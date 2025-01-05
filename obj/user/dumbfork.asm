
obj/user/dumbfork:     file format elf64-x86-64


Disassembly of section .text:

0000000000800000 <__text_start>:
.globl _start
_start:
    # See if we were started with arguments on the stack

#ifndef CONFIG_KSPACE
    movabs $USER_STACK_TOP, %rax
  800000:	48 b8 00 70 ff ff 7f 	movabs $0x7fffff7000,%rax
  800007:	00 00 00 
    cmpq %rax, %rsp
  80000a:	48 39 c4             	cmp    %rax,%rsp
    jne args_exist
  80000d:	75 04                	jne    800013 <args_exist>

    # If not, push dummy argc/argv arguments.
    # This happens when we are loaded by the kernel,
    # because the kernel does not know about passing arguments.
    # Marking argc and argv as zero.
    pushq $0
  80000f:	6a 00                	push   $0x0
    pushq $0
  800011:	6a 00                	push   $0x0

0000000000800013 <args_exist>:

args_exist:
    movq 8(%rsp), %rsi
  800013:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
    movq (%rsp), %rdi
  800018:	48 8b 3c 24          	mov    (%rsp),%rdi
    xorl %ebp, %ebp
  80001c:	31 ed                	xor    %ebp,%ebp
    call libmain
  80001e:	e8 8e 01 00 00       	call   8001b1 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <dumbfork>:
        sys_yield();
    }
}

