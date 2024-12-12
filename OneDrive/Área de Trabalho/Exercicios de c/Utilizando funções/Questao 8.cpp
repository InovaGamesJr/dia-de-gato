#include <stdio.h>
#include <math.h>

float quadradop(int number){
	int raiz;
	raiz = sqrt(number);
	if(raiz * raiz != number){
		printf("Quadrado imperfeito");
	}
	else{
		printf("quadrado perfeito");
	}
}
int main(){
	int number;
	printf("Digite um numero para verificar se tal é um quadrado perfeito:\n");
		scanf("%d", &number);
	quadradop(number);
}
