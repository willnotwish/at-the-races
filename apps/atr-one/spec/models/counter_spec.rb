require 'rails_helper'

RSpec.describe Counter, type: :model do
  it { is_expected.to have_db_column(:code) }
  it { is_expected.to belong_to(:month) }
end
