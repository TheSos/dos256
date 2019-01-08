org 100h
push 	0a000h			
pop 	es				; get start of video memory in ES
mov 	al,0x13			; switch to video mode 13h
int 	0x10			; 320 * 200 in 256 colors
fninit					; -	
						; it's useful to comment what's on the
						; stack after each FPU operation
						; to not get lost ;) start is : empty (-)
y:
in      al,60h          ;read whatever is at keyboard port; looking for ESC which is #1
dec     ax              ;if ESC, AX now 0
jz     short end   
inc word [phase]
x:
xor 	dx,dx			; reset the high word before division
mov 	bx,320			; 320 columns
mov 	ax,di			; get screen pointer in AX
div 	bx				; construct X,Y from screen pointer into AX,DX
;sub 	ax,100			; subtract the origin
;sub 	dx,160			; = (160,100) ... center of 320x200 screen
xor cx,cx

mov bx,dx
and bx,word 0fh
mov cl,byte [sintable+bx]
mov bx,ax
and bx,word 0fh
xor ax,ax
mov al,byte [sintable+bx]
;add al,16
mul cx
shr ax,12
mov cx,ax
inc cx
add ax,38h
;stosb
;call vline					; w	rite to screen (DI) and increment DI
mov bx,di
vlineloop:
mov [es:bx],al
sub bx,word 320
dec cx
jnz short vlineloop
inc di
jnz short x
jmp short y     ;fall through if 0, do jump somewhere else if otherwise
end:
			; next pix         ;Switch back to text mode as a convenience
ret
	
sintable db 128, 176, 218, 246, 255, 246, 218, 176, 127, 79, 37, 9, 0, 9, 37, 79,

phase:
