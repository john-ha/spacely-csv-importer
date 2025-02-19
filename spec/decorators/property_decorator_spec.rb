require "rails_helper"

RSpec.describe PropertyDecorator, type: :decorator do
  describe "#id" do
    let(:property) { create(:property) }

    subject { property.decorate.id }

    it { is_expected.to eq(property.prefix_id) }
  end

  describe "#full_address" do
    let(:property) { create(:property, address:, property_type: :house, room_number:) }

    context "when :address and :room_number are present" do
      let(:address) { "Toulouse" }
      let(:room_number) { "203A" }

      subject { property.decorate.full_address }

      it { is_expected.to eq("Toulouse 203A") }
    end

    context "when :address is present and :room_number is nil" do
      let(:address) { "Toulouse" }
      let(:room_number) { nil }

      subject { property.decorate.full_address }

      it { is_expected.to eq("Toulouse") }
    end
  end

  describe "#formatted_area_square_meters" do
    let(:property) { create(:property, area_square_meters:) }

    subject { property.decorate.formatted_area_square_meters }

    context "when :area_square_meters is present" do
      let(:area_square_meters) { 12.34 }

      it { is_expected.to eq("12.34 m²") }
    end

    context "when :area_square_meters is nil" do
      let(:area_square_meters) { nil }

      it { is_expected.to be_nil }
    end
  end

  describe "#formatted_rent" do
    let(:property) { create(:property, rent:) }

    subject { property.decorate.formatted_rent }

    context "when :rent is present" do
      let(:rent) { 12345 }

      it { is_expected.to eq("12345 円") }
    end

    context "when :rent is nil" do
      let(:rent) { nil }

      it { is_expected.to be_nil }
    end
  end

  describe "#formatted_property_type" do
    let(:property) { create(:property, property_type: Property.property_types.keys.sample) }

    subject { property.decorate.formatted_property_type }

    it { is_expected.to eq(property.property_type.humanize) }
  end
end
