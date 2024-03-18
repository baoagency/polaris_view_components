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
      %(<form class="button_to" method="post" action="/url"><button type="submit" data-controller="polaris-button" class="TestClass Polaris-Button Polaris-Button--iconOnly"><span class="Polaris-Button__Content">\n\n    <div class="Polaris-Button__Icon">\n      <span class="Polaris-Icon">\n    <svg viewbox="0 0 20 20" xmlns="http://www.w3.org/2000/svg" class="Polaris-Icon__Svg" focusable="false" aria-hidden="true"><path d="M11.5 8.25a.75.75 0 0 1 .75.75v4.25a.75.75 0 0 1-1.5 0v-4.25a.75.75 0 0 1 .75-.75Z"></path><path d="M9.25 9a.75.75 0 0 0-1.5 0v4.25a.75.75 0 0 0 1.5 0v-4.25Z"></path><path fill-rule="evenodd" d="M7.25 5.25a2.75 2.75 0 0 1 5.5 0h3a.75.75 0 0 1 0 1.5h-.75v5.45c0 1.68 0 2.52-.327 3.162a3 3 0 0 1-1.311 1.311c-.642.327-1.482.327-3.162.327h-.4c-1.68 0-2.52 0-3.162-.327a3 3 0 0 1-1.311-1.311c-.327-.642-.327-1.482-.327-3.162v-5.45h-.75a.75.75 0 0 1 0-1.5h3Zm1.5 0a1.25 1.25 0 1 1 2.5 0h-2.5Zm-2.25 1.5h7v5.45c0 .865-.001 1.423-.036 1.848-.033.408-.09.559-.128.633a1.5 1.5 0 0 1-.655.655c-.074.038-.225.095-.633.128-.425.035-.983.036-1.848.036h-.4c-.865 0-1.423-.001-1.848-.036-.408-.033-.559-.09-.633-.128a1.5 1.5 0 0 1-.656-.655c-.037-.074-.094-.225-.127-.633-.035-.425-.036-.983-.036-1.848v-5.45Z"></path></svg>\n</span>\n    </div>\n\n\n</span>\n</button></form>),
      polaris_button_to("/url", class: "TestClass") { |b| b.with_icon(name: "DeleteIcon") }
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
