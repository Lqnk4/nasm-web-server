%include "src/constants.s"

section .data
    struc sockaddr
        .sa_family resw 1
        .sa_port resw 1
        .sa_data resd 1
    endstruc

    socket_address istruc sockaddr
        at sockaddr.sa_family, dw AF_INET
        at sockaddr.sa_port, dw 0
        at sockaddr.sa_data, dd 0
    iend
    socket_address_len equ $ - socket_address


    init_text   db "Starting up nasm-web-server, ...",10
    init_textLen equ $ - init_text

section .bss
    socket resq 0

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
    mov rax, SYS_BIND
    mov rdi, [socket]
    mov rsi, [socket_address]
    mov rdx, socket_address_len
    syscall


close_socket:
    mov rax, SYS_CLOSE
    mov rdi, [socket]
    syscall

exit:
    mov rax, SYS_EXIT
    mov rdi, 0
    syscall

