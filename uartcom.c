#include <stdint.h>
#include <avr/io.h>
#include <inttypes.h>

#define F_CPU 20000000UL // clock spd
#include <util/delay.h>

typedef enum _uart_result {
  UART_SUCCESS = 0,
  UART_FAILURE
} uart_result;

void uart_init();
uint8_t uart_read();
uart_result uart_write(uint8_t data);

void uart_init()
{
#define BAUD 115200
#define USE_2X 0
#include <util/setbaud.h>
  UBRR0L = UBRRL_VALUE;
  UBRR0H = UBRRH_VALUE;
}

uint8_t uart_read()
{
  while (!(UCSR0A & (1<<RXC0))) {
  }

  return UDR0;
}

uart_result uart_write(uint8_t data)
{
  // wait until ready to transfer
  // "USART Data Register Ran Empty" (UDRE) 
  while (!(UCSR0A & (1<<UDRE0))) {}

  UDR0 = data;

  return UART_SUCCESS;
}

int main(void) {
  while (1) {
    _delay_ms(1);
  }
}
