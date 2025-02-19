class ImportHistoryDecorator < ApplicationDecorator
  delegate_all

  IMPORT_STATUS_COLORS = {
    enqueued: "blue",
    started: "orange",
    completed: "green",
    failed: "red"
  }.freeze

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def id
    object.prefix_id
  end

  def formatted_import_status
    object.import_status.humanize
  end

  def import_status_color
    IMPORT_STATUS_COLORS[object.import_status.to_sym]
  end

  def formatted_import_failure_type
    object.import_failure_type&.humanize
  end
end
