cmake_minimum_required(VERSION 3.24)

# Set the project name
project(cmake_template VERSION 1.0.0 LANGUAGES C ASM)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
# Add an executable
add_subdirectory(hal_lib)

################## FreeRtos Dependency #####################
# create FreeRTos config interface target
add_library(freertos_config INTERFACE)
# set the contained directory of FreeRTOSConfig.h
target_include_directories(freertos_config
    INTERFACE
    ${CMAKE_CURRENT_SOURCE_DIR}/freertos
)

# Select the heap port.  values between 1-4 will pick a heap.
set(FREERTOS_HEAP "4" CACHE STRING "" FORCE)

# Select the native compile PORT
set(FREERTOS_PORT "GCC_ARM_CM4F" CACHE STRING "" FORCE)

include(FetchContent)
# using fetch_content to import  freertos
FetchContent_Declare( freertos_kernel
  GIT_REPOSITORY https://github.com/FreeRTOS/FreeRTOS-Kernel.git
  GIT_TAG        V11.1.0 #Note: Best practice to use specific git-hash or tagged version
)
FetchContent_MakeAvailable(freertos_kernel)

################## FreeRtos END #####################

add_executable(MyExecutable   "application/main.c")

target_link_libraries(MyExecutable PRIVATE hal_lib freertos_kernel)
set_target_properties(MyExecutable PROPERTIES SUFFIX ".elf")
add_custom_target(flash
    COMMAND openocd -f interface/cmsis-dap.cfg -f target/stm32f4x.cfg -c "program ${CMAKE_CURRENT_BINARY_DIR}/MyExecutable.elf verify reset exit"
    DEPENDS MyExecutable
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    COMMENT "Flashing the target using OpenOCD"
)

add_custom_command(TARGET MyExecutable POST_BUILD
    COMMAND  ${CMAKE_OBJCOPY} -O binary MyExecutable.elf  MyExecutable.bin
    # COMMAND ${CMAKE_SIZE} MyExecutable.elf
)