class Hush < Formula
  desc "Modern fuss-free SSH over QUIC"
  homepage "https://github.com/kdrag0n/hush"
  version "0.1.0"
  revision 21
  license "MIT"

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/kdrag0n/hush/releases/download/prerelease-main/hush-macos-aarch64",
        using: :nounzip
    sha256 "2d4927f09120cab356c6439b2faaaee4b2cbec259cf601bf60a40469026907bd"

    resource "hush-server" do
      url "https://github.com/kdrag0n/hush/releases/download/prerelease-main/hush-server-macos-aarch64",
          using: :nounzip
      sha256 "837109a0e83a26135e5ce2eb31fad30f3580bb7d9bdbd257e9d87a8cf2b622e5"
    end
  elsif OS.mac? && Hardware::CPU.intel?
    url "https://github.com/kdrag0n/hush/releases/download/prerelease-main/hush-macos-x86_64",
        using: :nounzip
    sha256 "9328dec1a86f5d87baf9f1b09767c1f79096c3d9bbc1234074e3761c43b74ea2"

    resource "hush-server" do
      url "https://github.com/kdrag0n/hush/releases/download/prerelease-main/hush-server-macos-x86_64",
          using: :nounzip
      sha256 "f56d9cf619fa6ff3717ce881e6bc5a6509c615115c23b604bf27ecdec62faf7f"
    end
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/kdrag0n/hush/releases/download/prerelease-main/hush-linux-aarch64-musl",
        using: :nounzip
    sha256 "0a3afc9b134920a0a4f01687a7982497389f766ccd18e7519c5dd9cb89b85d0c"

    resource "hush-server" do
      url "https://github.com/kdrag0n/hush/releases/download/prerelease-main/hush-server-linux-aarch64-musl",
          using: :nounzip
      sha256 "d77eae93d7e663a9874becbb9c0d525b286601e0e7dbc9d2298bc92d31ab44b2"
    end
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/kdrag0n/hush/releases/download/prerelease-main/hush-linux-x86_64-musl",
        using: :nounzip
    sha256 "5ecbc5a65c2efc93d46b810a638d241194217f85943684009bd495aa1841bc16"

    resource "hush-server" do
      url "https://github.com/kdrag0n/hush/releases/download/prerelease-main/hush-server-linux-x86_64-musl",
          using: :nounzip
      sha256 "085267dc402f5024e8a79b8c3858720a3c87a34d770858bb7ec5d8785f3d929e"
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
