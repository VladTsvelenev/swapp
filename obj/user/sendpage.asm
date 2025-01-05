
obj/user/sendpage:     file format elf64-x86-64


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
  80001e:	e8 34 02 00 00       	call   800257 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <umain>:

#define TEMP_ADDR       ((char *)0xa00000)
#define TEMP_ADDR_CHILD ((char *)0xb00000)

void
umain(int argc, char **argv) {
  800025:	f3 0f 1e fa          	endbr64
  800029:	55                   	push   %rbp
  80002a:	48 89 e5             	mov    %rsp,%rbp
  80002d:	41 54                	push   %r12
  80002f:	53                   	push   %rbx
  800030:	48 83 ec 20          	sub    $0x20,%rsp
    envid_t who;

    if ((who = fork()) == 0) {
  800034:	48 b8 f7 16 80 00 00 	movabs $0x8016f7,%rax
  80003b:	00 00 00 
  80003e:	ff d0                	call   *%rax
  800040:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800043:	85 c0                	test   %eax,%eax
  800045:	0f 84 02 01 00 00    	je     80014d <umain+0x128>
        ipc_send(who, 0, TEMP_ADDR_CHILD, PAGE_SIZE, PROT_RW);
        return;
    }

    /* Parent */
    sys_alloc_region(thisenv->env_id, TEMP_ADDR, PAGE_SIZE, PROT_RW);
  80004b:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  800052:	00 00 00 
  800055:	8b b8 c8 00 00 00    	mov    0xc8(%rax),%edi
  80005b:	b9 06 00 00 00       	mov    $0x6,%ecx
  800060:	ba 00 10 00 00       	mov    $0x1000,%edx
  800065:	be 00 00 a0 00       	mov    $0xa00000,%esi
  80006a:	48 b8 33 13 80 00 00 	movabs $0x801333,%rax
  800071:	00 00 00 
  800074:	ff d0                	call   *%rax
    memcpy(TEMP_ADDR, str1, strlen(str1) + 1);
  800076:	48 bb 08 50 80 00 00 	movabs $0x805008,%rbx
  80007d:	00 00 00 
  800080:	48 8b 3b             	mov    (%rbx),%rdi
  800083:	49 bc e9 0c 80 00 00 	movabs $0x800ce9,%r12
  80008a:	00 00 00 
  80008d:	41 ff d4             	call   *%r12
  800090:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800094:	48 8b 33             	mov    (%rbx),%rsi
  800097:	bf 00 00 a0 00       	mov    $0xa00000,%edi
  80009c:	48 b8 b4 0f 80 00 00 	movabs $0x800fb4,%rax
  8000a3:	00 00 00 
  8000a6:	ff d0                	call   *%rax
    ipc_send(who, 0, TEMP_ADDR, PAGE_SIZE, PROT_RW);
  8000a8:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  8000ae:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8000b3:	ba 00 00 a0 00       	mov    $0xa00000,%edx
  8000b8:	be 00 00 00 00       	mov    $0x0,%esi
  8000bd:	8b 7d ec             	mov    -0x14(%rbp),%edi
  8000c0:	48 b8 ec 18 80 00 00 	movabs $0x8018ec,%rax
  8000c7:	00 00 00 
  8000ca:	ff d0                	call   *%rax

    size_t sz = PAGE_SIZE;
  8000cc:	48 c7 45 e0 00 10 00 	movq   $0x1000,-0x20(%rbp)
  8000d3:	00 
    ipc_recv(&who, TEMP_ADDR, &sz, 0);
  8000d4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000d9:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  8000dd:	be 00 00 a0 00       	mov    $0xa00000,%esi
  8000e2:	48 8d 7d ec          	lea    -0x14(%rbp),%rdi
  8000e6:	48 b8 53 18 80 00 00 	movabs $0x801853,%rax
  8000ed:	00 00 00 
  8000f0:	ff d0                	call   *%rax
    cprintf("%x got message: %s\n", who, TEMP_ADDR);
  8000f2:	ba 00 00 a0 00       	mov    $0xa00000,%edx
  8000f7:	8b 75 ec             	mov    -0x14(%rbp),%esi
  8000fa:	48 bf 00 40 80 00 00 	movabs $0x804000,%rdi
  800101:	00 00 00 
  800104:	b8 00 00 00 00       	mov    $0x0,%eax
  800109:	48 b9 e5 03 80 00 00 	movabs $0x8003e5,%rcx
  800110:	00 00 00 
  800113:	ff d1                	call   *%rcx
    if (strncmp(TEMP_ADDR, str2, strlen(str2)) == 0)
  800115:	48 bb 00 50 80 00 00 	movabs $0x805000,%rbx
  80011c:	00 00 00 
  80011f:	48 8b 3b             	mov    (%rbx),%rdi
  800122:	41 ff d4             	call   *%r12
  800125:	48 89 c2             	mov    %rax,%rdx
  800128:	48 8b 33             	mov    (%rbx),%rsi
  80012b:	bf 00 00 a0 00       	mov    $0xa00000,%edi
  800130:	48 b8 09 0e 80 00 00 	movabs $0x800e09,%rax
  800137:	00 00 00 
  80013a:	ff d0                	call   *%rax
  80013c:	85 c0                	test   %eax,%eax
  80013e:	0f 84 f8 00 00 00    	je     80023c <umain+0x217>
        cprintf("parent received correct message\n");
    return;
}
  800144:	48 83 c4 20          	add    $0x20,%rsp
  800148:	5b                   	pop    %rbx
  800149:	41 5c                	pop    %r12
  80014b:	5d                   	pop    %rbp
  80014c:	c3                   	ret
        size_t sz = PAGE_SIZE;
  80014d:	48 c7 45 d8 00 10 00 	movq   $0x1000,-0x28(%rbp)
  800154:	00 
        ipc_recv(&who, TEMP_ADDR_CHILD, &sz, 0);
  800155:	b9 00 00 00 00       	mov    $0x0,%ecx
  80015a:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80015e:	be 00 00 b0 00       	mov    $0xb00000,%esi
  800163:	48 8d 7d ec          	lea    -0x14(%rbp),%rdi
  800167:	48 b8 53 18 80 00 00 	movabs $0x801853,%rax
  80016e:	00 00 00 
  800171:	ff d0                	call   *%rax
        cprintf("%x got message: %s\n", who, TEMP_ADDR_CHILD);
  800173:	ba 00 00 b0 00       	mov    $0xb00000,%edx
  800178:	8b 75 ec             	mov    -0x14(%rbp),%esi
  80017b:	48 bf 00 40 80 00 00 	movabs $0x804000,%rdi
  800182:	00 00 00 
  800185:	b8 00 00 00 00       	mov    $0x0,%eax
  80018a:	48 b9 e5 03 80 00 00 	movabs $0x8003e5,%rcx
  800191:	00 00 00 
  800194:	ff d1                	call   *%rcx
        if (strncmp(TEMP_ADDR_CHILD, str1, strlen(str1)) == 0)
  800196:	48 bb 08 50 80 00 00 	movabs $0x805008,%rbx
  80019d:	00 00 00 
  8001a0:	48 8b 3b             	mov    (%rbx),%rdi
  8001a3:	48 b8 e9 0c 80 00 00 	movabs $0x800ce9,%rax
  8001aa:	00 00 00 
  8001ad:	ff d0                	call   *%rax
  8001af:	48 89 c2             	mov    %rax,%rdx
  8001b2:	48 8b 33             	mov    (%rbx),%rsi
  8001b5:	bf 00 00 b0 00       	mov    $0xb00000,%edi
  8001ba:	48 b8 09 0e 80 00 00 	movabs $0x800e09,%rax
  8001c1:	00 00 00 
  8001c4:	ff d0                	call   *%rax
  8001c6:	85 c0                	test   %eax,%eax
  8001c8:	74 5a                	je     800224 <umain+0x1ff>
        memcpy(TEMP_ADDR_CHILD, str2, strlen(str2) + 1);
  8001ca:	48 bb 00 50 80 00 00 	movabs $0x805000,%rbx
  8001d1:	00 00 00 
  8001d4:	48 8b 3b             	mov    (%rbx),%rdi
  8001d7:	48 b8 e9 0c 80 00 00 	movabs $0x800ce9,%rax
  8001de:	00 00 00 
  8001e1:	ff d0                	call   *%rax
  8001e3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8001e7:	48 8b 33             	mov    (%rbx),%rsi
  8001ea:	bf 00 00 b0 00       	mov    $0xb00000,%edi
  8001ef:	48 b8 b4 0f 80 00 00 	movabs $0x800fb4,%rax
  8001f6:	00 00 00 
  8001f9:	ff d0                	call   *%rax
        ipc_send(who, 0, TEMP_ADDR_CHILD, PAGE_SIZE, PROT_RW);
  8001fb:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  800201:	b9 00 10 00 00       	mov    $0x1000,%ecx
  800206:	ba 00 00 b0 00       	mov    $0xb00000,%edx
  80020b:	be 00 00 00 00       	mov    $0x0,%esi
  800210:	8b 7d ec             	mov    -0x14(%rbp),%edi
  800213:	48 b8 ec 18 80 00 00 	movabs $0x8018ec,%rax
  80021a:	00 00 00 
  80021d:	ff d0                	call   *%rax
        return;
  80021f:	e9 20 ff ff ff       	jmp    800144 <umain+0x11f>
            cprintf("child received correct message\n");
  800224:	48 bf d0 42 80 00 00 	movabs $0x8042d0,%rdi
  80022b:	00 00 00 
  80022e:	48 ba e5 03 80 00 00 	movabs $0x8003e5,%rdx
  800235:	00 00 00 
  800238:	ff d2                	call   *%rdx
  80023a:	eb 8e                	jmp    8001ca <umain+0x1a5>
        cprintf("parent received correct message\n");
  80023c:	48 bf f0 42 80 00 00 	movabs $0x8042f0,%rdi
  800243:	00 00 00 
  800246:	48 ba e5 03 80 00 00 	movabs $0x8003e5,%rdx
  80024d:	00 00 00 
  800250:	ff d2                	call   *%rdx
  800252:	e9 ed fe ff ff       	jmp    800144 <umain+0x11f>

0000000000800257 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  800257:	f3 0f 1e fa          	endbr64
  80025b:	55                   	push   %rbp
  80025c:	48 89 e5             	mov    %rsp,%rbp
  80025f:	41 56                	push   %r14
  800261:	41 55                	push   %r13
  800263:	41 54                	push   %r12
  800265:	53                   	push   %rbx
  800266:	41 89 fd             	mov    %edi,%r13d
  800269:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
     * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  80026c:	48 ba d8 50 80 00 00 	movabs $0x8050d8,%rdx
  800273:	00 00 00 
  800276:	48 b8 d8 50 80 00 00 	movabs $0x8050d8,%rax
  80027d:	00 00 00 
  800280:	48 39 c2             	cmp    %rax,%rdx
  800283:	73 17                	jae    80029c <libmain+0x45>
    void (**ctor)() = &__ctors_start;
  800285:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  800288:	49 89 c4             	mov    %rax,%r12
  80028b:	48 83 c3 08          	add    $0x8,%rbx
  80028f:	b8 00 00 00 00       	mov    $0x0,%eax
  800294:	ff 53 f8             	call   *-0x8(%rbx)
  800297:	4c 39 e3             	cmp    %r12,%rbx
  80029a:	72 ef                	jb     80028b <libmain+0x34>

    /* Set thisenv to point at our Env structure in envs[]. */

    // LAB 8: Your code here
    thisenv = &((struct Env *)UENVS)[ENVX(sys_getenvid())];
  80029c:	48 b8 63 12 80 00 00 	movabs $0x801263,%rax
  8002a3:	00 00 00 
  8002a6:	ff d0                	call   *%rax
  8002a8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002ad:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8002b1:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8002b5:	48 c1 e0 04          	shl    $0x4,%rax
  8002b9:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  8002c0:	00 00 00 
  8002c3:	48 01 d0             	add    %rdx,%rax
  8002c6:	48 a3 00 60 80 00 00 	movabs %rax,0x806000
  8002cd:	00 00 00 

    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  8002d0:	45 85 ed             	test   %r13d,%r13d
  8002d3:	7e 0d                	jle    8002e2 <libmain+0x8b>
  8002d5:	49 8b 06             	mov    (%r14),%rax
  8002d8:	48 a3 10 50 80 00 00 	movabs %rax,0x805010
  8002df:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  8002e2:	4c 89 f6             	mov    %r14,%rsi
  8002e5:	44 89 ef             	mov    %r13d,%edi
  8002e8:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  8002ef:	00 00 00 
  8002f2:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  8002f4:	48 b8 09 03 80 00 00 	movabs $0x800309,%rax
  8002fb:	00 00 00 
  8002fe:	ff d0                	call   *%rax
#endif
}
  800300:	5b                   	pop    %rbx
  800301:	41 5c                	pop    %r12
  800303:	41 5d                	pop    %r13
  800305:	41 5e                	pop    %r14
  800307:	5d                   	pop    %rbp
  800308:	c3                   	ret

0000000000800309 <exit>:

#include <inc/lib.h>

void
exit(void) {
  800309:	f3 0f 1e fa          	endbr64
  80030d:	55                   	push   %rbp
  80030e:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  800311:	48 b8 4e 1c 80 00 00 	movabs $0x801c4e,%rax
  800318:	00 00 00 
  80031b:	ff d0                	call   *%rax
    sys_env_destroy(0);
  80031d:	bf 00 00 00 00       	mov    $0x0,%edi
  800322:	48 b8 f4 11 80 00 00 	movabs $0x8011f4,%rax
  800329:	00 00 00 
  80032c:	ff d0                	call   *%rax
}
  80032e:	5d                   	pop    %rbp
  80032f:	c3                   	ret

0000000000800330 <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  800330:	f3 0f 1e fa          	endbr64
  800334:	55                   	push   %rbp
  800335:	48 89 e5             	mov    %rsp,%rbp
  800338:	53                   	push   %rbx
  800339:	48 83 ec 08          	sub    $0x8,%rsp
  80033d:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  800340:	8b 06                	mov    (%rsi),%eax
  800342:	8d 50 01             	lea    0x1(%rax),%edx
  800345:	89 16                	mov    %edx,(%rsi)
  800347:	48 98                	cltq
  800349:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  80034e:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  800354:	74 0a                	je     800360 <putch+0x30>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  800356:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  80035a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80035e:	c9                   	leave
  80035f:	c3                   	ret
        sys_cputs(state->buf, state->offset);
  800360:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  800364:	be ff 00 00 00       	mov    $0xff,%esi
  800369:	48 b8 8e 11 80 00 00 	movabs $0x80118e,%rax
  800370:	00 00 00 
  800373:	ff d0                	call   *%rax
        state->offset = 0;
  800375:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  80037b:	eb d9                	jmp    800356 <putch+0x26>

000000000080037d <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  80037d:	f3 0f 1e fa          	endbr64
  800381:	55                   	push   %rbp
  800382:	48 89 e5             	mov    %rsp,%rbp
  800385:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80038c:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  80038f:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  800396:	b9 21 00 00 00       	mov    $0x21,%ecx
  80039b:	b8 00 00 00 00       	mov    $0x0,%eax
  8003a0:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  8003a3:	48 89 f1             	mov    %rsi,%rcx
  8003a6:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  8003ad:	48 bf 30 03 80 00 00 	movabs $0x800330,%rdi
  8003b4:	00 00 00 
  8003b7:	48 b8 45 05 80 00 00 	movabs $0x800545,%rax
  8003be:	00 00 00 
  8003c1:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  8003c3:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  8003ca:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  8003d1:	48 b8 8e 11 80 00 00 	movabs $0x80118e,%rax
  8003d8:	00 00 00 
  8003db:	ff d0                	call   *%rax

    return state.count;
}
  8003dd:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  8003e3:	c9                   	leave
  8003e4:	c3                   	ret

00000000008003e5 <cprintf>:

int
cprintf(const char *fmt, ...) {
  8003e5:	f3 0f 1e fa          	endbr64
  8003e9:	55                   	push   %rbp
  8003ea:	48 89 e5             	mov    %rsp,%rbp
  8003ed:	48 83 ec 50          	sub    $0x50,%rsp
  8003f1:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  8003f5:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8003f9:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8003fd:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800401:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  800405:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  80040c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800410:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800414:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800418:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  80041c:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  800420:	48 b8 7d 03 80 00 00 	movabs $0x80037d,%rax
  800427:	00 00 00 
  80042a:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  80042c:	c9                   	leave
  80042d:	c3                   	ret

000000000080042e <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  80042e:	f3 0f 1e fa          	endbr64
  800432:	55                   	push   %rbp
  800433:	48 89 e5             	mov    %rsp,%rbp
  800436:	41 57                	push   %r15
  800438:	41 56                	push   %r14
  80043a:	41 55                	push   %r13
  80043c:	41 54                	push   %r12
  80043e:	53                   	push   %rbx
  80043f:	48 83 ec 18          	sub    $0x18,%rsp
  800443:	49 89 fc             	mov    %rdi,%r12
  800446:	49 89 f5             	mov    %rsi,%r13
  800449:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  80044d:	8b 45 10             	mov    0x10(%rbp),%eax
  800450:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  800453:	41 89 cf             	mov    %ecx,%r15d
  800456:	4c 39 fa             	cmp    %r15,%rdx
  800459:	73 5b                	jae    8004b6 <print_num+0x88>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  80045b:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  80045f:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  800463:	85 db                	test   %ebx,%ebx
  800465:	7e 0e                	jle    800475 <print_num+0x47>
            putch(padc, put_arg);
  800467:	4c 89 ee             	mov    %r13,%rsi
  80046a:	44 89 f7             	mov    %r14d,%edi
  80046d:	41 ff d4             	call   *%r12
        while (--width > 0) {
  800470:	83 eb 01             	sub    $0x1,%ebx
  800473:	75 f2                	jne    800467 <print_num+0x39>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  800475:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  800479:	48 b9 2f 40 80 00 00 	movabs $0x80402f,%rcx
  800480:	00 00 00 
  800483:	48 b8 1e 40 80 00 00 	movabs $0x80401e,%rax
  80048a:	00 00 00 
  80048d:	48 0f 45 c8          	cmovne %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  800491:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800495:	ba 00 00 00 00       	mov    $0x0,%edx
  80049a:	49 f7 f7             	div    %r15
  80049d:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  8004a1:	4c 89 ee             	mov    %r13,%rsi
  8004a4:	41 ff d4             	call   *%r12
}
  8004a7:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  8004ab:	5b                   	pop    %rbx
  8004ac:	41 5c                	pop    %r12
  8004ae:	41 5d                	pop    %r13
  8004b0:	41 5e                	pop    %r14
  8004b2:	41 5f                	pop    %r15
  8004b4:	5d                   	pop    %rbp
  8004b5:	c3                   	ret
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  8004b6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8004ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8004bf:	49 f7 f7             	div    %r15
  8004c2:	48 83 ec 08          	sub    $0x8,%rsp
  8004c6:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  8004ca:	52                   	push   %rdx
  8004cb:	45 0f be c9          	movsbl %r9b,%r9d
  8004cf:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  8004d3:	48 89 c2             	mov    %rax,%rdx
  8004d6:	48 b8 2e 04 80 00 00 	movabs $0x80042e,%rax
  8004dd:	00 00 00 
  8004e0:	ff d0                	call   *%rax
  8004e2:	48 83 c4 10          	add    $0x10,%rsp
  8004e6:	eb 8d                	jmp    800475 <print_num+0x47>

00000000008004e8 <sprintputch>:
    char *end;
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
  8004e8:	f3 0f 1e fa          	endbr64
    state->count++;
  8004ec:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  8004f0:	48 8b 06             	mov    (%rsi),%rax
  8004f3:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  8004f7:	73 0a                	jae    800503 <sprintputch+0x1b>
        *state->start++ = ch;
  8004f9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8004fd:	48 89 16             	mov    %rdx,(%rsi)
  800500:	40 88 38             	mov    %dil,(%rax)
    }
}
  800503:	c3                   	ret

0000000000800504 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  800504:	f3 0f 1e fa          	endbr64
  800508:	55                   	push   %rbp
  800509:	48 89 e5             	mov    %rsp,%rbp
  80050c:	48 83 ec 50          	sub    $0x50,%rsp
  800510:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800514:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800518:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  80051c:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800523:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800527:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80052b:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80052f:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  800533:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800537:	48 b8 45 05 80 00 00 	movabs $0x800545,%rax
  80053e:	00 00 00 
  800541:	ff d0                	call   *%rax
}
  800543:	c9                   	leave
  800544:	c3                   	ret

