class ReadInputWorker
  include Sidekiq::Worker
  require 'nmap/xml'

  def perform(scan_id)    
    puts "Starting reading scan with ID: #{scan_id}"
    scan = Scan.find(scan_id)
    scan.raw_result = File.read("#{scan.uuid}.xml")
    scan.save!
  end
end
