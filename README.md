# Cybersourcery Demo Site

This is a Rails app for demonstrating [the Cybersourcery gem](https://github.com/promptworks/cybersourcery) and [the Cybersourcery Testing gem](https://github.com/promptworks/cybersourcery_testing).

## Features

The Cybersourcery gem does not dictate how you build your application's checkout system. This project illustrates how to use all of the gem's features. See the gem's README for links to specific examples, or review these files in the following order for a general overview:

1. Config and setup

  The gems include generators for these files.
  
  ```
  config/
    cybersourcery_profiles.yml
    initializers/
      cybersourcery.rb
  .env
  ```
   
2. Sample shopping cart

  ```
  app/
    controllers/
      carts_controller.rb
    views/
      carts/
        new.html.slim
  ```

3. Sample payment form

  ```
  app/
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

4. Test setup and feature specs

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
