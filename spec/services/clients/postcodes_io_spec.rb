require "rails_helper"

module Clients
  RSpec.describe PostcodesIo, type: :service do
    it "returns the lsoa for a postcode" do
      VCR.use_cassette "services/clients/postcodes_io_spec/returns-the-lsoa-for-a-postcode" do
        result = Clients::PostcodesIo.new.retrieve_postcode(Postcode.new("SW1A1AA"))

        expect(result).to be_success
        expect(result.error).to be_nil
        expect(result.lsoa).to eq "Westminster 018C"
      end
    end

    it "returns the lsoa for a postcode with whitespace" do
      VCR.use_cassette "services/clients/postcodes_io_spec/returns-the-lsoa-for-a-postcode-with-whitespace" do
        result = Clients::PostcodesIo.new.retrieve_postcode(Postcode.new("SW1A 1AA"))

        expect(result).to be_success
        expect(result.error).to be_nil
        expect(result.lsoa).to eq "Westminster 018C"
      end
    end

    it "handles postcode not found errors" do
      VCR.use_cassette "services/clients/postcodes_io_spec/handles-postcode-not-found-errors" do
        result = Clients::PostcodesIo.new.retrieve_postcode(Postcode.new("888"))

        expect(result).not_to be_success
        expect(result.error).to eq "Invalid postcode"
        expect(result.lsoa).to be_nil
      end
    end
  end
end
