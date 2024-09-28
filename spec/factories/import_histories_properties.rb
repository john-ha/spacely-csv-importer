# == Schema Information
#
# Table name: import_histories_properties
#
#  id                :bigint           not null, primary key
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
# Foreign Keys
#
#  fk_rails_...  (import_history_id => import_histories.id)
#  fk_rails_...  (property_id => properties.id)
#
FactoryBot.define do
  factory :import_histories_property do
    import_history
    property
  end
end
