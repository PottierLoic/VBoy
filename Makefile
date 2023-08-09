ifeq ($(OS),Windows_NT)
    CLEAN_BUILD = del
else
    CLEAN_BUILD = rm -f
endif

dev:
	v ./src -o ./vboy.exe

prod:
	v ./src -prod -o ./vboy.exe

# Target for testing code faster
zelda:
	v run ./src ./roms/zelda.gb

# Profiler to test vboy speed
profile:
	v -prod -profile profile.txt run ./src ./roms/zelda.gb