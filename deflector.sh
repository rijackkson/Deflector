#!/bin/bash

# ==========================================
# DEFLECTOR: Native Search Key Remapper
# ==========================================
PLIST_NAME="com.local.deflector.plist"
PLIST_DIR="$HOME/Library/LaunchAgents"
PLIST_PATH="$PLIST_DIR/$PLIST_NAME"

# Hex Codes
# Source: Consumer Search (Magnifying Glass) -> 0x0C00000221
SRC_HEX="0xC00000221"
# Dest: F19 -> 0x07000006E
DST_HEX="0x70000006E"

# ==========================================
# FUNCTIONS
# ==========================================

function print_header() {
    clear
    echo "======================================================="
    echo "   🛡️  DEFLECTOR: Search Key Remapper                 "
    echo "======================================================="
    echo " Deflects the native 'Search' (F4) signal to F19.      "
    echo " Compatible with: Raycast, Alfred, BetterTouchTool.    "
    echo "-------------------------------------------------------"
}

function check_status() {
    echo "STATUS CHECK:"
    if launchctl list | grep -q "${PLIST_NAME%.plist}"; then
        echo "  ✅  Active: Deflector shielding is UP (Loaded)."
    else
        echo "  ❌  Inactive: Deflector is DOWN (Not loaded)."
    fi
    
    if [ -f "$PLIST_PATH" ]; then
        echo "  ✅  File:   Plist found at $PLIST_PATH"
    else
        echo "  ❌  File:   Plist not found."
    fi
    echo "-------------------------------------------------------"
}

function install_mapping() {
    echo ""
    echo "Initializing Deflector..."
    mkdir -p "$PLIST_DIR"

    # Create the Plist file
    cat << EOF > "$PLIST_PATH"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>${PLIST_NAME%.plist}</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/bin/hidutil</string>
        <string>property</string>
        <string>--set</string>
        <string>{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":$SRC_HEX,"HIDKeyboardModifierMappingDst":$DST_HEX}]}</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
EOF

    # Unload first (to clear old states), then Load
    launchctl bootout gui/$(id -u) "$PLIST_PATH" 2>/dev/null
    launchctl bootstrap gui/$(id -u) "$PLIST_PATH"
    
    echo "✅  Success! The Search key is now broadcasting F19."
    echo "👉  NEXT STEP: Open Raycast/Alfred settings and map your hotkey."
}

function uninstall_mapping() {
    echo ""
    echo "Uninstalling..."
    
    # 1. Unload from launchd
    launchctl bootout gui/$(id -u) "$PLIST_PATH" 2>/dev/null
    
    # 2. Delete the file
    if [ -f "$PLIST_PATH" ]; then
        rm "$PLIST_PATH"
        echo "✅  Plist file removed."
    else
        echo "⚠️   Plist file was already missing."
    fi

    # 3. Reset the current session immediately (no reboot needed)
    /usr/bin/hidutil property --set '{"UserKeyMapping":[]}'
    
    echo "✅  Deflector disabled. The Search key is back to default."
}

function test_session() {
    echo ""
    echo "Applying mapping for THIS session only..."
    /usr/bin/hidutil property --set "{\"UserKeyMapping\":[{\"HIDKeyboardModifierMappingSrc\":$SRC_HEX,\"HIDKeyboardModifierMappingDst\":$DST_HEX}]}"
    echo "✅  Active (Temporary). Press the Search key to test."
    echo "ℹ️   (This will revert automatically when you restart)."
}

# ==========================================
# MAIN MENU
# ==========================================

while true; do
    print_header
    check_status
    echo ""
    echo "1) 🛡️   Engage Deflector (Persistent Install)"
    echo "2) 🧪  Test Frequency (Current Session Only)"
    echo "3) 🗑️   Disengage & Reset Defaults"
    echo "4) 🚪  Exit"
    echo ""
    read -p "Select an option [1-4]: " option

    case $option in
        1)
            install_mapping
            read -p "   [Press Enter to continue...]"
            ;;
        2)
            test_session
            read -p "   [Press Enter to continue...]"
            ;;
        3)
            uninstall_mapping
            read -p "   [Press Enter to continue...]"
            ;;
        4)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid option."
            sleep 1
            ;;
    esac
done
