FactoryBot.define do
  factory :blog do
    title { "Test Blog Post" }
    content { "This is a test blog post." }
    publication_at { Time.now }
    user
  end
end
