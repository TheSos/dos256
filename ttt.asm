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
xor ax,ax 
inc word [phase]
mov di,320*32
;call vsync
;mov 	ax,0x0013			; switch to video mode 13h
;int 	0x10	
call write
x:
xor ax,ax
in      al,60h          ;read whatever is at keyboard port; looking for ESC which is #1
dec     ax              ;if ESC, AX now 0
jz     short end  

xor 	dx,dx			; reset the high word before division
mov 	bx,320			; 320 columns
mov 	ax,di			; get screen pointer in AX
div 	bx				; construct X,Y from screen pointer into AX,DX
;cmp ax,128
;je y
sub 	ax,100			; subtract the origin
sub 	dx,160			; = (160,100) ... center of 320x200 screen
mov 	word [si],1	; move 100 into a memory location
fild 	word [si]
;fild 	word [si]		; 100
mov 	word [si],12	; move 16 into a memory location
fild 	word [si]		; 16 100
mov 	bx,[phase]		; 100
mov 	word [si],bx	; move 16 into a memory location
fild 	word [si]	; move 100 into a memory location
fdiv st1
;mov 	word [si],[phase]	; move 16 into a memory location
;fild 	word [si]		; 16 100
;fild 	word [time]		; 16 100
mov     [si],ax			; 
fild 	word [si]		; y 16 100
fdiv 	st2
fdiv st2				; z=y/100 16 100
fadd	st3
mov 	[si],ax			; move X into a memory location
fild 	word [si]		; X z 16 100

fdiv	st3				; x/16 z 16 100

fdiv 	st1				; x/16/z 16 100
fadd st2

fsin					; sin(x/16/z) z 16 100
;fmul 	st1				; 16*sin(x/16/z) z 16 100
mov 	[si],dx			; move Y into a memory location
fild 	word [si]		; Y 16*sin(x/16/z) 16
fdiv	st4				; y/16 16*sin(x/16/z) 16
fdiv 	st2		
fadd st3		; y/16/z 16*sin(x/16/z) 16
fsin					; sin(y/16/z) 16*sin(x/16/z) 16
fmul 	st1				; 16*sin(y/16/z) 16*sin(x/16/z) 16
fmul 	st4				; 16*sin(y/16/z)+16*sin(x/16/z) 16*sin(x/16/z) 16
fistp 	word [si]		; -
mov 	ax,[si]			; get the result from memory
mov 	cx,ax
add		ax,word 91
add cx, byte 16
;shr cx,1
mov ax,320
mul cx
;stosb
;call vline					; write to screen (DI) and increment DI
mov bx,di

vlineloop:
sub bx,ax
add bx,320*20
mov [es:bx],al
;sub bx,word 320
;dec cx
;jnz short vlineloop
inc di
jz  y
mov bx,di
cmp bx,320*130
ja y
jmp  x     ;fall through if 0, do jump somewhere else if otherwise
end:
			; next pix         ;Switch back to text mode as a convenience
        ret   


write:
pusha
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
;mov al,'a'
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
popa
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

msg:
db 'Hello World!',0
		
phase:
