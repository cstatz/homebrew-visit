# Documentation: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Formula-Cookbook.md
#                /usr/local/Library/Contributions/example-formula.rb
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Icet < Formula
  desc ""
  homepage ""
  url "http://icet.sandia.gov/_assets/files/IceT-1-0-0.tar.gz"
  version "1-0-0"
  sha256 "bcd3277fc5c48401d8fbe541c274ca8e70215da2d984b8a7819d10a68a60463a"

  depends_on "cmake" => :build
  patch :DATA

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel

    args = [ ".",
             "-DCMAKE_INSTALL_PREFIX=#{prefix}"
           ]

    system "cmake", *args
    system "make", "install" # if this fails, try separate make/make install steps
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test IceT`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "true"
  end
end

__END__
--- a/src/CMakeLists.txt	2009-06-03 17:46:18.000000000 +0200
+++ b/src/CMakeLists.txt	2015-07-18 07:41:21.000000000 +0200
@@ -18,18 +18,18 @@
       "${CMAKE_CURRENT_SOURCE_DIR}/communication"
       "${CMAKE_CURRENT_SOURCE_DIR}/strategies")
   SET(filesToInstall)
-  FOREACH(p IN ${resPath})
+  FOREACH(p ${resPath})
       SET(tmpFilesToInstall)
       SET(exts "${p}/*.h;${p}/*.hxx;${p}/*.txx")
-      FOREACH(ext IN ${exts})
+      FOREACH(ext ${exts})
           FILE(GLOB tmpFilesToInstall
           RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}"
           "${ext}")
           IF(tmpFilesToInstall)
               SET(filesToInstall "${filesToInstall};${tmpFilesToInstall}")
           ENDIF(tmpFilesToInstall)
-      ENDFOREACH(ext IN ${exts})
-  ENDFOREACH(p IN ${resPath})
+      ENDFOREACH(ext ${exts})
+  ENDFOREACH(p ${resPath})
   INSTALL(
       FILES ${filesToInstall}
       DESTINATION "${ICET_INSTALL_INCLUDE_DIR}/ice-t"
