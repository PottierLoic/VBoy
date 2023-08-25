ifeq ($(OS),Windows_NT)
    CLEAN_BUILD = del
else
    CLEAN_BUILD = rm -f
endif

dev:
	v -shared ./src -o ./vboy.exe

prod:
	v -shared ./src -prod -o ./vboy.exe

test-all:
	v test ./tests/

test-cpu:
	v test ./tests/cpu/

# Target for testing code faster
zelda:
	v -shared ./src
	vboy.exe ./roms/zelda.gb

# Profiler to test vboy speed
# Doesnt work anymore with -shared apparently
profile:
	v -shared -profile profile.txt run ./src ./roms/zelda.gb