0000000000800545 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  800545:	f3 0f 1e fa          	endbr64
  800549:	55                   	push   %rbp
  80054a:	48 89 e5             	mov    %rsp,%rbp
  80054d:	41 57                	push   %r15
  80054f:	41 56                	push   %r14
  800551:	41 55                	push   %r13
  800553:	41 54                	push   %r12
  800555:	53                   	push   %rbx
  800556:	48 83 ec 38          	sub    $0x38,%rsp
  80055a:	49 89 fe             	mov    %rdi,%r14
  80055d:	49 89 f5             	mov    %rsi,%r13
  800560:	48 89 d3             	mov    %rdx,%rbx
    va_copy(aq, ap);
  800563:	48 8b 01             	mov    (%rcx),%rax
  800566:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  80056a:	48 8b 41 08          	mov    0x8(%rcx),%rax
  80056e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800572:	48 8b 41 10          	mov    0x10(%rcx),%rax
  800576:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  80057a:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  80057e:	0f b6 3b             	movzbl (%rbx),%edi
  800581:	40 80 ff 25          	cmp    $0x25,%dil
  800585:	74 18                	je     80059f <vprintfmt+0x5a>
            if (!ch) return;
  800587:	40 84 ff             	test   %dil,%dil
  80058a:	0f 84 b2 06 00 00    	je     800c42 <vprintfmt+0x6fd>
            putch(ch, put_arg);
  800590:	40 0f b6 ff          	movzbl %dil,%edi
  800594:	4c 89 ee             	mov    %r13,%rsi
  800597:	41 ff d6             	call   *%r14
        while ((ch = *ufmt++) != '%') {
  80059a:	4c 89 e3             	mov    %r12,%rbx
  80059d:	eb db                	jmp    80057a <vprintfmt+0x35>
        bool altflag = 0, zflag = 0;
  80059f:	be 00 00 00 00       	mov    $0x0,%esi
  8005a4:	c6 45 ab 00          	movb   $0x0,-0x55(%rbp)
        unsigned lflag = 0, base = 10;
  8005a8:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  8005ad:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  8005b3:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  8005ba:	c6 45 aa 20          	movb   $0x20,-0x56(%rbp)
        switch (ch = *ufmt++) {
  8005be:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  8005c3:	41 0f b6 04 24       	movzbl (%r12),%eax
  8005c8:	88 45 a0             	mov    %al,-0x60(%rbp)
  8005cb:	83 e8 23             	sub    $0x23,%eax
  8005ce:	3c 57                	cmp    $0x57,%al
  8005d0:	0f 87 52 06 00 00    	ja     800c28 <vprintfmt+0x6e3>
  8005d6:	0f b6 c0             	movzbl %al,%eax
  8005d9:	48 b9 80 44 80 00 00 	movabs $0x804480,%rcx
  8005e0:	00 00 00 
  8005e3:	3e ff 24 c1          	notrack jmp *(%rcx,%rax,8)
  8005e7:	49 89 dc             	mov    %rbx,%r12
            altflag = 1;
  8005ea:	c6 45 ab 01          	movb   $0x1,-0x55(%rbp)
  8005ee:	eb ce                	jmp    8005be <vprintfmt+0x79>
        switch (ch = *ufmt++) {
  8005f0:	49 89 dc             	mov    %rbx,%r12
  8005f3:	be 01 00 00 00       	mov    $0x1,%esi
  8005f8:	eb c4                	jmp    8005be <vprintfmt+0x79>
            padc = ch;
  8005fa:	0f b6 45 a0          	movzbl -0x60(%rbp),%eax
  8005fe:	88 45 aa             	mov    %al,-0x56(%rbp)
        switch (ch = *ufmt++) {
  800601:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  800604:	eb b8                	jmp    8005be <vprintfmt+0x79>
            precision = va_arg(aq, int);
  800606:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800609:	83 f8 2f             	cmp    $0x2f,%eax
  80060c:	77 24                	ja     800632 <vprintfmt+0xed>
  80060e:	89 c1                	mov    %eax,%ecx
  800610:	48 03 4d c8          	add    -0x38(%rbp),%rcx
  800614:	83 c0 08             	add    $0x8,%eax
  800617:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80061a:	44 8b 39             	mov    (%rcx),%r15d
        switch (ch = *ufmt++) {
  80061d:	49 89 dc             	mov    %rbx,%r12
            if (width < 0) {
  800620:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800624:	79 98                	jns    8005be <vprintfmt+0x79>
                width = precision;
  800626:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
                precision = -1;
  80062a:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  800630:	eb 8c                	jmp    8005be <vprintfmt+0x79>
            precision = va_arg(aq, int);
  800632:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  800636:	48 8d 41 08          	lea    0x8(%rcx),%rax
  80063a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80063e:	eb da                	jmp    80061a <vprintfmt+0xd5>
                precision = precision * 10 + ch - '0';
  800640:	44 0f b6 7d a0       	movzbl -0x60(%rbp),%r15d
  800645:	41 83 ef 30          	sub    $0x30,%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  800649:	41 0f b6 44 24 01    	movzbl 0x1(%r12),%eax
  80064f:	3c 39                	cmp    $0x39,%al
  800651:	77 1c                	ja     80066f <vprintfmt+0x12a>
            for (precision = 0;; ++ufmt) {
  800653:	48 83 c3 01          	add    $0x1,%rbx
                precision = precision * 10 + ch - '0';
  800657:	43 8d 0c bf          	lea    (%r15,%r15,4),%ecx
  80065b:	0f b6 c0             	movzbl %al,%eax
  80065e:	44 8d 7c 48 d0       	lea    -0x30(%rax,%rcx,2),%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  800663:	0f b6 03             	movzbl (%rbx),%eax
  800666:	3c 39                	cmp    $0x39,%al
  800668:	76 e9                	jbe    800653 <vprintfmt+0x10e>
        process_precision:
  80066a:	49 89 dc             	mov    %rbx,%r12
  80066d:	eb b1                	jmp    800620 <vprintfmt+0xdb>
        switch (ch = *ufmt++) {
  80066f:	49 89 dc             	mov    %rbx,%r12
  800672:	eb ac                	jmp    800620 <vprintfmt+0xdb>
            width = MAX(0, width);
  800674:	8b 4d ac             	mov    -0x54(%rbp),%ecx
  800677:	85 c9                	test   %ecx,%ecx
  800679:	b8 00 00 00 00       	mov    $0x0,%eax
  80067e:	0f 49 c1             	cmovns %ecx,%eax
  800681:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  800684:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  800687:	e9 32 ff ff ff       	jmp    8005be <vprintfmt+0x79>
            lflag++;
  80068c:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  80068f:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  800692:	e9 27 ff ff ff       	jmp    8005be <vprintfmt+0x79>
            putch(va_arg(aq, int), put_arg);
  800697:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80069a:	83 f8 2f             	cmp    $0x2f,%eax
  80069d:	77 19                	ja     8006b8 <vprintfmt+0x173>
  80069f:	89 c2                	mov    %eax,%edx
  8006a1:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8006a5:	83 c0 08             	add    $0x8,%eax
  8006a8:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8006ab:	8b 3a                	mov    (%rdx),%edi
  8006ad:	4c 89 ee             	mov    %r13,%rsi
  8006b0:	41 ff d6             	call   *%r14
            break;
  8006b3:	e9 c2 fe ff ff       	jmp    80057a <vprintfmt+0x35>
            putch(va_arg(aq, int), put_arg);
  8006b8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8006bc:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8006c0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8006c4:	eb e5                	jmp    8006ab <vprintfmt+0x166>
            int err = va_arg(aq, int);
  8006c6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8006c9:	83 f8 2f             	cmp    $0x2f,%eax
  8006cc:	77 5a                	ja     800728 <vprintfmt+0x1e3>
  8006ce:	89 c2                	mov    %eax,%edx
  8006d0:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8006d4:	83 c0 08             	add    $0x8,%eax
  8006d7:	89 45 b8             	mov    %eax,-0x48(%rbp)
            if (err < 0) err = -err;
  8006da:	8b 02                	mov    (%rdx),%eax
  8006dc:	89 c1                	mov    %eax,%ecx
  8006de:	f7 d9                	neg    %ecx
  8006e0:	0f 48 c8             	cmovs  %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  8006e3:	83 f9 13             	cmp    $0x13,%ecx
  8006e6:	7f 4e                	jg     800736 <vprintfmt+0x1f1>
  8006e8:	48 63 c1             	movslq %ecx,%rax
  8006eb:	48 ba 40 47 80 00 00 	movabs $0x804740,%rdx
  8006f2:	00 00 00 
  8006f5:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8006f9:	48 85 c0             	test   %rax,%rax
  8006fc:	74 38                	je     800736 <vprintfmt+0x1f1>
                printfmt(putch, put_arg, "%s", strerr);
  8006fe:	48 89 c1             	mov    %rax,%rcx
  800701:	48 ba 5e 42 80 00 00 	movabs $0x80425e,%rdx
  800708:	00 00 00 
  80070b:	4c 89 ee             	mov    %r13,%rsi
  80070e:	4c 89 f7             	mov    %r14,%rdi
  800711:	b8 00 00 00 00       	mov    $0x0,%eax
  800716:	49 b8 04 05 80 00 00 	movabs $0x800504,%r8
  80071d:	00 00 00 
  800720:	41 ff d0             	call   *%r8
  800723:	e9 52 fe ff ff       	jmp    80057a <vprintfmt+0x35>
            int err = va_arg(aq, int);
  800728:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80072c:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800730:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800734:	eb a4                	jmp    8006da <vprintfmt+0x195>
                printfmt(putch, put_arg, "error %d", err);
  800736:	48 ba 47 40 80 00 00 	movabs $0x804047,%rdx
  80073d:	00 00 00 
  800740:	4c 89 ee             	mov    %r13,%rsi
  800743:	4c 89 f7             	mov    %r14,%rdi
  800746:	b8 00 00 00 00       	mov    $0x0,%eax
  80074b:	49 b8 04 05 80 00 00 	movabs $0x800504,%r8
  800752:	00 00 00 
  800755:	41 ff d0             	call   *%r8
  800758:	e9 1d fe ff ff       	jmp    80057a <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  80075d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800760:	83 f8 2f             	cmp    $0x2f,%eax
  800763:	77 6c                	ja     8007d1 <vprintfmt+0x28c>
  800765:	89 c2                	mov    %eax,%edx
  800767:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80076b:	83 c0 08             	add    $0x8,%eax
  80076e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800771:	48 8b 12             	mov    (%rdx),%rdx
            if (!ptr) ptr = "(null)";
  800774:	48 85 d2             	test   %rdx,%rdx
  800777:	48 b8 40 40 80 00 00 	movabs $0x804040,%rax
  80077e:	00 00 00 
  800781:	48 0f 45 c2          	cmovne %rdx,%rax
  800785:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
            if (width > 0 && padc != '-') {
  800789:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  80078d:	7e 06                	jle    800795 <vprintfmt+0x250>
  80078f:	80 7d aa 2d          	cmpb   $0x2d,-0x56(%rbp)
  800793:	75 4a                	jne    8007df <vprintfmt+0x29a>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800795:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800799:	4c 8d 60 01          	lea    0x1(%rax),%r12
  80079d:	0f b6 00             	movzbl (%rax),%eax
  8007a0:	84 c0                	test   %al,%al
  8007a2:	0f 85 9a 00 00 00    	jne    800842 <vprintfmt+0x2fd>
            while (width-- > 0) putch(' ', put_arg);
  8007a8:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8007ab:	44 8d 60 ff          	lea    -0x1(%rax),%r12d
  8007af:	85 c0                	test   %eax,%eax
  8007b1:	0f 8e c3 fd ff ff    	jle    80057a <vprintfmt+0x35>
  8007b7:	4c 89 ee             	mov    %r13,%rsi
  8007ba:	bf 20 00 00 00       	mov    $0x20,%edi
  8007bf:	41 ff d6             	call   *%r14
  8007c2:	41 83 ec 01          	sub    $0x1,%r12d
  8007c6:	41 83 fc ff          	cmp    $0xffffffff,%r12d
  8007ca:	75 eb                	jne    8007b7 <vprintfmt+0x272>
  8007cc:	e9 a9 fd ff ff       	jmp    80057a <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  8007d1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007d5:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8007d9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007dd:	eb 92                	jmp    800771 <vprintfmt+0x22c>
                width -= strnlen(ptr, precision);
  8007df:	49 63 f7             	movslq %r15d,%rsi
  8007e2:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  8007e6:	48 b8 08 0d 80 00 00 	movabs $0x800d08,%rax
  8007ed:	00 00 00 
  8007f0:	ff d0                	call   *%rax
  8007f2:	48 89 c2             	mov    %rax,%rdx
  8007f5:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8007f8:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  8007fa:	8d 70 ff             	lea    -0x1(%rax),%esi
  8007fd:	89 75 ac             	mov    %esi,-0x54(%rbp)
  800800:	85 c0                	test   %eax,%eax
  800802:	7e 91                	jle    800795 <vprintfmt+0x250>
  800804:	44 0f be 65 aa       	movsbl -0x56(%rbp),%r12d
  800809:	4c 89 ee             	mov    %r13,%rsi
  80080c:	44 89 e7             	mov    %r12d,%edi
  80080f:	41 ff d6             	call   *%r14
  800812:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  800816:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800819:	83 f8 ff             	cmp    $0xffffffff,%eax
  80081c:	75 eb                	jne    800809 <vprintfmt+0x2c4>
  80081e:	e9 72 ff ff ff       	jmp    800795 <vprintfmt+0x250>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800823:	0f b6 f8             	movzbl %al,%edi
  800826:	4c 89 ee             	mov    %r13,%rsi
  800829:	41 ff d6             	call   *%r14
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  80082c:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  800830:	49 83 c4 01          	add    $0x1,%r12
  800834:	41 0f b6 44 24 ff    	movzbl -0x1(%r12),%eax
  80083a:	84 c0                	test   %al,%al
  80083c:	0f 84 66 ff ff ff    	je     8007a8 <vprintfmt+0x263>
  800842:	45 85 ff             	test   %r15d,%r15d
  800845:	78 0a                	js     800851 <vprintfmt+0x30c>
  800847:	41 83 ef 01          	sub    $0x1,%r15d
  80084b:	0f 88 57 ff ff ff    	js     8007a8 <vprintfmt+0x263>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800851:	80 7d ab 00          	cmpb   $0x0,-0x55(%rbp)
  800855:	74 cc                	je     800823 <vprintfmt+0x2de>
  800857:	8d 50 e0             	lea    -0x20(%rax),%edx
  80085a:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80085f:	80 fa 5e             	cmp    $0x5e,%dl
  800862:	77 c2                	ja     800826 <vprintfmt+0x2e1>
  800864:	eb bd                	jmp    800823 <vprintfmt+0x2de>
    if (zflag) return va_arg(*ap, size_t);
  800866:	40 84 f6             	test   %sil,%sil
  800869:	75 26                	jne    800891 <vprintfmt+0x34c>
    switch (lflag) {
  80086b:	85 d2                	test   %edx,%edx
  80086d:	74 59                	je     8008c8 <vprintfmt+0x383>
  80086f:	83 fa 01             	cmp    $0x1,%edx
  800872:	74 7b                	je     8008ef <vprintfmt+0x3aa>
        return va_arg(*ap, long long);
  800874:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800877:	83 f8 2f             	cmp    $0x2f,%eax
  80087a:	0f 87 96 00 00 00    	ja     800916 <vprintfmt+0x3d1>
  800880:	89 c2                	mov    %eax,%edx
  800882:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800886:	83 c0 08             	add    $0x8,%eax
  800889:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80088c:	4c 8b 22             	mov    (%rdx),%r12
  80088f:	eb 17                	jmp    8008a8 <vprintfmt+0x363>
    if (zflag) return va_arg(*ap, size_t);
  800891:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800894:	83 f8 2f             	cmp    $0x2f,%eax
  800897:	77 21                	ja     8008ba <vprintfmt+0x375>
  800899:	89 c2                	mov    %eax,%edx
  80089b:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80089f:	83 c0 08             	add    $0x8,%eax
  8008a2:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008a5:	4c 8b 22             	mov    (%rdx),%r12
            if (i < 0) {
  8008a8:	4d 85 e4             	test   %r12,%r12
  8008ab:	78 7a                	js     800927 <vprintfmt+0x3e2>
            num = i;
  8008ad:	4c 89 e2             	mov    %r12,%rdx
        unsigned lflag = 0, base = 10;
  8008b0:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  8008b5:	e9 50 02 00 00       	jmp    800b0a <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8008ba:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008be:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8008c2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008c6:	eb dd                	jmp    8008a5 <vprintfmt+0x360>
        return va_arg(*ap, int);
  8008c8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008cb:	83 f8 2f             	cmp    $0x2f,%eax
  8008ce:	77 11                	ja     8008e1 <vprintfmt+0x39c>
  8008d0:	89 c2                	mov    %eax,%edx
  8008d2:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8008d6:	83 c0 08             	add    $0x8,%eax
  8008d9:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008dc:	4c 63 22             	movslq (%rdx),%r12
  8008df:	eb c7                	jmp    8008a8 <vprintfmt+0x363>
  8008e1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008e5:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8008e9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008ed:	eb ed                	jmp    8008dc <vprintfmt+0x397>
        return va_arg(*ap, long);
  8008ef:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008f2:	83 f8 2f             	cmp    $0x2f,%eax
  8008f5:	77 11                	ja     800908 <vprintfmt+0x3c3>
  8008f7:	89 c2                	mov    %eax,%edx
  8008f9:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8008fd:	83 c0 08             	add    $0x8,%eax
  800900:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800903:	4c 8b 22             	mov    (%rdx),%r12
  800906:	eb a0                	jmp    8008a8 <vprintfmt+0x363>
  800908:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80090c:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800910:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800914:	eb ed                	jmp    800903 <vprintfmt+0x3be>
        return va_arg(*ap, long long);
  800916:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80091a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80091e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800922:	e9 65 ff ff ff       	jmp    80088c <vprintfmt+0x347>
                putch('-', put_arg);
  800927:	4c 89 ee             	mov    %r13,%rsi
  80092a:	bf 2d 00 00 00       	mov    $0x2d,%edi
  80092f:	41 ff d6             	call   *%r14
                i = -i;
  800932:	49 f7 dc             	neg    %r12
  800935:	e9 73 ff ff ff       	jmp    8008ad <vprintfmt+0x368>
    if (zflag) return va_arg(*ap, size_t);
  80093a:	40 84 f6             	test   %sil,%sil
  80093d:	75 32                	jne    800971 <vprintfmt+0x42c>
    switch (lflag) {
  80093f:	85 d2                	test   %edx,%edx
  800941:	74 5d                	je     8009a0 <vprintfmt+0x45b>
  800943:	83 fa 01             	cmp    $0x1,%edx
  800946:	0f 84 82 00 00 00    	je     8009ce <vprintfmt+0x489>
        return va_arg(*ap, unsigned long long);
  80094c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80094f:	83 f8 2f             	cmp    $0x2f,%eax
  800952:	0f 87 a5 00 00 00    	ja     8009fd <vprintfmt+0x4b8>
  800958:	89 c2                	mov    %eax,%edx
  80095a:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80095e:	83 c0 08             	add    $0x8,%eax
  800961:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800964:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800967:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  80096c:	e9 99 01 00 00       	jmp    800b0a <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800971:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800974:	83 f8 2f             	cmp    $0x2f,%eax
  800977:	77 19                	ja     800992 <vprintfmt+0x44d>
  800979:	89 c2                	mov    %eax,%edx
  80097b:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80097f:	83 c0 08             	add    $0x8,%eax
  800982:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800985:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800988:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  80098d:	e9 78 01 00 00       	jmp    800b0a <vprintfmt+0x5c5>
  800992:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800996:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80099a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80099e:	eb e5                	jmp    800985 <vprintfmt+0x440>
        return va_arg(*ap, unsigned int);
  8009a0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009a3:	83 f8 2f             	cmp    $0x2f,%eax
  8009a6:	77 18                	ja     8009c0 <vprintfmt+0x47b>
  8009a8:	89 c2                	mov    %eax,%edx
  8009aa:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8009ae:	83 c0 08             	add    $0x8,%eax
  8009b1:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009b4:	8b 12                	mov    (%rdx),%edx
        unsigned lflag = 0, base = 10;
  8009b6:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  8009bb:	e9 4a 01 00 00       	jmp    800b0a <vprintfmt+0x5c5>
  8009c0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009c4:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009c8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009cc:	eb e6                	jmp    8009b4 <vprintfmt+0x46f>
        return va_arg(*ap, unsigned long);
  8009ce:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009d1:	83 f8 2f             	cmp    $0x2f,%eax
  8009d4:	77 19                	ja     8009ef <vprintfmt+0x4aa>
  8009d6:	89 c2                	mov    %eax,%edx
  8009d8:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8009dc:	83 c0 08             	add    $0x8,%eax
  8009df:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009e2:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  8009e5:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  8009ea:	e9 1b 01 00 00       	jmp    800b0a <vprintfmt+0x5c5>
  8009ef:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009f3:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009f7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009fb:	eb e5                	jmp    8009e2 <vprintfmt+0x49d>
        return va_arg(*ap, unsigned long long);
  8009fd:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a01:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a05:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a09:	e9 56 ff ff ff       	jmp    800964 <vprintfmt+0x41f>
    if (zflag) return va_arg(*ap, size_t);
  800a0e:	40 84 f6             	test   %sil,%sil
  800a11:	75 2e                	jne    800a41 <vprintfmt+0x4fc>
    switch (lflag) {
  800a13:	85 d2                	test   %edx,%edx
  800a15:	74 59                	je     800a70 <vprintfmt+0x52b>
  800a17:	83 fa 01             	cmp    $0x1,%edx
  800a1a:	74 7f                	je     800a9b <vprintfmt+0x556>
        return va_arg(*ap, unsigned long long);
  800a1c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a1f:	83 f8 2f             	cmp    $0x2f,%eax
  800a22:	0f 87 9f 00 00 00    	ja     800ac7 <vprintfmt+0x582>
  800a28:	89 c2                	mov    %eax,%edx
  800a2a:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a2e:	83 c0 08             	add    $0x8,%eax
  800a31:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a34:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800a37:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  800a3c:	e9 c9 00 00 00       	jmp    800b0a <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800a41:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a44:	83 f8 2f             	cmp    $0x2f,%eax
  800a47:	77 19                	ja     800a62 <vprintfmt+0x51d>
  800a49:	89 c2                	mov    %eax,%edx
  800a4b:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a4f:	83 c0 08             	add    $0x8,%eax
  800a52:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a55:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800a58:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800a5d:	e9 a8 00 00 00       	jmp    800b0a <vprintfmt+0x5c5>
  800a62:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a66:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a6a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a6e:	eb e5                	jmp    800a55 <vprintfmt+0x510>
        return va_arg(*ap, unsigned int);
  800a70:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a73:	83 f8 2f             	cmp    $0x2f,%eax
  800a76:	77 15                	ja     800a8d <vprintfmt+0x548>
  800a78:	89 c2                	mov    %eax,%edx
  800a7a:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a7e:	83 c0 08             	add    $0x8,%eax
  800a81:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a84:	8b 12                	mov    (%rdx),%edx
            base = 8;
  800a86:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  800a8b:	eb 7d                	jmp    800b0a <vprintfmt+0x5c5>
  800a8d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a91:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a95:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a99:	eb e9                	jmp    800a84 <vprintfmt+0x53f>
        return va_arg(*ap, unsigned long);
  800a9b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a9e:	83 f8 2f             	cmp    $0x2f,%eax
  800aa1:	77 16                	ja     800ab9 <vprintfmt+0x574>
  800aa3:	89 c2                	mov    %eax,%edx
  800aa5:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800aa9:	83 c0 08             	add    $0x8,%eax
  800aac:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800aaf:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800ab2:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  800ab7:	eb 51                	jmp    800b0a <vprintfmt+0x5c5>
  800ab9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800abd:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800ac1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ac5:	eb e8                	jmp    800aaf <vprintfmt+0x56a>
        return va_arg(*ap, unsigned long long);
  800ac7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800acb:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800acf:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ad3:	e9 5c ff ff ff       	jmp    800a34 <vprintfmt+0x4ef>
            putch('0', put_arg);
  800ad8:	4c 89 ee             	mov    %r13,%rsi
  800adb:	bf 30 00 00 00       	mov    $0x30,%edi
  800ae0:	41 ff d6             	call   *%r14
            putch('x', put_arg);
  800ae3:	4c 89 ee             	mov    %r13,%rsi
  800ae6:	bf 78 00 00 00       	mov    $0x78,%edi
  800aeb:	41 ff d6             	call   *%r14
            num = (uintptr_t)va_arg(aq, void *);
  800aee:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800af1:	83 f8 2f             	cmp    $0x2f,%eax
  800af4:	77 47                	ja     800b3d <vprintfmt+0x5f8>
  800af6:	89 c2                	mov    %eax,%edx
  800af8:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800afc:	83 c0 08             	add    $0x8,%eax
  800aff:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b02:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800b05:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  800b0a:	48 83 ec 08          	sub    $0x8,%rsp
  800b0e:	80 7d a0 58          	cmpb   $0x58,-0x60(%rbp)
  800b12:	0f 94 c0             	sete   %al
  800b15:	0f b6 c0             	movzbl %al,%eax
  800b18:	50                   	push   %rax
  800b19:	44 0f be 4d aa       	movsbl -0x56(%rbp),%r9d
  800b1e:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  800b22:	4c 89 ee             	mov    %r13,%rsi
  800b25:	4c 89 f7             	mov    %r14,%rdi
  800b28:	48 b8 2e 04 80 00 00 	movabs $0x80042e,%rax
  800b2f:	00 00 00 
  800b32:	ff d0                	call   *%rax
            break;
  800b34:	48 83 c4 10          	add    $0x10,%rsp
  800b38:	e9 3d fa ff ff       	jmp    80057a <vprintfmt+0x35>
            num = (uintptr_t)va_arg(aq, void *);
  800b3d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b41:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b45:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b49:	eb b7                	jmp    800b02 <vprintfmt+0x5bd>
    if (zflag) return va_arg(*ap, size_t);
  800b4b:	40 84 f6             	test   %sil,%sil
  800b4e:	75 2b                	jne    800b7b <vprintfmt+0x636>
    switch (lflag) {
  800b50:	85 d2                	test   %edx,%edx
  800b52:	74 56                	je     800baa <vprintfmt+0x665>
  800b54:	83 fa 01             	cmp    $0x1,%edx
  800b57:	74 7f                	je     800bd8 <vprintfmt+0x693>
        return va_arg(*ap, unsigned long long);
  800b59:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b5c:	83 f8 2f             	cmp    $0x2f,%eax
  800b5f:	0f 87 a2 00 00 00    	ja     800c07 <vprintfmt+0x6c2>
  800b65:	89 c2                	mov    %eax,%edx
  800b67:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b6b:	83 c0 08             	add    $0x8,%eax
  800b6e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b71:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800b74:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800b79:	eb 8f                	jmp    800b0a <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800b7b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b7e:	83 f8 2f             	cmp    $0x2f,%eax
  800b81:	77 19                	ja     800b9c <vprintfmt+0x657>
  800b83:	89 c2                	mov    %eax,%edx
  800b85:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b89:	83 c0 08             	add    $0x8,%eax
  800b8c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b8f:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800b92:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800b97:	e9 6e ff ff ff       	jmp    800b0a <vprintfmt+0x5c5>
  800b9c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ba0:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800ba4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ba8:	eb e5                	jmp    800b8f <vprintfmt+0x64a>
        return va_arg(*ap, unsigned int);
  800baa:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bad:	83 f8 2f             	cmp    $0x2f,%eax
  800bb0:	77 18                	ja     800bca <vprintfmt+0x685>
  800bb2:	89 c2                	mov    %eax,%edx
  800bb4:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800bb8:	83 c0 08             	add    $0x8,%eax
  800bbb:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800bbe:	8b 12                	mov    (%rdx),%edx
            base = 16;
  800bc0:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  800bc5:	e9 40 ff ff ff       	jmp    800b0a <vprintfmt+0x5c5>
  800bca:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bce:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800bd2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800bd6:	eb e6                	jmp    800bbe <vprintfmt+0x679>
        return va_arg(*ap, unsigned long);
  800bd8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bdb:	83 f8 2f             	cmp    $0x2f,%eax
  800bde:	77 19                	ja     800bf9 <vprintfmt+0x6b4>
  800be0:	89 c2                	mov    %eax,%edx
  800be2:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800be6:	83 c0 08             	add    $0x8,%eax
  800be9:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800bec:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800bef:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800bf4:	e9 11 ff ff ff       	jmp    800b0a <vprintfmt+0x5c5>
  800bf9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bfd:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800c01:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c05:	eb e5                	jmp    800bec <vprintfmt+0x6a7>
        return va_arg(*ap, unsigned long long);
  800c07:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c0b:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800c0f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c13:	e9 59 ff ff ff       	jmp    800b71 <vprintfmt+0x62c>
            putch(ch, put_arg);
  800c18:	4c 89 ee             	mov    %r13,%rsi
  800c1b:	bf 25 00 00 00       	mov    $0x25,%edi
  800c20:	41 ff d6             	call   *%r14
            break;
  800c23:	e9 52 f9 ff ff       	jmp    80057a <vprintfmt+0x35>
            putch('%', put_arg);
  800c28:	4c 89 ee             	mov    %r13,%rsi
  800c2b:	bf 25 00 00 00       	mov    $0x25,%edi
  800c30:	41 ff d6             	call   *%r14
            while ((--ufmt)[-1] != '%') /* nothing */
  800c33:	48 83 eb 01          	sub    $0x1,%rbx
  800c37:	80 7b ff 25          	cmpb   $0x25,-0x1(%rbx)
  800c3b:	75 f6                	jne    800c33 <vprintfmt+0x6ee>
  800c3d:	e9 38 f9 ff ff       	jmp    80057a <vprintfmt+0x35>
}
  800c42:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800c46:	5b                   	pop    %rbx
  800c47:	41 5c                	pop    %r12
  800c49:	41 5d                	pop    %r13
  800c4b:	41 5e                	pop    %r14
  800c4d:	41 5f                	pop    %r15
  800c4f:	5d                   	pop    %rbp
  800c50:	c3                   	ret

0000000000800c51 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800c51:	f3 0f 1e fa          	endbr64
  800c55:	55                   	push   %rbp
  800c56:	48 89 e5             	mov    %rsp,%rbp
  800c59:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800c5d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800c61:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800c66:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800c6a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800c71:	48 85 ff             	test   %rdi,%rdi
  800c74:	74 2b                	je     800ca1 <vsnprintf+0x50>
  800c76:	48 85 f6             	test   %rsi,%rsi
  800c79:	74 26                	je     800ca1 <vsnprintf+0x50>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800c7b:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800c7f:	48 bf e8 04 80 00 00 	movabs $0x8004e8,%rdi
  800c86:	00 00 00 
  800c89:	48 b8 45 05 80 00 00 	movabs $0x800545,%rax
  800c90:	00 00 00 
  800c93:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800c95:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c99:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800c9c:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800c9f:	c9                   	leave
  800ca0:	c3                   	ret
    if (!buf || n < 1) return -E_INVAL;
  800ca1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ca6:	eb f7                	jmp    800c9f <vsnprintf+0x4e>

0000000000800ca8 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800ca8:	f3 0f 1e fa          	endbr64
  800cac:	55                   	push   %rbp
  800cad:	48 89 e5             	mov    %rsp,%rbp
  800cb0:	48 83 ec 50          	sub    $0x50,%rsp
  800cb4:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800cb8:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800cbc:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800cc0:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800cc7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800ccb:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ccf:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800cd3:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800cd7:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800cdb:	48 b8 51 0c 80 00 00 	movabs $0x800c51,%rax
  800ce2:	00 00 00 
  800ce5:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800ce7:	c9                   	leave
  800ce8:	c3                   	ret

0000000000800ce9 <strlen>:
 * Primespipe runs 3x faster this way */

#define ASM 1

size_t
strlen(const char *s) {
  800ce9:	f3 0f 1e fa          	endbr64
    size_t n = 0;
    while (*s++) n++;
  800ced:	80 3f 00             	cmpb   $0x0,(%rdi)
  800cf0:	74 10                	je     800d02 <strlen+0x19>
    size_t n = 0;
  800cf2:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800cf7:	48 83 c0 01          	add    $0x1,%rax
  800cfb:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800cff:	75 f6                	jne    800cf7 <strlen+0xe>
  800d01:	c3                   	ret
    size_t n = 0;
  800d02:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800d07:	c3                   	ret

0000000000800d08 <strnlen>:

size_t
strnlen(const char *s, size_t size) {
  800d08:	f3 0f 1e fa          	endbr64
  800d0c:	48 89 f0             	mov    %rsi,%rax
    size_t n = 0;
  800d0f:	ba 00 00 00 00       	mov    $0x0,%edx
    while (n < size && *s++) n++;
  800d14:	48 85 f6             	test   %rsi,%rsi
  800d17:	74 10                	je     800d29 <strnlen+0x21>
  800d19:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  800d1d:	74 0b                	je     800d2a <strnlen+0x22>
  800d1f:	48 83 c2 01          	add    $0x1,%rdx
  800d23:	48 39 d0             	cmp    %rdx,%rax
  800d26:	75 f1                	jne    800d19 <strnlen+0x11>
  800d28:	c3                   	ret
  800d29:	c3                   	ret
  800d2a:	48 89 d0             	mov    %rdx,%rax
    return n;
}
  800d2d:	c3                   	ret

0000000000800d2e <strcpy>:

char *
strcpy(char *dst, const char *src) {
  800d2e:	f3 0f 1e fa          	endbr64
  800d32:	48 89 f8             	mov    %rdi,%rax
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800d35:	ba 00 00 00 00       	mov    $0x0,%edx
  800d3a:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  800d3e:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  800d41:	48 83 c2 01          	add    $0x1,%rdx
  800d45:	84 c9                	test   %cl,%cl
  800d47:	75 f1                	jne    800d3a <strcpy+0xc>
        ;
    return res;
}
  800d49:	c3                   	ret

0000000000800d4a <strcat>:

char *
strcat(char *dst, const char *src) {
  800d4a:	f3 0f 1e fa          	endbr64
  800d4e:	55                   	push   %rbp
  800d4f:	48 89 e5             	mov    %rsp,%rbp
  800d52:	41 54                	push   %r12
  800d54:	53                   	push   %rbx
  800d55:	48 89 fb             	mov    %rdi,%rbx
  800d58:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800d5b:	48 b8 e9 0c 80 00 00 	movabs $0x800ce9,%rax
  800d62:	00 00 00 
  800d65:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800d67:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800d6b:	4c 89 e6             	mov    %r12,%rsi
  800d6e:	48 b8 2e 0d 80 00 00 	movabs $0x800d2e,%rax
  800d75:	00 00 00 
  800d78:	ff d0                	call   *%rax
    return dst;
}
  800d7a:	48 89 d8             	mov    %rbx,%rax
  800d7d:	5b                   	pop    %rbx
  800d7e:	41 5c                	pop    %r12
  800d80:	5d                   	pop    %rbp
  800d81:	c3                   	ret

0000000000800d82 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800d82:	f3 0f 1e fa          	endbr64
  800d86:	48 89 f8             	mov    %rdi,%rax
    char *ret = dst;
    while (size-- > 0) {
  800d89:	48 85 d2             	test   %rdx,%rdx
  800d8c:	74 1f                	je     800dad <strncpy+0x2b>
  800d8e:	48 01 fa             	add    %rdi,%rdx
  800d91:	48 89 f9             	mov    %rdi,%rcx
        *dst++ = *src;
  800d94:	48 83 c1 01          	add    $0x1,%rcx
  800d98:	44 0f b6 06          	movzbl (%rsi),%r8d
  800d9c:	44 88 41 ff          	mov    %r8b,-0x1(%rcx)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800da0:	41 80 f8 01          	cmp    $0x1,%r8b
  800da4:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800da8:	48 39 ca             	cmp    %rcx,%rdx
  800dab:	75 e7                	jne    800d94 <strncpy+0x12>
    }
    return ret;
}
  800dad:	c3                   	ret

0000000000800dae <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
  800dae:	f3 0f 1e fa          	endbr64
    char *dst_in = dst;
    if (size) {
  800db2:	48 89 f8             	mov    %rdi,%rax
  800db5:	48 85 d2             	test   %rdx,%rdx
  800db8:	74 24                	je     800dde <strlcpy+0x30>
        while (--size > 0 && *src)
  800dba:	48 83 ea 01          	sub    $0x1,%rdx
  800dbe:	74 1b                	je     800ddb <strlcpy+0x2d>
  800dc0:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800dc4:	0f b6 16             	movzbl (%rsi),%edx
  800dc7:	84 d2                	test   %dl,%dl
  800dc9:	74 10                	je     800ddb <strlcpy+0x2d>
            *dst++ = *src++;
  800dcb:	48 83 c6 01          	add    $0x1,%rsi
  800dcf:	48 83 c0 01          	add    $0x1,%rax
  800dd3:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800dd6:	48 39 c8             	cmp    %rcx,%rax
  800dd9:	75 e9                	jne    800dc4 <strlcpy+0x16>
        *dst = '\0';
  800ddb:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800dde:	48 29 f8             	sub    %rdi,%rax
}
  800de1:	c3                   	ret

0000000000800de2 <strcmp>:
    }
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
  800de2:	f3 0f 1e fa          	endbr64
    while (*p && *p == *q) p++, q++;
  800de6:	0f b6 07             	movzbl (%rdi),%eax
  800de9:	84 c0                	test   %al,%al
  800deb:	74 13                	je     800e00 <strcmp+0x1e>
  800ded:	38 06                	cmp    %al,(%rsi)
  800def:	75 0f                	jne    800e00 <strcmp+0x1e>
  800df1:	48 83 c7 01          	add    $0x1,%rdi
  800df5:	48 83 c6 01          	add    $0x1,%rsi
  800df9:	0f b6 07             	movzbl (%rdi),%eax
  800dfc:	84 c0                	test   %al,%al
  800dfe:	75 ed                	jne    800ded <strcmp+0xb>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800e00:	0f b6 c0             	movzbl %al,%eax
  800e03:	0f b6 16             	movzbl (%rsi),%edx
  800e06:	29 d0                	sub    %edx,%eax
}
  800e08:	c3                   	ret

0000000000800e09 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
  800e09:	f3 0f 1e fa          	endbr64
    while (n && *p && *p == *q) n--, p++, q++;
  800e0d:	48 85 d2             	test   %rdx,%rdx
  800e10:	74 1f                	je     800e31 <strncmp+0x28>
  800e12:	0f b6 07             	movzbl (%rdi),%eax
  800e15:	84 c0                	test   %al,%al
  800e17:	74 1e                	je     800e37 <strncmp+0x2e>
  800e19:	3a 06                	cmp    (%rsi),%al
  800e1b:	75 1a                	jne    800e37 <strncmp+0x2e>
  800e1d:	48 83 c7 01          	add    $0x1,%rdi
  800e21:	48 83 c6 01          	add    $0x1,%rsi
  800e25:	48 83 ea 01          	sub    $0x1,%rdx
  800e29:	75 e7                	jne    800e12 <strncmp+0x9>

    if (!n) return 0;
  800e2b:	b8 00 00 00 00       	mov    $0x0,%eax
  800e30:	c3                   	ret
  800e31:	b8 00 00 00 00       	mov    $0x0,%eax
  800e36:	c3                   	ret

    return (int)((unsigned char)*p - (unsigned char)*q);
  800e37:	0f b6 07             	movzbl (%rdi),%eax
  800e3a:	0f b6 16             	movzbl (%rsi),%edx
  800e3d:	29 d0                	sub    %edx,%eax
}
  800e3f:	c3                   	ret

0000000000800e40 <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
  800e40:	f3 0f 1e fa          	endbr64
    for (; *str; str++) {
  800e44:	0f b6 17             	movzbl (%rdi),%edx
  800e47:	84 d2                	test   %dl,%dl
  800e49:	74 18                	je     800e63 <strchr+0x23>
        if (*str == c) {
  800e4b:	0f be d2             	movsbl %dl,%edx
  800e4e:	39 f2                	cmp    %esi,%edx
  800e50:	74 17                	je     800e69 <strchr+0x29>
    for (; *str; str++) {
  800e52:	48 83 c7 01          	add    $0x1,%rdi
  800e56:	0f b6 17             	movzbl (%rdi),%edx
  800e59:	84 d2                	test   %dl,%dl
  800e5b:	75 ee                	jne    800e4b <strchr+0xb>
            return (char *)str;
        }
    }
    return NULL;
  800e5d:	b8 00 00 00 00       	mov    $0x0,%eax
  800e62:	c3                   	ret
  800e63:	b8 00 00 00 00       	mov    $0x0,%eax
  800e68:	c3                   	ret
            return (char *)str;
  800e69:	48 89 f8             	mov    %rdi,%rax
}
  800e6c:	c3                   	ret

0000000000800e6d <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
  800e6d:	f3 0f 1e fa          	endbr64
  800e71:	48 89 f8             	mov    %rdi,%rax
    for (; *str && *str != ch; str++) /* nothing */
  800e74:	0f b6 17             	movzbl (%rdi),%edx
  800e77:	84 d2                	test   %dl,%dl
  800e79:	74 13                	je     800e8e <strfind+0x21>
  800e7b:	0f be d2             	movsbl %dl,%edx
  800e7e:	39 f2                	cmp    %esi,%edx
  800e80:	74 0b                	je     800e8d <strfind+0x20>
  800e82:	48 83 c0 01          	add    $0x1,%rax
  800e86:	0f b6 10             	movzbl (%rax),%edx
  800e89:	84 d2                	test   %dl,%dl
  800e8b:	75 ee                	jne    800e7b <strfind+0xe>
        ;
    return (char *)str;
}
  800e8d:	c3                   	ret
  800e8e:	c3                   	ret

0000000000800e8f <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  800e8f:	f3 0f 1e fa          	endbr64
  800e93:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  800e96:	48 89 f8             	mov    %rdi,%rax
  800e99:	48 f7 d8             	neg    %rax
  800e9c:	83 e0 07             	and    $0x7,%eax
  800e9f:	49 89 d1             	mov    %rdx,%r9
  800ea2:	49 29 c1             	sub    %rax,%r9
  800ea5:	78 36                	js     800edd <memset+0x4e>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  800ea7:	40 0f b6 c6          	movzbl %sil,%eax
  800eab:	48 b9 01 01 01 01 01 	movabs $0x101010101010101,%rcx
  800eb2:	01 01 01 
  800eb5:	48 0f af c1          	imul   %rcx,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  800eb9:	40 f6 c7 07          	test   $0x7,%dil
  800ebd:	75 38                	jne    800ef7 <memset+0x68>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  800ebf:	4c 89 c9             	mov    %r9,%rcx
  800ec2:	48 c1 f9 03          	sar    $0x3,%rcx
  800ec6:	74 0c                	je     800ed4 <memset+0x45>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  800ec8:	fc                   	cld
  800ec9:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  800ecc:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  800ed0:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  800ed4:	4d 85 c9             	test   %r9,%r9
  800ed7:	75 45                	jne    800f1e <memset+0x8f>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  800ed9:	4c 89 c0             	mov    %r8,%rax
  800edc:	c3                   	ret
        while (n-- > 0) *ptr++ = c;
  800edd:	48 85 d2             	test   %rdx,%rdx
  800ee0:	74 f7                	je     800ed9 <memset+0x4a>
  800ee2:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  800ee5:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  800ee8:	48 83 c0 01          	add    $0x1,%rax
  800eec:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  800ef0:	48 39 c2             	cmp    %rax,%rdx
  800ef3:	75 f3                	jne    800ee8 <memset+0x59>
  800ef5:	eb e2                	jmp    800ed9 <memset+0x4a>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  800ef7:	40 f6 c7 01          	test   $0x1,%dil
  800efb:	74 06                	je     800f03 <memset+0x74>
  800efd:	88 07                	mov    %al,(%rdi)
  800eff:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  800f03:	40 f6 c7 02          	test   $0x2,%dil
  800f07:	74 07                	je     800f10 <memset+0x81>
  800f09:	66 89 07             	mov    %ax,(%rdi)
  800f0c:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  800f10:	40 f6 c7 04          	test   $0x4,%dil
  800f14:	74 a9                	je     800ebf <memset+0x30>
  800f16:	89 07                	mov    %eax,(%rdi)
  800f18:	48 83 c7 04          	add    $0x4,%rdi
  800f1c:	eb a1                	jmp    800ebf <memset+0x30>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  800f1e:	41 f6 c1 04          	test   $0x4,%r9b
  800f22:	74 1b                	je     800f3f <memset+0xb0>
  800f24:	89 07                	mov    %eax,(%rdi)
  800f26:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800f2a:	41 f6 c1 02          	test   $0x2,%r9b
  800f2e:	74 07                	je     800f37 <memset+0xa8>
  800f30:	66 89 07             	mov    %ax,(%rdi)
  800f33:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  800f37:	41 f6 c1 01          	test   $0x1,%r9b
  800f3b:	74 9c                	je     800ed9 <memset+0x4a>
  800f3d:	eb 06                	jmp    800f45 <memset+0xb6>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800f3f:	41 f6 c1 02          	test   $0x2,%r9b
  800f43:	75 eb                	jne    800f30 <memset+0xa1>
        if (ni & 1) *ptr = k;
  800f45:	88 07                	mov    %al,(%rdi)
  800f47:	eb 90                	jmp    800ed9 <memset+0x4a>

0000000000800f49 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  800f49:	f3 0f 1e fa          	endbr64
  800f4d:	48 89 f8             	mov    %rdi,%rax
  800f50:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  800f53:	48 39 fe             	cmp    %rdi,%rsi
  800f56:	73 3b                	jae    800f93 <memmove+0x4a>
  800f58:	48 8d 14 16          	lea    (%rsi,%rdx,1),%rdx
  800f5c:	48 39 d7             	cmp    %rdx,%rdi
  800f5f:	73 32                	jae    800f93 <memmove+0x4a>
        s += n;
        d += n;
  800f61:	48 8d 3c 0f          	lea    (%rdi,%rcx,1),%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800f65:	48 89 d6             	mov    %rdx,%rsi
  800f68:	48 09 fe             	or     %rdi,%rsi
  800f6b:	48 09 ce             	or     %rcx,%rsi
  800f6e:	40 f6 c6 07          	test   $0x7,%sil
  800f72:	75 12                	jne    800f86 <memmove+0x3d>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  800f74:	48 83 ef 08          	sub    $0x8,%rdi
  800f78:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  800f7c:	48 c1 e9 03          	shr    $0x3,%rcx
  800f80:	fd                   	std
  800f81:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  800f84:	fc                   	cld
  800f85:	c3                   	ret
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  800f86:	48 83 ef 01          	sub    $0x1,%rdi
  800f8a:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  800f8e:	fd                   	std
  800f8f:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  800f91:	eb f1                	jmp    800f84 <memmove+0x3b>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  800f93:	48 89 f2             	mov    %rsi,%rdx
  800f96:	48 09 c2             	or     %rax,%rdx
  800f99:	48 09 ca             	or     %rcx,%rdx
  800f9c:	f6 c2 07             	test   $0x7,%dl
  800f9f:	75 0c                	jne    800fad <memmove+0x64>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  800fa1:	48 c1 e9 03          	shr    $0x3,%rcx
  800fa5:	48 89 c7             	mov    %rax,%rdi
  800fa8:	fc                   	cld
  800fa9:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  800fac:	c3                   	ret
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  800fad:	48 89 c7             	mov    %rax,%rdi
  800fb0:	fc                   	cld
  800fb1:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  800fb3:	c3                   	ret

0000000000800fb4 <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  800fb4:	f3 0f 1e fa          	endbr64
  800fb8:	55                   	push   %rbp
  800fb9:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  800fbc:	48 b8 49 0f 80 00 00 	movabs $0x800f49,%rax
  800fc3:	00 00 00 
  800fc6:	ff d0                	call   *%rax
}
  800fc8:	5d                   	pop    %rbp
  800fc9:	c3                   	ret

0000000000800fca <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  800fca:	f3 0f 1e fa          	endbr64
  800fce:	55                   	push   %rbp
  800fcf:	48 89 e5             	mov    %rsp,%rbp
  800fd2:	41 57                	push   %r15
  800fd4:	41 56                	push   %r14
  800fd6:	41 55                	push   %r13
  800fd8:	41 54                	push   %r12
  800fda:	53                   	push   %rbx
  800fdb:	48 83 ec 08          	sub    $0x8,%rsp
  800fdf:	49 89 fe             	mov    %rdi,%r14
  800fe2:	49 89 f7             	mov    %rsi,%r15
  800fe5:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  800fe8:	48 89 f7             	mov    %rsi,%rdi
  800feb:	48 b8 e9 0c 80 00 00 	movabs $0x800ce9,%rax
  800ff2:	00 00 00 
  800ff5:	ff d0                	call   *%rax
  800ff7:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  800ffa:	48 89 de             	mov    %rbx,%rsi
  800ffd:	4c 89 f7             	mov    %r14,%rdi
  801000:	48 b8 08 0d 80 00 00 	movabs $0x800d08,%rax
  801007:	00 00 00 
  80100a:	ff d0                	call   *%rax
  80100c:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  80100f:	48 39 c3             	cmp    %rax,%rbx
  801012:	74 36                	je     80104a <strlcat+0x80>
    if (srclen < maxlen - dstlen) {
  801014:	48 89 d8             	mov    %rbx,%rax
  801017:	4c 29 e8             	sub    %r13,%rax
  80101a:	49 39 c4             	cmp    %rax,%r12
  80101d:	73 31                	jae    801050 <strlcat+0x86>
        memcpy(dst + dstlen, src, srclen + 1);
  80101f:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  801024:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  801028:	4c 89 fe             	mov    %r15,%rsi
  80102b:	48 b8 b4 0f 80 00 00 	movabs $0x800fb4,%rax
  801032:	00 00 00 
  801035:	ff d0                	call   *%rax
    return dstlen + srclen;
  801037:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  80103b:	48 83 c4 08          	add    $0x8,%rsp
  80103f:	5b                   	pop    %rbx
  801040:	41 5c                	pop    %r12
  801042:	41 5d                	pop    %r13
  801044:	41 5e                	pop    %r14
  801046:	41 5f                	pop    %r15
  801048:	5d                   	pop    %rbp
  801049:	c3                   	ret
    if (dstlen == maxlen) return maxlen + srclen;
  80104a:	49 8d 04 04          	lea    (%r12,%rax,1),%rax
  80104e:	eb eb                	jmp    80103b <strlcat+0x71>
        memcpy(dst + dstlen, src, maxlen - 1);
  801050:	48 83 eb 01          	sub    $0x1,%rbx
  801054:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  801058:	48 89 da             	mov    %rbx,%rdx
  80105b:	4c 89 fe             	mov    %r15,%rsi
  80105e:	48 b8 b4 0f 80 00 00 	movabs $0x800fb4,%rax
  801065:	00 00 00 
  801068:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  80106a:	49 01 de             	add    %rbx,%r14
  80106d:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  801072:	eb c3                	jmp    801037 <strlcat+0x6d>

0000000000801074 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  801074:	f3 0f 1e fa          	endbr64
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  801078:	48 85 d2             	test   %rdx,%rdx
  80107b:	74 2d                	je     8010aa <memcmp+0x36>
  80107d:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  801082:	0f b6 0c 07          	movzbl (%rdi,%rax,1),%ecx
  801086:	44 0f b6 04 06       	movzbl (%rsi,%rax,1),%r8d
  80108b:	44 38 c1             	cmp    %r8b,%cl
  80108e:	75 0f                	jne    80109f <memcmp+0x2b>
    while (n-- > 0) {
  801090:	48 83 c0 01          	add    $0x1,%rax
  801094:	48 39 c2             	cmp    %rax,%rdx
  801097:	75 e9                	jne    801082 <memcmp+0xe>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  801099:	b8 00 00 00 00       	mov    $0x0,%eax
  80109e:	c3                   	ret
            return (int)*s1 - (int)*s2;
  80109f:	0f b6 c1             	movzbl %cl,%eax
  8010a2:	45 0f b6 c0          	movzbl %r8b,%r8d
  8010a6:	44 29 c0             	sub    %r8d,%eax
  8010a9:	c3                   	ret
    return 0;
  8010aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010af:	c3                   	ret

00000000008010b0 <memfind>:

void *
memfind(const void *src, int c, size_t n) {
  8010b0:	f3 0f 1e fa          	endbr64
    const void *end = (const char *)src + n;
  8010b4:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  8010b8:	48 39 c7             	cmp    %rax,%rdi
  8010bb:	73 0f                	jae    8010cc <memfind+0x1c>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  8010bd:	40 38 37             	cmp    %sil,(%rdi)
  8010c0:	74 0e                	je     8010d0 <memfind+0x20>
    for (; src < end; src++) {
  8010c2:	48 83 c7 01          	add    $0x1,%rdi
  8010c6:	48 39 f8             	cmp    %rdi,%rax
  8010c9:	75 f2                	jne    8010bd <memfind+0xd>
  8010cb:	c3                   	ret
  8010cc:	48 89 f8             	mov    %rdi,%rax
  8010cf:	c3                   	ret
  8010d0:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  8010d3:	c3                   	ret

00000000008010d4 <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  8010d4:	f3 0f 1e fa          	endbr64
  8010d8:	49 89 f2             	mov    %rsi,%r10
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  8010db:	0f b6 37             	movzbl (%rdi),%esi
  8010de:	40 80 fe 20          	cmp    $0x20,%sil
  8010e2:	74 06                	je     8010ea <strtol+0x16>
  8010e4:	40 80 fe 09          	cmp    $0x9,%sil
  8010e8:	75 13                	jne    8010fd <strtol+0x29>
  8010ea:	48 83 c7 01          	add    $0x1,%rdi
  8010ee:	0f b6 37             	movzbl (%rdi),%esi
  8010f1:	40 80 fe 20          	cmp    $0x20,%sil
  8010f5:	74 f3                	je     8010ea <strtol+0x16>
  8010f7:	40 80 fe 09          	cmp    $0x9,%sil
  8010fb:	74 ed                	je     8010ea <strtol+0x16>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  8010fd:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  801100:	83 e0 fd             	and    $0xfffffffd,%eax
  801103:	3c 01                	cmp    $0x1,%al
  801105:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  801109:	f7 c2 ef ff ff ff    	test   $0xffffffef,%edx
  80110f:	75 0f                	jne    801120 <strtol+0x4c>
  801111:	80 3f 30             	cmpb   $0x30,(%rdi)
  801114:	74 14                	je     80112a <strtol+0x56>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  801116:	85 d2                	test   %edx,%edx
  801118:	b8 0a 00 00 00       	mov    $0xa,%eax
  80111d:	0f 44 d0             	cmove  %eax,%edx
    }

    /* Digits */
    long val = 0;
  801120:	b8 00 00 00 00       	mov    $0x0,%eax
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  801125:	4c 63 ca             	movslq %edx,%r9
  801128:	eb 36                	jmp    801160 <strtol+0x8c>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  80112a:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  80112e:	74 0f                	je     80113f <strtol+0x6b>
    } else if (!base && s[0] == '0') {
  801130:	85 d2                	test   %edx,%edx
  801132:	75 ec                	jne    801120 <strtol+0x4c>
        s++;
  801134:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  801138:	ba 08 00 00 00       	mov    $0x8,%edx
        s++;
  80113d:	eb e1                	jmp    801120 <strtol+0x4c>
        s += 2;
  80113f:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  801143:	ba 10 00 00 00       	mov    $0x10,%edx
        s += 2;
  801148:	eb d6                	jmp    801120 <strtol+0x4c>
            dig -= '0';
  80114a:	83 e9 30             	sub    $0x30,%ecx
        if (dig >= base) break;
  80114d:	44 0f b6 c1          	movzbl %cl,%r8d
  801151:	41 39 d0             	cmp    %edx,%r8d
  801154:	7d 21                	jge    801177 <strtol+0xa3>
        val = val * base + dig;
  801156:	49 0f af c1          	imul   %r9,%rax
  80115a:	0f b6 c9             	movzbl %cl,%ecx
  80115d:	48 01 c8             	add    %rcx,%rax
        uint8_t dig = *s++;
  801160:	48 83 c7 01          	add    $0x1,%rdi
  801164:	0f b6 4f ff          	movzbl -0x1(%rdi),%ecx
        if (dig - '0' < 10)
  801168:	80 f9 39             	cmp    $0x39,%cl
  80116b:	76 dd                	jbe    80114a <strtol+0x76>
        else if (dig - 'a' < 27)
  80116d:	80 f9 7b             	cmp    $0x7b,%cl
  801170:	77 05                	ja     801177 <strtol+0xa3>
            dig -= 'a' - 10;
  801172:	83 e9 57             	sub    $0x57,%ecx
  801175:	eb d6                	jmp    80114d <strtol+0x79>
    }

    if (endptr) *endptr = (char *)s;
  801177:	4d 85 d2             	test   %r10,%r10
  80117a:	74 03                	je     80117f <strtol+0xab>
  80117c:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  80117f:	48 89 c2             	mov    %rax,%rdx
  801182:	48 f7 da             	neg    %rdx
  801185:	40 80 fe 2d          	cmp    $0x2d,%sil
  801189:	48 0f 44 c2          	cmove  %rdx,%rax
}
  80118d:	c3                   	ret

000000000080118e <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  80118e:	f3 0f 1e fa          	endbr64
  801192:	55                   	push   %rbp
  801193:	48 89 e5             	mov    %rsp,%rbp
  801196:	53                   	push   %rbx
  801197:	48 89 fa             	mov    %rdi,%rdx
  80119a:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80119d:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8011a2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011a7:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8011ac:	be 00 00 00 00       	mov    $0x0,%esi
  8011b1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8011b7:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  8011b9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011bd:	c9                   	leave
  8011be:	c3                   	ret

00000000008011bf <sys_cgetc>:

int
sys_cgetc(void) {
  8011bf:	f3 0f 1e fa          	endbr64
  8011c3:	55                   	push   %rbp
  8011c4:	48 89 e5             	mov    %rsp,%rbp
  8011c7:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8011c8:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8011cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8011d2:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8011d7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011dc:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8011e1:	be 00 00 00 00       	mov    $0x0,%esi
  8011e6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8011ec:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  8011ee:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011f2:	c9                   	leave
  8011f3:	c3                   	ret

00000000008011f4 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  8011f4:	f3 0f 1e fa          	endbr64
  8011f8:	55                   	push   %rbp
  8011f9:	48 89 e5             	mov    %rsp,%rbp
  8011fc:	53                   	push   %rbx
  8011fd:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  801201:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801204:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801209:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80120e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801213:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801218:	be 00 00 00 00       	mov    $0x0,%esi
  80121d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801223:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801225:	48 85 c0             	test   %rax,%rax
  801228:	7f 06                	jg     801230 <sys_env_destroy+0x3c>
}
  80122a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80122e:	c9                   	leave
  80122f:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801230:	49 89 c0             	mov    %rax,%r8
  801233:	b9 03 00 00 00       	mov    $0x3,%ecx
  801238:	48 ba 88 43 80 00 00 	movabs $0x804388,%rdx
  80123f:	00 00 00 
  801242:	be 26 00 00 00       	mov    $0x26,%esi
  801247:	48 bf ad 41 80 00 00 	movabs $0x8041ad,%rdi
  80124e:	00 00 00 
  801251:	b8 00 00 00 00       	mov    $0x0,%eax
  801256:	49 b9 73 2f 80 00 00 	movabs $0x802f73,%r9
  80125d:	00 00 00 
  801260:	41 ff d1             	call   *%r9

0000000000801263 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  801263:	f3 0f 1e fa          	endbr64
  801267:	55                   	push   %rbp
  801268:	48 89 e5             	mov    %rsp,%rbp
  80126b:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80126c:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801271:	ba 00 00 00 00       	mov    $0x0,%edx
  801276:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80127b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801280:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801285:	be 00 00 00 00       	mov    $0x0,%esi
  80128a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801290:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  801292:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801296:	c9                   	leave
  801297:	c3                   	ret

0000000000801298 <sys_yield>:

void
sys_yield(void) {
  801298:	f3 0f 1e fa          	endbr64
  80129c:	55                   	push   %rbp
  80129d:	48 89 e5             	mov    %rsp,%rbp
  8012a0:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8012a1:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8012a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8012ab:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8012b0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012b5:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012ba:	be 00 00 00 00       	mov    $0x0,%esi
  8012bf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8012c5:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  8012c7:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012cb:	c9                   	leave
  8012cc:	c3                   	ret

00000000008012cd <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  8012cd:	f3 0f 1e fa          	endbr64
  8012d1:	55                   	push   %rbp
  8012d2:	48 89 e5             	mov    %rsp,%rbp
  8012d5:	53                   	push   %rbx
  8012d6:	48 89 fa             	mov    %rdi,%rdx
  8012d9:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8012dc:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8012e1:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  8012e8:	00 00 00 
  8012eb:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012f0:	be 00 00 00 00       	mov    $0x0,%esi
  8012f5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8012fb:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  8012fd:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801301:	c9                   	leave
  801302:	c3                   	ret

0000000000801303 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  801303:	f3 0f 1e fa          	endbr64
  801307:	55                   	push   %rbp
  801308:	48 89 e5             	mov    %rsp,%rbp
  80130b:	53                   	push   %rbx
  80130c:	49 89 f8             	mov    %rdi,%r8
  80130f:	48 89 d3             	mov    %rdx,%rbx
  801312:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  801315:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80131a:	4c 89 c2             	mov    %r8,%rdx
  80131d:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801320:	be 00 00 00 00       	mov    $0x0,%esi
  801325:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80132b:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  80132d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801331:	c9                   	leave
  801332:	c3                   	ret

0000000000801333 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  801333:	f3 0f 1e fa          	endbr64
  801337:	55                   	push   %rbp
  801338:	48 89 e5             	mov    %rsp,%rbp
  80133b:	53                   	push   %rbx
  80133c:	48 83 ec 08          	sub    $0x8,%rsp
  801340:	89 f8                	mov    %edi,%eax
  801342:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  801345:	48 63 f9             	movslq %ecx,%rdi
  801348:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80134b:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801350:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801353:	be 00 00 00 00       	mov    $0x0,%esi
  801358:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80135e:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801360:	48 85 c0             	test   %rax,%rax
  801363:	7f 06                	jg     80136b <sys_alloc_region+0x38>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  801365:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801369:	c9                   	leave
  80136a:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80136b:	49 89 c0             	mov    %rax,%r8
  80136e:	b9 04 00 00 00       	mov    $0x4,%ecx
  801373:	48 ba 88 43 80 00 00 	movabs $0x804388,%rdx
  80137a:	00 00 00 
  80137d:	be 26 00 00 00       	mov    $0x26,%esi
  801382:	48 bf ad 41 80 00 00 	movabs $0x8041ad,%rdi
  801389:	00 00 00 
  80138c:	b8 00 00 00 00       	mov    $0x0,%eax
  801391:	49 b9 73 2f 80 00 00 	movabs $0x802f73,%r9
  801398:	00 00 00 
  80139b:	41 ff d1             	call   *%r9

000000000080139e <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  80139e:	f3 0f 1e fa          	endbr64
  8013a2:	55                   	push   %rbp
  8013a3:	48 89 e5             	mov    %rsp,%rbp
  8013a6:	53                   	push   %rbx
  8013a7:	48 83 ec 08          	sub    $0x8,%rsp
  8013ab:	89 f8                	mov    %edi,%eax
  8013ad:	49 89 f2             	mov    %rsi,%r10
  8013b0:	48 89 cf             	mov    %rcx,%rdi
  8013b3:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  8013b6:	48 63 da             	movslq %edx,%rbx
  8013b9:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8013bc:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8013c1:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013c4:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  8013c7:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8013c9:	48 85 c0             	test   %rax,%rax
  8013cc:	7f 06                	jg     8013d4 <sys_map_region+0x36>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  8013ce:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013d2:	c9                   	leave
  8013d3:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8013d4:	49 89 c0             	mov    %rax,%r8
  8013d7:	b9 05 00 00 00       	mov    $0x5,%ecx
  8013dc:	48 ba 88 43 80 00 00 	movabs $0x804388,%rdx
  8013e3:	00 00 00 
  8013e6:	be 26 00 00 00       	mov    $0x26,%esi
  8013eb:	48 bf ad 41 80 00 00 	movabs $0x8041ad,%rdi
  8013f2:	00 00 00 
  8013f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8013fa:	49 b9 73 2f 80 00 00 	movabs $0x802f73,%r9
  801401:	00 00 00 
  801404:	41 ff d1             	call   *%r9

0000000000801407 <sys_map_physical_region>:

int
sys_map_physical_region(uintptr_t pa, envid_t dstenv, void *dstva, size_t size, int perm) {
  801407:	f3 0f 1e fa          	endbr64
  80140b:	55                   	push   %rbp
  80140c:	48 89 e5             	mov    %rsp,%rbp
  80140f:	53                   	push   %rbx
  801410:	48 83 ec 08          	sub    $0x8,%rsp
  801414:	49 89 f9             	mov    %rdi,%r9
  801417:	89 f0                	mov    %esi,%eax
  801419:	48 89 d3             	mov    %rdx,%rbx
  80141c:	48 89 cf             	mov    %rcx,%rdi
    int res = syscall(SYS_map_physical_region, 1, pa, dstenv, (uintptr_t)dstva, size, perm, 0);
  80141f:	49 63 f0             	movslq %r8d,%rsi
  801422:	48 63 c8             	movslq %eax,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801425:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80142a:	4c 89 ca             	mov    %r9,%rdx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80142d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801433:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801435:	48 85 c0             	test   %rax,%rax
  801438:	7f 06                	jg     801440 <sys_map_physical_region+0x39>
#ifdef SANITIZE_USER_SHADOW_BASE
    platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  80143a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80143e:	c9                   	leave
  80143f:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801440:	49 89 c0             	mov    %rax,%r8
  801443:	b9 06 00 00 00       	mov    $0x6,%ecx
  801448:	48 ba 88 43 80 00 00 	movabs $0x804388,%rdx
  80144f:	00 00 00 
  801452:	be 26 00 00 00       	mov    $0x26,%esi
  801457:	48 bf ad 41 80 00 00 	movabs $0x8041ad,%rdi
  80145e:	00 00 00 
  801461:	b8 00 00 00 00       	mov    $0x0,%eax
  801466:	49 b9 73 2f 80 00 00 	movabs $0x802f73,%r9
  80146d:	00 00 00 
  801470:	41 ff d1             	call   *%r9

0000000000801473 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  801473:	f3 0f 1e fa          	endbr64
  801477:	55                   	push   %rbp
  801478:	48 89 e5             	mov    %rsp,%rbp
  80147b:	53                   	push   %rbx
  80147c:	48 83 ec 08          	sub    $0x8,%rsp
  801480:	48 89 f1             	mov    %rsi,%rcx
  801483:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  801486:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801489:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80148e:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801493:	be 00 00 00 00       	mov    $0x0,%esi
  801498:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80149e:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8014a0:	48 85 c0             	test   %rax,%rax
  8014a3:	7f 06                	jg     8014ab <sys_unmap_region+0x38>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  8014a5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014a9:	c9                   	leave
  8014aa:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8014ab:	49 89 c0             	mov    %rax,%r8
  8014ae:	b9 07 00 00 00       	mov    $0x7,%ecx
  8014b3:	48 ba 88 43 80 00 00 	movabs $0x804388,%rdx
  8014ba:	00 00 00 
  8014bd:	be 26 00 00 00       	mov    $0x26,%esi
  8014c2:	48 bf ad 41 80 00 00 	movabs $0x8041ad,%rdi
  8014c9:	00 00 00 
  8014cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d1:	49 b9 73 2f 80 00 00 	movabs $0x802f73,%r9
  8014d8:	00 00 00 
  8014db:	41 ff d1             	call   *%r9

00000000008014de <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  8014de:	f3 0f 1e fa          	endbr64
  8014e2:	55                   	push   %rbp
  8014e3:	48 89 e5             	mov    %rsp,%rbp
  8014e6:	53                   	push   %rbx
  8014e7:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  8014eb:	48 63 ce             	movslq %esi,%rcx
  8014ee:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8014f1:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8014f6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014fb:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801500:	be 00 00 00 00       	mov    $0x0,%esi
  801505:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80150b:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80150d:	48 85 c0             	test   %rax,%rax
  801510:	7f 06                	jg     801518 <sys_env_set_status+0x3a>
}
  801512:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801516:	c9                   	leave
  801517:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801518:	49 89 c0             	mov    %rax,%r8
  80151b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801520:	48 ba 88 43 80 00 00 	movabs $0x804388,%rdx
  801527:	00 00 00 
  80152a:	be 26 00 00 00       	mov    $0x26,%esi
  80152f:	48 bf ad 41 80 00 00 	movabs $0x8041ad,%rdi
  801536:	00 00 00 
  801539:	b8 00 00 00 00       	mov    $0x0,%eax
  80153e:	49 b9 73 2f 80 00 00 	movabs $0x802f73,%r9
  801545:	00 00 00 
  801548:	41 ff d1             	call   *%r9

000000000080154b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  80154b:	f3 0f 1e fa          	endbr64
  80154f:	55                   	push   %rbp
  801550:	48 89 e5             	mov    %rsp,%rbp
  801553:	53                   	push   %rbx
  801554:	48 83 ec 08          	sub    $0x8,%rsp
  801558:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  80155b:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80155e:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801563:	bb 00 00 00 00       	mov    $0x0,%ebx
  801568:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80156d:	be 00 00 00 00       	mov    $0x0,%esi
  801572:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801578:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80157a:	48 85 c0             	test   %rax,%rax
  80157d:	7f 06                	jg     801585 <sys_env_set_trapframe+0x3a>
}
  80157f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801583:	c9                   	leave
  801584:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801585:	49 89 c0             	mov    %rax,%r8
  801588:	b9 0b 00 00 00       	mov    $0xb,%ecx
  80158d:	48 ba 88 43 80 00 00 	movabs $0x804388,%rdx
  801594:	00 00 00 
  801597:	be 26 00 00 00       	mov    $0x26,%esi
  80159c:	48 bf ad 41 80 00 00 	movabs $0x8041ad,%rdi
  8015a3:	00 00 00 
  8015a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ab:	49 b9 73 2f 80 00 00 	movabs $0x802f73,%r9
  8015b2:	00 00 00 
  8015b5:	41 ff d1             	call   *%r9

00000000008015b8 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  8015b8:	f3 0f 1e fa          	endbr64
  8015bc:	55                   	push   %rbp
  8015bd:	48 89 e5             	mov    %rsp,%rbp
  8015c0:	53                   	push   %rbx
  8015c1:	48 83 ec 08          	sub    $0x8,%rsp
  8015c5:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  8015c8:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8015cb:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8015d0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015d5:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8015da:	be 00 00 00 00       	mov    $0x0,%esi
  8015df:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8015e5:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8015e7:	48 85 c0             	test   %rax,%rax
  8015ea:	7f 06                	jg     8015f2 <sys_env_set_pgfault_upcall+0x3a>
}
  8015ec:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8015f0:	c9                   	leave
  8015f1:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8015f2:	49 89 c0             	mov    %rax,%r8
  8015f5:	b9 0c 00 00 00       	mov    $0xc,%ecx
  8015fa:	48 ba 88 43 80 00 00 	movabs $0x804388,%rdx
  801601:	00 00 00 
  801604:	be 26 00 00 00       	mov    $0x26,%esi
  801609:	48 bf ad 41 80 00 00 	movabs $0x8041ad,%rdi
  801610:	00 00 00 
  801613:	b8 00 00 00 00       	mov    $0x0,%eax
  801618:	49 b9 73 2f 80 00 00 	movabs $0x802f73,%r9
  80161f:	00 00 00 
  801622:	41 ff d1             	call   *%r9

0000000000801625 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  801625:	f3 0f 1e fa          	endbr64
  801629:	55                   	push   %rbp
  80162a:	48 89 e5             	mov    %rsp,%rbp
  80162d:	53                   	push   %rbx
  80162e:	89 f8                	mov    %edi,%eax
  801630:	49 89 f1             	mov    %rsi,%r9
  801633:	48 89 d3             	mov    %rdx,%rbx
  801636:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  801639:	49 63 f0             	movslq %r8d,%rsi
  80163c:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80163f:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801644:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801647:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80164d:	cd 30                	int    $0x30
}
  80164f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801653:	c9                   	leave
  801654:	c3                   	ret

0000000000801655 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  801655:	f3 0f 1e fa          	endbr64
  801659:	55                   	push   %rbp
  80165a:	48 89 e5             	mov    %rsp,%rbp
  80165d:	53                   	push   %rbx
  80165e:	48 83 ec 08          	sub    $0x8,%rsp
  801662:	48 89 fa             	mov    %rdi,%rdx
  801665:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801668:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80166d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801672:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801677:	be 00 00 00 00       	mov    $0x0,%esi
  80167c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801682:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801684:	48 85 c0             	test   %rax,%rax
  801687:	7f 06                	jg     80168f <sys_ipc_recv+0x3a>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  801689:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80168d:	c9                   	leave
  80168e:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80168f:	49 89 c0             	mov    %rax,%r8
  801692:	b9 0f 00 00 00       	mov    $0xf,%ecx
  801697:	48 ba 88 43 80 00 00 	movabs $0x804388,%rdx
  80169e:	00 00 00 
  8016a1:	be 26 00 00 00       	mov    $0x26,%esi
  8016a6:	48 bf ad 41 80 00 00 	movabs $0x8041ad,%rdi
  8016ad:	00 00 00 
  8016b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b5:	49 b9 73 2f 80 00 00 	movabs $0x802f73,%r9
  8016bc:	00 00 00 
  8016bf:	41 ff d1             	call   *%r9

00000000008016c2 <sys_gettime>:

int
sys_gettime(void) {
  8016c2:	f3 0f 1e fa          	endbr64
  8016c6:	55                   	push   %rbp
  8016c7:	48 89 e5             	mov    %rsp,%rbp
  8016ca:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8016cb:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8016d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8016d5:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8016da:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016df:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8016e4:	be 00 00 00 00       	mov    $0x0,%esi
  8016e9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8016ef:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  8016f1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8016f5:	c9                   	leave
  8016f6:	c3                   	ret

00000000008016f7 <fork>:
 *   Use sys_map_region, it can perform address space copying in one call
 *   Don't forget to set page fault handler in the child (using sys_env_set_pgfault_upcall()).
 *   Remember to fix "thisenv" in the child process.
 */
envid_t
fork(void) {
  8016f7:	f3 0f 1e fa          	endbr64
  8016fb:	55                   	push   %rbp
  8016fc:	48 89 e5             	mov    %rsp,%rbp
  8016ff:	41 56                	push   %r14
  801701:	41 55                	push   %r13
  801703:	41 54                	push   %r12
  801705:	53                   	push   %rbx
    // LAB 9: Your code here.
    bool has_pgfault_upcall = thisenv->env_pgfault_upcall;
  801706:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  80170d:	00 00 00 
  801710:	4c 8b b0 00 01 00 00 	mov    0x100(%rax),%r14

/* This must be inlined. Exercise for reader: why? */
static inline envid_t __attribute__((always_inline))
sys_exofork(void) {
    envid_t ret;
    asm volatile("int %2"
  801717:	b8 09 00 00 00       	mov    $0x9,%eax
  80171c:	cd 30                	int    $0x30
  80171e:	41 89 c4             	mov    %eax,%r12d

    envid_t envid = sys_exofork();
    if (envid < 0) {
  801721:	85 c0                	test   %eax,%eax
  801723:	78 7f                	js     8017a4 <fork+0xad>
  801725:	89 c3                	mov    %eax,%ebx
        return envid;
    }
    if (envid == 0) {
  801727:	0f 84 83 00 00 00    	je     8017b0 <fork+0xb9>
        thisenv = &envs[ENVX(sys_getenvid())];
        return 0;
    }
    int res = sys_map_region(CURENVID, NULL, envid, NULL, MAX_USER_ADDRESS, PROT_ALL | PROT_LAZY | PROT_COMBINE);
  80172d:	41 b9 ff 0f 00 00    	mov    $0xfff,%r9d
  801733:	49 b8 00 00 00 00 80 	movabs $0x8000000000,%r8
  80173a:	00 00 00 
  80173d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801742:	89 c2                	mov    %eax,%edx
  801744:	be 00 00 00 00       	mov    $0x0,%esi
  801749:	bf 00 00 00 00       	mov    $0x0,%edi
  80174e:	48 b8 9e 13 80 00 00 	movabs $0x80139e,%rax
  801755:	00 00 00 
  801758:	ff d0                	call   *%rax
  80175a:	41 89 c5             	mov    %eax,%r13d
    if (res < 0) {
  80175d:	85 c0                	test   %eax,%eax
  80175f:	0f 88 81 00 00 00    	js     8017e6 <fork+0xef>
        sys_env_destroy(envid);
        return res;
    }
    if (has_pgfault_upcall) {
  801765:	4d 85 f6             	test   %r14,%r14
  801768:	74 20                	je     80178a <fork+0x93>
        res = sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  80176a:	48 be 1a 30 80 00 00 	movabs $0x80301a,%rsi
  801771:	00 00 00 
  801774:	44 89 e7             	mov    %r12d,%edi
  801777:	48 b8 b8 15 80 00 00 	movabs $0x8015b8,%rax
  80177e:	00 00 00 
  801781:	ff d0                	call   *%rax
  801783:	41 89 c5             	mov    %eax,%r13d
        if (res < 0) {
  801786:	85 c0                	test   %eax,%eax
  801788:	78 70                	js     8017fa <fork+0x103>
            sys_env_destroy(envid);
            return res;
        }
    }
    res = sys_env_set_status(envid, ENV_RUNNABLE);
  80178a:	be 02 00 00 00       	mov    $0x2,%esi
  80178f:	89 df                	mov    %ebx,%edi
  801791:	48 b8 de 14 80 00 00 	movabs $0x8014de,%rax
  801798:	00 00 00 
  80179b:	ff d0                	call   *%rax
  80179d:	41 89 c5             	mov    %eax,%r13d
    if (res < 0) {
  8017a0:	85 c0                	test   %eax,%eax
  8017a2:	78 6a                	js     80180e <fork+0x117>
        sys_env_destroy(envid);
        return res;
    }
    return envid;
}
  8017a4:	44 89 e0             	mov    %r12d,%eax
  8017a7:	5b                   	pop    %rbx
  8017a8:	41 5c                	pop    %r12
  8017aa:	41 5d                	pop    %r13
  8017ac:	41 5e                	pop    %r14
  8017ae:	5d                   	pop    %rbp
  8017af:	c3                   	ret
        thisenv = &envs[ENVX(sys_getenvid())];
  8017b0:	48 b8 63 12 80 00 00 	movabs $0x801263,%rax
  8017b7:	00 00 00 
  8017ba:	ff d0                	call   *%rax
  8017bc:	25 ff 03 00 00       	and    $0x3ff,%eax
  8017c1:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8017c5:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8017c9:	48 c1 e0 04          	shl    $0x4,%rax
  8017cd:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  8017d4:	00 00 00 
  8017d7:	48 01 d0             	add    %rdx,%rax
  8017da:	48 a3 00 60 80 00 00 	movabs %rax,0x806000
  8017e1:	00 00 00 
        return 0;
  8017e4:	eb be                	jmp    8017a4 <fork+0xad>
        sys_env_destroy(envid);
  8017e6:	44 89 e7             	mov    %r12d,%edi
  8017e9:	48 b8 f4 11 80 00 00 	movabs $0x8011f4,%rax
  8017f0:	00 00 00 
  8017f3:	ff d0                	call   *%rax
        return res;
  8017f5:	45 89 ec             	mov    %r13d,%r12d
  8017f8:	eb aa                	jmp    8017a4 <fork+0xad>
            sys_env_destroy(envid);
  8017fa:	44 89 e7             	mov    %r12d,%edi
  8017fd:	48 b8 f4 11 80 00 00 	movabs $0x8011f4,%rax
  801804:	00 00 00 
  801807:	ff d0                	call   *%rax
            return res;
  801809:	45 89 ec             	mov    %r13d,%r12d
  80180c:	eb 96                	jmp    8017a4 <fork+0xad>
        sys_env_destroy(envid);
  80180e:	89 df                	mov    %ebx,%edi
  801810:	48 b8 f4 11 80 00 00 	movabs $0x8011f4,%rax
  801817:	00 00 00 
  80181a:	ff d0                	call   *%rax
        return res;
  80181c:	45 89 ec             	mov    %r13d,%r12d
  80181f:	eb 83                	jmp    8017a4 <fork+0xad>

0000000000801821 <sfork>:

envid_t
sfork() {
  801821:	f3 0f 1e fa          	endbr64
  801825:	55                   	push   %rbp
  801826:	48 89 e5             	mov    %rsp,%rbp
    panic("sfork() is not implemented");
  801829:	48 ba bb 41 80 00 00 	movabs $0x8041bb,%rdx
  801830:	00 00 00 
  801833:	be 37 00 00 00       	mov    $0x37,%esi
  801838:	48 bf d6 41 80 00 00 	movabs $0x8041d6,%rdi
  80183f:	00 00 00 
  801842:	b8 00 00 00 00       	mov    $0x0,%eax
  801847:	48 b9 73 2f 80 00 00 	movabs $0x802f73,%rcx
  80184e:	00 00 00 
  801851:	ff d1                	call   *%rcx

0000000000801853 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  801853:	f3 0f 1e fa          	endbr64
  801857:	55                   	push   %rbp
  801858:	48 89 e5             	mov    %rsp,%rbp
  80185b:	41 54                	push   %r12
  80185d:	53                   	push   %rbx
  80185e:	48 89 fb             	mov    %rdi,%rbx
  801861:	48 89 f7             	mov    %rsi,%rdi
  801864:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  801867:	48 85 f6             	test   %rsi,%rsi
  80186a:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  801871:	00 00 00 
  801874:	48 0f 44 f8          	cmove  %rax,%rdi
    }
    int res = sys_ipc_recv(pg, PAGE_SIZE);
  801878:	be 00 10 00 00       	mov    $0x1000,%esi
  80187d:	48 b8 55 16 80 00 00 	movabs $0x801655,%rax
  801884:	00 00 00 
  801887:	ff d0                	call   *%rax
    if (res < 0) {
  801889:	85 c0                	test   %eax,%eax
  80188b:	78 45                	js     8018d2 <ipc_recv+0x7f>
        if (perm_store != NULL) {
            *perm_store = 0;
        }
        return res;
    } else {
        if (from_env_store != NULL) {
  80188d:	48 85 db             	test   %rbx,%rbx
  801890:	74 12                	je     8018a4 <ipc_recv+0x51>
            *from_env_store = thisenv->env_ipc_from;
  801892:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801899:	00 00 00 
  80189c:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  8018a2:	89 03                	mov    %eax,(%rbx)
        }
        if (perm_store != NULL) {
  8018a4:	4d 85 e4             	test   %r12,%r12
  8018a7:	74 14                	je     8018bd <ipc_recv+0x6a>
            *perm_store = thisenv->env_ipc_perm;
  8018a9:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  8018b0:	00 00 00 
  8018b3:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  8018b9:	41 89 04 24          	mov    %eax,(%r12)
        }
        return thisenv->env_ipc_value;
  8018bd:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  8018c4:	00 00 00 
  8018c7:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
    }
    return -1;
}
  8018cd:	5b                   	pop    %rbx
  8018ce:	41 5c                	pop    %r12
  8018d0:	5d                   	pop    %rbp
  8018d1:	c3                   	ret
        if (from_env_store != NULL) {
  8018d2:	48 85 db             	test   %rbx,%rbx
  8018d5:	74 06                	je     8018dd <ipc_recv+0x8a>
            *from_env_store = 0;
  8018d7:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store != NULL) {
  8018dd:	4d 85 e4             	test   %r12,%r12
  8018e0:	74 eb                	je     8018cd <ipc_recv+0x7a>
            *perm_store = 0;
  8018e2:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  8018e9:	00 
  8018ea:	eb e1                	jmp    8018cd <ipc_recv+0x7a>

00000000008018ec <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  8018ec:	f3 0f 1e fa          	endbr64
  8018f0:	55                   	push   %rbp
  8018f1:	48 89 e5             	mov    %rsp,%rbp
  8018f4:	41 57                	push   %r15
  8018f6:	41 56                	push   %r14
  8018f8:	41 55                	push   %r13
  8018fa:	41 54                	push   %r12
  8018fc:	53                   	push   %rbx
  8018fd:	48 83 ec 18          	sub    $0x18,%rsp
  801901:	89 7d c4             	mov    %edi,-0x3c(%rbp)
  801904:	48 89 d3             	mov    %rdx,%rbx
  801907:	49 89 cc             	mov    %rcx,%r12
  80190a:	45 89 c5             	mov    %r8d,%r13d
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  80190d:	48 85 d2             	test   %rdx,%rdx
  801910:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  801917:	00 00 00 
  80191a:	48 0f 44 d8          	cmove  %rax,%rbx
    }
    int res = sys_ipc_try_send(to_env, val, pg, size, perm);
  80191e:	89 f0                	mov    %esi,%eax
  801920:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  801924:	48 89 da             	mov    %rbx,%rdx
  801927:	48 89 c6             	mov    %rax,%rsi
  80192a:	48 b8 25 16 80 00 00 	movabs $0x801625,%rax
  801931:	00 00 00 
  801934:	ff d0                	call   *%rax
    while (res < 0) {
  801936:	85 c0                	test   %eax,%eax
  801938:	79 65                	jns    80199f <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  80193a:	83 f8 f5             	cmp    $0xfffffff5,%eax
  80193d:	75 33                	jne    801972 <ipc_send+0x86>
            panic("Error: %i\n", res);
        }
        sys_yield();
  80193f:	49 bf 98 12 80 00 00 	movabs $0x801298,%r15
  801946:	00 00 00 
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  801949:	49 be 25 16 80 00 00 	movabs $0x801625,%r14
  801950:	00 00 00 
        sys_yield();
  801953:	41 ff d7             	call   *%r15
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  801956:	45 89 e8             	mov    %r13d,%r8d
  801959:	4c 89 e1             	mov    %r12,%rcx
  80195c:	48 89 da             	mov    %rbx,%rdx
  80195f:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  801963:	8b 7d c4             	mov    -0x3c(%rbp),%edi
  801966:	41 ff d6             	call   *%r14
    while (res < 0) {
  801969:	85 c0                	test   %eax,%eax
  80196b:	79 32                	jns    80199f <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  80196d:	83 f8 f5             	cmp    $0xfffffff5,%eax
  801970:	74 e1                	je     801953 <ipc_send+0x67>
            panic("Error: %i\n", res);
  801972:	89 c1                	mov    %eax,%ecx
  801974:	48 ba e1 41 80 00 00 	movabs $0x8041e1,%rdx
  80197b:	00 00 00 
  80197e:	be 42 00 00 00       	mov    $0x42,%esi
  801983:	48 bf ec 41 80 00 00 	movabs $0x8041ec,%rdi
  80198a:	00 00 00 
  80198d:	b8 00 00 00 00       	mov    $0x0,%eax
  801992:	49 b8 73 2f 80 00 00 	movabs $0x802f73,%r8
  801999:	00 00 00 
  80199c:	41 ff d0             	call   *%r8
    }
}
  80199f:	48 83 c4 18          	add    $0x18,%rsp
  8019a3:	5b                   	pop    %rbx
  8019a4:	41 5c                	pop    %r12
  8019a6:	41 5d                	pop    %r13
  8019a8:	41 5e                	pop    %r14
  8019aa:	41 5f                	pop    %r15
  8019ac:	5d                   	pop    %rbp
  8019ad:	c3                   	ret

00000000008019ae <ipc_find_env>:

/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
  8019ae:	f3 0f 1e fa          	endbr64
    for (size_t i = 0; i < NENV; i++)
  8019b2:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  8019b7:	48 b9 00 00 a0 1f 80 	movabs $0x801fa00000,%rcx
  8019be:	00 00 00 
  8019c1:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8019c5:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  8019c9:	48 c1 e2 04          	shl    $0x4,%rdx
  8019cd:	48 01 ca             	add    %rcx,%rdx
  8019d0:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  8019d6:	39 fa                	cmp    %edi,%edx
  8019d8:	74 12                	je     8019ec <ipc_find_env+0x3e>
    for (size_t i = 0; i < NENV; i++)
  8019da:	48 83 c0 01          	add    $0x1,%rax
  8019de:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  8019e4:	75 db                	jne    8019c1 <ipc_find_env+0x13>
            return envs[i].env_id;
    return 0;
  8019e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019eb:	c3                   	ret
            return envs[i].env_id;
  8019ec:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8019f0:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  8019f4:	48 c1 e2 04          	shl    $0x4,%rdx
  8019f8:	48 b8 00 00 a0 1f 80 	movabs $0x801fa00000,%rax
  8019ff:	00 00 00 
  801a02:	48 01 d0             	add    %rdx,%rax
  801a05:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801a0b:	c3                   	ret

0000000000801a0c <fd2num>:


/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
  801a0c:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801a10:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801a17:	ff ff ff 
  801a1a:	48 01 f8             	add    %rdi,%rax
  801a1d:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801a21:	c3                   	ret

0000000000801a22 <fd2data>:

char *
fd2data(struct Fd *fd) {
  801a22:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801a26:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801a2d:	ff ff ff 
  801a30:	48 01 f8             	add    %rdi,%rax
  801a33:	48 c1 e8 0c          	shr    $0xc,%rax
    return INDEX2DATA(fd2num(fd));
  801a37:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801a3d:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801a41:	c3                   	ret

0000000000801a42 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  801a42:	f3 0f 1e fa          	endbr64
  801a46:	55                   	push   %rbp
  801a47:	48 89 e5             	mov    %rsp,%rbp
  801a4a:	41 57                	push   %r15
  801a4c:	41 56                	push   %r14
  801a4e:	41 55                	push   %r13
  801a50:	41 54                	push   %r12
  801a52:	53                   	push   %rbx
  801a53:	48 83 ec 08          	sub    $0x8,%rsp
  801a57:	49 89 ff             	mov    %rdi,%r15
  801a5a:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  801a5f:	49 bd a1 2b 80 00 00 	movabs $0x802ba1,%r13
  801a66:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  801a69:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        struct Fd *fd = INDEX2FD(i);
  801a6f:	49 89 dc             	mov    %rbx,%r12
        if (!(get_prot(fd) & PROT_R)) {
  801a72:	48 89 df             	mov    %rbx,%rdi
  801a75:	41 ff d5             	call   *%r13
  801a78:	83 e0 04             	and    $0x4,%eax
  801a7b:	74 17                	je     801a94 <fd_alloc+0x52>
    for (int i = 0; i < MAXFD; i++) {
  801a7d:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  801a84:	4c 39 f3             	cmp    %r14,%rbx
  801a87:	75 e6                	jne    801a6f <fd_alloc+0x2d>
  801a89:	41 bc 00 00 00 00    	mov    $0x0,%r12d
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
    return -E_MAX_OPEN;
  801a8f:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
            *fd_store = fd;
  801a94:	4d 89 27             	mov    %r12,(%r15)
}
  801a97:	48 83 c4 08          	add    $0x8,%rsp
  801a9b:	5b                   	pop    %rbx
  801a9c:	41 5c                	pop    %r12
  801a9e:	41 5d                	pop    %r13
  801aa0:	41 5e                	pop    %r14
  801aa2:	41 5f                	pop    %r15
  801aa4:	5d                   	pop    %rbp
  801aa5:	c3                   	ret

0000000000801aa6 <fd_lookup>:
 *
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
  801aa6:	f3 0f 1e fa          	endbr64
    if (fdnum < 0 || fdnum >= MAXFD) {
  801aaa:	83 ff 1f             	cmp    $0x1f,%edi
  801aad:	77 39                	ja     801ae8 <fd_lookup+0x42>
fd_lookup(int fdnum, struct Fd **fd_store) {
  801aaf:	55                   	push   %rbp
  801ab0:	48 89 e5             	mov    %rsp,%rbp
  801ab3:	41 54                	push   %r12
  801ab5:	53                   	push   %rbx
  801ab6:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  801ab9:	48 63 df             	movslq %edi,%rbx
  801abc:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  801ac3:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  801ac7:	48 89 df             	mov    %rbx,%rdi
  801aca:	48 b8 a1 2b 80 00 00 	movabs $0x802ba1,%rax
  801ad1:	00 00 00 
  801ad4:	ff d0                	call   *%rax
  801ad6:	a8 04                	test   $0x4,%al
  801ad8:	74 14                	je     801aee <fd_lookup+0x48>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  801ada:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  801ade:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ae3:	5b                   	pop    %rbx
  801ae4:	41 5c                	pop    %r12
  801ae6:	5d                   	pop    %rbp
  801ae7:	c3                   	ret
        return -E_INVAL;
  801ae8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801aed:	c3                   	ret
        return -E_INVAL;
  801aee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801af3:	eb ee                	jmp    801ae3 <fd_lookup+0x3d>

0000000000801af5 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  801af5:	f3 0f 1e fa          	endbr64
  801af9:	55                   	push   %rbp
  801afa:	48 89 e5             	mov    %rsp,%rbp
  801afd:	41 54                	push   %r12
  801aff:	53                   	push   %rbx
  801b00:	49 89 f4             	mov    %rsi,%r12
    for (size_t i = 0; devtab[i]; i++) {
  801b03:	48 b8 e0 47 80 00 00 	movabs $0x8047e0,%rax
  801b0a:	00 00 00 
  801b0d:	48 bb 20 50 80 00 00 	movabs $0x805020,%rbx
  801b14:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  801b17:	39 3b                	cmp    %edi,(%rbx)
  801b19:	74 47                	je     801b62 <dev_lookup+0x6d>
    for (size_t i = 0; devtab[i]; i++) {
  801b1b:	48 83 c0 08          	add    $0x8,%rax
  801b1f:	48 8b 18             	mov    (%rax),%rbx
  801b22:	48 85 db             	test   %rbx,%rbx
  801b25:	75 f0                	jne    801b17 <dev_lookup+0x22>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801b27:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801b2e:	00 00 00 
  801b31:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801b37:	89 fa                	mov    %edi,%edx
  801b39:	48 bf a8 43 80 00 00 	movabs $0x8043a8,%rdi
  801b40:	00 00 00 
  801b43:	b8 00 00 00 00       	mov    $0x0,%eax
  801b48:	48 b9 e5 03 80 00 00 	movabs $0x8003e5,%rcx
  801b4f:	00 00 00 
  801b52:	ff d1                	call   *%rcx
    *dev = 0;
    return -E_INVAL;
  801b54:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
            *dev = devtab[i];
  801b59:	49 89 1c 24          	mov    %rbx,(%r12)
}
  801b5d:	5b                   	pop    %rbx
  801b5e:	41 5c                	pop    %r12
  801b60:	5d                   	pop    %rbp
  801b61:	c3                   	ret
            return 0;
  801b62:	b8 00 00 00 00       	mov    $0x0,%eax
  801b67:	eb f0                	jmp    801b59 <dev_lookup+0x64>

0000000000801b69 <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  801b69:	f3 0f 1e fa          	endbr64
  801b6d:	55                   	push   %rbp
  801b6e:	48 89 e5             	mov    %rsp,%rbp
  801b71:	41 55                	push   %r13
  801b73:	41 54                	push   %r12
  801b75:	53                   	push   %rbx
  801b76:	48 83 ec 18          	sub    $0x18,%rsp
  801b7a:	48 89 fb             	mov    %rdi,%rbx
  801b7d:	41 89 f4             	mov    %esi,%r12d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801b80:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  801b87:	ff ff ff 
  801b8a:	48 01 df             	add    %rbx,%rdi
  801b8d:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  801b91:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801b95:	48 b8 a6 1a 80 00 00 	movabs $0x801aa6,%rax
  801b9c:	00 00 00 
  801b9f:	ff d0                	call   *%rax
  801ba1:	41 89 c5             	mov    %eax,%r13d
  801ba4:	85 c0                	test   %eax,%eax
  801ba6:	78 06                	js     801bae <fd_close+0x45>
  801ba8:	48 39 5d d8          	cmp    %rbx,-0x28(%rbp)
  801bac:	74 1a                	je     801bc8 <fd_close+0x5f>
        return (must_exist ? res : 0);
  801bae:	45 84 e4             	test   %r12b,%r12b
  801bb1:	b8 00 00 00 00       	mov    $0x0,%eax
  801bb6:	44 0f 44 e8          	cmove  %eax,%r13d
}
  801bba:	44 89 e8             	mov    %r13d,%eax
  801bbd:	48 83 c4 18          	add    $0x18,%rsp
  801bc1:	5b                   	pop    %rbx
  801bc2:	41 5c                	pop    %r12
  801bc4:	41 5d                	pop    %r13
  801bc6:	5d                   	pop    %rbp
  801bc7:	c3                   	ret
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801bc8:	8b 3b                	mov    (%rbx),%edi
  801bca:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801bce:	48 b8 f5 1a 80 00 00 	movabs $0x801af5,%rax
  801bd5:	00 00 00 
  801bd8:	ff d0                	call   *%rax
  801bda:	41 89 c5             	mov    %eax,%r13d
  801bdd:	85 c0                	test   %eax,%eax
  801bdf:	78 1b                	js     801bfc <fd_close+0x93>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  801be1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801be5:	48 8b 40 20          	mov    0x20(%rax),%rax
  801be9:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  801bef:	48 85 c0             	test   %rax,%rax
  801bf2:	74 08                	je     801bfc <fd_close+0x93>
  801bf4:	48 89 df             	mov    %rbx,%rdi
  801bf7:	ff d0                	call   *%rax
  801bf9:	41 89 c5             	mov    %eax,%r13d
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801bfc:	ba 00 10 00 00       	mov    $0x1000,%edx
  801c01:	48 89 de             	mov    %rbx,%rsi
  801c04:	bf 00 00 00 00       	mov    $0x0,%edi
  801c09:	48 b8 73 14 80 00 00 	movabs $0x801473,%rax
  801c10:	00 00 00 
  801c13:	ff d0                	call   *%rax
    return res;
  801c15:	eb a3                	jmp    801bba <fd_close+0x51>

0000000000801c17 <close>:

int
close(int fdnum) {
  801c17:	f3 0f 1e fa          	endbr64
  801c1b:	55                   	push   %rbp
  801c1c:	48 89 e5             	mov    %rsp,%rbp
  801c1f:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  801c23:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801c27:	48 b8 a6 1a 80 00 00 	movabs $0x801aa6,%rax
  801c2e:	00 00 00 
  801c31:	ff d0                	call   *%rax
    if (res < 0) return res;
  801c33:	85 c0                	test   %eax,%eax
  801c35:	78 15                	js     801c4c <close+0x35>

    return fd_close(fd, 1);
  801c37:	be 01 00 00 00       	mov    $0x1,%esi
  801c3c:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801c40:	48 b8 69 1b 80 00 00 	movabs $0x801b69,%rax
  801c47:	00 00 00 
  801c4a:	ff d0                	call   *%rax
}
  801c4c:	c9                   	leave
  801c4d:	c3                   	ret

0000000000801c4e <close_all>:

void
close_all(void) {
  801c4e:	f3 0f 1e fa          	endbr64
  801c52:	55                   	push   %rbp
  801c53:	48 89 e5             	mov    %rsp,%rbp
  801c56:	41 54                	push   %r12
  801c58:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  801c59:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c5e:	49 bc 17 1c 80 00 00 	movabs $0x801c17,%r12
  801c65:	00 00 00 
  801c68:	89 df                	mov    %ebx,%edi
  801c6a:	41 ff d4             	call   *%r12
  801c6d:	83 c3 01             	add    $0x1,%ebx
  801c70:	83 fb 20             	cmp    $0x20,%ebx
  801c73:	75 f3                	jne    801c68 <close_all+0x1a>
}
  801c75:	5b                   	pop    %rbx
  801c76:	41 5c                	pop    %r12
  801c78:	5d                   	pop    %rbp
  801c79:	c3                   	ret

0000000000801c7a <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  801c7a:	f3 0f 1e fa          	endbr64
  801c7e:	55                   	push   %rbp
  801c7f:	48 89 e5             	mov    %rsp,%rbp
  801c82:	41 57                	push   %r15
  801c84:	41 56                	push   %r14
  801c86:	41 55                	push   %r13
  801c88:	41 54                	push   %r12
  801c8a:	53                   	push   %rbx
  801c8b:	48 83 ec 18          	sub    $0x18,%rsp
  801c8f:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  801c92:	48 8d 75 c8          	lea    -0x38(%rbp),%rsi
  801c96:	48 b8 a6 1a 80 00 00 	movabs $0x801aa6,%rax
  801c9d:	00 00 00 
  801ca0:	ff d0                	call   *%rax
  801ca2:	89 c3                	mov    %eax,%ebx
  801ca4:	85 c0                	test   %eax,%eax
  801ca6:	0f 88 b8 00 00 00    	js     801d64 <dup+0xea>
    close(newfdnum);
  801cac:	44 89 e7             	mov    %r12d,%edi
  801caf:	48 b8 17 1c 80 00 00 	movabs $0x801c17,%rax
  801cb6:	00 00 00 
  801cb9:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  801cbb:	4d 63 ec             	movslq %r12d,%r13
  801cbe:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  801cc5:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  801cc9:	4c 8b 7d c8          	mov    -0x38(%rbp),%r15
  801ccd:	4c 89 ff             	mov    %r15,%rdi
  801cd0:	49 be 22 1a 80 00 00 	movabs $0x801a22,%r14
  801cd7:	00 00 00 
  801cda:	41 ff d6             	call   *%r14
  801cdd:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  801ce0:	4c 89 ef             	mov    %r13,%rdi
  801ce3:	41 ff d6             	call   *%r14
  801ce6:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  801ce9:	48 89 df             	mov    %rbx,%rdi
  801cec:	48 b8 a1 2b 80 00 00 	movabs $0x802ba1,%rax
  801cf3:	00 00 00 
  801cf6:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  801cf8:	a8 04                	test   $0x4,%al
  801cfa:	74 2b                	je     801d27 <dup+0xad>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  801cfc:	41 89 c1             	mov    %eax,%r9d
  801cff:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801d05:	4c 89 f1             	mov    %r14,%rcx
  801d08:	ba 00 00 00 00       	mov    $0x0,%edx
  801d0d:	48 89 de             	mov    %rbx,%rsi
  801d10:	bf 00 00 00 00       	mov    $0x0,%edi
  801d15:	48 b8 9e 13 80 00 00 	movabs $0x80139e,%rax
  801d1c:	00 00 00 
  801d1f:	ff d0                	call   *%rax
  801d21:	89 c3                	mov    %eax,%ebx
  801d23:	85 c0                	test   %eax,%eax
  801d25:	78 4e                	js     801d75 <dup+0xfb>
    }
    prot = get_prot(oldfd);
  801d27:	4c 89 ff             	mov    %r15,%rdi
  801d2a:	48 b8 a1 2b 80 00 00 	movabs $0x802ba1,%rax
  801d31:	00 00 00 
  801d34:	ff d0                	call   *%rax
  801d36:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  801d39:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801d3f:	4c 89 e9             	mov    %r13,%rcx
  801d42:	ba 00 00 00 00       	mov    $0x0,%edx
  801d47:	4c 89 fe             	mov    %r15,%rsi
  801d4a:	bf 00 00 00 00       	mov    $0x0,%edi
  801d4f:	48 b8 9e 13 80 00 00 	movabs $0x80139e,%rax
  801d56:	00 00 00 
  801d59:	ff d0                	call   *%rax
  801d5b:	89 c3                	mov    %eax,%ebx
  801d5d:	85 c0                	test   %eax,%eax
  801d5f:	78 14                	js     801d75 <dup+0xfb>

    return newfdnum;
  801d61:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  801d64:	89 d8                	mov    %ebx,%eax
  801d66:	48 83 c4 18          	add    $0x18,%rsp
  801d6a:	5b                   	pop    %rbx
  801d6b:	41 5c                	pop    %r12
  801d6d:	41 5d                	pop    %r13
  801d6f:	41 5e                	pop    %r14
  801d71:	41 5f                	pop    %r15
  801d73:	5d                   	pop    %rbp
  801d74:	c3                   	ret
    sys_unmap_region(0, newfd, PAGE_SIZE);
  801d75:	ba 00 10 00 00       	mov    $0x1000,%edx
  801d7a:	4c 89 ee             	mov    %r13,%rsi
  801d7d:	bf 00 00 00 00       	mov    $0x0,%edi
  801d82:	49 bc 73 14 80 00 00 	movabs $0x801473,%r12
  801d89:	00 00 00 
  801d8c:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  801d8f:	ba 00 10 00 00       	mov    $0x1000,%edx
  801d94:	4c 89 f6             	mov    %r14,%rsi
  801d97:	bf 00 00 00 00       	mov    $0x0,%edi
  801d9c:	41 ff d4             	call   *%r12
    return res;
  801d9f:	eb c3                	jmp    801d64 <dup+0xea>

0000000000801da1 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  801da1:	f3 0f 1e fa          	endbr64
  801da5:	55                   	push   %rbp
  801da6:	48 89 e5             	mov    %rsp,%rbp
  801da9:	41 56                	push   %r14
  801dab:	41 55                	push   %r13
  801dad:	41 54                	push   %r12
  801daf:	53                   	push   %rbx
  801db0:	48 83 ec 10          	sub    $0x10,%rsp
  801db4:	89 fb                	mov    %edi,%ebx
  801db6:	49 89 f4             	mov    %rsi,%r12
  801db9:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801dbc:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801dc0:	48 b8 a6 1a 80 00 00 	movabs $0x801aa6,%rax
  801dc7:	00 00 00 
  801dca:	ff d0                	call   *%rax
  801dcc:	85 c0                	test   %eax,%eax
  801dce:	78 4c                	js     801e1c <read+0x7b>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801dd0:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801dd4:	41 8b 3e             	mov    (%r14),%edi
  801dd7:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801ddb:	48 b8 f5 1a 80 00 00 	movabs $0x801af5,%rax
  801de2:	00 00 00 
  801de5:	ff d0                	call   *%rax
  801de7:	85 c0                	test   %eax,%eax
  801de9:	78 35                	js     801e20 <read+0x7f>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801deb:	41 8b 46 08          	mov    0x8(%r14),%eax
  801def:	83 e0 03             	and    $0x3,%eax
  801df2:	83 f8 01             	cmp    $0x1,%eax
  801df5:	74 2d                	je     801e24 <read+0x83>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  801df7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801dfb:	48 8b 40 10          	mov    0x10(%rax),%rax
  801dff:	48 85 c0             	test   %rax,%rax
  801e02:	74 56                	je     801e5a <read+0xb9>

    return (*dev->dev_read)(fd, buf, n);
  801e04:	4c 89 ea             	mov    %r13,%rdx
  801e07:	4c 89 e6             	mov    %r12,%rsi
  801e0a:	4c 89 f7             	mov    %r14,%rdi
  801e0d:	ff d0                	call   *%rax
}
  801e0f:	48 83 c4 10          	add    $0x10,%rsp
  801e13:	5b                   	pop    %rbx
  801e14:	41 5c                	pop    %r12
  801e16:	41 5d                	pop    %r13
  801e18:	41 5e                	pop    %r14
  801e1a:	5d                   	pop    %rbp
  801e1b:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801e1c:	48 98                	cltq
  801e1e:	eb ef                	jmp    801e0f <read+0x6e>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801e20:	48 98                	cltq
  801e22:	eb eb                	jmp    801e0f <read+0x6e>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801e24:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801e2b:	00 00 00 
  801e2e:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801e34:	89 da                	mov    %ebx,%edx
  801e36:	48 bf f6 41 80 00 00 	movabs $0x8041f6,%rdi
  801e3d:	00 00 00 
  801e40:	b8 00 00 00 00       	mov    $0x0,%eax
  801e45:	48 b9 e5 03 80 00 00 	movabs $0x8003e5,%rcx
  801e4c:	00 00 00 
  801e4f:	ff d1                	call   *%rcx
        return -E_INVAL;
  801e51:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801e58:	eb b5                	jmp    801e0f <read+0x6e>
    if (!dev->dev_read) return -E_NOT_SUPP;
  801e5a:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801e61:	eb ac                	jmp    801e0f <read+0x6e>

0000000000801e63 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801e63:	f3 0f 1e fa          	endbr64
  801e67:	55                   	push   %rbp
  801e68:	48 89 e5             	mov    %rsp,%rbp
  801e6b:	41 57                	push   %r15
  801e6d:	41 56                	push   %r14
  801e6f:	41 55                	push   %r13
  801e71:	41 54                	push   %r12
  801e73:	53                   	push   %rbx
  801e74:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801e78:	48 85 d2             	test   %rdx,%rdx
  801e7b:	74 54                	je     801ed1 <readn+0x6e>
  801e7d:	41 89 fd             	mov    %edi,%r13d
  801e80:	49 89 f6             	mov    %rsi,%r14
  801e83:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801e86:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801e8b:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801e90:	49 bf a1 1d 80 00 00 	movabs $0x801da1,%r15
  801e97:	00 00 00 
  801e9a:	4c 89 e2             	mov    %r12,%rdx
  801e9d:	48 29 f2             	sub    %rsi,%rdx
  801ea0:	4c 01 f6             	add    %r14,%rsi
  801ea3:	44 89 ef             	mov    %r13d,%edi
  801ea6:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  801ea9:	85 c0                	test   %eax,%eax
  801eab:	78 20                	js     801ecd <readn+0x6a>
    for (; inc && res < n; res += inc) {
  801ead:	01 c3                	add    %eax,%ebx
  801eaf:	85 c0                	test   %eax,%eax
  801eb1:	74 08                	je     801ebb <readn+0x58>
  801eb3:	48 63 f3             	movslq %ebx,%rsi
  801eb6:	4c 39 e6             	cmp    %r12,%rsi
  801eb9:	72 df                	jb     801e9a <readn+0x37>
    }
    return res;
  801ebb:	48 63 c3             	movslq %ebx,%rax
}
  801ebe:	48 83 c4 08          	add    $0x8,%rsp
  801ec2:	5b                   	pop    %rbx
  801ec3:	41 5c                	pop    %r12
  801ec5:	41 5d                	pop    %r13
  801ec7:	41 5e                	pop    %r14
  801ec9:	41 5f                	pop    %r15
  801ecb:	5d                   	pop    %rbp
  801ecc:	c3                   	ret
        if (inc < 0) return inc;
  801ecd:	48 98                	cltq
  801ecf:	eb ed                	jmp    801ebe <readn+0x5b>
    int inc = 1, res = 0;
  801ed1:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ed6:	eb e3                	jmp    801ebb <readn+0x58>

0000000000801ed8 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  801ed8:	f3 0f 1e fa          	endbr64
  801edc:	55                   	push   %rbp
  801edd:	48 89 e5             	mov    %rsp,%rbp
  801ee0:	41 56                	push   %r14
  801ee2:	41 55                	push   %r13
  801ee4:	41 54                	push   %r12
  801ee6:	53                   	push   %rbx
  801ee7:	48 83 ec 10          	sub    $0x10,%rsp
  801eeb:	89 fb                	mov    %edi,%ebx
  801eed:	49 89 f4             	mov    %rsi,%r12
  801ef0:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801ef3:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801ef7:	48 b8 a6 1a 80 00 00 	movabs $0x801aa6,%rax
  801efe:	00 00 00 
  801f01:	ff d0                	call   *%rax
  801f03:	85 c0                	test   %eax,%eax
  801f05:	78 47                	js     801f4e <write+0x76>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801f07:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801f0b:	41 8b 3e             	mov    (%r14),%edi
  801f0e:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801f12:	48 b8 f5 1a 80 00 00 	movabs $0x801af5,%rax
  801f19:	00 00 00 
  801f1c:	ff d0                	call   *%rax
  801f1e:	85 c0                	test   %eax,%eax
  801f20:	78 30                	js     801f52 <write+0x7a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801f22:	41 f6 46 08 03       	testb  $0x3,0x8(%r14)
  801f27:	74 2d                	je     801f56 <write+0x7e>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801f29:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801f2d:	48 8b 40 18          	mov    0x18(%rax),%rax
  801f31:	48 85 c0             	test   %rax,%rax
  801f34:	74 56                	je     801f8c <write+0xb4>

    return (*dev->dev_write)(fd, buf, n);
  801f36:	4c 89 ea             	mov    %r13,%rdx
  801f39:	4c 89 e6             	mov    %r12,%rsi
  801f3c:	4c 89 f7             	mov    %r14,%rdi
  801f3f:	ff d0                	call   *%rax
}
  801f41:	48 83 c4 10          	add    $0x10,%rsp
  801f45:	5b                   	pop    %rbx
  801f46:	41 5c                	pop    %r12
  801f48:	41 5d                	pop    %r13
  801f4a:	41 5e                	pop    %r14
  801f4c:	5d                   	pop    %rbp
  801f4d:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801f4e:	48 98                	cltq
  801f50:	eb ef                	jmp    801f41 <write+0x69>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801f52:	48 98                	cltq
  801f54:	eb eb                	jmp    801f41 <write+0x69>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801f56:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801f5d:	00 00 00 
  801f60:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801f66:	89 da                	mov    %ebx,%edx
  801f68:	48 bf 12 42 80 00 00 	movabs $0x804212,%rdi
  801f6f:	00 00 00 
  801f72:	b8 00 00 00 00       	mov    $0x0,%eax
  801f77:	48 b9 e5 03 80 00 00 	movabs $0x8003e5,%rcx
  801f7e:	00 00 00 
  801f81:	ff d1                	call   *%rcx
        return -E_INVAL;
  801f83:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801f8a:	eb b5                	jmp    801f41 <write+0x69>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801f8c:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801f93:	eb ac                	jmp    801f41 <write+0x69>

0000000000801f95 <seek>:

int
seek(int fdnum, off_t offset) {
  801f95:	f3 0f 1e fa          	endbr64
  801f99:	55                   	push   %rbp
  801f9a:	48 89 e5             	mov    %rsp,%rbp
  801f9d:	53                   	push   %rbx
  801f9e:	48 83 ec 18          	sub    $0x18,%rsp
  801fa2:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801fa4:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801fa8:	48 b8 a6 1a 80 00 00 	movabs $0x801aa6,%rax
  801faf:	00 00 00 
  801fb2:	ff d0                	call   *%rax
  801fb4:	85 c0                	test   %eax,%eax
  801fb6:	78 0c                	js     801fc4 <seek+0x2f>

    fd->fd_offset = offset;
  801fb8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fbc:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  801fbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fc4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801fc8:	c9                   	leave
  801fc9:	c3                   	ret

0000000000801fca <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  801fca:	f3 0f 1e fa          	endbr64
  801fce:	55                   	push   %rbp
  801fcf:	48 89 e5             	mov    %rsp,%rbp
  801fd2:	41 55                	push   %r13
  801fd4:	41 54                	push   %r12
  801fd6:	53                   	push   %rbx
  801fd7:	48 83 ec 18          	sub    $0x18,%rsp
  801fdb:	89 fb                	mov    %edi,%ebx
  801fdd:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801fe0:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801fe4:	48 b8 a6 1a 80 00 00 	movabs $0x801aa6,%rax
  801feb:	00 00 00 
  801fee:	ff d0                	call   *%rax
  801ff0:	85 c0                	test   %eax,%eax
  801ff2:	78 38                	js     80202c <ftruncate+0x62>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801ff4:	4c 8b 6d d8          	mov    -0x28(%rbp),%r13
  801ff8:	41 8b 7d 00          	mov    0x0(%r13),%edi
  801ffc:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  802000:	48 b8 f5 1a 80 00 00 	movabs $0x801af5,%rax
  802007:	00 00 00 
  80200a:	ff d0                	call   *%rax
  80200c:	85 c0                	test   %eax,%eax
  80200e:	78 1c                	js     80202c <ftruncate+0x62>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802010:	41 f6 45 08 03       	testb  $0x3,0x8(%r13)
  802015:	74 20                	je     802037 <ftruncate+0x6d>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  802017:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80201b:	48 8b 40 30          	mov    0x30(%rax),%rax
  80201f:	48 85 c0             	test   %rax,%rax
  802022:	74 47                	je     80206b <ftruncate+0xa1>

    return (*dev->dev_trunc)(fd, newsize);
  802024:	44 89 e6             	mov    %r12d,%esi
  802027:	4c 89 ef             	mov    %r13,%rdi
  80202a:	ff d0                	call   *%rax
}
  80202c:	48 83 c4 18          	add    $0x18,%rsp
  802030:	5b                   	pop    %rbx
  802031:	41 5c                	pop    %r12
  802033:	41 5d                	pop    %r13
  802035:	5d                   	pop    %rbp
  802036:	c3                   	ret
                thisenv->env_id, fdnum);
  802037:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  80203e:	00 00 00 
  802041:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  802047:	89 da                	mov    %ebx,%edx
  802049:	48 bf c8 43 80 00 00 	movabs $0x8043c8,%rdi
  802050:	00 00 00 
  802053:	b8 00 00 00 00       	mov    $0x0,%eax
  802058:	48 b9 e5 03 80 00 00 	movabs $0x8003e5,%rcx
  80205f:	00 00 00 
  802062:	ff d1                	call   *%rcx
        return -E_INVAL;
  802064:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802069:	eb c1                	jmp    80202c <ftruncate+0x62>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  80206b:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  802070:	eb ba                	jmp    80202c <ftruncate+0x62>

0000000000802072 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  802072:	f3 0f 1e fa          	endbr64
  802076:	55                   	push   %rbp
  802077:	48 89 e5             	mov    %rsp,%rbp
  80207a:	41 54                	push   %r12
  80207c:	53                   	push   %rbx
  80207d:	48 83 ec 10          	sub    $0x10,%rsp
  802081:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  802084:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  802088:	48 b8 a6 1a 80 00 00 	movabs $0x801aa6,%rax
  80208f:	00 00 00 
  802092:	ff d0                	call   *%rax
  802094:	85 c0                	test   %eax,%eax
  802096:	78 4e                	js     8020e6 <fstat+0x74>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  802098:	4c 8b 65 e8          	mov    -0x18(%rbp),%r12
  80209c:	41 8b 3c 24          	mov    (%r12),%edi
  8020a0:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  8020a4:	48 b8 f5 1a 80 00 00 	movabs $0x801af5,%rax
  8020ab:	00 00 00 
  8020ae:	ff d0                	call   *%rax
  8020b0:	85 c0                	test   %eax,%eax
  8020b2:	78 32                	js     8020e6 <fstat+0x74>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  8020b4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020b8:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  8020bd:	74 30                	je     8020ef <fstat+0x7d>

    stat->st_name[0] = 0;
  8020bf:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  8020c2:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  8020c9:	00 00 00 
    stat->st_isdir = 0;
  8020cc:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  8020d3:	00 00 00 
    stat->st_dev = dev;
  8020d6:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  8020dd:	48 89 de             	mov    %rbx,%rsi
  8020e0:	4c 89 e7             	mov    %r12,%rdi
  8020e3:	ff 50 28             	call   *0x28(%rax)
}
  8020e6:	48 83 c4 10          	add    $0x10,%rsp
  8020ea:	5b                   	pop    %rbx
  8020eb:	41 5c                	pop    %r12
  8020ed:	5d                   	pop    %rbp
  8020ee:	c3                   	ret
    if (!dev->dev_stat) return -E_NOT_SUPP;
  8020ef:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  8020f4:	eb f0                	jmp    8020e6 <fstat+0x74>

00000000008020f6 <stat>:

int
stat(const char *path, struct Stat *stat) {
  8020f6:	f3 0f 1e fa          	endbr64
  8020fa:	55                   	push   %rbp
  8020fb:	48 89 e5             	mov    %rsp,%rbp
  8020fe:	41 54                	push   %r12
  802100:	53                   	push   %rbx
  802101:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  802104:	be 00 00 00 00       	mov    $0x0,%esi
  802109:	48 b8 d7 23 80 00 00 	movabs $0x8023d7,%rax
  802110:	00 00 00 
  802113:	ff d0                	call   *%rax
  802115:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  802117:	85 c0                	test   %eax,%eax
  802119:	78 25                	js     802140 <stat+0x4a>

    int res = fstat(fd, stat);
  80211b:	4c 89 e6             	mov    %r12,%rsi
  80211e:	89 c7                	mov    %eax,%edi
  802120:	48 b8 72 20 80 00 00 	movabs $0x802072,%rax
  802127:	00 00 00 
  80212a:	ff d0                	call   *%rax
  80212c:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  80212f:	89 df                	mov    %ebx,%edi
  802131:	48 b8 17 1c 80 00 00 	movabs $0x801c17,%rax
  802138:	00 00 00 
  80213b:	ff d0                	call   *%rax

    return res;
  80213d:	44 89 e3             	mov    %r12d,%ebx
}
  802140:	89 d8                	mov    %ebx,%eax
  802142:	5b                   	pop    %rbx
  802143:	41 5c                	pop    %r12
  802145:	5d                   	pop    %rbp
  802146:	c3                   	ret

0000000000802147 <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  802147:	f3 0f 1e fa          	endbr64
  80214b:	55                   	push   %rbp
  80214c:	48 89 e5             	mov    %rsp,%rbp
  80214f:	41 54                	push   %r12
  802151:	53                   	push   %rbx
  802152:	48 83 ec 10          	sub    $0x10,%rsp
  802156:	41 89 fc             	mov    %edi,%r12d
  802159:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  80215c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802163:	00 00 00 
  802166:	83 38 00             	cmpl   $0x0,(%rax)
  802169:	74 6e                	je     8021d9 <fsipc+0x92>

    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }
    fsenv = ipc_find_env(ENV_TYPE_FS);
  80216b:	bf 03 00 00 00       	mov    $0x3,%edi
  802170:	48 b8 ae 19 80 00 00 	movabs $0x8019ae,%rax
  802177:	00 00 00 
  80217a:	ff d0                	call   *%rax
  80217c:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  802183:	00 00 
    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  802185:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  80218b:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802190:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802197:	00 00 00 
  80219a:	44 89 e6             	mov    %r12d,%esi
  80219d:	89 c7                	mov    %eax,%edi
  80219f:	48 b8 ec 18 80 00 00 	movabs $0x8018ec,%rax
  8021a6:	00 00 00 
  8021a9:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  8021ab:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  8021b2:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  8021b3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8021b8:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8021bc:	48 89 de             	mov    %rbx,%rsi
  8021bf:	bf 00 00 00 00       	mov    $0x0,%edi
  8021c4:	48 b8 53 18 80 00 00 	movabs $0x801853,%rax
  8021cb:	00 00 00 
  8021ce:	ff d0                	call   *%rax
}
  8021d0:	48 83 c4 10          	add    $0x10,%rsp
  8021d4:	5b                   	pop    %rbx
  8021d5:	41 5c                	pop    %r12
  8021d7:	5d                   	pop    %rbp
  8021d8:	c3                   	ret
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  8021d9:	bf 03 00 00 00       	mov    $0x3,%edi
  8021de:	48 b8 ae 19 80 00 00 	movabs $0x8019ae,%rax
  8021e5:	00 00 00 
  8021e8:	ff d0                	call   *%rax
  8021ea:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  8021f1:	00 00 
  8021f3:	e9 73 ff ff ff       	jmp    80216b <fsipc+0x24>

00000000008021f8 <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  8021f8:	f3 0f 1e fa          	endbr64
  8021fc:	55                   	push   %rbp
  8021fd:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802200:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802207:	00 00 00 
  80220a:	8b 57 0c             	mov    0xc(%rdi),%edx
  80220d:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  80220f:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  802212:	be 00 00 00 00       	mov    $0x0,%esi
  802217:	bf 02 00 00 00       	mov    $0x2,%edi
  80221c:	48 b8 47 21 80 00 00 	movabs $0x802147,%rax
  802223:	00 00 00 
  802226:	ff d0                	call   *%rax
}
  802228:	5d                   	pop    %rbp
  802229:	c3                   	ret

000000000080222a <devfile_flush>:
devfile_flush(struct Fd *fd) {
  80222a:	f3 0f 1e fa          	endbr64
  80222e:	55                   	push   %rbp
  80222f:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802232:	8b 47 0c             	mov    0xc(%rdi),%eax
  802235:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  80223c:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  80223e:	be 00 00 00 00       	mov    $0x0,%esi
  802243:	bf 06 00 00 00       	mov    $0x6,%edi
  802248:	48 b8 47 21 80 00 00 	movabs $0x802147,%rax
  80224f:	00 00 00 
  802252:	ff d0                	call   *%rax
}
  802254:	5d                   	pop    %rbp
  802255:	c3                   	ret

0000000000802256 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  802256:	f3 0f 1e fa          	endbr64
  80225a:	55                   	push   %rbp
  80225b:	48 89 e5             	mov    %rsp,%rbp
  80225e:	41 54                	push   %r12
  802260:	53                   	push   %rbx
  802261:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802264:	8b 47 0c             	mov    0xc(%rdi),%eax
  802267:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  80226e:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  802270:	be 00 00 00 00       	mov    $0x0,%esi
  802275:	bf 05 00 00 00       	mov    $0x5,%edi
  80227a:	48 b8 47 21 80 00 00 	movabs $0x802147,%rax
  802281:	00 00 00 
  802284:	ff d0                	call   *%rax
    if (res < 0) return res;
  802286:	85 c0                	test   %eax,%eax
  802288:	78 3d                	js     8022c7 <devfile_stat+0x71>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80228a:	49 bc 00 70 80 00 00 	movabs $0x807000,%r12
  802291:	00 00 00 
  802294:	4c 89 e6             	mov    %r12,%rsi
  802297:	48 89 df             	mov    %rbx,%rdi
  80229a:	48 b8 2e 0d 80 00 00 	movabs $0x800d2e,%rax
  8022a1:	00 00 00 
  8022a4:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  8022a6:	41 8b 84 24 80 00 00 	mov    0x80(%r12),%eax
  8022ad:	00 
  8022ae:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8022b4:	41 8b 84 24 84 00 00 	mov    0x84(%r12),%eax
  8022bb:	00 
  8022bc:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  8022c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022c7:	5b                   	pop    %rbx
  8022c8:	41 5c                	pop    %r12
  8022ca:	5d                   	pop    %rbp
  8022cb:	c3                   	ret

00000000008022cc <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  8022cc:	f3 0f 1e fa          	endbr64
    if (n >= sizeof(fsipcbuf.write.req_buf)) {
  8022d0:	48 81 fa ef 0f 00 00 	cmp    $0xfef,%rdx
  8022d7:	77 41                	ja     80231a <devfile_write+0x4e>
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  8022d9:	55                   	push   %rbp
  8022da:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  8022dd:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8022e4:	00 00 00 
  8022e7:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  8022ea:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.write.req_n = n;
  8022ec:	48 89 50 08          	mov    %rdx,0x8(%rax)
    memmove(fsipcbuf.write.req_buf, buf, n);
  8022f0:	48 8d 78 10          	lea    0x10(%rax),%rdi
  8022f4:	48 b8 49 0f 80 00 00 	movabs $0x800f49,%rax
  8022fb:	00 00 00 
  8022fe:	ff d0                	call   *%rax
    res = fsipc(FSREQ_WRITE, NULL);
  802300:	be 00 00 00 00       	mov    $0x0,%esi
  802305:	bf 04 00 00 00       	mov    $0x4,%edi
  80230a:	48 b8 47 21 80 00 00 	movabs $0x802147,%rax
  802311:	00 00 00 
  802314:	ff d0                	call   *%rax
  802316:	48 98                	cltq
}
  802318:	5d                   	pop    %rbp
  802319:	c3                   	ret
        return -E_INVAL;
  80231a:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
}
  802321:	c3                   	ret

0000000000802322 <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  802322:	f3 0f 1e fa          	endbr64
  802326:	55                   	push   %rbp
  802327:	48 89 e5             	mov    %rsp,%rbp
  80232a:	41 55                	push   %r13
  80232c:	41 54                	push   %r12
  80232e:	53                   	push   %rbx
  80232f:	48 83 ec 08          	sub    $0x8,%rsp
  802333:	49 89 f4             	mov    %rsi,%r12
  802336:	48 89 d3             	mov    %rdx,%rbx
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  802339:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802340:	00 00 00 
  802343:	8b 57 0c             	mov    0xc(%rdi),%edx
  802346:	89 10                	mov    %edx,(%rax)
    fsipcbuf.read.req_n = n;
  802348:	48 89 58 08          	mov    %rbx,0x8(%rax)
    res = fsipc(FSREQ_READ, NULL);
  80234c:	be 00 00 00 00       	mov    $0x0,%esi
  802351:	bf 03 00 00 00       	mov    $0x3,%edi
  802356:	48 b8 47 21 80 00 00 	movabs $0x802147,%rax
  80235d:	00 00 00 
  802360:	ff d0                	call   *%rax
  802362:	4c 63 e8             	movslq %eax,%r13
    if (res < 0) {
  802365:	4d 85 ed             	test   %r13,%r13
  802368:	78 2a                	js     802394 <devfile_read+0x72>
    assert(res <= n && res <= PAGE_SIZE);
  80236a:	4c 89 ea             	mov    %r13,%rdx
  80236d:	4c 39 eb             	cmp    %r13,%rbx
  802370:	72 30                	jb     8023a2 <devfile_read+0x80>
  802372:	49 81 fd 00 10 00 00 	cmp    $0x1000,%r13
  802379:	7f 27                	jg     8023a2 <devfile_read+0x80>
    memmove(buf, &fsipcbuf, res);
  80237b:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802382:	00 00 00 
  802385:	4c 89 e7             	mov    %r12,%rdi
  802388:	48 b8 49 0f 80 00 00 	movabs $0x800f49,%rax
  80238f:	00 00 00 
  802392:	ff d0                	call   *%rax
}
  802394:	4c 89 e8             	mov    %r13,%rax
  802397:	48 83 c4 08          	add    $0x8,%rsp
  80239b:	5b                   	pop    %rbx
  80239c:	41 5c                	pop    %r12
  80239e:	41 5d                	pop    %r13
  8023a0:	5d                   	pop    %rbp
  8023a1:	c3                   	ret
    assert(res <= n && res <= PAGE_SIZE);
  8023a2:	48 b9 2f 42 80 00 00 	movabs $0x80422f,%rcx
  8023a9:	00 00 00 
  8023ac:	48 ba 4c 42 80 00 00 	movabs $0x80424c,%rdx
  8023b3:	00 00 00 
  8023b6:	be 7b 00 00 00       	mov    $0x7b,%esi
  8023bb:	48 bf 61 42 80 00 00 	movabs $0x804261,%rdi
  8023c2:	00 00 00 
  8023c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8023ca:	49 b8 73 2f 80 00 00 	movabs $0x802f73,%r8
  8023d1:	00 00 00 
  8023d4:	41 ff d0             	call   *%r8

00000000008023d7 <open>:
open(const char *path, int mode) {
  8023d7:	f3 0f 1e fa          	endbr64
  8023db:	55                   	push   %rbp
  8023dc:	48 89 e5             	mov    %rsp,%rbp
  8023df:	41 55                	push   %r13
  8023e1:	41 54                	push   %r12
  8023e3:	53                   	push   %rbx
  8023e4:	48 83 ec 18          	sub    $0x18,%rsp
  8023e8:	49 89 fc             	mov    %rdi,%r12
  8023eb:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  8023ee:	48 b8 e9 0c 80 00 00 	movabs $0x800ce9,%rax
  8023f5:	00 00 00 
  8023f8:	ff d0                	call   *%rax
  8023fa:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  802400:	0f 87 8a 00 00 00    	ja     802490 <open+0xb9>
    if ((res = fd_alloc(&fd)) < 0) return res;
  802406:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  80240a:	48 b8 42 1a 80 00 00 	movabs $0x801a42,%rax
  802411:	00 00 00 
  802414:	ff d0                	call   *%rax
  802416:	89 c3                	mov    %eax,%ebx
  802418:	85 c0                	test   %eax,%eax
  80241a:	78 50                	js     80246c <open+0x95>
    strcpy(fsipcbuf.open.req_path, path);
  80241c:	4c 89 e6             	mov    %r12,%rsi
  80241f:	48 bb 00 70 80 00 00 	movabs $0x807000,%rbx
  802426:	00 00 00 
  802429:	48 89 df             	mov    %rbx,%rdi
  80242c:	48 b8 2e 0d 80 00 00 	movabs $0x800d2e,%rax
  802433:	00 00 00 
  802436:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  802438:	44 89 ab 00 04 00 00 	mov    %r13d,0x400(%rbx)
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  80243f:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802443:	bf 01 00 00 00       	mov    $0x1,%edi
  802448:	48 b8 47 21 80 00 00 	movabs $0x802147,%rax
  80244f:	00 00 00 
  802452:	ff d0                	call   *%rax
  802454:	89 c3                	mov    %eax,%ebx
  802456:	85 c0                	test   %eax,%eax
  802458:	78 1f                	js     802479 <open+0xa2>
    return fd2num(fd);
  80245a:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80245e:	48 b8 0c 1a 80 00 00 	movabs $0x801a0c,%rax
  802465:	00 00 00 
  802468:	ff d0                	call   *%rax
  80246a:	89 c3                	mov    %eax,%ebx
}
  80246c:	89 d8                	mov    %ebx,%eax
  80246e:	48 83 c4 18          	add    $0x18,%rsp
  802472:	5b                   	pop    %rbx
  802473:	41 5c                	pop    %r12
  802475:	41 5d                	pop    %r13
  802477:	5d                   	pop    %rbp
  802478:	c3                   	ret
        fd_close(fd, 0);
  802479:	be 00 00 00 00       	mov    $0x0,%esi
  80247e:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802482:	48 b8 69 1b 80 00 00 	movabs $0x801b69,%rax
  802489:	00 00 00 
  80248c:	ff d0                	call   *%rax
        return res;
  80248e:	eb dc                	jmp    80246c <open+0x95>
        return -E_BAD_PATH;
  802490:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  802495:	eb d5                	jmp    80246c <open+0x95>

0000000000802497 <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  802497:	f3 0f 1e fa          	endbr64
  80249b:	55                   	push   %rbp
  80249c:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  80249f:	be 00 00 00 00       	mov    $0x0,%esi
  8024a4:	bf 08 00 00 00       	mov    $0x8,%edi
  8024a9:	48 b8 47 21 80 00 00 	movabs $0x802147,%rax
  8024b0:	00 00 00 
  8024b3:	ff d0                	call   *%rax
}
  8024b5:	5d                   	pop    %rbp
  8024b6:	c3                   	ret

00000000008024b7 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  8024b7:	f3 0f 1e fa          	endbr64
  8024bb:	55                   	push   %rbp
  8024bc:	48 89 e5             	mov    %rsp,%rbp
  8024bf:	41 54                	push   %r12
  8024c1:	53                   	push   %rbx
  8024c2:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8024c5:	48 b8 22 1a 80 00 00 	movabs $0x801a22,%rax
  8024cc:	00 00 00 
  8024cf:	ff d0                	call   *%rax
  8024d1:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  8024d4:	48 be 6c 42 80 00 00 	movabs $0x80426c,%rsi
  8024db:	00 00 00 
  8024de:	48 89 df             	mov    %rbx,%rdi
  8024e1:	48 b8 2e 0d 80 00 00 	movabs $0x800d2e,%rax
  8024e8:	00 00 00 
  8024eb:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  8024ed:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  8024f2:	41 2b 04 24          	sub    (%r12),%eax
  8024f6:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  8024fc:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  802503:	00 00 00 
    stat->st_dev = &devpipe;
  802506:	48 b8 60 50 80 00 00 	movabs $0x805060,%rax
  80250d:	00 00 00 
  802510:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  802517:	b8 00 00 00 00       	mov    $0x0,%eax
  80251c:	5b                   	pop    %rbx
  80251d:	41 5c                	pop    %r12
  80251f:	5d                   	pop    %rbp
  802520:	c3                   	ret

0000000000802521 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  802521:	f3 0f 1e fa          	endbr64
  802525:	55                   	push   %rbp
  802526:	48 89 e5             	mov    %rsp,%rbp
  802529:	41 54                	push   %r12
  80252b:	53                   	push   %rbx
  80252c:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  80252f:	ba 00 10 00 00       	mov    $0x1000,%edx
  802534:	48 89 fe             	mov    %rdi,%rsi
  802537:	bf 00 00 00 00       	mov    $0x0,%edi
  80253c:	49 bc 73 14 80 00 00 	movabs $0x801473,%r12
  802543:	00 00 00 
  802546:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  802549:	48 89 df             	mov    %rbx,%rdi
  80254c:	48 b8 22 1a 80 00 00 	movabs $0x801a22,%rax
  802553:	00 00 00 
  802556:	ff d0                	call   *%rax
  802558:	48 89 c6             	mov    %rax,%rsi
  80255b:	ba 00 10 00 00       	mov    $0x1000,%edx
  802560:	bf 00 00 00 00       	mov    $0x0,%edi
  802565:	41 ff d4             	call   *%r12
}
  802568:	5b                   	pop    %rbx
  802569:	41 5c                	pop    %r12
  80256b:	5d                   	pop    %rbp
  80256c:	c3                   	ret

