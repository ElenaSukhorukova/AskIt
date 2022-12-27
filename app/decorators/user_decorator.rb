# frozen_string_literal: true

class UserDecorator < ApplicationDecorator
  decorates_finders
  delegate_all

  def name_or_email
    return username.split.map(&:capitalize).join(' ') if username.present?

    email.split('@')[0].capitalize
  end

  def formatted_updated_at
    l updated_at, format: :long
  end
end
