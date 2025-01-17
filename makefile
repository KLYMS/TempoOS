# Assembly tool and the nessary flags
ASM   			= nasm
ASM_BIN 		= -f bin
ASM_ELF 		= -f elf

# For Virtualization 
QEMU 				= qemu-system-x86_64
DRIVE 			= -drive format=raw,file=$(OS_IMAGE)
FDA 				= -fda   #Floppy Disk Image 
QEMU_GDB		= -S -s
QEMU_CPU32	= -cpu qemu32


# lINKER and GCC-CROSS COMPILER
LD 					= /usr/local/cross/bin/x86_64-elf-ld
LD_ELF32		= -m elf_i386   # for 32 bit LINKER
LINKER_LD		= ./linker.ld

GCC 				= /usr/local/cross/bin/x86_64-elf-gcc
GCC_32 			= -m32
STD_				= -std=gnu99
OPT 				= -O0
WARNINGS 		= -Wall -Wextra -Werror
NO_STD			= -ffreestanding
GCC_DEBUG		= -g
CFLAGS			=	$(STD_) $(GCC_32) $(OPT) $(WARNINGS) $(NO_STD) 
# Additional include directories
CFLAGS += $(addprefix -I, $(SRC_DIRS))
CFLAGS += -nostdlib -lgcc

BOOTLOADER	= bootloader
SRC_DIRS    = ./
BUILD_DIR 	= ../build
BUILD_DIRS := $(addprefix $(BUILD_DIR)/, $(SRC_DIRS))
DEBUG_DIR		= debug

# Files
ASM_FILES     = $(shell find $(SRC_DIRS) -name "*.asm")
C_FILES       = $(shell find $(SRC_DIRS) -name "*.c")
OBJ_FILES 		= $(patsubst %.c,$(BUILD_DIR)/%.o,$(notdir $(C_FILES))) 
#            $(patsubst %.asm,$(BUILD_DIR)/%.o,$(notdir $(ASM_FILES)))

# Outputs
BOOT_BIN		=	$(BUILD_DIR)/boot.bin
KERNEL_ELF 	= $(BUILD_DIR)/kernel.elf
KERNEL_BIN	= $(BUILD_DIR)/kernel.bin
OS_IMAGE		=	$(BUILD_DIR)/os.img

.PHONY: all build run debug clean debug_print

all: build

build: $(OS_IMAGE)

$(BUILD_DIR):
	@echo "[BLD] Creating Parent Build Directory"
	@madir -p $@

$(BUILD_DIRS):
	@echo "[BLD] Creating Build Directories $@"
	@mkdir -p $@

# Combine bootloader and kernel into OS image
$(OS_IMAGE): $(BOOT_BIN) $(KERNEL_BIN) | $(BUILD_DIR)
	@echo "[IMG] Creating OS image $@"
	@cat $^ > $@

$(BOOT_BIN): $(BOOTLOADER)/boot.asm | $(BUILD_DIRS)
	@echo "[ASM] Assembling bootloader $@"
	@$(ASM) $^ -I$(BOOTLOADER) $(ASM_BIN) -o $@ 

$(KERNEL_BIN): $(BUILD_DIR)/kernel_entry.o $(OBJ_FILES)
	@echo "[LD] Linking kernel binary $@"
	@$(LD) $(LD_ELF32) -o $@ -T $(LINKER_LD) $^ --oformat binary

$(BUILD_DIR)/kernel_entry.o: $(BOOTLOADER)/kernel_entry.asm
	@echo "[ASM] Building an kernel entry point $@"
	@$(ASM) $(ASM_ELF) $< -o $@

# Object file compilation rules
$(BUILD_DIR)/%.o : $(C_FILES)
	@echo "[CC] Compiling $< -> $@"
# @mkdir -p $(dir $@)
	@$(GCC) $(CFLAGS) -c $< -o $@

# $(BUILD_DIR)/%.o: %.asm
# 	@echo "[ASM] Assembling $< -> $@"
# 	@mkdir -p $(dir $@)
# 	@$(ASM) $(ASM_BIN) $< -o $@

run: $(OS_IMAGE) build
	$(QEMU) $(QEMU_CPU32) $(FDA) $<

debug: $(OS_IMAGE) $(KERNEL_ELF) build
	@echo "[DEBUG] Running OS in QEMU with GDB server"
	@$(QEMU) $(QEMU_CPU32) $(QEMU_GDB) $(FDA) $<
# Have to launch tmux seperate pane with gdb in it

debug_print: 
	@echo "c.files :: $(C_FILES)"
	@echo "o.files :: $(OBJ_FILES)"


# Clean up
clean:
	rm -rf $(BUILD_DIR) 
# @echo "[CLEAN] Removing Debug files"
# @rm -rf $(DEBUG_DIR) 





