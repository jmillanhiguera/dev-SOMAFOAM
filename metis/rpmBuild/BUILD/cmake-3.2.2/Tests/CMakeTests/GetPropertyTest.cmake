include("/home/gpp/dev-SOMAFOAM/metis/rpmBuild/BUILD/cmake-3.2.2/Tests/CMakeTests/CheckCMakeTest.cmake")

get_property(FOO_BRIEF GLOBAL PROPERTY FOO BRIEF_DOCS)
get_property(FOO_FULL GLOBAL PROPERTY FOO FULL_DOCS)

if (NOT FOO_BRIEF STREQUAL "NOTFOUND")
  message(SEND_ERROR "property FOO has BRIEF_DOCS set to '${FOO_BRIEF}'")
endif ()

if (NOT FOO_FULL STREQUAL "NOTFOUND")
  message(SEND_ERROR "property FOO has FULL_DOCS set to '${FOO_FULL}'")
endif ()

set(test_var alpha)
get_property(result VARIABLE PROPERTY test_var)
if(NOT result STREQUAL "alpha")
  message(SEND_ERROR "bad value of VARIABLE PROPERTY test_var: got '${result}' instead of 'alpha'")
endif()

include("/home/gpp/dev-SOMAFOAM/metis/rpmBuild/BUILD/cmake-3.2.2/Tests/CMakeTests/../RegexEscapeString.cmake")
REGEX_ESCAPE_STRING(CTEST_ESCAPED_CMAKE_CURRENT_SOURCE_DIR "/home/gpp/dev-SOMAFOAM/metis/rpmBuild/BUILD/cmake-3.2.2/Tests/CMakeTests")

set(Missing-Argument-RESULT 1)
set(Missing-Argument-STDERR ".*CMake Error at (${CTEST_ESCAPED_CMAKE_CURRENT_SOURCE_DIR}/)?GetProperty-Missing-Argument.cmake:1 \\(get_property\\):.*get_property called with incorrect number of arguments.*")

check_cmake_test(GetProperty
  Missing-Argument
)

set(Bad-Scope-RESULT 1)
set(Bad-Scope-STDERR ".*CMake Error at (${CTEST_ESCAPED_CMAKE_CURRENT_SOURCE_DIR}/)?GetProperty-Bad-Scope.cmake:1 \\(get_property\\):.*get_property given invalid scope FOO\\..*")

check_cmake_test(GetProperty
  Bad-Scope
)

set(Bad-Argument-RESULT 1)
set(Bad-Argument-STDERR ".*CMake Error at (${CTEST_ESCAPED_CMAKE_CURRENT_SOURCE_DIR}/)?GetProperty-Bad-Argument.cmake:1 \\(get_property\\):.*get_property given invalid argument \"FOO\"\\..*")

check_cmake_test(GetProperty
  Bad-Argument
)

set(No-Property-RESULT 1)
set(No-Property-STDERR ".*CMake Error at (${CTEST_ESCAPED_CMAKE_CURRENT_SOURCE_DIR}/)?GetProperty-No-Property.cmake:1 \\(get_property\\):.*get_property not given a PROPERTY <name> argument\\..*")

check_cmake_test(GetProperty
  No-Property
)

set(Global-Name-RESULT 1)
set(Global-Name-STDERR ".*CMake Error at (${CTEST_ESCAPED_CMAKE_CURRENT_SOURCE_DIR}/)?GetProperty-Global-Name.cmake:1 \\(get_property\\):.*get_property given name for GLOBAL scope\\..*")

check_cmake_test(GetProperty
  Global-Name
)

set(Bad-Directory-RESULT 1)
set(Bad-Directory-STDERR ".*CMake Error at (${CTEST_ESCAPED_CMAKE_CURRENT_SOURCE_DIR}/)?GetProperty-Bad-Directory.cmake:1 \\(get_property\\):.*get_property DIRECTORY scope provided but requested directory was not.*found\\..*")

check_cmake_test(GetProperty
  Bad-Directory
)

set(No-Target-RESULT 1)
set(No-Target-STDERR ".*CMake Error at (${CTEST_ESCAPED_CMAKE_CURRENT_SOURCE_DIR}/)?GetProperty-No-Target.cmake:1 \\(get_property\\):.*get_property not given name for TARGET scope\\..*")

check_cmake_test(GetProperty
  No-Target
)

set(Bad-Target-RESULT 1)
set(Bad-Target-STDERR ".*CMake Error at (${CTEST_ESCAPED_CMAKE_CURRENT_SOURCE_DIR}/)?GetProperty-Bad-Target.cmake:1 \\(get_property\\):.*get_property could not find TARGET FOO\\..*")

check_cmake_test(GetProperty
  Bad-Target
)

set(No-Source-RESULT 1)
set(No-Source-STDERR ".*CMake Error at (${CTEST_ESCAPED_CMAKE_CURRENT_SOURCE_DIR}/)?GetProperty-No-Source.cmake:1 \\(get_property\\):.*get_property not given name for SOURCE scope\\..*")

check_cmake_test(GetProperty
  No-Source
)

set(No-Test-RESULT 1)
set(No-Test-STDERR ".*CMake Error at (${CTEST_ESCAPED_CMAKE_CURRENT_SOURCE_DIR}/)?GetProperty-No-Test.cmake:1 \\(get_property\\):.*get_property not given name for TEST scope\\..*")

check_cmake_test(GetProperty
  No-Test
)

set(Bad-Test-RESULT 1)
set(Bad-Test-STDERR ".*CMake Error at (${CTEST_ESCAPED_CMAKE_CURRENT_SOURCE_DIR}/)?GetProperty-Bad-Test.cmake:1 \\(get_property\\):.*get_property given TEST name that does not exist: FOO.*")

check_cmake_test(GetProperty
  Bad-Test
)

set(Variable-Name-RESULT 1)
set(Variable-Name-STDERR ".*CMake Error at (${CTEST_ESCAPED_CMAKE_CURRENT_SOURCE_DIR}/)?GetProperty-Variable-Name.cmake:1 \\(get_property\\):.*get_property given name for VARIABLE scope\\..*")

check_cmake_test(GetProperty
  Variable-Name
)

set(No-Cache-RESULT 1)
set(No-Cache-STDERR ".*CMake Error at (${CTEST_ESCAPED_CMAKE_CURRENT_SOURCE_DIR}/)?GetProperty-No-Cache.cmake:1 \\(get_property\\):.*get_property not given name for CACHE scope\\..*")

check_cmake_test(GetProperty
  No-Cache
)
