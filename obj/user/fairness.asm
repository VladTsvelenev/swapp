
obj/user/fairness:     file format elf64-x86-64


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
  80001e:	e8 e0 00 00 00       	call   800103 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <umain>:
 * (user/idle is env 0). */

#include <inc/lib.h>

void
umain(int argc, char **argv) {
  800025:	f3 0f 1e fa          	endbr64
  800029:	55                   	push   %rbp
  80002a:	48 89 e5             	mov    %rsp,%rbp
  80002d:	41 56                	push   %r14
  80002f:	41 55                	push   %r13
  800031:	41 54                	push   %r12
  800033:	53                   	push   %rbx
  800034:	48 83 ec 10          	sub    $0x10,%rsp
    envid_t who, id;

    id = sys_getenvid();
  800038:	48 b8 0f 11 80 00 00 	movabs $0x80110f,%rax
  80003f:	00 00 00 
  800042:	ff d0                	call   *%rax
  800044:	89 c3                	mov    %eax,%ebx

    if (thisenv == &envs[1]) {
  800046:	48 ba 00 50 80 00 00 	movabs $0x805000,%rdx
  80004d:	00 00 00 
  800050:	48 b8 30 01 a0 1f 80 	movabs $0x801fa00130,%rax
  800057:	00 00 00 
  80005a:	48 39 02             	cmp    %rax,(%rdx)
  80005d:	74 5e                	je     8000bd <umain+0x98>
        while (1) {
            ipc_recv(&who, NULL, NULL, NULL);
            cprintf("%x recv from %x\n", id, who);
        }
    } else {
        cprintf("%x loop sending to %x\n", id, envs[1].env_id);
  80005f:	48 b8 f8 01 a0 1f 80 	movabs $0x801fa001f8,%rax
  800066:	00 00 00 
  800069:	8b 10                	mov    (%rax),%edx
  80006b:	89 de                	mov    %ebx,%esi
  80006d:	48 bf 11 30 80 00 00 	movabs $0x803011,%rdi
  800074:	00 00 00 
  800077:	b8 00 00 00 00       	mov    $0x0,%eax
  80007c:	48 b9 91 02 80 00 00 	movabs $0x800291,%rcx
  800083:	00 00 00 
  800086:	ff d1                	call   *%rcx
        while (1)
            ipc_send(envs[1].env_id, 0, NULL, 0, 0);
  800088:	49 bc 00 00 a0 1f 80 	movabs $0x801fa00000,%r12
  80008f:	00 00 00 
  800092:	48 bb 3c 16 80 00 00 	movabs $0x80163c,%rbx
  800099:	00 00 00 
  80009c:	41 8b bc 24 f8 01 00 	mov    0x1f8(%r12),%edi
  8000a3:	00 
  8000a4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8000aa:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000af:	ba 00 00 00 00       	mov    $0x0,%edx
  8000b4:	be 00 00 00 00       	mov    $0x0,%esi
  8000b9:	ff d3                	call   *%rbx
        while (1)
  8000bb:	eb df                	jmp    80009c <umain+0x77>
            ipc_recv(&who, NULL, NULL, NULL);
  8000bd:	49 be a3 15 80 00 00 	movabs $0x8015a3,%r14
  8000c4:	00 00 00 
            cprintf("%x recv from %x\n", id, who);
  8000c7:	49 bd 00 30 80 00 00 	movabs $0x803000,%r13
  8000ce:	00 00 00 
  8000d1:	49 bc 91 02 80 00 00 	movabs $0x800291,%r12
  8000d8:	00 00 00 
            ipc_recv(&who, NULL, NULL, NULL);
  8000db:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8000e5:	be 00 00 00 00       	mov    $0x0,%esi
  8000ea:	48 8d 7d dc          	lea    -0x24(%rbp),%rdi
  8000ee:	41 ff d6             	call   *%r14
            cprintf("%x recv from %x\n", id, who);
  8000f1:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8000f4:	89 de                	mov    %ebx,%esi
  8000f6:	4c 89 ef             	mov    %r13,%rdi
  8000f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8000fe:	41 ff d4             	call   *%r12
        while (1) {
  800101:	eb d8                	jmp    8000db <umain+0xb6>

0000000000800103 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  800103:	f3 0f 1e fa          	endbr64
  800107:	55                   	push   %rbp
  800108:	48 89 e5             	mov    %rsp,%rbp
  80010b:	41 56                	push   %r14
  80010d:	41 55                	push   %r13
  80010f:	41 54                	push   %r12
  800111:	53                   	push   %rbx
  800112:	41 89 fd             	mov    %edi,%r13d
  800115:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
     * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  800118:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  80011f:	00 00 00 
  800122:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  800129:	00 00 00 
  80012c:	48 39 c2             	cmp    %rax,%rdx
  80012f:	73 17                	jae    800148 <libmain+0x45>
    void (**ctor)() = &__ctors_start;
  800131:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  800134:	49 89 c4             	mov    %rax,%r12
  800137:	48 83 c3 08          	add    $0x8,%rbx
  80013b:	b8 00 00 00 00       	mov    $0x0,%eax
  800140:	ff 53 f8             	call   *-0x8(%rbx)
  800143:	4c 39 e3             	cmp    %r12,%rbx
  800146:	72 ef                	jb     800137 <libmain+0x34>

    /* Set thisenv to point at our Env structure in envs[]. */

    // LAB 8: Your code here
    thisenv = &((struct Env *)UENVS)[ENVX(sys_getenvid())];
  800148:	48 b8 0f 11 80 00 00 	movabs $0x80110f,%rax
  80014f:	00 00 00 
  800152:	ff d0                	call   *%rax
  800154:	25 ff 03 00 00       	and    $0x3ff,%eax
  800159:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  80015d:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  800161:	48 c1 e0 04          	shl    $0x4,%rax
  800165:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  80016c:	00 00 00 
  80016f:	48 01 d0             	add    %rdx,%rax
  800172:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  800179:	00 00 00 

    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  80017c:	45 85 ed             	test   %r13d,%r13d
  80017f:	7e 0d                	jle    80018e <libmain+0x8b>
  800181:	49 8b 06             	mov    (%r14),%rax
  800184:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  80018b:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  80018e:	4c 89 f6             	mov    %r14,%rsi
  800191:	44 89 ef             	mov    %r13d,%edi
  800194:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  80019b:	00 00 00 
  80019e:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  8001a0:	48 b8 b5 01 80 00 00 	movabs $0x8001b5,%rax
  8001a7:	00 00 00 
  8001aa:	ff d0                	call   *%rax
#endif
}
  8001ac:	5b                   	pop    %rbx
  8001ad:	41 5c                	pop    %r12
  8001af:	41 5d                	pop    %r13
  8001b1:	41 5e                	pop    %r14
  8001b3:	5d                   	pop    %rbp
  8001b4:	c3                   	ret

00000000008001b5 <exit>:

#include <inc/lib.h>

void
exit(void) {
  8001b5:	f3 0f 1e fa          	endbr64
  8001b9:	55                   	push   %rbp
  8001ba:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  8001bd:	48 b8 9e 19 80 00 00 	movabs $0x80199e,%rax
  8001c4:	00 00 00 
  8001c7:	ff d0                	call   *%rax
    sys_env_destroy(0);
  8001c9:	bf 00 00 00 00       	mov    $0x0,%edi
  8001ce:	48 b8 a0 10 80 00 00 	movabs $0x8010a0,%rax
  8001d5:	00 00 00 
  8001d8:	ff d0                	call   *%rax
}
  8001da:	5d                   	pop    %rbp
  8001db:	c3                   	ret

00000000008001dc <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  8001dc:	f3 0f 1e fa          	endbr64
  8001e0:	55                   	push   %rbp
  8001e1:	48 89 e5             	mov    %rsp,%rbp
  8001e4:	53                   	push   %rbx
  8001e5:	48 83 ec 08          	sub    $0x8,%rsp
  8001e9:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  8001ec:	8b 06                	mov    (%rsi),%eax
  8001ee:	8d 50 01             	lea    0x1(%rax),%edx
  8001f1:	89 16                	mov    %edx,(%rsi)
  8001f3:	48 98                	cltq
  8001f5:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  8001fa:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  800200:	74 0a                	je     80020c <putch+0x30>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  800202:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  800206:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80020a:	c9                   	leave
  80020b:	c3                   	ret
        sys_cputs(state->buf, state->offset);
  80020c:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  800210:	be ff 00 00 00       	mov    $0xff,%esi
  800215:	48 b8 3a 10 80 00 00 	movabs $0x80103a,%rax
  80021c:	00 00 00 
  80021f:	ff d0                	call   *%rax
        state->offset = 0;
  800221:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  800227:	eb d9                	jmp    800202 <putch+0x26>

0000000000800229 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  800229:	f3 0f 1e fa          	endbr64
  80022d:	55                   	push   %rbp
  80022e:	48 89 e5             	mov    %rsp,%rbp
  800231:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800238:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  80023b:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  800242:	b9 21 00 00 00       	mov    $0x21,%ecx
  800247:	b8 00 00 00 00       	mov    $0x0,%eax
  80024c:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  80024f:	48 89 f1             	mov    %rsi,%rcx
  800252:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  800259:	48 bf dc 01 80 00 00 	movabs $0x8001dc,%rdi
  800260:	00 00 00 
  800263:	48 b8 f1 03 80 00 00 	movabs $0x8003f1,%rax
  80026a:	00 00 00 
  80026d:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  80026f:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  800276:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  80027d:	48 b8 3a 10 80 00 00 	movabs $0x80103a,%rax
  800284:	00 00 00 
  800287:	ff d0                	call   *%rax

    return state.count;
}
  800289:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  80028f:	c9                   	leave
  800290:	c3                   	ret

0000000000800291 <cprintf>:

int
cprintf(const char *fmt, ...) {
  800291:	f3 0f 1e fa          	endbr64
  800295:	55                   	push   %rbp
  800296:	48 89 e5             	mov    %rsp,%rbp
  800299:	48 83 ec 50          	sub    $0x50,%rsp
  80029d:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  8002a1:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8002a5:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8002a9:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8002ad:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  8002b1:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  8002b8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002bc:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8002c0:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8002c4:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  8002c8:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  8002cc:	48 b8 29 02 80 00 00 	movabs $0x800229,%rax
  8002d3:	00 00 00 
  8002d6:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  8002d8:	c9                   	leave
  8002d9:	c3                   	ret

00000000008002da <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  8002da:	f3 0f 1e fa          	endbr64
  8002de:	55                   	push   %rbp
  8002df:	48 89 e5             	mov    %rsp,%rbp
  8002e2:	41 57                	push   %r15
  8002e4:	41 56                	push   %r14
  8002e6:	41 55                	push   %r13
  8002e8:	41 54                	push   %r12
  8002ea:	53                   	push   %rbx
  8002eb:	48 83 ec 18          	sub    $0x18,%rsp
  8002ef:	49 89 fc             	mov    %rdi,%r12
  8002f2:	49 89 f5             	mov    %rsi,%r13
  8002f5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  8002f9:	8b 45 10             	mov    0x10(%rbp),%eax
  8002fc:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  8002ff:	41 89 cf             	mov    %ecx,%r15d
  800302:	4c 39 fa             	cmp    %r15,%rdx
  800305:	73 5b                	jae    800362 <print_num+0x88>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  800307:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  80030b:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  80030f:	85 db                	test   %ebx,%ebx
  800311:	7e 0e                	jle    800321 <print_num+0x47>
            putch(padc, put_arg);
  800313:	4c 89 ee             	mov    %r13,%rsi
  800316:	44 89 f7             	mov    %r14d,%edi
  800319:	41 ff d4             	call   *%r12
        while (--width > 0) {
  80031c:	83 eb 01             	sub    $0x1,%ebx
  80031f:	75 f2                	jne    800313 <print_num+0x39>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  800321:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  800325:	48 b9 43 30 80 00 00 	movabs $0x803043,%rcx
  80032c:	00 00 00 
  80032f:	48 b8 32 30 80 00 00 	movabs $0x803032,%rax
  800336:	00 00 00 
  800339:	48 0f 45 c8          	cmovne %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  80033d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800341:	ba 00 00 00 00       	mov    $0x0,%edx
  800346:	49 f7 f7             	div    %r15
  800349:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  80034d:	4c 89 ee             	mov    %r13,%rsi
  800350:	41 ff d4             	call   *%r12
}
  800353:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800357:	5b                   	pop    %rbx
  800358:	41 5c                	pop    %r12
  80035a:	41 5d                	pop    %r13
  80035c:	41 5e                	pop    %r14
  80035e:	41 5f                	pop    %r15
  800360:	5d                   	pop    %rbp
  800361:	c3                   	ret
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  800362:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800366:	ba 00 00 00 00       	mov    $0x0,%edx
  80036b:	49 f7 f7             	div    %r15
  80036e:	48 83 ec 08          	sub    $0x8,%rsp
  800372:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  800376:	52                   	push   %rdx
  800377:	45 0f be c9          	movsbl %r9b,%r9d
  80037b:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  80037f:	48 89 c2             	mov    %rax,%rdx
  800382:	48 b8 da 02 80 00 00 	movabs $0x8002da,%rax
  800389:	00 00 00 
  80038c:	ff d0                	call   *%rax
  80038e:	48 83 c4 10          	add    $0x10,%rsp
  800392:	eb 8d                	jmp    800321 <print_num+0x47>

0000000000800394 <sprintputch>:
    char *end;
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
  800394:	f3 0f 1e fa          	endbr64
    state->count++;
  800398:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  80039c:	48 8b 06             	mov    (%rsi),%rax
  80039f:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  8003a3:	73 0a                	jae    8003af <sprintputch+0x1b>
        *state->start++ = ch;
  8003a5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8003a9:	48 89 16             	mov    %rdx,(%rsi)
  8003ac:	40 88 38             	mov    %dil,(%rax)
    }
}
  8003af:	c3                   	ret

00000000008003b0 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  8003b0:	f3 0f 1e fa          	endbr64
  8003b4:	55                   	push   %rbp
  8003b5:	48 89 e5             	mov    %rsp,%rbp
  8003b8:	48 83 ec 50          	sub    $0x50,%rsp
  8003bc:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8003c0:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8003c4:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  8003c8:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  8003cf:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8003d3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8003d7:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8003db:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  8003df:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  8003e3:	48 b8 f1 03 80 00 00 	movabs $0x8003f1,%rax
  8003ea:	00 00 00 
  8003ed:	ff d0                	call   *%rax
}
  8003ef:	c9                   	leave
  8003f0:	c3                   	ret

