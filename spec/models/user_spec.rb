require 'rails_helper'

RSpec.describe User, type: :model do
  context 'assosiation' do
    it { should have_many(:questions) }
  end
  
  context 'validation' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
  end
end
