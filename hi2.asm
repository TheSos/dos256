org 100h
xor ax, ax 
mov es, ax
 xor bh, bh 
 mov bp, msg 
 mov ah, 13h
 mov bl, [foreground]
  mov al, 1 
  mov cx, [msg_length]
   mov dh, [msg_y] 
   mov dl, [msg_x] 
   int 10h
    ret 
    foreground:dw 0ah
    msg: db 'Beep Boop Meow' 
    msg_length: dw $-msg 
    msg_x: dw 5
     msg_y: dw 2 

