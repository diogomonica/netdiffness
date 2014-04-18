require 'nmap/xml'

class ReadInputWorker
  include Sidekiq::Worker

  sidekiq_options :retry => 2

  def perform(uuid)
    puts "Starting reading scan with ID: #{uuid}"
    scan_result = ScanResult.find_by_uuid(uuid)    
    scan_result.raw_result = File.read("#{uuid}.xml")
    scan_result.save
  end
end
