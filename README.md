# crystaldiscord

a discord library written in crystal.

## Installation

1. Add the dependency to your `shard.yml`:

```yaml
dependencies:
  crystaldiscord:
    github: Zomatree/crystaldiscord
```

2. Run `shards install`

## Usage

```crystal
require "crystaldiscord"

client = Crystaldiscord::Client.new "token goes here"

client.on_message = ->(msg : Crystaldiscord::Message) {
    puts "#{msg.author.user.name}: #{msg.content}"
}

client.run()
```

## Contributing

1. Fork it (<https://github.com/your-github-user/crystaldiscord/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Zomatree](https://github.com/your-github-user) - creator and maintainer
