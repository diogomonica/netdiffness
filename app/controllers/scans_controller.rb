class ScansController< ApplicationController
  before_filter :authenticate_user!
  before_filter :ensure_ownership, :only => [:show, :update, :rescan]

  def index
    @scans = current_user.scans
  end

  def show
    # Remove the last scan result because it wi
    @scan_results = @scan.scan_results[0..-2]
    @last_scan = @scan.get_last_scan_result
    @results = @last_scan ? @last_scan.result : {}
  end

  def new
    @scan = Scan.new
  end

  def create
    @scan = Scan.new(scan_params)
    @scan.user = current_user
    if @scan.save
      # Schedulle the scanning job
      @scan.start_scan
      redirect_to @scan
    else
      render "new"
    end
  end

  def update
    if @scan.active
      @scan.update_attributes({active: false})
    else
      @scan.update_attributes({active: true})
    end  
    redirect_to @scan
  end

  def rescan
    head :unauthorized if @scan.user != current_user
    @scan.start_scan
    redirect_to @scan
  end

  private

  def ensure_ownership
    @scan = Scan.find(params[:id])
    # Ensure that user is owner of this scan
    head :unauthorized if @scan.user != current_user
  end

  def scan_params
    params.require(:scan).permit(:targets, :frequency)
  end

  def update_params
    params.require(:scan).permit(:active)
  end
end
