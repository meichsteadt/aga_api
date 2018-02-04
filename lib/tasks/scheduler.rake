task :update_inventory => :environment do
  ProductItem.get_inventory
  puts 'done'
end
