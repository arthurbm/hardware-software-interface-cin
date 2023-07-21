ASM_SRC = $(file).asm
BIN_OUT = $(file).bin

all: compile execute

compile: $(ASM_SRC)
	nasm $(ASM_SRC) -o $(BIN_OUT)

execute: $(BIN_OUT)
	qemu-system-i386 $(BIN_OUT)

clean:
	rm $(BIN_OUT)
