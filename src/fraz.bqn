⟨ Get, Post ⟩ ← •Import "../lib/bqn-curl/curl.bqn"

fraz ⇐ {
  r ← Get "https://httpbin.org/get"
  Test ⇐ { 𝕩∾r.code }
}

# Various help strings # TODO: spin out into another file/namespace
helpMsg ← "Usage: fraz [init|add|remove|search|help] [help|<args>]

  init: Initialise a new Frazzle in the current directory (or another directory, if given)
   add: Add one or more Frazzles to lib/ in the current directory
remove: Remove one or more Frazzles from lib/ in the current directory
search: Query available Frazzles on frazzl.es (or $FRAZZLES_INDEX, if defined)
  help: Display this message

You can also call 'fraz <command> help for more in-depth help with a specific command."
initHelpMsg ← "TODO: init help message" # TODO
addHelpMsg ← "TODO: add help message" # TODO
removeHelpMsg ← "TODO: remove help message" # TODO
searchHelpMsg ← "TODO: search help message" # TODO
helpHelpMsg ← "You think you're funny, don't you?"
badCmdError ← "ERROR: allowed commands are 'init', 'add', 'remove', 'search' and 'help'."

# Process arguments: fraz <cmd> <args>
args ← •args
{ 0=≠𝕩 ? •Out helpMsg ⋄ •Exit 0 ; @ }args # Display help message if no arguments provided
cmd ← ⊑args
cmdSet ← "init"‿"add"‿"remove"‿"search"‿"help" # Allowed commands
{ ∊⟜cmdSet⌾<cmd ? @ ; •Out badCmdError ⋄ •Exit ¯1 } # Fail if cmd is unknown
args 1⊸↓↩

# Check if a directory is already a Frazzle
IsFrazzle ← {
  •file.Exists 𝕩 •file.At ".frazzle"
}

Init ← {
  #badInitError ← "ERROR: "
  #{1<≠𝕩 ? •Out badInitError ⋄ •Exit ¯1 ; @ }
  𝕩
}
Add ← { •Show⌽𝕩 }
Remove ← { •Show⌽¨𝕩 }
Search ← { •Show∘‿1⥊𝕩 }
Help ← {
  0=≠𝕩 ? •Out helpMsg ; "help"≡⊑𝕩 ? •Out helpHelpMsg ; •Out "Usage: fraz help" ⋄ •Exit ¯1 
}

# Run it!
{ cmd≡"init" ? Init args ; @ }
{ cmd≡"add" ? Add args ; @ }
{ cmd≡"remove" ? Remove args ; @ }
{ cmd≡"search" ? Search args ; @ }
{ cmd≡"help" ? Help args ; @ }