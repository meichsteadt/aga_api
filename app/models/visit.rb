class Visit < ActiveRecord::Base
  has_many :ahoy_events, class_name: "Ahoy::Event"
  belongs_to :user, optional: true
  def self.seed
    visits = []
    Visit.all.each do |visit|
      visits << JSON.parse(visit.to_json)
    end
  end
end
