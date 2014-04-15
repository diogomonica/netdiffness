require 'securerandom'
require 'nmap/xml'

class Scan < ActiveRecord::Base
  belongs_to :user
  before_create :generate_random_name

  def parse_xml_scan
    results = {}

    xml_document = StringIO.new(self.raw_result)

    Nmap::XML.new(xml_document) do |xml|
      xml.each_host do |host|
        results[host.address] = []
        host.each_port do |port|
          results[host.address] << "#{port.number}/#{port.protocol}"
        end
      end
    end
    results
  end

  private
  def generate_random_name
    self.uuid = SecureRandom.uuid()
  end
end
