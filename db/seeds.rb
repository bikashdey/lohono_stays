# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'date'

Villa.destroy_all
CalendarEntry.destroy_all

50.times do |i|
  villa = Villa.create(name: "Villa ##{i + 1}")

  (Date.new(2021, 1, 1)..Date.new(2021, 12, 31)).each do |date|
    villa.calendar_entries.create(
      date: date,
      rate: rand(30_000..50_000),
      available: [true, false].sample
    )
  end
end
