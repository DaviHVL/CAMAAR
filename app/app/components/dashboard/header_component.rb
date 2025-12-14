# Namespace que agrupa os componentes visuais exclusivos da área administrativa (Dashboard).
# Contém elementos de layout como cabeçalho e barra lateral.
module Dashboard
  # Componente visual responsável por renderizar o cabeçalho superior do dashboard.
  # Centraliza a lógica de exibição do título da página e do avatar do usuário,
  # adaptando-se ao contexto (Admin ou Usuário comum).
  class HeaderComponent < ViewComponent::Base
    
    # Inicializa o componente com os dados necessários para renderização.
    #
    # Args:
    #   - user (Usuario): O usuário logado atualmente.
    #   - path (String): O caminho da URL atual (request.path) para decisão do título.
    #
    # Retorno: Uma nova instância do componente.
    #
    # Efeitos Colaterais: Define as variáveis de instância @user e @path.
    def initialize(user:, path:)
      @user = user
      @path = path
    end

    # Extrai a primeira letra do nome do usuário para exibir no avatar (círculo de perfil).
    # Possui tratamento de erro (rescue) para garantir uma exibição padrão caso o nome seja inválido.
    #
    # Args: Nenhum
    #
    # Retorno:
    #   - String: A primeira letra do nome em maiúsculo (ex: "D").
    #   - String: "U" (default) caso ocorra erro ou o nome seja nulo.
    #
    # Efeitos Colaterais: Nenhum.
    def initials
      @user.nome.to_s.first.upcase
    rescue
      "U"
    end

    # Determina o título textual da página baseado na rota atual.
    # Diferencia visualmente a área administrativa da área de avaliações comuns.
    #
    # Args: Nenhum
    #
    # Retorno:
    #   - String: "Gerenciamento" se a URL começar com "/admin".
    #   - String: "Avaliações" para as demais rotas.
    #
    # Efeitos Colaterais: Nenhum.
    def title
      if @path.start_with?("/admin")
        "Gerenciamento"
      else
        "Avaliações"
      end
    end
  end
end