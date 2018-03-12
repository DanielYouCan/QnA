shared_examples_for "modelable" do
  context 'assosiation' do
    it { should have_many(:attachments) }
    it { should belong_to(:user) }
  end

  context 'validation' do
    it { should validate_presence_of(:body) }
    it { should validate_length_of(:body).is_at_least(5) }
  end

  context 'nested attributes' do
    it { should accept_nested_attributes_for :attachments }
  end

end
