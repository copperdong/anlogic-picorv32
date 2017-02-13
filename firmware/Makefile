
VLOG = iverilog
TOOLCHAIN_PREFIX = riscv32-unknown-elf-

lo.mif: firmware.S firmware.c firmware.lds rom2mif.exe
	$(TOOLCHAIN_PREFIX)gcc -Os -m32 -ffreestanding -nostdlib -o firmware.elf firmware.S firmware.c \
		-march=RV32IC --std=gnu99 -Wl,-Bstatic,-T,firmware.lds,-Map,firmware.map,--strip-debug -lgcc
	$(TOOLCHAIN_PREFIX)objcopy -O binary firmware.elf firmware.bin
	./rom2mif.exe
	$(TOOLCHAIN_PREFIX)objdump -d firmware.elf > disasm.S
	cp *.mif ../al_ip
	cp zero ../al_ip/zero.mif
	python3 makehex.py firmware.bin 1024 > firmware.hex
clean:
	rm  -f firmware.elf
	rm *.mif

rom2mif.exe:rom2mif.c
	gcc rom2mif.c -o rom2mif.exe
