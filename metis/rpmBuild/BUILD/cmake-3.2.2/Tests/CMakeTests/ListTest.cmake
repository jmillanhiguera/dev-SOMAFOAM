include("/home/gpp/dev-SOMAFOAM/metis/rpmBuild/BUILD/cmake-3.2.2/Tests/CMakeTests/CheckCMakeTest.cmake")

include("/home/gpp/dev-SOMAFOAM/metis/rpmBuild/BUILD/cmake-3.2.2/Tests/CMakeTests/../RegexEscapeString.cmake")
REGEX_ESCAPE_STRING(CTEST_ESCAPED_CMAKE_CURRENT_SOURCE_DIR "/home/gpp/dev-SOMAFOAM/metis/rpmBuild/BUILD/cmake-3.2.2/Tests/CMakeTests")

macro(TEST command expected)
  if("x${result}" STREQUAL "x${expected}")
    #message("TEST \"${command}\" success: \"${result}\" expected: \"${expected}\"")
  else()
    message(SEND_ERROR "${CMAKE_CURRENT_LIST_LINE}: TEST \"${command}\" failed: \"${result}\" expected: \"${expected}\"")
  endif()
endmacro()

set(mylist andy bill ken brad)

list(LENGTH mylist result)
TEST("LENGTH mylist result" "4")
list(LENGTH "mylist" result)
TEST("LENGTH \"mylist\" result" "4")

list(LENGTH "nonexiting_list1" result)
TEST("LENGTH \"nonexiting_list1\" result" "0")

list(GET mylist 3 2 1 0 result)
TEST("GET mylist 3 2 1 0 result" "brad;ken;bill;andy")

list(GET mylist 0 item0)
list(GET mylist 1 item1)
list(GET mylist 2 item2)
list(GET mylist 3 item3)
set(result "${item3}" "${item0}" "${item1}" "${item2}")
TEST("GET individual 3 2 1 0 result" "brad;andy;bill;ken")

list(GET mylist -1 -2 -3 -4 result)
TEST("GET mylist -1 -2 -3 -4 result" "brad;ken;bill;andy")

list(GET mylist -1 2 -3 0 result)
TEST("GET mylist -1 2 -3 0 ${result}" "brad;ken;bill;andy")

list(GET "nonexiting_list2" 1 result)
TEST("GET \"nonexiting_list2\" 1 result" "NOTFOUND")

set(result andy)
list(APPEND result brad)
TEST("APPEND result brad" "andy;brad")

list(APPEND "nonexiting_list3" brad)
set(result "${nonexiting_list3}")
TEST("APPEND \"nonexiting_list3\" brad" "brad")

list(INSERT "nonexiting_list4" 0 andy bill brad ken)
set(result "${nonexiting_list4}")
TEST("APPEND \"nonexiting_list4\" andy bill brad ken" "andy;bill;brad;ken")

set(result andy brad)
list(INSERT result -1 bill ken)
TEST("INSERT result -1 bill ken" "andy;bill;ken;brad")

set(result andy bill brad ken bob)
list(REMOVE_ITEM result bob)
TEST("REMOVE_ITEM result bob" "andy;bill;brad;ken")

set(result andy bill bob brad ken peter)
list(REMOVE_ITEM result peter bob)
TEST("REMOVE_ITEM result peter bob" "andy;bill;brad;ken")

set(result bob andy bill bob brad ken bob)
list(REMOVE_ITEM result bob)
TEST("REMOVE_ITEM result bob" "andy;bill;brad;ken")

set(result andy bill bob brad ken peter)
list(REMOVE_AT result 2 -1)
TEST("REMOVE_AT result 2 -1" "andy;bill;brad;ken")

# ken is at index 2, nobody is not in the list so -1 should be returned
set(mylist andy bill ken brad)
list(FIND mylist ken result)
TEST("FIND mylist ken result" "2")

list(FIND mylist nobody result)
TEST("FIND mylist nobody result" "-1")

set(result ken bill andy brad)
list(SORT result)
TEST("SORT result" "andy;bill;brad;ken")

set(result andy bill brad ken)
list(REVERSE result)
TEST("REVERSE result" "ken;brad;bill;andy")

set(result bill andy bill brad ken ken ken)
list(REMOVE_DUPLICATES result)
TEST("REMOVE_DUPLICATES result" "bill;andy;brad;ken")

# these commands should just do nothing if the list is already empty
set(result "")
list(REMOVE_DUPLICATES result)
TEST("REMOVE_DUPLICATES empty result" "")

list(REVERSE result)
TEST("REVERSE empty result" "")

list(SORT result)
TEST("SORT empty result" "")

set(No-Arguments-RESULT 1)
set(No-Arguments-STDERR ".*CMake Error at (${CTEST_ESCAPED_CMAKE_CURRENT_SOURCE_DIR}/)?List-No-Arguments.cmake:1 \\(list\\):.*list must be called with at least two arguments.*")

# these trigger top-level condition
foreach(cmd IN ITEMS Append Find Get Insert Length Reverse Remove_At Remove_Duplicates Remove_Item Sort)
  set(${cmd}-No-Arguments-RESULT 1)
  set(${cmd}-No-Arguments-STDERR ".*CMake Error at List-${cmd}-No-Arguments.cmake:1 \\(list\\):.*list must be called with at least two arguments.*")
  string(TOUPPER ${cmd} cmd_upper)
  set(_test_file_name "${CMAKE_CURRENT_BINARY_DIR}/List-${cmd}-No-Arguments.cmake")
  file(WRITE "${_test_file_name}" "list(${cmd_upper})\n")
  check_cmake_test_single(List "${cmd}-No-Arguments" "${_test_file_name}")
