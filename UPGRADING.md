# Upgrading guide

## Upgrading to `v4.0.0`

Version 4 updates the styles to the new Polaris design language used in the Shopify admin (the same look as [Polaris web components](https://shopify.dev/docs/api/app-home/web-components)). Components, their arguments, and the rendered markup are unchanged, so no application code changes are required.

Visual changes to review in your app:

- Page background is white, and cards use a larger radius with a soft shadow instead of a bevel.
- Buttons are pill-shaped. Secondary buttons have a flat gray fill, primary buttons are black, and destructive buttons use a soft red fill.
- Text fields, selects, checkboxes, and radio buttons use shadow outlines and a blue focus ring.
- Banners use a full tinted background. Badges and avatars use the new color palette.
- Tabs are displayed as pills, and the `Navigation` sidebar uses the dark admin theme.
- Typography uses regular (400) body text and medium (500) headings. The `ShopifyInter` font is used when it is available on the page, with the bundled Inter as a fallback.

If you override Polaris CSS custom properties (for example `--p-color-bg-app` or `--p-color-bg-fill-brand`), check that your overrides still apply, since many tokens have new values.

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
