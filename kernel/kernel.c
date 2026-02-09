#include <stddef.h>
#include <stdint.h>
#include "../drivers/tty.h"

void main() {
  terminal_initialize();
  char *msg = "HEllo Shitty World";
  print(msg);
}
