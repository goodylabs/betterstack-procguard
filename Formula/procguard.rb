class Procguard < Formula
  desc "Bash process watchdog for Betterstack alerts"
  homepage "https://github.com/goodylabs/betterstack-procguard"
  url "https://github.com/goodylabs/betterstack-procguard/archive/refs/tags/v1.2.tar.gz"
  sha256 "b9d916693b0a95a844493e2d622b0f42f886d5539f1a683839e65f4db8d5e605"
  license "MIT"

  def install
    bin.install "bin/procguard-watchdog.sh" => "procguard"
  end

  test do
    system "#{bin}/procguard", "--help"
  end
end
