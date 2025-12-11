class Procguard < Formula
  desc "Bash process watchdog for Betterstack alerts"
  homepage "https://github.com/goodylabs/betterstack-procguard"
  url "https://github.com/goodylabs/betterstack-procguard/archive/refs/tags/v1.2.tar.gz"
  sha256 "ab347031f731b34a1841d661d4e1b0614088a4b1a9eefcd02bd5cb75bd96cfc8"
  license "MIT"

  def install
    bin.install "bin/procguard-watchdog.sh" => "procguard"
  end

  test do
    system "#{bin}/procguard", "--help"
  end
end
