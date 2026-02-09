ASM     ?= nasm
CC      ?= gcc
LD      ?= ld
GDB     ?= i686-elf-gdb

# --- QEMU Configuration ---
QEMU        = qemu-system-i386
# Using -drive is often safer than -fda for raw images in newer QEMU
QEMU_FLAGS  = -drive format=raw,file=$(OS_IMAGE),index=0,if=floppy
QEMU_DEBUG  = -s -S

# --- Compiler Flags ---
CFLAGS   = -m32 -ffreestanding -fno-pie -fno-stack-protector -O2 -Wall -g
LDFLAGS  = -m elf_i386 -no-pie -T linker.ld -nostdlib
# CFLAGS   = -ffreestanding -O2 -Wall -Wextra -g -std=gnu99
# CFLAGS  += -I. 
# LDFLAGS  = -T linker.ld -nostdlib

# --- Directories & Files ---
BUILD_DIR   = build
SRC_DIRS    = .
BOOTLOADER = Bootloader

# Find all source files
ASM_SOURCES = $(shell find $(SRC_DIRS) -name "*.asm" -not -path "./bootloader/*")
C_SOURCES   = $(shell find $(SRC_DIRS) -name "*.c")

# Convert source filenames to object filenames
# Example: kernel.c -> build/kernel.o
OBJ_FILES   = $(patsubst %.c, $(BUILD_DIR)/%.o, $(C_SOURCES))

# Specific Bootloader files
BOOT_BIN    = $(BUILD_DIR)/boot.bin
KERNEL_BIN  = $(BUILD_DIR)/kernel.bin
OS_IMAGE    = $(BUILD_DIR)/os.img

# --- Targets ---

.PHONY: all clean build run debug

all: build
build: $(OS_IMAGE)

# 1. Create the OS Image by combining bootloader and kernel
$(OS_IMAGE): $(BOOT_BIN) $(KERNEL_BIN)
	@echo "[IMG] Creating disk image $@"
	@cat $^ > $@

# 2. Compile the Bootloader (Binary format)
$(BOOT_BIN): bootloader/boot.asm | $(BUILD_DIR)
	@echo "[ASM] Assembling Bootloader $@"
	$(ASM) $^ -I $(BOOTLOADER) -f bin $< -o $@

# 3. Link the Kernel
# We link the entry object first to ensure it's at the top
$(KERNEL_BIN): $(BUILD_DIR)/kernel_entry.o $(OBJ_FILES)
	@echo "[LD] Linking Kernel"
	$(LD) -o $@ $(LDFLAGS) $^ --oformat binary

# 4. Compile C Files
$(BUILD_DIR)/%.o: %.c | $(BUILD_DIR)
	@echo "[CC] Compiling $<"
	$(CC) $(CFLAGS) -c $< -o $@

# 5. Assemble the Kernel Entry
$(BUILD_DIR)/kernel_entry.o: bootloader/kernel_entry.asm | $(BUILD_DIR)
	@echo "[ASM] Assembling Kernel Entry"
	$(ASM) -f elf $< -o $@

# Create build directory if it doesn't exist
$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)

# --- Commands ---

run: $(OS_IMAGE)
	$(QEMU) $(QEMU_FLAGS)

debug: $(OS_IMAGE)
	@echo "[DEBUG] Waiting for GDB connection..."
	$(QEMU) $(QEMU_FLAGS) $(QEMU_DEBUG) &
	$(GDB) -ex "target remote localhost:1234" -ex "symbol-file $(BUILD_DIR)/kernel.elf"

clean:
	rm -rf $(BUILD_DIR)
