
obj/user/pingpongs:     file format elf64-x86-64


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
  80001e:	e8 71 01 00 00       	call   800194 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <umain>:
#include <inc/lib.h>

uint32_t val;

void
umain(int argc, char **argv) {
  800025:	f3 0f 1e fa          	endbr64
  800029:	55                   	push   %rbp
  80002a:	48 89 e5             	mov    %rsp,%rbp
  80002d:	41 57                	push   %r15
  80002f:	41 56                	push   %r14
  800031:	41 55                	push   %r13
  800033:	41 54                	push   %r12
  800035:	53                   	push   %rbx
  800036:	48 83 ec 18          	sub    $0x18,%rsp
    envid_t who;

    if ((who = sfork()) != 0) {
  80003a:	48 b8 5e 17 80 00 00 	movabs $0x80175e,%rax
  800041:	00 00 00 
  800044:	ff d0                	call   *%rax
  800046:	89 45 cc             	mov    %eax,-0x34(%rbp)
  800049:	85 c0                	test   %eax,%eax
  80004b:	0f 85 c3 00 00 00    	jne    800114 <umain+0xef>
        ipc_send(who, 0, 0, 0, 0);
    }

    while (1) {
        ipc_recv(&who, 0, 0, 0);
        cprintf("%x got %d from %x (thisenv is %p %x)\n", sys_getenvid(), val, who, thisenv, thisenv->env_id);
  800051:	48 bb 00 60 80 00 00 	movabs $0x806000,%rbx
  800058:	00 00 00 
        ipc_recv(&who, 0, 0, 0);
  80005b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800060:	ba 00 00 00 00       	mov    $0x0,%edx
  800065:	be 00 00 00 00       	mov    $0x0,%esi
  80006a:	48 8d 7d cc          	lea    -0x34(%rbp),%rdi
  80006e:	48 b8 90 17 80 00 00 	movabs $0x801790,%rax
  800075:	00 00 00 
  800078:	ff d0                	call   *%rax
        cprintf("%x got %d from %x (thisenv is %p %x)\n", sys_getenvid(), val, who, thisenv, thisenv->env_id);
  80007a:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800081:	00 00 00 
  800084:	4c 8b 20             	mov    (%rax),%r12
  800087:	45 8b bc 24 c8 00 00 	mov    0xc8(%r12),%r15d
  80008e:	00 
  80008f:	44 8b 75 cc          	mov    -0x34(%rbp),%r14d
  800093:	44 8b 2b             	mov    (%rbx),%r13d
  800096:	48 b8 a0 11 80 00 00 	movabs $0x8011a0,%rax
  80009d:	00 00 00 
  8000a0:	ff d0                	call   *%rax
  8000a2:	89 c6                	mov    %eax,%esi
  8000a4:	45 89 f9             	mov    %r15d,%r9d
  8000a7:	4d 89 e0             	mov    %r12,%r8
  8000aa:	44 89 f1             	mov    %r14d,%ecx
  8000ad:	44 89 ea             	mov    %r13d,%edx
  8000b0:	48 bf f0 42 80 00 00 	movabs $0x8042f0,%rdi
  8000b7:	00 00 00 
  8000ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8000bf:	49 ba 22 03 80 00 00 	movabs $0x800322,%r10
  8000c6:	00 00 00 
  8000c9:	41 ff d2             	call   *%r10
        if (val == 10) return;
  8000cc:	8b 03                	mov    (%rbx),%eax
  8000ce:	83 f8 0a             	cmp    $0xa,%eax
  8000d1:	74 32                	je     800105 <umain+0xe0>
        ++val;
  8000d3:	83 c0 01             	add    $0x1,%eax
  8000d6:	89 03                	mov    %eax,(%rbx)
        ipc_send(who, 0, 0, 0, 0);
  8000d8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8000de:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8000e8:	be 00 00 00 00       	mov    $0x0,%esi
  8000ed:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8000f0:	48 b8 29 18 80 00 00 	movabs $0x801829,%rax
  8000f7:	00 00 00 
  8000fa:	ff d0                	call   *%rax
        if (val == 10) return;
  8000fc:	83 3b 0a             	cmpl   $0xa,(%rbx)
  8000ff:	0f 85 56 ff ff ff    	jne    80005b <umain+0x36>
    }
}
  800105:	48 83 c4 18          	add    $0x18,%rsp
  800109:	5b                   	pop    %rbx
  80010a:	41 5c                	pop    %r12
  80010c:	41 5d                	pop    %r13
  80010e:	41 5e                	pop    %r14
  800110:	41 5f                	pop    %r15
  800112:	5d                   	pop    %rbp
  800113:	c3                   	ret
        cprintf("i am %08x; thisenv is %p\n", sys_getenvid(), thisenv);
  800114:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80011b:	00 00 00 
  80011e:	48 8b 18             	mov    (%rax),%rbx
  800121:	49 bc a0 11 80 00 00 	movabs $0x8011a0,%r12
  800128:	00 00 00 
  80012b:	41 ff d4             	call   *%r12
  80012e:	89 c6                	mov    %eax,%esi
  800130:	48 89 da             	mov    %rbx,%rdx
  800133:	48 bf 00 40 80 00 00 	movabs $0x804000,%rdi
  80013a:	00 00 00 
  80013d:	b8 00 00 00 00       	mov    $0x0,%eax
  800142:	48 bb 22 03 80 00 00 	movabs $0x800322,%rbx
  800149:	00 00 00 
  80014c:	ff d3                	call   *%rbx
        cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  80014e:	44 8b 6d cc          	mov    -0x34(%rbp),%r13d
  800152:	41 ff d4             	call   *%r12
  800155:	89 c6                	mov    %eax,%esi
  800157:	44 89 ea             	mov    %r13d,%edx
  80015a:	48 bf 1a 40 80 00 00 	movabs $0x80401a,%rdi
  800161:	00 00 00 
  800164:	b8 00 00 00 00       	mov    $0x0,%eax
  800169:	ff d3                	call   *%rbx
        ipc_send(who, 0, 0, 0, 0);
  80016b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800171:	b9 00 00 00 00       	mov    $0x0,%ecx
  800176:	ba 00 00 00 00       	mov    $0x0,%edx
  80017b:	be 00 00 00 00       	mov    $0x0,%esi
  800180:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800183:	48 b8 29 18 80 00 00 	movabs $0x801829,%rax
  80018a:	00 00 00 
  80018d:	ff d0                	call   *%rax
  80018f:	e9 bd fe ff ff       	jmp    800051 <umain+0x2c>

0000000000800194 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  800194:	f3 0f 1e fa          	endbr64
  800198:	55                   	push   %rbp
  800199:	48 89 e5             	mov    %rsp,%rbp
  80019c:	41 56                	push   %r14
  80019e:	41 55                	push   %r13
  8001a0:	41 54                	push   %r12
  8001a2:	53                   	push   %rbx
  8001a3:	41 89 fd             	mov    %edi,%r13d
  8001a6:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
     * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  8001a9:	48 ba d8 50 80 00 00 	movabs $0x8050d8,%rdx
  8001b0:	00 00 00 
  8001b3:	48 b8 d8 50 80 00 00 	movabs $0x8050d8,%rax
  8001ba:	00 00 00 
  8001bd:	48 39 c2             	cmp    %rax,%rdx
  8001c0:	73 17                	jae    8001d9 <libmain+0x45>
    void (**ctor)() = &__ctors_start;
  8001c2:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  8001c5:	49 89 c4             	mov    %rax,%r12
  8001c8:	48 83 c3 08          	add    $0x8,%rbx
  8001cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8001d1:	ff 53 f8             	call   *-0x8(%rbx)
  8001d4:	4c 39 e3             	cmp    %r12,%rbx
  8001d7:	72 ef                	jb     8001c8 <libmain+0x34>

    /* Set thisenv to point at our Env structure in envs[]. */

    // LAB 8: Your code here
    thisenv = &((struct Env *)UENVS)[ENVX(sys_getenvid())];
  8001d9:	48 b8 a0 11 80 00 00 	movabs $0x8011a0,%rax
  8001e0:	00 00 00 
  8001e3:	ff d0                	call   *%rax
  8001e5:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001ea:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8001ee:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8001f2:	48 c1 e0 04          	shl    $0x4,%rax
  8001f6:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  8001fd:	00 00 00 
  800200:	48 01 d0             	add    %rdx,%rax
  800203:	48 a3 08 60 80 00 00 	movabs %rax,0x806008
  80020a:	00 00 00 

    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  80020d:	45 85 ed             	test   %r13d,%r13d
  800210:	7e 0d                	jle    80021f <libmain+0x8b>
  800212:	49 8b 06             	mov    (%r14),%rax
  800215:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  80021c:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  80021f:	4c 89 f6             	mov    %r14,%rsi
  800222:	44 89 ef             	mov    %r13d,%edi
  800225:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  80022c:	00 00 00 
  80022f:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  800231:	48 b8 46 02 80 00 00 	movabs $0x800246,%rax
  800238:	00 00 00 
  80023b:	ff d0                	call   *%rax
#endif
}
  80023d:	5b                   	pop    %rbx
  80023e:	41 5c                	pop    %r12
  800240:	41 5d                	pop    %r13
  800242:	41 5e                	pop    %r14
  800244:	5d                   	pop    %rbp
  800245:	c3                   	ret

0000000000800246 <exit>:

#include <inc/lib.h>

void
exit(void) {
  800246:	f3 0f 1e fa          	endbr64
  80024a:	55                   	push   %rbp
  80024b:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  80024e:	48 b8 8b 1b 80 00 00 	movabs $0x801b8b,%rax
  800255:	00 00 00 
  800258:	ff d0                	call   *%rax
    sys_env_destroy(0);
  80025a:	bf 00 00 00 00       	mov    $0x0,%edi
  80025f:	48 b8 31 11 80 00 00 	movabs $0x801131,%rax
  800266:	00 00 00 
  800269:	ff d0                	call   *%rax
}
  80026b:	5d                   	pop    %rbp
  80026c:	c3                   	ret

000000000080026d <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  80026d:	f3 0f 1e fa          	endbr64
  800271:	55                   	push   %rbp
  800272:	48 89 e5             	mov    %rsp,%rbp
  800275:	53                   	push   %rbx
  800276:	48 83 ec 08          	sub    $0x8,%rsp
  80027a:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  80027d:	8b 06                	mov    (%rsi),%eax
  80027f:	8d 50 01             	lea    0x1(%rax),%edx
  800282:	89 16                	mov    %edx,(%rsi)
  800284:	48 98                	cltq
  800286:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  80028b:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  800291:	74 0a                	je     80029d <putch+0x30>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  800293:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  800297:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80029b:	c9                   	leave
  80029c:	c3                   	ret
        sys_cputs(state->buf, state->offset);
  80029d:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  8002a1:	be ff 00 00 00       	mov    $0xff,%esi
  8002a6:	48 b8 cb 10 80 00 00 	movabs $0x8010cb,%rax
  8002ad:	00 00 00 
  8002b0:	ff d0                	call   *%rax
        state->offset = 0;
  8002b2:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  8002b8:	eb d9                	jmp    800293 <putch+0x26>

00000000008002ba <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  8002ba:	f3 0f 1e fa          	endbr64
  8002be:	55                   	push   %rbp
  8002bf:	48 89 e5             	mov    %rsp,%rbp
  8002c2:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8002c9:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  8002cc:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  8002d3:	b9 21 00 00 00       	mov    $0x21,%ecx
  8002d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8002dd:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  8002e0:	48 89 f1             	mov    %rsi,%rcx
  8002e3:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  8002ea:	48 bf 6d 02 80 00 00 	movabs $0x80026d,%rdi
  8002f1:	00 00 00 
  8002f4:	48 b8 82 04 80 00 00 	movabs $0x800482,%rax
  8002fb:	00 00 00 
  8002fe:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  800300:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  800307:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  80030e:	48 b8 cb 10 80 00 00 	movabs $0x8010cb,%rax
  800315:	00 00 00 
  800318:	ff d0                	call   *%rax

    return state.count;
}
  80031a:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  800320:	c9                   	leave
  800321:	c3                   	ret

0000000000800322 <cprintf>:

int
cprintf(const char *fmt, ...) {
  800322:	f3 0f 1e fa          	endbr64
  800326:	55                   	push   %rbp
  800327:	48 89 e5             	mov    %rsp,%rbp
  80032a:	48 83 ec 50          	sub    $0x50,%rsp
  80032e:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  800332:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  800336:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80033a:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  80033e:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  800342:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  800349:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80034d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800351:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800355:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  800359:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  80035d:	48 b8 ba 02 80 00 00 	movabs $0x8002ba,%rax
  800364:	00 00 00 
  800367:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  800369:	c9                   	leave
  80036a:	c3                   	ret

000000000080036b <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  80036b:	f3 0f 1e fa          	endbr64
  80036f:	55                   	push   %rbp
  800370:	48 89 e5             	mov    %rsp,%rbp
  800373:	41 57                	push   %r15
  800375:	41 56                	push   %r14
  800377:	41 55                	push   %r13
  800379:	41 54                	push   %r12
  80037b:	53                   	push   %rbx
  80037c:	48 83 ec 18          	sub    $0x18,%rsp
  800380:	49 89 fc             	mov    %rdi,%r12
  800383:	49 89 f5             	mov    %rsi,%r13
  800386:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  80038a:	8b 45 10             	mov    0x10(%rbp),%eax
  80038d:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  800390:	41 89 cf             	mov    %ecx,%r15d
  800393:	4c 39 fa             	cmp    %r15,%rdx
  800396:	73 5b                	jae    8003f3 <print_num+0x88>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  800398:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  80039c:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  8003a0:	85 db                	test   %ebx,%ebx
  8003a2:	7e 0e                	jle    8003b2 <print_num+0x47>
            putch(padc, put_arg);
  8003a4:	4c 89 ee             	mov    %r13,%rsi
  8003a7:	44 89 f7             	mov    %r14d,%edi
  8003aa:	41 ff d4             	call   *%r12
        while (--width > 0) {
  8003ad:	83 eb 01             	sub    $0x1,%ebx
  8003b0:	75 f2                	jne    8003a4 <print_num+0x39>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  8003b2:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  8003b6:	48 b9 4b 40 80 00 00 	movabs $0x80404b,%rcx
  8003bd:	00 00 00 
  8003c0:	48 b8 3a 40 80 00 00 	movabs $0x80403a,%rax
  8003c7:	00 00 00 
  8003ca:	48 0f 45 c8          	cmovne %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  8003ce:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8003d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8003d7:	49 f7 f7             	div    %r15
  8003da:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  8003de:	4c 89 ee             	mov    %r13,%rsi
  8003e1:	41 ff d4             	call   *%r12
}
  8003e4:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  8003e8:	5b                   	pop    %rbx
  8003e9:	41 5c                	pop    %r12
  8003eb:	41 5d                	pop    %r13
  8003ed:	41 5e                	pop    %r14
  8003ef:	41 5f                	pop    %r15
  8003f1:	5d                   	pop    %rbp
  8003f2:	c3                   	ret
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  8003f3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8003f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8003fc:	49 f7 f7             	div    %r15
  8003ff:	48 83 ec 08          	sub    $0x8,%rsp
  800403:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  800407:	52                   	push   %rdx
  800408:	45 0f be c9          	movsbl %r9b,%r9d
  80040c:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  800410:	48 89 c2             	mov    %rax,%rdx
  800413:	48 b8 6b 03 80 00 00 	movabs $0x80036b,%rax
  80041a:	00 00 00 
  80041d:	ff d0                	call   *%rax
  80041f:	48 83 c4 10          	add    $0x10,%rsp
  800423:	eb 8d                	jmp    8003b2 <print_num+0x47>

0000000000800425 <sprintputch>:
    char *end;
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
  800425:	f3 0f 1e fa          	endbr64
    state->count++;
  800429:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  80042d:	48 8b 06             	mov    (%rsi),%rax
  800430:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  800434:	73 0a                	jae    800440 <sprintputch+0x1b>
        *state->start++ = ch;
  800436:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80043a:	48 89 16             	mov    %rdx,(%rsi)
  80043d:	40 88 38             	mov    %dil,(%rax)
    }
}
  800440:	c3                   	ret

0000000000800441 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  800441:	f3 0f 1e fa          	endbr64
  800445:	55                   	push   %rbp
  800446:	48 89 e5             	mov    %rsp,%rbp
  800449:	48 83 ec 50          	sub    $0x50,%rsp
  80044d:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800451:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800455:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  800459:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800460:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800464:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800468:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80046c:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  800470:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800474:	48 b8 82 04 80 00 00 	movabs $0x800482,%rax
  80047b:	00 00 00 
  80047e:	ff d0                	call   *%rax
}
  800480:	c9                   	leave
  800481:	c3                   	ret

