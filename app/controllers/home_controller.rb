class HomeController < ApplicationController
  def index
    @users = User.all
    # puts TestWorker.perform_async('OMG', 5)
  end
end
