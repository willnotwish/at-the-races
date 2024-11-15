require 'rails_helper'

class DummyMonitor
  def call(id, payload); end # does nothing
end

RSpec.describe DatabaseLockingProcessor, type: :processor do
  let(:processor) { subject } # alias
  let(:monitor) { DummyMonitor.new }

  context 'when a month - October 2024 - exists' do
    let(:month_code) { 'oct24' }
    let(:value) { 100 }

    before do
      FactoryBot.create(:month, code: month_code)
    end
    
    context 'when no counter exists' do
      let(:update) do
        FactoryBot.create(:counter_update, counter_code: 'foo', month_code: month_code, value: value)
      end

      it '#call creates a new counter' do
        expect { processor.call(update: update, monitor: monitor) }.to change(Counter, :count).by(1)
      end

      describe 'the counter created' do
        before do
          processor.call(update: update, monitor: monitor)
        end

        it 'has the updated value' do
          month = Month.find_by(code: update.month_code)
          counter = Counter.find_by(code: update.counter_code, month: month)
          expect(counter.value).to eq(value)
        end
      end
    end

    context 'when a counter exists' do
      let(:month) { Month.find_by(code: month_code) }

      let(:update) do
        FactoryBot.create(:counter_update, counter_code: 'foo', month_code: month_code, value: value)
      end

      before do
        FactoryBot.create(:counter, month: month, value: 50, code: update.counter_code)
      end

      it '#call does not create a new counter' do
        expect { processor.call(update: update, monitor: monitor) }.not_to change(Counter, :count)
      end

      it '#call updates the existing counter' do
        counter = Counter.find_by(code: update.counter_code, month: month)
        expect { processor.call(update: update, monitor: monitor) }.to change { counter.reload.value }.from(50).to(value)
      end
    end
  end 
end
