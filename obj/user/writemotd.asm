
obj/user/writemotd:     file format elf64-x86-64


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
  80001e:	e8 f9 02 00 00       	call   80031c <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <umain>:
#include <inc/lib.h>

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
  800036:	48 81 ec 08 02 00 00 	sub    $0x208,%rsp
    int rfd, wfd;
    char buf[512];
    int n, r;

    if ((rfd = open("/newmotd", O_RDONLY)) < 0)
  80003d:	be 00 00 00 00       	mov    $0x0,%esi
  800042:	48 bf 00 30 80 00 00 	movabs $0x803000,%rdi
  800049:	00 00 00 
  80004c:	48 b8 2e 22 80 00 00 	movabs $0x80222e,%rax
  800053:	00 00 00 
  800056:	ff d0                	call   *%rax
  800058:	41 89 c6             	mov    %eax,%r14d
  80005b:	85 c0                	test   %eax,%eax
  80005d:	0f 88 a6 00 00 00    	js     800109 <umain+0xe4>
        panic("open /newmotd: %i", rfd);
    if ((wfd = open("/motd", O_RDWR)) < 0)
  800063:	be 02 00 00 00       	mov    $0x2,%esi
  800068:	48 bf 2c 30 80 00 00 	movabs $0x80302c,%rdi
  80006f:	00 00 00 
  800072:	48 b8 2e 22 80 00 00 	movabs $0x80222e,%rax
  800079:	00 00 00 
  80007c:	ff d0                	call   *%rax
  80007e:	41 89 c5             	mov    %eax,%r13d
  800081:	85 c0                	test   %eax,%eax
  800083:	0f 88 ad 00 00 00    	js     800136 <umain+0x111>
        panic("open /motd: %i", wfd);
    cprintf("file descriptors %d %d\n", rfd, wfd);
  800089:	89 c2                	mov    %eax,%edx
  80008b:	44 89 f6             	mov    %r14d,%esi
  80008e:	48 bf 41 30 80 00 00 	movabs $0x803041,%rdi
  800095:	00 00 00 
  800098:	b8 00 00 00 00       	mov    $0x0,%eax
  80009d:	48 b9 51 05 80 00 00 	movabs $0x800551,%rcx
  8000a4:	00 00 00 
  8000a7:	ff d1                	call   *%rcx
    if (rfd == wfd)
  8000a9:	45 39 ee             	cmp    %r13d,%r14d
  8000ac:	0f 84 b1 00 00 00    	je     800163 <umain+0x13e>
        panic("open /newmotd and /motd give same file descriptor");

    cprintf("OLD MOTD\n===\n");
  8000b2:	48 bf 59 30 80 00 00 	movabs $0x803059,%rdi
  8000b9:	00 00 00 
  8000bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8000c1:	48 ba 51 05 80 00 00 	movabs $0x800551,%rdx
  8000c8:	00 00 00 
  8000cb:	ff d2                	call   *%rdx
    while ((n = read(wfd, buf, sizeof buf - 1)) > 0)
  8000cd:	48 bb f8 1b 80 00 00 	movabs $0x801bf8,%rbx
  8000d4:	00 00 00 
        sys_cputs(buf, n);
  8000d7:	49 bc fa 12 80 00 00 	movabs $0x8012fa,%r12
  8000de:	00 00 00 
    while ((n = read(wfd, buf, sizeof buf - 1)) > 0)
  8000e1:	ba ff 01 00 00       	mov    $0x1ff,%edx
  8000e6:	48 8d b5 d0 fd ff ff 	lea    -0x230(%rbp),%rsi
  8000ed:	44 89 ef             	mov    %r13d,%edi
  8000f0:	ff d3                	call   *%rbx
  8000f2:	85 c0                	test   %eax,%eax
  8000f4:	0f 8e 93 00 00 00    	jle    80018d <umain+0x168>
        sys_cputs(buf, n);
  8000fa:	48 63 f0             	movslq %eax,%rsi
  8000fd:	48 8d bd d0 fd ff ff 	lea    -0x230(%rbp),%rdi
  800104:	41 ff d4             	call   *%r12
  800107:	eb d8                	jmp    8000e1 <umain+0xbc>
        panic("open /newmotd: %i", rfd);
  800109:	89 c1                	mov    %eax,%ecx
  80010b:	48 ba 09 30 80 00 00 	movabs $0x803009,%rdx
  800112:	00 00 00 
  800115:	be 0a 00 00 00       	mov    $0xa,%esi
  80011a:	48 bf 1b 30 80 00 00 	movabs $0x80301b,%rdi
  800121:	00 00 00 
  800124:	b8 00 00 00 00       	mov    $0x0,%eax
  800129:	49 b8 f5 03 80 00 00 	movabs $0x8003f5,%r8
  800130:	00 00 00 
  800133:	41 ff d0             	call   *%r8
        panic("open /motd: %i", wfd);
  800136:	89 c1                	mov    %eax,%ecx
  800138:	48 ba 32 30 80 00 00 	movabs $0x803032,%rdx
  80013f:	00 00 00 
  800142:	be 0c 00 00 00       	mov    $0xc,%esi
  800147:	48 bf 1b 30 80 00 00 	movabs $0x80301b,%rdi
  80014e:	00 00 00 
  800151:	b8 00 00 00 00       	mov    $0x0,%eax
  800156:	49 b8 f5 03 80 00 00 	movabs $0x8003f5,%r8
  80015d:	00 00 00 
  800160:	41 ff d0             	call   *%r8
        panic("open /newmotd and /motd give same file descriptor");
  800163:	48 ba 00 33 80 00 00 	movabs $0x803300,%rdx
  80016a:	00 00 00 
  80016d:	be 0f 00 00 00       	mov    $0xf,%esi
  800172:	48 bf 1b 30 80 00 00 	movabs $0x80301b,%rdi
  800179:	00 00 00 
  80017c:	b8 00 00 00 00       	mov    $0x0,%eax
  800181:	48 b9 f5 03 80 00 00 	movabs $0x8003f5,%rcx
  800188:	00 00 00 
  80018b:	ff d1                	call   *%rcx
    cprintf("===\n");
  80018d:	48 bf 62 30 80 00 00 	movabs $0x803062,%rdi
  800194:	00 00 00 
  800197:	b8 00 00 00 00       	mov    $0x0,%eax
  80019c:	48 ba 51 05 80 00 00 	movabs $0x800551,%rdx
  8001a3:	00 00 00 
  8001a6:	ff d2                	call   *%rdx
    seek(wfd, 0);
  8001a8:	be 00 00 00 00       	mov    $0x0,%esi
  8001ad:	44 89 ef             	mov    %r13d,%edi
  8001b0:	48 b8 ec 1d 80 00 00 	movabs $0x801dec,%rax
  8001b7:	00 00 00 
  8001ba:	ff d0                	call   *%rax

    if ((r = ftruncate(wfd, 0)) < 0)
  8001bc:	be 00 00 00 00       	mov    $0x0,%esi
  8001c1:	44 89 ef             	mov    %r13d,%edi
  8001c4:	48 b8 21 1e 80 00 00 	movabs $0x801e21,%rax
  8001cb:	00 00 00 
  8001ce:	ff d0                	call   *%rax
  8001d0:	85 c0                	test   %eax,%eax
  8001d2:	0f 88 a5 00 00 00    	js     80027d <umain+0x258>
        panic("truncate /motd: %i", r);

    cprintf("NEW MOTD\n===\n");
  8001d8:	48 bf 7a 30 80 00 00 	movabs $0x80307a,%rdi
  8001df:	00 00 00 
  8001e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8001e7:	48 ba 51 05 80 00 00 	movabs $0x800551,%rdx
  8001ee:	00 00 00 
  8001f1:	ff d2                	call   *%rdx
    while ((n = read(rfd, buf, sizeof buf - 1)) > 0) {
  8001f3:	49 bf f8 1b 80 00 00 	movabs $0x801bf8,%r15
  8001fa:	00 00 00 
  8001fd:	ba ff 01 00 00       	mov    $0x1ff,%edx
  800202:	48 8d b5 d0 fd ff ff 	lea    -0x230(%rbp),%rsi
  800209:	44 89 f7             	mov    %r14d,%edi
  80020c:	41 ff d7             	call   *%r15
  80020f:	48 89 c3             	mov    %rax,%rbx
  800212:	85 c0                	test   %eax,%eax
  800214:	0f 8e 90 00 00 00    	jle    8002aa <umain+0x285>
        sys_cputs(buf, n);
  80021a:	4c 63 e3             	movslq %ebx,%r12
  80021d:	4c 89 e6             	mov    %r12,%rsi
  800220:	48 8d bd d0 fd ff ff 	lea    -0x230(%rbp),%rdi
  800227:	48 b8 fa 12 80 00 00 	movabs $0x8012fa,%rax
  80022e:	00 00 00 
  800231:	ff d0                	call   *%rax
        if ((r = write(wfd, buf, n)) != n)
  800233:	4c 89 e2             	mov    %r12,%rdx
  800236:	48 8d b5 d0 fd ff ff 	lea    -0x230(%rbp),%rsi
  80023d:	44 89 ef             	mov    %r13d,%edi
  800240:	48 b8 2f 1d 80 00 00 	movabs $0x801d2f,%rax
  800247:	00 00 00 
  80024a:	ff d0                	call   *%rax
  80024c:	89 c1                	mov    %eax,%ecx
  80024e:	39 c3                	cmp    %eax,%ebx
  800250:	74 ab                	je     8001fd <umain+0x1d8>
            panic("write /motd: %i", r);
  800252:	48 ba 88 30 80 00 00 	movabs $0x803088,%rdx
  800259:	00 00 00 
  80025c:	be 1e 00 00 00       	mov    $0x1e,%esi
  800261:	48 bf 1b 30 80 00 00 	movabs $0x80301b,%rdi
  800268:	00 00 00 
  80026b:	b8 00 00 00 00       	mov    $0x0,%eax
  800270:	49 b8 f5 03 80 00 00 	movabs $0x8003f5,%r8
  800277:	00 00 00 
  80027a:	41 ff d0             	call   *%r8
        panic("truncate /motd: %i", r);
  80027d:	89 c1                	mov    %eax,%ecx
  80027f:	48 ba 67 30 80 00 00 	movabs $0x803067,%rdx
  800286:	00 00 00 
  800289:	be 18 00 00 00       	mov    $0x18,%esi
  80028e:	48 bf 1b 30 80 00 00 	movabs $0x80301b,%rdi
  800295:	00 00 00 
  800298:	b8 00 00 00 00       	mov    $0x0,%eax
  80029d:	49 b8 f5 03 80 00 00 	movabs $0x8003f5,%r8
  8002a4:	00 00 00 
  8002a7:	41 ff d0             	call   *%r8
    }
    cprintf("===\n");
  8002aa:	48 bf 62 30 80 00 00 	movabs $0x803062,%rdi
  8002b1:	00 00 00 
  8002b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8002b9:	48 ba 51 05 80 00 00 	movabs $0x800551,%rdx
  8002c0:	00 00 00 
  8002c3:	ff d2                	call   *%rdx

    if (n < 0)
  8002c5:	85 db                	test   %ebx,%ebx
  8002c7:	78 26                	js     8002ef <umain+0x2ca>
        panic("read /newmotd: %i", n);

    close(rfd);
  8002c9:	44 89 f7             	mov    %r14d,%edi
  8002cc:	48 bb 6e 1a 80 00 00 	movabs $0x801a6e,%rbx
  8002d3:	00 00 00 
  8002d6:	ff d3                	call   *%rbx
    close(wfd);
  8002d8:	44 89 ef             	mov    %r13d,%edi
  8002db:	ff d3                	call   *%rbx
}
  8002dd:	48 81 c4 08 02 00 00 	add    $0x208,%rsp
  8002e4:	5b                   	pop    %rbx
  8002e5:	41 5c                	pop    %r12
  8002e7:	41 5d                	pop    %r13
  8002e9:	41 5e                	pop    %r14
  8002eb:	41 5f                	pop    %r15
  8002ed:	5d                   	pop    %rbp
  8002ee:	c3                   	ret
        panic("read /newmotd: %i", n);
  8002ef:	89 d9                	mov    %ebx,%ecx
  8002f1:	48 ba 98 30 80 00 00 	movabs $0x803098,%rdx
  8002f8:	00 00 00 
  8002fb:	be 23 00 00 00       	mov    $0x23,%esi
  800300:	48 bf 1b 30 80 00 00 	movabs $0x80301b,%rdi
  800307:	00 00 00 
  80030a:	b8 00 00 00 00       	mov    $0x0,%eax
  80030f:	49 b8 f5 03 80 00 00 	movabs $0x8003f5,%r8
  800316:	00 00 00 
  800319:	41 ff d0             	call   *%r8

000000000080031c <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  80031c:	f3 0f 1e fa          	endbr64
  800320:	55                   	push   %rbp
  800321:	48 89 e5             	mov    %rsp,%rbp
  800324:	41 56                	push   %r14
  800326:	41 55                	push   %r13
  800328:	41 54                	push   %r12
  80032a:	53                   	push   %rbx
  80032b:	41 89 fd             	mov    %edi,%r13d
  80032e:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
     * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  800331:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  800338:	00 00 00 
  80033b:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  800342:	00 00 00 
  800345:	48 39 c2             	cmp    %rax,%rdx
  800348:	73 17                	jae    800361 <libmain+0x45>
    void (**ctor)() = &__ctors_start;
  80034a:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  80034d:	49 89 c4             	mov    %rax,%r12
  800350:	48 83 c3 08          	add    $0x8,%rbx
  800354:	b8 00 00 00 00       	mov    $0x0,%eax
  800359:	ff 53 f8             	call   *-0x8(%rbx)
  80035c:	4c 39 e3             	cmp    %r12,%rbx
  80035f:	72 ef                	jb     800350 <libmain+0x34>

    /* Set thisenv to point at our Env structure in envs[]. */

    // LAB 8: Your code here
    thisenv = &((struct Env *)UENVS)[ENVX(sys_getenvid())];
  800361:	48 b8 cf 13 80 00 00 	movabs $0x8013cf,%rax
  800368:	00 00 00 
  80036b:	ff d0                	call   *%rax
  80036d:	25 ff 03 00 00       	and    $0x3ff,%eax
  800372:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  800376:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  80037a:	48 c1 e0 04          	shl    $0x4,%rax
  80037e:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  800385:	00 00 00 
  800388:	48 01 d0             	add    %rdx,%rax
  80038b:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  800392:	00 00 00 

    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  800395:	45 85 ed             	test   %r13d,%r13d
  800398:	7e 0d                	jle    8003a7 <libmain+0x8b>
  80039a:	49 8b 06             	mov    (%r14),%rax
  80039d:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  8003a4:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  8003a7:	4c 89 f6             	mov    %r14,%rsi
  8003aa:	44 89 ef             	mov    %r13d,%edi
  8003ad:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  8003b4:	00 00 00 
  8003b7:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  8003b9:	48 b8 ce 03 80 00 00 	movabs $0x8003ce,%rax
  8003c0:	00 00 00 
  8003c3:	ff d0                	call   *%rax
#endif
}
  8003c5:	5b                   	pop    %rbx
  8003c6:	41 5c                	pop    %r12
  8003c8:	41 5d                	pop    %r13
  8003ca:	41 5e                	pop    %r14
  8003cc:	5d                   	pop    %rbp
  8003cd:	c3                   	ret

00000000008003ce <exit>:

#include <inc/lib.h>

void
exit(void) {
  8003ce:	f3 0f 1e fa          	endbr64
  8003d2:	55                   	push   %rbp
  8003d3:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  8003d6:	48 b8 a5 1a 80 00 00 	movabs $0x801aa5,%rax
  8003dd:	00 00 00 
  8003e0:	ff d0                	call   *%rax
    sys_env_destroy(0);
  8003e2:	bf 00 00 00 00       	mov    $0x0,%edi
  8003e7:	48 b8 60 13 80 00 00 	movabs $0x801360,%rax
  8003ee:	00 00 00 
  8003f1:	ff d0                	call   *%rax
}
  8003f3:	5d                   	pop    %rbp
  8003f4:	c3                   	ret

00000000008003f5 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  8003f5:	f3 0f 1e fa          	endbr64
  8003f9:	55                   	push   %rbp
  8003fa:	48 89 e5             	mov    %rsp,%rbp
  8003fd:	41 56                	push   %r14
  8003ff:	41 55                	push   %r13
  800401:	41 54                	push   %r12
  800403:	53                   	push   %rbx
  800404:	48 83 ec 50          	sub    $0x50,%rsp
  800408:	49 89 fc             	mov    %rdi,%r12
  80040b:	41 89 f5             	mov    %esi,%r13d
  80040e:	48 89 d3             	mov    %rdx,%rbx
  800411:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800415:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  800419:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  80041d:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  800424:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800428:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  80042c:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  800430:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  800434:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  80043b:	00 00 00 
  80043e:	4c 8b 30             	mov    (%rax),%r14
  800441:	48 b8 cf 13 80 00 00 	movabs $0x8013cf,%rax
  800448:	00 00 00 
  80044b:	ff d0                	call   *%rax
  80044d:	89 c6                	mov    %eax,%esi
  80044f:	45 89 e8             	mov    %r13d,%r8d
  800452:	4c 89 e1             	mov    %r12,%rcx
  800455:	4c 89 f2             	mov    %r14,%rdx
  800458:	48 bf 38 33 80 00 00 	movabs $0x803338,%rdi
  80045f:	00 00 00 
  800462:	b8 00 00 00 00       	mov    $0x0,%eax
  800467:	49 bc 51 05 80 00 00 	movabs $0x800551,%r12
  80046e:	00 00 00 
  800471:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  800474:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  800478:	48 89 df             	mov    %rbx,%rdi
  80047b:	48 b8 e9 04 80 00 00 	movabs $0x8004e9,%rax
  800482:	00 00 00 
  800485:	ff d0                	call   *%rax
    cprintf("\n");
  800487:	48 bf 65 30 80 00 00 	movabs $0x803065,%rdi
  80048e:	00 00 00 
  800491:	b8 00 00 00 00       	mov    $0x0,%eax
  800496:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  800499:	cc                   	int3
  80049a:	eb fd                	jmp    800499 <_panic+0xa4>

000000000080049c <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  80049c:	f3 0f 1e fa          	endbr64
  8004a0:	55                   	push   %rbp
  8004a1:	48 89 e5             	mov    %rsp,%rbp
  8004a4:	53                   	push   %rbx
  8004a5:	48 83 ec 08          	sub    $0x8,%rsp
  8004a9:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  8004ac:	8b 06                	mov    (%rsi),%eax
  8004ae:	8d 50 01             	lea    0x1(%rax),%edx
  8004b1:	89 16                	mov    %edx,(%rsi)
  8004b3:	48 98                	cltq
  8004b5:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  8004ba:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  8004c0:	74 0a                	je     8004cc <putch+0x30>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  8004c2:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  8004c6:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8004ca:	c9                   	leave
  8004cb:	c3                   	ret
        sys_cputs(state->buf, state->offset);
  8004cc:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  8004d0:	be ff 00 00 00       	mov    $0xff,%esi
  8004d5:	48 b8 fa 12 80 00 00 	movabs $0x8012fa,%rax
  8004dc:	00 00 00 
  8004df:	ff d0                	call   *%rax
        state->offset = 0;
  8004e1:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  8004e7:	eb d9                	jmp    8004c2 <putch+0x26>

00000000008004e9 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  8004e9:	f3 0f 1e fa          	endbr64
  8004ed:	55                   	push   %rbp
  8004ee:	48 89 e5             	mov    %rsp,%rbp
  8004f1:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8004f8:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  8004fb:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  800502:	b9 21 00 00 00       	mov    $0x21,%ecx
  800507:	b8 00 00 00 00       	mov    $0x0,%eax
  80050c:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  80050f:	48 89 f1             	mov    %rsi,%rcx
  800512:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  800519:	48 bf 9c 04 80 00 00 	movabs $0x80049c,%rdi
  800520:	00 00 00 
  800523:	48 b8 b1 06 80 00 00 	movabs $0x8006b1,%rax
  80052a:	00 00 00 
  80052d:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  80052f:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  800536:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  80053d:	48 b8 fa 12 80 00 00 	movabs $0x8012fa,%rax
  800544:	00 00 00 
  800547:	ff d0                	call   *%rax

    return state.count;
}
  800549:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  80054f:	c9                   	leave
  800550:	c3                   	ret

0000000000800551 <cprintf>:

int
cprintf(const char *fmt, ...) {
  800551:	f3 0f 1e fa          	endbr64
  800555:	55                   	push   %rbp
  800556:	48 89 e5             	mov    %rsp,%rbp
  800559:	48 83 ec 50          	sub    $0x50,%rsp
  80055d:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  800561:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  800565:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800569:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  80056d:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  800571:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  800578:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80057c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800580:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800584:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  800588:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  80058c:	48 b8 e9 04 80 00 00 	movabs $0x8004e9,%rax
  800593:	00 00 00 
  800596:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  800598:	c9                   	leave
  800599:	c3                   	ret

000000000080059a <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  80059a:	f3 0f 1e fa          	endbr64
  80059e:	55                   	push   %rbp
  80059f:	48 89 e5             	mov    %rsp,%rbp
  8005a2:	41 57                	push   %r15
  8005a4:	41 56                	push   %r14
  8005a6:	41 55                	push   %r13
  8005a8:	41 54                	push   %r12
  8005aa:	53                   	push   %rbx
  8005ab:	48 83 ec 18          	sub    $0x18,%rsp
  8005af:	49 89 fc             	mov    %rdi,%r12
  8005b2:	49 89 f5             	mov    %rsi,%r13
  8005b5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  8005b9:	8b 45 10             	mov    0x10(%rbp),%eax
  8005bc:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  8005bf:	41 89 cf             	mov    %ecx,%r15d
  8005c2:	4c 39 fa             	cmp    %r15,%rdx
  8005c5:	73 5b                	jae    800622 <print_num+0x88>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  8005c7:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  8005cb:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  8005cf:	85 db                	test   %ebx,%ebx
  8005d1:	7e 0e                	jle    8005e1 <print_num+0x47>
            putch(padc, put_arg);
  8005d3:	4c 89 ee             	mov    %r13,%rsi
  8005d6:	44 89 f7             	mov    %r14d,%edi
  8005d9:	41 ff d4             	call   *%r12
        while (--width > 0) {
  8005dc:	83 eb 01             	sub    $0x1,%ebx
  8005df:	75 f2                	jne    8005d3 <print_num+0x39>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  8005e1:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  8005e5:	48 b9 c5 30 80 00 00 	movabs $0x8030c5,%rcx
  8005ec:	00 00 00 
  8005ef:	48 b8 b4 30 80 00 00 	movabs $0x8030b4,%rax
  8005f6:	00 00 00 
  8005f9:	48 0f 45 c8          	cmovne %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  8005fd:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800601:	ba 00 00 00 00       	mov    $0x0,%edx
  800606:	49 f7 f7             	div    %r15
  800609:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  80060d:	4c 89 ee             	mov    %r13,%rsi
  800610:	41 ff d4             	call   *%r12
}
  800613:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800617:	5b                   	pop    %rbx
  800618:	41 5c                	pop    %r12
  80061a:	41 5d                	pop    %r13
  80061c:	41 5e                	pop    %r14
  80061e:	41 5f                	pop    %r15
  800620:	5d                   	pop    %rbp
  800621:	c3                   	ret
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  800622:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800626:	ba 00 00 00 00       	mov    $0x0,%edx
  80062b:	49 f7 f7             	div    %r15
  80062e:	48 83 ec 08          	sub    $0x8,%rsp
  800632:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  800636:	52                   	push   %rdx
  800637:	45 0f be c9          	movsbl %r9b,%r9d
  80063b:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  80063f:	48 89 c2             	mov    %rax,%rdx
  800642:	48 b8 9a 05 80 00 00 	movabs $0x80059a,%rax
  800649:	00 00 00 
  80064c:	ff d0                	call   *%rax
  80064e:	48 83 c4 10          	add    $0x10,%rsp
  800652:	eb 8d                	jmp    8005e1 <print_num+0x47>

0000000000800654 <sprintputch>:
    char *end;
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
  800654:	f3 0f 1e fa          	endbr64
    state->count++;
  800658:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  80065c:	48 8b 06             	mov    (%rsi),%rax
  80065f:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  800663:	73 0a                	jae    80066f <sprintputch+0x1b>
        *state->start++ = ch;
  800665:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800669:	48 89 16             	mov    %rdx,(%rsi)
  80066c:	40 88 38             	mov    %dil,(%rax)
    }
}
  80066f:	c3                   	ret

