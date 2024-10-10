; ==========================
; Group member 01: Tinotenda_Chirozvi_22547747
; Group member 02: Tafara_Hwata_22565991
; Group member 03: Devan_Dewet_05169098
; ==========================

section .data

section .text
global addStudentToList
extern malloc

addStudentToList:
    push rbp
    mov rbp, rsp
    sub rsp, 32

    mov [rsp], rdi
    mov [rsp + 8], rsi
    movss [rsp + 16], xmm0

    mov rdi, 16
    call malloc
    test rax, rax
    jz .allocation_failed

    mov [rsp + 24], rax

    mov rdi, 72
    call malloc
    test rax, rax
    jz .allocation_failed

    mov rdx, [rsp + 24]
    mov [rdx], rax

    mov r12, [rsp]
    mov r12, [r12]
    xor r13d, r13d
    mov r14, r12

.traverse_list:
    test r12, r12
    jz .set_new_student

    mov r15d, [r12]
    cmp r15d, r13d
    cmovg r13d, r15d

    mov r14, r12
    mov r12, [r12 + 8]
    jmp .traverse_list

.set_new_student:
    inc r13d
    mov [rax], r13d

    mov rsi, [rsp + 8]
    lea rdi, [rax + 4]
    mov rcx, 63
    cld
    rep movsb
    mov byte [rdi], 0

    movss xmm0, [rsp + 16]
    movss [rax + 68], xmm0

    mov rdx, [rsp + 24]
    mov qword [rdx + 8], 0

    mov rcx, [rsp]
    cmp qword [rcx], 0
    jne .update_last_node

    mov [rcx], rdx
    jmp .end_function

.update_last_node:
    mov [r14 + 8], rdx

.end_function:
    leave
    ret

.allocation_failed:
    leave
    ret
