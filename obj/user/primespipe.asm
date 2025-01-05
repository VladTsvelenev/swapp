
obj/user/primespipe:     file format elf64-x86-64


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
  80001e:	e8 3e 03 00 00       	call   800361 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <primeproc>:
 * of main and user/idle. */

#include <inc/lib.h>

unsigned
primeproc(int fd) {
  800025:	f3 0f 1e fa          	endbr64
  800029:	55                   	push   %rbp
  80002a:	48 89 e5             	mov    %rsp,%rbp
  80002d:	41 57                	push   %r15
  80002f:	41 56                	push   %r14
  800031:	41 55                	push   %r13
  800033:	41 54                	push   %r12
  800035:	53                   	push   %rbx
  800036:	48 83 ec 18          	sub    $0x18,%rsp
  80003a:	89 fb                	mov    %edi,%ebx
    int id, p, pfd[2], wfd, r;

    /* Fetch a prime from our left neighbor */
top:
    if ((r = readn(fd, &p, 4)) != 4)
  80003c:	49 bc 5b 1e 80 00 00 	movabs $0x801e5b,%r12
  800043:	00 00 00 
        panic("primeproc could not read initial prime: %d, %i", r, r >= 0 ? 0 : r);

    cprintf("%d\n", p);
  800046:	49 bf 4a 41 80 00 00 	movabs $0x80414a,%r15
  80004d:	00 00 00 
  800050:	49 be 96 05 80 00 00 	movabs $0x800596,%r14
  800057:	00 00 00 

    /* Fork a right neighbor to continue the chain */
    if ((r = pipe(pfd)) < 0)
  80005a:	49 bd 51 27 80 00 00 	movabs $0x802751,%r13
  800061:	00 00 00 
    if ((r = readn(fd, &p, 4)) != 4)
  800064:	ba 04 00 00 00       	mov    $0x4,%edx
  800069:	48 8d 75 cc          	lea    -0x34(%rbp),%rsi
  80006d:	89 df                	mov    %ebx,%edi
  80006f:	41 ff d4             	call   *%r12
  800072:	89 c1                	mov    %eax,%ecx
  800074:	83 f8 04             	cmp    $0x4,%eax
  800077:	75 4b                	jne    8000c4 <primeproc+0x9f>
    cprintf("%d\n", p);
  800079:	8b 75 cc             	mov    -0x34(%rbp),%esi
  80007c:	4c 89 ff             	mov    %r15,%rdi
  80007f:	b8 00 00 00 00       	mov    $0x0,%eax
  800084:	41 ff d6             	call   *%r14
    if ((r = pipe(pfd)) < 0)
  800087:	48 8d 7d c4          	lea    -0x3c(%rbp),%rdi
  80008b:	41 ff d5             	call   *%r13
  80008e:	85 c0                	test   %eax,%eax
  800090:	78 69                	js     8000fb <primeproc+0xd6>
        panic("pipe: %i", r);
    if ((id = fork()) < 0)
  800092:	48 b8 a8 18 80 00 00 	movabs $0x8018a8,%rax
  800099:	00 00 00 
  80009c:	ff d0                	call   *%rax
  80009e:	85 c0                	test   %eax,%eax
  8000a0:	0f 88 82 00 00 00    	js     800128 <primeproc+0x103>
        panic("fork: %i", id);
    if (id == 0) {
  8000a6:	0f 85 a9 00 00 00    	jne    800155 <primeproc+0x130>
        close(fd);
  8000ac:	89 df                	mov    %ebx,%edi
  8000ae:	48 bb 0f 1c 80 00 00 	movabs $0x801c0f,%rbx
  8000b5:	00 00 00 
  8000b8:	ff d3                	call   *%rbx
        close(pfd[1]);
  8000ba:	8b 7d c8             	mov    -0x38(%rbp),%edi
  8000bd:	ff d3                	call   *%rbx
        fd = pfd[0];
  8000bf:	8b 5d c4             	mov    -0x3c(%rbp),%ebx
        goto top;
  8000c2:	eb a0                	jmp    800064 <primeproc+0x3f>
        panic("primeproc could not read initial prime: %d, %i", r, r >= 0 ? 0 : r);
  8000c4:	85 c0                	test   %eax,%eax
  8000c6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8000cc:	44 0f 4e c0          	cmovle %eax,%r8d
  8000d0:	48 ba 00 40 80 00 00 	movabs $0x804000,%rdx
  8000d7:	00 00 00 
  8000da:	be 14 00 00 00       	mov    $0x14,%esi
  8000df:	48 bf 38 41 80 00 00 	movabs $0x804138,%rdi
  8000e6:	00 00 00 
  8000e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ee:	49 b9 3a 04 80 00 00 	movabs $0x80043a,%r9
  8000f5:	00 00 00 
  8000f8:	41 ff d1             	call   *%r9
        panic("pipe: %i", r);
  8000fb:	89 c1                	mov    %eax,%ecx
  8000fd:	48 ba 4e 41 80 00 00 	movabs $0x80414e,%rdx
  800104:	00 00 00 
  800107:	be 1a 00 00 00       	mov    $0x1a,%esi
  80010c:	48 bf 38 41 80 00 00 	movabs $0x804138,%rdi
  800113:	00 00 00 
  800116:	b8 00 00 00 00       	mov    $0x0,%eax
  80011b:	49 b8 3a 04 80 00 00 	movabs $0x80043a,%r8
  800122:	00 00 00 
  800125:	41 ff d0             	call   *%r8
        panic("fork: %i", id);
  800128:	89 c1                	mov    %eax,%ecx
  80012a:	48 ba 57 41 80 00 00 	movabs $0x804157,%rdx
  800131:	00 00 00 
  800134:	be 1c 00 00 00       	mov    $0x1c,%esi
  800139:	48 bf 38 41 80 00 00 	movabs $0x804138,%rdi
  800140:	00 00 00 
  800143:	b8 00 00 00 00       	mov    $0x0,%eax
  800148:	49 b8 3a 04 80 00 00 	movabs $0x80043a,%r8
  80014f:	00 00 00 
  800152:	41 ff d0             	call   *%r8
    }

    close(pfd[0]);
  800155:	8b 7d c4             	mov    -0x3c(%rbp),%edi
  800158:	48 b8 0f 1c 80 00 00 	movabs $0x801c0f,%rax
  80015f:	00 00 00 
  800162:	ff d0                	call   *%rax
    wfd = pfd[1];
  800164:	44 8b 6d c8          	mov    -0x38(%rbp),%r13d

    /* Filter out multiples of our prime */
    for (int i;;) {
        if ((r = readn(fd, &i, 4)) != 4)
  800168:	49 bc 5b 1e 80 00 00 	movabs $0x801e5b,%r12
  80016f:	00 00 00 
  800172:	ba 04 00 00 00       	mov    $0x4,%edx
  800177:	48 8d 75 c0          	lea    -0x40(%rbp),%rsi
  80017b:	89 df                	mov    %ebx,%edi
  80017d:	41 ff d4             	call   *%r12
  800180:	83 f8 04             	cmp    $0x4,%eax
  800183:	75 65                	jne    8001ea <primeproc+0x1c5>
            panic("primeproc %d readn %d %d %i", p, fd, r, r >= 0 ? 0 : r);
        if (i % p)
  800185:	8b 45 c0             	mov    -0x40(%rbp),%eax
  800188:	99                   	cltd
  800189:	f7 7d cc             	idivl  -0x34(%rbp)
  80018c:	85 d2                	test   %edx,%edx
  80018e:	74 e2                	je     800172 <primeproc+0x14d>
            if ((r = write(wfd, &i, 4)) != 4)
  800190:	ba 04 00 00 00       	mov    $0x4,%edx
  800195:	48 8d 75 c0          	lea    -0x40(%rbp),%rsi
  800199:	44 89 ef             	mov    %r13d,%edi
  80019c:	48 b8 d0 1e 80 00 00 	movabs $0x801ed0,%rax
  8001a3:	00 00 00 
  8001a6:	ff d0                	call   *%rax
  8001a8:	83 f8 04             	cmp    $0x4,%eax
  8001ab:	74 c5                	je     800172 <primeproc+0x14d>
                panic("primeproc %d write: %d %i", p, r, r >= 0 ? 0 : r);
  8001ad:	85 c0                	test   %eax,%eax
  8001af:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001b5:	44 0f 4e c8          	cmovle %eax,%r9d
  8001b9:	41 89 c0             	mov    %eax,%r8d
  8001bc:	8b 4d cc             	mov    -0x34(%rbp),%ecx
  8001bf:	48 ba 7c 41 80 00 00 	movabs $0x80417c,%rdx
  8001c6:	00 00 00 
  8001c9:	be 2d 00 00 00       	mov    $0x2d,%esi
  8001ce:	48 bf 38 41 80 00 00 	movabs $0x804138,%rdi
  8001d5:	00 00 00 
  8001d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8001dd:	49 ba 3a 04 80 00 00 	movabs $0x80043a,%r10
  8001e4:	00 00 00 
  8001e7:	41 ff d2             	call   *%r10
            panic("primeproc %d readn %d %d %i", p, fd, r, r >= 0 ? 0 : r);
  8001ea:	48 83 ec 08          	sub    $0x8,%rsp
  8001ee:	85 c0                	test   %eax,%eax
  8001f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8001f5:	0f 4e d0             	cmovle %eax,%edx
  8001f8:	52                   	push   %rdx
  8001f9:	41 89 c1             	mov    %eax,%r9d
  8001fc:	41 89 d8             	mov    %ebx,%r8d
  8001ff:	8b 4d cc             	mov    -0x34(%rbp),%ecx
  800202:	48 ba 60 41 80 00 00 	movabs $0x804160,%rdx
  800209:	00 00 00 
  80020c:	be 2a 00 00 00       	mov    $0x2a,%esi
  800211:	48 bf 38 41 80 00 00 	movabs $0x804138,%rdi
  800218:	00 00 00 
  80021b:	b8 00 00 00 00       	mov    $0x0,%eax
  800220:	49 ba 3a 04 80 00 00 	movabs $0x80043a,%r10
  800227:	00 00 00 
  80022a:	41 ff d2             	call   *%r10

000000000080022d <umain>:
    }
}

void
umain(int argc, char **argv) {
  80022d:	f3 0f 1e fa          	endbr64
  800231:	55                   	push   %rbp
  800232:	48 89 e5             	mov    %rsp,%rbp
  800235:	53                   	push   %rbx
  800236:	48 83 ec 18          	sub    $0x18,%rsp
    int id, p[2], r;

    binaryname = "primespipe";
  80023a:	48 b8 96 41 80 00 00 	movabs $0x804196,%rax
  800241:	00 00 00 
  800244:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  80024b:	00 00 00 

    if ((r = pipe(p)) < 0)
  80024e:	48 8d 7d e8          	lea    -0x18(%rbp),%rdi
  800252:	48 b8 51 27 80 00 00 	movabs $0x802751,%rax
  800259:	00 00 00 
  80025c:	ff d0                	call   *%rax
  80025e:	85 c0                	test   %eax,%eax
  800260:	78 30                	js     800292 <umain+0x65>
        panic("pipe: %i", r);

    /* Fork the first prime process in the chain */
    if ((id = fork()) < 0)
  800262:	48 b8 a8 18 80 00 00 	movabs $0x8018a8,%rax
  800269:	00 00 00 
  80026c:	ff d0                	call   *%rax
  80026e:	85 c0                	test   %eax,%eax
  800270:	78 4d                	js     8002bf <umain+0x92>
        panic("fork: %i", id);

    if (id == 0) {
  800272:	75 78                	jne    8002ec <umain+0xbf>
        close(p[1]);
  800274:	8b 7d ec             	mov    -0x14(%rbp),%edi
  800277:	48 b8 0f 1c 80 00 00 	movabs $0x801c0f,%rax
  80027e:	00 00 00 
  800281:	ff d0                	call   *%rax
        primeproc(p[0]);
  800283:	8b 7d e8             	mov    -0x18(%rbp),%edi
  800286:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  80028d:	00 00 00 
  800290:	ff d0                	call   *%rax
        panic("pipe: %i", r);
  800292:	89 c1                	mov    %eax,%ecx
  800294:	48 ba 4e 41 80 00 00 	movabs $0x80414e,%rdx
  80029b:	00 00 00 
  80029e:	be 38 00 00 00       	mov    $0x38,%esi
  8002a3:	48 bf 38 41 80 00 00 	movabs $0x804138,%rdi
  8002aa:	00 00 00 
  8002ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8002b2:	49 b8 3a 04 80 00 00 	movabs $0x80043a,%r8
  8002b9:	00 00 00 
  8002bc:	41 ff d0             	call   *%r8
        panic("fork: %i", id);
  8002bf:	89 c1                	mov    %eax,%ecx
  8002c1:	48 ba 57 41 80 00 00 	movabs $0x804157,%rdx
  8002c8:	00 00 00 
  8002cb:	be 3c 00 00 00       	mov    $0x3c,%esi
  8002d0:	48 bf 38 41 80 00 00 	movabs $0x804138,%rdi
  8002d7:	00 00 00 
  8002da:	b8 00 00 00 00       	mov    $0x0,%eax
  8002df:	49 b8 3a 04 80 00 00 	movabs $0x80043a,%r8
  8002e6:	00 00 00 
  8002e9:	41 ff d0             	call   *%r8
    }

    close(p[0]);
  8002ec:	8b 7d e8             	mov    -0x18(%rbp),%edi
  8002ef:	48 b8 0f 1c 80 00 00 	movabs $0x801c0f,%rax
  8002f6:	00 00 00 
  8002f9:	ff d0                	call   *%rax
  8002fb:	b8 02 00 00 00       	mov    $0x2,%eax

    /* Feed all the integers through */
    for (int i = 2;; i++)
        if ((r = write(p[1], &i, 4)) != 4)
  800300:	48 bb d0 1e 80 00 00 	movabs $0x801ed0,%rbx
  800307:	00 00 00 
  80030a:	eb 06                	jmp    800312 <umain+0xe5>
    for (int i = 2;; i++)
  80030c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80030f:	83 c0 01             	add    $0x1,%eax
  800312:	89 45 e4             	mov    %eax,-0x1c(%rbp)
        if ((r = write(p[1], &i, 4)) != 4)
  800315:	ba 04 00 00 00       	mov    $0x4,%edx
  80031a:	48 8d 75 e4          	lea    -0x1c(%rbp),%rsi
  80031e:	8b 7d ec             	mov    -0x14(%rbp),%edi
  800321:	ff d3                	call   *%rbx
  800323:	89 c1                	mov    %eax,%ecx
  800325:	83 f8 04             	cmp    $0x4,%eax
  800328:	74 e2                	je     80030c <umain+0xdf>
            panic("generator write: %d, %i", r, r >= 0 ? 0 : r);
  80032a:	85 c0                	test   %eax,%eax
  80032c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800332:	44 0f 4e c0          	cmovle %eax,%r8d
  800336:	48 ba a1 41 80 00 00 	movabs $0x8041a1,%rdx
  80033d:	00 00 00 
  800340:	be 48 00 00 00       	mov    $0x48,%esi
  800345:	48 bf 38 41 80 00 00 	movabs $0x804138,%rdi
  80034c:	00 00 00 
  80034f:	b8 00 00 00 00       	mov    $0x0,%eax
  800354:	49 b9 3a 04 80 00 00 	movabs $0x80043a,%r9
  80035b:	00 00 00 
  80035e:	41 ff d1             	call   *%r9

0000000000800361 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  800361:	f3 0f 1e fa          	endbr64
  800365:	55                   	push   %rbp
  800366:	48 89 e5             	mov    %rsp,%rbp
  800369:	41 56                	push   %r14
  80036b:	41 55                	push   %r13
  80036d:	41 54                	push   %r12
  80036f:	53                   	push   %rbx
  800370:	41 89 fd             	mov    %edi,%r13d
  800373:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
     * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  800376:	48 ba d8 50 80 00 00 	movabs $0x8050d8,%rdx
  80037d:	00 00 00 
  800380:	48 b8 d8 50 80 00 00 	movabs $0x8050d8,%rax
  800387:	00 00 00 
  80038a:	48 39 c2             	cmp    %rax,%rdx
  80038d:	73 17                	jae    8003a6 <libmain+0x45>
    void (**ctor)() = &__ctors_start;
  80038f:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  800392:	49 89 c4             	mov    %rax,%r12
  800395:	48 83 c3 08          	add    $0x8,%rbx
  800399:	b8 00 00 00 00       	mov    $0x0,%eax
  80039e:	ff 53 f8             	call   *-0x8(%rbx)
  8003a1:	4c 39 e3             	cmp    %r12,%rbx
  8003a4:	72 ef                	jb     800395 <libmain+0x34>

    /* Set thisenv to point at our Env structure in envs[]. */

    // LAB 8: Your code here
    thisenv = &((struct Env *)UENVS)[ENVX(sys_getenvid())];
  8003a6:	48 b8 14 14 80 00 00 	movabs $0x801414,%rax
  8003ad:	00 00 00 
  8003b0:	ff d0                	call   *%rax
  8003b2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8003b7:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8003bb:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8003bf:	48 c1 e0 04          	shl    $0x4,%rax
  8003c3:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  8003ca:	00 00 00 
  8003cd:	48 01 d0             	add    %rdx,%rax
  8003d0:	48 a3 00 60 80 00 00 	movabs %rax,0x806000
  8003d7:	00 00 00 

    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  8003da:	45 85 ed             	test   %r13d,%r13d
  8003dd:	7e 0d                	jle    8003ec <libmain+0x8b>
  8003df:	49 8b 06             	mov    (%r14),%rax
  8003e2:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  8003e9:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  8003ec:	4c 89 f6             	mov    %r14,%rsi
  8003ef:	44 89 ef             	mov    %r13d,%edi
  8003f2:	48 b8 2d 02 80 00 00 	movabs $0x80022d,%rax
  8003f9:	00 00 00 
  8003fc:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  8003fe:	48 b8 13 04 80 00 00 	movabs $0x800413,%rax
  800405:	00 00 00 
  800408:	ff d0                	call   *%rax
#endif
}
  80040a:	5b                   	pop    %rbx
  80040b:	41 5c                	pop    %r12
  80040d:	41 5d                	pop    %r13
  80040f:	41 5e                	pop    %r14
  800411:	5d                   	pop    %rbp
  800412:	c3                   	ret

0000000000800413 <exit>:

#include <inc/lib.h>

void
exit(void) {
  800413:	f3 0f 1e fa          	endbr64
  800417:	55                   	push   %rbp
  800418:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  80041b:	48 b8 46 1c 80 00 00 	movabs $0x801c46,%rax
  800422:	00 00 00 
  800425:	ff d0                	call   *%rax
    sys_env_destroy(0);
  800427:	bf 00 00 00 00       	mov    $0x0,%edi
  80042c:	48 b8 a5 13 80 00 00 	movabs $0x8013a5,%rax
  800433:	00 00 00 
  800436:	ff d0                	call   *%rax
}
  800438:	5d                   	pop    %rbp
  800439:	c3                   	ret

000000000080043a <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  80043a:	f3 0f 1e fa          	endbr64
  80043e:	55                   	push   %rbp
  80043f:	48 89 e5             	mov    %rsp,%rbp
  800442:	41 56                	push   %r14
  800444:	41 55                	push   %r13
  800446:	41 54                	push   %r12
  800448:	53                   	push   %rbx
  800449:	48 83 ec 50          	sub    $0x50,%rsp
  80044d:	49 89 fc             	mov    %rdi,%r12
  800450:	41 89 f5             	mov    %esi,%r13d
  800453:	48 89 d3             	mov    %rdx,%rbx
  800456:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80045a:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  80045e:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800462:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  800469:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80046d:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  800471:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  800475:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  800479:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  800480:	00 00 00 
  800483:	4c 8b 30             	mov    (%rax),%r14
  800486:	48 b8 14 14 80 00 00 	movabs $0x801414,%rax
  80048d:	00 00 00 
  800490:	ff d0                	call   *%rax
  800492:	89 c6                	mov    %eax,%esi
  800494:	45 89 e8             	mov    %r13d,%r8d
  800497:	4c 89 e1             	mov    %r12,%rcx
  80049a:	4c 89 f2             	mov    %r14,%rdx
  80049d:	48 bf 30 40 80 00 00 	movabs $0x804030,%rdi
  8004a4:	00 00 00 
  8004a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ac:	49 bc 96 05 80 00 00 	movabs $0x800596,%r12
  8004b3:	00 00 00 
  8004b6:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  8004b9:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  8004bd:	48 89 df             	mov    %rbx,%rdi
  8004c0:	48 b8 2e 05 80 00 00 	movabs $0x80052e,%rax
  8004c7:	00 00 00 
  8004ca:	ff d0                	call   *%rax
    cprintf("\n");
  8004cc:	48 bf 4c 41 80 00 00 	movabs $0x80414c,%rdi
  8004d3:	00 00 00 
  8004d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8004db:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  8004de:	cc                   	int3
  8004df:	eb fd                	jmp    8004de <_panic+0xa4>

00000000008004e1 <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  8004e1:	f3 0f 1e fa          	endbr64
  8004e5:	55                   	push   %rbp
  8004e6:	48 89 e5             	mov    %rsp,%rbp
  8004e9:	53                   	push   %rbx
  8004ea:	48 83 ec 08          	sub    $0x8,%rsp
  8004ee:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  8004f1:	8b 06                	mov    (%rsi),%eax
  8004f3:	8d 50 01             	lea    0x1(%rax),%edx
  8004f6:	89 16                	mov    %edx,(%rsi)
  8004f8:	48 98                	cltq
  8004fa:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  8004ff:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  800505:	74 0a                	je     800511 <putch+0x30>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  800507:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  80050b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80050f:	c9                   	leave
  800510:	c3                   	ret
        sys_cputs(state->buf, state->offset);
  800511:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  800515:	be ff 00 00 00       	mov    $0xff,%esi
  80051a:	48 b8 3f 13 80 00 00 	movabs $0x80133f,%rax
  800521:	00 00 00 
  800524:	ff d0                	call   *%rax
        state->offset = 0;
  800526:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  80052c:	eb d9                	jmp    800507 <putch+0x26>

000000000080052e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  80052e:	f3 0f 1e fa          	endbr64
  800532:	55                   	push   %rbp
  800533:	48 89 e5             	mov    %rsp,%rbp
  800536:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80053d:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  800540:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  800547:	b9 21 00 00 00       	mov    $0x21,%ecx
  80054c:	b8 00 00 00 00       	mov    $0x0,%eax
  800551:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  800554:	48 89 f1             	mov    %rsi,%rcx
  800557:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  80055e:	48 bf e1 04 80 00 00 	movabs $0x8004e1,%rdi
  800565:	00 00 00 
  800568:	48 b8 f6 06 80 00 00 	movabs $0x8006f6,%rax
  80056f:	00 00 00 
  800572:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  800574:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  80057b:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  800582:	48 b8 3f 13 80 00 00 	movabs $0x80133f,%rax
  800589:	00 00 00 
  80058c:	ff d0                	call   *%rax

    return state.count;
}
  80058e:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  800594:	c9                   	leave
  800595:	c3                   	ret

0000000000800596 <cprintf>:

int
cprintf(const char *fmt, ...) {
  800596:	f3 0f 1e fa          	endbr64
  80059a:	55                   	push   %rbp
  80059b:	48 89 e5             	mov    %rsp,%rbp
  80059e:	48 83 ec 50          	sub    $0x50,%rsp
  8005a2:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  8005a6:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8005aa:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8005ae:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8005b2:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  8005b6:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  8005bd:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8005c1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8005c5:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8005c9:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  8005cd:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  8005d1:	48 b8 2e 05 80 00 00 	movabs $0x80052e,%rax
  8005d8:	00 00 00 
  8005db:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  8005dd:	c9                   	leave
  8005de:	c3                   	ret

00000000008005df <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  8005df:	f3 0f 1e fa          	endbr64
  8005e3:	55                   	push   %rbp
  8005e4:	48 89 e5             	mov    %rsp,%rbp
  8005e7:	41 57                	push   %r15
  8005e9:	41 56                	push   %r14
  8005eb:	41 55                	push   %r13
  8005ed:	41 54                	push   %r12
  8005ef:	53                   	push   %rbx
  8005f0:	48 83 ec 18          	sub    $0x18,%rsp
  8005f4:	49 89 fc             	mov    %rdi,%r12
  8005f7:	49 89 f5             	mov    %rsi,%r13
  8005fa:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  8005fe:	8b 45 10             	mov    0x10(%rbp),%eax
  800601:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  800604:	41 89 cf             	mov    %ecx,%r15d
  800607:	4c 39 fa             	cmp    %r15,%rdx
  80060a:	73 5b                	jae    800667 <print_num+0x88>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  80060c:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  800610:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  800614:	85 db                	test   %ebx,%ebx
  800616:	7e 0e                	jle    800626 <print_num+0x47>
            putch(padc, put_arg);
  800618:	4c 89 ee             	mov    %r13,%rsi
  80061b:	44 89 f7             	mov    %r14d,%edi
  80061e:	41 ff d4             	call   *%r12
        while (--width > 0) {
  800621:	83 eb 01             	sub    $0x1,%ebx
  800624:	75 f2                	jne    800618 <print_num+0x39>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  800626:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  80062a:	48 b9 d4 41 80 00 00 	movabs $0x8041d4,%rcx
  800631:	00 00 00 
  800634:	48 b8 c3 41 80 00 00 	movabs $0x8041c3,%rax
  80063b:	00 00 00 
  80063e:	48 0f 45 c8          	cmovne %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  800642:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800646:	ba 00 00 00 00       	mov    $0x0,%edx
  80064b:	49 f7 f7             	div    %r15
  80064e:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  800652:	4c 89 ee             	mov    %r13,%rsi
  800655:	41 ff d4             	call   *%r12
}
  800658:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  80065c:	5b                   	pop    %rbx
  80065d:	41 5c                	pop    %r12
  80065f:	41 5d                	pop    %r13
  800661:	41 5e                	pop    %r14
  800663:	41 5f                	pop    %r15
  800665:	5d                   	pop    %rbp
  800666:	c3                   	ret
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  800667:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80066b:	ba 00 00 00 00       	mov    $0x0,%edx
  800670:	49 f7 f7             	div    %r15
  800673:	48 83 ec 08          	sub    $0x8,%rsp
  800677:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  80067b:	52                   	push   %rdx
  80067c:	45 0f be c9          	movsbl %r9b,%r9d
  800680:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  800684:	48 89 c2             	mov    %rax,%rdx
  800687:	48 b8 df 05 80 00 00 	movabs $0x8005df,%rax
  80068e:	00 00 00 
  800691:	ff d0                	call   *%rax
  800693:	48 83 c4 10          	add    $0x10,%rsp
  800697:	eb 8d                	jmp    800626 <print_num+0x47>

0000000000800699 <sprintputch>:
    char *end;
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
  800699:	f3 0f 1e fa          	endbr64
    state->count++;
  80069d:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  8006a1:	48 8b 06             	mov    (%rsi),%rax
  8006a4:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  8006a8:	73 0a                	jae    8006b4 <sprintputch+0x1b>
        *state->start++ = ch;
  8006aa:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8006ae:	48 89 16             	mov    %rdx,(%rsi)
  8006b1:	40 88 38             	mov    %dil,(%rax)
    }
}
  8006b4:	c3                   	ret

00000000008006b5 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  8006b5:	f3 0f 1e fa          	endbr64
  8006b9:	55                   	push   %rbp
  8006ba:	48 89 e5             	mov    %rsp,%rbp
  8006bd:	48 83 ec 50          	sub    $0x50,%rsp
  8006c1:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8006c5:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8006c9:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  8006cd:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  8006d4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8006d8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8006dc:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8006e0:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  8006e4:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  8006e8:	48 b8 f6 06 80 00 00 	movabs $0x8006f6,%rax
  8006ef:	00 00 00 
  8006f2:	ff d0                	call   *%rax
}
  8006f4:	c9                   	leave
  8006f5:	c3                   	ret

