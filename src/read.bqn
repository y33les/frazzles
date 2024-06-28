# Functions to read user input from the terminal

# Line feed character
lf ← @+10
# Append user input to 𝕩 until the Enter key is pressed

Line ⇐ { lf≠c←•term.CharB @ ? 𝕊 𝕩∾c ; 𝕩 }
# ReadLine, but refuse to output an empty string

LineNoBlank ⇐ { ""≢l←Line 𝕩 ? l ; •Out "This field cannot be left blank." ⋄ 𝕊 𝕩 }