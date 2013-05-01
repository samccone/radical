// This seems like it could be dried up a bit

module.exports = {

  loginPage: function(req, res) {
    res.render('login', { title: 'Express' });
  },

  twitterAuth: function(req, res){

    var strategy = new TwitterStrategy({
      consumerKey: TWITTER_CONSUMER_KEY,
      consumerSecret: TWITTER_CONSUMER_SECRET,
      callbackURL: "http://localhost:3000/auth/twitter/callback"
    });

    passport.use(strategy, function(token, tokenSecret, profile, done){
      // create user in here then call done
    });

    passport.authenticate('twitter');

  },

  twitterCallback: function(req, res){

    passport.authenticate('twitter', {
      successRedirect: '/',
      failureRedirect: '/auth'
    });

  },

  facebookAuth: function(req, res){

    var strategy = new FacebookStrategy({
      clientID: FACEBOOK_APP_ID,
      clientSecret: FACEBOOK_APP_SECRET,
      callbackURL: "http://localhost:3000/auth/facebook/callback"
    });

    passport.use(strategy, function(accessToken, refreshToken, profile, done) {
      // create user in here then call done
    });

    passport.authenticate('facebook');

  },

  facebookCallback: function(req, res){

    passport.authenticate('facebook', {
      successRedirect: '/',
      failureRedirect: '/auth'
    });

  }

}