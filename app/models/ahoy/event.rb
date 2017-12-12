module Ahoy
  class Event < ActiveRecord::Base
    include Ahoy::Properties

    self.table_name = "ahoy_events"

    belongs_to :visit
    belongs_to :user, optional: true

    def self.seed
      events = []
      Ahoy::Event.all.each do |event|
        events << JSON.parse(event.to_json)
      end
    end
  end
end
