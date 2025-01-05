
obj/user/lsfd:     file format elf64-x86-64


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
  80001e:	e8 53 01 00 00       	call   800176 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <usage>:
#include <inc/lib.h>

void
usage(void) {
  800025:	f3 0f 1e fa          	endbr64
  800029:	55                   	push   %rbp
  80002a:	48 89 e5             	mov    %rsp,%rbp
    cprintf("usage: lsfd [-1]\n");
  80002d:	48 bf 00 40 80 00 00 	movabs $0x804000,%rdi
  800034:	00 00 00 
  800037:	b8 00 00 00 00       	mov    $0x0,%eax
  80003c:	48 ba 04 03 80 00 00 	movabs $0x800304,%rdx
  800043:	00 00 00 
  800046:	ff d2                	call   *%rdx
    exit();
  800048:	48 b8 28 02 80 00 00 	movabs $0x800228,%rax
  80004f:	00 00 00 
  800052:	ff d0                	call   *%rax
}
  800054:	5d                   	pop    %rbp
  800055:	c3                   	ret

0000000000800056 <umain>:

void
umain(int argc, char **argv) {
  800056:	f3 0f 1e fa          	endbr64
  80005a:	55                   	push   %rbp
  80005b:	48 89 e5             	mov    %rsp,%rbp
  80005e:	41 57                	push   %r15
  800060:	41 56                	push   %r14
  800062:	41 55                	push   %r13
  800064:	41 54                	push   %r12
  800066:	53                   	push   %rbx
  800067:	48 81 ec c8 00 00 00 	sub    $0xc8,%rsp
  80006e:	89 bd 1c ff ff ff    	mov    %edi,-0xe4(%rbp)
    int i, usefprint = 0;
    struct Stat st;
    struct Argstate args;

    argstart(&argc, argv, &args);
  800074:	48 8d 95 20 ff ff ff 	lea    -0xe0(%rbp),%rdx
  80007b:	48 8d bd 1c ff ff ff 	lea    -0xe4(%rbp),%rdi
  800082:	48 b8 16 16 80 00 00 	movabs $0x801616,%rax
  800089:	00 00 00 
  80008c:	ff d0                	call   *%rax
    int i, usefprint = 0;
  80008e:	41 bc 00 00 00 00    	mov    $0x0,%r12d
    while ((i = argnext(&args)) >= 0) {
  800094:	48 bb 47 16 80 00 00 	movabs $0x801647,%rbx
  80009b:	00 00 00 
  80009e:	48 8d bd 20 ff ff ff 	lea    -0xe0(%rbp),%rdi
  8000a5:	ff d3                	call   *%rbx
  8000a7:	85 c0                	test   %eax,%eax
  8000a9:	78 1b                	js     8000c6 <umain+0x70>
        if (i == '1')
  8000ab:	83 f8 31             	cmp    $0x31,%eax
  8000ae:	75 08                	jne    8000b8 <umain+0x62>
            usefprint = 1;
  8000b0:	41 bc 01 00 00 00    	mov    $0x1,%r12d
  8000b6:	eb e6                	jmp    80009e <umain+0x48>
        else
            usage();
  8000b8:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  8000bf:	00 00 00 
  8000c2:	ff d0                	call   *%rax
  8000c4:	eb d8                	jmp    80009e <umain+0x48>
    }

    for (i = 0; i < 32; i++) {
  8000c6:	bb 00 00 00 00       	mov    $0x0,%ebx
        if (fstat(i, &st) >= 0) {
  8000cb:	49 bd 06 1e 80 00 00 	movabs $0x801e06,%r13
  8000d2:	00 00 00 
            if (usefprint) {
                fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
                        i, st.st_name, st.st_isdir,
                        st.st_size, st.st_dev->dev_name);
            } else {
                cprintf("fd %d: name %s isdir %d size %d dev %s\n",
  8000d5:	49 be 68 42 80 00 00 	movabs $0x804268,%r14
  8000dc:	00 00 00 
  8000df:	49 bf 04 03 80 00 00 	movabs $0x800304,%r15
  8000e6:	00 00 00 
  8000e9:	eb 2b                	jmp    800116 <umain+0xc0>
  8000eb:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8000ef:	4c 8b 48 08          	mov    0x8(%rax),%r9
  8000f3:	44 8b 45 c0          	mov    -0x40(%rbp),%r8d
  8000f7:	8b 4d c4             	mov    -0x3c(%rbp),%ecx
  8000fa:	48 8d 95 40 ff ff ff 	lea    -0xc0(%rbp),%rdx
  800101:	89 de                	mov    %ebx,%esi
  800103:	4c 89 f7             	mov    %r14,%rdi
  800106:	b8 00 00 00 00       	mov    $0x0,%eax
  80010b:	41 ff d7             	call   *%r15
    for (i = 0; i < 32; i++) {
  80010e:	83 c3 01             	add    $0x1,%ebx
  800111:	83 fb 20             	cmp    $0x20,%ebx
  800114:	74 51                	je     800167 <umain+0x111>
        if (fstat(i, &st) >= 0) {
  800116:	48 8d b5 40 ff ff ff 	lea    -0xc0(%rbp),%rsi
  80011d:	89 df                	mov    %ebx,%edi
  80011f:	41 ff d5             	call   *%r13
  800122:	85 c0                	test   %eax,%eax
  800124:	78 e8                	js     80010e <umain+0xb8>
            if (usefprint) {
  800126:	45 85 e4             	test   %r12d,%r12d
  800129:	74 c0                	je     8000eb <umain+0x95>
                fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
  80012b:	48 83 ec 08          	sub    $0x8,%rsp
  80012f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800133:	ff 70 08             	push   0x8(%rax)
  800136:	44 8b 4d c0          	mov    -0x40(%rbp),%r9d
  80013a:	44 8b 45 c4          	mov    -0x3c(%rbp),%r8d
  80013e:	48 8d 8d 40 ff ff ff 	lea    -0xc0(%rbp),%rcx
  800145:	89 da                	mov    %ebx,%edx
  800147:	4c 89 f6             	mov    %r14,%rsi
  80014a:	bf 01 00 00 00       	mov    $0x1,%edi
  80014f:	b8 00 00 00 00       	mov    $0x0,%eax
  800154:	49 ba 6d 23 80 00 00 	movabs $0x80236d,%r10
  80015b:	00 00 00 
  80015e:	41 ff d2             	call   *%r10
  800161:	48 83 c4 10          	add    $0x10,%rsp
  800165:	eb a7                	jmp    80010e <umain+0xb8>
                        i, st.st_name, st.st_isdir,
                        st.st_size, st.st_dev->dev_name);
            }
        }
    }
}
  800167:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  80016b:	5b                   	pop    %rbx
  80016c:	41 5c                	pop    %r12
  80016e:	41 5d                	pop    %r13
  800170:	41 5e                	pop    %r14
  800172:	41 5f                	pop    %r15
  800174:	5d                   	pop    %rbp
  800175:	c3                   	ret

0000000000800176 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  800176:	f3 0f 1e fa          	endbr64
  80017a:	55                   	push   %rbp
  80017b:	48 89 e5             	mov    %rsp,%rbp
  80017e:	41 56                	push   %r14
  800180:	41 55                	push   %r13
  800182:	41 54                	push   %r12
  800184:	53                   	push   %rbx
  800185:	41 89 fd             	mov    %edi,%r13d
  800188:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
     * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  80018b:	48 ba d8 50 80 00 00 	movabs $0x8050d8,%rdx
  800192:	00 00 00 
  800195:	48 b8 d8 50 80 00 00 	movabs $0x8050d8,%rax
  80019c:	00 00 00 
  80019f:	48 39 c2             	cmp    %rax,%rdx
  8001a2:	73 17                	jae    8001bb <libmain+0x45>
    void (**ctor)() = &__ctors_start;
  8001a4:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  8001a7:	49 89 c4             	mov    %rax,%r12
  8001aa:	48 83 c3 08          	add    $0x8,%rbx
  8001ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8001b3:	ff 53 f8             	call   *-0x8(%rbx)
  8001b6:	4c 39 e3             	cmp    %r12,%rbx
  8001b9:	72 ef                	jb     8001aa <libmain+0x34>

    /* Set thisenv to point at our Env structure in envs[]. */

    // LAB 8: Your code here
    thisenv = &((struct Env *)UENVS)[ENVX(sys_getenvid())];
  8001bb:	48 b8 82 11 80 00 00 	movabs $0x801182,%rax
  8001c2:	00 00 00 
  8001c5:	ff d0                	call   *%rax
  8001c7:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001cc:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8001d0:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8001d4:	48 c1 e0 04          	shl    $0x4,%rax
  8001d8:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  8001df:	00 00 00 
  8001e2:	48 01 d0             	add    %rdx,%rax
  8001e5:	48 a3 00 60 80 00 00 	movabs %rax,0x806000
  8001ec:	00 00 00 

    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  8001ef:	45 85 ed             	test   %r13d,%r13d
  8001f2:	7e 0d                	jle    800201 <libmain+0x8b>
  8001f4:	49 8b 06             	mov    (%r14),%rax
  8001f7:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  8001fe:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  800201:	4c 89 f6             	mov    %r14,%rsi
  800204:	44 89 ef             	mov    %r13d,%edi
  800207:	48 b8 56 00 80 00 00 	movabs $0x800056,%rax
  80020e:	00 00 00 
  800211:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  800213:	48 b8 28 02 80 00 00 	movabs $0x800228,%rax
  80021a:	00 00 00 
  80021d:	ff d0                	call   *%rax
#endif
}
  80021f:	5b                   	pop    %rbx
  800220:	41 5c                	pop    %r12
  800222:	41 5d                	pop    %r13
  800224:	41 5e                	pop    %r14
  800226:	5d                   	pop    %rbp
  800227:	c3                   	ret

0000000000800228 <exit>:

#include <inc/lib.h>

void
exit(void) {
  800228:	f3 0f 1e fa          	endbr64
  80022c:	55                   	push   %rbp
  80022d:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  800230:	48 b8 e2 19 80 00 00 	movabs $0x8019e2,%rax
  800237:	00 00 00 
  80023a:	ff d0                	call   *%rax
    sys_env_destroy(0);
  80023c:	bf 00 00 00 00       	mov    $0x0,%edi
  800241:	48 b8 13 11 80 00 00 	movabs $0x801113,%rax
  800248:	00 00 00 
  80024b:	ff d0                	call   *%rax
}
  80024d:	5d                   	pop    %rbp
  80024e:	c3                   	ret

000000000080024f <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  80024f:	f3 0f 1e fa          	endbr64
  800253:	55                   	push   %rbp
  800254:	48 89 e5             	mov    %rsp,%rbp
  800257:	53                   	push   %rbx
  800258:	48 83 ec 08          	sub    $0x8,%rsp
  80025c:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  80025f:	8b 06                	mov    (%rsi),%eax
  800261:	8d 50 01             	lea    0x1(%rax),%edx
  800264:	89 16                	mov    %edx,(%rsi)
  800266:	48 98                	cltq
  800268:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  80026d:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  800273:	74 0a                	je     80027f <putch+0x30>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  800275:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  800279:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80027d:	c9                   	leave
  80027e:	c3                   	ret
        sys_cputs(state->buf, state->offset);
  80027f:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  800283:	be ff 00 00 00       	mov    $0xff,%esi
  800288:	48 b8 ad 10 80 00 00 	movabs $0x8010ad,%rax
  80028f:	00 00 00 
  800292:	ff d0                	call   *%rax
        state->offset = 0;
  800294:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  80029a:	eb d9                	jmp    800275 <putch+0x26>

000000000080029c <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  80029c:	f3 0f 1e fa          	endbr64
  8002a0:	55                   	push   %rbp
  8002a1:	48 89 e5             	mov    %rsp,%rbp
  8002a4:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8002ab:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  8002ae:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  8002b5:	b9 21 00 00 00       	mov    $0x21,%ecx
  8002ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8002bf:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  8002c2:	48 89 f1             	mov    %rsi,%rcx
  8002c5:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  8002cc:	48 bf 4f 02 80 00 00 	movabs $0x80024f,%rdi
  8002d3:	00 00 00 
  8002d6:	48 b8 64 04 80 00 00 	movabs $0x800464,%rax
  8002dd:	00 00 00 
  8002e0:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  8002e2:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  8002e9:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  8002f0:	48 b8 ad 10 80 00 00 	movabs $0x8010ad,%rax
  8002f7:	00 00 00 
  8002fa:	ff d0                	call   *%rax

    return state.count;
}
  8002fc:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  800302:	c9                   	leave
  800303:	c3                   	ret

0000000000800304 <cprintf>:

int
cprintf(const char *fmt, ...) {
  800304:	f3 0f 1e fa          	endbr64
  800308:	55                   	push   %rbp
  800309:	48 89 e5             	mov    %rsp,%rbp
  80030c:	48 83 ec 50          	sub    $0x50,%rsp
  800310:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  800314:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  800318:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80031c:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800320:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  800324:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  80032b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80032f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800333:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800337:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  80033b:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  80033f:	48 b8 9c 02 80 00 00 	movabs $0x80029c,%rax
  800346:	00 00 00 
  800349:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  80034b:	c9                   	leave
  80034c:	c3                   	ret

000000000080034d <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  80034d:	f3 0f 1e fa          	endbr64
  800351:	55                   	push   %rbp
  800352:	48 89 e5             	mov    %rsp,%rbp
  800355:	41 57                	push   %r15
  800357:	41 56                	push   %r14
  800359:	41 55                	push   %r13
  80035b:	41 54                	push   %r12
  80035d:	53                   	push   %rbx
  80035e:	48 83 ec 18          	sub    $0x18,%rsp
  800362:	49 89 fc             	mov    %rdi,%r12
  800365:	49 89 f5             	mov    %rsi,%r13
  800368:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  80036c:	8b 45 10             	mov    0x10(%rbp),%eax
  80036f:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  800372:	41 89 cf             	mov    %ecx,%r15d
  800375:	4c 39 fa             	cmp    %r15,%rdx
  800378:	73 5b                	jae    8003d5 <print_num+0x88>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  80037a:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  80037e:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  800382:	85 db                	test   %ebx,%ebx
  800384:	7e 0e                	jle    800394 <print_num+0x47>
            putch(padc, put_arg);
  800386:	4c 89 ee             	mov    %r13,%rsi
  800389:	44 89 f7             	mov    %r14d,%edi
  80038c:	41 ff d4             	call   *%r12
        while (--width > 0) {
  80038f:	83 eb 01             	sub    $0x1,%ebx
  800392:	75 f2                	jne    800386 <print_num+0x39>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  800394:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  800398:	48 b9 2d 40 80 00 00 	movabs $0x80402d,%rcx
  80039f:	00 00 00 
  8003a2:	48 b8 1c 40 80 00 00 	movabs $0x80401c,%rax
  8003a9:	00 00 00 
  8003ac:	48 0f 45 c8          	cmovne %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  8003b0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8003b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8003b9:	49 f7 f7             	div    %r15
  8003bc:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  8003c0:	4c 89 ee             	mov    %r13,%rsi
  8003c3:	41 ff d4             	call   *%r12
}
  8003c6:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  8003ca:	5b                   	pop    %rbx
  8003cb:	41 5c                	pop    %r12
  8003cd:	41 5d                	pop    %r13
  8003cf:	41 5e                	pop    %r14
  8003d1:	41 5f                	pop    %r15
  8003d3:	5d                   	pop    %rbp
  8003d4:	c3                   	ret
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  8003d5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8003d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8003de:	49 f7 f7             	div    %r15
  8003e1:	48 83 ec 08          	sub    $0x8,%rsp
  8003e5:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  8003e9:	52                   	push   %rdx
  8003ea:	45 0f be c9          	movsbl %r9b,%r9d
  8003ee:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  8003f2:	48 89 c2             	mov    %rax,%rdx
  8003f5:	48 b8 4d 03 80 00 00 	movabs $0x80034d,%rax
  8003fc:	00 00 00 
  8003ff:	ff d0                	call   *%rax
  800401:	48 83 c4 10          	add    $0x10,%rsp
  800405:	eb 8d                	jmp    800394 <print_num+0x47>

0000000000800407 <sprintputch>:
    char *end;
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
  800407:	f3 0f 1e fa          	endbr64
    state->count++;
  80040b:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  80040f:	48 8b 06             	mov    (%rsi),%rax
  800412:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  800416:	73 0a                	jae    800422 <sprintputch+0x1b>
        *state->start++ = ch;
  800418:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80041c:	48 89 16             	mov    %rdx,(%rsi)
  80041f:	40 88 38             	mov    %dil,(%rax)
    }
}
  800422:	c3                   	ret

0000000000800423 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  800423:	f3 0f 1e fa          	endbr64
  800427:	55                   	push   %rbp
  800428:	48 89 e5             	mov    %rsp,%rbp
  80042b:	48 83 ec 50          	sub    $0x50,%rsp
  80042f:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800433:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800437:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  80043b:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800442:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800446:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80044a:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80044e:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  800452:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800456:	48 b8 64 04 80 00 00 	movabs $0x800464,%rax
  80045d:	00 00 00 
  800460:	ff d0                	call   *%rax
}
  800462:	c9                   	leave
  800463:	c3                   	ret