envid_t
dumbfork(void) {
  800025:	f3 0f 1e fa          	endbr64
  800029:	55                   	push   %rbp
  80002a:	48 89 e5             	mov    %rsp,%rbp
  80002d:	53                   	push   %rbx
  80002e:	48 83 ec 08          	sub    $0x8,%rsp

/* This must be inlined. Exercise for reader: why? */
static inline envid_t __attribute__((always_inline))
sys_exofork(void) {
    envid_t ret;
    asm volatile("int %2"
  800032:	b8 09 00 00 00       	mov    $0x9,%eax
  800037:	cd 30                	int    $0x30
  800039:	89 c3                	mov    %eax,%ebx
     * The kernel will initialize it with a copy of our register state,
     * so that the child will appear to have called sys_exofork() too -
     * except that in the child, this "fake" call to sys_exofork()
     * will return 0 instead of the envid of the child. */
    envid = sys_exofork();
    if (envid < 0)
  80003b:	85 c0                	test   %eax,%eax
  80003d:	78 4e                	js     80008d <dumbfork+0x68>
        panic("sys_exofork: %i", envid);
    if (envid == 0) {
  80003f:	74 79                	je     8000ba <dumbfork+0x95>
        return 0;
    }

    /* We're the parent.
     * Eagerly lazily copy our entire address space into the child. */
    sys_map_region(0, NULL, envid, NULL, MAX_USER_ADDRESS, PROT_ALL | PROT_LAZY | PROT_COMBINE);
  800041:	41 b9 ff 0f 00 00    	mov    $0xfff,%r9d
  800047:	49 b8 00 00 00 00 80 	movabs $0x8000000000,%r8
  80004e:	00 00 00 
  800051:	b9 00 00 00 00       	mov    $0x0,%ecx
  800056:	89 c2                	mov    %eax,%edx
  800058:	be 00 00 00 00       	mov    $0x0,%esi
  80005d:	bf 00 00 00 00       	mov    $0x0,%edi
  800062:	48 b8 9f 13 80 00 00 	movabs $0x80139f,%rax
  800069:	00 00 00 
  80006c:	ff d0                	call   *%rax

    /* Start the child environment running */
    if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  80006e:	be 02 00 00 00       	mov    $0x2,%esi
  800073:	89 df                	mov    %ebx,%edi
  800075:	48 b8 df 14 80 00 00 	movabs $0x8014df,%rax
  80007c:	00 00 00 
  80007f:	ff d0                	call   *%rax
  800081:	85 c0                	test   %eax,%eax
  800083:	78 6b                	js     8000f0 <dumbfork+0xcb>
        panic("sys_env_set_status: %i", r);

    return envid;
}
  800085:	89 d8                	mov    %ebx,%eax
  800087:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80008b:	c9                   	leave
  80008c:	c3                   	ret
        panic("sys_exofork: %i", envid);
  80008d:	89 c1                	mov    %eax,%ecx
  80008f:	48 ba 00 30 80 00 00 	movabs $0x803000,%rdx
  800096:	00 00 00 
  800099:	be 23 00 00 00       	mov    $0x23,%esi
  80009e:	48 bf 10 30 80 00 00 	movabs $0x803010,%rdi
  8000a5:	00 00 00 
  8000a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ad:	49 b8 8a 02 80 00 00 	movabs $0x80028a,%r8
  8000b4:	00 00 00 
  8000b7:	41 ff d0             	call   *%r8
        thisenv = &envs[ENVX(sys_getenvid())];
  8000ba:	48 b8 64 12 80 00 00 	movabs $0x801264,%rax
  8000c1:	00 00 00 
  8000c4:	ff d0                	call   *%rax
  8000c6:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000cb:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8000cf:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8000d3:	48 c1 e0 04          	shl    $0x4,%rax
  8000d7:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  8000de:	00 00 00 
  8000e1:	48 01 d0             	add    %rdx,%rax
  8000e4:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  8000eb:	00 00 00 
        return 0;
  8000ee:	eb 95                	jmp    800085 <dumbfork+0x60>
        panic("sys_env_set_status: %i", r);
  8000f0:	89 c1                	mov    %eax,%ecx
  8000f2:	48 ba 20 30 80 00 00 	movabs $0x803020,%rdx
  8000f9:	00 00 00 
  8000fc:	be 33 00 00 00       	mov    $0x33,%esi
  800101:	48 bf 10 30 80 00 00 	movabs $0x803010,%rdi
  800108:	00 00 00 
  80010b:	b8 00 00 00 00       	mov    $0x0,%eax
  800110:	49 b8 8a 02 80 00 00 	movabs $0x80028a,%r8
  800117:	00 00 00 
  80011a:	41 ff d0             	call   *%r8

000000000080011d <umain>:
umain(int argc, char **argv) {
  80011d:	f3 0f 1e fa          	endbr64
  800121:	55                   	push   %rbp
  800122:	48 89 e5             	mov    %rsp,%rbp
  800125:	41 57                	push   %r15
  800127:	41 56                	push   %r14
  800129:	41 55                	push   %r13
  80012b:	41 54                	push   %r12
  80012d:	53                   	push   %rbx
  80012e:	48 83 ec 08          	sub    $0x8,%rsp
    who = dumbfork();
  800132:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  800139:	00 00 00 
  80013c:	ff d0                	call   *%rax
  80013e:	41 89 c4             	mov    %eax,%r12d
    for (int i = 0; i < (who ? 10 : 20); i++) {
  800141:	85 c0                	test   %eax,%eax
  800143:	49 bd 37 30 80 00 00 	movabs $0x803037,%r13
  80014a:	00 00 00 
  80014d:	48 b8 3e 30 80 00 00 	movabs $0x80303e,%rax
  800154:	00 00 00 
  800157:	4c 0f 44 e8          	cmove  %rax,%r13
  80015b:	bb 00 00 00 00       	mov    $0x0,%ebx
        cprintf("%d: I am the %s!\n", i, who ? "parent" : "child");
  800160:	49 bf e6 03 80 00 00 	movabs $0x8003e6,%r15
  800167:	00 00 00 
        sys_yield();
  80016a:	49 be 99 12 80 00 00 	movabs $0x801299,%r14
  800171:	00 00 00 
    for (int i = 0; i < (who ? 10 : 20); i++) {
  800174:	eb 22                	jmp    800198 <umain+0x7b>
  800176:	83 fb 13             	cmp    $0x13,%ebx
  800179:	7f 27                	jg     8001a2 <umain+0x85>
        cprintf("%d: I am the %s!\n", i, who ? "parent" : "child");
  80017b:	4c 89 ea             	mov    %r13,%rdx
  80017e:	89 de                	mov    %ebx,%esi
  800180:	48 bf 44 30 80 00 00 	movabs $0x803044,%rdi
  800187:	00 00 00 
  80018a:	b8 00 00 00 00       	mov    $0x0,%eax
  80018f:	41 ff d7             	call   *%r15
        sys_yield();
  800192:	41 ff d6             	call   *%r14
    for (int i = 0; i < (who ? 10 : 20); i++) {
  800195:	83 c3 01             	add    $0x1,%ebx
  800198:	45 85 e4             	test   %r12d,%r12d
  80019b:	74 d9                	je     800176 <umain+0x59>
  80019d:	83 fb 09             	cmp    $0x9,%ebx
  8001a0:	7e d9                	jle    80017b <umain+0x5e>
}
  8001a2:	48 83 c4 08          	add    $0x8,%rsp
  8001a6:	5b                   	pop    %rbx
  8001a7:	41 5c                	pop    %r12
  8001a9:	41 5d                	pop    %r13
  8001ab:	41 5e                	pop    %r14
  8001ad:	41 5f                	pop    %r15
  8001af:	5d                   	pop    %rbp
  8001b0:	c3                   	ret

00000000008001b1 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  8001b1:	f3 0f 1e fa          	endbr64
  8001b5:	55                   	push   %rbp
  8001b6:	48 89 e5             	mov    %rsp,%rbp
  8001b9:	41 56                	push   %r14
  8001bb:	41 55                	push   %r13
  8001bd:	41 54                	push   %r12
  8001bf:	53                   	push   %rbx
  8001c0:	41 89 fd             	mov    %edi,%r13d
  8001c3:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
     * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  8001c6:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  8001cd:	00 00 00 
  8001d0:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  8001d7:	00 00 00 
  8001da:	48 39 c2             	cmp    %rax,%rdx
  8001dd:	73 17                	jae    8001f6 <libmain+0x45>
    void (**ctor)() = &__ctors_start;
  8001df:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  8001e2:	49 89 c4             	mov    %rax,%r12
  8001e5:	48 83 c3 08          	add    $0x8,%rbx
  8001e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8001ee:	ff 53 f8             	call   *-0x8(%rbx)
  8001f1:	4c 39 e3             	cmp    %r12,%rbx
  8001f4:	72 ef                	jb     8001e5 <libmain+0x34>

    /* Set thisenv to point at our Env structure in envs[]. */

    // LAB 8: Your code here
    thisenv = &((struct Env *)UENVS)[ENVX(sys_getenvid())];
  8001f6:	48 b8 64 12 80 00 00 	movabs $0x801264,%rax
  8001fd:	00 00 00 
  800200:	ff d0                	call   *%rax
  800202:	25 ff 03 00 00       	and    $0x3ff,%eax
  800207:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  80020b:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  80020f:	48 c1 e0 04          	shl    $0x4,%rax
  800213:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  80021a:	00 00 00 
  80021d:	48 01 d0             	add    %rdx,%rax
  800220:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  800227:	00 00 00 

    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  80022a:	45 85 ed             	test   %r13d,%r13d
  80022d:	7e 0d                	jle    80023c <libmain+0x8b>
  80022f:	49 8b 06             	mov    (%r14),%rax
  800232:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  800239:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  80023c:	4c 89 f6             	mov    %r14,%rsi
  80023f:	44 89 ef             	mov    %r13d,%edi
  800242:	48 b8 1d 01 80 00 00 	movabs $0x80011d,%rax
  800249:	00 00 00 
  80024c:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  80024e:	48 b8 63 02 80 00 00 	movabs $0x800263,%rax
  800255:	00 00 00 
  800258:	ff d0                	call   *%rax
#endif
}
  80025a:	5b                   	pop    %rbx
  80025b:	41 5c                	pop    %r12
  80025d:	41 5d                	pop    %r13
  80025f:	41 5e                	pop    %r14
  800261:	5d                   	pop    %rbp
  800262:	c3                   	ret

0000000000800263 <exit>:

#include <inc/lib.h>

void
exit(void) {
  800263:	f3 0f 1e fa          	endbr64
  800267:	55                   	push   %rbp
  800268:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  80026b:	48 b8 3a 19 80 00 00 	movabs $0x80193a,%rax
  800272:	00 00 00 
  800275:	ff d0                	call   *%rax
    sys_env_destroy(0);
  800277:	bf 00 00 00 00       	mov    $0x0,%edi
  80027c:	48 b8 f5 11 80 00 00 	movabs $0x8011f5,%rax
  800283:	00 00 00 
  800286:	ff d0                	call   *%rax
}
  800288:	5d                   	pop    %rbp
  800289:	c3                   	ret

000000000080028a <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  80028a:	f3 0f 1e fa          	endbr64
  80028e:	55                   	push   %rbp
  80028f:	48 89 e5             	mov    %rsp,%rbp
  800292:	41 56                	push   %r14
  800294:	41 55                	push   %r13
  800296:	41 54                	push   %r12
  800298:	53                   	push   %rbx
  800299:	48 83 ec 50          	sub    $0x50,%rsp
  80029d:	49 89 fc             	mov    %rdi,%r12
  8002a0:	41 89 f5             	mov    %esi,%r13d
  8002a3:	48 89 d3             	mov    %rdx,%rbx
  8002a6:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8002aa:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  8002ae:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  8002b2:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  8002b9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002bd:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  8002c1:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  8002c5:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  8002c9:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  8002d0:	00 00 00 
  8002d3:	4c 8b 30             	mov    (%rax),%r14
  8002d6:	48 b8 64 12 80 00 00 	movabs $0x801264,%rax
  8002dd:	00 00 00 
  8002e0:	ff d0                	call   *%rax
  8002e2:	89 c6                	mov    %eax,%esi
  8002e4:	45 89 e8             	mov    %r13d,%r8d
  8002e7:	4c 89 e1             	mov    %r12,%rcx
  8002ea:	4c 89 f2             	mov    %r14,%rdx
  8002ed:	48 bf b0 32 80 00 00 	movabs $0x8032b0,%rdi
  8002f4:	00 00 00 
  8002f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8002fc:	49 bc e6 03 80 00 00 	movabs $0x8003e6,%r12
  800303:	00 00 00 
  800306:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  800309:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  80030d:	48 89 df             	mov    %rbx,%rdi
  800310:	48 b8 7e 03 80 00 00 	movabs $0x80037e,%rax
  800317:	00 00 00 
  80031a:	ff d0                	call   *%rax
    cprintf("\n");
  80031c:	48 bf 54 30 80 00 00 	movabs $0x803054,%rdi
  800323:	00 00 00 
  800326:	b8 00 00 00 00       	mov    $0x0,%eax
  80032b:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  80032e:	cc                   	int3
  80032f:	eb fd                	jmp    80032e <_panic+0xa4>

0000000000800331 <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  800331:	f3 0f 1e fa          	endbr64
  800335:	55                   	push   %rbp
  800336:	48 89 e5             	mov    %rsp,%rbp
  800339:	53                   	push   %rbx
  80033a:	48 83 ec 08          	sub    $0x8,%rsp
  80033e:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  800341:	8b 06                	mov    (%rsi),%eax
  800343:	8d 50 01             	lea    0x1(%rax),%edx
  800346:	89 16                	mov    %edx,(%rsi)
  800348:	48 98                	cltq
  80034a:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  80034f:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  800355:	74 0a                	je     800361 <putch+0x30>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  800357:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  80035b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80035f:	c9                   	leave
  800360:	c3                   	ret
        sys_cputs(state->buf, state->offset);
  800361:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  800365:	be ff 00 00 00       	mov    $0xff,%esi
  80036a:	48 b8 8f 11 80 00 00 	movabs $0x80118f,%rax
  800371:	00 00 00 
  800374:	ff d0                	call   *%rax
        state->offset = 0;
  800376:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  80037c:	eb d9                	jmp    800357 <putch+0x26>

000000000080037e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  80037e:	f3 0f 1e fa          	endbr64
  800382:	55                   	push   %rbp
  800383:	48 89 e5             	mov    %rsp,%rbp
  800386:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80038d:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  800390:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  800397:	b9 21 00 00 00       	mov    $0x21,%ecx
  80039c:	b8 00 00 00 00       	mov    $0x0,%eax
  8003a1:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  8003a4:	48 89 f1             	mov    %rsi,%rcx
  8003a7:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  8003ae:	48 bf 31 03 80 00 00 	movabs $0x800331,%rdi
  8003b5:	00 00 00 
  8003b8:	48 b8 46 05 80 00 00 	movabs $0x800546,%rax
  8003bf:	00 00 00 
  8003c2:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  8003c4:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  8003cb:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  8003d2:	48 b8 8f 11 80 00 00 	movabs $0x80118f,%rax
  8003d9:	00 00 00 
  8003dc:	ff d0                	call   *%rax

    return state.count;
}
  8003de:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  8003e4:	c9                   	leave
  8003e5:	c3                   	ret

00000000008003e6 <cprintf>:

int
cprintf(const char *fmt, ...) {
  8003e6:	f3 0f 1e fa          	endbr64
  8003ea:	55                   	push   %rbp
  8003eb:	48 89 e5             	mov    %rsp,%rbp
  8003ee:	48 83 ec 50          	sub    $0x50,%rsp
  8003f2:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  8003f6:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8003fa:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8003fe:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800402:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  800406:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  80040d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800411:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800415:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800419:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  80041d:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  800421:	48 b8 7e 03 80 00 00 	movabs $0x80037e,%rax
  800428:	00 00 00 
  80042b:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  80042d:	c9                   	leave
  80042e:	c3                   	ret

000000000080042f <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  80042f:	f3 0f 1e fa          	endbr64
  800433:	55                   	push   %rbp
  800434:	48 89 e5             	mov    %rsp,%rbp
  800437:	41 57                	push   %r15
  800439:	41 56                	push   %r14
  80043b:	41 55                	push   %r13
  80043d:	41 54                	push   %r12
  80043f:	53                   	push   %rbx
  800440:	48 83 ec 18          	sub    $0x18,%rsp
  800444:	49 89 fc             	mov    %rdi,%r12
  800447:	49 89 f5             	mov    %rsi,%r13
  80044a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  80044e:	8b 45 10             	mov    0x10(%rbp),%eax
  800451:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  800454:	41 89 cf             	mov    %ecx,%r15d
  800457:	4c 39 fa             	cmp    %r15,%rdx
  80045a:	73 5b                	jae    8004b7 <print_num+0x88>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  80045c:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  800460:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  800464:	85 db                	test   %ebx,%ebx
  800466:	7e 0e                	jle    800476 <print_num+0x47>
            putch(padc, put_arg);
  800468:	4c 89 ee             	mov    %r13,%rsi
  80046b:	44 89 f7             	mov    %r14d,%edi
  80046e:	41 ff d4             	call   *%r12
        while (--width > 0) {
  800471:	83 eb 01             	sub    $0x1,%ebx
  800474:	75 f2                	jne    800468 <print_num+0x39>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  800476:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  80047a:	48 b9 71 30 80 00 00 	movabs $0x803071,%rcx
  800481:	00 00 00 
  800484:	48 b8 60 30 80 00 00 	movabs $0x803060,%rax
  80048b:	00 00 00 
  80048e:	48 0f 45 c8          	cmovne %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  800492:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800496:	ba 00 00 00 00       	mov    $0x0,%edx
  80049b:	49 f7 f7             	div    %r15
  80049e:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  8004a2:	4c 89 ee             	mov    %r13,%rsi
  8004a5:	41 ff d4             	call   *%r12
}
  8004a8:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  8004ac:	5b                   	pop    %rbx
  8004ad:	41 5c                	pop    %r12
  8004af:	41 5d                	pop    %r13
  8004b1:	41 5e                	pop    %r14
  8004b3:	41 5f                	pop    %r15
  8004b5:	5d                   	pop    %rbp
  8004b6:	c3                   	ret
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  8004b7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8004c0:	49 f7 f7             	div    %r15
  8004c3:	48 83 ec 08          	sub    $0x8,%rsp
  8004c7:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  8004cb:	52                   	push   %rdx
  8004cc:	45 0f be c9          	movsbl %r9b,%r9d
  8004d0:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  8004d4:	48 89 c2             	mov    %rax,%rdx
  8004d7:	48 b8 2f 04 80 00 00 	movabs $0x80042f,%rax
  8004de:	00 00 00 
  8004e1:	ff d0                	call   *%rax
  8004e3:	48 83 c4 10          	add    $0x10,%rsp
  8004e7:	eb 8d                	jmp    800476 <print_num+0x47>

00000000008004e9 <sprintputch>:
    char *end;
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
  8004e9:	f3 0f 1e fa          	endbr64
    state->count++;
  8004ed:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  8004f1:	48 8b 06             	mov    (%rsi),%rax
  8004f4:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  8004f8:	73 0a                	jae    800504 <sprintputch+0x1b>
        *state->start++ = ch;
  8004fa:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8004fe:	48 89 16             	mov    %rdx,(%rsi)
  800501:	40 88 38             	mov    %dil,(%rax)
    }
}
  800504:	c3                   	ret

0000000000800505 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  800505:	f3 0f 1e fa          	endbr64
  800509:	55                   	push   %rbp
  80050a:	48 89 e5             	mov    %rsp,%rbp
  80050d:	48 83 ec 50          	sub    $0x50,%rsp
  800511:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800515:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800519:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  80051d:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800524:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800528:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80052c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800530:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  800534:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800538:	48 b8 46 05 80 00 00 	movabs $0x800546,%rax
  80053f:	00 00 00 
  800542:	ff d0                	call   *%rax
}
  800544:	c9                   	leave
  800545:	c3                   	ret

0000000000800546 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  800546:	f3 0f 1e fa          	endbr64
  80054a:	55                   	push   %rbp
  80054b:	48 89 e5             	mov    %rsp,%rbp
  80054e:	41 57                	push   %r15
  800550:	41 56                	push   %r14
  800552:	41 55                	push   %r13
  800554:	41 54                	push   %r12
  800556:	53                   	push   %rbx
  800557:	48 83 ec 38          	sub    $0x38,%rsp
  80055b:	49 89 fe             	mov    %rdi,%r14
  80055e:	49 89 f5             	mov    %rsi,%r13
  800561:	48 89 d3             	mov    %rdx,%rbx
    va_copy(aq, ap);
  800564:	48 8b 01             	mov    (%rcx),%rax
  800567:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  80056b:	48 8b 41 08          	mov    0x8(%rcx),%rax
  80056f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800573:	48 8b 41 10          	mov    0x10(%rcx),%rax
  800577:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  80057b:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  80057f:	0f b6 3b             	movzbl (%rbx),%edi
  800582:	40 80 ff 25          	cmp    $0x25,%dil
  800586:	74 18                	je     8005a0 <vprintfmt+0x5a>
            if (!ch) return;
  800588:	40 84 ff             	test   %dil,%dil
  80058b:	0f 84 b2 06 00 00    	je     800c43 <vprintfmt+0x6fd>
            putch(ch, put_arg);
  800591:	40 0f b6 ff          	movzbl %dil,%edi
  800595:	4c 89 ee             	mov    %r13,%rsi
  800598:	41 ff d6             	call   *%r14
        while ((ch = *ufmt++) != '%') {
  80059b:	4c 89 e3             	mov    %r12,%rbx
  80059e:	eb db                	jmp    80057b <vprintfmt+0x35>
        bool altflag = 0, zflag = 0;
  8005a0:	be 00 00 00 00       	mov    $0x0,%esi
  8005a5:	c6 45 ab 00          	movb   $0x0,-0x55(%rbp)
        unsigned lflag = 0, base = 10;
  8005a9:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  8005ae:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  8005b4:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  8005bb:	c6 45 aa 20          	movb   $0x20,-0x56(%rbp)
        switch (ch = *ufmt++) {
  8005bf:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  8005c4:	41 0f b6 04 24       	movzbl (%r12),%eax
  8005c9:	88 45 a0             	mov    %al,-0x60(%rbp)
  8005cc:	83 e8 23             	sub    $0x23,%eax
  8005cf:	3c 57                	cmp    $0x57,%al
  8005d1:	0f 87 52 06 00 00    	ja     800c29 <vprintfmt+0x6e3>
  8005d7:	0f b6 c0             	movzbl %al,%eax
  8005da:	48 b9 a0 33 80 00 00 	movabs $0x8033a0,%rcx
  8005e1:	00 00 00 
  8005e4:	3e ff 24 c1          	notrack jmp *(%rcx,%rax,8)
  8005e8:	49 89 dc             	mov    %rbx,%r12
            altflag = 1;
  8005eb:	c6 45 ab 01          	movb   $0x1,-0x55(%rbp)
  8005ef:	eb ce                	jmp    8005bf <vprintfmt+0x79>
        switch (ch = *ufmt++) {
  8005f1:	49 89 dc             	mov    %rbx,%r12
  8005f4:	be 01 00 00 00       	mov    $0x1,%esi
  8005f9:	eb c4                	jmp    8005bf <vprintfmt+0x79>
            padc = ch;
  8005fb:	0f b6 45 a0          	movzbl -0x60(%rbp),%eax
  8005ff:	88 45 aa             	mov    %al,-0x56(%rbp)
        switch (ch = *ufmt++) {
  800602:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  800605:	eb b8                	jmp    8005bf <vprintfmt+0x79>
            precision = va_arg(aq, int);
  800607:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80060a:	83 f8 2f             	cmp    $0x2f,%eax
  80060d:	77 24                	ja     800633 <vprintfmt+0xed>
  80060f:	89 c1                	mov    %eax,%ecx
  800611:	48 03 4d c8          	add    -0x38(%rbp),%rcx
  800615:	83 c0 08             	add    $0x8,%eax
  800618:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80061b:	44 8b 39             	mov    (%rcx),%r15d
        switch (ch = *ufmt++) {
  80061e:	49 89 dc             	mov    %rbx,%r12
            if (width < 0) {
  800621:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800625:	79 98                	jns    8005bf <vprintfmt+0x79>
                width = precision;
  800627:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
                precision = -1;
  80062b:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  800631:	eb 8c                	jmp    8005bf <vprintfmt+0x79>
            precision = va_arg(aq, int);
  800633:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  800637:	48 8d 41 08          	lea    0x8(%rcx),%rax
  80063b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80063f:	eb da                	jmp    80061b <vprintfmt+0xd5>
                precision = precision * 10 + ch - '0';
  800641:	44 0f b6 7d a0       	movzbl -0x60(%rbp),%r15d
  800646:	41 83 ef 30          	sub    $0x30,%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  80064a:	41 0f b6 44 24 01    	movzbl 0x1(%r12),%eax
  800650:	3c 39                	cmp    $0x39,%al
  800652:	77 1c                	ja     800670 <vprintfmt+0x12a>
            for (precision = 0;; ++ufmt) {
  800654:	48 83 c3 01          	add    $0x1,%rbx
                precision = precision * 10 + ch - '0';
  800658:	43 8d 0c bf          	lea    (%r15,%r15,4),%ecx
  80065c:	0f b6 c0             	movzbl %al,%eax
  80065f:	44 8d 7c 48 d0       	lea    -0x30(%rax,%rcx,2),%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  800664:	0f b6 03             	movzbl (%rbx),%eax
  800667:	3c 39                	cmp    $0x39,%al
  800669:	76 e9                	jbe    800654 <vprintfmt+0x10e>
        process_precision:
  80066b:	49 89 dc             	mov    %rbx,%r12
  80066e:	eb b1                	jmp    800621 <vprintfmt+0xdb>
        switch (ch = *ufmt++) {
  800670:	49 89 dc             	mov    %rbx,%r12
  800673:	eb ac                	jmp    800621 <vprintfmt+0xdb>
            width = MAX(0, width);
  800675:	8b 4d ac             	mov    -0x54(%rbp),%ecx
  800678:	85 c9                	test   %ecx,%ecx
  80067a:	b8 00 00 00 00       	mov    $0x0,%eax
  80067f:	0f 49 c1             	cmovns %ecx,%eax
  800682:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  800685:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  800688:	e9 32 ff ff ff       	jmp    8005bf <vprintfmt+0x79>
            lflag++;
  80068d:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  800690:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  800693:	e9 27 ff ff ff       	jmp    8005bf <vprintfmt+0x79>
            putch(va_arg(aq, int), put_arg);
  800698:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80069b:	83 f8 2f             	cmp    $0x2f,%eax
  80069e:	77 19                	ja     8006b9 <vprintfmt+0x173>
  8006a0:	89 c2                	mov    %eax,%edx
  8006a2:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8006a6:	83 c0 08             	add    $0x8,%eax
  8006a9:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8006ac:	8b 3a                	mov    (%rdx),%edi
  8006ae:	4c 89 ee             	mov    %r13,%rsi
  8006b1:	41 ff d6             	call   *%r14
            break;
  8006b4:	e9 c2 fe ff ff       	jmp    80057b <vprintfmt+0x35>
            putch(va_arg(aq, int), put_arg);
  8006b9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8006bd:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8006c1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8006c5:	eb e5                	jmp    8006ac <vprintfmt+0x166>
            int err = va_arg(aq, int);
  8006c7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8006ca:	83 f8 2f             	cmp    $0x2f,%eax
  8006cd:	77 5a                	ja     800729 <vprintfmt+0x1e3>
  8006cf:	89 c2                	mov    %eax,%edx
  8006d1:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8006d5:	83 c0 08             	add    $0x8,%eax
  8006d8:	89 45 b8             	mov    %eax,-0x48(%rbp)
            if (err < 0) err = -err;
  8006db:	8b 02                	mov    (%rdx),%eax
  8006dd:	89 c1                	mov    %eax,%ecx
  8006df:	f7 d9                	neg    %ecx
  8006e1:	0f 48 c8             	cmovs  %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  8006e4:	83 f9 13             	cmp    $0x13,%ecx
  8006e7:	7f 4e                	jg     800737 <vprintfmt+0x1f1>
  8006e9:	48 63 c1             	movslq %ecx,%rax
  8006ec:	48 ba 60 36 80 00 00 	movabs $0x803660,%rdx
  8006f3:	00 00 00 
  8006f6:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8006fa:	48 85 c0             	test   %rax,%rax
  8006fd:	74 38                	je     800737 <vprintfmt+0x1f1>
                printfmt(putch, put_arg, "%s", strerr);
  8006ff:	48 89 c1             	mov    %rax,%rcx
  800702:	48 ba 65 32 80 00 00 	movabs $0x803265,%rdx
  800709:	00 00 00 
  80070c:	4c 89 ee             	mov    %r13,%rsi
  80070f:	4c 89 f7             	mov    %r14,%rdi
  800712:	b8 00 00 00 00       	mov    $0x0,%eax
  800717:	49 b8 05 05 80 00 00 	movabs $0x800505,%r8
  80071e:	00 00 00 
  800721:	41 ff d0             	call   *%r8
  800724:	e9 52 fe ff ff       	jmp    80057b <vprintfmt+0x35>
            int err = va_arg(aq, int);
  800729:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80072d:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800731:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800735:	eb a4                	jmp    8006db <vprintfmt+0x195>
                printfmt(putch, put_arg, "error %d", err);
  800737:	48 ba 89 30 80 00 00 	movabs $0x803089,%rdx
  80073e:	00 00 00 
  800741:	4c 89 ee             	mov    %r13,%rsi
  800744:	4c 89 f7             	mov    %r14,%rdi
  800747:	b8 00 00 00 00       	mov    $0x0,%eax
  80074c:	49 b8 05 05 80 00 00 	movabs $0x800505,%r8
  800753:	00 00 00 
  800756:	41 ff d0             	call   *%r8
  800759:	e9 1d fe ff ff       	jmp    80057b <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  80075e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800761:	83 f8 2f             	cmp    $0x2f,%eax
  800764:	77 6c                	ja     8007d2 <vprintfmt+0x28c>
  800766:	89 c2                	mov    %eax,%edx
  800768:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80076c:	83 c0 08             	add    $0x8,%eax
  80076f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800772:	48 8b 12             	mov    (%rdx),%rdx
            if (!ptr) ptr = "(null)";
  800775:	48 85 d2             	test   %rdx,%rdx
  800778:	48 b8 82 30 80 00 00 	movabs $0x803082,%rax
  80077f:	00 00 00 
  800782:	48 0f 45 c2          	cmovne %rdx,%rax
  800786:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
            if (width > 0 && padc != '-') {
  80078a:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  80078e:	7e 06                	jle    800796 <vprintfmt+0x250>
  800790:	80 7d aa 2d          	cmpb   $0x2d,-0x56(%rbp)
  800794:	75 4a                	jne    8007e0 <vprintfmt+0x29a>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800796:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80079a:	4c 8d 60 01          	lea    0x1(%rax),%r12
  80079e:	0f b6 00             	movzbl (%rax),%eax
  8007a1:	84 c0                	test   %al,%al
  8007a3:	0f 85 9a 00 00 00    	jne    800843 <vprintfmt+0x2fd>
            while (width-- > 0) putch(' ', put_arg);
  8007a9:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8007ac:	44 8d 60 ff          	lea    -0x1(%rax),%r12d
  8007b0:	85 c0                	test   %eax,%eax
  8007b2:	0f 8e c3 fd ff ff    	jle    80057b <vprintfmt+0x35>
  8007b8:	4c 89 ee             	mov    %r13,%rsi
  8007bb:	bf 20 00 00 00       	mov    $0x20,%edi
  8007c0:	41 ff d6             	call   *%r14
  8007c3:	41 83 ec 01          	sub    $0x1,%r12d
  8007c7:	41 83 fc ff          	cmp    $0xffffffff,%r12d
  8007cb:	75 eb                	jne    8007b8 <vprintfmt+0x272>
  8007cd:	e9 a9 fd ff ff       	jmp    80057b <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  8007d2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007d6:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8007da:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007de:	eb 92                	jmp    800772 <vprintfmt+0x22c>
                width -= strnlen(ptr, precision);
  8007e0:	49 63 f7             	movslq %r15d,%rsi
  8007e3:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  8007e7:	48 b8 09 0d 80 00 00 	movabs $0x800d09,%rax
  8007ee:	00 00 00 
  8007f1:	ff d0                	call   *%rax
  8007f3:	48 89 c2             	mov    %rax,%rdx
  8007f6:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8007f9:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  8007fb:	8d 70 ff             	lea    -0x1(%rax),%esi
  8007fe:	89 75 ac             	mov    %esi,-0x54(%rbp)
  800801:	85 c0                	test   %eax,%eax
  800803:	7e 91                	jle    800796 <vprintfmt+0x250>
  800805:	44 0f be 65 aa       	movsbl -0x56(%rbp),%r12d
  80080a:	4c 89 ee             	mov    %r13,%rsi
  80080d:	44 89 e7             	mov    %r12d,%edi
  800810:	41 ff d6             	call   *%r14
  800813:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  800817:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80081a:	83 f8 ff             	cmp    $0xffffffff,%eax
  80081d:	75 eb                	jne    80080a <vprintfmt+0x2c4>
  80081f:	e9 72 ff ff ff       	jmp    800796 <vprintfmt+0x250>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800824:	0f b6 f8             	movzbl %al,%edi
  800827:	4c 89 ee             	mov    %r13,%rsi
  80082a:	41 ff d6             	call   *%r14
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  80082d:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  800831:	49 83 c4 01          	add    $0x1,%r12
  800835:	41 0f b6 44 24 ff    	movzbl -0x1(%r12),%eax
  80083b:	84 c0                	test   %al,%al
  80083d:	0f 84 66 ff ff ff    	je     8007a9 <vprintfmt+0x263>
  800843:	45 85 ff             	test   %r15d,%r15d
  800846:	78 0a                	js     800852 <vprintfmt+0x30c>
  800848:	41 83 ef 01          	sub    $0x1,%r15d
  80084c:	0f 88 57 ff ff ff    	js     8007a9 <vprintfmt+0x263>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800852:	80 7d ab 00          	cmpb   $0x0,-0x55(%rbp)
  800856:	74 cc                	je     800824 <vprintfmt+0x2de>
  800858:	8d 50 e0             	lea    -0x20(%rax),%edx
  80085b:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800860:	80 fa 5e             	cmp    $0x5e,%dl
  800863:	77 c2                	ja     800827 <vprintfmt+0x2e1>
  800865:	eb bd                	jmp    800824 <vprintfmt+0x2de>
    if (zflag) return va_arg(*ap, size_t);
  800867:	40 84 f6             	test   %sil,%sil
  80086a:	75 26                	jne    800892 <vprintfmt+0x34c>
    switch (lflag) {
  80086c:	85 d2                	test   %edx,%edx
  80086e:	74 59                	je     8008c9 <vprintfmt+0x383>
  800870:	83 fa 01             	cmp    $0x1,%edx
  800873:	74 7b                	je     8008f0 <vprintfmt+0x3aa>
        return va_arg(*ap, long long);
  800875:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800878:	83 f8 2f             	cmp    $0x2f,%eax
  80087b:	0f 87 96 00 00 00    	ja     800917 <vprintfmt+0x3d1>
  800881:	89 c2                	mov    %eax,%edx
  800883:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800887:	83 c0 08             	add    $0x8,%eax
  80088a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80088d:	4c 8b 22             	mov    (%rdx),%r12
  800890:	eb 17                	jmp    8008a9 <vprintfmt+0x363>
    if (zflag) return va_arg(*ap, size_t);
  800892:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800895:	83 f8 2f             	cmp    $0x2f,%eax
  800898:	77 21                	ja     8008bb <vprintfmt+0x375>
  80089a:	89 c2                	mov    %eax,%edx
  80089c:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8008a0:	83 c0 08             	add    $0x8,%eax
  8008a3:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008a6:	4c 8b 22             	mov    (%rdx),%r12
            if (i < 0) {
  8008a9:	4d 85 e4             	test   %r12,%r12
  8008ac:	78 7a                	js     800928 <vprintfmt+0x3e2>
            num = i;
  8008ae:	4c 89 e2             	mov    %r12,%rdx
        unsigned lflag = 0, base = 10;
  8008b1:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  8008b6:	e9 50 02 00 00       	jmp    800b0b <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8008bb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008bf:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8008c3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008c7:	eb dd                	jmp    8008a6 <vprintfmt+0x360>
        return va_arg(*ap, int);
  8008c9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008cc:	83 f8 2f             	cmp    $0x2f,%eax
  8008cf:	77 11                	ja     8008e2 <vprintfmt+0x39c>
  8008d1:	89 c2                	mov    %eax,%edx
  8008d3:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8008d7:	83 c0 08             	add    $0x8,%eax
  8008da:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008dd:	4c 63 22             	movslq (%rdx),%r12
  8008e0:	eb c7                	jmp    8008a9 <vprintfmt+0x363>
  8008e2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008e6:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8008ea:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008ee:	eb ed                	jmp    8008dd <vprintfmt+0x397>
        return va_arg(*ap, long);
  8008f0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008f3:	83 f8 2f             	cmp    $0x2f,%eax
  8008f6:	77 11                	ja     800909 <vprintfmt+0x3c3>
  8008f8:	89 c2                	mov    %eax,%edx
  8008fa:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8008fe:	83 c0 08             	add    $0x8,%eax
  800901:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800904:	4c 8b 22             	mov    (%rdx),%r12
  800907:	eb a0                	jmp    8008a9 <vprintfmt+0x363>
  800909:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80090d:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800911:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800915:	eb ed                	jmp    800904 <vprintfmt+0x3be>
        return va_arg(*ap, long long);
  800917:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80091b:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80091f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800923:	e9 65 ff ff ff       	jmp    80088d <vprintfmt+0x347>
                putch('-', put_arg);
  800928:	4c 89 ee             	mov    %r13,%rsi
  80092b:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800930:	41 ff d6             	call   *%r14
                i = -i;
  800933:	49 f7 dc             	neg    %r12
  800936:	e9 73 ff ff ff       	jmp    8008ae <vprintfmt+0x368>
    if (zflag) return va_arg(*ap, size_t);
  80093b:	40 84 f6             	test   %sil,%sil
  80093e:	75 32                	jne    800972 <vprintfmt+0x42c>
    switch (lflag) {
  800940:	85 d2                	test   %edx,%edx
  800942:	74 5d                	je     8009a1 <vprintfmt+0x45b>
  800944:	83 fa 01             	cmp    $0x1,%edx
  800947:	0f 84 82 00 00 00    	je     8009cf <vprintfmt+0x489>
        return va_arg(*ap, unsigned long long);
  80094d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800950:	83 f8 2f             	cmp    $0x2f,%eax
  800953:	0f 87 a5 00 00 00    	ja     8009fe <vprintfmt+0x4b8>
  800959:	89 c2                	mov    %eax,%edx
  80095b:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80095f:	83 c0 08             	add    $0x8,%eax
  800962:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800965:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800968:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  80096d:	e9 99 01 00 00       	jmp    800b0b <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800972:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800975:	83 f8 2f             	cmp    $0x2f,%eax
  800978:	77 19                	ja     800993 <vprintfmt+0x44d>
  80097a:	89 c2                	mov    %eax,%edx
  80097c:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800980:	83 c0 08             	add    $0x8,%eax
  800983:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800986:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800989:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  80098e:	e9 78 01 00 00       	jmp    800b0b <vprintfmt+0x5c5>
  800993:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800997:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80099b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80099f:	eb e5                	jmp    800986 <vprintfmt+0x440>
        return va_arg(*ap, unsigned int);
  8009a1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009a4:	83 f8 2f             	cmp    $0x2f,%eax
  8009a7:	77 18                	ja     8009c1 <vprintfmt+0x47b>
  8009a9:	89 c2                	mov    %eax,%edx
  8009ab:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8009af:	83 c0 08             	add    $0x8,%eax
  8009b2:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009b5:	8b 12                	mov    (%rdx),%edx
        unsigned lflag = 0, base = 10;
  8009b7:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  8009bc:	e9 4a 01 00 00       	jmp    800b0b <vprintfmt+0x5c5>
  8009c1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009c5:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009c9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009cd:	eb e6                	jmp    8009b5 <vprintfmt+0x46f>
        return va_arg(*ap, unsigned long);
  8009cf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009d2:	83 f8 2f             	cmp    $0x2f,%eax
  8009d5:	77 19                	ja     8009f0 <vprintfmt+0x4aa>
  8009d7:	89 c2                	mov    %eax,%edx
  8009d9:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8009dd:	83 c0 08             	add    $0x8,%eax
  8009e0:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009e3:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  8009e6:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  8009eb:	e9 1b 01 00 00       	jmp    800b0b <vprintfmt+0x5c5>
  8009f0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009f4:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009f8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009fc:	eb e5                	jmp    8009e3 <vprintfmt+0x49d>
        return va_arg(*ap, unsigned long long);
  8009fe:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a02:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a06:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a0a:	e9 56 ff ff ff       	jmp    800965 <vprintfmt+0x41f>
    if (zflag) return va_arg(*ap, size_t);
  800a0f:	40 84 f6             	test   %sil,%sil
  800a12:	75 2e                	jne    800a42 <vprintfmt+0x4fc>
    switch (lflag) {
  800a14:	85 d2                	test   %edx,%edx
  800a16:	74 59                	je     800a71 <vprintfmt+0x52b>
  800a18:	83 fa 01             	cmp    $0x1,%edx
  800a1b:	74 7f                	je     800a9c <vprintfmt+0x556>
        return va_arg(*ap, unsigned long long);
  800a1d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a20:	83 f8 2f             	cmp    $0x2f,%eax
  800a23:	0f 87 9f 00 00 00    	ja     800ac8 <vprintfmt+0x582>
  800a29:	89 c2                	mov    %eax,%edx
  800a2b:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a2f:	83 c0 08             	add    $0x8,%eax
  800a32:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a35:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800a38:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  800a3d:	e9 c9 00 00 00       	jmp    800b0b <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800a42:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a45:	83 f8 2f             	cmp    $0x2f,%eax
  800a48:	77 19                	ja     800a63 <vprintfmt+0x51d>
  800a4a:	89 c2                	mov    %eax,%edx
  800a4c:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a50:	83 c0 08             	add    $0x8,%eax
  800a53:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a56:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800a59:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800a5e:	e9 a8 00 00 00       	jmp    800b0b <vprintfmt+0x5c5>
  800a63:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a67:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a6b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a6f:	eb e5                	jmp    800a56 <vprintfmt+0x510>
        return va_arg(*ap, unsigned int);
  800a71:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a74:	83 f8 2f             	cmp    $0x2f,%eax
  800a77:	77 15                	ja     800a8e <vprintfmt+0x548>
  800a79:	89 c2                	mov    %eax,%edx
  800a7b:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a7f:	83 c0 08             	add    $0x8,%eax
  800a82:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a85:	8b 12                	mov    (%rdx),%edx
            base = 8;
  800a87:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  800a8c:	eb 7d                	jmp    800b0b <vprintfmt+0x5c5>
  800a8e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a92:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a96:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a9a:	eb e9                	jmp    800a85 <vprintfmt+0x53f>
        return va_arg(*ap, unsigned long);
  800a9c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a9f:	83 f8 2f             	cmp    $0x2f,%eax
  800aa2:	77 16                	ja     800aba <vprintfmt+0x574>
  800aa4:	89 c2                	mov    %eax,%edx
  800aa6:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800aaa:	83 c0 08             	add    $0x8,%eax
  800aad:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ab0:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800ab3:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  800ab8:	eb 51                	jmp    800b0b <vprintfmt+0x5c5>
  800aba:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800abe:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800ac2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ac6:	eb e8                	jmp    800ab0 <vprintfmt+0x56a>
        return va_arg(*ap, unsigned long long);
  800ac8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800acc:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800ad0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ad4:	e9 5c ff ff ff       	jmp    800a35 <vprintfmt+0x4ef>
            putch('0', put_arg);
  800ad9:	4c 89 ee             	mov    %r13,%rsi
  800adc:	bf 30 00 00 00       	mov    $0x30,%edi
  800ae1:	41 ff d6             	call   *%r14
            putch('x', put_arg);
  800ae4:	4c 89 ee             	mov    %r13,%rsi
  800ae7:	bf 78 00 00 00       	mov    $0x78,%edi
  800aec:	41 ff d6             	call   *%r14
            num = (uintptr_t)va_arg(aq, void *);
  800aef:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800af2:	83 f8 2f             	cmp    $0x2f,%eax
  800af5:	77 47                	ja     800b3e <vprintfmt+0x5f8>
  800af7:	89 c2                	mov    %eax,%edx
  800af9:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800afd:	83 c0 08             	add    $0x8,%eax
  800b00:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b03:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800b06:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  800b0b:	48 83 ec 08          	sub    $0x8,%rsp
  800b0f:	80 7d a0 58          	cmpb   $0x58,-0x60(%rbp)
  800b13:	0f 94 c0             	sete   %al
  800b16:	0f b6 c0             	movzbl %al,%eax
  800b19:	50                   	push   %rax
  800b1a:	44 0f be 4d aa       	movsbl -0x56(%rbp),%r9d
  800b1f:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  800b23:	4c 89 ee             	mov    %r13,%rsi
  800b26:	4c 89 f7             	mov    %r14,%rdi
  800b29:	48 b8 2f 04 80 00 00 	movabs $0x80042f,%rax
  800b30:	00 00 00 
  800b33:	ff d0                	call   *%rax
            break;
  800b35:	48 83 c4 10          	add    $0x10,%rsp
  800b39:	e9 3d fa ff ff       	jmp    80057b <vprintfmt+0x35>
            num = (uintptr_t)va_arg(aq, void *);
  800b3e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b42:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b46:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b4a:	eb b7                	jmp    800b03 <vprintfmt+0x5bd>
    if (zflag) return va_arg(*ap, size_t);
  800b4c:	40 84 f6             	test   %sil,%sil
  800b4f:	75 2b                	jne    800b7c <vprintfmt+0x636>
    switch (lflag) {
  800b51:	85 d2                	test   %edx,%edx
  800b53:	74 56                	je     800bab <vprintfmt+0x665>
  800b55:	83 fa 01             	cmp    $0x1,%edx
  800b58:	74 7f                	je     800bd9 <vprintfmt+0x693>
        return va_arg(*ap, unsigned long long);
  800b5a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b5d:	83 f8 2f             	cmp    $0x2f,%eax
  800b60:	0f 87 a2 00 00 00    	ja     800c08 <vprintfmt+0x6c2>
  800b66:	89 c2                	mov    %eax,%edx
  800b68:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b6c:	83 c0 08             	add    $0x8,%eax
  800b6f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b72:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800b75:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800b7a:	eb 8f                	jmp    800b0b <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800b7c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b7f:	83 f8 2f             	cmp    $0x2f,%eax
  800b82:	77 19                	ja     800b9d <vprintfmt+0x657>
  800b84:	89 c2                	mov    %eax,%edx
  800b86:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b8a:	83 c0 08             	add    $0x8,%eax
  800b8d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b90:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800b93:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800b98:	e9 6e ff ff ff       	jmp    800b0b <vprintfmt+0x5c5>
  800b9d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ba1:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800ba5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ba9:	eb e5                	jmp    800b90 <vprintfmt+0x64a>
        return va_arg(*ap, unsigned int);
  800bab:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bae:	83 f8 2f             	cmp    $0x2f,%eax
  800bb1:	77 18                	ja     800bcb <vprintfmt+0x685>
  800bb3:	89 c2                	mov    %eax,%edx
  800bb5:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800bb9:	83 c0 08             	add    $0x8,%eax
  800bbc:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800bbf:	8b 12                	mov    (%rdx),%edx
            base = 16;
  800bc1:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  800bc6:	e9 40 ff ff ff       	jmp    800b0b <vprintfmt+0x5c5>
  800bcb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bcf:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800bd3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800bd7:	eb e6                	jmp    800bbf <vprintfmt+0x679>
        return va_arg(*ap, unsigned long);
  800bd9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bdc:	83 f8 2f             	cmp    $0x2f,%eax
  800bdf:	77 19                	ja     800bfa <vprintfmt+0x6b4>
  800be1:	89 c2                	mov    %eax,%edx
  800be3:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800be7:	83 c0 08             	add    $0x8,%eax
  800bea:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800bed:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800bf0:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800bf5:	e9 11 ff ff ff       	jmp    800b0b <vprintfmt+0x5c5>
  800bfa:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bfe:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800c02:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c06:	eb e5                	jmp    800bed <vprintfmt+0x6a7>
        return va_arg(*ap, unsigned long long);
  800c08:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c0c:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800c10:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c14:	e9 59 ff ff ff       	jmp    800b72 <vprintfmt+0x62c>
            putch(ch, put_arg);
  800c19:	4c 89 ee             	mov    %r13,%rsi
  800c1c:	bf 25 00 00 00       	mov    $0x25,%edi
  800c21:	41 ff d6             	call   *%r14
            break;
  800c24:	e9 52 f9 ff ff       	jmp    80057b <vprintfmt+0x35>
            putch('%', put_arg);
  800c29:	4c 89 ee             	mov    %r13,%rsi
  800c2c:	bf 25 00 00 00       	mov    $0x25,%edi
  800c31:	41 ff d6             	call   *%r14
            while ((--ufmt)[-1] != '%') /* nothing */
  800c34:	48 83 eb 01          	sub    $0x1,%rbx
  800c38:	80 7b ff 25          	cmpb   $0x25,-0x1(%rbx)
  800c3c:	75 f6                	jne    800c34 <vprintfmt+0x6ee>
  800c3e:	e9 38 f9 ff ff       	jmp    80057b <vprintfmt+0x35>
}
  800c43:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800c47:	5b                   	pop    %rbx
  800c48:	41 5c                	pop    %r12
  800c4a:	41 5d                	pop    %r13
  800c4c:	41 5e                	pop    %r14
  800c4e:	41 5f                	pop    %r15
  800c50:	5d                   	pop    %rbp
  800c51:	c3                   	ret

0000000000800c52 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800c52:	f3 0f 1e fa          	endbr64
  800c56:	55                   	push   %rbp
  800c57:	48 89 e5             	mov    %rsp,%rbp
  800c5a:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800c5e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800c62:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800c67:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800c6b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800c72:	48 85 ff             	test   %rdi,%rdi
  800c75:	74 2b                	je     800ca2 <vsnprintf+0x50>
  800c77:	48 85 f6             	test   %rsi,%rsi
  800c7a:	74 26                	je     800ca2 <vsnprintf+0x50>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800c7c:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800c80:	48 bf e9 04 80 00 00 	movabs $0x8004e9,%rdi
  800c87:	00 00 00 
  800c8a:	48 b8 46 05 80 00 00 	movabs $0x800546,%rax
  800c91:	00 00 00 
  800c94:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800c96:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c9a:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800c9d:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800ca0:	c9                   	leave
  800ca1:	c3                   	ret
    if (!buf || n < 1) return -E_INVAL;
  800ca2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ca7:	eb f7                	jmp    800ca0 <vsnprintf+0x4e>

0000000000800ca9 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800ca9:	f3 0f 1e fa          	endbr64
  800cad:	55                   	push   %rbp
  800cae:	48 89 e5             	mov    %rsp,%rbp
  800cb1:	48 83 ec 50          	sub    $0x50,%rsp
  800cb5:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800cb9:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800cbd:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800cc1:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800cc8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800ccc:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800cd0:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800cd4:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800cd8:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800cdc:	48 b8 52 0c 80 00 00 	movabs $0x800c52,%rax
  800ce3:	00 00 00 
  800ce6:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800ce8:	c9                   	leave
  800ce9:	c3                   	ret

0000000000800cea <strlen>:
 * Primespipe runs 3x faster this way */

#define ASM 1

size_t
strlen(const char *s) {
  800cea:	f3 0f 1e fa          	endbr64
    size_t n = 0;
    while (*s++) n++;
  800cee:	80 3f 00             	cmpb   $0x0,(%rdi)
  800cf1:	74 10                	je     800d03 <strlen+0x19>
    size_t n = 0;
  800cf3:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800cf8:	48 83 c0 01          	add    $0x1,%rax
  800cfc:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800d00:	75 f6                	jne    800cf8 <strlen+0xe>
  800d02:	c3                   	ret
    size_t n = 0;
  800d03:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800d08:	c3                   	ret

0000000000800d09 <strnlen>:

size_t
strnlen(const char *s, size_t size) {
  800d09:	f3 0f 1e fa          	endbr64
  800d0d:	48 89 f0             	mov    %rsi,%rax
    size_t n = 0;
  800d10:	ba 00 00 00 00       	mov    $0x0,%edx
    while (n < size && *s++) n++;
  800d15:	48 85 f6             	test   %rsi,%rsi
  800d18:	74 10                	je     800d2a <strnlen+0x21>
  800d1a:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  800d1e:	74 0b                	je     800d2b <strnlen+0x22>
  800d20:	48 83 c2 01          	add    $0x1,%rdx
  800d24:	48 39 d0             	cmp    %rdx,%rax
  800d27:	75 f1                	jne    800d1a <strnlen+0x11>
  800d29:	c3                   	ret
  800d2a:	c3                   	ret
  800d2b:	48 89 d0             	mov    %rdx,%rax
    return n;
}
  800d2e:	c3                   	ret

0000000000800d2f <strcpy>:

char *
strcpy(char *dst, const char *src) {
  800d2f:	f3 0f 1e fa          	endbr64
  800d33:	48 89 f8             	mov    %rdi,%rax
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800d36:	ba 00 00 00 00       	mov    $0x0,%edx
  800d3b:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  800d3f:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  800d42:	48 83 c2 01          	add    $0x1,%rdx
  800d46:	84 c9                	test   %cl,%cl
  800d48:	75 f1                	jne    800d3b <strcpy+0xc>
        ;
    return res;
}
  800d4a:	c3                   	ret

0000000000800d4b <strcat>:

char *
strcat(char *dst, const char *src) {
  800d4b:	f3 0f 1e fa          	endbr64
  800d4f:	55                   	push   %rbp
  800d50:	48 89 e5             	mov    %rsp,%rbp
  800d53:	41 54                	push   %r12
  800d55:	53                   	push   %rbx
  800d56:	48 89 fb             	mov    %rdi,%rbx
  800d59:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800d5c:	48 b8 ea 0c 80 00 00 	movabs $0x800cea,%rax
  800d63:	00 00 00 
  800d66:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800d68:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800d6c:	4c 89 e6             	mov    %r12,%rsi
  800d6f:	48 b8 2f 0d 80 00 00 	movabs $0x800d2f,%rax
  800d76:	00 00 00 
  800d79:	ff d0                	call   *%rax
    return dst;
}
  800d7b:	48 89 d8             	mov    %rbx,%rax
  800d7e:	5b                   	pop    %rbx
  800d7f:	41 5c                	pop    %r12
  800d81:	5d                   	pop    %rbp
  800d82:	c3                   	ret

0000000000800d83 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800d83:	f3 0f 1e fa          	endbr64
  800d87:	48 89 f8             	mov    %rdi,%rax
    char *ret = dst;
    while (size-- > 0) {
  800d8a:	48 85 d2             	test   %rdx,%rdx
  800d8d:	74 1f                	je     800dae <strncpy+0x2b>
  800d8f:	48 01 fa             	add    %rdi,%rdx
  800d92:	48 89 f9             	mov    %rdi,%rcx
        *dst++ = *src;
  800d95:	48 83 c1 01          	add    $0x1,%rcx
  800d99:	44 0f b6 06          	movzbl (%rsi),%r8d
  800d9d:	44 88 41 ff          	mov    %r8b,-0x1(%rcx)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800da1:	41 80 f8 01          	cmp    $0x1,%r8b
  800da5:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800da9:	48 39 ca             	cmp    %rcx,%rdx
  800dac:	75 e7                	jne    800d95 <strncpy+0x12>
    }
    return ret;
}
  800dae:	c3                   	ret

0000000000800daf <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
  800daf:	f3 0f 1e fa          	endbr64
    char *dst_in = dst;
    if (size) {
  800db3:	48 89 f8             	mov    %rdi,%rax
  800db6:	48 85 d2             	test   %rdx,%rdx
  800db9:	74 24                	je     800ddf <strlcpy+0x30>
        while (--size > 0 && *src)
  800dbb:	48 83 ea 01          	sub    $0x1,%rdx
  800dbf:	74 1b                	je     800ddc <strlcpy+0x2d>
  800dc1:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800dc5:	0f b6 16             	movzbl (%rsi),%edx
  800dc8:	84 d2                	test   %dl,%dl
  800dca:	74 10                	je     800ddc <strlcpy+0x2d>
            *dst++ = *src++;
  800dcc:	48 83 c6 01          	add    $0x1,%rsi
  800dd0:	48 83 c0 01          	add    $0x1,%rax
  800dd4:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800dd7:	48 39 c8             	cmp    %rcx,%rax
  800dda:	75 e9                	jne    800dc5 <strlcpy+0x16>
        *dst = '\0';
  800ddc:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800ddf:	48 29 f8             	sub    %rdi,%rax
}
  800de2:	c3                   	ret

0000000000800de3 <strcmp>:
    }
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
  800de3:	f3 0f 1e fa          	endbr64
    while (*p && *p == *q) p++, q++;
  800de7:	0f b6 07             	movzbl (%rdi),%eax
  800dea:	84 c0                	test   %al,%al
  800dec:	74 13                	je     800e01 <strcmp+0x1e>
  800dee:	38 06                	cmp    %al,(%rsi)
  800df0:	75 0f                	jne    800e01 <strcmp+0x1e>
  800df2:	48 83 c7 01          	add    $0x1,%rdi
  800df6:	48 83 c6 01          	add    $0x1,%rsi
  800dfa:	0f b6 07             	movzbl (%rdi),%eax
  800dfd:	84 c0                	test   %al,%al
  800dff:	75 ed                	jne    800dee <strcmp+0xb>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800e01:	0f b6 c0             	movzbl %al,%eax
  800e04:	0f b6 16             	movzbl (%rsi),%edx
  800e07:	29 d0                	sub    %edx,%eax
}
  800e09:	c3                   	ret

0000000000800e0a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
  800e0a:	f3 0f 1e fa          	endbr64
    while (n && *p && *p == *q) n--, p++, q++;
  800e0e:	48 85 d2             	test   %rdx,%rdx
  800e11:	74 1f                	je     800e32 <strncmp+0x28>
  800e13:	0f b6 07             	movzbl (%rdi),%eax
  800e16:	84 c0                	test   %al,%al
  800e18:	74 1e                	je     800e38 <strncmp+0x2e>
  800e1a:	3a 06                	cmp    (%rsi),%al
  800e1c:	75 1a                	jne    800e38 <strncmp+0x2e>
  800e1e:	48 83 c7 01          	add    $0x1,%rdi
  800e22:	48 83 c6 01          	add    $0x1,%rsi
  800e26:	48 83 ea 01          	sub    $0x1,%rdx
  800e2a:	75 e7                	jne    800e13 <strncmp+0x9>

    if (!n) return 0;
  800e2c:	b8 00 00 00 00       	mov    $0x0,%eax
  800e31:	c3                   	ret
  800e32:	b8 00 00 00 00       	mov    $0x0,%eax
  800e37:	c3                   	ret

    return (int)((unsigned char)*p - (unsigned char)*q);
  800e38:	0f b6 07             	movzbl (%rdi),%eax
  800e3b:	0f b6 16             	movzbl (%rsi),%edx
  800e3e:	29 d0                	sub    %edx,%eax
}
  800e40:	c3                   	ret

0000000000800e41 <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
  800e41:	f3 0f 1e fa          	endbr64
    for (; *str; str++) {
  800e45:	0f b6 17             	movzbl (%rdi),%edx
  800e48:	84 d2                	test   %dl,%dl
  800e4a:	74 18                	je     800e64 <strchr+0x23>
        if (*str == c) {
  800e4c:	0f be d2             	movsbl %dl,%edx
  800e4f:	39 f2                	cmp    %esi,%edx
  800e51:	74 17                	je     800e6a <strchr+0x29>
    for (; *str; str++) {
  800e53:	48 83 c7 01          	add    $0x1,%rdi
  800e57:	0f b6 17             	movzbl (%rdi),%edx
  800e5a:	84 d2                	test   %dl,%dl
  800e5c:	75 ee                	jne    800e4c <strchr+0xb>
            return (char *)str;
        }
    }
    return NULL;
  800e5e:	b8 00 00 00 00       	mov    $0x0,%eax
  800e63:	c3                   	ret
  800e64:	b8 00 00 00 00       	mov    $0x0,%eax
  800e69:	c3                   	ret
            return (char *)str;
  800e6a:	48 89 f8             	mov    %rdi,%rax
}
  800e6d:	c3                   	ret

0000000000800e6e <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
  800e6e:	f3 0f 1e fa          	endbr64
  800e72:	48 89 f8             	mov    %rdi,%rax
    for (; *str && *str != ch; str++) /* nothing */
  800e75:	0f b6 17             	movzbl (%rdi),%edx
  800e78:	84 d2                	test   %dl,%dl
  800e7a:	74 13                	je     800e8f <strfind+0x21>
  800e7c:	0f be d2             	movsbl %dl,%edx
  800e7f:	39 f2                	cmp    %esi,%edx
  800e81:	74 0b                	je     800e8e <strfind+0x20>
  800e83:	48 83 c0 01          	add    $0x1,%rax
  800e87:	0f b6 10             	movzbl (%rax),%edx
  800e8a:	84 d2                	test   %dl,%dl
  800e8c:	75 ee                	jne    800e7c <strfind+0xe>
        ;
    return (char *)str;
}
  800e8e:	c3                   	ret
  800e8f:	c3                   	ret

0000000000800e90 <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  800e90:	f3 0f 1e fa          	endbr64
  800e94:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  800e97:	48 89 f8             	mov    %rdi,%rax
  800e9a:	48 f7 d8             	neg    %rax
  800e9d:	83 e0 07             	and    $0x7,%eax
  800ea0:	49 89 d1             	mov    %rdx,%r9
  800ea3:	49 29 c1             	sub    %rax,%r9
  800ea6:	78 36                	js     800ede <memset+0x4e>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  800ea8:	40 0f b6 c6          	movzbl %sil,%eax
  800eac:	48 b9 01 01 01 01 01 	movabs $0x101010101010101,%rcx
  800eb3:	01 01 01 
  800eb6:	48 0f af c1          	imul   %rcx,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  800eba:	40 f6 c7 07          	test   $0x7,%dil
  800ebe:	75 38                	jne    800ef8 <memset+0x68>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  800ec0:	4c 89 c9             	mov    %r9,%rcx
  800ec3:	48 c1 f9 03          	sar    $0x3,%rcx
  800ec7:	74 0c                	je     800ed5 <memset+0x45>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  800ec9:	fc                   	cld
  800eca:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  800ecd:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  800ed1:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  800ed5:	4d 85 c9             	test   %r9,%r9
  800ed8:	75 45                	jne    800f1f <memset+0x8f>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  800eda:	4c 89 c0             	mov    %r8,%rax
  800edd:	c3                   	ret
        while (n-- > 0) *ptr++ = c;
  800ede:	48 85 d2             	test   %rdx,%rdx
  800ee1:	74 f7                	je     800eda <memset+0x4a>
  800ee3:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  800ee6:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  800ee9:	48 83 c0 01          	add    $0x1,%rax
  800eed:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  800ef1:	48 39 c2             	cmp    %rax,%rdx
  800ef4:	75 f3                	jne    800ee9 <memset+0x59>
  800ef6:	eb e2                	jmp    800eda <memset+0x4a>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  800ef8:	40 f6 c7 01          	test   $0x1,%dil
  800efc:	74 06                	je     800f04 <memset+0x74>
  800efe:	88 07                	mov    %al,(%rdi)
  800f00:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  800f04:	40 f6 c7 02          	test   $0x2,%dil
  800f08:	74 07                	je     800f11 <memset+0x81>
  800f0a:	66 89 07             	mov    %ax,(%rdi)
  800f0d:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  800f11:	40 f6 c7 04          	test   $0x4,%dil
  800f15:	74 a9                	je     800ec0 <memset+0x30>
  800f17:	89 07                	mov    %eax,(%rdi)
  800f19:	48 83 c7 04          	add    $0x4,%rdi
  800f1d:	eb a1                	jmp    800ec0 <memset+0x30>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  800f1f:	41 f6 c1 04          	test   $0x4,%r9b
  800f23:	74 1b                	je     800f40 <memset+0xb0>
  800f25:	89 07                	mov    %eax,(%rdi)
  800f27:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800f2b:	41 f6 c1 02          	test   $0x2,%r9b
  800f2f:	74 07                	je     800f38 <memset+0xa8>
  800f31:	66 89 07             	mov    %ax,(%rdi)
  800f34:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  800f38:	41 f6 c1 01          	test   $0x1,%r9b
  800f3c:	74 9c                	je     800eda <memset+0x4a>
  800f3e:	eb 06                	jmp    800f46 <memset+0xb6>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800f40:	41 f6 c1 02          	test   $0x2,%r9b
  800f44:	75 eb                	jne    800f31 <memset+0xa1>
        if (ni & 1) *ptr = k;
  800f46:	88 07                	mov    %al,(%rdi)
  800f48:	eb 90                	jmp    800eda <memset+0x4a>

0000000000800f4a <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  800f4a:	f3 0f 1e fa          	endbr64
  800f4e:	48 89 f8             	mov    %rdi,%rax
  800f51:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  800f54:	48 39 fe             	cmp    %rdi,%rsi
  800f57:	73 3b                	jae    800f94 <memmove+0x4a>
  800f59:	48 8d 14 16          	lea    (%rsi,%rdx,1),%rdx
  800f5d:	48 39 d7             	cmp    %rdx,%rdi
  800f60:	73 32                	jae    800f94 <memmove+0x4a>
        s += n;
        d += n;
  800f62:	48 8d 3c 0f          	lea    (%rdi,%rcx,1),%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800f66:	48 89 d6             	mov    %rdx,%rsi
  800f69:	48 09 fe             	or     %rdi,%rsi
  800f6c:	48 09 ce             	or     %rcx,%rsi
  800f6f:	40 f6 c6 07          	test   $0x7,%sil
  800f73:	75 12                	jne    800f87 <memmove+0x3d>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  800f75:	48 83 ef 08          	sub    $0x8,%rdi
  800f79:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  800f7d:	48 c1 e9 03          	shr    $0x3,%rcx
  800f81:	fd                   	std
  800f82:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  800f85:	fc                   	cld
  800f86:	c3                   	ret
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  800f87:	48 83 ef 01          	sub    $0x1,%rdi
  800f8b:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  800f8f:	fd                   	std
  800f90:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  800f92:	eb f1                	jmp    800f85 <memmove+0x3b>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800f94:	48 89 f2             	mov    %rsi,%rdx
  800f97:	48 09 c2             	or     %rax,%rdx
  800f9a:	48 09 ca             	or     %rcx,%rdx
  800f9d:	f6 c2 07             	test   $0x7,%dl
  800fa0:	75 0c                	jne    800fae <memmove+0x64>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  800fa2:	48 c1 e9 03          	shr    $0x3,%rcx
  800fa6:	48 89 c7             	mov    %rax,%rdi
  800fa9:	fc                   	cld
  800faa:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  800fad:	c3                   	ret
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  800fae:	48 89 c7             	mov    %rax,%rdi
  800fb1:	fc                   	cld
  800fb2:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  800fb4:	c3                   	ret

0000000000800fb5 <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  800fb5:	f3 0f 1e fa          	endbr64
  800fb9:	55                   	push   %rbp
  800fba:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  800fbd:	48 b8 4a 0f 80 00 00 	movabs $0x800f4a,%rax
  800fc4:	00 00 00 
  800fc7:	ff d0                	call   *%rax
}
  800fc9:	5d                   	pop    %rbp
  800fca:	c3                   	ret

0000000000800fcb <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  800fcb:	f3 0f 1e fa          	endbr64
  800fcf:	55                   	push   %rbp
  800fd0:	48 89 e5             	mov    %rsp,%rbp
  800fd3:	41 57                	push   %r15
  800fd5:	41 56                	push   %r14
  800fd7:	41 55                	push   %r13
  800fd9:	41 54                	push   %r12
  800fdb:	53                   	push   %rbx
  800fdc:	48 83 ec 08          	sub    $0x8,%rsp
  800fe0:	49 89 fe             	mov    %rdi,%r14
  800fe3:	49 89 f7             	mov    %rsi,%r15
  800fe6:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  800fe9:	48 89 f7             	mov    %rsi,%rdi
  800fec:	48 b8 ea 0c 80 00 00 	movabs $0x800cea,%rax
  800ff3:	00 00 00 
  800ff6:	ff d0                	call   *%rax
  800ff8:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  800ffb:	48 89 de             	mov    %rbx,%rsi
  800ffe:	4c 89 f7             	mov    %r14,%rdi
  801001:	48 b8 09 0d 80 00 00 	movabs $0x800d09,%rax
  801008:	00 00 00 
  80100b:	ff d0                	call   *%rax
  80100d:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  801010:	48 39 c3             	cmp    %rax,%rbx
  801013:	74 36                	je     80104b <strlcat+0x80>
    if (srclen < maxlen - dstlen) {
  801015:	48 89 d8             	mov    %rbx,%rax
  801018:	4c 29 e8             	sub    %r13,%rax
  80101b:	49 39 c4             	cmp    %rax,%r12
  80101e:	73 31                	jae    801051 <strlcat+0x86>
        memcpy(dst + dstlen, src, srclen + 1);
  801020:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  801025:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  801029:	4c 89 fe             	mov    %r15,%rsi
  80102c:	48 b8 b5 0f 80 00 00 	movabs $0x800fb5,%rax
  801033:	00 00 00 
  801036:	ff d0                	call   *%rax
    return dstlen + srclen;
  801038:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  80103c:	48 83 c4 08          	add    $0x8,%rsp
  801040:	5b                   	pop    %rbx
  801041:	41 5c                	pop    %r12
  801043:	41 5d                	pop    %r13
  801045:	41 5e                	pop    %r14
  801047:	41 5f                	pop    %r15
  801049:	5d                   	pop    %rbp
  80104a:	c3                   	ret
    if (dstlen == maxlen) return maxlen + srclen;
  80104b:	49 8d 04 04          	lea    (%r12,%rax,1),%rax
  80104f:	eb eb                	jmp    80103c <strlcat+0x71>
        memcpy(dst + dstlen, src, maxlen - 1);
  801051:	48 83 eb 01          	sub    $0x1,%rbx
  801055:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  801059:	48 89 da             	mov    %rbx,%rdx
  80105c:	4c 89 fe             	mov    %r15,%rsi
  80105f:	48 b8 b5 0f 80 00 00 	movabs $0x800fb5,%rax
  801066:	00 00 00 
  801069:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  80106b:	49 01 de             	add    %rbx,%r14
  80106e:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  801073:	eb c3                	jmp    801038 <strlcat+0x6d>

0000000000801075 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  801075:	f3 0f 1e fa          	endbr64
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  801079:	48 85 d2             	test   %rdx,%rdx
  80107c:	74 2d                	je     8010ab <memcmp+0x36>
  80107e:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  801083:	0f b6 0c 07          	movzbl (%rdi,%rax,1),%ecx
  801087:	44 0f b6 04 06       	movzbl (%rsi,%rax,1),%r8d
  80108c:	44 38 c1             	cmp    %r8b,%cl
  80108f:	75 0f                	jne    8010a0 <memcmp+0x2b>
    while (n-- > 0) {
  801091:	48 83 c0 01          	add    $0x1,%rax
  801095:	48 39 c2             	cmp    %rax,%rdx
  801098:	75 e9                	jne    801083 <memcmp+0xe>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  80109a:	b8 00 00 00 00       	mov    $0x0,%eax
  80109f:	c3                   	ret
            return (int)*s1 - (int)*s2;
  8010a0:	0f b6 c1             	movzbl %cl,%eax
  8010a3:	45 0f b6 c0          	movzbl %r8b,%r8d
  8010a7:	44 29 c0             	sub    %r8d,%eax
  8010aa:	c3                   	ret
    return 0;
  8010ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010b0:	c3                   	ret

00000000008010b1 <memfind>:

void *
memfind(const void *src, int c, size_t n) {
  8010b1:	f3 0f 1e fa          	endbr64
    const void *end = (const char *)src + n;
  8010b5:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  8010b9:	48 39 c7             	cmp    %rax,%rdi
  8010bc:	73 0f                	jae    8010cd <memfind+0x1c>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  8010be:	40 38 37             	cmp    %sil,(%rdi)
  8010c1:	74 0e                	je     8010d1 <memfind+0x20>
    for (; src < end; src++) {
  8010c3:	48 83 c7 01          	add    $0x1,%rdi
  8010c7:	48 39 f8             	cmp    %rdi,%rax
  8010ca:	75 f2                	jne    8010be <memfind+0xd>
  8010cc:	c3                   	ret
  8010cd:	48 89 f8             	mov    %rdi,%rax
  8010d0:	c3                   	ret
  8010d1:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  8010d4:	c3                   	ret

00000000008010d5 <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  8010d5:	f3 0f 1e fa          	endbr64
  8010d9:	49 89 f2             	mov    %rsi,%r10
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  8010dc:	0f b6 37             	movzbl (%rdi),%esi
  8010df:	40 80 fe 20          	cmp    $0x20,%sil
  8010e3:	74 06                	je     8010eb <strtol+0x16>
  8010e5:	40 80 fe 09          	cmp    $0x9,%sil
  8010e9:	75 13                	jne    8010fe <strtol+0x29>
  8010eb:	48 83 c7 01          	add    $0x1,%rdi
  8010ef:	0f b6 37             	movzbl (%rdi),%esi
  8010f2:	40 80 fe 20          	cmp    $0x20,%sil
  8010f6:	74 f3                	je     8010eb <strtol+0x16>
  8010f8:	40 80 fe 09          	cmp    $0x9,%sil
  8010fc:	74 ed                	je     8010eb <strtol+0x16>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  8010fe:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  801101:	83 e0 fd             	and    $0xfffffffd,%eax
  801104:	3c 01                	cmp    $0x1,%al
  801106:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  80110a:	f7 c2 ef ff ff ff    	test   $0xffffffef,%edx
  801110:	75 0f                	jne    801121 <strtol+0x4c>
  801112:	80 3f 30             	cmpb   $0x30,(%rdi)
  801115:	74 14                	je     80112b <strtol+0x56>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  801117:	85 d2                	test   %edx,%edx
  801119:	b8 0a 00 00 00       	mov    $0xa,%eax
  80111e:	0f 44 d0             	cmove  %eax,%edx
    }

    /* Digits */
    long val = 0;
  801121:	b8 00 00 00 00       	mov    $0x0,%eax
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  801126:	4c 63 ca             	movslq %edx,%r9
  801129:	eb 36                	jmp    801161 <strtol+0x8c>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  80112b:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  80112f:	74 0f                	je     801140 <strtol+0x6b>
    } else if (!base && s[0] == '0') {
  801131:	85 d2                	test   %edx,%edx
  801133:	75 ec                	jne    801121 <strtol+0x4c>
        s++;
  801135:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  801139:	ba 08 00 00 00       	mov    $0x8,%edx
        s++;
  80113e:	eb e1                	jmp    801121 <strtol+0x4c>
        s += 2;
  801140:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  801144:	ba 10 00 00 00       	mov    $0x10,%edx
        s += 2;
  801149:	eb d6                	jmp    801121 <strtol+0x4c>
            dig -= '0';
  80114b:	83 e9 30             	sub    $0x30,%ecx
        if (dig >= base) break;
  80114e:	44 0f b6 c1          	movzbl %cl,%r8d
  801152:	41 39 d0             	cmp    %edx,%r8d
  801155:	7d 21                	jge    801178 <strtol+0xa3>
        val = val * base + dig;
  801157:	49 0f af c1          	imul   %r9,%rax
  80115b:	0f b6 c9             	movzbl %cl,%ecx
  80115e:	48 01 c8             	add    %rcx,%rax
        uint8_t dig = *s++;
  801161:	48 83 c7 01          	add    $0x1,%rdi
  801165:	0f b6 4f ff          	movzbl -0x1(%rdi),%ecx
        if (dig - '0' < 10)
  801169:	80 f9 39             	cmp    $0x39,%cl
  80116c:	76 dd                	jbe    80114b <strtol+0x76>
        else if (dig - 'a' < 27)
  80116e:	80 f9 7b             	cmp    $0x7b,%cl
  801171:	77 05                	ja     801178 <strtol+0xa3>
            dig -= 'a' - 10;
  801173:	83 e9 57             	sub    $0x57,%ecx
  801176:	eb d6                	jmp    80114e <strtol+0x79>
    }

    if (endptr) *endptr = (char *)s;
  801178:	4d 85 d2             	test   %r10,%r10
  80117b:	74 03                	je     801180 <strtol+0xab>
  80117d:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  801180:	48 89 c2             	mov    %rax,%rdx
  801183:	48 f7 da             	neg    %rdx
  801186:	40 80 fe 2d          	cmp    $0x2d,%sil
  80118a:	48 0f 44 c2          	cmove  %rdx,%rax
}
  80118e:	c3                   	ret

000000000080118f <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  80118f:	f3 0f 1e fa          	endbr64
  801193:	55                   	push   %rbp
  801194:	48 89 e5             	mov    %rsp,%rbp
  801197:	53                   	push   %rbx
  801198:	48 89 fa             	mov    %rdi,%rdx
  80119b:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80119e:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8011a3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011a8:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8011ad:	be 00 00 00 00       	mov    $0x0,%esi
  8011b2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8011b8:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  8011ba:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011be:	c9                   	leave
  8011bf:	c3                   	ret

00000000008011c0 <sys_cgetc>:

int
sys_cgetc(void) {
  8011c0:	f3 0f 1e fa          	endbr64
  8011c4:	55                   	push   %rbp
  8011c5:	48 89 e5             	mov    %rsp,%rbp
  8011c8:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8011c9:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8011ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8011d3:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8011d8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011dd:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8011e2:	be 00 00 00 00       	mov    $0x0,%esi
  8011e7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8011ed:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  8011ef:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011f3:	c9                   	leave
  8011f4:	c3                   	ret

00000000008011f5 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  8011f5:	f3 0f 1e fa          	endbr64
  8011f9:	55                   	push   %rbp
  8011fa:	48 89 e5             	mov    %rsp,%rbp
  8011fd:	53                   	push   %rbx
  8011fe:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  801202:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801205:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80120a:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80120f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801214:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801219:	be 00 00 00 00       	mov    $0x0,%esi
  80121e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801224:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801226:	48 85 c0             	test   %rax,%rax
  801229:	7f 06                	jg     801231 <sys_env_destroy+0x3c>
}
  80122b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80122f:	c9                   	leave
  801230:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801231:	49 89 c0             	mov    %rax,%r8
  801234:	b9 03 00 00 00       	mov    $0x3,%ecx
  801239:	48 ba f8 32 80 00 00 	movabs $0x8032f8,%rdx
  801240:	00 00 00 
  801243:	be 26 00 00 00       	mov    $0x26,%esi
  801248:	48 bf ef 31 80 00 00 	movabs $0x8031ef,%rdi
  80124f:	00 00 00 
  801252:	b8 00 00 00 00       	mov    $0x0,%eax
  801257:	49 b9 8a 02 80 00 00 	movabs $0x80028a,%r9
  80125e:	00 00 00 
  801261:	41 ff d1             	call   *%r9

0000000000801264 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  801264:	f3 0f 1e fa          	endbr64
  801268:	55                   	push   %rbp
  801269:	48 89 e5             	mov    %rsp,%rbp
  80126c:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80126d:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801272:	ba 00 00 00 00       	mov    $0x0,%edx
  801277:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80127c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801281:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801286:	be 00 00 00 00       	mov    $0x0,%esi
  80128b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801291:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  801293:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801297:	c9                   	leave
  801298:	c3                   	ret

0000000000801299 <sys_yield>:

void
sys_yield(void) {
  801299:	f3 0f 1e fa          	endbr64
  80129d:	55                   	push   %rbp
  80129e:	48 89 e5             	mov    %rsp,%rbp
  8012a1:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8012a2:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8012a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8012ac:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8012b1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012b6:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012bb:	be 00 00 00 00       	mov    $0x0,%esi
  8012c0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8012c6:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  8012c8:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012cc:	c9                   	leave
  8012cd:	c3                   	ret

00000000008012ce <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  8012ce:	f3 0f 1e fa          	endbr64
  8012d2:	55                   	push   %rbp
  8012d3:	48 89 e5             	mov    %rsp,%rbp
  8012d6:	53                   	push   %rbx
  8012d7:	48 89 fa             	mov    %rdi,%rdx
  8012da:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8012dd:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8012e2:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  8012e9:	00 00 00 
  8012ec:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012f1:	be 00 00 00 00       	mov    $0x0,%esi
  8012f6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8012fc:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  8012fe:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801302:	c9                   	leave
  801303:	c3                   	ret

0000000000801304 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  801304:	f3 0f 1e fa          	endbr64
  801308:	55                   	push   %rbp
  801309:	48 89 e5             	mov    %rsp,%rbp
  80130c:	53                   	push   %rbx
  80130d:	49 89 f8             	mov    %rdi,%r8
  801310:	48 89 d3             	mov    %rdx,%rbx
  801313:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  801316:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80131b:	4c 89 c2             	mov    %r8,%rdx
  80131e:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801321:	be 00 00 00 00       	mov    $0x0,%esi
  801326:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80132c:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  80132e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801332:	c9                   	leave
  801333:	c3                   	ret

0000000000801334 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  801334:	f3 0f 1e fa          	endbr64
  801338:	55                   	push   %rbp
  801339:	48 89 e5             	mov    %rsp,%rbp
  80133c:	53                   	push   %rbx
  80133d:	48 83 ec 08          	sub    $0x8,%rsp
  801341:	89 f8                	mov    %edi,%eax
  801343:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  801346:	48 63 f9             	movslq %ecx,%rdi
  801349:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80134c:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801351:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801354:	be 00 00 00 00       	mov    $0x0,%esi
  801359:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80135f:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801361:	48 85 c0             	test   %rax,%rax
  801364:	7f 06                	jg     80136c <sys_alloc_region+0x38>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  801366:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80136a:	c9                   	leave
  80136b:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80136c:	49 89 c0             	mov    %rax,%r8
  80136f:	b9 04 00 00 00       	mov    $0x4,%ecx
  801374:	48 ba f8 32 80 00 00 	movabs $0x8032f8,%rdx
  80137b:	00 00 00 
  80137e:	be 26 00 00 00       	mov    $0x26,%esi
  801383:	48 bf ef 31 80 00 00 	movabs $0x8031ef,%rdi
  80138a:	00 00 00 
  80138d:	b8 00 00 00 00       	mov    $0x0,%eax
  801392:	49 b9 8a 02 80 00 00 	movabs $0x80028a,%r9
  801399:	00 00 00 
  80139c:	41 ff d1             	call   *%r9

000000000080139f <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  80139f:	f3 0f 1e fa          	endbr64
  8013a3:	55                   	push   %rbp
  8013a4:	48 89 e5             	mov    %rsp,%rbp
  8013a7:	53                   	push   %rbx
  8013a8:	48 83 ec 08          	sub    $0x8,%rsp
  8013ac:	89 f8                	mov    %edi,%eax
  8013ae:	49 89 f2             	mov    %rsi,%r10
  8013b1:	48 89 cf             	mov    %rcx,%rdi
  8013b4:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  8013b7:	48 63 da             	movslq %edx,%rbx
  8013ba:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8013bd:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8013c2:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013c5:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  8013c8:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8013ca:	48 85 c0             	test   %rax,%rax
  8013cd:	7f 06                	jg     8013d5 <sys_map_region+0x36>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  8013cf:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013d3:	c9                   	leave
  8013d4:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8013d5:	49 89 c0             	mov    %rax,%r8
  8013d8:	b9 05 00 00 00       	mov    $0x5,%ecx
  8013dd:	48 ba f8 32 80 00 00 	movabs $0x8032f8,%rdx
  8013e4:	00 00 00 
  8013e7:	be 26 00 00 00       	mov    $0x26,%esi
  8013ec:	48 bf ef 31 80 00 00 	movabs $0x8031ef,%rdi
  8013f3:	00 00 00 
  8013f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8013fb:	49 b9 8a 02 80 00 00 	movabs $0x80028a,%r9
  801402:	00 00 00 
  801405:	41 ff d1             	call   *%r9

0000000000801408 <sys_map_physical_region>:

int
sys_map_physical_region(uintptr_t pa, envid_t dstenv, void *dstva, size_t size, int perm) {
  801408:	f3 0f 1e fa          	endbr64
  80140c:	55                   	push   %rbp
  80140d:	48 89 e5             	mov    %rsp,%rbp
  801410:	53                   	push   %rbx
  801411:	48 83 ec 08          	sub    $0x8,%rsp
  801415:	49 89 f9             	mov    %rdi,%r9
  801418:	89 f0                	mov    %esi,%eax
  80141a:	48 89 d3             	mov    %rdx,%rbx
  80141d:	48 89 cf             	mov    %rcx,%rdi
    int res = syscall(SYS_map_physical_region, 1, pa, dstenv, (uintptr_t)dstva, size, perm, 0);
  801420:	49 63 f0             	movslq %r8d,%rsi
  801423:	48 63 c8             	movslq %eax,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801426:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80142b:	4c 89 ca             	mov    %r9,%rdx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80142e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801434:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801436:	48 85 c0             	test   %rax,%rax
  801439:	7f 06                	jg     801441 <sys_map_physical_region+0x39>
#ifdef SANITIZE_USER_SHADOW_BASE
    platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  80143b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80143f:	c9                   	leave
  801440:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801441:	49 89 c0             	mov    %rax,%r8
  801444:	b9 06 00 00 00       	mov    $0x6,%ecx
  801449:	48 ba f8 32 80 00 00 	movabs $0x8032f8,%rdx
  801450:	00 00 00 
  801453:	be 26 00 00 00       	mov    $0x26,%esi
  801458:	48 bf ef 31 80 00 00 	movabs $0x8031ef,%rdi
  80145f:	00 00 00 
  801462:	b8 00 00 00 00       	mov    $0x0,%eax
  801467:	49 b9 8a 02 80 00 00 	movabs $0x80028a,%r9
  80146e:	00 00 00 
  801471:	41 ff d1             	call   *%r9

0000000000801474 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  801474:	f3 0f 1e fa          	endbr64
  801478:	55                   	push   %rbp
  801479:	48 89 e5             	mov    %rsp,%rbp
  80147c:	53                   	push   %rbx
  80147d:	48 83 ec 08          	sub    $0x8,%rsp
  801481:	48 89 f1             	mov    %rsi,%rcx
  801484:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  801487:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80148a:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80148f:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801494:	be 00 00 00 00       	mov    $0x0,%esi
  801499:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80149f:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8014a1:	48 85 c0             	test   %rax,%rax
  8014a4:	7f 06                	jg     8014ac <sys_unmap_region+0x38>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  8014a6:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014aa:	c9                   	leave
  8014ab:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8014ac:	49 89 c0             	mov    %rax,%r8
  8014af:	b9 07 00 00 00       	mov    $0x7,%ecx
  8014b4:	48 ba f8 32 80 00 00 	movabs $0x8032f8,%rdx
  8014bb:	00 00 00 
  8014be:	be 26 00 00 00       	mov    $0x26,%esi
  8014c3:	48 bf ef 31 80 00 00 	movabs $0x8031ef,%rdi
  8014ca:	00 00 00 
  8014cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d2:	49 b9 8a 02 80 00 00 	movabs $0x80028a,%r9
  8014d9:	00 00 00 
  8014dc:	41 ff d1             	call   *%r9

00000000008014df <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  8014df:	f3 0f 1e fa          	endbr64
  8014e3:	55                   	push   %rbp
  8014e4:	48 89 e5             	mov    %rsp,%rbp
  8014e7:	53                   	push   %rbx
  8014e8:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  8014ec:	48 63 ce             	movslq %esi,%rcx
  8014ef:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8014f2:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8014f7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014fc:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801501:	be 00 00 00 00       	mov    $0x0,%esi
  801506:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80150c:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80150e:	48 85 c0             	test   %rax,%rax
  801511:	7f 06                	jg     801519 <sys_env_set_status+0x3a>
}
  801513:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801517:	c9                   	leave
  801518:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801519:	49 89 c0             	mov    %rax,%r8
  80151c:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801521:	48 ba f8 32 80 00 00 	movabs $0x8032f8,%rdx
  801528:	00 00 00 
  80152b:	be 26 00 00 00       	mov    $0x26,%esi
  801530:	48 bf ef 31 80 00 00 	movabs $0x8031ef,%rdi
  801537:	00 00 00 
  80153a:	b8 00 00 00 00       	mov    $0x0,%eax
  80153f:	49 b9 8a 02 80 00 00 	movabs $0x80028a,%r9
  801546:	00 00 00 
  801549:	41 ff d1             	call   *%r9

000000000080154c <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  80154c:	f3 0f 1e fa          	endbr64
  801550:	55                   	push   %rbp
  801551:	48 89 e5             	mov    %rsp,%rbp
  801554:	53                   	push   %rbx
  801555:	48 83 ec 08          	sub    $0x8,%rsp
  801559:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  80155c:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80155f:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801564:	bb 00 00 00 00       	mov    $0x0,%ebx
  801569:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80156e:	be 00 00 00 00       	mov    $0x0,%esi
  801573:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801579:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80157b:	48 85 c0             	test   %rax,%rax
  80157e:	7f 06                	jg     801586 <sys_env_set_trapframe+0x3a>
}
  801580:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801584:	c9                   	leave
  801585:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801586:	49 89 c0             	mov    %rax,%r8
  801589:	b9 0b 00 00 00       	mov    $0xb,%ecx
  80158e:	48 ba f8 32 80 00 00 	movabs $0x8032f8,%rdx
  801595:	00 00 00 
  801598:	be 26 00 00 00       	mov    $0x26,%esi
  80159d:	48 bf ef 31 80 00 00 	movabs $0x8031ef,%rdi
  8015a4:	00 00 00 
  8015a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ac:	49 b9 8a 02 80 00 00 	movabs $0x80028a,%r9
  8015b3:	00 00 00 
  8015b6:	41 ff d1             	call   *%r9

00000000008015b9 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  8015b9:	f3 0f 1e fa          	endbr64
  8015bd:	55                   	push   %rbp
  8015be:	48 89 e5             	mov    %rsp,%rbp
  8015c1:	53                   	push   %rbx
  8015c2:	48 83 ec 08          	sub    $0x8,%rsp
  8015c6:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  8015c9:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8015cc:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8015d1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015d6:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8015db:	be 00 00 00 00       	mov    $0x0,%esi
  8015e0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8015e6:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8015e8:	48 85 c0             	test   %rax,%rax
  8015eb:	7f 06                	jg     8015f3 <sys_env_set_pgfault_upcall+0x3a>
}
  8015ed:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8015f1:	c9                   	leave
  8015f2:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8015f3:	49 89 c0             	mov    %rax,%r8
  8015f6:	b9 0c 00 00 00       	mov    $0xc,%ecx
  8015fb:	48 ba f8 32 80 00 00 	movabs $0x8032f8,%rdx
  801602:	00 00 00 
  801605:	be 26 00 00 00       	mov    $0x26,%esi
  80160a:	48 bf ef 31 80 00 00 	movabs $0x8031ef,%rdi
  801611:	00 00 00 
  801614:	b8 00 00 00 00       	mov    $0x0,%eax
  801619:	49 b9 8a 02 80 00 00 	movabs $0x80028a,%r9
  801620:	00 00 00 
  801623:	41 ff d1             	call   *%r9

0000000000801626 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  801626:	f3 0f 1e fa          	endbr64
  80162a:	55                   	push   %rbp
  80162b:	48 89 e5             	mov    %rsp,%rbp
  80162e:	53                   	push   %rbx
  80162f:	89 f8                	mov    %edi,%eax
  801631:	49 89 f1             	mov    %rsi,%r9
  801634:	48 89 d3             	mov    %rdx,%rbx
  801637:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  80163a:	49 63 f0             	movslq %r8d,%rsi
  80163d:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801640:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801645:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801648:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80164e:	cd 30                	int    $0x30
}
  801650:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801654:	c9                   	leave
  801655:	c3                   	ret

0000000000801656 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  801656:	f3 0f 1e fa          	endbr64
  80165a:	55                   	push   %rbp
  80165b:	48 89 e5             	mov    %rsp,%rbp
  80165e:	53                   	push   %rbx
  80165f:	48 83 ec 08          	sub    $0x8,%rsp
  801663:	48 89 fa             	mov    %rdi,%rdx
  801666:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801669:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80166e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801673:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801678:	be 00 00 00 00       	mov    $0x0,%esi
  80167d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801683:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801685:	48 85 c0             	test   %rax,%rax
  801688:	7f 06                	jg     801690 <sys_ipc_recv+0x3a>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  80168a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80168e:	c9                   	leave
  80168f:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801690:	49 89 c0             	mov    %rax,%r8
  801693:	b9 0f 00 00 00       	mov    $0xf,%ecx
  801698:	48 ba f8 32 80 00 00 	movabs $0x8032f8,%rdx
  80169f:	00 00 00 
  8016a2:	be 26 00 00 00       	mov    $0x26,%esi
  8016a7:	48 bf ef 31 80 00 00 	movabs $0x8031ef,%rdi
  8016ae:	00 00 00 
  8016b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b6:	49 b9 8a 02 80 00 00 	movabs $0x80028a,%r9
  8016bd:	00 00 00 
  8016c0:	41 ff d1             	call   *%r9

00000000008016c3 <sys_gettime>:

int
sys_gettime(void) {
  8016c3:	f3 0f 1e fa          	endbr64
  8016c7:	55                   	push   %rbp
  8016c8:	48 89 e5             	mov    %rsp,%rbp
  8016cb:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8016cc:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8016d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8016d6:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8016db:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016e0:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8016e5:	be 00 00 00 00       	mov    $0x0,%esi
  8016ea:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8016f0:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  8016f2:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8016f6:	c9                   	leave
  8016f7:	c3                   	ret

00000000008016f8 <fd2num>:


/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
  8016f8:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8016fc:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801703:	ff ff ff 
  801706:	48 01 f8             	add    %rdi,%rax
  801709:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80170d:	c3                   	ret

000000000080170e <fd2data>:

char *
fd2data(struct Fd *fd) {
  80170e:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801712:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801719:	ff ff ff 
  80171c:	48 01 f8             	add    %rdi,%rax
  80171f:	48 c1 e8 0c          	shr    $0xc,%rax
    return INDEX2DATA(fd2num(fd));
  801723:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801729:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80172d:	c3                   	ret

000000000080172e <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  80172e:	f3 0f 1e fa          	endbr64
  801732:	55                   	push   %rbp
  801733:	48 89 e5             	mov    %rsp,%rbp
  801736:	41 57                	push   %r15
  801738:	41 56                	push   %r14
  80173a:	41 55                	push   %r13
  80173c:	41 54                	push   %r12
  80173e:	53                   	push   %rbx
  80173f:	48 83 ec 08          	sub    $0x8,%rsp
  801743:	49 89 ff             	mov    %rdi,%r15
  801746:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  80174b:	49 bd 8d 28 80 00 00 	movabs $0x80288d,%r13
  801752:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  801755:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        struct Fd *fd = INDEX2FD(i);
  80175b:	49 89 dc             	mov    %rbx,%r12
        if (!(get_prot(fd) & PROT_R)) {
  80175e:	48 89 df             	mov    %rbx,%rdi
  801761:	41 ff d5             	call   *%r13
  801764:	83 e0 04             	and    $0x4,%eax
  801767:	74 17                	je     801780 <fd_alloc+0x52>
    for (int i = 0; i < MAXFD; i++) {
  801769:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  801770:	4c 39 f3             	cmp    %r14,%rbx
  801773:	75 e6                	jne    80175b <fd_alloc+0x2d>
  801775:	41 bc 00 00 00 00    	mov    $0x0,%r12d
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
    return -E_MAX_OPEN;
  80177b:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
            *fd_store = fd;
  801780:	4d 89 27             	mov    %r12,(%r15)
}
  801783:	48 83 c4 08          	add    $0x8,%rsp
  801787:	5b                   	pop    %rbx
  801788:	41 5c                	pop    %r12
  80178a:	41 5d                	pop    %r13
  80178c:	41 5e                	pop    %r14
  80178e:	41 5f                	pop    %r15
  801790:	5d                   	pop    %rbp
  801791:	c3                   	ret

0000000000801792 <fd_lookup>:
 *
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
  801792:	f3 0f 1e fa          	endbr64
    if (fdnum < 0 || fdnum >= MAXFD) {
  801796:	83 ff 1f             	cmp    $0x1f,%edi
  801799:	77 39                	ja     8017d4 <fd_lookup+0x42>
fd_lookup(int fdnum, struct Fd **fd_store) {
  80179b:	55                   	push   %rbp
  80179c:	48 89 e5             	mov    %rsp,%rbp
  80179f:	41 54                	push   %r12
  8017a1:	53                   	push   %rbx
  8017a2:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  8017a5:	48 63 df             	movslq %edi,%rbx
  8017a8:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  8017af:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  8017b3:	48 89 df             	mov    %rbx,%rdi
  8017b6:	48 b8 8d 28 80 00 00 	movabs $0x80288d,%rax
  8017bd:	00 00 00 
  8017c0:	ff d0                	call   *%rax
  8017c2:	a8 04                	test   $0x4,%al
  8017c4:	74 14                	je     8017da <fd_lookup+0x48>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  8017c6:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  8017ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017cf:	5b                   	pop    %rbx
  8017d0:	41 5c                	pop    %r12
  8017d2:	5d                   	pop    %rbp
  8017d3:	c3                   	ret
        return -E_INVAL;
  8017d4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8017d9:	c3                   	ret
        return -E_INVAL;
  8017da:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017df:	eb ee                	jmp    8017cf <fd_lookup+0x3d>

00000000008017e1 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  8017e1:	f3 0f 1e fa          	endbr64
  8017e5:	55                   	push   %rbp
  8017e6:	48 89 e5             	mov    %rsp,%rbp
  8017e9:	41 54                	push   %r12
  8017eb:	53                   	push   %rbx
  8017ec:	49 89 f4             	mov    %rsi,%r12
    for (size_t i = 0; devtab[i]; i++) {
  8017ef:	48 b8 00 37 80 00 00 	movabs $0x803700,%rax
  8017f6:	00 00 00 
  8017f9:	48 bb 20 40 80 00 00 	movabs $0x804020,%rbx
  801800:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  801803:	39 3b                	cmp    %edi,(%rbx)
  801805:	74 47                	je     80184e <dev_lookup+0x6d>
    for (size_t i = 0; devtab[i]; i++) {
  801807:	48 83 c0 08          	add    $0x8,%rax
  80180b:	48 8b 18             	mov    (%rax),%rbx
  80180e:	48 85 db             	test   %rbx,%rbx
  801811:	75 f0                	jne    801803 <dev_lookup+0x22>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801813:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  80181a:	00 00 00 
  80181d:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801823:	89 fa                	mov    %edi,%edx
  801825:	48 bf 18 33 80 00 00 	movabs $0x803318,%rdi
  80182c:	00 00 00 
  80182f:	b8 00 00 00 00       	mov    $0x0,%eax
  801834:	48 b9 e6 03 80 00 00 	movabs $0x8003e6,%rcx
  80183b:	00 00 00 
  80183e:	ff d1                	call   *%rcx
    *dev = 0;
    return -E_INVAL;
  801840:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
            *dev = devtab[i];
  801845:	49 89 1c 24          	mov    %rbx,(%r12)
}
  801849:	5b                   	pop    %rbx
  80184a:	41 5c                	pop    %r12
  80184c:	5d                   	pop    %rbp
  80184d:	c3                   	ret
            return 0;
  80184e:	b8 00 00 00 00       	mov    $0x0,%eax
  801853:	eb f0                	jmp    801845 <dev_lookup+0x64>

0000000000801855 <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  801855:	f3 0f 1e fa          	endbr64
  801859:	55                   	push   %rbp
  80185a:	48 89 e5             	mov    %rsp,%rbp
  80185d:	41 55                	push   %r13
  80185f:	41 54                	push   %r12
  801861:	53                   	push   %rbx
  801862:	48 83 ec 18          	sub    $0x18,%rsp
  801866:	48 89 fb             	mov    %rdi,%rbx
  801869:	41 89 f4             	mov    %esi,%r12d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80186c:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  801873:	ff ff ff 
  801876:	48 01 df             	add    %rbx,%rdi
  801879:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  80187d:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801881:	48 b8 92 17 80 00 00 	movabs $0x801792,%rax
  801888:	00 00 00 
  80188b:	ff d0                	call   *%rax
  80188d:	41 89 c5             	mov    %eax,%r13d
  801890:	85 c0                	test   %eax,%eax
  801892:	78 06                	js     80189a <fd_close+0x45>
  801894:	48 39 5d d8          	cmp    %rbx,-0x28(%rbp)
  801898:	74 1a                	je     8018b4 <fd_close+0x5f>
        return (must_exist ? res : 0);
  80189a:	45 84 e4             	test   %r12b,%r12b
  80189d:	b8 00 00 00 00       	mov    $0x0,%eax
  8018a2:	44 0f 44 e8          	cmove  %eax,%r13d
}
  8018a6:	44 89 e8             	mov    %r13d,%eax
  8018a9:	48 83 c4 18          	add    $0x18,%rsp
  8018ad:	5b                   	pop    %rbx
  8018ae:	41 5c                	pop    %r12
  8018b0:	41 5d                	pop    %r13
  8018b2:	5d                   	pop    %rbp
  8018b3:	c3                   	ret
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8018b4:	8b 3b                	mov    (%rbx),%edi
  8018b6:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8018ba:	48 b8 e1 17 80 00 00 	movabs $0x8017e1,%rax
  8018c1:	00 00 00 
  8018c4:	ff d0                	call   *%rax
  8018c6:	41 89 c5             	mov    %eax,%r13d
  8018c9:	85 c0                	test   %eax,%eax
  8018cb:	78 1b                	js     8018e8 <fd_close+0x93>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  8018cd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018d1:	48 8b 40 20          	mov    0x20(%rax),%rax
  8018d5:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  8018db:	48 85 c0             	test   %rax,%rax
  8018de:	74 08                	je     8018e8 <fd_close+0x93>
  8018e0:	48 89 df             	mov    %rbx,%rdi
  8018e3:	ff d0                	call   *%rax
  8018e5:	41 89 c5             	mov    %eax,%r13d
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  8018e8:	ba 00 10 00 00       	mov    $0x1000,%edx
  8018ed:	48 89 de             	mov    %rbx,%rsi
  8018f0:	bf 00 00 00 00       	mov    $0x0,%edi
  8018f5:	48 b8 74 14 80 00 00 	movabs $0x801474,%rax
  8018fc:	00 00 00 
  8018ff:	ff d0                	call   *%rax
    return res;
  801901:	eb a3                	jmp    8018a6 <fd_close+0x51>

0000000000801903 <close>:

int
close(int fdnum) {
  801903:	f3 0f 1e fa          	endbr64
  801907:	55                   	push   %rbp
  801908:	48 89 e5             	mov    %rsp,%rbp
  80190b:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  80190f:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801913:	48 b8 92 17 80 00 00 	movabs $0x801792,%rax
  80191a:	00 00 00 
  80191d:	ff d0                	call   *%rax
    if (res < 0) return res;
  80191f:	85 c0                	test   %eax,%eax
  801921:	78 15                	js     801938 <close+0x35>

    return fd_close(fd, 1);
  801923:	be 01 00 00 00       	mov    $0x1,%esi
  801928:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80192c:	48 b8 55 18 80 00 00 	movabs $0x801855,%rax
  801933:	00 00 00 
  801936:	ff d0                	call   *%rax
}
  801938:	c9                   	leave
  801939:	c3                   	ret

000000000080193a <close_all>:

void
close_all(void) {
  80193a:	f3 0f 1e fa          	endbr64
  80193e:	55                   	push   %rbp
  80193f:	48 89 e5             	mov    %rsp,%rbp
  801942:	41 54                	push   %r12
  801944:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  801945:	bb 00 00 00 00       	mov    $0x0,%ebx
  80194a:	49 bc 03 19 80 00 00 	movabs $0x801903,%r12
  801951:	00 00 00 
  801954:	89 df                	mov    %ebx,%edi
  801956:	41 ff d4             	call   *%r12
  801959:	83 c3 01             	add    $0x1,%ebx
  80195c:	83 fb 20             	cmp    $0x20,%ebx
  80195f:	75 f3                	jne    801954 <close_all+0x1a>
}
  801961:	5b                   	pop    %rbx
  801962:	41 5c                	pop    %r12
  801964:	5d                   	pop    %rbp
  801965:	c3                   	ret

0000000000801966 <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  801966:	f3 0f 1e fa          	endbr64
  80196a:	55                   	push   %rbp
  80196b:	48 89 e5             	mov    %rsp,%rbp
  80196e:	41 57                	push   %r15
  801970:	41 56                	push   %r14
  801972:	41 55                	push   %r13
  801974:	41 54                	push   %r12
  801976:	53                   	push   %rbx
  801977:	48 83 ec 18          	sub    $0x18,%rsp
  80197b:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  80197e:	48 8d 75 c8          	lea    -0x38(%rbp),%rsi
  801982:	48 b8 92 17 80 00 00 	movabs $0x801792,%rax
  801989:	00 00 00 
  80198c:	ff d0                	call   *%rax
  80198e:	89 c3                	mov    %eax,%ebx
  801990:	85 c0                	test   %eax,%eax
  801992:	0f 88 b8 00 00 00    	js     801a50 <dup+0xea>
    close(newfdnum);
  801998:	44 89 e7             	mov    %r12d,%edi
  80199b:	48 b8 03 19 80 00 00 	movabs $0x801903,%rax
  8019a2:	00 00 00 
  8019a5:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  8019a7:	4d 63 ec             	movslq %r12d,%r13
  8019aa:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  8019b1:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  8019b5:	4c 8b 7d c8          	mov    -0x38(%rbp),%r15
  8019b9:	4c 89 ff             	mov    %r15,%rdi
  8019bc:	49 be 0e 17 80 00 00 	movabs $0x80170e,%r14
  8019c3:	00 00 00 
  8019c6:	41 ff d6             	call   *%r14
  8019c9:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  8019cc:	4c 89 ef             	mov    %r13,%rdi
  8019cf:	41 ff d6             	call   *%r14
  8019d2:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  8019d5:	48 89 df             	mov    %rbx,%rdi
  8019d8:	48 b8 8d 28 80 00 00 	movabs $0x80288d,%rax
  8019df:	00 00 00 
  8019e2:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  8019e4:	a8 04                	test   $0x4,%al
  8019e6:	74 2b                	je     801a13 <dup+0xad>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  8019e8:	41 89 c1             	mov    %eax,%r9d
  8019eb:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8019f1:	4c 89 f1             	mov    %r14,%rcx
  8019f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8019f9:	48 89 de             	mov    %rbx,%rsi
  8019fc:	bf 00 00 00 00       	mov    $0x0,%edi
  801a01:	48 b8 9f 13 80 00 00 	movabs $0x80139f,%rax
  801a08:	00 00 00 
  801a0b:	ff d0                	call   *%rax
  801a0d:	89 c3                	mov    %eax,%ebx
  801a0f:	85 c0                	test   %eax,%eax
  801a11:	78 4e                	js     801a61 <dup+0xfb>
    }
    prot = get_prot(oldfd);
  801a13:	4c 89 ff             	mov    %r15,%rdi
  801a16:	48 b8 8d 28 80 00 00 	movabs $0x80288d,%rax
  801a1d:	00 00 00 
  801a20:	ff d0                	call   *%rax
  801a22:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  801a25:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801a2b:	4c 89 e9             	mov    %r13,%rcx
  801a2e:	ba 00 00 00 00       	mov    $0x0,%edx
  801a33:	4c 89 fe             	mov    %r15,%rsi
  801a36:	bf 00 00 00 00       	mov    $0x0,%edi
  801a3b:	48 b8 9f 13 80 00 00 	movabs $0x80139f,%rax
  801a42:	00 00 00 
  801a45:	ff d0                	call   *%rax
  801a47:	89 c3                	mov    %eax,%ebx
  801a49:	85 c0                	test   %eax,%eax
  801a4b:	78 14                	js     801a61 <dup+0xfb>

    return newfdnum;
  801a4d:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  801a50:	89 d8                	mov    %ebx,%eax
  801a52:	48 83 c4 18          	add    $0x18,%rsp
  801a56:	5b                   	pop    %rbx
  801a57:	41 5c                	pop    %r12
  801a59:	41 5d                	pop    %r13
  801a5b:	41 5e                	pop    %r14
  801a5d:	41 5f                	pop    %r15
  801a5f:	5d                   	pop    %rbp
  801a60:	c3                   	ret
    sys_unmap_region(0, newfd, PAGE_SIZE);
  801a61:	ba 00 10 00 00       	mov    $0x1000,%edx
  801a66:	4c 89 ee             	mov    %r13,%rsi
  801a69:	bf 00 00 00 00       	mov    $0x0,%edi
  801a6e:	49 bc 74 14 80 00 00 	movabs $0x801474,%r12
  801a75:	00 00 00 
  801a78:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  801a7b:	ba 00 10 00 00       	mov    $0x1000,%edx
  801a80:	4c 89 f6             	mov    %r14,%rsi
  801a83:	bf 00 00 00 00       	mov    $0x0,%edi
  801a88:	41 ff d4             	call   *%r12
    return res;
  801a8b:	eb c3                	jmp    801a50 <dup+0xea>

0000000000801a8d <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  801a8d:	f3 0f 1e fa          	endbr64
  801a91:	55                   	push   %rbp
  801a92:	48 89 e5             	mov    %rsp,%rbp
  801a95:	41 56                	push   %r14
  801a97:	41 55                	push   %r13
  801a99:	41 54                	push   %r12
  801a9b:	53                   	push   %rbx
  801a9c:	48 83 ec 10          	sub    $0x10,%rsp
  801aa0:	89 fb                	mov    %edi,%ebx
  801aa2:	49 89 f4             	mov    %rsi,%r12
  801aa5:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801aa8:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801aac:	48 b8 92 17 80 00 00 	movabs $0x801792,%rax
  801ab3:	00 00 00 
  801ab6:	ff d0                	call   *%rax
  801ab8:	85 c0                	test   %eax,%eax
  801aba:	78 4c                	js     801b08 <read+0x7b>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801abc:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801ac0:	41 8b 3e             	mov    (%r14),%edi
  801ac3:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801ac7:	48 b8 e1 17 80 00 00 	movabs $0x8017e1,%rax
  801ace:	00 00 00 
  801ad1:	ff d0                	call   *%rax
  801ad3:	85 c0                	test   %eax,%eax
  801ad5:	78 35                	js     801b0c <read+0x7f>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801ad7:	41 8b 46 08          	mov    0x8(%r14),%eax
  801adb:	83 e0 03             	and    $0x3,%eax
  801ade:	83 f8 01             	cmp    $0x1,%eax
  801ae1:	74 2d                	je     801b10 <read+0x83>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  801ae3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801ae7:	48 8b 40 10          	mov    0x10(%rax),%rax
  801aeb:	48 85 c0             	test   %rax,%rax
  801aee:	74 56                	je     801b46 <read+0xb9>

    return (*dev->dev_read)(fd, buf, n);
  801af0:	4c 89 ea             	mov    %r13,%rdx
  801af3:	4c 89 e6             	mov    %r12,%rsi
  801af6:	4c 89 f7             	mov    %r14,%rdi
  801af9:	ff d0                	call   *%rax
}
  801afb:	48 83 c4 10          	add    $0x10,%rsp
  801aff:	5b                   	pop    %rbx
  801b00:	41 5c                	pop    %r12
  801b02:	41 5d                	pop    %r13
  801b04:	41 5e                	pop    %r14
  801b06:	5d                   	pop    %rbp
  801b07:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801b08:	48 98                	cltq
  801b0a:	eb ef                	jmp    801afb <read+0x6e>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801b0c:	48 98                	cltq
  801b0e:	eb eb                	jmp    801afb <read+0x6e>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801b10:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801b17:	00 00 00 
  801b1a:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801b20:	89 da                	mov    %ebx,%edx
  801b22:	48 bf fd 31 80 00 00 	movabs $0x8031fd,%rdi
  801b29:	00 00 00 
  801b2c:	b8 00 00 00 00       	mov    $0x0,%eax
  801b31:	48 b9 e6 03 80 00 00 	movabs $0x8003e6,%rcx
  801b38:	00 00 00 
  801b3b:	ff d1                	call   *%rcx
        return -E_INVAL;
  801b3d:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801b44:	eb b5                	jmp    801afb <read+0x6e>
    if (!dev->dev_read) return -E_NOT_SUPP;
  801b46:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801b4d:	eb ac                	jmp    801afb <read+0x6e>

0000000000801b4f <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801b4f:	f3 0f 1e fa          	endbr64
  801b53:	55                   	push   %rbp
  801b54:	48 89 e5             	mov    %rsp,%rbp
  801b57:	41 57                	push   %r15
  801b59:	41 56                	push   %r14
  801b5b:	41 55                	push   %r13
  801b5d:	41 54                	push   %r12
  801b5f:	53                   	push   %rbx
  801b60:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801b64:	48 85 d2             	test   %rdx,%rdx
  801b67:	74 54                	je     801bbd <readn+0x6e>
  801b69:	41 89 fd             	mov    %edi,%r13d
  801b6c:	49 89 f6             	mov    %rsi,%r14
  801b6f:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801b72:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801b77:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801b7c:	49 bf 8d 1a 80 00 00 	movabs $0x801a8d,%r15
  801b83:	00 00 00 
  801b86:	4c 89 e2             	mov    %r12,%rdx
  801b89:	48 29 f2             	sub    %rsi,%rdx
  801b8c:	4c 01 f6             	add    %r14,%rsi
  801b8f:	44 89 ef             	mov    %r13d,%edi
  801b92:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  801b95:	85 c0                	test   %eax,%eax
  801b97:	78 20                	js     801bb9 <readn+0x6a>
    for (; inc && res < n; res += inc) {
  801b99:	01 c3                	add    %eax,%ebx
  801b9b:	85 c0                	test   %eax,%eax
  801b9d:	74 08                	je     801ba7 <readn+0x58>
  801b9f:	48 63 f3             	movslq %ebx,%rsi
  801ba2:	4c 39 e6             	cmp    %r12,%rsi
  801ba5:	72 df                	jb     801b86 <readn+0x37>
    }
    return res;
  801ba7:	48 63 c3             	movslq %ebx,%rax
}
  801baa:	48 83 c4 08          	add    $0x8,%rsp
  801bae:	5b                   	pop    %rbx
  801baf:	41 5c                	pop    %r12
  801bb1:	41 5d                	pop    %r13
  801bb3:	41 5e                	pop    %r14
  801bb5:	41 5f                	pop    %r15
  801bb7:	5d                   	pop    %rbp
  801bb8:	c3                   	ret
        if (inc < 0) return inc;
  801bb9:	48 98                	cltq
  801bbb:	eb ed                	jmp    801baa <readn+0x5b>
    int inc = 1, res = 0;
  801bbd:	bb 00 00 00 00       	mov    $0x0,%ebx
  801bc2:	eb e3                	jmp    801ba7 <readn+0x58>

0000000000801bc4 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  801bc4:	f3 0f 1e fa          	endbr64
  801bc8:	55                   	push   %rbp
  801bc9:	48 89 e5             	mov    %rsp,%rbp
  801bcc:	41 56                	push   %r14
  801bce:	41 55                	push   %r13
  801bd0:	41 54                	push   %r12
  801bd2:	53                   	push   %rbx
  801bd3:	48 83 ec 10          	sub    $0x10,%rsp
  801bd7:	89 fb                	mov    %edi,%ebx
  801bd9:	49 89 f4             	mov    %rsi,%r12
  801bdc:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801bdf:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801be3:	48 b8 92 17 80 00 00 	movabs $0x801792,%rax
  801bea:	00 00 00 
  801bed:	ff d0                	call   *%rax
  801bef:	85 c0                	test   %eax,%eax
  801bf1:	78 47                	js     801c3a <write+0x76>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801bf3:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801bf7:	41 8b 3e             	mov    (%r14),%edi
  801bfa:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801bfe:	48 b8 e1 17 80 00 00 	movabs $0x8017e1,%rax
  801c05:	00 00 00 
  801c08:	ff d0                	call   *%rax
  801c0a:	85 c0                	test   %eax,%eax
  801c0c:	78 30                	js     801c3e <write+0x7a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c0e:	41 f6 46 08 03       	testb  $0x3,0x8(%r14)
  801c13:	74 2d                	je     801c42 <write+0x7e>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801c15:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801c19:	48 8b 40 18          	mov    0x18(%rax),%rax
  801c1d:	48 85 c0             	test   %rax,%rax
  801c20:	74 56                	je     801c78 <write+0xb4>

    return (*dev->dev_write)(fd, buf, n);
  801c22:	4c 89 ea             	mov    %r13,%rdx
  801c25:	4c 89 e6             	mov    %r12,%rsi
  801c28:	4c 89 f7             	mov    %r14,%rdi
  801c2b:	ff d0                	call   *%rax
}
  801c2d:	48 83 c4 10          	add    $0x10,%rsp
  801c31:	5b                   	pop    %rbx
  801c32:	41 5c                	pop    %r12
  801c34:	41 5d                	pop    %r13
  801c36:	41 5e                	pop    %r14
  801c38:	5d                   	pop    %rbp
  801c39:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801c3a:	48 98                	cltq
  801c3c:	eb ef                	jmp    801c2d <write+0x69>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801c3e:	48 98                	cltq
  801c40:	eb eb                	jmp    801c2d <write+0x69>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801c42:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801c49:	00 00 00 
  801c4c:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801c52:	89 da                	mov    %ebx,%edx
  801c54:	48 bf 19 32 80 00 00 	movabs $0x803219,%rdi
  801c5b:	00 00 00 
  801c5e:	b8 00 00 00 00       	mov    $0x0,%eax
  801c63:	48 b9 e6 03 80 00 00 	movabs $0x8003e6,%rcx
  801c6a:	00 00 00 
  801c6d:	ff d1                	call   *%rcx
        return -E_INVAL;
  801c6f:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801c76:	eb b5                	jmp    801c2d <write+0x69>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801c78:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801c7f:	eb ac                	jmp    801c2d <write+0x69>

0000000000801c81 <seek>:

int
seek(int fdnum, off_t offset) {
  801c81:	f3 0f 1e fa          	endbr64
  801c85:	55                   	push   %rbp
  801c86:	48 89 e5             	mov    %rsp,%rbp
  801c89:	53                   	push   %rbx
  801c8a:	48 83 ec 18          	sub    $0x18,%rsp
  801c8e:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801c90:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801c94:	48 b8 92 17 80 00 00 	movabs $0x801792,%rax
  801c9b:	00 00 00 
  801c9e:	ff d0                	call   *%rax
  801ca0:	85 c0                	test   %eax,%eax
  801ca2:	78 0c                	js     801cb0 <seek+0x2f>

    fd->fd_offset = offset;
  801ca4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ca8:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  801cab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cb0:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801cb4:	c9                   	leave
  801cb5:	c3                   	ret

0000000000801cb6 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  801cb6:	f3 0f 1e fa          	endbr64
  801cba:	55                   	push   %rbp
  801cbb:	48 89 e5             	mov    %rsp,%rbp
  801cbe:	41 55                	push   %r13
  801cc0:	41 54                	push   %r12
  801cc2:	53                   	push   %rbx
  801cc3:	48 83 ec 18          	sub    $0x18,%rsp
  801cc7:	89 fb                	mov    %edi,%ebx
  801cc9:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801ccc:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801cd0:	48 b8 92 17 80 00 00 	movabs $0x801792,%rax
  801cd7:	00 00 00 
  801cda:	ff d0                	call   *%rax
  801cdc:	85 c0                	test   %eax,%eax
  801cde:	78 38                	js     801d18 <ftruncate+0x62>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801ce0:	4c 8b 6d d8          	mov    -0x28(%rbp),%r13
  801ce4:	41 8b 7d 00          	mov    0x0(%r13),%edi
  801ce8:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801cec:	48 b8 e1 17 80 00 00 	movabs $0x8017e1,%rax
  801cf3:	00 00 00 
  801cf6:	ff d0                	call   *%rax
  801cf8:	85 c0                	test   %eax,%eax
  801cfa:	78 1c                	js     801d18 <ftruncate+0x62>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801cfc:	41 f6 45 08 03       	testb  $0x3,0x8(%r13)
  801d01:	74 20                	je     801d23 <ftruncate+0x6d>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801d03:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d07:	48 8b 40 30          	mov    0x30(%rax),%rax
  801d0b:	48 85 c0             	test   %rax,%rax
  801d0e:	74 47                	je     801d57 <ftruncate+0xa1>

    return (*dev->dev_trunc)(fd, newsize);
  801d10:	44 89 e6             	mov    %r12d,%esi
  801d13:	4c 89 ef             	mov    %r13,%rdi
  801d16:	ff d0                	call   *%rax
}
  801d18:	48 83 c4 18          	add    $0x18,%rsp
  801d1c:	5b                   	pop    %rbx
  801d1d:	41 5c                	pop    %r12
  801d1f:	41 5d                	pop    %r13
  801d21:	5d                   	pop    %rbp
  801d22:	c3                   	ret
                thisenv->env_id, fdnum);
  801d23:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801d2a:	00 00 00 
  801d2d:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801d33:	89 da                	mov    %ebx,%edx
  801d35:	48 bf 38 33 80 00 00 	movabs $0x803338,%rdi
  801d3c:	00 00 00 
  801d3f:	b8 00 00 00 00       	mov    $0x0,%eax
  801d44:	48 b9 e6 03 80 00 00 	movabs $0x8003e6,%rcx
  801d4b:	00 00 00 
  801d4e:	ff d1                	call   *%rcx
        return -E_INVAL;
  801d50:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d55:	eb c1                	jmp    801d18 <ftruncate+0x62>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801d57:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801d5c:	eb ba                	jmp    801d18 <ftruncate+0x62>

0000000000801d5e <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  801d5e:	f3 0f 1e fa          	endbr64
  801d62:	55                   	push   %rbp
  801d63:	48 89 e5             	mov    %rsp,%rbp
  801d66:	41 54                	push   %r12
  801d68:	53                   	push   %rbx
  801d69:	48 83 ec 10          	sub    $0x10,%rsp
  801d6d:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801d70:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801d74:	48 b8 92 17 80 00 00 	movabs $0x801792,%rax
  801d7b:	00 00 00 
  801d7e:	ff d0                	call   *%rax
  801d80:	85 c0                	test   %eax,%eax
  801d82:	78 4e                	js     801dd2 <fstat+0x74>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801d84:	4c 8b 65 e8          	mov    -0x18(%rbp),%r12
  801d88:	41 8b 3c 24          	mov    (%r12),%edi
  801d8c:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801d90:	48 b8 e1 17 80 00 00 	movabs $0x8017e1,%rax
  801d97:	00 00 00 
  801d9a:	ff d0                	call   *%rax
  801d9c:	85 c0                	test   %eax,%eax
  801d9e:	78 32                	js     801dd2 <fstat+0x74>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  801da0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801da4:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  801da9:	74 30                	je     801ddb <fstat+0x7d>

    stat->st_name[0] = 0;
  801dab:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  801dae:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  801db5:	00 00 00 
    stat->st_isdir = 0;
  801db8:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801dbf:	00 00 00 
    stat->st_dev = dev;
  801dc2:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  801dc9:	48 89 de             	mov    %rbx,%rsi
  801dcc:	4c 89 e7             	mov    %r12,%rdi
  801dcf:	ff 50 28             	call   *0x28(%rax)
}
  801dd2:	48 83 c4 10          	add    $0x10,%rsp
  801dd6:	5b                   	pop    %rbx
  801dd7:	41 5c                	pop    %r12
  801dd9:	5d                   	pop    %rbp
  801dda:	c3                   	ret
    if (!dev->dev_stat) return -E_NOT_SUPP;
  801ddb:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801de0:	eb f0                	jmp    801dd2 <fstat+0x74>

0000000000801de2 <stat>:

int
stat(const char *path, struct Stat *stat) {
  801de2:	f3 0f 1e fa          	endbr64
  801de6:	55                   	push   %rbp
  801de7:	48 89 e5             	mov    %rsp,%rbp
  801dea:	41 54                	push   %r12
  801dec:	53                   	push   %rbx
  801ded:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  801df0:	be 00 00 00 00       	mov    $0x0,%esi
  801df5:	48 b8 c3 20 80 00 00 	movabs $0x8020c3,%rax
  801dfc:	00 00 00 
  801dff:	ff d0                	call   *%rax
  801e01:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  801e03:	85 c0                	test   %eax,%eax
  801e05:	78 25                	js     801e2c <stat+0x4a>

    int res = fstat(fd, stat);
  801e07:	4c 89 e6             	mov    %r12,%rsi
  801e0a:	89 c7                	mov    %eax,%edi
  801e0c:	48 b8 5e 1d 80 00 00 	movabs $0x801d5e,%rax
  801e13:	00 00 00 
  801e16:	ff d0                	call   *%rax
  801e18:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  801e1b:	89 df                	mov    %ebx,%edi
  801e1d:	48 b8 03 19 80 00 00 	movabs $0x801903,%rax
  801e24:	00 00 00 
  801e27:	ff d0                	call   *%rax

    return res;
  801e29:	44 89 e3             	mov    %r12d,%ebx
}
  801e2c:	89 d8                	mov    %ebx,%eax
  801e2e:	5b                   	pop    %rbx
  801e2f:	41 5c                	pop    %r12
  801e31:	5d                   	pop    %rbp
  801e32:	c3                   	ret

0000000000801e33 <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  801e33:	f3 0f 1e fa          	endbr64
  801e37:	55                   	push   %rbp
  801e38:	48 89 e5             	mov    %rsp,%rbp
  801e3b:	41 54                	push   %r12
  801e3d:	53                   	push   %rbx
  801e3e:	48 83 ec 10          	sub    $0x10,%rsp
  801e42:	41 89 fc             	mov    %edi,%r12d
  801e45:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801e48:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801e4f:	00 00 00 
  801e52:	83 38 00             	cmpl   $0x0,(%rax)
  801e55:	74 6e                	je     801ec5 <fsipc+0x92>

    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }
    fsenv = ipc_find_env(ENV_TYPE_FS);
  801e57:	bf 03 00 00 00       	mov    $0x3,%edi
  801e5c:	48 b8 ba 2d 80 00 00 	movabs $0x802dba,%rax
  801e63:	00 00 00 
  801e66:	ff d0                	call   *%rax
  801e68:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  801e6f:	00 00 
    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  801e71:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  801e77:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801e7c:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  801e83:	00 00 00 
  801e86:	44 89 e6             	mov    %r12d,%esi
  801e89:	89 c7                	mov    %eax,%edi
  801e8b:	48 b8 f8 2c 80 00 00 	movabs $0x802cf8,%rax
  801e92:	00 00 00 
  801e95:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  801e97:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  801e9e:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  801e9f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ea4:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801ea8:	48 89 de             	mov    %rbx,%rsi
  801eab:	bf 00 00 00 00       	mov    $0x0,%edi
  801eb0:	48 b8 5f 2c 80 00 00 	movabs $0x802c5f,%rax
  801eb7:	00 00 00 
  801eba:	ff d0                	call   *%rax
}
  801ebc:	48 83 c4 10          	add    $0x10,%rsp
  801ec0:	5b                   	pop    %rbx
  801ec1:	41 5c                	pop    %r12
  801ec3:	5d                   	pop    %rbp
  801ec4:	c3                   	ret
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801ec5:	bf 03 00 00 00       	mov    $0x3,%edi
  801eca:	48 b8 ba 2d 80 00 00 	movabs $0x802dba,%rax
  801ed1:	00 00 00 
  801ed4:	ff d0                	call   *%rax
  801ed6:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  801edd:	00 00 
  801edf:	e9 73 ff ff ff       	jmp    801e57 <fsipc+0x24>

0000000000801ee4 <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  801ee4:	f3 0f 1e fa          	endbr64
  801ee8:	55                   	push   %rbp
  801ee9:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801eec:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801ef3:	00 00 00 
  801ef6:	8b 57 0c             	mov    0xc(%rdi),%edx
  801ef9:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  801efb:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  801efe:	be 00 00 00 00       	mov    $0x0,%esi
  801f03:	bf 02 00 00 00       	mov    $0x2,%edi
  801f08:	48 b8 33 1e 80 00 00 	movabs $0x801e33,%rax
  801f0f:	00 00 00 
  801f12:	ff d0                	call   *%rax
}
  801f14:	5d                   	pop    %rbp
  801f15:	c3                   	ret

0000000000801f16 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  801f16:	f3 0f 1e fa          	endbr64
  801f1a:	55                   	push   %rbp
  801f1b:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801f1e:	8b 47 0c             	mov    0xc(%rdi),%eax
  801f21:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  801f28:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  801f2a:	be 00 00 00 00       	mov    $0x0,%esi
  801f2f:	bf 06 00 00 00       	mov    $0x6,%edi
  801f34:	48 b8 33 1e 80 00 00 	movabs $0x801e33,%rax
  801f3b:	00 00 00 
  801f3e:	ff d0                	call   *%rax
}
  801f40:	5d                   	pop    %rbp
  801f41:	c3                   	ret

0000000000801f42 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  801f42:	f3 0f 1e fa          	endbr64
  801f46:	55                   	push   %rbp
  801f47:	48 89 e5             	mov    %rsp,%rbp
  801f4a:	41 54                	push   %r12
  801f4c:	53                   	push   %rbx
  801f4d:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801f50:	8b 47 0c             	mov    0xc(%rdi),%eax
  801f53:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  801f5a:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  801f5c:	be 00 00 00 00       	mov    $0x0,%esi
  801f61:	bf 05 00 00 00       	mov    $0x5,%edi
  801f66:	48 b8 33 1e 80 00 00 	movabs $0x801e33,%rax
  801f6d:	00 00 00 
  801f70:	ff d0                	call   *%rax
    if (res < 0) return res;
  801f72:	85 c0                	test   %eax,%eax
  801f74:	78 3d                	js     801fb3 <devfile_stat+0x71>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801f76:	49 bc 00 60 80 00 00 	movabs $0x806000,%r12
  801f7d:	00 00 00 
  801f80:	4c 89 e6             	mov    %r12,%rsi
  801f83:	48 89 df             	mov    %rbx,%rdi
  801f86:	48 b8 2f 0d 80 00 00 	movabs $0x800d2f,%rax
  801f8d:	00 00 00 
  801f90:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  801f92:	41 8b 84 24 80 00 00 	mov    0x80(%r12),%eax
  801f99:	00 
  801f9a:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801fa0:	41 8b 84 24 84 00 00 	mov    0x84(%r12),%eax
  801fa7:	00 
  801fa8:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  801fae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fb3:	5b                   	pop    %rbx
  801fb4:	41 5c                	pop    %r12
  801fb6:	5d                   	pop    %rbp
  801fb7:	c3                   	ret

0000000000801fb8 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  801fb8:	f3 0f 1e fa          	endbr64
    if (n >= sizeof(fsipcbuf.write.req_buf)) {
  801fbc:	48 81 fa ef 0f 00 00 	cmp    $0xfef,%rdx
  801fc3:	77 41                	ja     802006 <devfile_write+0x4e>
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  801fc5:	55                   	push   %rbp
  801fc6:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  801fc9:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801fd0:	00 00 00 
  801fd3:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  801fd6:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.write.req_n = n;
  801fd8:	48 89 50 08          	mov    %rdx,0x8(%rax)
    memmove(fsipcbuf.write.req_buf, buf, n);
  801fdc:	48 8d 78 10          	lea    0x10(%rax),%rdi
  801fe0:	48 b8 4a 0f 80 00 00 	movabs $0x800f4a,%rax
  801fe7:	00 00 00 
  801fea:	ff d0                	call   *%rax
    res = fsipc(FSREQ_WRITE, NULL);
  801fec:	be 00 00 00 00       	mov    $0x0,%esi
  801ff1:	bf 04 00 00 00       	mov    $0x4,%edi
  801ff6:	48 b8 33 1e 80 00 00 	movabs $0x801e33,%rax
  801ffd:	00 00 00 
  802000:	ff d0                	call   *%rax
  802002:	48 98                	cltq
}
  802004:	5d                   	pop    %rbp
  802005:	c3                   	ret
        return -E_INVAL;
  802006:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
}
  80200d:	c3                   	ret

000000000080200e <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  80200e:	f3 0f 1e fa          	endbr64
  802012:	55                   	push   %rbp
  802013:	48 89 e5             	mov    %rsp,%rbp
  802016:	41 55                	push   %r13
  802018:	41 54                	push   %r12
  80201a:	53                   	push   %rbx
  80201b:	48 83 ec 08          	sub    $0x8,%rsp
  80201f:	49 89 f4             	mov    %rsi,%r12
  802022:	48 89 d3             	mov    %rdx,%rbx
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  802025:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80202c:	00 00 00 
  80202f:	8b 57 0c             	mov    0xc(%rdi),%edx
  802032:	89 10                	mov    %edx,(%rax)
    fsipcbuf.read.req_n = n;
  802034:	48 89 58 08          	mov    %rbx,0x8(%rax)
    res = fsipc(FSREQ_READ, NULL);
  802038:	be 00 00 00 00       	mov    $0x0,%esi
  80203d:	bf 03 00 00 00       	mov    $0x3,%edi
  802042:	48 b8 33 1e 80 00 00 	movabs $0x801e33,%rax
  802049:	00 00 00 
  80204c:	ff d0                	call   *%rax
  80204e:	4c 63 e8             	movslq %eax,%r13
    if (res < 0) {
  802051:	4d 85 ed             	test   %r13,%r13
  802054:	78 2a                	js     802080 <devfile_read+0x72>
    assert(res <= n && res <= PAGE_SIZE);
  802056:	4c 89 ea             	mov    %r13,%rdx
  802059:	4c 39 eb             	cmp    %r13,%rbx
  80205c:	72 30                	jb     80208e <devfile_read+0x80>
  80205e:	49 81 fd 00 10 00 00 	cmp    $0x1000,%r13
  802065:	7f 27                	jg     80208e <devfile_read+0x80>
    memmove(buf, &fsipcbuf, res);
  802067:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  80206e:	00 00 00 
  802071:	4c 89 e7             	mov    %r12,%rdi
  802074:	48 b8 4a 0f 80 00 00 	movabs $0x800f4a,%rax
  80207b:	00 00 00 
  80207e:	ff d0                	call   *%rax
}
  802080:	4c 89 e8             	mov    %r13,%rax
  802083:	48 83 c4 08          	add    $0x8,%rsp
  802087:	5b                   	pop    %rbx
  802088:	41 5c                	pop    %r12
  80208a:	41 5d                	pop    %r13
  80208c:	5d                   	pop    %rbp
  80208d:	c3                   	ret
    assert(res <= n && res <= PAGE_SIZE);
  80208e:	48 b9 36 32 80 00 00 	movabs $0x803236,%rcx
  802095:	00 00 00 
  802098:	48 ba 53 32 80 00 00 	movabs $0x803253,%rdx
  80209f:	00 00 00 
  8020a2:	be 7b 00 00 00       	mov    $0x7b,%esi
  8020a7:	48 bf 68 32 80 00 00 	movabs $0x803268,%rdi
  8020ae:	00 00 00 
  8020b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b6:	49 b8 8a 02 80 00 00 	movabs $0x80028a,%r8
  8020bd:	00 00 00 
  8020c0:	41 ff d0             	call   *%r8

00000000008020c3 <open>:
open(const char *path, int mode) {
  8020c3:	f3 0f 1e fa          	endbr64
  8020c7:	55                   	push   %rbp
  8020c8:	48 89 e5             	mov    %rsp,%rbp
  8020cb:	41 55                	push   %r13
  8020cd:	41 54                	push   %r12
  8020cf:	53                   	push   %rbx
  8020d0:	48 83 ec 18          	sub    $0x18,%rsp
  8020d4:	49 89 fc             	mov    %rdi,%r12
  8020d7:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  8020da:	48 b8 ea 0c 80 00 00 	movabs $0x800cea,%rax
  8020e1:	00 00 00 
  8020e4:	ff d0                	call   *%rax
  8020e6:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  8020ec:	0f 87 8a 00 00 00    	ja     80217c <open+0xb9>
    if ((res = fd_alloc(&fd)) < 0) return res;
  8020f2:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  8020f6:	48 b8 2e 17 80 00 00 	movabs $0x80172e,%rax
  8020fd:	00 00 00 
  802100:	ff d0                	call   *%rax
  802102:	89 c3                	mov    %eax,%ebx
  802104:	85 c0                	test   %eax,%eax
  802106:	78 50                	js     802158 <open+0x95>
    strcpy(fsipcbuf.open.req_path, path);
  802108:	4c 89 e6             	mov    %r12,%rsi
  80210b:	48 bb 00 60 80 00 00 	movabs $0x806000,%rbx
  802112:	00 00 00 
  802115:	48 89 df             	mov    %rbx,%rdi
  802118:	48 b8 2f 0d 80 00 00 	movabs $0x800d2f,%rax
  80211f:	00 00 00 
  802122:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  802124:	44 89 ab 00 04 00 00 	mov    %r13d,0x400(%rbx)
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  80212b:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80212f:	bf 01 00 00 00       	mov    $0x1,%edi
  802134:	48 b8 33 1e 80 00 00 	movabs $0x801e33,%rax
  80213b:	00 00 00 
  80213e:	ff d0                	call   *%rax
  802140:	89 c3                	mov    %eax,%ebx
  802142:	85 c0                	test   %eax,%eax
  802144:	78 1f                	js     802165 <open+0xa2>
    return fd2num(fd);
  802146:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80214a:	48 b8 f8 16 80 00 00 	movabs $0x8016f8,%rax
  802151:	00 00 00 
  802154:	ff d0                	call   *%rax
  802156:	89 c3                	mov    %eax,%ebx
}
  802158:	89 d8                	mov    %ebx,%eax
  80215a:	48 83 c4 18          	add    $0x18,%rsp
  80215e:	5b                   	pop    %rbx
  80215f:	41 5c                	pop    %r12
  802161:	41 5d                	pop    %r13
  802163:	5d                   	pop    %rbp
  802164:	c3                   	ret
        fd_close(fd, 0);
  802165:	be 00 00 00 00       	mov    $0x0,%esi
  80216a:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80216e:	48 b8 55 18 80 00 00 	movabs $0x801855,%rax
  802175:	00 00 00 
  802178:	ff d0                	call   *%rax
        return res;
  80217a:	eb dc                	jmp    802158 <open+0x95>
        return -E_BAD_PATH;
  80217c:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  802181:	eb d5                	jmp    802158 <open+0x95>

0000000000802183 <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  802183:	f3 0f 1e fa          	endbr64
  802187:	55                   	push   %rbp
  802188:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  80218b:	be 00 00 00 00       	mov    $0x0,%esi
  802190:	bf 08 00 00 00       	mov    $0x8,%edi
  802195:	48 b8 33 1e 80 00 00 	movabs $0x801e33,%rax
  80219c:	00 00 00 
  80219f:	ff d0                	call   *%rax
}
  8021a1:	5d                   	pop    %rbp
  8021a2:	c3                   	ret

00000000008021a3 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  8021a3:	f3 0f 1e fa          	endbr64
  8021a7:	55                   	push   %rbp
  8021a8:	48 89 e5             	mov    %rsp,%rbp
  8021ab:	41 54                	push   %r12
  8021ad:	53                   	push   %rbx
  8021ae:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8021b1:	48 b8 0e 17 80 00 00 	movabs $0x80170e,%rax
  8021b8:	00 00 00 
  8021bb:	ff d0                	call   *%rax
  8021bd:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  8021c0:	48 be 73 32 80 00 00 	movabs $0x803273,%rsi
  8021c7:	00 00 00 
  8021ca:	48 89 df             	mov    %rbx,%rdi
  8021cd:	48 b8 2f 0d 80 00 00 	movabs $0x800d2f,%rax
  8021d4:	00 00 00 
  8021d7:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  8021d9:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  8021de:	41 2b 04 24          	sub    (%r12),%eax
  8021e2:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  8021e8:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  8021ef:	00 00 00 
    stat->st_dev = &devpipe;
  8021f2:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  8021f9:	00 00 00 
  8021fc:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  802203:	b8 00 00 00 00       	mov    $0x0,%eax
  802208:	5b                   	pop    %rbx
  802209:	41 5c                	pop    %r12
  80220b:	5d                   	pop    %rbp
  80220c:	c3                   	ret

000000000080220d <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  80220d:	f3 0f 1e fa          	endbr64
  802211:	55                   	push   %rbp
  802212:	48 89 e5             	mov    %rsp,%rbp
  802215:	41 54                	push   %r12
  802217:	53                   	push   %rbx
  802218:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  80221b:	ba 00 10 00 00       	mov    $0x1000,%edx
  802220:	48 89 fe             	mov    %rdi,%rsi
  802223:	bf 00 00 00 00       	mov    $0x0,%edi
  802228:	49 bc 74 14 80 00 00 	movabs $0x801474,%r12
  80222f:	00 00 00 
  802232:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  802235:	48 89 df             	mov    %rbx,%rdi
  802238:	48 b8 0e 17 80 00 00 	movabs $0x80170e,%rax
  80223f:	00 00 00 
  802242:	ff d0                	call   *%rax
  802244:	48 89 c6             	mov    %rax,%rsi
  802247:	ba 00 10 00 00       	mov    $0x1000,%edx
  80224c:	bf 00 00 00 00       	mov    $0x0,%edi
  802251:	41 ff d4             	call   *%r12
}
  802254:	5b                   	pop    %rbx
  802255:	41 5c                	pop    %r12
  802257:	5d                   	pop    %rbp
  802258:	c3                   	ret

