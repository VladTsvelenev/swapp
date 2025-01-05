
obj/user/testfdsharing:     file format elf64-x86-64


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
  80001e:	e8 d3 02 00 00       	call   8002f6 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <umain>:
#include <inc/lib.h>

char buf[512], buf2[512];

void
umain(int argc, char **argv) {
  800025:	f3 0f 1e fa          	endbr64
  800029:	55                   	push   %rbp
  80002a:	48 89 e5             	mov    %rsp,%rbp
  80002d:	41 56                	push   %r14
  80002f:	41 55                	push   %r13
  800031:	41 54                	push   %r12
  800033:	53                   	push   %rbx
    int fd, r, n, n2;

    if ((fd = open("motd", O_RDONLY)) < 0)
  800034:	be 00 00 00 00       	mov    $0x0,%esi
  800039:	48 bf 00 40 80 00 00 	movabs $0x804000,%rdi
  800040:	00 00 00 
  800043:	48 b8 64 23 80 00 00 	movabs $0x802364,%rax
  80004a:	00 00 00 
  80004d:	ff d0                	call   *%rax
  80004f:	89 c3                	mov    %eax,%ebx
  800051:	85 c0                	test   %eax,%eax
  800053:	0f 88 8a 01 00 00    	js     8001e3 <umain+0x1be>
        panic("open motd: %i", fd);
    seek(fd, 0);
  800059:	be 00 00 00 00       	mov    $0x0,%esi
  80005e:	89 c7                	mov    %eax,%edi
  800060:	48 b8 22 1f 80 00 00 	movabs $0x801f22,%rax
  800067:	00 00 00 
  80006a:	ff d0                	call   *%rax
    if ((n = readn(fd, buf, sizeof buf)) <= 0)
  80006c:	ba 00 02 00 00       	mov    $0x200,%edx
  800071:	48 be 00 62 80 00 00 	movabs $0x806200,%rsi
  800078:	00 00 00 
  80007b:	89 df                	mov    %ebx,%edi
  80007d:	48 b8 f0 1d 80 00 00 	movabs $0x801df0,%rax
  800084:	00 00 00 
  800087:	ff d0                	call   *%rax
  800089:	49 89 c4             	mov    %rax,%r12
  80008c:	41 89 c6             	mov    %eax,%r14d
  80008f:	85 c0                	test   %eax,%eax
  800091:	0f 8e 79 01 00 00    	jle    800210 <umain+0x1eb>
        panic("readn: %i", n);

    if ((r = fork()) < 0)
  800097:	48 b8 3d 18 80 00 00 	movabs $0x80183d,%rax
  80009e:	00 00 00 
  8000a1:	ff d0                	call   *%rax
  8000a3:	41 89 c5             	mov    %eax,%r13d
  8000a6:	85 c0                	test   %eax,%eax
  8000a8:	0f 88 8f 01 00 00    	js     80023d <umain+0x218>
        panic("fork: %i", r);
    if (r == 0) {
  8000ae:	0f 85 c7 00 00 00    	jne    80017b <umain+0x156>
        seek(fd, 0);
  8000b4:	be 00 00 00 00       	mov    $0x0,%esi
  8000b9:	89 df                	mov    %ebx,%edi
  8000bb:	48 b8 22 1f 80 00 00 	movabs $0x801f22,%rax
  8000c2:	00 00 00 
  8000c5:	ff d0                	call   *%rax
        cprintf("going to read in child (might page fault if your sharing is buggy)\n");
  8000c7:	48 bf 40 43 80 00 00 	movabs $0x804340,%rdi
  8000ce:	00 00 00 
  8000d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d6:	48 ba 2b 05 80 00 00 	movabs $0x80052b,%rdx
  8000dd:	00 00 00 
  8000e0:	ff d2                	call   *%rdx
        if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  8000e2:	ba 00 02 00 00       	mov    $0x200,%edx
  8000e7:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  8000ee:	00 00 00 
  8000f1:	89 df                	mov    %ebx,%edi
  8000f3:	48 b8 f0 1d 80 00 00 	movabs $0x801df0,%rax
  8000fa:	00 00 00 
  8000fd:	ff d0                	call   *%rax
  8000ff:	41 39 c4             	cmp    %eax,%r12d
  800102:	0f 85 62 01 00 00    	jne    80026a <umain+0x245>
            panic("read in parent got %d, read in child got %d", n, n2);
        if (memcmp(buf, buf2, n) != 0)
  800108:	49 63 d4             	movslq %r12d,%rdx
  80010b:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  800112:	00 00 00 
  800115:	48 bf 00 62 80 00 00 	movabs $0x806200,%rdi
  80011c:	00 00 00 
  80011f:	48 b8 ba 11 80 00 00 	movabs $0x8011ba,%rax
  800126:	00 00 00 
  800129:	ff d0                	call   *%rax
  80012b:	85 c0                	test   %eax,%eax
  80012d:	0f 85 68 01 00 00    	jne    80029b <umain+0x276>
            panic("read in parent got different bytes from read in child");
        cprintf("read in child succeeded\n");
  800133:	48 bf 3b 40 80 00 00 	movabs $0x80403b,%rdi
  80013a:	00 00 00 
  80013d:	b8 00 00 00 00       	mov    $0x0,%eax
  800142:	48 ba 2b 05 80 00 00 	movabs $0x80052b,%rdx
  800149:	00 00 00 
  80014c:	ff d2                	call   *%rdx
        seek(fd, 0);
  80014e:	be 00 00 00 00       	mov    $0x0,%esi
  800153:	89 df                	mov    %ebx,%edi
  800155:	48 b8 22 1f 80 00 00 	movabs $0x801f22,%rax
  80015c:	00 00 00 
  80015f:	ff d0                	call   *%rax
        close(fd);
  800161:	89 df                	mov    %ebx,%edi
  800163:	48 b8 a4 1b 80 00 00 	movabs $0x801ba4,%rax
  80016a:	00 00 00 
  80016d:	ff d0                	call   *%rax
        exit();
  80016f:	48 b8 a8 03 80 00 00 	movabs $0x8003a8,%rax
  800176:	00 00 00 
  800179:	ff d0                	call   *%rax
    }
    wait(r);
  80017b:	44 89 ef             	mov    %r13d,%edi
  80017e:	48 b8 4d 29 80 00 00 	movabs $0x80294d,%rax
  800185:	00 00 00 
  800188:	ff d0                	call   *%rax
    if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  80018a:	ba 00 02 00 00       	mov    $0x200,%edx
  80018f:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  800196:	00 00 00 
  800199:	89 df                	mov    %ebx,%edi
  80019b:	48 b8 f0 1d 80 00 00 	movabs $0x801df0,%rax
  8001a2:	00 00 00 
  8001a5:	ff d0                	call   *%rax
  8001a7:	41 39 c4             	cmp    %eax,%r12d
  8001aa:	0f 85 15 01 00 00    	jne    8002c5 <umain+0x2a0>
        panic("read in parent got %d, then got %d", n, n2);
    cprintf("read in parent succeeded\n");
  8001b0:	48 bf 54 40 80 00 00 	movabs $0x804054,%rdi
  8001b7:	00 00 00 
  8001ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8001bf:	48 ba 2b 05 80 00 00 	movabs $0x80052b,%rdx
  8001c6:	00 00 00 
  8001c9:	ff d2                	call   *%rdx
    close(fd);
  8001cb:	89 df                	mov    %ebx,%edi
  8001cd:	48 b8 a4 1b 80 00 00 	movabs $0x801ba4,%rax
  8001d4:	00 00 00 
  8001d7:	ff d0                	call   *%rax

#include <inc/types.h>

static inline void __attribute__((always_inline))
breakpoint(void) {
    asm volatile("int3");
  8001d9:	cc                   	int3

    breakpoint();
}
  8001da:	5b                   	pop    %rbx
  8001db:	41 5c                	pop    %r12
  8001dd:	41 5d                	pop    %r13
  8001df:	41 5e                	pop    %r14
  8001e1:	5d                   	pop    %rbp
  8001e2:	c3                   	ret
        panic("open motd: %i", fd);
  8001e3:	89 c1                	mov    %eax,%ecx
  8001e5:	48 ba 05 40 80 00 00 	movabs $0x804005,%rdx
  8001ec:	00 00 00 
  8001ef:	be 0b 00 00 00       	mov    $0xb,%esi
  8001f4:	48 bf 13 40 80 00 00 	movabs $0x804013,%rdi
  8001fb:	00 00 00 
  8001fe:	b8 00 00 00 00       	mov    $0x0,%eax
  800203:	49 b8 cf 03 80 00 00 	movabs $0x8003cf,%r8
  80020a:	00 00 00 
  80020d:	41 ff d0             	call   *%r8
        panic("readn: %i", n);
  800210:	89 c1                	mov    %eax,%ecx
  800212:	48 ba 28 40 80 00 00 	movabs $0x804028,%rdx
  800219:	00 00 00 
  80021c:	be 0e 00 00 00       	mov    $0xe,%esi
  800221:	48 bf 13 40 80 00 00 	movabs $0x804013,%rdi
  800228:	00 00 00 
  80022b:	b8 00 00 00 00       	mov    $0x0,%eax
  800230:	49 b8 cf 03 80 00 00 	movabs $0x8003cf,%r8
  800237:	00 00 00 
  80023a:	41 ff d0             	call   *%r8
        panic("fork: %i", r);
  80023d:	89 c1                	mov    %eax,%ecx
  80023f:	48 ba 32 40 80 00 00 	movabs $0x804032,%rdx
  800246:	00 00 00 
  800249:	be 11 00 00 00       	mov    $0x11,%esi
  80024e:	48 bf 13 40 80 00 00 	movabs $0x804013,%rdi
  800255:	00 00 00 
  800258:	b8 00 00 00 00       	mov    $0x0,%eax
  80025d:	49 b8 cf 03 80 00 00 	movabs $0x8003cf,%r8
  800264:	00 00 00 
  800267:	41 ff d0             	call   *%r8
            panic("read in parent got %d, read in child got %d", n, n2);
  80026a:	41 89 c0             	mov    %eax,%r8d
  80026d:	44 89 e1             	mov    %r12d,%ecx
  800270:	48 ba 88 43 80 00 00 	movabs $0x804388,%rdx
  800277:	00 00 00 
  80027a:	be 16 00 00 00       	mov    $0x16,%esi
  80027f:	48 bf 13 40 80 00 00 	movabs $0x804013,%rdi
  800286:	00 00 00 
  800289:	b8 00 00 00 00       	mov    $0x0,%eax
  80028e:	49 b9 cf 03 80 00 00 	movabs $0x8003cf,%r9
  800295:	00 00 00 
  800298:	41 ff d1             	call   *%r9
            panic("read in parent got different bytes from read in child");
  80029b:	48 ba b8 43 80 00 00 	movabs $0x8043b8,%rdx
  8002a2:	00 00 00 
  8002a5:	be 18 00 00 00       	mov    $0x18,%esi
  8002aa:	48 bf 13 40 80 00 00 	movabs $0x804013,%rdi
  8002b1:	00 00 00 
  8002b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8002b9:	48 b9 cf 03 80 00 00 	movabs $0x8003cf,%rcx
  8002c0:	00 00 00 
  8002c3:	ff d1                	call   *%rcx
        panic("read in parent got %d, then got %d", n, n2);
  8002c5:	41 89 c0             	mov    %eax,%r8d
  8002c8:	44 89 f1             	mov    %r14d,%ecx
  8002cb:	48 ba f0 43 80 00 00 	movabs $0x8043f0,%rdx
  8002d2:	00 00 00 
  8002d5:	be 20 00 00 00       	mov    $0x20,%esi
  8002da:	48 bf 13 40 80 00 00 	movabs $0x804013,%rdi
  8002e1:	00 00 00 
  8002e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8002e9:	49 b9 cf 03 80 00 00 	movabs $0x8003cf,%r9
  8002f0:	00 00 00 
  8002f3:	41 ff d1             	call   *%r9

00000000008002f6 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  8002f6:	f3 0f 1e fa          	endbr64
  8002fa:	55                   	push   %rbp
  8002fb:	48 89 e5             	mov    %rsp,%rbp
  8002fe:	41 56                	push   %r14
  800300:	41 55                	push   %r13
  800302:	41 54                	push   %r12
  800304:	53                   	push   %rbx
  800305:	41 89 fd             	mov    %edi,%r13d
  800308:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
     * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  80030b:	48 ba d8 50 80 00 00 	movabs $0x8050d8,%rdx
  800312:	00 00 00 
  800315:	48 b8 d8 50 80 00 00 	movabs $0x8050d8,%rax
  80031c:	00 00 00 
  80031f:	48 39 c2             	cmp    %rax,%rdx
  800322:	73 17                	jae    80033b <libmain+0x45>
    void (**ctor)() = &__ctors_start;
  800324:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  800327:	49 89 c4             	mov    %rax,%r12
  80032a:	48 83 c3 08          	add    $0x8,%rbx
  80032e:	b8 00 00 00 00       	mov    $0x0,%eax
  800333:	ff 53 f8             	call   *-0x8(%rbx)
  800336:	4c 39 e3             	cmp    %r12,%rbx
  800339:	72 ef                	jb     80032a <libmain+0x34>

    /* Set thisenv to point at our Env structure in envs[]. */

    // LAB 8: Your code here
    thisenv = &((struct Env *)UENVS)[ENVX(sys_getenvid())];
  80033b:	48 b8 a9 13 80 00 00 	movabs $0x8013a9,%rax
  800342:	00 00 00 
  800345:	ff d0                	call   *%rax
  800347:	25 ff 03 00 00       	and    $0x3ff,%eax
  80034c:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  800350:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  800354:	48 c1 e0 04          	shl    $0x4,%rax
  800358:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  80035f:	00 00 00 
  800362:	48 01 d0             	add    %rdx,%rax
  800365:	48 a3 00 64 80 00 00 	movabs %rax,0x806400
  80036c:	00 00 00 

    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  80036f:	45 85 ed             	test   %r13d,%r13d
  800372:	7e 0d                	jle    800381 <libmain+0x8b>
  800374:	49 8b 06             	mov    (%r14),%rax
  800377:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  80037e:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  800381:	4c 89 f6             	mov    %r14,%rsi
  800384:	44 89 ef             	mov    %r13d,%edi
  800387:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  80038e:	00 00 00 
  800391:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  800393:	48 b8 a8 03 80 00 00 	movabs $0x8003a8,%rax
  80039a:	00 00 00 
  80039d:	ff d0                	call   *%rax
#endif
}
  80039f:	5b                   	pop    %rbx
  8003a0:	41 5c                	pop    %r12
  8003a2:	41 5d                	pop    %r13
  8003a4:	41 5e                	pop    %r14
  8003a6:	5d                   	pop    %rbp
  8003a7:	c3                   	ret

00000000008003a8 <exit>:

#include <inc/lib.h>

void
exit(void) {
  8003a8:	f3 0f 1e fa          	endbr64
  8003ac:	55                   	push   %rbp
  8003ad:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  8003b0:	48 b8 db 1b 80 00 00 	movabs $0x801bdb,%rax
  8003b7:	00 00 00 
  8003ba:	ff d0                	call   *%rax
    sys_env_destroy(0);
  8003bc:	bf 00 00 00 00       	mov    $0x0,%edi
  8003c1:	48 b8 3a 13 80 00 00 	movabs $0x80133a,%rax
  8003c8:	00 00 00 
  8003cb:	ff d0                	call   *%rax
}
  8003cd:	5d                   	pop    %rbp
  8003ce:	c3                   	ret

00000000008003cf <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  8003cf:	f3 0f 1e fa          	endbr64
  8003d3:	55                   	push   %rbp
  8003d4:	48 89 e5             	mov    %rsp,%rbp
  8003d7:	41 56                	push   %r14
  8003d9:	41 55                	push   %r13
  8003db:	41 54                	push   %r12
  8003dd:	53                   	push   %rbx
  8003de:	48 83 ec 50          	sub    $0x50,%rsp
  8003e2:	49 89 fc             	mov    %rdi,%r12
  8003e5:	41 89 f5             	mov    %esi,%r13d
  8003e8:	48 89 d3             	mov    %rdx,%rbx
  8003eb:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8003ef:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  8003f3:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  8003f7:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  8003fe:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800402:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  800406:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  80040a:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  80040e:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  800415:	00 00 00 
  800418:	4c 8b 30             	mov    (%rax),%r14
  80041b:	48 b8 a9 13 80 00 00 	movabs $0x8013a9,%rax
  800422:	00 00 00 
  800425:	ff d0                	call   *%rax
  800427:	89 c6                	mov    %eax,%esi
  800429:	45 89 e8             	mov    %r13d,%r8d
  80042c:	4c 89 e1             	mov    %r12,%rcx
  80042f:	4c 89 f2             	mov    %r14,%rdx
  800432:	48 bf 18 44 80 00 00 	movabs $0x804418,%rdi
  800439:	00 00 00 
  80043c:	b8 00 00 00 00       	mov    $0x0,%eax
  800441:	49 bc 2b 05 80 00 00 	movabs $0x80052b,%r12
  800448:	00 00 00 
  80044b:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  80044e:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  800452:	48 89 df             	mov    %rbx,%rdi
  800455:	48 b8 c3 04 80 00 00 	movabs $0x8004c3,%rax
  80045c:	00 00 00 
  80045f:	ff d0                	call   *%rax
    cprintf("\n");
  800461:	48 bf 52 40 80 00 00 	movabs $0x804052,%rdi
  800468:	00 00 00 
  80046b:	b8 00 00 00 00       	mov    $0x0,%eax
  800470:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  800473:	cc                   	int3
  800474:	eb fd                	jmp    800473 <_panic+0xa4>

0000000000800476 <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  800476:	f3 0f 1e fa          	endbr64
  80047a:	55                   	push   %rbp
  80047b:	48 89 e5             	mov    %rsp,%rbp
  80047e:	53                   	push   %rbx
  80047f:	48 83 ec 08          	sub    $0x8,%rsp
  800483:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  800486:	8b 06                	mov    (%rsi),%eax
  800488:	8d 50 01             	lea    0x1(%rax),%edx
  80048b:	89 16                	mov    %edx,(%rsi)
  80048d:	48 98                	cltq
  80048f:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  800494:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  80049a:	74 0a                	je     8004a6 <putch+0x30>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  80049c:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  8004a0:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8004a4:	c9                   	leave
  8004a5:	c3                   	ret
        sys_cputs(state->buf, state->offset);
  8004a6:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  8004aa:	be ff 00 00 00       	mov    $0xff,%esi
  8004af:	48 b8 d4 12 80 00 00 	movabs $0x8012d4,%rax
  8004b6:	00 00 00 
  8004b9:	ff d0                	call   *%rax
        state->offset = 0;
  8004bb:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  8004c1:	eb d9                	jmp    80049c <putch+0x26>

00000000008004c3 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  8004c3:	f3 0f 1e fa          	endbr64
  8004c7:	55                   	push   %rbp
  8004c8:	48 89 e5             	mov    %rsp,%rbp
  8004cb:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8004d2:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  8004d5:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  8004dc:	b9 21 00 00 00       	mov    $0x21,%ecx
  8004e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8004e6:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  8004e9:	48 89 f1             	mov    %rsi,%rcx
  8004ec:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  8004f3:	48 bf 76 04 80 00 00 	movabs $0x800476,%rdi
  8004fa:	00 00 00 
  8004fd:	48 b8 8b 06 80 00 00 	movabs $0x80068b,%rax
  800504:	00 00 00 
  800507:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  800509:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  800510:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  800517:	48 b8 d4 12 80 00 00 	movabs $0x8012d4,%rax
  80051e:	00 00 00 
  800521:	ff d0                	call   *%rax

    return state.count;
}
  800523:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  800529:	c9                   	leave
  80052a:	c3                   	ret

000000000080052b <cprintf>:

int
cprintf(const char *fmt, ...) {
  80052b:	f3 0f 1e fa          	endbr64
  80052f:	55                   	push   %rbp
  800530:	48 89 e5             	mov    %rsp,%rbp
  800533:	48 83 ec 50          	sub    $0x50,%rsp
  800537:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  80053b:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80053f:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800543:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800547:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  80054b:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  800552:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800556:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80055a:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80055e:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  800562:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  800566:	48 b8 c3 04 80 00 00 	movabs $0x8004c3,%rax
  80056d:	00 00 00 
  800570:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  800572:	c9                   	leave
  800573:	c3                   	ret

0000000000800574 <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  800574:	f3 0f 1e fa          	endbr64
  800578:	55                   	push   %rbp
  800579:	48 89 e5             	mov    %rsp,%rbp
  80057c:	41 57                	push   %r15
  80057e:	41 56                	push   %r14
  800580:	41 55                	push   %r13
  800582:	41 54                	push   %r12
  800584:	53                   	push   %rbx
  800585:	48 83 ec 18          	sub    $0x18,%rsp
  800589:	49 89 fc             	mov    %rdi,%r12
  80058c:	49 89 f5             	mov    %rsi,%r13
  80058f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  800593:	8b 45 10             	mov    0x10(%rbp),%eax
  800596:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  800599:	41 89 cf             	mov    %ecx,%r15d
  80059c:	4c 39 fa             	cmp    %r15,%rdx
  80059f:	73 5b                	jae    8005fc <print_num+0x88>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  8005a1:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  8005a5:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  8005a9:	85 db                	test   %ebx,%ebx
  8005ab:	7e 0e                	jle    8005bb <print_num+0x47>
            putch(padc, put_arg);
  8005ad:	4c 89 ee             	mov    %r13,%rsi
  8005b0:	44 89 f7             	mov    %r14d,%edi
  8005b3:	41 ff d4             	call   *%r12
        while (--width > 0) {
  8005b6:	83 eb 01             	sub    $0x1,%ebx
  8005b9:	75 f2                	jne    8005ad <print_num+0x39>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  8005bb:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  8005bf:	48 b9 89 40 80 00 00 	movabs $0x804089,%rcx
  8005c6:	00 00 00 
  8005c9:	48 b8 78 40 80 00 00 	movabs $0x804078,%rax
  8005d0:	00 00 00 
  8005d3:	48 0f 45 c8          	cmovne %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  8005d7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8005db:	ba 00 00 00 00       	mov    $0x0,%edx
  8005e0:	49 f7 f7             	div    %r15
  8005e3:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  8005e7:	4c 89 ee             	mov    %r13,%rsi
  8005ea:	41 ff d4             	call   *%r12
}
  8005ed:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  8005f1:	5b                   	pop    %rbx
  8005f2:	41 5c                	pop    %r12
  8005f4:	41 5d                	pop    %r13
  8005f6:	41 5e                	pop    %r14
  8005f8:	41 5f                	pop    %r15
  8005fa:	5d                   	pop    %rbp
  8005fb:	c3                   	ret
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  8005fc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800600:	ba 00 00 00 00       	mov    $0x0,%edx
  800605:	49 f7 f7             	div    %r15
  800608:	48 83 ec 08          	sub    $0x8,%rsp
  80060c:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  800610:	52                   	push   %rdx
  800611:	45 0f be c9          	movsbl %r9b,%r9d
  800615:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  800619:	48 89 c2             	mov    %rax,%rdx
  80061c:	48 b8 74 05 80 00 00 	movabs $0x800574,%rax
  800623:	00 00 00 
  800626:	ff d0                	call   *%rax
  800628:	48 83 c4 10          	add    $0x10,%rsp
  80062c:	eb 8d                	jmp    8005bb <print_num+0x47>

000000000080062e <sprintputch>:
    char *end;
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
  80062e:	f3 0f 1e fa          	endbr64
    state->count++;
  800632:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  800636:	48 8b 06             	mov    (%rsi),%rax
  800639:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  80063d:	73 0a                	jae    800649 <sprintputch+0x1b>
        *state->start++ = ch;
  80063f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800643:	48 89 16             	mov    %rdx,(%rsi)
  800646:	40 88 38             	mov    %dil,(%rax)
    }
}
  800649:	c3                   	ret

000000000080064a <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  80064a:	f3 0f 1e fa          	endbr64
  80064e:	55                   	push   %rbp
  80064f:	48 89 e5             	mov    %rsp,%rbp
  800652:	48 83 ec 50          	sub    $0x50,%rsp
  800656:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80065a:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  80065e:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  800662:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800669:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80066d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800671:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800675:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  800679:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  80067d:	48 b8 8b 06 80 00 00 	movabs $0x80068b,%rax
  800684:	00 00 00 
  800687:	ff d0                	call   *%rax
}
  800689:	c9                   	leave
  80068a:	c3                   	ret

