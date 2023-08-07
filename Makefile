ifeq ($(OS),Windows_NT)
    CLEAN_BUILD = del
else
    CLEAN_BUILD = rm -f
endif

main:
	v ./src -o ./vboy.exe

prod:
	v ./src -prod -o ./vboy.exe

clean:
	${CLEAN_BUILD} vboy.exe

# Target for testing code faster
zelda:
	v run ./src ./roms/zelda.gb