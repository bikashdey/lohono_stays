require 'rails_helper'

RSpec.describe Villa, type: :model do
  it { is_expected.to have_many(:calendar_entries).dependent(:destroy) }
end