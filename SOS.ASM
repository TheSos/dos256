org 100h
mov ax,13h
int 10h
mov ax,0a000h
mov es,ax
xor bx,bx

main:
mov ah,01h
int 16h
jnz end



;mov ax, word 100
;mov bx, word 100
;mov cx, word 100
;Scall line
call segmnt
;add byte [es:bx],bl
;add bx,1
;jnz main
call vsync
jmp main

end:
mov ax,3h
int 10h
ret

vsync:
mov dx,03dah
vend:
in al,dx
and al,08h
jnz vend
vstart:
in al,dx
and al,08h
jz vstart
ret

line:
pusha
mov dx, word 320
mul dx
add bx, ax
rdtsc
and ax, word 000fh
shl ax,1
sub bx,ax
add cx,ax
add cx,ax
shr ax,1
xor ax, word 01fh
lineloop:
mov [es:bx], byte al
inc bx
dec cx
jnz lineloop
popa
ret

;
segmnt:
pusha
xor bx,bx
mov bl,byte [n]
inc bl
and bl,7h
mov byte[n],bl
mov al,byte [txt+bx]
push ax
and al, 3h
jz zerodraw
pop ax
test al,1
jne nodraw
mov ax,word [y]
mov bx, word [x]
mov dx, word 10
moreline:
mov cx, 20
call line
inc ax
dec dx
jnz moreline
nodraw:
popa
ret

zerodraw:

jmp nodraw


b:
db 10
w:
dw 320
txt:
db 3fh,3fh,2eh,0ch,2dh,3fh,3fh
n:
db 0
x:
dw 0
y: 
dw 0