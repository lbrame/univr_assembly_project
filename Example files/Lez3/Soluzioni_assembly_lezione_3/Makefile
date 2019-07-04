AS = as --32
LD = ld -m elf_i386
FLAGS = -gstabs

all:
	$(AS) $(FLAGS) -o MCD.o MCD.s 
	$(AS) $(FLAGS) -o fattoriale.o fattoriale.s 
	$(LD) -o MCD.x MCD.o 
	$(LD) -o fattoriale.x fattoriale.o 
clean: 
	rm -f *.o *.x core
