FactoryBot.define do
  factory :drive_config do
    name { "MyString" }
    description { "MyText" }
    thread_count { 1 }
    race_delay { 1 }
    lock_timeout { 1 }
  end
end
