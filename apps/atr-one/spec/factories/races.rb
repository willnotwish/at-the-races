FactoryBot.define do
  factory :race do
    name { "MyString" }
    description { "MyText" }
    race_delay { 1 }
    thread_count { 1 }
    lock_timeout { 1 }
    update_count { 1 }
  end
end
