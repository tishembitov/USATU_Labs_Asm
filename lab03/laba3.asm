.model small
.stack 100h
.data
	string db 255
.code
FindEndOfString proc
	mov si, 1
count:
	inc si
	cmp string[si], 0dh
	jne count
	sub si, 1
	ret
FindEndOfString endp
DeleteSpace proc
notEnd:
	mov al, string[si+1]
	mov string[si], al
	inc si
	cmp string[si-1], 0dh
	jne notEnd	
	mov string[si], '$'
	ret
DeleteSpace endp	
main:
	mov ax, @data
	mov ds, ax
 
	mov ah, 0ah
	lea dx, string
	int 21h
; new line	
	mov dl,10
	mov ah,2
	int 21h
; end new line
	call FindEndOfString
run:
	cmp string[si], ' '
	je delete
	jne continue
delete:
	mov cx, si 
	call DeleteSpace
	mov si, cx
continue:
	dec si
	cmp si, 1
	jne run
 
	mov dx, offset string+2
	mov ah, 09h
	int 21h
 
	mov ah, 4ch
	int 21h
end main