000000000080068b <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  80068b:	f3 0f 1e fa          	endbr64
  80068f:	55                   	push   %rbp
  800690:	48 89 e5             	mov    %rsp,%rbp
  800693:	41 57                	push   %r15
  800695:	41 56                	push   %r14
  800697:	41 55                	push   %r13
  800699:	41 54                	push   %r12
  80069b:	53                   	push   %rbx
  80069c:	48 83 ec 38          	sub    $0x38,%rsp
  8006a0:	49 89 fe             	mov    %rdi,%r14
  8006a3:	49 89 f5             	mov    %rsi,%r13
  8006a6:	48 89 d3             	mov    %rdx,%rbx
    va_copy(aq, ap);
  8006a9:	48 8b 01             	mov    (%rcx),%rax
  8006ac:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  8006b0:	48 8b 41 08          	mov    0x8(%rcx),%rax
  8006b4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8006b8:	48 8b 41 10          	mov    0x10(%rcx),%rax
  8006bc:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  8006c0:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  8006c4:	0f b6 3b             	movzbl (%rbx),%edi
  8006c7:	40 80 ff 25          	cmp    $0x25,%dil
  8006cb:	74 18                	je     8006e5 <vprintfmt+0x5a>
            if (!ch) return;
  8006cd:	40 84 ff             	test   %dil,%dil
  8006d0:	0f 84 b2 06 00 00    	je     800d88 <vprintfmt+0x6fd>
            putch(ch, put_arg);
  8006d6:	40 0f b6 ff          	movzbl %dil,%edi
  8006da:	4c 89 ee             	mov    %r13,%rsi
  8006dd:	41 ff d6             	call   *%r14
        while ((ch = *ufmt++) != '%') {
  8006e0:	4c 89 e3             	mov    %r12,%rbx
  8006e3:	eb db                	jmp    8006c0 <vprintfmt+0x35>
        bool altflag = 0, zflag = 0;
  8006e5:	be 00 00 00 00       	mov    $0x0,%esi
  8006ea:	c6 45 ab 00          	movb   $0x0,-0x55(%rbp)
        unsigned lflag = 0, base = 10;
  8006ee:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  8006f3:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  8006f9:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  800700:	c6 45 aa 20          	movb   $0x20,-0x56(%rbp)
        switch (ch = *ufmt++) {
  800704:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  800709:	41 0f b6 04 24       	movzbl (%r12),%eax
  80070e:	88 45 a0             	mov    %al,-0x60(%rbp)
  800711:	83 e8 23             	sub    $0x23,%eax
  800714:	3c 57                	cmp    $0x57,%al
  800716:	0f 87 52 06 00 00    	ja     800d6e <vprintfmt+0x6e3>
  80071c:	0f b6 c0             	movzbl %al,%eax
  80071f:	48 b9 20 45 80 00 00 	movabs $0x804520,%rcx
  800726:	00 00 00 
  800729:	3e ff 24 c1          	notrack jmp *(%rcx,%rax,8)
  80072d:	49 89 dc             	mov    %rbx,%r12
            altflag = 1;
  800730:	c6 45 ab 01          	movb   $0x1,-0x55(%rbp)
  800734:	eb ce                	jmp    800704 <vprintfmt+0x79>
        switch (ch = *ufmt++) {
  800736:	49 89 dc             	mov    %rbx,%r12
  800739:	be 01 00 00 00       	mov    $0x1,%esi
  80073e:	eb c4                	jmp    800704 <vprintfmt+0x79>
            padc = ch;
  800740:	0f b6 45 a0          	movzbl -0x60(%rbp),%eax
  800744:	88 45 aa             	mov    %al,-0x56(%rbp)
        switch (ch = *ufmt++) {
  800747:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  80074a:	eb b8                	jmp    800704 <vprintfmt+0x79>
            precision = va_arg(aq, int);
  80074c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80074f:	83 f8 2f             	cmp    $0x2f,%eax
  800752:	77 24                	ja     800778 <vprintfmt+0xed>
  800754:	89 c1                	mov    %eax,%ecx
  800756:	48 03 4d c8          	add    -0x38(%rbp),%rcx
  80075a:	83 c0 08             	add    $0x8,%eax
  80075d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800760:	44 8b 39             	mov    (%rcx),%r15d
        switch (ch = *ufmt++) {
  800763:	49 89 dc             	mov    %rbx,%r12
            if (width < 0) {
  800766:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  80076a:	79 98                	jns    800704 <vprintfmt+0x79>
                width = precision;
  80076c:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
                precision = -1;
  800770:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  800776:	eb 8c                	jmp    800704 <vprintfmt+0x79>
            precision = va_arg(aq, int);
  800778:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  80077c:	48 8d 41 08          	lea    0x8(%rcx),%rax
  800780:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800784:	eb da                	jmp    800760 <vprintfmt+0xd5>
                precision = precision * 10 + ch - '0';
  800786:	44 0f b6 7d a0       	movzbl -0x60(%rbp),%r15d
  80078b:	41 83 ef 30          	sub    $0x30,%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  80078f:	41 0f b6 44 24 01    	movzbl 0x1(%r12),%eax
  800795:	3c 39                	cmp    $0x39,%al
  800797:	77 1c                	ja     8007b5 <vprintfmt+0x12a>
            for (precision = 0;; ++ufmt) {
  800799:	48 83 c3 01          	add    $0x1,%rbx
                precision = precision * 10 + ch - '0';
  80079d:	43 8d 0c bf          	lea    (%r15,%r15,4),%ecx
  8007a1:	0f b6 c0             	movzbl %al,%eax
  8007a4:	44 8d 7c 48 d0       	lea    -0x30(%rax,%rcx,2),%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  8007a9:	0f b6 03             	movzbl (%rbx),%eax
  8007ac:	3c 39                	cmp    $0x39,%al
  8007ae:	76 e9                	jbe    800799 <vprintfmt+0x10e>
        process_precision:
  8007b0:	49 89 dc             	mov    %rbx,%r12
  8007b3:	eb b1                	jmp    800766 <vprintfmt+0xdb>
        switch (ch = *ufmt++) {
  8007b5:	49 89 dc             	mov    %rbx,%r12
  8007b8:	eb ac                	jmp    800766 <vprintfmt+0xdb>
            width = MAX(0, width);
  8007ba:	8b 4d ac             	mov    -0x54(%rbp),%ecx
  8007bd:	85 c9                	test   %ecx,%ecx
  8007bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8007c4:	0f 49 c1             	cmovns %ecx,%eax
  8007c7:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  8007ca:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  8007cd:	e9 32 ff ff ff       	jmp    800704 <vprintfmt+0x79>
            lflag++;
  8007d2:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  8007d5:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  8007d8:	e9 27 ff ff ff       	jmp    800704 <vprintfmt+0x79>
            putch(va_arg(aq, int), put_arg);
  8007dd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007e0:	83 f8 2f             	cmp    $0x2f,%eax
  8007e3:	77 19                	ja     8007fe <vprintfmt+0x173>
  8007e5:	89 c2                	mov    %eax,%edx
  8007e7:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8007eb:	83 c0 08             	add    $0x8,%eax
  8007ee:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007f1:	8b 3a                	mov    (%rdx),%edi
  8007f3:	4c 89 ee             	mov    %r13,%rsi
  8007f6:	41 ff d6             	call   *%r14
            break;
  8007f9:	e9 c2 fe ff ff       	jmp    8006c0 <vprintfmt+0x35>
            putch(va_arg(aq, int), put_arg);
  8007fe:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800802:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800806:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80080a:	eb e5                	jmp    8007f1 <vprintfmt+0x166>
            int err = va_arg(aq, int);
  80080c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80080f:	83 f8 2f             	cmp    $0x2f,%eax
  800812:	77 5a                	ja     80086e <vprintfmt+0x1e3>
  800814:	89 c2                	mov    %eax,%edx
  800816:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80081a:	83 c0 08             	add    $0x8,%eax
  80081d:	89 45 b8             	mov    %eax,-0x48(%rbp)
            if (err < 0) err = -err;
  800820:	8b 02                	mov    (%rdx),%eax
  800822:	89 c1                	mov    %eax,%ecx
  800824:	f7 d9                	neg    %ecx
  800826:	0f 48 c8             	cmovs  %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  800829:	83 f9 13             	cmp    $0x13,%ecx
  80082c:	7f 4e                	jg     80087c <vprintfmt+0x1f1>
  80082e:	48 63 c1             	movslq %ecx,%rax
  800831:	48 ba e0 47 80 00 00 	movabs $0x8047e0,%rdx
  800838:	00 00 00 
  80083b:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80083f:	48 85 c0             	test   %rax,%rax
  800842:	74 38                	je     80087c <vprintfmt+0x1f1>
                printfmt(putch, put_arg, "%s", strerr);
  800844:	48 89 c1             	mov    %rax,%rcx
  800847:	48 ba a3 42 80 00 00 	movabs $0x8042a3,%rdx
  80084e:	00 00 00 
  800851:	4c 89 ee             	mov    %r13,%rsi
  800854:	4c 89 f7             	mov    %r14,%rdi
  800857:	b8 00 00 00 00       	mov    $0x0,%eax
  80085c:	49 b8 4a 06 80 00 00 	movabs $0x80064a,%r8
  800863:	00 00 00 
  800866:	41 ff d0             	call   *%r8
  800869:	e9 52 fe ff ff       	jmp    8006c0 <vprintfmt+0x35>
            int err = va_arg(aq, int);
  80086e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800872:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800876:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80087a:	eb a4                	jmp    800820 <vprintfmt+0x195>
                printfmt(putch, put_arg, "error %d", err);
  80087c:	48 ba a1 40 80 00 00 	movabs $0x8040a1,%rdx
  800883:	00 00 00 
  800886:	4c 89 ee             	mov    %r13,%rsi
  800889:	4c 89 f7             	mov    %r14,%rdi
  80088c:	b8 00 00 00 00       	mov    $0x0,%eax
  800891:	49 b8 4a 06 80 00 00 	movabs $0x80064a,%r8
  800898:	00 00 00 
  80089b:	41 ff d0             	call   *%r8
  80089e:	e9 1d fe ff ff       	jmp    8006c0 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  8008a3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008a6:	83 f8 2f             	cmp    $0x2f,%eax
  8008a9:	77 6c                	ja     800917 <vprintfmt+0x28c>
  8008ab:	89 c2                	mov    %eax,%edx
  8008ad:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8008b1:	83 c0 08             	add    $0x8,%eax
  8008b4:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008b7:	48 8b 12             	mov    (%rdx),%rdx
            if (!ptr) ptr = "(null)";
  8008ba:	48 85 d2             	test   %rdx,%rdx
  8008bd:	48 b8 9a 40 80 00 00 	movabs $0x80409a,%rax
  8008c4:	00 00 00 
  8008c7:	48 0f 45 c2          	cmovne %rdx,%rax
  8008cb:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
            if (width > 0 && padc != '-') {
  8008cf:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8008d3:	7e 06                	jle    8008db <vprintfmt+0x250>
  8008d5:	80 7d aa 2d          	cmpb   $0x2d,-0x56(%rbp)
  8008d9:	75 4a                	jne    800925 <vprintfmt+0x29a>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  8008db:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8008df:	4c 8d 60 01          	lea    0x1(%rax),%r12
  8008e3:	0f b6 00             	movzbl (%rax),%eax
  8008e6:	84 c0                	test   %al,%al
  8008e8:	0f 85 9a 00 00 00    	jne    800988 <vprintfmt+0x2fd>
            while (width-- > 0) putch(' ', put_arg);
  8008ee:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8008f1:	44 8d 60 ff          	lea    -0x1(%rax),%r12d
  8008f5:	85 c0                	test   %eax,%eax
  8008f7:	0f 8e c3 fd ff ff    	jle    8006c0 <vprintfmt+0x35>
  8008fd:	4c 89 ee             	mov    %r13,%rsi
  800900:	bf 20 00 00 00       	mov    $0x20,%edi
  800905:	41 ff d6             	call   *%r14
  800908:	41 83 ec 01          	sub    $0x1,%r12d
  80090c:	41 83 fc ff          	cmp    $0xffffffff,%r12d
  800910:	75 eb                	jne    8008fd <vprintfmt+0x272>
  800912:	e9 a9 fd ff ff       	jmp    8006c0 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  800917:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80091b:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80091f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800923:	eb 92                	jmp    8008b7 <vprintfmt+0x22c>
                width -= strnlen(ptr, precision);
  800925:	49 63 f7             	movslq %r15d,%rsi
  800928:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  80092c:	48 b8 4e 0e 80 00 00 	movabs $0x800e4e,%rax
  800933:	00 00 00 
  800936:	ff d0                	call   *%rax
  800938:	48 89 c2             	mov    %rax,%rdx
  80093b:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80093e:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  800940:	8d 70 ff             	lea    -0x1(%rax),%esi
  800943:	89 75 ac             	mov    %esi,-0x54(%rbp)
  800946:	85 c0                	test   %eax,%eax
  800948:	7e 91                	jle    8008db <vprintfmt+0x250>
  80094a:	44 0f be 65 aa       	movsbl -0x56(%rbp),%r12d
  80094f:	4c 89 ee             	mov    %r13,%rsi
  800952:	44 89 e7             	mov    %r12d,%edi
  800955:	41 ff d6             	call   *%r14
  800958:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  80095c:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80095f:	83 f8 ff             	cmp    $0xffffffff,%eax
  800962:	75 eb                	jne    80094f <vprintfmt+0x2c4>
  800964:	e9 72 ff ff ff       	jmp    8008db <vprintfmt+0x250>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800969:	0f b6 f8             	movzbl %al,%edi
  80096c:	4c 89 ee             	mov    %r13,%rsi
  80096f:	41 ff d6             	call   *%r14
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800972:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  800976:	49 83 c4 01          	add    $0x1,%r12
  80097a:	41 0f b6 44 24 ff    	movzbl -0x1(%r12),%eax
  800980:	84 c0                	test   %al,%al
  800982:	0f 84 66 ff ff ff    	je     8008ee <vprintfmt+0x263>
  800988:	45 85 ff             	test   %r15d,%r15d
  80098b:	78 0a                	js     800997 <vprintfmt+0x30c>
  80098d:	41 83 ef 01          	sub    $0x1,%r15d
  800991:	0f 88 57 ff ff ff    	js     8008ee <vprintfmt+0x263>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800997:	80 7d ab 00          	cmpb   $0x0,-0x55(%rbp)
  80099b:	74 cc                	je     800969 <vprintfmt+0x2de>
  80099d:	8d 50 e0             	lea    -0x20(%rax),%edx
  8009a0:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8009a5:	80 fa 5e             	cmp    $0x5e,%dl
  8009a8:	77 c2                	ja     80096c <vprintfmt+0x2e1>
  8009aa:	eb bd                	jmp    800969 <vprintfmt+0x2de>
    if (zflag) return va_arg(*ap, size_t);
  8009ac:	40 84 f6             	test   %sil,%sil
  8009af:	75 26                	jne    8009d7 <vprintfmt+0x34c>
    switch (lflag) {
  8009b1:	85 d2                	test   %edx,%edx
  8009b3:	74 59                	je     800a0e <vprintfmt+0x383>
  8009b5:	83 fa 01             	cmp    $0x1,%edx
  8009b8:	74 7b                	je     800a35 <vprintfmt+0x3aa>
        return va_arg(*ap, long long);
  8009ba:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009bd:	83 f8 2f             	cmp    $0x2f,%eax
  8009c0:	0f 87 96 00 00 00    	ja     800a5c <vprintfmt+0x3d1>
  8009c6:	89 c2                	mov    %eax,%edx
  8009c8:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8009cc:	83 c0 08             	add    $0x8,%eax
  8009cf:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009d2:	4c 8b 22             	mov    (%rdx),%r12
  8009d5:	eb 17                	jmp    8009ee <vprintfmt+0x363>
    if (zflag) return va_arg(*ap, size_t);
  8009d7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009da:	83 f8 2f             	cmp    $0x2f,%eax
  8009dd:	77 21                	ja     800a00 <vprintfmt+0x375>
  8009df:	89 c2                	mov    %eax,%edx
  8009e1:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8009e5:	83 c0 08             	add    $0x8,%eax
  8009e8:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009eb:	4c 8b 22             	mov    (%rdx),%r12
            if (i < 0) {
  8009ee:	4d 85 e4             	test   %r12,%r12
  8009f1:	78 7a                	js     800a6d <vprintfmt+0x3e2>
            num = i;
  8009f3:	4c 89 e2             	mov    %r12,%rdx
        unsigned lflag = 0, base = 10;
  8009f6:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  8009fb:	e9 50 02 00 00       	jmp    800c50 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800a00:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a04:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a08:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a0c:	eb dd                	jmp    8009eb <vprintfmt+0x360>
        return va_arg(*ap, int);
  800a0e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a11:	83 f8 2f             	cmp    $0x2f,%eax
  800a14:	77 11                	ja     800a27 <vprintfmt+0x39c>
  800a16:	89 c2                	mov    %eax,%edx
  800a18:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a1c:	83 c0 08             	add    $0x8,%eax
  800a1f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a22:	4c 63 22             	movslq (%rdx),%r12
  800a25:	eb c7                	jmp    8009ee <vprintfmt+0x363>
  800a27:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a2b:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a2f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a33:	eb ed                	jmp    800a22 <vprintfmt+0x397>
        return va_arg(*ap, long);
  800a35:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a38:	83 f8 2f             	cmp    $0x2f,%eax
  800a3b:	77 11                	ja     800a4e <vprintfmt+0x3c3>
  800a3d:	89 c2                	mov    %eax,%edx
  800a3f:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a43:	83 c0 08             	add    $0x8,%eax
  800a46:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a49:	4c 8b 22             	mov    (%rdx),%r12
  800a4c:	eb a0                	jmp    8009ee <vprintfmt+0x363>
  800a4e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a52:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a56:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a5a:	eb ed                	jmp    800a49 <vprintfmt+0x3be>
        return va_arg(*ap, long long);
  800a5c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a60:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a64:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a68:	e9 65 ff ff ff       	jmp    8009d2 <vprintfmt+0x347>
                putch('-', put_arg);
  800a6d:	4c 89 ee             	mov    %r13,%rsi
  800a70:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800a75:	41 ff d6             	call   *%r14
                i = -i;
  800a78:	49 f7 dc             	neg    %r12
  800a7b:	e9 73 ff ff ff       	jmp    8009f3 <vprintfmt+0x368>
    if (zflag) return va_arg(*ap, size_t);
  800a80:	40 84 f6             	test   %sil,%sil
  800a83:	75 32                	jne    800ab7 <vprintfmt+0x42c>
    switch (lflag) {
  800a85:	85 d2                	test   %edx,%edx
  800a87:	74 5d                	je     800ae6 <vprintfmt+0x45b>
  800a89:	83 fa 01             	cmp    $0x1,%edx
  800a8c:	0f 84 82 00 00 00    	je     800b14 <vprintfmt+0x489>
        return va_arg(*ap, unsigned long long);
  800a92:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a95:	83 f8 2f             	cmp    $0x2f,%eax
  800a98:	0f 87 a5 00 00 00    	ja     800b43 <vprintfmt+0x4b8>
  800a9e:	89 c2                	mov    %eax,%edx
  800aa0:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800aa4:	83 c0 08             	add    $0x8,%eax
  800aa7:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800aaa:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800aad:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  800ab2:	e9 99 01 00 00       	jmp    800c50 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800ab7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aba:	83 f8 2f             	cmp    $0x2f,%eax
  800abd:	77 19                	ja     800ad8 <vprintfmt+0x44d>
  800abf:	89 c2                	mov    %eax,%edx
  800ac1:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800ac5:	83 c0 08             	add    $0x8,%eax
  800ac8:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800acb:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800ace:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800ad3:	e9 78 01 00 00       	jmp    800c50 <vprintfmt+0x5c5>
  800ad8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800adc:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800ae0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ae4:	eb e5                	jmp    800acb <vprintfmt+0x440>
        return va_arg(*ap, unsigned int);
  800ae6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ae9:	83 f8 2f             	cmp    $0x2f,%eax
  800aec:	77 18                	ja     800b06 <vprintfmt+0x47b>
  800aee:	89 c2                	mov    %eax,%edx
  800af0:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800af4:	83 c0 08             	add    $0x8,%eax
  800af7:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800afa:	8b 12                	mov    (%rdx),%edx
        unsigned lflag = 0, base = 10;
  800afc:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  800b01:	e9 4a 01 00 00       	jmp    800c50 <vprintfmt+0x5c5>
  800b06:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b0a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b0e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b12:	eb e6                	jmp    800afa <vprintfmt+0x46f>
        return va_arg(*ap, unsigned long);
  800b14:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b17:	83 f8 2f             	cmp    $0x2f,%eax
  800b1a:	77 19                	ja     800b35 <vprintfmt+0x4aa>
  800b1c:	89 c2                	mov    %eax,%edx
  800b1e:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b22:	83 c0 08             	add    $0x8,%eax
  800b25:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b28:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800b2b:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  800b30:	e9 1b 01 00 00       	jmp    800c50 <vprintfmt+0x5c5>
  800b35:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b39:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b3d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b41:	eb e5                	jmp    800b28 <vprintfmt+0x49d>
        return va_arg(*ap, unsigned long long);
  800b43:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b47:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b4b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b4f:	e9 56 ff ff ff       	jmp    800aaa <vprintfmt+0x41f>
    if (zflag) return va_arg(*ap, size_t);
  800b54:	40 84 f6             	test   %sil,%sil
  800b57:	75 2e                	jne    800b87 <vprintfmt+0x4fc>
    switch (lflag) {
  800b59:	85 d2                	test   %edx,%edx
  800b5b:	74 59                	je     800bb6 <vprintfmt+0x52b>
  800b5d:	83 fa 01             	cmp    $0x1,%edx
  800b60:	74 7f                	je     800be1 <vprintfmt+0x556>
        return va_arg(*ap, unsigned long long);
  800b62:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b65:	83 f8 2f             	cmp    $0x2f,%eax
  800b68:	0f 87 9f 00 00 00    	ja     800c0d <vprintfmt+0x582>
  800b6e:	89 c2                	mov    %eax,%edx
  800b70:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b74:	83 c0 08             	add    $0x8,%eax
  800b77:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b7a:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800b7d:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  800b82:	e9 c9 00 00 00       	jmp    800c50 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800b87:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b8a:	83 f8 2f             	cmp    $0x2f,%eax
  800b8d:	77 19                	ja     800ba8 <vprintfmt+0x51d>
  800b8f:	89 c2                	mov    %eax,%edx
  800b91:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b95:	83 c0 08             	add    $0x8,%eax
  800b98:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b9b:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800b9e:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800ba3:	e9 a8 00 00 00       	jmp    800c50 <vprintfmt+0x5c5>
  800ba8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bac:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800bb0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800bb4:	eb e5                	jmp    800b9b <vprintfmt+0x510>
        return va_arg(*ap, unsigned int);
  800bb6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bb9:	83 f8 2f             	cmp    $0x2f,%eax
  800bbc:	77 15                	ja     800bd3 <vprintfmt+0x548>
  800bbe:	89 c2                	mov    %eax,%edx
  800bc0:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800bc4:	83 c0 08             	add    $0x8,%eax
  800bc7:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800bca:	8b 12                	mov    (%rdx),%edx
            base = 8;
  800bcc:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  800bd1:	eb 7d                	jmp    800c50 <vprintfmt+0x5c5>
  800bd3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bd7:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800bdb:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800bdf:	eb e9                	jmp    800bca <vprintfmt+0x53f>
        return va_arg(*ap, unsigned long);
  800be1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800be4:	83 f8 2f             	cmp    $0x2f,%eax
  800be7:	77 16                	ja     800bff <vprintfmt+0x574>
  800be9:	89 c2                	mov    %eax,%edx
  800beb:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800bef:	83 c0 08             	add    $0x8,%eax
  800bf2:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800bf5:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800bf8:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  800bfd:	eb 51                	jmp    800c50 <vprintfmt+0x5c5>
  800bff:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c03:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800c07:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c0b:	eb e8                	jmp    800bf5 <vprintfmt+0x56a>
        return va_arg(*ap, unsigned long long);
  800c0d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c11:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800c15:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c19:	e9 5c ff ff ff       	jmp    800b7a <vprintfmt+0x4ef>
            putch('0', put_arg);
  800c1e:	4c 89 ee             	mov    %r13,%rsi
  800c21:	bf 30 00 00 00       	mov    $0x30,%edi
  800c26:	41 ff d6             	call   *%r14
            putch('x', put_arg);
  800c29:	4c 89 ee             	mov    %r13,%rsi
  800c2c:	bf 78 00 00 00       	mov    $0x78,%edi
  800c31:	41 ff d6             	call   *%r14
            num = (uintptr_t)va_arg(aq, void *);
  800c34:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c37:	83 f8 2f             	cmp    $0x2f,%eax
  800c3a:	77 47                	ja     800c83 <vprintfmt+0x5f8>
  800c3c:	89 c2                	mov    %eax,%edx
  800c3e:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800c42:	83 c0 08             	add    $0x8,%eax
  800c45:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c48:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800c4b:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  800c50:	48 83 ec 08          	sub    $0x8,%rsp
  800c54:	80 7d a0 58          	cmpb   $0x58,-0x60(%rbp)
  800c58:	0f 94 c0             	sete   %al
  800c5b:	0f b6 c0             	movzbl %al,%eax
  800c5e:	50                   	push   %rax
  800c5f:	44 0f be 4d aa       	movsbl -0x56(%rbp),%r9d
  800c64:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  800c68:	4c 89 ee             	mov    %r13,%rsi
  800c6b:	4c 89 f7             	mov    %r14,%rdi
  800c6e:	48 b8 74 05 80 00 00 	movabs $0x800574,%rax
  800c75:	00 00 00 
  800c78:	ff d0                	call   *%rax
            break;
  800c7a:	48 83 c4 10          	add    $0x10,%rsp
  800c7e:	e9 3d fa ff ff       	jmp    8006c0 <vprintfmt+0x35>
            num = (uintptr_t)va_arg(aq, void *);
  800c83:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c87:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800c8b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c8f:	eb b7                	jmp    800c48 <vprintfmt+0x5bd>
    if (zflag) return va_arg(*ap, size_t);
  800c91:	40 84 f6             	test   %sil,%sil
  800c94:	75 2b                	jne    800cc1 <vprintfmt+0x636>
    switch (lflag) {
  800c96:	85 d2                	test   %edx,%edx
  800c98:	74 56                	je     800cf0 <vprintfmt+0x665>
  800c9a:	83 fa 01             	cmp    $0x1,%edx
  800c9d:	74 7f                	je     800d1e <vprintfmt+0x693>
        return va_arg(*ap, unsigned long long);
  800c9f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ca2:	83 f8 2f             	cmp    $0x2f,%eax
  800ca5:	0f 87 a2 00 00 00    	ja     800d4d <vprintfmt+0x6c2>
  800cab:	89 c2                	mov    %eax,%edx
  800cad:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800cb1:	83 c0 08             	add    $0x8,%eax
  800cb4:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800cb7:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800cba:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800cbf:	eb 8f                	jmp    800c50 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800cc1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cc4:	83 f8 2f             	cmp    $0x2f,%eax
  800cc7:	77 19                	ja     800ce2 <vprintfmt+0x657>
  800cc9:	89 c2                	mov    %eax,%edx
  800ccb:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800ccf:	83 c0 08             	add    $0x8,%eax
  800cd2:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800cd5:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800cd8:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800cdd:	e9 6e ff ff ff       	jmp    800c50 <vprintfmt+0x5c5>
  800ce2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ce6:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800cea:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800cee:	eb e5                	jmp    800cd5 <vprintfmt+0x64a>
        return va_arg(*ap, unsigned int);
  800cf0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cf3:	83 f8 2f             	cmp    $0x2f,%eax
  800cf6:	77 18                	ja     800d10 <vprintfmt+0x685>
  800cf8:	89 c2                	mov    %eax,%edx
  800cfa:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800cfe:	83 c0 08             	add    $0x8,%eax
  800d01:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800d04:	8b 12                	mov    (%rdx),%edx
            base = 16;
  800d06:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  800d0b:	e9 40 ff ff ff       	jmp    800c50 <vprintfmt+0x5c5>
  800d10:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d14:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800d18:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800d1c:	eb e6                	jmp    800d04 <vprintfmt+0x679>
        return va_arg(*ap, unsigned long);
  800d1e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d21:	83 f8 2f             	cmp    $0x2f,%eax
  800d24:	77 19                	ja     800d3f <vprintfmt+0x6b4>
  800d26:	89 c2                	mov    %eax,%edx
  800d28:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800d2c:	83 c0 08             	add    $0x8,%eax
  800d2f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800d32:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800d35:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800d3a:	e9 11 ff ff ff       	jmp    800c50 <vprintfmt+0x5c5>
  800d3f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d43:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800d47:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800d4b:	eb e5                	jmp    800d32 <vprintfmt+0x6a7>
        return va_arg(*ap, unsigned long long);
  800d4d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d51:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800d55:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800d59:	e9 59 ff ff ff       	jmp    800cb7 <vprintfmt+0x62c>
            putch(ch, put_arg);
  800d5e:	4c 89 ee             	mov    %r13,%rsi
  800d61:	bf 25 00 00 00       	mov    $0x25,%edi
  800d66:	41 ff d6             	call   *%r14
            break;
  800d69:	e9 52 f9 ff ff       	jmp    8006c0 <vprintfmt+0x35>
            putch('%', put_arg);
  800d6e:	4c 89 ee             	mov    %r13,%rsi
  800d71:	bf 25 00 00 00       	mov    $0x25,%edi
  800d76:	41 ff d6             	call   *%r14
            while ((--ufmt)[-1] != '%') /* nothing */
  800d79:	48 83 eb 01          	sub    $0x1,%rbx
  800d7d:	80 7b ff 25          	cmpb   $0x25,-0x1(%rbx)
  800d81:	75 f6                	jne    800d79 <vprintfmt+0x6ee>
  800d83:	e9 38 f9 ff ff       	jmp    8006c0 <vprintfmt+0x35>
}
  800d88:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800d8c:	5b                   	pop    %rbx
  800d8d:	41 5c                	pop    %r12
  800d8f:	41 5d                	pop    %r13
  800d91:	41 5e                	pop    %r14
  800d93:	41 5f                	pop    %r15
  800d95:	5d                   	pop    %rbp
  800d96:	c3                   	ret

0000000000800d97 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800d97:	f3 0f 1e fa          	endbr64
  800d9b:	55                   	push   %rbp
  800d9c:	48 89 e5             	mov    %rsp,%rbp
  800d9f:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800da3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800da7:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800dac:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800db0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800db7:	48 85 ff             	test   %rdi,%rdi
  800dba:	74 2b                	je     800de7 <vsnprintf+0x50>
  800dbc:	48 85 f6             	test   %rsi,%rsi
  800dbf:	74 26                	je     800de7 <vsnprintf+0x50>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800dc1:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800dc5:	48 bf 2e 06 80 00 00 	movabs $0x80062e,%rdi
  800dcc:	00 00 00 
  800dcf:	48 b8 8b 06 80 00 00 	movabs $0x80068b,%rax
  800dd6:	00 00 00 
  800dd9:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800ddb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ddf:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800de2:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800de5:	c9                   	leave
  800de6:	c3                   	ret
    if (!buf || n < 1) return -E_INVAL;
  800de7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800dec:	eb f7                	jmp    800de5 <vsnprintf+0x4e>

0000000000800dee <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800dee:	f3 0f 1e fa          	endbr64
  800df2:	55                   	push   %rbp
  800df3:	48 89 e5             	mov    %rsp,%rbp
  800df6:	48 83 ec 50          	sub    $0x50,%rsp
  800dfa:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800dfe:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800e02:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800e06:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800e0d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e11:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800e15:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800e19:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800e1d:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800e21:	48 b8 97 0d 80 00 00 	movabs $0x800d97,%rax
  800e28:	00 00 00 
  800e2b:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800e2d:	c9                   	leave
  800e2e:	c3                   	ret

0000000000800e2f <strlen>:
 * Primespipe runs 3x faster this way */

#define ASM 1

size_t
strlen(const char *s) {
  800e2f:	f3 0f 1e fa          	endbr64
    size_t n = 0;
    while (*s++) n++;
  800e33:	80 3f 00             	cmpb   $0x0,(%rdi)
  800e36:	74 10                	je     800e48 <strlen+0x19>
    size_t n = 0;
  800e38:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800e3d:	48 83 c0 01          	add    $0x1,%rax
  800e41:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800e45:	75 f6                	jne    800e3d <strlen+0xe>
  800e47:	c3                   	ret
    size_t n = 0;
  800e48:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800e4d:	c3                   	ret

0000000000800e4e <strnlen>:

size_t
strnlen(const char *s, size_t size) {
  800e4e:	f3 0f 1e fa          	endbr64
  800e52:	48 89 f0             	mov    %rsi,%rax
    size_t n = 0;
  800e55:	ba 00 00 00 00       	mov    $0x0,%edx
    while (n < size && *s++) n++;
  800e5a:	48 85 f6             	test   %rsi,%rsi
  800e5d:	74 10                	je     800e6f <strnlen+0x21>
  800e5f:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  800e63:	74 0b                	je     800e70 <strnlen+0x22>
  800e65:	48 83 c2 01          	add    $0x1,%rdx
  800e69:	48 39 d0             	cmp    %rdx,%rax
  800e6c:	75 f1                	jne    800e5f <strnlen+0x11>
  800e6e:	c3                   	ret
  800e6f:	c3                   	ret
  800e70:	48 89 d0             	mov    %rdx,%rax
    return n;
}
  800e73:	c3                   	ret

0000000000800e74 <strcpy>:

char *
strcpy(char *dst, const char *src) {
  800e74:	f3 0f 1e fa          	endbr64
  800e78:	48 89 f8             	mov    %rdi,%rax
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800e7b:	ba 00 00 00 00       	mov    $0x0,%edx
  800e80:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  800e84:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  800e87:	48 83 c2 01          	add    $0x1,%rdx
  800e8b:	84 c9                	test   %cl,%cl
  800e8d:	75 f1                	jne    800e80 <strcpy+0xc>
        ;
    return res;
}
  800e8f:	c3                   	ret

0000000000800e90 <strcat>:

char *
strcat(char *dst, const char *src) {
  800e90:	f3 0f 1e fa          	endbr64
  800e94:	55                   	push   %rbp
  800e95:	48 89 e5             	mov    %rsp,%rbp
  800e98:	41 54                	push   %r12
  800e9a:	53                   	push   %rbx
  800e9b:	48 89 fb             	mov    %rdi,%rbx
  800e9e:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800ea1:	48 b8 2f 0e 80 00 00 	movabs $0x800e2f,%rax
  800ea8:	00 00 00 
  800eab:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800ead:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800eb1:	4c 89 e6             	mov    %r12,%rsi
  800eb4:	48 b8 74 0e 80 00 00 	movabs $0x800e74,%rax
  800ebb:	00 00 00 
  800ebe:	ff d0                	call   *%rax
    return dst;
}
  800ec0:	48 89 d8             	mov    %rbx,%rax
  800ec3:	5b                   	pop    %rbx
  800ec4:	41 5c                	pop    %r12
  800ec6:	5d                   	pop    %rbp
  800ec7:	c3                   	ret

0000000000800ec8 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800ec8:	f3 0f 1e fa          	endbr64
  800ecc:	48 89 f8             	mov    %rdi,%rax
    char *ret = dst;
    while (size-- > 0) {
  800ecf:	48 85 d2             	test   %rdx,%rdx
  800ed2:	74 1f                	je     800ef3 <strncpy+0x2b>
  800ed4:	48 01 fa             	add    %rdi,%rdx
  800ed7:	48 89 f9             	mov    %rdi,%rcx
        *dst++ = *src;
  800eda:	48 83 c1 01          	add    $0x1,%rcx
  800ede:	44 0f b6 06          	movzbl (%rsi),%r8d
  800ee2:	44 88 41 ff          	mov    %r8b,-0x1(%rcx)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800ee6:	41 80 f8 01          	cmp    $0x1,%r8b
  800eea:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800eee:	48 39 ca             	cmp    %rcx,%rdx
  800ef1:	75 e7                	jne    800eda <strncpy+0x12>
    }
    return ret;
}
  800ef3:	c3                   	ret

0000000000800ef4 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
  800ef4:	f3 0f 1e fa          	endbr64
    char *dst_in = dst;
    if (size) {
  800ef8:	48 89 f8             	mov    %rdi,%rax
  800efb:	48 85 d2             	test   %rdx,%rdx
  800efe:	74 24                	je     800f24 <strlcpy+0x30>
        while (--size > 0 && *src)
  800f00:	48 83 ea 01          	sub    $0x1,%rdx
  800f04:	74 1b                	je     800f21 <strlcpy+0x2d>
  800f06:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800f0a:	0f b6 16             	movzbl (%rsi),%edx
  800f0d:	84 d2                	test   %dl,%dl
  800f0f:	74 10                	je     800f21 <strlcpy+0x2d>
            *dst++ = *src++;
  800f11:	48 83 c6 01          	add    $0x1,%rsi
  800f15:	48 83 c0 01          	add    $0x1,%rax
  800f19:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800f1c:	48 39 c8             	cmp    %rcx,%rax
  800f1f:	75 e9                	jne    800f0a <strlcpy+0x16>
        *dst = '\0';
  800f21:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800f24:	48 29 f8             	sub    %rdi,%rax
}
  800f27:	c3                   	ret

0000000000800f28 <strcmp>:
    }
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
  800f28:	f3 0f 1e fa          	endbr64
    while (*p && *p == *q) p++, q++;
  800f2c:	0f b6 07             	movzbl (%rdi),%eax
  800f2f:	84 c0                	test   %al,%al
  800f31:	74 13                	je     800f46 <strcmp+0x1e>
  800f33:	38 06                	cmp    %al,(%rsi)
  800f35:	75 0f                	jne    800f46 <strcmp+0x1e>
  800f37:	48 83 c7 01          	add    $0x1,%rdi
  800f3b:	48 83 c6 01          	add    $0x1,%rsi
  800f3f:	0f b6 07             	movzbl (%rdi),%eax
  800f42:	84 c0                	test   %al,%al
  800f44:	75 ed                	jne    800f33 <strcmp+0xb>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800f46:	0f b6 c0             	movzbl %al,%eax
  800f49:	0f b6 16             	movzbl (%rsi),%edx
  800f4c:	29 d0                	sub    %edx,%eax
}
  800f4e:	c3                   	ret

0000000000800f4f <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
  800f4f:	f3 0f 1e fa          	endbr64
    while (n && *p && *p == *q) n--, p++, q++;
  800f53:	48 85 d2             	test   %rdx,%rdx
  800f56:	74 1f                	je     800f77 <strncmp+0x28>
  800f58:	0f b6 07             	movzbl (%rdi),%eax
  800f5b:	84 c0                	test   %al,%al
  800f5d:	74 1e                	je     800f7d <strncmp+0x2e>
  800f5f:	3a 06                	cmp    (%rsi),%al
  800f61:	75 1a                	jne    800f7d <strncmp+0x2e>
  800f63:	48 83 c7 01          	add    $0x1,%rdi
  800f67:	48 83 c6 01          	add    $0x1,%rsi
  800f6b:	48 83 ea 01          	sub    $0x1,%rdx
  800f6f:	75 e7                	jne    800f58 <strncmp+0x9>

    if (!n) return 0;
  800f71:	b8 00 00 00 00       	mov    $0x0,%eax
  800f76:	c3                   	ret
  800f77:	b8 00 00 00 00       	mov    $0x0,%eax
  800f7c:	c3                   	ret

    return (int)((unsigned char)*p - (unsigned char)*q);
  800f7d:	0f b6 07             	movzbl (%rdi),%eax
  800f80:	0f b6 16             	movzbl (%rsi),%edx
  800f83:	29 d0                	sub    %edx,%eax
}
  800f85:	c3                   	ret

0000000000800f86 <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
  800f86:	f3 0f 1e fa          	endbr64
    for (; *str; str++) {
  800f8a:	0f b6 17             	movzbl (%rdi),%edx
  800f8d:	84 d2                	test   %dl,%dl
  800f8f:	74 18                	je     800fa9 <strchr+0x23>
        if (*str == c) {
  800f91:	0f be d2             	movsbl %dl,%edx
  800f94:	39 f2                	cmp    %esi,%edx
  800f96:	74 17                	je     800faf <strchr+0x29>
    for (; *str; str++) {
  800f98:	48 83 c7 01          	add    $0x1,%rdi
  800f9c:	0f b6 17             	movzbl (%rdi),%edx
  800f9f:	84 d2                	test   %dl,%dl
  800fa1:	75 ee                	jne    800f91 <strchr+0xb>
            return (char *)str;
        }
    }
    return NULL;
  800fa3:	b8 00 00 00 00       	mov    $0x0,%eax
  800fa8:	c3                   	ret
  800fa9:	b8 00 00 00 00       	mov    $0x0,%eax
  800fae:	c3                   	ret
            return (char *)str;
  800faf:	48 89 f8             	mov    %rdi,%rax
}
  800fb2:	c3                   	ret

0000000000800fb3 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
  800fb3:	f3 0f 1e fa          	endbr64
  800fb7:	48 89 f8             	mov    %rdi,%rax
    for (; *str && *str != ch; str++) /* nothing */
  800fba:	0f b6 17             	movzbl (%rdi),%edx
  800fbd:	84 d2                	test   %dl,%dl
  800fbf:	74 13                	je     800fd4 <strfind+0x21>
  800fc1:	0f be d2             	movsbl %dl,%edx
  800fc4:	39 f2                	cmp    %esi,%edx
  800fc6:	74 0b                	je     800fd3 <strfind+0x20>
  800fc8:	48 83 c0 01          	add    $0x1,%rax
  800fcc:	0f b6 10             	movzbl (%rax),%edx
  800fcf:	84 d2                	test   %dl,%dl
  800fd1:	75 ee                	jne    800fc1 <strfind+0xe>
        ;
    return (char *)str;
}
  800fd3:	c3                   	ret
  800fd4:	c3                   	ret

0000000000800fd5 <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  800fd5:	f3 0f 1e fa          	endbr64
  800fd9:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  800fdc:	48 89 f8             	mov    %rdi,%rax
  800fdf:	48 f7 d8             	neg    %rax
  800fe2:	83 e0 07             	and    $0x7,%eax
  800fe5:	49 89 d1             	mov    %rdx,%r9
  800fe8:	49 29 c1             	sub    %rax,%r9
  800feb:	78 36                	js     801023 <memset+0x4e>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  800fed:	40 0f b6 c6          	movzbl %sil,%eax
  800ff1:	48 b9 01 01 01 01 01 	movabs $0x101010101010101,%rcx
  800ff8:	01 01 01 
  800ffb:	48 0f af c1          	imul   %rcx,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  800fff:	40 f6 c7 07          	test   $0x7,%dil
  801003:	75 38                	jne    80103d <memset+0x68>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  801005:	4c 89 c9             	mov    %r9,%rcx
  801008:	48 c1 f9 03          	sar    $0x3,%rcx
  80100c:	74 0c                	je     80101a <memset+0x45>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  80100e:	fc                   	cld
  80100f:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  801012:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  801016:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  80101a:	4d 85 c9             	test   %r9,%r9
  80101d:	75 45                	jne    801064 <memset+0x8f>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  80101f:	4c 89 c0             	mov    %r8,%rax
  801022:	c3                   	ret
        while (n-- > 0) *ptr++ = c;
  801023:	48 85 d2             	test   %rdx,%rdx
  801026:	74 f7                	je     80101f <memset+0x4a>
  801028:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  80102b:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  80102e:	48 83 c0 01          	add    $0x1,%rax
  801032:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  801036:	48 39 c2             	cmp    %rax,%rdx
  801039:	75 f3                	jne    80102e <memset+0x59>
  80103b:	eb e2                	jmp    80101f <memset+0x4a>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  80103d:	40 f6 c7 01          	test   $0x1,%dil
  801041:	74 06                	je     801049 <memset+0x74>
  801043:	88 07                	mov    %al,(%rdi)
  801045:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  801049:	40 f6 c7 02          	test   $0x2,%dil
  80104d:	74 07                	je     801056 <memset+0x81>
  80104f:	66 89 07             	mov    %ax,(%rdi)
  801052:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  801056:	40 f6 c7 04          	test   $0x4,%dil
  80105a:	74 a9                	je     801005 <memset+0x30>
  80105c:	89 07                	mov    %eax,(%rdi)
  80105e:	48 83 c7 04          	add    $0x4,%rdi
  801062:	eb a1                	jmp    801005 <memset+0x30>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  801064:	41 f6 c1 04          	test   $0x4,%r9b
  801068:	74 1b                	je     801085 <memset+0xb0>
  80106a:	89 07                	mov    %eax,(%rdi)
  80106c:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  801070:	41 f6 c1 02          	test   $0x2,%r9b
  801074:	74 07                	je     80107d <memset+0xa8>
  801076:	66 89 07             	mov    %ax,(%rdi)
  801079:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  80107d:	41 f6 c1 01          	test   $0x1,%r9b
  801081:	74 9c                	je     80101f <memset+0x4a>
  801083:	eb 06                	jmp    80108b <memset+0xb6>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  801085:	41 f6 c1 02          	test   $0x2,%r9b
  801089:	75 eb                	jne    801076 <memset+0xa1>
        if (ni & 1) *ptr = k;
  80108b:	88 07                	mov    %al,(%rdi)
  80108d:	eb 90                	jmp    80101f <memset+0x4a>

000000000080108f <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  80108f:	f3 0f 1e fa          	endbr64
  801093:	48 89 f8             	mov    %rdi,%rax
  801096:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  801099:	48 39 fe             	cmp    %rdi,%rsi
  80109c:	73 3b                	jae    8010d9 <memmove+0x4a>
  80109e:	48 8d 14 16          	lea    (%rsi,%rdx,1),%rdx
  8010a2:	48 39 d7             	cmp    %rdx,%rdi
  8010a5:	73 32                	jae    8010d9 <memmove+0x4a>
        s += n;
        d += n;
  8010a7:	48 8d 3c 0f          	lea    (%rdi,%rcx,1),%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  8010ab:	48 89 d6             	mov    %rdx,%rsi
  8010ae:	48 09 fe             	or     %rdi,%rsi
  8010b1:	48 09 ce             	or     %rcx,%rsi
  8010b4:	40 f6 c6 07          	test   $0x7,%sil
  8010b8:	75 12                	jne    8010cc <memmove+0x3d>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  8010ba:	48 83 ef 08          	sub    $0x8,%rdi
  8010be:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  8010c2:	48 c1 e9 03          	shr    $0x3,%rcx
  8010c6:	fd                   	std
  8010c7:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  8010ca:	fc                   	cld
  8010cb:	c3                   	ret
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  8010cc:	48 83 ef 01          	sub    $0x1,%rdi
  8010d0:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  8010d4:	fd                   	std
  8010d5:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  8010d7:	eb f1                	jmp    8010ca <memmove+0x3b>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  8010d9:	48 89 f2             	mov    %rsi,%rdx
  8010dc:	48 09 c2             	or     %rax,%rdx
  8010df:	48 09 ca             	or     %rcx,%rdx
  8010e2:	f6 c2 07             	test   $0x7,%dl
  8010e5:	75 0c                	jne    8010f3 <memmove+0x64>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  8010e7:	48 c1 e9 03          	shr    $0x3,%rcx
  8010eb:	48 89 c7             	mov    %rax,%rdi
  8010ee:	fc                   	cld
  8010ef:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  8010f2:	c3                   	ret
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  8010f3:	48 89 c7             	mov    %rax,%rdi
  8010f6:	fc                   	cld
  8010f7:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  8010f9:	c3                   	ret

00000000008010fa <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  8010fa:	f3 0f 1e fa          	endbr64
  8010fe:	55                   	push   %rbp
  8010ff:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  801102:	48 b8 8f 10 80 00 00 	movabs $0x80108f,%rax
  801109:	00 00 00 
  80110c:	ff d0                	call   *%rax
}
  80110e:	5d                   	pop    %rbp
  80110f:	c3                   	ret

0000000000801110 <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  801110:	f3 0f 1e fa          	endbr64
  801114:	55                   	push   %rbp
  801115:	48 89 e5             	mov    %rsp,%rbp
  801118:	41 57                	push   %r15
  80111a:	41 56                	push   %r14
  80111c:	41 55                	push   %r13
  80111e:	41 54                	push   %r12
  801120:	53                   	push   %rbx
  801121:	48 83 ec 08          	sub    $0x8,%rsp
  801125:	49 89 fe             	mov    %rdi,%r14
  801128:	49 89 f7             	mov    %rsi,%r15
  80112b:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  80112e:	48 89 f7             	mov    %rsi,%rdi
  801131:	48 b8 2f 0e 80 00 00 	movabs $0x800e2f,%rax
  801138:	00 00 00 
  80113b:	ff d0                	call   *%rax
  80113d:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  801140:	48 89 de             	mov    %rbx,%rsi
  801143:	4c 89 f7             	mov    %r14,%rdi
  801146:	48 b8 4e 0e 80 00 00 	movabs $0x800e4e,%rax
  80114d:	00 00 00 
  801150:	ff d0                	call   *%rax
  801152:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  801155:	48 39 c3             	cmp    %rax,%rbx
  801158:	74 36                	je     801190 <strlcat+0x80>
    if (srclen < maxlen - dstlen) {
  80115a:	48 89 d8             	mov    %rbx,%rax
  80115d:	4c 29 e8             	sub    %r13,%rax
  801160:	49 39 c4             	cmp    %rax,%r12
  801163:	73 31                	jae    801196 <strlcat+0x86>
        memcpy(dst + dstlen, src, srclen + 1);
  801165:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  80116a:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  80116e:	4c 89 fe             	mov    %r15,%rsi
  801171:	48 b8 fa 10 80 00 00 	movabs $0x8010fa,%rax
  801178:	00 00 00 
  80117b:	ff d0                	call   *%rax
    return dstlen + srclen;
  80117d:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  801181:	48 83 c4 08          	add    $0x8,%rsp
  801185:	5b                   	pop    %rbx
  801186:	41 5c                	pop    %r12
  801188:	41 5d                	pop    %r13
  80118a:	41 5e                	pop    %r14
  80118c:	41 5f                	pop    %r15
  80118e:	5d                   	pop    %rbp
  80118f:	c3                   	ret
    if (dstlen == maxlen) return maxlen + srclen;
  801190:	49 8d 04 04          	lea    (%r12,%rax,1),%rax
  801194:	eb eb                	jmp    801181 <strlcat+0x71>
        memcpy(dst + dstlen, src, maxlen - 1);
  801196:	48 83 eb 01          	sub    $0x1,%rbx
  80119a:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  80119e:	48 89 da             	mov    %rbx,%rdx
  8011a1:	4c 89 fe             	mov    %r15,%rsi
  8011a4:	48 b8 fa 10 80 00 00 	movabs $0x8010fa,%rax
  8011ab:	00 00 00 
  8011ae:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  8011b0:	49 01 de             	add    %rbx,%r14
  8011b3:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  8011b8:	eb c3                	jmp    80117d <strlcat+0x6d>

00000000008011ba <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  8011ba:	f3 0f 1e fa          	endbr64
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  8011be:	48 85 d2             	test   %rdx,%rdx
  8011c1:	74 2d                	je     8011f0 <memcmp+0x36>
  8011c3:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  8011c8:	0f b6 0c 07          	movzbl (%rdi,%rax,1),%ecx
  8011cc:	44 0f b6 04 06       	movzbl (%rsi,%rax,1),%r8d
  8011d1:	44 38 c1             	cmp    %r8b,%cl
  8011d4:	75 0f                	jne    8011e5 <memcmp+0x2b>
    while (n-- > 0) {
  8011d6:	48 83 c0 01          	add    $0x1,%rax
  8011da:	48 39 c2             	cmp    %rax,%rdx
  8011dd:	75 e9                	jne    8011c8 <memcmp+0xe>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  8011df:	b8 00 00 00 00       	mov    $0x0,%eax
  8011e4:	c3                   	ret
            return (int)*s1 - (int)*s2;
  8011e5:	0f b6 c1             	movzbl %cl,%eax
  8011e8:	45 0f b6 c0          	movzbl %r8b,%r8d
  8011ec:	44 29 c0             	sub    %r8d,%eax
  8011ef:	c3                   	ret
    return 0;
  8011f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011f5:	c3                   	ret

00000000008011f6 <memfind>:

void *
memfind(const void *src, int c, size_t n) {
  8011f6:	f3 0f 1e fa          	endbr64
    const void *end = (const char *)src + n;
  8011fa:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  8011fe:	48 39 c7             	cmp    %rax,%rdi
  801201:	73 0f                	jae    801212 <memfind+0x1c>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  801203:	40 38 37             	cmp    %sil,(%rdi)
  801206:	74 0e                	je     801216 <memfind+0x20>
    for (; src < end; src++) {
  801208:	48 83 c7 01          	add    $0x1,%rdi
  80120c:	48 39 f8             	cmp    %rdi,%rax
  80120f:	75 f2                	jne    801203 <memfind+0xd>
  801211:	c3                   	ret
  801212:	48 89 f8             	mov    %rdi,%rax
  801215:	c3                   	ret
  801216:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  801219:	c3                   	ret

000000000080121a <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  80121a:	f3 0f 1e fa          	endbr64
  80121e:	49 89 f2             	mov    %rsi,%r10
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  801221:	0f b6 37             	movzbl (%rdi),%esi
  801224:	40 80 fe 20          	cmp    $0x20,%sil
  801228:	74 06                	je     801230 <strtol+0x16>
  80122a:	40 80 fe 09          	cmp    $0x9,%sil
  80122e:	75 13                	jne    801243 <strtol+0x29>
  801230:	48 83 c7 01          	add    $0x1,%rdi
  801234:	0f b6 37             	movzbl (%rdi),%esi
  801237:	40 80 fe 20          	cmp    $0x20,%sil
  80123b:	74 f3                	je     801230 <strtol+0x16>
  80123d:	40 80 fe 09          	cmp    $0x9,%sil
  801241:	74 ed                	je     801230 <strtol+0x16>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  801243:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  801246:	83 e0 fd             	and    $0xfffffffd,%eax
  801249:	3c 01                	cmp    $0x1,%al
  80124b:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  80124f:	f7 c2 ef ff ff ff    	test   $0xffffffef,%edx
  801255:	75 0f                	jne    801266 <strtol+0x4c>
  801257:	80 3f 30             	cmpb   $0x30,(%rdi)
  80125a:	74 14                	je     801270 <strtol+0x56>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  80125c:	85 d2                	test   %edx,%edx
  80125e:	b8 0a 00 00 00       	mov    $0xa,%eax
  801263:	0f 44 d0             	cmove  %eax,%edx
    }

    /* Digits */
    long val = 0;
  801266:	b8 00 00 00 00       	mov    $0x0,%eax
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  80126b:	4c 63 ca             	movslq %edx,%r9
  80126e:	eb 36                	jmp    8012a6 <strtol+0x8c>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  801270:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  801274:	74 0f                	je     801285 <strtol+0x6b>
    } else if (!base && s[0] == '0') {
  801276:	85 d2                	test   %edx,%edx
  801278:	75 ec                	jne    801266 <strtol+0x4c>
        s++;
  80127a:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  80127e:	ba 08 00 00 00       	mov    $0x8,%edx
        s++;
  801283:	eb e1                	jmp    801266 <strtol+0x4c>
        s += 2;
  801285:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  801289:	ba 10 00 00 00       	mov    $0x10,%edx
        s += 2;
  80128e:	eb d6                	jmp    801266 <strtol+0x4c>
            dig -= '0';
  801290:	83 e9 30             	sub    $0x30,%ecx
        if (dig >= base) break;
  801293:	44 0f b6 c1          	movzbl %cl,%r8d
  801297:	41 39 d0             	cmp    %edx,%r8d
  80129a:	7d 21                	jge    8012bd <strtol+0xa3>
        val = val * base + dig;
  80129c:	49 0f af c1          	imul   %r9,%rax
  8012a0:	0f b6 c9             	movzbl %cl,%ecx
  8012a3:	48 01 c8             	add    %rcx,%rax
        uint8_t dig = *s++;
  8012a6:	48 83 c7 01          	add    $0x1,%rdi
  8012aa:	0f b6 4f ff          	movzbl -0x1(%rdi),%ecx
        if (dig - '0' < 10)
  8012ae:	80 f9 39             	cmp    $0x39,%cl
  8012b1:	76 dd                	jbe    801290 <strtol+0x76>
        else if (dig - 'a' < 27)
  8012b3:	80 f9 7b             	cmp    $0x7b,%cl
  8012b6:	77 05                	ja     8012bd <strtol+0xa3>
            dig -= 'a' - 10;
  8012b8:	83 e9 57             	sub    $0x57,%ecx
  8012bb:	eb d6                	jmp    801293 <strtol+0x79>
    }

    if (endptr) *endptr = (char *)s;
  8012bd:	4d 85 d2             	test   %r10,%r10
  8012c0:	74 03                	je     8012c5 <strtol+0xab>
  8012c2:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  8012c5:	48 89 c2             	mov    %rax,%rdx
  8012c8:	48 f7 da             	neg    %rdx
  8012cb:	40 80 fe 2d          	cmp    $0x2d,%sil
  8012cf:	48 0f 44 c2          	cmove  %rdx,%rax
}
  8012d3:	c3                   	ret

00000000008012d4 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  8012d4:	f3 0f 1e fa          	endbr64
  8012d8:	55                   	push   %rbp
  8012d9:	48 89 e5             	mov    %rsp,%rbp
  8012dc:	53                   	push   %rbx
  8012dd:	48 89 fa             	mov    %rdi,%rdx
  8012e0:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8012e3:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8012e8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012ed:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012f2:	be 00 00 00 00       	mov    $0x0,%esi
  8012f7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8012fd:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  8012ff:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801303:	c9                   	leave
  801304:	c3                   	ret

0000000000801305 <sys_cgetc>:

int
sys_cgetc(void) {
  801305:	f3 0f 1e fa          	endbr64
  801309:	55                   	push   %rbp
  80130a:	48 89 e5             	mov    %rsp,%rbp
  80130d:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80130e:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801313:	ba 00 00 00 00       	mov    $0x0,%edx
  801318:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80131d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801322:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801327:	be 00 00 00 00       	mov    $0x0,%esi
  80132c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801332:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  801334:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801338:	c9                   	leave
  801339:	c3                   	ret

000000000080133a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  80133a:	f3 0f 1e fa          	endbr64
  80133e:	55                   	push   %rbp
  80133f:	48 89 e5             	mov    %rsp,%rbp
  801342:	53                   	push   %rbx
  801343:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  801347:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80134a:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80134f:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801354:	bb 00 00 00 00       	mov    $0x0,%ebx
  801359:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80135e:	be 00 00 00 00       	mov    $0x0,%esi
  801363:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801369:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80136b:	48 85 c0             	test   %rax,%rax
  80136e:	7f 06                	jg     801376 <sys_env_destroy+0x3c>
}
  801370:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801374:	c9                   	leave
  801375:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801376:	49 89 c0             	mov    %rax,%r8
  801379:	b9 03 00 00 00       	mov    $0x3,%ecx
  80137e:	48 ba 60 44 80 00 00 	movabs $0x804460,%rdx
  801385:	00 00 00 
  801388:	be 26 00 00 00       	mov    $0x26,%esi
  80138d:	48 bf 07 42 80 00 00 	movabs $0x804207,%rdi
  801394:	00 00 00 
  801397:	b8 00 00 00 00       	mov    $0x0,%eax
  80139c:	49 b9 cf 03 80 00 00 	movabs $0x8003cf,%r9
  8013a3:	00 00 00 
  8013a6:	41 ff d1             	call   *%r9

00000000008013a9 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  8013a9:	f3 0f 1e fa          	endbr64
  8013ad:	55                   	push   %rbp
  8013ae:	48 89 e5             	mov    %rsp,%rbp
  8013b1:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8013b2:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8013b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8013bc:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8013c1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013c6:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013cb:	be 00 00 00 00       	mov    $0x0,%esi
  8013d0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013d6:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  8013d8:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013dc:	c9                   	leave
  8013dd:	c3                   	ret

00000000008013de <sys_yield>:

void
sys_yield(void) {
  8013de:	f3 0f 1e fa          	endbr64
  8013e2:	55                   	push   %rbp
  8013e3:	48 89 e5             	mov    %rsp,%rbp
  8013e6:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8013e7:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8013ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8013f1:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8013f6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013fb:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801400:	be 00 00 00 00       	mov    $0x0,%esi
  801405:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80140b:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  80140d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801411:	c9                   	leave
  801412:	c3                   	ret

0000000000801413 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  801413:	f3 0f 1e fa          	endbr64
  801417:	55                   	push   %rbp
  801418:	48 89 e5             	mov    %rsp,%rbp
  80141b:	53                   	push   %rbx
  80141c:	48 89 fa             	mov    %rdi,%rdx
  80141f:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801422:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801427:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  80142e:	00 00 00 
  801431:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801436:	be 00 00 00 00       	mov    $0x0,%esi
  80143b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801441:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  801443:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801447:	c9                   	leave
  801448:	c3                   	ret

0000000000801449 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  801449:	f3 0f 1e fa          	endbr64
  80144d:	55                   	push   %rbp
  80144e:	48 89 e5             	mov    %rsp,%rbp
  801451:	53                   	push   %rbx
  801452:	49 89 f8             	mov    %rdi,%r8
  801455:	48 89 d3             	mov    %rdx,%rbx
  801458:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  80145b:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801460:	4c 89 c2             	mov    %r8,%rdx
  801463:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801466:	be 00 00 00 00       	mov    $0x0,%esi
  80146b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801471:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  801473:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801477:	c9                   	leave
  801478:	c3                   	ret

0000000000801479 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  801479:	f3 0f 1e fa          	endbr64
  80147d:	55                   	push   %rbp
  80147e:	48 89 e5             	mov    %rsp,%rbp
  801481:	53                   	push   %rbx
  801482:	48 83 ec 08          	sub    $0x8,%rsp
  801486:	89 f8                	mov    %edi,%eax
  801488:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  80148b:	48 63 f9             	movslq %ecx,%rdi
  80148e:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801491:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801496:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801499:	be 00 00 00 00       	mov    $0x0,%esi
  80149e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8014a4:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8014a6:	48 85 c0             	test   %rax,%rax
  8014a9:	7f 06                	jg     8014b1 <sys_alloc_region+0x38>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  8014ab:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014af:	c9                   	leave
  8014b0:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8014b1:	49 89 c0             	mov    %rax,%r8
  8014b4:	b9 04 00 00 00       	mov    $0x4,%ecx
  8014b9:	48 ba 60 44 80 00 00 	movabs $0x804460,%rdx
  8014c0:	00 00 00 
  8014c3:	be 26 00 00 00       	mov    $0x26,%esi
  8014c8:	48 bf 07 42 80 00 00 	movabs $0x804207,%rdi
  8014cf:	00 00 00 
  8014d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d7:	49 b9 cf 03 80 00 00 	movabs $0x8003cf,%r9
  8014de:	00 00 00 
  8014e1:	41 ff d1             	call   *%r9

00000000008014e4 <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  8014e4:	f3 0f 1e fa          	endbr64
  8014e8:	55                   	push   %rbp
  8014e9:	48 89 e5             	mov    %rsp,%rbp
  8014ec:	53                   	push   %rbx
  8014ed:	48 83 ec 08          	sub    $0x8,%rsp
  8014f1:	89 f8                	mov    %edi,%eax
  8014f3:	49 89 f2             	mov    %rsi,%r10
  8014f6:	48 89 cf             	mov    %rcx,%rdi
  8014f9:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  8014fc:	48 63 da             	movslq %edx,%rbx
  8014ff:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801502:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801507:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80150a:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  80150d:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80150f:	48 85 c0             	test   %rax,%rax
  801512:	7f 06                	jg     80151a <sys_map_region+0x36>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  801514:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801518:	c9                   	leave
  801519:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80151a:	49 89 c0             	mov    %rax,%r8
  80151d:	b9 05 00 00 00       	mov    $0x5,%ecx
  801522:	48 ba 60 44 80 00 00 	movabs $0x804460,%rdx
  801529:	00 00 00 
  80152c:	be 26 00 00 00       	mov    $0x26,%esi
  801531:	48 bf 07 42 80 00 00 	movabs $0x804207,%rdi
  801538:	00 00 00 
  80153b:	b8 00 00 00 00       	mov    $0x0,%eax
  801540:	49 b9 cf 03 80 00 00 	movabs $0x8003cf,%r9
  801547:	00 00 00 
  80154a:	41 ff d1             	call   *%r9

000000000080154d <sys_map_physical_region>:

int
sys_map_physical_region(uintptr_t pa, envid_t dstenv, void *dstva, size_t size, int perm) {
  80154d:	f3 0f 1e fa          	endbr64
  801551:	55                   	push   %rbp
  801552:	48 89 e5             	mov    %rsp,%rbp
  801555:	53                   	push   %rbx
  801556:	48 83 ec 08          	sub    $0x8,%rsp
  80155a:	49 89 f9             	mov    %rdi,%r9
  80155d:	89 f0                	mov    %esi,%eax
  80155f:	48 89 d3             	mov    %rdx,%rbx
  801562:	48 89 cf             	mov    %rcx,%rdi
    int res = syscall(SYS_map_physical_region, 1, pa, dstenv, (uintptr_t)dstva, size, perm, 0);
  801565:	49 63 f0             	movslq %r8d,%rsi
  801568:	48 63 c8             	movslq %eax,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80156b:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801570:	4c 89 ca             	mov    %r9,%rdx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801573:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801579:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80157b:	48 85 c0             	test   %rax,%rax
  80157e:	7f 06                	jg     801586 <sys_map_physical_region+0x39>
#ifdef SANITIZE_USER_SHADOW_BASE
    platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  801580:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801584:	c9                   	leave
  801585:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801586:	49 89 c0             	mov    %rax,%r8
  801589:	b9 06 00 00 00       	mov    $0x6,%ecx
  80158e:	48 ba 60 44 80 00 00 	movabs $0x804460,%rdx
  801595:	00 00 00 
  801598:	be 26 00 00 00       	mov    $0x26,%esi
  80159d:	48 bf 07 42 80 00 00 	movabs $0x804207,%rdi
  8015a4:	00 00 00 
  8015a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ac:	49 b9 cf 03 80 00 00 	movabs $0x8003cf,%r9
  8015b3:	00 00 00 
  8015b6:	41 ff d1             	call   *%r9

00000000008015b9 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  8015b9:	f3 0f 1e fa          	endbr64
  8015bd:	55                   	push   %rbp
  8015be:	48 89 e5             	mov    %rsp,%rbp
  8015c1:	53                   	push   %rbx
  8015c2:	48 83 ec 08          	sub    $0x8,%rsp
  8015c6:	48 89 f1             	mov    %rsi,%rcx
  8015c9:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  8015cc:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8015cf:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8015d4:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8015d9:	be 00 00 00 00       	mov    $0x0,%esi
  8015de:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8015e4:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8015e6:	48 85 c0             	test   %rax,%rax
  8015e9:	7f 06                	jg     8015f1 <sys_unmap_region+0x38>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  8015eb:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8015ef:	c9                   	leave
  8015f0:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8015f1:	49 89 c0             	mov    %rax,%r8
  8015f4:	b9 07 00 00 00       	mov    $0x7,%ecx
  8015f9:	48 ba 60 44 80 00 00 	movabs $0x804460,%rdx
  801600:	00 00 00 
  801603:	be 26 00 00 00       	mov    $0x26,%esi
  801608:	48 bf 07 42 80 00 00 	movabs $0x804207,%rdi
  80160f:	00 00 00 
  801612:	b8 00 00 00 00       	mov    $0x0,%eax
  801617:	49 b9 cf 03 80 00 00 	movabs $0x8003cf,%r9
  80161e:	00 00 00 
  801621:	41 ff d1             	call   *%r9

0000000000801624 <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  801624:	f3 0f 1e fa          	endbr64
  801628:	55                   	push   %rbp
  801629:	48 89 e5             	mov    %rsp,%rbp
  80162c:	53                   	push   %rbx
  80162d:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  801631:	48 63 ce             	movslq %esi,%rcx
  801634:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801637:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80163c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801641:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801646:	be 00 00 00 00       	mov    $0x0,%esi
  80164b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801651:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801653:	48 85 c0             	test   %rax,%rax
  801656:	7f 06                	jg     80165e <sys_env_set_status+0x3a>
}
  801658:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80165c:	c9                   	leave
  80165d:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80165e:	49 89 c0             	mov    %rax,%r8
  801661:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801666:	48 ba 60 44 80 00 00 	movabs $0x804460,%rdx
  80166d:	00 00 00 
  801670:	be 26 00 00 00       	mov    $0x26,%esi
  801675:	48 bf 07 42 80 00 00 	movabs $0x804207,%rdi
  80167c:	00 00 00 
  80167f:	b8 00 00 00 00       	mov    $0x0,%eax
  801684:	49 b9 cf 03 80 00 00 	movabs $0x8003cf,%r9
  80168b:	00 00 00 
  80168e:	41 ff d1             	call   *%r9

0000000000801691 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  801691:	f3 0f 1e fa          	endbr64
  801695:	55                   	push   %rbp
  801696:	48 89 e5             	mov    %rsp,%rbp
  801699:	53                   	push   %rbx
  80169a:	48 83 ec 08          	sub    $0x8,%rsp
  80169e:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  8016a1:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8016a4:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8016a9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016ae:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8016b3:	be 00 00 00 00       	mov    $0x0,%esi
  8016b8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8016be:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8016c0:	48 85 c0             	test   %rax,%rax
  8016c3:	7f 06                	jg     8016cb <sys_env_set_trapframe+0x3a>
}
  8016c5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8016c9:	c9                   	leave
  8016ca:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8016cb:	49 89 c0             	mov    %rax,%r8
  8016ce:	b9 0b 00 00 00       	mov    $0xb,%ecx
  8016d3:	48 ba 60 44 80 00 00 	movabs $0x804460,%rdx
  8016da:	00 00 00 
  8016dd:	be 26 00 00 00       	mov    $0x26,%esi
  8016e2:	48 bf 07 42 80 00 00 	movabs $0x804207,%rdi
  8016e9:	00 00 00 
  8016ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f1:	49 b9 cf 03 80 00 00 	movabs $0x8003cf,%r9
  8016f8:	00 00 00 
  8016fb:	41 ff d1             	call   *%r9

00000000008016fe <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  8016fe:	f3 0f 1e fa          	endbr64
  801702:	55                   	push   %rbp
  801703:	48 89 e5             	mov    %rsp,%rbp
  801706:	53                   	push   %rbx
  801707:	48 83 ec 08          	sub    $0x8,%rsp
  80170b:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  80170e:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801711:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801716:	bb 00 00 00 00       	mov    $0x0,%ebx
  80171b:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801720:	be 00 00 00 00       	mov    $0x0,%esi
  801725:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80172b:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80172d:	48 85 c0             	test   %rax,%rax
  801730:	7f 06                	jg     801738 <sys_env_set_pgfault_upcall+0x3a>
}
  801732:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801736:	c9                   	leave
  801737:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801738:	49 89 c0             	mov    %rax,%r8
  80173b:	b9 0c 00 00 00       	mov    $0xc,%ecx
  801740:	48 ba 60 44 80 00 00 	movabs $0x804460,%rdx
  801747:	00 00 00 
  80174a:	be 26 00 00 00       	mov    $0x26,%esi
  80174f:	48 bf 07 42 80 00 00 	movabs $0x804207,%rdi
  801756:	00 00 00 
  801759:	b8 00 00 00 00       	mov    $0x0,%eax
  80175e:	49 b9 cf 03 80 00 00 	movabs $0x8003cf,%r9
  801765:	00 00 00 
  801768:	41 ff d1             	call   *%r9

000000000080176b <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  80176b:	f3 0f 1e fa          	endbr64
  80176f:	55                   	push   %rbp
  801770:	48 89 e5             	mov    %rsp,%rbp
  801773:	53                   	push   %rbx
  801774:	89 f8                	mov    %edi,%eax
  801776:	49 89 f1             	mov    %rsi,%r9
  801779:	48 89 d3             	mov    %rdx,%rbx
  80177c:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  80177f:	49 63 f0             	movslq %r8d,%rsi
  801782:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801785:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80178a:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80178d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801793:	cd 30                	int    $0x30
}
  801795:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801799:	c9                   	leave
  80179a:	c3                   	ret

000000000080179b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  80179b:	f3 0f 1e fa          	endbr64
  80179f:	55                   	push   %rbp
  8017a0:	48 89 e5             	mov    %rsp,%rbp
  8017a3:	53                   	push   %rbx
  8017a4:	48 83 ec 08          	sub    $0x8,%rsp
  8017a8:	48 89 fa             	mov    %rdi,%rdx
  8017ab:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8017ae:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8017b3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017b8:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8017bd:	be 00 00 00 00       	mov    $0x0,%esi
  8017c2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8017c8:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8017ca:	48 85 c0             	test   %rax,%rax
  8017cd:	7f 06                	jg     8017d5 <sys_ipc_recv+0x3a>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  8017cf:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8017d3:	c9                   	leave
  8017d4:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8017d5:	49 89 c0             	mov    %rax,%r8
  8017d8:	b9 0f 00 00 00       	mov    $0xf,%ecx
  8017dd:	48 ba 60 44 80 00 00 	movabs $0x804460,%rdx
  8017e4:	00 00 00 
  8017e7:	be 26 00 00 00       	mov    $0x26,%esi
  8017ec:	48 bf 07 42 80 00 00 	movabs $0x804207,%rdi
  8017f3:	00 00 00 
  8017f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8017fb:	49 b9 cf 03 80 00 00 	movabs $0x8003cf,%r9
  801802:	00 00 00 
  801805:	41 ff d1             	call   *%r9

0000000000801808 <sys_gettime>:

int
sys_gettime(void) {
  801808:	f3 0f 1e fa          	endbr64
  80180c:	55                   	push   %rbp
  80180d:	48 89 e5             	mov    %rsp,%rbp
  801810:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801811:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801816:	ba 00 00 00 00       	mov    $0x0,%edx
  80181b:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801820:	bb 00 00 00 00       	mov    $0x0,%ebx
  801825:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80182a:	be 00 00 00 00       	mov    $0x0,%esi
  80182f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801835:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  801837:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80183b:	c9                   	leave
  80183c:	c3                   	ret

000000000080183d <fork>:
 *   Use sys_map_region, it can perform address space copying in one call
 *   Don't forget to set page fault handler in the child (using sys_env_set_pgfault_upcall()).
 *   Remember to fix "thisenv" in the child process.
 */
envid_t
fork(void) {
  80183d:	f3 0f 1e fa          	endbr64
  801841:	55                   	push   %rbp
  801842:	48 89 e5             	mov    %rsp,%rbp
  801845:	41 56                	push   %r14
  801847:	41 55                	push   %r13
  801849:	41 54                	push   %r12
  80184b:	53                   	push   %rbx
    // LAB 9: Your code here.
    bool has_pgfault_upcall = thisenv->env_pgfault_upcall;
  80184c:	48 a1 00 64 80 00 00 	movabs 0x806400,%rax
  801853:	00 00 00 
  801856:	4c 8b b0 00 01 00 00 	mov    0x100(%rax),%r14

/* This must be inlined. Exercise for reader: why? */
static inline envid_t __attribute__((always_inline))
sys_exofork(void) {
    envid_t ret;
    asm volatile("int %2"
  80185d:	b8 09 00 00 00       	mov    $0x9,%eax
  801862:	cd 30                	int    $0x30
  801864:	41 89 c4             	mov    %eax,%r12d

    envid_t envid = sys_exofork();
    if (envid < 0) {
  801867:	85 c0                	test   %eax,%eax
  801869:	78 7f                	js     8018ea <fork+0xad>
  80186b:	89 c3                	mov    %eax,%ebx
        return envid;
    }
    if (envid == 0) {
  80186d:	0f 84 83 00 00 00    	je     8018f6 <fork+0xb9>
        thisenv = &envs[ENVX(sys_getenvid())];
        return 0;
    }
    int res = sys_map_region(CURENVID, NULL, envid, NULL, MAX_USER_ADDRESS, PROT_ALL | PROT_LAZY | PROT_COMBINE);
  801873:	41 b9 ff 0f 00 00    	mov    $0xfff,%r9d
  801879:	49 b8 00 00 00 00 80 	movabs $0x8000000000,%r8
  801880:	00 00 00 
  801883:	b9 00 00 00 00       	mov    $0x0,%ecx
  801888:	89 c2                	mov    %eax,%edx
  80188a:	be 00 00 00 00       	mov    $0x0,%esi
  80188f:	bf 00 00 00 00       	mov    $0x0,%edi
  801894:	48 b8 e4 14 80 00 00 	movabs $0x8014e4,%rax
  80189b:	00 00 00 
  80189e:	ff d0                	call   *%rax
  8018a0:	41 89 c5             	mov    %eax,%r13d
    if (res < 0) {
  8018a3:	85 c0                	test   %eax,%eax
  8018a5:	0f 88 81 00 00 00    	js     80192c <fork+0xef>
        sys_env_destroy(envid);
        return res;
    }
    if (has_pgfault_upcall) {
  8018ab:	4d 85 f6             	test   %r14,%r14
  8018ae:	74 20                	je     8018d0 <fork+0x93>
        res = sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  8018b0:	48 be c7 2f 80 00 00 	movabs $0x802fc7,%rsi
  8018b7:	00 00 00 
  8018ba:	44 89 e7             	mov    %r12d,%edi
  8018bd:	48 b8 fe 16 80 00 00 	movabs $0x8016fe,%rax
  8018c4:	00 00 00 
  8018c7:	ff d0                	call   *%rax
  8018c9:	41 89 c5             	mov    %eax,%r13d
        if (res < 0) {
  8018cc:	85 c0                	test   %eax,%eax
  8018ce:	78 70                	js     801940 <fork+0x103>
            sys_env_destroy(envid);
            return res;
        }
    }
    res = sys_env_set_status(envid, ENV_RUNNABLE);
  8018d0:	be 02 00 00 00       	mov    $0x2,%esi
  8018d5:	89 df                	mov    %ebx,%edi
  8018d7:	48 b8 24 16 80 00 00 	movabs $0x801624,%rax
  8018de:	00 00 00 
  8018e1:	ff d0                	call   *%rax
  8018e3:	41 89 c5             	mov    %eax,%r13d
    if (res < 0) {
  8018e6:	85 c0                	test   %eax,%eax
  8018e8:	78 6a                	js     801954 <fork+0x117>
        sys_env_destroy(envid);
        return res;
    }
    return envid;
}
  8018ea:	44 89 e0             	mov    %r12d,%eax
  8018ed:	5b                   	pop    %rbx
  8018ee:	41 5c                	pop    %r12
  8018f0:	41 5d                	pop    %r13
  8018f2:	41 5e                	pop    %r14
  8018f4:	5d                   	pop    %rbp
  8018f5:	c3                   	ret
        thisenv = &envs[ENVX(sys_getenvid())];
  8018f6:	48 b8 a9 13 80 00 00 	movabs $0x8013a9,%rax
  8018fd:	00 00 00 
  801900:	ff d0                	call   *%rax
  801902:	25 ff 03 00 00       	and    $0x3ff,%eax
  801907:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  80190b:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  80190f:	48 c1 e0 04          	shl    $0x4,%rax
  801913:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  80191a:	00 00 00 
  80191d:	48 01 d0             	add    %rdx,%rax
  801920:	48 a3 00 64 80 00 00 	movabs %rax,0x806400
  801927:	00 00 00 
        return 0;
  80192a:	eb be                	jmp    8018ea <fork+0xad>
        sys_env_destroy(envid);
  80192c:	44 89 e7             	mov    %r12d,%edi
  80192f:	48 b8 3a 13 80 00 00 	movabs $0x80133a,%rax
  801936:	00 00 00 
  801939:	ff d0                	call   *%rax
        return res;
  80193b:	45 89 ec             	mov    %r13d,%r12d
  80193e:	eb aa                	jmp    8018ea <fork+0xad>
            sys_env_destroy(envid);
  801940:	44 89 e7             	mov    %r12d,%edi
  801943:	48 b8 3a 13 80 00 00 	movabs $0x80133a,%rax
  80194a:	00 00 00 
  80194d:	ff d0                	call   *%rax
            return res;
  80194f:	45 89 ec             	mov    %r13d,%r12d
  801952:	eb 96                	jmp    8018ea <fork+0xad>
        sys_env_destroy(envid);
  801954:	89 df                	mov    %ebx,%edi
  801956:	48 b8 3a 13 80 00 00 	movabs $0x80133a,%rax
  80195d:	00 00 00 
  801960:	ff d0                	call   *%rax
        return res;
  801962:	45 89 ec             	mov    %r13d,%r12d
  801965:	eb 83                	jmp    8018ea <fork+0xad>

0000000000801967 <sfork>:

envid_t
sfork() {
  801967:	f3 0f 1e fa          	endbr64
  80196b:	55                   	push   %rbp
  80196c:	48 89 e5             	mov    %rsp,%rbp
    panic("sfork() is not implemented");
  80196f:	48 ba 15 42 80 00 00 	movabs $0x804215,%rdx
  801976:	00 00 00 
  801979:	be 37 00 00 00       	mov    $0x37,%esi
  80197e:	48 bf 30 42 80 00 00 	movabs $0x804230,%rdi
  801985:	00 00 00 
  801988:	b8 00 00 00 00       	mov    $0x0,%eax
  80198d:	48 b9 cf 03 80 00 00 	movabs $0x8003cf,%rcx
  801994:	00 00 00 
  801997:	ff d1                	call   *%rcx

0000000000801999 <fd2num>:


/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
  801999:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80199d:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8019a4:	ff ff ff 
  8019a7:	48 01 f8             	add    %rdi,%rax
  8019aa:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8019ae:	c3                   	ret

00000000008019af <fd2data>:

char *
fd2data(struct Fd *fd) {
  8019af:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8019b3:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8019ba:	ff ff ff 
  8019bd:	48 01 f8             	add    %rdi,%rax
  8019c0:	48 c1 e8 0c          	shr    $0xc,%rax
    return INDEX2DATA(fd2num(fd));
  8019c4:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8019ca:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8019ce:	c3                   	ret

00000000008019cf <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  8019cf:	f3 0f 1e fa          	endbr64
  8019d3:	55                   	push   %rbp
  8019d4:	48 89 e5             	mov    %rsp,%rbp
  8019d7:	41 57                	push   %r15
  8019d9:	41 56                	push   %r14
  8019db:	41 55                	push   %r13
  8019dd:	41 54                	push   %r12
  8019df:	53                   	push   %rbx
  8019e0:	48 83 ec 08          	sub    $0x8,%rsp
  8019e4:	49 89 ff             	mov    %rdi,%r15
  8019e7:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  8019ec:	49 bd f5 2b 80 00 00 	movabs $0x802bf5,%r13
  8019f3:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  8019f6:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        struct Fd *fd = INDEX2FD(i);
  8019fc:	49 89 dc             	mov    %rbx,%r12
        if (!(get_prot(fd) & PROT_R)) {
  8019ff:	48 89 df             	mov    %rbx,%rdi
  801a02:	41 ff d5             	call   *%r13
  801a05:	83 e0 04             	and    $0x4,%eax
  801a08:	74 17                	je     801a21 <fd_alloc+0x52>
    for (int i = 0; i < MAXFD; i++) {
  801a0a:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  801a11:	4c 39 f3             	cmp    %r14,%rbx
  801a14:	75 e6                	jne    8019fc <fd_alloc+0x2d>
  801a16:	41 bc 00 00 00 00    	mov    $0x0,%r12d
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
    return -E_MAX_OPEN;
  801a1c:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
            *fd_store = fd;
  801a21:	4d 89 27             	mov    %r12,(%r15)
}
  801a24:	48 83 c4 08          	add    $0x8,%rsp
  801a28:	5b                   	pop    %rbx
  801a29:	41 5c                	pop    %r12
  801a2b:	41 5d                	pop    %r13
  801a2d:	41 5e                	pop    %r14
  801a2f:	41 5f                	pop    %r15
  801a31:	5d                   	pop    %rbp
  801a32:	c3                   	ret

0000000000801a33 <fd_lookup>:
 *
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
  801a33:	f3 0f 1e fa          	endbr64
    if (fdnum < 0 || fdnum >= MAXFD) {
  801a37:	83 ff 1f             	cmp    $0x1f,%edi
  801a3a:	77 39                	ja     801a75 <fd_lookup+0x42>
fd_lookup(int fdnum, struct Fd **fd_store) {
  801a3c:	55                   	push   %rbp
  801a3d:	48 89 e5             	mov    %rsp,%rbp
  801a40:	41 54                	push   %r12
  801a42:	53                   	push   %rbx
  801a43:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  801a46:	48 63 df             	movslq %edi,%rbx
  801a49:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  801a50:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  801a54:	48 89 df             	mov    %rbx,%rdi
  801a57:	48 b8 f5 2b 80 00 00 	movabs $0x802bf5,%rax
  801a5e:	00 00 00 
  801a61:	ff d0                	call   *%rax
  801a63:	a8 04                	test   $0x4,%al
  801a65:	74 14                	je     801a7b <fd_lookup+0x48>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  801a67:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  801a6b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a70:	5b                   	pop    %rbx
  801a71:	41 5c                	pop    %r12
  801a73:	5d                   	pop    %rbp
  801a74:	c3                   	ret
        return -E_INVAL;
  801a75:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801a7a:	c3                   	ret
        return -E_INVAL;
  801a7b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a80:	eb ee                	jmp    801a70 <fd_lookup+0x3d>

0000000000801a82 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  801a82:	f3 0f 1e fa          	endbr64
  801a86:	55                   	push   %rbp
  801a87:	48 89 e5             	mov    %rsp,%rbp
  801a8a:	41 54                	push   %r12
  801a8c:	53                   	push   %rbx
  801a8d:	49 89 f4             	mov    %rsi,%r12
    for (size_t i = 0; devtab[i]; i++) {
  801a90:	48 b8 80 48 80 00 00 	movabs $0x804880,%rax
  801a97:	00 00 00 
  801a9a:	48 bb 20 50 80 00 00 	movabs $0x805020,%rbx
  801aa1:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  801aa4:	39 3b                	cmp    %edi,(%rbx)
  801aa6:	74 47                	je     801aef <dev_lookup+0x6d>
    for (size_t i = 0; devtab[i]; i++) {
  801aa8:	48 83 c0 08          	add    $0x8,%rax
  801aac:	48 8b 18             	mov    (%rax),%rbx
  801aaf:	48 85 db             	test   %rbx,%rbx
  801ab2:	75 f0                	jne    801aa4 <dev_lookup+0x22>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801ab4:	48 a1 00 64 80 00 00 	movabs 0x806400,%rax
  801abb:	00 00 00 
  801abe:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801ac4:	89 fa                	mov    %edi,%edx
  801ac6:	48 bf 80 44 80 00 00 	movabs $0x804480,%rdi
  801acd:	00 00 00 
  801ad0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ad5:	48 b9 2b 05 80 00 00 	movabs $0x80052b,%rcx
  801adc:	00 00 00 
  801adf:	ff d1                	call   *%rcx
    *dev = 0;
    return -E_INVAL;
  801ae1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
            *dev = devtab[i];
  801ae6:	49 89 1c 24          	mov    %rbx,(%r12)
}
  801aea:	5b                   	pop    %rbx
  801aeb:	41 5c                	pop    %r12
  801aed:	5d                   	pop    %rbp
  801aee:	c3                   	ret
            return 0;
  801aef:	b8 00 00 00 00       	mov    $0x0,%eax
  801af4:	eb f0                	jmp    801ae6 <dev_lookup+0x64>

0000000000801af6 <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  801af6:	f3 0f 1e fa          	endbr64
  801afa:	55                   	push   %rbp
  801afb:	48 89 e5             	mov    %rsp,%rbp
  801afe:	41 55                	push   %r13
  801b00:	41 54                	push   %r12
  801b02:	53                   	push   %rbx
  801b03:	48 83 ec 18          	sub    $0x18,%rsp
  801b07:	48 89 fb             	mov    %rdi,%rbx
  801b0a:	41 89 f4             	mov    %esi,%r12d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801b0d:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  801b14:	ff ff ff 
  801b17:	48 01 df             	add    %rbx,%rdi
  801b1a:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  801b1e:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801b22:	48 b8 33 1a 80 00 00 	movabs $0x801a33,%rax
  801b29:	00 00 00 
  801b2c:	ff d0                	call   *%rax
  801b2e:	41 89 c5             	mov    %eax,%r13d
  801b31:	85 c0                	test   %eax,%eax
  801b33:	78 06                	js     801b3b <fd_close+0x45>
  801b35:	48 39 5d d8          	cmp    %rbx,-0x28(%rbp)
  801b39:	74 1a                	je     801b55 <fd_close+0x5f>
        return (must_exist ? res : 0);
  801b3b:	45 84 e4             	test   %r12b,%r12b
  801b3e:	b8 00 00 00 00       	mov    $0x0,%eax
  801b43:	44 0f 44 e8          	cmove  %eax,%r13d
}
  801b47:	44 89 e8             	mov    %r13d,%eax
  801b4a:	48 83 c4 18          	add    $0x18,%rsp
  801b4e:	5b                   	pop    %rbx
  801b4f:	41 5c                	pop    %r12
  801b51:	41 5d                	pop    %r13
  801b53:	5d                   	pop    %rbp
  801b54:	c3                   	ret
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801b55:	8b 3b                	mov    (%rbx),%edi
  801b57:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801b5b:	48 b8 82 1a 80 00 00 	movabs $0x801a82,%rax
  801b62:	00 00 00 
  801b65:	ff d0                	call   *%rax
  801b67:	41 89 c5             	mov    %eax,%r13d
  801b6a:	85 c0                	test   %eax,%eax
  801b6c:	78 1b                	js     801b89 <fd_close+0x93>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  801b6e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b72:	48 8b 40 20          	mov    0x20(%rax),%rax
  801b76:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  801b7c:	48 85 c0             	test   %rax,%rax
  801b7f:	74 08                	je     801b89 <fd_close+0x93>
  801b81:	48 89 df             	mov    %rbx,%rdi
  801b84:	ff d0                	call   *%rax
  801b86:	41 89 c5             	mov    %eax,%r13d
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801b89:	ba 00 10 00 00       	mov    $0x1000,%edx
  801b8e:	48 89 de             	mov    %rbx,%rsi
  801b91:	bf 00 00 00 00       	mov    $0x0,%edi
  801b96:	48 b8 b9 15 80 00 00 	movabs $0x8015b9,%rax
  801b9d:	00 00 00 
  801ba0:	ff d0                	call   *%rax
    return res;
  801ba2:	eb a3                	jmp    801b47 <fd_close+0x51>

0000000000801ba4 <close>:

int
close(int fdnum) {
  801ba4:	f3 0f 1e fa          	endbr64
  801ba8:	55                   	push   %rbp
  801ba9:	48 89 e5             	mov    %rsp,%rbp
  801bac:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  801bb0:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801bb4:	48 b8 33 1a 80 00 00 	movabs $0x801a33,%rax
  801bbb:	00 00 00 
  801bbe:	ff d0                	call   *%rax
    if (res < 0) return res;
  801bc0:	85 c0                	test   %eax,%eax
  801bc2:	78 15                	js     801bd9 <close+0x35>

    return fd_close(fd, 1);
  801bc4:	be 01 00 00 00       	mov    $0x1,%esi
  801bc9:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801bcd:	48 b8 f6 1a 80 00 00 	movabs $0x801af6,%rax
  801bd4:	00 00 00 
  801bd7:	ff d0                	call   *%rax
}
  801bd9:	c9                   	leave
  801bda:	c3                   	ret

0000000000801bdb <close_all>:

void
close_all(void) {
  801bdb:	f3 0f 1e fa          	endbr64
  801bdf:	55                   	push   %rbp
  801be0:	48 89 e5             	mov    %rsp,%rbp
  801be3:	41 54                	push   %r12
  801be5:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  801be6:	bb 00 00 00 00       	mov    $0x0,%ebx
  801beb:	49 bc a4 1b 80 00 00 	movabs $0x801ba4,%r12
  801bf2:	00 00 00 
  801bf5:	89 df                	mov    %ebx,%edi
  801bf7:	41 ff d4             	call   *%r12
  801bfa:	83 c3 01             	add    $0x1,%ebx
  801bfd:	83 fb 20             	cmp    $0x20,%ebx
  801c00:	75 f3                	jne    801bf5 <close_all+0x1a>
}
  801c02:	5b                   	pop    %rbx
  801c03:	41 5c                	pop    %r12
  801c05:	5d                   	pop    %rbp
  801c06:	c3                   	ret

0000000000801c07 <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  801c07:	f3 0f 1e fa          	endbr64
  801c0b:	55                   	push   %rbp
  801c0c:	48 89 e5             	mov    %rsp,%rbp
  801c0f:	41 57                	push   %r15
  801c11:	41 56                	push   %r14
  801c13:	41 55                	push   %r13
  801c15:	41 54                	push   %r12
  801c17:	53                   	push   %rbx
  801c18:	48 83 ec 18          	sub    $0x18,%rsp
  801c1c:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  801c1f:	48 8d 75 c8          	lea    -0x38(%rbp),%rsi
  801c23:	48 b8 33 1a 80 00 00 	movabs $0x801a33,%rax
  801c2a:	00 00 00 
  801c2d:	ff d0                	call   *%rax
  801c2f:	89 c3                	mov    %eax,%ebx
  801c31:	85 c0                	test   %eax,%eax
  801c33:	0f 88 b8 00 00 00    	js     801cf1 <dup+0xea>
    close(newfdnum);
  801c39:	44 89 e7             	mov    %r12d,%edi
  801c3c:	48 b8 a4 1b 80 00 00 	movabs $0x801ba4,%rax
  801c43:	00 00 00 
  801c46:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  801c48:	4d 63 ec             	movslq %r12d,%r13
  801c4b:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  801c52:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  801c56:	4c 8b 7d c8          	mov    -0x38(%rbp),%r15
  801c5a:	4c 89 ff             	mov    %r15,%rdi
  801c5d:	49 be af 19 80 00 00 	movabs $0x8019af,%r14
  801c64:	00 00 00 
  801c67:	41 ff d6             	call   *%r14
  801c6a:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  801c6d:	4c 89 ef             	mov    %r13,%rdi
  801c70:	41 ff d6             	call   *%r14
  801c73:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  801c76:	48 89 df             	mov    %rbx,%rdi
  801c79:	48 b8 f5 2b 80 00 00 	movabs $0x802bf5,%rax
  801c80:	00 00 00 
  801c83:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  801c85:	a8 04                	test   $0x4,%al
  801c87:	74 2b                	je     801cb4 <dup+0xad>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  801c89:	41 89 c1             	mov    %eax,%r9d
  801c8c:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801c92:	4c 89 f1             	mov    %r14,%rcx
  801c95:	ba 00 00 00 00       	mov    $0x0,%edx
  801c9a:	48 89 de             	mov    %rbx,%rsi
  801c9d:	bf 00 00 00 00       	mov    $0x0,%edi
  801ca2:	48 b8 e4 14 80 00 00 	movabs $0x8014e4,%rax
  801ca9:	00 00 00 
  801cac:	ff d0                	call   *%rax
  801cae:	89 c3                	mov    %eax,%ebx
  801cb0:	85 c0                	test   %eax,%eax
  801cb2:	78 4e                	js     801d02 <dup+0xfb>
    }
    prot = get_prot(oldfd);
  801cb4:	4c 89 ff             	mov    %r15,%rdi
  801cb7:	48 b8 f5 2b 80 00 00 	movabs $0x802bf5,%rax
  801cbe:	00 00 00 
  801cc1:	ff d0                	call   *%rax
  801cc3:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  801cc6:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801ccc:	4c 89 e9             	mov    %r13,%rcx
  801ccf:	ba 00 00 00 00       	mov    $0x0,%edx
  801cd4:	4c 89 fe             	mov    %r15,%rsi
  801cd7:	bf 00 00 00 00       	mov    $0x0,%edi
  801cdc:	48 b8 e4 14 80 00 00 	movabs $0x8014e4,%rax
  801ce3:	00 00 00 
  801ce6:	ff d0                	call   *%rax
  801ce8:	89 c3                	mov    %eax,%ebx
  801cea:	85 c0                	test   %eax,%eax
  801cec:	78 14                	js     801d02 <dup+0xfb>

    return newfdnum;
  801cee:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  801cf1:	89 d8                	mov    %ebx,%eax
  801cf3:	48 83 c4 18          	add    $0x18,%rsp
  801cf7:	5b                   	pop    %rbx
  801cf8:	41 5c                	pop    %r12
  801cfa:	41 5d                	pop    %r13
  801cfc:	41 5e                	pop    %r14
  801cfe:	41 5f                	pop    %r15
  801d00:	5d                   	pop    %rbp
  801d01:	c3                   	ret
    sys_unmap_region(0, newfd, PAGE_SIZE);
  801d02:	ba 00 10 00 00       	mov    $0x1000,%edx
  801d07:	4c 89 ee             	mov    %r13,%rsi
  801d0a:	bf 00 00 00 00       	mov    $0x0,%edi
  801d0f:	49 bc b9 15 80 00 00 	movabs $0x8015b9,%r12
  801d16:	00 00 00 
  801d19:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  801d1c:	ba 00 10 00 00       	mov    $0x1000,%edx
  801d21:	4c 89 f6             	mov    %r14,%rsi
  801d24:	bf 00 00 00 00       	mov    $0x0,%edi
  801d29:	41 ff d4             	call   *%r12
    return res;
  801d2c:	eb c3                	jmp    801cf1 <dup+0xea>

0000000000801d2e <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  801d2e:	f3 0f 1e fa          	endbr64
  801d32:	55                   	push   %rbp
  801d33:	48 89 e5             	mov    %rsp,%rbp
  801d36:	41 56                	push   %r14
  801d38:	41 55                	push   %r13
  801d3a:	41 54                	push   %r12
  801d3c:	53                   	push   %rbx
  801d3d:	48 83 ec 10          	sub    $0x10,%rsp
  801d41:	89 fb                	mov    %edi,%ebx
  801d43:	49 89 f4             	mov    %rsi,%r12
  801d46:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801d49:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801d4d:	48 b8 33 1a 80 00 00 	movabs $0x801a33,%rax
  801d54:	00 00 00 
  801d57:	ff d0                	call   *%rax
  801d59:	85 c0                	test   %eax,%eax
  801d5b:	78 4c                	js     801da9 <read+0x7b>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801d5d:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801d61:	41 8b 3e             	mov    (%r14),%edi
  801d64:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801d68:	48 b8 82 1a 80 00 00 	movabs $0x801a82,%rax
  801d6f:	00 00 00 
  801d72:	ff d0                	call   *%rax
  801d74:	85 c0                	test   %eax,%eax
  801d76:	78 35                	js     801dad <read+0x7f>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801d78:	41 8b 46 08          	mov    0x8(%r14),%eax
  801d7c:	83 e0 03             	and    $0x3,%eax
  801d7f:	83 f8 01             	cmp    $0x1,%eax
  801d82:	74 2d                	je     801db1 <read+0x83>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  801d84:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d88:	48 8b 40 10          	mov    0x10(%rax),%rax
  801d8c:	48 85 c0             	test   %rax,%rax
  801d8f:	74 56                	je     801de7 <read+0xb9>

    return (*dev->dev_read)(fd, buf, n);
  801d91:	4c 89 ea             	mov    %r13,%rdx
  801d94:	4c 89 e6             	mov    %r12,%rsi
  801d97:	4c 89 f7             	mov    %r14,%rdi
  801d9a:	ff d0                	call   *%rax
}
  801d9c:	48 83 c4 10          	add    $0x10,%rsp
  801da0:	5b                   	pop    %rbx
  801da1:	41 5c                	pop    %r12
  801da3:	41 5d                	pop    %r13
  801da5:	41 5e                	pop    %r14
  801da7:	5d                   	pop    %rbp
  801da8:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801da9:	48 98                	cltq
  801dab:	eb ef                	jmp    801d9c <read+0x6e>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801dad:	48 98                	cltq
  801daf:	eb eb                	jmp    801d9c <read+0x6e>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801db1:	48 a1 00 64 80 00 00 	movabs 0x806400,%rax
  801db8:	00 00 00 
  801dbb:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801dc1:	89 da                	mov    %ebx,%edx
  801dc3:	48 bf 3b 42 80 00 00 	movabs $0x80423b,%rdi
  801dca:	00 00 00 
  801dcd:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd2:	48 b9 2b 05 80 00 00 	movabs $0x80052b,%rcx
  801dd9:	00 00 00 
  801ddc:	ff d1                	call   *%rcx
        return -E_INVAL;
  801dde:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801de5:	eb b5                	jmp    801d9c <read+0x6e>
    if (!dev->dev_read) return -E_NOT_SUPP;
  801de7:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801dee:	eb ac                	jmp    801d9c <read+0x6e>

0000000000801df0 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801df0:	f3 0f 1e fa          	endbr64
  801df4:	55                   	push   %rbp
  801df5:	48 89 e5             	mov    %rsp,%rbp
  801df8:	41 57                	push   %r15
  801dfa:	41 56                	push   %r14
  801dfc:	41 55                	push   %r13
  801dfe:	41 54                	push   %r12
  801e00:	53                   	push   %rbx
  801e01:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801e05:	48 85 d2             	test   %rdx,%rdx
  801e08:	74 54                	je     801e5e <readn+0x6e>
  801e0a:	41 89 fd             	mov    %edi,%r13d
  801e0d:	49 89 f6             	mov    %rsi,%r14
  801e10:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801e13:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801e18:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801e1d:	49 bf 2e 1d 80 00 00 	movabs $0x801d2e,%r15
  801e24:	00 00 00 
  801e27:	4c 89 e2             	mov    %r12,%rdx
  801e2a:	48 29 f2             	sub    %rsi,%rdx
  801e2d:	4c 01 f6             	add    %r14,%rsi
  801e30:	44 89 ef             	mov    %r13d,%edi
  801e33:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  801e36:	85 c0                	test   %eax,%eax
  801e38:	78 20                	js     801e5a <readn+0x6a>
    for (; inc && res < n; res += inc) {
  801e3a:	01 c3                	add    %eax,%ebx
  801e3c:	85 c0                	test   %eax,%eax
  801e3e:	74 08                	je     801e48 <readn+0x58>
  801e40:	48 63 f3             	movslq %ebx,%rsi
  801e43:	4c 39 e6             	cmp    %r12,%rsi
  801e46:	72 df                	jb     801e27 <readn+0x37>
    }
    return res;
  801e48:	48 63 c3             	movslq %ebx,%rax
}
  801e4b:	48 83 c4 08          	add    $0x8,%rsp
  801e4f:	5b                   	pop    %rbx
  801e50:	41 5c                	pop    %r12
  801e52:	41 5d                	pop    %r13
  801e54:	41 5e                	pop    %r14
  801e56:	41 5f                	pop    %r15
  801e58:	5d                   	pop    %rbp
  801e59:	c3                   	ret
        if (inc < 0) return inc;
  801e5a:	48 98                	cltq
  801e5c:	eb ed                	jmp    801e4b <readn+0x5b>
    int inc = 1, res = 0;
  801e5e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e63:	eb e3                	jmp    801e48 <readn+0x58>

0000000000801e65 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  801e65:	f3 0f 1e fa          	endbr64
  801e69:	55                   	push   %rbp
  801e6a:	48 89 e5             	mov    %rsp,%rbp
  801e6d:	41 56                	push   %r14
  801e6f:	41 55                	push   %r13
  801e71:	41 54                	push   %r12
  801e73:	53                   	push   %rbx
  801e74:	48 83 ec 10          	sub    $0x10,%rsp
  801e78:	89 fb                	mov    %edi,%ebx
  801e7a:	49 89 f4             	mov    %rsi,%r12
  801e7d:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801e80:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801e84:	48 b8 33 1a 80 00 00 	movabs $0x801a33,%rax
  801e8b:	00 00 00 
  801e8e:	ff d0                	call   *%rax
  801e90:	85 c0                	test   %eax,%eax
  801e92:	78 47                	js     801edb <write+0x76>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801e94:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801e98:	41 8b 3e             	mov    (%r14),%edi
  801e9b:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801e9f:	48 b8 82 1a 80 00 00 	movabs $0x801a82,%rax
  801ea6:	00 00 00 
  801ea9:	ff d0                	call   *%rax
  801eab:	85 c0                	test   %eax,%eax
  801ead:	78 30                	js     801edf <write+0x7a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801eaf:	41 f6 46 08 03       	testb  $0x3,0x8(%r14)
  801eb4:	74 2d                	je     801ee3 <write+0x7e>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801eb6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801eba:	48 8b 40 18          	mov    0x18(%rax),%rax
  801ebe:	48 85 c0             	test   %rax,%rax
  801ec1:	74 56                	je     801f19 <write+0xb4>

    return (*dev->dev_write)(fd, buf, n);
  801ec3:	4c 89 ea             	mov    %r13,%rdx
  801ec6:	4c 89 e6             	mov    %r12,%rsi
  801ec9:	4c 89 f7             	mov    %r14,%rdi
  801ecc:	ff d0                	call   *%rax
}
  801ece:	48 83 c4 10          	add    $0x10,%rsp
  801ed2:	5b                   	pop    %rbx
  801ed3:	41 5c                	pop    %r12
  801ed5:	41 5d                	pop    %r13
  801ed7:	41 5e                	pop    %r14
  801ed9:	5d                   	pop    %rbp
  801eda:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801edb:	48 98                	cltq
  801edd:	eb ef                	jmp    801ece <write+0x69>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801edf:	48 98                	cltq
  801ee1:	eb eb                	jmp    801ece <write+0x69>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801ee3:	48 a1 00 64 80 00 00 	movabs 0x806400,%rax
  801eea:	00 00 00 
  801eed:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801ef3:	89 da                	mov    %ebx,%edx
  801ef5:	48 bf 57 42 80 00 00 	movabs $0x804257,%rdi
  801efc:	00 00 00 
  801eff:	b8 00 00 00 00       	mov    $0x0,%eax
  801f04:	48 b9 2b 05 80 00 00 	movabs $0x80052b,%rcx
  801f0b:	00 00 00 
  801f0e:	ff d1                	call   *%rcx
        return -E_INVAL;
  801f10:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801f17:	eb b5                	jmp    801ece <write+0x69>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801f19:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801f20:	eb ac                	jmp    801ece <write+0x69>

0000000000801f22 <seek>:

int
seek(int fdnum, off_t offset) {
  801f22:	f3 0f 1e fa          	endbr64
  801f26:	55                   	push   %rbp
  801f27:	48 89 e5             	mov    %rsp,%rbp
  801f2a:	53                   	push   %rbx
  801f2b:	48 83 ec 18          	sub    $0x18,%rsp
  801f2f:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801f31:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801f35:	48 b8 33 1a 80 00 00 	movabs $0x801a33,%rax
  801f3c:	00 00 00 
  801f3f:	ff d0                	call   *%rax
  801f41:	85 c0                	test   %eax,%eax
  801f43:	78 0c                	js     801f51 <seek+0x2f>

    fd->fd_offset = offset;
  801f45:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f49:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  801f4c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f51:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801f55:	c9                   	leave
  801f56:	c3                   	ret

0000000000801f57 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  801f57:	f3 0f 1e fa          	endbr64
  801f5b:	55                   	push   %rbp
  801f5c:	48 89 e5             	mov    %rsp,%rbp
  801f5f:	41 55                	push   %r13
  801f61:	41 54                	push   %r12
  801f63:	53                   	push   %rbx
  801f64:	48 83 ec 18          	sub    $0x18,%rsp
  801f68:	89 fb                	mov    %edi,%ebx
  801f6a:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801f6d:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801f71:	48 b8 33 1a 80 00 00 	movabs $0x801a33,%rax
  801f78:	00 00 00 
  801f7b:	ff d0                	call   *%rax
  801f7d:	85 c0                	test   %eax,%eax
  801f7f:	78 38                	js     801fb9 <ftruncate+0x62>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801f81:	4c 8b 6d d8          	mov    -0x28(%rbp),%r13
  801f85:	41 8b 7d 00          	mov    0x0(%r13),%edi
  801f89:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801f8d:	48 b8 82 1a 80 00 00 	movabs $0x801a82,%rax
  801f94:	00 00 00 
  801f97:	ff d0                	call   *%rax
  801f99:	85 c0                	test   %eax,%eax
  801f9b:	78 1c                	js     801fb9 <ftruncate+0x62>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801f9d:	41 f6 45 08 03       	testb  $0x3,0x8(%r13)
  801fa2:	74 20                	je     801fc4 <ftruncate+0x6d>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801fa4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801fa8:	48 8b 40 30          	mov    0x30(%rax),%rax
  801fac:	48 85 c0             	test   %rax,%rax
  801faf:	74 47                	je     801ff8 <ftruncate+0xa1>

    return (*dev->dev_trunc)(fd, newsize);
  801fb1:	44 89 e6             	mov    %r12d,%esi
  801fb4:	4c 89 ef             	mov    %r13,%rdi
  801fb7:	ff d0                	call   *%rax
}
  801fb9:	48 83 c4 18          	add    $0x18,%rsp
  801fbd:	5b                   	pop    %rbx
  801fbe:	41 5c                	pop    %r12
  801fc0:	41 5d                	pop    %r13
  801fc2:	5d                   	pop    %rbp
  801fc3:	c3                   	ret
                thisenv->env_id, fdnum);
  801fc4:	48 a1 00 64 80 00 00 	movabs 0x806400,%rax
  801fcb:	00 00 00 
  801fce:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801fd4:	89 da                	mov    %ebx,%edx
  801fd6:	48 bf a0 44 80 00 00 	movabs $0x8044a0,%rdi
  801fdd:	00 00 00 
  801fe0:	b8 00 00 00 00       	mov    $0x0,%eax
  801fe5:	48 b9 2b 05 80 00 00 	movabs $0x80052b,%rcx
  801fec:	00 00 00 
  801fef:	ff d1                	call   *%rcx
        return -E_INVAL;
  801ff1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ff6:	eb c1                	jmp    801fb9 <ftruncate+0x62>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801ff8:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801ffd:	eb ba                	jmp    801fb9 <ftruncate+0x62>

0000000000801fff <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  801fff:	f3 0f 1e fa          	endbr64
  802003:	55                   	push   %rbp
  802004:	48 89 e5             	mov    %rsp,%rbp
  802007:	41 54                	push   %r12
  802009:	53                   	push   %rbx
  80200a:	48 83 ec 10          	sub    $0x10,%rsp
  80200e:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  802011:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  802015:	48 b8 33 1a 80 00 00 	movabs $0x801a33,%rax
  80201c:	00 00 00 
  80201f:	ff d0                	call   *%rax
  802021:	85 c0                	test   %eax,%eax
  802023:	78 4e                	js     802073 <fstat+0x74>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  802025:	4c 8b 65 e8          	mov    -0x18(%rbp),%r12
  802029:	41 8b 3c 24          	mov    (%r12),%edi
  80202d:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  802031:	48 b8 82 1a 80 00 00 	movabs $0x801a82,%rax
  802038:	00 00 00 
  80203b:	ff d0                	call   *%rax
  80203d:	85 c0                	test   %eax,%eax
  80203f:	78 32                	js     802073 <fstat+0x74>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  802041:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802045:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  80204a:	74 30                	je     80207c <fstat+0x7d>

    stat->st_name[0] = 0;
  80204c:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  80204f:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  802056:	00 00 00 
    stat->st_isdir = 0;
  802059:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  802060:	00 00 00 
    stat->st_dev = dev;
  802063:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  80206a:	48 89 de             	mov    %rbx,%rsi
  80206d:	4c 89 e7             	mov    %r12,%rdi
  802070:	ff 50 28             	call   *0x28(%rax)
}
  802073:	48 83 c4 10          	add    $0x10,%rsp
  802077:	5b                   	pop    %rbx
  802078:	41 5c                	pop    %r12
  80207a:	5d                   	pop    %rbp
  80207b:	c3                   	ret
    if (!dev->dev_stat) return -E_NOT_SUPP;
  80207c:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  802081:	eb f0                	jmp    802073 <fstat+0x74>

0000000000802083 <stat>:

int
stat(const char *path, struct Stat *stat) {
  802083:	f3 0f 1e fa          	endbr64
  802087:	55                   	push   %rbp
  802088:	48 89 e5             	mov    %rsp,%rbp
  80208b:	41 54                	push   %r12
  80208d:	53                   	push   %rbx
  80208e:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  802091:	be 00 00 00 00       	mov    $0x0,%esi
  802096:	48 b8 64 23 80 00 00 	movabs $0x802364,%rax
  80209d:	00 00 00 
  8020a0:	ff d0                	call   *%rax
  8020a2:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  8020a4:	85 c0                	test   %eax,%eax
  8020a6:	78 25                	js     8020cd <stat+0x4a>

    int res = fstat(fd, stat);
  8020a8:	4c 89 e6             	mov    %r12,%rsi
  8020ab:	89 c7                	mov    %eax,%edi
  8020ad:	48 b8 ff 1f 80 00 00 	movabs $0x801fff,%rax
  8020b4:	00 00 00 
  8020b7:	ff d0                	call   *%rax
  8020b9:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  8020bc:	89 df                	mov    %ebx,%edi
  8020be:	48 b8 a4 1b 80 00 00 	movabs $0x801ba4,%rax
  8020c5:	00 00 00 
  8020c8:	ff d0                	call   *%rax

    return res;
  8020ca:	44 89 e3             	mov    %r12d,%ebx
}
  8020cd:	89 d8                	mov    %ebx,%eax
  8020cf:	5b                   	pop    %rbx
  8020d0:	41 5c                	pop    %r12
  8020d2:	5d                   	pop    %rbp
  8020d3:	c3                   	ret

00000000008020d4 <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  8020d4:	f3 0f 1e fa          	endbr64
  8020d8:	55                   	push   %rbp
  8020d9:	48 89 e5             	mov    %rsp,%rbp
  8020dc:	41 54                	push   %r12
  8020de:	53                   	push   %rbx
  8020df:	48 83 ec 10          	sub    $0x10,%rsp
  8020e3:	41 89 fc             	mov    %edi,%r12d
  8020e6:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  8020e9:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8020f0:	00 00 00 
  8020f3:	83 38 00             	cmpl   $0x0,(%rax)
  8020f6:	74 6e                	je     802166 <fsipc+0x92>

    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }
    fsenv = ipc_find_env(ENV_TYPE_FS);
  8020f8:	bf 03 00 00 00       	mov    $0x3,%edi
  8020fd:	48 b8 a8 31 80 00 00 	movabs $0x8031a8,%rax
  802104:	00 00 00 
  802107:	ff d0                	call   *%rax
  802109:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  802110:	00 00 
    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  802112:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  802118:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80211d:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802124:	00 00 00 
  802127:	44 89 e6             	mov    %r12d,%esi
  80212a:	89 c7                	mov    %eax,%edi
  80212c:	48 b8 e6 30 80 00 00 	movabs $0x8030e6,%rax
  802133:	00 00 00 
  802136:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  802138:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  80213f:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  802140:	b9 00 00 00 00       	mov    $0x0,%ecx
  802145:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802149:	48 89 de             	mov    %rbx,%rsi
  80214c:	bf 00 00 00 00       	mov    $0x0,%edi
  802151:	48 b8 4d 30 80 00 00 	movabs $0x80304d,%rax
  802158:	00 00 00 
  80215b:	ff d0                	call   *%rax
}
  80215d:	48 83 c4 10          	add    $0x10,%rsp
  802161:	5b                   	pop    %rbx
  802162:	41 5c                	pop    %r12
  802164:	5d                   	pop    %rbp
  802165:	c3                   	ret
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  802166:	bf 03 00 00 00       	mov    $0x3,%edi
  80216b:	48 b8 a8 31 80 00 00 	movabs $0x8031a8,%rax
  802172:	00 00 00 
  802175:	ff d0                	call   *%rax
  802177:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  80217e:	00 00 
  802180:	e9 73 ff ff ff       	jmp    8020f8 <fsipc+0x24>

0000000000802185 <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  802185:	f3 0f 1e fa          	endbr64
  802189:	55                   	push   %rbp
  80218a:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80218d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802194:	00 00 00 
  802197:	8b 57 0c             	mov    0xc(%rdi),%edx
  80219a:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  80219c:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  80219f:	be 00 00 00 00       	mov    $0x0,%esi
  8021a4:	bf 02 00 00 00       	mov    $0x2,%edi
  8021a9:	48 b8 d4 20 80 00 00 	movabs $0x8020d4,%rax
  8021b0:	00 00 00 
  8021b3:	ff d0                	call   *%rax
}
  8021b5:	5d                   	pop    %rbp
  8021b6:	c3                   	ret

00000000008021b7 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  8021b7:	f3 0f 1e fa          	endbr64
  8021bb:	55                   	push   %rbp
  8021bc:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8021bf:	8b 47 0c             	mov    0xc(%rdi),%eax
  8021c2:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  8021c9:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  8021cb:	be 00 00 00 00       	mov    $0x0,%esi
  8021d0:	bf 06 00 00 00       	mov    $0x6,%edi
  8021d5:	48 b8 d4 20 80 00 00 	movabs $0x8020d4,%rax
  8021dc:	00 00 00 
  8021df:	ff d0                	call   *%rax
}
  8021e1:	5d                   	pop    %rbp
  8021e2:	c3                   	ret

00000000008021e3 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  8021e3:	f3 0f 1e fa          	endbr64
  8021e7:	55                   	push   %rbp
  8021e8:	48 89 e5             	mov    %rsp,%rbp
  8021eb:	41 54                	push   %r12
  8021ed:	53                   	push   %rbx
  8021ee:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8021f1:	8b 47 0c             	mov    0xc(%rdi),%eax
  8021f4:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  8021fb:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  8021fd:	be 00 00 00 00       	mov    $0x0,%esi
  802202:	bf 05 00 00 00       	mov    $0x5,%edi
  802207:	48 b8 d4 20 80 00 00 	movabs $0x8020d4,%rax
  80220e:	00 00 00 
  802211:	ff d0                	call   *%rax
    if (res < 0) return res;
  802213:	85 c0                	test   %eax,%eax
  802215:	78 3d                	js     802254 <devfile_stat+0x71>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802217:	49 bc 00 70 80 00 00 	movabs $0x807000,%r12
  80221e:	00 00 00 
  802221:	4c 89 e6             	mov    %r12,%rsi
  802224:	48 89 df             	mov    %rbx,%rdi
  802227:	48 b8 74 0e 80 00 00 	movabs $0x800e74,%rax
  80222e:	00 00 00 
  802231:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  802233:	41 8b 84 24 80 00 00 	mov    0x80(%r12),%eax
  80223a:	00 
  80223b:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802241:	41 8b 84 24 84 00 00 	mov    0x84(%r12),%eax
  802248:	00 
  802249:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  80224f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802254:	5b                   	pop    %rbx
  802255:	41 5c                	pop    %r12
  802257:	5d                   	pop    %rbp
  802258:	c3                   	ret

0000000000802259 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  802259:	f3 0f 1e fa          	endbr64
    if (n >= sizeof(fsipcbuf.write.req_buf)) {
  80225d:	48 81 fa ef 0f 00 00 	cmp    $0xfef,%rdx
  802264:	77 41                	ja     8022a7 <devfile_write+0x4e>
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  802266:	55                   	push   %rbp
  802267:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  80226a:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802271:	00 00 00 
  802274:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  802277:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.write.req_n = n;
  802279:	48 89 50 08          	mov    %rdx,0x8(%rax)
    memmove(fsipcbuf.write.req_buf, buf, n);
  80227d:	48 8d 78 10          	lea    0x10(%rax),%rdi
  802281:	48 b8 8f 10 80 00 00 	movabs $0x80108f,%rax
  802288:	00 00 00 
  80228b:	ff d0                	call   *%rax
    res = fsipc(FSREQ_WRITE, NULL);
  80228d:	be 00 00 00 00       	mov    $0x0,%esi
  802292:	bf 04 00 00 00       	mov    $0x4,%edi
  802297:	48 b8 d4 20 80 00 00 	movabs $0x8020d4,%rax
  80229e:	00 00 00 
  8022a1:	ff d0                	call   *%rax
  8022a3:	48 98                	cltq
}
  8022a5:	5d                   	pop    %rbp
  8022a6:	c3                   	ret
        return -E_INVAL;
  8022a7:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
}
  8022ae:	c3                   	ret

00000000008022af <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  8022af:	f3 0f 1e fa          	endbr64
  8022b3:	55                   	push   %rbp
  8022b4:	48 89 e5             	mov    %rsp,%rbp
  8022b7:	41 55                	push   %r13
  8022b9:	41 54                	push   %r12
  8022bb:	53                   	push   %rbx
  8022bc:	48 83 ec 08          	sub    $0x8,%rsp
  8022c0:	49 89 f4             	mov    %rsi,%r12
  8022c3:	48 89 d3             	mov    %rdx,%rbx
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  8022c6:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8022cd:	00 00 00 
  8022d0:	8b 57 0c             	mov    0xc(%rdi),%edx
  8022d3:	89 10                	mov    %edx,(%rax)
    fsipcbuf.read.req_n = n;
  8022d5:	48 89 58 08          	mov    %rbx,0x8(%rax)
    res = fsipc(FSREQ_READ, NULL);
  8022d9:	be 00 00 00 00       	mov    $0x0,%esi
  8022de:	bf 03 00 00 00       	mov    $0x3,%edi
  8022e3:	48 b8 d4 20 80 00 00 	movabs $0x8020d4,%rax
  8022ea:	00 00 00 
  8022ed:	ff d0                	call   *%rax
  8022ef:	4c 63 e8             	movslq %eax,%r13
    if (res < 0) {
  8022f2:	4d 85 ed             	test   %r13,%r13
  8022f5:	78 2a                	js     802321 <devfile_read+0x72>
    assert(res <= n && res <= PAGE_SIZE);
  8022f7:	4c 89 ea             	mov    %r13,%rdx
  8022fa:	4c 39 eb             	cmp    %r13,%rbx
  8022fd:	72 30                	jb     80232f <devfile_read+0x80>
  8022ff:	49 81 fd 00 10 00 00 	cmp    $0x1000,%r13
  802306:	7f 27                	jg     80232f <devfile_read+0x80>
    memmove(buf, &fsipcbuf, res);
  802308:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  80230f:	00 00 00 
  802312:	4c 89 e7             	mov    %r12,%rdi
  802315:	48 b8 8f 10 80 00 00 	movabs $0x80108f,%rax
  80231c:	00 00 00 
  80231f:	ff d0                	call   *%rax
}
  802321:	4c 89 e8             	mov    %r13,%rax
  802324:	48 83 c4 08          	add    $0x8,%rsp
  802328:	5b                   	pop    %rbx
  802329:	41 5c                	pop    %r12
  80232b:	41 5d                	pop    %r13
  80232d:	5d                   	pop    %rbp
  80232e:	c3                   	ret
    assert(res <= n && res <= PAGE_SIZE);
  80232f:	48 b9 74 42 80 00 00 	movabs $0x804274,%rcx
  802336:	00 00 00 
  802339:	48 ba 91 42 80 00 00 	movabs $0x804291,%rdx
  802340:	00 00 00 
  802343:	be 7b 00 00 00       	mov    $0x7b,%esi
  802348:	48 bf a6 42 80 00 00 	movabs $0x8042a6,%rdi
  80234f:	00 00 00 
  802352:	b8 00 00 00 00       	mov    $0x0,%eax
  802357:	49 b8 cf 03 80 00 00 	movabs $0x8003cf,%r8
  80235e:	00 00 00 
  802361:	41 ff d0             	call   *%r8

0000000000802364 <open>:
open(const char *path, int mode) {
  802364:	f3 0f 1e fa          	endbr64
  802368:	55                   	push   %rbp
  802369:	48 89 e5             	mov    %rsp,%rbp
  80236c:	41 55                	push   %r13
  80236e:	41 54                	push   %r12
  802370:	53                   	push   %rbx
  802371:	48 83 ec 18          	sub    $0x18,%rsp
  802375:	49 89 fc             	mov    %rdi,%r12
  802378:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  80237b:	48 b8 2f 0e 80 00 00 	movabs $0x800e2f,%rax
  802382:	00 00 00 
  802385:	ff d0                	call   *%rax
  802387:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  80238d:	0f 87 8a 00 00 00    	ja     80241d <open+0xb9>
    if ((res = fd_alloc(&fd)) < 0) return res;
  802393:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802397:	48 b8 cf 19 80 00 00 	movabs $0x8019cf,%rax
  80239e:	00 00 00 
  8023a1:	ff d0                	call   *%rax
  8023a3:	89 c3                	mov    %eax,%ebx
  8023a5:	85 c0                	test   %eax,%eax
  8023a7:	78 50                	js     8023f9 <open+0x95>
    strcpy(fsipcbuf.open.req_path, path);
  8023a9:	4c 89 e6             	mov    %r12,%rsi
  8023ac:	48 bb 00 70 80 00 00 	movabs $0x807000,%rbx
  8023b3:	00 00 00 
  8023b6:	48 89 df             	mov    %rbx,%rdi
  8023b9:	48 b8 74 0e 80 00 00 	movabs $0x800e74,%rax
  8023c0:	00 00 00 
  8023c3:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  8023c5:	44 89 ab 00 04 00 00 	mov    %r13d,0x400(%rbx)
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  8023cc:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8023d0:	bf 01 00 00 00       	mov    $0x1,%edi
  8023d5:	48 b8 d4 20 80 00 00 	movabs $0x8020d4,%rax
  8023dc:	00 00 00 
  8023df:	ff d0                	call   *%rax
  8023e1:	89 c3                	mov    %eax,%ebx
  8023e3:	85 c0                	test   %eax,%eax
  8023e5:	78 1f                	js     802406 <open+0xa2>
    return fd2num(fd);
  8023e7:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8023eb:	48 b8 99 19 80 00 00 	movabs $0x801999,%rax
  8023f2:	00 00 00 
  8023f5:	ff d0                	call   *%rax
  8023f7:	89 c3                	mov    %eax,%ebx
}
  8023f9:	89 d8                	mov    %ebx,%eax
  8023fb:	48 83 c4 18          	add    $0x18,%rsp
  8023ff:	5b                   	pop    %rbx
  802400:	41 5c                	pop    %r12
  802402:	41 5d                	pop    %r13
  802404:	5d                   	pop    %rbp
  802405:	c3                   	ret
        fd_close(fd, 0);
  802406:	be 00 00 00 00       	mov    $0x0,%esi
  80240b:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80240f:	48 b8 f6 1a 80 00 00 	movabs $0x801af6,%rax
  802416:	00 00 00 
  802419:	ff d0                	call   *%rax
        return res;
  80241b:	eb dc                	jmp    8023f9 <open+0x95>
        return -E_BAD_PATH;
  80241d:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  802422:	eb d5                	jmp    8023f9 <open+0x95>

0000000000802424 <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  802424:	f3 0f 1e fa          	endbr64
  802428:	55                   	push   %rbp
  802429:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  80242c:	be 00 00 00 00       	mov    $0x0,%esi
  802431:	bf 08 00 00 00       	mov    $0x8,%edi
  802436:	48 b8 d4 20 80 00 00 	movabs $0x8020d4,%rax
  80243d:	00 00 00 
  802440:	ff d0                	call   *%rax
}
  802442:	5d                   	pop    %rbp
  802443:	c3                   	ret

0000000000802444 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  802444:	f3 0f 1e fa          	endbr64
  802448:	55                   	push   %rbp
  802449:	48 89 e5             	mov    %rsp,%rbp
  80244c:	41 54                	push   %r12
  80244e:	53                   	push   %rbx
  80244f:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802452:	48 b8 af 19 80 00 00 	movabs $0x8019af,%rax
  802459:	00 00 00 
  80245c:	ff d0                	call   *%rax
  80245e:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  802461:	48 be b1 42 80 00 00 	movabs $0x8042b1,%rsi
  802468:	00 00 00 
  80246b:	48 89 df             	mov    %rbx,%rdi
  80246e:	48 b8 74 0e 80 00 00 	movabs $0x800e74,%rax
  802475:	00 00 00 
  802478:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  80247a:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  80247f:	41 2b 04 24          	sub    (%r12),%eax
  802483:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  802489:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  802490:	00 00 00 
    stat->st_dev = &devpipe;
  802493:	48 b8 60 50 80 00 00 	movabs $0x805060,%rax
  80249a:	00 00 00 
  80249d:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  8024a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8024a9:	5b                   	pop    %rbx
  8024aa:	41 5c                	pop    %r12
  8024ac:	5d                   	pop    %rbp
  8024ad:	c3                   	ret

00000000008024ae <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  8024ae:	f3 0f 1e fa          	endbr64
  8024b2:	55                   	push   %rbp
  8024b3:	48 89 e5             	mov    %rsp,%rbp
  8024b6:	41 54                	push   %r12
  8024b8:	53                   	push   %rbx
  8024b9:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  8024bc:	ba 00 10 00 00       	mov    $0x1000,%edx
  8024c1:	48 89 fe             	mov    %rdi,%rsi
  8024c4:	bf 00 00 00 00       	mov    $0x0,%edi
  8024c9:	49 bc b9 15 80 00 00 	movabs $0x8015b9,%r12
  8024d0:	00 00 00 
  8024d3:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  8024d6:	48 89 df             	mov    %rbx,%rdi
  8024d9:	48 b8 af 19 80 00 00 	movabs $0x8019af,%rax
  8024e0:	00 00 00 
  8024e3:	ff d0                	call   *%rax
  8024e5:	48 89 c6             	mov    %rax,%rsi
  8024e8:	ba 00 10 00 00       	mov    $0x1000,%edx
  8024ed:	bf 00 00 00 00       	mov    $0x0,%edi
  8024f2:	41 ff d4             	call   *%r12
}
  8024f5:	5b                   	pop    %rbx
  8024f6:	41 5c                	pop    %r12
  8024f8:	5d                   	pop    %rbp
  8024f9:	c3                   	ret

00000000008024fa <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  8024fa:	f3 0f 1e fa          	endbr64
  8024fe:	55                   	push   %rbp
  8024ff:	48 89 e5             	mov    %rsp,%rbp
  802502:	41 57                	push   %r15
  802504:	41 56                	push   %r14
  802506:	41 55                	push   %r13
  802508:	41 54                	push   %r12
  80250a:	53                   	push   %rbx
  80250b:	48 83 ec 18          	sub    $0x18,%rsp
  80250f:	49 89 fc             	mov    %rdi,%r12
  802512:	49 89 f5             	mov    %rsi,%r13
  802515:	49 89 d7             	mov    %rdx,%r15
  802518:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  80251c:	48 b8 af 19 80 00 00 	movabs $0x8019af,%rax
  802523:	00 00 00 
  802526:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  802528:	4d 85 ff             	test   %r15,%r15
  80252b:	0f 84 af 00 00 00    	je     8025e0 <devpipe_write+0xe6>
  802531:	48 89 c3             	mov    %rax,%rbx
  802534:	4c 89 f8             	mov    %r15,%rax
  802537:	4d 89 ef             	mov    %r13,%r15
  80253a:	4c 01 e8             	add    %r13,%rax
  80253d:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802541:	49 bd 49 14 80 00 00 	movabs $0x801449,%r13
  802548:	00 00 00 
            sys_yield();
  80254b:	49 be de 13 80 00 00 	movabs $0x8013de,%r14
  802552:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  802555:	8b 73 04             	mov    0x4(%rbx),%esi
  802558:	48 63 ce             	movslq %esi,%rcx
  80255b:	48 63 03             	movslq (%rbx),%rax
  80255e:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  802564:	48 39 c1             	cmp    %rax,%rcx
  802567:	72 2e                	jb     802597 <devpipe_write+0x9d>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802569:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80256e:	48 89 da             	mov    %rbx,%rdx
  802571:	be 00 10 00 00       	mov    $0x1000,%esi
  802576:	4c 89 e7             	mov    %r12,%rdi
  802579:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  80257c:	85 c0                	test   %eax,%eax
  80257e:	74 66                	je     8025e6 <devpipe_write+0xec>
            sys_yield();
  802580:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  802583:	8b 73 04             	mov    0x4(%rbx),%esi
  802586:	48 63 ce             	movslq %esi,%rcx
  802589:	48 63 03             	movslq (%rbx),%rax
  80258c:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  802592:	48 39 c1             	cmp    %rax,%rcx
  802595:	73 d2                	jae    802569 <devpipe_write+0x6f>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802597:	41 0f b6 3f          	movzbl (%r15),%edi
  80259b:	48 89 ca             	mov    %rcx,%rdx
  80259e:	48 c1 ea 03          	shr    $0x3,%rdx
  8025a2:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  8025a9:	08 10 20 
  8025ac:	48 f7 e2             	mul    %rdx
  8025af:	48 c1 ea 06          	shr    $0x6,%rdx
  8025b3:	48 89 d0             	mov    %rdx,%rax
  8025b6:	48 c1 e0 09          	shl    $0x9,%rax
  8025ba:	48 29 d0             	sub    %rdx,%rax
  8025bd:	48 c1 e0 03          	shl    $0x3,%rax
  8025c1:	48 29 c1             	sub    %rax,%rcx
  8025c4:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  8025c9:	83 c6 01             	add    $0x1,%esi
  8025cc:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  8025cf:	49 83 c7 01          	add    $0x1,%r15
  8025d3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8025d7:	49 39 c7             	cmp    %rax,%r15
  8025da:	0f 85 75 ff ff ff    	jne    802555 <devpipe_write+0x5b>
    return n;
  8025e0:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8025e4:	eb 05                	jmp    8025eb <devpipe_write+0xf1>
            if (_pipeisclosed(fd, p)) return 0;
  8025e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025eb:	48 83 c4 18          	add    $0x18,%rsp
  8025ef:	5b                   	pop    %rbx
  8025f0:	41 5c                	pop    %r12
  8025f2:	41 5d                	pop    %r13
  8025f4:	41 5e                	pop    %r14
  8025f6:	41 5f                	pop    %r15
  8025f8:	5d                   	pop    %rbp
  8025f9:	c3                   	ret

00000000008025fa <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  8025fa:	f3 0f 1e fa          	endbr64
  8025fe:	55                   	push   %rbp
  8025ff:	48 89 e5             	mov    %rsp,%rbp
  802602:	41 57                	push   %r15
  802604:	41 56                	push   %r14
  802606:	41 55                	push   %r13
  802608:	41 54                	push   %r12
  80260a:	53                   	push   %rbx
  80260b:	48 83 ec 18          	sub    $0x18,%rsp
  80260f:	49 89 fc             	mov    %rdi,%r12
  802612:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  802616:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  80261a:	48 b8 af 19 80 00 00 	movabs $0x8019af,%rax
  802621:	00 00 00 
  802624:	ff d0                	call   *%rax
  802626:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  802629:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80262f:	49 bd 49 14 80 00 00 	movabs $0x801449,%r13
  802636:	00 00 00 
            sys_yield();
  802639:	49 be de 13 80 00 00 	movabs $0x8013de,%r14
  802640:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  802643:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  802648:	74 7d                	je     8026c7 <devpipe_read+0xcd>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  80264a:	8b 03                	mov    (%rbx),%eax
  80264c:	3b 43 04             	cmp    0x4(%rbx),%eax
  80264f:	75 26                	jne    802677 <devpipe_read+0x7d>
            if (i > 0) return i;
  802651:	4d 85 ff             	test   %r15,%r15
  802654:	75 77                	jne    8026cd <devpipe_read+0xd3>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802656:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80265b:	48 89 da             	mov    %rbx,%rdx
  80265e:	be 00 10 00 00       	mov    $0x1000,%esi
  802663:	4c 89 e7             	mov    %r12,%rdi
  802666:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802669:	85 c0                	test   %eax,%eax
  80266b:	74 72                	je     8026df <devpipe_read+0xe5>
            sys_yield();
  80266d:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802670:	8b 03                	mov    (%rbx),%eax
  802672:	3b 43 04             	cmp    0x4(%rbx),%eax
  802675:	74 df                	je     802656 <devpipe_read+0x5c>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802677:	48 63 c8             	movslq %eax,%rcx
  80267a:	48 89 ca             	mov    %rcx,%rdx
  80267d:	48 c1 ea 03          	shr    $0x3,%rdx
  802681:	48 be 81 00 01 02 04 	movabs $0x2010080402010081,%rsi
  802688:	08 10 20 
  80268b:	48 89 d0             	mov    %rdx,%rax
  80268e:	48 f7 e6             	mul    %rsi
  802691:	48 c1 ea 06          	shr    $0x6,%rdx
  802695:	48 89 d0             	mov    %rdx,%rax
  802698:	48 c1 e0 09          	shl    $0x9,%rax
  80269c:	48 29 d0             	sub    %rdx,%rax
  80269f:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8026a6:	00 
  8026a7:	48 89 c8             	mov    %rcx,%rax
  8026aa:	48 29 d0             	sub    %rdx,%rax
  8026ad:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  8026b2:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8026b6:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  8026ba:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  8026bd:	49 83 c7 01          	add    $0x1,%r15
  8026c1:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  8026c5:	75 83                	jne    80264a <devpipe_read+0x50>
    return n;
  8026c7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8026cb:	eb 03                	jmp    8026d0 <devpipe_read+0xd6>
            if (i > 0) return i;
  8026cd:	4c 89 f8             	mov    %r15,%rax
}
  8026d0:	48 83 c4 18          	add    $0x18,%rsp
  8026d4:	5b                   	pop    %rbx
  8026d5:	41 5c                	pop    %r12
  8026d7:	41 5d                	pop    %r13
  8026d9:	41 5e                	pop    %r14
  8026db:	41 5f                	pop    %r15
  8026dd:	5d                   	pop    %rbp
  8026de:	c3                   	ret
            if (_pipeisclosed(fd, p)) return 0;
  8026df:	b8 00 00 00 00       	mov    $0x0,%eax
  8026e4:	eb ea                	jmp    8026d0 <devpipe_read+0xd6>

00000000008026e6 <pipe>:
pipe(int pfd[2]) {
  8026e6:	f3 0f 1e fa          	endbr64
  8026ea:	55                   	push   %rbp
  8026eb:	48 89 e5             	mov    %rsp,%rbp
  8026ee:	41 55                	push   %r13
  8026f0:	41 54                	push   %r12
  8026f2:	53                   	push   %rbx
  8026f3:	48 83 ec 18          	sub    $0x18,%rsp
  8026f7:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  8026fa:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  8026fe:	48 b8 cf 19 80 00 00 	movabs $0x8019cf,%rax
  802705:	00 00 00 
  802708:	ff d0                	call   *%rax
  80270a:	89 c3                	mov    %eax,%ebx
  80270c:	85 c0                	test   %eax,%eax
  80270e:	0f 88 a0 01 00 00    	js     8028b4 <pipe+0x1ce>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  802714:	b9 46 00 00 00       	mov    $0x46,%ecx
  802719:	ba 00 10 00 00       	mov    $0x1000,%edx
  80271e:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802722:	bf 00 00 00 00       	mov    $0x0,%edi
  802727:	48 b8 79 14 80 00 00 	movabs $0x801479,%rax
  80272e:	00 00 00 
  802731:	ff d0                	call   *%rax
  802733:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  802735:	85 c0                	test   %eax,%eax
  802737:	0f 88 77 01 00 00    	js     8028b4 <pipe+0x1ce>
    if ((res = fd_alloc(&fd1)) < 0 ||
  80273d:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  802741:	48 b8 cf 19 80 00 00 	movabs $0x8019cf,%rax
  802748:	00 00 00 
  80274b:	ff d0                	call   *%rax
  80274d:	89 c3                	mov    %eax,%ebx
  80274f:	85 c0                	test   %eax,%eax
  802751:	0f 88 43 01 00 00    	js     80289a <pipe+0x1b4>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  802757:	b9 46 00 00 00       	mov    $0x46,%ecx
  80275c:	ba 00 10 00 00       	mov    $0x1000,%edx
  802761:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802765:	bf 00 00 00 00       	mov    $0x0,%edi
  80276a:	48 b8 79 14 80 00 00 	movabs $0x801479,%rax
  802771:	00 00 00 
  802774:	ff d0                	call   *%rax
  802776:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  802778:	85 c0                	test   %eax,%eax
  80277a:	0f 88 1a 01 00 00    	js     80289a <pipe+0x1b4>
    va = fd2data(fd0);
  802780:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802784:	48 b8 af 19 80 00 00 	movabs $0x8019af,%rax
  80278b:	00 00 00 
  80278e:	ff d0                	call   *%rax
  802790:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  802793:	b9 46 00 00 00       	mov    $0x46,%ecx
  802798:	ba 00 10 00 00       	mov    $0x1000,%edx
  80279d:	48 89 c6             	mov    %rax,%rsi
  8027a0:	bf 00 00 00 00       	mov    $0x0,%edi
  8027a5:	48 b8 79 14 80 00 00 	movabs $0x801479,%rax
  8027ac:	00 00 00 
  8027af:	ff d0                	call   *%rax
  8027b1:	89 c3                	mov    %eax,%ebx
  8027b3:	85 c0                	test   %eax,%eax
  8027b5:	0f 88 c5 00 00 00    	js     802880 <pipe+0x19a>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  8027bb:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8027bf:	48 b8 af 19 80 00 00 	movabs $0x8019af,%rax
  8027c6:	00 00 00 
  8027c9:	ff d0                	call   *%rax
  8027cb:	48 89 c1             	mov    %rax,%rcx
  8027ce:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  8027d4:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8027da:	ba 00 00 00 00       	mov    $0x0,%edx
  8027df:	4c 89 ee             	mov    %r13,%rsi
  8027e2:	bf 00 00 00 00       	mov    $0x0,%edi
  8027e7:	48 b8 e4 14 80 00 00 	movabs $0x8014e4,%rax
  8027ee:	00 00 00 
  8027f1:	ff d0                	call   *%rax
  8027f3:	89 c3                	mov    %eax,%ebx
  8027f5:	85 c0                	test   %eax,%eax
  8027f7:	78 6e                	js     802867 <pipe+0x181>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8027f9:	be 00 10 00 00       	mov    $0x1000,%esi
  8027fe:	4c 89 ef             	mov    %r13,%rdi
  802801:	48 b8 13 14 80 00 00 	movabs $0x801413,%rax
  802808:	00 00 00 
  80280b:	ff d0                	call   *%rax
  80280d:	83 f8 02             	cmp    $0x2,%eax
  802810:	0f 85 ab 00 00 00    	jne    8028c1 <pipe+0x1db>
    fd0->fd_dev_id = devpipe.dev_id;
  802816:	a1 60 50 80 00 00 00 	movabs 0x805060,%eax
  80281d:	00 00 
  80281f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802823:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  802825:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802829:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  802830:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802834:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  802836:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80283a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  802841:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802845:	48 bb 99 19 80 00 00 	movabs $0x801999,%rbx
  80284c:	00 00 00 
  80284f:	ff d3                	call   *%rbx
  802851:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  802855:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802859:	ff d3                	call   *%rbx
  80285b:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  802860:	bb 00 00 00 00       	mov    $0x0,%ebx
  802865:	eb 4d                	jmp    8028b4 <pipe+0x1ce>
    sys_unmap_region(0, va, PAGE_SIZE);
  802867:	ba 00 10 00 00       	mov    $0x1000,%edx
  80286c:	4c 89 ee             	mov    %r13,%rsi
  80286f:	bf 00 00 00 00       	mov    $0x0,%edi
  802874:	48 b8 b9 15 80 00 00 	movabs $0x8015b9,%rax
  80287b:	00 00 00 
  80287e:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  802880:	ba 00 10 00 00       	mov    $0x1000,%edx
  802885:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802889:	bf 00 00 00 00       	mov    $0x0,%edi
  80288e:	48 b8 b9 15 80 00 00 	movabs $0x8015b9,%rax
  802895:	00 00 00 
  802898:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  80289a:	ba 00 10 00 00       	mov    $0x1000,%edx
  80289f:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8028a3:	bf 00 00 00 00       	mov    $0x0,%edi
  8028a8:	48 b8 b9 15 80 00 00 	movabs $0x8015b9,%rax
  8028af:	00 00 00 
  8028b2:	ff d0                	call   *%rax
}
  8028b4:	89 d8                	mov    %ebx,%eax
  8028b6:	48 83 c4 18          	add    $0x18,%rsp
  8028ba:	5b                   	pop    %rbx
  8028bb:	41 5c                	pop    %r12
  8028bd:	41 5d                	pop    %r13
  8028bf:	5d                   	pop    %rbp
  8028c0:	c3                   	ret
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8028c1:	48 b9 c8 44 80 00 00 	movabs $0x8044c8,%rcx
  8028c8:	00 00 00 
  8028cb:	48 ba 91 42 80 00 00 	movabs $0x804291,%rdx
  8028d2:	00 00 00 
  8028d5:	be 2e 00 00 00       	mov    $0x2e,%esi
  8028da:	48 bf b8 42 80 00 00 	movabs $0x8042b8,%rdi
  8028e1:	00 00 00 
  8028e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8028e9:	49 b8 cf 03 80 00 00 	movabs $0x8003cf,%r8
  8028f0:	00 00 00 
  8028f3:	41 ff d0             	call   *%r8

00000000008028f6 <pipeisclosed>:
pipeisclosed(int fdnum) {
  8028f6:	f3 0f 1e fa          	endbr64
  8028fa:	55                   	push   %rbp
  8028fb:	48 89 e5             	mov    %rsp,%rbp
  8028fe:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802902:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802906:	48 b8 33 1a 80 00 00 	movabs $0x801a33,%rax
  80290d:	00 00 00 
  802910:	ff d0                	call   *%rax
    if (res < 0) return res;
  802912:	85 c0                	test   %eax,%eax
  802914:	78 35                	js     80294b <pipeisclosed+0x55>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  802916:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80291a:	48 b8 af 19 80 00 00 	movabs $0x8019af,%rax
  802921:	00 00 00 
  802924:	ff d0                	call   *%rax
  802926:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802929:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80292e:	be 00 10 00 00       	mov    $0x1000,%esi
  802933:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802937:	48 b8 49 14 80 00 00 	movabs $0x801449,%rax
  80293e:	00 00 00 
  802941:	ff d0                	call   *%rax
  802943:	85 c0                	test   %eax,%eax
  802945:	0f 94 c0             	sete   %al
  802948:	0f b6 c0             	movzbl %al,%eax
}
  80294b:	c9                   	leave
  80294c:	c3                   	ret

000000000080294d <wait>:
#include <inc/lib.h>

/* Waits until 'envid' exits. */
void
wait(envid_t envid) {
  80294d:	f3 0f 1e fa          	endbr64
  802951:	55                   	push   %rbp
  802952:	48 89 e5             	mov    %rsp,%rbp
  802955:	41 55                	push   %r13
  802957:	41 54                	push   %r12
  802959:	53                   	push   %rbx
  80295a:	48 83 ec 08          	sub    $0x8,%rsp
    assert(envid != 0);
  80295e:	85 ff                	test   %edi,%edi
  802960:	74 7d                	je     8029df <wait+0x92>
  802962:	41 89 fc             	mov    %edi,%r12d

    const volatile struct Env *env = &envs[ENVX(envid)];
  802965:	89 f8                	mov    %edi,%eax
  802967:	25 ff 03 00 00       	and    $0x3ff,%eax

    while (env->env_id == envid &&
  80296c:	89 fa                	mov    %edi,%edx
  80296e:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  802974:	48 8d 0c d2          	lea    (%rdx,%rdx,8),%rcx
  802978:	48 8d 0c 4a          	lea    (%rdx,%rcx,2),%rcx
  80297c:	48 c1 e1 04          	shl    $0x4,%rcx
  802980:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  802987:	00 00 00 
  80298a:	48 01 ca             	add    %rcx,%rdx
  80298d:	8b 92 c8 00 00 00    	mov    0xc8(%rdx),%edx
  802993:	39 d7                	cmp    %edx,%edi
  802995:	75 3d                	jne    8029d4 <wait+0x87>
           env->env_status != ENV_FREE) {
  802997:	48 98                	cltq
  802999:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  80299d:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8029a1:	48 c1 e0 04          	shl    $0x4,%rax
  8029a5:	48 bb 00 00 a0 1f 80 	movabs $0x801fa00000,%rbx
  8029ac:	00 00 00 
  8029af:	48 01 c3             	add    %rax,%rbx
        sys_yield();
  8029b2:	49 bd de 13 80 00 00 	movabs $0x8013de,%r13
  8029b9:	00 00 00 
           env->env_status != ENV_FREE) {
  8029bc:	8b 83 d4 00 00 00    	mov    0xd4(%rbx),%eax
    while (env->env_id == envid &&
  8029c2:	85 c0                	test   %eax,%eax
  8029c4:	74 0e                	je     8029d4 <wait+0x87>
        sys_yield();
  8029c6:	41 ff d5             	call   *%r13
    while (env->env_id == envid &&
  8029c9:	8b 83 c8 00 00 00    	mov    0xc8(%rbx),%eax
  8029cf:	44 39 e0             	cmp    %r12d,%eax
  8029d2:	74 e8                	je     8029bc <wait+0x6f>
    }
}
  8029d4:	48 83 c4 08          	add    $0x8,%rsp
  8029d8:	5b                   	pop    %rbx
  8029d9:	41 5c                	pop    %r12
  8029db:	41 5d                	pop    %r13
  8029dd:	5d                   	pop    %rbp
  8029de:	c3                   	ret
    assert(envid != 0);
  8029df:	48 b9 c8 42 80 00 00 	movabs $0x8042c8,%rcx
  8029e6:	00 00 00 
  8029e9:	48 ba 91 42 80 00 00 	movabs $0x804291,%rdx
  8029f0:	00 00 00 
  8029f3:	be 06 00 00 00       	mov    $0x6,%esi
  8029f8:	48 bf d3 42 80 00 00 	movabs $0x8042d3,%rdi
  8029ff:	00 00 00 
  802a02:	b8 00 00 00 00       	mov    $0x0,%eax
  802a07:	49 b8 cf 03 80 00 00 	movabs $0x8003cf,%r8
  802a0e:	00 00 00 
  802a11:	41 ff d0             	call   *%r8

0000000000802a14 <get_uvpt_entry>:
extern volatile pde_t uvpd[];     /* VA of current page directory */
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
  802a14:	f3 0f 1e fa          	endbr64
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802a18:	48 89 f8             	mov    %rdi,%rax
  802a1b:	48 c1 e8 27          	shr    $0x27,%rax
  802a1f:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  802a26:	7f 00 00 
  802a29:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802a2d:	f6 c2 01             	test   $0x1,%dl
  802a30:	74 6d                	je     802a9f <get_uvpt_entry+0x8b>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  802a32:	48 89 f8             	mov    %rdi,%rax
  802a35:	48 c1 e8 1e          	shr    $0x1e,%rax
  802a39:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  802a40:	7f 00 00 
  802a43:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802a47:	f6 c2 01             	test   $0x1,%dl
  802a4a:	74 62                	je     802aae <get_uvpt_entry+0x9a>
  802a4c:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  802a53:	7f 00 00 
  802a56:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802a5a:	f6 c2 80             	test   $0x80,%dl
  802a5d:	75 4f                	jne    802aae <get_uvpt_entry+0x9a>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802a5f:	48 89 f8             	mov    %rdi,%rax
  802a62:	48 c1 e8 15          	shr    $0x15,%rax
  802a66:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802a6d:	7f 00 00 
  802a70:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802a74:	f6 c2 01             	test   $0x1,%dl
  802a77:	74 44                	je     802abd <get_uvpt_entry+0xa9>
  802a79:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802a80:	7f 00 00 
  802a83:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802a87:	f6 c2 80             	test   $0x80,%dl
  802a8a:	75 31                	jne    802abd <get_uvpt_entry+0xa9>
    return uvpt[VPT(va)];
  802a8c:	48 c1 ef 0c          	shr    $0xc,%rdi
  802a90:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802a97:	7f 00 00 
  802a9a:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  802a9e:	c3                   	ret
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802a9f:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  802aa6:	7f 00 00 
  802aa9:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802aad:	c3                   	ret
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  802aae:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  802ab5:	7f 00 00 
  802ab8:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802abc:	c3                   	ret
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802abd:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802ac4:	7f 00 00 
  802ac7:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802acb:	c3                   	ret

0000000000802acc <get_phys_addr>:

uintptr_t
get_phys_addr(void *va) {
  802acc:	f3 0f 1e fa          	endbr64
  802ad0:	48 89 fa             	mov    %rdi,%rdx
    if (!(uvpml4[VPML4(va)] & PTE_P))
  802ad3:	48 89 f9             	mov    %rdi,%rcx
  802ad6:	48 c1 e9 27          	shr    $0x27,%rcx
  802ada:	48 b8 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rax
  802ae1:	7f 00 00 
  802ae4:	48 8b 0c c8          	mov    (%rax,%rcx,8),%rcx
        return -1;
  802ae8:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpml4[VPML4(va)] & PTE_P))
  802aef:	f6 c1 01             	test   $0x1,%cl
  802af2:	0f 84 b2 00 00 00    	je     802baa <get_phys_addr+0xde>
    if (!(uvpdp[VPDP(va)] & PTE_P))
  802af8:	48 89 f9             	mov    %rdi,%rcx
  802afb:	48 c1 e9 1e          	shr    $0x1e,%rcx
  802aff:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802b06:	7f 00 00 
  802b09:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  802b0d:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpdp[VPDP(va)] & PTE_P))
  802b14:	40 f6 c6 01          	test   $0x1,%sil
  802b18:	0f 84 8c 00 00 00    	je     802baa <get_phys_addr+0xde>
    if (uvpdp[VPDP(va)] & PTE_PS)
  802b1e:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802b25:	7f 00 00 
  802b28:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802b2c:	a8 80                	test   $0x80,%al
  802b2e:	75 7b                	jne    802bab <get_phys_addr+0xdf>
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
    if (!(uvpd[VPD(va)] & PTE_P))
  802b30:	48 89 f9             	mov    %rdi,%rcx
  802b33:	48 c1 e9 15          	shr    $0x15,%rcx
  802b37:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  802b3e:	7f 00 00 
  802b41:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  802b45:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpd[VPD(va)] & PTE_P))
  802b4c:	40 f6 c6 01          	test   $0x1,%sil
  802b50:	74 58                	je     802baa <get_phys_addr+0xde>
    if ((uvpd[VPD(va)] & PTE_PS))
  802b52:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  802b59:	7f 00 00 
  802b5c:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802b60:	a8 80                	test   $0x80,%al
  802b62:	75 6c                	jne    802bd0 <get_phys_addr+0x104>
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
    if (!(uvpt[VPT(va)] & PTE_P))
  802b64:	48 89 f9             	mov    %rdi,%rcx
  802b67:	48 c1 e9 0c          	shr    $0xc,%rcx
  802b6b:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802b72:	7f 00 00 
  802b75:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  802b79:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpt[VPT(va)] & PTE_P))
  802b80:	40 f6 c6 01          	test   $0x1,%sil
  802b84:	74 24                	je     802baa <get_phys_addr+0xde>
    return PTE_ADDR(uvpt[VPT(va)]) + PAGE_OFFSET(va);
  802b86:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802b8d:	7f 00 00 
  802b90:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802b94:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802b9b:	ff ff 7f 
  802b9e:	48 21 c8             	and    %rcx,%rax
  802ba1:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  802ba7:	48 09 d0             	or     %rdx,%rax
}
  802baa:	c3                   	ret
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
  802bab:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802bb2:	7f 00 00 
  802bb5:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802bb9:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802bc0:	ff ff 7f 
  802bc3:	48 21 c8             	and    %rcx,%rax
  802bc6:	81 e2 ff ff ff 3f    	and    $0x3fffffff,%edx
  802bcc:	48 01 d0             	add    %rdx,%rax
  802bcf:	c3                   	ret
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
  802bd0:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  802bd7:	7f 00 00 
  802bda:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802bde:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802be5:	ff ff 7f 
  802be8:	48 21 c8             	and    %rcx,%rax
  802beb:	81 e2 ff ff 1f 00    	and    $0x1fffff,%edx
  802bf1:	48 01 d0             	add    %rdx,%rax
  802bf4:	c3                   	ret

