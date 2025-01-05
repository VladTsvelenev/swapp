
obj/user/forktree:     file format elf64-x86-64


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
  80001e:	e8 0b 01 00 00       	call   80012e <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <forktree>:
        exit();
    }
}

void
forktree(const char *cur) {
  800025:	f3 0f 1e fa          	endbr64
  800029:	55                   	push   %rbp
  80002a:	48 89 e5             	mov    %rsp,%rbp
  80002d:	41 54                	push   %r12
  80002f:	53                   	push   %rbx
  800030:	48 89 fb             	mov    %rdi,%rbx
    cprintf("%04x: I am '%s'\n", sys_getenvid(), cur);
  800033:	48 b8 3a 11 80 00 00 	movabs $0x80113a,%rax
  80003a:	00 00 00 
  80003d:	ff d0                	call   *%rax
  80003f:	89 c6                	mov    %eax,%esi
  800041:	48 89 da             	mov    %rbx,%rdx
  800044:	48 bf 00 40 80 00 00 	movabs $0x804000,%rdi
  80004b:	00 00 00 
  80004e:	b8 00 00 00 00       	mov    $0x0,%eax
  800053:	48 b9 bc 02 80 00 00 	movabs $0x8002bc,%rcx
  80005a:	00 00 00 
  80005d:	ff d1                	call   *%rcx

    forkchild(cur, '0');
  80005f:	be 30 00 00 00       	mov    $0x30,%esi
  800064:	48 89 df             	mov    %rbx,%rdi
  800067:	49 bc 84 00 80 00 00 	movabs $0x800084,%r12
  80006e:	00 00 00 
  800071:	41 ff d4             	call   *%r12
    forkchild(cur, '1');
  800074:	be 31 00 00 00       	mov    $0x31,%esi
  800079:	48 89 df             	mov    %rbx,%rdi
  80007c:	41 ff d4             	call   *%r12
}
  80007f:	5b                   	pop    %rbx
  800080:	41 5c                	pop    %r12
  800082:	5d                   	pop    %rbp
  800083:	c3                   	ret

0000000000800084 <forkchild>:
forkchild(const char *cur, char branch) {
  800084:	f3 0f 1e fa          	endbr64
  800088:	55                   	push   %rbp
  800089:	48 89 e5             	mov    %rsp,%rbp
  80008c:	41 54                	push   %r12
  80008e:	53                   	push   %rbx
  80008f:	48 83 ec 10          	sub    $0x10,%rsp
  800093:	48 89 fb             	mov    %rdi,%rbx
  800096:	41 89 f4             	mov    %esi,%r12d
    if (strlen(cur) >= DEPTH)
  800099:	48 b8 c0 0b 80 00 00 	movabs $0x800bc0,%rax
  8000a0:	00 00 00 
  8000a3:	ff d0                	call   *%rax
  8000a5:	48 83 f8 02          	cmp    $0x2,%rax
  8000a9:	76 09                	jbe    8000b4 <forkchild+0x30>
}
  8000ab:	48 83 c4 10          	add    $0x10,%rsp
  8000af:	5b                   	pop    %rbx
  8000b0:	41 5c                	pop    %r12
  8000b2:	5d                   	pop    %rbp
  8000b3:	c3                   	ret
    snprintf(nxt, DEPTH + 1, "%s%c", cur, branch);
  8000b4:	45 0f be c4          	movsbl %r12b,%r8d
  8000b8:	48 89 d9             	mov    %rbx,%rcx
  8000bb:	48 ba 11 40 80 00 00 	movabs $0x804011,%rdx
  8000c2:	00 00 00 
  8000c5:	be 04 00 00 00       	mov    $0x4,%esi
  8000ca:	48 8d 7d ec          	lea    -0x14(%rbp),%rdi
  8000ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d3:	49 b9 7f 0b 80 00 00 	movabs $0x800b7f,%r9
  8000da:	00 00 00 
  8000dd:	41 ff d1             	call   *%r9
    if (fork() == 0) {
  8000e0:	48 b8 ce 15 80 00 00 	movabs $0x8015ce,%rax
  8000e7:	00 00 00 
  8000ea:	ff d0                	call   *%rax
  8000ec:	85 c0                	test   %eax,%eax
  8000ee:	75 bb                	jne    8000ab <forkchild+0x27>
        forktree(nxt);
  8000f0:	48 8d 7d ec          	lea    -0x14(%rbp),%rdi
  8000f4:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  8000fb:	00 00 00 
  8000fe:	ff d0                	call   *%rax
        exit();
  800100:	48 b8 e0 01 80 00 00 	movabs $0x8001e0,%rax
  800107:	00 00 00 
  80010a:	ff d0                	call   *%rax
  80010c:	eb 9d                	jmp    8000ab <forkchild+0x27>

000000000080010e <umain>:

void
umain(int argc, char **argv) {
  80010e:	f3 0f 1e fa          	endbr64
  800112:	55                   	push   %rbp
  800113:	48 89 e5             	mov    %rsp,%rbp
    forktree("");
  800116:	48 bf 10 40 80 00 00 	movabs $0x804010,%rdi
  80011d:	00 00 00 
  800120:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  800127:	00 00 00 
  80012a:	ff d0                	call   *%rax
}
  80012c:	5d                   	pop    %rbp
  80012d:	c3                   	ret

000000000080012e <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  80012e:	f3 0f 1e fa          	endbr64
  800132:	55                   	push   %rbp
  800133:	48 89 e5             	mov    %rsp,%rbp
  800136:	41 56                	push   %r14
  800138:	41 55                	push   %r13
  80013a:	41 54                	push   %r12
  80013c:	53                   	push   %rbx
  80013d:	41 89 fd             	mov    %edi,%r13d
  800140:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
     * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  800143:	48 ba d8 50 80 00 00 	movabs $0x8050d8,%rdx
  80014a:	00 00 00 
  80014d:	48 b8 d8 50 80 00 00 	movabs $0x8050d8,%rax
  800154:	00 00 00 
  800157:	48 39 c2             	cmp    %rax,%rdx
  80015a:	73 17                	jae    800173 <libmain+0x45>
    void (**ctor)() = &__ctors_start;
  80015c:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  80015f:	49 89 c4             	mov    %rax,%r12
  800162:	48 83 c3 08          	add    $0x8,%rbx
  800166:	b8 00 00 00 00       	mov    $0x0,%eax
  80016b:	ff 53 f8             	call   *-0x8(%rbx)
  80016e:	4c 39 e3             	cmp    %r12,%rbx
  800171:	72 ef                	jb     800162 <libmain+0x34>

    /* Set thisenv to point at our Env structure in envs[]. */

    // LAB 8: Your code here
    thisenv = &((struct Env *)UENVS)[ENVX(sys_getenvid())];
  800173:	48 b8 3a 11 80 00 00 	movabs $0x80113a,%rax
  80017a:	00 00 00 
  80017d:	ff d0                	call   *%rax
  80017f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800184:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  800188:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  80018c:	48 c1 e0 04          	shl    $0x4,%rax
  800190:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  800197:	00 00 00 
  80019a:	48 01 d0             	add    %rdx,%rax
  80019d:	48 a3 00 60 80 00 00 	movabs %rax,0x806000
  8001a4:	00 00 00 

    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  8001a7:	45 85 ed             	test   %r13d,%r13d
  8001aa:	7e 0d                	jle    8001b9 <libmain+0x8b>
  8001ac:	49 8b 06             	mov    (%r14),%rax
  8001af:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  8001b6:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  8001b9:	4c 89 f6             	mov    %r14,%rsi
  8001bc:	44 89 ef             	mov    %r13d,%edi
  8001bf:	48 b8 0e 01 80 00 00 	movabs $0x80010e,%rax
  8001c6:	00 00 00 
  8001c9:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  8001cb:	48 b8 e0 01 80 00 00 	movabs $0x8001e0,%rax
  8001d2:	00 00 00 
  8001d5:	ff d0                	call   *%rax
#endif
}
  8001d7:	5b                   	pop    %rbx
  8001d8:	41 5c                	pop    %r12
  8001da:	41 5d                	pop    %r13
  8001dc:	41 5e                	pop    %r14
  8001de:	5d                   	pop    %rbp
  8001df:	c3                   	ret

00000000008001e0 <exit>:

#include <inc/lib.h>

void
exit(void) {
  8001e0:	f3 0f 1e fa          	endbr64
  8001e4:	55                   	push   %rbp
  8001e5:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  8001e8:	48 b8 6c 19 80 00 00 	movabs $0x80196c,%rax
  8001ef:	00 00 00 
  8001f2:	ff d0                	call   *%rax
    sys_env_destroy(0);
  8001f4:	bf 00 00 00 00       	mov    $0x0,%edi
  8001f9:	48 b8 cb 10 80 00 00 	movabs $0x8010cb,%rax
  800200:	00 00 00 
  800203:	ff d0                	call   *%rax
}
  800205:	5d                   	pop    %rbp
  800206:	c3                   	ret

0000000000800207 <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  800207:	f3 0f 1e fa          	endbr64
  80020b:	55                   	push   %rbp
  80020c:	48 89 e5             	mov    %rsp,%rbp
  80020f:	53                   	push   %rbx
  800210:	48 83 ec 08          	sub    $0x8,%rsp
  800214:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  800217:	8b 06                	mov    (%rsi),%eax
  800219:	8d 50 01             	lea    0x1(%rax),%edx
  80021c:	89 16                	mov    %edx,(%rsi)
  80021e:	48 98                	cltq
  800220:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  800225:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  80022b:	74 0a                	je     800237 <putch+0x30>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  80022d:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  800231:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800235:	c9                   	leave
  800236:	c3                   	ret
        sys_cputs(state->buf, state->offset);
  800237:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  80023b:	be ff 00 00 00       	mov    $0xff,%esi
  800240:	48 b8 65 10 80 00 00 	movabs $0x801065,%rax
  800247:	00 00 00 
  80024a:	ff d0                	call   *%rax
        state->offset = 0;
  80024c:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  800252:	eb d9                	jmp    80022d <putch+0x26>

0000000000800254 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  800254:	f3 0f 1e fa          	endbr64
  800258:	55                   	push   %rbp
  800259:	48 89 e5             	mov    %rsp,%rbp
  80025c:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800263:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  800266:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  80026d:	b9 21 00 00 00       	mov    $0x21,%ecx
  800272:	b8 00 00 00 00       	mov    $0x0,%eax
  800277:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  80027a:	48 89 f1             	mov    %rsi,%rcx
  80027d:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  800284:	48 bf 07 02 80 00 00 	movabs $0x800207,%rdi
  80028b:	00 00 00 
  80028e:	48 b8 1c 04 80 00 00 	movabs $0x80041c,%rax
  800295:	00 00 00 
  800298:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  80029a:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  8002a1:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  8002a8:	48 b8 65 10 80 00 00 	movabs $0x801065,%rax
  8002af:	00 00 00 
  8002b2:	ff d0                	call   *%rax

    return state.count;
}
  8002b4:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  8002ba:	c9                   	leave
  8002bb:	c3                   	ret

00000000008002bc <cprintf>:

int
cprintf(const char *fmt, ...) {
  8002bc:	f3 0f 1e fa          	endbr64
  8002c0:	55                   	push   %rbp
  8002c1:	48 89 e5             	mov    %rsp,%rbp
  8002c4:	48 83 ec 50          	sub    $0x50,%rsp
  8002c8:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  8002cc:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8002d0:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8002d4:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8002d8:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  8002dc:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  8002e3:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002e7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8002eb:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8002ef:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  8002f3:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  8002f7:	48 b8 54 02 80 00 00 	movabs $0x800254,%rax
  8002fe:	00 00 00 
  800301:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  800303:	c9                   	leave
  800304:	c3                   	ret

0000000000800305 <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  800305:	f3 0f 1e fa          	endbr64
  800309:	55                   	push   %rbp
  80030a:	48 89 e5             	mov    %rsp,%rbp
  80030d:	41 57                	push   %r15
  80030f:	41 56                	push   %r14
  800311:	41 55                	push   %r13
  800313:	41 54                	push   %r12
  800315:	53                   	push   %rbx
  800316:	48 83 ec 18          	sub    $0x18,%rsp
  80031a:	49 89 fc             	mov    %rdi,%r12
  80031d:	49 89 f5             	mov    %rsi,%r13
  800320:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  800324:	8b 45 10             	mov    0x10(%rbp),%eax
  800327:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  80032a:	41 89 cf             	mov    %ecx,%r15d
  80032d:	4c 39 fa             	cmp    %r15,%rdx
  800330:	73 5b                	jae    80038d <print_num+0x88>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  800332:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  800336:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  80033a:	85 db                	test   %ebx,%ebx
  80033c:	7e 0e                	jle    80034c <print_num+0x47>
            putch(padc, put_arg);
  80033e:	4c 89 ee             	mov    %r13,%rsi
  800341:	44 89 f7             	mov    %r14d,%edi
  800344:	41 ff d4             	call   *%r12
        while (--width > 0) {
  800347:	83 eb 01             	sub    $0x1,%ebx
  80034a:	75 f2                	jne    80033e <print_num+0x39>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  80034c:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  800350:	48 b9 31 40 80 00 00 	movabs $0x804031,%rcx
  800357:	00 00 00 
  80035a:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  800361:	00 00 00 
  800364:	48 0f 45 c8          	cmovne %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  800368:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80036c:	ba 00 00 00 00       	mov    $0x0,%edx
  800371:	49 f7 f7             	div    %r15
  800374:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  800378:	4c 89 ee             	mov    %r13,%rsi
  80037b:	41 ff d4             	call   *%r12
}
  80037e:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800382:	5b                   	pop    %rbx
  800383:	41 5c                	pop    %r12
  800385:	41 5d                	pop    %r13
  800387:	41 5e                	pop    %r14
  800389:	41 5f                	pop    %r15
  80038b:	5d                   	pop    %rbp
  80038c:	c3                   	ret
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  80038d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800391:	ba 00 00 00 00       	mov    $0x0,%edx
  800396:	49 f7 f7             	div    %r15
  800399:	48 83 ec 08          	sub    $0x8,%rsp
  80039d:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  8003a1:	52                   	push   %rdx
  8003a2:	45 0f be c9          	movsbl %r9b,%r9d
  8003a6:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  8003aa:	48 89 c2             	mov    %rax,%rdx
  8003ad:	48 b8 05 03 80 00 00 	movabs $0x800305,%rax
  8003b4:	00 00 00 
  8003b7:	ff d0                	call   *%rax
  8003b9:	48 83 c4 10          	add    $0x10,%rsp
  8003bd:	eb 8d                	jmp    80034c <print_num+0x47>

00000000008003bf <sprintputch>:
    char *end;
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
  8003bf:	f3 0f 1e fa          	endbr64
    state->count++;
  8003c3:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  8003c7:	48 8b 06             	mov    (%rsi),%rax
  8003ca:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  8003ce:	73 0a                	jae    8003da <sprintputch+0x1b>
        *state->start++ = ch;
  8003d0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8003d4:	48 89 16             	mov    %rdx,(%rsi)
  8003d7:	40 88 38             	mov    %dil,(%rax)
    }
}
  8003da:	c3                   	ret

00000000008003db <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  8003db:	f3 0f 1e fa          	endbr64
  8003df:	55                   	push   %rbp
  8003e0:	48 89 e5             	mov    %rsp,%rbp
  8003e3:	48 83 ec 50          	sub    $0x50,%rsp
  8003e7:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8003eb:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8003ef:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  8003f3:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  8003fa:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8003fe:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800402:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800406:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  80040a:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  80040e:	48 b8 1c 04 80 00 00 	movabs $0x80041c,%rax
  800415:	00 00 00 
  800418:	ff d0                	call   *%rax
}
  80041a:	c9                   	leave
  80041b:	c3                   	ret

