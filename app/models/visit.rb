class Visit < ActiveRecord::Base
  has_many :ahoy_events, class_name: "Ahoy::Event"
  belongs_to :user, optional: true
  def self.seed
    visits = []
    Visit.all.each do |visit|
      visits << JSON.parse(visit.to_json)
    end
  end

  def self.write
    @output = {}
    Visit.all.each do |visit|
      @output[visit.id] = visit.ahoy_events.order(time: :asc)
    end
    File.open('visit.json', 'w') {|file| file.write(@output.to_json)}
  end
end
