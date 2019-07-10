AS = as --32
LD = ld -m elf_i386 -dynamic-linker /lib/ld-linux.so.2 -lc
FLAGS = -gstabs

all:
	$(AS) $(FLAGS) -o main.o main.s
	$(LD)	-o main.x main.o

due:
	$(AS) $(FLAGS) -o main2.o main2.s
	$(LD)	-o main2.x main2.o
	
clean:
	rm -f main.o main2.o main.x main2.x core