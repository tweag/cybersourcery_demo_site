# Cybersourcery Demo Site

This is a Rails app for demonstrating [the Cybersourcery gem](https://github.com/promptworks/cybersourcery) and [the Cybersourcery Testing gem](https://github.com/promptworks/cybersourcery_testing).

## Features

The Cybersourcery gems do not dictate how you build your application's checkout system. You can use whichever subset of features are appropriate for your project. This demo project illustrates how to use all of the gems' features. See the gems' README for links to specific examples of the various features, or review the files listed below for a general overview:

1. Config and setup:
  
  ```
  .env
  Gemfile
  config/
    cybersourcery_profiles.yml
    initializers/
      cybersourcery.rb
    routes.rb
  ```
   
  The Cybersourcery gem includes generators for `cybersourcery.rb` and `cybersourcery_profiles.yml`. The Cybersourcery Testing gem includes a generator for the `.env` file.
  
2. Sample, super-simple shopping cart:

  ```
  app/
    controllers/
      carts_controller.rb
    views/
      carts/
        new.html.slim
  ```

3. Sample payment form:

  ```
  app/
    assets/
      javascripts/
        payments.js.coffee
      stylesheets/
        payments.css.scss
    controllers/
      payments_controller.rb
    models/
      my_payment.rb
    views/
      payments
        confirm.html.slim
        error.html.slim
        pay.html.slim        
  ```
  
  Note that the Cybersourcery gem includes helpers for use with Simple Form, but Simple Form is not required.
  
4. Test setup and feature specs (applicable to the Cybersourcery Testing gem only):

  ```
  cybersourcery_proxy_custom.rb
  spec/
    cassettes/
      cybersourcery.yml
    features/
      payments_spec.rb
  ```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/cybersourcery_demo_site/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
