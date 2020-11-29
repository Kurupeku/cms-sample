module ApplicationHelper
  def check_active(target_path, exactly: false)
    if exactly
      target_path == request.path ? 'active' : ''
    else
      Regexp.new(target_path) =~ request.path ? 'active' : ''
    end
  end

  def check_uk_active(target_path, exactly: false)
    if exactly
      target_path == request.path ? 'uk-active' : ''
    else
      Regexp.new(target_path) =~ request.path ? 'uk-active' : ''
    end
  end
end
