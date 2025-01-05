
obj/user/testpipe:     file format elf64-x86-64


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
  80001e:	e8 89 04 00 00       	call   8004ac <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <umain>:
#include <inc/lib.h>

char *msg = "Now is the time for all good men to come to the aid of their party.";

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
  800036:	48 83 ec 78          	sub    $0x78,%rsp
    char buf[100];
    int i, pid, p[2];

    binaryname = "pipereadeof";
  80003a:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  800041:	00 00 00 
  800044:	48 a3 08 50 80 00 00 	movabs %rax,0x805008
  80004b:	00 00 00 

    if ((i = pipe(p)) < 0)
  80004e:	48 8d bd 64 ff ff ff 	lea    -0x9c(%rbp),%rdi
  800055:	48 b8 9c 28 80 00 00 	movabs $0x80289c,%rax
  80005c:	00 00 00 
  80005f:	ff d0                	call   *%rax
  800061:	41 89 c4             	mov    %eax,%r12d
  800064:	85 c0                	test   %eax,%eax
  800066:	0f 88 b3 01 00 00    	js     80021f <umain+0x1fa>
        panic("pipe: %i", i);

    if ((pid = fork()) < 0)
  80006c:	48 b8 f3 19 80 00 00 	movabs $0x8019f3,%rax
  800073:	00 00 00 
  800076:	ff d0                	call   *%rax
  800078:	89 c3                	mov    %eax,%ebx
  80007a:	85 c0                	test   %eax,%eax
  80007c:	0f 88 ca 01 00 00    	js     80024c <umain+0x227>
        panic("fork: %i", i);

    if (pid == 0) {
  800082:	0f 85 49 02 00 00    	jne    8002d1 <umain+0x2ac>
        cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[1]);
  800088:	49 bd 00 60 80 00 00 	movabs $0x806000,%r13
  80008f:	00 00 00 
  800092:	49 8b 45 00          	mov    0x0(%r13),%rax
  800096:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  80009c:	8b 95 68 ff ff ff    	mov    -0x98(%rbp),%edx
  8000a2:	48 bf 2e 40 80 00 00 	movabs $0x80402e,%rdi
  8000a9:	00 00 00 
  8000ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b1:	49 bc e1 06 80 00 00 	movabs $0x8006e1,%r12
  8000b8:	00 00 00 
  8000bb:	41 ff d4             	call   *%r12
        close(p[1]);
  8000be:	8b bd 68 ff ff ff    	mov    -0x98(%rbp),%edi
  8000c4:	48 b8 5a 1d 80 00 00 	movabs $0x801d5a,%rax
  8000cb:	00 00 00 
  8000ce:	ff d0                	call   *%rax
        cprintf("[%08x] pipereadeof readn %d\n", thisenv->env_id, p[0]);
  8000d0:	49 8b 45 00          	mov    0x0(%r13),%rax
  8000d4:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  8000da:	8b 95 64 ff ff ff    	mov    -0x9c(%rbp),%edx
  8000e0:	48 bf 4b 40 80 00 00 	movabs $0x80404b,%rdi
  8000e7:	00 00 00 
  8000ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ef:	41 ff d4             	call   *%r12
        i = readn(p[0], buf, sizeof buf - 1);
  8000f2:	ba 63 00 00 00       	mov    $0x63,%edx
  8000f7:	48 8d b5 6c ff ff ff 	lea    -0x94(%rbp),%rsi
  8000fe:	8b bd 64 ff ff ff    	mov    -0x9c(%rbp),%edi
  800104:	48 b8 a6 1f 80 00 00 	movabs $0x801fa6,%rax
  80010b:	00 00 00 
  80010e:	ff d0                	call   *%rax
  800110:	41 89 c4             	mov    %eax,%r12d
        if (i < 0)
  800113:	85 c0                	test   %eax,%eax
  800115:	0f 88 5f 01 00 00    	js     80027a <umain+0x255>
            panic("read: %i", i);
        buf[i] = 0;
  80011b:	48 98                	cltq
  80011d:	c6 84 05 6c ff ff ff 	movb   $0x0,-0x94(%rbp,%rax,1)
  800124:	00 
        if (strcmp(buf, msg) == 0)
  800125:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  80012c:	00 00 00 
  80012f:	48 8b 30             	mov    (%rax),%rsi
  800132:	48 8d bd 6c ff ff ff 	lea    -0x94(%rbp),%rdi
  800139:	48 b8 de 10 80 00 00 	movabs $0x8010de,%rax
  800140:	00 00 00 
  800143:	ff d0                	call   *%rax
  800145:	85 c0                	test   %eax,%eax
  800147:	0f 85 5a 01 00 00    	jne    8002a7 <umain+0x282>
            cprintf("\npipe read closed properly\n");
  80014d:	48 bf 71 40 80 00 00 	movabs $0x804071,%rdi
  800154:	00 00 00 
  800157:	48 ba e1 06 80 00 00 	movabs $0x8006e1,%rdx
  80015e:	00 00 00 
  800161:	ff d2                	call   *%rdx
        else
            cprintf("\ngot %d bytes: %s\n", i, buf);
        exit();
  800163:	48 b8 5e 05 80 00 00 	movabs $0x80055e,%rax
  80016a:	00 00 00 
  80016d:	ff d0                	call   *%rax
        cprintf("[%08x] pipereadeof write %d\n", thisenv->env_id, p[1]);
        if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
            panic("write: %i", i);
        close(p[1]);
    }
    wait(pid);
  80016f:	89 df                	mov    %ebx,%edi
  800171:	48 b8 03 2b 80 00 00 	movabs $0x802b03,%rax
  800178:	00 00 00 
  80017b:	ff d0                	call   *%rax

    binaryname = "pipewriteeof";
  80017d:	48 b8 c7 40 80 00 00 	movabs $0x8040c7,%rax
  800184:	00 00 00 
  800187:	48 a3 08 50 80 00 00 	movabs %rax,0x805008
  80018e:	00 00 00 
    if ((i = pipe(p)) < 0)
  800191:	48 8d bd 64 ff ff ff 	lea    -0x9c(%rbp),%rdi
  800198:	48 b8 9c 28 80 00 00 	movabs $0x80289c,%rax
  80019f:	00 00 00 
  8001a2:	ff d0                	call   *%rax
  8001a4:	41 89 c4             	mov    %eax,%r12d
  8001a7:	85 c0                	test   %eax,%eax
  8001a9:	0f 88 1a 02 00 00    	js     8003c9 <umain+0x3a4>
        panic("pipe: %i", i);

    if ((pid = fork()) < 0)
  8001af:	48 b8 f3 19 80 00 00 	movabs $0x8019f3,%rax
  8001b6:	00 00 00 
  8001b9:	ff d0                	call   *%rax
  8001bb:	89 c3                	mov    %eax,%ebx
  8001bd:	85 c0                	test   %eax,%eax
  8001bf:	0f 88 31 02 00 00    	js     8003f6 <umain+0x3d1>
        panic("fork: %i", i);

    if (pid == 0) {
  8001c5:	0f 84 59 02 00 00    	je     800424 <umain+0x3ff>
                break;
        }
        cprintf("\npipe write closed properly\n");
        exit();
    }
    close(p[0]);
  8001cb:	8b bd 64 ff ff ff    	mov    -0x9c(%rbp),%edi
  8001d1:	49 bc 5a 1d 80 00 00 	movabs $0x801d5a,%r12
  8001d8:	00 00 00 
  8001db:	41 ff d4             	call   *%r12
    close(p[1]);
  8001de:	8b bd 68 ff ff ff    	mov    -0x98(%rbp),%edi
  8001e4:	41 ff d4             	call   *%r12
    wait(pid);
  8001e7:	89 df                	mov    %ebx,%edi
  8001e9:	48 b8 03 2b 80 00 00 	movabs $0x802b03,%rax
  8001f0:	00 00 00 
  8001f3:	ff d0                	call   *%rax

    cprintf("pipe tests passed\n");
  8001f5:	48 bf f5 40 80 00 00 	movabs $0x8040f5,%rdi
  8001fc:	00 00 00 
  8001ff:	b8 00 00 00 00       	mov    $0x0,%eax
  800204:	48 ba e1 06 80 00 00 	movabs $0x8006e1,%rdx
  80020b:	00 00 00 
  80020e:	ff d2                	call   *%rdx
}
  800210:	48 83 c4 78          	add    $0x78,%rsp
  800214:	5b                   	pop    %rbx
  800215:	41 5c                	pop    %r12
  800217:	41 5d                	pop    %r13
  800219:	41 5e                	pop    %r14
  80021b:	41 5f                	pop    %r15
  80021d:	5d                   	pop    %rbp
  80021e:	c3                   	ret
        panic("pipe: %i", i);
  80021f:	89 c1                	mov    %eax,%ecx
  800221:	48 ba 0c 40 80 00 00 	movabs $0x80400c,%rdx
  800228:	00 00 00 
  80022b:	be 0d 00 00 00       	mov    $0xd,%esi
  800230:	48 bf 15 40 80 00 00 	movabs $0x804015,%rdi
  800237:	00 00 00 
  80023a:	b8 00 00 00 00       	mov    $0x0,%eax
  80023f:	49 b8 85 05 80 00 00 	movabs $0x800585,%r8
  800246:	00 00 00 
  800249:	41 ff d0             	call   *%r8
        panic("fork: %i", i);
  80024c:	44 89 e1             	mov    %r12d,%ecx
  80024f:	48 ba 25 40 80 00 00 	movabs $0x804025,%rdx
  800256:	00 00 00 
  800259:	be 10 00 00 00       	mov    $0x10,%esi
  80025e:	48 bf 15 40 80 00 00 	movabs $0x804015,%rdi
  800265:	00 00 00 
  800268:	b8 00 00 00 00       	mov    $0x0,%eax
  80026d:	49 b8 85 05 80 00 00 	movabs $0x800585,%r8
  800274:	00 00 00 
  800277:	41 ff d0             	call   *%r8
            panic("read: %i", i);
  80027a:	89 c1                	mov    %eax,%ecx
  80027c:	48 ba 68 40 80 00 00 	movabs $0x804068,%rdx
  800283:	00 00 00 
  800286:	be 18 00 00 00       	mov    $0x18,%esi
  80028b:	48 bf 15 40 80 00 00 	movabs $0x804015,%rdi
  800292:	00 00 00 
  800295:	b8 00 00 00 00       	mov    $0x0,%eax
  80029a:	49 b8 85 05 80 00 00 	movabs $0x800585,%r8
  8002a1:	00 00 00 
  8002a4:	41 ff d0             	call   *%r8
            cprintf("\ngot %d bytes: %s\n", i, buf);
  8002a7:	48 8d 95 6c ff ff ff 	lea    -0x94(%rbp),%rdx
  8002ae:	44 89 e6             	mov    %r12d,%esi
  8002b1:	48 bf 8d 40 80 00 00 	movabs $0x80408d,%rdi
  8002b8:	00 00 00 
  8002bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8002c0:	48 b9 e1 06 80 00 00 	movabs $0x8006e1,%rcx
  8002c7:	00 00 00 
  8002ca:	ff d1                	call   *%rcx
  8002cc:	e9 92 fe ff ff       	jmp    800163 <umain+0x13e>
        cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[0]);
  8002d1:	49 bd 00 60 80 00 00 	movabs $0x806000,%r13
  8002d8:	00 00 00 
  8002db:	49 8b 45 00          	mov    0x0(%r13),%rax
  8002df:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  8002e5:	8b 95 64 ff ff ff    	mov    -0x9c(%rbp),%edx
  8002eb:	48 bf 2e 40 80 00 00 	movabs $0x80402e,%rdi
  8002f2:	00 00 00 
  8002f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8002fa:	49 bc e1 06 80 00 00 	movabs $0x8006e1,%r12
  800301:	00 00 00 
  800304:	41 ff d4             	call   *%r12
        close(p[0]);
  800307:	8b bd 64 ff ff ff    	mov    -0x9c(%rbp),%edi
  80030d:	48 b8 5a 1d 80 00 00 	movabs $0x801d5a,%rax
  800314:	00 00 00 
  800317:	ff d0                	call   *%rax
        cprintf("[%08x] pipereadeof write %d\n", thisenv->env_id, p[1]);
  800319:	49 8b 45 00          	mov    0x0(%r13),%rax
  80031d:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800323:	8b 95 68 ff ff ff    	mov    -0x98(%rbp),%edx
  800329:	48 bf a0 40 80 00 00 	movabs $0x8040a0,%rdi
  800330:	00 00 00 
  800333:	b8 00 00 00 00       	mov    $0x0,%eax
  800338:	41 ff d4             	call   *%r12
        if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
  80033b:	49 bd 00 50 80 00 00 	movabs $0x805000,%r13
  800342:	00 00 00 
  800345:	49 8b 7d 00          	mov    0x0(%r13),%rdi
  800349:	49 bf e5 0f 80 00 00 	movabs $0x800fe5,%r15
  800350:	00 00 00 
  800353:	41 ff d7             	call   *%r15
  800356:	48 89 c2             	mov    %rax,%rdx
  800359:	49 8b 75 00          	mov    0x0(%r13),%rsi
  80035d:	8b bd 68 ff ff ff    	mov    -0x98(%rbp),%edi
  800363:	48 b8 1b 20 80 00 00 	movabs $0x80201b,%rax
  80036a:	00 00 00 
  80036d:	ff d0                	call   *%rax
  80036f:	49 89 c4             	mov    %rax,%r12
  800372:	41 89 c6             	mov    %eax,%r14d
  800375:	49 8b 7d 00          	mov    0x0(%r13),%rdi
  800379:	41 ff d7             	call   *%r15
  80037c:	4d 63 e4             	movslq %r12d,%r12
  80037f:	49 39 c4             	cmp    %rax,%r12
  800382:	75 17                	jne    80039b <umain+0x376>
        close(p[1]);
  800384:	8b bd 68 ff ff ff    	mov    -0x98(%rbp),%edi
  80038a:	48 b8 5a 1d 80 00 00 	movabs $0x801d5a,%rax
  800391:	00 00 00 
  800394:	ff d0                	call   *%rax
  800396:	e9 d4 fd ff ff       	jmp    80016f <umain+0x14a>
            panic("write: %i", i);
  80039b:	44 89 f1             	mov    %r14d,%ecx
  80039e:	48 ba bd 40 80 00 00 	movabs $0x8040bd,%rdx
  8003a5:	00 00 00 
  8003a8:	be 24 00 00 00       	mov    $0x24,%esi
  8003ad:	48 bf 15 40 80 00 00 	movabs $0x804015,%rdi
  8003b4:	00 00 00 
  8003b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8003bc:	49 b8 85 05 80 00 00 	movabs $0x800585,%r8
  8003c3:	00 00 00 
  8003c6:	41 ff d0             	call   *%r8
        panic("pipe: %i", i);
  8003c9:	89 c1                	mov    %eax,%ecx
  8003cb:	48 ba 0c 40 80 00 00 	movabs $0x80400c,%rdx
  8003d2:	00 00 00 
  8003d5:	be 2b 00 00 00       	mov    $0x2b,%esi
  8003da:	48 bf 15 40 80 00 00 	movabs $0x804015,%rdi
  8003e1:	00 00 00 
  8003e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8003e9:	49 b8 85 05 80 00 00 	movabs $0x800585,%r8
  8003f0:	00 00 00 
  8003f3:	41 ff d0             	call   *%r8
        panic("fork: %i", i);
  8003f6:	44 89 e1             	mov    %r12d,%ecx
  8003f9:	48 ba 25 40 80 00 00 	movabs $0x804025,%rdx
  800400:	00 00 00 
  800403:	be 2e 00 00 00       	mov    $0x2e,%esi
  800408:	48 bf 15 40 80 00 00 	movabs $0x804015,%rdi
  80040f:	00 00 00 
  800412:	b8 00 00 00 00       	mov    $0x0,%eax
  800417:	49 b8 85 05 80 00 00 	movabs $0x800585,%r8
  80041e:	00 00 00 
  800421:	41 ff d0             	call   *%r8
        close(p[0]);
  800424:	8b bd 64 ff ff ff    	mov    -0x9c(%rbp),%edi
  80042a:	48 b8 5a 1d 80 00 00 	movabs $0x801d5a,%rax
  800431:	00 00 00 
  800434:	ff d0                	call   *%rax
            cprintf(".");
  800436:	49 bf d4 40 80 00 00 	movabs $0x8040d4,%r15
  80043d:	00 00 00 
  800440:	49 be e1 06 80 00 00 	movabs $0x8006e1,%r14
  800447:	00 00 00 
            if (write(p[1], "x", 1) != 1)
  80044a:	49 bd d6 40 80 00 00 	movabs $0x8040d6,%r13
  800451:	00 00 00 
  800454:	49 bc 1b 20 80 00 00 	movabs $0x80201b,%r12
  80045b:	00 00 00 
            cprintf(".");
  80045e:	4c 89 ff             	mov    %r15,%rdi
  800461:	b8 00 00 00 00       	mov    $0x0,%eax
  800466:	41 ff d6             	call   *%r14
            if (write(p[1], "x", 1) != 1)
  800469:	ba 01 00 00 00       	mov    $0x1,%edx
  80046e:	4c 89 ee             	mov    %r13,%rsi
  800471:	8b bd 68 ff ff ff    	mov    -0x98(%rbp),%edi
  800477:	41 ff d4             	call   *%r12
  80047a:	48 83 f8 01          	cmp    $0x1,%rax
  80047e:	74 de                	je     80045e <umain+0x439>
        cprintf("\npipe write closed properly\n");
  800480:	48 bf d8 40 80 00 00 	movabs $0x8040d8,%rdi
  800487:	00 00 00 
  80048a:	b8 00 00 00 00       	mov    $0x0,%eax
  80048f:	48 ba e1 06 80 00 00 	movabs $0x8006e1,%rdx
  800496:	00 00 00 
  800499:	ff d2                	call   *%rdx
        exit();
  80049b:	48 b8 5e 05 80 00 00 	movabs $0x80055e,%rax
  8004a2:	00 00 00 
  8004a5:	ff d0                	call   *%rax
  8004a7:	e9 1f fd ff ff       	jmp    8001cb <umain+0x1a6>

00000000008004ac <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  8004ac:	f3 0f 1e fa          	endbr64
  8004b0:	55                   	push   %rbp
  8004b1:	48 89 e5             	mov    %rsp,%rbp
  8004b4:	41 56                	push   %r14
  8004b6:	41 55                	push   %r13
  8004b8:	41 54                	push   %r12
  8004ba:	53                   	push   %rbx
  8004bb:	41 89 fd             	mov    %edi,%r13d
  8004be:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
     * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  8004c1:	48 ba d8 50 80 00 00 	movabs $0x8050d8,%rdx
  8004c8:	00 00 00 
  8004cb:	48 b8 d8 50 80 00 00 	movabs $0x8050d8,%rax
  8004d2:	00 00 00 
  8004d5:	48 39 c2             	cmp    %rax,%rdx
  8004d8:	73 17                	jae    8004f1 <libmain+0x45>
    void (**ctor)() = &__ctors_start;
  8004da:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  8004dd:	49 89 c4             	mov    %rax,%r12
  8004e0:	48 83 c3 08          	add    $0x8,%rbx
  8004e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8004e9:	ff 53 f8             	call   *-0x8(%rbx)
  8004ec:	4c 39 e3             	cmp    %r12,%rbx
  8004ef:	72 ef                	jb     8004e0 <libmain+0x34>

    /* Set thisenv to point at our Env structure in envs[]. */

    // LAB 8: Your code here
    thisenv = &((struct Env *)UENVS)[ENVX(sys_getenvid())];
  8004f1:	48 b8 5f 15 80 00 00 	movabs $0x80155f,%rax
  8004f8:	00 00 00 
  8004fb:	ff d0                	call   *%rax
  8004fd:	25 ff 03 00 00       	and    $0x3ff,%eax
  800502:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  800506:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  80050a:	48 c1 e0 04          	shl    $0x4,%rax
  80050e:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  800515:	00 00 00 
  800518:	48 01 d0             	add    %rdx,%rax
  80051b:	48 a3 00 60 80 00 00 	movabs %rax,0x806000
  800522:	00 00 00 

    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  800525:	45 85 ed             	test   %r13d,%r13d
  800528:	7e 0d                	jle    800537 <libmain+0x8b>
  80052a:	49 8b 06             	mov    (%r14),%rax
  80052d:	48 a3 08 50 80 00 00 	movabs %rax,0x805008
  800534:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  800537:	4c 89 f6             	mov    %r14,%rsi
  80053a:	44 89 ef             	mov    %r13d,%edi
  80053d:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  800544:	00 00 00 
  800547:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  800549:	48 b8 5e 05 80 00 00 	movabs $0x80055e,%rax
  800550:	00 00 00 
  800553:	ff d0                	call   *%rax
#endif
}
  800555:	5b                   	pop    %rbx
  800556:	41 5c                	pop    %r12
  800558:	41 5d                	pop    %r13
  80055a:	41 5e                	pop    %r14
  80055c:	5d                   	pop    %rbp
  80055d:	c3                   	ret

000000000080055e <exit>:

#include <inc/lib.h>

void
exit(void) {
  80055e:	f3 0f 1e fa          	endbr64
  800562:	55                   	push   %rbp
  800563:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  800566:	48 b8 91 1d 80 00 00 	movabs $0x801d91,%rax
  80056d:	00 00 00 
  800570:	ff d0                	call   *%rax
    sys_env_destroy(0);
  800572:	bf 00 00 00 00       	mov    $0x0,%edi
  800577:	48 b8 f0 14 80 00 00 	movabs $0x8014f0,%rax
  80057e:	00 00 00 
  800581:	ff d0                	call   *%rax
}
  800583:	5d                   	pop    %rbp
  800584:	c3                   	ret

0000000000800585 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  800585:	f3 0f 1e fa          	endbr64
  800589:	55                   	push   %rbp
  80058a:	48 89 e5             	mov    %rsp,%rbp
  80058d:	41 56                	push   %r14
  80058f:	41 55                	push   %r13
  800591:	41 54                	push   %r12
  800593:	53                   	push   %rbx
  800594:	48 83 ec 50          	sub    $0x50,%rsp
  800598:	49 89 fc             	mov    %rdi,%r12
  80059b:	41 89 f5             	mov    %esi,%r13d
  80059e:	48 89 d3             	mov    %rdx,%rbx
  8005a1:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8005a5:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  8005a9:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  8005ad:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  8005b4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8005b8:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  8005bc:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  8005c0:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  8005c4:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  8005cb:	00 00 00 
  8005ce:	4c 8b 30             	mov    (%rax),%r14
  8005d1:	48 b8 5f 15 80 00 00 	movabs $0x80155f,%rax
  8005d8:	00 00 00 
  8005db:	ff d0                	call   *%rax
  8005dd:	89 c6                	mov    %eax,%esi
  8005df:	45 89 e8             	mov    %r13d,%r8d
  8005e2:	4c 89 e1             	mov    %r12,%rcx
  8005e5:	4c 89 f2             	mov    %r14,%rdx
  8005e8:	48 bf 28 44 80 00 00 	movabs $0x804428,%rdi
  8005ef:	00 00 00 
  8005f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8005f7:	49 bc e1 06 80 00 00 	movabs $0x8006e1,%r12
  8005fe:	00 00 00 
  800601:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  800604:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  800608:	48 89 df             	mov    %rbx,%rdi
  80060b:	48 b8 79 06 80 00 00 	movabs $0x800679,%rax
  800612:	00 00 00 
  800615:	ff d0                	call   *%rax
    cprintf("\n");
  800617:	48 bf 49 40 80 00 00 	movabs $0x804049,%rdi
  80061e:	00 00 00 
  800621:	b8 00 00 00 00       	mov    $0x0,%eax
  800626:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  800629:	cc                   	int3
  80062a:	eb fd                	jmp    800629 <_panic+0xa4>

000000000080062c <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  80062c:	f3 0f 1e fa          	endbr64
  800630:	55                   	push   %rbp
  800631:	48 89 e5             	mov    %rsp,%rbp
  800634:	53                   	push   %rbx
  800635:	48 83 ec 08          	sub    $0x8,%rsp
  800639:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  80063c:	8b 06                	mov    (%rsi),%eax
  80063e:	8d 50 01             	lea    0x1(%rax),%edx
  800641:	89 16                	mov    %edx,(%rsi)
  800643:	48 98                	cltq
  800645:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  80064a:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  800650:	74 0a                	je     80065c <putch+0x30>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  800652:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  800656:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80065a:	c9                   	leave
  80065b:	c3                   	ret
        sys_cputs(state->buf, state->offset);
  80065c:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  800660:	be ff 00 00 00       	mov    $0xff,%esi
  800665:	48 b8 8a 14 80 00 00 	movabs $0x80148a,%rax
  80066c:	00 00 00 
  80066f:	ff d0                	call   *%rax
        state->offset = 0;
  800671:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  800677:	eb d9                	jmp    800652 <putch+0x26>

0000000000800679 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  800679:	f3 0f 1e fa          	endbr64
  80067d:	55                   	push   %rbp
  80067e:	48 89 e5             	mov    %rsp,%rbp
  800681:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800688:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  80068b:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  800692:	b9 21 00 00 00       	mov    $0x21,%ecx
  800697:	b8 00 00 00 00       	mov    $0x0,%eax
  80069c:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  80069f:	48 89 f1             	mov    %rsi,%rcx
  8006a2:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  8006a9:	48 bf 2c 06 80 00 00 	movabs $0x80062c,%rdi
  8006b0:	00 00 00 
  8006b3:	48 b8 41 08 80 00 00 	movabs $0x800841,%rax
  8006ba:	00 00 00 
  8006bd:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  8006bf:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  8006c6:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  8006cd:	48 b8 8a 14 80 00 00 	movabs $0x80148a,%rax
  8006d4:	00 00 00 
  8006d7:	ff d0                	call   *%rax

    return state.count;
}
  8006d9:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  8006df:	c9                   	leave
  8006e0:	c3                   	ret

00000000008006e1 <cprintf>:

int
cprintf(const char *fmt, ...) {
  8006e1:	f3 0f 1e fa          	endbr64
  8006e5:	55                   	push   %rbp
  8006e6:	48 89 e5             	mov    %rsp,%rbp
  8006e9:	48 83 ec 50          	sub    $0x50,%rsp
  8006ed:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  8006f1:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8006f5:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8006f9:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8006fd:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  800701:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  800708:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80070c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800710:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800714:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  800718:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  80071c:	48 b8 79 06 80 00 00 	movabs $0x800679,%rax
  800723:	00 00 00 
  800726:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  800728:	c9                   	leave
  800729:	c3                   	ret

000000000080072a <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  80072a:	f3 0f 1e fa          	endbr64
  80072e:	55                   	push   %rbp
  80072f:	48 89 e5             	mov    %rsp,%rbp
  800732:	41 57                	push   %r15
  800734:	41 56                	push   %r14
  800736:	41 55                	push   %r13
  800738:	41 54                	push   %r12
  80073a:	53                   	push   %rbx
  80073b:	48 83 ec 18          	sub    $0x18,%rsp
  80073f:	49 89 fc             	mov    %rdi,%r12
  800742:	49 89 f5             	mov    %rsi,%r13
  800745:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  800749:	8b 45 10             	mov    0x10(%rbp),%eax
  80074c:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  80074f:	41 89 cf             	mov    %ecx,%r15d
  800752:	4c 39 fa             	cmp    %r15,%rdx
  800755:	73 5b                	jae    8007b2 <print_num+0x88>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  800757:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  80075b:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  80075f:	85 db                	test   %ebx,%ebx
  800761:	7e 0e                	jle    800771 <print_num+0x47>
            putch(padc, put_arg);
  800763:	4c 89 ee             	mov    %r13,%rsi
  800766:	44 89 f7             	mov    %r14d,%edi
  800769:	41 ff d4             	call   *%r12
        while (--width > 0) {
  80076c:	83 eb 01             	sub    $0x1,%ebx
  80076f:	75 f2                	jne    800763 <print_num+0x39>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  800771:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  800775:	48 b9 23 41 80 00 00 	movabs $0x804123,%rcx
  80077c:	00 00 00 
  80077f:	48 b8 12 41 80 00 00 	movabs $0x804112,%rax
  800786:	00 00 00 
  800789:	48 0f 45 c8          	cmovne %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  80078d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800791:	ba 00 00 00 00       	mov    $0x0,%edx
  800796:	49 f7 f7             	div    %r15
  800799:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  80079d:	4c 89 ee             	mov    %r13,%rsi
  8007a0:	41 ff d4             	call   *%r12
}
  8007a3:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  8007a7:	5b                   	pop    %rbx
  8007a8:	41 5c                	pop    %r12
  8007aa:	41 5d                	pop    %r13
  8007ac:	41 5e                	pop    %r14
  8007ae:	41 5f                	pop    %r15
  8007b0:	5d                   	pop    %rbp
  8007b1:	c3                   	ret
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  8007b2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8007b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8007bb:	49 f7 f7             	div    %r15
  8007be:	48 83 ec 08          	sub    $0x8,%rsp
  8007c2:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  8007c6:	52                   	push   %rdx
  8007c7:	45 0f be c9          	movsbl %r9b,%r9d
  8007cb:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  8007cf:	48 89 c2             	mov    %rax,%rdx
  8007d2:	48 b8 2a 07 80 00 00 	movabs $0x80072a,%rax
  8007d9:	00 00 00 
  8007dc:	ff d0                	call   *%rax
  8007de:	48 83 c4 10          	add    $0x10,%rsp
  8007e2:	eb 8d                	jmp    800771 <print_num+0x47>

00000000008007e4 <sprintputch>:
    char *end;
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
  8007e4:	f3 0f 1e fa          	endbr64
    state->count++;
  8007e8:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  8007ec:	48 8b 06             	mov    (%rsi),%rax
  8007ef:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  8007f3:	73 0a                	jae    8007ff <sprintputch+0x1b>
        *state->start++ = ch;
  8007f5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8007f9:	48 89 16             	mov    %rdx,(%rsi)
  8007fc:	40 88 38             	mov    %dil,(%rax)
    }
}
  8007ff:	c3                   	ret

