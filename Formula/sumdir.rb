class Sumdir < Formula
  desc "summarize a directory by file type frequency"
  homepage "https://github.com/stchris/sumdir"
  version "0.4.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stchris/sumdir/releases/download/v0.4.1/sumdir-aarch64-apple-darwin.tar.xz"
      sha256 "04f94dc407c08f77ae188dd2fb3b20be4c17a1b3e07315b9e35702719bed677e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stchris/sumdir/releases/download/v0.4.1/sumdir-x86_64-apple-darwin.tar.xz"
      sha256 "a35568742409eaee2526834983e4cc55f9be18fd3f2406f861cc65e1ccac7659"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/stchris/sumdir/releases/download/v0.4.1/sumdir-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3c9d01c82d4255f4c20633b21cbfd5de7143fb023a9a9207f1548547d8028102"
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
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
    bin.install "sumdir" if OS.mac? && Hardware::CPU.arm?
    bin.install "sumdir" if OS.mac? && Hardware::CPU.intel?
    bin.install "sumdir" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