0000000000800670 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  800670:	f3 0f 1e fa          	endbr64
  800674:	55                   	push   %rbp
  800675:	48 89 e5             	mov    %rsp,%rbp
  800678:	48 83 ec 50          	sub    $0x50,%rsp
  80067c:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800680:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800684:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  800688:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  80068f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800693:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800697:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80069b:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  80069f:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  8006a3:	48 b8 b1 06 80 00 00 	movabs $0x8006b1,%rax
  8006aa:	00 00 00 
  8006ad:	ff d0                	call   *%rax
}
  8006af:	c9                   	leave
  8006b0:	c3                   	ret

00000000008006b1 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  8006b1:	f3 0f 1e fa          	endbr64
  8006b5:	55                   	push   %rbp
  8006b6:	48 89 e5             	mov    %rsp,%rbp
  8006b9:	41 57                	push   %r15
  8006bb:	41 56                	push   %r14
  8006bd:	41 55                	push   %r13
  8006bf:	41 54                	push   %r12
  8006c1:	53                   	push   %rbx
  8006c2:	48 83 ec 38          	sub    $0x38,%rsp
  8006c6:	49 89 fe             	mov    %rdi,%r14
  8006c9:	49 89 f5             	mov    %rsi,%r13
  8006cc:	48 89 d3             	mov    %rdx,%rbx
    va_copy(aq, ap);
  8006cf:	48 8b 01             	mov    (%rcx),%rax
  8006d2:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  8006d6:	48 8b 41 08          	mov    0x8(%rcx),%rax
  8006da:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8006de:	48 8b 41 10          	mov    0x10(%rcx),%rax
  8006e2:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  8006e6:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  8006ea:	0f b6 3b             	movzbl (%rbx),%edi
  8006ed:	40 80 ff 25          	cmp    $0x25,%dil
  8006f1:	74 18                	je     80070b <vprintfmt+0x5a>
            if (!ch) return;
  8006f3:	40 84 ff             	test   %dil,%dil
  8006f6:	0f 84 b2 06 00 00    	je     800dae <vprintfmt+0x6fd>
            putch(ch, put_arg);
  8006fc:	40 0f b6 ff          	movzbl %dil,%edi
  800700:	4c 89 ee             	mov    %r13,%rsi
  800703:	41 ff d6             	call   *%r14
        while ((ch = *ufmt++) != '%') {
  800706:	4c 89 e3             	mov    %r12,%rbx
  800709:	eb db                	jmp    8006e6 <vprintfmt+0x35>
        bool altflag = 0, zflag = 0;
  80070b:	be 00 00 00 00       	mov    $0x0,%esi
  800710:	c6 45 ab 00          	movb   $0x0,-0x55(%rbp)
        unsigned lflag = 0, base = 10;
  800714:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  800719:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  80071f:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  800726:	c6 45 aa 20          	movb   $0x20,-0x56(%rbp)
        switch (ch = *ufmt++) {
  80072a:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  80072f:	41 0f b6 04 24       	movzbl (%r12),%eax
  800734:	88 45 a0             	mov    %al,-0x60(%rbp)
  800737:	83 e8 23             	sub    $0x23,%eax
  80073a:	3c 57                	cmp    $0x57,%al
  80073c:	0f 87 52 06 00 00    	ja     800d94 <vprintfmt+0x6e3>
  800742:	0f b6 c0             	movzbl %al,%eax
  800745:	48 b9 20 34 80 00 00 	movabs $0x803420,%rcx
  80074c:	00 00 00 
  80074f:	3e ff 24 c1          	notrack jmp *(%rcx,%rax,8)
  800753:	49 89 dc             	mov    %rbx,%r12
            altflag = 1;
  800756:	c6 45 ab 01          	movb   $0x1,-0x55(%rbp)
  80075a:	eb ce                	jmp    80072a <vprintfmt+0x79>
        switch (ch = *ufmt++) {
  80075c:	49 89 dc             	mov    %rbx,%r12
  80075f:	be 01 00 00 00       	mov    $0x1,%esi
  800764:	eb c4                	jmp    80072a <vprintfmt+0x79>
            padc = ch;
  800766:	0f b6 45 a0          	movzbl -0x60(%rbp),%eax
  80076a:	88 45 aa             	mov    %al,-0x56(%rbp)
        switch (ch = *ufmt++) {
  80076d:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  800770:	eb b8                	jmp    80072a <vprintfmt+0x79>
            precision = va_arg(aq, int);
  800772:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800775:	83 f8 2f             	cmp    $0x2f,%eax
  800778:	77 24                	ja     80079e <vprintfmt+0xed>
  80077a:	89 c1                	mov    %eax,%ecx
  80077c:	48 03 4d c8          	add    -0x38(%rbp),%rcx
  800780:	83 c0 08             	add    $0x8,%eax
  800783:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800786:	44 8b 39             	mov    (%rcx),%r15d
        switch (ch = *ufmt++) {
  800789:	49 89 dc             	mov    %rbx,%r12
            if (width < 0) {
  80078c:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800790:	79 98                	jns    80072a <vprintfmt+0x79>
                width = precision;
  800792:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
                precision = -1;
  800796:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  80079c:	eb 8c                	jmp    80072a <vprintfmt+0x79>
            precision = va_arg(aq, int);
  80079e:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8007a2:	48 8d 41 08          	lea    0x8(%rcx),%rax
  8007a6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007aa:	eb da                	jmp    800786 <vprintfmt+0xd5>
                precision = precision * 10 + ch - '0';
  8007ac:	44 0f b6 7d a0       	movzbl -0x60(%rbp),%r15d
  8007b1:	41 83 ef 30          	sub    $0x30,%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  8007b5:	41 0f b6 44 24 01    	movzbl 0x1(%r12),%eax
  8007bb:	3c 39                	cmp    $0x39,%al
  8007bd:	77 1c                	ja     8007db <vprintfmt+0x12a>
            for (precision = 0;; ++ufmt) {
  8007bf:	48 83 c3 01          	add    $0x1,%rbx
                precision = precision * 10 + ch - '0';
  8007c3:	43 8d 0c bf          	lea    (%r15,%r15,4),%ecx
  8007c7:	0f b6 c0             	movzbl %al,%eax
  8007ca:	44 8d 7c 48 d0       	lea    -0x30(%rax,%rcx,2),%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  8007cf:	0f b6 03             	movzbl (%rbx),%eax
  8007d2:	3c 39                	cmp    $0x39,%al
  8007d4:	76 e9                	jbe    8007bf <vprintfmt+0x10e>
        process_precision:
  8007d6:	49 89 dc             	mov    %rbx,%r12
  8007d9:	eb b1                	jmp    80078c <vprintfmt+0xdb>
        switch (ch = *ufmt++) {
  8007db:	49 89 dc             	mov    %rbx,%r12
  8007de:	eb ac                	jmp    80078c <vprintfmt+0xdb>
            width = MAX(0, width);
  8007e0:	8b 4d ac             	mov    -0x54(%rbp),%ecx
  8007e3:	85 c9                	test   %ecx,%ecx
  8007e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8007ea:	0f 49 c1             	cmovns %ecx,%eax
  8007ed:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  8007f0:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  8007f3:	e9 32 ff ff ff       	jmp    80072a <vprintfmt+0x79>
            lflag++;
  8007f8:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  8007fb:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  8007fe:	e9 27 ff ff ff       	jmp    80072a <vprintfmt+0x79>
            putch(va_arg(aq, int), put_arg);
  800803:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800806:	83 f8 2f             	cmp    $0x2f,%eax
  800809:	77 19                	ja     800824 <vprintfmt+0x173>
  80080b:	89 c2                	mov    %eax,%edx
  80080d:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800811:	83 c0 08             	add    $0x8,%eax
  800814:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800817:	8b 3a                	mov    (%rdx),%edi
  800819:	4c 89 ee             	mov    %r13,%rsi
  80081c:	41 ff d6             	call   *%r14
            break;
  80081f:	e9 c2 fe ff ff       	jmp    8006e6 <vprintfmt+0x35>
            putch(va_arg(aq, int), put_arg);
  800824:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800828:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80082c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800830:	eb e5                	jmp    800817 <vprintfmt+0x166>
            int err = va_arg(aq, int);
  800832:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800835:	83 f8 2f             	cmp    $0x2f,%eax
  800838:	77 5a                	ja     800894 <vprintfmt+0x1e3>
  80083a:	89 c2                	mov    %eax,%edx
  80083c:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800840:	83 c0 08             	add    $0x8,%eax
  800843:	89 45 b8             	mov    %eax,-0x48(%rbp)
            if (err < 0) err = -err;
  800846:	8b 02                	mov    (%rdx),%eax
  800848:	89 c1                	mov    %eax,%ecx
  80084a:	f7 d9                	neg    %ecx
  80084c:	0f 48 c8             	cmovs  %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  80084f:	83 f9 13             	cmp    $0x13,%ecx
  800852:	7f 4e                	jg     8008a2 <vprintfmt+0x1f1>
  800854:	48 63 c1             	movslq %ecx,%rax
  800857:	48 ba e0 36 80 00 00 	movabs $0x8036e0,%rdx
  80085e:	00 00 00 
  800861:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  800865:	48 85 c0             	test   %rax,%rax
  800868:	74 38                	je     8008a2 <vprintfmt+0x1f1>
                printfmt(putch, put_arg, "%s", strerr);
  80086a:	48 89 c1             	mov    %rax,%rcx
  80086d:	48 ba b9 32 80 00 00 	movabs $0x8032b9,%rdx
  800874:	00 00 00 
  800877:	4c 89 ee             	mov    %r13,%rsi
  80087a:	4c 89 f7             	mov    %r14,%rdi
  80087d:	b8 00 00 00 00       	mov    $0x0,%eax
  800882:	49 b8 70 06 80 00 00 	movabs $0x800670,%r8
  800889:	00 00 00 
  80088c:	41 ff d0             	call   *%r8
  80088f:	e9 52 fe ff ff       	jmp    8006e6 <vprintfmt+0x35>
            int err = va_arg(aq, int);
  800894:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800898:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80089c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008a0:	eb a4                	jmp    800846 <vprintfmt+0x195>
                printfmt(putch, put_arg, "error %d", err);
  8008a2:	48 ba dd 30 80 00 00 	movabs $0x8030dd,%rdx
  8008a9:	00 00 00 
  8008ac:	4c 89 ee             	mov    %r13,%rsi
  8008af:	4c 89 f7             	mov    %r14,%rdi
  8008b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8008b7:	49 b8 70 06 80 00 00 	movabs $0x800670,%r8
  8008be:	00 00 00 
  8008c1:	41 ff d0             	call   *%r8
  8008c4:	e9 1d fe ff ff       	jmp    8006e6 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  8008c9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008cc:	83 f8 2f             	cmp    $0x2f,%eax
  8008cf:	77 6c                	ja     80093d <vprintfmt+0x28c>
  8008d1:	89 c2                	mov    %eax,%edx
  8008d3:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8008d7:	83 c0 08             	add    $0x8,%eax
  8008da:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008dd:	48 8b 12             	mov    (%rdx),%rdx
            if (!ptr) ptr = "(null)";
  8008e0:	48 85 d2             	test   %rdx,%rdx
  8008e3:	48 b8 d6 30 80 00 00 	movabs $0x8030d6,%rax
  8008ea:	00 00 00 
  8008ed:	48 0f 45 c2          	cmovne %rdx,%rax
  8008f1:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
            if (width > 0 && padc != '-') {
  8008f5:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8008f9:	7e 06                	jle    800901 <vprintfmt+0x250>
  8008fb:	80 7d aa 2d          	cmpb   $0x2d,-0x56(%rbp)
  8008ff:	75 4a                	jne    80094b <vprintfmt+0x29a>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800901:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800905:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800909:	0f b6 00             	movzbl (%rax),%eax
  80090c:	84 c0                	test   %al,%al
  80090e:	0f 85 9a 00 00 00    	jne    8009ae <vprintfmt+0x2fd>
            while (width-- > 0) putch(' ', put_arg);
  800914:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800917:	44 8d 60 ff          	lea    -0x1(%rax),%r12d
  80091b:	85 c0                	test   %eax,%eax
  80091d:	0f 8e c3 fd ff ff    	jle    8006e6 <vprintfmt+0x35>
  800923:	4c 89 ee             	mov    %r13,%rsi
  800926:	bf 20 00 00 00       	mov    $0x20,%edi
  80092b:	41 ff d6             	call   *%r14
  80092e:	41 83 ec 01          	sub    $0x1,%r12d
  800932:	41 83 fc ff          	cmp    $0xffffffff,%r12d
  800936:	75 eb                	jne    800923 <vprintfmt+0x272>
  800938:	e9 a9 fd ff ff       	jmp    8006e6 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  80093d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800941:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800945:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800949:	eb 92                	jmp    8008dd <vprintfmt+0x22c>
                width -= strnlen(ptr, precision);
  80094b:	49 63 f7             	movslq %r15d,%rsi
  80094e:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  800952:	48 b8 74 0e 80 00 00 	movabs $0x800e74,%rax
  800959:	00 00 00 
  80095c:	ff d0                	call   *%rax
  80095e:	48 89 c2             	mov    %rax,%rdx
  800961:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800964:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  800966:	8d 70 ff             	lea    -0x1(%rax),%esi
  800969:	89 75 ac             	mov    %esi,-0x54(%rbp)
  80096c:	85 c0                	test   %eax,%eax
  80096e:	7e 91                	jle    800901 <vprintfmt+0x250>
  800970:	44 0f be 65 aa       	movsbl -0x56(%rbp),%r12d
  800975:	4c 89 ee             	mov    %r13,%rsi
  800978:	44 89 e7             	mov    %r12d,%edi
  80097b:	41 ff d6             	call   *%r14
  80097e:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  800982:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800985:	83 f8 ff             	cmp    $0xffffffff,%eax
  800988:	75 eb                	jne    800975 <vprintfmt+0x2c4>
  80098a:	e9 72 ff ff ff       	jmp    800901 <vprintfmt+0x250>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  80098f:	0f b6 f8             	movzbl %al,%edi
  800992:	4c 89 ee             	mov    %r13,%rsi
  800995:	41 ff d6             	call   *%r14
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800998:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  80099c:	49 83 c4 01          	add    $0x1,%r12
  8009a0:	41 0f b6 44 24 ff    	movzbl -0x1(%r12),%eax
  8009a6:	84 c0                	test   %al,%al
  8009a8:	0f 84 66 ff ff ff    	je     800914 <vprintfmt+0x263>
  8009ae:	45 85 ff             	test   %r15d,%r15d
  8009b1:	78 0a                	js     8009bd <vprintfmt+0x30c>
  8009b3:	41 83 ef 01          	sub    $0x1,%r15d
  8009b7:	0f 88 57 ff ff ff    	js     800914 <vprintfmt+0x263>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  8009bd:	80 7d ab 00          	cmpb   $0x0,-0x55(%rbp)
  8009c1:	74 cc                	je     80098f <vprintfmt+0x2de>
  8009c3:	8d 50 e0             	lea    -0x20(%rax),%edx
  8009c6:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8009cb:	80 fa 5e             	cmp    $0x5e,%dl
  8009ce:	77 c2                	ja     800992 <vprintfmt+0x2e1>
  8009d0:	eb bd                	jmp    80098f <vprintfmt+0x2de>
    if (zflag) return va_arg(*ap, size_t);
  8009d2:	40 84 f6             	test   %sil,%sil
  8009d5:	75 26                	jne    8009fd <vprintfmt+0x34c>
    switch (lflag) {
  8009d7:	85 d2                	test   %edx,%edx
  8009d9:	74 59                	je     800a34 <vprintfmt+0x383>
  8009db:	83 fa 01             	cmp    $0x1,%edx
  8009de:	74 7b                	je     800a5b <vprintfmt+0x3aa>
        return va_arg(*ap, long long);
  8009e0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009e3:	83 f8 2f             	cmp    $0x2f,%eax
  8009e6:	0f 87 96 00 00 00    	ja     800a82 <vprintfmt+0x3d1>
  8009ec:	89 c2                	mov    %eax,%edx
  8009ee:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8009f2:	83 c0 08             	add    $0x8,%eax
  8009f5:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009f8:	4c 8b 22             	mov    (%rdx),%r12
  8009fb:	eb 17                	jmp    800a14 <vprintfmt+0x363>
    if (zflag) return va_arg(*ap, size_t);
  8009fd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a00:	83 f8 2f             	cmp    $0x2f,%eax
  800a03:	77 21                	ja     800a26 <vprintfmt+0x375>
  800a05:	89 c2                	mov    %eax,%edx
  800a07:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a0b:	83 c0 08             	add    $0x8,%eax
  800a0e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a11:	4c 8b 22             	mov    (%rdx),%r12
            if (i < 0) {
  800a14:	4d 85 e4             	test   %r12,%r12
  800a17:	78 7a                	js     800a93 <vprintfmt+0x3e2>
            num = i;
  800a19:	4c 89 e2             	mov    %r12,%rdx
        unsigned lflag = 0, base = 10;
  800a1c:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  800a21:	e9 50 02 00 00       	jmp    800c76 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800a26:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a2a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a2e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a32:	eb dd                	jmp    800a11 <vprintfmt+0x360>
        return va_arg(*ap, int);
  800a34:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a37:	83 f8 2f             	cmp    $0x2f,%eax
  800a3a:	77 11                	ja     800a4d <vprintfmt+0x39c>
  800a3c:	89 c2                	mov    %eax,%edx
  800a3e:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a42:	83 c0 08             	add    $0x8,%eax
  800a45:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a48:	4c 63 22             	movslq (%rdx),%r12
  800a4b:	eb c7                	jmp    800a14 <vprintfmt+0x363>
  800a4d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a51:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a55:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a59:	eb ed                	jmp    800a48 <vprintfmt+0x397>
        return va_arg(*ap, long);
  800a5b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a5e:	83 f8 2f             	cmp    $0x2f,%eax
  800a61:	77 11                	ja     800a74 <vprintfmt+0x3c3>
  800a63:	89 c2                	mov    %eax,%edx
  800a65:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a69:	83 c0 08             	add    $0x8,%eax
  800a6c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a6f:	4c 8b 22             	mov    (%rdx),%r12
  800a72:	eb a0                	jmp    800a14 <vprintfmt+0x363>
  800a74:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a78:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a7c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a80:	eb ed                	jmp    800a6f <vprintfmt+0x3be>
        return va_arg(*ap, long long);
  800a82:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a86:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a8a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a8e:	e9 65 ff ff ff       	jmp    8009f8 <vprintfmt+0x347>
                putch('-', put_arg);
  800a93:	4c 89 ee             	mov    %r13,%rsi
  800a96:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800a9b:	41 ff d6             	call   *%r14
                i = -i;
  800a9e:	49 f7 dc             	neg    %r12
  800aa1:	e9 73 ff ff ff       	jmp    800a19 <vprintfmt+0x368>
    if (zflag) return va_arg(*ap, size_t);
  800aa6:	40 84 f6             	test   %sil,%sil
  800aa9:	75 32                	jne    800add <vprintfmt+0x42c>
    switch (lflag) {
  800aab:	85 d2                	test   %edx,%edx
  800aad:	74 5d                	je     800b0c <vprintfmt+0x45b>
  800aaf:	83 fa 01             	cmp    $0x1,%edx
  800ab2:	0f 84 82 00 00 00    	je     800b3a <vprintfmt+0x489>
        return va_arg(*ap, unsigned long long);
  800ab8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800abb:	83 f8 2f             	cmp    $0x2f,%eax
  800abe:	0f 87 a5 00 00 00    	ja     800b69 <vprintfmt+0x4b8>
  800ac4:	89 c2                	mov    %eax,%edx
  800ac6:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800aca:	83 c0 08             	add    $0x8,%eax
  800acd:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ad0:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800ad3:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  800ad8:	e9 99 01 00 00       	jmp    800c76 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800add:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ae0:	83 f8 2f             	cmp    $0x2f,%eax
  800ae3:	77 19                	ja     800afe <vprintfmt+0x44d>
  800ae5:	89 c2                	mov    %eax,%edx
  800ae7:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800aeb:	83 c0 08             	add    $0x8,%eax
  800aee:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800af1:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800af4:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800af9:	e9 78 01 00 00       	jmp    800c76 <vprintfmt+0x5c5>
  800afe:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b02:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b06:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b0a:	eb e5                	jmp    800af1 <vprintfmt+0x440>
        return va_arg(*ap, unsigned int);
  800b0c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b0f:	83 f8 2f             	cmp    $0x2f,%eax
  800b12:	77 18                	ja     800b2c <vprintfmt+0x47b>
  800b14:	89 c2                	mov    %eax,%edx
  800b16:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b1a:	83 c0 08             	add    $0x8,%eax
  800b1d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b20:	8b 12                	mov    (%rdx),%edx
        unsigned lflag = 0, base = 10;
  800b22:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  800b27:	e9 4a 01 00 00       	jmp    800c76 <vprintfmt+0x5c5>
  800b2c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b30:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b34:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b38:	eb e6                	jmp    800b20 <vprintfmt+0x46f>
        return va_arg(*ap, unsigned long);
  800b3a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b3d:	83 f8 2f             	cmp    $0x2f,%eax
  800b40:	77 19                	ja     800b5b <vprintfmt+0x4aa>
  800b42:	89 c2                	mov    %eax,%edx
  800b44:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b48:	83 c0 08             	add    $0x8,%eax
  800b4b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b4e:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800b51:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  800b56:	e9 1b 01 00 00       	jmp    800c76 <vprintfmt+0x5c5>
  800b5b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b5f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b63:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b67:	eb e5                	jmp    800b4e <vprintfmt+0x49d>
        return va_arg(*ap, unsigned long long);
  800b69:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b6d:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b71:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b75:	e9 56 ff ff ff       	jmp    800ad0 <vprintfmt+0x41f>
    if (zflag) return va_arg(*ap, size_t);
  800b7a:	40 84 f6             	test   %sil,%sil
  800b7d:	75 2e                	jne    800bad <vprintfmt+0x4fc>
    switch (lflag) {
  800b7f:	85 d2                	test   %edx,%edx
  800b81:	74 59                	je     800bdc <vprintfmt+0x52b>
  800b83:	83 fa 01             	cmp    $0x1,%edx
  800b86:	74 7f                	je     800c07 <vprintfmt+0x556>
        return va_arg(*ap, unsigned long long);
  800b88:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b8b:	83 f8 2f             	cmp    $0x2f,%eax
  800b8e:	0f 87 9f 00 00 00    	ja     800c33 <vprintfmt+0x582>
  800b94:	89 c2                	mov    %eax,%edx
  800b96:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b9a:	83 c0 08             	add    $0x8,%eax
  800b9d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ba0:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800ba3:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  800ba8:	e9 c9 00 00 00       	jmp    800c76 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800bad:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bb0:	83 f8 2f             	cmp    $0x2f,%eax
  800bb3:	77 19                	ja     800bce <vprintfmt+0x51d>
  800bb5:	89 c2                	mov    %eax,%edx
  800bb7:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800bbb:	83 c0 08             	add    $0x8,%eax
  800bbe:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800bc1:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800bc4:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800bc9:	e9 a8 00 00 00       	jmp    800c76 <vprintfmt+0x5c5>
  800bce:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bd2:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800bd6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800bda:	eb e5                	jmp    800bc1 <vprintfmt+0x510>
        return va_arg(*ap, unsigned int);
  800bdc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bdf:	83 f8 2f             	cmp    $0x2f,%eax
  800be2:	77 15                	ja     800bf9 <vprintfmt+0x548>
  800be4:	89 c2                	mov    %eax,%edx
  800be6:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800bea:	83 c0 08             	add    $0x8,%eax
  800bed:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800bf0:	8b 12                	mov    (%rdx),%edx
            base = 8;
  800bf2:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  800bf7:	eb 7d                	jmp    800c76 <vprintfmt+0x5c5>
  800bf9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bfd:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800c01:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c05:	eb e9                	jmp    800bf0 <vprintfmt+0x53f>
        return va_arg(*ap, unsigned long);
  800c07:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c0a:	83 f8 2f             	cmp    $0x2f,%eax
  800c0d:	77 16                	ja     800c25 <vprintfmt+0x574>
  800c0f:	89 c2                	mov    %eax,%edx
  800c11:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800c15:	83 c0 08             	add    $0x8,%eax
  800c18:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c1b:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800c1e:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  800c23:	eb 51                	jmp    800c76 <vprintfmt+0x5c5>
  800c25:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c29:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800c2d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c31:	eb e8                	jmp    800c1b <vprintfmt+0x56a>
        return va_arg(*ap, unsigned long long);
  800c33:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c37:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800c3b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c3f:	e9 5c ff ff ff       	jmp    800ba0 <vprintfmt+0x4ef>
            putch('0', put_arg);
  800c44:	4c 89 ee             	mov    %r13,%rsi
  800c47:	bf 30 00 00 00       	mov    $0x30,%edi
  800c4c:	41 ff d6             	call   *%r14
            putch('x', put_arg);
  800c4f:	4c 89 ee             	mov    %r13,%rsi
  800c52:	bf 78 00 00 00       	mov    $0x78,%edi
  800c57:	41 ff d6             	call   *%r14
            num = (uintptr_t)va_arg(aq, void *);
  800c5a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c5d:	83 f8 2f             	cmp    $0x2f,%eax
  800c60:	77 47                	ja     800ca9 <vprintfmt+0x5f8>
  800c62:	89 c2                	mov    %eax,%edx
  800c64:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800c68:	83 c0 08             	add    $0x8,%eax
  800c6b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c6e:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800c71:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  800c76:	48 83 ec 08          	sub    $0x8,%rsp
  800c7a:	80 7d a0 58          	cmpb   $0x58,-0x60(%rbp)
  800c7e:	0f 94 c0             	sete   %al
  800c81:	0f b6 c0             	movzbl %al,%eax
  800c84:	50                   	push   %rax
  800c85:	44 0f be 4d aa       	movsbl -0x56(%rbp),%r9d
  800c8a:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  800c8e:	4c 89 ee             	mov    %r13,%rsi
  800c91:	4c 89 f7             	mov    %r14,%rdi
  800c94:	48 b8 9a 05 80 00 00 	movabs $0x80059a,%rax
  800c9b:	00 00 00 
  800c9e:	ff d0                	call   *%rax
            break;
  800ca0:	48 83 c4 10          	add    $0x10,%rsp
  800ca4:	e9 3d fa ff ff       	jmp    8006e6 <vprintfmt+0x35>
            num = (uintptr_t)va_arg(aq, void *);
  800ca9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cad:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800cb1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800cb5:	eb b7                	jmp    800c6e <vprintfmt+0x5bd>
    if (zflag) return va_arg(*ap, size_t);
  800cb7:	40 84 f6             	test   %sil,%sil
  800cba:	75 2b                	jne    800ce7 <vprintfmt+0x636>
    switch (lflag) {
  800cbc:	85 d2                	test   %edx,%edx
  800cbe:	74 56                	je     800d16 <vprintfmt+0x665>
  800cc0:	83 fa 01             	cmp    $0x1,%edx
  800cc3:	74 7f                	je     800d44 <vprintfmt+0x693>
        return va_arg(*ap, unsigned long long);
  800cc5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cc8:	83 f8 2f             	cmp    $0x2f,%eax
  800ccb:	0f 87 a2 00 00 00    	ja     800d73 <vprintfmt+0x6c2>
  800cd1:	89 c2                	mov    %eax,%edx
  800cd3:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800cd7:	83 c0 08             	add    $0x8,%eax
  800cda:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800cdd:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800ce0:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800ce5:	eb 8f                	jmp    800c76 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800ce7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cea:	83 f8 2f             	cmp    $0x2f,%eax
  800ced:	77 19                	ja     800d08 <vprintfmt+0x657>
  800cef:	89 c2                	mov    %eax,%edx
  800cf1:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800cf5:	83 c0 08             	add    $0x8,%eax
  800cf8:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800cfb:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800cfe:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800d03:	e9 6e ff ff ff       	jmp    800c76 <vprintfmt+0x5c5>
  800d08:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d0c:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800d10:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800d14:	eb e5                	jmp    800cfb <vprintfmt+0x64a>
        return va_arg(*ap, unsigned int);
  800d16:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d19:	83 f8 2f             	cmp    $0x2f,%eax
  800d1c:	77 18                	ja     800d36 <vprintfmt+0x685>
  800d1e:	89 c2                	mov    %eax,%edx
  800d20:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800d24:	83 c0 08             	add    $0x8,%eax
  800d27:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800d2a:	8b 12                	mov    (%rdx),%edx
            base = 16;
  800d2c:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  800d31:	e9 40 ff ff ff       	jmp    800c76 <vprintfmt+0x5c5>
  800d36:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d3a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800d3e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800d42:	eb e6                	jmp    800d2a <vprintfmt+0x679>
        return va_arg(*ap, unsigned long);
  800d44:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d47:	83 f8 2f             	cmp    $0x2f,%eax
  800d4a:	77 19                	ja     800d65 <vprintfmt+0x6b4>
  800d4c:	89 c2                	mov    %eax,%edx
  800d4e:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800d52:	83 c0 08             	add    $0x8,%eax
  800d55:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800d58:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800d5b:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800d60:	e9 11 ff ff ff       	jmp    800c76 <vprintfmt+0x5c5>
  800d65:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d69:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800d6d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800d71:	eb e5                	jmp    800d58 <vprintfmt+0x6a7>
        return va_arg(*ap, unsigned long long);
  800d73:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d77:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800d7b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800d7f:	e9 59 ff ff ff       	jmp    800cdd <vprintfmt+0x62c>
            putch(ch, put_arg);
  800d84:	4c 89 ee             	mov    %r13,%rsi
  800d87:	bf 25 00 00 00       	mov    $0x25,%edi
  800d8c:	41 ff d6             	call   *%r14
            break;
  800d8f:	e9 52 f9 ff ff       	jmp    8006e6 <vprintfmt+0x35>
            putch('%', put_arg);
  800d94:	4c 89 ee             	mov    %r13,%rsi
  800d97:	bf 25 00 00 00       	mov    $0x25,%edi
  800d9c:	41 ff d6             	call   *%r14
            while ((--ufmt)[-1] != '%') /* nothing */
  800d9f:	48 83 eb 01          	sub    $0x1,%rbx
  800da3:	80 7b ff 25          	cmpb   $0x25,-0x1(%rbx)
  800da7:	75 f6                	jne    800d9f <vprintfmt+0x6ee>
  800da9:	e9 38 f9 ff ff       	jmp    8006e6 <vprintfmt+0x35>
}
  800dae:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800db2:	5b                   	pop    %rbx
  800db3:	41 5c                	pop    %r12
  800db5:	41 5d                	pop    %r13
  800db7:	41 5e                	pop    %r14
  800db9:	41 5f                	pop    %r15
  800dbb:	5d                   	pop    %rbp
  800dbc:	c3                   	ret

0000000000800dbd <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800dbd:	f3 0f 1e fa          	endbr64
  800dc1:	55                   	push   %rbp
  800dc2:	48 89 e5             	mov    %rsp,%rbp
  800dc5:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800dc9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800dcd:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800dd2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800dd6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800ddd:	48 85 ff             	test   %rdi,%rdi
  800de0:	74 2b                	je     800e0d <vsnprintf+0x50>
  800de2:	48 85 f6             	test   %rsi,%rsi
  800de5:	74 26                	je     800e0d <vsnprintf+0x50>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800de7:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800deb:	48 bf 54 06 80 00 00 	movabs $0x800654,%rdi
  800df2:	00 00 00 
  800df5:	48 b8 b1 06 80 00 00 	movabs $0x8006b1,%rax
  800dfc:	00 00 00 
  800dff:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800e01:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e05:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800e08:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800e0b:	c9                   	leave
  800e0c:	c3                   	ret
    if (!buf || n < 1) return -E_INVAL;
  800e0d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e12:	eb f7                	jmp    800e0b <vsnprintf+0x4e>

0000000000800e14 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800e14:	f3 0f 1e fa          	endbr64
  800e18:	55                   	push   %rbp
  800e19:	48 89 e5             	mov    %rsp,%rbp
  800e1c:	48 83 ec 50          	sub    $0x50,%rsp
  800e20:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800e24:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800e28:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800e2c:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800e33:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e37:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800e3b:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800e3f:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800e43:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800e47:	48 b8 bd 0d 80 00 00 	movabs $0x800dbd,%rax
  800e4e:	00 00 00 
  800e51:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800e53:	c9                   	leave
  800e54:	c3                   	ret

0000000000800e55 <strlen>:
 * Primespipe runs 3x faster this way */

#define ASM 1

size_t
strlen(const char *s) {
  800e55:	f3 0f 1e fa          	endbr64
    size_t n = 0;
    while (*s++) n++;
  800e59:	80 3f 00             	cmpb   $0x0,(%rdi)
  800e5c:	74 10                	je     800e6e <strlen+0x19>
    size_t n = 0;
  800e5e:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800e63:	48 83 c0 01          	add    $0x1,%rax
  800e67:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800e6b:	75 f6                	jne    800e63 <strlen+0xe>
  800e6d:	c3                   	ret
    size_t n = 0;
  800e6e:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800e73:	c3                   	ret

0000000000800e74 <strnlen>:

size_t
strnlen(const char *s, size_t size) {
  800e74:	f3 0f 1e fa          	endbr64
  800e78:	48 89 f0             	mov    %rsi,%rax
    size_t n = 0;
  800e7b:	ba 00 00 00 00       	mov    $0x0,%edx
    while (n < size && *s++) n++;
  800e80:	48 85 f6             	test   %rsi,%rsi
  800e83:	74 10                	je     800e95 <strnlen+0x21>
  800e85:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  800e89:	74 0b                	je     800e96 <strnlen+0x22>
  800e8b:	48 83 c2 01          	add    $0x1,%rdx
  800e8f:	48 39 d0             	cmp    %rdx,%rax
  800e92:	75 f1                	jne    800e85 <strnlen+0x11>
  800e94:	c3                   	ret
  800e95:	c3                   	ret
  800e96:	48 89 d0             	mov    %rdx,%rax
    return n;
}
  800e99:	c3                   	ret

0000000000800e9a <strcpy>:

char *
strcpy(char *dst, const char *src) {
  800e9a:	f3 0f 1e fa          	endbr64
  800e9e:	48 89 f8             	mov    %rdi,%rax
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800ea1:	ba 00 00 00 00       	mov    $0x0,%edx
  800ea6:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  800eaa:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  800ead:	48 83 c2 01          	add    $0x1,%rdx
  800eb1:	84 c9                	test   %cl,%cl
  800eb3:	75 f1                	jne    800ea6 <strcpy+0xc>
        ;
    return res;
}
  800eb5:	c3                   	ret

0000000000800eb6 <strcat>:

char *
strcat(char *dst, const char *src) {
  800eb6:	f3 0f 1e fa          	endbr64
  800eba:	55                   	push   %rbp
  800ebb:	48 89 e5             	mov    %rsp,%rbp
  800ebe:	41 54                	push   %r12
  800ec0:	53                   	push   %rbx
  800ec1:	48 89 fb             	mov    %rdi,%rbx
  800ec4:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800ec7:	48 b8 55 0e 80 00 00 	movabs $0x800e55,%rax
  800ece:	00 00 00 
  800ed1:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800ed3:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800ed7:	4c 89 e6             	mov    %r12,%rsi
  800eda:	48 b8 9a 0e 80 00 00 	movabs $0x800e9a,%rax
  800ee1:	00 00 00 
  800ee4:	ff d0                	call   *%rax
    return dst;
}
  800ee6:	48 89 d8             	mov    %rbx,%rax
  800ee9:	5b                   	pop    %rbx
  800eea:	41 5c                	pop    %r12
  800eec:	5d                   	pop    %rbp
  800eed:	c3                   	ret

0000000000800eee <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800eee:	f3 0f 1e fa          	endbr64
  800ef2:	48 89 f8             	mov    %rdi,%rax
    char *ret = dst;
    while (size-- > 0) {
  800ef5:	48 85 d2             	test   %rdx,%rdx
  800ef8:	74 1f                	je     800f19 <strncpy+0x2b>
  800efa:	48 01 fa             	add    %rdi,%rdx
  800efd:	48 89 f9             	mov    %rdi,%rcx
        *dst++ = *src;
  800f00:	48 83 c1 01          	add    $0x1,%rcx
  800f04:	44 0f b6 06          	movzbl (%rsi),%r8d
  800f08:	44 88 41 ff          	mov    %r8b,-0x1(%rcx)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800f0c:	41 80 f8 01          	cmp    $0x1,%r8b
  800f10:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800f14:	48 39 ca             	cmp    %rcx,%rdx
  800f17:	75 e7                	jne    800f00 <strncpy+0x12>
    }
    return ret;
}
  800f19:	c3                   	ret

0000000000800f1a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
  800f1a:	f3 0f 1e fa          	endbr64
    char *dst_in = dst;
    if (size) {
  800f1e:	48 89 f8             	mov    %rdi,%rax
  800f21:	48 85 d2             	test   %rdx,%rdx
  800f24:	74 24                	je     800f4a <strlcpy+0x30>
        while (--size > 0 && *src)
  800f26:	48 83 ea 01          	sub    $0x1,%rdx
  800f2a:	74 1b                	je     800f47 <strlcpy+0x2d>
  800f2c:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800f30:	0f b6 16             	movzbl (%rsi),%edx
  800f33:	84 d2                	test   %dl,%dl
  800f35:	74 10                	je     800f47 <strlcpy+0x2d>
            *dst++ = *src++;
  800f37:	48 83 c6 01          	add    $0x1,%rsi
  800f3b:	48 83 c0 01          	add    $0x1,%rax
  800f3f:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800f42:	48 39 c8             	cmp    %rcx,%rax
  800f45:	75 e9                	jne    800f30 <strlcpy+0x16>
        *dst = '\0';
  800f47:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800f4a:	48 29 f8             	sub    %rdi,%rax
}
  800f4d:	c3                   	ret

0000000000800f4e <strcmp>:
    }
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
  800f4e:	f3 0f 1e fa          	endbr64
    while (*p && *p == *q) p++, q++;
  800f52:	0f b6 07             	movzbl (%rdi),%eax
  800f55:	84 c0                	test   %al,%al
  800f57:	74 13                	je     800f6c <strcmp+0x1e>
  800f59:	38 06                	cmp    %al,(%rsi)
  800f5b:	75 0f                	jne    800f6c <strcmp+0x1e>
  800f5d:	48 83 c7 01          	add    $0x1,%rdi
  800f61:	48 83 c6 01          	add    $0x1,%rsi
  800f65:	0f b6 07             	movzbl (%rdi),%eax
  800f68:	84 c0                	test   %al,%al
  800f6a:	75 ed                	jne    800f59 <strcmp+0xb>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800f6c:	0f b6 c0             	movzbl %al,%eax
  800f6f:	0f b6 16             	movzbl (%rsi),%edx
  800f72:	29 d0                	sub    %edx,%eax
}
  800f74:	c3                   	ret

0000000000800f75 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
  800f75:	f3 0f 1e fa          	endbr64
    while (n && *p && *p == *q) n--, p++, q++;
  800f79:	48 85 d2             	test   %rdx,%rdx
  800f7c:	74 1f                	je     800f9d <strncmp+0x28>
  800f7e:	0f b6 07             	movzbl (%rdi),%eax
  800f81:	84 c0                	test   %al,%al
  800f83:	74 1e                	je     800fa3 <strncmp+0x2e>
  800f85:	3a 06                	cmp    (%rsi),%al
  800f87:	75 1a                	jne    800fa3 <strncmp+0x2e>
  800f89:	48 83 c7 01          	add    $0x1,%rdi
  800f8d:	48 83 c6 01          	add    $0x1,%rsi
  800f91:	48 83 ea 01          	sub    $0x1,%rdx
  800f95:	75 e7                	jne    800f7e <strncmp+0x9>

    if (!n) return 0;
  800f97:	b8 00 00 00 00       	mov    $0x0,%eax
  800f9c:	c3                   	ret
  800f9d:	b8 00 00 00 00       	mov    $0x0,%eax
  800fa2:	c3                   	ret

    return (int)((unsigned char)*p - (unsigned char)*q);
  800fa3:	0f b6 07             	movzbl (%rdi),%eax
  800fa6:	0f b6 16             	movzbl (%rsi),%edx
  800fa9:	29 d0                	sub    %edx,%eax
}
  800fab:	c3                   	ret

0000000000800fac <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
  800fac:	f3 0f 1e fa          	endbr64
    for (; *str; str++) {
  800fb0:	0f b6 17             	movzbl (%rdi),%edx
  800fb3:	84 d2                	test   %dl,%dl
  800fb5:	74 18                	je     800fcf <strchr+0x23>
        if (*str == c) {
  800fb7:	0f be d2             	movsbl %dl,%edx
  800fba:	39 f2                	cmp    %esi,%edx
  800fbc:	74 17                	je     800fd5 <strchr+0x29>
    for (; *str; str++) {
  800fbe:	48 83 c7 01          	add    $0x1,%rdi
  800fc2:	0f b6 17             	movzbl (%rdi),%edx
  800fc5:	84 d2                	test   %dl,%dl
  800fc7:	75 ee                	jne    800fb7 <strchr+0xb>
            return (char *)str;
        }
    }
    return NULL;
  800fc9:	b8 00 00 00 00       	mov    $0x0,%eax
  800fce:	c3                   	ret
  800fcf:	b8 00 00 00 00       	mov    $0x0,%eax
  800fd4:	c3                   	ret
            return (char *)str;
  800fd5:	48 89 f8             	mov    %rdi,%rax
}
  800fd8:	c3                   	ret

0000000000800fd9 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
  800fd9:	f3 0f 1e fa          	endbr64
  800fdd:	48 89 f8             	mov    %rdi,%rax
    for (; *str && *str != ch; str++) /* nothing */
  800fe0:	0f b6 17             	movzbl (%rdi),%edx
  800fe3:	84 d2                	test   %dl,%dl
  800fe5:	74 13                	je     800ffa <strfind+0x21>
  800fe7:	0f be d2             	movsbl %dl,%edx
  800fea:	39 f2                	cmp    %esi,%edx
  800fec:	74 0b                	je     800ff9 <strfind+0x20>
  800fee:	48 83 c0 01          	add    $0x1,%rax
  800ff2:	0f b6 10             	movzbl (%rax),%edx
  800ff5:	84 d2                	test   %dl,%dl
  800ff7:	75 ee                	jne    800fe7 <strfind+0xe>
        ;
    return (char *)str;
}
  800ff9:	c3                   	ret
  800ffa:	c3                   	ret

0000000000800ffb <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  800ffb:	f3 0f 1e fa          	endbr64
  800fff:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  801002:	48 89 f8             	mov    %rdi,%rax
  801005:	48 f7 d8             	neg    %rax
  801008:	83 e0 07             	and    $0x7,%eax
  80100b:	49 89 d1             	mov    %rdx,%r9
  80100e:	49 29 c1             	sub    %rax,%r9
  801011:	78 36                	js     801049 <memset+0x4e>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  801013:	40 0f b6 c6          	movzbl %sil,%eax
  801017:	48 b9 01 01 01 01 01 	movabs $0x101010101010101,%rcx
  80101e:	01 01 01 
  801021:	48 0f af c1          	imul   %rcx,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  801025:	40 f6 c7 07          	test   $0x7,%dil
  801029:	75 38                	jne    801063 <memset+0x68>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  80102b:	4c 89 c9             	mov    %r9,%rcx
  80102e:	48 c1 f9 03          	sar    $0x3,%rcx
  801032:	74 0c                	je     801040 <memset+0x45>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  801034:	fc                   	cld
  801035:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  801038:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  80103c:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  801040:	4d 85 c9             	test   %r9,%r9
  801043:	75 45                	jne    80108a <memset+0x8f>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  801045:	4c 89 c0             	mov    %r8,%rax
  801048:	c3                   	ret
        while (n-- > 0) *ptr++ = c;
  801049:	48 85 d2             	test   %rdx,%rdx
  80104c:	74 f7                	je     801045 <memset+0x4a>
  80104e:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  801051:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  801054:	48 83 c0 01          	add    $0x1,%rax
  801058:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  80105c:	48 39 c2             	cmp    %rax,%rdx
  80105f:	75 f3                	jne    801054 <memset+0x59>
  801061:	eb e2                	jmp    801045 <memset+0x4a>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  801063:	40 f6 c7 01          	test   $0x1,%dil
  801067:	74 06                	je     80106f <memset+0x74>
  801069:	88 07                	mov    %al,(%rdi)
  80106b:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  80106f:	40 f6 c7 02          	test   $0x2,%dil
  801073:	74 07                	je     80107c <memset+0x81>
  801075:	66 89 07             	mov    %ax,(%rdi)
  801078:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  80107c:	40 f6 c7 04          	test   $0x4,%dil
  801080:	74 a9                	je     80102b <memset+0x30>
  801082:	89 07                	mov    %eax,(%rdi)
  801084:	48 83 c7 04          	add    $0x4,%rdi
  801088:	eb a1                	jmp    80102b <memset+0x30>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  80108a:	41 f6 c1 04          	test   $0x4,%r9b
  80108e:	74 1b                	je     8010ab <memset+0xb0>
  801090:	89 07                	mov    %eax,(%rdi)
  801092:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  801096:	41 f6 c1 02          	test   $0x2,%r9b
  80109a:	74 07                	je     8010a3 <memset+0xa8>
  80109c:	66 89 07             	mov    %ax,(%rdi)
  80109f:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  8010a3:	41 f6 c1 01          	test   $0x1,%r9b
  8010a7:	74 9c                	je     801045 <memset+0x4a>
  8010a9:	eb 06                	jmp    8010b1 <memset+0xb6>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  8010ab:	41 f6 c1 02          	test   $0x2,%r9b
  8010af:	75 eb                	jne    80109c <memset+0xa1>
        if (ni & 1) *ptr = k;
  8010b1:	88 07                	mov    %al,(%rdi)
  8010b3:	eb 90                	jmp    801045 <memset+0x4a>

00000000008010b5 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  8010b5:	f3 0f 1e fa          	endbr64
  8010b9:	48 89 f8             	mov    %rdi,%rax
  8010bc:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  8010bf:	48 39 fe             	cmp    %rdi,%rsi
  8010c2:	73 3b                	jae    8010ff <memmove+0x4a>
  8010c4:	48 8d 14 16          	lea    (%rsi,%rdx,1),%rdx
  8010c8:	48 39 d7             	cmp    %rdx,%rdi
  8010cb:	73 32                	jae    8010ff <memmove+0x4a>
        s += n;
        d += n;
  8010cd:	48 8d 3c 0f          	lea    (%rdi,%rcx,1),%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  8010d1:	48 89 d6             	mov    %rdx,%rsi
  8010d4:	48 09 fe             	or     %rdi,%rsi
  8010d7:	48 09 ce             	or     %rcx,%rsi
  8010da:	40 f6 c6 07          	test   $0x7,%sil
  8010de:	75 12                	jne    8010f2 <memmove+0x3d>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  8010e0:	48 83 ef 08          	sub    $0x8,%rdi
  8010e4:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  8010e8:	48 c1 e9 03          	shr    $0x3,%rcx
  8010ec:	fd                   	std
  8010ed:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  8010f0:	fc                   	cld
  8010f1:	c3                   	ret
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  8010f2:	48 83 ef 01          	sub    $0x1,%rdi
  8010f6:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  8010fa:	fd                   	std
  8010fb:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  8010fd:	eb f1                	jmp    8010f0 <memmove+0x3b>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  8010ff:	48 89 f2             	mov    %rsi,%rdx
  801102:	48 09 c2             	or     %rax,%rdx
  801105:	48 09 ca             	or     %rcx,%rdx
  801108:	f6 c2 07             	test   $0x7,%dl
  80110b:	75 0c                	jne    801119 <memmove+0x64>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  80110d:	48 c1 e9 03          	shr    $0x3,%rcx
  801111:	48 89 c7             	mov    %rax,%rdi
  801114:	fc                   	cld
  801115:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  801118:	c3                   	ret
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  801119:	48 89 c7             	mov    %rax,%rdi
  80111c:	fc                   	cld
  80111d:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  80111f:	c3                   	ret

0000000000801120 <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  801120:	f3 0f 1e fa          	endbr64
  801124:	55                   	push   %rbp
  801125:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  801128:	48 b8 b5 10 80 00 00 	movabs $0x8010b5,%rax
  80112f:	00 00 00 
  801132:	ff d0                	call   *%rax
}
  801134:	5d                   	pop    %rbp
  801135:	c3                   	ret

0000000000801136 <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  801136:	f3 0f 1e fa          	endbr64
  80113a:	55                   	push   %rbp
  80113b:	48 89 e5             	mov    %rsp,%rbp
  80113e:	41 57                	push   %r15
  801140:	41 56                	push   %r14
  801142:	41 55                	push   %r13
  801144:	41 54                	push   %r12
  801146:	53                   	push   %rbx
  801147:	48 83 ec 08          	sub    $0x8,%rsp
  80114b:	49 89 fe             	mov    %rdi,%r14
  80114e:	49 89 f7             	mov    %rsi,%r15
  801151:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  801154:	48 89 f7             	mov    %rsi,%rdi
  801157:	48 b8 55 0e 80 00 00 	movabs $0x800e55,%rax
  80115e:	00 00 00 
  801161:	ff d0                	call   *%rax
  801163:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  801166:	48 89 de             	mov    %rbx,%rsi
  801169:	4c 89 f7             	mov    %r14,%rdi
  80116c:	48 b8 74 0e 80 00 00 	movabs $0x800e74,%rax
  801173:	00 00 00 
  801176:	ff d0                	call   *%rax
  801178:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  80117b:	48 39 c3             	cmp    %rax,%rbx
  80117e:	74 36                	je     8011b6 <strlcat+0x80>
    if (srclen < maxlen - dstlen) {
  801180:	48 89 d8             	mov    %rbx,%rax
  801183:	4c 29 e8             	sub    %r13,%rax
  801186:	49 39 c4             	cmp    %rax,%r12
  801189:	73 31                	jae    8011bc <strlcat+0x86>
        memcpy(dst + dstlen, src, srclen + 1);
  80118b:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  801190:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  801194:	4c 89 fe             	mov    %r15,%rsi
  801197:	48 b8 20 11 80 00 00 	movabs $0x801120,%rax
  80119e:	00 00 00 
  8011a1:	ff d0                	call   *%rax
    return dstlen + srclen;
  8011a3:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  8011a7:	48 83 c4 08          	add    $0x8,%rsp
  8011ab:	5b                   	pop    %rbx
  8011ac:	41 5c                	pop    %r12
  8011ae:	41 5d                	pop    %r13
  8011b0:	41 5e                	pop    %r14
  8011b2:	41 5f                	pop    %r15
  8011b4:	5d                   	pop    %rbp
  8011b5:	c3                   	ret
    if (dstlen == maxlen) return maxlen + srclen;
  8011b6:	49 8d 04 04          	lea    (%r12,%rax,1),%rax
  8011ba:	eb eb                	jmp    8011a7 <strlcat+0x71>
        memcpy(dst + dstlen, src, maxlen - 1);
  8011bc:	48 83 eb 01          	sub    $0x1,%rbx
  8011c0:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  8011c4:	48 89 da             	mov    %rbx,%rdx
  8011c7:	4c 89 fe             	mov    %r15,%rsi
  8011ca:	48 b8 20 11 80 00 00 	movabs $0x801120,%rax
  8011d1:	00 00 00 
  8011d4:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  8011d6:	49 01 de             	add    %rbx,%r14
  8011d9:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  8011de:	eb c3                	jmp    8011a3 <strlcat+0x6d>

00000000008011e0 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  8011e0:	f3 0f 1e fa          	endbr64
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  8011e4:	48 85 d2             	test   %rdx,%rdx
  8011e7:	74 2d                	je     801216 <memcmp+0x36>
  8011e9:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  8011ee:	0f b6 0c 07          	movzbl (%rdi,%rax,1),%ecx
  8011f2:	44 0f b6 04 06       	movzbl (%rsi,%rax,1),%r8d
  8011f7:	44 38 c1             	cmp    %r8b,%cl
  8011fa:	75 0f                	jne    80120b <memcmp+0x2b>
    while (n-- > 0) {
  8011fc:	48 83 c0 01          	add    $0x1,%rax
  801200:	48 39 c2             	cmp    %rax,%rdx
  801203:	75 e9                	jne    8011ee <memcmp+0xe>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  801205:	b8 00 00 00 00       	mov    $0x0,%eax
  80120a:	c3                   	ret
            return (int)*s1 - (int)*s2;
  80120b:	0f b6 c1             	movzbl %cl,%eax
  80120e:	45 0f b6 c0          	movzbl %r8b,%r8d
  801212:	44 29 c0             	sub    %r8d,%eax
  801215:	c3                   	ret
    return 0;
  801216:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80121b:	c3                   	ret

000000000080121c <memfind>:

void *
memfind(const void *src, int c, size_t n) {
  80121c:	f3 0f 1e fa          	endbr64
    const void *end = (const char *)src + n;
  801220:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  801224:	48 39 c7             	cmp    %rax,%rdi
  801227:	73 0f                	jae    801238 <memfind+0x1c>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  801229:	40 38 37             	cmp    %sil,(%rdi)
  80122c:	74 0e                	je     80123c <memfind+0x20>
    for (; src < end; src++) {
  80122e:	48 83 c7 01          	add    $0x1,%rdi
  801232:	48 39 f8             	cmp    %rdi,%rax
  801235:	75 f2                	jne    801229 <memfind+0xd>
  801237:	c3                   	ret
  801238:	48 89 f8             	mov    %rdi,%rax
  80123b:	c3                   	ret
  80123c:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  80123f:	c3                   	ret

0000000000801240 <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  801240:	f3 0f 1e fa          	endbr64
  801244:	49 89 f2             	mov    %rsi,%r10
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  801247:	0f b6 37             	movzbl (%rdi),%esi
  80124a:	40 80 fe 20          	cmp    $0x20,%sil
  80124e:	74 06                	je     801256 <strtol+0x16>
  801250:	40 80 fe 09          	cmp    $0x9,%sil
  801254:	75 13                	jne    801269 <strtol+0x29>
  801256:	48 83 c7 01          	add    $0x1,%rdi
  80125a:	0f b6 37             	movzbl (%rdi),%esi
  80125d:	40 80 fe 20          	cmp    $0x20,%sil
  801261:	74 f3                	je     801256 <strtol+0x16>
  801263:	40 80 fe 09          	cmp    $0x9,%sil
  801267:	74 ed                	je     801256 <strtol+0x16>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  801269:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  80126c:	83 e0 fd             	and    $0xfffffffd,%eax
  80126f:	3c 01                	cmp    $0x1,%al
  801271:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  801275:	f7 c2 ef ff ff ff    	test   $0xffffffef,%edx
  80127b:	75 0f                	jne    80128c <strtol+0x4c>
  80127d:	80 3f 30             	cmpb   $0x30,(%rdi)
  801280:	74 14                	je     801296 <strtol+0x56>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  801282:	85 d2                	test   %edx,%edx
  801284:	b8 0a 00 00 00       	mov    $0xa,%eax
  801289:	0f 44 d0             	cmove  %eax,%edx
    }

    /* Digits */
    long val = 0;
  80128c:	b8 00 00 00 00       	mov    $0x0,%eax
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  801291:	4c 63 ca             	movslq %edx,%r9
  801294:	eb 36                	jmp    8012cc <strtol+0x8c>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  801296:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  80129a:	74 0f                	je     8012ab <strtol+0x6b>
    } else if (!base && s[0] == '0') {
  80129c:	85 d2                	test   %edx,%edx
  80129e:	75 ec                	jne    80128c <strtol+0x4c>
        s++;
  8012a0:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  8012a4:	ba 08 00 00 00       	mov    $0x8,%edx
        s++;
  8012a9:	eb e1                	jmp    80128c <strtol+0x4c>
        s += 2;
  8012ab:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  8012af:	ba 10 00 00 00       	mov    $0x10,%edx
        s += 2;
  8012b4:	eb d6                	jmp    80128c <strtol+0x4c>
            dig -= '0';
  8012b6:	83 e9 30             	sub    $0x30,%ecx
        if (dig >= base) break;
  8012b9:	44 0f b6 c1          	movzbl %cl,%r8d
  8012bd:	41 39 d0             	cmp    %edx,%r8d
  8012c0:	7d 21                	jge    8012e3 <strtol+0xa3>
        val = val * base + dig;
  8012c2:	49 0f af c1          	imul   %r9,%rax
  8012c6:	0f b6 c9             	movzbl %cl,%ecx
  8012c9:	48 01 c8             	add    %rcx,%rax
        uint8_t dig = *s++;
  8012cc:	48 83 c7 01          	add    $0x1,%rdi
  8012d0:	0f b6 4f ff          	movzbl -0x1(%rdi),%ecx
        if (dig - '0' < 10)
  8012d4:	80 f9 39             	cmp    $0x39,%cl
  8012d7:	76 dd                	jbe    8012b6 <strtol+0x76>
        else if (dig - 'a' < 27)
  8012d9:	80 f9 7b             	cmp    $0x7b,%cl
  8012dc:	77 05                	ja     8012e3 <strtol+0xa3>
            dig -= 'a' - 10;
  8012de:	83 e9 57             	sub    $0x57,%ecx
  8012e1:	eb d6                	jmp    8012b9 <strtol+0x79>
    }

    if (endptr) *endptr = (char *)s;
  8012e3:	4d 85 d2             	test   %r10,%r10
  8012e6:	74 03                	je     8012eb <strtol+0xab>
  8012e8:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  8012eb:	48 89 c2             	mov    %rax,%rdx
  8012ee:	48 f7 da             	neg    %rdx
  8012f1:	40 80 fe 2d          	cmp    $0x2d,%sil
  8012f5:	48 0f 44 c2          	cmove  %rdx,%rax
}
  8012f9:	c3                   	ret

00000000008012fa <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  8012fa:	f3 0f 1e fa          	endbr64
  8012fe:	55                   	push   %rbp
  8012ff:	48 89 e5             	mov    %rsp,%rbp
  801302:	53                   	push   %rbx
  801303:	48 89 fa             	mov    %rdi,%rdx
  801306:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801309:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80130e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801313:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801318:	be 00 00 00 00       	mov    $0x0,%esi
  80131d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801323:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  801325:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801329:	c9                   	leave
  80132a:	c3                   	ret

000000000080132b <sys_cgetc>:

int
sys_cgetc(void) {
  80132b:	f3 0f 1e fa          	endbr64
  80132f:	55                   	push   %rbp
  801330:	48 89 e5             	mov    %rsp,%rbp
  801333:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801334:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801339:	ba 00 00 00 00       	mov    $0x0,%edx
  80133e:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801343:	bb 00 00 00 00       	mov    $0x0,%ebx
  801348:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80134d:	be 00 00 00 00       	mov    $0x0,%esi
  801352:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801358:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  80135a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80135e:	c9                   	leave
  80135f:	c3                   	ret

0000000000801360 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  801360:	f3 0f 1e fa          	endbr64
  801364:	55                   	push   %rbp
  801365:	48 89 e5             	mov    %rsp,%rbp
  801368:	53                   	push   %rbx
  801369:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  80136d:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801370:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801375:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80137a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80137f:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801384:	be 00 00 00 00       	mov    $0x0,%esi
  801389:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80138f:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801391:	48 85 c0             	test   %rax,%rax
  801394:	7f 06                	jg     80139c <sys_env_destroy+0x3c>
}
  801396:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80139a:	c9                   	leave
  80139b:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80139c:	49 89 c0             	mov    %rax,%r8
  80139f:	b9 03 00 00 00       	mov    $0x3,%ecx
  8013a4:	48 ba 80 33 80 00 00 	movabs $0x803380,%rdx
  8013ab:	00 00 00 
  8013ae:	be 26 00 00 00       	mov    $0x26,%esi
  8013b3:	48 bf 43 32 80 00 00 	movabs $0x803243,%rdi
  8013ba:	00 00 00 
  8013bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8013c2:	49 b9 f5 03 80 00 00 	movabs $0x8003f5,%r9
  8013c9:	00 00 00 
  8013cc:	41 ff d1             	call   *%r9

00000000008013cf <sys_getenvid>:

envid_t
sys_getenvid(void) {
  8013cf:	f3 0f 1e fa          	endbr64
  8013d3:	55                   	push   %rbp
  8013d4:	48 89 e5             	mov    %rsp,%rbp
  8013d7:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8013d8:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8013dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8013e2:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8013e7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013ec:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013f1:	be 00 00 00 00       	mov    $0x0,%esi
  8013f6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013fc:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  8013fe:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801402:	c9                   	leave
  801403:	c3                   	ret

0000000000801404 <sys_yield>:

void
sys_yield(void) {
  801404:	f3 0f 1e fa          	endbr64
  801408:	55                   	push   %rbp
  801409:	48 89 e5             	mov    %rsp,%rbp
  80140c:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80140d:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801412:	ba 00 00 00 00       	mov    $0x0,%edx
  801417:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80141c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801421:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801426:	be 00 00 00 00       	mov    $0x0,%esi
  80142b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801431:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  801433:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801437:	c9                   	leave
  801438:	c3                   	ret

0000000000801439 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  801439:	f3 0f 1e fa          	endbr64
  80143d:	55                   	push   %rbp
  80143e:	48 89 e5             	mov    %rsp,%rbp
  801441:	53                   	push   %rbx
  801442:	48 89 fa             	mov    %rdi,%rdx
  801445:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801448:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80144d:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  801454:	00 00 00 
  801457:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80145c:	be 00 00 00 00       	mov    $0x0,%esi
  801461:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801467:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  801469:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80146d:	c9                   	leave
  80146e:	c3                   	ret

000000000080146f <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  80146f:	f3 0f 1e fa          	endbr64
  801473:	55                   	push   %rbp
  801474:	48 89 e5             	mov    %rsp,%rbp
  801477:	53                   	push   %rbx
  801478:	49 89 f8             	mov    %rdi,%r8
  80147b:	48 89 d3             	mov    %rdx,%rbx
  80147e:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  801481:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801486:	4c 89 c2             	mov    %r8,%rdx
  801489:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80148c:	be 00 00 00 00       	mov    $0x0,%esi
  801491:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801497:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  801499:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80149d:	c9                   	leave
  80149e:	c3                   	ret

000000000080149f <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  80149f:	f3 0f 1e fa          	endbr64
  8014a3:	55                   	push   %rbp
  8014a4:	48 89 e5             	mov    %rsp,%rbp
  8014a7:	53                   	push   %rbx
  8014a8:	48 83 ec 08          	sub    $0x8,%rsp
  8014ac:	89 f8                	mov    %edi,%eax
  8014ae:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  8014b1:	48 63 f9             	movslq %ecx,%rdi
  8014b4:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8014b7:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8014bc:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8014bf:	be 00 00 00 00       	mov    $0x0,%esi
  8014c4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8014ca:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8014cc:	48 85 c0             	test   %rax,%rax
  8014cf:	7f 06                	jg     8014d7 <sys_alloc_region+0x38>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  8014d1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014d5:	c9                   	leave
  8014d6:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8014d7:	49 89 c0             	mov    %rax,%r8
  8014da:	b9 04 00 00 00       	mov    $0x4,%ecx
  8014df:	48 ba 80 33 80 00 00 	movabs $0x803380,%rdx
  8014e6:	00 00 00 
  8014e9:	be 26 00 00 00       	mov    $0x26,%esi
  8014ee:	48 bf 43 32 80 00 00 	movabs $0x803243,%rdi
  8014f5:	00 00 00 
  8014f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8014fd:	49 b9 f5 03 80 00 00 	movabs $0x8003f5,%r9
  801504:	00 00 00 
  801507:	41 ff d1             	call   *%r9

000000000080150a <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  80150a:	f3 0f 1e fa          	endbr64
  80150e:	55                   	push   %rbp
  80150f:	48 89 e5             	mov    %rsp,%rbp
  801512:	53                   	push   %rbx
  801513:	48 83 ec 08          	sub    $0x8,%rsp
  801517:	89 f8                	mov    %edi,%eax
  801519:	49 89 f2             	mov    %rsi,%r10
  80151c:	48 89 cf             	mov    %rcx,%rdi
  80151f:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  801522:	48 63 da             	movslq %edx,%rbx
  801525:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801528:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80152d:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801530:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  801533:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801535:	48 85 c0             	test   %rax,%rax
  801538:	7f 06                	jg     801540 <sys_map_region+0x36>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  80153a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80153e:	c9                   	leave
  80153f:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801540:	49 89 c0             	mov    %rax,%r8
  801543:	b9 05 00 00 00       	mov    $0x5,%ecx
  801548:	48 ba 80 33 80 00 00 	movabs $0x803380,%rdx
  80154f:	00 00 00 
  801552:	be 26 00 00 00       	mov    $0x26,%esi
  801557:	48 bf 43 32 80 00 00 	movabs $0x803243,%rdi
  80155e:	00 00 00 
  801561:	b8 00 00 00 00       	mov    $0x0,%eax
  801566:	49 b9 f5 03 80 00 00 	movabs $0x8003f5,%r9
  80156d:	00 00 00 
  801570:	41 ff d1             	call   *%r9

0000000000801573 <sys_map_physical_region>:

int
sys_map_physical_region(uintptr_t pa, envid_t dstenv, void *dstva, size_t size, int perm) {
  801573:	f3 0f 1e fa          	endbr64
  801577:	55                   	push   %rbp
  801578:	48 89 e5             	mov    %rsp,%rbp
  80157b:	53                   	push   %rbx
  80157c:	48 83 ec 08          	sub    $0x8,%rsp
  801580:	49 89 f9             	mov    %rdi,%r9
  801583:	89 f0                	mov    %esi,%eax
  801585:	48 89 d3             	mov    %rdx,%rbx
  801588:	48 89 cf             	mov    %rcx,%rdi
    int res = syscall(SYS_map_physical_region, 1, pa, dstenv, (uintptr_t)dstva, size, perm, 0);
  80158b:	49 63 f0             	movslq %r8d,%rsi
  80158e:	48 63 c8             	movslq %eax,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801591:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801596:	4c 89 ca             	mov    %r9,%rdx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801599:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80159f:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8015a1:	48 85 c0             	test   %rax,%rax
  8015a4:	7f 06                	jg     8015ac <sys_map_physical_region+0x39>
#ifdef SANITIZE_USER_SHADOW_BASE
    platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  8015a6:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8015aa:	c9                   	leave
  8015ab:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8015ac:	49 89 c0             	mov    %rax,%r8
  8015af:	b9 06 00 00 00       	mov    $0x6,%ecx
  8015b4:	48 ba 80 33 80 00 00 	movabs $0x803380,%rdx
  8015bb:	00 00 00 
  8015be:	be 26 00 00 00       	mov    $0x26,%esi
  8015c3:	48 bf 43 32 80 00 00 	movabs $0x803243,%rdi
  8015ca:	00 00 00 
  8015cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8015d2:	49 b9 f5 03 80 00 00 	movabs $0x8003f5,%r9
  8015d9:	00 00 00 
  8015dc:	41 ff d1             	call   *%r9

00000000008015df <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  8015df:	f3 0f 1e fa          	endbr64
  8015e3:	55                   	push   %rbp
  8015e4:	48 89 e5             	mov    %rsp,%rbp
  8015e7:	53                   	push   %rbx
  8015e8:	48 83 ec 08          	sub    $0x8,%rsp
  8015ec:	48 89 f1             	mov    %rsi,%rcx
  8015ef:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  8015f2:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8015f5:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8015fa:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8015ff:	be 00 00 00 00       	mov    $0x0,%esi
  801604:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80160a:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80160c:	48 85 c0             	test   %rax,%rax
  80160f:	7f 06                	jg     801617 <sys_unmap_region+0x38>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  801611:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801615:	c9                   	leave
  801616:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801617:	49 89 c0             	mov    %rax,%r8
  80161a:	b9 07 00 00 00       	mov    $0x7,%ecx
  80161f:	48 ba 80 33 80 00 00 	movabs $0x803380,%rdx
  801626:	00 00 00 
  801629:	be 26 00 00 00       	mov    $0x26,%esi
  80162e:	48 bf 43 32 80 00 00 	movabs $0x803243,%rdi
  801635:	00 00 00 
  801638:	b8 00 00 00 00       	mov    $0x0,%eax
  80163d:	49 b9 f5 03 80 00 00 	movabs $0x8003f5,%r9
  801644:	00 00 00 
  801647:	41 ff d1             	call   *%r9

000000000080164a <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  80164a:	f3 0f 1e fa          	endbr64
  80164e:	55                   	push   %rbp
  80164f:	48 89 e5             	mov    %rsp,%rbp
  801652:	53                   	push   %rbx
  801653:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  801657:	48 63 ce             	movslq %esi,%rcx
  80165a:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80165d:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801662:	bb 00 00 00 00       	mov    $0x0,%ebx
  801667:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80166c:	be 00 00 00 00       	mov    $0x0,%esi
  801671:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801677:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801679:	48 85 c0             	test   %rax,%rax
  80167c:	7f 06                	jg     801684 <sys_env_set_status+0x3a>
}
  80167e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801682:	c9                   	leave
  801683:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801684:	49 89 c0             	mov    %rax,%r8
  801687:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80168c:	48 ba 80 33 80 00 00 	movabs $0x803380,%rdx
  801693:	00 00 00 
  801696:	be 26 00 00 00       	mov    $0x26,%esi
  80169b:	48 bf 43 32 80 00 00 	movabs $0x803243,%rdi
  8016a2:	00 00 00 
  8016a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8016aa:	49 b9 f5 03 80 00 00 	movabs $0x8003f5,%r9
  8016b1:	00 00 00 
  8016b4:	41 ff d1             	call   *%r9

00000000008016b7 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  8016b7:	f3 0f 1e fa          	endbr64
  8016bb:	55                   	push   %rbp
  8016bc:	48 89 e5             	mov    %rsp,%rbp
  8016bf:	53                   	push   %rbx
  8016c0:	48 83 ec 08          	sub    $0x8,%rsp
  8016c4:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  8016c7:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8016ca:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8016cf:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016d4:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8016d9:	be 00 00 00 00       	mov    $0x0,%esi
  8016de:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8016e4:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8016e6:	48 85 c0             	test   %rax,%rax
  8016e9:	7f 06                	jg     8016f1 <sys_env_set_trapframe+0x3a>
}
  8016eb:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8016ef:	c9                   	leave
  8016f0:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8016f1:	49 89 c0             	mov    %rax,%r8
  8016f4:	b9 0b 00 00 00       	mov    $0xb,%ecx
  8016f9:	48 ba 80 33 80 00 00 	movabs $0x803380,%rdx
  801700:	00 00 00 
  801703:	be 26 00 00 00       	mov    $0x26,%esi
  801708:	48 bf 43 32 80 00 00 	movabs $0x803243,%rdi
  80170f:	00 00 00 
  801712:	b8 00 00 00 00       	mov    $0x0,%eax
  801717:	49 b9 f5 03 80 00 00 	movabs $0x8003f5,%r9
  80171e:	00 00 00 
  801721:	41 ff d1             	call   *%r9

0000000000801724 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  801724:	f3 0f 1e fa          	endbr64
  801728:	55                   	push   %rbp
  801729:	48 89 e5             	mov    %rsp,%rbp
  80172c:	53                   	push   %rbx
  80172d:	48 83 ec 08          	sub    $0x8,%rsp
  801731:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  801734:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801737:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80173c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801741:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801746:	be 00 00 00 00       	mov    $0x0,%esi
  80174b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801751:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801753:	48 85 c0             	test   %rax,%rax
  801756:	7f 06                	jg     80175e <sys_env_set_pgfault_upcall+0x3a>
}
  801758:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80175c:	c9                   	leave
  80175d:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80175e:	49 89 c0             	mov    %rax,%r8
  801761:	b9 0c 00 00 00       	mov    $0xc,%ecx
  801766:	48 ba 80 33 80 00 00 	movabs $0x803380,%rdx
  80176d:	00 00 00 
  801770:	be 26 00 00 00       	mov    $0x26,%esi
  801775:	48 bf 43 32 80 00 00 	movabs $0x803243,%rdi
  80177c:	00 00 00 
  80177f:	b8 00 00 00 00       	mov    $0x0,%eax
  801784:	49 b9 f5 03 80 00 00 	movabs $0x8003f5,%r9
  80178b:	00 00 00 
  80178e:	41 ff d1             	call   *%r9

0000000000801791 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  801791:	f3 0f 1e fa          	endbr64
  801795:	55                   	push   %rbp
  801796:	48 89 e5             	mov    %rsp,%rbp
  801799:	53                   	push   %rbx
  80179a:	89 f8                	mov    %edi,%eax
  80179c:	49 89 f1             	mov    %rsi,%r9
  80179f:	48 89 d3             	mov    %rdx,%rbx
  8017a2:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  8017a5:	49 63 f0             	movslq %r8d,%rsi
  8017a8:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8017ab:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8017b0:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8017b3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8017b9:	cd 30                	int    $0x30
}
  8017bb:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8017bf:	c9                   	leave
  8017c0:	c3                   	ret

00000000008017c1 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  8017c1:	f3 0f 1e fa          	endbr64
  8017c5:	55                   	push   %rbp
  8017c6:	48 89 e5             	mov    %rsp,%rbp
  8017c9:	53                   	push   %rbx
  8017ca:	48 83 ec 08          	sub    $0x8,%rsp
  8017ce:	48 89 fa             	mov    %rdi,%rdx
  8017d1:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8017d4:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8017d9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017de:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8017e3:	be 00 00 00 00       	mov    $0x0,%esi
  8017e8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8017ee:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8017f0:	48 85 c0             	test   %rax,%rax
  8017f3:	7f 06                	jg     8017fb <sys_ipc_recv+0x3a>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  8017f5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8017f9:	c9                   	leave
  8017fa:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8017fb:	49 89 c0             	mov    %rax,%r8
  8017fe:	b9 0f 00 00 00       	mov    $0xf,%ecx
  801803:	48 ba 80 33 80 00 00 	movabs $0x803380,%rdx
  80180a:	00 00 00 
  80180d:	be 26 00 00 00       	mov    $0x26,%esi
  801812:	48 bf 43 32 80 00 00 	movabs $0x803243,%rdi
  801819:	00 00 00 
  80181c:	b8 00 00 00 00       	mov    $0x0,%eax
  801821:	49 b9 f5 03 80 00 00 	movabs $0x8003f5,%r9
  801828:	00 00 00 
  80182b:	41 ff d1             	call   *%r9

000000000080182e <sys_gettime>:

int
sys_gettime(void) {
  80182e:	f3 0f 1e fa          	endbr64
  801832:	55                   	push   %rbp
  801833:	48 89 e5             	mov    %rsp,%rbp
  801836:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801837:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80183c:	ba 00 00 00 00       	mov    $0x0,%edx
  801841:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801846:	bb 00 00 00 00       	mov    $0x0,%ebx
  80184b:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801850:	be 00 00 00 00       	mov    $0x0,%esi
  801855:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80185b:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  80185d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801861:	c9                   	leave
  801862:	c3                   	ret

0000000000801863 <fd2num>:


/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
  801863:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801867:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80186e:	ff ff ff 
  801871:	48 01 f8             	add    %rdi,%rax
  801874:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801878:	c3                   	ret

0000000000801879 <fd2data>:

char *
fd2data(struct Fd *fd) {
  801879:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80187d:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801884:	ff ff ff 
  801887:	48 01 f8             	add    %rdi,%rax
  80188a:	48 c1 e8 0c          	shr    $0xc,%rax
    return INDEX2DATA(fd2num(fd));
  80188e:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801894:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801898:	c3                   	ret

0000000000801899 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  801899:	f3 0f 1e fa          	endbr64
  80189d:	55                   	push   %rbp
  80189e:	48 89 e5             	mov    %rsp,%rbp
  8018a1:	41 57                	push   %r15
  8018a3:	41 56                	push   %r14
  8018a5:	41 55                	push   %r13
  8018a7:	41 54                	push   %r12
  8018a9:	53                   	push   %rbx
  8018aa:	48 83 ec 08          	sub    $0x8,%rsp
  8018ae:	49 89 ff             	mov    %rdi,%r15
  8018b1:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  8018b6:	49 bd f8 29 80 00 00 	movabs $0x8029f8,%r13
  8018bd:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  8018c0:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        struct Fd *fd = INDEX2FD(i);
  8018c6:	49 89 dc             	mov    %rbx,%r12
        if (!(get_prot(fd) & PROT_R)) {
  8018c9:	48 89 df             	mov    %rbx,%rdi
  8018cc:	41 ff d5             	call   *%r13
  8018cf:	83 e0 04             	and    $0x4,%eax
  8018d2:	74 17                	je     8018eb <fd_alloc+0x52>
    for (int i = 0; i < MAXFD; i++) {
  8018d4:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  8018db:	4c 39 f3             	cmp    %r14,%rbx
  8018de:	75 e6                	jne    8018c6 <fd_alloc+0x2d>
  8018e0:	41 bc 00 00 00 00    	mov    $0x0,%r12d
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
    return -E_MAX_OPEN;
  8018e6:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
            *fd_store = fd;
  8018eb:	4d 89 27             	mov    %r12,(%r15)
}
  8018ee:	48 83 c4 08          	add    $0x8,%rsp
  8018f2:	5b                   	pop    %rbx
  8018f3:	41 5c                	pop    %r12
  8018f5:	41 5d                	pop    %r13
  8018f7:	41 5e                	pop    %r14
  8018f9:	41 5f                	pop    %r15
  8018fb:	5d                   	pop    %rbp
  8018fc:	c3                   	ret

00000000008018fd <fd_lookup>:
 *
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
  8018fd:	f3 0f 1e fa          	endbr64
    if (fdnum < 0 || fdnum >= MAXFD) {
  801901:	83 ff 1f             	cmp    $0x1f,%edi
  801904:	77 39                	ja     80193f <fd_lookup+0x42>
fd_lookup(int fdnum, struct Fd **fd_store) {
  801906:	55                   	push   %rbp
  801907:	48 89 e5             	mov    %rsp,%rbp
  80190a:	41 54                	push   %r12
  80190c:	53                   	push   %rbx
  80190d:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  801910:	48 63 df             	movslq %edi,%rbx
  801913:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  80191a:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  80191e:	48 89 df             	mov    %rbx,%rdi
  801921:	48 b8 f8 29 80 00 00 	movabs $0x8029f8,%rax
  801928:	00 00 00 
  80192b:	ff d0                	call   *%rax
  80192d:	a8 04                	test   $0x4,%al
  80192f:	74 14                	je     801945 <fd_lookup+0x48>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  801931:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  801935:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80193a:	5b                   	pop    %rbx
  80193b:	41 5c                	pop    %r12
  80193d:	5d                   	pop    %rbp
  80193e:	c3                   	ret
        return -E_INVAL;
  80193f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801944:	c3                   	ret
        return -E_INVAL;
  801945:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80194a:	eb ee                	jmp    80193a <fd_lookup+0x3d>

000000000080194c <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  80194c:	f3 0f 1e fa          	endbr64
  801950:	55                   	push   %rbp
  801951:	48 89 e5             	mov    %rsp,%rbp
  801954:	41 54                	push   %r12
  801956:	53                   	push   %rbx
  801957:	49 89 f4             	mov    %rsi,%r12
    for (size_t i = 0; devtab[i]; i++) {
  80195a:	48 b8 80 37 80 00 00 	movabs $0x803780,%rax
  801961:	00 00 00 
  801964:	48 bb 20 40 80 00 00 	movabs $0x804020,%rbx
  80196b:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  80196e:	39 3b                	cmp    %edi,(%rbx)
  801970:	74 47                	je     8019b9 <dev_lookup+0x6d>
    for (size_t i = 0; devtab[i]; i++) {
  801972:	48 83 c0 08          	add    $0x8,%rax
  801976:	48 8b 18             	mov    (%rax),%rbx
  801979:	48 85 db             	test   %rbx,%rbx
  80197c:	75 f0                	jne    80196e <dev_lookup+0x22>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80197e:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801985:	00 00 00 
  801988:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  80198e:	89 fa                	mov    %edi,%edx
  801990:	48 bf a0 33 80 00 00 	movabs $0x8033a0,%rdi
  801997:	00 00 00 
  80199a:	b8 00 00 00 00       	mov    $0x0,%eax
  80199f:	48 b9 51 05 80 00 00 	movabs $0x800551,%rcx
  8019a6:	00 00 00 
  8019a9:	ff d1                	call   *%rcx
    *dev = 0;
    return -E_INVAL;
  8019ab:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
            *dev = devtab[i];
  8019b0:	49 89 1c 24          	mov    %rbx,(%r12)
}
  8019b4:	5b                   	pop    %rbx
  8019b5:	41 5c                	pop    %r12
  8019b7:	5d                   	pop    %rbp
  8019b8:	c3                   	ret
            return 0;
  8019b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8019be:	eb f0                	jmp    8019b0 <dev_lookup+0x64>

00000000008019c0 <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  8019c0:	f3 0f 1e fa          	endbr64
  8019c4:	55                   	push   %rbp
  8019c5:	48 89 e5             	mov    %rsp,%rbp
  8019c8:	41 55                	push   %r13
  8019ca:	41 54                	push   %r12
  8019cc:	53                   	push   %rbx
  8019cd:	48 83 ec 18          	sub    $0x18,%rsp
  8019d1:	48 89 fb             	mov    %rdi,%rbx
  8019d4:	41 89 f4             	mov    %esi,%r12d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8019d7:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  8019de:	ff ff ff 
  8019e1:	48 01 df             	add    %rbx,%rdi
  8019e4:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  8019e8:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8019ec:	48 b8 fd 18 80 00 00 	movabs $0x8018fd,%rax
  8019f3:	00 00 00 
  8019f6:	ff d0                	call   *%rax
  8019f8:	41 89 c5             	mov    %eax,%r13d
  8019fb:	85 c0                	test   %eax,%eax
  8019fd:	78 06                	js     801a05 <fd_close+0x45>
  8019ff:	48 39 5d d8          	cmp    %rbx,-0x28(%rbp)
  801a03:	74 1a                	je     801a1f <fd_close+0x5f>
        return (must_exist ? res : 0);
  801a05:	45 84 e4             	test   %r12b,%r12b
  801a08:	b8 00 00 00 00       	mov    $0x0,%eax
  801a0d:	44 0f 44 e8          	cmove  %eax,%r13d
}
  801a11:	44 89 e8             	mov    %r13d,%eax
  801a14:	48 83 c4 18          	add    $0x18,%rsp
  801a18:	5b                   	pop    %rbx
  801a19:	41 5c                	pop    %r12
  801a1b:	41 5d                	pop    %r13
  801a1d:	5d                   	pop    %rbp
  801a1e:	c3                   	ret
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801a1f:	8b 3b                	mov    (%rbx),%edi
  801a21:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801a25:	48 b8 4c 19 80 00 00 	movabs $0x80194c,%rax
  801a2c:	00 00 00 
  801a2f:	ff d0                	call   *%rax
  801a31:	41 89 c5             	mov    %eax,%r13d
  801a34:	85 c0                	test   %eax,%eax
  801a36:	78 1b                	js     801a53 <fd_close+0x93>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  801a38:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a3c:	48 8b 40 20          	mov    0x20(%rax),%rax
  801a40:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  801a46:	48 85 c0             	test   %rax,%rax
  801a49:	74 08                	je     801a53 <fd_close+0x93>
  801a4b:	48 89 df             	mov    %rbx,%rdi
  801a4e:	ff d0                	call   *%rax
  801a50:	41 89 c5             	mov    %eax,%r13d
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801a53:	ba 00 10 00 00       	mov    $0x1000,%edx
  801a58:	48 89 de             	mov    %rbx,%rsi
  801a5b:	bf 00 00 00 00       	mov    $0x0,%edi
  801a60:	48 b8 df 15 80 00 00 	movabs $0x8015df,%rax
  801a67:	00 00 00 
  801a6a:	ff d0                	call   *%rax
    return res;
  801a6c:	eb a3                	jmp    801a11 <fd_close+0x51>

0000000000801a6e <close>:

int
close(int fdnum) {
  801a6e:	f3 0f 1e fa          	endbr64
  801a72:	55                   	push   %rbp
  801a73:	48 89 e5             	mov    %rsp,%rbp
  801a76:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  801a7a:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801a7e:	48 b8 fd 18 80 00 00 	movabs $0x8018fd,%rax
  801a85:	00 00 00 
  801a88:	ff d0                	call   *%rax
    if (res < 0) return res;
  801a8a:	85 c0                	test   %eax,%eax
  801a8c:	78 15                	js     801aa3 <close+0x35>

    return fd_close(fd, 1);
  801a8e:	be 01 00 00 00       	mov    $0x1,%esi
  801a93:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801a97:	48 b8 c0 19 80 00 00 	movabs $0x8019c0,%rax
  801a9e:	00 00 00 
  801aa1:	ff d0                	call   *%rax
}
  801aa3:	c9                   	leave
  801aa4:	c3                   	ret

0000000000801aa5 <close_all>:

void
close_all(void) {
  801aa5:	f3 0f 1e fa          	endbr64
  801aa9:	55                   	push   %rbp
  801aaa:	48 89 e5             	mov    %rsp,%rbp
  801aad:	41 54                	push   %r12
  801aaf:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  801ab0:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ab5:	49 bc 6e 1a 80 00 00 	movabs $0x801a6e,%r12
  801abc:	00 00 00 
  801abf:	89 df                	mov    %ebx,%edi
  801ac1:	41 ff d4             	call   *%r12
  801ac4:	83 c3 01             	add    $0x1,%ebx
  801ac7:	83 fb 20             	cmp    $0x20,%ebx
  801aca:	75 f3                	jne    801abf <close_all+0x1a>
}
  801acc:	5b                   	pop    %rbx
  801acd:	41 5c                	pop    %r12
  801acf:	5d                   	pop    %rbp
  801ad0:	c3                   	ret

0000000000801ad1 <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  801ad1:	f3 0f 1e fa          	endbr64
  801ad5:	55                   	push   %rbp
  801ad6:	48 89 e5             	mov    %rsp,%rbp
  801ad9:	41 57                	push   %r15
  801adb:	41 56                	push   %r14
  801add:	41 55                	push   %r13
  801adf:	41 54                	push   %r12
  801ae1:	53                   	push   %rbx
  801ae2:	48 83 ec 18          	sub    $0x18,%rsp
  801ae6:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  801ae9:	48 8d 75 c8          	lea    -0x38(%rbp),%rsi
  801aed:	48 b8 fd 18 80 00 00 	movabs $0x8018fd,%rax
  801af4:	00 00 00 
  801af7:	ff d0                	call   *%rax
  801af9:	89 c3                	mov    %eax,%ebx
  801afb:	85 c0                	test   %eax,%eax
  801afd:	0f 88 b8 00 00 00    	js     801bbb <dup+0xea>
    close(newfdnum);
  801b03:	44 89 e7             	mov    %r12d,%edi
  801b06:	48 b8 6e 1a 80 00 00 	movabs $0x801a6e,%rax
  801b0d:	00 00 00 
  801b10:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  801b12:	4d 63 ec             	movslq %r12d,%r13
  801b15:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  801b1c:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  801b20:	4c 8b 7d c8          	mov    -0x38(%rbp),%r15
  801b24:	4c 89 ff             	mov    %r15,%rdi
  801b27:	49 be 79 18 80 00 00 	movabs $0x801879,%r14
  801b2e:	00 00 00 
  801b31:	41 ff d6             	call   *%r14
  801b34:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  801b37:	4c 89 ef             	mov    %r13,%rdi
  801b3a:	41 ff d6             	call   *%r14
  801b3d:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  801b40:	48 89 df             	mov    %rbx,%rdi
  801b43:	48 b8 f8 29 80 00 00 	movabs $0x8029f8,%rax
  801b4a:	00 00 00 
  801b4d:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  801b4f:	a8 04                	test   $0x4,%al
  801b51:	74 2b                	je     801b7e <dup+0xad>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  801b53:	41 89 c1             	mov    %eax,%r9d
  801b56:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801b5c:	4c 89 f1             	mov    %r14,%rcx
  801b5f:	ba 00 00 00 00       	mov    $0x0,%edx
  801b64:	48 89 de             	mov    %rbx,%rsi
  801b67:	bf 00 00 00 00       	mov    $0x0,%edi
  801b6c:	48 b8 0a 15 80 00 00 	movabs $0x80150a,%rax
  801b73:	00 00 00 
  801b76:	ff d0                	call   *%rax
  801b78:	89 c3                	mov    %eax,%ebx
  801b7a:	85 c0                	test   %eax,%eax
  801b7c:	78 4e                	js     801bcc <dup+0xfb>
    }
    prot = get_prot(oldfd);
  801b7e:	4c 89 ff             	mov    %r15,%rdi
  801b81:	48 b8 f8 29 80 00 00 	movabs $0x8029f8,%rax
  801b88:	00 00 00 
  801b8b:	ff d0                	call   *%rax
  801b8d:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  801b90:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801b96:	4c 89 e9             	mov    %r13,%rcx
  801b99:	ba 00 00 00 00       	mov    $0x0,%edx
  801b9e:	4c 89 fe             	mov    %r15,%rsi
  801ba1:	bf 00 00 00 00       	mov    $0x0,%edi
  801ba6:	48 b8 0a 15 80 00 00 	movabs $0x80150a,%rax
  801bad:	00 00 00 
  801bb0:	ff d0                	call   *%rax
  801bb2:	89 c3                	mov    %eax,%ebx
  801bb4:	85 c0                	test   %eax,%eax
  801bb6:	78 14                	js     801bcc <dup+0xfb>

    return newfdnum;
  801bb8:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  801bbb:	89 d8                	mov    %ebx,%eax
  801bbd:	48 83 c4 18          	add    $0x18,%rsp
  801bc1:	5b                   	pop    %rbx
  801bc2:	41 5c                	pop    %r12
  801bc4:	41 5d                	pop    %r13
  801bc6:	41 5e                	pop    %r14
  801bc8:	41 5f                	pop    %r15
  801bca:	5d                   	pop    %rbp
  801bcb:	c3                   	ret
    sys_unmap_region(0, newfd, PAGE_SIZE);
  801bcc:	ba 00 10 00 00       	mov    $0x1000,%edx
  801bd1:	4c 89 ee             	mov    %r13,%rsi
  801bd4:	bf 00 00 00 00       	mov    $0x0,%edi
  801bd9:	49 bc df 15 80 00 00 	movabs $0x8015df,%r12
  801be0:	00 00 00 
  801be3:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  801be6:	ba 00 10 00 00       	mov    $0x1000,%edx
  801beb:	4c 89 f6             	mov    %r14,%rsi
  801bee:	bf 00 00 00 00       	mov    $0x0,%edi
  801bf3:	41 ff d4             	call   *%r12
    return res;
  801bf6:	eb c3                	jmp    801bbb <dup+0xea>

0000000000801bf8 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  801bf8:	f3 0f 1e fa          	endbr64
  801bfc:	55                   	push   %rbp
  801bfd:	48 89 e5             	mov    %rsp,%rbp
  801c00:	41 56                	push   %r14
  801c02:	41 55                	push   %r13
  801c04:	41 54                	push   %r12
  801c06:	53                   	push   %rbx
  801c07:	48 83 ec 10          	sub    $0x10,%rsp
  801c0b:	89 fb                	mov    %edi,%ebx
  801c0d:	49 89 f4             	mov    %rsi,%r12
  801c10:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801c13:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801c17:	48 b8 fd 18 80 00 00 	movabs $0x8018fd,%rax
  801c1e:	00 00 00 
  801c21:	ff d0                	call   *%rax
  801c23:	85 c0                	test   %eax,%eax
  801c25:	78 4c                	js     801c73 <read+0x7b>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801c27:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801c2b:	41 8b 3e             	mov    (%r14),%edi
  801c2e:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801c32:	48 b8 4c 19 80 00 00 	movabs $0x80194c,%rax
  801c39:	00 00 00 
  801c3c:	ff d0                	call   *%rax
  801c3e:	85 c0                	test   %eax,%eax
  801c40:	78 35                	js     801c77 <read+0x7f>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801c42:	41 8b 46 08          	mov    0x8(%r14),%eax
  801c46:	83 e0 03             	and    $0x3,%eax
  801c49:	83 f8 01             	cmp    $0x1,%eax
  801c4c:	74 2d                	je     801c7b <read+0x83>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  801c4e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801c52:	48 8b 40 10          	mov    0x10(%rax),%rax
  801c56:	48 85 c0             	test   %rax,%rax
  801c59:	74 56                	je     801cb1 <read+0xb9>

    return (*dev->dev_read)(fd, buf, n);
  801c5b:	4c 89 ea             	mov    %r13,%rdx
  801c5e:	4c 89 e6             	mov    %r12,%rsi
  801c61:	4c 89 f7             	mov    %r14,%rdi
  801c64:	ff d0                	call   *%rax
}
  801c66:	48 83 c4 10          	add    $0x10,%rsp
  801c6a:	5b                   	pop    %rbx
  801c6b:	41 5c                	pop    %r12
  801c6d:	41 5d                	pop    %r13
  801c6f:	41 5e                	pop    %r14
  801c71:	5d                   	pop    %rbp
  801c72:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801c73:	48 98                	cltq
  801c75:	eb ef                	jmp    801c66 <read+0x6e>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801c77:	48 98                	cltq
  801c79:	eb eb                	jmp    801c66 <read+0x6e>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801c7b:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801c82:	00 00 00 
  801c85:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801c8b:	89 da                	mov    %ebx,%edx
  801c8d:	48 bf 51 32 80 00 00 	movabs $0x803251,%rdi
  801c94:	00 00 00 
  801c97:	b8 00 00 00 00       	mov    $0x0,%eax
  801c9c:	48 b9 51 05 80 00 00 	movabs $0x800551,%rcx
  801ca3:	00 00 00 
  801ca6:	ff d1                	call   *%rcx
        return -E_INVAL;
  801ca8:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801caf:	eb b5                	jmp    801c66 <read+0x6e>
    if (!dev->dev_read) return -E_NOT_SUPP;
  801cb1:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801cb8:	eb ac                	jmp    801c66 <read+0x6e>

0000000000801cba <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801cba:	f3 0f 1e fa          	endbr64
  801cbe:	55                   	push   %rbp
  801cbf:	48 89 e5             	mov    %rsp,%rbp
  801cc2:	41 57                	push   %r15
  801cc4:	41 56                	push   %r14
  801cc6:	41 55                	push   %r13
  801cc8:	41 54                	push   %r12
  801cca:	53                   	push   %rbx
  801ccb:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801ccf:	48 85 d2             	test   %rdx,%rdx
  801cd2:	74 54                	je     801d28 <readn+0x6e>
  801cd4:	41 89 fd             	mov    %edi,%r13d
  801cd7:	49 89 f6             	mov    %rsi,%r14
  801cda:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801cdd:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801ce2:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801ce7:	49 bf f8 1b 80 00 00 	movabs $0x801bf8,%r15
  801cee:	00 00 00 
  801cf1:	4c 89 e2             	mov    %r12,%rdx
  801cf4:	48 29 f2             	sub    %rsi,%rdx
  801cf7:	4c 01 f6             	add    %r14,%rsi
  801cfa:	44 89 ef             	mov    %r13d,%edi
  801cfd:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  801d00:	85 c0                	test   %eax,%eax
  801d02:	78 20                	js     801d24 <readn+0x6a>
    for (; inc && res < n; res += inc) {
  801d04:	01 c3                	add    %eax,%ebx
  801d06:	85 c0                	test   %eax,%eax
  801d08:	74 08                	je     801d12 <readn+0x58>
  801d0a:	48 63 f3             	movslq %ebx,%rsi
  801d0d:	4c 39 e6             	cmp    %r12,%rsi
  801d10:	72 df                	jb     801cf1 <readn+0x37>
    }
    return res;
  801d12:	48 63 c3             	movslq %ebx,%rax
}
  801d15:	48 83 c4 08          	add    $0x8,%rsp
  801d19:	5b                   	pop    %rbx
  801d1a:	41 5c                	pop    %r12
  801d1c:	41 5d                	pop    %r13
  801d1e:	41 5e                	pop    %r14
  801d20:	41 5f                	pop    %r15
  801d22:	5d                   	pop    %rbp
  801d23:	c3                   	ret
        if (inc < 0) return inc;
  801d24:	48 98                	cltq
  801d26:	eb ed                	jmp    801d15 <readn+0x5b>
    int inc = 1, res = 0;
  801d28:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d2d:	eb e3                	jmp    801d12 <readn+0x58>

0000000000801d2f <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  801d2f:	f3 0f 1e fa          	endbr64
  801d33:	55                   	push   %rbp
  801d34:	48 89 e5             	mov    %rsp,%rbp
  801d37:	41 56                	push   %r14
  801d39:	41 55                	push   %r13
  801d3b:	41 54                	push   %r12
  801d3d:	53                   	push   %rbx
  801d3e:	48 83 ec 10          	sub    $0x10,%rsp
  801d42:	89 fb                	mov    %edi,%ebx
  801d44:	49 89 f4             	mov    %rsi,%r12
  801d47:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801d4a:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801d4e:	48 b8 fd 18 80 00 00 	movabs $0x8018fd,%rax
  801d55:	00 00 00 
  801d58:	ff d0                	call   *%rax
  801d5a:	85 c0                	test   %eax,%eax
  801d5c:	78 47                	js     801da5 <write+0x76>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801d5e:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801d62:	41 8b 3e             	mov    (%r14),%edi
  801d65:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801d69:	48 b8 4c 19 80 00 00 	movabs $0x80194c,%rax
  801d70:	00 00 00 
  801d73:	ff d0                	call   *%rax
  801d75:	85 c0                	test   %eax,%eax
  801d77:	78 30                	js     801da9 <write+0x7a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801d79:	41 f6 46 08 03       	testb  $0x3,0x8(%r14)
  801d7e:	74 2d                	je     801dad <write+0x7e>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801d80:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d84:	48 8b 40 18          	mov    0x18(%rax),%rax
  801d88:	48 85 c0             	test   %rax,%rax
  801d8b:	74 56                	je     801de3 <write+0xb4>

    return (*dev->dev_write)(fd, buf, n);
  801d8d:	4c 89 ea             	mov    %r13,%rdx
  801d90:	4c 89 e6             	mov    %r12,%rsi
  801d93:	4c 89 f7             	mov    %r14,%rdi
  801d96:	ff d0                	call   *%rax
}
  801d98:	48 83 c4 10          	add    $0x10,%rsp
  801d9c:	5b                   	pop    %rbx
  801d9d:	41 5c                	pop    %r12
  801d9f:	41 5d                	pop    %r13
  801da1:	41 5e                	pop    %r14
  801da3:	5d                   	pop    %rbp
  801da4:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801da5:	48 98                	cltq
  801da7:	eb ef                	jmp    801d98 <write+0x69>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801da9:	48 98                	cltq
  801dab:	eb eb                	jmp    801d98 <write+0x69>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801dad:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801db4:	00 00 00 
  801db7:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801dbd:	89 da                	mov    %ebx,%edx
  801dbf:	48 bf 6d 32 80 00 00 	movabs $0x80326d,%rdi
  801dc6:	00 00 00 
  801dc9:	b8 00 00 00 00       	mov    $0x0,%eax
  801dce:	48 b9 51 05 80 00 00 	movabs $0x800551,%rcx
  801dd5:	00 00 00 
  801dd8:	ff d1                	call   *%rcx
        return -E_INVAL;
  801dda:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801de1:	eb b5                	jmp    801d98 <write+0x69>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801de3:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801dea:	eb ac                	jmp    801d98 <write+0x69>

0000000000801dec <seek>:

int
seek(int fdnum, off_t offset) {
  801dec:	f3 0f 1e fa          	endbr64
  801df0:	55                   	push   %rbp
  801df1:	48 89 e5             	mov    %rsp,%rbp
  801df4:	53                   	push   %rbx
  801df5:	48 83 ec 18          	sub    $0x18,%rsp
  801df9:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801dfb:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801dff:	48 b8 fd 18 80 00 00 	movabs $0x8018fd,%rax
  801e06:	00 00 00 
  801e09:	ff d0                	call   *%rax
  801e0b:	85 c0                	test   %eax,%eax
  801e0d:	78 0c                	js     801e1b <seek+0x2f>

    fd->fd_offset = offset;
  801e0f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e13:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  801e16:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e1b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801e1f:	c9                   	leave
  801e20:	c3                   	ret

0000000000801e21 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  801e21:	f3 0f 1e fa          	endbr64
  801e25:	55                   	push   %rbp
  801e26:	48 89 e5             	mov    %rsp,%rbp
  801e29:	41 55                	push   %r13
  801e2b:	41 54                	push   %r12
  801e2d:	53                   	push   %rbx
  801e2e:	48 83 ec 18          	sub    $0x18,%rsp
  801e32:	89 fb                	mov    %edi,%ebx
  801e34:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801e37:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801e3b:	48 b8 fd 18 80 00 00 	movabs $0x8018fd,%rax
  801e42:	00 00 00 
  801e45:	ff d0                	call   *%rax
  801e47:	85 c0                	test   %eax,%eax
  801e49:	78 38                	js     801e83 <ftruncate+0x62>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801e4b:	4c 8b 6d d8          	mov    -0x28(%rbp),%r13
  801e4f:	41 8b 7d 00          	mov    0x0(%r13),%edi
  801e53:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801e57:	48 b8 4c 19 80 00 00 	movabs $0x80194c,%rax
  801e5e:	00 00 00 
  801e61:	ff d0                	call   *%rax
  801e63:	85 c0                	test   %eax,%eax
  801e65:	78 1c                	js     801e83 <ftruncate+0x62>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801e67:	41 f6 45 08 03       	testb  $0x3,0x8(%r13)
  801e6c:	74 20                	je     801e8e <ftruncate+0x6d>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801e6e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801e72:	48 8b 40 30          	mov    0x30(%rax),%rax
  801e76:	48 85 c0             	test   %rax,%rax
  801e79:	74 47                	je     801ec2 <ftruncate+0xa1>

    return (*dev->dev_trunc)(fd, newsize);
  801e7b:	44 89 e6             	mov    %r12d,%esi
  801e7e:	4c 89 ef             	mov    %r13,%rdi
  801e81:	ff d0                	call   *%rax
}
  801e83:	48 83 c4 18          	add    $0x18,%rsp
  801e87:	5b                   	pop    %rbx
  801e88:	41 5c                	pop    %r12
  801e8a:	41 5d                	pop    %r13
  801e8c:	5d                   	pop    %rbp
  801e8d:	c3                   	ret
                thisenv->env_id, fdnum);
  801e8e:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801e95:	00 00 00 
  801e98:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801e9e:	89 da                	mov    %ebx,%edx
  801ea0:	48 bf c0 33 80 00 00 	movabs $0x8033c0,%rdi
  801ea7:	00 00 00 
  801eaa:	b8 00 00 00 00       	mov    $0x0,%eax
  801eaf:	48 b9 51 05 80 00 00 	movabs $0x800551,%rcx
  801eb6:	00 00 00 
  801eb9:	ff d1                	call   *%rcx
        return -E_INVAL;
  801ebb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ec0:	eb c1                	jmp    801e83 <ftruncate+0x62>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801ec2:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801ec7:	eb ba                	jmp    801e83 <ftruncate+0x62>

0000000000801ec9 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  801ec9:	f3 0f 1e fa          	endbr64
  801ecd:	55                   	push   %rbp
  801ece:	48 89 e5             	mov    %rsp,%rbp
  801ed1:	41 54                	push   %r12
  801ed3:	53                   	push   %rbx
  801ed4:	48 83 ec 10          	sub    $0x10,%rsp
  801ed8:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801edb:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801edf:	48 b8 fd 18 80 00 00 	movabs $0x8018fd,%rax
  801ee6:	00 00 00 
  801ee9:	ff d0                	call   *%rax
  801eeb:	85 c0                	test   %eax,%eax
  801eed:	78 4e                	js     801f3d <fstat+0x74>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801eef:	4c 8b 65 e8          	mov    -0x18(%rbp),%r12
  801ef3:	41 8b 3c 24          	mov    (%r12),%edi
  801ef7:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801efb:	48 b8 4c 19 80 00 00 	movabs $0x80194c,%rax
  801f02:	00 00 00 
  801f05:	ff d0                	call   *%rax
  801f07:	85 c0                	test   %eax,%eax
  801f09:	78 32                	js     801f3d <fstat+0x74>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  801f0b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f0f:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  801f14:	74 30                	je     801f46 <fstat+0x7d>

    stat->st_name[0] = 0;
  801f16:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  801f19:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  801f20:	00 00 00 
    stat->st_isdir = 0;
  801f23:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801f2a:	00 00 00 
    stat->st_dev = dev;
  801f2d:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  801f34:	48 89 de             	mov    %rbx,%rsi
  801f37:	4c 89 e7             	mov    %r12,%rdi
  801f3a:	ff 50 28             	call   *0x28(%rax)
}
  801f3d:	48 83 c4 10          	add    $0x10,%rsp
  801f41:	5b                   	pop    %rbx
  801f42:	41 5c                	pop    %r12
  801f44:	5d                   	pop    %rbp
  801f45:	c3                   	ret
    if (!dev->dev_stat) return -E_NOT_SUPP;
  801f46:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801f4b:	eb f0                	jmp    801f3d <fstat+0x74>

0000000000801f4d <stat>:

int
stat(const char *path, struct Stat *stat) {
  801f4d:	f3 0f 1e fa          	endbr64
  801f51:	55                   	push   %rbp
  801f52:	48 89 e5             	mov    %rsp,%rbp
  801f55:	41 54                	push   %r12
  801f57:	53                   	push   %rbx
  801f58:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  801f5b:	be 00 00 00 00       	mov    $0x0,%esi
  801f60:	48 b8 2e 22 80 00 00 	movabs $0x80222e,%rax
  801f67:	00 00 00 
  801f6a:	ff d0                	call   *%rax
  801f6c:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  801f6e:	85 c0                	test   %eax,%eax
  801f70:	78 25                	js     801f97 <stat+0x4a>

    int res = fstat(fd, stat);
  801f72:	4c 89 e6             	mov    %r12,%rsi
  801f75:	89 c7                	mov    %eax,%edi
  801f77:	48 b8 c9 1e 80 00 00 	movabs $0x801ec9,%rax
  801f7e:	00 00 00 
  801f81:	ff d0                	call   *%rax
  801f83:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  801f86:	89 df                	mov    %ebx,%edi
  801f88:	48 b8 6e 1a 80 00 00 	movabs $0x801a6e,%rax
  801f8f:	00 00 00 
  801f92:	ff d0                	call   *%rax

    return res;
  801f94:	44 89 e3             	mov    %r12d,%ebx
}
  801f97:	89 d8                	mov    %ebx,%eax
  801f99:	5b                   	pop    %rbx
  801f9a:	41 5c                	pop    %r12
  801f9c:	5d                   	pop    %rbp
  801f9d:	c3                   	ret

0000000000801f9e <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  801f9e:	f3 0f 1e fa          	endbr64
  801fa2:	55                   	push   %rbp
  801fa3:	48 89 e5             	mov    %rsp,%rbp
  801fa6:	41 54                	push   %r12
  801fa8:	53                   	push   %rbx
  801fa9:	48 83 ec 10          	sub    $0x10,%rsp
  801fad:	41 89 fc             	mov    %edi,%r12d
  801fb0:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801fb3:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801fba:	00 00 00 
  801fbd:	83 38 00             	cmpl   $0x0,(%rax)
  801fc0:	74 6e                	je     802030 <fsipc+0x92>

    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }
    fsenv = ipc_find_env(ENV_TYPE_FS);
  801fc2:	bf 03 00 00 00       	mov    $0x3,%edi
  801fc7:	48 b8 25 2f 80 00 00 	movabs $0x802f25,%rax
  801fce:	00 00 00 
  801fd1:	ff d0                	call   *%rax
  801fd3:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  801fda:	00 00 
    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  801fdc:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  801fe2:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801fe7:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  801fee:	00 00 00 
  801ff1:	44 89 e6             	mov    %r12d,%esi
  801ff4:	89 c7                	mov    %eax,%edi
  801ff6:	48 b8 63 2e 80 00 00 	movabs $0x802e63,%rax
  801ffd:	00 00 00 
  802000:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  802002:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  802009:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  80200a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80200f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802013:	48 89 de             	mov    %rbx,%rsi
  802016:	bf 00 00 00 00       	mov    $0x0,%edi
  80201b:	48 b8 ca 2d 80 00 00 	movabs $0x802dca,%rax
  802022:	00 00 00 
  802025:	ff d0                	call   *%rax
}
  802027:	48 83 c4 10          	add    $0x10,%rsp
  80202b:	5b                   	pop    %rbx
  80202c:	41 5c                	pop    %r12
  80202e:	5d                   	pop    %rbp
  80202f:	c3                   	ret
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  802030:	bf 03 00 00 00       	mov    $0x3,%edi
  802035:	48 b8 25 2f 80 00 00 	movabs $0x802f25,%rax
  80203c:	00 00 00 
  80203f:	ff d0                	call   *%rax
  802041:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  802048:	00 00 
  80204a:	e9 73 ff ff ff       	jmp    801fc2 <fsipc+0x24>

000000000080204f <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  80204f:	f3 0f 1e fa          	endbr64
  802053:	55                   	push   %rbp
  802054:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802057:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80205e:	00 00 00 
  802061:	8b 57 0c             	mov    0xc(%rdi),%edx
  802064:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  802066:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  802069:	be 00 00 00 00       	mov    $0x0,%esi
  80206e:	bf 02 00 00 00       	mov    $0x2,%edi
  802073:	48 b8 9e 1f 80 00 00 	movabs $0x801f9e,%rax
  80207a:	00 00 00 
  80207d:	ff d0                	call   *%rax
}
  80207f:	5d                   	pop    %rbp
  802080:	c3                   	ret

0000000000802081 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  802081:	f3 0f 1e fa          	endbr64
  802085:	55                   	push   %rbp
  802086:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802089:	8b 47 0c             	mov    0xc(%rdi),%eax
  80208c:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  802093:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  802095:	be 00 00 00 00       	mov    $0x0,%esi
  80209a:	bf 06 00 00 00       	mov    $0x6,%edi
  80209f:	48 b8 9e 1f 80 00 00 	movabs $0x801f9e,%rax
  8020a6:	00 00 00 
  8020a9:	ff d0                	call   *%rax
}
  8020ab:	5d                   	pop    %rbp
  8020ac:	c3                   	ret

00000000008020ad <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  8020ad:	f3 0f 1e fa          	endbr64
  8020b1:	55                   	push   %rbp
  8020b2:	48 89 e5             	mov    %rsp,%rbp
  8020b5:	41 54                	push   %r12
  8020b7:	53                   	push   %rbx
  8020b8:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8020bb:	8b 47 0c             	mov    0xc(%rdi),%eax
  8020be:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  8020c5:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  8020c7:	be 00 00 00 00       	mov    $0x0,%esi
  8020cc:	bf 05 00 00 00       	mov    $0x5,%edi
  8020d1:	48 b8 9e 1f 80 00 00 	movabs $0x801f9e,%rax
  8020d8:	00 00 00 
  8020db:	ff d0                	call   *%rax
    if (res < 0) return res;
  8020dd:	85 c0                	test   %eax,%eax
  8020df:	78 3d                	js     80211e <devfile_stat+0x71>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8020e1:	49 bc 00 60 80 00 00 	movabs $0x806000,%r12
  8020e8:	00 00 00 
  8020eb:	4c 89 e6             	mov    %r12,%rsi
  8020ee:	48 89 df             	mov    %rbx,%rdi
  8020f1:	48 b8 9a 0e 80 00 00 	movabs $0x800e9a,%rax
  8020f8:	00 00 00 
  8020fb:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  8020fd:	41 8b 84 24 80 00 00 	mov    0x80(%r12),%eax
  802104:	00 
  802105:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80210b:	41 8b 84 24 84 00 00 	mov    0x84(%r12),%eax
  802112:	00 
  802113:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  802119:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80211e:	5b                   	pop    %rbx
  80211f:	41 5c                	pop    %r12
  802121:	5d                   	pop    %rbp
  802122:	c3                   	ret

0000000000802123 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  802123:	f3 0f 1e fa          	endbr64
    if (n >= sizeof(fsipcbuf.write.req_buf)) {
  802127:	48 81 fa ef 0f 00 00 	cmp    $0xfef,%rdx
  80212e:	77 41                	ja     802171 <devfile_write+0x4e>
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  802130:	55                   	push   %rbp
  802131:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  802134:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80213b:	00 00 00 
  80213e:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  802141:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.write.req_n = n;
  802143:	48 89 50 08          	mov    %rdx,0x8(%rax)
    memmove(fsipcbuf.write.req_buf, buf, n);
  802147:	48 8d 78 10          	lea    0x10(%rax),%rdi
  80214b:	48 b8 b5 10 80 00 00 	movabs $0x8010b5,%rax
  802152:	00 00 00 
  802155:	ff d0                	call   *%rax
    res = fsipc(FSREQ_WRITE, NULL);
  802157:	be 00 00 00 00       	mov    $0x0,%esi
  80215c:	bf 04 00 00 00       	mov    $0x4,%edi
  802161:	48 b8 9e 1f 80 00 00 	movabs $0x801f9e,%rax
  802168:	00 00 00 
  80216b:	ff d0                	call   *%rax
  80216d:	48 98                	cltq
}
  80216f:	5d                   	pop    %rbp
  802170:	c3                   	ret
        return -E_INVAL;
  802171:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
}
  802178:	c3                   	ret

0000000000802179 <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  802179:	f3 0f 1e fa          	endbr64
  80217d:	55                   	push   %rbp
  80217e:	48 89 e5             	mov    %rsp,%rbp
  802181:	41 55                	push   %r13
  802183:	41 54                	push   %r12
  802185:	53                   	push   %rbx
  802186:	48 83 ec 08          	sub    $0x8,%rsp
  80218a:	49 89 f4             	mov    %rsi,%r12
  80218d:	48 89 d3             	mov    %rdx,%rbx
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  802190:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  802197:	00 00 00 
  80219a:	8b 57 0c             	mov    0xc(%rdi),%edx
  80219d:	89 10                	mov    %edx,(%rax)
    fsipcbuf.read.req_n = n;
  80219f:	48 89 58 08          	mov    %rbx,0x8(%rax)
    res = fsipc(FSREQ_READ, NULL);
  8021a3:	be 00 00 00 00       	mov    $0x0,%esi
  8021a8:	bf 03 00 00 00       	mov    $0x3,%edi
  8021ad:	48 b8 9e 1f 80 00 00 	movabs $0x801f9e,%rax
  8021b4:	00 00 00 
  8021b7:	ff d0                	call   *%rax
  8021b9:	4c 63 e8             	movslq %eax,%r13
    if (res < 0) {
  8021bc:	4d 85 ed             	test   %r13,%r13
  8021bf:	78 2a                	js     8021eb <devfile_read+0x72>
    assert(res <= n && res <= PAGE_SIZE);
  8021c1:	4c 89 ea             	mov    %r13,%rdx
  8021c4:	4c 39 eb             	cmp    %r13,%rbx
  8021c7:	72 30                	jb     8021f9 <devfile_read+0x80>
  8021c9:	49 81 fd 00 10 00 00 	cmp    $0x1000,%r13
  8021d0:	7f 27                	jg     8021f9 <devfile_read+0x80>
    memmove(buf, &fsipcbuf, res);
  8021d2:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  8021d9:	00 00 00 
  8021dc:	4c 89 e7             	mov    %r12,%rdi
  8021df:	48 b8 b5 10 80 00 00 	movabs $0x8010b5,%rax
  8021e6:	00 00 00 
  8021e9:	ff d0                	call   *%rax
}
  8021eb:	4c 89 e8             	mov    %r13,%rax
  8021ee:	48 83 c4 08          	add    $0x8,%rsp
  8021f2:	5b                   	pop    %rbx
  8021f3:	41 5c                	pop    %r12
  8021f5:	41 5d                	pop    %r13
  8021f7:	5d                   	pop    %rbp
  8021f8:	c3                   	ret
    assert(res <= n && res <= PAGE_SIZE);
  8021f9:	48 b9 8a 32 80 00 00 	movabs $0x80328a,%rcx
  802200:	00 00 00 
  802203:	48 ba a7 32 80 00 00 	movabs $0x8032a7,%rdx
  80220a:	00 00 00 
  80220d:	be 7b 00 00 00       	mov    $0x7b,%esi
  802212:	48 bf bc 32 80 00 00 	movabs $0x8032bc,%rdi
  802219:	00 00 00 
  80221c:	b8 00 00 00 00       	mov    $0x0,%eax
  802221:	49 b8 f5 03 80 00 00 	movabs $0x8003f5,%r8
  802228:	00 00 00 
  80222b:	41 ff d0             	call   *%r8

000000000080222e <open>:
open(const char *path, int mode) {
  80222e:	f3 0f 1e fa          	endbr64
  802232:	55                   	push   %rbp
  802233:	48 89 e5             	mov    %rsp,%rbp
  802236:	41 55                	push   %r13
  802238:	41 54                	push   %r12
  80223a:	53                   	push   %rbx
  80223b:	48 83 ec 18          	sub    $0x18,%rsp
  80223f:	49 89 fc             	mov    %rdi,%r12
  802242:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  802245:	48 b8 55 0e 80 00 00 	movabs $0x800e55,%rax
  80224c:	00 00 00 
  80224f:	ff d0                	call   *%rax
  802251:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  802257:	0f 87 8a 00 00 00    	ja     8022e7 <open+0xb9>
    if ((res = fd_alloc(&fd)) < 0) return res;
  80225d:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802261:	48 b8 99 18 80 00 00 	movabs $0x801899,%rax
  802268:	00 00 00 
  80226b:	ff d0                	call   *%rax
  80226d:	89 c3                	mov    %eax,%ebx
  80226f:	85 c0                	test   %eax,%eax
  802271:	78 50                	js     8022c3 <open+0x95>
    strcpy(fsipcbuf.open.req_path, path);
  802273:	4c 89 e6             	mov    %r12,%rsi
  802276:	48 bb 00 60 80 00 00 	movabs $0x806000,%rbx
  80227d:	00 00 00 
  802280:	48 89 df             	mov    %rbx,%rdi
  802283:	48 b8 9a 0e 80 00 00 	movabs $0x800e9a,%rax
  80228a:	00 00 00 
  80228d:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  80228f:	44 89 ab 00 04 00 00 	mov    %r13d,0x400(%rbx)
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  802296:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80229a:	bf 01 00 00 00       	mov    $0x1,%edi
  80229f:	48 b8 9e 1f 80 00 00 	movabs $0x801f9e,%rax
  8022a6:	00 00 00 
  8022a9:	ff d0                	call   *%rax
  8022ab:	89 c3                	mov    %eax,%ebx
  8022ad:	85 c0                	test   %eax,%eax
  8022af:	78 1f                	js     8022d0 <open+0xa2>
    return fd2num(fd);
  8022b1:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8022b5:	48 b8 63 18 80 00 00 	movabs $0x801863,%rax
  8022bc:	00 00 00 
  8022bf:	ff d0                	call   *%rax
  8022c1:	89 c3                	mov    %eax,%ebx
}
  8022c3:	89 d8                	mov    %ebx,%eax
  8022c5:	48 83 c4 18          	add    $0x18,%rsp
  8022c9:	5b                   	pop    %rbx
  8022ca:	41 5c                	pop    %r12
  8022cc:	41 5d                	pop    %r13
  8022ce:	5d                   	pop    %rbp
  8022cf:	c3                   	ret
        fd_close(fd, 0);
  8022d0:	be 00 00 00 00       	mov    $0x0,%esi
  8022d5:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8022d9:	48 b8 c0 19 80 00 00 	movabs $0x8019c0,%rax
  8022e0:	00 00 00 
  8022e3:	ff d0                	call   *%rax
        return res;
  8022e5:	eb dc                	jmp    8022c3 <open+0x95>
        return -E_BAD_PATH;
  8022e7:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  8022ec:	eb d5                	jmp    8022c3 <open+0x95>

00000000008022ee <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  8022ee:	f3 0f 1e fa          	endbr64
  8022f2:	55                   	push   %rbp
  8022f3:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  8022f6:	be 00 00 00 00       	mov    $0x0,%esi
  8022fb:	bf 08 00 00 00       	mov    $0x8,%edi
  802300:	48 b8 9e 1f 80 00 00 	movabs $0x801f9e,%rax
  802307:	00 00 00 
  80230a:	ff d0                	call   *%rax
}
  80230c:	5d                   	pop    %rbp
  80230d:	c3                   	ret

000000000080230e <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  80230e:	f3 0f 1e fa          	endbr64
  802312:	55                   	push   %rbp
  802313:	48 89 e5             	mov    %rsp,%rbp
  802316:	41 54                	push   %r12
  802318:	53                   	push   %rbx
  802319:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  80231c:	48 b8 79 18 80 00 00 	movabs $0x801879,%rax
  802323:	00 00 00 
  802326:	ff d0                	call   *%rax
  802328:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  80232b:	48 be c7 32 80 00 00 	movabs $0x8032c7,%rsi
  802332:	00 00 00 
  802335:	48 89 df             	mov    %rbx,%rdi
  802338:	48 b8 9a 0e 80 00 00 	movabs $0x800e9a,%rax
  80233f:	00 00 00 
  802342:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  802344:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  802349:	41 2b 04 24          	sub    (%r12),%eax
  80234d:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  802353:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  80235a:	00 00 00 
    stat->st_dev = &devpipe;
  80235d:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  802364:	00 00 00 
  802367:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  80236e:	b8 00 00 00 00       	mov    $0x0,%eax
  802373:	5b                   	pop    %rbx
  802374:	41 5c                	pop    %r12
  802376:	5d                   	pop    %rbp
  802377:	c3                   	ret

0000000000802378 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  802378:	f3 0f 1e fa          	endbr64
  80237c:	55                   	push   %rbp
  80237d:	48 89 e5             	mov    %rsp,%rbp
  802380:	41 54                	push   %r12
  802382:	53                   	push   %rbx
  802383:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  802386:	ba 00 10 00 00       	mov    $0x1000,%edx
  80238b:	48 89 fe             	mov    %rdi,%rsi
  80238e:	bf 00 00 00 00       	mov    $0x0,%edi
  802393:	49 bc df 15 80 00 00 	movabs $0x8015df,%r12
  80239a:	00 00 00 
  80239d:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  8023a0:	48 89 df             	mov    %rbx,%rdi
  8023a3:	48 b8 79 18 80 00 00 	movabs $0x801879,%rax
  8023aa:	00 00 00 
  8023ad:	ff d0                	call   *%rax
  8023af:	48 89 c6             	mov    %rax,%rsi
  8023b2:	ba 00 10 00 00       	mov    $0x1000,%edx
  8023b7:	bf 00 00 00 00       	mov    $0x0,%edi
  8023bc:	41 ff d4             	call   *%r12
}
  8023bf:	5b                   	pop    %rbx
  8023c0:	41 5c                	pop    %r12
  8023c2:	5d                   	pop    %rbp
  8023c3:	c3                   	ret

