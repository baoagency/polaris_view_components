require "test_helper"

class LinkComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_renders_default_link
    render_inline(Polaris::LinkComponent.new(url: "shopify.com")) { "Default" }

    assert_selector "a.Polaris-Link[href='shopify.com']", text: "Default"
  end

  def test_renders_monochrome_link
    render_inline(Polaris::LinkComponent.new(url: "shopify.com", monochrome: true)) { "Monochrome" }

    assert_selector "a.Polaris-Link.Polaris-Link--monochrome"
  end

  def test_renders_external_link
    render_inline(Polaris::LinkComponent.new(url: "shopify.com", external: true)) do
      "External"
    end

    assert_selector "a.Polaris-Link[rel='noopener noreferrer'][target='_blank']", text: "External"
  end

  def test_no_underline
    render_inline(Polaris::LinkComponent.new(url: "shopify.com", no_underline: true)) { "Default" }

    assert_selector "a.Polaris-Link.Polaris-Link--removeUnderline"
  end

  def test_html_content
    render_inline(Polaris::LinkComponent.new(url: "shopify.com")) do
      tag.div id: "nested-html"
    end

    assert_selector "a.Polaris-Link > #nested-html"
  end
end
