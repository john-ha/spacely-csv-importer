require "rails_helper"

RSpec.describe Imports::UploadService, type: :service do
  describe "#call" do
    let(:file) { fixture_file_upload("valid_data.csv") }

    before do
      allow(ImportPropertiesJob).to receive(:perform_later).and_call_original
    end

    it "creates an ImportHistory and enqueues the ImportPropertiesJob job" do
      expect { described_class.call(file: file) }
        .to change(ImportHistory, :count).by(1)
        .and change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)

      import_history = ImportHistory.last

      expect(import_history.import_status).to eq("in_progress")
      expect(import_history.imported_at).to be_within(1.second).of(Time.zone.now)
      expect(import_history.imported_file).to be_attached

      expect(ImportPropertiesJob).to have_received(:perform_later).with(import_history.id)
    end
  end
end
