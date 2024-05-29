FactoryBot.define do
  factory :calendar_entry do
    villa
    date { Date.today }
    rate { rand(30_000..50_000) }
    available { [true, false].sample }
  end
end