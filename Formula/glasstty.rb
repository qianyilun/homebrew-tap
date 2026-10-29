class Glasstty < Formula
  desc "Liquid Glass look for the Ghostty terminal on macOS 26"
  homepage "https://github.com/qianyilun/glasstty"
  url "https://github.com/qianyilun/glasstty/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "cd64b8d46ab3e1ef665aeb0a5cc8ce34fc3f79208720600c937b988dc8b07371"
  license "MIT"
  head "https://github.com/qianyilun/glasstty.git", branch: "main"

  depends_on :macos

  def install
    pkgshare.install "glasstty.ghostty", "themes", "shaders", "tmux"
    # The opt path stays the same across upgrades, so the include line in the user's
    # Ghostty config keeps working after `brew upgrade`.
    inreplace "bin/glasstty", 'GLASSTTY_ROOT_DEFAULT=""', "GLASSTTY_ROOT_DEFAULT=\"#{opt_pkgshare}\""
    bin.install "bin/glasstty"
  end

  def caveats
    <<~EOS
      Turn glasstty on in Ghostty:
        glasstty enable            # add --tmux for the glass tmux tab bar
      then reload Ghostty with Cmd+Shift+, (Reload Configuration).

      Run `glasstty disable` before uninstalling.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/glasstty version")
    ENV["HOME"] = testpath
    system bin/"glasstty", "enable"
    config = testpath/"Library/Application Support/com.mitchellh.ghostty/config.ghostty"
    assert_match "config-file = ?#{opt_pkgshare}/glasstty.ghostty", config.read
  end
end
