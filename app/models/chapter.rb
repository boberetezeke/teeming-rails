class Chapter < MemberGroup
  belongs_to :account

  CHAPTER_TYPE_IN_FORMATION = 'formation'
  CHAPTER_TYPE_AFFILIATE = 'affiliate'
  CHAPTER_TYPE_RECOGNIZED = 'recognized'
  CHAPTER_TYPE_INDEPENDENT = 'independent'

  CHAPTER_TYPES_HASH = {
     'In Formation' => CHAPTER_TYPE_IN_FORMATION,
     'Affiliate' => CHAPTER_TYPE_AFFILIATE,
     'Recognized' => CHAPTER_TYPE_RECOGNIZED,
     "Independent" => CHAPTER_TYPE_INDEPENDENT
  }

  has_one :skills_questionnaire, as: :questionnairable, class_name: 'Questionnaire'

  scope :local_chapters, ->{ where(is_state_wide: false) }
  scope :in_order, ->{ order('name asc')}

  def self.state_wide
    Chapter.find_by_is_state_wide(true)
  end

  def chapter_hash_for_profile

  end

  def self.collection_hash
    Hash[Chapter.all.map do |chapter|
      chapter.is_state_wide ?
        [chapter.name, chapter.id] :
        ["#{chapter.name} - (#{chapter.chapter_type_str})", chapter.id]
    end]
  end

  def chapter_type_str
    CHAPTER_TYPES_HASH.invert[chapter_type]
  end

  def affiliate?
    chapter_type == CHAPTER_TYPE_AFFILIATE || chapter_type == CHAPTER_TYPE_IN_FORMATION
  end

  def active_officer_assignments
    officers.joins(:officer_assignments).merge(OfficerAssignment.active)
  end

  def boundaries
    return nil unless boundaries_description_yml

    ChapterBoundaries.new(YAML.load(StringIO.new(boundaries_description_yml)).map do |boundary_hash|
      boundary_type = boundary_hash[:type]
      if ChapterBoundary::EAST_WEST_BOUNDARIES.include?(boundary_type)
        ChapterBoundary.new(boundary_type, x: boundary_hash[:x])
      else
        ChapterBoundary.new(boundary_type,
                            x1: boundary_hash[:x1],
                            y1: boundary_hash[:y1],
                            x2: boundary_hash[:x2],
                            y2: boundary_hash[:y2])
      end
    end)
  end

  def cities
    return [] unless boundaries
    return @cities if @cities

    @cities = []
    Geocoding::CITIES.to_a.each do |name, values|
      if boundaries.within_boundaries?(values[:lon], values[:lat])
        @cities.push(name)
      end
    end
    @cities
  end
end