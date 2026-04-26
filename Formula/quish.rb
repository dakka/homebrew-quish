class Quish < Formula
  desc "Reliable interactive terminal client/server using QUIC"
  homepage "https://github.com/dakka/quish"
  # NOTE: dakka/quish is currently private. Until it goes public:
  #   - `brew install --HEAD quish` works over SSH via the head: line below
  #     (requires SSH access to the repo).
  #   - Tagged tarball install requires HOMEBREW_GITHUB_API_TOKEN with repo
  #     read access. When the repo goes public, remove the git@ override.
  url "https://github.com/dakka/quish/archive/refs/tags/v0.5.2-beta.1.tar.gz"
  sha256 "REPLACE_WITH_TARBALL_SHA256"
  license "Apache-2.0"
  head "git@github.com:dakka/quish.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "linux-pam"
  end

  def install
    args = std_cmake_args + [
      "-DBUILD_TESTS=OFF",
      "-DCMAKE_BUILD_TYPE=Release",
    ]
    # quish-flaker uses /dev/net/tun (Linux-only); a macOS utun port is pending.
    args << "-DBUILD_FLAKER=OFF" if OS.mac?
    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}/quish --version 2>&1")
    assert_match "quish", output
    output = shell_output("#{bin}/quish-server --version 2>&1")
    assert_match "quish-server", output
  end
end
