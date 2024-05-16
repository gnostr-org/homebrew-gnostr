class GnostrLookup < Formula
  desc "git+nostr workflow utility"
  homepage "https://github.com/gnostr-org/gnostr"
  version "0.0.37"
  if OS.mac?
    url "https://github.com/gnostr-org/gnostr/releases/download/v0.0.37/gnostr-lookup-x86_64-apple-darwin.tar.gz"
    sha256 "84345c023678fce3fb010234d5c91145812f52d9c54e193968ebbd4d8d5cb9d1"
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/gnostr-org/gnostr/releases/download/v0.0.37/gnostr-lookup-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "9c3cf9944b1d85d55634b870f6316d82930a685dd1dec1c1ea3a3a0d66fb1239"
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
      bin.install "gnostr-lookup"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "gnostr-lookup"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "gnostr-lookup"
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
