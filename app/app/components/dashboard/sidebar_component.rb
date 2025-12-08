module Dashboard
  class SidebarComponent < ViewComponent::Base
    def initialize(user:)
      @user = user
    end

    def admin?
      @user.is_admin?
    end
  end
end