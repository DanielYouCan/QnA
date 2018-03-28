module OmniauthMacros
  def mock_auth_hash_twitter
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
      'provider' => 'twitter',
      'uid' => '123456',
      'info' => {
        'nickname' => 'mockuser',
        'image' => 'mock_user_thumbnail_url'
      },
      'credentials' => {
        'token' => 'mock_token',
        'secret' => 'mock_secret'
      }
    })
  end

  def mock_auth_hash_facebook
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
      'provider' => 'facebook',
      'uid' => '123456',
      'info' => {
        'email' => 'mock@mock.com',
        'nickname' => 'mockuser',
        'image' => 'mock_user_thumbnail_url'
      },
      'credentials' => {
        'token' => 'mock_token',
        'secret' => 'mock_secret'
      }
    })
  end

  def mock_auth_hash_vkontakte
    OmniAuth.config.mock_auth[:vkontakte] = OmniAuth::AuthHash.new({
      'provider' => 'vkontakte',
      'uid' => '123456',
      'info' => {
        'email' => 'mock@mock.com',
        'nickname' => 'mockuser',
        'image' => 'mock_user_thumbnail_url'
      },
      'credentials' => {
        'token' => 'mock_token',
        'secret' => 'mock_secret'
      }
    })
  end
end
