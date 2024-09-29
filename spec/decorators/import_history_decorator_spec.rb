require "rails_helper"

RSpec.describe ImportHistoryDecorator, type: :decorator do
  describe "#import_status" do
    let(:import_history) { create(:import_history) }

    subject { import_history.decorate.import_status }

    it { is_expected.to eq(import_history.import_status.humanize) }
  end

  describe "#import_status_color" do
    let(:import_history) { create(:import_history, import_status:) }

    subject { import_history.decorate.import_status_color }

    context "when :import_status is :started" do
      let(:import_status) { :started }

      it { is_expected.to eq "blue" }
    end

    context "when :import_status is :completed" do
      let(:import_status) { :completed }

      it { is_expected.to eq "green" }
    end

    context "when :import_status is :failed" do
      let(:import_status) { :failed }

      it { is_expected.to eq "red" }
    end
  end

  describe "#import_failure_type" do
    let(:import_history) { create(:import_history, import_failure_type:) }

    subject { import_history.decorate.import_failure_type }

    context "when :import_failure_type is present" do
      let(:import_failure_type) { :invalid_rows }

      it { is_expected.to eq import_failure_type.to_s.humanize }
    end

    context "when :import_failure_type is nil" do
      let(:import_failure_type) { nil }

      it { is_expected.to be_nil }
    end
  end
end