000000000080041c <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  80041c:	f3 0f 1e fa          	endbr64
  800420:	55                   	push   %rbp
  800421:	48 89 e5             	mov    %rsp,%rbp
  800424:	41 57                	push   %r15
  800426:	41 56                	push   %r14
  800428:	41 55                	push   %r13
  80042a:	41 54                	push   %r12
  80042c:	53                   	push   %rbx
  80042d:	48 83 ec 38          	sub    $0x38,%rsp
  800431:	49 89 fe             	mov    %rdi,%r14
  800434:	49 89 f5             	mov    %rsi,%r13
  800437:	48 89 d3             	mov    %rdx,%rbx
    va_copy(aq, ap);
  80043a:	48 8b 01             	mov    (%rcx),%rax
  80043d:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  800441:	48 8b 41 08          	mov    0x8(%rcx),%rax
  800445:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800449:	48 8b 41 10          	mov    0x10(%rcx),%rax
  80044d:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  800451:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  800455:	0f b6 3b             	movzbl (%rbx),%edi
  800458:	40 80 ff 25          	cmp    $0x25,%dil
  80045c:	74 18                	je     800476 <vprintfmt+0x5a>
            if (!ch) return;
  80045e:	40 84 ff             	test   %dil,%dil
  800461:	0f 84 b2 06 00 00    	je     800b19 <vprintfmt+0x6fd>
            putch(ch, put_arg);
  800467:	40 0f b6 ff          	movzbl %dil,%edi
  80046b:	4c 89 ee             	mov    %r13,%rsi
  80046e:	41 ff d6             	call   *%r14
        while ((ch = *ufmt++) != '%') {
  800471:	4c 89 e3             	mov    %r12,%rbx
  800474:	eb db                	jmp    800451 <vprintfmt+0x35>
        bool altflag = 0, zflag = 0;
  800476:	be 00 00 00 00       	mov    $0x0,%esi
  80047b:	c6 45 ab 00          	movb   $0x0,-0x55(%rbp)
        unsigned lflag = 0, base = 10;
  80047f:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  800484:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  80048a:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  800491:	c6 45 aa 20          	movb   $0x20,-0x56(%rbp)
        switch (ch = *ufmt++) {
  800495:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  80049a:	41 0f b6 04 24       	movzbl (%r12),%eax
  80049f:	88 45 a0             	mov    %al,-0x60(%rbp)
  8004a2:	83 e8 23             	sub    $0x23,%eax
  8004a5:	3c 57                	cmp    $0x57,%al
  8004a7:	0f 87 52 06 00 00    	ja     800aff <vprintfmt+0x6e3>
  8004ad:	0f b6 c0             	movzbl %al,%eax
  8004b0:	48 b9 e0 42 80 00 00 	movabs $0x8042e0,%rcx
  8004b7:	00 00 00 
  8004ba:	3e ff 24 c1          	notrack jmp *(%rcx,%rax,8)
  8004be:	49 89 dc             	mov    %rbx,%r12
            altflag = 1;
  8004c1:	c6 45 ab 01          	movb   $0x1,-0x55(%rbp)
  8004c5:	eb ce                	jmp    800495 <vprintfmt+0x79>
        switch (ch = *ufmt++) {
  8004c7:	49 89 dc             	mov    %rbx,%r12
  8004ca:	be 01 00 00 00       	mov    $0x1,%esi
  8004cf:	eb c4                	jmp    800495 <vprintfmt+0x79>
            padc = ch;
  8004d1:	0f b6 45 a0          	movzbl -0x60(%rbp),%eax
  8004d5:	88 45 aa             	mov    %al,-0x56(%rbp)
        switch (ch = *ufmt++) {
  8004d8:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  8004db:	eb b8                	jmp    800495 <vprintfmt+0x79>
            precision = va_arg(aq, int);
  8004dd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8004e0:	83 f8 2f             	cmp    $0x2f,%eax
  8004e3:	77 24                	ja     800509 <vprintfmt+0xed>
  8004e5:	89 c1                	mov    %eax,%ecx
  8004e7:	48 03 4d c8          	add    -0x38(%rbp),%rcx
  8004eb:	83 c0 08             	add    $0x8,%eax
  8004ee:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8004f1:	44 8b 39             	mov    (%rcx),%r15d
        switch (ch = *ufmt++) {
  8004f4:	49 89 dc             	mov    %rbx,%r12
            if (width < 0) {
  8004f7:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8004fb:	79 98                	jns    800495 <vprintfmt+0x79>
                width = precision;
  8004fd:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
                precision = -1;
  800501:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  800507:	eb 8c                	jmp    800495 <vprintfmt+0x79>
            precision = va_arg(aq, int);
  800509:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  80050d:	48 8d 41 08          	lea    0x8(%rcx),%rax
  800511:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800515:	eb da                	jmp    8004f1 <vprintfmt+0xd5>
                precision = precision * 10 + ch - '0';
  800517:	44 0f b6 7d a0       	movzbl -0x60(%rbp),%r15d
  80051c:	41 83 ef 30          	sub    $0x30,%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  800520:	41 0f b6 44 24 01    	movzbl 0x1(%r12),%eax
  800526:	3c 39                	cmp    $0x39,%al
  800528:	77 1c                	ja     800546 <vprintfmt+0x12a>
            for (precision = 0;; ++ufmt) {
  80052a:	48 83 c3 01          	add    $0x1,%rbx
                precision = precision * 10 + ch - '0';
  80052e:	43 8d 0c bf          	lea    (%r15,%r15,4),%ecx
  800532:	0f b6 c0             	movzbl %al,%eax
  800535:	44 8d 7c 48 d0       	lea    -0x30(%rax,%rcx,2),%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  80053a:	0f b6 03             	movzbl (%rbx),%eax
  80053d:	3c 39                	cmp    $0x39,%al
  80053f:	76 e9                	jbe    80052a <vprintfmt+0x10e>
        process_precision:
  800541:	49 89 dc             	mov    %rbx,%r12
  800544:	eb b1                	jmp    8004f7 <vprintfmt+0xdb>
        switch (ch = *ufmt++) {
  800546:	49 89 dc             	mov    %rbx,%r12
  800549:	eb ac                	jmp    8004f7 <vprintfmt+0xdb>
            width = MAX(0, width);
  80054b:	8b 4d ac             	mov    -0x54(%rbp),%ecx
  80054e:	85 c9                	test   %ecx,%ecx
  800550:	b8 00 00 00 00       	mov    $0x0,%eax
  800555:	0f 49 c1             	cmovns %ecx,%eax
  800558:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  80055b:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  80055e:	e9 32 ff ff ff       	jmp    800495 <vprintfmt+0x79>
            lflag++;
  800563:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  800566:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  800569:	e9 27 ff ff ff       	jmp    800495 <vprintfmt+0x79>
            putch(va_arg(aq, int), put_arg);
  80056e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800571:	83 f8 2f             	cmp    $0x2f,%eax
  800574:	77 19                	ja     80058f <vprintfmt+0x173>
  800576:	89 c2                	mov    %eax,%edx
  800578:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80057c:	83 c0 08             	add    $0x8,%eax
  80057f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800582:	8b 3a                	mov    (%rdx),%edi
  800584:	4c 89 ee             	mov    %r13,%rsi
  800587:	41 ff d6             	call   *%r14
            break;
  80058a:	e9 c2 fe ff ff       	jmp    800451 <vprintfmt+0x35>
            putch(va_arg(aq, int), put_arg);
  80058f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800593:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800597:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80059b:	eb e5                	jmp    800582 <vprintfmt+0x166>
            int err = va_arg(aq, int);
  80059d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8005a0:	83 f8 2f             	cmp    $0x2f,%eax
  8005a3:	77 5a                	ja     8005ff <vprintfmt+0x1e3>
  8005a5:	89 c2                	mov    %eax,%edx
  8005a7:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8005ab:	83 c0 08             	add    $0x8,%eax
  8005ae:	89 45 b8             	mov    %eax,-0x48(%rbp)
            if (err < 0) err = -err;
  8005b1:	8b 02                	mov    (%rdx),%eax
  8005b3:	89 c1                	mov    %eax,%ecx
  8005b5:	f7 d9                	neg    %ecx
  8005b7:	0f 48 c8             	cmovs  %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  8005ba:	83 f9 13             	cmp    $0x13,%ecx
  8005bd:	7f 4e                	jg     80060d <vprintfmt+0x1f1>
  8005bf:	48 63 c1             	movslq %ecx,%rax
  8005c2:	48 ba a0 45 80 00 00 	movabs $0x8045a0,%rdx
  8005c9:	00 00 00 
  8005cc:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8005d0:	48 85 c0             	test   %rax,%rax
  8005d3:	74 38                	je     80060d <vprintfmt+0x1f1>
                printfmt(putch, put_arg, "%s", strerr);
  8005d5:	48 89 c1             	mov    %rax,%rcx
  8005d8:	48 ba 4b 42 80 00 00 	movabs $0x80424b,%rdx
  8005df:	00 00 00 
  8005e2:	4c 89 ee             	mov    %r13,%rsi
  8005e5:	4c 89 f7             	mov    %r14,%rdi
  8005e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8005ed:	49 b8 db 03 80 00 00 	movabs $0x8003db,%r8
  8005f4:	00 00 00 
  8005f7:	41 ff d0             	call   *%r8
  8005fa:	e9 52 fe ff ff       	jmp    800451 <vprintfmt+0x35>
            int err = va_arg(aq, int);
  8005ff:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800603:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800607:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80060b:	eb a4                	jmp    8005b1 <vprintfmt+0x195>
                printfmt(putch, put_arg, "error %d", err);
  80060d:	48 ba 49 40 80 00 00 	movabs $0x804049,%rdx
  800614:	00 00 00 
  800617:	4c 89 ee             	mov    %r13,%rsi
  80061a:	4c 89 f7             	mov    %r14,%rdi
  80061d:	b8 00 00 00 00       	mov    $0x0,%eax
  800622:	49 b8 db 03 80 00 00 	movabs $0x8003db,%r8
  800629:	00 00 00 
  80062c:	41 ff d0             	call   *%r8
  80062f:	e9 1d fe ff ff       	jmp    800451 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  800634:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800637:	83 f8 2f             	cmp    $0x2f,%eax
  80063a:	77 6c                	ja     8006a8 <vprintfmt+0x28c>
  80063c:	89 c2                	mov    %eax,%edx
  80063e:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800642:	83 c0 08             	add    $0x8,%eax
  800645:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800648:	48 8b 12             	mov    (%rdx),%rdx
            if (!ptr) ptr = "(null)";
  80064b:	48 85 d2             	test   %rdx,%rdx
  80064e:	48 b8 42 40 80 00 00 	movabs $0x804042,%rax
  800655:	00 00 00 
  800658:	48 0f 45 c2          	cmovne %rdx,%rax
  80065c:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
            if (width > 0 && padc != '-') {
  800660:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800664:	7e 06                	jle    80066c <vprintfmt+0x250>
  800666:	80 7d aa 2d          	cmpb   $0x2d,-0x56(%rbp)
  80066a:	75 4a                	jne    8006b6 <vprintfmt+0x29a>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  80066c:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800670:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800674:	0f b6 00             	movzbl (%rax),%eax
  800677:	84 c0                	test   %al,%al
  800679:	0f 85 9a 00 00 00    	jne    800719 <vprintfmt+0x2fd>
            while (width-- > 0) putch(' ', put_arg);
  80067f:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800682:	44 8d 60 ff          	lea    -0x1(%rax),%r12d
  800686:	85 c0                	test   %eax,%eax
  800688:	0f 8e c3 fd ff ff    	jle    800451 <vprintfmt+0x35>
  80068e:	4c 89 ee             	mov    %r13,%rsi
  800691:	bf 20 00 00 00       	mov    $0x20,%edi
  800696:	41 ff d6             	call   *%r14
  800699:	41 83 ec 01          	sub    $0x1,%r12d
  80069d:	41 83 fc ff          	cmp    $0xffffffff,%r12d
  8006a1:	75 eb                	jne    80068e <vprintfmt+0x272>
  8006a3:	e9 a9 fd ff ff       	jmp    800451 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  8006a8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8006ac:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8006b0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8006b4:	eb 92                	jmp    800648 <vprintfmt+0x22c>
                width -= strnlen(ptr, precision);
  8006b6:	49 63 f7             	movslq %r15d,%rsi
  8006b9:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  8006bd:	48 b8 df 0b 80 00 00 	movabs $0x800bdf,%rax
  8006c4:	00 00 00 
  8006c7:	ff d0                	call   *%rax
  8006c9:	48 89 c2             	mov    %rax,%rdx
  8006cc:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8006cf:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  8006d1:	8d 70 ff             	lea    -0x1(%rax),%esi
  8006d4:	89 75 ac             	mov    %esi,-0x54(%rbp)
  8006d7:	85 c0                	test   %eax,%eax
  8006d9:	7e 91                	jle    80066c <vprintfmt+0x250>
  8006db:	44 0f be 65 aa       	movsbl -0x56(%rbp),%r12d
  8006e0:	4c 89 ee             	mov    %r13,%rsi
  8006e3:	44 89 e7             	mov    %r12d,%edi
  8006e6:	41 ff d6             	call   *%r14
  8006e9:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  8006ed:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8006f0:	83 f8 ff             	cmp    $0xffffffff,%eax
  8006f3:	75 eb                	jne    8006e0 <vprintfmt+0x2c4>
  8006f5:	e9 72 ff ff ff       	jmp    80066c <vprintfmt+0x250>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  8006fa:	0f b6 f8             	movzbl %al,%edi
  8006fd:	4c 89 ee             	mov    %r13,%rsi
  800700:	41 ff d6             	call   *%r14
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800703:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  800707:	49 83 c4 01          	add    $0x1,%r12
  80070b:	41 0f b6 44 24 ff    	movzbl -0x1(%r12),%eax
  800711:	84 c0                	test   %al,%al
  800713:	0f 84 66 ff ff ff    	je     80067f <vprintfmt+0x263>
  800719:	45 85 ff             	test   %r15d,%r15d
  80071c:	78 0a                	js     800728 <vprintfmt+0x30c>
  80071e:	41 83 ef 01          	sub    $0x1,%r15d
  800722:	0f 88 57 ff ff ff    	js     80067f <vprintfmt+0x263>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800728:	80 7d ab 00          	cmpb   $0x0,-0x55(%rbp)
  80072c:	74 cc                	je     8006fa <vprintfmt+0x2de>
  80072e:	8d 50 e0             	lea    -0x20(%rax),%edx
  800731:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800736:	80 fa 5e             	cmp    $0x5e,%dl
  800739:	77 c2                	ja     8006fd <vprintfmt+0x2e1>
  80073b:	eb bd                	jmp    8006fa <vprintfmt+0x2de>
    if (zflag) return va_arg(*ap, size_t);
  80073d:	40 84 f6             	test   %sil,%sil
  800740:	75 26                	jne    800768 <vprintfmt+0x34c>
    switch (lflag) {
  800742:	85 d2                	test   %edx,%edx
  800744:	74 59                	je     80079f <vprintfmt+0x383>
  800746:	83 fa 01             	cmp    $0x1,%edx
  800749:	74 7b                	je     8007c6 <vprintfmt+0x3aa>
        return va_arg(*ap, long long);
  80074b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80074e:	83 f8 2f             	cmp    $0x2f,%eax
  800751:	0f 87 96 00 00 00    	ja     8007ed <vprintfmt+0x3d1>
  800757:	89 c2                	mov    %eax,%edx
  800759:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80075d:	83 c0 08             	add    $0x8,%eax
  800760:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800763:	4c 8b 22             	mov    (%rdx),%r12
  800766:	eb 17                	jmp    80077f <vprintfmt+0x363>
    if (zflag) return va_arg(*ap, size_t);
  800768:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80076b:	83 f8 2f             	cmp    $0x2f,%eax
  80076e:	77 21                	ja     800791 <vprintfmt+0x375>
  800770:	89 c2                	mov    %eax,%edx
  800772:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800776:	83 c0 08             	add    $0x8,%eax
  800779:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80077c:	4c 8b 22             	mov    (%rdx),%r12
            if (i < 0) {
  80077f:	4d 85 e4             	test   %r12,%r12
  800782:	78 7a                	js     8007fe <vprintfmt+0x3e2>
            num = i;
  800784:	4c 89 e2             	mov    %r12,%rdx
        unsigned lflag = 0, base = 10;
  800787:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  80078c:	e9 50 02 00 00       	jmp    8009e1 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800791:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800795:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800799:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80079d:	eb dd                	jmp    80077c <vprintfmt+0x360>
        return va_arg(*ap, int);
  80079f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007a2:	83 f8 2f             	cmp    $0x2f,%eax
  8007a5:	77 11                	ja     8007b8 <vprintfmt+0x39c>
  8007a7:	89 c2                	mov    %eax,%edx
  8007a9:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8007ad:	83 c0 08             	add    $0x8,%eax
  8007b0:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007b3:	4c 63 22             	movslq (%rdx),%r12
  8007b6:	eb c7                	jmp    80077f <vprintfmt+0x363>
  8007b8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007bc:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8007c0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007c4:	eb ed                	jmp    8007b3 <vprintfmt+0x397>
        return va_arg(*ap, long);
  8007c6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007c9:	83 f8 2f             	cmp    $0x2f,%eax
  8007cc:	77 11                	ja     8007df <vprintfmt+0x3c3>
  8007ce:	89 c2                	mov    %eax,%edx
  8007d0:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8007d4:	83 c0 08             	add    $0x8,%eax
  8007d7:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007da:	4c 8b 22             	mov    (%rdx),%r12
  8007dd:	eb a0                	jmp    80077f <vprintfmt+0x363>
  8007df:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007e3:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8007e7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007eb:	eb ed                	jmp    8007da <vprintfmt+0x3be>
        return va_arg(*ap, long long);
  8007ed:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007f1:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8007f5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007f9:	e9 65 ff ff ff       	jmp    800763 <vprintfmt+0x347>
                putch('-', put_arg);
  8007fe:	4c 89 ee             	mov    %r13,%rsi
  800801:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800806:	41 ff d6             	call   *%r14
                i = -i;
  800809:	49 f7 dc             	neg    %r12
  80080c:	e9 73 ff ff ff       	jmp    800784 <vprintfmt+0x368>
    if (zflag) return va_arg(*ap, size_t);
  800811:	40 84 f6             	test   %sil,%sil
  800814:	75 32                	jne    800848 <vprintfmt+0x42c>
    switch (lflag) {
  800816:	85 d2                	test   %edx,%edx
  800818:	74 5d                	je     800877 <vprintfmt+0x45b>
  80081a:	83 fa 01             	cmp    $0x1,%edx
  80081d:	0f 84 82 00 00 00    	je     8008a5 <vprintfmt+0x489>
        return va_arg(*ap, unsigned long long);
  800823:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800826:	83 f8 2f             	cmp    $0x2f,%eax
  800829:	0f 87 a5 00 00 00    	ja     8008d4 <vprintfmt+0x4b8>
  80082f:	89 c2                	mov    %eax,%edx
  800831:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800835:	83 c0 08             	add    $0x8,%eax
  800838:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80083b:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  80083e:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  800843:	e9 99 01 00 00       	jmp    8009e1 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800848:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80084b:	83 f8 2f             	cmp    $0x2f,%eax
  80084e:	77 19                	ja     800869 <vprintfmt+0x44d>
  800850:	89 c2                	mov    %eax,%edx
  800852:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800856:	83 c0 08             	add    $0x8,%eax
  800859:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80085c:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  80085f:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800864:	e9 78 01 00 00       	jmp    8009e1 <vprintfmt+0x5c5>
  800869:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80086d:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800871:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800875:	eb e5                	jmp    80085c <vprintfmt+0x440>
        return va_arg(*ap, unsigned int);
  800877:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80087a:	83 f8 2f             	cmp    $0x2f,%eax
  80087d:	77 18                	ja     800897 <vprintfmt+0x47b>
  80087f:	89 c2                	mov    %eax,%edx
  800881:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800885:	83 c0 08             	add    $0x8,%eax
  800888:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80088b:	8b 12                	mov    (%rdx),%edx
        unsigned lflag = 0, base = 10;
  80088d:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  800892:	e9 4a 01 00 00       	jmp    8009e1 <vprintfmt+0x5c5>
  800897:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80089b:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80089f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008a3:	eb e6                	jmp    80088b <vprintfmt+0x46f>
        return va_arg(*ap, unsigned long);
  8008a5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008a8:	83 f8 2f             	cmp    $0x2f,%eax
  8008ab:	77 19                	ja     8008c6 <vprintfmt+0x4aa>
  8008ad:	89 c2                	mov    %eax,%edx
  8008af:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8008b3:	83 c0 08             	add    $0x8,%eax
  8008b6:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008b9:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  8008bc:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  8008c1:	e9 1b 01 00 00       	jmp    8009e1 <vprintfmt+0x5c5>
  8008c6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008ca:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8008ce:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008d2:	eb e5                	jmp    8008b9 <vprintfmt+0x49d>
        return va_arg(*ap, unsigned long long);
  8008d4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008d8:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8008dc:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008e0:	e9 56 ff ff ff       	jmp    80083b <vprintfmt+0x41f>
    if (zflag) return va_arg(*ap, size_t);
  8008e5:	40 84 f6             	test   %sil,%sil
  8008e8:	75 2e                	jne    800918 <vprintfmt+0x4fc>
    switch (lflag) {
  8008ea:	85 d2                	test   %edx,%edx
  8008ec:	74 59                	je     800947 <vprintfmt+0x52b>
  8008ee:	83 fa 01             	cmp    $0x1,%edx
  8008f1:	74 7f                	je     800972 <vprintfmt+0x556>
        return va_arg(*ap, unsigned long long);
  8008f3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008f6:	83 f8 2f             	cmp    $0x2f,%eax
  8008f9:	0f 87 9f 00 00 00    	ja     80099e <vprintfmt+0x582>
  8008ff:	89 c2                	mov    %eax,%edx
  800901:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800905:	83 c0 08             	add    $0x8,%eax
  800908:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80090b:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  80090e:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  800913:	e9 c9 00 00 00       	jmp    8009e1 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800918:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80091b:	83 f8 2f             	cmp    $0x2f,%eax
  80091e:	77 19                	ja     800939 <vprintfmt+0x51d>
  800920:	89 c2                	mov    %eax,%edx
  800922:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800926:	83 c0 08             	add    $0x8,%eax
  800929:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80092c:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  80092f:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800934:	e9 a8 00 00 00       	jmp    8009e1 <vprintfmt+0x5c5>
  800939:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80093d:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800941:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800945:	eb e5                	jmp    80092c <vprintfmt+0x510>
        return va_arg(*ap, unsigned int);
  800947:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80094a:	83 f8 2f             	cmp    $0x2f,%eax
  80094d:	77 15                	ja     800964 <vprintfmt+0x548>
  80094f:	89 c2                	mov    %eax,%edx
  800951:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800955:	83 c0 08             	add    $0x8,%eax
  800958:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80095b:	8b 12                	mov    (%rdx),%edx
            base = 8;
  80095d:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  800962:	eb 7d                	jmp    8009e1 <vprintfmt+0x5c5>
  800964:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800968:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80096c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800970:	eb e9                	jmp    80095b <vprintfmt+0x53f>
        return va_arg(*ap, unsigned long);
  800972:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800975:	83 f8 2f             	cmp    $0x2f,%eax
  800978:	77 16                	ja     800990 <vprintfmt+0x574>
  80097a:	89 c2                	mov    %eax,%edx
  80097c:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800980:	83 c0 08             	add    $0x8,%eax
  800983:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800986:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800989:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  80098e:	eb 51                	jmp    8009e1 <vprintfmt+0x5c5>
  800990:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800994:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800998:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80099c:	eb e8                	jmp    800986 <vprintfmt+0x56a>
        return va_arg(*ap, unsigned long long);
  80099e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009a2:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009a6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009aa:	e9 5c ff ff ff       	jmp    80090b <vprintfmt+0x4ef>
            putch('0', put_arg);
  8009af:	4c 89 ee             	mov    %r13,%rsi
  8009b2:	bf 30 00 00 00       	mov    $0x30,%edi
  8009b7:	41 ff d6             	call   *%r14
            putch('x', put_arg);
  8009ba:	4c 89 ee             	mov    %r13,%rsi
  8009bd:	bf 78 00 00 00       	mov    $0x78,%edi
  8009c2:	41 ff d6             	call   *%r14
            num = (uintptr_t)va_arg(aq, void *);
  8009c5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009c8:	83 f8 2f             	cmp    $0x2f,%eax
  8009cb:	77 47                	ja     800a14 <vprintfmt+0x5f8>
  8009cd:	89 c2                	mov    %eax,%edx
  8009cf:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8009d3:	83 c0 08             	add    $0x8,%eax
  8009d6:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009d9:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  8009dc:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  8009e1:	48 83 ec 08          	sub    $0x8,%rsp
  8009e5:	80 7d a0 58          	cmpb   $0x58,-0x60(%rbp)
  8009e9:	0f 94 c0             	sete   %al
  8009ec:	0f b6 c0             	movzbl %al,%eax
  8009ef:	50                   	push   %rax
  8009f0:	44 0f be 4d aa       	movsbl -0x56(%rbp),%r9d
  8009f5:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  8009f9:	4c 89 ee             	mov    %r13,%rsi
  8009fc:	4c 89 f7             	mov    %r14,%rdi
  8009ff:	48 b8 05 03 80 00 00 	movabs $0x800305,%rax
  800a06:	00 00 00 
  800a09:	ff d0                	call   *%rax
            break;
  800a0b:	48 83 c4 10          	add    $0x10,%rsp
  800a0f:	e9 3d fa ff ff       	jmp    800451 <vprintfmt+0x35>
            num = (uintptr_t)va_arg(aq, void *);
  800a14:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a18:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a1c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a20:	eb b7                	jmp    8009d9 <vprintfmt+0x5bd>
    if (zflag) return va_arg(*ap, size_t);
  800a22:	40 84 f6             	test   %sil,%sil
  800a25:	75 2b                	jne    800a52 <vprintfmt+0x636>
    switch (lflag) {
  800a27:	85 d2                	test   %edx,%edx
  800a29:	74 56                	je     800a81 <vprintfmt+0x665>
  800a2b:	83 fa 01             	cmp    $0x1,%edx
  800a2e:	74 7f                	je     800aaf <vprintfmt+0x693>
        return va_arg(*ap, unsigned long long);
  800a30:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a33:	83 f8 2f             	cmp    $0x2f,%eax
  800a36:	0f 87 a2 00 00 00    	ja     800ade <vprintfmt+0x6c2>
  800a3c:	89 c2                	mov    %eax,%edx
  800a3e:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a42:	83 c0 08             	add    $0x8,%eax
  800a45:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a48:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800a4b:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800a50:	eb 8f                	jmp    8009e1 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800a52:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a55:	83 f8 2f             	cmp    $0x2f,%eax
  800a58:	77 19                	ja     800a73 <vprintfmt+0x657>
  800a5a:	89 c2                	mov    %eax,%edx
  800a5c:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a60:	83 c0 08             	add    $0x8,%eax
  800a63:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a66:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800a69:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800a6e:	e9 6e ff ff ff       	jmp    8009e1 <vprintfmt+0x5c5>
  800a73:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a77:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a7b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a7f:	eb e5                	jmp    800a66 <vprintfmt+0x64a>
        return va_arg(*ap, unsigned int);
  800a81:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a84:	83 f8 2f             	cmp    $0x2f,%eax
  800a87:	77 18                	ja     800aa1 <vprintfmt+0x685>
  800a89:	89 c2                	mov    %eax,%edx
  800a8b:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a8f:	83 c0 08             	add    $0x8,%eax
  800a92:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a95:	8b 12                	mov    (%rdx),%edx
            base = 16;
  800a97:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  800a9c:	e9 40 ff ff ff       	jmp    8009e1 <vprintfmt+0x5c5>
  800aa1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800aa5:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800aa9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800aad:	eb e6                	jmp    800a95 <vprintfmt+0x679>
        return va_arg(*ap, unsigned long);
  800aaf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ab2:	83 f8 2f             	cmp    $0x2f,%eax
  800ab5:	77 19                	ja     800ad0 <vprintfmt+0x6b4>
  800ab7:	89 c2                	mov    %eax,%edx
  800ab9:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800abd:	83 c0 08             	add    $0x8,%eax
  800ac0:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ac3:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800ac6:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800acb:	e9 11 ff ff ff       	jmp    8009e1 <vprintfmt+0x5c5>
  800ad0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ad4:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800ad8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800adc:	eb e5                	jmp    800ac3 <vprintfmt+0x6a7>
        return va_arg(*ap, unsigned long long);
  800ade:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ae2:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800ae6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800aea:	e9 59 ff ff ff       	jmp    800a48 <vprintfmt+0x62c>
            putch(ch, put_arg);
  800aef:	4c 89 ee             	mov    %r13,%rsi
  800af2:	bf 25 00 00 00       	mov    $0x25,%edi
  800af7:	41 ff d6             	call   *%r14
            break;
  800afa:	e9 52 f9 ff ff       	jmp    800451 <vprintfmt+0x35>
            putch('%', put_arg);
  800aff:	4c 89 ee             	mov    %r13,%rsi
  800b02:	bf 25 00 00 00       	mov    $0x25,%edi
  800b07:	41 ff d6             	call   *%r14
            while ((--ufmt)[-1] != '%') /* nothing */
  800b0a:	48 83 eb 01          	sub    $0x1,%rbx
  800b0e:	80 7b ff 25          	cmpb   $0x25,-0x1(%rbx)
  800b12:	75 f6                	jne    800b0a <vprintfmt+0x6ee>
  800b14:	e9 38 f9 ff ff       	jmp    800451 <vprintfmt+0x35>
}
  800b19:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800b1d:	5b                   	pop    %rbx
  800b1e:	41 5c                	pop    %r12
  800b20:	41 5d                	pop    %r13
  800b22:	41 5e                	pop    %r14
  800b24:	41 5f                	pop    %r15
  800b26:	5d                   	pop    %rbp
  800b27:	c3                   	ret

0000000000800b28 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800b28:	f3 0f 1e fa          	endbr64
  800b2c:	55                   	push   %rbp
  800b2d:	48 89 e5             	mov    %rsp,%rbp
  800b30:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800b34:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800b38:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800b3d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800b41:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800b48:	48 85 ff             	test   %rdi,%rdi
  800b4b:	74 2b                	je     800b78 <vsnprintf+0x50>
  800b4d:	48 85 f6             	test   %rsi,%rsi
  800b50:	74 26                	je     800b78 <vsnprintf+0x50>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800b52:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800b56:	48 bf bf 03 80 00 00 	movabs $0x8003bf,%rdi
  800b5d:	00 00 00 
  800b60:	48 b8 1c 04 80 00 00 	movabs $0x80041c,%rax
  800b67:	00 00 00 
  800b6a:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800b6c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b70:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800b73:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800b76:	c9                   	leave
  800b77:	c3                   	ret
    if (!buf || n < 1) return -E_INVAL;
  800b78:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b7d:	eb f7                	jmp    800b76 <vsnprintf+0x4e>

0000000000800b7f <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800b7f:	f3 0f 1e fa          	endbr64
  800b83:	55                   	push   %rbp
  800b84:	48 89 e5             	mov    %rsp,%rbp
  800b87:	48 83 ec 50          	sub    $0x50,%rsp
  800b8b:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800b8f:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800b93:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800b97:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800b9e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800ba2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ba6:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800baa:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800bae:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800bb2:	48 b8 28 0b 80 00 00 	movabs $0x800b28,%rax
  800bb9:	00 00 00 
  800bbc:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800bbe:	c9                   	leave
  800bbf:	c3                   	ret

0000000000800bc0 <strlen>:
 * Primespipe runs 3x faster this way */

#define ASM 1

size_t
strlen(const char *s) {
  800bc0:	f3 0f 1e fa          	endbr64
    size_t n = 0;
    while (*s++) n++;
  800bc4:	80 3f 00             	cmpb   $0x0,(%rdi)
  800bc7:	74 10                	je     800bd9 <strlen+0x19>
    size_t n = 0;
  800bc9:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800bce:	48 83 c0 01          	add    $0x1,%rax
  800bd2:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800bd6:	75 f6                	jne    800bce <strlen+0xe>
  800bd8:	c3                   	ret
    size_t n = 0;
  800bd9:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800bde:	c3                   	ret

0000000000800bdf <strnlen>:

size_t
strnlen(const char *s, size_t size) {
  800bdf:	f3 0f 1e fa          	endbr64
  800be3:	48 89 f0             	mov    %rsi,%rax
    size_t n = 0;
  800be6:	ba 00 00 00 00       	mov    $0x0,%edx
    while (n < size && *s++) n++;
  800beb:	48 85 f6             	test   %rsi,%rsi
  800bee:	74 10                	je     800c00 <strnlen+0x21>
  800bf0:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  800bf4:	74 0b                	je     800c01 <strnlen+0x22>
  800bf6:	48 83 c2 01          	add    $0x1,%rdx
  800bfa:	48 39 d0             	cmp    %rdx,%rax
  800bfd:	75 f1                	jne    800bf0 <strnlen+0x11>
  800bff:	c3                   	ret
  800c00:	c3                   	ret
  800c01:	48 89 d0             	mov    %rdx,%rax
    return n;
}
  800c04:	c3                   	ret

0000000000800c05 <strcpy>:

char *
strcpy(char *dst, const char *src) {
  800c05:	f3 0f 1e fa          	endbr64
  800c09:	48 89 f8             	mov    %rdi,%rax
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800c0c:	ba 00 00 00 00       	mov    $0x0,%edx
  800c11:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  800c15:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  800c18:	48 83 c2 01          	add    $0x1,%rdx
  800c1c:	84 c9                	test   %cl,%cl
  800c1e:	75 f1                	jne    800c11 <strcpy+0xc>
        ;
    return res;
}
  800c20:	c3                   	ret

0000000000800c21 <strcat>:

char *
strcat(char *dst, const char *src) {
  800c21:	f3 0f 1e fa          	endbr64
  800c25:	55                   	push   %rbp
  800c26:	48 89 e5             	mov    %rsp,%rbp
  800c29:	41 54                	push   %r12
  800c2b:	53                   	push   %rbx
  800c2c:	48 89 fb             	mov    %rdi,%rbx
  800c2f:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800c32:	48 b8 c0 0b 80 00 00 	movabs $0x800bc0,%rax
  800c39:	00 00 00 
  800c3c:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800c3e:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800c42:	4c 89 e6             	mov    %r12,%rsi
  800c45:	48 b8 05 0c 80 00 00 	movabs $0x800c05,%rax
  800c4c:	00 00 00 
  800c4f:	ff d0                	call   *%rax
    return dst;
}
  800c51:	48 89 d8             	mov    %rbx,%rax
  800c54:	5b                   	pop    %rbx
  800c55:	41 5c                	pop    %r12
  800c57:	5d                   	pop    %rbp
  800c58:	c3                   	ret

0000000000800c59 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800c59:	f3 0f 1e fa          	endbr64
  800c5d:	48 89 f8             	mov    %rdi,%rax
    char *ret = dst;
    while (size-- > 0) {
  800c60:	48 85 d2             	test   %rdx,%rdx
  800c63:	74 1f                	je     800c84 <strncpy+0x2b>
  800c65:	48 01 fa             	add    %rdi,%rdx
  800c68:	48 89 f9             	mov    %rdi,%rcx
        *dst++ = *src;
  800c6b:	48 83 c1 01          	add    $0x1,%rcx
  800c6f:	44 0f b6 06          	movzbl (%rsi),%r8d
  800c73:	44 88 41 ff          	mov    %r8b,-0x1(%rcx)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800c77:	41 80 f8 01          	cmp    $0x1,%r8b
  800c7b:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800c7f:	48 39 ca             	cmp    %rcx,%rdx
  800c82:	75 e7                	jne    800c6b <strncpy+0x12>
    }
    return ret;
}
  800c84:	c3                   	ret

0000000000800c85 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
  800c85:	f3 0f 1e fa          	endbr64
    char *dst_in = dst;
    if (size) {
  800c89:	48 89 f8             	mov    %rdi,%rax
  800c8c:	48 85 d2             	test   %rdx,%rdx
  800c8f:	74 24                	je     800cb5 <strlcpy+0x30>
        while (--size > 0 && *src)
  800c91:	48 83 ea 01          	sub    $0x1,%rdx
  800c95:	74 1b                	je     800cb2 <strlcpy+0x2d>
  800c97:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800c9b:	0f b6 16             	movzbl (%rsi),%edx
  800c9e:	84 d2                	test   %dl,%dl
  800ca0:	74 10                	je     800cb2 <strlcpy+0x2d>
            *dst++ = *src++;
  800ca2:	48 83 c6 01          	add    $0x1,%rsi
  800ca6:	48 83 c0 01          	add    $0x1,%rax
  800caa:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800cad:	48 39 c8             	cmp    %rcx,%rax
  800cb0:	75 e9                	jne    800c9b <strlcpy+0x16>
        *dst = '\0';
  800cb2:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800cb5:	48 29 f8             	sub    %rdi,%rax
}
  800cb8:	c3                   	ret

0000000000800cb9 <strcmp>:
    }
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
  800cb9:	f3 0f 1e fa          	endbr64
    while (*p && *p == *q) p++, q++;
  800cbd:	0f b6 07             	movzbl (%rdi),%eax
  800cc0:	84 c0                	test   %al,%al
  800cc2:	74 13                	je     800cd7 <strcmp+0x1e>
  800cc4:	38 06                	cmp    %al,(%rsi)
  800cc6:	75 0f                	jne    800cd7 <strcmp+0x1e>
  800cc8:	48 83 c7 01          	add    $0x1,%rdi
  800ccc:	48 83 c6 01          	add    $0x1,%rsi
  800cd0:	0f b6 07             	movzbl (%rdi),%eax
  800cd3:	84 c0                	test   %al,%al
  800cd5:	75 ed                	jne    800cc4 <strcmp+0xb>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800cd7:	0f b6 c0             	movzbl %al,%eax
  800cda:	0f b6 16             	movzbl (%rsi),%edx
  800cdd:	29 d0                	sub    %edx,%eax
}
  800cdf:	c3                   	ret

0000000000800ce0 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
  800ce0:	f3 0f 1e fa          	endbr64
    while (n && *p && *p == *q) n--, p++, q++;
  800ce4:	48 85 d2             	test   %rdx,%rdx
  800ce7:	74 1f                	je     800d08 <strncmp+0x28>
  800ce9:	0f b6 07             	movzbl (%rdi),%eax
  800cec:	84 c0                	test   %al,%al
  800cee:	74 1e                	je     800d0e <strncmp+0x2e>
  800cf0:	3a 06                	cmp    (%rsi),%al
  800cf2:	75 1a                	jne    800d0e <strncmp+0x2e>
  800cf4:	48 83 c7 01          	add    $0x1,%rdi
  800cf8:	48 83 c6 01          	add    $0x1,%rsi
  800cfc:	48 83 ea 01          	sub    $0x1,%rdx
  800d00:	75 e7                	jne    800ce9 <strncmp+0x9>

    if (!n) return 0;
  800d02:	b8 00 00 00 00       	mov    $0x0,%eax
  800d07:	c3                   	ret
  800d08:	b8 00 00 00 00       	mov    $0x0,%eax
  800d0d:	c3                   	ret

    return (int)((unsigned char)*p - (unsigned char)*q);
  800d0e:	0f b6 07             	movzbl (%rdi),%eax
  800d11:	0f b6 16             	movzbl (%rsi),%edx
  800d14:	29 d0                	sub    %edx,%eax
}
  800d16:	c3                   	ret

0000000000800d17 <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
  800d17:	f3 0f 1e fa          	endbr64
    for (; *str; str++) {
  800d1b:	0f b6 17             	movzbl (%rdi),%edx
  800d1e:	84 d2                	test   %dl,%dl
  800d20:	74 18                	je     800d3a <strchr+0x23>
        if (*str == c) {
  800d22:	0f be d2             	movsbl %dl,%edx
  800d25:	39 f2                	cmp    %esi,%edx
  800d27:	74 17                	je     800d40 <strchr+0x29>
    for (; *str; str++) {
  800d29:	48 83 c7 01          	add    $0x1,%rdi
  800d2d:	0f b6 17             	movzbl (%rdi),%edx
  800d30:	84 d2                	test   %dl,%dl
  800d32:	75 ee                	jne    800d22 <strchr+0xb>
            return (char *)str;
        }
    }
    return NULL;
  800d34:	b8 00 00 00 00       	mov    $0x0,%eax
  800d39:	c3                   	ret
  800d3a:	b8 00 00 00 00       	mov    $0x0,%eax
  800d3f:	c3                   	ret
            return (char *)str;
  800d40:	48 89 f8             	mov    %rdi,%rax
}
  800d43:	c3                   	ret

0000000000800d44 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
  800d44:	f3 0f 1e fa          	endbr64
  800d48:	48 89 f8             	mov    %rdi,%rax
    for (; *str && *str != ch; str++) /* nothing */
  800d4b:	0f b6 17             	movzbl (%rdi),%edx
  800d4e:	84 d2                	test   %dl,%dl
  800d50:	74 13                	je     800d65 <strfind+0x21>
  800d52:	0f be d2             	movsbl %dl,%edx
  800d55:	39 f2                	cmp    %esi,%edx
  800d57:	74 0b                	je     800d64 <strfind+0x20>
  800d59:	48 83 c0 01          	add    $0x1,%rax
  800d5d:	0f b6 10             	movzbl (%rax),%edx
  800d60:	84 d2                	test   %dl,%dl
  800d62:	75 ee                	jne    800d52 <strfind+0xe>
        ;
    return (char *)str;
}
  800d64:	c3                   	ret
  800d65:	c3                   	ret

0000000000800d66 <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  800d66:	f3 0f 1e fa          	endbr64
  800d6a:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  800d6d:	48 89 f8             	mov    %rdi,%rax
  800d70:	48 f7 d8             	neg    %rax
  800d73:	83 e0 07             	and    $0x7,%eax
  800d76:	49 89 d1             	mov    %rdx,%r9
  800d79:	49 29 c1             	sub    %rax,%r9
  800d7c:	78 36                	js     800db4 <memset+0x4e>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  800d7e:	40 0f b6 c6          	movzbl %sil,%eax
  800d82:	48 b9 01 01 01 01 01 	movabs $0x101010101010101,%rcx
  800d89:	01 01 01 
  800d8c:	48 0f af c1          	imul   %rcx,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  800d90:	40 f6 c7 07          	test   $0x7,%dil
  800d94:	75 38                	jne    800dce <memset+0x68>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  800d96:	4c 89 c9             	mov    %r9,%rcx
  800d99:	48 c1 f9 03          	sar    $0x3,%rcx
  800d9d:	74 0c                	je     800dab <memset+0x45>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  800d9f:	fc                   	cld
  800da0:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  800da3:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  800da7:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  800dab:	4d 85 c9             	test   %r9,%r9
  800dae:	75 45                	jne    800df5 <memset+0x8f>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  800db0:	4c 89 c0             	mov    %r8,%rax
  800db3:	c3                   	ret
        while (n-- > 0) *ptr++ = c;
  800db4:	48 85 d2             	test   %rdx,%rdx
  800db7:	74 f7                	je     800db0 <memset+0x4a>
  800db9:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  800dbc:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  800dbf:	48 83 c0 01          	add    $0x1,%rax
  800dc3:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  800dc7:	48 39 c2             	cmp    %rax,%rdx
  800dca:	75 f3                	jne    800dbf <memset+0x59>
  800dcc:	eb e2                	jmp    800db0 <memset+0x4a>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  800dce:	40 f6 c7 01          	test   $0x1,%dil
  800dd2:	74 06                	je     800dda <memset+0x74>
  800dd4:	88 07                	mov    %al,(%rdi)
  800dd6:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  800dda:	40 f6 c7 02          	test   $0x2,%dil
  800dde:	74 07                	je     800de7 <memset+0x81>
  800de0:	66 89 07             	mov    %ax,(%rdi)
  800de3:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  800de7:	40 f6 c7 04          	test   $0x4,%dil
  800deb:	74 a9                	je     800d96 <memset+0x30>
  800ded:	89 07                	mov    %eax,(%rdi)
  800def:	48 83 c7 04          	add    $0x4,%rdi
  800df3:	eb a1                	jmp    800d96 <memset+0x30>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  800df5:	41 f6 c1 04          	test   $0x4,%r9b
  800df9:	74 1b                	je     800e16 <memset+0xb0>
  800dfb:	89 07                	mov    %eax,(%rdi)
  800dfd:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800e01:	41 f6 c1 02          	test   $0x2,%r9b
  800e05:	74 07                	je     800e0e <memset+0xa8>
  800e07:	66 89 07             	mov    %ax,(%rdi)
  800e0a:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  800e0e:	41 f6 c1 01          	test   $0x1,%r9b
  800e12:	74 9c                	je     800db0 <memset+0x4a>
  800e14:	eb 06                	jmp    800e1c <memset+0xb6>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800e16:	41 f6 c1 02          	test   $0x2,%r9b
  800e1a:	75 eb                	jne    800e07 <memset+0xa1>
        if (ni & 1) *ptr = k;
  800e1c:	88 07                	mov    %al,(%rdi)
  800e1e:	eb 90                	jmp    800db0 <memset+0x4a>

0000000000800e20 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  800e20:	f3 0f 1e fa          	endbr64
  800e24:	48 89 f8             	mov    %rdi,%rax
  800e27:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  800e2a:	48 39 fe             	cmp    %rdi,%rsi
  800e2d:	73 3b                	jae    800e6a <memmove+0x4a>
  800e2f:	48 8d 14 16          	lea    (%rsi,%rdx,1),%rdx
  800e33:	48 39 d7             	cmp    %rdx,%rdi
  800e36:	73 32                	jae    800e6a <memmove+0x4a>
        s += n;
        d += n;
  800e38:	48 8d 3c 0f          	lea    (%rdi,%rcx,1),%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800e3c:	48 89 d6             	mov    %rdx,%rsi
  800e3f:	48 09 fe             	or     %rdi,%rsi
  800e42:	48 09 ce             	or     %rcx,%rsi
  800e45:	40 f6 c6 07          	test   $0x7,%sil
  800e49:	75 12                	jne    800e5d <memmove+0x3d>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  800e4b:	48 83 ef 08          	sub    $0x8,%rdi
  800e4f:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  800e53:	48 c1 e9 03          	shr    $0x3,%rcx
  800e57:	fd                   	std
  800e58:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  800e5b:	fc                   	cld
  800e5c:	c3                   	ret
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  800e5d:	48 83 ef 01          	sub    $0x1,%rdi
  800e61:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  800e65:	fd                   	std
  800e66:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  800e68:	eb f1                	jmp    800e5b <memmove+0x3b>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800e6a:	48 89 f2             	mov    %rsi,%rdx
  800e6d:	48 09 c2             	or     %rax,%rdx
  800e70:	48 09 ca             	or     %rcx,%rdx
  800e73:	f6 c2 07             	test   $0x7,%dl
  800e76:	75 0c                	jne    800e84 <memmove+0x64>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  800e78:	48 c1 e9 03          	shr    $0x3,%rcx
  800e7c:	48 89 c7             	mov    %rax,%rdi
  800e7f:	fc                   	cld
  800e80:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  800e83:	c3                   	ret
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  800e84:	48 89 c7             	mov    %rax,%rdi
  800e87:	fc                   	cld
  800e88:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  800e8a:	c3                   	ret

0000000000800e8b <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  800e8b:	f3 0f 1e fa          	endbr64
  800e8f:	55                   	push   %rbp
  800e90:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  800e93:	48 b8 20 0e 80 00 00 	movabs $0x800e20,%rax
  800e9a:	00 00 00 
  800e9d:	ff d0                	call   *%rax
}
  800e9f:	5d                   	pop    %rbp
  800ea0:	c3                   	ret

0000000000800ea1 <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  800ea1:	f3 0f 1e fa          	endbr64
  800ea5:	55                   	push   %rbp
  800ea6:	48 89 e5             	mov    %rsp,%rbp
  800ea9:	41 57                	push   %r15
  800eab:	41 56                	push   %r14
  800ead:	41 55                	push   %r13
  800eaf:	41 54                	push   %r12
  800eb1:	53                   	push   %rbx
  800eb2:	48 83 ec 08          	sub    $0x8,%rsp
  800eb6:	49 89 fe             	mov    %rdi,%r14
  800eb9:	49 89 f7             	mov    %rsi,%r15
  800ebc:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  800ebf:	48 89 f7             	mov    %rsi,%rdi
  800ec2:	48 b8 c0 0b 80 00 00 	movabs $0x800bc0,%rax
  800ec9:	00 00 00 
  800ecc:	ff d0                	call   *%rax
  800ece:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  800ed1:	48 89 de             	mov    %rbx,%rsi
  800ed4:	4c 89 f7             	mov    %r14,%rdi
  800ed7:	48 b8 df 0b 80 00 00 	movabs $0x800bdf,%rax
  800ede:	00 00 00 
  800ee1:	ff d0                	call   *%rax
  800ee3:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  800ee6:	48 39 c3             	cmp    %rax,%rbx
  800ee9:	74 36                	je     800f21 <strlcat+0x80>
    if (srclen < maxlen - dstlen) {
  800eeb:	48 89 d8             	mov    %rbx,%rax
  800eee:	4c 29 e8             	sub    %r13,%rax
  800ef1:	49 39 c4             	cmp    %rax,%r12
  800ef4:	73 31                	jae    800f27 <strlcat+0x86>
        memcpy(dst + dstlen, src, srclen + 1);
  800ef6:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  800efb:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800eff:	4c 89 fe             	mov    %r15,%rsi
  800f02:	48 b8 8b 0e 80 00 00 	movabs $0x800e8b,%rax
  800f09:	00 00 00 
  800f0c:	ff d0                	call   *%rax
    return dstlen + srclen;
  800f0e:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  800f12:	48 83 c4 08          	add    $0x8,%rsp
  800f16:	5b                   	pop    %rbx
  800f17:	41 5c                	pop    %r12
  800f19:	41 5d                	pop    %r13
  800f1b:	41 5e                	pop    %r14
  800f1d:	41 5f                	pop    %r15
  800f1f:	5d                   	pop    %rbp
  800f20:	c3                   	ret
    if (dstlen == maxlen) return maxlen + srclen;
  800f21:	49 8d 04 04          	lea    (%r12,%rax,1),%rax
  800f25:	eb eb                	jmp    800f12 <strlcat+0x71>
        memcpy(dst + dstlen, src, maxlen - 1);
  800f27:	48 83 eb 01          	sub    $0x1,%rbx
  800f2b:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800f2f:	48 89 da             	mov    %rbx,%rdx
  800f32:	4c 89 fe             	mov    %r15,%rsi
  800f35:	48 b8 8b 0e 80 00 00 	movabs $0x800e8b,%rax
  800f3c:	00 00 00 
  800f3f:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  800f41:	49 01 de             	add    %rbx,%r14
  800f44:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  800f49:	eb c3                	jmp    800f0e <strlcat+0x6d>

0000000000800f4b <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  800f4b:	f3 0f 1e fa          	endbr64
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  800f4f:	48 85 d2             	test   %rdx,%rdx
  800f52:	74 2d                	je     800f81 <memcmp+0x36>
  800f54:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  800f59:	0f b6 0c 07          	movzbl (%rdi,%rax,1),%ecx
  800f5d:	44 0f b6 04 06       	movzbl (%rsi,%rax,1),%r8d
  800f62:	44 38 c1             	cmp    %r8b,%cl
  800f65:	75 0f                	jne    800f76 <memcmp+0x2b>
    while (n-- > 0) {
  800f67:	48 83 c0 01          	add    $0x1,%rax
  800f6b:	48 39 c2             	cmp    %rax,%rdx
  800f6e:	75 e9                	jne    800f59 <memcmp+0xe>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  800f70:	b8 00 00 00 00       	mov    $0x0,%eax
  800f75:	c3                   	ret
            return (int)*s1 - (int)*s2;
  800f76:	0f b6 c1             	movzbl %cl,%eax
  800f79:	45 0f b6 c0          	movzbl %r8b,%r8d
  800f7d:	44 29 c0             	sub    %r8d,%eax
  800f80:	c3                   	ret
    return 0;
  800f81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f86:	c3                   	ret

0000000000800f87 <memfind>:

void *
memfind(const void *src, int c, size_t n) {
  800f87:	f3 0f 1e fa          	endbr64
    const void *end = (const char *)src + n;
  800f8b:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  800f8f:	48 39 c7             	cmp    %rax,%rdi
  800f92:	73 0f                	jae    800fa3 <memfind+0x1c>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  800f94:	40 38 37             	cmp    %sil,(%rdi)
  800f97:	74 0e                	je     800fa7 <memfind+0x20>
    for (; src < end; src++) {
  800f99:	48 83 c7 01          	add    $0x1,%rdi
  800f9d:	48 39 f8             	cmp    %rdi,%rax
  800fa0:	75 f2                	jne    800f94 <memfind+0xd>
  800fa2:	c3                   	ret
  800fa3:	48 89 f8             	mov    %rdi,%rax
  800fa6:	c3                   	ret
  800fa7:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  800faa:	c3                   	ret

0000000000800fab <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  800fab:	f3 0f 1e fa          	endbr64
  800faf:	49 89 f2             	mov    %rsi,%r10
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  800fb2:	0f b6 37             	movzbl (%rdi),%esi
  800fb5:	40 80 fe 20          	cmp    $0x20,%sil
  800fb9:	74 06                	je     800fc1 <strtol+0x16>
  800fbb:	40 80 fe 09          	cmp    $0x9,%sil
  800fbf:	75 13                	jne    800fd4 <strtol+0x29>
  800fc1:	48 83 c7 01          	add    $0x1,%rdi
  800fc5:	0f b6 37             	movzbl (%rdi),%esi
  800fc8:	40 80 fe 20          	cmp    $0x20,%sil
  800fcc:	74 f3                	je     800fc1 <strtol+0x16>
  800fce:	40 80 fe 09          	cmp    $0x9,%sil
  800fd2:	74 ed                	je     800fc1 <strtol+0x16>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  800fd4:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  800fd7:	83 e0 fd             	and    $0xfffffffd,%eax
  800fda:	3c 01                	cmp    $0x1,%al
  800fdc:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  800fe0:	f7 c2 ef ff ff ff    	test   $0xffffffef,%edx
  800fe6:	75 0f                	jne    800ff7 <strtol+0x4c>
  800fe8:	80 3f 30             	cmpb   $0x30,(%rdi)
  800feb:	74 14                	je     801001 <strtol+0x56>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  800fed:	85 d2                	test   %edx,%edx
  800fef:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ff4:	0f 44 d0             	cmove  %eax,%edx
    }

    /* Digits */
    long val = 0;
  800ff7:	b8 00 00 00 00       	mov    $0x0,%eax
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  800ffc:	4c 63 ca             	movslq %edx,%r9
  800fff:	eb 36                	jmp    801037 <strtol+0x8c>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  801001:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  801005:	74 0f                	je     801016 <strtol+0x6b>
    } else if (!base && s[0] == '0') {
  801007:	85 d2                	test   %edx,%edx
  801009:	75 ec                	jne    800ff7 <strtol+0x4c>
        s++;
  80100b:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  80100f:	ba 08 00 00 00       	mov    $0x8,%edx
        s++;
  801014:	eb e1                	jmp    800ff7 <strtol+0x4c>
        s += 2;
  801016:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  80101a:	ba 10 00 00 00       	mov    $0x10,%edx
        s += 2;
  80101f:	eb d6                	jmp    800ff7 <strtol+0x4c>
            dig -= '0';
  801021:	83 e9 30             	sub    $0x30,%ecx
        if (dig >= base) break;
  801024:	44 0f b6 c1          	movzbl %cl,%r8d
  801028:	41 39 d0             	cmp    %edx,%r8d
  80102b:	7d 21                	jge    80104e <strtol+0xa3>
        val = val * base + dig;
  80102d:	49 0f af c1          	imul   %r9,%rax
  801031:	0f b6 c9             	movzbl %cl,%ecx
  801034:	48 01 c8             	add    %rcx,%rax
        uint8_t dig = *s++;
  801037:	48 83 c7 01          	add    $0x1,%rdi
  80103b:	0f b6 4f ff          	movzbl -0x1(%rdi),%ecx
        if (dig - '0' < 10)
  80103f:	80 f9 39             	cmp    $0x39,%cl
  801042:	76 dd                	jbe    801021 <strtol+0x76>
        else if (dig - 'a' < 27)
  801044:	80 f9 7b             	cmp    $0x7b,%cl
  801047:	77 05                	ja     80104e <strtol+0xa3>
            dig -= 'a' - 10;
  801049:	83 e9 57             	sub    $0x57,%ecx
  80104c:	eb d6                	jmp    801024 <strtol+0x79>
    }

    if (endptr) *endptr = (char *)s;
  80104e:	4d 85 d2             	test   %r10,%r10
  801051:	74 03                	je     801056 <strtol+0xab>
  801053:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  801056:	48 89 c2             	mov    %rax,%rdx
  801059:	48 f7 da             	neg    %rdx
  80105c:	40 80 fe 2d          	cmp    $0x2d,%sil
  801060:	48 0f 44 c2          	cmove  %rdx,%rax
}
  801064:	c3                   	ret

0000000000801065 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  801065:	f3 0f 1e fa          	endbr64
  801069:	55                   	push   %rbp
  80106a:	48 89 e5             	mov    %rsp,%rbp
  80106d:	53                   	push   %rbx
  80106e:	48 89 fa             	mov    %rdi,%rdx
  801071:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801074:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801079:	bb 00 00 00 00       	mov    $0x0,%ebx
  80107e:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801083:	be 00 00 00 00       	mov    $0x0,%esi
  801088:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80108e:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  801090:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801094:	c9                   	leave
  801095:	c3                   	ret

0000000000801096 <sys_cgetc>:

int
sys_cgetc(void) {
  801096:	f3 0f 1e fa          	endbr64
  80109a:	55                   	push   %rbp
  80109b:	48 89 e5             	mov    %rsp,%rbp
  80109e:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80109f:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8010a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8010a9:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8010ae:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010b3:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8010b8:	be 00 00 00 00       	mov    $0x0,%esi
  8010bd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8010c3:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  8010c5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8010c9:	c9                   	leave
  8010ca:	c3                   	ret

00000000008010cb <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  8010cb:	f3 0f 1e fa          	endbr64
  8010cf:	55                   	push   %rbp
  8010d0:	48 89 e5             	mov    %rsp,%rbp
  8010d3:	53                   	push   %rbx
  8010d4:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  8010d8:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8010db:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8010e0:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8010e5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010ea:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8010ef:	be 00 00 00 00       	mov    $0x0,%esi
  8010f4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8010fa:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8010fc:	48 85 c0             	test   %rax,%rax
  8010ff:	7f 06                	jg     801107 <sys_env_destroy+0x3c>
}
  801101:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801105:	c9                   	leave
  801106:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801107:	49 89 c0             	mov    %rax,%r8
  80110a:	b9 03 00 00 00       	mov    $0x3,%ecx
  80110f:	48 ba 60 46 80 00 00 	movabs $0x804660,%rdx
  801116:	00 00 00 
  801119:	be 26 00 00 00       	mov    $0x26,%esi
  80111e:	48 bf af 41 80 00 00 	movabs $0x8041af,%rdi
  801125:	00 00 00 
  801128:	b8 00 00 00 00       	mov    $0x0,%eax
  80112d:	49 b9 91 2c 80 00 00 	movabs $0x802c91,%r9
  801134:	00 00 00 
  801137:	41 ff d1             	call   *%r9

000000000080113a <sys_getenvid>:

envid_t
sys_getenvid(void) {
  80113a:	f3 0f 1e fa          	endbr64
  80113e:	55                   	push   %rbp
  80113f:	48 89 e5             	mov    %rsp,%rbp
  801142:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801143:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801148:	ba 00 00 00 00       	mov    $0x0,%edx
  80114d:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801152:	bb 00 00 00 00       	mov    $0x0,%ebx
  801157:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80115c:	be 00 00 00 00       	mov    $0x0,%esi
  801161:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801167:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  801169:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80116d:	c9                   	leave
  80116e:	c3                   	ret

000000000080116f <sys_yield>:

void
sys_yield(void) {
  80116f:	f3 0f 1e fa          	endbr64
  801173:	55                   	push   %rbp
  801174:	48 89 e5             	mov    %rsp,%rbp
  801177:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801178:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80117d:	ba 00 00 00 00       	mov    $0x0,%edx
  801182:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801187:	bb 00 00 00 00       	mov    $0x0,%ebx
  80118c:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801191:	be 00 00 00 00       	mov    $0x0,%esi
  801196:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80119c:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  80119e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011a2:	c9                   	leave
  8011a3:	c3                   	ret

00000000008011a4 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  8011a4:	f3 0f 1e fa          	endbr64
  8011a8:	55                   	push   %rbp
  8011a9:	48 89 e5             	mov    %rsp,%rbp
  8011ac:	53                   	push   %rbx
  8011ad:	48 89 fa             	mov    %rdi,%rdx
  8011b0:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8011b3:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8011b8:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  8011bf:	00 00 00 
  8011c2:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8011c7:	be 00 00 00 00       	mov    $0x0,%esi
  8011cc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8011d2:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  8011d4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011d8:	c9                   	leave
  8011d9:	c3                   	ret

00000000008011da <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  8011da:	f3 0f 1e fa          	endbr64
  8011de:	55                   	push   %rbp
  8011df:	48 89 e5             	mov    %rsp,%rbp
  8011e2:	53                   	push   %rbx
  8011e3:	49 89 f8             	mov    %rdi,%r8
  8011e6:	48 89 d3             	mov    %rdx,%rbx
  8011e9:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  8011ec:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8011f1:	4c 89 c2             	mov    %r8,%rdx
  8011f4:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8011f7:	be 00 00 00 00       	mov    $0x0,%esi
  8011fc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801202:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  801204:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801208:	c9                   	leave
  801209:	c3                   	ret

000000000080120a <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  80120a:	f3 0f 1e fa          	endbr64
  80120e:	55                   	push   %rbp
  80120f:	48 89 e5             	mov    %rsp,%rbp
  801212:	53                   	push   %rbx
  801213:	48 83 ec 08          	sub    $0x8,%rsp
  801217:	89 f8                	mov    %edi,%eax
  801219:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  80121c:	48 63 f9             	movslq %ecx,%rdi
  80121f:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801222:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801227:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80122a:	be 00 00 00 00       	mov    $0x0,%esi
  80122f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801235:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801237:	48 85 c0             	test   %rax,%rax
  80123a:	7f 06                	jg     801242 <sys_alloc_region+0x38>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  80123c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801240:	c9                   	leave
  801241:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801242:	49 89 c0             	mov    %rax,%r8
  801245:	b9 04 00 00 00       	mov    $0x4,%ecx
  80124a:	48 ba 60 46 80 00 00 	movabs $0x804660,%rdx
  801251:	00 00 00 
  801254:	be 26 00 00 00       	mov    $0x26,%esi
  801259:	48 bf af 41 80 00 00 	movabs $0x8041af,%rdi
  801260:	00 00 00 
  801263:	b8 00 00 00 00       	mov    $0x0,%eax
  801268:	49 b9 91 2c 80 00 00 	movabs $0x802c91,%r9
  80126f:	00 00 00 
  801272:	41 ff d1             	call   *%r9

0000000000801275 <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  801275:	f3 0f 1e fa          	endbr64
  801279:	55                   	push   %rbp
  80127a:	48 89 e5             	mov    %rsp,%rbp
  80127d:	53                   	push   %rbx
  80127e:	48 83 ec 08          	sub    $0x8,%rsp
  801282:	89 f8                	mov    %edi,%eax
  801284:	49 89 f2             	mov    %rsi,%r10
  801287:	48 89 cf             	mov    %rcx,%rdi
  80128a:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  80128d:	48 63 da             	movslq %edx,%rbx
  801290:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801293:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801298:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80129b:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  80129e:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8012a0:	48 85 c0             	test   %rax,%rax
  8012a3:	7f 06                	jg     8012ab <sys_map_region+0x36>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  8012a5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012a9:	c9                   	leave
  8012aa:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8012ab:	49 89 c0             	mov    %rax,%r8
  8012ae:	b9 05 00 00 00       	mov    $0x5,%ecx
  8012b3:	48 ba 60 46 80 00 00 	movabs $0x804660,%rdx
  8012ba:	00 00 00 
  8012bd:	be 26 00 00 00       	mov    $0x26,%esi
  8012c2:	48 bf af 41 80 00 00 	movabs $0x8041af,%rdi
  8012c9:	00 00 00 
  8012cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8012d1:	49 b9 91 2c 80 00 00 	movabs $0x802c91,%r9
  8012d8:	00 00 00 
  8012db:	41 ff d1             	call   *%r9

00000000008012de <sys_map_physical_region>:

int
sys_map_physical_region(uintptr_t pa, envid_t dstenv, void *dstva, size_t size, int perm) {
  8012de:	f3 0f 1e fa          	endbr64
  8012e2:	55                   	push   %rbp
  8012e3:	48 89 e5             	mov    %rsp,%rbp
  8012e6:	53                   	push   %rbx
  8012e7:	48 83 ec 08          	sub    $0x8,%rsp
  8012eb:	49 89 f9             	mov    %rdi,%r9
  8012ee:	89 f0                	mov    %esi,%eax
  8012f0:	48 89 d3             	mov    %rdx,%rbx
  8012f3:	48 89 cf             	mov    %rcx,%rdi
    int res = syscall(SYS_map_physical_region, 1, pa, dstenv, (uintptr_t)dstva, size, perm, 0);
  8012f6:	49 63 f0             	movslq %r8d,%rsi
  8012f9:	48 63 c8             	movslq %eax,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8012fc:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801301:	4c 89 ca             	mov    %r9,%rdx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801304:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80130a:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80130c:	48 85 c0             	test   %rax,%rax
  80130f:	7f 06                	jg     801317 <sys_map_physical_region+0x39>
#ifdef SANITIZE_USER_SHADOW_BASE
    platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  801311:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801315:	c9                   	leave
  801316:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801317:	49 89 c0             	mov    %rax,%r8
  80131a:	b9 06 00 00 00       	mov    $0x6,%ecx
  80131f:	48 ba 60 46 80 00 00 	movabs $0x804660,%rdx
  801326:	00 00 00 
  801329:	be 26 00 00 00       	mov    $0x26,%esi
  80132e:	48 bf af 41 80 00 00 	movabs $0x8041af,%rdi
  801335:	00 00 00 
  801338:	b8 00 00 00 00       	mov    $0x0,%eax
  80133d:	49 b9 91 2c 80 00 00 	movabs $0x802c91,%r9
  801344:	00 00 00 
  801347:	41 ff d1             	call   *%r9

000000000080134a <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  80134a:	f3 0f 1e fa          	endbr64
  80134e:	55                   	push   %rbp
  80134f:	48 89 e5             	mov    %rsp,%rbp
  801352:	53                   	push   %rbx
  801353:	48 83 ec 08          	sub    $0x8,%rsp
  801357:	48 89 f1             	mov    %rsi,%rcx
  80135a:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  80135d:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801360:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801365:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80136a:	be 00 00 00 00       	mov    $0x0,%esi
  80136f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801375:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801377:	48 85 c0             	test   %rax,%rax
  80137a:	7f 06                	jg     801382 <sys_unmap_region+0x38>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  80137c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801380:	c9                   	leave
  801381:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801382:	49 89 c0             	mov    %rax,%r8
  801385:	b9 07 00 00 00       	mov    $0x7,%ecx
  80138a:	48 ba 60 46 80 00 00 	movabs $0x804660,%rdx
  801391:	00 00 00 
  801394:	be 26 00 00 00       	mov    $0x26,%esi
  801399:	48 bf af 41 80 00 00 	movabs $0x8041af,%rdi
  8013a0:	00 00 00 
  8013a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8013a8:	49 b9 91 2c 80 00 00 	movabs $0x802c91,%r9
  8013af:	00 00 00 
  8013b2:	41 ff d1             	call   *%r9

00000000008013b5 <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  8013b5:	f3 0f 1e fa          	endbr64
  8013b9:	55                   	push   %rbp
  8013ba:	48 89 e5             	mov    %rsp,%rbp
  8013bd:	53                   	push   %rbx
  8013be:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  8013c2:	48 63 ce             	movslq %esi,%rcx
  8013c5:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8013c8:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8013cd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013d2:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013d7:	be 00 00 00 00       	mov    $0x0,%esi
  8013dc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013e2:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8013e4:	48 85 c0             	test   %rax,%rax
  8013e7:	7f 06                	jg     8013ef <sys_env_set_status+0x3a>
}
  8013e9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013ed:	c9                   	leave
  8013ee:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8013ef:	49 89 c0             	mov    %rax,%r8
  8013f2:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013f7:	48 ba 60 46 80 00 00 	movabs $0x804660,%rdx
  8013fe:	00 00 00 
  801401:	be 26 00 00 00       	mov    $0x26,%esi
  801406:	48 bf af 41 80 00 00 	movabs $0x8041af,%rdi
  80140d:	00 00 00 
  801410:	b8 00 00 00 00       	mov    $0x0,%eax
  801415:	49 b9 91 2c 80 00 00 	movabs $0x802c91,%r9
  80141c:	00 00 00 
  80141f:	41 ff d1             	call   *%r9

0000000000801422 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  801422:	f3 0f 1e fa          	endbr64
  801426:	55                   	push   %rbp
  801427:	48 89 e5             	mov    %rsp,%rbp
  80142a:	53                   	push   %rbx
  80142b:	48 83 ec 08          	sub    $0x8,%rsp
  80142f:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  801432:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801435:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80143a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80143f:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801444:	be 00 00 00 00       	mov    $0x0,%esi
  801449:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80144f:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801451:	48 85 c0             	test   %rax,%rax
  801454:	7f 06                	jg     80145c <sys_env_set_trapframe+0x3a>
}
  801456:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80145a:	c9                   	leave
  80145b:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80145c:	49 89 c0             	mov    %rax,%r8
  80145f:	b9 0b 00 00 00       	mov    $0xb,%ecx
  801464:	48 ba 60 46 80 00 00 	movabs $0x804660,%rdx
  80146b:	00 00 00 
  80146e:	be 26 00 00 00       	mov    $0x26,%esi
  801473:	48 bf af 41 80 00 00 	movabs $0x8041af,%rdi
  80147a:	00 00 00 
  80147d:	b8 00 00 00 00       	mov    $0x0,%eax
  801482:	49 b9 91 2c 80 00 00 	movabs $0x802c91,%r9
  801489:	00 00 00 
  80148c:	41 ff d1             	call   *%r9

000000000080148f <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  80148f:	f3 0f 1e fa          	endbr64
  801493:	55                   	push   %rbp
  801494:	48 89 e5             	mov    %rsp,%rbp
  801497:	53                   	push   %rbx
  801498:	48 83 ec 08          	sub    $0x8,%rsp
  80149c:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  80149f:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8014a2:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8014a7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014ac:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8014b1:	be 00 00 00 00       	mov    $0x0,%esi
  8014b6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8014bc:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8014be:	48 85 c0             	test   %rax,%rax
  8014c1:	7f 06                	jg     8014c9 <sys_env_set_pgfault_upcall+0x3a>
}
  8014c3:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014c7:	c9                   	leave
  8014c8:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8014c9:	49 89 c0             	mov    %rax,%r8
  8014cc:	b9 0c 00 00 00       	mov    $0xc,%ecx
  8014d1:	48 ba 60 46 80 00 00 	movabs $0x804660,%rdx
  8014d8:	00 00 00 
  8014db:	be 26 00 00 00       	mov    $0x26,%esi
  8014e0:	48 bf af 41 80 00 00 	movabs $0x8041af,%rdi
  8014e7:	00 00 00 
  8014ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ef:	49 b9 91 2c 80 00 00 	movabs $0x802c91,%r9
  8014f6:	00 00 00 
  8014f9:	41 ff d1             	call   *%r9

00000000008014fc <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  8014fc:	f3 0f 1e fa          	endbr64
  801500:	55                   	push   %rbp
  801501:	48 89 e5             	mov    %rsp,%rbp
  801504:	53                   	push   %rbx
  801505:	89 f8                	mov    %edi,%eax
  801507:	49 89 f1             	mov    %rsi,%r9
  80150a:	48 89 d3             	mov    %rdx,%rbx
  80150d:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  801510:	49 63 f0             	movslq %r8d,%rsi
  801513:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801516:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80151b:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80151e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801524:	cd 30                	int    $0x30
}
  801526:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80152a:	c9                   	leave
  80152b:	c3                   	ret

000000000080152c <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  80152c:	f3 0f 1e fa          	endbr64
  801530:	55                   	push   %rbp
  801531:	48 89 e5             	mov    %rsp,%rbp
  801534:	53                   	push   %rbx
  801535:	48 83 ec 08          	sub    $0x8,%rsp
  801539:	48 89 fa             	mov    %rdi,%rdx
  80153c:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80153f:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801544:	bb 00 00 00 00       	mov    $0x0,%ebx
  801549:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80154e:	be 00 00 00 00       	mov    $0x0,%esi
  801553:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801559:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80155b:	48 85 c0             	test   %rax,%rax
  80155e:	7f 06                	jg     801566 <sys_ipc_recv+0x3a>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  801560:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801564:	c9                   	leave
  801565:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801566:	49 89 c0             	mov    %rax,%r8
  801569:	b9 0f 00 00 00       	mov    $0xf,%ecx
  80156e:	48 ba 60 46 80 00 00 	movabs $0x804660,%rdx
  801575:	00 00 00 
  801578:	be 26 00 00 00       	mov    $0x26,%esi
  80157d:	48 bf af 41 80 00 00 	movabs $0x8041af,%rdi
  801584:	00 00 00 
  801587:	b8 00 00 00 00       	mov    $0x0,%eax
  80158c:	49 b9 91 2c 80 00 00 	movabs $0x802c91,%r9
  801593:	00 00 00 
  801596:	41 ff d1             	call   *%r9

0000000000801599 <sys_gettime>:

int
sys_gettime(void) {
  801599:	f3 0f 1e fa          	endbr64
  80159d:	55                   	push   %rbp
  80159e:	48 89 e5             	mov    %rsp,%rbp
  8015a1:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8015a2:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8015a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8015ac:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8015b1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015b6:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8015bb:	be 00 00 00 00       	mov    $0x0,%esi
  8015c0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8015c6:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  8015c8:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8015cc:	c9                   	leave
  8015cd:	c3                   	ret

00000000008015ce <fork>:
 *   Use sys_map_region, it can perform address space copying in one call
 *   Don't forget to set page fault handler in the child (using sys_env_set_pgfault_upcall()).
 *   Remember to fix "thisenv" in the child process.
 */
envid_t
fork(void) {
  8015ce:	f3 0f 1e fa          	endbr64
  8015d2:	55                   	push   %rbp
  8015d3:	48 89 e5             	mov    %rsp,%rbp
  8015d6:	41 56                	push   %r14
  8015d8:	41 55                	push   %r13
  8015da:	41 54                	push   %r12
  8015dc:	53                   	push   %rbx
    // LAB 9: Your code here.
    bool has_pgfault_upcall = thisenv->env_pgfault_upcall;
  8015dd:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  8015e4:	00 00 00 
  8015e7:	4c 8b b0 00 01 00 00 	mov    0x100(%rax),%r14

/* This must be inlined. Exercise for reader: why? */
static inline envid_t __attribute__((always_inline))
sys_exofork(void) {
    envid_t ret;
    asm volatile("int %2"
  8015ee:	b8 09 00 00 00       	mov    $0x9,%eax
  8015f3:	cd 30                	int    $0x30
  8015f5:	41 89 c4             	mov    %eax,%r12d

    envid_t envid = sys_exofork();
    if (envid < 0) {
  8015f8:	85 c0                	test   %eax,%eax
  8015fa:	78 7f                	js     80167b <fork+0xad>
  8015fc:	89 c3                	mov    %eax,%ebx
        return envid;
    }
    if (envid == 0) {
  8015fe:	0f 84 83 00 00 00    	je     801687 <fork+0xb9>
        thisenv = &envs[ENVX(sys_getenvid())];
        return 0;
    }
    int res = sys_map_region(CURENVID, NULL, envid, NULL, MAX_USER_ADDRESS, PROT_ALL | PROT_LAZY | PROT_COMBINE);
  801604:	41 b9 ff 0f 00 00    	mov    $0xfff,%r9d
  80160a:	49 b8 00 00 00 00 80 	movabs $0x8000000000,%r8
  801611:	00 00 00 
  801614:	b9 00 00 00 00       	mov    $0x0,%ecx
  801619:	89 c2                	mov    %eax,%edx
  80161b:	be 00 00 00 00       	mov    $0x0,%esi
  801620:	bf 00 00 00 00       	mov    $0x0,%edi
  801625:	48 b8 75 12 80 00 00 	movabs $0x801275,%rax
  80162c:	00 00 00 
  80162f:	ff d0                	call   *%rax
  801631:	41 89 c5             	mov    %eax,%r13d
    if (res < 0) {
  801634:	85 c0                	test   %eax,%eax
  801636:	0f 88 81 00 00 00    	js     8016bd <fork+0xef>
        sys_env_destroy(envid);
        return res;
    }
    if (has_pgfault_upcall) {
  80163c:	4d 85 f6             	test   %r14,%r14
  80163f:	74 20                	je     801661 <fork+0x93>
        res = sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  801641:	48 be 38 2d 80 00 00 	movabs $0x802d38,%rsi
  801648:	00 00 00 
  80164b:	44 89 e7             	mov    %r12d,%edi
  80164e:	48 b8 8f 14 80 00 00 	movabs $0x80148f,%rax
  801655:	00 00 00 
  801658:	ff d0                	call   *%rax
  80165a:	41 89 c5             	mov    %eax,%r13d
        if (res < 0) {
  80165d:	85 c0                	test   %eax,%eax
  80165f:	78 70                	js     8016d1 <fork+0x103>
            sys_env_destroy(envid);
            return res;
        }
    }
    res = sys_env_set_status(envid, ENV_RUNNABLE);
  801661:	be 02 00 00 00       	mov    $0x2,%esi
  801666:	89 df                	mov    %ebx,%edi
  801668:	48 b8 b5 13 80 00 00 	movabs $0x8013b5,%rax
  80166f:	00 00 00 
  801672:	ff d0                	call   *%rax
  801674:	41 89 c5             	mov    %eax,%r13d
    if (res < 0) {
  801677:	85 c0                	test   %eax,%eax
  801679:	78 6a                	js     8016e5 <fork+0x117>
        sys_env_destroy(envid);
        return res;
    }
    return envid;
}
  80167b:	44 89 e0             	mov    %r12d,%eax
  80167e:	5b                   	pop    %rbx
  80167f:	41 5c                	pop    %r12
  801681:	41 5d                	pop    %r13
  801683:	41 5e                	pop    %r14
  801685:	5d                   	pop    %rbp
  801686:	c3                   	ret
        thisenv = &envs[ENVX(sys_getenvid())];
  801687:	48 b8 3a 11 80 00 00 	movabs $0x80113a,%rax
  80168e:	00 00 00 
  801691:	ff d0                	call   *%rax
  801693:	25 ff 03 00 00       	and    $0x3ff,%eax
  801698:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  80169c:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8016a0:	48 c1 e0 04          	shl    $0x4,%rax
  8016a4:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  8016ab:	00 00 00 
  8016ae:	48 01 d0             	add    %rdx,%rax
  8016b1:	48 a3 00 60 80 00 00 	movabs %rax,0x806000
  8016b8:	00 00 00 
        return 0;
  8016bb:	eb be                	jmp    80167b <fork+0xad>
        sys_env_destroy(envid);
  8016bd:	44 89 e7             	mov    %r12d,%edi
  8016c0:	48 b8 cb 10 80 00 00 	movabs $0x8010cb,%rax
  8016c7:	00 00 00 
  8016ca:	ff d0                	call   *%rax
        return res;
  8016cc:	45 89 ec             	mov    %r13d,%r12d
  8016cf:	eb aa                	jmp    80167b <fork+0xad>
            sys_env_destroy(envid);
  8016d1:	44 89 e7             	mov    %r12d,%edi
  8016d4:	48 b8 cb 10 80 00 00 	movabs $0x8010cb,%rax
  8016db:	00 00 00 
  8016de:	ff d0                	call   *%rax
            return res;
  8016e0:	45 89 ec             	mov    %r13d,%r12d
  8016e3:	eb 96                	jmp    80167b <fork+0xad>
        sys_env_destroy(envid);
  8016e5:	89 df                	mov    %ebx,%edi
  8016e7:	48 b8 cb 10 80 00 00 	movabs $0x8010cb,%rax
  8016ee:	00 00 00 
  8016f1:	ff d0                	call   *%rax
        return res;
  8016f3:	45 89 ec             	mov    %r13d,%r12d
  8016f6:	eb 83                	jmp    80167b <fork+0xad>

00000000008016f8 <sfork>:

envid_t
sfork() {
  8016f8:	f3 0f 1e fa          	endbr64
  8016fc:	55                   	push   %rbp
  8016fd:	48 89 e5             	mov    %rsp,%rbp
    panic("sfork() is not implemented");
  801700:	48 ba bd 41 80 00 00 	movabs $0x8041bd,%rdx
  801707:	00 00 00 
  80170a:	be 37 00 00 00       	mov    $0x37,%esi
  80170f:	48 bf d8 41 80 00 00 	movabs $0x8041d8,%rdi
  801716:	00 00 00 
  801719:	b8 00 00 00 00       	mov    $0x0,%eax
  80171e:	48 b9 91 2c 80 00 00 	movabs $0x802c91,%rcx
  801725:	00 00 00 
  801728:	ff d1                	call   *%rcx

000000000080172a <fd2num>:


/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
  80172a:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80172e:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801735:	ff ff ff 
  801738:	48 01 f8             	add    %rdi,%rax
  80173b:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80173f:	c3                   	ret

0000000000801740 <fd2data>:

char *
fd2data(struct Fd *fd) {
  801740:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801744:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80174b:	ff ff ff 
  80174e:	48 01 f8             	add    %rdi,%rax
  801751:	48 c1 e8 0c          	shr    $0xc,%rax
    return INDEX2DATA(fd2num(fd));
  801755:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80175b:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80175f:	c3                   	ret

0000000000801760 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  801760:	f3 0f 1e fa          	endbr64
  801764:	55                   	push   %rbp
  801765:	48 89 e5             	mov    %rsp,%rbp
  801768:	41 57                	push   %r15
  80176a:	41 56                	push   %r14
  80176c:	41 55                	push   %r13
  80176e:	41 54                	push   %r12
  801770:	53                   	push   %rbx
  801771:	48 83 ec 08          	sub    $0x8,%rsp
  801775:	49 89 ff             	mov    %rdi,%r15
  801778:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  80177d:	49 bd bf 28 80 00 00 	movabs $0x8028bf,%r13
  801784:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  801787:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        struct Fd *fd = INDEX2FD(i);
  80178d:	49 89 dc             	mov    %rbx,%r12
        if (!(get_prot(fd) & PROT_R)) {
  801790:	48 89 df             	mov    %rbx,%rdi
  801793:	41 ff d5             	call   *%r13
  801796:	83 e0 04             	and    $0x4,%eax
  801799:	74 17                	je     8017b2 <fd_alloc+0x52>
    for (int i = 0; i < MAXFD; i++) {
  80179b:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  8017a2:	4c 39 f3             	cmp    %r14,%rbx
  8017a5:	75 e6                	jne    80178d <fd_alloc+0x2d>
  8017a7:	41 bc 00 00 00 00    	mov    $0x0,%r12d
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
    return -E_MAX_OPEN;
  8017ad:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
            *fd_store = fd;
  8017b2:	4d 89 27             	mov    %r12,(%r15)
}
  8017b5:	48 83 c4 08          	add    $0x8,%rsp
  8017b9:	5b                   	pop    %rbx
  8017ba:	41 5c                	pop    %r12
  8017bc:	41 5d                	pop    %r13
  8017be:	41 5e                	pop    %r14
  8017c0:	41 5f                	pop    %r15
  8017c2:	5d                   	pop    %rbp
  8017c3:	c3                   	ret

00000000008017c4 <fd_lookup>:
 *
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
  8017c4:	f3 0f 1e fa          	endbr64
    if (fdnum < 0 || fdnum >= MAXFD) {
  8017c8:	83 ff 1f             	cmp    $0x1f,%edi
  8017cb:	77 39                	ja     801806 <fd_lookup+0x42>
fd_lookup(int fdnum, struct Fd **fd_store) {
  8017cd:	55                   	push   %rbp
  8017ce:	48 89 e5             	mov    %rsp,%rbp
  8017d1:	41 54                	push   %r12
  8017d3:	53                   	push   %rbx
  8017d4:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  8017d7:	48 63 df             	movslq %edi,%rbx
  8017da:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  8017e1:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  8017e5:	48 89 df             	mov    %rbx,%rdi
  8017e8:	48 b8 bf 28 80 00 00 	movabs $0x8028bf,%rax
  8017ef:	00 00 00 
  8017f2:	ff d0                	call   *%rax
  8017f4:	a8 04                	test   $0x4,%al
  8017f6:	74 14                	je     80180c <fd_lookup+0x48>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  8017f8:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  8017fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801801:	5b                   	pop    %rbx
  801802:	41 5c                	pop    %r12
  801804:	5d                   	pop    %rbp
  801805:	c3                   	ret
        return -E_INVAL;
  801806:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80180b:	c3                   	ret
        return -E_INVAL;
  80180c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801811:	eb ee                	jmp    801801 <fd_lookup+0x3d>

0000000000801813 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  801813:	f3 0f 1e fa          	endbr64
  801817:	55                   	push   %rbp
  801818:	48 89 e5             	mov    %rsp,%rbp
  80181b:	41 54                	push   %r12
  80181d:	53                   	push   %rbx
  80181e:	49 89 f4             	mov    %rsi,%r12
    for (size_t i = 0; devtab[i]; i++) {
  801821:	48 b8 60 47 80 00 00 	movabs $0x804760,%rax
  801828:	00 00 00 
  80182b:	48 bb 20 50 80 00 00 	movabs $0x805020,%rbx
  801832:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  801835:	39 3b                	cmp    %edi,(%rbx)
  801837:	74 47                	je     801880 <dev_lookup+0x6d>
    for (size_t i = 0; devtab[i]; i++) {
  801839:	48 83 c0 08          	add    $0x8,%rax
  80183d:	48 8b 18             	mov    (%rax),%rbx
  801840:	48 85 db             	test   %rbx,%rbx
  801843:	75 f0                	jne    801835 <dev_lookup+0x22>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801845:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  80184c:	00 00 00 
  80184f:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801855:	89 fa                	mov    %edi,%edx
  801857:	48 bf 80 46 80 00 00 	movabs $0x804680,%rdi
  80185e:	00 00 00 
  801861:	b8 00 00 00 00       	mov    $0x0,%eax
  801866:	48 b9 bc 02 80 00 00 	movabs $0x8002bc,%rcx
  80186d:	00 00 00 
  801870:	ff d1                	call   *%rcx
    *dev = 0;
    return -E_INVAL;
  801872:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
            *dev = devtab[i];
  801877:	49 89 1c 24          	mov    %rbx,(%r12)
}
  80187b:	5b                   	pop    %rbx
  80187c:	41 5c                	pop    %r12
  80187e:	5d                   	pop    %rbp
  80187f:	c3                   	ret
            return 0;
  801880:	b8 00 00 00 00       	mov    $0x0,%eax
  801885:	eb f0                	jmp    801877 <dev_lookup+0x64>

0000000000801887 <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  801887:	f3 0f 1e fa          	endbr64
  80188b:	55                   	push   %rbp
  80188c:	48 89 e5             	mov    %rsp,%rbp
  80188f:	41 55                	push   %r13
  801891:	41 54                	push   %r12
  801893:	53                   	push   %rbx
  801894:	48 83 ec 18          	sub    $0x18,%rsp
  801898:	48 89 fb             	mov    %rdi,%rbx
  80189b:	41 89 f4             	mov    %esi,%r12d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80189e:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  8018a5:	ff ff ff 
  8018a8:	48 01 df             	add    %rbx,%rdi
  8018ab:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  8018af:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8018b3:	48 b8 c4 17 80 00 00 	movabs $0x8017c4,%rax
  8018ba:	00 00 00 
  8018bd:	ff d0                	call   *%rax
  8018bf:	41 89 c5             	mov    %eax,%r13d
  8018c2:	85 c0                	test   %eax,%eax
  8018c4:	78 06                	js     8018cc <fd_close+0x45>
  8018c6:	48 39 5d d8          	cmp    %rbx,-0x28(%rbp)
  8018ca:	74 1a                	je     8018e6 <fd_close+0x5f>
        return (must_exist ? res : 0);
  8018cc:	45 84 e4             	test   %r12b,%r12b
  8018cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8018d4:	44 0f 44 e8          	cmove  %eax,%r13d
}
  8018d8:	44 89 e8             	mov    %r13d,%eax
  8018db:	48 83 c4 18          	add    $0x18,%rsp
  8018df:	5b                   	pop    %rbx
  8018e0:	41 5c                	pop    %r12
  8018e2:	41 5d                	pop    %r13
  8018e4:	5d                   	pop    %rbp
  8018e5:	c3                   	ret
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8018e6:	8b 3b                	mov    (%rbx),%edi
  8018e8:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8018ec:	48 b8 13 18 80 00 00 	movabs $0x801813,%rax
  8018f3:	00 00 00 
  8018f6:	ff d0                	call   *%rax
  8018f8:	41 89 c5             	mov    %eax,%r13d
  8018fb:	85 c0                	test   %eax,%eax
  8018fd:	78 1b                	js     80191a <fd_close+0x93>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  8018ff:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801903:	48 8b 40 20          	mov    0x20(%rax),%rax
  801907:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  80190d:	48 85 c0             	test   %rax,%rax
  801910:	74 08                	je     80191a <fd_close+0x93>
  801912:	48 89 df             	mov    %rbx,%rdi
  801915:	ff d0                	call   *%rax
  801917:	41 89 c5             	mov    %eax,%r13d
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  80191a:	ba 00 10 00 00       	mov    $0x1000,%edx
  80191f:	48 89 de             	mov    %rbx,%rsi
  801922:	bf 00 00 00 00       	mov    $0x0,%edi
  801927:	48 b8 4a 13 80 00 00 	movabs $0x80134a,%rax
  80192e:	00 00 00 
  801931:	ff d0                	call   *%rax
    return res;
  801933:	eb a3                	jmp    8018d8 <fd_close+0x51>

0000000000801935 <close>:

int
close(int fdnum) {
  801935:	f3 0f 1e fa          	endbr64
  801939:	55                   	push   %rbp
  80193a:	48 89 e5             	mov    %rsp,%rbp
  80193d:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  801941:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801945:	48 b8 c4 17 80 00 00 	movabs $0x8017c4,%rax
  80194c:	00 00 00 
  80194f:	ff d0                	call   *%rax
    if (res < 0) return res;
  801951:	85 c0                	test   %eax,%eax
  801953:	78 15                	js     80196a <close+0x35>

    return fd_close(fd, 1);
  801955:	be 01 00 00 00       	mov    $0x1,%esi
  80195a:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80195e:	48 b8 87 18 80 00 00 	movabs $0x801887,%rax
  801965:	00 00 00 
  801968:	ff d0                	call   *%rax
}
  80196a:	c9                   	leave
  80196b:	c3                   	ret

000000000080196c <close_all>:

void
close_all(void) {
  80196c:	f3 0f 1e fa          	endbr64
  801970:	55                   	push   %rbp
  801971:	48 89 e5             	mov    %rsp,%rbp
  801974:	41 54                	push   %r12
  801976:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  801977:	bb 00 00 00 00       	mov    $0x0,%ebx
  80197c:	49 bc 35 19 80 00 00 	movabs $0x801935,%r12
  801983:	00 00 00 
  801986:	89 df                	mov    %ebx,%edi
  801988:	41 ff d4             	call   *%r12
  80198b:	83 c3 01             	add    $0x1,%ebx
  80198e:	83 fb 20             	cmp    $0x20,%ebx
  801991:	75 f3                	jne    801986 <close_all+0x1a>
}
  801993:	5b                   	pop    %rbx
  801994:	41 5c                	pop    %r12
  801996:	5d                   	pop    %rbp
  801997:	c3                   	ret

0000000000801998 <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  801998:	f3 0f 1e fa          	endbr64
  80199c:	55                   	push   %rbp
  80199d:	48 89 e5             	mov    %rsp,%rbp
  8019a0:	41 57                	push   %r15
  8019a2:	41 56                	push   %r14
  8019a4:	41 55                	push   %r13
  8019a6:	41 54                	push   %r12
  8019a8:	53                   	push   %rbx
  8019a9:	48 83 ec 18          	sub    $0x18,%rsp
  8019ad:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  8019b0:	48 8d 75 c8          	lea    -0x38(%rbp),%rsi
  8019b4:	48 b8 c4 17 80 00 00 	movabs $0x8017c4,%rax
  8019bb:	00 00 00 
  8019be:	ff d0                	call   *%rax
  8019c0:	89 c3                	mov    %eax,%ebx
  8019c2:	85 c0                	test   %eax,%eax
  8019c4:	0f 88 b8 00 00 00    	js     801a82 <dup+0xea>
    close(newfdnum);
  8019ca:	44 89 e7             	mov    %r12d,%edi
  8019cd:	48 b8 35 19 80 00 00 	movabs $0x801935,%rax
  8019d4:	00 00 00 
  8019d7:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  8019d9:	4d 63 ec             	movslq %r12d,%r13
  8019dc:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  8019e3:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  8019e7:	4c 8b 7d c8          	mov    -0x38(%rbp),%r15
  8019eb:	4c 89 ff             	mov    %r15,%rdi
  8019ee:	49 be 40 17 80 00 00 	movabs $0x801740,%r14
  8019f5:	00 00 00 
  8019f8:	41 ff d6             	call   *%r14
  8019fb:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  8019fe:	4c 89 ef             	mov    %r13,%rdi
  801a01:	41 ff d6             	call   *%r14
  801a04:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  801a07:	48 89 df             	mov    %rbx,%rdi
  801a0a:	48 b8 bf 28 80 00 00 	movabs $0x8028bf,%rax
  801a11:	00 00 00 
  801a14:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  801a16:	a8 04                	test   $0x4,%al
  801a18:	74 2b                	je     801a45 <dup+0xad>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  801a1a:	41 89 c1             	mov    %eax,%r9d
  801a1d:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801a23:	4c 89 f1             	mov    %r14,%rcx
  801a26:	ba 00 00 00 00       	mov    $0x0,%edx
  801a2b:	48 89 de             	mov    %rbx,%rsi
  801a2e:	bf 00 00 00 00       	mov    $0x0,%edi
  801a33:	48 b8 75 12 80 00 00 	movabs $0x801275,%rax
  801a3a:	00 00 00 
  801a3d:	ff d0                	call   *%rax
  801a3f:	89 c3                	mov    %eax,%ebx
  801a41:	85 c0                	test   %eax,%eax
  801a43:	78 4e                	js     801a93 <dup+0xfb>
    }
    prot = get_prot(oldfd);
  801a45:	4c 89 ff             	mov    %r15,%rdi
  801a48:	48 b8 bf 28 80 00 00 	movabs $0x8028bf,%rax
  801a4f:	00 00 00 
  801a52:	ff d0                	call   *%rax
  801a54:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  801a57:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801a5d:	4c 89 e9             	mov    %r13,%rcx
  801a60:	ba 00 00 00 00       	mov    $0x0,%edx
  801a65:	4c 89 fe             	mov    %r15,%rsi
  801a68:	bf 00 00 00 00       	mov    $0x0,%edi
  801a6d:	48 b8 75 12 80 00 00 	movabs $0x801275,%rax
  801a74:	00 00 00 
  801a77:	ff d0                	call   *%rax
  801a79:	89 c3                	mov    %eax,%ebx
  801a7b:	85 c0                	test   %eax,%eax
  801a7d:	78 14                	js     801a93 <dup+0xfb>

    return newfdnum;
  801a7f:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  801a82:	89 d8                	mov    %ebx,%eax
  801a84:	48 83 c4 18          	add    $0x18,%rsp
  801a88:	5b                   	pop    %rbx
  801a89:	41 5c                	pop    %r12
  801a8b:	41 5d                	pop    %r13
  801a8d:	41 5e                	pop    %r14
  801a8f:	41 5f                	pop    %r15
  801a91:	5d                   	pop    %rbp
  801a92:	c3                   	ret
    sys_unmap_region(0, newfd, PAGE_SIZE);
  801a93:	ba 00 10 00 00       	mov    $0x1000,%edx
  801a98:	4c 89 ee             	mov    %r13,%rsi
  801a9b:	bf 00 00 00 00       	mov    $0x0,%edi
  801aa0:	49 bc 4a 13 80 00 00 	movabs $0x80134a,%r12
  801aa7:	00 00 00 
  801aaa:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  801aad:	ba 00 10 00 00       	mov    $0x1000,%edx
  801ab2:	4c 89 f6             	mov    %r14,%rsi
  801ab5:	bf 00 00 00 00       	mov    $0x0,%edi
  801aba:	41 ff d4             	call   *%r12
    return res;
  801abd:	eb c3                	jmp    801a82 <dup+0xea>

0000000000801abf <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  801abf:	f3 0f 1e fa          	endbr64
  801ac3:	55                   	push   %rbp
  801ac4:	48 89 e5             	mov    %rsp,%rbp
  801ac7:	41 56                	push   %r14
  801ac9:	41 55                	push   %r13
  801acb:	41 54                	push   %r12
  801acd:	53                   	push   %rbx
  801ace:	48 83 ec 10          	sub    $0x10,%rsp
  801ad2:	89 fb                	mov    %edi,%ebx
  801ad4:	49 89 f4             	mov    %rsi,%r12
  801ad7:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801ada:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801ade:	48 b8 c4 17 80 00 00 	movabs $0x8017c4,%rax
  801ae5:	00 00 00 
  801ae8:	ff d0                	call   *%rax
  801aea:	85 c0                	test   %eax,%eax
  801aec:	78 4c                	js     801b3a <read+0x7b>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801aee:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801af2:	41 8b 3e             	mov    (%r14),%edi
  801af5:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801af9:	48 b8 13 18 80 00 00 	movabs $0x801813,%rax
  801b00:	00 00 00 
  801b03:	ff d0                	call   *%rax
  801b05:	85 c0                	test   %eax,%eax
  801b07:	78 35                	js     801b3e <read+0x7f>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801b09:	41 8b 46 08          	mov    0x8(%r14),%eax
  801b0d:	83 e0 03             	and    $0x3,%eax
  801b10:	83 f8 01             	cmp    $0x1,%eax
  801b13:	74 2d                	je     801b42 <read+0x83>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  801b15:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b19:	48 8b 40 10          	mov    0x10(%rax),%rax
  801b1d:	48 85 c0             	test   %rax,%rax
  801b20:	74 56                	je     801b78 <read+0xb9>

    return (*dev->dev_read)(fd, buf, n);
  801b22:	4c 89 ea             	mov    %r13,%rdx
  801b25:	4c 89 e6             	mov    %r12,%rsi
  801b28:	4c 89 f7             	mov    %r14,%rdi
  801b2b:	ff d0                	call   *%rax
}
  801b2d:	48 83 c4 10          	add    $0x10,%rsp
  801b31:	5b                   	pop    %rbx
  801b32:	41 5c                	pop    %r12
  801b34:	41 5d                	pop    %r13
  801b36:	41 5e                	pop    %r14
  801b38:	5d                   	pop    %rbp
  801b39:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801b3a:	48 98                	cltq
  801b3c:	eb ef                	jmp    801b2d <read+0x6e>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801b3e:	48 98                	cltq
  801b40:	eb eb                	jmp    801b2d <read+0x6e>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801b42:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801b49:	00 00 00 
  801b4c:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801b52:	89 da                	mov    %ebx,%edx
  801b54:	48 bf e3 41 80 00 00 	movabs $0x8041e3,%rdi
  801b5b:	00 00 00 
  801b5e:	b8 00 00 00 00       	mov    $0x0,%eax
  801b63:	48 b9 bc 02 80 00 00 	movabs $0x8002bc,%rcx
  801b6a:	00 00 00 
  801b6d:	ff d1                	call   *%rcx
        return -E_INVAL;
  801b6f:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801b76:	eb b5                	jmp    801b2d <read+0x6e>
    if (!dev->dev_read) return -E_NOT_SUPP;
  801b78:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801b7f:	eb ac                	jmp    801b2d <read+0x6e>

0000000000801b81 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801b81:	f3 0f 1e fa          	endbr64
  801b85:	55                   	push   %rbp
  801b86:	48 89 e5             	mov    %rsp,%rbp
  801b89:	41 57                	push   %r15
  801b8b:	41 56                	push   %r14
  801b8d:	41 55                	push   %r13
  801b8f:	41 54                	push   %r12
  801b91:	53                   	push   %rbx
  801b92:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801b96:	48 85 d2             	test   %rdx,%rdx
  801b99:	74 54                	je     801bef <readn+0x6e>
  801b9b:	41 89 fd             	mov    %edi,%r13d
  801b9e:	49 89 f6             	mov    %rsi,%r14
  801ba1:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801ba4:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801ba9:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801bae:	49 bf bf 1a 80 00 00 	movabs $0x801abf,%r15
  801bb5:	00 00 00 
  801bb8:	4c 89 e2             	mov    %r12,%rdx
  801bbb:	48 29 f2             	sub    %rsi,%rdx
  801bbe:	4c 01 f6             	add    %r14,%rsi
  801bc1:	44 89 ef             	mov    %r13d,%edi
  801bc4:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  801bc7:	85 c0                	test   %eax,%eax
  801bc9:	78 20                	js     801beb <readn+0x6a>
    for (; inc && res < n; res += inc) {
  801bcb:	01 c3                	add    %eax,%ebx
  801bcd:	85 c0                	test   %eax,%eax
  801bcf:	74 08                	je     801bd9 <readn+0x58>
  801bd1:	48 63 f3             	movslq %ebx,%rsi
  801bd4:	4c 39 e6             	cmp    %r12,%rsi
  801bd7:	72 df                	jb     801bb8 <readn+0x37>
    }
    return res;
  801bd9:	48 63 c3             	movslq %ebx,%rax
}
  801bdc:	48 83 c4 08          	add    $0x8,%rsp
  801be0:	5b                   	pop    %rbx
  801be1:	41 5c                	pop    %r12
  801be3:	41 5d                	pop    %r13
  801be5:	41 5e                	pop    %r14
  801be7:	41 5f                	pop    %r15
  801be9:	5d                   	pop    %rbp
  801bea:	c3                   	ret
        if (inc < 0) return inc;
  801beb:	48 98                	cltq
  801bed:	eb ed                	jmp    801bdc <readn+0x5b>
    int inc = 1, res = 0;
  801bef:	bb 00 00 00 00       	mov    $0x0,%ebx
  801bf4:	eb e3                	jmp    801bd9 <readn+0x58>

0000000000801bf6 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  801bf6:	f3 0f 1e fa          	endbr64
  801bfa:	55                   	push   %rbp
  801bfb:	48 89 e5             	mov    %rsp,%rbp
  801bfe:	41 56                	push   %r14
  801c00:	41 55                	push   %r13
  801c02:	41 54                	push   %r12
  801c04:	53                   	push   %rbx
  801c05:	48 83 ec 10          	sub    $0x10,%rsp
  801c09:	89 fb                	mov    %edi,%ebx
  801c0b:	49 89 f4             	mov    %rsi,%r12
  801c0e:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801c11:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801c15:	48 b8 c4 17 80 00 00 	movabs $0x8017c4,%rax
  801c1c:	00 00 00 
  801c1f:	ff d0                	call   *%rax
  801c21:	85 c0                	test   %eax,%eax
  801c23:	78 47                	js     801c6c <write+0x76>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801c25:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801c29:	41 8b 3e             	mov    (%r14),%edi
  801c2c:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801c30:	48 b8 13 18 80 00 00 	movabs $0x801813,%rax
  801c37:	00 00 00 
  801c3a:	ff d0                	call   *%rax
  801c3c:	85 c0                	test   %eax,%eax
  801c3e:	78 30                	js     801c70 <write+0x7a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c40:	41 f6 46 08 03       	testb  $0x3,0x8(%r14)
  801c45:	74 2d                	je     801c74 <write+0x7e>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801c47:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801c4b:	48 8b 40 18          	mov    0x18(%rax),%rax
  801c4f:	48 85 c0             	test   %rax,%rax
  801c52:	74 56                	je     801caa <write+0xb4>

    return (*dev->dev_write)(fd, buf, n);
  801c54:	4c 89 ea             	mov    %r13,%rdx
  801c57:	4c 89 e6             	mov    %r12,%rsi
  801c5a:	4c 89 f7             	mov    %r14,%rdi
  801c5d:	ff d0                	call   *%rax
}
  801c5f:	48 83 c4 10          	add    $0x10,%rsp
  801c63:	5b                   	pop    %rbx
  801c64:	41 5c                	pop    %r12
  801c66:	41 5d                	pop    %r13
  801c68:	41 5e                	pop    %r14
  801c6a:	5d                   	pop    %rbp
  801c6b:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801c6c:	48 98                	cltq
  801c6e:	eb ef                	jmp    801c5f <write+0x69>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801c70:	48 98                	cltq
  801c72:	eb eb                	jmp    801c5f <write+0x69>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801c74:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801c7b:	00 00 00 
  801c7e:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801c84:	89 da                	mov    %ebx,%edx
  801c86:	48 bf ff 41 80 00 00 	movabs $0x8041ff,%rdi
  801c8d:	00 00 00 
  801c90:	b8 00 00 00 00       	mov    $0x0,%eax
  801c95:	48 b9 bc 02 80 00 00 	movabs $0x8002bc,%rcx
  801c9c:	00 00 00 
  801c9f:	ff d1                	call   *%rcx
        return -E_INVAL;
  801ca1:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801ca8:	eb b5                	jmp    801c5f <write+0x69>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801caa:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801cb1:	eb ac                	jmp    801c5f <write+0x69>

0000000000801cb3 <seek>:

int
seek(int fdnum, off_t offset) {
  801cb3:	f3 0f 1e fa          	endbr64
  801cb7:	55                   	push   %rbp
  801cb8:	48 89 e5             	mov    %rsp,%rbp
  801cbb:	53                   	push   %rbx
  801cbc:	48 83 ec 18          	sub    $0x18,%rsp
  801cc0:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801cc2:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801cc6:	48 b8 c4 17 80 00 00 	movabs $0x8017c4,%rax
  801ccd:	00 00 00 
  801cd0:	ff d0                	call   *%rax
  801cd2:	85 c0                	test   %eax,%eax
  801cd4:	78 0c                	js     801ce2 <seek+0x2f>

    fd->fd_offset = offset;
  801cd6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cda:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  801cdd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ce2:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801ce6:	c9                   	leave
  801ce7:	c3                   	ret

0000000000801ce8 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  801ce8:	f3 0f 1e fa          	endbr64
  801cec:	55                   	push   %rbp
  801ced:	48 89 e5             	mov    %rsp,%rbp
  801cf0:	41 55                	push   %r13
  801cf2:	41 54                	push   %r12
  801cf4:	53                   	push   %rbx
  801cf5:	48 83 ec 18          	sub    $0x18,%rsp
  801cf9:	89 fb                	mov    %edi,%ebx
  801cfb:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801cfe:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801d02:	48 b8 c4 17 80 00 00 	movabs $0x8017c4,%rax
  801d09:	00 00 00 
  801d0c:	ff d0                	call   *%rax
  801d0e:	85 c0                	test   %eax,%eax
  801d10:	78 38                	js     801d4a <ftruncate+0x62>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801d12:	4c 8b 6d d8          	mov    -0x28(%rbp),%r13
  801d16:	41 8b 7d 00          	mov    0x0(%r13),%edi
  801d1a:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801d1e:	48 b8 13 18 80 00 00 	movabs $0x801813,%rax
  801d25:	00 00 00 
  801d28:	ff d0                	call   *%rax
  801d2a:	85 c0                	test   %eax,%eax
  801d2c:	78 1c                	js     801d4a <ftruncate+0x62>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801d2e:	41 f6 45 08 03       	testb  $0x3,0x8(%r13)
  801d33:	74 20                	je     801d55 <ftruncate+0x6d>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801d35:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d39:	48 8b 40 30          	mov    0x30(%rax),%rax
  801d3d:	48 85 c0             	test   %rax,%rax
  801d40:	74 47                	je     801d89 <ftruncate+0xa1>

    return (*dev->dev_trunc)(fd, newsize);
  801d42:	44 89 e6             	mov    %r12d,%esi
  801d45:	4c 89 ef             	mov    %r13,%rdi
  801d48:	ff d0                	call   *%rax
}
  801d4a:	48 83 c4 18          	add    $0x18,%rsp
  801d4e:	5b                   	pop    %rbx
  801d4f:	41 5c                	pop    %r12
  801d51:	41 5d                	pop    %r13
  801d53:	5d                   	pop    %rbp
  801d54:	c3                   	ret
                thisenv->env_id, fdnum);
  801d55:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801d5c:	00 00 00 
  801d5f:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801d65:	89 da                	mov    %ebx,%edx
  801d67:	48 bf a0 46 80 00 00 	movabs $0x8046a0,%rdi
  801d6e:	00 00 00 
  801d71:	b8 00 00 00 00       	mov    $0x0,%eax
  801d76:	48 b9 bc 02 80 00 00 	movabs $0x8002bc,%rcx
  801d7d:	00 00 00 
  801d80:	ff d1                	call   *%rcx
        return -E_INVAL;
  801d82:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d87:	eb c1                	jmp    801d4a <ftruncate+0x62>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801d89:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801d8e:	eb ba                	jmp    801d4a <ftruncate+0x62>

0000000000801d90 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  801d90:	f3 0f 1e fa          	endbr64
  801d94:	55                   	push   %rbp
  801d95:	48 89 e5             	mov    %rsp,%rbp
  801d98:	41 54                	push   %r12
  801d9a:	53                   	push   %rbx
  801d9b:	48 83 ec 10          	sub    $0x10,%rsp
  801d9f:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801da2:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801da6:	48 b8 c4 17 80 00 00 	movabs $0x8017c4,%rax
  801dad:	00 00 00 
  801db0:	ff d0                	call   *%rax
  801db2:	85 c0                	test   %eax,%eax
  801db4:	78 4e                	js     801e04 <fstat+0x74>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801db6:	4c 8b 65 e8          	mov    -0x18(%rbp),%r12
  801dba:	41 8b 3c 24          	mov    (%r12),%edi
  801dbe:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801dc2:	48 b8 13 18 80 00 00 	movabs $0x801813,%rax
  801dc9:	00 00 00 
  801dcc:	ff d0                	call   *%rax
  801dce:	85 c0                	test   %eax,%eax
  801dd0:	78 32                	js     801e04 <fstat+0x74>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  801dd2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801dd6:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  801ddb:	74 30                	je     801e0d <fstat+0x7d>

    stat->st_name[0] = 0;
  801ddd:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  801de0:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  801de7:	00 00 00 
    stat->st_isdir = 0;
  801dea:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801df1:	00 00 00 
    stat->st_dev = dev;
  801df4:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  801dfb:	48 89 de             	mov    %rbx,%rsi
  801dfe:	4c 89 e7             	mov    %r12,%rdi
  801e01:	ff 50 28             	call   *0x28(%rax)
}
  801e04:	48 83 c4 10          	add    $0x10,%rsp
  801e08:	5b                   	pop    %rbx
  801e09:	41 5c                	pop    %r12
  801e0b:	5d                   	pop    %rbp
  801e0c:	c3                   	ret
    if (!dev->dev_stat) return -E_NOT_SUPP;
  801e0d:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801e12:	eb f0                	jmp    801e04 <fstat+0x74>

0000000000801e14 <stat>:

int
stat(const char *path, struct Stat *stat) {
  801e14:	f3 0f 1e fa          	endbr64
  801e18:	55                   	push   %rbp
  801e19:	48 89 e5             	mov    %rsp,%rbp
  801e1c:	41 54                	push   %r12
  801e1e:	53                   	push   %rbx
  801e1f:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  801e22:	be 00 00 00 00       	mov    $0x0,%esi
  801e27:	48 b8 f5 20 80 00 00 	movabs $0x8020f5,%rax
  801e2e:	00 00 00 
  801e31:	ff d0                	call   *%rax
  801e33:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  801e35:	85 c0                	test   %eax,%eax
  801e37:	78 25                	js     801e5e <stat+0x4a>

    int res = fstat(fd, stat);
  801e39:	4c 89 e6             	mov    %r12,%rsi
  801e3c:	89 c7                	mov    %eax,%edi
  801e3e:	48 b8 90 1d 80 00 00 	movabs $0x801d90,%rax
  801e45:	00 00 00 
  801e48:	ff d0                	call   *%rax
  801e4a:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  801e4d:	89 df                	mov    %ebx,%edi
  801e4f:	48 b8 35 19 80 00 00 	movabs $0x801935,%rax
  801e56:	00 00 00 
  801e59:	ff d0                	call   *%rax

    return res;
  801e5b:	44 89 e3             	mov    %r12d,%ebx
}
  801e5e:	89 d8                	mov    %ebx,%eax
  801e60:	5b                   	pop    %rbx
  801e61:	41 5c                	pop    %r12
  801e63:	5d                   	pop    %rbp
  801e64:	c3                   	ret

0000000000801e65 <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  801e65:	f3 0f 1e fa          	endbr64
  801e69:	55                   	push   %rbp
  801e6a:	48 89 e5             	mov    %rsp,%rbp
  801e6d:	41 54                	push   %r12
  801e6f:	53                   	push   %rbx
  801e70:	48 83 ec 10          	sub    $0x10,%rsp
  801e74:	41 89 fc             	mov    %edi,%r12d
  801e77:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801e7a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801e81:	00 00 00 
  801e84:	83 38 00             	cmpl   $0x0,(%rax)
  801e87:	74 6e                	je     801ef7 <fsipc+0x92>

    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }
    fsenv = ipc_find_env(ENV_TYPE_FS);
  801e89:	bf 03 00 00 00       	mov    $0x3,%edi
  801e8e:	48 b8 19 2f 80 00 00 	movabs $0x802f19,%rax
  801e95:	00 00 00 
  801e98:	ff d0                	call   *%rax
  801e9a:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  801ea1:	00 00 
    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  801ea3:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  801ea9:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801eae:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  801eb5:	00 00 00 
  801eb8:	44 89 e6             	mov    %r12d,%esi
  801ebb:	89 c7                	mov    %eax,%edi
  801ebd:	48 b8 57 2e 80 00 00 	movabs $0x802e57,%rax
  801ec4:	00 00 00 
  801ec7:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  801ec9:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  801ed0:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  801ed1:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ed6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801eda:	48 89 de             	mov    %rbx,%rsi
  801edd:	bf 00 00 00 00       	mov    $0x0,%edi
  801ee2:	48 b8 be 2d 80 00 00 	movabs $0x802dbe,%rax
  801ee9:	00 00 00 
  801eec:	ff d0                	call   *%rax
}
  801eee:	48 83 c4 10          	add    $0x10,%rsp
  801ef2:	5b                   	pop    %rbx
  801ef3:	41 5c                	pop    %r12
  801ef5:	5d                   	pop    %rbp
  801ef6:	c3                   	ret
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801ef7:	bf 03 00 00 00       	mov    $0x3,%edi
  801efc:	48 b8 19 2f 80 00 00 	movabs $0x802f19,%rax
  801f03:	00 00 00 
  801f06:	ff d0                	call   *%rax
  801f08:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  801f0f:	00 00 
  801f11:	e9 73 ff ff ff       	jmp    801e89 <fsipc+0x24>

0000000000801f16 <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  801f16:	f3 0f 1e fa          	endbr64
  801f1a:	55                   	push   %rbp
  801f1b:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801f1e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801f25:	00 00 00 
  801f28:	8b 57 0c             	mov    0xc(%rdi),%edx
  801f2b:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  801f2d:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  801f30:	be 00 00 00 00       	mov    $0x0,%esi
  801f35:	bf 02 00 00 00       	mov    $0x2,%edi
  801f3a:	48 b8 65 1e 80 00 00 	movabs $0x801e65,%rax
  801f41:	00 00 00 
  801f44:	ff d0                	call   *%rax
}
  801f46:	5d                   	pop    %rbp
  801f47:	c3                   	ret

0000000000801f48 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  801f48:	f3 0f 1e fa          	endbr64
  801f4c:	55                   	push   %rbp
  801f4d:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801f50:	8b 47 0c             	mov    0xc(%rdi),%eax
  801f53:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  801f5a:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  801f5c:	be 00 00 00 00       	mov    $0x0,%esi
  801f61:	bf 06 00 00 00       	mov    $0x6,%edi
  801f66:	48 b8 65 1e 80 00 00 	movabs $0x801e65,%rax
  801f6d:	00 00 00 
  801f70:	ff d0                	call   *%rax
}
  801f72:	5d                   	pop    %rbp
  801f73:	c3                   	ret

0000000000801f74 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  801f74:	f3 0f 1e fa          	endbr64
  801f78:	55                   	push   %rbp
  801f79:	48 89 e5             	mov    %rsp,%rbp
  801f7c:	41 54                	push   %r12
  801f7e:	53                   	push   %rbx
  801f7f:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801f82:	8b 47 0c             	mov    0xc(%rdi),%eax
  801f85:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  801f8c:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  801f8e:	be 00 00 00 00       	mov    $0x0,%esi
  801f93:	bf 05 00 00 00       	mov    $0x5,%edi
  801f98:	48 b8 65 1e 80 00 00 	movabs $0x801e65,%rax
  801f9f:	00 00 00 
  801fa2:	ff d0                	call   *%rax
    if (res < 0) return res;
  801fa4:	85 c0                	test   %eax,%eax
  801fa6:	78 3d                	js     801fe5 <devfile_stat+0x71>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801fa8:	49 bc 00 70 80 00 00 	movabs $0x807000,%r12
  801faf:	00 00 00 
  801fb2:	4c 89 e6             	mov    %r12,%rsi
  801fb5:	48 89 df             	mov    %rbx,%rdi
  801fb8:	48 b8 05 0c 80 00 00 	movabs $0x800c05,%rax
  801fbf:	00 00 00 
  801fc2:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  801fc4:	41 8b 84 24 80 00 00 	mov    0x80(%r12),%eax
  801fcb:	00 
  801fcc:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801fd2:	41 8b 84 24 84 00 00 	mov    0x84(%r12),%eax
  801fd9:	00 
  801fda:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  801fe0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fe5:	5b                   	pop    %rbx
  801fe6:	41 5c                	pop    %r12
  801fe8:	5d                   	pop    %rbp
  801fe9:	c3                   	ret

0000000000801fea <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  801fea:	f3 0f 1e fa          	endbr64
    if (n >= sizeof(fsipcbuf.write.req_buf)) {
  801fee:	48 81 fa ef 0f 00 00 	cmp    $0xfef,%rdx
  801ff5:	77 41                	ja     802038 <devfile_write+0x4e>
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  801ff7:	55                   	push   %rbp
  801ff8:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  801ffb:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802002:	00 00 00 
  802005:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  802008:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.write.req_n = n;
  80200a:	48 89 50 08          	mov    %rdx,0x8(%rax)
    memmove(fsipcbuf.write.req_buf, buf, n);
  80200e:	48 8d 78 10          	lea    0x10(%rax),%rdi
  802012:	48 b8 20 0e 80 00 00 	movabs $0x800e20,%rax
  802019:	00 00 00 
  80201c:	ff d0                	call   *%rax
    res = fsipc(FSREQ_WRITE, NULL);
  80201e:	be 00 00 00 00       	mov    $0x0,%esi
  802023:	bf 04 00 00 00       	mov    $0x4,%edi
  802028:	48 b8 65 1e 80 00 00 	movabs $0x801e65,%rax
  80202f:	00 00 00 
  802032:	ff d0                	call   *%rax
  802034:	48 98                	cltq
}
  802036:	5d                   	pop    %rbp
  802037:	c3                   	ret
        return -E_INVAL;
  802038:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
}
  80203f:	c3                   	ret

0000000000802040 <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  802040:	f3 0f 1e fa          	endbr64
  802044:	55                   	push   %rbp
  802045:	48 89 e5             	mov    %rsp,%rbp
  802048:	41 55                	push   %r13
  80204a:	41 54                	push   %r12
  80204c:	53                   	push   %rbx
  80204d:	48 83 ec 08          	sub    $0x8,%rsp
  802051:	49 89 f4             	mov    %rsi,%r12
  802054:	48 89 d3             	mov    %rdx,%rbx
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  802057:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80205e:	00 00 00 
  802061:	8b 57 0c             	mov    0xc(%rdi),%edx
  802064:	89 10                	mov    %edx,(%rax)
    fsipcbuf.read.req_n = n;
  802066:	48 89 58 08          	mov    %rbx,0x8(%rax)
    res = fsipc(FSREQ_READ, NULL);
  80206a:	be 00 00 00 00       	mov    $0x0,%esi
  80206f:	bf 03 00 00 00       	mov    $0x3,%edi
  802074:	48 b8 65 1e 80 00 00 	movabs $0x801e65,%rax
  80207b:	00 00 00 
  80207e:	ff d0                	call   *%rax
  802080:	4c 63 e8             	movslq %eax,%r13
    if (res < 0) {
  802083:	4d 85 ed             	test   %r13,%r13
  802086:	78 2a                	js     8020b2 <devfile_read+0x72>
    assert(res <= n && res <= PAGE_SIZE);
  802088:	4c 89 ea             	mov    %r13,%rdx
  80208b:	4c 39 eb             	cmp    %r13,%rbx
  80208e:	72 30                	jb     8020c0 <devfile_read+0x80>
  802090:	49 81 fd 00 10 00 00 	cmp    $0x1000,%r13
  802097:	7f 27                	jg     8020c0 <devfile_read+0x80>
    memmove(buf, &fsipcbuf, res);
  802099:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  8020a0:	00 00 00 
  8020a3:	4c 89 e7             	mov    %r12,%rdi
  8020a6:	48 b8 20 0e 80 00 00 	movabs $0x800e20,%rax
  8020ad:	00 00 00 
  8020b0:	ff d0                	call   *%rax
}
  8020b2:	4c 89 e8             	mov    %r13,%rax
  8020b5:	48 83 c4 08          	add    $0x8,%rsp
  8020b9:	5b                   	pop    %rbx
  8020ba:	41 5c                	pop    %r12
  8020bc:	41 5d                	pop    %r13
  8020be:	5d                   	pop    %rbp
  8020bf:	c3                   	ret
    assert(res <= n && res <= PAGE_SIZE);
  8020c0:	48 b9 1c 42 80 00 00 	movabs $0x80421c,%rcx
  8020c7:	00 00 00 
  8020ca:	48 ba 39 42 80 00 00 	movabs $0x804239,%rdx
  8020d1:	00 00 00 
  8020d4:	be 7b 00 00 00       	mov    $0x7b,%esi
  8020d9:	48 bf 4e 42 80 00 00 	movabs $0x80424e,%rdi
  8020e0:	00 00 00 
  8020e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8020e8:	49 b8 91 2c 80 00 00 	movabs $0x802c91,%r8
  8020ef:	00 00 00 
  8020f2:	41 ff d0             	call   *%r8

00000000008020f5 <open>:
open(const char *path, int mode) {
  8020f5:	f3 0f 1e fa          	endbr64
  8020f9:	55                   	push   %rbp
  8020fa:	48 89 e5             	mov    %rsp,%rbp
  8020fd:	41 55                	push   %r13
  8020ff:	41 54                	push   %r12
  802101:	53                   	push   %rbx
  802102:	48 83 ec 18          	sub    $0x18,%rsp
  802106:	49 89 fc             	mov    %rdi,%r12
  802109:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  80210c:	48 b8 c0 0b 80 00 00 	movabs $0x800bc0,%rax
  802113:	00 00 00 
  802116:	ff d0                	call   *%rax
  802118:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  80211e:	0f 87 8a 00 00 00    	ja     8021ae <open+0xb9>
    if ((res = fd_alloc(&fd)) < 0) return res;
  802124:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802128:	48 b8 60 17 80 00 00 	movabs $0x801760,%rax
  80212f:	00 00 00 
  802132:	ff d0                	call   *%rax
  802134:	89 c3                	mov    %eax,%ebx
  802136:	85 c0                	test   %eax,%eax
  802138:	78 50                	js     80218a <open+0x95>
    strcpy(fsipcbuf.open.req_path, path);
  80213a:	4c 89 e6             	mov    %r12,%rsi
  80213d:	48 bb 00 70 80 00 00 	movabs $0x807000,%rbx
  802144:	00 00 00 
  802147:	48 89 df             	mov    %rbx,%rdi
  80214a:	48 b8 05 0c 80 00 00 	movabs $0x800c05,%rax
  802151:	00 00 00 
  802154:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  802156:	44 89 ab 00 04 00 00 	mov    %r13d,0x400(%rbx)
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  80215d:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802161:	bf 01 00 00 00       	mov    $0x1,%edi
  802166:	48 b8 65 1e 80 00 00 	movabs $0x801e65,%rax
  80216d:	00 00 00 
  802170:	ff d0                	call   *%rax
  802172:	89 c3                	mov    %eax,%ebx
  802174:	85 c0                	test   %eax,%eax
  802176:	78 1f                	js     802197 <open+0xa2>
    return fd2num(fd);
  802178:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80217c:	48 b8 2a 17 80 00 00 	movabs $0x80172a,%rax
  802183:	00 00 00 
  802186:	ff d0                	call   *%rax
  802188:	89 c3                	mov    %eax,%ebx
}
  80218a:	89 d8                	mov    %ebx,%eax
  80218c:	48 83 c4 18          	add    $0x18,%rsp
  802190:	5b                   	pop    %rbx
  802191:	41 5c                	pop    %r12
  802193:	41 5d                	pop    %r13
  802195:	5d                   	pop    %rbp
  802196:	c3                   	ret
        fd_close(fd, 0);
  802197:	be 00 00 00 00       	mov    $0x0,%esi
  80219c:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8021a0:	48 b8 87 18 80 00 00 	movabs $0x801887,%rax
  8021a7:	00 00 00 
  8021aa:	ff d0                	call   *%rax
        return res;
  8021ac:	eb dc                	jmp    80218a <open+0x95>
        return -E_BAD_PATH;
  8021ae:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  8021b3:	eb d5                	jmp    80218a <open+0x95>

00000000008021b5 <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  8021b5:	f3 0f 1e fa          	endbr64
  8021b9:	55                   	push   %rbp
  8021ba:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  8021bd:	be 00 00 00 00       	mov    $0x0,%esi
  8021c2:	bf 08 00 00 00       	mov    $0x8,%edi
  8021c7:	48 b8 65 1e 80 00 00 	movabs $0x801e65,%rax
  8021ce:	00 00 00 
  8021d1:	ff d0                	call   *%rax
}
  8021d3:	5d                   	pop    %rbp
  8021d4:	c3                   	ret

00000000008021d5 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  8021d5:	f3 0f 1e fa          	endbr64
  8021d9:	55                   	push   %rbp
  8021da:	48 89 e5             	mov    %rsp,%rbp
  8021dd:	41 54                	push   %r12
  8021df:	53                   	push   %rbx
  8021e0:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8021e3:	48 b8 40 17 80 00 00 	movabs $0x801740,%rax
  8021ea:	00 00 00 
  8021ed:	ff d0                	call   *%rax
  8021ef:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  8021f2:	48 be 59 42 80 00 00 	movabs $0x804259,%rsi
  8021f9:	00 00 00 
  8021fc:	48 89 df             	mov    %rbx,%rdi
  8021ff:	48 b8 05 0c 80 00 00 	movabs $0x800c05,%rax
  802206:	00 00 00 
  802209:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  80220b:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  802210:	41 2b 04 24          	sub    (%r12),%eax
  802214:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  80221a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  802221:	00 00 00 
    stat->st_dev = &devpipe;
  802224:	48 b8 60 50 80 00 00 	movabs $0x805060,%rax
  80222b:	00 00 00 
  80222e:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  802235:	b8 00 00 00 00       	mov    $0x0,%eax
  80223a:	5b                   	pop    %rbx
  80223b:	41 5c                	pop    %r12
  80223d:	5d                   	pop    %rbp
  80223e:	c3                   	ret

000000000080223f <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  80223f:	f3 0f 1e fa          	endbr64
  802243:	55                   	push   %rbp
  802244:	48 89 e5             	mov    %rsp,%rbp
  802247:	41 54                	push   %r12
  802249:	53                   	push   %rbx
  80224a:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  80224d:	ba 00 10 00 00       	mov    $0x1000,%edx
  802252:	48 89 fe             	mov    %rdi,%rsi
  802255:	bf 00 00 00 00       	mov    $0x0,%edi
  80225a:	49 bc 4a 13 80 00 00 	movabs $0x80134a,%r12
  802261:	00 00 00 
  802264:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  802267:	48 89 df             	mov    %rbx,%rdi
  80226a:	48 b8 40 17 80 00 00 	movabs $0x801740,%rax
  802271:	00 00 00 
  802274:	ff d0                	call   *%rax
  802276:	48 89 c6             	mov    %rax,%rsi
  802279:	ba 00 10 00 00       	mov    $0x1000,%edx
  80227e:	bf 00 00 00 00       	mov    $0x0,%edi
  802283:	41 ff d4             	call   *%r12
}
  802286:	5b                   	pop    %rbx
  802287:	41 5c                	pop    %r12
  802289:	5d                   	pop    %rbp
  80228a:	c3                   	ret

000000000080228b <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  80228b:	f3 0f 1e fa          	endbr64
  80228f:	55                   	push   %rbp
  802290:	48 89 e5             	mov    %rsp,%rbp
  802293:	41 57                	push   %r15
  802295:	41 56                	push   %r14
  802297:	41 55                	push   %r13
  802299:	41 54                	push   %r12
  80229b:	53                   	push   %rbx
  80229c:	48 83 ec 18          	sub    $0x18,%rsp
  8022a0:	49 89 fc             	mov    %rdi,%r12
  8022a3:	49 89 f5             	mov    %rsi,%r13
  8022a6:	49 89 d7             	mov    %rdx,%r15
  8022a9:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8022ad:	48 b8 40 17 80 00 00 	movabs $0x801740,%rax
  8022b4:	00 00 00 
  8022b7:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  8022b9:	4d 85 ff             	test   %r15,%r15
  8022bc:	0f 84 af 00 00 00    	je     802371 <devpipe_write+0xe6>
  8022c2:	48 89 c3             	mov    %rax,%rbx
  8022c5:	4c 89 f8             	mov    %r15,%rax
  8022c8:	4d 89 ef             	mov    %r13,%r15
  8022cb:	4c 01 e8             	add    %r13,%rax
  8022ce:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8022d2:	49 bd da 11 80 00 00 	movabs $0x8011da,%r13
  8022d9:	00 00 00 
            sys_yield();
  8022dc:	49 be 6f 11 80 00 00 	movabs $0x80116f,%r14
  8022e3:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8022e6:	8b 73 04             	mov    0x4(%rbx),%esi
  8022e9:	48 63 ce             	movslq %esi,%rcx
  8022ec:	48 63 03             	movslq (%rbx),%rax
  8022ef:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8022f5:	48 39 c1             	cmp    %rax,%rcx
  8022f8:	72 2e                	jb     802328 <devpipe_write+0x9d>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8022fa:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8022ff:	48 89 da             	mov    %rbx,%rdx
  802302:	be 00 10 00 00       	mov    $0x1000,%esi
  802307:	4c 89 e7             	mov    %r12,%rdi
  80230a:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  80230d:	85 c0                	test   %eax,%eax
  80230f:	74 66                	je     802377 <devpipe_write+0xec>
            sys_yield();
  802311:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  802314:	8b 73 04             	mov    0x4(%rbx),%esi
  802317:	48 63 ce             	movslq %esi,%rcx
  80231a:	48 63 03             	movslq (%rbx),%rax
  80231d:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  802323:	48 39 c1             	cmp    %rax,%rcx
  802326:	73 d2                	jae    8022fa <devpipe_write+0x6f>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802328:	41 0f b6 3f          	movzbl (%r15),%edi
  80232c:	48 89 ca             	mov    %rcx,%rdx
  80232f:	48 c1 ea 03          	shr    $0x3,%rdx
  802333:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  80233a:	08 10 20 
  80233d:	48 f7 e2             	mul    %rdx
  802340:	48 c1 ea 06          	shr    $0x6,%rdx
  802344:	48 89 d0             	mov    %rdx,%rax
  802347:	48 c1 e0 09          	shl    $0x9,%rax
  80234b:	48 29 d0             	sub    %rdx,%rax
  80234e:	48 c1 e0 03          	shl    $0x3,%rax
  802352:	48 29 c1             	sub    %rax,%rcx
  802355:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  80235a:	83 c6 01             	add    $0x1,%esi
  80235d:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  802360:	49 83 c7 01          	add    $0x1,%r15
  802364:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802368:	49 39 c7             	cmp    %rax,%r15
  80236b:	0f 85 75 ff ff ff    	jne    8022e6 <devpipe_write+0x5b>
    return n;
  802371:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802375:	eb 05                	jmp    80237c <devpipe_write+0xf1>
            if (_pipeisclosed(fd, p)) return 0;
  802377:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80237c:	48 83 c4 18          	add    $0x18,%rsp
  802380:	5b                   	pop    %rbx
  802381:	41 5c                	pop    %r12
  802383:	41 5d                	pop    %r13
  802385:	41 5e                	pop    %r14
  802387:	41 5f                	pop    %r15
  802389:	5d                   	pop    %rbp
  80238a:	c3                   	ret

000000000080238b <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  80238b:	f3 0f 1e fa          	endbr64
  80238f:	55                   	push   %rbp
  802390:	48 89 e5             	mov    %rsp,%rbp
  802393:	41 57                	push   %r15
  802395:	41 56                	push   %r14
  802397:	41 55                	push   %r13
  802399:	41 54                	push   %r12
  80239b:	53                   	push   %rbx
  80239c:	48 83 ec 18          	sub    $0x18,%rsp
  8023a0:	49 89 fc             	mov    %rdi,%r12
  8023a3:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  8023a7:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8023ab:	48 b8 40 17 80 00 00 	movabs $0x801740,%rax
  8023b2:	00 00 00 
  8023b5:	ff d0                	call   *%rax
  8023b7:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  8023ba:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8023c0:	49 bd da 11 80 00 00 	movabs $0x8011da,%r13
  8023c7:	00 00 00 
            sys_yield();
  8023ca:	49 be 6f 11 80 00 00 	movabs $0x80116f,%r14
  8023d1:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  8023d4:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8023d9:	74 7d                	je     802458 <devpipe_read+0xcd>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8023db:	8b 03                	mov    (%rbx),%eax
  8023dd:	3b 43 04             	cmp    0x4(%rbx),%eax
  8023e0:	75 26                	jne    802408 <devpipe_read+0x7d>
            if (i > 0) return i;
  8023e2:	4d 85 ff             	test   %r15,%r15
  8023e5:	75 77                	jne    80245e <devpipe_read+0xd3>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8023e7:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8023ec:	48 89 da             	mov    %rbx,%rdx
  8023ef:	be 00 10 00 00       	mov    $0x1000,%esi
  8023f4:	4c 89 e7             	mov    %r12,%rdi
  8023f7:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8023fa:	85 c0                	test   %eax,%eax
  8023fc:	74 72                	je     802470 <devpipe_read+0xe5>
            sys_yield();
  8023fe:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802401:	8b 03                	mov    (%rbx),%eax
  802403:	3b 43 04             	cmp    0x4(%rbx),%eax
  802406:	74 df                	je     8023e7 <devpipe_read+0x5c>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802408:	48 63 c8             	movslq %eax,%rcx
  80240b:	48 89 ca             	mov    %rcx,%rdx
  80240e:	48 c1 ea 03          	shr    $0x3,%rdx
  802412:	48 be 81 00 01 02 04 	movabs $0x2010080402010081,%rsi
  802419:	08 10 20 
  80241c:	48 89 d0             	mov    %rdx,%rax
  80241f:	48 f7 e6             	mul    %rsi
  802422:	48 c1 ea 06          	shr    $0x6,%rdx
  802426:	48 89 d0             	mov    %rdx,%rax
  802429:	48 c1 e0 09          	shl    $0x9,%rax
  80242d:	48 29 d0             	sub    %rdx,%rax
  802430:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802437:	00 
  802438:	48 89 c8             	mov    %rcx,%rax
  80243b:	48 29 d0             	sub    %rdx,%rax
  80243e:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  802443:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  802447:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  80244b:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  80244e:	49 83 c7 01          	add    $0x1,%r15
  802452:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  802456:	75 83                	jne    8023db <devpipe_read+0x50>
    return n;
  802458:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80245c:	eb 03                	jmp    802461 <devpipe_read+0xd6>
            if (i > 0) return i;
  80245e:	4c 89 f8             	mov    %r15,%rax
}
  802461:	48 83 c4 18          	add    $0x18,%rsp
  802465:	5b                   	pop    %rbx
  802466:	41 5c                	pop    %r12
  802468:	41 5d                	pop    %r13
  80246a:	41 5e                	pop    %r14
  80246c:	41 5f                	pop    %r15
  80246e:	5d                   	pop    %rbp
  80246f:	c3                   	ret
            if (_pipeisclosed(fd, p)) return 0;
  802470:	b8 00 00 00 00       	mov    $0x0,%eax
  802475:	eb ea                	jmp    802461 <devpipe_read+0xd6>

0000000000802477 <pipe>:
pipe(int pfd[2]) {
  802477:	f3 0f 1e fa          	endbr64
  80247b:	55                   	push   %rbp
  80247c:	48 89 e5             	mov    %rsp,%rbp
  80247f:	41 55                	push   %r13
  802481:	41 54                	push   %r12
  802483:	53                   	push   %rbx
  802484:	48 83 ec 18          	sub    $0x18,%rsp
  802488:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  80248b:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  80248f:	48 b8 60 17 80 00 00 	movabs $0x801760,%rax
  802496:	00 00 00 
  802499:	ff d0                	call   *%rax
  80249b:	89 c3                	mov    %eax,%ebx
  80249d:	85 c0                	test   %eax,%eax
  80249f:	0f 88 a0 01 00 00    	js     802645 <pipe+0x1ce>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  8024a5:	b9 46 00 00 00       	mov    $0x46,%ecx
  8024aa:	ba 00 10 00 00       	mov    $0x1000,%edx
  8024af:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8024b3:	bf 00 00 00 00       	mov    $0x0,%edi
  8024b8:	48 b8 0a 12 80 00 00 	movabs $0x80120a,%rax
  8024bf:	00 00 00 
  8024c2:	ff d0                	call   *%rax
  8024c4:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  8024c6:	85 c0                	test   %eax,%eax
  8024c8:	0f 88 77 01 00 00    	js     802645 <pipe+0x1ce>
    if ((res = fd_alloc(&fd1)) < 0 ||
  8024ce:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  8024d2:	48 b8 60 17 80 00 00 	movabs $0x801760,%rax
  8024d9:	00 00 00 
  8024dc:	ff d0                	call   *%rax
  8024de:	89 c3                	mov    %eax,%ebx
  8024e0:	85 c0                	test   %eax,%eax
  8024e2:	0f 88 43 01 00 00    	js     80262b <pipe+0x1b4>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  8024e8:	b9 46 00 00 00       	mov    $0x46,%ecx
  8024ed:	ba 00 10 00 00       	mov    $0x1000,%edx
  8024f2:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8024f6:	bf 00 00 00 00       	mov    $0x0,%edi
  8024fb:	48 b8 0a 12 80 00 00 	movabs $0x80120a,%rax
  802502:	00 00 00 
  802505:	ff d0                	call   *%rax
  802507:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  802509:	85 c0                	test   %eax,%eax
  80250b:	0f 88 1a 01 00 00    	js     80262b <pipe+0x1b4>
    va = fd2data(fd0);
  802511:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802515:	48 b8 40 17 80 00 00 	movabs $0x801740,%rax
  80251c:	00 00 00 
  80251f:	ff d0                	call   *%rax
  802521:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  802524:	b9 46 00 00 00       	mov    $0x46,%ecx
  802529:	ba 00 10 00 00       	mov    $0x1000,%edx
  80252e:	48 89 c6             	mov    %rax,%rsi
  802531:	bf 00 00 00 00       	mov    $0x0,%edi
  802536:	48 b8 0a 12 80 00 00 	movabs $0x80120a,%rax
  80253d:	00 00 00 
  802540:	ff d0                	call   *%rax
  802542:	89 c3                	mov    %eax,%ebx
  802544:	85 c0                	test   %eax,%eax
  802546:	0f 88 c5 00 00 00    	js     802611 <pipe+0x19a>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  80254c:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802550:	48 b8 40 17 80 00 00 	movabs $0x801740,%rax
  802557:	00 00 00 
  80255a:	ff d0                	call   *%rax
  80255c:	48 89 c1             	mov    %rax,%rcx
  80255f:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  802565:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  80256b:	ba 00 00 00 00       	mov    $0x0,%edx
  802570:	4c 89 ee             	mov    %r13,%rsi
  802573:	bf 00 00 00 00       	mov    $0x0,%edi
  802578:	48 b8 75 12 80 00 00 	movabs $0x801275,%rax
  80257f:	00 00 00 
  802582:	ff d0                	call   *%rax
  802584:	89 c3                	mov    %eax,%ebx
  802586:	85 c0                	test   %eax,%eax
  802588:	78 6e                	js     8025f8 <pipe+0x181>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  80258a:	be 00 10 00 00       	mov    $0x1000,%esi
  80258f:	4c 89 ef             	mov    %r13,%rdi
  802592:	48 b8 a4 11 80 00 00 	movabs $0x8011a4,%rax
  802599:	00 00 00 
  80259c:	ff d0                	call   *%rax
  80259e:	83 f8 02             	cmp    $0x2,%eax
  8025a1:	0f 85 ab 00 00 00    	jne    802652 <pipe+0x1db>
    fd0->fd_dev_id = devpipe.dev_id;
  8025a7:	a1 60 50 80 00 00 00 	movabs 0x805060,%eax
  8025ae:	00 00 
  8025b0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8025b4:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  8025b6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8025ba:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  8025c1:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8025c5:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  8025c7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025cb:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  8025d2:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8025d6:	48 bb 2a 17 80 00 00 	movabs $0x80172a,%rbx
  8025dd:	00 00 00 
  8025e0:	ff d3                	call   *%rbx
  8025e2:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  8025e6:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8025ea:	ff d3                	call   *%rbx
  8025ec:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  8025f1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8025f6:	eb 4d                	jmp    802645 <pipe+0x1ce>
    sys_unmap_region(0, va, PAGE_SIZE);
  8025f8:	ba 00 10 00 00       	mov    $0x1000,%edx
  8025fd:	4c 89 ee             	mov    %r13,%rsi
  802600:	bf 00 00 00 00       	mov    $0x0,%edi
  802605:	48 b8 4a 13 80 00 00 	movabs $0x80134a,%rax
  80260c:	00 00 00 
  80260f:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  802611:	ba 00 10 00 00       	mov    $0x1000,%edx
  802616:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80261a:	bf 00 00 00 00       	mov    $0x0,%edi
  80261f:	48 b8 4a 13 80 00 00 	movabs $0x80134a,%rax
  802626:	00 00 00 
  802629:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  80262b:	ba 00 10 00 00       	mov    $0x1000,%edx
  802630:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802634:	bf 00 00 00 00       	mov    $0x0,%edi
  802639:	48 b8 4a 13 80 00 00 	movabs $0x80134a,%rax
  802640:	00 00 00 
  802643:	ff d0                	call   *%rax
}
  802645:	89 d8                	mov    %ebx,%eax
  802647:	48 83 c4 18          	add    $0x18,%rsp
  80264b:	5b                   	pop    %rbx
  80264c:	41 5c                	pop    %r12
  80264e:	41 5d                	pop    %r13
  802650:	5d                   	pop    %rbp
  802651:	c3                   	ret
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802652:	48 b9 c8 46 80 00 00 	movabs $0x8046c8,%rcx
  802659:	00 00 00 
  80265c:	48 ba 39 42 80 00 00 	movabs $0x804239,%rdx
  802663:	00 00 00 
  802666:	be 2e 00 00 00       	mov    $0x2e,%esi
  80266b:	48 bf 60 42 80 00 00 	movabs $0x804260,%rdi
  802672:	00 00 00 
  802675:	b8 00 00 00 00       	mov    $0x0,%eax
  80267a:	49 b8 91 2c 80 00 00 	movabs $0x802c91,%r8
  802681:	00 00 00 
  802684:	41 ff d0             	call   *%r8

0000000000802687 <pipeisclosed>:
pipeisclosed(int fdnum) {
  802687:	f3 0f 1e fa          	endbr64
  80268b:	55                   	push   %rbp
  80268c:	48 89 e5             	mov    %rsp,%rbp
  80268f:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802693:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802697:	48 b8 c4 17 80 00 00 	movabs $0x8017c4,%rax
  80269e:	00 00 00 
  8026a1:	ff d0                	call   *%rax
    if (res < 0) return res;
  8026a3:	85 c0                	test   %eax,%eax
  8026a5:	78 35                	js     8026dc <pipeisclosed+0x55>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  8026a7:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8026ab:	48 b8 40 17 80 00 00 	movabs $0x801740,%rax
  8026b2:	00 00 00 
  8026b5:	ff d0                	call   *%rax
  8026b7:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8026ba:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8026bf:	be 00 10 00 00       	mov    $0x1000,%esi
  8026c4:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8026c8:	48 b8 da 11 80 00 00 	movabs $0x8011da,%rax
  8026cf:	00 00 00 
  8026d2:	ff d0                	call   *%rax
  8026d4:	85 c0                	test   %eax,%eax
  8026d6:	0f 94 c0             	sete   %al
  8026d9:	0f b6 c0             	movzbl %al,%eax
}
  8026dc:	c9                   	leave
  8026dd:	c3                   	ret

00000000008026de <get_uvpt_entry>:
extern volatile pde_t uvpd[];     /* VA of current page directory */
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
  8026de:	f3 0f 1e fa          	endbr64
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8026e2:	48 89 f8             	mov    %rdi,%rax
  8026e5:	48 c1 e8 27          	shr    $0x27,%rax
  8026e9:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  8026f0:	7f 00 00 
  8026f3:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8026f7:	f6 c2 01             	test   $0x1,%dl
  8026fa:	74 6d                	je     802769 <get_uvpt_entry+0x8b>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8026fc:	48 89 f8             	mov    %rdi,%rax
  8026ff:	48 c1 e8 1e          	shr    $0x1e,%rax
  802703:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  80270a:	7f 00 00 
  80270d:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802711:	f6 c2 01             	test   $0x1,%dl
  802714:	74 62                	je     802778 <get_uvpt_entry+0x9a>
  802716:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  80271d:	7f 00 00 
  802720:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802724:	f6 c2 80             	test   $0x80,%dl
  802727:	75 4f                	jne    802778 <get_uvpt_entry+0x9a>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802729:	48 89 f8             	mov    %rdi,%rax
  80272c:	48 c1 e8 15          	shr    $0x15,%rax
  802730:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802737:	7f 00 00 
  80273a:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80273e:	f6 c2 01             	test   $0x1,%dl
  802741:	74 44                	je     802787 <get_uvpt_entry+0xa9>
  802743:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  80274a:	7f 00 00 
  80274d:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802751:	f6 c2 80             	test   $0x80,%dl
  802754:	75 31                	jne    802787 <get_uvpt_entry+0xa9>
    return uvpt[VPT(va)];
  802756:	48 c1 ef 0c          	shr    $0xc,%rdi
  80275a:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802761:	7f 00 00 
  802764:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  802768:	c3                   	ret
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802769:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  802770:	7f 00 00 
  802773:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802777:	c3                   	ret
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  802778:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  80277f:	7f 00 00 
  802782:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802786:	c3                   	ret
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802787:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  80278e:	7f 00 00 
  802791:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802795:	c3                   	ret

0000000000802796 <get_phys_addr>:

uintptr_t
get_phys_addr(void *va) {
  802796:	f3 0f 1e fa          	endbr64
  80279a:	48 89 fa             	mov    %rdi,%rdx
    if (!(uvpml4[VPML4(va)] & PTE_P))
  80279d:	48 89 f9             	mov    %rdi,%rcx
  8027a0:	48 c1 e9 27          	shr    $0x27,%rcx
  8027a4:	48 b8 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rax
  8027ab:	7f 00 00 
  8027ae:	48 8b 0c c8          	mov    (%rax,%rcx,8),%rcx
        return -1;
  8027b2:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpml4[VPML4(va)] & PTE_P))
  8027b9:	f6 c1 01             	test   $0x1,%cl
  8027bc:	0f 84 b2 00 00 00    	je     802874 <get_phys_addr+0xde>
    if (!(uvpdp[VPDP(va)] & PTE_P))
  8027c2:	48 89 f9             	mov    %rdi,%rcx
  8027c5:	48 c1 e9 1e          	shr    $0x1e,%rcx
  8027c9:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  8027d0:	7f 00 00 
  8027d3:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  8027d7:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpdp[VPDP(va)] & PTE_P))
  8027de:	40 f6 c6 01          	test   $0x1,%sil
  8027e2:	0f 84 8c 00 00 00    	je     802874 <get_phys_addr+0xde>
    if (uvpdp[VPDP(va)] & PTE_PS)
  8027e8:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  8027ef:	7f 00 00 
  8027f2:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8027f6:	a8 80                	test   $0x80,%al
  8027f8:	75 7b                	jne    802875 <get_phys_addr+0xdf>
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
    if (!(uvpd[VPD(va)] & PTE_P))
  8027fa:	48 89 f9             	mov    %rdi,%rcx
  8027fd:	48 c1 e9 15          	shr    $0x15,%rcx
  802801:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  802808:	7f 00 00 
  80280b:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  80280f:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpd[VPD(va)] & PTE_P))
  802816:	40 f6 c6 01          	test   $0x1,%sil
  80281a:	74 58                	je     802874 <get_phys_addr+0xde>
    if ((uvpd[VPD(va)] & PTE_PS))
  80281c:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  802823:	7f 00 00 
  802826:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  80282a:	a8 80                	test   $0x80,%al
  80282c:	75 6c                	jne    80289a <get_phys_addr+0x104>
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
    if (!(uvpt[VPT(va)] & PTE_P))
  80282e:	48 89 f9             	mov    %rdi,%rcx
  802831:	48 c1 e9 0c          	shr    $0xc,%rcx
  802835:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  80283c:	7f 00 00 
  80283f:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  802843:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpt[VPT(va)] & PTE_P))
  80284a:	40 f6 c6 01          	test   $0x1,%sil
  80284e:	74 24                	je     802874 <get_phys_addr+0xde>
    return PTE_ADDR(uvpt[VPT(va)]) + PAGE_OFFSET(va);
  802850:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802857:	7f 00 00 
  80285a:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  80285e:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802865:	ff ff 7f 
  802868:	48 21 c8             	and    %rcx,%rax
  80286b:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  802871:	48 09 d0             	or     %rdx,%rax
}
  802874:	c3                   	ret
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
  802875:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  80287c:	7f 00 00 
  80287f:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802883:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  80288a:	ff ff 7f 
  80288d:	48 21 c8             	and    %rcx,%rax
  802890:	81 e2 ff ff ff 3f    	and    $0x3fffffff,%edx
  802896:	48 01 d0             	add    %rdx,%rax
  802899:	c3                   	ret
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
  80289a:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  8028a1:	7f 00 00 
  8028a4:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8028a8:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  8028af:	ff ff 7f 
  8028b2:	48 21 c8             	and    %rcx,%rax
  8028b5:	81 e2 ff ff 1f 00    	and    $0x1fffff,%edx
  8028bb:	48 01 d0             	add    %rdx,%rax
  8028be:	c3                   	ret