000000000080256d <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  80256d:	f3 0f 1e fa          	endbr64
  802571:	55                   	push   %rbp
  802572:	48 89 e5             	mov    %rsp,%rbp
  802575:	41 57                	push   %r15
  802577:	41 56                	push   %r14
  802579:	41 55                	push   %r13
  80257b:	41 54                	push   %r12
  80257d:	53                   	push   %rbx
  80257e:	48 83 ec 18          	sub    $0x18,%rsp
  802582:	49 89 fc             	mov    %rdi,%r12
  802585:	49 89 f5             	mov    %rsi,%r13
  802588:	49 89 d7             	mov    %rdx,%r15
  80258b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  80258f:	48 b8 22 1a 80 00 00 	movabs $0x801a22,%rax
  802596:	00 00 00 
  802599:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  80259b:	4d 85 ff             	test   %r15,%r15
  80259e:	0f 84 af 00 00 00    	je     802653 <devpipe_write+0xe6>
  8025a4:	48 89 c3             	mov    %rax,%rbx
  8025a7:	4c 89 f8             	mov    %r15,%rax
  8025aa:	4d 89 ef             	mov    %r13,%r15
  8025ad:	4c 01 e8             	add    %r13,%rax
  8025b0:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8025b4:	49 bd 03 13 80 00 00 	movabs $0x801303,%r13
  8025bb:	00 00 00 
            sys_yield();
  8025be:	49 be 98 12 80 00 00 	movabs $0x801298,%r14
  8025c5:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8025c8:	8b 73 04             	mov    0x4(%rbx),%esi
  8025cb:	48 63 ce             	movslq %esi,%rcx
  8025ce:	48 63 03             	movslq (%rbx),%rax
  8025d1:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8025d7:	48 39 c1             	cmp    %rax,%rcx
  8025da:	72 2e                	jb     80260a <devpipe_write+0x9d>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8025dc:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8025e1:	48 89 da             	mov    %rbx,%rdx
  8025e4:	be 00 10 00 00       	mov    $0x1000,%esi
  8025e9:	4c 89 e7             	mov    %r12,%rdi
  8025ec:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8025ef:	85 c0                	test   %eax,%eax
  8025f1:	74 66                	je     802659 <devpipe_write+0xec>
            sys_yield();
  8025f3:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8025f6:	8b 73 04             	mov    0x4(%rbx),%esi
  8025f9:	48 63 ce             	movslq %esi,%rcx
  8025fc:	48 63 03             	movslq (%rbx),%rax
  8025ff:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  802605:	48 39 c1             	cmp    %rax,%rcx
  802608:	73 d2                	jae    8025dc <devpipe_write+0x6f>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80260a:	41 0f b6 3f          	movzbl (%r15),%edi
  80260e:	48 89 ca             	mov    %rcx,%rdx
  802611:	48 c1 ea 03          	shr    $0x3,%rdx
  802615:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  80261c:	08 10 20 
  80261f:	48 f7 e2             	mul    %rdx
  802622:	48 c1 ea 06          	shr    $0x6,%rdx
  802626:	48 89 d0             	mov    %rdx,%rax
  802629:	48 c1 e0 09          	shl    $0x9,%rax
  80262d:	48 29 d0             	sub    %rdx,%rax
  802630:	48 c1 e0 03          	shl    $0x3,%rax
  802634:	48 29 c1             	sub    %rax,%rcx
  802637:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  80263c:	83 c6 01             	add    $0x1,%esi
  80263f:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  802642:	49 83 c7 01          	add    $0x1,%r15
  802646:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80264a:	49 39 c7             	cmp    %rax,%r15
  80264d:	0f 85 75 ff ff ff    	jne    8025c8 <devpipe_write+0x5b>
    return n;
  802653:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802657:	eb 05                	jmp    80265e <devpipe_write+0xf1>
            if (_pipeisclosed(fd, p)) return 0;
  802659:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80265e:	48 83 c4 18          	add    $0x18,%rsp
  802662:	5b                   	pop    %rbx
  802663:	41 5c                	pop    %r12
  802665:	41 5d                	pop    %r13
  802667:	41 5e                	pop    %r14
  802669:	41 5f                	pop    %r15
  80266b:	5d                   	pop    %rbp
  80266c:	c3                   	ret

