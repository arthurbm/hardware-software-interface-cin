# Determine the absolute path to the root directory
ROOT_DIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))

# Targets
all: compile execute

# Compile target
compile:
	nasm "$(ROOT_DIR)/$(file).asm" -o "$(ROOT_DIR)/$(file).bin"

# Execute target
execute:
	qemu-system-i386 "$(ROOT_DIR)/$(file).bin"

# Clean target
clean:
	rm -f "$(ROOT_DIR)/provas"/*/*.bin
	rm -f "$(ROOT_DIR)/atividades_praticas"/*/*.bin
