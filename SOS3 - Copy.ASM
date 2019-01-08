push 	0a000h			
pop 	es				; get start of video memory in ES
mov 	al,0x13			; switch to video mode 13h
int 	0x10			; 320 * 200 in 256 colors
fninit					; -	
						; it's useful to comment what's on the
						; stack after each FPU operation
						; to not get lost ;) start is : empty (-)
X:
inc word [time]
xor 	dx,dx			; reset the high word before division
mov 	bx,320			; 320 columns
mov 	ax,di			; get screen pointer in AX
div 	bx				; construct X,Y from screen pointer into AX,DX
sub 	ax,100			; subtract the origin
sub 	dx,160			; = (160,100) ... center of 320x200 screen
mov 	word [si],1	; move 100 into a memory location
fild 	word [si]		; 100
mov 	word [si],120	; move 100 into a memory location
fild 	word [si]		; 100
mov 	word [si],12	; move 16 into a memory location
fild 	word [si]		; 16 100
;fild 	word [time]		; 16 100
mov     [si],ax			; 
fild 	word [si]		; y 16 100
fdiv 	st2				; z=y/100 16 100
fadd	st3
mov 	[si],ax			; move X into a memory location
fild 	word [si]		; X z 16 100
fdiv	st2				; x/16 z 16 100
fdiv 	st1				; x/16/z 16 100
fsin					; sin(x/16/z) z 16 100
;fmul 	st1				; 16*sin(x/16/z) z 16 100
mov 	[si],dx			; move Y into a memory location
fild 	word [si]		; Y 16*sin(x/16/z) 16
fdiv	st3				; y/16 16*sin(x/16/z) 16
fdiv 	st2				; y/16/z 16*sin(x/16/z) 16
fsin					; sin(y/16/z) 16*sin(x/16/z) 16
fmul 	st1				; 16*sin(y/16/z) 16*sin(x/16/z) 16
fmul 	st3				; 16*sin(y/16/z)+16*sin(x/16/z) 16*sin(x/16/z) 16
fistp 	word [si]		; -
mov 	ax,[si]			; get the result from memory
mov 	cx,ax
add		ax,word 91
add cx, byte 16
shr cx,1
;stosb
call vline					; write to screen (DI) and increment DI
inc di
in      al,60h          ;read whatever is at keyboard port; looking for ESC which is #1
dec     ax              ;if ESC, AX now 0
jnz     short X        ;fall through if 0, do jump somewhere else if otherwise
			; next pixel
mov     al,03           ;AX=0000 due to mainloop exit condition
        int     10h             ;Switch back to text mode as a convenience
        ret   
		
vline:
pusha
mov bx,di
vlineloop:
mov [es:bx],al
sub bx,word 320
dec cx
jnz vlineloop
popa
ret

time:
dw 0 
