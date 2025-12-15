require 'rails_helper'

RSpec.describe QuestaoRespondida, type: :model do
  it 'instancia corretamente' do
    expect(QuestaoRespondida.new).to be_a(QuestaoRespondida)
  end
end
