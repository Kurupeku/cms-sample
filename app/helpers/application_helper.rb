module ApplicationHelper
  PARAMETER_REGEXP = Regexp.new '[#\?].+\Z'
  DEFINED_ALERT_KEYS = %w[primary success warning danger].freeze

  def full_title(page_title = nil)
    return @setting.site_title if page_title.blank?

    "#{page_title} | #{@setting.site_title}"
  end

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

    "uk-background-#{key}"
  end

  def check_uk_active_sort_tab(sym)
    return '' unless sym == @search.sorts[0]&.name&.to_sym

    'uk-active'
  end

  def main_cover_anable?
    request.path == root_path && @setting.anable_recent_popular && @setting.main_cover.attached?
  end

  def articles_per_url(default_key, per)
    sort_key = @search.sorts[0]&.name&.to_sym || default_key
    ransack_url = sort_url @search, sort_key
    url = if ransack_url.include? '+asc'
            ransack_url.gsub '+asc', '+desc'
          else
            ransack_url.gsub '+desc', '+asc'
          end
    [url, '&per=', per].join
  end

  def main_container_classes
    "uk-container#{@side_menu ? '' : ' uk-container-small'}#{request.path == '/' ? '' : ' breadcrumbs-padding'}"
  end

  def main_area_classes
    return 'uk-width-3-4@m' if @side_menu

    'uk-width-1-1'
  end
end
