class TweetsController < ApplicationController
  before_action :set_tweet, only: [:edit, :show]
  before_action :move_to_index, except: [:index, :show, :search]
  
  #indexアクションにアクセスした場合、indexアクションへのリダイレクトを繰り返してしまい、無限ループが起こります。この対策として、except: :indexを付け加えています
  #ログインしていなくても、詳細ページに遷移できる仕様にするためにexcept: [:index, :show]としています。
  before_action :move_to_index, except: [:index, :show]

  def index
    @tweets = Tweet.includes(:user).order("created_at DESC")
  end

  def new
    @tweet = Tweet.new
  end

  def create
    # binding.pry
    Tweet.create(tweet_params)
  end

  def destroy
    tweet = Tweet.find(params[:id])
    tweet.destroy
  end

  def edit
  end

  def update
    tweet = Tweet.find(params[:id])
    tweet.update(tweet_params)
  end

  def show
    @comment = Comment.new
    @comments = @tweet.comments.includes(:user)
  end
  
  def search
    @tweets = Tweet.search(params[:keyword])
  end

  private
  
  def tweet_params
    params.require(:tweet).permit(:image, :text).merge(user_id: current_user.id)
  end

  def set_tweet
    @tweet = Tweet.find(params[:id])
  end

  def move_to_index
    unless user_signed_in?
      #falseだった場合にredirect_toが実行
      redirect_to action: :index
    end
  end
end