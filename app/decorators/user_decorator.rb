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

  def gravatar(size: 30, css_class: '')
    h.image_tag "https://www.gravatar.com/avatar/#{gravatar_hash}.ipg?s=#{size}", 
      class: "rounded #{css_class}", alt: name_or_email
  end
end
