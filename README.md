# polydocopt

A subcommand-oriented version of docopt.

Modern command line tools often have totally different subcommands that have different options and arguments.

This is a library to make it easier to write such tools
while keeping with the spirit of [docopt](https://docopt.org/).

**NOTE:** This builds on the excellent [docopt.cr!](https://github.com/chenkovsky/docopt.cr)

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     polydocopt:
       github: ralsina/polydocopt
   ```

2. Run `shards install`

## Usage

You can see an example in the `examples` directory, but this
is the gist of it:

To build it: `crystal build example/main.cr -o say` and
then you can run `./say` to see the help.

```
> ./say
Usage:
  say help [COMMAND]
  say hello                   Says hello to the world
  say bye                     Says bye to the world

> ./say help hello
Says hello to the world

Usage:
  say hello [-u] [-p PLANET]

Options:
  -h --help     Show this screen
  -u --upper    Uppercase the output
  -p PLANET     Greet a planet [default: world]

> ./say help bye
Says bye to the world

Usage:
  say bye [-b] [-p PLANET]

Options:
  -h --help         Show this screen
  -b --backwards    Say it backwards
  -p PLANET         Greet a planet [default: world]
```

As you can see, it has totally different helps for each subcommand, which is not trivial using many other libraries.

Also, the definition of each command is simple:

```crystal
require "polydocopt"

struct Hello < Polydocopt::Command
  @name = "hello"
  @@doc = <<-HELP
Says hello to the world

Usage:
  say hello [-u] [-p PLANET]

Options:
  -h --help     Show this screen
  -u --upper    Uppercase the output
  -p PLANET     Greet a planet [default: world]
HELP

  def run : Int32
    greeting = "hello #{options["-p"]}"
    greeting = greeting.upcase if options["--upper"]
    puts greeting
    0
  end
end

Hello.register()
```

And you can run your command with all its subcommands like this:

```crystal
exit(Polydocopt.main("say", ARGV))
```

## Contributing

1. Fork it (<https://github.com/ralsina/polydocopt/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Roberto Alsina](https://github.com/your-github-user) - creator and maintainer
