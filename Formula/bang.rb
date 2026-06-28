class Bang < Formula
  desc "Bang 프로그래밍 언어 컴파일러/런타임"
  homepage "https://github.com/knoxxr/bang"
  version "0.24.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/knoxxr/bang/releases/download/v0.24.0/bang-aarch64-apple-darwin.tar.xz"
      sha256 "06f505241c3238a499d842f2623e2200834f531875a3d819f9e82f834709ab89"
    end
    if Hardware::CPU.intel?
      url "https://github.com/knoxxr/bang/releases/download/v0.24.0/bang-x86_64-apple-darwin.tar.xz"
      sha256 "fc7b21618455d0f072fcec1b5acdb62983486ad1661f8f1767209488b348aee6"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/knoxxr/bang/releases/download/v0.24.0/bang-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c073da2f2525245cd1c76433dfa3bd219d49f5fe60b1456b4b41eecf145885f9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/knoxxr/bang/releases/download/v0.24.0/bang-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "64a4528db280dda18d220ab05d3c8b2fde5405546fb31353707d1e8a4b71fcef"
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
