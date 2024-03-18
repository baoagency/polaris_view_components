require "test_helper"

class PaginationComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_default_page
    render_inline(Polaris::PageComponent.new(title: "Page Title")) do
      "Page Content"
    end

    assert_selector ".Polaris-Page" do
      assert_selector ".Polaris-Page-Header--noBreadcrumbs" do
        assert_selector ".Polaris-Page-Header__TitleWrapper" do
          assert_selector ".Polaris-Header-Title__TitleAndSubtitleWrapper" do
            assert_selector "h1.Polaris-Header-Title", text: "Page Title"
          end
        end
      end
      assert_text "Page Content"
    end
  end

  def test_page_with_subtitle
    render_inline(Polaris::PageComponent.new(subtitle: "Page Subtitle"))

    assert_selector ".Polaris-Header-Title__TitleAndSubtitleWrapper" do
      assert_selector ".Polaris-Header-Title__SubTitle", text: "Page Subtitle"
    end
  end

  def test_page_with_back_button
    render_inline(Polaris::PageComponent.new(back_url: "/back"))

    assert_selector ".Polaris-Page-Header--hasNavigation" do
      assert_selector ".Polaris-Page-Header__Row" do
        assert_selector ".Polaris-Page-Header__BreadcrumbWrapper nav" do
          assert_selector "a.Polaris-Breadcrumbs__Breadcrumb[href='/back']" do
            assert_selector ".Polaris-Breadcrumbs__ContentWrapper > .Polaris-Breadcrumbs__Icon > .Polaris-Icon"
          end
        end
      end
    end
  end

  def test_page_with_primary_action
    render_inline(Polaris::PageComponent.new(title: "Page Title")) do |page|
      page.with_primary_action { "Primary Button" }
    end

    assert_selector ".Polaris-Page-Header__RightAlign" do
      assert_selector ".Polaris-Page-Header__PrimaryActionWrapper" do
        assert_selector ".Polaris-Button--primary", text: "Primary Button"
      end
    end
  end

  def test_page_without_header
    render_inline(Polaris::PageComponent.new) do
      "Page Content"
    end

    assert_no_selector ".Polaris-Page-Header"
    assert_selector ".Polaris-Page__Content", text: "Page Content"
  end

  def test_full_width_page
    render_inline(Polaris::PageComponent.new(full_width: true))

    assert_selector ".Polaris-Page.Polaris-Page--fullWidth"
  end

  def test_narrow_width_page
    render_inline(Polaris::PageComponent.new(narrow_width: true))

    assert_selector ".Polaris-Page.Polaris-Page--narrowWidth"
  end

  def test_page_with_divider
    render_inline(Polaris::PageComponent.new(title: "Title", divider: true)) do
      "Page Content"
    end

    assert_selector ".Polaris-Page--divider", text: "Page Content"
  end

  def test_page_with_title_metadata
    render_inline(Polaris::PageComponent.new(title: "Page Title")) do |page|
      page.with_title_metadata { "Title Metadata" }
    end

    assert_selector ".Polaris-Page-Header__TitleWrapper" do
      assert_selector ".Polaris-Header-Title__TitleAndSubtitleWrapper" do
        assert_selector ".Polaris-Header-Title__TitleWithMetadataWrapper" do
          assert_selector ".Polaris-Header-Title", text: "Page Title"
          assert_selector ".Polaris-Header-Title__TitleMetadata", text: "Title Metadata"
        end
      end
    end
  end

  def test_secondary_actions
    render_inline(Polaris::PageComponent.new(
      title: "Page Title",
      secondary_actions: [
        {content: "Duplicate", url: "/duplicate"},
        {content: "Download", url: "/download", icon_name: "ArrowDownIcon"}
      ]
    )) do
      "Page Content"
    end

    assert_selector ".Polaris-ActionMenu--mobile" do
      assert_selector ".Polaris-ActionList__Item", text: "Duplicate"
      assert_selector ".Polaris-ActionList__Item", text: "Download" do
        assert_selector ".Polaris-ActionList__Prefix > .Polaris-Icon"
      end
    end
    assert_selector ".Polaris-ActionMenu--desktop" do
      assert_selector ".Polaris-ActionMenu-SecondaryAction", text: "Duplicate"
      assert_selector ".Polaris-ActionMenu-SecondaryAction", text: "Download" do
        assert_selector ".Polaris-Button .Polaris-Button__Icon"
      end
    end
  end

  def test_action_group
    render_inline(Polaris::PageComponent.new(title: "Page Title")) do |page|
      page.with_action_group(
        title: "Promote",
        actions: [
          {content: "Share on Facebook", url: "https://facebook.com"},
          {content: "Share on Twitter", url: "https://twitter.com"}
        ]
      )
      "Page Content"
    end

    assert_selector ".Polaris-ActionMenu--mobile" do
      assert_selector ".Polaris-Popover .Polaris-ActionList" do
        assert_text "Promote"
        assert_selector ".Polaris-ActionList__Item", text: "Share on Facebook"
        assert_selector ".Polaris-ActionList__Item", text: "Share on Twitter"
      end
    end
    assert_selector ".Polaris-ActionMenu--desktop" do
      assert_selector ".Polaris-ActionMenu-SecondaryAction", text: "Promote"
      assert_selector ".Polaris-Popover .Polaris-ActionList" do
        assert_selector ".Polaris-ActionList__Item", text: "Share on Facebook"
        assert_selector ".Polaris-ActionList__Item", text: "Share on Twitter"
      end
    end
  end

  def test_compact_title
    render_inline(Polaris::PageComponent.new(
      title: "Page Title",
      subtitle: "Page Subtitle",
      compact_title: true
    )) do
      "Page Content"
    end

    assert_selector ".Polaris-Header-Title__SubTitle.Polaris-Header-Title__SubtitleCompact"
  end

  def test_pagination_links
    render_inline(Polaris::PageComponent.new(
      title: "Page Title",
      prev_url: "/prev",
      next_url: "/next"
    )) do
      "Page Content"
    end

    assert_selector ".Polaris-Page-Header__PaginationWrapper" do
      assert_selector ".Polaris-Button--iconOnly", count: 2
    end
  end
end
