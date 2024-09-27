# == Schema Information
#
# Table name: import_histories
#
#  id                        :bigint           not null, primary key
#  import_status             :integer          default("in_progress"), not null
#  imported_at               :datetime         not null
#  imported_properties_count :integer          default(0), not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
class ImportHistory < ApplicationRecord
  has_many :import_history_properties, dependent: :destroy
  has_many :properties, through: :import_history_properties

  has_one_attached :imported_file

  enum import_status: {in_progress: 0, success: 1, failed: 2}

  validates :import_status, presence: true
  validates :imported_at, presence: true
  validates :imported_properties_count, presence: true
end
