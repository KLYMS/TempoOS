# Variables for tools and flags
ASM         = nasm
ASM_BIN     = -f bin
ASM_ELF     = -f elf

QEMU        = qemu-system-x86_64
DRIVE       = -drive format=raw,file=$(BUILD)/$(OS_IMG)
FDA         = -fda

LD          = /usr/local/cross/bin/x86_64-elf-ld
GCC         = /usr/local/cross/bin/x86_64-elf-gcc
# aft 32bit PM which is not yet 64 bit
LD_ELF32    =  -m elf_i386
# for 32 bit binary after PM
GCC_32      = -m32
STD_        = -std=gnu99
OPT         = -O2
WARNINGS    = -Wall -Wextra -Werror
NO_STD      =  -nostdlib -nostdinc -fno-builtin -fno-stack-protector -nostartfiles -nodefaultlibs -ffreestanding
CFLAGS      = $(STD_) $(GCC_32) $(WARNINGS) $(NO_STD) $(OPT) 



# Build paths
BUILD       = ../build
KERNEL      = kernel
BOOTLOADER  = bootloader
DEBUG       = debug

# Output files
KERNEL_BIN  = kernel.bin
BOOT_BIN    = boot.bin
OS_IMG      = os-image.bin

.PHONY: all build run clean

# Target: Default (build everything)
all: build

# Rule to build everything (kernel and bootloader)
build: $(BUILD)/$(OS_IMG)

# Combine the bootloader and kernel to form the final OS image
$(BUILD)/$(OS_IMG): $(BUILD)/$(BOOT_BIN) $(BUILD)/$(KERNEL_BIN)
	cat $^ > $@

# Rule to assemble the kernel entry (written in assembly)
$(BUILD)/kernel_entry.o: $(BOOTLOADER)/kernel_entry.asm
	$(ASM) $^ $(ASM_ELF) -o $@

# Rule to compile the C kernel
$(BUILD)/kernel.o: $(KERNEL)/kernel.c
	$(GCC) $(CFLAGS) -c $< -o $@ 

# Rule to build the kernel binary
$(BUILD)/$(KERNEL_BIN): $(BUILD)/kernel_entry.o $(BUILD)/kernel.o 
	$(LD) $(LD_ELF32) -o $@ -Ttext 0x1000 $^ --oformat binary

# Rule to assemble the bootloader (boot sector)
$(BUILD)/$(BOOT_BIN): $(BOOTLOADER)/boot.asm
	$(ASM) $^ -I $(BOOTLOADER) $(ASM_BIN) -o $@

# Disassemble the kernel for debugging (optional)
$(DEBUG)/kernel.dis: $(BUILD)/$(KERNEL_BIN)
	ndisasm -b 32 $< > $@

# Run the OS image in QEMU (without rebuilding)
run: $(BUILD)/$(OS_IMG)
	# $(QEMU) $(DRIVE)
	$(QEMU) $(FDA) $<
# Clean up build artifacts
clean:
	rm -f $(BUILD)/*
	rm -f $(DEBUG)/*


