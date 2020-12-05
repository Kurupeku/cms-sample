module ApplicationHelper
  PARAMETER_REGEXP = Regexp.new '[#\?].+\Z'
  DEFINED_ALERT_KEYS = %w[primary success warning danger].freeze

  def check_active(target_path, exactly: false)
    if exactly
      target_path == path_without_params ? 'active' : ''
    else
      Regexp.new(target_path) =~ path_without_params ? 'active' : ''
    end
  end

  def check_uk_active(target_path, exactly: false)
    if exactly
      target_path == path_without_params ? 'uk-active' : ''
    else
      Regexp.new(target_path) =~ path_without_params ? 'uk-active' : ''
    end
  end

  def path_without_params
    request.path&.gsub(PARAMETER_REGEXP, '') || ''
  end

  def url_without_params
    request.url&.gsub(PARAMETER_REGEXP, '') || ''
  end

  def encoded_string(str)
    URI.encode_www_form_component str
  end

  def uk_alert_class_name(key)
    return '' unless DEFINED_ALERT_KEYS.include?(key)

    "uk-alert-#{key}"
  end
end
