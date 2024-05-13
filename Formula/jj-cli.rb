class JjCli < Formula
  desc "gnostr: a git+nostr workflow utility."
  homepage "https://github.com/gnostr-org/gnostr"
  version "0.0.32"
  if OS.mac?
    url "https://github.com/gnostr-org/gnostr/releases/download/v0.0.32/jj-cli-x86_64-apple-darwin.tar.gz"
    sha256 "ad1d68c92f63324121a13272d16619a4ab3a50fb4975cd7f4fc46b65bfe1323d"
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/gnostr-org/gnostr/releases/download/v0.0.32/jj-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a6cf3b1d09f347cf3f7a155269958e94d731acdf0f62dd6a31bfe91f11a2705a"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {"aarch64-apple-darwin": {}, "x86_64-apple-darwin": {}, "x86_64-unknown-linux-gnu": {}}

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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "fake-diff-editor", "fake-editor", "gnostr", "gnostr-jj", "gnostr-jj-gui", "jj"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "fake-diff-editor", "fake-editor", "gnostr", "gnostr-jj", "gnostr-jj-gui", "jj"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "fake-diff-editor", "fake-editor", "gnostr", "gnostr-jj", "gnostr-jj-gui", "jj"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
