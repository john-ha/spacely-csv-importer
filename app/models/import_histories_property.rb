# == Schema Information
#
# Table name: import_histories_properties
#
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  import_history_id :bigint           not null
#  property_id       :bigint           not null
#
# Indexes
#
#  idx_on_import_history_id_property_id_b9c60664be         (import_history_id,property_id) UNIQUE
#  index_import_histories_properties_on_import_history_id  (import_history_id)
#  index_import_histories_properties_on_property_id        (property_id)
#
class ImportHistoriesProperty < ApplicationRecord
  belongs_to :property
  belongs_to :import_history

  validates :property_id, presence: true
  validates :import_history_id, presence: true
  validates :property_id, uniqueness: {scope: :import_history_id}
end
