class MembersController < ApplicationController
  before_action :authenticate_user!

  before_action :set_chapter
  before_action :set_context_params
  before_action :set_member, only: [:show, :edit, :update, :destroy]

  def index
    authorize_with_args Member, @context_params
    @chapter = Chapter.find(params[:chapter_id])

    @members = policy_scope(Member).includes(:user).references(:user)

    @restrict_by_chapter = (params[:restrict_by_chapter] == "true")

    @title = "Members"

    @member_type = params[:member_type]
    @source = params[:source]
    @subcaucus = params[:subcaucus]
    @district = params[:district]
    @general_tag = params[:general_tag]
    @search = params[:search]
    @attr_type = params[:attr_type]

    @members = Member.filtered(@chapter, @members, @restrict_by_chapter,
                               @member_type, @source, @subcaucus, @district,
                               @general_tag, @search, @attr_type)

    @members_ids = @members.pluck(:id)

    @members = @members.paginate(page: params[:page], per_page: params[:per_page])

    @export_params = {
      chapter: @chapter
    }
    [:member_type, :source, :subcaucus, :district, :general_tag, :search, :attr_type].each do |sym|
      @export_params[sym] = instance_variable_get("@#{sym}")
    end

    breadcrumbs members_breadcrumbs, @title
  end

  def select2
    @chapter = Chapter.find(params[:chapter_id])
    if params[:term].present?
      @members = @chapter.members.filtered_by_string(params[:term]).limit(50)
    else
      @members = []
    end
    respond_to do |format|
      format.json { render(json: {results: @members.map{|member| {text: member.name, id: member.id}}}.to_json) }
    end
  end

  def new
    @chapter = Chapter.find(params[:chapter_id])
    @member = Member.new
  end

  def create
    @member = Member.new(member_params)
    @member.chapter = Chapter.find(params[:chapter_id])
    @member.save
    handle_tags(member_tag_params)

    respond_with(@member)
  end

  def show
    @user = @member.user

    breadcrumbs members_breadcrumbs, @member.name
  end

  def edit
    breadcrumbs members_breadcrumbs, "Edit #{@member.name}"
  end

  def update
    @member.update(member_params)
    handle_tags(member_tag_params)
    @member.user.update_role_from_roles(current_user.selected_account) if @member.user
    respond_with(@member)
  end

  def export
    authorize_with_args Member, @context_params

    chapter = Chapter.find(params[:chapter_id])
    members = policy_scope(Member).includes(:user).references(:user)
    restrict_by_chapter = (params[:restrict_by_chapter] == "true")

    members = Member.filtered(chapter, members, restrict_by_chapter,
                              params[:member_type], params[:source], params[:subcaucus], params[:district],
                              params[:general_tag], params[:search], params[:attr_type])
    send_data Member.export(members)
  end

  def handle_tags(params)
    self.class.handle_tags(@member, params)
  end

  def self.handle_tags(member, params)
    tag_attribute_names = [:general_tags, :subcaucuses, :districts, :sources]
    tag_attribute_names.each do |tag_attribute_name|
      handle_tag(member, tag_attribute_name, params)
    end
  end

  def self.handle_tag(member, tag_attribute_name, params)
    singular_tag_name = tag_attribute_name.to_s.singularize
    tags = member.send(tag_attribute_name).map(&:name)
    new_tags = params["#{singular_tag_name}_ids"].select(&:present?).map do |id|
      tag = ActsAsTaggableOn::Tag.find_by_id(id)
      tag ? tag.name : id
    end

    tags_to_remove = tags - new_tags
    tags_to_insert = new_tags - tags

    puts "tags: #{tags}"
    puts "new_tags: #{new_tags}"
    puts "tags_to_remove: #{tags_to_remove}"
    puts "tags_to_insert: #{tags_to_insert}"

    tags_to_remove.each do |tag_to_remove|
      puts "removing tag: #{tag_to_remove}"
      member.send("#{tag_attribute_name.to_s.singularize}_list").remove(tag_to_remove)
    end

    tags_to_insert.each do |tag_to_insert|
      puts "inserting tag: #{tag_to_insert}"
      member.send("#{tag_attribute_name.to_s.singularize}_list").add(tag_to_insert)
    end

    member.save
  end

  def destroy
    @member.destroy

    redirect_to chapter_members_path(@member.chapter)
  end

  def import
    authorize Member, :import?

    if params[:import_file]
      importer = Importer.create(filename:params[:import_file].tempfile.path,
                                 original_filename: params[:import_file].original_filename,
                                 content_type: params[:import_file].content_type,
                                 import_file: params[:import_file])

      title_line = CSV.open(params[:import_file].tempfile.path).first
      title_line = title_line.map(&:strip)
      if title_line == Member::DATABANK_EXPORT_COLUMNS
        data = nil
        t = Tempfile.new("import-file")
        File.open(params[:import_file].tempfile.path) {|f| data = f.read; t.write(data) }
        t.close
        ImportJob.perform_later(current_user.id, importer.id)
        flash[:notice] = "User import started, you will be notified by email when it is finished: '#{data}'"
      else
        flash[:alert] = "import file not in correct format"
      end
    else
      flash[:alert] = "No file selected to import"
    end

    redirect_to chapter_members_path(@chapter)
  end

  private

  def member_params
    params.require(:member).permit(*self.class.permitted_attributes)
  end

  def member_tag_params
    params.require(:member).permit(self.class.permitted_tag_attributes)
  end

  def self.permitted_attributes
    [ :email, :notes, :first_name, :middle_initial, :last_name,
       :mobile_phone, :work_phone, :home_phone,
       :address_1, :address_2, :city, :state, :zip,
       message_controls_attributes: [:id] + MessageControlsController.permitted_attributes,
       user_attributes: [:id, {role_ids: [], officer_ids: []}]
    ]
  end

  def self.permitted_tag_attributes
    {general_tag_ids: [], subcaucus_ids: [], district_ids: [], source_ids: []}
  end

  def set_member
    @member = Member.find(params[:id])
    authorize @member
  end

  def set_chapter
    @chapter = Chapter.find(params[:chapter_id]) if params[:chapter_id]
  end

  def set_context_params
    @context_params = @chapter ? { chapter_id: @chapter.id } : {}
  end

  def members_breadcrumbs
    if @member
      ["Members", @member.chapter ? chapter_members_path(@member.chapter) :
                    (@member.potential_chapter ?
                       chapter_members_path(@member.potential_chapter) :
                       chapter_members_path(Chapter.state_wide))
      ]
    else
      [@chapter.name, chapter_path(@chapter)]
    end
  end
end