0000000000802259 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  802259:	f3 0f 1e fa          	endbr64
  80225d:	55                   	push   %rbp
  80225e:	48 89 e5             	mov    %rsp,%rbp
  802261:	41 57                	push   %r15
  802263:	41 56                	push   %r14
  802265:	41 55                	push   %r13
  802267:	41 54                	push   %r12
  802269:	53                   	push   %rbx
  80226a:	48 83 ec 18          	sub    $0x18,%rsp
  80226e:	49 89 fc             	mov    %rdi,%r12
  802271:	49 89 f5             	mov    %rsi,%r13
  802274:	49 89 d7             	mov    %rdx,%r15
  802277:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  80227b:	48 b8 0e 17 80 00 00 	movabs $0x80170e,%rax
  802282:	00 00 00 
  802285:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  802287:	4d 85 ff             	test   %r15,%r15
  80228a:	0f 84 af 00 00 00    	je     80233f <devpipe_write+0xe6>
  802290:	48 89 c3             	mov    %rax,%rbx
  802293:	4c 89 f8             	mov    %r15,%rax
  802296:	4d 89 ef             	mov    %r13,%r15
  802299:	4c 01 e8             	add    %r13,%rax
  80229c:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8022a0:	49 bd 04 13 80 00 00 	movabs $0x801304,%r13
  8022a7:	00 00 00 
            sys_yield();
  8022aa:	49 be 99 12 80 00 00 	movabs $0x801299,%r14
  8022b1:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8022b4:	8b 73 04             	mov    0x4(%rbx),%esi
  8022b7:	48 63 ce             	movslq %esi,%rcx
  8022ba:	48 63 03             	movslq (%rbx),%rax
  8022bd:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8022c3:	48 39 c1             	cmp    %rax,%rcx
  8022c6:	72 2e                	jb     8022f6 <devpipe_write+0x9d>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8022c8:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8022cd:	48 89 da             	mov    %rbx,%rdx
  8022d0:	be 00 10 00 00       	mov    $0x1000,%esi
  8022d5:	4c 89 e7             	mov    %r12,%rdi
  8022d8:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8022db:	85 c0                	test   %eax,%eax
  8022dd:	74 66                	je     802345 <devpipe_write+0xec>
            sys_yield();
  8022df:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8022e2:	8b 73 04             	mov    0x4(%rbx),%esi
  8022e5:	48 63 ce             	movslq %esi,%rcx
  8022e8:	48 63 03             	movslq (%rbx),%rax
  8022eb:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8022f1:	48 39 c1             	cmp    %rax,%rcx
  8022f4:	73 d2                	jae    8022c8 <devpipe_write+0x6f>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8022f6:	41 0f b6 3f          	movzbl (%r15),%edi
  8022fa:	48 89 ca             	mov    %rcx,%rdx
  8022fd:	48 c1 ea 03          	shr    $0x3,%rdx
  802301:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  802308:	08 10 20 
  80230b:	48 f7 e2             	mul    %rdx
  80230e:	48 c1 ea 06          	shr    $0x6,%rdx
  802312:	48 89 d0             	mov    %rdx,%rax
  802315:	48 c1 e0 09          	shl    $0x9,%rax
  802319:	48 29 d0             	sub    %rdx,%rax
  80231c:	48 c1 e0 03          	shl    $0x3,%rax
  802320:	48 29 c1             	sub    %rax,%rcx
  802323:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  802328:	83 c6 01             	add    $0x1,%esi
  80232b:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  80232e:	49 83 c7 01          	add    $0x1,%r15
  802332:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802336:	49 39 c7             	cmp    %rax,%r15
  802339:	0f 85 75 ff ff ff    	jne    8022b4 <devpipe_write+0x5b>
    return n;
  80233f:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802343:	eb 05                	jmp    80234a <devpipe_write+0xf1>
            if (_pipeisclosed(fd, p)) return 0;
  802345:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80234a:	48 83 c4 18          	add    $0x18,%rsp
  80234e:	5b                   	pop    %rbx
  80234f:	41 5c                	pop    %r12
  802351:	41 5d                	pop    %r13
  802353:	41 5e                	pop    %r14
  802355:	41 5f                	pop    %r15
  802357:	5d                   	pop    %rbp
  802358:	c3                   	ret

