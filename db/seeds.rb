# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require "factory_bot_rails"

properties = FactoryBot.create_list(:property, 10)

completed_import_histories = FactoryBot.create_list(:import_history, 3, import_status: :completed)
_started_import_histories = FactoryBot.create_list(:import_history, 5, import_status: :started)
_failed_import_histories = FactoryBot.create_list(:import_history, 2, import_status: :failed)

completed_import_histories.each do |import_history|
  properties.sample(5).each do |property|
    FactoryBot.create(:import_histories_property, import_history:, property:)
  end
end
