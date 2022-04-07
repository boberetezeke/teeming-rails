module ApplicationHelper
  def breadcrumbs_html_safe
    @breadcrumbs = (@breadcrumbs || [])
    breadcrumbs_array = @breadcrumbs.map do |title, link|
      if link
        link_to(title, link)
      else
        title
      end
    end

    if @breadcrumbs_prefix_for_files
      "#{@breadcrumbs_prefix_for_files}: #{breadcrumbs_array.first} #{breadcrumbs_array[1..-1].join(' / ')}".html_safe
    else
      breadcrumbs_array.join(" | ").html_safe
    end
  end

  def job_headline(job)
    MembersMailer; Message; MessageRecipient
    job_info = YAML.load(job.handler)
    if job_info.is_a?(Delayed::PerformableMailer)
      email, from, to = job_info.args
      "email: #{email.subject} to '#{to.email}'"
    elsif job_info.job_data['job_class'] == "ImportJob"
      filename = job_info.job_data['arguments'][1]["original_filename"]
      "Importing Members from file: #{filename}"
    else
      "Unknown Job"
    end
  end

  def candidacies_names_and_emails(candidacies)
    candidacies.map{|c| "#{c.name}<#{c.email}>"}.join(", ")
  end

  def members_names_and_emails(members)
    members.map{|m| "#{m.name}<#{m.email}>"}.join(", ")
  end

  def ranked_choice_with_link(text)
    if m = /\[candidacy:(\d+)\]/.match(text)
      text.gsub(/\[candidacy:(\d+)\]/, "<a href=\"/candidacies/#{$1}\" target=\"_blank\">candidate questionnaire</a>").html_safe
    else
      text
    end
  end

  def breadcrumbs(*args)
    @breadcrumbs = args.map do |name_and_link|
      if name_and_link.is_a?(Array)
        if name_and_link.size == 2
          name_and_link
        else
          raise "name and link only expected in array: #{name_and_link}"
        end
      elsif name_and_link.is_a?(String)
        [name_and_link, nil]
      else
        raise "Expect either a two element array or a string for a breadcrumb: #{name_and_link.inspect}"
      end
    end
  end

  def can?(user, action, klass_or_object)
    Pundit.policy(user, klass_or_object).send("#{action}?")
  end

  def bylaws_text
    "Bylaws " * 100
  end

  def event_date_and_time_str(datetime)
    "On " + datetime.strftime("%A, the #{datetime.day.ordinalize} of %B, %Y") + ", at #{datetime.strftime('%I:%M%P')}"
  end

  def voting_date_and_time_str(datetime)
    date_and_time_str(datetime)
  end

  def officer_term_and_reasons(officer_assignment)
    if officer_assignment.reason_for_start
      reason_for_start =  OfficerAssignment::START_REASONS_HASH.invert[officer_assignment.reason_for_start]
    else
      reason_for_start = "reason for start not set"
    end

    if officer_assignment.reason_for_end
      reason_for_end =  OfficerAssignment::END_REASONS_HASH.invert[officer_assignment.reason_for_end]
    else
      reason_for_end = "reason for end not set"
    end

    if officer_assignment.start_date
      start_date = date_str(officer_assignment.start_date)
    else
      start_date = "start date not set"
    end

    if officer_assignment.start_date
      start_date = date_str(officer_assignment.start_date)
    else
      start_date = "start date not set"
    end

    if officer_assignment.end_date
      end_date = date_str(officer_assignment.end_date)
    else
      end_date = "end date not set"
    end

    "<strong>Starts</strong>: #{start_date} - (#{reason_for_start})<br/><strong>Ends</strong>: #{end_date} (#{reason_for_end})".html_safe
  end

  def date_str(date)
    return "" unless date
    date.strftime("%m/%d/%Y")
  end

  def date_and_time_str(datetime)
    return "" unless datetime
    Time.zone.utc_to_local(datetime.utc).strftime("%m/%d/%Y %I:%M%P")
  end

  def before_and_current_sections_for_question(question)
    section = question.questionnaire_section

    sections = []
    order_index = section.order_index - 1
    while order_index >= 1
      before_section = section.questionnaire.questionnaire_sections.where(order_index: order_index).first
      break if before_section.questions.count > 0

      sections << before_section
      order_index -= 1
    end

    sections = sections.reverse

    sections += [section]

    sections.each { |section| yield section }
  end


  def tab_class(active_tab, tab_name)
    if active_tab == tab_name
      {class: 'active'}
    else
      {}
    end
  end

  def empty_after_sections_for_question(question)
    return if question.order_index < question.questionnaire_section.questions.count

    section = question.questionnaire_section
    total_sections = section.questionnaire.questionnaire_sections.count

    order_index = section.order_index + 1
    after_sections = []

    while order_index <= total_sections
      after_section = section.questionnaire.questionnaire_sections.where(order_index: order_index).first
      if after_section.questions.count > 0
        after_sections = []
        break
      else
        after_sections << after_section
      end

      order_index += 1
    end

    after_sections.each { |section| yield section }
  end

  def in_formtastic(html)
    html.gsub(/<(p|ul|li)>/) { "<#{$1} class=\"in-formtastic\">" }
  end

  def group_by_questions(answers)
    questions = {}
    answers.each do |answer|
      questions[answer.question] ||= []
      questions[answer.question].push(answer)
    end
    questions
  end

  def is_current_user?(member, current_user)
    member.user && member.user == current_user
  end

  def member_index_tags(member)
    general_tags = member.general_tags.map(&:name)
    subcaucus_tags = member.subcaucuses.map(&:name)
    source_tags = member.sources.map(&:name)
    district_tags = member.districts.map(&:name)

    non_empty_tag_groups = [["", general_tags], ["districts", district_tags], ["caucuses", subcaucus_tags], ["sources", source_tags]].reject{|title, tags| tags.empty?}
    non_empty_tag_groups.map{|title, tags| (title.empty? ? "" : "<strong>#{title}: </strong>".html_safe) + truncate(sanitize(tags.join(", "), length: 25))}.join("<br/>").html_safe
  end

  def percent(part, whole)
    "%.2f" % [(part.to_f / whole.to_f) * 100]
  end

  def when_to_meet_date(day)
    (Date.today + day).to_s
  end

  def when_to_meet_hour(hour)
    hour = (9 + hour) % 12
    hour = 12 if hour == 0
    "#{hour}:00 #{hour >= 3 ? 'pm' : 'am'}"
  end
end