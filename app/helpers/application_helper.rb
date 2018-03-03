module ApplicationHelper
  FLASH_CLASS = {
      'notice' =>'alert alert-info', 'success' => 'alert alert-success',
      'error' => 'alert alert-danger', 'alert' => 'alert alert-warning' }

  def flash_class(key)
    FLASH_CLASS[key]
  end

  def user_name(resource)
    resource.user.username
  end

  def greeting
    greeting = "Hello, " + content_tag(:b, current_user.username)
    greeting.html_safe
  end
end
