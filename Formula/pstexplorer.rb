class Pstexplorer < Formula
  desc "A CLI tool to explore and extract data from Outlook PST files"
  homepage "https://github.com/stchris/pstexplorer"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stchris/pstexplorer/releases/download/v0.1.0/pstexplorer-aarch64-apple-darwin.tar.xz"
      sha256 "7be090092960198417ad0c97f1f5df9739da0aa085a7b68558abd27f29b35013"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stchris/pstexplorer/releases/download/v0.1.0/pstexplorer-x86_64-apple-darwin.tar.xz"
      sha256 "4342b814c53af1416e702672086eb226d63f1b8d44b8ff049a2b621275daa467"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stchris/pstexplorer/releases/download/v0.1.0/pstexplorer-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c7a4f93bbbca9db07d27906f74e4f2867a2f368cbb4c98947c394b83c49c0fe4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stchris/pstexplorer/releases/download/v0.1.0/pstexplorer-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "74e24217125a7504b861f726ca12ea2e49d0fa496cde00ffb0934f32aa0ff870"
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
