MCU=atmega328p
PORT=/dev/ttyACM0
CFLAGS=-g -Wall -mcall-prologues -mmcu=$(MCU) -Os
LDFLAGS=-Wl,-gc-sections -Wl,-relax
CC=avr-gcc
MAKEFILE_DIR=$(shell dirname "$(readlink -f "$0")")
TARGET=$(MAKEFILE_DIR)
PROGRAMMER=avrispv2

all: $(TARGET).hex

clean:
	rm -f *.o *.elf *.hex

%.hex: %.elf
	avr-objcopy -R .eeprom -O ihex $< $@

$(TARGET).elf: $(TARGET).o
	$(CC) $(CFLAGS) $(LDFLAGS) $^ -o $@

program: $(TARGET).hex
	avrdude -c $(PROGRAMMER) -P $(PORT) -p $(MCU) -U flash:w:$<:i  -v -v
	#avrdude -c stk500v2 -P "$(PORT)" -p $(MCU) -U flash:w:$<:i

