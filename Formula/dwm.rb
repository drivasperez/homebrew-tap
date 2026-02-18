class Dwm < Formula
  desc "A git/jj worktree manager"
  homepage "dwm.drpz.xyz"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/drivasperez/dwm/releases/download/v0.2.0/dwm-aarch64-apple-darwin.tar.xz"
      sha256 "e8651cbae7b382c642c49714d4071f69dbeec4a31ff49f3520e2f439c1a5897c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/drivasperez/dwm/releases/download/v0.2.0/dwm-x86_64-apple-darwin.tar.xz"
      sha256 "62425544186fa5863cde344110212542173298c3d843a472d9b9e5352d95304a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/drivasperez/dwm/releases/download/v0.2.0/dwm-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3a10546fe05d178c31364df61c217454f314b6eb64591248aec50797da1da8b9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/drivasperez/dwm/releases/download/v0.2.0/dwm-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "18c59dd4ca45f7ab6ea52a22a18479ba0eb62f5ea7515a5c117f381612c1b00f"
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
