Data segment
	time dw 18			;���������� ������� 18,2 ������ � ������� (5 ������ - ��� 91 �����������)
	txt  db " ", 13,10,"$"
	cnt  dw 10			;��� �������� ��������
	trii dw 0
	SAVE_CS DW 0			;��������� ������� ����������� ����������
	SAVE_IP DW 0			;��������� �������� ����������
Data ends

code segment
start: assume cs:code, ds: data, es:stk
	mov AX, data
	mov DS, AX
;��������� ������ - ��������� �������� ����������
	mov AH, 25h			;������� ��������� �������
	mov AL, 8h			;����� �������
	int 21h				;
	mov SAVE_IP, BX			;���������� �������� � BX
	mov SAVE_CS, ES			;���������� ������� � ES

	push DS
	mov DX,offset rout		;�������� ��� ��������� � DX
	mov AX, seg rout		;�������� ������� ��������� � DS
	mov DS, AX
	mov AH, 25h			;� AH-> ������� ��������� �������
	mov AL, 8h			;� AL-> ����� �������
	int 21h				;�.�. �������� ����������
	pop DS
B:
jmp B

rout proc far
	push AX				;��������� ��� ���������� ��������
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
		call PrintNumber	;����� ��������� ������ �� ����� ����� �� AX
		mov AH, 9h
		lea DX, txt		
		int 21h
	nxt: 
	pop DX
	pop AX				;������������ ��������
	mov AL, 20h			;���������� ���������� 
	out 20h, AL			;
	iret
rout endp

PrintNumber proc			;��������� ������ ����� �� AX
	push BX				;��������� ���������� ��������� � ����, ����� ����� ������� ��
	push DX
	push SI
	push CX
	mov CX, 0			;�������������� ����
	mov BX, 10			;� BX ������� ��������� ������� ���������
loophere:				;�������� ����
	mov DX, 0			;�������� DX
	div BX				;����� �� 10
	
	push AX				;��������� � �����
	add DL, "0"			;������������ ��������� ����� � ASCII-���

	pop AX				;������ AX
	push DX				;�������� DX
	inc CX				;�������� CX �� 1
	cmp AX, 0			;��������� ��� ���� ���� �����
jnz loophere
	mov AH, 2			;DOS-������� ������ �������
loophere2:
	pop DX				;������������������ ����� �� ��������� � ������ � 
	mov AH, 02h			;������� �� �� �����
	int 21h
loop loophere2

	pop CX
	pop SI
	pop DX
	pop BX
     ret
PrintNumber endp			

codeend: 				;��������������� �������� ������
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











