require 'nmap/program'

class SimpleScanWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false

  def perform(uuid, targets)
    puts "Starting scan with ID: #{uuid} and targets: #{targets}"
    targets = nil if targets.empty?
    raise "Not enough parameters to start scanner" unless targets && uuid

    result = Nmap::Program.scan do |nmap|
      nmap.service_scan = true
      nmap.xml = "#{uuid}.xml"

      nmap.ports = [20,21,22,23,25,80,110,443,512,522,8080,1080]
      nmap.targets = targets
    end
    ReadInputWorker.perform_async(uuid)
  end
end
