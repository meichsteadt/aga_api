class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.seed
    seeds = {}
    seeds['emails'] = Email.seed
    seeds['visits'] = Visit.seed
    seeds['events'] = Ahoy::Event.seed
    seeds['users'] = User.seed
    seeds
  end
end