00000000008023c4 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  8023c4:	f3 0f 1e fa          	endbr64
  8023c8:	55                   	push   %rbp
  8023c9:	48 89 e5             	mov    %rsp,%rbp
  8023cc:	41 57                	push   %r15
  8023ce:	41 56                	push   %r14
  8023d0:	41 55                	push   %r13
  8023d2:	41 54                	push   %r12
  8023d4:	53                   	push   %rbx
  8023d5:	48 83 ec 18          	sub    $0x18,%rsp
  8023d9:	49 89 fc             	mov    %rdi,%r12
  8023dc:	49 89 f5             	mov    %rsi,%r13
  8023df:	49 89 d7             	mov    %rdx,%r15
  8023e2:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8023e6:	48 b8 79 18 80 00 00 	movabs $0x801879,%rax
  8023ed:	00 00 00 
  8023f0:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  8023f2:	4d 85 ff             	test   %r15,%r15
  8023f5:	0f 84 af 00 00 00    	je     8024aa <devpipe_write+0xe6>
  8023fb:	48 89 c3             	mov    %rax,%rbx
  8023fe:	4c 89 f8             	mov    %r15,%rax
  802401:	4d 89 ef             	mov    %r13,%r15
  802404:	4c 01 e8             	add    %r13,%rax
  802407:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80240b:	49 bd 6f 14 80 00 00 	movabs $0x80146f,%r13
  802412:	00 00 00 
            sys_yield();
  802415:	49 be 04 14 80 00 00 	movabs $0x801404,%r14
  80241c:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  80241f:	8b 73 04             	mov    0x4(%rbx),%esi
  802422:	48 63 ce             	movslq %esi,%rcx
  802425:	48 63 03             	movslq (%rbx),%rax
  802428:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  80242e:	48 39 c1             	cmp    %rax,%rcx
  802431:	72 2e                	jb     802461 <devpipe_write+0x9d>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802433:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802438:	48 89 da             	mov    %rbx,%rdx
  80243b:	be 00 10 00 00       	mov    $0x1000,%esi
  802440:	4c 89 e7             	mov    %r12,%rdi
  802443:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802446:	85 c0                	test   %eax,%eax
  802448:	74 66                	je     8024b0 <devpipe_write+0xec>
            sys_yield();
  80244a:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  80244d:	8b 73 04             	mov    0x4(%rbx),%esi
  802450:	48 63 ce             	movslq %esi,%rcx
  802453:	48 63 03             	movslq (%rbx),%rax
  802456:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  80245c:	48 39 c1             	cmp    %rax,%rcx
  80245f:	73 d2                	jae    802433 <devpipe_write+0x6f>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802461:	41 0f b6 3f          	movzbl (%r15),%edi
  802465:	48 89 ca             	mov    %rcx,%rdx
  802468:	48 c1 ea 03          	shr    $0x3,%rdx
  80246c:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  802473:	08 10 20 
  802476:	48 f7 e2             	mul    %rdx
  802479:	48 c1 ea 06          	shr    $0x6,%rdx
  80247d:	48 89 d0             	mov    %rdx,%rax
  802480:	48 c1 e0 09          	shl    $0x9,%rax
  802484:	48 29 d0             	sub    %rdx,%rax
  802487:	48 c1 e0 03          	shl    $0x3,%rax
  80248b:	48 29 c1             	sub    %rax,%rcx
  80248e:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  802493:	83 c6 01             	add    $0x1,%esi
  802496:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  802499:	49 83 c7 01          	add    $0x1,%r15
  80249d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8024a1:	49 39 c7             	cmp    %rax,%r15
  8024a4:	0f 85 75 ff ff ff    	jne    80241f <devpipe_write+0x5b>
    return n;
  8024aa:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8024ae:	eb 05                	jmp    8024b5 <devpipe_write+0xf1>
            if (_pipeisclosed(fd, p)) return 0;
  8024b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024b5:	48 83 c4 18          	add    $0x18,%rsp
  8024b9:	5b                   	pop    %rbx
  8024ba:	41 5c                	pop    %r12
  8024bc:	41 5d                	pop    %r13
  8024be:	41 5e                	pop    %r14
  8024c0:	41 5f                	pop    %r15
  8024c2:	5d                   	pop    %rbp
  8024c3:	c3                   	ret

