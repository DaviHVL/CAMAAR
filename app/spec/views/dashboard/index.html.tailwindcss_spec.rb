require 'rails_helper'

RSpec.describe "dashboard/index", type: :view do
  it 'carrega o contexto da view do dashboard' do
    expect { view }.not_to raise_error
  end
end
