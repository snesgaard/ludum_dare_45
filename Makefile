all:
	make -C art/actor
	make -C art/tiles
	make -C art/maps

clean:
	make -C art/actor clean
	make -C art/tiles clean
	make -C art/maps clean
