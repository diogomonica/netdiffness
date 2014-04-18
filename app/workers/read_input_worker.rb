require 'nmap/xml'

class ReadInputWorker
  include Sidekiq::Worker

  sidekiq_options :retry => 2

  def perform(uuid)
    puts "Starting reading scan with ID: #{uuid}"
    scan_result = ScanResult.find_by_uuid(uuid)
    if scan_result
      scan_result.raw_result = File.read("#{uuid}.xml")
      last_result = scan_result.scan.get_last_diff_scan_result
      if last_result && last_result.compare(scan_result).empty?
        scan_result.raw_result = nil
      end
      scan_result.finished = true
      scan_result.save
    else
      raise "Scan result not found in database: #{uuid}"
    end
  end
end
