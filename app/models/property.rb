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
class Property < ApplicationRecord
  enum :property_type, {appartment: 0, mansion: 1, house: 2}, prefix: true

  has_many :import_histories_properties, dependent: :destroy
  has_many :import_histories, through: :import_histories_properties

  validates :external_id, presence: true
  validates :name, presence: true
  validates :property_type, presence: true

  validates :room_number, presence: true, if: -> { appartment? || mansion? }
end
