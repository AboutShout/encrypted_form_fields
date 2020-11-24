# EncryptedFormFields

Encrypted form fields for Rails apps.

[![Build Status](https://travis-ci.org/lautis/encrypted_form_fields.svg)](https://travis-ci.org/lautis/encrypted_form_fields)
[![Gem Version](https://badge.fury.io/rb/encrypted_form_fields.svg)](http://badge.fury.io/rb/encrypted_form_fields)

## Installation

Add this line to your application's Gemfile:

    gem 'encrypted_form_fields'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install encrypted_form_fields

## Usage

Configure necessary encryption keys in Rails initializer:

```ruby
EncryptedFormFields.secret_key_base = # your secret key base
EncryptedFormFields.secret_token = # your secret token

```

Create encrypted inputs in your view:

```erb

<%= form_for(user) do |f| %>
  <%= f.encrypted_field :secrets %>
  <%= encrypted_field_tag :field_name, "secret data" %>
<% end %>

```

Then access the data in controller:

```ruby

class SomeController
  def create
    # do stuff...
    encrypted_params # This will contain values of encrypted parameters
    # do stuff...
  end
end
```

## Rack Middleware

Have the decrypted params added directly to params using Rack middleware. The decrypted params take precedence over all other params. Configure to use the middleware by adding this to your application.rb.

```ruby

module YourProject
  class Application < Rails::Application

    # do stuff...

    # Options:
    #   encrypted_param_prefix: Param's encrypted fields prefix. Default: "_encrypted"
    #   remove_raw_encrypted_params: True will remove the "_encrypted" sub has from your params. Default: false
    config.middleware.use EncryptedFormFields::AutoDecryptEncryptedParamsMiddleware, remove_raw_encrypted_params: true

    # do stuff...

  end
end
```

## Contributing

1. Fork it ( http://github.com/lautis/encrypted_form_fields/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