00000000008003f1 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  8003f1:	f3 0f 1e fa          	endbr64
  8003f5:	55                   	push   %rbp
  8003f6:	48 89 e5             	mov    %rsp,%rbp
  8003f9:	41 57                	push   %r15
  8003fb:	41 56                	push   %r14
  8003fd:	41 55                	push   %r13
  8003ff:	41 54                	push   %r12
  800401:	53                   	push   %rbx
  800402:	48 83 ec 38          	sub    $0x38,%rsp
  800406:	49 89 fe             	mov    %rdi,%r14
  800409:	49 89 f5             	mov    %rsi,%r13
  80040c:	48 89 d3             	mov    %rdx,%rbx
    va_copy(aq, ap);
  80040f:	48 8b 01             	mov    (%rcx),%rax
  800412:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  800416:	48 8b 41 08          	mov    0x8(%rcx),%rax
  80041a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80041e:	48 8b 41 10          	mov    0x10(%rcx),%rax
  800422:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  800426:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  80042a:	0f b6 3b             	movzbl (%rbx),%edi
  80042d:	40 80 ff 25          	cmp    $0x25,%dil
  800431:	74 18                	je     80044b <vprintfmt+0x5a>
            if (!ch) return;
  800433:	40 84 ff             	test   %dil,%dil
  800436:	0f 84 b2 06 00 00    	je     800aee <vprintfmt+0x6fd>
            putch(ch, put_arg);
  80043c:	40 0f b6 ff          	movzbl %dil,%edi
  800440:	4c 89 ee             	mov    %r13,%rsi
  800443:	41 ff d6             	call   *%r14
        while ((ch = *ufmt++) != '%') {
  800446:	4c 89 e3             	mov    %r12,%rbx
  800449:	eb db                	jmp    800426 <vprintfmt+0x35>
        bool altflag = 0, zflag = 0;
  80044b:	be 00 00 00 00       	mov    $0x0,%esi
  800450:	c6 45 ab 00          	movb   $0x0,-0x55(%rbp)
        unsigned lflag = 0, base = 10;
  800454:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  800459:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  80045f:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  800466:	c6 45 aa 20          	movb   $0x20,-0x56(%rbp)
        switch (ch = *ufmt++) {
  80046a:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  80046f:	41 0f b6 04 24       	movzbl (%r12),%eax
  800474:	88 45 a0             	mov    %al,-0x60(%rbp)
  800477:	83 e8 23             	sub    $0x23,%eax
  80047a:	3c 57                	cmp    $0x57,%al
  80047c:	0f 87 52 06 00 00    	ja     800ad4 <vprintfmt+0x6e3>
  800482:	0f b6 c0             	movzbl %al,%eax
  800485:	48 b9 80 32 80 00 00 	movabs $0x803280,%rcx
  80048c:	00 00 00 
  80048f:	3e ff 24 c1          	notrack jmp *(%rcx,%rax,8)
  800493:	49 89 dc             	mov    %rbx,%r12
            altflag = 1;
  800496:	c6 45 ab 01          	movb   $0x1,-0x55(%rbp)
  80049a:	eb ce                	jmp    80046a <vprintfmt+0x79>
        switch (ch = *ufmt++) {
  80049c:	49 89 dc             	mov    %rbx,%r12
  80049f:	be 01 00 00 00       	mov    $0x1,%esi
  8004a4:	eb c4                	jmp    80046a <vprintfmt+0x79>
            padc = ch;
  8004a6:	0f b6 45 a0          	movzbl -0x60(%rbp),%eax
  8004aa:	88 45 aa             	mov    %al,-0x56(%rbp)
        switch (ch = *ufmt++) {
  8004ad:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  8004b0:	eb b8                	jmp    80046a <vprintfmt+0x79>
            precision = va_arg(aq, int);
  8004b2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8004b5:	83 f8 2f             	cmp    $0x2f,%eax
  8004b8:	77 24                	ja     8004de <vprintfmt+0xed>
  8004ba:	89 c1                	mov    %eax,%ecx
  8004bc:	48 03 4d c8          	add    -0x38(%rbp),%rcx
  8004c0:	83 c0 08             	add    $0x8,%eax
  8004c3:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8004c6:	44 8b 39             	mov    (%rcx),%r15d
        switch (ch = *ufmt++) {
  8004c9:	49 89 dc             	mov    %rbx,%r12
            if (width < 0) {
  8004cc:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8004d0:	79 98                	jns    80046a <vprintfmt+0x79>
                width = precision;
  8004d2:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
                precision = -1;
  8004d6:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  8004dc:	eb 8c                	jmp    80046a <vprintfmt+0x79>
            precision = va_arg(aq, int);
  8004de:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8004e2:	48 8d 41 08          	lea    0x8(%rcx),%rax
  8004e6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8004ea:	eb da                	jmp    8004c6 <vprintfmt+0xd5>
                precision = precision * 10 + ch - '0';
  8004ec:	44 0f b6 7d a0       	movzbl -0x60(%rbp),%r15d
  8004f1:	41 83 ef 30          	sub    $0x30,%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  8004f5:	41 0f b6 44 24 01    	movzbl 0x1(%r12),%eax
  8004fb:	3c 39                	cmp    $0x39,%al
  8004fd:	77 1c                	ja     80051b <vprintfmt+0x12a>
            for (precision = 0;; ++ufmt) {
  8004ff:	48 83 c3 01          	add    $0x1,%rbx
                precision = precision * 10 + ch - '0';
  800503:	43 8d 0c bf          	lea    (%r15,%r15,4),%ecx
  800507:	0f b6 c0             	movzbl %al,%eax
  80050a:	44 8d 7c 48 d0       	lea    -0x30(%rax,%rcx,2),%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  80050f:	0f b6 03             	movzbl (%rbx),%eax
  800512:	3c 39                	cmp    $0x39,%al
  800514:	76 e9                	jbe    8004ff <vprintfmt+0x10e>
        process_precision:
  800516:	49 89 dc             	mov    %rbx,%r12
  800519:	eb b1                	jmp    8004cc <vprintfmt+0xdb>
        switch (ch = *ufmt++) {
  80051b:	49 89 dc             	mov    %rbx,%r12
  80051e:	eb ac                	jmp    8004cc <vprintfmt+0xdb>
            width = MAX(0, width);
  800520:	8b 4d ac             	mov    -0x54(%rbp),%ecx
  800523:	85 c9                	test   %ecx,%ecx
  800525:	b8 00 00 00 00       	mov    $0x0,%eax
  80052a:	0f 49 c1             	cmovns %ecx,%eax
  80052d:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  800530:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  800533:	e9 32 ff ff ff       	jmp    80046a <vprintfmt+0x79>
            lflag++;
  800538:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  80053b:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  80053e:	e9 27 ff ff ff       	jmp    80046a <vprintfmt+0x79>
            putch(va_arg(aq, int), put_arg);
  800543:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800546:	83 f8 2f             	cmp    $0x2f,%eax
  800549:	77 19                	ja     800564 <vprintfmt+0x173>
  80054b:	89 c2                	mov    %eax,%edx
  80054d:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800551:	83 c0 08             	add    $0x8,%eax
  800554:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800557:	8b 3a                	mov    (%rdx),%edi
  800559:	4c 89 ee             	mov    %r13,%rsi
  80055c:	41 ff d6             	call   *%r14
            break;
  80055f:	e9 c2 fe ff ff       	jmp    800426 <vprintfmt+0x35>
            putch(va_arg(aq, int), put_arg);
  800564:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800568:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80056c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800570:	eb e5                	jmp    800557 <vprintfmt+0x166>
            int err = va_arg(aq, int);
  800572:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800575:	83 f8 2f             	cmp    $0x2f,%eax
  800578:	77 5a                	ja     8005d4 <vprintfmt+0x1e3>
  80057a:	89 c2                	mov    %eax,%edx
  80057c:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800580:	83 c0 08             	add    $0x8,%eax
  800583:	89 45 b8             	mov    %eax,-0x48(%rbp)
            if (err < 0) err = -err;
  800586:	8b 02                	mov    (%rdx),%eax
  800588:	89 c1                	mov    %eax,%ecx
  80058a:	f7 d9                	neg    %ecx
  80058c:	0f 48 c8             	cmovs  %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  80058f:	83 f9 13             	cmp    $0x13,%ecx
  800592:	7f 4e                	jg     8005e2 <vprintfmt+0x1f1>
  800594:	48 63 c1             	movslq %ecx,%rax
  800597:	48 ba 40 35 80 00 00 	movabs $0x803540,%rdx
  80059e:	00 00 00 
  8005a1:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8005a5:	48 85 c0             	test   %rax,%rax
  8005a8:	74 38                	je     8005e2 <vprintfmt+0x1f1>
                printfmt(putch, put_arg, "%s", strerr);
  8005aa:	48 89 c1             	mov    %rax,%rcx
  8005ad:	48 ba 4c 32 80 00 00 	movabs $0x80324c,%rdx
  8005b4:	00 00 00 
  8005b7:	4c 89 ee             	mov    %r13,%rsi
  8005ba:	4c 89 f7             	mov    %r14,%rdi
  8005bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8005c2:	49 b8 b0 03 80 00 00 	movabs $0x8003b0,%r8
  8005c9:	00 00 00 
  8005cc:	41 ff d0             	call   *%r8
  8005cf:	e9 52 fe ff ff       	jmp    800426 <vprintfmt+0x35>
            int err = va_arg(aq, int);
  8005d4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8005d8:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8005dc:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8005e0:	eb a4                	jmp    800586 <vprintfmt+0x195>
                printfmt(putch, put_arg, "error %d", err);
  8005e2:	48 ba 5b 30 80 00 00 	movabs $0x80305b,%rdx
  8005e9:	00 00 00 
  8005ec:	4c 89 ee             	mov    %r13,%rsi
  8005ef:	4c 89 f7             	mov    %r14,%rdi
  8005f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8005f7:	49 b8 b0 03 80 00 00 	movabs $0x8003b0,%r8
  8005fe:	00 00 00 
  800601:	41 ff d0             	call   *%r8
  800604:	e9 1d fe ff ff       	jmp    800426 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  800609:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80060c:	83 f8 2f             	cmp    $0x2f,%eax
  80060f:	77 6c                	ja     80067d <vprintfmt+0x28c>
  800611:	89 c2                	mov    %eax,%edx
  800613:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800617:	83 c0 08             	add    $0x8,%eax
  80061a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80061d:	48 8b 12             	mov    (%rdx),%rdx
            if (!ptr) ptr = "(null)";
  800620:	48 85 d2             	test   %rdx,%rdx
  800623:	48 b8 54 30 80 00 00 	movabs $0x803054,%rax
  80062a:	00 00 00 
  80062d:	48 0f 45 c2          	cmovne %rdx,%rax
  800631:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
            if (width > 0 && padc != '-') {
  800635:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800639:	7e 06                	jle    800641 <vprintfmt+0x250>
  80063b:	80 7d aa 2d          	cmpb   $0x2d,-0x56(%rbp)
  80063f:	75 4a                	jne    80068b <vprintfmt+0x29a>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800641:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800645:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800649:	0f b6 00             	movzbl (%rax),%eax
  80064c:	84 c0                	test   %al,%al
  80064e:	0f 85 9a 00 00 00    	jne    8006ee <vprintfmt+0x2fd>
            while (width-- > 0) putch(' ', put_arg);
  800654:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800657:	44 8d 60 ff          	lea    -0x1(%rax),%r12d
  80065b:	85 c0                	test   %eax,%eax
  80065d:	0f 8e c3 fd ff ff    	jle    800426 <vprintfmt+0x35>
  800663:	4c 89 ee             	mov    %r13,%rsi
  800666:	bf 20 00 00 00       	mov    $0x20,%edi
  80066b:	41 ff d6             	call   *%r14
  80066e:	41 83 ec 01          	sub    $0x1,%r12d
  800672:	41 83 fc ff          	cmp    $0xffffffff,%r12d
  800676:	75 eb                	jne    800663 <vprintfmt+0x272>
  800678:	e9 a9 fd ff ff       	jmp    800426 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  80067d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800681:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800685:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800689:	eb 92                	jmp    80061d <vprintfmt+0x22c>
                width -= strnlen(ptr, precision);
  80068b:	49 63 f7             	movslq %r15d,%rsi
  80068e:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  800692:	48 b8 b4 0b 80 00 00 	movabs $0x800bb4,%rax
  800699:	00 00 00 
  80069c:	ff d0                	call   *%rax
  80069e:	48 89 c2             	mov    %rax,%rdx
  8006a1:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8006a4:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  8006a6:	8d 70 ff             	lea    -0x1(%rax),%esi
  8006a9:	89 75 ac             	mov    %esi,-0x54(%rbp)
  8006ac:	85 c0                	test   %eax,%eax
  8006ae:	7e 91                	jle    800641 <vprintfmt+0x250>
  8006b0:	44 0f be 65 aa       	movsbl -0x56(%rbp),%r12d
  8006b5:	4c 89 ee             	mov    %r13,%rsi
  8006b8:	44 89 e7             	mov    %r12d,%edi
  8006bb:	41 ff d6             	call   *%r14
  8006be:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  8006c2:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8006c5:	83 f8 ff             	cmp    $0xffffffff,%eax
  8006c8:	75 eb                	jne    8006b5 <vprintfmt+0x2c4>
  8006ca:	e9 72 ff ff ff       	jmp    800641 <vprintfmt+0x250>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  8006cf:	0f b6 f8             	movzbl %al,%edi
  8006d2:	4c 89 ee             	mov    %r13,%rsi
  8006d5:	41 ff d6             	call   *%r14
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  8006d8:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  8006dc:	49 83 c4 01          	add    $0x1,%r12
  8006e0:	41 0f b6 44 24 ff    	movzbl -0x1(%r12),%eax
  8006e6:	84 c0                	test   %al,%al
  8006e8:	0f 84 66 ff ff ff    	je     800654 <vprintfmt+0x263>
  8006ee:	45 85 ff             	test   %r15d,%r15d
  8006f1:	78 0a                	js     8006fd <vprintfmt+0x30c>
  8006f3:	41 83 ef 01          	sub    $0x1,%r15d
  8006f7:	0f 88 57 ff ff ff    	js     800654 <vprintfmt+0x263>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  8006fd:	80 7d ab 00          	cmpb   $0x0,-0x55(%rbp)
  800701:	74 cc                	je     8006cf <vprintfmt+0x2de>
  800703:	8d 50 e0             	lea    -0x20(%rax),%edx
  800706:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80070b:	80 fa 5e             	cmp    $0x5e,%dl
  80070e:	77 c2                	ja     8006d2 <vprintfmt+0x2e1>
  800710:	eb bd                	jmp    8006cf <vprintfmt+0x2de>
    if (zflag) return va_arg(*ap, size_t);
  800712:	40 84 f6             	test   %sil,%sil
  800715:	75 26                	jne    80073d <vprintfmt+0x34c>
    switch (lflag) {
  800717:	85 d2                	test   %edx,%edx
  800719:	74 59                	je     800774 <vprintfmt+0x383>
  80071b:	83 fa 01             	cmp    $0x1,%edx
  80071e:	74 7b                	je     80079b <vprintfmt+0x3aa>
        return va_arg(*ap, long long);
  800720:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800723:	83 f8 2f             	cmp    $0x2f,%eax
  800726:	0f 87 96 00 00 00    	ja     8007c2 <vprintfmt+0x3d1>
  80072c:	89 c2                	mov    %eax,%edx
  80072e:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800732:	83 c0 08             	add    $0x8,%eax
  800735:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800738:	4c 8b 22             	mov    (%rdx),%r12
  80073b:	eb 17                	jmp    800754 <vprintfmt+0x363>
    if (zflag) return va_arg(*ap, size_t);
  80073d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800740:	83 f8 2f             	cmp    $0x2f,%eax
  800743:	77 21                	ja     800766 <vprintfmt+0x375>
  800745:	89 c2                	mov    %eax,%edx
  800747:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80074b:	83 c0 08             	add    $0x8,%eax
  80074e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800751:	4c 8b 22             	mov    (%rdx),%r12
            if (i < 0) {
  800754:	4d 85 e4             	test   %r12,%r12
  800757:	78 7a                	js     8007d3 <vprintfmt+0x3e2>
            num = i;
  800759:	4c 89 e2             	mov    %r12,%rdx
        unsigned lflag = 0, base = 10;
  80075c:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  800761:	e9 50 02 00 00       	jmp    8009b6 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800766:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80076a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80076e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800772:	eb dd                	jmp    800751 <vprintfmt+0x360>
        return va_arg(*ap, int);
  800774:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800777:	83 f8 2f             	cmp    $0x2f,%eax
  80077a:	77 11                	ja     80078d <vprintfmt+0x39c>
  80077c:	89 c2                	mov    %eax,%edx
  80077e:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800782:	83 c0 08             	add    $0x8,%eax
  800785:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800788:	4c 63 22             	movslq (%rdx),%r12
  80078b:	eb c7                	jmp    800754 <vprintfmt+0x363>
  80078d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800791:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800795:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800799:	eb ed                	jmp    800788 <vprintfmt+0x397>
        return va_arg(*ap, long);
  80079b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80079e:	83 f8 2f             	cmp    $0x2f,%eax
  8007a1:	77 11                	ja     8007b4 <vprintfmt+0x3c3>
  8007a3:	89 c2                	mov    %eax,%edx
  8007a5:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8007a9:	83 c0 08             	add    $0x8,%eax
  8007ac:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007af:	4c 8b 22             	mov    (%rdx),%r12
  8007b2:	eb a0                	jmp    800754 <vprintfmt+0x363>
  8007b4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007b8:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8007bc:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007c0:	eb ed                	jmp    8007af <vprintfmt+0x3be>
        return va_arg(*ap, long long);
  8007c2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007c6:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8007ca:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007ce:	e9 65 ff ff ff       	jmp    800738 <vprintfmt+0x347>
                putch('-', put_arg);
  8007d3:	4c 89 ee             	mov    %r13,%rsi
  8007d6:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8007db:	41 ff d6             	call   *%r14
                i = -i;
  8007de:	49 f7 dc             	neg    %r12
  8007e1:	e9 73 ff ff ff       	jmp    800759 <vprintfmt+0x368>
    if (zflag) return va_arg(*ap, size_t);
  8007e6:	40 84 f6             	test   %sil,%sil
  8007e9:	75 32                	jne    80081d <vprintfmt+0x42c>
    switch (lflag) {
  8007eb:	85 d2                	test   %edx,%edx
  8007ed:	74 5d                	je     80084c <vprintfmt+0x45b>
  8007ef:	83 fa 01             	cmp    $0x1,%edx
  8007f2:	0f 84 82 00 00 00    	je     80087a <vprintfmt+0x489>
        return va_arg(*ap, unsigned long long);
  8007f8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007fb:	83 f8 2f             	cmp    $0x2f,%eax
  8007fe:	0f 87 a5 00 00 00    	ja     8008a9 <vprintfmt+0x4b8>
  800804:	89 c2                	mov    %eax,%edx
  800806:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80080a:	83 c0 08             	add    $0x8,%eax
  80080d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800810:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800813:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  800818:	e9 99 01 00 00       	jmp    8009b6 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  80081d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800820:	83 f8 2f             	cmp    $0x2f,%eax
  800823:	77 19                	ja     80083e <vprintfmt+0x44d>
  800825:	89 c2                	mov    %eax,%edx
  800827:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80082b:	83 c0 08             	add    $0x8,%eax
  80082e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800831:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800834:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800839:	e9 78 01 00 00       	jmp    8009b6 <vprintfmt+0x5c5>
  80083e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800842:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800846:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80084a:	eb e5                	jmp    800831 <vprintfmt+0x440>
        return va_arg(*ap, unsigned int);
  80084c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80084f:	83 f8 2f             	cmp    $0x2f,%eax
  800852:	77 18                	ja     80086c <vprintfmt+0x47b>
  800854:	89 c2                	mov    %eax,%edx
  800856:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80085a:	83 c0 08             	add    $0x8,%eax
  80085d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800860:	8b 12                	mov    (%rdx),%edx
        unsigned lflag = 0, base = 10;
  800862:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  800867:	e9 4a 01 00 00       	jmp    8009b6 <vprintfmt+0x5c5>
  80086c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800870:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800874:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800878:	eb e6                	jmp    800860 <vprintfmt+0x46f>
        return va_arg(*ap, unsigned long);
  80087a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80087d:	83 f8 2f             	cmp    $0x2f,%eax
  800880:	77 19                	ja     80089b <vprintfmt+0x4aa>
  800882:	89 c2                	mov    %eax,%edx
  800884:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800888:	83 c0 08             	add    $0x8,%eax
  80088b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80088e:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800891:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  800896:	e9 1b 01 00 00       	jmp    8009b6 <vprintfmt+0x5c5>
  80089b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80089f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8008a3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008a7:	eb e5                	jmp    80088e <vprintfmt+0x49d>
        return va_arg(*ap, unsigned long long);
  8008a9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008ad:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8008b1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008b5:	e9 56 ff ff ff       	jmp    800810 <vprintfmt+0x41f>
    if (zflag) return va_arg(*ap, size_t);
  8008ba:	40 84 f6             	test   %sil,%sil
  8008bd:	75 2e                	jne    8008ed <vprintfmt+0x4fc>
    switch (lflag) {
  8008bf:	85 d2                	test   %edx,%edx
  8008c1:	74 59                	je     80091c <vprintfmt+0x52b>
  8008c3:	83 fa 01             	cmp    $0x1,%edx
  8008c6:	74 7f                	je     800947 <vprintfmt+0x556>
        return va_arg(*ap, unsigned long long);
  8008c8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008cb:	83 f8 2f             	cmp    $0x2f,%eax
  8008ce:	0f 87 9f 00 00 00    	ja     800973 <vprintfmt+0x582>
  8008d4:	89 c2                	mov    %eax,%edx
  8008d6:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8008da:	83 c0 08             	add    $0x8,%eax
  8008dd:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008e0:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  8008e3:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  8008e8:	e9 c9 00 00 00       	jmp    8009b6 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8008ed:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008f0:	83 f8 2f             	cmp    $0x2f,%eax
  8008f3:	77 19                	ja     80090e <vprintfmt+0x51d>
  8008f5:	89 c2                	mov    %eax,%edx
  8008f7:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8008fb:	83 c0 08             	add    $0x8,%eax
  8008fe:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800901:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800904:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800909:	e9 a8 00 00 00       	jmp    8009b6 <vprintfmt+0x5c5>
  80090e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800912:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800916:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80091a:	eb e5                	jmp    800901 <vprintfmt+0x510>
        return va_arg(*ap, unsigned int);
  80091c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80091f:	83 f8 2f             	cmp    $0x2f,%eax
  800922:	77 15                	ja     800939 <vprintfmt+0x548>
  800924:	89 c2                	mov    %eax,%edx
  800926:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80092a:	83 c0 08             	add    $0x8,%eax
  80092d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800930:	8b 12                	mov    (%rdx),%edx
            base = 8;
  800932:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  800937:	eb 7d                	jmp    8009b6 <vprintfmt+0x5c5>
  800939:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80093d:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800941:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800945:	eb e9                	jmp    800930 <vprintfmt+0x53f>
        return va_arg(*ap, unsigned long);
  800947:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80094a:	83 f8 2f             	cmp    $0x2f,%eax
  80094d:	77 16                	ja     800965 <vprintfmt+0x574>
  80094f:	89 c2                	mov    %eax,%edx
  800951:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800955:	83 c0 08             	add    $0x8,%eax
  800958:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80095b:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  80095e:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  800963:	eb 51                	jmp    8009b6 <vprintfmt+0x5c5>
  800965:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800969:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80096d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800971:	eb e8                	jmp    80095b <vprintfmt+0x56a>
        return va_arg(*ap, unsigned long long);
  800973:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800977:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80097b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80097f:	e9 5c ff ff ff       	jmp    8008e0 <vprintfmt+0x4ef>
            putch('0', put_arg);
  800984:	4c 89 ee             	mov    %r13,%rsi
  800987:	bf 30 00 00 00       	mov    $0x30,%edi
  80098c:	41 ff d6             	call   *%r14
            putch('x', put_arg);
  80098f:	4c 89 ee             	mov    %r13,%rsi
  800992:	bf 78 00 00 00       	mov    $0x78,%edi
  800997:	41 ff d6             	call   *%r14
            num = (uintptr_t)va_arg(aq, void *);
  80099a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80099d:	83 f8 2f             	cmp    $0x2f,%eax
  8009a0:	77 47                	ja     8009e9 <vprintfmt+0x5f8>
  8009a2:	89 c2                	mov    %eax,%edx
  8009a4:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8009a8:	83 c0 08             	add    $0x8,%eax
  8009ab:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009ae:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  8009b1:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  8009b6:	48 83 ec 08          	sub    $0x8,%rsp
  8009ba:	80 7d a0 58          	cmpb   $0x58,-0x60(%rbp)
  8009be:	0f 94 c0             	sete   %al
  8009c1:	0f b6 c0             	movzbl %al,%eax
  8009c4:	50                   	push   %rax
  8009c5:	44 0f be 4d aa       	movsbl -0x56(%rbp),%r9d
  8009ca:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  8009ce:	4c 89 ee             	mov    %r13,%rsi
  8009d1:	4c 89 f7             	mov    %r14,%rdi
  8009d4:	48 b8 da 02 80 00 00 	movabs $0x8002da,%rax
  8009db:	00 00 00 
  8009de:	ff d0                	call   *%rax
            break;
  8009e0:	48 83 c4 10          	add    $0x10,%rsp
  8009e4:	e9 3d fa ff ff       	jmp    800426 <vprintfmt+0x35>
            num = (uintptr_t)va_arg(aq, void *);
  8009e9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009ed:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009f1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009f5:	eb b7                	jmp    8009ae <vprintfmt+0x5bd>
    if (zflag) return va_arg(*ap, size_t);
  8009f7:	40 84 f6             	test   %sil,%sil
  8009fa:	75 2b                	jne    800a27 <vprintfmt+0x636>
    switch (lflag) {
  8009fc:	85 d2                	test   %edx,%edx
  8009fe:	74 56                	je     800a56 <vprintfmt+0x665>
  800a00:	83 fa 01             	cmp    $0x1,%edx
  800a03:	74 7f                	je     800a84 <vprintfmt+0x693>
        return va_arg(*ap, unsigned long long);
  800a05:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a08:	83 f8 2f             	cmp    $0x2f,%eax
  800a0b:	0f 87 a2 00 00 00    	ja     800ab3 <vprintfmt+0x6c2>
  800a11:	89 c2                	mov    %eax,%edx
  800a13:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a17:	83 c0 08             	add    $0x8,%eax
  800a1a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a1d:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800a20:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800a25:	eb 8f                	jmp    8009b6 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800a27:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a2a:	83 f8 2f             	cmp    $0x2f,%eax
  800a2d:	77 19                	ja     800a48 <vprintfmt+0x657>
  800a2f:	89 c2                	mov    %eax,%edx
  800a31:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a35:	83 c0 08             	add    $0x8,%eax
  800a38:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a3b:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800a3e:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800a43:	e9 6e ff ff ff       	jmp    8009b6 <vprintfmt+0x5c5>
  800a48:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a4c:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a50:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a54:	eb e5                	jmp    800a3b <vprintfmt+0x64a>
        return va_arg(*ap, unsigned int);
  800a56:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a59:	83 f8 2f             	cmp    $0x2f,%eax
  800a5c:	77 18                	ja     800a76 <vprintfmt+0x685>
  800a5e:	89 c2                	mov    %eax,%edx
  800a60:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a64:	83 c0 08             	add    $0x8,%eax
  800a67:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a6a:	8b 12                	mov    (%rdx),%edx
            base = 16;
  800a6c:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  800a71:	e9 40 ff ff ff       	jmp    8009b6 <vprintfmt+0x5c5>
  800a76:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a7a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a7e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a82:	eb e6                	jmp    800a6a <vprintfmt+0x679>
        return va_arg(*ap, unsigned long);
  800a84:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a87:	83 f8 2f             	cmp    $0x2f,%eax
  800a8a:	77 19                	ja     800aa5 <vprintfmt+0x6b4>
  800a8c:	89 c2                	mov    %eax,%edx
  800a8e:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a92:	83 c0 08             	add    $0x8,%eax
  800a95:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a98:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800a9b:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800aa0:	e9 11 ff ff ff       	jmp    8009b6 <vprintfmt+0x5c5>
  800aa5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800aa9:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800aad:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ab1:	eb e5                	jmp    800a98 <vprintfmt+0x6a7>
        return va_arg(*ap, unsigned long long);
  800ab3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ab7:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800abb:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800abf:	e9 59 ff ff ff       	jmp    800a1d <vprintfmt+0x62c>
            putch(ch, put_arg);
  800ac4:	4c 89 ee             	mov    %r13,%rsi
  800ac7:	bf 25 00 00 00       	mov    $0x25,%edi
  800acc:	41 ff d6             	call   *%r14
            break;
  800acf:	e9 52 f9 ff ff       	jmp    800426 <vprintfmt+0x35>
            putch('%', put_arg);
  800ad4:	4c 89 ee             	mov    %r13,%rsi
  800ad7:	bf 25 00 00 00       	mov    $0x25,%edi
  800adc:	41 ff d6             	call   *%r14
            while ((--ufmt)[-1] != '%') /* nothing */
  800adf:	48 83 eb 01          	sub    $0x1,%rbx
  800ae3:	80 7b ff 25          	cmpb   $0x25,-0x1(%rbx)
  800ae7:	75 f6                	jne    800adf <vprintfmt+0x6ee>
  800ae9:	e9 38 f9 ff ff       	jmp    800426 <vprintfmt+0x35>
}
  800aee:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800af2:	5b                   	pop    %rbx
  800af3:	41 5c                	pop    %r12
  800af5:	41 5d                	pop    %r13
  800af7:	41 5e                	pop    %r14
  800af9:	41 5f                	pop    %r15
  800afb:	5d                   	pop    %rbp
  800afc:	c3                   	ret

0000000000800afd <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800afd:	f3 0f 1e fa          	endbr64
  800b01:	55                   	push   %rbp
  800b02:	48 89 e5             	mov    %rsp,%rbp
  800b05:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800b09:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800b0d:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800b12:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800b16:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800b1d:	48 85 ff             	test   %rdi,%rdi
  800b20:	74 2b                	je     800b4d <vsnprintf+0x50>
  800b22:	48 85 f6             	test   %rsi,%rsi
  800b25:	74 26                	je     800b4d <vsnprintf+0x50>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800b27:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800b2b:	48 bf 94 03 80 00 00 	movabs $0x800394,%rdi
  800b32:	00 00 00 
  800b35:	48 b8 f1 03 80 00 00 	movabs $0x8003f1,%rax
  800b3c:	00 00 00 
  800b3f:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800b41:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b45:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800b48:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800b4b:	c9                   	leave
  800b4c:	c3                   	ret
    if (!buf || n < 1) return -E_INVAL;
  800b4d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b52:	eb f7                	jmp    800b4b <vsnprintf+0x4e>

0000000000800b54 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800b54:	f3 0f 1e fa          	endbr64
  800b58:	55                   	push   %rbp
  800b59:	48 89 e5             	mov    %rsp,%rbp
  800b5c:	48 83 ec 50          	sub    $0x50,%rsp
  800b60:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800b64:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800b68:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800b6c:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800b73:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800b77:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b7b:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800b7f:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800b83:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800b87:	48 b8 fd 0a 80 00 00 	movabs $0x800afd,%rax
  800b8e:	00 00 00 
  800b91:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800b93:	c9                   	leave
  800b94:	c3                   	ret

0000000000800b95 <strlen>:
 * Primespipe runs 3x faster this way */

#define ASM 1

size_t
strlen(const char *s) {
  800b95:	f3 0f 1e fa          	endbr64
    size_t n = 0;
    while (*s++) n++;
  800b99:	80 3f 00             	cmpb   $0x0,(%rdi)
  800b9c:	74 10                	je     800bae <strlen+0x19>
    size_t n = 0;
  800b9e:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800ba3:	48 83 c0 01          	add    $0x1,%rax
  800ba7:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800bab:	75 f6                	jne    800ba3 <strlen+0xe>
  800bad:	c3                   	ret
    size_t n = 0;
  800bae:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800bb3:	c3                   	ret

0000000000800bb4 <strnlen>:

size_t
strnlen(const char *s, size_t size) {
  800bb4:	f3 0f 1e fa          	endbr64
  800bb8:	48 89 f0             	mov    %rsi,%rax
    size_t n = 0;
  800bbb:	ba 00 00 00 00       	mov    $0x0,%edx
    while (n < size && *s++) n++;
  800bc0:	48 85 f6             	test   %rsi,%rsi
  800bc3:	74 10                	je     800bd5 <strnlen+0x21>
  800bc5:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  800bc9:	74 0b                	je     800bd6 <strnlen+0x22>
  800bcb:	48 83 c2 01          	add    $0x1,%rdx
  800bcf:	48 39 d0             	cmp    %rdx,%rax
  800bd2:	75 f1                	jne    800bc5 <strnlen+0x11>
  800bd4:	c3                   	ret
  800bd5:	c3                   	ret
  800bd6:	48 89 d0             	mov    %rdx,%rax
    return n;
}
  800bd9:	c3                   	ret

0000000000800bda <strcpy>:

char *
strcpy(char *dst, const char *src) {
  800bda:	f3 0f 1e fa          	endbr64
  800bde:	48 89 f8             	mov    %rdi,%rax
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800be1:	ba 00 00 00 00       	mov    $0x0,%edx
  800be6:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  800bea:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  800bed:	48 83 c2 01          	add    $0x1,%rdx
  800bf1:	84 c9                	test   %cl,%cl
  800bf3:	75 f1                	jne    800be6 <strcpy+0xc>
        ;
    return res;
}
  800bf5:	c3                   	ret

0000000000800bf6 <strcat>:

char *
strcat(char *dst, const char *src) {
  800bf6:	f3 0f 1e fa          	endbr64
  800bfa:	55                   	push   %rbp
  800bfb:	48 89 e5             	mov    %rsp,%rbp
  800bfe:	41 54                	push   %r12
  800c00:	53                   	push   %rbx
  800c01:	48 89 fb             	mov    %rdi,%rbx
  800c04:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800c07:	48 b8 95 0b 80 00 00 	movabs $0x800b95,%rax
  800c0e:	00 00 00 
  800c11:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800c13:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800c17:	4c 89 e6             	mov    %r12,%rsi
  800c1a:	48 b8 da 0b 80 00 00 	movabs $0x800bda,%rax
  800c21:	00 00 00 
  800c24:	ff d0                	call   *%rax
    return dst;
}
  800c26:	48 89 d8             	mov    %rbx,%rax
  800c29:	5b                   	pop    %rbx
  800c2a:	41 5c                	pop    %r12
  800c2c:	5d                   	pop    %rbp
  800c2d:	c3                   	ret

0000000000800c2e <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800c2e:	f3 0f 1e fa          	endbr64
  800c32:	48 89 f8             	mov    %rdi,%rax
    char *ret = dst;
    while (size-- > 0) {
  800c35:	48 85 d2             	test   %rdx,%rdx
  800c38:	74 1f                	je     800c59 <strncpy+0x2b>
  800c3a:	48 01 fa             	add    %rdi,%rdx
  800c3d:	48 89 f9             	mov    %rdi,%rcx
        *dst++ = *src;
  800c40:	48 83 c1 01          	add    $0x1,%rcx
  800c44:	44 0f b6 06          	movzbl (%rsi),%r8d
  800c48:	44 88 41 ff          	mov    %r8b,-0x1(%rcx)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800c4c:	41 80 f8 01          	cmp    $0x1,%r8b
  800c50:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800c54:	48 39 ca             	cmp    %rcx,%rdx
  800c57:	75 e7                	jne    800c40 <strncpy+0x12>
    }
    return ret;
}
  800c59:	c3                   	ret

0000000000800c5a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
  800c5a:	f3 0f 1e fa          	endbr64
    char *dst_in = dst;
    if (size) {
  800c5e:	48 89 f8             	mov    %rdi,%rax
  800c61:	48 85 d2             	test   %rdx,%rdx
  800c64:	74 24                	je     800c8a <strlcpy+0x30>
        while (--size > 0 && *src)
  800c66:	48 83 ea 01          	sub    $0x1,%rdx
  800c6a:	74 1b                	je     800c87 <strlcpy+0x2d>
  800c6c:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800c70:	0f b6 16             	movzbl (%rsi),%edx
  800c73:	84 d2                	test   %dl,%dl
  800c75:	74 10                	je     800c87 <strlcpy+0x2d>
            *dst++ = *src++;
  800c77:	48 83 c6 01          	add    $0x1,%rsi
  800c7b:	48 83 c0 01          	add    $0x1,%rax
  800c7f:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800c82:	48 39 c8             	cmp    %rcx,%rax
  800c85:	75 e9                	jne    800c70 <strlcpy+0x16>
        *dst = '\0';
  800c87:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800c8a:	48 29 f8             	sub    %rdi,%rax
}
  800c8d:	c3                   	ret

0000000000800c8e <strcmp>:
    }
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
  800c8e:	f3 0f 1e fa          	endbr64
    while (*p && *p == *q) p++, q++;
  800c92:	0f b6 07             	movzbl (%rdi),%eax
  800c95:	84 c0                	test   %al,%al
  800c97:	74 13                	je     800cac <strcmp+0x1e>
  800c99:	38 06                	cmp    %al,(%rsi)
  800c9b:	75 0f                	jne    800cac <strcmp+0x1e>
  800c9d:	48 83 c7 01          	add    $0x1,%rdi
  800ca1:	48 83 c6 01          	add    $0x1,%rsi
  800ca5:	0f b6 07             	movzbl (%rdi),%eax
  800ca8:	84 c0                	test   %al,%al
  800caa:	75 ed                	jne    800c99 <strcmp+0xb>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800cac:	0f b6 c0             	movzbl %al,%eax
  800caf:	0f b6 16             	movzbl (%rsi),%edx
  800cb2:	29 d0                	sub    %edx,%eax
}
  800cb4:	c3                   	ret

0000000000800cb5 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
  800cb5:	f3 0f 1e fa          	endbr64
    while (n && *p && *p == *q) n--, p++, q++;
  800cb9:	48 85 d2             	test   %rdx,%rdx
  800cbc:	74 1f                	je     800cdd <strncmp+0x28>
  800cbe:	0f b6 07             	movzbl (%rdi),%eax
  800cc1:	84 c0                	test   %al,%al
  800cc3:	74 1e                	je     800ce3 <strncmp+0x2e>
  800cc5:	3a 06                	cmp    (%rsi),%al
  800cc7:	75 1a                	jne    800ce3 <strncmp+0x2e>
  800cc9:	48 83 c7 01          	add    $0x1,%rdi
  800ccd:	48 83 c6 01          	add    $0x1,%rsi
  800cd1:	48 83 ea 01          	sub    $0x1,%rdx
  800cd5:	75 e7                	jne    800cbe <strncmp+0x9>

    if (!n) return 0;
  800cd7:	b8 00 00 00 00       	mov    $0x0,%eax
  800cdc:	c3                   	ret
  800cdd:	b8 00 00 00 00       	mov    $0x0,%eax
  800ce2:	c3                   	ret

    return (int)((unsigned char)*p - (unsigned char)*q);
  800ce3:	0f b6 07             	movzbl (%rdi),%eax
  800ce6:	0f b6 16             	movzbl (%rsi),%edx
  800ce9:	29 d0                	sub    %edx,%eax
}
  800ceb:	c3                   	ret

0000000000800cec <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
  800cec:	f3 0f 1e fa          	endbr64
    for (; *str; str++) {
  800cf0:	0f b6 17             	movzbl (%rdi),%edx
  800cf3:	84 d2                	test   %dl,%dl
  800cf5:	74 18                	je     800d0f <strchr+0x23>
        if (*str == c) {
  800cf7:	0f be d2             	movsbl %dl,%edx
  800cfa:	39 f2                	cmp    %esi,%edx
  800cfc:	74 17                	je     800d15 <strchr+0x29>
    for (; *str; str++) {
  800cfe:	48 83 c7 01          	add    $0x1,%rdi
  800d02:	0f b6 17             	movzbl (%rdi),%edx
  800d05:	84 d2                	test   %dl,%dl
  800d07:	75 ee                	jne    800cf7 <strchr+0xb>
            return (char *)str;
        }
    }
    return NULL;
  800d09:	b8 00 00 00 00       	mov    $0x0,%eax
  800d0e:	c3                   	ret
  800d0f:	b8 00 00 00 00       	mov    $0x0,%eax
  800d14:	c3                   	ret
            return (char *)str;
  800d15:	48 89 f8             	mov    %rdi,%rax
}
  800d18:	c3                   	ret

0000000000800d19 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
  800d19:	f3 0f 1e fa          	endbr64
  800d1d:	48 89 f8             	mov    %rdi,%rax
    for (; *str && *str != ch; str++) /* nothing */
  800d20:	0f b6 17             	movzbl (%rdi),%edx
  800d23:	84 d2                	test   %dl,%dl
  800d25:	74 13                	je     800d3a <strfind+0x21>
  800d27:	0f be d2             	movsbl %dl,%edx
  800d2a:	39 f2                	cmp    %esi,%edx
  800d2c:	74 0b                	je     800d39 <strfind+0x20>
  800d2e:	48 83 c0 01          	add    $0x1,%rax
  800d32:	0f b6 10             	movzbl (%rax),%edx
  800d35:	84 d2                	test   %dl,%dl
  800d37:	75 ee                	jne    800d27 <strfind+0xe>
        ;
    return (char *)str;
}
  800d39:	c3                   	ret
  800d3a:	c3                   	ret

0000000000800d3b <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  800d3b:	f3 0f 1e fa          	endbr64
  800d3f:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  800d42:	48 89 f8             	mov    %rdi,%rax
  800d45:	48 f7 d8             	neg    %rax
  800d48:	83 e0 07             	and    $0x7,%eax
  800d4b:	49 89 d1             	mov    %rdx,%r9
  800d4e:	49 29 c1             	sub    %rax,%r9
  800d51:	78 36                	js     800d89 <memset+0x4e>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  800d53:	40 0f b6 c6          	movzbl %sil,%eax
  800d57:	48 b9 01 01 01 01 01 	movabs $0x101010101010101,%rcx
  800d5e:	01 01 01 
  800d61:	48 0f af c1          	imul   %rcx,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  800d65:	40 f6 c7 07          	test   $0x7,%dil
  800d69:	75 38                	jne    800da3 <memset+0x68>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  800d6b:	4c 89 c9             	mov    %r9,%rcx
  800d6e:	48 c1 f9 03          	sar    $0x3,%rcx
  800d72:	74 0c                	je     800d80 <memset+0x45>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  800d74:	fc                   	cld
  800d75:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  800d78:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  800d7c:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  800d80:	4d 85 c9             	test   %r9,%r9
  800d83:	75 45                	jne    800dca <memset+0x8f>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  800d85:	4c 89 c0             	mov    %r8,%rax
  800d88:	c3                   	ret
        while (n-- > 0) *ptr++ = c;
  800d89:	48 85 d2             	test   %rdx,%rdx
  800d8c:	74 f7                	je     800d85 <memset+0x4a>
  800d8e:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  800d91:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  800d94:	48 83 c0 01          	add    $0x1,%rax
  800d98:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  800d9c:	48 39 c2             	cmp    %rax,%rdx
  800d9f:	75 f3                	jne    800d94 <memset+0x59>
  800da1:	eb e2                	jmp    800d85 <memset+0x4a>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  800da3:	40 f6 c7 01          	test   $0x1,%dil
  800da7:	74 06                	je     800daf <memset+0x74>
  800da9:	88 07                	mov    %al,(%rdi)
  800dab:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  800daf:	40 f6 c7 02          	test   $0x2,%dil
  800db3:	74 07                	je     800dbc <memset+0x81>
  800db5:	66 89 07             	mov    %ax,(%rdi)
  800db8:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  800dbc:	40 f6 c7 04          	test   $0x4,%dil
  800dc0:	74 a9                	je     800d6b <memset+0x30>
  800dc2:	89 07                	mov    %eax,(%rdi)
  800dc4:	48 83 c7 04          	add    $0x4,%rdi
  800dc8:	eb a1                	jmp    800d6b <memset+0x30>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  800dca:	41 f6 c1 04          	test   $0x4,%r9b
  800dce:	74 1b                	je     800deb <memset+0xb0>
  800dd0:	89 07                	mov    %eax,(%rdi)
  800dd2:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800dd6:	41 f6 c1 02          	test   $0x2,%r9b
  800dda:	74 07                	je     800de3 <memset+0xa8>
  800ddc:	66 89 07             	mov    %ax,(%rdi)
  800ddf:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  800de3:	41 f6 c1 01          	test   $0x1,%r9b
  800de7:	74 9c                	je     800d85 <memset+0x4a>
  800de9:	eb 06                	jmp    800df1 <memset+0xb6>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800deb:	41 f6 c1 02          	test   $0x2,%r9b
  800def:	75 eb                	jne    800ddc <memset+0xa1>
        if (ni & 1) *ptr = k;
  800df1:	88 07                	mov    %al,(%rdi)
  800df3:	eb 90                	jmp    800d85 <memset+0x4a>

0000000000800df5 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  800df5:	f3 0f 1e fa          	endbr64
  800df9:	48 89 f8             	mov    %rdi,%rax
  800dfc:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  800dff:	48 39 fe             	cmp    %rdi,%rsi
  800e02:	73 3b                	jae    800e3f <memmove+0x4a>
  800e04:	48 8d 14 16          	lea    (%rsi,%rdx,1),%rdx
  800e08:	48 39 d7             	cmp    %rdx,%rdi
  800e0b:	73 32                	jae    800e3f <memmove+0x4a>
        s += n;
        d += n;
  800e0d:	48 8d 3c 0f          	lea    (%rdi,%rcx,1),%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800e11:	48 89 d6             	mov    %rdx,%rsi
  800e14:	48 09 fe             	or     %rdi,%rsi
  800e17:	48 09 ce             	or     %rcx,%rsi
  800e1a:	40 f6 c6 07          	test   $0x7,%sil
  800e1e:	75 12                	jne    800e32 <memmove+0x3d>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  800e20:	48 83 ef 08          	sub    $0x8,%rdi
  800e24:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  800e28:	48 c1 e9 03          	shr    $0x3,%rcx
  800e2c:	fd                   	std
  800e2d:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  800e30:	fc                   	cld
  800e31:	c3                   	ret
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  800e32:	48 83 ef 01          	sub    $0x1,%rdi
  800e36:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  800e3a:	fd                   	std
  800e3b:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  800e3d:	eb f1                	jmp    800e30 <memmove+0x3b>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800e3f:	48 89 f2             	mov    %rsi,%rdx
  800e42:	48 09 c2             	or     %rax,%rdx
  800e45:	48 09 ca             	or     %rcx,%rdx
  800e48:	f6 c2 07             	test   $0x7,%dl
  800e4b:	75 0c                	jne    800e59 <memmove+0x64>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  800e4d:	48 c1 e9 03          	shr    $0x3,%rcx
  800e51:	48 89 c7             	mov    %rax,%rdi
  800e54:	fc                   	cld
  800e55:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  800e58:	c3                   	ret
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  800e59:	48 89 c7             	mov    %rax,%rdi
  800e5c:	fc                   	cld
  800e5d:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  800e5f:	c3                   	ret

0000000000800e60 <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  800e60:	f3 0f 1e fa          	endbr64
  800e64:	55                   	push   %rbp
  800e65:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  800e68:	48 b8 f5 0d 80 00 00 	movabs $0x800df5,%rax
  800e6f:	00 00 00 
  800e72:	ff d0                	call   *%rax
}
  800e74:	5d                   	pop    %rbp
  800e75:	c3                   	ret

0000000000800e76 <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  800e76:	f3 0f 1e fa          	endbr64
  800e7a:	55                   	push   %rbp
  800e7b:	48 89 e5             	mov    %rsp,%rbp
  800e7e:	41 57                	push   %r15
  800e80:	41 56                	push   %r14
  800e82:	41 55                	push   %r13
  800e84:	41 54                	push   %r12
  800e86:	53                   	push   %rbx
  800e87:	48 83 ec 08          	sub    $0x8,%rsp
  800e8b:	49 89 fe             	mov    %rdi,%r14
  800e8e:	49 89 f7             	mov    %rsi,%r15
  800e91:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  800e94:	48 89 f7             	mov    %rsi,%rdi
  800e97:	48 b8 95 0b 80 00 00 	movabs $0x800b95,%rax
  800e9e:	00 00 00 
  800ea1:	ff d0                	call   *%rax
  800ea3:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  800ea6:	48 89 de             	mov    %rbx,%rsi
  800ea9:	4c 89 f7             	mov    %r14,%rdi
  800eac:	48 b8 b4 0b 80 00 00 	movabs $0x800bb4,%rax
  800eb3:	00 00 00 
  800eb6:	ff d0                	call   *%rax
  800eb8:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  800ebb:	48 39 c3             	cmp    %rax,%rbx
  800ebe:	74 36                	je     800ef6 <strlcat+0x80>
    if (srclen < maxlen - dstlen) {
  800ec0:	48 89 d8             	mov    %rbx,%rax
  800ec3:	4c 29 e8             	sub    %r13,%rax
  800ec6:	49 39 c4             	cmp    %rax,%r12
  800ec9:	73 31                	jae    800efc <strlcat+0x86>
        memcpy(dst + dstlen, src, srclen + 1);
  800ecb:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  800ed0:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800ed4:	4c 89 fe             	mov    %r15,%rsi
  800ed7:	48 b8 60 0e 80 00 00 	movabs $0x800e60,%rax
  800ede:	00 00 00 
  800ee1:	ff d0                	call   *%rax
    return dstlen + srclen;
  800ee3:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  800ee7:	48 83 c4 08          	add    $0x8,%rsp
  800eeb:	5b                   	pop    %rbx
  800eec:	41 5c                	pop    %r12
  800eee:	41 5d                	pop    %r13
  800ef0:	41 5e                	pop    %r14
  800ef2:	41 5f                	pop    %r15
  800ef4:	5d                   	pop    %rbp
  800ef5:	c3                   	ret
    if (dstlen == maxlen) return maxlen + srclen;
  800ef6:	49 8d 04 04          	lea    (%r12,%rax,1),%rax
  800efa:	eb eb                	jmp    800ee7 <strlcat+0x71>
        memcpy(dst + dstlen, src, maxlen - 1);
  800efc:	48 83 eb 01          	sub    $0x1,%rbx
  800f00:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  800f04:	48 89 da             	mov    %rbx,%rdx
  800f07:	4c 89 fe             	mov    %r15,%rsi
  800f0a:	48 b8 60 0e 80 00 00 	movabs $0x800e60,%rax
  800f11:	00 00 00 
  800f14:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  800f16:	49 01 de             	add    %rbx,%r14
  800f19:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  800f1e:	eb c3                	jmp    800ee3 <strlcat+0x6d>

0000000000800f20 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  800f20:	f3 0f 1e fa          	endbr64
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  800f24:	48 85 d2             	test   %rdx,%rdx
  800f27:	74 2d                	je     800f56 <memcmp+0x36>
  800f29:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  800f2e:	0f b6 0c 07          	movzbl (%rdi,%rax,1),%ecx
  800f32:	44 0f b6 04 06       	movzbl (%rsi,%rax,1),%r8d
  800f37:	44 38 c1             	cmp    %r8b,%cl
  800f3a:	75 0f                	jne    800f4b <memcmp+0x2b>
    while (n-- > 0) {
  800f3c:	48 83 c0 01          	add    $0x1,%rax
  800f40:	48 39 c2             	cmp    %rax,%rdx
  800f43:	75 e9                	jne    800f2e <memcmp+0xe>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  800f45:	b8 00 00 00 00       	mov    $0x0,%eax
  800f4a:	c3                   	ret
            return (int)*s1 - (int)*s2;
  800f4b:	0f b6 c1             	movzbl %cl,%eax
  800f4e:	45 0f b6 c0          	movzbl %r8b,%r8d
  800f52:	44 29 c0             	sub    %r8d,%eax
  800f55:	c3                   	ret
    return 0;
  800f56:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f5b:	c3                   	ret

0000000000800f5c <memfind>:

void *
memfind(const void *src, int c, size_t n) {
  800f5c:	f3 0f 1e fa          	endbr64
    const void *end = (const char *)src + n;
  800f60:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  800f64:	48 39 c7             	cmp    %rax,%rdi
  800f67:	73 0f                	jae    800f78 <memfind+0x1c>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  800f69:	40 38 37             	cmp    %sil,(%rdi)
  800f6c:	74 0e                	je     800f7c <memfind+0x20>
    for (; src < end; src++) {
  800f6e:	48 83 c7 01          	add    $0x1,%rdi
  800f72:	48 39 f8             	cmp    %rdi,%rax
  800f75:	75 f2                	jne    800f69 <memfind+0xd>
  800f77:	c3                   	ret
  800f78:	48 89 f8             	mov    %rdi,%rax
  800f7b:	c3                   	ret
  800f7c:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  800f7f:	c3                   	ret

0000000000800f80 <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  800f80:	f3 0f 1e fa          	endbr64
  800f84:	49 89 f2             	mov    %rsi,%r10
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  800f87:	0f b6 37             	movzbl (%rdi),%esi
  800f8a:	40 80 fe 20          	cmp    $0x20,%sil
  800f8e:	74 06                	je     800f96 <strtol+0x16>
  800f90:	40 80 fe 09          	cmp    $0x9,%sil
  800f94:	75 13                	jne    800fa9 <strtol+0x29>
  800f96:	48 83 c7 01          	add    $0x1,%rdi
  800f9a:	0f b6 37             	movzbl (%rdi),%esi
  800f9d:	40 80 fe 20          	cmp    $0x20,%sil
  800fa1:	74 f3                	je     800f96 <strtol+0x16>
  800fa3:	40 80 fe 09          	cmp    $0x9,%sil
  800fa7:	74 ed                	je     800f96 <strtol+0x16>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  800fa9:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  800fac:	83 e0 fd             	and    $0xfffffffd,%eax
  800faf:	3c 01                	cmp    $0x1,%al
  800fb1:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  800fb5:	f7 c2 ef ff ff ff    	test   $0xffffffef,%edx
  800fbb:	75 0f                	jne    800fcc <strtol+0x4c>
  800fbd:	80 3f 30             	cmpb   $0x30,(%rdi)
  800fc0:	74 14                	je     800fd6 <strtol+0x56>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  800fc2:	85 d2                	test   %edx,%edx
  800fc4:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fc9:	0f 44 d0             	cmove  %eax,%edx
    }

    /* Digits */
    long val = 0;
  800fcc:	b8 00 00 00 00       	mov    $0x0,%eax
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  800fd1:	4c 63 ca             	movslq %edx,%r9
  800fd4:	eb 36                	jmp    80100c <strtol+0x8c>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  800fd6:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  800fda:	74 0f                	je     800feb <strtol+0x6b>
    } else if (!base && s[0] == '0') {
  800fdc:	85 d2                	test   %edx,%edx
  800fde:	75 ec                	jne    800fcc <strtol+0x4c>
        s++;
  800fe0:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  800fe4:	ba 08 00 00 00       	mov    $0x8,%edx
        s++;
  800fe9:	eb e1                	jmp    800fcc <strtol+0x4c>
        s += 2;
  800feb:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  800fef:	ba 10 00 00 00       	mov    $0x10,%edx
        s += 2;
  800ff4:	eb d6                	jmp    800fcc <strtol+0x4c>
            dig -= '0';
  800ff6:	83 e9 30             	sub    $0x30,%ecx
        if (dig >= base) break;
  800ff9:	44 0f b6 c1          	movzbl %cl,%r8d
  800ffd:	41 39 d0             	cmp    %edx,%r8d
  801000:	7d 21                	jge    801023 <strtol+0xa3>
        val = val * base + dig;
  801002:	49 0f af c1          	imul   %r9,%rax
  801006:	0f b6 c9             	movzbl %cl,%ecx
  801009:	48 01 c8             	add    %rcx,%rax
        uint8_t dig = *s++;
  80100c:	48 83 c7 01          	add    $0x1,%rdi
  801010:	0f b6 4f ff          	movzbl -0x1(%rdi),%ecx
        if (dig - '0' < 10)
  801014:	80 f9 39             	cmp    $0x39,%cl
  801017:	76 dd                	jbe    800ff6 <strtol+0x76>
        else if (dig - 'a' < 27)
  801019:	80 f9 7b             	cmp    $0x7b,%cl
  80101c:	77 05                	ja     801023 <strtol+0xa3>
            dig -= 'a' - 10;
  80101e:	83 e9 57             	sub    $0x57,%ecx
  801021:	eb d6                	jmp    800ff9 <strtol+0x79>
    }

    if (endptr) *endptr = (char *)s;
  801023:	4d 85 d2             	test   %r10,%r10
  801026:	74 03                	je     80102b <strtol+0xab>
  801028:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  80102b:	48 89 c2             	mov    %rax,%rdx
  80102e:	48 f7 da             	neg    %rdx
  801031:	40 80 fe 2d          	cmp    $0x2d,%sil
  801035:	48 0f 44 c2          	cmove  %rdx,%rax
}
  801039:	c3                   	ret

000000000080103a <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  80103a:	f3 0f 1e fa          	endbr64
  80103e:	55                   	push   %rbp
  80103f:	48 89 e5             	mov    %rsp,%rbp
  801042:	53                   	push   %rbx
  801043:	48 89 fa             	mov    %rdi,%rdx
  801046:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801049:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80104e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801053:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801058:	be 00 00 00 00       	mov    $0x0,%esi
  80105d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801063:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  801065:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801069:	c9                   	leave
  80106a:	c3                   	ret

000000000080106b <sys_cgetc>:

int
sys_cgetc(void) {
  80106b:	f3 0f 1e fa          	endbr64
  80106f:	55                   	push   %rbp
  801070:	48 89 e5             	mov    %rsp,%rbp
  801073:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801074:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801079:	ba 00 00 00 00       	mov    $0x0,%edx
  80107e:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801083:	bb 00 00 00 00       	mov    $0x0,%ebx
  801088:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80108d:	be 00 00 00 00       	mov    $0x0,%esi
  801092:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801098:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  80109a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80109e:	c9                   	leave
  80109f:	c3                   	ret

00000000008010a0 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  8010a0:	f3 0f 1e fa          	endbr64
  8010a4:	55                   	push   %rbp
  8010a5:	48 89 e5             	mov    %rsp,%rbp
  8010a8:	53                   	push   %rbx
  8010a9:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  8010ad:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8010b0:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8010b5:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8010ba:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010bf:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8010c4:	be 00 00 00 00       	mov    $0x0,%esi
  8010c9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8010cf:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8010d1:	48 85 c0             	test   %rax,%rax
  8010d4:	7f 06                	jg     8010dc <sys_env_destroy+0x3c>
}
  8010d6:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8010da:	c9                   	leave
  8010db:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8010dc:	49 89 c0             	mov    %rax,%r8
  8010df:	b9 03 00 00 00       	mov    $0x3,%ecx
  8010e4:	48 ba 00 36 80 00 00 	movabs $0x803600,%rdx
  8010eb:	00 00 00 
  8010ee:	be 26 00 00 00       	mov    $0x26,%esi
  8010f3:	48 bf c1 31 80 00 00 	movabs $0x8031c1,%rdi
  8010fa:	00 00 00 
  8010fd:	b8 00 00 00 00       	mov    $0x0,%eax
  801102:	49 b9 c3 2c 80 00 00 	movabs $0x802cc3,%r9
  801109:	00 00 00 
  80110c:	41 ff d1             	call   *%r9

000000000080110f <sys_getenvid>:

envid_t
sys_getenvid(void) {
  80110f:	f3 0f 1e fa          	endbr64
  801113:	55                   	push   %rbp
  801114:	48 89 e5             	mov    %rsp,%rbp
  801117:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801118:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80111d:	ba 00 00 00 00       	mov    $0x0,%edx
  801122:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801127:	bb 00 00 00 00       	mov    $0x0,%ebx
  80112c:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801131:	be 00 00 00 00       	mov    $0x0,%esi
  801136:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80113c:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  80113e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801142:	c9                   	leave
  801143:	c3                   	ret

0000000000801144 <sys_yield>:

void
sys_yield(void) {
  801144:	f3 0f 1e fa          	endbr64
  801148:	55                   	push   %rbp
  801149:	48 89 e5             	mov    %rsp,%rbp
  80114c:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80114d:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801152:	ba 00 00 00 00       	mov    $0x0,%edx
  801157:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80115c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801161:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801166:	be 00 00 00 00       	mov    $0x0,%esi
  80116b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801171:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  801173:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801177:	c9                   	leave
  801178:	c3                   	ret

0000000000801179 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  801179:	f3 0f 1e fa          	endbr64
  80117d:	55                   	push   %rbp
  80117e:	48 89 e5             	mov    %rsp,%rbp
  801181:	53                   	push   %rbx
  801182:	48 89 fa             	mov    %rdi,%rdx
  801185:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801188:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80118d:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  801194:	00 00 00 
  801197:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80119c:	be 00 00 00 00       	mov    $0x0,%esi
  8011a1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8011a7:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  8011a9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011ad:	c9                   	leave
  8011ae:	c3                   	ret

00000000008011af <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  8011af:	f3 0f 1e fa          	endbr64
  8011b3:	55                   	push   %rbp
  8011b4:	48 89 e5             	mov    %rsp,%rbp
  8011b7:	53                   	push   %rbx
  8011b8:	49 89 f8             	mov    %rdi,%r8
  8011bb:	48 89 d3             	mov    %rdx,%rbx
  8011be:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  8011c1:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8011c6:	4c 89 c2             	mov    %r8,%rdx
  8011c9:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8011cc:	be 00 00 00 00       	mov    $0x0,%esi
  8011d1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8011d7:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  8011d9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011dd:	c9                   	leave
  8011de:	c3                   	ret

00000000008011df <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  8011df:	f3 0f 1e fa          	endbr64
  8011e3:	55                   	push   %rbp
  8011e4:	48 89 e5             	mov    %rsp,%rbp
  8011e7:	53                   	push   %rbx
  8011e8:	48 83 ec 08          	sub    $0x8,%rsp
  8011ec:	89 f8                	mov    %edi,%eax
  8011ee:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  8011f1:	48 63 f9             	movslq %ecx,%rdi
  8011f4:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8011f7:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8011fc:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8011ff:	be 00 00 00 00       	mov    $0x0,%esi
  801204:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80120a:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80120c:	48 85 c0             	test   %rax,%rax
  80120f:	7f 06                	jg     801217 <sys_alloc_region+0x38>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  801211:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801215:	c9                   	leave
  801216:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801217:	49 89 c0             	mov    %rax,%r8
  80121a:	b9 04 00 00 00       	mov    $0x4,%ecx
  80121f:	48 ba 00 36 80 00 00 	movabs $0x803600,%rdx
  801226:	00 00 00 
  801229:	be 26 00 00 00       	mov    $0x26,%esi
  80122e:	48 bf c1 31 80 00 00 	movabs $0x8031c1,%rdi
  801235:	00 00 00 
  801238:	b8 00 00 00 00       	mov    $0x0,%eax
  80123d:	49 b9 c3 2c 80 00 00 	movabs $0x802cc3,%r9
  801244:	00 00 00 
  801247:	41 ff d1             	call   *%r9

000000000080124a <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  80124a:	f3 0f 1e fa          	endbr64
  80124e:	55                   	push   %rbp
  80124f:	48 89 e5             	mov    %rsp,%rbp
  801252:	53                   	push   %rbx
  801253:	48 83 ec 08          	sub    $0x8,%rsp
  801257:	89 f8                	mov    %edi,%eax
  801259:	49 89 f2             	mov    %rsi,%r10
  80125c:	48 89 cf             	mov    %rcx,%rdi
  80125f:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  801262:	48 63 da             	movslq %edx,%rbx
  801265:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801268:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80126d:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801270:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  801273:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801275:	48 85 c0             	test   %rax,%rax
  801278:	7f 06                	jg     801280 <sys_map_region+0x36>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  80127a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80127e:	c9                   	leave
  80127f:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801280:	49 89 c0             	mov    %rax,%r8
  801283:	b9 05 00 00 00       	mov    $0x5,%ecx
  801288:	48 ba 00 36 80 00 00 	movabs $0x803600,%rdx
  80128f:	00 00 00 
  801292:	be 26 00 00 00       	mov    $0x26,%esi
  801297:	48 bf c1 31 80 00 00 	movabs $0x8031c1,%rdi
  80129e:	00 00 00 
  8012a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8012a6:	49 b9 c3 2c 80 00 00 	movabs $0x802cc3,%r9
  8012ad:	00 00 00 
  8012b0:	41 ff d1             	call   *%r9

00000000008012b3 <sys_map_physical_region>:

int
sys_map_physical_region(uintptr_t pa, envid_t dstenv, void *dstva, size_t size, int perm) {
  8012b3:	f3 0f 1e fa          	endbr64
  8012b7:	55                   	push   %rbp
  8012b8:	48 89 e5             	mov    %rsp,%rbp
  8012bb:	53                   	push   %rbx
  8012bc:	48 83 ec 08          	sub    $0x8,%rsp
  8012c0:	49 89 f9             	mov    %rdi,%r9
  8012c3:	89 f0                	mov    %esi,%eax
  8012c5:	48 89 d3             	mov    %rdx,%rbx
  8012c8:	48 89 cf             	mov    %rcx,%rdi
    int res = syscall(SYS_map_physical_region, 1, pa, dstenv, (uintptr_t)dstva, size, perm, 0);
  8012cb:	49 63 f0             	movslq %r8d,%rsi
  8012ce:	48 63 c8             	movslq %eax,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8012d1:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8012d6:	4c 89 ca             	mov    %r9,%rdx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012d9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8012df:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8012e1:	48 85 c0             	test   %rax,%rax
  8012e4:	7f 06                	jg     8012ec <sys_map_physical_region+0x39>
#ifdef SANITIZE_USER_SHADOW_BASE
    platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  8012e6:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012ea:	c9                   	leave
  8012eb:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8012ec:	49 89 c0             	mov    %rax,%r8
  8012ef:	b9 06 00 00 00       	mov    $0x6,%ecx
  8012f4:	48 ba 00 36 80 00 00 	movabs $0x803600,%rdx
  8012fb:	00 00 00 
  8012fe:	be 26 00 00 00       	mov    $0x26,%esi
  801303:	48 bf c1 31 80 00 00 	movabs $0x8031c1,%rdi
  80130a:	00 00 00 
  80130d:	b8 00 00 00 00       	mov    $0x0,%eax
  801312:	49 b9 c3 2c 80 00 00 	movabs $0x802cc3,%r9
  801319:	00 00 00 
  80131c:	41 ff d1             	call   *%r9

000000000080131f <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  80131f:	f3 0f 1e fa          	endbr64
  801323:	55                   	push   %rbp
  801324:	48 89 e5             	mov    %rsp,%rbp
  801327:	53                   	push   %rbx
  801328:	48 83 ec 08          	sub    $0x8,%rsp
  80132c:	48 89 f1             	mov    %rsi,%rcx
  80132f:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  801332:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801335:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80133a:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80133f:	be 00 00 00 00       	mov    $0x0,%esi
  801344:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80134a:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80134c:	48 85 c0             	test   %rax,%rax
  80134f:	7f 06                	jg     801357 <sys_unmap_region+0x38>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  801351:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801355:	c9                   	leave
  801356:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801357:	49 89 c0             	mov    %rax,%r8
  80135a:	b9 07 00 00 00       	mov    $0x7,%ecx
  80135f:	48 ba 00 36 80 00 00 	movabs $0x803600,%rdx
  801366:	00 00 00 
  801369:	be 26 00 00 00       	mov    $0x26,%esi
  80136e:	48 bf c1 31 80 00 00 	movabs $0x8031c1,%rdi
  801375:	00 00 00 
  801378:	b8 00 00 00 00       	mov    $0x0,%eax
  80137d:	49 b9 c3 2c 80 00 00 	movabs $0x802cc3,%r9
  801384:	00 00 00 
  801387:	41 ff d1             	call   *%r9

000000000080138a <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  80138a:	f3 0f 1e fa          	endbr64
  80138e:	55                   	push   %rbp
  80138f:	48 89 e5             	mov    %rsp,%rbp
  801392:	53                   	push   %rbx
  801393:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  801397:	48 63 ce             	movslq %esi,%rcx
  80139a:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80139d:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8013a2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013a7:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013ac:	be 00 00 00 00       	mov    $0x0,%esi
  8013b1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013b7:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8013b9:	48 85 c0             	test   %rax,%rax
  8013bc:	7f 06                	jg     8013c4 <sys_env_set_status+0x3a>
}
  8013be:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013c2:	c9                   	leave
  8013c3:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8013c4:	49 89 c0             	mov    %rax,%r8
  8013c7:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013cc:	48 ba 00 36 80 00 00 	movabs $0x803600,%rdx
  8013d3:	00 00 00 
  8013d6:	be 26 00 00 00       	mov    $0x26,%esi
  8013db:	48 bf c1 31 80 00 00 	movabs $0x8031c1,%rdi
  8013e2:	00 00 00 
  8013e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8013ea:	49 b9 c3 2c 80 00 00 	movabs $0x802cc3,%r9
  8013f1:	00 00 00 
  8013f4:	41 ff d1             	call   *%r9

00000000008013f7 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  8013f7:	f3 0f 1e fa          	endbr64
  8013fb:	55                   	push   %rbp
  8013fc:	48 89 e5             	mov    %rsp,%rbp
  8013ff:	53                   	push   %rbx
  801400:	48 83 ec 08          	sub    $0x8,%rsp
  801404:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  801407:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80140a:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80140f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801414:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801419:	be 00 00 00 00       	mov    $0x0,%esi
  80141e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801424:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801426:	48 85 c0             	test   %rax,%rax
  801429:	7f 06                	jg     801431 <sys_env_set_trapframe+0x3a>
}
  80142b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80142f:	c9                   	leave
  801430:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801431:	49 89 c0             	mov    %rax,%r8
  801434:	b9 0b 00 00 00       	mov    $0xb,%ecx
  801439:	48 ba 00 36 80 00 00 	movabs $0x803600,%rdx
  801440:	00 00 00 
  801443:	be 26 00 00 00       	mov    $0x26,%esi
  801448:	48 bf c1 31 80 00 00 	movabs $0x8031c1,%rdi
  80144f:	00 00 00 
  801452:	b8 00 00 00 00       	mov    $0x0,%eax
  801457:	49 b9 c3 2c 80 00 00 	movabs $0x802cc3,%r9
  80145e:	00 00 00 
  801461:	41 ff d1             	call   *%r9

0000000000801464 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  801464:	f3 0f 1e fa          	endbr64
  801468:	55                   	push   %rbp
  801469:	48 89 e5             	mov    %rsp,%rbp
  80146c:	53                   	push   %rbx
  80146d:	48 83 ec 08          	sub    $0x8,%rsp
  801471:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  801474:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801477:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80147c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801481:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801486:	be 00 00 00 00       	mov    $0x0,%esi
  80148b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801491:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801493:	48 85 c0             	test   %rax,%rax
  801496:	7f 06                	jg     80149e <sys_env_set_pgfault_upcall+0x3a>
}
  801498:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80149c:	c9                   	leave
  80149d:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80149e:	49 89 c0             	mov    %rax,%r8
  8014a1:	b9 0c 00 00 00       	mov    $0xc,%ecx
  8014a6:	48 ba 00 36 80 00 00 	movabs $0x803600,%rdx
  8014ad:	00 00 00 
  8014b0:	be 26 00 00 00       	mov    $0x26,%esi
  8014b5:	48 bf c1 31 80 00 00 	movabs $0x8031c1,%rdi
  8014bc:	00 00 00 
  8014bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c4:	49 b9 c3 2c 80 00 00 	movabs $0x802cc3,%r9
  8014cb:	00 00 00 
  8014ce:	41 ff d1             	call   *%r9

00000000008014d1 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  8014d1:	f3 0f 1e fa          	endbr64
  8014d5:	55                   	push   %rbp
  8014d6:	48 89 e5             	mov    %rsp,%rbp
  8014d9:	53                   	push   %rbx
  8014da:	89 f8                	mov    %edi,%eax
  8014dc:	49 89 f1             	mov    %rsi,%r9
  8014df:	48 89 d3             	mov    %rdx,%rbx
  8014e2:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  8014e5:	49 63 f0             	movslq %r8d,%rsi
  8014e8:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8014eb:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8014f0:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8014f3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8014f9:	cd 30                	int    $0x30
}
  8014fb:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014ff:	c9                   	leave
  801500:	c3                   	ret

0000000000801501 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  801501:	f3 0f 1e fa          	endbr64
  801505:	55                   	push   %rbp
  801506:	48 89 e5             	mov    %rsp,%rbp
  801509:	53                   	push   %rbx
  80150a:	48 83 ec 08          	sub    $0x8,%rsp
  80150e:	48 89 fa             	mov    %rdi,%rdx
  801511:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801514:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801519:	bb 00 00 00 00       	mov    $0x0,%ebx
  80151e:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801523:	be 00 00 00 00       	mov    $0x0,%esi
  801528:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80152e:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801530:	48 85 c0             	test   %rax,%rax
  801533:	7f 06                	jg     80153b <sys_ipc_recv+0x3a>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  801535:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801539:	c9                   	leave
  80153a:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80153b:	49 89 c0             	mov    %rax,%r8
  80153e:	b9 0f 00 00 00       	mov    $0xf,%ecx
  801543:	48 ba 00 36 80 00 00 	movabs $0x803600,%rdx
  80154a:	00 00 00 
  80154d:	be 26 00 00 00       	mov    $0x26,%esi
  801552:	48 bf c1 31 80 00 00 	movabs $0x8031c1,%rdi
  801559:	00 00 00 
  80155c:	b8 00 00 00 00       	mov    $0x0,%eax
  801561:	49 b9 c3 2c 80 00 00 	movabs $0x802cc3,%r9
  801568:	00 00 00 
  80156b:	41 ff d1             	call   *%r9

000000000080156e <sys_gettime>:

int
sys_gettime(void) {
  80156e:	f3 0f 1e fa          	endbr64
  801572:	55                   	push   %rbp
  801573:	48 89 e5             	mov    %rsp,%rbp
  801576:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801577:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80157c:	ba 00 00 00 00       	mov    $0x0,%edx
  801581:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801586:	bb 00 00 00 00       	mov    $0x0,%ebx
  80158b:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801590:	be 00 00 00 00       	mov    $0x0,%esi
  801595:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80159b:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  80159d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8015a1:	c9                   	leave
  8015a2:	c3                   	ret

00000000008015a3 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  8015a3:	f3 0f 1e fa          	endbr64
  8015a7:	55                   	push   %rbp
  8015a8:	48 89 e5             	mov    %rsp,%rbp
  8015ab:	41 54                	push   %r12
  8015ad:	53                   	push   %rbx
  8015ae:	48 89 fb             	mov    %rdi,%rbx
  8015b1:	48 89 f7             	mov    %rsi,%rdi
  8015b4:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  8015b7:	48 85 f6             	test   %rsi,%rsi
  8015ba:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  8015c1:	00 00 00 
  8015c4:	48 0f 44 f8          	cmove  %rax,%rdi
    }
    int res = sys_ipc_recv(pg, PAGE_SIZE);
  8015c8:	be 00 10 00 00       	mov    $0x1000,%esi
  8015cd:	48 b8 01 15 80 00 00 	movabs $0x801501,%rax
  8015d4:	00 00 00 
  8015d7:	ff d0                	call   *%rax
    if (res < 0) {
  8015d9:	85 c0                	test   %eax,%eax
  8015db:	78 45                	js     801622 <ipc_recv+0x7f>
        if (perm_store != NULL) {
            *perm_store = 0;
        }
        return res;
    } else {
        if (from_env_store != NULL) {
  8015dd:	48 85 db             	test   %rbx,%rbx
  8015e0:	74 12                	je     8015f4 <ipc_recv+0x51>
            *from_env_store = thisenv->env_ipc_from;
  8015e2:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  8015e9:	00 00 00 
  8015ec:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  8015f2:	89 03                	mov    %eax,(%rbx)
        }
        if (perm_store != NULL) {
  8015f4:	4d 85 e4             	test   %r12,%r12
  8015f7:	74 14                	je     80160d <ipc_recv+0x6a>
            *perm_store = thisenv->env_ipc_perm;
  8015f9:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801600:	00 00 00 
  801603:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  801609:	41 89 04 24          	mov    %eax,(%r12)
        }
        return thisenv->env_ipc_value;
  80160d:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801614:	00 00 00 
  801617:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
    }
    return -1;
}
  80161d:	5b                   	pop    %rbx
  80161e:	41 5c                	pop    %r12
  801620:	5d                   	pop    %rbp
  801621:	c3                   	ret
        if (from_env_store != NULL) {
  801622:	48 85 db             	test   %rbx,%rbx
  801625:	74 06                	je     80162d <ipc_recv+0x8a>
            *from_env_store = 0;
  801627:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store != NULL) {
  80162d:	4d 85 e4             	test   %r12,%r12
  801630:	74 eb                	je     80161d <ipc_recv+0x7a>
            *perm_store = 0;
  801632:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  801639:	00 
  80163a:	eb e1                	jmp    80161d <ipc_recv+0x7a>

000000000080163c <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  80163c:	f3 0f 1e fa          	endbr64
  801640:	55                   	push   %rbp
  801641:	48 89 e5             	mov    %rsp,%rbp
  801644:	41 57                	push   %r15
  801646:	41 56                	push   %r14
  801648:	41 55                	push   %r13
  80164a:	41 54                	push   %r12
  80164c:	53                   	push   %rbx
  80164d:	48 83 ec 18          	sub    $0x18,%rsp
  801651:	89 7d c4             	mov    %edi,-0x3c(%rbp)
  801654:	48 89 d3             	mov    %rdx,%rbx
  801657:	49 89 cc             	mov    %rcx,%r12
  80165a:	45 89 c5             	mov    %r8d,%r13d
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  80165d:	48 85 d2             	test   %rdx,%rdx
  801660:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  801667:	00 00 00 
  80166a:	48 0f 44 d8          	cmove  %rax,%rbx
    }
    int res = sys_ipc_try_send(to_env, val, pg, size, perm);
  80166e:	89 f0                	mov    %esi,%eax
  801670:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  801674:	48 89 da             	mov    %rbx,%rdx
  801677:	48 89 c6             	mov    %rax,%rsi
  80167a:	48 b8 d1 14 80 00 00 	movabs $0x8014d1,%rax
  801681:	00 00 00 
  801684:	ff d0                	call   *%rax
    while (res < 0) {
  801686:	85 c0                	test   %eax,%eax
  801688:	79 65                	jns    8016ef <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  80168a:	83 f8 f5             	cmp    $0xfffffff5,%eax
  80168d:	75 33                	jne    8016c2 <ipc_send+0x86>
            panic("Error: %i\n", res);
        }
        sys_yield();
  80168f:	49 bf 44 11 80 00 00 	movabs $0x801144,%r15
  801696:	00 00 00 
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  801699:	49 be d1 14 80 00 00 	movabs $0x8014d1,%r14
  8016a0:	00 00 00 
        sys_yield();
  8016a3:	41 ff d7             	call   *%r15
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  8016a6:	45 89 e8             	mov    %r13d,%r8d
  8016a9:	4c 89 e1             	mov    %r12,%rcx
  8016ac:	48 89 da             	mov    %rbx,%rdx
  8016af:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  8016b3:	8b 7d c4             	mov    -0x3c(%rbp),%edi
  8016b6:	41 ff d6             	call   *%r14
    while (res < 0) {
  8016b9:	85 c0                	test   %eax,%eax
  8016bb:	79 32                	jns    8016ef <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  8016bd:	83 f8 f5             	cmp    $0xfffffff5,%eax
  8016c0:	74 e1                	je     8016a3 <ipc_send+0x67>
            panic("Error: %i\n", res);
  8016c2:	89 c1                	mov    %eax,%ecx
  8016c4:	48 ba cf 31 80 00 00 	movabs $0x8031cf,%rdx
  8016cb:	00 00 00 
  8016ce:	be 42 00 00 00       	mov    $0x42,%esi
  8016d3:	48 bf da 31 80 00 00 	movabs $0x8031da,%rdi
  8016da:	00 00 00 
  8016dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e2:	49 b8 c3 2c 80 00 00 	movabs $0x802cc3,%r8
  8016e9:	00 00 00 
  8016ec:	41 ff d0             	call   *%r8
    }
}
  8016ef:	48 83 c4 18          	add    $0x18,%rsp
  8016f3:	5b                   	pop    %rbx
  8016f4:	41 5c                	pop    %r12
  8016f6:	41 5d                	pop    %r13
  8016f8:	41 5e                	pop    %r14
  8016fa:	41 5f                	pop    %r15
  8016fc:	5d                   	pop    %rbp
  8016fd:	c3                   	ret

00000000008016fe <ipc_find_env>:

/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
  8016fe:	f3 0f 1e fa          	endbr64
    for (size_t i = 0; i < NENV; i++)
  801702:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  801707:	48 b9 00 00 a0 1f 80 	movabs $0x801fa00000,%rcx
  80170e:	00 00 00 
  801711:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  801715:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  801719:	48 c1 e2 04          	shl    $0x4,%rdx
  80171d:	48 01 ca             	add    %rcx,%rdx
  801720:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  801726:	39 fa                	cmp    %edi,%edx
  801728:	74 12                	je     80173c <ipc_find_env+0x3e>
    for (size_t i = 0; i < NENV; i++)
  80172a:	48 83 c0 01          	add    $0x1,%rax
  80172e:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  801734:	75 db                	jne    801711 <ipc_find_env+0x13>
            return envs[i].env_id;
    return 0;
  801736:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80173b:	c3                   	ret
            return envs[i].env_id;
  80173c:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  801740:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  801744:	48 c1 e2 04          	shl    $0x4,%rdx
  801748:	48 b8 00 00 a0 1f 80 	movabs $0x801fa00000,%rax
  80174f:	00 00 00 
  801752:	48 01 d0             	add    %rdx,%rax
  801755:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80175b:	c3                   	ret

000000000080175c <fd2num>:


/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
  80175c:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801760:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801767:	ff ff ff 
  80176a:	48 01 f8             	add    %rdi,%rax
  80176d:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801771:	c3                   	ret

0000000000801772 <fd2data>:

char *
fd2data(struct Fd *fd) {
  801772:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801776:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80177d:	ff ff ff 
  801780:	48 01 f8             	add    %rdi,%rax
  801783:	48 c1 e8 0c          	shr    $0xc,%rax
    return INDEX2DATA(fd2num(fd));
  801787:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80178d:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801791:	c3                   	ret

0000000000801792 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  801792:	f3 0f 1e fa          	endbr64
  801796:	55                   	push   %rbp
  801797:	48 89 e5             	mov    %rsp,%rbp
  80179a:	41 57                	push   %r15
  80179c:	41 56                	push   %r14
  80179e:	41 55                	push   %r13
  8017a0:	41 54                	push   %r12
  8017a2:	53                   	push   %rbx
  8017a3:	48 83 ec 08          	sub    $0x8,%rsp
  8017a7:	49 89 ff             	mov    %rdi,%r15
  8017aa:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  8017af:	49 bd f1 28 80 00 00 	movabs $0x8028f1,%r13
  8017b6:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  8017b9:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        struct Fd *fd = INDEX2FD(i);
  8017bf:	49 89 dc             	mov    %rbx,%r12
        if (!(get_prot(fd) & PROT_R)) {
  8017c2:	48 89 df             	mov    %rbx,%rdi
  8017c5:	41 ff d5             	call   *%r13
  8017c8:	83 e0 04             	and    $0x4,%eax
  8017cb:	74 17                	je     8017e4 <fd_alloc+0x52>
    for (int i = 0; i < MAXFD; i++) {
  8017cd:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  8017d4:	4c 39 f3             	cmp    %r14,%rbx
  8017d7:	75 e6                	jne    8017bf <fd_alloc+0x2d>
  8017d9:	41 bc 00 00 00 00    	mov    $0x0,%r12d
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
    return -E_MAX_OPEN;
  8017df:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
            *fd_store = fd;
  8017e4:	4d 89 27             	mov    %r12,(%r15)
}
  8017e7:	48 83 c4 08          	add    $0x8,%rsp
  8017eb:	5b                   	pop    %rbx
  8017ec:	41 5c                	pop    %r12
  8017ee:	41 5d                	pop    %r13
  8017f0:	41 5e                	pop    %r14
  8017f2:	41 5f                	pop    %r15
  8017f4:	5d                   	pop    %rbp
  8017f5:	c3                   	ret

00000000008017f6 <fd_lookup>:
 *
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
  8017f6:	f3 0f 1e fa          	endbr64
    if (fdnum < 0 || fdnum >= MAXFD) {
  8017fa:	83 ff 1f             	cmp    $0x1f,%edi
  8017fd:	77 39                	ja     801838 <fd_lookup+0x42>
fd_lookup(int fdnum, struct Fd **fd_store) {
  8017ff:	55                   	push   %rbp
  801800:	48 89 e5             	mov    %rsp,%rbp
  801803:	41 54                	push   %r12
  801805:	53                   	push   %rbx
  801806:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  801809:	48 63 df             	movslq %edi,%rbx
  80180c:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  801813:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  801817:	48 89 df             	mov    %rbx,%rdi
  80181a:	48 b8 f1 28 80 00 00 	movabs $0x8028f1,%rax
  801821:	00 00 00 
  801824:	ff d0                	call   *%rax
  801826:	a8 04                	test   $0x4,%al
  801828:	74 14                	je     80183e <fd_lookup+0x48>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  80182a:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  80182e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801833:	5b                   	pop    %rbx
  801834:	41 5c                	pop    %r12
  801836:	5d                   	pop    %rbp
  801837:	c3                   	ret
        return -E_INVAL;
  801838:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80183d:	c3                   	ret
        return -E_INVAL;
  80183e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801843:	eb ee                	jmp    801833 <fd_lookup+0x3d>

0000000000801845 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  801845:	f3 0f 1e fa          	endbr64
  801849:	55                   	push   %rbp
  80184a:	48 89 e5             	mov    %rsp,%rbp
  80184d:	41 54                	push   %r12
  80184f:	53                   	push   %rbx
  801850:	49 89 f4             	mov    %rsi,%r12
    for (size_t i = 0; devtab[i]; i++) {
  801853:	48 b8 c0 36 80 00 00 	movabs $0x8036c0,%rax
  80185a:	00 00 00 
  80185d:	48 bb 20 40 80 00 00 	movabs $0x804020,%rbx
  801864:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  801867:	39 3b                	cmp    %edi,(%rbx)
  801869:	74 47                	je     8018b2 <dev_lookup+0x6d>
    for (size_t i = 0; devtab[i]; i++) {
  80186b:	48 83 c0 08          	add    $0x8,%rax
  80186f:	48 8b 18             	mov    (%rax),%rbx
  801872:	48 85 db             	test   %rbx,%rbx
  801875:	75 f0                	jne    801867 <dev_lookup+0x22>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801877:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  80187e:	00 00 00 
  801881:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801887:	89 fa                	mov    %edi,%edx
  801889:	48 bf 20 36 80 00 00 	movabs $0x803620,%rdi
  801890:	00 00 00 
  801893:	b8 00 00 00 00       	mov    $0x0,%eax
  801898:	48 b9 91 02 80 00 00 	movabs $0x800291,%rcx
  80189f:	00 00 00 
  8018a2:	ff d1                	call   *%rcx
    *dev = 0;
    return -E_INVAL;
  8018a4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
            *dev = devtab[i];
  8018a9:	49 89 1c 24          	mov    %rbx,(%r12)
}
  8018ad:	5b                   	pop    %rbx
  8018ae:	41 5c                	pop    %r12
  8018b0:	5d                   	pop    %rbp
  8018b1:	c3                   	ret
            return 0;
  8018b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8018b7:	eb f0                	jmp    8018a9 <dev_lookup+0x64>

00000000008018b9 <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  8018b9:	f3 0f 1e fa          	endbr64
  8018bd:	55                   	push   %rbp
  8018be:	48 89 e5             	mov    %rsp,%rbp
  8018c1:	41 55                	push   %r13
  8018c3:	41 54                	push   %r12
  8018c5:	53                   	push   %rbx
  8018c6:	48 83 ec 18          	sub    $0x18,%rsp
  8018ca:	48 89 fb             	mov    %rdi,%rbx
  8018cd:	41 89 f4             	mov    %esi,%r12d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8018d0:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  8018d7:	ff ff ff 
  8018da:	48 01 df             	add    %rbx,%rdi
  8018dd:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  8018e1:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8018e5:	48 b8 f6 17 80 00 00 	movabs $0x8017f6,%rax
  8018ec:	00 00 00 
  8018ef:	ff d0                	call   *%rax
  8018f1:	41 89 c5             	mov    %eax,%r13d
  8018f4:	85 c0                	test   %eax,%eax
  8018f6:	78 06                	js     8018fe <fd_close+0x45>
  8018f8:	48 39 5d d8          	cmp    %rbx,-0x28(%rbp)
  8018fc:	74 1a                	je     801918 <fd_close+0x5f>
        return (must_exist ? res : 0);
  8018fe:	45 84 e4             	test   %r12b,%r12b
  801901:	b8 00 00 00 00       	mov    $0x0,%eax
  801906:	44 0f 44 e8          	cmove  %eax,%r13d
}
  80190a:	44 89 e8             	mov    %r13d,%eax
  80190d:	48 83 c4 18          	add    $0x18,%rsp
  801911:	5b                   	pop    %rbx
  801912:	41 5c                	pop    %r12
  801914:	41 5d                	pop    %r13
  801916:	5d                   	pop    %rbp
  801917:	c3                   	ret
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801918:	8b 3b                	mov    (%rbx),%edi
  80191a:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  80191e:	48 b8 45 18 80 00 00 	movabs $0x801845,%rax
  801925:	00 00 00 
  801928:	ff d0                	call   *%rax
  80192a:	41 89 c5             	mov    %eax,%r13d
  80192d:	85 c0                	test   %eax,%eax
  80192f:	78 1b                	js     80194c <fd_close+0x93>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  801931:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801935:	48 8b 40 20          	mov    0x20(%rax),%rax
  801939:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  80193f:	48 85 c0             	test   %rax,%rax
  801942:	74 08                	je     80194c <fd_close+0x93>
  801944:	48 89 df             	mov    %rbx,%rdi
  801947:	ff d0                	call   *%rax
  801949:	41 89 c5             	mov    %eax,%r13d
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  80194c:	ba 00 10 00 00       	mov    $0x1000,%edx
  801951:	48 89 de             	mov    %rbx,%rsi
  801954:	bf 00 00 00 00       	mov    $0x0,%edi
  801959:	48 b8 1f 13 80 00 00 	movabs $0x80131f,%rax
  801960:	00 00 00 
  801963:	ff d0                	call   *%rax
    return res;
  801965:	eb a3                	jmp    80190a <fd_close+0x51>

0000000000801967 <close>:

int
close(int fdnum) {
  801967:	f3 0f 1e fa          	endbr64
  80196b:	55                   	push   %rbp
  80196c:	48 89 e5             	mov    %rsp,%rbp
  80196f:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  801973:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801977:	48 b8 f6 17 80 00 00 	movabs $0x8017f6,%rax
  80197e:	00 00 00 
  801981:	ff d0                	call   *%rax
    if (res < 0) return res;
  801983:	85 c0                	test   %eax,%eax
  801985:	78 15                	js     80199c <close+0x35>

    return fd_close(fd, 1);
  801987:	be 01 00 00 00       	mov    $0x1,%esi
  80198c:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801990:	48 b8 b9 18 80 00 00 	movabs $0x8018b9,%rax
  801997:	00 00 00 
  80199a:	ff d0                	call   *%rax
}
  80199c:	c9                   	leave
  80199d:	c3                   	ret

000000000080199e <close_all>:

void
close_all(void) {
  80199e:	f3 0f 1e fa          	endbr64
  8019a2:	55                   	push   %rbp
  8019a3:	48 89 e5             	mov    %rsp,%rbp
  8019a6:	41 54                	push   %r12
  8019a8:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  8019a9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019ae:	49 bc 67 19 80 00 00 	movabs $0x801967,%r12
  8019b5:	00 00 00 
  8019b8:	89 df                	mov    %ebx,%edi
  8019ba:	41 ff d4             	call   *%r12
  8019bd:	83 c3 01             	add    $0x1,%ebx
  8019c0:	83 fb 20             	cmp    $0x20,%ebx
  8019c3:	75 f3                	jne    8019b8 <close_all+0x1a>
}
  8019c5:	5b                   	pop    %rbx
  8019c6:	41 5c                	pop    %r12
  8019c8:	5d                   	pop    %rbp
  8019c9:	c3                   	ret

00000000008019ca <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  8019ca:	f3 0f 1e fa          	endbr64
  8019ce:	55                   	push   %rbp
  8019cf:	48 89 e5             	mov    %rsp,%rbp
  8019d2:	41 57                	push   %r15
  8019d4:	41 56                	push   %r14
  8019d6:	41 55                	push   %r13
  8019d8:	41 54                	push   %r12
  8019da:	53                   	push   %rbx
  8019db:	48 83 ec 18          	sub    $0x18,%rsp
  8019df:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  8019e2:	48 8d 75 c8          	lea    -0x38(%rbp),%rsi
  8019e6:	48 b8 f6 17 80 00 00 	movabs $0x8017f6,%rax
  8019ed:	00 00 00 
  8019f0:	ff d0                	call   *%rax
  8019f2:	89 c3                	mov    %eax,%ebx
  8019f4:	85 c0                	test   %eax,%eax
  8019f6:	0f 88 b8 00 00 00    	js     801ab4 <dup+0xea>
    close(newfdnum);
  8019fc:	44 89 e7             	mov    %r12d,%edi
  8019ff:	48 b8 67 19 80 00 00 	movabs $0x801967,%rax
  801a06:	00 00 00 
  801a09:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  801a0b:	4d 63 ec             	movslq %r12d,%r13
  801a0e:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  801a15:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  801a19:	4c 8b 7d c8          	mov    -0x38(%rbp),%r15
  801a1d:	4c 89 ff             	mov    %r15,%rdi
  801a20:	49 be 72 17 80 00 00 	movabs $0x801772,%r14
  801a27:	00 00 00 
  801a2a:	41 ff d6             	call   *%r14
  801a2d:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  801a30:	4c 89 ef             	mov    %r13,%rdi
  801a33:	41 ff d6             	call   *%r14
  801a36:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  801a39:	48 89 df             	mov    %rbx,%rdi
  801a3c:	48 b8 f1 28 80 00 00 	movabs $0x8028f1,%rax
  801a43:	00 00 00 
  801a46:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  801a48:	a8 04                	test   $0x4,%al
  801a4a:	74 2b                	je     801a77 <dup+0xad>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  801a4c:	41 89 c1             	mov    %eax,%r9d
  801a4f:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801a55:	4c 89 f1             	mov    %r14,%rcx
  801a58:	ba 00 00 00 00       	mov    $0x0,%edx
  801a5d:	48 89 de             	mov    %rbx,%rsi
  801a60:	bf 00 00 00 00       	mov    $0x0,%edi
  801a65:	48 b8 4a 12 80 00 00 	movabs $0x80124a,%rax
  801a6c:	00 00 00 
  801a6f:	ff d0                	call   *%rax
  801a71:	89 c3                	mov    %eax,%ebx
  801a73:	85 c0                	test   %eax,%eax
  801a75:	78 4e                	js     801ac5 <dup+0xfb>
    }
    prot = get_prot(oldfd);
  801a77:	4c 89 ff             	mov    %r15,%rdi
  801a7a:	48 b8 f1 28 80 00 00 	movabs $0x8028f1,%rax
  801a81:	00 00 00 
  801a84:	ff d0                	call   *%rax
  801a86:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  801a89:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801a8f:	4c 89 e9             	mov    %r13,%rcx
  801a92:	ba 00 00 00 00       	mov    $0x0,%edx
  801a97:	4c 89 fe             	mov    %r15,%rsi
  801a9a:	bf 00 00 00 00       	mov    $0x0,%edi
  801a9f:	48 b8 4a 12 80 00 00 	movabs $0x80124a,%rax
  801aa6:	00 00 00 
  801aa9:	ff d0                	call   *%rax
  801aab:	89 c3                	mov    %eax,%ebx
  801aad:	85 c0                	test   %eax,%eax
  801aaf:	78 14                	js     801ac5 <dup+0xfb>

    return newfdnum;
  801ab1:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  801ab4:	89 d8                	mov    %ebx,%eax
  801ab6:	48 83 c4 18          	add    $0x18,%rsp
  801aba:	5b                   	pop    %rbx
  801abb:	41 5c                	pop    %r12
  801abd:	41 5d                	pop    %r13
  801abf:	41 5e                	pop    %r14
  801ac1:	41 5f                	pop    %r15
  801ac3:	5d                   	pop    %rbp
  801ac4:	c3                   	ret
    sys_unmap_region(0, newfd, PAGE_SIZE);
  801ac5:	ba 00 10 00 00       	mov    $0x1000,%edx
  801aca:	4c 89 ee             	mov    %r13,%rsi
  801acd:	bf 00 00 00 00       	mov    $0x0,%edi
  801ad2:	49 bc 1f 13 80 00 00 	movabs $0x80131f,%r12
  801ad9:	00 00 00 
  801adc:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  801adf:	ba 00 10 00 00       	mov    $0x1000,%edx
  801ae4:	4c 89 f6             	mov    %r14,%rsi
  801ae7:	bf 00 00 00 00       	mov    $0x0,%edi
  801aec:	41 ff d4             	call   *%r12
    return res;
  801aef:	eb c3                	jmp    801ab4 <dup+0xea>

0000000000801af1 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  801af1:	f3 0f 1e fa          	endbr64
  801af5:	55                   	push   %rbp
  801af6:	48 89 e5             	mov    %rsp,%rbp
  801af9:	41 56                	push   %r14
  801afb:	41 55                	push   %r13
  801afd:	41 54                	push   %r12
  801aff:	53                   	push   %rbx
  801b00:	48 83 ec 10          	sub    $0x10,%rsp
  801b04:	89 fb                	mov    %edi,%ebx
  801b06:	49 89 f4             	mov    %rsi,%r12
  801b09:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801b0c:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801b10:	48 b8 f6 17 80 00 00 	movabs $0x8017f6,%rax
  801b17:	00 00 00 
  801b1a:	ff d0                	call   *%rax
  801b1c:	85 c0                	test   %eax,%eax
  801b1e:	78 4c                	js     801b6c <read+0x7b>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801b20:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801b24:	41 8b 3e             	mov    (%r14),%edi
  801b27:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801b2b:	48 b8 45 18 80 00 00 	movabs $0x801845,%rax
  801b32:	00 00 00 
  801b35:	ff d0                	call   *%rax
  801b37:	85 c0                	test   %eax,%eax
  801b39:	78 35                	js     801b70 <read+0x7f>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801b3b:	41 8b 46 08          	mov    0x8(%r14),%eax
  801b3f:	83 e0 03             	and    $0x3,%eax
  801b42:	83 f8 01             	cmp    $0x1,%eax
  801b45:	74 2d                	je     801b74 <read+0x83>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  801b47:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b4b:	48 8b 40 10          	mov    0x10(%rax),%rax
  801b4f:	48 85 c0             	test   %rax,%rax
  801b52:	74 56                	je     801baa <read+0xb9>

    return (*dev->dev_read)(fd, buf, n);
  801b54:	4c 89 ea             	mov    %r13,%rdx
  801b57:	4c 89 e6             	mov    %r12,%rsi
  801b5a:	4c 89 f7             	mov    %r14,%rdi
  801b5d:	ff d0                	call   *%rax
}
  801b5f:	48 83 c4 10          	add    $0x10,%rsp
  801b63:	5b                   	pop    %rbx
  801b64:	41 5c                	pop    %r12
  801b66:	41 5d                	pop    %r13
  801b68:	41 5e                	pop    %r14
  801b6a:	5d                   	pop    %rbp
  801b6b:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801b6c:	48 98                	cltq
  801b6e:	eb ef                	jmp    801b5f <read+0x6e>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801b70:	48 98                	cltq
  801b72:	eb eb                	jmp    801b5f <read+0x6e>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801b74:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801b7b:	00 00 00 
  801b7e:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801b84:	89 da                	mov    %ebx,%edx
  801b86:	48 bf e4 31 80 00 00 	movabs $0x8031e4,%rdi
  801b8d:	00 00 00 
  801b90:	b8 00 00 00 00       	mov    $0x0,%eax
  801b95:	48 b9 91 02 80 00 00 	movabs $0x800291,%rcx
  801b9c:	00 00 00 
  801b9f:	ff d1                	call   *%rcx
        return -E_INVAL;
  801ba1:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801ba8:	eb b5                	jmp    801b5f <read+0x6e>
    if (!dev->dev_read) return -E_NOT_SUPP;
  801baa:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801bb1:	eb ac                	jmp    801b5f <read+0x6e>

0000000000801bb3 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801bb3:	f3 0f 1e fa          	endbr64
  801bb7:	55                   	push   %rbp
  801bb8:	48 89 e5             	mov    %rsp,%rbp
  801bbb:	41 57                	push   %r15
  801bbd:	41 56                	push   %r14
  801bbf:	41 55                	push   %r13
  801bc1:	41 54                	push   %r12
  801bc3:	53                   	push   %rbx
  801bc4:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801bc8:	48 85 d2             	test   %rdx,%rdx
  801bcb:	74 54                	je     801c21 <readn+0x6e>
  801bcd:	41 89 fd             	mov    %edi,%r13d
  801bd0:	49 89 f6             	mov    %rsi,%r14
  801bd3:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801bd6:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801bdb:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801be0:	49 bf f1 1a 80 00 00 	movabs $0x801af1,%r15
  801be7:	00 00 00 
  801bea:	4c 89 e2             	mov    %r12,%rdx
  801bed:	48 29 f2             	sub    %rsi,%rdx
  801bf0:	4c 01 f6             	add    %r14,%rsi
  801bf3:	44 89 ef             	mov    %r13d,%edi
  801bf6:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  801bf9:	85 c0                	test   %eax,%eax
  801bfb:	78 20                	js     801c1d <readn+0x6a>
    for (; inc && res < n; res += inc) {
  801bfd:	01 c3                	add    %eax,%ebx
  801bff:	85 c0                	test   %eax,%eax
  801c01:	74 08                	je     801c0b <readn+0x58>
  801c03:	48 63 f3             	movslq %ebx,%rsi
  801c06:	4c 39 e6             	cmp    %r12,%rsi
  801c09:	72 df                	jb     801bea <readn+0x37>
    }
    return res;
  801c0b:	48 63 c3             	movslq %ebx,%rax
}
  801c0e:	48 83 c4 08          	add    $0x8,%rsp
  801c12:	5b                   	pop    %rbx
  801c13:	41 5c                	pop    %r12
  801c15:	41 5d                	pop    %r13
  801c17:	41 5e                	pop    %r14
  801c19:	41 5f                	pop    %r15
  801c1b:	5d                   	pop    %rbp
  801c1c:	c3                   	ret
        if (inc < 0) return inc;
  801c1d:	48 98                	cltq
  801c1f:	eb ed                	jmp    801c0e <readn+0x5b>
    int inc = 1, res = 0;
  801c21:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c26:	eb e3                	jmp    801c0b <readn+0x58>

0000000000801c28 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  801c28:	f3 0f 1e fa          	endbr64
  801c2c:	55                   	push   %rbp
  801c2d:	48 89 e5             	mov    %rsp,%rbp
  801c30:	41 56                	push   %r14
  801c32:	41 55                	push   %r13
  801c34:	41 54                	push   %r12
  801c36:	53                   	push   %rbx
  801c37:	48 83 ec 10          	sub    $0x10,%rsp
  801c3b:	89 fb                	mov    %edi,%ebx
  801c3d:	49 89 f4             	mov    %rsi,%r12
  801c40:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801c43:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801c47:	48 b8 f6 17 80 00 00 	movabs $0x8017f6,%rax
  801c4e:	00 00 00 
  801c51:	ff d0                	call   *%rax
  801c53:	85 c0                	test   %eax,%eax
  801c55:	78 47                	js     801c9e <write+0x76>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801c57:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801c5b:	41 8b 3e             	mov    (%r14),%edi
  801c5e:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801c62:	48 b8 45 18 80 00 00 	movabs $0x801845,%rax
  801c69:	00 00 00 
  801c6c:	ff d0                	call   *%rax
  801c6e:	85 c0                	test   %eax,%eax
  801c70:	78 30                	js     801ca2 <write+0x7a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c72:	41 f6 46 08 03       	testb  $0x3,0x8(%r14)
  801c77:	74 2d                	je     801ca6 <write+0x7e>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801c79:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801c7d:	48 8b 40 18          	mov    0x18(%rax),%rax
  801c81:	48 85 c0             	test   %rax,%rax
  801c84:	74 56                	je     801cdc <write+0xb4>

    return (*dev->dev_write)(fd, buf, n);
  801c86:	4c 89 ea             	mov    %r13,%rdx
  801c89:	4c 89 e6             	mov    %r12,%rsi
  801c8c:	4c 89 f7             	mov    %r14,%rdi
  801c8f:	ff d0                	call   *%rax
}
  801c91:	48 83 c4 10          	add    $0x10,%rsp
  801c95:	5b                   	pop    %rbx
  801c96:	41 5c                	pop    %r12
  801c98:	41 5d                	pop    %r13
  801c9a:	41 5e                	pop    %r14
  801c9c:	5d                   	pop    %rbp
  801c9d:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801c9e:	48 98                	cltq
  801ca0:	eb ef                	jmp    801c91 <write+0x69>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801ca2:	48 98                	cltq
  801ca4:	eb eb                	jmp    801c91 <write+0x69>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801ca6:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801cad:	00 00 00 
  801cb0:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801cb6:	89 da                	mov    %ebx,%edx
  801cb8:	48 bf 00 32 80 00 00 	movabs $0x803200,%rdi
  801cbf:	00 00 00 
  801cc2:	b8 00 00 00 00       	mov    $0x0,%eax
  801cc7:	48 b9 91 02 80 00 00 	movabs $0x800291,%rcx
  801cce:	00 00 00 
  801cd1:	ff d1                	call   *%rcx
        return -E_INVAL;
  801cd3:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801cda:	eb b5                	jmp    801c91 <write+0x69>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801cdc:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801ce3:	eb ac                	jmp    801c91 <write+0x69>

0000000000801ce5 <seek>:

int
seek(int fdnum, off_t offset) {
  801ce5:	f3 0f 1e fa          	endbr64
  801ce9:	55                   	push   %rbp
  801cea:	48 89 e5             	mov    %rsp,%rbp
  801ced:	53                   	push   %rbx
  801cee:	48 83 ec 18          	sub    $0x18,%rsp
  801cf2:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801cf4:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801cf8:	48 b8 f6 17 80 00 00 	movabs $0x8017f6,%rax
  801cff:	00 00 00 
  801d02:	ff d0                	call   *%rax
  801d04:	85 c0                	test   %eax,%eax
  801d06:	78 0c                	js     801d14 <seek+0x2f>

    fd->fd_offset = offset;
  801d08:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d0c:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  801d0f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d14:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801d18:	c9                   	leave
  801d19:	c3                   	ret

0000000000801d1a <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  801d1a:	f3 0f 1e fa          	endbr64
  801d1e:	55                   	push   %rbp
  801d1f:	48 89 e5             	mov    %rsp,%rbp
  801d22:	41 55                	push   %r13
  801d24:	41 54                	push   %r12
  801d26:	53                   	push   %rbx
  801d27:	48 83 ec 18          	sub    $0x18,%rsp
  801d2b:	89 fb                	mov    %edi,%ebx
  801d2d:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801d30:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801d34:	48 b8 f6 17 80 00 00 	movabs $0x8017f6,%rax
  801d3b:	00 00 00 
  801d3e:	ff d0                	call   *%rax
  801d40:	85 c0                	test   %eax,%eax
  801d42:	78 38                	js     801d7c <ftruncate+0x62>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801d44:	4c 8b 6d d8          	mov    -0x28(%rbp),%r13
  801d48:	41 8b 7d 00          	mov    0x0(%r13),%edi
  801d4c:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801d50:	48 b8 45 18 80 00 00 	movabs $0x801845,%rax
  801d57:	00 00 00 
  801d5a:	ff d0                	call   *%rax
  801d5c:	85 c0                	test   %eax,%eax
  801d5e:	78 1c                	js     801d7c <ftruncate+0x62>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801d60:	41 f6 45 08 03       	testb  $0x3,0x8(%r13)
  801d65:	74 20                	je     801d87 <ftruncate+0x6d>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801d67:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d6b:	48 8b 40 30          	mov    0x30(%rax),%rax
  801d6f:	48 85 c0             	test   %rax,%rax
  801d72:	74 47                	je     801dbb <ftruncate+0xa1>

    return (*dev->dev_trunc)(fd, newsize);
  801d74:	44 89 e6             	mov    %r12d,%esi
  801d77:	4c 89 ef             	mov    %r13,%rdi
  801d7a:	ff d0                	call   *%rax
}
  801d7c:	48 83 c4 18          	add    $0x18,%rsp
  801d80:	5b                   	pop    %rbx
  801d81:	41 5c                	pop    %r12
  801d83:	41 5d                	pop    %r13
  801d85:	5d                   	pop    %rbp
  801d86:	c3                   	ret
                thisenv->env_id, fdnum);
  801d87:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801d8e:	00 00 00 
  801d91:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801d97:	89 da                	mov    %ebx,%edx
  801d99:	48 bf 40 36 80 00 00 	movabs $0x803640,%rdi
  801da0:	00 00 00 
  801da3:	b8 00 00 00 00       	mov    $0x0,%eax
  801da8:	48 b9 91 02 80 00 00 	movabs $0x800291,%rcx
  801daf:	00 00 00 
  801db2:	ff d1                	call   *%rcx
        return -E_INVAL;
  801db4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801db9:	eb c1                	jmp    801d7c <ftruncate+0x62>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801dbb:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801dc0:	eb ba                	jmp    801d7c <ftruncate+0x62>

0000000000801dc2 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  801dc2:	f3 0f 1e fa          	endbr64
  801dc6:	55                   	push   %rbp
  801dc7:	48 89 e5             	mov    %rsp,%rbp
  801dca:	41 54                	push   %r12
  801dcc:	53                   	push   %rbx
  801dcd:	48 83 ec 10          	sub    $0x10,%rsp
  801dd1:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801dd4:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801dd8:	48 b8 f6 17 80 00 00 	movabs $0x8017f6,%rax
  801ddf:	00 00 00 
  801de2:	ff d0                	call   *%rax
  801de4:	85 c0                	test   %eax,%eax
  801de6:	78 4e                	js     801e36 <fstat+0x74>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801de8:	4c 8b 65 e8          	mov    -0x18(%rbp),%r12
  801dec:	41 8b 3c 24          	mov    (%r12),%edi
  801df0:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801df4:	48 b8 45 18 80 00 00 	movabs $0x801845,%rax
  801dfb:	00 00 00 
  801dfe:	ff d0                	call   *%rax
  801e00:	85 c0                	test   %eax,%eax
  801e02:	78 32                	js     801e36 <fstat+0x74>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  801e04:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e08:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  801e0d:	74 30                	je     801e3f <fstat+0x7d>

    stat->st_name[0] = 0;
  801e0f:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  801e12:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  801e19:	00 00 00 
    stat->st_isdir = 0;
  801e1c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801e23:	00 00 00 
    stat->st_dev = dev;
  801e26:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  801e2d:	48 89 de             	mov    %rbx,%rsi
  801e30:	4c 89 e7             	mov    %r12,%rdi
  801e33:	ff 50 28             	call   *0x28(%rax)
}
  801e36:	48 83 c4 10          	add    $0x10,%rsp
  801e3a:	5b                   	pop    %rbx
  801e3b:	41 5c                	pop    %r12
  801e3d:	5d                   	pop    %rbp
  801e3e:	c3                   	ret
    if (!dev->dev_stat) return -E_NOT_SUPP;
  801e3f:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801e44:	eb f0                	jmp    801e36 <fstat+0x74>

0000000000801e46 <stat>:

int
stat(const char *path, struct Stat *stat) {
  801e46:	f3 0f 1e fa          	endbr64
  801e4a:	55                   	push   %rbp
  801e4b:	48 89 e5             	mov    %rsp,%rbp
  801e4e:	41 54                	push   %r12
  801e50:	53                   	push   %rbx
  801e51:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  801e54:	be 00 00 00 00       	mov    $0x0,%esi
  801e59:	48 b8 27 21 80 00 00 	movabs $0x802127,%rax
  801e60:	00 00 00 
  801e63:	ff d0                	call   *%rax
  801e65:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  801e67:	85 c0                	test   %eax,%eax
  801e69:	78 25                	js     801e90 <stat+0x4a>

    int res = fstat(fd, stat);
  801e6b:	4c 89 e6             	mov    %r12,%rsi
  801e6e:	89 c7                	mov    %eax,%edi
  801e70:	48 b8 c2 1d 80 00 00 	movabs $0x801dc2,%rax
  801e77:	00 00 00 
  801e7a:	ff d0                	call   *%rax
  801e7c:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  801e7f:	89 df                	mov    %ebx,%edi
  801e81:	48 b8 67 19 80 00 00 	movabs $0x801967,%rax
  801e88:	00 00 00 
  801e8b:	ff d0                	call   *%rax

    return res;
  801e8d:	44 89 e3             	mov    %r12d,%ebx
}
  801e90:	89 d8                	mov    %ebx,%eax
  801e92:	5b                   	pop    %rbx
  801e93:	41 5c                	pop    %r12
  801e95:	5d                   	pop    %rbp
  801e96:	c3                   	ret

0000000000801e97 <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  801e97:	f3 0f 1e fa          	endbr64
  801e9b:	55                   	push   %rbp
  801e9c:	48 89 e5             	mov    %rsp,%rbp
  801e9f:	41 54                	push   %r12
  801ea1:	53                   	push   %rbx
  801ea2:	48 83 ec 10          	sub    $0x10,%rsp
  801ea6:	41 89 fc             	mov    %edi,%r12d
  801ea9:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801eac:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801eb3:	00 00 00 
  801eb6:	83 38 00             	cmpl   $0x0,(%rax)
  801eb9:	74 6e                	je     801f29 <fsipc+0x92>

    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }
    fsenv = ipc_find_env(ENV_TYPE_FS);
  801ebb:	bf 03 00 00 00       	mov    $0x3,%edi
  801ec0:	48 b8 fe 16 80 00 00 	movabs $0x8016fe,%rax
  801ec7:	00 00 00 
  801eca:	ff d0                	call   *%rax
  801ecc:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  801ed3:	00 00 
    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  801ed5:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  801edb:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801ee0:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  801ee7:	00 00 00 
  801eea:	44 89 e6             	mov    %r12d,%esi
  801eed:	89 c7                	mov    %eax,%edi
  801eef:	48 b8 3c 16 80 00 00 	movabs $0x80163c,%rax
  801ef6:	00 00 00 
  801ef9:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  801efb:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  801f02:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  801f03:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f08:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801f0c:	48 89 de             	mov    %rbx,%rsi
  801f0f:	bf 00 00 00 00       	mov    $0x0,%edi
  801f14:	48 b8 a3 15 80 00 00 	movabs $0x8015a3,%rax
  801f1b:	00 00 00 
  801f1e:	ff d0                	call   *%rax
}
  801f20:	48 83 c4 10          	add    $0x10,%rsp
  801f24:	5b                   	pop    %rbx
  801f25:	41 5c                	pop    %r12
  801f27:	5d                   	pop    %rbp
  801f28:	c3                   	ret
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801f29:	bf 03 00 00 00       	mov    $0x3,%edi
  801f2e:	48 b8 fe 16 80 00 00 	movabs $0x8016fe,%rax
  801f35:	00 00 00 
  801f38:	ff d0                	call   *%rax
  801f3a:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  801f41:	00 00 
  801f43:	e9 73 ff ff ff       	jmp    801ebb <fsipc+0x24>

0000000000801f48 <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  801f48:	f3 0f 1e fa          	endbr64
  801f4c:	55                   	push   %rbp
  801f4d:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801f50:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801f57:	00 00 00 
  801f5a:	8b 57 0c             	mov    0xc(%rdi),%edx
  801f5d:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  801f5f:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  801f62:	be 00 00 00 00       	mov    $0x0,%esi
  801f67:	bf 02 00 00 00       	mov    $0x2,%edi
  801f6c:	48 b8 97 1e 80 00 00 	movabs $0x801e97,%rax
  801f73:	00 00 00 
  801f76:	ff d0                	call   *%rax
}
  801f78:	5d                   	pop    %rbp
  801f79:	c3                   	ret

0000000000801f7a <devfile_flush>:
devfile_flush(struct Fd *fd) {
  801f7a:	f3 0f 1e fa          	endbr64
  801f7e:	55                   	push   %rbp
  801f7f:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801f82:	8b 47 0c             	mov    0xc(%rdi),%eax
  801f85:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  801f8c:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  801f8e:	be 00 00 00 00       	mov    $0x0,%esi
  801f93:	bf 06 00 00 00       	mov    $0x6,%edi
  801f98:	48 b8 97 1e 80 00 00 	movabs $0x801e97,%rax
  801f9f:	00 00 00 
  801fa2:	ff d0                	call   *%rax
}
  801fa4:	5d                   	pop    %rbp
  801fa5:	c3                   	ret

0000000000801fa6 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  801fa6:	f3 0f 1e fa          	endbr64
  801faa:	55                   	push   %rbp
  801fab:	48 89 e5             	mov    %rsp,%rbp
  801fae:	41 54                	push   %r12
  801fb0:	53                   	push   %rbx
  801fb1:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801fb4:	8b 47 0c             	mov    0xc(%rdi),%eax
  801fb7:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  801fbe:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  801fc0:	be 00 00 00 00       	mov    $0x0,%esi
  801fc5:	bf 05 00 00 00       	mov    $0x5,%edi
  801fca:	48 b8 97 1e 80 00 00 	movabs $0x801e97,%rax
  801fd1:	00 00 00 
  801fd4:	ff d0                	call   *%rax
    if (res < 0) return res;
  801fd6:	85 c0                	test   %eax,%eax
  801fd8:	78 3d                	js     802017 <devfile_stat+0x71>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801fda:	49 bc 00 60 80 00 00 	movabs $0x806000,%r12
  801fe1:	00 00 00 
  801fe4:	4c 89 e6             	mov    %r12,%rsi
  801fe7:	48 89 df             	mov    %rbx,%rdi
  801fea:	48 b8 da 0b 80 00 00 	movabs $0x800bda,%rax
  801ff1:	00 00 00 
  801ff4:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  801ff6:	41 8b 84 24 80 00 00 	mov    0x80(%r12),%eax
  801ffd:	00 
  801ffe:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802004:	41 8b 84 24 84 00 00 	mov    0x84(%r12),%eax
  80200b:	00 
  80200c:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  802012:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802017:	5b                   	pop    %rbx
  802018:	41 5c                	pop    %r12
  80201a:	5d                   	pop    %rbp
  80201b:	c3                   	ret

000000000080201c <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  80201c:	f3 0f 1e fa          	endbr64
    if (n >= sizeof(fsipcbuf.write.req_buf)) {
  802020:	48 81 fa ef 0f 00 00 	cmp    $0xfef,%rdx
  802027:	77 41                	ja     80206a <devfile_write+0x4e>
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  802029:	55                   	push   %rbp
  80202a:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  80202d:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  802034:	00 00 00 
  802037:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  80203a:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.write.req_n = n;
  80203c:	48 89 50 08          	mov    %rdx,0x8(%rax)
    memmove(fsipcbuf.write.req_buf, buf, n);
  802040:	48 8d 78 10          	lea    0x10(%rax),%rdi
  802044:	48 b8 f5 0d 80 00 00 	movabs $0x800df5,%rax
  80204b:	00 00 00 
  80204e:	ff d0                	call   *%rax
    res = fsipc(FSREQ_WRITE, NULL);
  802050:	be 00 00 00 00       	mov    $0x0,%esi
  802055:	bf 04 00 00 00       	mov    $0x4,%edi
  80205a:	48 b8 97 1e 80 00 00 	movabs $0x801e97,%rax
  802061:	00 00 00 
  802064:	ff d0                	call   *%rax
  802066:	48 98                	cltq
}
  802068:	5d                   	pop    %rbp
  802069:	c3                   	ret
        return -E_INVAL;
  80206a:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
}
  802071:	c3                   	ret

