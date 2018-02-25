require 'rails_helper'

shared_examples_for "commentable" do
  it { should have_many(:comments).dependent(:destroy) }

  it { should validate_presence_of :body }
  it { should validate_length_of(:body).is_at_least(5) }
end
