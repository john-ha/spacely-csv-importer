require "rails_helper"

RSpec.describe ImportPropertiesJob, type: :job do
  describe "#perform" do
    let(:import_history) { create(:import_history, import_status:) }

    before do
      # Do not execute the ParseCsvService. We only test if the job calls it.
      allow(Imports::ParseCsvService).to receive(:call).and_return(nil)
    end

    context "when ImportHistory status is other than :enqueued" do
      shared_examples "returns and does not call the ParseCsvService" do
        it "does not call the ParseCsvService" do
          expect(Imports::ParseCsvService).not_to receive(:call)

          ImportPropertiesJob.perform_now(import_history.id)
        end

        it "does not change the ImportHistory status" do
          expect { ImportPropertiesJob.perform_now(import_history.id) }.not_to change { import_history.reload.import_status }
        end
      end

      context "when ImportHistory status is :completed" do
        let(:import_status) { :completed }
        let(:imported_file) { fixture_file_upload("valid_rows_10_rows.csv", "text/csv") }

        it_behaves_like "returns and does not call the ParseCsvService"
      end

      context "when ImportHistory status is :failed" do
        let(:import_status) { :failed }
        let(:imported_file) { fixture_file_upload("valid_rows_10_rows.csv", "text/csv") }

        it_behaves_like "returns and does not call the ParseCsvService"
      end

      context "when ImportHistory status is :started" do
        let(:import_status) { :started }
        let(:imported_file) { fixture_file_upload("valid_rows_10_rows.csv", "text/csv") }

        it_behaves_like "returns and does not call the ParseCsvService"
      end
    end

    context "when ImportHistory status is :enqueued" do
      let(:import_status) { :enqueued }
      let(:imported_file) { fixture_file_upload("valid_rows_10_rows.csv", "text/csv") }

      it "calls the ParseCsvService" do
        expect(Imports::ParseCsvService).to receive(:call).with(import_history:)

        ImportPropertiesJob.perform_now(import_history.id)
      end

      it "changes the ImportHistory status to :started" do
        expect { ImportPropertiesJob.perform_now(import_history.id) }.to change { import_history.reload.import_status }.from("enqueued").to("started")
      end
    end
  end
end
