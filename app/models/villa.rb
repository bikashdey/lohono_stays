class Villa < ApplicationRecord
  has_many :calendar_entries, dependent: :destroy
end
