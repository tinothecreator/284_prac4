; ==========================
; Group member 01: Tinotenda_Chirozvi_22547747
; Group member 02: Tafara_Hwata_22565991
; Group member 03: Devan_Dewet_05169098
; ==========================


extern malloc
section .text
    global createStudent

createStudent:

    push rbp
    mov rbp, rsp
    push rdi
    push rsi

   
    mov rdi, 72
    extern malloc
    call malloc
    test rax, rax
    jz .allocation_failed

  
    pop rsi  
    pop rdi  
    mov [rax], edi

 
    lea rdi, [rax + 4]
    mov rcx, 63  
    cld          
    rep movsb
    mov byte [rdi], 0  

   
    movss [rax + 68], xmm0

  
    leave
    ret

.allocation_failed:
 
    xor rax, rax 
    leave
    ret