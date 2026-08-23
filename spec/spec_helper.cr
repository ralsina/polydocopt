require "spec"
require "../src/polydocopt"

struct SpecGreet < Polydocopt::Command
  @@name = "greet"
  @@doc = <<-HELP
    Greets people

    Usage:
      spec greet [-u] [-p PLANET]

    Options:
      -h --help     Show this screen
      -u --upper    Uppercase output
      -p PLANET     Planet to greet [default: world]
    HELP

  class_property? executed = false
  class_property last_planet : String = ""

  def run : Int32
    @@executed = true
    @@last_planet = options.fetch("-p", "").as?(String) || ""
    0
  end
end

struct SpecFail < Polydocopt::Command
  @@name = "fail"
  @@doc = <<-HELP
    Always fails

    Usage:
      spec fail
    HELP

  def run : Int32
    7
  end
end

struct SpecGreat < Polydocopt::Command
  @@name = "great"
  @@doc = <<-HELP
    Greets greatly

    Usage:
      spec great
    HELP

  def run : Int32
    0
  end
end

SpecGreet.register
SpecFail.register
SpecGreat.register

struct SpecBroken < Polydocopt::Command
  @@name = "broken-spec-cmd"
  @@doc = <<-HELP
    No usage here at all.
    HELP

  def run : Int32
    0
  end
end

def run_main(arguments : Array(String))
  stdout_io = IO::Memory.new
  stderr_io = IO::Memory.new
  code = Polydocopt.main("spec", arguments, stdout: stdout_io, stderr: stderr_io)
  {code, stdout_io.to_s, stderr_io.to_s}
end
