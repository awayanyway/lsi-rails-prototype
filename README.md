lsi-rails-prototype
===================

# deploy on heroku

  heroku create yourappname


  heroku labs:enable user-env-compile

  heroku config:set BUNDLE_WITHOUT="development:developments3:test:localserver"

  heroku config:add BUILDPACK_URL=https://github.com/ddollar/heroku-buildpack-multi

  heroku config:add LD_LIBRARY_PATH=/app/vendor/openbabel/lib


  heroku labs:enable websockets 

  heroku addons:add sendgrid


