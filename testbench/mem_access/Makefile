# vsim -sv_lib mem_access ....

CFLAGS = -O1 -I/c/altera/13.1/modelsim_ase/include

mem_access.dll: mem_access.o
	cc -shared -Bsymbolic -o mem_access.dll mem_access.o

install:
	cp mem_access.dll ../../simulation/modelsim/mem_access.dll

clean:
	rm -f *.o *.dll