0000000000800800 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  800800:	f3 0f 1e fa          	endbr64
  800804:	55                   	push   %rbp
  800805:	48 89 e5             	mov    %rsp,%rbp
  800808:	48 83 ec 50          	sub    $0x50,%rsp
  80080c:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800810:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800814:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  800818:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  80081f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800823:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800827:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80082b:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  80082f:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800833:	48 b8 41 08 80 00 00 	movabs $0x800841,%rax
  80083a:	00 00 00 
  80083d:	ff d0                	call   *%rax
}
  80083f:	c9                   	leave
  800840:	c3                   	ret

0000000000800841 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  800841:	f3 0f 1e fa          	endbr64
  800845:	55                   	push   %rbp
  800846:	48 89 e5             	mov    %rsp,%rbp
  800849:	41 57                	push   %r15
  80084b:	41 56                	push   %r14
  80084d:	41 55                	push   %r13
  80084f:	41 54                	push   %r12
  800851:	53                   	push   %rbx
  800852:	48 83 ec 38          	sub    $0x38,%rsp
  800856:	49 89 fe             	mov    %rdi,%r14
  800859:	49 89 f5             	mov    %rsi,%r13
  80085c:	48 89 d3             	mov    %rdx,%rbx
    va_copy(aq, ap);
  80085f:	48 8b 01             	mov    (%rcx),%rax
  800862:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  800866:	48 8b 41 08          	mov    0x8(%rcx),%rax
  80086a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80086e:	48 8b 41 10          	mov    0x10(%rcx),%rax
  800872:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  800876:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  80087a:	0f b6 3b             	movzbl (%rbx),%edi
  80087d:	40 80 ff 25          	cmp    $0x25,%dil
  800881:	74 18                	je     80089b <vprintfmt+0x5a>
            if (!ch) return;
  800883:	40 84 ff             	test   %dil,%dil
  800886:	0f 84 b2 06 00 00    	je     800f3e <vprintfmt+0x6fd>
            putch(ch, put_arg);
  80088c:	40 0f b6 ff          	movzbl %dil,%edi
  800890:	4c 89 ee             	mov    %r13,%rsi
  800893:	41 ff d6             	call   *%r14
        while ((ch = *ufmt++) != '%') {
  800896:	4c 89 e3             	mov    %r12,%rbx
  800899:	eb db                	jmp    800876 <vprintfmt+0x35>
        bool altflag = 0, zflag = 0;
  80089b:	be 00 00 00 00       	mov    $0x0,%esi
  8008a0:	c6 45 ab 00          	movb   $0x0,-0x55(%rbp)
        unsigned lflag = 0, base = 10;
  8008a4:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  8008a9:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  8008af:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  8008b6:	c6 45 aa 20          	movb   $0x20,-0x56(%rbp)
        switch (ch = *ufmt++) {
  8008ba:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  8008bf:	41 0f b6 04 24       	movzbl (%r12),%eax
  8008c4:	88 45 a0             	mov    %al,-0x60(%rbp)
  8008c7:	83 e8 23             	sub    $0x23,%eax
  8008ca:	3c 57                	cmp    $0x57,%al
  8008cc:	0f 87 52 06 00 00    	ja     800f24 <vprintfmt+0x6e3>
  8008d2:	0f b6 c0             	movzbl %al,%eax
  8008d5:	48 b9 40 45 80 00 00 	movabs $0x804540,%rcx
  8008dc:	00 00 00 
  8008df:	3e ff 24 c1          	notrack jmp *(%rcx,%rax,8)
  8008e3:	49 89 dc             	mov    %rbx,%r12
            altflag = 1;
  8008e6:	c6 45 ab 01          	movb   $0x1,-0x55(%rbp)
  8008ea:	eb ce                	jmp    8008ba <vprintfmt+0x79>
        switch (ch = *ufmt++) {
  8008ec:	49 89 dc             	mov    %rbx,%r12
  8008ef:	be 01 00 00 00       	mov    $0x1,%esi
  8008f4:	eb c4                	jmp    8008ba <vprintfmt+0x79>
            padc = ch;
  8008f6:	0f b6 45 a0          	movzbl -0x60(%rbp),%eax
  8008fa:	88 45 aa             	mov    %al,-0x56(%rbp)
        switch (ch = *ufmt++) {
  8008fd:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  800900:	eb b8                	jmp    8008ba <vprintfmt+0x79>
            precision = va_arg(aq, int);
  800902:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800905:	83 f8 2f             	cmp    $0x2f,%eax
  800908:	77 24                	ja     80092e <vprintfmt+0xed>
  80090a:	89 c1                	mov    %eax,%ecx
  80090c:	48 03 4d c8          	add    -0x38(%rbp),%rcx
  800910:	83 c0 08             	add    $0x8,%eax
  800913:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800916:	44 8b 39             	mov    (%rcx),%r15d
        switch (ch = *ufmt++) {
  800919:	49 89 dc             	mov    %rbx,%r12
            if (width < 0) {
  80091c:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800920:	79 98                	jns    8008ba <vprintfmt+0x79>
                width = precision;
  800922:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
                precision = -1;
  800926:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  80092c:	eb 8c                	jmp    8008ba <vprintfmt+0x79>
            precision = va_arg(aq, int);
  80092e:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  800932:	48 8d 41 08          	lea    0x8(%rcx),%rax
  800936:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80093a:	eb da                	jmp    800916 <vprintfmt+0xd5>
                precision = precision * 10 + ch - '0';
  80093c:	44 0f b6 7d a0       	movzbl -0x60(%rbp),%r15d
  800941:	41 83 ef 30          	sub    $0x30,%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  800945:	41 0f b6 44 24 01    	movzbl 0x1(%r12),%eax
  80094b:	3c 39                	cmp    $0x39,%al
  80094d:	77 1c                	ja     80096b <vprintfmt+0x12a>
            for (precision = 0;; ++ufmt) {
  80094f:	48 83 c3 01          	add    $0x1,%rbx
                precision = precision * 10 + ch - '0';
  800953:	43 8d 0c bf          	lea    (%r15,%r15,4),%ecx
  800957:	0f b6 c0             	movzbl %al,%eax
  80095a:	44 8d 7c 48 d0       	lea    -0x30(%rax,%rcx,2),%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  80095f:	0f b6 03             	movzbl (%rbx),%eax
  800962:	3c 39                	cmp    $0x39,%al
  800964:	76 e9                	jbe    80094f <vprintfmt+0x10e>
        process_precision:
  800966:	49 89 dc             	mov    %rbx,%r12
  800969:	eb b1                	jmp    80091c <vprintfmt+0xdb>
        switch (ch = *ufmt++) {
  80096b:	49 89 dc             	mov    %rbx,%r12
  80096e:	eb ac                	jmp    80091c <vprintfmt+0xdb>
            width = MAX(0, width);
  800970:	8b 4d ac             	mov    -0x54(%rbp),%ecx
  800973:	85 c9                	test   %ecx,%ecx
  800975:	b8 00 00 00 00       	mov    $0x0,%eax
  80097a:	0f 49 c1             	cmovns %ecx,%eax
  80097d:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  800980:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  800983:	e9 32 ff ff ff       	jmp    8008ba <vprintfmt+0x79>
            lflag++;
  800988:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  80098b:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  80098e:	e9 27 ff ff ff       	jmp    8008ba <vprintfmt+0x79>
            putch(va_arg(aq, int), put_arg);
  800993:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800996:	83 f8 2f             	cmp    $0x2f,%eax
  800999:	77 19                	ja     8009b4 <vprintfmt+0x173>
  80099b:	89 c2                	mov    %eax,%edx
  80099d:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8009a1:	83 c0 08             	add    $0x8,%eax
  8009a4:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009a7:	8b 3a                	mov    (%rdx),%edi
  8009a9:	4c 89 ee             	mov    %r13,%rsi
  8009ac:	41 ff d6             	call   *%r14
            break;
  8009af:	e9 c2 fe ff ff       	jmp    800876 <vprintfmt+0x35>
            putch(va_arg(aq, int), put_arg);
  8009b4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009b8:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009bc:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009c0:	eb e5                	jmp    8009a7 <vprintfmt+0x166>
            int err = va_arg(aq, int);
  8009c2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009c5:	83 f8 2f             	cmp    $0x2f,%eax
  8009c8:	77 5a                	ja     800a24 <vprintfmt+0x1e3>
  8009ca:	89 c2                	mov    %eax,%edx
  8009cc:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8009d0:	83 c0 08             	add    $0x8,%eax
  8009d3:	89 45 b8             	mov    %eax,-0x48(%rbp)
            if (err < 0) err = -err;
  8009d6:	8b 02                	mov    (%rdx),%eax
  8009d8:	89 c1                	mov    %eax,%ecx
  8009da:	f7 d9                	neg    %ecx
  8009dc:	0f 48 c8             	cmovs  %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  8009df:	83 f9 13             	cmp    $0x13,%ecx
  8009e2:	7f 4e                	jg     800a32 <vprintfmt+0x1f1>
  8009e4:	48 63 c1             	movslq %ecx,%rax
  8009e7:	48 ba 00 48 80 00 00 	movabs $0x804800,%rdx
  8009ee:	00 00 00 
  8009f1:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8009f5:	48 85 c0             	test   %rax,%rax
  8009f8:	74 38                	je     800a32 <vprintfmt+0x1f1>
                printfmt(putch, put_arg, "%s", strerr);
  8009fa:	48 89 c1             	mov    %rax,%rcx
  8009fd:	48 ba 3d 43 80 00 00 	movabs $0x80433d,%rdx
  800a04:	00 00 00 
  800a07:	4c 89 ee             	mov    %r13,%rsi
  800a0a:	4c 89 f7             	mov    %r14,%rdi
  800a0d:	b8 00 00 00 00       	mov    $0x0,%eax
  800a12:	49 b8 00 08 80 00 00 	movabs $0x800800,%r8
  800a19:	00 00 00 
  800a1c:	41 ff d0             	call   *%r8
  800a1f:	e9 52 fe ff ff       	jmp    800876 <vprintfmt+0x35>
            int err = va_arg(aq, int);
  800a24:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a28:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a2c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a30:	eb a4                	jmp    8009d6 <vprintfmt+0x195>
                printfmt(putch, put_arg, "error %d", err);
  800a32:	48 ba 3b 41 80 00 00 	movabs $0x80413b,%rdx
  800a39:	00 00 00 
  800a3c:	4c 89 ee             	mov    %r13,%rsi
  800a3f:	4c 89 f7             	mov    %r14,%rdi
  800a42:	b8 00 00 00 00       	mov    $0x0,%eax
  800a47:	49 b8 00 08 80 00 00 	movabs $0x800800,%r8
  800a4e:	00 00 00 
  800a51:	41 ff d0             	call   *%r8
  800a54:	e9 1d fe ff ff       	jmp    800876 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  800a59:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a5c:	83 f8 2f             	cmp    $0x2f,%eax
  800a5f:	77 6c                	ja     800acd <vprintfmt+0x28c>
  800a61:	89 c2                	mov    %eax,%edx
  800a63:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a67:	83 c0 08             	add    $0x8,%eax
  800a6a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a6d:	48 8b 12             	mov    (%rdx),%rdx
            if (!ptr) ptr = "(null)";
  800a70:	48 85 d2             	test   %rdx,%rdx
  800a73:	48 b8 34 41 80 00 00 	movabs $0x804134,%rax
  800a7a:	00 00 00 
  800a7d:	48 0f 45 c2          	cmovne %rdx,%rax
  800a81:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
            if (width > 0 && padc != '-') {
  800a85:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800a89:	7e 06                	jle    800a91 <vprintfmt+0x250>
  800a8b:	80 7d aa 2d          	cmpb   $0x2d,-0x56(%rbp)
  800a8f:	75 4a                	jne    800adb <vprintfmt+0x29a>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800a91:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800a95:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800a99:	0f b6 00             	movzbl (%rax),%eax
  800a9c:	84 c0                	test   %al,%al
  800a9e:	0f 85 9a 00 00 00    	jne    800b3e <vprintfmt+0x2fd>
            while (width-- > 0) putch(' ', put_arg);
  800aa4:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800aa7:	44 8d 60 ff          	lea    -0x1(%rax),%r12d
  800aab:	85 c0                	test   %eax,%eax
  800aad:	0f 8e c3 fd ff ff    	jle    800876 <vprintfmt+0x35>
  800ab3:	4c 89 ee             	mov    %r13,%rsi
  800ab6:	bf 20 00 00 00       	mov    $0x20,%edi
  800abb:	41 ff d6             	call   *%r14
  800abe:	41 83 ec 01          	sub    $0x1,%r12d
  800ac2:	41 83 fc ff          	cmp    $0xffffffff,%r12d
  800ac6:	75 eb                	jne    800ab3 <vprintfmt+0x272>
  800ac8:	e9 a9 fd ff ff       	jmp    800876 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  800acd:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ad1:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800ad5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ad9:	eb 92                	jmp    800a6d <vprintfmt+0x22c>
                width -= strnlen(ptr, precision);
  800adb:	49 63 f7             	movslq %r15d,%rsi
  800ade:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  800ae2:	48 b8 04 10 80 00 00 	movabs $0x801004,%rax
  800ae9:	00 00 00 
  800aec:	ff d0                	call   *%rax
  800aee:	48 89 c2             	mov    %rax,%rdx
  800af1:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800af4:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  800af6:	8d 70 ff             	lea    -0x1(%rax),%esi
  800af9:	89 75 ac             	mov    %esi,-0x54(%rbp)
  800afc:	85 c0                	test   %eax,%eax
  800afe:	7e 91                	jle    800a91 <vprintfmt+0x250>
  800b00:	44 0f be 65 aa       	movsbl -0x56(%rbp),%r12d
  800b05:	4c 89 ee             	mov    %r13,%rsi
  800b08:	44 89 e7             	mov    %r12d,%edi
  800b0b:	41 ff d6             	call   *%r14
  800b0e:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  800b12:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800b15:	83 f8 ff             	cmp    $0xffffffff,%eax
  800b18:	75 eb                	jne    800b05 <vprintfmt+0x2c4>
  800b1a:	e9 72 ff ff ff       	jmp    800a91 <vprintfmt+0x250>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800b1f:	0f b6 f8             	movzbl %al,%edi
  800b22:	4c 89 ee             	mov    %r13,%rsi
  800b25:	41 ff d6             	call   *%r14
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800b28:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  800b2c:	49 83 c4 01          	add    $0x1,%r12
  800b30:	41 0f b6 44 24 ff    	movzbl -0x1(%r12),%eax
  800b36:	84 c0                	test   %al,%al
  800b38:	0f 84 66 ff ff ff    	je     800aa4 <vprintfmt+0x263>
  800b3e:	45 85 ff             	test   %r15d,%r15d
  800b41:	78 0a                	js     800b4d <vprintfmt+0x30c>
  800b43:	41 83 ef 01          	sub    $0x1,%r15d
  800b47:	0f 88 57 ff ff ff    	js     800aa4 <vprintfmt+0x263>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800b4d:	80 7d ab 00          	cmpb   $0x0,-0x55(%rbp)
  800b51:	74 cc                	je     800b1f <vprintfmt+0x2de>
  800b53:	8d 50 e0             	lea    -0x20(%rax),%edx
  800b56:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b5b:	80 fa 5e             	cmp    $0x5e,%dl
  800b5e:	77 c2                	ja     800b22 <vprintfmt+0x2e1>
  800b60:	eb bd                	jmp    800b1f <vprintfmt+0x2de>
    if (zflag) return va_arg(*ap, size_t);
  800b62:	40 84 f6             	test   %sil,%sil
  800b65:	75 26                	jne    800b8d <vprintfmt+0x34c>
    switch (lflag) {
  800b67:	85 d2                	test   %edx,%edx
  800b69:	74 59                	je     800bc4 <vprintfmt+0x383>
  800b6b:	83 fa 01             	cmp    $0x1,%edx
  800b6e:	74 7b                	je     800beb <vprintfmt+0x3aa>
        return va_arg(*ap, long long);
  800b70:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b73:	83 f8 2f             	cmp    $0x2f,%eax
  800b76:	0f 87 96 00 00 00    	ja     800c12 <vprintfmt+0x3d1>
  800b7c:	89 c2                	mov    %eax,%edx
  800b7e:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b82:	83 c0 08             	add    $0x8,%eax
  800b85:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b88:	4c 8b 22             	mov    (%rdx),%r12
  800b8b:	eb 17                	jmp    800ba4 <vprintfmt+0x363>
    if (zflag) return va_arg(*ap, size_t);
  800b8d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b90:	83 f8 2f             	cmp    $0x2f,%eax
  800b93:	77 21                	ja     800bb6 <vprintfmt+0x375>
  800b95:	89 c2                	mov    %eax,%edx
  800b97:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b9b:	83 c0 08             	add    $0x8,%eax
  800b9e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ba1:	4c 8b 22             	mov    (%rdx),%r12
            if (i < 0) {
  800ba4:	4d 85 e4             	test   %r12,%r12
  800ba7:	78 7a                	js     800c23 <vprintfmt+0x3e2>
            num = i;
  800ba9:	4c 89 e2             	mov    %r12,%rdx
        unsigned lflag = 0, base = 10;
  800bac:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  800bb1:	e9 50 02 00 00       	jmp    800e06 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800bb6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bba:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800bbe:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800bc2:	eb dd                	jmp    800ba1 <vprintfmt+0x360>
        return va_arg(*ap, int);
  800bc4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bc7:	83 f8 2f             	cmp    $0x2f,%eax
  800bca:	77 11                	ja     800bdd <vprintfmt+0x39c>
  800bcc:	89 c2                	mov    %eax,%edx
  800bce:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800bd2:	83 c0 08             	add    $0x8,%eax
  800bd5:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800bd8:	4c 63 22             	movslq (%rdx),%r12
  800bdb:	eb c7                	jmp    800ba4 <vprintfmt+0x363>
  800bdd:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800be1:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800be5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800be9:	eb ed                	jmp    800bd8 <vprintfmt+0x397>
        return va_arg(*ap, long);
  800beb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bee:	83 f8 2f             	cmp    $0x2f,%eax
  800bf1:	77 11                	ja     800c04 <vprintfmt+0x3c3>
  800bf3:	89 c2                	mov    %eax,%edx
  800bf5:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800bf9:	83 c0 08             	add    $0x8,%eax
  800bfc:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800bff:	4c 8b 22             	mov    (%rdx),%r12
  800c02:	eb a0                	jmp    800ba4 <vprintfmt+0x363>
  800c04:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c08:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800c0c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c10:	eb ed                	jmp    800bff <vprintfmt+0x3be>
        return va_arg(*ap, long long);
  800c12:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c16:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800c1a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c1e:	e9 65 ff ff ff       	jmp    800b88 <vprintfmt+0x347>
                putch('-', put_arg);
  800c23:	4c 89 ee             	mov    %r13,%rsi
  800c26:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800c2b:	41 ff d6             	call   *%r14
                i = -i;
  800c2e:	49 f7 dc             	neg    %r12
  800c31:	e9 73 ff ff ff       	jmp    800ba9 <vprintfmt+0x368>
    if (zflag) return va_arg(*ap, size_t);
  800c36:	40 84 f6             	test   %sil,%sil
  800c39:	75 32                	jne    800c6d <vprintfmt+0x42c>
    switch (lflag) {
  800c3b:	85 d2                	test   %edx,%edx
  800c3d:	74 5d                	je     800c9c <vprintfmt+0x45b>
  800c3f:	83 fa 01             	cmp    $0x1,%edx
  800c42:	0f 84 82 00 00 00    	je     800cca <vprintfmt+0x489>
        return va_arg(*ap, unsigned long long);
  800c48:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c4b:	83 f8 2f             	cmp    $0x2f,%eax
  800c4e:	0f 87 a5 00 00 00    	ja     800cf9 <vprintfmt+0x4b8>
  800c54:	89 c2                	mov    %eax,%edx
  800c56:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800c5a:	83 c0 08             	add    $0x8,%eax
  800c5d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c60:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800c63:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  800c68:	e9 99 01 00 00       	jmp    800e06 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800c6d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c70:	83 f8 2f             	cmp    $0x2f,%eax
  800c73:	77 19                	ja     800c8e <vprintfmt+0x44d>
  800c75:	89 c2                	mov    %eax,%edx
  800c77:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800c7b:	83 c0 08             	add    $0x8,%eax
  800c7e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c81:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800c84:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800c89:	e9 78 01 00 00       	jmp    800e06 <vprintfmt+0x5c5>
  800c8e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c92:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800c96:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c9a:	eb e5                	jmp    800c81 <vprintfmt+0x440>
        return va_arg(*ap, unsigned int);
  800c9c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c9f:	83 f8 2f             	cmp    $0x2f,%eax
  800ca2:	77 18                	ja     800cbc <vprintfmt+0x47b>
  800ca4:	89 c2                	mov    %eax,%edx
  800ca6:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800caa:	83 c0 08             	add    $0x8,%eax
  800cad:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800cb0:	8b 12                	mov    (%rdx),%edx
        unsigned lflag = 0, base = 10;
  800cb2:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  800cb7:	e9 4a 01 00 00       	jmp    800e06 <vprintfmt+0x5c5>
  800cbc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cc0:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800cc4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800cc8:	eb e6                	jmp    800cb0 <vprintfmt+0x46f>
        return va_arg(*ap, unsigned long);
  800cca:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ccd:	83 f8 2f             	cmp    $0x2f,%eax
  800cd0:	77 19                	ja     800ceb <vprintfmt+0x4aa>
  800cd2:	89 c2                	mov    %eax,%edx
  800cd4:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800cd8:	83 c0 08             	add    $0x8,%eax
  800cdb:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800cde:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800ce1:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  800ce6:	e9 1b 01 00 00       	jmp    800e06 <vprintfmt+0x5c5>
  800ceb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cef:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800cf3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800cf7:	eb e5                	jmp    800cde <vprintfmt+0x49d>
        return va_arg(*ap, unsigned long long);
  800cf9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cfd:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800d01:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800d05:	e9 56 ff ff ff       	jmp    800c60 <vprintfmt+0x41f>
    if (zflag) return va_arg(*ap, size_t);
  800d0a:	40 84 f6             	test   %sil,%sil
  800d0d:	75 2e                	jne    800d3d <vprintfmt+0x4fc>
    switch (lflag) {
  800d0f:	85 d2                	test   %edx,%edx
  800d11:	74 59                	je     800d6c <vprintfmt+0x52b>
  800d13:	83 fa 01             	cmp    $0x1,%edx
  800d16:	74 7f                	je     800d97 <vprintfmt+0x556>
        return va_arg(*ap, unsigned long long);
  800d18:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d1b:	83 f8 2f             	cmp    $0x2f,%eax
  800d1e:	0f 87 9f 00 00 00    	ja     800dc3 <vprintfmt+0x582>
  800d24:	89 c2                	mov    %eax,%edx
  800d26:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800d2a:	83 c0 08             	add    $0x8,%eax
  800d2d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800d30:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800d33:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  800d38:	e9 c9 00 00 00       	jmp    800e06 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800d3d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d40:	83 f8 2f             	cmp    $0x2f,%eax
  800d43:	77 19                	ja     800d5e <vprintfmt+0x51d>
  800d45:	89 c2                	mov    %eax,%edx
  800d47:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800d4b:	83 c0 08             	add    $0x8,%eax
  800d4e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800d51:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800d54:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800d59:	e9 a8 00 00 00       	jmp    800e06 <vprintfmt+0x5c5>
  800d5e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d62:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800d66:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800d6a:	eb e5                	jmp    800d51 <vprintfmt+0x510>
        return va_arg(*ap, unsigned int);
  800d6c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d6f:	83 f8 2f             	cmp    $0x2f,%eax
  800d72:	77 15                	ja     800d89 <vprintfmt+0x548>
  800d74:	89 c2                	mov    %eax,%edx
  800d76:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800d7a:	83 c0 08             	add    $0x8,%eax
  800d7d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800d80:	8b 12                	mov    (%rdx),%edx
            base = 8;
  800d82:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  800d87:	eb 7d                	jmp    800e06 <vprintfmt+0x5c5>
  800d89:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d8d:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800d91:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800d95:	eb e9                	jmp    800d80 <vprintfmt+0x53f>
        return va_arg(*ap, unsigned long);
  800d97:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d9a:	83 f8 2f             	cmp    $0x2f,%eax
  800d9d:	77 16                	ja     800db5 <vprintfmt+0x574>
  800d9f:	89 c2                	mov    %eax,%edx
  800da1:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800da5:	83 c0 08             	add    $0x8,%eax
  800da8:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800dab:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800dae:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  800db3:	eb 51                	jmp    800e06 <vprintfmt+0x5c5>
  800db5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800db9:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800dbd:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800dc1:	eb e8                	jmp    800dab <vprintfmt+0x56a>
        return va_arg(*ap, unsigned long long);
  800dc3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800dc7:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800dcb:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800dcf:	e9 5c ff ff ff       	jmp    800d30 <vprintfmt+0x4ef>
            putch('0', put_arg);
  800dd4:	4c 89 ee             	mov    %r13,%rsi
  800dd7:	bf 30 00 00 00       	mov    $0x30,%edi
  800ddc:	41 ff d6             	call   *%r14
            putch('x', put_arg);
  800ddf:	4c 89 ee             	mov    %r13,%rsi
  800de2:	bf 78 00 00 00       	mov    $0x78,%edi
  800de7:	41 ff d6             	call   *%r14
            num = (uintptr_t)va_arg(aq, void *);
  800dea:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ded:	83 f8 2f             	cmp    $0x2f,%eax
  800df0:	77 47                	ja     800e39 <vprintfmt+0x5f8>
  800df2:	89 c2                	mov    %eax,%edx
  800df4:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800df8:	83 c0 08             	add    $0x8,%eax
  800dfb:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800dfe:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800e01:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  800e06:	48 83 ec 08          	sub    $0x8,%rsp
  800e0a:	80 7d a0 58          	cmpb   $0x58,-0x60(%rbp)
  800e0e:	0f 94 c0             	sete   %al
  800e11:	0f b6 c0             	movzbl %al,%eax
  800e14:	50                   	push   %rax
  800e15:	44 0f be 4d aa       	movsbl -0x56(%rbp),%r9d
  800e1a:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  800e1e:	4c 89 ee             	mov    %r13,%rsi
  800e21:	4c 89 f7             	mov    %r14,%rdi
  800e24:	48 b8 2a 07 80 00 00 	movabs $0x80072a,%rax
  800e2b:	00 00 00 
  800e2e:	ff d0                	call   *%rax
            break;
  800e30:	48 83 c4 10          	add    $0x10,%rsp
  800e34:	e9 3d fa ff ff       	jmp    800876 <vprintfmt+0x35>
            num = (uintptr_t)va_arg(aq, void *);
  800e39:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e3d:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800e41:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800e45:	eb b7                	jmp    800dfe <vprintfmt+0x5bd>
    if (zflag) return va_arg(*ap, size_t);
  800e47:	40 84 f6             	test   %sil,%sil
  800e4a:	75 2b                	jne    800e77 <vprintfmt+0x636>
    switch (lflag) {
  800e4c:	85 d2                	test   %edx,%edx
  800e4e:	74 56                	je     800ea6 <vprintfmt+0x665>
  800e50:	83 fa 01             	cmp    $0x1,%edx
  800e53:	74 7f                	je     800ed4 <vprintfmt+0x693>
        return va_arg(*ap, unsigned long long);
  800e55:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e58:	83 f8 2f             	cmp    $0x2f,%eax
  800e5b:	0f 87 a2 00 00 00    	ja     800f03 <vprintfmt+0x6c2>
  800e61:	89 c2                	mov    %eax,%edx
  800e63:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800e67:	83 c0 08             	add    $0x8,%eax
  800e6a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800e6d:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800e70:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800e75:	eb 8f                	jmp    800e06 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800e77:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e7a:	83 f8 2f             	cmp    $0x2f,%eax
  800e7d:	77 19                	ja     800e98 <vprintfmt+0x657>
  800e7f:	89 c2                	mov    %eax,%edx
  800e81:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800e85:	83 c0 08             	add    $0x8,%eax
  800e88:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800e8b:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800e8e:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800e93:	e9 6e ff ff ff       	jmp    800e06 <vprintfmt+0x5c5>
  800e98:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e9c:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800ea0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ea4:	eb e5                	jmp    800e8b <vprintfmt+0x64a>
        return va_arg(*ap, unsigned int);
  800ea6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ea9:	83 f8 2f             	cmp    $0x2f,%eax
  800eac:	77 18                	ja     800ec6 <vprintfmt+0x685>
  800eae:	89 c2                	mov    %eax,%edx
  800eb0:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800eb4:	83 c0 08             	add    $0x8,%eax
  800eb7:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800eba:	8b 12                	mov    (%rdx),%edx
            base = 16;
  800ebc:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  800ec1:	e9 40 ff ff ff       	jmp    800e06 <vprintfmt+0x5c5>
  800ec6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800eca:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800ece:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ed2:	eb e6                	jmp    800eba <vprintfmt+0x679>
        return va_arg(*ap, unsigned long);
  800ed4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ed7:	83 f8 2f             	cmp    $0x2f,%eax
  800eda:	77 19                	ja     800ef5 <vprintfmt+0x6b4>
  800edc:	89 c2                	mov    %eax,%edx
  800ede:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800ee2:	83 c0 08             	add    $0x8,%eax
  800ee5:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ee8:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800eeb:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800ef0:	e9 11 ff ff ff       	jmp    800e06 <vprintfmt+0x5c5>
  800ef5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ef9:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800efd:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800f01:	eb e5                	jmp    800ee8 <vprintfmt+0x6a7>
        return va_arg(*ap, unsigned long long);
  800f03:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800f07:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800f0b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800f0f:	e9 59 ff ff ff       	jmp    800e6d <vprintfmt+0x62c>
            putch(ch, put_arg);
  800f14:	4c 89 ee             	mov    %r13,%rsi
  800f17:	bf 25 00 00 00       	mov    $0x25,%edi
  800f1c:	41 ff d6             	call   *%r14
            break;
  800f1f:	e9 52 f9 ff ff       	jmp    800876 <vprintfmt+0x35>
            putch('%', put_arg);
  800f24:	4c 89 ee             	mov    %r13,%rsi
  800f27:	bf 25 00 00 00       	mov    $0x25,%edi
  800f2c:	41 ff d6             	call   *%r14
            while ((--ufmt)[-1] != '%') /* nothing */
  800f2f:	48 83 eb 01          	sub    $0x1,%rbx
  800f33:	80 7b ff 25          	cmpb   $0x25,-0x1(%rbx)
  800f37:	75 f6                	jne    800f2f <vprintfmt+0x6ee>
  800f39:	e9 38 f9 ff ff       	jmp    800876 <vprintfmt+0x35>
}
  800f3e:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800f42:	5b                   	pop    %rbx
  800f43:	41 5c                	pop    %r12
  800f45:	41 5d                	pop    %r13
  800f47:	41 5e                	pop    %r14
  800f49:	41 5f                	pop    %r15
  800f4b:	5d                   	pop    %rbp
  800f4c:	c3                   	ret

0000000000800f4d <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800f4d:	f3 0f 1e fa          	endbr64
  800f51:	55                   	push   %rbp
  800f52:	48 89 e5             	mov    %rsp,%rbp
  800f55:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800f59:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f5d:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800f62:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800f66:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800f6d:	48 85 ff             	test   %rdi,%rdi
  800f70:	74 2b                	je     800f9d <vsnprintf+0x50>
  800f72:	48 85 f6             	test   %rsi,%rsi
  800f75:	74 26                	je     800f9d <vsnprintf+0x50>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800f77:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800f7b:	48 bf e4 07 80 00 00 	movabs $0x8007e4,%rdi
  800f82:	00 00 00 
  800f85:	48 b8 41 08 80 00 00 	movabs $0x800841,%rax
  800f8c:	00 00 00 
  800f8f:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800f91:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f95:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800f98:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800f9b:	c9                   	leave
  800f9c:	c3                   	ret
    if (!buf || n < 1) return -E_INVAL;
  800f9d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fa2:	eb f7                	jmp    800f9b <vsnprintf+0x4e>

0000000000800fa4 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800fa4:	f3 0f 1e fa          	endbr64
  800fa8:	55                   	push   %rbp
  800fa9:	48 89 e5             	mov    %rsp,%rbp
  800fac:	48 83 ec 50          	sub    $0x50,%rsp
  800fb0:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800fb4:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800fb8:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800fbc:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800fc3:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800fc7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800fcb:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800fcf:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800fd3:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800fd7:	48 b8 4d 0f 80 00 00 	movabs $0x800f4d,%rax
  800fde:	00 00 00 
  800fe1:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800fe3:	c9                   	leave
  800fe4:	c3                   	ret

0000000000800fe5 <strlen>:
 * Primespipe runs 3x faster this way */

#define ASM 1

size_t
strlen(const char *s) {
  800fe5:	f3 0f 1e fa          	endbr64
    size_t n = 0;
    while (*s++) n++;
  800fe9:	80 3f 00             	cmpb   $0x0,(%rdi)
  800fec:	74 10                	je     800ffe <strlen+0x19>
    size_t n = 0;
  800fee:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800ff3:	48 83 c0 01          	add    $0x1,%rax
  800ff7:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800ffb:	75 f6                	jne    800ff3 <strlen+0xe>
  800ffd:	c3                   	ret
    size_t n = 0;
  800ffe:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  801003:	c3                   	ret

0000000000801004 <strnlen>:

size_t
strnlen(const char *s, size_t size) {
  801004:	f3 0f 1e fa          	endbr64
  801008:	48 89 f0             	mov    %rsi,%rax
    size_t n = 0;
  80100b:	ba 00 00 00 00       	mov    $0x0,%edx
    while (n < size && *s++) n++;
  801010:	48 85 f6             	test   %rsi,%rsi
  801013:	74 10                	je     801025 <strnlen+0x21>
  801015:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  801019:	74 0b                	je     801026 <strnlen+0x22>
  80101b:	48 83 c2 01          	add    $0x1,%rdx
  80101f:	48 39 d0             	cmp    %rdx,%rax
  801022:	75 f1                	jne    801015 <strnlen+0x11>
  801024:	c3                   	ret
  801025:	c3                   	ret
  801026:	48 89 d0             	mov    %rdx,%rax
    return n;
}
  801029:	c3                   	ret

000000000080102a <strcpy>:

char *
strcpy(char *dst, const char *src) {
  80102a:	f3 0f 1e fa          	endbr64
  80102e:	48 89 f8             	mov    %rdi,%rax
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  801031:	ba 00 00 00 00       	mov    $0x0,%edx
  801036:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  80103a:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  80103d:	48 83 c2 01          	add    $0x1,%rdx
  801041:	84 c9                	test   %cl,%cl
  801043:	75 f1                	jne    801036 <strcpy+0xc>
        ;
    return res;
}
  801045:	c3                   	ret

0000000000801046 <strcat>:

char *
strcat(char *dst, const char *src) {
  801046:	f3 0f 1e fa          	endbr64
  80104a:	55                   	push   %rbp
  80104b:	48 89 e5             	mov    %rsp,%rbp
  80104e:	41 54                	push   %r12
  801050:	53                   	push   %rbx
  801051:	48 89 fb             	mov    %rdi,%rbx
  801054:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  801057:	48 b8 e5 0f 80 00 00 	movabs $0x800fe5,%rax
  80105e:	00 00 00 
  801061:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  801063:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  801067:	4c 89 e6             	mov    %r12,%rsi
  80106a:	48 b8 2a 10 80 00 00 	movabs $0x80102a,%rax
  801071:	00 00 00 
  801074:	ff d0                	call   *%rax
    return dst;
}
  801076:	48 89 d8             	mov    %rbx,%rax
  801079:	5b                   	pop    %rbx
  80107a:	41 5c                	pop    %r12
  80107c:	5d                   	pop    %rbp
  80107d:	c3                   	ret

000000000080107e <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80107e:	f3 0f 1e fa          	endbr64
  801082:	48 89 f8             	mov    %rdi,%rax
    char *ret = dst;
    while (size-- > 0) {
  801085:	48 85 d2             	test   %rdx,%rdx
  801088:	74 1f                	je     8010a9 <strncpy+0x2b>
  80108a:	48 01 fa             	add    %rdi,%rdx
  80108d:	48 89 f9             	mov    %rdi,%rcx
        *dst++ = *src;
  801090:	48 83 c1 01          	add    $0x1,%rcx
  801094:	44 0f b6 06          	movzbl (%rsi),%r8d
  801098:	44 88 41 ff          	mov    %r8b,-0x1(%rcx)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  80109c:	41 80 f8 01          	cmp    $0x1,%r8b
  8010a0:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  8010a4:	48 39 ca             	cmp    %rcx,%rdx
  8010a7:	75 e7                	jne    801090 <strncpy+0x12>
    }
    return ret;
}
  8010a9:	c3                   	ret

00000000008010aa <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
  8010aa:	f3 0f 1e fa          	endbr64
    char *dst_in = dst;
    if (size) {
  8010ae:	48 89 f8             	mov    %rdi,%rax
  8010b1:	48 85 d2             	test   %rdx,%rdx
  8010b4:	74 24                	je     8010da <strlcpy+0x30>
        while (--size > 0 && *src)
  8010b6:	48 83 ea 01          	sub    $0x1,%rdx
  8010ba:	74 1b                	je     8010d7 <strlcpy+0x2d>
  8010bc:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  8010c0:	0f b6 16             	movzbl (%rsi),%edx
  8010c3:	84 d2                	test   %dl,%dl
  8010c5:	74 10                	je     8010d7 <strlcpy+0x2d>
            *dst++ = *src++;
  8010c7:	48 83 c6 01          	add    $0x1,%rsi
  8010cb:	48 83 c0 01          	add    $0x1,%rax
  8010cf:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  8010d2:	48 39 c8             	cmp    %rcx,%rax
  8010d5:	75 e9                	jne    8010c0 <strlcpy+0x16>
        *dst = '\0';
  8010d7:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  8010da:	48 29 f8             	sub    %rdi,%rax
}
  8010dd:	c3                   	ret

00000000008010de <strcmp>:
    }
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
  8010de:	f3 0f 1e fa          	endbr64
    while (*p && *p == *q) p++, q++;
  8010e2:	0f b6 07             	movzbl (%rdi),%eax
  8010e5:	84 c0                	test   %al,%al
  8010e7:	74 13                	je     8010fc <strcmp+0x1e>
  8010e9:	38 06                	cmp    %al,(%rsi)
  8010eb:	75 0f                	jne    8010fc <strcmp+0x1e>
  8010ed:	48 83 c7 01          	add    $0x1,%rdi
  8010f1:	48 83 c6 01          	add    $0x1,%rsi
  8010f5:	0f b6 07             	movzbl (%rdi),%eax
  8010f8:	84 c0                	test   %al,%al
  8010fa:	75 ed                	jne    8010e9 <strcmp+0xb>
    return (int)((unsigned char)*p - (unsigned char)*q);
  8010fc:	0f b6 c0             	movzbl %al,%eax
  8010ff:	0f b6 16             	movzbl (%rsi),%edx
  801102:	29 d0                	sub    %edx,%eax
}
  801104:	c3                   	ret

0000000000801105 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
  801105:	f3 0f 1e fa          	endbr64
    while (n && *p && *p == *q) n--, p++, q++;
  801109:	48 85 d2             	test   %rdx,%rdx
  80110c:	74 1f                	je     80112d <strncmp+0x28>
  80110e:	0f b6 07             	movzbl (%rdi),%eax
  801111:	84 c0                	test   %al,%al
  801113:	74 1e                	je     801133 <strncmp+0x2e>
  801115:	3a 06                	cmp    (%rsi),%al
  801117:	75 1a                	jne    801133 <strncmp+0x2e>
  801119:	48 83 c7 01          	add    $0x1,%rdi
  80111d:	48 83 c6 01          	add    $0x1,%rsi
  801121:	48 83 ea 01          	sub    $0x1,%rdx
  801125:	75 e7                	jne    80110e <strncmp+0x9>

    if (!n) return 0;
  801127:	b8 00 00 00 00       	mov    $0x0,%eax
  80112c:	c3                   	ret
  80112d:	b8 00 00 00 00       	mov    $0x0,%eax
  801132:	c3                   	ret

    return (int)((unsigned char)*p - (unsigned char)*q);
  801133:	0f b6 07             	movzbl (%rdi),%eax
  801136:	0f b6 16             	movzbl (%rsi),%edx
  801139:	29 d0                	sub    %edx,%eax
}
  80113b:	c3                   	ret

000000000080113c <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
  80113c:	f3 0f 1e fa          	endbr64
    for (; *str; str++) {
  801140:	0f b6 17             	movzbl (%rdi),%edx
  801143:	84 d2                	test   %dl,%dl
  801145:	74 18                	je     80115f <strchr+0x23>
        if (*str == c) {
  801147:	0f be d2             	movsbl %dl,%edx
  80114a:	39 f2                	cmp    %esi,%edx
  80114c:	74 17                	je     801165 <strchr+0x29>
    for (; *str; str++) {
  80114e:	48 83 c7 01          	add    $0x1,%rdi
  801152:	0f b6 17             	movzbl (%rdi),%edx
  801155:	84 d2                	test   %dl,%dl
  801157:	75 ee                	jne    801147 <strchr+0xb>
            return (char *)str;
        }
    }
    return NULL;
  801159:	b8 00 00 00 00       	mov    $0x0,%eax
  80115e:	c3                   	ret
  80115f:	b8 00 00 00 00       	mov    $0x0,%eax
  801164:	c3                   	ret
            return (char *)str;
  801165:	48 89 f8             	mov    %rdi,%rax
}
  801168:	c3                   	ret

0000000000801169 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
  801169:	f3 0f 1e fa          	endbr64
  80116d:	48 89 f8             	mov    %rdi,%rax
    for (; *str && *str != ch; str++) /* nothing */
  801170:	0f b6 17             	movzbl (%rdi),%edx
  801173:	84 d2                	test   %dl,%dl
  801175:	74 13                	je     80118a <strfind+0x21>
  801177:	0f be d2             	movsbl %dl,%edx
  80117a:	39 f2                	cmp    %esi,%edx
  80117c:	74 0b                	je     801189 <strfind+0x20>
  80117e:	48 83 c0 01          	add    $0x1,%rax
  801182:	0f b6 10             	movzbl (%rax),%edx
  801185:	84 d2                	test   %dl,%dl
  801187:	75 ee                	jne    801177 <strfind+0xe>
        ;
    return (char *)str;
}
  801189:	c3                   	ret
  80118a:	c3                   	ret

000000000080118b <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  80118b:	f3 0f 1e fa          	endbr64
  80118f:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  801192:	48 89 f8             	mov    %rdi,%rax
  801195:	48 f7 d8             	neg    %rax
  801198:	83 e0 07             	and    $0x7,%eax
  80119b:	49 89 d1             	mov    %rdx,%r9
  80119e:	49 29 c1             	sub    %rax,%r9
  8011a1:	78 36                	js     8011d9 <memset+0x4e>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  8011a3:	40 0f b6 c6          	movzbl %sil,%eax
  8011a7:	48 b9 01 01 01 01 01 	movabs $0x101010101010101,%rcx
  8011ae:	01 01 01 
  8011b1:	48 0f af c1          	imul   %rcx,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  8011b5:	40 f6 c7 07          	test   $0x7,%dil
  8011b9:	75 38                	jne    8011f3 <memset+0x68>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  8011bb:	4c 89 c9             	mov    %r9,%rcx
  8011be:	48 c1 f9 03          	sar    $0x3,%rcx
  8011c2:	74 0c                	je     8011d0 <memset+0x45>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  8011c4:	fc                   	cld
  8011c5:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  8011c8:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  8011cc:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  8011d0:	4d 85 c9             	test   %r9,%r9
  8011d3:	75 45                	jne    80121a <memset+0x8f>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  8011d5:	4c 89 c0             	mov    %r8,%rax
  8011d8:	c3                   	ret
        while (n-- > 0) *ptr++ = c;
  8011d9:	48 85 d2             	test   %rdx,%rdx
  8011dc:	74 f7                	je     8011d5 <memset+0x4a>
  8011de:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  8011e1:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  8011e4:	48 83 c0 01          	add    $0x1,%rax
  8011e8:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  8011ec:	48 39 c2             	cmp    %rax,%rdx
  8011ef:	75 f3                	jne    8011e4 <memset+0x59>
  8011f1:	eb e2                	jmp    8011d5 <memset+0x4a>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  8011f3:	40 f6 c7 01          	test   $0x1,%dil
  8011f7:	74 06                	je     8011ff <memset+0x74>
  8011f9:	88 07                	mov    %al,(%rdi)
  8011fb:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  8011ff:	40 f6 c7 02          	test   $0x2,%dil
  801203:	74 07                	je     80120c <memset+0x81>
  801205:	66 89 07             	mov    %ax,(%rdi)
  801208:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  80120c:	40 f6 c7 04          	test   $0x4,%dil
  801210:	74 a9                	je     8011bb <memset+0x30>
  801212:	89 07                	mov    %eax,(%rdi)
  801214:	48 83 c7 04          	add    $0x4,%rdi
  801218:	eb a1                	jmp    8011bb <memset+0x30>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  80121a:	41 f6 c1 04          	test   $0x4,%r9b
  80121e:	74 1b                	je     80123b <memset+0xb0>
  801220:	89 07                	mov    %eax,(%rdi)
  801222:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  801226:	41 f6 c1 02          	test   $0x2,%r9b
  80122a:	74 07                	je     801233 <memset+0xa8>
  80122c:	66 89 07             	mov    %ax,(%rdi)
  80122f:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  801233:	41 f6 c1 01          	test   $0x1,%r9b
  801237:	74 9c                	je     8011d5 <memset+0x4a>
  801239:	eb 06                	jmp    801241 <memset+0xb6>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  80123b:	41 f6 c1 02          	test   $0x2,%r9b
  80123f:	75 eb                	jne    80122c <memset+0xa1>
        if (ni & 1) *ptr = k;
  801241:	88 07                	mov    %al,(%rdi)
  801243:	eb 90                	jmp    8011d5 <memset+0x4a>

0000000000801245 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  801245:	f3 0f 1e fa          	endbr64
  801249:	48 89 f8             	mov    %rdi,%rax
  80124c:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  80124f:	48 39 fe             	cmp    %rdi,%rsi
  801252:	73 3b                	jae    80128f <memmove+0x4a>
  801254:	48 8d 14 16          	lea    (%rsi,%rdx,1),%rdx
  801258:	48 39 d7             	cmp    %rdx,%rdi
  80125b:	73 32                	jae    80128f <memmove+0x4a>
        s += n;
        d += n;
  80125d:	48 8d 3c 0f          	lea    (%rdi,%rcx,1),%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  801261:	48 89 d6             	mov    %rdx,%rsi
  801264:	48 09 fe             	or     %rdi,%rsi
  801267:	48 09 ce             	or     %rcx,%rsi
  80126a:	40 f6 c6 07          	test   $0x7,%sil
  80126e:	75 12                	jne    801282 <memmove+0x3d>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  801270:	48 83 ef 08          	sub    $0x8,%rdi
  801274:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  801278:	48 c1 e9 03          	shr    $0x3,%rcx
  80127c:	fd                   	std
  80127d:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  801280:	fc                   	cld
  801281:	c3                   	ret
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  801282:	48 83 ef 01          	sub    $0x1,%rdi
  801286:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  80128a:	fd                   	std
  80128b:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  80128d:	eb f1                	jmp    801280 <memmove+0x3b>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  80128f:	48 89 f2             	mov    %rsi,%rdx
  801292:	48 09 c2             	or     %rax,%rdx
  801295:	48 09 ca             	or     %rcx,%rdx
  801298:	f6 c2 07             	test   $0x7,%dl
  80129b:	75 0c                	jne    8012a9 <memmove+0x64>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  80129d:	48 c1 e9 03          	shr    $0x3,%rcx
  8012a1:	48 89 c7             	mov    %rax,%rdi
  8012a4:	fc                   	cld
  8012a5:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  8012a8:	c3                   	ret
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  8012a9:	48 89 c7             	mov    %rax,%rdi
  8012ac:	fc                   	cld
  8012ad:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  8012af:	c3                   	ret

00000000008012b0 <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  8012b0:	f3 0f 1e fa          	endbr64
  8012b4:	55                   	push   %rbp
  8012b5:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  8012b8:	48 b8 45 12 80 00 00 	movabs $0x801245,%rax
  8012bf:	00 00 00 
  8012c2:	ff d0                	call   *%rax
}
  8012c4:	5d                   	pop    %rbp
  8012c5:	c3                   	ret

00000000008012c6 <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  8012c6:	f3 0f 1e fa          	endbr64
  8012ca:	55                   	push   %rbp
  8012cb:	48 89 e5             	mov    %rsp,%rbp
  8012ce:	41 57                	push   %r15
  8012d0:	41 56                	push   %r14
  8012d2:	41 55                	push   %r13
  8012d4:	41 54                	push   %r12
  8012d6:	53                   	push   %rbx
  8012d7:	48 83 ec 08          	sub    $0x8,%rsp
  8012db:	49 89 fe             	mov    %rdi,%r14
  8012de:	49 89 f7             	mov    %rsi,%r15
  8012e1:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  8012e4:	48 89 f7             	mov    %rsi,%rdi
  8012e7:	48 b8 e5 0f 80 00 00 	movabs $0x800fe5,%rax
  8012ee:	00 00 00 
  8012f1:	ff d0                	call   *%rax
  8012f3:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  8012f6:	48 89 de             	mov    %rbx,%rsi
  8012f9:	4c 89 f7             	mov    %r14,%rdi
  8012fc:	48 b8 04 10 80 00 00 	movabs $0x801004,%rax
  801303:	00 00 00 
  801306:	ff d0                	call   *%rax
  801308:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  80130b:	48 39 c3             	cmp    %rax,%rbx
  80130e:	74 36                	je     801346 <strlcat+0x80>
    if (srclen < maxlen - dstlen) {
  801310:	48 89 d8             	mov    %rbx,%rax
  801313:	4c 29 e8             	sub    %r13,%rax
  801316:	49 39 c4             	cmp    %rax,%r12
  801319:	73 31                	jae    80134c <strlcat+0x86>
        memcpy(dst + dstlen, src, srclen + 1);
  80131b:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  801320:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  801324:	4c 89 fe             	mov    %r15,%rsi
  801327:	48 b8 b0 12 80 00 00 	movabs $0x8012b0,%rax
  80132e:	00 00 00 
  801331:	ff d0                	call   *%rax
    return dstlen + srclen;
  801333:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  801337:	48 83 c4 08          	add    $0x8,%rsp
  80133b:	5b                   	pop    %rbx
  80133c:	41 5c                	pop    %r12
  80133e:	41 5d                	pop    %r13
  801340:	41 5e                	pop    %r14
  801342:	41 5f                	pop    %r15
  801344:	5d                   	pop    %rbp
  801345:	c3                   	ret
    if (dstlen == maxlen) return maxlen + srclen;
  801346:	49 8d 04 04          	lea    (%r12,%rax,1),%rax
  80134a:	eb eb                	jmp    801337 <strlcat+0x71>
        memcpy(dst + dstlen, src, maxlen - 1);
  80134c:	48 83 eb 01          	sub    $0x1,%rbx
  801350:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  801354:	48 89 da             	mov    %rbx,%rdx
  801357:	4c 89 fe             	mov    %r15,%rsi
  80135a:	48 b8 b0 12 80 00 00 	movabs $0x8012b0,%rax
  801361:	00 00 00 
  801364:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  801366:	49 01 de             	add    %rbx,%r14
  801369:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  80136e:	eb c3                	jmp    801333 <strlcat+0x6d>

0000000000801370 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  801370:	f3 0f 1e fa          	endbr64
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  801374:	48 85 d2             	test   %rdx,%rdx
  801377:	74 2d                	je     8013a6 <memcmp+0x36>
  801379:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  80137e:	0f b6 0c 07          	movzbl (%rdi,%rax,1),%ecx
  801382:	44 0f b6 04 06       	movzbl (%rsi,%rax,1),%r8d
  801387:	44 38 c1             	cmp    %r8b,%cl
  80138a:	75 0f                	jne    80139b <memcmp+0x2b>
    while (n-- > 0) {
  80138c:	48 83 c0 01          	add    $0x1,%rax
  801390:	48 39 c2             	cmp    %rax,%rdx
  801393:	75 e9                	jne    80137e <memcmp+0xe>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  801395:	b8 00 00 00 00       	mov    $0x0,%eax
  80139a:	c3                   	ret
            return (int)*s1 - (int)*s2;
  80139b:	0f b6 c1             	movzbl %cl,%eax
  80139e:	45 0f b6 c0          	movzbl %r8b,%r8d
  8013a2:	44 29 c0             	sub    %r8d,%eax
  8013a5:	c3                   	ret
    return 0;
  8013a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013ab:	c3                   	ret

00000000008013ac <memfind>:

void *
memfind(const void *src, int c, size_t n) {
  8013ac:	f3 0f 1e fa          	endbr64
    const void *end = (const char *)src + n;
  8013b0:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  8013b4:	48 39 c7             	cmp    %rax,%rdi
  8013b7:	73 0f                	jae    8013c8 <memfind+0x1c>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  8013b9:	40 38 37             	cmp    %sil,(%rdi)
  8013bc:	74 0e                	je     8013cc <memfind+0x20>
    for (; src < end; src++) {
  8013be:	48 83 c7 01          	add    $0x1,%rdi
  8013c2:	48 39 f8             	cmp    %rdi,%rax
  8013c5:	75 f2                	jne    8013b9 <memfind+0xd>
  8013c7:	c3                   	ret
  8013c8:	48 89 f8             	mov    %rdi,%rax
  8013cb:	c3                   	ret
  8013cc:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  8013cf:	c3                   	ret

00000000008013d0 <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  8013d0:	f3 0f 1e fa          	endbr64
  8013d4:	49 89 f2             	mov    %rsi,%r10
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  8013d7:	0f b6 37             	movzbl (%rdi),%esi
  8013da:	40 80 fe 20          	cmp    $0x20,%sil
  8013de:	74 06                	je     8013e6 <strtol+0x16>
  8013e0:	40 80 fe 09          	cmp    $0x9,%sil
  8013e4:	75 13                	jne    8013f9 <strtol+0x29>
  8013e6:	48 83 c7 01          	add    $0x1,%rdi
  8013ea:	0f b6 37             	movzbl (%rdi),%esi
  8013ed:	40 80 fe 20          	cmp    $0x20,%sil
  8013f1:	74 f3                	je     8013e6 <strtol+0x16>
  8013f3:	40 80 fe 09          	cmp    $0x9,%sil
  8013f7:	74 ed                	je     8013e6 <strtol+0x16>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  8013f9:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  8013fc:	83 e0 fd             	and    $0xfffffffd,%eax
  8013ff:	3c 01                	cmp    $0x1,%al
  801401:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  801405:	f7 c2 ef ff ff ff    	test   $0xffffffef,%edx
  80140b:	75 0f                	jne    80141c <strtol+0x4c>
  80140d:	80 3f 30             	cmpb   $0x30,(%rdi)
  801410:	74 14                	je     801426 <strtol+0x56>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  801412:	85 d2                	test   %edx,%edx
  801414:	b8 0a 00 00 00       	mov    $0xa,%eax
  801419:	0f 44 d0             	cmove  %eax,%edx
    }

    /* Digits */
    long val = 0;
  80141c:	b8 00 00 00 00       	mov    $0x0,%eax
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  801421:	4c 63 ca             	movslq %edx,%r9
  801424:	eb 36                	jmp    80145c <strtol+0x8c>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  801426:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  80142a:	74 0f                	je     80143b <strtol+0x6b>
    } else if (!base && s[0] == '0') {
  80142c:	85 d2                	test   %edx,%edx
  80142e:	75 ec                	jne    80141c <strtol+0x4c>
        s++;
  801430:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  801434:	ba 08 00 00 00       	mov    $0x8,%edx
        s++;
  801439:	eb e1                	jmp    80141c <strtol+0x4c>
        s += 2;
  80143b:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  80143f:	ba 10 00 00 00       	mov    $0x10,%edx
        s += 2;
  801444:	eb d6                	jmp    80141c <strtol+0x4c>
            dig -= '0';
  801446:	83 e9 30             	sub    $0x30,%ecx
        if (dig >= base) break;
  801449:	44 0f b6 c1          	movzbl %cl,%r8d
  80144d:	41 39 d0             	cmp    %edx,%r8d
  801450:	7d 21                	jge    801473 <strtol+0xa3>
        val = val * base + dig;
  801452:	49 0f af c1          	imul   %r9,%rax
  801456:	0f b6 c9             	movzbl %cl,%ecx
  801459:	48 01 c8             	add    %rcx,%rax
        uint8_t dig = *s++;
  80145c:	48 83 c7 01          	add    $0x1,%rdi
  801460:	0f b6 4f ff          	movzbl -0x1(%rdi),%ecx
        if (dig - '0' < 10)
  801464:	80 f9 39             	cmp    $0x39,%cl
  801467:	76 dd                	jbe    801446 <strtol+0x76>
        else if (dig - 'a' < 27)
  801469:	80 f9 7b             	cmp    $0x7b,%cl
  80146c:	77 05                	ja     801473 <strtol+0xa3>
            dig -= 'a' - 10;
  80146e:	83 e9 57             	sub    $0x57,%ecx
  801471:	eb d6                	jmp    801449 <strtol+0x79>
    }

    if (endptr) *endptr = (char *)s;
  801473:	4d 85 d2             	test   %r10,%r10
  801476:	74 03                	je     80147b <strtol+0xab>
  801478:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  80147b:	48 89 c2             	mov    %rax,%rdx
  80147e:	48 f7 da             	neg    %rdx
  801481:	40 80 fe 2d          	cmp    $0x2d,%sil
  801485:	48 0f 44 c2          	cmove  %rdx,%rax
}
  801489:	c3                   	ret

000000000080148a <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  80148a:	f3 0f 1e fa          	endbr64
  80148e:	55                   	push   %rbp
  80148f:	48 89 e5             	mov    %rsp,%rbp
  801492:	53                   	push   %rbx
  801493:	48 89 fa             	mov    %rdi,%rdx
  801496:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801499:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80149e:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014a3:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8014a8:	be 00 00 00 00       	mov    $0x0,%esi
  8014ad:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8014b3:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  8014b5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014b9:	c9                   	leave
  8014ba:	c3                   	ret

00000000008014bb <sys_cgetc>:

int
sys_cgetc(void) {
  8014bb:	f3 0f 1e fa          	endbr64
  8014bf:	55                   	push   %rbp
  8014c0:	48 89 e5             	mov    %rsp,%rbp
  8014c3:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8014c4:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8014c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8014ce:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8014d3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014d8:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8014dd:	be 00 00 00 00       	mov    $0x0,%esi
  8014e2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8014e8:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  8014ea:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014ee:	c9                   	leave
  8014ef:	c3                   	ret

00000000008014f0 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  8014f0:	f3 0f 1e fa          	endbr64
  8014f4:	55                   	push   %rbp
  8014f5:	48 89 e5             	mov    %rsp,%rbp
  8014f8:	53                   	push   %rbx
  8014f9:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  8014fd:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801500:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801505:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80150a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80150f:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801514:	be 00 00 00 00       	mov    $0x0,%esi
  801519:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80151f:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801521:	48 85 c0             	test   %rax,%rax
  801524:	7f 06                	jg     80152c <sys_env_destroy+0x3c>
}
  801526:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80152a:	c9                   	leave
  80152b:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80152c:	49 89 c0             	mov    %rax,%r8
  80152f:	b9 03 00 00 00       	mov    $0x3,%ecx
  801534:	48 ba 70 44 80 00 00 	movabs $0x804470,%rdx
  80153b:	00 00 00 
  80153e:	be 26 00 00 00       	mov    $0x26,%esi
  801543:	48 bf a1 42 80 00 00 	movabs $0x8042a1,%rdi
  80154a:	00 00 00 
  80154d:	b8 00 00 00 00       	mov    $0x0,%eax
  801552:	49 b9 85 05 80 00 00 	movabs $0x800585,%r9
  801559:	00 00 00 
  80155c:	41 ff d1             	call   *%r9

000000000080155f <sys_getenvid>:

envid_t
sys_getenvid(void) {
  80155f:	f3 0f 1e fa          	endbr64
  801563:	55                   	push   %rbp
  801564:	48 89 e5             	mov    %rsp,%rbp
  801567:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801568:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80156d:	ba 00 00 00 00       	mov    $0x0,%edx
  801572:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801577:	bb 00 00 00 00       	mov    $0x0,%ebx
  80157c:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801581:	be 00 00 00 00       	mov    $0x0,%esi
  801586:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80158c:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  80158e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801592:	c9                   	leave
  801593:	c3                   	ret

0000000000801594 <sys_yield>:

void
sys_yield(void) {
  801594:	f3 0f 1e fa          	endbr64
  801598:	55                   	push   %rbp
  801599:	48 89 e5             	mov    %rsp,%rbp
  80159c:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80159d:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8015a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8015a7:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8015ac:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015b1:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8015b6:	be 00 00 00 00       	mov    $0x0,%esi
  8015bb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8015c1:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  8015c3:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8015c7:	c9                   	leave
  8015c8:	c3                   	ret

00000000008015c9 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  8015c9:	f3 0f 1e fa          	endbr64
  8015cd:	55                   	push   %rbp
  8015ce:	48 89 e5             	mov    %rsp,%rbp
  8015d1:	53                   	push   %rbx
  8015d2:	48 89 fa             	mov    %rdi,%rdx
  8015d5:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8015d8:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8015dd:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  8015e4:	00 00 00 
  8015e7:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8015ec:	be 00 00 00 00       	mov    $0x0,%esi
  8015f1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8015f7:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  8015f9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8015fd:	c9                   	leave
  8015fe:	c3                   	ret

00000000008015ff <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  8015ff:	f3 0f 1e fa          	endbr64
  801603:	55                   	push   %rbp
  801604:	48 89 e5             	mov    %rsp,%rbp
  801607:	53                   	push   %rbx
  801608:	49 89 f8             	mov    %rdi,%r8
  80160b:	48 89 d3             	mov    %rdx,%rbx
  80160e:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  801611:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801616:	4c 89 c2             	mov    %r8,%rdx
  801619:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80161c:	be 00 00 00 00       	mov    $0x0,%esi
  801621:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801627:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  801629:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80162d:	c9                   	leave
  80162e:	c3                   	ret

000000000080162f <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  80162f:	f3 0f 1e fa          	endbr64
  801633:	55                   	push   %rbp
  801634:	48 89 e5             	mov    %rsp,%rbp
  801637:	53                   	push   %rbx
  801638:	48 83 ec 08          	sub    $0x8,%rsp
  80163c:	89 f8                	mov    %edi,%eax
  80163e:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  801641:	48 63 f9             	movslq %ecx,%rdi
  801644:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801647:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80164c:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80164f:	be 00 00 00 00       	mov    $0x0,%esi
  801654:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80165a:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80165c:	48 85 c0             	test   %rax,%rax
  80165f:	7f 06                	jg     801667 <sys_alloc_region+0x38>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  801661:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801665:	c9                   	leave
  801666:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801667:	49 89 c0             	mov    %rax,%r8
  80166a:	b9 04 00 00 00       	mov    $0x4,%ecx
  80166f:	48 ba 70 44 80 00 00 	movabs $0x804470,%rdx
  801676:	00 00 00 
  801679:	be 26 00 00 00       	mov    $0x26,%esi
  80167e:	48 bf a1 42 80 00 00 	movabs $0x8042a1,%rdi
  801685:	00 00 00 
  801688:	b8 00 00 00 00       	mov    $0x0,%eax
  80168d:	49 b9 85 05 80 00 00 	movabs $0x800585,%r9
  801694:	00 00 00 
  801697:	41 ff d1             	call   *%r9

000000000080169a <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  80169a:	f3 0f 1e fa          	endbr64
  80169e:	55                   	push   %rbp
  80169f:	48 89 e5             	mov    %rsp,%rbp
  8016a2:	53                   	push   %rbx
  8016a3:	48 83 ec 08          	sub    $0x8,%rsp
  8016a7:	89 f8                	mov    %edi,%eax
  8016a9:	49 89 f2             	mov    %rsi,%r10
  8016ac:	48 89 cf             	mov    %rcx,%rdi
  8016af:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  8016b2:	48 63 da             	movslq %edx,%rbx
  8016b5:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8016b8:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8016bd:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8016c0:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  8016c3:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8016c5:	48 85 c0             	test   %rax,%rax
  8016c8:	7f 06                	jg     8016d0 <sys_map_region+0x36>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  8016ca:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8016ce:	c9                   	leave
  8016cf:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8016d0:	49 89 c0             	mov    %rax,%r8
  8016d3:	b9 05 00 00 00       	mov    $0x5,%ecx
  8016d8:	48 ba 70 44 80 00 00 	movabs $0x804470,%rdx
  8016df:	00 00 00 
  8016e2:	be 26 00 00 00       	mov    $0x26,%esi
  8016e7:	48 bf a1 42 80 00 00 	movabs $0x8042a1,%rdi
  8016ee:	00 00 00 
  8016f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f6:	49 b9 85 05 80 00 00 	movabs $0x800585,%r9
  8016fd:	00 00 00 
  801700:	41 ff d1             	call   *%r9

0000000000801703 <sys_map_physical_region>:

int
sys_map_physical_region(uintptr_t pa, envid_t dstenv, void *dstva, size_t size, int perm) {
  801703:	f3 0f 1e fa          	endbr64
  801707:	55                   	push   %rbp
  801708:	48 89 e5             	mov    %rsp,%rbp
  80170b:	53                   	push   %rbx
  80170c:	48 83 ec 08          	sub    $0x8,%rsp
  801710:	49 89 f9             	mov    %rdi,%r9
  801713:	89 f0                	mov    %esi,%eax
  801715:	48 89 d3             	mov    %rdx,%rbx
  801718:	48 89 cf             	mov    %rcx,%rdi
    int res = syscall(SYS_map_physical_region, 1, pa, dstenv, (uintptr_t)dstva, size, perm, 0);
  80171b:	49 63 f0             	movslq %r8d,%rsi
  80171e:	48 63 c8             	movslq %eax,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801721:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801726:	4c 89 ca             	mov    %r9,%rdx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801729:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80172f:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801731:	48 85 c0             	test   %rax,%rax
  801734:	7f 06                	jg     80173c <sys_map_physical_region+0x39>
#ifdef SANITIZE_USER_SHADOW_BASE
    platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  801736:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80173a:	c9                   	leave
  80173b:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80173c:	49 89 c0             	mov    %rax,%r8
  80173f:	b9 06 00 00 00       	mov    $0x6,%ecx
  801744:	48 ba 70 44 80 00 00 	movabs $0x804470,%rdx
  80174b:	00 00 00 
  80174e:	be 26 00 00 00       	mov    $0x26,%esi
  801753:	48 bf a1 42 80 00 00 	movabs $0x8042a1,%rdi
  80175a:	00 00 00 
  80175d:	b8 00 00 00 00       	mov    $0x0,%eax
  801762:	49 b9 85 05 80 00 00 	movabs $0x800585,%r9
  801769:	00 00 00 
  80176c:	41 ff d1             	call   *%r9

000000000080176f <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  80176f:	f3 0f 1e fa          	endbr64
  801773:	55                   	push   %rbp
  801774:	48 89 e5             	mov    %rsp,%rbp
  801777:	53                   	push   %rbx
  801778:	48 83 ec 08          	sub    $0x8,%rsp
  80177c:	48 89 f1             	mov    %rsi,%rcx
  80177f:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  801782:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801785:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80178a:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80178f:	be 00 00 00 00       	mov    $0x0,%esi
  801794:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80179a:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80179c:	48 85 c0             	test   %rax,%rax
  80179f:	7f 06                	jg     8017a7 <sys_unmap_region+0x38>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  8017a1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8017a5:	c9                   	leave
  8017a6:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8017a7:	49 89 c0             	mov    %rax,%r8
  8017aa:	b9 07 00 00 00       	mov    $0x7,%ecx
  8017af:	48 ba 70 44 80 00 00 	movabs $0x804470,%rdx
  8017b6:	00 00 00 
  8017b9:	be 26 00 00 00       	mov    $0x26,%esi
  8017be:	48 bf a1 42 80 00 00 	movabs $0x8042a1,%rdi
  8017c5:	00 00 00 
  8017c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8017cd:	49 b9 85 05 80 00 00 	movabs $0x800585,%r9
  8017d4:	00 00 00 
  8017d7:	41 ff d1             	call   *%r9

00000000008017da <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  8017da:	f3 0f 1e fa          	endbr64
  8017de:	55                   	push   %rbp
  8017df:	48 89 e5             	mov    %rsp,%rbp
  8017e2:	53                   	push   %rbx
  8017e3:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  8017e7:	48 63 ce             	movslq %esi,%rcx
  8017ea:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8017ed:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8017f2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017f7:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8017fc:	be 00 00 00 00       	mov    $0x0,%esi
  801801:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801807:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801809:	48 85 c0             	test   %rax,%rax
  80180c:	7f 06                	jg     801814 <sys_env_set_status+0x3a>
}
  80180e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801812:	c9                   	leave
  801813:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801814:	49 89 c0             	mov    %rax,%r8
  801817:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80181c:	48 ba 70 44 80 00 00 	movabs $0x804470,%rdx
  801823:	00 00 00 
  801826:	be 26 00 00 00       	mov    $0x26,%esi
  80182b:	48 bf a1 42 80 00 00 	movabs $0x8042a1,%rdi
  801832:	00 00 00 
  801835:	b8 00 00 00 00       	mov    $0x0,%eax
  80183a:	49 b9 85 05 80 00 00 	movabs $0x800585,%r9
  801841:	00 00 00 
  801844:	41 ff d1             	call   *%r9

0000000000801847 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  801847:	f3 0f 1e fa          	endbr64
  80184b:	55                   	push   %rbp
  80184c:	48 89 e5             	mov    %rsp,%rbp
  80184f:	53                   	push   %rbx
  801850:	48 83 ec 08          	sub    $0x8,%rsp
  801854:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  801857:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80185a:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80185f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801864:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801869:	be 00 00 00 00       	mov    $0x0,%esi
  80186e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801874:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801876:	48 85 c0             	test   %rax,%rax
  801879:	7f 06                	jg     801881 <sys_env_set_trapframe+0x3a>
}
  80187b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80187f:	c9                   	leave
  801880:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801881:	49 89 c0             	mov    %rax,%r8
  801884:	b9 0b 00 00 00       	mov    $0xb,%ecx
  801889:	48 ba 70 44 80 00 00 	movabs $0x804470,%rdx
  801890:	00 00 00 
  801893:	be 26 00 00 00       	mov    $0x26,%esi
  801898:	48 bf a1 42 80 00 00 	movabs $0x8042a1,%rdi
  80189f:	00 00 00 
  8018a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8018a7:	49 b9 85 05 80 00 00 	movabs $0x800585,%r9
  8018ae:	00 00 00 
  8018b1:	41 ff d1             	call   *%r9

00000000008018b4 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  8018b4:	f3 0f 1e fa          	endbr64
  8018b8:	55                   	push   %rbp
  8018b9:	48 89 e5             	mov    %rsp,%rbp
  8018bc:	53                   	push   %rbx
  8018bd:	48 83 ec 08          	sub    $0x8,%rsp
  8018c1:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  8018c4:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8018c7:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8018cc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018d1:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8018d6:	be 00 00 00 00       	mov    $0x0,%esi
  8018db:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8018e1:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8018e3:	48 85 c0             	test   %rax,%rax
  8018e6:	7f 06                	jg     8018ee <sys_env_set_pgfault_upcall+0x3a>
}
  8018e8:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8018ec:	c9                   	leave
  8018ed:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8018ee:	49 89 c0             	mov    %rax,%r8
  8018f1:	b9 0c 00 00 00       	mov    $0xc,%ecx
  8018f6:	48 ba 70 44 80 00 00 	movabs $0x804470,%rdx
  8018fd:	00 00 00 
  801900:	be 26 00 00 00       	mov    $0x26,%esi
  801905:	48 bf a1 42 80 00 00 	movabs $0x8042a1,%rdi
  80190c:	00 00 00 
  80190f:	b8 00 00 00 00       	mov    $0x0,%eax
  801914:	49 b9 85 05 80 00 00 	movabs $0x800585,%r9
  80191b:	00 00 00 
  80191e:	41 ff d1             	call   *%r9

0000000000801921 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  801921:	f3 0f 1e fa          	endbr64
  801925:	55                   	push   %rbp
  801926:	48 89 e5             	mov    %rsp,%rbp
  801929:	53                   	push   %rbx
  80192a:	89 f8                	mov    %edi,%eax
  80192c:	49 89 f1             	mov    %rsi,%r9
  80192f:	48 89 d3             	mov    %rdx,%rbx
  801932:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  801935:	49 63 f0             	movslq %r8d,%rsi
  801938:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80193b:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801940:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801943:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801949:	cd 30                	int    $0x30
}
  80194b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80194f:	c9                   	leave
  801950:	c3                   	ret

0000000000801951 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  801951:	f3 0f 1e fa          	endbr64
  801955:	55                   	push   %rbp
  801956:	48 89 e5             	mov    %rsp,%rbp
  801959:	53                   	push   %rbx
  80195a:	48 83 ec 08          	sub    $0x8,%rsp
  80195e:	48 89 fa             	mov    %rdi,%rdx
  801961:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801964:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801969:	bb 00 00 00 00       	mov    $0x0,%ebx
  80196e:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801973:	be 00 00 00 00       	mov    $0x0,%esi
  801978:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80197e:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801980:	48 85 c0             	test   %rax,%rax
  801983:	7f 06                	jg     80198b <sys_ipc_recv+0x3a>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  801985:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801989:	c9                   	leave
  80198a:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80198b:	49 89 c0             	mov    %rax,%r8
  80198e:	b9 0f 00 00 00       	mov    $0xf,%ecx
  801993:	48 ba 70 44 80 00 00 	movabs $0x804470,%rdx
  80199a:	00 00 00 
  80199d:	be 26 00 00 00       	mov    $0x26,%esi
  8019a2:	48 bf a1 42 80 00 00 	movabs $0x8042a1,%rdi
  8019a9:	00 00 00 
  8019ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8019b1:	49 b9 85 05 80 00 00 	movabs $0x800585,%r9
  8019b8:	00 00 00 
  8019bb:	41 ff d1             	call   *%r9

00000000008019be <sys_gettime>:

int
sys_gettime(void) {
  8019be:	f3 0f 1e fa          	endbr64
  8019c2:	55                   	push   %rbp
  8019c3:	48 89 e5             	mov    %rsp,%rbp
  8019c6:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8019c7:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8019cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8019d1:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8019d6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019db:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8019e0:	be 00 00 00 00       	mov    $0x0,%esi
  8019e5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8019eb:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  8019ed:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8019f1:	c9                   	leave
  8019f2:	c3                   	ret

00000000008019f3 <fork>:
 *   Use sys_map_region, it can perform address space copying in one call
 *   Don't forget to set page fault handler in the child (using sys_env_set_pgfault_upcall()).
 *   Remember to fix "thisenv" in the child process.
 */
envid_t
fork(void) {
  8019f3:	f3 0f 1e fa          	endbr64
  8019f7:	55                   	push   %rbp
  8019f8:	48 89 e5             	mov    %rsp,%rbp
  8019fb:	41 56                	push   %r14
  8019fd:	41 55                	push   %r13
  8019ff:	41 54                	push   %r12
  801a01:	53                   	push   %rbx
    // LAB 9: Your code here.
    bool has_pgfault_upcall = thisenv->env_pgfault_upcall;
  801a02:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801a09:	00 00 00 
  801a0c:	4c 8b b0 00 01 00 00 	mov    0x100(%rax),%r14

/* This must be inlined. Exercise for reader: why? */
static inline envid_t __attribute__((always_inline))
sys_exofork(void) {
    envid_t ret;
    asm volatile("int %2"
  801a13:	b8 09 00 00 00       	mov    $0x9,%eax
  801a18:	cd 30                	int    $0x30
  801a1a:	41 89 c4             	mov    %eax,%r12d

    envid_t envid = sys_exofork();
    if (envid < 0) {
  801a1d:	85 c0                	test   %eax,%eax
  801a1f:	78 7f                	js     801aa0 <fork+0xad>
  801a21:	89 c3                	mov    %eax,%ebx
        return envid;
    }
    if (envid == 0) {
  801a23:	0f 84 83 00 00 00    	je     801aac <fork+0xb9>
        thisenv = &envs[ENVX(sys_getenvid())];
        return 0;
    }
    int res = sys_map_region(CURENVID, NULL, envid, NULL, MAX_USER_ADDRESS, PROT_ALL | PROT_LAZY | PROT_COMBINE);
  801a29:	41 b9 ff 0f 00 00    	mov    $0xfff,%r9d
  801a2f:	49 b8 00 00 00 00 80 	movabs $0x8000000000,%r8
  801a36:	00 00 00 
  801a39:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a3e:	89 c2                	mov    %eax,%edx
  801a40:	be 00 00 00 00       	mov    $0x0,%esi
  801a45:	bf 00 00 00 00       	mov    $0x0,%edi
  801a4a:	48 b8 9a 16 80 00 00 	movabs $0x80169a,%rax
  801a51:	00 00 00 
  801a54:	ff d0                	call   *%rax
  801a56:	41 89 c5             	mov    %eax,%r13d
    if (res < 0) {
  801a59:	85 c0                	test   %eax,%eax
  801a5b:	0f 88 81 00 00 00    	js     801ae2 <fork+0xef>
        sys_env_destroy(envid);
        return res;
    }
    if (has_pgfault_upcall) {
  801a61:	4d 85 f6             	test   %r14,%r14
  801a64:	74 20                	je     801a86 <fork+0x93>
        res = sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  801a66:	48 be 7d 31 80 00 00 	movabs $0x80317d,%rsi
  801a6d:	00 00 00 
  801a70:	44 89 e7             	mov    %r12d,%edi
  801a73:	48 b8 b4 18 80 00 00 	movabs $0x8018b4,%rax
  801a7a:	00 00 00 
  801a7d:	ff d0                	call   *%rax
  801a7f:	41 89 c5             	mov    %eax,%r13d
        if (res < 0) {
  801a82:	85 c0                	test   %eax,%eax
  801a84:	78 70                	js     801af6 <fork+0x103>
            sys_env_destroy(envid);
            return res;
        }
    }
    res = sys_env_set_status(envid, ENV_RUNNABLE);
  801a86:	be 02 00 00 00       	mov    $0x2,%esi
  801a8b:	89 df                	mov    %ebx,%edi
  801a8d:	48 b8 da 17 80 00 00 	movabs $0x8017da,%rax
  801a94:	00 00 00 
  801a97:	ff d0                	call   *%rax
  801a99:	41 89 c5             	mov    %eax,%r13d
    if (res < 0) {
  801a9c:	85 c0                	test   %eax,%eax
  801a9e:	78 6a                	js     801b0a <fork+0x117>
        sys_env_destroy(envid);
        return res;
    }
    return envid;
}
  801aa0:	44 89 e0             	mov    %r12d,%eax
  801aa3:	5b                   	pop    %rbx
  801aa4:	41 5c                	pop    %r12
  801aa6:	41 5d                	pop    %r13
  801aa8:	41 5e                	pop    %r14
  801aaa:	5d                   	pop    %rbp
  801aab:	c3                   	ret
        thisenv = &envs[ENVX(sys_getenvid())];
  801aac:	48 b8 5f 15 80 00 00 	movabs $0x80155f,%rax
  801ab3:	00 00 00 
  801ab6:	ff d0                	call   *%rax
  801ab8:	25 ff 03 00 00       	and    $0x3ff,%eax
  801abd:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  801ac1:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  801ac5:	48 c1 e0 04          	shl    $0x4,%rax
  801ac9:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  801ad0:	00 00 00 
  801ad3:	48 01 d0             	add    %rdx,%rax
  801ad6:	48 a3 00 60 80 00 00 	movabs %rax,0x806000
  801add:	00 00 00 
        return 0;
  801ae0:	eb be                	jmp    801aa0 <fork+0xad>
        sys_env_destroy(envid);
  801ae2:	44 89 e7             	mov    %r12d,%edi
  801ae5:	48 b8 f0 14 80 00 00 	movabs $0x8014f0,%rax
  801aec:	00 00 00 
  801aef:	ff d0                	call   *%rax
        return res;
  801af1:	45 89 ec             	mov    %r13d,%r12d
  801af4:	eb aa                	jmp    801aa0 <fork+0xad>
            sys_env_destroy(envid);
  801af6:	44 89 e7             	mov    %r12d,%edi
  801af9:	48 b8 f0 14 80 00 00 	movabs $0x8014f0,%rax
  801b00:	00 00 00 
  801b03:	ff d0                	call   *%rax
            return res;
  801b05:	45 89 ec             	mov    %r13d,%r12d
  801b08:	eb 96                	jmp    801aa0 <fork+0xad>
        sys_env_destroy(envid);
  801b0a:	89 df                	mov    %ebx,%edi
  801b0c:	48 b8 f0 14 80 00 00 	movabs $0x8014f0,%rax
  801b13:	00 00 00 
  801b16:	ff d0                	call   *%rax
        return res;
  801b18:	45 89 ec             	mov    %r13d,%r12d
  801b1b:	eb 83                	jmp    801aa0 <fork+0xad>

0000000000801b1d <sfork>:

envid_t
sfork() {
  801b1d:	f3 0f 1e fa          	endbr64
  801b21:	55                   	push   %rbp
  801b22:	48 89 e5             	mov    %rsp,%rbp
    panic("sfork() is not implemented");
  801b25:	48 ba af 42 80 00 00 	movabs $0x8042af,%rdx
  801b2c:	00 00 00 
  801b2f:	be 37 00 00 00       	mov    $0x37,%esi
  801b34:	48 bf ca 42 80 00 00 	movabs $0x8042ca,%rdi
  801b3b:	00 00 00 
  801b3e:	b8 00 00 00 00       	mov    $0x0,%eax
  801b43:	48 b9 85 05 80 00 00 	movabs $0x800585,%rcx
  801b4a:	00 00 00 
  801b4d:	ff d1                	call   *%rcx

0000000000801b4f <fd2num>:


/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
  801b4f:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801b53:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801b5a:	ff ff ff 
  801b5d:	48 01 f8             	add    %rdi,%rax
  801b60:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801b64:	c3                   	ret

0000000000801b65 <fd2data>:

char *
fd2data(struct Fd *fd) {
  801b65:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801b69:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801b70:	ff ff ff 
  801b73:	48 01 f8             	add    %rdi,%rax
  801b76:	48 c1 e8 0c          	shr    $0xc,%rax
    return INDEX2DATA(fd2num(fd));
  801b7a:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801b80:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801b84:	c3                   	ret

0000000000801b85 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  801b85:	f3 0f 1e fa          	endbr64
  801b89:	55                   	push   %rbp
  801b8a:	48 89 e5             	mov    %rsp,%rbp
  801b8d:	41 57                	push   %r15
  801b8f:	41 56                	push   %r14
  801b91:	41 55                	push   %r13
  801b93:	41 54                	push   %r12
  801b95:	53                   	push   %rbx
  801b96:	48 83 ec 08          	sub    $0x8,%rsp
  801b9a:	49 89 ff             	mov    %rdi,%r15
  801b9d:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  801ba2:	49 bd ab 2d 80 00 00 	movabs $0x802dab,%r13
  801ba9:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  801bac:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        struct Fd *fd = INDEX2FD(i);
  801bb2:	49 89 dc             	mov    %rbx,%r12
        if (!(get_prot(fd) & PROT_R)) {
  801bb5:	48 89 df             	mov    %rbx,%rdi
  801bb8:	41 ff d5             	call   *%r13
  801bbb:	83 e0 04             	and    $0x4,%eax
  801bbe:	74 17                	je     801bd7 <fd_alloc+0x52>
    for (int i = 0; i < MAXFD; i++) {
  801bc0:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  801bc7:	4c 39 f3             	cmp    %r14,%rbx
  801bca:	75 e6                	jne    801bb2 <fd_alloc+0x2d>
  801bcc:	41 bc 00 00 00 00    	mov    $0x0,%r12d
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
    return -E_MAX_OPEN;
  801bd2:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
            *fd_store = fd;
  801bd7:	4d 89 27             	mov    %r12,(%r15)
}
  801bda:	48 83 c4 08          	add    $0x8,%rsp
  801bde:	5b                   	pop    %rbx
  801bdf:	41 5c                	pop    %r12
  801be1:	41 5d                	pop    %r13
  801be3:	41 5e                	pop    %r14
  801be5:	41 5f                	pop    %r15
  801be7:	5d                   	pop    %rbp
  801be8:	c3                   	ret

0000000000801be9 <fd_lookup>:
 *
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
  801be9:	f3 0f 1e fa          	endbr64
    if (fdnum < 0 || fdnum >= MAXFD) {
  801bed:	83 ff 1f             	cmp    $0x1f,%edi
  801bf0:	77 39                	ja     801c2b <fd_lookup+0x42>
fd_lookup(int fdnum, struct Fd **fd_store) {
  801bf2:	55                   	push   %rbp
  801bf3:	48 89 e5             	mov    %rsp,%rbp
  801bf6:	41 54                	push   %r12
  801bf8:	53                   	push   %rbx
  801bf9:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  801bfc:	48 63 df             	movslq %edi,%rbx
  801bff:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  801c06:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  801c0a:	48 89 df             	mov    %rbx,%rdi
  801c0d:	48 b8 ab 2d 80 00 00 	movabs $0x802dab,%rax
  801c14:	00 00 00 
  801c17:	ff d0                	call   *%rax
  801c19:	a8 04                	test   $0x4,%al
  801c1b:	74 14                	je     801c31 <fd_lookup+0x48>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  801c1d:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  801c21:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c26:	5b                   	pop    %rbx
  801c27:	41 5c                	pop    %r12
  801c29:	5d                   	pop    %rbp
  801c2a:	c3                   	ret
        return -E_INVAL;
  801c2b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801c30:	c3                   	ret
        return -E_INVAL;
  801c31:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c36:	eb ee                	jmp    801c26 <fd_lookup+0x3d>

0000000000801c38 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  801c38:	f3 0f 1e fa          	endbr64
  801c3c:	55                   	push   %rbp
  801c3d:	48 89 e5             	mov    %rsp,%rbp
  801c40:	41 54                	push   %r12
  801c42:	53                   	push   %rbx
  801c43:	49 89 f4             	mov    %rsi,%r12
    for (size_t i = 0; devtab[i]; i++) {
  801c46:	48 b8 a0 48 80 00 00 	movabs $0x8048a0,%rax
  801c4d:	00 00 00 
  801c50:	48 bb 20 50 80 00 00 	movabs $0x805020,%rbx
  801c57:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  801c5a:	39 3b                	cmp    %edi,(%rbx)
  801c5c:	74 47                	je     801ca5 <dev_lookup+0x6d>
    for (size_t i = 0; devtab[i]; i++) {
  801c5e:	48 83 c0 08          	add    $0x8,%rax
  801c62:	48 8b 18             	mov    (%rax),%rbx
  801c65:	48 85 db             	test   %rbx,%rbx
  801c68:	75 f0                	jne    801c5a <dev_lookup+0x22>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801c6a:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801c71:	00 00 00 
  801c74:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801c7a:	89 fa                	mov    %edi,%edx
  801c7c:	48 bf 90 44 80 00 00 	movabs $0x804490,%rdi
  801c83:	00 00 00 
  801c86:	b8 00 00 00 00       	mov    $0x0,%eax
  801c8b:	48 b9 e1 06 80 00 00 	movabs $0x8006e1,%rcx
  801c92:	00 00 00 
  801c95:	ff d1                	call   *%rcx
    *dev = 0;
    return -E_INVAL;
  801c97:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
            *dev = devtab[i];
  801c9c:	49 89 1c 24          	mov    %rbx,(%r12)
}
  801ca0:	5b                   	pop    %rbx
  801ca1:	41 5c                	pop    %r12
  801ca3:	5d                   	pop    %rbp
  801ca4:	c3                   	ret
            return 0;
  801ca5:	b8 00 00 00 00       	mov    $0x0,%eax
  801caa:	eb f0                	jmp    801c9c <dev_lookup+0x64>

0000000000801cac <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  801cac:	f3 0f 1e fa          	endbr64
  801cb0:	55                   	push   %rbp
  801cb1:	48 89 e5             	mov    %rsp,%rbp
  801cb4:	41 55                	push   %r13
  801cb6:	41 54                	push   %r12
  801cb8:	53                   	push   %rbx
  801cb9:	48 83 ec 18          	sub    $0x18,%rsp
  801cbd:	48 89 fb             	mov    %rdi,%rbx
  801cc0:	41 89 f4             	mov    %esi,%r12d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801cc3:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  801cca:	ff ff ff 
  801ccd:	48 01 df             	add    %rbx,%rdi
  801cd0:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  801cd4:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801cd8:	48 b8 e9 1b 80 00 00 	movabs $0x801be9,%rax
  801cdf:	00 00 00 
  801ce2:	ff d0                	call   *%rax
  801ce4:	41 89 c5             	mov    %eax,%r13d
  801ce7:	85 c0                	test   %eax,%eax
  801ce9:	78 06                	js     801cf1 <fd_close+0x45>
  801ceb:	48 39 5d d8          	cmp    %rbx,-0x28(%rbp)
  801cef:	74 1a                	je     801d0b <fd_close+0x5f>
        return (must_exist ? res : 0);
  801cf1:	45 84 e4             	test   %r12b,%r12b
  801cf4:	b8 00 00 00 00       	mov    $0x0,%eax
  801cf9:	44 0f 44 e8          	cmove  %eax,%r13d
}
  801cfd:	44 89 e8             	mov    %r13d,%eax
  801d00:	48 83 c4 18          	add    $0x18,%rsp
  801d04:	5b                   	pop    %rbx
  801d05:	41 5c                	pop    %r12
  801d07:	41 5d                	pop    %r13
  801d09:	5d                   	pop    %rbp
  801d0a:	c3                   	ret
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801d0b:	8b 3b                	mov    (%rbx),%edi
  801d0d:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801d11:	48 b8 38 1c 80 00 00 	movabs $0x801c38,%rax
  801d18:	00 00 00 
  801d1b:	ff d0                	call   *%rax
  801d1d:	41 89 c5             	mov    %eax,%r13d
  801d20:	85 c0                	test   %eax,%eax
  801d22:	78 1b                	js     801d3f <fd_close+0x93>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  801d24:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d28:	48 8b 40 20          	mov    0x20(%rax),%rax
  801d2c:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  801d32:	48 85 c0             	test   %rax,%rax
  801d35:	74 08                	je     801d3f <fd_close+0x93>
  801d37:	48 89 df             	mov    %rbx,%rdi
  801d3a:	ff d0                	call   *%rax
  801d3c:	41 89 c5             	mov    %eax,%r13d
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801d3f:	ba 00 10 00 00       	mov    $0x1000,%edx
  801d44:	48 89 de             	mov    %rbx,%rsi
  801d47:	bf 00 00 00 00       	mov    $0x0,%edi
  801d4c:	48 b8 6f 17 80 00 00 	movabs $0x80176f,%rax
  801d53:	00 00 00 
  801d56:	ff d0                	call   *%rax
    return res;
  801d58:	eb a3                	jmp    801cfd <fd_close+0x51>

0000000000801d5a <close>:

int
close(int fdnum) {
  801d5a:	f3 0f 1e fa          	endbr64
  801d5e:	55                   	push   %rbp
  801d5f:	48 89 e5             	mov    %rsp,%rbp
  801d62:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  801d66:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801d6a:	48 b8 e9 1b 80 00 00 	movabs $0x801be9,%rax
  801d71:	00 00 00 
  801d74:	ff d0                	call   *%rax
    if (res < 0) return res;
  801d76:	85 c0                	test   %eax,%eax
  801d78:	78 15                	js     801d8f <close+0x35>

    return fd_close(fd, 1);
  801d7a:	be 01 00 00 00       	mov    $0x1,%esi
  801d7f:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801d83:	48 b8 ac 1c 80 00 00 	movabs $0x801cac,%rax
  801d8a:	00 00 00 
  801d8d:	ff d0                	call   *%rax
}
  801d8f:	c9                   	leave
  801d90:	c3                   	ret

0000000000801d91 <close_all>:

void
close_all(void) {
  801d91:	f3 0f 1e fa          	endbr64
  801d95:	55                   	push   %rbp
  801d96:	48 89 e5             	mov    %rsp,%rbp
  801d99:	41 54                	push   %r12
  801d9b:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  801d9c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801da1:	49 bc 5a 1d 80 00 00 	movabs $0x801d5a,%r12
  801da8:	00 00 00 
  801dab:	89 df                	mov    %ebx,%edi
  801dad:	41 ff d4             	call   *%r12
  801db0:	83 c3 01             	add    $0x1,%ebx
  801db3:	83 fb 20             	cmp    $0x20,%ebx
  801db6:	75 f3                	jne    801dab <close_all+0x1a>
}
  801db8:	5b                   	pop    %rbx
  801db9:	41 5c                	pop    %r12
  801dbb:	5d                   	pop    %rbp
  801dbc:	c3                   	ret

0000000000801dbd <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  801dbd:	f3 0f 1e fa          	endbr64
  801dc1:	55                   	push   %rbp
  801dc2:	48 89 e5             	mov    %rsp,%rbp
  801dc5:	41 57                	push   %r15
  801dc7:	41 56                	push   %r14
  801dc9:	41 55                	push   %r13
  801dcb:	41 54                	push   %r12
  801dcd:	53                   	push   %rbx
  801dce:	48 83 ec 18          	sub    $0x18,%rsp
  801dd2:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  801dd5:	48 8d 75 c8          	lea    -0x38(%rbp),%rsi
  801dd9:	48 b8 e9 1b 80 00 00 	movabs $0x801be9,%rax
  801de0:	00 00 00 
  801de3:	ff d0                	call   *%rax
  801de5:	89 c3                	mov    %eax,%ebx
  801de7:	85 c0                	test   %eax,%eax
  801de9:	0f 88 b8 00 00 00    	js     801ea7 <dup+0xea>
    close(newfdnum);
  801def:	44 89 e7             	mov    %r12d,%edi
  801df2:	48 b8 5a 1d 80 00 00 	movabs $0x801d5a,%rax
  801df9:	00 00 00 
  801dfc:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  801dfe:	4d 63 ec             	movslq %r12d,%r13
  801e01:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  801e08:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  801e0c:	4c 8b 7d c8          	mov    -0x38(%rbp),%r15
  801e10:	4c 89 ff             	mov    %r15,%rdi
  801e13:	49 be 65 1b 80 00 00 	movabs $0x801b65,%r14
  801e1a:	00 00 00 
  801e1d:	41 ff d6             	call   *%r14
  801e20:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  801e23:	4c 89 ef             	mov    %r13,%rdi
  801e26:	41 ff d6             	call   *%r14
  801e29:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  801e2c:	48 89 df             	mov    %rbx,%rdi
  801e2f:	48 b8 ab 2d 80 00 00 	movabs $0x802dab,%rax
  801e36:	00 00 00 
  801e39:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  801e3b:	a8 04                	test   $0x4,%al
  801e3d:	74 2b                	je     801e6a <dup+0xad>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  801e3f:	41 89 c1             	mov    %eax,%r9d
  801e42:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801e48:	4c 89 f1             	mov    %r14,%rcx
  801e4b:	ba 00 00 00 00       	mov    $0x0,%edx
  801e50:	48 89 de             	mov    %rbx,%rsi
  801e53:	bf 00 00 00 00       	mov    $0x0,%edi
  801e58:	48 b8 9a 16 80 00 00 	movabs $0x80169a,%rax
  801e5f:	00 00 00 
  801e62:	ff d0                	call   *%rax
  801e64:	89 c3                	mov    %eax,%ebx
  801e66:	85 c0                	test   %eax,%eax
  801e68:	78 4e                	js     801eb8 <dup+0xfb>
    }
    prot = get_prot(oldfd);
  801e6a:	4c 89 ff             	mov    %r15,%rdi
  801e6d:	48 b8 ab 2d 80 00 00 	movabs $0x802dab,%rax
  801e74:	00 00 00 
  801e77:	ff d0                	call   *%rax
  801e79:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  801e7c:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801e82:	4c 89 e9             	mov    %r13,%rcx
  801e85:	ba 00 00 00 00       	mov    $0x0,%edx
  801e8a:	4c 89 fe             	mov    %r15,%rsi
  801e8d:	bf 00 00 00 00       	mov    $0x0,%edi
  801e92:	48 b8 9a 16 80 00 00 	movabs $0x80169a,%rax
  801e99:	00 00 00 
  801e9c:	ff d0                	call   *%rax
  801e9e:	89 c3                	mov    %eax,%ebx
  801ea0:	85 c0                	test   %eax,%eax
  801ea2:	78 14                	js     801eb8 <dup+0xfb>

    return newfdnum;
  801ea4:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  801ea7:	89 d8                	mov    %ebx,%eax
  801ea9:	48 83 c4 18          	add    $0x18,%rsp
  801ead:	5b                   	pop    %rbx
  801eae:	41 5c                	pop    %r12
  801eb0:	41 5d                	pop    %r13
  801eb2:	41 5e                	pop    %r14
  801eb4:	41 5f                	pop    %r15
  801eb6:	5d                   	pop    %rbp
  801eb7:	c3                   	ret
    sys_unmap_region(0, newfd, PAGE_SIZE);
  801eb8:	ba 00 10 00 00       	mov    $0x1000,%edx
  801ebd:	4c 89 ee             	mov    %r13,%rsi
  801ec0:	bf 00 00 00 00       	mov    $0x0,%edi
  801ec5:	49 bc 6f 17 80 00 00 	movabs $0x80176f,%r12
  801ecc:	00 00 00 
  801ecf:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  801ed2:	ba 00 10 00 00       	mov    $0x1000,%edx
  801ed7:	4c 89 f6             	mov    %r14,%rsi
  801eda:	bf 00 00 00 00       	mov    $0x0,%edi
  801edf:	41 ff d4             	call   *%r12
    return res;
  801ee2:	eb c3                	jmp    801ea7 <dup+0xea>

0000000000801ee4 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  801ee4:	f3 0f 1e fa          	endbr64
  801ee8:	55                   	push   %rbp
  801ee9:	48 89 e5             	mov    %rsp,%rbp
  801eec:	41 56                	push   %r14
  801eee:	41 55                	push   %r13
  801ef0:	41 54                	push   %r12
  801ef2:	53                   	push   %rbx
  801ef3:	48 83 ec 10          	sub    $0x10,%rsp
  801ef7:	89 fb                	mov    %edi,%ebx
  801ef9:	49 89 f4             	mov    %rsi,%r12
  801efc:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801eff:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801f03:	48 b8 e9 1b 80 00 00 	movabs $0x801be9,%rax
  801f0a:	00 00 00 
  801f0d:	ff d0                	call   *%rax
  801f0f:	85 c0                	test   %eax,%eax
  801f11:	78 4c                	js     801f5f <read+0x7b>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801f13:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801f17:	41 8b 3e             	mov    (%r14),%edi
  801f1a:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801f1e:	48 b8 38 1c 80 00 00 	movabs $0x801c38,%rax
  801f25:	00 00 00 
  801f28:	ff d0                	call   *%rax
  801f2a:	85 c0                	test   %eax,%eax
  801f2c:	78 35                	js     801f63 <read+0x7f>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801f2e:	41 8b 46 08          	mov    0x8(%r14),%eax
  801f32:	83 e0 03             	and    $0x3,%eax
  801f35:	83 f8 01             	cmp    $0x1,%eax
  801f38:	74 2d                	je     801f67 <read+0x83>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  801f3a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801f3e:	48 8b 40 10          	mov    0x10(%rax),%rax
  801f42:	48 85 c0             	test   %rax,%rax
  801f45:	74 56                	je     801f9d <read+0xb9>

    return (*dev->dev_read)(fd, buf, n);
  801f47:	4c 89 ea             	mov    %r13,%rdx
  801f4a:	4c 89 e6             	mov    %r12,%rsi
  801f4d:	4c 89 f7             	mov    %r14,%rdi
  801f50:	ff d0                	call   *%rax
}
  801f52:	48 83 c4 10          	add    $0x10,%rsp
  801f56:	5b                   	pop    %rbx
  801f57:	41 5c                	pop    %r12
  801f59:	41 5d                	pop    %r13
  801f5b:	41 5e                	pop    %r14
  801f5d:	5d                   	pop    %rbp
  801f5e:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801f5f:	48 98                	cltq
  801f61:	eb ef                	jmp    801f52 <read+0x6e>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801f63:	48 98                	cltq
  801f65:	eb eb                	jmp    801f52 <read+0x6e>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801f67:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801f6e:	00 00 00 
  801f71:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801f77:	89 da                	mov    %ebx,%edx
  801f79:	48 bf d5 42 80 00 00 	movabs $0x8042d5,%rdi
  801f80:	00 00 00 
  801f83:	b8 00 00 00 00       	mov    $0x0,%eax
  801f88:	48 b9 e1 06 80 00 00 	movabs $0x8006e1,%rcx
  801f8f:	00 00 00 
  801f92:	ff d1                	call   *%rcx
        return -E_INVAL;
  801f94:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801f9b:	eb b5                	jmp    801f52 <read+0x6e>
    if (!dev->dev_read) return -E_NOT_SUPP;
  801f9d:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801fa4:	eb ac                	jmp    801f52 <read+0x6e>

0000000000801fa6 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801fa6:	f3 0f 1e fa          	endbr64
  801faa:	55                   	push   %rbp
  801fab:	48 89 e5             	mov    %rsp,%rbp
  801fae:	41 57                	push   %r15
  801fb0:	41 56                	push   %r14
  801fb2:	41 55                	push   %r13
  801fb4:	41 54                	push   %r12
  801fb6:	53                   	push   %rbx
  801fb7:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801fbb:	48 85 d2             	test   %rdx,%rdx
  801fbe:	74 54                	je     802014 <readn+0x6e>
  801fc0:	41 89 fd             	mov    %edi,%r13d
  801fc3:	49 89 f6             	mov    %rsi,%r14
  801fc6:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801fc9:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801fce:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801fd3:	49 bf e4 1e 80 00 00 	movabs $0x801ee4,%r15
  801fda:	00 00 00 
  801fdd:	4c 89 e2             	mov    %r12,%rdx
  801fe0:	48 29 f2             	sub    %rsi,%rdx
  801fe3:	4c 01 f6             	add    %r14,%rsi
  801fe6:	44 89 ef             	mov    %r13d,%edi
  801fe9:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  801fec:	85 c0                	test   %eax,%eax
  801fee:	78 20                	js     802010 <readn+0x6a>
    for (; inc && res < n; res += inc) {
  801ff0:	01 c3                	add    %eax,%ebx
  801ff2:	85 c0                	test   %eax,%eax
  801ff4:	74 08                	je     801ffe <readn+0x58>
  801ff6:	48 63 f3             	movslq %ebx,%rsi
  801ff9:	4c 39 e6             	cmp    %r12,%rsi
  801ffc:	72 df                	jb     801fdd <readn+0x37>
    }
    return res;
  801ffe:	48 63 c3             	movslq %ebx,%rax
}
  802001:	48 83 c4 08          	add    $0x8,%rsp
  802005:	5b                   	pop    %rbx
  802006:	41 5c                	pop    %r12
  802008:	41 5d                	pop    %r13
  80200a:	41 5e                	pop    %r14
  80200c:	41 5f                	pop    %r15
  80200e:	5d                   	pop    %rbp
  80200f:	c3                   	ret
        if (inc < 0) return inc;
  802010:	48 98                	cltq
  802012:	eb ed                	jmp    802001 <readn+0x5b>
    int inc = 1, res = 0;
  802014:	bb 00 00 00 00       	mov    $0x0,%ebx
  802019:	eb e3                	jmp    801ffe <readn+0x58>

000000000080201b <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  80201b:	f3 0f 1e fa          	endbr64
  80201f:	55                   	push   %rbp
  802020:	48 89 e5             	mov    %rsp,%rbp
  802023:	41 56                	push   %r14
  802025:	41 55                	push   %r13
  802027:	41 54                	push   %r12
  802029:	53                   	push   %rbx
  80202a:	48 83 ec 10          	sub    $0x10,%rsp
  80202e:	89 fb                	mov    %edi,%ebx
  802030:	49 89 f4             	mov    %rsi,%r12
  802033:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  802036:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  80203a:	48 b8 e9 1b 80 00 00 	movabs $0x801be9,%rax
  802041:	00 00 00 
  802044:	ff d0                	call   *%rax
  802046:	85 c0                	test   %eax,%eax
  802048:	78 47                	js     802091 <write+0x76>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  80204a:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  80204e:	41 8b 3e             	mov    (%r14),%edi
  802051:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  802055:	48 b8 38 1c 80 00 00 	movabs $0x801c38,%rax
  80205c:	00 00 00 
  80205f:	ff d0                	call   *%rax
  802061:	85 c0                	test   %eax,%eax
  802063:	78 30                	js     802095 <write+0x7a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802065:	41 f6 46 08 03       	testb  $0x3,0x8(%r14)
  80206a:	74 2d                	je     802099 <write+0x7e>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  80206c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802070:	48 8b 40 18          	mov    0x18(%rax),%rax
  802074:	48 85 c0             	test   %rax,%rax
  802077:	74 56                	je     8020cf <write+0xb4>

    return (*dev->dev_write)(fd, buf, n);
  802079:	4c 89 ea             	mov    %r13,%rdx
  80207c:	4c 89 e6             	mov    %r12,%rsi
  80207f:	4c 89 f7             	mov    %r14,%rdi
  802082:	ff d0                	call   *%rax
}
  802084:	48 83 c4 10          	add    $0x10,%rsp
  802088:	5b                   	pop    %rbx
  802089:	41 5c                	pop    %r12
  80208b:	41 5d                	pop    %r13
  80208d:	41 5e                	pop    %r14
  80208f:	5d                   	pop    %rbp
  802090:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  802091:	48 98                	cltq
  802093:	eb ef                	jmp    802084 <write+0x69>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  802095:	48 98                	cltq
  802097:	eb eb                	jmp    802084 <write+0x69>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802099:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  8020a0:	00 00 00 
  8020a3:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  8020a9:	89 da                	mov    %ebx,%edx
  8020ab:	48 bf f1 42 80 00 00 	movabs $0x8042f1,%rdi
  8020b2:	00 00 00 
  8020b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ba:	48 b9 e1 06 80 00 00 	movabs $0x8006e1,%rcx
  8020c1:	00 00 00 
  8020c4:	ff d1                	call   *%rcx
        return -E_INVAL;
  8020c6:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  8020cd:	eb b5                	jmp    802084 <write+0x69>
    if (!dev->dev_write) return -E_NOT_SUPP;
  8020cf:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  8020d6:	eb ac                	jmp    802084 <write+0x69>

00000000008020d8 <seek>:

int
seek(int fdnum, off_t offset) {
  8020d8:	f3 0f 1e fa          	endbr64
  8020dc:	55                   	push   %rbp
  8020dd:	48 89 e5             	mov    %rsp,%rbp
  8020e0:	53                   	push   %rbx
  8020e1:	48 83 ec 18          	sub    $0x18,%rsp
  8020e5:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8020e7:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  8020eb:	48 b8 e9 1b 80 00 00 	movabs $0x801be9,%rax
  8020f2:	00 00 00 
  8020f5:	ff d0                	call   *%rax
  8020f7:	85 c0                	test   %eax,%eax
  8020f9:	78 0c                	js     802107 <seek+0x2f>

    fd->fd_offset = offset;
  8020fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020ff:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  802102:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802107:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80210b:	c9                   	leave
  80210c:	c3                   	ret

000000000080210d <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  80210d:	f3 0f 1e fa          	endbr64
  802111:	55                   	push   %rbp
  802112:	48 89 e5             	mov    %rsp,%rbp
  802115:	41 55                	push   %r13
  802117:	41 54                	push   %r12
  802119:	53                   	push   %rbx
  80211a:	48 83 ec 18          	sub    $0x18,%rsp
  80211e:	89 fb                	mov    %edi,%ebx
  802120:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  802123:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  802127:	48 b8 e9 1b 80 00 00 	movabs $0x801be9,%rax
  80212e:	00 00 00 
  802131:	ff d0                	call   *%rax
  802133:	85 c0                	test   %eax,%eax
  802135:	78 38                	js     80216f <ftruncate+0x62>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  802137:	4c 8b 6d d8          	mov    -0x28(%rbp),%r13
  80213b:	41 8b 7d 00          	mov    0x0(%r13),%edi
  80213f:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  802143:	48 b8 38 1c 80 00 00 	movabs $0x801c38,%rax
  80214a:	00 00 00 
  80214d:	ff d0                	call   *%rax
  80214f:	85 c0                	test   %eax,%eax
  802151:	78 1c                	js     80216f <ftruncate+0x62>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802153:	41 f6 45 08 03       	testb  $0x3,0x8(%r13)
  802158:	74 20                	je     80217a <ftruncate+0x6d>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  80215a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80215e:	48 8b 40 30          	mov    0x30(%rax),%rax
  802162:	48 85 c0             	test   %rax,%rax
  802165:	74 47                	je     8021ae <ftruncate+0xa1>

    return (*dev->dev_trunc)(fd, newsize);
  802167:	44 89 e6             	mov    %r12d,%esi
  80216a:	4c 89 ef             	mov    %r13,%rdi
  80216d:	ff d0                	call   *%rax
}
  80216f:	48 83 c4 18          	add    $0x18,%rsp
  802173:	5b                   	pop    %rbx
  802174:	41 5c                	pop    %r12
  802176:	41 5d                	pop    %r13
  802178:	5d                   	pop    %rbp
  802179:	c3                   	ret
                thisenv->env_id, fdnum);
  80217a:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  802181:	00 00 00 
  802184:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  80218a:	89 da                	mov    %ebx,%edx
  80218c:	48 bf b0 44 80 00 00 	movabs $0x8044b0,%rdi
  802193:	00 00 00 
  802196:	b8 00 00 00 00       	mov    $0x0,%eax
  80219b:	48 b9 e1 06 80 00 00 	movabs $0x8006e1,%rcx
  8021a2:	00 00 00 
  8021a5:	ff d1                	call   *%rcx
        return -E_INVAL;
  8021a7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8021ac:	eb c1                	jmp    80216f <ftruncate+0x62>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  8021ae:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  8021b3:	eb ba                	jmp    80216f <ftruncate+0x62>

00000000008021b5 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  8021b5:	f3 0f 1e fa          	endbr64
  8021b9:	55                   	push   %rbp
  8021ba:	48 89 e5             	mov    %rsp,%rbp
  8021bd:	41 54                	push   %r12
  8021bf:	53                   	push   %rbx
  8021c0:	48 83 ec 10          	sub    $0x10,%rsp
  8021c4:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8021c7:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  8021cb:	48 b8 e9 1b 80 00 00 	movabs $0x801be9,%rax
  8021d2:	00 00 00 
  8021d5:	ff d0                	call   *%rax
  8021d7:	85 c0                	test   %eax,%eax
  8021d9:	78 4e                	js     802229 <fstat+0x74>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8021db:	4c 8b 65 e8          	mov    -0x18(%rbp),%r12
  8021df:	41 8b 3c 24          	mov    (%r12),%edi
  8021e3:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  8021e7:	48 b8 38 1c 80 00 00 	movabs $0x801c38,%rax
  8021ee:	00 00 00 
  8021f1:	ff d0                	call   *%rax
  8021f3:	85 c0                	test   %eax,%eax
  8021f5:	78 32                	js     802229 <fstat+0x74>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  8021f7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8021fb:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  802200:	74 30                	je     802232 <fstat+0x7d>

    stat->st_name[0] = 0;
  802202:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  802205:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  80220c:	00 00 00 
    stat->st_isdir = 0;
  80220f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  802216:	00 00 00 
    stat->st_dev = dev;
  802219:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  802220:	48 89 de             	mov    %rbx,%rsi
  802223:	4c 89 e7             	mov    %r12,%rdi
  802226:	ff 50 28             	call   *0x28(%rax)
}
  802229:	48 83 c4 10          	add    $0x10,%rsp
  80222d:	5b                   	pop    %rbx
  80222e:	41 5c                	pop    %r12
  802230:	5d                   	pop    %rbp
  802231:	c3                   	ret
    if (!dev->dev_stat) return -E_NOT_SUPP;
  802232:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  802237:	eb f0                	jmp    802229 <fstat+0x74>

0000000000802239 <stat>:

int
stat(const char *path, struct Stat *stat) {
  802239:	f3 0f 1e fa          	endbr64
  80223d:	55                   	push   %rbp
  80223e:	48 89 e5             	mov    %rsp,%rbp
  802241:	41 54                	push   %r12
  802243:	53                   	push   %rbx
  802244:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  802247:	be 00 00 00 00       	mov    $0x0,%esi
  80224c:	48 b8 1a 25 80 00 00 	movabs $0x80251a,%rax
  802253:	00 00 00 
  802256:	ff d0                	call   *%rax
  802258:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  80225a:	85 c0                	test   %eax,%eax
  80225c:	78 25                	js     802283 <stat+0x4a>

    int res = fstat(fd, stat);
  80225e:	4c 89 e6             	mov    %r12,%rsi
  802261:	89 c7                	mov    %eax,%edi
  802263:	48 b8 b5 21 80 00 00 	movabs $0x8021b5,%rax
  80226a:	00 00 00 
  80226d:	ff d0                	call   *%rax
  80226f:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  802272:	89 df                	mov    %ebx,%edi
  802274:	48 b8 5a 1d 80 00 00 	movabs $0x801d5a,%rax
  80227b:	00 00 00 
  80227e:	ff d0                	call   *%rax

    return res;
  802280:	44 89 e3             	mov    %r12d,%ebx
}
  802283:	89 d8                	mov    %ebx,%eax
  802285:	5b                   	pop    %rbx
  802286:	41 5c                	pop    %r12
  802288:	5d                   	pop    %rbp
  802289:	c3                   	ret

000000000080228a <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  80228a:	f3 0f 1e fa          	endbr64
  80228e:	55                   	push   %rbp
  80228f:	48 89 e5             	mov    %rsp,%rbp
  802292:	41 54                	push   %r12
  802294:	53                   	push   %rbx
  802295:	48 83 ec 10          	sub    $0x10,%rsp
  802299:	41 89 fc             	mov    %edi,%r12d
  80229c:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  80229f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8022a6:	00 00 00 
  8022a9:	83 38 00             	cmpl   $0x0,(%rax)
  8022ac:	74 6e                	je     80231c <fsipc+0x92>

    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }
    fsenv = ipc_find_env(ENV_TYPE_FS);
  8022ae:	bf 03 00 00 00       	mov    $0x3,%edi
  8022b3:	48 b8 5e 33 80 00 00 	movabs $0x80335e,%rax
  8022ba:	00 00 00 
  8022bd:	ff d0                	call   *%rax
  8022bf:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  8022c6:	00 00 
    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  8022c8:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  8022ce:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8022d3:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8022da:	00 00 00 
  8022dd:	44 89 e6             	mov    %r12d,%esi
  8022e0:	89 c7                	mov    %eax,%edi
  8022e2:	48 b8 9c 32 80 00 00 	movabs $0x80329c,%rax
  8022e9:	00 00 00 
  8022ec:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  8022ee:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  8022f5:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  8022f6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8022fb:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8022ff:	48 89 de             	mov    %rbx,%rsi
  802302:	bf 00 00 00 00       	mov    $0x0,%edi
  802307:	48 b8 03 32 80 00 00 	movabs $0x803203,%rax
  80230e:	00 00 00 
  802311:	ff d0                	call   *%rax
}
  802313:	48 83 c4 10          	add    $0x10,%rsp
  802317:	5b                   	pop    %rbx
  802318:	41 5c                	pop    %r12
  80231a:	5d                   	pop    %rbp
  80231b:	c3                   	ret
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  80231c:	bf 03 00 00 00       	mov    $0x3,%edi
  802321:	48 b8 5e 33 80 00 00 	movabs $0x80335e,%rax
  802328:	00 00 00 
  80232b:	ff d0                	call   *%rax
  80232d:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  802334:	00 00 
  802336:	e9 73 ff ff ff       	jmp    8022ae <fsipc+0x24>

000000000080233b <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  80233b:	f3 0f 1e fa          	endbr64
  80233f:	55                   	push   %rbp
  802340:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802343:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80234a:	00 00 00 
  80234d:	8b 57 0c             	mov    0xc(%rdi),%edx
  802350:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  802352:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  802355:	be 00 00 00 00       	mov    $0x0,%esi
  80235a:	bf 02 00 00 00       	mov    $0x2,%edi
  80235f:	48 b8 8a 22 80 00 00 	movabs $0x80228a,%rax
  802366:	00 00 00 
  802369:	ff d0                	call   *%rax
}
  80236b:	5d                   	pop    %rbp
  80236c:	c3                   	ret

000000000080236d <devfile_flush>:
devfile_flush(struct Fd *fd) {
  80236d:	f3 0f 1e fa          	endbr64
  802371:	55                   	push   %rbp
  802372:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802375:	8b 47 0c             	mov    0xc(%rdi),%eax
  802378:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  80237f:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  802381:	be 00 00 00 00       	mov    $0x0,%esi
  802386:	bf 06 00 00 00       	mov    $0x6,%edi
  80238b:	48 b8 8a 22 80 00 00 	movabs $0x80228a,%rax
  802392:	00 00 00 
  802395:	ff d0                	call   *%rax
}
  802397:	5d                   	pop    %rbp
  802398:	c3                   	ret

0000000000802399 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  802399:	f3 0f 1e fa          	endbr64
  80239d:	55                   	push   %rbp
  80239e:	48 89 e5             	mov    %rsp,%rbp
  8023a1:	41 54                	push   %r12
  8023a3:	53                   	push   %rbx
  8023a4:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8023a7:	8b 47 0c             	mov    0xc(%rdi),%eax
  8023aa:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  8023b1:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  8023b3:	be 00 00 00 00       	mov    $0x0,%esi
  8023b8:	bf 05 00 00 00       	mov    $0x5,%edi
  8023bd:	48 b8 8a 22 80 00 00 	movabs $0x80228a,%rax
  8023c4:	00 00 00 
  8023c7:	ff d0                	call   *%rax
    if (res < 0) return res;
  8023c9:	85 c0                	test   %eax,%eax
  8023cb:	78 3d                	js     80240a <devfile_stat+0x71>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8023cd:	49 bc 00 70 80 00 00 	movabs $0x807000,%r12
  8023d4:	00 00 00 
  8023d7:	4c 89 e6             	mov    %r12,%rsi
  8023da:	48 89 df             	mov    %rbx,%rdi
  8023dd:	48 b8 2a 10 80 00 00 	movabs $0x80102a,%rax
  8023e4:	00 00 00 
  8023e7:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  8023e9:	41 8b 84 24 80 00 00 	mov    0x80(%r12),%eax
  8023f0:	00 
  8023f1:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8023f7:	41 8b 84 24 84 00 00 	mov    0x84(%r12),%eax
  8023fe:	00 
  8023ff:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  802405:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80240a:	5b                   	pop    %rbx
  80240b:	41 5c                	pop    %r12
  80240d:	5d                   	pop    %rbp
  80240e:	c3                   	ret

000000000080240f <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  80240f:	f3 0f 1e fa          	endbr64
    if (n >= sizeof(fsipcbuf.write.req_buf)) {
  802413:	48 81 fa ef 0f 00 00 	cmp    $0xfef,%rdx
  80241a:	77 41                	ja     80245d <devfile_write+0x4e>
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  80241c:	55                   	push   %rbp
  80241d:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  802420:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802427:	00 00 00 
  80242a:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  80242d:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.write.req_n = n;
  80242f:	48 89 50 08          	mov    %rdx,0x8(%rax)
    memmove(fsipcbuf.write.req_buf, buf, n);
  802433:	48 8d 78 10          	lea    0x10(%rax),%rdi
  802437:	48 b8 45 12 80 00 00 	movabs $0x801245,%rax
  80243e:	00 00 00 
  802441:	ff d0                	call   *%rax
    res = fsipc(FSREQ_WRITE, NULL);
  802443:	be 00 00 00 00       	mov    $0x0,%esi
  802448:	bf 04 00 00 00       	mov    $0x4,%edi
  80244d:	48 b8 8a 22 80 00 00 	movabs $0x80228a,%rax
  802454:	00 00 00 
  802457:	ff d0                	call   *%rax
  802459:	48 98                	cltq
}
  80245b:	5d                   	pop    %rbp
  80245c:	c3                   	ret
        return -E_INVAL;
  80245d:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
}
  802464:	c3                   	ret

0000000000802465 <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  802465:	f3 0f 1e fa          	endbr64
  802469:	55                   	push   %rbp
  80246a:	48 89 e5             	mov    %rsp,%rbp
  80246d:	41 55                	push   %r13
  80246f:	41 54                	push   %r12
  802471:	53                   	push   %rbx
  802472:	48 83 ec 08          	sub    $0x8,%rsp
  802476:	49 89 f4             	mov    %rsi,%r12
  802479:	48 89 d3             	mov    %rdx,%rbx
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  80247c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802483:	00 00 00 
  802486:	8b 57 0c             	mov    0xc(%rdi),%edx
  802489:	89 10                	mov    %edx,(%rax)
    fsipcbuf.read.req_n = n;
  80248b:	48 89 58 08          	mov    %rbx,0x8(%rax)
    res = fsipc(FSREQ_READ, NULL);
  80248f:	be 00 00 00 00       	mov    $0x0,%esi
  802494:	bf 03 00 00 00       	mov    $0x3,%edi
  802499:	48 b8 8a 22 80 00 00 	movabs $0x80228a,%rax
  8024a0:	00 00 00 
  8024a3:	ff d0                	call   *%rax
  8024a5:	4c 63 e8             	movslq %eax,%r13
    if (res < 0) {
  8024a8:	4d 85 ed             	test   %r13,%r13
  8024ab:	78 2a                	js     8024d7 <devfile_read+0x72>
    assert(res <= n && res <= PAGE_SIZE);
  8024ad:	4c 89 ea             	mov    %r13,%rdx
  8024b0:	4c 39 eb             	cmp    %r13,%rbx
  8024b3:	72 30                	jb     8024e5 <devfile_read+0x80>
  8024b5:	49 81 fd 00 10 00 00 	cmp    $0x1000,%r13
  8024bc:	7f 27                	jg     8024e5 <devfile_read+0x80>
    memmove(buf, &fsipcbuf, res);
  8024be:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  8024c5:	00 00 00 
  8024c8:	4c 89 e7             	mov    %r12,%rdi
  8024cb:	48 b8 45 12 80 00 00 	movabs $0x801245,%rax
  8024d2:	00 00 00 
  8024d5:	ff d0                	call   *%rax
}
  8024d7:	4c 89 e8             	mov    %r13,%rax
  8024da:	48 83 c4 08          	add    $0x8,%rsp
  8024de:	5b                   	pop    %rbx
  8024df:	41 5c                	pop    %r12
  8024e1:	41 5d                	pop    %r13
  8024e3:	5d                   	pop    %rbp
  8024e4:	c3                   	ret
    assert(res <= n && res <= PAGE_SIZE);
  8024e5:	48 b9 0e 43 80 00 00 	movabs $0x80430e,%rcx
  8024ec:	00 00 00 
  8024ef:	48 ba 2b 43 80 00 00 	movabs $0x80432b,%rdx
  8024f6:	00 00 00 
  8024f9:	be 7b 00 00 00       	mov    $0x7b,%esi
  8024fe:	48 bf 40 43 80 00 00 	movabs $0x804340,%rdi
  802505:	00 00 00 
  802508:	b8 00 00 00 00       	mov    $0x0,%eax
  80250d:	49 b8 85 05 80 00 00 	movabs $0x800585,%r8
  802514:	00 00 00 
  802517:	41 ff d0             	call   *%r8

000000000080251a <open>:
open(const char *path, int mode) {
  80251a:	f3 0f 1e fa          	endbr64
  80251e:	55                   	push   %rbp
  80251f:	48 89 e5             	mov    %rsp,%rbp
  802522:	41 55                	push   %r13
  802524:	41 54                	push   %r12
  802526:	53                   	push   %rbx
  802527:	48 83 ec 18          	sub    $0x18,%rsp
  80252b:	49 89 fc             	mov    %rdi,%r12
  80252e:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  802531:	48 b8 e5 0f 80 00 00 	movabs $0x800fe5,%rax
  802538:	00 00 00 
  80253b:	ff d0                	call   *%rax
  80253d:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  802543:	0f 87 8a 00 00 00    	ja     8025d3 <open+0xb9>
    if ((res = fd_alloc(&fd)) < 0) return res;
  802549:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  80254d:	48 b8 85 1b 80 00 00 	movabs $0x801b85,%rax
  802554:	00 00 00 
  802557:	ff d0                	call   *%rax
  802559:	89 c3                	mov    %eax,%ebx
  80255b:	85 c0                	test   %eax,%eax
  80255d:	78 50                	js     8025af <open+0x95>
    strcpy(fsipcbuf.open.req_path, path);
  80255f:	4c 89 e6             	mov    %r12,%rsi
  802562:	48 bb 00 70 80 00 00 	movabs $0x807000,%rbx
  802569:	00 00 00 
  80256c:	48 89 df             	mov    %rbx,%rdi
  80256f:	48 b8 2a 10 80 00 00 	movabs $0x80102a,%rax
  802576:	00 00 00 
  802579:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  80257b:	44 89 ab 00 04 00 00 	mov    %r13d,0x400(%rbx)
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  802582:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802586:	bf 01 00 00 00       	mov    $0x1,%edi
  80258b:	48 b8 8a 22 80 00 00 	movabs $0x80228a,%rax
  802592:	00 00 00 
  802595:	ff d0                	call   *%rax
  802597:	89 c3                	mov    %eax,%ebx
  802599:	85 c0                	test   %eax,%eax
  80259b:	78 1f                	js     8025bc <open+0xa2>
    return fd2num(fd);
  80259d:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8025a1:	48 b8 4f 1b 80 00 00 	movabs $0x801b4f,%rax
  8025a8:	00 00 00 
  8025ab:	ff d0                	call   *%rax
  8025ad:	89 c3                	mov    %eax,%ebx
}
  8025af:	89 d8                	mov    %ebx,%eax
  8025b1:	48 83 c4 18          	add    $0x18,%rsp
  8025b5:	5b                   	pop    %rbx
  8025b6:	41 5c                	pop    %r12
  8025b8:	41 5d                	pop    %r13
  8025ba:	5d                   	pop    %rbp
  8025bb:	c3                   	ret
        fd_close(fd, 0);
  8025bc:	be 00 00 00 00       	mov    $0x0,%esi
  8025c1:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8025c5:	48 b8 ac 1c 80 00 00 	movabs $0x801cac,%rax
  8025cc:	00 00 00 
  8025cf:	ff d0                	call   *%rax
        return res;
  8025d1:	eb dc                	jmp    8025af <open+0x95>
        return -E_BAD_PATH;
  8025d3:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  8025d8:	eb d5                	jmp    8025af <open+0x95>

00000000008025da <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  8025da:	f3 0f 1e fa          	endbr64
  8025de:	55                   	push   %rbp
  8025df:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  8025e2:	be 00 00 00 00       	mov    $0x0,%esi
  8025e7:	bf 08 00 00 00       	mov    $0x8,%edi
  8025ec:	48 b8 8a 22 80 00 00 	movabs $0x80228a,%rax
  8025f3:	00 00 00 
  8025f6:	ff d0                	call   *%rax
}
  8025f8:	5d                   	pop    %rbp
  8025f9:	c3                   	ret

00000000008025fa <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  8025fa:	f3 0f 1e fa          	endbr64
  8025fe:	55                   	push   %rbp
  8025ff:	48 89 e5             	mov    %rsp,%rbp
  802602:	41 54                	push   %r12
  802604:	53                   	push   %rbx
  802605:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802608:	48 b8 65 1b 80 00 00 	movabs $0x801b65,%rax
  80260f:	00 00 00 
  802612:	ff d0                	call   *%rax
  802614:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  802617:	48 be 4b 43 80 00 00 	movabs $0x80434b,%rsi
  80261e:	00 00 00 
  802621:	48 89 df             	mov    %rbx,%rdi
  802624:	48 b8 2a 10 80 00 00 	movabs $0x80102a,%rax
  80262b:	00 00 00 
  80262e:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  802630:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  802635:	41 2b 04 24          	sub    (%r12),%eax
  802639:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  80263f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  802646:	00 00 00 
    stat->st_dev = &devpipe;
  802649:	48 b8 60 50 80 00 00 	movabs $0x805060,%rax
  802650:	00 00 00 
  802653:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  80265a:	b8 00 00 00 00       	mov    $0x0,%eax
  80265f:	5b                   	pop    %rbx
  802660:	41 5c                	pop    %r12
  802662:	5d                   	pop    %rbp
  802663:	c3                   	ret

0000000000802664 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  802664:	f3 0f 1e fa          	endbr64
  802668:	55                   	push   %rbp
  802669:	48 89 e5             	mov    %rsp,%rbp
  80266c:	41 54                	push   %r12
  80266e:	53                   	push   %rbx
  80266f:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  802672:	ba 00 10 00 00       	mov    $0x1000,%edx
  802677:	48 89 fe             	mov    %rdi,%rsi
  80267a:	bf 00 00 00 00       	mov    $0x0,%edi
  80267f:	49 bc 6f 17 80 00 00 	movabs $0x80176f,%r12
  802686:	00 00 00 
  802689:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  80268c:	48 89 df             	mov    %rbx,%rdi
  80268f:	48 b8 65 1b 80 00 00 	movabs $0x801b65,%rax
  802696:	00 00 00 
  802699:	ff d0                	call   *%rax
  80269b:	48 89 c6             	mov    %rax,%rsi
  80269e:	ba 00 10 00 00       	mov    $0x1000,%edx
  8026a3:	bf 00 00 00 00       	mov    $0x0,%edi
  8026a8:	41 ff d4             	call   *%r12
}
  8026ab:	5b                   	pop    %rbx
  8026ac:	41 5c                	pop    %r12
  8026ae:	5d                   	pop    %rbp
  8026af:	c3                   	ret

00000000008026b0 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  8026b0:	f3 0f 1e fa          	endbr64
  8026b4:	55                   	push   %rbp
  8026b5:	48 89 e5             	mov    %rsp,%rbp
  8026b8:	41 57                	push   %r15
  8026ba:	41 56                	push   %r14
  8026bc:	41 55                	push   %r13
  8026be:	41 54                	push   %r12
  8026c0:	53                   	push   %rbx
  8026c1:	48 83 ec 18          	sub    $0x18,%rsp
  8026c5:	49 89 fc             	mov    %rdi,%r12
  8026c8:	49 89 f5             	mov    %rsi,%r13
  8026cb:	49 89 d7             	mov    %rdx,%r15
  8026ce:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8026d2:	48 b8 65 1b 80 00 00 	movabs $0x801b65,%rax
  8026d9:	00 00 00 
  8026dc:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  8026de:	4d 85 ff             	test   %r15,%r15
  8026e1:	0f 84 af 00 00 00    	je     802796 <devpipe_write+0xe6>
  8026e7:	48 89 c3             	mov    %rax,%rbx
  8026ea:	4c 89 f8             	mov    %r15,%rax
  8026ed:	4d 89 ef             	mov    %r13,%r15
  8026f0:	4c 01 e8             	add    %r13,%rax
  8026f3:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8026f7:	49 bd ff 15 80 00 00 	movabs $0x8015ff,%r13
  8026fe:	00 00 00 
            sys_yield();
  802701:	49 be 94 15 80 00 00 	movabs $0x801594,%r14
  802708:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  80270b:	8b 73 04             	mov    0x4(%rbx),%esi
  80270e:	48 63 ce             	movslq %esi,%rcx
  802711:	48 63 03             	movslq (%rbx),%rax
  802714:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  80271a:	48 39 c1             	cmp    %rax,%rcx
  80271d:	72 2e                	jb     80274d <devpipe_write+0x9d>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80271f:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802724:	48 89 da             	mov    %rbx,%rdx
  802727:	be 00 10 00 00       	mov    $0x1000,%esi
  80272c:	4c 89 e7             	mov    %r12,%rdi
  80272f:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802732:	85 c0                	test   %eax,%eax
  802734:	74 66                	je     80279c <devpipe_write+0xec>
            sys_yield();
  802736:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  802739:	8b 73 04             	mov    0x4(%rbx),%esi
  80273c:	48 63 ce             	movslq %esi,%rcx
  80273f:	48 63 03             	movslq (%rbx),%rax
  802742:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  802748:	48 39 c1             	cmp    %rax,%rcx
  80274b:	73 d2                	jae    80271f <devpipe_write+0x6f>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80274d:	41 0f b6 3f          	movzbl (%r15),%edi
  802751:	48 89 ca             	mov    %rcx,%rdx
  802754:	48 c1 ea 03          	shr    $0x3,%rdx
  802758:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  80275f:	08 10 20 
  802762:	48 f7 e2             	mul    %rdx
  802765:	48 c1 ea 06          	shr    $0x6,%rdx
  802769:	48 89 d0             	mov    %rdx,%rax
  80276c:	48 c1 e0 09          	shl    $0x9,%rax
  802770:	48 29 d0             	sub    %rdx,%rax
  802773:	48 c1 e0 03          	shl    $0x3,%rax
  802777:	48 29 c1             	sub    %rax,%rcx
  80277a:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  80277f:	83 c6 01             	add    $0x1,%esi
  802782:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  802785:	49 83 c7 01          	add    $0x1,%r15
  802789:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80278d:	49 39 c7             	cmp    %rax,%r15
  802790:	0f 85 75 ff ff ff    	jne    80270b <devpipe_write+0x5b>
    return n;
  802796:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80279a:	eb 05                	jmp    8027a1 <devpipe_write+0xf1>
            if (_pipeisclosed(fd, p)) return 0;
  80279c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027a1:	48 83 c4 18          	add    $0x18,%rsp
  8027a5:	5b                   	pop    %rbx
  8027a6:	41 5c                	pop    %r12
  8027a8:	41 5d                	pop    %r13
  8027aa:	41 5e                	pop    %r14
  8027ac:	41 5f                	pop    %r15
  8027ae:	5d                   	pop    %rbp
  8027af:	c3                   	ret

00000000008027b0 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  8027b0:	f3 0f 1e fa          	endbr64
  8027b4:	55                   	push   %rbp
  8027b5:	48 89 e5             	mov    %rsp,%rbp
  8027b8:	41 57                	push   %r15
  8027ba:	41 56                	push   %r14
  8027bc:	41 55                	push   %r13
  8027be:	41 54                	push   %r12
  8027c0:	53                   	push   %rbx
  8027c1:	48 83 ec 18          	sub    $0x18,%rsp
  8027c5:	49 89 fc             	mov    %rdi,%r12
  8027c8:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  8027cc:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8027d0:	48 b8 65 1b 80 00 00 	movabs $0x801b65,%rax
  8027d7:	00 00 00 
  8027da:	ff d0                	call   *%rax
  8027dc:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  8027df:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8027e5:	49 bd ff 15 80 00 00 	movabs $0x8015ff,%r13
  8027ec:	00 00 00 
            sys_yield();
  8027ef:	49 be 94 15 80 00 00 	movabs $0x801594,%r14
  8027f6:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  8027f9:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8027fe:	74 7d                	je     80287d <devpipe_read+0xcd>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802800:	8b 03                	mov    (%rbx),%eax
  802802:	3b 43 04             	cmp    0x4(%rbx),%eax
  802805:	75 26                	jne    80282d <devpipe_read+0x7d>
            if (i > 0) return i;
  802807:	4d 85 ff             	test   %r15,%r15
  80280a:	75 77                	jne    802883 <devpipe_read+0xd3>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80280c:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802811:	48 89 da             	mov    %rbx,%rdx
  802814:	be 00 10 00 00       	mov    $0x1000,%esi
  802819:	4c 89 e7             	mov    %r12,%rdi
  80281c:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  80281f:	85 c0                	test   %eax,%eax
  802821:	74 72                	je     802895 <devpipe_read+0xe5>
            sys_yield();
  802823:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802826:	8b 03                	mov    (%rbx),%eax
  802828:	3b 43 04             	cmp    0x4(%rbx),%eax
  80282b:	74 df                	je     80280c <devpipe_read+0x5c>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80282d:	48 63 c8             	movslq %eax,%rcx
  802830:	48 89 ca             	mov    %rcx,%rdx
  802833:	48 c1 ea 03          	shr    $0x3,%rdx
  802837:	48 be 81 00 01 02 04 	movabs $0x2010080402010081,%rsi
  80283e:	08 10 20 
  802841:	48 89 d0             	mov    %rdx,%rax
  802844:	48 f7 e6             	mul    %rsi
  802847:	48 c1 ea 06          	shr    $0x6,%rdx
  80284b:	48 89 d0             	mov    %rdx,%rax
  80284e:	48 c1 e0 09          	shl    $0x9,%rax
  802852:	48 29 d0             	sub    %rdx,%rax
  802855:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80285c:	00 
  80285d:	48 89 c8             	mov    %rcx,%rax
  802860:	48 29 d0             	sub    %rdx,%rax
  802863:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  802868:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  80286c:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  802870:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  802873:	49 83 c7 01          	add    $0x1,%r15
  802877:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  80287b:	75 83                	jne    802800 <devpipe_read+0x50>
    return n;
  80287d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802881:	eb 03                	jmp    802886 <devpipe_read+0xd6>
            if (i > 0) return i;
  802883:	4c 89 f8             	mov    %r15,%rax
}
  802886:	48 83 c4 18          	add    $0x18,%rsp
  80288a:	5b                   	pop    %rbx
  80288b:	41 5c                	pop    %r12
  80288d:	41 5d                	pop    %r13
  80288f:	41 5e                	pop    %r14
  802891:	41 5f                	pop    %r15
  802893:	5d                   	pop    %rbp
  802894:	c3                   	ret
            if (_pipeisclosed(fd, p)) return 0;
  802895:	b8 00 00 00 00       	mov    $0x0,%eax
  80289a:	eb ea                	jmp    802886 <devpipe_read+0xd6>

000000000080289c <pipe>:
pipe(int pfd[2]) {
  80289c:	f3 0f 1e fa          	endbr64
  8028a0:	55                   	push   %rbp
  8028a1:	48 89 e5             	mov    %rsp,%rbp
  8028a4:	41 55                	push   %r13
  8028a6:	41 54                	push   %r12
  8028a8:	53                   	push   %rbx
  8028a9:	48 83 ec 18          	sub    $0x18,%rsp
  8028ad:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  8028b0:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  8028b4:	48 b8 85 1b 80 00 00 	movabs $0x801b85,%rax
  8028bb:	00 00 00 
  8028be:	ff d0                	call   *%rax
  8028c0:	89 c3                	mov    %eax,%ebx
  8028c2:	85 c0                	test   %eax,%eax
  8028c4:	0f 88 a0 01 00 00    	js     802a6a <pipe+0x1ce>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  8028ca:	b9 46 00 00 00       	mov    $0x46,%ecx
  8028cf:	ba 00 10 00 00       	mov    $0x1000,%edx
  8028d4:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8028d8:	bf 00 00 00 00       	mov    $0x0,%edi
  8028dd:	48 b8 2f 16 80 00 00 	movabs $0x80162f,%rax
  8028e4:	00 00 00 
  8028e7:	ff d0                	call   *%rax
  8028e9:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  8028eb:	85 c0                	test   %eax,%eax
  8028ed:	0f 88 77 01 00 00    	js     802a6a <pipe+0x1ce>
    if ((res = fd_alloc(&fd1)) < 0 ||
  8028f3:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  8028f7:	48 b8 85 1b 80 00 00 	movabs $0x801b85,%rax
  8028fe:	00 00 00 
  802901:	ff d0                	call   *%rax
  802903:	89 c3                	mov    %eax,%ebx
  802905:	85 c0                	test   %eax,%eax
  802907:	0f 88 43 01 00 00    	js     802a50 <pipe+0x1b4>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  80290d:	b9 46 00 00 00       	mov    $0x46,%ecx
  802912:	ba 00 10 00 00       	mov    $0x1000,%edx
  802917:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80291b:	bf 00 00 00 00       	mov    $0x0,%edi
  802920:	48 b8 2f 16 80 00 00 	movabs $0x80162f,%rax
  802927:	00 00 00 
  80292a:	ff d0                	call   *%rax
  80292c:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  80292e:	85 c0                	test   %eax,%eax
  802930:	0f 88 1a 01 00 00    	js     802a50 <pipe+0x1b4>
    va = fd2data(fd0);
  802936:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80293a:	48 b8 65 1b 80 00 00 	movabs $0x801b65,%rax
  802941:	00 00 00 
  802944:	ff d0                	call   *%rax
  802946:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  802949:	b9 46 00 00 00       	mov    $0x46,%ecx
  80294e:	ba 00 10 00 00       	mov    $0x1000,%edx
  802953:	48 89 c6             	mov    %rax,%rsi
  802956:	bf 00 00 00 00       	mov    $0x0,%edi
  80295b:	48 b8 2f 16 80 00 00 	movabs $0x80162f,%rax
  802962:	00 00 00 
  802965:	ff d0                	call   *%rax
  802967:	89 c3                	mov    %eax,%ebx
  802969:	85 c0                	test   %eax,%eax
  80296b:	0f 88 c5 00 00 00    	js     802a36 <pipe+0x19a>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  802971:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802975:	48 b8 65 1b 80 00 00 	movabs $0x801b65,%rax
  80297c:	00 00 00 
  80297f:	ff d0                	call   *%rax
  802981:	48 89 c1             	mov    %rax,%rcx
  802984:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  80298a:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  802990:	ba 00 00 00 00       	mov    $0x0,%edx
  802995:	4c 89 ee             	mov    %r13,%rsi
  802998:	bf 00 00 00 00       	mov    $0x0,%edi
  80299d:	48 b8 9a 16 80 00 00 	movabs $0x80169a,%rax
  8029a4:	00 00 00 
  8029a7:	ff d0                	call   *%rax
  8029a9:	89 c3                	mov    %eax,%ebx
  8029ab:	85 c0                	test   %eax,%eax
  8029ad:	78 6e                	js     802a1d <pipe+0x181>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8029af:	be 00 10 00 00       	mov    $0x1000,%esi
  8029b4:	4c 89 ef             	mov    %r13,%rdi
  8029b7:	48 b8 c9 15 80 00 00 	movabs $0x8015c9,%rax
  8029be:	00 00 00 
  8029c1:	ff d0                	call   *%rax
  8029c3:	83 f8 02             	cmp    $0x2,%eax
  8029c6:	0f 85 ab 00 00 00    	jne    802a77 <pipe+0x1db>
    fd0->fd_dev_id = devpipe.dev_id;
  8029cc:	a1 60 50 80 00 00 00 	movabs 0x805060,%eax
  8029d3:	00 00 
  8029d5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8029d9:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  8029db:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8029df:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  8029e6:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8029ea:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  8029ec:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8029f0:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  8029f7:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8029fb:	48 bb 4f 1b 80 00 00 	movabs $0x801b4f,%rbx
  802a02:	00 00 00 
  802a05:	ff d3                	call   *%rbx
  802a07:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  802a0b:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802a0f:	ff d3                	call   *%rbx
  802a11:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  802a16:	bb 00 00 00 00       	mov    $0x0,%ebx
  802a1b:	eb 4d                	jmp    802a6a <pipe+0x1ce>
    sys_unmap_region(0, va, PAGE_SIZE);
  802a1d:	ba 00 10 00 00       	mov    $0x1000,%edx
  802a22:	4c 89 ee             	mov    %r13,%rsi
  802a25:	bf 00 00 00 00       	mov    $0x0,%edi
  802a2a:	48 b8 6f 17 80 00 00 	movabs $0x80176f,%rax
  802a31:	00 00 00 
  802a34:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  802a36:	ba 00 10 00 00       	mov    $0x1000,%edx
  802a3b:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802a3f:	bf 00 00 00 00       	mov    $0x0,%edi
  802a44:	48 b8 6f 17 80 00 00 	movabs $0x80176f,%rax
  802a4b:	00 00 00 
  802a4e:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  802a50:	ba 00 10 00 00       	mov    $0x1000,%edx
  802a55:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802a59:	bf 00 00 00 00       	mov    $0x0,%edi
  802a5e:	48 b8 6f 17 80 00 00 	movabs $0x80176f,%rax
  802a65:	00 00 00 
  802a68:	ff d0                	call   *%rax
}
  802a6a:	89 d8                	mov    %ebx,%eax
  802a6c:	48 83 c4 18          	add    $0x18,%rsp
  802a70:	5b                   	pop    %rbx
  802a71:	41 5c                	pop    %r12
  802a73:	41 5d                	pop    %r13
  802a75:	5d                   	pop    %rbp
  802a76:	c3                   	ret
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802a77:	48 b9 d8 44 80 00 00 	movabs $0x8044d8,%rcx
  802a7e:	00 00 00 
  802a81:	48 ba 2b 43 80 00 00 	movabs $0x80432b,%rdx
  802a88:	00 00 00 
  802a8b:	be 2e 00 00 00       	mov    $0x2e,%esi
  802a90:	48 bf 52 43 80 00 00 	movabs $0x804352,%rdi
  802a97:	00 00 00 
  802a9a:	b8 00 00 00 00       	mov    $0x0,%eax
  802a9f:	49 b8 85 05 80 00 00 	movabs $0x800585,%r8
  802aa6:	00 00 00 
  802aa9:	41 ff d0             	call   *%r8

0000000000802aac <pipeisclosed>:
pipeisclosed(int fdnum) {
  802aac:	f3 0f 1e fa          	endbr64
  802ab0:	55                   	push   %rbp
  802ab1:	48 89 e5             	mov    %rsp,%rbp
  802ab4:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802ab8:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802abc:	48 b8 e9 1b 80 00 00 	movabs $0x801be9,%rax
  802ac3:	00 00 00 
  802ac6:	ff d0                	call   *%rax
    if (res < 0) return res;
  802ac8:	85 c0                	test   %eax,%eax
  802aca:	78 35                	js     802b01 <pipeisclosed+0x55>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  802acc:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802ad0:	48 b8 65 1b 80 00 00 	movabs $0x801b65,%rax
  802ad7:	00 00 00 
  802ada:	ff d0                	call   *%rax
  802adc:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802adf:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802ae4:	be 00 10 00 00       	mov    $0x1000,%esi
  802ae9:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802aed:	48 b8 ff 15 80 00 00 	movabs $0x8015ff,%rax
  802af4:	00 00 00 
  802af7:	ff d0                	call   *%rax
  802af9:	85 c0                	test   %eax,%eax
  802afb:	0f 94 c0             	sete   %al
  802afe:	0f b6 c0             	movzbl %al,%eax
}
  802b01:	c9                   	leave
  802b02:	c3                   	ret

0000000000802b03 <wait>:
#include <inc/lib.h>

/* Waits until 'envid' exits. */
void
wait(envid_t envid) {
  802b03:	f3 0f 1e fa          	endbr64
  802b07:	55                   	push   %rbp
  802b08:	48 89 e5             	mov    %rsp,%rbp
  802b0b:	41 55                	push   %r13
  802b0d:	41 54                	push   %r12
  802b0f:	53                   	push   %rbx
  802b10:	48 83 ec 08          	sub    $0x8,%rsp
    assert(envid != 0);
  802b14:	85 ff                	test   %edi,%edi
  802b16:	74 7d                	je     802b95 <wait+0x92>
  802b18:	41 89 fc             	mov    %edi,%r12d

    const volatile struct Env *env = &envs[ENVX(envid)];
  802b1b:	89 f8                	mov    %edi,%eax
  802b1d:	25 ff 03 00 00       	and    $0x3ff,%eax

    while (env->env_id == envid &&
  802b22:	89 fa                	mov    %edi,%edx
  802b24:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  802b2a:	48 8d 0c d2          	lea    (%rdx,%rdx,8),%rcx
  802b2e:	48 8d 0c 4a          	lea    (%rdx,%rcx,2),%rcx
  802b32:	48 c1 e1 04          	shl    $0x4,%rcx
  802b36:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  802b3d:	00 00 00 
  802b40:	48 01 ca             	add    %rcx,%rdx
  802b43:	8b 92 c8 00 00 00    	mov    0xc8(%rdx),%edx
  802b49:	39 d7                	cmp    %edx,%edi
  802b4b:	75 3d                	jne    802b8a <wait+0x87>
           env->env_status != ENV_FREE) {
  802b4d:	48 98                	cltq
  802b4f:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802b53:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  802b57:	48 c1 e0 04          	shl    $0x4,%rax
  802b5b:	48 bb 00 00 a0 1f 80 	movabs $0x801fa00000,%rbx
  802b62:	00 00 00 
  802b65:	48 01 c3             	add    %rax,%rbx
        sys_yield();
  802b68:	49 bd 94 15 80 00 00 	movabs $0x801594,%r13
  802b6f:	00 00 00 
           env->env_status != ENV_FREE) {
  802b72:	8b 83 d4 00 00 00    	mov    0xd4(%rbx),%eax
    while (env->env_id == envid &&
  802b78:	85 c0                	test   %eax,%eax
  802b7a:	74 0e                	je     802b8a <wait+0x87>
        sys_yield();
  802b7c:	41 ff d5             	call   *%r13
    while (env->env_id == envid &&
  802b7f:	8b 83 c8 00 00 00    	mov    0xc8(%rbx),%eax
  802b85:	44 39 e0             	cmp    %r12d,%eax
  802b88:	74 e8                	je     802b72 <wait+0x6f>
    }
}
  802b8a:	48 83 c4 08          	add    $0x8,%rsp
  802b8e:	5b                   	pop    %rbx
  802b8f:	41 5c                	pop    %r12
  802b91:	41 5d                	pop    %r13
  802b93:	5d                   	pop    %rbp
  802b94:	c3                   	ret
    assert(envid != 0);
  802b95:	48 b9 62 43 80 00 00 	movabs $0x804362,%rcx
  802b9c:	00 00 00 
  802b9f:	48 ba 2b 43 80 00 00 	movabs $0x80432b,%rdx
  802ba6:	00 00 00 
  802ba9:	be 06 00 00 00       	mov    $0x6,%esi
  802bae:	48 bf 6d 43 80 00 00 	movabs $0x80436d,%rdi
  802bb5:	00 00 00 
  802bb8:	b8 00 00 00 00       	mov    $0x0,%eax
  802bbd:	49 b8 85 05 80 00 00 	movabs $0x800585,%r8
  802bc4:	00 00 00 
  802bc7:	41 ff d0             	call   *%r8

0000000000802bca <get_uvpt_entry>:
extern volatile pde_t uvpd[];     /* VA of current page directory */
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
  802bca:	f3 0f 1e fa          	endbr64
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802bce:	48 89 f8             	mov    %rdi,%rax
  802bd1:	48 c1 e8 27          	shr    $0x27,%rax
  802bd5:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  802bdc:	7f 00 00 
  802bdf:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802be3:	f6 c2 01             	test   $0x1,%dl
  802be6:	74 6d                	je     802c55 <get_uvpt_entry+0x8b>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  802be8:	48 89 f8             	mov    %rdi,%rax
  802beb:	48 c1 e8 1e          	shr    $0x1e,%rax
  802bef:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  802bf6:	7f 00 00 
  802bf9:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802bfd:	f6 c2 01             	test   $0x1,%dl
  802c00:	74 62                	je     802c64 <get_uvpt_entry+0x9a>
  802c02:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  802c09:	7f 00 00 
  802c0c:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802c10:	f6 c2 80             	test   $0x80,%dl
  802c13:	75 4f                	jne    802c64 <get_uvpt_entry+0x9a>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802c15:	48 89 f8             	mov    %rdi,%rax
  802c18:	48 c1 e8 15          	shr    $0x15,%rax
  802c1c:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802c23:	7f 00 00 
  802c26:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802c2a:	f6 c2 01             	test   $0x1,%dl
  802c2d:	74 44                	je     802c73 <get_uvpt_entry+0xa9>
  802c2f:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802c36:	7f 00 00 
  802c39:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802c3d:	f6 c2 80             	test   $0x80,%dl
  802c40:	75 31                	jne    802c73 <get_uvpt_entry+0xa9>
    return uvpt[VPT(va)];
  802c42:	48 c1 ef 0c          	shr    $0xc,%rdi
  802c46:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802c4d:	7f 00 00 
  802c50:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  802c54:	c3                   	ret
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802c55:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  802c5c:	7f 00 00 
  802c5f:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802c63:	c3                   	ret
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  802c64:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  802c6b:	7f 00 00 
  802c6e:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802c72:	c3                   	ret
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802c73:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802c7a:	7f 00 00 
  802c7d:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802c81:	c3                   	ret

0000000000802c82 <get_phys_addr>:

uintptr_t
get_phys_addr(void *va) {
  802c82:	f3 0f 1e fa          	endbr64
  802c86:	48 89 fa             	mov    %rdi,%rdx
    if (!(uvpml4[VPML4(va)] & PTE_P))
  802c89:	48 89 f9             	mov    %rdi,%rcx
  802c8c:	48 c1 e9 27          	shr    $0x27,%rcx
  802c90:	48 b8 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rax
  802c97:	7f 00 00 
  802c9a:	48 8b 0c c8          	mov    (%rax,%rcx,8),%rcx
        return -1;
  802c9e:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpml4[VPML4(va)] & PTE_P))
  802ca5:	f6 c1 01             	test   $0x1,%cl
  802ca8:	0f 84 b2 00 00 00    	je     802d60 <get_phys_addr+0xde>
    if (!(uvpdp[VPDP(va)] & PTE_P))
  802cae:	48 89 f9             	mov    %rdi,%rcx
  802cb1:	48 c1 e9 1e          	shr    $0x1e,%rcx
  802cb5:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802cbc:	7f 00 00 
  802cbf:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  802cc3:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpdp[VPDP(va)] & PTE_P))
  802cca:	40 f6 c6 01          	test   $0x1,%sil
  802cce:	0f 84 8c 00 00 00    	je     802d60 <get_phys_addr+0xde>
    if (uvpdp[VPDP(va)] & PTE_PS)
  802cd4:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802cdb:	7f 00 00 
  802cde:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802ce2:	a8 80                	test   $0x80,%al
  802ce4:	75 7b                	jne    802d61 <get_phys_addr+0xdf>
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
    if (!(uvpd[VPD(va)] & PTE_P))
  802ce6:	48 89 f9             	mov    %rdi,%rcx
  802ce9:	48 c1 e9 15          	shr    $0x15,%rcx
  802ced:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  802cf4:	7f 00 00 
  802cf7:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  802cfb:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpd[VPD(va)] & PTE_P))
  802d02:	40 f6 c6 01          	test   $0x1,%sil
  802d06:	74 58                	je     802d60 <get_phys_addr+0xde>
    if ((uvpd[VPD(va)] & PTE_PS))
  802d08:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  802d0f:	7f 00 00 
  802d12:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802d16:	a8 80                	test   $0x80,%al
  802d18:	75 6c                	jne    802d86 <get_phys_addr+0x104>
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
    if (!(uvpt[VPT(va)] & PTE_P))
  802d1a:	48 89 f9             	mov    %rdi,%rcx
  802d1d:	48 c1 e9 0c          	shr    $0xc,%rcx
  802d21:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802d28:	7f 00 00 
  802d2b:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  802d2f:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpt[VPT(va)] & PTE_P))
  802d36:	40 f6 c6 01          	test   $0x1,%sil
  802d3a:	74 24                	je     802d60 <get_phys_addr+0xde>
    return PTE_ADDR(uvpt[VPT(va)]) + PAGE_OFFSET(va);
  802d3c:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802d43:	7f 00 00 
  802d46:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802d4a:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802d51:	ff ff 7f 
  802d54:	48 21 c8             	and    %rcx,%rax
  802d57:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  802d5d:	48 09 d0             	or     %rdx,%rax
}
  802d60:	c3                   	ret
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
  802d61:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802d68:	7f 00 00 
  802d6b:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802d6f:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802d76:	ff ff 7f 
  802d79:	48 21 c8             	and    %rcx,%rax
  802d7c:	81 e2 ff ff ff 3f    	and    $0x3fffffff,%edx
  802d82:	48 01 d0             	add    %rdx,%rax
  802d85:	c3                   	ret
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
  802d86:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  802d8d:	7f 00 00 
  802d90:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802d94:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802d9b:	ff ff 7f 
  802d9e:	48 21 c8             	and    %rcx,%rax
  802da1:	81 e2 ff ff 1f 00    	and    $0x1fffff,%edx
  802da7:	48 01 d0             	add    %rdx,%rax
  802daa:	c3                   	ret

