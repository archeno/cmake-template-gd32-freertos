# 找到 Doxygen
find_package(Doxygen REQUIRED)
find_package(Sphinx REQUIRED)


# 配置 Doxygen
set(DOXYGEN_INPUT_DIR "${CMAKE_SOURCE_DIR}/application")
set(DOXYGEN_OUTPUT_DIR "${CMAKE_BINARY_DIR}/docs/doxygen")
set(DOXYGEN_XML_DIR "${DOXYGEN_OUTPUT_DIR}/xml")
set(DOXYFILE_IN "${CMAKE_SOURCE_DIR}/docs/doxygen/Doxyfile.in")
set(DOXYFILE_OUT "${CMAKE_BINARY_DIR}/docs/doxygen/Doxyfile")



configure_file(${DOXYFILE_IN} ${DOXYFILE_OUT} @ONLY)
add_custom_target(doxygen ALL
    COMMAND ${DOXYGEN_EXECUTABLE} ${DOXYFILE_OUT}
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    COMMENT "Generating Doxygen documentation"
    VERBATIM)


# 配置 Sphinx
set(SPHINX_SOURCE "${CMAKE_SOURCE_DIR}/docs/sphinx/source")
set(SPHINX_BUILD "${CMAKE_BINARY_DIR}/docs/sphinx/build")


add_custom_target(sphinx ALL
    COMMAND ${SPHINX_EXECUTABLE} -b html ${SPHINX_SOURCE} ${SPHINX_BUILD}
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    COMMENT "Generating Sphinx documentation"
    VERBATIM)
  
# 让 Sphinx 依赖于 Doxygen
add_dependencies(sphinx doxygen)