0000000000800482 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  800482:	f3 0f 1e fa          	endbr64
  800486:	55                   	push   %rbp
  800487:	48 89 e5             	mov    %rsp,%rbp
  80048a:	41 57                	push   %r15
  80048c:	41 56                	push   %r14
  80048e:	41 55                	push   %r13
  800490:	41 54                	push   %r12
  800492:	53                   	push   %rbx
  800493:	48 83 ec 38          	sub    $0x38,%rsp
  800497:	49 89 fe             	mov    %rdi,%r14
  80049a:	49 89 f5             	mov    %rsi,%r13
  80049d:	48 89 d3             	mov    %rdx,%rbx
    va_copy(aq, ap);
  8004a0:	48 8b 01             	mov    (%rcx),%rax
  8004a3:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  8004a7:	48 8b 41 08          	mov    0x8(%rcx),%rax
  8004ab:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8004af:	48 8b 41 10          	mov    0x10(%rcx),%rax
  8004b3:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  8004b7:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  8004bb:	0f b6 3b             	movzbl (%rbx),%edi
  8004be:	40 80 ff 25          	cmp    $0x25,%dil
  8004c2:	74 18                	je     8004dc <vprintfmt+0x5a>
            if (!ch) return;
  8004c4:	40 84 ff             	test   %dil,%dil
  8004c7:	0f 84 b2 06 00 00    	je     800b7f <vprintfmt+0x6fd>
            putch(ch, put_arg);
  8004cd:	40 0f b6 ff          	movzbl %dil,%edi
  8004d1:	4c 89 ee             	mov    %r13,%rsi
  8004d4:	41 ff d6             	call   *%r14
        while ((ch = *ufmt++) != '%') {
  8004d7:	4c 89 e3             	mov    %r12,%rbx
  8004da:	eb db                	jmp    8004b7 <vprintfmt+0x35>
        bool altflag = 0, zflag = 0;
  8004dc:	be 00 00 00 00       	mov    $0x0,%esi
  8004e1:	c6 45 ab 00          	movb   $0x0,-0x55(%rbp)
        unsigned lflag = 0, base = 10;
  8004e5:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  8004ea:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  8004f0:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  8004f7:	c6 45 aa 20          	movb   $0x20,-0x56(%rbp)
        switch (ch = *ufmt++) {
  8004fb:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  800500:	41 0f b6 04 24       	movzbl (%r12),%eax
  800505:	88 45 a0             	mov    %al,-0x60(%rbp)
  800508:	83 e8 23             	sub    $0x23,%eax
  80050b:	3c 57                	cmp    $0x57,%al
  80050d:	0f 87 52 06 00 00    	ja     800b65 <vprintfmt+0x6e3>
  800513:	0f b6 c0             	movzbl %al,%eax
  800516:	48 b9 20 44 80 00 00 	movabs $0x804420,%rcx
  80051d:	00 00 00 
  800520:	3e ff 24 c1          	notrack jmp *(%rcx,%rax,8)
  800524:	49 89 dc             	mov    %rbx,%r12
            altflag = 1;
  800527:	c6 45 ab 01          	movb   $0x1,-0x55(%rbp)
  80052b:	eb ce                	jmp    8004fb <vprintfmt+0x79>
        switch (ch = *ufmt++) {
  80052d:	49 89 dc             	mov    %rbx,%r12
  800530:	be 01 00 00 00       	mov    $0x1,%esi
  800535:	eb c4                	jmp    8004fb <vprintfmt+0x79>
            padc = ch;
  800537:	0f b6 45 a0          	movzbl -0x60(%rbp),%eax
  80053b:	88 45 aa             	mov    %al,-0x56(%rbp)
        switch (ch = *ufmt++) {
  80053e:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  800541:	eb b8                	jmp    8004fb <vprintfmt+0x79>
            precision = va_arg(aq, int);
  800543:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800546:	83 f8 2f             	cmp    $0x2f,%eax
  800549:	77 24                	ja     80056f <vprintfmt+0xed>
  80054b:	89 c1                	mov    %eax,%ecx
  80054d:	48 03 4d c8          	add    -0x38(%rbp),%rcx
  800551:	83 c0 08             	add    $0x8,%eax
  800554:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800557:	44 8b 39             	mov    (%rcx),%r15d
        switch (ch = *ufmt++) {
  80055a:	49 89 dc             	mov    %rbx,%r12
            if (width < 0) {
  80055d:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800561:	79 98                	jns    8004fb <vprintfmt+0x79>
                width = precision;
  800563:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
                precision = -1;
  800567:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  80056d:	eb 8c                	jmp    8004fb <vprintfmt+0x79>
            precision = va_arg(aq, int);
  80056f:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  800573:	48 8d 41 08          	lea    0x8(%rcx),%rax
  800577:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80057b:	eb da                	jmp    800557 <vprintfmt+0xd5>
                precision = precision * 10 + ch - '0';
  80057d:	44 0f b6 7d a0       	movzbl -0x60(%rbp),%r15d
  800582:	41 83 ef 30          	sub    $0x30,%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  800586:	41 0f b6 44 24 01    	movzbl 0x1(%r12),%eax
  80058c:	3c 39                	cmp    $0x39,%al
  80058e:	77 1c                	ja     8005ac <vprintfmt+0x12a>
            for (precision = 0;; ++ufmt) {
  800590:	48 83 c3 01          	add    $0x1,%rbx
                precision = precision * 10 + ch - '0';
  800594:	43 8d 0c bf          	lea    (%r15,%r15,4),%ecx
  800598:	0f b6 c0             	movzbl %al,%eax
  80059b:	44 8d 7c 48 d0       	lea    -0x30(%rax,%rcx,2),%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  8005a0:	0f b6 03             	movzbl (%rbx),%eax
  8005a3:	3c 39                	cmp    $0x39,%al
  8005a5:	76 e9                	jbe    800590 <vprintfmt+0x10e>
        process_precision:
  8005a7:	49 89 dc             	mov    %rbx,%r12
  8005aa:	eb b1                	jmp    80055d <vprintfmt+0xdb>
        switch (ch = *ufmt++) {
  8005ac:	49 89 dc             	mov    %rbx,%r12
  8005af:	eb ac                	jmp    80055d <vprintfmt+0xdb>
            width = MAX(0, width);
  8005b1:	8b 4d ac             	mov    -0x54(%rbp),%ecx
  8005b4:	85 c9                	test   %ecx,%ecx
  8005b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8005bb:	0f 49 c1             	cmovns %ecx,%eax
  8005be:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  8005c1:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  8005c4:	e9 32 ff ff ff       	jmp    8004fb <vprintfmt+0x79>
            lflag++;
  8005c9:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  8005cc:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  8005cf:	e9 27 ff ff ff       	jmp    8004fb <vprintfmt+0x79>
            putch(va_arg(aq, int), put_arg);
  8005d4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8005d7:	83 f8 2f             	cmp    $0x2f,%eax
  8005da:	77 19                	ja     8005f5 <vprintfmt+0x173>
  8005dc:	89 c2                	mov    %eax,%edx
  8005de:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8005e2:	83 c0 08             	add    $0x8,%eax
  8005e5:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8005e8:	8b 3a                	mov    (%rdx),%edi
  8005ea:	4c 89 ee             	mov    %r13,%rsi
  8005ed:	41 ff d6             	call   *%r14
            break;
  8005f0:	e9 c2 fe ff ff       	jmp    8004b7 <vprintfmt+0x35>
            putch(va_arg(aq, int), put_arg);
  8005f5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8005f9:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8005fd:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800601:	eb e5                	jmp    8005e8 <vprintfmt+0x166>
            int err = va_arg(aq, int);
  800603:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800606:	83 f8 2f             	cmp    $0x2f,%eax
  800609:	77 5a                	ja     800665 <vprintfmt+0x1e3>
  80060b:	89 c2                	mov    %eax,%edx
  80060d:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800611:	83 c0 08             	add    $0x8,%eax
  800614:	89 45 b8             	mov    %eax,-0x48(%rbp)
            if (err < 0) err = -err;
  800617:	8b 02                	mov    (%rdx),%eax
  800619:	89 c1                	mov    %eax,%ecx
  80061b:	f7 d9                	neg    %ecx
  80061d:	0f 48 c8             	cmovs  %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  800620:	83 f9 13             	cmp    $0x13,%ecx
  800623:	7f 4e                	jg     800673 <vprintfmt+0x1f1>
  800625:	48 63 c1             	movslq %ecx,%rax
  800628:	48 ba e0 46 80 00 00 	movabs $0x8046e0,%rdx
  80062f:	00 00 00 
  800632:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  800636:	48 85 c0             	test   %rax,%rax
  800639:	74 38                	je     800673 <vprintfmt+0x1f1>
                printfmt(putch, put_arg, "%s", strerr);
  80063b:	48 89 c1             	mov    %rax,%rcx
  80063e:	48 ba 7a 42 80 00 00 	movabs $0x80427a,%rdx
  800645:	00 00 00 
  800648:	4c 89 ee             	mov    %r13,%rsi
  80064b:	4c 89 f7             	mov    %r14,%rdi
  80064e:	b8 00 00 00 00       	mov    $0x0,%eax
  800653:	49 b8 41 04 80 00 00 	movabs $0x800441,%r8
  80065a:	00 00 00 
  80065d:	41 ff d0             	call   *%r8
  800660:	e9 52 fe ff ff       	jmp    8004b7 <vprintfmt+0x35>
            int err = va_arg(aq, int);
  800665:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800669:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80066d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800671:	eb a4                	jmp    800617 <vprintfmt+0x195>
                printfmt(putch, put_arg, "error %d", err);
  800673:	48 ba 63 40 80 00 00 	movabs $0x804063,%rdx
  80067a:	00 00 00 
  80067d:	4c 89 ee             	mov    %r13,%rsi
  800680:	4c 89 f7             	mov    %r14,%rdi
  800683:	b8 00 00 00 00       	mov    $0x0,%eax
  800688:	49 b8 41 04 80 00 00 	movabs $0x800441,%r8
  80068f:	00 00 00 
  800692:	41 ff d0             	call   *%r8
  800695:	e9 1d fe ff ff       	jmp    8004b7 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  80069a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80069d:	83 f8 2f             	cmp    $0x2f,%eax
  8006a0:	77 6c                	ja     80070e <vprintfmt+0x28c>
  8006a2:	89 c2                	mov    %eax,%edx
  8006a4:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8006a8:	83 c0 08             	add    $0x8,%eax
  8006ab:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8006ae:	48 8b 12             	mov    (%rdx),%rdx
            if (!ptr) ptr = "(null)";
  8006b1:	48 85 d2             	test   %rdx,%rdx
  8006b4:	48 b8 5c 40 80 00 00 	movabs $0x80405c,%rax
  8006bb:	00 00 00 
  8006be:	48 0f 45 c2          	cmovne %rdx,%rax
  8006c2:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
            if (width > 0 && padc != '-') {
  8006c6:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8006ca:	7e 06                	jle    8006d2 <vprintfmt+0x250>
  8006cc:	80 7d aa 2d          	cmpb   $0x2d,-0x56(%rbp)
  8006d0:	75 4a                	jne    80071c <vprintfmt+0x29a>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  8006d2:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8006d6:	4c 8d 60 01          	lea    0x1(%rax),%r12
  8006da:	0f b6 00             	movzbl (%rax),%eax
  8006dd:	84 c0                	test   %al,%al
  8006df:	0f 85 9a 00 00 00    	jne    80077f <vprintfmt+0x2fd>
            while (width-- > 0) putch(' ', put_arg);
  8006e5:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8006e8:	44 8d 60 ff          	lea    -0x1(%rax),%r12d
  8006ec:	85 c0                	test   %eax,%eax
  8006ee:	0f 8e c3 fd ff ff    	jle    8004b7 <vprintfmt+0x35>
  8006f4:	4c 89 ee             	mov    %r13,%rsi
  8006f7:	bf 20 00 00 00       	mov    $0x20,%edi
  8006fc:	41 ff d6             	call   *%r14
  8006ff:	41 83 ec 01          	sub    $0x1,%r12d
  800703:	41 83 fc ff          	cmp    $0xffffffff,%r12d
  800707:	75 eb                	jne    8006f4 <vprintfmt+0x272>
  800709:	e9 a9 fd ff ff       	jmp    8004b7 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  80070e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800712:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800716:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80071a:	eb 92                	jmp    8006ae <vprintfmt+0x22c>
                width -= strnlen(ptr, precision);
  80071c:	49 63 f7             	movslq %r15d,%rsi
  80071f:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  800723:	48 b8 45 0c 80 00 00 	movabs $0x800c45,%rax
  80072a:	00 00 00 
  80072d:	ff d0                	call   *%rax
  80072f:	48 89 c2             	mov    %rax,%rdx
  800732:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800735:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  800737:	8d 70 ff             	lea    -0x1(%rax),%esi
  80073a:	89 75 ac             	mov    %esi,-0x54(%rbp)
  80073d:	85 c0                	test   %eax,%eax
  80073f:	7e 91                	jle    8006d2 <vprintfmt+0x250>
  800741:	44 0f be 65 aa       	movsbl -0x56(%rbp),%r12d
  800746:	4c 89 ee             	mov    %r13,%rsi
  800749:	44 89 e7             	mov    %r12d,%edi
  80074c:	41 ff d6             	call   *%r14
  80074f:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  800753:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800756:	83 f8 ff             	cmp    $0xffffffff,%eax
  800759:	75 eb                	jne    800746 <vprintfmt+0x2c4>
  80075b:	e9 72 ff ff ff       	jmp    8006d2 <vprintfmt+0x250>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800760:	0f b6 f8             	movzbl %al,%edi
  800763:	4c 89 ee             	mov    %r13,%rsi
  800766:	41 ff d6             	call   *%r14
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800769:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  80076d:	49 83 c4 01          	add    $0x1,%r12
  800771:	41 0f b6 44 24 ff    	movzbl -0x1(%r12),%eax
  800777:	84 c0                	test   %al,%al
  800779:	0f 84 66 ff ff ff    	je     8006e5 <vprintfmt+0x263>
  80077f:	45 85 ff             	test   %r15d,%r15d
  800782:	78 0a                	js     80078e <vprintfmt+0x30c>
  800784:	41 83 ef 01          	sub    $0x1,%r15d
  800788:	0f 88 57 ff ff ff    	js     8006e5 <vprintfmt+0x263>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  80078e:	80 7d ab 00          	cmpb   $0x0,-0x55(%rbp)
  800792:	74 cc                	je     800760 <vprintfmt+0x2de>
  800794:	8d 50 e0             	lea    -0x20(%rax),%edx
  800797:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80079c:	80 fa 5e             	cmp    $0x5e,%dl
  80079f:	77 c2                	ja     800763 <vprintfmt+0x2e1>
  8007a1:	eb bd                	jmp    800760 <vprintfmt+0x2de>
    if (zflag) return va_arg(*ap, size_t);
  8007a3:	40 84 f6             	test   %sil,%sil
  8007a6:	75 26                	jne    8007ce <vprintfmt+0x34c>
    switch (lflag) {
  8007a8:	85 d2                	test   %edx,%edx
  8007aa:	74 59                	je     800805 <vprintfmt+0x383>
  8007ac:	83 fa 01             	cmp    $0x1,%edx
  8007af:	74 7b                	je     80082c <vprintfmt+0x3aa>
        return va_arg(*ap, long long);
  8007b1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007b4:	83 f8 2f             	cmp    $0x2f,%eax
  8007b7:	0f 87 96 00 00 00    	ja     800853 <vprintfmt+0x3d1>
  8007bd:	89 c2                	mov    %eax,%edx
  8007bf:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8007c3:	83 c0 08             	add    $0x8,%eax
  8007c6:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007c9:	4c 8b 22             	mov    (%rdx),%r12
  8007cc:	eb 17                	jmp    8007e5 <vprintfmt+0x363>
    if (zflag) return va_arg(*ap, size_t);
  8007ce:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007d1:	83 f8 2f             	cmp    $0x2f,%eax
  8007d4:	77 21                	ja     8007f7 <vprintfmt+0x375>
  8007d6:	89 c2                	mov    %eax,%edx
  8007d8:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8007dc:	83 c0 08             	add    $0x8,%eax
  8007df:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007e2:	4c 8b 22             	mov    (%rdx),%r12
            if (i < 0) {
  8007e5:	4d 85 e4             	test   %r12,%r12
  8007e8:	78 7a                	js     800864 <vprintfmt+0x3e2>
            num = i;
  8007ea:	4c 89 e2             	mov    %r12,%rdx
        unsigned lflag = 0, base = 10;
  8007ed:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  8007f2:	e9 50 02 00 00       	jmp    800a47 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8007f7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007fb:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8007ff:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800803:	eb dd                	jmp    8007e2 <vprintfmt+0x360>
        return va_arg(*ap, int);
  800805:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800808:	83 f8 2f             	cmp    $0x2f,%eax
  80080b:	77 11                	ja     80081e <vprintfmt+0x39c>
  80080d:	89 c2                	mov    %eax,%edx
  80080f:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800813:	83 c0 08             	add    $0x8,%eax
  800816:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800819:	4c 63 22             	movslq (%rdx),%r12
  80081c:	eb c7                	jmp    8007e5 <vprintfmt+0x363>
  80081e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800822:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800826:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80082a:	eb ed                	jmp    800819 <vprintfmt+0x397>
        return va_arg(*ap, long);
  80082c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80082f:	83 f8 2f             	cmp    $0x2f,%eax
  800832:	77 11                	ja     800845 <vprintfmt+0x3c3>
  800834:	89 c2                	mov    %eax,%edx
  800836:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80083a:	83 c0 08             	add    $0x8,%eax
  80083d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800840:	4c 8b 22             	mov    (%rdx),%r12
  800843:	eb a0                	jmp    8007e5 <vprintfmt+0x363>
  800845:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800849:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80084d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800851:	eb ed                	jmp    800840 <vprintfmt+0x3be>
        return va_arg(*ap, long long);
  800853:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800857:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80085b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80085f:	e9 65 ff ff ff       	jmp    8007c9 <vprintfmt+0x347>
                putch('-', put_arg);
  800864:	4c 89 ee             	mov    %r13,%rsi
  800867:	bf 2d 00 00 00       	mov    $0x2d,%edi
  80086c:	41 ff d6             	call   *%r14
                i = -i;
  80086f:	49 f7 dc             	neg    %r12
  800872:	e9 73 ff ff ff       	jmp    8007ea <vprintfmt+0x368>
    if (zflag) return va_arg(*ap, size_t);
  800877:	40 84 f6             	test   %sil,%sil
  80087a:	75 32                	jne    8008ae <vprintfmt+0x42c>
    switch (lflag) {
  80087c:	85 d2                	test   %edx,%edx
  80087e:	74 5d                	je     8008dd <vprintfmt+0x45b>
  800880:	83 fa 01             	cmp    $0x1,%edx
  800883:	0f 84 82 00 00 00    	je     80090b <vprintfmt+0x489>
        return va_arg(*ap, unsigned long long);
  800889:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80088c:	83 f8 2f             	cmp    $0x2f,%eax
  80088f:	0f 87 a5 00 00 00    	ja     80093a <vprintfmt+0x4b8>
  800895:	89 c2                	mov    %eax,%edx
  800897:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80089b:	83 c0 08             	add    $0x8,%eax
  80089e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008a1:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  8008a4:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  8008a9:	e9 99 01 00 00       	jmp    800a47 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8008ae:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008b1:	83 f8 2f             	cmp    $0x2f,%eax
  8008b4:	77 19                	ja     8008cf <vprintfmt+0x44d>
  8008b6:	89 c2                	mov    %eax,%edx
  8008b8:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8008bc:	83 c0 08             	add    $0x8,%eax
  8008bf:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008c2:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  8008c5:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8008ca:	e9 78 01 00 00       	jmp    800a47 <vprintfmt+0x5c5>
  8008cf:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008d3:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8008d7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008db:	eb e5                	jmp    8008c2 <vprintfmt+0x440>
        return va_arg(*ap, unsigned int);
  8008dd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008e0:	83 f8 2f             	cmp    $0x2f,%eax
  8008e3:	77 18                	ja     8008fd <vprintfmt+0x47b>
  8008e5:	89 c2                	mov    %eax,%edx
  8008e7:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8008eb:	83 c0 08             	add    $0x8,%eax
  8008ee:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008f1:	8b 12                	mov    (%rdx),%edx
        unsigned lflag = 0, base = 10;
  8008f3:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  8008f8:	e9 4a 01 00 00       	jmp    800a47 <vprintfmt+0x5c5>
  8008fd:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800901:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800905:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800909:	eb e6                	jmp    8008f1 <vprintfmt+0x46f>
        return va_arg(*ap, unsigned long);
  80090b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80090e:	83 f8 2f             	cmp    $0x2f,%eax
  800911:	77 19                	ja     80092c <vprintfmt+0x4aa>
  800913:	89 c2                	mov    %eax,%edx
  800915:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800919:	83 c0 08             	add    $0x8,%eax
  80091c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80091f:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800922:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  800927:	e9 1b 01 00 00       	jmp    800a47 <vprintfmt+0x5c5>
  80092c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800930:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800934:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800938:	eb e5                	jmp    80091f <vprintfmt+0x49d>
        return va_arg(*ap, unsigned long long);
  80093a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80093e:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800942:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800946:	e9 56 ff ff ff       	jmp    8008a1 <vprintfmt+0x41f>
    if (zflag) return va_arg(*ap, size_t);
  80094b:	40 84 f6             	test   %sil,%sil
  80094e:	75 2e                	jne    80097e <vprintfmt+0x4fc>
    switch (lflag) {
  800950:	85 d2                	test   %edx,%edx
  800952:	74 59                	je     8009ad <vprintfmt+0x52b>
  800954:	83 fa 01             	cmp    $0x1,%edx
  800957:	74 7f                	je     8009d8 <vprintfmt+0x556>
        return va_arg(*ap, unsigned long long);
  800959:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80095c:	83 f8 2f             	cmp    $0x2f,%eax
  80095f:	0f 87 9f 00 00 00    	ja     800a04 <vprintfmt+0x582>
  800965:	89 c2                	mov    %eax,%edx
  800967:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80096b:	83 c0 08             	add    $0x8,%eax
  80096e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800971:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800974:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  800979:	e9 c9 00 00 00       	jmp    800a47 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  80097e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800981:	83 f8 2f             	cmp    $0x2f,%eax
  800984:	77 19                	ja     80099f <vprintfmt+0x51d>
  800986:	89 c2                	mov    %eax,%edx
  800988:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80098c:	83 c0 08             	add    $0x8,%eax
  80098f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800992:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800995:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  80099a:	e9 a8 00 00 00       	jmp    800a47 <vprintfmt+0x5c5>
  80099f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009a3:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009a7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009ab:	eb e5                	jmp    800992 <vprintfmt+0x510>
        return va_arg(*ap, unsigned int);
  8009ad:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009b0:	83 f8 2f             	cmp    $0x2f,%eax
  8009b3:	77 15                	ja     8009ca <vprintfmt+0x548>
  8009b5:	89 c2                	mov    %eax,%edx
  8009b7:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8009bb:	83 c0 08             	add    $0x8,%eax
  8009be:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009c1:	8b 12                	mov    (%rdx),%edx
            base = 8;
  8009c3:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  8009c8:	eb 7d                	jmp    800a47 <vprintfmt+0x5c5>
  8009ca:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009ce:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009d2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009d6:	eb e9                	jmp    8009c1 <vprintfmt+0x53f>
        return va_arg(*ap, unsigned long);
  8009d8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009db:	83 f8 2f             	cmp    $0x2f,%eax
  8009de:	77 16                	ja     8009f6 <vprintfmt+0x574>
  8009e0:	89 c2                	mov    %eax,%edx
  8009e2:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8009e6:	83 c0 08             	add    $0x8,%eax
  8009e9:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009ec:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  8009ef:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  8009f4:	eb 51                	jmp    800a47 <vprintfmt+0x5c5>
  8009f6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009fa:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009fe:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a02:	eb e8                	jmp    8009ec <vprintfmt+0x56a>
        return va_arg(*ap, unsigned long long);
  800a04:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a08:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a0c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a10:	e9 5c ff ff ff       	jmp    800971 <vprintfmt+0x4ef>
            putch('0', put_arg);
  800a15:	4c 89 ee             	mov    %r13,%rsi
  800a18:	bf 30 00 00 00       	mov    $0x30,%edi
  800a1d:	41 ff d6             	call   *%r14
            putch('x', put_arg);
  800a20:	4c 89 ee             	mov    %r13,%rsi
  800a23:	bf 78 00 00 00       	mov    $0x78,%edi
  800a28:	41 ff d6             	call   *%r14
            num = (uintptr_t)va_arg(aq, void *);
  800a2b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a2e:	83 f8 2f             	cmp    $0x2f,%eax
  800a31:	77 47                	ja     800a7a <vprintfmt+0x5f8>
  800a33:	89 c2                	mov    %eax,%edx
  800a35:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a39:	83 c0 08             	add    $0x8,%eax
  800a3c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a3f:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800a42:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  800a47:	48 83 ec 08          	sub    $0x8,%rsp
  800a4b:	80 7d a0 58          	cmpb   $0x58,-0x60(%rbp)
  800a4f:	0f 94 c0             	sete   %al
  800a52:	0f b6 c0             	movzbl %al,%eax
  800a55:	50                   	push   %rax
  800a56:	44 0f be 4d aa       	movsbl -0x56(%rbp),%r9d
  800a5b:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  800a5f:	4c 89 ee             	mov    %r13,%rsi
  800a62:	4c 89 f7             	mov    %r14,%rdi
  800a65:	48 b8 6b 03 80 00 00 	movabs $0x80036b,%rax
  800a6c:	00 00 00 
  800a6f:	ff d0                	call   *%rax
            break;
  800a71:	48 83 c4 10          	add    $0x10,%rsp
  800a75:	e9 3d fa ff ff       	jmp    8004b7 <vprintfmt+0x35>
            num = (uintptr_t)va_arg(aq, void *);
  800a7a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a7e:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a82:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a86:	eb b7                	jmp    800a3f <vprintfmt+0x5bd>
    if (zflag) return va_arg(*ap, size_t);
  800a88:	40 84 f6             	test   %sil,%sil
  800a8b:	75 2b                	jne    800ab8 <vprintfmt+0x636>
    switch (lflag) {
  800a8d:	85 d2                	test   %edx,%edx
  800a8f:	74 56                	je     800ae7 <vprintfmt+0x665>
  800a91:	83 fa 01             	cmp    $0x1,%edx
  800a94:	74 7f                	je     800b15 <vprintfmt+0x693>
        return va_arg(*ap, unsigned long long);
  800a96:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a99:	83 f8 2f             	cmp    $0x2f,%eax
  800a9c:	0f 87 a2 00 00 00    	ja     800b44 <vprintfmt+0x6c2>
  800aa2:	89 c2                	mov    %eax,%edx
  800aa4:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800aa8:	83 c0 08             	add    $0x8,%eax
  800aab:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800aae:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800ab1:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800ab6:	eb 8f                	jmp    800a47 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800ab8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800abb:	83 f8 2f             	cmp    $0x2f,%eax
  800abe:	77 19                	ja     800ad9 <vprintfmt+0x657>
  800ac0:	89 c2                	mov    %eax,%edx
  800ac2:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800ac6:	83 c0 08             	add    $0x8,%eax
  800ac9:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800acc:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800acf:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800ad4:	e9 6e ff ff ff       	jmp    800a47 <vprintfmt+0x5c5>
  800ad9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800add:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800ae1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ae5:	eb e5                	jmp    800acc <vprintfmt+0x64a>
        return va_arg(*ap, unsigned int);
  800ae7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aea:	83 f8 2f             	cmp    $0x2f,%eax
  800aed:	77 18                	ja     800b07 <vprintfmt+0x685>
  800aef:	89 c2                	mov    %eax,%edx
  800af1:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800af5:	83 c0 08             	add    $0x8,%eax
  800af8:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800afb:	8b 12                	mov    (%rdx),%edx
            base = 16;
  800afd:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  800b02:	e9 40 ff ff ff       	jmp    800a47 <vprintfmt+0x5c5>
  800b07:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b0b:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b0f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b13:	eb e6                	jmp    800afb <vprintfmt+0x679>
        return va_arg(*ap, unsigned long);
  800b15:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b18:	83 f8 2f             	cmp    $0x2f,%eax
  800b1b:	77 19                	ja     800b36 <vprintfmt+0x6b4>
  800b1d:	89 c2                	mov    %eax,%edx
  800b1f:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b23:	83 c0 08             	add    $0x8,%eax
  800b26:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b29:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800b2c:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800b31:	e9 11 ff ff ff       	jmp    800a47 <vprintfmt+0x5c5>
  800b36:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b3a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b3e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b42:	eb e5                	jmp    800b29 <vprintfmt+0x6a7>
        return va_arg(*ap, unsigned long long);
  800b44:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b48:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b4c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b50:	e9 59 ff ff ff       	jmp    800aae <vprintfmt+0x62c>
            putch(ch, put_arg);
  800b55:	4c 89 ee             	mov    %r13,%rsi
  800b58:	bf 25 00 00 00       	mov    $0x25,%edi
  800b5d:	41 ff d6             	call   *%r14
            break;
  800b60:	e9 52 f9 ff ff       	jmp    8004b7 <vprintfmt+0x35>
            putch('%', put_arg);
  800b65:	4c 89 ee             	mov    %r13,%rsi
  800b68:	bf 25 00 00 00       	mov    $0x25,%edi
  800b6d:	41 ff d6             	call   *%r14
            while ((--ufmt)[-1] != '%') /* nothing */
  800b70:	48 83 eb 01          	sub    $0x1,%rbx
  800b74:	80 7b ff 25          	cmpb   $0x25,-0x1(%rbx)
  800b78:	75 f6                	jne    800b70 <vprintfmt+0x6ee>
  800b7a:	e9 38 f9 ff ff       	jmp    8004b7 <vprintfmt+0x35>
}
  800b7f:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800b83:	5b                   	pop    %rbx
  800b84:	41 5c                	pop    %r12
  800b86:	41 5d                	pop    %r13
  800b88:	41 5e                	pop    %r14
  800b8a:	41 5f                	pop    %r15
  800b8c:	5d                   	pop    %rbp
  800b8d:	c3                   	ret

0000000000800b8e <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800b8e:	f3 0f 1e fa          	endbr64
  800b92:	55                   	push   %rbp
  800b93:	48 89 e5             	mov    %rsp,%rbp
  800b96:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800b9a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800b9e:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800ba3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800ba7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800bae:	48 85 ff             	test   %rdi,%rdi
  800bb1:	74 2b                	je     800bde <vsnprintf+0x50>
  800bb3:	48 85 f6             	test   %rsi,%rsi
  800bb6:	74 26                	je     800bde <vsnprintf+0x50>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800bb8:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800bbc:	48 bf 25 04 80 00 00 	movabs $0x800425,%rdi
  800bc3:	00 00 00 
  800bc6:	48 b8 82 04 80 00 00 	movabs $0x800482,%rax
  800bcd:	00 00 00 
  800bd0:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800bd2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bd6:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800bd9:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800bdc:	c9                   	leave
  800bdd:	c3                   	ret
    if (!buf || n < 1) return -E_INVAL;
  800bde:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800be3:	eb f7                	jmp    800bdc <vsnprintf+0x4e>

0000000000800be5 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800be5:	f3 0f 1e fa          	endbr64
  800be9:	55                   	push   %rbp
  800bea:	48 89 e5             	mov    %rsp,%rbp
  800bed:	48 83 ec 50          	sub    $0x50,%rsp
  800bf1:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800bf5:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800bf9:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800bfd:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800c04:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800c08:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c0c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800c10:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800c14:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800c18:	48 b8 8e 0b 80 00 00 	movabs $0x800b8e,%rax
  800c1f:	00 00 00 
  800c22:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800c24:	c9                   	leave
  800c25:	c3                   	ret

0000000000800c26 <strlen>:
 * Primespipe runs 3x faster this way */

#define ASM 1

size_t
strlen(const char *s) {
  800c26:	f3 0f 1e fa          	endbr64
    size_t n = 0;
    while (*s++) n++;
  800c2a:	80 3f 00             	cmpb   $0x0,(%rdi)
  800c2d:	74 10                	je     800c3f <strlen+0x19>
    size_t n = 0;
  800c2f:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800c34:	48 83 c0 01          	add    $0x1,%rax
  800c38:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800c3c:	75 f6                	jne    800c34 <strlen+0xe>
  800c3e:	c3                   	ret
    size_t n = 0;
  800c3f:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800c44:	c3                   	ret

0000000000800c45 <strnlen>:

size_t
strnlen(const char *s, size_t size) {
  800c45:	f3 0f 1e fa          	endbr64
  800c49:	48 89 f0             	mov    %rsi,%rax
    size_t n = 0;
  800c4c:	ba 00 00 00 00       	mov    $0x0,%edx
    while (n < size && *s++) n++;
  800c51:	48 85 f6             	test   %rsi,%rsi
  800c54:	74 10                	je     800c66 <strnlen+0x21>
  800c56:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  800c5a:	74 0b                	je     800c67 <strnlen+0x22>
  800c5c:	48 83 c2 01          	add    $0x1,%rdx
  800c60:	48 39 d0             	cmp    %rdx,%rax
  800c63:	75 f1                	jne    800c56 <strnlen+0x11>
  800c65:	c3                   	ret
  800c66:	c3                   	ret
  800c67:	48 89 d0             	mov    %rdx,%rax
    return n;
}
  800c6a:	c3                   	ret

0000000000800c6b <strcpy>:

char *
strcpy(char *dst, const char *src) {
  800c6b:	f3 0f 1e fa          	endbr64
  800c6f:	48 89 f8             	mov    %rdi,%rax
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800c72:	ba 00 00 00 00       	mov    $0x0,%edx
  800c77:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  800c7b:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  800c7e:	48 83 c2 01          	add    $0x1,%rdx
  800c82:	84 c9                	test   %cl,%cl
  800c84:	75 f1                	jne    800c77 <strcpy+0xc>
        ;
    return res;
}
  800c86:	c3                   	ret

0000000000800c87 <strcat>:

char *
strcat(char *dst, const char *src) {
  800c87:	f3 0f 1e fa          	endbr64
  800c8b:	55                   	push   %rbp
  800c8c:	48 89 e5             	mov    %rsp,%rbp
  800c8f:	41 54                	push   %r12
  800c91:	53                   	push   %rbx
  800c92:	48 89 fb             	mov    %rdi,%rbx
  800c95:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800c98:	48 b8 26 0c 80 00 00 	movabs $0x800c26,%rax
  800c9f:	00 00 00 
  800ca2:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800ca4:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800ca8:	4c 89 e6             	mov    %r12,%rsi
  800cab:	48 b8 6b 0c 80 00 00 	movabs $0x800c6b,%rax
  800cb2:	00 00 00 
  800cb5:	ff d0                	call   *%rax
    return dst;
}
  800cb7:	48 89 d8             	mov    %rbx,%rax
  800cba:	5b                   	pop    %rbx
  800cbb:	41 5c                	pop    %r12
  800cbd:	5d                   	pop    %rbp
  800cbe:	c3                   	ret

0000000000800cbf <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800cbf:	f3 0f 1e fa          	endbr64
  800cc3:	48 89 f8             	mov    %rdi,%rax
    char *ret = dst;
    while (size-- > 0) {
  800cc6:	48 85 d2             	test   %rdx,%rdx
  800cc9:	74 1f                	je     800cea <strncpy+0x2b>
  800ccb:	48 01 fa             	add    %rdi,%rdx
  800cce:	48 89 f9             	mov    %rdi,%rcx
        *dst++ = *src;
  800cd1:	48 83 c1 01          	add    $0x1,%rcx
  800cd5:	44 0f b6 06          	movzbl (%rsi),%r8d
  800cd9:	44 88 41 ff          	mov    %r8b,-0x1(%rcx)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800cdd:	41 80 f8 01          	cmp    $0x1,%r8b
  800ce1:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800ce5:	48 39 ca             	cmp    %rcx,%rdx
  800ce8:	75 e7                	jne    800cd1 <strncpy+0x12>
    }
    return ret;
}
  800cea:	c3                   	ret

0000000000800ceb <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
  800ceb:	f3 0f 1e fa          	endbr64
    char *dst_in = dst;
    if (size) {
  800cef:	48 89 f8             	mov    %rdi,%rax
  800cf2:	48 85 d2             	test   %rdx,%rdx
  800cf5:	74 24                	je     800d1b <strlcpy+0x30>
        while (--size > 0 && *src)
  800cf7:	48 83 ea 01          	sub    $0x1,%rdx
  800cfb:	74 1b                	je     800d18 <strlcpy+0x2d>
  800cfd:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800d01:	0f b6 16             	movzbl (%rsi),%edx
  800d04:	84 d2                	test   %dl,%dl
  800d06:	74 10                	je     800d18 <strlcpy+0x2d>
            *dst++ = *src++;
  800d08:	48 83 c6 01          	add    $0x1,%rsi
  800d0c:	48 83 c0 01          	add    $0x1,%rax
  800d10:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800d13:	48 39 c8             	cmp    %rcx,%rax
  800d16:	75 e9                	jne    800d01 <strlcpy+0x16>
        *dst = '\0';
  800d18:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800d1b:	48 29 f8             	sub    %rdi,%rax
}
  800d1e:	c3                   	ret

0000000000800d1f <strcmp>:
    }
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
  800d1f:	f3 0f 1e fa          	endbr64
    while (*p && *p == *q) p++, q++;
  800d23:	0f b6 07             	movzbl (%rdi),%eax
  800d26:	84 c0                	test   %al,%al
  800d28:	74 13                	je     800d3d <strcmp+0x1e>
  800d2a:	38 06                	cmp    %al,(%rsi)
  800d2c:	75 0f                	jne    800d3d <strcmp+0x1e>
  800d2e:	48 83 c7 01          	add    $0x1,%rdi
  800d32:	48 83 c6 01          	add    $0x1,%rsi
  800d36:	0f b6 07             	movzbl (%rdi),%eax
  800d39:	84 c0                	test   %al,%al
  800d3b:	75 ed                	jne    800d2a <strcmp+0xb>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800d3d:	0f b6 c0             	movzbl %al,%eax
  800d40:	0f b6 16             	movzbl (%rsi),%edx
  800d43:	29 d0                	sub    %edx,%eax
}
  800d45:	c3                   	ret

0000000000800d46 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
  800d46:	f3 0f 1e fa          	endbr64
    while (n && *p && *p == *q) n--, p++, q++;
  800d4a:	48 85 d2             	test   %rdx,%rdx
  800d4d:	74 1f                	je     800d6e <strncmp+0x28>
  800d4f:	0f b6 07             	movzbl (%rdi),%eax
  800d52:	84 c0                	test   %al,%al
  800d54:	74 1e                	je     800d74 <strncmp+0x2e>
  800d56:	3a 06                	cmp    (%rsi),%al
  800d58:	75 1a                	jne    800d74 <strncmp+0x2e>
  800d5a:	48 83 c7 01          	add    $0x1,%rdi
  800d5e:	48 83 c6 01          	add    $0x1,%rsi
  800d62:	48 83 ea 01          	sub    $0x1,%rdx
  800d66:	75 e7                	jne    800d4f <strncmp+0x9>

    if (!n) return 0;
  800d68:	b8 00 00 00 00       	mov    $0x0,%eax
  800d6d:	c3                   	ret
  800d6e:	b8 00 00 00 00       	mov    $0x0,%eax
  800d73:	c3                   	ret

    return (int)((unsigned char)*p - (unsigned char)*q);
  800d74:	0f b6 07             	movzbl (%rdi),%eax
  800d77:	0f b6 16             	movzbl (%rsi),%edx
  800d7a:	29 d0                	sub    %edx,%eax
}
  800d7c:	c3                   	ret

0000000000800d7d <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
  800d7d:	f3 0f 1e fa          	endbr64
    for (; *str; str++) {
  800d81:	0f b6 17             	movzbl (%rdi),%edx
  800d84:	84 d2                	test   %dl,%dl
  800d86:	74 18                	je     800da0 <strchr+0x23>
        if (*str == c) {
  800d88:	0f be d2             	movsbl %dl,%edx
  800d8b:	39 f2                	cmp    %esi,%edx
  800d8d:	74 17                	je     800da6 <strchr+0x29>
    for (; *str; str++) {
  800d8f:	48 83 c7 01          	add    $0x1,%rdi
  800d93:	0f b6 17             	movzbl (%rdi),%edx
  800d96:	84 d2                	test   %dl,%dl
  800d98:	75 ee                	jne    800d88 <strchr+0xb>
            return (char *)str;
        }
    }
    return NULL;
  800d9a:	b8 00 00 00 00       	mov    $0x0,%eax
  800d9f:	c3                   	ret
  800da0:	b8 00 00 00 00       	mov    $0x0,%eax
  800da5:	c3                   	ret
            return (char *)str;
  800da6:	48 89 f8             	mov    %rdi,%rax
}
  800da9:	c3                   	ret

0000000000800daa <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
  800daa:	f3 0f 1e fa          	endbr64
  800dae:	48 89 f8             	mov    %rdi,%rax
    for (; *str && *str != ch; str++) /* nothing */
  800db1:	0f b6 17             	movzbl (%rdi),%edx
  800db4:	84 d2                	test   %dl,%dl
  800db6:	74 13                	je     800dcb <strfind+0x21>
  800db8:	0f be d2             	movsbl %dl,%edx
  800dbb:	39 f2                	cmp    %esi,%edx
  800dbd:	74 0b                	je     800dca <strfind+0x20>
  800dbf:	48 83 c0 01          	add    $0x1,%rax
  800dc3:	0f b6 10             	movzbl (%rax),%edx
  800dc6:	84 d2                	test   %dl,%dl
  800dc8:	75 ee                	jne    800db8 <strfind+0xe>
        ;
    return (char *)str;
}
  800dca:	c3                   	ret
  800dcb:	c3                   	ret

0000000000800dcc <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  800dcc:	f3 0f 1e fa          	endbr64
  800dd0:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  800dd3:	48 89 f8             	mov    %rdi,%rax
  800dd6:	48 f7 d8             	neg    %rax
  800dd9:	83 e0 07             	and    $0x7,%eax
  800ddc:	49 89 d1             	mov    %rdx,%r9
  800ddf:	49 29 c1             	sub    %rax,%r9
  800de2:	78 36                	js     800e1a <memset+0x4e>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  800de4:	40 0f b6 c6          	movzbl %sil,%eax
  800de8:	48 b9 01 01 01 01 01 	movabs $0x101010101010101,%rcx
  800def:	01 01 01 
  800df2:	48 0f af c1          	imul   %rcx,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  800df6:	40 f6 c7 07          	test   $0x7,%dil
  800dfa:	75 38                	jne    800e34 <memset+0x68>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  800dfc:	4c 89 c9             	mov    %r9,%rcx
  800dff:	48 c1 f9 03          	sar    $0x3,%rcx
  800e03:	74 0c                	je     800e11 <memset+0x45>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  800e05:	fc                   	cld
  800e06:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  800e09:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  800e0d:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  800e11:	4d 85 c9             	test   %r9,%r9
  800e14:	75 45                	jne    800e5b <memset+0x8f>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  800e16:	4c 89 c0             	mov    %r8,%rax
  800e19:	c3                   	ret
        while (n-- > 0) *ptr++ = c;
  800e1a:	48 85 d2             	test   %rdx,%rdx
  800e1d:	74 f7                	je     800e16 <memset+0x4a>
  800e1f:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  800e22:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  800e25:	48 83 c0 01          	add    $0x1,%rax
  800e29:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  800e2d:	48 39 c2             	cmp    %rax,%rdx
  800e30:	75 f3                	jne    800e25 <memset+0x59>
  800e32:	eb e2                	jmp    800e16 <memset+0x4a>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  800e34:	40 f6 c7 01          	test   $0x1,%dil
  800e38:	74 06                	je     800e40 <memset+0x74>
  800e3a:	88 07                	mov    %al,(%rdi)
  800e3c:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  800e40:	40 f6 c7 02          	test   $0x2,%dil
  800e44:	74 07                	je     800e4d <memset+0x81>
  800e46:	66 89 07             	mov    %ax,(%rdi)
  800e49:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  800e4d:	40 f6 c7 04          	test   $0x4,%dil
  800e51:	74 a9                	je     800dfc <memset+0x30>
  800e53:	89 07                	mov    %eax,(%rdi)
  800e55:	48 83 c7 04          	add    $0x4,%rdi
  800e59:	eb a1                	jmp    800dfc <memset+0x30>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  800e5b:	41 f6 c1 04          	test   $0x4,%r9b
  800e5f:	74 1b                	je     800e7c <memset+0xb0>
  800e61:	89 07                	mov    %eax,(%rdi)
  800e63:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800e67:	41 f6 c1 02          	test   $0x2,%r9b
  800e6b:	74 07                	je     800e74 <memset+0xa8>
  800e6d:	66 89 07             	mov    %ax,(%rdi)
  800e70:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  800e74:	41 f6 c1 01          	test   $0x1,%r9b
  800e78:	74 9c                	je     800e16 <memset+0x4a>
  800e7a:	eb 06                	jmp    800e82 <memset+0xb6>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800e7c:	41 f6 c1 02          	test   $0x2,%r9b
  800e80:	75 eb                	jne    800e6d <memset+0xa1>
        if (ni & 1) *ptr = k;
  800e82:	88 07                	mov    %al,(%rdi)
  800e84:	eb 90                	jmp    800e16 <memset+0x4a>

0000000000800e86 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  800e86:	f3 0f 1e fa          	endbr64
  800e8a:	48 89 f8             	mov    %rdi,%rax
  800e8d:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  800e90:	48 39 fe             	cmp    %rdi,%rsi
  800e93:	73 3b                	jae    800ed0 <memmove+0x4a>
  800e95:	48 8d 14 16          	lea    (%rsi,%rdx,1),%rdx
  800e99:	48 39 d7             	cmp    %rdx,%rdi
  800e9c:	73 32                	jae    800ed0 <memmove+0x4a>
        s += n;
        d += n;
  800e9e:	48 8d 3c 0f          	lea    (%rdi,%rcx,1),%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800ea2:	48 89 d6             	mov    %rdx,%rsi
  800ea5:	48 09 fe             	or     %rdi,%rsi
  800ea8:	48 09 ce             	or     %rcx,%rsi
  800eab:	40 f6 c6 07          	test   $0x7,%sil
  800eaf:	75 12                	jne    800ec3 <memmove+0x3d>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  800eb1:	48 83 ef 08          	sub    $0x8,%rdi
  800eb5:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  800eb9:	48 c1 e9 03          	shr    $0x3,%rcx
  800ebd:	fd                   	std
  800ebe:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  800ec1:	fc                   	cld
  800ec2:	c3                   	ret
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  800ec3:	48 83 ef 01          	sub    $0x1,%rdi
  800ec7:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  800ecb:	fd                   	std
  800ecc:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  800ece:	eb f1                	jmp    800ec1 <memmove+0x3b>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800ed0:	48 89 f2             	mov    %rsi,%rdx
  800ed3:	48 09 c2             	or     %rax,%rdx
  800ed6:	48 09 ca             	or     %rcx,%rdx
  800ed9:	f6 c2 07             	test   $0x7,%dl
  800edc:	75 0c                	jne    800eea <memmove+0x64>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  800ede:	48 c1 e9 03          	shr    $0x3,%rcx
  800ee2:	48 89 c7             	mov    %rax,%rdi
  800ee5:	fc                   	cld
  800ee6:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  800ee9:	c3                   	ret
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  800eea:	48 89 c7             	mov    %rax,%rdi
  800eed:	fc                   	cld
  800eee:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  800ef0:	c3                   	ret

0000000000800ef1 <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  800ef1:	f3 0f 1e fa          	endbr64
  800ef5:	55                   	push   %rbp
  800ef6:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  800ef9:	48 b8 86 0e 80 00 00 	movabs $0x800e86,%rax
  800f00:	00 00 00 
  800f03:	ff d0                	call   *%rax
}
  800f05:	5d                   	pop    %rbp
  800f06:	c3                   	ret

0000000000800f07 <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  800f07:	f3 0f 1e fa          	endbr64
  800f0b:	55                   	push   %rbp
  800f0c:	48 89 e5             	mov    %rsp,%rbp
  800f0f:	41 57                	push   %r15
  800f11:	41 56                	push   %r14
  800f13:	41 55                	push   %r13
  800f15:	41 54                	push   %r12
  800f17:	53                   	push   %rbx
  800f18:	48 83 ec 08          	sub    $0x8,%rsp
  800f1c:	49 89 fe             	mov    %rdi,%r14
  800f1f:	49 89 f7             	mov    %rsi,%r15
  800f22:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  800f25:	48 89 f7             	mov    %rsi,%rdi
  800f28:	48 b8 26 0c 80 00 00 	movabs $0x800c26,%rax
  800f2f:	00 00 00 
  800f32:	ff d0                	call   *%rax
  800f34:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  800f37:	48 89 de             	mov    %rbx,%rsi
  800f3a:	4c 89 f7             	mov    %r14,%rdi
  800f3d:	48 b8 45 0c 80 00 00 	movabs $0x800c45,%rax
  800f44:	00 00 00 
  800f47:	ff d0                	call   *%rax
  800f49:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  800f4c:	48 39 c3             	cmp    %rax,%rbx
  800f4f:	74 36                	je     800f87 <strlcat+0x80>
    if (srclen < maxlen - dstlen) {
  800f51:	48 89 d8             	mov    %rbx,%rax
  800f54:	4c 29 e8             	sub    %r13,%rax
  800f57:	49 39 c4             	cmp    %rax,%r12
  800f5a:	73 31                	jae    800f8d <strlcat+0x86>
        memcpy(dst + dstlen, src, srclen + 1);
  800f5c:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  800f61:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800f65:	4c 89 fe             	mov    %r15,%rsi
  800f68:	48 b8 f1 0e 80 00 00 	movabs $0x800ef1,%rax
  800f6f:	00 00 00 
  800f72:	ff d0                	call   *%rax
    return dstlen + srclen;
  800f74:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  800f78:	48 83 c4 08          	add    $0x8,%rsp
  800f7c:	5b                   	pop    %rbx
  800f7d:	41 5c                	pop    %r12
  800f7f:	41 5d                	pop    %r13
  800f81:	41 5e                	pop    %r14
  800f83:	41 5f                	pop    %r15
  800f85:	5d                   	pop    %rbp
  800f86:	c3                   	ret
    if (dstlen == maxlen) return maxlen + srclen;
  800f87:	49 8d 04 04          	lea    (%r12,%rax,1),%rax
  800f8b:	eb eb                	jmp    800f78 <strlcat+0x71>
        memcpy(dst + dstlen, src, maxlen - 1);
  800f8d:	48 83 eb 01          	sub    $0x1,%rbx
  800f91:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800f95:	48 89 da             	mov    %rbx,%rdx
  800f98:	4c 89 fe             	mov    %r15,%rsi
  800f9b:	48 b8 f1 0e 80 00 00 	movabs $0x800ef1,%rax
  800fa2:	00 00 00 
  800fa5:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  800fa7:	49 01 de             	add    %rbx,%r14
  800faa:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  800faf:	eb c3                	jmp    800f74 <strlcat+0x6d>

0000000000800fb1 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  800fb1:	f3 0f 1e fa          	endbr64
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  800fb5:	48 85 d2             	test   %rdx,%rdx
  800fb8:	74 2d                	je     800fe7 <memcmp+0x36>
  800fba:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  800fbf:	0f b6 0c 07          	movzbl (%rdi,%rax,1),%ecx
  800fc3:	44 0f b6 04 06       	movzbl (%rsi,%rax,1),%r8d
  800fc8:	44 38 c1             	cmp    %r8b,%cl
  800fcb:	75 0f                	jne    800fdc <memcmp+0x2b>
    while (n-- > 0) {
  800fcd:	48 83 c0 01          	add    $0x1,%rax
  800fd1:	48 39 c2             	cmp    %rax,%rdx
  800fd4:	75 e9                	jne    800fbf <memcmp+0xe>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  800fd6:	b8 00 00 00 00       	mov    $0x0,%eax
  800fdb:	c3                   	ret
            return (int)*s1 - (int)*s2;
  800fdc:	0f b6 c1             	movzbl %cl,%eax
  800fdf:	45 0f b6 c0          	movzbl %r8b,%r8d
  800fe3:	44 29 c0             	sub    %r8d,%eax
  800fe6:	c3                   	ret
    return 0;
  800fe7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fec:	c3                   	ret

0000000000800fed <memfind>:

void *
memfind(const void *src, int c, size_t n) {
  800fed:	f3 0f 1e fa          	endbr64
    const void *end = (const char *)src + n;
  800ff1:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  800ff5:	48 39 c7             	cmp    %rax,%rdi
  800ff8:	73 0f                	jae    801009 <memfind+0x1c>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  800ffa:	40 38 37             	cmp    %sil,(%rdi)
  800ffd:	74 0e                	je     80100d <memfind+0x20>
    for (; src < end; src++) {
  800fff:	48 83 c7 01          	add    $0x1,%rdi
  801003:	48 39 f8             	cmp    %rdi,%rax
  801006:	75 f2                	jne    800ffa <memfind+0xd>
  801008:	c3                   	ret
  801009:	48 89 f8             	mov    %rdi,%rax
  80100c:	c3                   	ret
  80100d:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  801010:	c3                   	ret

0000000000801011 <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  801011:	f3 0f 1e fa          	endbr64
  801015:	49 89 f2             	mov    %rsi,%r10
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  801018:	0f b6 37             	movzbl (%rdi),%esi
  80101b:	40 80 fe 20          	cmp    $0x20,%sil
  80101f:	74 06                	je     801027 <strtol+0x16>
  801021:	40 80 fe 09          	cmp    $0x9,%sil
  801025:	75 13                	jne    80103a <strtol+0x29>
  801027:	48 83 c7 01          	add    $0x1,%rdi
  80102b:	0f b6 37             	movzbl (%rdi),%esi
  80102e:	40 80 fe 20          	cmp    $0x20,%sil
  801032:	74 f3                	je     801027 <strtol+0x16>
  801034:	40 80 fe 09          	cmp    $0x9,%sil
  801038:	74 ed                	je     801027 <strtol+0x16>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  80103a:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  80103d:	83 e0 fd             	and    $0xfffffffd,%eax
  801040:	3c 01                	cmp    $0x1,%al
  801042:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  801046:	f7 c2 ef ff ff ff    	test   $0xffffffef,%edx
  80104c:	75 0f                	jne    80105d <strtol+0x4c>
  80104e:	80 3f 30             	cmpb   $0x30,(%rdi)
  801051:	74 14                	je     801067 <strtol+0x56>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  801053:	85 d2                	test   %edx,%edx
  801055:	b8 0a 00 00 00       	mov    $0xa,%eax
  80105a:	0f 44 d0             	cmove  %eax,%edx
    }

    /* Digits */
    long val = 0;
  80105d:	b8 00 00 00 00       	mov    $0x0,%eax
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  801062:	4c 63 ca             	movslq %edx,%r9
  801065:	eb 36                	jmp    80109d <strtol+0x8c>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  801067:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  80106b:	74 0f                	je     80107c <strtol+0x6b>
    } else if (!base && s[0] == '0') {
  80106d:	85 d2                	test   %edx,%edx
  80106f:	75 ec                	jne    80105d <strtol+0x4c>
        s++;
  801071:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  801075:	ba 08 00 00 00       	mov    $0x8,%edx
        s++;
  80107a:	eb e1                	jmp    80105d <strtol+0x4c>
        s += 2;
  80107c:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  801080:	ba 10 00 00 00       	mov    $0x10,%edx
        s += 2;
  801085:	eb d6                	jmp    80105d <strtol+0x4c>
            dig -= '0';
  801087:	83 e9 30             	sub    $0x30,%ecx
        if (dig >= base) break;
  80108a:	44 0f b6 c1          	movzbl %cl,%r8d
  80108e:	41 39 d0             	cmp    %edx,%r8d
  801091:	7d 21                	jge    8010b4 <strtol+0xa3>
        val = val * base + dig;
  801093:	49 0f af c1          	imul   %r9,%rax
  801097:	0f b6 c9             	movzbl %cl,%ecx
  80109a:	48 01 c8             	add    %rcx,%rax
        uint8_t dig = *s++;
  80109d:	48 83 c7 01          	add    $0x1,%rdi
  8010a1:	0f b6 4f ff          	movzbl -0x1(%rdi),%ecx
        if (dig - '0' < 10)
  8010a5:	80 f9 39             	cmp    $0x39,%cl
  8010a8:	76 dd                	jbe    801087 <strtol+0x76>
        else if (dig - 'a' < 27)
  8010aa:	80 f9 7b             	cmp    $0x7b,%cl
  8010ad:	77 05                	ja     8010b4 <strtol+0xa3>
            dig -= 'a' - 10;
  8010af:	83 e9 57             	sub    $0x57,%ecx
  8010b2:	eb d6                	jmp    80108a <strtol+0x79>
    }

    if (endptr) *endptr = (char *)s;
  8010b4:	4d 85 d2             	test   %r10,%r10
  8010b7:	74 03                	je     8010bc <strtol+0xab>
  8010b9:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  8010bc:	48 89 c2             	mov    %rax,%rdx
  8010bf:	48 f7 da             	neg    %rdx
  8010c2:	40 80 fe 2d          	cmp    $0x2d,%sil
  8010c6:	48 0f 44 c2          	cmove  %rdx,%rax
}
  8010ca:	c3                   	ret

00000000008010cb <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  8010cb:	f3 0f 1e fa          	endbr64
  8010cf:	55                   	push   %rbp
  8010d0:	48 89 e5             	mov    %rsp,%rbp
  8010d3:	53                   	push   %rbx
  8010d4:	48 89 fa             	mov    %rdi,%rdx
  8010d7:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8010da:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8010df:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010e4:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8010e9:	be 00 00 00 00       	mov    $0x0,%esi
  8010ee:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8010f4:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  8010f6:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8010fa:	c9                   	leave
  8010fb:	c3                   	ret

00000000008010fc <sys_cgetc>:

int
sys_cgetc(void) {
  8010fc:	f3 0f 1e fa          	endbr64
  801100:	55                   	push   %rbp
  801101:	48 89 e5             	mov    %rsp,%rbp
  801104:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801105:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80110a:	ba 00 00 00 00       	mov    $0x0,%edx
  80110f:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801114:	bb 00 00 00 00       	mov    $0x0,%ebx
  801119:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80111e:	be 00 00 00 00       	mov    $0x0,%esi
  801123:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801129:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  80112b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80112f:	c9                   	leave
  801130:	c3                   	ret

0000000000801131 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  801131:	f3 0f 1e fa          	endbr64
  801135:	55                   	push   %rbp
  801136:	48 89 e5             	mov    %rsp,%rbp
  801139:	53                   	push   %rbx
  80113a:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  80113e:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801141:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801146:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80114b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801150:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801155:	be 00 00 00 00       	mov    $0x0,%esi
  80115a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801160:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801162:	48 85 c0             	test   %rax,%rax
  801165:	7f 06                	jg     80116d <sys_env_destroy+0x3c>
}
  801167:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80116b:	c9                   	leave
  80116c:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80116d:	49 89 c0             	mov    %rax,%r8
  801170:	b9 03 00 00 00       	mov    $0x3,%ecx
  801175:	48 ba 38 43 80 00 00 	movabs $0x804338,%rdx
  80117c:	00 00 00 
  80117f:	be 26 00 00 00       	mov    $0x26,%esi
  801184:	48 bf c9 41 80 00 00 	movabs $0x8041c9,%rdi
  80118b:	00 00 00 
  80118e:	b8 00 00 00 00       	mov    $0x0,%eax
  801193:	49 b9 b0 2e 80 00 00 	movabs $0x802eb0,%r9
  80119a:	00 00 00 
  80119d:	41 ff d1             	call   *%r9

00000000008011a0 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  8011a0:	f3 0f 1e fa          	endbr64
  8011a4:	55                   	push   %rbp
  8011a5:	48 89 e5             	mov    %rsp,%rbp
  8011a8:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8011a9:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8011ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8011b3:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8011b8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011bd:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8011c2:	be 00 00 00 00       	mov    $0x0,%esi
  8011c7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8011cd:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  8011cf:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011d3:	c9                   	leave
  8011d4:	c3                   	ret

00000000008011d5 <sys_yield>:

void
sys_yield(void) {
  8011d5:	f3 0f 1e fa          	endbr64
  8011d9:	55                   	push   %rbp
  8011da:	48 89 e5             	mov    %rsp,%rbp
  8011dd:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8011de:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8011e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8011e8:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8011ed:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011f2:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8011f7:	be 00 00 00 00       	mov    $0x0,%esi
  8011fc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801202:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  801204:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801208:	c9                   	leave
  801209:	c3                   	ret

000000000080120a <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  80120a:	f3 0f 1e fa          	endbr64
  80120e:	55                   	push   %rbp
  80120f:	48 89 e5             	mov    %rsp,%rbp
  801212:	53                   	push   %rbx
  801213:	48 89 fa             	mov    %rdi,%rdx
  801216:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801219:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80121e:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  801225:	00 00 00 
  801228:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80122d:	be 00 00 00 00       	mov    $0x0,%esi
  801232:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801238:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  80123a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80123e:	c9                   	leave
  80123f:	c3                   	ret

0000000000801240 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  801240:	f3 0f 1e fa          	endbr64
  801244:	55                   	push   %rbp
  801245:	48 89 e5             	mov    %rsp,%rbp
  801248:	53                   	push   %rbx
  801249:	49 89 f8             	mov    %rdi,%r8
  80124c:	48 89 d3             	mov    %rdx,%rbx
  80124f:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  801252:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801257:	4c 89 c2             	mov    %r8,%rdx
  80125a:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80125d:	be 00 00 00 00       	mov    $0x0,%esi
  801262:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801268:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  80126a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80126e:	c9                   	leave
  80126f:	c3                   	ret

0000000000801270 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  801270:	f3 0f 1e fa          	endbr64
  801274:	55                   	push   %rbp
  801275:	48 89 e5             	mov    %rsp,%rbp
  801278:	53                   	push   %rbx
  801279:	48 83 ec 08          	sub    $0x8,%rsp
  80127d:	89 f8                	mov    %edi,%eax
  80127f:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  801282:	48 63 f9             	movslq %ecx,%rdi
  801285:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801288:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80128d:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801290:	be 00 00 00 00       	mov    $0x0,%esi
  801295:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80129b:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80129d:	48 85 c0             	test   %rax,%rax
  8012a0:	7f 06                	jg     8012a8 <sys_alloc_region+0x38>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  8012a2:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012a6:	c9                   	leave
  8012a7:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8012a8:	49 89 c0             	mov    %rax,%r8
  8012ab:	b9 04 00 00 00       	mov    $0x4,%ecx
  8012b0:	48 ba 38 43 80 00 00 	movabs $0x804338,%rdx
  8012b7:	00 00 00 
  8012ba:	be 26 00 00 00       	mov    $0x26,%esi
  8012bf:	48 bf c9 41 80 00 00 	movabs $0x8041c9,%rdi
  8012c6:	00 00 00 
  8012c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8012ce:	49 b9 b0 2e 80 00 00 	movabs $0x802eb0,%r9
  8012d5:	00 00 00 
  8012d8:	41 ff d1             	call   *%r9

00000000008012db <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  8012db:	f3 0f 1e fa          	endbr64
  8012df:	55                   	push   %rbp
  8012e0:	48 89 e5             	mov    %rsp,%rbp
  8012e3:	53                   	push   %rbx
  8012e4:	48 83 ec 08          	sub    $0x8,%rsp
  8012e8:	89 f8                	mov    %edi,%eax
  8012ea:	49 89 f2             	mov    %rsi,%r10
  8012ed:	48 89 cf             	mov    %rcx,%rdi
  8012f0:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  8012f3:	48 63 da             	movslq %edx,%rbx
  8012f6:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8012f9:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8012fe:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801301:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  801304:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801306:	48 85 c0             	test   %rax,%rax
  801309:	7f 06                	jg     801311 <sys_map_region+0x36>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  80130b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80130f:	c9                   	leave
  801310:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801311:	49 89 c0             	mov    %rax,%r8
  801314:	b9 05 00 00 00       	mov    $0x5,%ecx
  801319:	48 ba 38 43 80 00 00 	movabs $0x804338,%rdx
  801320:	00 00 00 
  801323:	be 26 00 00 00       	mov    $0x26,%esi
  801328:	48 bf c9 41 80 00 00 	movabs $0x8041c9,%rdi
  80132f:	00 00 00 
  801332:	b8 00 00 00 00       	mov    $0x0,%eax
  801337:	49 b9 b0 2e 80 00 00 	movabs $0x802eb0,%r9
  80133e:	00 00 00 
  801341:	41 ff d1             	call   *%r9

0000000000801344 <sys_map_physical_region>:

int
sys_map_physical_region(uintptr_t pa, envid_t dstenv, void *dstva, size_t size, int perm) {
  801344:	f3 0f 1e fa          	endbr64
  801348:	55                   	push   %rbp
  801349:	48 89 e5             	mov    %rsp,%rbp
  80134c:	53                   	push   %rbx
  80134d:	48 83 ec 08          	sub    $0x8,%rsp
  801351:	49 89 f9             	mov    %rdi,%r9
  801354:	89 f0                	mov    %esi,%eax
  801356:	48 89 d3             	mov    %rdx,%rbx
  801359:	48 89 cf             	mov    %rcx,%rdi
    int res = syscall(SYS_map_physical_region, 1, pa, dstenv, (uintptr_t)dstva, size, perm, 0);
  80135c:	49 63 f0             	movslq %r8d,%rsi
  80135f:	48 63 c8             	movslq %eax,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801362:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801367:	4c 89 ca             	mov    %r9,%rdx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80136a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801370:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801372:	48 85 c0             	test   %rax,%rax
  801375:	7f 06                	jg     80137d <sys_map_physical_region+0x39>
#ifdef SANITIZE_USER_SHADOW_BASE
    platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  801377:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80137b:	c9                   	leave
  80137c:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80137d:	49 89 c0             	mov    %rax,%r8
  801380:	b9 06 00 00 00       	mov    $0x6,%ecx
  801385:	48 ba 38 43 80 00 00 	movabs $0x804338,%rdx
  80138c:	00 00 00 
  80138f:	be 26 00 00 00       	mov    $0x26,%esi
  801394:	48 bf c9 41 80 00 00 	movabs $0x8041c9,%rdi
  80139b:	00 00 00 
  80139e:	b8 00 00 00 00       	mov    $0x0,%eax
  8013a3:	49 b9 b0 2e 80 00 00 	movabs $0x802eb0,%r9
  8013aa:	00 00 00 
  8013ad:	41 ff d1             	call   *%r9

00000000008013b0 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  8013b0:	f3 0f 1e fa          	endbr64
  8013b4:	55                   	push   %rbp
  8013b5:	48 89 e5             	mov    %rsp,%rbp
  8013b8:	53                   	push   %rbx
  8013b9:	48 83 ec 08          	sub    $0x8,%rsp
  8013bd:	48 89 f1             	mov    %rsi,%rcx
  8013c0:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  8013c3:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8013c6:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8013cb:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013d0:	be 00 00 00 00       	mov    $0x0,%esi
  8013d5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013db:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8013dd:	48 85 c0             	test   %rax,%rax
  8013e0:	7f 06                	jg     8013e8 <sys_unmap_region+0x38>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  8013e2:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013e6:	c9                   	leave
  8013e7:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8013e8:	49 89 c0             	mov    %rax,%r8
  8013eb:	b9 07 00 00 00       	mov    $0x7,%ecx
  8013f0:	48 ba 38 43 80 00 00 	movabs $0x804338,%rdx
  8013f7:	00 00 00 
  8013fa:	be 26 00 00 00       	mov    $0x26,%esi
  8013ff:	48 bf c9 41 80 00 00 	movabs $0x8041c9,%rdi
  801406:	00 00 00 
  801409:	b8 00 00 00 00       	mov    $0x0,%eax
  80140e:	49 b9 b0 2e 80 00 00 	movabs $0x802eb0,%r9
  801415:	00 00 00 
  801418:	41 ff d1             	call   *%r9

000000000080141b <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  80141b:	f3 0f 1e fa          	endbr64
  80141f:	55                   	push   %rbp
  801420:	48 89 e5             	mov    %rsp,%rbp
  801423:	53                   	push   %rbx
  801424:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  801428:	48 63 ce             	movslq %esi,%rcx
  80142b:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80142e:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801433:	bb 00 00 00 00       	mov    $0x0,%ebx
  801438:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80143d:	be 00 00 00 00       	mov    $0x0,%esi
  801442:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801448:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80144a:	48 85 c0             	test   %rax,%rax
  80144d:	7f 06                	jg     801455 <sys_env_set_status+0x3a>
}
  80144f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801453:	c9                   	leave
  801454:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801455:	49 89 c0             	mov    %rax,%r8
  801458:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80145d:	48 ba 38 43 80 00 00 	movabs $0x804338,%rdx
  801464:	00 00 00 
  801467:	be 26 00 00 00       	mov    $0x26,%esi
  80146c:	48 bf c9 41 80 00 00 	movabs $0x8041c9,%rdi
  801473:	00 00 00 
  801476:	b8 00 00 00 00       	mov    $0x0,%eax
  80147b:	49 b9 b0 2e 80 00 00 	movabs $0x802eb0,%r9
  801482:	00 00 00 
  801485:	41 ff d1             	call   *%r9

0000000000801488 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  801488:	f3 0f 1e fa          	endbr64
  80148c:	55                   	push   %rbp
  80148d:	48 89 e5             	mov    %rsp,%rbp
  801490:	53                   	push   %rbx
  801491:	48 83 ec 08          	sub    $0x8,%rsp
  801495:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  801498:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80149b:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8014a0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014a5:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8014aa:	be 00 00 00 00       	mov    $0x0,%esi
  8014af:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8014b5:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8014b7:	48 85 c0             	test   %rax,%rax
  8014ba:	7f 06                	jg     8014c2 <sys_env_set_trapframe+0x3a>
}
  8014bc:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014c0:	c9                   	leave
  8014c1:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8014c2:	49 89 c0             	mov    %rax,%r8
  8014c5:	b9 0b 00 00 00       	mov    $0xb,%ecx
  8014ca:	48 ba 38 43 80 00 00 	movabs $0x804338,%rdx
  8014d1:	00 00 00 
  8014d4:	be 26 00 00 00       	mov    $0x26,%esi
  8014d9:	48 bf c9 41 80 00 00 	movabs $0x8041c9,%rdi
  8014e0:	00 00 00 
  8014e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8014e8:	49 b9 b0 2e 80 00 00 	movabs $0x802eb0,%r9
  8014ef:	00 00 00 
  8014f2:	41 ff d1             	call   *%r9

00000000008014f5 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  8014f5:	f3 0f 1e fa          	endbr64
  8014f9:	55                   	push   %rbp
  8014fa:	48 89 e5             	mov    %rsp,%rbp
  8014fd:	53                   	push   %rbx
  8014fe:	48 83 ec 08          	sub    $0x8,%rsp
  801502:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  801505:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801508:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80150d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801512:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801517:	be 00 00 00 00       	mov    $0x0,%esi
  80151c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801522:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801524:	48 85 c0             	test   %rax,%rax
  801527:	7f 06                	jg     80152f <sys_env_set_pgfault_upcall+0x3a>
}
  801529:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80152d:	c9                   	leave
  80152e:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80152f:	49 89 c0             	mov    %rax,%r8
  801532:	b9 0c 00 00 00       	mov    $0xc,%ecx
  801537:	48 ba 38 43 80 00 00 	movabs $0x804338,%rdx
  80153e:	00 00 00 
  801541:	be 26 00 00 00       	mov    $0x26,%esi
  801546:	48 bf c9 41 80 00 00 	movabs $0x8041c9,%rdi
  80154d:	00 00 00 
  801550:	b8 00 00 00 00       	mov    $0x0,%eax
  801555:	49 b9 b0 2e 80 00 00 	movabs $0x802eb0,%r9
  80155c:	00 00 00 
  80155f:	41 ff d1             	call   *%r9

0000000000801562 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  801562:	f3 0f 1e fa          	endbr64
  801566:	55                   	push   %rbp
  801567:	48 89 e5             	mov    %rsp,%rbp
  80156a:	53                   	push   %rbx
  80156b:	89 f8                	mov    %edi,%eax
  80156d:	49 89 f1             	mov    %rsi,%r9
  801570:	48 89 d3             	mov    %rdx,%rbx
  801573:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  801576:	49 63 f0             	movslq %r8d,%rsi
  801579:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80157c:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801581:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801584:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80158a:	cd 30                	int    $0x30
}
  80158c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801590:	c9                   	leave
  801591:	c3                   	ret

0000000000801592 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  801592:	f3 0f 1e fa          	endbr64
  801596:	55                   	push   %rbp
  801597:	48 89 e5             	mov    %rsp,%rbp
  80159a:	53                   	push   %rbx
  80159b:	48 83 ec 08          	sub    $0x8,%rsp
  80159f:	48 89 fa             	mov    %rdi,%rdx
  8015a2:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8015a5:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8015aa:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015af:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8015b4:	be 00 00 00 00       	mov    $0x0,%esi
  8015b9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8015bf:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8015c1:	48 85 c0             	test   %rax,%rax
  8015c4:	7f 06                	jg     8015cc <sys_ipc_recv+0x3a>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  8015c6:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8015ca:	c9                   	leave
  8015cb:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8015cc:	49 89 c0             	mov    %rax,%r8
  8015cf:	b9 0f 00 00 00       	mov    $0xf,%ecx
  8015d4:	48 ba 38 43 80 00 00 	movabs $0x804338,%rdx
  8015db:	00 00 00 
  8015de:	be 26 00 00 00       	mov    $0x26,%esi
  8015e3:	48 bf c9 41 80 00 00 	movabs $0x8041c9,%rdi
  8015ea:	00 00 00 
  8015ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8015f2:	49 b9 b0 2e 80 00 00 	movabs $0x802eb0,%r9
  8015f9:	00 00 00 
  8015fc:	41 ff d1             	call   *%r9

00000000008015ff <sys_gettime>:

int
sys_gettime(void) {
  8015ff:	f3 0f 1e fa          	endbr64
  801603:	55                   	push   %rbp
  801604:	48 89 e5             	mov    %rsp,%rbp
  801607:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801608:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80160d:	ba 00 00 00 00       	mov    $0x0,%edx
  801612:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801617:	bb 00 00 00 00       	mov    $0x0,%ebx
  80161c:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801621:	be 00 00 00 00       	mov    $0x0,%esi
  801626:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80162c:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  80162e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801632:	c9                   	leave
  801633:	c3                   	ret

0000000000801634 <fork>:
 *   Use sys_map_region, it can perform address space copying in one call
 *   Don't forget to set page fault handler in the child (using sys_env_set_pgfault_upcall()).
 *   Remember to fix "thisenv" in the child process.
 */
envid_t
fork(void) {
  801634:	f3 0f 1e fa          	endbr64
  801638:	55                   	push   %rbp
  801639:	48 89 e5             	mov    %rsp,%rbp
  80163c:	41 56                	push   %r14
  80163e:	41 55                	push   %r13
  801640:	41 54                	push   %r12
  801642:	53                   	push   %rbx
    // LAB 9: Your code here.
    bool has_pgfault_upcall = thisenv->env_pgfault_upcall;
  801643:	48 a1 08 60 80 00 00 	movabs 0x806008,%rax
  80164a:	00 00 00 
  80164d:	4c 8b b0 00 01 00 00 	mov    0x100(%rax),%r14

/* This must be inlined. Exercise for reader: why? */
static inline envid_t __attribute__((always_inline))
sys_exofork(void) {
    envid_t ret;
    asm volatile("int %2"
  801654:	b8 09 00 00 00       	mov    $0x9,%eax
  801659:	cd 30                	int    $0x30
  80165b:	41 89 c4             	mov    %eax,%r12d

    envid_t envid = sys_exofork();
    if (envid < 0) {
  80165e:	85 c0                	test   %eax,%eax
  801660:	78 7f                	js     8016e1 <fork+0xad>
  801662:	89 c3                	mov    %eax,%ebx
        return envid;
    }
    if (envid == 0) {
  801664:	0f 84 83 00 00 00    	je     8016ed <fork+0xb9>
        thisenv = &envs[ENVX(sys_getenvid())];
        return 0;
    }
    int res = sys_map_region(CURENVID, NULL, envid, NULL, MAX_USER_ADDRESS, PROT_ALL | PROT_LAZY | PROT_COMBINE);
  80166a:	41 b9 ff 0f 00 00    	mov    $0xfff,%r9d
  801670:	49 b8 00 00 00 00 80 	movabs $0x8000000000,%r8
  801677:	00 00 00 
  80167a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80167f:	89 c2                	mov    %eax,%edx
  801681:	be 00 00 00 00       	mov    $0x0,%esi
  801686:	bf 00 00 00 00       	mov    $0x0,%edi
  80168b:	48 b8 db 12 80 00 00 	movabs $0x8012db,%rax
  801692:	00 00 00 
  801695:	ff d0                	call   *%rax
  801697:	41 89 c5             	mov    %eax,%r13d
    if (res < 0) {
  80169a:	85 c0                	test   %eax,%eax
  80169c:	0f 88 81 00 00 00    	js     801723 <fork+0xef>
        sys_env_destroy(envid);
        return res;
    }
    if (has_pgfault_upcall) {
  8016a2:	4d 85 f6             	test   %r14,%r14
  8016a5:	74 20                	je     8016c7 <fork+0x93>
        res = sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  8016a7:	48 be 57 2f 80 00 00 	movabs $0x802f57,%rsi
  8016ae:	00 00 00 
  8016b1:	44 89 e7             	mov    %r12d,%edi
  8016b4:	48 b8 f5 14 80 00 00 	movabs $0x8014f5,%rax
  8016bb:	00 00 00 
  8016be:	ff d0                	call   *%rax
  8016c0:	41 89 c5             	mov    %eax,%r13d
        if (res < 0) {
  8016c3:	85 c0                	test   %eax,%eax
  8016c5:	78 70                	js     801737 <fork+0x103>
            sys_env_destroy(envid);
            return res;
        }
    }
    res = sys_env_set_status(envid, ENV_RUNNABLE);
  8016c7:	be 02 00 00 00       	mov    $0x2,%esi
  8016cc:	89 df                	mov    %ebx,%edi
  8016ce:	48 b8 1b 14 80 00 00 	movabs $0x80141b,%rax
  8016d5:	00 00 00 
  8016d8:	ff d0                	call   *%rax
  8016da:	41 89 c5             	mov    %eax,%r13d
    if (res < 0) {
  8016dd:	85 c0                	test   %eax,%eax
  8016df:	78 6a                	js     80174b <fork+0x117>
        sys_env_destroy(envid);
        return res;
    }
    return envid;
}
  8016e1:	44 89 e0             	mov    %r12d,%eax
  8016e4:	5b                   	pop    %rbx
  8016e5:	41 5c                	pop    %r12
  8016e7:	41 5d                	pop    %r13
  8016e9:	41 5e                	pop    %r14
  8016eb:	5d                   	pop    %rbp
  8016ec:	c3                   	ret
        thisenv = &envs[ENVX(sys_getenvid())];
  8016ed:	48 b8 a0 11 80 00 00 	movabs $0x8011a0,%rax
  8016f4:	00 00 00 
  8016f7:	ff d0                	call   *%rax
  8016f9:	25 ff 03 00 00       	and    $0x3ff,%eax
  8016fe:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  801702:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  801706:	48 c1 e0 04          	shl    $0x4,%rax
  80170a:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  801711:	00 00 00 
  801714:	48 01 d0             	add    %rdx,%rax
  801717:	48 a3 08 60 80 00 00 	movabs %rax,0x806008
  80171e:	00 00 00 
        return 0;
  801721:	eb be                	jmp    8016e1 <fork+0xad>
        sys_env_destroy(envid);
  801723:	44 89 e7             	mov    %r12d,%edi
  801726:	48 b8 31 11 80 00 00 	movabs $0x801131,%rax
  80172d:	00 00 00 
  801730:	ff d0                	call   *%rax
        return res;
  801732:	45 89 ec             	mov    %r13d,%r12d
  801735:	eb aa                	jmp    8016e1 <fork+0xad>
            sys_env_destroy(envid);
  801737:	44 89 e7             	mov    %r12d,%edi
  80173a:	48 b8 31 11 80 00 00 	movabs $0x801131,%rax
  801741:	00 00 00 
  801744:	ff d0                	call   *%rax
            return res;
  801746:	45 89 ec             	mov    %r13d,%r12d
  801749:	eb 96                	jmp    8016e1 <fork+0xad>
        sys_env_destroy(envid);
  80174b:	89 df                	mov    %ebx,%edi
  80174d:	48 b8 31 11 80 00 00 	movabs $0x801131,%rax
  801754:	00 00 00 
  801757:	ff d0                	call   *%rax
        return res;
  801759:	45 89 ec             	mov    %r13d,%r12d
  80175c:	eb 83                	jmp    8016e1 <fork+0xad>

000000000080175e <sfork>:

envid_t
sfork() {
  80175e:	f3 0f 1e fa          	endbr64
  801762:	55                   	push   %rbp
  801763:	48 89 e5             	mov    %rsp,%rbp
    panic("sfork() is not implemented");
  801766:	48 ba d7 41 80 00 00 	movabs $0x8041d7,%rdx
  80176d:	00 00 00 
  801770:	be 37 00 00 00       	mov    $0x37,%esi
  801775:	48 bf f2 41 80 00 00 	movabs $0x8041f2,%rdi
  80177c:	00 00 00 
  80177f:	b8 00 00 00 00       	mov    $0x0,%eax
  801784:	48 b9 b0 2e 80 00 00 	movabs $0x802eb0,%rcx
  80178b:	00 00 00 
  80178e:	ff d1                	call   *%rcx

0000000000801790 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  801790:	f3 0f 1e fa          	endbr64
  801794:	55                   	push   %rbp
  801795:	48 89 e5             	mov    %rsp,%rbp
  801798:	41 54                	push   %r12
  80179a:	53                   	push   %rbx
  80179b:	48 89 fb             	mov    %rdi,%rbx
  80179e:	48 89 f7             	mov    %rsi,%rdi
  8017a1:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  8017a4:	48 85 f6             	test   %rsi,%rsi
  8017a7:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  8017ae:	00 00 00 
  8017b1:	48 0f 44 f8          	cmove  %rax,%rdi
    }
    int res = sys_ipc_recv(pg, PAGE_SIZE);
  8017b5:	be 00 10 00 00       	mov    $0x1000,%esi
  8017ba:	48 b8 92 15 80 00 00 	movabs $0x801592,%rax
  8017c1:	00 00 00 
  8017c4:	ff d0                	call   *%rax
    if (res < 0) {
  8017c6:	85 c0                	test   %eax,%eax
  8017c8:	78 45                	js     80180f <ipc_recv+0x7f>
        if (perm_store != NULL) {
            *perm_store = 0;
        }
        return res;
    } else {
        if (from_env_store != NULL) {
  8017ca:	48 85 db             	test   %rbx,%rbx
  8017cd:	74 12                	je     8017e1 <ipc_recv+0x51>
            *from_env_store = thisenv->env_ipc_from;
  8017cf:	48 a1 08 60 80 00 00 	movabs 0x806008,%rax
  8017d6:	00 00 00 
  8017d9:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  8017df:	89 03                	mov    %eax,(%rbx)
        }
        if (perm_store != NULL) {
  8017e1:	4d 85 e4             	test   %r12,%r12
  8017e4:	74 14                	je     8017fa <ipc_recv+0x6a>
            *perm_store = thisenv->env_ipc_perm;
  8017e6:	48 a1 08 60 80 00 00 	movabs 0x806008,%rax
  8017ed:	00 00 00 
  8017f0:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  8017f6:	41 89 04 24          	mov    %eax,(%r12)
        }
        return thisenv->env_ipc_value;
  8017fa:	48 a1 08 60 80 00 00 	movabs 0x806008,%rax
  801801:	00 00 00 
  801804:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
    }
    return -1;
}
  80180a:	5b                   	pop    %rbx
  80180b:	41 5c                	pop    %r12
  80180d:	5d                   	pop    %rbp
  80180e:	c3                   	ret
        if (from_env_store != NULL) {
  80180f:	48 85 db             	test   %rbx,%rbx
  801812:	74 06                	je     80181a <ipc_recv+0x8a>
            *from_env_store = 0;
  801814:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store != NULL) {
  80181a:	4d 85 e4             	test   %r12,%r12
  80181d:	74 eb                	je     80180a <ipc_recv+0x7a>
            *perm_store = 0;
  80181f:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  801826:	00 
  801827:	eb e1                	jmp    80180a <ipc_recv+0x7a>

0000000000801829 <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  801829:	f3 0f 1e fa          	endbr64
  80182d:	55                   	push   %rbp
  80182e:	48 89 e5             	mov    %rsp,%rbp
  801831:	41 57                	push   %r15
  801833:	41 56                	push   %r14
  801835:	41 55                	push   %r13
  801837:	41 54                	push   %r12
  801839:	53                   	push   %rbx
  80183a:	48 83 ec 18          	sub    $0x18,%rsp
  80183e:	89 7d c4             	mov    %edi,-0x3c(%rbp)
  801841:	48 89 d3             	mov    %rdx,%rbx
  801844:	49 89 cc             	mov    %rcx,%r12
  801847:	45 89 c5             	mov    %r8d,%r13d
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  80184a:	48 85 d2             	test   %rdx,%rdx
  80184d:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  801854:	00 00 00 
  801857:	48 0f 44 d8          	cmove  %rax,%rbx
    }
    int res = sys_ipc_try_send(to_env, val, pg, size, perm);
  80185b:	89 f0                	mov    %esi,%eax
  80185d:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  801861:	48 89 da             	mov    %rbx,%rdx
  801864:	48 89 c6             	mov    %rax,%rsi
  801867:	48 b8 62 15 80 00 00 	movabs $0x801562,%rax
  80186e:	00 00 00 
  801871:	ff d0                	call   *%rax
    while (res < 0) {
  801873:	85 c0                	test   %eax,%eax
  801875:	79 65                	jns    8018dc <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  801877:	83 f8 f5             	cmp    $0xfffffff5,%eax
  80187a:	75 33                	jne    8018af <ipc_send+0x86>
            panic("Error: %i\n", res);
        }
        sys_yield();
  80187c:	49 bf d5 11 80 00 00 	movabs $0x8011d5,%r15
  801883:	00 00 00 
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  801886:	49 be 62 15 80 00 00 	movabs $0x801562,%r14
  80188d:	00 00 00 
        sys_yield();
  801890:	41 ff d7             	call   *%r15
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  801893:	45 89 e8             	mov    %r13d,%r8d
  801896:	4c 89 e1             	mov    %r12,%rcx
  801899:	48 89 da             	mov    %rbx,%rdx
  80189c:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  8018a0:	8b 7d c4             	mov    -0x3c(%rbp),%edi
  8018a3:	41 ff d6             	call   *%r14
    while (res < 0) {
  8018a6:	85 c0                	test   %eax,%eax
  8018a8:	79 32                	jns    8018dc <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  8018aa:	83 f8 f5             	cmp    $0xfffffff5,%eax
  8018ad:	74 e1                	je     801890 <ipc_send+0x67>
            panic("Error: %i\n", res);
  8018af:	89 c1                	mov    %eax,%ecx
  8018b1:	48 ba fd 41 80 00 00 	movabs $0x8041fd,%rdx
  8018b8:	00 00 00 
  8018bb:	be 42 00 00 00       	mov    $0x42,%esi
  8018c0:	48 bf 08 42 80 00 00 	movabs $0x804208,%rdi
  8018c7:	00 00 00 
  8018ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8018cf:	49 b8 b0 2e 80 00 00 	movabs $0x802eb0,%r8
  8018d6:	00 00 00 
  8018d9:	41 ff d0             	call   *%r8
    }
}
  8018dc:	48 83 c4 18          	add    $0x18,%rsp
  8018e0:	5b                   	pop    %rbx
  8018e1:	41 5c                	pop    %r12
  8018e3:	41 5d                	pop    %r13
  8018e5:	41 5e                	pop    %r14
  8018e7:	41 5f                	pop    %r15
  8018e9:	5d                   	pop    %rbp
  8018ea:	c3                   	ret

00000000008018eb <ipc_find_env>:

/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
  8018eb:	f3 0f 1e fa          	endbr64
    for (size_t i = 0; i < NENV; i++)
  8018ef:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  8018f4:	48 b9 00 00 a0 1f 80 	movabs $0x801fa00000,%rcx
  8018fb:	00 00 00 
  8018fe:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  801902:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  801906:	48 c1 e2 04          	shl    $0x4,%rdx
  80190a:	48 01 ca             	add    %rcx,%rdx
  80190d:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  801913:	39 fa                	cmp    %edi,%edx
  801915:	74 12                	je     801929 <ipc_find_env+0x3e>
    for (size_t i = 0; i < NENV; i++)
  801917:	48 83 c0 01          	add    $0x1,%rax
  80191b:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  801921:	75 db                	jne    8018fe <ipc_find_env+0x13>
            return envs[i].env_id;
    return 0;
  801923:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801928:	c3                   	ret
            return envs[i].env_id;
  801929:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  80192d:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  801931:	48 c1 e2 04          	shl    $0x4,%rdx
  801935:	48 b8 00 00 a0 1f 80 	movabs $0x801fa00000,%rax
  80193c:	00 00 00 
  80193f:	48 01 d0             	add    %rdx,%rax
  801942:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801948:	c3                   	ret

0000000000801949 <fd2num>:


/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
  801949:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80194d:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801954:	ff ff ff 
  801957:	48 01 f8             	add    %rdi,%rax
  80195a:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80195e:	c3                   	ret

000000000080195f <fd2data>:

char *
fd2data(struct Fd *fd) {
  80195f:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801963:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80196a:	ff ff ff 
  80196d:	48 01 f8             	add    %rdi,%rax
  801970:	48 c1 e8 0c          	shr    $0xc,%rax
    return INDEX2DATA(fd2num(fd));
  801974:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80197a:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80197e:	c3                   	ret

000000000080197f <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  80197f:	f3 0f 1e fa          	endbr64
  801983:	55                   	push   %rbp
  801984:	48 89 e5             	mov    %rsp,%rbp
  801987:	41 57                	push   %r15
  801989:	41 56                	push   %r14
  80198b:	41 55                	push   %r13
  80198d:	41 54                	push   %r12
  80198f:	53                   	push   %rbx
  801990:	48 83 ec 08          	sub    $0x8,%rsp
  801994:	49 89 ff             	mov    %rdi,%r15
  801997:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  80199c:	49 bd de 2a 80 00 00 	movabs $0x802ade,%r13
  8019a3:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  8019a6:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        struct Fd *fd = INDEX2FD(i);
  8019ac:	49 89 dc             	mov    %rbx,%r12
        if (!(get_prot(fd) & PROT_R)) {
  8019af:	48 89 df             	mov    %rbx,%rdi
  8019b2:	41 ff d5             	call   *%r13
  8019b5:	83 e0 04             	and    $0x4,%eax
  8019b8:	74 17                	je     8019d1 <fd_alloc+0x52>
    for (int i = 0; i < MAXFD; i++) {
  8019ba:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  8019c1:	4c 39 f3             	cmp    %r14,%rbx
  8019c4:	75 e6                	jne    8019ac <fd_alloc+0x2d>
  8019c6:	41 bc 00 00 00 00    	mov    $0x0,%r12d
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
    return -E_MAX_OPEN;
  8019cc:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
            *fd_store = fd;
  8019d1:	4d 89 27             	mov    %r12,(%r15)
}
  8019d4:	48 83 c4 08          	add    $0x8,%rsp
  8019d8:	5b                   	pop    %rbx
  8019d9:	41 5c                	pop    %r12
  8019db:	41 5d                	pop    %r13
  8019dd:	41 5e                	pop    %r14
  8019df:	41 5f                	pop    %r15
  8019e1:	5d                   	pop    %rbp
  8019e2:	c3                   	ret

00000000008019e3 <fd_lookup>:
 *
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
  8019e3:	f3 0f 1e fa          	endbr64
    if (fdnum < 0 || fdnum >= MAXFD) {
  8019e7:	83 ff 1f             	cmp    $0x1f,%edi
  8019ea:	77 39                	ja     801a25 <fd_lookup+0x42>
fd_lookup(int fdnum, struct Fd **fd_store) {
  8019ec:	55                   	push   %rbp
  8019ed:	48 89 e5             	mov    %rsp,%rbp
  8019f0:	41 54                	push   %r12
  8019f2:	53                   	push   %rbx
  8019f3:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  8019f6:	48 63 df             	movslq %edi,%rbx
  8019f9:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  801a00:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  801a04:	48 89 df             	mov    %rbx,%rdi
  801a07:	48 b8 de 2a 80 00 00 	movabs $0x802ade,%rax
  801a0e:	00 00 00 
  801a11:	ff d0                	call   *%rax
  801a13:	a8 04                	test   $0x4,%al
  801a15:	74 14                	je     801a2b <fd_lookup+0x48>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  801a17:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  801a1b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a20:	5b                   	pop    %rbx
  801a21:	41 5c                	pop    %r12
  801a23:	5d                   	pop    %rbp
  801a24:	c3                   	ret
        return -E_INVAL;
  801a25:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801a2a:	c3                   	ret
        return -E_INVAL;
  801a2b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a30:	eb ee                	jmp    801a20 <fd_lookup+0x3d>

0000000000801a32 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  801a32:	f3 0f 1e fa          	endbr64
  801a36:	55                   	push   %rbp
  801a37:	48 89 e5             	mov    %rsp,%rbp
  801a3a:	41 54                	push   %r12
  801a3c:	53                   	push   %rbx
  801a3d:	49 89 f4             	mov    %rsi,%r12
    for (size_t i = 0; devtab[i]; i++) {
  801a40:	48 b8 80 47 80 00 00 	movabs $0x804780,%rax
  801a47:	00 00 00 
  801a4a:	48 bb 20 50 80 00 00 	movabs $0x805020,%rbx
  801a51:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  801a54:	39 3b                	cmp    %edi,(%rbx)
  801a56:	74 47                	je     801a9f <dev_lookup+0x6d>
    for (size_t i = 0; devtab[i]; i++) {
  801a58:	48 83 c0 08          	add    $0x8,%rax
  801a5c:	48 8b 18             	mov    (%rax),%rbx
  801a5f:	48 85 db             	test   %rbx,%rbx
  801a62:	75 f0                	jne    801a54 <dev_lookup+0x22>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801a64:	48 a1 08 60 80 00 00 	movabs 0x806008,%rax
  801a6b:	00 00 00 
  801a6e:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801a74:	89 fa                	mov    %edi,%edx
  801a76:	48 bf 58 43 80 00 00 	movabs $0x804358,%rdi
  801a7d:	00 00 00 
  801a80:	b8 00 00 00 00       	mov    $0x0,%eax
  801a85:	48 b9 22 03 80 00 00 	movabs $0x800322,%rcx
  801a8c:	00 00 00 
  801a8f:	ff d1                	call   *%rcx
    *dev = 0;
    return -E_INVAL;
  801a91:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
            *dev = devtab[i];
  801a96:	49 89 1c 24          	mov    %rbx,(%r12)
}
  801a9a:	5b                   	pop    %rbx
  801a9b:	41 5c                	pop    %r12
  801a9d:	5d                   	pop    %rbp
  801a9e:	c3                   	ret
            return 0;
  801a9f:	b8 00 00 00 00       	mov    $0x0,%eax
  801aa4:	eb f0                	jmp    801a96 <dev_lookup+0x64>

0000000000801aa6 <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  801aa6:	f3 0f 1e fa          	endbr64
  801aaa:	55                   	push   %rbp
  801aab:	48 89 e5             	mov    %rsp,%rbp
  801aae:	41 55                	push   %r13
  801ab0:	41 54                	push   %r12
  801ab2:	53                   	push   %rbx
  801ab3:	48 83 ec 18          	sub    $0x18,%rsp
  801ab7:	48 89 fb             	mov    %rdi,%rbx
  801aba:	41 89 f4             	mov    %esi,%r12d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801abd:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  801ac4:	ff ff ff 
  801ac7:	48 01 df             	add    %rbx,%rdi
  801aca:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  801ace:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801ad2:	48 b8 e3 19 80 00 00 	movabs $0x8019e3,%rax
  801ad9:	00 00 00 
  801adc:	ff d0                	call   *%rax
  801ade:	41 89 c5             	mov    %eax,%r13d
  801ae1:	85 c0                	test   %eax,%eax
  801ae3:	78 06                	js     801aeb <fd_close+0x45>
  801ae5:	48 39 5d d8          	cmp    %rbx,-0x28(%rbp)
  801ae9:	74 1a                	je     801b05 <fd_close+0x5f>
        return (must_exist ? res : 0);
  801aeb:	45 84 e4             	test   %r12b,%r12b
  801aee:	b8 00 00 00 00       	mov    $0x0,%eax
  801af3:	44 0f 44 e8          	cmove  %eax,%r13d
}
  801af7:	44 89 e8             	mov    %r13d,%eax
  801afa:	48 83 c4 18          	add    $0x18,%rsp
  801afe:	5b                   	pop    %rbx
  801aff:	41 5c                	pop    %r12
  801b01:	41 5d                	pop    %r13
  801b03:	5d                   	pop    %rbp
  801b04:	c3                   	ret
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801b05:	8b 3b                	mov    (%rbx),%edi
  801b07:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801b0b:	48 b8 32 1a 80 00 00 	movabs $0x801a32,%rax
  801b12:	00 00 00 
  801b15:	ff d0                	call   *%rax
  801b17:	41 89 c5             	mov    %eax,%r13d
  801b1a:	85 c0                	test   %eax,%eax
  801b1c:	78 1b                	js     801b39 <fd_close+0x93>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  801b1e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b22:	48 8b 40 20          	mov    0x20(%rax),%rax
  801b26:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  801b2c:	48 85 c0             	test   %rax,%rax
  801b2f:	74 08                	je     801b39 <fd_close+0x93>
  801b31:	48 89 df             	mov    %rbx,%rdi
  801b34:	ff d0                	call   *%rax
  801b36:	41 89 c5             	mov    %eax,%r13d
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801b39:	ba 00 10 00 00       	mov    $0x1000,%edx
  801b3e:	48 89 de             	mov    %rbx,%rsi
  801b41:	bf 00 00 00 00       	mov    $0x0,%edi
  801b46:	48 b8 b0 13 80 00 00 	movabs $0x8013b0,%rax
  801b4d:	00 00 00 
  801b50:	ff d0                	call   *%rax
    return res;
  801b52:	eb a3                	jmp    801af7 <fd_close+0x51>

0000000000801b54 <close>:

int
close(int fdnum) {
  801b54:	f3 0f 1e fa          	endbr64
  801b58:	55                   	push   %rbp
  801b59:	48 89 e5             	mov    %rsp,%rbp
  801b5c:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  801b60:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801b64:	48 b8 e3 19 80 00 00 	movabs $0x8019e3,%rax
  801b6b:	00 00 00 
  801b6e:	ff d0                	call   *%rax
    if (res < 0) return res;
  801b70:	85 c0                	test   %eax,%eax
  801b72:	78 15                	js     801b89 <close+0x35>

    return fd_close(fd, 1);
  801b74:	be 01 00 00 00       	mov    $0x1,%esi
  801b79:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801b7d:	48 b8 a6 1a 80 00 00 	movabs $0x801aa6,%rax
  801b84:	00 00 00 
  801b87:	ff d0                	call   *%rax
}
  801b89:	c9                   	leave
  801b8a:	c3                   	ret

0000000000801b8b <close_all>:

void
close_all(void) {
  801b8b:	f3 0f 1e fa          	endbr64
  801b8f:	55                   	push   %rbp
  801b90:	48 89 e5             	mov    %rsp,%rbp
  801b93:	41 54                	push   %r12
  801b95:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  801b96:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b9b:	49 bc 54 1b 80 00 00 	movabs $0x801b54,%r12
  801ba2:	00 00 00 
  801ba5:	89 df                	mov    %ebx,%edi
  801ba7:	41 ff d4             	call   *%r12
  801baa:	83 c3 01             	add    $0x1,%ebx
  801bad:	83 fb 20             	cmp    $0x20,%ebx
  801bb0:	75 f3                	jne    801ba5 <close_all+0x1a>
}
  801bb2:	5b                   	pop    %rbx
  801bb3:	41 5c                	pop    %r12
  801bb5:	5d                   	pop    %rbp
  801bb6:	c3                   	ret

0000000000801bb7 <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  801bb7:	f3 0f 1e fa          	endbr64
  801bbb:	55                   	push   %rbp
  801bbc:	48 89 e5             	mov    %rsp,%rbp
  801bbf:	41 57                	push   %r15
  801bc1:	41 56                	push   %r14
  801bc3:	41 55                	push   %r13
  801bc5:	41 54                	push   %r12
  801bc7:	53                   	push   %rbx
  801bc8:	48 83 ec 18          	sub    $0x18,%rsp
  801bcc:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  801bcf:	48 8d 75 c8          	lea    -0x38(%rbp),%rsi
  801bd3:	48 b8 e3 19 80 00 00 	movabs $0x8019e3,%rax
  801bda:	00 00 00 
  801bdd:	ff d0                	call   *%rax
  801bdf:	89 c3                	mov    %eax,%ebx
  801be1:	85 c0                	test   %eax,%eax
  801be3:	0f 88 b8 00 00 00    	js     801ca1 <dup+0xea>
    close(newfdnum);
  801be9:	44 89 e7             	mov    %r12d,%edi
  801bec:	48 b8 54 1b 80 00 00 	movabs $0x801b54,%rax
  801bf3:	00 00 00 
  801bf6:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  801bf8:	4d 63 ec             	movslq %r12d,%r13
  801bfb:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  801c02:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  801c06:	4c 8b 7d c8          	mov    -0x38(%rbp),%r15
  801c0a:	4c 89 ff             	mov    %r15,%rdi
  801c0d:	49 be 5f 19 80 00 00 	movabs $0x80195f,%r14
  801c14:	00 00 00 
  801c17:	41 ff d6             	call   *%r14
  801c1a:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  801c1d:	4c 89 ef             	mov    %r13,%rdi
  801c20:	41 ff d6             	call   *%r14
  801c23:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  801c26:	48 89 df             	mov    %rbx,%rdi
  801c29:	48 b8 de 2a 80 00 00 	movabs $0x802ade,%rax
  801c30:	00 00 00 
  801c33:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  801c35:	a8 04                	test   $0x4,%al
  801c37:	74 2b                	je     801c64 <dup+0xad>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  801c39:	41 89 c1             	mov    %eax,%r9d
  801c3c:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801c42:	4c 89 f1             	mov    %r14,%rcx
  801c45:	ba 00 00 00 00       	mov    $0x0,%edx
  801c4a:	48 89 de             	mov    %rbx,%rsi
  801c4d:	bf 00 00 00 00       	mov    $0x0,%edi
  801c52:	48 b8 db 12 80 00 00 	movabs $0x8012db,%rax
  801c59:	00 00 00 
  801c5c:	ff d0                	call   *%rax
  801c5e:	89 c3                	mov    %eax,%ebx
  801c60:	85 c0                	test   %eax,%eax
  801c62:	78 4e                	js     801cb2 <dup+0xfb>
    }
    prot = get_prot(oldfd);
  801c64:	4c 89 ff             	mov    %r15,%rdi
  801c67:	48 b8 de 2a 80 00 00 	movabs $0x802ade,%rax
  801c6e:	00 00 00 
  801c71:	ff d0                	call   *%rax
  801c73:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  801c76:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801c7c:	4c 89 e9             	mov    %r13,%rcx
  801c7f:	ba 00 00 00 00       	mov    $0x0,%edx
  801c84:	4c 89 fe             	mov    %r15,%rsi
  801c87:	bf 00 00 00 00       	mov    $0x0,%edi
  801c8c:	48 b8 db 12 80 00 00 	movabs $0x8012db,%rax
  801c93:	00 00 00 
  801c96:	ff d0                	call   *%rax
  801c98:	89 c3                	mov    %eax,%ebx
  801c9a:	85 c0                	test   %eax,%eax
  801c9c:	78 14                	js     801cb2 <dup+0xfb>

    return newfdnum;
  801c9e:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  801ca1:	89 d8                	mov    %ebx,%eax
  801ca3:	48 83 c4 18          	add    $0x18,%rsp
  801ca7:	5b                   	pop    %rbx
  801ca8:	41 5c                	pop    %r12
  801caa:	41 5d                	pop    %r13
  801cac:	41 5e                	pop    %r14
  801cae:	41 5f                	pop    %r15
  801cb0:	5d                   	pop    %rbp
  801cb1:	c3                   	ret
    sys_unmap_region(0, newfd, PAGE_SIZE);
  801cb2:	ba 00 10 00 00       	mov    $0x1000,%edx
  801cb7:	4c 89 ee             	mov    %r13,%rsi
  801cba:	bf 00 00 00 00       	mov    $0x0,%edi
  801cbf:	49 bc b0 13 80 00 00 	movabs $0x8013b0,%r12
  801cc6:	00 00 00 
  801cc9:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  801ccc:	ba 00 10 00 00       	mov    $0x1000,%edx
  801cd1:	4c 89 f6             	mov    %r14,%rsi
  801cd4:	bf 00 00 00 00       	mov    $0x0,%edi
  801cd9:	41 ff d4             	call   *%r12
    return res;
  801cdc:	eb c3                	jmp    801ca1 <dup+0xea>

0000000000801cde <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  801cde:	f3 0f 1e fa          	endbr64
  801ce2:	55                   	push   %rbp
  801ce3:	48 89 e5             	mov    %rsp,%rbp
  801ce6:	41 56                	push   %r14
  801ce8:	41 55                	push   %r13
  801cea:	41 54                	push   %r12
  801cec:	53                   	push   %rbx
  801ced:	48 83 ec 10          	sub    $0x10,%rsp
  801cf1:	89 fb                	mov    %edi,%ebx
  801cf3:	49 89 f4             	mov    %rsi,%r12
  801cf6:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801cf9:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801cfd:	48 b8 e3 19 80 00 00 	movabs $0x8019e3,%rax
  801d04:	00 00 00 
  801d07:	ff d0                	call   *%rax
  801d09:	85 c0                	test   %eax,%eax
  801d0b:	78 4c                	js     801d59 <read+0x7b>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801d0d:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801d11:	41 8b 3e             	mov    (%r14),%edi
  801d14:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801d18:	48 b8 32 1a 80 00 00 	movabs $0x801a32,%rax
  801d1f:	00 00 00 
  801d22:	ff d0                	call   *%rax
  801d24:	85 c0                	test   %eax,%eax
  801d26:	78 35                	js     801d5d <read+0x7f>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801d28:	41 8b 46 08          	mov    0x8(%r14),%eax
  801d2c:	83 e0 03             	and    $0x3,%eax
  801d2f:	83 f8 01             	cmp    $0x1,%eax
  801d32:	74 2d                	je     801d61 <read+0x83>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  801d34:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d38:	48 8b 40 10          	mov    0x10(%rax),%rax
  801d3c:	48 85 c0             	test   %rax,%rax
  801d3f:	74 56                	je     801d97 <read+0xb9>

    return (*dev->dev_read)(fd, buf, n);
  801d41:	4c 89 ea             	mov    %r13,%rdx
  801d44:	4c 89 e6             	mov    %r12,%rsi
  801d47:	4c 89 f7             	mov    %r14,%rdi
  801d4a:	ff d0                	call   *%rax
}
  801d4c:	48 83 c4 10          	add    $0x10,%rsp
  801d50:	5b                   	pop    %rbx
  801d51:	41 5c                	pop    %r12
  801d53:	41 5d                	pop    %r13
  801d55:	41 5e                	pop    %r14
  801d57:	5d                   	pop    %rbp
  801d58:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801d59:	48 98                	cltq
  801d5b:	eb ef                	jmp    801d4c <read+0x6e>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801d5d:	48 98                	cltq
  801d5f:	eb eb                	jmp    801d4c <read+0x6e>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801d61:	48 a1 08 60 80 00 00 	movabs 0x806008,%rax
  801d68:	00 00 00 
  801d6b:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801d71:	89 da                	mov    %ebx,%edx
  801d73:	48 bf 12 42 80 00 00 	movabs $0x804212,%rdi
  801d7a:	00 00 00 
  801d7d:	b8 00 00 00 00       	mov    $0x0,%eax
  801d82:	48 b9 22 03 80 00 00 	movabs $0x800322,%rcx
  801d89:	00 00 00 
  801d8c:	ff d1                	call   *%rcx
        return -E_INVAL;
  801d8e:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801d95:	eb b5                	jmp    801d4c <read+0x6e>
    if (!dev->dev_read) return -E_NOT_SUPP;
  801d97:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801d9e:	eb ac                	jmp    801d4c <read+0x6e>

0000000000801da0 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801da0:	f3 0f 1e fa          	endbr64
  801da4:	55                   	push   %rbp
  801da5:	48 89 e5             	mov    %rsp,%rbp
  801da8:	41 57                	push   %r15
  801daa:	41 56                	push   %r14
  801dac:	41 55                	push   %r13
  801dae:	41 54                	push   %r12
  801db0:	53                   	push   %rbx
  801db1:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801db5:	48 85 d2             	test   %rdx,%rdx
  801db8:	74 54                	je     801e0e <readn+0x6e>
  801dba:	41 89 fd             	mov    %edi,%r13d
  801dbd:	49 89 f6             	mov    %rsi,%r14
  801dc0:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801dc3:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801dc8:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801dcd:	49 bf de 1c 80 00 00 	movabs $0x801cde,%r15
  801dd4:	00 00 00 
  801dd7:	4c 89 e2             	mov    %r12,%rdx
  801dda:	48 29 f2             	sub    %rsi,%rdx
  801ddd:	4c 01 f6             	add    %r14,%rsi
  801de0:	44 89 ef             	mov    %r13d,%edi
  801de3:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  801de6:	85 c0                	test   %eax,%eax
  801de8:	78 20                	js     801e0a <readn+0x6a>
    for (; inc && res < n; res += inc) {
  801dea:	01 c3                	add    %eax,%ebx
  801dec:	85 c0                	test   %eax,%eax
  801dee:	74 08                	je     801df8 <readn+0x58>
  801df0:	48 63 f3             	movslq %ebx,%rsi
  801df3:	4c 39 e6             	cmp    %r12,%rsi
  801df6:	72 df                	jb     801dd7 <readn+0x37>
    }
    return res;
  801df8:	48 63 c3             	movslq %ebx,%rax
}
  801dfb:	48 83 c4 08          	add    $0x8,%rsp
  801dff:	5b                   	pop    %rbx
  801e00:	41 5c                	pop    %r12
  801e02:	41 5d                	pop    %r13
  801e04:	41 5e                	pop    %r14
  801e06:	41 5f                	pop    %r15
  801e08:	5d                   	pop    %rbp
  801e09:	c3                   	ret
        if (inc < 0) return inc;
  801e0a:	48 98                	cltq
  801e0c:	eb ed                	jmp    801dfb <readn+0x5b>
    int inc = 1, res = 0;
  801e0e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e13:	eb e3                	jmp    801df8 <readn+0x58>

0000000000801e15 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  801e15:	f3 0f 1e fa          	endbr64
  801e19:	55                   	push   %rbp
  801e1a:	48 89 e5             	mov    %rsp,%rbp
  801e1d:	41 56                	push   %r14
  801e1f:	41 55                	push   %r13
  801e21:	41 54                	push   %r12
  801e23:	53                   	push   %rbx
  801e24:	48 83 ec 10          	sub    $0x10,%rsp
  801e28:	89 fb                	mov    %edi,%ebx
  801e2a:	49 89 f4             	mov    %rsi,%r12
  801e2d:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801e30:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801e34:	48 b8 e3 19 80 00 00 	movabs $0x8019e3,%rax
  801e3b:	00 00 00 
  801e3e:	ff d0                	call   *%rax
  801e40:	85 c0                	test   %eax,%eax
  801e42:	78 47                	js     801e8b <write+0x76>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801e44:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801e48:	41 8b 3e             	mov    (%r14),%edi
  801e4b:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801e4f:	48 b8 32 1a 80 00 00 	movabs $0x801a32,%rax
  801e56:	00 00 00 
  801e59:	ff d0                	call   *%rax
  801e5b:	85 c0                	test   %eax,%eax
  801e5d:	78 30                	js     801e8f <write+0x7a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801e5f:	41 f6 46 08 03       	testb  $0x3,0x8(%r14)
  801e64:	74 2d                	je     801e93 <write+0x7e>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801e66:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801e6a:	48 8b 40 18          	mov    0x18(%rax),%rax
  801e6e:	48 85 c0             	test   %rax,%rax
  801e71:	74 56                	je     801ec9 <write+0xb4>

    return (*dev->dev_write)(fd, buf, n);
  801e73:	4c 89 ea             	mov    %r13,%rdx
  801e76:	4c 89 e6             	mov    %r12,%rsi
  801e79:	4c 89 f7             	mov    %r14,%rdi
  801e7c:	ff d0                	call   *%rax
}
  801e7e:	48 83 c4 10          	add    $0x10,%rsp
  801e82:	5b                   	pop    %rbx
  801e83:	41 5c                	pop    %r12
  801e85:	41 5d                	pop    %r13
  801e87:	41 5e                	pop    %r14
  801e89:	5d                   	pop    %rbp
  801e8a:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801e8b:	48 98                	cltq
  801e8d:	eb ef                	jmp    801e7e <write+0x69>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801e8f:	48 98                	cltq
  801e91:	eb eb                	jmp    801e7e <write+0x69>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801e93:	48 a1 08 60 80 00 00 	movabs 0x806008,%rax
  801e9a:	00 00 00 
  801e9d:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801ea3:	89 da                	mov    %ebx,%edx
  801ea5:	48 bf 2e 42 80 00 00 	movabs $0x80422e,%rdi
  801eac:	00 00 00 
  801eaf:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb4:	48 b9 22 03 80 00 00 	movabs $0x800322,%rcx
  801ebb:	00 00 00 
  801ebe:	ff d1                	call   *%rcx
        return -E_INVAL;
  801ec0:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801ec7:	eb b5                	jmp    801e7e <write+0x69>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801ec9:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801ed0:	eb ac                	jmp    801e7e <write+0x69>

0000000000801ed2 <seek>:

int
seek(int fdnum, off_t offset) {
  801ed2:	f3 0f 1e fa          	endbr64
  801ed6:	55                   	push   %rbp
  801ed7:	48 89 e5             	mov    %rsp,%rbp
  801eda:	53                   	push   %rbx
  801edb:	48 83 ec 18          	sub    $0x18,%rsp
  801edf:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801ee1:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801ee5:	48 b8 e3 19 80 00 00 	movabs $0x8019e3,%rax
  801eec:	00 00 00 
  801eef:	ff d0                	call   *%rax
  801ef1:	85 c0                	test   %eax,%eax
  801ef3:	78 0c                	js     801f01 <seek+0x2f>

    fd->fd_offset = offset;
  801ef5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ef9:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  801efc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f01:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801f05:	c9                   	leave
  801f06:	c3                   	ret

0000000000801f07 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  801f07:	f3 0f 1e fa          	endbr64
  801f0b:	55                   	push   %rbp
  801f0c:	48 89 e5             	mov    %rsp,%rbp
  801f0f:	41 55                	push   %r13
  801f11:	41 54                	push   %r12
  801f13:	53                   	push   %rbx
  801f14:	48 83 ec 18          	sub    $0x18,%rsp
  801f18:	89 fb                	mov    %edi,%ebx
  801f1a:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801f1d:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801f21:	48 b8 e3 19 80 00 00 	movabs $0x8019e3,%rax
  801f28:	00 00 00 
  801f2b:	ff d0                	call   *%rax
  801f2d:	85 c0                	test   %eax,%eax
  801f2f:	78 38                	js     801f69 <ftruncate+0x62>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801f31:	4c 8b 6d d8          	mov    -0x28(%rbp),%r13
  801f35:	41 8b 7d 00          	mov    0x0(%r13),%edi
  801f39:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801f3d:	48 b8 32 1a 80 00 00 	movabs $0x801a32,%rax
  801f44:	00 00 00 
  801f47:	ff d0                	call   *%rax
  801f49:	85 c0                	test   %eax,%eax
  801f4b:	78 1c                	js     801f69 <ftruncate+0x62>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801f4d:	41 f6 45 08 03       	testb  $0x3,0x8(%r13)
  801f52:	74 20                	je     801f74 <ftruncate+0x6d>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801f54:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801f58:	48 8b 40 30          	mov    0x30(%rax),%rax
  801f5c:	48 85 c0             	test   %rax,%rax
  801f5f:	74 47                	je     801fa8 <ftruncate+0xa1>

    return (*dev->dev_trunc)(fd, newsize);
  801f61:	44 89 e6             	mov    %r12d,%esi
  801f64:	4c 89 ef             	mov    %r13,%rdi
  801f67:	ff d0                	call   *%rax
}
  801f69:	48 83 c4 18          	add    $0x18,%rsp
  801f6d:	5b                   	pop    %rbx
  801f6e:	41 5c                	pop    %r12
  801f70:	41 5d                	pop    %r13
  801f72:	5d                   	pop    %rbp
  801f73:	c3                   	ret
                thisenv->env_id, fdnum);
  801f74:	48 a1 08 60 80 00 00 	movabs 0x806008,%rax
  801f7b:	00 00 00 
  801f7e:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801f84:	89 da                	mov    %ebx,%edx
  801f86:	48 bf 78 43 80 00 00 	movabs $0x804378,%rdi
  801f8d:	00 00 00 
  801f90:	b8 00 00 00 00       	mov    $0x0,%eax
  801f95:	48 b9 22 03 80 00 00 	movabs $0x800322,%rcx
  801f9c:	00 00 00 
  801f9f:	ff d1                	call   *%rcx
        return -E_INVAL;
  801fa1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801fa6:	eb c1                	jmp    801f69 <ftruncate+0x62>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801fa8:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801fad:	eb ba                	jmp    801f69 <ftruncate+0x62>

0000000000801faf <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  801faf:	f3 0f 1e fa          	endbr64
  801fb3:	55                   	push   %rbp
  801fb4:	48 89 e5             	mov    %rsp,%rbp
  801fb7:	41 54                	push   %r12
  801fb9:	53                   	push   %rbx
  801fba:	48 83 ec 10          	sub    $0x10,%rsp
  801fbe:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801fc1:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801fc5:	48 b8 e3 19 80 00 00 	movabs $0x8019e3,%rax
  801fcc:	00 00 00 
  801fcf:	ff d0                	call   *%rax
  801fd1:	85 c0                	test   %eax,%eax
  801fd3:	78 4e                	js     802023 <fstat+0x74>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801fd5:	4c 8b 65 e8          	mov    -0x18(%rbp),%r12
  801fd9:	41 8b 3c 24          	mov    (%r12),%edi
  801fdd:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801fe1:	48 b8 32 1a 80 00 00 	movabs $0x801a32,%rax
  801fe8:	00 00 00 
  801feb:	ff d0                	call   *%rax
  801fed:	85 c0                	test   %eax,%eax
  801fef:	78 32                	js     802023 <fstat+0x74>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  801ff1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ff5:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  801ffa:	74 30                	je     80202c <fstat+0x7d>

    stat->st_name[0] = 0;
  801ffc:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  801fff:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  802006:	00 00 00 
    stat->st_isdir = 0;
  802009:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  802010:	00 00 00 
    stat->st_dev = dev;
  802013:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  80201a:	48 89 de             	mov    %rbx,%rsi
  80201d:	4c 89 e7             	mov    %r12,%rdi
  802020:	ff 50 28             	call   *0x28(%rax)
}
  802023:	48 83 c4 10          	add    $0x10,%rsp
  802027:	5b                   	pop    %rbx
  802028:	41 5c                	pop    %r12
  80202a:	5d                   	pop    %rbp
  80202b:	c3                   	ret
    if (!dev->dev_stat) return -E_NOT_SUPP;
  80202c:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  802031:	eb f0                	jmp    802023 <fstat+0x74>

0000000000802033 <stat>:

int
stat(const char *path, struct Stat *stat) {
  802033:	f3 0f 1e fa          	endbr64
  802037:	55                   	push   %rbp
  802038:	48 89 e5             	mov    %rsp,%rbp
  80203b:	41 54                	push   %r12
  80203d:	53                   	push   %rbx
  80203e:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  802041:	be 00 00 00 00       	mov    $0x0,%esi
  802046:	48 b8 14 23 80 00 00 	movabs $0x802314,%rax
  80204d:	00 00 00 
  802050:	ff d0                	call   *%rax
  802052:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  802054:	85 c0                	test   %eax,%eax
  802056:	78 25                	js     80207d <stat+0x4a>

    int res = fstat(fd, stat);
  802058:	4c 89 e6             	mov    %r12,%rsi
  80205b:	89 c7                	mov    %eax,%edi
  80205d:	48 b8 af 1f 80 00 00 	movabs $0x801faf,%rax
  802064:	00 00 00 
  802067:	ff d0                	call   *%rax
  802069:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  80206c:	89 df                	mov    %ebx,%edi
  80206e:	48 b8 54 1b 80 00 00 	movabs $0x801b54,%rax
  802075:	00 00 00 
  802078:	ff d0                	call   *%rax

    return res;
  80207a:	44 89 e3             	mov    %r12d,%ebx
}
  80207d:	89 d8                	mov    %ebx,%eax
  80207f:	5b                   	pop    %rbx
  802080:	41 5c                	pop    %r12
  802082:	5d                   	pop    %rbp
  802083:	c3                   	ret

0000000000802084 <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  802084:	f3 0f 1e fa          	endbr64
  802088:	55                   	push   %rbp
  802089:	48 89 e5             	mov    %rsp,%rbp
  80208c:	41 54                	push   %r12
  80208e:	53                   	push   %rbx
  80208f:	48 83 ec 10          	sub    $0x10,%rsp
  802093:	41 89 fc             	mov    %edi,%r12d
  802096:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  802099:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8020a0:	00 00 00 
  8020a3:	83 38 00             	cmpl   $0x0,(%rax)
  8020a6:	74 6e                	je     802116 <fsipc+0x92>

    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }
    fsenv = ipc_find_env(ENV_TYPE_FS);
  8020a8:	bf 03 00 00 00       	mov    $0x3,%edi
  8020ad:	48 b8 eb 18 80 00 00 	movabs $0x8018eb,%rax
  8020b4:	00 00 00 
  8020b7:	ff d0                	call   *%rax
  8020b9:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  8020c0:	00 00 
    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  8020c2:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  8020c8:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8020cd:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8020d4:	00 00 00 
  8020d7:	44 89 e6             	mov    %r12d,%esi
  8020da:	89 c7                	mov    %eax,%edi
  8020dc:	48 b8 29 18 80 00 00 	movabs $0x801829,%rax
  8020e3:	00 00 00 
  8020e6:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  8020e8:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  8020ef:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  8020f0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8020f5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8020f9:	48 89 de             	mov    %rbx,%rsi
  8020fc:	bf 00 00 00 00       	mov    $0x0,%edi
  802101:	48 b8 90 17 80 00 00 	movabs $0x801790,%rax
  802108:	00 00 00 
  80210b:	ff d0                	call   *%rax
}
  80210d:	48 83 c4 10          	add    $0x10,%rsp
  802111:	5b                   	pop    %rbx
  802112:	41 5c                	pop    %r12
  802114:	5d                   	pop    %rbp
  802115:	c3                   	ret
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  802116:	bf 03 00 00 00       	mov    $0x3,%edi
  80211b:	48 b8 eb 18 80 00 00 	movabs $0x8018eb,%rax
  802122:	00 00 00 
  802125:	ff d0                	call   *%rax
  802127:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  80212e:	00 00 
  802130:	e9 73 ff ff ff       	jmp    8020a8 <fsipc+0x24>

0000000000802135 <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  802135:	f3 0f 1e fa          	endbr64
  802139:	55                   	push   %rbp
  80213a:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80213d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802144:	00 00 00 
  802147:	8b 57 0c             	mov    0xc(%rdi),%edx
  80214a:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  80214c:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  80214f:	be 00 00 00 00       	mov    $0x0,%esi
  802154:	bf 02 00 00 00       	mov    $0x2,%edi
  802159:	48 b8 84 20 80 00 00 	movabs $0x802084,%rax
  802160:	00 00 00 
  802163:	ff d0                	call   *%rax
}
  802165:	5d                   	pop    %rbp
  802166:	c3                   	ret

0000000000802167 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  802167:	f3 0f 1e fa          	endbr64
  80216b:	55                   	push   %rbp
  80216c:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80216f:	8b 47 0c             	mov    0xc(%rdi),%eax
  802172:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  802179:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  80217b:	be 00 00 00 00       	mov    $0x0,%esi
  802180:	bf 06 00 00 00       	mov    $0x6,%edi
  802185:	48 b8 84 20 80 00 00 	movabs $0x802084,%rax
  80218c:	00 00 00 
  80218f:	ff d0                	call   *%rax
}
  802191:	5d                   	pop    %rbp
  802192:	c3                   	ret

0000000000802193 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  802193:	f3 0f 1e fa          	endbr64
  802197:	55                   	push   %rbp
  802198:	48 89 e5             	mov    %rsp,%rbp
  80219b:	41 54                	push   %r12
  80219d:	53                   	push   %rbx
  80219e:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8021a1:	8b 47 0c             	mov    0xc(%rdi),%eax
  8021a4:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  8021ab:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  8021ad:	be 00 00 00 00       	mov    $0x0,%esi
  8021b2:	bf 05 00 00 00       	mov    $0x5,%edi
  8021b7:	48 b8 84 20 80 00 00 	movabs $0x802084,%rax
  8021be:	00 00 00 
  8021c1:	ff d0                	call   *%rax
    if (res < 0) return res;
  8021c3:	85 c0                	test   %eax,%eax
  8021c5:	78 3d                	js     802204 <devfile_stat+0x71>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8021c7:	49 bc 00 70 80 00 00 	movabs $0x807000,%r12
  8021ce:	00 00 00 
  8021d1:	4c 89 e6             	mov    %r12,%rsi
  8021d4:	48 89 df             	mov    %rbx,%rdi
  8021d7:	48 b8 6b 0c 80 00 00 	movabs $0x800c6b,%rax
  8021de:	00 00 00 
  8021e1:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  8021e3:	41 8b 84 24 80 00 00 	mov    0x80(%r12),%eax
  8021ea:	00 
  8021eb:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8021f1:	41 8b 84 24 84 00 00 	mov    0x84(%r12),%eax
  8021f8:	00 
  8021f9:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  8021ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802204:	5b                   	pop    %rbx
  802205:	41 5c                	pop    %r12
  802207:	5d                   	pop    %rbp
  802208:	c3                   	ret

0000000000802209 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  802209:	f3 0f 1e fa          	endbr64
    if (n >= sizeof(fsipcbuf.write.req_buf)) {
  80220d:	48 81 fa ef 0f 00 00 	cmp    $0xfef,%rdx
  802214:	77 41                	ja     802257 <devfile_write+0x4e>
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  802216:	55                   	push   %rbp
  802217:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  80221a:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802221:	00 00 00 
  802224:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  802227:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.write.req_n = n;
  802229:	48 89 50 08          	mov    %rdx,0x8(%rax)
    memmove(fsipcbuf.write.req_buf, buf, n);
  80222d:	48 8d 78 10          	lea    0x10(%rax),%rdi
  802231:	48 b8 86 0e 80 00 00 	movabs $0x800e86,%rax
  802238:	00 00 00 
  80223b:	ff d0                	call   *%rax
    res = fsipc(FSREQ_WRITE, NULL);
  80223d:	be 00 00 00 00       	mov    $0x0,%esi
  802242:	bf 04 00 00 00       	mov    $0x4,%edi
  802247:	48 b8 84 20 80 00 00 	movabs $0x802084,%rax
  80224e:	00 00 00 
  802251:	ff d0                	call   *%rax
  802253:	48 98                	cltq
}
  802255:	5d                   	pop    %rbp
  802256:	c3                   	ret
        return -E_INVAL;
  802257:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
}
  80225e:	c3                   	ret

000000000080225f <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  80225f:	f3 0f 1e fa          	endbr64
  802263:	55                   	push   %rbp
  802264:	48 89 e5             	mov    %rsp,%rbp
  802267:	41 55                	push   %r13
  802269:	41 54                	push   %r12
  80226b:	53                   	push   %rbx
  80226c:	48 83 ec 08          	sub    $0x8,%rsp
  802270:	49 89 f4             	mov    %rsi,%r12
  802273:	48 89 d3             	mov    %rdx,%rbx
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  802276:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80227d:	00 00 00 
  802280:	8b 57 0c             	mov    0xc(%rdi),%edx
  802283:	89 10                	mov    %edx,(%rax)
    fsipcbuf.read.req_n = n;
  802285:	48 89 58 08          	mov    %rbx,0x8(%rax)
    res = fsipc(FSREQ_READ, NULL);
  802289:	be 00 00 00 00       	mov    $0x0,%esi
  80228e:	bf 03 00 00 00       	mov    $0x3,%edi
  802293:	48 b8 84 20 80 00 00 	movabs $0x802084,%rax
  80229a:	00 00 00 
  80229d:	ff d0                	call   *%rax
  80229f:	4c 63 e8             	movslq %eax,%r13
    if (res < 0) {
  8022a2:	4d 85 ed             	test   %r13,%r13
  8022a5:	78 2a                	js     8022d1 <devfile_read+0x72>
    assert(res <= n && res <= PAGE_SIZE);
  8022a7:	4c 89 ea             	mov    %r13,%rdx
  8022aa:	4c 39 eb             	cmp    %r13,%rbx
  8022ad:	72 30                	jb     8022df <devfile_read+0x80>
  8022af:	49 81 fd 00 10 00 00 	cmp    $0x1000,%r13
  8022b6:	7f 27                	jg     8022df <devfile_read+0x80>
    memmove(buf, &fsipcbuf, res);
  8022b8:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  8022bf:	00 00 00 
  8022c2:	4c 89 e7             	mov    %r12,%rdi
  8022c5:	48 b8 86 0e 80 00 00 	movabs $0x800e86,%rax
  8022cc:	00 00 00 
  8022cf:	ff d0                	call   *%rax
}
  8022d1:	4c 89 e8             	mov    %r13,%rax
  8022d4:	48 83 c4 08          	add    $0x8,%rsp
  8022d8:	5b                   	pop    %rbx
  8022d9:	41 5c                	pop    %r12
  8022db:	41 5d                	pop    %r13
  8022dd:	5d                   	pop    %rbp
  8022de:	c3                   	ret
    assert(res <= n && res <= PAGE_SIZE);
  8022df:	48 b9 4b 42 80 00 00 	movabs $0x80424b,%rcx
  8022e6:	00 00 00 
  8022e9:	48 ba 68 42 80 00 00 	movabs $0x804268,%rdx
  8022f0:	00 00 00 
  8022f3:	be 7b 00 00 00       	mov    $0x7b,%esi
  8022f8:	48 bf 7d 42 80 00 00 	movabs $0x80427d,%rdi
  8022ff:	00 00 00 
  802302:	b8 00 00 00 00       	mov    $0x0,%eax
  802307:	49 b8 b0 2e 80 00 00 	movabs $0x802eb0,%r8
  80230e:	00 00 00 
  802311:	41 ff d0             	call   *%r8

0000000000802314 <open>:
open(const char *path, int mode) {
  802314:	f3 0f 1e fa          	endbr64
  802318:	55                   	push   %rbp
  802319:	48 89 e5             	mov    %rsp,%rbp
  80231c:	41 55                	push   %r13
  80231e:	41 54                	push   %r12
  802320:	53                   	push   %rbx
  802321:	48 83 ec 18          	sub    $0x18,%rsp
  802325:	49 89 fc             	mov    %rdi,%r12
  802328:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  80232b:	48 b8 26 0c 80 00 00 	movabs $0x800c26,%rax
  802332:	00 00 00 
  802335:	ff d0                	call   *%rax
  802337:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  80233d:	0f 87 8a 00 00 00    	ja     8023cd <open+0xb9>
    if ((res = fd_alloc(&fd)) < 0) return res;
  802343:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802347:	48 b8 7f 19 80 00 00 	movabs $0x80197f,%rax
  80234e:	00 00 00 
  802351:	ff d0                	call   *%rax
  802353:	89 c3                	mov    %eax,%ebx
  802355:	85 c0                	test   %eax,%eax
  802357:	78 50                	js     8023a9 <open+0x95>
    strcpy(fsipcbuf.open.req_path, path);
  802359:	4c 89 e6             	mov    %r12,%rsi
  80235c:	48 bb 00 70 80 00 00 	movabs $0x807000,%rbx
  802363:	00 00 00 
  802366:	48 89 df             	mov    %rbx,%rdi
  802369:	48 b8 6b 0c 80 00 00 	movabs $0x800c6b,%rax
  802370:	00 00 00 
  802373:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  802375:	44 89 ab 00 04 00 00 	mov    %r13d,0x400(%rbx)
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  80237c:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802380:	bf 01 00 00 00       	mov    $0x1,%edi
  802385:	48 b8 84 20 80 00 00 	movabs $0x802084,%rax
  80238c:	00 00 00 
  80238f:	ff d0                	call   *%rax
  802391:	89 c3                	mov    %eax,%ebx
  802393:	85 c0                	test   %eax,%eax
  802395:	78 1f                	js     8023b6 <open+0xa2>
    return fd2num(fd);
  802397:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80239b:	48 b8 49 19 80 00 00 	movabs $0x801949,%rax
  8023a2:	00 00 00 
  8023a5:	ff d0                	call   *%rax
  8023a7:	89 c3                	mov    %eax,%ebx
}
  8023a9:	89 d8                	mov    %ebx,%eax
  8023ab:	48 83 c4 18          	add    $0x18,%rsp
  8023af:	5b                   	pop    %rbx
  8023b0:	41 5c                	pop    %r12
  8023b2:	41 5d                	pop    %r13
  8023b4:	5d                   	pop    %rbp
  8023b5:	c3                   	ret
        fd_close(fd, 0);
  8023b6:	be 00 00 00 00       	mov    $0x0,%esi
  8023bb:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8023bf:	48 b8 a6 1a 80 00 00 	movabs $0x801aa6,%rax
  8023c6:	00 00 00 
  8023c9:	ff d0                	call   *%rax
        return res;
  8023cb:	eb dc                	jmp    8023a9 <open+0x95>
        return -E_BAD_PATH;
  8023cd:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  8023d2:	eb d5                	jmp    8023a9 <open+0x95>

00000000008023d4 <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  8023d4:	f3 0f 1e fa          	endbr64
  8023d8:	55                   	push   %rbp
  8023d9:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  8023dc:	be 00 00 00 00       	mov    $0x0,%esi
  8023e1:	bf 08 00 00 00       	mov    $0x8,%edi
  8023e6:	48 b8 84 20 80 00 00 	movabs $0x802084,%rax
  8023ed:	00 00 00 
  8023f0:	ff d0                	call   *%rax
}
  8023f2:	5d                   	pop    %rbp
  8023f3:	c3                   	ret

