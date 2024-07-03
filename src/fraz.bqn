curl ← •Import "../lib/bqn-curl/curl.bqn"
read ← •Import "read.bqn"
err ← •Import "err.bqn"
msg ← •Import "msg.bqn"
str ← •Import "str.bqn"
config ← •Import "config.bqn"

cmdSet ⇐ ⟨"new","add","remove","search","help"⟩ # Allowed commands
cmdHelpMap ← cmdSet •HashMap ⟨msg.help.new,msg.help.add,msg.help.remove,msg.help.search,msg.help.help⟩ # Allowed commands with their corresponding help messages
frazIndex ← "get.frazzl.es" # Default Frazzle index

New ⇐ {
  (1=≠𝕩) err._Assert_ msg.use.new
  dir ← •wdpath •file.At ⊑𝕩
  (¬•file.Exists dir) err._Assert_ ("Directory "∾dir∾" already exists.")
  •file.CreateDir dir
  (dir •file.At ".frazzle") config.Write conf←config.Generate config.Input ""
  •file.CreateDir¨ dir⊸•file.At¨ "src"‿"lib"‿"test"
  (dir •file.At "LICENSE") •file.Lines ⟨∾´"<placeholder: "∾(conf.Get "license")∾">"⟩
  (dir •file.At "README.md") •file.Lines ⟨∾´"# "∾conf.Get "name","",conf.Get "description"⟩
  (dir •file.At "src" •file.At (conf.Get "name")∾".bqn") •file.Lines ⟨"Hello ⇐ {","  •Out ∾´""Hello, ""∾𝕩∾""!""","}"⟩
  (dir •file.At "main.bqn") •file.Lines ⟨∾´(conf.Get "name")∾" ← •Import ""src/"∾(conf.Get "name")∾".bqn""","",∾´(conf.Get "name")∾".Hello ""world"""⟩
  (dir •file.At "test" •file.At "all.bqn") •file.Lines ⟨"•Out ""Hello, world!"""⟩
  •Out "New Frazzle created in "∾dir∾"."
}

Add ⇐ {
  (0≠≠𝕩) err._Assert_ msg.use.add
  (•file.Exists •wdpath •file.At ".frazzle") err._Assert_ "This command must be run from the root directory of a Frazzle."
  offset ← 0
  {"-i"≡⊑𝕩 ? (2<≠𝕩) err._Assert_ msg.use.search ⋄ frazIndex ↩ 1⊑𝕩 ⋄ offset↩2 ; (1=≠𝕩) err._Assert_ msg.use.search}𝕩
  search ← offset↓𝕩
  •Show search
  Download ← {
    response ← curl.Get url ← ∾´"ftp://"∾frazIndex∾"/"∾𝕩∾".frz" # TODO: add check to make sure no protocol:// header
    •Show url
    (226=response.code) err._Assert_ ("Failed to fetch Frazzle index with code "∾(•Fmt response.code)∾" ("∾url∾").") # 226 is FTP OK
    libdir ← •wdpath •file.At "lib"
    outfile ← libdir •file.At "._frz_"∾𝕩
    •Show outfile
    outfile •file.Bytes response.content
    •SH "tar"‿"xJf"‿outfile # TODO: A pure BQN (or even an •FFI) solution would be nicer here at some point
    •file.Remove outfile
  }
  Download¨ search # TODO: test!!
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

# TODO: Test
# TODO: Build
# TODO: Run (not for libs) (run folder and run .frz file)
# TODO: Publish?