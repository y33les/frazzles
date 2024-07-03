fraz ← •Import "src/fraz.bqn"
msg ← •Import "src/msg.bqn"
err ← •Import "src/err.bqn"

cmdFnMap ← fraz.cmdSet •HashMap ⟨fraz.new,fraz.add,fraz.remove,fraz.search,fraz.help⟩ # Allowed commands with their corresponding functions

# Process arguments: fraz <cmd> <args>
args ← •args
{ 0=≠𝕩 ? •Out msg.help.fraz ⋄ •Exit 0 ; @ }args # Display help message if no arguments provided
cmd ← ⊑args
(∊⟜fraz.cmdSet⌾<cmd) err._Assert_ ("Allowed commands are: "∾{𝕨∾", "∾𝕩}´fraz.cmdSet) # Fail if cmd is unknown
args 1⊸↓↩

# Run it!
args{𝕏𝕨}cmdFnMap.Get cmd