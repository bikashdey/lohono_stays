FactoryBot.define do
  factory :villa do
    name { "Test Villa" }

    after(:create) do |villa|
      (Date.new(2021, 1, 1)..Date.new(2021, 12, 31)).each do |date|
        create(:calendar_entry, villa: villa, date: date, available: true)
      end
    end
  end
end