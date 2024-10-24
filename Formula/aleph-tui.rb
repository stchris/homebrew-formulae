class AlephTui < Formula
  desc "A text user interface for Aleph"
  homepage "https://github.com/stchris/aleph-tui"
  version "0.4.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stchris/aleph-tui/releases/download/v0.4.1/aleph-tui-aarch64-apple-darwin.tar.xz"
      sha256 "6688172210568287a90856c85d9d46d426ee809ad5c5e8ad88ab1bb4cf8aef51"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stchris/aleph-tui/releases/download/v0.4.1/aleph-tui-x86_64-apple-darwin.tar.xz"
      sha256 "970229b7e3ad165956cce25c438e604c1bb3edb1e1ff9316d653ce7c53bbb9a3"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/stchris/aleph-tui/releases/download/v0.4.1/aleph-tui-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "ce64af7e29d4e8c27097c305a254921a539a45b231a2f9394cb02ccf6cf2cb41"
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
