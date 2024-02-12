require 'rails_helper'
require 'faker'

RSpec.describe "Posts API", type: :request do
  
  describe 'GET /posts' do
  let!(:posts) { create_list(:post, 5) } 

  before { get '/posts' }

  it 'returns all posts' do
    expect(response).to have_http_status(200)
    expect(json).not_to be_empty
    expect(json.size).to eq(5)
  end
end

describe 'GET /posts/:id' do
  let!(:post) { create(:post) }

  before { get "/posts/#{post.id}" }

  it 'returns the post' do
    expect(response).to have_http_status(200)
    expect(json).not_to be_empty
    expect(json['id']).to eq(post.id)
  end
end

  describe 'POST /posts' do
    let(:valid_attributes) { { title: 'First post', content: 'First content' } }
  
    before { post '/posts', params: { post: valid_attributes } }
    
    context 'when the request is valid' do

    # before { get '/posts' }

    it 'create a new post' do
      expect{post '/posts', params: {post: valid_attributes}}.to change(Post, :count).by(1)

    end

    it 'has correct HTTP resonse status' do
      expect(response).to have_http_status(201)
    end

    it 'returns the created post' do
      expect(json['title']).to eq('First post')
      expect(json['content']).to eq('First content')
    end

     context 'when the request is invalid' do
      before {post '/posts', params: {post: { title: nil, content:'my content'}}}

       it 'shold include appropriate HTTP status code' do
        expect(response). to have_http_status(422)
       end

       it 'should include appropriate error messages response' do 
        expect(json['title']).to include("can't be blank")
  
       end

      end 

  end
end
describe 'PUT /posts/:id' do
  let!(:post) {create (:post)}

  context 'when the request is valid' do
    before { put "/posts/#{post.id}", params: { post: {title: 'Updated title', content: 'Updated content'}}}

    it 'update the post' do
      expect(json['title']).to eq('Updated title')
      expect(json['content']).to eq('Updated content')
    end

    it 'returns HTTP status 200' do
      expect(response).to have_http_status(200)
    end

  end
end

describe 'DELETE /posts/:id' do
  let!(:post) {create(:post)}
  before {delete "/posts/#{post.id}"}

  it 'returns status code 204' do
    expect(response).to have_http_status(204)
  end
end

    def json
      JSON.parse(response.body)
      # This is a helper method that parses the response body into JSON.
    end
  end
