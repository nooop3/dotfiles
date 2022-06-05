# Dotfiles

## Runcom

### Tmux.conf

```bash
ln -s ~/github/dotfiles/runcom/tmux.conf ~/.tmux.conf
```

### pip.conf

```bash
ln -s ~/github/dotfiles/runcom/pip.conf ~/.config/pip/pip.conf
```

### inputrc

Enable Vim bindings for REPL like Python.

```bash
ln -s ~/github/dotfiles/runcom/inputrc ~/.inputrc
```

### terraformrc

```bash
ln -s ~/github/dotfiles/runcom/terraformrc ~/.terraformrc
```

## XDG_CONFIG_HOME

### neovim

```bash
ln -s ~/github/dotfiles/XDG_CONFIG_HOME/nvim ~/.config/nvim
```

## Softwares

### Joplin

#### Edit Keymap Config File

Add file `~/.config/joplin/keymap.json` with the content of './sofwares/joplin/keymap.json'

### Karabiner

#### Link `change-screenshot-keys.json` to Karabiner config folder

```bash
ln -s ~/github/dotfiles/sofwares/karabiner/change-screenshot-keys.json ~/.config/karabiner/assets/complex_modifications
```

#### Enable in the `Complex modifications` tab

## Mirrors

### Maven

#### Link `settings.xml` to m2 config folder

```bash
mkdir ~/.m2
ln -s $PWD/mirrors/settings.xml ~/.m2/settings.xml
```
