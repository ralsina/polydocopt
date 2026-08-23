# polydocopt

A subcommand-oriented version of docopt.

Modern command line tools often have totally different subcommands that have different options and arguments.

This is a library to make it easier to write such tools
while keeping with the spirit of [docopt](http://docopt.org/).

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

You can see an example in the `example` directory, but this
is the gist of it:

To build it: `shards build` and
then you can run `./bin/say` to see the help.

```
> ./bin/say
Help about the say command.

Usage:
  say help [COMMAND]

Commands:
  hello       Says hello to the world
  bye         Says bye to the world

> ./bin/say help hello
Says hello to the world

Usage:
  say hello [-u] [-p PLANET]

Options:
  -h --help     Show this screen
  -u --upper    Uppercase the output
  -p PLANET     Greet a planet [default: world]

> ./bin/say helo
say: 'helo' is not a say command. See 'say help'.

The most similar command is
	hello
```

As you can see, it has totally different helps for each subcommand, which is not trivial using many other libraries.
It also suggests similar commands when you mistype one, just like git does.

Also, the definition of each command is simple:

```crystal
require "polydocopt"

struct Hello < Polydocopt::Command
  @@name = "hello"
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

Hello.register
```

And you can run your command with all its subcommands like this:

```crystal
exit(Polydocopt.main("say", ARGV))
```

`Polydocopt.main` returns the exit code of the executed command,
so wrapping it in `exit` gives your tool correct exit codes:

| Situation                                   | Exit code |
|---------------------------------------------|-----------|
| Command ran                                 | whatever `run` returned |
| No arguments, `help`, `-h`, `--help`        | 0         |
| Unknown or misspelled command               | 1         |
| Invalid arguments for a command             | 1         |

The rules for a command's documentation are:

* It must contain a `Usage:` section (validated at registration time)
* The first paragraph is used as the command summary in the top-level help
* Command names must be unique (registering a duplicate raises)
* The name `help` is reserved

If you want to test your own commands, `Polydocopt.main` accepts optional
`stdout` and `stderr` arguments so you can capture output without touching
the real streams:

```crystal
code = Polydocopt.main("say", ["hello"], stdout: io, stderr: err_io)
```

## Contributing

1. Fork it (<https://github.com/ralsina/polydocopt/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Roberto Alsina](https://github.com/ralsina) - creator and maintainer
