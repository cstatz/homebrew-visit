require 'formula'

class Pyqt52 < Formula
  desc "Python bindings for v5.2.1 of Qt"
  homepage "http://www.riverbankcomputing.co.uk/software/pyqt/download5"
  url "https://downloads.sf.net/project/pyqt/PyQt5/PyQt-5.2.1/PyQt-gpl-5.2.1.tar.gz"
  sha256 "a07b6ef0bf80513032fdbbb28f283e0f842b8581554c2849e2837e669f301922"

  option 'enable-debug', "Build with debug symbols"
  option 'with-docs', "Install HTML documentation and python examples"

  depends_on :python => :recommended
  depends_on :python3 => :optional

  if build.without?("python3") && build.without?("python")
    odie "pyqt5: --with-python3 must be specified when using --without-python"
  end

  depends_on 'qt52'

  if build.with? 'python3'
    depends_on 'sip' => 'with-python3'
  else
    depends_on 'sip'
  end

  def install
    Language::Python.each_python(build) do |python, version|
      args = [ "--confirm-license",
               "--bindir=#{bin}",
               "--destdir=#{lib}/python#{version}/site-packages",
               # To avoid conflicts with PyQt (for Qt4):
               "--sipdir=#{share}/sip/Qt5/",
               # sip.h could not be found automatically
               "--sip-incdir=#{Formula["sip"].opt_include}",
               # Make sure the qt5 version of qmake is found.
               # If qt4 is linked it will pickup that version otherwise.
               "--qmake=#{Formula["qt52"].bin}/qmake",
               # Force deployment target to avoid libc++ issues
               "QMAKE_MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}",
               "--verbose"]
      args << '--debug' if build.include? 'enable-debug'

      system python, "configure.py", *args
      system "make"
      system "make", "install"
      system "make", "clean"
    end
    doc.install 'doc/html', 'examples' if build.with? "docs"
  end

  test do
    system "pyuic5", "--version"
    system "pylupdate5", "-version"
    Language::Python.each_python(build) do |python, version|
      system python, "-c", "import PyQt5"
    end
  end
end
