# == Schema Information
#
# Table name: import_histories
#
#  id                        :bigint           not null, primary key
#  import_failure_type       :integer
#  import_status             :integer          default("enqueued"), not null
#  imported_at               :datetime         not null
#  imported_properties_count :integer          default(0), not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
FactoryBot.define do
  factory :import_history do
    import_failure_type { ImportHistory.import_failure_types.keys.sample }
    import_status { ImportHistory.import_statuses.keys.sample }
    imported_at { Faker::Time.backward(days: 14) }
    imported_properties_count { Faker::Number.number(digits: 3) }

    trait :with_properties do
      after(:create) do |import_history|
        create_list(:import_histories_property, 3, import_history:)
      end
    end
  end
end
