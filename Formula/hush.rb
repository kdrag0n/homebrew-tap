class Hush < Formula
  desc "Modern fuss-free SSH over QUIC"
  homepage "https://github.com/kdrag0n/hush"
  version "0.1.0"
  revision 19
  license "MIT"

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/kdrag0n/hush/releases/download/prerelease-main/hush-macos-aarch64",
        using: :nounzip
    sha256 "2f61f1d3af47ee0ab0f2b1d5b633e7a1764c165d7a0e482a296bdc4633297104"

    resource "hush-server" do
      url "https://github.com/kdrag0n/hush/releases/download/prerelease-main/hush-server-macos-aarch64",
          using: :nounzip
      sha256 "2c1e4f549edb8c635c1fffd5cdd34f840b35edd615a0c70dafe4e6a568480e57"
    end
  elsif OS.mac? && Hardware::CPU.intel?
    url "https://github.com/kdrag0n/hush/releases/download/prerelease-main/hush-macos-x86_64",
        using: :nounzip
    sha256 "bf4bd5e6c116de0825ec5be9234503a32202937854138691fa84e91f19f1a851"

    resource "hush-server" do
      url "https://github.com/kdrag0n/hush/releases/download/prerelease-main/hush-server-macos-x86_64",
          using: :nounzip
      sha256 "58ae855cb4c01a22cd13eae829e86e5412b28b9165eb655e29672a18318dd6fb"
    end
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/kdrag0n/hush/releases/download/prerelease-main/hush-linux-aarch64-musl",
        using: :nounzip
    sha256 "e4017e3bb0070f1d30b17a0d0e7b88d764f6226f5961e6c9fec15a5a4cef79a9"

    resource "hush-server" do
      url "https://github.com/kdrag0n/hush/releases/download/prerelease-main/hush-server-linux-aarch64-musl",
          using: :nounzip
      sha256 "5cc0206e33ffc32a33a04da399d88d6bf7dfc03735a9da7ca72e0d1c42637204"
    end
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/kdrag0n/hush/releases/download/prerelease-main/hush-linux-x86_64-musl",
        using: :nounzip
    sha256 "9e288b8b5179af65ed8b0bdf797523a5b92cae7afd00f942931b6a24fc632d67"

    resource "hush-server" do
      url "https://github.com/kdrag0n/hush/releases/download/prerelease-main/hush-server-linux-x86_64-musl",
          using: :nounzip
      sha256 "11dc9cdc613ef2253b434b8fdb75128d9feb545d7674a119baa4cf605333efab"
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
