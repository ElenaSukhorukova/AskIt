# frozen_string_literal: true

class ApplicationDecorator < Draper::Decorator
  def formatted_created_at
    l created_at, format: :long
  end
end
