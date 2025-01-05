/* See COPYRIGHT for copyright information. */

#include <inc/mmu.h>
#include <inc/memlayout.h>
#include <inc/trap.h>
#include <kern/macro.h>

#include <kern/picirq.h>

#ifdef CONFIG_KSPACE

.globl clock_thdlr
.type clock_thdlr, @function
clock_thdlr:
    call save_trapframe_trap
    # Set trap code for trapframe
    movl $(IRQ_OFFSET + IRQ_CLOCK), 136(%rsp)
    call trap
    jmp .

.globl timer_thdlr
.type timer_thdlr, @function
timer_thdlr:
    call save_trapframe_trap
    # Set trap code for trapframe
    movl $(IRQ_OFFSET + IRQ_TIMER), 136(%rsp)
    call trap
    jmp .

#else

# TRAPHANDLER defines a globally-visible function for handling a trap.
# It pushes a trap number onto the stack, then jumps to _alltraps.
# Use TRAPHANDLER for traps where the CPU automatically pushes an error code.
#
# You shouldn't call a TRAPHANDLER function from C, but you may
# need to _declare_ one in C (for instance, to get a function pointer
# during IDT setup).  You can declare the function with
#   void NAME();
# where NAME is the argument passed to TRAPHANDLER.

#define TRAPHANDLER(name, num) \
.globl name;                   \
.type name, @function;         \
.align 2;                      \
name:                          \
    pushq $(num);              \
    jmp _alltraps

# Use TRAPHANDLER_NOEC for traps where the CPU doesn't push an error code.
# It pushes a 0 in place of the error code, so the trap frame has the same
# format in either case.

#define TRAPHANDLER_NOEC(name, num) \
.globl name;                        \
.type name, @function;              \
.align 2;                           \
name:                               \
    pushq $0;                       \
    pushq $(num);                   \
    jmp _alltraps

.text

.globl _alltraps
.type _alltraps, @function;
.align 2
_alltraps:
    # LAB 8: Your code here
    # Complete `struct Trapframe' on stack
    # NOTE: Members after tf_paddind4 already on stack.
    #       For struct PushRegs you can use PUSHA macro.
    subq $16,%rsp
    movw %ds,8(%rsp)
    movw %es,(%rsp)
    PUSHA
    # LAB 8: Your code here
    # Invoke `trap' with a pointer to struct trap as an argument.
    movl $GD_KD,%eax
    movw %ax,%ds
    movw %ax,%es
    movq %rsp, %rdi
    call trap
    jmp .

# LAB 8: Your code here
# Use TRAPHANDLER or TRAPHANDLER_NOEC to setup
# all trap handlers' entry points
# (Look up their list in inc/trap.h)
#define H(N) handler##N
#define TRP(N) TRAPHANDLER(H(N), N)
#define TRPNOEC(N) TRAPHANDLER_NOEC(H(N), N)
TRPNOEC(0) # T_DIVIDE
TRPNOEC(1) # T_DEBUG
TRPNOEC(2) # T_NMI
TRPNOEC(3) # T_BRKPT
TRPNOEC(4) # T_OFLOW
TRPNOEC(5) # T_BOUND
TRPNOEC(6) # T_ILLOP
TRPNOEC(7) # T_DEVICE
TRP(8)    # T_DBLFLT
TRP(10)   # T_TSS
TRP(11)   # T_SEGNP
TRP(12)   # T_STACK
TRP(13)   # T_GPFLT
TRP(14)   # T_PGFLT
TRPNOEC(16) # T_FPERR
TRP(17)    # T_ALIGN
TRPNOEC(18) # T_MCHK
TRPNOEC(19) # T_SIMDERR
TRPNOEC(32) # IRQ_OFFSET + IRQ_CLOCK
TRPNOEC(40) # IRQ_OFFSET + IRQ_TIMER
TRPNOEC(33) # IRQ_OFFSET + IRQ_KBD
TRPNOEC(36) # IRQ_OFFSET + IRQ_SERIAL
TRPNOEC(48) # syscall
#endif
