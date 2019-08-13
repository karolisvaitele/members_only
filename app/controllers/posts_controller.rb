class PostsController < ApplicationController
    before_action :logged_in?, only:[:new, :create]

    def new
        @post = Post.new
    end

    def create
        @post = Post.new(post_params)
        if @post.save
            redirect_to posts_path
        else
            render 'new'
        end
    end

    def index
        @posts = Post.all
    end

    private
        def post_params
            params.require(:post).permit(:title, :body, :user_id)
        end
end
