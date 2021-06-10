#!/bin/sh

echo "Setting up your Mac Home..."

# Check `for Homebrew and install if we don't have it
if test ! $(which brew); then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update Homebrew recipes
brew update

# Install all our dependencies with bundle (See Brewfile)
brew tap homebrew/bundle
brew bundle

# Make ZSH the default shell environment
chsh -s $(which zsh)

chmod 755 /usr/local/share/zsh
chmod 755 /usr/local/share/zsh/site-functions

# Install oh-my-zsh and config
# #TODO add check for installed oh my zsh
# ZSH=~/config/ohmyzsh sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions 2> /dev/null
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting 2> /dev/null
git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime 2> /dev/null \
	sh ~/.vim_runtime/install_awesome_vimrc.sh
touch $HOME/.aliases && chmod 755 $HOME/.aliases
touch $HOME/.functions && chmod 755 $HOME/.functions
cp ./config/.bashrc $HOME/.bashrc
cp ./config/.zshrc $HOME/.zshrc
cp ./config/.zprofile $HOME/.zprofile
cp ./config/.profile $HOME/.profile
cp ./config/.gitignore $HOME/.gitignore
cp ./config/.gitignore_global $HOME/.gitignore_global
cp ./config/.gitconfig $HOME/.gitconfig
cp ./config/.bash.local $HOME/.bash.local
cp ./config/.bash_exports $HOME/.bash_exports
cp ./config/.bash_autocomplete $HOME/.bash_autocomplete
cp ./config/.bash_logout $HOME/.bash_logout
cp ./config/.bash_options $HOME/.bash_options
cp ./config/.bash_profile $HOME/.bash_profile
cp ./config/.bash_prompt $HOME/.bash_prompt
cp ./config/.console_bash_aliases $HOME/.console_bash_aliases
cp ./config/directories.zsh $HOME/.oh-my-zsh/lib/directories.zsh
cp ./config/misc.zsh $HOME/.oh-my-zsh/lib/misc.zsh
cp ./config/functions.zsh $HOME/.oh-my-zsh/lib/functions.zsh
cp ./config/git.zsh $HOME/.oh-my-zsh/lib/git.zsh

# # Install global NPM packages
# # npm install --global yarn gulp eslint prettier # might add (now)

# Set macOS preferences
# We will run this last because this will reload the shell
source .macos