0000000000802359 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  802359:	f3 0f 1e fa          	endbr64
  80235d:	55                   	push   %rbp
  80235e:	48 89 e5             	mov    %rsp,%rbp
  802361:	41 57                	push   %r15
  802363:	41 56                	push   %r14
  802365:	41 55                	push   %r13
  802367:	41 54                	push   %r12
  802369:	53                   	push   %rbx
  80236a:	48 83 ec 18          	sub    $0x18,%rsp
  80236e:	49 89 fc             	mov    %rdi,%r12
  802371:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  802375:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802379:	48 b8 0e 17 80 00 00 	movabs $0x80170e,%rax
  802380:	00 00 00 
  802383:	ff d0                	call   *%rax
  802385:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  802388:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80238e:	49 bd 04 13 80 00 00 	movabs $0x801304,%r13
  802395:	00 00 00 
            sys_yield();
  802398:	49 be 99 12 80 00 00 	movabs $0x801299,%r14
  80239f:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  8023a2:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8023a7:	74 7d                	je     802426 <devpipe_read+0xcd>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8023a9:	8b 03                	mov    (%rbx),%eax
  8023ab:	3b 43 04             	cmp    0x4(%rbx),%eax
  8023ae:	75 26                	jne    8023d6 <devpipe_read+0x7d>
            if (i > 0) return i;
  8023b0:	4d 85 ff             	test   %r15,%r15
  8023b3:	75 77                	jne    80242c <devpipe_read+0xd3>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8023b5:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8023ba:	48 89 da             	mov    %rbx,%rdx
  8023bd:	be 00 10 00 00       	mov    $0x1000,%esi
  8023c2:	4c 89 e7             	mov    %r12,%rdi
  8023c5:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8023c8:	85 c0                	test   %eax,%eax
  8023ca:	74 72                	je     80243e <devpipe_read+0xe5>
            sys_yield();
  8023cc:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8023cf:	8b 03                	mov    (%rbx),%eax
  8023d1:	3b 43 04             	cmp    0x4(%rbx),%eax
  8023d4:	74 df                	je     8023b5 <devpipe_read+0x5c>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8023d6:	48 63 c8             	movslq %eax,%rcx
  8023d9:	48 89 ca             	mov    %rcx,%rdx
  8023dc:	48 c1 ea 03          	shr    $0x3,%rdx
  8023e0:	48 be 81 00 01 02 04 	movabs $0x2010080402010081,%rsi
  8023e7:	08 10 20 
  8023ea:	48 89 d0             	mov    %rdx,%rax
  8023ed:	48 f7 e6             	mul    %rsi
  8023f0:	48 c1 ea 06          	shr    $0x6,%rdx
  8023f4:	48 89 d0             	mov    %rdx,%rax
  8023f7:	48 c1 e0 09          	shl    $0x9,%rax
  8023fb:	48 29 d0             	sub    %rdx,%rax
  8023fe:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802405:	00 
  802406:	48 89 c8             	mov    %rcx,%rax
  802409:	48 29 d0             	sub    %rdx,%rax
  80240c:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  802411:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  802415:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  802419:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  80241c:	49 83 c7 01          	add    $0x1,%r15
  802420:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  802424:	75 83                	jne    8023a9 <devpipe_read+0x50>
    return n;
  802426:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80242a:	eb 03                	jmp    80242f <devpipe_read+0xd6>
            if (i > 0) return i;
  80242c:	4c 89 f8             	mov    %r15,%rax
}
  80242f:	48 83 c4 18          	add    $0x18,%rsp
  802433:	5b                   	pop    %rbx
  802434:	41 5c                	pop    %r12
  802436:	41 5d                	pop    %r13
  802438:	41 5e                	pop    %r14
  80243a:	41 5f                	pop    %r15
  80243c:	5d                   	pop    %rbp
  80243d:	c3                   	ret
            if (_pipeisclosed(fd, p)) return 0;
  80243e:	b8 00 00 00 00       	mov    $0x0,%eax
  802443:	eb ea                	jmp    80242f <devpipe_read+0xd6>