00000000008024c4 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  8024c4:	f3 0f 1e fa          	endbr64
  8024c8:	55                   	push   %rbp
  8024c9:	48 89 e5             	mov    %rsp,%rbp
  8024cc:	41 57                	push   %r15
  8024ce:	41 56                	push   %r14
  8024d0:	41 55                	push   %r13
  8024d2:	41 54                	push   %r12
  8024d4:	53                   	push   %rbx
  8024d5:	48 83 ec 18          	sub    $0x18,%rsp
  8024d9:	49 89 fc             	mov    %rdi,%r12
  8024dc:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  8024e0:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8024e4:	48 b8 79 18 80 00 00 	movabs $0x801879,%rax
  8024eb:	00 00 00 
  8024ee:	ff d0                	call   *%rax
  8024f0:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  8024f3:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8024f9:	49 bd 6f 14 80 00 00 	movabs $0x80146f,%r13
  802500:	00 00 00 
            sys_yield();
  802503:	49 be 04 14 80 00 00 	movabs $0x801404,%r14
  80250a:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  80250d:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  802512:	74 7d                	je     802591 <devpipe_read+0xcd>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802514:	8b 03                	mov    (%rbx),%eax
  802516:	3b 43 04             	cmp    0x4(%rbx),%eax
  802519:	75 26                	jne    802541 <devpipe_read+0x7d>
            if (i > 0) return i;
  80251b:	4d 85 ff             	test   %r15,%r15
  80251e:	75 77                	jne    802597 <devpipe_read+0xd3>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802520:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802525:	48 89 da             	mov    %rbx,%rdx
  802528:	be 00 10 00 00       	mov    $0x1000,%esi
  80252d:	4c 89 e7             	mov    %r12,%rdi
  802530:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802533:	85 c0                	test   %eax,%eax
  802535:	74 72                	je     8025a9 <devpipe_read+0xe5>
            sys_yield();
  802537:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  80253a:	8b 03                	mov    (%rbx),%eax
  80253c:	3b 43 04             	cmp    0x4(%rbx),%eax
  80253f:	74 df                	je     802520 <devpipe_read+0x5c>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802541:	48 63 c8             	movslq %eax,%rcx
  802544:	48 89 ca             	mov    %rcx,%rdx
  802547:	48 c1 ea 03          	shr    $0x3,%rdx
  80254b:	48 be 81 00 01 02 04 	movabs $0x2010080402010081,%rsi
  802552:	08 10 20 
  802555:	48 89 d0             	mov    %rdx,%rax
  802558:	48 f7 e6             	mul    %rsi
  80255b:	48 c1 ea 06          	shr    $0x6,%rdx
  80255f:	48 89 d0             	mov    %rdx,%rax
  802562:	48 c1 e0 09          	shl    $0x9,%rax
  802566:	48 29 d0             	sub    %rdx,%rax
  802569:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802570:	00 
  802571:	48 89 c8             	mov    %rcx,%rax
  802574:	48 29 d0             	sub    %rdx,%rax
  802577:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  80257c:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  802580:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  802584:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  802587:	49 83 c7 01          	add    $0x1,%r15
  80258b:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  80258f:	75 83                	jne    802514 <devpipe_read+0x50>
    return n;
  802591:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802595:	eb 03                	jmp    80259a <devpipe_read+0xd6>
            if (i > 0) return i;
  802597:	4c 89 f8             	mov    %r15,%rax
}
  80259a:	48 83 c4 18          	add    $0x18,%rsp
  80259e:	5b                   	pop    %rbx
  80259f:	41 5c                	pop    %r12
  8025a1:	41 5d                	pop    %r13
  8025a3:	41 5e                	pop    %r14
  8025a5:	41 5f                	pop    %r15
  8025a7:	5d                   	pop    %rbp
  8025a8:	c3                   	ret
            if (_pipeisclosed(fd, p)) return 0;
  8025a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ae:	eb ea                	jmp    80259a <devpipe_read+0xd6>