0000000000802dab <get_prot>:

int
get_prot(void *va) {
  802dab:	f3 0f 1e fa          	endbr64
  802daf:	55                   	push   %rbp
  802db0:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802db3:	48 b8 ca 2b 80 00 00 	movabs $0x802bca,%rax
  802dba:	00 00 00 
  802dbd:	ff d0                	call   *%rax
  802dbf:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
    if (pte & PTE_P) prot |= PROT_R;
  802dc2:	83 e0 01             	and    $0x1,%eax
  802dc5:	c1 e0 02             	shl    $0x2,%eax
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  802dc8:	89 d1                	mov    %edx,%ecx
  802dca:	81 e1 00 0a 00 00    	and    $0xa00,%ecx
    if (pte & PTE_P) prot |= PROT_R;
  802dd0:	09 c8                	or     %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  802dd2:	89 c1                	mov    %eax,%ecx
  802dd4:	83 c9 02             	or     $0x2,%ecx
  802dd7:	f6 c2 02             	test   $0x2,%dl
  802dda:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  802ddd:	89 c1                	mov    %eax,%ecx
  802ddf:	83 c9 01             	or     $0x1,%ecx
  802de2:	48 85 d2             	test   %rdx,%rdx
  802de5:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  802de8:	89 c1                	mov    %eax,%ecx
  802dea:	83 c9 40             	or     $0x40,%ecx
  802ded:	f6 c6 04             	test   $0x4,%dh
  802df0:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  802df3:	5d                   	pop    %rbp
  802df4:	c3                   	ret

0000000000802df5 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  802df5:	f3 0f 1e fa          	endbr64
  802df9:	55                   	push   %rbp
  802dfa:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802dfd:	48 b8 ca 2b 80 00 00 	movabs $0x802bca,%rax
  802e04:	00 00 00 
  802e07:	ff d0                	call   *%rax
    return pte & PTE_D;
  802e09:	48 c1 e8 06          	shr    $0x6,%rax
  802e0d:	83 e0 01             	and    $0x1,%eax
}
  802e10:	5d                   	pop    %rbp
  802e11:	c3                   	ret

