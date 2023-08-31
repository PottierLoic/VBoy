# VBoy  

VBoy is a WIP Gameboy emulator made for training (fun ?) purpose.  

It is written in V and uses v sdl wrapper for graphics.  

### Goals:  

- [ ] Fully functional Gameboy emulation  
- [ ] Tile and background visualization  
- [ ] Debugger  

### Future goals:
- [ ] Fast forward and speed change  
- [ ] Backtracking  

## Requirements  

- [V](https://github.com/vlang/v)
- [V SDL wrapper](https://github.com/vlang/sdl)
- SDL Developement libraries have to be installed

## Install / Run  

Don't forget to install the requirements:  [here](#requirements)  

Choose the way you prefer:
```bash
make dev // fast compilation
make prod // slower compilation, but gives better performance and more safety
```
or  
```bash
v -shared ./vboy
v vboy.v
```
Then you can launch it by providing the ROM path:  
```bash
vboy "./path/to/rom.gb"
```

## Warning and docs  

VBoy is still in development, not well optimized and poorly written.  
This may change in the future, but it is actually not a good emulator example (doesn't even work ^^).  

In case you want to develop one yourself, some websites and softwares are very useful:  
- [Pandocs](https://gbdev.io/pandocs/): contains everything about the Gameboy.  
- [Opcodes](https://www.pastraiser.com/cpu/gameboy/gameboy_opcodes.html): all the Gameboy opcodes and some usefull informations (cycles, flags).  
- [BGB](https://bgb.bircd.org): emulator and debugger, usefull to check results.  

The discord server availlable on pandocs (gbdev) is also a wonderful place to find help.