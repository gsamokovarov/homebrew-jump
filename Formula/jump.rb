require "language/go"

class Jump < Formula
  desc "A quick and fuzzy directory jumper."
  homepage "https://github.com/gsamokovarov/jump"
  url "https://codeload.github.com/gsamokovarov/jump/tar.gz/v0.5.0"
  sha256 "1f7ac07e62b4ccb33f089e2fdf1269d6c491e7b640f089d321fcce04308edbc5"
  head "https://github.com/gsamokovarov/jump.git"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/gsamokovarov").mkpath
    ln_s buildpath, buildpath/"src/github.com/gsamokovarov/jump"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", "#{bin}/jump"
    man1.install "man/jump.1"
  end

  def caveats; <<-EOS.undent
    To install the shell integration, follow the instructions at:
      #{bin}/jump shell
    EOS
  end

  test do
    (testpath/"test_dir").mkpath
    ENV["JUMP_HOME"] = testpath.to_s
    system "#{bin}/jump", "chdir", "#{testpath}/test_dir"

    assert_equal testpath/"test_dir", shell_output("#{bin}/jump cd tdir").chomp
  end
end
