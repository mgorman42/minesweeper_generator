FactoryBot.define do
  factory :tile do
    board   { FactoryBot.build(:board) }
    x       { 0 }
    y       { 0 }
    is_mine { false }
  end
end
