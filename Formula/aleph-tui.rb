class AlephTui < Formula
  desc "A text user interface for Aleph"
  homepage "https://github.com/stchris/aleph-tui"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stchris/aleph-tui/releases/download/v0.4.0/aleph-tui-aarch64-apple-darwin.tar.xz"
      sha256 "7da9c641b6a6215c888922a4de8060c6f5f15e24f77da4087b522b4fcef3433f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stchris/aleph-tui/releases/download/v0.4.0/aleph-tui-x86_64-apple-darwin.tar.xz"
      sha256 "5adf58a46421e50ba717c1e16f0255b5f4ff4ecd582ea38d7e24f8bd22305984"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/stchris/aleph-tui/releases/download/v0.4.0/aleph-tui-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "f634ac818a841b39411541756df8f37d9f4088437dac6c5f893daea9ea41ac50"
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