0000000000802072 <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  802072:	f3 0f 1e fa          	endbr64
  802076:	55                   	push   %rbp
  802077:	48 89 e5             	mov    %rsp,%rbp
  80207a:	41 55                	push   %r13
  80207c:	41 54                	push   %r12
  80207e:	53                   	push   %rbx
  80207f:	48 83 ec 08          	sub    $0x8,%rsp
  802083:	49 89 f4             	mov    %rsi,%r12
  802086:	48 89 d3             	mov    %rdx,%rbx
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  802089:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  802090:	00 00 00 
  802093:	8b 57 0c             	mov    0xc(%rdi),%edx
  802096:	89 10                	mov    %edx,(%rax)
    fsipcbuf.read.req_n = n;
  802098:	48 89 58 08          	mov    %rbx,0x8(%rax)
    res = fsipc(FSREQ_READ, NULL);
  80209c:	be 00 00 00 00       	mov    $0x0,%esi
  8020a1:	bf 03 00 00 00       	mov    $0x3,%edi
  8020a6:	48 b8 97 1e 80 00 00 	movabs $0x801e97,%rax
  8020ad:	00 00 00 
  8020b0:	ff d0                	call   *%rax
  8020b2:	4c 63 e8             	movslq %eax,%r13
    if (res < 0) {
  8020b5:	4d 85 ed             	test   %r13,%r13
  8020b8:	78 2a                	js     8020e4 <devfile_read+0x72>
    assert(res <= n && res <= PAGE_SIZE);
  8020ba:	4c 89 ea             	mov    %r13,%rdx
  8020bd:	4c 39 eb             	cmp    %r13,%rbx
  8020c0:	72 30                	jb     8020f2 <devfile_read+0x80>
  8020c2:	49 81 fd 00 10 00 00 	cmp    $0x1000,%r13
  8020c9:	7f 27                	jg     8020f2 <devfile_read+0x80>
    memmove(buf, &fsipcbuf, res);
  8020cb:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  8020d2:	00 00 00 
  8020d5:	4c 89 e7             	mov    %r12,%rdi
  8020d8:	48 b8 f5 0d 80 00 00 	movabs $0x800df5,%rax
  8020df:	00 00 00 
  8020e2:	ff d0                	call   *%rax
}
  8020e4:	4c 89 e8             	mov    %r13,%rax
  8020e7:	48 83 c4 08          	add    $0x8,%rsp
  8020eb:	5b                   	pop    %rbx
  8020ec:	41 5c                	pop    %r12
  8020ee:	41 5d                	pop    %r13
  8020f0:	5d                   	pop    %rbp
  8020f1:	c3                   	ret
    assert(res <= n && res <= PAGE_SIZE);
  8020f2:	48 b9 1d 32 80 00 00 	movabs $0x80321d,%rcx
  8020f9:	00 00 00 
  8020fc:	48 ba 3a 32 80 00 00 	movabs $0x80323a,%rdx
  802103:	00 00 00 
  802106:	be 7b 00 00 00       	mov    $0x7b,%esi
  80210b:	48 bf 4f 32 80 00 00 	movabs $0x80324f,%rdi
  802112:	00 00 00 
  802115:	b8 00 00 00 00       	mov    $0x0,%eax
  80211a:	49 b8 c3 2c 80 00 00 	movabs $0x802cc3,%r8
  802121:	00 00 00 
  802124:	41 ff d0             	call   *%r8

