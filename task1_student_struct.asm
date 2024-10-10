; ==========================
; Group member 01: Name_Surname_student-nr
; Group member 02: Name_Surname_student-nr
; Group member 03: Name_Surname_student-nr
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