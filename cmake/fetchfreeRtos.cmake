
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