class PostsController < ApplicationController
    before_action :set_post, only: [:show, :update, :destroy]

    def index
        render json: Post.all
    end

    def show
        # post = Post.find(params[:id])

        if @post
            render json: @post, status: :ok
        else
            render json: {message: 'not found'}, status: :not_found
        end
    end

    def create
        post = Post.new(post_params)
        if post.save
          render json: post, status: :created
        else
          render json: post.errors, status: :unprocessable_entity
        end
      end

    def update
        # post = Post.find(params[:id])

        if @post.update(post_params)
            render json: @post, status: :ok
        else
            render json: @post.errors, status: :unprocessable_entity
        end

    end

    def destroy
        # post = Post.find(params[:id])

        if @post.destroy
            # return a response with only headers and no body
            head :no_content
        else
            render json: post.errors, status: :unproceesable_entity
        end
    end
    
    private
    
    def post_params
        params.require(:post).permit(:title, :content)
      end

      # ****set post variable for show, update and destroy, remove post = Post.find(params[:id]) and replace with @post.destroy
    def set_post
        @post = Post.find(params[:id])
    end
end