class AlephTui < Formula
  desc "A text user interface for Aleph"
  version "0.1.3"
  on_macos do
    on_arm do
      url "https://github.com/stchris/aleph-tui/releases/download/v0.1.3/aleph-tui-aarch64-apple-darwin.tar.xz"
      sha256 "da154b204f3e4766f9b0b084413dc45353b2a9e4eb9d823ee0f98c41cb5b01b1"
    end
    on_intel do
      url "https://github.com/stchris/aleph-tui/releases/download/v0.1.3/aleph-tui-x86_64-apple-darwin.tar.xz"
      sha256 "a469124431367976ea962c5a1d6cfd6d348756df17d6d4a5143c59a9719f1107"
    end
  end
  on_linux do
    on_intel do
      url "https://github.com/stchris/aleph-tui/releases/download/v0.1.3/aleph-tui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5015ea0adeef5811d314c806bbd1838615888615c5d48242727ae41feb647f73"
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
