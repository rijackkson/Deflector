# 🛡️ Deflector

**Deflect the dedicated macOS Search key to a useful frequency.**

Deflector is a lightweight, native utility for Apple Silicon Macs. It uses macOS's built-in `hidutil` to remap the dedicated **Search / Magnifying Glass** key (Usage Page: Consumer, ID: `0x221`) to **F19**. 

This allows you to bind the key to launchers like **Raycast** or **Alfred** while keeping your system clean of heavy third-party drivers like Karabiner-Elements.

## 🚀 Why use Deflector?
* **Zero Dependencies:** No background apps, no drivers, no `kext` files.
* **Native:** Uses Apple's pure `hidutil` binary.
* **Persistent:** Creates a local LaunchAgent so the mapping survives reboots.
* **Safe:** Includes an instant uninstaller that reverts changes immediately.

## 🎯 Perfect For
Once deflected to **F19**, this key becomes a global hotkey trigger perfect for:
* **Raycast:** Trigger the launcher or specific Quicklinks.
* **Alfred:** Launch workflows or the search bar.
* **BetterTouchTool:** Trigger complex touch bar or trackpad macros.
* **Obsidian / VS Code:** Bind to "Global Search" or command palettes.

## 📦 Installation

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/YOUR_USERNAME/deflector.git](https://github.com/YOUR_USERNAME/deflector.git)
    cd deflector
    ```

2.  **Make the script executable:**
    ```bash
    chmod +x deflector.sh
    ```

3.  **Run the Menu:**
    ```bash
    ./deflector.sh
    ```

### The Menu
The script provides a simple interface:
* `[1] Engage Deflector`: Sets up the permanent LaunchAgent.
* `[2] Test Frequency`: Applies the mapping for the *current session only* (resets on reboot).
* `[3] Disengage`: Removes the LaunchAgent and immediately resets the key to default.

## ⚙️ Technical Specs
macOS treats the dedicated Search key as a "Consumer Control" input rather than a standard keyboard key. Most simple remappers cannot see it. Deflector generates a persistent mapping for:

| Key | Usage Page | Usage ID | Hex Code |
| :--- | :--- | :--- | :--- |
| **Source (Search)** | Consumer | `0x221` | `0xC00000221` |
| **Destination (F19)** | Keyboard | `0x6E` | `0x70000006E` |

## License
MIT License.