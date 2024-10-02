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
require "rails_helper"

RSpec.describe ImportHistory, type: :model do
  describe "enumerations" do
    it { should define_enum_for(:import_status).with_values(enqueued: 0, started: 1, completed: 2, failed: 3).with_prefix(true) }
    it { should define_enum_for(:import_failure_type).with_values(unknown_error: 0, invalid_headers: 1, invalid_rows: 2).with_prefix(true) }
  end

  describe "associations" do
    it { should have_many(:import_histories_properties).dependent(:destroy) }
    it { should have_many(:properties).through(:import_histories_properties) }
  end

  describe "validations" do
    it { should validate_presence_of(:import_status) }
    it { should validate_presence_of(:imported_at) }
    it { should validate_presence_of(:imported_properties_count) }
  end

  describe "attachments" do
    it { should have_one_attached(:imported_file) }
    it { should have_one_attached(:imported_file_with_errors) }
  end
end
