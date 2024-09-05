class AlephTui < Formula
  desc "A text user interface for Aleph"
  homepage "https://github.com/stchris/aleph-tui"
  version "0.3.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stchris/aleph-tui/releases/download/v0.3.2/aleph-tui-aarch64-apple-darwin.tar.xz"
      sha256 "54ca4b5d5acaa40b7d87a758b7ecaa42994eb91bec0d2b3571b255e2ddcf0490"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stchris/aleph-tui/releases/download/v0.3.2/aleph-tui-x86_64-apple-darwin.tar.xz"
      sha256 "efc8a8ade713ac43c4ce0b5010d6e5546de4ce8278bb9779e3f25c64ffa13fb6"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/stchris/aleph-tui/releases/download/v0.3.2/aleph-tui-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "5854f41f78c39b57afef10fa8452aca803918dca4a98516270133c3d0b74dac6"
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
