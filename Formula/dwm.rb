class Dwm < Formula
  desc "A git/jj worktree manager"
  homepage "dwm.drpz.xyz"
  version "0.4.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/drivasperez/dwm/releases/download/v0.4.3/dwm-aarch64-apple-darwin.tar.xz"
      sha256 "1a3646af84acff1278c6abd11f5c3ab26c3a45c7805fd5d3ef7d2ae22c4f7384"
    end
    if Hardware::CPU.intel?
      url "https://github.com/drivasperez/dwm/releases/download/v0.4.3/dwm-x86_64-apple-darwin.tar.xz"
      sha256 "7fe97df1fb4a22bafa5b83af63f8cd1a35dea3cc6948af52daf93dddfcd28dbb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/drivasperez/dwm/releases/download/v0.4.3/dwm-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d911d924316e5436bf69cc2e4c1edbf1cee17a10194d6cd3c18237f806a4a054"
    end
    if Hardware::CPU.intel?
      url "https://github.com/drivasperez/dwm/releases/download/v0.4.3/dwm-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b14c4d96607021019629c90e883eccf861e8fb1f92b2e330e34bcfd0ff303975"
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