0000000000800464 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  800464:	f3 0f 1e fa          	endbr64
  800468:	55                   	push   %rbp
  800469:	48 89 e5             	mov    %rsp,%rbp
  80046c:	41 57                	push   %r15
  80046e:	41 56                	push   %r14
  800470:	41 55                	push   %r13
  800472:	41 54                	push   %r12
  800474:	53                   	push   %rbx
  800475:	48 83 ec 38          	sub    $0x38,%rsp
  800479:	49 89 fe             	mov    %rdi,%r14
  80047c:	49 89 f5             	mov    %rsi,%r13
  80047f:	48 89 d3             	mov    %rdx,%rbx
    va_copy(aq, ap);
  800482:	48 8b 01             	mov    (%rcx),%rax
  800485:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  800489:	48 8b 41 08          	mov    0x8(%rcx),%rax
  80048d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800491:	48 8b 41 10          	mov    0x10(%rcx),%rax
  800495:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  800499:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  80049d:	0f b6 3b             	movzbl (%rbx),%edi
  8004a0:	40 80 ff 25          	cmp    $0x25,%dil
  8004a4:	74 18                	je     8004be <vprintfmt+0x5a>
            if (!ch) return;
  8004a6:	40 84 ff             	test   %dil,%dil
  8004a9:	0f 84 b2 06 00 00    	je     800b61 <vprintfmt+0x6fd>
            putch(ch, put_arg);
  8004af:	40 0f b6 ff          	movzbl %dil,%edi
  8004b3:	4c 89 ee             	mov    %r13,%rsi
  8004b6:	41 ff d6             	call   *%r14
        while ((ch = *ufmt++) != '%') {
  8004b9:	4c 89 e3             	mov    %r12,%rbx
  8004bc:	eb db                	jmp    800499 <vprintfmt+0x35>
        bool altflag = 0, zflag = 0;
  8004be:	be 00 00 00 00       	mov    $0x0,%esi
  8004c3:	c6 45 ab 00          	movb   $0x0,-0x55(%rbp)
        unsigned lflag = 0, base = 10;
  8004c7:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  8004cc:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  8004d2:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  8004d9:	c6 45 aa 20          	movb   $0x20,-0x56(%rbp)
        switch (ch = *ufmt++) {
  8004dd:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  8004e2:	41 0f b6 04 24       	movzbl (%r12),%eax
  8004e7:	88 45 a0             	mov    %al,-0x60(%rbp)
  8004ea:	83 e8 23             	sub    $0x23,%eax
  8004ed:	3c 57                	cmp    $0x57,%al
  8004ef:	0f 87 52 06 00 00    	ja     800b47 <vprintfmt+0x6e3>
  8004f5:	0f b6 c0             	movzbl %al,%eax
  8004f8:	48 b9 80 43 80 00 00 	movabs $0x804380,%rcx
  8004ff:	00 00 00 
  800502:	3e ff 24 c1          	notrack jmp *(%rcx,%rax,8)
  800506:	49 89 dc             	mov    %rbx,%r12
            altflag = 1;
  800509:	c6 45 ab 01          	movb   $0x1,-0x55(%rbp)
  80050d:	eb ce                	jmp    8004dd <vprintfmt+0x79>
        switch (ch = *ufmt++) {
  80050f:	49 89 dc             	mov    %rbx,%r12
  800512:	be 01 00 00 00       	mov    $0x1,%esi
  800517:	eb c4                	jmp    8004dd <vprintfmt+0x79>
            padc = ch;
  800519:	0f b6 45 a0          	movzbl -0x60(%rbp),%eax
  80051d:	88 45 aa             	mov    %al,-0x56(%rbp)
        switch (ch = *ufmt++) {
  800520:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  800523:	eb b8                	jmp    8004dd <vprintfmt+0x79>
            precision = va_arg(aq, int);
  800525:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800528:	83 f8 2f             	cmp    $0x2f,%eax
  80052b:	77 24                	ja     800551 <vprintfmt+0xed>
  80052d:	89 c1                	mov    %eax,%ecx
  80052f:	48 03 4d c8          	add    -0x38(%rbp),%rcx
  800533:	83 c0 08             	add    $0x8,%eax
  800536:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800539:	44 8b 39             	mov    (%rcx),%r15d
        switch (ch = *ufmt++) {
  80053c:	49 89 dc             	mov    %rbx,%r12
            if (width < 0) {
  80053f:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800543:	79 98                	jns    8004dd <vprintfmt+0x79>
                width = precision;
  800545:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
                precision = -1;
  800549:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  80054f:	eb 8c                	jmp    8004dd <vprintfmt+0x79>
            precision = va_arg(aq, int);
  800551:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  800555:	48 8d 41 08          	lea    0x8(%rcx),%rax
  800559:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80055d:	eb da                	jmp    800539 <vprintfmt+0xd5>
                precision = precision * 10 + ch - '0';
  80055f:	44 0f b6 7d a0       	movzbl -0x60(%rbp),%r15d
  800564:	41 83 ef 30          	sub    $0x30,%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  800568:	41 0f b6 44 24 01    	movzbl 0x1(%r12),%eax
  80056e:	3c 39                	cmp    $0x39,%al
  800570:	77 1c                	ja     80058e <vprintfmt+0x12a>
            for (precision = 0;; ++ufmt) {
  800572:	48 83 c3 01          	add    $0x1,%rbx
                precision = precision * 10 + ch - '0';
  800576:	43 8d 0c bf          	lea    (%r15,%r15,4),%ecx
  80057a:	0f b6 c0             	movzbl %al,%eax
  80057d:	44 8d 7c 48 d0       	lea    -0x30(%rax,%rcx,2),%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  800582:	0f b6 03             	movzbl (%rbx),%eax
  800585:	3c 39                	cmp    $0x39,%al
  800587:	76 e9                	jbe    800572 <vprintfmt+0x10e>
        process_precision:
  800589:	49 89 dc             	mov    %rbx,%r12
  80058c:	eb b1                	jmp    80053f <vprintfmt+0xdb>
        switch (ch = *ufmt++) {
  80058e:	49 89 dc             	mov    %rbx,%r12
  800591:	eb ac                	jmp    80053f <vprintfmt+0xdb>
            width = MAX(0, width);
  800593:	8b 4d ac             	mov    -0x54(%rbp),%ecx
  800596:	85 c9                	test   %ecx,%ecx
  800598:	b8 00 00 00 00       	mov    $0x0,%eax
  80059d:	0f 49 c1             	cmovns %ecx,%eax
  8005a0:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  8005a3:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  8005a6:	e9 32 ff ff ff       	jmp    8004dd <vprintfmt+0x79>
            lflag++;
  8005ab:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  8005ae:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  8005b1:	e9 27 ff ff ff       	jmp    8004dd <vprintfmt+0x79>
            putch(va_arg(aq, int), put_arg);
  8005b6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8005b9:	83 f8 2f             	cmp    $0x2f,%eax
  8005bc:	77 19                	ja     8005d7 <vprintfmt+0x173>
  8005be:	89 c2                	mov    %eax,%edx
  8005c0:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8005c4:	83 c0 08             	add    $0x8,%eax
  8005c7:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8005ca:	8b 3a                	mov    (%rdx),%edi
  8005cc:	4c 89 ee             	mov    %r13,%rsi
  8005cf:	41 ff d6             	call   *%r14
            break;
  8005d2:	e9 c2 fe ff ff       	jmp    800499 <vprintfmt+0x35>
            putch(va_arg(aq, int), put_arg);
  8005d7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8005db:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8005df:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8005e3:	eb e5                	jmp    8005ca <vprintfmt+0x166>
            int err = va_arg(aq, int);
  8005e5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8005e8:	83 f8 2f             	cmp    $0x2f,%eax
  8005eb:	77 5a                	ja     800647 <vprintfmt+0x1e3>
  8005ed:	89 c2                	mov    %eax,%edx
  8005ef:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8005f3:	83 c0 08             	add    $0x8,%eax
  8005f6:	89 45 b8             	mov    %eax,-0x48(%rbp)
            if (err < 0) err = -err;
  8005f9:	8b 02                	mov    (%rdx),%eax
  8005fb:	89 c1                	mov    %eax,%ecx
  8005fd:	f7 d9                	neg    %ecx
  8005ff:	0f 48 c8             	cmovs  %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  800602:	83 f9 13             	cmp    $0x13,%ecx
  800605:	7f 4e                	jg     800655 <vprintfmt+0x1f1>
  800607:	48 63 c1             	movslq %ecx,%rax
  80060a:	48 ba 40 46 80 00 00 	movabs $0x804640,%rdx
  800611:	00 00 00 
  800614:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  800618:	48 85 c0             	test   %rax,%rax
  80061b:	74 38                	je     800655 <vprintfmt+0x1f1>
                printfmt(putch, put_arg, "%s", strerr);
  80061d:	48 89 c1             	mov    %rax,%rcx
  800620:	48 ba 21 42 80 00 00 	movabs $0x804221,%rdx
  800627:	00 00 00 
  80062a:	4c 89 ee             	mov    %r13,%rsi
  80062d:	4c 89 f7             	mov    %r14,%rdi
  800630:	b8 00 00 00 00       	mov    $0x0,%eax
  800635:	49 b8 23 04 80 00 00 	movabs $0x800423,%r8
  80063c:	00 00 00 
  80063f:	41 ff d0             	call   *%r8
  800642:	e9 52 fe ff ff       	jmp    800499 <vprintfmt+0x35>
            int err = va_arg(aq, int);
  800647:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80064b:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80064f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800653:	eb a4                	jmp    8005f9 <vprintfmt+0x195>
                printfmt(putch, put_arg, "error %d", err);
  800655:	48 ba 45 40 80 00 00 	movabs $0x804045,%rdx
  80065c:	00 00 00 
  80065f:	4c 89 ee             	mov    %r13,%rsi
  800662:	4c 89 f7             	mov    %r14,%rdi
  800665:	b8 00 00 00 00       	mov    $0x0,%eax
  80066a:	49 b8 23 04 80 00 00 	movabs $0x800423,%r8
  800671:	00 00 00 
  800674:	41 ff d0             	call   *%r8
  800677:	e9 1d fe ff ff       	jmp    800499 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  80067c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80067f:	83 f8 2f             	cmp    $0x2f,%eax
  800682:	77 6c                	ja     8006f0 <vprintfmt+0x28c>
  800684:	89 c2                	mov    %eax,%edx
  800686:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80068a:	83 c0 08             	add    $0x8,%eax
  80068d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800690:	48 8b 12             	mov    (%rdx),%rdx
            if (!ptr) ptr = "(null)";
  800693:	48 85 d2             	test   %rdx,%rdx
  800696:	48 b8 3e 40 80 00 00 	movabs $0x80403e,%rax
  80069d:	00 00 00 
  8006a0:	48 0f 45 c2          	cmovne %rdx,%rax
  8006a4:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
            if (width > 0 && padc != '-') {
  8006a8:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8006ac:	7e 06                	jle    8006b4 <vprintfmt+0x250>
  8006ae:	80 7d aa 2d          	cmpb   $0x2d,-0x56(%rbp)
  8006b2:	75 4a                	jne    8006fe <vprintfmt+0x29a>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  8006b4:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8006b8:	4c 8d 60 01          	lea    0x1(%rax),%r12
  8006bc:	0f b6 00             	movzbl (%rax),%eax
  8006bf:	84 c0                	test   %al,%al
  8006c1:	0f 85 9a 00 00 00    	jne    800761 <vprintfmt+0x2fd>
            while (width-- > 0) putch(' ', put_arg);
  8006c7:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8006ca:	44 8d 60 ff          	lea    -0x1(%rax),%r12d
  8006ce:	85 c0                	test   %eax,%eax
  8006d0:	0f 8e c3 fd ff ff    	jle    800499 <vprintfmt+0x35>
  8006d6:	4c 89 ee             	mov    %r13,%rsi
  8006d9:	bf 20 00 00 00       	mov    $0x20,%edi
  8006de:	41 ff d6             	call   *%r14
  8006e1:	41 83 ec 01          	sub    $0x1,%r12d
  8006e5:	41 83 fc ff          	cmp    $0xffffffff,%r12d
  8006e9:	75 eb                	jne    8006d6 <vprintfmt+0x272>
  8006eb:	e9 a9 fd ff ff       	jmp    800499 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  8006f0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8006f4:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8006f8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8006fc:	eb 92                	jmp    800690 <vprintfmt+0x22c>
                width -= strnlen(ptr, precision);
  8006fe:	49 63 f7             	movslq %r15d,%rsi
  800701:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  800705:	48 b8 27 0c 80 00 00 	movabs $0x800c27,%rax
  80070c:	00 00 00 
  80070f:	ff d0                	call   *%rax
  800711:	48 89 c2             	mov    %rax,%rdx
  800714:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800717:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  800719:	8d 70 ff             	lea    -0x1(%rax),%esi
  80071c:	89 75 ac             	mov    %esi,-0x54(%rbp)
  80071f:	85 c0                	test   %eax,%eax
  800721:	7e 91                	jle    8006b4 <vprintfmt+0x250>
  800723:	44 0f be 65 aa       	movsbl -0x56(%rbp),%r12d
  800728:	4c 89 ee             	mov    %r13,%rsi
  80072b:	44 89 e7             	mov    %r12d,%edi
  80072e:	41 ff d6             	call   *%r14
  800731:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  800735:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800738:	83 f8 ff             	cmp    $0xffffffff,%eax
  80073b:	75 eb                	jne    800728 <vprintfmt+0x2c4>
  80073d:	e9 72 ff ff ff       	jmp    8006b4 <vprintfmt+0x250>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800742:	0f b6 f8             	movzbl %al,%edi
  800745:	4c 89 ee             	mov    %r13,%rsi
  800748:	41 ff d6             	call   *%r14
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  80074b:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  80074f:	49 83 c4 01          	add    $0x1,%r12
  800753:	41 0f b6 44 24 ff    	movzbl -0x1(%r12),%eax
  800759:	84 c0                	test   %al,%al
  80075b:	0f 84 66 ff ff ff    	je     8006c7 <vprintfmt+0x263>
  800761:	45 85 ff             	test   %r15d,%r15d
  800764:	78 0a                	js     800770 <vprintfmt+0x30c>
  800766:	41 83 ef 01          	sub    $0x1,%r15d
  80076a:	0f 88 57 ff ff ff    	js     8006c7 <vprintfmt+0x263>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800770:	80 7d ab 00          	cmpb   $0x0,-0x55(%rbp)
  800774:	74 cc                	je     800742 <vprintfmt+0x2de>
  800776:	8d 50 e0             	lea    -0x20(%rax),%edx
  800779:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80077e:	80 fa 5e             	cmp    $0x5e,%dl
  800781:	77 c2                	ja     800745 <vprintfmt+0x2e1>
  800783:	eb bd                	jmp    800742 <vprintfmt+0x2de>
    if (zflag) return va_arg(*ap, size_t);
  800785:	40 84 f6             	test   %sil,%sil
  800788:	75 26                	jne    8007b0 <vprintfmt+0x34c>
    switch (lflag) {
  80078a:	85 d2                	test   %edx,%edx
  80078c:	74 59                	je     8007e7 <vprintfmt+0x383>
  80078e:	83 fa 01             	cmp    $0x1,%edx
  800791:	74 7b                	je     80080e <vprintfmt+0x3aa>
        return va_arg(*ap, long long);
  800793:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800796:	83 f8 2f             	cmp    $0x2f,%eax
  800799:	0f 87 96 00 00 00    	ja     800835 <vprintfmt+0x3d1>
  80079f:	89 c2                	mov    %eax,%edx
  8007a1:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8007a5:	83 c0 08             	add    $0x8,%eax
  8007a8:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007ab:	4c 8b 22             	mov    (%rdx),%r12
  8007ae:	eb 17                	jmp    8007c7 <vprintfmt+0x363>
    if (zflag) return va_arg(*ap, size_t);
  8007b0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007b3:	83 f8 2f             	cmp    $0x2f,%eax
  8007b6:	77 21                	ja     8007d9 <vprintfmt+0x375>
  8007b8:	89 c2                	mov    %eax,%edx
  8007ba:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8007be:	83 c0 08             	add    $0x8,%eax
  8007c1:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007c4:	4c 8b 22             	mov    (%rdx),%r12
            if (i < 0) {
  8007c7:	4d 85 e4             	test   %r12,%r12
  8007ca:	78 7a                	js     800846 <vprintfmt+0x3e2>
            num = i;
  8007cc:	4c 89 e2             	mov    %r12,%rdx
        unsigned lflag = 0, base = 10;
  8007cf:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  8007d4:	e9 50 02 00 00       	jmp    800a29 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8007d9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007dd:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8007e1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007e5:	eb dd                	jmp    8007c4 <vprintfmt+0x360>
        return va_arg(*ap, int);
  8007e7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007ea:	83 f8 2f             	cmp    $0x2f,%eax
  8007ed:	77 11                	ja     800800 <vprintfmt+0x39c>
  8007ef:	89 c2                	mov    %eax,%edx
  8007f1:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8007f5:	83 c0 08             	add    $0x8,%eax
  8007f8:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007fb:	4c 63 22             	movslq (%rdx),%r12
  8007fe:	eb c7                	jmp    8007c7 <vprintfmt+0x363>
  800800:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800804:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800808:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80080c:	eb ed                	jmp    8007fb <vprintfmt+0x397>
        return va_arg(*ap, long);
  80080e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800811:	83 f8 2f             	cmp    $0x2f,%eax
  800814:	77 11                	ja     800827 <vprintfmt+0x3c3>
  800816:	89 c2                	mov    %eax,%edx
  800818:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80081c:	83 c0 08             	add    $0x8,%eax
  80081f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800822:	4c 8b 22             	mov    (%rdx),%r12
  800825:	eb a0                	jmp    8007c7 <vprintfmt+0x363>
  800827:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80082b:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80082f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800833:	eb ed                	jmp    800822 <vprintfmt+0x3be>
        return va_arg(*ap, long long);
  800835:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800839:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80083d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800841:	e9 65 ff ff ff       	jmp    8007ab <vprintfmt+0x347>
                putch('-', put_arg);
  800846:	4c 89 ee             	mov    %r13,%rsi
  800849:	bf 2d 00 00 00       	mov    $0x2d,%edi
  80084e:	41 ff d6             	call   *%r14
                i = -i;
  800851:	49 f7 dc             	neg    %r12
  800854:	e9 73 ff ff ff       	jmp    8007cc <vprintfmt+0x368>
    if (zflag) return va_arg(*ap, size_t);
  800859:	40 84 f6             	test   %sil,%sil
  80085c:	75 32                	jne    800890 <vprintfmt+0x42c>
    switch (lflag) {
  80085e:	85 d2                	test   %edx,%edx
  800860:	74 5d                	je     8008bf <vprintfmt+0x45b>
  800862:	83 fa 01             	cmp    $0x1,%edx
  800865:	0f 84 82 00 00 00    	je     8008ed <vprintfmt+0x489>
        return va_arg(*ap, unsigned long long);
  80086b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80086e:	83 f8 2f             	cmp    $0x2f,%eax
  800871:	0f 87 a5 00 00 00    	ja     80091c <vprintfmt+0x4b8>
  800877:	89 c2                	mov    %eax,%edx
  800879:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80087d:	83 c0 08             	add    $0x8,%eax
  800880:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800883:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800886:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  80088b:	e9 99 01 00 00       	jmp    800a29 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800890:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800893:	83 f8 2f             	cmp    $0x2f,%eax
  800896:	77 19                	ja     8008b1 <vprintfmt+0x44d>
  800898:	89 c2                	mov    %eax,%edx
  80089a:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80089e:	83 c0 08             	add    $0x8,%eax
  8008a1:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008a4:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  8008a7:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8008ac:	e9 78 01 00 00       	jmp    800a29 <vprintfmt+0x5c5>
  8008b1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008b5:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8008b9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008bd:	eb e5                	jmp    8008a4 <vprintfmt+0x440>
        return va_arg(*ap, unsigned int);
  8008bf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008c2:	83 f8 2f             	cmp    $0x2f,%eax
  8008c5:	77 18                	ja     8008df <vprintfmt+0x47b>
  8008c7:	89 c2                	mov    %eax,%edx
  8008c9:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8008cd:	83 c0 08             	add    $0x8,%eax
  8008d0:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008d3:	8b 12                	mov    (%rdx),%edx
        unsigned lflag = 0, base = 10;
  8008d5:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  8008da:	e9 4a 01 00 00       	jmp    800a29 <vprintfmt+0x5c5>
  8008df:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008e3:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8008e7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008eb:	eb e6                	jmp    8008d3 <vprintfmt+0x46f>
        return va_arg(*ap, unsigned long);
  8008ed:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008f0:	83 f8 2f             	cmp    $0x2f,%eax
  8008f3:	77 19                	ja     80090e <vprintfmt+0x4aa>
  8008f5:	89 c2                	mov    %eax,%edx
  8008f7:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8008fb:	83 c0 08             	add    $0x8,%eax
  8008fe:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800901:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800904:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  800909:	e9 1b 01 00 00       	jmp    800a29 <vprintfmt+0x5c5>
  80090e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800912:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800916:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80091a:	eb e5                	jmp    800901 <vprintfmt+0x49d>
        return va_arg(*ap, unsigned long long);
  80091c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800920:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800924:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800928:	e9 56 ff ff ff       	jmp    800883 <vprintfmt+0x41f>
    if (zflag) return va_arg(*ap, size_t);
  80092d:	40 84 f6             	test   %sil,%sil
  800930:	75 2e                	jne    800960 <vprintfmt+0x4fc>
    switch (lflag) {
  800932:	85 d2                	test   %edx,%edx
  800934:	74 59                	je     80098f <vprintfmt+0x52b>
  800936:	83 fa 01             	cmp    $0x1,%edx
  800939:	74 7f                	je     8009ba <vprintfmt+0x556>
        return va_arg(*ap, unsigned long long);
  80093b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80093e:	83 f8 2f             	cmp    $0x2f,%eax
  800941:	0f 87 9f 00 00 00    	ja     8009e6 <vprintfmt+0x582>
  800947:	89 c2                	mov    %eax,%edx
  800949:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80094d:	83 c0 08             	add    $0x8,%eax
  800950:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800953:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800956:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  80095b:	e9 c9 00 00 00       	jmp    800a29 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800960:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800963:	83 f8 2f             	cmp    $0x2f,%eax
  800966:	77 19                	ja     800981 <vprintfmt+0x51d>
  800968:	89 c2                	mov    %eax,%edx
  80096a:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80096e:	83 c0 08             	add    $0x8,%eax
  800971:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800974:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800977:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  80097c:	e9 a8 00 00 00       	jmp    800a29 <vprintfmt+0x5c5>
  800981:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800985:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800989:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80098d:	eb e5                	jmp    800974 <vprintfmt+0x510>
        return va_arg(*ap, unsigned int);
  80098f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800992:	83 f8 2f             	cmp    $0x2f,%eax
  800995:	77 15                	ja     8009ac <vprintfmt+0x548>
  800997:	89 c2                	mov    %eax,%edx
  800999:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80099d:	83 c0 08             	add    $0x8,%eax
  8009a0:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009a3:	8b 12                	mov    (%rdx),%edx
            base = 8;
  8009a5:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  8009aa:	eb 7d                	jmp    800a29 <vprintfmt+0x5c5>
  8009ac:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009b0:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009b4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009b8:	eb e9                	jmp    8009a3 <vprintfmt+0x53f>
        return va_arg(*ap, unsigned long);
  8009ba:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009bd:	83 f8 2f             	cmp    $0x2f,%eax
  8009c0:	77 16                	ja     8009d8 <vprintfmt+0x574>
  8009c2:	89 c2                	mov    %eax,%edx
  8009c4:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8009c8:	83 c0 08             	add    $0x8,%eax
  8009cb:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009ce:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  8009d1:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  8009d6:	eb 51                	jmp    800a29 <vprintfmt+0x5c5>
  8009d8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009dc:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009e0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009e4:	eb e8                	jmp    8009ce <vprintfmt+0x56a>
        return va_arg(*ap, unsigned long long);
  8009e6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009ea:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009ee:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009f2:	e9 5c ff ff ff       	jmp    800953 <vprintfmt+0x4ef>
            putch('0', put_arg);
  8009f7:	4c 89 ee             	mov    %r13,%rsi
  8009fa:	bf 30 00 00 00       	mov    $0x30,%edi
  8009ff:	41 ff d6             	call   *%r14
            putch('x', put_arg);
  800a02:	4c 89 ee             	mov    %r13,%rsi
  800a05:	bf 78 00 00 00       	mov    $0x78,%edi
  800a0a:	41 ff d6             	call   *%r14
            num = (uintptr_t)va_arg(aq, void *);
  800a0d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a10:	83 f8 2f             	cmp    $0x2f,%eax
  800a13:	77 47                	ja     800a5c <vprintfmt+0x5f8>
  800a15:	89 c2                	mov    %eax,%edx
  800a17:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a1b:	83 c0 08             	add    $0x8,%eax
  800a1e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a21:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800a24:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  800a29:	48 83 ec 08          	sub    $0x8,%rsp
  800a2d:	80 7d a0 58          	cmpb   $0x58,-0x60(%rbp)
  800a31:	0f 94 c0             	sete   %al
  800a34:	0f b6 c0             	movzbl %al,%eax
  800a37:	50                   	push   %rax
  800a38:	44 0f be 4d aa       	movsbl -0x56(%rbp),%r9d
  800a3d:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  800a41:	4c 89 ee             	mov    %r13,%rsi
  800a44:	4c 89 f7             	mov    %r14,%rdi
  800a47:	48 b8 4d 03 80 00 00 	movabs $0x80034d,%rax
  800a4e:	00 00 00 
  800a51:	ff d0                	call   *%rax
            break;
  800a53:	48 83 c4 10          	add    $0x10,%rsp
  800a57:	e9 3d fa ff ff       	jmp    800499 <vprintfmt+0x35>
            num = (uintptr_t)va_arg(aq, void *);
  800a5c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a60:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a64:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a68:	eb b7                	jmp    800a21 <vprintfmt+0x5bd>
    if (zflag) return va_arg(*ap, size_t);
  800a6a:	40 84 f6             	test   %sil,%sil
  800a6d:	75 2b                	jne    800a9a <vprintfmt+0x636>
    switch (lflag) {
  800a6f:	85 d2                	test   %edx,%edx
  800a71:	74 56                	je     800ac9 <vprintfmt+0x665>
  800a73:	83 fa 01             	cmp    $0x1,%edx
  800a76:	74 7f                	je     800af7 <vprintfmt+0x693>
        return va_arg(*ap, unsigned long long);
  800a78:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a7b:	83 f8 2f             	cmp    $0x2f,%eax
  800a7e:	0f 87 a2 00 00 00    	ja     800b26 <vprintfmt+0x6c2>
  800a84:	89 c2                	mov    %eax,%edx
  800a86:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a8a:	83 c0 08             	add    $0x8,%eax
  800a8d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a90:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800a93:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800a98:	eb 8f                	jmp    800a29 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800a9a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a9d:	83 f8 2f             	cmp    $0x2f,%eax
  800aa0:	77 19                	ja     800abb <vprintfmt+0x657>
  800aa2:	89 c2                	mov    %eax,%edx
  800aa4:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800aa8:	83 c0 08             	add    $0x8,%eax
  800aab:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800aae:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800ab1:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800ab6:	e9 6e ff ff ff       	jmp    800a29 <vprintfmt+0x5c5>
  800abb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800abf:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800ac3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ac7:	eb e5                	jmp    800aae <vprintfmt+0x64a>
        return va_arg(*ap, unsigned int);
  800ac9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800acc:	83 f8 2f             	cmp    $0x2f,%eax
  800acf:	77 18                	ja     800ae9 <vprintfmt+0x685>
  800ad1:	89 c2                	mov    %eax,%edx
  800ad3:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800ad7:	83 c0 08             	add    $0x8,%eax
  800ada:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800add:	8b 12                	mov    (%rdx),%edx
            base = 16;
  800adf:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  800ae4:	e9 40 ff ff ff       	jmp    800a29 <vprintfmt+0x5c5>
  800ae9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800aed:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800af1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800af5:	eb e6                	jmp    800add <vprintfmt+0x679>
        return va_arg(*ap, unsigned long);
  800af7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800afa:	83 f8 2f             	cmp    $0x2f,%eax
  800afd:	77 19                	ja     800b18 <vprintfmt+0x6b4>
  800aff:	89 c2                	mov    %eax,%edx
  800b01:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b05:	83 c0 08             	add    $0x8,%eax
  800b08:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b0b:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800b0e:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800b13:	e9 11 ff ff ff       	jmp    800a29 <vprintfmt+0x5c5>
  800b18:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b1c:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b20:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b24:	eb e5                	jmp    800b0b <vprintfmt+0x6a7>
        return va_arg(*ap, unsigned long long);
  800b26:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b2a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b2e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b32:	e9 59 ff ff ff       	jmp    800a90 <vprintfmt+0x62c>
            putch(ch, put_arg);
  800b37:	4c 89 ee             	mov    %r13,%rsi
  800b3a:	bf 25 00 00 00       	mov    $0x25,%edi
  800b3f:	41 ff d6             	call   *%r14
            break;
  800b42:	e9 52 f9 ff ff       	jmp    800499 <vprintfmt+0x35>
            putch('%', put_arg);
  800b47:	4c 89 ee             	mov    %r13,%rsi
  800b4a:	bf 25 00 00 00       	mov    $0x25,%edi
  800b4f:	41 ff d6             	call   *%r14
            while ((--ufmt)[-1] != '%') /* nothing */
  800b52:	48 83 eb 01          	sub    $0x1,%rbx
  800b56:	80 7b ff 25          	cmpb   $0x25,-0x1(%rbx)
  800b5a:	75 f6                	jne    800b52 <vprintfmt+0x6ee>
  800b5c:	e9 38 f9 ff ff       	jmp    800499 <vprintfmt+0x35>
}
  800b61:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800b65:	5b                   	pop    %rbx
  800b66:	41 5c                	pop    %r12
  800b68:	41 5d                	pop    %r13
  800b6a:	41 5e                	pop    %r14
  800b6c:	41 5f                	pop    %r15
  800b6e:	5d                   	pop    %rbp
  800b6f:	c3                   	ret

0000000000800b70 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800b70:	f3 0f 1e fa          	endbr64
  800b74:	55                   	push   %rbp
  800b75:	48 89 e5             	mov    %rsp,%rbp
  800b78:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800b7c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800b80:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800b85:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800b89:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800b90:	48 85 ff             	test   %rdi,%rdi
  800b93:	74 2b                	je     800bc0 <vsnprintf+0x50>
  800b95:	48 85 f6             	test   %rsi,%rsi
  800b98:	74 26                	je     800bc0 <vsnprintf+0x50>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800b9a:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800b9e:	48 bf 07 04 80 00 00 	movabs $0x800407,%rdi
  800ba5:	00 00 00 
  800ba8:	48 b8 64 04 80 00 00 	movabs $0x800464,%rax
  800baf:	00 00 00 
  800bb2:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800bb4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bb8:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800bbb:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800bbe:	c9                   	leave
  800bbf:	c3                   	ret
    if (!buf || n < 1) return -E_INVAL;
  800bc0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800bc5:	eb f7                	jmp    800bbe <vsnprintf+0x4e>

0000000000800bc7 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800bc7:	f3 0f 1e fa          	endbr64
  800bcb:	55                   	push   %rbp
  800bcc:	48 89 e5             	mov    %rsp,%rbp
  800bcf:	48 83 ec 50          	sub    $0x50,%rsp
  800bd3:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800bd7:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800bdb:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800bdf:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800be6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800bea:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800bee:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800bf2:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800bf6:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800bfa:	48 b8 70 0b 80 00 00 	movabs $0x800b70,%rax
  800c01:	00 00 00 
  800c04:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800c06:	c9                   	leave
  800c07:	c3                   	ret

0000000000800c08 <strlen>:
 * Primespipe runs 3x faster this way */

#define ASM 1

size_t
strlen(const char *s) {
  800c08:	f3 0f 1e fa          	endbr64
    size_t n = 0;
    while (*s++) n++;
  800c0c:	80 3f 00             	cmpb   $0x0,(%rdi)
  800c0f:	74 10                	je     800c21 <strlen+0x19>
    size_t n = 0;
  800c11:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800c16:	48 83 c0 01          	add    $0x1,%rax
  800c1a:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800c1e:	75 f6                	jne    800c16 <strlen+0xe>
  800c20:	c3                   	ret
    size_t n = 0;
  800c21:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800c26:	c3                   	ret

0000000000800c27 <strnlen>:

size_t
strnlen(const char *s, size_t size) {
  800c27:	f3 0f 1e fa          	endbr64
  800c2b:	48 89 f0             	mov    %rsi,%rax
    size_t n = 0;
  800c2e:	ba 00 00 00 00       	mov    $0x0,%edx
    while (n < size && *s++) n++;
  800c33:	48 85 f6             	test   %rsi,%rsi
  800c36:	74 10                	je     800c48 <strnlen+0x21>
  800c38:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  800c3c:	74 0b                	je     800c49 <strnlen+0x22>
  800c3e:	48 83 c2 01          	add    $0x1,%rdx
  800c42:	48 39 d0             	cmp    %rdx,%rax
  800c45:	75 f1                	jne    800c38 <strnlen+0x11>
  800c47:	c3                   	ret
  800c48:	c3                   	ret
  800c49:	48 89 d0             	mov    %rdx,%rax
    return n;
}
  800c4c:	c3                   	ret

0000000000800c4d <strcpy>:

char *
strcpy(char *dst, const char *src) {
  800c4d:	f3 0f 1e fa          	endbr64
  800c51:	48 89 f8             	mov    %rdi,%rax
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800c54:	ba 00 00 00 00       	mov    $0x0,%edx
  800c59:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  800c5d:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  800c60:	48 83 c2 01          	add    $0x1,%rdx
  800c64:	84 c9                	test   %cl,%cl
  800c66:	75 f1                	jne    800c59 <strcpy+0xc>
        ;
    return res;
}
  800c68:	c3                   	ret

0000000000800c69 <strcat>:

char *
strcat(char *dst, const char *src) {
  800c69:	f3 0f 1e fa          	endbr64
  800c6d:	55                   	push   %rbp
  800c6e:	48 89 e5             	mov    %rsp,%rbp
  800c71:	41 54                	push   %r12
  800c73:	53                   	push   %rbx
  800c74:	48 89 fb             	mov    %rdi,%rbx
  800c77:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800c7a:	48 b8 08 0c 80 00 00 	movabs $0x800c08,%rax
  800c81:	00 00 00 
  800c84:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800c86:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800c8a:	4c 89 e6             	mov    %r12,%rsi
  800c8d:	48 b8 4d 0c 80 00 00 	movabs $0x800c4d,%rax
  800c94:	00 00 00 
  800c97:	ff d0                	call   *%rax
    return dst;
}
  800c99:	48 89 d8             	mov    %rbx,%rax
  800c9c:	5b                   	pop    %rbx
  800c9d:	41 5c                	pop    %r12
  800c9f:	5d                   	pop    %rbp
  800ca0:	c3                   	ret

0000000000800ca1 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800ca1:	f3 0f 1e fa          	endbr64
  800ca5:	48 89 f8             	mov    %rdi,%rax
    char *ret = dst;
    while (size-- > 0) {
  800ca8:	48 85 d2             	test   %rdx,%rdx
  800cab:	74 1f                	je     800ccc <strncpy+0x2b>
  800cad:	48 01 fa             	add    %rdi,%rdx
  800cb0:	48 89 f9             	mov    %rdi,%rcx
        *dst++ = *src;
  800cb3:	48 83 c1 01          	add    $0x1,%rcx
  800cb7:	44 0f b6 06          	movzbl (%rsi),%r8d
  800cbb:	44 88 41 ff          	mov    %r8b,-0x1(%rcx)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800cbf:	41 80 f8 01          	cmp    $0x1,%r8b
  800cc3:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800cc7:	48 39 ca             	cmp    %rcx,%rdx
  800cca:	75 e7                	jne    800cb3 <strncpy+0x12>
    }
    return ret;
}
  800ccc:	c3                   	ret

0000000000800ccd <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
  800ccd:	f3 0f 1e fa          	endbr64
    char *dst_in = dst;
    if (size) {
  800cd1:	48 89 f8             	mov    %rdi,%rax
  800cd4:	48 85 d2             	test   %rdx,%rdx
  800cd7:	74 24                	je     800cfd <strlcpy+0x30>
        while (--size > 0 && *src)
  800cd9:	48 83 ea 01          	sub    $0x1,%rdx
  800cdd:	74 1b                	je     800cfa <strlcpy+0x2d>
  800cdf:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800ce3:	0f b6 16             	movzbl (%rsi),%edx
  800ce6:	84 d2                	test   %dl,%dl
  800ce8:	74 10                	je     800cfa <strlcpy+0x2d>
            *dst++ = *src++;
  800cea:	48 83 c6 01          	add    $0x1,%rsi
  800cee:	48 83 c0 01          	add    $0x1,%rax
  800cf2:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800cf5:	48 39 c8             	cmp    %rcx,%rax
  800cf8:	75 e9                	jne    800ce3 <strlcpy+0x16>
        *dst = '\0';
  800cfa:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800cfd:	48 29 f8             	sub    %rdi,%rax
}
  800d00:	c3                   	ret

0000000000800d01 <strcmp>:
    }
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
  800d01:	f3 0f 1e fa          	endbr64
    while (*p && *p == *q) p++, q++;
  800d05:	0f b6 07             	movzbl (%rdi),%eax
  800d08:	84 c0                	test   %al,%al
  800d0a:	74 13                	je     800d1f <strcmp+0x1e>
  800d0c:	38 06                	cmp    %al,(%rsi)
  800d0e:	75 0f                	jne    800d1f <strcmp+0x1e>
  800d10:	48 83 c7 01          	add    $0x1,%rdi
  800d14:	48 83 c6 01          	add    $0x1,%rsi
  800d18:	0f b6 07             	movzbl (%rdi),%eax
  800d1b:	84 c0                	test   %al,%al
  800d1d:	75 ed                	jne    800d0c <strcmp+0xb>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800d1f:	0f b6 c0             	movzbl %al,%eax
  800d22:	0f b6 16             	movzbl (%rsi),%edx
  800d25:	29 d0                	sub    %edx,%eax
}
  800d27:	c3                   	ret

0000000000800d28 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
  800d28:	f3 0f 1e fa          	endbr64
    while (n && *p && *p == *q) n--, p++, q++;
  800d2c:	48 85 d2             	test   %rdx,%rdx
  800d2f:	74 1f                	je     800d50 <strncmp+0x28>
  800d31:	0f b6 07             	movzbl (%rdi),%eax
  800d34:	84 c0                	test   %al,%al
  800d36:	74 1e                	je     800d56 <strncmp+0x2e>
  800d38:	3a 06                	cmp    (%rsi),%al
  800d3a:	75 1a                	jne    800d56 <strncmp+0x2e>
  800d3c:	48 83 c7 01          	add    $0x1,%rdi
  800d40:	48 83 c6 01          	add    $0x1,%rsi
  800d44:	48 83 ea 01          	sub    $0x1,%rdx
  800d48:	75 e7                	jne    800d31 <strncmp+0x9>

    if (!n) return 0;
  800d4a:	b8 00 00 00 00       	mov    $0x0,%eax
  800d4f:	c3                   	ret
  800d50:	b8 00 00 00 00       	mov    $0x0,%eax
  800d55:	c3                   	ret

    return (int)((unsigned char)*p - (unsigned char)*q);
  800d56:	0f b6 07             	movzbl (%rdi),%eax
  800d59:	0f b6 16             	movzbl (%rsi),%edx
  800d5c:	29 d0                	sub    %edx,%eax
}
  800d5e:	c3                   	ret

0000000000800d5f <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
  800d5f:	f3 0f 1e fa          	endbr64
    for (; *str; str++) {
  800d63:	0f b6 17             	movzbl (%rdi),%edx
  800d66:	84 d2                	test   %dl,%dl
  800d68:	74 18                	je     800d82 <strchr+0x23>
        if (*str == c) {
  800d6a:	0f be d2             	movsbl %dl,%edx
  800d6d:	39 f2                	cmp    %esi,%edx
  800d6f:	74 17                	je     800d88 <strchr+0x29>
    for (; *str; str++) {
  800d71:	48 83 c7 01          	add    $0x1,%rdi
  800d75:	0f b6 17             	movzbl (%rdi),%edx
  800d78:	84 d2                	test   %dl,%dl
  800d7a:	75 ee                	jne    800d6a <strchr+0xb>
            return (char *)str;
        }
    }
    return NULL;
  800d7c:	b8 00 00 00 00       	mov    $0x0,%eax
  800d81:	c3                   	ret
  800d82:	b8 00 00 00 00       	mov    $0x0,%eax
  800d87:	c3                   	ret
            return (char *)str;
  800d88:	48 89 f8             	mov    %rdi,%rax
}
  800d8b:	c3                   	ret

0000000000800d8c <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
  800d8c:	f3 0f 1e fa          	endbr64
  800d90:	48 89 f8             	mov    %rdi,%rax
    for (; *str && *str != ch; str++) /* nothing */
  800d93:	0f b6 17             	movzbl (%rdi),%edx
  800d96:	84 d2                	test   %dl,%dl
  800d98:	74 13                	je     800dad <strfind+0x21>
  800d9a:	0f be d2             	movsbl %dl,%edx
  800d9d:	39 f2                	cmp    %esi,%edx
  800d9f:	74 0b                	je     800dac <strfind+0x20>
  800da1:	48 83 c0 01          	add    $0x1,%rax
  800da5:	0f b6 10             	movzbl (%rax),%edx
  800da8:	84 d2                	test   %dl,%dl
  800daa:	75 ee                	jne    800d9a <strfind+0xe>
        ;
    return (char *)str;
}
  800dac:	c3                   	ret
  800dad:	c3                   	ret

0000000000800dae <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  800dae:	f3 0f 1e fa          	endbr64
  800db2:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  800db5:	48 89 f8             	mov    %rdi,%rax
  800db8:	48 f7 d8             	neg    %rax
  800dbb:	83 e0 07             	and    $0x7,%eax
  800dbe:	49 89 d1             	mov    %rdx,%r9
  800dc1:	49 29 c1             	sub    %rax,%r9
  800dc4:	78 36                	js     800dfc <memset+0x4e>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  800dc6:	40 0f b6 c6          	movzbl %sil,%eax
  800dca:	48 b9 01 01 01 01 01 	movabs $0x101010101010101,%rcx
  800dd1:	01 01 01 
  800dd4:	48 0f af c1          	imul   %rcx,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  800dd8:	40 f6 c7 07          	test   $0x7,%dil
  800ddc:	75 38                	jne    800e16 <memset+0x68>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  800dde:	4c 89 c9             	mov    %r9,%rcx
  800de1:	48 c1 f9 03          	sar    $0x3,%rcx
  800de5:	74 0c                	je     800df3 <memset+0x45>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  800de7:	fc                   	cld
  800de8:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  800deb:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  800def:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  800df3:	4d 85 c9             	test   %r9,%r9
  800df6:	75 45                	jne    800e3d <memset+0x8f>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  800df8:	4c 89 c0             	mov    %r8,%rax
  800dfb:	c3                   	ret
        while (n-- > 0) *ptr++ = c;
  800dfc:	48 85 d2             	test   %rdx,%rdx
  800dff:	74 f7                	je     800df8 <memset+0x4a>
  800e01:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  800e04:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  800e07:	48 83 c0 01          	add    $0x1,%rax
  800e0b:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  800e0f:	48 39 c2             	cmp    %rax,%rdx
  800e12:	75 f3                	jne    800e07 <memset+0x59>
  800e14:	eb e2                	jmp    800df8 <memset+0x4a>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  800e16:	40 f6 c7 01          	test   $0x1,%dil
  800e1a:	74 06                	je     800e22 <memset+0x74>
  800e1c:	88 07                	mov    %al,(%rdi)
  800e1e:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  800e22:	40 f6 c7 02          	test   $0x2,%dil
  800e26:	74 07                	je     800e2f <memset+0x81>
  800e28:	66 89 07             	mov    %ax,(%rdi)
  800e2b:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  800e2f:	40 f6 c7 04          	test   $0x4,%dil
  800e33:	74 a9                	je     800dde <memset+0x30>
  800e35:	89 07                	mov    %eax,(%rdi)
  800e37:	48 83 c7 04          	add    $0x4,%rdi
  800e3b:	eb a1                	jmp    800dde <memset+0x30>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  800e3d:	41 f6 c1 04          	test   $0x4,%r9b
  800e41:	74 1b                	je     800e5e <memset+0xb0>
  800e43:	89 07                	mov    %eax,(%rdi)
  800e45:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800e49:	41 f6 c1 02          	test   $0x2,%r9b
  800e4d:	74 07                	je     800e56 <memset+0xa8>
  800e4f:	66 89 07             	mov    %ax,(%rdi)
  800e52:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  800e56:	41 f6 c1 01          	test   $0x1,%r9b
  800e5a:	74 9c                	je     800df8 <memset+0x4a>
  800e5c:	eb 06                	jmp    800e64 <memset+0xb6>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800e5e:	41 f6 c1 02          	test   $0x2,%r9b
  800e62:	75 eb                	jne    800e4f <memset+0xa1>
        if (ni & 1) *ptr = k;
  800e64:	88 07                	mov    %al,(%rdi)
  800e66:	eb 90                	jmp    800df8 <memset+0x4a>

0000000000800e68 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  800e68:	f3 0f 1e fa          	endbr64
  800e6c:	48 89 f8             	mov    %rdi,%rax
  800e6f:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  800e72:	48 39 fe             	cmp    %rdi,%rsi
  800e75:	73 3b                	jae    800eb2 <memmove+0x4a>
  800e77:	48 8d 14 16          	lea    (%rsi,%rdx,1),%rdx
  800e7b:	48 39 d7             	cmp    %rdx,%rdi
  800e7e:	73 32                	jae    800eb2 <memmove+0x4a>
        s += n;
        d += n;
  800e80:	48 8d 3c 0f          	lea    (%rdi,%rcx,1),%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800e84:	48 89 d6             	mov    %rdx,%rsi
  800e87:	48 09 fe             	or     %rdi,%rsi
  800e8a:	48 09 ce             	or     %rcx,%rsi
  800e8d:	40 f6 c6 07          	test   $0x7,%sil
  800e91:	75 12                	jne    800ea5 <memmove+0x3d>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  800e93:	48 83 ef 08          	sub    $0x8,%rdi
  800e97:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  800e9b:	48 c1 e9 03          	shr    $0x3,%rcx
  800e9f:	fd                   	std
  800ea0:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  800ea3:	fc                   	cld
  800ea4:	c3                   	ret
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  800ea5:	48 83 ef 01          	sub    $0x1,%rdi
  800ea9:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  800ead:	fd                   	std
  800eae:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  800eb0:	eb f1                	jmp    800ea3 <memmove+0x3b>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800eb2:	48 89 f2             	mov    %rsi,%rdx
  800eb5:	48 09 c2             	or     %rax,%rdx
  800eb8:	48 09 ca             	or     %rcx,%rdx
  800ebb:	f6 c2 07             	test   $0x7,%dl
  800ebe:	75 0c                	jne    800ecc <memmove+0x64>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  800ec0:	48 c1 e9 03          	shr    $0x3,%rcx
  800ec4:	48 89 c7             	mov    %rax,%rdi
  800ec7:	fc                   	cld
  800ec8:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  800ecb:	c3                   	ret
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  800ecc:	48 89 c7             	mov    %rax,%rdi
  800ecf:	fc                   	cld
  800ed0:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  800ed2:	c3                   	ret

0000000000800ed3 <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  800ed3:	f3 0f 1e fa          	endbr64
  800ed7:	55                   	push   %rbp
  800ed8:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  800edb:	48 b8 68 0e 80 00 00 	movabs $0x800e68,%rax
  800ee2:	00 00 00 
  800ee5:	ff d0                	call   *%rax
}
  800ee7:	5d                   	pop    %rbp
  800ee8:	c3                   	ret

0000000000800ee9 <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  800ee9:	f3 0f 1e fa          	endbr64
  800eed:	55                   	push   %rbp
  800eee:	48 89 e5             	mov    %rsp,%rbp
  800ef1:	41 57                	push   %r15
  800ef3:	41 56                	push   %r14
  800ef5:	41 55                	push   %r13
  800ef7:	41 54                	push   %r12
  800ef9:	53                   	push   %rbx
  800efa:	48 83 ec 08          	sub    $0x8,%rsp
  800efe:	49 89 fe             	mov    %rdi,%r14
  800f01:	49 89 f7             	mov    %rsi,%r15
  800f04:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  800f07:	48 89 f7             	mov    %rsi,%rdi
  800f0a:	48 b8 08 0c 80 00 00 	movabs $0x800c08,%rax
  800f11:	00 00 00 
  800f14:	ff d0                	call   *%rax
  800f16:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  800f19:	48 89 de             	mov    %rbx,%rsi
  800f1c:	4c 89 f7             	mov    %r14,%rdi
  800f1f:	48 b8 27 0c 80 00 00 	movabs $0x800c27,%rax
  800f26:	00 00 00 
  800f29:	ff d0                	call   *%rax
  800f2b:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  800f2e:	48 39 c3             	cmp    %rax,%rbx
  800f31:	74 36                	je     800f69 <strlcat+0x80>
    if (srclen < maxlen - dstlen) {
  800f33:	48 89 d8             	mov    %rbx,%rax
  800f36:	4c 29 e8             	sub    %r13,%rax
  800f39:	49 39 c4             	cmp    %rax,%r12
  800f3c:	73 31                	jae    800f6f <strlcat+0x86>
        memcpy(dst + dstlen, src, srclen + 1);
  800f3e:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  800f43:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800f47:	4c 89 fe             	mov    %r15,%rsi
  800f4a:	48 b8 d3 0e 80 00 00 	movabs $0x800ed3,%rax
  800f51:	00 00 00 
  800f54:	ff d0                	call   *%rax
    return dstlen + srclen;
  800f56:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  800f5a:	48 83 c4 08          	add    $0x8,%rsp
  800f5e:	5b                   	pop    %rbx
  800f5f:	41 5c                	pop    %r12
  800f61:	41 5d                	pop    %r13
  800f63:	41 5e                	pop    %r14
  800f65:	41 5f                	pop    %r15
  800f67:	5d                   	pop    %rbp
  800f68:	c3                   	ret
    if (dstlen == maxlen) return maxlen + srclen;
  800f69:	49 8d 04 04          	lea    (%r12,%rax,1),%rax
  800f6d:	eb eb                	jmp    800f5a <strlcat+0x71>
        memcpy(dst + dstlen, src, maxlen - 1);
  800f6f:	48 83 eb 01          	sub    $0x1,%rbx
  800f73:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800f77:	48 89 da             	mov    %rbx,%rdx
  800f7a:	4c 89 fe             	mov    %r15,%rsi
  800f7d:	48 b8 d3 0e 80 00 00 	movabs $0x800ed3,%rax
  800f84:	00 00 00 
  800f87:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  800f89:	49 01 de             	add    %rbx,%r14
  800f8c:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  800f91:	eb c3                	jmp    800f56 <strlcat+0x6d>

0000000000800f93 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  800f93:	f3 0f 1e fa          	endbr64
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  800f97:	48 85 d2             	test   %rdx,%rdx
  800f9a:	74 2d                	je     800fc9 <memcmp+0x36>
  800f9c:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  800fa1:	0f b6 0c 07          	movzbl (%rdi,%rax,1),%ecx
  800fa5:	44 0f b6 04 06       	movzbl (%rsi,%rax,1),%r8d
  800faa:	44 38 c1             	cmp    %r8b,%cl
  800fad:	75 0f                	jne    800fbe <memcmp+0x2b>
    while (n-- > 0) {
  800faf:	48 83 c0 01          	add    $0x1,%rax
  800fb3:	48 39 c2             	cmp    %rax,%rdx
  800fb6:	75 e9                	jne    800fa1 <memcmp+0xe>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  800fb8:	b8 00 00 00 00       	mov    $0x0,%eax
  800fbd:	c3                   	ret
            return (int)*s1 - (int)*s2;
  800fbe:	0f b6 c1             	movzbl %cl,%eax
  800fc1:	45 0f b6 c0          	movzbl %r8b,%r8d
  800fc5:	44 29 c0             	sub    %r8d,%eax
  800fc8:	c3                   	ret
    return 0;
  800fc9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fce:	c3                   	ret

0000000000800fcf <memfind>:

void *
memfind(const void *src, int c, size_t n) {
  800fcf:	f3 0f 1e fa          	endbr64
    const void *end = (const char *)src + n;
  800fd3:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  800fd7:	48 39 c7             	cmp    %rax,%rdi
  800fda:	73 0f                	jae    800feb <memfind+0x1c>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  800fdc:	40 38 37             	cmp    %sil,(%rdi)
  800fdf:	74 0e                	je     800fef <memfind+0x20>
    for (; src < end; src++) {
  800fe1:	48 83 c7 01          	add    $0x1,%rdi
  800fe5:	48 39 f8             	cmp    %rdi,%rax
  800fe8:	75 f2                	jne    800fdc <memfind+0xd>
  800fea:	c3                   	ret
  800feb:	48 89 f8             	mov    %rdi,%rax
  800fee:	c3                   	ret
  800fef:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  800ff2:	c3                   	ret

0000000000800ff3 <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  800ff3:	f3 0f 1e fa          	endbr64
  800ff7:	49 89 f2             	mov    %rsi,%r10
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  800ffa:	0f b6 37             	movzbl (%rdi),%esi
  800ffd:	40 80 fe 20          	cmp    $0x20,%sil
  801001:	74 06                	je     801009 <strtol+0x16>
  801003:	40 80 fe 09          	cmp    $0x9,%sil
  801007:	75 13                	jne    80101c <strtol+0x29>
  801009:	48 83 c7 01          	add    $0x1,%rdi
  80100d:	0f b6 37             	movzbl (%rdi),%esi
  801010:	40 80 fe 20          	cmp    $0x20,%sil
  801014:	74 f3                	je     801009 <strtol+0x16>
  801016:	40 80 fe 09          	cmp    $0x9,%sil
  80101a:	74 ed                	je     801009 <strtol+0x16>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  80101c:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  80101f:	83 e0 fd             	and    $0xfffffffd,%eax
  801022:	3c 01                	cmp    $0x1,%al
  801024:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  801028:	f7 c2 ef ff ff ff    	test   $0xffffffef,%edx
  80102e:	75 0f                	jne    80103f <strtol+0x4c>
  801030:	80 3f 30             	cmpb   $0x30,(%rdi)
  801033:	74 14                	je     801049 <strtol+0x56>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  801035:	85 d2                	test   %edx,%edx
  801037:	b8 0a 00 00 00       	mov    $0xa,%eax
  80103c:	0f 44 d0             	cmove  %eax,%edx
    }

    /* Digits */
    long val = 0;
  80103f:	b8 00 00 00 00       	mov    $0x0,%eax
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  801044:	4c 63 ca             	movslq %edx,%r9
  801047:	eb 36                	jmp    80107f <strtol+0x8c>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  801049:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  80104d:	74 0f                	je     80105e <strtol+0x6b>
    } else if (!base && s[0] == '0') {
  80104f:	85 d2                	test   %edx,%edx
  801051:	75 ec                	jne    80103f <strtol+0x4c>
        s++;
  801053:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  801057:	ba 08 00 00 00       	mov    $0x8,%edx
        s++;
  80105c:	eb e1                	jmp    80103f <strtol+0x4c>
        s += 2;
  80105e:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  801062:	ba 10 00 00 00       	mov    $0x10,%edx
        s += 2;
  801067:	eb d6                	jmp    80103f <strtol+0x4c>
            dig -= '0';
  801069:	83 e9 30             	sub    $0x30,%ecx
        if (dig >= base) break;
  80106c:	44 0f b6 c1          	movzbl %cl,%r8d
  801070:	41 39 d0             	cmp    %edx,%r8d
  801073:	7d 21                	jge    801096 <strtol+0xa3>
        val = val * base + dig;
  801075:	49 0f af c1          	imul   %r9,%rax
  801079:	0f b6 c9             	movzbl %cl,%ecx
  80107c:	48 01 c8             	add    %rcx,%rax
        uint8_t dig = *s++;
  80107f:	48 83 c7 01          	add    $0x1,%rdi
  801083:	0f b6 4f ff          	movzbl -0x1(%rdi),%ecx
        if (dig - '0' < 10)
  801087:	80 f9 39             	cmp    $0x39,%cl
  80108a:	76 dd                	jbe    801069 <strtol+0x76>
        else if (dig - 'a' < 27)
  80108c:	80 f9 7b             	cmp    $0x7b,%cl
  80108f:	77 05                	ja     801096 <strtol+0xa3>
            dig -= 'a' - 10;
  801091:	83 e9 57             	sub    $0x57,%ecx
  801094:	eb d6                	jmp    80106c <strtol+0x79>
    }

    if (endptr) *endptr = (char *)s;
  801096:	4d 85 d2             	test   %r10,%r10
  801099:	74 03                	je     80109e <strtol+0xab>
  80109b:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  80109e:	48 89 c2             	mov    %rax,%rdx
  8010a1:	48 f7 da             	neg    %rdx
  8010a4:	40 80 fe 2d          	cmp    $0x2d,%sil
  8010a8:	48 0f 44 c2          	cmove  %rdx,%rax
}
  8010ac:	c3                   	ret

00000000008010ad <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  8010ad:	f3 0f 1e fa          	endbr64
  8010b1:	55                   	push   %rbp
  8010b2:	48 89 e5             	mov    %rsp,%rbp
  8010b5:	53                   	push   %rbx
  8010b6:	48 89 fa             	mov    %rdi,%rdx
  8010b9:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8010bc:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8010c1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010c6:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8010cb:	be 00 00 00 00       	mov    $0x0,%esi
  8010d0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8010d6:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  8010d8:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8010dc:	c9                   	leave
  8010dd:	c3                   	ret

00000000008010de <sys_cgetc>:

int
sys_cgetc(void) {
  8010de:	f3 0f 1e fa          	endbr64
  8010e2:	55                   	push   %rbp
  8010e3:	48 89 e5             	mov    %rsp,%rbp
  8010e6:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8010e7:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8010ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8010f1:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8010f6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010fb:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801100:	be 00 00 00 00       	mov    $0x0,%esi
  801105:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80110b:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  80110d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801111:	c9                   	leave
  801112:	c3                   	ret

0000000000801113 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  801113:	f3 0f 1e fa          	endbr64
  801117:	55                   	push   %rbp
  801118:	48 89 e5             	mov    %rsp,%rbp
  80111b:	53                   	push   %rbx
  80111c:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  801120:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801123:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801128:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80112d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801132:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801137:	be 00 00 00 00       	mov    $0x0,%esi
  80113c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801142:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801144:	48 85 c0             	test   %rax,%rax
  801147:	7f 06                	jg     80114f <sys_env_destroy+0x3c>
}
  801149:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80114d:	c9                   	leave
  80114e:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80114f:	49 89 c0             	mov    %rax,%r8
  801152:	b9 03 00 00 00       	mov    $0x3,%ecx
  801157:	48 ba b0 42 80 00 00 	movabs $0x8042b0,%rdx
  80115e:	00 00 00 
  801161:	be 26 00 00 00       	mov    $0x26,%esi
  801166:	48 bf ab 41 80 00 00 	movabs $0x8041ab,%rdi
  80116d:	00 00 00 
  801170:	b8 00 00 00 00       	mov    $0x0,%eax
  801175:	49 b9 bf 2e 80 00 00 	movabs $0x802ebf,%r9
  80117c:	00 00 00 
  80117f:	41 ff d1             	call   *%r9

0000000000801182 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  801182:	f3 0f 1e fa          	endbr64
  801186:	55                   	push   %rbp
  801187:	48 89 e5             	mov    %rsp,%rbp
  80118a:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80118b:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801190:	ba 00 00 00 00       	mov    $0x0,%edx
  801195:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80119a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80119f:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8011a4:	be 00 00 00 00       	mov    $0x0,%esi
  8011a9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8011af:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  8011b1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011b5:	c9                   	leave
  8011b6:	c3                   	ret

00000000008011b7 <sys_yield>:

void
sys_yield(void) {
  8011b7:	f3 0f 1e fa          	endbr64
  8011bb:	55                   	push   %rbp
  8011bc:	48 89 e5             	mov    %rsp,%rbp
  8011bf:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8011c0:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8011c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8011ca:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8011cf:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011d4:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8011d9:	be 00 00 00 00       	mov    $0x0,%esi
  8011de:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8011e4:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  8011e6:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011ea:	c9                   	leave
  8011eb:	c3                   	ret

00000000008011ec <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  8011ec:	f3 0f 1e fa          	endbr64
  8011f0:	55                   	push   %rbp
  8011f1:	48 89 e5             	mov    %rsp,%rbp
  8011f4:	53                   	push   %rbx
  8011f5:	48 89 fa             	mov    %rdi,%rdx
  8011f8:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8011fb:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801200:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  801207:	00 00 00 
  80120a:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80120f:	be 00 00 00 00       	mov    $0x0,%esi
  801214:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80121a:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  80121c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801220:	c9                   	leave
  801221:	c3                   	ret

0000000000801222 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  801222:	f3 0f 1e fa          	endbr64
  801226:	55                   	push   %rbp
  801227:	48 89 e5             	mov    %rsp,%rbp
  80122a:	53                   	push   %rbx
  80122b:	49 89 f8             	mov    %rdi,%r8
  80122e:	48 89 d3             	mov    %rdx,%rbx
  801231:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  801234:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801239:	4c 89 c2             	mov    %r8,%rdx
  80123c:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80123f:	be 00 00 00 00       	mov    $0x0,%esi
  801244:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80124a:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  80124c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801250:	c9                   	leave
  801251:	c3                   	ret

0000000000801252 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  801252:	f3 0f 1e fa          	endbr64
  801256:	55                   	push   %rbp
  801257:	48 89 e5             	mov    %rsp,%rbp
  80125a:	53                   	push   %rbx
  80125b:	48 83 ec 08          	sub    $0x8,%rsp
  80125f:	89 f8                	mov    %edi,%eax
  801261:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  801264:	48 63 f9             	movslq %ecx,%rdi
  801267:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80126a:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80126f:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801272:	be 00 00 00 00       	mov    $0x0,%esi
  801277:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80127d:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80127f:	48 85 c0             	test   %rax,%rax
  801282:	7f 06                	jg     80128a <sys_alloc_region+0x38>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  801284:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801288:	c9                   	leave
  801289:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80128a:	49 89 c0             	mov    %rax,%r8
  80128d:	b9 04 00 00 00       	mov    $0x4,%ecx
  801292:	48 ba b0 42 80 00 00 	movabs $0x8042b0,%rdx
  801299:	00 00 00 
  80129c:	be 26 00 00 00       	mov    $0x26,%esi
  8012a1:	48 bf ab 41 80 00 00 	movabs $0x8041ab,%rdi
  8012a8:	00 00 00 
  8012ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8012b0:	49 b9 bf 2e 80 00 00 	movabs $0x802ebf,%r9
  8012b7:	00 00 00 
  8012ba:	41 ff d1             	call   *%r9

00000000008012bd <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  8012bd:	f3 0f 1e fa          	endbr64
  8012c1:	55                   	push   %rbp
  8012c2:	48 89 e5             	mov    %rsp,%rbp
  8012c5:	53                   	push   %rbx
  8012c6:	48 83 ec 08          	sub    $0x8,%rsp
  8012ca:	89 f8                	mov    %edi,%eax
  8012cc:	49 89 f2             	mov    %rsi,%r10
  8012cf:	48 89 cf             	mov    %rcx,%rdi
  8012d2:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  8012d5:	48 63 da             	movslq %edx,%rbx
  8012d8:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8012db:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8012e0:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012e3:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  8012e6:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8012e8:	48 85 c0             	test   %rax,%rax
  8012eb:	7f 06                	jg     8012f3 <sys_map_region+0x36>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  8012ed:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012f1:	c9                   	leave
  8012f2:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8012f3:	49 89 c0             	mov    %rax,%r8
  8012f6:	b9 05 00 00 00       	mov    $0x5,%ecx
  8012fb:	48 ba b0 42 80 00 00 	movabs $0x8042b0,%rdx
  801302:	00 00 00 
  801305:	be 26 00 00 00       	mov    $0x26,%esi
  80130a:	48 bf ab 41 80 00 00 	movabs $0x8041ab,%rdi
  801311:	00 00 00 
  801314:	b8 00 00 00 00       	mov    $0x0,%eax
  801319:	49 b9 bf 2e 80 00 00 	movabs $0x802ebf,%r9
  801320:	00 00 00 
  801323:	41 ff d1             	call   *%r9

0000000000801326 <sys_map_physical_region>:

int
sys_map_physical_region(uintptr_t pa, envid_t dstenv, void *dstva, size_t size, int perm) {
  801326:	f3 0f 1e fa          	endbr64
  80132a:	55                   	push   %rbp
  80132b:	48 89 e5             	mov    %rsp,%rbp
  80132e:	53                   	push   %rbx
  80132f:	48 83 ec 08          	sub    $0x8,%rsp
  801333:	49 89 f9             	mov    %rdi,%r9
  801336:	89 f0                	mov    %esi,%eax
  801338:	48 89 d3             	mov    %rdx,%rbx
  80133b:	48 89 cf             	mov    %rcx,%rdi
    int res = syscall(SYS_map_physical_region, 1, pa, dstenv, (uintptr_t)dstva, size, perm, 0);
  80133e:	49 63 f0             	movslq %r8d,%rsi
  801341:	48 63 c8             	movslq %eax,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801344:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801349:	4c 89 ca             	mov    %r9,%rdx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80134c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801352:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801354:	48 85 c0             	test   %rax,%rax
  801357:	7f 06                	jg     80135f <sys_map_physical_region+0x39>
#ifdef SANITIZE_USER_SHADOW_BASE
    platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  801359:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80135d:	c9                   	leave
  80135e:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80135f:	49 89 c0             	mov    %rax,%r8
  801362:	b9 06 00 00 00       	mov    $0x6,%ecx
  801367:	48 ba b0 42 80 00 00 	movabs $0x8042b0,%rdx
  80136e:	00 00 00 
  801371:	be 26 00 00 00       	mov    $0x26,%esi
  801376:	48 bf ab 41 80 00 00 	movabs $0x8041ab,%rdi
  80137d:	00 00 00 
  801380:	b8 00 00 00 00       	mov    $0x0,%eax
  801385:	49 b9 bf 2e 80 00 00 	movabs $0x802ebf,%r9
  80138c:	00 00 00 
  80138f:	41 ff d1             	call   *%r9

0000000000801392 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  801392:	f3 0f 1e fa          	endbr64
  801396:	55                   	push   %rbp
  801397:	48 89 e5             	mov    %rsp,%rbp
  80139a:	53                   	push   %rbx
  80139b:	48 83 ec 08          	sub    $0x8,%rsp
  80139f:	48 89 f1             	mov    %rsi,%rcx
  8013a2:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  8013a5:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8013a8:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8013ad:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013b2:	be 00 00 00 00       	mov    $0x0,%esi
  8013b7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013bd:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8013bf:	48 85 c0             	test   %rax,%rax
  8013c2:	7f 06                	jg     8013ca <sys_unmap_region+0x38>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  8013c4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013c8:	c9                   	leave
  8013c9:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8013ca:	49 89 c0             	mov    %rax,%r8
  8013cd:	b9 07 00 00 00       	mov    $0x7,%ecx
  8013d2:	48 ba b0 42 80 00 00 	movabs $0x8042b0,%rdx
  8013d9:	00 00 00 
  8013dc:	be 26 00 00 00       	mov    $0x26,%esi
  8013e1:	48 bf ab 41 80 00 00 	movabs $0x8041ab,%rdi
  8013e8:	00 00 00 
  8013eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8013f0:	49 b9 bf 2e 80 00 00 	movabs $0x802ebf,%r9
  8013f7:	00 00 00 
  8013fa:	41 ff d1             	call   *%r9

00000000008013fd <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  8013fd:	f3 0f 1e fa          	endbr64
  801401:	55                   	push   %rbp
  801402:	48 89 e5             	mov    %rsp,%rbp
  801405:	53                   	push   %rbx
  801406:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  80140a:	48 63 ce             	movslq %esi,%rcx
  80140d:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801410:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801415:	bb 00 00 00 00       	mov    $0x0,%ebx
  80141a:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80141f:	be 00 00 00 00       	mov    $0x0,%esi
  801424:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80142a:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80142c:	48 85 c0             	test   %rax,%rax
  80142f:	7f 06                	jg     801437 <sys_env_set_status+0x3a>
}
  801431:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801435:	c9                   	leave
  801436:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801437:	49 89 c0             	mov    %rax,%r8
  80143a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80143f:	48 ba b0 42 80 00 00 	movabs $0x8042b0,%rdx
  801446:	00 00 00 
  801449:	be 26 00 00 00       	mov    $0x26,%esi
  80144e:	48 bf ab 41 80 00 00 	movabs $0x8041ab,%rdi
  801455:	00 00 00 
  801458:	b8 00 00 00 00       	mov    $0x0,%eax
  80145d:	49 b9 bf 2e 80 00 00 	movabs $0x802ebf,%r9
  801464:	00 00 00 
  801467:	41 ff d1             	call   *%r9

000000000080146a <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  80146a:	f3 0f 1e fa          	endbr64
  80146e:	55                   	push   %rbp
  80146f:	48 89 e5             	mov    %rsp,%rbp
  801472:	53                   	push   %rbx
  801473:	48 83 ec 08          	sub    $0x8,%rsp
  801477:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  80147a:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80147d:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801482:	bb 00 00 00 00       	mov    $0x0,%ebx
  801487:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80148c:	be 00 00 00 00       	mov    $0x0,%esi
  801491:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801497:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801499:	48 85 c0             	test   %rax,%rax
  80149c:	7f 06                	jg     8014a4 <sys_env_set_trapframe+0x3a>
}
  80149e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014a2:	c9                   	leave
  8014a3:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8014a4:	49 89 c0             	mov    %rax,%r8
  8014a7:	b9 0b 00 00 00       	mov    $0xb,%ecx
  8014ac:	48 ba b0 42 80 00 00 	movabs $0x8042b0,%rdx
  8014b3:	00 00 00 
  8014b6:	be 26 00 00 00       	mov    $0x26,%esi
  8014bb:	48 bf ab 41 80 00 00 	movabs $0x8041ab,%rdi
  8014c2:	00 00 00 
  8014c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ca:	49 b9 bf 2e 80 00 00 	movabs $0x802ebf,%r9
  8014d1:	00 00 00 
  8014d4:	41 ff d1             	call   *%r9

00000000008014d7 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  8014d7:	f3 0f 1e fa          	endbr64
  8014db:	55                   	push   %rbp
  8014dc:	48 89 e5             	mov    %rsp,%rbp
  8014df:	53                   	push   %rbx
  8014e0:	48 83 ec 08          	sub    $0x8,%rsp
  8014e4:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  8014e7:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8014ea:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8014ef:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014f4:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8014f9:	be 00 00 00 00       	mov    $0x0,%esi
  8014fe:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801504:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801506:	48 85 c0             	test   %rax,%rax
  801509:	7f 06                	jg     801511 <sys_env_set_pgfault_upcall+0x3a>
}
  80150b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80150f:	c9                   	leave
  801510:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801511:	49 89 c0             	mov    %rax,%r8
  801514:	b9 0c 00 00 00       	mov    $0xc,%ecx
  801519:	48 ba b0 42 80 00 00 	movabs $0x8042b0,%rdx
  801520:	00 00 00 
  801523:	be 26 00 00 00       	mov    $0x26,%esi
  801528:	48 bf ab 41 80 00 00 	movabs $0x8041ab,%rdi
  80152f:	00 00 00 
  801532:	b8 00 00 00 00       	mov    $0x0,%eax
  801537:	49 b9 bf 2e 80 00 00 	movabs $0x802ebf,%r9
  80153e:	00 00 00 
  801541:	41 ff d1             	call   *%r9

0000000000801544 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  801544:	f3 0f 1e fa          	endbr64
  801548:	55                   	push   %rbp
  801549:	48 89 e5             	mov    %rsp,%rbp
  80154c:	53                   	push   %rbx
  80154d:	89 f8                	mov    %edi,%eax
  80154f:	49 89 f1             	mov    %rsi,%r9
  801552:	48 89 d3             	mov    %rdx,%rbx
  801555:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  801558:	49 63 f0             	movslq %r8d,%rsi
  80155b:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80155e:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801563:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801566:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80156c:	cd 30                	int    $0x30
}
  80156e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801572:	c9                   	leave
  801573:	c3                   	ret

0000000000801574 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  801574:	f3 0f 1e fa          	endbr64
  801578:	55                   	push   %rbp
  801579:	48 89 e5             	mov    %rsp,%rbp
  80157c:	53                   	push   %rbx
  80157d:	48 83 ec 08          	sub    $0x8,%rsp
  801581:	48 89 fa             	mov    %rdi,%rdx
  801584:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801587:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80158c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801591:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801596:	be 00 00 00 00       	mov    $0x0,%esi
  80159b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8015a1:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8015a3:	48 85 c0             	test   %rax,%rax
  8015a6:	7f 06                	jg     8015ae <sys_ipc_recv+0x3a>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  8015a8:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8015ac:	c9                   	leave
  8015ad:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8015ae:	49 89 c0             	mov    %rax,%r8
  8015b1:	b9 0f 00 00 00       	mov    $0xf,%ecx
  8015b6:	48 ba b0 42 80 00 00 	movabs $0x8042b0,%rdx
  8015bd:	00 00 00 
  8015c0:	be 26 00 00 00       	mov    $0x26,%esi
  8015c5:	48 bf ab 41 80 00 00 	movabs $0x8041ab,%rdi
  8015cc:	00 00 00 
  8015cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8015d4:	49 b9 bf 2e 80 00 00 	movabs $0x802ebf,%r9
  8015db:	00 00 00 
  8015de:	41 ff d1             	call   *%r9

00000000008015e1 <sys_gettime>:

int
sys_gettime(void) {
  8015e1:	f3 0f 1e fa          	endbr64
  8015e5:	55                   	push   %rbp
  8015e6:	48 89 e5             	mov    %rsp,%rbp
  8015e9:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8015ea:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8015ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8015f4:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8015f9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015fe:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801603:	be 00 00 00 00       	mov    $0x0,%esi
  801608:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80160e:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  801610:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801614:	c9                   	leave
  801615:	c3                   	ret

0000000000801616 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args) {
  801616:	f3 0f 1e fa          	endbr64
    args->argc = argc;
  80161a:	48 89 3a             	mov    %rdi,(%rdx)
    args->argv = (const char **)argv;
  80161d:	48 89 72 08          	mov    %rsi,0x8(%rdx)
    args->curarg = (*argc > 1 && argv ? "" : NULL);
  801621:	83 3f 01             	cmpl   $0x1,(%rdi)
  801624:	7e 0f                	jle    801635 <argstart+0x1f>
  801626:	48 b8 11 40 80 00 00 	movabs $0x804011,%rax
  80162d:	00 00 00 
  801630:	48 85 f6             	test   %rsi,%rsi
  801633:	75 05                	jne    80163a <argstart+0x24>
  801635:	b8 00 00 00 00       	mov    $0x0,%eax
  80163a:	48 89 42 10          	mov    %rax,0x10(%rdx)
    args->argvalue = 0;
  80163e:	48 c7 42 18 00 00 00 	movq   $0x0,0x18(%rdx)
  801645:	00 
}
  801646:	c3                   	ret

0000000000801647 <argnext>:

int
argnext(struct Argstate *args) {
  801647:	f3 0f 1e fa          	endbr64
    int arg;

    args->argvalue = 0;
  80164b:	48 c7 47 18 00 00 00 	movq   $0x0,0x18(%rdi)
  801652:	00 

    /* Done processing arguments if args->curarg == 0 */
    if (args->curarg == 0) return -1;
  801653:	48 8b 47 10          	mov    0x10(%rdi),%rax
  801657:	48 85 c0             	test   %rax,%rax
  80165a:	0f 84 8f 00 00 00    	je     8016ef <argnext+0xa8>
argnext(struct Argstate *args) {
  801660:	55                   	push   %rbp
  801661:	48 89 e5             	mov    %rsp,%rbp
  801664:	53                   	push   %rbx
  801665:	48 83 ec 08          	sub    $0x8,%rsp
  801669:	48 89 fb             	mov    %rdi,%rbx

    if (!*args->curarg) {
  80166c:	80 38 00             	cmpb   $0x0,(%rax)
  80166f:	75 52                	jne    8016c3 <argnext+0x7c>
        /* Need to process the next argument
         * Check for end of argument list */
        if (*args->argc == 1 ||
  801671:	48 8b 17             	mov    (%rdi),%rdx
  801674:	83 3a 01             	cmpl   $0x1,(%rdx)
  801677:	74 67                	je     8016e0 <argnext+0x99>
            args->argv[1][0] != '-' ||
  801679:	48 8b 7f 08          	mov    0x8(%rdi),%rdi
  80167d:	48 8b 47 08          	mov    0x8(%rdi),%rax
        if (*args->argc == 1 ||
  801681:	80 38 2d             	cmpb   $0x2d,(%rax)
  801684:	75 5a                	jne    8016e0 <argnext+0x99>
            args->argv[1][0] != '-' ||
  801686:	80 78 01 00          	cmpb   $0x0,0x1(%rax)
  80168a:	74 54                	je     8016e0 <argnext+0x99>
            args->argv[1][1] == '\0') goto endofargs;

        /* Shift arguments down one */
        args->curarg = args->argv[1] + 1;
  80168c:	48 83 c0 01          	add    $0x1,%rax
  801690:	48 89 43 10          	mov    %rax,0x10(%rbx)
        memmove(args->argv + 1, args->argv + 2, sizeof(*args->argv) * (*args->argc - 1));
  801694:	8b 12                	mov    (%rdx),%edx
  801696:	83 ea 01             	sub    $0x1,%edx
  801699:	48 63 d2             	movslq %edx,%rdx
  80169c:	48 c1 e2 03          	shl    $0x3,%rdx
  8016a0:	48 8d 77 10          	lea    0x10(%rdi),%rsi
  8016a4:	48 83 c7 08          	add    $0x8,%rdi
  8016a8:	48 b8 68 0e 80 00 00 	movabs $0x800e68,%rax
  8016af:	00 00 00 
  8016b2:	ff d0                	call   *%rax

        (*args->argc)--;
  8016b4:	48 8b 03             	mov    (%rbx),%rax
  8016b7:	83 28 01             	subl   $0x1,(%rax)

        /* Check for "--": end of argument list */
        if (args->curarg[0] == '-' &&
  8016ba:	48 8b 43 10          	mov    0x10(%rbx),%rax
  8016be:	80 38 2d             	cmpb   $0x2d,(%rax)
  8016c1:	74 17                	je     8016da <argnext+0x93>
            args->curarg[1] == '\0') goto endofargs;
    }

    arg = (unsigned char)*args->curarg;
  8016c3:	48 8b 43 10          	mov    0x10(%rbx),%rax
  8016c7:	0f b6 10             	movzbl (%rax),%edx
    args->curarg++;
  8016ca:	48 83 c0 01          	add    $0x1,%rax
  8016ce:	48 89 43 10          	mov    %rax,0x10(%rbx)
    return arg;

endofargs:
    args->curarg = 0;
    return -1;
}
  8016d2:	89 d0                	mov    %edx,%eax
  8016d4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8016d8:	c9                   	leave
  8016d9:	c3                   	ret
        if (args->curarg[0] == '-' &&
  8016da:	80 78 01 00          	cmpb   $0x0,0x1(%rax)
  8016de:	75 e3                	jne    8016c3 <argnext+0x7c>
    args->curarg = 0;
  8016e0:	48 c7 43 10 00 00 00 	movq   $0x0,0x10(%rbx)
  8016e7:	00 
    return -1;
  8016e8:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  8016ed:	eb e3                	jmp    8016d2 <argnext+0x8b>
    if (args->curarg == 0) return -1;
  8016ef:	ba ff ff ff ff       	mov    $0xffffffff,%edx
}
  8016f4:	89 d0                	mov    %edx,%eax
  8016f6:	c3                   	ret

00000000008016f7 <argnextvalue>:
argvalue(struct Argstate *args) {
    return (char *)(args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args) {
  8016f7:	f3 0f 1e fa          	endbr64
    if (!args->curarg) return 0;
  8016fb:	48 8b 47 10          	mov    0x10(%rdi),%rax
  8016ff:	48 85 c0             	test   %rax,%rax
  801702:	74 7b                	je     80177f <argnextvalue+0x88>
argnextvalue(struct Argstate *args) {
  801704:	55                   	push   %rbp
  801705:	48 89 e5             	mov    %rsp,%rbp
  801708:	53                   	push   %rbx
  801709:	48 83 ec 08          	sub    $0x8,%rsp
  80170d:	48 89 fb             	mov    %rdi,%rbx

    if (*args->curarg) {
  801710:	80 38 00             	cmpb   $0x0,(%rax)
  801713:	74 1c                	je     801731 <argnextvalue+0x3a>
        args->argvalue = args->curarg;
  801715:	48 89 47 18          	mov    %rax,0x18(%rdi)
        args->curarg = "";
  801719:	48 b8 11 40 80 00 00 	movabs $0x804011,%rax
  801720:	00 00 00 
  801723:	48 89 47 10          	mov    %rax,0x10(%rdi)
    } else {
        args->argvalue = 0;
        args->curarg = 0;
    }

    return (char *)args->argvalue;
  801727:	48 8b 43 18          	mov    0x18(%rbx),%rax
}
  80172b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80172f:	c9                   	leave
  801730:	c3                   	ret
    } else if (*args->argc > 1) {
  801731:	48 8b 07             	mov    (%rdi),%rax
  801734:	83 38 01             	cmpl   $0x1,(%rax)
  801737:	7f 12                	jg     80174b <argnextvalue+0x54>
        args->argvalue = 0;
  801739:	48 c7 47 18 00 00 00 	movq   $0x0,0x18(%rdi)
  801740:	00 
        args->curarg = 0;
  801741:	48 c7 47 10 00 00 00 	movq   $0x0,0x10(%rdi)
  801748:	00 
  801749:	eb dc                	jmp    801727 <argnextvalue+0x30>
        args->argvalue = args->argv[1];
  80174b:	48 8b 7f 08          	mov    0x8(%rdi),%rdi
  80174f:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  801753:	48 89 53 18          	mov    %rdx,0x18(%rbx)
        memmove(args->argv + 1, args->argv + 2, sizeof(*args->argv) * (*args->argc - 1));
  801757:	8b 10                	mov    (%rax),%edx
  801759:	83 ea 01             	sub    $0x1,%edx
  80175c:	48 63 d2             	movslq %edx,%rdx
  80175f:	48 c1 e2 03          	shl    $0x3,%rdx
  801763:	48 8d 77 10          	lea    0x10(%rdi),%rsi
  801767:	48 83 c7 08          	add    $0x8,%rdi
  80176b:	48 b8 68 0e 80 00 00 	movabs $0x800e68,%rax
  801772:	00 00 00 
  801775:	ff d0                	call   *%rax
        (*args->argc)--;
  801777:	48 8b 03             	mov    (%rbx),%rax
  80177a:	83 28 01             	subl   $0x1,(%rax)
  80177d:	eb a8                	jmp    801727 <argnextvalue+0x30>
}
  80177f:	c3                   	ret

0000000000801780 <argvalue>:
argvalue(struct Argstate *args) {
  801780:	f3 0f 1e fa          	endbr64
    return (char *)(args->argvalue ? args->argvalue : argnextvalue(args));
  801784:	48 8b 47 18          	mov    0x18(%rdi),%rax
  801788:	48 85 c0             	test   %rax,%rax
  80178b:	74 01                	je     80178e <argvalue+0xe>
}
  80178d:	c3                   	ret
argvalue(struct Argstate *args) {
  80178e:	55                   	push   %rbp
  80178f:	48 89 e5             	mov    %rsp,%rbp
    return (char *)(args->argvalue ? args->argvalue : argnextvalue(args));
  801792:	48 b8 f7 16 80 00 00 	movabs $0x8016f7,%rax
  801799:	00 00 00 
  80179c:	ff d0                	call   *%rax
}
  80179e:	5d                   	pop    %rbp
  80179f:	c3                   	ret

00000000008017a0 <fd2num>:


/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
  8017a0:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8017a4:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8017ab:	ff ff ff 
  8017ae:	48 01 f8             	add    %rdi,%rax
  8017b1:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8017b5:	c3                   	ret

00000000008017b6 <fd2data>:

char *
fd2data(struct Fd *fd) {
  8017b6:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8017ba:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8017c1:	ff ff ff 
  8017c4:	48 01 f8             	add    %rdi,%rax
  8017c7:	48 c1 e8 0c          	shr    $0xc,%rax
    return INDEX2DATA(fd2num(fd));
  8017cb:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8017d1:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8017d5:	c3                   	ret

00000000008017d6 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  8017d6:	f3 0f 1e fa          	endbr64
  8017da:	55                   	push   %rbp
  8017db:	48 89 e5             	mov    %rsp,%rbp
  8017de:	41 57                	push   %r15
  8017e0:	41 56                	push   %r14
  8017e2:	41 55                	push   %r13
  8017e4:	41 54                	push   %r12
  8017e6:	53                   	push   %rbx
  8017e7:	48 83 ec 08          	sub    $0x8,%rsp
  8017eb:	49 89 ff             	mov    %rdi,%r15
  8017ee:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  8017f3:	49 bd ed 2a 80 00 00 	movabs $0x802aed,%r13
  8017fa:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  8017fd:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        struct Fd *fd = INDEX2FD(i);
  801803:	49 89 dc             	mov    %rbx,%r12
        if (!(get_prot(fd) & PROT_R)) {
  801806:	48 89 df             	mov    %rbx,%rdi
  801809:	41 ff d5             	call   *%r13
  80180c:	83 e0 04             	and    $0x4,%eax
  80180f:	74 17                	je     801828 <fd_alloc+0x52>
    for (int i = 0; i < MAXFD; i++) {
  801811:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  801818:	4c 39 f3             	cmp    %r14,%rbx
  80181b:	75 e6                	jne    801803 <fd_alloc+0x2d>
  80181d:	41 bc 00 00 00 00    	mov    $0x0,%r12d
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
    return -E_MAX_OPEN;
  801823:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
            *fd_store = fd;
  801828:	4d 89 27             	mov    %r12,(%r15)
}
  80182b:	48 83 c4 08          	add    $0x8,%rsp
  80182f:	5b                   	pop    %rbx
  801830:	41 5c                	pop    %r12
  801832:	41 5d                	pop    %r13
  801834:	41 5e                	pop    %r14
  801836:	41 5f                	pop    %r15
  801838:	5d                   	pop    %rbp
  801839:	c3                   	ret

000000000080183a <fd_lookup>:
 *
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
  80183a:	f3 0f 1e fa          	endbr64
    if (fdnum < 0 || fdnum >= MAXFD) {
  80183e:	83 ff 1f             	cmp    $0x1f,%edi
  801841:	77 39                	ja     80187c <fd_lookup+0x42>
fd_lookup(int fdnum, struct Fd **fd_store) {
  801843:	55                   	push   %rbp
  801844:	48 89 e5             	mov    %rsp,%rbp
  801847:	41 54                	push   %r12
  801849:	53                   	push   %rbx
  80184a:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  80184d:	48 63 df             	movslq %edi,%rbx
  801850:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  801857:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  80185b:	48 89 df             	mov    %rbx,%rdi
  80185e:	48 b8 ed 2a 80 00 00 	movabs $0x802aed,%rax
  801865:	00 00 00 
  801868:	ff d0                	call   *%rax
  80186a:	a8 04                	test   $0x4,%al
  80186c:	74 14                	je     801882 <fd_lookup+0x48>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  80186e:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  801872:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801877:	5b                   	pop    %rbx
  801878:	41 5c                	pop    %r12
  80187a:	5d                   	pop    %rbp
  80187b:	c3                   	ret
        return -E_INVAL;
  80187c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801881:	c3                   	ret
        return -E_INVAL;
  801882:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801887:	eb ee                	jmp    801877 <fd_lookup+0x3d>

0000000000801889 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  801889:	f3 0f 1e fa          	endbr64
  80188d:	55                   	push   %rbp
  80188e:	48 89 e5             	mov    %rsp,%rbp
  801891:	41 54                	push   %r12
  801893:	53                   	push   %rbx
  801894:	49 89 f4             	mov    %rsi,%r12
    for (size_t i = 0; devtab[i]; i++) {
  801897:	48 b8 e0 46 80 00 00 	movabs $0x8046e0,%rax
  80189e:	00 00 00 
  8018a1:	48 bb 20 50 80 00 00 	movabs $0x805020,%rbx
  8018a8:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  8018ab:	39 3b                	cmp    %edi,(%rbx)
  8018ad:	74 47                	je     8018f6 <dev_lookup+0x6d>
    for (size_t i = 0; devtab[i]; i++) {
  8018af:	48 83 c0 08          	add    $0x8,%rax
  8018b3:	48 8b 18             	mov    (%rax),%rbx
  8018b6:	48 85 db             	test   %rbx,%rbx
  8018b9:	75 f0                	jne    8018ab <dev_lookup+0x22>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8018bb:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  8018c2:	00 00 00 
  8018c5:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  8018cb:	89 fa                	mov    %edi,%edx
  8018cd:	48 bf d0 42 80 00 00 	movabs $0x8042d0,%rdi
  8018d4:	00 00 00 
  8018d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8018dc:	48 b9 04 03 80 00 00 	movabs $0x800304,%rcx
  8018e3:	00 00 00 
  8018e6:	ff d1                	call   *%rcx
    *dev = 0;
    return -E_INVAL;
  8018e8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
            *dev = devtab[i];
  8018ed:	49 89 1c 24          	mov    %rbx,(%r12)
}
  8018f1:	5b                   	pop    %rbx
  8018f2:	41 5c                	pop    %r12
  8018f4:	5d                   	pop    %rbp
  8018f5:	c3                   	ret
            return 0;
  8018f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8018fb:	eb f0                	jmp    8018ed <dev_lookup+0x64>

00000000008018fd <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  8018fd:	f3 0f 1e fa          	endbr64
  801901:	55                   	push   %rbp
  801902:	48 89 e5             	mov    %rsp,%rbp
  801905:	41 55                	push   %r13
  801907:	41 54                	push   %r12
  801909:	53                   	push   %rbx
  80190a:	48 83 ec 18          	sub    $0x18,%rsp
  80190e:	48 89 fb             	mov    %rdi,%rbx
  801911:	41 89 f4             	mov    %esi,%r12d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801914:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  80191b:	ff ff ff 
  80191e:	48 01 df             	add    %rbx,%rdi
  801921:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  801925:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801929:	48 b8 3a 18 80 00 00 	movabs $0x80183a,%rax
  801930:	00 00 00 
  801933:	ff d0                	call   *%rax
  801935:	41 89 c5             	mov    %eax,%r13d
  801938:	85 c0                	test   %eax,%eax
  80193a:	78 06                	js     801942 <fd_close+0x45>
  80193c:	48 39 5d d8          	cmp    %rbx,-0x28(%rbp)
  801940:	74 1a                	je     80195c <fd_close+0x5f>
        return (must_exist ? res : 0);
  801942:	45 84 e4             	test   %r12b,%r12b
  801945:	b8 00 00 00 00       	mov    $0x0,%eax
  80194a:	44 0f 44 e8          	cmove  %eax,%r13d
}
  80194e:	44 89 e8             	mov    %r13d,%eax
  801951:	48 83 c4 18          	add    $0x18,%rsp
  801955:	5b                   	pop    %rbx
  801956:	41 5c                	pop    %r12
  801958:	41 5d                	pop    %r13
  80195a:	5d                   	pop    %rbp
  80195b:	c3                   	ret
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80195c:	8b 3b                	mov    (%rbx),%edi
  80195e:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801962:	48 b8 89 18 80 00 00 	movabs $0x801889,%rax
  801969:	00 00 00 
  80196c:	ff d0                	call   *%rax
  80196e:	41 89 c5             	mov    %eax,%r13d
  801971:	85 c0                	test   %eax,%eax
  801973:	78 1b                	js     801990 <fd_close+0x93>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  801975:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801979:	48 8b 40 20          	mov    0x20(%rax),%rax
  80197d:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  801983:	48 85 c0             	test   %rax,%rax
  801986:	74 08                	je     801990 <fd_close+0x93>
  801988:	48 89 df             	mov    %rbx,%rdi
  80198b:	ff d0                	call   *%rax
  80198d:	41 89 c5             	mov    %eax,%r13d
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801990:	ba 00 10 00 00       	mov    $0x1000,%edx
  801995:	48 89 de             	mov    %rbx,%rsi
  801998:	bf 00 00 00 00       	mov    $0x0,%edi
  80199d:	48 b8 92 13 80 00 00 	movabs $0x801392,%rax
  8019a4:	00 00 00 
  8019a7:	ff d0                	call   *%rax
    return res;
  8019a9:	eb a3                	jmp    80194e <fd_close+0x51>

00000000008019ab <close>:

int
close(int fdnum) {
  8019ab:	f3 0f 1e fa          	endbr64
  8019af:	55                   	push   %rbp
  8019b0:	48 89 e5             	mov    %rsp,%rbp
  8019b3:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  8019b7:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8019bb:	48 b8 3a 18 80 00 00 	movabs $0x80183a,%rax
  8019c2:	00 00 00 
  8019c5:	ff d0                	call   *%rax
    if (res < 0) return res;
  8019c7:	85 c0                	test   %eax,%eax
  8019c9:	78 15                	js     8019e0 <close+0x35>

    return fd_close(fd, 1);
  8019cb:	be 01 00 00 00       	mov    $0x1,%esi
  8019d0:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8019d4:	48 b8 fd 18 80 00 00 	movabs $0x8018fd,%rax
  8019db:	00 00 00 
  8019de:	ff d0                	call   *%rax
}
  8019e0:	c9                   	leave
  8019e1:	c3                   	ret

00000000008019e2 <close_all>:

void
close_all(void) {
  8019e2:	f3 0f 1e fa          	endbr64
  8019e6:	55                   	push   %rbp
  8019e7:	48 89 e5             	mov    %rsp,%rbp
  8019ea:	41 54                	push   %r12
  8019ec:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  8019ed:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019f2:	49 bc ab 19 80 00 00 	movabs $0x8019ab,%r12
  8019f9:	00 00 00 
  8019fc:	89 df                	mov    %ebx,%edi
  8019fe:	41 ff d4             	call   *%r12
  801a01:	83 c3 01             	add    $0x1,%ebx
  801a04:	83 fb 20             	cmp    $0x20,%ebx
  801a07:	75 f3                	jne    8019fc <close_all+0x1a>
}
  801a09:	5b                   	pop    %rbx
  801a0a:	41 5c                	pop    %r12
  801a0c:	5d                   	pop    %rbp
  801a0d:	c3                   	ret

0000000000801a0e <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  801a0e:	f3 0f 1e fa          	endbr64
  801a12:	55                   	push   %rbp
  801a13:	48 89 e5             	mov    %rsp,%rbp
  801a16:	41 57                	push   %r15
  801a18:	41 56                	push   %r14
  801a1a:	41 55                	push   %r13
  801a1c:	41 54                	push   %r12
  801a1e:	53                   	push   %rbx
  801a1f:	48 83 ec 18          	sub    $0x18,%rsp
  801a23:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  801a26:	48 8d 75 c8          	lea    -0x38(%rbp),%rsi
  801a2a:	48 b8 3a 18 80 00 00 	movabs $0x80183a,%rax
  801a31:	00 00 00 
  801a34:	ff d0                	call   *%rax
  801a36:	89 c3                	mov    %eax,%ebx
  801a38:	85 c0                	test   %eax,%eax
  801a3a:	0f 88 b8 00 00 00    	js     801af8 <dup+0xea>
    close(newfdnum);
  801a40:	44 89 e7             	mov    %r12d,%edi
  801a43:	48 b8 ab 19 80 00 00 	movabs $0x8019ab,%rax
  801a4a:	00 00 00 
  801a4d:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  801a4f:	4d 63 ec             	movslq %r12d,%r13
  801a52:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  801a59:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  801a5d:	4c 8b 7d c8          	mov    -0x38(%rbp),%r15
  801a61:	4c 89 ff             	mov    %r15,%rdi
  801a64:	49 be b6 17 80 00 00 	movabs $0x8017b6,%r14
  801a6b:	00 00 00 
  801a6e:	41 ff d6             	call   *%r14
  801a71:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  801a74:	4c 89 ef             	mov    %r13,%rdi
  801a77:	41 ff d6             	call   *%r14
  801a7a:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  801a7d:	48 89 df             	mov    %rbx,%rdi
  801a80:	48 b8 ed 2a 80 00 00 	movabs $0x802aed,%rax
  801a87:	00 00 00 
  801a8a:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  801a8c:	a8 04                	test   $0x4,%al
  801a8e:	74 2b                	je     801abb <dup+0xad>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  801a90:	41 89 c1             	mov    %eax,%r9d
  801a93:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801a99:	4c 89 f1             	mov    %r14,%rcx
  801a9c:	ba 00 00 00 00       	mov    $0x0,%edx
  801aa1:	48 89 de             	mov    %rbx,%rsi
  801aa4:	bf 00 00 00 00       	mov    $0x0,%edi
  801aa9:	48 b8 bd 12 80 00 00 	movabs $0x8012bd,%rax
  801ab0:	00 00 00 
  801ab3:	ff d0                	call   *%rax
  801ab5:	89 c3                	mov    %eax,%ebx
  801ab7:	85 c0                	test   %eax,%eax
  801ab9:	78 4e                	js     801b09 <dup+0xfb>
    }
    prot = get_prot(oldfd);
  801abb:	4c 89 ff             	mov    %r15,%rdi
  801abe:	48 b8 ed 2a 80 00 00 	movabs $0x802aed,%rax
  801ac5:	00 00 00 
  801ac8:	ff d0                	call   *%rax
  801aca:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  801acd:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801ad3:	4c 89 e9             	mov    %r13,%rcx
  801ad6:	ba 00 00 00 00       	mov    $0x0,%edx
  801adb:	4c 89 fe             	mov    %r15,%rsi
  801ade:	bf 00 00 00 00       	mov    $0x0,%edi
  801ae3:	48 b8 bd 12 80 00 00 	movabs $0x8012bd,%rax
  801aea:	00 00 00 
  801aed:	ff d0                	call   *%rax
  801aef:	89 c3                	mov    %eax,%ebx
  801af1:	85 c0                	test   %eax,%eax
  801af3:	78 14                	js     801b09 <dup+0xfb>

    return newfdnum;
  801af5:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  801af8:	89 d8                	mov    %ebx,%eax
  801afa:	48 83 c4 18          	add    $0x18,%rsp
  801afe:	5b                   	pop    %rbx
  801aff:	41 5c                	pop    %r12
  801b01:	41 5d                	pop    %r13
  801b03:	41 5e                	pop    %r14
  801b05:	41 5f                	pop    %r15
  801b07:	5d                   	pop    %rbp
  801b08:	c3                   	ret
    sys_unmap_region(0, newfd, PAGE_SIZE);
  801b09:	ba 00 10 00 00       	mov    $0x1000,%edx
  801b0e:	4c 89 ee             	mov    %r13,%rsi
  801b11:	bf 00 00 00 00       	mov    $0x0,%edi
  801b16:	49 bc 92 13 80 00 00 	movabs $0x801392,%r12
  801b1d:	00 00 00 
  801b20:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  801b23:	ba 00 10 00 00       	mov    $0x1000,%edx
  801b28:	4c 89 f6             	mov    %r14,%rsi
  801b2b:	bf 00 00 00 00       	mov    $0x0,%edi
  801b30:	41 ff d4             	call   *%r12
    return res;
  801b33:	eb c3                	jmp    801af8 <dup+0xea>

0000000000801b35 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  801b35:	f3 0f 1e fa          	endbr64
  801b39:	55                   	push   %rbp
  801b3a:	48 89 e5             	mov    %rsp,%rbp
  801b3d:	41 56                	push   %r14
  801b3f:	41 55                	push   %r13
  801b41:	41 54                	push   %r12
  801b43:	53                   	push   %rbx
  801b44:	48 83 ec 10          	sub    $0x10,%rsp
  801b48:	89 fb                	mov    %edi,%ebx
  801b4a:	49 89 f4             	mov    %rsi,%r12
  801b4d:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801b50:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801b54:	48 b8 3a 18 80 00 00 	movabs $0x80183a,%rax
  801b5b:	00 00 00 
  801b5e:	ff d0                	call   *%rax
  801b60:	85 c0                	test   %eax,%eax
  801b62:	78 4c                	js     801bb0 <read+0x7b>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801b64:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801b68:	41 8b 3e             	mov    (%r14),%edi
  801b6b:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801b6f:	48 b8 89 18 80 00 00 	movabs $0x801889,%rax
  801b76:	00 00 00 
  801b79:	ff d0                	call   *%rax
  801b7b:	85 c0                	test   %eax,%eax
  801b7d:	78 35                	js     801bb4 <read+0x7f>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801b7f:	41 8b 46 08          	mov    0x8(%r14),%eax
  801b83:	83 e0 03             	and    $0x3,%eax
  801b86:	83 f8 01             	cmp    $0x1,%eax
  801b89:	74 2d                	je     801bb8 <read+0x83>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  801b8b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b8f:	48 8b 40 10          	mov    0x10(%rax),%rax
  801b93:	48 85 c0             	test   %rax,%rax
  801b96:	74 56                	je     801bee <read+0xb9>

    return (*dev->dev_read)(fd, buf, n);
  801b98:	4c 89 ea             	mov    %r13,%rdx
  801b9b:	4c 89 e6             	mov    %r12,%rsi
  801b9e:	4c 89 f7             	mov    %r14,%rdi
  801ba1:	ff d0                	call   *%rax
}
  801ba3:	48 83 c4 10          	add    $0x10,%rsp
  801ba7:	5b                   	pop    %rbx
  801ba8:	41 5c                	pop    %r12
  801baa:	41 5d                	pop    %r13
  801bac:	41 5e                	pop    %r14
  801bae:	5d                   	pop    %rbp
  801baf:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801bb0:	48 98                	cltq
  801bb2:	eb ef                	jmp    801ba3 <read+0x6e>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801bb4:	48 98                	cltq
  801bb6:	eb eb                	jmp    801ba3 <read+0x6e>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801bb8:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801bbf:	00 00 00 
  801bc2:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801bc8:	89 da                	mov    %ebx,%edx
  801bca:	48 bf b9 41 80 00 00 	movabs $0x8041b9,%rdi
  801bd1:	00 00 00 
  801bd4:	b8 00 00 00 00       	mov    $0x0,%eax
  801bd9:	48 b9 04 03 80 00 00 	movabs $0x800304,%rcx
  801be0:	00 00 00 
  801be3:	ff d1                	call   *%rcx
        return -E_INVAL;
  801be5:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801bec:	eb b5                	jmp    801ba3 <read+0x6e>
    if (!dev->dev_read) return -E_NOT_SUPP;
  801bee:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801bf5:	eb ac                	jmp    801ba3 <read+0x6e>

0000000000801bf7 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801bf7:	f3 0f 1e fa          	endbr64
  801bfb:	55                   	push   %rbp
  801bfc:	48 89 e5             	mov    %rsp,%rbp
  801bff:	41 57                	push   %r15
  801c01:	41 56                	push   %r14
  801c03:	41 55                	push   %r13
  801c05:	41 54                	push   %r12
  801c07:	53                   	push   %rbx
  801c08:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801c0c:	48 85 d2             	test   %rdx,%rdx
  801c0f:	74 54                	je     801c65 <readn+0x6e>
  801c11:	41 89 fd             	mov    %edi,%r13d
  801c14:	49 89 f6             	mov    %rsi,%r14
  801c17:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801c1a:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801c1f:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801c24:	49 bf 35 1b 80 00 00 	movabs $0x801b35,%r15
  801c2b:	00 00 00 
  801c2e:	4c 89 e2             	mov    %r12,%rdx
  801c31:	48 29 f2             	sub    %rsi,%rdx
  801c34:	4c 01 f6             	add    %r14,%rsi
  801c37:	44 89 ef             	mov    %r13d,%edi
  801c3a:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  801c3d:	85 c0                	test   %eax,%eax
  801c3f:	78 20                	js     801c61 <readn+0x6a>
    for (; inc && res < n; res += inc) {
  801c41:	01 c3                	add    %eax,%ebx
  801c43:	85 c0                	test   %eax,%eax
  801c45:	74 08                	je     801c4f <readn+0x58>
  801c47:	48 63 f3             	movslq %ebx,%rsi
  801c4a:	4c 39 e6             	cmp    %r12,%rsi
  801c4d:	72 df                	jb     801c2e <readn+0x37>
    }
    return res;
  801c4f:	48 63 c3             	movslq %ebx,%rax
}
  801c52:	48 83 c4 08          	add    $0x8,%rsp
  801c56:	5b                   	pop    %rbx
  801c57:	41 5c                	pop    %r12
  801c59:	41 5d                	pop    %r13
  801c5b:	41 5e                	pop    %r14
  801c5d:	41 5f                	pop    %r15
  801c5f:	5d                   	pop    %rbp
  801c60:	c3                   	ret
        if (inc < 0) return inc;
  801c61:	48 98                	cltq
  801c63:	eb ed                	jmp    801c52 <readn+0x5b>
    int inc = 1, res = 0;
  801c65:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c6a:	eb e3                	jmp    801c4f <readn+0x58>

0000000000801c6c <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  801c6c:	f3 0f 1e fa          	endbr64
  801c70:	55                   	push   %rbp
  801c71:	48 89 e5             	mov    %rsp,%rbp
  801c74:	41 56                	push   %r14
  801c76:	41 55                	push   %r13
  801c78:	41 54                	push   %r12
  801c7a:	53                   	push   %rbx
  801c7b:	48 83 ec 10          	sub    $0x10,%rsp
  801c7f:	89 fb                	mov    %edi,%ebx
  801c81:	49 89 f4             	mov    %rsi,%r12
  801c84:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801c87:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801c8b:	48 b8 3a 18 80 00 00 	movabs $0x80183a,%rax
  801c92:	00 00 00 
  801c95:	ff d0                	call   *%rax
  801c97:	85 c0                	test   %eax,%eax
  801c99:	78 47                	js     801ce2 <write+0x76>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801c9b:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801c9f:	41 8b 3e             	mov    (%r14),%edi
  801ca2:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801ca6:	48 b8 89 18 80 00 00 	movabs $0x801889,%rax
  801cad:	00 00 00 
  801cb0:	ff d0                	call   *%rax
  801cb2:	85 c0                	test   %eax,%eax
  801cb4:	78 30                	js     801ce6 <write+0x7a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801cb6:	41 f6 46 08 03       	testb  $0x3,0x8(%r14)
  801cbb:	74 2d                	je     801cea <write+0x7e>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801cbd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801cc1:	48 8b 40 18          	mov    0x18(%rax),%rax
  801cc5:	48 85 c0             	test   %rax,%rax
  801cc8:	74 56                	je     801d20 <write+0xb4>

    return (*dev->dev_write)(fd, buf, n);
  801cca:	4c 89 ea             	mov    %r13,%rdx
  801ccd:	4c 89 e6             	mov    %r12,%rsi
  801cd0:	4c 89 f7             	mov    %r14,%rdi
  801cd3:	ff d0                	call   *%rax
}
  801cd5:	48 83 c4 10          	add    $0x10,%rsp
  801cd9:	5b                   	pop    %rbx
  801cda:	41 5c                	pop    %r12
  801cdc:	41 5d                	pop    %r13
  801cde:	41 5e                	pop    %r14
  801ce0:	5d                   	pop    %rbp
  801ce1:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801ce2:	48 98                	cltq
  801ce4:	eb ef                	jmp    801cd5 <write+0x69>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801ce6:	48 98                	cltq
  801ce8:	eb eb                	jmp    801cd5 <write+0x69>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801cea:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801cf1:	00 00 00 
  801cf4:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801cfa:	89 da                	mov    %ebx,%edx
  801cfc:	48 bf d5 41 80 00 00 	movabs $0x8041d5,%rdi
  801d03:	00 00 00 
  801d06:	b8 00 00 00 00       	mov    $0x0,%eax
  801d0b:	48 b9 04 03 80 00 00 	movabs $0x800304,%rcx
  801d12:	00 00 00 
  801d15:	ff d1                	call   *%rcx
        return -E_INVAL;
  801d17:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801d1e:	eb b5                	jmp    801cd5 <write+0x69>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801d20:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801d27:	eb ac                	jmp    801cd5 <write+0x69>

0000000000801d29 <seek>:

int
seek(int fdnum, off_t offset) {
  801d29:	f3 0f 1e fa          	endbr64
  801d2d:	55                   	push   %rbp
  801d2e:	48 89 e5             	mov    %rsp,%rbp
  801d31:	53                   	push   %rbx
  801d32:	48 83 ec 18          	sub    $0x18,%rsp
  801d36:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801d38:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801d3c:	48 b8 3a 18 80 00 00 	movabs $0x80183a,%rax
  801d43:	00 00 00 
  801d46:	ff d0                	call   *%rax
  801d48:	85 c0                	test   %eax,%eax
  801d4a:	78 0c                	js     801d58 <seek+0x2f>

    fd->fd_offset = offset;
  801d4c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d50:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  801d53:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d58:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801d5c:	c9                   	leave
  801d5d:	c3                   	ret

0000000000801d5e <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  801d5e:	f3 0f 1e fa          	endbr64
  801d62:	55                   	push   %rbp
  801d63:	48 89 e5             	mov    %rsp,%rbp
  801d66:	41 55                	push   %r13
  801d68:	41 54                	push   %r12
  801d6a:	53                   	push   %rbx
  801d6b:	48 83 ec 18          	sub    $0x18,%rsp
  801d6f:	89 fb                	mov    %edi,%ebx
  801d71:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801d74:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801d78:	48 b8 3a 18 80 00 00 	movabs $0x80183a,%rax
  801d7f:	00 00 00 
  801d82:	ff d0                	call   *%rax
  801d84:	85 c0                	test   %eax,%eax
  801d86:	78 38                	js     801dc0 <ftruncate+0x62>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801d88:	4c 8b 6d d8          	mov    -0x28(%rbp),%r13
  801d8c:	41 8b 7d 00          	mov    0x0(%r13),%edi
  801d90:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801d94:	48 b8 89 18 80 00 00 	movabs $0x801889,%rax
  801d9b:	00 00 00 
  801d9e:	ff d0                	call   *%rax
  801da0:	85 c0                	test   %eax,%eax
  801da2:	78 1c                	js     801dc0 <ftruncate+0x62>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801da4:	41 f6 45 08 03       	testb  $0x3,0x8(%r13)
  801da9:	74 20                	je     801dcb <ftruncate+0x6d>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801dab:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801daf:	48 8b 40 30          	mov    0x30(%rax),%rax
  801db3:	48 85 c0             	test   %rax,%rax
  801db6:	74 47                	je     801dff <ftruncate+0xa1>

    return (*dev->dev_trunc)(fd, newsize);
  801db8:	44 89 e6             	mov    %r12d,%esi
  801dbb:	4c 89 ef             	mov    %r13,%rdi
  801dbe:	ff d0                	call   *%rax
}
  801dc0:	48 83 c4 18          	add    $0x18,%rsp
  801dc4:	5b                   	pop    %rbx
  801dc5:	41 5c                	pop    %r12
  801dc7:	41 5d                	pop    %r13
  801dc9:	5d                   	pop    %rbp
  801dca:	c3                   	ret
                thisenv->env_id, fdnum);
  801dcb:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801dd2:	00 00 00 
  801dd5:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801ddb:	89 da                	mov    %ebx,%edx
  801ddd:	48 bf f0 42 80 00 00 	movabs $0x8042f0,%rdi
  801de4:	00 00 00 
  801de7:	b8 00 00 00 00       	mov    $0x0,%eax
  801dec:	48 b9 04 03 80 00 00 	movabs $0x800304,%rcx
  801df3:	00 00 00 
  801df6:	ff d1                	call   *%rcx
        return -E_INVAL;
  801df8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801dfd:	eb c1                	jmp    801dc0 <ftruncate+0x62>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801dff:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801e04:	eb ba                	jmp    801dc0 <ftruncate+0x62>

0000000000801e06 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  801e06:	f3 0f 1e fa          	endbr64
  801e0a:	55                   	push   %rbp
  801e0b:	48 89 e5             	mov    %rsp,%rbp
  801e0e:	41 54                	push   %r12
  801e10:	53                   	push   %rbx
  801e11:	48 83 ec 10          	sub    $0x10,%rsp
  801e15:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801e18:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801e1c:	48 b8 3a 18 80 00 00 	movabs $0x80183a,%rax
  801e23:	00 00 00 
  801e26:	ff d0                	call   *%rax
  801e28:	85 c0                	test   %eax,%eax
  801e2a:	78 4e                	js     801e7a <fstat+0x74>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801e2c:	4c 8b 65 e8          	mov    -0x18(%rbp),%r12
  801e30:	41 8b 3c 24          	mov    (%r12),%edi
  801e34:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801e38:	48 b8 89 18 80 00 00 	movabs $0x801889,%rax
  801e3f:	00 00 00 
  801e42:	ff d0                	call   *%rax
  801e44:	85 c0                	test   %eax,%eax
  801e46:	78 32                	js     801e7a <fstat+0x74>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  801e48:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e4c:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  801e51:	74 30                	je     801e83 <fstat+0x7d>

    stat->st_name[0] = 0;
  801e53:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  801e56:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  801e5d:	00 00 00 
    stat->st_isdir = 0;
  801e60:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801e67:	00 00 00 
    stat->st_dev = dev;
  801e6a:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  801e71:	48 89 de             	mov    %rbx,%rsi
  801e74:	4c 89 e7             	mov    %r12,%rdi
  801e77:	ff 50 28             	call   *0x28(%rax)
}
  801e7a:	48 83 c4 10          	add    $0x10,%rsp
  801e7e:	5b                   	pop    %rbx
  801e7f:	41 5c                	pop    %r12
  801e81:	5d                   	pop    %rbp
  801e82:	c3                   	ret
    if (!dev->dev_stat) return -E_NOT_SUPP;
  801e83:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801e88:	eb f0                	jmp    801e7a <fstat+0x74>

0000000000801e8a <stat>:

int
stat(const char *path, struct Stat *stat) {
  801e8a:	f3 0f 1e fa          	endbr64
  801e8e:	55                   	push   %rbp
  801e8f:	48 89 e5             	mov    %rsp,%rbp
  801e92:	41 54                	push   %r12
  801e94:	53                   	push   %rbx
  801e95:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  801e98:	be 00 00 00 00       	mov    $0x0,%esi
  801e9d:	48 b8 6b 21 80 00 00 	movabs $0x80216b,%rax
  801ea4:	00 00 00 
  801ea7:	ff d0                	call   *%rax
  801ea9:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  801eab:	85 c0                	test   %eax,%eax
  801ead:	78 25                	js     801ed4 <stat+0x4a>

    int res = fstat(fd, stat);
  801eaf:	4c 89 e6             	mov    %r12,%rsi
  801eb2:	89 c7                	mov    %eax,%edi
  801eb4:	48 b8 06 1e 80 00 00 	movabs $0x801e06,%rax
  801ebb:	00 00 00 
  801ebe:	ff d0                	call   *%rax
  801ec0:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  801ec3:	89 df                	mov    %ebx,%edi
  801ec5:	48 b8 ab 19 80 00 00 	movabs $0x8019ab,%rax
  801ecc:	00 00 00 
  801ecf:	ff d0                	call   *%rax

    return res;
  801ed1:	44 89 e3             	mov    %r12d,%ebx
}
  801ed4:	89 d8                	mov    %ebx,%eax
  801ed6:	5b                   	pop    %rbx
  801ed7:	41 5c                	pop    %r12
  801ed9:	5d                   	pop    %rbp
  801eda:	c3                   	ret

0000000000801edb <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  801edb:	f3 0f 1e fa          	endbr64
  801edf:	55                   	push   %rbp
  801ee0:	48 89 e5             	mov    %rsp,%rbp
  801ee3:	41 54                	push   %r12
  801ee5:	53                   	push   %rbx
  801ee6:	48 83 ec 10          	sub    $0x10,%rsp
  801eea:	41 89 fc             	mov    %edi,%r12d
  801eed:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801ef0:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801ef7:	00 00 00 
  801efa:	83 38 00             	cmpl   $0x0,(%rax)
  801efd:	74 6e                	je     801f6d <fsipc+0x92>

    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }
    fsenv = ipc_find_env(ENV_TYPE_FS);
  801eff:	bf 03 00 00 00       	mov    $0x3,%edi
  801f04:	48 b8 c1 30 80 00 00 	movabs $0x8030c1,%rax
  801f0b:	00 00 00 
  801f0e:	ff d0                	call   *%rax
  801f10:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  801f17:	00 00 
    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  801f19:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  801f1f:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801f24:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  801f2b:	00 00 00 
  801f2e:	44 89 e6             	mov    %r12d,%esi
  801f31:	89 c7                	mov    %eax,%edi
  801f33:	48 b8 ff 2f 80 00 00 	movabs $0x802fff,%rax
  801f3a:	00 00 00 
  801f3d:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  801f3f:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  801f46:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  801f47:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f4c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801f50:	48 89 de             	mov    %rbx,%rsi
  801f53:	bf 00 00 00 00       	mov    $0x0,%edi
  801f58:	48 b8 66 2f 80 00 00 	movabs $0x802f66,%rax
  801f5f:	00 00 00 
  801f62:	ff d0                	call   *%rax
}
  801f64:	48 83 c4 10          	add    $0x10,%rsp
  801f68:	5b                   	pop    %rbx
  801f69:	41 5c                	pop    %r12
  801f6b:	5d                   	pop    %rbp
  801f6c:	c3                   	ret
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801f6d:	bf 03 00 00 00       	mov    $0x3,%edi
  801f72:	48 b8 c1 30 80 00 00 	movabs $0x8030c1,%rax
  801f79:	00 00 00 
  801f7c:	ff d0                	call   *%rax
  801f7e:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  801f85:	00 00 
  801f87:	e9 73 ff ff ff       	jmp    801eff <fsipc+0x24>

0000000000801f8c <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  801f8c:	f3 0f 1e fa          	endbr64
  801f90:	55                   	push   %rbp
  801f91:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801f94:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801f9b:	00 00 00 
  801f9e:	8b 57 0c             	mov    0xc(%rdi),%edx
  801fa1:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  801fa3:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  801fa6:	be 00 00 00 00       	mov    $0x0,%esi
  801fab:	bf 02 00 00 00       	mov    $0x2,%edi
  801fb0:	48 b8 db 1e 80 00 00 	movabs $0x801edb,%rax
  801fb7:	00 00 00 
  801fba:	ff d0                	call   *%rax
}
  801fbc:	5d                   	pop    %rbp
  801fbd:	c3                   	ret

0000000000801fbe <devfile_flush>:
devfile_flush(struct Fd *fd) {
  801fbe:	f3 0f 1e fa          	endbr64
  801fc2:	55                   	push   %rbp
  801fc3:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801fc6:	8b 47 0c             	mov    0xc(%rdi),%eax
  801fc9:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  801fd0:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  801fd2:	be 00 00 00 00       	mov    $0x0,%esi
  801fd7:	bf 06 00 00 00       	mov    $0x6,%edi
  801fdc:	48 b8 db 1e 80 00 00 	movabs $0x801edb,%rax
  801fe3:	00 00 00 
  801fe6:	ff d0                	call   *%rax
}
  801fe8:	5d                   	pop    %rbp
  801fe9:	c3                   	ret

0000000000801fea <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  801fea:	f3 0f 1e fa          	endbr64
  801fee:	55                   	push   %rbp
  801fef:	48 89 e5             	mov    %rsp,%rbp
  801ff2:	41 54                	push   %r12
  801ff4:	53                   	push   %rbx
  801ff5:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801ff8:	8b 47 0c             	mov    0xc(%rdi),%eax
  801ffb:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  802002:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  802004:	be 00 00 00 00       	mov    $0x0,%esi
  802009:	bf 05 00 00 00       	mov    $0x5,%edi
  80200e:	48 b8 db 1e 80 00 00 	movabs $0x801edb,%rax
  802015:	00 00 00 
  802018:	ff d0                	call   *%rax
    if (res < 0) return res;
  80201a:	85 c0                	test   %eax,%eax
  80201c:	78 3d                	js     80205b <devfile_stat+0x71>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80201e:	49 bc 00 70 80 00 00 	movabs $0x807000,%r12
  802025:	00 00 00 
  802028:	4c 89 e6             	mov    %r12,%rsi
  80202b:	48 89 df             	mov    %rbx,%rdi
  80202e:	48 b8 4d 0c 80 00 00 	movabs $0x800c4d,%rax
  802035:	00 00 00 
  802038:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  80203a:	41 8b 84 24 80 00 00 	mov    0x80(%r12),%eax
  802041:	00 
  802042:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802048:	41 8b 84 24 84 00 00 	mov    0x84(%r12),%eax
  80204f:	00 
  802050:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  802056:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80205b:	5b                   	pop    %rbx
  80205c:	41 5c                	pop    %r12
  80205e:	5d                   	pop    %rbp
  80205f:	c3                   	ret

0000000000802060 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  802060:	f3 0f 1e fa          	endbr64
    if (n >= sizeof(fsipcbuf.write.req_buf)) {
  802064:	48 81 fa ef 0f 00 00 	cmp    $0xfef,%rdx
  80206b:	77 41                	ja     8020ae <devfile_write+0x4e>
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  80206d:	55                   	push   %rbp
  80206e:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  802071:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802078:	00 00 00 
  80207b:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  80207e:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.write.req_n = n;
  802080:	48 89 50 08          	mov    %rdx,0x8(%rax)
    memmove(fsipcbuf.write.req_buf, buf, n);
  802084:	48 8d 78 10          	lea    0x10(%rax),%rdi
  802088:	48 b8 68 0e 80 00 00 	movabs $0x800e68,%rax
  80208f:	00 00 00 
  802092:	ff d0                	call   *%rax
    res = fsipc(FSREQ_WRITE, NULL);
  802094:	be 00 00 00 00       	mov    $0x0,%esi
  802099:	bf 04 00 00 00       	mov    $0x4,%edi
  80209e:	48 b8 db 1e 80 00 00 	movabs $0x801edb,%rax
  8020a5:	00 00 00 
  8020a8:	ff d0                	call   *%rax
  8020aa:	48 98                	cltq
}
  8020ac:	5d                   	pop    %rbp
  8020ad:	c3                   	ret
        return -E_INVAL;
  8020ae:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
}
  8020b5:	c3                   	ret

00000000008020b6 <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  8020b6:	f3 0f 1e fa          	endbr64
  8020ba:	55                   	push   %rbp
  8020bb:	48 89 e5             	mov    %rsp,%rbp
  8020be:	41 55                	push   %r13
  8020c0:	41 54                	push   %r12
  8020c2:	53                   	push   %rbx
  8020c3:	48 83 ec 08          	sub    $0x8,%rsp
  8020c7:	49 89 f4             	mov    %rsi,%r12
  8020ca:	48 89 d3             	mov    %rdx,%rbx
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  8020cd:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8020d4:	00 00 00 
  8020d7:	8b 57 0c             	mov    0xc(%rdi),%edx
  8020da:	89 10                	mov    %edx,(%rax)
    fsipcbuf.read.req_n = n;
  8020dc:	48 89 58 08          	mov    %rbx,0x8(%rax)
    res = fsipc(FSREQ_READ, NULL);
  8020e0:	be 00 00 00 00       	mov    $0x0,%esi
  8020e5:	bf 03 00 00 00       	mov    $0x3,%edi
  8020ea:	48 b8 db 1e 80 00 00 	movabs $0x801edb,%rax
  8020f1:	00 00 00 
  8020f4:	ff d0                	call   *%rax
  8020f6:	4c 63 e8             	movslq %eax,%r13
    if (res < 0) {
  8020f9:	4d 85 ed             	test   %r13,%r13
  8020fc:	78 2a                	js     802128 <devfile_read+0x72>
    assert(res <= n && res <= PAGE_SIZE);
  8020fe:	4c 89 ea             	mov    %r13,%rdx
  802101:	4c 39 eb             	cmp    %r13,%rbx
  802104:	72 30                	jb     802136 <devfile_read+0x80>
  802106:	49 81 fd 00 10 00 00 	cmp    $0x1000,%r13
  80210d:	7f 27                	jg     802136 <devfile_read+0x80>
    memmove(buf, &fsipcbuf, res);
  80210f:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802116:	00 00 00 
  802119:	4c 89 e7             	mov    %r12,%rdi
  80211c:	48 b8 68 0e 80 00 00 	movabs $0x800e68,%rax
  802123:	00 00 00 
  802126:	ff d0                	call   *%rax
}
  802128:	4c 89 e8             	mov    %r13,%rax
  80212b:	48 83 c4 08          	add    $0x8,%rsp
  80212f:	5b                   	pop    %rbx
  802130:	41 5c                	pop    %r12
  802132:	41 5d                	pop    %r13
  802134:	5d                   	pop    %rbp
  802135:	c3                   	ret
    assert(res <= n && res <= PAGE_SIZE);
  802136:	48 b9 f2 41 80 00 00 	movabs $0x8041f2,%rcx
  80213d:	00 00 00 
  802140:	48 ba 0f 42 80 00 00 	movabs $0x80420f,%rdx
  802147:	00 00 00 
  80214a:	be 7b 00 00 00       	mov    $0x7b,%esi
  80214f:	48 bf 24 42 80 00 00 	movabs $0x804224,%rdi
  802156:	00 00 00 
  802159:	b8 00 00 00 00       	mov    $0x0,%eax
  80215e:	49 b8 bf 2e 80 00 00 	movabs $0x802ebf,%r8
  802165:	00 00 00 
  802168:	41 ff d0             	call   *%r8

000000000080216b <open>:
open(const char *path, int mode) {
  80216b:	f3 0f 1e fa          	endbr64
  80216f:	55                   	push   %rbp
  802170:	48 89 e5             	mov    %rsp,%rbp
  802173:	41 55                	push   %r13
  802175:	41 54                	push   %r12
  802177:	53                   	push   %rbx
  802178:	48 83 ec 18          	sub    $0x18,%rsp
  80217c:	49 89 fc             	mov    %rdi,%r12
  80217f:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  802182:	48 b8 08 0c 80 00 00 	movabs $0x800c08,%rax
  802189:	00 00 00 
  80218c:	ff d0                	call   *%rax
  80218e:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  802194:	0f 87 8a 00 00 00    	ja     802224 <open+0xb9>
    if ((res = fd_alloc(&fd)) < 0) return res;
  80219a:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  80219e:	48 b8 d6 17 80 00 00 	movabs $0x8017d6,%rax
  8021a5:	00 00 00 
  8021a8:	ff d0                	call   *%rax
  8021aa:	89 c3                	mov    %eax,%ebx
  8021ac:	85 c0                	test   %eax,%eax
  8021ae:	78 50                	js     802200 <open+0x95>
    strcpy(fsipcbuf.open.req_path, path);
  8021b0:	4c 89 e6             	mov    %r12,%rsi
  8021b3:	48 bb 00 70 80 00 00 	movabs $0x807000,%rbx
  8021ba:	00 00 00 
  8021bd:	48 89 df             	mov    %rbx,%rdi
  8021c0:	48 b8 4d 0c 80 00 00 	movabs $0x800c4d,%rax
  8021c7:	00 00 00 
  8021ca:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  8021cc:	44 89 ab 00 04 00 00 	mov    %r13d,0x400(%rbx)
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  8021d3:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8021d7:	bf 01 00 00 00       	mov    $0x1,%edi
  8021dc:	48 b8 db 1e 80 00 00 	movabs $0x801edb,%rax
  8021e3:	00 00 00 
  8021e6:	ff d0                	call   *%rax
  8021e8:	89 c3                	mov    %eax,%ebx
  8021ea:	85 c0                	test   %eax,%eax
  8021ec:	78 1f                	js     80220d <open+0xa2>
    return fd2num(fd);
  8021ee:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8021f2:	48 b8 a0 17 80 00 00 	movabs $0x8017a0,%rax
  8021f9:	00 00 00 
  8021fc:	ff d0                	call   *%rax
  8021fe:	89 c3                	mov    %eax,%ebx
}
  802200:	89 d8                	mov    %ebx,%eax
  802202:	48 83 c4 18          	add    $0x18,%rsp
  802206:	5b                   	pop    %rbx
  802207:	41 5c                	pop    %r12
  802209:	41 5d                	pop    %r13
  80220b:	5d                   	pop    %rbp
  80220c:	c3                   	ret
        fd_close(fd, 0);
  80220d:	be 00 00 00 00       	mov    $0x0,%esi
  802212:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802216:	48 b8 fd 18 80 00 00 	movabs $0x8018fd,%rax
  80221d:	00 00 00 
  802220:	ff d0                	call   *%rax
        return res;
  802222:	eb dc                	jmp    802200 <open+0x95>
        return -E_BAD_PATH;
  802224:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  802229:	eb d5                	jmp    802200 <open+0x95>

000000000080222b <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  80222b:	f3 0f 1e fa          	endbr64
  80222f:	55                   	push   %rbp
  802230:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  802233:	be 00 00 00 00       	mov    $0x0,%esi
  802238:	bf 08 00 00 00       	mov    $0x8,%edi
  80223d:	48 b8 db 1e 80 00 00 	movabs $0x801edb,%rax
  802244:	00 00 00 
  802247:	ff d0                	call   *%rax
}
  802249:	5d                   	pop    %rbp
  80224a:	c3                   	ret

000000000080224b <writebuf>:
    int error;      /* First error that occurred */
    char buf[PRINTBUFSZ];
};

static void
writebuf(struct printbuf *state) {
  80224b:	f3 0f 1e fa          	endbr64
    if (state->error > 0) {
  80224f:	83 7f 10 00          	cmpl   $0x0,0x10(%rdi)
  802253:	7f 01                	jg     802256 <writebuf+0xb>
  802255:	c3                   	ret
writebuf(struct printbuf *state) {
  802256:	55                   	push   %rbp
  802257:	48 89 e5             	mov    %rsp,%rbp
  80225a:	53                   	push   %rbx
  80225b:	48 83 ec 08          	sub    $0x8,%rsp
  80225f:	48 89 fb             	mov    %rdi,%rbx
        ssize_t result = write(state->fd, state->buf, state->offset);
  802262:	48 63 57 04          	movslq 0x4(%rdi),%rdx
  802266:	48 8d 77 14          	lea    0x14(%rdi),%rsi
  80226a:	8b 3f                	mov    (%rdi),%edi
  80226c:	48 b8 6c 1c 80 00 00 	movabs $0x801c6c,%rax
  802273:	00 00 00 
  802276:	ff d0                	call   *%rax
        if (result > 0) state->result += result;
  802278:	48 85 c0             	test   %rax,%rax
  80227b:	7e 04                	jle    802281 <writebuf+0x36>
  80227d:	48 01 43 08          	add    %rax,0x8(%rbx)

        /* Error, or wrote less than supplied */
        if (result != state->offset)
  802281:	48 63 53 04          	movslq 0x4(%rbx),%rdx
  802285:	48 39 c2             	cmp    %rax,%rdx
  802288:	74 0f                	je     802299 <writebuf+0x4e>
            state->error = MIN(0, result);
  80228a:	48 85 c0             	test   %rax,%rax
  80228d:	ba 00 00 00 00       	mov    $0x0,%edx
  802292:	48 0f 4f c2          	cmovg  %rdx,%rax
  802296:	89 43 10             	mov    %eax,0x10(%rbx)
    }
}
  802299:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80229d:	c9                   	leave
  80229e:	c3                   	ret

000000000080229f <putch>:

static void
putch(int ch, void *arg) {
  80229f:	f3 0f 1e fa          	endbr64
    struct printbuf *state = (struct printbuf *)arg;
    state->buf[state->offset++] = ch;
  8022a3:	8b 46 04             	mov    0x4(%rsi),%eax
  8022a6:	8d 50 01             	lea    0x1(%rax),%edx
  8022a9:	89 56 04             	mov    %edx,0x4(%rsi)
  8022ac:	48 98                	cltq
  8022ae:	40 88 7c 06 14       	mov    %dil,0x14(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ) {
  8022b3:	81 fa 00 01 00 00    	cmp    $0x100,%edx
  8022b9:	74 01                	je     8022bc <putch+0x1d>
  8022bb:	c3                   	ret
putch(int ch, void *arg) {
  8022bc:	55                   	push   %rbp
  8022bd:	48 89 e5             	mov    %rsp,%rbp
  8022c0:	53                   	push   %rbx
  8022c1:	48 83 ec 08          	sub    $0x8,%rsp
  8022c5:	48 89 f3             	mov    %rsi,%rbx
        writebuf(state);
  8022c8:	48 89 f7             	mov    %rsi,%rdi
  8022cb:	48 b8 4b 22 80 00 00 	movabs $0x80224b,%rax
  8022d2:	00 00 00 
  8022d5:	ff d0                	call   *%rax
        state->offset = 0;
  8022d7:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%rbx)
    }
}
  8022de:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8022e2:	c9                   	leave
  8022e3:	c3                   	ret

00000000008022e4 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap) {
  8022e4:	f3 0f 1e fa          	endbr64
  8022e8:	55                   	push   %rbp
  8022e9:	48 89 e5             	mov    %rsp,%rbp
  8022ec:	48 81 ec 20 01 00 00 	sub    $0x120,%rsp
  8022f3:	48 89 d1             	mov    %rdx,%rcx
    struct printbuf state;
    state.fd = fd;
  8022f6:	89 bd e8 fe ff ff    	mov    %edi,-0x118(%rbp)
    state.offset = 0;
  8022fc:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%rbp)
  802303:	00 00 00 
    state.result = 0;
  802306:	48 c7 85 f0 fe ff ff 	movq   $0x0,-0x110(%rbp)
  80230d:	00 00 00 00 
    state.error = 1;
  802311:	c7 85 f8 fe ff ff 01 	movl   $0x1,-0x108(%rbp)
  802318:	00 00 00 

    vprintfmt(putch, &state, fmt, ap);
  80231b:	48 89 f2             	mov    %rsi,%rdx
  80231e:	48 8d b5 e8 fe ff ff 	lea    -0x118(%rbp),%rsi
  802325:	48 bf 9f 22 80 00 00 	movabs $0x80229f,%rdi
  80232c:	00 00 00 
  80232f:	48 b8 64 04 80 00 00 	movabs $0x800464,%rax
  802336:	00 00 00 
  802339:	ff d0                	call   *%rax
    if (state.offset > 0) writebuf(&state);
  80233b:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%rbp)
  802342:	7f 14                	jg     802358 <vfprintf+0x74>

    return (state.result ? state.result : state.error);
  802344:	48 8b 85 f0 fe ff ff 	mov    -0x110(%rbp),%rax
  80234b:	48 85 c0             	test   %rax,%rax
  80234e:	75 06                	jne    802356 <vfprintf+0x72>
  802350:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
}
  802356:	c9                   	leave
  802357:	c3                   	ret
    if (state.offset > 0) writebuf(&state);
  802358:	48 8d bd e8 fe ff ff 	lea    -0x118(%rbp),%rdi
  80235f:	48 b8 4b 22 80 00 00 	movabs $0x80224b,%rax
  802366:	00 00 00 
  802369:	ff d0                	call   *%rax
  80236b:	eb d7                	jmp    802344 <vfprintf+0x60>