000000000080266d <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  80266d:	f3 0f 1e fa          	endbr64
  802671:	55                   	push   %rbp
  802672:	48 89 e5             	mov    %rsp,%rbp
  802675:	41 57                	push   %r15
  802677:	41 56                	push   %r14
  802679:	41 55                	push   %r13
  80267b:	41 54                	push   %r12
  80267d:	53                   	push   %rbx
  80267e:	48 83 ec 18          	sub    $0x18,%rsp
  802682:	49 89 fc             	mov    %rdi,%r12
  802685:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  802689:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  80268d:	48 b8 22 1a 80 00 00 	movabs $0x801a22,%rax
  802694:	00 00 00 
  802697:	ff d0                	call   *%rax
  802699:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  80269c:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8026a2:	49 bd 03 13 80 00 00 	movabs $0x801303,%r13
  8026a9:	00 00 00 
            sys_yield();
  8026ac:	49 be 98 12 80 00 00 	movabs $0x801298,%r14
  8026b3:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  8026b6:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8026bb:	74 7d                	je     80273a <devpipe_read+0xcd>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8026bd:	8b 03                	mov    (%rbx),%eax
  8026bf:	3b 43 04             	cmp    0x4(%rbx),%eax
  8026c2:	75 26                	jne    8026ea <devpipe_read+0x7d>
            if (i > 0) return i;
  8026c4:	4d 85 ff             	test   %r15,%r15
  8026c7:	75 77                	jne    802740 <devpipe_read+0xd3>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8026c9:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8026ce:	48 89 da             	mov    %rbx,%rdx
  8026d1:	be 00 10 00 00       	mov    $0x1000,%esi
  8026d6:	4c 89 e7             	mov    %r12,%rdi
  8026d9:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8026dc:	85 c0                	test   %eax,%eax
  8026de:	74 72                	je     802752 <devpipe_read+0xe5>
            sys_yield();
  8026e0:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8026e3:	8b 03                	mov    (%rbx),%eax
  8026e5:	3b 43 04             	cmp    0x4(%rbx),%eax
  8026e8:	74 df                	je     8026c9 <devpipe_read+0x5c>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8026ea:	48 63 c8             	movslq %eax,%rcx
  8026ed:	48 89 ca             	mov    %rcx,%rdx
  8026f0:	48 c1 ea 03          	shr    $0x3,%rdx
  8026f4:	48 be 81 00 01 02 04 	movabs $0x2010080402010081,%rsi
  8026fb:	08 10 20 
  8026fe:	48 89 d0             	mov    %rdx,%rax
  802701:	48 f7 e6             	mul    %rsi
  802704:	48 c1 ea 06          	shr    $0x6,%rdx
  802708:	48 89 d0             	mov    %rdx,%rax
  80270b:	48 c1 e0 09          	shl    $0x9,%rax
  80270f:	48 29 d0             	sub    %rdx,%rax
  802712:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802719:	00 
  80271a:	48 89 c8             	mov    %rcx,%rax
  80271d:	48 29 d0             	sub    %rdx,%rax
  802720:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  802725:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  802729:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  80272d:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  802730:	49 83 c7 01          	add    $0x1,%r15
  802734:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  802738:	75 83                	jne    8026bd <devpipe_read+0x50>
    return n;
  80273a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80273e:	eb 03                	jmp    802743 <devpipe_read+0xd6>
            if (i > 0) return i;
  802740:	4c 89 f8             	mov    %r15,%rax
}
  802743:	48 83 c4 18          	add    $0x18,%rsp
  802747:	5b                   	pop    %rbx
  802748:	41 5c                	pop    %r12
  80274a:	41 5d                	pop    %r13
  80274c:	41 5e                	pop    %r14
  80274e:	41 5f                	pop    %r15
  802750:	5d                   	pop    %rbp
  802751:	c3                   	ret
            if (_pipeisclosed(fd, p)) return 0;
  802752:	b8 00 00 00 00       	mov    $0x0,%eax
  802757:	eb ea                	jmp    802743 <devpipe_read+0xd6>

