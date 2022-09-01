all: libzero.so

%.o : %.c
	$(CC) -c $(CFLAGS) $(CPPFLAGS) -fPIC $< -o $@

libzero.so: libzero.o tp-libzero.o
	$(CC) -shared -fPIC -o $@ $^ $(LDFLAGS) $(LDLIBS)

clean:
	-rm -f *.o libzero.so

.PHONY: clean
