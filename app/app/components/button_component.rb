# Componente de interface reutilizável para renderizar botões ou links com estilo de botão.
# Padroniza a aparência da aplicação, oferecendo variantes de cores pré-definidas (primary, secondary, etc.)
# e encapsulando as classes utilitárias do Tailwind CSS.
class ButtonComponent < ViewComponent::Base
  
  # Inicializa o componente com as configurações de exibição e comportamento.
  #
  # Args:
  #   - text: (String) O rótulo/texto a ser exibido dentro do botão.
  #   - type: (Symbol) O tipo do botão HTML (ex: :submit, :button). Padrão: :submit.
  #   - variant: (Symbol) O esquema de cores (:primary, :secondary, :tertiary). Padrão: :primary.
  #   - link: (String/nil) Se fornecido, o componente renderiza um link (<a>) em vez de um <button>.
  #
  # Retorno: Uma nova instância do componente ButtonComponent.
  #
  # Efeitos Colaterais: Atribui os parâmetros às variáveis de instância para uso no template.
  def initialize(text:, type: :submit, variant: :primary, link: nil)
    @text = text
    @type = type
    @variant = variant
    @link = link
  end

  # Gera a string completa de classes CSS (Tailwind) baseada na variante escolhida.
  # Combina estilos base (padding, bordas, foco) com estilos específicos de cor.
  #
  # Args: Nenhum
  #
  # Retorno:
  #   - String: Uma lista de classes CSS separadas por espaço.
  #
  # Efeitos Colaterais: Nenhum.
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