require 'securerandom'
require 'nmap/xml'

class Scan < ActiveRecord::Base
  belongs_to :user
  has_many :scan_results
  validates_format_of :targets, :with => /(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])(\/([1-2]\d|3[0-2]|\d))/i, :on => :create

  def start_scan
    scan_result = ScanResult.create(scan_id: self.id)
    SimpleScanWorker.perform_async(scan_result.uuid, self.targets)
    self.last_scan = Time.now
    self.save
  end

  def get_last_diff_scan_result
    ScanResult.where("scan_id = ? AND raw_result is NOT NULL", self.id).last
  end

  def get_history_of_scans(result_b)
    # [[0.4, 1], [3, 2], [4, 2], [5, 2], [1, 1]]
    # Change this to return an intermediate value depending on the day
    # Change this to calculate the amount of change between dates
    result = []
    ScanResult.where("scan_id = ? AND raw_result is NOT NULL", self.id).each do |r|
      result << [r.created_at.month, r.compare(result_b).count]
    end
    result
  end
end