0000000000802127 <open>:
open(const char *path, int mode) {
  802127:	f3 0f 1e fa          	endbr64
  80212b:	55                   	push   %rbp
  80212c:	48 89 e5             	mov    %rsp,%rbp
  80212f:	41 55                	push   %r13
  802131:	41 54                	push   %r12
  802133:	53                   	push   %rbx
  802134:	48 83 ec 18          	sub    $0x18,%rsp
  802138:	49 89 fc             	mov    %rdi,%r12
  80213b:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  80213e:	48 b8 95 0b 80 00 00 	movabs $0x800b95,%rax
  802145:	00 00 00 
  802148:	ff d0                	call   *%rax
  80214a:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  802150:	0f 87 8a 00 00 00    	ja     8021e0 <open+0xb9>
    if ((res = fd_alloc(&fd)) < 0) return res;
  802156:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  80215a:	48 b8 92 17 80 00 00 	movabs $0x801792,%rax
  802161:	00 00 00 
  802164:	ff d0                	call   *%rax
  802166:	89 c3                	mov    %eax,%ebx
  802168:	85 c0                	test   %eax,%eax
  80216a:	78 50                	js     8021bc <open+0x95>
    strcpy(fsipcbuf.open.req_path, path);
  80216c:	4c 89 e6             	mov    %r12,%rsi
  80216f:	48 bb 00 60 80 00 00 	movabs $0x806000,%rbx
  802176:	00 00 00 
  802179:	48 89 df             	mov    %rbx,%rdi
  80217c:	48 b8 da 0b 80 00 00 	movabs $0x800bda,%rax
  802183:	00 00 00 
  802186:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  802188:	44 89 ab 00 04 00 00 	mov    %r13d,0x400(%rbx)
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  80218f:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802193:	bf 01 00 00 00       	mov    $0x1,%edi
  802198:	48 b8 97 1e 80 00 00 	movabs $0x801e97,%rax
  80219f:	00 00 00 
  8021a2:	ff d0                	call   *%rax
  8021a4:	89 c3                	mov    %eax,%ebx
  8021a6:	85 c0                	test   %eax,%eax
  8021a8:	78 1f                	js     8021c9 <open+0xa2>
    return fd2num(fd);
  8021aa:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8021ae:	48 b8 5c 17 80 00 00 	movabs $0x80175c,%rax
  8021b5:	00 00 00 
  8021b8:	ff d0                	call   *%rax
  8021ba:	89 c3                	mov    %eax,%ebx
}
  8021bc:	89 d8                	mov    %ebx,%eax
  8021be:	48 83 c4 18          	add    $0x18,%rsp
  8021c2:	5b                   	pop    %rbx
  8021c3:	41 5c                	pop    %r12
  8021c5:	41 5d                	pop    %r13
  8021c7:	5d                   	pop    %rbp
  8021c8:	c3                   	ret
        fd_close(fd, 0);
  8021c9:	be 00 00 00 00       	mov    $0x0,%esi
  8021ce:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8021d2:	48 b8 b9 18 80 00 00 	movabs $0x8018b9,%rax
  8021d9:	00 00 00 
  8021dc:	ff d0                	call   *%rax
        return res;
  8021de:	eb dc                	jmp    8021bc <open+0x95>
        return -E_BAD_PATH;
  8021e0:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  8021e5:	eb d5                	jmp    8021bc <open+0x95>