00000000008023f4 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  8023f4:	f3 0f 1e fa          	endbr64
  8023f8:	55                   	push   %rbp
  8023f9:	48 89 e5             	mov    %rsp,%rbp
  8023fc:	41 54                	push   %r12
  8023fe:	53                   	push   %rbx
  8023ff:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802402:	48 b8 5f 19 80 00 00 	movabs $0x80195f,%rax
  802409:	00 00 00 
  80240c:	ff d0                	call   *%rax
  80240e:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  802411:	48 be 88 42 80 00 00 	movabs $0x804288,%rsi
  802418:	00 00 00 
  80241b:	48 89 df             	mov    %rbx,%rdi
  80241e:	48 b8 6b 0c 80 00 00 	movabs $0x800c6b,%rax
  802425:	00 00 00 
  802428:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  80242a:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  80242f:	41 2b 04 24          	sub    (%r12),%eax
  802433:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  802439:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  802440:	00 00 00 
    stat->st_dev = &devpipe;
  802443:	48 b8 60 50 80 00 00 	movabs $0x805060,%rax
  80244a:	00 00 00 
  80244d:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  802454:	b8 00 00 00 00       	mov    $0x0,%eax
  802459:	5b                   	pop    %rbx
  80245a:	41 5c                	pop    %r12
  80245c:	5d                   	pop    %rbp
  80245d:	c3                   	ret

