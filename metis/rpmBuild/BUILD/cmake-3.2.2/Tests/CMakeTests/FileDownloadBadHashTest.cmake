set(url "file:///home/gpp/dev-SOMAFOAM/metis/rpmBuild/BUILD/cmake-3.2.2/Tests/CMakeTests/FileDownloadInput.png")
set(dir "/home/gpp/dev-SOMAFOAM/metis/rpmBuild/BUILD/cmake-3.2.2/Tests/CMakeTests/downloads")

file(DOWNLOAD
  ${url}
  ${dir}/file3.png
  TIMEOUT 2
  STATUS status
  EXPECTED_HASH SHA1=5555555555555555555555555555555555555555
  )
