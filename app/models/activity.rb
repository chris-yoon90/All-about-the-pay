class Activity < ActiveRecord::Base
	validates :name, presence: true, 
						length: { minimum: 2, maximum: 50 }

	def self.search(search)
		if search
			self.where("name LIKE ?", "%#{search}%")
		else
			self.all
		end
	end
end
