class GnostrBins < Formula
  desc "git+nostr workflow utility"
  homepage "https://github.com/gnostr-org/gnostr"
  version "0.0.28"
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/gnostr-org/gnostr/releases/download/v0.0.28/gnostr-bins-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "da0337cbc6d020ff9916d23805e9a4560fc217d8f93ca6509eea8c900a6863ae"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {"x86_64-unknown-linux-gnu": {}}

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
    if OS.linux? && Hardware::CPU.intel?
      bin.install "gnostr-add", "gnostr-bech32-to-any", "gnostr-blame", "gnostr-blockheight", "gnostr-cat-file", "gnostr-cli-example", "gnostr-clone", "gnostr-dashboard", "gnostr-decrypt-private_key", "gnostr-diff", "gnostr-dump-relay", "gnostr-encrypt-private_key", "gnostr-fetch", "gnostr-fetch-by-id", "gnostr-fetch-by-kind-and-author", "gnostr-fetch-metadata", "gnostr-fetch-nip11", "gnostr-fetch-pubkey-relays", "gnostr-fetch-watch-list", "gnostr-fetch-watch-list-iterator", "gnostr-form-event-addr", "gnostr-generate-keypair", "gnostr-get-example", "gnostr-get-relays", "gnostr-init", "gnostr-legit", "gnostr-log", "gnostr-ls-remote", "gnostr-objects", "gnostr-pi", "gnostr-post-event", "gnostr-privkey-to-bech32", "gnostr-pubkey-to-bech32", "gnostr-pull", "gnostr-reflog", "gnostr-rev-list", "gnostr-rev-parse", "gnostr-serve", "gnostr-sha256", "gnostr-state", "gnostr-status", "gnostr-tag", "gnostr-verify-keypair", "gnostr-weeble", "gnostr-welcome", "gnostr-wobble", "nostr"
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
