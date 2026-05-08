#!/usr/bin/env bash
set -euo pipefail

die() {
  printf 'error: %s\n' "$*" >&2
  exit 1
}

sha256_file() {
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$1" | awk '{print $1}'
  else
    shasum -a 256 "$1" | awk '{print $1}'
  fi
}

require_asset() {
  local asset=$1
  [[ -f "${DIST_DIR}/${asset}" ]] || die "missing release asset ${DIST_DIR}/${asset}"
}

DIST_DIR=${DIST_DIR:-dist/plush}
FORMULA_PATH=${FORMULA_PATH:-Formula/plush.rb}
PLUSH_REPOSITORY=${PLUSH_REPOSITORY:-kdrag0n/plush}
RELEASE_TAG=${RELEASE_TAG:-prerelease-main}
PLUSH_VERSION=${PLUSH_VERSION:-0.1.0}
HOMEBREW_REVISION=${HOMEBREW_REVISION:-}

[[ -n "${HOMEBREW_REVISION}" ]] || die "HOMEBREW_REVISION must be set"
[[ "${HOMEBREW_REVISION}" =~ ^[0-9]+$ ]] || die "HOMEBREW_REVISION must be an integer"
command -v gh >/dev/null 2>&1 || die "gh CLI is required"

rm -rf "${DIST_DIR}"
mkdir -p "${DIST_DIR}"
gh release download "${RELEASE_TAG}" \
  --repo "${PLUSH_REPOSITORY}" \
  --dir "${DIST_DIR}" \
  --pattern 'plush-*' \
  --clobber

assets=(
  plush-macos-aarch64
  plush-macos-x86_64
  plush-linux-aarch64-musl
  plush-linux-x86_64-musl
)

for asset in "${assets[@]}"; do
  require_asset "${asset}"
done

url_base="https://github.com/${PLUSH_REPOSITORY}/releases/download/${RELEASE_TAG}"
sha_plush_macos_arm=$(sha256_file "${DIST_DIR}/plush-macos-aarch64")
sha_plush_macos_x64=$(sha256_file "${DIST_DIR}/plush-macos-x86_64")
sha_plush_linux_arm=$(sha256_file "${DIST_DIR}/plush-linux-aarch64-musl")
sha_plush_linux_x64=$(sha256_file "${DIST_DIR}/plush-linux-x86_64-musl")

mkdir -p "$(dirname "${FORMULA_PATH}")"

cat > "${FORMULA_PATH}" <<EOF
class Plush < Formula
  desc "Soft comfy bash-compatible shell"
  homepage "https://github.com/${PLUSH_REPOSITORY}"
  version "${PLUSH_VERSION}"
  license "MIT"
  revision ${HOMEBREW_REVISION}

  if OS.mac? && Hardware::CPU.arm?
    url "${url_base}/plush-macos-aarch64",
        using: :nounzip
    sha256 "${sha_plush_macos_arm}"
  elsif OS.mac? && Hardware::CPU.intel?
    url "${url_base}/plush-macos-x86_64",
        using: :nounzip
    sha256 "${sha_plush_macos_x64}"
  elsif OS.linux? && Hardware::CPU.arm?
    url "${url_base}/plush-linux-aarch64-musl",
        using: :nounzip
    sha256 "${sha_plush_linux_arm}"
  elsif OS.linux? && Hardware::CPU.intel?
    url "${url_base}/plush-linux-x86_64-musl",
        using: :nounzip
    sha256 "${sha_plush_linux_x64}"
  else
    odie "plush prebuilt binaries are not available for this platform"
  end

  def install
    bin.install cached_download => "plush"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/plush --version")
    assert_equal "hello\n", shell_output("#{bin}/plush -c 'echo hello'")
  end
end
EOF

ruby -c "${FORMULA_PATH}"

git config user.name "github-actions[bot]"
git config user.email "41898282+github-actions[bot]@users.noreply.github.com"
git add "${FORMULA_PATH}"

if git diff --cached --quiet; then
  printf 'Plush formula is already up to date.\n'
  exit 0
fi

git commit -m "Update plush prerelease formula"
git push
