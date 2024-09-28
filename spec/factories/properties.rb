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
FactoryBot.define do
  factory :property do
    address { Faker::Address.full_address }
    area_square_meters { Faker::Number.decimal(l_digits: 2) }
    name { Faker::Address.community }
    property_type { Property.property_types.keys.sample }
    rent { Faker::Number.number(digits: 5) }
    room_number { Faker::Alphanumeric.alphanumeric(number: 3) }
    external_id { Faker::Alphanumeric.alphanumeric(number: 10) }
  end
end
