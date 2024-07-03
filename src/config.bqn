r ← •Import "read.bqn"
str ← •Import "str.bqn"

headers ⇐ ⟨"name","description","website","author","email","version","type","licence","dependencies"⟩
Input ⇐ {
  •Out "Frazzle name:"
  name ← r.LineNoBlank 𝕩
  •Out "Description:"
  description ← r.LineNoBlank 𝕩
  •Out "Project website:"
  project ← r.LineNoBlank 𝕩
  •Out "Author:"
  author ← r.LineNoBlank 𝕩
  •Out "Email address:"
  email ← r.LineNoBlank 𝕩
  •Out "Version number:"
  version ← r.LineNoBlank 𝕩
  •Out "Frazzle type ('app' or 'lib'):"
  type ← {l←r.LineNoBlank 𝕩 ⋄ (l≡"app")∨(l≡"lib") ? l ; •Out "Frazzle type must be either 'app' or 'lib'." ⋄ 𝕊 𝕩} 𝕩
  •Out "Licence:"
  licence ← r.LineNoBlank 𝕩
  dependencies ← ""
  ⟨name,description,project,author,email,version,type,licence,dependencies⟩
}
# Generate a config HashMap where 𝕩 is a list of corresponding to the Frazzle name (string), description (string), project website (string), author (string), email (string), version (string), type (string: "app" or "lib") licence (string) and dependencies (list of lists of strings (index, Frazzle)).
# TODO: Implement dependency versioning like in Python (e.g. "numpy==1.1.14")
# TODO: Type checking
Generate ⇐ {
  n←≠headers
  ("Generate requires a list of length "∾(•Fmt n)∾".")!n=≠𝕩
  headers •HashMap 𝕩
}
Read ⇐ {
  config ← •file.Lines 𝕩
  config '→'⊸str.Cut¨↩
  keys ← ⥊⊑¨∘‿1⥊'→'⊸str.Split˝˘∘‿1⥊config
  values ← ⥊(⊑⌽)¨∘‿1⥊'→'⊸str.Split˝˘∘‿1⥊config
  (∾´"Keys do not match required config headers.
  Your keys:"∾str.tab∾str.tab∾(•Fmt keys)∾"
  Required keys:"∾str.tab∾(•Fmt headers))!headers≡keys
   "Config is missing values (or you have given a value which is the same as the key."!0=+´≡˝˘¯1↓⍉keys≍values
  {"dependencies"≡⊑⌽values ? values↩(¯1↓values)∾⟨⟨⟩⟩ ; @} # If dependencies not given (which Read processes as having the value "dependencies", set dependencies to be ⟨⟩ # TODO: parse dependencies instead of @
  out ← keys •Hashmap values
  "Frazzle must be of type 'app' or 'lib'."!0≠≠(out.Get "type") str.SearchList ⟨"app","lib"⟩
  out
}
Write ⇐ {
  # TODO: how to write dependencies?  need to convert list to config string format
  config ← <∘∾˘{𝕨∾"→"∾𝕩}˝˘⍉ (𝕩.Keys @) ≍ 𝕩.Values @
  𝕨 •file.Lines config
} # TODO: input checking