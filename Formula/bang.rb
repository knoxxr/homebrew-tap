class Bang < Formula
  desc "Bang 프로그래밍 언어 컴파일러/런타임"
  homepage "https://github.com/knoxxr/bang"
  version "0.20.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/knoxxr/bang/releases/download/v0.20.0/bang-aarch64-apple-darwin.tar.xz"
      sha256 "231b85b7ae76a61773179ca4843429bd711b2a0e5efa1b98ad3d73a06b8a3c77"
    end
    if Hardware::CPU.intel?
      url "https://github.com/knoxxr/bang/releases/download/v0.20.0/bang-x86_64-apple-darwin.tar.xz"
      sha256 "d1f7aad378b3aeab322d30392597c17e7190190f9ed31abd8ce9879cdb9149d0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/knoxxr/bang/releases/download/v0.20.0/bang-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4dc7dee546dac63bdd0cb8a1b773a732be2c1ef5a57981256b8f078144efc79c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/knoxxr/bang/releases/download/v0.20.0/bang-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f48ed02db24497129d8f626485823d1b2e3cca31187b5620e916d13a0f7b1ab5"
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
