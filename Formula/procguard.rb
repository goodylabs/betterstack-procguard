class Procguard < Formula
  desc "Bash process watchdog for Betterstack alerts"
  homepage "https://github.com/goodylabs/betterstack-procguard"
  url "https://github.com/goodylabs/betterstack-procguard/archive/refs/tags/v1.4.tar.gz"
  sha256 "e057b3b0a33722da2bdb2fb3c9d4fead4da4e31e1bd1137c4768dd120eb9fa15"
  license "MIT"

  def install
    bin.install "bin/procguard-watchdog.sh" => "procguard"
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/procguard --help", 0)
  end
end
