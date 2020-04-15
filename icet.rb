class Icet < Formula
  desc "Image composition engine by tiles"
  homepage "https://icet.sandia.gov/"
  url "https://gitlab.kitware.com/icet/icet.git"
  version "2.3.0"
  sha256 ""
  head "https://gitlab.kitware.com/icet/icet.git"

  keg_only "Just for visit."

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "openmpi"

  def install

    args = std_cmake_args + %W[
      -DMPI_C_INCLUDE_PATH:PATH=/usr/local/include
      -DMPI_C_LIBRAROES:FILEPATH=./fakempi.a
      -DBUILD_TESTING:BOOL=OFF
    ]


    ENV.cxx11 if ENV.compiler == :clang
    ENV["PAR_COMPILER"] = "/usr/local/bin/mpicc"

    mkdir "build" do
      system "touch", "fakempi.a"
      system "cmake", "-G", "Ninja", "..", *args
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test icet`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