00000000008028bf <get_prot>:

int
get_prot(void *va) {
  8028bf:	f3 0f 1e fa          	endbr64
  8028c3:	55                   	push   %rbp
  8028c4:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  8028c7:	48 b8 de 26 80 00 00 	movabs $0x8026de,%rax
  8028ce:	00 00 00 
  8028d1:	ff d0                	call   *%rax
  8028d3:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
    if (pte & PTE_P) prot |= PROT_R;
  8028d6:	83 e0 01             	and    $0x1,%eax
  8028d9:	c1 e0 02             	shl    $0x2,%eax
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  8028dc:	89 d1                	mov    %edx,%ecx
  8028de:	81 e1 00 0a 00 00    	and    $0xa00,%ecx
    if (pte & PTE_P) prot |= PROT_R;
  8028e4:	09 c8                	or     %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  8028e6:	89 c1                	mov    %eax,%ecx
  8028e8:	83 c9 02             	or     $0x2,%ecx
  8028eb:	f6 c2 02             	test   $0x2,%dl
  8028ee:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  8028f1:	89 c1                	mov    %eax,%ecx
  8028f3:	83 c9 01             	or     $0x1,%ecx
  8028f6:	48 85 d2             	test   %rdx,%rdx
  8028f9:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  8028fc:	89 c1                	mov    %eax,%ecx
  8028fe:	83 c9 40             	or     $0x40,%ecx
  802901:	f6 c6 04             	test   $0x4,%dh
  802904:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  802907:	5d                   	pop    %rbp
  802908:	c3                   	ret

0000000000802909 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  802909:	f3 0f 1e fa          	endbr64
  80290d:	55                   	push   %rbp
  80290e:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802911:	48 b8 de 26 80 00 00 	movabs $0x8026de,%rax
  802918:	00 00 00 
  80291b:	ff d0                	call   *%rax
    return pte & PTE_D;
  80291d:	48 c1 e8 06          	shr    $0x6,%rax
  802921:	83 e0 01             	and    $0x1,%eax
}
  802924:	5d                   	pop    %rbp
  802925:	c3                   	ret