00000000008006f6 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  8006f6:	f3 0f 1e fa          	endbr64
  8006fa:	55                   	push   %rbp
  8006fb:	48 89 e5             	mov    %rsp,%rbp
  8006fe:	41 57                	push   %r15
  800700:	41 56                	push   %r14
  800702:	41 55                	push   %r13
  800704:	41 54                	push   %r12
  800706:	53                   	push   %rbx
  800707:	48 83 ec 38          	sub    $0x38,%rsp
  80070b:	49 89 fe             	mov    %rdi,%r14
  80070e:	49 89 f5             	mov    %rsi,%r13
  800711:	48 89 d3             	mov    %rdx,%rbx
    va_copy(aq, ap);
  800714:	48 8b 01             	mov    (%rcx),%rax
  800717:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  80071b:	48 8b 41 08          	mov    0x8(%rcx),%rax
  80071f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800723:	48 8b 41 10          	mov    0x10(%rcx),%rax
  800727:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  80072b:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  80072f:	0f b6 3b             	movzbl (%rbx),%edi
  800732:	40 80 ff 25          	cmp    $0x25,%dil
  800736:	74 18                	je     800750 <vprintfmt+0x5a>
            if (!ch) return;
  800738:	40 84 ff             	test   %dil,%dil
  80073b:	0f 84 b2 06 00 00    	je     800df3 <vprintfmt+0x6fd>
            putch(ch, put_arg);
  800741:	40 0f b6 ff          	movzbl %dil,%edi
  800745:	4c 89 ee             	mov    %r13,%rsi
  800748:	41 ff d6             	call   *%r14
        while ((ch = *ufmt++) != '%') {
  80074b:	4c 89 e3             	mov    %r12,%rbx
  80074e:	eb db                	jmp    80072b <vprintfmt+0x35>
        bool altflag = 0, zflag = 0;
  800750:	be 00 00 00 00       	mov    $0x0,%esi
  800755:	c6 45 ab 00          	movb   $0x0,-0x55(%rbp)
        unsigned lflag = 0, base = 10;
  800759:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  80075e:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  800764:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  80076b:	c6 45 aa 20          	movb   $0x20,-0x56(%rbp)
        switch (ch = *ufmt++) {
  80076f:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  800774:	41 0f b6 04 24       	movzbl (%r12),%eax
  800779:	88 45 a0             	mov    %al,-0x60(%rbp)
  80077c:	83 e8 23             	sub    $0x23,%eax
  80077f:	3c 57                	cmp    $0x57,%al
  800781:	0f 87 52 06 00 00    	ja     800dd9 <vprintfmt+0x6e3>
  800787:	0f b6 c0             	movzbl %al,%eax
  80078a:	48 b9 80 44 80 00 00 	movabs $0x804480,%rcx
  800791:	00 00 00 
  800794:	3e ff 24 c1          	notrack jmp *(%rcx,%rax,8)
  800798:	49 89 dc             	mov    %rbx,%r12
            altflag = 1;
  80079b:	c6 45 ab 01          	movb   $0x1,-0x55(%rbp)
  80079f:	eb ce                	jmp    80076f <vprintfmt+0x79>
        switch (ch = *ufmt++) {
  8007a1:	49 89 dc             	mov    %rbx,%r12
  8007a4:	be 01 00 00 00       	mov    $0x1,%esi
  8007a9:	eb c4                	jmp    80076f <vprintfmt+0x79>
            padc = ch;
  8007ab:	0f b6 45 a0          	movzbl -0x60(%rbp),%eax
  8007af:	88 45 aa             	mov    %al,-0x56(%rbp)
        switch (ch = *ufmt++) {
  8007b2:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  8007b5:	eb b8                	jmp    80076f <vprintfmt+0x79>
            precision = va_arg(aq, int);
  8007b7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007ba:	83 f8 2f             	cmp    $0x2f,%eax
  8007bd:	77 24                	ja     8007e3 <vprintfmt+0xed>
  8007bf:	89 c1                	mov    %eax,%ecx
  8007c1:	48 03 4d c8          	add    -0x38(%rbp),%rcx
  8007c5:	83 c0 08             	add    $0x8,%eax
  8007c8:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007cb:	44 8b 39             	mov    (%rcx),%r15d
        switch (ch = *ufmt++) {
  8007ce:	49 89 dc             	mov    %rbx,%r12
            if (width < 0) {
  8007d1:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8007d5:	79 98                	jns    80076f <vprintfmt+0x79>
                width = precision;
  8007d7:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
                precision = -1;
  8007db:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  8007e1:	eb 8c                	jmp    80076f <vprintfmt+0x79>
            precision = va_arg(aq, int);
  8007e3:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8007e7:	48 8d 41 08          	lea    0x8(%rcx),%rax
  8007eb:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007ef:	eb da                	jmp    8007cb <vprintfmt+0xd5>
                precision = precision * 10 + ch - '0';
  8007f1:	44 0f b6 7d a0       	movzbl -0x60(%rbp),%r15d
  8007f6:	41 83 ef 30          	sub    $0x30,%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  8007fa:	41 0f b6 44 24 01    	movzbl 0x1(%r12),%eax
  800800:	3c 39                	cmp    $0x39,%al
  800802:	77 1c                	ja     800820 <vprintfmt+0x12a>
            for (precision = 0;; ++ufmt) {
  800804:	48 83 c3 01          	add    $0x1,%rbx
                precision = precision * 10 + ch - '0';
  800808:	43 8d 0c bf          	lea    (%r15,%r15,4),%ecx
  80080c:	0f b6 c0             	movzbl %al,%eax
  80080f:	44 8d 7c 48 d0       	lea    -0x30(%rax,%rcx,2),%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  800814:	0f b6 03             	movzbl (%rbx),%eax
  800817:	3c 39                	cmp    $0x39,%al
  800819:	76 e9                	jbe    800804 <vprintfmt+0x10e>
        process_precision:
  80081b:	49 89 dc             	mov    %rbx,%r12
  80081e:	eb b1                	jmp    8007d1 <vprintfmt+0xdb>
        switch (ch = *ufmt++) {
  800820:	49 89 dc             	mov    %rbx,%r12
  800823:	eb ac                	jmp    8007d1 <vprintfmt+0xdb>
            width = MAX(0, width);
  800825:	8b 4d ac             	mov    -0x54(%rbp),%ecx
  800828:	85 c9                	test   %ecx,%ecx
  80082a:	b8 00 00 00 00       	mov    $0x0,%eax
  80082f:	0f 49 c1             	cmovns %ecx,%eax
  800832:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  800835:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  800838:	e9 32 ff ff ff       	jmp    80076f <vprintfmt+0x79>
            lflag++;
  80083d:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  800840:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  800843:	e9 27 ff ff ff       	jmp    80076f <vprintfmt+0x79>
            putch(va_arg(aq, int), put_arg);
  800848:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80084b:	83 f8 2f             	cmp    $0x2f,%eax
  80084e:	77 19                	ja     800869 <vprintfmt+0x173>
  800850:	89 c2                	mov    %eax,%edx
  800852:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800856:	83 c0 08             	add    $0x8,%eax
  800859:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80085c:	8b 3a                	mov    (%rdx),%edi
  80085e:	4c 89 ee             	mov    %r13,%rsi
  800861:	41 ff d6             	call   *%r14
            break;
  800864:	e9 c2 fe ff ff       	jmp    80072b <vprintfmt+0x35>
            putch(va_arg(aq, int), put_arg);
  800869:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80086d:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800871:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800875:	eb e5                	jmp    80085c <vprintfmt+0x166>
            int err = va_arg(aq, int);
  800877:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80087a:	83 f8 2f             	cmp    $0x2f,%eax
  80087d:	77 5a                	ja     8008d9 <vprintfmt+0x1e3>
  80087f:	89 c2                	mov    %eax,%edx
  800881:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800885:	83 c0 08             	add    $0x8,%eax
  800888:	89 45 b8             	mov    %eax,-0x48(%rbp)
            if (err < 0) err = -err;
  80088b:	8b 02                	mov    (%rdx),%eax
  80088d:	89 c1                	mov    %eax,%ecx
  80088f:	f7 d9                	neg    %ecx
  800891:	0f 48 c8             	cmovs  %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  800894:	83 f9 13             	cmp    $0x13,%ecx
  800897:	7f 4e                	jg     8008e7 <vprintfmt+0x1f1>
  800899:	48 63 c1             	movslq %ecx,%rax
  80089c:	48 ba 40 47 80 00 00 	movabs $0x804740,%rdx
  8008a3:	00 00 00 
  8008a6:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8008aa:	48 85 c0             	test   %rax,%rax
  8008ad:	74 38                	je     8008e7 <vprintfmt+0x1f1>
                printfmt(putch, put_arg, "%s", strerr);
  8008af:	48 89 c1             	mov    %rax,%rcx
  8008b2:	48 ba ee 43 80 00 00 	movabs $0x8043ee,%rdx
  8008b9:	00 00 00 
  8008bc:	4c 89 ee             	mov    %r13,%rsi
  8008bf:	4c 89 f7             	mov    %r14,%rdi
  8008c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8008c7:	49 b8 b5 06 80 00 00 	movabs $0x8006b5,%r8
  8008ce:	00 00 00 
  8008d1:	41 ff d0             	call   *%r8
  8008d4:	e9 52 fe ff ff       	jmp    80072b <vprintfmt+0x35>
            int err = va_arg(aq, int);
  8008d9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008dd:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8008e1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008e5:	eb a4                	jmp    80088b <vprintfmt+0x195>
                printfmt(putch, put_arg, "error %d", err);
  8008e7:	48 ba ec 41 80 00 00 	movabs $0x8041ec,%rdx
  8008ee:	00 00 00 
  8008f1:	4c 89 ee             	mov    %r13,%rsi
  8008f4:	4c 89 f7             	mov    %r14,%rdi
  8008f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8008fc:	49 b8 b5 06 80 00 00 	movabs $0x8006b5,%r8
  800903:	00 00 00 
  800906:	41 ff d0             	call   *%r8
  800909:	e9 1d fe ff ff       	jmp    80072b <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  80090e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800911:	83 f8 2f             	cmp    $0x2f,%eax
  800914:	77 6c                	ja     800982 <vprintfmt+0x28c>
  800916:	89 c2                	mov    %eax,%edx
  800918:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80091c:	83 c0 08             	add    $0x8,%eax
  80091f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800922:	48 8b 12             	mov    (%rdx),%rdx
            if (!ptr) ptr = "(null)";
  800925:	48 85 d2             	test   %rdx,%rdx
  800928:	48 b8 e5 41 80 00 00 	movabs $0x8041e5,%rax
  80092f:	00 00 00 
  800932:	48 0f 45 c2          	cmovne %rdx,%rax
  800936:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
            if (width > 0 && padc != '-') {
  80093a:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  80093e:	7e 06                	jle    800946 <vprintfmt+0x250>
  800940:	80 7d aa 2d          	cmpb   $0x2d,-0x56(%rbp)
  800944:	75 4a                	jne    800990 <vprintfmt+0x29a>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800946:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80094a:	4c 8d 60 01          	lea    0x1(%rax),%r12
  80094e:	0f b6 00             	movzbl (%rax),%eax
  800951:	84 c0                	test   %al,%al
  800953:	0f 85 9a 00 00 00    	jne    8009f3 <vprintfmt+0x2fd>
            while (width-- > 0) putch(' ', put_arg);
  800959:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80095c:	44 8d 60 ff          	lea    -0x1(%rax),%r12d
  800960:	85 c0                	test   %eax,%eax
  800962:	0f 8e c3 fd ff ff    	jle    80072b <vprintfmt+0x35>
  800968:	4c 89 ee             	mov    %r13,%rsi
  80096b:	bf 20 00 00 00       	mov    $0x20,%edi
  800970:	41 ff d6             	call   *%r14
  800973:	41 83 ec 01          	sub    $0x1,%r12d
  800977:	41 83 fc ff          	cmp    $0xffffffff,%r12d
  80097b:	75 eb                	jne    800968 <vprintfmt+0x272>
  80097d:	e9 a9 fd ff ff       	jmp    80072b <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  800982:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800986:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80098a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80098e:	eb 92                	jmp    800922 <vprintfmt+0x22c>
                width -= strnlen(ptr, precision);
  800990:	49 63 f7             	movslq %r15d,%rsi
  800993:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  800997:	48 b8 b9 0e 80 00 00 	movabs $0x800eb9,%rax
  80099e:	00 00 00 
  8009a1:	ff d0                	call   *%rax
  8009a3:	48 89 c2             	mov    %rax,%rdx
  8009a6:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8009a9:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  8009ab:	8d 70 ff             	lea    -0x1(%rax),%esi
  8009ae:	89 75 ac             	mov    %esi,-0x54(%rbp)
  8009b1:	85 c0                	test   %eax,%eax
  8009b3:	7e 91                	jle    800946 <vprintfmt+0x250>
  8009b5:	44 0f be 65 aa       	movsbl -0x56(%rbp),%r12d
  8009ba:	4c 89 ee             	mov    %r13,%rsi
  8009bd:	44 89 e7             	mov    %r12d,%edi
  8009c0:	41 ff d6             	call   *%r14
  8009c3:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  8009c7:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8009ca:	83 f8 ff             	cmp    $0xffffffff,%eax
  8009cd:	75 eb                	jne    8009ba <vprintfmt+0x2c4>
  8009cf:	e9 72 ff ff ff       	jmp    800946 <vprintfmt+0x250>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  8009d4:	0f b6 f8             	movzbl %al,%edi
  8009d7:	4c 89 ee             	mov    %r13,%rsi
  8009da:	41 ff d6             	call   *%r14
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  8009dd:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  8009e1:	49 83 c4 01          	add    $0x1,%r12
  8009e5:	41 0f b6 44 24 ff    	movzbl -0x1(%r12),%eax
  8009eb:	84 c0                	test   %al,%al
  8009ed:	0f 84 66 ff ff ff    	je     800959 <vprintfmt+0x263>
  8009f3:	45 85 ff             	test   %r15d,%r15d
  8009f6:	78 0a                	js     800a02 <vprintfmt+0x30c>
  8009f8:	41 83 ef 01          	sub    $0x1,%r15d
  8009fc:	0f 88 57 ff ff ff    	js     800959 <vprintfmt+0x263>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800a02:	80 7d ab 00          	cmpb   $0x0,-0x55(%rbp)
  800a06:	74 cc                	je     8009d4 <vprintfmt+0x2de>
  800a08:	8d 50 e0             	lea    -0x20(%rax),%edx
  800a0b:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800a10:	80 fa 5e             	cmp    $0x5e,%dl
  800a13:	77 c2                	ja     8009d7 <vprintfmt+0x2e1>
  800a15:	eb bd                	jmp    8009d4 <vprintfmt+0x2de>
    if (zflag) return va_arg(*ap, size_t);
  800a17:	40 84 f6             	test   %sil,%sil
  800a1a:	75 26                	jne    800a42 <vprintfmt+0x34c>
    switch (lflag) {
  800a1c:	85 d2                	test   %edx,%edx
  800a1e:	74 59                	je     800a79 <vprintfmt+0x383>
  800a20:	83 fa 01             	cmp    $0x1,%edx
  800a23:	74 7b                	je     800aa0 <vprintfmt+0x3aa>
        return va_arg(*ap, long long);
  800a25:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a28:	83 f8 2f             	cmp    $0x2f,%eax
  800a2b:	0f 87 96 00 00 00    	ja     800ac7 <vprintfmt+0x3d1>
  800a31:	89 c2                	mov    %eax,%edx
  800a33:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a37:	83 c0 08             	add    $0x8,%eax
  800a3a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a3d:	4c 8b 22             	mov    (%rdx),%r12
  800a40:	eb 17                	jmp    800a59 <vprintfmt+0x363>
    if (zflag) return va_arg(*ap, size_t);
  800a42:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a45:	83 f8 2f             	cmp    $0x2f,%eax
  800a48:	77 21                	ja     800a6b <vprintfmt+0x375>
  800a4a:	89 c2                	mov    %eax,%edx
  800a4c:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a50:	83 c0 08             	add    $0x8,%eax
  800a53:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a56:	4c 8b 22             	mov    (%rdx),%r12
            if (i < 0) {
  800a59:	4d 85 e4             	test   %r12,%r12
  800a5c:	78 7a                	js     800ad8 <vprintfmt+0x3e2>
            num = i;
  800a5e:	4c 89 e2             	mov    %r12,%rdx
        unsigned lflag = 0, base = 10;
  800a61:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  800a66:	e9 50 02 00 00       	jmp    800cbb <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800a6b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a6f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a73:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a77:	eb dd                	jmp    800a56 <vprintfmt+0x360>
        return va_arg(*ap, int);
  800a79:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a7c:	83 f8 2f             	cmp    $0x2f,%eax
  800a7f:	77 11                	ja     800a92 <vprintfmt+0x39c>
  800a81:	89 c2                	mov    %eax,%edx
  800a83:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a87:	83 c0 08             	add    $0x8,%eax
  800a8a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a8d:	4c 63 22             	movslq (%rdx),%r12
  800a90:	eb c7                	jmp    800a59 <vprintfmt+0x363>
  800a92:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a96:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a9a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a9e:	eb ed                	jmp    800a8d <vprintfmt+0x397>
        return va_arg(*ap, long);
  800aa0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aa3:	83 f8 2f             	cmp    $0x2f,%eax
  800aa6:	77 11                	ja     800ab9 <vprintfmt+0x3c3>
  800aa8:	89 c2                	mov    %eax,%edx
  800aaa:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800aae:	83 c0 08             	add    $0x8,%eax
  800ab1:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ab4:	4c 8b 22             	mov    (%rdx),%r12
  800ab7:	eb a0                	jmp    800a59 <vprintfmt+0x363>
  800ab9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800abd:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800ac1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ac5:	eb ed                	jmp    800ab4 <vprintfmt+0x3be>
        return va_arg(*ap, long long);
  800ac7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800acb:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800acf:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ad3:	e9 65 ff ff ff       	jmp    800a3d <vprintfmt+0x347>
                putch('-', put_arg);
  800ad8:	4c 89 ee             	mov    %r13,%rsi
  800adb:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800ae0:	41 ff d6             	call   *%r14
                i = -i;
  800ae3:	49 f7 dc             	neg    %r12
  800ae6:	e9 73 ff ff ff       	jmp    800a5e <vprintfmt+0x368>
    if (zflag) return va_arg(*ap, size_t);
  800aeb:	40 84 f6             	test   %sil,%sil
  800aee:	75 32                	jne    800b22 <vprintfmt+0x42c>
    switch (lflag) {
  800af0:	85 d2                	test   %edx,%edx
  800af2:	74 5d                	je     800b51 <vprintfmt+0x45b>
  800af4:	83 fa 01             	cmp    $0x1,%edx
  800af7:	0f 84 82 00 00 00    	je     800b7f <vprintfmt+0x489>
        return va_arg(*ap, unsigned long long);
  800afd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b00:	83 f8 2f             	cmp    $0x2f,%eax
  800b03:	0f 87 a5 00 00 00    	ja     800bae <vprintfmt+0x4b8>
  800b09:	89 c2                	mov    %eax,%edx
  800b0b:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b0f:	83 c0 08             	add    $0x8,%eax
  800b12:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b15:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800b18:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  800b1d:	e9 99 01 00 00       	jmp    800cbb <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800b22:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b25:	83 f8 2f             	cmp    $0x2f,%eax
  800b28:	77 19                	ja     800b43 <vprintfmt+0x44d>
  800b2a:	89 c2                	mov    %eax,%edx
  800b2c:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b30:	83 c0 08             	add    $0x8,%eax
  800b33:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b36:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800b39:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800b3e:	e9 78 01 00 00       	jmp    800cbb <vprintfmt+0x5c5>
  800b43:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b47:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b4b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b4f:	eb e5                	jmp    800b36 <vprintfmt+0x440>
        return va_arg(*ap, unsigned int);
  800b51:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b54:	83 f8 2f             	cmp    $0x2f,%eax
  800b57:	77 18                	ja     800b71 <vprintfmt+0x47b>
  800b59:	89 c2                	mov    %eax,%edx
  800b5b:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b5f:	83 c0 08             	add    $0x8,%eax
  800b62:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b65:	8b 12                	mov    (%rdx),%edx
        unsigned lflag = 0, base = 10;
  800b67:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  800b6c:	e9 4a 01 00 00       	jmp    800cbb <vprintfmt+0x5c5>
  800b71:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b75:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b79:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b7d:	eb e6                	jmp    800b65 <vprintfmt+0x46f>
        return va_arg(*ap, unsigned long);
  800b7f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b82:	83 f8 2f             	cmp    $0x2f,%eax
  800b85:	77 19                	ja     800ba0 <vprintfmt+0x4aa>
  800b87:	89 c2                	mov    %eax,%edx
  800b89:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b8d:	83 c0 08             	add    $0x8,%eax
  800b90:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b93:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800b96:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  800b9b:	e9 1b 01 00 00       	jmp    800cbb <vprintfmt+0x5c5>
  800ba0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ba4:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800ba8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800bac:	eb e5                	jmp    800b93 <vprintfmt+0x49d>
        return va_arg(*ap, unsigned long long);
  800bae:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bb2:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800bb6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800bba:	e9 56 ff ff ff       	jmp    800b15 <vprintfmt+0x41f>
    if (zflag) return va_arg(*ap, size_t);
  800bbf:	40 84 f6             	test   %sil,%sil
  800bc2:	75 2e                	jne    800bf2 <vprintfmt+0x4fc>
    switch (lflag) {
  800bc4:	85 d2                	test   %edx,%edx
  800bc6:	74 59                	je     800c21 <vprintfmt+0x52b>
  800bc8:	83 fa 01             	cmp    $0x1,%edx
  800bcb:	74 7f                	je     800c4c <vprintfmt+0x556>
        return va_arg(*ap, unsigned long long);
  800bcd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bd0:	83 f8 2f             	cmp    $0x2f,%eax
  800bd3:	0f 87 9f 00 00 00    	ja     800c78 <vprintfmt+0x582>
  800bd9:	89 c2                	mov    %eax,%edx
  800bdb:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800bdf:	83 c0 08             	add    $0x8,%eax
  800be2:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800be5:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800be8:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  800bed:	e9 c9 00 00 00       	jmp    800cbb <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800bf2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bf5:	83 f8 2f             	cmp    $0x2f,%eax
  800bf8:	77 19                	ja     800c13 <vprintfmt+0x51d>
  800bfa:	89 c2                	mov    %eax,%edx
  800bfc:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800c00:	83 c0 08             	add    $0x8,%eax
  800c03:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c06:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800c09:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800c0e:	e9 a8 00 00 00       	jmp    800cbb <vprintfmt+0x5c5>
  800c13:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c17:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800c1b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c1f:	eb e5                	jmp    800c06 <vprintfmt+0x510>
        return va_arg(*ap, unsigned int);
  800c21:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c24:	83 f8 2f             	cmp    $0x2f,%eax
  800c27:	77 15                	ja     800c3e <vprintfmt+0x548>
  800c29:	89 c2                	mov    %eax,%edx
  800c2b:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800c2f:	83 c0 08             	add    $0x8,%eax
  800c32:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c35:	8b 12                	mov    (%rdx),%edx
            base = 8;
  800c37:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  800c3c:	eb 7d                	jmp    800cbb <vprintfmt+0x5c5>
  800c3e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c42:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800c46:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c4a:	eb e9                	jmp    800c35 <vprintfmt+0x53f>
        return va_arg(*ap, unsigned long);
  800c4c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c4f:	83 f8 2f             	cmp    $0x2f,%eax
  800c52:	77 16                	ja     800c6a <vprintfmt+0x574>
  800c54:	89 c2                	mov    %eax,%edx
  800c56:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800c5a:	83 c0 08             	add    $0x8,%eax
  800c5d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c60:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800c63:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  800c68:	eb 51                	jmp    800cbb <vprintfmt+0x5c5>
  800c6a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c6e:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800c72:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c76:	eb e8                	jmp    800c60 <vprintfmt+0x56a>
        return va_arg(*ap, unsigned long long);
  800c78:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c7c:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800c80:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c84:	e9 5c ff ff ff       	jmp    800be5 <vprintfmt+0x4ef>
            putch('0', put_arg);
  800c89:	4c 89 ee             	mov    %r13,%rsi
  800c8c:	bf 30 00 00 00       	mov    $0x30,%edi
  800c91:	41 ff d6             	call   *%r14
            putch('x', put_arg);
  800c94:	4c 89 ee             	mov    %r13,%rsi
  800c97:	bf 78 00 00 00       	mov    $0x78,%edi
  800c9c:	41 ff d6             	call   *%r14
            num = (uintptr_t)va_arg(aq, void *);
  800c9f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ca2:	83 f8 2f             	cmp    $0x2f,%eax
  800ca5:	77 47                	ja     800cee <vprintfmt+0x5f8>
  800ca7:	89 c2                	mov    %eax,%edx
  800ca9:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800cad:	83 c0 08             	add    $0x8,%eax
  800cb0:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800cb3:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800cb6:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  800cbb:	48 83 ec 08          	sub    $0x8,%rsp
  800cbf:	80 7d a0 58          	cmpb   $0x58,-0x60(%rbp)
  800cc3:	0f 94 c0             	sete   %al
  800cc6:	0f b6 c0             	movzbl %al,%eax
  800cc9:	50                   	push   %rax
  800cca:	44 0f be 4d aa       	movsbl -0x56(%rbp),%r9d
  800ccf:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  800cd3:	4c 89 ee             	mov    %r13,%rsi
  800cd6:	4c 89 f7             	mov    %r14,%rdi
  800cd9:	48 b8 df 05 80 00 00 	movabs $0x8005df,%rax
  800ce0:	00 00 00 
  800ce3:	ff d0                	call   *%rax
            break;
  800ce5:	48 83 c4 10          	add    $0x10,%rsp
  800ce9:	e9 3d fa ff ff       	jmp    80072b <vprintfmt+0x35>
            num = (uintptr_t)va_arg(aq, void *);
  800cee:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cf2:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800cf6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800cfa:	eb b7                	jmp    800cb3 <vprintfmt+0x5bd>
    if (zflag) return va_arg(*ap, size_t);
  800cfc:	40 84 f6             	test   %sil,%sil
  800cff:	75 2b                	jne    800d2c <vprintfmt+0x636>
    switch (lflag) {
  800d01:	85 d2                	test   %edx,%edx
  800d03:	74 56                	je     800d5b <vprintfmt+0x665>
  800d05:	83 fa 01             	cmp    $0x1,%edx
  800d08:	74 7f                	je     800d89 <vprintfmt+0x693>
        return va_arg(*ap, unsigned long long);
  800d0a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d0d:	83 f8 2f             	cmp    $0x2f,%eax
  800d10:	0f 87 a2 00 00 00    	ja     800db8 <vprintfmt+0x6c2>
  800d16:	89 c2                	mov    %eax,%edx
  800d18:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800d1c:	83 c0 08             	add    $0x8,%eax
  800d1f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800d22:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800d25:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800d2a:	eb 8f                	jmp    800cbb <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800d2c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d2f:	83 f8 2f             	cmp    $0x2f,%eax
  800d32:	77 19                	ja     800d4d <vprintfmt+0x657>
  800d34:	89 c2                	mov    %eax,%edx
  800d36:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800d3a:	83 c0 08             	add    $0x8,%eax
  800d3d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800d40:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800d43:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800d48:	e9 6e ff ff ff       	jmp    800cbb <vprintfmt+0x5c5>
  800d4d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d51:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800d55:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800d59:	eb e5                	jmp    800d40 <vprintfmt+0x64a>
        return va_arg(*ap, unsigned int);
  800d5b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d5e:	83 f8 2f             	cmp    $0x2f,%eax
  800d61:	77 18                	ja     800d7b <vprintfmt+0x685>
  800d63:	89 c2                	mov    %eax,%edx
  800d65:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800d69:	83 c0 08             	add    $0x8,%eax
  800d6c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800d6f:	8b 12                	mov    (%rdx),%edx
            base = 16;
  800d71:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  800d76:	e9 40 ff ff ff       	jmp    800cbb <vprintfmt+0x5c5>
  800d7b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d7f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800d83:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800d87:	eb e6                	jmp    800d6f <vprintfmt+0x679>
        return va_arg(*ap, unsigned long);
  800d89:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d8c:	83 f8 2f             	cmp    $0x2f,%eax
  800d8f:	77 19                	ja     800daa <vprintfmt+0x6b4>
  800d91:	89 c2                	mov    %eax,%edx
  800d93:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800d97:	83 c0 08             	add    $0x8,%eax
  800d9a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800d9d:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800da0:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800da5:	e9 11 ff ff ff       	jmp    800cbb <vprintfmt+0x5c5>
  800daa:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800dae:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800db2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800db6:	eb e5                	jmp    800d9d <vprintfmt+0x6a7>
        return va_arg(*ap, unsigned long long);
  800db8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800dbc:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800dc0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800dc4:	e9 59 ff ff ff       	jmp    800d22 <vprintfmt+0x62c>
            putch(ch, put_arg);
  800dc9:	4c 89 ee             	mov    %r13,%rsi
  800dcc:	bf 25 00 00 00       	mov    $0x25,%edi
  800dd1:	41 ff d6             	call   *%r14
            break;
  800dd4:	e9 52 f9 ff ff       	jmp    80072b <vprintfmt+0x35>
            putch('%', put_arg);
  800dd9:	4c 89 ee             	mov    %r13,%rsi
  800ddc:	bf 25 00 00 00       	mov    $0x25,%edi
  800de1:	41 ff d6             	call   *%r14
            while ((--ufmt)[-1] != '%') /* nothing */
  800de4:	48 83 eb 01          	sub    $0x1,%rbx
  800de8:	80 7b ff 25          	cmpb   $0x25,-0x1(%rbx)
  800dec:	75 f6                	jne    800de4 <vprintfmt+0x6ee>
  800dee:	e9 38 f9 ff ff       	jmp    80072b <vprintfmt+0x35>
}
  800df3:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800df7:	5b                   	pop    %rbx
  800df8:	41 5c                	pop    %r12
  800dfa:	41 5d                	pop    %r13
  800dfc:	41 5e                	pop    %r14
  800dfe:	41 5f                	pop    %r15
  800e00:	5d                   	pop    %rbp
  800e01:	c3                   	ret

0000000000800e02 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800e02:	f3 0f 1e fa          	endbr64
  800e06:	55                   	push   %rbp
  800e07:	48 89 e5             	mov    %rsp,%rbp
  800e0a:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800e0e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e12:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800e17:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800e1b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800e22:	48 85 ff             	test   %rdi,%rdi
  800e25:	74 2b                	je     800e52 <vsnprintf+0x50>
  800e27:	48 85 f6             	test   %rsi,%rsi
  800e2a:	74 26                	je     800e52 <vsnprintf+0x50>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800e2c:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800e30:	48 bf 99 06 80 00 00 	movabs $0x800699,%rdi
  800e37:	00 00 00 
  800e3a:	48 b8 f6 06 80 00 00 	movabs $0x8006f6,%rax
  800e41:	00 00 00 
  800e44:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800e46:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e4a:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800e4d:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800e50:	c9                   	leave
  800e51:	c3                   	ret
    if (!buf || n < 1) return -E_INVAL;
  800e52:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e57:	eb f7                	jmp    800e50 <vsnprintf+0x4e>

0000000000800e59 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800e59:	f3 0f 1e fa          	endbr64
  800e5d:	55                   	push   %rbp
  800e5e:	48 89 e5             	mov    %rsp,%rbp
  800e61:	48 83 ec 50          	sub    $0x50,%rsp
  800e65:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800e69:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800e6d:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800e71:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800e78:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e7c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800e80:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800e84:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800e88:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800e8c:	48 b8 02 0e 80 00 00 	movabs $0x800e02,%rax
  800e93:	00 00 00 
  800e96:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800e98:	c9                   	leave
  800e99:	c3                   	ret

0000000000800e9a <strlen>:
 * Primespipe runs 3x faster this way */

#define ASM 1

size_t
strlen(const char *s) {
  800e9a:	f3 0f 1e fa          	endbr64
    size_t n = 0;
    while (*s++) n++;
  800e9e:	80 3f 00             	cmpb   $0x0,(%rdi)
  800ea1:	74 10                	je     800eb3 <strlen+0x19>
    size_t n = 0;
  800ea3:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800ea8:	48 83 c0 01          	add    $0x1,%rax
  800eac:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800eb0:	75 f6                	jne    800ea8 <strlen+0xe>
  800eb2:	c3                   	ret
    size_t n = 0;
  800eb3:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800eb8:	c3                   	ret

0000000000800eb9 <strnlen>:

size_t
strnlen(const char *s, size_t size) {
  800eb9:	f3 0f 1e fa          	endbr64
  800ebd:	48 89 f0             	mov    %rsi,%rax
    size_t n = 0;
  800ec0:	ba 00 00 00 00       	mov    $0x0,%edx
    while (n < size && *s++) n++;
  800ec5:	48 85 f6             	test   %rsi,%rsi
  800ec8:	74 10                	je     800eda <strnlen+0x21>
  800eca:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  800ece:	74 0b                	je     800edb <strnlen+0x22>
  800ed0:	48 83 c2 01          	add    $0x1,%rdx
  800ed4:	48 39 d0             	cmp    %rdx,%rax
  800ed7:	75 f1                	jne    800eca <strnlen+0x11>
  800ed9:	c3                   	ret
  800eda:	c3                   	ret
  800edb:	48 89 d0             	mov    %rdx,%rax
    return n;
}
  800ede:	c3                   	ret

0000000000800edf <strcpy>:

char *
strcpy(char *dst, const char *src) {
  800edf:	f3 0f 1e fa          	endbr64
  800ee3:	48 89 f8             	mov    %rdi,%rax
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800ee6:	ba 00 00 00 00       	mov    $0x0,%edx
  800eeb:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  800eef:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  800ef2:	48 83 c2 01          	add    $0x1,%rdx
  800ef6:	84 c9                	test   %cl,%cl
  800ef8:	75 f1                	jne    800eeb <strcpy+0xc>
        ;
    return res;
}
  800efa:	c3                   	ret

0000000000800efb <strcat>:

char *
strcat(char *dst, const char *src) {
  800efb:	f3 0f 1e fa          	endbr64
  800eff:	55                   	push   %rbp
  800f00:	48 89 e5             	mov    %rsp,%rbp
  800f03:	41 54                	push   %r12
  800f05:	53                   	push   %rbx
  800f06:	48 89 fb             	mov    %rdi,%rbx
  800f09:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800f0c:	48 b8 9a 0e 80 00 00 	movabs $0x800e9a,%rax
  800f13:	00 00 00 
  800f16:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800f18:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800f1c:	4c 89 e6             	mov    %r12,%rsi
  800f1f:	48 b8 df 0e 80 00 00 	movabs $0x800edf,%rax
  800f26:	00 00 00 
  800f29:	ff d0                	call   *%rax
    return dst;
}
  800f2b:	48 89 d8             	mov    %rbx,%rax
  800f2e:	5b                   	pop    %rbx
  800f2f:	41 5c                	pop    %r12
  800f31:	5d                   	pop    %rbp
  800f32:	c3                   	ret

0000000000800f33 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800f33:	f3 0f 1e fa          	endbr64
  800f37:	48 89 f8             	mov    %rdi,%rax
    char *ret = dst;
    while (size-- > 0) {
  800f3a:	48 85 d2             	test   %rdx,%rdx
  800f3d:	74 1f                	je     800f5e <strncpy+0x2b>
  800f3f:	48 01 fa             	add    %rdi,%rdx
  800f42:	48 89 f9             	mov    %rdi,%rcx
        *dst++ = *src;
  800f45:	48 83 c1 01          	add    $0x1,%rcx
  800f49:	44 0f b6 06          	movzbl (%rsi),%r8d
  800f4d:	44 88 41 ff          	mov    %r8b,-0x1(%rcx)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800f51:	41 80 f8 01          	cmp    $0x1,%r8b
  800f55:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800f59:	48 39 ca             	cmp    %rcx,%rdx
  800f5c:	75 e7                	jne    800f45 <strncpy+0x12>
    }
    return ret;
}
  800f5e:	c3                   	ret

0000000000800f5f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
  800f5f:	f3 0f 1e fa          	endbr64
    char *dst_in = dst;
    if (size) {
  800f63:	48 89 f8             	mov    %rdi,%rax
  800f66:	48 85 d2             	test   %rdx,%rdx
  800f69:	74 24                	je     800f8f <strlcpy+0x30>
        while (--size > 0 && *src)
  800f6b:	48 83 ea 01          	sub    $0x1,%rdx
  800f6f:	74 1b                	je     800f8c <strlcpy+0x2d>
  800f71:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800f75:	0f b6 16             	movzbl (%rsi),%edx
  800f78:	84 d2                	test   %dl,%dl
  800f7a:	74 10                	je     800f8c <strlcpy+0x2d>
            *dst++ = *src++;
  800f7c:	48 83 c6 01          	add    $0x1,%rsi
  800f80:	48 83 c0 01          	add    $0x1,%rax
  800f84:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800f87:	48 39 c8             	cmp    %rcx,%rax
  800f8a:	75 e9                	jne    800f75 <strlcpy+0x16>
        *dst = '\0';
  800f8c:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800f8f:	48 29 f8             	sub    %rdi,%rax
}
  800f92:	c3                   	ret

0000000000800f93 <strcmp>:
    }
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
  800f93:	f3 0f 1e fa          	endbr64
    while (*p && *p == *q) p++, q++;
  800f97:	0f b6 07             	movzbl (%rdi),%eax
  800f9a:	84 c0                	test   %al,%al
  800f9c:	74 13                	je     800fb1 <strcmp+0x1e>
  800f9e:	38 06                	cmp    %al,(%rsi)
  800fa0:	75 0f                	jne    800fb1 <strcmp+0x1e>
  800fa2:	48 83 c7 01          	add    $0x1,%rdi
  800fa6:	48 83 c6 01          	add    $0x1,%rsi
  800faa:	0f b6 07             	movzbl (%rdi),%eax
  800fad:	84 c0                	test   %al,%al
  800faf:	75 ed                	jne    800f9e <strcmp+0xb>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800fb1:	0f b6 c0             	movzbl %al,%eax
  800fb4:	0f b6 16             	movzbl (%rsi),%edx
  800fb7:	29 d0                	sub    %edx,%eax
}
  800fb9:	c3                   	ret

0000000000800fba <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
  800fba:	f3 0f 1e fa          	endbr64
    while (n && *p && *p == *q) n--, p++, q++;
  800fbe:	48 85 d2             	test   %rdx,%rdx
  800fc1:	74 1f                	je     800fe2 <strncmp+0x28>
  800fc3:	0f b6 07             	movzbl (%rdi),%eax
  800fc6:	84 c0                	test   %al,%al
  800fc8:	74 1e                	je     800fe8 <strncmp+0x2e>
  800fca:	3a 06                	cmp    (%rsi),%al
  800fcc:	75 1a                	jne    800fe8 <strncmp+0x2e>
  800fce:	48 83 c7 01          	add    $0x1,%rdi
  800fd2:	48 83 c6 01          	add    $0x1,%rsi
  800fd6:	48 83 ea 01          	sub    $0x1,%rdx
  800fda:	75 e7                	jne    800fc3 <strncmp+0x9>

    if (!n) return 0;
  800fdc:	b8 00 00 00 00       	mov    $0x0,%eax
  800fe1:	c3                   	ret
  800fe2:	b8 00 00 00 00       	mov    $0x0,%eax
  800fe7:	c3                   	ret

    return (int)((unsigned char)*p - (unsigned char)*q);
  800fe8:	0f b6 07             	movzbl (%rdi),%eax
  800feb:	0f b6 16             	movzbl (%rsi),%edx
  800fee:	29 d0                	sub    %edx,%eax
}
  800ff0:	c3                   	ret

0000000000800ff1 <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
  800ff1:	f3 0f 1e fa          	endbr64
    for (; *str; str++) {
  800ff5:	0f b6 17             	movzbl (%rdi),%edx
  800ff8:	84 d2                	test   %dl,%dl
  800ffa:	74 18                	je     801014 <strchr+0x23>
        if (*str == c) {
  800ffc:	0f be d2             	movsbl %dl,%edx
  800fff:	39 f2                	cmp    %esi,%edx
  801001:	74 17                	je     80101a <strchr+0x29>
    for (; *str; str++) {
  801003:	48 83 c7 01          	add    $0x1,%rdi
  801007:	0f b6 17             	movzbl (%rdi),%edx
  80100a:	84 d2                	test   %dl,%dl
  80100c:	75 ee                	jne    800ffc <strchr+0xb>
            return (char *)str;
        }
    }
    return NULL;
  80100e:	b8 00 00 00 00       	mov    $0x0,%eax
  801013:	c3                   	ret
  801014:	b8 00 00 00 00       	mov    $0x0,%eax
  801019:	c3                   	ret
            return (char *)str;
  80101a:	48 89 f8             	mov    %rdi,%rax
}
  80101d:	c3                   	ret

000000000080101e <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
  80101e:	f3 0f 1e fa          	endbr64
  801022:	48 89 f8             	mov    %rdi,%rax
    for (; *str && *str != ch; str++) /* nothing */
  801025:	0f b6 17             	movzbl (%rdi),%edx
  801028:	84 d2                	test   %dl,%dl
  80102a:	74 13                	je     80103f <strfind+0x21>
  80102c:	0f be d2             	movsbl %dl,%edx
  80102f:	39 f2                	cmp    %esi,%edx
  801031:	74 0b                	je     80103e <strfind+0x20>
  801033:	48 83 c0 01          	add    $0x1,%rax
  801037:	0f b6 10             	movzbl (%rax),%edx
  80103a:	84 d2                	test   %dl,%dl
  80103c:	75 ee                	jne    80102c <strfind+0xe>
        ;
    return (char *)str;
}
  80103e:	c3                   	ret
  80103f:	c3                   	ret

0000000000801040 <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  801040:	f3 0f 1e fa          	endbr64
  801044:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  801047:	48 89 f8             	mov    %rdi,%rax
  80104a:	48 f7 d8             	neg    %rax
  80104d:	83 e0 07             	and    $0x7,%eax
  801050:	49 89 d1             	mov    %rdx,%r9
  801053:	49 29 c1             	sub    %rax,%r9
  801056:	78 36                	js     80108e <memset+0x4e>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  801058:	40 0f b6 c6          	movzbl %sil,%eax
  80105c:	48 b9 01 01 01 01 01 	movabs $0x101010101010101,%rcx
  801063:	01 01 01 
  801066:	48 0f af c1          	imul   %rcx,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  80106a:	40 f6 c7 07          	test   $0x7,%dil
  80106e:	75 38                	jne    8010a8 <memset+0x68>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  801070:	4c 89 c9             	mov    %r9,%rcx
  801073:	48 c1 f9 03          	sar    $0x3,%rcx
  801077:	74 0c                	je     801085 <memset+0x45>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  801079:	fc                   	cld
  80107a:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  80107d:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  801081:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  801085:	4d 85 c9             	test   %r9,%r9
  801088:	75 45                	jne    8010cf <memset+0x8f>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  80108a:	4c 89 c0             	mov    %r8,%rax
  80108d:	c3                   	ret
        while (n-- > 0) *ptr++ = c;
  80108e:	48 85 d2             	test   %rdx,%rdx
  801091:	74 f7                	je     80108a <memset+0x4a>
  801093:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  801096:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  801099:	48 83 c0 01          	add    $0x1,%rax
  80109d:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  8010a1:	48 39 c2             	cmp    %rax,%rdx
  8010a4:	75 f3                	jne    801099 <memset+0x59>
  8010a6:	eb e2                	jmp    80108a <memset+0x4a>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  8010a8:	40 f6 c7 01          	test   $0x1,%dil
  8010ac:	74 06                	je     8010b4 <memset+0x74>
  8010ae:	88 07                	mov    %al,(%rdi)
  8010b0:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  8010b4:	40 f6 c7 02          	test   $0x2,%dil
  8010b8:	74 07                	je     8010c1 <memset+0x81>
  8010ba:	66 89 07             	mov    %ax,(%rdi)
  8010bd:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  8010c1:	40 f6 c7 04          	test   $0x4,%dil
  8010c5:	74 a9                	je     801070 <memset+0x30>
  8010c7:	89 07                	mov    %eax,(%rdi)
  8010c9:	48 83 c7 04          	add    $0x4,%rdi
  8010cd:	eb a1                	jmp    801070 <memset+0x30>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  8010cf:	41 f6 c1 04          	test   $0x4,%r9b
  8010d3:	74 1b                	je     8010f0 <memset+0xb0>
  8010d5:	89 07                	mov    %eax,(%rdi)
  8010d7:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  8010db:	41 f6 c1 02          	test   $0x2,%r9b
  8010df:	74 07                	je     8010e8 <memset+0xa8>
  8010e1:	66 89 07             	mov    %ax,(%rdi)
  8010e4:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  8010e8:	41 f6 c1 01          	test   $0x1,%r9b
  8010ec:	74 9c                	je     80108a <memset+0x4a>
  8010ee:	eb 06                	jmp    8010f6 <memset+0xb6>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  8010f0:	41 f6 c1 02          	test   $0x2,%r9b
  8010f4:	75 eb                	jne    8010e1 <memset+0xa1>
        if (ni & 1) *ptr = k;
  8010f6:	88 07                	mov    %al,(%rdi)
  8010f8:	eb 90                	jmp    80108a <memset+0x4a>

00000000008010fa <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  8010fa:	f3 0f 1e fa          	endbr64
  8010fe:	48 89 f8             	mov    %rdi,%rax
  801101:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  801104:	48 39 fe             	cmp    %rdi,%rsi
  801107:	73 3b                	jae    801144 <memmove+0x4a>
  801109:	48 8d 14 16          	lea    (%rsi,%rdx,1),%rdx
  80110d:	48 39 d7             	cmp    %rdx,%rdi
  801110:	73 32                	jae    801144 <memmove+0x4a>
        s += n;
        d += n;
  801112:	48 8d 3c 0f          	lea    (%rdi,%rcx,1),%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  801116:	48 89 d6             	mov    %rdx,%rsi
  801119:	48 09 fe             	or     %rdi,%rsi
  80111c:	48 09 ce             	or     %rcx,%rsi
  80111f:	40 f6 c6 07          	test   $0x7,%sil
  801123:	75 12                	jne    801137 <memmove+0x3d>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  801125:	48 83 ef 08          	sub    $0x8,%rdi
  801129:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  80112d:	48 c1 e9 03          	shr    $0x3,%rcx
  801131:	fd                   	std
  801132:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  801135:	fc                   	cld
  801136:	c3                   	ret
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  801137:	48 83 ef 01          	sub    $0x1,%rdi
  80113b:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  80113f:	fd                   	std
  801140:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  801142:	eb f1                	jmp    801135 <memmove+0x3b>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  801144:	48 89 f2             	mov    %rsi,%rdx
  801147:	48 09 c2             	or     %rax,%rdx
  80114a:	48 09 ca             	or     %rcx,%rdx
  80114d:	f6 c2 07             	test   $0x7,%dl
  801150:	75 0c                	jne    80115e <memmove+0x64>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  801152:	48 c1 e9 03          	shr    $0x3,%rcx
  801156:	48 89 c7             	mov    %rax,%rdi
  801159:	fc                   	cld
  80115a:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  80115d:	c3                   	ret
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  80115e:	48 89 c7             	mov    %rax,%rdi
  801161:	fc                   	cld
  801162:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  801164:	c3                   	ret

0000000000801165 <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  801165:	f3 0f 1e fa          	endbr64
  801169:	55                   	push   %rbp
  80116a:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  80116d:	48 b8 fa 10 80 00 00 	movabs $0x8010fa,%rax
  801174:	00 00 00 
  801177:	ff d0                	call   *%rax
}
  801179:	5d                   	pop    %rbp
  80117a:	c3                   	ret

000000000080117b <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  80117b:	f3 0f 1e fa          	endbr64
  80117f:	55                   	push   %rbp
  801180:	48 89 e5             	mov    %rsp,%rbp
  801183:	41 57                	push   %r15
  801185:	41 56                	push   %r14
  801187:	41 55                	push   %r13
  801189:	41 54                	push   %r12
  80118b:	53                   	push   %rbx
  80118c:	48 83 ec 08          	sub    $0x8,%rsp
  801190:	49 89 fe             	mov    %rdi,%r14
  801193:	49 89 f7             	mov    %rsi,%r15
  801196:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  801199:	48 89 f7             	mov    %rsi,%rdi
  80119c:	48 b8 9a 0e 80 00 00 	movabs $0x800e9a,%rax
  8011a3:	00 00 00 
  8011a6:	ff d0                	call   *%rax
  8011a8:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  8011ab:	48 89 de             	mov    %rbx,%rsi
  8011ae:	4c 89 f7             	mov    %r14,%rdi
  8011b1:	48 b8 b9 0e 80 00 00 	movabs $0x800eb9,%rax
  8011b8:	00 00 00 
  8011bb:	ff d0                	call   *%rax
  8011bd:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  8011c0:	48 39 c3             	cmp    %rax,%rbx
  8011c3:	74 36                	je     8011fb <strlcat+0x80>
    if (srclen < maxlen - dstlen) {
  8011c5:	48 89 d8             	mov    %rbx,%rax
  8011c8:	4c 29 e8             	sub    %r13,%rax
  8011cb:	49 39 c4             	cmp    %rax,%r12
  8011ce:	73 31                	jae    801201 <strlcat+0x86>
        memcpy(dst + dstlen, src, srclen + 1);
  8011d0:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  8011d5:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  8011d9:	4c 89 fe             	mov    %r15,%rsi
  8011dc:	48 b8 65 11 80 00 00 	movabs $0x801165,%rax
  8011e3:	00 00 00 
  8011e6:	ff d0                	call   *%rax
    return dstlen + srclen;
  8011e8:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  8011ec:	48 83 c4 08          	add    $0x8,%rsp
  8011f0:	5b                   	pop    %rbx
  8011f1:	41 5c                	pop    %r12
  8011f3:	41 5d                	pop    %r13
  8011f5:	41 5e                	pop    %r14
  8011f7:	41 5f                	pop    %r15
  8011f9:	5d                   	pop    %rbp
  8011fa:	c3                   	ret
    if (dstlen == maxlen) return maxlen + srclen;
  8011fb:	49 8d 04 04          	lea    (%r12,%rax,1),%rax
  8011ff:	eb eb                	jmp    8011ec <strlcat+0x71>
        memcpy(dst + dstlen, src, maxlen - 1);
  801201:	48 83 eb 01          	sub    $0x1,%rbx
  801205:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  801209:	48 89 da             	mov    %rbx,%rdx
  80120c:	4c 89 fe             	mov    %r15,%rsi
  80120f:	48 b8 65 11 80 00 00 	movabs $0x801165,%rax
  801216:	00 00 00 
  801219:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  80121b:	49 01 de             	add    %rbx,%r14
  80121e:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  801223:	eb c3                	jmp    8011e8 <strlcat+0x6d>

0000000000801225 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  801225:	f3 0f 1e fa          	endbr64
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  801229:	48 85 d2             	test   %rdx,%rdx
  80122c:	74 2d                	je     80125b <memcmp+0x36>
  80122e:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  801233:	0f b6 0c 07          	movzbl (%rdi,%rax,1),%ecx
  801237:	44 0f b6 04 06       	movzbl (%rsi,%rax,1),%r8d
  80123c:	44 38 c1             	cmp    %r8b,%cl
  80123f:	75 0f                	jne    801250 <memcmp+0x2b>
    while (n-- > 0) {
  801241:	48 83 c0 01          	add    $0x1,%rax
  801245:	48 39 c2             	cmp    %rax,%rdx
  801248:	75 e9                	jne    801233 <memcmp+0xe>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  80124a:	b8 00 00 00 00       	mov    $0x0,%eax
  80124f:	c3                   	ret
            return (int)*s1 - (int)*s2;
  801250:	0f b6 c1             	movzbl %cl,%eax
  801253:	45 0f b6 c0          	movzbl %r8b,%r8d
  801257:	44 29 c0             	sub    %r8d,%eax
  80125a:	c3                   	ret
    return 0;
  80125b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801260:	c3                   	ret

0000000000801261 <memfind>:

void *
memfind(const void *src, int c, size_t n) {
  801261:	f3 0f 1e fa          	endbr64
    const void *end = (const char *)src + n;
  801265:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  801269:	48 39 c7             	cmp    %rax,%rdi
  80126c:	73 0f                	jae    80127d <memfind+0x1c>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  80126e:	40 38 37             	cmp    %sil,(%rdi)
  801271:	74 0e                	je     801281 <memfind+0x20>
    for (; src < end; src++) {
  801273:	48 83 c7 01          	add    $0x1,%rdi
  801277:	48 39 f8             	cmp    %rdi,%rax
  80127a:	75 f2                	jne    80126e <memfind+0xd>
  80127c:	c3                   	ret
  80127d:	48 89 f8             	mov    %rdi,%rax
  801280:	c3                   	ret
  801281:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  801284:	c3                   	ret

0000000000801285 <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  801285:	f3 0f 1e fa          	endbr64
  801289:	49 89 f2             	mov    %rsi,%r10
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  80128c:	0f b6 37             	movzbl (%rdi),%esi
  80128f:	40 80 fe 20          	cmp    $0x20,%sil
  801293:	74 06                	je     80129b <strtol+0x16>
  801295:	40 80 fe 09          	cmp    $0x9,%sil
  801299:	75 13                	jne    8012ae <strtol+0x29>
  80129b:	48 83 c7 01          	add    $0x1,%rdi
  80129f:	0f b6 37             	movzbl (%rdi),%esi
  8012a2:	40 80 fe 20          	cmp    $0x20,%sil
  8012a6:	74 f3                	je     80129b <strtol+0x16>
  8012a8:	40 80 fe 09          	cmp    $0x9,%sil
  8012ac:	74 ed                	je     80129b <strtol+0x16>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  8012ae:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  8012b1:	83 e0 fd             	and    $0xfffffffd,%eax
  8012b4:	3c 01                	cmp    $0x1,%al
  8012b6:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  8012ba:	f7 c2 ef ff ff ff    	test   $0xffffffef,%edx
  8012c0:	75 0f                	jne    8012d1 <strtol+0x4c>
  8012c2:	80 3f 30             	cmpb   $0x30,(%rdi)
  8012c5:	74 14                	je     8012db <strtol+0x56>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  8012c7:	85 d2                	test   %edx,%edx
  8012c9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8012ce:	0f 44 d0             	cmove  %eax,%edx
    }

    /* Digits */
    long val = 0;
  8012d1:	b8 00 00 00 00       	mov    $0x0,%eax
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  8012d6:	4c 63 ca             	movslq %edx,%r9
  8012d9:	eb 36                	jmp    801311 <strtol+0x8c>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  8012db:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  8012df:	74 0f                	je     8012f0 <strtol+0x6b>
    } else if (!base && s[0] == '0') {
  8012e1:	85 d2                	test   %edx,%edx
  8012e3:	75 ec                	jne    8012d1 <strtol+0x4c>
        s++;
  8012e5:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  8012e9:	ba 08 00 00 00       	mov    $0x8,%edx
        s++;
  8012ee:	eb e1                	jmp    8012d1 <strtol+0x4c>
        s += 2;
  8012f0:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  8012f4:	ba 10 00 00 00       	mov    $0x10,%edx
        s += 2;
  8012f9:	eb d6                	jmp    8012d1 <strtol+0x4c>
            dig -= '0';
  8012fb:	83 e9 30             	sub    $0x30,%ecx
        if (dig >= base) break;
  8012fe:	44 0f b6 c1          	movzbl %cl,%r8d
  801302:	41 39 d0             	cmp    %edx,%r8d
  801305:	7d 21                	jge    801328 <strtol+0xa3>
        val = val * base + dig;
  801307:	49 0f af c1          	imul   %r9,%rax
  80130b:	0f b6 c9             	movzbl %cl,%ecx
  80130e:	48 01 c8             	add    %rcx,%rax
        uint8_t dig = *s++;
  801311:	48 83 c7 01          	add    $0x1,%rdi
  801315:	0f b6 4f ff          	movzbl -0x1(%rdi),%ecx
        if (dig - '0' < 10)
  801319:	80 f9 39             	cmp    $0x39,%cl
  80131c:	76 dd                	jbe    8012fb <strtol+0x76>
        else if (dig - 'a' < 27)
  80131e:	80 f9 7b             	cmp    $0x7b,%cl
  801321:	77 05                	ja     801328 <strtol+0xa3>
            dig -= 'a' - 10;
  801323:	83 e9 57             	sub    $0x57,%ecx
  801326:	eb d6                	jmp    8012fe <strtol+0x79>
    }

    if (endptr) *endptr = (char *)s;
  801328:	4d 85 d2             	test   %r10,%r10
  80132b:	74 03                	je     801330 <strtol+0xab>
  80132d:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  801330:	48 89 c2             	mov    %rax,%rdx
  801333:	48 f7 da             	neg    %rdx
  801336:	40 80 fe 2d          	cmp    $0x2d,%sil
  80133a:	48 0f 44 c2          	cmove  %rdx,%rax
}
  80133e:	c3                   	ret

000000000080133f <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  80133f:	f3 0f 1e fa          	endbr64
  801343:	55                   	push   %rbp
  801344:	48 89 e5             	mov    %rsp,%rbp
  801347:	53                   	push   %rbx
  801348:	48 89 fa             	mov    %rdi,%rdx
  80134b:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80134e:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801353:	bb 00 00 00 00       	mov    $0x0,%ebx
  801358:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80135d:	be 00 00 00 00       	mov    $0x0,%esi
  801362:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801368:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  80136a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80136e:	c9                   	leave
  80136f:	c3                   	ret

0000000000801370 <sys_cgetc>:

int
sys_cgetc(void) {
  801370:	f3 0f 1e fa          	endbr64
  801374:	55                   	push   %rbp
  801375:	48 89 e5             	mov    %rsp,%rbp
  801378:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801379:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80137e:	ba 00 00 00 00       	mov    $0x0,%edx
  801383:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801388:	bb 00 00 00 00       	mov    $0x0,%ebx
  80138d:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801392:	be 00 00 00 00       	mov    $0x0,%esi
  801397:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80139d:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  80139f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013a3:	c9                   	leave
  8013a4:	c3                   	ret

00000000008013a5 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  8013a5:	f3 0f 1e fa          	endbr64
  8013a9:	55                   	push   %rbp
  8013aa:	48 89 e5             	mov    %rsp,%rbp
  8013ad:	53                   	push   %rbx
  8013ae:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  8013b2:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8013b5:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8013ba:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8013bf:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013c4:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013c9:	be 00 00 00 00       	mov    $0x0,%esi
  8013ce:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013d4:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8013d6:	48 85 c0             	test   %rax,%rax
  8013d9:	7f 06                	jg     8013e1 <sys_env_destroy+0x3c>
}
  8013db:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013df:	c9                   	leave
  8013e0:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8013e1:	49 89 c0             	mov    %rax,%r8
  8013e4:	b9 03 00 00 00       	mov    $0x3,%ecx
  8013e9:	48 ba 78 40 80 00 00 	movabs $0x804078,%rdx
  8013f0:	00 00 00 
  8013f3:	be 26 00 00 00       	mov    $0x26,%esi
  8013f8:	48 bf 52 43 80 00 00 	movabs $0x804352,%rdi
  8013ff:	00 00 00 
  801402:	b8 00 00 00 00       	mov    $0x0,%eax
  801407:	49 b9 3a 04 80 00 00 	movabs $0x80043a,%r9
  80140e:	00 00 00 
  801411:	41 ff d1             	call   *%r9

0000000000801414 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  801414:	f3 0f 1e fa          	endbr64
  801418:	55                   	push   %rbp
  801419:	48 89 e5             	mov    %rsp,%rbp
  80141c:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80141d:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801422:	ba 00 00 00 00       	mov    $0x0,%edx
  801427:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80142c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801431:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801436:	be 00 00 00 00       	mov    $0x0,%esi
  80143b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801441:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  801443:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801447:	c9                   	leave
  801448:	c3                   	ret

0000000000801449 <sys_yield>:

void
sys_yield(void) {
  801449:	f3 0f 1e fa          	endbr64
  80144d:	55                   	push   %rbp
  80144e:	48 89 e5             	mov    %rsp,%rbp
  801451:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801452:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801457:	ba 00 00 00 00       	mov    $0x0,%edx
  80145c:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801461:	bb 00 00 00 00       	mov    $0x0,%ebx
  801466:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80146b:	be 00 00 00 00       	mov    $0x0,%esi
  801470:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801476:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  801478:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80147c:	c9                   	leave
  80147d:	c3                   	ret

000000000080147e <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  80147e:	f3 0f 1e fa          	endbr64
  801482:	55                   	push   %rbp
  801483:	48 89 e5             	mov    %rsp,%rbp
  801486:	53                   	push   %rbx
  801487:	48 89 fa             	mov    %rdi,%rdx
  80148a:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80148d:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801492:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  801499:	00 00 00 
  80149c:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8014a1:	be 00 00 00 00       	mov    $0x0,%esi
  8014a6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8014ac:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  8014ae:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014b2:	c9                   	leave
  8014b3:	c3                   	ret

00000000008014b4 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  8014b4:	f3 0f 1e fa          	endbr64
  8014b8:	55                   	push   %rbp
  8014b9:	48 89 e5             	mov    %rsp,%rbp
  8014bc:	53                   	push   %rbx
  8014bd:	49 89 f8             	mov    %rdi,%r8
  8014c0:	48 89 d3             	mov    %rdx,%rbx
  8014c3:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  8014c6:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8014cb:	4c 89 c2             	mov    %r8,%rdx
  8014ce:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8014d1:	be 00 00 00 00       	mov    $0x0,%esi
  8014d6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8014dc:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  8014de:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014e2:	c9                   	leave
  8014e3:	c3                   	ret

00000000008014e4 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  8014e4:	f3 0f 1e fa          	endbr64
  8014e8:	55                   	push   %rbp
  8014e9:	48 89 e5             	mov    %rsp,%rbp
  8014ec:	53                   	push   %rbx
  8014ed:	48 83 ec 08          	sub    $0x8,%rsp
  8014f1:	89 f8                	mov    %edi,%eax
  8014f3:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  8014f6:	48 63 f9             	movslq %ecx,%rdi
  8014f9:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8014fc:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801501:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801504:	be 00 00 00 00       	mov    $0x0,%esi
  801509:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80150f:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801511:	48 85 c0             	test   %rax,%rax
  801514:	7f 06                	jg     80151c <sys_alloc_region+0x38>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  801516:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80151a:	c9                   	leave
  80151b:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80151c:	49 89 c0             	mov    %rax,%r8
  80151f:	b9 04 00 00 00       	mov    $0x4,%ecx
  801524:	48 ba 78 40 80 00 00 	movabs $0x804078,%rdx
  80152b:	00 00 00 
  80152e:	be 26 00 00 00       	mov    $0x26,%esi
  801533:	48 bf 52 43 80 00 00 	movabs $0x804352,%rdi
  80153a:	00 00 00 
  80153d:	b8 00 00 00 00       	mov    $0x0,%eax
  801542:	49 b9 3a 04 80 00 00 	movabs $0x80043a,%r9
  801549:	00 00 00 
  80154c:	41 ff d1             	call   *%r9

000000000080154f <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  80154f:	f3 0f 1e fa          	endbr64
  801553:	55                   	push   %rbp
  801554:	48 89 e5             	mov    %rsp,%rbp
  801557:	53                   	push   %rbx
  801558:	48 83 ec 08          	sub    $0x8,%rsp
  80155c:	89 f8                	mov    %edi,%eax
  80155e:	49 89 f2             	mov    %rsi,%r10
  801561:	48 89 cf             	mov    %rcx,%rdi
  801564:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  801567:	48 63 da             	movslq %edx,%rbx
  80156a:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80156d:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801572:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801575:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  801578:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80157a:	48 85 c0             	test   %rax,%rax
  80157d:	7f 06                	jg     801585 <sys_map_region+0x36>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  80157f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801583:	c9                   	leave
  801584:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801585:	49 89 c0             	mov    %rax,%r8
  801588:	b9 05 00 00 00       	mov    $0x5,%ecx
  80158d:	48 ba 78 40 80 00 00 	movabs $0x804078,%rdx
  801594:	00 00 00 
  801597:	be 26 00 00 00       	mov    $0x26,%esi
  80159c:	48 bf 52 43 80 00 00 	movabs $0x804352,%rdi
  8015a3:	00 00 00 
  8015a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ab:	49 b9 3a 04 80 00 00 	movabs $0x80043a,%r9
  8015b2:	00 00 00 
  8015b5:	41 ff d1             	call   *%r9

00000000008015b8 <sys_map_physical_region>:

int
sys_map_physical_region(uintptr_t pa, envid_t dstenv, void *dstva, size_t size, int perm) {
  8015b8:	f3 0f 1e fa          	endbr64
  8015bc:	55                   	push   %rbp
  8015bd:	48 89 e5             	mov    %rsp,%rbp
  8015c0:	53                   	push   %rbx
  8015c1:	48 83 ec 08          	sub    $0x8,%rsp
  8015c5:	49 89 f9             	mov    %rdi,%r9
  8015c8:	89 f0                	mov    %esi,%eax
  8015ca:	48 89 d3             	mov    %rdx,%rbx
  8015cd:	48 89 cf             	mov    %rcx,%rdi
    int res = syscall(SYS_map_physical_region, 1, pa, dstenv, (uintptr_t)dstva, size, perm, 0);
  8015d0:	49 63 f0             	movslq %r8d,%rsi
  8015d3:	48 63 c8             	movslq %eax,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8015d6:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8015db:	4c 89 ca             	mov    %r9,%rdx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8015de:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8015e4:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8015e6:	48 85 c0             	test   %rax,%rax
  8015e9:	7f 06                	jg     8015f1 <sys_map_physical_region+0x39>
#ifdef SANITIZE_USER_SHADOW_BASE
    platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  8015eb:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8015ef:	c9                   	leave
  8015f0:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8015f1:	49 89 c0             	mov    %rax,%r8
  8015f4:	b9 06 00 00 00       	mov    $0x6,%ecx
  8015f9:	48 ba 78 40 80 00 00 	movabs $0x804078,%rdx
  801600:	00 00 00 
  801603:	be 26 00 00 00       	mov    $0x26,%esi
  801608:	48 bf 52 43 80 00 00 	movabs $0x804352,%rdi
  80160f:	00 00 00 
  801612:	b8 00 00 00 00       	mov    $0x0,%eax
  801617:	49 b9 3a 04 80 00 00 	movabs $0x80043a,%r9
  80161e:	00 00 00 
  801621:	41 ff d1             	call   *%r9

0000000000801624 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  801624:	f3 0f 1e fa          	endbr64
  801628:	55                   	push   %rbp
  801629:	48 89 e5             	mov    %rsp,%rbp
  80162c:	53                   	push   %rbx
  80162d:	48 83 ec 08          	sub    $0x8,%rsp
  801631:	48 89 f1             	mov    %rsi,%rcx
  801634:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  801637:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80163a:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80163f:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801644:	be 00 00 00 00       	mov    $0x0,%esi
  801649:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80164f:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801651:	48 85 c0             	test   %rax,%rax
  801654:	7f 06                	jg     80165c <sys_unmap_region+0x38>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  801656:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80165a:	c9                   	leave
  80165b:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80165c:	49 89 c0             	mov    %rax,%r8
  80165f:	b9 07 00 00 00       	mov    $0x7,%ecx
  801664:	48 ba 78 40 80 00 00 	movabs $0x804078,%rdx
  80166b:	00 00 00 
  80166e:	be 26 00 00 00       	mov    $0x26,%esi
  801673:	48 bf 52 43 80 00 00 	movabs $0x804352,%rdi
  80167a:	00 00 00 
  80167d:	b8 00 00 00 00       	mov    $0x0,%eax
  801682:	49 b9 3a 04 80 00 00 	movabs $0x80043a,%r9
  801689:	00 00 00 
  80168c:	41 ff d1             	call   *%r9

000000000080168f <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  80168f:	f3 0f 1e fa          	endbr64
  801693:	55                   	push   %rbp
  801694:	48 89 e5             	mov    %rsp,%rbp
  801697:	53                   	push   %rbx
  801698:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  80169c:	48 63 ce             	movslq %esi,%rcx
  80169f:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8016a2:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8016a7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016ac:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8016b1:	be 00 00 00 00       	mov    $0x0,%esi
  8016b6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8016bc:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8016be:	48 85 c0             	test   %rax,%rax
  8016c1:	7f 06                	jg     8016c9 <sys_env_set_status+0x3a>
}
  8016c3:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8016c7:	c9                   	leave
  8016c8:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8016c9:	49 89 c0             	mov    %rax,%r8
  8016cc:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8016d1:	48 ba 78 40 80 00 00 	movabs $0x804078,%rdx
  8016d8:	00 00 00 
  8016db:	be 26 00 00 00       	mov    $0x26,%esi
  8016e0:	48 bf 52 43 80 00 00 	movabs $0x804352,%rdi
  8016e7:	00 00 00 
  8016ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ef:	49 b9 3a 04 80 00 00 	movabs $0x80043a,%r9
  8016f6:	00 00 00 
  8016f9:	41 ff d1             	call   *%r9

00000000008016fc <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  8016fc:	f3 0f 1e fa          	endbr64
  801700:	55                   	push   %rbp
  801701:	48 89 e5             	mov    %rsp,%rbp
  801704:	53                   	push   %rbx
  801705:	48 83 ec 08          	sub    $0x8,%rsp
  801709:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  80170c:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80170f:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801714:	bb 00 00 00 00       	mov    $0x0,%ebx
  801719:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80171e:	be 00 00 00 00       	mov    $0x0,%esi
  801723:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801729:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80172b:	48 85 c0             	test   %rax,%rax
  80172e:	7f 06                	jg     801736 <sys_env_set_trapframe+0x3a>
}
  801730:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801734:	c9                   	leave
  801735:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801736:	49 89 c0             	mov    %rax,%r8
  801739:	b9 0b 00 00 00       	mov    $0xb,%ecx
  80173e:	48 ba 78 40 80 00 00 	movabs $0x804078,%rdx
  801745:	00 00 00 
  801748:	be 26 00 00 00       	mov    $0x26,%esi
  80174d:	48 bf 52 43 80 00 00 	movabs $0x804352,%rdi
  801754:	00 00 00 
  801757:	b8 00 00 00 00       	mov    $0x0,%eax
  80175c:	49 b9 3a 04 80 00 00 	movabs $0x80043a,%r9
  801763:	00 00 00 
  801766:	41 ff d1             	call   *%r9

0000000000801769 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  801769:	f3 0f 1e fa          	endbr64
  80176d:	55                   	push   %rbp
  80176e:	48 89 e5             	mov    %rsp,%rbp
  801771:	53                   	push   %rbx
  801772:	48 83 ec 08          	sub    $0x8,%rsp
  801776:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  801779:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80177c:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801781:	bb 00 00 00 00       	mov    $0x0,%ebx
  801786:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80178b:	be 00 00 00 00       	mov    $0x0,%esi
  801790:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801796:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801798:	48 85 c0             	test   %rax,%rax
  80179b:	7f 06                	jg     8017a3 <sys_env_set_pgfault_upcall+0x3a>
}
  80179d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8017a1:	c9                   	leave
  8017a2:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8017a3:	49 89 c0             	mov    %rax,%r8
  8017a6:	b9 0c 00 00 00       	mov    $0xc,%ecx
  8017ab:	48 ba 78 40 80 00 00 	movabs $0x804078,%rdx
  8017b2:	00 00 00 
  8017b5:	be 26 00 00 00       	mov    $0x26,%esi
  8017ba:	48 bf 52 43 80 00 00 	movabs $0x804352,%rdi
  8017c1:	00 00 00 
  8017c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c9:	49 b9 3a 04 80 00 00 	movabs $0x80043a,%r9
  8017d0:	00 00 00 
  8017d3:	41 ff d1             	call   *%r9

00000000008017d6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  8017d6:	f3 0f 1e fa          	endbr64
  8017da:	55                   	push   %rbp
  8017db:	48 89 e5             	mov    %rsp,%rbp
  8017de:	53                   	push   %rbx
  8017df:	89 f8                	mov    %edi,%eax
  8017e1:	49 89 f1             	mov    %rsi,%r9
  8017e4:	48 89 d3             	mov    %rdx,%rbx
  8017e7:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  8017ea:	49 63 f0             	movslq %r8d,%rsi
  8017ed:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8017f0:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8017f5:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8017f8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8017fe:	cd 30                	int    $0x30
}
  801800:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801804:	c9                   	leave
  801805:	c3                   	ret

0000000000801806 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  801806:	f3 0f 1e fa          	endbr64
  80180a:	55                   	push   %rbp
  80180b:	48 89 e5             	mov    %rsp,%rbp
  80180e:	53                   	push   %rbx
  80180f:	48 83 ec 08          	sub    $0x8,%rsp
  801813:	48 89 fa             	mov    %rdi,%rdx
  801816:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801819:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80181e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801823:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801828:	be 00 00 00 00       	mov    $0x0,%esi
  80182d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801833:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801835:	48 85 c0             	test   %rax,%rax
  801838:	7f 06                	jg     801840 <sys_ipc_recv+0x3a>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  80183a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80183e:	c9                   	leave
  80183f:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801840:	49 89 c0             	mov    %rax,%r8
  801843:	b9 0f 00 00 00       	mov    $0xf,%ecx
  801848:	48 ba 78 40 80 00 00 	movabs $0x804078,%rdx
  80184f:	00 00 00 
  801852:	be 26 00 00 00       	mov    $0x26,%esi
  801857:	48 bf 52 43 80 00 00 	movabs $0x804352,%rdi
  80185e:	00 00 00 
  801861:	b8 00 00 00 00       	mov    $0x0,%eax
  801866:	49 b9 3a 04 80 00 00 	movabs $0x80043a,%r9
  80186d:	00 00 00 
  801870:	41 ff d1             	call   *%r9

0000000000801873 <sys_gettime>:

int
sys_gettime(void) {
  801873:	f3 0f 1e fa          	endbr64
  801877:	55                   	push   %rbp
  801878:	48 89 e5             	mov    %rsp,%rbp
  80187b:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80187c:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801881:	ba 00 00 00 00       	mov    $0x0,%edx
  801886:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80188b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801890:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801895:	be 00 00 00 00       	mov    $0x0,%esi
  80189a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8018a0:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  8018a2:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8018a6:	c9                   	leave
  8018a7:	c3                   	ret

00000000008018a8 <fork>:
 *   Use sys_map_region, it can perform address space copying in one call
 *   Don't forget to set page fault handler in the child (using sys_env_set_pgfault_upcall()).
 *   Remember to fix "thisenv" in the child process.
 */
envid_t
fork(void) {
  8018a8:	f3 0f 1e fa          	endbr64
  8018ac:	55                   	push   %rbp
  8018ad:	48 89 e5             	mov    %rsp,%rbp
  8018b0:	41 56                	push   %r14
  8018b2:	41 55                	push   %r13
  8018b4:	41 54                	push   %r12
  8018b6:	53                   	push   %rbx
    // LAB 9: Your code here.
    bool has_pgfault_upcall = thisenv->env_pgfault_upcall;
  8018b7:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  8018be:	00 00 00 
  8018c1:	4c 8b b0 00 01 00 00 	mov    0x100(%rax),%r14

/* This must be inlined. Exercise for reader: why? */
static inline envid_t __attribute__((always_inline))
sys_exofork(void) {
    envid_t ret;
    asm volatile("int %2"
  8018c8:	b8 09 00 00 00       	mov    $0x9,%eax
  8018cd:	cd 30                	int    $0x30
  8018cf:	41 89 c4             	mov    %eax,%r12d

    envid_t envid = sys_exofork();
    if (envid < 0) {
  8018d2:	85 c0                	test   %eax,%eax
  8018d4:	78 7f                	js     801955 <fork+0xad>
  8018d6:	89 c3                	mov    %eax,%ebx
        return envid;
    }
    if (envid == 0) {
  8018d8:	0f 84 83 00 00 00    	je     801961 <fork+0xb9>
        thisenv = &envs[ENVX(sys_getenvid())];
        return 0;
    }
    int res = sys_map_region(CURENVID, NULL, envid, NULL, MAX_USER_ADDRESS, PROT_ALL | PROT_LAZY | PROT_COMBINE);
  8018de:	41 b9 ff 0f 00 00    	mov    $0xfff,%r9d
  8018e4:	49 b8 00 00 00 00 80 	movabs $0x8000000000,%r8
  8018eb:	00 00 00 
  8018ee:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018f3:	89 c2                	mov    %eax,%edx
  8018f5:	be 00 00 00 00       	mov    $0x0,%esi
  8018fa:	bf 00 00 00 00       	mov    $0x0,%edi
  8018ff:	48 b8 4f 15 80 00 00 	movabs $0x80154f,%rax
  801906:	00 00 00 
  801909:	ff d0                	call   *%rax
  80190b:	41 89 c5             	mov    %eax,%r13d
    if (res < 0) {
  80190e:	85 c0                	test   %eax,%eax
  801910:	0f 88 81 00 00 00    	js     801997 <fork+0xef>
        sys_env_destroy(envid);
        return res;
    }
    if (has_pgfault_upcall) {
  801916:	4d 85 f6             	test   %r14,%r14
  801919:	74 20                	je     80193b <fork+0x93>
        res = sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  80191b:	48 be 6b 2f 80 00 00 	movabs $0x802f6b,%rsi
  801922:	00 00 00 
  801925:	44 89 e7             	mov    %r12d,%edi
  801928:	48 b8 69 17 80 00 00 	movabs $0x801769,%rax
  80192f:	00 00 00 
  801932:	ff d0                	call   *%rax
  801934:	41 89 c5             	mov    %eax,%r13d
        if (res < 0) {
  801937:	85 c0                	test   %eax,%eax
  801939:	78 70                	js     8019ab <fork+0x103>
            sys_env_destroy(envid);
            return res;
        }
    }
    res = sys_env_set_status(envid, ENV_RUNNABLE);
  80193b:	be 02 00 00 00       	mov    $0x2,%esi
  801940:	89 df                	mov    %ebx,%edi
  801942:	48 b8 8f 16 80 00 00 	movabs $0x80168f,%rax
  801949:	00 00 00 
  80194c:	ff d0                	call   *%rax
  80194e:	41 89 c5             	mov    %eax,%r13d
    if (res < 0) {
  801951:	85 c0                	test   %eax,%eax
  801953:	78 6a                	js     8019bf <fork+0x117>
        sys_env_destroy(envid);
        return res;
    }
    return envid;
}
  801955:	44 89 e0             	mov    %r12d,%eax
  801958:	5b                   	pop    %rbx
  801959:	41 5c                	pop    %r12
  80195b:	41 5d                	pop    %r13
  80195d:	41 5e                	pop    %r14
  80195f:	5d                   	pop    %rbp
  801960:	c3                   	ret
        thisenv = &envs[ENVX(sys_getenvid())];
  801961:	48 b8 14 14 80 00 00 	movabs $0x801414,%rax
  801968:	00 00 00 
  80196b:	ff d0                	call   *%rax
  80196d:	25 ff 03 00 00       	and    $0x3ff,%eax
  801972:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  801976:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  80197a:	48 c1 e0 04          	shl    $0x4,%rax
  80197e:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  801985:	00 00 00 
  801988:	48 01 d0             	add    %rdx,%rax
  80198b:	48 a3 00 60 80 00 00 	movabs %rax,0x806000
  801992:	00 00 00 
        return 0;
  801995:	eb be                	jmp    801955 <fork+0xad>
        sys_env_destroy(envid);
  801997:	44 89 e7             	mov    %r12d,%edi
  80199a:	48 b8 a5 13 80 00 00 	movabs $0x8013a5,%rax
  8019a1:	00 00 00 
  8019a4:	ff d0                	call   *%rax
        return res;
  8019a6:	45 89 ec             	mov    %r13d,%r12d
  8019a9:	eb aa                	jmp    801955 <fork+0xad>
            sys_env_destroy(envid);
  8019ab:	44 89 e7             	mov    %r12d,%edi
  8019ae:	48 b8 a5 13 80 00 00 	movabs $0x8013a5,%rax
  8019b5:	00 00 00 
  8019b8:	ff d0                	call   *%rax
            return res;
  8019ba:	45 89 ec             	mov    %r13d,%r12d
  8019bd:	eb 96                	jmp    801955 <fork+0xad>
        sys_env_destroy(envid);
  8019bf:	89 df                	mov    %ebx,%edi
  8019c1:	48 b8 a5 13 80 00 00 	movabs $0x8013a5,%rax
  8019c8:	00 00 00 
  8019cb:	ff d0                	call   *%rax
        return res;
  8019cd:	45 89 ec             	mov    %r13d,%r12d
  8019d0:	eb 83                	jmp    801955 <fork+0xad>

00000000008019d2 <sfork>:

envid_t
sfork() {
  8019d2:	f3 0f 1e fa          	endbr64
  8019d6:	55                   	push   %rbp
  8019d7:	48 89 e5             	mov    %rsp,%rbp
    panic("sfork() is not implemented");
  8019da:	48 ba 60 43 80 00 00 	movabs $0x804360,%rdx
  8019e1:	00 00 00 
  8019e4:	be 37 00 00 00       	mov    $0x37,%esi
  8019e9:	48 bf 7b 43 80 00 00 	movabs $0x80437b,%rdi
  8019f0:	00 00 00 
  8019f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8019f8:	48 b9 3a 04 80 00 00 	movabs $0x80043a,%rcx
  8019ff:	00 00 00 
  801a02:	ff d1                	call   *%rcx

0000000000801a04 <fd2num>:


/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
  801a04:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801a08:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801a0f:	ff ff ff 
  801a12:	48 01 f8             	add    %rdi,%rax
  801a15:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801a19:	c3                   	ret

0000000000801a1a <fd2data>:

char *
fd2data(struct Fd *fd) {
  801a1a:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801a1e:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801a25:	ff ff ff 
  801a28:	48 01 f8             	add    %rdi,%rax
  801a2b:	48 c1 e8 0c          	shr    $0xc,%rax
    return INDEX2DATA(fd2num(fd));
  801a2f:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801a35:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801a39:	c3                   	ret

0000000000801a3a <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  801a3a:	f3 0f 1e fa          	endbr64
  801a3e:	55                   	push   %rbp
  801a3f:	48 89 e5             	mov    %rsp,%rbp
  801a42:	41 57                	push   %r15
  801a44:	41 56                	push   %r14
  801a46:	41 55                	push   %r13
  801a48:	41 54                	push   %r12
  801a4a:	53                   	push   %rbx
  801a4b:	48 83 ec 08          	sub    $0x8,%rsp
  801a4f:	49 89 ff             	mov    %rdi,%r15
  801a52:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  801a57:	49 bd 99 2b 80 00 00 	movabs $0x802b99,%r13
  801a5e:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  801a61:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        struct Fd *fd = INDEX2FD(i);
  801a67:	49 89 dc             	mov    %rbx,%r12
        if (!(get_prot(fd) & PROT_R)) {
  801a6a:	48 89 df             	mov    %rbx,%rdi
  801a6d:	41 ff d5             	call   *%r13
  801a70:	83 e0 04             	and    $0x4,%eax
  801a73:	74 17                	je     801a8c <fd_alloc+0x52>
    for (int i = 0; i < MAXFD; i++) {
  801a75:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  801a7c:	4c 39 f3             	cmp    %r14,%rbx
  801a7f:	75 e6                	jne    801a67 <fd_alloc+0x2d>
  801a81:	41 bc 00 00 00 00    	mov    $0x0,%r12d
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
    return -E_MAX_OPEN;
  801a87:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
            *fd_store = fd;
  801a8c:	4d 89 27             	mov    %r12,(%r15)
}
  801a8f:	48 83 c4 08          	add    $0x8,%rsp
  801a93:	5b                   	pop    %rbx
  801a94:	41 5c                	pop    %r12
  801a96:	41 5d                	pop    %r13
  801a98:	41 5e                	pop    %r14
  801a9a:	41 5f                	pop    %r15
  801a9c:	5d                   	pop    %rbp
  801a9d:	c3                   	ret

0000000000801a9e <fd_lookup>:
 *
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
  801a9e:	f3 0f 1e fa          	endbr64
    if (fdnum < 0 || fdnum >= MAXFD) {
  801aa2:	83 ff 1f             	cmp    $0x1f,%edi
  801aa5:	77 39                	ja     801ae0 <fd_lookup+0x42>
fd_lookup(int fdnum, struct Fd **fd_store) {
  801aa7:	55                   	push   %rbp
  801aa8:	48 89 e5             	mov    %rsp,%rbp
  801aab:	41 54                	push   %r12
  801aad:	53                   	push   %rbx
  801aae:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  801ab1:	48 63 df             	movslq %edi,%rbx
  801ab4:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  801abb:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  801abf:	48 89 df             	mov    %rbx,%rdi
  801ac2:	48 b8 99 2b 80 00 00 	movabs $0x802b99,%rax
  801ac9:	00 00 00 
  801acc:	ff d0                	call   *%rax
  801ace:	a8 04                	test   $0x4,%al
  801ad0:	74 14                	je     801ae6 <fd_lookup+0x48>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  801ad2:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  801ad6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801adb:	5b                   	pop    %rbx
  801adc:	41 5c                	pop    %r12
  801ade:	5d                   	pop    %rbp
  801adf:	c3                   	ret
        return -E_INVAL;
  801ae0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801ae5:	c3                   	ret
        return -E_INVAL;
  801ae6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801aeb:	eb ee                	jmp    801adb <fd_lookup+0x3d>

0000000000801aed <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  801aed:	f3 0f 1e fa          	endbr64
  801af1:	55                   	push   %rbp
  801af2:	48 89 e5             	mov    %rsp,%rbp
  801af5:	41 54                	push   %r12
  801af7:	53                   	push   %rbx
  801af8:	49 89 f4             	mov    %rsi,%r12
    for (size_t i = 0; devtab[i]; i++) {
  801afb:	48 b8 e0 47 80 00 00 	movabs $0x8047e0,%rax
  801b02:	00 00 00 
  801b05:	48 bb 20 50 80 00 00 	movabs $0x805020,%rbx
  801b0c:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  801b0f:	39 3b                	cmp    %edi,(%rbx)
  801b11:	74 47                	je     801b5a <dev_lookup+0x6d>
    for (size_t i = 0; devtab[i]; i++) {
  801b13:	48 83 c0 08          	add    $0x8,%rax
  801b17:	48 8b 18             	mov    (%rax),%rbx
  801b1a:	48 85 db             	test   %rbx,%rbx
  801b1d:	75 f0                	jne    801b0f <dev_lookup+0x22>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801b1f:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801b26:	00 00 00 
  801b29:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801b2f:	89 fa                	mov    %edi,%edx
  801b31:	48 bf 98 40 80 00 00 	movabs $0x804098,%rdi
  801b38:	00 00 00 
  801b3b:	b8 00 00 00 00       	mov    $0x0,%eax
  801b40:	48 b9 96 05 80 00 00 	movabs $0x800596,%rcx
  801b47:	00 00 00 
  801b4a:	ff d1                	call   *%rcx
    *dev = 0;
    return -E_INVAL;
  801b4c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
            *dev = devtab[i];
  801b51:	49 89 1c 24          	mov    %rbx,(%r12)
}
  801b55:	5b                   	pop    %rbx
  801b56:	41 5c                	pop    %r12
  801b58:	5d                   	pop    %rbp
  801b59:	c3                   	ret
            return 0;
  801b5a:	b8 00 00 00 00       	mov    $0x0,%eax
  801b5f:	eb f0                	jmp    801b51 <dev_lookup+0x64>

0000000000801b61 <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  801b61:	f3 0f 1e fa          	endbr64
  801b65:	55                   	push   %rbp
  801b66:	48 89 e5             	mov    %rsp,%rbp
  801b69:	41 55                	push   %r13
  801b6b:	41 54                	push   %r12
  801b6d:	53                   	push   %rbx
  801b6e:	48 83 ec 18          	sub    $0x18,%rsp
  801b72:	48 89 fb             	mov    %rdi,%rbx
  801b75:	41 89 f4             	mov    %esi,%r12d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801b78:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  801b7f:	ff ff ff 
  801b82:	48 01 df             	add    %rbx,%rdi
  801b85:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  801b89:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801b8d:	48 b8 9e 1a 80 00 00 	movabs $0x801a9e,%rax
  801b94:	00 00 00 
  801b97:	ff d0                	call   *%rax
  801b99:	41 89 c5             	mov    %eax,%r13d
  801b9c:	85 c0                	test   %eax,%eax
  801b9e:	78 06                	js     801ba6 <fd_close+0x45>
  801ba0:	48 39 5d d8          	cmp    %rbx,-0x28(%rbp)
  801ba4:	74 1a                	je     801bc0 <fd_close+0x5f>
        return (must_exist ? res : 0);
  801ba6:	45 84 e4             	test   %r12b,%r12b
  801ba9:	b8 00 00 00 00       	mov    $0x0,%eax
  801bae:	44 0f 44 e8          	cmove  %eax,%r13d
}
  801bb2:	44 89 e8             	mov    %r13d,%eax
  801bb5:	48 83 c4 18          	add    $0x18,%rsp
  801bb9:	5b                   	pop    %rbx
  801bba:	41 5c                	pop    %r12
  801bbc:	41 5d                	pop    %r13
  801bbe:	5d                   	pop    %rbp
  801bbf:	c3                   	ret
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801bc0:	8b 3b                	mov    (%rbx),%edi
  801bc2:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801bc6:	48 b8 ed 1a 80 00 00 	movabs $0x801aed,%rax
  801bcd:	00 00 00 
  801bd0:	ff d0                	call   *%rax
  801bd2:	41 89 c5             	mov    %eax,%r13d
  801bd5:	85 c0                	test   %eax,%eax
  801bd7:	78 1b                	js     801bf4 <fd_close+0x93>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  801bd9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801bdd:	48 8b 40 20          	mov    0x20(%rax),%rax
  801be1:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  801be7:	48 85 c0             	test   %rax,%rax
  801bea:	74 08                	je     801bf4 <fd_close+0x93>
  801bec:	48 89 df             	mov    %rbx,%rdi
  801bef:	ff d0                	call   *%rax
  801bf1:	41 89 c5             	mov    %eax,%r13d
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801bf4:	ba 00 10 00 00       	mov    $0x1000,%edx
  801bf9:	48 89 de             	mov    %rbx,%rsi
  801bfc:	bf 00 00 00 00       	mov    $0x0,%edi
  801c01:	48 b8 24 16 80 00 00 	movabs $0x801624,%rax
  801c08:	00 00 00 
  801c0b:	ff d0                	call   *%rax
    return res;
  801c0d:	eb a3                	jmp    801bb2 <fd_close+0x51>

0000000000801c0f <close>:

int
close(int fdnum) {
  801c0f:	f3 0f 1e fa          	endbr64
  801c13:	55                   	push   %rbp
  801c14:	48 89 e5             	mov    %rsp,%rbp
  801c17:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  801c1b:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801c1f:	48 b8 9e 1a 80 00 00 	movabs $0x801a9e,%rax
  801c26:	00 00 00 
  801c29:	ff d0                	call   *%rax
    if (res < 0) return res;
  801c2b:	85 c0                	test   %eax,%eax
  801c2d:	78 15                	js     801c44 <close+0x35>

    return fd_close(fd, 1);
  801c2f:	be 01 00 00 00       	mov    $0x1,%esi
  801c34:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801c38:	48 b8 61 1b 80 00 00 	movabs $0x801b61,%rax
  801c3f:	00 00 00 
  801c42:	ff d0                	call   *%rax
}
  801c44:	c9                   	leave
  801c45:	c3                   	ret

0000000000801c46 <close_all>:

void
close_all(void) {
  801c46:	f3 0f 1e fa          	endbr64
  801c4a:	55                   	push   %rbp
  801c4b:	48 89 e5             	mov    %rsp,%rbp
  801c4e:	41 54                	push   %r12
  801c50:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  801c51:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c56:	49 bc 0f 1c 80 00 00 	movabs $0x801c0f,%r12
  801c5d:	00 00 00 
  801c60:	89 df                	mov    %ebx,%edi
  801c62:	41 ff d4             	call   *%r12
  801c65:	83 c3 01             	add    $0x1,%ebx
  801c68:	83 fb 20             	cmp    $0x20,%ebx
  801c6b:	75 f3                	jne    801c60 <close_all+0x1a>
}
  801c6d:	5b                   	pop    %rbx
  801c6e:	41 5c                	pop    %r12
  801c70:	5d                   	pop    %rbp
  801c71:	c3                   	ret

0000000000801c72 <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  801c72:	f3 0f 1e fa          	endbr64
  801c76:	55                   	push   %rbp
  801c77:	48 89 e5             	mov    %rsp,%rbp
  801c7a:	41 57                	push   %r15
  801c7c:	41 56                	push   %r14
  801c7e:	41 55                	push   %r13
  801c80:	41 54                	push   %r12
  801c82:	53                   	push   %rbx
  801c83:	48 83 ec 18          	sub    $0x18,%rsp
  801c87:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  801c8a:	48 8d 75 c8          	lea    -0x38(%rbp),%rsi
  801c8e:	48 b8 9e 1a 80 00 00 	movabs $0x801a9e,%rax
  801c95:	00 00 00 
  801c98:	ff d0                	call   *%rax
  801c9a:	89 c3                	mov    %eax,%ebx
  801c9c:	85 c0                	test   %eax,%eax
  801c9e:	0f 88 b8 00 00 00    	js     801d5c <dup+0xea>
    close(newfdnum);
  801ca4:	44 89 e7             	mov    %r12d,%edi
  801ca7:	48 b8 0f 1c 80 00 00 	movabs $0x801c0f,%rax
  801cae:	00 00 00 
  801cb1:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  801cb3:	4d 63 ec             	movslq %r12d,%r13
  801cb6:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  801cbd:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  801cc1:	4c 8b 7d c8          	mov    -0x38(%rbp),%r15
  801cc5:	4c 89 ff             	mov    %r15,%rdi
  801cc8:	49 be 1a 1a 80 00 00 	movabs $0x801a1a,%r14
  801ccf:	00 00 00 
  801cd2:	41 ff d6             	call   *%r14
  801cd5:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  801cd8:	4c 89 ef             	mov    %r13,%rdi
  801cdb:	41 ff d6             	call   *%r14
  801cde:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  801ce1:	48 89 df             	mov    %rbx,%rdi
  801ce4:	48 b8 99 2b 80 00 00 	movabs $0x802b99,%rax
  801ceb:	00 00 00 
  801cee:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  801cf0:	a8 04                	test   $0x4,%al
  801cf2:	74 2b                	je     801d1f <dup+0xad>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  801cf4:	41 89 c1             	mov    %eax,%r9d
  801cf7:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801cfd:	4c 89 f1             	mov    %r14,%rcx
  801d00:	ba 00 00 00 00       	mov    $0x0,%edx
  801d05:	48 89 de             	mov    %rbx,%rsi
  801d08:	bf 00 00 00 00       	mov    $0x0,%edi
  801d0d:	48 b8 4f 15 80 00 00 	movabs $0x80154f,%rax
  801d14:	00 00 00 
  801d17:	ff d0                	call   *%rax
  801d19:	89 c3                	mov    %eax,%ebx
  801d1b:	85 c0                	test   %eax,%eax
  801d1d:	78 4e                	js     801d6d <dup+0xfb>
    }
    prot = get_prot(oldfd);
  801d1f:	4c 89 ff             	mov    %r15,%rdi
  801d22:	48 b8 99 2b 80 00 00 	movabs $0x802b99,%rax
  801d29:	00 00 00 
  801d2c:	ff d0                	call   *%rax
  801d2e:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  801d31:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801d37:	4c 89 e9             	mov    %r13,%rcx
  801d3a:	ba 00 00 00 00       	mov    $0x0,%edx
  801d3f:	4c 89 fe             	mov    %r15,%rsi
  801d42:	bf 00 00 00 00       	mov    $0x0,%edi
  801d47:	48 b8 4f 15 80 00 00 	movabs $0x80154f,%rax
  801d4e:	00 00 00 
  801d51:	ff d0                	call   *%rax
  801d53:	89 c3                	mov    %eax,%ebx
  801d55:	85 c0                	test   %eax,%eax
  801d57:	78 14                	js     801d6d <dup+0xfb>

    return newfdnum;
  801d59:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  801d5c:	89 d8                	mov    %ebx,%eax
  801d5e:	48 83 c4 18          	add    $0x18,%rsp
  801d62:	5b                   	pop    %rbx
  801d63:	41 5c                	pop    %r12
  801d65:	41 5d                	pop    %r13
  801d67:	41 5e                	pop    %r14
  801d69:	41 5f                	pop    %r15
  801d6b:	5d                   	pop    %rbp
  801d6c:	c3                   	ret
    sys_unmap_region(0, newfd, PAGE_SIZE);
  801d6d:	ba 00 10 00 00       	mov    $0x1000,%edx
  801d72:	4c 89 ee             	mov    %r13,%rsi
  801d75:	bf 00 00 00 00       	mov    $0x0,%edi
  801d7a:	49 bc 24 16 80 00 00 	movabs $0x801624,%r12
  801d81:	00 00 00 
  801d84:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  801d87:	ba 00 10 00 00       	mov    $0x1000,%edx
  801d8c:	4c 89 f6             	mov    %r14,%rsi
  801d8f:	bf 00 00 00 00       	mov    $0x0,%edi
  801d94:	41 ff d4             	call   *%r12
    return res;
  801d97:	eb c3                	jmp    801d5c <dup+0xea>

0000000000801d99 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  801d99:	f3 0f 1e fa          	endbr64
  801d9d:	55                   	push   %rbp
  801d9e:	48 89 e5             	mov    %rsp,%rbp
  801da1:	41 56                	push   %r14
  801da3:	41 55                	push   %r13
  801da5:	41 54                	push   %r12
  801da7:	53                   	push   %rbx
  801da8:	48 83 ec 10          	sub    $0x10,%rsp
  801dac:	89 fb                	mov    %edi,%ebx
  801dae:	49 89 f4             	mov    %rsi,%r12
  801db1:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801db4:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801db8:	48 b8 9e 1a 80 00 00 	movabs $0x801a9e,%rax
  801dbf:	00 00 00 
  801dc2:	ff d0                	call   *%rax
  801dc4:	85 c0                	test   %eax,%eax
  801dc6:	78 4c                	js     801e14 <read+0x7b>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801dc8:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801dcc:	41 8b 3e             	mov    (%r14),%edi
  801dcf:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801dd3:	48 b8 ed 1a 80 00 00 	movabs $0x801aed,%rax
  801dda:	00 00 00 
  801ddd:	ff d0                	call   *%rax
  801ddf:	85 c0                	test   %eax,%eax
  801de1:	78 35                	js     801e18 <read+0x7f>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801de3:	41 8b 46 08          	mov    0x8(%r14),%eax
  801de7:	83 e0 03             	and    $0x3,%eax
  801dea:	83 f8 01             	cmp    $0x1,%eax
  801ded:	74 2d                	je     801e1c <read+0x83>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  801def:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801df3:	48 8b 40 10          	mov    0x10(%rax),%rax
  801df7:	48 85 c0             	test   %rax,%rax
  801dfa:	74 56                	je     801e52 <read+0xb9>

    return (*dev->dev_read)(fd, buf, n);
  801dfc:	4c 89 ea             	mov    %r13,%rdx
  801dff:	4c 89 e6             	mov    %r12,%rsi
  801e02:	4c 89 f7             	mov    %r14,%rdi
  801e05:	ff d0                	call   *%rax
}
  801e07:	48 83 c4 10          	add    $0x10,%rsp
  801e0b:	5b                   	pop    %rbx
  801e0c:	41 5c                	pop    %r12
  801e0e:	41 5d                	pop    %r13
  801e10:	41 5e                	pop    %r14
  801e12:	5d                   	pop    %rbp
  801e13:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801e14:	48 98                	cltq
  801e16:	eb ef                	jmp    801e07 <read+0x6e>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801e18:	48 98                	cltq
  801e1a:	eb eb                	jmp    801e07 <read+0x6e>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801e1c:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801e23:	00 00 00 
  801e26:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801e2c:	89 da                	mov    %ebx,%edx
  801e2e:	48 bf 86 43 80 00 00 	movabs $0x804386,%rdi
  801e35:	00 00 00 
  801e38:	b8 00 00 00 00       	mov    $0x0,%eax
  801e3d:	48 b9 96 05 80 00 00 	movabs $0x800596,%rcx
  801e44:	00 00 00 
  801e47:	ff d1                	call   *%rcx
        return -E_INVAL;
  801e49:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801e50:	eb b5                	jmp    801e07 <read+0x6e>
    if (!dev->dev_read) return -E_NOT_SUPP;
  801e52:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801e59:	eb ac                	jmp    801e07 <read+0x6e>

0000000000801e5b <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801e5b:	f3 0f 1e fa          	endbr64
  801e5f:	55                   	push   %rbp
  801e60:	48 89 e5             	mov    %rsp,%rbp
  801e63:	41 57                	push   %r15
  801e65:	41 56                	push   %r14
  801e67:	41 55                	push   %r13
  801e69:	41 54                	push   %r12
  801e6b:	53                   	push   %rbx
  801e6c:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801e70:	48 85 d2             	test   %rdx,%rdx
  801e73:	74 54                	je     801ec9 <readn+0x6e>
  801e75:	41 89 fd             	mov    %edi,%r13d
  801e78:	49 89 f6             	mov    %rsi,%r14
  801e7b:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801e7e:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801e83:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801e88:	49 bf 99 1d 80 00 00 	movabs $0x801d99,%r15
  801e8f:	00 00 00 
  801e92:	4c 89 e2             	mov    %r12,%rdx
  801e95:	48 29 f2             	sub    %rsi,%rdx
  801e98:	4c 01 f6             	add    %r14,%rsi
  801e9b:	44 89 ef             	mov    %r13d,%edi
  801e9e:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  801ea1:	85 c0                	test   %eax,%eax
  801ea3:	78 20                	js     801ec5 <readn+0x6a>
    for (; inc && res < n; res += inc) {
  801ea5:	01 c3                	add    %eax,%ebx
  801ea7:	85 c0                	test   %eax,%eax
  801ea9:	74 08                	je     801eb3 <readn+0x58>
  801eab:	48 63 f3             	movslq %ebx,%rsi
  801eae:	4c 39 e6             	cmp    %r12,%rsi
  801eb1:	72 df                	jb     801e92 <readn+0x37>
    }
    return res;
  801eb3:	48 63 c3             	movslq %ebx,%rax
}
  801eb6:	48 83 c4 08          	add    $0x8,%rsp
  801eba:	5b                   	pop    %rbx
  801ebb:	41 5c                	pop    %r12
  801ebd:	41 5d                	pop    %r13
  801ebf:	41 5e                	pop    %r14
  801ec1:	41 5f                	pop    %r15
  801ec3:	5d                   	pop    %rbp
  801ec4:	c3                   	ret
        if (inc < 0) return inc;
  801ec5:	48 98                	cltq
  801ec7:	eb ed                	jmp    801eb6 <readn+0x5b>
    int inc = 1, res = 0;
  801ec9:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ece:	eb e3                	jmp    801eb3 <readn+0x58>

0000000000801ed0 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  801ed0:	f3 0f 1e fa          	endbr64
  801ed4:	55                   	push   %rbp
  801ed5:	48 89 e5             	mov    %rsp,%rbp
  801ed8:	41 56                	push   %r14
  801eda:	41 55                	push   %r13
  801edc:	41 54                	push   %r12
  801ede:	53                   	push   %rbx
  801edf:	48 83 ec 10          	sub    $0x10,%rsp
  801ee3:	89 fb                	mov    %edi,%ebx
  801ee5:	49 89 f4             	mov    %rsi,%r12
  801ee8:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801eeb:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801eef:	48 b8 9e 1a 80 00 00 	movabs $0x801a9e,%rax
  801ef6:	00 00 00 
  801ef9:	ff d0                	call   *%rax
  801efb:	85 c0                	test   %eax,%eax
  801efd:	78 47                	js     801f46 <write+0x76>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801eff:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801f03:	41 8b 3e             	mov    (%r14),%edi
  801f06:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801f0a:	48 b8 ed 1a 80 00 00 	movabs $0x801aed,%rax
  801f11:	00 00 00 
  801f14:	ff d0                	call   *%rax
  801f16:	85 c0                	test   %eax,%eax
  801f18:	78 30                	js     801f4a <write+0x7a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801f1a:	41 f6 46 08 03       	testb  $0x3,0x8(%r14)
  801f1f:	74 2d                	je     801f4e <write+0x7e>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801f21:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801f25:	48 8b 40 18          	mov    0x18(%rax),%rax
  801f29:	48 85 c0             	test   %rax,%rax
  801f2c:	74 56                	je     801f84 <write+0xb4>

    return (*dev->dev_write)(fd, buf, n);
  801f2e:	4c 89 ea             	mov    %r13,%rdx
  801f31:	4c 89 e6             	mov    %r12,%rsi
  801f34:	4c 89 f7             	mov    %r14,%rdi
  801f37:	ff d0                	call   *%rax
}
  801f39:	48 83 c4 10          	add    $0x10,%rsp
  801f3d:	5b                   	pop    %rbx
  801f3e:	41 5c                	pop    %r12
  801f40:	41 5d                	pop    %r13
  801f42:	41 5e                	pop    %r14
  801f44:	5d                   	pop    %rbp
  801f45:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801f46:	48 98                	cltq
  801f48:	eb ef                	jmp    801f39 <write+0x69>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801f4a:	48 98                	cltq
  801f4c:	eb eb                	jmp    801f39 <write+0x69>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801f4e:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801f55:	00 00 00 
  801f58:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801f5e:	89 da                	mov    %ebx,%edx
  801f60:	48 bf a2 43 80 00 00 	movabs $0x8043a2,%rdi
  801f67:	00 00 00 
  801f6a:	b8 00 00 00 00       	mov    $0x0,%eax
  801f6f:	48 b9 96 05 80 00 00 	movabs $0x800596,%rcx
  801f76:	00 00 00 
  801f79:	ff d1                	call   *%rcx
        return -E_INVAL;
  801f7b:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801f82:	eb b5                	jmp    801f39 <write+0x69>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801f84:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801f8b:	eb ac                	jmp    801f39 <write+0x69>

0000000000801f8d <seek>:

int
seek(int fdnum, off_t offset) {
  801f8d:	f3 0f 1e fa          	endbr64
  801f91:	55                   	push   %rbp
  801f92:	48 89 e5             	mov    %rsp,%rbp
  801f95:	53                   	push   %rbx
  801f96:	48 83 ec 18          	sub    $0x18,%rsp
  801f9a:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801f9c:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801fa0:	48 b8 9e 1a 80 00 00 	movabs $0x801a9e,%rax
  801fa7:	00 00 00 
  801faa:	ff d0                	call   *%rax
  801fac:	85 c0                	test   %eax,%eax
  801fae:	78 0c                	js     801fbc <seek+0x2f>

    fd->fd_offset = offset;
  801fb0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fb4:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  801fb7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fbc:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801fc0:	c9                   	leave
  801fc1:	c3                   	ret

0000000000801fc2 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  801fc2:	f3 0f 1e fa          	endbr64
  801fc6:	55                   	push   %rbp
  801fc7:	48 89 e5             	mov    %rsp,%rbp
  801fca:	41 55                	push   %r13
  801fcc:	41 54                	push   %r12
  801fce:	53                   	push   %rbx
  801fcf:	48 83 ec 18          	sub    $0x18,%rsp
  801fd3:	89 fb                	mov    %edi,%ebx
  801fd5:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801fd8:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801fdc:	48 b8 9e 1a 80 00 00 	movabs $0x801a9e,%rax
  801fe3:	00 00 00 
  801fe6:	ff d0                	call   *%rax
  801fe8:	85 c0                	test   %eax,%eax
  801fea:	78 38                	js     802024 <ftruncate+0x62>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801fec:	4c 8b 6d d8          	mov    -0x28(%rbp),%r13
  801ff0:	41 8b 7d 00          	mov    0x0(%r13),%edi
  801ff4:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801ff8:	48 b8 ed 1a 80 00 00 	movabs $0x801aed,%rax
  801fff:	00 00 00 
  802002:	ff d0                	call   *%rax
  802004:	85 c0                	test   %eax,%eax
  802006:	78 1c                	js     802024 <ftruncate+0x62>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802008:	41 f6 45 08 03       	testb  $0x3,0x8(%r13)
  80200d:	74 20                	je     80202f <ftruncate+0x6d>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  80200f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802013:	48 8b 40 30          	mov    0x30(%rax),%rax
  802017:	48 85 c0             	test   %rax,%rax
  80201a:	74 47                	je     802063 <ftruncate+0xa1>

    return (*dev->dev_trunc)(fd, newsize);
  80201c:	44 89 e6             	mov    %r12d,%esi
  80201f:	4c 89 ef             	mov    %r13,%rdi
  802022:	ff d0                	call   *%rax
}
  802024:	48 83 c4 18          	add    $0x18,%rsp
  802028:	5b                   	pop    %rbx
  802029:	41 5c                	pop    %r12
  80202b:	41 5d                	pop    %r13
  80202d:	5d                   	pop    %rbp
  80202e:	c3                   	ret
                thisenv->env_id, fdnum);
  80202f:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  802036:	00 00 00 
  802039:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  80203f:	89 da                	mov    %ebx,%edx
  802041:	48 bf b8 40 80 00 00 	movabs $0x8040b8,%rdi
  802048:	00 00 00 
  80204b:	b8 00 00 00 00       	mov    $0x0,%eax
  802050:	48 b9 96 05 80 00 00 	movabs $0x800596,%rcx
  802057:	00 00 00 
  80205a:	ff d1                	call   *%rcx
        return -E_INVAL;
  80205c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802061:	eb c1                	jmp    802024 <ftruncate+0x62>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  802063:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  802068:	eb ba                	jmp    802024 <ftruncate+0x62>

000000000080206a <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  80206a:	f3 0f 1e fa          	endbr64
  80206e:	55                   	push   %rbp
  80206f:	48 89 e5             	mov    %rsp,%rbp
  802072:	41 54                	push   %r12
  802074:	53                   	push   %rbx
  802075:	48 83 ec 10          	sub    $0x10,%rsp
  802079:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  80207c:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  802080:	48 b8 9e 1a 80 00 00 	movabs $0x801a9e,%rax
  802087:	00 00 00 
  80208a:	ff d0                	call   *%rax
  80208c:	85 c0                	test   %eax,%eax
  80208e:	78 4e                	js     8020de <fstat+0x74>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  802090:	4c 8b 65 e8          	mov    -0x18(%rbp),%r12
  802094:	41 8b 3c 24          	mov    (%r12),%edi
  802098:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  80209c:	48 b8 ed 1a 80 00 00 	movabs $0x801aed,%rax
  8020a3:	00 00 00 
  8020a6:	ff d0                	call   *%rax
  8020a8:	85 c0                	test   %eax,%eax
  8020aa:	78 32                	js     8020de <fstat+0x74>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  8020ac:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020b0:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  8020b5:	74 30                	je     8020e7 <fstat+0x7d>

    stat->st_name[0] = 0;
  8020b7:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  8020ba:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  8020c1:	00 00 00 
    stat->st_isdir = 0;
  8020c4:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  8020cb:	00 00 00 
    stat->st_dev = dev;
  8020ce:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  8020d5:	48 89 de             	mov    %rbx,%rsi
  8020d8:	4c 89 e7             	mov    %r12,%rdi
  8020db:	ff 50 28             	call   *0x28(%rax)
}
  8020de:	48 83 c4 10          	add    $0x10,%rsp
  8020e2:	5b                   	pop    %rbx
  8020e3:	41 5c                	pop    %r12
  8020e5:	5d                   	pop    %rbp
  8020e6:	c3                   	ret
    if (!dev->dev_stat) return -E_NOT_SUPP;
  8020e7:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  8020ec:	eb f0                	jmp    8020de <fstat+0x74>

00000000008020ee <stat>:

int
stat(const char *path, struct Stat *stat) {
  8020ee:	f3 0f 1e fa          	endbr64
  8020f2:	55                   	push   %rbp
  8020f3:	48 89 e5             	mov    %rsp,%rbp
  8020f6:	41 54                	push   %r12
  8020f8:	53                   	push   %rbx
  8020f9:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  8020fc:	be 00 00 00 00       	mov    $0x0,%esi
  802101:	48 b8 cf 23 80 00 00 	movabs $0x8023cf,%rax
  802108:	00 00 00 
  80210b:	ff d0                	call   *%rax
  80210d:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  80210f:	85 c0                	test   %eax,%eax
  802111:	78 25                	js     802138 <stat+0x4a>

    int res = fstat(fd, stat);
  802113:	4c 89 e6             	mov    %r12,%rsi
  802116:	89 c7                	mov    %eax,%edi
  802118:	48 b8 6a 20 80 00 00 	movabs $0x80206a,%rax
  80211f:	00 00 00 
  802122:	ff d0                	call   *%rax
  802124:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  802127:	89 df                	mov    %ebx,%edi
  802129:	48 b8 0f 1c 80 00 00 	movabs $0x801c0f,%rax
  802130:	00 00 00 
  802133:	ff d0                	call   *%rax

    return res;
  802135:	44 89 e3             	mov    %r12d,%ebx
}
  802138:	89 d8                	mov    %ebx,%eax
  80213a:	5b                   	pop    %rbx
  80213b:	41 5c                	pop    %r12
  80213d:	5d                   	pop    %rbp
  80213e:	c3                   	ret

000000000080213f <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  80213f:	f3 0f 1e fa          	endbr64
  802143:	55                   	push   %rbp
  802144:	48 89 e5             	mov    %rsp,%rbp
  802147:	41 54                	push   %r12
  802149:	53                   	push   %rbx
  80214a:	48 83 ec 10          	sub    $0x10,%rsp
  80214e:	41 89 fc             	mov    %edi,%r12d
  802151:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  802154:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80215b:	00 00 00 
  80215e:	83 38 00             	cmpl   $0x0,(%rax)
  802161:	74 6e                	je     8021d1 <fsipc+0x92>

    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }
    fsenv = ipc_find_env(ENV_TYPE_FS);
  802163:	bf 03 00 00 00       	mov    $0x3,%edi
  802168:	48 b8 4c 31 80 00 00 	movabs $0x80314c,%rax
  80216f:	00 00 00 
  802172:	ff d0                	call   *%rax
  802174:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  80217b:	00 00 
    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  80217d:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  802183:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802188:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  80218f:	00 00 00 
  802192:	44 89 e6             	mov    %r12d,%esi
  802195:	89 c7                	mov    %eax,%edi
  802197:	48 b8 8a 30 80 00 00 	movabs $0x80308a,%rax
  80219e:	00 00 00 
  8021a1:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  8021a3:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  8021aa:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  8021ab:	b9 00 00 00 00       	mov    $0x0,%ecx
  8021b0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8021b4:	48 89 de             	mov    %rbx,%rsi
  8021b7:	bf 00 00 00 00       	mov    $0x0,%edi
  8021bc:	48 b8 f1 2f 80 00 00 	movabs $0x802ff1,%rax
  8021c3:	00 00 00 
  8021c6:	ff d0                	call   *%rax
}
  8021c8:	48 83 c4 10          	add    $0x10,%rsp
  8021cc:	5b                   	pop    %rbx
  8021cd:	41 5c                	pop    %r12
  8021cf:	5d                   	pop    %rbp
  8021d0:	c3                   	ret
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  8021d1:	bf 03 00 00 00       	mov    $0x3,%edi
  8021d6:	48 b8 4c 31 80 00 00 	movabs $0x80314c,%rax
  8021dd:	00 00 00 
  8021e0:	ff d0                	call   *%rax
  8021e2:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  8021e9:	00 00 
  8021eb:	e9 73 ff ff ff       	jmp    802163 <fsipc+0x24>

00000000008021f0 <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  8021f0:	f3 0f 1e fa          	endbr64
  8021f4:	55                   	push   %rbp
  8021f5:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8021f8:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8021ff:	00 00 00 
  802202:	8b 57 0c             	mov    0xc(%rdi),%edx
  802205:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  802207:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  80220a:	be 00 00 00 00       	mov    $0x0,%esi
  80220f:	bf 02 00 00 00       	mov    $0x2,%edi
  802214:	48 b8 3f 21 80 00 00 	movabs $0x80213f,%rax
  80221b:	00 00 00 
  80221e:	ff d0                	call   *%rax
}
  802220:	5d                   	pop    %rbp
  802221:	c3                   	ret

0000000000802222 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  802222:	f3 0f 1e fa          	endbr64
  802226:	55                   	push   %rbp
  802227:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80222a:	8b 47 0c             	mov    0xc(%rdi),%eax
  80222d:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  802234:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  802236:	be 00 00 00 00       	mov    $0x0,%esi
  80223b:	bf 06 00 00 00       	mov    $0x6,%edi
  802240:	48 b8 3f 21 80 00 00 	movabs $0x80213f,%rax
  802247:	00 00 00 
  80224a:	ff d0                	call   *%rax
}
  80224c:	5d                   	pop    %rbp
  80224d:	c3                   	ret

000000000080224e <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  80224e:	f3 0f 1e fa          	endbr64
  802252:	55                   	push   %rbp
  802253:	48 89 e5             	mov    %rsp,%rbp
  802256:	41 54                	push   %r12
  802258:	53                   	push   %rbx
  802259:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80225c:	8b 47 0c             	mov    0xc(%rdi),%eax
  80225f:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  802266:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  802268:	be 00 00 00 00       	mov    $0x0,%esi
  80226d:	bf 05 00 00 00       	mov    $0x5,%edi
  802272:	48 b8 3f 21 80 00 00 	movabs $0x80213f,%rax
  802279:	00 00 00 
  80227c:	ff d0                	call   *%rax
    if (res < 0) return res;
  80227e:	85 c0                	test   %eax,%eax
  802280:	78 3d                	js     8022bf <devfile_stat+0x71>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802282:	49 bc 00 70 80 00 00 	movabs $0x807000,%r12
  802289:	00 00 00 
  80228c:	4c 89 e6             	mov    %r12,%rsi
  80228f:	48 89 df             	mov    %rbx,%rdi
  802292:	48 b8 df 0e 80 00 00 	movabs $0x800edf,%rax
  802299:	00 00 00 
  80229c:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  80229e:	41 8b 84 24 80 00 00 	mov    0x80(%r12),%eax
  8022a5:	00 
  8022a6:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8022ac:	41 8b 84 24 84 00 00 	mov    0x84(%r12),%eax
  8022b3:	00 
  8022b4:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  8022ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022bf:	5b                   	pop    %rbx
  8022c0:	41 5c                	pop    %r12
  8022c2:	5d                   	pop    %rbp
  8022c3:	c3                   	ret

00000000008022c4 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  8022c4:	f3 0f 1e fa          	endbr64
    if (n >= sizeof(fsipcbuf.write.req_buf)) {
  8022c8:	48 81 fa ef 0f 00 00 	cmp    $0xfef,%rdx
  8022cf:	77 41                	ja     802312 <devfile_write+0x4e>
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  8022d1:	55                   	push   %rbp
  8022d2:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  8022d5:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8022dc:	00 00 00 
  8022df:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  8022e2:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.write.req_n = n;
  8022e4:	48 89 50 08          	mov    %rdx,0x8(%rax)
    memmove(fsipcbuf.write.req_buf, buf, n);
  8022e8:	48 8d 78 10          	lea    0x10(%rax),%rdi
  8022ec:	48 b8 fa 10 80 00 00 	movabs $0x8010fa,%rax
  8022f3:	00 00 00 
  8022f6:	ff d0                	call   *%rax
    res = fsipc(FSREQ_WRITE, NULL);
  8022f8:	be 00 00 00 00       	mov    $0x0,%esi
  8022fd:	bf 04 00 00 00       	mov    $0x4,%edi
  802302:	48 b8 3f 21 80 00 00 	movabs $0x80213f,%rax
  802309:	00 00 00 
  80230c:	ff d0                	call   *%rax
  80230e:	48 98                	cltq
}
  802310:	5d                   	pop    %rbp
  802311:	c3                   	ret
        return -E_INVAL;
  802312:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
}
  802319:	c3                   	ret

000000000080231a <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  80231a:	f3 0f 1e fa          	endbr64
  80231e:	55                   	push   %rbp
  80231f:	48 89 e5             	mov    %rsp,%rbp
  802322:	41 55                	push   %r13
  802324:	41 54                	push   %r12
  802326:	53                   	push   %rbx
  802327:	48 83 ec 08          	sub    $0x8,%rsp
  80232b:	49 89 f4             	mov    %rsi,%r12
  80232e:	48 89 d3             	mov    %rdx,%rbx
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  802331:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802338:	00 00 00 
  80233b:	8b 57 0c             	mov    0xc(%rdi),%edx
  80233e:	89 10                	mov    %edx,(%rax)
    fsipcbuf.read.req_n = n;
  802340:	48 89 58 08          	mov    %rbx,0x8(%rax)
    res = fsipc(FSREQ_READ, NULL);
  802344:	be 00 00 00 00       	mov    $0x0,%esi
  802349:	bf 03 00 00 00       	mov    $0x3,%edi
  80234e:	48 b8 3f 21 80 00 00 	movabs $0x80213f,%rax
  802355:	00 00 00 
  802358:	ff d0                	call   *%rax
  80235a:	4c 63 e8             	movslq %eax,%r13
    if (res < 0) {
  80235d:	4d 85 ed             	test   %r13,%r13
  802360:	78 2a                	js     80238c <devfile_read+0x72>
    assert(res <= n && res <= PAGE_SIZE);
  802362:	4c 89 ea             	mov    %r13,%rdx
  802365:	4c 39 eb             	cmp    %r13,%rbx
  802368:	72 30                	jb     80239a <devfile_read+0x80>
  80236a:	49 81 fd 00 10 00 00 	cmp    $0x1000,%r13
  802371:	7f 27                	jg     80239a <devfile_read+0x80>
    memmove(buf, &fsipcbuf, res);
  802373:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  80237a:	00 00 00 
  80237d:	4c 89 e7             	mov    %r12,%rdi
  802380:	48 b8 fa 10 80 00 00 	movabs $0x8010fa,%rax
  802387:	00 00 00 
  80238a:	ff d0                	call   *%rax
}
  80238c:	4c 89 e8             	mov    %r13,%rax
  80238f:	48 83 c4 08          	add    $0x8,%rsp
  802393:	5b                   	pop    %rbx
  802394:	41 5c                	pop    %r12
  802396:	41 5d                	pop    %r13
  802398:	5d                   	pop    %rbp
  802399:	c3                   	ret
    assert(res <= n && res <= PAGE_SIZE);
  80239a:	48 b9 bf 43 80 00 00 	movabs $0x8043bf,%rcx
  8023a1:	00 00 00 
  8023a4:	48 ba dc 43 80 00 00 	movabs $0x8043dc,%rdx
  8023ab:	00 00 00 
  8023ae:	be 7b 00 00 00       	mov    $0x7b,%esi
  8023b3:	48 bf f1 43 80 00 00 	movabs $0x8043f1,%rdi
  8023ba:	00 00 00 
  8023bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8023c2:	49 b8 3a 04 80 00 00 	movabs $0x80043a,%r8
  8023c9:	00 00 00 
  8023cc:	41 ff d0             	call   *%r8

00000000008023cf <open>:
open(const char *path, int mode) {
  8023cf:	f3 0f 1e fa          	endbr64
  8023d3:	55                   	push   %rbp
  8023d4:	48 89 e5             	mov    %rsp,%rbp
  8023d7:	41 55                	push   %r13
  8023d9:	41 54                	push   %r12
  8023db:	53                   	push   %rbx
  8023dc:	48 83 ec 18          	sub    $0x18,%rsp
  8023e0:	49 89 fc             	mov    %rdi,%r12
  8023e3:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  8023e6:	48 b8 9a 0e 80 00 00 	movabs $0x800e9a,%rax
  8023ed:	00 00 00 
  8023f0:	ff d0                	call   *%rax
  8023f2:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  8023f8:	0f 87 8a 00 00 00    	ja     802488 <open+0xb9>
    if ((res = fd_alloc(&fd)) < 0) return res;
  8023fe:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802402:	48 b8 3a 1a 80 00 00 	movabs $0x801a3a,%rax
  802409:	00 00 00 
  80240c:	ff d0                	call   *%rax
  80240e:	89 c3                	mov    %eax,%ebx
  802410:	85 c0                	test   %eax,%eax
  802412:	78 50                	js     802464 <open+0x95>
    strcpy(fsipcbuf.open.req_path, path);
  802414:	4c 89 e6             	mov    %r12,%rsi
  802417:	48 bb 00 70 80 00 00 	movabs $0x807000,%rbx
  80241e:	00 00 00 
  802421:	48 89 df             	mov    %rbx,%rdi
  802424:	48 b8 df 0e 80 00 00 	movabs $0x800edf,%rax
  80242b:	00 00 00 
  80242e:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  802430:	44 89 ab 00 04 00 00 	mov    %r13d,0x400(%rbx)
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  802437:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80243b:	bf 01 00 00 00       	mov    $0x1,%edi
  802440:	48 b8 3f 21 80 00 00 	movabs $0x80213f,%rax
  802447:	00 00 00 
  80244a:	ff d0                	call   *%rax
  80244c:	89 c3                	mov    %eax,%ebx
  80244e:	85 c0                	test   %eax,%eax
  802450:	78 1f                	js     802471 <open+0xa2>
    return fd2num(fd);
  802452:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802456:	48 b8 04 1a 80 00 00 	movabs $0x801a04,%rax
  80245d:	00 00 00 
  802460:	ff d0                	call   *%rax
  802462:	89 c3                	mov    %eax,%ebx
}
  802464:	89 d8                	mov    %ebx,%eax
  802466:	48 83 c4 18          	add    $0x18,%rsp
  80246a:	5b                   	pop    %rbx
  80246b:	41 5c                	pop    %r12
  80246d:	41 5d                	pop    %r13
  80246f:	5d                   	pop    %rbp
  802470:	c3                   	ret
        fd_close(fd, 0);
  802471:	be 00 00 00 00       	mov    $0x0,%esi
  802476:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80247a:	48 b8 61 1b 80 00 00 	movabs $0x801b61,%rax
  802481:	00 00 00 
  802484:	ff d0                	call   *%rax
        return res;
  802486:	eb dc                	jmp    802464 <open+0x95>
        return -E_BAD_PATH;
  802488:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  80248d:	eb d5                	jmp    802464 <open+0x95>

000000000080248f <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  80248f:	f3 0f 1e fa          	endbr64
  802493:	55                   	push   %rbp
  802494:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  802497:	be 00 00 00 00       	mov    $0x0,%esi
  80249c:	bf 08 00 00 00       	mov    $0x8,%edi
  8024a1:	48 b8 3f 21 80 00 00 	movabs $0x80213f,%rax
  8024a8:	00 00 00 
  8024ab:	ff d0                	call   *%rax
}
  8024ad:	5d                   	pop    %rbp
  8024ae:	c3                   	ret

00000000008024af <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  8024af:	f3 0f 1e fa          	endbr64
  8024b3:	55                   	push   %rbp
  8024b4:	48 89 e5             	mov    %rsp,%rbp
  8024b7:	41 54                	push   %r12
  8024b9:	53                   	push   %rbx
  8024ba:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8024bd:	48 b8 1a 1a 80 00 00 	movabs $0x801a1a,%rax
  8024c4:	00 00 00 
  8024c7:	ff d0                	call   *%rax
  8024c9:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  8024cc:	48 be fc 43 80 00 00 	movabs $0x8043fc,%rsi
  8024d3:	00 00 00 
  8024d6:	48 89 df             	mov    %rbx,%rdi
  8024d9:	48 b8 df 0e 80 00 00 	movabs $0x800edf,%rax
  8024e0:	00 00 00 
  8024e3:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  8024e5:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  8024ea:	41 2b 04 24          	sub    (%r12),%eax
  8024ee:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  8024f4:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  8024fb:	00 00 00 
    stat->st_dev = &devpipe;
  8024fe:	48 b8 60 50 80 00 00 	movabs $0x805060,%rax
  802505:	00 00 00 
  802508:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  80250f:	b8 00 00 00 00       	mov    $0x0,%eax
  802514:	5b                   	pop    %rbx
  802515:	41 5c                	pop    %r12
  802517:	5d                   	pop    %rbp
  802518:	c3                   	ret

0000000000802519 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  802519:	f3 0f 1e fa          	endbr64
  80251d:	55                   	push   %rbp
  80251e:	48 89 e5             	mov    %rsp,%rbp
  802521:	41 54                	push   %r12
  802523:	53                   	push   %rbx
  802524:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  802527:	ba 00 10 00 00       	mov    $0x1000,%edx
  80252c:	48 89 fe             	mov    %rdi,%rsi
  80252f:	bf 00 00 00 00       	mov    $0x0,%edi
  802534:	49 bc 24 16 80 00 00 	movabs $0x801624,%r12
  80253b:	00 00 00 
  80253e:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  802541:	48 89 df             	mov    %rbx,%rdi
  802544:	48 b8 1a 1a 80 00 00 	movabs $0x801a1a,%rax
  80254b:	00 00 00 
  80254e:	ff d0                	call   *%rax
  802550:	48 89 c6             	mov    %rax,%rsi
  802553:	ba 00 10 00 00       	mov    $0x1000,%edx
  802558:	bf 00 00 00 00       	mov    $0x0,%edi
  80255d:	41 ff d4             	call   *%r12
}
  802560:	5b                   	pop    %rbx
  802561:	41 5c                	pop    %r12
  802563:	5d                   	pop    %rbp
  802564:	c3                   	ret

0000000000802565 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  802565:	f3 0f 1e fa          	endbr64
  802569:	55                   	push   %rbp
  80256a:	48 89 e5             	mov    %rsp,%rbp
  80256d:	41 57                	push   %r15
  80256f:	41 56                	push   %r14
  802571:	41 55                	push   %r13
  802573:	41 54                	push   %r12
  802575:	53                   	push   %rbx
  802576:	48 83 ec 18          	sub    $0x18,%rsp
  80257a:	49 89 fc             	mov    %rdi,%r12
  80257d:	49 89 f5             	mov    %rsi,%r13
  802580:	49 89 d7             	mov    %rdx,%r15
  802583:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802587:	48 b8 1a 1a 80 00 00 	movabs $0x801a1a,%rax
  80258e:	00 00 00 
  802591:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  802593:	4d 85 ff             	test   %r15,%r15
  802596:	0f 84 af 00 00 00    	je     80264b <devpipe_write+0xe6>
  80259c:	48 89 c3             	mov    %rax,%rbx
  80259f:	4c 89 f8             	mov    %r15,%rax
  8025a2:	4d 89 ef             	mov    %r13,%r15
  8025a5:	4c 01 e8             	add    %r13,%rax
  8025a8:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8025ac:	49 bd b4 14 80 00 00 	movabs $0x8014b4,%r13
  8025b3:	00 00 00 
            sys_yield();
  8025b6:	49 be 49 14 80 00 00 	movabs $0x801449,%r14
  8025bd:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8025c0:	8b 73 04             	mov    0x4(%rbx),%esi
  8025c3:	48 63 ce             	movslq %esi,%rcx
  8025c6:	48 63 03             	movslq (%rbx),%rax
  8025c9:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8025cf:	48 39 c1             	cmp    %rax,%rcx
  8025d2:	72 2e                	jb     802602 <devpipe_write+0x9d>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8025d4:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8025d9:	48 89 da             	mov    %rbx,%rdx
  8025dc:	be 00 10 00 00       	mov    $0x1000,%esi
  8025e1:	4c 89 e7             	mov    %r12,%rdi
  8025e4:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8025e7:	85 c0                	test   %eax,%eax
  8025e9:	74 66                	je     802651 <devpipe_write+0xec>
            sys_yield();
  8025eb:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8025ee:	8b 73 04             	mov    0x4(%rbx),%esi
  8025f1:	48 63 ce             	movslq %esi,%rcx
  8025f4:	48 63 03             	movslq (%rbx),%rax
  8025f7:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8025fd:	48 39 c1             	cmp    %rax,%rcx
  802600:	73 d2                	jae    8025d4 <devpipe_write+0x6f>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802602:	41 0f b6 3f          	movzbl (%r15),%edi
  802606:	48 89 ca             	mov    %rcx,%rdx
  802609:	48 c1 ea 03          	shr    $0x3,%rdx
  80260d:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  802614:	08 10 20 
  802617:	48 f7 e2             	mul    %rdx
  80261a:	48 c1 ea 06          	shr    $0x6,%rdx
  80261e:	48 89 d0             	mov    %rdx,%rax
  802621:	48 c1 e0 09          	shl    $0x9,%rax
  802625:	48 29 d0             	sub    %rdx,%rax
  802628:	48 c1 e0 03          	shl    $0x3,%rax
  80262c:	48 29 c1             	sub    %rax,%rcx
  80262f:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  802634:	83 c6 01             	add    $0x1,%esi
  802637:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  80263a:	49 83 c7 01          	add    $0x1,%r15
  80263e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802642:	49 39 c7             	cmp    %rax,%r15
  802645:	0f 85 75 ff ff ff    	jne    8025c0 <devpipe_write+0x5b>
    return n;
  80264b:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80264f:	eb 05                	jmp    802656 <devpipe_write+0xf1>
            if (_pipeisclosed(fd, p)) return 0;
  802651:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802656:	48 83 c4 18          	add    $0x18,%rsp
  80265a:	5b                   	pop    %rbx
  80265b:	41 5c                	pop    %r12
  80265d:	41 5d                	pop    %r13
  80265f:	41 5e                	pop    %r14
  802661:	41 5f                	pop    %r15
  802663:	5d                   	pop    %rbp
  802664:	c3                   	ret

0000000000802665 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  802665:	f3 0f 1e fa          	endbr64
  802669:	55                   	push   %rbp
  80266a:	48 89 e5             	mov    %rsp,%rbp
  80266d:	41 57                	push   %r15
  80266f:	41 56                	push   %r14
  802671:	41 55                	push   %r13
  802673:	41 54                	push   %r12
  802675:	53                   	push   %rbx
  802676:	48 83 ec 18          	sub    $0x18,%rsp
  80267a:	49 89 fc             	mov    %rdi,%r12
  80267d:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  802681:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802685:	48 b8 1a 1a 80 00 00 	movabs $0x801a1a,%rax
  80268c:	00 00 00 
  80268f:	ff d0                	call   *%rax
  802691:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  802694:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80269a:	49 bd b4 14 80 00 00 	movabs $0x8014b4,%r13
  8026a1:	00 00 00 
            sys_yield();
  8026a4:	49 be 49 14 80 00 00 	movabs $0x801449,%r14
  8026ab:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  8026ae:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8026b3:	74 7d                	je     802732 <devpipe_read+0xcd>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8026b5:	8b 03                	mov    (%rbx),%eax
  8026b7:	3b 43 04             	cmp    0x4(%rbx),%eax
  8026ba:	75 26                	jne    8026e2 <devpipe_read+0x7d>
            if (i > 0) return i;
  8026bc:	4d 85 ff             	test   %r15,%r15
  8026bf:	75 77                	jne    802738 <devpipe_read+0xd3>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8026c1:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8026c6:	48 89 da             	mov    %rbx,%rdx
  8026c9:	be 00 10 00 00       	mov    $0x1000,%esi
  8026ce:	4c 89 e7             	mov    %r12,%rdi
  8026d1:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8026d4:	85 c0                	test   %eax,%eax
  8026d6:	74 72                	je     80274a <devpipe_read+0xe5>
            sys_yield();
  8026d8:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8026db:	8b 03                	mov    (%rbx),%eax
  8026dd:	3b 43 04             	cmp    0x4(%rbx),%eax
  8026e0:	74 df                	je     8026c1 <devpipe_read+0x5c>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8026e2:	48 63 c8             	movslq %eax,%rcx
  8026e5:	48 89 ca             	mov    %rcx,%rdx
  8026e8:	48 c1 ea 03          	shr    $0x3,%rdx
  8026ec:	48 be 81 00 01 02 04 	movabs $0x2010080402010081,%rsi
  8026f3:	08 10 20 
  8026f6:	48 89 d0             	mov    %rdx,%rax
  8026f9:	48 f7 e6             	mul    %rsi
  8026fc:	48 c1 ea 06          	shr    $0x6,%rdx
  802700:	48 89 d0             	mov    %rdx,%rax
  802703:	48 c1 e0 09          	shl    $0x9,%rax
  802707:	48 29 d0             	sub    %rdx,%rax
  80270a:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802711:	00 
  802712:	48 89 c8             	mov    %rcx,%rax
  802715:	48 29 d0             	sub    %rdx,%rax
  802718:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  80271d:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  802721:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  802725:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  802728:	49 83 c7 01          	add    $0x1,%r15
  80272c:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  802730:	75 83                	jne    8026b5 <devpipe_read+0x50>
    return n;
  802732:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802736:	eb 03                	jmp    80273b <devpipe_read+0xd6>
            if (i > 0) return i;
  802738:	4c 89 f8             	mov    %r15,%rax
}
  80273b:	48 83 c4 18          	add    $0x18,%rsp
  80273f:	5b                   	pop    %rbx
  802740:	41 5c                	pop    %r12
  802742:	41 5d                	pop    %r13
  802744:	41 5e                	pop    %r14
  802746:	41 5f                	pop    %r15
  802748:	5d                   	pop    %rbp
  802749:	c3                   	ret
            if (_pipeisclosed(fd, p)) return 0;
  80274a:	b8 00 00 00 00       	mov    $0x0,%eax
  80274f:	eb ea                	jmp    80273b <devpipe_read+0xd6>

0000000000802751 <pipe>:
pipe(int pfd[2]) {
  802751:	f3 0f 1e fa          	endbr64
  802755:	55                   	push   %rbp
  802756:	48 89 e5             	mov    %rsp,%rbp
  802759:	41 55                	push   %r13
  80275b:	41 54                	push   %r12
  80275d:	53                   	push   %rbx
  80275e:	48 83 ec 18          	sub    $0x18,%rsp
  802762:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  802765:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802769:	48 b8 3a 1a 80 00 00 	movabs $0x801a3a,%rax
  802770:	00 00 00 
  802773:	ff d0                	call   *%rax
  802775:	89 c3                	mov    %eax,%ebx
  802777:	85 c0                	test   %eax,%eax
  802779:	0f 88 a0 01 00 00    	js     80291f <pipe+0x1ce>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  80277f:	b9 46 00 00 00       	mov    $0x46,%ecx
  802784:	ba 00 10 00 00       	mov    $0x1000,%edx
  802789:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80278d:	bf 00 00 00 00       	mov    $0x0,%edi
  802792:	48 b8 e4 14 80 00 00 	movabs $0x8014e4,%rax
  802799:	00 00 00 
  80279c:	ff d0                	call   *%rax
  80279e:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  8027a0:	85 c0                	test   %eax,%eax
  8027a2:	0f 88 77 01 00 00    	js     80291f <pipe+0x1ce>
    if ((res = fd_alloc(&fd1)) < 0 ||
  8027a8:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  8027ac:	48 b8 3a 1a 80 00 00 	movabs $0x801a3a,%rax
  8027b3:	00 00 00 
  8027b6:	ff d0                	call   *%rax
  8027b8:	89 c3                	mov    %eax,%ebx
  8027ba:	85 c0                	test   %eax,%eax
  8027bc:	0f 88 43 01 00 00    	js     802905 <pipe+0x1b4>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  8027c2:	b9 46 00 00 00       	mov    $0x46,%ecx
  8027c7:	ba 00 10 00 00       	mov    $0x1000,%edx
  8027cc:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8027d0:	bf 00 00 00 00       	mov    $0x0,%edi
  8027d5:	48 b8 e4 14 80 00 00 	movabs $0x8014e4,%rax
  8027dc:	00 00 00 
  8027df:	ff d0                	call   *%rax
  8027e1:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  8027e3:	85 c0                	test   %eax,%eax
  8027e5:	0f 88 1a 01 00 00    	js     802905 <pipe+0x1b4>
    va = fd2data(fd0);
  8027eb:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8027ef:	48 b8 1a 1a 80 00 00 	movabs $0x801a1a,%rax
  8027f6:	00 00 00 
  8027f9:	ff d0                	call   *%rax
  8027fb:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  8027fe:	b9 46 00 00 00       	mov    $0x46,%ecx
  802803:	ba 00 10 00 00       	mov    $0x1000,%edx
  802808:	48 89 c6             	mov    %rax,%rsi
  80280b:	bf 00 00 00 00       	mov    $0x0,%edi
  802810:	48 b8 e4 14 80 00 00 	movabs $0x8014e4,%rax
  802817:	00 00 00 
  80281a:	ff d0                	call   *%rax
  80281c:	89 c3                	mov    %eax,%ebx
  80281e:	85 c0                	test   %eax,%eax
  802820:	0f 88 c5 00 00 00    	js     8028eb <pipe+0x19a>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  802826:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  80282a:	48 b8 1a 1a 80 00 00 	movabs $0x801a1a,%rax
  802831:	00 00 00 
  802834:	ff d0                	call   *%rax
  802836:	48 89 c1             	mov    %rax,%rcx
  802839:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  80283f:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  802845:	ba 00 00 00 00       	mov    $0x0,%edx
  80284a:	4c 89 ee             	mov    %r13,%rsi
  80284d:	bf 00 00 00 00       	mov    $0x0,%edi
  802852:	48 b8 4f 15 80 00 00 	movabs $0x80154f,%rax
  802859:	00 00 00 
  80285c:	ff d0                	call   *%rax
  80285e:	89 c3                	mov    %eax,%ebx
  802860:	85 c0                	test   %eax,%eax
  802862:	78 6e                	js     8028d2 <pipe+0x181>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802864:	be 00 10 00 00       	mov    $0x1000,%esi
  802869:	4c 89 ef             	mov    %r13,%rdi
  80286c:	48 b8 7e 14 80 00 00 	movabs $0x80147e,%rax
  802873:	00 00 00 
  802876:	ff d0                	call   *%rax
  802878:	83 f8 02             	cmp    $0x2,%eax
  80287b:	0f 85 ab 00 00 00    	jne    80292c <pipe+0x1db>
    fd0->fd_dev_id = devpipe.dev_id;
  802881:	a1 60 50 80 00 00 00 	movabs 0x805060,%eax
  802888:	00 00 
  80288a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80288e:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  802890:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802894:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  80289b:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80289f:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  8028a1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8028a5:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  8028ac:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8028b0:	48 bb 04 1a 80 00 00 	movabs $0x801a04,%rbx
  8028b7:	00 00 00 
  8028ba:	ff d3                	call   *%rbx
  8028bc:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  8028c0:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8028c4:	ff d3                	call   *%rbx
  8028c6:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  8028cb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8028d0:	eb 4d                	jmp    80291f <pipe+0x1ce>
    sys_unmap_region(0, va, PAGE_SIZE);
  8028d2:	ba 00 10 00 00       	mov    $0x1000,%edx
  8028d7:	4c 89 ee             	mov    %r13,%rsi
  8028da:	bf 00 00 00 00       	mov    $0x0,%edi
  8028df:	48 b8 24 16 80 00 00 	movabs $0x801624,%rax
  8028e6:	00 00 00 
  8028e9:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  8028eb:	ba 00 10 00 00       	mov    $0x1000,%edx
  8028f0:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8028f4:	bf 00 00 00 00       	mov    $0x0,%edi
  8028f9:	48 b8 24 16 80 00 00 	movabs $0x801624,%rax
  802900:	00 00 00 
  802903:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  802905:	ba 00 10 00 00       	mov    $0x1000,%edx
  80290a:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80290e:	bf 00 00 00 00       	mov    $0x0,%edi
  802913:	48 b8 24 16 80 00 00 	movabs $0x801624,%rax
  80291a:	00 00 00 
  80291d:	ff d0                	call   *%rax
}
  80291f:	89 d8                	mov    %ebx,%eax
  802921:	48 83 c4 18          	add    $0x18,%rsp
  802925:	5b                   	pop    %rbx
  802926:	41 5c                	pop    %r12
  802928:	41 5d                	pop    %r13
  80292a:	5d                   	pop    %rbp
  80292b:	c3                   	ret
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  80292c:	48 b9 e0 40 80 00 00 	movabs $0x8040e0,%rcx
  802933:	00 00 00 
  802936:	48 ba dc 43 80 00 00 	movabs $0x8043dc,%rdx
  80293d:	00 00 00 
  802940:	be 2e 00 00 00       	mov    $0x2e,%esi
  802945:	48 bf 03 44 80 00 00 	movabs $0x804403,%rdi
  80294c:	00 00 00 
  80294f:	b8 00 00 00 00       	mov    $0x0,%eax
  802954:	49 b8 3a 04 80 00 00 	movabs $0x80043a,%r8
  80295b:	00 00 00 
  80295e:	41 ff d0             	call   *%r8

0000000000802961 <pipeisclosed>:
pipeisclosed(int fdnum) {
  802961:	f3 0f 1e fa          	endbr64
  802965:	55                   	push   %rbp
  802966:	48 89 e5             	mov    %rsp,%rbp
  802969:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  80296d:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802971:	48 b8 9e 1a 80 00 00 	movabs $0x801a9e,%rax
  802978:	00 00 00 
  80297b:	ff d0                	call   *%rax
    if (res < 0) return res;
  80297d:	85 c0                	test   %eax,%eax
  80297f:	78 35                	js     8029b6 <pipeisclosed+0x55>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  802981:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802985:	48 b8 1a 1a 80 00 00 	movabs $0x801a1a,%rax
  80298c:	00 00 00 
  80298f:	ff d0                	call   *%rax
  802991:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802994:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802999:	be 00 10 00 00       	mov    $0x1000,%esi
  80299e:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8029a2:	48 b8 b4 14 80 00 00 	movabs $0x8014b4,%rax
  8029a9:	00 00 00 
  8029ac:	ff d0                	call   *%rax
  8029ae:	85 c0                	test   %eax,%eax
  8029b0:	0f 94 c0             	sete   %al
  8029b3:	0f b6 c0             	movzbl %al,%eax
}
  8029b6:	c9                   	leave
  8029b7:	c3                   	ret

00000000008029b8 <get_uvpt_entry>:
extern volatile pde_t uvpd[];     /* VA of current page directory */
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
  8029b8:	f3 0f 1e fa          	endbr64
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8029bc:	48 89 f8             	mov    %rdi,%rax
  8029bf:	48 c1 e8 27          	shr    $0x27,%rax
  8029c3:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  8029ca:	7f 00 00 
  8029cd:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8029d1:	f6 c2 01             	test   $0x1,%dl
  8029d4:	74 6d                	je     802a43 <get_uvpt_entry+0x8b>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8029d6:	48 89 f8             	mov    %rdi,%rax
  8029d9:	48 c1 e8 1e          	shr    $0x1e,%rax
  8029dd:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  8029e4:	7f 00 00 
  8029e7:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8029eb:	f6 c2 01             	test   $0x1,%dl
  8029ee:	74 62                	je     802a52 <get_uvpt_entry+0x9a>
  8029f0:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  8029f7:	7f 00 00 
  8029fa:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8029fe:	f6 c2 80             	test   $0x80,%dl
  802a01:	75 4f                	jne    802a52 <get_uvpt_entry+0x9a>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802a03:	48 89 f8             	mov    %rdi,%rax
  802a06:	48 c1 e8 15          	shr    $0x15,%rax
  802a0a:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802a11:	7f 00 00 
  802a14:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802a18:	f6 c2 01             	test   $0x1,%dl
  802a1b:	74 44                	je     802a61 <get_uvpt_entry+0xa9>
  802a1d:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802a24:	7f 00 00 
  802a27:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802a2b:	f6 c2 80             	test   $0x80,%dl
  802a2e:	75 31                	jne    802a61 <get_uvpt_entry+0xa9>
    return uvpt[VPT(va)];
  802a30:	48 c1 ef 0c          	shr    $0xc,%rdi
  802a34:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802a3b:	7f 00 00 
  802a3e:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  802a42:	c3                   	ret
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802a43:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  802a4a:	7f 00 00 
  802a4d:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802a51:	c3                   	ret
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  802a52:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  802a59:	7f 00 00 
  802a5c:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802a60:	c3                   	ret
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802a61:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802a68:	7f 00 00 
  802a6b:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802a6f:	c3                   	ret

0000000000802a70 <get_phys_addr>:

uintptr_t
get_phys_addr(void *va) {
  802a70:	f3 0f 1e fa          	endbr64
  802a74:	48 89 fa             	mov    %rdi,%rdx
    if (!(uvpml4[VPML4(va)] & PTE_P))
  802a77:	48 89 f9             	mov    %rdi,%rcx
  802a7a:	48 c1 e9 27          	shr    $0x27,%rcx
  802a7e:	48 b8 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rax
  802a85:	7f 00 00 
  802a88:	48 8b 0c c8          	mov    (%rax,%rcx,8),%rcx
        return -1;
  802a8c:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpml4[VPML4(va)] & PTE_P))
  802a93:	f6 c1 01             	test   $0x1,%cl
  802a96:	0f 84 b2 00 00 00    	je     802b4e <get_phys_addr+0xde>
    if (!(uvpdp[VPDP(va)] & PTE_P))
  802a9c:	48 89 f9             	mov    %rdi,%rcx
  802a9f:	48 c1 e9 1e          	shr    $0x1e,%rcx
  802aa3:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802aaa:	7f 00 00 
  802aad:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  802ab1:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpdp[VPDP(va)] & PTE_P))
  802ab8:	40 f6 c6 01          	test   $0x1,%sil
  802abc:	0f 84 8c 00 00 00    	je     802b4e <get_phys_addr+0xde>
    if (uvpdp[VPDP(va)] & PTE_PS)
  802ac2:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802ac9:	7f 00 00 
  802acc:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802ad0:	a8 80                	test   $0x80,%al
  802ad2:	75 7b                	jne    802b4f <get_phys_addr+0xdf>
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
    if (!(uvpd[VPD(va)] & PTE_P))
  802ad4:	48 89 f9             	mov    %rdi,%rcx
  802ad7:	48 c1 e9 15          	shr    $0x15,%rcx
  802adb:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  802ae2:	7f 00 00 
  802ae5:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  802ae9:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpd[VPD(va)] & PTE_P))
  802af0:	40 f6 c6 01          	test   $0x1,%sil
  802af4:	74 58                	je     802b4e <get_phys_addr+0xde>
    if ((uvpd[VPD(va)] & PTE_PS))
  802af6:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  802afd:	7f 00 00 
  802b00:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802b04:	a8 80                	test   $0x80,%al
  802b06:	75 6c                	jne    802b74 <get_phys_addr+0x104>
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
    if (!(uvpt[VPT(va)] & PTE_P))
  802b08:	48 89 f9             	mov    %rdi,%rcx
  802b0b:	48 c1 e9 0c          	shr    $0xc,%rcx
  802b0f:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802b16:	7f 00 00 
  802b19:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  802b1d:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpt[VPT(va)] & PTE_P))
  802b24:	40 f6 c6 01          	test   $0x1,%sil
  802b28:	74 24                	je     802b4e <get_phys_addr+0xde>
    return PTE_ADDR(uvpt[VPT(va)]) + PAGE_OFFSET(va);
  802b2a:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802b31:	7f 00 00 
  802b34:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802b38:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802b3f:	ff ff 7f 
  802b42:	48 21 c8             	and    %rcx,%rax
  802b45:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  802b4b:	48 09 d0             	or     %rdx,%rax
}
  802b4e:	c3                   	ret
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
  802b4f:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802b56:	7f 00 00 
  802b59:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802b5d:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802b64:	ff ff 7f 
  802b67:	48 21 c8             	and    %rcx,%rax
  802b6a:	81 e2 ff ff ff 3f    	and    $0x3fffffff,%edx
  802b70:	48 01 d0             	add    %rdx,%rax
  802b73:	c3                   	ret
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
  802b74:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  802b7b:	7f 00 00 
  802b7e:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802b82:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802b89:	ff ff 7f 
  802b8c:	48 21 c8             	and    %rcx,%rax
  802b8f:	81 e2 ff ff 1f 00    	and    $0x1fffff,%edx
  802b95:	48 01 d0             	add    %rdx,%rax
  802b98:	c3                   	ret

