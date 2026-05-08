class Plush < Formula
  desc "Soft comfy bash-compatible shell"
  homepage "https://github.com/kdrag0n/plush"
  version "0.1.0"
  revision 1
  license "MIT"

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/kdrag0n/plush/releases/download/prerelease-main/plush-macos-aarch64",
        using: :nounzip
    sha256 "638e3e8b23d655ab9e40c4a4bfbc12674b1f6f93fb3912787e9a8fe23117a988"
  elsif OS.mac? && Hardware::CPU.intel?
    url "https://github.com/kdrag0n/plush/releases/download/prerelease-main/plush-macos-x86_64",
        using: :nounzip
    sha256 "496ec645aa4816cba4bacb21dee4f1619861b0d3d8d0983acac66c976d5a9dc7"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/kdrag0n/plush/releases/download/prerelease-main/plush-linux-aarch64-musl",
        using: :nounzip
    sha256 "5664436f6259f02330a7525d1054cc7b09b5e765b186a321bf9f455fac4e5e36"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/kdrag0n/plush/releases/download/prerelease-main/plush-linux-x86_64-musl",
        using: :nounzip
    sha256 "02748348ca7f6121f759e9c0b3b0ae34a36991a17f4fb5f5b5bc625eaad40932"
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
