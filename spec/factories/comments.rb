FactoryBot.define do
  factory :comment do
    content { "First Comment" }
    user
    blog_post
  end
end
