AS = as --32
LD = ld -m elf_i386 -dynamic-linker /lib/ld-linux.so.2 -lc
FLAGS = -gstabs

all:
	$(AS) $(FLAGS) -o main.o main.s
	$(LD)	-o main.x main.o
clean:
	rm -f main.o main.x core