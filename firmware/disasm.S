
firmware.elf：     文件格式 elf32-littleriscv


Disassembly of section .memory:

00000000 <putc-0x14>:
   0:	0000                	unimp
   2:	0000                	unimp
   4:	00000137          	lui	sp,0x0
   8:	40010113          	addi	sp,sp,1024 # 400 <end+0x2f4>
   c:	0c0000ef          	jal	cc <main>
  10:	00100073          	ebreak

00000014 <putc>:
  14:	ff010113          	addi	sp,sp,-16
  18:	00000793          	li	a5,0
  1c:	100006b7          	lui	a3,0x10000
  20:	00100813          	li	a6,1
  24:	00900593          	li	a1,9
  28:	00a00613          	li	a2,10
  2c:	40f55733          	sra	a4,a0,a5
  30:	00177713          	andi	a4,a4,1
  34:	02070263          	beqz	a4,58 <putc+0x44>
  38:	01068023          	sb	a6,0(a3) # 10000000 <end+0xffffef4>
  3c:	00012623          	sw	zero,12(sp)
  40:	00c12703          	lw	a4,12(sp)
  44:	00e5de63          	ble	a4,a1,60 <putc+0x4c>
  48:	00178793          	addi	a5,a5,1
  4c:	fec790e3          	bne	a5,a2,2c <putc+0x18>
  50:	01010113          	addi	sp,sp,16
  54:	00008067          	ret
  58:	00068023          	sb	zero,0(a3)
  5c:	fe1ff06f          	j	3c <putc+0x28>
  60:	00000013          	nop
  64:	00c12703          	lw	a4,12(sp)
  68:	00170713          	addi	a4,a4,1
  6c:	00e12623          	sw	a4,12(sp)
  70:	fd1ff06f          	j	40 <putc+0x2c>

00000074 <puts>:
  74:	ff010113          	addi	sp,sp,-16
  78:	00812423          	sw	s0,8(sp)
  7c:	00112623          	sw	ra,12(sp)
  80:	00050413          	mv	s0,a0
  84:	00044503          	lbu	a0,0(s0)
  88:	00051a63          	bnez	a0,9c <puts+0x28>
  8c:	00c12083          	lw	ra,12(sp)
  90:	00812403          	lw	s0,8(sp)
  94:	01010113          	addi	sp,sp,16
  98:	00008067          	ret
  9c:	00140413          	addi	s0,s0,1
  a0:	f75ff0ef          	jal	14 <putc>
  a4:	fe1ff06f          	j	84 <puts+0x10>

000000a8 <memcpy>:
  a8:	00c587b3          	add	a5,a1,a2
  ac:	00c50633          	add	a2,a0,a2
  b0:	fff60613          	addi	a2,a2,-1
  b4:	00f59463          	bne	a1,a5,bc <memcpy+0x14>
  b8:	00008067          	ret
  bc:	fff7c703          	lbu	a4,-1(a5)
  c0:	fff78793          	addi	a5,a5,-1
  c4:	00e60023          	sb	a4,0(a2)
  c8:	fe9ff06f          	j	b0 <memcpy+0x8>

000000cc <main>:
  cc:	ff010113          	addi	sp,sp,-16
  d0:	00812423          	sw	s0,8(sp)
  d4:	00912223          	sw	s1,4(sp)
  d8:	00112623          	sw	ra,12(sp)
  dc:	05500493          	li	s1,85
  e0:	0aa00413          	li	s0,170
  e4:	00048513          	mv	a0,s1
  e8:	f2dff0ef          	jal	14 <putc>
  ec:	00040513          	mv	a0,s0
  f0:	f25ff0ef          	jal	14 <putc>
  f4:	ff1ff06f          	j	e4 <main+0x18>
  f8:	3a434347          	fmsub.d	ft6,ft6,ft4,ft7,rmm
  fc:	2820                	fld	fs0,80(s0)
  fe:	29554e47          	fmsub.s	ft8,fa0,fs5,ft5,rmm
 102:	3620                	fld	fs0,104(a2)
 104:	312e                	fld	ft2,232(sp)
 106:	302e                	fld	ft0,232(sp)
 108:	0000                	unimp
	...
