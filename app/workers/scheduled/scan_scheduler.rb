
class ScanScheduler
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { hourly }

  def perform
    scans_to_perform = Scan.where(:active => true).where("last_scan < ?", Time.now - 10.minutes).order('last_scan ASC')
    puts scans_to_perform
    scans_to_perform.each do |scan|
      scan.start_scan
    end
  end

end
