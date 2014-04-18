class HomeController < ApplicationController
  def index
    @scans = Scan.where(user_id: current_user.id, active: true) if current_user
  end
end
