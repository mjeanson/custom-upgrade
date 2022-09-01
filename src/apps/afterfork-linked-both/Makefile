all: afterfork-linked-both

afterfork-linked-both: afterfork-linked-both.o
	$(CC) -o $@ $^ $(LDFLAGS) -lzero -lone $(LDLIBS)

clean:
	-rm -f *.o afterfork-linked-both

.PHONY: clean
