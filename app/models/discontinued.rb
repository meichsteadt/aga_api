class Discontinued < ApplicationRecord
  def self.get_discontinued
    csv_text = File.read("discontinued.csv")
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      Discontinued.create(number: row['number'])
    end
  end
end
