# app/components/form_input_component.rb
class FormInputComponent < ViewComponent::Base
  def initialize(label:, name:, type: :text, placeholder: "")
    @label = label
    @name = name
    @type = type
    @placeholder = placeholder
  end
end