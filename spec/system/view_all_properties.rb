require "rails_helper"

RSpec.describe "ViewImportedProperties", type: :system do
  let!(:properties) { create_list(:property, 15) }
  let(:decorated_properties) { properties.decorate }

  before do
    driven_by(:selenium_chrome_headless)
  end

  it "shows all the properties" do
    visit properties_index_path

    expect(page).to have_selector("#properties tbody tr", count: 10)

    properties.sort(&:external_id).first(10).each_with_index do |property, index|
      decorated_property = property.decorate

      expect(page).to have_selector("#properties tbody tr:nth-child(#{index + 1}) td:nth-child(1)", text: decorated_property.external_id)
      expect(page).to have_selector("#properties tbody tr:nth-child(#{index + 1}) td:nth-child(2)", text: decorated_property.name)
      expect(page).to have_selector("#properties tbody tr:nth-child(#{index + 1}) td:nth-child(3)", text: decorated_property.full_address)
      expect(page).to have_selector("#properties tbody tr:nth-child(#{index + 1}) td:nth-child(4)", text: decorated_property.formatted_area_square_meters)
      expect(page).to have_selector("#properties tbody tr:nth-child(#{index + 1}) td:nth-child(5)", text: decorated_property.rent)
      expect(page).to have_selector("#properties tbody tr:nth-child(#{index + 1}) td:nth-child(6)", text: decorated_property.property_type)
    end

    # Click on element with rel="next" attribute
    find("a[rel='next']").click

    expect(page).to have_selector("#properties tbody tr", count: 5)

    properties.sort(&:external_id).last(5).each_with_index do |property, index|
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
