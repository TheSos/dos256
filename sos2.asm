
	mov ax,13h
	int 10h

main:
	mov ax,1
	int 16h
	jnz end
	jmp main
	

end:
	mov ax,3h
	int 10h
	ret