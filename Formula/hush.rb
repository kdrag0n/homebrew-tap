class Hush < Formula
  desc "Modern fuss-free SSH over QUIC"
  homepage "https://github.com/kdrag0n/hush"
  version "0.1.0"
  revision 26
  license "MIT"

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/kdrag0n/hush/releases/download/prerelease-main/hush-macos-aarch64",
        using: :nounzip
    sha256 "95e52685bdf86b59d2248d4c24d51c8a15225246bb5a357a831368ff6e67e024"

    resource "hush-server" do
      url "https://github.com/kdrag0n/hush/releases/download/prerelease-main/hush-server-macos-aarch64",
          using: :nounzip
      sha256 "13bcd343d95b46ab7afbd7af311d1974a43d3b42decc15efc094fcbf38c590df"
    end
  elsif OS.mac? && Hardware::CPU.intel?
    url "https://github.com/kdrag0n/hush/releases/download/prerelease-main/hush-macos-x86_64",
        using: :nounzip
    sha256 "ff015231702403a5ad2ff029463c8a293e597d46c5a3e9030a9edf7ffabac724"

    resource "hush-server" do
      url "https://github.com/kdrag0n/hush/releases/download/prerelease-main/hush-server-macos-x86_64",
          using: :nounzip
      sha256 "eabd39817284df221989504086489e6e863d6395d98b09677f8a68c07f80b1d1"
    end
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/kdrag0n/hush/releases/download/prerelease-main/hush-linux-aarch64-musl",
        using: :nounzip
    sha256 "07694b05baccd6466389b0edab8c07673a539371af5585d2ff75fd1737256d03"

    resource "hush-server" do
      url "https://github.com/kdrag0n/hush/releases/download/prerelease-main/hush-server-linux-aarch64-musl",
          using: :nounzip
      sha256 "d95fbbd8a7cca12fa5c66cd0163db69e3e49fe93c993f05d5d206096db09117e"
    end
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/kdrag0n/hush/releases/download/prerelease-main/hush-linux-x86_64-musl",
        using: :nounzip
    sha256 "062839d45d14e2aa1e05d396fb3ab68b4ec9d0f473be89ebc02a88cdf3616ea7"

    resource "hush-server" do
      url "https://github.com/kdrag0n/hush/releases/download/prerelease-main/hush-server-linux-x86_64-musl",
          using: :nounzip
      sha256 "a9c26d8cb58a696eba68dfa7e37047d6f5362ec6606ad26a3eb640a350189eef"
    end
  else
    odie "hush prebuilt binaries are not available for this platform"
  end

  def install
    bin.install cached_download => "hush"
    bin.install resource("hush-server").cached_download => "hush-server"
  end

  service do
    run [opt_bin/"hush-server"]
    keep_alive true
    require_root true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hush --version")
    assert_match version.to_s, shell_output("#{bin}/hush-server --version")
  end
end
