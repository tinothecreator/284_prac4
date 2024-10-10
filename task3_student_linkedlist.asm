section .data
    debug_msg db "Debug: Added student to list - ID: %d, Name: %s, GPA: %f", 10, 0
    error_msg db "Error: Memory allocation failed", 10, 0

section .text
global addStudentToList
extern malloc
extern printf
extern strlen
extern strncpy

; Function: addStudentToList
; Parameters:
;   rdi - pointer to the head of the linked list (StudentNode**)
;   rsi - pointer to the name of the new student
;   xmm0 - GPA of the new student
; Returns: void

addStudentToList:
    push rbp
    mov rbp, rsp
    sub rsp, 48  ; Allocate stack space for local variables

    ; Save parameters
    mov [rsp], rdi      ; head pointer
    mov [rsp + 8], rsi  ; name pointer
    movss [rsp + 16], xmm0 ; GPA

    ; Check if name is NULL
    test rsi, rsi
    jz .error_exit

    ; Get name length
    mov rdi, rsi
    call strlen
    mov [rsp + 24], rax ; Save name length

    ; Allocate memory for new StudentNode (16 bytes)
    mov rdi, 16
    call malloc
    test rax, rax
    jz .error_exit

    mov [rsp + 32], rax ; Save new StudentNode pointer

    ; Allocate memory for new Student (72 bytes)
    mov rdi, 72
    call malloc
    test rax, rax
    jz .error_exit

    ; rax now points to new Student struct
    mov rdx, [rsp + 32] ; Get StudentNode pointer
    mov [rdx], rax      ; Set StudentNode->student

    ; Find highest ID and last node
    mov r12, [rsp]      ; r12 = head pointer
    mov r12, [r12]      ; r12 = *head
    xor r13d, r13d      ; r13d = highest ID
    mov r14, r12        ; r14 = last node

.traverse_list:
    test r12, r12
    jz .set_new_student

    mov r15d, [r12]     ; Load current Student's ID
    cmp r15d, r13d
    cmovg r13d, r15d    ; Update highest ID if current is greater

    mov r14, r12        ; Update last node
    mov r12, [r12 + 8]  ; Move to next node
    jmp .traverse_list

.set_new_student:
    ; Set new ID (highest + 1)
    inc r13d
    mov [rax], r13d

    ; Set name (next 64 bytes)
    mov rdi, rax
    add rdi, 4          ; Destination: name field in struct
    mov rsi, [rsp + 8]  ; Source: name pointer
    mov rdx, 63         ; Max length to copy
    call strncpy
    mov byte [rax + 67], 0 ; Ensure null-termination

    ; Set GPA (last 4 bytes)
    movss xmm0, [rsp + 16]
    movss [rax + 68], xmm0

    ; Set next pointer to NULL
    mov rdx, [rsp + 32] ; Get StudentNode pointer
    mov qword [rdx + 8], 0

    ; Update list
    mov rcx, [rsp]      ; Get head pointer
    cmp qword [rcx], 0
    jne .update_last_node

    ; If list was empty, set head
    mov [rcx], rdx
    jmp .print_debug

.update_last_node:
    mov [r14 + 8], rdx

.print_debug:
    ; Debug print
    mov rdi, debug_msg
    mov esi, [rax]      ; ID
    lea rdx, [rax + 4]  ; Name
    movss xmm0, [rax + 68] ; GPA
    cvtss2sd xmm0, xmm0   ; Convert float to double for printf
    mov al, 1           ; One floating point argument
    call printf

    jmp .exit

.error_exit:
    ; Print error message
    mov rdi, error_msg
    xor eax, eax
    call printf

.exit:
    leave
    ret