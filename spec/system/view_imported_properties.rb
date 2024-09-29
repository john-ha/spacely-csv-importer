require "rails_helper"

RSpec.describe "ViewImportedProperties", type: :system do
  let!(:import_history) { create(:import_history, :with_properties) }
  let(:decorated_import_history) { import_history.decorate }

  before do
    driven_by(:selenium_chrome_headless)
  end

  it "shows all the imported properties for an import history" do
    visit imports_index_path

    expect(page).to have_selector("#import-histories tbody tr", count: 1)

    expect(page).to have_selector("#import-histories tbody tr:nth-child(1) td:nth-child(1)", text: decorated_import_history.id)
    expect(page).to have_selector("#import-histories tbody tr:nth-child(1) td:nth-child(2)", text: decorated_import_history.imported_properties_count)
    expect(page).to have_selector("#import-histories tbody tr:nth-child(1) td:nth-child(3)", text: decorated_import_history.imported_at)
    expect(page).to have_selector("#import-histories tbody tr:nth-child(1) td:nth-child(4)", text: decorated_import_history.import_status)
    expect(page).to have_selector("#import-histories tbody tr:nth-child(1) td:nth-child(5)", text: nil)
    expect(page).to have_selector("#import-histories tbody tr:nth-child(1) td:nth-child(6) a", text: "Show")
    expect(page).to have_selector("#import-histories tbody tr:nth-child(1) td:nth-child(6) a", text: "Original file")

    click_on "Show"

    expect(page).to have_current_path(imports_import_history_properties_path(import_history_id: import_history.id))
    expect(page).to have_selector("#properties tbody tr", count: 3)

    import_history.properties.order(external_id: :asc).each_with_index do |property, index|
      decorated_property = property.decorate

      expect(page).to have_selector("#properties tbody tr:nth-child(#{index + 1}) td:nth-child(1)", text: decorated_property.external_id)
      expect(page).to have_selector("#properties tbody tr:nth-child(#{index + 1}) td:nth-child(2)", text: decorated_property.name)
      expect(page).to have_selector("#properties tbody tr:nth-child(#{index + 1}) td:nth-child(3)", text: decorated_property.full_address)
      expect(page).to have_selector("#properties tbody tr:nth-child(#{index + 1}) td:nth-child(4)", text: decorated_property.formatted_area_square_meters)
      expect(page).to have_selector("#properties tbody tr:nth-child(#{index + 1}) td:nth-child(5)", text: decorated_property.rent)
      expect(page).to have_selector("#properties tbody tr:nth-child(#{index + 1}) td:nth-child(6)", text: decorated_property.property_type)
    end
  end
end