0000000000802926 <is_page_present>:

bool
is_page_present(void *va) {
  802926:	f3 0f 1e fa          	endbr64
  80292a:	55                   	push   %rbp
  80292b:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  80292e:	48 b8 de 26 80 00 00 	movabs $0x8026de,%rax
  802935:	00 00 00 
  802938:	ff d0                	call   *%rax
  80293a:	83 e0 01             	and    $0x1,%eax
}
  80293d:	5d                   	pop    %rbp
  80293e:	c3                   	ret

000000000080293f <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  80293f:	f3 0f 1e fa          	endbr64
  802943:	55                   	push   %rbp
  802944:	48 89 e5             	mov    %rsp,%rbp
  802947:	41 57                	push   %r15
  802949:	41 56                	push   %r14
  80294b:	41 55                	push   %r13
  80294d:	41 54                	push   %r12
  80294f:	53                   	push   %rbx
  802950:	48 83 ec 18          	sub    $0x18,%rsp
  802954:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  802958:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
     * NOTE: Skip over larger pages/page directories for efficiency */
    // LAB 11: Your code here:

    int res = 0;
    (void)fun, (void)arg;
    uintptr_t va = 0;
  80295c:	bb 00 00 00 00       	mov    $0x0,%ebx
    while (va < USER_STACK_TOP) {
        size_t size = 0;
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  802961:	49 be 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%r14
  802968:	7f 00 00 
            size = 1LL << PML4_SHIFT;
            goto next;
        }

        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  80296b:	49 bd 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%r13
  802972:	7f 00 00 
    while (va < USER_STACK_TOP) {
  802975:	49 bf ff 6f ff ff 7f 	movabs $0x7fffff6fff,%r15
  80297c:	00 00 00 
  80297f:	eb 73                	jmp    8029f4 <foreach_shared_region+0xb5>
            }

            goto next;
        }

        if (!(uvpd[VPD(va)] & PTE_P)) {
  802981:	48 89 d8             	mov    %rbx,%rax
  802984:	48 c1 e8 15          	shr    $0x15,%rax
  802988:	48 b9 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rcx
  80298f:	7f 00 00 
  802992:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
            size = 1LL << PD_SHIFT;
  802996:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
        if (!(uvpd[VPD(va)] & PTE_P)) {
  80299c:	f6 c2 01             	test   $0x1,%dl
  80299f:	74 4b                	je     8029ec <foreach_shared_region+0xad>
            goto next;
        }

        if (uvpd[VPD(va)] & PTE_PS) {
  8029a1:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
  8029a5:	f6 c2 80             	test   $0x80,%dl
  8029a8:	74 11                	je     8029bb <foreach_shared_region+0x7c>
            size = 1LL << PD_SHIFT;
            if (uvpd[VPD(va)] & PTE_SHARE) {
  8029aa:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
  8029ae:	f6 c4 04             	test   $0x4,%ah
  8029b1:	74 39                	je     8029ec <foreach_shared_region+0xad>
            size = 1LL << PD_SHIFT;
  8029b3:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
  8029b9:	eb 20                	jmp    8029db <foreach_shared_region+0x9c>

            goto next;
        }

        size = PAGE_SIZE;
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  8029bb:	48 89 da             	mov    %rbx,%rdx
  8029be:	48 c1 ea 0c          	shr    $0xc,%rdx
  8029c2:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  8029c9:	7f 00 00 
  8029cc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
        size = PAGE_SIZE;
  8029d0:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  8029d6:	f6 c4 04             	test   $0x4,%ah
  8029d9:	74 11                	je     8029ec <foreach_shared_region+0xad>
            goto next;
        }

    map:
        fun((void *)va, (void *)(va + size), arg);
  8029db:	49 8d 34 1c          	lea    (%r12,%rbx,1),%rsi
  8029df:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8029e3:	48 89 df             	mov    %rbx,%rdi
  8029e6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8029ea:	ff d0                	call   *%rax
    next:
        va += size;
  8029ec:	4c 01 e3             	add    %r12,%rbx
    while (va < USER_STACK_TOP) {
  8029ef:	49 39 df             	cmp    %rbx,%r15
  8029f2:	72 3e                	jb     802a32 <foreach_shared_region+0xf3>
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  8029f4:	49 8b 06             	mov    (%r14),%rax
  8029f7:	a8 01                	test   $0x1,%al
  8029f9:	74 37                	je     802a32 <foreach_shared_region+0xf3>
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  8029fb:	48 89 d8             	mov    %rbx,%rax
  8029fe:	48 c1 e8 1e          	shr    $0x1e,%rax
  802a02:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
            size = 1LL << PDP_SHIFT;
  802a07:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802a0d:	f6 c2 01             	test   $0x1,%dl
  802a10:	74 da                	je     8029ec <foreach_shared_region+0xad>
        if (uvpdp[VPDP(va)] & PTE_PS) {
  802a12:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
  802a17:	f6 c2 80             	test   $0x80,%dl
  802a1a:	0f 84 61 ff ff ff    	je     802981 <foreach_shared_region+0x42>
            if (uvpdp[VPDP(va)] & PTE_SHARE) {
  802a20:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  802a25:	f6 c4 04             	test   $0x4,%ah
  802a28:	74 c2                	je     8029ec <foreach_shared_region+0xad>
            size = 1LL << PDP_SHIFT;
  802a2a:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
  802a30:	eb a9                	jmp    8029db <foreach_shared_region+0x9c>
    }
    return res;
}
  802a32:	b8 00 00 00 00       	mov    $0x0,%eax
  802a37:	48 83 c4 18          	add    $0x18,%rsp
  802a3b:	5b                   	pop    %rbx
  802a3c:	41 5c                	pop    %r12
  802a3e:	41 5d                	pop    %r13
  802a40:	41 5e                	pop    %r14
  802a42:	41 5f                	pop    %r15
  802a44:	5d                   	pop    %rbp
  802a45:	c3                   	ret

0000000000802a46 <devcons_close>:

    return res;
}

static int
devcons_close(struct Fd *fd) {
  802a46:	f3 0f 1e fa          	endbr64
    USED(fd);

    return 0;
}
  802a4a:	b8 00 00 00 00       	mov    $0x0,%eax
  802a4f:	c3                   	ret

0000000000802a50 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  802a50:	f3 0f 1e fa          	endbr64
  802a54:	55                   	push   %rbp
  802a55:	48 89 e5             	mov    %rsp,%rbp
  802a58:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  802a5b:	48 be 70 42 80 00 00 	movabs $0x804270,%rsi
  802a62:	00 00 00 
  802a65:	48 b8 05 0c 80 00 00 	movabs $0x800c05,%rax
  802a6c:	00 00 00 
  802a6f:	ff d0                	call   *%rax
    return 0;
}
  802a71:	b8 00 00 00 00       	mov    $0x0,%eax
  802a76:	5d                   	pop    %rbp
  802a77:	c3                   	ret

