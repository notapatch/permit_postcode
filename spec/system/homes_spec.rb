require "rails_helper"

RSpec.describe "Homes", type: :system do
  it "serves allowed postcode" do
    visit root_path

    expect(page).to have_text("Check postcode allowed")
    fill_in "Check postcode allowed", with: "SH24 1AA"
    click_on "Check"

    expect(page).to have_text("Success, we allow SH24 1AA")
  end

  it "refuses disallowed postcode" do
    skip("TODO unhappy path")
  end

  it "displays errors when not fully formed postcode" do
    skip("TODO error path")
  end
end
