cmake_minimum_required(VERSION 3.6)


##########################################################################
# Setup project                                                          #
##########################################################################
# NOTE: Each target (firmware image or executable) image will have their own name
project(LoRaMac-node)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
enable_language(C CXX ASM)


##########################################################################
# Cross compiler defines and flags                                       #
##########################################################################
set(CROSS_COMMON_FLAGS
  "-Wall -Wextra -fdata-sections -ffunction-sections -mcpu=cortex-m0plus -mthumb --specs=nano.specs --specs=nosys.specs -flto"
  CACHE STRING
  "Common flags when compiling for ARM"
  FORCE
  )
set(CROSS_COMMON_DEFINES
  ""
  CACHE STRING
  "Common defines when compiling for ARM"
  FORCE
  )
set(CROSS_C_FLAGS
  "-std=gnu11 "
  CACHE STRING
  "c compiler flags to use when compiling for ARM"
  FORCE
  )
set(CROSS_CXX_FLAGS
  "-fno-exceptions -fno-rtti -std=gnu++11"
  CACHE STRING
  "c++ compiler flags to use when compiling for ARM"
  FORCE
  )
set(CROSS_EXE_LINKER_FLAGS
  "-Wl,--gc-sections"
  CACHE STRING
  "Linker flags to when linking ARM targets"
  FORCE
  )
set(CROSS_EXECUTABLE_SUFFIX ".elf")

# Now map the cross-compile variables to global cmake variables
set(CMAKE_C_FLAGS "${TOOLCHAIN_COMPILER_FLAGS} ${CROSS_C_FLAGS} ${CROSS_COMMON_DEFINES} ${CROSS_COMMON_FLAGS} ${CMAKE_C_FLAGS}")
set(CMAKE_CXX_FLAGS "${TOOLCHAIN_COMPILER_FLAGS} ${CROSS_CXX_FLAGS} ${CROSS_COMMON_DEFINES} ${CROSS_COMMON_FLAGS} ${CMAKE_CXX_FLAGS}")
SET(ASM_OPTIONS "-x assembler-with-cpp")
SET(CMAKE_ASM_FLAGS "${CFLAGS} ${ASM_OPTIONS}" )
set(CMAKE_EXE_LINKER_FLAGS ${CROSS_EXE_LINKER_FLAGS})
set(CMAKE_EXECUTABLE_SUFFIX ${CROSS_EXECUTABLE_SUFFIX})