0000000000802445 <pipe>:
pipe(int pfd[2]) {
  802445:	f3 0f 1e fa          	endbr64
  802449:	55                   	push   %rbp
  80244a:	48 89 e5             	mov    %rsp,%rbp
  80244d:	41 55                	push   %r13
  80244f:	41 54                	push   %r12
  802451:	53                   	push   %rbx
  802452:	48 83 ec 18          	sub    $0x18,%rsp
  802456:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  802459:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  80245d:	48 b8 2e 17 80 00 00 	movabs $0x80172e,%rax
  802464:	00 00 00 
  802467:	ff d0                	call   *%rax
  802469:	89 c3                	mov    %eax,%ebx
  80246b:	85 c0                	test   %eax,%eax
  80246d:	0f 88 a0 01 00 00    	js     802613 <pipe+0x1ce>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  802473:	b9 46 00 00 00       	mov    $0x46,%ecx
  802478:	ba 00 10 00 00       	mov    $0x1000,%edx
  80247d:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802481:	bf 00 00 00 00       	mov    $0x0,%edi
  802486:	48 b8 34 13 80 00 00 	movabs $0x801334,%rax
  80248d:	00 00 00 
  802490:	ff d0                	call   *%rax
  802492:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  802494:	85 c0                	test   %eax,%eax
  802496:	0f 88 77 01 00 00    	js     802613 <pipe+0x1ce>
    if ((res = fd_alloc(&fd1)) < 0 ||
  80249c:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  8024a0:	48 b8 2e 17 80 00 00 	movabs $0x80172e,%rax
  8024a7:	00 00 00 
  8024aa:	ff d0                	call   *%rax
  8024ac:	89 c3                	mov    %eax,%ebx
  8024ae:	85 c0                	test   %eax,%eax
  8024b0:	0f 88 43 01 00 00    	js     8025f9 <pipe+0x1b4>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  8024b6:	b9 46 00 00 00       	mov    $0x46,%ecx
  8024bb:	ba 00 10 00 00       	mov    $0x1000,%edx
  8024c0:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8024c4:	bf 00 00 00 00       	mov    $0x0,%edi
  8024c9:	48 b8 34 13 80 00 00 	movabs $0x801334,%rax
  8024d0:	00 00 00 
  8024d3:	ff d0                	call   *%rax
  8024d5:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  8024d7:	85 c0                	test   %eax,%eax
  8024d9:	0f 88 1a 01 00 00    	js     8025f9 <pipe+0x1b4>
    va = fd2data(fd0);
  8024df:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8024e3:	48 b8 0e 17 80 00 00 	movabs $0x80170e,%rax
  8024ea:	00 00 00 
  8024ed:	ff d0                	call   *%rax
  8024ef:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  8024f2:	b9 46 00 00 00       	mov    $0x46,%ecx
  8024f7:	ba 00 10 00 00       	mov    $0x1000,%edx
  8024fc:	48 89 c6             	mov    %rax,%rsi
  8024ff:	bf 00 00 00 00       	mov    $0x0,%edi
  802504:	48 b8 34 13 80 00 00 	movabs $0x801334,%rax
  80250b:	00 00 00 
  80250e:	ff d0                	call   *%rax
  802510:	89 c3                	mov    %eax,%ebx
  802512:	85 c0                	test   %eax,%eax
  802514:	0f 88 c5 00 00 00    	js     8025df <pipe+0x19a>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  80251a:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  80251e:	48 b8 0e 17 80 00 00 	movabs $0x80170e,%rax
  802525:	00 00 00 
  802528:	ff d0                	call   *%rax
  80252a:	48 89 c1             	mov    %rax,%rcx
  80252d:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  802533:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  802539:	ba 00 00 00 00       	mov    $0x0,%edx
  80253e:	4c 89 ee             	mov    %r13,%rsi
  802541:	bf 00 00 00 00       	mov    $0x0,%edi
  802546:	48 b8 9f 13 80 00 00 	movabs $0x80139f,%rax
  80254d:	00 00 00 
  802550:	ff d0                	call   *%rax
  802552:	89 c3                	mov    %eax,%ebx
  802554:	85 c0                	test   %eax,%eax
  802556:	78 6e                	js     8025c6 <pipe+0x181>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802558:	be 00 10 00 00       	mov    $0x1000,%esi
  80255d:	4c 89 ef             	mov    %r13,%rdi
  802560:	48 b8 ce 12 80 00 00 	movabs $0x8012ce,%rax
  802567:	00 00 00 
  80256a:	ff d0                	call   *%rax
  80256c:	83 f8 02             	cmp    $0x2,%eax
  80256f:	0f 85 ab 00 00 00    	jne    802620 <pipe+0x1db>
    fd0->fd_dev_id = devpipe.dev_id;
  802575:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  80257c:	00 00 
  80257e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802582:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  802584:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802588:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  80258f:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802593:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  802595:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802599:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  8025a0:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8025a4:	48 bb f8 16 80 00 00 	movabs $0x8016f8,%rbx
  8025ab:	00 00 00 
  8025ae:	ff d3                	call   *%rbx
  8025b0:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  8025b4:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8025b8:	ff d3                	call   *%rbx
  8025ba:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  8025bf:	bb 00 00 00 00       	mov    $0x0,%ebx
  8025c4:	eb 4d                	jmp    802613 <pipe+0x1ce>
    sys_unmap_region(0, va, PAGE_SIZE);
  8025c6:	ba 00 10 00 00       	mov    $0x1000,%edx
  8025cb:	4c 89 ee             	mov    %r13,%rsi
  8025ce:	bf 00 00 00 00       	mov    $0x0,%edi
  8025d3:	48 b8 74 14 80 00 00 	movabs $0x801474,%rax
  8025da:	00 00 00 
  8025dd:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  8025df:	ba 00 10 00 00       	mov    $0x1000,%edx
  8025e4:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8025e8:	bf 00 00 00 00       	mov    $0x0,%edi
  8025ed:	48 b8 74 14 80 00 00 	movabs $0x801474,%rax
  8025f4:	00 00 00 
  8025f7:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  8025f9:	ba 00 10 00 00       	mov    $0x1000,%edx
  8025fe:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802602:	bf 00 00 00 00       	mov    $0x0,%edi
  802607:	48 b8 74 14 80 00 00 	movabs $0x801474,%rax
  80260e:	00 00 00 
  802611:	ff d0                	call   *%rax
}
  802613:	89 d8                	mov    %ebx,%eax
  802615:	48 83 c4 18          	add    $0x18,%rsp
  802619:	5b                   	pop    %rbx
  80261a:	41 5c                	pop    %r12
  80261c:	41 5d                	pop    %r13
  80261e:	5d                   	pop    %rbp
  80261f:	c3                   	ret
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802620:	48 b9 60 33 80 00 00 	movabs $0x803360,%rcx
  802627:	00 00 00 
  80262a:	48 ba 53 32 80 00 00 	movabs $0x803253,%rdx
  802631:	00 00 00 
  802634:	be 2e 00 00 00       	mov    $0x2e,%esi
  802639:	48 bf 7a 32 80 00 00 	movabs $0x80327a,%rdi
  802640:	00 00 00 
  802643:	b8 00 00 00 00       	mov    $0x0,%eax
  802648:	49 b8 8a 02 80 00 00 	movabs $0x80028a,%r8
  80264f:	00 00 00 
  802652:	41 ff d0             	call   *%r8

0000000000802655 <pipeisclosed>:
pipeisclosed(int fdnum) {
  802655:	f3 0f 1e fa          	endbr64
  802659:	55                   	push   %rbp
  80265a:	48 89 e5             	mov    %rsp,%rbp
  80265d:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802661:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802665:	48 b8 92 17 80 00 00 	movabs $0x801792,%rax
  80266c:	00 00 00 
  80266f:	ff d0                	call   *%rax
    if (res < 0) return res;
  802671:	85 c0                	test   %eax,%eax
  802673:	78 35                	js     8026aa <pipeisclosed+0x55>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  802675:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802679:	48 b8 0e 17 80 00 00 	movabs $0x80170e,%rax
  802680:	00 00 00 
  802683:	ff d0                	call   *%rax
  802685:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802688:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80268d:	be 00 10 00 00       	mov    $0x1000,%esi
  802692:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802696:	48 b8 04 13 80 00 00 	movabs $0x801304,%rax
  80269d:	00 00 00 
  8026a0:	ff d0                	call   *%rax
  8026a2:	85 c0                	test   %eax,%eax
  8026a4:	0f 94 c0             	sete   %al
  8026a7:	0f b6 c0             	movzbl %al,%eax
}
  8026aa:	c9                   	leave
  8026ab:	c3                   	ret

00000000008026ac <get_uvpt_entry>:
extern volatile pde_t uvpd[];     /* VA of current page directory */
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
  8026ac:	f3 0f 1e fa          	endbr64
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8026b0:	48 89 f8             	mov    %rdi,%rax
  8026b3:	48 c1 e8 27          	shr    $0x27,%rax
  8026b7:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  8026be:	7f 00 00 
  8026c1:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8026c5:	f6 c2 01             	test   $0x1,%dl
  8026c8:	74 6d                	je     802737 <get_uvpt_entry+0x8b>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8026ca:	48 89 f8             	mov    %rdi,%rax
  8026cd:	48 c1 e8 1e          	shr    $0x1e,%rax
  8026d1:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  8026d8:	7f 00 00 
  8026db:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8026df:	f6 c2 01             	test   $0x1,%dl
  8026e2:	74 62                	je     802746 <get_uvpt_entry+0x9a>
  8026e4:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  8026eb:	7f 00 00 
  8026ee:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8026f2:	f6 c2 80             	test   $0x80,%dl
  8026f5:	75 4f                	jne    802746 <get_uvpt_entry+0x9a>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8026f7:	48 89 f8             	mov    %rdi,%rax
  8026fa:	48 c1 e8 15          	shr    $0x15,%rax
  8026fe:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802705:	7f 00 00 
  802708:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80270c:	f6 c2 01             	test   $0x1,%dl
  80270f:	74 44                	je     802755 <get_uvpt_entry+0xa9>
  802711:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802718:	7f 00 00 
  80271b:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80271f:	f6 c2 80             	test   $0x80,%dl
  802722:	75 31                	jne    802755 <get_uvpt_entry+0xa9>
    return uvpt[VPT(va)];
  802724:	48 c1 ef 0c          	shr    $0xc,%rdi
  802728:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  80272f:	7f 00 00 
  802732:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  802736:	c3                   	ret
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802737:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  80273e:	7f 00 00 
  802741:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802745:	c3                   	ret
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  802746:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  80274d:	7f 00 00 
  802750:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802754:	c3                   	ret
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802755:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  80275c:	7f 00 00 
  80275f:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802763:	c3                   	ret

0000000000802764 <get_phys_addr>:

uintptr_t
get_phys_addr(void *va) {
  802764:	f3 0f 1e fa          	endbr64
  802768:	48 89 fa             	mov    %rdi,%rdx
    if (!(uvpml4[VPML4(va)] & PTE_P))
  80276b:	48 89 f9             	mov    %rdi,%rcx
  80276e:	48 c1 e9 27          	shr    $0x27,%rcx
  802772:	48 b8 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rax
  802779:	7f 00 00 
  80277c:	48 8b 0c c8          	mov    (%rax,%rcx,8),%rcx
        return -1;
  802780:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpml4[VPML4(va)] & PTE_P))
  802787:	f6 c1 01             	test   $0x1,%cl
  80278a:	0f 84 b2 00 00 00    	je     802842 <get_phys_addr+0xde>
    if (!(uvpdp[VPDP(va)] & PTE_P))
  802790:	48 89 f9             	mov    %rdi,%rcx
  802793:	48 c1 e9 1e          	shr    $0x1e,%rcx
  802797:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  80279e:	7f 00 00 
  8027a1:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  8027a5:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpdp[VPDP(va)] & PTE_P))
  8027ac:	40 f6 c6 01          	test   $0x1,%sil
  8027b0:	0f 84 8c 00 00 00    	je     802842 <get_phys_addr+0xde>
    if (uvpdp[VPDP(va)] & PTE_PS)
  8027b6:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  8027bd:	7f 00 00 
  8027c0:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8027c4:	a8 80                	test   $0x80,%al
  8027c6:	75 7b                	jne    802843 <get_phys_addr+0xdf>
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
    if (!(uvpd[VPD(va)] & PTE_P))
  8027c8:	48 89 f9             	mov    %rdi,%rcx
  8027cb:	48 c1 e9 15          	shr    $0x15,%rcx
  8027cf:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  8027d6:	7f 00 00 
  8027d9:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  8027dd:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpd[VPD(va)] & PTE_P))
  8027e4:	40 f6 c6 01          	test   $0x1,%sil
  8027e8:	74 58                	je     802842 <get_phys_addr+0xde>
    if ((uvpd[VPD(va)] & PTE_PS))
  8027ea:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  8027f1:	7f 00 00 
  8027f4:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8027f8:	a8 80                	test   $0x80,%al
  8027fa:	75 6c                	jne    802868 <get_phys_addr+0x104>
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
    if (!(uvpt[VPT(va)] & PTE_P))
  8027fc:	48 89 f9             	mov    %rdi,%rcx
  8027ff:	48 c1 e9 0c          	shr    $0xc,%rcx
  802803:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  80280a:	7f 00 00 
  80280d:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  802811:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpt[VPT(va)] & PTE_P))
  802818:	40 f6 c6 01          	test   $0x1,%sil
  80281c:	74 24                	je     802842 <get_phys_addr+0xde>
    return PTE_ADDR(uvpt[VPT(va)]) + PAGE_OFFSET(va);
  80281e:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802825:	7f 00 00 
  802828:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  80282c:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802833:	ff ff 7f 
  802836:	48 21 c8             	and    %rcx,%rax
  802839:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  80283f:	48 09 d0             	or     %rdx,%rax
}
  802842:	c3                   	ret
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
  802843:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  80284a:	7f 00 00 
  80284d:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802851:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802858:	ff ff 7f 
  80285b:	48 21 c8             	and    %rcx,%rax
  80285e:	81 e2 ff ff ff 3f    	and    $0x3fffffff,%edx
  802864:	48 01 d0             	add    %rdx,%rax
  802867:	c3                   	ret
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
  802868:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  80286f:	7f 00 00 
  802872:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802876:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  80287d:	ff ff 7f 
  802880:	48 21 c8             	and    %rcx,%rax
  802883:	81 e2 ff ff 1f 00    	and    $0x1fffff,%edx
  802889:	48 01 d0             	add    %rdx,%rax
  80288c:	c3                   	ret

