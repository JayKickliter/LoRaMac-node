set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

##########################################################################
# Set cross compiler                                                     #
##########################################################################
set(CMAKE_C_COMPILER   "arm-none-eabi-gcc")
set(CMAKE_CXX_COMPILER "arm-none-eabi-g++")

##########################################################################
# Set cross compiler defines and flags                                   #
##########################################################################
set(TOOLCHAIN_COMPILER_FLAGS
  "-mcpu=cortex-m0plus"
  CACHE STRING
  "Toolchain specific flags"
  FORCE
  )
