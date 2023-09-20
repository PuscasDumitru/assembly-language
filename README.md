#### **Notes**

NASM version 2.14.02

#### Commands

```bash
$ nasm -f bin boot.asm -o boot.bin # create .bin file
$ nasm -f bin boot.asm -o boot.img # create a image that could be runned on the floppy disk as a SO
$ qemu-system-x86_64 boot.bin      # simple floppy disk emulator with qemu
```
