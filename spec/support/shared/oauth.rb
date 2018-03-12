shared_examples_for "Oauthenticable" do
  context 'user is persisted but authorization is not confirmed' do
    let!(:authorization) { create(:authorization, confirmed: false, provider: provider, uid: '123456', user: user ) }
    before { get provider.to_sym }

    it 'redirects to login page' do
      expect(response).to redirect_to new_user_session_path
    end

    it 'shows certain flash message' do
      expect(controller).to set_flash[:notice]
    end
  end

  context 'user is persisted and authorization is confirmed' do
    let!(:authorization) { create(:authorization, provider: provider, uid: '123456', user: user ) }
    before { get provider.to_sym }

    it 'signs in user' do
      expect(subject.current_user).to eq user
    end

    it 'sets flash message' do
      expect(controller).to set_flash[:notice]
    end
  end
end
