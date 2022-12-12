class UserDecorator < ApplicationDecorator
  decorates_finders
  delegate_all

  def name_or_email
    return username.split(' ').map(&:capitalize).join(' ') if username.present?

    email.split('@')[0].capitalize
  end
end
