# frozen-string-literal: true

module EncryptedFormFields
  module EncryptedParameters
    # Decrypt encrypted parameters
    def encrypted_params
      @encrypted_params ||=
        EncryptedFormFields.decrypt_parameters(params["_encrypted"] || {})
    end

    def decrypted_params
      @decrypt_params ||= params.to_h.merge(encrypted_params)
    end
  end
end
