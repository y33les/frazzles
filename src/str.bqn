# Various string utility functions

tab ⇐ @+9 # Tab character
lf ⇐ @+10 # Line feed character
cr ⇐ @+13 # Carriage return character
Split ⇐ (⊢-˜+`×¬)∘=⊔⊢ # Split string 𝕩 by separator char 𝕨, removing the separators  (from BQNcrate)
Cut ⇐ (¬-˜⊢×·+`»⊸>)∘≠⊔⊢ # Cut string 𝕩 at occurrences of char 𝕨, removing separators and empty segments (from BQNcrate)
SearchList ⇐ {(/¬0=+´¨𝕨⊸⍷¨𝕩)⊏𝕩} # Return elements of list of strings 𝕩 containing the substring 𝕨