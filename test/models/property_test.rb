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
require "test_helper"

class PropertyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
