cmake_minimum_required(VERSION 3.24)

# Set the project name
project(cmake_template VERSION 1.0.0 LANGUAGES C ASM)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
# Add an executable
add_subdirectory(hal_lib)
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
include(fetchfreeRtos)


add_executable(MyExecutable   "application/main.c")

target_link_libraries(MyExecutable PRIVATE hal_lib freertos_kernel)
set_target_properties(MyExecutable PROPERTIES SUFFIX ".elf")
add_custom_target(flash
    COMMAND openocd -f interface/cmsis-dap.cfg -f target/stm32f4x.cfg\ 
    -c "program ${CMAKE_CURRENT_BINARY_DIR}/MyExecutable.elf verify reset exit"
    DEPENDS MyExecutable
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    COMMENT "Flashing the target using OpenOCD"
)

add_custom_command(TARGET MyExecutable POST_BUILD
    COMMAND  ${CMAKE_OBJCOPY} -O binary MyExecutable.elf  MyExecutable.bin
    # COMMAND ${CMAKE_SIZE} MyExecutable.elf
)

# Add the Doxygen  and sphinx  documentation
include(sphinx_doxygen)