0000000000802b99 <get_prot>:

int
get_prot(void *va) {
  802b99:	f3 0f 1e fa          	endbr64
  802b9d:	55                   	push   %rbp
  802b9e:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802ba1:	48 b8 b8 29 80 00 00 	movabs $0x8029b8,%rax
  802ba8:	00 00 00 
  802bab:	ff d0                	call   *%rax
  802bad:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
    if (pte & PTE_P) prot |= PROT_R;
  802bb0:	83 e0 01             	and    $0x1,%eax
  802bb3:	c1 e0 02             	shl    $0x2,%eax
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  802bb6:	89 d1                	mov    %edx,%ecx
  802bb8:	81 e1 00 0a 00 00    	and    $0xa00,%ecx
    if (pte & PTE_P) prot |= PROT_R;
  802bbe:	09 c8                	or     %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  802bc0:	89 c1                	mov    %eax,%ecx
  802bc2:	83 c9 02             	or     $0x2,%ecx
  802bc5:	f6 c2 02             	test   $0x2,%dl
  802bc8:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  802bcb:	89 c1                	mov    %eax,%ecx
  802bcd:	83 c9 01             	or     $0x1,%ecx
  802bd0:	48 85 d2             	test   %rdx,%rdx
  802bd3:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  802bd6:	89 c1                	mov    %eax,%ecx
  802bd8:	83 c9 40             	or     $0x40,%ecx
  802bdb:	f6 c6 04             	test   $0x4,%dh
  802bde:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  802be1:	5d                   	pop    %rbp
  802be2:	c3                   	ret

0000000000802be3 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  802be3:	f3 0f 1e fa          	endbr64
  802be7:	55                   	push   %rbp
  802be8:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802beb:	48 b8 b8 29 80 00 00 	movabs $0x8029b8,%rax
  802bf2:	00 00 00 
  802bf5:	ff d0                	call   *%rax
    return pte & PTE_D;
  802bf7:	48 c1 e8 06          	shr    $0x6,%rax
  802bfb:	83 e0 01             	and    $0x1,%eax
}
  802bfe:	5d                   	pop    %rbp
  802bff:	c3                   	ret

