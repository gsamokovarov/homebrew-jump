require "language/go"

class Jump < Formula
  desc "A quick and fuzzy directory jumper."
  homepage "https://github.com/gsamokovarov/jump"
  url "https://codeload.github.com/gsamokovarov/jump/tar.gz/v0.3.0"
  sha256 "c277be2eb7455b60ce208ff3f6617c5822a861c910d0de186e3eaaca560fffb8"
  head "https://github.com/gsamokovarov/jump.git"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/gsamokovarov"
    ln_s buildpath, buildpath/"src/github.com/gsamokovarov/jump"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go build -o jump"
    bin.install "jump"
    man.install "man/jump.1"
  end

  def caveats; <<-EOS.undent
    To install shell integration, follow the instructions at:
      #{prefix}/bin/jump shell
    EOS
  end

  test do
    mkdir_p testpath/"test_dir"
    ENV["JUMP_HOME"] = testpath.to_s
    system "jump chdir #{testpath/"test_dir"}"

    assert_equal testpath/"test_dir", shell_output("jump cd tdir").chomp
  end
end
