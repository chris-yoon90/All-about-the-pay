module ApplicationHelper

	WillPaginate::ViewHelpers.pagination_options[:next_label] = ">>"
	WillPaginate::ViewHelpers.pagination_options[:previous_label] = "<<"
	WillPaginate.per_page = 10

	def full_title(title) 
		default_title = "PayMeNow"
		unless(title.empty?)
			default_title += " | #{title}"
		end
		default_title
	end
end