0000000000802c00 <is_page_present>:

bool
is_page_present(void *va) {
  802c00:	f3 0f 1e fa          	endbr64
  802c04:	55                   	push   %rbp
  802c05:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  802c08:	48 b8 b8 29 80 00 00 	movabs $0x8029b8,%rax
  802c0f:	00 00 00 
  802c12:	ff d0                	call   *%rax
  802c14:	83 e0 01             	and    $0x1,%eax
}
  802c17:	5d                   	pop    %rbp
  802c18:	c3                   	ret

0000000000802c19 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  802c19:	f3 0f 1e fa          	endbr64
  802c1d:	55                   	push   %rbp
  802c1e:	48 89 e5             	mov    %rsp,%rbp
  802c21:	41 57                	push   %r15
  802c23:	41 56                	push   %r14
  802c25:	41 55                	push   %r13
  802c27:	41 54                	push   %r12
  802c29:	53                   	push   %rbx
  802c2a:	48 83 ec 18          	sub    $0x18,%rsp
  802c2e:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  802c32:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
     * NOTE: Skip over larger pages/page directories for efficiency */
    // LAB 11: Your code here:

    int res = 0;
    (void)fun, (void)arg;
    uintptr_t va = 0;
  802c36:	bb 00 00 00 00       	mov    $0x0,%ebx
    while (va < USER_STACK_TOP) {
        size_t size = 0;
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  802c3b:	49 be 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%r14
  802c42:	7f 00 00 
            size = 1LL << PML4_SHIFT;
            goto next;
        }

        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802c45:	49 bd 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%r13
  802c4c:	7f 00 00 
    while (va < USER_STACK_TOP) {
  802c4f:	49 bf ff 6f ff ff 7f 	movabs $0x7fffff6fff,%r15
  802c56:	00 00 00 
  802c59:	eb 73                	jmp    802cce <foreach_shared_region+0xb5>
            }

            goto next;
        }

        if (!(uvpd[VPD(va)] & PTE_P)) {
  802c5b:	48 89 d8             	mov    %rbx,%rax
  802c5e:	48 c1 e8 15          	shr    $0x15,%rax
  802c62:	48 b9 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rcx
  802c69:	7f 00 00 
  802c6c:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
            size = 1LL << PD_SHIFT;
  802c70:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
        if (!(uvpd[VPD(va)] & PTE_P)) {
  802c76:	f6 c2 01             	test   $0x1,%dl
  802c79:	74 4b                	je     802cc6 <foreach_shared_region+0xad>
            goto next;
        }

        if (uvpd[VPD(va)] & PTE_PS) {
  802c7b:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
  802c7f:	f6 c2 80             	test   $0x80,%dl
  802c82:	74 11                	je     802c95 <foreach_shared_region+0x7c>
            size = 1LL << PD_SHIFT;
            if (uvpd[VPD(va)] & PTE_SHARE) {
  802c84:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
  802c88:	f6 c4 04             	test   $0x4,%ah
  802c8b:	74 39                	je     802cc6 <foreach_shared_region+0xad>
            size = 1LL << PD_SHIFT;
  802c8d:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
  802c93:	eb 20                	jmp    802cb5 <foreach_shared_region+0x9c>

            goto next;
        }

        size = PAGE_SIZE;
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  802c95:	48 89 da             	mov    %rbx,%rdx
  802c98:	48 c1 ea 0c          	shr    $0xc,%rdx
  802c9c:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802ca3:	7f 00 00 
  802ca6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
        size = PAGE_SIZE;
  802caa:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  802cb0:	f6 c4 04             	test   $0x4,%ah
  802cb3:	74 11                	je     802cc6 <foreach_shared_region+0xad>
            goto next;
        }

    map:
        fun((void *)va, (void *)(va + size), arg);
  802cb5:	49 8d 34 1c          	lea    (%r12,%rbx,1),%rsi
  802cb9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802cbd:	48 89 df             	mov    %rbx,%rdi
  802cc0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802cc4:	ff d0                	call   *%rax
    next:
        va += size;
  802cc6:	4c 01 e3             	add    %r12,%rbx
    while (va < USER_STACK_TOP) {
  802cc9:	49 39 df             	cmp    %rbx,%r15
  802ccc:	72 3e                	jb     802d0c <foreach_shared_region+0xf3>
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  802cce:	49 8b 06             	mov    (%r14),%rax
  802cd1:	a8 01                	test   $0x1,%al
  802cd3:	74 37                	je     802d0c <foreach_shared_region+0xf3>
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802cd5:	48 89 d8             	mov    %rbx,%rax
  802cd8:	48 c1 e8 1e          	shr    $0x1e,%rax
  802cdc:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
            size = 1LL << PDP_SHIFT;
  802ce1:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802ce7:	f6 c2 01             	test   $0x1,%dl
  802cea:	74 da                	je     802cc6 <foreach_shared_region+0xad>
        if (uvpdp[VPDP(va)] & PTE_PS) {
  802cec:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
  802cf1:	f6 c2 80             	test   $0x80,%dl
  802cf4:	0f 84 61 ff ff ff    	je     802c5b <foreach_shared_region+0x42>
            if (uvpdp[VPDP(va)] & PTE_SHARE) {
  802cfa:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  802cff:	f6 c4 04             	test   $0x4,%ah
  802d02:	74 c2                	je     802cc6 <foreach_shared_region+0xad>
            size = 1LL << PDP_SHIFT;
  802d04:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
  802d0a:	eb a9                	jmp    802cb5 <foreach_shared_region+0x9c>
    }
    return res;
}
  802d0c:	b8 00 00 00 00       	mov    $0x0,%eax
  802d11:	48 83 c4 18          	add    $0x18,%rsp
  802d15:	5b                   	pop    %rbx
  802d16:	41 5c                	pop    %r12
  802d18:	41 5d                	pop    %r13
  802d1a:	41 5e                	pop    %r14
  802d1c:	41 5f                	pop    %r15
  802d1e:	5d                   	pop    %rbp
  802d1f:	c3                   	ret

0000000000802d20 <devcons_close>:

    return res;
}

static int
devcons_close(struct Fd *fd) {
  802d20:	f3 0f 1e fa          	endbr64
    USED(fd);

    return 0;
}
  802d24:	b8 00 00 00 00       	mov    $0x0,%eax
  802d29:	c3                   	ret

0000000000802d2a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  802d2a:	f3 0f 1e fa          	endbr64
  802d2e:	55                   	push   %rbp
  802d2f:	48 89 e5             	mov    %rsp,%rbp
  802d32:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  802d35:	48 be 0e 44 80 00 00 	movabs $0x80440e,%rsi
  802d3c:	00 00 00 
  802d3f:	48 b8 df 0e 80 00 00 	movabs $0x800edf,%rax
  802d46:	00 00 00 
  802d49:	ff d0                	call   *%rax
    return 0;
}
  802d4b:	b8 00 00 00 00       	mov    $0x0,%eax
  802d50:	5d                   	pop    %rbp
  802d51:	c3                   	ret