000000000080288d <get_prot>:

int
get_prot(void *va) {
  80288d:	f3 0f 1e fa          	endbr64
  802891:	55                   	push   %rbp
  802892:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802895:	48 b8 ac 26 80 00 00 	movabs $0x8026ac,%rax
  80289c:	00 00 00 
  80289f:	ff d0                	call   *%rax
  8028a1:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
    if (pte & PTE_P) prot |= PROT_R;
  8028a4:	83 e0 01             	and    $0x1,%eax
  8028a7:	c1 e0 02             	shl    $0x2,%eax
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  8028aa:	89 d1                	mov    %edx,%ecx
  8028ac:	81 e1 00 0a 00 00    	and    $0xa00,%ecx
    if (pte & PTE_P) prot |= PROT_R;
  8028b2:	09 c8                	or     %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  8028b4:	89 c1                	mov    %eax,%ecx
  8028b6:	83 c9 02             	or     $0x2,%ecx
  8028b9:	f6 c2 02             	test   $0x2,%dl
  8028bc:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  8028bf:	89 c1                	mov    %eax,%ecx
  8028c1:	83 c9 01             	or     $0x1,%ecx
  8028c4:	48 85 d2             	test   %rdx,%rdx
  8028c7:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  8028ca:	89 c1                	mov    %eax,%ecx
  8028cc:	83 c9 40             	or     $0x40,%ecx
  8028cf:	f6 c6 04             	test   $0x4,%dh
  8028d2:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  8028d5:	5d                   	pop    %rbp
  8028d6:	c3                   	ret

00000000008028d7 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  8028d7:	f3 0f 1e fa          	endbr64
  8028db:	55                   	push   %rbp
  8028dc:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  8028df:	48 b8 ac 26 80 00 00 	movabs $0x8026ac,%rax
  8028e6:	00 00 00 
  8028e9:	ff d0                	call   *%rax
    return pte & PTE_D;
  8028eb:	48 c1 e8 06          	shr    $0x6,%rax
  8028ef:	83 e0 01             	and    $0x1,%eax
}
  8028f2:	5d                   	pop    %rbp
  8028f3:	c3                   	ret

