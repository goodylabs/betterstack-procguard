class Procguard < Formula
  desc "Bash process watchdog for Betterstack alerts"
  homepage "https://github.com/goodylabs/betterstack-procguard"
  url "https://github.com/goodylabs/betterstack-procguard/archive/refs/tags/v1.2.tar.gz"
  sha256 "c7a922708b9738f0c06a9acaae753078efa1f2cc0f5679a4647837a700b84859"
  license "MIT"

  def install
    bin.install "bin/procguard-watchdog.sh" => "procguard"
  end

  test do
    system "#{bin}/procguard", "--help"
  end
end