00000000008021e7 <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  8021e7:	f3 0f 1e fa          	endbr64
  8021eb:	55                   	push   %rbp
  8021ec:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  8021ef:	be 00 00 00 00       	mov    $0x0,%esi
  8021f4:	bf 08 00 00 00       	mov    $0x8,%edi
  8021f9:	48 b8 97 1e 80 00 00 	movabs $0x801e97,%rax
  802200:	00 00 00 
  802203:	ff d0                	call   *%rax
}
  802205:	5d                   	pop    %rbp
  802206:	c3                   	ret

0000000000802207 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  802207:	f3 0f 1e fa          	endbr64
  80220b:	55                   	push   %rbp
  80220c:	48 89 e5             	mov    %rsp,%rbp
  80220f:	41 54                	push   %r12
  802211:	53                   	push   %rbx
  802212:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802215:	48 b8 72 17 80 00 00 	movabs $0x801772,%rax
  80221c:	00 00 00 
  80221f:	ff d0                	call   *%rax
  802221:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  802224:	48 be 5a 32 80 00 00 	movabs $0x80325a,%rsi
  80222b:	00 00 00 
  80222e:	48 89 df             	mov    %rbx,%rdi
  802231:	48 b8 da 0b 80 00 00 	movabs $0x800bda,%rax
  802238:	00 00 00 
  80223b:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  80223d:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  802242:	41 2b 04 24          	sub    (%r12),%eax
  802246:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  80224c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  802253:	00 00 00 
    stat->st_dev = &devpipe;
  802256:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  80225d:	00 00 00 
  802260:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  802267:	b8 00 00 00 00       	mov    $0x0,%eax
  80226c:	5b                   	pop    %rbx
  80226d:	41 5c                	pop    %r12
  80226f:	5d                   	pop    %rbp
  802270:	c3                   	ret

