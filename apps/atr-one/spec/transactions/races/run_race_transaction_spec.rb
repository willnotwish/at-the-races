require 'rails_helper'

RSpec.describe Races::RunRaceTransaction, type: :transaction do
  let(:transaction) { subject } # alias
  let(:month) { FactoryBot.create(:month, name: 'October 2024', code: 'oct24') }

  it { is_expected.to respond_to(:call) }

  context 'when supplied with a valid race id' do
    let(:race) do
      FactoryBot.create(
        :race,
        name: 'Test race',
        description: 'A test race',
        race_delay: 1,
        thread_count: 1,
        lock_timeout: 10,
        update_count: 10,
        month_code: month.code,
        counter_code: 'usage-to-date',
        processor: 'simple_processor',
        driver: 'single_threaded_driver'
      )
    end

    it '#call returns a success' do
      expect(transaction.call(race.id)).to be_success
    end
  end
end
