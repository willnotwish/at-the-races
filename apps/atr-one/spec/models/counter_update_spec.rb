require 'rails_helper'

RSpec.describe CounterUpdate, type: :model do
  subject { described_class.new(counter_code: 'foo-counter', month_code: 'bar-month', value: 1) }
  let(:update) { subject } # alias

  it { is_expected.to have_db_column(:counter_code) }
  it { is_expected.to have_db_column(:month_code) }
  it { is_expected.to have_db_column(:value) }

  it { is_expected.to validate_presence_of(:counter_code) }
  it { is_expected.to validate_presence_of(:month_code) }
  it { is_expected.to validate_presence_of(:value) }

  it { is_expected.to be_valid }

  describe 'transitions' do
    it { is_expected.to be_pending }

    context 'when allocated' do
      before do
        update.allocate!
      end

      it { is_expected.to be_allocated }
      it 'allocated_at timestamp is set' do
        expect(update.allocated_at).to be_present
      end

      it 'can be processed' do
        update.process!
        expect(update).to be_processed
        expect(update.processed_at).to be_present
      end

      it 'can be a failure' do
        update.fail!
        expect(update).to be_failed
        expect(update.failed_at).to be_present
      end
    end
  end
end