000000000080245e <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  80245e:	f3 0f 1e fa          	endbr64
  802462:	55                   	push   %rbp
  802463:	48 89 e5             	mov    %rsp,%rbp
  802466:	41 54                	push   %r12
  802468:	53                   	push   %rbx
  802469:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  80246c:	ba 00 10 00 00       	mov    $0x1000,%edx
  802471:	48 89 fe             	mov    %rdi,%rsi
  802474:	bf 00 00 00 00       	mov    $0x0,%edi
  802479:	49 bc b0 13 80 00 00 	movabs $0x8013b0,%r12
  802480:	00 00 00 
  802483:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  802486:	48 89 df             	mov    %rbx,%rdi
  802489:	48 b8 5f 19 80 00 00 	movabs $0x80195f,%rax
  802490:	00 00 00 
  802493:	ff d0                	call   *%rax
  802495:	48 89 c6             	mov    %rax,%rsi
  802498:	ba 00 10 00 00       	mov    $0x1000,%edx
  80249d:	bf 00 00 00 00       	mov    $0x0,%edi
  8024a2:	41 ff d4             	call   *%r12
}
  8024a5:	5b                   	pop    %rbx
  8024a6:	41 5c                	pop    %r12
  8024a8:	5d                   	pop    %rbp
  8024a9:	c3                   	ret

