require 'rails_helper'

RSpec.describe SingleThreadedDriver, type: :driver do
  let(:driver) { subject } # alias
  let(:count) { 100 }
  let(:delta) { 10 }

  before do
    FactoryBot.create(:month, code: 'oct24', name: 'October 2024')
  end

  context 'when 100 updates exist for October 2024 in increments of 10' do
    let(:updates) do
      FactoryBot.create_list(:counter_update, count, counter_code: 'foo', month_code: 'oct24') do |update, index|
        update.value = (index + 1) * delta
      end
    end

    context 'with a simple processor' do
      let(:processor) { SimpleProcessor.new }

      it '#call creates only one counter' do
        expect { driver.call(updates: updates, processor: processor) }.to(
          change(Counter, :count).from(0).to(1)
        )
      end
  
      describe 'the counter created' do
        it 'has the correct accumulated value' do
          driver.call(updates: updates, processor: processor)
          counter = Counter.last
          expect(counter.value).to eq(count * delta)
        end
      end
    end 
  end
end
