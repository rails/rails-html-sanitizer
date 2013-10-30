# Rails Html Sanitizers

This gem is resposible to sanitize HTML fragments in Rails applications.

## Installation

Add this line to your application's Gemfile:

    gem 'rails-html-sanitizer'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rails-html-sanitizer

## Usage

### Sanitizers

TODO: show some examples of the sanitizers

### Scrubbers

Scrubbers are objects responsible to remove nodes or attributtes you don't want in your HTML
document.

This gem includes two scrubber `Rails::Html::PermitScrubber` and `Rails::Html::TargetScrubber`.

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

Where PermitScrubber picks out tags and attributes to permit in sanitization,
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

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
