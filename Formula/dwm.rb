class Dwm < Formula
  desc "A git/jj worktree manager"
  homepage "dwm.drpz.xyz"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/drivasperez/dwm/releases/download/v0.4.0/dwm-aarch64-apple-darwin.tar.xz"
      sha256 "0ab656b6677ff6b513d519a8d4a111cd69b81666f2baefcc224e19cb840e421a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/drivasperez/dwm/releases/download/v0.4.0/dwm-x86_64-apple-darwin.tar.xz"
      sha256 "2acbc7cc0f4ff51b37fac4877bf62666cc6b0a2f0899b442e1a9de1f11cab915"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/drivasperez/dwm/releases/download/v0.4.0/dwm-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5f0392d01a8a07cf7c37c088d9850a47760e5cb1f9a6f1fb6048939adf60ec06"
    end
    if Hardware::CPU.intel?
      url "https://github.com/drivasperez/dwm/releases/download/v0.4.0/dwm-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6d09ad47ea856763becd15f32faffa5b2bd06583724402d01e31800bca9cef92"
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
