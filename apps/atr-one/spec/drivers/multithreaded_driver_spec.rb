require 'rails_helper'

RSpec.describe MultithreadedDriver, type: :driver do
  self.use_transactional_fixtures = false   # turn off Rspec wrapping examples in transactions

  let(:driver) { subject } # alias
  let(:count) { 20 }
  let(:delta) { 1 }

  before do
    Counter.delete_all
    Month.delete_all
    CounterUpdate.delete_all
    FactoryBot.create(:month, code: 'oct24', name: 'October 2024')
  end

  context 'when updates exist relating to October 2024' do
    let(:updates) do
      FactoryBot.create_list(:counter_update, count, counter_code: 'foo', month_code: 'oct24') do |update, index|
        update.value = (index + 1) * delta
      end
    end

    shared_examples 'it creates only one counter' do
      it do
        expect do driver.call(
          updates: updates, processor: processor, thread_count: thread_count, **processor_opts
        )
        end.to(change(Counter, :count).from(0).to(1))
      end
  
      # describe 'the counter created' do
      #   it 'has the correct accumulated value' do
      #     driver.call(updates: updates, processor: processor, thread_count: thread_count)
      #     counter = Counter.last
      #     expect(counter.value).to eq(count * delta)
      #   end
      # end
    end

    context 'with a simple processor' do
      let(:processor) { SimpleProcessor.new }
      let(:processor_opts) { {} }
      let(:thread_count) { 1 }

      it_behaves_like 'it creates only one counter'
    end 

    context 'with a database locking processor and two threads' do
      let(:processor) { DatabaseLockingProcessor.new }

      let(:race_delay) do
        return 1 if ENV['RACE_DELAY'].blank?

        ENV['RACE_DELAY'].to_i
      end

      let(:lock_timeout) do
        return 10 if ENV['LOCK_TIMEOUT'].blank?

        ENV['LOCK_TIMEOUT'].to_i
      end

      let(:thread_count) do
        return 2 if ENV['THREAD_COUNT'].blank?

        ENV['THREAD_COUNT'].to_i
      end

      let(:processor_opts) do
        {
          race_delay: race_delay,
          lock_timeout: lock_timeout
        }
      end

      it_behaves_like 'it creates only one counter'
    end
  end
end