0000000000802a78 <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  802a78:	f3 0f 1e fa          	endbr64
  802a7c:	55                   	push   %rbp
  802a7d:	48 89 e5             	mov    %rsp,%rbp
  802a80:	41 57                	push   %r15
  802a82:	41 56                	push   %r14
  802a84:	41 55                	push   %r13
  802a86:	41 54                	push   %r12
  802a88:	53                   	push   %rbx
  802a89:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  802a90:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  802a97:	48 85 d2             	test   %rdx,%rdx
  802a9a:	74 7a                	je     802b16 <devcons_write+0x9e>
  802a9c:	49 89 d6             	mov    %rdx,%r14
  802a9f:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802aa5:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  802aaa:	49 bf 20 0e 80 00 00 	movabs $0x800e20,%r15
  802ab1:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  802ab4:	4c 89 f3             	mov    %r14,%rbx
  802ab7:	48 29 f3             	sub    %rsi,%rbx
  802aba:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802abf:	48 39 c3             	cmp    %rax,%rbx
  802ac2:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  802ac6:	4c 63 eb             	movslq %ebx,%r13
  802ac9:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  802ad0:	48 01 c6             	add    %rax,%rsi
  802ad3:	4c 89 ea             	mov    %r13,%rdx
  802ad6:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802add:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  802ae0:	4c 89 ee             	mov    %r13,%rsi
  802ae3:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802aea:	48 b8 65 10 80 00 00 	movabs $0x801065,%rax
  802af1:	00 00 00 
  802af4:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  802af6:	41 01 dc             	add    %ebx,%r12d
  802af9:	49 63 f4             	movslq %r12d,%rsi
  802afc:	4c 39 f6             	cmp    %r14,%rsi
  802aff:	72 b3                	jb     802ab4 <devcons_write+0x3c>
    return res;
  802b01:	49 63 c4             	movslq %r12d,%rax
}
  802b04:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  802b0b:	5b                   	pop    %rbx
  802b0c:	41 5c                	pop    %r12
  802b0e:	41 5d                	pop    %r13
  802b10:	41 5e                	pop    %r14
  802b12:	41 5f                	pop    %r15
  802b14:	5d                   	pop    %rbp
  802b15:	c3                   	ret
    for (res = 0; res < n; res += inc) {
  802b16:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802b1c:	eb e3                	jmp    802b01 <devcons_write+0x89>

0000000000802b1e <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802b1e:	f3 0f 1e fa          	endbr64
  802b22:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  802b25:	ba 00 00 00 00       	mov    $0x0,%edx
  802b2a:	48 85 c0             	test   %rax,%rax
  802b2d:	74 55                	je     802b84 <devcons_read+0x66>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802b2f:	55                   	push   %rbp
  802b30:	48 89 e5             	mov    %rsp,%rbp
  802b33:	41 55                	push   %r13
  802b35:	41 54                	push   %r12
  802b37:	53                   	push   %rbx
  802b38:	48 83 ec 08          	sub    $0x8,%rsp
  802b3c:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  802b3f:	48 bb 96 10 80 00 00 	movabs $0x801096,%rbx
  802b46:	00 00 00 
  802b49:	49 bc 6f 11 80 00 00 	movabs $0x80116f,%r12
  802b50:	00 00 00 
  802b53:	eb 03                	jmp    802b58 <devcons_read+0x3a>
  802b55:	41 ff d4             	call   *%r12
  802b58:	ff d3                	call   *%rbx
  802b5a:	85 c0                	test   %eax,%eax
  802b5c:	74 f7                	je     802b55 <devcons_read+0x37>
    if (c < 0) return c;
  802b5e:	48 63 d0             	movslq %eax,%rdx
  802b61:	78 13                	js     802b76 <devcons_read+0x58>
    if (c == 0x04) return 0;
  802b63:	ba 00 00 00 00       	mov    $0x0,%edx
  802b68:	83 f8 04             	cmp    $0x4,%eax
  802b6b:	74 09                	je     802b76 <devcons_read+0x58>
    *(char *)vbuf = (char)c;
  802b6d:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  802b71:	ba 01 00 00 00       	mov    $0x1,%edx
}
  802b76:	48 89 d0             	mov    %rdx,%rax
  802b79:	48 83 c4 08          	add    $0x8,%rsp
  802b7d:	5b                   	pop    %rbx
  802b7e:	41 5c                	pop    %r12
  802b80:	41 5d                	pop    %r13
  802b82:	5d                   	pop    %rbp
  802b83:	c3                   	ret
  802b84:	48 89 d0             	mov    %rdx,%rax
  802b87:	c3                   	ret

