
all : byteOps.so

byteOps.so : byteOps.o
	gcc -bundle -undefined dynamic_lookup -o byteOps.so byteOps.o

byteOps.o : byteOps.c
	gcc -c -fPIC byteOps.c

clean : 
	rm -rf *.o *.so
