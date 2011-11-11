d2c:
	d2c -o amicable amicable.lid
od:
	opendylan -build amicable.lid
clean:
	rm -f *.o *.c *.el *.mak *.hdp *.du amicable