0000000000802e12 <is_page_present>:

bool
is_page_present(void *va) {
  802e12:	f3 0f 1e fa          	endbr64
  802e16:	55                   	push   %rbp
  802e17:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  802e1a:	48 b8 ca 2b 80 00 00 	movabs $0x802bca,%rax
  802e21:	00 00 00 
  802e24:	ff d0                	call   *%rax
  802e26:	83 e0 01             	and    $0x1,%eax
}
  802e29:	5d                   	pop    %rbp
  802e2a:	c3                   	ret

0000000000802e2b <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  802e2b:	f3 0f 1e fa          	endbr64
  802e2f:	55                   	push   %rbp
  802e30:	48 89 e5             	mov    %rsp,%rbp
  802e33:	41 57                	push   %r15
  802e35:	41 56                	push   %r14
  802e37:	41 55                	push   %r13
  802e39:	41 54                	push   %r12
  802e3b:	53                   	push   %rbx
  802e3c:	48 83 ec 18          	sub    $0x18,%rsp
  802e40:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  802e44:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
     * NOTE: Skip over larger pages/page directories for efficiency */
    // LAB 11: Your code here:

    int res = 0;
    (void)fun, (void)arg;
    uintptr_t va = 0;
  802e48:	bb 00 00 00 00       	mov    $0x0,%ebx
    while (va < USER_STACK_TOP) {
        size_t size = 0;
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  802e4d:	49 be 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%r14
  802e54:	7f 00 00 
            size = 1LL << PML4_SHIFT;
            goto next;
        }

        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802e57:	49 bd 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%r13
  802e5e:	7f 00 00 
    while (va < USER_STACK_TOP) {
  802e61:	49 bf ff 6f ff ff 7f 	movabs $0x7fffff6fff,%r15
  802e68:	00 00 00 
  802e6b:	eb 73                	jmp    802ee0 <foreach_shared_region+0xb5>
            }

            goto next;
        }

        if (!(uvpd[VPD(va)] & PTE_P)) {
  802e6d:	48 89 d8             	mov    %rbx,%rax
  802e70:	48 c1 e8 15          	shr    $0x15,%rax
  802e74:	48 b9 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rcx
  802e7b:	7f 00 00 
  802e7e:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
            size = 1LL << PD_SHIFT;
  802e82:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
        if (!(uvpd[VPD(va)] & PTE_P)) {
  802e88:	f6 c2 01             	test   $0x1,%dl
  802e8b:	74 4b                	je     802ed8 <foreach_shared_region+0xad>
            goto next;
        }

        if (uvpd[VPD(va)] & PTE_PS) {
  802e8d:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
  802e91:	f6 c2 80             	test   $0x80,%dl
  802e94:	74 11                	je     802ea7 <foreach_shared_region+0x7c>
            size = 1LL << PD_SHIFT;
            if (uvpd[VPD(va)] & PTE_SHARE) {
  802e96:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
  802e9a:	f6 c4 04             	test   $0x4,%ah
  802e9d:	74 39                	je     802ed8 <foreach_shared_region+0xad>
            size = 1LL << PD_SHIFT;
  802e9f:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
  802ea5:	eb 20                	jmp    802ec7 <foreach_shared_region+0x9c>

            goto next;
        }

        size = PAGE_SIZE;
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  802ea7:	48 89 da             	mov    %rbx,%rdx
  802eaa:	48 c1 ea 0c          	shr    $0xc,%rdx
  802eae:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802eb5:	7f 00 00 
  802eb8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
        size = PAGE_SIZE;
  802ebc:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  802ec2:	f6 c4 04             	test   $0x4,%ah
  802ec5:	74 11                	je     802ed8 <foreach_shared_region+0xad>
            goto next;
        }

    map:
        fun((void *)va, (void *)(va + size), arg);
  802ec7:	49 8d 34 1c          	lea    (%r12,%rbx,1),%rsi
  802ecb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802ecf:	48 89 df             	mov    %rbx,%rdi
  802ed2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802ed6:	ff d0                	call   *%rax
    next:
        va += size;
  802ed8:	4c 01 e3             	add    %r12,%rbx
    while (va < USER_STACK_TOP) {
  802edb:	49 39 df             	cmp    %rbx,%r15
  802ede:	72 3e                	jb     802f1e <foreach_shared_region+0xf3>
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  802ee0:	49 8b 06             	mov    (%r14),%rax
  802ee3:	a8 01                	test   $0x1,%al
  802ee5:	74 37                	je     802f1e <foreach_shared_region+0xf3>
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802ee7:	48 89 d8             	mov    %rbx,%rax
  802eea:	48 c1 e8 1e          	shr    $0x1e,%rax
  802eee:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
            size = 1LL << PDP_SHIFT;
  802ef3:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802ef9:	f6 c2 01             	test   $0x1,%dl
  802efc:	74 da                	je     802ed8 <foreach_shared_region+0xad>
        if (uvpdp[VPDP(va)] & PTE_PS) {
  802efe:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
  802f03:	f6 c2 80             	test   $0x80,%dl
  802f06:	0f 84 61 ff ff ff    	je     802e6d <foreach_shared_region+0x42>
            if (uvpdp[VPDP(va)] & PTE_SHARE) {
  802f0c:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  802f11:	f6 c4 04             	test   $0x4,%ah
  802f14:	74 c2                	je     802ed8 <foreach_shared_region+0xad>
            size = 1LL << PDP_SHIFT;
  802f16:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
  802f1c:	eb a9                	jmp    802ec7 <foreach_shared_region+0x9c>
    }
    return res;
}
  802f1e:	b8 00 00 00 00       	mov    $0x0,%eax
  802f23:	48 83 c4 18          	add    $0x18,%rsp
  802f27:	5b                   	pop    %rbx
  802f28:	41 5c                	pop    %r12
  802f2a:	41 5d                	pop    %r13
  802f2c:	41 5e                	pop    %r14
  802f2e:	41 5f                	pop    %r15
  802f30:	5d                   	pop    %rbp
  802f31:	c3                   	ret

0000000000802f32 <devcons_close>:

    return res;
}

static int
devcons_close(struct Fd *fd) {
  802f32:	f3 0f 1e fa          	endbr64
    USED(fd);

    return 0;
}
  802f36:	b8 00 00 00 00       	mov    $0x0,%eax
  802f3b:	c3                   	ret

0000000000802f3c <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  802f3c:	f3 0f 1e fa          	endbr64
  802f40:	55                   	push   %rbp
  802f41:	48 89 e5             	mov    %rsp,%rbp
  802f44:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  802f47:	48 be 78 43 80 00 00 	movabs $0x804378,%rsi
  802f4e:	00 00 00 
  802f51:	48 b8 2a 10 80 00 00 	movabs $0x80102a,%rax
  802f58:	00 00 00 
  802f5b:	ff d0                	call   *%rax
    return 0;
}
  802f5d:	b8 00 00 00 00       	mov    $0x0,%eax
  802f62:	5d                   	pop    %rbp
  802f63:	c3                   	ret

