class PostsController < ApplicationController
    def home
        redirect_to "/posts"
    end

    def index
        #post = Post.new(name: 'kazz2', title: "Wow", content: '>_<', edit_pass: "ao2Mkw")
        #post.save
        @posts = Post.where(parent_post_id: nil).where(is_hide: false).order(id: :desc)
    end

    def read
        @post = Post.find(params[:id])
        @replies = Post.where(parent_post_id: params[:id]).order(id: :desc)
    end

    def edit
        id = params[:id]
        @pass = params[:input_edit_pass]
        @post = Post.find(id)

        if @pass != @post.edit_pass
            flash[:notice] = "edit_pass_auth_error"
            redirect_to "/posts/" + id.to_s
        else
            @ok = "OK"
        end
    end

    def update
        id = params[:id]
        name = params[:name]
        title = params[:title]
        content = params[:content]
        image = params[:image]

        session[:name] = name

        Post.where(id: id).update(
            name: name,
            title: title,
            content: content
        )

        redirect_to "/posts/" + id.to_s
    end

    def new
        
    end

    def create
        name = params[:name]
        title = params[:title]
        content = params[:content]
        edit_pass = params[:edit_pass]
        image = params[:image]

        session[:name] = name
        session[:edit_pass] = edit_pass

        post = Post.new(
            name: name,
            title: title,
            content: content,
            edit_pass: edit_pass
        )

        if post.save
            if image
                file_name = post.id.to_s + ".png"
                File.binwrite("public/images/" + file_name, image.read)
            end
            flash[:notice] = "create_post_success"
            redirect_to "/posts/" + post.id.to_s

        else
            flash[:notice] = "create_post_faild"
            redirect_back(fallback_location: "/posts")
        end
    end

    def reply
        post = Post.new(
            name: params[:name],
            parent_post_id: params[:id],
            content: params[:content],
            edit_pass: params[:edit_pass]
        )
        post.save

        flash[:notice] = "reply_success"
        redirect_to "/posts/" + params[:id]
    end
end
