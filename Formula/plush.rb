class Plush < Formula
  desc "Soft comfy bash-compatible shell"
  homepage "https://github.com/kdrag0n/plush"
  version "0.1.0"
  license "MIT"
  revision 6

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/kdrag0n/plush/releases/download/prerelease-main/plush-macos-aarch64",
        using: :nounzip
    sha256 "8c7e23645951c8c1672f0fc490f042a5903c385dcfff99112c31b18c2c123183"
  elsif OS.mac? && Hardware::CPU.intel?
    url "https://github.com/kdrag0n/plush/releases/download/prerelease-main/plush-macos-x86_64",
        using: :nounzip
    sha256 "2e32203c2b2820f92aec49488d8272c5ddb2360647e09b9b1c870ddcf0ab42e8"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/kdrag0n/plush/releases/download/prerelease-main/plush-linux-aarch64-musl",
        using: :nounzip
    sha256 "ad398c9dde80a34ba7ce37d03e4eac4ffb732ad2941e1c299f2bc28b6dc57736"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/kdrag0n/plush/releases/download/prerelease-main/plush-linux-x86_64-musl",
        using: :nounzip
    sha256 "6e12ef090b1e3717dcf8e7e3eb79e4fe4bd182cea126c7ce81704d1132d60404"
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
