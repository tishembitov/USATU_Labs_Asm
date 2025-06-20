assume	cs:code,ds:data, es:stk
	data	segment			
mas1	dw	5 dup (?)
mas2	dw	5 dup (?)
mes1		db	0ah,0dh,'Massiv(summa)- ','$'
mes2		db	0ah,0dh,'Massiv(raznost)- ','$'
mes3		db	0ah,0dh,'Massiv(proizvedenie)- ','$'
mes4		db	0ah,0dh,'Massiv(chastnoe)- ','$'
e		dw	9h
i		dw	1h
tmp		db	0
abz		dw	' ','$'
	data	ends	

code	segment	
prep proc near
	mov i,1h
	mov e,9h
	mov  ax,data		
	mov  ds,ax		
	xor ax,ax
	xor bx,bx  
	mov	SI,0
	mov     CX,5  
 go:
	mov bx,i
	mov mas1[si],bx
	mov ax,e
	mov mas2[si],ax
	inc i
	inc e
	inc si
	inc si
LOOP    go 
	ret  

prep endp
add_proc proc near
	mov si,0
	mov    cx,5
sum:
	mov bx,mas1[si]
	mov ax,mas2[si]
	add ax,bx
	mov mas1[si],ax
	inc si
	inc si
loop	sum
	ret
add_proc endp


sub_proc proc near
.....
....
...
sub_proc endp


div_proc proc near
	mov si,0
	mov    cx,5
del:
	xor dx,dx
	mov bx,mas1[si]
	mov ax,mas2[si]
	div bl
	mov dl,al
	mov mas1[si],dx
	inc si
	inc si
loop	del
	ret
div_proc endp


mul_proc proc near
....
...
..
mul_proc endp


outp proc near
	mov si,0
	mov cx,5
show:
	mov ax,mas1[si]
	mov dl,10
	div dl
	mov tmp,ah
	mov dl,al
	add dl,30h
	mov ah,02h
	int 21h
	mov dl,tmp
	add dl,30h
	mov ah,02h
	int 21h
	inc si
	inc si
	mov ah,09h
	lea dx,abz
	int 21h
loop show
	ret
outp endp


outp2 proc near
	mov si,0
	mov cx,5
show2:
	mov ax,mas2[si]
	mov dl,10
	div dl
	mov tmp,ah
	mov dl,al
	add dl,30h
	mov ah,02h
	int 21h
	mov dl,tmp
	add dl,30h
	mov ah,02h
	int 21h
	inc si
	inc si
	mov ah,09h
	lea dx,abz
	int 21h
loop show2
	ret
outp2 endp


begin:	
	call prep
	call outp
	call outp2
        mov  ah,09h
	lea  dx,mes1
	int  21h
	call add_proc
	call outp
	call prep
	mov ah,09h
	lea  dx,mes2
	int   21h
	call sub_proc
	call outp
	call prep
    	mov  ah,09h
	lea  dx,mes3
	int   21h
call mul_proc
call outp
call prep
mov ah,09h
lea  dx,mes4
int  21h
call div_proc
call outp
	int 21h		
	mov  ax,4c00h	
	int  21h	
code	ends	
	

stk  segment  stack	
	db  256 dup('*')
stk  ends		


end  begin
