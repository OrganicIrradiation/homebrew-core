class LibrealsenseAT1121 < Formula
  desc "Intel RealSense F200, SR300, R200, LR200 and ZR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense/tree/v1.12.1"
  url "https://github.com/IntelRealSense/librealsense/archive/v1.12.1.tar.gz"
  sha256 "62fb4afac289ad7e25c81b6be584ee275f3d4d3742468dc7d80222ee2e4671bd"

  option "with-examples", "Install examples"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "glfw" if build.with? "examples"
  depends_on "libusb"

  def install
    args = std_cmake_args

    args << "-DBUILD_EXAMPLES=true" if build.with? "examples"

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <librealsense/rs.h>
      #include<stdio.h>
      int main()
      {
        printf(RS2_API_VERSION_STR);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-o", "test"
    assert_equal shell_output("./test").strip, version.to_s
  end
end
