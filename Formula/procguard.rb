class Procguard < Formula
  desc "Bash process watchdog for Betterstack alerts"
  homepage "https://github.com/goodylabs/betterstack-procguard"
  url "https://github.com/goodylabs/betterstack-procguard/archive/refs/tags/v1.4.tar.gz"
  sha256 "115531dafbd754a7f4b43140426583f3b3f1397ac7a121be953049fa48cfd981"
  license "MIT"

  def install
    bin.install "bin/procguard-watchdog.sh" => "procguard"
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/procguard --help", 0)
  end
end
