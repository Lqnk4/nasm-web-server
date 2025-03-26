%include "src/constants.s"

section .data
    struc sockaddr_in
        .sin_family resw 1  ; AF_INET
        .sin_port resw 1    ; Port number
        .sin_addr resd 1    ; IPv4 address
        .sin_padding  resq 1
    endstruc

    socket dq 0
    one_constant dw 1
    socket_address istruc sockaddr_in
        at sockaddr_in.sin_family, dw AF_INET
        at sockaddr_in.sin_port, dw 8080
        at sockaddr_in.sin_addr, db 127,0,0,1
        at sockaddr_in.sin_padding, dq 0
    iend
    socket_address_len equ $ - socket_address

    client dq 0

    bufflen equ 512
    reqbuff times bufflen db 0
    retbuff times bufflen db 0

    index db "src/html/index.html",0

    init_text   db "Starting up nasm-web-server, ...",10,0
    init_textLen equ $ - init_text

section .bss

section .text

global _start
_start:
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
    cmp rax, 0
    jle close_server
    mov [socket], rax   ;; cache socket fd
    mov r12, rax        ;; leave fd in r12 as well

    mov rax, SYS_SETSOCKOPT    
    mov rdi, r12
    mov rsi, SOL_SOCKET
    mov rdx, SO_REUSEADDR
    mov r10, one_constant   ;; requires a pointer
    mov r8, dword 32 ;; min option length
    syscall
    cmp rax, 0
    jne close_server


    ;; htons(socket_address.sin_port)
    mov bx, [socket_address + sockaddr_in.sin_port]
    xchg bl, bh
    mov [socket_address + sockaddr_in.sin_port], bx

    mov rax, SYS_BIND
    mov rdi, r12
    mov rsi, socket_address
    mov rdx, socket_address_len
    syscall
    cmp rax, 0
    jne close_server

socket_listen:
    mov rax, SYS_LISTEN
    mov rdi, r12
    mov rsi, 8  ; max connections in listener queue
    syscall

accept_loop:
    mov rax, SYS_ACCEPT
    mov rdi, r12
    mov rsi, 0
    syscall
    cmp rax, 0
    jle close_server
    mov [client], rax ;; cache client fd
    mov r13, rax

.read_header:
    mov rax, SYS_READ
    mov rdi, r13
    mov rsi, reqbuff
    mov rdx, bufflen
    syscall
    cmp rax, 0
    jle close_server

    ;; doesn't parse the request for now

.read_html:
    mov rax, SYS_OPEN
    mov rdi, index
    mov rsi, O_RDONLY
    syscall
    cmp rax, 0
    jle close_server
    mov r14, rax        ;; index.html fd

    mov rax, SYS_READ
    mov rdi, r14,
    mov rsi, retbuff
    mov rdx, bufflen
    syscall
    cmp rax, 0
    jle close_server

.write_socket:
    mov rdx, rax        ;; write only the numer of bytes read from index
    mov rax, SYS_WRITE
    mov rdi, r13
    mov rsi, retbuff
    syscall
    cmp rax, 0
    jle close_server

.close_client:
    mov rax, SYS_CLOSE
    mov rdi, r13
    syscall
    cmp rax, 0
    jne close_server

.close_html:
    mov rax, SYS_CLOSE
    mov rdi, r14
    syscall
    cmp rax, 0
    jne close_server

    jmp accept_loop


close_server:
    mov rax, SYS_CLOSE
    mov rdi, [socket]   ;; use cached fd for redundency
    syscall
    cmp rax, 0
    jne _exit
    xor rax, rax    ;; zero rax for successful exit

_exit:
    mov rdi, rax
    mov rax, SYS_EXIT
    syscall

