
org 0x7C00 
   
bits 16      

mov si, msg
call print

mainloop:
    mov si, prompt
    call print 

    mov di, buff
    call input 

    mov si, buff
    cmp byte [si], 0 
    je mainloop

    mov si, buff
    mov di, count  
    call compare
    jc count_cmd

    mov si, invalidMsg
    call print

    jmp mainloop
    
    count_cmd:
         
         mov si, countMsg
         call print
         mov cx, 0
         
         mov di, buff
         call input 
         mov bx, buff
         
         mov [buffer], bx

         mov si, [buffer]
        
          call count_occ
          
          mov si, blank
          call print

          jmp mainloop

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
                mov [number], dx
                call int_to_string

                mov cx, 0
                mov si, [buffer]

                jmp count_occ

            .load_char:
                xor di, di
                inc cx  
                mov dx, 1
                mov [di], al
                mov [resBuffer], di
                mov si, [resBuffer]
                call print
                jmp count_occ

            .done:
                ret

         

compare:
    .loop:
        mov al, [si]
        mov bl, [di] 
        cmp al, bl 
        jne .false 

        cmp al, 0
        je .true 

        inc di 
        inc si 
        jmp .loop 
    
    .false:
        clc      
        ret 

    .true:  
        stc       
        ret


input:
    xor cl, cl                     

    .loop:
        mov ah, 0                   
        int 16h                     

        cmp al, 0x08                
        je .backspace               

        cmp al, 0x0D               
        je .done                  

        cmp cl, 0x5                 
        je .loop                   

        mov ah, 0hE
        int 10h                     

        stosb                       
        inc cl                
        jmp .loop                 
    
    .backspace:
        cmp cl, 0                 
        je .loop                   

        dec di
        mov byte [di], 0           
        dec cl                      

        mov ah, 0hE
        mov al, 0x08
        int 10h                     

        mov al, ' '
        int 10h                   

        mov al, 0x08
        int 10h                    

        jmp .loop                  
    

    .done:
        mov al, 0                  
        stosb                       
        
        mov ah, 0Eh 
        mov al, 0x0D
        int 10h         
        mov al, 0x0A
        int 10h                    
        
        ret

print:
    lodsb        

    or al, al    
    jz .done     

    mov ah, 0hE 
    int 10h 

    jmp print

    .done:
        ret


buff: times 20 db 0
buffer: times 20 db 0
resBuffer: times 20 db 0

number: dw 0
              
count: db 'count', 0

msg: db 'OS', 0x0D, 0x0A, 0x0D, 0x0A, 0
prompt: db '>', 0 
helpMsg: db 'Valid commands: help, about, count, box', 0x0D, 0x0A, 0
invalidMsg: db 'There is no such command, type help to see the available ones', 0x0D, 0x0A, 0
aboutMsg: db ' Final OS', 0x0D, 0x0A, 0
countMsg: db 'Type a string: ', 0x0D, 0x0A, 0
blank: db ' ', 0x0D, 0x0A, 0

times 1022-($-$$) db 0
dw 0xaa55