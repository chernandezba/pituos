
//Parece que no podemos usar este string porque no corresponde la direccion de compilacion
//a la direccion donde realmente se esta cargando
//char welcome[]="Hello from second stage";
extern void loader_main() {

	for (int i = 0; i < 26; i++) {
		char c;
		//c = 0x41 + i;
		if (i==0) c='S';
		else if (i==1) c='t';
		else if (i==2) c='a';
		else if (i==3) c='g';
		else if (i==4) c='e';
		else if (i==5) c='2';
		else c='.';
		//char c = welcome[i];

		asm(
			"mov %0, %%al;"
			"mov $0x0E, %%ah;"
			"int $0x10;"
			:
			: "r" (c)
		);
	}
}
