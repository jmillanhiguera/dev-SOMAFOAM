# This script drives creation of a Mercurial repository and checks
# that CTest can update from it.

#-----------------------------------------------------------------------------
# Test in a directory next to this script.
get_filename_component(TOP "${CMAKE_CURRENT_LIST_FILE}" PATH)
set(TOP "${TOP}/CTest UpdateHG")

# Include code common to all update tests.
include("/home/gpp/dev-SOMAFOAM/metis/rpmBuild/BUILD/cmake-3.2.2/Tests/CTestUpdateCommon.cmake")

#-----------------------------------------------------------------------------
# Report hg tools in use.
message("Using HG tools:")
set(HG "/usr/bin/hg")
message(" hg = ${HG}")

#-----------------------------------------------------------------------------
# Initialize the testing directory.
message("Creating test directory...")
init_testing()

#-----------------------------------------------------------------------------
# Create the repository.
message("Creating repository...")
file(MAKE_DIRECTORY ${TOP}/repo.hg)
run_child(
  WORKING_DIRECTORY ${TOP}/repo.hg
  COMMAND ${HG} init
  )
if(NOT "${TOP}" MATCHES "^/")
  set(slash /)
endif()
set(REPO file://${slash}${TOP}/repo.hg)

#-----------------------------------------------------------------------------
# Import initial content into the repository.
message("Importing content...")
create_content(import)

# Import the content into the repository.
run_child(WORKING_DIRECTORY ${TOP}/import
  COMMAND ${HG} init
  )
run_child(WORKING_DIRECTORY ${TOP}/import
  COMMAND ${HG} add .
  )
run_child(WORKING_DIRECTORY ${TOP}/import
  COMMAND ${HG} commit -m "Initial content"
                       -u "Test Author <testauthor@cmake.org>"
  )
run_child(WORKING_DIRECTORY ${TOP}/import
  COMMAND ${HG} push "${REPO}"
  )

#-----------------------------------------------------------------------------
# Create a working tree.
message("Checking out first revision...")
run_child(
  WORKING_DIRECTORY ${TOP}
  COMMAND ${HG} clone ${REPO} user-source
  )

#-----------------------------------------------------------------------------
# Make changes in the working tree.
message("Changing content...")
update_content(user-source files_added files_removed dirs_added)
if(dirs_added)
  run_child(
    WORKING_DIRECTORY ${TOP}/user-source
    COMMAND ${HG} add ${dirs_added}
    )
endif()
run_child(
  WORKING_DIRECTORY ${TOP}/user-source
  COMMAND ${HG} add ${files_added}
  )
run_child(
  WORKING_DIRECTORY ${TOP}/user-source
  COMMAND ${HG} rm ${files_removed}
  )
run_child(
  WORKING_DIRECTORY ${TOP}/user-source
  COMMAND ${HG} add
  )

#-----------------------------------------------------------------------------
# Commit the changes to the repository.
message("Committing revision 2...")
run_child(
  WORKING_DIRECTORY ${TOP}/user-source
  COMMAND ${HG} commit -m "Changed content"
                       -u "Test Author <testauthor@cmake.org>"
  )
run_child(
  WORKING_DIRECTORY ${TOP}/user-source
  COMMAND ${HG} push
  )

#-----------------------------------------------------------------------------
# Make changes in the working tree.
message("Changing content again...")
change_content(user-source)
run_child(
  WORKING_DIRECTORY ${TOP}/user-source
  COMMAND ${HG} add
  )

#-----------------------------------------------------------------------------
# Commit the changes to the repository.
message("Committing revision 3...")
run_child(
  WORKING_DIRECTORY ${TOP}/user-source
  COMMAND ${HG} commit -m "Changed content again"
                       -u "Test Author <testauthor@cmake.org>"
  )
run_child(
  WORKING_DIRECTORY ${TOP}/user-source
  COMMAND ${HG} push
  )

#-----------------------------------------------------------------------------
# Go back to before the changes so we can test updating.
message("Backing up to first revision...")
run_child(
  WORKING_DIRECTORY ${TOP}/user-source
  COMMAND ${HG} update -C -r 0
  )

# Create a modified file.
modify_content(user-source)

#-----------------------------------------------------------------------------
# Test updating the user work directory with the command-line interface.
message("Running CTest Dashboard Command Line...")

# Create the user build tree.
create_build_tree(user-source user-binary)
file(APPEND ${TOP}/user-binary/CTestConfiguration.ini
  "# HG command configuration
UpdateCommand: ${HG}
")

# Run the dashboard command line interface.
run_dashboard_command_line(user-binary)

#-----------------------------------------------------------------------------
# Test initial checkout and update with a dashboard script.
message("Running CTest Dashboard Script...")

create_dashboard_script(dash-binary
  "# hg command configuration
set(CTEST_HG_COMMAND \"${HG}\")
set(CTEST_HG_UPDATE_OPTIONS)
execute_process(
  WORKING_DIRECTORY \"${TOP}\"
  COMMAND \"${HG}\" clone \"${REPO}\" dash-source
  )
execute_process(
  WORKING_DIRECTORY \"${TOP}/dash-source\"
  COMMAND \"${HG}\" update -C -r 0
  )
")

# Run the dashboard script with CTest.
run_dashboard_script(dash-binary)
