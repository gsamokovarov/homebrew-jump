require "language/go"

class Jump < Formula
  desc "A fuzzy quick-directory jumper."
  homepage "https://github.com/gsamokovarov/jump"
  url "https://codeload.github.com/gsamokovarov/jump/tar.gz/v0.1.0"
  sha256 "13b93f7fb9b0163b469c1d1fda6b2ed4918b822e0421be87f81ae865c710d643"
  head "https://github.com/gsamokovarov/jump.git"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/gsamokovarov"
    ln_s buildpath, buildpath/"src/github.com/gsamokovarov/jump"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go build -o jump"
    bin.install "jump"
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
