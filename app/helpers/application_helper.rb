module ApplicationHelper
  def i18n_model_name(model, count: 1)
    model.model_name.human(count: count)
  end

  def attribute_model(model, attr)
    model.class.human_attribute_name(attr)
  end
end
