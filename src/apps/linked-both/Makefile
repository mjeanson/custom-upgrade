all: linked-both

linked-both: linked-both.o
	$(CC) -o $@ $^ $(LDFLAGS) -lzero -lone $(LDLIBS)

clean:
	-rm -f *.o linked-both

.PHONY: clean
