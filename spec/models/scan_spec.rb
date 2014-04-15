require 'spec_helper'

VALID_SCAN_RESULT = ["74.207.244.221", ["20/tcp", "21/tcp", "22/tcp", "23/tcp", "25/tcp", "80/tcp", "110/tcp", "443/tcp", "512/tcp", "522/tcp", "1080/tcp", "8080/tcp"]]

describe Scan do
  subject {Scan.new}
  it "parses the xml correctly" do
    expect(subject.parse_xml_scan("random_name")).not_to be_nil
    expect(subject.parse_xml_scan("random_name")).to contain_exactly(VALID_SCAN_RESULT)
  end
end