0000000000802b88 <cputchar>:
cputchar(int ch) {
  802b88:	f3 0f 1e fa          	endbr64
  802b8c:	55                   	push   %rbp
  802b8d:	48 89 e5             	mov    %rsp,%rbp
  802b90:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  802b94:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  802b98:	be 01 00 00 00       	mov    $0x1,%esi
  802b9d:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  802ba1:	48 b8 65 10 80 00 00 	movabs $0x801065,%rax
  802ba8:	00 00 00 
  802bab:	ff d0                	call   *%rax
}
  802bad:	c9                   	leave
  802bae:	c3                   	ret

0000000000802baf <getchar>:
getchar(void) {
  802baf:	f3 0f 1e fa          	endbr64
  802bb3:	55                   	push   %rbp
  802bb4:	48 89 e5             	mov    %rsp,%rbp
  802bb7:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  802bbb:	ba 01 00 00 00       	mov    $0x1,%edx
  802bc0:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  802bc4:	bf 00 00 00 00       	mov    $0x0,%edi
  802bc9:	48 b8 bf 1a 80 00 00 	movabs $0x801abf,%rax
  802bd0:	00 00 00 
  802bd3:	ff d0                	call   *%rax
  802bd5:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  802bd7:	85 c0                	test   %eax,%eax
  802bd9:	78 06                	js     802be1 <getchar+0x32>
  802bdb:	74 08                	je     802be5 <getchar+0x36>
  802bdd:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  802be1:	89 d0                	mov    %edx,%eax
  802be3:	c9                   	leave
  802be4:	c3                   	ret
    return res < 0 ? res : res ? c :
  802be5:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  802bea:	eb f5                	jmp    802be1 <getchar+0x32>

0000000000802bec <iscons>:
iscons(int fdnum) {
  802bec:	f3 0f 1e fa          	endbr64
  802bf0:	55                   	push   %rbp
  802bf1:	48 89 e5             	mov    %rsp,%rbp
  802bf4:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802bf8:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802bfc:	48 b8 c4 17 80 00 00 	movabs $0x8017c4,%rax
  802c03:	00 00 00 
  802c06:	ff d0                	call   *%rax
    if (res < 0) return res;
  802c08:	85 c0                	test   %eax,%eax
  802c0a:	78 18                	js     802c24 <iscons+0x38>
    return fd->fd_dev_id == devcons.dev_id;
  802c0c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802c10:	48 b8 a0 50 80 00 00 	movabs $0x8050a0,%rax
  802c17:	00 00 00 
  802c1a:	8b 00                	mov    (%rax),%eax
  802c1c:	39 02                	cmp    %eax,(%rdx)
  802c1e:	0f 94 c0             	sete   %al
  802c21:	0f b6 c0             	movzbl %al,%eax
}
  802c24:	c9                   	leave
  802c25:	c3                   	ret

0000000000802c26 <opencons>:
opencons(void) {
  802c26:	f3 0f 1e fa          	endbr64
  802c2a:	55                   	push   %rbp
  802c2b:	48 89 e5             	mov    %rsp,%rbp
  802c2e:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  802c32:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  802c36:	48 b8 60 17 80 00 00 	movabs $0x801760,%rax
  802c3d:	00 00 00 
  802c40:	ff d0                	call   *%rax
  802c42:	85 c0                	test   %eax,%eax
  802c44:	78 49                	js     802c8f <opencons+0x69>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  802c46:	b9 46 00 00 00       	mov    $0x46,%ecx
  802c4b:	ba 00 10 00 00       	mov    $0x1000,%edx
  802c50:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  802c54:	bf 00 00 00 00       	mov    $0x0,%edi
  802c59:	48 b8 0a 12 80 00 00 	movabs $0x80120a,%rax
  802c60:	00 00 00 
  802c63:	ff d0                	call   *%rax
  802c65:	85 c0                	test   %eax,%eax
  802c67:	78 26                	js     802c8f <opencons+0x69>
    fd->fd_dev_id = devcons.dev_id;
  802c69:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802c6d:	a1 a0 50 80 00 00 00 	movabs 0x8050a0,%eax
  802c74:	00 00 
  802c76:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  802c78:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802c7c:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  802c83:	48 b8 2a 17 80 00 00 	movabs $0x80172a,%rax
  802c8a:	00 00 00 
  802c8d:	ff d0                	call   *%rax
}
  802c8f:	c9                   	leave
  802c90:	c3                   	ret

0000000000802c91 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  802c91:	f3 0f 1e fa          	endbr64
  802c95:	55                   	push   %rbp
  802c96:	48 89 e5             	mov    %rsp,%rbp
  802c99:	41 56                	push   %r14
  802c9b:	41 55                	push   %r13
  802c9d:	41 54                	push   %r12
  802c9f:	53                   	push   %rbx
  802ca0:	48 83 ec 50          	sub    $0x50,%rsp
  802ca4:	49 89 fc             	mov    %rdi,%r12
  802ca7:	41 89 f5             	mov    %esi,%r13d
  802caa:	48 89 d3             	mov    %rdx,%rbx
  802cad:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  802cb1:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  802cb5:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  802cb9:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  802cc0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802cc4:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  802cc8:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  802ccc:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  802cd0:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  802cd7:	00 00 00 
  802cda:	4c 8b 30             	mov    (%rax),%r14
  802cdd:	48 b8 3a 11 80 00 00 	movabs $0x80113a,%rax
  802ce4:	00 00 00 
  802ce7:	ff d0                	call   *%rax
  802ce9:	89 c6                	mov    %eax,%esi
  802ceb:	45 89 e8             	mov    %r13d,%r8d
  802cee:	4c 89 e1             	mov    %r12,%rcx
  802cf1:	4c 89 f2             	mov    %r14,%rdx
  802cf4:	48 bf f0 46 80 00 00 	movabs $0x8046f0,%rdi
  802cfb:	00 00 00 
  802cfe:	b8 00 00 00 00       	mov    $0x0,%eax
  802d03:	49 bc bc 02 80 00 00 	movabs $0x8002bc,%r12
  802d0a:	00 00 00 
  802d0d:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  802d10:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  802d14:	48 89 df             	mov    %rbx,%rdi
  802d17:	48 b8 54 02 80 00 00 	movabs $0x800254,%rax
  802d1e:	00 00 00 
  802d21:	ff d0                	call   *%rax
    cprintf("\n");
  802d23:	48 bf 0f 40 80 00 00 	movabs $0x80400f,%rdi
  802d2a:	00 00 00 
  802d2d:	b8 00 00 00 00       	mov    $0x0,%eax
  802d32:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  802d35:	cc                   	int3
  802d36:	eb fd                	jmp    802d35 <_panic+0xa4>

0000000000802d38 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
    # Call the C page fault handler.
    movq  %rsp,%rdi # passing the function argument in rdi
  802d38:	48 89 e7             	mov    %rsp,%rdi
    movabs $_handle_vectored_pagefault, %rax
  802d3b:	48 b8 77 2f 80 00 00 	movabs $0x802f77,%rax
  802d42:	00 00 00 
    call *%rax
  802d45:	ff d0                	call   *%rax
    # registers are available for intermediate calculations.  You
    # may find that you have to rearrange your code in non-obvious
    # ways as registers become unavailable as scratch space.

    # LAB 9: Your code here
    movq %rsp, %rax
  802d47:	48 89 e0             	mov    %rsp,%rax
    movq UTRAP_RIP(%rsp), %rbx
  802d4a:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  802d51:	00 
    movq UTRAP_RSP(%rsp), %rsp
  802d52:	48 8b a4 24 98 00 00 	mov    0x98(%rsp),%rsp
  802d59:	00 
    pushq %rbx
  802d5a:	53                   	push   %rbx
    movq %rsp, UTRAP_RSP(%rax)
  802d5b:	48 89 a0 98 00 00 00 	mov    %rsp,0x98(%rax)

    # Restore the trap-time registers.  After you do this, you
    # can no longer modify any general-purpose registers (use POPA macro).
    # LAB 9: Your code here
    movq %rax, %rsp
  802d62:	48 89 c4             	mov    %rax,%rsp
    addq $16, %rsp
  802d65:	48 83 c4 10          	add    $0x10,%rsp
    POPA
  802d69:	4c 8b 3c 24          	mov    (%rsp),%r15
  802d6d:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  802d72:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  802d77:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  802d7c:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  802d81:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  802d86:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  802d8b:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  802d90:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  802d95:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  802d9a:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  802d9f:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  802da4:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  802da9:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  802dae:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  802db3:	48 83 c4 78          	add    $0x78,%rsp
    addq $8, %rsp
  802db7:	48 83 c4 08          	add    $0x8,%rsp
    # Restore rflags from the stack.  After you do this, you can
    # no longer use arithmetic operations or anything else that
    # modifies rflags.
    # LAB 9: Your code here
	popfq
  802dbb:	9d                   	popf
    # Switch back to the adjusted trap-time stack.
    # LAB 9: Your code here
	popq %rsp
  802dbc:	5c                   	pop    %rsp
    # Return to re-execute the instruction that faulted.
    ret
  802dbd:	c3                   	ret

0000000000802dbe <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802dbe:	f3 0f 1e fa          	endbr64
  802dc2:	55                   	push   %rbp
  802dc3:	48 89 e5             	mov    %rsp,%rbp
  802dc6:	41 54                	push   %r12
  802dc8:	53                   	push   %rbx
  802dc9:	48 89 fb             	mov    %rdi,%rbx
  802dcc:	48 89 f7             	mov    %rsi,%rdi
  802dcf:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802dd2:	48 85 f6             	test   %rsi,%rsi
  802dd5:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802ddc:	00 00 00 
  802ddf:	48 0f 44 f8          	cmove  %rax,%rdi
    }
    int res = sys_ipc_recv(pg, PAGE_SIZE);
  802de3:	be 00 10 00 00       	mov    $0x1000,%esi
  802de8:	48 b8 2c 15 80 00 00 	movabs $0x80152c,%rax
  802def:	00 00 00 
  802df2:	ff d0                	call   *%rax
    if (res < 0) {
  802df4:	85 c0                	test   %eax,%eax
  802df6:	78 45                	js     802e3d <ipc_recv+0x7f>
        if (perm_store != NULL) {
            *perm_store = 0;
        }
        return res;
    } else {
        if (from_env_store != NULL) {
  802df8:	48 85 db             	test   %rbx,%rbx
  802dfb:	74 12                	je     802e0f <ipc_recv+0x51>
            *from_env_store = thisenv->env_ipc_from;
  802dfd:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  802e04:	00 00 00 
  802e07:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  802e0d:	89 03                	mov    %eax,(%rbx)
        }
        if (perm_store != NULL) {
  802e0f:	4d 85 e4             	test   %r12,%r12
  802e12:	74 14                	je     802e28 <ipc_recv+0x6a>
            *perm_store = thisenv->env_ipc_perm;
  802e14:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  802e1b:	00 00 00 
  802e1e:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  802e24:	41 89 04 24          	mov    %eax,(%r12)
        }
        return thisenv->env_ipc_value;
  802e28:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  802e2f:	00 00 00 
  802e32:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
    }
    return -1;
}
  802e38:	5b                   	pop    %rbx
  802e39:	41 5c                	pop    %r12
  802e3b:	5d                   	pop    %rbp
  802e3c:	c3                   	ret
        if (from_env_store != NULL) {
  802e3d:	48 85 db             	test   %rbx,%rbx
  802e40:	74 06                	je     802e48 <ipc_recv+0x8a>
            *from_env_store = 0;
  802e42:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store != NULL) {
  802e48:	4d 85 e4             	test   %r12,%r12
  802e4b:	74 eb                	je     802e38 <ipc_recv+0x7a>
            *perm_store = 0;
  802e4d:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  802e54:	00 
  802e55:	eb e1                	jmp    802e38 <ipc_recv+0x7a>

0000000000802e57 <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  802e57:	f3 0f 1e fa          	endbr64
  802e5b:	55                   	push   %rbp
  802e5c:	48 89 e5             	mov    %rsp,%rbp
  802e5f:	41 57                	push   %r15
  802e61:	41 56                	push   %r14
  802e63:	41 55                	push   %r13
  802e65:	41 54                	push   %r12
  802e67:	53                   	push   %rbx
  802e68:	48 83 ec 18          	sub    $0x18,%rsp
  802e6c:	89 7d c4             	mov    %edi,-0x3c(%rbp)
  802e6f:	48 89 d3             	mov    %rdx,%rbx
  802e72:	49 89 cc             	mov    %rcx,%r12
  802e75:	45 89 c5             	mov    %r8d,%r13d
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802e78:	48 85 d2             	test   %rdx,%rdx
  802e7b:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802e82:	00 00 00 
  802e85:	48 0f 44 d8          	cmove  %rax,%rbx
    }
    int res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802e89:	89 f0                	mov    %esi,%eax
  802e8b:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  802e8f:	48 89 da             	mov    %rbx,%rdx
  802e92:	48 89 c6             	mov    %rax,%rsi
  802e95:	48 b8 fc 14 80 00 00 	movabs $0x8014fc,%rax
  802e9c:	00 00 00 
  802e9f:	ff d0                	call   *%rax
    while (res < 0) {
  802ea1:	85 c0                	test   %eax,%eax
  802ea3:	79 65                	jns    802f0a <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802ea5:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802ea8:	75 33                	jne    802edd <ipc_send+0x86>
            panic("Error: %i\n", res);
        }
        sys_yield();
  802eaa:	49 bf 6f 11 80 00 00 	movabs $0x80116f,%r15
  802eb1:	00 00 00 
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802eb4:	49 be fc 14 80 00 00 	movabs $0x8014fc,%r14
  802ebb:	00 00 00 
        sys_yield();
  802ebe:	41 ff d7             	call   *%r15
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802ec1:	45 89 e8             	mov    %r13d,%r8d
  802ec4:	4c 89 e1             	mov    %r12,%rcx
  802ec7:	48 89 da             	mov    %rbx,%rdx
  802eca:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  802ece:	8b 7d c4             	mov    -0x3c(%rbp),%edi
  802ed1:	41 ff d6             	call   *%r14
    while (res < 0) {
  802ed4:	85 c0                	test   %eax,%eax
  802ed6:	79 32                	jns    802f0a <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802ed8:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802edb:	74 e1                	je     802ebe <ipc_send+0x67>
            panic("Error: %i\n", res);
  802edd:	89 c1                	mov    %eax,%ecx
  802edf:	48 ba 7c 42 80 00 00 	movabs $0x80427c,%rdx
  802ee6:	00 00 00 
  802ee9:	be 42 00 00 00       	mov    $0x42,%esi
  802eee:	48 bf 87 42 80 00 00 	movabs $0x804287,%rdi
  802ef5:	00 00 00 
  802ef8:	b8 00 00 00 00       	mov    $0x0,%eax
  802efd:	49 b8 91 2c 80 00 00 	movabs $0x802c91,%r8
  802f04:	00 00 00 
  802f07:	41 ff d0             	call   *%r8
    }
}
  802f0a:	48 83 c4 18          	add    $0x18,%rsp
  802f0e:	5b                   	pop    %rbx
  802f0f:	41 5c                	pop    %r12
  802f11:	41 5d                	pop    %r13
  802f13:	41 5e                	pop    %r14
  802f15:	41 5f                	pop    %r15
  802f17:	5d                   	pop    %rbp
  802f18:	c3                   	ret