00000000008025b0 <pipe>:
pipe(int pfd[2]) {
  8025b0:	f3 0f 1e fa          	endbr64
  8025b4:	55                   	push   %rbp
  8025b5:	48 89 e5             	mov    %rsp,%rbp
  8025b8:	41 55                	push   %r13
  8025ba:	41 54                	push   %r12
  8025bc:	53                   	push   %rbx
  8025bd:	48 83 ec 18          	sub    $0x18,%rsp
  8025c1:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  8025c4:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  8025c8:	48 b8 99 18 80 00 00 	movabs $0x801899,%rax
  8025cf:	00 00 00 
  8025d2:	ff d0                	call   *%rax
  8025d4:	89 c3                	mov    %eax,%ebx
  8025d6:	85 c0                	test   %eax,%eax
  8025d8:	0f 88 a0 01 00 00    	js     80277e <pipe+0x1ce>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  8025de:	b9 46 00 00 00       	mov    $0x46,%ecx
  8025e3:	ba 00 10 00 00       	mov    $0x1000,%edx
  8025e8:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8025ec:	bf 00 00 00 00       	mov    $0x0,%edi
  8025f1:	48 b8 9f 14 80 00 00 	movabs $0x80149f,%rax
  8025f8:	00 00 00 
  8025fb:	ff d0                	call   *%rax
  8025fd:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  8025ff:	85 c0                	test   %eax,%eax
  802601:	0f 88 77 01 00 00    	js     80277e <pipe+0x1ce>
    if ((res = fd_alloc(&fd1)) < 0 ||
  802607:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  80260b:	48 b8 99 18 80 00 00 	movabs $0x801899,%rax
  802612:	00 00 00 
  802615:	ff d0                	call   *%rax
  802617:	89 c3                	mov    %eax,%ebx
  802619:	85 c0                	test   %eax,%eax
  80261b:	0f 88 43 01 00 00    	js     802764 <pipe+0x1b4>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  802621:	b9 46 00 00 00       	mov    $0x46,%ecx
  802626:	ba 00 10 00 00       	mov    $0x1000,%edx
  80262b:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80262f:	bf 00 00 00 00       	mov    $0x0,%edi
  802634:	48 b8 9f 14 80 00 00 	movabs $0x80149f,%rax
  80263b:	00 00 00 
  80263e:	ff d0                	call   *%rax
  802640:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  802642:	85 c0                	test   %eax,%eax
  802644:	0f 88 1a 01 00 00    	js     802764 <pipe+0x1b4>
    va = fd2data(fd0);
  80264a:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80264e:	48 b8 79 18 80 00 00 	movabs $0x801879,%rax
  802655:	00 00 00 
  802658:	ff d0                	call   *%rax
  80265a:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  80265d:	b9 46 00 00 00       	mov    $0x46,%ecx
  802662:	ba 00 10 00 00       	mov    $0x1000,%edx
  802667:	48 89 c6             	mov    %rax,%rsi
  80266a:	bf 00 00 00 00       	mov    $0x0,%edi
  80266f:	48 b8 9f 14 80 00 00 	movabs $0x80149f,%rax
  802676:	00 00 00 
  802679:	ff d0                	call   *%rax
  80267b:	89 c3                	mov    %eax,%ebx
  80267d:	85 c0                	test   %eax,%eax
  80267f:	0f 88 c5 00 00 00    	js     80274a <pipe+0x19a>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  802685:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802689:	48 b8 79 18 80 00 00 	movabs $0x801879,%rax
  802690:	00 00 00 
  802693:	ff d0                	call   *%rax
  802695:	48 89 c1             	mov    %rax,%rcx
  802698:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  80269e:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8026a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8026a9:	4c 89 ee             	mov    %r13,%rsi
  8026ac:	bf 00 00 00 00       	mov    $0x0,%edi
  8026b1:	48 b8 0a 15 80 00 00 	movabs $0x80150a,%rax
  8026b8:	00 00 00 
  8026bb:	ff d0                	call   *%rax
  8026bd:	89 c3                	mov    %eax,%ebx
  8026bf:	85 c0                	test   %eax,%eax
  8026c1:	78 6e                	js     802731 <pipe+0x181>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8026c3:	be 00 10 00 00       	mov    $0x1000,%esi
  8026c8:	4c 89 ef             	mov    %r13,%rdi
  8026cb:	48 b8 39 14 80 00 00 	movabs $0x801439,%rax
  8026d2:	00 00 00 
  8026d5:	ff d0                	call   *%rax
  8026d7:	83 f8 02             	cmp    $0x2,%eax
  8026da:	0f 85 ab 00 00 00    	jne    80278b <pipe+0x1db>
    fd0->fd_dev_id = devpipe.dev_id;
  8026e0:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  8026e7:	00 00 
  8026e9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8026ed:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  8026ef:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8026f3:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  8026fa:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8026fe:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  802700:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802704:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  80270b:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80270f:	48 bb 63 18 80 00 00 	movabs $0x801863,%rbx
  802716:	00 00 00 
  802719:	ff d3                	call   *%rbx
  80271b:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  80271f:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802723:	ff d3                	call   *%rbx
  802725:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  80272a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80272f:	eb 4d                	jmp    80277e <pipe+0x1ce>
    sys_unmap_region(0, va, PAGE_SIZE);
  802731:	ba 00 10 00 00       	mov    $0x1000,%edx
  802736:	4c 89 ee             	mov    %r13,%rsi
  802739:	bf 00 00 00 00       	mov    $0x0,%edi
  80273e:	48 b8 df 15 80 00 00 	movabs $0x8015df,%rax
  802745:	00 00 00 
  802748:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  80274a:	ba 00 10 00 00       	mov    $0x1000,%edx
  80274f:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802753:	bf 00 00 00 00       	mov    $0x0,%edi
  802758:	48 b8 df 15 80 00 00 	movabs $0x8015df,%rax
  80275f:	00 00 00 
  802762:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  802764:	ba 00 10 00 00       	mov    $0x1000,%edx
  802769:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80276d:	bf 00 00 00 00       	mov    $0x0,%edi
  802772:	48 b8 df 15 80 00 00 	movabs $0x8015df,%rax
  802779:	00 00 00 
  80277c:	ff d0                	call   *%rax
}
  80277e:	89 d8                	mov    %ebx,%eax
  802780:	48 83 c4 18          	add    $0x18,%rsp
  802784:	5b                   	pop    %rbx
  802785:	41 5c                	pop    %r12
  802787:	41 5d                	pop    %r13
  802789:	5d                   	pop    %rbp
  80278a:	c3                   	ret
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  80278b:	48 b9 e8 33 80 00 00 	movabs $0x8033e8,%rcx
  802792:	00 00 00 
  802795:	48 ba a7 32 80 00 00 	movabs $0x8032a7,%rdx
  80279c:	00 00 00 
  80279f:	be 2e 00 00 00       	mov    $0x2e,%esi
  8027a4:	48 bf ce 32 80 00 00 	movabs $0x8032ce,%rdi
  8027ab:	00 00 00 
  8027ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8027b3:	49 b8 f5 03 80 00 00 	movabs $0x8003f5,%r8
  8027ba:	00 00 00 
  8027bd:	41 ff d0             	call   *%r8

00000000008027c0 <pipeisclosed>:
pipeisclosed(int fdnum) {
  8027c0:	f3 0f 1e fa          	endbr64
  8027c4:	55                   	push   %rbp
  8027c5:	48 89 e5             	mov    %rsp,%rbp
  8027c8:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8027cc:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8027d0:	48 b8 fd 18 80 00 00 	movabs $0x8018fd,%rax
  8027d7:	00 00 00 
  8027da:	ff d0                	call   *%rax
    if (res < 0) return res;
  8027dc:	85 c0                	test   %eax,%eax
  8027de:	78 35                	js     802815 <pipeisclosed+0x55>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  8027e0:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8027e4:	48 b8 79 18 80 00 00 	movabs $0x801879,%rax
  8027eb:	00 00 00 
  8027ee:	ff d0                	call   *%rax
  8027f0:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8027f3:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8027f8:	be 00 10 00 00       	mov    $0x1000,%esi
  8027fd:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802801:	48 b8 6f 14 80 00 00 	movabs $0x80146f,%rax
  802808:	00 00 00 
  80280b:	ff d0                	call   *%rax
  80280d:	85 c0                	test   %eax,%eax
  80280f:	0f 94 c0             	sete   %al
  802812:	0f b6 c0             	movzbl %al,%eax
}
  802815:	c9                   	leave
  802816:	c3                   	ret

0000000000802817 <get_uvpt_entry>:
extern volatile pde_t uvpd[];     /* VA of current page directory */
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
  802817:	f3 0f 1e fa          	endbr64
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  80281b:	48 89 f8             	mov    %rdi,%rax
  80281e:	48 c1 e8 27          	shr    $0x27,%rax
  802822:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  802829:	7f 00 00 
  80282c:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802830:	f6 c2 01             	test   $0x1,%dl
  802833:	74 6d                	je     8028a2 <get_uvpt_entry+0x8b>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  802835:	48 89 f8             	mov    %rdi,%rax
  802838:	48 c1 e8 1e          	shr    $0x1e,%rax
  80283c:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  802843:	7f 00 00 
  802846:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80284a:	f6 c2 01             	test   $0x1,%dl
  80284d:	74 62                	je     8028b1 <get_uvpt_entry+0x9a>
  80284f:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  802856:	7f 00 00 
  802859:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80285d:	f6 c2 80             	test   $0x80,%dl
  802860:	75 4f                	jne    8028b1 <get_uvpt_entry+0x9a>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802862:	48 89 f8             	mov    %rdi,%rax
  802865:	48 c1 e8 15          	shr    $0x15,%rax
  802869:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802870:	7f 00 00 
  802873:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802877:	f6 c2 01             	test   $0x1,%dl
  80287a:	74 44                	je     8028c0 <get_uvpt_entry+0xa9>
  80287c:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802883:	7f 00 00 
  802886:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80288a:	f6 c2 80             	test   $0x80,%dl
  80288d:	75 31                	jne    8028c0 <get_uvpt_entry+0xa9>
    return uvpt[VPT(va)];
  80288f:	48 c1 ef 0c          	shr    $0xc,%rdi
  802893:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  80289a:	7f 00 00 
  80289d:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  8028a1:	c3                   	ret
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8028a2:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  8028a9:	7f 00 00 
  8028ac:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8028b0:	c3                   	ret
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8028b1:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  8028b8:	7f 00 00 
  8028bb:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8028bf:	c3                   	ret
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8028c0:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  8028c7:	7f 00 00 
  8028ca:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8028ce:	c3                   	ret

00000000008028cf <get_phys_addr>:

uintptr_t
get_phys_addr(void *va) {
  8028cf:	f3 0f 1e fa          	endbr64
  8028d3:	48 89 fa             	mov    %rdi,%rdx
    if (!(uvpml4[VPML4(va)] & PTE_P))
  8028d6:	48 89 f9             	mov    %rdi,%rcx
  8028d9:	48 c1 e9 27          	shr    $0x27,%rcx
  8028dd:	48 b8 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rax
  8028e4:	7f 00 00 
  8028e7:	48 8b 0c c8          	mov    (%rax,%rcx,8),%rcx
        return -1;
  8028eb:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpml4[VPML4(va)] & PTE_P))
  8028f2:	f6 c1 01             	test   $0x1,%cl
  8028f5:	0f 84 b2 00 00 00    	je     8029ad <get_phys_addr+0xde>
    if (!(uvpdp[VPDP(va)] & PTE_P))
  8028fb:	48 89 f9             	mov    %rdi,%rcx
  8028fe:	48 c1 e9 1e          	shr    $0x1e,%rcx
  802902:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802909:	7f 00 00 
  80290c:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  802910:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpdp[VPDP(va)] & PTE_P))
  802917:	40 f6 c6 01          	test   $0x1,%sil
  80291b:	0f 84 8c 00 00 00    	je     8029ad <get_phys_addr+0xde>
    if (uvpdp[VPDP(va)] & PTE_PS)
  802921:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802928:	7f 00 00 
  80292b:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  80292f:	a8 80                	test   $0x80,%al
  802931:	75 7b                	jne    8029ae <get_phys_addr+0xdf>
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
    if (!(uvpd[VPD(va)] & PTE_P))
  802933:	48 89 f9             	mov    %rdi,%rcx
  802936:	48 c1 e9 15          	shr    $0x15,%rcx
  80293a:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  802941:	7f 00 00 
  802944:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  802948:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpd[VPD(va)] & PTE_P))
  80294f:	40 f6 c6 01          	test   $0x1,%sil
  802953:	74 58                	je     8029ad <get_phys_addr+0xde>
    if ((uvpd[VPD(va)] & PTE_PS))
  802955:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  80295c:	7f 00 00 
  80295f:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802963:	a8 80                	test   $0x80,%al
  802965:	75 6c                	jne    8029d3 <get_phys_addr+0x104>
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
    if (!(uvpt[VPT(va)] & PTE_P))
  802967:	48 89 f9             	mov    %rdi,%rcx
  80296a:	48 c1 e9 0c          	shr    $0xc,%rcx
  80296e:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802975:	7f 00 00 
  802978:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  80297c:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpt[VPT(va)] & PTE_P))
  802983:	40 f6 c6 01          	test   $0x1,%sil
  802987:	74 24                	je     8029ad <get_phys_addr+0xde>
    return PTE_ADDR(uvpt[VPT(va)]) + PAGE_OFFSET(va);
  802989:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802990:	7f 00 00 
  802993:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802997:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  80299e:	ff ff 7f 
  8029a1:	48 21 c8             	and    %rcx,%rax
  8029a4:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  8029aa:	48 09 d0             	or     %rdx,%rax
}
  8029ad:	c3                   	ret
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
  8029ae:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  8029b5:	7f 00 00 
  8029b8:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8029bc:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  8029c3:	ff ff 7f 
  8029c6:	48 21 c8             	and    %rcx,%rax
  8029c9:	81 e2 ff ff ff 3f    	and    $0x3fffffff,%edx
  8029cf:	48 01 d0             	add    %rdx,%rax
  8029d2:	c3                   	ret
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
  8029d3:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  8029da:	7f 00 00 
  8029dd:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8029e1:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  8029e8:	ff ff 7f 
  8029eb:	48 21 c8             	and    %rcx,%rax
  8029ee:	81 e2 ff ff 1f 00    	and    $0x1fffff,%edx
  8029f4:	48 01 d0             	add    %rdx,%rax
  8029f7:	c3                   	ret

