#include <stdio.h>

float volume(float raio, float altura){
	float volume;
	volume = (raio * raio) * 3.141592 * altura;
	return volume;
	
}
int main(){
	float raio, altura;
	printf("Informe o raio do cilindro:\n");
		scanf("%f", &raio);
	printf("Informe a altura do cilindro:\n");
		scanf("%f", &altura);
	
	printf("O volume deste cilindro e --> %.2f", volume(raio, altura));
}
