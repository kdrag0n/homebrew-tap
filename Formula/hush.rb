class Hush < Formula
  desc "Modern fuss-free SSH over QUIC"
  homepage "https://github.com/kdrag0n/hush"
  version "0.1.0"
  revision 15
  license "MIT"

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/kdrag0n/hush/releases/download/prerelease-main/hush-macos-aarch64",
        using: :nounzip
    sha256 "debcff793b9b7c093e8560e32804a279f1d75cce7f6b5dc016cce732d55b3d13"

    resource "hush-server" do
      url "https://github.com/kdrag0n/hush/releases/download/prerelease-main/hush-server-macos-aarch64",
          using: :nounzip
      sha256 "3c7c8bf9ae1428daf5b28a830e5a43a70bdc3965531f979392fc1e39ef5bd15b"
    end
  elsif OS.mac? && Hardware::CPU.intel?
    url "https://github.com/kdrag0n/hush/releases/download/prerelease-main/hush-macos-x86_64",
        using: :nounzip
    sha256 "bb4134c592735c4f89cb43e92b6a32dd55a9a1550b235de8cf2ab06d4d696c89"

    resource "hush-server" do
      url "https://github.com/kdrag0n/hush/releases/download/prerelease-main/hush-server-macos-x86_64",
          using: :nounzip
      sha256 "6371bc97deb48875bb5b73cc561d52902ceeb682dd09a87e2c8f77eb73205208"
    end
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/kdrag0n/hush/releases/download/prerelease-main/hush-linux-aarch64-musl",
        using: :nounzip
    sha256 "45e5ce4acea46a56b967ff087acb142df795d85c9f9febacf10fba09e4867946"

    resource "hush-server" do
      url "https://github.com/kdrag0n/hush/releases/download/prerelease-main/hush-server-linux-aarch64-musl",
          using: :nounzip
      sha256 "aba325121fb01b0e826997a9b5a62f4b7109a32089038e314720eeccc556ffa2"
    end
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/kdrag0n/hush/releases/download/prerelease-main/hush-linux-x86_64-musl",
        using: :nounzip
    sha256 "372e7def3cc2a9260be299c2997ebfdf85e31b1693ee4861901f1a105b93f355"

    resource "hush-server" do
      url "https://github.com/kdrag0n/hush/releases/download/prerelease-main/hush-server-linux-x86_64-musl",
          using: :nounzip
      sha256 "fafd73c16fcf79975bc098dae73b23a4e99d2a28657c0b2a286af32b614813cf"
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
