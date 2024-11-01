require 'rails_helper'

RSpec.describe Races::CreateTransaction, type: :transaction do
  let(:transaction) { subject } # alias
  let(:month) { FactoryBot.create(:month, name: 'October 2024', code: 'oct24') }

  it { is_expected.to respond_to(:call) }

  context 'when supplied with valid race params' do
    let(:params) do
      {
        name: 'Test race',
        description: 'A test race',
        race_delay: 1,
        thread_count: 1,
        lock_timeout: 10,
        update_count: 10,
        month_code: month.code,
        counter_code: 'usage-to-date'
      }
    end

    it '#call returns a success' do
      expect(transaction.call(params)).to be_success
    end
  end
end
