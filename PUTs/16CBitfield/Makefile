GCOV_OUTPUT = *.gcda *.gcno *.gcov 
GCOV_CCFLAGS = -fprofile-arcs -ftest-coverage
CC     = gcc
CCFLAGS = -I. -Itests -g -O2 $(GCOV_CCFLAGS)


all: test

main.c:
	sh tests/make-tests.sh tests/test*.c > main.c

test: main.c bitfield.o tests/test_bitfield.c tests/CuTest.c main.c
	$(CC) $(CCFLAGS) -o $@ $^
	./test
	gcov -bc main.c tests/test_bitfield.c bitfield.c

bitfield.o: bitfield.c
	$(CC) $(CCFLAGS) -c -o $@ $^

clean:
	rm -f main.c bitfield.o test $(GCOV_OUTPUT)
