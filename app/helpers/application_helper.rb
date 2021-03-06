module ApplicationHelper

	# Returns the full title on a per-page basis.
  def full_title(page_title = '')
    base_title = "Fringr"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end
end

# Override the default datepicker

module ActionView
  module Helpers
    class FormBuilder 
      def datetime_select(method, options = {}, html_options = {})
        existing_time = @object.send(method) 
        formatted_time = existing_time.to_time.strftime("%F %I:%M %p") if existing_time.present?
        @template.content_tag(:div, class: "input-group") do    
          text_field(method, value: formatted_time, class: "form-control datetimepicker1", placeholder: html_options[:placeholder], :"data-date-format" => "YYYY-MM-DD hh:mm A")
        end
      end
    end
  end
end