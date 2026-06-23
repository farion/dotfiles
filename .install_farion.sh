#!/usr/bin/env bash
set -euo pipefail

# Bootstrap a fresh Ubuntu/Debian workstation for these dotfiles.
# Safe to re-run: package installs and clones are guarded where practical.

DOTFILES_REPO="${DOTFILES_REPO:-https://github.com/farion/dotfiles.git}"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.cfg}"
REPOS_DIR="${REPOS_DIR:-/opt/repos}"
RUN_PRIVATE_SETUP="${RUN_PRIVATE_SETUP:-0}"
RUN_WORK_SETUP="${RUN_WORK_SETUP:-0}"

APT_PACKAGES=(
  adwaita-icon-theme
  adwaita-icon-theme-legacy
  adwaita-qt
  adwaita-qt6
  blueman
  build-essential
  cargo
  chafa
  clipman
  cliphist
  cmatrix
  cryptsetup
  curl
  direnv
  dunst
  equivs
  foot
  fonts-adwaita
  fonts-adwaita-sans
  fonts-firacode
  fonts-lato
  fonts-powerline
  fuzzel
  fzf
  git
  gir1.2-gtk-3.0
  gir1.2-webkit2-4.1
  gnome-themes-extra
  grim
  gsimplecal
  kanshi
  keepassxc
  libappindicator3-1
  libcairo2-dev
  libgirepository1.0-dev
  libsecret-tools
  light
  lm-sensors
  lxpolkit
  mako-notifier
  network-manager-applet
  network-manager-openconnect
  network-manager-openconnect-gnome
  neovim
  nextcloud-desktop
  nwg-look
  onedrive
  qt5ct
  qt6ct
  pamixer
  papirus-icon-theme
  pavucontrol
  pipx
  pkg-config
  playerctl
  pyenv
  python-is-python3
  python3
  python3-dev
  python3-gi
  python3-i3ipc
  python3-pip
  qalculate-gtk
  slurp
  sway
  swaybg
  swayidle
  swaylock
  sway-notification-center
  swappy
  thunar
  waybar
  wl-clipboard
  wob
  xdg-desktop-portal-wlr
  xdg-utils
  xfconf
  xwayland
  zsh
)

log() {
  printf '\n==> %s\n' "$*"
}

have() {
  command -v "$1" >/dev/null 2>&1
}