endforeach()

set(Get-List-Only-STDERR "at least three")
set(Find-List-Only-STDERR "three")
set(Insert-List-Only-STDERR "at least three")
set(Length-List-Only-STDERR "two")
set(Remove_At-List-Only-STDERR "at least two")
set(Remove_Item-List-Only-STDERR "two or more")

foreach(cmd IN ITEMS Find Get Insert Length Remove_At Remove_Item)
  string(TOUPPER ${cmd} cmd_upper)
  set(${cmd}-List-Only-RESULT 1)
  set(${cmd}-List-Only-STDERR ".*CMake Error at List-${cmd}-List-Only.cmake:1 \\(list\\):.*list sub-command ${cmd_upper} requires ${${cmd}-List-Only-STDERR} arguments.*")
  set(_test_file_name "${CMAKE_CURRENT_BINARY_DIR}/List-${cmd}-List-Only.cmake")
  file(WRITE "${_test_file_name}" "list(${cmd_upper} mylist)\n")
  check_cmake_test_single(List "${cmd}-List-Only" "${_test_file_name}")
endforeach()

set(Length-Too-Many-Arguments-RESULT 1)
set(Length-Too-Many-Arguments-STDERR ".*CMake Error at (${CTEST_ESCAPED_CMAKE_CURRENT_SOURCE_DIR}/)?List-Length-Too-Many-Arguments.cmake:1 \\(list\\):.*list sub-command LENGTH requires two arguments.*")

set(Reverse-Too-Many-Arguments-RESULT 1)
set(Reverse-Too-Many-Arguments-STDERR ".*CMake Error at (${CTEST_ESCAPED_CMAKE_CURRENT_SOURCE_DIR}/)?List-Reverse-Too-Many-Arguments.cmake:1 \\(list\\):.*list sub-command REVERSE only takes one argument.*")

set(Remove_Duplicates-Too-Many-Arguments-RESULT 1)
set(Remove_Duplicates-Too-Many-Arguments-STDERR ".*CMake Error at (${CTEST_ESCAPED_CMAKE_CURRENT_SOURCE_DIR}/)?List-Remove_Duplicates-Too-Many-Arguments.cmake:1 \\(list\\):.*list sub-command REMOVE_DUPLICATES only takes one argument.*")

set(Sort-Too-Many-Arguments-RESULT 1)
set(Sort-Too-Many-Arguments-STDERR ".*CMake Error at (${CTEST_ESCAPED_CMAKE_CURRENT_SOURCE_DIR}/)?List-Sort-Too-Many-Arguments.cmake:1 \\(list\\):.*list sub-command SORT only takes one argument.*")

set(Invalid-Subcommand-RESULT 1)
set(Invalid-Subcommand-STDERR ".*CMake Error at (${CTEST_ESCAPED_CMAKE_CURRENT_SOURCE_DIR}/)?List-Invalid-Subcommand.cmake:1 \\(list\\):.*list does not recognize sub-command NO_SUCH_SUBCOMMAND.*")

foreach(cmd Get Insert Remove_At)
  set(${cmd}-Invalid-Index-RESULT 1)
  set(${cmd}-Invalid-Index-STDERR ".*CMake Error at (${CTEST_ESCAPED_CMAKE_CURRENT_SOURCE_DIR}/)?List-${cmd}-Invalid-Index.cmake:2 \\(list\\):.*list index: 3 out of range \\(-3, 2\\).*")
endforeach()

foreach(cmd Remove_Item Reverse Remove_Duplicates Sort Remove_At)
  string(TOUPPER ${cmd} Cmd)
  set(${cmd}-Nonexistent-List-RESULT 1)
  set(${cmd}-Nonexistent-List-STDERR ".*CMake Error at (${CTEST_ESCAPED_CMAKE_CURRENT_SOURCE_DIR}/)?List-${cmd}-Nonexistent-List.cmake:2 \\(list\\):.*sub-command ${Cmd} requires list to be present.*")
endforeach()

set(Get-CMP0007-Warn-RESULT 0)
set(Get-CMP0007-Warn-STDERR ".*CMake Warning \\(dev\\) at (${CTEST_ESCAPED_CMAKE_CURRENT_SOURCE_DIR}/)?List-Get-CMP0007-Warn.cmake:3 \\(list\\):.*Policy CMP0007 is not set:.*")

check_cmake_test(List
  No-Arguments
  Length-Too-Many-Arguments
  Reverse-Too-Many-Arguments
  Remove_Duplicates-Too-Many-Arguments
  Sort-Too-Many-Arguments
  Invalid-Subcommand
  Get-Invalid-Index
  Insert-Invalid-Index
  Remove_Item-Nonexistent-List
  Reverse-Nonexistent-List
  Remove_Duplicates-Nonexistent-List
  Sort-Nonexistent-List
  Remove_At-Nonexistent-List
  Remove_At-Invalid-Index
  Get-CMP0007-Warn
)

set(thelist "" NEW OLD)

foreach (_pol ${thelist})
    cmake_policy(SET CMP0007 ${_pol})
    list(GET thelist 1 thevalue)
    if (NOT thevalue STREQUAL _pol)
        message(SEND_ERROR "returned element '${thevalue}', but expected '${_pol}'")
    endif()
endforeach (_pol)
