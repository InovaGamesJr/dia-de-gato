#include <stdio.h>

float conversor(float f){
	float c;
	c = (f - 32.0) * (5.0/9.0);
	return c;
}
int main(){
	float f;
	printf("Digite a temperatura em fahr:\n");
		scanf("%f", &f);
	printf("o valor em graus e %.1f", conversor(f));
}