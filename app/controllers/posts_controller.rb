class PostsController < ApplicationController
    def index
        #post = Post.new(name: 'kazz2', title: "Wow", content: '>_<', edit_pass: "ao2Mkw")
        #post.save
        @posts = Post.all
    end

    def read
        @post = Post.find(params[:id])
    end

    def edit
        id = params[:id]
        @pass = params[:input_edit_pass]
        @post = Post.find(id)

        if @pass != @post.edit_pass
            flash[:error] = true
            redirect_to "/posts/" + id.to_s
        else
            @ok = "OK"
        end
    end

    def create
        
    end
end
