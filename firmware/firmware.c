#define GPIO_A_ODR (*(volatile char*)0x10000000)

#define UART_ODR (*(volatile char*)0x10000010)
#define UART_IDR (*(volatile char*)0x10000014)
#define UART_BSRR (*(volatile unsigned int*)0x10000018)
#define UART_SR (*(volatile char*)0x1000001C)
void putc(char c)
{
	UART_ODR = c;
	while(UART_SR & 0x01);
}
/*void putc(char c)
{
	int i;
	volatile int j;
	int ch = (c << 1) + (1 << 9);
	for(i = 0; i < 10; i++) //
	{
		if(ch & (1 << i))
			GPIO_A_ODR = 0xff;
		else
			GPIO_A_ODR = 0x00;
		for(j = 0; j < 9; j++)
			__asm__("nop");
			
	}
}*/
void puts(const char *s)
{
	volatile int j;
	while (*s)
	{
		putc(*s++);
	}
}

void *memcpy(void *dest, const void *src, int n)
{
	while (n) 
	{
		n--;
		((char*)dest)[n] = ((char*)src)[n];
	}
	return dest;
}




void main()
{
	volatile int i = 0;
	char message[] = "$Uryyb+Jbeyq!+Vs+lbh+pna+ernq+guvf+zrffntr+gura$gur+CvpbEI32+PCH"
			"+frrzf+gb+or+jbexvat+whfg+svar.$$++++++++++++++++GRFG+CNFFRQ!$$";
	UART_BSRR = 69; //baudrate 115200
	for (int i = 0; message[i]; i++)
		switch (message[i])
		{
		case 'a' ... 'm':
		case 'A' ... 'M':
			message[i] += 13;
			break;
		case 'n' ... 'z':
		case 'N' ... 'Z':
			message[i] -= 13;
			break;
		case '$':
			message[i] = '\n';
			break;
		case '+':
			message[i] = ' ';
			break;
		}
	//puts("Hello world!\n");
	//int i;
	/*for(i = 0; i < 8; i++)
	{
		serial_sim(1 << i);
		puts("\n");
	}*/
	while(1)
		puts(message);

	//while(1)
		//puts("Hello world \n");

;
}
