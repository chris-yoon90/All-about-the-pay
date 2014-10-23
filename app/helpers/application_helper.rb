module ApplicationHelper

	WillPaginate::ViewHelpers.pagination_options[:next_label] = ">>"
	WillPaginate::ViewHelpers.pagination_options[:previous_label] = "<<"

	def full_title(title) 
		default_title = "All-About-The-Pay"
		unless(title.empty?)
			default_title += " | #{title}"
		end
		default_title
	end
end
