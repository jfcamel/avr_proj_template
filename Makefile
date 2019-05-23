MCU=atmega328p
PORT=/dev/ttyACM0
CFLAGS=-g -Wall -mcall-prologues -mmcu=$(MCU) -Os -D__AVR_ATmega328P__
LDFLAGS=-Wl,-gc-sections -Wl,-relax
CC=avr-gcc
#MAKEFILE_DIR=$(shell dirname "$(readlink -f "$0")")
TARGET=uartcom
PROGRAMMER=avrispv2
SRC=main.c

all: $(TARGET).hex

clean:
	rm -f *.o *.elf *.hex

%.hex: %.elf
	avr-objcopy -R .eeprom -O ihex $< $@

$(TARGET).elf: $(TARGET).o
	$(CC) $(CFLAGS) $(LDFLAGS) $^ -o $@

program: $(TARGET).hex
	avrdude -F -c $(PROGRAMMER) -P $(PORT) -p $(MCU) -U flash:w:$<:i  -v -v
	#avrdude -c stk500v2 -P "$(PORT)" -p $(MCU) -U flash:w:$<:i