0000000000802759 <pipe>:
pipe(int pfd[2]) {
  802759:	f3 0f 1e fa          	endbr64
  80275d:	55                   	push   %rbp
  80275e:	48 89 e5             	mov    %rsp,%rbp
  802761:	41 55                	push   %r13
  802763:	41 54                	push   %r12
  802765:	53                   	push   %rbx
  802766:	48 83 ec 18          	sub    $0x18,%rsp
  80276a:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  80276d:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802771:	48 b8 42 1a 80 00 00 	movabs $0x801a42,%rax
  802778:	00 00 00 
  80277b:	ff d0                	call   *%rax
  80277d:	89 c3                	mov    %eax,%ebx
  80277f:	85 c0                	test   %eax,%eax
  802781:	0f 88 a0 01 00 00    	js     802927 <pipe+0x1ce>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  802787:	b9 46 00 00 00       	mov    $0x46,%ecx
  80278c:	ba 00 10 00 00       	mov    $0x1000,%edx
  802791:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802795:	bf 00 00 00 00       	mov    $0x0,%edi
  80279a:	48 b8 33 13 80 00 00 	movabs $0x801333,%rax
  8027a1:	00 00 00 
  8027a4:	ff d0                	call   *%rax
  8027a6:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  8027a8:	85 c0                	test   %eax,%eax
  8027aa:	0f 88 77 01 00 00    	js     802927 <pipe+0x1ce>
    if ((res = fd_alloc(&fd1)) < 0 ||
  8027b0:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  8027b4:	48 b8 42 1a 80 00 00 	movabs $0x801a42,%rax
  8027bb:	00 00 00 
  8027be:	ff d0                	call   *%rax
  8027c0:	89 c3                	mov    %eax,%ebx
  8027c2:	85 c0                	test   %eax,%eax
  8027c4:	0f 88 43 01 00 00    	js     80290d <pipe+0x1b4>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  8027ca:	b9 46 00 00 00       	mov    $0x46,%ecx
  8027cf:	ba 00 10 00 00       	mov    $0x1000,%edx
  8027d4:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8027d8:	bf 00 00 00 00       	mov    $0x0,%edi
  8027dd:	48 b8 33 13 80 00 00 	movabs $0x801333,%rax
  8027e4:	00 00 00 
  8027e7:	ff d0                	call   *%rax
  8027e9:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  8027eb:	85 c0                	test   %eax,%eax
  8027ed:	0f 88 1a 01 00 00    	js     80290d <pipe+0x1b4>
    va = fd2data(fd0);
  8027f3:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8027f7:	48 b8 22 1a 80 00 00 	movabs $0x801a22,%rax
  8027fe:	00 00 00 
  802801:	ff d0                	call   *%rax
  802803:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  802806:	b9 46 00 00 00       	mov    $0x46,%ecx
  80280b:	ba 00 10 00 00       	mov    $0x1000,%edx
  802810:	48 89 c6             	mov    %rax,%rsi
  802813:	bf 00 00 00 00       	mov    $0x0,%edi
  802818:	48 b8 33 13 80 00 00 	movabs $0x801333,%rax
  80281f:	00 00 00 
  802822:	ff d0                	call   *%rax
  802824:	89 c3                	mov    %eax,%ebx
  802826:	85 c0                	test   %eax,%eax
  802828:	0f 88 c5 00 00 00    	js     8028f3 <pipe+0x19a>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  80282e:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802832:	48 b8 22 1a 80 00 00 	movabs $0x801a22,%rax
  802839:	00 00 00 
  80283c:	ff d0                	call   *%rax
  80283e:	48 89 c1             	mov    %rax,%rcx
  802841:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  802847:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  80284d:	ba 00 00 00 00       	mov    $0x0,%edx
  802852:	4c 89 ee             	mov    %r13,%rsi
  802855:	bf 00 00 00 00       	mov    $0x0,%edi
  80285a:	48 b8 9e 13 80 00 00 	movabs $0x80139e,%rax
  802861:	00 00 00 
  802864:	ff d0                	call   *%rax
  802866:	89 c3                	mov    %eax,%ebx
  802868:	85 c0                	test   %eax,%eax
  80286a:	78 6e                	js     8028da <pipe+0x181>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  80286c:	be 00 10 00 00       	mov    $0x1000,%esi
  802871:	4c 89 ef             	mov    %r13,%rdi
  802874:	48 b8 cd 12 80 00 00 	movabs $0x8012cd,%rax
  80287b:	00 00 00 
  80287e:	ff d0                	call   *%rax
  802880:	83 f8 02             	cmp    $0x2,%eax
  802883:	0f 85 ab 00 00 00    	jne    802934 <pipe+0x1db>
    fd0->fd_dev_id = devpipe.dev_id;
  802889:	a1 60 50 80 00 00 00 	movabs 0x805060,%eax
  802890:	00 00 
  802892:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802896:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  802898:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80289c:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  8028a3:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8028a7:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  8028a9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8028ad:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  8028b4:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8028b8:	48 bb 0c 1a 80 00 00 	movabs $0x801a0c,%rbx
  8028bf:	00 00 00 
  8028c2:	ff d3                	call   *%rbx
  8028c4:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  8028c8:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8028cc:	ff d3                	call   *%rbx
  8028ce:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  8028d3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8028d8:	eb 4d                	jmp    802927 <pipe+0x1ce>
    sys_unmap_region(0, va, PAGE_SIZE);
  8028da:	ba 00 10 00 00       	mov    $0x1000,%edx
  8028df:	4c 89 ee             	mov    %r13,%rsi
  8028e2:	bf 00 00 00 00       	mov    $0x0,%edi
  8028e7:	48 b8 73 14 80 00 00 	movabs $0x801473,%rax
  8028ee:	00 00 00 
  8028f1:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  8028f3:	ba 00 10 00 00       	mov    $0x1000,%edx
  8028f8:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8028fc:	bf 00 00 00 00       	mov    $0x0,%edi
  802901:	48 b8 73 14 80 00 00 	movabs $0x801473,%rax
  802908:	00 00 00 
  80290b:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  80290d:	ba 00 10 00 00       	mov    $0x1000,%edx
  802912:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802916:	bf 00 00 00 00       	mov    $0x0,%edi
  80291b:	48 b8 73 14 80 00 00 	movabs $0x801473,%rax
  802922:	00 00 00 
  802925:	ff d0                	call   *%rax
}
  802927:	89 d8                	mov    %ebx,%eax
  802929:	48 83 c4 18          	add    $0x18,%rsp
  80292d:	5b                   	pop    %rbx
  80292e:	41 5c                	pop    %r12
  802930:	41 5d                	pop    %r13
  802932:	5d                   	pop    %rbp
  802933:	c3                   	ret
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802934:	48 b9 f0 43 80 00 00 	movabs $0x8043f0,%rcx
  80293b:	00 00 00 
  80293e:	48 ba 4c 42 80 00 00 	movabs $0x80424c,%rdx
  802945:	00 00 00 
  802948:	be 2e 00 00 00       	mov    $0x2e,%esi
  80294d:	48 bf 73 42 80 00 00 	movabs $0x804273,%rdi
  802954:	00 00 00 
  802957:	b8 00 00 00 00       	mov    $0x0,%eax
  80295c:	49 b8 73 2f 80 00 00 	movabs $0x802f73,%r8
  802963:	00 00 00 
  802966:	41 ff d0             	call   *%r8

0000000000802969 <pipeisclosed>:
pipeisclosed(int fdnum) {
  802969:	f3 0f 1e fa          	endbr64
  80296d:	55                   	push   %rbp
  80296e:	48 89 e5             	mov    %rsp,%rbp
  802971:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802975:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802979:	48 b8 a6 1a 80 00 00 	movabs $0x801aa6,%rax
  802980:	00 00 00 
  802983:	ff d0                	call   *%rax
    if (res < 0) return res;
  802985:	85 c0                	test   %eax,%eax
  802987:	78 35                	js     8029be <pipeisclosed+0x55>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  802989:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80298d:	48 b8 22 1a 80 00 00 	movabs $0x801a22,%rax
  802994:	00 00 00 
  802997:	ff d0                	call   *%rax
  802999:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80299c:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8029a1:	be 00 10 00 00       	mov    $0x1000,%esi
  8029a6:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8029aa:	48 b8 03 13 80 00 00 	movabs $0x801303,%rax
  8029b1:	00 00 00 
  8029b4:	ff d0                	call   *%rax
  8029b6:	85 c0                	test   %eax,%eax
  8029b8:	0f 94 c0             	sete   %al
  8029bb:	0f b6 c0             	movzbl %al,%eax
}
  8029be:	c9                   	leave
  8029bf:	c3                   	ret

00000000008029c0 <get_uvpt_entry>:
extern volatile pde_t uvpd[];     /* VA of current page directory */
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
  8029c0:	f3 0f 1e fa          	endbr64
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8029c4:	48 89 f8             	mov    %rdi,%rax
  8029c7:	48 c1 e8 27          	shr    $0x27,%rax
  8029cb:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  8029d2:	7f 00 00 
  8029d5:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8029d9:	f6 c2 01             	test   $0x1,%dl
  8029dc:	74 6d                	je     802a4b <get_uvpt_entry+0x8b>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8029de:	48 89 f8             	mov    %rdi,%rax
  8029e1:	48 c1 e8 1e          	shr    $0x1e,%rax
  8029e5:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  8029ec:	7f 00 00 
  8029ef:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8029f3:	f6 c2 01             	test   $0x1,%dl
  8029f6:	74 62                	je     802a5a <get_uvpt_entry+0x9a>
  8029f8:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  8029ff:	7f 00 00 
  802a02:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802a06:	f6 c2 80             	test   $0x80,%dl
  802a09:	75 4f                	jne    802a5a <get_uvpt_entry+0x9a>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802a0b:	48 89 f8             	mov    %rdi,%rax
  802a0e:	48 c1 e8 15          	shr    $0x15,%rax
  802a12:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802a19:	7f 00 00 
  802a1c:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802a20:	f6 c2 01             	test   $0x1,%dl
  802a23:	74 44                	je     802a69 <get_uvpt_entry+0xa9>
  802a25:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802a2c:	7f 00 00 
  802a2f:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802a33:	f6 c2 80             	test   $0x80,%dl
  802a36:	75 31                	jne    802a69 <get_uvpt_entry+0xa9>
    return uvpt[VPT(va)];
  802a38:	48 c1 ef 0c          	shr    $0xc,%rdi
  802a3c:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802a43:	7f 00 00 
  802a46:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  802a4a:	c3                   	ret
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802a4b:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  802a52:	7f 00 00 
  802a55:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802a59:	c3                   	ret
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  802a5a:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  802a61:	7f 00 00 
  802a64:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802a68:	c3                   	ret
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802a69:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802a70:	7f 00 00 
  802a73:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802a77:	c3                   	ret

0000000000802a78 <get_phys_addr>:

uintptr_t
get_phys_addr(void *va) {
  802a78:	f3 0f 1e fa          	endbr64
  802a7c:	48 89 fa             	mov    %rdi,%rdx
    if (!(uvpml4[VPML4(va)] & PTE_P))
  802a7f:	48 89 f9             	mov    %rdi,%rcx
  802a82:	48 c1 e9 27          	shr    $0x27,%rcx
  802a86:	48 b8 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rax
  802a8d:	7f 00 00 
  802a90:	48 8b 0c c8          	mov    (%rax,%rcx,8),%rcx
        return -1;
  802a94:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpml4[VPML4(va)] & PTE_P))
  802a9b:	f6 c1 01             	test   $0x1,%cl
  802a9e:	0f 84 b2 00 00 00    	je     802b56 <get_phys_addr+0xde>
    if (!(uvpdp[VPDP(va)] & PTE_P))
  802aa4:	48 89 f9             	mov    %rdi,%rcx
  802aa7:	48 c1 e9 1e          	shr    $0x1e,%rcx
  802aab:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802ab2:	7f 00 00 
  802ab5:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  802ab9:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpdp[VPDP(va)] & PTE_P))
  802ac0:	40 f6 c6 01          	test   $0x1,%sil
  802ac4:	0f 84 8c 00 00 00    	je     802b56 <get_phys_addr+0xde>
    if (uvpdp[VPDP(va)] & PTE_PS)
  802aca:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802ad1:	7f 00 00 
  802ad4:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802ad8:	a8 80                	test   $0x80,%al
  802ada:	75 7b                	jne    802b57 <get_phys_addr+0xdf>
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
    if (!(uvpd[VPD(va)] & PTE_P))
  802adc:	48 89 f9             	mov    %rdi,%rcx
  802adf:	48 c1 e9 15          	shr    $0x15,%rcx
  802ae3:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  802aea:	7f 00 00 
  802aed:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  802af1:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpd[VPD(va)] & PTE_P))
  802af8:	40 f6 c6 01          	test   $0x1,%sil
  802afc:	74 58                	je     802b56 <get_phys_addr+0xde>
    if ((uvpd[VPD(va)] & PTE_PS))
  802afe:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  802b05:	7f 00 00 
  802b08:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802b0c:	a8 80                	test   $0x80,%al
  802b0e:	75 6c                	jne    802b7c <get_phys_addr+0x104>
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
    if (!(uvpt[VPT(va)] & PTE_P))
  802b10:	48 89 f9             	mov    %rdi,%rcx
  802b13:	48 c1 e9 0c          	shr    $0xc,%rcx
  802b17:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802b1e:	7f 00 00 
  802b21:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  802b25:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpt[VPT(va)] & PTE_P))
  802b2c:	40 f6 c6 01          	test   $0x1,%sil
  802b30:	74 24                	je     802b56 <get_phys_addr+0xde>
    return PTE_ADDR(uvpt[VPT(va)]) + PAGE_OFFSET(va);
  802b32:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802b39:	7f 00 00 
  802b3c:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802b40:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802b47:	ff ff 7f 
  802b4a:	48 21 c8             	and    %rcx,%rax
  802b4d:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  802b53:	48 09 d0             	or     %rdx,%rax
}
  802b56:	c3                   	ret
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
  802b57:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802b5e:	7f 00 00 
  802b61:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802b65:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802b6c:	ff ff 7f 
  802b6f:	48 21 c8             	and    %rcx,%rax
  802b72:	81 e2 ff ff ff 3f    	and    $0x3fffffff,%edx
  802b78:	48 01 d0             	add    %rdx,%rax
  802b7b:	c3                   	ret
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
  802b7c:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  802b83:	7f 00 00 
  802b86:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802b8a:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802b91:	ff ff 7f 
  802b94:	48 21 c8             	and    %rcx,%rax
  802b97:	81 e2 ff ff 1f 00    	and    $0x1fffff,%edx
  802b9d:	48 01 d0             	add    %rdx,%rax
  802ba0:	c3                   	ret

