# Middleman::Search

LunrJS-based search for Middleman.

## Installation

Add this line to your application's Gemfile:

    gem 'middleman-search'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install middleman-search

## Usage

> **Notice**: this gem is a work in progress. While it already _works_, it still has lots of configurations hardcoded. You should monkey-patch the gem if its configuration doesn't suit you, or - even better - refactor it and send a pull request :)

You need to activate the module in your `config.rb`, telling the extension how to index your resources:

```ruby
activate :search do
  search.resources = ['blog/', 'index.html', 'contactus/index.html']
  search.fields = {
    title: {boost: 100, store: true, required: true},
    body:  {boost: 50},
    url:   {index: false, store: true}
  }
end
```

`resources` is a list of the beginning of the URL of the resources to index (tested with `String#start_with?`). `fields` is a hash with one entry for each field to be indexed, and a hash of options associated.

For each field, you can specify it's relevance `boost`, and whether to `index` that field's content or not.

You should also `require` the `lunr.min.js` file to your `all.js` file:

```javascript
//= require lunr.min
```

## Acknowledgments

A big thank you to:
- @Octo-Labs's @jagthedrummer for his [`middleman-alias`](https://github.com/Octo-Labs/middleman-alias) extension, in which we based for developing this one.
- @jnovos and @256dpi, for their [`middleman-lunrjs`](https://github.com/jnovos/middleman-lunrjs) and [`middleman-lunr`](https://github.com/256dpi/middleman-lunr) extensions, which served as inspirations for making this one.
- @olivernn and all [`lunr.js`](http://lunrjs.com/) [contributors](https://github.com/olivernn/lunr.js/graphs/contributors)
- [The Middleman](https://middlemanapp.com/) [team](https://github.com/orgs/middleman/people) and [contributors](https://github.com/middleman/middleman/graphs/contributors)