000000000080236d <fprintf>:

int
fprintf(int fd, const char *fmt, ...) {
  80236d:	f3 0f 1e fa          	endbr64
  802371:	55                   	push   %rbp
  802372:	48 89 e5             	mov    %rsp,%rbp
  802375:	48 83 ec 50          	sub    $0x50,%rsp
  802379:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80237d:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802381:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  802385:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    va_start(ap, fmt);
  802389:	c7 45 b8 10 00 00 00 	movl   $0x10,-0x48(%rbp)
  802390:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802394:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802398:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80239c:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int res = vfprintf(fd, fmt, ap);
  8023a0:	48 8d 55 b8          	lea    -0x48(%rbp),%rdx
  8023a4:	48 b8 e4 22 80 00 00 	movabs $0x8022e4,%rax
  8023ab:	00 00 00 
  8023ae:	ff d0                	call   *%rax
    va_end(ap);

    return res;
}
  8023b0:	c9                   	leave
  8023b1:	c3                   	ret

00000000008023b2 <printf>:

int
printf(const char *fmt, ...) {
  8023b2:	f3 0f 1e fa          	endbr64
  8023b6:	55                   	push   %rbp
  8023b7:	48 89 e5             	mov    %rsp,%rbp
  8023ba:	48 83 ec 50          	sub    $0x50,%rsp
  8023be:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  8023c2:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8023c6:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8023ca:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8023ce:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    va_start(ap, fmt);
  8023d2:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  8023d9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8023dd:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8023e1:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8023e5:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int res = vfprintf(1, fmt, ap);
  8023e9:	48 8d 55 b8          	lea    -0x48(%rbp),%rdx
  8023ed:	48 89 fe             	mov    %rdi,%rsi
  8023f0:	bf 01 00 00 00       	mov    $0x1,%edi
  8023f5:	48 b8 e4 22 80 00 00 	movabs $0x8022e4,%rax
  8023fc:	00 00 00 
  8023ff:	ff d0                	call   *%rax
    va_end(ap);

    return res;
}
  802401:	c9                   	leave
  802402:	c3                   	ret