0000000000802f19 <ipc_find_env>:

/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
  802f19:	f3 0f 1e fa          	endbr64
    for (size_t i = 0; i < NENV; i++)
  802f1d:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  802f22:	48 b9 00 00 a0 1f 80 	movabs $0x801fa00000,%rcx
  802f29:	00 00 00 
  802f2c:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802f30:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802f34:	48 c1 e2 04          	shl    $0x4,%rdx
  802f38:	48 01 ca             	add    %rcx,%rdx
  802f3b:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  802f41:	39 fa                	cmp    %edi,%edx
  802f43:	74 12                	je     802f57 <ipc_find_env+0x3e>
    for (size_t i = 0; i < NENV; i++)
  802f45:	48 83 c0 01          	add    $0x1,%rax
  802f49:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  802f4f:	75 db                	jne    802f2c <ipc_find_env+0x13>
            return envs[i].env_id;
    return 0;
  802f51:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f56:	c3                   	ret
            return envs[i].env_id;
  802f57:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802f5b:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802f5f:	48 c1 e2 04          	shl    $0x4,%rdx
  802f63:	48 b8 00 00 a0 1f 80 	movabs $0x801fa00000,%rax
  802f6a:	00 00 00 
  802f6d:	48 01 d0             	add    %rdx,%rax
  802f70:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802f76:	c3                   	ret

