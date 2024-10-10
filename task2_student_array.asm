; ==========================
; Group member 01: Tinotenda_Chirozvi_22547747
; Group member 02: Tafara_Hwata_22565991
; Group member 03: Devan_Dewet_05169098
; ==========================


extern malloc
section .text
    global addStudent
    extern printf

addStudent:

  push rbp
    mov rbp, rsp
    sub rsp, 32  

  
    mov [rsp], rdi     
    mov [rsp + 8], esi 
    mov [rsp + 16], rdx
    movss [rsp + 24], xmm0 

    
    xor rcx, rcx      
    xor r8d, r8d        
    mov r9, rdi       

.find_highest_id:
    cmp ecx, esi
    jge .add_new_student

    mov eax, [r9]   
    test eax, eax      
    jz .add_new_student

    cmp eax, r8d
    cmovg r8d, eax      

    add r9, 72         
    inc ecx
    jmp .find_highest_id

.add_new_student:
    ; Check if we have space
    cmp ecx, esi
    jge .array_full

    ; Set new ID (highest + 1)
    inc r8d
    mov [r9], r8d

    ; Set name (next 64 bytes)
    mov rsi, [rsp + 16] 
    lea rdi, [r9 + 4]   
    mov rcx, 63         
    cld
    rep movsb
    mov byte [rdi], 0  

    ; Set GPA (last 4 bytes)
    movss xmm0, [rsp + 24]
    movss [r9 + 68], xmm0



.array_full:
    ; Clean up and return
    leave
    ret