0000000000802403 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  802403:	f3 0f 1e fa          	endbr64
  802407:	55                   	push   %rbp
  802408:	48 89 e5             	mov    %rsp,%rbp
  80240b:	41 54                	push   %r12
  80240d:	53                   	push   %rbx
  80240e:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802411:	48 b8 b6 17 80 00 00 	movabs $0x8017b6,%rax
  802418:	00 00 00 
  80241b:	ff d0                	call   *%rax
  80241d:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  802420:	48 be 2f 42 80 00 00 	movabs $0x80422f,%rsi
  802427:	00 00 00 
  80242a:	48 89 df             	mov    %rbx,%rdi
  80242d:	48 b8 4d 0c 80 00 00 	movabs $0x800c4d,%rax
  802434:	00 00 00 
  802437:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  802439:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  80243e:	41 2b 04 24          	sub    (%r12),%eax
  802442:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  802448:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  80244f:	00 00 00 
    stat->st_dev = &devpipe;
  802452:	48 b8 60 50 80 00 00 	movabs $0x805060,%rax
  802459:	00 00 00 
  80245c:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  802463:	b8 00 00 00 00       	mov    $0x0,%eax
  802468:	5b                   	pop    %rbx
  802469:	41 5c                	pop    %r12
  80246b:	5d                   	pop    %rbp
  80246c:	c3                   	ret

