# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Blaze < Formula
  desc "A high performance C++ math library."
  homepage "https://bitbucket.org/blaze-lib/blaze/"
  url "https://bitbucket.org/blaze-lib/blaze/get/master.tar.gz"

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "cmake", "--build", ".", "--", "install"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test blaze`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
