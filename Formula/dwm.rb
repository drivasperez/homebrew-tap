class Dwm < Formula
  desc "A git/jj worktree manager"
  homepage "dwm.drpz.xyz"
  version "0.4.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/drivasperez/dwm/releases/download/v0.4.1/dwm-aarch64-apple-darwin.tar.xz"
      sha256 "beceacba3ae47cdab635cd417cecfdbbae721795d9d4b7a06d9fca815ed95323"
    end
    if Hardware::CPU.intel?
      url "https://github.com/drivasperez/dwm/releases/download/v0.4.1/dwm-x86_64-apple-darwin.tar.xz"
      sha256 "9ae934a6c600b37f07a3e851eb987fea99b43429c73f1977e99952242b60da6b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/drivasperez/dwm/releases/download/v0.4.1/dwm-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3a6170e58315561d65413b476798ad73dcf43c5e7b042896d06d77402c5cbeaf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/drivasperez/dwm/releases/download/v0.4.1/dwm-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "66487be7e92a3205e0f6c0fdded07ea3f1d6bf419b9bf49968aa496a434fe15d"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
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
    bin.install "dwm" if OS.mac? && Hardware::CPU.arm?
    bin.install "dwm" if OS.mac? && Hardware::CPU.intel?
    bin.install "dwm" if OS.linux? && Hardware::CPU.arm?
    bin.install "dwm" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
