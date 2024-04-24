FactoryBot.define do
  factory :comment do
    content { "First Comment" }
    user
    blog
  end
end
