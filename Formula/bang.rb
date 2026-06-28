class Bang < Formula
  desc "Bang 프로그래밍 언어 컴파일러/런타임"
  homepage "https://github.com/knoxxr/bang"
  version "0.23.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/knoxxr/bang/releases/download/v0.23.0/bang-aarch64-apple-darwin.tar.xz"
      sha256 "cb1ebff29470a022a360651d65c69c00afc34bda4546354fc4ccf7af492d17d8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/knoxxr/bang/releases/download/v0.23.0/bang-x86_64-apple-darwin.tar.xz"
      sha256 "db482801a282310a2ee3f33106694608310a089a7d54ea959b86d7aca0698fd9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/knoxxr/bang/releases/download/v0.23.0/bang-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ad0b0d3bb8ba2eb05504e828e15d3f336455ee0bdbc3d942a57fd1544f0a90e2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/knoxxr/bang/releases/download/v0.23.0/bang-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c90c530e2d544ccbe073e7934ea832b891f452b236c602f46748499ebc6c96a2"
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
