# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  def prepend_flash
    turbo_stream.prepend 'flash', partial: 'shared/flash'
  end

  def pagination(obj)
    pagy_bootstrap_nav(obj) if obj.pages > 1
  end

  def i18n_model_name(model, count = 1)
    model.model_name.human(count: count)
  end

  def attribute_model(model, attr)
    model.class.human_attribute_name(attr)
  end

  def full_title(page_title = '')
    base_title = t('site_name')
    page_title ? "#{page_title} | #{base_title}" : base_title.to_s
  end

  def currently_at(current_page = '')
    render partial: 'shared/menu', locals: { current_page: current_page }
  end

  def nav_tab(title, url, options = {})
    current_page = options.delete :current_page
    css_text = current_page == title ? 'text-secondary' : 'text-white'
    options[:class] = if options[:class]
                        "#{options[:class]} #{css_text}"
                      else
                        css_text
                      end

    link_to title, url, options
  end

  def params_plus(additional_params)
    params.to_unsafe_h.merge(additional_params)
  end
end
