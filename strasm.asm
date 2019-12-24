global main

extern exit
extern printf
extern puts
extern scanf

section .text

; fastcall convention
; ecx <- first command line argument
; rdx <- second command line argument
main:
    cmp ecx, 2
    jne usage
    
    lea rcx, [fmt]
    mov rdi, qword [rdx + 8]
    cld ; Let's clear direction flag just in case
    call strlen

    mov rsi, rax
    lea rcx, [fmt_uint]
    mov rdx, rax
    call printf

    lea rcx, [scanf_msg]
    call printf
    
    sub rsp, 8
    lea rcx, [scanf_fmt]
    lea rax, [rsp + 8]
    mov rdx, rax
    call scanf
    mov cl, byte [rsp + 8]
    add rsp, 8
    mov rdx, rsi
    call strchr
    
    cmp rax, 0
    jne found
    
    lea rcx, [not_found_msg]
    call puts
    jmp continue_prg
    
    found:
    lea rcx, [found_msg]
    mov rdx, rax
    call printf

    continue_prg:
    
    
    end_prg:
    xor rax,rax
    call exit


usage:
    lea rcx, [usage_msg]
    call puts
    xor rax, rax
    call exit

; fastcall convention
; rdi <- pointer to string
strlen:
    mov rsi, rdi
    xor rax, rax
    repne scasb
    mov rax, rdi
    sub rax, rsi
    mov rdi, rsi
    dec rax
    ret

; fastcall
; cl <- searched character
; rdx <- string length
strchr:
    mov rsi, rdi
    mov al, cl
    mov rcx, rdx
    search_loop:
        scasb
        je break
        inc rbx
        loop search_loop

    xor rax, rax
    mov rdi, rsi
    ret

    break:
    mov rax, rdi
    sub rax, rsi
    mov rdi, rsi
    ret

section .data

usage_msg: db "usage: strasm <string>", 0xa, 0

fmt: db "%s", 0

fmt_uint: db "Strlen: %u", 0xa, 0

scanf_msg: db "Enter character to be found: ", 0

scanf_fmt: db "%c", 0

found_msg: db "character found at position: %u", 0xa, 0

not_found_msg: db "Character not found", 0xa, 0
