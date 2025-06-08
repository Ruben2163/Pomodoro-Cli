# Homebrew Formula for Pomodoro CLI
#
# To update:
# 1. Build and upload a new release binary to GitHub Releases.
# 2. Update the 'url' to the new release asset.
# 3. Update 'sha256' with: shasum -a 256 pomodoro
# 4. Commit and push to your tap repo.
# 5. Users can install with:
#      brew tap ruben2163/pomodoro
#      brew install pomodoro

class Pomodoro < Formula
  desc "Fast, themeable Pomodoro timer for your terminal (OCaml)"
  homepage "https://github.com/ruben2163/pomodoro-cli"
  url "https://github.com/ruben2163/pomodoro-cli/releases/download/v1.0.0/pomodoro"
  sha256 "PUT_SHA256_HERE"
  version "1.0.0"

  def install
    bin.install "pomodoro"
  end

  test do
    system "#{bin}/pomodoro", "--help"
  end
end
