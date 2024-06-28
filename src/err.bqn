# Nicer error-handling functions for the CLI

# Fail prettily (users don't need a stack trace) with message 𝕨 and ignore 𝕩
Fail ⇐ { •Out 𝕨 ⋄ •Exit ¯1}

# Assert 𝔽 and fail prettily with message 𝕘
_Assert_ ⇐ { !⎊(𝕘⊸fail) 𝕗 }