00000000008028f4 <is_page_present>:

bool
is_page_present(void *va) {
  8028f4:	f3 0f 1e fa          	endbr64
  8028f8:	55                   	push   %rbp
  8028f9:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  8028fc:	48 b8 ac 26 80 00 00 	movabs $0x8026ac,%rax
  802903:	00 00 00 
  802906:	ff d0                	call   *%rax
  802908:	83 e0 01             	and    $0x1,%eax
}
  80290b:	5d                   	pop    %rbp
  80290c:	c3                   	ret

000000000080290d <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  80290d:	f3 0f 1e fa          	endbr64
  802911:	55                   	push   %rbp
  802912:	48 89 e5             	mov    %rsp,%rbp
  802915:	41 57                	push   %r15
  802917:	41 56                	push   %r14
  802919:	41 55                	push   %r13
  80291b:	41 54                	push   %r12
  80291d:	53                   	push   %rbx
  80291e:	48 83 ec 18          	sub    $0x18,%rsp
  802922:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  802926:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
     * NOTE: Skip over larger pages/page directories for efficiency */
    // LAB 11: Your code here:

    int res = 0;
    (void)fun, (void)arg;
    uintptr_t va = 0;
  80292a:	bb 00 00 00 00       	mov    $0x0,%ebx
    while (va < USER_STACK_TOP) {
        size_t size = 0;
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  80292f:	49 be 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%r14
  802936:	7f 00 00 
            size = 1LL << PML4_SHIFT;
            goto next;
        }

        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802939:	49 bd 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%r13
  802940:	7f 00 00 
    while (va < USER_STACK_TOP) {
  802943:	49 bf ff 6f ff ff 7f 	movabs $0x7fffff6fff,%r15
  80294a:	00 00 00 
  80294d:	eb 73                	jmp    8029c2 <foreach_shared_region+0xb5>
            }

            goto next;
        }

        if (!(uvpd[VPD(va)] & PTE_P)) {
  80294f:	48 89 d8             	mov    %rbx,%rax
  802952:	48 c1 e8 15          	shr    $0x15,%rax
  802956:	48 b9 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rcx
  80295d:	7f 00 00 
  802960:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
            size = 1LL << PD_SHIFT;
  802964:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
        if (!(uvpd[VPD(va)] & PTE_P)) {
  80296a:	f6 c2 01             	test   $0x1,%dl
  80296d:	74 4b                	je     8029ba <foreach_shared_region+0xad>
            goto next;
        }

        if (uvpd[VPD(va)] & PTE_PS) {
  80296f:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
  802973:	f6 c2 80             	test   $0x80,%dl
  802976:	74 11                	je     802989 <foreach_shared_region+0x7c>
            size = 1LL << PD_SHIFT;
            if (uvpd[VPD(va)] & PTE_SHARE) {
  802978:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
  80297c:	f6 c4 04             	test   $0x4,%ah
  80297f:	74 39                	je     8029ba <foreach_shared_region+0xad>
            size = 1LL << PD_SHIFT;
  802981:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
  802987:	eb 20                	jmp    8029a9 <foreach_shared_region+0x9c>

            goto next;
        }

        size = PAGE_SIZE;
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  802989:	48 89 da             	mov    %rbx,%rdx
  80298c:	48 c1 ea 0c          	shr    $0xc,%rdx
  802990:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802997:	7f 00 00 
  80299a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
        size = PAGE_SIZE;
  80299e:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  8029a4:	f6 c4 04             	test   $0x4,%ah
  8029a7:	74 11                	je     8029ba <foreach_shared_region+0xad>
            goto next;
        }

    map:
        fun((void *)va, (void *)(va + size), arg);
  8029a9:	49 8d 34 1c          	lea    (%r12,%rbx,1),%rsi
  8029ad:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8029b1:	48 89 df             	mov    %rbx,%rdi
  8029b4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8029b8:	ff d0                	call   *%rax
    next:
        va += size;
  8029ba:	4c 01 e3             	add    %r12,%rbx
    while (va < USER_STACK_TOP) {
  8029bd:	49 39 df             	cmp    %rbx,%r15
  8029c0:	72 3e                	jb     802a00 <foreach_shared_region+0xf3>
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  8029c2:	49 8b 06             	mov    (%r14),%rax
  8029c5:	a8 01                	test   $0x1,%al
  8029c7:	74 37                	je     802a00 <foreach_shared_region+0xf3>
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  8029c9:	48 89 d8             	mov    %rbx,%rax
  8029cc:	48 c1 e8 1e          	shr    $0x1e,%rax
  8029d0:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
            size = 1LL << PDP_SHIFT;
  8029d5:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  8029db:	f6 c2 01             	test   $0x1,%dl
  8029de:	74 da                	je     8029ba <foreach_shared_region+0xad>
        if (uvpdp[VPDP(va)] & PTE_PS) {
  8029e0:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
  8029e5:	f6 c2 80             	test   $0x80,%dl
  8029e8:	0f 84 61 ff ff ff    	je     80294f <foreach_shared_region+0x42>
            if (uvpdp[VPDP(va)] & PTE_SHARE) {
  8029ee:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  8029f3:	f6 c4 04             	test   $0x4,%ah
  8029f6:	74 c2                	je     8029ba <foreach_shared_region+0xad>
            size = 1LL << PDP_SHIFT;
  8029f8:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
  8029fe:	eb a9                	jmp    8029a9 <foreach_shared_region+0x9c>
    }
    return res;
}
  802a00:	b8 00 00 00 00       	mov    $0x0,%eax
  802a05:	48 83 c4 18          	add    $0x18,%rsp
  802a09:	5b                   	pop    %rbx
  802a0a:	41 5c                	pop    %r12
  802a0c:	41 5d                	pop    %r13
  802a0e:	41 5e                	pop    %r14
  802a10:	41 5f                	pop    %r15
  802a12:	5d                   	pop    %rbp
  802a13:	c3                   	ret

0000000000802a14 <devcons_close>:

    return res;
}

static int
devcons_close(struct Fd *fd) {
  802a14:	f3 0f 1e fa          	endbr64
    USED(fd);

    return 0;
}
  802a18:	b8 00 00 00 00       	mov    $0x0,%eax
  802a1d:	c3                   	ret

0000000000802a1e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  802a1e:	f3 0f 1e fa          	endbr64
  802a22:	55                   	push   %rbp
  802a23:	48 89 e5             	mov    %rsp,%rbp
  802a26:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  802a29:	48 be 8a 32 80 00 00 	movabs $0x80328a,%rsi
  802a30:	00 00 00 
  802a33:	48 b8 2f 0d 80 00 00 	movabs $0x800d2f,%rax
  802a3a:	00 00 00 
  802a3d:	ff d0                	call   *%rax
    return 0;
}
  802a3f:	b8 00 00 00 00       	mov    $0x0,%eax
  802a44:	5d                   	pop    %rbp
  802a45:	c3                   	ret

