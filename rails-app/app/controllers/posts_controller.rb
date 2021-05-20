class PostsController < ApplicationController
  before_action :correct_user, only: [:show, :destroy, :edit, :update]
   
  def index
    @q = Post.includes(:user).order(created_at: "DESC").ransack(params[:q])
    @pagy, @posts = pagy(@q.result, items: 10)
    @post = Post.new
  end
    
  def show
  end
  
  def new
    @post = Post.new
  end
  
  def create
    @post = current_user.posts.build(post_params)
  
    if @post.save
      flash[:success] = '投稿されました'
    else
      flash[:danger] = '投稿されませんでした'
    end
    redirect_to posts_url
  end
  
  def edit
  end
  
  def update
    if @post.update(post_params)
      flash[:success] = '投稿内容が更新されました'
      redirect_to posts_url
    else
      flash.now[:danger] = '投稿内容が更新されませんでした'
      render :edit
    end
  end
  
  def destroy
    @post.destroy
    flash[:success] = '投稿を削除しました'
    redirect_to posts_url
  end
  
  private
  
  def post_params
    params.require(:post).permit(:content)
  end
  
  def correct_user
   @post = current_user.posts.find_by(id: params[:id])
   unless @post
     redirect_to posts_url
   end
  end
end