0000000000802d52 <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  802d52:	f3 0f 1e fa          	endbr64
  802d56:	55                   	push   %rbp
  802d57:	48 89 e5             	mov    %rsp,%rbp
  802d5a:	41 57                	push   %r15
  802d5c:	41 56                	push   %r14
  802d5e:	41 55                	push   %r13
  802d60:	41 54                	push   %r12
  802d62:	53                   	push   %rbx
  802d63:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  802d6a:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  802d71:	48 85 d2             	test   %rdx,%rdx
  802d74:	74 7a                	je     802df0 <devcons_write+0x9e>
  802d76:	49 89 d6             	mov    %rdx,%r14
  802d79:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802d7f:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  802d84:	49 bf fa 10 80 00 00 	movabs $0x8010fa,%r15
  802d8b:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  802d8e:	4c 89 f3             	mov    %r14,%rbx
  802d91:	48 29 f3             	sub    %rsi,%rbx
  802d94:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802d99:	48 39 c3             	cmp    %rax,%rbx
  802d9c:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  802da0:	4c 63 eb             	movslq %ebx,%r13
  802da3:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  802daa:	48 01 c6             	add    %rax,%rsi
  802dad:	4c 89 ea             	mov    %r13,%rdx
  802db0:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802db7:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  802dba:	4c 89 ee             	mov    %r13,%rsi
  802dbd:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802dc4:	48 b8 3f 13 80 00 00 	movabs $0x80133f,%rax
  802dcb:	00 00 00 
  802dce:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  802dd0:	41 01 dc             	add    %ebx,%r12d
  802dd3:	49 63 f4             	movslq %r12d,%rsi
  802dd6:	4c 39 f6             	cmp    %r14,%rsi
  802dd9:	72 b3                	jb     802d8e <devcons_write+0x3c>
    return res;
  802ddb:	49 63 c4             	movslq %r12d,%rax
}
  802dde:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  802de5:	5b                   	pop    %rbx
  802de6:	41 5c                	pop    %r12
  802de8:	41 5d                	pop    %r13
  802dea:	41 5e                	pop    %r14
  802dec:	41 5f                	pop    %r15
  802dee:	5d                   	pop    %rbp
  802def:	c3                   	ret
    for (res = 0; res < n; res += inc) {
  802df0:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802df6:	eb e3                	jmp    802ddb <devcons_write+0x89>

0000000000802df8 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802df8:	f3 0f 1e fa          	endbr64
  802dfc:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  802dff:	ba 00 00 00 00       	mov    $0x0,%edx
  802e04:	48 85 c0             	test   %rax,%rax
  802e07:	74 55                	je     802e5e <devcons_read+0x66>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802e09:	55                   	push   %rbp
  802e0a:	48 89 e5             	mov    %rsp,%rbp
  802e0d:	41 55                	push   %r13
  802e0f:	41 54                	push   %r12
  802e11:	53                   	push   %rbx
  802e12:	48 83 ec 08          	sub    $0x8,%rsp
  802e16:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  802e19:	48 bb 70 13 80 00 00 	movabs $0x801370,%rbx
  802e20:	00 00 00 
  802e23:	49 bc 49 14 80 00 00 	movabs $0x801449,%r12
  802e2a:	00 00 00 
  802e2d:	eb 03                	jmp    802e32 <devcons_read+0x3a>
  802e2f:	41 ff d4             	call   *%r12
  802e32:	ff d3                	call   *%rbx
  802e34:	85 c0                	test   %eax,%eax
  802e36:	74 f7                	je     802e2f <devcons_read+0x37>
    if (c < 0) return c;
  802e38:	48 63 d0             	movslq %eax,%rdx
  802e3b:	78 13                	js     802e50 <devcons_read+0x58>
    if (c == 0x04) return 0;
  802e3d:	ba 00 00 00 00       	mov    $0x0,%edx
  802e42:	83 f8 04             	cmp    $0x4,%eax
  802e45:	74 09                	je     802e50 <devcons_read+0x58>
    *(char *)vbuf = (char)c;
  802e47:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  802e4b:	ba 01 00 00 00       	mov    $0x1,%edx
}
  802e50:	48 89 d0             	mov    %rdx,%rax
  802e53:	48 83 c4 08          	add    $0x8,%rsp
  802e57:	5b                   	pop    %rbx
  802e58:	41 5c                	pop    %r12
  802e5a:	41 5d                	pop    %r13
  802e5c:	5d                   	pop    %rbp
  802e5d:	c3                   	ret
  802e5e:	48 89 d0             	mov    %rdx,%rax
  802e61:	c3                   	ret

