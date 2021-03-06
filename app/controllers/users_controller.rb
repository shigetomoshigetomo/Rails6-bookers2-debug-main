class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:update]

  def show
    @user = User.find(params[:id])
    @books = @user.books.page(params[:page]).per(5)
    @book = Book.new
    @today_book = @books.created_today
    @yesterday_book = @books.created_yesterday
    @yesterday_compare = @today_book.count / @yesterday_book.count.to_f

    @this_week = @books.created_this_week
    @last_week = @books.created_last_week
    @week_compare = @this_week.count / @last_week.count.to_f

    array = []
    @books.each do |book|
      point = book.favorites.count
      array << point
    end
    @point_sum = array.sum
    @level = @point_sum.to_i / 5
  end

  def index
    @users = User.all
    @book = Book.new
  end

  def edit
    @user = User.find(params[:id])
    if @user.id != current_user.id
      redirect_to user_path(current_user.id)
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      render :edit
    end
  end

  def search
    @user = User.find(params[:user_id])
    @books = @user.books
    if params[:created_at] == ""
      @search_book = "日付を選択してください。"
    else
      create_at = params[:created_at]
      @search_book = @books.where(["created_at LIKE ?", "#{create_at}%"]).count
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
