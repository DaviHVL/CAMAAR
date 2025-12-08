# app/components/form_input_component.rb
class FormInputComponent < ViewComponent::Base
  # Initialize accepts either a model-backed input via `form`+`attribute`
  # or an unbound input via `name` (used in sessions/login view).
  def initialize(label:, form: nil, attribute: nil, name: nil, type: :text, placeholder: "")
    @label = label
    @form = form
    @attribute = attribute
    @name = name
    @type = type
    @placeholder = placeholder

    # If attribute was provided but no explicit name, derive a name fallback
    @name ||= @attribute.to_s if @attribute
  end

  # When using an ERB template, ViewComponent will render that template.
  # The template can access the instance variables set in `initialize`.
end