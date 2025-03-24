%include "src/constants.s"

section .data
    struc sockaddr_in
        .sin_family resw 1  ; AF_INET
        .sin_port resw 1    ; Port number
        .sin_addr resd 1    ; IPv4 address
    endstruc

    socket dq 0
    socket_address istruc sockaddr_in
        at sockaddr_in.sin_family, dw AF_INET
        at sockaddr_in.sin_port, dw 8080
        at sockaddr_in.sin_addr, dd 0
    iend
    socket_address_len equ $ - socket_address


    init_text   db "Starting up nasm-web-server, ...",10
    init_textLen equ $ - init_text

section .bss

section .text

global _start
_start:

init_message:
    mov rax, SYS_WRITE
    mov rdi, 1
    mov rsi, init_text
    mov rdx, init_textLen
    syscall

create_socket:
    mov rax, SYS_SOCKET
    mov rdi, AF_INET
    mov rsi, SOCK_STREAM
    mov rdx, PROTO_TCP
    syscall
    mov [socket], rax ;; store socket fd

bind_socket:
    ;; htonl(sin_port)
    mov bx, [socket_address + sockaddr_in.sin_port]
    xchg bl, bh
    mov [socket_address + sockaddr_in.sin_port], bx

    mov rax, SYS_BIND
    mov rdi, [socket]
    mov rsi, [socket_address]
    mov rdx, socket_address_len
    syscall

listen:
    mov rax, SYS_LISTEN
    mov rdi, [socket]
    mov rsi, 8
    syscall

close_socket:
    mov rax, SYS_CLOSE
    mov rdi, [socket]
    syscall

exit:
    mov rax, SYS_EXIT
    mov rdi, 0
    syscall