0000000000802bf5 <get_prot>:

int
get_prot(void *va) {
  802bf5:	f3 0f 1e fa          	endbr64
  802bf9:	55                   	push   %rbp
  802bfa:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802bfd:	48 b8 14 2a 80 00 00 	movabs $0x802a14,%rax
  802c04:	00 00 00 
  802c07:	ff d0                	call   *%rax
  802c09:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
    if (pte & PTE_P) prot |= PROT_R;
  802c0c:	83 e0 01             	and    $0x1,%eax
  802c0f:	c1 e0 02             	shl    $0x2,%eax
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  802c12:	89 d1                	mov    %edx,%ecx
  802c14:	81 e1 00 0a 00 00    	and    $0xa00,%ecx
    if (pte & PTE_P) prot |= PROT_R;
  802c1a:	09 c8                	or     %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  802c1c:	89 c1                	mov    %eax,%ecx
  802c1e:	83 c9 02             	or     $0x2,%ecx
  802c21:	f6 c2 02             	test   $0x2,%dl
  802c24:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  802c27:	89 c1                	mov    %eax,%ecx
  802c29:	83 c9 01             	or     $0x1,%ecx
  802c2c:	48 85 d2             	test   %rdx,%rdx
  802c2f:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  802c32:	89 c1                	mov    %eax,%ecx
  802c34:	83 c9 40             	or     $0x40,%ecx
  802c37:	f6 c6 04             	test   $0x4,%dh
  802c3a:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  802c3d:	5d                   	pop    %rbp
  802c3e:	c3                   	ret

0000000000802c3f <is_page_dirty>:

bool
is_page_dirty(void *va) {
  802c3f:	f3 0f 1e fa          	endbr64
  802c43:	55                   	push   %rbp
  802c44:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802c47:	48 b8 14 2a 80 00 00 	movabs $0x802a14,%rax
  802c4e:	00 00 00 
  802c51:	ff d0                	call   *%rax
    return pte & PTE_D;
  802c53:	48 c1 e8 06          	shr    $0x6,%rax
  802c57:	83 e0 01             	and    $0x1,%eax
}
  802c5a:	5d                   	pop    %rbp
  802c5b:	c3                   	ret

0000000000802c5c <is_page_present>:

bool
is_page_present(void *va) {
  802c5c:	f3 0f 1e fa          	endbr64
  802c60:	55                   	push   %rbp
  802c61:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  802c64:	48 b8 14 2a 80 00 00 	movabs $0x802a14,%rax
  802c6b:	00 00 00 
  802c6e:	ff d0                	call   *%rax
  802c70:	83 e0 01             	and    $0x1,%eax
}
  802c73:	5d                   	pop    %rbp
  802c74:	c3                   	ret

0000000000802c75 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  802c75:	f3 0f 1e fa          	endbr64
  802c79:	55                   	push   %rbp
  802c7a:	48 89 e5             	mov    %rsp,%rbp
  802c7d:	41 57                	push   %r15
  802c7f:	41 56                	push   %r14
  802c81:	41 55                	push   %r13
  802c83:	41 54                	push   %r12
  802c85:	53                   	push   %rbx
  802c86:	48 83 ec 18          	sub    $0x18,%rsp
  802c8a:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  802c8e:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
     * NOTE: Skip over larger pages/page directories for efficiency */
    // LAB 11: Your code here:

    int res = 0;
    (void)fun, (void)arg;
    uintptr_t va = 0;
  802c92:	bb 00 00 00 00       	mov    $0x0,%ebx
    while (va < USER_STACK_TOP) {
        size_t size = 0;
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  802c97:	49 be 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%r14
  802c9e:	7f 00 00 
            size = 1LL << PML4_SHIFT;
            goto next;
        }

        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802ca1:	49 bd 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%r13
  802ca8:	7f 00 00 
    while (va < USER_STACK_TOP) {
  802cab:	49 bf ff 6f ff ff 7f 	movabs $0x7fffff6fff,%r15
  802cb2:	00 00 00 
  802cb5:	eb 73                	jmp    802d2a <foreach_shared_region+0xb5>
            }

            goto next;
        }

        if (!(uvpd[VPD(va)] & PTE_P)) {
  802cb7:	48 89 d8             	mov    %rbx,%rax
  802cba:	48 c1 e8 15          	shr    $0x15,%rax
  802cbe:	48 b9 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rcx
  802cc5:	7f 00 00 
  802cc8:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
            size = 1LL << PD_SHIFT;
  802ccc:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
        if (!(uvpd[VPD(va)] & PTE_P)) {
  802cd2:	f6 c2 01             	test   $0x1,%dl
  802cd5:	74 4b                	je     802d22 <foreach_shared_region+0xad>
            goto next;
        }

        if (uvpd[VPD(va)] & PTE_PS) {
  802cd7:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
  802cdb:	f6 c2 80             	test   $0x80,%dl
  802cde:	74 11                	je     802cf1 <foreach_shared_region+0x7c>
            size = 1LL << PD_SHIFT;
            if (uvpd[VPD(va)] & PTE_SHARE) {
  802ce0:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
  802ce4:	f6 c4 04             	test   $0x4,%ah
  802ce7:	74 39                	je     802d22 <foreach_shared_region+0xad>
            size = 1LL << PD_SHIFT;
  802ce9:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
  802cef:	eb 20                	jmp    802d11 <foreach_shared_region+0x9c>

            goto next;
        }

        size = PAGE_SIZE;
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  802cf1:	48 89 da             	mov    %rbx,%rdx
  802cf4:	48 c1 ea 0c          	shr    $0xc,%rdx
  802cf8:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802cff:	7f 00 00 
  802d02:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
        size = PAGE_SIZE;
  802d06:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  802d0c:	f6 c4 04             	test   $0x4,%ah
  802d0f:	74 11                	je     802d22 <foreach_shared_region+0xad>
            goto next;
        }

    map:
        fun((void *)va, (void *)(va + size), arg);
  802d11:	49 8d 34 1c          	lea    (%r12,%rbx,1),%rsi
  802d15:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802d19:	48 89 df             	mov    %rbx,%rdi
  802d1c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802d20:	ff d0                	call   *%rax
    next:
        va += size;
  802d22:	4c 01 e3             	add    %r12,%rbx
    while (va < USER_STACK_TOP) {
  802d25:	49 39 df             	cmp    %rbx,%r15
  802d28:	72 3e                	jb     802d68 <foreach_shared_region+0xf3>
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  802d2a:	49 8b 06             	mov    (%r14),%rax
  802d2d:	a8 01                	test   $0x1,%al
  802d2f:	74 37                	je     802d68 <foreach_shared_region+0xf3>
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802d31:	48 89 d8             	mov    %rbx,%rax
  802d34:	48 c1 e8 1e          	shr    $0x1e,%rax
  802d38:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
            size = 1LL << PDP_SHIFT;
  802d3d:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802d43:	f6 c2 01             	test   $0x1,%dl
  802d46:	74 da                	je     802d22 <foreach_shared_region+0xad>
        if (uvpdp[VPDP(va)] & PTE_PS) {
  802d48:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
  802d4d:	f6 c2 80             	test   $0x80,%dl
  802d50:	0f 84 61 ff ff ff    	je     802cb7 <foreach_shared_region+0x42>
            if (uvpdp[VPDP(va)] & PTE_SHARE) {
  802d56:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  802d5b:	f6 c4 04             	test   $0x4,%ah
  802d5e:	74 c2                	je     802d22 <foreach_shared_region+0xad>
            size = 1LL << PDP_SHIFT;
  802d60:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
  802d66:	eb a9                	jmp    802d11 <foreach_shared_region+0x9c>
    }
    return res;
}
  802d68:	b8 00 00 00 00       	mov    $0x0,%eax
  802d6d:	48 83 c4 18          	add    $0x18,%rsp
  802d71:	5b                   	pop    %rbx
  802d72:	41 5c                	pop    %r12
  802d74:	41 5d                	pop    %r13
  802d76:	41 5e                	pop    %r14
  802d78:	41 5f                	pop    %r15
  802d7a:	5d                   	pop    %rbp
  802d7b:	c3                   	ret

0000000000802d7c <devcons_close>:

    return res;
}

static int
devcons_close(struct Fd *fd) {
  802d7c:	f3 0f 1e fa          	endbr64
    USED(fd);

    return 0;
}
  802d80:	b8 00 00 00 00       	mov    $0x0,%eax
  802d85:	c3                   	ret

0000000000802d86 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  802d86:	f3 0f 1e fa          	endbr64
  802d8a:	55                   	push   %rbp
  802d8b:	48 89 e5             	mov    %rsp,%rbp
  802d8e:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  802d91:	48 be de 42 80 00 00 	movabs $0x8042de,%rsi
  802d98:	00 00 00 
  802d9b:	48 b8 74 0e 80 00 00 	movabs $0x800e74,%rax
  802da2:	00 00 00 
  802da5:	ff d0                	call   *%rax
    return 0;
}
  802da7:	b8 00 00 00 00       	mov    $0x0,%eax
  802dac:	5d                   	pop    %rbp
  802dad:	c3                   	ret

