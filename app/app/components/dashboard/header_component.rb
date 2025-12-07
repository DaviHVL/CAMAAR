class Dashboard::HeaderComponent < ViewComponent::Base
  def initialize(user:)
    @user = user
  end

  def initials
    @user.nome.split.first[0].upcase rescue "U"
  end
end