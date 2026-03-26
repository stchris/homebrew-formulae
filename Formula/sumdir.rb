class Sumdir < Formula
  desc "summarize a directory by file type frequency"
  homepage "https://github.com/stchris/sumdir"
  version "0.5.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stchris/sumdir/releases/download/v0.5.1/sumdir-aarch64-apple-darwin.tar.xz"
      sha256 "5d6b270fe2456895741c88d267926d203151e39041d51041d7b84715d96b929a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stchris/sumdir/releases/download/v0.5.1/sumdir-x86_64-apple-darwin.tar.xz"
      sha256 "2be2d088cf6dcbd57887107e95d8a069513c5ed2839a2c12ce2a1d8fc3038a16"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/stchris/sumdir/releases/download/v0.5.1/sumdir-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "703104a1f56c811ef8b3eb2080157b8a43350bf0f3127535775e2a4248df5777"
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
