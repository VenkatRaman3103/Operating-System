ASM = nasm

SRC_DIR = src
BUILD_DIR = build

.PHONY: all floppy_image kernel bootloader clean always

#
# FLOPPY IMAGE
#
floppy_image: $(BUILD_DIR)/main_floppy.img

$(BUILD_DIR)/main_floppy.img: bootloader kernel
	dd if=/dev/zero of=$(BUILD_DIR)/main_floppy.img bs=512 count=2880
	mkfs.fat -F 12 -n "NBOS" $(BUILD_DIR)/main_floppy.img
	mcopy -i $(BUILD_DIR)/main_floppy.img $(BUILD_DIR)/kernel.bin "::kernel.bin"
	dd if=$(BUILD_DIR)/bootloader.bin of=$(BUILD_DIR)/main_floppy.img conv=notrunc
	truncate -s 1440k $(BUILD_DIR)/main_floppy.img

#
# BOOTLOADER
#
bootloader: $(BUILD_DIR)/bootloader.bin

$(BUILD_DIR)/bootloader.bin: always
	$(ASM) $(SRC_DIR)/bootloader/boot.asm -f bin -o $(BUILD_DIR)/bootloader.bin

#
# KERNEL
#
kernel: $(BUILD_DIR)/kernel.bin

$(BUILD_DIR)/kernel.bin: always
	$(ASM) $(SRC_DIR)/kernel/main.asm -f bin -o $(BUILD_DIR)/kernel.bin

#
# ALWAYS
#
always: 
	mkdir -p $(BUILD_DIR)

#
# CLEAN
#
clea: 
	rm -rf $(BUILD_DIR)/*

run: $(BUILD_DIR)/main_floppy.img
	qemu-system-x86_64 -fda $<
