# Burhan Khanzada - Dotfiles

Modern, modular, and aesthetic dotfiles environment for macOS. Features an interactive multi-tab TUI installer wizard, decoupled package architecture, and granular macOS preferences management.

---

## Architecture Overview

```dir
.
├── Brewfile                          # Declarative Homebrew bundle (CLI, casks, fonts, MAS)
├── README.md                         # Documentation & architecture guide
├── bootstrap.sh                      # Main system orchestrator (interactive wizard + unattended)
│
├── core/                             # Foundational libraries & helpers
│   ├── colors.sh                     # Lightweight, high-performance ANSI color & log helpers
│   ├── fs.sh                         # Safe symlink, directory, and path management utilities
│   ├── prompt.sh                     # Interactive confirmation prompts (continueAbortCommand/File)
│   ├── github.sh                     # GitHub release asset downloader
│   ├── package.sh                    # Package installation & lifecycle engine
│   ├── tui.sh                        # Shell wrapper for TUI wizard
│   ├── tui_wizard.py                 # Multi-tab curses interactive setup wizard entrypoint
│   ├── wizard/                       # Modular TUI wizard package (banner, config, renderer, app)
│   └── init.sh                       # Core library unified loader
│
├── macos/                            # macOS system preferences & defaults
│   ├── defaults/
│   │   ├── ui.sh                     # UI & Appearance (dark theme, dock, animations, menu bar)
│   │   ├── finder.sh                 # Finder & Desktop (extensions, path bar, clutter, hidden files)
│   │   ├── hardware.sh               # Hardware & Input (key repeat, trackpad gestures, power)
│   │   └── system.sh                 # System & Screenshots (locations, formats, Metal HUD)
│   ├── setup.sh                      # Interactive/automated macOS defaults runner
│   └── reset.sh                      # Clean restore of factory macOS defaults
│
├── zsh/                              # ZSH shell environment & configuration
│   ├── .zshrc                        # Clean interactive shell entry point
│   ├── .zprofile                     # Login shell profile (Homebrew shellenv)
│   ├── .zshenv                       # Environment variables (DOTFILES, DEVELOPMENT, PROJECTS)
│   ├── init.zsh                      # Dynamic loader for active package configs
│   ├── aliases.zsh                   # System & productivity aliases
│   └── setup.sh                      # Idempotent shell installer & migration cleaner
│
└── packages/                         # Self-contained, modular toolchain packages
    ├── android-studio/               # IDE cask installer + env.zsh (JBR PATH)
    ├── android-tools/                # CLI platform-tools + env.zsh (ANDROID_HOME, PATH, completion)
    ├── antigravity-ide/              # AI IDE + shared extensions link + env.zsh
    ├── cmake/                        # Build system + env.zsh (gnubin PATH)
    ├── cocoapods/                    # CocoaPods installer + links
    ├── firebase/                     # Firebase CLI installer
    ├── flutter/                      # FVM setup + env.zsh (pub-cache, fvm PATH) + post_install
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
    └── setup.sh                      # Package batch/TUI configuration runner
```

---

## Package Lifecycle Contract

Packages are self-contained within `packages/<name>/` and never mutate `$HOME/.zshrc`. The dynamic loader (`zsh/init.zsh`) automatically discovers and activates them:

| File | Purpose | Sourced When |
| :--- | :--- | :--- |
| `install.sh` | Installs dependencies via brew, curl, etc. | Running wizard / package installer |
| `links.sh` | Safely symlinks configs into `$HOME` | Running wizard / package installer |
| `post_install.sh` | One-time post-link actions (e.g. start daemons) | Running wizard / package installer |
| `env.zsh` | Exports `PATH`, `*_HOME`, and compiler flags | Automatically on each shell startup |
| `aliases.zsh` | Tool-specific command shortcuts | Automatically on each shell startup |
| `functions.zsh` | Tool-specific shell functions | Automatically on each shell startup |

---

## Getting Started

### 1. Clone into `~/.dotfiles`

```sh
git clone https://github.com/burhankhanzada/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

### 2. Run the Interactive Setup Wizard

```sh
./bootstrap.sh
```

### Command Line Options

```sh
./bootstrap.sh -y       # Install and configure everything non-interactively
./bootstrap.sh --no-tui # Bypass the interactive TUI wizard
./bootstrap.sh -h       # Show help message
```

---

## macOS Preferences

* **Apply macOS Defaults**:

  ```sh
  ~/.dotfiles/macos/setup.sh
  ```

* **Reset macOS Defaults to Factory**:

  ```sh
  ~/.dotfiles/macos/reset.sh
  ```

---

## Homebrew Bundle

* **Install all declared packages**:

  ```sh
  brew bundle --file=~/.dotfiles/Brewfile
  ```

* **Dump currently installed packages into Brewfile**:

  ```sh
  cd ~/.dotfiles && brew bundle dump -f --describe
  ```
