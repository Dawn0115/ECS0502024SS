matAdd.out:  matAdd.o
	ld -m elf_i386 -o matAdd.out matAdd.o
matAdd.o:  matAdd.s
	as --gstabs -o matAdd.o matAdd.s
clean:
	rm -f *.out *.o
