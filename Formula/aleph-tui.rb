class AlephTui < Formula
  desc "A text user interface for Aleph"
  version "0.1.2"
  on_macos do
    on_arm do
      url "https://github.com/stchris/aleph-tui/releases/download/v0.1.2/aleph-tui-aarch64-apple-darwin.tar.xz"
      sha256 "6813821c116a90f094185d5720f5c5a44a53ea72713a75b4ced8b25e926765d6"
    end
    on_intel do
      url "https://github.com/stchris/aleph-tui/releases/download/v0.1.2/aleph-tui-x86_64-apple-darwin.tar.xz"
      sha256 "3aa85f4c7678a025516ffc6d74f5b7f65414fc2c05b4722ac18be9709f0fc29b"
    end
  end
  on_linux do
    on_intel do
      url "https://github.com/stchris/aleph-tui/releases/download/v0.1.2/aleph-tui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "11b83f75033044d5f3f39a770f53be78590204296ff518827fa38e8f998e84e0"
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
