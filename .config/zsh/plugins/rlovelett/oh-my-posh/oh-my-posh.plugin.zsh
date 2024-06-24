# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Function to install oh-my-posh using Homebrew
install_with_brew() {
  echo "Installing oh-my-posh using Homebrew..."
  brew install oh-my-posh
}

# Function to download file using cURL or wget
download_file() {
  local url=$1
  local dest=$2

  if command_exists curl; then
    curl -Lo "$dest" "$url"
  elif command_exists wget; then
    wget -O "$dest" "$url"
  else
    echo "Error: neither cURL or wget is available."
    return 1
  fi
}

# Function to determine the architecture for binary download
determine_arch() {
  local arch=$(uname -m)
  case $arch in
    x86_64)
      echo "amd64"
      ;;
    arm64 | aarch64)
      echo "arm64"
      ;;
    *)
      echo "Unsupported architecture: $arch"
      return 1
      ;;
  esac
}

# Function to install oh-my-posh directly from GitHub Releases
install_from_github() {
  local install_dir="$HOME/.local/bin"
  local oh_my_posh_version="v22.0.2"
  # Determine OS
  local os=$(uname -s | tr '[:upper:]' '[:lower:]')
  local arch=$(determine_arch)

  if [[ $? -ne 0 ]]; then
    echo "$arch"
    return 1
  fi

  local binary_url="https://github.com/JanDeDobbeleer/oh-my-posh/releases/download/${oh_my_posh_version}/posh-${os}-${arch}"

  echo "Installing oh-my-posh using GitHub Releases..."
  mkdir -p "${install_dir}"
  if ! download_file "$binary_url" "${install_dir}/oh-my-posh"; then
    return 1
  fi
  chmod +x "${install_dir}/oh-my-posh"
}

# Main installation logic
if ! command_exists oh-my-posh; then
  if command_exists brew; then
    install_with_brew
  else
    if ! install_from_github; then
      echo "Failed to install oh-my-posh."
      exit 1
    fi
  fi
fi

eval "$(oh-my-posh init zsh --config ${XDG_CONFIG_HOME:-${HOME}/.config}/ohmyposh/base.toml)"
