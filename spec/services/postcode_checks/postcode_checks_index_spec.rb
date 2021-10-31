require "rails_helper"

module PostcodeChecks
  RSpec.describe PostcodeChecksIndex, type: :service do
    context "with disallowed LSOA" do
      it "serves addresses in allowed postcodes" do
        create(:allowed_postcode, postcode: "SH241AA")
        result = PostcodeChecks::PostcodeChecksIndex.new.postcode_checks_index(postcode_query: "SH24 1AA")

        expect(result.allowed?).to eq true
      end

      it "refuses addresses in disallowed postcodes" do
        result = PostcodeChecks::PostcodeChecksIndex.new.postcode_checks_index(postcode_query: "SH24 1AA")

        expect(result.allowed?).to eq false
      end
    end
  end
end