0000000000802dae <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  802dae:	f3 0f 1e fa          	endbr64
  802db2:	55                   	push   %rbp
  802db3:	48 89 e5             	mov    %rsp,%rbp
  802db6:	41 57                	push   %r15
  802db8:	41 56                	push   %r14
  802dba:	41 55                	push   %r13
  802dbc:	41 54                	push   %r12
  802dbe:	53                   	push   %rbx
  802dbf:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  802dc6:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  802dcd:	48 85 d2             	test   %rdx,%rdx
  802dd0:	74 7a                	je     802e4c <devcons_write+0x9e>
  802dd2:	49 89 d6             	mov    %rdx,%r14
  802dd5:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802ddb:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  802de0:	49 bf 8f 10 80 00 00 	movabs $0x80108f,%r15
  802de7:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  802dea:	4c 89 f3             	mov    %r14,%rbx
  802ded:	48 29 f3             	sub    %rsi,%rbx
  802df0:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802df5:	48 39 c3             	cmp    %rax,%rbx
  802df8:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  802dfc:	4c 63 eb             	movslq %ebx,%r13
  802dff:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  802e06:	48 01 c6             	add    %rax,%rsi
  802e09:	4c 89 ea             	mov    %r13,%rdx
  802e0c:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802e13:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  802e16:	4c 89 ee             	mov    %r13,%rsi
  802e19:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802e20:	48 b8 d4 12 80 00 00 	movabs $0x8012d4,%rax
  802e27:	00 00 00 
  802e2a:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  802e2c:	41 01 dc             	add    %ebx,%r12d
  802e2f:	49 63 f4             	movslq %r12d,%rsi
  802e32:	4c 39 f6             	cmp    %r14,%rsi
  802e35:	72 b3                	jb     802dea <devcons_write+0x3c>
    return res;
  802e37:	49 63 c4             	movslq %r12d,%rax
}
  802e3a:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  802e41:	5b                   	pop    %rbx
  802e42:	41 5c                	pop    %r12
  802e44:	41 5d                	pop    %r13
  802e46:	41 5e                	pop    %r14
  802e48:	41 5f                	pop    %r15
  802e4a:	5d                   	pop    %rbp
  802e4b:	c3                   	ret
    for (res = 0; res < n; res += inc) {
  802e4c:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802e52:	eb e3                	jmp    802e37 <devcons_write+0x89>

0000000000802e54 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802e54:	f3 0f 1e fa          	endbr64
  802e58:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  802e5b:	ba 00 00 00 00       	mov    $0x0,%edx
  802e60:	48 85 c0             	test   %rax,%rax
  802e63:	74 55                	je     802eba <devcons_read+0x66>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802e65:	55                   	push   %rbp
  802e66:	48 89 e5             	mov    %rsp,%rbp
  802e69:	41 55                	push   %r13
  802e6b:	41 54                	push   %r12
  802e6d:	53                   	push   %rbx
  802e6e:	48 83 ec 08          	sub    $0x8,%rsp
  802e72:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  802e75:	48 bb 05 13 80 00 00 	movabs $0x801305,%rbx
  802e7c:	00 00 00 
  802e7f:	49 bc de 13 80 00 00 	movabs $0x8013de,%r12
  802e86:	00 00 00 
  802e89:	eb 03                	jmp    802e8e <devcons_read+0x3a>
  802e8b:	41 ff d4             	call   *%r12
  802e8e:	ff d3                	call   *%rbx
  802e90:	85 c0                	test   %eax,%eax
  802e92:	74 f7                	je     802e8b <devcons_read+0x37>
    if (c < 0) return c;
  802e94:	48 63 d0             	movslq %eax,%rdx
  802e97:	78 13                	js     802eac <devcons_read+0x58>
    if (c == 0x04) return 0;
  802e99:	ba 00 00 00 00       	mov    $0x0,%edx
  802e9e:	83 f8 04             	cmp    $0x4,%eax
  802ea1:	74 09                	je     802eac <devcons_read+0x58>
    *(char *)vbuf = (char)c;
  802ea3:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  802ea7:	ba 01 00 00 00       	mov    $0x1,%edx
}
  802eac:	48 89 d0             	mov    %rdx,%rax
  802eaf:	48 83 c4 08          	add    $0x8,%rsp
  802eb3:	5b                   	pop    %rbx
  802eb4:	41 5c                	pop    %r12
  802eb6:	41 5d                	pop    %r13
  802eb8:	5d                   	pop    %rbp
  802eb9:	c3                   	ret
  802eba:	48 89 d0             	mov    %rdx,%rax
  802ebd:	c3                   	ret

