require 'hashdiff'

class ScanResultsController < ApplicationController
  def compare
    @result_a = ScanResult.find(params[:id])
    @result_b = ScanResult.find(params[:cid])

    # Make sure these ScanResults exist
    raise ActionController::RoutingError.new('Not Found') unless @result_a && @result_b

    # Ensure that user is owner of this scan
    if @result_a.scan.user != current_user or @result_b.scan.user != current_user
      head :unauthorized
    end

    # Make sure these ScanResults belong to the same Scan
    head :unauthorized unless @result_a.scan == @result_b.scan

    @results = @result_a.compare(@result_b)
  end
end
