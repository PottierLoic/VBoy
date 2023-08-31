ifeq ($(OS),Windows_NT)
    CLEAN_BUILD = del
else
    CLEAN_BUILD = rm -f
endif

dev:
	v -shared ./vboy
	v ./vboy.v -o vboy.exe

prod:
	v -shared -prod ./vboy
	v -prod vboy.v -o vboy.exe

# Target for testing code faster
zelda:
	v -shared ./vboy
	v run vboy.v ./roms/zelda.gb

# TESTS

test-all:
	v test ./tests/

test-cpu:
	v test ./tests/cpu/

test-reg:
	v test ./tests/registers

# Doesnt work anymore with -shared apparently
profile:
	make dev
	v -profile profile.txt run ./vboy.v ./roms/zelda.gb