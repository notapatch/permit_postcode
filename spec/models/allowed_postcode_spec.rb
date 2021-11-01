require "rails_helper"

RSpec.describe AllowedPostcode, type: :model do
  describe ".matching?" do
    it "includes allowed postcode" do
      create(:allowed_postcode, postcode: "SH241AB")

      expect(AllowedPostcode).to be_matching(Postcode.new("SH241AB"))
    end

    it "includes allowed postcode formatted with space" do
      create(:allowed_postcode, postcode: "SH241AB")

      expect(AllowedPostcode).to be_matching(Postcode.new("SH24 1AB"))
    end

    it "include allowed postcode in lowercase" do
      create(:allowed_postcode, postcode: "SH241AB")

      expect(AllowedPostcode).to be_matching(Postcode.new("sh241ab"))
    end

    it "excludes disallowed postcodes" do
      expect(AllowedPostcode).not_to be_matching(Postcode.new("SH241AB"))
    end
  end
end
