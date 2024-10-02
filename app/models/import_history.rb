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
class ImportHistory < ApplicationRecord
  has_prefix_id :imp

  enum :import_status, {enqueued: 0, started: 1, completed: 2, failed: 3}, prefix: true
  enum :import_failure_type, {unknown_error: 0, invalid_headers: 1, invalid_rows: 2}, prefix: true

  has_many :import_histories_properties, dependent: :destroy
  has_many :properties, through: :import_histories_properties

  validates :import_status, presence: true
  validates :imported_at, presence: true
  validates :imported_properties_count, presence: true

  has_one_attached :imported_file
  has_one_attached :imported_file_with_errors
end