0000000000802ebe <cputchar>:
cputchar(int ch) {
  802ebe:	f3 0f 1e fa          	endbr64
  802ec2:	55                   	push   %rbp
  802ec3:	48 89 e5             	mov    %rsp,%rbp
  802ec6:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  802eca:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  802ece:	be 01 00 00 00       	mov    $0x1,%esi
  802ed3:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  802ed7:	48 b8 d4 12 80 00 00 	movabs $0x8012d4,%rax
  802ede:	00 00 00 
  802ee1:	ff d0                	call   *%rax
}
  802ee3:	c9                   	leave
  802ee4:	c3                   	ret

0000000000802ee5 <getchar>:
getchar(void) {
  802ee5:	f3 0f 1e fa          	endbr64
  802ee9:	55                   	push   %rbp
  802eea:	48 89 e5             	mov    %rsp,%rbp
  802eed:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  802ef1:	ba 01 00 00 00       	mov    $0x1,%edx
  802ef6:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  802efa:	bf 00 00 00 00       	mov    $0x0,%edi
  802eff:	48 b8 2e 1d 80 00 00 	movabs $0x801d2e,%rax
  802f06:	00 00 00 
  802f09:	ff d0                	call   *%rax
  802f0b:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  802f0d:	85 c0                	test   %eax,%eax
  802f0f:	78 06                	js     802f17 <getchar+0x32>
  802f11:	74 08                	je     802f1b <getchar+0x36>
  802f13:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  802f17:	89 d0                	mov    %edx,%eax
  802f19:	c9                   	leave
  802f1a:	c3                   	ret
    return res < 0 ? res : res ? c :
  802f1b:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  802f20:	eb f5                	jmp    802f17 <getchar+0x32>

0000000000802f22 <iscons>:
iscons(int fdnum) {
  802f22:	f3 0f 1e fa          	endbr64
  802f26:	55                   	push   %rbp
  802f27:	48 89 e5             	mov    %rsp,%rbp
  802f2a:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802f2e:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802f32:	48 b8 33 1a 80 00 00 	movabs $0x801a33,%rax
  802f39:	00 00 00 
  802f3c:	ff d0                	call   *%rax
    if (res < 0) return res;
  802f3e:	85 c0                	test   %eax,%eax
  802f40:	78 18                	js     802f5a <iscons+0x38>
    return fd->fd_dev_id == devcons.dev_id;
  802f42:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f46:	48 b8 a0 50 80 00 00 	movabs $0x8050a0,%rax
  802f4d:	00 00 00 
  802f50:	8b 00                	mov    (%rax),%eax
  802f52:	39 02                	cmp    %eax,(%rdx)
  802f54:	0f 94 c0             	sete   %al
  802f57:	0f b6 c0             	movzbl %al,%eax
}
  802f5a:	c9                   	leave
  802f5b:	c3                   	ret

0000000000802f5c <opencons>:
opencons(void) {
  802f5c:	f3 0f 1e fa          	endbr64
  802f60:	55                   	push   %rbp
  802f61:	48 89 e5             	mov    %rsp,%rbp
  802f64:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  802f68:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  802f6c:	48 b8 cf 19 80 00 00 	movabs $0x8019cf,%rax
  802f73:	00 00 00 
  802f76:	ff d0                	call   *%rax
  802f78:	85 c0                	test   %eax,%eax
  802f7a:	78 49                	js     802fc5 <opencons+0x69>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  802f7c:	b9 46 00 00 00       	mov    $0x46,%ecx
  802f81:	ba 00 10 00 00       	mov    $0x1000,%edx
  802f86:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  802f8a:	bf 00 00 00 00       	mov    $0x0,%edi
  802f8f:	48 b8 79 14 80 00 00 	movabs $0x801479,%rax
  802f96:	00 00 00 
  802f99:	ff d0                	call   *%rax
  802f9b:	85 c0                	test   %eax,%eax
  802f9d:	78 26                	js     802fc5 <opencons+0x69>
    fd->fd_dev_id = devcons.dev_id;
  802f9f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802fa3:	a1 a0 50 80 00 00 00 	movabs 0x8050a0,%eax
  802faa:	00 00 
  802fac:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  802fae:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802fb2:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  802fb9:	48 b8 99 19 80 00 00 	movabs $0x801999,%rax
  802fc0:	00 00 00 
  802fc3:	ff d0                	call   *%rax
}
  802fc5:	c9                   	leave
  802fc6:	c3                   	ret

0000000000802fc7 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
    # Call the C page fault handler.
    movq  %rsp,%rdi # passing the function argument in rdi
  802fc7:	48 89 e7             	mov    %rsp,%rdi
    movabs $_handle_vectored_pagefault, %rax
  802fca:	48 b8 06 32 80 00 00 	movabs $0x803206,%rax
  802fd1:	00 00 00 
    call *%rax
  802fd4:	ff d0                	call   *%rax
    # registers are available for intermediate calculations.  You
    # may find that you have to rearrange your code in non-obvious
    # ways as registers become unavailable as scratch space.

    # LAB 9: Your code here
    movq %rsp, %rax
  802fd6:	48 89 e0             	mov    %rsp,%rax
    movq UTRAP_RIP(%rsp), %rbx
  802fd9:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  802fe0:	00 
    movq UTRAP_RSP(%rsp), %rsp
  802fe1:	48 8b a4 24 98 00 00 	mov    0x98(%rsp),%rsp
  802fe8:	00 
    pushq %rbx
  802fe9:	53                   	push   %rbx
    movq %rsp, UTRAP_RSP(%rax)
  802fea:	48 89 a0 98 00 00 00 	mov    %rsp,0x98(%rax)

    # Restore the trap-time registers.  After you do this, you
    # can no longer modify any general-purpose registers (use POPA macro).
    # LAB 9: Your code here
    movq %rax, %rsp
  802ff1:	48 89 c4             	mov    %rax,%rsp
    addq $16, %rsp
  802ff4:	48 83 c4 10          	add    $0x10,%rsp
    POPA
  802ff8:	4c 8b 3c 24          	mov    (%rsp),%r15
  802ffc:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  803001:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  803006:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  80300b:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  803010:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  803015:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  80301a:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  80301f:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  803024:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  803029:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  80302e:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  803033:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  803038:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  80303d:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  803042:	48 83 c4 78          	add    $0x78,%rsp
    addq $8, %rsp
  803046:	48 83 c4 08          	add    $0x8,%rsp
    # Restore rflags from the stack.  After you do this, you can
    # no longer use arithmetic operations or anything else that
    # modifies rflags.
    # LAB 9: Your code here
	popfq
  80304a:	9d                   	popf
    # Switch back to the adjusted trap-time stack.
    # LAB 9: Your code here
	popq %rsp
  80304b:	5c                   	pop    %rsp
    # Return to re-execute the instruction that faulted.
    ret
  80304c:	c3                   	ret

000000000080304d <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  80304d:	f3 0f 1e fa          	endbr64
  803051:	55                   	push   %rbp
  803052:	48 89 e5             	mov    %rsp,%rbp
  803055:	41 54                	push   %r12
  803057:	53                   	push   %rbx
  803058:	48 89 fb             	mov    %rdi,%rbx
  80305b:	48 89 f7             	mov    %rsi,%rdi
  80305e:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  803061:	48 85 f6             	test   %rsi,%rsi
  803064:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  80306b:	00 00 00 
  80306e:	48 0f 44 f8          	cmove  %rax,%rdi
    }
    int res = sys_ipc_recv(pg, PAGE_SIZE);
  803072:	be 00 10 00 00       	mov    $0x1000,%esi
  803077:	48 b8 9b 17 80 00 00 	movabs $0x80179b,%rax
  80307e:	00 00 00 
  803081:	ff d0                	call   *%rax
    if (res < 0) {
  803083:	85 c0                	test   %eax,%eax
  803085:	78 45                	js     8030cc <ipc_recv+0x7f>
        if (perm_store != NULL) {
            *perm_store = 0;
        }
        return res;
    } else {
        if (from_env_store != NULL) {
  803087:	48 85 db             	test   %rbx,%rbx
  80308a:	74 12                	je     80309e <ipc_recv+0x51>
            *from_env_store = thisenv->env_ipc_from;
  80308c:	48 a1 00 64 80 00 00 	movabs 0x806400,%rax
  803093:	00 00 00 
  803096:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  80309c:	89 03                	mov    %eax,(%rbx)
        }
        if (perm_store != NULL) {
  80309e:	4d 85 e4             	test   %r12,%r12
  8030a1:	74 14                	je     8030b7 <ipc_recv+0x6a>
            *perm_store = thisenv->env_ipc_perm;
  8030a3:	48 a1 00 64 80 00 00 	movabs 0x806400,%rax
  8030aa:	00 00 00 
  8030ad:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  8030b3:	41 89 04 24          	mov    %eax,(%r12)
        }
        return thisenv->env_ipc_value;
  8030b7:	48 a1 00 64 80 00 00 	movabs 0x806400,%rax
  8030be:	00 00 00 
  8030c1:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
    }
    return -1;
}
  8030c7:	5b                   	pop    %rbx
  8030c8:	41 5c                	pop    %r12
  8030ca:	5d                   	pop    %rbp
  8030cb:	c3                   	ret
        if (from_env_store != NULL) {
  8030cc:	48 85 db             	test   %rbx,%rbx
  8030cf:	74 06                	je     8030d7 <ipc_recv+0x8a>
            *from_env_store = 0;
  8030d1:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store != NULL) {
  8030d7:	4d 85 e4             	test   %r12,%r12
  8030da:	74 eb                	je     8030c7 <ipc_recv+0x7a>
            *perm_store = 0;
  8030dc:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  8030e3:	00 
  8030e4:	eb e1                	jmp    8030c7 <ipc_recv+0x7a>

00000000008030e6 <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  8030e6:	f3 0f 1e fa          	endbr64
  8030ea:	55                   	push   %rbp
  8030eb:	48 89 e5             	mov    %rsp,%rbp
  8030ee:	41 57                	push   %r15
  8030f0:	41 56                	push   %r14
  8030f2:	41 55                	push   %r13
  8030f4:	41 54                	push   %r12
  8030f6:	53                   	push   %rbx
  8030f7:	48 83 ec 18          	sub    $0x18,%rsp
  8030fb:	89 7d c4             	mov    %edi,-0x3c(%rbp)
  8030fe:	48 89 d3             	mov    %rdx,%rbx
  803101:	49 89 cc             	mov    %rcx,%r12
  803104:	45 89 c5             	mov    %r8d,%r13d
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  803107:	48 85 d2             	test   %rdx,%rdx
  80310a:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  803111:	00 00 00 
  803114:	48 0f 44 d8          	cmove  %rax,%rbx
    }
    int res = sys_ipc_try_send(to_env, val, pg, size, perm);
  803118:	89 f0                	mov    %esi,%eax
  80311a:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  80311e:	48 89 da             	mov    %rbx,%rdx
  803121:	48 89 c6             	mov    %rax,%rsi
  803124:	48 b8 6b 17 80 00 00 	movabs $0x80176b,%rax
  80312b:	00 00 00 
  80312e:	ff d0                	call   *%rax
    while (res < 0) {
  803130:	85 c0                	test   %eax,%eax
  803132:	79 65                	jns    803199 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  803134:	83 f8 f5             	cmp    $0xfffffff5,%eax
  803137:	75 33                	jne    80316c <ipc_send+0x86>
            panic("Error: %i\n", res);
        }
        sys_yield();
  803139:	49 bf de 13 80 00 00 	movabs $0x8013de,%r15
  803140:	00 00 00 
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  803143:	49 be 6b 17 80 00 00 	movabs $0x80176b,%r14
  80314a:	00 00 00 
        sys_yield();
  80314d:	41 ff d7             	call   *%r15
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  803150:	45 89 e8             	mov    %r13d,%r8d
  803153:	4c 89 e1             	mov    %r12,%rcx
  803156:	48 89 da             	mov    %rbx,%rdx
  803159:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  80315d:	8b 7d c4             	mov    -0x3c(%rbp),%edi
  803160:	41 ff d6             	call   *%r14
    while (res < 0) {
  803163:	85 c0                	test   %eax,%eax
  803165:	79 32                	jns    803199 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  803167:	83 f8 f5             	cmp    $0xfffffff5,%eax
  80316a:	74 e1                	je     80314d <ipc_send+0x67>
            panic("Error: %i\n", res);
  80316c:	89 c1                	mov    %eax,%ecx
  80316e:	48 ba ea 42 80 00 00 	movabs $0x8042ea,%rdx
  803175:	00 00 00 
  803178:	be 42 00 00 00       	mov    $0x42,%esi
  80317d:	48 bf f5 42 80 00 00 	movabs $0x8042f5,%rdi
  803184:	00 00 00 
  803187:	b8 00 00 00 00       	mov    $0x0,%eax
  80318c:	49 b8 cf 03 80 00 00 	movabs $0x8003cf,%r8
  803193:	00 00 00 
  803196:	41 ff d0             	call   *%r8
    }
}
  803199:	48 83 c4 18          	add    $0x18,%rsp
  80319d:	5b                   	pop    %rbx
  80319e:	41 5c                	pop    %r12
  8031a0:	41 5d                	pop    %r13
  8031a2:	41 5e                	pop    %r14
  8031a4:	41 5f                	pop    %r15
  8031a6:	5d                   	pop    %rbp
  8031a7:	c3                   	ret

