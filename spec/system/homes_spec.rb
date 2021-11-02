require "rails_helper"

RSpec.describe "Homes", type: :system do
  it "serves allowed postcode" do
    create(:allowed_postcode, postcode: "SH241AA")
    visit root_path

    expect(page).to have_text("Check postcode allowed")
    fill_in "Check postcode allowed", with: "SH24 1AA"
    click_on "Check"

    expect(page).to have_text("Good news, we can deliver")
  end

  it "refuses disallowed postcode" do
    VCR.use_cassette(vcr_path("refuses disallowed postcode")) do
      visit root_path

      expect(page).to have_text("Check postcode allowed")
      fill_in "Check postcode allowed", with: "SW1A 1AA"
      click_on "Check"

      expect(page).to have_text("Sorry our services are not available in your area")
    end
  end

  it "displays errors when bad postcode" do
    VCR.use_cassette(vcr_path("displays errors when bad postcode")) do
      visit root_path

      expect(page).to have_text("Check postcode allowed")
      fill_in "Check postcode allowed", with: "888"
      click_on "Check"

      expect(page).to have_text("Invalid postcode")
    end
  end

  def vcr_path(filename)
    "system/homes_spec/#{filename}"
  end
end
