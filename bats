#!/usr/bin/env bash

set -euo pipefail

BATS_VERSION=${BATS_VERSION:-1.11.1}

script_dir() {
  local script
  local dir
  script=${BASH_SOURCE[0]}
  while [ -L "$script" ]; do
    dir=$(cd -P "$(dirname "$script")" >/dev/null 2>&1 && pwd)
    script=$(readlink "$script")
    [[ $script != /* ]] && script=$dir/$script
  done
  cd -P "$(dirname "$script")" >/dev/null 2>&1 && pwd
}

download() {
  local url=$1
  local target=$2
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL -o "$target" "$url"
    return
  fi
  if command -v wget >/dev/null 2>&1; then
    wget -q -O "$target" "$url"
    return
  fi
  echo "Error: curl or wget is required to download bats-core." >&2
  exit 1
}

bootstrap_bats() {
  local install_dir=$1
  local tmp_dir
  local archive
  local src_dir

  tmp_dir=$(mktemp -d)
  trap 'rm -rf "$tmp_dir"' RETURN

  archive="$tmp_dir/bats-core-v${BATS_VERSION}.tar.gz"
  download "https://github.com/bats-core/bats-core/archive/refs/tags/v${BATS_VERSION}.tar.gz" "$archive"

  tar -xzf "$archive" -C "$tmp_dir"
  src_dir="$tmp_dir/bats-core-${BATS_VERSION}"

  mkdir -p "$install_dir"
  "$src_dir/install.sh" "$install_dir" >/dev/null
}

main() {
  local root
  local cache_dir
  local install_dir
  local bats_bin

  root=$(script_dir)
  cache_dir=${BATS_CACHE_DIR:-"$root/cache/_tools/bats"}
  install_dir="$cache_dir/v${BATS_VERSION}"
  bats_bin="$install_dir/bin/bats"

  if [[ ! -x "$bats_bin" ]]; then
    echo "Installing bats-core v${BATS_VERSION} into $install_dir" >&2
    bootstrap_bats "$install_dir"
  fi

  exec "$bats_bin" "$@"
}

main "$@"