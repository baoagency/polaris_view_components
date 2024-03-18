# Upgrading guide

## Upgrading to `v2.0.0`

This release updates UI to Polaris v12 styles. Required changes after gem upgrade:

1. Add `polaris_html_classes` to your `html` tag in layouts:

```erb
<html class="<%= polaris_html_classes %>" style="<%= polaris_html_styles %>">
```

2. Update icon names in your app. Naming convention in Polaris Icons v12 changed. There's no more separation to `Minor` and `Major` icons. All icons have `Icon` suffix. New icon names can be found in Polaris documentation: https://polaris.shopify.com/icons
