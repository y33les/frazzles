⟨ Get, Post ⟩ ← •Import "../lib/bqn-curl/curl.bqn"

fraz ⇐ {
  r ← Get "https://httpbin.org/get"
  Test ⇐ { 𝕩∾r.code }
}

# Process arguments: fraz <cmd> <args>
args ← •args
{ 0=≠𝕩 ? •Out helpMsg ⋄ •Exit 0 ; @ }args # Display help message if no arguments provided
cmd ← ⊑args
cmdSet ← ⟨"new","init","add","remove","search","help"⟩ # Allowed commands
("Allowed commands are: "∾{𝕨∾", "∾𝕩}´cmdSet)!∊⟜cmdSet⌾<cmd # Fail if cmd is unknown
args 1⊸↓↩

# Various help strings # TODO: spin out into another file/namespace
helpMsg ← "Usage: fraz [new|init|add|remove|search|help] <args>

   new: Create a new Frazzle in a given directory
  init: Initialise a new Frazzle in the current directory (or another directory, if given)
   add: Add one or more Frazzles to lib/ in the current directory
remove: Remove one or more Frazzles from lib/ in the current directory
search: Query available Frazzles on frazzl.es (or $FRAZZLES_INDEX, if defined)
  help: Display this message, or get specific help with a given command

You can also call 'fraz help <command> for more in-depth help with a specific command."
newHelpMsg ← "TODO: new help message" # TODO
initHelpMsg ← "TODO: init help message" # TODO
addHelpMsg ← "TODO: add help message" # TODO
removeHelpMsg ← "TODO: remove help message" # TODO
searchHelpMsg ← "TODO: search help message" # TODO
helpHelpMsg ← "You think you're funny, don't you?"
cmdHelpMap ← cmdSet •HashMap ⟨newHelpMsg,initHelpMsg,addHelpMsg,removeHelpMsg,searchHelpMsg,helpHelpMsg⟩ # Allowed commands with their corresponding help messages

# Generate a config HashMap where 𝕩 is a list of corresponding to the Frazzle name (string), author (string), version (string), licence (string) and dependencies (list of strings).
# TODO: Implement dependency versioning like in Python (e.g. "numpy==1.1.14")
GenConfig ← {
  "GenConfig requires a list of length 5."!5=≠𝕩
  ⟨"name","author","version","licence","dependencies"⟩ •HashMap 𝕩
}
ReadConfig ← { 𝕩 }
WriteConfig ← { 𝕩 •file.Chars helpMsg } # TODO: Replace placeholder

New ← {
  "fraz new requires one argument, the name of a new directory in whcih to create a Frazzle."!1=≠𝕩
  dir ← •wdpath •file.At ⊑𝕩
  ("Directory "∾dir∾" already exists.")!¬•file.Exists dir
  •file.CreateDir dir
  frazFile ← dir •file.At ".frazzle"
  WriteConfig frazFile # TODO: GenConfig + WriteConfig
  •Out "New Frazzle created in "∾dir∾"."
}
Init ← {
  "fraz init does not accept arguments.  Did you mean 'fraz new <dir>'?"!0=≠𝕩
  frazFile ← •wdpath •file.At ".frazzle"
  "This directory is already a Frazzle."!¬•file.Exists frazFile
  WriteConfig frazFile
  •Out "Frazzle initialised in "∾•wdpath
}
Add ← { •Show⌽𝕩 }
Remove ← { •Show⌽¨𝕩 }
Search ← { •Show∘‿1⥊𝕩 }
Help ← {
  "fraz help can be called with either no arguments, or with one (the name of a fraz command)."!2>≠𝕩
  0=≠𝕩 ? •Out helpMsg ⋄ •Exit 0 ; ("Allowed commands are: "∾{𝕨∾", "∾𝕩}´cmdSet)!∊⟜cmdSet⌾<⊑𝕩 ⋄ •Out cmdHelpMap.Get ⊑𝕩 
}
cmdFnMap ← cmdSet •HashMap ⟨new,init,add,remove,search,help⟩ # Allowed commands with their corresponding functions

# Run it!
args{𝕏𝕨}cmdFnMap.Get cmd