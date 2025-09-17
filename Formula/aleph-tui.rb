class AlephTui < Formula
  desc "A text user interface for Aleph"
  homepage "https://github.com/stchris/aleph-tui"
  version "0.4.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stchris/aleph-tui/releases/download/v0.4.4/aleph-tui-aarch64-apple-darwin.tar.xz"
      sha256 "7be544fffd14ec4449e3a2afafbe3e9fea749171f5a237be6dbd052f00d6fce7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stchris/aleph-tui/releases/download/v0.4.4/aleph-tui-x86_64-apple-darwin.tar.xz"
      sha256 "5b888ddfc4fe3076ec8a7a09f66415560cc24cc3c9d9b3f2343e897c7b7d07a2"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/stchris/aleph-tui/releases/download/v0.4.4/aleph-tui-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "3f1b1e6c407e1071bb99fb0874517113475eb9427898f9f68629ff414bfd1e73"
  end
  license "GPL-3.0-or-later"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
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
    bin.install "aleph-tui" if OS.mac? && Hardware::CPU.arm?
    bin.install "aleph-tui" if OS.mac? && Hardware::CPU.intel?
    bin.install "aleph-tui" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