0000000000802e62 <cputchar>:
cputchar(int ch) {
  802e62:	f3 0f 1e fa          	endbr64
  802e66:	55                   	push   %rbp
  802e67:	48 89 e5             	mov    %rsp,%rbp
  802e6a:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  802e6e:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  802e72:	be 01 00 00 00       	mov    $0x1,%esi
  802e77:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  802e7b:	48 b8 3f 13 80 00 00 	movabs $0x80133f,%rax
  802e82:	00 00 00 
  802e85:	ff d0                	call   *%rax
}
  802e87:	c9                   	leave
  802e88:	c3                   	ret

0000000000802e89 <getchar>:
getchar(void) {
  802e89:	f3 0f 1e fa          	endbr64
  802e8d:	55                   	push   %rbp
  802e8e:	48 89 e5             	mov    %rsp,%rbp
  802e91:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  802e95:	ba 01 00 00 00       	mov    $0x1,%edx
  802e9a:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  802e9e:	bf 00 00 00 00       	mov    $0x0,%edi
  802ea3:	48 b8 99 1d 80 00 00 	movabs $0x801d99,%rax
  802eaa:	00 00 00 
  802ead:	ff d0                	call   *%rax
  802eaf:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  802eb1:	85 c0                	test   %eax,%eax
  802eb3:	78 06                	js     802ebb <getchar+0x32>
  802eb5:	74 08                	je     802ebf <getchar+0x36>
  802eb7:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  802ebb:	89 d0                	mov    %edx,%eax
  802ebd:	c9                   	leave
  802ebe:	c3                   	ret
    return res < 0 ? res : res ? c :
  802ebf:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  802ec4:	eb f5                	jmp    802ebb <getchar+0x32>

0000000000802ec6 <iscons>:
iscons(int fdnum) {
  802ec6:	f3 0f 1e fa          	endbr64
  802eca:	55                   	push   %rbp
  802ecb:	48 89 e5             	mov    %rsp,%rbp
  802ece:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802ed2:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802ed6:	48 b8 9e 1a 80 00 00 	movabs $0x801a9e,%rax
  802edd:	00 00 00 
  802ee0:	ff d0                	call   *%rax
    if (res < 0) return res;
  802ee2:	85 c0                	test   %eax,%eax
  802ee4:	78 18                	js     802efe <iscons+0x38>
    return fd->fd_dev_id == devcons.dev_id;
  802ee6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802eea:	48 b8 a0 50 80 00 00 	movabs $0x8050a0,%rax
  802ef1:	00 00 00 
  802ef4:	8b 00                	mov    (%rax),%eax
  802ef6:	39 02                	cmp    %eax,(%rdx)
  802ef8:	0f 94 c0             	sete   %al
  802efb:	0f b6 c0             	movzbl %al,%eax
}
  802efe:	c9                   	leave
  802eff:	c3                   	ret

0000000000802f00 <opencons>:
opencons(void) {
  802f00:	f3 0f 1e fa          	endbr64
  802f04:	55                   	push   %rbp
  802f05:	48 89 e5             	mov    %rsp,%rbp
  802f08:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  802f0c:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  802f10:	48 b8 3a 1a 80 00 00 	movabs $0x801a3a,%rax
  802f17:	00 00 00 
  802f1a:	ff d0                	call   *%rax
  802f1c:	85 c0                	test   %eax,%eax
  802f1e:	78 49                	js     802f69 <opencons+0x69>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  802f20:	b9 46 00 00 00       	mov    $0x46,%ecx
  802f25:	ba 00 10 00 00       	mov    $0x1000,%edx
  802f2a:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  802f2e:	bf 00 00 00 00       	mov    $0x0,%edi
  802f33:	48 b8 e4 14 80 00 00 	movabs $0x8014e4,%rax
  802f3a:	00 00 00 
  802f3d:	ff d0                	call   *%rax
  802f3f:	85 c0                	test   %eax,%eax
  802f41:	78 26                	js     802f69 <opencons+0x69>
    fd->fd_dev_id = devcons.dev_id;
  802f43:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f47:	a1 a0 50 80 00 00 00 	movabs 0x8050a0,%eax
  802f4e:	00 00 
  802f50:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  802f52:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802f56:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  802f5d:	48 b8 04 1a 80 00 00 	movabs $0x801a04,%rax
  802f64:	00 00 00 
  802f67:	ff d0                	call   *%rax
}
  802f69:	c9                   	leave
  802f6a:	c3                   	ret

0000000000802f6b <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
    # Call the C page fault handler.
    movq  %rsp,%rdi # passing the function argument in rdi
  802f6b:	48 89 e7             	mov    %rsp,%rdi
    movabs $_handle_vectored_pagefault, %rax
  802f6e:	48 b8 aa 31 80 00 00 	movabs $0x8031aa,%rax
  802f75:	00 00 00 
    call *%rax
  802f78:	ff d0                	call   *%rax
    # registers are available for intermediate calculations.  You
    # may find that you have to rearrange your code in non-obvious
    # ways as registers become unavailable as scratch space.

    # LAB 9: Your code here
    movq %rsp, %rax
  802f7a:	48 89 e0             	mov    %rsp,%rax
    movq UTRAP_RIP(%rsp), %rbx
  802f7d:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  802f84:	00 
    movq UTRAP_RSP(%rsp), %rsp
  802f85:	48 8b a4 24 98 00 00 	mov    0x98(%rsp),%rsp
  802f8c:	00 
    pushq %rbx
  802f8d:	53                   	push   %rbx
    movq %rsp, UTRAP_RSP(%rax)
  802f8e:	48 89 a0 98 00 00 00 	mov    %rsp,0x98(%rax)

    # Restore the trap-time registers.  After you do this, you
    # can no longer modify any general-purpose registers (use POPA macro).
    # LAB 9: Your code here
    movq %rax, %rsp
  802f95:	48 89 c4             	mov    %rax,%rsp
    addq $16, %rsp
  802f98:	48 83 c4 10          	add    $0x10,%rsp
    POPA
  802f9c:	4c 8b 3c 24          	mov    (%rsp),%r15
  802fa0:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  802fa5:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  802faa:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  802faf:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  802fb4:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  802fb9:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  802fbe:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  802fc3:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  802fc8:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  802fcd:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  802fd2:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  802fd7:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  802fdc:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  802fe1:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  802fe6:	48 83 c4 78          	add    $0x78,%rsp
    addq $8, %rsp
  802fea:	48 83 c4 08          	add    $0x8,%rsp
    # Restore rflags from the stack.  After you do this, you can
    # no longer use arithmetic operations or anything else that
    # modifies rflags.
    # LAB 9: Your code here
	popfq
  802fee:	9d                   	popf
    # Switch back to the adjusted trap-time stack.
    # LAB 9: Your code here
	popq %rsp
  802fef:	5c                   	pop    %rsp
    # Return to re-execute the instruction that faulted.
    ret
  802ff0:	c3                   	ret

0000000000802ff1 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802ff1:	f3 0f 1e fa          	endbr64
  802ff5:	55                   	push   %rbp
  802ff6:	48 89 e5             	mov    %rsp,%rbp
  802ff9:	41 54                	push   %r12
  802ffb:	53                   	push   %rbx
  802ffc:	48 89 fb             	mov    %rdi,%rbx
  802fff:	48 89 f7             	mov    %rsi,%rdi
  803002:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  803005:	48 85 f6             	test   %rsi,%rsi
  803008:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  80300f:	00 00 00 
  803012:	48 0f 44 f8          	cmove  %rax,%rdi
    }
    int res = sys_ipc_recv(pg, PAGE_SIZE);
  803016:	be 00 10 00 00       	mov    $0x1000,%esi
  80301b:	48 b8 06 18 80 00 00 	movabs $0x801806,%rax
  803022:	00 00 00 
  803025:	ff d0                	call   *%rax
    if (res < 0) {
  803027:	85 c0                	test   %eax,%eax
  803029:	78 45                	js     803070 <ipc_recv+0x7f>
        if (perm_store != NULL) {
            *perm_store = 0;
        }
        return res;
    } else {
        if (from_env_store != NULL) {
  80302b:	48 85 db             	test   %rbx,%rbx
  80302e:	74 12                	je     803042 <ipc_recv+0x51>
            *from_env_store = thisenv->env_ipc_from;
  803030:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  803037:	00 00 00 
  80303a:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  803040:	89 03                	mov    %eax,(%rbx)
        }
        if (perm_store != NULL) {
  803042:	4d 85 e4             	test   %r12,%r12
  803045:	74 14                	je     80305b <ipc_recv+0x6a>
            *perm_store = thisenv->env_ipc_perm;
  803047:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  80304e:	00 00 00 
  803051:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  803057:	41 89 04 24          	mov    %eax,(%r12)
        }
        return thisenv->env_ipc_value;
  80305b:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  803062:	00 00 00 
  803065:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
    }
    return -1;
}
  80306b:	5b                   	pop    %rbx
  80306c:	41 5c                	pop    %r12
  80306e:	5d                   	pop    %rbp
  80306f:	c3                   	ret
        if (from_env_store != NULL) {
  803070:	48 85 db             	test   %rbx,%rbx
  803073:	74 06                	je     80307b <ipc_recv+0x8a>
            *from_env_store = 0;
  803075:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store != NULL) {
  80307b:	4d 85 e4             	test   %r12,%r12
  80307e:	74 eb                	je     80306b <ipc_recv+0x7a>
            *perm_store = 0;
  803080:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  803087:	00 
  803088:	eb e1                	jmp    80306b <ipc_recv+0x7a>

000000000080308a <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  80308a:	f3 0f 1e fa          	endbr64
  80308e:	55                   	push   %rbp
  80308f:	48 89 e5             	mov    %rsp,%rbp
  803092:	41 57                	push   %r15
  803094:	41 56                	push   %r14
  803096:	41 55                	push   %r13
  803098:	41 54                	push   %r12
  80309a:	53                   	push   %rbx
  80309b:	48 83 ec 18          	sub    $0x18,%rsp
  80309f:	89 7d c4             	mov    %edi,-0x3c(%rbp)
  8030a2:	48 89 d3             	mov    %rdx,%rbx
  8030a5:	49 89 cc             	mov    %rcx,%r12
  8030a8:	45 89 c5             	mov    %r8d,%r13d
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  8030ab:	48 85 d2             	test   %rdx,%rdx
  8030ae:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  8030b5:	00 00 00 
  8030b8:	48 0f 44 d8          	cmove  %rax,%rbx
    }
    int res = sys_ipc_try_send(to_env, val, pg, size, perm);
  8030bc:	89 f0                	mov    %esi,%eax
  8030be:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  8030c2:	48 89 da             	mov    %rbx,%rdx
  8030c5:	48 89 c6             	mov    %rax,%rsi
  8030c8:	48 b8 d6 17 80 00 00 	movabs $0x8017d6,%rax
  8030cf:	00 00 00 
  8030d2:	ff d0                	call   *%rax
    while (res < 0) {
  8030d4:	85 c0                	test   %eax,%eax
  8030d6:	79 65                	jns    80313d <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  8030d8:	83 f8 f5             	cmp    $0xfffffff5,%eax
  8030db:	75 33                	jne    803110 <ipc_send+0x86>
            panic("Error: %i\n", res);
        }
        sys_yield();
  8030dd:	49 bf 49 14 80 00 00 	movabs $0x801449,%r15
  8030e4:	00 00 00 
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  8030e7:	49 be d6 17 80 00 00 	movabs $0x8017d6,%r14
  8030ee:	00 00 00 
        sys_yield();
  8030f1:	41 ff d7             	call   *%r15
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  8030f4:	45 89 e8             	mov    %r13d,%r8d
  8030f7:	4c 89 e1             	mov    %r12,%rcx
  8030fa:	48 89 da             	mov    %rbx,%rdx
  8030fd:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  803101:	8b 7d c4             	mov    -0x3c(%rbp),%edi
  803104:	41 ff d6             	call   *%r14
    while (res < 0) {
  803107:	85 c0                	test   %eax,%eax
  803109:	79 32                	jns    80313d <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  80310b:	83 f8 f5             	cmp    $0xfffffff5,%eax
  80310e:	74 e1                	je     8030f1 <ipc_send+0x67>
            panic("Error: %i\n", res);
  803110:	89 c1                	mov    %eax,%ecx
  803112:	48 ba 1a 44 80 00 00 	movabs $0x80441a,%rdx
  803119:	00 00 00 
  80311c:	be 42 00 00 00       	mov    $0x42,%esi
  803121:	48 bf 25 44 80 00 00 	movabs $0x804425,%rdi
  803128:	00 00 00 
  80312b:	b8 00 00 00 00       	mov    $0x0,%eax
  803130:	49 b8 3a 04 80 00 00 	movabs $0x80043a,%r8
  803137:	00 00 00 
  80313a:	41 ff d0             	call   *%r8
    }
}
  80313d:	48 83 c4 18          	add    $0x18,%rsp
  803141:	5b                   	pop    %rbx
  803142:	41 5c                	pop    %r12
  803144:	41 5d                	pop    %r13
  803146:	41 5e                	pop    %r14
  803148:	41 5f                	pop    %r15
  80314a:	5d                   	pop    %rbp
  80314b:	c3                   	ret

