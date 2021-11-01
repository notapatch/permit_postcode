require "rails_helper"

RSpec.describe PostcodeChecker, type: :service do
  context "with disallowed postcodes" do
    it "serves addresses in allowed LSOH" do
      VCR.use_cassette vcr_path("serves addresses in allowed lsoh") do
        create(:allowed_lsoa, lsoa: "westminster")
        result = PostcodeChecker.new.call(postcode: Postcode.new("sw1a 1aa"))

        expect(result.allowed?).to eq true
      end
    end

    it "serves addresses in allowed LSOH with two words" do
      VCR.use_cassette vcr_path("serves addresses in allowed lsoh with two words") do
        create(:allowed_lsoa, lsoa: "milton keynes")
        result = PostcodeChecker.new.call(postcode: Postcode.new("mk10 1sa"))

        expect(result.allowed?).to eq true
      end
    end

    it "refuses addresses in disallowed LSOH" do
      VCR.use_cassette vcr_path("serves addresses in allowed lsoh") do
        result = PostcodeChecker.new.call(postcode: Postcode.new("sw1a 1aa"))

        expect(result.allowed?).to eq false
      end
    end
  end

  context "with disallowed LSOA" do
    it "serves addresses in allowed postcodes" do
      create(:allowed_postcode, postcode: "SH241AA")
      result = PostcodeChecker.new.call(postcode: Postcode.new("SH24 1AA"))

      expect(result.allowed?).to eq true
    end

    it "refuses addresses in disallowed postcodes" do
      VCR.use_cassette vcr_path("refuses addresses in disallowed postcodes") do
        result = PostcodeChecker.new.call(postcode: Postcode.new("SH24 1AA"))

        expect(result.allowed?).to eq false
      end
    end
  end

  def vcr_path(filename)
    "services/postcode_checks/postcode_checks_index_spec/#{filename}"
  end
end
