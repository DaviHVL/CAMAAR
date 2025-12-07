# app/components/button_component.rb
class ButtonComponent < ViewComponent::Base
  def initialize(text:, type: :submit, variant: :primary)
    @text = text
    @type = type
    @variant = variant
  end

  def classes
    base = "w-full py-3 px-4 rounded text-sm font-medium focus:outline-none transition duration-150 shadow-sm"
    
    case @variant
    when :primary
      "#{base} bg-[#22C55E] hover:bg-green-600 text-white" 
    else
      "#{base} bg-gray-500 hover:bg-gray-700 text-white"
    end
  end
end