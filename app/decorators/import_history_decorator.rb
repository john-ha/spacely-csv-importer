class ImportHistoryDecorator < ApplicationDecorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def import_status
    object.import_status.humanize
  end

  def import_status_color
    case object.import_status.to_sym
    when :in_progress
      "blue"
    when :completed
      "green"
    when :failed
      "red"
    end
  end

  def import_error_message
    if object.import_failure_type.present?
      object.import_failure_type.humanize
    end
  end
end
