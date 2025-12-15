# Módulo auxiliar para gerenciar a lógica de visualização relacionada à sessão do usuário.
#
# Embora a lógica principal de autenticação (como current_user e logged_in?)
# esteja frequentemente centralizada no ApplicationController e exposta via helper_method,
# este módulo serve como namespace reservado para helpers específicos das views de login/logout
# (ex: formatação de mensagens de boas-vindas, links condicionais de sessão) em expansões futuras.
module SessionsHelper
end