0000000000802271 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  802271:	f3 0f 1e fa          	endbr64
  802275:	55                   	push   %rbp
  802276:	48 89 e5             	mov    %rsp,%rbp
  802279:	41 54                	push   %r12
  80227b:	53                   	push   %rbx
  80227c:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  80227f:	ba 00 10 00 00       	mov    $0x1000,%edx
  802284:	48 89 fe             	mov    %rdi,%rsi
  802287:	bf 00 00 00 00       	mov    $0x0,%edi
  80228c:	49 bc 1f 13 80 00 00 	movabs $0x80131f,%r12
  802293:	00 00 00 
  802296:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  802299:	48 89 df             	mov    %rbx,%rdi
  80229c:	48 b8 72 17 80 00 00 	movabs $0x801772,%rax
  8022a3:	00 00 00 
  8022a6:	ff d0                	call   *%rax
  8022a8:	48 89 c6             	mov    %rax,%rsi
  8022ab:	ba 00 10 00 00       	mov    $0x1000,%edx
  8022b0:	bf 00 00 00 00       	mov    $0x0,%edi
  8022b5:	41 ff d4             	call   *%r12
}
  8022b8:	5b                   	pop    %rbx
  8022b9:	41 5c                	pop    %r12
  8022bb:	5d                   	pop    %rbp
  8022bc:	c3                   	ret

