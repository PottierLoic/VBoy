ifeq ($(OS),Windows_NT)
    CLEAN_CMD = del
else
    CLEAN_CMD = rm -f
endif

main:
	v ./src -o ./vboy.exe

prod:
	v ./src -prod -o ./vboy.exe

clean:
	${CLEAN_CMD} vboy.exe

# Target for running code faster
zelda:
	v run ./src ./roms/zelda.gb