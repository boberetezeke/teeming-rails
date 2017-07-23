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
end