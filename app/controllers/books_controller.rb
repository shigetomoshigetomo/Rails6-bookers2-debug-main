class BooksController < ApplicationController

  impressionist :actions=>[:show]

  def show
    @book = Book.find(params[:id])
    impressionist(@book, nil, unique: [:session_hash.to_s])
    @book_new=Book.new
    @book_comment=BookComment.new
  end

  def index
    @sequence=params[:sequence]
    to=Time.current.at_end_of_day
    from=(to-6.day).at_beginning_of_day

    if @sequence=="新着順"
      books=Book.all.order(created_at: :desc)
      @books=Kaminari.paginate_array(books).page(params[:page]).per(5)
    elsif @sequence=="評価が高い順"
      books=Book.all.order(rate: :desc)
      @books=Kaminari.paginate_array(books).page(params[:page]).per(5)
    else
      books = Book.all.sort {|a,b|
      b.favorites.where(created_at: from...to).size <=>
      a.favorites.where(created_at: from...to).size}
      @books=Kaminari.paginate_array(books).page(params[:page]).per(5)
    end

    @book=Book.new
  end

  def create
    @book = Book.new(book_params)
    @book.user_id=current_user.id
    if @book.save
      redirect_to book_path(@book.id), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
    if @book.user_id!=current_user.id
      redirect_to books_path
    end
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title,:body,:rate)
  end
end
