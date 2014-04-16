class ScansController< ApplicationController
  before_filter :authenticate_user!

  def index
    @scans = current_user.scans
  end

  def show
    @scan = Scan.find(params[:id])
    # Ensure that user is owner of this scan
    head :unauthorized if @scan.user != current_user
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

  def rescan
    @scan = Scan.find(params[:id])
    # Ensure that user is owner of this scan
    head :unauthorized if @scan.user != current_user
    @scan.start_scan
    redirect_to @scan
  end

  private
  def scan_params
    params.require(:scan).permit(:targets, :frequency)
  end
end
