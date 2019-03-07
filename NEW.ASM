org 100h ; we start at CS:100h
push 0a000h
pop es
mov ax,13h
int 10h
xchg bp,ax ; already a trick, puts 09h into AH
mov dx,text; DX expects the adress of a $ terminated string
int 21h	; call the DOS function (AH = 09h)
loop:
in      al,60h          ;read whatever is at keyboard port; looking for ESC which is #1
dec     ax              ;if ESC, AX now 0
jz     short end   
x:
xor 	dx,dx			; reset the high word before division
mov 	bx,320			; 320 columns
mov 	ax,di			; get screen pointer in AX
div 	bx				; construct
sub ax,128
shr ax,3
sub dx,68
jc goon
inc di
goon:
shr dx,3
xchg ax,dx
mul bx
add ax,dx
mov si,ax
mov ax,[es:si]
stosb
jmp loop
end:
ret ; quit
text:
db 'SOS$'