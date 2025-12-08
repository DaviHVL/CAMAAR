module Dashboard
  class HeaderComponent < ViewComponent::Base
    def initialize(user:, path:)
      @user = user
      @path = path
    end

    def initials
      @user.nome.to_s.first.upcase
    rescue
      "U"
    end

    def title
      if @path.start_with?("/admin")
        "Gerenciamento"
      else
        "Avaliações"
      end
    end
  end
end