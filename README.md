# Polaris ViewComponents

Polaris ViewComponents is an implementation of the Polaris Design System using [ViewComponent](https://github.com/github/view_component).

> **This library is under active development. Breaking changes are likely until stable release.**

## Usage

Render Polaris ViewComponents via helpers:

```erb
<%= polaris_card(title: "Title") do %>
  <p>Card example</p>
<% end %>
```

or the full version:

```erb
<%= render Polaris::Card::Component.new(title: "Title") do %>
  <p>Card example</p>
<% end %>
```

## Installation

In `Gemfile`, add:
```ruby
gem 'polaris_view_components', github: 'baoagency/polaris_view_components'
```

To add styles for `Polaris::ShopifyNavigation::Component` in your layout's `<head>` tag add:
```erb
<%= stylesheet_link_tag 'polaris_view_components' %>
```

To add the javascript Stimulus controllers in your applications webpack entry file add:

```javascript
import { registerPolarisStimulusControllers } from '@by-association-only/polaris-view-components'

const application = Application.start()
registerPolarisStimulusControllers(application)
```

## Dependencies

In addition to the dependencies declared in the `gemspec`, Polaris ViewComponents assumes the presence of Polaris CSS.

## Development

To get started:

1. Run: `bundle install`
2. Run: `foreman start`

It will open demo app with component previews on `localhost:4000`. You can change components and they will be updated on page reload. Component previews located in `demo/test/components/previews`.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
