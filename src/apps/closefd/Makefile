all: closefd

closefd: closefd.o
	$(CC) -o $@ $^ $(LDFLAGS) -lzero -lone $(LDLIBS)

clean:
	-rm -f *.o closefd

.PHONY: clean