00000000008022bd <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  8022bd:	f3 0f 1e fa          	endbr64
  8022c1:	55                   	push   %rbp
  8022c2:	48 89 e5             	mov    %rsp,%rbp
  8022c5:	41 57                	push   %r15
  8022c7:	41 56                	push   %r14
  8022c9:	41 55                	push   %r13
  8022cb:	41 54                	push   %r12
  8022cd:	53                   	push   %rbx
  8022ce:	48 83 ec 18          	sub    $0x18,%rsp
  8022d2:	49 89 fc             	mov    %rdi,%r12
  8022d5:	49 89 f5             	mov    %rsi,%r13
  8022d8:	49 89 d7             	mov    %rdx,%r15
  8022db:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8022df:	48 b8 72 17 80 00 00 	movabs $0x801772,%rax
  8022e6:	00 00 00 
  8022e9:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  8022eb:	4d 85 ff             	test   %r15,%r15
  8022ee:	0f 84 af 00 00 00    	je     8023a3 <devpipe_write+0xe6>
  8022f4:	48 89 c3             	mov    %rax,%rbx
  8022f7:	4c 89 f8             	mov    %r15,%rax
  8022fa:	4d 89 ef             	mov    %r13,%r15
  8022fd:	4c 01 e8             	add    %r13,%rax
  802300:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802304:	49 bd af 11 80 00 00 	movabs $0x8011af,%r13
  80230b:	00 00 00 
            sys_yield();
  80230e:	49 be 44 11 80 00 00 	movabs $0x801144,%r14
  802315:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  802318:	8b 73 04             	mov    0x4(%rbx),%esi
  80231b:	48 63 ce             	movslq %esi,%rcx
  80231e:	48 63 03             	movslq (%rbx),%rax
  802321:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  802327:	48 39 c1             	cmp    %rax,%rcx
  80232a:	72 2e                	jb     80235a <devpipe_write+0x9d>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80232c:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802331:	48 89 da             	mov    %rbx,%rdx
  802334:	be 00 10 00 00       	mov    $0x1000,%esi
  802339:	4c 89 e7             	mov    %r12,%rdi
  80233c:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  80233f:	85 c0                	test   %eax,%eax
  802341:	74 66                	je     8023a9 <devpipe_write+0xec>
            sys_yield();
  802343:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  802346:	8b 73 04             	mov    0x4(%rbx),%esi
  802349:	48 63 ce             	movslq %esi,%rcx
  80234c:	48 63 03             	movslq (%rbx),%rax
  80234f:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  802355:	48 39 c1             	cmp    %rax,%rcx
  802358:	73 d2                	jae    80232c <devpipe_write+0x6f>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80235a:	41 0f b6 3f          	movzbl (%r15),%edi
  80235e:	48 89 ca             	mov    %rcx,%rdx
  802361:	48 c1 ea 03          	shr    $0x3,%rdx
  802365:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  80236c:	08 10 20 
  80236f:	48 f7 e2             	mul    %rdx
  802372:	48 c1 ea 06          	shr    $0x6,%rdx
  802376:	48 89 d0             	mov    %rdx,%rax
  802379:	48 c1 e0 09          	shl    $0x9,%rax
  80237d:	48 29 d0             	sub    %rdx,%rax
  802380:	48 c1 e0 03          	shl    $0x3,%rax
  802384:	48 29 c1             	sub    %rax,%rcx
  802387:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  80238c:	83 c6 01             	add    $0x1,%esi
  80238f:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  802392:	49 83 c7 01          	add    $0x1,%r15
  802396:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80239a:	49 39 c7             	cmp    %rax,%r15
  80239d:	0f 85 75 ff ff ff    	jne    802318 <devpipe_write+0x5b>
    return n;
  8023a3:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8023a7:	eb 05                	jmp    8023ae <devpipe_write+0xf1>
            if (_pipeisclosed(fd, p)) return 0;
  8023a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023ae:	48 83 c4 18          	add    $0x18,%rsp
  8023b2:	5b                   	pop    %rbx
  8023b3:	41 5c                	pop    %r12
  8023b5:	41 5d                	pop    %r13
  8023b7:	41 5e                	pop    %r14
  8023b9:	41 5f                	pop    %r15
  8023bb:	5d                   	pop    %rbp
  8023bc:	c3                   	ret

00000000008023bd <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  8023bd:	f3 0f 1e fa          	endbr64
  8023c1:	55                   	push   %rbp
  8023c2:	48 89 e5             	mov    %rsp,%rbp
  8023c5:	41 57                	push   %r15
  8023c7:	41 56                	push   %r14
  8023c9:	41 55                	push   %r13
  8023cb:	41 54                	push   %r12
  8023cd:	53                   	push   %rbx
  8023ce:	48 83 ec 18          	sub    $0x18,%rsp
  8023d2:	49 89 fc             	mov    %rdi,%r12
  8023d5:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  8023d9:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8023dd:	48 b8 72 17 80 00 00 	movabs $0x801772,%rax
  8023e4:	00 00 00 
  8023e7:	ff d0                	call   *%rax
  8023e9:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  8023ec:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8023f2:	49 bd af 11 80 00 00 	movabs $0x8011af,%r13
  8023f9:	00 00 00 
            sys_yield();
  8023fc:	49 be 44 11 80 00 00 	movabs $0x801144,%r14
  802403:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  802406:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80240b:	74 7d                	je     80248a <devpipe_read+0xcd>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  80240d:	8b 03                	mov    (%rbx),%eax
  80240f:	3b 43 04             	cmp    0x4(%rbx),%eax
  802412:	75 26                	jne    80243a <devpipe_read+0x7d>
            if (i > 0) return i;
  802414:	4d 85 ff             	test   %r15,%r15
  802417:	75 77                	jne    802490 <devpipe_read+0xd3>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802419:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80241e:	48 89 da             	mov    %rbx,%rdx
  802421:	be 00 10 00 00       	mov    $0x1000,%esi
  802426:	4c 89 e7             	mov    %r12,%rdi
  802429:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  80242c:	85 c0                	test   %eax,%eax
  80242e:	74 72                	je     8024a2 <devpipe_read+0xe5>
            sys_yield();
  802430:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802433:	8b 03                	mov    (%rbx),%eax
  802435:	3b 43 04             	cmp    0x4(%rbx),%eax
  802438:	74 df                	je     802419 <devpipe_read+0x5c>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80243a:	48 63 c8             	movslq %eax,%rcx
  80243d:	48 89 ca             	mov    %rcx,%rdx
  802440:	48 c1 ea 03          	shr    $0x3,%rdx
  802444:	48 be 81 00 01 02 04 	movabs $0x2010080402010081,%rsi
  80244b:	08 10 20 
  80244e:	48 89 d0             	mov    %rdx,%rax
  802451:	48 f7 e6             	mul    %rsi
  802454:	48 c1 ea 06          	shr    $0x6,%rdx
  802458:	48 89 d0             	mov    %rdx,%rax
  80245b:	48 c1 e0 09          	shl    $0x9,%rax
  80245f:	48 29 d0             	sub    %rdx,%rax
  802462:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802469:	00 
  80246a:	48 89 c8             	mov    %rcx,%rax
  80246d:	48 29 d0             	sub    %rdx,%rax
  802470:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  802475:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  802479:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  80247d:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  802480:	49 83 c7 01          	add    $0x1,%r15
  802484:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  802488:	75 83                	jne    80240d <devpipe_read+0x50>
    return n;
  80248a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80248e:	eb 03                	jmp    802493 <devpipe_read+0xd6>
            if (i > 0) return i;
  802490:	4c 89 f8             	mov    %r15,%rax
}
  802493:	48 83 c4 18          	add    $0x18,%rsp
  802497:	5b                   	pop    %rbx
  802498:	41 5c                	pop    %r12
  80249a:	41 5d                	pop    %r13
  80249c:	41 5e                	pop    %r14
  80249e:	41 5f                	pop    %r15
  8024a0:	5d                   	pop    %rbp
  8024a1:	c3                   	ret
            if (_pipeisclosed(fd, p)) return 0;
  8024a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8024a7:	eb ea                	jmp    802493 <devpipe_read+0xd6>

00000000008024a9 <pipe>:
pipe(int pfd[2]) {
  8024a9:	f3 0f 1e fa          	endbr64
  8024ad:	55                   	push   %rbp
  8024ae:	48 89 e5             	mov    %rsp,%rbp
  8024b1:	41 55                	push   %r13
  8024b3:	41 54                	push   %r12
  8024b5:	53                   	push   %rbx
  8024b6:	48 83 ec 18          	sub    $0x18,%rsp
  8024ba:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  8024bd:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  8024c1:	48 b8 92 17 80 00 00 	movabs $0x801792,%rax
  8024c8:	00 00 00 
  8024cb:	ff d0                	call   *%rax
  8024cd:	89 c3                	mov    %eax,%ebx
  8024cf:	85 c0                	test   %eax,%eax
  8024d1:	0f 88 a0 01 00 00    	js     802677 <pipe+0x1ce>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  8024d7:	b9 46 00 00 00       	mov    $0x46,%ecx
  8024dc:	ba 00 10 00 00       	mov    $0x1000,%edx
  8024e1:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8024e5:	bf 00 00 00 00       	mov    $0x0,%edi
  8024ea:	48 b8 df 11 80 00 00 	movabs $0x8011df,%rax
  8024f1:	00 00 00 
  8024f4:	ff d0                	call   *%rax
  8024f6:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  8024f8:	85 c0                	test   %eax,%eax
  8024fa:	0f 88 77 01 00 00    	js     802677 <pipe+0x1ce>
    if ((res = fd_alloc(&fd1)) < 0 ||
  802500:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  802504:	48 b8 92 17 80 00 00 	movabs $0x801792,%rax
  80250b:	00 00 00 
  80250e:	ff d0                	call   *%rax
  802510:	89 c3                	mov    %eax,%ebx
  802512:	85 c0                	test   %eax,%eax
  802514:	0f 88 43 01 00 00    	js     80265d <pipe+0x1b4>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  80251a:	b9 46 00 00 00       	mov    $0x46,%ecx
  80251f:	ba 00 10 00 00       	mov    $0x1000,%edx
  802524:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802528:	bf 00 00 00 00       	mov    $0x0,%edi
  80252d:	48 b8 df 11 80 00 00 	movabs $0x8011df,%rax
  802534:	00 00 00 
  802537:	ff d0                	call   *%rax
  802539:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  80253b:	85 c0                	test   %eax,%eax
  80253d:	0f 88 1a 01 00 00    	js     80265d <pipe+0x1b4>
    va = fd2data(fd0);
  802543:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802547:	48 b8 72 17 80 00 00 	movabs $0x801772,%rax
  80254e:	00 00 00 
  802551:	ff d0                	call   *%rax
  802553:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  802556:	b9 46 00 00 00       	mov    $0x46,%ecx
  80255b:	ba 00 10 00 00       	mov    $0x1000,%edx
  802560:	48 89 c6             	mov    %rax,%rsi
  802563:	bf 00 00 00 00       	mov    $0x0,%edi
  802568:	48 b8 df 11 80 00 00 	movabs $0x8011df,%rax
  80256f:	00 00 00 
  802572:	ff d0                	call   *%rax
  802574:	89 c3                	mov    %eax,%ebx
  802576:	85 c0                	test   %eax,%eax
  802578:	0f 88 c5 00 00 00    	js     802643 <pipe+0x19a>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  80257e:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802582:	48 b8 72 17 80 00 00 	movabs $0x801772,%rax
  802589:	00 00 00 
  80258c:	ff d0                	call   *%rax
  80258e:	48 89 c1             	mov    %rax,%rcx
  802591:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  802597:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  80259d:	ba 00 00 00 00       	mov    $0x0,%edx
  8025a2:	4c 89 ee             	mov    %r13,%rsi
  8025a5:	bf 00 00 00 00       	mov    $0x0,%edi
  8025aa:	48 b8 4a 12 80 00 00 	movabs $0x80124a,%rax
  8025b1:	00 00 00 
  8025b4:	ff d0                	call   *%rax
  8025b6:	89 c3                	mov    %eax,%ebx
  8025b8:	85 c0                	test   %eax,%eax
  8025ba:	78 6e                	js     80262a <pipe+0x181>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8025bc:	be 00 10 00 00       	mov    $0x1000,%esi
  8025c1:	4c 89 ef             	mov    %r13,%rdi
  8025c4:	48 b8 79 11 80 00 00 	movabs $0x801179,%rax
  8025cb:	00 00 00 
  8025ce:	ff d0                	call   *%rax
  8025d0:	83 f8 02             	cmp    $0x2,%eax
  8025d3:	0f 85 ab 00 00 00    	jne    802684 <pipe+0x1db>
    fd0->fd_dev_id = devpipe.dev_id;
  8025d9:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  8025e0:	00 00 
  8025e2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8025e6:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  8025e8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8025ec:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  8025f3:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8025f7:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  8025f9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025fd:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  802604:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802608:	48 bb 5c 17 80 00 00 	movabs $0x80175c,%rbx
  80260f:	00 00 00 
  802612:	ff d3                	call   *%rbx
  802614:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  802618:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  80261c:	ff d3                	call   *%rbx
  80261e:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  802623:	bb 00 00 00 00       	mov    $0x0,%ebx
  802628:	eb 4d                	jmp    802677 <pipe+0x1ce>
    sys_unmap_region(0, va, PAGE_SIZE);
  80262a:	ba 00 10 00 00       	mov    $0x1000,%edx
  80262f:	4c 89 ee             	mov    %r13,%rsi
  802632:	bf 00 00 00 00       	mov    $0x0,%edi
  802637:	48 b8 1f 13 80 00 00 	movabs $0x80131f,%rax
  80263e:	00 00 00 
  802641:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  802643:	ba 00 10 00 00       	mov    $0x1000,%edx
  802648:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80264c:	bf 00 00 00 00       	mov    $0x0,%edi
  802651:	48 b8 1f 13 80 00 00 	movabs $0x80131f,%rax
  802658:	00 00 00 
  80265b:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  80265d:	ba 00 10 00 00       	mov    $0x1000,%edx
  802662:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802666:	bf 00 00 00 00       	mov    $0x0,%edi
  80266b:	48 b8 1f 13 80 00 00 	movabs $0x80131f,%rax
  802672:	00 00 00 
  802675:	ff d0                	call   *%rax
}
  802677:	89 d8                	mov    %ebx,%eax
  802679:	48 83 c4 18          	add    $0x18,%rsp
  80267d:	5b                   	pop    %rbx
  80267e:	41 5c                	pop    %r12
  802680:	41 5d                	pop    %r13
  802682:	5d                   	pop    %rbp
  802683:	c3                   	ret
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802684:	48 b9 68 36 80 00 00 	movabs $0x803668,%rcx
  80268b:	00 00 00 
  80268e:	48 ba 3a 32 80 00 00 	movabs $0x80323a,%rdx
  802695:	00 00 00 
  802698:	be 2e 00 00 00       	mov    $0x2e,%esi
  80269d:	48 bf 61 32 80 00 00 	movabs $0x803261,%rdi
  8026a4:	00 00 00 
  8026a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ac:	49 b8 c3 2c 80 00 00 	movabs $0x802cc3,%r8
  8026b3:	00 00 00 
  8026b6:	41 ff d0             	call   *%r8

00000000008026b9 <pipeisclosed>:
pipeisclosed(int fdnum) {
  8026b9:	f3 0f 1e fa          	endbr64
  8026bd:	55                   	push   %rbp
  8026be:	48 89 e5             	mov    %rsp,%rbp
  8026c1:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8026c5:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8026c9:	48 b8 f6 17 80 00 00 	movabs $0x8017f6,%rax
  8026d0:	00 00 00 
  8026d3:	ff d0                	call   *%rax
    if (res < 0) return res;
  8026d5:	85 c0                	test   %eax,%eax
  8026d7:	78 35                	js     80270e <pipeisclosed+0x55>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  8026d9:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8026dd:	48 b8 72 17 80 00 00 	movabs $0x801772,%rax
  8026e4:	00 00 00 
  8026e7:	ff d0                	call   *%rax
  8026e9:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8026ec:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8026f1:	be 00 10 00 00       	mov    $0x1000,%esi
  8026f6:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8026fa:	48 b8 af 11 80 00 00 	movabs $0x8011af,%rax
  802701:	00 00 00 
  802704:	ff d0                	call   *%rax
  802706:	85 c0                	test   %eax,%eax
  802708:	0f 94 c0             	sete   %al
  80270b:	0f b6 c0             	movzbl %al,%eax
}
  80270e:	c9                   	leave
  80270f:	c3                   	ret

0000000000802710 <get_uvpt_entry>:
extern volatile pde_t uvpd[];     /* VA of current page directory */
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
  802710:	f3 0f 1e fa          	endbr64
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802714:	48 89 f8             	mov    %rdi,%rax
  802717:	48 c1 e8 27          	shr    $0x27,%rax
  80271b:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  802722:	7f 00 00 
  802725:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802729:	f6 c2 01             	test   $0x1,%dl
  80272c:	74 6d                	je     80279b <get_uvpt_entry+0x8b>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  80272e:	48 89 f8             	mov    %rdi,%rax
  802731:	48 c1 e8 1e          	shr    $0x1e,%rax
  802735:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  80273c:	7f 00 00 
  80273f:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802743:	f6 c2 01             	test   $0x1,%dl
  802746:	74 62                	je     8027aa <get_uvpt_entry+0x9a>
  802748:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  80274f:	7f 00 00 
  802752:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802756:	f6 c2 80             	test   $0x80,%dl
  802759:	75 4f                	jne    8027aa <get_uvpt_entry+0x9a>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  80275b:	48 89 f8             	mov    %rdi,%rax
  80275e:	48 c1 e8 15          	shr    $0x15,%rax
  802762:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802769:	7f 00 00 
  80276c:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802770:	f6 c2 01             	test   $0x1,%dl
  802773:	74 44                	je     8027b9 <get_uvpt_entry+0xa9>
  802775:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  80277c:	7f 00 00 
  80277f:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802783:	f6 c2 80             	test   $0x80,%dl
  802786:	75 31                	jne    8027b9 <get_uvpt_entry+0xa9>
    return uvpt[VPT(va)];
  802788:	48 c1 ef 0c          	shr    $0xc,%rdi
  80278c:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802793:	7f 00 00 
  802796:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  80279a:	c3                   	ret
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  80279b:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  8027a2:	7f 00 00 
  8027a5:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8027a9:	c3                   	ret
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8027aa:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  8027b1:	7f 00 00 
  8027b4:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8027b8:	c3                   	ret
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8027b9:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  8027c0:	7f 00 00 
  8027c3:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8027c7:	c3                   	ret

00000000008027c8 <get_phys_addr>:

uintptr_t
get_phys_addr(void *va) {
  8027c8:	f3 0f 1e fa          	endbr64
  8027cc:	48 89 fa             	mov    %rdi,%rdx
    if (!(uvpml4[VPML4(va)] & PTE_P))
  8027cf:	48 89 f9             	mov    %rdi,%rcx
  8027d2:	48 c1 e9 27          	shr    $0x27,%rcx
  8027d6:	48 b8 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rax
  8027dd:	7f 00 00 
  8027e0:	48 8b 0c c8          	mov    (%rax,%rcx,8),%rcx
        return -1;
  8027e4:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpml4[VPML4(va)] & PTE_P))
  8027eb:	f6 c1 01             	test   $0x1,%cl
  8027ee:	0f 84 b2 00 00 00    	je     8028a6 <get_phys_addr+0xde>
    if (!(uvpdp[VPDP(va)] & PTE_P))
  8027f4:	48 89 f9             	mov    %rdi,%rcx
  8027f7:	48 c1 e9 1e          	shr    $0x1e,%rcx
  8027fb:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802802:	7f 00 00 
  802805:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  802809:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpdp[VPDP(va)] & PTE_P))
  802810:	40 f6 c6 01          	test   $0x1,%sil
  802814:	0f 84 8c 00 00 00    	je     8028a6 <get_phys_addr+0xde>
    if (uvpdp[VPDP(va)] & PTE_PS)
  80281a:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802821:	7f 00 00 
  802824:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802828:	a8 80                	test   $0x80,%al
  80282a:	75 7b                	jne    8028a7 <get_phys_addr+0xdf>
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
    if (!(uvpd[VPD(va)] & PTE_P))
  80282c:	48 89 f9             	mov    %rdi,%rcx
  80282f:	48 c1 e9 15          	shr    $0x15,%rcx
  802833:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  80283a:	7f 00 00 
  80283d:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  802841:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpd[VPD(va)] & PTE_P))
  802848:	40 f6 c6 01          	test   $0x1,%sil
  80284c:	74 58                	je     8028a6 <get_phys_addr+0xde>
    if ((uvpd[VPD(va)] & PTE_PS))
  80284e:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  802855:	7f 00 00 
  802858:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  80285c:	a8 80                	test   $0x80,%al
  80285e:	75 6c                	jne    8028cc <get_phys_addr+0x104>
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
    if (!(uvpt[VPT(va)] & PTE_P))
  802860:	48 89 f9             	mov    %rdi,%rcx
  802863:	48 c1 e9 0c          	shr    $0xc,%rcx
  802867:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  80286e:	7f 00 00 
  802871:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  802875:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpt[VPT(va)] & PTE_P))
  80287c:	40 f6 c6 01          	test   $0x1,%sil
  802880:	74 24                	je     8028a6 <get_phys_addr+0xde>
    return PTE_ADDR(uvpt[VPT(va)]) + PAGE_OFFSET(va);
  802882:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802889:	7f 00 00 
  80288c:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802890:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802897:	ff ff 7f 
  80289a:	48 21 c8             	and    %rcx,%rax
  80289d:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  8028a3:	48 09 d0             	or     %rdx,%rax
}
  8028a6:	c3                   	ret
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
  8028a7:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  8028ae:	7f 00 00 
  8028b1:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8028b5:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  8028bc:	ff ff 7f 
  8028bf:	48 21 c8             	and    %rcx,%rax
  8028c2:	81 e2 ff ff ff 3f    	and    $0x3fffffff,%edx
  8028c8:	48 01 d0             	add    %rdx,%rax
  8028cb:	c3                   	ret
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
  8028cc:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  8028d3:	7f 00 00 
  8028d6:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8028da:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  8028e1:	ff ff 7f 
  8028e4:	48 21 c8             	and    %rcx,%rax
  8028e7:	81 e2 ff ff 1f 00    	and    $0x1fffff,%edx
  8028ed:	48 01 d0             	add    %rdx,%rax
  8028f0:	c3                   	ret