000000000080246d <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  80246d:	f3 0f 1e fa          	endbr64
  802471:	55                   	push   %rbp
  802472:	48 89 e5             	mov    %rsp,%rbp
  802475:	41 54                	push   %r12
  802477:	53                   	push   %rbx
  802478:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  80247b:	ba 00 10 00 00       	mov    $0x1000,%edx
  802480:	48 89 fe             	mov    %rdi,%rsi
  802483:	bf 00 00 00 00       	mov    $0x0,%edi
  802488:	49 bc 92 13 80 00 00 	movabs $0x801392,%r12
  80248f:	00 00 00 
  802492:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  802495:	48 89 df             	mov    %rbx,%rdi
  802498:	48 b8 b6 17 80 00 00 	movabs $0x8017b6,%rax
  80249f:	00 00 00 
  8024a2:	ff d0                	call   *%rax
  8024a4:	48 89 c6             	mov    %rax,%rsi
  8024a7:	ba 00 10 00 00       	mov    $0x1000,%edx
  8024ac:	bf 00 00 00 00       	mov    $0x0,%edi
  8024b1:	41 ff d4             	call   *%r12
}
  8024b4:	5b                   	pop    %rbx
  8024b5:	41 5c                	pop    %r12
  8024b7:	5d                   	pop    %rbp
  8024b8:	c3                   	ret

