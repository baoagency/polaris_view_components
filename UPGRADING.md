# Upgrading guide

## Upgrading to `v4.0.0`

Version 4 updates the styles to the new Polaris design language used in the Shopify admin (the same look as [Polaris web components](https://shopify.dev/docs/api/app-home/web-components)). Existing component helpers and arguments remain available, but rendered markup and several defaults have changed. Review custom CSS, JavaScript, and tests that depend on the component DOM before upgrading.

Visual changes to review in your app:

- Page background is white, and cards use a larger radius with a soft shadow instead of a bevel.
- Buttons are pill-shaped. Secondary buttons have a flat gray fill, primary buttons are black, and destructive buttons use a soft red fill.
- Text fields, selects, checkboxes, and radio buttons use shadow outlines and a blue focus ring.
- Banners use a full tinted background and filled status icons by default (`InfoFilledIcon`, `CheckCircleFilledIcon`, `AlertCircleFilledIcon`). Pass `icon:` to `polaris_banner` to keep a different icon. Badges and avatars use the new color palette.
- Tabs are displayed as pills, and the `Navigation` sidebar uses the dark admin theme.
- Typography uses regular (400) body text and medium (500) headings, set in the bundled `ShopifyInter` font (the Inter fork used in the Shopify admin), with Inter as a fallback for other scripts.

If you override Polaris CSS custom properties (for example `--p-color-bg-app` or `--p-color-bg-fill-brand`), check that your overrides still apply, since many tokens have new values.

Markup and default changes to account for:

- Cards place the header outside a new `.Polaris-LegacyCard__Surface` wrapper, which contains tabs, sections, content, and footer actions. Update direct-child selectors accordingly. Unstyled sections now have a `.Polaris-LegacyCard__Section--unstyled` class.
- Card footer actions default to left alignment, with the primary action first. Pass `footer_action_alignment: :right` to retain the previous alignment and order. Header and section actions now use normal buttons by default; pass `plain: true` on individual actions to retain link styling.
- Banners use new heading, message, and action wrappers. Messages always appear below a heading, and action buttons occupy a separate row. Update selectors targeting the previous top-bar or content structure.
- Loading buttons render `.Polaris-Button__Spinner` directly inside the button, alongside `.Polaris-Button__Content`. Both button and standalone spinners now use SVG circles instead of paths.
- Callout illustrations have a new `.Polaris-CalloutCard__Illustration` wrapper and are omitted when no illustration is provided. Secondary actions default to tertiary styling; pass `monochrome: false, remove_underline: false` to retain plain link styling.
- Resource-item shortcut actions expose a compact overflow menu on narrow or touch layouts. Persistent actions default to tertiary styling.
- Drop zones use new upload-content, icon, and help-text wrappers. Review any custom selectors for the previous stack layout.
- Progress bars default to the dark `:primary` color. Pass `color: :highlight` to retain the previous blue default.

## Upgrading to `v3.0.0`

Version 3 updates the supported Ruby, Rails, and ViewComponent versions. Before upgrading, make sure your application uses:

- Ruby 3.2 or newer
- Rails 7.1 or newer
- ViewComponent 3.0 or newer and earlier than 4.2

Version 3 adds support for Rails 8.1 and ViewComponent 4.1. It also removes the `polaris_view_components:detect_legacy_slots` and `polaris_view_components:migrate_legacy_slots` tasks, which were provided for the earlier ViewComponent 3 slot API migration.

No application markup changes are required when upgrading from the latest v2 release, provided the application already meets the runtime requirements above.

## Upgrading to `v2.0.0`

This release updates UI to Polaris v12 styles. Required changes after gem upgrade:

1. Add `polaris_html_classes` to your `html` tag in layouts:

```erb
<html class="<%= polaris_html_classes %>" style="<%= polaris_html_styles %>">
```

2. Update icon names in your app. Naming convention in Polaris Icons v12 changed. There's no more separation to `Minor` and `Major` icons. All icons have `Icon` suffix. New icon names can be found in Polaris documentation: https://polaris.shopify.com/icons
