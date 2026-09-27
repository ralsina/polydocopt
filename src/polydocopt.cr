# Compatibility shim: polydocopt's implementation now lives in
# docopt.cr (>= 0.6.0) behind `require "docopt/dispatch"` as
# Docopt::Dispatch. The Polydocopt alias keeps existing code working
# (Polydocopt.main, Polydocopt::Command, Polydocopt::COMMANDS, ...).
#
# New code can depend on docopt directly:
#
#   dependencies:
#     docopt:
#       github: ralsina/docopt.cr
#
#   require "docopt/dispatch"
require "docopt/dispatch"

alias Polydocopt = Docopt::Dispatch
