require 'rails_helper'

RSpec.describe CounterUpdate, type: :model do
  it { is_expected.to have_db_column(:counter_code) }
  it { is_expected.to have_db_column(:month_code) }
  it { is_expected.to have_db_column(:value) }

  it { is_expected.to validate_presence_of(:counter_code) }
  it { is_expected.to validate_presence_of(:month_code) }
  it { is_expected.to validate_presence_of(:value) }
end
