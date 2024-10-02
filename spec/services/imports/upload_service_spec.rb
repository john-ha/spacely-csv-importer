require "rails_helper"

RSpec.describe Imports::UploadService, type: :service do
  describe "#call" do
    before do
      allow(ImportPropertiesJob).to receive(:perform_later).and_call_original
    end

    context "when the file is valid" do
      let(:file) { fixture_file_upload("valid_rows_10_rows.csv", "text/csv") }

      it "creates an ImportHistory and enqueues the ImportPropertiesJob job" do
        expect { described_class.call(file:) }
          .to change(ImportHistory, :count).by(1)
          .and change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)

        import_history = ImportHistory.last

        expect(import_history.import_status).to eq("started")
        expect(import_history.imported_at).to be_within(1.second).of(Time.zone.now)
        expect(import_history.imported_file).to be_attached

        expect(ImportPropertiesJob).to have_received(:perform_later).with(import_history.id)
      end
    end

    context "when the file is not a CSV file" do
      let(:file) { fixture_file_upload("wrong_format_file.txt", "text/plain") }

      it "raises an InvalidFileFormatError" do
        expect { described_class.call(file:) }
          .to raise_error(Imports::UploadService::InvalidFileFormatError)
          .and not_change(ImportHistory, :count)
          .and not_change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size)
      end
    end

    context "when the file size exceeds the maximum allowed" do
      let(:file) { fixture_file_upload("invalid_size.csv", "text/csv") }

      it "raises a FileSizeExceededError" do
        expect { described_class.call(file:) }
          .to raise_error(Imports::UploadService::FileSizeExceededError)
          .and not_change(ImportHistory, :count)
          .and not_change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size)
      end
    end
  end
end