0000000000802f64 <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  802f64:	f3 0f 1e fa          	endbr64
  802f68:	55                   	push   %rbp
  802f69:	48 89 e5             	mov    %rsp,%rbp
  802f6c:	41 57                	push   %r15
  802f6e:	41 56                	push   %r14
  802f70:	41 55                	push   %r13
  802f72:	41 54                	push   %r12
  802f74:	53                   	push   %rbx
  802f75:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  802f7c:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  802f83:	48 85 d2             	test   %rdx,%rdx
  802f86:	74 7a                	je     803002 <devcons_write+0x9e>
  802f88:	49 89 d6             	mov    %rdx,%r14
  802f8b:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802f91:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  802f96:	49 bf 45 12 80 00 00 	movabs $0x801245,%r15
  802f9d:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  802fa0:	4c 89 f3             	mov    %r14,%rbx
  802fa3:	48 29 f3             	sub    %rsi,%rbx
  802fa6:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802fab:	48 39 c3             	cmp    %rax,%rbx
  802fae:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  802fb2:	4c 63 eb             	movslq %ebx,%r13
  802fb5:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  802fbc:	48 01 c6             	add    %rax,%rsi
  802fbf:	4c 89 ea             	mov    %r13,%rdx
  802fc2:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802fc9:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  802fcc:	4c 89 ee             	mov    %r13,%rsi
  802fcf:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802fd6:	48 b8 8a 14 80 00 00 	movabs $0x80148a,%rax
  802fdd:	00 00 00 
  802fe0:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  802fe2:	41 01 dc             	add    %ebx,%r12d
  802fe5:	49 63 f4             	movslq %r12d,%rsi
  802fe8:	4c 39 f6             	cmp    %r14,%rsi
  802feb:	72 b3                	jb     802fa0 <devcons_write+0x3c>
    return res;
  802fed:	49 63 c4             	movslq %r12d,%rax
}
  802ff0:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  802ff7:	5b                   	pop    %rbx
  802ff8:	41 5c                	pop    %r12
  802ffa:	41 5d                	pop    %r13
  802ffc:	41 5e                	pop    %r14
  802ffe:	41 5f                	pop    %r15
  803000:	5d                   	pop    %rbp
  803001:	c3                   	ret
    for (res = 0; res < n; res += inc) {
  803002:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  803008:	eb e3                	jmp    802fed <devcons_write+0x89>

000000000080300a <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  80300a:	f3 0f 1e fa          	endbr64
  80300e:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  803011:	ba 00 00 00 00       	mov    $0x0,%edx
  803016:	48 85 c0             	test   %rax,%rax
  803019:	74 55                	je     803070 <devcons_read+0x66>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  80301b:	55                   	push   %rbp
  80301c:	48 89 e5             	mov    %rsp,%rbp
  80301f:	41 55                	push   %r13
  803021:	41 54                	push   %r12
  803023:	53                   	push   %rbx
  803024:	48 83 ec 08          	sub    $0x8,%rsp
  803028:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  80302b:	48 bb bb 14 80 00 00 	movabs $0x8014bb,%rbx
  803032:	00 00 00 
  803035:	49 bc 94 15 80 00 00 	movabs $0x801594,%r12
  80303c:	00 00 00 
  80303f:	eb 03                	jmp    803044 <devcons_read+0x3a>
  803041:	41 ff d4             	call   *%r12
  803044:	ff d3                	call   *%rbx
  803046:	85 c0                	test   %eax,%eax
  803048:	74 f7                	je     803041 <devcons_read+0x37>
    if (c < 0) return c;
  80304a:	48 63 d0             	movslq %eax,%rdx
  80304d:	78 13                	js     803062 <devcons_read+0x58>
    if (c == 0x04) return 0;
  80304f:	ba 00 00 00 00       	mov    $0x0,%edx
  803054:	83 f8 04             	cmp    $0x4,%eax
  803057:	74 09                	je     803062 <devcons_read+0x58>
    *(char *)vbuf = (char)c;
  803059:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  80305d:	ba 01 00 00 00       	mov    $0x1,%edx
}
  803062:	48 89 d0             	mov    %rdx,%rax
  803065:	48 83 c4 08          	add    $0x8,%rsp
  803069:	5b                   	pop    %rbx
  80306a:	41 5c                	pop    %r12
  80306c:	41 5d                	pop    %r13
  80306e:	5d                   	pop    %rbp
  80306f:	c3                   	ret
  803070:	48 89 d0             	mov    %rdx,%rax
  803073:	c3                   	ret

