#include <iostream>
#include <conio.h>
using namespace std;
void main()
{
	char symbol;
	char string[100];
	char result[4];
	int leng;
	setlocale(0, "RUS");
	cout << "Введите строку:" << endl;
	cin >> string + 1; //вводим строку в которой искать
	leng = strlen(string);
	cout << "Введите искомый символ" << endl;
	cin >> symbol;
	_asm
	{
		lea esi, [string + 1]
		mov bl, symbol
		mov ecx, leng
		dec ecx
		mov al, [esi]; запишем первый символ строки после последнего
		mov[esi + ecx], al
		mov al, [esi + ecx - 1]
		mov[esi - 1], al; а последний - после первого
		_go :
		lodsb
			cmp bl, al
			jne _one

			push ecx
			mov [esi-1],' '
			mov eax, [esi-2]; если найден символ, равный заданному
			and eax, 0ffffffh; 
			mov dword ptr result, eax; лишний обнуляем и записываем в переменную
	}
	cout << result;
	_asm
	{
		pop ecx
		_one : ; продолжаем цикл
		loop _go
	}
}
