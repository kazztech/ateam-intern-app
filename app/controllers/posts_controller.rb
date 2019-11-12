class PostsController < ApplicationController
    # PVカウントのgem
    impressionist :actions => [:index, :read]

    def home
        # homeは保留
        redirect_to "/posts"
    end

    def index
        # 絞り込み検索のカテゴリ表示
        categolies = Category.all()
        @category_option = [["未選択", ""]]
        for category in categolies do
            @category_option.push([category.name, category.id.to_s])
        end

        # 取得
        @posts = Post
            .where(parent_post_id: nil)
            .where(is_hide: false)
        
        # カテゴリ検索ありの場合
        if params[:category] && params[:category] != ""
            @posts = @posts.where(category_id: params[:category])
        end

        # キーワード検索ありの場合
        if params[:keyword] && params[:keyword] != ""
            @posts = @posts.where("title LIKE ?", "%" + params[:keyword] + "%")
        end

        # ソート順決定
        if params[:gender] && params[:gender] != ""
            if params[:gender] == "date"
                @posts = @posts.order(created_at: :desc)
            elsif params[:gender] == "preview"
                @posts = @posts.order(impressions_count: :desc)
            elsif params[:gender] == "reply"
                @posts = @posts.order(reply_count: :desc)
            end
        else
            @posts = @posts.order(id: :desc)
        end 
    end

    def read
        @post = Post.find(params[:id])
        @replies = Post.where(parent_post_id: params[:id]).order(id: :desc)
        # PVカウント
        impressionist(@post, nil, unique: [:session_hash])
    end

    def addBookmark
        if session[:bookmark]
            session[:bookmark].push(params[:id])
        else
            session[:bookmark] = [params[:id]]
        end

        flash[:notice] = "add_bookmark"
        redirect_to "/posts/" + params[:id].to_s
    end

    def bookmark
        if session[:bookmark]
            ids = session[:bookmark]
        else
            ids = []
        end
        @posts = Post.where(id: ids)
            .where(parent_post_id: params[:id])
            .order(id: :desc)
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

    def delete
        Post.where(id: params[:id]).update(
            is_hide: true
        )
        redirect_to "/posts"
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
