class Procguard < Formula
  desc "Bash process watchdog for Betterstack alerts"
  homepage "https://github.com/goodylabs/betterstack-procguard"
  url "https://github.com/goodylabs/betterstack-procguard/archive/refs/tags/v1.2.tar.gz"
  sha256 "ca1201e79ac68a5371ae556f9eab72d06244ad00de65fe328bd7004af6a3b8db"
  license "MIT"

  def install
    bin.install "bin/procguard-watchdog.sh" => "procguard"
  end

  test do
    system "#{bin}/procguard", "--help"
  end
end