000000000080314c <ipc_find_env>:

/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
  80314c:	f3 0f 1e fa          	endbr64
    for (size_t i = 0; i < NENV; i++)
  803150:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  803155:	48 b9 00 00 a0 1f 80 	movabs $0x801fa00000,%rcx
  80315c:	00 00 00 
  80315f:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  803163:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  803167:	48 c1 e2 04          	shl    $0x4,%rdx
  80316b:	48 01 ca             	add    %rcx,%rdx
  80316e:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  803174:	39 fa                	cmp    %edi,%edx
  803176:	74 12                	je     80318a <ipc_find_env+0x3e>
    for (size_t i = 0; i < NENV; i++)
  803178:	48 83 c0 01          	add    $0x1,%rax
  80317c:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  803182:	75 db                	jne    80315f <ipc_find_env+0x13>
            return envs[i].env_id;
    return 0;
  803184:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803189:	c3                   	ret
            return envs[i].env_id;
  80318a:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  80318e:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  803192:	48 c1 e2 04          	shl    $0x4,%rdx
  803196:	48 b8 00 00 a0 1f 80 	movabs $0x801fa00000,%rax
  80319d:	00 00 00 
  8031a0:	48 01 d0             	add    %rdx,%rax
  8031a3:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8031a9:	c3                   	ret

