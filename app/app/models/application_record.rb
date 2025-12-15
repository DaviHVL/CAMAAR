# Classe base abstrata para todos os modelos (Models) da aplicação.
# Atua como uma camada intermediária entre o framework (ActiveRecord::Base)
# e os modelos de negócio (Usuario, Template, Formulario, etc).
#
# A diretiva `primary_abstract_class` informa ao Rails que esta classe
# não possui uma tabela própria no banco de dados e serve apenas para herança.
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
end