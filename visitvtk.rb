class Visitvtk < Formula
  desc "Toolkit for 3D computer graphics, image processing, and visualization"
  homepage "https://www.vtk.org/"
  revision 10
  head "https://github.com/Kitware/VTK.git"

  stable do
    url "https://www.vtk.org/files/release/8.2/VTK-8.2.0.tar.gz"
    sha256 "34c3dc775261be5e45a8049155f7228b6bd668106c72a3c435d95730d17d57bb"

    # Fix compile issues on Mojave and later
    patch do
      url "https://gitlab.kitware.com/vtk/vtk/commit/ca3b5a50d945b6e65f0e764b3138cad17bd7eb8d.diff"
      sha256 "b9f7a3ebf3c29f3cad4327eb15844ac0ee849755b148b60fef006314de8e822e"
    end

    # Python 3.8 compatibility
    patch do
      url "https://gitlab.kitware.com/vtk/vtk/commit/257b9d7b18d5f3db3fe099dc18f230e23f7dfbab.diff"
      sha256 "572c06a4ba279a133bfdcf0190fec2eff5f330fa85ad6a2a0b0f6dfdea01ca69"
    end

  end

  keg_only "Conflicts with homebrew VTK."

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "hdf5"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "netcdf"
  depends_on "pyqt"
  depends_on "python@3.8" => :build
  depends_on "qt"
  depends_on "ninja" => :build

  # -DVTK_Group_Imaging:BOOL=false
  # -DVTK_Group_MPI:BOOL=false
  # -DVTK_Group_Rendering:BOOL=false
  # -DVTK_Group_StandAlone:BOOL=false
  # -DVTK_Group_Tk:BOOL=false
  # -DVTK_Group_Views:BOOL=false
  # -DVTK_Group_Web:BOOL=false

  def install
    pyver = Language::Python.major_minor_version "python3"
    args = std_cmake_args + %W[
      -DBUILD_SHARED_LIBS=ON
      -DBUILD_TESTING=OFF
      -DCMAKE_INSTALL_NAME_DIR:STRING=#{lib}
      -DCMAKE_INSTALL_RPATH:STRING=#{lib}
      -DVTK_LEGACY_REMOVE:BOOL=true
      -DModule_vtkCommonCore:BOOL=true
      -DModule_vtkPython:BOOL=true
      -DModule_vtkWrappingPythonCore:BOOL=true
      -DModule_vtksys:BOOL=true
      -DModule_vtkCommonMisc:BOOL=true
      -DModule_vtkFiltersFlowPaths:BOOL=true
      -DModule_vtkFiltersHybrid:BOOL=true
      -DModule_vtkFiltersModeling:BOOL=true
      -DModule_vtkGeovisCore:BOOL=true
      -DModule_vtkIOEnSight:BOOL=true
      -DModule_vtkIOGeometry:BOOL=true
      -DModule_vtkIOLegacy:BOOL=true
      -DModule_vtkIOPLY:BOOL=true
      -DModule_vtkIOXML:BOOL=true
      -DModule_vtkInteractionStyle:BOOL=true
      -DModule_vtkRenderingAnnotation:BOOL=true
      -DModule_vtkRenderingFreeType:BOOL=true
      -DModule_vtkRenderingOpenGL2:BOOL=true
      -DModule_vtklibxml2:BOOL=true
      -DModule_vtkPythonInterpreter:BOOL=true
      -DModule_vtkGUISupportQtOpenGL:BOOL=true
      -DVTK_ALL_NEW_OBJECT_FACTORY:BOOL=true
      -DVTK_REQUIRED_OBJCXX_FLAGS=''
      -DVTK_USE_COCOA=ON
      -DVTK_USE_SYSTEM_EXPAT=ON
      -DVTK_USE_SYSTEM_HDF5=ON
      -DVTK_USE_SYSTEM_JPEG=ON
      -DVTK_USE_SYSTEM_LIBXML2=ON
      -DVTK_USE_SYSTEM_NETCDF=ON
      -DVTK_USE_SYSTEM_PNG=ON
      -DVTK_USE_SYSTEM_TIFF=ON
      -DVTK_USE_SYSTEM_ZLIB=ON
      -DVTK_WRAP_PYTHON=ON
      -DVTK_PYTHON_VERSION=3
      -DPYTHON_EXECUTABLE=#{Formula["python@3.8"].opt_bin}/python3/
      -DVTK_INSTALL_PYTHON_MODULE_DIR=#{lib}/python#{pyver}/site-packages
      -DVTK_QT_VERSION:STRING=5
      -DVTK_Group_Qt=ON
      -DVTK_WRAP_PYTHON_SIP=ON
      -DSIP_PYQT_DIR='#{Formula["pyqt5"].opt_share}/sip'
    ]

    mkdir "build" do
      system "cmake", "-G", "Ninja", "..", *args
      system "ninja"
      system "ninja", "install"
    end

    # Avoid hard-coding HDF5's Cellar path
    inreplace Dir["#{lib}/cmake/**/vtkhdf5.cmake"].first,
              Formula["hdf5"].prefix.realpath,
              Formula["hdf5"].opt_prefix
  end

  test do
    vtk_include = Dir[opt_include/"vtk-*"].first
    major, minor = vtk_include.match(/.*-(.*)$/)[1].split(".")

    (testpath/"version.cpp").write <<~EOS
      #include <vtkVersion.h>
      #include <assert.h>
      int main(int, char *[]) {
        assert (vtkVersion::GetVTKMajorVersion()==#{major});
        assert (vtkVersion::GetVTKMinorVersion()==#{minor});
        return EXIT_SUCCESS;
      }
    EOS

    system ENV.cxx, "-std=c++11", "version.cpp", "-I#{vtk_include}"
    system "./a.out"
    system "#{bin}/vtkpython", "-c", "exit()"
  end
end
