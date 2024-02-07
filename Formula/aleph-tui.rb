class AlephTui < Formula
  desc "A text user interface for Aleph"
  version "0.2.0"
  on_macos do
    on_arm do
      url "https://github.com/stchris/aleph-tui/releases/download/v0.2.0/aleph-tui-aarch64-apple-darwin.tar.xz"
      sha256 "bc49dc681537f2ee7851bca46d3ee864d4b619207ee294429c69670e10b99456"
    end
    on_intel do
      url "https://github.com/stchris/aleph-tui/releases/download/v0.2.0/aleph-tui-x86_64-apple-darwin.tar.xz"
      sha256 "eeabdb88893e21000e2c21fbdc81d5d3d8f0b2e2da4839a6af99ab5c3f1aa675"
    end
  end
  on_linux do
    on_intel do
      url "https://github.com/stchris/aleph-tui/releases/download/v0.2.0/aleph-tui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b4ebc2061bc0d66df7d6584b6c95c147ff5b93d3476e2f4f124c6dba10c70c4a"
    end
  end
  license "GPL-3.0-or-later"

  def install
    bin.install "aleph-tui"

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install *leftover_contents unless leftover_contents.empty?
  end
end
