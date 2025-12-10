class Procguard < Formula
  desc "Bash process watchdog for Betterstack alerts"
  homepage "https://github.com/goodylabs/betterstack-procguard"
  url "https://github.com/goodylabs/betterstack-procguard/archive/refs/tags/v1.0.tar.gz"
  sha256 "2d642672087a531881ce8f95f162eced8f4844ab47e45542af0619de72b84694"
  license "MIT"

  def install
    bin.install "bin/procguard-watchdog.sh" => "procguard"
  end

  test do
    system "#{bin}/procguard", "--help"
  end
end
