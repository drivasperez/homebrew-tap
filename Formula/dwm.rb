class Dwm < Formula
  desc "A git/jj worktree manager"
  homepage "dwm.drpz.xyz"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/drivasperez/dwm/releases/download/v0.1.1/dwm-aarch64-apple-darwin.tar.xz"
      sha256 "97e08061b180a6c04cb9d1fc16e9e12e2d22a4dc82c9cb928fea5080a8f5b1d0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/drivasperez/dwm/releases/download/v0.1.1/dwm-x86_64-apple-darwin.tar.xz"
      sha256 "bd5a84fcd903806b100ac07bb55854b60c4b115642bb461289b7890799dadad2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/drivasperez/dwm/releases/download/v0.1.1/dwm-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3860ff40e2963e511b5e86854f1980eb3cf1dfcb42547ccc165554710ebd5bb9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/drivasperez/dwm/releases/download/v0.1.1/dwm-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2ca93e2ea21c3aad6c2558543966bfb544e964687db1b8882fd248b038f18155"
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