00000000008024b9 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  8024b9:	f3 0f 1e fa          	endbr64
  8024bd:	55                   	push   %rbp
  8024be:	48 89 e5             	mov    %rsp,%rbp
  8024c1:	41 57                	push   %r15
  8024c3:	41 56                	push   %r14
  8024c5:	41 55                	push   %r13
  8024c7:	41 54                	push   %r12
  8024c9:	53                   	push   %rbx
  8024ca:	48 83 ec 18          	sub    $0x18,%rsp
  8024ce:	49 89 fc             	mov    %rdi,%r12
  8024d1:	49 89 f5             	mov    %rsi,%r13
  8024d4:	49 89 d7             	mov    %rdx,%r15
  8024d7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8024db:	48 b8 b6 17 80 00 00 	movabs $0x8017b6,%rax
  8024e2:	00 00 00 
  8024e5:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  8024e7:	4d 85 ff             	test   %r15,%r15
  8024ea:	0f 84 af 00 00 00    	je     80259f <devpipe_write+0xe6>
  8024f0:	48 89 c3             	mov    %rax,%rbx
  8024f3:	4c 89 f8             	mov    %r15,%rax
  8024f6:	4d 89 ef             	mov    %r13,%r15
  8024f9:	4c 01 e8             	add    %r13,%rax
  8024fc:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802500:	49 bd 22 12 80 00 00 	movabs $0x801222,%r13
  802507:	00 00 00 
            sys_yield();
  80250a:	49 be b7 11 80 00 00 	movabs $0x8011b7,%r14
  802511:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  802514:	8b 73 04             	mov    0x4(%rbx),%esi
  802517:	48 63 ce             	movslq %esi,%rcx
  80251a:	48 63 03             	movslq (%rbx),%rax
  80251d:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  802523:	48 39 c1             	cmp    %rax,%rcx
  802526:	72 2e                	jb     802556 <devpipe_write+0x9d>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802528:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80252d:	48 89 da             	mov    %rbx,%rdx
  802530:	be 00 10 00 00       	mov    $0x1000,%esi
  802535:	4c 89 e7             	mov    %r12,%rdi
  802538:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  80253b:	85 c0                	test   %eax,%eax
  80253d:	74 66                	je     8025a5 <devpipe_write+0xec>
            sys_yield();
  80253f:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  802542:	8b 73 04             	mov    0x4(%rbx),%esi
  802545:	48 63 ce             	movslq %esi,%rcx
  802548:	48 63 03             	movslq (%rbx),%rax
  80254b:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  802551:	48 39 c1             	cmp    %rax,%rcx
  802554:	73 d2                	jae    802528 <devpipe_write+0x6f>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802556:	41 0f b6 3f          	movzbl (%r15),%edi
  80255a:	48 89 ca             	mov    %rcx,%rdx
  80255d:	48 c1 ea 03          	shr    $0x3,%rdx
  802561:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  802568:	08 10 20 
  80256b:	48 f7 e2             	mul    %rdx
  80256e:	48 c1 ea 06          	shr    $0x6,%rdx
  802572:	48 89 d0             	mov    %rdx,%rax
  802575:	48 c1 e0 09          	shl    $0x9,%rax
  802579:	48 29 d0             	sub    %rdx,%rax
  80257c:	48 c1 e0 03          	shl    $0x3,%rax
  802580:	48 29 c1             	sub    %rax,%rcx
  802583:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  802588:	83 c6 01             	add    $0x1,%esi
  80258b:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  80258e:	49 83 c7 01          	add    $0x1,%r15
  802592:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802596:	49 39 c7             	cmp    %rax,%r15
  802599:	0f 85 75 ff ff ff    	jne    802514 <devpipe_write+0x5b>
    return n;
  80259f:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8025a3:	eb 05                	jmp    8025aa <devpipe_write+0xf1>
            if (_pipeisclosed(fd, p)) return 0;
  8025a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025aa:	48 83 c4 18          	add    $0x18,%rsp
  8025ae:	5b                   	pop    %rbx
  8025af:	41 5c                	pop    %r12
  8025b1:	41 5d                	pop    %r13
  8025b3:	41 5e                	pop    %r14
  8025b5:	41 5f                	pop    %r15
  8025b7:	5d                   	pop    %rbp
  8025b8:	c3                   	ret

00000000008025b9 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  8025b9:	f3 0f 1e fa          	endbr64
  8025bd:	55                   	push   %rbp
  8025be:	48 89 e5             	mov    %rsp,%rbp
  8025c1:	41 57                	push   %r15
  8025c3:	41 56                	push   %r14
  8025c5:	41 55                	push   %r13
  8025c7:	41 54                	push   %r12
  8025c9:	53                   	push   %rbx
  8025ca:	48 83 ec 18          	sub    $0x18,%rsp
  8025ce:	49 89 fc             	mov    %rdi,%r12
  8025d1:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  8025d5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8025d9:	48 b8 b6 17 80 00 00 	movabs $0x8017b6,%rax
  8025e0:	00 00 00 
  8025e3:	ff d0                	call   *%rax
  8025e5:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  8025e8:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8025ee:	49 bd 22 12 80 00 00 	movabs $0x801222,%r13
  8025f5:	00 00 00 
            sys_yield();
  8025f8:	49 be b7 11 80 00 00 	movabs $0x8011b7,%r14
  8025ff:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  802602:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  802607:	74 7d                	je     802686 <devpipe_read+0xcd>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802609:	8b 03                	mov    (%rbx),%eax
  80260b:	3b 43 04             	cmp    0x4(%rbx),%eax
  80260e:	75 26                	jne    802636 <devpipe_read+0x7d>
            if (i > 0) return i;
  802610:	4d 85 ff             	test   %r15,%r15
  802613:	75 77                	jne    80268c <devpipe_read+0xd3>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802615:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80261a:	48 89 da             	mov    %rbx,%rdx
  80261d:	be 00 10 00 00       	mov    $0x1000,%esi
  802622:	4c 89 e7             	mov    %r12,%rdi
  802625:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802628:	85 c0                	test   %eax,%eax
  80262a:	74 72                	je     80269e <devpipe_read+0xe5>
            sys_yield();
  80262c:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  80262f:	8b 03                	mov    (%rbx),%eax
  802631:	3b 43 04             	cmp    0x4(%rbx),%eax
  802634:	74 df                	je     802615 <devpipe_read+0x5c>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802636:	48 63 c8             	movslq %eax,%rcx
  802639:	48 89 ca             	mov    %rcx,%rdx
  80263c:	48 c1 ea 03          	shr    $0x3,%rdx
  802640:	48 be 81 00 01 02 04 	movabs $0x2010080402010081,%rsi
  802647:	08 10 20 
  80264a:	48 89 d0             	mov    %rdx,%rax
  80264d:	48 f7 e6             	mul    %rsi
  802650:	48 c1 ea 06          	shr    $0x6,%rdx
  802654:	48 89 d0             	mov    %rdx,%rax
  802657:	48 c1 e0 09          	shl    $0x9,%rax
  80265b:	48 29 d0             	sub    %rdx,%rax
  80265e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802665:	00 
  802666:	48 89 c8             	mov    %rcx,%rax
  802669:	48 29 d0             	sub    %rdx,%rax
  80266c:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  802671:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  802675:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  802679:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  80267c:	49 83 c7 01          	add    $0x1,%r15
  802680:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  802684:	75 83                	jne    802609 <devpipe_read+0x50>
    return n;
  802686:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80268a:	eb 03                	jmp    80268f <devpipe_read+0xd6>
            if (i > 0) return i;
  80268c:	4c 89 f8             	mov    %r15,%rax
}
  80268f:	48 83 c4 18          	add    $0x18,%rsp
  802693:	5b                   	pop    %rbx
  802694:	41 5c                	pop    %r12
  802696:	41 5d                	pop    %r13
  802698:	41 5e                	pop    %r14
  80269a:	41 5f                	pop    %r15
  80269c:	5d                   	pop    %rbp
  80269d:	c3                   	ret
            if (_pipeisclosed(fd, p)) return 0;
  80269e:	b8 00 00 00 00       	mov    $0x0,%eax
  8026a3:	eb ea                	jmp    80268f <devpipe_read+0xd6>

