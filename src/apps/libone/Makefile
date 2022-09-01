all: libone.so

%.o : %.c
	$(CC) -c $(CFLAGS) $(CPPFLAGS) -fPIC $< -o $@

libone.so: libone.o tp-libone.o
	$(CC) -shared -fPIC -o $@ $^ $(LDFLAGS) $(LDLIBS)

clean:
	-rm -f *.o libone.so

.PHONY: clean
