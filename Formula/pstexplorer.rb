class Pstexplorer < Formula
  desc "A CLI tool to explore and extract data from Outlook PST files"
  homepage "https://github.com/stchris/pstexplorer"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stchris/pstexplorer/releases/download/v0.2.0/pstexplorer-aarch64-apple-darwin.tar.xz"
      sha256 "26b33e1a70eee5f7bed1674622ee03c62c51320cb10bc6310fff8949c4acc0cb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stchris/pstexplorer/releases/download/v0.2.0/pstexplorer-x86_64-apple-darwin.tar.xz"
      sha256 "8c810ce9d9bfdc7847d782c201f8b2e28b4a87cd3e9b7b4fb2fb9a0a9c907841"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stchris/pstexplorer/releases/download/v0.2.0/pstexplorer-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a916c23709b81393cafd9ab7492233f6455b61f1741733059aee644b3cedb453"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stchris/pstexplorer/releases/download/v0.2.0/pstexplorer-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fbd9d7ba02ccf4a908c2d3b3860602bcc7f52a83ea09dc676cee27769299751d"
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