0000000000802ba1 <get_prot>:

int
get_prot(void *va) {
  802ba1:	f3 0f 1e fa          	endbr64
  802ba5:	55                   	push   %rbp
  802ba6:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802ba9:	48 b8 c0 29 80 00 00 	movabs $0x8029c0,%rax
  802bb0:	00 00 00 
  802bb3:	ff d0                	call   *%rax
  802bb5:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
    if (pte & PTE_P) prot |= PROT_R;
  802bb8:	83 e0 01             	and    $0x1,%eax
  802bbb:	c1 e0 02             	shl    $0x2,%eax
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  802bbe:	89 d1                	mov    %edx,%ecx
  802bc0:	81 e1 00 0a 00 00    	and    $0xa00,%ecx
    if (pte & PTE_P) prot |= PROT_R;
  802bc6:	09 c8                	or     %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  802bc8:	89 c1                	mov    %eax,%ecx
  802bca:	83 c9 02             	or     $0x2,%ecx
  802bcd:	f6 c2 02             	test   $0x2,%dl
  802bd0:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  802bd3:	89 c1                	mov    %eax,%ecx
  802bd5:	83 c9 01             	or     $0x1,%ecx
  802bd8:	48 85 d2             	test   %rdx,%rdx
  802bdb:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  802bde:	89 c1                	mov    %eax,%ecx
  802be0:	83 c9 40             	or     $0x40,%ecx
  802be3:	f6 c6 04             	test   $0x4,%dh
  802be6:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  802be9:	5d                   	pop    %rbp
  802bea:	c3                   	ret

0000000000802beb <is_page_dirty>:

bool
is_page_dirty(void *va) {
  802beb:	f3 0f 1e fa          	endbr64
  802bef:	55                   	push   %rbp
  802bf0:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802bf3:	48 b8 c0 29 80 00 00 	movabs $0x8029c0,%rax
  802bfa:	00 00 00 
  802bfd:	ff d0                	call   *%rax
    return pte & PTE_D;
  802bff:	48 c1 e8 06          	shr    $0x6,%rax
  802c03:	83 e0 01             	and    $0x1,%eax
}
  802c06:	5d                   	pop    %rbp
  802c07:	c3                   	ret

0000000000802c08 <is_page_present>:

bool
is_page_present(void *va) {
  802c08:	f3 0f 1e fa          	endbr64
  802c0c:	55                   	push   %rbp
  802c0d:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  802c10:	48 b8 c0 29 80 00 00 	movabs $0x8029c0,%rax
  802c17:	00 00 00 
  802c1a:	ff d0                	call   *%rax
  802c1c:	83 e0 01             	and    $0x1,%eax
}
  802c1f:	5d                   	pop    %rbp
  802c20:	c3                   	ret

0000000000802c21 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  802c21:	f3 0f 1e fa          	endbr64
  802c25:	55                   	push   %rbp
  802c26:	48 89 e5             	mov    %rsp,%rbp
  802c29:	41 57                	push   %r15
  802c2b:	41 56                	push   %r14
  802c2d:	41 55                	push   %r13
  802c2f:	41 54                	push   %r12
  802c31:	53                   	push   %rbx
  802c32:	48 83 ec 18          	sub    $0x18,%rsp
  802c36:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  802c3a:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
     * NOTE: Skip over larger pages/page directories for efficiency */
    // LAB 11: Your code here:

    int res = 0;
    (void)fun, (void)arg;
    uintptr_t va = 0;
  802c3e:	bb 00 00 00 00       	mov    $0x0,%ebx
    while (va < USER_STACK_TOP) {
        size_t size = 0;
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  802c43:	49 be 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%r14
  802c4a:	7f 00 00 
            size = 1LL << PML4_SHIFT;
            goto next;
        }

        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802c4d:	49 bd 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%r13
  802c54:	7f 00 00 
    while (va < USER_STACK_TOP) {
  802c57:	49 bf ff 6f ff ff 7f 	movabs $0x7fffff6fff,%r15
  802c5e:	00 00 00 
  802c61:	eb 73                	jmp    802cd6 <foreach_shared_region+0xb5>
            }

            goto next;
        }

        if (!(uvpd[VPD(va)] & PTE_P)) {
  802c63:	48 89 d8             	mov    %rbx,%rax
  802c66:	48 c1 e8 15          	shr    $0x15,%rax
  802c6a:	48 b9 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rcx
  802c71:	7f 00 00 
  802c74:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
            size = 1LL << PD_SHIFT;
  802c78:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
        if (!(uvpd[VPD(va)] & PTE_P)) {
  802c7e:	f6 c2 01             	test   $0x1,%dl
  802c81:	74 4b                	je     802cce <foreach_shared_region+0xad>
            goto next;
        }

        if (uvpd[VPD(va)] & PTE_PS) {
  802c83:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
  802c87:	f6 c2 80             	test   $0x80,%dl
  802c8a:	74 11                	je     802c9d <foreach_shared_region+0x7c>
            size = 1LL << PD_SHIFT;
            if (uvpd[VPD(va)] & PTE_SHARE) {
  802c8c:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
  802c90:	f6 c4 04             	test   $0x4,%ah
  802c93:	74 39                	je     802cce <foreach_shared_region+0xad>
            size = 1LL << PD_SHIFT;
  802c95:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
  802c9b:	eb 20                	jmp    802cbd <foreach_shared_region+0x9c>

            goto next;
        }

        size = PAGE_SIZE;
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  802c9d:	48 89 da             	mov    %rbx,%rdx
  802ca0:	48 c1 ea 0c          	shr    $0xc,%rdx
  802ca4:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802cab:	7f 00 00 
  802cae:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
        size = PAGE_SIZE;
  802cb2:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  802cb8:	f6 c4 04             	test   $0x4,%ah
  802cbb:	74 11                	je     802cce <foreach_shared_region+0xad>
            goto next;
        }

    map:
        fun((void *)va, (void *)(va + size), arg);
  802cbd:	49 8d 34 1c          	lea    (%r12,%rbx,1),%rsi
  802cc1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802cc5:	48 89 df             	mov    %rbx,%rdi
  802cc8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802ccc:	ff d0                	call   *%rax
    next:
        va += size;
  802cce:	4c 01 e3             	add    %r12,%rbx
    while (va < USER_STACK_TOP) {
  802cd1:	49 39 df             	cmp    %rbx,%r15
  802cd4:	72 3e                	jb     802d14 <foreach_shared_region+0xf3>
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  802cd6:	49 8b 06             	mov    (%r14),%rax
  802cd9:	a8 01                	test   $0x1,%al
  802cdb:	74 37                	je     802d14 <foreach_shared_region+0xf3>
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802cdd:	48 89 d8             	mov    %rbx,%rax
  802ce0:	48 c1 e8 1e          	shr    $0x1e,%rax
  802ce4:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
            size = 1LL << PDP_SHIFT;
  802ce9:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802cef:	f6 c2 01             	test   $0x1,%dl
  802cf2:	74 da                	je     802cce <foreach_shared_region+0xad>
        if (uvpdp[VPDP(va)] & PTE_PS) {
  802cf4:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
  802cf9:	f6 c2 80             	test   $0x80,%dl
  802cfc:	0f 84 61 ff ff ff    	je     802c63 <foreach_shared_region+0x42>
            if (uvpdp[VPDP(va)] & PTE_SHARE) {
  802d02:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  802d07:	f6 c4 04             	test   $0x4,%ah
  802d0a:	74 c2                	je     802cce <foreach_shared_region+0xad>
            size = 1LL << PDP_SHIFT;
  802d0c:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
  802d12:	eb a9                	jmp    802cbd <foreach_shared_region+0x9c>
    }
    return res;
}
  802d14:	b8 00 00 00 00       	mov    $0x0,%eax
  802d19:	48 83 c4 18          	add    $0x18,%rsp
  802d1d:	5b                   	pop    %rbx
  802d1e:	41 5c                	pop    %r12
  802d20:	41 5d                	pop    %r13
  802d22:	41 5e                	pop    %r14
  802d24:	41 5f                	pop    %r15
  802d26:	5d                   	pop    %rbp
  802d27:	c3                   	ret

0000000000802d28 <devcons_close>:

    return res;
}

static int
devcons_close(struct Fd *fd) {
  802d28:	f3 0f 1e fa          	endbr64
    USED(fd);

    return 0;
}
  802d2c:	b8 00 00 00 00       	mov    $0x0,%eax
  802d31:	c3                   	ret

0000000000802d32 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  802d32:	f3 0f 1e fa          	endbr64
  802d36:	55                   	push   %rbp
  802d37:	48 89 e5             	mov    %rsp,%rbp
  802d3a:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  802d3d:	48 be 83 42 80 00 00 	movabs $0x804283,%rsi
  802d44:	00 00 00 
  802d47:	48 b8 2e 0d 80 00 00 	movabs $0x800d2e,%rax
  802d4e:	00 00 00 
  802d51:	ff d0                	call   *%rax
    return 0;
}
  802d53:	b8 00 00 00 00       	mov    $0x0,%eax
  802d58:	5d                   	pop    %rbp
  802d59:	c3                   	ret

