# frozen_string_literal: true

class HackatimeProjectSelectorComponent < ViewComponent::Base
  COLORS = %i[red blue green yellow].freeze

  attr_reader :label, :color, :subtitle, :form, :attribute, :projects, :project_times, :locked_project_names

  def initialize(label:, form:, attribute:, color: :blue, subtitle: nil, projects: [], project_times: {}, locked_project_names: [])
    @label = label
    @form = form
    @attribute = attribute
    @color = normalize_color(color)
    @subtitle = subtitle
    @projects = projects
    @project_times = project_times
    @locked_project_names = Array(locked_project_names)
  end

  def input_classes
    class_names("hackatime-project-selector", "hackatime-project-selector--#{color}")
  end

  def hidden_input_name
    "#{form.object_name}[#{attribute}][]"
  end

  def hidden_input_id_base
    "#{form.object_name}_#{attribute}"
  end

  def project_icon_path
    helpers.asset_path("icons/rocket.svg")
  rescue
    "/assets/icons/rocket.svg"
  end

  def close_icon_path
    helpers.asset_path("icons/close.svg")
  rescue
    "/assets/icons/close.svg"
  end

  def initial_projects
    record = form.object
    if record.respond_to?(:hackatime_projects)
      record.hackatime_projects.select(:id, :name).map do |hp|
        { id: hp.id, name: hp.name, locked: locked_project_names.include?(hp.name) }
      end
    else
      []
    end
  end

  private

  def normalize_color(value)
    symbolized = value.to_sym
    return symbolized if COLORS.include?(symbolized)

    raise ArgumentError, "color must be one of #{COLORS.join(', ')}, got #{value.inspect}"
  end
end
