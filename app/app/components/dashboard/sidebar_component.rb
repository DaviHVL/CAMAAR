module Dashboard
  # Componente visual responsável por renderizar a barra lateral de navegação (Sidebar).
  # Gerencia a exibição dos links de menu, adaptando-os dinamicamente
  # com base no perfil do usuário (Administrador ou Comum).
  class SidebarComponent < ViewComponent::Base
    
    # Inicializa o componente com os dados do usuário para controle de permissões.
    #
    # Args:
    #   - user (Usuario): O usuário logado atualmente.
    #
    # Retorno: Uma nova instância do componente.
    #
    # Efeitos Colaterais: Define a variável de instância @user.
    def initialize(user:)
      @user = user
    end

    # Helper utilizado no template para verificar permissões de administrador.
    # Determina se os menus de gestão (Criar Template, Importar Turmas) devem ser exibidos.
    #
    # Args: Nenhum
    #
    # Retorno:
    #   - Boolean: true se o usuário for administrador, false caso contrário.
    #
    # Efeitos Colaterais: Nenhum.
    def admin?
      @user.is_admin?
    end
  end
end