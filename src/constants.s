%ifndef CONSTANTS
%define CONSTANTS

    ;; syscalls
    SYS_READ equ 0 ; unsigned int fd, char* buf, size_t count
    SYS_WRITE equ 1 ; int fd, const void *buf, size_t count
    SYS_OPEN equ 2 ; const char *pathname, int flags, ...
    SYS_CLOSE equ 3 ; int fildes
    SYS_SOCKET equ 41 ; int domain, int type, int protocol
    SYS_ACCEPT equ 43 ; int socket, struct sockaddr *restrict address, socklen_t * restrict address_len
    SYS_BIND equ 49 ; int socket, const struct sockaddr *address, socklen_t address_len
    SYS_LISTEN equ 50 ; int socket, int backlog
    SYS_SETSOCKOPT equ 54 ; int socket, int level, int option_name, const void *option_value, socklen_t option_len
    SYS_EXIT equ 60 ; int code

    ;; SYS_OPEN
    O_RDONLY equ 0

    ;; SYS_SOCKET
    AF_INET equ 2
    SOCK_STREAM equ 1
    PROTO_TCP equ 6


%endif
