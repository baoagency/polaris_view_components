# Polaris ViewComponents

Polaris ViewComponents is an implementation of the Polaris Design System using [ViewComponent](https://github.com/github/view_component).

![Polaris ViewComponents](.github/assets/preview.png)

> **This library is under active development. Breaking changes are likely until stable release.**

## Preview

https://polarisviewcomponents.org

## Usage

Render Polaris ViewComponents:

```erb
<%= polaris_card(title: "Title") do %>
  <p>Card example</p>
<% end %>
```

## Dependencies

- [Stimulus](https://stimulus.hotwired.dev/)

## Installation

Add to `Gemfile`:

```ruby
gem "polaris_view_components"
```

Run installer:
```bash
bin/rails polaris_view_components:install
```

## Development

To get started:

1. Run: `bundle install`
2. Run: `bin/dev`

It will open demo app with component previews on `localhost:4000`. You can change components and they will be updated on page reload. Component previews located in `demo/test/components/previews`.

To run tests:

```bash
bin/rails test
```

## Releases

The library follows [semantic versioning](https://semver.org/). To draft a new release you need to run `script/release` with a new version number:

```bash
script/release VERSION
```

Where the VERSION is the version number you want to release. This script will update the version in the gem and push it to GitHub and Rubygems automatically.

To release a new version of npm package update the package.json file with the new version number and run:

```bash
npm run release
```

After that make sure to commit changes in package.json.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
