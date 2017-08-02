module ApplicationHelper
  def breadcrumbs_html_safe
    nil
  end

  def bylaws_text
    "Bylaws " * 100
  end

  def event_date_and_time_str(datetime)
    "On " + datetime.strftime("%A, the #{datetime.day.ordinalize} of %B, %Y") + ", at #{datetime.strftime('%I:%M%P')}"
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
end