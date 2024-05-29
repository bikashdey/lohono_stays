require 'rails_helper'

RSpec.describe CalendarEntry, type: :model do
  it { is_expected.to belong_to(:villa) }

  it { is_expected.to validate_presence_of(:date) }
  it { is_expected.to validate_presence_of(:rate) }
  it { is_expected.to validate_presence_of(:available) }
end
