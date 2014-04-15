class SimpleScanWorker
  include Sidekiq::Worker
  require 'nmap/program'
  require 'securerandom'

  def perform(scan_id)
    scan = Scan.find(scan_id)
    raise "Scan not found" if scan.nil?

    puts "Starting scan with ID: #{scan_id} and targets: #{scan.targets}"
    Nmap::Program.scan do |nmap|
      nmap.service_scan = true
      nmap.xml = "#{scan.uuid}.xml"

      nmap.ports = [20,21,22,23,25,80,110,443,512,522,8080,1080]
      nmap.targets = scan.targets
    end

    ReadInputWorker.perform_async(scan_id)
  end
end
