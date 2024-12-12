#include <stdio.h>

float imc(float altura, float peso){
	float imc;
	imc = peso / (altura * altura);
	return imc;
}

int main(){
	float x, y;
		printf("Informe a altura em metros:\n");
			scanf("%f", &x);
		printf("Informe o peso em kg:\n");
			scanf("%f", &y);
		printf("O seu IMC e --> %.1f", imc(x, y));
			
}
