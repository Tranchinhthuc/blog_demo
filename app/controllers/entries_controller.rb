class EntriesController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy
  def create
    @entry = current_user.entries.build(entry_params)
    if @entry.save
      flash[:success] = "Entry created!"
      redirect_to user_url(current_user)
    else
      @feed_items = []
      render 'new'
    end
  end
  def edit
     @entry = Entry.find(params[:id])   
  end

  def update

    @entry = Entry.find(params[:id])
    @entry.update(entry_params)
    redirect_to user_url(@entry.user)
  end
def new
  @entry = Entry.new
  
end
  def destroy
    user = @entry.user
  	@entry.destroy
    flash[:success] = "Entry deleted"
    redirect_to user_url(user)
  end


  def index
    id = current_user.id
    @entries = Entry.where("user_id = #{id}")
    #@entries = Entry.where("user_id = @user_id")
  end
  def show
    #@user = User.find(params[:id])

    @comment = Comment.new

    @entry = Entry.find(params[:id])
   # id = @user.id
    #@entries = @user.entries.paginate(page: params[:page])
  end

  private

    def entry_params
      params.require(:entry).permit(:title, :body, :picture)
    end
    def correct_user
      @entry = current_user.entries.find_by(id: params[:id])
      redirect_to root_url if @entry.nil?
    end
end