# Example of polydocopt usage

require "../src/polydocopt.cr"

# We define a couple of commands

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

struct Bye < Polydocopt::Command
  @name = "bye"
  @@doc = <<-HELP
Says bye to the world

Usage:
  say bye [-b] [-p PLANET]

Options:
  -h --help         Show this screen
  -b --backwards    Say it backwards
  -p PLANET         Greet a planet [default: world]
HELP

  def run : Int32
    greeting = "bye #{options["-p"]}"
    greeting = greeting.reverse if options["--backwards"]
    puts greeting
    0
  end
end

Bye.register()

# We run the main function with the command line arguments
exit(Polydocopt.main("say", ARGV))
