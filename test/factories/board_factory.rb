FactoryBot.define do
  factory :board do
    name       { "test name" }
    email      { "test@email.com" }
    width      { 5 }
    height     { 5 }
    mine_count { 10 }
  end
end
