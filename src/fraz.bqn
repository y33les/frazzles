⟨ Get, Post ⟩ ← •Import "../lib/bqn-curl/curl.bqn"
⟨ read ⟩ ← •Import "read.bqn"

fraz ⇐ {
  r ← Get "https://httpbin.org/get"
  Test ⇐ { 𝕩∾r.code }
}

cmdSet ← ⟨"new","init","add","remove","search","help"⟩ # Allowed commands

# Fail prettily (users don't need a stack trace) with message 𝕨 and ignore 𝕩
# TODO: spin this out into another namespace
Fail ← { •Out 𝕨 ⋄ •Exit ¯1}
_Assert_ ← { !⎊(𝕘⊸fail) 𝕗 }

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

# Process arguments: fraz <cmd> <args>
args ← •args
{ 0=≠𝕩 ? •Out helpMsg ⋄ •Exit 0 ; @ }args # Display help message if no arguments provided
cmd ← ⊑args
(∊⟜cmdSet⌾<cmd) _Assert_ ("Allowed commands are: "∾{𝕨∾", "∾𝕩}´cmdSet) # Fail if cmd is unknown
args 1⊸↓↩

configHeaders ← ⟨"name","description","author","version","type","licence","dependencies"⟩
# Generate a config HashMap where 𝕩 is a list of corresponding to the Frazzle name (string), description (string), author (string), version (string), type (string: "app" or "lib") licence (string) and dependencies (list of strings).
# TODO: Implement dependency versioning like in Python (e.g. "numpy==1.1.14")
InputConfig ← {
  •Out "Frazzle name:"
  name ← read.LineNoBlank ""
  •Out "Description:"
  description ← read.LineNoBlank ""
  •Out "Author:"
  author ← read.LineNoBlank ""
  •Out "Version number:"
  version ← read.LineNoBlank ""
  •Out "Frazzle type ('app' or 'lib'):"
  type ← read.LineNoBlank ""
  •Out "Licence:"
  licence ← read.LineNoBlank ""
  dependencies ← ""
  ⟨name,description,author,version,type,licence,dependencies⟩
}
GenConfig ← {
  "GenConfig requires a list of length 7."!7=≠𝕩
  configHeaders •HashMap 𝕩
}
ReadConfig ← { 𝕩 }
WriteConfig ← { 𝕩 •file.Chars helpMsg } # TODO: Replace placeholder

New ← {
  (1=≠𝕩) _Assert_ "Usage: fraz new <dir>"
  dir ← •wdpath •file.At ⊑𝕩
  (¬•file.Exists dir) _Assert_ ("Directory "∾dir∾" already exists.")
  •file.CreateDir dir
  frazFile ← dir •file.At ".frazzle"
  WriteConfig frazFile # TODO: GenConfig + WriteConfig
  •Out "New Frazzle created in "∾dir∾"."
}
Init ← {
  (0=≠𝕩) _Assert_ "fraz init does not accept arguments.  Did you mean 'fraz new <dir>'?"
  frazFile ← •wdpath •file.At ".frazzle"
  (¬•file.Exists frazFile) _Assert_ "This directory is already a Frazzle."
  WriteConfig frazFile
  •Out "Frazzle initialised in "∾•wdpath
}
Add ← { •Show⌽𝕩 }
Remove ← { •Show⌽¨𝕩 }
Search ← {
  usageMsg ← "Usage: fraz search [-i <Frazzle index URL>] <search term>"
  frazIndex ← "ftp://ftp.frazzl.es"
  (0≠≠𝕩) _Assert_ usageMsg
  {"-i"≡⊑𝕩 ? usageMsg!2=≠𝕩 ⋄ frazIndex ↩ 1⊑𝕩 ; usageMsg!1=≠𝕩}𝕩
  •Out frazIndex
}
Help ← {
  (2>≠𝕩) _Assert_ "Usage: fraz help [command]"
  { 0=≠𝕩 ? •Out helpMsg ⋄ •Exit 0 ; @ }𝕩 # Display toplevel help message if no command provided
  (∊⟜cmdSet⌾<cmd) _Assert_ ("Allowed commands are: "∾{𝕨∾", "∾𝕩}´cmdSet)
  •Out cmdHelpMap.Get ⊑𝕩 
}
cmdFnMap ← cmdSet •HashMap ⟨new,init,add,remove,search,help⟩ # Allowed commands with their corresponding functions

# Run it!
args{𝕏𝕨}cmdFnMap.Get cmd