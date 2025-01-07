# Add the source files
file(GLOB  SOURCES CONFIGURE_DEPENDS "source/*.c" "startup/startup_gd32f4xx.s"  "cmsis/gd/source/*.c")


# message(STATUS "SOURCES: ${SOURCES}")
# Create a static library
add_library(hal_lib STATIC ${SOURCES})

# Specify include directories for the library
target_include_directories(hal_lib PUBLIC include
    cmsis/gd/include
    cmsis/core
)

target_compile_definitions(hal_lib PUBLIC
    -DGD32F425

)