0000000000803074 <cputchar>:
cputchar(int ch) {
  803074:	f3 0f 1e fa          	endbr64
  803078:	55                   	push   %rbp
  803079:	48 89 e5             	mov    %rsp,%rbp
  80307c:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  803080:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  803084:	be 01 00 00 00       	mov    $0x1,%esi
  803089:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  80308d:	48 b8 8a 14 80 00 00 	movabs $0x80148a,%rax
  803094:	00 00 00 
  803097:	ff d0                	call   *%rax
}
  803099:	c9                   	leave
  80309a:	c3                   	ret

000000000080309b <getchar>:
getchar(void) {
  80309b:	f3 0f 1e fa          	endbr64
  80309f:	55                   	push   %rbp
  8030a0:	48 89 e5             	mov    %rsp,%rbp
  8030a3:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  8030a7:	ba 01 00 00 00       	mov    $0x1,%edx
  8030ac:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  8030b0:	bf 00 00 00 00       	mov    $0x0,%edi
  8030b5:	48 b8 e4 1e 80 00 00 	movabs $0x801ee4,%rax
  8030bc:	00 00 00 
  8030bf:	ff d0                	call   *%rax
  8030c1:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  8030c3:	85 c0                	test   %eax,%eax
  8030c5:	78 06                	js     8030cd <getchar+0x32>
  8030c7:	74 08                	je     8030d1 <getchar+0x36>
  8030c9:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  8030cd:	89 d0                	mov    %edx,%eax
  8030cf:	c9                   	leave
  8030d0:	c3                   	ret
    return res < 0 ? res : res ? c :
  8030d1:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  8030d6:	eb f5                	jmp    8030cd <getchar+0x32>

00000000008030d8 <iscons>:
iscons(int fdnum) {
  8030d8:	f3 0f 1e fa          	endbr64
  8030dc:	55                   	push   %rbp
  8030dd:	48 89 e5             	mov    %rsp,%rbp
  8030e0:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8030e4:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8030e8:	48 b8 e9 1b 80 00 00 	movabs $0x801be9,%rax
  8030ef:	00 00 00 
  8030f2:	ff d0                	call   *%rax
    if (res < 0) return res;
  8030f4:	85 c0                	test   %eax,%eax
  8030f6:	78 18                	js     803110 <iscons+0x38>
    return fd->fd_dev_id == devcons.dev_id;
  8030f8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8030fc:	48 b8 a0 50 80 00 00 	movabs $0x8050a0,%rax
  803103:	00 00 00 
  803106:	8b 00                	mov    (%rax),%eax
  803108:	39 02                	cmp    %eax,(%rdx)
  80310a:	0f 94 c0             	sete   %al
  80310d:	0f b6 c0             	movzbl %al,%eax
}
  803110:	c9                   	leave
  803111:	c3                   	ret

0000000000803112 <opencons>:
opencons(void) {
  803112:	f3 0f 1e fa          	endbr64
  803116:	55                   	push   %rbp
  803117:	48 89 e5             	mov    %rsp,%rbp
  80311a:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  80311e:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  803122:	48 b8 85 1b 80 00 00 	movabs $0x801b85,%rax
  803129:	00 00 00 
  80312c:	ff d0                	call   *%rax
  80312e:	85 c0                	test   %eax,%eax
  803130:	78 49                	js     80317b <opencons+0x69>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  803132:	b9 46 00 00 00       	mov    $0x46,%ecx
  803137:	ba 00 10 00 00       	mov    $0x1000,%edx
  80313c:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  803140:	bf 00 00 00 00       	mov    $0x0,%edi
  803145:	48 b8 2f 16 80 00 00 	movabs $0x80162f,%rax
  80314c:	00 00 00 
  80314f:	ff d0                	call   *%rax
  803151:	85 c0                	test   %eax,%eax
  803153:	78 26                	js     80317b <opencons+0x69>
    fd->fd_dev_id = devcons.dev_id;
  803155:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803159:	a1 a0 50 80 00 00 00 	movabs 0x8050a0,%eax
  803160:	00 00 
  803162:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  803164:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  803168:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  80316f:	48 b8 4f 1b 80 00 00 	movabs $0x801b4f,%rax
  803176:	00 00 00 
  803179:	ff d0                	call   *%rax
}
  80317b:	c9                   	leave
  80317c:	c3                   	ret

000000000080317d <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
    # Call the C page fault handler.
    movq  %rsp,%rdi # passing the function argument in rdi
  80317d:	48 89 e7             	mov    %rsp,%rdi
    movabs $_handle_vectored_pagefault, %rax
  803180:	48 b8 bc 33 80 00 00 	movabs $0x8033bc,%rax
  803187:	00 00 00 
    call *%rax
  80318a:	ff d0                	call   *%rax
    # registers are available for intermediate calculations.  You
    # may find that you have to rearrange your code in non-obvious
    # ways as registers become unavailable as scratch space.

    # LAB 9: Your code here
    movq %rsp, %rax
  80318c:	48 89 e0             	mov    %rsp,%rax
    movq UTRAP_RIP(%rsp), %rbx
  80318f:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  803196:	00 
    movq UTRAP_RSP(%rsp), %rsp
  803197:	48 8b a4 24 98 00 00 	mov    0x98(%rsp),%rsp
  80319e:	00 
    pushq %rbx
  80319f:	53                   	push   %rbx
    movq %rsp, UTRAP_RSP(%rax)
  8031a0:	48 89 a0 98 00 00 00 	mov    %rsp,0x98(%rax)

    # Restore the trap-time registers.  After you do this, you
    # can no longer modify any general-purpose registers (use POPA macro).
    # LAB 9: Your code here
    movq %rax, %rsp
  8031a7:	48 89 c4             	mov    %rax,%rsp
    addq $16, %rsp
  8031aa:	48 83 c4 10          	add    $0x10,%rsp
    POPA
  8031ae:	4c 8b 3c 24          	mov    (%rsp),%r15
  8031b2:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  8031b7:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  8031bc:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  8031c1:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  8031c6:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  8031cb:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  8031d0:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  8031d5:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  8031da:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  8031df:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  8031e4:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  8031e9:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  8031ee:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  8031f3:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8031f8:	48 83 c4 78          	add    $0x78,%rsp
    addq $8, %rsp
  8031fc:	48 83 c4 08          	add    $0x8,%rsp
    # Restore rflags from the stack.  After you do this, you can
    # no longer use arithmetic operations or anything else that
    # modifies rflags.
    # LAB 9: Your code here
	popfq
  803200:	9d                   	popf
    # Switch back to the adjusted trap-time stack.
    # LAB 9: Your code here
	popq %rsp
  803201:	5c                   	pop    %rsp
    # Return to re-execute the instruction that faulted.
    ret
  803202:	c3                   	ret

0000000000803203 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  803203:	f3 0f 1e fa          	endbr64
  803207:	55                   	push   %rbp
  803208:	48 89 e5             	mov    %rsp,%rbp
  80320b:	41 54                	push   %r12
  80320d:	53                   	push   %rbx
  80320e:	48 89 fb             	mov    %rdi,%rbx
  803211:	48 89 f7             	mov    %rsi,%rdi
  803214:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  803217:	48 85 f6             	test   %rsi,%rsi
  80321a:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  803221:	00 00 00 
  803224:	48 0f 44 f8          	cmove  %rax,%rdi
    }
    int res = sys_ipc_recv(pg, PAGE_SIZE);
  803228:	be 00 10 00 00       	mov    $0x1000,%esi
  80322d:	48 b8 51 19 80 00 00 	movabs $0x801951,%rax
  803234:	00 00 00 
  803237:	ff d0                	call   *%rax
    if (res < 0) {
  803239:	85 c0                	test   %eax,%eax
  80323b:	78 45                	js     803282 <ipc_recv+0x7f>
        if (perm_store != NULL) {
            *perm_store = 0;
        }
        return res;
    } else {
        if (from_env_store != NULL) {
  80323d:	48 85 db             	test   %rbx,%rbx
  803240:	74 12                	je     803254 <ipc_recv+0x51>
            *from_env_store = thisenv->env_ipc_from;
  803242:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  803249:	00 00 00 
  80324c:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  803252:	89 03                	mov    %eax,(%rbx)
        }
        if (perm_store != NULL) {
  803254:	4d 85 e4             	test   %r12,%r12
  803257:	74 14                	je     80326d <ipc_recv+0x6a>
            *perm_store = thisenv->env_ipc_perm;
  803259:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  803260:	00 00 00 
  803263:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  803269:	41 89 04 24          	mov    %eax,(%r12)
        }
        return thisenv->env_ipc_value;
  80326d:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  803274:	00 00 00 
  803277:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
    }
    return -1;
}
  80327d:	5b                   	pop    %rbx
  80327e:	41 5c                	pop    %r12
  803280:	5d                   	pop    %rbp
  803281:	c3                   	ret
        if (from_env_store != NULL) {
  803282:	48 85 db             	test   %rbx,%rbx
  803285:	74 06                	je     80328d <ipc_recv+0x8a>
            *from_env_store = 0;
  803287:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store != NULL) {
  80328d:	4d 85 e4             	test   %r12,%r12
  803290:	74 eb                	je     80327d <ipc_recv+0x7a>
            *perm_store = 0;
  803292:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  803299:	00 
  80329a:	eb e1                	jmp    80327d <ipc_recv+0x7a>

000000000080329c <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  80329c:	f3 0f 1e fa          	endbr64
  8032a0:	55                   	push   %rbp
  8032a1:	48 89 e5             	mov    %rsp,%rbp
  8032a4:	41 57                	push   %r15
  8032a6:	41 56                	push   %r14
  8032a8:	41 55                	push   %r13
  8032aa:	41 54                	push   %r12
  8032ac:	53                   	push   %rbx
  8032ad:	48 83 ec 18          	sub    $0x18,%rsp
  8032b1:	89 7d c4             	mov    %edi,-0x3c(%rbp)
  8032b4:	48 89 d3             	mov    %rdx,%rbx
  8032b7:	49 89 cc             	mov    %rcx,%r12
  8032ba:	45 89 c5             	mov    %r8d,%r13d
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  8032bd:	48 85 d2             	test   %rdx,%rdx
  8032c0:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  8032c7:	00 00 00 
  8032ca:	48 0f 44 d8          	cmove  %rax,%rbx
    }
    int res = sys_ipc_try_send(to_env, val, pg, size, perm);
  8032ce:	89 f0                	mov    %esi,%eax
  8032d0:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  8032d4:	48 89 da             	mov    %rbx,%rdx
  8032d7:	48 89 c6             	mov    %rax,%rsi
  8032da:	48 b8 21 19 80 00 00 	movabs $0x801921,%rax
  8032e1:	00 00 00 
  8032e4:	ff d0                	call   *%rax
    while (res < 0) {
  8032e6:	85 c0                	test   %eax,%eax
  8032e8:	79 65                	jns    80334f <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  8032ea:	83 f8 f5             	cmp    $0xfffffff5,%eax
  8032ed:	75 33                	jne    803322 <ipc_send+0x86>
            panic("Error: %i\n", res);
        }
        sys_yield();
  8032ef:	49 bf 94 15 80 00 00 	movabs $0x801594,%r15
  8032f6:	00 00 00 
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  8032f9:	49 be 21 19 80 00 00 	movabs $0x801921,%r14
  803300:	00 00 00 
        sys_yield();
  803303:	41 ff d7             	call   *%r15
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  803306:	45 89 e8             	mov    %r13d,%r8d
  803309:	4c 89 e1             	mov    %r12,%rcx
  80330c:	48 89 da             	mov    %rbx,%rdx
  80330f:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  803313:	8b 7d c4             	mov    -0x3c(%rbp),%edi
  803316:	41 ff d6             	call   *%r14
    while (res < 0) {
  803319:	85 c0                	test   %eax,%eax
  80331b:	79 32                	jns    80334f <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  80331d:	83 f8 f5             	cmp    $0xfffffff5,%eax
  803320:	74 e1                	je     803303 <ipc_send+0x67>
            panic("Error: %i\n", res);
  803322:	89 c1                	mov    %eax,%ecx
  803324:	48 ba 84 43 80 00 00 	movabs $0x804384,%rdx
  80332b:	00 00 00 
  80332e:	be 42 00 00 00       	mov    $0x42,%esi
  803333:	48 bf 8f 43 80 00 00 	movabs $0x80438f,%rdi
  80333a:	00 00 00 
  80333d:	b8 00 00 00 00       	mov    $0x0,%eax
  803342:	49 b8 85 05 80 00 00 	movabs $0x800585,%r8
  803349:	00 00 00 
  80334c:	41 ff d0             	call   *%r8
    }
}
  80334f:	48 83 c4 18          	add    $0x18,%rsp
  803353:	5b                   	pop    %rbx
  803354:	41 5c                	pop    %r12
  803356:	41 5d                	pop    %r13
  803358:	41 5e                	pop    %r14
  80335a:	41 5f                	pop    %r15
  80335c:	5d                   	pop    %rbp
  80335d:	c3                   	ret

