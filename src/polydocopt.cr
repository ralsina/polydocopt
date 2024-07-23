require "docopt"

# TODO: Write documentation for `Polydocopt`

module Polydocopt
  extend self
  VERSION = "0.1.0"

  abstract struct Command
    property options : Hash(String, (Nil | String | Int32 | Bool | Array(String)))
    class_property name : String = "command"
    class_property doc : String = ""

    def initialize(@options)
    end

    def self.register
      COMMANDS[self.name] = self
    end

    def run : Int32
      raise Exception.new("Not implemented")
    end
  end

  # Command class registry
  COMMANDS = {} of String => Command.class

  private def self.help(progname : String, args : Array(String)) : Int32
    help_doc = <<-HELP
Help about the #{progname} command.
  
Usage:
  #{progname} help [COMMAND]
HELP
    COMMANDS.each do |name, cmd|
      help_doc += "\n  #{progname} #{name.ljust 24}" + cmd.doc.split("\n").first
    end

    options = Docopt.docopt(help_doc, args)
    if !options["COMMAND"]
      puts help_doc
      return 0
    else
      command_name = options["COMMAND"]
      command = COMMANDS.fetch(command_name, nil)
      if command.nil?
        puts "Unknown command: #{command_name}"
        return 0
      end

      puts command.doc
      0
    end
  end

  def self.main(progname, args : Array(String)) : Int32
    # Register the help command:

    if args.size < 1 ||
       args[0] == "help" ||
       args[0] == "--help" ||
       !COMMANDS.has_key?(args[0])
      return help(progname, args)
    end

    # Run named command
    command_name = args[0]
    command = COMMANDS.fetch(command_name, nil)
    if command.nil?
      puts "Unknown command: #{command_name}"
      return 1
    end

    options = Docopt.docopt(command.doc, args)
    command_instance = command.new(options)
    exit(command_instance.run)
  end
end
