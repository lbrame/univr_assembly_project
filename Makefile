AS = as --32
LD = ld -m elf_i386
LINK = -dynamic-linker /lib/ld-linux.so.2 -lc
FLAGS = -gstabs
F1 = main
F2 = vectlib
FINAL = main.x

all:
	$(AS) $(FLAGS) -o $(F2).o $(F2).s
	$(AS) $(FLAGS) -o $(F1).o $(F1).s
	$(LD) -o $(FINAL) $(F2).o $(F1).o $(LINK)

run:
	$(AS) $(FLAGS) -o $(F2).o $(F2).s
	$(AS) $(FLAGS) -o $(F1).o $(F1).s
	$(LD) -o $(FINAL) $(F2).o $(F1).o $(LINK)
	./$(FINAL)

nodbrun:	
	$(AS) -o $(F2).o $(F2).s
	$(AS) -o $(F1).o $(F1).s
	$(LD) -o $(FINAL) $(F2).o $(F1).O $(LINK)
	./$(FINAL)

nodebug:
	$(AS) -o $(F2).o $(F2).s
	$(AS) -o $(F1).o $(F1).s
	$(LD) -o $(FINAL) $(F2).o $(F1).o $(LINK)

clean:
	rm -f $(F1).o $(F1).x $(F2).o $(F2).x core