000000000080335e <ipc_find_env>:

/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
  80335e:	f3 0f 1e fa          	endbr64
    for (size_t i = 0; i < NENV; i++)
  803362:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  803367:	48 b9 00 00 a0 1f 80 	movabs $0x801fa00000,%rcx
  80336e:	00 00 00 
  803371:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  803375:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  803379:	48 c1 e2 04          	shl    $0x4,%rdx
  80337d:	48 01 ca             	add    %rcx,%rdx
  803380:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  803386:	39 fa                	cmp    %edi,%edx
  803388:	74 12                	je     80339c <ipc_find_env+0x3e>
    for (size_t i = 0; i < NENV; i++)
  80338a:	48 83 c0 01          	add    $0x1,%rax
  80338e:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  803394:	75 db                	jne    803371 <ipc_find_env+0x13>
            return envs[i].env_id;
    return 0;
  803396:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80339b:	c3                   	ret
            return envs[i].env_id;
  80339c:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8033a0:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  8033a4:	48 c1 e2 04          	shl    $0x4,%rdx
  8033a8:	48 b8 00 00 a0 1f 80 	movabs $0x801fa00000,%rax
  8033af:	00 00 00 
  8033b2:	48 01 d0             	add    %rdx,%rax
  8033b5:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8033bb:	c3                   	ret

