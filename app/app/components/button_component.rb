class ButtonComponent < ViewComponent::Base
  def initialize(text:, type: :submit, variant: :primary, link: nil)
    @text = text
    @type = type
    @variant = variant
    @link = link
  end

  def classes
    base = "w-full inline-block py-3 px-6 rounded font-bold text-sm text-center focus:outline-none transition duration-150 shadow-md cursor-pointer"
    
    case @variant
    when :primary
      # Importar Dados (Verde mais escuro)
      "#{base} bg-green-600 hover:bg-green-700 text-white" 
    when :secondary
      # Editar Templates / Enviar Formulários (Verde médio)
      "#{base} bg-green-400 hover:bg-green-500 text-white" 
    when :tertiary
      # Resultados (Verde mais claro)
      "#{base} bg-green-200 hover:bg-green-300 text-green-800"
    else
      # Padrão
      "#{base} bg-gray-500 hover:bg-gray-700 text-white"
    end
  end
end