00000000008028f1 <get_prot>:

int
get_prot(void *va) {
  8028f1:	f3 0f 1e fa          	endbr64
  8028f5:	55                   	push   %rbp
  8028f6:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  8028f9:	48 b8 10 27 80 00 00 	movabs $0x802710,%rax
  802900:	00 00 00 
  802903:	ff d0                	call   *%rax
  802905:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
    if (pte & PTE_P) prot |= PROT_R;
  802908:	83 e0 01             	and    $0x1,%eax
  80290b:	c1 e0 02             	shl    $0x2,%eax
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  80290e:	89 d1                	mov    %edx,%ecx
  802910:	81 e1 00 0a 00 00    	and    $0xa00,%ecx
    if (pte & PTE_P) prot |= PROT_R;
  802916:	09 c8                	or     %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  802918:	89 c1                	mov    %eax,%ecx
  80291a:	83 c9 02             	or     $0x2,%ecx
  80291d:	f6 c2 02             	test   $0x2,%dl
  802920:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  802923:	89 c1                	mov    %eax,%ecx
  802925:	83 c9 01             	or     $0x1,%ecx
  802928:	48 85 d2             	test   %rdx,%rdx
  80292b:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  80292e:	89 c1                	mov    %eax,%ecx
  802930:	83 c9 40             	or     $0x40,%ecx
  802933:	f6 c6 04             	test   $0x4,%dh
  802936:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  802939:	5d                   	pop    %rbp
  80293a:	c3                   	ret

000000000080293b <is_page_dirty>:

bool
is_page_dirty(void *va) {
  80293b:	f3 0f 1e fa          	endbr64
  80293f:	55                   	push   %rbp
  802940:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802943:	48 b8 10 27 80 00 00 	movabs $0x802710,%rax
  80294a:	00 00 00 
  80294d:	ff d0                	call   *%rax
    return pte & PTE_D;
  80294f:	48 c1 e8 06          	shr    $0x6,%rax
  802953:	83 e0 01             	and    $0x1,%eax
}
  802956:	5d                   	pop    %rbp
  802957:	c3                   	ret

0000000000802958 <is_page_present>:

bool
is_page_present(void *va) {
  802958:	f3 0f 1e fa          	endbr64
  80295c:	55                   	push   %rbp
  80295d:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  802960:	48 b8 10 27 80 00 00 	movabs $0x802710,%rax
  802967:	00 00 00 
  80296a:	ff d0                	call   *%rax
  80296c:	83 e0 01             	and    $0x1,%eax
}
  80296f:	5d                   	pop    %rbp
  802970:	c3                   	ret

0000000000802971 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  802971:	f3 0f 1e fa          	endbr64
  802975:	55                   	push   %rbp
  802976:	48 89 e5             	mov    %rsp,%rbp
  802979:	41 57                	push   %r15
  80297b:	41 56                	push   %r14
  80297d:	41 55                	push   %r13
  80297f:	41 54                	push   %r12
  802981:	53                   	push   %rbx
  802982:	48 83 ec 18          	sub    $0x18,%rsp
  802986:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80298a:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
     * NOTE: Skip over larger pages/page directories for efficiency */
    // LAB 11: Your code here:

    int res = 0;
    (void)fun, (void)arg;
    uintptr_t va = 0;
  80298e:	bb 00 00 00 00       	mov    $0x0,%ebx
    while (va < USER_STACK_TOP) {
        size_t size = 0;
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  802993:	49 be 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%r14
  80299a:	7f 00 00 
            size = 1LL << PML4_SHIFT;
            goto next;
        }

        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  80299d:	49 bd 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%r13
  8029a4:	7f 00 00 
    while (va < USER_STACK_TOP) {
  8029a7:	49 bf ff 6f ff ff 7f 	movabs $0x7fffff6fff,%r15
  8029ae:	00 00 00 
  8029b1:	eb 73                	jmp    802a26 <foreach_shared_region+0xb5>
            }

            goto next;
        }

        if (!(uvpd[VPD(va)] & PTE_P)) {
  8029b3:	48 89 d8             	mov    %rbx,%rax
  8029b6:	48 c1 e8 15          	shr    $0x15,%rax
  8029ba:	48 b9 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rcx
  8029c1:	7f 00 00 
  8029c4:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
            size = 1LL << PD_SHIFT;
  8029c8:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
        if (!(uvpd[VPD(va)] & PTE_P)) {
  8029ce:	f6 c2 01             	test   $0x1,%dl
  8029d1:	74 4b                	je     802a1e <foreach_shared_region+0xad>
            goto next;
        }

        if (uvpd[VPD(va)] & PTE_PS) {
  8029d3:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
  8029d7:	f6 c2 80             	test   $0x80,%dl
  8029da:	74 11                	je     8029ed <foreach_shared_region+0x7c>
            size = 1LL << PD_SHIFT;
            if (uvpd[VPD(va)] & PTE_SHARE) {
  8029dc:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
  8029e0:	f6 c4 04             	test   $0x4,%ah
  8029e3:	74 39                	je     802a1e <foreach_shared_region+0xad>
            size = 1LL << PD_SHIFT;
  8029e5:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
  8029eb:	eb 20                	jmp    802a0d <foreach_shared_region+0x9c>

            goto next;
        }

        size = PAGE_SIZE;
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  8029ed:	48 89 da             	mov    %rbx,%rdx
  8029f0:	48 c1 ea 0c          	shr    $0xc,%rdx
  8029f4:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  8029fb:	7f 00 00 
  8029fe:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
        size = PAGE_SIZE;
  802a02:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  802a08:	f6 c4 04             	test   $0x4,%ah
  802a0b:	74 11                	je     802a1e <foreach_shared_region+0xad>
            goto next;
        }

    map:
        fun((void *)va, (void *)(va + size), arg);
  802a0d:	49 8d 34 1c          	lea    (%r12,%rbx,1),%rsi
  802a11:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802a15:	48 89 df             	mov    %rbx,%rdi
  802a18:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802a1c:	ff d0                	call   *%rax
    next:
        va += size;
  802a1e:	4c 01 e3             	add    %r12,%rbx
    while (va < USER_STACK_TOP) {
  802a21:	49 39 df             	cmp    %rbx,%r15
  802a24:	72 3e                	jb     802a64 <foreach_shared_region+0xf3>
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  802a26:	49 8b 06             	mov    (%r14),%rax
  802a29:	a8 01                	test   $0x1,%al
  802a2b:	74 37                	je     802a64 <foreach_shared_region+0xf3>
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802a2d:	48 89 d8             	mov    %rbx,%rax
  802a30:	48 c1 e8 1e          	shr    $0x1e,%rax
  802a34:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
            size = 1LL << PDP_SHIFT;
  802a39:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802a3f:	f6 c2 01             	test   $0x1,%dl
  802a42:	74 da                	je     802a1e <foreach_shared_region+0xad>
        if (uvpdp[VPDP(va)] & PTE_PS) {
  802a44:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
  802a49:	f6 c2 80             	test   $0x80,%dl
  802a4c:	0f 84 61 ff ff ff    	je     8029b3 <foreach_shared_region+0x42>
            if (uvpdp[VPDP(va)] & PTE_SHARE) {
  802a52:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  802a57:	f6 c4 04             	test   $0x4,%ah
  802a5a:	74 c2                	je     802a1e <foreach_shared_region+0xad>
            size = 1LL << PDP_SHIFT;
  802a5c:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
  802a62:	eb a9                	jmp    802a0d <foreach_shared_region+0x9c>
    }
    return res;
}
  802a64:	b8 00 00 00 00       	mov    $0x0,%eax
  802a69:	48 83 c4 18          	add    $0x18,%rsp
  802a6d:	5b                   	pop    %rbx
  802a6e:	41 5c                	pop    %r12
  802a70:	41 5d                	pop    %r13
  802a72:	41 5e                	pop    %r14
  802a74:	41 5f                	pop    %r15
  802a76:	5d                   	pop    %rbp
  802a77:	c3                   	ret

0000000000802a78 <devcons_close>:

    return res;
}

static int
devcons_close(struct Fd *fd) {
  802a78:	f3 0f 1e fa          	endbr64
    USED(fd);

    return 0;
}
  802a7c:	b8 00 00 00 00       	mov    $0x0,%eax
  802a81:	c3                   	ret

0000000000802a82 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  802a82:	f3 0f 1e fa          	endbr64
  802a86:	55                   	push   %rbp
  802a87:	48 89 e5             	mov    %rsp,%rbp
  802a8a:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  802a8d:	48 be 71 32 80 00 00 	movabs $0x803271,%rsi
  802a94:	00 00 00 
  802a97:	48 b8 da 0b 80 00 00 	movabs $0x800bda,%rax
  802a9e:	00 00 00 
  802aa1:	ff d0                	call   *%rax
    return 0;
}
  802aa3:	b8 00 00 00 00       	mov    $0x0,%eax
  802aa8:	5d                   	pop    %rbp
  802aa9:	c3                   	ret

0000000000802aaa <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  802aaa:	f3 0f 1e fa          	endbr64
  802aae:	55                   	push   %rbp
  802aaf:	48 89 e5             	mov    %rsp,%rbp
  802ab2:	41 57                	push   %r15
  802ab4:	41 56                	push   %r14
  802ab6:	41 55                	push   %r13
  802ab8:	41 54                	push   %r12
  802aba:	53                   	push   %rbx
  802abb:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  802ac2:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  802ac9:	48 85 d2             	test   %rdx,%rdx
  802acc:	74 7a                	je     802b48 <devcons_write+0x9e>
  802ace:	49 89 d6             	mov    %rdx,%r14
  802ad1:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802ad7:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  802adc:	49 bf f5 0d 80 00 00 	movabs $0x800df5,%r15
  802ae3:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  802ae6:	4c 89 f3             	mov    %r14,%rbx
  802ae9:	48 29 f3             	sub    %rsi,%rbx
  802aec:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802af1:	48 39 c3             	cmp    %rax,%rbx
  802af4:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  802af8:	4c 63 eb             	movslq %ebx,%r13
  802afb:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  802b02:	48 01 c6             	add    %rax,%rsi
  802b05:	4c 89 ea             	mov    %r13,%rdx
  802b08:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802b0f:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  802b12:	4c 89 ee             	mov    %r13,%rsi
  802b15:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802b1c:	48 b8 3a 10 80 00 00 	movabs $0x80103a,%rax
  802b23:	00 00 00 
  802b26:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  802b28:	41 01 dc             	add    %ebx,%r12d
  802b2b:	49 63 f4             	movslq %r12d,%rsi
  802b2e:	4c 39 f6             	cmp    %r14,%rsi
  802b31:	72 b3                	jb     802ae6 <devcons_write+0x3c>
    return res;
  802b33:	49 63 c4             	movslq %r12d,%rax
}
  802b36:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  802b3d:	5b                   	pop    %rbx
  802b3e:	41 5c                	pop    %r12
  802b40:	41 5d                	pop    %r13
  802b42:	41 5e                	pop    %r14
  802b44:	41 5f                	pop    %r15
  802b46:	5d                   	pop    %rbp
  802b47:	c3                   	ret
    for (res = 0; res < n; res += inc) {
  802b48:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802b4e:	eb e3                	jmp    802b33 <devcons_write+0x89>

0000000000802b50 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802b50:	f3 0f 1e fa          	endbr64
  802b54:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  802b57:	ba 00 00 00 00       	mov    $0x0,%edx
  802b5c:	48 85 c0             	test   %rax,%rax
  802b5f:	74 55                	je     802bb6 <devcons_read+0x66>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802b61:	55                   	push   %rbp
  802b62:	48 89 e5             	mov    %rsp,%rbp
  802b65:	41 55                	push   %r13
  802b67:	41 54                	push   %r12
  802b69:	53                   	push   %rbx
  802b6a:	48 83 ec 08          	sub    $0x8,%rsp
  802b6e:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  802b71:	48 bb 6b 10 80 00 00 	movabs $0x80106b,%rbx
  802b78:	00 00 00 
  802b7b:	49 bc 44 11 80 00 00 	movabs $0x801144,%r12
  802b82:	00 00 00 
  802b85:	eb 03                	jmp    802b8a <devcons_read+0x3a>
  802b87:	41 ff d4             	call   *%r12
  802b8a:	ff d3                	call   *%rbx
  802b8c:	85 c0                	test   %eax,%eax
  802b8e:	74 f7                	je     802b87 <devcons_read+0x37>
    if (c < 0) return c;
  802b90:	48 63 d0             	movslq %eax,%rdx
  802b93:	78 13                	js     802ba8 <devcons_read+0x58>
    if (c == 0x04) return 0;
  802b95:	ba 00 00 00 00       	mov    $0x0,%edx
  802b9a:	83 f8 04             	cmp    $0x4,%eax
  802b9d:	74 09                	je     802ba8 <devcons_read+0x58>
    *(char *)vbuf = (char)c;
  802b9f:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  802ba3:	ba 01 00 00 00       	mov    $0x1,%edx
}
  802ba8:	48 89 d0             	mov    %rdx,%rax
  802bab:	48 83 c4 08          	add    $0x8,%rsp
  802baf:	5b                   	pop    %rbx
  802bb0:	41 5c                	pop    %r12
  802bb2:	41 5d                	pop    %r13
  802bb4:	5d                   	pop    %rbp
  802bb5:	c3                   	ret
  802bb6:	48 89 d0             	mov    %rdx,%rax
  802bb9:	c3                   	ret

0000000000802bba <cputchar>:
cputchar(int ch) {
  802bba:	f3 0f 1e fa          	endbr64
  802bbe:	55                   	push   %rbp
  802bbf:	48 89 e5             	mov    %rsp,%rbp
  802bc2:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  802bc6:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  802bca:	be 01 00 00 00       	mov    $0x1,%esi
  802bcf:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  802bd3:	48 b8 3a 10 80 00 00 	movabs $0x80103a,%rax
  802bda:	00 00 00 
  802bdd:	ff d0                	call   *%rax
}
  802bdf:	c9                   	leave
  802be0:	c3                   	ret

0000000000802be1 <getchar>:
getchar(void) {
  802be1:	f3 0f 1e fa          	endbr64
  802be5:	55                   	push   %rbp
  802be6:	48 89 e5             	mov    %rsp,%rbp
  802be9:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  802bed:	ba 01 00 00 00       	mov    $0x1,%edx
  802bf2:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  802bf6:	bf 00 00 00 00       	mov    $0x0,%edi
  802bfb:	48 b8 f1 1a 80 00 00 	movabs $0x801af1,%rax
  802c02:	00 00 00 
  802c05:	ff d0                	call   *%rax
  802c07:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  802c09:	85 c0                	test   %eax,%eax
  802c0b:	78 06                	js     802c13 <getchar+0x32>
  802c0d:	74 08                	je     802c17 <getchar+0x36>
  802c0f:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  802c13:	89 d0                	mov    %edx,%eax
  802c15:	c9                   	leave
  802c16:	c3                   	ret
    return res < 0 ? res : res ? c :
  802c17:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  802c1c:	eb f5                	jmp    802c13 <getchar+0x32>

0000000000802c1e <iscons>:
iscons(int fdnum) {
  802c1e:	f3 0f 1e fa          	endbr64
  802c22:	55                   	push   %rbp
  802c23:	48 89 e5             	mov    %rsp,%rbp
  802c26:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802c2a:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802c2e:	48 b8 f6 17 80 00 00 	movabs $0x8017f6,%rax
  802c35:	00 00 00 
  802c38:	ff d0                	call   *%rax
    if (res < 0) return res;
  802c3a:	85 c0                	test   %eax,%eax
  802c3c:	78 18                	js     802c56 <iscons+0x38>
    return fd->fd_dev_id == devcons.dev_id;
  802c3e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802c42:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  802c49:	00 00 00 
  802c4c:	8b 00                	mov    (%rax),%eax
  802c4e:	39 02                	cmp    %eax,(%rdx)
  802c50:	0f 94 c0             	sete   %al
  802c53:	0f b6 c0             	movzbl %al,%eax
}
  802c56:	c9                   	leave
  802c57:	c3                   	ret

0000000000802c58 <opencons>:
opencons(void) {
  802c58:	f3 0f 1e fa          	endbr64
  802c5c:	55                   	push   %rbp
  802c5d:	48 89 e5             	mov    %rsp,%rbp
  802c60:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  802c64:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  802c68:	48 b8 92 17 80 00 00 	movabs $0x801792,%rax
  802c6f:	00 00 00 
  802c72:	ff d0                	call   *%rax
  802c74:	85 c0                	test   %eax,%eax
  802c76:	78 49                	js     802cc1 <opencons+0x69>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  802c78:	b9 46 00 00 00       	mov    $0x46,%ecx
  802c7d:	ba 00 10 00 00       	mov    $0x1000,%edx
  802c82:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  802c86:	bf 00 00 00 00       	mov    $0x0,%edi
  802c8b:	48 b8 df 11 80 00 00 	movabs $0x8011df,%rax
  802c92:	00 00 00 
  802c95:	ff d0                	call   *%rax
  802c97:	85 c0                	test   %eax,%eax
  802c99:	78 26                	js     802cc1 <opencons+0x69>
    fd->fd_dev_id = devcons.dev_id;
  802c9b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802c9f:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  802ca6:	00 00 
  802ca8:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  802caa:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802cae:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  802cb5:	48 b8 5c 17 80 00 00 	movabs $0x80175c,%rax
  802cbc:	00 00 00 
  802cbf:	ff d0                	call   *%rax
}
  802cc1:	c9                   	leave
  802cc2:	c3                   	ret

0000000000802cc3 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  802cc3:	f3 0f 1e fa          	endbr64
  802cc7:	55                   	push   %rbp
  802cc8:	48 89 e5             	mov    %rsp,%rbp
  802ccb:	41 56                	push   %r14
  802ccd:	41 55                	push   %r13
  802ccf:	41 54                	push   %r12
  802cd1:	53                   	push   %rbx
  802cd2:	48 83 ec 50          	sub    $0x50,%rsp
  802cd6:	49 89 fc             	mov    %rdi,%r12
  802cd9:	41 89 f5             	mov    %esi,%r13d
  802cdc:	48 89 d3             	mov    %rdx,%rbx
  802cdf:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  802ce3:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  802ce7:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  802ceb:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  802cf2:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802cf6:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  802cfa:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  802cfe:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  802d02:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  802d09:	00 00 00 
  802d0c:	4c 8b 30             	mov    (%rax),%r14
  802d0f:	48 b8 0f 11 80 00 00 	movabs $0x80110f,%rax
  802d16:	00 00 00 
  802d19:	ff d0                	call   *%rax
  802d1b:	89 c6                	mov    %eax,%esi
  802d1d:	45 89 e8             	mov    %r13d,%r8d
  802d20:	4c 89 e1             	mov    %r12,%rcx
  802d23:	4c 89 f2             	mov    %r14,%rdx
  802d26:	48 bf 90 36 80 00 00 	movabs $0x803690,%rdi
  802d2d:	00 00 00 
  802d30:	b8 00 00 00 00       	mov    $0x0,%eax
  802d35:	49 bc 91 02 80 00 00 	movabs $0x800291,%r12
  802d3c:	00 00 00 
  802d3f:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  802d42:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  802d46:	48 89 df             	mov    %rbx,%rdi
  802d49:	48 b8 29 02 80 00 00 	movabs $0x800229,%rax
  802d50:	00 00 00 
  802d53:	ff d0                	call   *%rax
    cprintf("\n");
  802d55:	48 bf fe 31 80 00 00 	movabs $0x8031fe,%rdi
  802d5c:	00 00 00 
  802d5f:	b8 00 00 00 00       	mov    $0x0,%eax
  802d64:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  802d67:	cc                   	int3
  802d68:	eb fd                	jmp    802d67 <_panic+0xa4>

0000000000802d6a <__text_end>:
  802d6a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d71:	00 00 00 
  802d74:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d7b:	00 00 00 
  802d7e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d85:	00 00 00 
  802d88:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d8f:	00 00 00 
  802d92:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d99:	00 00 00 
  802d9c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802da3:	00 00 00 
  802da6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dad:	00 00 00 
  802db0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802db7:	00 00 00 
  802dba:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dc1:	00 00 00 
  802dc4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dcb:	00 00 00 
  802dce:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dd5:	00 00 00 
  802dd8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ddf:	00 00 00 
  802de2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802de9:	00 00 00 
  802dec:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802df3:	00 00 00 
  802df6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dfd:	00 00 00 
  802e00:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e07:	00 00 00 
  802e0a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e11:	00 00 00 
  802e14:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e1b:	00 00 00 
  802e1e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e25:	00 00 00 
  802e28:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e2f:	00 00 00 
  802e32:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e39:	00 00 00 
  802e3c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e43:	00 00 00 
  802e46:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e4d:	00 00 00 
  802e50:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e57:	00 00 00 
  802e5a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e61:	00 00 00 
  802e64:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e6b:	00 00 00 
  802e6e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e75:	00 00 00 
  802e78:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e7f:	00 00 00 
  802e82:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e89:	00 00 00 
  802e8c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e93:	00 00 00 
  802e96:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e9d:	00 00 00 
  802ea0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ea7:	00 00 00 
  802eaa:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802eb1:	00 00 00 
  802eb4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ebb:	00 00 00 
  802ebe:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ec5:	00 00 00 
  802ec8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ecf:	00 00 00 
  802ed2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ed9:	00 00 00 
  802edc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ee3:	00 00 00 
  802ee6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802eed:	00 00 00 
  802ef0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ef7:	00 00 00 
  802efa:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f01:	00 00 00 
  802f04:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f0b:	00 00 00 
  802f0e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f15:	00 00 00 
  802f18:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f1f:	00 00 00 
  802f22:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f29:	00 00 00 
  802f2c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f33:	00 00 00 
  802f36:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f3d:	00 00 00 
  802f40:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f47:	00 00 00 
  802f4a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f51:	00 00 00 
  802f54:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f5b:	00 00 00 
  802f5e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f65:	00 00 00 
  802f68:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f6f:	00 00 00 
  802f72:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f79:	00 00 00 
  802f7c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f83:	00 00 00 
  802f86:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f8d:	00 00 00 
  802f90:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f97:	00 00 00 
  802f9a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fa1:	00 00 00 
  802fa4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fab:	00 00 00 
  802fae:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fb5:	00 00 00 
  802fb8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fbf:	00 00 00 
  802fc2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fc9:	00 00 00 
  802fcc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fd3:	00 00 00 
  802fd6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fdd:	00 00 00 
  802fe0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fe7:	00 00 00 
  802fea:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ff1:	00 00 00 
  802ff4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ffb:	00 00 00 
  802ffe:	66 90                	xchg   %ax,%ax
