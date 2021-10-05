# Polaris ViewComponents

Polaris ViewComponents is an implementation of the Polaris Design System using [ViewComponent](https://github.com/github/view_component).

![Polaris ViewComponents](.github/assets/preview.png)

> **This library is under active development. Breaking changes are likely until stable release.**

## Preview

https://polaris-view-components.herokuapp.com/lookbook

## Usage

Render Polaris ViewComponents:

```erb
<%= polaris_card(title: "Title") do %>
  <p>Card example</p>
<% end %>
```

## Installation

In `Gemfile`, add:

```ruby
gem 'polaris_view_components'
```

Run install generator:
```bash
rails generate polaris_view_components:install
```

Setup Polaris styles in your layouts `<head>` tag:

```erb
<link rel="stylesheet" href="https://unpkg.com/@shopify/polaris@6.6.0/dist/styles.css" />
<%= stylesheet_link_tag 'polaris_view_components' %>
```

Define Polaris style on your `<body>` tag:

```erb
<body style="<%= polaris_body_styles %>">
```

### Importmaps

Add to `config/importmap.rb`:

```rb
pin "polaris-view-components", to: "polaris_view_components.js"
```

Add to `app/javascript/controllers/index.js`:
```javascript
// ...

import { registerPolarisControllers } from "polaris-view-components"
registerPolarisControllers(Stimulus)
```

### NPM

Install NPM package:
```bash
yarn add polaris-view-components
```

Add to `app/javascript/controllers/index.js`:
```javascript
// ...

import { registerPolarisControllers } from "polaris-view-components"
registerPolarisControllers(Stimulus)
```

## Dependencies

In addition to the dependencies declared in the `gemspec`, Polaris ViewComponents assumes the presence of Polaris CSS.

## Development

To get started:

1. Run: `bundle install`
2. Run: `foreman start`

It will open demo app with component previews on `localhost:4000`. You can change components and they will be updated on page reload. Component previews located in `demo/test/components/previews`.

To release gem run:
```bash
script/release
```

To release npm package run:
```bash
yarn release
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
