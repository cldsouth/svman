# svman — script vault manager
![version](https://img.shields.io/badge/version-0.1.0--alpha-blue)

A lightweight CLI tool for creating, organizing, installing and managing scripts. Store scripts in a structured vault, install them from GitHub, and back everything up with one tool.

---

## Installation
```bash
mkdir -p ~/.local/bin
curl -fsSL https://raw.githubusercontent.com/cldsouth/svman/main/svman \
  -o ~/.local/bin/svman
chmod +x ~/.local/bin/svman
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

> **Dependencies:** `bash`, `curl`, `git`. Optional: `gh` (GitHub CLI) for backup.

---

## Quick Start
```bash
svman new hello          # create a script called 'hello'
svman run hello          # run it
svman list               # see everything in your vault
```

---

## Scripts

### Create
```bash
svman new myscript               # opens default editor (nano)
svman new myscript -e vim        # open with a specific editor
svman new myscript -f network    # save into a folder
```

### Edit
```bash
svman edit myscript              # opens with snapshot — changes can be discarded
svman edit myscript -e kate      # open with a specific editor
```
> If you choose not to save, the script is automatically restored to its previous state.

### Run
```bash
svman run myscript
svman run myscript arg1 arg2     # pass arguments
```

### List
```bash
svman list                       # show full vault
svman list network               # filter by folder name or title
```

---

## Folders

Group your scripts into named folders with optional display titles.
```bash
svman folder new network                    # create folder 'network'
svman folder new work "Work Scripts"        # create with a custom title
svman folder rename work "Office Tools"     # rename display title

svman new portscan -f network               # save a script into a folder
svman list network                          # list a specific folder
```

Folders appear as separate sections in `svman list`:
```
  .-- vault
  ----------------------------------------
  |  hello
  ----------------------------------------

  .-- Work Scripts [work]
  ----------------------------------------
  |  deploy
  |  standup
  ----------------------------------------
```

---

## Pull from GitHub

Install scripts directly from GitHub repositories.
```bash
svman pull                            # interactive search
svman pull dylanaraps/pure-bash-bible # browse a specific repo
svman pull "dotfiles manager"         # keyword search
```

Search results are paginated. Navigate with:
- **number** — select a result
- **n** — next page
- **b** — back
- **p3** — jump to page 3
- **q** — quit
```bash
svman pull dylanaraps/pure-bash-bible -f utils    # install into a folder
svman pull -p 8                                    # show 8 results per page
```

---

## Editors

svman uses a whitelist to control which editors can be used. Default: `nano`.
```bash
svman editor list                       # show whitelist
svman editor add hx terminal            # add helix as a terminal editor
svman editor add code gui               # add VS Code as a GUI editor
svman editor remove gedit               # remove from whitelist
```

Set a default editor:
```bash
svman config set default_editor vim
```

---

## Configuration
```bash
svman config list                          # show all settings
svman config set pull_page_size 8          # results per page in pull
svman config set pull_desc_length 80       # description truncation length
svman config set default_editor vim        # default editor
svman config unset pull_page_size          # restore to default
```

| Key | Default | Description |
|-----|---------|-------------|
| `default_editor` | `nano` | Editor used when `-e` is not specified |
| `pull_page_size` | `5` | Results shown per page during `pull` |
| `pull_desc_length` | `55` | Max characters shown for repo descriptions |

---

## Backup
```bash
svman backup                  # push vault to existing git remote
svman backup -c               # create a new GitHub repo and push
svman backup -a               # save a local tar.gz snapshot
```

---

## Remove
```bash
svman remove myscript         # delete a single script
svman remove -f network       # delete a folder and all its contents
svman remove --all            # clear the entire vault
svman nuke                    # wipe vault + all svman config
```

> Destructive actions require confirmation. `nuke` requires typing `confirm nuke`.

---

## Vault Structure
```
~/.local/bin/
├── vault/
│   ├── hello
│   ├── network/
│   │   ├── .title
│   │   └── portscan
│   └── work/
│       ├── .title
│       └── deploy
└── svman

~/.config/svman/
├── config
└── editors
```

Scripts in the vault are symlinked to `~/.local/bin` and callable directly from the terminal.

---

## Shebang Auto-detection

svman sets the shebang automatically based on file extension:

| Extension | Shebang |
|-----------|---------|
| `.py` | `#!/usr/bin/env python3` |
| `.js` | `#!/usr/bin/env node` |
| `.zsh` | `#!/usr/bin/env zsh` |
| `.rb` | `#!/usr/bin/env ruby` |
| `.pl` | `#!/usr/bin/env perl` |
| *(none / `.sh`)* | `#!/usr/bin/env bash` |

---

## License

MIT

