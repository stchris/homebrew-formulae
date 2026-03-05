class Sumdir < Formula
  desc "summarize a directory by file type frequency"
  homepage "https://github.com/stchris/sumdir"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stchris/sumdir/releases/download/v0.3.0/sumdir-aarch64-apple-darwin.tar.xz"
      sha256 "123974a3a6ee23a6d8d505c6354a42936fe6f5fd34d765204e0abfa4b4cdbcfe"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stchris/sumdir/releases/download/v0.3.0/sumdir-x86_64-apple-darwin.tar.xz"
      sha256 "0e495df7b6e5a451a410464d149d2277e51f6d7503dc3f2adc4409c32b83e89f"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/stchris/sumdir/releases/download/v0.3.0/sumdir-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "eac5dbdcb55797da5df1c4a8c1882677a09bb476f061ba352a0f303b4f42a36b"
  end

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