00000000008029f8 <get_prot>:

int
get_prot(void *va) {
  8029f8:	f3 0f 1e fa          	endbr64
  8029fc:	55                   	push   %rbp
  8029fd:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802a00:	48 b8 17 28 80 00 00 	movabs $0x802817,%rax
  802a07:	00 00 00 
  802a0a:	ff d0                	call   *%rax
  802a0c:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
    if (pte & PTE_P) prot |= PROT_R;
  802a0f:	83 e0 01             	and    $0x1,%eax
  802a12:	c1 e0 02             	shl    $0x2,%eax
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  802a15:	89 d1                	mov    %edx,%ecx
  802a17:	81 e1 00 0a 00 00    	and    $0xa00,%ecx
    if (pte & PTE_P) prot |= PROT_R;
  802a1d:	09 c8                	or     %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  802a1f:	89 c1                	mov    %eax,%ecx
  802a21:	83 c9 02             	or     $0x2,%ecx
  802a24:	f6 c2 02             	test   $0x2,%dl
  802a27:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  802a2a:	89 c1                	mov    %eax,%ecx
  802a2c:	83 c9 01             	or     $0x1,%ecx
  802a2f:	48 85 d2             	test   %rdx,%rdx
  802a32:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  802a35:	89 c1                	mov    %eax,%ecx
  802a37:	83 c9 40             	or     $0x40,%ecx
  802a3a:	f6 c6 04             	test   $0x4,%dh
  802a3d:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  802a40:	5d                   	pop    %rbp
  802a41:	c3                   	ret

0000000000802a42 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  802a42:	f3 0f 1e fa          	endbr64
  802a46:	55                   	push   %rbp
  802a47:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802a4a:	48 b8 17 28 80 00 00 	movabs $0x802817,%rax
  802a51:	00 00 00 
  802a54:	ff d0                	call   *%rax
    return pte & PTE_D;
  802a56:	48 c1 e8 06          	shr    $0x6,%rax
  802a5a:	83 e0 01             	and    $0x1,%eax
}
  802a5d:	5d                   	pop    %rbp
  802a5e:	c3                   	ret

