# Rails Html Sanitizers

This gem is responsible for sanitizing HTML fragments in Rails applications, i.e. in the `sanitize`, `sanitize_css`, `strip_tags` and `strip_links` methods.

## Installation

Add this line to your application's Gemfile:

    gem 'rails-html-sanitizer'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rails-html-sanitizer

## Usage

### Sanitizers

All sanitizers respond to `sanitize`.

#### FullSanitizer

```ruby
@full_sanitizer = Rails::Html::FullSanitizer.new
@full_sanitizer.sanitize("<b>Bold</b> no more!  <a href='more.html'>See more here</a>...")
# => Bold no more!  See more here...
```

#### LinkSanitizer

```ruby
@link_sanitizer = Rails::Html::LinkSanitizer.new
@link_sanitizer.sanitize('<a href="example.com">Only the link text will be kept.</a>')
# => Only the link text will be kept.
```

#### WhiteListSanitizer

```ruby
@white_list_sanitizer = Rails::Html::WhiteListSanitizer.new

# sanitize via an extensive white list of allowed elements
@white_list_sanitizer.sanitize(@article.body)

# white list only the supplied tags and attributes
@white_list_sanitizer.sanitize(@article.body, tags: %w(table tr td), attributes: %w(id class style))

# white list via a custom scrubber
@white_list_sanitizer.sanitize(@article.body, ArticleScrubber.new)
```

### Scrubbers

Scrubbers are objects responsible for removing nodes or attributes you don't want in your HTML document.

This gem includes two scrubbers `Rails::Html::PermitScrubber` and `Rails::Html::TargetScrubber`.

#### `Rails::Html::PermitScrubber`

This scrubber allows you to permit only the tags and attributes you want.

```ruby
scrubber = Rails::Html::PermitScrubber.new
scrubber.tags = ['a']

html_fragment = Loofah.fragment('<a><img/ ></a>')
html_fragment.scrub!(scrubber)
html_fragment.to_s # => "<a></a>"
```

#### `Rails::Html::TargetScrubber`

Where `PermitScrubber` picks out tags and attributes to permit in sanitization,
`Rails::Html::TargetScrubber` targets them for removal.


```ruby
scrubber = Rails::Html::TargetScrubber.new
scrubber.tags = ['img']

html_fragment = Loofah.fragment('<a><img/ ></a>')
html_fragment.scrub!(scrubber)
html_fragment.to_s # => "<a></a>"
```

#### Custom Scrubbers

You can also create custom scrubbers in your application if you want to.

```ruby
class CommentScrubber < Rails::Html::PermitScrubber
  def allowed_node?(node)
    !%w(form script comment blockquote).include?(node.name)
  end

  def skip_node?(node)
    node.text?
  end

  def scrub_attribute?(name)
    name == "style"
  end
end
```

See `Rails::Html::PermitScrubber` documentation to learn more about which methods can be overridden.

#### Custom Scrubber in a Rails app

Using the `CommentScrubber` from above, you can use this in a Rails view like so:

```ruby
<%= sanitize @comment, CommentScrubber.new %>
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