0000000000802f77 <_handle_vectored_pagefault>:
/* Vector size */
static size_t _pfhandler_off = 0;
static bool _pfhandler_inititiallized = 0;

void
_handle_vectored_pagefault(struct UTrapframe *utf) {
  802f77:	f3 0f 1e fa          	endbr64
  802f7b:	55                   	push   %rbp
  802f7c:	48 89 e5             	mov    %rsp,%rbp
  802f7f:	41 56                	push   %r14
  802f81:	41 55                	push   %r13
  802f83:	41 54                	push   %r12
  802f85:	53                   	push   %rbx
  802f86:	49 89 fc             	mov    %rdi,%r12
    /* This trying to handle pagefault until
     * some handler returns 1, that indicates
     * successfully handled exception */
    for (size_t i = 0; i < _pfhandler_off; i++)
  802f89:	48 b8 68 80 80 00 00 	movabs $0x808068,%rax
  802f90:	00 00 00 
  802f93:	48 83 38 00          	cmpq   $0x0,(%rax)
  802f97:	74 27                	je     802fc0 <_handle_vectored_pagefault+0x49>
  802f99:	bb 00 00 00 00       	mov    $0x0,%ebx
        if (_pfhandler_vec[i](utf)) return;
  802f9e:	49 bd 20 80 80 00 00 	movabs $0x808020,%r13
  802fa5:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++)
  802fa8:	49 89 c6             	mov    %rax,%r14
        if (_pfhandler_vec[i](utf)) return;
  802fab:	4c 89 e7             	mov    %r12,%rdi
  802fae:	41 ff 54 dd 00       	call   *0x0(%r13,%rbx,8)
  802fb3:	84 c0                	test   %al,%al
  802fb5:	75 45                	jne    802ffc <_handle_vectored_pagefault+0x85>
    for (size_t i = 0; i < _pfhandler_off; i++)
  802fb7:	48 83 c3 01          	add    $0x1,%rbx
  802fbb:	49 3b 1e             	cmp    (%r14),%rbx
  802fbe:	72 eb                	jb     802fab <_handle_vectored_pagefault+0x34>

    /* Unhandled exceptions just cause panic */
    panic("Userspace page fault rip=%08lX va=%08lX err=%x\n",
  802fc0:	49 8b 8c 24 88 00 00 	mov    0x88(%r12),%rcx
  802fc7:	00 
  802fc8:	45 8b 4c 24 08       	mov    0x8(%r12),%r9d
  802fcd:	4d 8b 04 24          	mov    (%r12),%r8
  802fd1:	48 ba 18 47 80 00 00 	movabs $0x804718,%rdx
  802fd8:	00 00 00 
  802fdb:	be 1d 00 00 00       	mov    $0x1d,%esi
  802fe0:	48 bf 91 42 80 00 00 	movabs $0x804291,%rdi
  802fe7:	00 00 00 
  802fea:	b8 00 00 00 00       	mov    $0x0,%eax
  802fef:	49 ba 91 2c 80 00 00 	movabs $0x802c91,%r10
  802ff6:	00 00 00 
  802ff9:	41 ff d2             	call   *%r10
          utf->utf_rip, utf->utf_fault_va, (int)utf->utf_err);
}
  802ffc:	5b                   	pop    %rbx
  802ffd:	41 5c                	pop    %r12
  802fff:	41 5d                	pop    %r13
  803001:	41 5e                	pop    %r14
  803003:	5d                   	pop    %rbp
  803004:	c3                   	ret

0000000000803005 <add_pgfault_handler>:
 * The first time we register a handler, we need to
 * allocate an exception stack (one page of memory with its top
 * at USER_EXCEPTION_STACK_TOP), and tell the kernel to call the assembly-language
 * _pgfault_upcall routine when a page fault occurs. */
int
add_pgfault_handler(pf_handler_t handler) {
  803005:	f3 0f 1e fa          	endbr64
  803009:	55                   	push   %rbp
  80300a:	48 89 e5             	mov    %rsp,%rbp
  80300d:	53                   	push   %rbx
  80300e:	48 83 ec 08          	sub    $0x8,%rsp
  803012:	48 89 fb             	mov    %rdi,%rbx
    int res = 0;
    if (!_pfhandler_inititiallized) {
  803015:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  80301c:	00 00 00 
  80301f:	80 38 00             	cmpb   $0x0,(%rax)
  803022:	0f 84 84 00 00 00    	je     8030ac <add_pgfault_handler+0xa7>
        _pfhandler_vec[_pfhandler_off++] = handler;
        _pfhandler_inititiallized = 1;
        goto end;
    }

    for (size_t i = 0; i < _pfhandler_off; i++)
  803028:	48 b8 68 80 80 00 00 	movabs $0x808068,%rax
  80302f:	00 00 00 
  803032:	48 8b 10             	mov    (%rax),%rdx
  803035:	b8 00 00 00 00       	mov    $0x0,%eax
        if (handler == _pfhandler_vec[i]) return 0;
  80303a:	48 b9 20 80 80 00 00 	movabs $0x808020,%rcx
  803041:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++)
  803044:	48 85 d2             	test   %rdx,%rdx
  803047:	74 19                	je     803062 <add_pgfault_handler+0x5d>
        if (handler == _pfhandler_vec[i]) return 0;
  803049:	48 39 1c c1          	cmp    %rbx,(%rcx,%rax,8)
  80304d:	0f 84 e8 00 00 00    	je     80313b <add_pgfault_handler+0x136>
    for (size_t i = 0; i < _pfhandler_off; i++)
  803053:	48 83 c0 01          	add    $0x1,%rax
  803057:	48 39 d0             	cmp    %rdx,%rax
  80305a:	75 ed                	jne    803049 <add_pgfault_handler+0x44>

    if (_pfhandler_off == MAX_PFHANDLER)
  80305c:	48 83 fa 08          	cmp    $0x8,%rdx
  803060:	74 1c                	je     80307e <add_pgfault_handler+0x79>
        res = -E_INVAL;
    else
        _pfhandler_vec[_pfhandler_off++] = handler;
  803062:	48 8d 42 01          	lea    0x1(%rdx),%rax
  803066:	48 a3 68 80 80 00 00 	movabs %rax,0x808068
  80306d:	00 00 00 
  803070:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  803077:	00 00 00 
  80307a:	48 89 1c d0          	mov    %rbx,(%rax,%rdx,8)

end:
    res = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  80307e:	48 b8 3a 11 80 00 00 	movabs $0x80113a,%rax
  803085:	00 00 00 
  803088:	ff d0                	call   *%rax
  80308a:	89 c7                	mov    %eax,%edi
  80308c:	48 be 38 2d 80 00 00 	movabs $0x802d38,%rsi
  803093:	00 00 00 
  803096:	48 b8 8f 14 80 00 00 	movabs $0x80148f,%rax
  80309d:	00 00 00 
  8030a0:	ff d0                	call   *%rax
    if (res < 0) panic("set_pgfault_handler: %i", res);
  8030a2:	85 c0                	test   %eax,%eax
  8030a4:	78 68                	js     80310e <add_pgfault_handler+0x109>
    return res;
}
  8030a6:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8030aa:	c9                   	leave
  8030ab:	c3                   	ret
        res = sys_alloc_region(sys_getenvid(), (void*)(USER_EXCEPTION_STACK_TOP - PAGE_SIZE), PAGE_SIZE, PROT_RW);
  8030ac:	48 b8 3a 11 80 00 00 	movabs $0x80113a,%rax
  8030b3:	00 00 00 
  8030b6:	ff d0                	call   *%rax
  8030b8:	89 c7                	mov    %eax,%edi
  8030ba:	b9 06 00 00 00       	mov    $0x6,%ecx
  8030bf:	ba 00 10 00 00       	mov    $0x1000,%edx
  8030c4:	48 be 00 f0 ff ff 7f 	movabs $0x7ffffff000,%rsi
  8030cb:	00 00 00 
  8030ce:	48 b8 0a 12 80 00 00 	movabs $0x80120a,%rax
  8030d5:	00 00 00 
  8030d8:	ff d0                	call   *%rax
        _pfhandler_vec[_pfhandler_off++] = handler;
  8030da:	48 ba 68 80 80 00 00 	movabs $0x808068,%rdx
  8030e1:	00 00 00 
  8030e4:	48 8b 02             	mov    (%rdx),%rax
  8030e7:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8030eb:	48 89 0a             	mov    %rcx,(%rdx)
  8030ee:	48 ba 20 80 80 00 00 	movabs $0x808020,%rdx
  8030f5:	00 00 00 
  8030f8:	48 89 1c c2          	mov    %rbx,(%rdx,%rax,8)
        _pfhandler_inititiallized = 1;
  8030fc:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  803103:	00 00 00 
  803106:	c6 00 01             	movb   $0x1,(%rax)
        goto end;
  803109:	e9 70 ff ff ff       	jmp    80307e <add_pgfault_handler+0x79>
    if (res < 0) panic("set_pgfault_handler: %i", res);
  80310e:	89 c1                	mov    %eax,%ecx
  803110:	48 ba 9f 42 80 00 00 	movabs $0x80429f,%rdx
  803117:	00 00 00 
  80311a:	be 3d 00 00 00       	mov    $0x3d,%esi
  80311f:	48 bf 91 42 80 00 00 	movabs $0x804291,%rdi
  803126:	00 00 00 
  803129:	b8 00 00 00 00       	mov    $0x0,%eax
  80312e:	49 b8 91 2c 80 00 00 	movabs $0x802c91,%r8
  803135:	00 00 00 
  803138:	41 ff d0             	call   *%r8
        if (handler == _pfhandler_vec[i]) return 0;
  80313b:	b8 00 00 00 00       	mov    $0x0,%eax
  803140:	e9 61 ff ff ff       	jmp    8030a6 <add_pgfault_handler+0xa1>

0000000000803145 <remove_pgfault_handler>:

void
remove_pgfault_handler(pf_handler_t handler) {
  803145:	f3 0f 1e fa          	endbr64
  803149:	55                   	push   %rbp
  80314a:	48 89 e5             	mov    %rsp,%rbp
    assert(_pfhandler_inititiallized);
  80314d:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  803154:	00 00 00 
  803157:	80 38 00             	cmpb   $0x0,(%rax)
  80315a:	74 33                	je     80318f <remove_pgfault_handler+0x4a>
    for (size_t i = 0; i < _pfhandler_off; i++) {
  80315c:	48 a1 68 80 80 00 00 	movabs 0x808068,%rax
  803163:	00 00 00 
  803166:	b9 00 00 00 00       	mov    $0x0,%ecx
        if (_pfhandler_vec[i] == handler) {
  80316b:	48 ba 20 80 80 00 00 	movabs $0x808020,%rdx
  803172:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++) {
  803175:	48 85 c0             	test   %rax,%rax
  803178:	0f 84 85 00 00 00    	je     803203 <remove_pgfault_handler+0xbe>
        if (_pfhandler_vec[i] == handler) {
  80317e:	48 39 3c ca          	cmp    %rdi,(%rdx,%rcx,8)
  803182:	74 40                	je     8031c4 <remove_pgfault_handler+0x7f>
    for (size_t i = 0; i < _pfhandler_off; i++) {
  803184:	48 83 c1 01          	add    $0x1,%rcx
  803188:	48 39 c1             	cmp    %rax,%rcx
  80318b:	75 f1                	jne    80317e <remove_pgfault_handler+0x39>
  80318d:	eb 74                	jmp    803203 <remove_pgfault_handler+0xbe>
    assert(_pfhandler_inititiallized);
  80318f:	48 b9 b7 42 80 00 00 	movabs $0x8042b7,%rcx
  803196:	00 00 00 
  803199:	48 ba 39 42 80 00 00 	movabs $0x804239,%rdx
  8031a0:	00 00 00 
  8031a3:	be 43 00 00 00       	mov    $0x43,%esi
  8031a8:	48 bf 91 42 80 00 00 	movabs $0x804291,%rdi
  8031af:	00 00 00 
  8031b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8031b7:	49 b8 91 2c 80 00 00 	movabs $0x802c91,%r8
  8031be:	00 00 00 
  8031c1:	41 ff d0             	call   *%r8
            memmove(_pfhandler_vec + i, _pfhandler_vec + i + 1, (_pfhandler_off - i - 1) * sizeof(*handler));
  8031c4:	48 8d 34 cd 08 00 00 	lea    0x8(,%rcx,8),%rsi
  8031cb:	00 
  8031cc:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8031d0:	48 29 ca             	sub    %rcx,%rdx
  8031d3:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8031da:	00 00 00 
  8031dd:	48 8d 0c 06          	lea    (%rsi,%rax,1),%rcx
  8031e1:	48 8d 7c 30 f8       	lea    -0x8(%rax,%rsi,1),%rdi
  8031e6:	48 89 ce             	mov    %rcx,%rsi
  8031e9:	48 b8 20 0e 80 00 00 	movabs $0x800e20,%rax
  8031f0:	00 00 00 
  8031f3:	ff d0                	call   *%rax
            _pfhandler_off--;
  8031f5:	48 b8 68 80 80 00 00 	movabs $0x808068,%rax
  8031fc:	00 00 00 
  8031ff:	48 83 28 01          	subq   $0x1,(%rax)
            return;
        }
    }
}
  803203:	5d                   	pop    %rbp
  803204:	c3                   	ret

0000000000803205 <__text_end>:
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
