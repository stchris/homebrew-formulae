class AlephTui < Formula
  desc "A text user interface for Aleph"
  version "0.3.0"
  on_macos do
    on_arm do
      url "https://github.com/stchris/aleph-tui/releases/download/v0.3.0/aleph-tui-aarch64-apple-darwin.tar.xz"
      sha256 "82c95cec36ed280cdb07d660c59d27c4038c8228c0b81f9e536d83232b48fb04"
    end
    on_intel do
      url "https://github.com/stchris/aleph-tui/releases/download/v0.3.0/aleph-tui-x86_64-apple-darwin.tar.xz"
      sha256 "a89d7ea0af3f654081579c34b6d9c50230e41e36a601f206d22f35232786ecb9"
    end
  end
  on_linux do
    on_intel do
      url "https://github.com/stchris/aleph-tui/releases/download/v0.3.0/aleph-tui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2338804473a690a97fa758b45e0f6388d29a506b8ee577c9a71d5f2bfade96b6"
    end
  end
  license "GPL-3.0-or-later"

  def install
    on_macos do
      on_arm do
        bin.install "aleph-tui"
      end
    end
    on_macos do
      on_intel do
        bin.install "aleph-tui"
      end
    end
    on_linux do
      on_intel do
        bin.install "aleph-tui"
      end
    end

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install *leftover_contents unless leftover_contents.empty?
  end
end
