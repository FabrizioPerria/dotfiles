LS_COLORS='fi=38;5;248'       # Regular files: Dim white
LS_COLORS+=':mi=01;31'        # Missing files: Bright red
LS_COLORS+=':mh=00'           # Multi-hardlinked files: Default
LS_COLORS+=':ln=01;36'        # Symbolic links: Bright cyan
LS_COLORS+=':or=01;31'        # Orphaned symbolic links: Bright red
LS_COLORS+=':di=01;34'        # Directories: Bright blue
LS_COLORS+=':ow=01;35'        # Other-writable directories: Bright magenta
LS_COLORS+=':st=34'           # Sticky directories: Blue
LS_COLORS+=':tw=01;34'        # Sticky and other-writable directories: Bright blue
LS_COLORS+=':pi=01;33'        # Named pipes: Bright yellow
LS_COLORS+=':so=01;33'        # Sockets: Bright yellow
LS_COLORS+=':do=01;33'        # Door files (if supported): Bright yellow
LS_COLORS+=':bd=01;33'        # Block devices: Bright yellow
LS_COLORS+=':cd=01;33'        # Character devices: Bright yellow
LS_COLORS+=':su=01;35'        # Setuid files: Bright magenta
LS_COLORS+=':sg=01;35'        # Setgid files: Bright magenta
LS_COLORS+=':ca=01;35'        # Capability-enabled files: Bright magenta
LS_COLORS+=':ex=01;32'        # Executables: Bright green
LS_COLORS+=':no=38;5;248'     # Normal non-file text: Dim white
LS_COLORS+=':ma=01;35'        # Media files: Bright magenta
export LS_COLORS
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
zstyle ':completion:*' menu select