00000000008024aa <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  8024aa:	f3 0f 1e fa          	endbr64
  8024ae:	55                   	push   %rbp
  8024af:	48 89 e5             	mov    %rsp,%rbp
  8024b2:	41 57                	push   %r15
  8024b4:	41 56                	push   %r14
  8024b6:	41 55                	push   %r13
  8024b8:	41 54                	push   %r12
  8024ba:	53                   	push   %rbx
  8024bb:	48 83 ec 18          	sub    $0x18,%rsp
  8024bf:	49 89 fc             	mov    %rdi,%r12
  8024c2:	49 89 f5             	mov    %rsi,%r13
  8024c5:	49 89 d7             	mov    %rdx,%r15
  8024c8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8024cc:	48 b8 5f 19 80 00 00 	movabs $0x80195f,%rax
  8024d3:	00 00 00 
  8024d6:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  8024d8:	4d 85 ff             	test   %r15,%r15
  8024db:	0f 84 af 00 00 00    	je     802590 <devpipe_write+0xe6>
  8024e1:	48 89 c3             	mov    %rax,%rbx
  8024e4:	4c 89 f8             	mov    %r15,%rax
  8024e7:	4d 89 ef             	mov    %r13,%r15
  8024ea:	4c 01 e8             	add    %r13,%rax
  8024ed:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8024f1:	49 bd 40 12 80 00 00 	movabs $0x801240,%r13
  8024f8:	00 00 00 
            sys_yield();
  8024fb:	49 be d5 11 80 00 00 	movabs $0x8011d5,%r14
  802502:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  802505:	8b 73 04             	mov    0x4(%rbx),%esi
  802508:	48 63 ce             	movslq %esi,%rcx
  80250b:	48 63 03             	movslq (%rbx),%rax
  80250e:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  802514:	48 39 c1             	cmp    %rax,%rcx
  802517:	72 2e                	jb     802547 <devpipe_write+0x9d>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802519:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80251e:	48 89 da             	mov    %rbx,%rdx
  802521:	be 00 10 00 00       	mov    $0x1000,%esi
  802526:	4c 89 e7             	mov    %r12,%rdi
  802529:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  80252c:	85 c0                	test   %eax,%eax
  80252e:	74 66                	je     802596 <devpipe_write+0xec>
            sys_yield();
  802530:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  802533:	8b 73 04             	mov    0x4(%rbx),%esi
  802536:	48 63 ce             	movslq %esi,%rcx
  802539:	48 63 03             	movslq (%rbx),%rax
  80253c:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  802542:	48 39 c1             	cmp    %rax,%rcx
  802545:	73 d2                	jae    802519 <devpipe_write+0x6f>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802547:	41 0f b6 3f          	movzbl (%r15),%edi
  80254b:	48 89 ca             	mov    %rcx,%rdx
  80254e:	48 c1 ea 03          	shr    $0x3,%rdx
  802552:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  802559:	08 10 20 
  80255c:	48 f7 e2             	mul    %rdx
  80255f:	48 c1 ea 06          	shr    $0x6,%rdx
  802563:	48 89 d0             	mov    %rdx,%rax
  802566:	48 c1 e0 09          	shl    $0x9,%rax
  80256a:	48 29 d0             	sub    %rdx,%rax
  80256d:	48 c1 e0 03          	shl    $0x3,%rax
  802571:	48 29 c1             	sub    %rax,%rcx
  802574:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  802579:	83 c6 01             	add    $0x1,%esi
  80257c:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  80257f:	49 83 c7 01          	add    $0x1,%r15
  802583:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802587:	49 39 c7             	cmp    %rax,%r15
  80258a:	0f 85 75 ff ff ff    	jne    802505 <devpipe_write+0x5b>
    return n;
  802590:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802594:	eb 05                	jmp    80259b <devpipe_write+0xf1>
            if (_pipeisclosed(fd, p)) return 0;
  802596:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80259b:	48 83 c4 18          	add    $0x18,%rsp
  80259f:	5b                   	pop    %rbx
  8025a0:	41 5c                	pop    %r12
  8025a2:	41 5d                	pop    %r13
  8025a4:	41 5e                	pop    %r14
  8025a6:	41 5f                	pop    %r15
  8025a8:	5d                   	pop    %rbp
  8025a9:	c3                   	ret

