class ScansController< ApplicationController
  before_filter :authenticate_user!
  before_filter :ensure_ownership, :only => [:show, :update, :rescan]

  def index
    @scans = current_user.scans.order(last_scan: :desc).limit(100)
  end

  def show
    @last_scan = @scan.scan_results.last
    @results = ScanResult.where("scan_id = ? AND raw_result IS NOT NULL", @scan.id).limit(100)
    @last_scan_with_raw = @results.last unless @results.empty?

    # Previous scans stuff
    previous_six_months = (0..6).map do |month|
      (6.months.ago + month.months).strftime("%B")
    end

    @historic_summary = { current_result: @last_scan_with_raw.id, timeline: previous_six_months, articles: @scan.get_history_of_scans(@last_scan) }

    respond_to do |format|
      format.html
      format.json { render :json => @historic_summary }
    end
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
    params.require(:scan).permit(:targets, :frequency, :name)
  end

  def update_params
    params.require(:scan).permit(:active)
  end
end
