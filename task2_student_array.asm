; ==========================
; Group member 01: Name_Surname_student-nr
; Group member 02: Name_Surname_student-nr
; Group member 03: Name_Surname_student-nr

; ==========================
section .data
    debug_msg db "Debug: Added student - ID: %d, Name: %s, GPA: %f", 10, 0


extern malloc
section .text
    global addStudent
    extern printf

addStudent:

  push rbp
    mov rbp, rsp
    sub rsp, 32  ; Allocate stack space for local variables

    ; Save parameters
    mov [rsp], rdi      ; array pointer
    mov [rsp + 8], esi  ; max size
    mov [rsp + 16], rdx ; name pointer
    movss [rsp + 24], xmm0 ; GPA

    ; Find the highest ID and next available position
    xor rcx, rcx        ; rcx = current index
    xor r8d, r8d        ; r8d = highest ID
    mov r9, rdi         ; r9 = current struct pointer

.find_highest_id:
    cmp ecx, esi
    jge .add_new_student

    mov eax, [r9]       ; Load current struct's ID
    test eax, eax       ; If ID is 0, we've found an empty slot
    jz .add_new_student

    cmp eax, r8d
    cmovg r8d, eax      ; Update highest ID if current is greater

    add r9, 72          ; Move to next struct (72 bytes per struct)
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
    mov rsi, [rsp + 16] ; Source: name pointer
    lea rdi, [r9 + 4]   ; Destination: name field in struct
    mov rcx, 63         ; Copy up to 63 characters
    cld
    rep movsb
    mov byte [rdi], 0   ; Null-terminate the string

    ; Set GPA (last 4 bytes)
    movss xmm0, [rsp + 24]
    movss [r9 + 68], xmm0

    ; Debug print
    mov rdi, debug_msg
    mov esi, [r9]       ; ID
    lea rdx, [r9 + 4]   ; Name
    movss xmm0, [r9 + 68] ; GPA
    cvtss2sd xmm0, xmm0   ; Convert float to double for printf
    mov al, 1           ; One floating point argument
    call printf

.array_full:
    ; Clean up and return
    leave
    ret
