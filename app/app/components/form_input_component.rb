# Componente de interface reutilizável para renderizar campos de entrada (inputs) de formulário.
# Abstrai a complexidade de estilização (CSS) e estrutura HTML (Label + Input),
# garantindo consistência visual em toda a aplicação.
#
# Suporta dois modos de operação:
# 1. Baseado em Modelo (Model-Backed): Usando `form` e `attribute` (ex: Cadastro de Usuário).
# 2. Baseado em Tag (Tag-Based): Usando apenas `name` (ex: Login, onde não há model direto).
class FormInputComponent < ViewComponent::Base
  
  # Inicializa o componente aceitando tanto um input ligado a um modelo via `form`+`attribute`
  # quanto um input livre via `name` (usado nas views de sessão/login).
  #
  # Args:
  #   - label: (String) O texto do rótulo exibido acima do campo.
  #   - form: (ActionView::Helpers::FormBuilder | nil) O objeto construtor do formulário.
  #   - attribute: (Symbol | nil) O nome do atributo do modelo (ex: :email).
  #   - name: (String | nil) O atributo 'name' do input HTML (usado quando não há `form`).
  #   - type: (Symbol) O tipo do input HTML (:text, :password, :email, etc.). Padrão: :text.
  #   - placeholder: (String) Texto de ajuda exibido dentro do campo quando vazio.
  #
  # Retorno: Uma nova instância do componente FormInputComponent.
  #
  # Efeitos Colaterais:
  #   - Define variáveis de instância para uso no template.
  #   - Lógica de Fallback: Se `attribute` for fornecido mas `name` não, define `name` baseado no atributo.
  def initialize(label:, form: nil, attribute: nil, name: nil, type: :text, placeholder: "")
    @label = label
    @form = form
    @attribute = attribute
    @name = name
    @type = type
    @placeholder = placeholder

    # Se o atributo foi fornecido mas nenhum 'name' explícito, deriva um nome de fallback baseando-se no atributo
    @name ||= @attribute.to_s if @attribute
  end

  # Ao usar um template ERB, o ViewComponent renderizará esse template automaticamente.
  # O template pode acessar as variáveis de instância definidas em `initialize`.
end