0000000000802d5a <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  802d5a:	f3 0f 1e fa          	endbr64
  802d5e:	55                   	push   %rbp
  802d5f:	48 89 e5             	mov    %rsp,%rbp
  802d62:	41 57                	push   %r15
  802d64:	41 56                	push   %r14
  802d66:	41 55                	push   %r13
  802d68:	41 54                	push   %r12
  802d6a:	53                   	push   %rbx
  802d6b:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  802d72:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  802d79:	48 85 d2             	test   %rdx,%rdx
  802d7c:	74 7a                	je     802df8 <devcons_write+0x9e>
  802d7e:	49 89 d6             	mov    %rdx,%r14
  802d81:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802d87:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  802d8c:	49 bf 49 0f 80 00 00 	movabs $0x800f49,%r15
  802d93:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  802d96:	4c 89 f3             	mov    %r14,%rbx
  802d99:	48 29 f3             	sub    %rsi,%rbx
  802d9c:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802da1:	48 39 c3             	cmp    %rax,%rbx
  802da4:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  802da8:	4c 63 eb             	movslq %ebx,%r13
  802dab:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  802db2:	48 01 c6             	add    %rax,%rsi
  802db5:	4c 89 ea             	mov    %r13,%rdx
  802db8:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802dbf:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  802dc2:	4c 89 ee             	mov    %r13,%rsi
  802dc5:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802dcc:	48 b8 8e 11 80 00 00 	movabs $0x80118e,%rax
  802dd3:	00 00 00 
  802dd6:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  802dd8:	41 01 dc             	add    %ebx,%r12d
  802ddb:	49 63 f4             	movslq %r12d,%rsi
  802dde:	4c 39 f6             	cmp    %r14,%rsi
  802de1:	72 b3                	jb     802d96 <devcons_write+0x3c>
    return res;
  802de3:	49 63 c4             	movslq %r12d,%rax
}
  802de6:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  802ded:	5b                   	pop    %rbx
  802dee:	41 5c                	pop    %r12
  802df0:	41 5d                	pop    %r13
  802df2:	41 5e                	pop    %r14
  802df4:	41 5f                	pop    %r15
  802df6:	5d                   	pop    %rbp
  802df7:	c3                   	ret
    for (res = 0; res < n; res += inc) {
  802df8:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802dfe:	eb e3                	jmp    802de3 <devcons_write+0x89>

0000000000802e00 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802e00:	f3 0f 1e fa          	endbr64
  802e04:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  802e07:	ba 00 00 00 00       	mov    $0x0,%edx
  802e0c:	48 85 c0             	test   %rax,%rax
  802e0f:	74 55                	je     802e66 <devcons_read+0x66>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802e11:	55                   	push   %rbp
  802e12:	48 89 e5             	mov    %rsp,%rbp
  802e15:	41 55                	push   %r13
  802e17:	41 54                	push   %r12
  802e19:	53                   	push   %rbx
  802e1a:	48 83 ec 08          	sub    $0x8,%rsp
  802e1e:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  802e21:	48 bb bf 11 80 00 00 	movabs $0x8011bf,%rbx
  802e28:	00 00 00 
  802e2b:	49 bc 98 12 80 00 00 	movabs $0x801298,%r12
  802e32:	00 00 00 
  802e35:	eb 03                	jmp    802e3a <devcons_read+0x3a>
  802e37:	41 ff d4             	call   *%r12
  802e3a:	ff d3                	call   *%rbx
  802e3c:	85 c0                	test   %eax,%eax
  802e3e:	74 f7                	je     802e37 <devcons_read+0x37>
    if (c < 0) return c;
  802e40:	48 63 d0             	movslq %eax,%rdx
  802e43:	78 13                	js     802e58 <devcons_read+0x58>
    if (c == 0x04) return 0;
  802e45:	ba 00 00 00 00       	mov    $0x0,%edx
  802e4a:	83 f8 04             	cmp    $0x4,%eax
  802e4d:	74 09                	je     802e58 <devcons_read+0x58>
    *(char *)vbuf = (char)c;
  802e4f:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  802e53:	ba 01 00 00 00       	mov    $0x1,%edx
}
  802e58:	48 89 d0             	mov    %rdx,%rax
  802e5b:	48 83 c4 08          	add    $0x8,%rsp
  802e5f:	5b                   	pop    %rbx
  802e60:	41 5c                	pop    %r12
  802e62:	41 5d                	pop    %r13
  802e64:	5d                   	pop    %rbp
  802e65:	c3                   	ret
  802e66:	48 89 d0             	mov    %rdx,%rax
  802e69:	c3                   	ret

0000000000802e6a <cputchar>:
cputchar(int ch) {
  802e6a:	f3 0f 1e fa          	endbr64
  802e6e:	55                   	push   %rbp
  802e6f:	48 89 e5             	mov    %rsp,%rbp
  802e72:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  802e76:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  802e7a:	be 01 00 00 00       	mov    $0x1,%esi
  802e7f:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  802e83:	48 b8 8e 11 80 00 00 	movabs $0x80118e,%rax
  802e8a:	00 00 00 
  802e8d:	ff d0                	call   *%rax
}
  802e8f:	c9                   	leave
  802e90:	c3                   	ret

0000000000802e91 <getchar>:
getchar(void) {
  802e91:	f3 0f 1e fa          	endbr64
  802e95:	55                   	push   %rbp
  802e96:	48 89 e5             	mov    %rsp,%rbp
  802e99:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  802e9d:	ba 01 00 00 00       	mov    $0x1,%edx
  802ea2:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  802ea6:	bf 00 00 00 00       	mov    $0x0,%edi
  802eab:	48 b8 a1 1d 80 00 00 	movabs $0x801da1,%rax
  802eb2:	00 00 00 
  802eb5:	ff d0                	call   *%rax
  802eb7:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  802eb9:	85 c0                	test   %eax,%eax
  802ebb:	78 06                	js     802ec3 <getchar+0x32>
  802ebd:	74 08                	je     802ec7 <getchar+0x36>
  802ebf:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  802ec3:	89 d0                	mov    %edx,%eax
  802ec5:	c9                   	leave
  802ec6:	c3                   	ret
    return res < 0 ? res : res ? c :
  802ec7:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  802ecc:	eb f5                	jmp    802ec3 <getchar+0x32>

0000000000802ece <iscons>:
iscons(int fdnum) {
  802ece:	f3 0f 1e fa          	endbr64
  802ed2:	55                   	push   %rbp
  802ed3:	48 89 e5             	mov    %rsp,%rbp
  802ed6:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802eda:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802ede:	48 b8 a6 1a 80 00 00 	movabs $0x801aa6,%rax
  802ee5:	00 00 00 
  802ee8:	ff d0                	call   *%rax
    if (res < 0) return res;
  802eea:	85 c0                	test   %eax,%eax
  802eec:	78 18                	js     802f06 <iscons+0x38>
    return fd->fd_dev_id == devcons.dev_id;
  802eee:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802ef2:	48 b8 a0 50 80 00 00 	movabs $0x8050a0,%rax
  802ef9:	00 00 00 
  802efc:	8b 00                	mov    (%rax),%eax
  802efe:	39 02                	cmp    %eax,(%rdx)
  802f00:	0f 94 c0             	sete   %al
  802f03:	0f b6 c0             	movzbl %al,%eax
}
  802f06:	c9                   	leave
  802f07:	c3                   	ret

0000000000802f08 <opencons>:
opencons(void) {
  802f08:	f3 0f 1e fa          	endbr64
  802f0c:	55                   	push   %rbp
  802f0d:	48 89 e5             	mov    %rsp,%rbp
  802f10:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  802f14:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  802f18:	48 b8 42 1a 80 00 00 	movabs $0x801a42,%rax
  802f1f:	00 00 00 
  802f22:	ff d0                	call   *%rax
  802f24:	85 c0                	test   %eax,%eax
  802f26:	78 49                	js     802f71 <opencons+0x69>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  802f28:	b9 46 00 00 00       	mov    $0x46,%ecx
  802f2d:	ba 00 10 00 00       	mov    $0x1000,%edx
  802f32:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  802f36:	bf 00 00 00 00       	mov    $0x0,%edi
  802f3b:	48 b8 33 13 80 00 00 	movabs $0x801333,%rax
  802f42:	00 00 00 
  802f45:	ff d0                	call   *%rax
  802f47:	85 c0                	test   %eax,%eax
  802f49:	78 26                	js     802f71 <opencons+0x69>
    fd->fd_dev_id = devcons.dev_id;
  802f4b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f4f:	a1 a0 50 80 00 00 00 	movabs 0x8050a0,%eax
  802f56:	00 00 
  802f58:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  802f5a:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802f5e:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  802f65:	48 b8 0c 1a 80 00 00 	movabs $0x801a0c,%rax
  802f6c:	00 00 00 
  802f6f:	ff d0                	call   *%rax
}
  802f71:	c9                   	leave
  802f72:	c3                   	ret

0000000000802f73 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  802f73:	f3 0f 1e fa          	endbr64
  802f77:	55                   	push   %rbp
  802f78:	48 89 e5             	mov    %rsp,%rbp
  802f7b:	41 56                	push   %r14
  802f7d:	41 55                	push   %r13
  802f7f:	41 54                	push   %r12
  802f81:	53                   	push   %rbx
  802f82:	48 83 ec 50          	sub    $0x50,%rsp
  802f86:	49 89 fc             	mov    %rdi,%r12
  802f89:	41 89 f5             	mov    %esi,%r13d
  802f8c:	48 89 d3             	mov    %rdx,%rbx
  802f8f:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  802f93:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  802f97:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  802f9b:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  802fa2:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802fa6:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  802faa:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  802fae:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  802fb2:	48 b8 10 50 80 00 00 	movabs $0x805010,%rax
  802fb9:	00 00 00 
  802fbc:	4c 8b 30             	mov    (%rax),%r14
  802fbf:	48 b8 63 12 80 00 00 	movabs $0x801263,%rax
  802fc6:	00 00 00 
  802fc9:	ff d0                	call   *%rax
  802fcb:	89 c6                	mov    %eax,%esi
  802fcd:	45 89 e8             	mov    %r13d,%r8d
  802fd0:	4c 89 e1             	mov    %r12,%rcx
  802fd3:	4c 89 f2             	mov    %r14,%rdx
  802fd6:	48 bf 18 44 80 00 00 	movabs $0x804418,%rdi
  802fdd:	00 00 00 
  802fe0:	b8 00 00 00 00       	mov    $0x0,%eax
  802fe5:	49 bc e5 03 80 00 00 	movabs $0x8003e5,%r12
  802fec:	00 00 00 
  802fef:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  802ff2:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  802ff6:	48 89 df             	mov    %rbx,%rdi
  802ff9:	48 b8 7d 03 80 00 00 	movabs $0x80037d,%rax
  803000:	00 00 00 
  803003:	ff d0                	call   *%rax
    cprintf("\n");
  803005:	48 bf 10 42 80 00 00 	movabs $0x804210,%rdi
  80300c:	00 00 00 
  80300f:	b8 00 00 00 00       	mov    $0x0,%eax
  803014:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  803017:	cc                   	int3
  803018:	eb fd                	jmp    803017 <_panic+0xa4>

000000000080301a <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
    # Call the C page fault handler.
    movq  %rsp,%rdi # passing the function argument in rdi
  80301a:	48 89 e7             	mov    %rsp,%rdi
    movabs $_handle_vectored_pagefault, %rax
  80301d:	48 b8 a0 30 80 00 00 	movabs $0x8030a0,%rax
  803024:	00 00 00 
    call *%rax
  803027:	ff d0                	call   *%rax
    # registers are available for intermediate calculations.  You
    # may find that you have to rearrange your code in non-obvious
    # ways as registers become unavailable as scratch space.

    # LAB 9: Your code here
    movq %rsp, %rax
  803029:	48 89 e0             	mov    %rsp,%rax
    movq UTRAP_RIP(%rsp), %rbx
  80302c:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  803033:	00 
    movq UTRAP_RSP(%rsp), %rsp
  803034:	48 8b a4 24 98 00 00 	mov    0x98(%rsp),%rsp
  80303b:	00 
    pushq %rbx
  80303c:	53                   	push   %rbx
    movq %rsp, UTRAP_RSP(%rax)
  80303d:	48 89 a0 98 00 00 00 	mov    %rsp,0x98(%rax)

    # Restore the trap-time registers.  After you do this, you
    # can no longer modify any general-purpose registers (use POPA macro).
    # LAB 9: Your code here
    movq %rax, %rsp
  803044:	48 89 c4             	mov    %rax,%rsp
    addq $16, %rsp
  803047:	48 83 c4 10          	add    $0x10,%rsp
    POPA
  80304b:	4c 8b 3c 24          	mov    (%rsp),%r15
  80304f:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  803054:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  803059:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  80305e:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  803063:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  803068:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  80306d:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  803072:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  803077:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  80307c:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  803081:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  803086:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  80308b:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  803090:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  803095:	48 83 c4 78          	add    $0x78,%rsp
    addq $8, %rsp
  803099:	48 83 c4 08          	add    $0x8,%rsp
    # Restore rflags from the stack.  After you do this, you can
    # no longer use arithmetic operations or anything else that
    # modifies rflags.
    # LAB 9: Your code here
	popfq
  80309d:	9d                   	popf
    # Switch back to the adjusted trap-time stack.
    # LAB 9: Your code here
	popq %rsp
  80309e:	5c                   	pop    %rsp
    # Return to re-execute the instruction that faulted.
    ret
  80309f:	c3                   	ret

00000000008030a0 <_handle_vectored_pagefault>:
/* Vector size */
static size_t _pfhandler_off = 0;
static bool _pfhandler_inititiallized = 0;

void
_handle_vectored_pagefault(struct UTrapframe *utf) {
  8030a0:	f3 0f 1e fa          	endbr64
  8030a4:	55                   	push   %rbp
  8030a5:	48 89 e5             	mov    %rsp,%rbp
  8030a8:	41 56                	push   %r14
  8030aa:	41 55                	push   %r13
  8030ac:	41 54                	push   %r12
  8030ae:	53                   	push   %rbx
  8030af:	49 89 fc             	mov    %rdi,%r12
    /* This trying to handle pagefault until
     * some handler returns 1, that indicates
     * successfully handled exception */
    for (size_t i = 0; i < _pfhandler_off; i++)
  8030b2:	48 b8 68 80 80 00 00 	movabs $0x808068,%rax
  8030b9:	00 00 00 
  8030bc:	48 83 38 00          	cmpq   $0x0,(%rax)
  8030c0:	74 27                	je     8030e9 <_handle_vectored_pagefault+0x49>
  8030c2:	bb 00 00 00 00       	mov    $0x0,%ebx
        if (_pfhandler_vec[i](utf)) return;
  8030c7:	49 bd 20 80 80 00 00 	movabs $0x808020,%r13
  8030ce:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++)
  8030d1:	49 89 c6             	mov    %rax,%r14
        if (_pfhandler_vec[i](utf)) return;
  8030d4:	4c 89 e7             	mov    %r12,%rdi
  8030d7:	41 ff 54 dd 00       	call   *0x0(%r13,%rbx,8)
  8030dc:	84 c0                	test   %al,%al
  8030de:	75 45                	jne    803125 <_handle_vectored_pagefault+0x85>
    for (size_t i = 0; i < _pfhandler_off; i++)
  8030e0:	48 83 c3 01          	add    $0x1,%rbx
  8030e4:	49 3b 1e             	cmp    (%r14),%rbx
  8030e7:	72 eb                	jb     8030d4 <_handle_vectored_pagefault+0x34>

    /* Unhandled exceptions just cause panic */
    panic("Userspace page fault rip=%08lX va=%08lX err=%x\n",
  8030e9:	49 8b 8c 24 88 00 00 	mov    0x88(%r12),%rcx
  8030f0:	00 
  8030f1:	45 8b 4c 24 08       	mov    0x8(%r12),%r9d
  8030f6:	4d 8b 04 24          	mov    (%r12),%r8
  8030fa:	48 ba 40 44 80 00 00 	movabs $0x804440,%rdx
  803101:	00 00 00 
  803104:	be 1d 00 00 00       	mov    $0x1d,%esi
  803109:	48 bf 8f 42 80 00 00 	movabs $0x80428f,%rdi
  803110:	00 00 00 
  803113:	b8 00 00 00 00       	mov    $0x0,%eax
  803118:	49 ba 73 2f 80 00 00 	movabs $0x802f73,%r10
  80311f:	00 00 00 
  803122:	41 ff d2             	call   *%r10
          utf->utf_rip, utf->utf_fault_va, (int)utf->utf_err);
}
  803125:	5b                   	pop    %rbx
  803126:	41 5c                	pop    %r12
  803128:	41 5d                	pop    %r13
  80312a:	41 5e                	pop    %r14
  80312c:	5d                   	pop    %rbp
  80312d:	c3                   	ret

