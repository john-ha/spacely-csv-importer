# == Schema Information
#
# Table name: import_histories
#
#  id                        :bigint           not null, primary key
#  import_failure_type       :integer
#  import_status             :integer          default("in_progress"), not null
#  imported_at               :datetime         not null
#  imported_properties_count :integer          default(0), not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
require "test_helper"

class ImportHistoryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