00000000008026a5 <pipe>:
pipe(int pfd[2]) {
  8026a5:	f3 0f 1e fa          	endbr64
  8026a9:	55                   	push   %rbp
  8026aa:	48 89 e5             	mov    %rsp,%rbp
  8026ad:	41 55                	push   %r13
  8026af:	41 54                	push   %r12
  8026b1:	53                   	push   %rbx
  8026b2:	48 83 ec 18          	sub    $0x18,%rsp
  8026b6:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  8026b9:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  8026bd:	48 b8 d6 17 80 00 00 	movabs $0x8017d6,%rax
  8026c4:	00 00 00 
  8026c7:	ff d0                	call   *%rax
  8026c9:	89 c3                	mov    %eax,%ebx
  8026cb:	85 c0                	test   %eax,%eax
  8026cd:	0f 88 a0 01 00 00    	js     802873 <pipe+0x1ce>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  8026d3:	b9 46 00 00 00       	mov    $0x46,%ecx
  8026d8:	ba 00 10 00 00       	mov    $0x1000,%edx
  8026dd:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8026e1:	bf 00 00 00 00       	mov    $0x0,%edi
  8026e6:	48 b8 52 12 80 00 00 	movabs $0x801252,%rax
  8026ed:	00 00 00 
  8026f0:	ff d0                	call   *%rax
  8026f2:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  8026f4:	85 c0                	test   %eax,%eax
  8026f6:	0f 88 77 01 00 00    	js     802873 <pipe+0x1ce>
    if ((res = fd_alloc(&fd1)) < 0 ||
  8026fc:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  802700:	48 b8 d6 17 80 00 00 	movabs $0x8017d6,%rax
  802707:	00 00 00 
  80270a:	ff d0                	call   *%rax
  80270c:	89 c3                	mov    %eax,%ebx
  80270e:	85 c0                	test   %eax,%eax
  802710:	0f 88 43 01 00 00    	js     802859 <pipe+0x1b4>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  802716:	b9 46 00 00 00       	mov    $0x46,%ecx
  80271b:	ba 00 10 00 00       	mov    $0x1000,%edx
  802720:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802724:	bf 00 00 00 00       	mov    $0x0,%edi
  802729:	48 b8 52 12 80 00 00 	movabs $0x801252,%rax
  802730:	00 00 00 
  802733:	ff d0                	call   *%rax
  802735:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  802737:	85 c0                	test   %eax,%eax
  802739:	0f 88 1a 01 00 00    	js     802859 <pipe+0x1b4>
    va = fd2data(fd0);
  80273f:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802743:	48 b8 b6 17 80 00 00 	movabs $0x8017b6,%rax
  80274a:	00 00 00 
  80274d:	ff d0                	call   *%rax
  80274f:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  802752:	b9 46 00 00 00       	mov    $0x46,%ecx
  802757:	ba 00 10 00 00       	mov    $0x1000,%edx
  80275c:	48 89 c6             	mov    %rax,%rsi
  80275f:	bf 00 00 00 00       	mov    $0x0,%edi
  802764:	48 b8 52 12 80 00 00 	movabs $0x801252,%rax
  80276b:	00 00 00 
  80276e:	ff d0                	call   *%rax
  802770:	89 c3                	mov    %eax,%ebx
  802772:	85 c0                	test   %eax,%eax
  802774:	0f 88 c5 00 00 00    	js     80283f <pipe+0x19a>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  80277a:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  80277e:	48 b8 b6 17 80 00 00 	movabs $0x8017b6,%rax
  802785:	00 00 00 
  802788:	ff d0                	call   *%rax
  80278a:	48 89 c1             	mov    %rax,%rcx
  80278d:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  802793:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  802799:	ba 00 00 00 00       	mov    $0x0,%edx
  80279e:	4c 89 ee             	mov    %r13,%rsi
  8027a1:	bf 00 00 00 00       	mov    $0x0,%edi
  8027a6:	48 b8 bd 12 80 00 00 	movabs $0x8012bd,%rax
  8027ad:	00 00 00 
  8027b0:	ff d0                	call   *%rax
  8027b2:	89 c3                	mov    %eax,%ebx
  8027b4:	85 c0                	test   %eax,%eax
  8027b6:	78 6e                	js     802826 <pipe+0x181>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8027b8:	be 00 10 00 00       	mov    $0x1000,%esi
  8027bd:	4c 89 ef             	mov    %r13,%rdi
  8027c0:	48 b8 ec 11 80 00 00 	movabs $0x8011ec,%rax
  8027c7:	00 00 00 
  8027ca:	ff d0                	call   *%rax
  8027cc:	83 f8 02             	cmp    $0x2,%eax
  8027cf:	0f 85 ab 00 00 00    	jne    802880 <pipe+0x1db>
    fd0->fd_dev_id = devpipe.dev_id;
  8027d5:	a1 60 50 80 00 00 00 	movabs 0x805060,%eax
  8027dc:	00 00 
  8027de:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8027e2:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  8027e4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8027e8:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  8027ef:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8027f3:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  8027f5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8027f9:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  802800:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802804:	48 bb a0 17 80 00 00 	movabs $0x8017a0,%rbx
  80280b:	00 00 00 
  80280e:	ff d3                	call   *%rbx
  802810:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  802814:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802818:	ff d3                	call   *%rbx
  80281a:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  80281f:	bb 00 00 00 00       	mov    $0x0,%ebx
  802824:	eb 4d                	jmp    802873 <pipe+0x1ce>
    sys_unmap_region(0, va, PAGE_SIZE);
  802826:	ba 00 10 00 00       	mov    $0x1000,%edx
  80282b:	4c 89 ee             	mov    %r13,%rsi
  80282e:	bf 00 00 00 00       	mov    $0x0,%edi
  802833:	48 b8 92 13 80 00 00 	movabs $0x801392,%rax
  80283a:	00 00 00 
  80283d:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  80283f:	ba 00 10 00 00       	mov    $0x1000,%edx
  802844:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802848:	bf 00 00 00 00       	mov    $0x0,%edi
  80284d:	48 b8 92 13 80 00 00 	movabs $0x801392,%rax
  802854:	00 00 00 
  802857:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  802859:	ba 00 10 00 00       	mov    $0x1000,%edx
  80285e:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802862:	bf 00 00 00 00       	mov    $0x0,%edi
  802867:	48 b8 92 13 80 00 00 	movabs $0x801392,%rax
  80286e:	00 00 00 
  802871:	ff d0                	call   *%rax
}
  802873:	89 d8                	mov    %ebx,%eax
  802875:	48 83 c4 18          	add    $0x18,%rsp
  802879:	5b                   	pop    %rbx
  80287a:	41 5c                	pop    %r12
  80287c:	41 5d                	pop    %r13
  80287e:	5d                   	pop    %rbp
  80287f:	c3                   	ret
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802880:	48 b9 18 43 80 00 00 	movabs $0x804318,%rcx
  802887:	00 00 00 
  80288a:	48 ba 0f 42 80 00 00 	movabs $0x80420f,%rdx
  802891:	00 00 00 
  802894:	be 2e 00 00 00       	mov    $0x2e,%esi
  802899:	48 bf 36 42 80 00 00 	movabs $0x804236,%rdi
  8028a0:	00 00 00 
  8028a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8028a8:	49 b8 bf 2e 80 00 00 	movabs $0x802ebf,%r8
  8028af:	00 00 00 
  8028b2:	41 ff d0             	call   *%r8

00000000008028b5 <pipeisclosed>:
pipeisclosed(int fdnum) {
  8028b5:	f3 0f 1e fa          	endbr64
  8028b9:	55                   	push   %rbp
  8028ba:	48 89 e5             	mov    %rsp,%rbp
  8028bd:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8028c1:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8028c5:	48 b8 3a 18 80 00 00 	movabs $0x80183a,%rax
  8028cc:	00 00 00 
  8028cf:	ff d0                	call   *%rax
    if (res < 0) return res;
  8028d1:	85 c0                	test   %eax,%eax
  8028d3:	78 35                	js     80290a <pipeisclosed+0x55>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  8028d5:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8028d9:	48 b8 b6 17 80 00 00 	movabs $0x8017b6,%rax
  8028e0:	00 00 00 
  8028e3:	ff d0                	call   *%rax
  8028e5:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8028e8:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8028ed:	be 00 10 00 00       	mov    $0x1000,%esi
  8028f2:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8028f6:	48 b8 22 12 80 00 00 	movabs $0x801222,%rax
  8028fd:	00 00 00 
  802900:	ff d0                	call   *%rax
  802902:	85 c0                	test   %eax,%eax
  802904:	0f 94 c0             	sete   %al
  802907:	0f b6 c0             	movzbl %al,%eax
}
  80290a:	c9                   	leave
  80290b:	c3                   	ret

000000000080290c <get_uvpt_entry>:
extern volatile pde_t uvpd[];     /* VA of current page directory */
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
  80290c:	f3 0f 1e fa          	endbr64
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802910:	48 89 f8             	mov    %rdi,%rax
  802913:	48 c1 e8 27          	shr    $0x27,%rax
  802917:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  80291e:	7f 00 00 
  802921:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802925:	f6 c2 01             	test   $0x1,%dl
  802928:	74 6d                	je     802997 <get_uvpt_entry+0x8b>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  80292a:	48 89 f8             	mov    %rdi,%rax
  80292d:	48 c1 e8 1e          	shr    $0x1e,%rax
  802931:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  802938:	7f 00 00 
  80293b:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80293f:	f6 c2 01             	test   $0x1,%dl
  802942:	74 62                	je     8029a6 <get_uvpt_entry+0x9a>
  802944:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  80294b:	7f 00 00 
  80294e:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802952:	f6 c2 80             	test   $0x80,%dl
  802955:	75 4f                	jne    8029a6 <get_uvpt_entry+0x9a>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802957:	48 89 f8             	mov    %rdi,%rax
  80295a:	48 c1 e8 15          	shr    $0x15,%rax
  80295e:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802965:	7f 00 00 
  802968:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80296c:	f6 c2 01             	test   $0x1,%dl
  80296f:	74 44                	je     8029b5 <get_uvpt_entry+0xa9>
  802971:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802978:	7f 00 00 
  80297b:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80297f:	f6 c2 80             	test   $0x80,%dl
  802982:	75 31                	jne    8029b5 <get_uvpt_entry+0xa9>
    return uvpt[VPT(va)];
  802984:	48 c1 ef 0c          	shr    $0xc,%rdi
  802988:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  80298f:	7f 00 00 
  802992:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  802996:	c3                   	ret
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802997:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  80299e:	7f 00 00 
  8029a1:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8029a5:	c3                   	ret
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8029a6:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  8029ad:	7f 00 00 
  8029b0:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8029b4:	c3                   	ret
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8029b5:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  8029bc:	7f 00 00 
  8029bf:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8029c3:	c3                   	ret

00000000008029c4 <get_phys_addr>:

uintptr_t
get_phys_addr(void *va) {
  8029c4:	f3 0f 1e fa          	endbr64
  8029c8:	48 89 fa             	mov    %rdi,%rdx
    if (!(uvpml4[VPML4(va)] & PTE_P))
  8029cb:	48 89 f9             	mov    %rdi,%rcx
  8029ce:	48 c1 e9 27          	shr    $0x27,%rcx
  8029d2:	48 b8 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rax
  8029d9:	7f 00 00 
  8029dc:	48 8b 0c c8          	mov    (%rax,%rcx,8),%rcx
        return -1;
  8029e0:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpml4[VPML4(va)] & PTE_P))
  8029e7:	f6 c1 01             	test   $0x1,%cl
  8029ea:	0f 84 b2 00 00 00    	je     802aa2 <get_phys_addr+0xde>
    if (!(uvpdp[VPDP(va)] & PTE_P))
  8029f0:	48 89 f9             	mov    %rdi,%rcx
  8029f3:	48 c1 e9 1e          	shr    $0x1e,%rcx
  8029f7:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  8029fe:	7f 00 00 
  802a01:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  802a05:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpdp[VPDP(va)] & PTE_P))
  802a0c:	40 f6 c6 01          	test   $0x1,%sil
  802a10:	0f 84 8c 00 00 00    	je     802aa2 <get_phys_addr+0xde>
    if (uvpdp[VPDP(va)] & PTE_PS)
  802a16:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802a1d:	7f 00 00 
  802a20:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802a24:	a8 80                	test   $0x80,%al
  802a26:	75 7b                	jne    802aa3 <get_phys_addr+0xdf>
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
    if (!(uvpd[VPD(va)] & PTE_P))
  802a28:	48 89 f9             	mov    %rdi,%rcx
  802a2b:	48 c1 e9 15          	shr    $0x15,%rcx
  802a2f:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  802a36:	7f 00 00 
  802a39:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  802a3d:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpd[VPD(va)] & PTE_P))
  802a44:	40 f6 c6 01          	test   $0x1,%sil
  802a48:	74 58                	je     802aa2 <get_phys_addr+0xde>
    if ((uvpd[VPD(va)] & PTE_PS))
  802a4a:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  802a51:	7f 00 00 
  802a54:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802a58:	a8 80                	test   $0x80,%al
  802a5a:	75 6c                	jne    802ac8 <get_phys_addr+0x104>
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
    if (!(uvpt[VPT(va)] & PTE_P))
  802a5c:	48 89 f9             	mov    %rdi,%rcx
  802a5f:	48 c1 e9 0c          	shr    $0xc,%rcx
  802a63:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802a6a:	7f 00 00 
  802a6d:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  802a71:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpt[VPT(va)] & PTE_P))
  802a78:	40 f6 c6 01          	test   $0x1,%sil
  802a7c:	74 24                	je     802aa2 <get_phys_addr+0xde>
    return PTE_ADDR(uvpt[VPT(va)]) + PAGE_OFFSET(va);
  802a7e:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802a85:	7f 00 00 
  802a88:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802a8c:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802a93:	ff ff 7f 
  802a96:	48 21 c8             	and    %rcx,%rax
  802a99:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  802a9f:	48 09 d0             	or     %rdx,%rax
}
  802aa2:	c3                   	ret
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
  802aa3:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802aaa:	7f 00 00 
  802aad:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802ab1:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802ab8:	ff ff 7f 
  802abb:	48 21 c8             	and    %rcx,%rax
  802abe:	81 e2 ff ff ff 3f    	and    $0x3fffffff,%edx
  802ac4:	48 01 d0             	add    %rdx,%rax
  802ac7:	c3                   	ret
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
  802ac8:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  802acf:	7f 00 00 
  802ad2:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802ad6:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802add:	ff ff 7f 
  802ae0:	48 21 c8             	and    %rcx,%rax
  802ae3:	81 e2 ff ff 1f 00    	and    $0x1fffff,%edx
  802ae9:	48 01 d0             	add    %rdx,%rax
  802aec:	c3                   	ret

0000000000802aed <get_prot>:

int
get_prot(void *va) {
  802aed:	f3 0f 1e fa          	endbr64
  802af1:	55                   	push   %rbp
  802af2:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802af5:	48 b8 0c 29 80 00 00 	movabs $0x80290c,%rax
  802afc:	00 00 00 
  802aff:	ff d0                	call   *%rax
  802b01:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
    if (pte & PTE_P) prot |= PROT_R;
  802b04:	83 e0 01             	and    $0x1,%eax
  802b07:	c1 e0 02             	shl    $0x2,%eax
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  802b0a:	89 d1                	mov    %edx,%ecx
  802b0c:	81 e1 00 0a 00 00    	and    $0xa00,%ecx
    if (pte & PTE_P) prot |= PROT_R;
  802b12:	09 c8                	or     %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  802b14:	89 c1                	mov    %eax,%ecx
  802b16:	83 c9 02             	or     $0x2,%ecx
  802b19:	f6 c2 02             	test   $0x2,%dl
  802b1c:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  802b1f:	89 c1                	mov    %eax,%ecx
  802b21:	83 c9 01             	or     $0x1,%ecx
  802b24:	48 85 d2             	test   %rdx,%rdx
  802b27:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  802b2a:	89 c1                	mov    %eax,%ecx
  802b2c:	83 c9 40             	or     $0x40,%ecx
  802b2f:	f6 c6 04             	test   $0x4,%dh
  802b32:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  802b35:	5d                   	pop    %rbp
  802b36:	c3                   	ret

0000000000802b37 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  802b37:	f3 0f 1e fa          	endbr64
  802b3b:	55                   	push   %rbp
  802b3c:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802b3f:	48 b8 0c 29 80 00 00 	movabs $0x80290c,%rax
  802b46:	00 00 00 
  802b49:	ff d0                	call   *%rax
    return pte & PTE_D;
  802b4b:	48 c1 e8 06          	shr    $0x6,%rax
  802b4f:	83 e0 01             	and    $0x1,%eax
}
  802b52:	5d                   	pop    %rbp
  802b53:	c3                   	ret

0000000000802b54 <is_page_present>:

bool
is_page_present(void *va) {
  802b54:	f3 0f 1e fa          	endbr64
  802b58:	55                   	push   %rbp
  802b59:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  802b5c:	48 b8 0c 29 80 00 00 	movabs $0x80290c,%rax
  802b63:	00 00 00 
  802b66:	ff d0                	call   *%rax
  802b68:	83 e0 01             	and    $0x1,%eax
}
  802b6b:	5d                   	pop    %rbp
  802b6c:	c3                   	ret

0000000000802b6d <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  802b6d:	f3 0f 1e fa          	endbr64
  802b71:	55                   	push   %rbp
  802b72:	48 89 e5             	mov    %rsp,%rbp
  802b75:	41 57                	push   %r15
  802b77:	41 56                	push   %r14
  802b79:	41 55                	push   %r13
  802b7b:	41 54                	push   %r12
  802b7d:	53                   	push   %rbx
  802b7e:	48 83 ec 18          	sub    $0x18,%rsp
  802b82:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  802b86:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
     * NOTE: Skip over larger pages/page directories for efficiency */
    // LAB 11: Your code here:

    int res = 0;
    (void)fun, (void)arg;
    uintptr_t va = 0;
  802b8a:	bb 00 00 00 00       	mov    $0x0,%ebx
    while (va < USER_STACK_TOP) {
        size_t size = 0;
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  802b8f:	49 be 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%r14
  802b96:	7f 00 00 
            size = 1LL << PML4_SHIFT;
            goto next;
        }

        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802b99:	49 bd 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%r13
  802ba0:	7f 00 00 
    while (va < USER_STACK_TOP) {
  802ba3:	49 bf ff 6f ff ff 7f 	movabs $0x7fffff6fff,%r15
  802baa:	00 00 00 
  802bad:	eb 73                	jmp    802c22 <foreach_shared_region+0xb5>
            }

            goto next;
        }

        if (!(uvpd[VPD(va)] & PTE_P)) {
  802baf:	48 89 d8             	mov    %rbx,%rax
  802bb2:	48 c1 e8 15          	shr    $0x15,%rax
  802bb6:	48 b9 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rcx
  802bbd:	7f 00 00 
  802bc0:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
            size = 1LL << PD_SHIFT;
  802bc4:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
        if (!(uvpd[VPD(va)] & PTE_P)) {
  802bca:	f6 c2 01             	test   $0x1,%dl
  802bcd:	74 4b                	je     802c1a <foreach_shared_region+0xad>
            goto next;
        }

        if (uvpd[VPD(va)] & PTE_PS) {
  802bcf:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
  802bd3:	f6 c2 80             	test   $0x80,%dl
  802bd6:	74 11                	je     802be9 <foreach_shared_region+0x7c>
            size = 1LL << PD_SHIFT;
            if (uvpd[VPD(va)] & PTE_SHARE) {
  802bd8:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
  802bdc:	f6 c4 04             	test   $0x4,%ah
  802bdf:	74 39                	je     802c1a <foreach_shared_region+0xad>
            size = 1LL << PD_SHIFT;
  802be1:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
  802be7:	eb 20                	jmp    802c09 <foreach_shared_region+0x9c>

            goto next;
        }

        size = PAGE_SIZE;
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  802be9:	48 89 da             	mov    %rbx,%rdx
  802bec:	48 c1 ea 0c          	shr    $0xc,%rdx
  802bf0:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802bf7:	7f 00 00 
  802bfa:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
        size = PAGE_SIZE;
  802bfe:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  802c04:	f6 c4 04             	test   $0x4,%ah
  802c07:	74 11                	je     802c1a <foreach_shared_region+0xad>
            goto next;
        }

    map:
        fun((void *)va, (void *)(va + size), arg);
  802c09:	49 8d 34 1c          	lea    (%r12,%rbx,1),%rsi
  802c0d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802c11:	48 89 df             	mov    %rbx,%rdi
  802c14:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802c18:	ff d0                	call   *%rax
    next:
        va += size;
  802c1a:	4c 01 e3             	add    %r12,%rbx
    while (va < USER_STACK_TOP) {
  802c1d:	49 39 df             	cmp    %rbx,%r15
  802c20:	72 3e                	jb     802c60 <foreach_shared_region+0xf3>
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  802c22:	49 8b 06             	mov    (%r14),%rax
  802c25:	a8 01                	test   $0x1,%al
  802c27:	74 37                	je     802c60 <foreach_shared_region+0xf3>
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802c29:	48 89 d8             	mov    %rbx,%rax
  802c2c:	48 c1 e8 1e          	shr    $0x1e,%rax
  802c30:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
            size = 1LL << PDP_SHIFT;
  802c35:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802c3b:	f6 c2 01             	test   $0x1,%dl
  802c3e:	74 da                	je     802c1a <foreach_shared_region+0xad>
        if (uvpdp[VPDP(va)] & PTE_PS) {
  802c40:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
  802c45:	f6 c2 80             	test   $0x80,%dl
  802c48:	0f 84 61 ff ff ff    	je     802baf <foreach_shared_region+0x42>
            if (uvpdp[VPDP(va)] & PTE_SHARE) {
  802c4e:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  802c53:	f6 c4 04             	test   $0x4,%ah
  802c56:	74 c2                	je     802c1a <foreach_shared_region+0xad>
            size = 1LL << PDP_SHIFT;
  802c58:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
  802c5e:	eb a9                	jmp    802c09 <foreach_shared_region+0x9c>
    }
    return res;
}
  802c60:	b8 00 00 00 00       	mov    $0x0,%eax
  802c65:	48 83 c4 18          	add    $0x18,%rsp
  802c69:	5b                   	pop    %rbx
  802c6a:	41 5c                	pop    %r12
  802c6c:	41 5d                	pop    %r13
  802c6e:	41 5e                	pop    %r14
  802c70:	41 5f                	pop    %r15
  802c72:	5d                   	pop    %rbp
  802c73:	c3                   	ret

0000000000802c74 <devcons_close>:

    return res;
}

static int
devcons_close(struct Fd *fd) {
  802c74:	f3 0f 1e fa          	endbr64
    USED(fd);

    return 0;
}
  802c78:	b8 00 00 00 00       	mov    $0x0,%eax
  802c7d:	c3                   	ret

0000000000802c7e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  802c7e:	f3 0f 1e fa          	endbr64
  802c82:	55                   	push   %rbp
  802c83:	48 89 e5             	mov    %rsp,%rbp
  802c86:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  802c89:	48 be 46 42 80 00 00 	movabs $0x804246,%rsi
  802c90:	00 00 00 
  802c93:	48 b8 4d 0c 80 00 00 	movabs $0x800c4d,%rax
  802c9a:	00 00 00 
  802c9d:	ff d0                	call   *%rax
    return 0;
}
  802c9f:	b8 00 00 00 00       	mov    $0x0,%eax
  802ca4:	5d                   	pop    %rbp
  802ca5:	c3                   	ret

0000000000802ca6 <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  802ca6:	f3 0f 1e fa          	endbr64
  802caa:	55                   	push   %rbp
  802cab:	48 89 e5             	mov    %rsp,%rbp
  802cae:	41 57                	push   %r15
  802cb0:	41 56                	push   %r14
  802cb2:	41 55                	push   %r13
  802cb4:	41 54                	push   %r12
  802cb6:	53                   	push   %rbx
  802cb7:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  802cbe:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  802cc5:	48 85 d2             	test   %rdx,%rdx
  802cc8:	74 7a                	je     802d44 <devcons_write+0x9e>
  802cca:	49 89 d6             	mov    %rdx,%r14
  802ccd:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802cd3:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  802cd8:	49 bf 68 0e 80 00 00 	movabs $0x800e68,%r15
  802cdf:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  802ce2:	4c 89 f3             	mov    %r14,%rbx
  802ce5:	48 29 f3             	sub    %rsi,%rbx
  802ce8:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802ced:	48 39 c3             	cmp    %rax,%rbx
  802cf0:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  802cf4:	4c 63 eb             	movslq %ebx,%r13
  802cf7:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  802cfe:	48 01 c6             	add    %rax,%rsi
  802d01:	4c 89 ea             	mov    %r13,%rdx
  802d04:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802d0b:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  802d0e:	4c 89 ee             	mov    %r13,%rsi
  802d11:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802d18:	48 b8 ad 10 80 00 00 	movabs $0x8010ad,%rax
  802d1f:	00 00 00 
  802d22:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  802d24:	41 01 dc             	add    %ebx,%r12d
  802d27:	49 63 f4             	movslq %r12d,%rsi
  802d2a:	4c 39 f6             	cmp    %r14,%rsi
  802d2d:	72 b3                	jb     802ce2 <devcons_write+0x3c>
    return res;
  802d2f:	49 63 c4             	movslq %r12d,%rax
}
  802d32:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  802d39:	5b                   	pop    %rbx
  802d3a:	41 5c                	pop    %r12
  802d3c:	41 5d                	pop    %r13
  802d3e:	41 5e                	pop    %r14
  802d40:	41 5f                	pop    %r15
  802d42:	5d                   	pop    %rbp
  802d43:	c3                   	ret
    for (res = 0; res < n; res += inc) {
  802d44:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802d4a:	eb e3                	jmp    802d2f <devcons_write+0x89>

0000000000802d4c <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802d4c:	f3 0f 1e fa          	endbr64
  802d50:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  802d53:	ba 00 00 00 00       	mov    $0x0,%edx
  802d58:	48 85 c0             	test   %rax,%rax
  802d5b:	74 55                	je     802db2 <devcons_read+0x66>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802d5d:	55                   	push   %rbp
  802d5e:	48 89 e5             	mov    %rsp,%rbp
  802d61:	41 55                	push   %r13
  802d63:	41 54                	push   %r12
  802d65:	53                   	push   %rbx
  802d66:	48 83 ec 08          	sub    $0x8,%rsp
  802d6a:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  802d6d:	48 bb de 10 80 00 00 	movabs $0x8010de,%rbx
  802d74:	00 00 00 
  802d77:	49 bc b7 11 80 00 00 	movabs $0x8011b7,%r12
  802d7e:	00 00 00 
  802d81:	eb 03                	jmp    802d86 <devcons_read+0x3a>
  802d83:	41 ff d4             	call   *%r12
  802d86:	ff d3                	call   *%rbx
  802d88:	85 c0                	test   %eax,%eax
  802d8a:	74 f7                	je     802d83 <devcons_read+0x37>
    if (c < 0) return c;
  802d8c:	48 63 d0             	movslq %eax,%rdx
  802d8f:	78 13                	js     802da4 <devcons_read+0x58>
    if (c == 0x04) return 0;
  802d91:	ba 00 00 00 00       	mov    $0x0,%edx
  802d96:	83 f8 04             	cmp    $0x4,%eax
  802d99:	74 09                	je     802da4 <devcons_read+0x58>
    *(char *)vbuf = (char)c;
  802d9b:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  802d9f:	ba 01 00 00 00       	mov    $0x1,%edx
}
  802da4:	48 89 d0             	mov    %rdx,%rax
  802da7:	48 83 c4 08          	add    $0x8,%rsp
  802dab:	5b                   	pop    %rbx
  802dac:	41 5c                	pop    %r12
  802dae:	41 5d                	pop    %r13
  802db0:	5d                   	pop    %rbp
  802db1:	c3                   	ret
  802db2:	48 89 d0             	mov    %rdx,%rax
  802db5:	c3                   	ret

0000000000802db6 <cputchar>:
cputchar(int ch) {
  802db6:	f3 0f 1e fa          	endbr64
  802dba:	55                   	push   %rbp
  802dbb:	48 89 e5             	mov    %rsp,%rbp
  802dbe:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  802dc2:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  802dc6:	be 01 00 00 00       	mov    $0x1,%esi
  802dcb:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  802dcf:	48 b8 ad 10 80 00 00 	movabs $0x8010ad,%rax
  802dd6:	00 00 00 
  802dd9:	ff d0                	call   *%rax
}
  802ddb:	c9                   	leave
  802ddc:	c3                   	ret