00000000008025aa <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  8025aa:	f3 0f 1e fa          	endbr64
  8025ae:	55                   	push   %rbp
  8025af:	48 89 e5             	mov    %rsp,%rbp
  8025b2:	41 57                	push   %r15
  8025b4:	41 56                	push   %r14
  8025b6:	41 55                	push   %r13
  8025b8:	41 54                	push   %r12
  8025ba:	53                   	push   %rbx
  8025bb:	48 83 ec 18          	sub    $0x18,%rsp
  8025bf:	49 89 fc             	mov    %rdi,%r12
  8025c2:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  8025c6:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8025ca:	48 b8 5f 19 80 00 00 	movabs $0x80195f,%rax
  8025d1:	00 00 00 
  8025d4:	ff d0                	call   *%rax
  8025d6:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  8025d9:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8025df:	49 bd 40 12 80 00 00 	movabs $0x801240,%r13
  8025e6:	00 00 00 
            sys_yield();
  8025e9:	49 be d5 11 80 00 00 	movabs $0x8011d5,%r14
  8025f0:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  8025f3:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8025f8:	74 7d                	je     802677 <devpipe_read+0xcd>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8025fa:	8b 03                	mov    (%rbx),%eax
  8025fc:	3b 43 04             	cmp    0x4(%rbx),%eax
  8025ff:	75 26                	jne    802627 <devpipe_read+0x7d>
            if (i > 0) return i;
  802601:	4d 85 ff             	test   %r15,%r15
  802604:	75 77                	jne    80267d <devpipe_read+0xd3>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802606:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80260b:	48 89 da             	mov    %rbx,%rdx
  80260e:	be 00 10 00 00       	mov    $0x1000,%esi
  802613:	4c 89 e7             	mov    %r12,%rdi
  802616:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802619:	85 c0                	test   %eax,%eax
  80261b:	74 72                	je     80268f <devpipe_read+0xe5>
            sys_yield();
  80261d:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802620:	8b 03                	mov    (%rbx),%eax
  802622:	3b 43 04             	cmp    0x4(%rbx),%eax
  802625:	74 df                	je     802606 <devpipe_read+0x5c>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802627:	48 63 c8             	movslq %eax,%rcx
  80262a:	48 89 ca             	mov    %rcx,%rdx
  80262d:	48 c1 ea 03          	shr    $0x3,%rdx
  802631:	48 be 81 00 01 02 04 	movabs $0x2010080402010081,%rsi
  802638:	08 10 20 
  80263b:	48 89 d0             	mov    %rdx,%rax
  80263e:	48 f7 e6             	mul    %rsi
  802641:	48 c1 ea 06          	shr    $0x6,%rdx
  802645:	48 89 d0             	mov    %rdx,%rax
  802648:	48 c1 e0 09          	shl    $0x9,%rax
  80264c:	48 29 d0             	sub    %rdx,%rax
  80264f:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802656:	00 
  802657:	48 89 c8             	mov    %rcx,%rax
  80265a:	48 29 d0             	sub    %rdx,%rax
  80265d:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  802662:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  802666:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  80266a:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  80266d:	49 83 c7 01          	add    $0x1,%r15
  802671:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  802675:	75 83                	jne    8025fa <devpipe_read+0x50>
    return n;
  802677:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80267b:	eb 03                	jmp    802680 <devpipe_read+0xd6>
            if (i > 0) return i;
  80267d:	4c 89 f8             	mov    %r15,%rax
}
  802680:	48 83 c4 18          	add    $0x18,%rsp
  802684:	5b                   	pop    %rbx
  802685:	41 5c                	pop    %r12
  802687:	41 5d                	pop    %r13
  802689:	41 5e                	pop    %r14
  80268b:	41 5f                	pop    %r15
  80268d:	5d                   	pop    %rbp
  80268e:	c3                   	ret
            if (_pipeisclosed(fd, p)) return 0;
  80268f:	b8 00 00 00 00       	mov    $0x0,%eax
  802694:	eb ea                	jmp    802680 <devpipe_read+0xd6>

0000000000802696 <pipe>:
pipe(int pfd[2]) {
  802696:	f3 0f 1e fa          	endbr64
  80269a:	55                   	push   %rbp
  80269b:	48 89 e5             	mov    %rsp,%rbp
  80269e:	41 55                	push   %r13
  8026a0:	41 54                	push   %r12
  8026a2:	53                   	push   %rbx
  8026a3:	48 83 ec 18          	sub    $0x18,%rsp
  8026a7:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  8026aa:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  8026ae:	48 b8 7f 19 80 00 00 	movabs $0x80197f,%rax
  8026b5:	00 00 00 
  8026b8:	ff d0                	call   *%rax
  8026ba:	89 c3                	mov    %eax,%ebx
  8026bc:	85 c0                	test   %eax,%eax
  8026be:	0f 88 a0 01 00 00    	js     802864 <pipe+0x1ce>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  8026c4:	b9 46 00 00 00       	mov    $0x46,%ecx
  8026c9:	ba 00 10 00 00       	mov    $0x1000,%edx
  8026ce:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8026d2:	bf 00 00 00 00       	mov    $0x0,%edi
  8026d7:	48 b8 70 12 80 00 00 	movabs $0x801270,%rax
  8026de:	00 00 00 
  8026e1:	ff d0                	call   *%rax
  8026e3:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  8026e5:	85 c0                	test   %eax,%eax
  8026e7:	0f 88 77 01 00 00    	js     802864 <pipe+0x1ce>
    if ((res = fd_alloc(&fd1)) < 0 ||
  8026ed:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  8026f1:	48 b8 7f 19 80 00 00 	movabs $0x80197f,%rax
  8026f8:	00 00 00 
  8026fb:	ff d0                	call   *%rax
  8026fd:	89 c3                	mov    %eax,%ebx
  8026ff:	85 c0                	test   %eax,%eax
  802701:	0f 88 43 01 00 00    	js     80284a <pipe+0x1b4>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  802707:	b9 46 00 00 00       	mov    $0x46,%ecx
  80270c:	ba 00 10 00 00       	mov    $0x1000,%edx
  802711:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802715:	bf 00 00 00 00       	mov    $0x0,%edi
  80271a:	48 b8 70 12 80 00 00 	movabs $0x801270,%rax
  802721:	00 00 00 
  802724:	ff d0                	call   *%rax
  802726:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  802728:	85 c0                	test   %eax,%eax
  80272a:	0f 88 1a 01 00 00    	js     80284a <pipe+0x1b4>
    va = fd2data(fd0);
  802730:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802734:	48 b8 5f 19 80 00 00 	movabs $0x80195f,%rax
  80273b:	00 00 00 
  80273e:	ff d0                	call   *%rax
  802740:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  802743:	b9 46 00 00 00       	mov    $0x46,%ecx
  802748:	ba 00 10 00 00       	mov    $0x1000,%edx
  80274d:	48 89 c6             	mov    %rax,%rsi
  802750:	bf 00 00 00 00       	mov    $0x0,%edi
  802755:	48 b8 70 12 80 00 00 	movabs $0x801270,%rax
  80275c:	00 00 00 
  80275f:	ff d0                	call   *%rax
  802761:	89 c3                	mov    %eax,%ebx
  802763:	85 c0                	test   %eax,%eax
  802765:	0f 88 c5 00 00 00    	js     802830 <pipe+0x19a>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  80276b:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  80276f:	48 b8 5f 19 80 00 00 	movabs $0x80195f,%rax
  802776:	00 00 00 
  802779:	ff d0                	call   *%rax
  80277b:	48 89 c1             	mov    %rax,%rcx
  80277e:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  802784:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  80278a:	ba 00 00 00 00       	mov    $0x0,%edx
  80278f:	4c 89 ee             	mov    %r13,%rsi
  802792:	bf 00 00 00 00       	mov    $0x0,%edi
  802797:	48 b8 db 12 80 00 00 	movabs $0x8012db,%rax
  80279e:	00 00 00 
  8027a1:	ff d0                	call   *%rax
  8027a3:	89 c3                	mov    %eax,%ebx
  8027a5:	85 c0                	test   %eax,%eax
  8027a7:	78 6e                	js     802817 <pipe+0x181>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8027a9:	be 00 10 00 00       	mov    $0x1000,%esi
  8027ae:	4c 89 ef             	mov    %r13,%rdi
  8027b1:	48 b8 0a 12 80 00 00 	movabs $0x80120a,%rax
  8027b8:	00 00 00 
  8027bb:	ff d0                	call   *%rax
  8027bd:	83 f8 02             	cmp    $0x2,%eax
  8027c0:	0f 85 ab 00 00 00    	jne    802871 <pipe+0x1db>
    fd0->fd_dev_id = devpipe.dev_id;
  8027c6:	a1 60 50 80 00 00 00 	movabs 0x805060,%eax
  8027cd:	00 00 
  8027cf:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8027d3:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  8027d5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8027d9:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  8027e0:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8027e4:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  8027e6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8027ea:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  8027f1:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8027f5:	48 bb 49 19 80 00 00 	movabs $0x801949,%rbx
  8027fc:	00 00 00 
  8027ff:	ff d3                	call   *%rbx
  802801:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  802805:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802809:	ff d3                	call   *%rbx
  80280b:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  802810:	bb 00 00 00 00       	mov    $0x0,%ebx
  802815:	eb 4d                	jmp    802864 <pipe+0x1ce>
    sys_unmap_region(0, va, PAGE_SIZE);
  802817:	ba 00 10 00 00       	mov    $0x1000,%edx
  80281c:	4c 89 ee             	mov    %r13,%rsi
  80281f:	bf 00 00 00 00       	mov    $0x0,%edi
  802824:	48 b8 b0 13 80 00 00 	movabs $0x8013b0,%rax
  80282b:	00 00 00 
  80282e:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  802830:	ba 00 10 00 00       	mov    $0x1000,%edx
  802835:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802839:	bf 00 00 00 00       	mov    $0x0,%edi
  80283e:	48 b8 b0 13 80 00 00 	movabs $0x8013b0,%rax
  802845:	00 00 00 
  802848:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  80284a:	ba 00 10 00 00       	mov    $0x1000,%edx
  80284f:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802853:	bf 00 00 00 00       	mov    $0x0,%edi
  802858:	48 b8 b0 13 80 00 00 	movabs $0x8013b0,%rax
  80285f:	00 00 00 
  802862:	ff d0                	call   *%rax
}
  802864:	89 d8                	mov    %ebx,%eax
  802866:	48 83 c4 18          	add    $0x18,%rsp
  80286a:	5b                   	pop    %rbx
  80286b:	41 5c                	pop    %r12
  80286d:	41 5d                	pop    %r13
  80286f:	5d                   	pop    %rbp
  802870:	c3                   	ret
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802871:	48 b9 a0 43 80 00 00 	movabs $0x8043a0,%rcx
  802878:	00 00 00 
  80287b:	48 ba 68 42 80 00 00 	movabs $0x804268,%rdx
  802882:	00 00 00 
  802885:	be 2e 00 00 00       	mov    $0x2e,%esi
  80288a:	48 bf 8f 42 80 00 00 	movabs $0x80428f,%rdi
  802891:	00 00 00 
  802894:	b8 00 00 00 00       	mov    $0x0,%eax
  802899:	49 b8 b0 2e 80 00 00 	movabs $0x802eb0,%r8
  8028a0:	00 00 00 
  8028a3:	41 ff d0             	call   *%r8

00000000008028a6 <pipeisclosed>:
pipeisclosed(int fdnum) {
  8028a6:	f3 0f 1e fa          	endbr64
  8028aa:	55                   	push   %rbp
  8028ab:	48 89 e5             	mov    %rsp,%rbp
  8028ae:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8028b2:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8028b6:	48 b8 e3 19 80 00 00 	movabs $0x8019e3,%rax
  8028bd:	00 00 00 
  8028c0:	ff d0                	call   *%rax
    if (res < 0) return res;
  8028c2:	85 c0                	test   %eax,%eax
  8028c4:	78 35                	js     8028fb <pipeisclosed+0x55>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  8028c6:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8028ca:	48 b8 5f 19 80 00 00 	movabs $0x80195f,%rax
  8028d1:	00 00 00 
  8028d4:	ff d0                	call   *%rax
  8028d6:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8028d9:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8028de:	be 00 10 00 00       	mov    $0x1000,%esi
  8028e3:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8028e7:	48 b8 40 12 80 00 00 	movabs $0x801240,%rax
  8028ee:	00 00 00 
  8028f1:	ff d0                	call   *%rax
  8028f3:	85 c0                	test   %eax,%eax
  8028f5:	0f 94 c0             	sete   %al
  8028f8:	0f b6 c0             	movzbl %al,%eax
}
  8028fb:	c9                   	leave
  8028fc:	c3                   	ret

00000000008028fd <get_uvpt_entry>:
extern volatile pde_t uvpd[];     /* VA of current page directory */
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
  8028fd:	f3 0f 1e fa          	endbr64
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802901:	48 89 f8             	mov    %rdi,%rax
  802904:	48 c1 e8 27          	shr    $0x27,%rax
  802908:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  80290f:	7f 00 00 
  802912:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802916:	f6 c2 01             	test   $0x1,%dl
  802919:	74 6d                	je     802988 <get_uvpt_entry+0x8b>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  80291b:	48 89 f8             	mov    %rdi,%rax
  80291e:	48 c1 e8 1e          	shr    $0x1e,%rax
  802922:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  802929:	7f 00 00 
  80292c:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802930:	f6 c2 01             	test   $0x1,%dl
  802933:	74 62                	je     802997 <get_uvpt_entry+0x9a>
  802935:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  80293c:	7f 00 00 
  80293f:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802943:	f6 c2 80             	test   $0x80,%dl
  802946:	75 4f                	jne    802997 <get_uvpt_entry+0x9a>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802948:	48 89 f8             	mov    %rdi,%rax
  80294b:	48 c1 e8 15          	shr    $0x15,%rax
  80294f:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802956:	7f 00 00 
  802959:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80295d:	f6 c2 01             	test   $0x1,%dl
  802960:	74 44                	je     8029a6 <get_uvpt_entry+0xa9>
  802962:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802969:	7f 00 00 
  80296c:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802970:	f6 c2 80             	test   $0x80,%dl
  802973:	75 31                	jne    8029a6 <get_uvpt_entry+0xa9>
    return uvpt[VPT(va)];
  802975:	48 c1 ef 0c          	shr    $0xc,%rdi
  802979:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802980:	7f 00 00 
  802983:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  802987:	c3                   	ret
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802988:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  80298f:	7f 00 00 
  802992:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802996:	c3                   	ret
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  802997:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  80299e:	7f 00 00 
  8029a1:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8029a5:	c3                   	ret
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8029a6:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  8029ad:	7f 00 00 
  8029b0:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8029b4:	c3                   	ret

00000000008029b5 <get_phys_addr>:

uintptr_t
get_phys_addr(void *va) {
  8029b5:	f3 0f 1e fa          	endbr64
  8029b9:	48 89 fa             	mov    %rdi,%rdx
    if (!(uvpml4[VPML4(va)] & PTE_P))
  8029bc:	48 89 f9             	mov    %rdi,%rcx
  8029bf:	48 c1 e9 27          	shr    $0x27,%rcx
  8029c3:	48 b8 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rax
  8029ca:	7f 00 00 
  8029cd:	48 8b 0c c8          	mov    (%rax,%rcx,8),%rcx
        return -1;
  8029d1:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpml4[VPML4(va)] & PTE_P))
  8029d8:	f6 c1 01             	test   $0x1,%cl
  8029db:	0f 84 b2 00 00 00    	je     802a93 <get_phys_addr+0xde>
    if (!(uvpdp[VPDP(va)] & PTE_P))
  8029e1:	48 89 f9             	mov    %rdi,%rcx
  8029e4:	48 c1 e9 1e          	shr    $0x1e,%rcx
  8029e8:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  8029ef:	7f 00 00 
  8029f2:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  8029f6:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpdp[VPDP(va)] & PTE_P))
  8029fd:	40 f6 c6 01          	test   $0x1,%sil
  802a01:	0f 84 8c 00 00 00    	je     802a93 <get_phys_addr+0xde>
    if (uvpdp[VPDP(va)] & PTE_PS)
  802a07:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802a0e:	7f 00 00 
  802a11:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802a15:	a8 80                	test   $0x80,%al
  802a17:	75 7b                	jne    802a94 <get_phys_addr+0xdf>
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
    if (!(uvpd[VPD(va)] & PTE_P))
  802a19:	48 89 f9             	mov    %rdi,%rcx
  802a1c:	48 c1 e9 15          	shr    $0x15,%rcx
  802a20:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  802a27:	7f 00 00 
  802a2a:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  802a2e:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpd[VPD(va)] & PTE_P))
  802a35:	40 f6 c6 01          	test   $0x1,%sil
  802a39:	74 58                	je     802a93 <get_phys_addr+0xde>
    if ((uvpd[VPD(va)] & PTE_PS))
  802a3b:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  802a42:	7f 00 00 
  802a45:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802a49:	a8 80                	test   $0x80,%al
  802a4b:	75 6c                	jne    802ab9 <get_phys_addr+0x104>
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
    if (!(uvpt[VPT(va)] & PTE_P))
  802a4d:	48 89 f9             	mov    %rdi,%rcx
  802a50:	48 c1 e9 0c          	shr    $0xc,%rcx
  802a54:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802a5b:	7f 00 00 
  802a5e:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  802a62:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpt[VPT(va)] & PTE_P))
  802a69:	40 f6 c6 01          	test   $0x1,%sil
  802a6d:	74 24                	je     802a93 <get_phys_addr+0xde>
    return PTE_ADDR(uvpt[VPT(va)]) + PAGE_OFFSET(va);
  802a6f:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802a76:	7f 00 00 
  802a79:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802a7d:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802a84:	ff ff 7f 
  802a87:	48 21 c8             	and    %rcx,%rax
  802a8a:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  802a90:	48 09 d0             	or     %rdx,%rax
}
  802a93:	c3                   	ret
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
  802a94:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802a9b:	7f 00 00 
  802a9e:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802aa2:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802aa9:	ff ff 7f 
  802aac:	48 21 c8             	and    %rcx,%rax
  802aaf:	81 e2 ff ff ff 3f    	and    $0x3fffffff,%edx
  802ab5:	48 01 d0             	add    %rdx,%rax
  802ab8:	c3                   	ret
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
  802ab9:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  802ac0:	7f 00 00 
  802ac3:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802ac7:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802ace:	ff ff 7f 
  802ad1:	48 21 c8             	and    %rcx,%rax
  802ad4:	81 e2 ff ff 1f 00    	and    $0x1fffff,%edx
  802ada:	48 01 d0             	add    %rdx,%rax
  802add:	c3                   	ret

