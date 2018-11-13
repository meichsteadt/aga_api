require 'csv'
class CheckCsv
  def check_csv
    csv = CSV.read("2018_new_pricebook.csv", headers: true)
    book = {}
    pis = ProductItem.pluck(:id, :number, :price)
    csv.each do |row|
      row[" New Price "] ? np = row[" New Price "].remove("$", ",").strip.to_f.ceil : np = nil
      row[" Price "] ? p = row[" Price "].remove("$", ",").strip.to_f.ceil : p = nil
      book[row["Item#"]] = [np, p]
    end

    CSV.open("check_prices.csv", "w") do |row|
      row << ["id", "number", "kiosk_price", "new_price", "old_price", "diff"]
      pis.each do |pi|
        if book[pi[1]] && book[pi[1]][0]
          diff = (pi[2] - book[pi[1]][0])
        else
           diff = pi[2]
        end
        row << [pi[0], pi[1], pi[2], book[pi[1]], diff].flatten(1)
      end
    end
  end
end
