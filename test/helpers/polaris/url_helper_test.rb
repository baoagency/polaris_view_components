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
      %(<form class="button_to" method="post" action="/url"><button type="submit" data-controller="polaris-button" class="TestClass Polaris-Button Polaris-Button--iconOnly"><span class="Polaris-Button__Content">\n\n    <div class="Polaris-Button__Icon">\n      <span class="Polaris-Icon">\n    <svg viewbox="0 0 20 20" xmlns="http://www.w3.org/2000/svg" class="Polaris-Icon__Svg" focusable="false" aria-hidden="true"><path d="M8 3.994C8 2.893 8.895 2 10 2s2 .893 2 1.994h4c.552 0 1 .446 1 .997a1 1 0 0 1-1 .997H4c-.552 0-1-.447-1-.997s.448-.997 1-.997h4zM5 14.508V8h2v6.508a.5.5 0 0 0 .5.498H9V8h2v7.006h1.5a.5.5 0 0 0 .5-.498V8h2v6.508A2.496 2.496 0 0 1 12.5 17h-5C6.12 17 5 15.884 5 14.508z"></path></svg>\n</span>\n    </div>\n\n\n</span>\n</button></form>),
      polaris_button_to("/url", class: "TestClass") { |b| b.icon(name: "DeleteMinor") }
    )
  end
end
