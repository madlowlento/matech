#!/bin/bash

# Ubuntu 24.04 Post-Install Setup Script
# Run as root or with sudo privileges

set -e

echo "🔧 Updating system..."
apt update && apt upgrade -y

echo "🧰 Installing essential tools..."
apt install -y \
  curl \
  wget \
  git \
  unzip \
  htop \
  build-essential \
  software-properties-common \
  ufw \
  apt-transport-https \
  ca-certificates \
  gnupg \
  lsb-release \
  net-tools \
  jq \
  tmux \
  zsh \
  neofetch \
  fail2ban

echo "🧱 Enabling firewall (UFW)..."
ufw allow OpenSSH
ufw --force enable

echo "🔐 Enabling SSH (already enabled by default on most servers)..."
systemctl enable ssh
systemctl start ssh

echo "🐳 Installing Docker..."
if ! command -v docker &> /dev/null; then
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
    https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null

  apt update
  apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  usermod -aG docker "$USER"
fi

echo "🟢 Docker installed successfully."

echo "⬇️ Installing Node.js (v20 LTS)..."
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt install -y nodejs

echo "🧪 Verifying installations..."
echo -n "Docker version: " && docker --version
echo -n "Node.js version: " && node -v
echo -n "NPM version: " && npm -v
echo -n "Git version: " && git --version

echo "📦 Installing Yarn..."
npm install -g yarn

echo "⚙️ Setting Zsh as default shell..."
chsh -s $(which zsh)

echo "📸 Installing Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

echo "🧹 Cleaning up..."
apt autoremove -y

echo "✅ Setup complete. Please restart your terminal or log out/in for changes to take effect."
