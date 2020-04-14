class Api::V1::ArticlesController < ApplicationController
  skip_before_action :verify_authenticity_token if -> { auth_header.present? }
  before_action :login_require

  def index
    @articles = Article.all
    respond_to do |format|
      format.html
      format.json { render json: @articles, status: :ok }
    end
  end

  def new
    @article = Article.new
  end

  def show
    @article = Article.find_by(id: params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @article, status: 200 }
    end
  end

  def create
    @article = Article.create(article_params)
    @article.user_id = session_user.id

    if @article.save
      respond_to do |format|
        format.html
        format.json { render json: { article: @article } , status: :created }
      end
    else
      render json: @article.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    @article = Article.find(params[:id])
    if @article.update!(article_params)
      respond_to do |format|
        format.html
        format.json { render json: @article, status: :created }
      end
    else
      render json: @article.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    @article = Article.find(params[:id])

    if @article.destroy
      respond_to do |format|
        format.html
        format.json { render json: @article, status: :no_content }
      end
    else
      render json: @article.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

  def article_params
    params.require(:article).permit(:title, :body)
  end
end
