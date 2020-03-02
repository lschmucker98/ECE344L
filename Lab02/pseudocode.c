#include <stdio.h> //default library to include functions

int dotproduct(int num1[], int num2[]); //in C we declare what functions will be used before the main program
int average(int num3[]);

int main() { //same as .global main and main:
	int Vector1[] = { -6,2,-4,9,5,18 };
	int Vector2[] = { -11,15,7,-8,13,20 }; //Same as .data section declaring my vector
	int avgVector1;
	int avgVector2;	//initiliazing parameters to use throughout my code, similar to t/s registers
	int dot;

	dot = dotproduct(Vector1, Vector2);
	avgVector1 = average(Vector1);	//store our final values for display
	avgVector2 = average(Vector2);	//similar to outputting to s/v registers 

	printf("The dot product is %d\n", dot);
	printf("The average of vector one is %d\n", avgVector1); //output our values 
	printf("The average of vector two is %d\n", avgVector2); //to confirm our code works

	return 0;
}

int dotproduct(int num1[], int num2[]) {
	int dotres = 0;
	for (int i = 0; i < 6; i++) {
		dotres += num1[i] * num2[i]; //loop over each element in each vector
	}									//and multiplying them then adding them to current sum
	return dotres; //returning values to main register kindof like jr ra
}

int average(int num3[]) {
	int avgres = 0;
	int sumres = 0;
	for (int i = 0; i < 6; i++) {
		sumres = sumres + num3[i];	//looping over each vector and taking a sum and average
	}
	avgres = (int)sumres / 6;
	return avgres;
}