0000000000802a5f <is_page_present>:

bool
is_page_present(void *va) {
  802a5f:	f3 0f 1e fa          	endbr64
  802a63:	55                   	push   %rbp
  802a64:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  802a67:	48 b8 17 28 80 00 00 	movabs $0x802817,%rax
  802a6e:	00 00 00 
  802a71:	ff d0                	call   *%rax
  802a73:	83 e0 01             	and    $0x1,%eax
}
  802a76:	5d                   	pop    %rbp
  802a77:	c3                   	ret

0000000000802a78 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  802a78:	f3 0f 1e fa          	endbr64
  802a7c:	55                   	push   %rbp
  802a7d:	48 89 e5             	mov    %rsp,%rbp
  802a80:	41 57                	push   %r15
  802a82:	41 56                	push   %r14
  802a84:	41 55                	push   %r13
  802a86:	41 54                	push   %r12
  802a88:	53                   	push   %rbx
  802a89:	48 83 ec 18          	sub    $0x18,%rsp
  802a8d:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  802a91:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
     * NOTE: Skip over larger pages/page directories for efficiency */
    // LAB 11: Your code here:

    int res = 0;
    (void)fun, (void)arg;
    uintptr_t va = 0;
  802a95:	bb 00 00 00 00       	mov    $0x0,%ebx
    while (va < USER_STACK_TOP) {
        size_t size = 0;
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  802a9a:	49 be 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%r14
  802aa1:	7f 00 00 
            size = 1LL << PML4_SHIFT;
            goto next;
        }

        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802aa4:	49 bd 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%r13
  802aab:	7f 00 00 
    while (va < USER_STACK_TOP) {
  802aae:	49 bf ff 6f ff ff 7f 	movabs $0x7fffff6fff,%r15
  802ab5:	00 00 00 
  802ab8:	eb 73                	jmp    802b2d <foreach_shared_region+0xb5>
            }

            goto next;
        }

        if (!(uvpd[VPD(va)] & PTE_P)) {
  802aba:	48 89 d8             	mov    %rbx,%rax
  802abd:	48 c1 e8 15          	shr    $0x15,%rax
  802ac1:	48 b9 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rcx
  802ac8:	7f 00 00 
  802acb:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
            size = 1LL << PD_SHIFT;
  802acf:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
        if (!(uvpd[VPD(va)] & PTE_P)) {
  802ad5:	f6 c2 01             	test   $0x1,%dl
  802ad8:	74 4b                	je     802b25 <foreach_shared_region+0xad>
            goto next;
        }

        if (uvpd[VPD(va)] & PTE_PS) {
  802ada:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
  802ade:	f6 c2 80             	test   $0x80,%dl
  802ae1:	74 11                	je     802af4 <foreach_shared_region+0x7c>
            size = 1LL << PD_SHIFT;
            if (uvpd[VPD(va)] & PTE_SHARE) {
  802ae3:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
  802ae7:	f6 c4 04             	test   $0x4,%ah
  802aea:	74 39                	je     802b25 <foreach_shared_region+0xad>
            size = 1LL << PD_SHIFT;
  802aec:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
  802af2:	eb 20                	jmp    802b14 <foreach_shared_region+0x9c>

            goto next;
        }

        size = PAGE_SIZE;
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  802af4:	48 89 da             	mov    %rbx,%rdx
  802af7:	48 c1 ea 0c          	shr    $0xc,%rdx
  802afb:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802b02:	7f 00 00 
  802b05:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
        size = PAGE_SIZE;
  802b09:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  802b0f:	f6 c4 04             	test   $0x4,%ah
  802b12:	74 11                	je     802b25 <foreach_shared_region+0xad>
            goto next;
        }

    map:
        fun((void *)va, (void *)(va + size), arg);
  802b14:	49 8d 34 1c          	lea    (%r12,%rbx,1),%rsi
  802b18:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802b1c:	48 89 df             	mov    %rbx,%rdi
  802b1f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802b23:	ff d0                	call   *%rax
    next:
        va += size;
  802b25:	4c 01 e3             	add    %r12,%rbx
    while (va < USER_STACK_TOP) {
  802b28:	49 39 df             	cmp    %rbx,%r15
  802b2b:	72 3e                	jb     802b6b <foreach_shared_region+0xf3>
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  802b2d:	49 8b 06             	mov    (%r14),%rax
  802b30:	a8 01                	test   $0x1,%al
  802b32:	74 37                	je     802b6b <foreach_shared_region+0xf3>
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802b34:	48 89 d8             	mov    %rbx,%rax
  802b37:	48 c1 e8 1e          	shr    $0x1e,%rax
  802b3b:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
            size = 1LL << PDP_SHIFT;
  802b40:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802b46:	f6 c2 01             	test   $0x1,%dl
  802b49:	74 da                	je     802b25 <foreach_shared_region+0xad>
        if (uvpdp[VPDP(va)] & PTE_PS) {
  802b4b:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
  802b50:	f6 c2 80             	test   $0x80,%dl
  802b53:	0f 84 61 ff ff ff    	je     802aba <foreach_shared_region+0x42>
            if (uvpdp[VPDP(va)] & PTE_SHARE) {
  802b59:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  802b5e:	f6 c4 04             	test   $0x4,%ah
  802b61:	74 c2                	je     802b25 <foreach_shared_region+0xad>
            size = 1LL << PDP_SHIFT;
  802b63:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
  802b69:	eb a9                	jmp    802b14 <foreach_shared_region+0x9c>
    }
    return res;
}
  802b6b:	b8 00 00 00 00       	mov    $0x0,%eax
  802b70:	48 83 c4 18          	add    $0x18,%rsp
  802b74:	5b                   	pop    %rbx
  802b75:	41 5c                	pop    %r12
  802b77:	41 5d                	pop    %r13
  802b79:	41 5e                	pop    %r14
  802b7b:	41 5f                	pop    %r15
  802b7d:	5d                   	pop    %rbp
  802b7e:	c3                   	ret

0000000000802b7f <devcons_close>:

    return res;
}

static int
devcons_close(struct Fd *fd) {
  802b7f:	f3 0f 1e fa          	endbr64
    USED(fd);

    return 0;
}
  802b83:	b8 00 00 00 00       	mov    $0x0,%eax
  802b88:	c3                   	ret

0000000000802b89 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  802b89:	f3 0f 1e fa          	endbr64
  802b8d:	55                   	push   %rbp
  802b8e:	48 89 e5             	mov    %rsp,%rbp
  802b91:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  802b94:	48 be de 32 80 00 00 	movabs $0x8032de,%rsi
  802b9b:	00 00 00 
  802b9e:	48 b8 9a 0e 80 00 00 	movabs $0x800e9a,%rax
  802ba5:	00 00 00 
  802ba8:	ff d0                	call   *%rax
    return 0;
}
  802baa:	b8 00 00 00 00       	mov    $0x0,%eax
  802baf:	5d                   	pop    %rbp
  802bb0:	c3                   	ret

