class Pstexplorer < Formula
  desc "A CLI tool to explore and extract data from Outlook PST files"
  homepage "https://github.com/stchris/pstexplorer"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stchris/pstexplorer/releases/download/v0.4.0/pstexplorer-aarch64-apple-darwin.tar.xz"
      sha256 "527276fbd3dbeacc50e0194c42002c5ac3b4f967e0a715238b513bf8a4fc75e6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stchris/pstexplorer/releases/download/v0.4.0/pstexplorer-x86_64-apple-darwin.tar.xz"
      sha256 "03d9ffd356c4bcf564256b357d081d183cc82c94995c25885a327f2493670f97"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stchris/pstexplorer/releases/download/v0.4.0/pstexplorer-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6b08eb03bd2baacf9f2a6e3ca9ecc31f6ed8355b2e67b32ca6d9dc431b56232f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stchris/pstexplorer/releases/download/v0.4.0/pstexplorer-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d8258dd416f04431296eca5767ed3ade658987c89cf161fa1405ab7a099f30bd"
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
