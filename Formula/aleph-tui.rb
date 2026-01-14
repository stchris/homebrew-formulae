class AlephTui < Formula
  desc "A text user interface for Aleph"
  homepage "https://github.com/stchris/aleph-tui"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stchris/aleph-tui/releases/download/v0.5.0/aleph-tui-aarch64-apple-darwin.tar.xz"
      sha256 "18bc2382862a47fe2b995da26e35cb8d1120acf3101c28e96528ee8ca5adf894"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stchris/aleph-tui/releases/download/v0.5.0/aleph-tui-x86_64-apple-darwin.tar.xz"
      sha256 "1cdf543dc2f2f07934061baaa668b3a4277234657d5080be91c525d38c22c16f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stchris/aleph-tui/releases/download/v0.5.0/aleph-tui-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7340bcf0c4c2eaed3abcfe2a7d3f721b53bff3afdc5a35dd609cfbaf3d21864e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stchris/aleph-tui/releases/download/v0.5.0/aleph-tui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4e5661ba043a6587e8e7933150df3ad2c8918477c729d94892ae193efbf3bd6e"
    end
  end
  license "GPL-3.0-or-later"

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
    bin.install "aleph-tui" if OS.mac? && Hardware::CPU.arm?
    bin.install "aleph-tui" if OS.mac? && Hardware::CPU.intel?
    bin.install "aleph-tui" if OS.linux? && Hardware::CPU.arm?
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
