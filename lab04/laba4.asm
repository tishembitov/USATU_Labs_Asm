Data segment
	time dw 18			;переменная таймера 18,2 сигнаа в секунду (5 секунд - это 91 прерываение)
	txt  db " ", 13,10,"$"
	cnt  dw 10			;для счетчика смещения
	trii dw 0
	SAVE_CS DW 0			;сохраняем сегмент заменяемого прерывания
	SAVE_IP DW 0			;сохраняем смещение прерывания
Data ends

code segment
start: assume cs:code, ds: data, es:stk
	mov AX, data
	mov DS, AX
;сохраняем вектор - сохраняем исходные прерывания
	mov AH, 25h			;функция получения вектора
	mov AL, 8h			;номер вектора
	int 21h				;
	mov SAVE_IP, BX			;запоминаем смещение в BX
	mov SAVE_CS, ES			;запоминаем сегмент в ES

	push DS
	mov DX,offset rout		;смещение для процедуры в DX
	mov AX, seg rout		;помещаем сегмент процедуры в DS
	mov DS, AX
	mov AH, 25h			;в AH-> функцию установки вектора
	mov AL, 8h			;в AL-> номер вектора
	int 21h				;т.е. поменяли прерывание
	pop DS
B:
jmp B

rout proc far
	push AX				;сохраняем все измененные регистры
	push DX
	dec time
	cmp time, 0
	jnz nxt
		dec cnt
		mov AX, 18
		mov time, AX

		mov AX, trii
		inc BX			;
		mov CX, 1
		add AX, CX
		jc codeend
		mov trii, AX
		call PrintNumber	;вызов процедуры вывода на экран числа из AX
		mov AH, 9h
		lea DX, txt		
		int 21h
	nxt: 
	pop DX
	pop AX				;восстановили регистры
	mov AL, 20h			;аппартаное прерывание 
	out 20h, AL			;
	iret
rout endp

PrintNumber proc			;процедура показа числа из AX
	push BX				;сохраняем содержимое регистров в стек, чтобы потом вернуть их
	push DX
	push SI
	push CX
	mov CX, 0			;инициализируем цикл
	mov BX, 10			;в BX заносим основание системы счисления
loophere:				;основной цикл
	mov DX, 0			;обнуляем DX
	div BX				;делим на 10
	
	push AX				;результат в стеке
	add DL, "0"			;конвертируем последнюю цифру в ASCII-код

	pop AX				;вернем AX
	push DX				;сохраним DX
	inc CX				;увеличим CX на 1
	cmp AX, 0			;повторяем для всех цифр числа
jnz loophere
	mov AH, 2			;DOS-функция вывода символа
loophere2:
	pop DX				;восстанавливливаем цифры от последней к первой и 
	mov AH, 02h			;выводим их на экран
	int 21h
loop loophere2

	pop CX
	pop SI
	pop DX
	pop BX
     ret
PrintNumber endp			

codeend: 				;восстанавливаем исходный вектор
	CLI
	push DS
	mov DX, SAVE_IP
	mov AX, SAVE_CS
	mov DS, AX
	mov AH, 25h
	mov AL, 1ch
	int 21h
	pop DS
	STI

mov AX, 4ch
int 21h
code ends
	
stk segment stack
		db 256 dup ("*")
stk ends

end start











