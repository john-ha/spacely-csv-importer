require "rails_helper"

RSpec.describe ImportPropertiesJob, type: :job do
  describe "#perform" do
    let(:import_history) { create(:import_history) }

    it "calls the ParseCsvService" do
      expect(Imports::ParseCsvService).to receive(:call).with(import_history:)

      ImportPropertiesJob.perform_now(import_history.id)
    end
  end
end
