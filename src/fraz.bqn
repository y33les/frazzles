curl ← •Import "../lib/bqn-curl/curl.bqn"
read ← •Import "read.bqn"
err ← •Import "err.bqn"
msg ← •Import "msg.bqn"
str ← •Import "str.bqn"

cmdSet ← ⟨"new","init","add","remove","search","help"⟩ # Allowed commands
cmdHelpMap ← cmdSet •HashMap ⟨msg.help.new,msg.help.init,msg.help.add,msg.help.remove,msg.help.search,msg.help.help⟩ # Allowed commands with their corresponding help messages
frazIndex ← "get.frazzl.es" # Default Frazzle index

# Process arguments: fraz <cmd> <args>
args ← •args
{ 0=≠𝕩 ? •Out msg.help.fraz ⋄ •Exit 0 ; @ }args # Display help message if no arguments provided
cmd ← ⊑args
(∊⟜cmdSet⌾<cmd) err._Assert_ ("Allowed commands are: "∾{𝕨∾", "∾𝕩}´cmdSet) # Fail if cmd is unknown
args 1⊸↓↩

configHeaders ← ⟨"name","description","author","version","type","licence","dependencies"⟩
InputConfig ← {
  •Out "Frazzle name:"
  name ← read.LineNoBlank 𝕩
  •Out "Description:"
  description ← read.LineNoBlank 𝕩
  •Out "Author:"
  author ← read.LineNoBlank 𝕩
  •Out "Version number:"
  version ← read.LineNoBlank 𝕩
  •Out "Frazzle type ('app' or 'lib'):"
  type ← {l←read.LineNoBlank 𝕩 ⋄ (l≡"app")∨(l≡"lib") ? l ; •Out "Frazzle type must be either 'app' or 'lib'." ⋄ 𝕊 𝕩} 𝕩
  •Out "Licence:"
  licence ← read.LineNoBlank 𝕩
  dependencies ← ⟨⟩
  ⟨name,description,author,version,type,licence,dependencies⟩
}
# Generate a config HashMap where 𝕩 is a list of corresponding to the Frazzle name (string), description (string), author (string), version (string), type (string: "app" or "lib") licence (string) and dependencies (list of strings).
# TODO: Implement dependency versioning like in Python (e.g. "numpy==1.1.14")
# TODO: Type checking
GenConfig ⇐ {
  n←≠configHeaders
  ("GenConfig requires a list of length "∾(•Fmt n)∾".")!n=≠𝕩
  configHeaders •HashMap 𝕩
}
ReadConfig ⇐ { 𝕩 }
WriteConfig ⇐ { 𝕨 •file.Bytes 𝕩 } # TODO: input checking

New ⇐ {
  (1=≠𝕩) err._Assert_ msg.use.new
  dir ← •wdpath •file.At ⊑𝕩
  (¬•file.Exists dir) err._Assert_ ("Directory "∾dir∾" already exists.")
  •file.CreateDir dir
  frazFile ← dir •file.At ".frazzle"
  frazFile WriteConfig GenConfig InputConfig ""
  •Out "New Frazzle created in "∾dir∾"."
}

Init ⇐ {
  (0=≠𝕩) err._Assert_ "fraz init does not accept arguments.  Did you mean 'fraz new <dir>'?"
  frazFile ← •wdpath •file.At ".frazzle"
  (¬•file.Exists frazFile) err._Assert_ "This directory is already a Frazzle."
  WriteConfig frazFile
  •Out "Frazzle initialised in "∾•wdpath
}

Add ⇐ {
  (0≠≠𝕩) err._Assert_ msg.use.add
  {"-i"≡⊑𝕩 ? (2<≠𝕩) err._Assert_ msg.use.add ⋄ frazIndex ↩ 1⊑𝕩 ; @}𝕩
  •Out frazIndex
}

Remove ⇐ { •Show⌽¨𝕩 }

SearchFrazzle ← { # TODO: Make it able to search descriptions as well, once I've figured out how to store and provide them
  (0≠≠𝕩) err._Assert_ msg.use.search
  offset ← 0 # Where the search term is (in case -i is used)
  {"-i"≡⊑𝕩 ? (3=≠𝕩) err._Assert_ msg.use.search ⋄ frazIndex ↩ 1⊑𝕩 ⋄ offset↩2 ; (1=≠𝕩) err._Assert_ msg.use.search}𝕩
  search ← offset⊑𝕩
  response ← curl.Get "ftp://"∾frazIndex # TODO: add check to make sure no protocol:// header
  (226=response.code) err._Assert_ ("Failed to fetch Frazzle index with code "∾(•Fmt response.code)∾".") # 226 is FTP OK
  files ← str.lf str.Split response.content
  files {⊑⌽' ' str.Split 𝕩}¨↩
  frazzles ← ".frz" str.SearchList files
  results ← search str.SearchList ¯4↓¨frazzles
}
GetDescription ← {
  # TODO: input checks
  response ← curl.Get ∾´"dict://"∾𝕨∾"/d:"∾𝕩 # TODO: add check to make sure no protocol:// header
  response ↩ str.lf⊸str.Cut¨ str.cr str.Cut response.content
  (552≠str.ParseInt 3↑⊑2⊑response) err._Assert_ (∾´"There is no Frazzle named '"∾𝕩∾"' at "∾𝕨∾".") # 552 is the DICT code for no entries found
  result ← ⊑4⊑response
}
Search ⇐ { •Out¨ frazIndex⊸GetDescription¨ SearchFrazzle 𝕩 }

Help ⇐ {
  (2>≠𝕩) err._Assert_ msg.use.help
  { 0=≠𝕩 ? •Out msg.help.fraz ⋄ •Exit 0 ; @ }𝕩 # Display toplevel help message if no command provided
  (∊⟜cmdSet⌾<⊑𝕩) err._Assert_ ("Allowed commands are: "∾{𝕨∾", "∾𝕩}´cmdSet)
  •Out cmdHelpMap.Get ⊑𝕩 
}

cmdFnMap ← cmdSet •HashMap ⟨new,init,add,remove,search,help⟩ # Allowed commands with their corresponding functions

# Run it!
args{𝕏𝕨}cmdFnMap.Get cmd

# 4