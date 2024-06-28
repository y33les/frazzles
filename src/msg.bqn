# Various instructional messages and help strings

# Help strings
help ⇐ {
  fraz ⇐ "Usage: fraz [new|init|add|remove|search|help] <args>

   new: Create a new Frazzle in a given directory
  init: Initialise a new Frazzle in the current directory (or another directory, if given)
   add: Add one or more Frazzles to lib/ in the current directory
remove: Remove one or more Frazzles from lib/ in the current directory
search: Query available Frazzles on frazzl.es (or $FRAZZLES_INDEX, if defined)
  help: Display this message, or get specific help with a given command

You can also call 'fraz help <command> for more in-depth help with a specific command."
  new ⇐ "TODO: new help message" # TODO
  init ⇐ "TODO: init help message" # TODO
  add ⇐ "TODO: add help message" # TODO
  remove ⇐ "TODO: remove help message" # TODO
  search ⇐ "TODO: search help message" # TODO
  help ⇐ "You think you're funny, don't you?"
}

# Usage notices
use ⇐ {
  new ⇐ "Usage: fraz new <dir>"
  init ⇐ "Usage: fraz init"
  add ⇐ "Usage: fraz add [-i <Frazzle index URL] <frazzles>"
  remove ⇐ "Usage: fraz remove <frazzles>"
  search ⇐ "Usage: fraz search [-i <Frazzle index URL>] <search term>"
  help ⇐ "Usage: fraz help [command]"
}