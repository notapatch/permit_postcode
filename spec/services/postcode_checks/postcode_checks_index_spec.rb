require "rails_helper"

module PostcodeChecks
  RSpec.describe PostcodeChecksIndex, type: :service do
    context "with disallowed postcodes" do
      it "serves addresses in allowed LSOH" do
        VCR.use_cassette "services/postcode_checks/postcode_checks_index_spec/serves-addresses-in-allowed-lsoh" do
          create(:allowed_lsoa, lsoa: "westminster")
          result = PostcodeChecks::PostcodeChecksIndex.new.postcode_checks_index(postcode: Postcode.new("sw1a 1aa"))

          expect(result.allowed?).to eq true
        end
      end

      it "serves addresses in allowed LSOH with two words" do
        VCR.use_cassette "services/postcode_checks/postcode_checks_index_spec/serves-addresses-in-allowed-lsoh-with-two-words" do
          create(:allowed_lsoa, lsoa: "milton keynes")
          result = PostcodeChecks::PostcodeChecksIndex.new.postcode_checks_index(postcode: Postcode.new("mk10 1sa"))

          expect(result.allowed?).to eq true
        end
      end

      it "refuses addresses in disallowed LSOH" do
        VCR.use_cassette "services/postcode_checks/postcode_checks_index_spec/serves-addresses-in-allowed-lsoh" do
          result = PostcodeChecks::PostcodeChecksIndex.new.postcode_checks_index(postcode: Postcode.new("sw1a 1aa"))

          expect(result.allowed?).to eq false
        end
      end
    end

    context "with disallowed LSOA" do
      it "serves addresses in allowed postcodes" do
        create(:allowed_postcode, postcode: "SH241AA")
        result = PostcodeChecks::PostcodeChecksIndex.new.postcode_checks_index(postcode: Postcode.new("SH24 1AA"))

        expect(result.allowed?).to eq true
      end

      it "refuses addresses in disallowed postcodes" do
        VCR.use_cassette "services/postcode_checks/postcode_checks_index_spec/refuses addresses in disallowed postcodes" do
          result = PostcodeChecks::PostcodeChecksIndex.new.postcode_checks_index(postcode: Postcode.new("SH24 1AA"))

          expect(result.allowed?).to eq false
        end
      end
    end
  end
end
