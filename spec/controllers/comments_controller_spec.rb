require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:blog_post) { create(:blog_post, user: user) }

  before do
    sign_in user
  end

  describe 'POST #create' do
    context 'with valid params' do
      let(:valid_params) { { blog_post_id: blog_post.id, comment: { content: 'This is a test comment.' } } }

      it "creates a new comment" do
        expect {
          post :create, params: valid_params
        }.to change(Comment, :count).by(1)
      end
    end

    context 'with invalid params' do
      let(:invalid_params) { { content: nil, user_id: user.id, blog_post_id: blog_post.id } }

      it 'does not create a new comment' do
        expect {
          post :create, params: { blog_post_id: blog_post.id, comment: invalid_params }
        }.to_not change(Comment, :count)
      end
    end
  end

  describe 'PATCH #update' do
    let(:comment) { create(:comment, user_id: user.id, blog_post_id: blog_post.id) }

    context "with valid params" do
      let(:valid_params) { { id: comment.id, blog_post_id: blog_post.id, comment: { content: "Updated content" } } }

      it "updates the comment" do
        patch :update, params: valid_params
        comment.reload
        expect(comment.content).to eq("Updated content")
      end

      it "responds with turbo_stream" do
        patch :update, params: valid_params, format: :turbo_stream
        expect(response).to have_http_status(:success)
      end
    end

    context "with invalid params" do
      let(:invalid_params) { { id: comment.id, blog_post_id: blog_post.id, comment: { content: "" } } }

      it "does not update the comment" do
        expect {
          patch :update, params: invalid_params
          comment.reload
        }.not_to change(comment, :content)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:comment) { create(:comment, user_id: user.id, blog_post_id: blog_post.id) }

    it "destroys the comment" do
      expect {
        delete :destroy, params: { id: comment.id, blog_post_id: blog_post.id }
      }.to change(Comment, :count).by(-1)
    end

    it "responds with turbo_stream" do
      delete :destroy, params: { id: comment.id, blog_post_id: blog_post.id }, format: :turbo_stream
      expect(response).to have_http_status(:success)
    end
  end
end
