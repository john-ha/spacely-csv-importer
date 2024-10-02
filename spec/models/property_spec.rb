# == Schema Information
#
# Table name: properties
#
#  id                 :bigint           not null, primary key
#  address            :string
#  area_square_meters :float
#  name               :string           not null
#  property_type      :integer          default("appartment"), not null
#  rent               :integer
#  room_number        :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  external_id        :string           not null
#
# Indexes
#
#  index_properties_on_external_id  (external_id) UNIQUE
#
require "rails_helper"

RSpec.describe Property, type: :model do
  describe "enumerations" do
    it { should define_enum_for(:property_type).with_values(appartment: 0, mansion: 1, house: 2).with_prefix(true) }
  end

  describe "associations" do
    it { should have_many(:import_histories_properties).dependent(:destroy) }
    it { should accept_nested_attributes_for(:import_histories_properties) }
    it { should have_many(:import_histories).through(:import_histories_properties) }
  end

  describe "validations" do
    it { should validate_presence_of(:external_id) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:property_type) }
    it { should validate_numericality_of(:area_square_meters).is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:rent).is_greater_than_or_equal_to(0) }

    it { create(:property, property_type: :appartment).should validate_presence_of(:room_number) }
    it { create(:property, property_type: :mansion).should validate_presence_of(:room_number) }
    it { create(:property, property_type: :house).should_not validate_presence_of(:room_number) }
  end
end
