class PostsController < ApplicationController
    # PVカウントのgem
    impressionist :actions => [:index, :read]

    CATEGORY_BADGE_COLORS = {
        "1" => "warning",
        "2" => "info",
        "3" => "danger",
        "4" => "success"
    }

    def home
        # homeは保留
        redirect_to "/posts"
    end

    def index
        @category_badge_colors = CATEGORY_BADGE_COLORS
        @posts = Post.where(parent_post_id: nil).where(is_hide: false).order(id: :desc)   
    end

    def read
        @category_badge_colors = CATEGORY_BADGE_COLORS
        @post = Post.find(params[:id])
        @replies = Post.where(parent_post_id: params[:id]).order(id: :desc)
        # PVカウント
        impressionist(@post, nil, unique: [:session_hash])
    end

    def edit
        id = params[:id]
        @pass = params[:input_edit_pass]
        @post = Post.find(id)

        # 編集パスワード判定
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
        categolies = Category.all()

        @category_option = []
        for category in categolies do
            @category_option.push([category.name, category.id.to_s])
        end
    end

    def create
        name = params[:name]
        title = params[:title]
        category = params[:category]
        content = params[:content]
        edit_pass = params[:edit_pass]
        image = params[:image]

        session[:name] = name
        session[:edit_pass] = edit_pass

        post = Post.new(
            name: name,
            title: title,
            category_id: category,
            content: content,
            edit_pass: edit_pass,
            reply_count: 0
        )

        if post.save
            if image
                # 画像アップロード
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
            edit_pass: params[:edit_pass],
            reply_count: 0,
            category_id: 99
        )
        logger.debug("st")
        post.save!
        logger.debug("en")

        # 返信数インクリメント(パフォーマンス考慮)
        Post.find(post.parent_post_id).increment(:reply_count).save

        flash[:notice] = "reply_success"
        redirect_to "/posts/" + params[:id]
    end
end
