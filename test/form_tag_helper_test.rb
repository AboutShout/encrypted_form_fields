require 'test_helper'

class FormTagHelperTest < ActionView::TestCase
  tests EncryptedFormFields::Helpers::FormTagHelper

  def test_encrypted_form_tag
    tag = HTML::Document.new(encrypted_field_tag "field", "value").find(tag: "input")
    decrypted_value = EncryptedFormFields.decrypt_and_verify(tag.attributes["value"])
    assert_equal "value", decrypted_value
    assert_equal "_encrypted[field]", tag.attributes["name"]
    assert_equal "hidden", tag.attributes["type"]
    assert_equal "field", tag.attributes["id"]
  end
end