apt_install() {
  log "Installing apt packages"
  sudo apt-get update
  if sudo apt-get install -y "${APT_PACKAGES[@]}"; then
    return
  fi

  log "Bulk apt install failed; retrying package-by-package"
  local failed=()
  local package
  for package in "${APT_PACKAGES[@]}"; do
    if ! sudo apt-get install -y "$package"; then
      failed+=("$package")
    fi
  done

  if ((${#failed[@]} > 0)); then
    printf '\nThese apt packages could not be installed on this system:\n'
    printf '- %s\n' "${failed[@]}"
  fi
}

install_go_task_repo() {
  if apt-cache policy task 2>/dev/null | grep -q 'cloudsmith.io/public/task/task'; then
    return
  fi

  log "Adding Taskfile apt repository"
  curl -1sLf 'https://dl.cloudsmith.io/public/task/task/setup.deb.sh' | sudo -E bash
  sudo apt-get install -y task
}

install_teams_repo() {
  if [[ -f /etc/apt/sources.list.d/teams-for-linux-packages.sources ]]; then
    return
  fi

  log "Adding teams-for-linux apt repository"
  sudo install -d -m 0755 /etc/apt/keyrings
  sudo wget -qO /etc/apt/keyrings/teams-for-linux.asc https://repo.teamsforlinux.de/teams-for-linux.asc
  sudo tee /etc/apt/sources.list.d/teams-for-linux-packages.sources >/dev/null <<'EOF'
Types: deb
URIs: https://repo.teamsforlinux.de/debian/
Suites: stable
Components: main
Signed-By: /etc/apt/keyrings/teams-for-linux.asc
Architectures: amd64
EOF
  sudo apt-get update
  sudo apt-get install -y teams-for-linux
}

install_dotfiles() {
  if [[ -d "$DOTFILES_DIR" ]]; then
    log "Dotfiles repo already exists at $DOTFILES_DIR"
  else
    log "Cloning dotfiles bare repository"
    git clone --bare "$DOTFILES_REPO" "$DOTFILES_DIR"
  fi

  git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" config status.showUntrackedFiles no
  if ! git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" checkout; then
    printf '\nDotfiles checkout found conflicting existing files. Move them away and re-run:\n'
    git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" checkout 2>&1 | sed -n '/would be overwritten/,$p' || true
    exit 1
  fi
}

install_oh_my_zsh() {
  if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    log "Installing oh-my-zsh"
    RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  fi

  local custom_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
  mkdir -p "$custom_dir/plugins"

  if [[ ! -d "$custom_dir/plugins/zsh-autosuggestions" ]]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$custom_dir/plugins/zsh-autosuggestions"
  fi

  if [[ ! -d "$custom_dir/plugins/zsh-nvm" ]]; then
    git clone https://github.com/lukechilds/zsh-nvm "$custom_dir/plugins/zsh-nvm"
  fi

  if [[ "$(getent passwd "$USER" | cut -d: -f7)" != "$(command -v zsh)" ]]; then
    log "Changing default shell to zsh"
    chsh -s "$(command -v zsh)" "$USER"
  fi
}

install_rust() {
  if [[ ! -x "$HOME/.cargo/bin/cargo" ]]; then
    log "Installing rustup"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  fi
}

install_nvm() {
  if [[ ! -s "$HOME/.nvm/nvm.sh" ]]; then
    log "Installing nvm"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.5/install.sh | bash
  fi

  # shellcheck disable=SC1091
  source "$HOME/.nvm/nvm.sh"
  nvm install --lts
  nvm alias default node
}

install_pipx_tools() {
  log "Configuring pipx"
  pipx ensurepath
  pipx install gp-saml-gui || pipx upgrade gp-saml-gui || true
}

install_opencode() {
  if ! have opencode; then
    log "Installing opencode"
    curl -fsSL https://opencode.ai/install | bash
  fi
}

prepare_repos_dir() {
  if [[ ! -d "$REPOS_DIR" ]]; then
    sudo mkdir -p "$REPOS_DIR"
  fi
  sudo chown "$USER:$(id -gn)" "$REPOS_DIR"
}

clone_or_update() {
  local repo_url="$1"
  local target="$2"

  if [[ -d "$target/.git" ]]; then
    git -C "$target" pull --ff-only
  else
    git clone "$repo_url" "$target"
  fi
}

install_sway_interactive_screenshot() {
  if [[ -x /usr/local/bin/sway-interactive-screenshot ]]; then
    return
  fi

  log "Installing sway-interactive-screenshot"
  local tmp_file
  tmp_file="$(mktemp)"
  curl -fsSL https://raw.githubusercontent.com/moverest/sway-interactive-screenshot/master/sway-interactive-screenshot -o "$tmp_file"
  chmod +x "$tmp_file"
  sudo install -m 0755 "$tmp_file" /usr/local/bin/sway-interactive-screenshot
  rm -f "$tmp_file"
}

install_rust_tools_from_source() {
  prepare_repos_dir

  clone_or_update https://github.com/farion/kanshiui "$REPOS_DIR/kanshiui"
  clone_or_update https://github.com/farion/lazytime "$REPOS_DIR/lazytime"
  clone_or_update https://github.com/Linus789/wl-clip-persist.git "$REPOS_DIR/wl-clip-persist"

  log "Building KanshiUI"
  cargo build --release --manifest-path "$REPOS_DIR/kanshiui/Cargo.toml"
  sudo install -m 0755 "$REPOS_DIR/kanshiui/target/release/KanshiUI" /usr/local/bin/KanshiUI

  log "Building wl-clip-persist"
  cargo build --release --manifest-path "$REPOS_DIR/wl-clip-persist/Cargo.toml"
  sudo install -m 0755 "$REPOS_DIR/wl-clip-persist/target/release/wl-clip-persist" /usr/local/bin/wl-clip-persist
}

configure_gtk() {
  log "Configuring GTK icon theme"
  gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark' || true
  if have xfconf-query; then
    xfconf-query -c xsettings -p /Net/IconThemeName -s 'Papirus-Dark' --create -t string || true
  fi
}

install_private_volume() {
  if [[ "$RUN_PRIVATE_SETUP" != "1" ]]; then
    return
  fi

  log "Creating encrypted private volume"
  if [[ ! -f /opt/private.iso ]]; then
    sudo dd if=/dev/zero of=/opt/private.iso bs=1M count=100000 status=progress
    sudo cryptsetup luksFormat /opt/private.iso
  fi
  sudo mkdir -p /opt/private
  printf 'Open and mount later with: ~/.config/sway/scripts/mountprivate\n'
}

main() {
  apt_install
  install_go_task_repo
  install_teams_repo
  install_dotfiles
  install_oh_my_zsh
  install_rust
  install_nvm
  install_pipx_tools
  install_opencode
  install_sway_interactive_screenshot
  install_rust_tools_from_source
  configure_gtk
  install_private_volume
}

main "$@"
