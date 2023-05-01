require "test_helper"

class Polaris::UrlHelperTest < ActionView::TestCase
  test "polaris_button_to helper with name" do
    assert_dom_equal(
      %(<form class="button_to" method="post" action="/url"><button data-controller="polaris-button test" type="submit" class="Polaris-Button Polaris-Button--plain"><span class="Polaris-Button__Content">\n\n\n    <div class="Polaris-Button__Text">\n      Name\n    </div>\n\n</span>\n</button></form>),
      polaris_button_to("Name", "/url", plain: true, data: {controller: "test"})
    )
  end

  test "polaris_button_to helper with block" do
    assert_dom_equal(
      %(<form class="button_to" method="post" action="/url"><button type="submit" data-controller="polaris-button" class="TestClass Polaris-Button Polaris-Button--iconOnly"><span class="Polaris-Button__Content">\n\n    <div class="Polaris-Button__Icon">\n      <span class="Polaris-Icon">\n    <svg viewbox="0 0 20 20" xmlns="http://www.w3.org/2000/svg" class="Polaris-Icon__Svg" focusable="false" aria-hidden="true"><path d="M8 3.994c0-1.101.895-1.994 2-1.994s2 .893 2 1.994h4c.552 0 1 .446 1 .997a1 1 0 0 1-1 .997h-12c-.552 0-1-.447-1-.997s.448-.997 1-.997h4zm-3 10.514v-6.508h2v6.508a.5.5 0 0 0 .5.498h1.5v-7.006h2v7.006h1.5a.5.5 0 0 0 .5-.498v-6.508h2v6.508a2.496 2.496 0 0 1-2.5 2.492h-5c-1.38 0-2.5-1.116-2.5-2.492z"></path></svg>\n</span>\n    </div>\n\n\n</span>\n</button></form>),
      polaris_button_to("/url", class: "TestClass") { |b| b.with_icon(name: "DeleteMinor") }
    )
  end

  test "polaris_link_to helper with name" do
    assert_dom_equal(
      %(<a plain="true" data-controller="test" href="/url" data-polaris-unstyled="true" class="Polaris-Link">Name</a>),
      polaris_link_to("Name", "/url", plain: true, data: {controller: "test"})
    )
  end

  test "polaris_link_to helper with block" do
    assert_dom_equal(
      %(<a class="TestClass" href="/url" data-polaris-unstyled="true" class="Polaris-Link">Name</a>),
      polaris_link_to("/url", class: "TestClass") { "Name" }
    )
  end

  test "polaris_mail_to helper with email" do
    assert_dom_equal(
      %(<a href="mailto:me@domain.com" data-polaris-unstyled="true" class="Polaris-Link">My email</a>),
      polaris_mail_to("me@domain.com", "My email")
    )
  end

  test "polaris_mail_to helper with block" do
    assert_dom_equal(
      %(<a href="mailto:me@domain.com" data-polaris-unstyled="true" class="Polaris-Link">Email me</a>),
      polaris_mail_to("me@domain.com") { "Email me" }
    )
  end
end
