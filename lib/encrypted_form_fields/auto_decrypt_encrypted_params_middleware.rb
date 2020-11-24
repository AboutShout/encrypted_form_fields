# frozen-string-literal: true

module EncryptedFormFields
  class AutoDecryptEncryptedParamsMiddleware
    def initialize(app, options = {})
      @app = app
      @encrypted_param_prefix = options[:encrypted_param_prefix] || "_encrypted"
      @remove_raw_encrypted_params = options[:remove_raw_encrypted_params]
    end

    def call(env)
      request = Rack::Request.new(env)
      # Decrypt the params
      the_decrypted_params = EncryptedFormFields.decrypt_parameters(request.params[@encrypted_param_prefix] || {})
      # Remove raw encrypted params
      request.delete_param(@encrypted_param_prefix) if @remove_raw_encrypted_params
      # Merge to get the final tree of any decrypted param key
      merged_params = request.params.deep_merge!(the_decrypted_params)
      # Replace the source param key's value with the merged tree
      the_decrypted_params.each_pair do |key, _|
        request.update_param(key, merged_params[key])
      end

      @app.call(env)
    end
  end
end
