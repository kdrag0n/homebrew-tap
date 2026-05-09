class Plush < Formula
  desc "Soft comfy bash-compatible shell"
  homepage "https://github.com/kdrag0n/plush"
  version "0.1.0"
  license "MIT"
  revision 5

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/kdrag0n/plush/releases/download/prerelease-main/plush-macos-aarch64",
        using: :nounzip
    sha256 "52f406f2be0efa85740dce281cf4ead6ac50aca7f79f7079cadf0a3bea38d618"
  elsif OS.mac? && Hardware::CPU.intel?
    url "https://github.com/kdrag0n/plush/releases/download/prerelease-main/plush-macos-x86_64",
        using: :nounzip
    sha256 "34051015685bfce4fc90b323faa8de264056548e27414add5319e60777739a13"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/kdrag0n/plush/releases/download/prerelease-main/plush-linux-aarch64-musl",
        using: :nounzip
    sha256 "8dd539365bc0378f91b2f32b520eabfea19d18849d0ef2f0ce075bd43c871a1a"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/kdrag0n/plush/releases/download/prerelease-main/plush-linux-x86_64-musl",
        using: :nounzip
    sha256 "c61d3c7f498e3df87abaac51d19e9beec3ddb6f7acf3be59d23969c98616484b"
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