0000000000802ade <get_prot>:

int
get_prot(void *va) {
  802ade:	f3 0f 1e fa          	endbr64
  802ae2:	55                   	push   %rbp
  802ae3:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802ae6:	48 b8 fd 28 80 00 00 	movabs $0x8028fd,%rax
  802aed:	00 00 00 
  802af0:	ff d0                	call   *%rax
  802af2:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
    if (pte & PTE_P) prot |= PROT_R;
  802af5:	83 e0 01             	and    $0x1,%eax
  802af8:	c1 e0 02             	shl    $0x2,%eax
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  802afb:	89 d1                	mov    %edx,%ecx
  802afd:	81 e1 00 0a 00 00    	and    $0xa00,%ecx
    if (pte & PTE_P) prot |= PROT_R;
  802b03:	09 c8                	or     %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  802b05:	89 c1                	mov    %eax,%ecx
  802b07:	83 c9 02             	or     $0x2,%ecx
  802b0a:	f6 c2 02             	test   $0x2,%dl
  802b0d:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  802b10:	89 c1                	mov    %eax,%ecx
  802b12:	83 c9 01             	or     $0x1,%ecx
  802b15:	48 85 d2             	test   %rdx,%rdx
  802b18:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  802b1b:	89 c1                	mov    %eax,%ecx
  802b1d:	83 c9 40             	or     $0x40,%ecx
  802b20:	f6 c6 04             	test   $0x4,%dh
  802b23:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  802b26:	5d                   	pop    %rbp
  802b27:	c3                   	ret

0000000000802b28 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  802b28:	f3 0f 1e fa          	endbr64
  802b2c:	55                   	push   %rbp
  802b2d:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802b30:	48 b8 fd 28 80 00 00 	movabs $0x8028fd,%rax
  802b37:	00 00 00 
  802b3a:	ff d0                	call   *%rax
    return pte & PTE_D;
  802b3c:	48 c1 e8 06          	shr    $0x6,%rax
  802b40:	83 e0 01             	and    $0x1,%eax
}
  802b43:	5d                   	pop    %rbp
  802b44:	c3                   	ret

0000000000802b45 <is_page_present>:

bool
is_page_present(void *va) {
  802b45:	f3 0f 1e fa          	endbr64
  802b49:	55                   	push   %rbp
  802b4a:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  802b4d:	48 b8 fd 28 80 00 00 	movabs $0x8028fd,%rax
  802b54:	00 00 00 
  802b57:	ff d0                	call   *%rax
  802b59:	83 e0 01             	and    $0x1,%eax
}
  802b5c:	5d                   	pop    %rbp
  802b5d:	c3                   	ret

0000000000802b5e <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  802b5e:	f3 0f 1e fa          	endbr64
  802b62:	55                   	push   %rbp
  802b63:	48 89 e5             	mov    %rsp,%rbp
  802b66:	41 57                	push   %r15
  802b68:	41 56                	push   %r14
  802b6a:	41 55                	push   %r13
  802b6c:	41 54                	push   %r12
  802b6e:	53                   	push   %rbx
  802b6f:	48 83 ec 18          	sub    $0x18,%rsp
  802b73:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  802b77:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
     * NOTE: Skip over larger pages/page directories for efficiency */
    // LAB 11: Your code here:

    int res = 0;
    (void)fun, (void)arg;
    uintptr_t va = 0;
  802b7b:	bb 00 00 00 00       	mov    $0x0,%ebx
    while (va < USER_STACK_TOP) {
        size_t size = 0;
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  802b80:	49 be 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%r14
  802b87:	7f 00 00 
            size = 1LL << PML4_SHIFT;
            goto next;
        }

        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802b8a:	49 bd 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%r13
  802b91:	7f 00 00 
    while (va < USER_STACK_TOP) {
  802b94:	49 bf ff 6f ff ff 7f 	movabs $0x7fffff6fff,%r15
  802b9b:	00 00 00 
  802b9e:	eb 73                	jmp    802c13 <foreach_shared_region+0xb5>
            }

            goto next;
        }

        if (!(uvpd[VPD(va)] & PTE_P)) {
  802ba0:	48 89 d8             	mov    %rbx,%rax
  802ba3:	48 c1 e8 15          	shr    $0x15,%rax
  802ba7:	48 b9 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rcx
  802bae:	7f 00 00 
  802bb1:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
            size = 1LL << PD_SHIFT;
  802bb5:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
        if (!(uvpd[VPD(va)] & PTE_P)) {
  802bbb:	f6 c2 01             	test   $0x1,%dl
  802bbe:	74 4b                	je     802c0b <foreach_shared_region+0xad>
            goto next;
        }

        if (uvpd[VPD(va)] & PTE_PS) {
  802bc0:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
  802bc4:	f6 c2 80             	test   $0x80,%dl
  802bc7:	74 11                	je     802bda <foreach_shared_region+0x7c>
            size = 1LL << PD_SHIFT;
            if (uvpd[VPD(va)] & PTE_SHARE) {
  802bc9:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
  802bcd:	f6 c4 04             	test   $0x4,%ah
  802bd0:	74 39                	je     802c0b <foreach_shared_region+0xad>
            size = 1LL << PD_SHIFT;
  802bd2:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
  802bd8:	eb 20                	jmp    802bfa <foreach_shared_region+0x9c>

            goto next;
        }

        size = PAGE_SIZE;
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  802bda:	48 89 da             	mov    %rbx,%rdx
  802bdd:	48 c1 ea 0c          	shr    $0xc,%rdx
  802be1:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802be8:	7f 00 00 
  802beb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
        size = PAGE_SIZE;
  802bef:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  802bf5:	f6 c4 04             	test   $0x4,%ah
  802bf8:	74 11                	je     802c0b <foreach_shared_region+0xad>
            goto next;
        }

    map:
        fun((void *)va, (void *)(va + size), arg);
  802bfa:	49 8d 34 1c          	lea    (%r12,%rbx,1),%rsi
  802bfe:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802c02:	48 89 df             	mov    %rbx,%rdi
  802c05:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802c09:	ff d0                	call   *%rax
    next:
        va += size;
  802c0b:	4c 01 e3             	add    %r12,%rbx
    while (va < USER_STACK_TOP) {
  802c0e:	49 39 df             	cmp    %rbx,%r15
  802c11:	72 3e                	jb     802c51 <foreach_shared_region+0xf3>
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  802c13:	49 8b 06             	mov    (%r14),%rax
  802c16:	a8 01                	test   $0x1,%al
  802c18:	74 37                	je     802c51 <foreach_shared_region+0xf3>
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802c1a:	48 89 d8             	mov    %rbx,%rax
  802c1d:	48 c1 e8 1e          	shr    $0x1e,%rax
  802c21:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
            size = 1LL << PDP_SHIFT;
  802c26:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802c2c:	f6 c2 01             	test   $0x1,%dl
  802c2f:	74 da                	je     802c0b <foreach_shared_region+0xad>
        if (uvpdp[VPDP(va)] & PTE_PS) {
  802c31:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
  802c36:	f6 c2 80             	test   $0x80,%dl
  802c39:	0f 84 61 ff ff ff    	je     802ba0 <foreach_shared_region+0x42>
            if (uvpdp[VPDP(va)] & PTE_SHARE) {
  802c3f:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  802c44:	f6 c4 04             	test   $0x4,%ah
  802c47:	74 c2                	je     802c0b <foreach_shared_region+0xad>
            size = 1LL << PDP_SHIFT;
  802c49:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
  802c4f:	eb a9                	jmp    802bfa <foreach_shared_region+0x9c>
    }
    return res;
}
  802c51:	b8 00 00 00 00       	mov    $0x0,%eax
  802c56:	48 83 c4 18          	add    $0x18,%rsp
  802c5a:	5b                   	pop    %rbx
  802c5b:	41 5c                	pop    %r12
  802c5d:	41 5d                	pop    %r13
  802c5f:	41 5e                	pop    %r14
  802c61:	41 5f                	pop    %r15
  802c63:	5d                   	pop    %rbp
  802c64:	c3                   	ret

0000000000802c65 <devcons_close>:

    return res;
}

static int
devcons_close(struct Fd *fd) {
  802c65:	f3 0f 1e fa          	endbr64
    USED(fd);

    return 0;
}
  802c69:	b8 00 00 00 00       	mov    $0x0,%eax
  802c6e:	c3                   	ret

0000000000802c6f <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  802c6f:	f3 0f 1e fa          	endbr64
  802c73:	55                   	push   %rbp
  802c74:	48 89 e5             	mov    %rsp,%rbp
  802c77:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  802c7a:	48 be 9f 42 80 00 00 	movabs $0x80429f,%rsi
  802c81:	00 00 00 
  802c84:	48 b8 6b 0c 80 00 00 	movabs $0x800c6b,%rax
  802c8b:	00 00 00 
  802c8e:	ff d0                	call   *%rax
    return 0;
}
  802c90:	b8 00 00 00 00       	mov    $0x0,%eax
  802c95:	5d                   	pop    %rbp
  802c96:	c3                   	ret

0000000000802c97 <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  802c97:	f3 0f 1e fa          	endbr64
  802c9b:	55                   	push   %rbp
  802c9c:	48 89 e5             	mov    %rsp,%rbp
  802c9f:	41 57                	push   %r15
  802ca1:	41 56                	push   %r14
  802ca3:	41 55                	push   %r13
  802ca5:	41 54                	push   %r12
  802ca7:	53                   	push   %rbx
  802ca8:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  802caf:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  802cb6:	48 85 d2             	test   %rdx,%rdx
  802cb9:	74 7a                	je     802d35 <devcons_write+0x9e>
  802cbb:	49 89 d6             	mov    %rdx,%r14
  802cbe:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802cc4:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  802cc9:	49 bf 86 0e 80 00 00 	movabs $0x800e86,%r15
  802cd0:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  802cd3:	4c 89 f3             	mov    %r14,%rbx
  802cd6:	48 29 f3             	sub    %rsi,%rbx
  802cd9:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802cde:	48 39 c3             	cmp    %rax,%rbx
  802ce1:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  802ce5:	4c 63 eb             	movslq %ebx,%r13
  802ce8:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  802cef:	48 01 c6             	add    %rax,%rsi
  802cf2:	4c 89 ea             	mov    %r13,%rdx
  802cf5:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802cfc:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  802cff:	4c 89 ee             	mov    %r13,%rsi
  802d02:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802d09:	48 b8 cb 10 80 00 00 	movabs $0x8010cb,%rax
  802d10:	00 00 00 
  802d13:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  802d15:	41 01 dc             	add    %ebx,%r12d
  802d18:	49 63 f4             	movslq %r12d,%rsi
  802d1b:	4c 39 f6             	cmp    %r14,%rsi
  802d1e:	72 b3                	jb     802cd3 <devcons_write+0x3c>
    return res;
  802d20:	49 63 c4             	movslq %r12d,%rax
}
  802d23:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  802d2a:	5b                   	pop    %rbx
  802d2b:	41 5c                	pop    %r12
  802d2d:	41 5d                	pop    %r13
  802d2f:	41 5e                	pop    %r14
  802d31:	41 5f                	pop    %r15
  802d33:	5d                   	pop    %rbp
  802d34:	c3                   	ret
    for (res = 0; res < n; res += inc) {
  802d35:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802d3b:	eb e3                	jmp    802d20 <devcons_write+0x89>

0000000000802d3d <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802d3d:	f3 0f 1e fa          	endbr64
  802d41:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  802d44:	ba 00 00 00 00       	mov    $0x0,%edx
  802d49:	48 85 c0             	test   %rax,%rax
  802d4c:	74 55                	je     802da3 <devcons_read+0x66>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802d4e:	55                   	push   %rbp
  802d4f:	48 89 e5             	mov    %rsp,%rbp
  802d52:	41 55                	push   %r13
  802d54:	41 54                	push   %r12
  802d56:	53                   	push   %rbx
  802d57:	48 83 ec 08          	sub    $0x8,%rsp
  802d5b:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  802d5e:	48 bb fc 10 80 00 00 	movabs $0x8010fc,%rbx
  802d65:	00 00 00 
  802d68:	49 bc d5 11 80 00 00 	movabs $0x8011d5,%r12
  802d6f:	00 00 00 
  802d72:	eb 03                	jmp    802d77 <devcons_read+0x3a>
  802d74:	41 ff d4             	call   *%r12
  802d77:	ff d3                	call   *%rbx
  802d79:	85 c0                	test   %eax,%eax
  802d7b:	74 f7                	je     802d74 <devcons_read+0x37>
    if (c < 0) return c;
  802d7d:	48 63 d0             	movslq %eax,%rdx
  802d80:	78 13                	js     802d95 <devcons_read+0x58>
    if (c == 0x04) return 0;
  802d82:	ba 00 00 00 00       	mov    $0x0,%edx
  802d87:	83 f8 04             	cmp    $0x4,%eax
  802d8a:	74 09                	je     802d95 <devcons_read+0x58>
    *(char *)vbuf = (char)c;
  802d8c:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  802d90:	ba 01 00 00 00       	mov    $0x1,%edx
}
  802d95:	48 89 d0             	mov    %rdx,%rax
  802d98:	48 83 c4 08          	add    $0x8,%rsp
  802d9c:	5b                   	pop    %rbx
  802d9d:	41 5c                	pop    %r12
  802d9f:	41 5d                	pop    %r13
  802da1:	5d                   	pop    %rbp
  802da2:	c3                   	ret
  802da3:	48 89 d0             	mov    %rdx,%rax
  802da6:	c3                   	ret

0000000000802da7 <cputchar>:
cputchar(int ch) {
  802da7:	f3 0f 1e fa          	endbr64
  802dab:	55                   	push   %rbp
  802dac:	48 89 e5             	mov    %rsp,%rbp
  802daf:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  802db3:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  802db7:	be 01 00 00 00       	mov    $0x1,%esi
  802dbc:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  802dc0:	48 b8 cb 10 80 00 00 	movabs $0x8010cb,%rax
  802dc7:	00 00 00 
  802dca:	ff d0                	call   *%rax
}
  802dcc:	c9                   	leave
  802dcd:	c3                   	ret

0000000000802dce <getchar>:
getchar(void) {
  802dce:	f3 0f 1e fa          	endbr64
  802dd2:	55                   	push   %rbp
  802dd3:	48 89 e5             	mov    %rsp,%rbp
  802dd6:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  802dda:	ba 01 00 00 00       	mov    $0x1,%edx
  802ddf:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  802de3:	bf 00 00 00 00       	mov    $0x0,%edi
  802de8:	48 b8 de 1c 80 00 00 	movabs $0x801cde,%rax
  802def:	00 00 00 
  802df2:	ff d0                	call   *%rax
  802df4:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  802df6:	85 c0                	test   %eax,%eax
  802df8:	78 06                	js     802e00 <getchar+0x32>
  802dfa:	74 08                	je     802e04 <getchar+0x36>
  802dfc:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  802e00:	89 d0                	mov    %edx,%eax
  802e02:	c9                   	leave
  802e03:	c3                   	ret
    return res < 0 ? res : res ? c :
  802e04:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  802e09:	eb f5                	jmp    802e00 <getchar+0x32>

0000000000802e0b <iscons>:
iscons(int fdnum) {
  802e0b:	f3 0f 1e fa          	endbr64
  802e0f:	55                   	push   %rbp
  802e10:	48 89 e5             	mov    %rsp,%rbp
  802e13:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802e17:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802e1b:	48 b8 e3 19 80 00 00 	movabs $0x8019e3,%rax
  802e22:	00 00 00 
  802e25:	ff d0                	call   *%rax
    if (res < 0) return res;
  802e27:	85 c0                	test   %eax,%eax
  802e29:	78 18                	js     802e43 <iscons+0x38>
    return fd->fd_dev_id == devcons.dev_id;
  802e2b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802e2f:	48 b8 a0 50 80 00 00 	movabs $0x8050a0,%rax
  802e36:	00 00 00 
  802e39:	8b 00                	mov    (%rax),%eax
  802e3b:	39 02                	cmp    %eax,(%rdx)
  802e3d:	0f 94 c0             	sete   %al
  802e40:	0f b6 c0             	movzbl %al,%eax
}
  802e43:	c9                   	leave
  802e44:	c3                   	ret

0000000000802e45 <opencons>:
opencons(void) {
  802e45:	f3 0f 1e fa          	endbr64
  802e49:	55                   	push   %rbp
  802e4a:	48 89 e5             	mov    %rsp,%rbp
  802e4d:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  802e51:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  802e55:	48 b8 7f 19 80 00 00 	movabs $0x80197f,%rax
  802e5c:	00 00 00 
  802e5f:	ff d0                	call   *%rax
  802e61:	85 c0                	test   %eax,%eax
  802e63:	78 49                	js     802eae <opencons+0x69>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  802e65:	b9 46 00 00 00       	mov    $0x46,%ecx
  802e6a:	ba 00 10 00 00       	mov    $0x1000,%edx
  802e6f:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  802e73:	bf 00 00 00 00       	mov    $0x0,%edi
  802e78:	48 b8 70 12 80 00 00 	movabs $0x801270,%rax
  802e7f:	00 00 00 
  802e82:	ff d0                	call   *%rax
  802e84:	85 c0                	test   %eax,%eax
  802e86:	78 26                	js     802eae <opencons+0x69>
    fd->fd_dev_id = devcons.dev_id;
  802e88:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802e8c:	a1 a0 50 80 00 00 00 	movabs 0x8050a0,%eax
  802e93:	00 00 
  802e95:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  802e97:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802e9b:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  802ea2:	48 b8 49 19 80 00 00 	movabs $0x801949,%rax
  802ea9:	00 00 00 
  802eac:	ff d0                	call   *%rax
}
  802eae:	c9                   	leave
  802eaf:	c3                   	ret

0000000000802eb0 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  802eb0:	f3 0f 1e fa          	endbr64
  802eb4:	55                   	push   %rbp
  802eb5:	48 89 e5             	mov    %rsp,%rbp
  802eb8:	41 56                	push   %r14
  802eba:	41 55                	push   %r13
  802ebc:	41 54                	push   %r12
  802ebe:	53                   	push   %rbx
  802ebf:	48 83 ec 50          	sub    $0x50,%rsp
  802ec3:	49 89 fc             	mov    %rdi,%r12
  802ec6:	41 89 f5             	mov    %esi,%r13d
  802ec9:	48 89 d3             	mov    %rdx,%rbx
  802ecc:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  802ed0:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  802ed4:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  802ed8:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  802edf:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802ee3:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  802ee7:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  802eeb:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  802eef:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  802ef6:	00 00 00 
  802ef9:	4c 8b 30             	mov    (%rax),%r14
  802efc:	48 b8 a0 11 80 00 00 	movabs $0x8011a0,%rax
  802f03:	00 00 00 
  802f06:	ff d0                	call   *%rax
  802f08:	89 c6                	mov    %eax,%esi
  802f0a:	45 89 e8             	mov    %r13d,%r8d
  802f0d:	4c 89 e1             	mov    %r12,%rcx
  802f10:	4c 89 f2             	mov    %r14,%rdx
  802f13:	48 bf c8 43 80 00 00 	movabs $0x8043c8,%rdi
  802f1a:	00 00 00 
  802f1d:	b8 00 00 00 00       	mov    $0x0,%eax
  802f22:	49 bc 22 03 80 00 00 	movabs $0x800322,%r12
  802f29:	00 00 00 
  802f2c:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  802f2f:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  802f33:	48 89 df             	mov    %rbx,%rdi
  802f36:	48 b8 ba 02 80 00 00 	movabs $0x8002ba,%rax
  802f3d:	00 00 00 
  802f40:	ff d0                	call   *%rax
    cprintf("\n");
  802f42:	48 bf 2c 42 80 00 00 	movabs $0x80422c,%rdi
  802f49:	00 00 00 
  802f4c:	b8 00 00 00 00       	mov    $0x0,%eax
  802f51:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  802f54:	cc                   	int3
  802f55:	eb fd                	jmp    802f54 <_panic+0xa4>

0000000000802f57 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
    # Call the C page fault handler.
    movq  %rsp,%rdi # passing the function argument in rdi
  802f57:	48 89 e7             	mov    %rsp,%rdi
    movabs $_handle_vectored_pagefault, %rax
  802f5a:	48 b8 dd 2f 80 00 00 	movabs $0x802fdd,%rax
  802f61:	00 00 00 
    call *%rax
  802f64:	ff d0                	call   *%rax
    # registers are available for intermediate calculations.  You
    # may find that you have to rearrange your code in non-obvious
    # ways as registers become unavailable as scratch space.

    # LAB 9: Your code here
    movq %rsp, %rax
  802f66:	48 89 e0             	mov    %rsp,%rax
    movq UTRAP_RIP(%rsp), %rbx
  802f69:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  802f70:	00 
    movq UTRAP_RSP(%rsp), %rsp
  802f71:	48 8b a4 24 98 00 00 	mov    0x98(%rsp),%rsp
  802f78:	00 
    pushq %rbx
  802f79:	53                   	push   %rbx
    movq %rsp, UTRAP_RSP(%rax)
  802f7a:	48 89 a0 98 00 00 00 	mov    %rsp,0x98(%rax)

    # Restore the trap-time registers.  After you do this, you
    # can no longer modify any general-purpose registers (use POPA macro).
    # LAB 9: Your code here
    movq %rax, %rsp
  802f81:	48 89 c4             	mov    %rax,%rsp
    addq $16, %rsp
  802f84:	48 83 c4 10          	add    $0x10,%rsp
    POPA
  802f88:	4c 8b 3c 24          	mov    (%rsp),%r15
  802f8c:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  802f91:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  802f96:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  802f9b:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  802fa0:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  802fa5:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  802faa:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  802faf:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  802fb4:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  802fb9:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  802fbe:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  802fc3:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  802fc8:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  802fcd:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  802fd2:	48 83 c4 78          	add    $0x78,%rsp
    addq $8, %rsp
  802fd6:	48 83 c4 08          	add    $0x8,%rsp
    # Restore rflags from the stack.  After you do this, you can
    # no longer use arithmetic operations or anything else that
    # modifies rflags.
    # LAB 9: Your code here
	popfq
  802fda:	9d                   	popf
    # Switch back to the adjusted trap-time stack.
    # LAB 9: Your code here
	popq %rsp
  802fdb:	5c                   	pop    %rsp
    # Return to re-execute the instruction that faulted.
    ret
  802fdc:	c3                   	ret

0000000000802fdd <_handle_vectored_pagefault>:
/* Vector size */
static size_t _pfhandler_off = 0;
static bool _pfhandler_inititiallized = 0;

void
_handle_vectored_pagefault(struct UTrapframe *utf) {
  802fdd:	f3 0f 1e fa          	endbr64
  802fe1:	55                   	push   %rbp
  802fe2:	48 89 e5             	mov    %rsp,%rbp
  802fe5:	41 56                	push   %r14
  802fe7:	41 55                	push   %r13
  802fe9:	41 54                	push   %r12
  802feb:	53                   	push   %rbx
  802fec:	49 89 fc             	mov    %rdi,%r12
    /* This trying to handle pagefault until
     * some handler returns 1, that indicates
     * successfully handled exception */
    for (size_t i = 0; i < _pfhandler_off; i++)
  802fef:	48 b8 68 80 80 00 00 	movabs $0x808068,%rax
  802ff6:	00 00 00 
  802ff9:	48 83 38 00          	cmpq   $0x0,(%rax)
  802ffd:	74 27                	je     803026 <_handle_vectored_pagefault+0x49>
  802fff:	bb 00 00 00 00       	mov    $0x0,%ebx
        if (_pfhandler_vec[i](utf)) return;
  803004:	49 bd 20 80 80 00 00 	movabs $0x808020,%r13
  80300b:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++)
  80300e:	49 89 c6             	mov    %rax,%r14
        if (_pfhandler_vec[i](utf)) return;
  803011:	4c 89 e7             	mov    %r12,%rdi
  803014:	41 ff 54 dd 00       	call   *0x0(%r13,%rbx,8)
  803019:	84 c0                	test   %al,%al
  80301b:	75 45                	jne    803062 <_handle_vectored_pagefault+0x85>
    for (size_t i = 0; i < _pfhandler_off; i++)
  80301d:	48 83 c3 01          	add    $0x1,%rbx
  803021:	49 3b 1e             	cmp    (%r14),%rbx
  803024:	72 eb                	jb     803011 <_handle_vectored_pagefault+0x34>

    /* Unhandled exceptions just cause panic */
    panic("Userspace page fault rip=%08lX va=%08lX err=%x\n",
  803026:	49 8b 8c 24 88 00 00 	mov    0x88(%r12),%rcx
  80302d:	00 
  80302e:	45 8b 4c 24 08       	mov    0x8(%r12),%r9d
  803033:	4d 8b 04 24          	mov    (%r12),%r8
  803037:	48 ba f0 43 80 00 00 	movabs $0x8043f0,%rdx
  80303e:	00 00 00 
  803041:	be 1d 00 00 00       	mov    $0x1d,%esi
  803046:	48 bf ab 42 80 00 00 	movabs $0x8042ab,%rdi
  80304d:	00 00 00 
  803050:	b8 00 00 00 00       	mov    $0x0,%eax
  803055:	49 ba b0 2e 80 00 00 	movabs $0x802eb0,%r10
  80305c:	00 00 00 
  80305f:	41 ff d2             	call   *%r10
          utf->utf_rip, utf->utf_fault_va, (int)utf->utf_err);
}
  803062:	5b                   	pop    %rbx
  803063:	41 5c                	pop    %r12
  803065:	41 5d                	pop    %r13
  803067:	41 5e                	pop    %r14
  803069:	5d                   	pop    %rbp
  80306a:	c3                   	ret