# Stop CMAKE from adding linker flag `-Wl,-search-paths-first` which only applicable to OS X host targets
if(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
    set(CMAKE_C_LINK_FLAGS   "" CACHE STRING "" FORCE)
    set(CMAKE_CXX_LINK_FLAGS "" CACHE STRING "" FORCE)
endif()


##########################################################################
# MoteII                                                                 #
##########################################################################
set(MOTEII_LINKER_SCRIPT
  ${CMAKE_CURRENT_SOURCE_DIR}/src/boards/MoteII/cmsis/arm-gcc/stm32l051xx_flash.ld
  )
set(MOTEII_LORAMAC_COMMON_SRCS
  src/boards/MoteII/adc-board.c
  src/boards/MoteII/board.c
  src/boards/MoteII/cmsis/arm-gcc/startup_stm32l051xx.s
  src/boards/MoteII/cmsis/system_stm32l0xx.c
  src/boards/MoteII/display-board.c
  src/boards/MoteII/gpio-board.c
  src/boards/MoteII/gps-board.c
  src/boards/MoteII/i2c-board.c
  src/boards/MoteII/rtc-board.c
  src/boards/MoteII/spi-board.c
  src/boards/MoteII/sx1272-board.c
  src/boards/MoteII/uart-board.c
  src/boards/mcu/stm32/STM32L0xx_HAL_Driver/Src/stm32l0xx_hal.c
  src/boards/mcu/stm32/STM32L0xx_HAL_Driver/Src/stm32l0xx_hal_adc.c
  src/boards/mcu/stm32/STM32L0xx_HAL_Driver/Src/stm32l0xx_hal_adc_ex.c
  src/boards/mcu/stm32/STM32L0xx_HAL_Driver/Src/stm32l0xx_hal_cortex.c
  src/boards/mcu/stm32/STM32L0xx_HAL_Driver/Src/stm32l0xx_hal_dma.c
  src/boards/mcu/stm32/STM32L0xx_HAL_Driver/Src/stm32l0xx_hal_flash.c
  src/boards/mcu/stm32/STM32L0xx_HAL_Driver/Src/stm32l0xx_hal_flash_ex.c
  src/boards/mcu/stm32/STM32L0xx_HAL_Driver/Src/stm32l0xx_hal_flash_ramfunc.c
  src/boards/mcu/stm32/STM32L0xx_HAL_Driver/Src/stm32l0xx_hal_gpio.c
  src/boards/mcu/stm32/STM32L0xx_HAL_Driver/Src/stm32l0xx_hal_i2c.c
  src/boards/mcu/stm32/STM32L0xx_HAL_Driver/Src/stm32l0xx_hal_i2c_ex.c
  src/boards/mcu/stm32/STM32L0xx_HAL_Driver/Src/stm32l0xx_hal_pwr.c
  src/boards/mcu/stm32/STM32L0xx_HAL_Driver/Src/stm32l0xx_hal_pwr_ex.c
  src/boards/mcu/stm32/STM32L0xx_HAL_Driver/Src/stm32l0xx_hal_rcc.c
  src/boards/mcu/stm32/STM32L0xx_HAL_Driver/Src/stm32l0xx_hal_rcc_ex.c
  src/boards/mcu/stm32/STM32L0xx_HAL_Driver/Src/stm32l0xx_hal_rtc.c
  src/boards/mcu/stm32/STM32L0xx_HAL_Driver/Src/stm32l0xx_hal_rtc_ex.c
  src/boards/mcu/stm32/STM32L0xx_HAL_Driver/Src/stm32l0xx_hal_spi.c
  src/boards/mcu/stm32/STM32L0xx_HAL_Driver/Src/stm32l0xx_hal_uart.c
  src/boards/mcu/stm32/STM32L0xx_HAL_Driver/Src/stm32l0xx_hal_uart_ex.c
  src/boards/mcu/stm32/sysIrqHandlers.c
  src/boards/mcu/stm32/utilities.c
  src/mac/LoRaMac.c
  src/mac/LoRaMacCrypto.c
  src/peripherals/gpio-ioe.c
  src/peripherals/mag3110.c
  src/peripherals/mma8451.c
  src/peripherals/mpl3115.c
  src/peripherals/pam7q.c
  src/peripherals/sx1509.c
  src/radio/sx1272/sx1272.c
  src/system/adc.c
  src/system/crypto/aes.c
  src/system/crypto/cmac.c
  src/system/delay.c
  src/system/fifo.c
  src/system/gpio.c
  src/system/gps.c
  src/system/i2c.c
  src/system/timer.c
  src/system/uart.c
  )
set(MOTEII_LORAMAC_COMMON_INCS
  PRIVATE src
  PRIVATE src/boards/MoteII
  PRIVATE src/boards/MoteII/cmsis
  PRIVATE src/boards/mcu/stm32
  PRIVATE src/boards/mcu/stm32/STM32L0xx_HAL_Driver/inc
  PRIVATE src/boards/mcu/stm32/cmsis
  PRIVATE src/mac
  PRIVATE src/peripherals
  PRIVATE src/radio
  PRIVATE src/system
  PRIVATE src/system/crypto
  )

###########
# Class A #
###########
add_executable(MoteII-LoRaMac-ClassA
  ${MOTEII_LORAMAC_COMMON_SRCS}
  src/apps/LoRaMac/classA/MoteII/buttons.c
  src/apps/LoRaMac/classA/MoteII/main.c
  src/apps/LoRaMac/classA/MoteII/screen.c
  )
target_include_directories(MoteII-LoRaMac-ClassA
  ${MOTEII_LORAMAC_COMMON_INCS}
  )
target_compile_definitions(MoteII-LoRaMac-ClassA
  PRIVATE USE_HAL_DRIVER
  PRIVATE STM32L051xx
  PRIVATE USE_BAND_915
  )
target_link_libraries(MoteII-LoRaMac-ClassA -Wl,--script=${MOTEII_LINKER_SCRIPT} m)

###########
# Class B #
###########
add_executable(MoteII-LoRaMac-ClassB
  ${MOTEII_LORAMAC_COMMON_SRCS}
  src/apps/LoRaMac/classA/MoteII/buttons.c
  src/apps/LoRaMac/classA/MoteII/main.c
  src/apps/LoRaMac/classA/MoteII/screen.c
  )
target_include_directories(MoteII-LoRaMac-ClassB
  ${MOTEII_LORAMAC_COMMON_INCS}
  )
target_compile_definitions(MoteII-LoRaMac-ClassB
  PRIVATE USE_HAL_DRIVER
  PRIVATE STM32L051xx
  PRIVATE USE_BAND_915
  )
target_link_libraries(MoteII-LoRaMac-ClassB -Wl,--script=${MOTEII_LINKER_SCRIPT} m)

###########
# Class C #
###########
add_executable(MoteII-LoRaMac-ClassC
  ${MOTEII_LORAMAC_COMMON_SRCS}
  src/apps/LoRaMac/classA/MoteII/buttons.c
  src/apps/LoRaMac/classA/MoteII/main.c
  src/apps/LoRaMac/classA/MoteII/screen.c
  )
target_include_directories(MoteII-LoRaMac-ClassC
  ${MOTEII_LORAMAC_COMMON_INCS}
  )
target_compile_definitions(MoteII-LoRaMac-ClassC
  PRIVATE USE_HAL_DRIVER
  PRIVATE STM32L051xx
  PRIVATE USE_BAND_915
  )
target_link_libraries(MoteII-LoRaMac-ClassC -Wl,--script=${MOTEII_LINKER_SCRIPT} m)
