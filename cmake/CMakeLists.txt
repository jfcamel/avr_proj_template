cmake_minimum_required(VERSION 3.4.2)
project(TEMPLATE)

set(MCU "atmega328p")
set(PROGRAMMER "avrispv2")
set(PORT "/dev/ttyACM0")

set(CMAKE_C_COMPILER avr-gcc)
set(CMAKE_C_FLAGS "-mmcu=${MCU} -g -Wall -mcall-prologues -Os")
set(CMAKE_LD_FLAGS "-Wl,-gc-sections -Wl,-relax")


include_directories(
  ${CMAKE_CURRENT_LIST_DIR}/
)

set(SRC
  ${CMAKE_CURRENT_LIST_DIR}/main.c
)

add_executable(${CMAKE_PROJECT_NAME}.elf
  ${SRC})

add_custom_target(${CMAKE_PROJECT_NAME}.hex
  avr-objcopy -R .eeprom -O ihex ${CMAKE_PROJECT_NAME}.elf ${CMAKE_PROJECT_NAME}.hex
  )

add_dependencies(${CMAKE_PROJECT_NAME}.hex ${CMAKE_PROJECT_NAME}.elf)

add_custom_target(program
  avrdude -c avrispv2 -P ${PORT} -p ${MCU} -U flash:w:${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_PROJECT_NAME}.hex:i  -v -v
  )

add_dependencies(program ${CMAKE_PROJECT_NAME}.hex)
