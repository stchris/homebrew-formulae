class Pstexplorer < Formula
  desc "A CLI tool to explore and extract data from Outlook PST files"
  homepage "https://github.com/stchris/pstexplorer"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stchris/pstexplorer/releases/download/v0.3.0/pstexplorer-aarch64-apple-darwin.tar.xz"
      sha256 "2776ee649b1cb8fd885718882173eaa42a5b63ab148ecff7d37abdab22a45222"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stchris/pstexplorer/releases/download/v0.3.0/pstexplorer-x86_64-apple-darwin.tar.xz"
      sha256 "6a1df291d20d2c8c5ac5ee861ff434b38adbbe944bd97182f173337547117437"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stchris/pstexplorer/releases/download/v0.3.0/pstexplorer-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d63d02ae371bcf12e2973fd7386f592938e1f6bf69afc8367456a25c9722336e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stchris/pstexplorer/releases/download/v0.3.0/pstexplorer-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e82310535bee57b79cbfe296ec89926f512b0117ca8c321137364e64e88fc08a"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
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
    bin.install "pstexplorer" if OS.mac? && Hardware::CPU.arm?
    bin.install "pstexplorer" if OS.mac? && Hardware::CPU.intel?
    bin.install "pstexplorer" if OS.linux? && Hardware::CPU.arm?
    bin.install "pstexplorer" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
