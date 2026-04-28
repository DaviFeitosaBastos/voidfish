# voidfish 🐟

A minimal but information-rich Fish shell theme built for developers and security enthusiasts. Forked and heavily customized from [fisk](https://github.com/oh-my-fish/plugin-fisk).

## Preview

```
[0] davi@feitosa0x ~/D/G/Conversor (main +1 ~2 ?1 ⬆1 ⬇1 ⎇2) $          1.2s(14:32:07)
```

```
⚡ root@feitosa0x ~/D/G/Conversor (main) [ROOT] ➜#                          (14:32:07)
```

## Features

- Exit code indicator — green on success, red on failure
- Git branch with full status indicators
- Python virtualenv detection
- Command duration — shown only when relevant (>100ms)
- Current time on the right prompt
- Distinct root prompt with `⚡ [ROOT] ➜#`

## Git Indicators

| Symbol | Color | Meaning |
|--------|-------|---------|
| `+N` | green | N files staged |
| `~N` | red | N files modified |
| `?N` | gray | N untracked files |
| `⬆N` | magenta | N commits ahead of remote (push needed) |
| `⬇N` | orange | N commits behind remote (pull needed) |
| `⎇N` | cyan | N unmerged branches |

## Requirements

- [Fish shell](https://fishshell.com/) 3.0+
- [Oh My Fish](https://github.com/oh-my-fish/oh-my-fish)
- A [Nerd Font](https://www.nerdfonts.com/) (recommended: Hack Nerd Font)

## Installation

### User prompt

```bash
git clone https://github.com/DaviFeitosaBastos/voidfish
mkdir -p ~/.local/share/omf/themes/voidfish/functions
cp voidfish/functions/fish_prompt.fish ~/.local/share/omf/themes/voidfish/functions/
cp voidfish/functions/_fisk_concat.fish ~/.local/share/omf/themes/voidfish/functions/
omf theme voidfish
```

### Root prompt

```bash
sudo su
mkdir -p ~/.config/fish/functions
cp /path/to/voidfish/root/fish_prompt.fish ~/.config/fish/functions/fish_prompt.fish
exec fish
```

### Disable duplicate virtualenv indicator

Add this to `~/.config/fish/config.fish`:

```fish
set -g VIRTUAL_ENV_DISABLE_PROMPT 1
```

## Customization

Colors are defined as hex values at the top of `fish_prompt.fish`:

```fish
set -l c_red     c44   # user@host color
set -l c_blue    55f   # prompt symbol color
set -l c_yellow  ff5   # git branch color
set -l c_cyan    0cc   # unmerged branches
set -l c_orange  fa0   # behind remote
set -l c_magenta f0d   # ahead remote / virtualenv
```

Change any value to customize your prompt colors.

## Credits

Based on [fisk](https://github.com/oh-my-fish/plugin-fisk) by oh-my-fish.