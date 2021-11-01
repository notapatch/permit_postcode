require "rails_helper"

RSpec.describe AllowedLsoa, type: :model do
  describe ".matching?" do
    it "includes allowed lsoa" do
      create(:allowed_lsoa, lsoa: "westminster")

      expect(AllowedLsoa).to be_matching("westminster")
    end

    it "includes allowed capitalized lsoa" do
      create(:allowed_lsoa, lsoa: "westminster")

      expect(AllowedLsoa).to be_matching("Westminster")
    end

    it "includes allowed lsoa with whitespace around it" do
      create(:allowed_lsoa, lsoa: "westminster")

      expect(AllowedLsoa).to be_matching(" westminster ")
    end

    it "excludes disallowed lsoa" do
      expect(AllowedLsoa).not_to be_matching("westminster")
    end
  end
end
