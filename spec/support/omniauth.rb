OmniAuth.config.test_mode = true

OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
  provider: 'twitter',
  uid:      '123545',
  info: {
    name: 'Paul Smith',
    email: 'paul.smith@gmail.com',
    nickname: 'paulie',
    image: 'http://pbs.twimg.com/profile_images/2437172008/62jzehzum66dhmdwslfu_normal.jpeg'
  }
})

OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
  provider: 'facebook',
  uid:      '1337',
  info: {
    name: 'Not Paul Smith',
    email: 'not.paul.smith@gmail.com',
    image: 'https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xpf1/v/t1.0-1/c0.5.50.50/p50x50/10905_10152697793558706_4035448148486150943_n.jpg?oh=7acf376bdb74b466134c0b2012adef6d&oe=561E3C3A&__gda__=1447955979_637fe2cc8fdee5ce835c90f25741c243'
  },
  extra: {
    raw_info: {
      locale: 'en_US'
    }
  }
})

OmniAuth.config.mock_auth[:google] = OmniAuth::AuthHash.new({
  provider: 'google',
  uid:      '007',
  info: {
    name: 'Google user',
    email: 'google-user@gmail.com',
    image: 'https://lh5.googleusercontent.com/-vB8_p-33Rl8/AAAAAAAAAAI/AAAAAAAAAkk/XQ0O9DKBJv8/photo.jpg'
  },
  extra: {
    raw_info: {
      locale: 'en'
    }
  }
})
