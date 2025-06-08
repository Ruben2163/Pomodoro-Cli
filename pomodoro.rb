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
