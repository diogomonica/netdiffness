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

  def get_last_scan_result
    results = self.scan_results
    return results.last unless results.empty?
    nil
  end
end
