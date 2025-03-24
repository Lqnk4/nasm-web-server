%ifndef CONSTANTS
%define CONSTANTS

    ;; syscall values
    SYS_WRITE equ 1 ; int fd, const void *buf, size_t count
    SYS_CLOSE equ 3 ; int fildes
    SYS_SOCKET equ 41 ; int domain, int type, int protocol
    SYS_EXIT equ 60 ; int code
    SYS_BIND equ 49 ; int socket, const struct sockaddr *address, socklen_t address_len

    ;; SYS_SOCKET
    AF_INET equ 2
    SOCK_STREAM equ 1
    PROTO_TCP equ 6


%endif
