class Bang < Formula
  desc "Bang 프로그래밍 언어 컴파일러/런타임"
  homepage "https://github.com/knoxxr/bang"
  version "0.19.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/knoxxr/bang/releases/download/v0.19.0/bang-aarch64-apple-darwin.tar.xz"
      sha256 "400a0f868c83475bcc302a52083b44273e545ab7b7ea4873046add51514899a5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/knoxxr/bang/releases/download/v0.19.0/bang-x86_64-apple-darwin.tar.xz"
      sha256 "a030d67182a260cc075ad1f75f93bb3b6ea9af2c658c38a070dd16d590ef885e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/knoxxr/bang/releases/download/v0.19.0/bang-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2c510f736b5c603c12617c14eea785913632aed4dd1d486bbde217933d4100a7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/knoxxr/bang/releases/download/v0.19.0/bang-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "396122abcc965da5f38bcda6e635ad64fbdf89c686be27edd4153e7e471736a0"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "bang" if OS.mac? && Hardware::CPU.arm?
    bin.install "bang" if OS.mac? && Hardware::CPU.intel?
    bin.install "bang" if OS.linux? && Hardware::CPU.arm?
    bin.install "bang" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
