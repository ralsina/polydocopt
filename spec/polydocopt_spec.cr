require "./spec_helper"

describe Polydocopt do
  describe ".levenshtein_distance" do
    it "is zero for identical strings" do
      Polydocopt.levenshtein_distance("greet", "greet").should eq(0)
    end

    it "ignores case" do
      Polydocopt.levenshtein_distance("Greet", "GREET").should eq(0)
    end

    it "measures single character edits" do
      Polydocopt.levenshtein_distance("hello", "helllo").should eq(1)
      Polydocopt.levenshtein_distance("grret", "greet").should eq(1)
      Polydocopt.levenshtein_distance("kitten", "sitting").should eq(3)
    end

    it "handles empty strings" do
      Polydocopt.levenshtein_distance("", "abc").should eq(3)
      Polydocopt.levenshtein_distance("", "").should eq(0)
    end
  end

  describe ".main" do
    it "runs a registered command and returns its exit code" do
      code, _stdout, stderr = run_main(["greet", "-p", "mars"])
      code.should eq(0)
      SpecGreet.executed?.should be_true
      SpecGreet.last_planet.should eq("mars")
      stderr.should be_empty
    end

    it "propagates non-zero exit codes from commands" do
      code, _stdout, _stderr = run_main(["fail"])
      code.should eq(7)
    end

    context "with no arguments" do
      it "prints top level help" do
        code, stdout, stderr = run_main([] of String)
        code.should eq(0)
        stdout.should contain("Usage:")
        stdout.should contain("spec help [COMMAND]")
        stdout.should contain("Commands:")
        stdout.should contain("Greets people")
        stdout.should contain("Greets greatly")
        stderr.should be_empty
      end
    end

    context "with --help or -h" do
      it "prints top level help" do
        code, stdout, _stderr = run_main(["--help"])
        code.should eq(0)
        stdout.should contain("Commands:")
      end

      it "prints top level help for -h" do
        code, stdout, _stderr = run_main(["-h"])
        code.should eq(0)
        stdout.should contain("Commands:")
      end
    end

    context "with the help command" do
      it "prints top level help without an argument" do
        code, stdout, _stderr = run_main(["help"])
        code.should eq(0)
        stdout.should contain("Commands:")
      end

      it "prints a command's documentation" do
        code, stdout, _stderr = run_main(["help", "greet"])
        code.should eq(0)
        stdout.should contain("Greets people")
        stdout.should contain("-p PLANET")
      end

      it "fails with suggestions for unknown commands" do
        code, _stdout, stderr = run_main(["help", "greot"])
        code.should eq(1)
        stderr.should contain("is not a spec command")
        stderr.should contain("The most similar commands are")
        stderr.should contain("greet")
        stderr.should contain("great")
      end

      it "rejects extra arguments" do
        code, _stdout, stderr = run_main(["help", "greet", "extra"])
        code.should eq(1)
        stderr.should contain("Usage:")
      end
    end

    context "with an unknown command" do
      it "suggests similar commands like git" do
        code, _stdout, stderr = run_main(["fial"])
        code.should eq(1)
        stderr.should contain("'fial' is not a spec command")
        stderr.should contain("The most similar command is")
        stderr.should contain("\tfail")
      end

      it "prints no suggestions when nothing is similar" do
        code, _stdout, stderr = run_main(["zzzzzzz"])
        code.should eq(1)
        stderr.should contain("is not a spec command")
        stderr.should_not contain("most similar")
      end
    end

    context "with invalid arguments for a known command" do
      it "prints usage and a hint to stderr" do
        code, _stdout, stderr = run_main(["greet", "-x"])
        code.should eq(1)
        stderr.should contain("Usage:")
        stderr.should contain("See 'spec help greet'")
      end
    end

    context "with --help on a known command" do
      it "prints that command's documentation" do
        code, stdout, stderr = run_main(["greet", "--help"])
        code.should eq(0)
        stdout.should contain("Greets people")
        stdout.should contain("-p PLANET")
        stderr.should be_empty
      end
    end
  end

  describe Polydocopt::Command do
    it "rejects documentation without a usage section" do
      expect_raises(ArgumentError, "no 'Usage:' section") do
        SpecBroken.register
      end
    end

    it "rejects duplicate command names" do
      expect_raises(ArgumentError, "already registered") do
        SpecGreet.register
      end
    end
  end
end