0000000000802ddd <getchar>:
getchar(void) {
  802ddd:	f3 0f 1e fa          	endbr64
  802de1:	55                   	push   %rbp
  802de2:	48 89 e5             	mov    %rsp,%rbp
  802de5:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  802de9:	ba 01 00 00 00       	mov    $0x1,%edx
  802dee:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  802df2:	bf 00 00 00 00       	mov    $0x0,%edi
  802df7:	48 b8 35 1b 80 00 00 	movabs $0x801b35,%rax
  802dfe:	00 00 00 
  802e01:	ff d0                	call   *%rax
  802e03:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  802e05:	85 c0                	test   %eax,%eax
  802e07:	78 06                	js     802e0f <getchar+0x32>
  802e09:	74 08                	je     802e13 <getchar+0x36>
  802e0b:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  802e0f:	89 d0                	mov    %edx,%eax
  802e11:	c9                   	leave
  802e12:	c3                   	ret
    return res < 0 ? res : res ? c :
  802e13:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  802e18:	eb f5                	jmp    802e0f <getchar+0x32>

0000000000802e1a <iscons>:
iscons(int fdnum) {
  802e1a:	f3 0f 1e fa          	endbr64
  802e1e:	55                   	push   %rbp
  802e1f:	48 89 e5             	mov    %rsp,%rbp
  802e22:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802e26:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802e2a:	48 b8 3a 18 80 00 00 	movabs $0x80183a,%rax
  802e31:	00 00 00 
  802e34:	ff d0                	call   *%rax
    if (res < 0) return res;
  802e36:	85 c0                	test   %eax,%eax
  802e38:	78 18                	js     802e52 <iscons+0x38>
    return fd->fd_dev_id == devcons.dev_id;
  802e3a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802e3e:	48 b8 a0 50 80 00 00 	movabs $0x8050a0,%rax
  802e45:	00 00 00 
  802e48:	8b 00                	mov    (%rax),%eax
  802e4a:	39 02                	cmp    %eax,(%rdx)
  802e4c:	0f 94 c0             	sete   %al
  802e4f:	0f b6 c0             	movzbl %al,%eax
}
  802e52:	c9                   	leave
  802e53:	c3                   	ret

0000000000802e54 <opencons>:
opencons(void) {
  802e54:	f3 0f 1e fa          	endbr64
  802e58:	55                   	push   %rbp
  802e59:	48 89 e5             	mov    %rsp,%rbp
  802e5c:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  802e60:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  802e64:	48 b8 d6 17 80 00 00 	movabs $0x8017d6,%rax
  802e6b:	00 00 00 
  802e6e:	ff d0                	call   *%rax
  802e70:	85 c0                	test   %eax,%eax
  802e72:	78 49                	js     802ebd <opencons+0x69>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  802e74:	b9 46 00 00 00       	mov    $0x46,%ecx
  802e79:	ba 00 10 00 00       	mov    $0x1000,%edx
  802e7e:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  802e82:	bf 00 00 00 00       	mov    $0x0,%edi
  802e87:	48 b8 52 12 80 00 00 	movabs $0x801252,%rax
  802e8e:	00 00 00 
  802e91:	ff d0                	call   *%rax
  802e93:	85 c0                	test   %eax,%eax
  802e95:	78 26                	js     802ebd <opencons+0x69>
    fd->fd_dev_id = devcons.dev_id;
  802e97:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802e9b:	a1 a0 50 80 00 00 00 	movabs 0x8050a0,%eax
  802ea2:	00 00 
  802ea4:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  802ea6:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802eaa:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  802eb1:	48 b8 a0 17 80 00 00 	movabs $0x8017a0,%rax
  802eb8:	00 00 00 
  802ebb:	ff d0                	call   *%rax
}
  802ebd:	c9                   	leave
  802ebe:	c3                   	ret

0000000000802ebf <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  802ebf:	f3 0f 1e fa          	endbr64
  802ec3:	55                   	push   %rbp
  802ec4:	48 89 e5             	mov    %rsp,%rbp
  802ec7:	41 56                	push   %r14
  802ec9:	41 55                	push   %r13
  802ecb:	41 54                	push   %r12
  802ecd:	53                   	push   %rbx
  802ece:	48 83 ec 50          	sub    $0x50,%rsp
  802ed2:	49 89 fc             	mov    %rdi,%r12
  802ed5:	41 89 f5             	mov    %esi,%r13d
  802ed8:	48 89 d3             	mov    %rdx,%rbx
  802edb:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  802edf:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  802ee3:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  802ee7:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  802eee:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802ef2:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  802ef6:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  802efa:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  802efe:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  802f05:	00 00 00 
  802f08:	4c 8b 30             	mov    (%rax),%r14
  802f0b:	48 b8 82 11 80 00 00 	movabs $0x801182,%rax
  802f12:	00 00 00 
  802f15:	ff d0                	call   *%rax
  802f17:	89 c6                	mov    %eax,%esi
  802f19:	45 89 e8             	mov    %r13d,%r8d
  802f1c:	4c 89 e1             	mov    %r12,%rcx
  802f1f:	4c 89 f2             	mov    %r14,%rdx
  802f22:	48 bf 40 43 80 00 00 	movabs $0x804340,%rdi
  802f29:	00 00 00 
  802f2c:	b8 00 00 00 00       	mov    $0x0,%eax
  802f31:	49 bc 04 03 80 00 00 	movabs $0x800304,%r12
  802f38:	00 00 00 
  802f3b:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  802f3e:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  802f42:	48 89 df             	mov    %rbx,%rdi
  802f45:	48 b8 9c 02 80 00 00 	movabs $0x80029c,%rax
  802f4c:	00 00 00 
  802f4f:	ff d0                	call   *%rax
    cprintf("\n");
  802f51:	48 bf 10 40 80 00 00 	movabs $0x804010,%rdi
  802f58:	00 00 00 
  802f5b:	b8 00 00 00 00       	mov    $0x0,%eax
  802f60:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  802f63:	cc                   	int3
  802f64:	eb fd                	jmp    802f63 <_panic+0xa4>

0000000000802f66 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802f66:	f3 0f 1e fa          	endbr64
  802f6a:	55                   	push   %rbp
  802f6b:	48 89 e5             	mov    %rsp,%rbp
  802f6e:	41 54                	push   %r12
  802f70:	53                   	push   %rbx
  802f71:	48 89 fb             	mov    %rdi,%rbx
  802f74:	48 89 f7             	mov    %rsi,%rdi
  802f77:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802f7a:	48 85 f6             	test   %rsi,%rsi
  802f7d:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802f84:	00 00 00 
  802f87:	48 0f 44 f8          	cmove  %rax,%rdi
    }
    int res = sys_ipc_recv(pg, PAGE_SIZE);
  802f8b:	be 00 10 00 00       	mov    $0x1000,%esi
  802f90:	48 b8 74 15 80 00 00 	movabs $0x801574,%rax
  802f97:	00 00 00 
  802f9a:	ff d0                	call   *%rax
    if (res < 0) {
  802f9c:	85 c0                	test   %eax,%eax
  802f9e:	78 45                	js     802fe5 <ipc_recv+0x7f>
        if (perm_store != NULL) {
            *perm_store = 0;
        }
        return res;
    } else {
        if (from_env_store != NULL) {
  802fa0:	48 85 db             	test   %rbx,%rbx
  802fa3:	74 12                	je     802fb7 <ipc_recv+0x51>
            *from_env_store = thisenv->env_ipc_from;
  802fa5:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  802fac:	00 00 00 
  802faf:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  802fb5:	89 03                	mov    %eax,(%rbx)
        }
        if (perm_store != NULL) {
  802fb7:	4d 85 e4             	test   %r12,%r12
  802fba:	74 14                	je     802fd0 <ipc_recv+0x6a>
            *perm_store = thisenv->env_ipc_perm;
  802fbc:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  802fc3:	00 00 00 
  802fc6:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  802fcc:	41 89 04 24          	mov    %eax,(%r12)
        }
        return thisenv->env_ipc_value;
  802fd0:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  802fd7:	00 00 00 
  802fda:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
    }
    return -1;
}
  802fe0:	5b                   	pop    %rbx
  802fe1:	41 5c                	pop    %r12
  802fe3:	5d                   	pop    %rbp
  802fe4:	c3                   	ret
        if (from_env_store != NULL) {
  802fe5:	48 85 db             	test   %rbx,%rbx
  802fe8:	74 06                	je     802ff0 <ipc_recv+0x8a>
            *from_env_store = 0;
  802fea:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store != NULL) {
  802ff0:	4d 85 e4             	test   %r12,%r12
  802ff3:	74 eb                	je     802fe0 <ipc_recv+0x7a>
            *perm_store = 0;
  802ff5:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  802ffc:	00 
  802ffd:	eb e1                	jmp    802fe0 <ipc_recv+0x7a>

0000000000802fff <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  802fff:	f3 0f 1e fa          	endbr64
  803003:	55                   	push   %rbp
  803004:	48 89 e5             	mov    %rsp,%rbp
  803007:	41 57                	push   %r15
  803009:	41 56                	push   %r14
  80300b:	41 55                	push   %r13
  80300d:	41 54                	push   %r12
  80300f:	53                   	push   %rbx
  803010:	48 83 ec 18          	sub    $0x18,%rsp
  803014:	89 7d c4             	mov    %edi,-0x3c(%rbp)
  803017:	48 89 d3             	mov    %rdx,%rbx
  80301a:	49 89 cc             	mov    %rcx,%r12
  80301d:	45 89 c5             	mov    %r8d,%r13d
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  803020:	48 85 d2             	test   %rdx,%rdx
  803023:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  80302a:	00 00 00 
  80302d:	48 0f 44 d8          	cmove  %rax,%rbx
    }
    int res = sys_ipc_try_send(to_env, val, pg, size, perm);
  803031:	89 f0                	mov    %esi,%eax
  803033:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  803037:	48 89 da             	mov    %rbx,%rdx
  80303a:	48 89 c6             	mov    %rax,%rsi
  80303d:	48 b8 44 15 80 00 00 	movabs $0x801544,%rax
  803044:	00 00 00 
  803047:	ff d0                	call   *%rax
    while (res < 0) {
  803049:	85 c0                	test   %eax,%eax
  80304b:	79 65                	jns    8030b2 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  80304d:	83 f8 f5             	cmp    $0xfffffff5,%eax
  803050:	75 33                	jne    803085 <ipc_send+0x86>
            panic("Error: %i\n", res);
        }
        sys_yield();
  803052:	49 bf b7 11 80 00 00 	movabs $0x8011b7,%r15
  803059:	00 00 00 
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  80305c:	49 be 44 15 80 00 00 	movabs $0x801544,%r14
  803063:	00 00 00 
        sys_yield();
  803066:	41 ff d7             	call   *%r15
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  803069:	45 89 e8             	mov    %r13d,%r8d
  80306c:	4c 89 e1             	mov    %r12,%rcx
  80306f:	48 89 da             	mov    %rbx,%rdx
  803072:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  803076:	8b 7d c4             	mov    -0x3c(%rbp),%edi
  803079:	41 ff d6             	call   *%r14
    while (res < 0) {
  80307c:	85 c0                	test   %eax,%eax
  80307e:	79 32                	jns    8030b2 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  803080:	83 f8 f5             	cmp    $0xfffffff5,%eax
  803083:	74 e1                	je     803066 <ipc_send+0x67>
            panic("Error: %i\n", res);
  803085:	89 c1                	mov    %eax,%ecx
  803087:	48 ba 52 42 80 00 00 	movabs $0x804252,%rdx
  80308e:	00 00 00 
  803091:	be 42 00 00 00       	mov    $0x42,%esi
  803096:	48 bf 5d 42 80 00 00 	movabs $0x80425d,%rdi
  80309d:	00 00 00 
  8030a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8030a5:	49 b8 bf 2e 80 00 00 	movabs $0x802ebf,%r8
  8030ac:	00 00 00 
  8030af:	41 ff d0             	call   *%r8
    }
}
  8030b2:	48 83 c4 18          	add    $0x18,%rsp
  8030b6:	5b                   	pop    %rbx
  8030b7:	41 5c                	pop    %r12
  8030b9:	41 5d                	pop    %r13
  8030bb:	41 5e                	pop    %r14
  8030bd:	41 5f                	pop    %r15
  8030bf:	5d                   	pop    %rbp
  8030c0:	c3                   	ret

00000000008030c1 <ipc_find_env>:

/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
  8030c1:	f3 0f 1e fa          	endbr64
    for (size_t i = 0; i < NENV; i++)
  8030c5:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  8030ca:	48 b9 00 00 a0 1f 80 	movabs $0x801fa00000,%rcx
  8030d1:	00 00 00 
  8030d4:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8030d8:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  8030dc:	48 c1 e2 04          	shl    $0x4,%rdx
  8030e0:	48 01 ca             	add    %rcx,%rdx
  8030e3:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  8030e9:	39 fa                	cmp    %edi,%edx
  8030eb:	74 12                	je     8030ff <ipc_find_env+0x3e>
    for (size_t i = 0; i < NENV; i++)
  8030ed:	48 83 c0 01          	add    $0x1,%rax
  8030f1:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  8030f7:	75 db                	jne    8030d4 <ipc_find_env+0x13>
            return envs[i].env_id;
    return 0;
  8030f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030fe:	c3                   	ret
            return envs[i].env_id;
  8030ff:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  803103:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  803107:	48 c1 e2 04          	shl    $0x4,%rdx
  80310b:	48 b8 00 00 a0 1f 80 	movabs $0x801fa00000,%rax
  803112:	00 00 00 
  803115:	48 01 d0             	add    %rdx,%rax
  803118:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80311e:	c3                   	ret

000000000080311f <__text_end>:
  80311f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803126:	00 00 00 
  803129:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803130:	00 00 00 
  803133:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80313a:	00 00 00 
  80313d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803144:	00 00 00 
  803147:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80314e:	00 00 00 
  803151:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803158:	00 00 00 
  80315b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803162:	00 00 00 
  803165:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80316c:	00 00 00 
  80316f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803176:	00 00 00 
  803179:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803180:	00 00 00 
  803183:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80318a:	00 00 00 
  80318d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803194:	00 00 00 
  803197:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80319e:	00 00 00 
  8031a1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8031a8:	00 00 00 
  8031ab:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8031b2:	00 00 00 
  8031b5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8031bc:	00 00 00 
  8031bf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8031c6:	00 00 00 
  8031c9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8031d0:	00 00 00 
  8031d3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8031da:	00 00 00 
  8031dd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8031e4:	00 00 00 
  8031e7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8031ee:	00 00 00 
  8031f1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8031f8:	00 00 00 
  8031fb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803202:	00 00 00 
  803205:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80320c:	00 00 00 
  80320f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803216:	00 00 00 
  803219:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803220:	00 00 00 
  803223:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80322a:	00 00 00 
  80322d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803234:	00 00 00 
  803237:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80323e:	00 00 00 
  803241:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803248:	00 00 00 
  80324b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803252:	00 00 00 
  803255:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80325c:	00 00 00 
  80325f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803266:	00 00 00 
  803269:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803270:	00 00 00 
  803273:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80327a:	00 00 00 
  80327d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803284:	00 00 00 
  803287:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80328e:	00 00 00 
  803291:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803298:	00 00 00 
  80329b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032a2:	00 00 00 
  8032a5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032ac:	00 00 00 
  8032af:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032b6:	00 00 00 
  8032b9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032c0:	00 00 00 
  8032c3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032ca:	00 00 00 
  8032cd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032d4:	00 00 00 
  8032d7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032de:	00 00 00 
  8032e1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032e8:	00 00 00 
  8032eb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032f2:	00 00 00 
  8032f5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032fc:	00 00 00 
  8032ff:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803306:	00 00 00 
  803309:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803310:	00 00 00 
  803313:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80331a:	00 00 00 
  80331d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803324:	00 00 00 
  803327:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80332e:	00 00 00 
  803331:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803338:	00 00 00 
  80333b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803342:	00 00 00 
  803345:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80334c:	00 00 00 
  80334f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803356:	00 00 00 
  803359:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803360:	00 00 00 
  803363:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80336a:	00 00 00 
  80336d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803374:	00 00 00 
  803377:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80337e:	00 00 00 
  803381:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803388:	00 00 00 
  80338b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803392:	00 00 00 
  803395:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80339c:	00 00 00 
  80339f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033a6:	00 00 00 
  8033a9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033b0:	00 00 00 
  8033b3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033ba:	00 00 00 
  8033bd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033c4:	00 00 00 
  8033c7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033ce:	00 00 00 
  8033d1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033d8:	00 00 00 
  8033db:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033e2:	00 00 00 
  8033e5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033ec:	00 00 00 
  8033ef:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033f6:	00 00 00 
  8033f9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803400:	00 00 00 
  803403:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80340a:	00 00 00 
  80340d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803414:	00 00 00 
  803417:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80341e:	00 00 00 
  803421:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803428:	00 00 00 
  80342b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803432:	00 00 00 
  803435:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80343c:	00 00 00 
  80343f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803446:	00 00 00 
  803449:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803450:	00 00 00 
  803453:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80345a:	00 00 00 
  80345d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803464:	00 00 00 
  803467:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80346e:	00 00 00 
  803471:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803478:	00 00 00 
  80347b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803482:	00 00 00 
  803485:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80348c:	00 00 00 
  80348f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803496:	00 00 00 
  803499:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034a0:	00 00 00 
  8034a3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034aa:	00 00 00 
  8034ad:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034b4:	00 00 00 
  8034b7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034be:	00 00 00 
  8034c1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034c8:	00 00 00 
  8034cb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034d2:	00 00 00 
  8034d5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034dc:	00 00 00 
  8034df:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034e6:	00 00 00 
  8034e9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034f0:	00 00 00 
  8034f3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034fa:	00 00 00 
  8034fd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803504:	00 00 00 
  803507:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80350e:	00 00 00 
  803511:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803518:	00 00 00 
  80351b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803522:	00 00 00 
  803525:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80352c:	00 00 00 
  80352f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803536:	00 00 00 
  803539:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803540:	00 00 00 
  803543:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80354a:	00 00 00 
  80354d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803554:	00 00 00 
  803557:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80355e:	00 00 00 
  803561:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803568:	00 00 00 
  80356b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803572:	00 00 00 
  803575:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80357c:	00 00 00 
  80357f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803586:	00 00 00 
  803589:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803590:	00 00 00 
  803593:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80359a:	00 00 00 
  80359d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035a4:	00 00 00 
  8035a7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035ae:	00 00 00 
  8035b1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035b8:	00 00 00 
  8035bb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035c2:	00 00 00 
  8035c5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035cc:	00 00 00 
  8035cf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035d6:	00 00 00 
  8035d9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035e0:	00 00 00 
  8035e3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035ea:	00 00 00 
  8035ed:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035f4:	00 00 00 
  8035f7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035fe:	00 00 00 
  803601:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803608:	00 00 00 
  80360b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803612:	00 00 00 
  803615:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80361c:	00 00 00 
  80361f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803626:	00 00 00 
  803629:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803630:	00 00 00 
  803633:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80363a:	00 00 00 
  80363d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803644:	00 00 00 
  803647:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80364e:	00 00 00 
  803651:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803658:	00 00 00 
  80365b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803662:	00 00 00 
  803665:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80366c:	00 00 00 
  80366f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803676:	00 00 00 
  803679:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803680:	00 00 00 
  803683:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80368a:	00 00 00 
  80368d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803694:	00 00 00 
  803697:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80369e:	00 00 00 
  8036a1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036a8:	00 00 00 
  8036ab:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036b2:	00 00 00 
  8036b5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036bc:	00 00 00 
  8036bf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036c6:	00 00 00 
  8036c9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036d0:	00 00 00 
  8036d3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036da:	00 00 00 
  8036dd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036e4:	00 00 00 
  8036e7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036ee:	00 00 00 
  8036f1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036f8:	00 00 00 
  8036fb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803702:	00 00 00 
  803705:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80370c:	00 00 00 
  80370f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803716:	00 00 00 
  803719:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803720:	00 00 00 
  803723:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80372a:	00 00 00 
  80372d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803734:	00 00 00 
  803737:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80373e:	00 00 00 
  803741:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803748:	00 00 00 
  80374b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803752:	00 00 00 
  803755:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80375c:	00 00 00 
  80375f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803766:	00 00 00 
  803769:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803770:	00 00 00 
  803773:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80377a:	00 00 00 
  80377d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803784:	00 00 00 
  803787:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80378e:	00 00 00 
  803791:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803798:	00 00 00 
  80379b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037a2:	00 00 00 
  8037a5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037ac:	00 00 00 
  8037af:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037b6:	00 00 00 
  8037b9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037c0:	00 00 00 
  8037c3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037ca:	00 00 00 
  8037cd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037d4:	00 00 00 
  8037d7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037de:	00 00 00 
  8037e1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037e8:	00 00 00 
  8037eb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037f2:	00 00 00 
  8037f5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037fc:	00 00 00 
  8037ff:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803806:	00 00 00 
  803809:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803810:	00 00 00 
  803813:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80381a:	00 00 00 
  80381d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803824:	00 00 00 
  803827:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80382e:	00 00 00 
  803831:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803838:	00 00 00 
  80383b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803842:	00 00 00 
  803845:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80384c:	00 00 00 
  80384f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803856:	00 00 00 
  803859:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803860:	00 00 00 
  803863:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80386a:	00 00 00 
  80386d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803874:	00 00 00 
  803877:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80387e:	00 00 00 
  803881:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803888:	00 00 00 
  80388b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803892:	00 00 00 
  803895:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80389c:	00 00 00 
  80389f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038a6:	00 00 00 
  8038a9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038b0:	00 00 00 
  8038b3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038ba:	00 00 00 
  8038bd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038c4:	00 00 00 
  8038c7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038ce:	00 00 00 
  8038d1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038d8:	00 00 00 
  8038db:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038e2:	00 00 00 
  8038e5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038ec:	00 00 00 
  8038ef:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038f6:	00 00 00 
  8038f9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803900:	00 00 00 
  803903:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80390a:	00 00 00 
  80390d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803914:	00 00 00 
  803917:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80391e:	00 00 00 
  803921:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803928:	00 00 00 
  80392b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803932:	00 00 00 
  803935:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80393c:	00 00 00 
  80393f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803946:	00 00 00 
  803949:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803950:	00 00 00 
  803953:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80395a:	00 00 00 
  80395d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803964:	00 00 00 
  803967:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80396e:	00 00 00 
  803971:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803978:	00 00 00 
  80397b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803982:	00 00 00 
  803985:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80398c:	00 00 00 
  80398f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803996:	00 00 00 
  803999:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039a0:	00 00 00 
  8039a3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039aa:	00 00 00 
  8039ad:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039b4:	00 00 00 
  8039b7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039be:	00 00 00 
  8039c1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039c8:	00 00 00 
  8039cb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039d2:	00 00 00 
  8039d5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039dc:	00 00 00 
  8039df:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039e6:	00 00 00 
  8039e9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039f0:	00 00 00 
  8039f3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039fa:	00 00 00 
  8039fd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a04:	00 00 00 
  803a07:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a0e:	00 00 00 
  803a11:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a18:	00 00 00 
  803a1b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a22:	00 00 00 
  803a25:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a2c:	00 00 00 
  803a2f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a36:	00 00 00 
  803a39:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a40:	00 00 00 
  803a43:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a4a:	00 00 00 
  803a4d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a54:	00 00 00 
  803a57:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a5e:	00 00 00 
  803a61:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a68:	00 00 00 
  803a6b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a72:	00 00 00 
  803a75:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a7c:	00 00 00 
  803a7f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a86:	00 00 00 
  803a89:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a90:	00 00 00 
  803a93:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a9a:	00 00 00 
  803a9d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803aa4:	00 00 00 
  803aa7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803aae:	00 00 00 
  803ab1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ab8:	00 00 00 
  803abb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ac2:	00 00 00 
  803ac5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803acc:	00 00 00 
  803acf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ad6:	00 00 00 
  803ad9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ae0:	00 00 00 
  803ae3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803aea:	00 00 00 
  803aed:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803af4:	00 00 00 
  803af7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803afe:	00 00 00 
  803b01:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b08:	00 00 00 
  803b0b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b12:	00 00 00 
  803b15:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b1c:	00 00 00 
  803b1f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b26:	00 00 00 
  803b29:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b30:	00 00 00 
  803b33:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b3a:	00 00 00 
  803b3d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b44:	00 00 00 
  803b47:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b4e:	00 00 00 
  803b51:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b58:	00 00 00 
  803b5b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b62:	00 00 00 
  803b65:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b6c:	00 00 00 
  803b6f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b76:	00 00 00 
  803b79:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b80:	00 00 00 
  803b83:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b8a:	00 00 00 
  803b8d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b94:	00 00 00 
  803b97:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b9e:	00 00 00 
  803ba1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ba8:	00 00 00 
  803bab:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bb2:	00 00 00 
  803bb5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bbc:	00 00 00 
  803bbf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bc6:	00 00 00 
  803bc9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bd0:	00 00 00 
  803bd3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bda:	00 00 00 
  803bdd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803be4:	00 00 00 
  803be7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bee:	00 00 00 
  803bf1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bf8:	00 00 00 
  803bfb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c02:	00 00 00 
  803c05:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c0c:	00 00 00 
  803c0f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c16:	00 00 00 
  803c19:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c20:	00 00 00 
  803c23:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c2a:	00 00 00 
  803c2d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c34:	00 00 00 
  803c37:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c3e:	00 00 00 
  803c41:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c48:	00 00 00 
  803c4b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c52:	00 00 00 
  803c55:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c5c:	00 00 00 
  803c5f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c66:	00 00 00 
  803c69:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c70:	00 00 00 
  803c73:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c7a:	00 00 00 
  803c7d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c84:	00 00 00 
  803c87:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c8e:	00 00 00 
  803c91:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c98:	00 00 00 
  803c9b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ca2:	00 00 00 
  803ca5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cac:	00 00 00 
  803caf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cb6:	00 00 00 
  803cb9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cc0:	00 00 00 
  803cc3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cca:	00 00 00 
  803ccd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cd4:	00 00 00 
  803cd7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cde:	00 00 00 
  803ce1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ce8:	00 00 00 
  803ceb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cf2:	00 00 00 
  803cf5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cfc:	00 00 00 
  803cff:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d06:	00 00 00 
  803d09:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d10:	00 00 00 
  803d13:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d1a:	00 00 00 
  803d1d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d24:	00 00 00 
  803d27:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d2e:	00 00 00 
  803d31:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d38:	00 00 00 
  803d3b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d42:	00 00 00 
  803d45:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d4c:	00 00 00 
  803d4f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d56:	00 00 00 
  803d59:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d60:	00 00 00 
  803d63:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d6a:	00 00 00 
  803d6d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d74:	00 00 00 
  803d77:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d7e:	00 00 00 
  803d81:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d88:	00 00 00 
  803d8b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d92:	00 00 00 
  803d95:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d9c:	00 00 00 
  803d9f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803da6:	00 00 00 
  803da9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803db0:	00 00 00 
  803db3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dba:	00 00 00 
  803dbd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dc4:	00 00 00 
  803dc7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dce:	00 00 00 
  803dd1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dd8:	00 00 00 
  803ddb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803de2:	00 00 00 
  803de5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dec:	00 00 00 
  803def:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803df6:	00 00 00 
  803df9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e00:	00 00 00 
  803e03:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e0a:	00 00 00 
  803e0d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e14:	00 00 00 
  803e17:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e1e:	00 00 00 
  803e21:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e28:	00 00 00 
  803e2b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e32:	00 00 00 
  803e35:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e3c:	00 00 00 
  803e3f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e46:	00 00 00 
  803e49:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e50:	00 00 00 
  803e53:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e5a:	00 00 00 
  803e5d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e64:	00 00 00 
  803e67:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e6e:	00 00 00 
  803e71:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e78:	00 00 00 
  803e7b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e82:	00 00 00 
  803e85:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e8c:	00 00 00 
  803e8f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e96:	00 00 00 
  803e99:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ea0:	00 00 00 
  803ea3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803eaa:	00 00 00 
  803ead:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803eb4:	00 00 00 
  803eb7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ebe:	00 00 00 
  803ec1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ec8:	00 00 00 
  803ecb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ed2:	00 00 00 
  803ed5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803edc:	00 00 00 
  803edf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ee6:	00 00 00 
  803ee9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ef0:	00 00 00 
  803ef3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803efa:	00 00 00 
  803efd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f04:	00 00 00 
  803f07:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f0e:	00 00 00 
  803f11:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f18:	00 00 00 
  803f1b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f22:	00 00 00 
  803f25:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f2c:	00 00 00 
  803f2f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f36:	00 00 00 
  803f39:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f40:	00 00 00 
  803f43:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f4a:	00 00 00 
  803f4d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f54:	00 00 00 
  803f57:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f5e:	00 00 00 
  803f61:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f68:	00 00 00 
  803f6b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f72:	00 00 00 
  803f75:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f7c:	00 00 00 
  803f7f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f86:	00 00 00 
  803f89:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f90:	00 00 00 
  803f93:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f9a:	00 00 00 
  803f9d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fa4:	00 00 00 
  803fa7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fae:	00 00 00 
  803fb1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fb8:	00 00 00 
  803fbb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fc2:	00 00 00 
  803fc5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fcc:	00 00 00 
  803fcf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fd6:	00 00 00 
  803fd9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fe0:	00 00 00 
  803fe3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fea:	00 00 00 
  803fed:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ff4:	00 00 00 
  803ff7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  803ffe:	00 00 