00000000008031a8 <ipc_find_env>:

/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
  8031a8:	f3 0f 1e fa          	endbr64
    for (size_t i = 0; i < NENV; i++)
  8031ac:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  8031b1:	48 b9 00 00 a0 1f 80 	movabs $0x801fa00000,%rcx
  8031b8:	00 00 00 
  8031bb:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8031bf:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  8031c3:	48 c1 e2 04          	shl    $0x4,%rdx
  8031c7:	48 01 ca             	add    %rcx,%rdx
  8031ca:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  8031d0:	39 fa                	cmp    %edi,%edx
  8031d2:	74 12                	je     8031e6 <ipc_find_env+0x3e>
    for (size_t i = 0; i < NENV; i++)
  8031d4:	48 83 c0 01          	add    $0x1,%rax
  8031d8:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  8031de:	75 db                	jne    8031bb <ipc_find_env+0x13>
            return envs[i].env_id;
    return 0;
  8031e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031e5:	c3                   	ret
            return envs[i].env_id;
  8031e6:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8031ea:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  8031ee:	48 c1 e2 04          	shl    $0x4,%rdx
  8031f2:	48 b8 00 00 a0 1f 80 	movabs $0x801fa00000,%rax
  8031f9:	00 00 00 
  8031fc:	48 01 d0             	add    %rdx,%rax
  8031ff:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803205:	c3                   	ret

