
org 0x7C00   
bits 16  


	  mov cx, 0
	 
	  mov bx, s
	  mov [buffer], bx
	  
	  mov si, [buffer]
	  call count_occ

	  ret

int_to_string:

	mov ax, [number]
	mov cx, 0
    mov bx, 10
	
	.compute_digits:
	    mov dx, 0
	    div bx 

	    push ax
	    add dl, '0'                    

	    pop ax                          
	    push dx                         
	    inc cx                          
	    cmp ax, 0                       
	jnz .compute_digits

	    
	    mov ah, 2                     
	.print_digits:
	    
	    pop dx    
	    mov [resBuffer], dx 
	   
	    mov si, resBuffer
	    call print
	                          
	    loop .print_digits

	    ret


count_occ:
    lodsb        
    
    or al, al    
    jz .done     

    mov ah, 0hE 

    cmp cx, 0
    je .load_char

    cmp al, [di]
    jne .store_result
    inc dx
    jmp count_occ
    
   	.store_result:
   	    add [buffer], dx
   		mov [resBuffer], di
   		mov si, [resBuffer]
   		call print

   		mov [number], dx
   		call int_to_string

   		mov cx, 0
   		mov si, [buffer]

	    jmp count_occ

	.load_char:
    	inc cx	
    	mov dx, 1
    	mov [di], al
    	jmp count_occ

    .done:
        ret



buffer: times 20 db 0
resBuffer: times 20 db 0

asz: db "fizz"
s: db "sdfsdfsd"
number:	dw 0

times 510-($-$$) db 0
dw 0xaa55