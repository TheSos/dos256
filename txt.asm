org 100h
mov ax,13h
int 10h

;set the cursor position to the center of the screen
;the screen is assumed to be 25 rows by 80 columns
;so the middle coordinate is 12 x 40
xor ax,ax
mov ah, 2
mov bh, 0
mov dh, 2
mov dl, 3
int 10h
;puts letter ‘a’ with color blue and background color red

mov si,msg

teletype:
mov ah, 9
mov bh,0
mov bl, 41h
mov cx, 1

lodsb
cmp al,byte 0
je endd
int 10h
mov ah, 02h
mov bh, 00h
mov bl,0
inc dl
cmp dl,40
jg endd
int 10h
jmp teletype
endd:
ret

msg:
db 'Hello World!',0