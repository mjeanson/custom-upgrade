all: fork-linked-both

fork-linked-both: fork-linked-both.o
	$(CC) -o $@ $^ $(LDFLAGS) -lzero -lone $(LDLIBS)

clean:
	-rm -f *.o fork-linked-both

.PHONY: clean
