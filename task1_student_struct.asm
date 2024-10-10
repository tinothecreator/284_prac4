; ==========================
; Group member 01: Name_Surname_student-nr
; Group member 02: Name_Surname_student-nr
; Group member 03: Name_Surname_student-nr
; ==========================

extern malloc
section .text
    global createStudent

createStudent:
    ; Preserve required registers
    push rbp
    mov rbp, rsp
    push rdi
    push rsi

    ; Allocate memory for the Student struct (72 bytes)
    mov rdi, 72
    extern malloc
    call malloc
    test rax, rax
    jz .allocation_failed

    ; Set id (first 4 bytes)
    pop rsi  ; Retrieve name pointer
    pop rdi  ; Retrieve id
    mov [rax], edi

    ; Set name (next 64 bytes)
    lea rdi, [rax + 4]
    mov rcx, 63  ; Copy up to 63 characters to leave room for null terminator
    cld          ; Clear direction flag (ensure we're moving forward)
    rep movsb
    mov byte [rdi], 0  ; Null-terminate the string

    ; Set gpa (last 4 bytes)
    movss [rax + 68], xmm0

    ; Return the pointer to the struct
    leave
    ret

.allocation_failed:
    ; Handle allocation failure (you might want to add error handling)
    xor rax, rax  ; Return NULL
    leave
    ret