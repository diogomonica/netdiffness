class HomeController < ApplicationController
  def index
    redirect_to controller: "scans", action: "index"
  end
end