0000000000802bb1 <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  802bb1:	f3 0f 1e fa          	endbr64
  802bb5:	55                   	push   %rbp
  802bb6:	48 89 e5             	mov    %rsp,%rbp
  802bb9:	41 57                	push   %r15
  802bbb:	41 56                	push   %r14
  802bbd:	41 55                	push   %r13
  802bbf:	41 54                	push   %r12
  802bc1:	53                   	push   %rbx
  802bc2:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  802bc9:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  802bd0:	48 85 d2             	test   %rdx,%rdx
  802bd3:	74 7a                	je     802c4f <devcons_write+0x9e>
  802bd5:	49 89 d6             	mov    %rdx,%r14
  802bd8:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802bde:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  802be3:	49 bf b5 10 80 00 00 	movabs $0x8010b5,%r15
  802bea:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  802bed:	4c 89 f3             	mov    %r14,%rbx
  802bf0:	48 29 f3             	sub    %rsi,%rbx
  802bf3:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802bf8:	48 39 c3             	cmp    %rax,%rbx
  802bfb:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  802bff:	4c 63 eb             	movslq %ebx,%r13
  802c02:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  802c09:	48 01 c6             	add    %rax,%rsi
  802c0c:	4c 89 ea             	mov    %r13,%rdx
  802c0f:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802c16:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  802c19:	4c 89 ee             	mov    %r13,%rsi
  802c1c:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802c23:	48 b8 fa 12 80 00 00 	movabs $0x8012fa,%rax
  802c2a:	00 00 00 
  802c2d:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  802c2f:	41 01 dc             	add    %ebx,%r12d
  802c32:	49 63 f4             	movslq %r12d,%rsi
  802c35:	4c 39 f6             	cmp    %r14,%rsi
  802c38:	72 b3                	jb     802bed <devcons_write+0x3c>
    return res;
  802c3a:	49 63 c4             	movslq %r12d,%rax
}
  802c3d:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  802c44:	5b                   	pop    %rbx
  802c45:	41 5c                	pop    %r12
  802c47:	41 5d                	pop    %r13
  802c49:	41 5e                	pop    %r14
  802c4b:	41 5f                	pop    %r15
  802c4d:	5d                   	pop    %rbp
  802c4e:	c3                   	ret
    for (res = 0; res < n; res += inc) {
  802c4f:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802c55:	eb e3                	jmp    802c3a <devcons_write+0x89>

0000000000802c57 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802c57:	f3 0f 1e fa          	endbr64
  802c5b:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  802c5e:	ba 00 00 00 00       	mov    $0x0,%edx
  802c63:	48 85 c0             	test   %rax,%rax
  802c66:	74 55                	je     802cbd <devcons_read+0x66>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802c68:	55                   	push   %rbp
  802c69:	48 89 e5             	mov    %rsp,%rbp
  802c6c:	41 55                	push   %r13
  802c6e:	41 54                	push   %r12
  802c70:	53                   	push   %rbx
  802c71:	48 83 ec 08          	sub    $0x8,%rsp
  802c75:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  802c78:	48 bb 2b 13 80 00 00 	movabs $0x80132b,%rbx
  802c7f:	00 00 00 
  802c82:	49 bc 04 14 80 00 00 	movabs $0x801404,%r12
  802c89:	00 00 00 
  802c8c:	eb 03                	jmp    802c91 <devcons_read+0x3a>
  802c8e:	41 ff d4             	call   *%r12
  802c91:	ff d3                	call   *%rbx
  802c93:	85 c0                	test   %eax,%eax
  802c95:	74 f7                	je     802c8e <devcons_read+0x37>
    if (c < 0) return c;
  802c97:	48 63 d0             	movslq %eax,%rdx
  802c9a:	78 13                	js     802caf <devcons_read+0x58>
    if (c == 0x04) return 0;
  802c9c:	ba 00 00 00 00       	mov    $0x0,%edx
  802ca1:	83 f8 04             	cmp    $0x4,%eax
  802ca4:	74 09                	je     802caf <devcons_read+0x58>
    *(char *)vbuf = (char)c;
  802ca6:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  802caa:	ba 01 00 00 00       	mov    $0x1,%edx
}
  802caf:	48 89 d0             	mov    %rdx,%rax
  802cb2:	48 83 c4 08          	add    $0x8,%rsp
  802cb6:	5b                   	pop    %rbx
  802cb7:	41 5c                	pop    %r12
  802cb9:	41 5d                	pop    %r13
  802cbb:	5d                   	pop    %rbp
  802cbc:	c3                   	ret
  802cbd:	48 89 d0             	mov    %rdx,%rax
  802cc0:	c3                   	ret

0000000000802cc1 <cputchar>:
cputchar(int ch) {
  802cc1:	f3 0f 1e fa          	endbr64
  802cc5:	55                   	push   %rbp
  802cc6:	48 89 e5             	mov    %rsp,%rbp
  802cc9:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  802ccd:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  802cd1:	be 01 00 00 00       	mov    $0x1,%esi
  802cd6:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  802cda:	48 b8 fa 12 80 00 00 	movabs $0x8012fa,%rax
  802ce1:	00 00 00 
  802ce4:	ff d0                	call   *%rax
}
  802ce6:	c9                   	leave
  802ce7:	c3                   	ret

0000000000802ce8 <getchar>:
getchar(void) {
  802ce8:	f3 0f 1e fa          	endbr64
  802cec:	55                   	push   %rbp
  802ced:	48 89 e5             	mov    %rsp,%rbp
  802cf0:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  802cf4:	ba 01 00 00 00       	mov    $0x1,%edx
  802cf9:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  802cfd:	bf 00 00 00 00       	mov    $0x0,%edi
  802d02:	48 b8 f8 1b 80 00 00 	movabs $0x801bf8,%rax
  802d09:	00 00 00 
  802d0c:	ff d0                	call   *%rax
  802d0e:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  802d10:	85 c0                	test   %eax,%eax
  802d12:	78 06                	js     802d1a <getchar+0x32>
  802d14:	74 08                	je     802d1e <getchar+0x36>
  802d16:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  802d1a:	89 d0                	mov    %edx,%eax
  802d1c:	c9                   	leave
  802d1d:	c3                   	ret
    return res < 0 ? res : res ? c :
  802d1e:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  802d23:	eb f5                	jmp    802d1a <getchar+0x32>

0000000000802d25 <iscons>:
iscons(int fdnum) {
  802d25:	f3 0f 1e fa          	endbr64
  802d29:	55                   	push   %rbp
  802d2a:	48 89 e5             	mov    %rsp,%rbp
  802d2d:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802d31:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802d35:	48 b8 fd 18 80 00 00 	movabs $0x8018fd,%rax
  802d3c:	00 00 00 
  802d3f:	ff d0                	call   *%rax
    if (res < 0) return res;
  802d41:	85 c0                	test   %eax,%eax
  802d43:	78 18                	js     802d5d <iscons+0x38>
    return fd->fd_dev_id == devcons.dev_id;
  802d45:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802d49:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  802d50:	00 00 00 
  802d53:	8b 00                	mov    (%rax),%eax
  802d55:	39 02                	cmp    %eax,(%rdx)
  802d57:	0f 94 c0             	sete   %al
  802d5a:	0f b6 c0             	movzbl %al,%eax
}
  802d5d:	c9                   	leave
  802d5e:	c3                   	ret

0000000000802d5f <opencons>:
opencons(void) {
  802d5f:	f3 0f 1e fa          	endbr64
  802d63:	55                   	push   %rbp
  802d64:	48 89 e5             	mov    %rsp,%rbp
  802d67:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  802d6b:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  802d6f:	48 b8 99 18 80 00 00 	movabs $0x801899,%rax
  802d76:	00 00 00 
  802d79:	ff d0                	call   *%rax
  802d7b:	85 c0                	test   %eax,%eax
  802d7d:	78 49                	js     802dc8 <opencons+0x69>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  802d7f:	b9 46 00 00 00       	mov    $0x46,%ecx
  802d84:	ba 00 10 00 00       	mov    $0x1000,%edx
  802d89:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  802d8d:	bf 00 00 00 00       	mov    $0x0,%edi
  802d92:	48 b8 9f 14 80 00 00 	movabs $0x80149f,%rax
  802d99:	00 00 00 
  802d9c:	ff d0                	call   *%rax
  802d9e:	85 c0                	test   %eax,%eax
  802da0:	78 26                	js     802dc8 <opencons+0x69>
    fd->fd_dev_id = devcons.dev_id;
  802da2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802da6:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  802dad:	00 00 
  802daf:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  802db1:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802db5:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  802dbc:	48 b8 63 18 80 00 00 	movabs $0x801863,%rax
  802dc3:	00 00 00 
  802dc6:	ff d0                	call   *%rax
}
  802dc8:	c9                   	leave
  802dc9:	c3                   	ret

0000000000802dca <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802dca:	f3 0f 1e fa          	endbr64
  802dce:	55                   	push   %rbp
  802dcf:	48 89 e5             	mov    %rsp,%rbp
  802dd2:	41 54                	push   %r12
  802dd4:	53                   	push   %rbx
  802dd5:	48 89 fb             	mov    %rdi,%rbx
  802dd8:	48 89 f7             	mov    %rsi,%rdi
  802ddb:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802dde:	48 85 f6             	test   %rsi,%rsi
  802de1:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802de8:	00 00 00 
  802deb:	48 0f 44 f8          	cmove  %rax,%rdi
    }
    int res = sys_ipc_recv(pg, PAGE_SIZE);
  802def:	be 00 10 00 00       	mov    $0x1000,%esi
  802df4:	48 b8 c1 17 80 00 00 	movabs $0x8017c1,%rax
  802dfb:	00 00 00 
  802dfe:	ff d0                	call   *%rax
    if (res < 0) {
  802e00:	85 c0                	test   %eax,%eax
  802e02:	78 45                	js     802e49 <ipc_recv+0x7f>
        if (perm_store != NULL) {
            *perm_store = 0;
        }
        return res;
    } else {
        if (from_env_store != NULL) {
  802e04:	48 85 db             	test   %rbx,%rbx
  802e07:	74 12                	je     802e1b <ipc_recv+0x51>
            *from_env_store = thisenv->env_ipc_from;
  802e09:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802e10:	00 00 00 
  802e13:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  802e19:	89 03                	mov    %eax,(%rbx)
        }
        if (perm_store != NULL) {
  802e1b:	4d 85 e4             	test   %r12,%r12
  802e1e:	74 14                	je     802e34 <ipc_recv+0x6a>
            *perm_store = thisenv->env_ipc_perm;
  802e20:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802e27:	00 00 00 
  802e2a:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  802e30:	41 89 04 24          	mov    %eax,(%r12)
        }
        return thisenv->env_ipc_value;
  802e34:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802e3b:	00 00 00 
  802e3e:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
    }
    return -1;
}
  802e44:	5b                   	pop    %rbx
  802e45:	41 5c                	pop    %r12
  802e47:	5d                   	pop    %rbp
  802e48:	c3                   	ret
        if (from_env_store != NULL) {
  802e49:	48 85 db             	test   %rbx,%rbx
  802e4c:	74 06                	je     802e54 <ipc_recv+0x8a>
            *from_env_store = 0;
  802e4e:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store != NULL) {
  802e54:	4d 85 e4             	test   %r12,%r12
  802e57:	74 eb                	je     802e44 <ipc_recv+0x7a>
            *perm_store = 0;
  802e59:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  802e60:	00 
  802e61:	eb e1                	jmp    802e44 <ipc_recv+0x7a>

0000000000802e63 <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  802e63:	f3 0f 1e fa          	endbr64
  802e67:	55                   	push   %rbp
  802e68:	48 89 e5             	mov    %rsp,%rbp
  802e6b:	41 57                	push   %r15
  802e6d:	41 56                	push   %r14
  802e6f:	41 55                	push   %r13
  802e71:	41 54                	push   %r12
  802e73:	53                   	push   %rbx
  802e74:	48 83 ec 18          	sub    $0x18,%rsp
  802e78:	89 7d c4             	mov    %edi,-0x3c(%rbp)
  802e7b:	48 89 d3             	mov    %rdx,%rbx
  802e7e:	49 89 cc             	mov    %rcx,%r12
  802e81:	45 89 c5             	mov    %r8d,%r13d
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802e84:	48 85 d2             	test   %rdx,%rdx
  802e87:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802e8e:	00 00 00 
  802e91:	48 0f 44 d8          	cmove  %rax,%rbx
    }
    int res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802e95:	89 f0                	mov    %esi,%eax
  802e97:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  802e9b:	48 89 da             	mov    %rbx,%rdx
  802e9e:	48 89 c6             	mov    %rax,%rsi
  802ea1:	48 b8 91 17 80 00 00 	movabs $0x801791,%rax
  802ea8:	00 00 00 
  802eab:	ff d0                	call   *%rax
    while (res < 0) {
  802ead:	85 c0                	test   %eax,%eax
  802eaf:	79 65                	jns    802f16 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802eb1:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802eb4:	75 33                	jne    802ee9 <ipc_send+0x86>
            panic("Error: %i\n", res);
        }
        sys_yield();
  802eb6:	49 bf 04 14 80 00 00 	movabs $0x801404,%r15
  802ebd:	00 00 00 
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802ec0:	49 be 91 17 80 00 00 	movabs $0x801791,%r14
  802ec7:	00 00 00 
        sys_yield();
  802eca:	41 ff d7             	call   *%r15
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802ecd:	45 89 e8             	mov    %r13d,%r8d
  802ed0:	4c 89 e1             	mov    %r12,%rcx
  802ed3:	48 89 da             	mov    %rbx,%rdx
  802ed6:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  802eda:	8b 7d c4             	mov    -0x3c(%rbp),%edi
  802edd:	41 ff d6             	call   *%r14
    while (res < 0) {
  802ee0:	85 c0                	test   %eax,%eax
  802ee2:	79 32                	jns    802f16 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802ee4:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802ee7:	74 e1                	je     802eca <ipc_send+0x67>
            panic("Error: %i\n", res);
  802ee9:	89 c1                	mov    %eax,%ecx
  802eeb:	48 ba ea 32 80 00 00 	movabs $0x8032ea,%rdx
  802ef2:	00 00 00 
  802ef5:	be 42 00 00 00       	mov    $0x42,%esi
  802efa:	48 bf f5 32 80 00 00 	movabs $0x8032f5,%rdi
  802f01:	00 00 00 
  802f04:	b8 00 00 00 00       	mov    $0x0,%eax
  802f09:	49 b8 f5 03 80 00 00 	movabs $0x8003f5,%r8
  802f10:	00 00 00 
  802f13:	41 ff d0             	call   *%r8
    }
}
  802f16:	48 83 c4 18          	add    $0x18,%rsp
  802f1a:	5b                   	pop    %rbx
  802f1b:	41 5c                	pop    %r12
  802f1d:	41 5d                	pop    %r13
  802f1f:	41 5e                	pop    %r14
  802f21:	41 5f                	pop    %r15
  802f23:	5d                   	pop    %rbp
  802f24:	c3                   	ret

0000000000802f25 <ipc_find_env>:

/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
  802f25:	f3 0f 1e fa          	endbr64
    for (size_t i = 0; i < NENV; i++)
  802f29:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  802f2e:	48 b9 00 00 a0 1f 80 	movabs $0x801fa00000,%rcx
  802f35:	00 00 00 
  802f38:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802f3c:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802f40:	48 c1 e2 04          	shl    $0x4,%rdx
  802f44:	48 01 ca             	add    %rcx,%rdx
  802f47:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  802f4d:	39 fa                	cmp    %edi,%edx
  802f4f:	74 12                	je     802f63 <ipc_find_env+0x3e>
    for (size_t i = 0; i < NENV; i++)
  802f51:	48 83 c0 01          	add    $0x1,%rax
  802f55:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  802f5b:	75 db                	jne    802f38 <ipc_find_env+0x13>
            return envs[i].env_id;
    return 0;
  802f5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f62:	c3                   	ret
            return envs[i].env_id;
  802f63:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802f67:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802f6b:	48 c1 e2 04          	shl    $0x4,%rdx
  802f6f:	48 b8 00 00 a0 1f 80 	movabs $0x801fa00000,%rax
  802f76:	00 00 00 
  802f79:	48 01 d0             	add    %rdx,%rax
  802f7c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802f82:	c3                   	ret

0000000000802f83 <__text_end>:
  802f83:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f8a:	00 00 00 
  802f8d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f94:	00 00 00 
  802f97:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f9e:	00 00 00 
  802fa1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fa8:	00 00 00 
  802fab:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fb2:	00 00 00 
  802fb5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fbc:	00 00 00 
  802fbf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fc6:	00 00 00 
  802fc9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fd0:	00 00 00 
  802fd3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fda:	00 00 00 
  802fdd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fe4:	00 00 00 
  802fe7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fee:	00 00 00 
  802ff1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ff8:	00 00 00 
  802ffb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
