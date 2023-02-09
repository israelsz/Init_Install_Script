
# Install Script

This is a simple script for quickly install some dev tools that I use in a fresh install linux system (Mint 21)

Note: This script should work for another distro based in ubuntu 22.04

## Usage

Run the installation script in the terminal

```bash
sh install_script.sh
```

Restart the session after the script is done running to see all the changes.

In case zsh was installed make sure to have the .zshrc file in your home directory (~/.zshrc) if not go through the configuration screen that prompts after the first execution. 
To install plugins install Oh My Zsh
```bash
sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
```
To install plugins and powerlevel10k theme run the install zsh plugins script

```bash
sh install_zsh_plugins.sh
```

## Recommended font

The powerlevel10k may bug depending of the terminal font.

Hack nerd font works with no problem

https://www.nerdfonts.com/font-downloads

