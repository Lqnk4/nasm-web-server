#include <sys/socket.h>
#include <sys/syscall.h>
#include <fcntl.h>

//x86-64        rdi   rsi   rdx   r10   r8    r9    -
int socket_syscall = SYS_socket; // 41
int af_inet = AF_INET; // 2
int sock_stream = SOCK_STREAM; // 1

int o_rdonly = O_RDONLY; // 0 

// SYS_setsockop
int sol_socket = SOL_SOCKET; // 1 socket level
int so_linger = SO_LINGER; // 13
int so_reuseaddr = SO_REUSEADDR; // 2
