# Set the name of the toolchain
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)

# Specify the cross compiler
# set(CMAKE_C_COMPILER arm-none-eabi-gcc)
# set(CMAKE_CXX_COMPILER arm-none-eabi-g++)
# set(CMAKE_ASM_COMPILER arm-none-eabi-gcc)

# Specify the target architecture
set(CMAKE_C_FLAGS "-mcpu=cortex-m4 -mthumb")
set(CMAKE_CXX_FLAGS "-mcpu=cortex-m4 -mthumb")
set(CMAKE_ASM_FLAGS "-mcpu=cortex-m4 -mthumb")

set(LINKER_SCRIPT ${CMAKE_SOURCE_DIR}/board/linker_script/linker_script.ld)

#spccify libray nano
# set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -specs=nano.specs")

# # nosys
# set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS}")



# specify the linker flags
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_C_FLAGS} -nostartfiles  -T${LINKER_SCRIPT} -Wl,-Map=${PROJECT_NAME}.map,--cref -Wl,--gc-sections -Wl,--print-memory-usage")

# compiler flags for garbage collection
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -mfloat-abi=hard  -mfpu=fpv4-sp-d16 -ffunction-sections -fdata-sections")




# Specify the path to the toolchain
set(CMAKE_FIND_ROOT_PATH D:/01DevelopmentTools/mingw)
# Search for programs in the build host directories
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
# For libraries and headers in the target directories
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

# Specify the path to the C/c++ compiler
set(CMAKE_C_COMPILER  ${CMAKE_FIND_ROOT_PATH}/bin/arm-none-eabi-gcc.exe)
set(CMAKE_CXX_COMPILER ${CMAKE_FIND_ROOT_PATH}/bin/arm-none-eabi-g++.exe)

set(CMAKE_SIZE   ${CMAKE_FIND_ROOT_PATH}/bin/arm-none-eabi-size.exe)

# set asm compiler
set(CMAKE_ASM_COMPILER ${CMAKE_FIND_ROOT_PATH}/bin/arm-none-eabi-gcc.exe)
set(CMAKE_C_COMPILER_WORKS ON)
set(CMAKE_CXX_COMPILER_WORKS ON)
set(CMAKE_asm_COMPILER_WORKS ON)