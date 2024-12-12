#include <stdio.h>

int return_meses(int a){
	switch(a){
		case 1:
			printf("Janeiro, com 31 dias.");
			break;
		case 2:
			printf("Fevereiro, com 30 dias.");
			break;
		case 3:
			printf("marco, com 31 dias.");
			break;
		case 4:
			printf("abril, com 30 dias.");
			break;
		case 5:
			printf("maio, com 31 dias");
			break;
		case 6:
			printf("junho, com 30 dias");
			break;
		case 7:
			printf("julho, com 31 dias");
			break;
		case 8:
			printf("agosto, com 31 dias");
			break;
		case 9:
			printf("setembro, com 30 dias");
			break;
		case 10:
			printf("outubro, com 31 dias");
			break;
		case 11:
			printf("novembro, com 30 dias");
			break;
		case 12:
			printf("dezembro, com 31 dias");
			break;
	}
	return 0;
}
int main(){
	int number;
		printf("Digite um numero de 1 a 12:\n");
			scanf("%d", &number);
		if(number < 1 || number > 12){
			printf("Numero menor que 1 e maior que 12");
		}
		else{
			return_meses(number);
		}	
}