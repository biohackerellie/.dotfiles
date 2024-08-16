#!/bin/bash

# Shell script to set up a fresh WSL environment
#
#
#
# Function to try a command and retry with sudo if it fails
try_command() {
    command=$1

    # Try the command without sudo
    eval $command
    exit_status=$?

    # Check if the command failed
    if [ $exit_status -ne 0 ]; then
        echo "Command failed, retrying with sudo..."
        eval "sudo $command"

        # Check if sudo command failed as well
        if [ $? -ne 0 ]; then
            echo "Command failed even with sudo."
            return 1
        fi
    fi

    return 0
}

# Set color variables
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

USERNAME="ellie"
WORK_DIR="/home/$USERNAME"


echo -e "${CYAN}Setting up a fresh WSL environment${NC}"

cd $WORK_DIR

echo -e "${CYAN}Updating and upgrading packages${NC}"

sudo apt update && sudo apt upgrade -y
sudo apt install -y curl wget 


echo -e "${CYAN}Installing github cli${NC}"
sudo apt install -y gh
gh auth login

echo -e "${CYAN}Installing basic packages${NC}"

echo -e "${CYAN}Installing zsh${NC}"
sudo apt-get install zsh





echo -e "${GREEN}Installing Golang${NC}"
mkdir $WORK_DIR/tmp
cd $WORK_DIR/tmp

curl -so "go1.23.0.linux-amd64.tar.gz" -L  https://go.dev/dl/go1.23.0.linux-amd64.tar.gz
sudo rm -rf /usr/local/go && tar -C /usr/local -xzf go1.23.0.linux-amd64.tar.gz

echo -e "${GREEN}Installing NodeJS${NC}"
# installs nvm (Node Version Manager)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
nvm install 22
node -v # should print `v22.6.0`
npm -v # should print `10.8.2`

echo -e "${GREEN}Installing pnpm${NC}"
try_command "curl -fsSL https://get.pnpm.io/install.sh | sh -"
if [ $? -ne 0 ]; then
    echo "Failed to install, exiting."
    exit 1
fi

echo -e "${GREEN}Installing Bun${NC}"
try_command "curl -fsSL https://bun.sh/install | bash"
if [ $? -ne 0 ]; then
    echo "Failed to install, exiting."
    exit 1
fi

echo -e "${GREEN}Installing Turbo${NC}"
try_command "pnpm install turbo --global"
if [ $? -ne 0 ]; then
    echo "Failed to install, exiting."
    exit 1
fi

echo -e "${GREEN}Installing Rust${NC}"
try_command "curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh"
if [ $? -ne 0 ]; then
    echo "Failed to install, exiting."
    exit 1
fi

echo -e "${GREEN}Installing Gum${NC}"
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
sudo apt update && sudo apt install gum

echo -e "${GREEN}Installing stow${NC}"
sudo apt install -y stow


echo -e "${GREEN}Installing lazygit${NC}"
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin

echo -e "${GREEN}Installing Neovim${NC}"
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz


echo -e "${GREEN}Installing dotfiles${NC}"
cd $WORK_DIR
gh repo clone biohackerellie/.dotfiles


echo -e "${GREEN}Installing oh-my-zsh${NC}"
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
gh repo clone romkatv/powerlevel10k $ZSH_CUSTOM/themes/powerlevel10k

echo -e "${RED}removing .bashrc and .zshrc${NC}"
rm -rf $WORK_DIR/.bashrc
rm -rf $WORK_DIR/.zshrc


echo -e "${YELLOW}Setting symlink between dotfiles and .config/ with stow${NC}"
cd $WORK_DIR/.dotfiles
stow config


echo -e "${GREEN} 🎉🎉 all done! ${NC}"


