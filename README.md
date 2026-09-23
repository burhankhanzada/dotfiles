# Burhan Khanzada - Dotfiles

```sh
    ____        __  _____ __           
   / __ \____  / /_/ __(_) /__  _____  
  / / / / __ \/ __/ /_/ / / _ \/ ___/  
 / /_/ / /_/ / /_/ __/ / /  __(__  )   
/_____/\____/\__/_/ /_/_/\___/____/    
Burhan Khanzada - Personal Dotfiles
```

Modern, modular, and aesthetic dotfiles environment for macOS. Features an interactive multi-tab TUI installer wizard, decoupled package architecture, complete developer toolchain automation (Android SDK, Flutter/FVM, Java, Node, Python, Rust), and granular macOS preferences management.

---

## Quick Start

### 1. Clone into `~/.dotfiles`

```sh
git clone https://github.com/burhankhanzada/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

### 2. Run the Interactive Setup Wizard

```sh
make install
# or
./bootstrap.sh
```

---

## Makefile Command Reference

A top-level [`Makefile`](file:///Users/burhankhanzada/.dotfiles/Makefile) provides quick shortcuts for day-to-day management:

| Command | Description |
| :--- | :--- |
| `make help` | Show all available commands and descriptions |
| `make install` | Launch the full interactive setup wizard |
| `make update` | Pull dotfiles updates, update Homebrew, and update modular toolchains |
| `make doctor` | Run comprehensive health check on binaries, SDK paths, symlinks, and GUI session |
| `make check` | Run syntax validation (`bash -n`, `zsh -n`) and compile all Python wizard modules |
| `make dry-run` | Preview configuration without modifying the disk or prompting for `sudo` |
| `make status` | Inspect installed binary, hook, and shell configuration status across all packages |
| `make packages` | Configure modular packages (e.g. `make packages PKG="git node"`) |
| `make defaults` | Apply macOS system preferences and defaults |
| `make reset-macos` | Reset macOS system preferences to factory values |
| `make zsh` | Idempotently re-configure Zsh environment, profiles, and loader |

---

## Environment & Tooling Doctor

Run `make doctor` or `./core/doctor.sh` at any time to verify system health:

```sh
make doctor
```

The doctor validates:

* **Developer Binaries**: `git`, `brew`, `zsh`, `python3`, `node`, `java`, `android`, `adb`, `avdmanager`, `sdkmanager`, `dart`, `flutter`, `fvm`.
* **SDK Environment Variables**: `ANDROID_HOME`, `ANDROID_SDK_ROOT`, `JAVA_HOME`, `FLUTTER_ROOT`, `DART_ROOT`, `HOMEBREW_PREFIX`.
* **macOS GUI Session Sync**: Confirms `launchctl` has active variables exported for GUI applications (Antigravity IDE, VS Code, Android Studio).
* **Symlinks & Directory Health**: Verifies that shared extension directories and development folders are intact without broken links.

---

## Package Lifecycle Contract

All modular packages reside under [`packages/<name>/`](file:///Users/burhankhanzada/.dotfiles/packages) and remain completely decoupled from `$HOME/.zshrc`. The dynamic loader ([`zsh/init.zsh`](file:///Users/burhankhanzada/.dotfiles/zsh/init.zsh)) automatically discovers and activates them:

| File | Purpose | Execution Timing |
| :--- | :--- | :--- |
| `install.sh` | Installs dependencies via Homebrew, SDK managers, etc. | Running wizard / `make packages` |
| `links.sh` | Safely symlinks configs and data directories into `$HOME` | Running wizard / `make packages` |
| `post_install.sh` | One-time post-link actions (service restarts, daemons) | Running wizard / `make packages` |
| `env.zsh` | Exports `PATH`, SDK roots (`*_HOME`), and compiler flags | Loaded dynamically on each shell startup |
| `aliases.zsh` | Tool-specific command shortcuts | Loaded dynamically on each shell startup |
| `functions.zsh` | Tool-specific shell helpers and utilities | Loaded dynamically on each shell startup |

---

## Shell Ergonomics & Productivity

### 1. Zsh History & Secret Protection

* **Persistent 50,000 line history** stored in `~/.zsh_history`.
* `SHARE_HISTORY`: Real-time shared history across all open terminal windows and tabs.
* `HIST_IGNORE_SPACE`: Commands prepended with a space are omitted from history (protects API keys, passwords, and tokens).
* `EXTENDED_HISTORY`: Logs timestamps and execution durations.

### 2. Directory Navigation Ergonomics

* `AUTO_CD`: Jump to any directory simply by typing its path or name (e.g. `..`, `Development`, `Projects`).
* `AUTO_PUSHD`: Automatically maintains a clean directory stack history.

### 3. Built-in Shell Shortcuts

* `dotfiles`: Jump directly to `~/.dotfiles` (`cd "$DOTFILES"`).
* `doctor`: Run health diagnostics (`make -C "$DOTFILES" doctor`).
* `dotstatus`: Check package binary and hook status (`make -C "$DOTFILES" status`).
* `dotcheck`: Run syntax checks on all shell and Python files (`make -C "$DOTFILES" check`).
* `reld`: Reload current Zsh session (`source ~/.zshrc`).
* `path`: Pretty-print `$PATH` with one entry per line.
* `eza` / `exa`: Enhanced directory listing with icons, git status, and tree views (`ls`, `l`, `ll`, `la`, `lt`).

### 4. Android Development Aliases

* `avd-list`: List all installed Android Virtual Devices.
* `avd-run <name>`: Boot an Android emulator without opening Android Studio.
* `adb-devices`: View connected devices with human-readable models.
* `adb-restart`: Restart the ADB daemon.
* `adb-screenshot`: Take a screenshot on the connected device and save to Desktop.
* `adb-ip`: Display the connected device's WLAN IP address.

---

## IDE & MCP Integration

* **Antigravity IDE & VS Code**:
  * Automatically merges and symlinks extensions into a unified shared base: `~/.vscode-base-ide-extensions`.
  * Configures `avdmanager.sdkPath` pointing to `~/Library/Android/sdk` for seamless emulator launching.
* **Dart & Flutter MCP Server**:
  * Pre-configured in `~/.gemini/config/mcp_config.json` with direct binary paths and environment sync.

---

## Repository Architecture

```text
.
├── Makefile                          # Unified build, test, update, and management shortcuts
├── Brewfile                          # Declarative Homebrew bundle (CLI, casks, fonts, MAS)
├── README.md                         # Documentation & architecture reference
├── bootstrap.sh                      # Main system orchestrator (interactive wizard + unattended)
│
├── core/                             # Core library & management foundation
│   ├── colors.sh                     # Lightweight, high-performance ANSI color & log helpers
│   ├── doctor.sh                     # System, SDK, and GUI environment health diagnostic
│   ├── fs.sh                         # Safe symlink and directory management utilities
│   ├── prompt.sh                     # Deduplicated confirmation prompt helper (_confirm_action)
│   ├── package.sh                    # Package lifecycle management & installation runner
│   ├── defaults.sh                   # macOS defaults discovery and execution engine
│   ├── tui.sh                        # Shell wrapper for Python curses TUI wizard
│   ├── tui_wizard.py                 # Interactive multi-tab curses setup wizard
│   ├── wizard/                       # Modular wizard package (banner, config, renderer, app)
│   └── init.sh                       # Core unified library loader (ensure_homebrew_env)
│
├── macos/                            # macOS system preferences & defaults
│   ├── defaults/
│   │   ├── ui.sh                     # UI & Appearance (dark theme, dock, animations, menu bar)
│   │   ├── finder.sh                 # Finder & Desktop (extensions, path bar, clutter, hidden files)
│   │   ├── hardware.sh               # Hardware & Input (key repeat, trackpad gestures, power)
│   │   └── system.sh                 # System & Screenshots (locations, formats, Metal HUD)
│   ├── setup.sh                      # Interactive/automated macOS defaults runner
│   ├── reset.sh                      # Clean restore of factory macOS defaults
│   └── README.md                     # macOS defaults & NVRAM inspection commands
│
├── zsh/                              # Zsh shell environment & configuration
│   ├── .zshrc                        # Clean interactive shell entry point
│   ├── .zprofile                     # Login shell profile (Homebrew shellenv)
│   ├── .zshenv                       # Environment variables (DOTFILES, DEVELOPMENT, PROJECTS)
│   ├── init.zsh                      # Dynamic loader for package configs & centralized GUI sync
│   ├── env.zsh                       # History, navigation ergonomics, and unique array options
│   ├── aliases.zsh                   # Global productivity & navigation shortcuts
│   └── setup.sh                      # Idempotent shell installer & migration cleaner
│
└── packages/                         # Self-contained modular packages
    ├── android-studio/               # IDE cask installer + env.zsh (JBR PATH)
    ├── android-tools/                # Platform tools + cmdline tools + completion cache + aliases
    ├── antigravity-ide/              # AI IDE + shared extensions link + env.zsh
    ├── cmake/                        # Build system + env.zsh (gnubin PATH)
    ├── cocoapods/                    # CocoaPods installer + links
    ├── firebase/                     # Firebase CLI installer
    ├── flutter/                      # FVM setup + env.zsh (FLUTTER_ROOT, DART_ROOT, pub-cache)
    ├── generic/                      # Core directory links (.cache, .config)
    ├── git/                          # Git config + aliases.zsh + env.zsh + functions.zsh
    ├── java/                         # OpenJDK + env.zsh (JAVA_HOME, bin PATH)
    ├── llvm/                         # Clang/LLVM + env.zsh (LDFLAGS, CPPFLAGS, bin PATH)
    ├── node/                         # Node LTS installer + links
    ├── parallels/                    # Parallels cask installer + links
    ├── python/                       # Pyenv + env.zsh (PYENV_ROOT, shims PATH) + links
    ├── ruby/                         # Chruby + env.zsh (chruby sourcing, gem PATH)
    ├── rust/                         # Rustup installer + env.zsh (cargo PATH)
    ├── vscode/                       # VS Code setup + shared extensions link + styles.css
    ├── warp/                         # Warp AI terminal configs & links
    ├── wine/                         # Wine development links
    ├── xcode/                        # Xcode license and developer tool setup
    ├── yabai/                        # Yabai/skhd configs (.yabairc, .skhdrc) + post_install
    └── setup.sh                      # Package batch/TUI configuration runner (-u, --dry-run)
```
