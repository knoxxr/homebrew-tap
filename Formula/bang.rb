class Bang < Formula
  desc "Bang 프로그래밍 언어 컴파일러/런타임"
  homepage "https://github.com/knoxxr/bang"
  version "0.10.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/knoxxr/bang/releases/download/v0.10.2/bang-aarch64-apple-darwin.tar.xz"
      sha256 "49c65e8e2874a0f430d19fe945cdc0a7d927ebb7f91fe9ef7d766165da3d5737"
    end
    if Hardware::CPU.intel?
      url "https://github.com/knoxxr/bang/releases/download/v0.10.2/bang-x86_64-apple-darwin.tar.xz"
      sha256 "9312cab6150c4c70a644b50febacc7cd04b48abea7ea22fc39a4cb48198306a6"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/knoxxr/bang/releases/download/v0.10.2/bang-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "282ea7780031d2d28679f408289f291e42db6ea1431ab78e43c4cd676626182d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/knoxxr/bang/releases/download/v0.10.2/bang-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f319f74c1ca165a1b2d967f88b2d8d384299a8dd027f0c47085da864cc0d07c6"
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
