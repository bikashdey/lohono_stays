class CalendarEntry < ApplicationRecord
  belongs_to :villa
  validates :date, :rate, :available, presence: true
end