000000000080312e <add_pgfault_handler>:
 * The first time we register a handler, we need to
 * allocate an exception stack (one page of memory with its top
 * at USER_EXCEPTION_STACK_TOP), and tell the kernel to call the assembly-language
 * _pgfault_upcall routine when a page fault occurs. */
int
add_pgfault_handler(pf_handler_t handler) {
  80312e:	f3 0f 1e fa          	endbr64
  803132:	55                   	push   %rbp
  803133:	48 89 e5             	mov    %rsp,%rbp
  803136:	53                   	push   %rbx
  803137:	48 83 ec 08          	sub    $0x8,%rsp
  80313b:	48 89 fb             	mov    %rdi,%rbx
    int res = 0;
    if (!_pfhandler_inititiallized) {
  80313e:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  803145:	00 00 00 
  803148:	80 38 00             	cmpb   $0x0,(%rax)
  80314b:	0f 84 84 00 00 00    	je     8031d5 <add_pgfault_handler+0xa7>
        _pfhandler_vec[_pfhandler_off++] = handler;
        _pfhandler_inititiallized = 1;
        goto end;
    }

    for (size_t i = 0; i < _pfhandler_off; i++)
  803151:	48 b8 68 80 80 00 00 	movabs $0x808068,%rax
  803158:	00 00 00 
  80315b:	48 8b 10             	mov    (%rax),%rdx
  80315e:	b8 00 00 00 00       	mov    $0x0,%eax
        if (handler == _pfhandler_vec[i]) return 0;
  803163:	48 b9 20 80 80 00 00 	movabs $0x808020,%rcx
  80316a:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++)
  80316d:	48 85 d2             	test   %rdx,%rdx
  803170:	74 19                	je     80318b <add_pgfault_handler+0x5d>
        if (handler == _pfhandler_vec[i]) return 0;
  803172:	48 39 1c c1          	cmp    %rbx,(%rcx,%rax,8)
  803176:	0f 84 e8 00 00 00    	je     803264 <add_pgfault_handler+0x136>
    for (size_t i = 0; i < _pfhandler_off; i++)
  80317c:	48 83 c0 01          	add    $0x1,%rax
  803180:	48 39 d0             	cmp    %rdx,%rax
  803183:	75 ed                	jne    803172 <add_pgfault_handler+0x44>

    if (_pfhandler_off == MAX_PFHANDLER)
  803185:	48 83 fa 08          	cmp    $0x8,%rdx
  803189:	74 1c                	je     8031a7 <add_pgfault_handler+0x79>
        res = -E_INVAL;
    else
        _pfhandler_vec[_pfhandler_off++] = handler;
  80318b:	48 8d 42 01          	lea    0x1(%rdx),%rax
  80318f:	48 a3 68 80 80 00 00 	movabs %rax,0x808068
  803196:	00 00 00 
  803199:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8031a0:	00 00 00 
  8031a3:	48 89 1c d0          	mov    %rbx,(%rax,%rdx,8)

end:
    res = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  8031a7:	48 b8 63 12 80 00 00 	movabs $0x801263,%rax
  8031ae:	00 00 00 
  8031b1:	ff d0                	call   *%rax
  8031b3:	89 c7                	mov    %eax,%edi
  8031b5:	48 be 1a 30 80 00 00 	movabs $0x80301a,%rsi
  8031bc:	00 00 00 
  8031bf:	48 b8 b8 15 80 00 00 	movabs $0x8015b8,%rax
  8031c6:	00 00 00 
  8031c9:	ff d0                	call   *%rax
    if (res < 0) panic("set_pgfault_handler: %i", res);
  8031cb:	85 c0                	test   %eax,%eax
  8031cd:	78 68                	js     803237 <add_pgfault_handler+0x109>
    return res;
}
  8031cf:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8031d3:	c9                   	leave
  8031d4:	c3                   	ret
        res = sys_alloc_region(sys_getenvid(), (void*)(USER_EXCEPTION_STACK_TOP - PAGE_SIZE), PAGE_SIZE, PROT_RW);
  8031d5:	48 b8 63 12 80 00 00 	movabs $0x801263,%rax
  8031dc:	00 00 00 
  8031df:	ff d0                	call   *%rax
  8031e1:	89 c7                	mov    %eax,%edi
  8031e3:	b9 06 00 00 00       	mov    $0x6,%ecx
  8031e8:	ba 00 10 00 00       	mov    $0x1000,%edx
  8031ed:	48 be 00 f0 ff ff 7f 	movabs $0x7ffffff000,%rsi
  8031f4:	00 00 00 
  8031f7:	48 b8 33 13 80 00 00 	movabs $0x801333,%rax
  8031fe:	00 00 00 
  803201:	ff d0                	call   *%rax
        _pfhandler_vec[_pfhandler_off++] = handler;
  803203:	48 ba 68 80 80 00 00 	movabs $0x808068,%rdx
  80320a:	00 00 00 
  80320d:	48 8b 02             	mov    (%rdx),%rax
  803210:	48 8d 48 01          	lea    0x1(%rax),%rcx
  803214:	48 89 0a             	mov    %rcx,(%rdx)
  803217:	48 ba 20 80 80 00 00 	movabs $0x808020,%rdx
  80321e:	00 00 00 
  803221:	48 89 1c c2          	mov    %rbx,(%rdx,%rax,8)
        _pfhandler_inititiallized = 1;
  803225:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  80322c:	00 00 00 
  80322f:	c6 00 01             	movb   $0x1,(%rax)
        goto end;
  803232:	e9 70 ff ff ff       	jmp    8031a7 <add_pgfault_handler+0x79>
    if (res < 0) panic("set_pgfault_handler: %i", res);
  803237:	89 c1                	mov    %eax,%ecx
  803239:	48 ba 9d 42 80 00 00 	movabs $0x80429d,%rdx
  803240:	00 00 00 
  803243:	be 3d 00 00 00       	mov    $0x3d,%esi
  803248:	48 bf 8f 42 80 00 00 	movabs $0x80428f,%rdi
  80324f:	00 00 00 
  803252:	b8 00 00 00 00       	mov    $0x0,%eax
  803257:	49 b8 73 2f 80 00 00 	movabs $0x802f73,%r8
  80325e:	00 00 00 
  803261:	41 ff d0             	call   *%r8
        if (handler == _pfhandler_vec[i]) return 0;
  803264:	b8 00 00 00 00       	mov    $0x0,%eax
  803269:	e9 61 ff ff ff       	jmp    8031cf <add_pgfault_handler+0xa1>

000000000080326e <remove_pgfault_handler>:

void
remove_pgfault_handler(pf_handler_t handler) {
  80326e:	f3 0f 1e fa          	endbr64
  803272:	55                   	push   %rbp
  803273:	48 89 e5             	mov    %rsp,%rbp
    assert(_pfhandler_inititiallized);
  803276:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  80327d:	00 00 00 
  803280:	80 38 00             	cmpb   $0x0,(%rax)
  803283:	74 33                	je     8032b8 <remove_pgfault_handler+0x4a>
    for (size_t i = 0; i < _pfhandler_off; i++) {
  803285:	48 a1 68 80 80 00 00 	movabs 0x808068,%rax
  80328c:	00 00 00 
  80328f:	b9 00 00 00 00       	mov    $0x0,%ecx
        if (_pfhandler_vec[i] == handler) {
  803294:	48 ba 20 80 80 00 00 	movabs $0x808020,%rdx
  80329b:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++) {
  80329e:	48 85 c0             	test   %rax,%rax
  8032a1:	0f 84 85 00 00 00    	je     80332c <remove_pgfault_handler+0xbe>
        if (_pfhandler_vec[i] == handler) {
  8032a7:	48 39 3c ca          	cmp    %rdi,(%rdx,%rcx,8)
  8032ab:	74 40                	je     8032ed <remove_pgfault_handler+0x7f>
    for (size_t i = 0; i < _pfhandler_off; i++) {
  8032ad:	48 83 c1 01          	add    $0x1,%rcx
  8032b1:	48 39 c1             	cmp    %rax,%rcx
  8032b4:	75 f1                	jne    8032a7 <remove_pgfault_handler+0x39>
  8032b6:	eb 74                	jmp    80332c <remove_pgfault_handler+0xbe>
    assert(_pfhandler_inititiallized);
  8032b8:	48 b9 b5 42 80 00 00 	movabs $0x8042b5,%rcx
  8032bf:	00 00 00 
  8032c2:	48 ba 4c 42 80 00 00 	movabs $0x80424c,%rdx
  8032c9:	00 00 00 
  8032cc:	be 43 00 00 00       	mov    $0x43,%esi
  8032d1:	48 bf 8f 42 80 00 00 	movabs $0x80428f,%rdi
  8032d8:	00 00 00 
  8032db:	b8 00 00 00 00       	mov    $0x0,%eax
  8032e0:	49 b8 73 2f 80 00 00 	movabs $0x802f73,%r8
  8032e7:	00 00 00 
  8032ea:	41 ff d0             	call   *%r8
            memmove(_pfhandler_vec + i, _pfhandler_vec + i + 1, (_pfhandler_off - i - 1) * sizeof(*handler));
  8032ed:	48 8d 34 cd 08 00 00 	lea    0x8(,%rcx,8),%rsi
  8032f4:	00 
  8032f5:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8032f9:	48 29 ca             	sub    %rcx,%rdx
  8032fc:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  803303:	00 00 00 
  803306:	48 8d 0c 06          	lea    (%rsi,%rax,1),%rcx
  80330a:	48 8d 7c 30 f8       	lea    -0x8(%rax,%rsi,1),%rdi
  80330f:	48 89 ce             	mov    %rcx,%rsi
  803312:	48 b8 49 0f 80 00 00 	movabs $0x800f49,%rax
  803319:	00 00 00 
  80331c:	ff d0                	call   *%rax
            _pfhandler_off--;
  80331e:	48 b8 68 80 80 00 00 	movabs $0x808068,%rax
  803325:	00 00 00 
  803328:	48 83 28 01          	subq   $0x1,(%rax)
            return;
        }
    }
}
  80332c:	5d                   	pop    %rbp
  80332d:	c3                   	ret

000000000080332e <__text_end>:
  80332e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803335:	00 00 00 
  803338:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80333f:	00 00 00 
  803342:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803349:	00 00 00 
  80334c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803353:	00 00 00 
  803356:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80335d:	00 00 00 
  803360:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803367:	00 00 00 
  80336a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803371:	00 00 00 
  803374:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80337b:	00 00 00 
  80337e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803385:	00 00 00 
  803388:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80338f:	00 00 00 
  803392:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803399:	00 00 00 
  80339c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033a3:	00 00 00 
  8033a6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033ad:	00 00 00 
  8033b0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033b7:	00 00 00 
  8033ba:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033c1:	00 00 00 
  8033c4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033cb:	00 00 00 
  8033ce:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033d5:	00 00 00 
  8033d8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033df:	00 00 00 
  8033e2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033e9:	00 00 00 
  8033ec:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033f3:	00 00 00 
  8033f6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033fd:	00 00 00 
  803400:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803407:	00 00 00 
  80340a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803411:	00 00 00 
  803414:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80341b:	00 00 00 
  80341e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803425:	00 00 00 
  803428:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80342f:	00 00 00 
  803432:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803439:	00 00 00 
  80343c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803443:	00 00 00 
  803446:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80344d:	00 00 00 
  803450:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803457:	00 00 00 
  80345a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803461:	00 00 00 
  803464:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80346b:	00 00 00 
  80346e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803475:	00 00 00 
  803478:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80347f:	00 00 00 
  803482:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803489:	00 00 00 
  80348c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803493:	00 00 00 
  803496:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80349d:	00 00 00 
  8034a0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034a7:	00 00 00 
  8034aa:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034b1:	00 00 00 
  8034b4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034bb:	00 00 00 
  8034be:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034c5:	00 00 00 
  8034c8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034cf:	00 00 00 
  8034d2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034d9:	00 00 00 
  8034dc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034e3:	00 00 00 
  8034e6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034ed:	00 00 00 
  8034f0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034f7:	00 00 00 
  8034fa:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803501:	00 00 00 
  803504:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80350b:	00 00 00 
  80350e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803515:	00 00 00 
  803518:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80351f:	00 00 00 
  803522:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803529:	00 00 00 
  80352c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803533:	00 00 00 
  803536:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80353d:	00 00 00 
  803540:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803547:	00 00 00 
  80354a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803551:	00 00 00 
  803554:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80355b:	00 00 00 
  80355e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803565:	00 00 00 
  803568:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80356f:	00 00 00 
  803572:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803579:	00 00 00 
  80357c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803583:	00 00 00 
  803586:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80358d:	00 00 00 
  803590:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803597:	00 00 00 
  80359a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035a1:	00 00 00 
  8035a4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035ab:	00 00 00 
  8035ae:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035b5:	00 00 00 
  8035b8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035bf:	00 00 00 
  8035c2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035c9:	00 00 00 
  8035cc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035d3:	00 00 00 
  8035d6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035dd:	00 00 00 
  8035e0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035e7:	00 00 00 
  8035ea:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035f1:	00 00 00 
  8035f4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035fb:	00 00 00 
  8035fe:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803605:	00 00 00 
  803608:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80360f:	00 00 00 
  803612:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803619:	00 00 00 
  80361c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803623:	00 00 00 
  803626:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80362d:	00 00 00 
  803630:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803637:	00 00 00 
  80363a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803641:	00 00 00 
  803644:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80364b:	00 00 00 
  80364e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803655:	00 00 00 
  803658:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80365f:	00 00 00 
  803662:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803669:	00 00 00 
  80366c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803673:	00 00 00 
  803676:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80367d:	00 00 00 
  803680:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803687:	00 00 00 
  80368a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803691:	00 00 00 
  803694:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80369b:	00 00 00 
  80369e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036a5:	00 00 00 
  8036a8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036af:	00 00 00 
  8036b2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036b9:	00 00 00 
  8036bc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036c3:	00 00 00 
  8036c6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036cd:	00 00 00 
  8036d0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036d7:	00 00 00 
  8036da:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036e1:	00 00 00 
  8036e4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036eb:	00 00 00 
  8036ee:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036f5:	00 00 00 
  8036f8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036ff:	00 00 00 
  803702:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803709:	00 00 00 
  80370c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803713:	00 00 00 
  803716:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80371d:	00 00 00 
  803720:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803727:	00 00 00 
  80372a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803731:	00 00 00 
  803734:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80373b:	00 00 00 
  80373e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803745:	00 00 00 
  803748:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80374f:	00 00 00 
  803752:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803759:	00 00 00 
  80375c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803763:	00 00 00 
  803766:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80376d:	00 00 00 
  803770:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803777:	00 00 00 
  80377a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803781:	00 00 00 
  803784:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80378b:	00 00 00 
  80378e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803795:	00 00 00 
  803798:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80379f:	00 00 00 
  8037a2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037a9:	00 00 00 
  8037ac:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037b3:	00 00 00 
  8037b6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037bd:	00 00 00 
  8037c0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037c7:	00 00 00 
  8037ca:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037d1:	00 00 00 
  8037d4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037db:	00 00 00 
  8037de:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037e5:	00 00 00 
  8037e8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037ef:	00 00 00 
  8037f2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037f9:	00 00 00 
  8037fc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803803:	00 00 00 
  803806:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80380d:	00 00 00 
  803810:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803817:	00 00 00 
  80381a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803821:	00 00 00 
  803824:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80382b:	00 00 00 
  80382e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803835:	00 00 00 
  803838:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80383f:	00 00 00 
  803842:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803849:	00 00 00 
  80384c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803853:	00 00 00 
  803856:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80385d:	00 00 00 
  803860:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803867:	00 00 00 
  80386a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803871:	00 00 00 
  803874:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80387b:	00 00 00 
  80387e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803885:	00 00 00 
  803888:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80388f:	00 00 00 
  803892:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803899:	00 00 00 
  80389c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038a3:	00 00 00 
  8038a6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038ad:	00 00 00 
  8038b0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038b7:	00 00 00 
  8038ba:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038c1:	00 00 00 
  8038c4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038cb:	00 00 00 
  8038ce:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038d5:	00 00 00 
  8038d8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038df:	00 00 00 
  8038e2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038e9:	00 00 00 
  8038ec:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038f3:	00 00 00 
  8038f6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038fd:	00 00 00 
  803900:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803907:	00 00 00 
  80390a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803911:	00 00 00 
  803914:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80391b:	00 00 00 
  80391e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803925:	00 00 00 
  803928:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80392f:	00 00 00 
  803932:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803939:	00 00 00 
  80393c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803943:	00 00 00 
  803946:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80394d:	00 00 00 
  803950:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803957:	00 00 00 
  80395a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803961:	00 00 00 
  803964:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80396b:	00 00 00 
  80396e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803975:	00 00 00 
  803978:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80397f:	00 00 00 
  803982:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803989:	00 00 00 
  80398c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803993:	00 00 00 
  803996:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80399d:	00 00 00 
  8039a0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039a7:	00 00 00 
  8039aa:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039b1:	00 00 00 
  8039b4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039bb:	00 00 00 
  8039be:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039c5:	00 00 00 
  8039c8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039cf:	00 00 00 
  8039d2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039d9:	00 00 00 
  8039dc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039e3:	00 00 00 
  8039e6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039ed:	00 00 00 
  8039f0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039f7:	00 00 00 
  8039fa:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a01:	00 00 00 
  803a04:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a0b:	00 00 00 
  803a0e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a15:	00 00 00 
  803a18:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a1f:	00 00 00 
  803a22:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a29:	00 00 00 
  803a2c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a33:	00 00 00 
  803a36:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a3d:	00 00 00 
  803a40:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a47:	00 00 00 
  803a4a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a51:	00 00 00 
  803a54:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a5b:	00 00 00 
  803a5e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a65:	00 00 00 
  803a68:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a6f:	00 00 00 
  803a72:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a79:	00 00 00 
  803a7c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a83:	00 00 00 
  803a86:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a8d:	00 00 00 
  803a90:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a97:	00 00 00 
  803a9a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803aa1:	00 00 00 
  803aa4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803aab:	00 00 00 
  803aae:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ab5:	00 00 00 
  803ab8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803abf:	00 00 00 
  803ac2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ac9:	00 00 00 
  803acc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ad3:	00 00 00 
  803ad6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803add:	00 00 00 
  803ae0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ae7:	00 00 00 
  803aea:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803af1:	00 00 00 
  803af4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803afb:	00 00 00 
  803afe:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b05:	00 00 00 
  803b08:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b0f:	00 00 00 
  803b12:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b19:	00 00 00 
  803b1c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b23:	00 00 00 
  803b26:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b2d:	00 00 00 
  803b30:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b37:	00 00 00 
  803b3a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b41:	00 00 00 
  803b44:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b4b:	00 00 00 
  803b4e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b55:	00 00 00 
  803b58:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b5f:	00 00 00 
  803b62:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b69:	00 00 00 
  803b6c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b73:	00 00 00 
  803b76:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b7d:	00 00 00 
  803b80:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b87:	00 00 00 
  803b8a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b91:	00 00 00 
  803b94:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b9b:	00 00 00 
  803b9e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ba5:	00 00 00 
  803ba8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803baf:	00 00 00 
  803bb2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bb9:	00 00 00 
  803bbc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bc3:	00 00 00 
  803bc6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bcd:	00 00 00 
  803bd0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bd7:	00 00 00 
  803bda:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803be1:	00 00 00 
  803be4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803beb:	00 00 00 
  803bee:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bf5:	00 00 00 
  803bf8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bff:	00 00 00 
  803c02:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c09:	00 00 00 
  803c0c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c13:	00 00 00 
  803c16:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c1d:	00 00 00 
  803c20:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c27:	00 00 00 
  803c2a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c31:	00 00 00 
  803c34:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c3b:	00 00 00 
  803c3e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c45:	00 00 00 
  803c48:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c4f:	00 00 00 
  803c52:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c59:	00 00 00 
  803c5c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c63:	00 00 00 
  803c66:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c6d:	00 00 00 
  803c70:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c77:	00 00 00 
  803c7a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c81:	00 00 00 
  803c84:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c8b:	00 00 00 
  803c8e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c95:	00 00 00 
  803c98:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c9f:	00 00 00 
  803ca2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ca9:	00 00 00 
  803cac:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cb3:	00 00 00 
  803cb6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cbd:	00 00 00 
  803cc0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cc7:	00 00 00 
  803cca:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cd1:	00 00 00 
  803cd4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cdb:	00 00 00 
  803cde:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ce5:	00 00 00 
  803ce8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cef:	00 00 00 
  803cf2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cf9:	00 00 00 
  803cfc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d03:	00 00 00 
  803d06:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d0d:	00 00 00 
  803d10:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d17:	00 00 00 
  803d1a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d21:	00 00 00 
  803d24:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d2b:	00 00 00 
  803d2e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d35:	00 00 00 
  803d38:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d3f:	00 00 00 
  803d42:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d49:	00 00 00 
  803d4c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d53:	00 00 00 
  803d56:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d5d:	00 00 00 
  803d60:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d67:	00 00 00 
  803d6a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d71:	00 00 00 
  803d74:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d7b:	00 00 00 
  803d7e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d85:	00 00 00 
  803d88:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d8f:	00 00 00 
  803d92:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d99:	00 00 00 
  803d9c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803da3:	00 00 00 
  803da6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dad:	00 00 00 
  803db0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803db7:	00 00 00 
  803dba:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dc1:	00 00 00 
  803dc4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dcb:	00 00 00 
  803dce:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dd5:	00 00 00 
  803dd8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ddf:	00 00 00 
  803de2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803de9:	00 00 00 
  803dec:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803df3:	00 00 00 
  803df6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dfd:	00 00 00 
  803e00:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e07:	00 00 00 
  803e0a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e11:	00 00 00 
  803e14:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e1b:	00 00 00 
  803e1e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e25:	00 00 00 
  803e28:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e2f:	00 00 00 
  803e32:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e39:	00 00 00 
  803e3c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e43:	00 00 00 
  803e46:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e4d:	00 00 00 
  803e50:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e57:	00 00 00 
  803e5a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e61:	00 00 00 
  803e64:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e6b:	00 00 00 
  803e6e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e75:	00 00 00 
  803e78:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e7f:	00 00 00 
  803e82:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e89:	00 00 00 
  803e8c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e93:	00 00 00 
  803e96:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e9d:	00 00 00 
  803ea0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ea7:	00 00 00 
  803eaa:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803eb1:	00 00 00 
  803eb4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ebb:	00 00 00 
  803ebe:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ec5:	00 00 00 
  803ec8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ecf:	00 00 00 
  803ed2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ed9:	00 00 00 
  803edc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ee3:	00 00 00 
  803ee6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803eed:	00 00 00 
  803ef0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ef7:	00 00 00 
  803efa:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f01:	00 00 00 
  803f04:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f0b:	00 00 00 
  803f0e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f15:	00 00 00 
  803f18:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f1f:	00 00 00 
  803f22:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f29:	00 00 00 
  803f2c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f33:	00 00 00 
  803f36:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f3d:	00 00 00 
  803f40:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f47:	00 00 00 
  803f4a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f51:	00 00 00 
  803f54:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f5b:	00 00 00 
  803f5e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f65:	00 00 00 
  803f68:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f6f:	00 00 00 
  803f72:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f79:	00 00 00 
  803f7c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f83:	00 00 00 
  803f86:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f8d:	00 00 00 
  803f90:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f97:	00 00 00 
  803f9a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fa1:	00 00 00 
  803fa4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fab:	00 00 00 
  803fae:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fb5:	00 00 00 
  803fb8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fbf:	00 00 00 
  803fc2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fc9:	00 00 00 
  803fcc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fd3:	00 00 00 
  803fd6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fdd:	00 00 00 
  803fe0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fe7:	00 00 00 
  803fea:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ff1:	00 00 00 
  803ff4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ffb:	00 00 00 
  803ffe:	66 90                	xchg   %ax,%ax