0000000000803206 <_handle_vectored_pagefault>:
/* Vector size */
static size_t _pfhandler_off = 0;
static bool _pfhandler_inititiallized = 0;

void
_handle_vectored_pagefault(struct UTrapframe *utf) {
  803206:	f3 0f 1e fa          	endbr64
  80320a:	55                   	push   %rbp
  80320b:	48 89 e5             	mov    %rsp,%rbp
  80320e:	41 56                	push   %r14
  803210:	41 55                	push   %r13
  803212:	41 54                	push   %r12
  803214:	53                   	push   %rbx
  803215:	49 89 fc             	mov    %rdi,%r12
    /* This trying to handle pagefault until
     * some handler returns 1, that indicates
     * successfully handled exception */
    for (size_t i = 0; i < _pfhandler_off; i++)
  803218:	48 b8 68 80 80 00 00 	movabs $0x808068,%rax
  80321f:	00 00 00 
  803222:	48 83 38 00          	cmpq   $0x0,(%rax)
  803226:	74 27                	je     80324f <_handle_vectored_pagefault+0x49>
  803228:	bb 00 00 00 00       	mov    $0x0,%ebx
        if (_pfhandler_vec[i](utf)) return;
  80322d:	49 bd 20 80 80 00 00 	movabs $0x808020,%r13
  803234:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++)
  803237:	49 89 c6             	mov    %rax,%r14
        if (_pfhandler_vec[i](utf)) return;
  80323a:	4c 89 e7             	mov    %r12,%rdi
  80323d:	41 ff 54 dd 00       	call   *0x0(%r13,%rbx,8)
  803242:	84 c0                	test   %al,%al
  803244:	75 45                	jne    80328b <_handle_vectored_pagefault+0x85>
    for (size_t i = 0; i < _pfhandler_off; i++)
  803246:	48 83 c3 01          	add    $0x1,%rbx
  80324a:	49 3b 1e             	cmp    (%r14),%rbx
  80324d:	72 eb                	jb     80323a <_handle_vectored_pagefault+0x34>

    /* Unhandled exceptions just cause panic */
    panic("Userspace page fault rip=%08lX va=%08lX err=%x\n",
  80324f:	49 8b 8c 24 88 00 00 	mov    0x88(%r12),%rcx
  803256:	00 
  803257:	45 8b 4c 24 08       	mov    0x8(%r12),%r9d
  80325c:	4d 8b 04 24          	mov    (%r12),%r8
  803260:	48 ba f0 44 80 00 00 	movabs $0x8044f0,%rdx
  803267:	00 00 00 
  80326a:	be 1d 00 00 00       	mov    $0x1d,%esi
  80326f:	48 bf ff 42 80 00 00 	movabs $0x8042ff,%rdi
  803276:	00 00 00 
  803279:	b8 00 00 00 00       	mov    $0x0,%eax
  80327e:	49 ba cf 03 80 00 00 	movabs $0x8003cf,%r10
  803285:	00 00 00 
  803288:	41 ff d2             	call   *%r10
          utf->utf_rip, utf->utf_fault_va, (int)utf->utf_err);
}
  80328b:	5b                   	pop    %rbx
  80328c:	41 5c                	pop    %r12
  80328e:	41 5d                	pop    %r13
  803290:	41 5e                	pop    %r14
  803292:	5d                   	pop    %rbp
  803293:	c3                   	ret

