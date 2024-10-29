require 'rails_helper'

RSpec.describe Month, type: :model do
  it { is_expected.to have_db_column(:name) }
  it { is_expected.to have_db_column(:code) }

  it { is_expected.to have_many(:counters) }
end
