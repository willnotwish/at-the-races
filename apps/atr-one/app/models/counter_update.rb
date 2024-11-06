class CounterUpdate < ActiveRecord::Base
  include AASM

  # If the counter has been processed (successfully or not), this will be set
  belongs_to :race_result, required: false

  validates :counter_code, :month_code, :value, presence: true

  enum aasm_state: { pending: 5, allocated: 10, processed: 15, failed: 20 }

  aasm timestamps: true, enum: true do
    state :pending, initial: true

    state :allocated
    state :processed
    state :failed

    event :allocate do
      transitions from: :pending, to: :allocated
    end

    event :process do
      transitions from: :allocated, to: :processed
    end

    event :fail do
      transitions from: :allocated, to: :failed
    end
  end
end
