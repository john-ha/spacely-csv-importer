require "rails_helper"

RSpec.describe "ImportProperties", type: :system do
  before do
    driven_by(:selenium_chrome_headless)
  end

  it "starts the import of properties" do
    visit imports_index_path

    expect(page).to have_selector("#import-histories tbody tr", count: 0)

    click_on "Import properties"

    expect(page).to have_current_path(imports_new_path)
    attach_file("file", Rails.root.join("spec", "fixtures", "files", "valid_data.csv"))

    click_on "Import"

    expect(page).to have_current_path(imports_index_path)
    expect(page).to have_selector("#import-histories tbody tr", count: 1)
  end
end
