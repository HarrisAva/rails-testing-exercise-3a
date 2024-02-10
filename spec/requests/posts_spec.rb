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
      before {post '/posts', params: {post: { content:'my content'}}}
      #  it 'is invalid post without a title' do
      #   expect(post).to be_invalid
      #  end

       it 'return status code 422' do
        expect(response). to have_http_status(422)
       end
      end
    end
  end

    def json
      JSON.parse(response.body)
      # This is a helper method that parses the response body into JSON.
    end
  end
