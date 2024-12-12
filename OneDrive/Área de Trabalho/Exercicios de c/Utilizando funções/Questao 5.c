#include <stdio.h>

float vol(float raio){
	float V, pi = 3.141592;
	V = (4 * pi * (raio * raio * raio)) / 3;
	return V;
}

int main(){
	float raio;
	printf("Digite o valor do raio do cirulo:\n");
		scanf("%f", &raio);
	printf("Volume do circulo e -- > %.1f", vol(raio));
}