0000000000803294 <add_pgfault_handler>:
 * The first time we register a handler, we need to
 * allocate an exception stack (one page of memory with its top
 * at USER_EXCEPTION_STACK_TOP), and tell the kernel to call the assembly-language
 * _pgfault_upcall routine when a page fault occurs. */
int
add_pgfault_handler(pf_handler_t handler) {
  803294:	f3 0f 1e fa          	endbr64
  803298:	55                   	push   %rbp
  803299:	48 89 e5             	mov    %rsp,%rbp
  80329c:	53                   	push   %rbx
  80329d:	48 83 ec 08          	sub    $0x8,%rsp
  8032a1:	48 89 fb             	mov    %rdi,%rbx
    int res = 0;
    if (!_pfhandler_inititiallized) {
  8032a4:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  8032ab:	00 00 00 
  8032ae:	80 38 00             	cmpb   $0x0,(%rax)
  8032b1:	0f 84 84 00 00 00    	je     80333b <add_pgfault_handler+0xa7>
        _pfhandler_vec[_pfhandler_off++] = handler;
        _pfhandler_inititiallized = 1;
        goto end;
    }

    for (size_t i = 0; i < _pfhandler_off; i++)
  8032b7:	48 b8 68 80 80 00 00 	movabs $0x808068,%rax
  8032be:	00 00 00 
  8032c1:	48 8b 10             	mov    (%rax),%rdx
  8032c4:	b8 00 00 00 00       	mov    $0x0,%eax
        if (handler == _pfhandler_vec[i]) return 0;
  8032c9:	48 b9 20 80 80 00 00 	movabs $0x808020,%rcx
  8032d0:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++)
  8032d3:	48 85 d2             	test   %rdx,%rdx
  8032d6:	74 19                	je     8032f1 <add_pgfault_handler+0x5d>
        if (handler == _pfhandler_vec[i]) return 0;
  8032d8:	48 39 1c c1          	cmp    %rbx,(%rcx,%rax,8)
  8032dc:	0f 84 e8 00 00 00    	je     8033ca <add_pgfault_handler+0x136>
    for (size_t i = 0; i < _pfhandler_off; i++)
  8032e2:	48 83 c0 01          	add    $0x1,%rax
  8032e6:	48 39 d0             	cmp    %rdx,%rax
  8032e9:	75 ed                	jne    8032d8 <add_pgfault_handler+0x44>

    if (_pfhandler_off == MAX_PFHANDLER)
  8032eb:	48 83 fa 08          	cmp    $0x8,%rdx
  8032ef:	74 1c                	je     80330d <add_pgfault_handler+0x79>
        res = -E_INVAL;
    else
        _pfhandler_vec[_pfhandler_off++] = handler;
  8032f1:	48 8d 42 01          	lea    0x1(%rdx),%rax
  8032f5:	48 a3 68 80 80 00 00 	movabs %rax,0x808068
  8032fc:	00 00 00 
  8032ff:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  803306:	00 00 00 
  803309:	48 89 1c d0          	mov    %rbx,(%rax,%rdx,8)

end:
    res = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  80330d:	48 b8 a9 13 80 00 00 	movabs $0x8013a9,%rax
  803314:	00 00 00 
  803317:	ff d0                	call   *%rax
  803319:	89 c7                	mov    %eax,%edi
  80331b:	48 be c7 2f 80 00 00 	movabs $0x802fc7,%rsi
  803322:	00 00 00 
  803325:	48 b8 fe 16 80 00 00 	movabs $0x8016fe,%rax
  80332c:	00 00 00 
  80332f:	ff d0                	call   *%rax
    if (res < 0) panic("set_pgfault_handler: %i", res);
  803331:	85 c0                	test   %eax,%eax
  803333:	78 68                	js     80339d <add_pgfault_handler+0x109>
    return res;
}
  803335:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  803339:	c9                   	leave
  80333a:	c3                   	ret
        res = sys_alloc_region(sys_getenvid(), (void*)(USER_EXCEPTION_STACK_TOP - PAGE_SIZE), PAGE_SIZE, PROT_RW);
  80333b:	48 b8 a9 13 80 00 00 	movabs $0x8013a9,%rax
  803342:	00 00 00 
  803345:	ff d0                	call   *%rax
  803347:	89 c7                	mov    %eax,%edi
  803349:	b9 06 00 00 00       	mov    $0x6,%ecx
  80334e:	ba 00 10 00 00       	mov    $0x1000,%edx
  803353:	48 be 00 f0 ff ff 7f 	movabs $0x7ffffff000,%rsi
  80335a:	00 00 00 
  80335d:	48 b8 79 14 80 00 00 	movabs $0x801479,%rax
  803364:	00 00 00 
  803367:	ff d0                	call   *%rax
        _pfhandler_vec[_pfhandler_off++] = handler;
  803369:	48 ba 68 80 80 00 00 	movabs $0x808068,%rdx
  803370:	00 00 00 
  803373:	48 8b 02             	mov    (%rdx),%rax
  803376:	48 8d 48 01          	lea    0x1(%rax),%rcx
  80337a:	48 89 0a             	mov    %rcx,(%rdx)
  80337d:	48 ba 20 80 80 00 00 	movabs $0x808020,%rdx
  803384:	00 00 00 
  803387:	48 89 1c c2          	mov    %rbx,(%rdx,%rax,8)
        _pfhandler_inititiallized = 1;
  80338b:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  803392:	00 00 00 
  803395:	c6 00 01             	movb   $0x1,(%rax)
        goto end;
  803398:	e9 70 ff ff ff       	jmp    80330d <add_pgfault_handler+0x79>
    if (res < 0) panic("set_pgfault_handler: %i", res);
  80339d:	89 c1                	mov    %eax,%ecx
  80339f:	48 ba 0d 43 80 00 00 	movabs $0x80430d,%rdx
  8033a6:	00 00 00 
  8033a9:	be 3d 00 00 00       	mov    $0x3d,%esi
  8033ae:	48 bf ff 42 80 00 00 	movabs $0x8042ff,%rdi
  8033b5:	00 00 00 
  8033b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8033bd:	49 b8 cf 03 80 00 00 	movabs $0x8003cf,%r8
  8033c4:	00 00 00 
  8033c7:	41 ff d0             	call   *%r8
        if (handler == _pfhandler_vec[i]) return 0;
  8033ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8033cf:	e9 61 ff ff ff       	jmp    803335 <add_pgfault_handler+0xa1>

00000000008033d4 <remove_pgfault_handler>:

void
remove_pgfault_handler(pf_handler_t handler) {
  8033d4:	f3 0f 1e fa          	endbr64
  8033d8:	55                   	push   %rbp
  8033d9:	48 89 e5             	mov    %rsp,%rbp
    assert(_pfhandler_inititiallized);
  8033dc:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  8033e3:	00 00 00 
  8033e6:	80 38 00             	cmpb   $0x0,(%rax)
  8033e9:	74 33                	je     80341e <remove_pgfault_handler+0x4a>
    for (size_t i = 0; i < _pfhandler_off; i++) {
  8033eb:	48 a1 68 80 80 00 00 	movabs 0x808068,%rax
  8033f2:	00 00 00 
  8033f5:	b9 00 00 00 00       	mov    $0x0,%ecx
        if (_pfhandler_vec[i] == handler) {
  8033fa:	48 ba 20 80 80 00 00 	movabs $0x808020,%rdx
  803401:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++) {
  803404:	48 85 c0             	test   %rax,%rax
  803407:	0f 84 85 00 00 00    	je     803492 <remove_pgfault_handler+0xbe>
        if (_pfhandler_vec[i] == handler) {
  80340d:	48 39 3c ca          	cmp    %rdi,(%rdx,%rcx,8)
  803411:	74 40                	je     803453 <remove_pgfault_handler+0x7f>
    for (size_t i = 0; i < _pfhandler_off; i++) {
  803413:	48 83 c1 01          	add    $0x1,%rcx
  803417:	48 39 c1             	cmp    %rax,%rcx
  80341a:	75 f1                	jne    80340d <remove_pgfault_handler+0x39>
  80341c:	eb 74                	jmp    803492 <remove_pgfault_handler+0xbe>
    assert(_pfhandler_inititiallized);
  80341e:	48 b9 25 43 80 00 00 	movabs $0x804325,%rcx
  803425:	00 00 00 
  803428:	48 ba 91 42 80 00 00 	movabs $0x804291,%rdx
  80342f:	00 00 00 
  803432:	be 43 00 00 00       	mov    $0x43,%esi
  803437:	48 bf ff 42 80 00 00 	movabs $0x8042ff,%rdi
  80343e:	00 00 00 
  803441:	b8 00 00 00 00       	mov    $0x0,%eax
  803446:	49 b8 cf 03 80 00 00 	movabs $0x8003cf,%r8
  80344d:	00 00 00 
  803450:	41 ff d0             	call   *%r8
            memmove(_pfhandler_vec + i, _pfhandler_vec + i + 1, (_pfhandler_off - i - 1) * sizeof(*handler));
  803453:	48 8d 34 cd 08 00 00 	lea    0x8(,%rcx,8),%rsi
  80345a:	00 
  80345b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80345f:	48 29 ca             	sub    %rcx,%rdx
  803462:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  803469:	00 00 00 
  80346c:	48 8d 0c 06          	lea    (%rsi,%rax,1),%rcx
  803470:	48 8d 7c 30 f8       	lea    -0x8(%rax,%rsi,1),%rdi
  803475:	48 89 ce             	mov    %rcx,%rsi
  803478:	48 b8 8f 10 80 00 00 	movabs $0x80108f,%rax
  80347f:	00 00 00 
  803482:	ff d0                	call   *%rax
            _pfhandler_off--;
  803484:	48 b8 68 80 80 00 00 	movabs $0x808068,%rax
  80348b:	00 00 00 
  80348e:	48 83 28 01          	subq   $0x1,(%rax)
            return;
        }
    }
}
  803492:	5d                   	pop    %rbp
  803493:	c3                   	ret

0000000000803494 <__text_end>:
  803494:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80349b:	00 00 00 
  80349e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034a5:	00 00 00 
  8034a8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034af:	00 00 00 
  8034b2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034b9:	00 00 00 
  8034bc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034c3:	00 00 00 
  8034c6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034cd:	00 00 00 
  8034d0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034d7:	00 00 00 
  8034da:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034e1:	00 00 00 
  8034e4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034eb:	00 00 00 
  8034ee:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034f5:	00 00 00 
  8034f8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034ff:	00 00 00 
  803502:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803509:	00 00 00 
  80350c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803513:	00 00 00 
  803516:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80351d:	00 00 00 
  803520:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803527:	00 00 00 
  80352a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803531:	00 00 00 
  803534:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80353b:	00 00 00 
  80353e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803545:	00 00 00 
  803548:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80354f:	00 00 00 
  803552:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803559:	00 00 00 
  80355c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803563:	00 00 00 
  803566:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80356d:	00 00 00 
  803570:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803577:	00 00 00 
  80357a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803581:	00 00 00 
  803584:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80358b:	00 00 00 
  80358e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803595:	00 00 00 
  803598:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80359f:	00 00 00 
  8035a2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035a9:	00 00 00 
  8035ac:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035b3:	00 00 00 
  8035b6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035bd:	00 00 00 
  8035c0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035c7:	00 00 00 
  8035ca:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035d1:	00 00 00 
  8035d4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035db:	00 00 00 
  8035de:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035e5:	00 00 00 
  8035e8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035ef:	00 00 00 
  8035f2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035f9:	00 00 00 
  8035fc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803603:	00 00 00 
  803606:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80360d:	00 00 00 
  803610:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803617:	00 00 00 
  80361a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803621:	00 00 00 
  803624:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80362b:	00 00 00 
  80362e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803635:	00 00 00 
  803638:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80363f:	00 00 00 
  803642:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803649:	00 00 00 
  80364c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803653:	00 00 00 
  803656:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80365d:	00 00 00 
  803660:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803667:	00 00 00 
  80366a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803671:	00 00 00 
  803674:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80367b:	00 00 00 
  80367e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803685:	00 00 00 
  803688:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80368f:	00 00 00 
  803692:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803699:	00 00 00 
  80369c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036a3:	00 00 00 
  8036a6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036ad:	00 00 00 
  8036b0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036b7:	00 00 00 
  8036ba:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036c1:	00 00 00 
  8036c4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036cb:	00 00 00 
  8036ce:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036d5:	00 00 00 
  8036d8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036df:	00 00 00 
  8036e2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036e9:	00 00 00 
  8036ec:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036f3:	00 00 00 
  8036f6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036fd:	00 00 00 
  803700:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803707:	00 00 00 
  80370a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803711:	00 00 00 
  803714:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80371b:	00 00 00 
  80371e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803725:	00 00 00 
  803728:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80372f:	00 00 00 
  803732:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803739:	00 00 00 
  80373c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803743:	00 00 00 
  803746:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80374d:	00 00 00 
  803750:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803757:	00 00 00 
  80375a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803761:	00 00 00 
  803764:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80376b:	00 00 00 
  80376e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803775:	00 00 00 
  803778:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80377f:	00 00 00 
  803782:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803789:	00 00 00 
  80378c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803793:	00 00 00 
  803796:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80379d:	00 00 00 
  8037a0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037a7:	00 00 00 
  8037aa:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037b1:	00 00 00 
  8037b4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037bb:	00 00 00 
  8037be:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037c5:	00 00 00 
  8037c8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037cf:	00 00 00 
  8037d2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037d9:	00 00 00 
  8037dc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037e3:	00 00 00 
  8037e6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037ed:	00 00 00 
  8037f0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037f7:	00 00 00 
  8037fa:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803801:	00 00 00 
  803804:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80380b:	00 00 00 
  80380e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803815:	00 00 00 
  803818:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80381f:	00 00 00 
  803822:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803829:	00 00 00 
  80382c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803833:	00 00 00 
  803836:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80383d:	00 00 00 
  803840:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803847:	00 00 00 
  80384a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803851:	00 00 00 
  803854:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80385b:	00 00 00 
  80385e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803865:	00 00 00 
  803868:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80386f:	00 00 00 
  803872:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803879:	00 00 00 
  80387c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803883:	00 00 00 
  803886:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80388d:	00 00 00 
  803890:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803897:	00 00 00 
  80389a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038a1:	00 00 00 
  8038a4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038ab:	00 00 00 
  8038ae:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038b5:	00 00 00 
  8038b8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038bf:	00 00 00 
  8038c2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038c9:	00 00 00 
  8038cc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038d3:	00 00 00 
  8038d6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038dd:	00 00 00 
  8038e0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038e7:	00 00 00 
  8038ea:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038f1:	00 00 00 
  8038f4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038fb:	00 00 00 
  8038fe:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803905:	00 00 00 
  803908:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80390f:	00 00 00 
  803912:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803919:	00 00 00 
  80391c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803923:	00 00 00 
  803926:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80392d:	00 00 00 
  803930:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803937:	00 00 00 
  80393a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803941:	00 00 00 
  803944:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80394b:	00 00 00 
  80394e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803955:	00 00 00 
  803958:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80395f:	00 00 00 
  803962:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803969:	00 00 00 
  80396c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803973:	00 00 00 
  803976:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80397d:	00 00 00 
  803980:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803987:	00 00 00 
  80398a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803991:	00 00 00 
  803994:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80399b:	00 00 00 
  80399e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039a5:	00 00 00 
  8039a8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039af:	00 00 00 
  8039b2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039b9:	00 00 00 
  8039bc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039c3:	00 00 00 
  8039c6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039cd:	00 00 00 
  8039d0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039d7:	00 00 00 
  8039da:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039e1:	00 00 00 
  8039e4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039eb:	00 00 00 
  8039ee:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039f5:	00 00 00 
  8039f8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039ff:	00 00 00 
  803a02:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a09:	00 00 00 
  803a0c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a13:	00 00 00 
  803a16:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a1d:	00 00 00 
  803a20:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a27:	00 00 00 
  803a2a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a31:	00 00 00 
  803a34:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a3b:	00 00 00 
  803a3e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a45:	00 00 00 
  803a48:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a4f:	00 00 00 
  803a52:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a59:	00 00 00 
  803a5c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a63:	00 00 00 
  803a66:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a6d:	00 00 00 
  803a70:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a77:	00 00 00 
  803a7a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a81:	00 00 00 
  803a84:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a8b:	00 00 00 
  803a8e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a95:	00 00 00 
  803a98:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a9f:	00 00 00 
  803aa2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803aa9:	00 00 00 
  803aac:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ab3:	00 00 00 
  803ab6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803abd:	00 00 00 
  803ac0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ac7:	00 00 00 
  803aca:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ad1:	00 00 00 
  803ad4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803adb:	00 00 00 
  803ade:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ae5:	00 00 00 
  803ae8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803aef:	00 00 00 
  803af2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803af9:	00 00 00 
  803afc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b03:	00 00 00 
  803b06:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b0d:	00 00 00 
  803b10:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b17:	00 00 00 
  803b1a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b21:	00 00 00 
  803b24:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b2b:	00 00 00 
  803b2e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b35:	00 00 00 
  803b38:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b3f:	00 00 00 
  803b42:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b49:	00 00 00 
  803b4c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b53:	00 00 00 
  803b56:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b5d:	00 00 00 
  803b60:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b67:	00 00 00 
  803b6a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b71:	00 00 00 
  803b74:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b7b:	00 00 00 
  803b7e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b85:	00 00 00 
  803b88:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b8f:	00 00 00 
  803b92:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b99:	00 00 00 
  803b9c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ba3:	00 00 00 
  803ba6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bad:	00 00 00 
  803bb0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bb7:	00 00 00 
  803bba:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bc1:	00 00 00 
  803bc4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bcb:	00 00 00 
  803bce:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bd5:	00 00 00 
  803bd8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bdf:	00 00 00 
  803be2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803be9:	00 00 00 
  803bec:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bf3:	00 00 00 
  803bf6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bfd:	00 00 00 
  803c00:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c07:	00 00 00 
  803c0a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c11:	00 00 00 
  803c14:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c1b:	00 00 00 
  803c1e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c25:	00 00 00 
  803c28:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c2f:	00 00 00 
  803c32:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c39:	00 00 00 
  803c3c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c43:	00 00 00 
  803c46:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c4d:	00 00 00 
  803c50:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c57:	00 00 00 
  803c5a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c61:	00 00 00 
  803c64:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c6b:	00 00 00 
  803c6e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c75:	00 00 00 
  803c78:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c7f:	00 00 00 
  803c82:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c89:	00 00 00 
  803c8c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c93:	00 00 00 
  803c96:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c9d:	00 00 00 
  803ca0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ca7:	00 00 00 
  803caa:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cb1:	00 00 00 
  803cb4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cbb:	00 00 00 
  803cbe:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cc5:	00 00 00 
  803cc8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ccf:	00 00 00 
  803cd2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cd9:	00 00 00 
  803cdc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ce3:	00 00 00 
  803ce6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ced:	00 00 00 
  803cf0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cf7:	00 00 00 
  803cfa:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d01:	00 00 00 
  803d04:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d0b:	00 00 00 
  803d0e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d15:	00 00 00 
  803d18:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d1f:	00 00 00 
  803d22:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d29:	00 00 00 
  803d2c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d33:	00 00 00 
  803d36:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d3d:	00 00 00 
  803d40:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d47:	00 00 00 
  803d4a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d51:	00 00 00 
  803d54:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d5b:	00 00 00 
  803d5e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d65:	00 00 00 
  803d68:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d6f:	00 00 00 
  803d72:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d79:	00 00 00 
  803d7c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d83:	00 00 00 
  803d86:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d8d:	00 00 00 
  803d90:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d97:	00 00 00 
  803d9a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803da1:	00 00 00 
  803da4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dab:	00 00 00 
  803dae:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803db5:	00 00 00 
  803db8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dbf:	00 00 00 
  803dc2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dc9:	00 00 00 
  803dcc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dd3:	00 00 00 
  803dd6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ddd:	00 00 00 
  803de0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803de7:	00 00 00 
  803dea:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803df1:	00 00 00 
  803df4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dfb:	00 00 00 
  803dfe:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e05:	00 00 00 
  803e08:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e0f:	00 00 00 
  803e12:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e19:	00 00 00 
  803e1c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e23:	00 00 00 
  803e26:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e2d:	00 00 00 
  803e30:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e37:	00 00 00 
  803e3a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e41:	00 00 00 
  803e44:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e4b:	00 00 00 
  803e4e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e55:	00 00 00 
  803e58:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e5f:	00 00 00 
  803e62:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e69:	00 00 00 
  803e6c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e73:	00 00 00 
  803e76:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e7d:	00 00 00 
  803e80:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e87:	00 00 00 
  803e8a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e91:	00 00 00 
  803e94:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e9b:	00 00 00 
  803e9e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ea5:	00 00 00 
  803ea8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803eaf:	00 00 00 
  803eb2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803eb9:	00 00 00 
  803ebc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ec3:	00 00 00 
  803ec6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ecd:	00 00 00 
  803ed0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ed7:	00 00 00 
  803eda:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ee1:	00 00 00 
  803ee4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803eeb:	00 00 00 
  803eee:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ef5:	00 00 00 
  803ef8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803eff:	00 00 00 
  803f02:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f09:	00 00 00 
  803f0c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f13:	00 00 00 
  803f16:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f1d:	00 00 00 
  803f20:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f27:	00 00 00 
  803f2a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f31:	00 00 00 
  803f34:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f3b:	00 00 00 
  803f3e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f45:	00 00 00 
  803f48:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f4f:	00 00 00 
  803f52:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f59:	00 00 00 
  803f5c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f63:	00 00 00 
  803f66:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f6d:	00 00 00 
  803f70:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f77:	00 00 00 
  803f7a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f81:	00 00 00 
  803f84:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f8b:	00 00 00 
  803f8e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f95:	00 00 00 
  803f98:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f9f:	00 00 00 
  803fa2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fa9:	00 00 00 
  803fac:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fb3:	00 00 00 
  803fb6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fbd:	00 00 00 
  803fc0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fc7:	00 00 00 
  803fca:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fd1:	00 00 00 
  803fd4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fdb:	00 00 00 
  803fde:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fe5:	00 00 00 
  803fe8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fef:	00 00 00 
  803ff2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ff9:	00 00 00 
  803ffc:	0f 1f 40 00          	nopl   0x0(%rax)
