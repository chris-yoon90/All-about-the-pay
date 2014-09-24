module ApplicationHelper
	def full_title(title) 
		default_title = "All-About-The-Pay"
		if(!title.empty?)
			default_title += " | #{title}"
		end
		default_title
	end
end
