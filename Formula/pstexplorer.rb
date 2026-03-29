class Pstexplorer < Formula
  desc "A CLI tool to explore and extract data from Outlook PST files"
  homepage "https://github.com/stchris/pstexplorer"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stchris/pstexplorer/releases/download/v0.5.0/pstexplorer-aarch64-apple-darwin.tar.xz"
      sha256 "3e29efd82292101e6fee24f6ea93445d0a5a0b46daa8f4911be2fbc8286c9ed0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stchris/pstexplorer/releases/download/v0.5.0/pstexplorer-x86_64-apple-darwin.tar.xz"
      sha256 "1193fa2cd574636488ed070aed7ad5c20c4313809db576a3113e55fbc3b2acab"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stchris/pstexplorer/releases/download/v0.5.0/pstexplorer-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8de1f40dc4b075aeefe7a1293c412ec70e7e5c27fa313eb3bf0cd5d4d58b4123"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stchris/pstexplorer/releases/download/v0.5.0/pstexplorer-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0c5e14e8c1cc31c9d497ceced27dc596895167522ad077f7dd0a9aa64c20a581"
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