0000000000802a46 <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  802a46:	f3 0f 1e fa          	endbr64
  802a4a:	55                   	push   %rbp
  802a4b:	48 89 e5             	mov    %rsp,%rbp
  802a4e:	41 57                	push   %r15
  802a50:	41 56                	push   %r14
  802a52:	41 55                	push   %r13
  802a54:	41 54                	push   %r12
  802a56:	53                   	push   %rbx
  802a57:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  802a5e:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  802a65:	48 85 d2             	test   %rdx,%rdx
  802a68:	74 7a                	je     802ae4 <devcons_write+0x9e>
  802a6a:	49 89 d6             	mov    %rdx,%r14
  802a6d:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802a73:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  802a78:	49 bf 4a 0f 80 00 00 	movabs $0x800f4a,%r15
  802a7f:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  802a82:	4c 89 f3             	mov    %r14,%rbx
  802a85:	48 29 f3             	sub    %rsi,%rbx
  802a88:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802a8d:	48 39 c3             	cmp    %rax,%rbx
  802a90:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  802a94:	4c 63 eb             	movslq %ebx,%r13
  802a97:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  802a9e:	48 01 c6             	add    %rax,%rsi
  802aa1:	4c 89 ea             	mov    %r13,%rdx
  802aa4:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802aab:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  802aae:	4c 89 ee             	mov    %r13,%rsi
  802ab1:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802ab8:	48 b8 8f 11 80 00 00 	movabs $0x80118f,%rax
  802abf:	00 00 00 
  802ac2:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  802ac4:	41 01 dc             	add    %ebx,%r12d
  802ac7:	49 63 f4             	movslq %r12d,%rsi
  802aca:	4c 39 f6             	cmp    %r14,%rsi
  802acd:	72 b3                	jb     802a82 <devcons_write+0x3c>
    return res;
  802acf:	49 63 c4             	movslq %r12d,%rax
}
  802ad2:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  802ad9:	5b                   	pop    %rbx
  802ada:	41 5c                	pop    %r12
  802adc:	41 5d                	pop    %r13
  802ade:	41 5e                	pop    %r14
  802ae0:	41 5f                	pop    %r15
  802ae2:	5d                   	pop    %rbp
  802ae3:	c3                   	ret
    for (res = 0; res < n; res += inc) {
  802ae4:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802aea:	eb e3                	jmp    802acf <devcons_write+0x89>

0000000000802aec <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802aec:	f3 0f 1e fa          	endbr64
  802af0:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  802af3:	ba 00 00 00 00       	mov    $0x0,%edx
  802af8:	48 85 c0             	test   %rax,%rax
  802afb:	74 55                	je     802b52 <devcons_read+0x66>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802afd:	55                   	push   %rbp
  802afe:	48 89 e5             	mov    %rsp,%rbp
  802b01:	41 55                	push   %r13
  802b03:	41 54                	push   %r12
  802b05:	53                   	push   %rbx
  802b06:	48 83 ec 08          	sub    $0x8,%rsp
  802b0a:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  802b0d:	48 bb c0 11 80 00 00 	movabs $0x8011c0,%rbx
  802b14:	00 00 00 
  802b17:	49 bc 99 12 80 00 00 	movabs $0x801299,%r12
  802b1e:	00 00 00 
  802b21:	eb 03                	jmp    802b26 <devcons_read+0x3a>
  802b23:	41 ff d4             	call   *%r12
  802b26:	ff d3                	call   *%rbx
  802b28:	85 c0                	test   %eax,%eax
  802b2a:	74 f7                	je     802b23 <devcons_read+0x37>
    if (c < 0) return c;
  802b2c:	48 63 d0             	movslq %eax,%rdx
  802b2f:	78 13                	js     802b44 <devcons_read+0x58>
    if (c == 0x04) return 0;
  802b31:	ba 00 00 00 00       	mov    $0x0,%edx
  802b36:	83 f8 04             	cmp    $0x4,%eax
  802b39:	74 09                	je     802b44 <devcons_read+0x58>
    *(char *)vbuf = (char)c;
  802b3b:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  802b3f:	ba 01 00 00 00       	mov    $0x1,%edx
}
  802b44:	48 89 d0             	mov    %rdx,%rax
  802b47:	48 83 c4 08          	add    $0x8,%rsp
  802b4b:	5b                   	pop    %rbx
  802b4c:	41 5c                	pop    %r12
  802b4e:	41 5d                	pop    %r13
  802b50:	5d                   	pop    %rbp
  802b51:	c3                   	ret
  802b52:	48 89 d0             	mov    %rdx,%rax
  802b55:	c3                   	ret

0000000000802b56 <cputchar>:
cputchar(int ch) {
  802b56:	f3 0f 1e fa          	endbr64
  802b5a:	55                   	push   %rbp
  802b5b:	48 89 e5             	mov    %rsp,%rbp
  802b5e:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  802b62:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  802b66:	be 01 00 00 00       	mov    $0x1,%esi
  802b6b:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  802b6f:	48 b8 8f 11 80 00 00 	movabs $0x80118f,%rax
  802b76:	00 00 00 
  802b79:	ff d0                	call   *%rax
}
  802b7b:	c9                   	leave
  802b7c:	c3                   	ret

0000000000802b7d <getchar>:
getchar(void) {
  802b7d:	f3 0f 1e fa          	endbr64
  802b81:	55                   	push   %rbp
  802b82:	48 89 e5             	mov    %rsp,%rbp
  802b85:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  802b89:	ba 01 00 00 00       	mov    $0x1,%edx
  802b8e:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  802b92:	bf 00 00 00 00       	mov    $0x0,%edi
  802b97:	48 b8 8d 1a 80 00 00 	movabs $0x801a8d,%rax
  802b9e:	00 00 00 
  802ba1:	ff d0                	call   *%rax
  802ba3:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  802ba5:	85 c0                	test   %eax,%eax
  802ba7:	78 06                	js     802baf <getchar+0x32>
  802ba9:	74 08                	je     802bb3 <getchar+0x36>
  802bab:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  802baf:	89 d0                	mov    %edx,%eax
  802bb1:	c9                   	leave
  802bb2:	c3                   	ret
    return res < 0 ? res : res ? c :
  802bb3:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  802bb8:	eb f5                	jmp    802baf <getchar+0x32>

0000000000802bba <iscons>:
iscons(int fdnum) {
  802bba:	f3 0f 1e fa          	endbr64
  802bbe:	55                   	push   %rbp
  802bbf:	48 89 e5             	mov    %rsp,%rbp
  802bc2:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802bc6:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802bca:	48 b8 92 17 80 00 00 	movabs $0x801792,%rax
  802bd1:	00 00 00 
  802bd4:	ff d0                	call   *%rax
    if (res < 0) return res;
  802bd6:	85 c0                	test   %eax,%eax
  802bd8:	78 18                	js     802bf2 <iscons+0x38>
    return fd->fd_dev_id == devcons.dev_id;
  802bda:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802bde:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  802be5:	00 00 00 
  802be8:	8b 00                	mov    (%rax),%eax
  802bea:	39 02                	cmp    %eax,(%rdx)
  802bec:	0f 94 c0             	sete   %al
  802bef:	0f b6 c0             	movzbl %al,%eax
}
  802bf2:	c9                   	leave
  802bf3:	c3                   	ret

0000000000802bf4 <opencons>:
opencons(void) {
  802bf4:	f3 0f 1e fa          	endbr64
  802bf8:	55                   	push   %rbp
  802bf9:	48 89 e5             	mov    %rsp,%rbp
  802bfc:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  802c00:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  802c04:	48 b8 2e 17 80 00 00 	movabs $0x80172e,%rax
  802c0b:	00 00 00 
  802c0e:	ff d0                	call   *%rax
  802c10:	85 c0                	test   %eax,%eax
  802c12:	78 49                	js     802c5d <opencons+0x69>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  802c14:	b9 46 00 00 00       	mov    $0x46,%ecx
  802c19:	ba 00 10 00 00       	mov    $0x1000,%edx
  802c1e:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  802c22:	bf 00 00 00 00       	mov    $0x0,%edi
  802c27:	48 b8 34 13 80 00 00 	movabs $0x801334,%rax
  802c2e:	00 00 00 
  802c31:	ff d0                	call   *%rax
  802c33:	85 c0                	test   %eax,%eax
  802c35:	78 26                	js     802c5d <opencons+0x69>
    fd->fd_dev_id = devcons.dev_id;
  802c37:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802c3b:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  802c42:	00 00 
  802c44:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  802c46:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802c4a:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  802c51:	48 b8 f8 16 80 00 00 	movabs $0x8016f8,%rax
  802c58:	00 00 00 
  802c5b:	ff d0                	call   *%rax
}
  802c5d:	c9                   	leave
  802c5e:	c3                   	ret

0000000000802c5f <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802c5f:	f3 0f 1e fa          	endbr64
  802c63:	55                   	push   %rbp
  802c64:	48 89 e5             	mov    %rsp,%rbp
  802c67:	41 54                	push   %r12
  802c69:	53                   	push   %rbx
  802c6a:	48 89 fb             	mov    %rdi,%rbx
  802c6d:	48 89 f7             	mov    %rsi,%rdi
  802c70:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802c73:	48 85 f6             	test   %rsi,%rsi
  802c76:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802c7d:	00 00 00 
  802c80:	48 0f 44 f8          	cmove  %rax,%rdi
    }
    int res = sys_ipc_recv(pg, PAGE_SIZE);
  802c84:	be 00 10 00 00       	mov    $0x1000,%esi
  802c89:	48 b8 56 16 80 00 00 	movabs $0x801656,%rax
  802c90:	00 00 00 
  802c93:	ff d0                	call   *%rax
    if (res < 0) {
  802c95:	85 c0                	test   %eax,%eax
  802c97:	78 45                	js     802cde <ipc_recv+0x7f>
        if (perm_store != NULL) {
            *perm_store = 0;
        }
        return res;
    } else {
        if (from_env_store != NULL) {
  802c99:	48 85 db             	test   %rbx,%rbx
  802c9c:	74 12                	je     802cb0 <ipc_recv+0x51>
            *from_env_store = thisenv->env_ipc_from;
  802c9e:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802ca5:	00 00 00 
  802ca8:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  802cae:	89 03                	mov    %eax,(%rbx)
        }
        if (perm_store != NULL) {
  802cb0:	4d 85 e4             	test   %r12,%r12
  802cb3:	74 14                	je     802cc9 <ipc_recv+0x6a>
            *perm_store = thisenv->env_ipc_perm;
  802cb5:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802cbc:	00 00 00 
  802cbf:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  802cc5:	41 89 04 24          	mov    %eax,(%r12)
        }
        return thisenv->env_ipc_value;
  802cc9:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802cd0:	00 00 00 
  802cd3:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
    }
    return -1;
}
  802cd9:	5b                   	pop    %rbx
  802cda:	41 5c                	pop    %r12
  802cdc:	5d                   	pop    %rbp
  802cdd:	c3                   	ret
        if (from_env_store != NULL) {
  802cde:	48 85 db             	test   %rbx,%rbx
  802ce1:	74 06                	je     802ce9 <ipc_recv+0x8a>
            *from_env_store = 0;
  802ce3:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store != NULL) {
  802ce9:	4d 85 e4             	test   %r12,%r12
  802cec:	74 eb                	je     802cd9 <ipc_recv+0x7a>
            *perm_store = 0;
  802cee:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  802cf5:	00 
  802cf6:	eb e1                	jmp    802cd9 <ipc_recv+0x7a>

0000000000802cf8 <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  802cf8:	f3 0f 1e fa          	endbr64
  802cfc:	55                   	push   %rbp
  802cfd:	48 89 e5             	mov    %rsp,%rbp
  802d00:	41 57                	push   %r15
  802d02:	41 56                	push   %r14
  802d04:	41 55                	push   %r13
  802d06:	41 54                	push   %r12
  802d08:	53                   	push   %rbx
  802d09:	48 83 ec 18          	sub    $0x18,%rsp
  802d0d:	89 7d c4             	mov    %edi,-0x3c(%rbp)
  802d10:	48 89 d3             	mov    %rdx,%rbx
  802d13:	49 89 cc             	mov    %rcx,%r12
  802d16:	45 89 c5             	mov    %r8d,%r13d
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802d19:	48 85 d2             	test   %rdx,%rdx
  802d1c:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802d23:	00 00 00 
  802d26:	48 0f 44 d8          	cmove  %rax,%rbx
    }
    int res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802d2a:	89 f0                	mov    %esi,%eax
  802d2c:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  802d30:	48 89 da             	mov    %rbx,%rdx
  802d33:	48 89 c6             	mov    %rax,%rsi
  802d36:	48 b8 26 16 80 00 00 	movabs $0x801626,%rax
  802d3d:	00 00 00 
  802d40:	ff d0                	call   *%rax
    while (res < 0) {
  802d42:	85 c0                	test   %eax,%eax
  802d44:	79 65                	jns    802dab <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802d46:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802d49:	75 33                	jne    802d7e <ipc_send+0x86>
            panic("Error: %i\n", res);
        }
        sys_yield();
  802d4b:	49 bf 99 12 80 00 00 	movabs $0x801299,%r15
  802d52:	00 00 00 
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802d55:	49 be 26 16 80 00 00 	movabs $0x801626,%r14
  802d5c:	00 00 00 
        sys_yield();
  802d5f:	41 ff d7             	call   *%r15
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802d62:	45 89 e8             	mov    %r13d,%r8d
  802d65:	4c 89 e1             	mov    %r12,%rcx
  802d68:	48 89 da             	mov    %rbx,%rdx
  802d6b:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  802d6f:	8b 7d c4             	mov    -0x3c(%rbp),%edi
  802d72:	41 ff d6             	call   *%r14
    while (res < 0) {
  802d75:	85 c0                	test   %eax,%eax
  802d77:	79 32                	jns    802dab <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802d79:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802d7c:	74 e1                	je     802d5f <ipc_send+0x67>
            panic("Error: %i\n", res);
  802d7e:	89 c1                	mov    %eax,%ecx
  802d80:	48 ba 96 32 80 00 00 	movabs $0x803296,%rdx
  802d87:	00 00 00 
  802d8a:	be 42 00 00 00       	mov    $0x42,%esi
  802d8f:	48 bf a1 32 80 00 00 	movabs $0x8032a1,%rdi
  802d96:	00 00 00 
  802d99:	b8 00 00 00 00       	mov    $0x0,%eax
  802d9e:	49 b8 8a 02 80 00 00 	movabs $0x80028a,%r8
  802da5:	00 00 00 
  802da8:	41 ff d0             	call   *%r8
    }
}
  802dab:	48 83 c4 18          	add    $0x18,%rsp
  802daf:	5b                   	pop    %rbx
  802db0:	41 5c                	pop    %r12
  802db2:	41 5d                	pop    %r13
  802db4:	41 5e                	pop    %r14
  802db6:	41 5f                	pop    %r15
  802db8:	5d                   	pop    %rbp
  802db9:	c3                   	ret

0000000000802dba <ipc_find_env>:

/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
  802dba:	f3 0f 1e fa          	endbr64
    for (size_t i = 0; i < NENV; i++)
  802dbe:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  802dc3:	48 b9 00 00 a0 1f 80 	movabs $0x801fa00000,%rcx
  802dca:	00 00 00 
  802dcd:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802dd1:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802dd5:	48 c1 e2 04          	shl    $0x4,%rdx
  802dd9:	48 01 ca             	add    %rcx,%rdx
  802ddc:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  802de2:	39 fa                	cmp    %edi,%edx
  802de4:	74 12                	je     802df8 <ipc_find_env+0x3e>
    for (size_t i = 0; i < NENV; i++)
  802de6:	48 83 c0 01          	add    $0x1,%rax
  802dea:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  802df0:	75 db                	jne    802dcd <ipc_find_env+0x13>
            return envs[i].env_id;
    return 0;
  802df2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802df7:	c3                   	ret
            return envs[i].env_id;
  802df8:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802dfc:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802e00:	48 c1 e2 04          	shl    $0x4,%rdx
  802e04:	48 b8 00 00 a0 1f 80 	movabs $0x801fa00000,%rax
  802e0b:	00 00 00 
  802e0e:	48 01 d0             	add    %rdx,%rax
  802e11:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802e17:	c3                   	ret

0000000000802e18 <__text_end>:
  802e18:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e1f:	00 00 00 
  802e22:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e29:	00 00 00 
  802e2c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e33:	00 00 00 
  802e36:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e3d:	00 00 00 
  802e40:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e47:	00 00 00 
  802e4a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e51:	00 00 00 
  802e54:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e5b:	00 00 00 
  802e5e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e65:	00 00 00 
  802e68:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e6f:	00 00 00 
  802e72:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e79:	00 00 00 
  802e7c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e83:	00 00 00 
  802e86:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e8d:	00 00 00 
  802e90:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e97:	00 00 00 
  802e9a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ea1:	00 00 00 
  802ea4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802eab:	00 00 00 
  802eae:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802eb5:	00 00 00 
  802eb8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ebf:	00 00 00 
  802ec2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ec9:	00 00 00 
  802ecc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ed3:	00 00 00 
  802ed6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802edd:	00 00 00 
  802ee0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ee7:	00 00 00 
  802eea:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ef1:	00 00 00 
  802ef4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802efb:	00 00 00 
  802efe:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f05:	00 00 00 
  802f08:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f0f:	00 00 00 
  802f12:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f19:	00 00 00 
  802f1c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f23:	00 00 00 
  802f26:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f2d:	00 00 00 
  802f30:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f37:	00 00 00 
  802f3a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f41:	00 00 00 
  802f44:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f4b:	00 00 00 
  802f4e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f55:	00 00 00 
  802f58:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f5f:	00 00 00 
  802f62:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f69:	00 00 00 
  802f6c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f73:	00 00 00 
  802f76:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f7d:	00 00 00 
  802f80:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f87:	00 00 00 
  802f8a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f91:	00 00 00 
  802f94:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f9b:	00 00 00 
  802f9e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fa5:	00 00 00 
  802fa8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802faf:	00 00 00 
  802fb2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fb9:	00 00 00 
  802fbc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fc3:	00 00 00 
  802fc6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fcd:	00 00 00 
  802fd0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fd7:	00 00 00 
  802fda:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fe1:	00 00 00 
  802fe4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802feb:	00 00 00 
  802fee:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ff5:	00 00 00 
  802ff8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  802fff:	00 
