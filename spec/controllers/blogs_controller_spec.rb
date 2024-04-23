require 'rails_helper'

RSpec.describe BlogsController, type: :controller do
  let(:user) { create(:user) }
  let(:invalid_attr) { { title: nil, content: 'This is a test post.', user_id: user.id } }

  before do
    sign_in user
  end

  describe 'GET #index' do
    it 'returns a success response' do
      get :index

      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new blog post' do
        params = { blog_post: attributes_for(:blog_post, title: 'Test Post', content: 'This is a test post.', user_id: user.id) }
        post :create, params: params

        expect(response).to have_http_status(:found)
      end
    end

    context 'with invalid params' do
      it 'does not create a new blog post' do
        expect {
          post :create, params: { blog_post: invalid_attr }
        }.to_not change(BlogPost, :count)
      end
    end
  end

  describe 'PUT #update' do
    let(:blog_post) { create(:blog_post) }

    context 'with valid parameters' do
      it 'updates the requested blog post' do
        put :update, params: { id: blog_post.to_param, blog_post: { title: 'New Title' } }

        blog_post.reload

        expect(blog_post.title).to eq('New Title')
      end
    end

    context 'with invalid parameters' do
      it 'does not update the blog post' do
        put :update, params: { id: blog_post.to_param, blog_post: { title: nil } }
        expect(blog_post.reload.title).not_to eq(nil)
      end
    end
  end

  describe 'GET #edit' do
    let(:blog_post) { create(:blog_post) }

    it 'returns a success response' do
      get :edit, params: { id: blog_post.to_param }
      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new
      expect(response).to be_successful
    end
  end
  
  describe 'DELETE #destroy' do
    let!(:blog_post) { create(:blog_post) }

    it 'destroys the requested blog post' do
      expect {
        delete :destroy, params: { id: blog_post.to_param }
      }.to change(BlogPost, :count).by(-1)
    end
  end
end
