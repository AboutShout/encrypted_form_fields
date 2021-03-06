# frozen-string-literal: true
require "test_helper"
require "nokogiri"
require "encrypted_form_fields/helpers/form_helper"

class FormBuilderTest < MiniTest::Unit::TestCase
  def setup
    super
    @template = Object.new
    @template.extend ActionView::Helpers::FormHelper
    @template.extend EncryptedFormFields::Helpers::FormHelper
    @template.extend ActionView::Helpers::FormOptionsHelper
    @object = Struct.new(:bar).new(SecureRandom.base64)
  end

  def test_encrypted_form_tag
    form_builder = ActionView::Helpers::FormBuilder.new(:foo, @object, @template, {})
    document = Nokogiri::HTML.fragment(form_builder.encrypted_field(:bar))
    tag = document.css("input").first
    decrypted_value = EncryptedFormFields.decrypt_and_verify(tag.attributes["value"].value)
    assert_equal @object.bar, decrypted_value
    assert_equal "_encrypted[foo][bar]", tag.attributes["name"].value
    assert_equal "hidden", tag.attributes["type"].value
    assert_equal "_encrypted_foo_bar", tag.attributes["id"].value
  end
end
