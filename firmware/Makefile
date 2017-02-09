
VLOG = iverilog
TOOLCHAIN_PREFIX = /opt/riscv32i/bin/riscv32-unknown-elf-

lo.mif: firmware.S firmware.c firmware.lds
	$(TOOLCHAIN_PREFIX)gcc -Os -m32 -march=RV32IC -ffreestanding -nostdlib -o firmware.elf firmware.S firmware.c \
		 --std=gnu99 -Wl,-Bstatic,-T,firmware.lds,-Map,firmware.map,--strip-debug -lgcc
	$(TOOLCHAIN_PREFIX)objcopy -O binary firmware.elf firmware.bin
	./rom2mif
	$(TOOLCHAIN_PREFIX)objdump -d firmware.elf > disasm.S
	cp *.mif ../al_ip
	python3 makehex.py firmware.bin 1024 > firmware.hex
clean:
	rm firmware.elf
	rm *.mif

