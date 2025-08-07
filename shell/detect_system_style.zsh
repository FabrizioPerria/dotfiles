detect_system_style() {
    if echo "$OSTYPE" | grep -q "^darwin"; then
        # macOS: detect dark mode
        if [[ $(defaults read -g AppleInterfaceStyle 2>/dev/null) == "Dark" ]]; then
            COLOR_MODE="dark"
        else
            COLOR_MODE="light"
        fi
    elif [ -n "$XDG_CURRENT_DESKTOP" ]; then
        # Linux: try to detect dark/light GTK theme
        GTK_THEME=$(gsettings get org.gnome.desktop.interface gtk-theme 2>/dev/null | tr -d "'")
        if echo "$GTK_THEME" | grep -q "*[Dd]ark*"; then
            COLOR_MODE="light"
        else
            COLOR_MODE="dark"
        fi
    else
        COLOR_MODE="dark"
    fi
    echo "$COLOR_MODE"
}

detect_system_style
