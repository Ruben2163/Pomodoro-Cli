class Pomodoro < Formula
  desc "Fast, themeable Pomodoro timer for your terminal (OCaml)"
  homepage "https://github.com/ruben2163/pomodoro-cli"
  url "https://github.com/ruben2163/pomodoro-cli/releases/download/v1.0.0/pomodoro"
  sha256 "f91acb9347f8f74543ce88fb7e0052d3e6f2967fffa3a1f9db3fa5163a29d6a4"
  version "1.0.0"

  def install
    bin.install "pomodoro"
  end

  test do
    system "#{bin}/pomodoro", "--help"
  end
end