00000000008033bc <_handle_vectored_pagefault>:
/* Vector size */
static size_t _pfhandler_off = 0;
static bool _pfhandler_inititiallized = 0;

void
_handle_vectored_pagefault(struct UTrapframe *utf) {
  8033bc:	f3 0f 1e fa          	endbr64
  8033c0:	55                   	push   %rbp
  8033c1:	48 89 e5             	mov    %rsp,%rbp
  8033c4:	41 56                	push   %r14
  8033c6:	41 55                	push   %r13
  8033c8:	41 54                	push   %r12
  8033ca:	53                   	push   %rbx
  8033cb:	49 89 fc             	mov    %rdi,%r12
    /* This trying to handle pagefault until
     * some handler returns 1, that indicates
     * successfully handled exception */
    for (size_t i = 0; i < _pfhandler_off; i++)
  8033ce:	48 b8 68 80 80 00 00 	movabs $0x808068,%rax
  8033d5:	00 00 00 
  8033d8:	48 83 38 00          	cmpq   $0x0,(%rax)
  8033dc:	74 27                	je     803405 <_handle_vectored_pagefault+0x49>
  8033de:	bb 00 00 00 00       	mov    $0x0,%ebx
        if (_pfhandler_vec[i](utf)) return;
  8033e3:	49 bd 20 80 80 00 00 	movabs $0x808020,%r13
  8033ea:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++)
  8033ed:	49 89 c6             	mov    %rax,%r14
        if (_pfhandler_vec[i](utf)) return;
  8033f0:	4c 89 e7             	mov    %r12,%rdi
  8033f3:	41 ff 54 dd 00       	call   *0x0(%r13,%rbx,8)
  8033f8:	84 c0                	test   %al,%al
  8033fa:	75 45                	jne    803441 <_handle_vectored_pagefault+0x85>
    for (size_t i = 0; i < _pfhandler_off; i++)
  8033fc:	48 83 c3 01          	add    $0x1,%rbx
  803400:	49 3b 1e             	cmp    (%r14),%rbx
  803403:	72 eb                	jb     8033f0 <_handle_vectored_pagefault+0x34>

    /* Unhandled exceptions just cause panic */
    panic("Userspace page fault rip=%08lX va=%08lX err=%x\n",
  803405:	49 8b 8c 24 88 00 00 	mov    0x88(%r12),%rcx
  80340c:	00 
  80340d:	45 8b 4c 24 08       	mov    0x8(%r12),%r9d
  803412:	4d 8b 04 24          	mov    (%r12),%r8
  803416:	48 ba 00 45 80 00 00 	movabs $0x804500,%rdx
  80341d:	00 00 00 
  803420:	be 1d 00 00 00       	mov    $0x1d,%esi
  803425:	48 bf 99 43 80 00 00 	movabs $0x804399,%rdi
  80342c:	00 00 00 
  80342f:	b8 00 00 00 00       	mov    $0x0,%eax
  803434:	49 ba 85 05 80 00 00 	movabs $0x800585,%r10
  80343b:	00 00 00 
  80343e:	41 ff d2             	call   *%r10
          utf->utf_rip, utf->utf_fault_va, (int)utf->utf_err);
}
  803441:	5b                   	pop    %rbx
  803442:	41 5c                	pop    %r12
  803444:	41 5d                	pop    %r13
  803446:	41 5e                	pop    %r14
  803448:	5d                   	pop    %rbp
  803449:	c3                   	ret

000000000080344a <add_pgfault_handler>:
 * The first time we register a handler, we need to
 * allocate an exception stack (one page of memory with its top
 * at USER_EXCEPTION_STACK_TOP), and tell the kernel to call the assembly-language
 * _pgfault_upcall routine when a page fault occurs. */
int
add_pgfault_handler(pf_handler_t handler) {
  80344a:	f3 0f 1e fa          	endbr64
  80344e:	55                   	push   %rbp
  80344f:	48 89 e5             	mov    %rsp,%rbp
  803452:	53                   	push   %rbx
  803453:	48 83 ec 08          	sub    $0x8,%rsp
  803457:	48 89 fb             	mov    %rdi,%rbx
    int res = 0;
    if (!_pfhandler_inititiallized) {
  80345a:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  803461:	00 00 00 
  803464:	80 38 00             	cmpb   $0x0,(%rax)
  803467:	0f 84 84 00 00 00    	je     8034f1 <add_pgfault_handler+0xa7>
        _pfhandler_vec[_pfhandler_off++] = handler;
        _pfhandler_inititiallized = 1;
        goto end;
    }

    for (size_t i = 0; i < _pfhandler_off; i++)
  80346d:	48 b8 68 80 80 00 00 	movabs $0x808068,%rax
  803474:	00 00 00 
  803477:	48 8b 10             	mov    (%rax),%rdx
  80347a:	b8 00 00 00 00       	mov    $0x0,%eax
        if (handler == _pfhandler_vec[i]) return 0;
  80347f:	48 b9 20 80 80 00 00 	movabs $0x808020,%rcx
  803486:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++)
  803489:	48 85 d2             	test   %rdx,%rdx
  80348c:	74 19                	je     8034a7 <add_pgfault_handler+0x5d>
        if (handler == _pfhandler_vec[i]) return 0;
  80348e:	48 39 1c c1          	cmp    %rbx,(%rcx,%rax,8)
  803492:	0f 84 e8 00 00 00    	je     803580 <add_pgfault_handler+0x136>
    for (size_t i = 0; i < _pfhandler_off; i++)
  803498:	48 83 c0 01          	add    $0x1,%rax
  80349c:	48 39 d0             	cmp    %rdx,%rax
  80349f:	75 ed                	jne    80348e <add_pgfault_handler+0x44>

    if (_pfhandler_off == MAX_PFHANDLER)
  8034a1:	48 83 fa 08          	cmp    $0x8,%rdx
  8034a5:	74 1c                	je     8034c3 <add_pgfault_handler+0x79>
        res = -E_INVAL;
    else
        _pfhandler_vec[_pfhandler_off++] = handler;
  8034a7:	48 8d 42 01          	lea    0x1(%rdx),%rax
  8034ab:	48 a3 68 80 80 00 00 	movabs %rax,0x808068
  8034b2:	00 00 00 
  8034b5:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8034bc:	00 00 00 
  8034bf:	48 89 1c d0          	mov    %rbx,(%rax,%rdx,8)

end:
    res = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  8034c3:	48 b8 5f 15 80 00 00 	movabs $0x80155f,%rax
  8034ca:	00 00 00 
  8034cd:	ff d0                	call   *%rax
  8034cf:	89 c7                	mov    %eax,%edi
  8034d1:	48 be 7d 31 80 00 00 	movabs $0x80317d,%rsi
  8034d8:	00 00 00 
  8034db:	48 b8 b4 18 80 00 00 	movabs $0x8018b4,%rax
  8034e2:	00 00 00 
  8034e5:	ff d0                	call   *%rax
    if (res < 0) panic("set_pgfault_handler: %i", res);
  8034e7:	85 c0                	test   %eax,%eax
  8034e9:	78 68                	js     803553 <add_pgfault_handler+0x109>
    return res;
}
  8034eb:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8034ef:	c9                   	leave
  8034f0:	c3                   	ret
        res = sys_alloc_region(sys_getenvid(), (void*)(USER_EXCEPTION_STACK_TOP - PAGE_SIZE), PAGE_SIZE, PROT_RW);
  8034f1:	48 b8 5f 15 80 00 00 	movabs $0x80155f,%rax
  8034f8:	00 00 00 
  8034fb:	ff d0                	call   *%rax
  8034fd:	89 c7                	mov    %eax,%edi
  8034ff:	b9 06 00 00 00       	mov    $0x6,%ecx
  803504:	ba 00 10 00 00       	mov    $0x1000,%edx
  803509:	48 be 00 f0 ff ff 7f 	movabs $0x7ffffff000,%rsi
  803510:	00 00 00 
  803513:	48 b8 2f 16 80 00 00 	movabs $0x80162f,%rax
  80351a:	00 00 00 
  80351d:	ff d0                	call   *%rax
        _pfhandler_vec[_pfhandler_off++] = handler;
  80351f:	48 ba 68 80 80 00 00 	movabs $0x808068,%rdx
  803526:	00 00 00 
  803529:	48 8b 02             	mov    (%rdx),%rax
  80352c:	48 8d 48 01          	lea    0x1(%rax),%rcx
  803530:	48 89 0a             	mov    %rcx,(%rdx)
  803533:	48 ba 20 80 80 00 00 	movabs $0x808020,%rdx
  80353a:	00 00 00 
  80353d:	48 89 1c c2          	mov    %rbx,(%rdx,%rax,8)
        _pfhandler_inititiallized = 1;
  803541:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  803548:	00 00 00 
  80354b:	c6 00 01             	movb   $0x1,(%rax)
        goto end;
  80354e:	e9 70 ff ff ff       	jmp    8034c3 <add_pgfault_handler+0x79>
    if (res < 0) panic("set_pgfault_handler: %i", res);
  803553:	89 c1                	mov    %eax,%ecx
  803555:	48 ba a7 43 80 00 00 	movabs $0x8043a7,%rdx
  80355c:	00 00 00 
  80355f:	be 3d 00 00 00       	mov    $0x3d,%esi
  803564:	48 bf 99 43 80 00 00 	movabs $0x804399,%rdi
  80356b:	00 00 00 
  80356e:	b8 00 00 00 00       	mov    $0x0,%eax
  803573:	49 b8 85 05 80 00 00 	movabs $0x800585,%r8
  80357a:	00 00 00 
  80357d:	41 ff d0             	call   *%r8
        if (handler == _pfhandler_vec[i]) return 0;
  803580:	b8 00 00 00 00       	mov    $0x0,%eax
  803585:	e9 61 ff ff ff       	jmp    8034eb <add_pgfault_handler+0xa1>

000000000080358a <remove_pgfault_handler>:

void
remove_pgfault_handler(pf_handler_t handler) {
  80358a:	f3 0f 1e fa          	endbr64
  80358e:	55                   	push   %rbp
  80358f:	48 89 e5             	mov    %rsp,%rbp
    assert(_pfhandler_inititiallized);
  803592:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  803599:	00 00 00 
  80359c:	80 38 00             	cmpb   $0x0,(%rax)
  80359f:	74 33                	je     8035d4 <remove_pgfault_handler+0x4a>
    for (size_t i = 0; i < _pfhandler_off; i++) {
  8035a1:	48 a1 68 80 80 00 00 	movabs 0x808068,%rax
  8035a8:	00 00 00 
  8035ab:	b9 00 00 00 00       	mov    $0x0,%ecx
        if (_pfhandler_vec[i] == handler) {
  8035b0:	48 ba 20 80 80 00 00 	movabs $0x808020,%rdx
  8035b7:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++) {
  8035ba:	48 85 c0             	test   %rax,%rax
  8035bd:	0f 84 85 00 00 00    	je     803648 <remove_pgfault_handler+0xbe>
        if (_pfhandler_vec[i] == handler) {
  8035c3:	48 39 3c ca          	cmp    %rdi,(%rdx,%rcx,8)
  8035c7:	74 40                	je     803609 <remove_pgfault_handler+0x7f>
    for (size_t i = 0; i < _pfhandler_off; i++) {
  8035c9:	48 83 c1 01          	add    $0x1,%rcx
  8035cd:	48 39 c1             	cmp    %rax,%rcx
  8035d0:	75 f1                	jne    8035c3 <remove_pgfault_handler+0x39>
  8035d2:	eb 74                	jmp    803648 <remove_pgfault_handler+0xbe>
    assert(_pfhandler_inititiallized);
  8035d4:	48 b9 bf 43 80 00 00 	movabs $0x8043bf,%rcx
  8035db:	00 00 00 
  8035de:	48 ba 2b 43 80 00 00 	movabs $0x80432b,%rdx
  8035e5:	00 00 00 
  8035e8:	be 43 00 00 00       	mov    $0x43,%esi
  8035ed:	48 bf 99 43 80 00 00 	movabs $0x804399,%rdi
  8035f4:	00 00 00 
  8035f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8035fc:	49 b8 85 05 80 00 00 	movabs $0x800585,%r8
  803603:	00 00 00 
  803606:	41 ff d0             	call   *%r8
            memmove(_pfhandler_vec + i, _pfhandler_vec + i + 1, (_pfhandler_off - i - 1) * sizeof(*handler));
  803609:	48 8d 34 cd 08 00 00 	lea    0x8(,%rcx,8),%rsi
  803610:	00 
  803611:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  803615:	48 29 ca             	sub    %rcx,%rdx
  803618:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  80361f:	00 00 00 
  803622:	48 8d 0c 06          	lea    (%rsi,%rax,1),%rcx
  803626:	48 8d 7c 30 f8       	lea    -0x8(%rax,%rsi,1),%rdi
  80362b:	48 89 ce             	mov    %rcx,%rsi
  80362e:	48 b8 45 12 80 00 00 	movabs $0x801245,%rax
  803635:	00 00 00 
  803638:	ff d0                	call   *%rax
            _pfhandler_off--;
  80363a:	48 b8 68 80 80 00 00 	movabs $0x808068,%rax
  803641:	00 00 00 
  803644:	48 83 28 01          	subq   $0x1,(%rax)
            return;
        }
    }
}
  803648:	5d                   	pop    %rbp
  803649:	c3                   	ret

000000000080364a <__text_end>:
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
