class CommentsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy


  def create
    @comment = Comment.new(comment_params)
    #user = User.find(@comment.user_id)
    if @comment.save
      redirect_to request.referrer || root_url
    else
      @feed_items = []      
      render 'static_pages/home'
    end
  end
def new
  @comment = Comment.new 
end
  def destroy
    @comment.destroy
    flash[:success] = "Comment deleted"
    redirect_to request.referrer || root_url
  end

  def index
    user_id = current_user.id
    @comments = Comment.where("user_id = #{id} and entries_id = #{}")
  end


  private

    def comment_params
      params.require(:comment).permit(:content, :user_id, :entries_id)
    end
    def correct_user
      @comment = current_user.comments.find_by(id: params[:id])
      redirect_to root_url if @comment.nil?
    end
end