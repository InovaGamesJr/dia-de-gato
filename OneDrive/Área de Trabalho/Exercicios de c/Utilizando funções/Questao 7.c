#include <stdio.h>

int conversor(int horas, int minutos, int segundos){
  int resultado;
	horas = horas * 60;
	minutos = horas + minutos;
	resultado = segundos + (minutos * 60);
	return resultado;		
}


int main(){
  int horas, minutos, segundos;
  	printf("Informe a hora:\n");
  		scanf("%d", &horas);
  	printf("Informe os minutos:\n");
  		scanf("%d", &minutos);
  	printf("Informe os segundos:\n");
  		scanf("%d", &segundos);
  	printf("Convertendo este horario em segundos -- > %d segundos", conversor(horas,minutos,segundos));
}
