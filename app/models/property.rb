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
  has_prefix_id :prop

  enum :property_type, {appartment: 0, mansion: 1, house: 2}, prefix: true

  has_many :import_histories_properties, dependent: :destroy
  accepts_nested_attributes_for :import_histories_properties
  has_many :import_histories, through: :import_histories_properties

  validates :external_id, presence: true
  validates :name, presence: true
  validates :property_type, presence: true
  validates :room_number, presence: true, if: -> { property_type_appartment? || property_type_mansion? }
  validates :area_square_meters, numericality: {greater_than_or_equal_to: 0}, allow_nil: true
  validates :rent, numericality: {greater_than_or_equal_to: 0}, allow_nil: true

  # Ransack configuration: allow only specific attributes to be searchable
  # Reference: https://activerecord-hackery.github.io/ransack/going-further/other-notes/#authorization-allowlistingdenylisting
  # @return [Array<String>]
  def self.ransackable_attributes(auth_object = nil)
    ["external_id", "name", "address", "room_number", "property_type"]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