00000000008031aa <_handle_vectored_pagefault>:
/* Vector size */
static size_t _pfhandler_off = 0;
static bool _pfhandler_inititiallized = 0;

void
_handle_vectored_pagefault(struct UTrapframe *utf) {
  8031aa:	f3 0f 1e fa          	endbr64
  8031ae:	55                   	push   %rbp
  8031af:	48 89 e5             	mov    %rsp,%rbp
  8031b2:	41 56                	push   %r14
  8031b4:	41 55                	push   %r13
  8031b6:	41 54                	push   %r12
  8031b8:	53                   	push   %rbx
  8031b9:	49 89 fc             	mov    %rdi,%r12
    /* This trying to handle pagefault until
     * some handler returns 1, that indicates
     * successfully handled exception */
    for (size_t i = 0; i < _pfhandler_off; i++)
  8031bc:	48 b8 68 80 80 00 00 	movabs $0x808068,%rax
  8031c3:	00 00 00 
  8031c6:	48 83 38 00          	cmpq   $0x0,(%rax)
  8031ca:	74 27                	je     8031f3 <_handle_vectored_pagefault+0x49>
  8031cc:	bb 00 00 00 00       	mov    $0x0,%ebx
        if (_pfhandler_vec[i](utf)) return;
  8031d1:	49 bd 20 80 80 00 00 	movabs $0x808020,%r13
  8031d8:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++)
  8031db:	49 89 c6             	mov    %rax,%r14
        if (_pfhandler_vec[i](utf)) return;
  8031de:	4c 89 e7             	mov    %r12,%rdi
  8031e1:	41 ff 54 dd 00       	call   *0x0(%r13,%rbx,8)
  8031e6:	84 c0                	test   %al,%al
  8031e8:	75 45                	jne    80322f <_handle_vectored_pagefault+0x85>
    for (size_t i = 0; i < _pfhandler_off; i++)
  8031ea:	48 83 c3 01          	add    $0x1,%rbx
  8031ee:	49 3b 1e             	cmp    (%r14),%rbx
  8031f1:	72 eb                	jb     8031de <_handle_vectored_pagefault+0x34>

    /* Unhandled exceptions just cause panic */
    panic("Userspace page fault rip=%08lX va=%08lX err=%x\n",
  8031f3:	49 8b 8c 24 88 00 00 	mov    0x88(%r12),%rcx
  8031fa:	00 
  8031fb:	45 8b 4c 24 08       	mov    0x8(%r12),%r9d
  803200:	4d 8b 04 24          	mov    (%r12),%r8
  803204:	48 ba 08 41 80 00 00 	movabs $0x804108,%rdx
  80320b:	00 00 00 
  80320e:	be 1d 00 00 00       	mov    $0x1d,%esi
  803213:	48 bf 2f 44 80 00 00 	movabs $0x80442f,%rdi
  80321a:	00 00 00 
  80321d:	b8 00 00 00 00       	mov    $0x0,%eax
  803222:	49 ba 3a 04 80 00 00 	movabs $0x80043a,%r10
  803229:	00 00 00 
  80322c:	41 ff d2             	call   *%r10
          utf->utf_rip, utf->utf_fault_va, (int)utf->utf_err);
}
  80322f:	5b                   	pop    %rbx
  803230:	41 5c                	pop    %r12
  803232:	41 5d                	pop    %r13
  803234:	41 5e                	pop    %r14
  803236:	5d                   	pop    %rbp
  803237:	c3                   	ret

0000000000803238 <add_pgfault_handler>:
 * The first time we register a handler, we need to
 * allocate an exception stack (one page of memory with its top
 * at USER_EXCEPTION_STACK_TOP), and tell the kernel to call the assembly-language
 * _pgfault_upcall routine when a page fault occurs. */
int
add_pgfault_handler(pf_handler_t handler) {
  803238:	f3 0f 1e fa          	endbr64
  80323c:	55                   	push   %rbp
  80323d:	48 89 e5             	mov    %rsp,%rbp
  803240:	53                   	push   %rbx
  803241:	48 83 ec 08          	sub    $0x8,%rsp
  803245:	48 89 fb             	mov    %rdi,%rbx
    int res = 0;
    if (!_pfhandler_inititiallized) {
  803248:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  80324f:	00 00 00 
  803252:	80 38 00             	cmpb   $0x0,(%rax)
  803255:	0f 84 84 00 00 00    	je     8032df <add_pgfault_handler+0xa7>
        _pfhandler_vec[_pfhandler_off++] = handler;
        _pfhandler_inititiallized = 1;
        goto end;
    }

    for (size_t i = 0; i < _pfhandler_off; i++)
  80325b:	48 b8 68 80 80 00 00 	movabs $0x808068,%rax
  803262:	00 00 00 
  803265:	48 8b 10             	mov    (%rax),%rdx
  803268:	b8 00 00 00 00       	mov    $0x0,%eax
        if (handler == _pfhandler_vec[i]) return 0;
  80326d:	48 b9 20 80 80 00 00 	movabs $0x808020,%rcx
  803274:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++)
  803277:	48 85 d2             	test   %rdx,%rdx
  80327a:	74 19                	je     803295 <add_pgfault_handler+0x5d>
        if (handler == _pfhandler_vec[i]) return 0;
  80327c:	48 39 1c c1          	cmp    %rbx,(%rcx,%rax,8)
  803280:	0f 84 e8 00 00 00    	je     80336e <add_pgfault_handler+0x136>
    for (size_t i = 0; i < _pfhandler_off; i++)
  803286:	48 83 c0 01          	add    $0x1,%rax
  80328a:	48 39 d0             	cmp    %rdx,%rax
  80328d:	75 ed                	jne    80327c <add_pgfault_handler+0x44>

    if (_pfhandler_off == MAX_PFHANDLER)
  80328f:	48 83 fa 08          	cmp    $0x8,%rdx
  803293:	74 1c                	je     8032b1 <add_pgfault_handler+0x79>
        res = -E_INVAL;
    else
        _pfhandler_vec[_pfhandler_off++] = handler;
  803295:	48 8d 42 01          	lea    0x1(%rdx),%rax
  803299:	48 a3 68 80 80 00 00 	movabs %rax,0x808068
  8032a0:	00 00 00 
  8032a3:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8032aa:	00 00 00 
  8032ad:	48 89 1c d0          	mov    %rbx,(%rax,%rdx,8)

end:
    res = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  8032b1:	48 b8 14 14 80 00 00 	movabs $0x801414,%rax
  8032b8:	00 00 00 
  8032bb:	ff d0                	call   *%rax
  8032bd:	89 c7                	mov    %eax,%edi
  8032bf:	48 be 6b 2f 80 00 00 	movabs $0x802f6b,%rsi
  8032c6:	00 00 00 
  8032c9:	48 b8 69 17 80 00 00 	movabs $0x801769,%rax
  8032d0:	00 00 00 
  8032d3:	ff d0                	call   *%rax
    if (res < 0) panic("set_pgfault_handler: %i", res);
  8032d5:	85 c0                	test   %eax,%eax
  8032d7:	78 68                	js     803341 <add_pgfault_handler+0x109>
    return res;
}
  8032d9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8032dd:	c9                   	leave
  8032de:	c3                   	ret
        res = sys_alloc_region(sys_getenvid(), (void*)(USER_EXCEPTION_STACK_TOP - PAGE_SIZE), PAGE_SIZE, PROT_RW);
  8032df:	48 b8 14 14 80 00 00 	movabs $0x801414,%rax
  8032e6:	00 00 00 
  8032e9:	ff d0                	call   *%rax
  8032eb:	89 c7                	mov    %eax,%edi
  8032ed:	b9 06 00 00 00       	mov    $0x6,%ecx
  8032f2:	ba 00 10 00 00       	mov    $0x1000,%edx
  8032f7:	48 be 00 f0 ff ff 7f 	movabs $0x7ffffff000,%rsi
  8032fe:	00 00 00 
  803301:	48 b8 e4 14 80 00 00 	movabs $0x8014e4,%rax
  803308:	00 00 00 
  80330b:	ff d0                	call   *%rax
        _pfhandler_vec[_pfhandler_off++] = handler;
  80330d:	48 ba 68 80 80 00 00 	movabs $0x808068,%rdx
  803314:	00 00 00 
  803317:	48 8b 02             	mov    (%rdx),%rax
  80331a:	48 8d 48 01          	lea    0x1(%rax),%rcx
  80331e:	48 89 0a             	mov    %rcx,(%rdx)
  803321:	48 ba 20 80 80 00 00 	movabs $0x808020,%rdx
  803328:	00 00 00 
  80332b:	48 89 1c c2          	mov    %rbx,(%rdx,%rax,8)
        _pfhandler_inititiallized = 1;
  80332f:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  803336:	00 00 00 
  803339:	c6 00 01             	movb   $0x1,(%rax)
        goto end;
  80333c:	e9 70 ff ff ff       	jmp    8032b1 <add_pgfault_handler+0x79>
    if (res < 0) panic("set_pgfault_handler: %i", res);
  803341:	89 c1                	mov    %eax,%ecx
  803343:	48 ba 3d 44 80 00 00 	movabs $0x80443d,%rdx
  80334a:	00 00 00 
  80334d:	be 3d 00 00 00       	mov    $0x3d,%esi
  803352:	48 bf 2f 44 80 00 00 	movabs $0x80442f,%rdi
  803359:	00 00 00 
  80335c:	b8 00 00 00 00       	mov    $0x0,%eax
  803361:	49 b8 3a 04 80 00 00 	movabs $0x80043a,%r8
  803368:	00 00 00 
  80336b:	41 ff d0             	call   *%r8
        if (handler == _pfhandler_vec[i]) return 0;
  80336e:	b8 00 00 00 00       	mov    $0x0,%eax
  803373:	e9 61 ff ff ff       	jmp    8032d9 <add_pgfault_handler+0xa1>

0000000000803378 <remove_pgfault_handler>:

void
remove_pgfault_handler(pf_handler_t handler) {
  803378:	f3 0f 1e fa          	endbr64
  80337c:	55                   	push   %rbp
  80337d:	48 89 e5             	mov    %rsp,%rbp
    assert(_pfhandler_inititiallized);
  803380:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  803387:	00 00 00 
  80338a:	80 38 00             	cmpb   $0x0,(%rax)
  80338d:	74 33                	je     8033c2 <remove_pgfault_handler+0x4a>
    for (size_t i = 0; i < _pfhandler_off; i++) {
  80338f:	48 a1 68 80 80 00 00 	movabs 0x808068,%rax
  803396:	00 00 00 
  803399:	b9 00 00 00 00       	mov    $0x0,%ecx
        if (_pfhandler_vec[i] == handler) {
  80339e:	48 ba 20 80 80 00 00 	movabs $0x808020,%rdx
  8033a5:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++) {
  8033a8:	48 85 c0             	test   %rax,%rax
  8033ab:	0f 84 85 00 00 00    	je     803436 <remove_pgfault_handler+0xbe>
        if (_pfhandler_vec[i] == handler) {
  8033b1:	48 39 3c ca          	cmp    %rdi,(%rdx,%rcx,8)
  8033b5:	74 40                	je     8033f7 <remove_pgfault_handler+0x7f>
    for (size_t i = 0; i < _pfhandler_off; i++) {
  8033b7:	48 83 c1 01          	add    $0x1,%rcx
  8033bb:	48 39 c1             	cmp    %rax,%rcx
  8033be:	75 f1                	jne    8033b1 <remove_pgfault_handler+0x39>
  8033c0:	eb 74                	jmp    803436 <remove_pgfault_handler+0xbe>
    assert(_pfhandler_inititiallized);
  8033c2:	48 b9 55 44 80 00 00 	movabs $0x804455,%rcx
  8033c9:	00 00 00 
  8033cc:	48 ba dc 43 80 00 00 	movabs $0x8043dc,%rdx
  8033d3:	00 00 00 
  8033d6:	be 43 00 00 00       	mov    $0x43,%esi
  8033db:	48 bf 2f 44 80 00 00 	movabs $0x80442f,%rdi
  8033e2:	00 00 00 
  8033e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8033ea:	49 b8 3a 04 80 00 00 	movabs $0x80043a,%r8
  8033f1:	00 00 00 
  8033f4:	41 ff d0             	call   *%r8
            memmove(_pfhandler_vec + i, _pfhandler_vec + i + 1, (_pfhandler_off - i - 1) * sizeof(*handler));
  8033f7:	48 8d 34 cd 08 00 00 	lea    0x8(,%rcx,8),%rsi
  8033fe:	00 
  8033ff:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  803403:	48 29 ca             	sub    %rcx,%rdx
  803406:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  80340d:	00 00 00 
  803410:	48 8d 0c 06          	lea    (%rsi,%rax,1),%rcx
  803414:	48 8d 7c 30 f8       	lea    -0x8(%rax,%rsi,1),%rdi
  803419:	48 89 ce             	mov    %rcx,%rsi
  80341c:	48 b8 fa 10 80 00 00 	movabs $0x8010fa,%rax
  803423:	00 00 00 
  803426:	ff d0                	call   *%rax
            _pfhandler_off--;
  803428:	48 b8 68 80 80 00 00 	movabs $0x808068,%rax
  80342f:	00 00 00 
  803432:	48 83 28 01          	subq   $0x1,(%rax)
            return;
        }
    }
}
  803436:	5d                   	pop    %rbp
  803437:	c3                   	ret

0000000000803438 <__text_end>:
  803438:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80343f:	00 00 00 
  803442:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803449:	00 00 00 
  80344c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803453:	00 00 00 
  803456:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80345d:	00 00 00 
  803460:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803467:	00 00 00 
  80346a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803471:	00 00 00 
  803474:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80347b:	00 00 00 
  80347e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803485:	00 00 00 
  803488:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80348f:	00 00 00 
  803492:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803499:	00 00 00 
  80349c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034a3:	00 00 00 
  8034a6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034ad:	00 00 00 
  8034b0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034b7:	00 00 00 
  8034ba:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034c1:	00 00 00 
  8034c4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034cb:	00 00 00 
  8034ce:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034d5:	00 00 00 
  8034d8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034df:	00 00 00 
  8034e2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034e9:	00 00 00 
  8034ec:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034f3:	00 00 00 
  8034f6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034fd:	00 00 00 
  803500:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803507:	00 00 00 
  80350a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803511:	00 00 00 
  803514:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80351b:	00 00 00 
  80351e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803525:	00 00 00 
  803528:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80352f:	00 00 00 
  803532:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803539:	00 00 00 
  80353c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803543:	00 00 00 
  803546:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80354d:	00 00 00 
  803550:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803557:	00 00 00 
  80355a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803561:	00 00 00 
  803564:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80356b:	00 00 00 
  80356e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803575:	00 00 00 
  803578:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80357f:	00 00 00 
  803582:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803589:	00 00 00 
  80358c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803593:	00 00 00 
  803596:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80359d:	00 00 00 
  8035a0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035a7:	00 00 00 
  8035aa:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035b1:	00 00 00 
  8035b4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035bb:	00 00 00 
  8035be:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035c5:	00 00 00 
  8035c8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035cf:	00 00 00 
  8035d2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035d9:	00 00 00 
  8035dc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035e3:	00 00 00 
  8035e6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035ed:	00 00 00 
  8035f0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035f7:	00 00 00 
  8035fa:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803601:	00 00 00 
  803604:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80360b:	00 00 00 
  80360e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803615:	00 00 00 
  803618:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80361f:	00 00 00 
  803622:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803629:	00 00 00 
  80362c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803633:	00 00 00 
  803636:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80363d:	00 00 00 
  803640:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803647:	00 00 00 
  80364a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803651:	00 00 00 
  803654:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80365b:	00 00 00 
  80365e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803665:	00 00 00 
  803668:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80366f:	00 00 00 
  803672:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803679:	00 00 00 
  80367c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803683:	00 00 00 
  803686:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80368d:	00 00 00 
  803690:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803697:	00 00 00 
  80369a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036a1:	00 00 00 
  8036a4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036ab:	00 00 00 
  8036ae:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036b5:	00 00 00 
  8036b8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036bf:	00 00 00 
  8036c2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036c9:	00 00 00 
  8036cc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036d3:	00 00 00 
  8036d6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036dd:	00 00 00 
  8036e0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036e7:	00 00 00 
  8036ea:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036f1:	00 00 00 
  8036f4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036fb:	00 00 00 
  8036fe:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803705:	00 00 00 
  803708:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80370f:	00 00 00 
  803712:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803719:	00 00 00 
  80371c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803723:	00 00 00 
  803726:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80372d:	00 00 00 
  803730:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803737:	00 00 00 
  80373a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803741:	00 00 00 
  803744:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80374b:	00 00 00 
  80374e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803755:	00 00 00 
  803758:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80375f:	00 00 00 
  803762:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803769:	00 00 00 
  80376c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803773:	00 00 00 
  803776:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80377d:	00 00 00 
  803780:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803787:	00 00 00 
  80378a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803791:	00 00 00 
  803794:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80379b:	00 00 00 
  80379e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037a5:	00 00 00 
  8037a8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037af:	00 00 00 
  8037b2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037b9:	00 00 00 
  8037bc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037c3:	00 00 00 
  8037c6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037cd:	00 00 00 
  8037d0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037d7:	00 00 00 
  8037da:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037e1:	00 00 00 
  8037e4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037eb:	00 00 00 
  8037ee:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037f5:	00 00 00 
  8037f8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037ff:	00 00 00 
  803802:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803809:	00 00 00 
  80380c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803813:	00 00 00 
  803816:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80381d:	00 00 00 
  803820:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803827:	00 00 00 
  80382a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803831:	00 00 00 
  803834:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80383b:	00 00 00 
  80383e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803845:	00 00 00 
  803848:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80384f:	00 00 00 
  803852:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803859:	00 00 00 
  80385c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803863:	00 00 00 
  803866:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80386d:	00 00 00 
  803870:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803877:	00 00 00 
  80387a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803881:	00 00 00 
  803884:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80388b:	00 00 00 
  80388e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803895:	00 00 00 
  803898:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80389f:	00 00 00 
  8038a2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038a9:	00 00 00 
  8038ac:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038b3:	00 00 00 
  8038b6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038bd:	00 00 00 
  8038c0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038c7:	00 00 00 
  8038ca:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038d1:	00 00 00 
  8038d4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038db:	00 00 00 
  8038de:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038e5:	00 00 00 
  8038e8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038ef:	00 00 00 
  8038f2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038f9:	00 00 00 
  8038fc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803903:	00 00 00 
  803906:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80390d:	00 00 00 
  803910:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803917:	00 00 00 
  80391a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803921:	00 00 00 
  803924:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80392b:	00 00 00 
  80392e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803935:	00 00 00 
  803938:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80393f:	00 00 00 
  803942:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803949:	00 00 00 
  80394c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803953:	00 00 00 
  803956:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80395d:	00 00 00 
  803960:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803967:	00 00 00 
  80396a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803971:	00 00 00 
  803974:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80397b:	00 00 00 
  80397e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803985:	00 00 00 
  803988:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80398f:	00 00 00 
  803992:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803999:	00 00 00 
  80399c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039a3:	00 00 00 
  8039a6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039ad:	00 00 00 
  8039b0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039b7:	00 00 00 
  8039ba:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039c1:	00 00 00 
  8039c4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039cb:	00 00 00 
  8039ce:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039d5:	00 00 00 
  8039d8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039df:	00 00 00 
  8039e2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039e9:	00 00 00 
  8039ec:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039f3:	00 00 00 
  8039f6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039fd:	00 00 00 
  803a00:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a07:	00 00 00 
  803a0a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a11:	00 00 00 
  803a14:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a1b:	00 00 00 
  803a1e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a25:	00 00 00 
  803a28:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a2f:	00 00 00 
  803a32:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a39:	00 00 00 
  803a3c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a43:	00 00 00 
  803a46:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a4d:	00 00 00 
  803a50:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a57:	00 00 00 
  803a5a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a61:	00 00 00 
  803a64:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a6b:	00 00 00 
  803a6e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a75:	00 00 00 
  803a78:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a7f:	00 00 00 
  803a82:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a89:	00 00 00 
  803a8c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a93:	00 00 00 
  803a96:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a9d:	00 00 00 
  803aa0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803aa7:	00 00 00 
  803aaa:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ab1:	00 00 00 
  803ab4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803abb:	00 00 00 
  803abe:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ac5:	00 00 00 
  803ac8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803acf:	00 00 00 
  803ad2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ad9:	00 00 00 
  803adc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ae3:	00 00 00 
  803ae6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803aed:	00 00 00 
  803af0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803af7:	00 00 00 
  803afa:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b01:	00 00 00 
  803b04:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b0b:	00 00 00 
  803b0e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b15:	00 00 00 
  803b18:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b1f:	00 00 00 
  803b22:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b29:	00 00 00 
  803b2c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b33:	00 00 00 
  803b36:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b3d:	00 00 00 
  803b40:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b47:	00 00 00 
  803b4a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b51:	00 00 00 
  803b54:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b5b:	00 00 00 
  803b5e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b65:	00 00 00 
  803b68:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b6f:	00 00 00 
  803b72:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b79:	00 00 00 
  803b7c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b83:	00 00 00 
  803b86:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b8d:	00 00 00 
  803b90:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b97:	00 00 00 
  803b9a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ba1:	00 00 00 
  803ba4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bab:	00 00 00 
  803bae:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bb5:	00 00 00 
  803bb8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bbf:	00 00 00 
  803bc2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bc9:	00 00 00 
  803bcc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bd3:	00 00 00 
  803bd6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bdd:	00 00 00 
  803be0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803be7:	00 00 00 
  803bea:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bf1:	00 00 00 
  803bf4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bfb:	00 00 00 
  803bfe:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c05:	00 00 00 
  803c08:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c0f:	00 00 00 
  803c12:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c19:	00 00 00 
  803c1c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c23:	00 00 00 
  803c26:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c2d:	00 00 00 
  803c30:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c37:	00 00 00 
  803c3a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c41:	00 00 00 
  803c44:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c4b:	00 00 00 
  803c4e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c55:	00 00 00 
  803c58:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c5f:	00 00 00 
  803c62:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c69:	00 00 00 
  803c6c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c73:	00 00 00 
  803c76:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c7d:	00 00 00 
  803c80:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c87:	00 00 00 
  803c8a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c91:	00 00 00 
  803c94:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c9b:	00 00 00 
  803c9e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ca5:	00 00 00 
  803ca8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803caf:	00 00 00 
  803cb2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cb9:	00 00 00 
  803cbc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cc3:	00 00 00 
  803cc6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ccd:	00 00 00 
  803cd0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cd7:	00 00 00 
  803cda:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ce1:	00 00 00 
  803ce4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ceb:	00 00 00 
  803cee:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cf5:	00 00 00 
  803cf8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cff:	00 00 00 
  803d02:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d09:	00 00 00 
  803d0c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d13:	00 00 00 
  803d16:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d1d:	00 00 00 
  803d20:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d27:	00 00 00 
  803d2a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d31:	00 00 00 
  803d34:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d3b:	00 00 00 
  803d3e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d45:	00 00 00 
  803d48:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d4f:	00 00 00 
  803d52:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d59:	00 00 00 
  803d5c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d63:	00 00 00 
  803d66:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d6d:	00 00 00 
  803d70:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d77:	00 00 00 
  803d7a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d81:	00 00 00 
  803d84:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d8b:	00 00 00 
  803d8e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d95:	00 00 00 
  803d98:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d9f:	00 00 00 
  803da2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803da9:	00 00 00 
  803dac:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803db3:	00 00 00 
  803db6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dbd:	00 00 00 
  803dc0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dc7:	00 00 00 
  803dca:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dd1:	00 00 00 
  803dd4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ddb:	00 00 00 
  803dde:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803de5:	00 00 00 
  803de8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803def:	00 00 00 
  803df2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803df9:	00 00 00 
  803dfc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e03:	00 00 00 
  803e06:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e0d:	00 00 00 
  803e10:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e17:	00 00 00 
  803e1a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e21:	00 00 00 
  803e24:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e2b:	00 00 00 
  803e2e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e35:	00 00 00 
  803e38:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e3f:	00 00 00 
  803e42:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e49:	00 00 00 
  803e4c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e53:	00 00 00 
  803e56:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e5d:	00 00 00 
  803e60:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e67:	00 00 00 
  803e6a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e71:	00 00 00 
  803e74:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e7b:	00 00 00 
  803e7e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e85:	00 00 00 
  803e88:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e8f:	00 00 00 
  803e92:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e99:	00 00 00 
  803e9c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ea3:	00 00 00 
  803ea6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ead:	00 00 00 
  803eb0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803eb7:	00 00 00 
  803eba:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ec1:	00 00 00 
  803ec4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ecb:	00 00 00 
  803ece:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ed5:	00 00 00 
  803ed8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803edf:	00 00 00 
  803ee2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ee9:	00 00 00 
  803eec:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ef3:	00 00 00 
  803ef6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803efd:	00 00 00 
  803f00:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f07:	00 00 00 
  803f0a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f11:	00 00 00 
  803f14:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f1b:	00 00 00 
  803f1e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f25:	00 00 00 
  803f28:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f2f:	00 00 00 
  803f32:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f39:	00 00 00 
  803f3c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f43:	00 00 00 
  803f46:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f4d:	00 00 00 
  803f50:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f57:	00 00 00 
  803f5a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f61:	00 00 00 
  803f64:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f6b:	00 00 00 
  803f6e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f75:	00 00 00 
  803f78:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f7f:	00 00 00 
  803f82:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f89:	00 00 00 
  803f8c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f93:	00 00 00 
  803f96:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f9d:	00 00 00 
  803fa0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fa7:	00 00 00 
  803faa:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fb1:	00 00 00 
  803fb4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fbb:	00 00 00 
  803fbe:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fc5:	00 00 00 
  803fc8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fcf:	00 00 00 
  803fd2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fd9:	00 00 00 
  803fdc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fe3:	00 00 00 
  803fe6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fed:	00 00 00 
  803ff0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ff7:	00 00 00 
  803ffa:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
