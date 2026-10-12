class Hush < Formula
  desc "Modern fuss-free SSH over QUIC"
  homepage "https://github.com/kdrag0n/hush"
  version "0.1.0"
  revision 36
  license "MIT"

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/kdrag0n/hush/releases/download/prerelease-main/hush-macos-aarch64",
        using: :nounzip
    sha256 "aa3bc02ac245cf011af3f6a67e51201c8ef9c5f0483e6c9d3a79791b51ecf3a4"

    resource "hush-server" do
      url "https://github.com/kdrag0n/hush/releases/download/prerelease-main/hush-server-macos-aarch64",
          using: :nounzip
      sha256 "330400416caf8cfbc556b98e494cbb4af0cad21bcfba03a9025877cd304e5895"
    end
  elsif OS.mac? && Hardware::CPU.intel?
    url "https://github.com/kdrag0n/hush/releases/download/prerelease-main/hush-macos-x86_64",
        using: :nounzip
    sha256 "4d173667cfbc1af82a20bc58fe755846eb7463d4b0923850e12e6a6bbd6f6b55"

    resource "hush-server" do
      url "https://github.com/kdrag0n/hush/releases/download/prerelease-main/hush-server-macos-x86_64",
          using: :nounzip
      sha256 "c9dd4acf4c56fb8a9d134ef05b73de1b39f022858c6bd951b05ddfe69c24c5f9"
    end
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/kdrag0n/hush/releases/download/prerelease-main/hush-linux-aarch64-musl",
        using: :nounzip
    sha256 "a6c12839a365c8b40e27fb280934a74372155c572ffa670c9c09fcf28990e8fe"

    resource "hush-server" do
      url "https://github.com/kdrag0n/hush/releases/download/prerelease-main/hush-server-linux-aarch64-musl",
          using: :nounzip
      sha256 "85522f5a5e95b62eea234e0eeee233128f4f6a03fc466f266fab8d2f9e5f969b"
    end
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/kdrag0n/hush/releases/download/prerelease-main/hush-linux-x86_64-musl",
        using: :nounzip
    sha256 "b85986f2068d737d999f6984ad2a7363b9417e58b4eee5515fccfc673bf48eaf"

    resource "hush-server" do
      url "https://github.com/kdrag0n/hush/releases/download/prerelease-main/hush-server-linux-x86_64-musl",
          using: :nounzip
      sha256 "b21abfb89ed31731369d7f34c70714ecb35d032d5853d9c73dacc9e0df03cbc4"
    end
  else
    odie "hush prebuilt binaries are not available for this platform"
  end

  def install
    bin.install cached_download => "hush"
    bin.install resource("hush-server").cached_download => "hush-server"
    generate_completions_from_executable(bin/"hush", "--completions", shells: [:bash, :zsh])
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
