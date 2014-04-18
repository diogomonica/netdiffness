class ScanResult < ActiveRecord::Base
  belongs_to :scan
  before_create :generate_random_uuid

  def result
    return nil unless self.raw_result
    result_hash = {}

    xml_document = StringIO.new(self.raw_result)
    Nmap::XML.new(xml_document) do |xml|
      xml.each_host do |host|
        result_hash[host.address] = []
        host.each_port do |port|
          result_hash[host.address] << "#{port.number}/#{port.protocol}" if port.state == :open
        end
      end
    end
    result_hash
  end

  def compare(scan_result)
    HashDiff.diff(self.result, scan_result.result, :delimiter => ';')
  end

  private
  def generate_random_uuid
    self.uuid = SecureRandom.uuid()
  end
end