000000000080306b <add_pgfault_handler>:
 * The first time we register a handler, we need to
 * allocate an exception stack (one page of memory with its top
 * at USER_EXCEPTION_STACK_TOP), and tell the kernel to call the assembly-language
 * _pgfault_upcall routine when a page fault occurs. */
int
add_pgfault_handler(pf_handler_t handler) {
  80306b:	f3 0f 1e fa          	endbr64
  80306f:	55                   	push   %rbp
  803070:	48 89 e5             	mov    %rsp,%rbp
  803073:	53                   	push   %rbx
  803074:	48 83 ec 08          	sub    $0x8,%rsp
  803078:	48 89 fb             	mov    %rdi,%rbx
    int res = 0;
    if (!_pfhandler_inititiallized) {
  80307b:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  803082:	00 00 00 
  803085:	80 38 00             	cmpb   $0x0,(%rax)
  803088:	0f 84 84 00 00 00    	je     803112 <add_pgfault_handler+0xa7>
        _pfhandler_vec[_pfhandler_off++] = handler;
        _pfhandler_inititiallized = 1;
        goto end;
    }

    for (size_t i = 0; i < _pfhandler_off; i++)
  80308e:	48 b8 68 80 80 00 00 	movabs $0x808068,%rax
  803095:	00 00 00 
  803098:	48 8b 10             	mov    (%rax),%rdx
  80309b:	b8 00 00 00 00       	mov    $0x0,%eax
        if (handler == _pfhandler_vec[i]) return 0;
  8030a0:	48 b9 20 80 80 00 00 	movabs $0x808020,%rcx
  8030a7:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++)
  8030aa:	48 85 d2             	test   %rdx,%rdx
  8030ad:	74 19                	je     8030c8 <add_pgfault_handler+0x5d>
        if (handler == _pfhandler_vec[i]) return 0;
  8030af:	48 39 1c c1          	cmp    %rbx,(%rcx,%rax,8)
  8030b3:	0f 84 e8 00 00 00    	je     8031a1 <add_pgfault_handler+0x136>
    for (size_t i = 0; i < _pfhandler_off; i++)
  8030b9:	48 83 c0 01          	add    $0x1,%rax
  8030bd:	48 39 d0             	cmp    %rdx,%rax
  8030c0:	75 ed                	jne    8030af <add_pgfault_handler+0x44>

    if (_pfhandler_off == MAX_PFHANDLER)
  8030c2:	48 83 fa 08          	cmp    $0x8,%rdx
  8030c6:	74 1c                	je     8030e4 <add_pgfault_handler+0x79>
        res = -E_INVAL;
    else
        _pfhandler_vec[_pfhandler_off++] = handler;
  8030c8:	48 8d 42 01          	lea    0x1(%rdx),%rax
  8030cc:	48 a3 68 80 80 00 00 	movabs %rax,0x808068
  8030d3:	00 00 00 
  8030d6:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8030dd:	00 00 00 
  8030e0:	48 89 1c d0          	mov    %rbx,(%rax,%rdx,8)

end:
    res = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  8030e4:	48 b8 a0 11 80 00 00 	movabs $0x8011a0,%rax
  8030eb:	00 00 00 
  8030ee:	ff d0                	call   *%rax
  8030f0:	89 c7                	mov    %eax,%edi
  8030f2:	48 be 57 2f 80 00 00 	movabs $0x802f57,%rsi
  8030f9:	00 00 00 
  8030fc:	48 b8 f5 14 80 00 00 	movabs $0x8014f5,%rax
  803103:	00 00 00 
  803106:	ff d0                	call   *%rax
    if (res < 0) panic("set_pgfault_handler: %i", res);
  803108:	85 c0                	test   %eax,%eax
  80310a:	78 68                	js     803174 <add_pgfault_handler+0x109>
    return res;
}
  80310c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  803110:	c9                   	leave
  803111:	c3                   	ret
        res = sys_alloc_region(sys_getenvid(), (void*)(USER_EXCEPTION_STACK_TOP - PAGE_SIZE), PAGE_SIZE, PROT_RW);
  803112:	48 b8 a0 11 80 00 00 	movabs $0x8011a0,%rax
  803119:	00 00 00 
  80311c:	ff d0                	call   *%rax
  80311e:	89 c7                	mov    %eax,%edi
  803120:	b9 06 00 00 00       	mov    $0x6,%ecx
  803125:	ba 00 10 00 00       	mov    $0x1000,%edx
  80312a:	48 be 00 f0 ff ff 7f 	movabs $0x7ffffff000,%rsi
  803131:	00 00 00 
  803134:	48 b8 70 12 80 00 00 	movabs $0x801270,%rax
  80313b:	00 00 00 
  80313e:	ff d0                	call   *%rax
        _pfhandler_vec[_pfhandler_off++] = handler;
  803140:	48 ba 68 80 80 00 00 	movabs $0x808068,%rdx
  803147:	00 00 00 
  80314a:	48 8b 02             	mov    (%rdx),%rax
  80314d:	48 8d 48 01          	lea    0x1(%rax),%rcx
  803151:	48 89 0a             	mov    %rcx,(%rdx)
  803154:	48 ba 20 80 80 00 00 	movabs $0x808020,%rdx
  80315b:	00 00 00 
  80315e:	48 89 1c c2          	mov    %rbx,(%rdx,%rax,8)
        _pfhandler_inititiallized = 1;
  803162:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  803169:	00 00 00 
  80316c:	c6 00 01             	movb   $0x1,(%rax)
        goto end;
  80316f:	e9 70 ff ff ff       	jmp    8030e4 <add_pgfault_handler+0x79>
    if (res < 0) panic("set_pgfault_handler: %i", res);
  803174:	89 c1                	mov    %eax,%ecx
  803176:	48 ba b9 42 80 00 00 	movabs $0x8042b9,%rdx
  80317d:	00 00 00 
  803180:	be 3d 00 00 00       	mov    $0x3d,%esi
  803185:	48 bf ab 42 80 00 00 	movabs $0x8042ab,%rdi
  80318c:	00 00 00 
  80318f:	b8 00 00 00 00       	mov    $0x0,%eax
  803194:	49 b8 b0 2e 80 00 00 	movabs $0x802eb0,%r8
  80319b:	00 00 00 
  80319e:	41 ff d0             	call   *%r8
        if (handler == _pfhandler_vec[i]) return 0;
  8031a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8031a6:	e9 61 ff ff ff       	jmp    80310c <add_pgfault_handler+0xa1>

00000000008031ab <remove_pgfault_handler>:

void
remove_pgfault_handler(pf_handler_t handler) {
  8031ab:	f3 0f 1e fa          	endbr64
  8031af:	55                   	push   %rbp
  8031b0:	48 89 e5             	mov    %rsp,%rbp
    assert(_pfhandler_inititiallized);
  8031b3:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  8031ba:	00 00 00 
  8031bd:	80 38 00             	cmpb   $0x0,(%rax)
  8031c0:	74 33                	je     8031f5 <remove_pgfault_handler+0x4a>
    for (size_t i = 0; i < _pfhandler_off; i++) {
  8031c2:	48 a1 68 80 80 00 00 	movabs 0x808068,%rax
  8031c9:	00 00 00 
  8031cc:	b9 00 00 00 00       	mov    $0x0,%ecx
        if (_pfhandler_vec[i] == handler) {
  8031d1:	48 ba 20 80 80 00 00 	movabs $0x808020,%rdx
  8031d8:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++) {
  8031db:	48 85 c0             	test   %rax,%rax
  8031de:	0f 84 85 00 00 00    	je     803269 <remove_pgfault_handler+0xbe>
        if (_pfhandler_vec[i] == handler) {
  8031e4:	48 39 3c ca          	cmp    %rdi,(%rdx,%rcx,8)
  8031e8:	74 40                	je     80322a <remove_pgfault_handler+0x7f>
    for (size_t i = 0; i < _pfhandler_off; i++) {
  8031ea:	48 83 c1 01          	add    $0x1,%rcx
  8031ee:	48 39 c1             	cmp    %rax,%rcx
  8031f1:	75 f1                	jne    8031e4 <remove_pgfault_handler+0x39>
  8031f3:	eb 74                	jmp    803269 <remove_pgfault_handler+0xbe>
    assert(_pfhandler_inititiallized);
  8031f5:	48 b9 d1 42 80 00 00 	movabs $0x8042d1,%rcx
  8031fc:	00 00 00 
  8031ff:	48 ba 68 42 80 00 00 	movabs $0x804268,%rdx
  803206:	00 00 00 
  803209:	be 43 00 00 00       	mov    $0x43,%esi
  80320e:	48 bf ab 42 80 00 00 	movabs $0x8042ab,%rdi
  803215:	00 00 00 
  803218:	b8 00 00 00 00       	mov    $0x0,%eax
  80321d:	49 b8 b0 2e 80 00 00 	movabs $0x802eb0,%r8
  803224:	00 00 00 
  803227:	41 ff d0             	call   *%r8
            memmove(_pfhandler_vec + i, _pfhandler_vec + i + 1, (_pfhandler_off - i - 1) * sizeof(*handler));
  80322a:	48 8d 34 cd 08 00 00 	lea    0x8(,%rcx,8),%rsi
  803231:	00 
  803232:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  803236:	48 29 ca             	sub    %rcx,%rdx
  803239:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  803240:	00 00 00 
  803243:	48 8d 0c 06          	lea    (%rsi,%rax,1),%rcx
  803247:	48 8d 7c 30 f8       	lea    -0x8(%rax,%rsi,1),%rdi
  80324c:	48 89 ce             	mov    %rcx,%rsi
  80324f:	48 b8 86 0e 80 00 00 	movabs $0x800e86,%rax
  803256:	00 00 00 
  803259:	ff d0                	call   *%rax
            _pfhandler_off--;
  80325b:	48 b8 68 80 80 00 00 	movabs $0x808068,%rax
  803262:	00 00 00 
  803265:	48 83 28 01          	subq   $0x1,(%rax)
            return;
        }
    }
}
  803269:	5d                   	pop    %rbp
  80326a:	c3                   	ret

000000000080326b <__text_end>:
  80326b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803272:	00 00 00 
  803275:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80327c:	00 00 00 
  80327f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803286:	00 00 00 
  803289:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803290:	00 00 00 
  803293:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80329a:	00 00 00 
  80329d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032a4:	00 00 00 
  8032a7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032ae:	00 00 00 
  8032b1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032b8:	00 00 00 
  8032bb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032c2:	00 00 00 
  8032c5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032cc:	00 00 00 
  8032cf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032d6:	00 00 00 
  8032d9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032e0:	00 00 00 
  8032e3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032ea:	00 00 00 
  8032ed:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032f4:	00 00 00 
  8032f7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032fe:	00 00 00 
  803301:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803308:	00 00 00 
  80330b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803312:	00 00 00 
  803315:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80331c:	00 00 00 
  80331f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803326:	00 00 00 
  803329:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803330:	00 00 00 
  803333:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80333a:	00 00 00 
  80333d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803344:	00 00 00 
  803347:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80334e:	00 00 00 
  803351:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803358:	00 00 00 
  80335b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803362:	00 00 00 
  803365:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80336c:	00 00 00 
  80336f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803376:	00 00 00 
  803379:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803380:	00 00 00 
  803383:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80338a:	00 00 00 
  80338d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803394:	00 00 00 
  803397:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80339e:	00 00 00 
  8033a1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033a8:	00 00 00 
  8033ab:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033b2:	00 00 00 
  8033b5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033bc:	00 00 00 
  8033bf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033c6:	00 00 00 
  8033c9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033d0:	00 00 00 
  8033d3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033da:	00 00 00 
  8033dd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033e4:	00 00 00 
  8033e7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033ee:	00 00 00 
  8033f1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033f8:	00 00 00 
  8033fb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803402:	00 00 00 
  803405:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80340c:	00 00 00 
  80340f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803416:	00 00 00 
  803419:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803420:	00 00 00 
  803423:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80342a:	00 00 00 
  80342d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803434:	00 00 00 
  803437:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80343e:	00 00 00 
  803441:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803448:	00 00 00 
  80344b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803452:	00 00 00 
  803455:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80345c:	00 00 00 
  80345f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803466:	00 00 00 
  803469:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803470:	00 00 00 
  803473:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80347a:	00 00 00 
  80347d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803484:	00 00 00 
  803487:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80348e:	00 00 00 
  803491:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803498:	00 00 00 
  80349b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034a2:	00 00 00 
  8034a5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034ac:	00 00 00 
  8034af:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034b6:	00 00 00 
  8034b9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034c0:	00 00 00 
  8034c3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034ca:	00 00 00 
  8034cd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034d4:	00 00 00 
  8034d7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034de:	00 00 00 
  8034e1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034e8:	00 00 00 
  8034eb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034f2:	00 00 00 
  8034f5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034fc:	00 00 00 
  8034ff:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803506:	00 00 00 
  803509:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803510:	00 00 00 
  803513:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80351a:	00 00 00 
  80351d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803524:	00 00 00 
  803527:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80352e:	00 00 00 
  803531:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803538:	00 00 00 
  80353b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803542:	00 00 00 
  803545:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80354c:	00 00 00 
  80354f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803556:	00 00 00 
  803559:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803560:	00 00 00 
  803563:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80356a:	00 00 00 
  80356d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803574:	00 00 00 
  803577:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80357e:	00 00 00 
  803581:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803588:	00 00 00 
  80358b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803592:	00 00 00 
  803595:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80359c:	00 00 00 
  80359f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035a6:	00 00 00 
  8035a9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035b0:	00 00 00 
  8035b3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035ba:	00 00 00 
  8035bd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035c4:	00 00 00 
  8035c7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035ce:	00 00 00 
  8035d1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035d8:	00 00 00 
  8035db:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035e2:	00 00 00 
  8035e5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035ec:	00 00 00 
  8035ef:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035f6:	00 00 00 
  8035f9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803600:	00 00 00 
  803603:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80360a:	00 00 00 
  80360d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803614:	00 00 00 
  803617:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80361e:	00 00 00 
  803621:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803628:	00 00 00 
  80362b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803632:	00 00 00 
  803635:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80363c:	00 00 00 
  80363f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803646:	00 00 00 
  803649:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803650:	00 00 00 
  803653:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80365a:	00 00 00 
  80365d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803664:	00 00 00 
  803667:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80366e:	00 00 00 
  803671:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803678:	00 00 00 
  80367b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803682:	00 00 00 
  803685:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80368c:	00 00 00 
  80368f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803696:	00 00 00 
  803699:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036a0:	00 00 00 
  8036a3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036aa:	00 00 00 
  8036ad:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036b4:	00 00 00 
  8036b7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036be:	00 00 00 
  8036c1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036c8:	00 00 00 
  8036cb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036d2:	00 00 00 
  8036d5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036dc:	00 00 00 
  8036df:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036e6:	00 00 00 
  8036e9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036f0:	00 00 00 
  8036f3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036fa:	00 00 00 
  8036fd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803704:	00 00 00 
  803707:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80370e:	00 00 00 
  803711:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803718:	00 00 00 
  80371b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803722:	00 00 00 
  803725:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80372c:	00 00 00 
  80372f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803736:	00 00 00 
  803739:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803740:	00 00 00 
  803743:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80374a:	00 00 00 
  80374d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803754:	00 00 00 
  803757:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80375e:	00 00 00 
  803761:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803768:	00 00 00 
  80376b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803772:	00 00 00 
  803775:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80377c:	00 00 00 
  80377f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803786:	00 00 00 
  803789:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803790:	00 00 00 
  803793:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80379a:	00 00 00 
  80379d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037a4:	00 00 00 
  8037a7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037ae:	00 00 00 
  8037b1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037b8:	00 00 00 
  8037bb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037c2:	00 00 00 
  8037c5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037cc:	00 00 00 
  8037cf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037d6:	00 00 00 
  8037d9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037e0:	00 00 00 
  8037e3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037ea:	00 00 00 
  8037ed:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037f4:	00 00 00 
  8037f7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037fe:	00 00 00 
  803801:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803808:	00 00 00 
  80380b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803812:	00 00 00 
  803815:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80381c:	00 00 00 
  80381f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803826:	00 00 00 
  803829:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803830:	00 00 00 
  803833:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80383a:	00 00 00 
  80383d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803844:	00 00 00 
  803847:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80384e:	00 00 00 
  803851:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803858:	00 00 00 
  80385b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803862:	00 00 00 
  803865:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80386c:	00 00 00 
  80386f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803876:	00 00 00 
  803879:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803880:	00 00 00 
  803883:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80388a:	00 00 00 
  80388d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803894:	00 00 00 
  803897:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80389e:	00 00 00 
  8038a1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038a8:	00 00 00 
  8038ab:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038b2:	00 00 00 
  8038b5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038bc:	00 00 00 
  8038bf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038c6:	00 00 00 
  8038c9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038d0:	00 00 00 
  8038d3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038da:	00 00 00 
  8038dd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038e4:	00 00 00 
  8038e7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038ee:	00 00 00 
  8038f1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038f8:	00 00 00 
  8038fb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803902:	00 00 00 
  803905:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80390c:	00 00 00 
  80390f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803916:	00 00 00 
  803919:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803920:	00 00 00 
  803923:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80392a:	00 00 00 
  80392d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803934:	00 00 00 
  803937:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80393e:	00 00 00 
  803941:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803948:	00 00 00 
  80394b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803952:	00 00 00 
  803955:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80395c:	00 00 00 
  80395f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803966:	00 00 00 
  803969:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803970:	00 00 00 
  803973:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80397a:	00 00 00 
  80397d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803984:	00 00 00 
  803987:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80398e:	00 00 00 
  803991:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803998:	00 00 00 
  80399b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039a2:	00 00 00 
  8039a5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039ac:	00 00 00 
  8039af:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039b6:	00 00 00 
  8039b9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039c0:	00 00 00 
  8039c3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039ca:	00 00 00 
  8039cd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039d4:	00 00 00 
  8039d7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039de:	00 00 00 
  8039e1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039e8:	00 00 00 
  8039eb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039f2:	00 00 00 
  8039f5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039fc:	00 00 00 
  8039ff:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a06:	00 00 00 
  803a09:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a10:	00 00 00 
  803a13:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a1a:	00 00 00 
  803a1d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a24:	00 00 00 
  803a27:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a2e:	00 00 00 
  803a31:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a38:	00 00 00 
  803a3b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a42:	00 00 00 
  803a45:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a4c:	00 00 00 
  803a4f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a56:	00 00 00 
  803a59:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a60:	00 00 00 
  803a63:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a6a:	00 00 00 
  803a6d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a74:	00 00 00 
  803a77:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a7e:	00 00 00 
  803a81:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a88:	00 00 00 
  803a8b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a92:	00 00 00 
  803a95:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a9c:	00 00 00 
  803a9f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803aa6:	00 00 00 
  803aa9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ab0:	00 00 00 
  803ab3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803aba:	00 00 00 
  803abd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ac4:	00 00 00 
  803ac7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ace:	00 00 00 
  803ad1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ad8:	00 00 00 
  803adb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ae2:	00 00 00 
  803ae5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803aec:	00 00 00 
  803aef:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803af6:	00 00 00 
  803af9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b00:	00 00 00 
  803b03:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b0a:	00 00 00 
  803b0d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b14:	00 00 00 
  803b17:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b1e:	00 00 00 
  803b21:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b28:	00 00 00 
  803b2b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b32:	00 00 00 
  803b35:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b3c:	00 00 00 
  803b3f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b46:	00 00 00 
  803b49:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b50:	00 00 00 
  803b53:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b5a:	00 00 00 
  803b5d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b64:	00 00 00 
  803b67:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b6e:	00 00 00 
  803b71:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b78:	00 00 00 
  803b7b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b82:	00 00 00 
  803b85:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b8c:	00 00 00 
  803b8f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b96:	00 00 00 
  803b99:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ba0:	00 00 00 
  803ba3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803baa:	00 00 00 
  803bad:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bb4:	00 00 00 
  803bb7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bbe:	00 00 00 
  803bc1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bc8:	00 00 00 
  803bcb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bd2:	00 00 00 
  803bd5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bdc:	00 00 00 
  803bdf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803be6:	00 00 00 
  803be9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bf0:	00 00 00 
  803bf3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bfa:	00 00 00 
  803bfd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c04:	00 00 00 
  803c07:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c0e:	00 00 00 
  803c11:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c18:	00 00 00 
  803c1b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c22:	00 00 00 
  803c25:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c2c:	00 00 00 
  803c2f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c36:	00 00 00 
  803c39:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c40:	00 00 00 
  803c43:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c4a:	00 00 00 
  803c4d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c54:	00 00 00 
  803c57:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c5e:	00 00 00 
  803c61:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c68:	00 00 00 
  803c6b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c72:	00 00 00 
  803c75:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c7c:	00 00 00 
  803c7f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c86:	00 00 00 
  803c89:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c90:	00 00 00 
  803c93:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c9a:	00 00 00 
  803c9d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ca4:	00 00 00 
  803ca7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cae:	00 00 00 
  803cb1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cb8:	00 00 00 
  803cbb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cc2:	00 00 00 
  803cc5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ccc:	00 00 00 
  803ccf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cd6:	00 00 00 
  803cd9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ce0:	00 00 00 
  803ce3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cea:	00 00 00 
  803ced:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cf4:	00 00 00 
  803cf7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cfe:	00 00 00 
  803d01:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d08:	00 00 00 
  803d0b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d12:	00 00 00 
  803d15:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d1c:	00 00 00 
  803d1f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d26:	00 00 00 
  803d29:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d30:	00 00 00 
  803d33:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d3a:	00 00 00 
  803d3d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d44:	00 00 00 
  803d47:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d4e:	00 00 00 
  803d51:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d58:	00 00 00 
  803d5b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d62:	00 00 00 
  803d65:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d6c:	00 00 00 
  803d6f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d76:	00 00 00 
  803d79:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d80:	00 00 00 
  803d83:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d8a:	00 00 00 
  803d8d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d94:	00 00 00 
  803d97:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d9e:	00 00 00 
  803da1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803da8:	00 00 00 
  803dab:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803db2:	00 00 00 
  803db5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dbc:	00 00 00 
  803dbf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dc6:	00 00 00 
  803dc9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dd0:	00 00 00 
  803dd3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dda:	00 00 00 
  803ddd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803de4:	00 00 00 
  803de7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dee:	00 00 00 
  803df1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803df8:	00 00 00 
  803dfb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e02:	00 00 00 
  803e05:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e0c:	00 00 00 
  803e0f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e16:	00 00 00 
  803e19:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e20:	00 00 00 
  803e23:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e2a:	00 00 00 
  803e2d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e34:	00 00 00 
  803e37:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e3e:	00 00 00 
  803e41:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e48:	00 00 00 
  803e4b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e52:	00 00 00 
  803e55:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e5c:	00 00 00 
  803e5f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e66:	00 00 00 
  803e69:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e70:	00 00 00 
  803e73:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e7a:	00 00 00 
  803e7d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e84:	00 00 00 
  803e87:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e8e:	00 00 00 
  803e91:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e98:	00 00 00 
  803e9b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ea2:	00 00 00 
  803ea5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803eac:	00 00 00 
  803eaf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803eb6:	00 00 00 
  803eb9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ec0:	00 00 00 
  803ec3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803eca:	00 00 00 
  803ecd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ed4:	00 00 00 
  803ed7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ede:	00 00 00 
  803ee1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ee8:	00 00 00 
  803eeb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ef2:	00 00 00 
  803ef5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803efc:	00 00 00 
  803eff:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f06:	00 00 00 
  803f09:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f10:	00 00 00 
  803f13:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f1a:	00 00 00 
  803f1d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f24:	00 00 00 
  803f27:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f2e:	00 00 00 
  803f31:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f38:	00 00 00 
  803f3b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f42:	00 00 00 
  803f45:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f4c:	00 00 00 
  803f4f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f56:	00 00 00 
  803f59:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f60:	00 00 00 
  803f63:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f6a:	00 00 00 
  803f6d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f74:	00 00 00 
  803f77:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f7e:	00 00 00 
  803f81:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f88:	00 00 00 
  803f8b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f92:	00 00 00 
  803f95:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f9c:	00 00 00 
  803f9f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fa6:	00 00 00 
  803fa9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fb0:	00 00 00 
  803fb3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fba:	00 00 00 
  803fbd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fc4:	00 00 00 
  803fc7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fce:	00 00 00 
  803fd1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fd8:	00 00 00 
  803fdb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fe2:	00 00 00 
  803fe5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fec:	00 00 00 
  803fef:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ff6:	00 00 00 
  803ff9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
