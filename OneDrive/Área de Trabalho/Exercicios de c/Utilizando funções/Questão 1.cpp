#include <stdio.h>

int maior(int a, int b){
	
	if (a > b){
		return a;
	}
	else{
		if(b > a){
			return b;
		}
		else{
			return 0;
		}
	}
}
int main(){
	int a, b, c = 0;
	
		printf("Digite o 1 numero:\n");
			scanf("%d", &a);
		printf("Digite o 2 numero:\n");
			scanf("%d", &b);
		c = maior(a, b);
		if(c != 0){
			printf("O maior numero dos dois eh --> %d", c);
		}
		else{
			printf("Numeros iguais!");
		}
}	
	
