CC=gcc
LD=ld
CFLAGS=-fno-pic -static -fno-builtin -nostdinc -I. -fno-strict-aliasing -Wall -MD -ggdb -m32 -Werror -fno-omit-frame-pointer -fno-stack-protector
ASFLAGS=-m32 -gdwarf-2 -Wa,-divide
LDFLAGS=-m elf_i386

all: bootblock

mkboot: mkboot.c
	$(CC) -o mkboot mkboot.c

bootblock: bootasm.S mkboot
	$(CC) $(CFLAGS) -c bootasm.S
	$(LD) $(LDFLAGS) -N -e start -Ttext 0x7C00 -o bootblock.o bootasm.o
	objcopy -S -O binary -j .text bootblock.o bootblock

-include *.d

clean:
	rm -f *.o *.d bootblock

qemu-gdb: bootblock
	qemu -serial mon:stdio -S -gdb tcp::26000 bootblock