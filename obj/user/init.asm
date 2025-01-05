
obj/user/init:     file format elf64-x86-64


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
  80001e:	e8 6a 05 00 00       	call   80058d <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <sum>:
        "so is this"};

char bss[6000];

int
sum(const char *s, int n) {
  800025:	f3 0f 1e fa          	endbr64
    int i, tot = 0;
    for (i = 0; i < n; i++)
  800029:	85 f6                	test   %esi,%esi
  80002b:	7e 22                	jle    80004f <sum+0x2a>
  80002d:	48 63 f6             	movslq %esi,%rsi
  800030:	b8 00 00 00 00       	mov    $0x0,%eax
    int i, tot = 0;
  800035:	b9 00 00 00 00       	mov    $0x0,%ecx
        tot ^= i * s[i];
  80003a:	0f be 14 07          	movsbl (%rdi,%rax,1),%edx
  80003e:	0f af d0             	imul   %eax,%edx
  800041:	31 d1                	xor    %edx,%ecx
    for (i = 0; i < n; i++)
  800043:	48 83 c0 01          	add    $0x1,%rax
  800047:	48 39 f0             	cmp    %rsi,%rax
  80004a:	75 ee                	jne    80003a <sum+0x15>
    return tot;
}
  80004c:	89 c8                	mov    %ecx,%eax
  80004e:	c3                   	ret
    int i, tot = 0;
  80004f:	b9 00 00 00 00       	mov    $0x0,%ecx
    return tot;
  800054:	eb f6                	jmp    80004c <sum+0x27>

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
  800067:	48 81 ec 08 01 00 00 	sub    $0x108,%rsp
  80006e:	41 89 fc             	mov    %edi,%r12d
  800071:	49 89 f5             	mov    %rsi,%r13
    int i, r, x, want;
    char args[256];

    cprintf("init: running\n");
  800074:	48 bf 00 40 80 00 00 	movabs $0x804000,%rdi
  80007b:	00 00 00 
  80007e:	b8 00 00 00 00       	mov    $0x0,%eax
  800083:	48 ba c2 07 80 00 00 	movabs $0x8007c2,%rdx
  80008a:	00 00 00 
  80008d:	ff d2                	call   *%rdx

    want = 0xf989e;
    if ((x = sum((char *)&data, sizeof data)) != want)
  80008f:	be 70 17 00 00       	mov    $0x1770,%esi
  800094:	48 bf 00 50 80 00 00 	movabs $0x805000,%rdi
  80009b:	00 00 00 
  80009e:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  8000a5:	00 00 00 
  8000a8:	ff d0                	call   *%rax
  8000aa:	3d 9e 98 0f 00       	cmp    $0xf989e,%eax
  8000af:	0f 84 64 01 00 00    	je     800219 <umain+0x1c3>
        cprintf("init: data is not initialized: got sum %08x wanted %08x\n",
  8000b5:	ba 9e 98 0f 00       	mov    $0xf989e,%edx
  8000ba:	89 c6                	mov    %eax,%esi
  8000bc:	48 bf a0 43 80 00 00 	movabs $0x8043a0,%rdi
  8000c3:	00 00 00 
  8000c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8000cb:	48 b9 c2 07 80 00 00 	movabs $0x8007c2,%rcx
  8000d2:	00 00 00 
  8000d5:	ff d1                	call   *%rcx
                x, want);
    else
        cprintf("init: data seems okay\n");
    if ((x = sum(bss, sizeof bss)) != 0)
  8000d7:	be 70 17 00 00       	mov    $0x1770,%esi
  8000dc:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  8000e3:	00 00 00 
  8000e6:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  8000ed:	00 00 00 
  8000f0:	ff d0                	call   *%rax
  8000f2:	85 c0                	test   %eax,%eax
  8000f4:	0f 84 3f 01 00 00    	je     800239 <umain+0x1e3>
        cprintf("bss is not initialized: wanted sum 0 got %08x\n", x);
  8000fa:	89 c6                	mov    %eax,%esi
  8000fc:	48 bf e0 43 80 00 00 	movabs $0x8043e0,%rdi
  800103:	00 00 00 
  800106:	b8 00 00 00 00       	mov    $0x0,%eax
  80010b:	48 ba c2 07 80 00 00 	movabs $0x8007c2,%rdx
  800112:	00 00 00 
  800115:	ff d2                	call   *%rdx
    else
        cprintf("init: bss seems okay\n");

    /* Output in one syscall per line to avoid output interleaving */
    strcat(args, "init: args:");
  800117:	48 be 3c 40 80 00 00 	movabs $0x80403c,%rsi
  80011e:	00 00 00 
  800121:	48 8d bd d0 fe ff ff 	lea    -0x130(%rbp),%rdi
  800128:	48 b8 27 11 80 00 00 	movabs $0x801127,%rax
  80012f:	00 00 00 
  800132:	ff d0                	call   *%rax
    for (i = 0; i < argc; i++) {
  800134:	45 85 e4             	test   %r12d,%r12d
  800137:	7e 59                	jle    800192 <umain+0x13c>
  800139:	4c 89 eb             	mov    %r13,%rbx
  80013c:	4d 63 e4             	movslq %r12d,%r12
  80013f:	4f 8d 7c e5 00       	lea    0x0(%r13,%r12,8),%r15
        strcat(args, " '");
  800144:	49 be 48 40 80 00 00 	movabs $0x804048,%r14
  80014b:	00 00 00 
  80014e:	49 bc 27 11 80 00 00 	movabs $0x801127,%r12
  800155:	00 00 00 
        strcat(args, argv[i]);
        strcat(args, "'");
  800158:	49 bd 49 40 80 00 00 	movabs $0x804049,%r13
  80015f:	00 00 00 
        strcat(args, " '");
  800162:	4c 89 f6             	mov    %r14,%rsi
  800165:	48 8d bd d0 fe ff ff 	lea    -0x130(%rbp),%rdi
  80016c:	41 ff d4             	call   *%r12
        strcat(args, argv[i]);
  80016f:	48 8b 33             	mov    (%rbx),%rsi
  800172:	48 8d bd d0 fe ff ff 	lea    -0x130(%rbp),%rdi
  800179:	41 ff d4             	call   *%r12
        strcat(args, "'");
  80017c:	4c 89 ee             	mov    %r13,%rsi
  80017f:	48 8d bd d0 fe ff ff 	lea    -0x130(%rbp),%rdi
  800186:	41 ff d4             	call   *%r12
    for (i = 0; i < argc; i++) {
  800189:	48 83 c3 08          	add    $0x8,%rbx
  80018d:	4c 39 fb             	cmp    %r15,%rbx
  800190:	75 d0                	jne    800162 <umain+0x10c>
    }
    cprintf("%s\n", args);
  800192:	48 8d b5 d0 fe ff ff 	lea    -0x130(%rbp),%rsi
  800199:	48 bf 4b 40 80 00 00 	movabs $0x80404b,%rdi
  8001a0:	00 00 00 
  8001a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a8:	48 bb c2 07 80 00 00 	movabs $0x8007c2,%rbx
  8001af:	00 00 00 
  8001b2:	ff d3                	call   *%rbx

    cprintf("init: running sh\n");
  8001b4:	48 bf 4f 40 80 00 00 	movabs $0x80404f,%rdi
  8001bb:	00 00 00 
  8001be:	b8 00 00 00 00       	mov    $0x0,%eax
  8001c3:	ff d3                	call   *%rbx

    /* Being run directly from kernel, so no file descriptors open yet */
    close(0);
  8001c5:	bf 00 00 00 00       	mov    $0x0,%edi
  8001ca:	48 b8 df 1c 80 00 00 	movabs $0x801cdf,%rax
  8001d1:	00 00 00 
  8001d4:	ff d0                	call   *%rax
    if ((r = opencons()) < 0)
  8001d6:	48 b8 22 05 80 00 00 	movabs $0x800522,%rax
  8001dd:	00 00 00 
  8001e0:	ff d0                	call   *%rax
  8001e2:	85 c0                	test   %eax,%eax
  8001e4:	78 73                	js     800259 <umain+0x203>
        panic("opencons: %i", r);
    if (r != 0)
  8001e6:	0f 84 9a 00 00 00    	je     800286 <umain+0x230>
        panic("first opencons used fd %d", r);
  8001ec:	89 c1                	mov    %eax,%ecx
  8001ee:	48 ba 7a 40 80 00 00 	movabs $0x80407a,%rdx
  8001f5:	00 00 00 
  8001f8:	be 36 00 00 00       	mov    $0x36,%esi
  8001fd:	48 bf 6e 40 80 00 00 	movabs $0x80406e,%rdi
  800204:	00 00 00 
  800207:	b8 00 00 00 00       	mov    $0x0,%eax
  80020c:	49 b8 66 06 80 00 00 	movabs $0x800666,%r8
  800213:	00 00 00 
  800216:	41 ff d0             	call   *%r8
        cprintf("init: data seems okay\n");
  800219:	48 bf 0f 40 80 00 00 	movabs $0x80400f,%rdi
  800220:	00 00 00 
  800223:	b8 00 00 00 00       	mov    $0x0,%eax
  800228:	48 ba c2 07 80 00 00 	movabs $0x8007c2,%rdx
  80022f:	00 00 00 
  800232:	ff d2                	call   *%rdx
  800234:	e9 9e fe ff ff       	jmp    8000d7 <umain+0x81>
        cprintf("init: bss seems okay\n");
  800239:	48 bf 26 40 80 00 00 	movabs $0x804026,%rdi
  800240:	00 00 00 
  800243:	b8 00 00 00 00       	mov    $0x0,%eax
  800248:	48 ba c2 07 80 00 00 	movabs $0x8007c2,%rdx
  80024f:	00 00 00 
  800252:	ff d2                	call   *%rdx
  800254:	e9 be fe ff ff       	jmp    800117 <umain+0xc1>
        panic("opencons: %i", r);
  800259:	89 c1                	mov    %eax,%ecx
  80025b:	48 ba 61 40 80 00 00 	movabs $0x804061,%rdx
  800262:	00 00 00 
  800265:	be 34 00 00 00       	mov    $0x34,%esi
  80026a:	48 bf 6e 40 80 00 00 	movabs $0x80406e,%rdi
  800271:	00 00 00 
  800274:	b8 00 00 00 00       	mov    $0x0,%eax
  800279:	49 b8 66 06 80 00 00 	movabs $0x800666,%r8
  800280:	00 00 00 
  800283:	41 ff d0             	call   *%r8
    if ((r = dup(0, 1)) < 0)
  800286:	be 01 00 00 00       	mov    $0x1,%esi
  80028b:	bf 00 00 00 00       	mov    $0x0,%edi
  800290:	48 b8 42 1d 80 00 00 	movabs $0x801d42,%rax
  800297:	00 00 00 
  80029a:	ff d0                	call   *%rax
        panic("dup: %i", r);
    while (1) {
        cprintf("init: starting sh\n");
  80029c:	49 be 9c 40 80 00 00 	movabs $0x80409c,%r14
  8002a3:	00 00 00 
  8002a6:	48 bb c2 07 80 00 00 	movabs $0x8007c2,%rbx
  8002ad:	00 00 00 
        r = spawnl("/sh", "sh", (char *)0);
  8002b0:	49 bd b0 40 80 00 00 	movabs $0x8040b0,%r13
  8002b7:	00 00 00 
  8002ba:	49 bc af 40 80 00 00 	movabs $0x8040af,%r12
  8002c1:	00 00 00 
    if ((r = dup(0, 1)) < 0)
  8002c4:	85 c0                	test   %eax,%eax
  8002c6:	79 40                	jns    800308 <umain+0x2b2>
        panic("dup: %i", r);
  8002c8:	89 c1                	mov    %eax,%ecx
  8002ca:	48 ba 94 40 80 00 00 	movabs $0x804094,%rdx
  8002d1:	00 00 00 
  8002d4:	be 38 00 00 00       	mov    $0x38,%esi
  8002d9:	48 bf 6e 40 80 00 00 	movabs $0x80406e,%rdi
  8002e0:	00 00 00 
  8002e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8002e8:	49 b8 66 06 80 00 00 	movabs $0x800666,%r8
  8002ef:	00 00 00 
  8002f2:	41 ff d0             	call   *%r8
        if (r < 0) {
            cprintf("init: spawn sh: %i\n", r);
  8002f5:	89 c6                	mov    %eax,%esi
  8002f7:	48 bf b3 40 80 00 00 	movabs $0x8040b3,%rdi
  8002fe:	00 00 00 
  800301:	b8 00 00 00 00       	mov    $0x0,%eax
  800306:	ff d3                	call   *%rbx
        cprintf("init: starting sh\n");
  800308:	4c 89 f7             	mov    %r14,%rdi
  80030b:	b8 00 00 00 00       	mov    $0x0,%eax
  800310:	ff d3                	call   *%rbx
        r = spawnl("/sh", "sh", (char *)0);
  800312:	ba 00 00 00 00       	mov    $0x0,%edx
  800317:	4c 89 ee             	mov    %r13,%rsi
  80031a:	4c 89 e7             	mov    %r12,%rdi
  80031d:	b8 00 00 00 00       	mov    $0x0,%eax
  800322:	48 b9 c0 2c 80 00 00 	movabs $0x802cc0,%rcx
  800329:	00 00 00 
  80032c:	ff d1                	call   *%rcx
        if (r < 0) {
  80032e:	85 c0                	test   %eax,%eax
  800330:	78 c3                	js     8002f5 <umain+0x29f>
            continue;
        }
        wait(r);
  800332:	89 c7                	mov    %eax,%edi
  800334:	48 b8 10 33 80 00 00 	movabs $0x803310,%rax
  80033b:	00 00 00 
  80033e:	ff d0                	call   *%rax
  800340:	eb c6                	jmp    800308 <umain+0x2b2>

0000000000800342 <devcons_close>:

    return res;
}

static int
devcons_close(struct Fd *fd) {
  800342:	f3 0f 1e fa          	endbr64
    USED(fd);

    return 0;
}
  800346:	b8 00 00 00 00       	mov    $0x0,%eax
  80034b:	c3                   	ret

000000000080034c <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  80034c:	f3 0f 1e fa          	endbr64
  800350:	55                   	push   %rbp
  800351:	48 89 e5             	mov    %rsp,%rbp
  800354:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  800357:	48 be c7 40 80 00 00 	movabs $0x8040c7,%rsi
  80035e:	00 00 00 
  800361:	48 b8 0b 11 80 00 00 	movabs $0x80110b,%rax
  800368:	00 00 00 
  80036b:	ff d0                	call   *%rax
    return 0;
}
  80036d:	b8 00 00 00 00       	mov    $0x0,%eax
  800372:	5d                   	pop    %rbp
  800373:	c3                   	ret

0000000000800374 <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  800374:	f3 0f 1e fa          	endbr64
  800378:	55                   	push   %rbp
  800379:	48 89 e5             	mov    %rsp,%rbp
  80037c:	41 57                	push   %r15
  80037e:	41 56                	push   %r14
  800380:	41 55                	push   %r13
  800382:	41 54                	push   %r12
  800384:	53                   	push   %rbx
  800385:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  80038c:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  800393:	48 85 d2             	test   %rdx,%rdx
  800396:	74 7a                	je     800412 <devcons_write+0x9e>
  800398:	49 89 d6             	mov    %rdx,%r14
  80039b:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  8003a1:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  8003a6:	49 bf 26 13 80 00 00 	movabs $0x801326,%r15
  8003ad:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  8003b0:	4c 89 f3             	mov    %r14,%rbx
  8003b3:	48 29 f3             	sub    %rsi,%rbx
  8003b6:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8003bb:	48 39 c3             	cmp    %rax,%rbx
  8003be:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  8003c2:	4c 63 eb             	movslq %ebx,%r13
  8003c5:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  8003cc:	48 01 c6             	add    %rax,%rsi
  8003cf:	4c 89 ea             	mov    %r13,%rdx
  8003d2:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  8003d9:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  8003dc:	4c 89 ee             	mov    %r13,%rsi
  8003df:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  8003e6:	48 b8 6b 15 80 00 00 	movabs $0x80156b,%rax
  8003ed:	00 00 00 
  8003f0:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  8003f2:	41 01 dc             	add    %ebx,%r12d
  8003f5:	49 63 f4             	movslq %r12d,%rsi
  8003f8:	4c 39 f6             	cmp    %r14,%rsi
  8003fb:	72 b3                	jb     8003b0 <devcons_write+0x3c>
    return res;
  8003fd:	49 63 c4             	movslq %r12d,%rax
}
  800400:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  800407:	5b                   	pop    %rbx
  800408:	41 5c                	pop    %r12
  80040a:	41 5d                	pop    %r13
  80040c:	41 5e                	pop    %r14
  80040e:	41 5f                	pop    %r15
  800410:	5d                   	pop    %rbp
  800411:	c3                   	ret
    for (res = 0; res < n; res += inc) {
  800412:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  800418:	eb e3                	jmp    8003fd <devcons_write+0x89>

000000000080041a <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  80041a:	f3 0f 1e fa          	endbr64
  80041e:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  800421:	ba 00 00 00 00       	mov    $0x0,%edx
  800426:	48 85 c0             	test   %rax,%rax
  800429:	74 55                	je     800480 <devcons_read+0x66>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  80042b:	55                   	push   %rbp
  80042c:	48 89 e5             	mov    %rsp,%rbp
  80042f:	41 55                	push   %r13
  800431:	41 54                	push   %r12
  800433:	53                   	push   %rbx
  800434:	48 83 ec 08          	sub    $0x8,%rsp
  800438:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  80043b:	48 bb 9c 15 80 00 00 	movabs $0x80159c,%rbx
  800442:	00 00 00 
  800445:	49 bc 75 16 80 00 00 	movabs $0x801675,%r12
  80044c:	00 00 00 
  80044f:	eb 03                	jmp    800454 <devcons_read+0x3a>
  800451:	41 ff d4             	call   *%r12
  800454:	ff d3                	call   *%rbx
  800456:	85 c0                	test   %eax,%eax
  800458:	74 f7                	je     800451 <devcons_read+0x37>
    if (c < 0) return c;
  80045a:	48 63 d0             	movslq %eax,%rdx
  80045d:	78 13                	js     800472 <devcons_read+0x58>
    if (c == 0x04) return 0;
  80045f:	ba 00 00 00 00       	mov    $0x0,%edx
  800464:	83 f8 04             	cmp    $0x4,%eax
  800467:	74 09                	je     800472 <devcons_read+0x58>
    *(char *)vbuf = (char)c;
  800469:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  80046d:	ba 01 00 00 00       	mov    $0x1,%edx
}
  800472:	48 89 d0             	mov    %rdx,%rax
  800475:	48 83 c4 08          	add    $0x8,%rsp
  800479:	5b                   	pop    %rbx
  80047a:	41 5c                	pop    %r12
  80047c:	41 5d                	pop    %r13
  80047e:	5d                   	pop    %rbp
  80047f:	c3                   	ret
  800480:	48 89 d0             	mov    %rdx,%rax
  800483:	c3                   	ret

0000000000800484 <cputchar>:
cputchar(int ch) {
  800484:	f3 0f 1e fa          	endbr64
  800488:	55                   	push   %rbp
  800489:	48 89 e5             	mov    %rsp,%rbp
  80048c:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  800490:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  800494:	be 01 00 00 00       	mov    $0x1,%esi
  800499:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  80049d:	48 b8 6b 15 80 00 00 	movabs $0x80156b,%rax
  8004a4:	00 00 00 
  8004a7:	ff d0                	call   *%rax
}
  8004a9:	c9                   	leave
  8004aa:	c3                   	ret

00000000008004ab <getchar>:
getchar(void) {
  8004ab:	f3 0f 1e fa          	endbr64
  8004af:	55                   	push   %rbp
  8004b0:	48 89 e5             	mov    %rsp,%rbp
  8004b3:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  8004b7:	ba 01 00 00 00       	mov    $0x1,%edx
  8004bc:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  8004c0:	bf 00 00 00 00       	mov    $0x0,%edi
  8004c5:	48 b8 69 1e 80 00 00 	movabs $0x801e69,%rax
  8004cc:	00 00 00 
  8004cf:	ff d0                	call   *%rax
  8004d1:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  8004d3:	85 c0                	test   %eax,%eax
  8004d5:	78 06                	js     8004dd <getchar+0x32>
  8004d7:	74 08                	je     8004e1 <getchar+0x36>
  8004d9:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  8004dd:	89 d0                	mov    %edx,%eax
  8004df:	c9                   	leave
  8004e0:	c3                   	ret
    return res < 0 ? res : res ? c :
  8004e1:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  8004e6:	eb f5                	jmp    8004dd <getchar+0x32>

00000000008004e8 <iscons>:
iscons(int fdnum) {
  8004e8:	f3 0f 1e fa          	endbr64
  8004ec:	55                   	push   %rbp
  8004ed:	48 89 e5             	mov    %rsp,%rbp
  8004f0:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8004f4:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8004f8:	48 b8 6e 1b 80 00 00 	movabs $0x801b6e,%rax
  8004ff:	00 00 00 
  800502:	ff d0                	call   *%rax
    if (res < 0) return res;
  800504:	85 c0                	test   %eax,%eax
  800506:	78 18                	js     800520 <iscons+0x38>
    return fd->fd_dev_id == devcons.dev_id;
  800508:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80050c:	48 b8 80 67 80 00 00 	movabs $0x806780,%rax
  800513:	00 00 00 
  800516:	8b 00                	mov    (%rax),%eax
  800518:	39 02                	cmp    %eax,(%rdx)
  80051a:	0f 94 c0             	sete   %al
  80051d:	0f b6 c0             	movzbl %al,%eax
}
  800520:	c9                   	leave
  800521:	c3                   	ret

0000000000800522 <opencons>:
opencons(void) {
  800522:	f3 0f 1e fa          	endbr64
  800526:	55                   	push   %rbp
  800527:	48 89 e5             	mov    %rsp,%rbp
  80052a:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  80052e:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  800532:	48 b8 0a 1b 80 00 00 	movabs $0x801b0a,%rax
  800539:	00 00 00 
  80053c:	ff d0                	call   *%rax
  80053e:	85 c0                	test   %eax,%eax
  800540:	78 49                	js     80058b <opencons+0x69>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  800542:	b9 46 00 00 00       	mov    $0x46,%ecx
  800547:	ba 00 10 00 00       	mov    $0x1000,%edx
  80054c:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  800550:	bf 00 00 00 00       	mov    $0x0,%edi
  800555:	48 b8 10 17 80 00 00 	movabs $0x801710,%rax
  80055c:	00 00 00 
  80055f:	ff d0                	call   *%rax
  800561:	85 c0                	test   %eax,%eax
  800563:	78 26                	js     80058b <opencons+0x69>
    fd->fd_dev_id = devcons.dev_id;
  800565:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800569:	a1 80 67 80 00 00 00 	movabs 0x806780,%eax
  800570:	00 00 
  800572:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  800574:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  800578:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  80057f:	48 b8 d4 1a 80 00 00 	movabs $0x801ad4,%rax
  800586:	00 00 00 
  800589:	ff d0                	call   *%rax
}
  80058b:	c9                   	leave
  80058c:	c3                   	ret

000000000080058d <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  80058d:	f3 0f 1e fa          	endbr64
  800591:	55                   	push   %rbp
  800592:	48 89 e5             	mov    %rsp,%rbp
  800595:	41 56                	push   %r14
  800597:	41 55                	push   %r13
  800599:	41 54                	push   %r12
  80059b:	53                   	push   %rbx
  80059c:	41 89 fd             	mov    %edi,%r13d
  80059f:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
     * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  8005a2:	48 ba 38 68 80 00 00 	movabs $0x806838,%rdx
  8005a9:	00 00 00 
  8005ac:	48 b8 38 68 80 00 00 	movabs $0x806838,%rax
  8005b3:	00 00 00 
  8005b6:	48 39 c2             	cmp    %rax,%rdx
  8005b9:	73 17                	jae    8005d2 <libmain+0x45>
    void (**ctor)() = &__ctors_start;
  8005bb:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  8005be:	49 89 c4             	mov    %rax,%r12
  8005c1:	48 83 c3 08          	add    $0x8,%rbx
  8005c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8005ca:	ff 53 f8             	call   *-0x8(%rbx)
  8005cd:	4c 39 e3             	cmp    %r12,%rbx
  8005d0:	72 ef                	jb     8005c1 <libmain+0x34>

    /* Set thisenv to point at our Env structure in envs[]. */

    // LAB 8: Your code here
    thisenv = &((struct Env *)UENVS)[ENVX(sys_getenvid())];
  8005d2:	48 b8 40 16 80 00 00 	movabs $0x801640,%rax
  8005d9:	00 00 00 
  8005dc:	ff d0                	call   *%rax
  8005de:	25 ff 03 00 00       	and    $0x3ff,%eax
  8005e3:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8005e7:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8005eb:	48 c1 e0 04          	shl    $0x4,%rax
  8005ef:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  8005f6:	00 00 00 
  8005f9:	48 01 d0             	add    %rdx,%rax
  8005fc:	48 a3 70 87 80 00 00 	movabs %rax,0x808770
  800603:	00 00 00 

    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  800606:	45 85 ed             	test   %r13d,%r13d
  800609:	7e 0d                	jle    800618 <libmain+0x8b>
  80060b:	49 8b 06             	mov    (%r14),%rax
  80060e:	48 a3 b8 67 80 00 00 	movabs %rax,0x8067b8
  800615:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  800618:	4c 89 f6             	mov    %r14,%rsi
  80061b:	44 89 ef             	mov    %r13d,%edi
  80061e:	48 b8 56 00 80 00 00 	movabs $0x800056,%rax
  800625:	00 00 00 
  800628:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  80062a:	48 b8 3f 06 80 00 00 	movabs $0x80063f,%rax
  800631:	00 00 00 
  800634:	ff d0                	call   *%rax
#endif
}
  800636:	5b                   	pop    %rbx
  800637:	41 5c                	pop    %r12
  800639:	41 5d                	pop    %r13
  80063b:	41 5e                	pop    %r14
  80063d:	5d                   	pop    %rbp
  80063e:	c3                   	ret

000000000080063f <exit>:

#include <inc/lib.h>

void
exit(void) {
  80063f:	f3 0f 1e fa          	endbr64
  800643:	55                   	push   %rbp
  800644:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  800647:	48 b8 16 1d 80 00 00 	movabs $0x801d16,%rax
  80064e:	00 00 00 
  800651:	ff d0                	call   *%rax
    sys_env_destroy(0);
  800653:	bf 00 00 00 00       	mov    $0x0,%edi
  800658:	48 b8 d1 15 80 00 00 	movabs $0x8015d1,%rax
  80065f:	00 00 00 
  800662:	ff d0                	call   *%rax
}
  800664:	5d                   	pop    %rbp
  800665:	c3                   	ret

0000000000800666 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  800666:	f3 0f 1e fa          	endbr64
  80066a:	55                   	push   %rbp
  80066b:	48 89 e5             	mov    %rsp,%rbp
  80066e:	41 56                	push   %r14
  800670:	41 55                	push   %r13
  800672:	41 54                	push   %r12
  800674:	53                   	push   %rbx
  800675:	48 83 ec 50          	sub    $0x50,%rsp
  800679:	49 89 fc             	mov    %rdi,%r12
  80067c:	41 89 f5             	mov    %esi,%r13d
  80067f:	48 89 d3             	mov    %rdx,%rbx
  800682:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800686:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  80068a:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  80068e:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  800695:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800699:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  80069d:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  8006a1:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  8006a5:	48 b8 b8 67 80 00 00 	movabs $0x8067b8,%rax
  8006ac:	00 00 00 
  8006af:	4c 8b 30             	mov    (%rax),%r14
  8006b2:	48 b8 40 16 80 00 00 	movabs $0x801640,%rax
  8006b9:	00 00 00 
  8006bc:	ff d0                	call   *%rax
  8006be:	89 c6                	mov    %eax,%esi
  8006c0:	45 89 e8             	mov    %r13d,%r8d
  8006c3:	4c 89 e1             	mov    %r12,%rcx
  8006c6:	4c 89 f2             	mov    %r14,%rdx
  8006c9:	48 bf 10 44 80 00 00 	movabs $0x804410,%rdi
  8006d0:	00 00 00 
  8006d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8006d8:	49 bc c2 07 80 00 00 	movabs $0x8007c2,%r12
  8006df:	00 00 00 
  8006e2:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  8006e5:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  8006e9:	48 89 df             	mov    %rbx,%rdi
  8006ec:	48 b8 5a 07 80 00 00 	movabs $0x80075a,%rax
  8006f3:	00 00 00 
  8006f6:	ff d0                	call   *%rax
    cprintf("\n");
  8006f8:	48 bf 94 42 80 00 00 	movabs $0x804294,%rdi
  8006ff:	00 00 00 
  800702:	b8 00 00 00 00       	mov    $0x0,%eax
  800707:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  80070a:	cc                   	int3
  80070b:	eb fd                	jmp    80070a <_panic+0xa4>

000000000080070d <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  80070d:	f3 0f 1e fa          	endbr64
  800711:	55                   	push   %rbp
  800712:	48 89 e5             	mov    %rsp,%rbp
  800715:	53                   	push   %rbx
  800716:	48 83 ec 08          	sub    $0x8,%rsp
  80071a:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  80071d:	8b 06                	mov    (%rsi),%eax
  80071f:	8d 50 01             	lea    0x1(%rax),%edx
  800722:	89 16                	mov    %edx,(%rsi)
  800724:	48 98                	cltq
  800726:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  80072b:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  800731:	74 0a                	je     80073d <putch+0x30>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  800733:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  800737:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80073b:	c9                   	leave
  80073c:	c3                   	ret
        sys_cputs(state->buf, state->offset);
  80073d:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  800741:	be ff 00 00 00       	mov    $0xff,%esi
  800746:	48 b8 6b 15 80 00 00 	movabs $0x80156b,%rax
  80074d:	00 00 00 
  800750:	ff d0                	call   *%rax
        state->offset = 0;
  800752:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  800758:	eb d9                	jmp    800733 <putch+0x26>

000000000080075a <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  80075a:	f3 0f 1e fa          	endbr64
  80075e:	55                   	push   %rbp
  80075f:	48 89 e5             	mov    %rsp,%rbp
  800762:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800769:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  80076c:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  800773:	b9 21 00 00 00       	mov    $0x21,%ecx
  800778:	b8 00 00 00 00       	mov    $0x0,%eax
  80077d:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  800780:	48 89 f1             	mov    %rsi,%rcx
  800783:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  80078a:	48 bf 0d 07 80 00 00 	movabs $0x80070d,%rdi
  800791:	00 00 00 
  800794:	48 b8 22 09 80 00 00 	movabs $0x800922,%rax
  80079b:	00 00 00 
  80079e:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  8007a0:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  8007a7:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  8007ae:	48 b8 6b 15 80 00 00 	movabs $0x80156b,%rax
  8007b5:	00 00 00 
  8007b8:	ff d0                	call   *%rax

    return state.count;
}
  8007ba:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  8007c0:	c9                   	leave
  8007c1:	c3                   	ret

00000000008007c2 <cprintf>:

int
cprintf(const char *fmt, ...) {
  8007c2:	f3 0f 1e fa          	endbr64
  8007c6:	55                   	push   %rbp
  8007c7:	48 89 e5             	mov    %rsp,%rbp
  8007ca:	48 83 ec 50          	sub    $0x50,%rsp
  8007ce:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  8007d2:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8007d6:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8007da:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8007de:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  8007e2:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  8007e9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8007ed:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007f1:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8007f5:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  8007f9:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  8007fd:	48 b8 5a 07 80 00 00 	movabs $0x80075a,%rax
  800804:	00 00 00 
  800807:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  800809:	c9                   	leave
  80080a:	c3                   	ret

000000000080080b <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  80080b:	f3 0f 1e fa          	endbr64
  80080f:	55                   	push   %rbp
  800810:	48 89 e5             	mov    %rsp,%rbp
  800813:	41 57                	push   %r15
  800815:	41 56                	push   %r14
  800817:	41 55                	push   %r13
  800819:	41 54                	push   %r12
  80081b:	53                   	push   %rbx
  80081c:	48 83 ec 18          	sub    $0x18,%rsp
  800820:	49 89 fc             	mov    %rdi,%r12
  800823:	49 89 f5             	mov    %rsi,%r13
  800826:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  80082a:	8b 45 10             	mov    0x10(%rbp),%eax
  80082d:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  800830:	41 89 cf             	mov    %ecx,%r15d
  800833:	4c 39 fa             	cmp    %r15,%rdx
  800836:	73 5b                	jae    800893 <print_num+0x88>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  800838:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  80083c:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  800840:	85 db                	test   %ebx,%ebx
  800842:	7e 0e                	jle    800852 <print_num+0x47>
            putch(padc, put_arg);
  800844:	4c 89 ee             	mov    %r13,%rsi
  800847:	44 89 f7             	mov    %r14d,%edi
  80084a:	41 ff d4             	call   *%r12
        while (--width > 0) {
  80084d:	83 eb 01             	sub    $0x1,%ebx
  800850:	75 f2                	jne    800844 <print_num+0x39>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  800852:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  800856:	48 b9 ee 40 80 00 00 	movabs $0x8040ee,%rcx
  80085d:	00 00 00 
  800860:	48 b8 dd 40 80 00 00 	movabs $0x8040dd,%rax
  800867:	00 00 00 
  80086a:	48 0f 45 c8          	cmovne %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  80086e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800872:	ba 00 00 00 00       	mov    $0x0,%edx
  800877:	49 f7 f7             	div    %r15
  80087a:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  80087e:	4c 89 ee             	mov    %r13,%rsi
  800881:	41 ff d4             	call   *%r12
}
  800884:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800888:	5b                   	pop    %rbx
  800889:	41 5c                	pop    %r12
  80088b:	41 5d                	pop    %r13
  80088d:	41 5e                	pop    %r14
  80088f:	41 5f                	pop    %r15
  800891:	5d                   	pop    %rbp
  800892:	c3                   	ret
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  800893:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800897:	ba 00 00 00 00       	mov    $0x0,%edx
  80089c:	49 f7 f7             	div    %r15
  80089f:	48 83 ec 08          	sub    $0x8,%rsp
  8008a3:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  8008a7:	52                   	push   %rdx
  8008a8:	45 0f be c9          	movsbl %r9b,%r9d
  8008ac:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  8008b0:	48 89 c2             	mov    %rax,%rdx
  8008b3:	48 b8 0b 08 80 00 00 	movabs $0x80080b,%rax
  8008ba:	00 00 00 
  8008bd:	ff d0                	call   *%rax
  8008bf:	48 83 c4 10          	add    $0x10,%rsp
  8008c3:	eb 8d                	jmp    800852 <print_num+0x47>

00000000008008c5 <sprintputch>:
    char *end;
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
  8008c5:	f3 0f 1e fa          	endbr64
    state->count++;
  8008c9:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  8008cd:	48 8b 06             	mov    (%rsi),%rax
  8008d0:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  8008d4:	73 0a                	jae    8008e0 <sprintputch+0x1b>
        *state->start++ = ch;
  8008d6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008da:	48 89 16             	mov    %rdx,(%rsi)
  8008dd:	40 88 38             	mov    %dil,(%rax)
    }
}
  8008e0:	c3                   	ret

00000000008008e1 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  8008e1:	f3 0f 1e fa          	endbr64
  8008e5:	55                   	push   %rbp
  8008e6:	48 89 e5             	mov    %rsp,%rbp
  8008e9:	48 83 ec 50          	sub    $0x50,%rsp
  8008ed:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8008f1:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8008f5:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  8008f9:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800900:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800904:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800908:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80090c:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  800910:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800914:	48 b8 22 09 80 00 00 	movabs $0x800922,%rax
  80091b:	00 00 00 
  80091e:	ff d0                	call   *%rax
}
  800920:	c9                   	leave
  800921:	c3                   	ret

0000000000800922 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  800922:	f3 0f 1e fa          	endbr64
  800926:	55                   	push   %rbp
  800927:	48 89 e5             	mov    %rsp,%rbp
  80092a:	41 57                	push   %r15
  80092c:	41 56                	push   %r14
  80092e:	41 55                	push   %r13
  800930:	41 54                	push   %r12
  800932:	53                   	push   %rbx
  800933:	48 83 ec 38          	sub    $0x38,%rsp
  800937:	49 89 fe             	mov    %rdi,%r14
  80093a:	49 89 f5             	mov    %rsi,%r13
  80093d:	48 89 d3             	mov    %rdx,%rbx
    va_copy(aq, ap);
  800940:	48 8b 01             	mov    (%rcx),%rax
  800943:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  800947:	48 8b 41 08          	mov    0x8(%rcx),%rax
  80094b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80094f:	48 8b 41 10          	mov    0x10(%rcx),%rax
  800953:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  800957:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  80095b:	0f b6 3b             	movzbl (%rbx),%edi
  80095e:	40 80 ff 25          	cmp    $0x25,%dil
  800962:	74 18                	je     80097c <vprintfmt+0x5a>
            if (!ch) return;
  800964:	40 84 ff             	test   %dil,%dil
  800967:	0f 84 b2 06 00 00    	je     80101f <vprintfmt+0x6fd>
            putch(ch, put_arg);
  80096d:	40 0f b6 ff          	movzbl %dil,%edi
  800971:	4c 89 ee             	mov    %r13,%rsi
  800974:	41 ff d6             	call   *%r14
        while ((ch = *ufmt++) != '%') {
  800977:	4c 89 e3             	mov    %r12,%rbx
  80097a:	eb db                	jmp    800957 <vprintfmt+0x35>
        bool altflag = 0, zflag = 0;
  80097c:	be 00 00 00 00       	mov    $0x0,%esi
  800981:	c6 45 ab 00          	movb   $0x0,-0x55(%rbp)
        unsigned lflag = 0, base = 10;
  800985:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  80098a:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  800990:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  800997:	c6 45 aa 20          	movb   $0x20,-0x56(%rbp)
        switch (ch = *ufmt++) {
  80099b:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  8009a0:	41 0f b6 04 24       	movzbl (%r12),%eax
  8009a5:	88 45 a0             	mov    %al,-0x60(%rbp)
  8009a8:	83 e8 23             	sub    $0x23,%eax
  8009ab:	3c 57                	cmp    $0x57,%al
  8009ad:	0f 87 52 06 00 00    	ja     801005 <vprintfmt+0x6e3>
  8009b3:	0f b6 c0             	movzbl %al,%eax
  8009b6:	48 b9 60 45 80 00 00 	movabs $0x804560,%rcx
  8009bd:	00 00 00 
  8009c0:	3e ff 24 c1          	notrack jmp *(%rcx,%rax,8)
  8009c4:	49 89 dc             	mov    %rbx,%r12
            altflag = 1;
  8009c7:	c6 45 ab 01          	movb   $0x1,-0x55(%rbp)
  8009cb:	eb ce                	jmp    80099b <vprintfmt+0x79>
        switch (ch = *ufmt++) {
  8009cd:	49 89 dc             	mov    %rbx,%r12
  8009d0:	be 01 00 00 00       	mov    $0x1,%esi
  8009d5:	eb c4                	jmp    80099b <vprintfmt+0x79>
            padc = ch;
  8009d7:	0f b6 45 a0          	movzbl -0x60(%rbp),%eax
  8009db:	88 45 aa             	mov    %al,-0x56(%rbp)
        switch (ch = *ufmt++) {
  8009de:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  8009e1:	eb b8                	jmp    80099b <vprintfmt+0x79>
            precision = va_arg(aq, int);
  8009e3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009e6:	83 f8 2f             	cmp    $0x2f,%eax
  8009e9:	77 24                	ja     800a0f <vprintfmt+0xed>
  8009eb:	89 c1                	mov    %eax,%ecx
  8009ed:	48 03 4d c8          	add    -0x38(%rbp),%rcx
  8009f1:	83 c0 08             	add    $0x8,%eax
  8009f4:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009f7:	44 8b 39             	mov    (%rcx),%r15d
        switch (ch = *ufmt++) {
  8009fa:	49 89 dc             	mov    %rbx,%r12
            if (width < 0) {
  8009fd:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800a01:	79 98                	jns    80099b <vprintfmt+0x79>
                width = precision;
  800a03:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
                precision = -1;
  800a07:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  800a0d:	eb 8c                	jmp    80099b <vprintfmt+0x79>
            precision = va_arg(aq, int);
  800a0f:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  800a13:	48 8d 41 08          	lea    0x8(%rcx),%rax
  800a17:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a1b:	eb da                	jmp    8009f7 <vprintfmt+0xd5>
                precision = precision * 10 + ch - '0';
  800a1d:	44 0f b6 7d a0       	movzbl -0x60(%rbp),%r15d
  800a22:	41 83 ef 30          	sub    $0x30,%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  800a26:	41 0f b6 44 24 01    	movzbl 0x1(%r12),%eax
  800a2c:	3c 39                	cmp    $0x39,%al
  800a2e:	77 1c                	ja     800a4c <vprintfmt+0x12a>
            for (precision = 0;; ++ufmt) {
  800a30:	48 83 c3 01          	add    $0x1,%rbx
                precision = precision * 10 + ch - '0';
  800a34:	43 8d 0c bf          	lea    (%r15,%r15,4),%ecx
  800a38:	0f b6 c0             	movzbl %al,%eax
  800a3b:	44 8d 7c 48 d0       	lea    -0x30(%rax,%rcx,2),%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  800a40:	0f b6 03             	movzbl (%rbx),%eax
  800a43:	3c 39                	cmp    $0x39,%al
  800a45:	76 e9                	jbe    800a30 <vprintfmt+0x10e>
        process_precision:
  800a47:	49 89 dc             	mov    %rbx,%r12
  800a4a:	eb b1                	jmp    8009fd <vprintfmt+0xdb>
        switch (ch = *ufmt++) {
  800a4c:	49 89 dc             	mov    %rbx,%r12
  800a4f:	eb ac                	jmp    8009fd <vprintfmt+0xdb>
            width = MAX(0, width);
  800a51:	8b 4d ac             	mov    -0x54(%rbp),%ecx
  800a54:	85 c9                	test   %ecx,%ecx
  800a56:	b8 00 00 00 00       	mov    $0x0,%eax
  800a5b:	0f 49 c1             	cmovns %ecx,%eax
  800a5e:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  800a61:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  800a64:	e9 32 ff ff ff       	jmp    80099b <vprintfmt+0x79>
            lflag++;
  800a69:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  800a6c:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  800a6f:	e9 27 ff ff ff       	jmp    80099b <vprintfmt+0x79>
            putch(va_arg(aq, int), put_arg);
  800a74:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a77:	83 f8 2f             	cmp    $0x2f,%eax
  800a7a:	77 19                	ja     800a95 <vprintfmt+0x173>
  800a7c:	89 c2                	mov    %eax,%edx
  800a7e:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a82:	83 c0 08             	add    $0x8,%eax
  800a85:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a88:	8b 3a                	mov    (%rdx),%edi
  800a8a:	4c 89 ee             	mov    %r13,%rsi
  800a8d:	41 ff d6             	call   *%r14
            break;
  800a90:	e9 c2 fe ff ff       	jmp    800957 <vprintfmt+0x35>
            putch(va_arg(aq, int), put_arg);
  800a95:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a99:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a9d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800aa1:	eb e5                	jmp    800a88 <vprintfmt+0x166>
            int err = va_arg(aq, int);
  800aa3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aa6:	83 f8 2f             	cmp    $0x2f,%eax
  800aa9:	77 5a                	ja     800b05 <vprintfmt+0x1e3>
  800aab:	89 c2                	mov    %eax,%edx
  800aad:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800ab1:	83 c0 08             	add    $0x8,%eax
  800ab4:	89 45 b8             	mov    %eax,-0x48(%rbp)
            if (err < 0) err = -err;
  800ab7:	8b 02                	mov    (%rdx),%eax
  800ab9:	89 c1                	mov    %eax,%ecx
  800abb:	f7 d9                	neg    %ecx
  800abd:	0f 48 c8             	cmovs  %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  800ac0:	83 f9 13             	cmp    $0x13,%ecx
  800ac3:	7f 4e                	jg     800b13 <vprintfmt+0x1f1>
  800ac5:	48 63 c1             	movslq %ecx,%rax
  800ac8:	48 ba 20 48 80 00 00 	movabs $0x804820,%rdx
  800acf:	00 00 00 
  800ad2:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  800ad6:	48 85 c0             	test   %rax,%rax
  800ad9:	74 38                	je     800b13 <vprintfmt+0x1f1>
                printfmt(putch, put_arg, "%s", strerr);
  800adb:	48 89 c1             	mov    %rax,%rcx
  800ade:	48 ba e2 42 80 00 00 	movabs $0x8042e2,%rdx
  800ae5:	00 00 00 
  800ae8:	4c 89 ee             	mov    %r13,%rsi
  800aeb:	4c 89 f7             	mov    %r14,%rdi
  800aee:	b8 00 00 00 00       	mov    $0x0,%eax
  800af3:	49 b8 e1 08 80 00 00 	movabs $0x8008e1,%r8
  800afa:	00 00 00 
  800afd:	41 ff d0             	call   *%r8
  800b00:	e9 52 fe ff ff       	jmp    800957 <vprintfmt+0x35>
            int err = va_arg(aq, int);
  800b05:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b09:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b0d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b11:	eb a4                	jmp    800ab7 <vprintfmt+0x195>
                printfmt(putch, put_arg, "error %d", err);
  800b13:	48 ba 06 41 80 00 00 	movabs $0x804106,%rdx
  800b1a:	00 00 00 
  800b1d:	4c 89 ee             	mov    %r13,%rsi
  800b20:	4c 89 f7             	mov    %r14,%rdi
  800b23:	b8 00 00 00 00       	mov    $0x0,%eax
  800b28:	49 b8 e1 08 80 00 00 	movabs $0x8008e1,%r8
  800b2f:	00 00 00 
  800b32:	41 ff d0             	call   *%r8
  800b35:	e9 1d fe ff ff       	jmp    800957 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  800b3a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b3d:	83 f8 2f             	cmp    $0x2f,%eax
  800b40:	77 6c                	ja     800bae <vprintfmt+0x28c>
  800b42:	89 c2                	mov    %eax,%edx
  800b44:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b48:	83 c0 08             	add    $0x8,%eax
  800b4b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b4e:	48 8b 12             	mov    (%rdx),%rdx
            if (!ptr) ptr = "(null)";
  800b51:	48 85 d2             	test   %rdx,%rdx
  800b54:	48 b8 ff 40 80 00 00 	movabs $0x8040ff,%rax
  800b5b:	00 00 00 
  800b5e:	48 0f 45 c2          	cmovne %rdx,%rax
  800b62:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
            if (width > 0 && padc != '-') {
  800b66:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800b6a:	7e 06                	jle    800b72 <vprintfmt+0x250>
  800b6c:	80 7d aa 2d          	cmpb   $0x2d,-0x56(%rbp)
  800b70:	75 4a                	jne    800bbc <vprintfmt+0x29a>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800b72:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800b76:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800b7a:	0f b6 00             	movzbl (%rax),%eax
  800b7d:	84 c0                	test   %al,%al
  800b7f:	0f 85 9a 00 00 00    	jne    800c1f <vprintfmt+0x2fd>
            while (width-- > 0) putch(' ', put_arg);
  800b85:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800b88:	44 8d 60 ff          	lea    -0x1(%rax),%r12d
  800b8c:	85 c0                	test   %eax,%eax
  800b8e:	0f 8e c3 fd ff ff    	jle    800957 <vprintfmt+0x35>
  800b94:	4c 89 ee             	mov    %r13,%rsi
  800b97:	bf 20 00 00 00       	mov    $0x20,%edi
  800b9c:	41 ff d6             	call   *%r14
  800b9f:	41 83 ec 01          	sub    $0x1,%r12d
  800ba3:	41 83 fc ff          	cmp    $0xffffffff,%r12d
  800ba7:	75 eb                	jne    800b94 <vprintfmt+0x272>
  800ba9:	e9 a9 fd ff ff       	jmp    800957 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  800bae:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bb2:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800bb6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800bba:	eb 92                	jmp    800b4e <vprintfmt+0x22c>
                width -= strnlen(ptr, precision);
  800bbc:	49 63 f7             	movslq %r15d,%rsi
  800bbf:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  800bc3:	48 b8 e5 10 80 00 00 	movabs $0x8010e5,%rax
  800bca:	00 00 00 
  800bcd:	ff d0                	call   *%rax
  800bcf:	48 89 c2             	mov    %rax,%rdx
  800bd2:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800bd5:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  800bd7:	8d 70 ff             	lea    -0x1(%rax),%esi
  800bda:	89 75 ac             	mov    %esi,-0x54(%rbp)
  800bdd:	85 c0                	test   %eax,%eax
  800bdf:	7e 91                	jle    800b72 <vprintfmt+0x250>
  800be1:	44 0f be 65 aa       	movsbl -0x56(%rbp),%r12d
  800be6:	4c 89 ee             	mov    %r13,%rsi
  800be9:	44 89 e7             	mov    %r12d,%edi
  800bec:	41 ff d6             	call   *%r14
  800bef:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  800bf3:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800bf6:	83 f8 ff             	cmp    $0xffffffff,%eax
  800bf9:	75 eb                	jne    800be6 <vprintfmt+0x2c4>
  800bfb:	e9 72 ff ff ff       	jmp    800b72 <vprintfmt+0x250>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800c00:	0f b6 f8             	movzbl %al,%edi
  800c03:	4c 89 ee             	mov    %r13,%rsi
  800c06:	41 ff d6             	call   *%r14
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800c09:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  800c0d:	49 83 c4 01          	add    $0x1,%r12
  800c11:	41 0f b6 44 24 ff    	movzbl -0x1(%r12),%eax
  800c17:	84 c0                	test   %al,%al
  800c19:	0f 84 66 ff ff ff    	je     800b85 <vprintfmt+0x263>
  800c1f:	45 85 ff             	test   %r15d,%r15d
  800c22:	78 0a                	js     800c2e <vprintfmt+0x30c>
  800c24:	41 83 ef 01          	sub    $0x1,%r15d
  800c28:	0f 88 57 ff ff ff    	js     800b85 <vprintfmt+0x263>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800c2e:	80 7d ab 00          	cmpb   $0x0,-0x55(%rbp)
  800c32:	74 cc                	je     800c00 <vprintfmt+0x2de>
  800c34:	8d 50 e0             	lea    -0x20(%rax),%edx
  800c37:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800c3c:	80 fa 5e             	cmp    $0x5e,%dl
  800c3f:	77 c2                	ja     800c03 <vprintfmt+0x2e1>
  800c41:	eb bd                	jmp    800c00 <vprintfmt+0x2de>
    if (zflag) return va_arg(*ap, size_t);
  800c43:	40 84 f6             	test   %sil,%sil
  800c46:	75 26                	jne    800c6e <vprintfmt+0x34c>
    switch (lflag) {
  800c48:	85 d2                	test   %edx,%edx
  800c4a:	74 59                	je     800ca5 <vprintfmt+0x383>
  800c4c:	83 fa 01             	cmp    $0x1,%edx
  800c4f:	74 7b                	je     800ccc <vprintfmt+0x3aa>
        return va_arg(*ap, long long);
  800c51:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c54:	83 f8 2f             	cmp    $0x2f,%eax
  800c57:	0f 87 96 00 00 00    	ja     800cf3 <vprintfmt+0x3d1>
  800c5d:	89 c2                	mov    %eax,%edx
  800c5f:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800c63:	83 c0 08             	add    $0x8,%eax
  800c66:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c69:	4c 8b 22             	mov    (%rdx),%r12
  800c6c:	eb 17                	jmp    800c85 <vprintfmt+0x363>
    if (zflag) return va_arg(*ap, size_t);
  800c6e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c71:	83 f8 2f             	cmp    $0x2f,%eax
  800c74:	77 21                	ja     800c97 <vprintfmt+0x375>
  800c76:	89 c2                	mov    %eax,%edx
  800c78:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800c7c:	83 c0 08             	add    $0x8,%eax
  800c7f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c82:	4c 8b 22             	mov    (%rdx),%r12
            if (i < 0) {
  800c85:	4d 85 e4             	test   %r12,%r12
  800c88:	78 7a                	js     800d04 <vprintfmt+0x3e2>
            num = i;
  800c8a:	4c 89 e2             	mov    %r12,%rdx
        unsigned lflag = 0, base = 10;
  800c8d:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  800c92:	e9 50 02 00 00       	jmp    800ee7 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800c97:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c9b:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800c9f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ca3:	eb dd                	jmp    800c82 <vprintfmt+0x360>
        return va_arg(*ap, int);
  800ca5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ca8:	83 f8 2f             	cmp    $0x2f,%eax
  800cab:	77 11                	ja     800cbe <vprintfmt+0x39c>
  800cad:	89 c2                	mov    %eax,%edx
  800caf:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800cb3:	83 c0 08             	add    $0x8,%eax
  800cb6:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800cb9:	4c 63 22             	movslq (%rdx),%r12
  800cbc:	eb c7                	jmp    800c85 <vprintfmt+0x363>
  800cbe:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cc2:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800cc6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800cca:	eb ed                	jmp    800cb9 <vprintfmt+0x397>
        return va_arg(*ap, long);
  800ccc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ccf:	83 f8 2f             	cmp    $0x2f,%eax
  800cd2:	77 11                	ja     800ce5 <vprintfmt+0x3c3>
  800cd4:	89 c2                	mov    %eax,%edx
  800cd6:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800cda:	83 c0 08             	add    $0x8,%eax
  800cdd:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ce0:	4c 8b 22             	mov    (%rdx),%r12
  800ce3:	eb a0                	jmp    800c85 <vprintfmt+0x363>
  800ce5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ce9:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800ced:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800cf1:	eb ed                	jmp    800ce0 <vprintfmt+0x3be>
        return va_arg(*ap, long long);
  800cf3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cf7:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800cfb:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800cff:	e9 65 ff ff ff       	jmp    800c69 <vprintfmt+0x347>
                putch('-', put_arg);
  800d04:	4c 89 ee             	mov    %r13,%rsi
  800d07:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800d0c:	41 ff d6             	call   *%r14
                i = -i;
  800d0f:	49 f7 dc             	neg    %r12
  800d12:	e9 73 ff ff ff       	jmp    800c8a <vprintfmt+0x368>
    if (zflag) return va_arg(*ap, size_t);
  800d17:	40 84 f6             	test   %sil,%sil
  800d1a:	75 32                	jne    800d4e <vprintfmt+0x42c>
    switch (lflag) {
  800d1c:	85 d2                	test   %edx,%edx
  800d1e:	74 5d                	je     800d7d <vprintfmt+0x45b>
  800d20:	83 fa 01             	cmp    $0x1,%edx
  800d23:	0f 84 82 00 00 00    	je     800dab <vprintfmt+0x489>
        return va_arg(*ap, unsigned long long);
  800d29:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d2c:	83 f8 2f             	cmp    $0x2f,%eax
  800d2f:	0f 87 a5 00 00 00    	ja     800dda <vprintfmt+0x4b8>
  800d35:	89 c2                	mov    %eax,%edx
  800d37:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800d3b:	83 c0 08             	add    $0x8,%eax
  800d3e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800d41:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800d44:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  800d49:	e9 99 01 00 00       	jmp    800ee7 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800d4e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d51:	83 f8 2f             	cmp    $0x2f,%eax
  800d54:	77 19                	ja     800d6f <vprintfmt+0x44d>
  800d56:	89 c2                	mov    %eax,%edx
  800d58:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800d5c:	83 c0 08             	add    $0x8,%eax
  800d5f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800d62:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800d65:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800d6a:	e9 78 01 00 00       	jmp    800ee7 <vprintfmt+0x5c5>
  800d6f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d73:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800d77:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800d7b:	eb e5                	jmp    800d62 <vprintfmt+0x440>
        return va_arg(*ap, unsigned int);
  800d7d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d80:	83 f8 2f             	cmp    $0x2f,%eax
  800d83:	77 18                	ja     800d9d <vprintfmt+0x47b>
  800d85:	89 c2                	mov    %eax,%edx
  800d87:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800d8b:	83 c0 08             	add    $0x8,%eax
  800d8e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800d91:	8b 12                	mov    (%rdx),%edx
        unsigned lflag = 0, base = 10;
  800d93:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  800d98:	e9 4a 01 00 00       	jmp    800ee7 <vprintfmt+0x5c5>
  800d9d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800da1:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800da5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800da9:	eb e6                	jmp    800d91 <vprintfmt+0x46f>
        return va_arg(*ap, unsigned long);
  800dab:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800dae:	83 f8 2f             	cmp    $0x2f,%eax
  800db1:	77 19                	ja     800dcc <vprintfmt+0x4aa>
  800db3:	89 c2                	mov    %eax,%edx
  800db5:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800db9:	83 c0 08             	add    $0x8,%eax
  800dbc:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800dbf:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800dc2:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  800dc7:	e9 1b 01 00 00       	jmp    800ee7 <vprintfmt+0x5c5>
  800dcc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800dd0:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800dd4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800dd8:	eb e5                	jmp    800dbf <vprintfmt+0x49d>
        return va_arg(*ap, unsigned long long);
  800dda:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800dde:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800de2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800de6:	e9 56 ff ff ff       	jmp    800d41 <vprintfmt+0x41f>
    if (zflag) return va_arg(*ap, size_t);
  800deb:	40 84 f6             	test   %sil,%sil
  800dee:	75 2e                	jne    800e1e <vprintfmt+0x4fc>
    switch (lflag) {
  800df0:	85 d2                	test   %edx,%edx
  800df2:	74 59                	je     800e4d <vprintfmt+0x52b>
  800df4:	83 fa 01             	cmp    $0x1,%edx
  800df7:	74 7f                	je     800e78 <vprintfmt+0x556>
        return va_arg(*ap, unsigned long long);
  800df9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800dfc:	83 f8 2f             	cmp    $0x2f,%eax
  800dff:	0f 87 9f 00 00 00    	ja     800ea4 <vprintfmt+0x582>
  800e05:	89 c2                	mov    %eax,%edx
  800e07:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800e0b:	83 c0 08             	add    $0x8,%eax
  800e0e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800e11:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800e14:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  800e19:	e9 c9 00 00 00       	jmp    800ee7 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800e1e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e21:	83 f8 2f             	cmp    $0x2f,%eax
  800e24:	77 19                	ja     800e3f <vprintfmt+0x51d>
  800e26:	89 c2                	mov    %eax,%edx
  800e28:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800e2c:	83 c0 08             	add    $0x8,%eax
  800e2f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800e32:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800e35:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800e3a:	e9 a8 00 00 00       	jmp    800ee7 <vprintfmt+0x5c5>
  800e3f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e43:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800e47:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800e4b:	eb e5                	jmp    800e32 <vprintfmt+0x510>
        return va_arg(*ap, unsigned int);
  800e4d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e50:	83 f8 2f             	cmp    $0x2f,%eax
  800e53:	77 15                	ja     800e6a <vprintfmt+0x548>
  800e55:	89 c2                	mov    %eax,%edx
  800e57:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800e5b:	83 c0 08             	add    $0x8,%eax
  800e5e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800e61:	8b 12                	mov    (%rdx),%edx
            base = 8;
  800e63:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  800e68:	eb 7d                	jmp    800ee7 <vprintfmt+0x5c5>
  800e6a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e6e:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800e72:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800e76:	eb e9                	jmp    800e61 <vprintfmt+0x53f>
        return va_arg(*ap, unsigned long);
  800e78:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e7b:	83 f8 2f             	cmp    $0x2f,%eax
  800e7e:	77 16                	ja     800e96 <vprintfmt+0x574>
  800e80:	89 c2                	mov    %eax,%edx
  800e82:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800e86:	83 c0 08             	add    $0x8,%eax
  800e89:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800e8c:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800e8f:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  800e94:	eb 51                	jmp    800ee7 <vprintfmt+0x5c5>
  800e96:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e9a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800e9e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ea2:	eb e8                	jmp    800e8c <vprintfmt+0x56a>
        return va_arg(*ap, unsigned long long);
  800ea4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ea8:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800eac:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800eb0:	e9 5c ff ff ff       	jmp    800e11 <vprintfmt+0x4ef>
            putch('0', put_arg);
  800eb5:	4c 89 ee             	mov    %r13,%rsi
  800eb8:	bf 30 00 00 00       	mov    $0x30,%edi
  800ebd:	41 ff d6             	call   *%r14
            putch('x', put_arg);
  800ec0:	4c 89 ee             	mov    %r13,%rsi
  800ec3:	bf 78 00 00 00       	mov    $0x78,%edi
  800ec8:	41 ff d6             	call   *%r14
            num = (uintptr_t)va_arg(aq, void *);
  800ecb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ece:	83 f8 2f             	cmp    $0x2f,%eax
  800ed1:	77 47                	ja     800f1a <vprintfmt+0x5f8>
  800ed3:	89 c2                	mov    %eax,%edx
  800ed5:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800ed9:	83 c0 08             	add    $0x8,%eax
  800edc:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800edf:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800ee2:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  800ee7:	48 83 ec 08          	sub    $0x8,%rsp
  800eeb:	80 7d a0 58          	cmpb   $0x58,-0x60(%rbp)
  800eef:	0f 94 c0             	sete   %al
  800ef2:	0f b6 c0             	movzbl %al,%eax
  800ef5:	50                   	push   %rax
  800ef6:	44 0f be 4d aa       	movsbl -0x56(%rbp),%r9d
  800efb:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  800eff:	4c 89 ee             	mov    %r13,%rsi
  800f02:	4c 89 f7             	mov    %r14,%rdi
  800f05:	48 b8 0b 08 80 00 00 	movabs $0x80080b,%rax
  800f0c:	00 00 00 
  800f0f:	ff d0                	call   *%rax
            break;
  800f11:	48 83 c4 10          	add    $0x10,%rsp
  800f15:	e9 3d fa ff ff       	jmp    800957 <vprintfmt+0x35>
            num = (uintptr_t)va_arg(aq, void *);
  800f1a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800f1e:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800f22:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800f26:	eb b7                	jmp    800edf <vprintfmt+0x5bd>
    if (zflag) return va_arg(*ap, size_t);
  800f28:	40 84 f6             	test   %sil,%sil
  800f2b:	75 2b                	jne    800f58 <vprintfmt+0x636>
    switch (lflag) {
  800f2d:	85 d2                	test   %edx,%edx
  800f2f:	74 56                	je     800f87 <vprintfmt+0x665>
  800f31:	83 fa 01             	cmp    $0x1,%edx
  800f34:	74 7f                	je     800fb5 <vprintfmt+0x693>
        return va_arg(*ap, unsigned long long);
  800f36:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f39:	83 f8 2f             	cmp    $0x2f,%eax
  800f3c:	0f 87 a2 00 00 00    	ja     800fe4 <vprintfmt+0x6c2>
  800f42:	89 c2                	mov    %eax,%edx
  800f44:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800f48:	83 c0 08             	add    $0x8,%eax
  800f4b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800f4e:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800f51:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800f56:	eb 8f                	jmp    800ee7 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800f58:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f5b:	83 f8 2f             	cmp    $0x2f,%eax
  800f5e:	77 19                	ja     800f79 <vprintfmt+0x657>
  800f60:	89 c2                	mov    %eax,%edx
  800f62:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800f66:	83 c0 08             	add    $0x8,%eax
  800f69:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800f6c:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800f6f:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800f74:	e9 6e ff ff ff       	jmp    800ee7 <vprintfmt+0x5c5>
  800f79:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800f7d:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800f81:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800f85:	eb e5                	jmp    800f6c <vprintfmt+0x64a>
        return va_arg(*ap, unsigned int);
  800f87:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f8a:	83 f8 2f             	cmp    $0x2f,%eax
  800f8d:	77 18                	ja     800fa7 <vprintfmt+0x685>
  800f8f:	89 c2                	mov    %eax,%edx
  800f91:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800f95:	83 c0 08             	add    $0x8,%eax
  800f98:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800f9b:	8b 12                	mov    (%rdx),%edx
            base = 16;
  800f9d:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  800fa2:	e9 40 ff ff ff       	jmp    800ee7 <vprintfmt+0x5c5>
  800fa7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800fab:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800faf:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800fb3:	eb e6                	jmp    800f9b <vprintfmt+0x679>
        return va_arg(*ap, unsigned long);
  800fb5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800fb8:	83 f8 2f             	cmp    $0x2f,%eax
  800fbb:	77 19                	ja     800fd6 <vprintfmt+0x6b4>
  800fbd:	89 c2                	mov    %eax,%edx
  800fbf:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800fc3:	83 c0 08             	add    $0x8,%eax
  800fc6:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800fc9:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800fcc:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800fd1:	e9 11 ff ff ff       	jmp    800ee7 <vprintfmt+0x5c5>
  800fd6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800fda:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800fde:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800fe2:	eb e5                	jmp    800fc9 <vprintfmt+0x6a7>
        return va_arg(*ap, unsigned long long);
  800fe4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800fe8:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800fec:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ff0:	e9 59 ff ff ff       	jmp    800f4e <vprintfmt+0x62c>
            putch(ch, put_arg);
  800ff5:	4c 89 ee             	mov    %r13,%rsi
  800ff8:	bf 25 00 00 00       	mov    $0x25,%edi
  800ffd:	41 ff d6             	call   *%r14
            break;
  801000:	e9 52 f9 ff ff       	jmp    800957 <vprintfmt+0x35>
            putch('%', put_arg);
  801005:	4c 89 ee             	mov    %r13,%rsi
  801008:	bf 25 00 00 00       	mov    $0x25,%edi
  80100d:	41 ff d6             	call   *%r14
            while ((--ufmt)[-1] != '%') /* nothing */
  801010:	48 83 eb 01          	sub    $0x1,%rbx
  801014:	80 7b ff 25          	cmpb   $0x25,-0x1(%rbx)
  801018:	75 f6                	jne    801010 <vprintfmt+0x6ee>
  80101a:	e9 38 f9 ff ff       	jmp    800957 <vprintfmt+0x35>
}
  80101f:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  801023:	5b                   	pop    %rbx
  801024:	41 5c                	pop    %r12
  801026:	41 5d                	pop    %r13
  801028:	41 5e                	pop    %r14
  80102a:	41 5f                	pop    %r15
  80102c:	5d                   	pop    %rbp
  80102d:	c3                   	ret

000000000080102e <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  80102e:	f3 0f 1e fa          	endbr64
  801032:	55                   	push   %rbp
  801033:	48 89 e5             	mov    %rsp,%rbp
  801036:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  80103a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80103e:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  801043:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  801047:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  80104e:	48 85 ff             	test   %rdi,%rdi
  801051:	74 2b                	je     80107e <vsnprintf+0x50>
  801053:	48 85 f6             	test   %rsi,%rsi
  801056:	74 26                	je     80107e <vsnprintf+0x50>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  801058:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  80105c:	48 bf c5 08 80 00 00 	movabs $0x8008c5,%rdi
  801063:	00 00 00 
  801066:	48 b8 22 09 80 00 00 	movabs $0x800922,%rax
  80106d:	00 00 00 
  801070:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  801072:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801076:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  801079:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80107c:	c9                   	leave
  80107d:	c3                   	ret
    if (!buf || n < 1) return -E_INVAL;
  80107e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801083:	eb f7                	jmp    80107c <vsnprintf+0x4e>

0000000000801085 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  801085:	f3 0f 1e fa          	endbr64
  801089:	55                   	push   %rbp
  80108a:	48 89 e5             	mov    %rsp,%rbp
  80108d:	48 83 ec 50          	sub    $0x50,%rsp
  801091:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801095:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  801099:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  80109d:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  8010a4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8010a8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8010ac:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8010b0:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  8010b4:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  8010b8:	48 b8 2e 10 80 00 00 	movabs $0x80102e,%rax
  8010bf:	00 00 00 
  8010c2:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  8010c4:	c9                   	leave
  8010c5:	c3                   	ret

00000000008010c6 <strlen>:
 * Primespipe runs 3x faster this way */

#define ASM 1

size_t
strlen(const char *s) {
  8010c6:	f3 0f 1e fa          	endbr64
    size_t n = 0;
    while (*s++) n++;
  8010ca:	80 3f 00             	cmpb   $0x0,(%rdi)
  8010cd:	74 10                	je     8010df <strlen+0x19>
    size_t n = 0;
  8010cf:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  8010d4:	48 83 c0 01          	add    $0x1,%rax
  8010d8:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  8010dc:	75 f6                	jne    8010d4 <strlen+0xe>
  8010de:	c3                   	ret
    size_t n = 0;
  8010df:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  8010e4:	c3                   	ret

00000000008010e5 <strnlen>:

size_t
strnlen(const char *s, size_t size) {
  8010e5:	f3 0f 1e fa          	endbr64
  8010e9:	48 89 f0             	mov    %rsi,%rax
    size_t n = 0;
  8010ec:	ba 00 00 00 00       	mov    $0x0,%edx
    while (n < size && *s++) n++;
  8010f1:	48 85 f6             	test   %rsi,%rsi
  8010f4:	74 10                	je     801106 <strnlen+0x21>
  8010f6:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  8010fa:	74 0b                	je     801107 <strnlen+0x22>
  8010fc:	48 83 c2 01          	add    $0x1,%rdx
  801100:	48 39 d0             	cmp    %rdx,%rax
  801103:	75 f1                	jne    8010f6 <strnlen+0x11>
  801105:	c3                   	ret
  801106:	c3                   	ret
  801107:	48 89 d0             	mov    %rdx,%rax
    return n;
}
  80110a:	c3                   	ret

000000000080110b <strcpy>:

char *
strcpy(char *dst, const char *src) {
  80110b:	f3 0f 1e fa          	endbr64
  80110f:	48 89 f8             	mov    %rdi,%rax
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  801112:	ba 00 00 00 00       	mov    $0x0,%edx
  801117:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  80111b:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  80111e:	48 83 c2 01          	add    $0x1,%rdx
  801122:	84 c9                	test   %cl,%cl
  801124:	75 f1                	jne    801117 <strcpy+0xc>
        ;
    return res;
}
  801126:	c3                   	ret

0000000000801127 <strcat>:

char *
strcat(char *dst, const char *src) {
  801127:	f3 0f 1e fa          	endbr64
  80112b:	55                   	push   %rbp
  80112c:	48 89 e5             	mov    %rsp,%rbp
  80112f:	41 54                	push   %r12
  801131:	53                   	push   %rbx
  801132:	48 89 fb             	mov    %rdi,%rbx
  801135:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  801138:	48 b8 c6 10 80 00 00 	movabs $0x8010c6,%rax
  80113f:	00 00 00 
  801142:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  801144:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  801148:	4c 89 e6             	mov    %r12,%rsi
  80114b:	48 b8 0b 11 80 00 00 	movabs $0x80110b,%rax
  801152:	00 00 00 
  801155:	ff d0                	call   *%rax
    return dst;
}
  801157:	48 89 d8             	mov    %rbx,%rax
  80115a:	5b                   	pop    %rbx
  80115b:	41 5c                	pop    %r12
  80115d:	5d                   	pop    %rbp
  80115e:	c3                   	ret

000000000080115f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80115f:	f3 0f 1e fa          	endbr64
  801163:	48 89 f8             	mov    %rdi,%rax
    char *ret = dst;
    while (size-- > 0) {
  801166:	48 85 d2             	test   %rdx,%rdx
  801169:	74 1f                	je     80118a <strncpy+0x2b>
  80116b:	48 01 fa             	add    %rdi,%rdx
  80116e:	48 89 f9             	mov    %rdi,%rcx
        *dst++ = *src;
  801171:	48 83 c1 01          	add    $0x1,%rcx
  801175:	44 0f b6 06          	movzbl (%rsi),%r8d
  801179:	44 88 41 ff          	mov    %r8b,-0x1(%rcx)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  80117d:	41 80 f8 01          	cmp    $0x1,%r8b
  801181:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  801185:	48 39 ca             	cmp    %rcx,%rdx
  801188:	75 e7                	jne    801171 <strncpy+0x12>
    }
    return ret;
}
  80118a:	c3                   	ret

000000000080118b <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
  80118b:	f3 0f 1e fa          	endbr64
    char *dst_in = dst;
    if (size) {
  80118f:	48 89 f8             	mov    %rdi,%rax
  801192:	48 85 d2             	test   %rdx,%rdx
  801195:	74 24                	je     8011bb <strlcpy+0x30>
        while (--size > 0 && *src)
  801197:	48 83 ea 01          	sub    $0x1,%rdx
  80119b:	74 1b                	je     8011b8 <strlcpy+0x2d>
  80119d:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  8011a1:	0f b6 16             	movzbl (%rsi),%edx
  8011a4:	84 d2                	test   %dl,%dl
  8011a6:	74 10                	je     8011b8 <strlcpy+0x2d>
            *dst++ = *src++;
  8011a8:	48 83 c6 01          	add    $0x1,%rsi
  8011ac:	48 83 c0 01          	add    $0x1,%rax
  8011b0:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  8011b3:	48 39 c8             	cmp    %rcx,%rax
  8011b6:	75 e9                	jne    8011a1 <strlcpy+0x16>
        *dst = '\0';
  8011b8:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  8011bb:	48 29 f8             	sub    %rdi,%rax
}
  8011be:	c3                   	ret

00000000008011bf <strcmp>:
    }
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
  8011bf:	f3 0f 1e fa          	endbr64
    while (*p && *p == *q) p++, q++;
  8011c3:	0f b6 07             	movzbl (%rdi),%eax
  8011c6:	84 c0                	test   %al,%al
  8011c8:	74 13                	je     8011dd <strcmp+0x1e>
  8011ca:	38 06                	cmp    %al,(%rsi)
  8011cc:	75 0f                	jne    8011dd <strcmp+0x1e>
  8011ce:	48 83 c7 01          	add    $0x1,%rdi
  8011d2:	48 83 c6 01          	add    $0x1,%rsi
  8011d6:	0f b6 07             	movzbl (%rdi),%eax
  8011d9:	84 c0                	test   %al,%al
  8011db:	75 ed                	jne    8011ca <strcmp+0xb>
    return (int)((unsigned char)*p - (unsigned char)*q);
  8011dd:	0f b6 c0             	movzbl %al,%eax
  8011e0:	0f b6 16             	movzbl (%rsi),%edx
  8011e3:	29 d0                	sub    %edx,%eax
}
  8011e5:	c3                   	ret

00000000008011e6 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
  8011e6:	f3 0f 1e fa          	endbr64
    while (n && *p && *p == *q) n--, p++, q++;
  8011ea:	48 85 d2             	test   %rdx,%rdx
  8011ed:	74 1f                	je     80120e <strncmp+0x28>
  8011ef:	0f b6 07             	movzbl (%rdi),%eax
  8011f2:	84 c0                	test   %al,%al
  8011f4:	74 1e                	je     801214 <strncmp+0x2e>
  8011f6:	3a 06                	cmp    (%rsi),%al
  8011f8:	75 1a                	jne    801214 <strncmp+0x2e>
  8011fa:	48 83 c7 01          	add    $0x1,%rdi
  8011fe:	48 83 c6 01          	add    $0x1,%rsi
  801202:	48 83 ea 01          	sub    $0x1,%rdx
  801206:	75 e7                	jne    8011ef <strncmp+0x9>

    if (!n) return 0;
  801208:	b8 00 00 00 00       	mov    $0x0,%eax
  80120d:	c3                   	ret
  80120e:	b8 00 00 00 00       	mov    $0x0,%eax
  801213:	c3                   	ret

    return (int)((unsigned char)*p - (unsigned char)*q);
  801214:	0f b6 07             	movzbl (%rdi),%eax
  801217:	0f b6 16             	movzbl (%rsi),%edx
  80121a:	29 d0                	sub    %edx,%eax
}
  80121c:	c3                   	ret

000000000080121d <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
  80121d:	f3 0f 1e fa          	endbr64
    for (; *str; str++) {
  801221:	0f b6 17             	movzbl (%rdi),%edx
  801224:	84 d2                	test   %dl,%dl
  801226:	74 18                	je     801240 <strchr+0x23>
        if (*str == c) {
  801228:	0f be d2             	movsbl %dl,%edx
  80122b:	39 f2                	cmp    %esi,%edx
  80122d:	74 17                	je     801246 <strchr+0x29>
    for (; *str; str++) {
  80122f:	48 83 c7 01          	add    $0x1,%rdi
  801233:	0f b6 17             	movzbl (%rdi),%edx
  801236:	84 d2                	test   %dl,%dl
  801238:	75 ee                	jne    801228 <strchr+0xb>
            return (char *)str;
        }
    }
    return NULL;
  80123a:	b8 00 00 00 00       	mov    $0x0,%eax
  80123f:	c3                   	ret
  801240:	b8 00 00 00 00       	mov    $0x0,%eax
  801245:	c3                   	ret
            return (char *)str;
  801246:	48 89 f8             	mov    %rdi,%rax
}
  801249:	c3                   	ret

000000000080124a <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
  80124a:	f3 0f 1e fa          	endbr64
  80124e:	48 89 f8             	mov    %rdi,%rax
    for (; *str && *str != ch; str++) /* nothing */
  801251:	0f b6 17             	movzbl (%rdi),%edx
  801254:	84 d2                	test   %dl,%dl
  801256:	74 13                	je     80126b <strfind+0x21>
  801258:	0f be d2             	movsbl %dl,%edx
  80125b:	39 f2                	cmp    %esi,%edx
  80125d:	74 0b                	je     80126a <strfind+0x20>
  80125f:	48 83 c0 01          	add    $0x1,%rax
  801263:	0f b6 10             	movzbl (%rax),%edx
  801266:	84 d2                	test   %dl,%dl
  801268:	75 ee                	jne    801258 <strfind+0xe>
        ;
    return (char *)str;
}
  80126a:	c3                   	ret
  80126b:	c3                   	ret

000000000080126c <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  80126c:	f3 0f 1e fa          	endbr64
  801270:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  801273:	48 89 f8             	mov    %rdi,%rax
  801276:	48 f7 d8             	neg    %rax
  801279:	83 e0 07             	and    $0x7,%eax
  80127c:	49 89 d1             	mov    %rdx,%r9
  80127f:	49 29 c1             	sub    %rax,%r9
  801282:	78 36                	js     8012ba <memset+0x4e>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  801284:	40 0f b6 c6          	movzbl %sil,%eax
  801288:	48 b9 01 01 01 01 01 	movabs $0x101010101010101,%rcx
  80128f:	01 01 01 
  801292:	48 0f af c1          	imul   %rcx,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  801296:	40 f6 c7 07          	test   $0x7,%dil
  80129a:	75 38                	jne    8012d4 <memset+0x68>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  80129c:	4c 89 c9             	mov    %r9,%rcx
  80129f:	48 c1 f9 03          	sar    $0x3,%rcx
  8012a3:	74 0c                	je     8012b1 <memset+0x45>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  8012a5:	fc                   	cld
  8012a6:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  8012a9:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  8012ad:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  8012b1:	4d 85 c9             	test   %r9,%r9
  8012b4:	75 45                	jne    8012fb <memset+0x8f>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  8012b6:	4c 89 c0             	mov    %r8,%rax
  8012b9:	c3                   	ret
        while (n-- > 0) *ptr++ = c;
  8012ba:	48 85 d2             	test   %rdx,%rdx
  8012bd:	74 f7                	je     8012b6 <memset+0x4a>
  8012bf:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  8012c2:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  8012c5:	48 83 c0 01          	add    $0x1,%rax
  8012c9:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  8012cd:	48 39 c2             	cmp    %rax,%rdx
  8012d0:	75 f3                	jne    8012c5 <memset+0x59>
  8012d2:	eb e2                	jmp    8012b6 <memset+0x4a>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  8012d4:	40 f6 c7 01          	test   $0x1,%dil
  8012d8:	74 06                	je     8012e0 <memset+0x74>
  8012da:	88 07                	mov    %al,(%rdi)
  8012dc:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  8012e0:	40 f6 c7 02          	test   $0x2,%dil
  8012e4:	74 07                	je     8012ed <memset+0x81>
  8012e6:	66 89 07             	mov    %ax,(%rdi)
  8012e9:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  8012ed:	40 f6 c7 04          	test   $0x4,%dil
  8012f1:	74 a9                	je     80129c <memset+0x30>
  8012f3:	89 07                	mov    %eax,(%rdi)
  8012f5:	48 83 c7 04          	add    $0x4,%rdi
  8012f9:	eb a1                	jmp    80129c <memset+0x30>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  8012fb:	41 f6 c1 04          	test   $0x4,%r9b
  8012ff:	74 1b                	je     80131c <memset+0xb0>
  801301:	89 07                	mov    %eax,(%rdi)
  801303:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  801307:	41 f6 c1 02          	test   $0x2,%r9b
  80130b:	74 07                	je     801314 <memset+0xa8>
  80130d:	66 89 07             	mov    %ax,(%rdi)
  801310:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  801314:	41 f6 c1 01          	test   $0x1,%r9b
  801318:	74 9c                	je     8012b6 <memset+0x4a>
  80131a:	eb 06                	jmp    801322 <memset+0xb6>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  80131c:	41 f6 c1 02          	test   $0x2,%r9b
  801320:	75 eb                	jne    80130d <memset+0xa1>
        if (ni & 1) *ptr = k;
  801322:	88 07                	mov    %al,(%rdi)
  801324:	eb 90                	jmp    8012b6 <memset+0x4a>

0000000000801326 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  801326:	f3 0f 1e fa          	endbr64
  80132a:	48 89 f8             	mov    %rdi,%rax
  80132d:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  801330:	48 39 fe             	cmp    %rdi,%rsi
  801333:	73 3b                	jae    801370 <memmove+0x4a>
  801335:	48 8d 14 16          	lea    (%rsi,%rdx,1),%rdx
  801339:	48 39 d7             	cmp    %rdx,%rdi
  80133c:	73 32                	jae    801370 <memmove+0x4a>
        s += n;
        d += n;
  80133e:	48 8d 3c 0f          	lea    (%rdi,%rcx,1),%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  801342:	48 89 d6             	mov    %rdx,%rsi
  801345:	48 09 fe             	or     %rdi,%rsi
  801348:	48 09 ce             	or     %rcx,%rsi
  80134b:	40 f6 c6 07          	test   $0x7,%sil
  80134f:	75 12                	jne    801363 <memmove+0x3d>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  801351:	48 83 ef 08          	sub    $0x8,%rdi
  801355:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  801359:	48 c1 e9 03          	shr    $0x3,%rcx
  80135d:	fd                   	std
  80135e:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  801361:	fc                   	cld
  801362:	c3                   	ret
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  801363:	48 83 ef 01          	sub    $0x1,%rdi
  801367:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  80136b:	fd                   	std
  80136c:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  80136e:	eb f1                	jmp    801361 <memmove+0x3b>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  801370:	48 89 f2             	mov    %rsi,%rdx
  801373:	48 09 c2             	or     %rax,%rdx
  801376:	48 09 ca             	or     %rcx,%rdx
  801379:	f6 c2 07             	test   $0x7,%dl
  80137c:	75 0c                	jne    80138a <memmove+0x64>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  80137e:	48 c1 e9 03          	shr    $0x3,%rcx
  801382:	48 89 c7             	mov    %rax,%rdi
  801385:	fc                   	cld
  801386:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  801389:	c3                   	ret
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  80138a:	48 89 c7             	mov    %rax,%rdi
  80138d:	fc                   	cld
  80138e:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  801390:	c3                   	ret

0000000000801391 <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  801391:	f3 0f 1e fa          	endbr64
  801395:	55                   	push   %rbp
  801396:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  801399:	48 b8 26 13 80 00 00 	movabs $0x801326,%rax
  8013a0:	00 00 00 
  8013a3:	ff d0                	call   *%rax
}
  8013a5:	5d                   	pop    %rbp
  8013a6:	c3                   	ret

00000000008013a7 <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  8013a7:	f3 0f 1e fa          	endbr64
  8013ab:	55                   	push   %rbp
  8013ac:	48 89 e5             	mov    %rsp,%rbp
  8013af:	41 57                	push   %r15
  8013b1:	41 56                	push   %r14
  8013b3:	41 55                	push   %r13
  8013b5:	41 54                	push   %r12
  8013b7:	53                   	push   %rbx
  8013b8:	48 83 ec 08          	sub    $0x8,%rsp
  8013bc:	49 89 fe             	mov    %rdi,%r14
  8013bf:	49 89 f7             	mov    %rsi,%r15
  8013c2:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  8013c5:	48 89 f7             	mov    %rsi,%rdi
  8013c8:	48 b8 c6 10 80 00 00 	movabs $0x8010c6,%rax
  8013cf:	00 00 00 
  8013d2:	ff d0                	call   *%rax
  8013d4:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  8013d7:	48 89 de             	mov    %rbx,%rsi
  8013da:	4c 89 f7             	mov    %r14,%rdi
  8013dd:	48 b8 e5 10 80 00 00 	movabs $0x8010e5,%rax
  8013e4:	00 00 00 
  8013e7:	ff d0                	call   *%rax
  8013e9:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  8013ec:	48 39 c3             	cmp    %rax,%rbx
  8013ef:	74 36                	je     801427 <strlcat+0x80>
    if (srclen < maxlen - dstlen) {
  8013f1:	48 89 d8             	mov    %rbx,%rax
  8013f4:	4c 29 e8             	sub    %r13,%rax
  8013f7:	49 39 c4             	cmp    %rax,%r12
  8013fa:	73 31                	jae    80142d <strlcat+0x86>
        memcpy(dst + dstlen, src, srclen + 1);
  8013fc:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  801401:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  801405:	4c 89 fe             	mov    %r15,%rsi
  801408:	48 b8 91 13 80 00 00 	movabs $0x801391,%rax
  80140f:	00 00 00 
  801412:	ff d0                	call   *%rax
    return dstlen + srclen;
  801414:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  801418:	48 83 c4 08          	add    $0x8,%rsp
  80141c:	5b                   	pop    %rbx
  80141d:	41 5c                	pop    %r12
  80141f:	41 5d                	pop    %r13
  801421:	41 5e                	pop    %r14
  801423:	41 5f                	pop    %r15
  801425:	5d                   	pop    %rbp
  801426:	c3                   	ret
    if (dstlen == maxlen) return maxlen + srclen;
  801427:	49 8d 04 04          	lea    (%r12,%rax,1),%rax
  80142b:	eb eb                	jmp    801418 <strlcat+0x71>
        memcpy(dst + dstlen, src, maxlen - 1);
  80142d:	48 83 eb 01          	sub    $0x1,%rbx
  801431:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  801435:	48 89 da             	mov    %rbx,%rdx
  801438:	4c 89 fe             	mov    %r15,%rsi
  80143b:	48 b8 91 13 80 00 00 	movabs $0x801391,%rax
  801442:	00 00 00 
  801445:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  801447:	49 01 de             	add    %rbx,%r14
  80144a:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  80144f:	eb c3                	jmp    801414 <strlcat+0x6d>

0000000000801451 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  801451:	f3 0f 1e fa          	endbr64
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  801455:	48 85 d2             	test   %rdx,%rdx
  801458:	74 2d                	je     801487 <memcmp+0x36>
  80145a:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  80145f:	0f b6 0c 07          	movzbl (%rdi,%rax,1),%ecx
  801463:	44 0f b6 04 06       	movzbl (%rsi,%rax,1),%r8d
  801468:	44 38 c1             	cmp    %r8b,%cl
  80146b:	75 0f                	jne    80147c <memcmp+0x2b>
    while (n-- > 0) {
  80146d:	48 83 c0 01          	add    $0x1,%rax
  801471:	48 39 c2             	cmp    %rax,%rdx
  801474:	75 e9                	jne    80145f <memcmp+0xe>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  801476:	b8 00 00 00 00       	mov    $0x0,%eax
  80147b:	c3                   	ret
            return (int)*s1 - (int)*s2;
  80147c:	0f b6 c1             	movzbl %cl,%eax
  80147f:	45 0f b6 c0          	movzbl %r8b,%r8d
  801483:	44 29 c0             	sub    %r8d,%eax
  801486:	c3                   	ret
    return 0;
  801487:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80148c:	c3                   	ret

000000000080148d <memfind>:

void *
memfind(const void *src, int c, size_t n) {
  80148d:	f3 0f 1e fa          	endbr64
    const void *end = (const char *)src + n;
  801491:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  801495:	48 39 c7             	cmp    %rax,%rdi
  801498:	73 0f                	jae    8014a9 <memfind+0x1c>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  80149a:	40 38 37             	cmp    %sil,(%rdi)
  80149d:	74 0e                	je     8014ad <memfind+0x20>
    for (; src < end; src++) {
  80149f:	48 83 c7 01          	add    $0x1,%rdi
  8014a3:	48 39 f8             	cmp    %rdi,%rax
  8014a6:	75 f2                	jne    80149a <memfind+0xd>
  8014a8:	c3                   	ret
  8014a9:	48 89 f8             	mov    %rdi,%rax
  8014ac:	c3                   	ret
  8014ad:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  8014b0:	c3                   	ret

00000000008014b1 <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  8014b1:	f3 0f 1e fa          	endbr64
  8014b5:	49 89 f2             	mov    %rsi,%r10
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  8014b8:	0f b6 37             	movzbl (%rdi),%esi
  8014bb:	40 80 fe 20          	cmp    $0x20,%sil
  8014bf:	74 06                	je     8014c7 <strtol+0x16>
  8014c1:	40 80 fe 09          	cmp    $0x9,%sil
  8014c5:	75 13                	jne    8014da <strtol+0x29>
  8014c7:	48 83 c7 01          	add    $0x1,%rdi
  8014cb:	0f b6 37             	movzbl (%rdi),%esi
  8014ce:	40 80 fe 20          	cmp    $0x20,%sil
  8014d2:	74 f3                	je     8014c7 <strtol+0x16>
  8014d4:	40 80 fe 09          	cmp    $0x9,%sil
  8014d8:	74 ed                	je     8014c7 <strtol+0x16>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  8014da:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  8014dd:	83 e0 fd             	and    $0xfffffffd,%eax
  8014e0:	3c 01                	cmp    $0x1,%al
  8014e2:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  8014e6:	f7 c2 ef ff ff ff    	test   $0xffffffef,%edx
  8014ec:	75 0f                	jne    8014fd <strtol+0x4c>
  8014ee:	80 3f 30             	cmpb   $0x30,(%rdi)
  8014f1:	74 14                	je     801507 <strtol+0x56>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  8014f3:	85 d2                	test   %edx,%edx
  8014f5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8014fa:	0f 44 d0             	cmove  %eax,%edx
    }

    /* Digits */
    long val = 0;
  8014fd:	b8 00 00 00 00       	mov    $0x0,%eax
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  801502:	4c 63 ca             	movslq %edx,%r9
  801505:	eb 36                	jmp    80153d <strtol+0x8c>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  801507:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  80150b:	74 0f                	je     80151c <strtol+0x6b>
    } else if (!base && s[0] == '0') {
  80150d:	85 d2                	test   %edx,%edx
  80150f:	75 ec                	jne    8014fd <strtol+0x4c>
        s++;
  801511:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  801515:	ba 08 00 00 00       	mov    $0x8,%edx
        s++;
  80151a:	eb e1                	jmp    8014fd <strtol+0x4c>
        s += 2;
  80151c:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  801520:	ba 10 00 00 00       	mov    $0x10,%edx
        s += 2;
  801525:	eb d6                	jmp    8014fd <strtol+0x4c>
            dig -= '0';
  801527:	83 e9 30             	sub    $0x30,%ecx
        if (dig >= base) break;
  80152a:	44 0f b6 c1          	movzbl %cl,%r8d
  80152e:	41 39 d0             	cmp    %edx,%r8d
  801531:	7d 21                	jge    801554 <strtol+0xa3>
        val = val * base + dig;
  801533:	49 0f af c1          	imul   %r9,%rax
  801537:	0f b6 c9             	movzbl %cl,%ecx
  80153a:	48 01 c8             	add    %rcx,%rax
        uint8_t dig = *s++;
  80153d:	48 83 c7 01          	add    $0x1,%rdi
  801541:	0f b6 4f ff          	movzbl -0x1(%rdi),%ecx
        if (dig - '0' < 10)
  801545:	80 f9 39             	cmp    $0x39,%cl
  801548:	76 dd                	jbe    801527 <strtol+0x76>
        else if (dig - 'a' < 27)
  80154a:	80 f9 7b             	cmp    $0x7b,%cl
  80154d:	77 05                	ja     801554 <strtol+0xa3>
            dig -= 'a' - 10;
  80154f:	83 e9 57             	sub    $0x57,%ecx
  801552:	eb d6                	jmp    80152a <strtol+0x79>
    }

    if (endptr) *endptr = (char *)s;
  801554:	4d 85 d2             	test   %r10,%r10
  801557:	74 03                	je     80155c <strtol+0xab>
  801559:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  80155c:	48 89 c2             	mov    %rax,%rdx
  80155f:	48 f7 da             	neg    %rdx
  801562:	40 80 fe 2d          	cmp    $0x2d,%sil
  801566:	48 0f 44 c2          	cmove  %rdx,%rax
}
  80156a:	c3                   	ret

000000000080156b <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  80156b:	f3 0f 1e fa          	endbr64
  80156f:	55                   	push   %rbp
  801570:	48 89 e5             	mov    %rsp,%rbp
  801573:	53                   	push   %rbx
  801574:	48 89 fa             	mov    %rdi,%rdx
  801577:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80157a:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80157f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801584:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801589:	be 00 00 00 00       	mov    $0x0,%esi
  80158e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801594:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  801596:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80159a:	c9                   	leave
  80159b:	c3                   	ret

000000000080159c <sys_cgetc>:

int
sys_cgetc(void) {
  80159c:	f3 0f 1e fa          	endbr64
  8015a0:	55                   	push   %rbp
  8015a1:	48 89 e5             	mov    %rsp,%rbp
  8015a4:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8015a5:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8015aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8015af:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8015b4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015b9:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8015be:	be 00 00 00 00       	mov    $0x0,%esi
  8015c3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8015c9:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  8015cb:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8015cf:	c9                   	leave
  8015d0:	c3                   	ret

00000000008015d1 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  8015d1:	f3 0f 1e fa          	endbr64
  8015d5:	55                   	push   %rbp
  8015d6:	48 89 e5             	mov    %rsp,%rbp
  8015d9:	53                   	push   %rbx
  8015da:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  8015de:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8015e1:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8015e6:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8015eb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015f0:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8015f5:	be 00 00 00 00       	mov    $0x0,%esi
  8015fa:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801600:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801602:	48 85 c0             	test   %rax,%rax
  801605:	7f 06                	jg     80160d <sys_env_destroy+0x3c>
}
  801607:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80160b:	c9                   	leave
  80160c:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80160d:	49 89 c0             	mov    %rax,%r8
  801610:	b9 03 00 00 00       	mov    $0x3,%ecx
  801615:	48 ba 58 44 80 00 00 	movabs $0x804458,%rdx
  80161c:	00 00 00 
  80161f:	be 26 00 00 00       	mov    $0x26,%esi
  801624:	48 bf 6c 42 80 00 00 	movabs $0x80426c,%rdi
  80162b:	00 00 00 
  80162e:	b8 00 00 00 00       	mov    $0x0,%eax
  801633:	49 b9 66 06 80 00 00 	movabs $0x800666,%r9
  80163a:	00 00 00 
  80163d:	41 ff d1             	call   *%r9

0000000000801640 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  801640:	f3 0f 1e fa          	endbr64
  801644:	55                   	push   %rbp
  801645:	48 89 e5             	mov    %rsp,%rbp
  801648:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801649:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80164e:	ba 00 00 00 00       	mov    $0x0,%edx
  801653:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801658:	bb 00 00 00 00       	mov    $0x0,%ebx
  80165d:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801662:	be 00 00 00 00       	mov    $0x0,%esi
  801667:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80166d:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  80166f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801673:	c9                   	leave
  801674:	c3                   	ret

0000000000801675 <sys_yield>:

void
sys_yield(void) {
  801675:	f3 0f 1e fa          	endbr64
  801679:	55                   	push   %rbp
  80167a:	48 89 e5             	mov    %rsp,%rbp
  80167d:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80167e:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801683:	ba 00 00 00 00       	mov    $0x0,%edx
  801688:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80168d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801692:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801697:	be 00 00 00 00       	mov    $0x0,%esi
  80169c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8016a2:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  8016a4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8016a8:	c9                   	leave
  8016a9:	c3                   	ret

00000000008016aa <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  8016aa:	f3 0f 1e fa          	endbr64
  8016ae:	55                   	push   %rbp
  8016af:	48 89 e5             	mov    %rsp,%rbp
  8016b2:	53                   	push   %rbx
  8016b3:	48 89 fa             	mov    %rdi,%rdx
  8016b6:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8016b9:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8016be:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  8016c5:	00 00 00 
  8016c8:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8016cd:	be 00 00 00 00       	mov    $0x0,%esi
  8016d2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8016d8:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  8016da:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8016de:	c9                   	leave
  8016df:	c3                   	ret

00000000008016e0 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  8016e0:	f3 0f 1e fa          	endbr64
  8016e4:	55                   	push   %rbp
  8016e5:	48 89 e5             	mov    %rsp,%rbp
  8016e8:	53                   	push   %rbx
  8016e9:	49 89 f8             	mov    %rdi,%r8
  8016ec:	48 89 d3             	mov    %rdx,%rbx
  8016ef:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  8016f2:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8016f7:	4c 89 c2             	mov    %r8,%rdx
  8016fa:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8016fd:	be 00 00 00 00       	mov    $0x0,%esi
  801702:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801708:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  80170a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80170e:	c9                   	leave
  80170f:	c3                   	ret

0000000000801710 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  801710:	f3 0f 1e fa          	endbr64
  801714:	55                   	push   %rbp
  801715:	48 89 e5             	mov    %rsp,%rbp
  801718:	53                   	push   %rbx
  801719:	48 83 ec 08          	sub    $0x8,%rsp
  80171d:	89 f8                	mov    %edi,%eax
  80171f:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  801722:	48 63 f9             	movslq %ecx,%rdi
  801725:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801728:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80172d:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801730:	be 00 00 00 00       	mov    $0x0,%esi
  801735:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80173b:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80173d:	48 85 c0             	test   %rax,%rax
  801740:	7f 06                	jg     801748 <sys_alloc_region+0x38>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  801742:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801746:	c9                   	leave
  801747:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801748:	49 89 c0             	mov    %rax,%r8
  80174b:	b9 04 00 00 00       	mov    $0x4,%ecx
  801750:	48 ba 58 44 80 00 00 	movabs $0x804458,%rdx
  801757:	00 00 00 
  80175a:	be 26 00 00 00       	mov    $0x26,%esi
  80175f:	48 bf 6c 42 80 00 00 	movabs $0x80426c,%rdi
  801766:	00 00 00 
  801769:	b8 00 00 00 00       	mov    $0x0,%eax
  80176e:	49 b9 66 06 80 00 00 	movabs $0x800666,%r9
  801775:	00 00 00 
  801778:	41 ff d1             	call   *%r9

000000000080177b <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  80177b:	f3 0f 1e fa          	endbr64
  80177f:	55                   	push   %rbp
  801780:	48 89 e5             	mov    %rsp,%rbp
  801783:	53                   	push   %rbx
  801784:	48 83 ec 08          	sub    $0x8,%rsp
  801788:	89 f8                	mov    %edi,%eax
  80178a:	49 89 f2             	mov    %rsi,%r10
  80178d:	48 89 cf             	mov    %rcx,%rdi
  801790:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  801793:	48 63 da             	movslq %edx,%rbx
  801796:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801799:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80179e:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8017a1:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  8017a4:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8017a6:	48 85 c0             	test   %rax,%rax
  8017a9:	7f 06                	jg     8017b1 <sys_map_region+0x36>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  8017ab:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8017af:	c9                   	leave
  8017b0:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8017b1:	49 89 c0             	mov    %rax,%r8
  8017b4:	b9 05 00 00 00       	mov    $0x5,%ecx
  8017b9:	48 ba 58 44 80 00 00 	movabs $0x804458,%rdx
  8017c0:	00 00 00 
  8017c3:	be 26 00 00 00       	mov    $0x26,%esi
  8017c8:	48 bf 6c 42 80 00 00 	movabs $0x80426c,%rdi
  8017cf:	00 00 00 
  8017d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8017d7:	49 b9 66 06 80 00 00 	movabs $0x800666,%r9
  8017de:	00 00 00 
  8017e1:	41 ff d1             	call   *%r9

00000000008017e4 <sys_map_physical_region>:

int
sys_map_physical_region(uintptr_t pa, envid_t dstenv, void *dstva, size_t size, int perm) {
  8017e4:	f3 0f 1e fa          	endbr64
  8017e8:	55                   	push   %rbp
  8017e9:	48 89 e5             	mov    %rsp,%rbp
  8017ec:	53                   	push   %rbx
  8017ed:	48 83 ec 08          	sub    $0x8,%rsp
  8017f1:	49 89 f9             	mov    %rdi,%r9
  8017f4:	89 f0                	mov    %esi,%eax
  8017f6:	48 89 d3             	mov    %rdx,%rbx
  8017f9:	48 89 cf             	mov    %rcx,%rdi
    int res = syscall(SYS_map_physical_region, 1, pa, dstenv, (uintptr_t)dstva, size, perm, 0);
  8017fc:	49 63 f0             	movslq %r8d,%rsi
  8017ff:	48 63 c8             	movslq %eax,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801802:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801807:	4c 89 ca             	mov    %r9,%rdx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80180a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801810:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801812:	48 85 c0             	test   %rax,%rax
  801815:	7f 06                	jg     80181d <sys_map_physical_region+0x39>
#ifdef SANITIZE_USER_SHADOW_BASE
    platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  801817:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80181b:	c9                   	leave
  80181c:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80181d:	49 89 c0             	mov    %rax,%r8
  801820:	b9 06 00 00 00       	mov    $0x6,%ecx
  801825:	48 ba 58 44 80 00 00 	movabs $0x804458,%rdx
  80182c:	00 00 00 
  80182f:	be 26 00 00 00       	mov    $0x26,%esi
  801834:	48 bf 6c 42 80 00 00 	movabs $0x80426c,%rdi
  80183b:	00 00 00 
  80183e:	b8 00 00 00 00       	mov    $0x0,%eax
  801843:	49 b9 66 06 80 00 00 	movabs $0x800666,%r9
  80184a:	00 00 00 
  80184d:	41 ff d1             	call   *%r9

0000000000801850 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  801850:	f3 0f 1e fa          	endbr64
  801854:	55                   	push   %rbp
  801855:	48 89 e5             	mov    %rsp,%rbp
  801858:	53                   	push   %rbx
  801859:	48 83 ec 08          	sub    $0x8,%rsp
  80185d:	48 89 f1             	mov    %rsi,%rcx
  801860:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  801863:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801866:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80186b:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801870:	be 00 00 00 00       	mov    $0x0,%esi
  801875:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80187b:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80187d:	48 85 c0             	test   %rax,%rax
  801880:	7f 06                	jg     801888 <sys_unmap_region+0x38>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  801882:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801886:	c9                   	leave
  801887:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801888:	49 89 c0             	mov    %rax,%r8
  80188b:	b9 07 00 00 00       	mov    $0x7,%ecx
  801890:	48 ba 58 44 80 00 00 	movabs $0x804458,%rdx
  801897:	00 00 00 
  80189a:	be 26 00 00 00       	mov    $0x26,%esi
  80189f:	48 bf 6c 42 80 00 00 	movabs $0x80426c,%rdi
  8018a6:	00 00 00 
  8018a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8018ae:	49 b9 66 06 80 00 00 	movabs $0x800666,%r9
  8018b5:	00 00 00 
  8018b8:	41 ff d1             	call   *%r9

00000000008018bb <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  8018bb:	f3 0f 1e fa          	endbr64
  8018bf:	55                   	push   %rbp
  8018c0:	48 89 e5             	mov    %rsp,%rbp
  8018c3:	53                   	push   %rbx
  8018c4:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  8018c8:	48 63 ce             	movslq %esi,%rcx
  8018cb:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8018ce:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8018d3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018d8:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8018dd:	be 00 00 00 00       	mov    $0x0,%esi
  8018e2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8018e8:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8018ea:	48 85 c0             	test   %rax,%rax
  8018ed:	7f 06                	jg     8018f5 <sys_env_set_status+0x3a>
}
  8018ef:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8018f3:	c9                   	leave
  8018f4:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8018f5:	49 89 c0             	mov    %rax,%r8
  8018f8:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8018fd:	48 ba 58 44 80 00 00 	movabs $0x804458,%rdx
  801904:	00 00 00 
  801907:	be 26 00 00 00       	mov    $0x26,%esi
  80190c:	48 bf 6c 42 80 00 00 	movabs $0x80426c,%rdi
  801913:	00 00 00 
  801916:	b8 00 00 00 00       	mov    $0x0,%eax
  80191b:	49 b9 66 06 80 00 00 	movabs $0x800666,%r9
  801922:	00 00 00 
  801925:	41 ff d1             	call   *%r9

0000000000801928 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  801928:	f3 0f 1e fa          	endbr64
  80192c:	55                   	push   %rbp
  80192d:	48 89 e5             	mov    %rsp,%rbp
  801930:	53                   	push   %rbx
  801931:	48 83 ec 08          	sub    $0x8,%rsp
  801935:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  801938:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80193b:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801940:	bb 00 00 00 00       	mov    $0x0,%ebx
  801945:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80194a:	be 00 00 00 00       	mov    $0x0,%esi
  80194f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801955:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801957:	48 85 c0             	test   %rax,%rax
  80195a:	7f 06                	jg     801962 <sys_env_set_trapframe+0x3a>
}
  80195c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801960:	c9                   	leave
  801961:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801962:	49 89 c0             	mov    %rax,%r8
  801965:	b9 0b 00 00 00       	mov    $0xb,%ecx
  80196a:	48 ba 58 44 80 00 00 	movabs $0x804458,%rdx
  801971:	00 00 00 
  801974:	be 26 00 00 00       	mov    $0x26,%esi
  801979:	48 bf 6c 42 80 00 00 	movabs $0x80426c,%rdi
  801980:	00 00 00 
  801983:	b8 00 00 00 00       	mov    $0x0,%eax
  801988:	49 b9 66 06 80 00 00 	movabs $0x800666,%r9
  80198f:	00 00 00 
  801992:	41 ff d1             	call   *%r9

0000000000801995 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  801995:	f3 0f 1e fa          	endbr64
  801999:	55                   	push   %rbp
  80199a:	48 89 e5             	mov    %rsp,%rbp
  80199d:	53                   	push   %rbx
  80199e:	48 83 ec 08          	sub    $0x8,%rsp
  8019a2:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  8019a5:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8019a8:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8019ad:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019b2:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8019b7:	be 00 00 00 00       	mov    $0x0,%esi
  8019bc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8019c2:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8019c4:	48 85 c0             	test   %rax,%rax
  8019c7:	7f 06                	jg     8019cf <sys_env_set_pgfault_upcall+0x3a>
}
  8019c9:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8019cd:	c9                   	leave
  8019ce:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8019cf:	49 89 c0             	mov    %rax,%r8
  8019d2:	b9 0c 00 00 00       	mov    $0xc,%ecx
  8019d7:	48 ba 58 44 80 00 00 	movabs $0x804458,%rdx
  8019de:	00 00 00 
  8019e1:	be 26 00 00 00       	mov    $0x26,%esi
  8019e6:	48 bf 6c 42 80 00 00 	movabs $0x80426c,%rdi
  8019ed:	00 00 00 
  8019f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8019f5:	49 b9 66 06 80 00 00 	movabs $0x800666,%r9
  8019fc:	00 00 00 
  8019ff:	41 ff d1             	call   *%r9

0000000000801a02 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  801a02:	f3 0f 1e fa          	endbr64
  801a06:	55                   	push   %rbp
  801a07:	48 89 e5             	mov    %rsp,%rbp
  801a0a:	53                   	push   %rbx
  801a0b:	89 f8                	mov    %edi,%eax
  801a0d:	49 89 f1             	mov    %rsi,%r9
  801a10:	48 89 d3             	mov    %rdx,%rbx
  801a13:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  801a16:	49 63 f0             	movslq %r8d,%rsi
  801a19:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801a1c:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801a21:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801a24:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801a2a:	cd 30                	int    $0x30
}
  801a2c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801a30:	c9                   	leave
  801a31:	c3                   	ret

0000000000801a32 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  801a32:	f3 0f 1e fa          	endbr64
  801a36:	55                   	push   %rbp
  801a37:	48 89 e5             	mov    %rsp,%rbp
  801a3a:	53                   	push   %rbx
  801a3b:	48 83 ec 08          	sub    $0x8,%rsp
  801a3f:	48 89 fa             	mov    %rdi,%rdx
  801a42:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801a45:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801a4a:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a4f:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801a54:	be 00 00 00 00       	mov    $0x0,%esi
  801a59:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801a5f:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801a61:	48 85 c0             	test   %rax,%rax
  801a64:	7f 06                	jg     801a6c <sys_ipc_recv+0x3a>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  801a66:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801a6a:	c9                   	leave
  801a6b:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801a6c:	49 89 c0             	mov    %rax,%r8
  801a6f:	b9 0f 00 00 00       	mov    $0xf,%ecx
  801a74:	48 ba 58 44 80 00 00 	movabs $0x804458,%rdx
  801a7b:	00 00 00 
  801a7e:	be 26 00 00 00       	mov    $0x26,%esi
  801a83:	48 bf 6c 42 80 00 00 	movabs $0x80426c,%rdi
  801a8a:	00 00 00 
  801a8d:	b8 00 00 00 00       	mov    $0x0,%eax
  801a92:	49 b9 66 06 80 00 00 	movabs $0x800666,%r9
  801a99:	00 00 00 
  801a9c:	41 ff d1             	call   *%r9

0000000000801a9f <sys_gettime>:

int
sys_gettime(void) {
  801a9f:	f3 0f 1e fa          	endbr64
  801aa3:	55                   	push   %rbp
  801aa4:	48 89 e5             	mov    %rsp,%rbp
  801aa7:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801aa8:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801aad:	ba 00 00 00 00       	mov    $0x0,%edx
  801ab2:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801ab7:	bb 00 00 00 00       	mov    $0x0,%ebx
  801abc:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801ac1:	be 00 00 00 00       	mov    $0x0,%esi
  801ac6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801acc:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  801ace:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801ad2:	c9                   	leave
  801ad3:	c3                   	ret

0000000000801ad4 <fd2num>:


/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
  801ad4:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801ad8:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801adf:	ff ff ff 
  801ae2:	48 01 f8             	add    %rdi,%rax
  801ae5:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801ae9:	c3                   	ret

0000000000801aea <fd2data>:

char *
fd2data(struct Fd *fd) {
  801aea:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801aee:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801af5:	ff ff ff 
  801af8:	48 01 f8             	add    %rdi,%rax
  801afb:	48 c1 e8 0c          	shr    $0xc,%rax
    return INDEX2DATA(fd2num(fd));
  801aff:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801b05:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801b09:	c3                   	ret

0000000000801b0a <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  801b0a:	f3 0f 1e fa          	endbr64
  801b0e:	55                   	push   %rbp
  801b0f:	48 89 e5             	mov    %rsp,%rbp
  801b12:	41 57                	push   %r15
  801b14:	41 56                	push   %r14
  801b16:	41 55                	push   %r13
  801b18:	41 54                	push   %r12
  801b1a:	53                   	push   %rbx
  801b1b:	48 83 ec 08          	sub    $0x8,%rsp
  801b1f:	49 89 ff             	mov    %rdi,%r15
  801b22:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  801b27:	49 bd b8 35 80 00 00 	movabs $0x8035b8,%r13
  801b2e:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  801b31:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        struct Fd *fd = INDEX2FD(i);
  801b37:	49 89 dc             	mov    %rbx,%r12
        if (!(get_prot(fd) & PROT_R)) {
  801b3a:	48 89 df             	mov    %rbx,%rdi
  801b3d:	41 ff d5             	call   *%r13
  801b40:	83 e0 04             	and    $0x4,%eax
  801b43:	74 17                	je     801b5c <fd_alloc+0x52>
    for (int i = 0; i < MAXFD; i++) {
  801b45:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  801b4c:	4c 39 f3             	cmp    %r14,%rbx
  801b4f:	75 e6                	jne    801b37 <fd_alloc+0x2d>
  801b51:	41 bc 00 00 00 00    	mov    $0x0,%r12d
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
    return -E_MAX_OPEN;
  801b57:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
            *fd_store = fd;
  801b5c:	4d 89 27             	mov    %r12,(%r15)
}
  801b5f:	48 83 c4 08          	add    $0x8,%rsp
  801b63:	5b                   	pop    %rbx
  801b64:	41 5c                	pop    %r12
  801b66:	41 5d                	pop    %r13
  801b68:	41 5e                	pop    %r14
  801b6a:	41 5f                	pop    %r15
  801b6c:	5d                   	pop    %rbp
  801b6d:	c3                   	ret

0000000000801b6e <fd_lookup>:
 *
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
  801b6e:	f3 0f 1e fa          	endbr64
    if (fdnum < 0 || fdnum >= MAXFD) {
  801b72:	83 ff 1f             	cmp    $0x1f,%edi
  801b75:	77 39                	ja     801bb0 <fd_lookup+0x42>
fd_lookup(int fdnum, struct Fd **fd_store) {
  801b77:	55                   	push   %rbp
  801b78:	48 89 e5             	mov    %rsp,%rbp
  801b7b:	41 54                	push   %r12
  801b7d:	53                   	push   %rbx
  801b7e:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  801b81:	48 63 df             	movslq %edi,%rbx
  801b84:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  801b8b:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  801b8f:	48 89 df             	mov    %rbx,%rdi
  801b92:	48 b8 b8 35 80 00 00 	movabs $0x8035b8,%rax
  801b99:	00 00 00 
  801b9c:	ff d0                	call   *%rax
  801b9e:	a8 04                	test   $0x4,%al
  801ba0:	74 14                	je     801bb6 <fd_lookup+0x48>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  801ba2:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  801ba6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bab:	5b                   	pop    %rbx
  801bac:	41 5c                	pop    %r12
  801bae:	5d                   	pop    %rbp
  801baf:	c3                   	ret
        return -E_INVAL;
  801bb0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801bb5:	c3                   	ret
        return -E_INVAL;
  801bb6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801bbb:	eb ee                	jmp    801bab <fd_lookup+0x3d>

0000000000801bbd <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  801bbd:	f3 0f 1e fa          	endbr64
  801bc1:	55                   	push   %rbp
  801bc2:	48 89 e5             	mov    %rsp,%rbp
  801bc5:	41 54                	push   %r12
  801bc7:	53                   	push   %rbx
  801bc8:	49 89 f4             	mov    %rsi,%r12
    for (size_t i = 0; devtab[i]; i++) {
  801bcb:	48 b8 c0 48 80 00 00 	movabs $0x8048c0,%rax
  801bd2:	00 00 00 
  801bd5:	48 bb c0 67 80 00 00 	movabs $0x8067c0,%rbx
  801bdc:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  801bdf:	39 3b                	cmp    %edi,(%rbx)
  801be1:	74 47                	je     801c2a <dev_lookup+0x6d>
    for (size_t i = 0; devtab[i]; i++) {
  801be3:	48 83 c0 08          	add    $0x8,%rax
  801be7:	48 8b 18             	mov    (%rax),%rbx
  801bea:	48 85 db             	test   %rbx,%rbx
  801bed:	75 f0                	jne    801bdf <dev_lookup+0x22>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801bef:	48 a1 70 87 80 00 00 	movabs 0x808770,%rax
  801bf6:	00 00 00 
  801bf9:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801bff:	89 fa                	mov    %edi,%edx
  801c01:	48 bf 78 44 80 00 00 	movabs $0x804478,%rdi
  801c08:	00 00 00 
  801c0b:	b8 00 00 00 00       	mov    $0x0,%eax
  801c10:	48 b9 c2 07 80 00 00 	movabs $0x8007c2,%rcx
  801c17:	00 00 00 
  801c1a:	ff d1                	call   *%rcx
    *dev = 0;
    return -E_INVAL;
  801c1c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
            *dev = devtab[i];
  801c21:	49 89 1c 24          	mov    %rbx,(%r12)
}
  801c25:	5b                   	pop    %rbx
  801c26:	41 5c                	pop    %r12
  801c28:	5d                   	pop    %rbp
  801c29:	c3                   	ret
            return 0;
  801c2a:	b8 00 00 00 00       	mov    $0x0,%eax
  801c2f:	eb f0                	jmp    801c21 <dev_lookup+0x64>

0000000000801c31 <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  801c31:	f3 0f 1e fa          	endbr64
  801c35:	55                   	push   %rbp
  801c36:	48 89 e5             	mov    %rsp,%rbp
  801c39:	41 55                	push   %r13
  801c3b:	41 54                	push   %r12
  801c3d:	53                   	push   %rbx
  801c3e:	48 83 ec 18          	sub    $0x18,%rsp
  801c42:	48 89 fb             	mov    %rdi,%rbx
  801c45:	41 89 f4             	mov    %esi,%r12d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801c48:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  801c4f:	ff ff ff 
  801c52:	48 01 df             	add    %rbx,%rdi
  801c55:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  801c59:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801c5d:	48 b8 6e 1b 80 00 00 	movabs $0x801b6e,%rax
  801c64:	00 00 00 
  801c67:	ff d0                	call   *%rax
  801c69:	41 89 c5             	mov    %eax,%r13d
  801c6c:	85 c0                	test   %eax,%eax
  801c6e:	78 06                	js     801c76 <fd_close+0x45>
  801c70:	48 39 5d d8          	cmp    %rbx,-0x28(%rbp)
  801c74:	74 1a                	je     801c90 <fd_close+0x5f>
        return (must_exist ? res : 0);
  801c76:	45 84 e4             	test   %r12b,%r12b
  801c79:	b8 00 00 00 00       	mov    $0x0,%eax
  801c7e:	44 0f 44 e8          	cmove  %eax,%r13d
}
  801c82:	44 89 e8             	mov    %r13d,%eax
  801c85:	48 83 c4 18          	add    $0x18,%rsp
  801c89:	5b                   	pop    %rbx
  801c8a:	41 5c                	pop    %r12
  801c8c:	41 5d                	pop    %r13
  801c8e:	5d                   	pop    %rbp
  801c8f:	c3                   	ret
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801c90:	8b 3b                	mov    (%rbx),%edi
  801c92:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801c96:	48 b8 bd 1b 80 00 00 	movabs $0x801bbd,%rax
  801c9d:	00 00 00 
  801ca0:	ff d0                	call   *%rax
  801ca2:	41 89 c5             	mov    %eax,%r13d
  801ca5:	85 c0                	test   %eax,%eax
  801ca7:	78 1b                	js     801cc4 <fd_close+0x93>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  801ca9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801cad:	48 8b 40 20          	mov    0x20(%rax),%rax
  801cb1:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  801cb7:	48 85 c0             	test   %rax,%rax
  801cba:	74 08                	je     801cc4 <fd_close+0x93>
  801cbc:	48 89 df             	mov    %rbx,%rdi
  801cbf:	ff d0                	call   *%rax
  801cc1:	41 89 c5             	mov    %eax,%r13d
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801cc4:	ba 00 10 00 00       	mov    $0x1000,%edx
  801cc9:	48 89 de             	mov    %rbx,%rsi
  801ccc:	bf 00 00 00 00       	mov    $0x0,%edi
  801cd1:	48 b8 50 18 80 00 00 	movabs $0x801850,%rax
  801cd8:	00 00 00 
  801cdb:	ff d0                	call   *%rax
    return res;
  801cdd:	eb a3                	jmp    801c82 <fd_close+0x51>

0000000000801cdf <close>:

int
close(int fdnum) {
  801cdf:	f3 0f 1e fa          	endbr64
  801ce3:	55                   	push   %rbp
  801ce4:	48 89 e5             	mov    %rsp,%rbp
  801ce7:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  801ceb:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801cef:	48 b8 6e 1b 80 00 00 	movabs $0x801b6e,%rax
  801cf6:	00 00 00 
  801cf9:	ff d0                	call   *%rax
    if (res < 0) return res;
  801cfb:	85 c0                	test   %eax,%eax
  801cfd:	78 15                	js     801d14 <close+0x35>

    return fd_close(fd, 1);
  801cff:	be 01 00 00 00       	mov    $0x1,%esi
  801d04:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801d08:	48 b8 31 1c 80 00 00 	movabs $0x801c31,%rax
  801d0f:	00 00 00 
  801d12:	ff d0                	call   *%rax
}
  801d14:	c9                   	leave
  801d15:	c3                   	ret

0000000000801d16 <close_all>:

void
close_all(void) {
  801d16:	f3 0f 1e fa          	endbr64
  801d1a:	55                   	push   %rbp
  801d1b:	48 89 e5             	mov    %rsp,%rbp
  801d1e:	41 54                	push   %r12
  801d20:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  801d21:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d26:	49 bc df 1c 80 00 00 	movabs $0x801cdf,%r12
  801d2d:	00 00 00 
  801d30:	89 df                	mov    %ebx,%edi
  801d32:	41 ff d4             	call   *%r12
  801d35:	83 c3 01             	add    $0x1,%ebx
  801d38:	83 fb 20             	cmp    $0x20,%ebx
  801d3b:	75 f3                	jne    801d30 <close_all+0x1a>
}
  801d3d:	5b                   	pop    %rbx
  801d3e:	41 5c                	pop    %r12
  801d40:	5d                   	pop    %rbp
  801d41:	c3                   	ret

0000000000801d42 <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  801d42:	f3 0f 1e fa          	endbr64
  801d46:	55                   	push   %rbp
  801d47:	48 89 e5             	mov    %rsp,%rbp
  801d4a:	41 57                	push   %r15
  801d4c:	41 56                	push   %r14
  801d4e:	41 55                	push   %r13
  801d50:	41 54                	push   %r12
  801d52:	53                   	push   %rbx
  801d53:	48 83 ec 18          	sub    $0x18,%rsp
  801d57:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  801d5a:	48 8d 75 c8          	lea    -0x38(%rbp),%rsi
  801d5e:	48 b8 6e 1b 80 00 00 	movabs $0x801b6e,%rax
  801d65:	00 00 00 
  801d68:	ff d0                	call   *%rax
  801d6a:	89 c3                	mov    %eax,%ebx
  801d6c:	85 c0                	test   %eax,%eax
  801d6e:	0f 88 b8 00 00 00    	js     801e2c <dup+0xea>
    close(newfdnum);
  801d74:	44 89 e7             	mov    %r12d,%edi
  801d77:	48 b8 df 1c 80 00 00 	movabs $0x801cdf,%rax
  801d7e:	00 00 00 
  801d81:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  801d83:	4d 63 ec             	movslq %r12d,%r13
  801d86:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  801d8d:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  801d91:	4c 8b 7d c8          	mov    -0x38(%rbp),%r15
  801d95:	4c 89 ff             	mov    %r15,%rdi
  801d98:	49 be ea 1a 80 00 00 	movabs $0x801aea,%r14
  801d9f:	00 00 00 
  801da2:	41 ff d6             	call   *%r14
  801da5:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  801da8:	4c 89 ef             	mov    %r13,%rdi
  801dab:	41 ff d6             	call   *%r14
  801dae:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  801db1:	48 89 df             	mov    %rbx,%rdi
  801db4:	48 b8 b8 35 80 00 00 	movabs $0x8035b8,%rax
  801dbb:	00 00 00 
  801dbe:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  801dc0:	a8 04                	test   $0x4,%al
  801dc2:	74 2b                	je     801def <dup+0xad>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  801dc4:	41 89 c1             	mov    %eax,%r9d
  801dc7:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801dcd:	4c 89 f1             	mov    %r14,%rcx
  801dd0:	ba 00 00 00 00       	mov    $0x0,%edx
  801dd5:	48 89 de             	mov    %rbx,%rsi
  801dd8:	bf 00 00 00 00       	mov    $0x0,%edi
  801ddd:	48 b8 7b 17 80 00 00 	movabs $0x80177b,%rax
  801de4:	00 00 00 
  801de7:	ff d0                	call   *%rax
  801de9:	89 c3                	mov    %eax,%ebx
  801deb:	85 c0                	test   %eax,%eax
  801ded:	78 4e                	js     801e3d <dup+0xfb>
    }
    prot = get_prot(oldfd);
  801def:	4c 89 ff             	mov    %r15,%rdi
  801df2:	48 b8 b8 35 80 00 00 	movabs $0x8035b8,%rax
  801df9:	00 00 00 
  801dfc:	ff d0                	call   *%rax
  801dfe:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  801e01:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801e07:	4c 89 e9             	mov    %r13,%rcx
  801e0a:	ba 00 00 00 00       	mov    $0x0,%edx
  801e0f:	4c 89 fe             	mov    %r15,%rsi
  801e12:	bf 00 00 00 00       	mov    $0x0,%edi
  801e17:	48 b8 7b 17 80 00 00 	movabs $0x80177b,%rax
  801e1e:	00 00 00 
  801e21:	ff d0                	call   *%rax
  801e23:	89 c3                	mov    %eax,%ebx
  801e25:	85 c0                	test   %eax,%eax
  801e27:	78 14                	js     801e3d <dup+0xfb>

    return newfdnum;
  801e29:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  801e2c:	89 d8                	mov    %ebx,%eax
  801e2e:	48 83 c4 18          	add    $0x18,%rsp
  801e32:	5b                   	pop    %rbx
  801e33:	41 5c                	pop    %r12
  801e35:	41 5d                	pop    %r13
  801e37:	41 5e                	pop    %r14
  801e39:	41 5f                	pop    %r15
  801e3b:	5d                   	pop    %rbp
  801e3c:	c3                   	ret
    sys_unmap_region(0, newfd, PAGE_SIZE);
  801e3d:	ba 00 10 00 00       	mov    $0x1000,%edx
  801e42:	4c 89 ee             	mov    %r13,%rsi
  801e45:	bf 00 00 00 00       	mov    $0x0,%edi
  801e4a:	49 bc 50 18 80 00 00 	movabs $0x801850,%r12
  801e51:	00 00 00 
  801e54:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  801e57:	ba 00 10 00 00       	mov    $0x1000,%edx
  801e5c:	4c 89 f6             	mov    %r14,%rsi
  801e5f:	bf 00 00 00 00       	mov    $0x0,%edi
  801e64:	41 ff d4             	call   *%r12
    return res;
  801e67:	eb c3                	jmp    801e2c <dup+0xea>

0000000000801e69 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  801e69:	f3 0f 1e fa          	endbr64
  801e6d:	55                   	push   %rbp
  801e6e:	48 89 e5             	mov    %rsp,%rbp
  801e71:	41 56                	push   %r14
  801e73:	41 55                	push   %r13
  801e75:	41 54                	push   %r12
  801e77:	53                   	push   %rbx
  801e78:	48 83 ec 10          	sub    $0x10,%rsp
  801e7c:	89 fb                	mov    %edi,%ebx
  801e7e:	49 89 f4             	mov    %rsi,%r12
  801e81:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801e84:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801e88:	48 b8 6e 1b 80 00 00 	movabs $0x801b6e,%rax
  801e8f:	00 00 00 
  801e92:	ff d0                	call   *%rax
  801e94:	85 c0                	test   %eax,%eax
  801e96:	78 4c                	js     801ee4 <read+0x7b>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801e98:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801e9c:	41 8b 3e             	mov    (%r14),%edi
  801e9f:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801ea3:	48 b8 bd 1b 80 00 00 	movabs $0x801bbd,%rax
  801eaa:	00 00 00 
  801ead:	ff d0                	call   *%rax
  801eaf:	85 c0                	test   %eax,%eax
  801eb1:	78 35                	js     801ee8 <read+0x7f>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801eb3:	41 8b 46 08          	mov    0x8(%r14),%eax
  801eb7:	83 e0 03             	and    $0x3,%eax
  801eba:	83 f8 01             	cmp    $0x1,%eax
  801ebd:	74 2d                	je     801eec <read+0x83>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  801ebf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801ec3:	48 8b 40 10          	mov    0x10(%rax),%rax
  801ec7:	48 85 c0             	test   %rax,%rax
  801eca:	74 56                	je     801f22 <read+0xb9>

    return (*dev->dev_read)(fd, buf, n);
  801ecc:	4c 89 ea             	mov    %r13,%rdx
  801ecf:	4c 89 e6             	mov    %r12,%rsi
  801ed2:	4c 89 f7             	mov    %r14,%rdi
  801ed5:	ff d0                	call   *%rax
}
  801ed7:	48 83 c4 10          	add    $0x10,%rsp
  801edb:	5b                   	pop    %rbx
  801edc:	41 5c                	pop    %r12
  801ede:	41 5d                	pop    %r13
  801ee0:	41 5e                	pop    %r14
  801ee2:	5d                   	pop    %rbp
  801ee3:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801ee4:	48 98                	cltq
  801ee6:	eb ef                	jmp    801ed7 <read+0x6e>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801ee8:	48 98                	cltq
  801eea:	eb eb                	jmp    801ed7 <read+0x6e>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801eec:	48 a1 70 87 80 00 00 	movabs 0x808770,%rax
  801ef3:	00 00 00 
  801ef6:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801efc:	89 da                	mov    %ebx,%edx
  801efe:	48 bf 7a 42 80 00 00 	movabs $0x80427a,%rdi
  801f05:	00 00 00 
  801f08:	b8 00 00 00 00       	mov    $0x0,%eax
  801f0d:	48 b9 c2 07 80 00 00 	movabs $0x8007c2,%rcx
  801f14:	00 00 00 
  801f17:	ff d1                	call   *%rcx
        return -E_INVAL;
  801f19:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801f20:	eb b5                	jmp    801ed7 <read+0x6e>
    if (!dev->dev_read) return -E_NOT_SUPP;
  801f22:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801f29:	eb ac                	jmp    801ed7 <read+0x6e>

0000000000801f2b <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801f2b:	f3 0f 1e fa          	endbr64
  801f2f:	55                   	push   %rbp
  801f30:	48 89 e5             	mov    %rsp,%rbp
  801f33:	41 57                	push   %r15
  801f35:	41 56                	push   %r14
  801f37:	41 55                	push   %r13
  801f39:	41 54                	push   %r12
  801f3b:	53                   	push   %rbx
  801f3c:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801f40:	48 85 d2             	test   %rdx,%rdx
  801f43:	74 54                	je     801f99 <readn+0x6e>
  801f45:	41 89 fd             	mov    %edi,%r13d
  801f48:	49 89 f6             	mov    %rsi,%r14
  801f4b:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801f4e:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801f53:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801f58:	49 bf 69 1e 80 00 00 	movabs $0x801e69,%r15
  801f5f:	00 00 00 
  801f62:	4c 89 e2             	mov    %r12,%rdx
  801f65:	48 29 f2             	sub    %rsi,%rdx
  801f68:	4c 01 f6             	add    %r14,%rsi
  801f6b:	44 89 ef             	mov    %r13d,%edi
  801f6e:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  801f71:	85 c0                	test   %eax,%eax
  801f73:	78 20                	js     801f95 <readn+0x6a>
    for (; inc && res < n; res += inc) {
  801f75:	01 c3                	add    %eax,%ebx
  801f77:	85 c0                	test   %eax,%eax
  801f79:	74 08                	je     801f83 <readn+0x58>
  801f7b:	48 63 f3             	movslq %ebx,%rsi
  801f7e:	4c 39 e6             	cmp    %r12,%rsi
  801f81:	72 df                	jb     801f62 <readn+0x37>
    }
    return res;
  801f83:	48 63 c3             	movslq %ebx,%rax
}
  801f86:	48 83 c4 08          	add    $0x8,%rsp
  801f8a:	5b                   	pop    %rbx
  801f8b:	41 5c                	pop    %r12
  801f8d:	41 5d                	pop    %r13
  801f8f:	41 5e                	pop    %r14
  801f91:	41 5f                	pop    %r15
  801f93:	5d                   	pop    %rbp
  801f94:	c3                   	ret
        if (inc < 0) return inc;
  801f95:	48 98                	cltq
  801f97:	eb ed                	jmp    801f86 <readn+0x5b>
    int inc = 1, res = 0;
  801f99:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f9e:	eb e3                	jmp    801f83 <readn+0x58>

0000000000801fa0 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  801fa0:	f3 0f 1e fa          	endbr64
  801fa4:	55                   	push   %rbp
  801fa5:	48 89 e5             	mov    %rsp,%rbp
  801fa8:	41 56                	push   %r14
  801faa:	41 55                	push   %r13
  801fac:	41 54                	push   %r12
  801fae:	53                   	push   %rbx
  801faf:	48 83 ec 10          	sub    $0x10,%rsp
  801fb3:	89 fb                	mov    %edi,%ebx
  801fb5:	49 89 f4             	mov    %rsi,%r12
  801fb8:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801fbb:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801fbf:	48 b8 6e 1b 80 00 00 	movabs $0x801b6e,%rax
  801fc6:	00 00 00 
  801fc9:	ff d0                	call   *%rax
  801fcb:	85 c0                	test   %eax,%eax
  801fcd:	78 47                	js     802016 <write+0x76>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801fcf:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801fd3:	41 8b 3e             	mov    (%r14),%edi
  801fd6:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801fda:	48 b8 bd 1b 80 00 00 	movabs $0x801bbd,%rax
  801fe1:	00 00 00 
  801fe4:	ff d0                	call   *%rax
  801fe6:	85 c0                	test   %eax,%eax
  801fe8:	78 30                	js     80201a <write+0x7a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801fea:	41 f6 46 08 03       	testb  $0x3,0x8(%r14)
  801fef:	74 2d                	je     80201e <write+0x7e>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801ff1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801ff5:	48 8b 40 18          	mov    0x18(%rax),%rax
  801ff9:	48 85 c0             	test   %rax,%rax
  801ffc:	74 56                	je     802054 <write+0xb4>

    return (*dev->dev_write)(fd, buf, n);
  801ffe:	4c 89 ea             	mov    %r13,%rdx
  802001:	4c 89 e6             	mov    %r12,%rsi
  802004:	4c 89 f7             	mov    %r14,%rdi
  802007:	ff d0                	call   *%rax
}
  802009:	48 83 c4 10          	add    $0x10,%rsp
  80200d:	5b                   	pop    %rbx
  80200e:	41 5c                	pop    %r12
  802010:	41 5d                	pop    %r13
  802012:	41 5e                	pop    %r14
  802014:	5d                   	pop    %rbp
  802015:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  802016:	48 98                	cltq
  802018:	eb ef                	jmp    802009 <write+0x69>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  80201a:	48 98                	cltq
  80201c:	eb eb                	jmp    802009 <write+0x69>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80201e:	48 a1 70 87 80 00 00 	movabs 0x808770,%rax
  802025:	00 00 00 
  802028:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  80202e:	89 da                	mov    %ebx,%edx
  802030:	48 bf 96 42 80 00 00 	movabs $0x804296,%rdi
  802037:	00 00 00 
  80203a:	b8 00 00 00 00       	mov    $0x0,%eax
  80203f:	48 b9 c2 07 80 00 00 	movabs $0x8007c2,%rcx
  802046:	00 00 00 
  802049:	ff d1                	call   *%rcx
        return -E_INVAL;
  80204b:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  802052:	eb b5                	jmp    802009 <write+0x69>
    if (!dev->dev_write) return -E_NOT_SUPP;
  802054:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  80205b:	eb ac                	jmp    802009 <write+0x69>

000000000080205d <seek>:

int
seek(int fdnum, off_t offset) {
  80205d:	f3 0f 1e fa          	endbr64
  802061:	55                   	push   %rbp
  802062:	48 89 e5             	mov    %rsp,%rbp
  802065:	53                   	push   %rbx
  802066:	48 83 ec 18          	sub    $0x18,%rsp
  80206a:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  80206c:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  802070:	48 b8 6e 1b 80 00 00 	movabs $0x801b6e,%rax
  802077:	00 00 00 
  80207a:	ff d0                	call   *%rax
  80207c:	85 c0                	test   %eax,%eax
  80207e:	78 0c                	js     80208c <seek+0x2f>

    fd->fd_offset = offset;
  802080:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802084:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  802087:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80208c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  802090:	c9                   	leave
  802091:	c3                   	ret

0000000000802092 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  802092:	f3 0f 1e fa          	endbr64
  802096:	55                   	push   %rbp
  802097:	48 89 e5             	mov    %rsp,%rbp
  80209a:	41 55                	push   %r13
  80209c:	41 54                	push   %r12
  80209e:	53                   	push   %rbx
  80209f:	48 83 ec 18          	sub    $0x18,%rsp
  8020a3:	89 fb                	mov    %edi,%ebx
  8020a5:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8020a8:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8020ac:	48 b8 6e 1b 80 00 00 	movabs $0x801b6e,%rax
  8020b3:	00 00 00 
  8020b6:	ff d0                	call   *%rax
  8020b8:	85 c0                	test   %eax,%eax
  8020ba:	78 38                	js     8020f4 <ftruncate+0x62>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8020bc:	4c 8b 6d d8          	mov    -0x28(%rbp),%r13
  8020c0:	41 8b 7d 00          	mov    0x0(%r13),%edi
  8020c4:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8020c8:	48 b8 bd 1b 80 00 00 	movabs $0x801bbd,%rax
  8020cf:	00 00 00 
  8020d2:	ff d0                	call   *%rax
  8020d4:	85 c0                	test   %eax,%eax
  8020d6:	78 1c                	js     8020f4 <ftruncate+0x62>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8020d8:	41 f6 45 08 03       	testb  $0x3,0x8(%r13)
  8020dd:	74 20                	je     8020ff <ftruncate+0x6d>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  8020df:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8020e3:	48 8b 40 30          	mov    0x30(%rax),%rax
  8020e7:	48 85 c0             	test   %rax,%rax
  8020ea:	74 47                	je     802133 <ftruncate+0xa1>

    return (*dev->dev_trunc)(fd, newsize);
  8020ec:	44 89 e6             	mov    %r12d,%esi
  8020ef:	4c 89 ef             	mov    %r13,%rdi
  8020f2:	ff d0                	call   *%rax
}
  8020f4:	48 83 c4 18          	add    $0x18,%rsp
  8020f8:	5b                   	pop    %rbx
  8020f9:	41 5c                	pop    %r12
  8020fb:	41 5d                	pop    %r13
  8020fd:	5d                   	pop    %rbp
  8020fe:	c3                   	ret
                thisenv->env_id, fdnum);
  8020ff:	48 a1 70 87 80 00 00 	movabs 0x808770,%rax
  802106:	00 00 00 
  802109:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  80210f:	89 da                	mov    %ebx,%edx
  802111:	48 bf 98 44 80 00 00 	movabs $0x804498,%rdi
  802118:	00 00 00 
  80211b:	b8 00 00 00 00       	mov    $0x0,%eax
  802120:	48 b9 c2 07 80 00 00 	movabs $0x8007c2,%rcx
  802127:	00 00 00 
  80212a:	ff d1                	call   *%rcx
        return -E_INVAL;
  80212c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802131:	eb c1                	jmp    8020f4 <ftruncate+0x62>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  802133:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  802138:	eb ba                	jmp    8020f4 <ftruncate+0x62>

000000000080213a <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  80213a:	f3 0f 1e fa          	endbr64
  80213e:	55                   	push   %rbp
  80213f:	48 89 e5             	mov    %rsp,%rbp
  802142:	41 54                	push   %r12
  802144:	53                   	push   %rbx
  802145:	48 83 ec 10          	sub    $0x10,%rsp
  802149:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  80214c:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  802150:	48 b8 6e 1b 80 00 00 	movabs $0x801b6e,%rax
  802157:	00 00 00 
  80215a:	ff d0                	call   *%rax
  80215c:	85 c0                	test   %eax,%eax
  80215e:	78 4e                	js     8021ae <fstat+0x74>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  802160:	4c 8b 65 e8          	mov    -0x18(%rbp),%r12
  802164:	41 8b 3c 24          	mov    (%r12),%edi
  802168:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  80216c:	48 b8 bd 1b 80 00 00 	movabs $0x801bbd,%rax
  802173:	00 00 00 
  802176:	ff d0                	call   *%rax
  802178:	85 c0                	test   %eax,%eax
  80217a:	78 32                	js     8021ae <fstat+0x74>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  80217c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802180:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  802185:	74 30                	je     8021b7 <fstat+0x7d>

    stat->st_name[0] = 0;
  802187:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  80218a:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  802191:	00 00 00 
    stat->st_isdir = 0;
  802194:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  80219b:	00 00 00 
    stat->st_dev = dev;
  80219e:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  8021a5:	48 89 de             	mov    %rbx,%rsi
  8021a8:	4c 89 e7             	mov    %r12,%rdi
  8021ab:	ff 50 28             	call   *0x28(%rax)
}
  8021ae:	48 83 c4 10          	add    $0x10,%rsp
  8021b2:	5b                   	pop    %rbx
  8021b3:	41 5c                	pop    %r12
  8021b5:	5d                   	pop    %rbp
  8021b6:	c3                   	ret
    if (!dev->dev_stat) return -E_NOT_SUPP;
  8021b7:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  8021bc:	eb f0                	jmp    8021ae <fstat+0x74>

00000000008021be <stat>:

int
stat(const char *path, struct Stat *stat) {
  8021be:	f3 0f 1e fa          	endbr64
  8021c2:	55                   	push   %rbp
  8021c3:	48 89 e5             	mov    %rsp,%rbp
  8021c6:	41 54                	push   %r12
  8021c8:	53                   	push   %rbx
  8021c9:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  8021cc:	be 00 00 00 00       	mov    $0x0,%esi
  8021d1:	48 b8 9f 24 80 00 00 	movabs $0x80249f,%rax
  8021d8:	00 00 00 
  8021db:	ff d0                	call   *%rax
  8021dd:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  8021df:	85 c0                	test   %eax,%eax
  8021e1:	78 25                	js     802208 <stat+0x4a>

    int res = fstat(fd, stat);
  8021e3:	4c 89 e6             	mov    %r12,%rsi
  8021e6:	89 c7                	mov    %eax,%edi
  8021e8:	48 b8 3a 21 80 00 00 	movabs $0x80213a,%rax
  8021ef:	00 00 00 
  8021f2:	ff d0                	call   *%rax
  8021f4:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  8021f7:	89 df                	mov    %ebx,%edi
  8021f9:	48 b8 df 1c 80 00 00 	movabs $0x801cdf,%rax
  802200:	00 00 00 
  802203:	ff d0                	call   *%rax

    return res;
  802205:	44 89 e3             	mov    %r12d,%ebx
}
  802208:	89 d8                	mov    %ebx,%eax
  80220a:	5b                   	pop    %rbx
  80220b:	41 5c                	pop    %r12
  80220d:	5d                   	pop    %rbp
  80220e:	c3                   	ret

000000000080220f <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  80220f:	f3 0f 1e fa          	endbr64
  802213:	55                   	push   %rbp
  802214:	48 89 e5             	mov    %rsp,%rbp
  802217:	41 54                	push   %r12
  802219:	53                   	push   %rbx
  80221a:	48 83 ec 10          	sub    $0x10,%rsp
  80221e:	41 89 fc             	mov    %edi,%r12d
  802221:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  802224:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80222b:	00 00 00 
  80222e:	83 38 00             	cmpl   $0x0,(%rax)
  802231:	74 6e                	je     8022a1 <fsipc+0x92>

    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }
    fsenv = ipc_find_env(ENV_TYPE_FS);
  802233:	bf 03 00 00 00       	mov    $0x3,%edi
  802238:	48 b8 9a 38 80 00 00 	movabs $0x80389a,%rax
  80223f:	00 00 00 
  802242:	ff d0                	call   *%rax
  802244:	a3 00 a0 80 00 00 00 	movabs %eax,0x80a000
  80224b:	00 00 
    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  80224d:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  802253:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802258:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  80225f:	00 00 00 
  802262:	44 89 e6             	mov    %r12d,%esi
  802265:	89 c7                	mov    %eax,%edi
  802267:	48 b8 d8 37 80 00 00 	movabs $0x8037d8,%rax
  80226e:	00 00 00 
  802271:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  802273:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  80227a:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  80227b:	b9 00 00 00 00       	mov    $0x0,%ecx
  802280:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802284:	48 89 de             	mov    %rbx,%rsi
  802287:	bf 00 00 00 00       	mov    $0x0,%edi
  80228c:	48 b8 3f 37 80 00 00 	movabs $0x80373f,%rax
  802293:	00 00 00 
  802296:	ff d0                	call   *%rax
}
  802298:	48 83 c4 10          	add    $0x10,%rsp
  80229c:	5b                   	pop    %rbx
  80229d:	41 5c                	pop    %r12
  80229f:	5d                   	pop    %rbp
  8022a0:	c3                   	ret
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  8022a1:	bf 03 00 00 00       	mov    $0x3,%edi
  8022a6:	48 b8 9a 38 80 00 00 	movabs $0x80389a,%rax
  8022ad:	00 00 00 
  8022b0:	ff d0                	call   *%rax
  8022b2:	a3 00 a0 80 00 00 00 	movabs %eax,0x80a000
  8022b9:	00 00 
  8022bb:	e9 73 ff ff ff       	jmp    802233 <fsipc+0x24>

00000000008022c0 <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  8022c0:	f3 0f 1e fa          	endbr64
  8022c4:	55                   	push   %rbp
  8022c5:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8022c8:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8022cf:	00 00 00 
  8022d2:	8b 57 0c             	mov    0xc(%rdi),%edx
  8022d5:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  8022d7:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  8022da:	be 00 00 00 00       	mov    $0x0,%esi
  8022df:	bf 02 00 00 00       	mov    $0x2,%edi
  8022e4:	48 b8 0f 22 80 00 00 	movabs $0x80220f,%rax
  8022eb:	00 00 00 
  8022ee:	ff d0                	call   *%rax
}
  8022f0:	5d                   	pop    %rbp
  8022f1:	c3                   	ret

00000000008022f2 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  8022f2:	f3 0f 1e fa          	endbr64
  8022f6:	55                   	push   %rbp
  8022f7:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8022fa:	8b 47 0c             	mov    0xc(%rdi),%eax
  8022fd:	a3 00 90 80 00 00 00 	movabs %eax,0x809000
  802304:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  802306:	be 00 00 00 00       	mov    $0x0,%esi
  80230b:	bf 06 00 00 00       	mov    $0x6,%edi
  802310:	48 b8 0f 22 80 00 00 	movabs $0x80220f,%rax
  802317:	00 00 00 
  80231a:	ff d0                	call   *%rax
}
  80231c:	5d                   	pop    %rbp
  80231d:	c3                   	ret

000000000080231e <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  80231e:	f3 0f 1e fa          	endbr64
  802322:	55                   	push   %rbp
  802323:	48 89 e5             	mov    %rsp,%rbp
  802326:	41 54                	push   %r12
  802328:	53                   	push   %rbx
  802329:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80232c:	8b 47 0c             	mov    0xc(%rdi),%eax
  80232f:	a3 00 90 80 00 00 00 	movabs %eax,0x809000
  802336:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  802338:	be 00 00 00 00       	mov    $0x0,%esi
  80233d:	bf 05 00 00 00       	mov    $0x5,%edi
  802342:	48 b8 0f 22 80 00 00 	movabs $0x80220f,%rax
  802349:	00 00 00 
  80234c:	ff d0                	call   *%rax
    if (res < 0) return res;
  80234e:	85 c0                	test   %eax,%eax
  802350:	78 3d                	js     80238f <devfile_stat+0x71>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802352:	49 bc 00 90 80 00 00 	movabs $0x809000,%r12
  802359:	00 00 00 
  80235c:	4c 89 e6             	mov    %r12,%rsi
  80235f:	48 89 df             	mov    %rbx,%rdi
  802362:	48 b8 0b 11 80 00 00 	movabs $0x80110b,%rax
  802369:	00 00 00 
  80236c:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  80236e:	41 8b 84 24 80 00 00 	mov    0x80(%r12),%eax
  802375:	00 
  802376:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80237c:	41 8b 84 24 84 00 00 	mov    0x84(%r12),%eax
  802383:	00 
  802384:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  80238a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80238f:	5b                   	pop    %rbx
  802390:	41 5c                	pop    %r12
  802392:	5d                   	pop    %rbp
  802393:	c3                   	ret

0000000000802394 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  802394:	f3 0f 1e fa          	endbr64
    if (n >= sizeof(fsipcbuf.write.req_buf)) {
  802398:	48 81 fa ef 0f 00 00 	cmp    $0xfef,%rdx
  80239f:	77 41                	ja     8023e2 <devfile_write+0x4e>
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  8023a1:	55                   	push   %rbp
  8023a2:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  8023a5:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8023ac:	00 00 00 
  8023af:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  8023b2:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.write.req_n = n;
  8023b4:	48 89 50 08          	mov    %rdx,0x8(%rax)
    memmove(fsipcbuf.write.req_buf, buf, n);
  8023b8:	48 8d 78 10          	lea    0x10(%rax),%rdi
  8023bc:	48 b8 26 13 80 00 00 	movabs $0x801326,%rax
  8023c3:	00 00 00 
  8023c6:	ff d0                	call   *%rax
    res = fsipc(FSREQ_WRITE, NULL);
  8023c8:	be 00 00 00 00       	mov    $0x0,%esi
  8023cd:	bf 04 00 00 00       	mov    $0x4,%edi
  8023d2:	48 b8 0f 22 80 00 00 	movabs $0x80220f,%rax
  8023d9:	00 00 00 
  8023dc:	ff d0                	call   *%rax
  8023de:	48 98                	cltq
}
  8023e0:	5d                   	pop    %rbp
  8023e1:	c3                   	ret
        return -E_INVAL;
  8023e2:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
}
  8023e9:	c3                   	ret

00000000008023ea <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  8023ea:	f3 0f 1e fa          	endbr64
  8023ee:	55                   	push   %rbp
  8023ef:	48 89 e5             	mov    %rsp,%rbp
  8023f2:	41 55                	push   %r13
  8023f4:	41 54                	push   %r12
  8023f6:	53                   	push   %rbx
  8023f7:	48 83 ec 08          	sub    $0x8,%rsp
  8023fb:	49 89 f4             	mov    %rsi,%r12
  8023fe:	48 89 d3             	mov    %rdx,%rbx
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  802401:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802408:	00 00 00 
  80240b:	8b 57 0c             	mov    0xc(%rdi),%edx
  80240e:	89 10                	mov    %edx,(%rax)
    fsipcbuf.read.req_n = n;
  802410:	48 89 58 08          	mov    %rbx,0x8(%rax)
    res = fsipc(FSREQ_READ, NULL);
  802414:	be 00 00 00 00       	mov    $0x0,%esi
  802419:	bf 03 00 00 00       	mov    $0x3,%edi
  80241e:	48 b8 0f 22 80 00 00 	movabs $0x80220f,%rax
  802425:	00 00 00 
  802428:	ff d0                	call   *%rax
  80242a:	4c 63 e8             	movslq %eax,%r13
    if (res < 0) {
  80242d:	4d 85 ed             	test   %r13,%r13
  802430:	78 2a                	js     80245c <devfile_read+0x72>
    assert(res <= n && res <= PAGE_SIZE);
  802432:	4c 89 ea             	mov    %r13,%rdx
  802435:	4c 39 eb             	cmp    %r13,%rbx
  802438:	72 30                	jb     80246a <devfile_read+0x80>
  80243a:	49 81 fd 00 10 00 00 	cmp    $0x1000,%r13
  802441:	7f 27                	jg     80246a <devfile_read+0x80>
    memmove(buf, &fsipcbuf, res);
  802443:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  80244a:	00 00 00 
  80244d:	4c 89 e7             	mov    %r12,%rdi
  802450:	48 b8 26 13 80 00 00 	movabs $0x801326,%rax
  802457:	00 00 00 
  80245a:	ff d0                	call   *%rax
}
  80245c:	4c 89 e8             	mov    %r13,%rax
  80245f:	48 83 c4 08          	add    $0x8,%rsp
  802463:	5b                   	pop    %rbx
  802464:	41 5c                	pop    %r12
  802466:	41 5d                	pop    %r13
  802468:	5d                   	pop    %rbp
  802469:	c3                   	ret
    assert(res <= n && res <= PAGE_SIZE);
  80246a:	48 b9 b3 42 80 00 00 	movabs $0x8042b3,%rcx
  802471:	00 00 00 
  802474:	48 ba d0 42 80 00 00 	movabs $0x8042d0,%rdx
  80247b:	00 00 00 
  80247e:	be 7b 00 00 00       	mov    $0x7b,%esi
  802483:	48 bf e5 42 80 00 00 	movabs $0x8042e5,%rdi
  80248a:	00 00 00 
  80248d:	b8 00 00 00 00       	mov    $0x0,%eax
  802492:	49 b8 66 06 80 00 00 	movabs $0x800666,%r8
  802499:	00 00 00 
  80249c:	41 ff d0             	call   *%r8

000000000080249f <open>:
open(const char *path, int mode) {
  80249f:	f3 0f 1e fa          	endbr64
  8024a3:	55                   	push   %rbp
  8024a4:	48 89 e5             	mov    %rsp,%rbp
  8024a7:	41 55                	push   %r13
  8024a9:	41 54                	push   %r12
  8024ab:	53                   	push   %rbx
  8024ac:	48 83 ec 18          	sub    $0x18,%rsp
  8024b0:	49 89 fc             	mov    %rdi,%r12
  8024b3:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  8024b6:	48 b8 c6 10 80 00 00 	movabs $0x8010c6,%rax
  8024bd:	00 00 00 
  8024c0:	ff d0                	call   *%rax
  8024c2:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  8024c8:	0f 87 8a 00 00 00    	ja     802558 <open+0xb9>
    if ((res = fd_alloc(&fd)) < 0) return res;
  8024ce:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  8024d2:	48 b8 0a 1b 80 00 00 	movabs $0x801b0a,%rax
  8024d9:	00 00 00 
  8024dc:	ff d0                	call   *%rax
  8024de:	89 c3                	mov    %eax,%ebx
  8024e0:	85 c0                	test   %eax,%eax
  8024e2:	78 50                	js     802534 <open+0x95>
    strcpy(fsipcbuf.open.req_path, path);
  8024e4:	4c 89 e6             	mov    %r12,%rsi
  8024e7:	48 bb 00 90 80 00 00 	movabs $0x809000,%rbx
  8024ee:	00 00 00 
  8024f1:	48 89 df             	mov    %rbx,%rdi
  8024f4:	48 b8 0b 11 80 00 00 	movabs $0x80110b,%rax
  8024fb:	00 00 00 
  8024fe:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  802500:	44 89 ab 00 04 00 00 	mov    %r13d,0x400(%rbx)
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  802507:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80250b:	bf 01 00 00 00       	mov    $0x1,%edi
  802510:	48 b8 0f 22 80 00 00 	movabs $0x80220f,%rax
  802517:	00 00 00 
  80251a:	ff d0                	call   *%rax
  80251c:	89 c3                	mov    %eax,%ebx
  80251e:	85 c0                	test   %eax,%eax
  802520:	78 1f                	js     802541 <open+0xa2>
    return fd2num(fd);
  802522:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802526:	48 b8 d4 1a 80 00 00 	movabs $0x801ad4,%rax
  80252d:	00 00 00 
  802530:	ff d0                	call   *%rax
  802532:	89 c3                	mov    %eax,%ebx
}
  802534:	89 d8                	mov    %ebx,%eax
  802536:	48 83 c4 18          	add    $0x18,%rsp
  80253a:	5b                   	pop    %rbx
  80253b:	41 5c                	pop    %r12
  80253d:	41 5d                	pop    %r13
  80253f:	5d                   	pop    %rbp
  802540:	c3                   	ret
        fd_close(fd, 0);
  802541:	be 00 00 00 00       	mov    $0x0,%esi
  802546:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80254a:	48 b8 31 1c 80 00 00 	movabs $0x801c31,%rax
  802551:	00 00 00 
  802554:	ff d0                	call   *%rax
        return res;
  802556:	eb dc                	jmp    802534 <open+0x95>
        return -E_BAD_PATH;
  802558:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  80255d:	eb d5                	jmp    802534 <open+0x95>

000000000080255f <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  80255f:	f3 0f 1e fa          	endbr64
  802563:	55                   	push   %rbp
  802564:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  802567:	be 00 00 00 00       	mov    $0x0,%esi
  80256c:	bf 08 00 00 00       	mov    $0x8,%edi
  802571:	48 b8 0f 22 80 00 00 	movabs $0x80220f,%rax
  802578:	00 00 00 
  80257b:	ff d0                	call   *%rax
}
  80257d:	5d                   	pop    %rbp
  80257e:	c3                   	ret

000000000080257f <copy_shared_region>:
    if (sys_unmap_region(0, UTEMP, USER_STACK_SIZE) < 0) goto error;
    return res;
}

static int
copy_shared_region(void *start, void *end, void *arg) {
  80257f:	f3 0f 1e fa          	endbr64
  802583:	55                   	push   %rbp
  802584:	48 89 e5             	mov    %rsp,%rbp
  802587:	41 55                	push   %r13
  802589:	41 54                	push   %r12
  80258b:	53                   	push   %rbx
  80258c:	48 83 ec 08          	sub    $0x8,%rsp
  802590:	48 89 fb             	mov    %rdi,%rbx
  802593:	49 89 f4             	mov    %rsi,%r12
    envid_t child = *(envid_t *)arg;
  802596:	44 8b 2a             	mov    (%rdx),%r13d
    return sys_map_region(0, start, child, start, end - start, get_prot(start));
  802599:	48 b8 b8 35 80 00 00 	movabs $0x8035b8,%rax
  8025a0:	00 00 00 
  8025a3:	ff d0                	call   *%rax
  8025a5:	41 89 c1             	mov    %eax,%r9d
  8025a8:	4d 89 e0             	mov    %r12,%r8
  8025ab:	49 29 d8             	sub    %rbx,%r8
  8025ae:	48 89 d9             	mov    %rbx,%rcx
  8025b1:	44 89 ea             	mov    %r13d,%edx
  8025b4:	48 89 de             	mov    %rbx,%rsi
  8025b7:	bf 00 00 00 00       	mov    $0x0,%edi
  8025bc:	48 b8 7b 17 80 00 00 	movabs $0x80177b,%rax
  8025c3:	00 00 00 
  8025c6:	ff d0                	call   *%rax
}
  8025c8:	48 83 c4 08          	add    $0x8,%rsp
  8025cc:	5b                   	pop    %rbx
  8025cd:	41 5c                	pop    %r12
  8025cf:	41 5d                	pop    %r13
  8025d1:	5d                   	pop    %rbp
  8025d2:	c3                   	ret

00000000008025d3 <spawn>:
spawn(const char *prog, const char **argv) {
  8025d3:	f3 0f 1e fa          	endbr64
  8025d7:	55                   	push   %rbp
  8025d8:	48 89 e5             	mov    %rsp,%rbp
  8025db:	41 57                	push   %r15
  8025dd:	41 56                	push   %r14
  8025df:	41 55                	push   %r13
  8025e1:	41 54                	push   %r12
  8025e3:	53                   	push   %rbx
  8025e4:	48 81 ec f8 02 00 00 	sub    $0x2f8,%rsp
  8025eb:	49 89 f4             	mov    %rsi,%r12
    int fd = open(prog, O_RDONLY);
  8025ee:	be 00 00 00 00       	mov    $0x0,%esi
  8025f3:	48 b8 9f 24 80 00 00 	movabs $0x80249f,%rax
  8025fa:	00 00 00 
  8025fd:	ff d0                	call   *%rax
  8025ff:	89 85 fc fc ff ff    	mov    %eax,-0x304(%rbp)
    if (fd < 0) return fd;
  802605:	85 c0                	test   %eax,%eax
  802607:	0f 88 30 06 00 00    	js     802c3d <spawn+0x66a>
  80260d:	89 c7                	mov    %eax,%edi
    res = readn(fd, elf_buf, sizeof(elf_buf));
  80260f:	ba 00 02 00 00       	mov    $0x200,%edx
  802614:	48 8d b5 d0 fd ff ff 	lea    -0x230(%rbp),%rsi
  80261b:	48 b8 2b 1f 80 00 00 	movabs $0x801f2b,%rax
  802622:	00 00 00 
  802625:	ff d0                	call   *%rax
  802627:	89 c6                	mov    %eax,%esi
    if (res != sizeof(elf_buf)) {
  802629:	3d 00 02 00 00       	cmp    $0x200,%eax
  80262e:	0f 85 7d 02 00 00    	jne    8028b1 <spawn+0x2de>
        elf->e_elf[1] != 1 /* little endian */ ||
  802634:	48 b8 ff ff ff ff ff 	movabs $0xffffffffffffff,%rax
  80263b:	ff ff 00 
  80263e:	48 23 85 d0 fd ff ff 	and    -0x230(%rbp),%rax
    if (elf->e_magic != ELF_MAGIC ||
  802645:	48 ba 7f 45 4c 46 02 	movabs $0x10102464c457f,%rdx
  80264c:	01 01 00 
  80264f:	48 39 d0             	cmp    %rdx,%rax
  802652:	0f 85 95 02 00 00    	jne    8028ed <spawn+0x31a>
        elf->e_type != ET_EXEC /* executable */ ||
  802658:	81 bd e0 fd ff ff 02 	cmpl   $0x3e0002,-0x220(%rbp)
  80265f:	00 3e 00 
  802662:	0f 85 85 02 00 00    	jne    8028ed <spawn+0x31a>

/* This must be inlined. Exercise for reader: why? */
static inline envid_t __attribute__((always_inline))
sys_exofork(void) {
    envid_t ret;
    asm volatile("int %2"
  802668:	b8 09 00 00 00       	mov    $0x9,%eax
  80266d:	cd 30                	int    $0x30
  80266f:	41 89 c6             	mov    %eax,%r14d
  802672:	89 c3                	mov    %eax,%ebx
    if ((int)(res = sys_exofork()) < 0) goto error2;
  802674:	85 c0                	test   %eax,%eax
  802676:	0f 88 a9 05 00 00    	js     802c25 <spawn+0x652>
    envid_t child = res;
  80267c:	89 85 cc fd ff ff    	mov    %eax,-0x234(%rbp)
    struct Trapframe child_tf = envs[ENVX(child)].env_tf;
  802682:	25 ff 03 00 00       	and    $0x3ff,%eax
  802687:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  80268b:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  80268f:	48 c1 e0 04          	shl    $0x4,%rax
  802693:	48 be 00 00 a0 1f 80 	movabs $0x801fa00000,%rsi
  80269a:	00 00 00 
  80269d:	48 01 c6             	add    %rax,%rsi
  8026a0:	48 8b 06             	mov    (%rsi),%rax
  8026a3:	48 89 85 0c fd ff ff 	mov    %rax,-0x2f4(%rbp)
  8026aa:	48 8b 86 b8 00 00 00 	mov    0xb8(%rsi),%rax
  8026b1:	48 89 85 c4 fd ff ff 	mov    %rax,-0x23c(%rbp)
  8026b8:	48 8d bd 10 fd ff ff 	lea    -0x2f0(%rbp),%rdi
  8026bf:	48 c7 c1 fc ff ff ff 	mov    $0xfffffffffffffffc,%rcx
  8026c6:	48 29 ce             	sub    %rcx,%rsi
  8026c9:	81 c1 c0 00 00 00    	add    $0xc0,%ecx
  8026cf:	c1 e9 03             	shr    $0x3,%ecx
  8026d2:	89 c9                	mov    %ecx,%ecx
  8026d4:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
    child_tf.tf_rip = elf->e_entry;
  8026d7:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8026de:	48 89 85 a4 fd ff ff 	mov    %rax,-0x25c(%rbp)
    for (argc = 0; argv[argc] != 0; argc++)
  8026e5:	49 8b 3c 24          	mov    (%r12),%rdi
  8026e9:	48 85 ff             	test   %rdi,%rdi
  8026ec:	0f 84 7f 05 00 00    	je     802c71 <spawn+0x69e>
  8026f2:	41 bd 01 00 00 00    	mov    $0x1,%r13d
    string_size = 0;
  8026f8:	41 bf 00 00 00 00    	mov    $0x0,%r15d
        string_size += strlen(argv[argc]) + 1;
  8026fe:	48 bb c6 10 80 00 00 	movabs $0x8010c6,%rbx
  802705:	00 00 00 
  802708:	ff d3                	call   *%rbx
  80270a:	4c 01 f8             	add    %r15,%rax
  80270d:	4c 8d 78 01          	lea    0x1(%rax),%r15
    for (argc = 0; argv[argc] != 0; argc++)
  802711:	4c 89 ea             	mov    %r13,%rdx
  802714:	49 83 c5 01          	add    $0x1,%r13
  802718:	4b 8b 7c ec f8       	mov    -0x8(%r12,%r13,8),%rdi
  80271d:	48 85 ff             	test   %rdi,%rdi
  802720:	75 e6                	jne    802708 <spawn+0x135>
    string_store = (char *)UTEMP + USER_STACK_SIZE - string_size;
  802722:	49 89 d5             	mov    %rdx,%r13
  802725:	48 89 95 e8 fc ff ff 	mov    %rdx,-0x318(%rbp)
  80272c:	48 f7 d0             	not    %rax
  80272f:	48 8d 98 00 00 41 00 	lea    0x410000(%rax),%rbx
    argv_store = (uintptr_t *)(ROUNDDOWN(string_store, sizeof(uintptr_t)) - sizeof(uintptr_t) * (argc + 1));
  802736:	49 89 df             	mov    %rbx,%r15
  802739:	49 83 e7 f8          	and    $0xfffffffffffffff8,%r15
  80273d:	4c 89 bd e0 fc ff ff 	mov    %r15,-0x320(%rbp)
  802744:	89 d0                	mov    %edx,%eax
  802746:	83 c0 01             	add    $0x1,%eax
  802749:	48 98                	cltq
  80274b:	48 c1 e0 03          	shl    $0x3,%rax
  80274f:	49 29 c7             	sub    %rax,%r15
  802752:	4c 89 bd f0 fc ff ff 	mov    %r15,-0x310(%rbp)
    if ((void *)(argv_store - 2) < (void *)UTEMP) return -E_NO_MEM;
  802759:	49 8d 47 f0          	lea    -0x10(%r15),%rax
  80275d:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  802763:	0f 86 ff 04 00 00    	jbe    802c68 <spawn+0x695>
    if ((res = sys_alloc_region(0, UTEMP, USER_STACK_SIZE, PROT_RW)) < 0) return res;
  802769:	b9 06 00 00 00       	mov    $0x6,%ecx
  80276e:	ba 00 00 01 00       	mov    $0x10000,%edx
  802773:	be 00 00 40 00       	mov    $0x400000,%esi
  802778:	48 b8 10 17 80 00 00 	movabs $0x801710,%rax
  80277f:	00 00 00 
  802782:	ff d0                	call   *%rax
  802784:	85 c0                	test   %eax,%eax
  802786:	0f 88 e1 04 00 00    	js     802c6d <spawn+0x69a>
    for (i = 0; i < argc; i++) {
  80278c:	4c 89 e8             	mov    %r13,%rax
  80278f:	45 85 ed             	test   %r13d,%r13d
  802792:	7e 54                	jle    8027e8 <spawn+0x215>
  802794:	4d 89 fd             	mov    %r15,%r13
  802797:	48 98                	cltq
  802799:	4d 8d 3c c7          	lea    (%r15,%rax,8),%r15
        argv_store[i] = UTEMP2USTACK(string_store);
  80279d:	48 b8 00 70 fe ff 7f 	movabs $0x7ffffe7000,%rax
  8027a4:	00 00 00 
  8027a7:	48 8d 84 03 00 00 c0 	lea    -0x400000(%rbx,%rax,1),%rax
  8027ae:	ff 
  8027af:	49 89 45 00          	mov    %rax,0x0(%r13)
        strcpy(string_store, argv[i]);
  8027b3:	49 8b 34 24          	mov    (%r12),%rsi
  8027b7:	48 89 df             	mov    %rbx,%rdi
  8027ba:	48 b8 0b 11 80 00 00 	movabs $0x80110b,%rax
  8027c1:	00 00 00 
  8027c4:	ff d0                	call   *%rax
        string_store += strlen(argv[i]) + 1;
  8027c6:	49 8b 3c 24          	mov    (%r12),%rdi
  8027ca:	48 b8 c6 10 80 00 00 	movabs $0x8010c6,%rax
  8027d1:	00 00 00 
  8027d4:	ff d0                	call   *%rax
  8027d6:	48 8d 5c 03 01       	lea    0x1(%rbx,%rax,1),%rbx
    for (i = 0; i < argc; i++) {
  8027db:	49 83 c5 08          	add    $0x8,%r13
  8027df:	49 83 c4 08          	add    $0x8,%r12
  8027e3:	4d 39 fd             	cmp    %r15,%r13
  8027e6:	75 b5                	jne    80279d <spawn+0x1ca>
    argv_store[argc] = 0;
  8027e8:	48 8b 85 e0 fc ff ff 	mov    -0x320(%rbp),%rax
  8027ef:	48 c7 40 f8 00 00 00 	movq   $0x0,-0x8(%rax)
  8027f6:	00 
    assert(string_store == (char *)UTEMP + USER_STACK_SIZE);
  8027f7:	48 81 fb 00 00 41 00 	cmp    $0x410000,%rbx
  8027fe:	0f 85 30 01 00 00    	jne    802934 <spawn+0x361>
    argv_store[-1] = UTEMP2USTACK(argv_store);
  802804:	48 b9 00 70 fe ff 7f 	movabs $0x7ffffe7000,%rcx
  80280b:	00 00 00 
  80280e:	48 8b b5 f0 fc ff ff 	mov    -0x310(%rbp),%rsi
  802815:	48 8d 84 0e 00 00 c0 	lea    -0x400000(%rsi,%rcx,1),%rax
  80281c:	ff 
  80281d:	48 89 46 f8          	mov    %rax,-0x8(%rsi)
    argv_store[-2] = argc;
  802821:	48 8b 85 e8 fc ff ff 	mov    -0x318(%rbp),%rax
  802828:	48 89 46 f0          	mov    %rax,-0x10(%rsi)
    tf->tf_rsp = UTEMP2USTACK(&argv_store[-2]);
  80282c:	48 b8 f0 6f fe ff 7f 	movabs $0x7ffffe6ff0,%rax
  802833:	00 00 00 
  802836:	48 8d 84 06 00 00 c0 	lea    -0x400000(%rsi,%rax,1),%rax
  80283d:	ff 
  80283e:	48 89 85 bc fd ff ff 	mov    %rax,-0x244(%rbp)
    if (sys_map_region(0, UTEMP, child, (void *)(USER_STACK_TOP - USER_STACK_SIZE),
  802845:	41 b9 06 00 00 00    	mov    $0x6,%r9d
  80284b:	41 b8 00 00 01 00    	mov    $0x10000,%r8d
  802851:	44 89 f2             	mov    %r14d,%edx
  802854:	be 00 00 40 00       	mov    $0x400000,%esi
  802859:	bf 00 00 00 00       	mov    $0x0,%edi
  80285e:	48 b8 7b 17 80 00 00 	movabs $0x80177b,%rax
  802865:	00 00 00 
  802868:	ff d0                	call   *%rax
    if (sys_unmap_region(0, UTEMP, USER_STACK_SIZE) < 0) goto error;
  80286a:	48 bb 50 18 80 00 00 	movabs $0x801850,%rbx
  802871:	00 00 00 
  802874:	ba 00 00 01 00       	mov    $0x10000,%edx
  802879:	be 00 00 40 00       	mov    $0x400000,%esi
  80287e:	bf 00 00 00 00       	mov    $0x0,%edi
  802883:	ff d3                	call   *%rbx
  802885:	85 c0                	test   %eax,%eax
  802887:	78 eb                	js     802874 <spawn+0x2a1>
    struct Proghdr *ph = (struct Proghdr *)(elf_buf + elf->e_phoff);
  802889:	48 8b 85 f0 fd ff ff 	mov    -0x210(%rbp),%rax
  802890:	4c 8d b4 05 d0 fd ff 	lea    -0x230(%rbp,%rax,1),%r14
  802897:	ff 
    for (size_t i = 0; i < elf->e_phnum; i++, ph++) {
  802898:	66 83 bd 08 fe ff ff 	cmpw   $0x0,-0x1f8(%rbp)
  80289f:	00 
  8028a0:	0f 84 68 02 00 00    	je     802b0e <spawn+0x53b>
  8028a6:	41 bf 00 00 00 00    	mov    $0x0,%r15d
  8028ac:	e9 c5 01 00 00       	jmp    802a76 <spawn+0x4a3>
        cprintf("Wrong ELF header size or read error: %i\n", res);
  8028b1:	48 bf c0 44 80 00 00 	movabs $0x8044c0,%rdi
  8028b8:	00 00 00 
  8028bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8028c0:	48 ba c2 07 80 00 00 	movabs $0x8007c2,%rdx
  8028c7:	00 00 00 
  8028ca:	ff d2                	call   *%rdx
        close(fd);
  8028cc:	8b bd fc fc ff ff    	mov    -0x304(%rbp),%edi
  8028d2:	48 b8 df 1c 80 00 00 	movabs $0x801cdf,%rax
  8028d9:	00 00 00 
  8028dc:	ff d0                	call   *%rax
        return -E_NOT_EXEC;
  8028de:	c7 85 fc fc ff ff ee 	movl   $0xffffffee,-0x304(%rbp)
  8028e5:	ff ff ff 
  8028e8:	e9 50 03 00 00       	jmp    802c3d <spawn+0x66a>
        cprintf("Elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  8028ed:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  8028f2:	8b b5 d0 fd ff ff    	mov    -0x230(%rbp),%esi
  8028f8:	48 bf f0 42 80 00 00 	movabs $0x8042f0,%rdi
  8028ff:	00 00 00 
  802902:	b8 00 00 00 00       	mov    $0x0,%eax
  802907:	48 b9 c2 07 80 00 00 	movabs $0x8007c2,%rcx
  80290e:	00 00 00 
  802911:	ff d1                	call   *%rcx
        close(fd);
  802913:	8b bd fc fc ff ff    	mov    -0x304(%rbp),%edi
  802919:	48 b8 df 1c 80 00 00 	movabs $0x801cdf,%rax
  802920:	00 00 00 
  802923:	ff d0                	call   *%rax
        return -E_NOT_EXEC;
  802925:	c7 85 fc fc ff ff ee 	movl   $0xffffffee,-0x304(%rbp)
  80292c:	ff ff ff 
  80292f:	e9 09 03 00 00       	jmp    802c3d <spawn+0x66a>
    assert(string_store == (char *)UTEMP + USER_STACK_SIZE);
  802934:	48 b9 f0 44 80 00 00 	movabs $0x8044f0,%rcx
  80293b:	00 00 00 
  80293e:	48 ba d0 42 80 00 00 	movabs $0x8042d0,%rdx
  802945:	00 00 00 
  802948:	be f0 00 00 00       	mov    $0xf0,%esi
  80294d:	48 bf 0a 43 80 00 00 	movabs $0x80430a,%rdi
  802954:	00 00 00 
  802957:	b8 00 00 00 00       	mov    $0x0,%eax
  80295c:	49 b8 66 06 80 00 00 	movabs $0x800666,%r8
  802963:	00 00 00 
  802966:	41 ff d0             	call   *%r8
    /* seek() fd to fileoffset  */
    /* read filesz to UTEMP */
    /* Map read section conents to child */
    /* Unmap it from parent */
    if (filesz != 0) {
        res = sys_alloc_region(CURENVID, UTEMP, filesz, perm | PROT_W);
  802969:	8b 8d f0 fc ff ff    	mov    -0x310(%rbp),%ecx
  80296f:	83 c9 02             	or     $0x2,%ecx
  802972:	48 89 da             	mov    %rbx,%rdx
  802975:	be 00 00 40 00       	mov    $0x400000,%esi
  80297a:	bf 00 00 00 00       	mov    $0x0,%edi
  80297f:	48 b8 10 17 80 00 00 	movabs $0x801710,%rax
  802986:	00 00 00 
  802989:	ff d0                	call   *%rax
        if (res < 0) {
  80298b:	85 c0                	test   %eax,%eax
  80298d:	0f 88 7e 02 00 00    	js     802c11 <spawn+0x63e>
            return res;
        }

        res = seek(fd, fileoffset);
  802993:	8b b5 e8 fc ff ff    	mov    -0x318(%rbp),%esi
  802999:	8b bd fc fc ff ff    	mov    -0x304(%rbp),%edi
  80299f:	48 b8 5d 20 80 00 00 	movabs $0x80205d,%rax
  8029a6:	00 00 00 
  8029a9:	ff d0                	call   *%rax
        if (res < 0) {
  8029ab:	85 c0                	test   %eax,%eax
  8029ad:	0f 88 a2 02 00 00    	js     802c55 <spawn+0x682>
            return res;
        }

        res = readn(fd, (void *)UTEMP, filesz);
  8029b3:	48 89 da             	mov    %rbx,%rdx
  8029b6:	be 00 00 40 00       	mov    $0x400000,%esi
  8029bb:	8b bd fc fc ff ff    	mov    -0x304(%rbp),%edi
  8029c1:	48 b8 2b 1f 80 00 00 	movabs $0x801f2b,%rax
  8029c8:	00 00 00 
  8029cb:	ff d0                	call   *%rax
        if (res < 0) {
  8029cd:	85 c0                	test   %eax,%eax
  8029cf:	0f 88 84 02 00 00    	js     802c59 <spawn+0x686>
            return res;
        }

        res = sys_map_region(CURENVID, (void *)UTEMP, child, (void *)va, filesz, perm);
  8029d5:	44 8b 8d f0 fc ff ff 	mov    -0x310(%rbp),%r9d
  8029dc:	49 89 d8             	mov    %rbx,%r8
  8029df:	4c 89 e1             	mov    %r12,%rcx
  8029e2:	8b 95 e0 fc ff ff    	mov    -0x320(%rbp),%edx
  8029e8:	be 00 00 40 00       	mov    $0x400000,%esi
  8029ed:	bf 00 00 00 00       	mov    $0x0,%edi
  8029f2:	48 b8 7b 17 80 00 00 	movabs $0x80177b,%rax
  8029f9:	00 00 00 
  8029fc:	ff d0                	call   *%rax
        if (res < 0) {
  8029fe:	85 c0                	test   %eax,%eax
  802a00:	0f 88 57 02 00 00    	js     802c5d <spawn+0x68a>
            return res;
        }

        res = sys_unmap_region(CURENVID, UTEMP, filesz);
  802a06:	48 89 da             	mov    %rbx,%rdx
  802a09:	be 00 00 40 00       	mov    $0x400000,%esi
  802a0e:	bf 00 00 00 00       	mov    $0x0,%edi
  802a13:	48 b8 50 18 80 00 00 	movabs $0x801850,%rax
  802a1a:	00 00 00 
  802a1d:	ff d0                	call   *%rax
        if (res < 0) {
  802a1f:	85 c0                	test   %eax,%eax
  802a21:	0f 89 ca 00 00 00    	jns    802af1 <spawn+0x51e>
  802a27:	89 c3                	mov    %eax,%ebx
  802a29:	e9 e5 01 00 00       	jmp    802c13 <spawn+0x640>
            return res;
        }
    }

    if (memsz > filesz) {
        res = sys_alloc_region(child, (void *)(va + filesz), (memsz - filesz), perm | ALLOC_ZERO);
  802a2e:	8b 8d f0 fc ff ff    	mov    -0x310(%rbp),%ecx
  802a34:	81 c9 00 00 10 00    	or     $0x100000,%ecx
  802a3a:	4c 89 ea             	mov    %r13,%rdx
  802a3d:	48 29 da             	sub    %rbx,%rdx
  802a40:	4a 8d 34 23          	lea    (%rbx,%r12,1),%rsi
  802a44:	8b bd e0 fc ff ff    	mov    -0x320(%rbp),%edi
  802a4a:	48 b8 10 17 80 00 00 	movabs $0x801710,%rax
  802a51:	00 00 00 
  802a54:	ff d0                	call   *%rax
        if ((res = map_segment(child, ph->p_va, ph->p_memsz,
  802a56:	85 c0                	test   %eax,%eax
  802a58:	0f 88 a1 00 00 00    	js     802aff <spawn+0x52c>
    for (size_t i = 0; i < elf->e_phnum; i++, ph++) {
  802a5e:	49 83 c7 01          	add    $0x1,%r15
  802a62:	49 83 c6 38          	add    $0x38,%r14
  802a66:	0f b7 85 08 fe ff ff 	movzwl -0x1f8(%rbp),%eax
  802a6d:	49 39 c7             	cmp    %rax,%r15
  802a70:	0f 83 98 00 00 00    	jae    802b0e <spawn+0x53b>
        if (ph->p_type != ELF_PROG_LOAD) continue;
  802a76:	41 83 3e 01          	cmpl   $0x1,(%r14)
  802a7a:	75 e2                	jne    802a5e <spawn+0x48b>
        if (ph->p_flags & ELF_PROG_FLAG_WRITE) perm |= PROT_W;
  802a7c:	41 8b 46 04          	mov    0x4(%r14),%eax
  802a80:	89 c2                	mov    %eax,%edx
  802a82:	83 e2 02             	and    $0x2,%edx
        if (ph->p_flags & ELF_PROG_FLAG_READ) perm |= PROT_R;
  802a85:	89 d1                	mov    %edx,%ecx
  802a87:	83 c9 04             	or     $0x4,%ecx
  802a8a:	a8 04                	test   $0x4,%al
  802a8c:	0f 45 d1             	cmovne %ecx,%edx
        if (ph->p_flags & ELF_PROG_FLAG_EXEC) perm |= PROT_X;
  802a8f:	83 e0 01             	and    $0x1,%eax
  802a92:	09 d0                	or     %edx,%eax
  802a94:	89 85 f0 fc ff ff    	mov    %eax,-0x310(%rbp)
        if ((res = map_segment(child, ph->p_va, ph->p_memsz,
  802a9a:	49 8b 46 08          	mov    0x8(%r14),%rax
  802a9e:	89 85 e8 fc ff ff    	mov    %eax,-0x318(%rbp)
  802aa4:	49 8b 5e 20          	mov    0x20(%r14),%rbx
  802aa8:	4d 8b 6e 28          	mov    0x28(%r14),%r13
  802aac:	4d 8b 66 10          	mov    0x10(%r14),%r12
  802ab0:	8b 8d cc fd ff ff    	mov    -0x234(%rbp),%ecx
  802ab6:	89 8d e0 fc ff ff    	mov    %ecx,-0x320(%rbp)
    if (res) {
  802abc:	44 89 e2             	mov    %r12d,%edx
  802abf:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  802ac5:	74 14                	je     802adb <spawn+0x508>
        va -= res;
  802ac7:	48 63 ca             	movslq %edx,%rcx
  802aca:	49 29 cc             	sub    %rcx,%r12
        memsz += res;
  802acd:	49 01 cd             	add    %rcx,%r13
        filesz += res;
  802ad0:	48 01 cb             	add    %rcx,%rbx
        fileoffset -= res;
  802ad3:	29 d0                	sub    %edx,%eax
  802ad5:	89 85 e8 fc ff ff    	mov    %eax,-0x318(%rbp)
    if (filesz > HUGE_PAGE_SIZE) {
  802adb:	48 81 fb 00 00 20 00 	cmp    $0x200000,%rbx
  802ae2:	0f 87 79 01 00 00    	ja     802c61 <spawn+0x68e>
    if (filesz != 0) {
  802ae8:	48 85 db             	test   %rbx,%rbx
  802aeb:	0f 85 78 fe ff ff    	jne    802969 <spawn+0x396>
    if (memsz > filesz) {
  802af1:	4c 39 eb             	cmp    %r13,%rbx
  802af4:	0f 83 64 ff ff ff    	jae    802a5e <spawn+0x48b>
  802afa:	e9 2f ff ff ff       	jmp    802a2e <spawn+0x45b>
        if (res < 0) {
  802aff:	ba 00 00 00 00       	mov    $0x0,%edx
  802b04:	0f 4e d0             	cmovle %eax,%edx
  802b07:	89 d3                	mov    %edx,%ebx
  802b09:	e9 05 01 00 00       	jmp    802c13 <spawn+0x640>
    close(fd);
  802b0e:	8b bd fc fc ff ff    	mov    -0x304(%rbp),%edi
  802b14:	48 b8 df 1c 80 00 00 	movabs $0x801cdf,%rax
  802b1b:	00 00 00 
  802b1e:	ff d0                	call   *%rax
    if ((res = foreach_shared_region(copy_shared_region, &child)) < 0)
  802b20:	48 8d b5 cc fd ff ff 	lea    -0x234(%rbp),%rsi
  802b27:	48 bf 7f 25 80 00 00 	movabs $0x80257f,%rdi
  802b2e:	00 00 00 
  802b31:	48 b8 38 36 80 00 00 	movabs $0x803638,%rax
  802b38:	00 00 00 
  802b3b:	ff d0                	call   *%rax
  802b3d:	85 c0                	test   %eax,%eax
  802b3f:	78 49                	js     802b8a <spawn+0x5b7>
    if ((res = sys_env_set_trapframe(child, &child_tf)) < 0)
  802b41:	48 8d b5 0c fd ff ff 	lea    -0x2f4(%rbp),%rsi
  802b48:	8b bd cc fd ff ff    	mov    -0x234(%rbp),%edi
  802b4e:	48 b8 28 19 80 00 00 	movabs $0x801928,%rax
  802b55:	00 00 00 
  802b58:	ff d0                	call   *%rax
  802b5a:	85 c0                	test   %eax,%eax
  802b5c:	78 59                	js     802bb7 <spawn+0x5e4>
    if ((res = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802b5e:	be 02 00 00 00       	mov    $0x2,%esi
  802b63:	8b bd cc fd ff ff    	mov    -0x234(%rbp),%edi
  802b69:	48 b8 bb 18 80 00 00 	movabs $0x8018bb,%rax
  802b70:	00 00 00 
  802b73:	ff d0                	call   *%rax
  802b75:	85 c0                	test   %eax,%eax
  802b77:	78 6b                	js     802be4 <spawn+0x611>
    return child;
  802b79:	8b 85 cc fd ff ff    	mov    -0x234(%rbp),%eax
  802b7f:	89 85 fc fc ff ff    	mov    %eax,-0x304(%rbp)
  802b85:	e9 b3 00 00 00       	jmp    802c3d <spawn+0x66a>
        panic("copy_shared_region: %i", res);
  802b8a:	89 c1                	mov    %eax,%ecx
  802b8c:	48 ba 16 43 80 00 00 	movabs $0x804316,%rdx
  802b93:	00 00 00 
  802b96:	be 84 00 00 00       	mov    $0x84,%esi
  802b9b:	48 bf 0a 43 80 00 00 	movabs $0x80430a,%rdi
  802ba2:	00 00 00 
  802ba5:	b8 00 00 00 00       	mov    $0x0,%eax
  802baa:	49 b8 66 06 80 00 00 	movabs $0x800666,%r8
  802bb1:	00 00 00 
  802bb4:	41 ff d0             	call   *%r8
        panic("sys_env_set_trapframe: %i", res);
  802bb7:	89 c1                	mov    %eax,%ecx
  802bb9:	48 ba 2d 43 80 00 00 	movabs $0x80432d,%rdx
  802bc0:	00 00 00 
  802bc3:	be 87 00 00 00       	mov    $0x87,%esi
  802bc8:	48 bf 0a 43 80 00 00 	movabs $0x80430a,%rdi
  802bcf:	00 00 00 
  802bd2:	b8 00 00 00 00       	mov    $0x0,%eax
  802bd7:	49 b8 66 06 80 00 00 	movabs $0x800666,%r8
  802bde:	00 00 00 
  802be1:	41 ff d0             	call   *%r8
        panic("sys_env_set_status: %i", res);
  802be4:	89 c1                	mov    %eax,%ecx
  802be6:	48 ba 47 43 80 00 00 	movabs $0x804347,%rdx
  802bed:	00 00 00 
  802bf0:	be 8a 00 00 00       	mov    $0x8a,%esi
  802bf5:	48 bf 0a 43 80 00 00 	movabs $0x80430a,%rdi
  802bfc:	00 00 00 
  802bff:	b8 00 00 00 00       	mov    $0x0,%eax
  802c04:	49 b8 66 06 80 00 00 	movabs $0x800666,%r8
  802c0b:	00 00 00 
  802c0e:	41 ff d0             	call   *%r8
  802c11:	89 c3                	mov    %eax,%ebx
    sys_env_destroy(child);
  802c13:	8b bd cc fd ff ff    	mov    -0x234(%rbp),%edi
  802c19:	48 b8 d1 15 80 00 00 	movabs $0x8015d1,%rax
  802c20:	00 00 00 
  802c23:	ff d0                	call   *%rax
    close(fd);
  802c25:	8b bd fc fc ff ff    	mov    -0x304(%rbp),%edi
  802c2b:	48 b8 df 1c 80 00 00 	movabs $0x801cdf,%rax
  802c32:	00 00 00 
  802c35:	ff d0                	call   *%rax
    return res;
  802c37:	89 9d fc fc ff ff    	mov    %ebx,-0x304(%rbp)
}
  802c3d:	8b 85 fc fc ff ff    	mov    -0x304(%rbp),%eax
  802c43:	48 81 c4 f8 02 00 00 	add    $0x2f8,%rsp
  802c4a:	5b                   	pop    %rbx
  802c4b:	41 5c                	pop    %r12
  802c4d:	41 5d                	pop    %r13
  802c4f:	41 5e                	pop    %r14
  802c51:	41 5f                	pop    %r15
  802c53:	5d                   	pop    %rbp
  802c54:	c3                   	ret
  802c55:	89 c3                	mov    %eax,%ebx
  802c57:	eb ba                	jmp    802c13 <spawn+0x640>
  802c59:	89 c3                	mov    %eax,%ebx
  802c5b:	eb b6                	jmp    802c13 <spawn+0x640>
  802c5d:	89 c3                	mov    %eax,%ebx
  802c5f:	eb b2                	jmp    802c13 <spawn+0x640>
        return -E_INVAL;
  802c61:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
  802c66:	eb ab                	jmp    802c13 <spawn+0x640>
    if ((void *)(argv_store - 2) < (void *)UTEMP) return -E_NO_MEM;
  802c68:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
    if ((res = init_stack(child, argv, &child_tf)) < 0) goto error;
  802c6d:	89 c3                	mov    %eax,%ebx
  802c6f:	eb a2                	jmp    802c13 <spawn+0x640>
    if ((res = sys_alloc_region(0, UTEMP, USER_STACK_SIZE, PROT_RW)) < 0) return res;
  802c71:	b9 06 00 00 00       	mov    $0x6,%ecx
  802c76:	ba 00 00 01 00       	mov    $0x10000,%edx
  802c7b:	be 00 00 40 00       	mov    $0x400000,%esi
  802c80:	bf 00 00 00 00       	mov    $0x0,%edi
  802c85:	48 b8 10 17 80 00 00 	movabs $0x801710,%rax
  802c8c:	00 00 00 
  802c8f:	ff d0                	call   *%rax
  802c91:	85 c0                	test   %eax,%eax
  802c93:	78 d8                	js     802c6d <spawn+0x69a>
    for (argc = 0; argv[argc] != 0; argc++)
  802c95:	48 c7 85 e8 fc ff ff 	movq   $0x0,-0x318(%rbp)
  802c9c:	00 00 00 00 
    argv_store = (uintptr_t *)(ROUNDDOWN(string_store, sizeof(uintptr_t)) - sizeof(uintptr_t) * (argc + 1));
  802ca0:	48 c7 85 f0 fc ff ff 	movq   $0x40fff8,-0x310(%rbp)
  802ca7:	f8 ff 40 00 
  802cab:	48 c7 85 e0 fc ff ff 	movq   $0x410000,-0x320(%rbp)
  802cb2:	00 00 41 00 
    string_store = (char *)UTEMP + USER_STACK_SIZE - string_size;
  802cb6:	bb 00 00 41 00       	mov    $0x410000,%ebx
  802cbb:	e9 28 fb ff ff       	jmp    8027e8 <spawn+0x215>

0000000000802cc0 <spawnl>:
spawnl(const char *prog, const char *arg0, ...) {
  802cc0:	f3 0f 1e fa          	endbr64
  802cc4:	55                   	push   %rbp
  802cc5:	48 89 e5             	mov    %rsp,%rbp
  802cc8:	48 83 ec 50          	sub    $0x50,%rsp
  802ccc:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  802cd0:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802cd4:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  802cd8:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(vl, arg0);
  802cdc:	c7 45 b8 10 00 00 00 	movl   $0x10,-0x48(%rbp)
  802ce3:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802ce7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802ceb:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802cef:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int argc = 0;
  802cf3:	b9 00 00 00 00       	mov    $0x0,%ecx
    while (va_arg(vl, void *) != NULL) argc++;
  802cf8:	eb 15                	jmp    802d0f <spawnl+0x4f>
  802cfa:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802cfe:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802d02:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802d06:	48 83 3a 00          	cmpq   $0x0,(%rdx)
  802d0a:	74 1c                	je     802d28 <spawnl+0x68>
  802d0c:	83 c1 01             	add    $0x1,%ecx
  802d0f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802d12:	83 f8 2f             	cmp    $0x2f,%eax
  802d15:	77 e3                	ja     802cfa <spawnl+0x3a>
  802d17:	89 c2                	mov    %eax,%edx
  802d19:	4c 8d 55 d0          	lea    -0x30(%rbp),%r10
  802d1d:	4c 01 d2             	add    %r10,%rdx
  802d20:	83 c0 08             	add    $0x8,%eax
  802d23:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802d26:	eb de                	jmp    802d06 <spawnl+0x46>
    const char *argv[argc + 2];
  802d28:	8d 41 02             	lea    0x2(%rcx),%eax
  802d2b:	48 98                	cltq
  802d2d:	48 8d 04 c5 0f 00 00 	lea    0xf(,%rax,8),%rax
  802d34:	00 
  802d35:	49 89 c0             	mov    %rax,%r8
  802d38:	49 83 e0 f0          	and    $0xfffffffffffffff0,%r8
  802d3c:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802d42:	48 89 e2             	mov    %rsp,%rdx
  802d45:	48 29 c2             	sub    %rax,%rdx
  802d48:	48 39 d4             	cmp    %rdx,%rsp
  802d4b:	74 12                	je     802d5f <spawnl+0x9f>
  802d4d:	48 81 ec 00 10 00 00 	sub    $0x1000,%rsp
  802d54:	48 83 8c 24 f8 0f 00 	orq    $0x0,0xff8(%rsp)
  802d5b:	00 00 
  802d5d:	eb e9                	jmp    802d48 <spawnl+0x88>
  802d5f:	4c 89 c0             	mov    %r8,%rax
  802d62:	25 ff 0f 00 00       	and    $0xfff,%eax
  802d67:	48 29 c4             	sub    %rax,%rsp
  802d6a:	48 85 c0             	test   %rax,%rax
  802d6d:	74 06                	je     802d75 <spawnl+0xb5>
  802d6f:	48 83 4c 04 f8 00    	orq    $0x0,-0x8(%rsp,%rax,1)
  802d75:	4c 8d 4c 24 07       	lea    0x7(%rsp),%r9
  802d7a:	4c 89 c8             	mov    %r9,%rax
  802d7d:	48 c1 e8 03          	shr    $0x3,%rax
  802d81:	49 83 e1 f8          	and    $0xfffffffffffffff8,%r9
    argv[0] = arg0;
  802d85:	48 89 34 c5 00 00 00 	mov    %rsi,0x0(,%rax,8)
  802d8c:	00 
    argv[argc + 1] = NULL;
  802d8d:	8d 41 01             	lea    0x1(%rcx),%eax
  802d90:	48 98                	cltq
  802d92:	49 c7 04 c1 00 00 00 	movq   $0x0,(%r9,%rax,8)
  802d99:	00 
    va_start(vl, arg0);
  802d9a:	c7 45 b8 10 00 00 00 	movl   $0x10,-0x48(%rbp)
  802da1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802da5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802da9:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802dad:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    for (i = 0; i < argc; i++) {
  802db1:	85 c9                	test   %ecx,%ecx
  802db3:	74 41                	je     802df6 <spawnl+0x136>
        argv[i + 1] = va_arg(vl, const char *);
  802db5:	49 89 c0             	mov    %rax,%r8
  802db8:	49 8d 41 08          	lea    0x8(%r9),%rax
  802dbc:	8d 51 ff             	lea    -0x1(%rcx),%edx
  802dbf:	49 8d 74 d1 10       	lea    0x10(%r9,%rdx,8),%rsi
  802dc4:	eb 1b                	jmp    802de1 <spawnl+0x121>
  802dc6:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  802dca:	48 8d 51 08          	lea    0x8(%rcx),%rdx
  802dce:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802dd2:	48 8b 11             	mov    (%rcx),%rdx
  802dd5:	48 89 10             	mov    %rdx,(%rax)
    for (i = 0; i < argc; i++) {
  802dd8:	48 83 c0 08          	add    $0x8,%rax
  802ddc:	48 39 f0             	cmp    %rsi,%rax
  802ddf:	74 15                	je     802df6 <spawnl+0x136>
        argv[i + 1] = va_arg(vl, const char *);
  802de1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802de4:	83 fa 2f             	cmp    $0x2f,%edx
  802de7:	77 dd                	ja     802dc6 <spawnl+0x106>
  802de9:	89 d1                	mov    %edx,%ecx
  802deb:	4c 01 c1             	add    %r8,%rcx
  802dee:	83 c2 08             	add    $0x8,%edx
  802df1:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802df4:	eb dc                	jmp    802dd2 <spawnl+0x112>
    return spawn(prog, argv);
  802df6:	4c 89 ce             	mov    %r9,%rsi
  802df9:	48 b8 d3 25 80 00 00 	movabs $0x8025d3,%rax
  802e00:	00 00 00 
  802e03:	ff d0                	call   *%rax
}
  802e05:	c9                   	leave
  802e06:	c3                   	ret

0000000000802e07 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  802e07:	f3 0f 1e fa          	endbr64
  802e0b:	55                   	push   %rbp
  802e0c:	48 89 e5             	mov    %rsp,%rbp
  802e0f:	41 54                	push   %r12
  802e11:	53                   	push   %rbx
  802e12:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802e15:	48 b8 ea 1a 80 00 00 	movabs $0x801aea,%rax
  802e1c:	00 00 00 
  802e1f:	ff d0                	call   *%rax
  802e21:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  802e24:	48 be 5e 43 80 00 00 	movabs $0x80435e,%rsi
  802e2b:	00 00 00 
  802e2e:	48 89 df             	mov    %rbx,%rdi
  802e31:	48 b8 0b 11 80 00 00 	movabs $0x80110b,%rax
  802e38:	00 00 00 
  802e3b:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  802e3d:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  802e42:	41 2b 04 24          	sub    (%r12),%eax
  802e46:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  802e4c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  802e53:	00 00 00 
    stat->st_dev = &devpipe;
  802e56:	48 b8 00 68 80 00 00 	movabs $0x806800,%rax
  802e5d:	00 00 00 
  802e60:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  802e67:	b8 00 00 00 00       	mov    $0x0,%eax
  802e6c:	5b                   	pop    %rbx
  802e6d:	41 5c                	pop    %r12
  802e6f:	5d                   	pop    %rbp
  802e70:	c3                   	ret

0000000000802e71 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  802e71:	f3 0f 1e fa          	endbr64
  802e75:	55                   	push   %rbp
  802e76:	48 89 e5             	mov    %rsp,%rbp
  802e79:	41 54                	push   %r12
  802e7b:	53                   	push   %rbx
  802e7c:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  802e7f:	ba 00 10 00 00       	mov    $0x1000,%edx
  802e84:	48 89 fe             	mov    %rdi,%rsi
  802e87:	bf 00 00 00 00       	mov    $0x0,%edi
  802e8c:	49 bc 50 18 80 00 00 	movabs $0x801850,%r12
  802e93:	00 00 00 
  802e96:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  802e99:	48 89 df             	mov    %rbx,%rdi
  802e9c:	48 b8 ea 1a 80 00 00 	movabs $0x801aea,%rax
  802ea3:	00 00 00 
  802ea6:	ff d0                	call   *%rax
  802ea8:	48 89 c6             	mov    %rax,%rsi
  802eab:	ba 00 10 00 00       	mov    $0x1000,%edx
  802eb0:	bf 00 00 00 00       	mov    $0x0,%edi
  802eb5:	41 ff d4             	call   *%r12
}
  802eb8:	5b                   	pop    %rbx
  802eb9:	41 5c                	pop    %r12
  802ebb:	5d                   	pop    %rbp
  802ebc:	c3                   	ret

0000000000802ebd <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  802ebd:	f3 0f 1e fa          	endbr64
  802ec1:	55                   	push   %rbp
  802ec2:	48 89 e5             	mov    %rsp,%rbp
  802ec5:	41 57                	push   %r15
  802ec7:	41 56                	push   %r14
  802ec9:	41 55                	push   %r13
  802ecb:	41 54                	push   %r12
  802ecd:	53                   	push   %rbx
  802ece:	48 83 ec 18          	sub    $0x18,%rsp
  802ed2:	49 89 fc             	mov    %rdi,%r12
  802ed5:	49 89 f5             	mov    %rsi,%r13
  802ed8:	49 89 d7             	mov    %rdx,%r15
  802edb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802edf:	48 b8 ea 1a 80 00 00 	movabs $0x801aea,%rax
  802ee6:	00 00 00 
  802ee9:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  802eeb:	4d 85 ff             	test   %r15,%r15
  802eee:	0f 84 af 00 00 00    	je     802fa3 <devpipe_write+0xe6>
  802ef4:	48 89 c3             	mov    %rax,%rbx
  802ef7:	4c 89 f8             	mov    %r15,%rax
  802efa:	4d 89 ef             	mov    %r13,%r15
  802efd:	4c 01 e8             	add    %r13,%rax
  802f00:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802f04:	49 bd e0 16 80 00 00 	movabs $0x8016e0,%r13
  802f0b:	00 00 00 
            sys_yield();
  802f0e:	49 be 75 16 80 00 00 	movabs $0x801675,%r14
  802f15:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  802f18:	8b 73 04             	mov    0x4(%rbx),%esi
  802f1b:	48 63 ce             	movslq %esi,%rcx
  802f1e:	48 63 03             	movslq (%rbx),%rax
  802f21:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  802f27:	48 39 c1             	cmp    %rax,%rcx
  802f2a:	72 2e                	jb     802f5a <devpipe_write+0x9d>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802f2c:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802f31:	48 89 da             	mov    %rbx,%rdx
  802f34:	be 00 10 00 00       	mov    $0x1000,%esi
  802f39:	4c 89 e7             	mov    %r12,%rdi
  802f3c:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802f3f:	85 c0                	test   %eax,%eax
  802f41:	74 66                	je     802fa9 <devpipe_write+0xec>
            sys_yield();
  802f43:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  802f46:	8b 73 04             	mov    0x4(%rbx),%esi
  802f49:	48 63 ce             	movslq %esi,%rcx
  802f4c:	48 63 03             	movslq (%rbx),%rax
  802f4f:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  802f55:	48 39 c1             	cmp    %rax,%rcx
  802f58:	73 d2                	jae    802f2c <devpipe_write+0x6f>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802f5a:	41 0f b6 3f          	movzbl (%r15),%edi
  802f5e:	48 89 ca             	mov    %rcx,%rdx
  802f61:	48 c1 ea 03          	shr    $0x3,%rdx
  802f65:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  802f6c:	08 10 20 
  802f6f:	48 f7 e2             	mul    %rdx
  802f72:	48 c1 ea 06          	shr    $0x6,%rdx
  802f76:	48 89 d0             	mov    %rdx,%rax
  802f79:	48 c1 e0 09          	shl    $0x9,%rax
  802f7d:	48 29 d0             	sub    %rdx,%rax
  802f80:	48 c1 e0 03          	shl    $0x3,%rax
  802f84:	48 29 c1             	sub    %rax,%rcx
  802f87:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  802f8c:	83 c6 01             	add    $0x1,%esi
  802f8f:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  802f92:	49 83 c7 01          	add    $0x1,%r15
  802f96:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802f9a:	49 39 c7             	cmp    %rax,%r15
  802f9d:	0f 85 75 ff ff ff    	jne    802f18 <devpipe_write+0x5b>
    return n;
  802fa3:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802fa7:	eb 05                	jmp    802fae <devpipe_write+0xf1>
            if (_pipeisclosed(fd, p)) return 0;
  802fa9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802fae:	48 83 c4 18          	add    $0x18,%rsp
  802fb2:	5b                   	pop    %rbx
  802fb3:	41 5c                	pop    %r12
  802fb5:	41 5d                	pop    %r13
  802fb7:	41 5e                	pop    %r14
  802fb9:	41 5f                	pop    %r15
  802fbb:	5d                   	pop    %rbp
  802fbc:	c3                   	ret

0000000000802fbd <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  802fbd:	f3 0f 1e fa          	endbr64
  802fc1:	55                   	push   %rbp
  802fc2:	48 89 e5             	mov    %rsp,%rbp
  802fc5:	41 57                	push   %r15
  802fc7:	41 56                	push   %r14
  802fc9:	41 55                	push   %r13
  802fcb:	41 54                	push   %r12
  802fcd:	53                   	push   %rbx
  802fce:	48 83 ec 18          	sub    $0x18,%rsp
  802fd2:	49 89 fc             	mov    %rdi,%r12
  802fd5:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  802fd9:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802fdd:	48 b8 ea 1a 80 00 00 	movabs $0x801aea,%rax
  802fe4:	00 00 00 
  802fe7:	ff d0                	call   *%rax
  802fe9:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  802fec:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802ff2:	49 bd e0 16 80 00 00 	movabs $0x8016e0,%r13
  802ff9:	00 00 00 
            sys_yield();
  802ffc:	49 be 75 16 80 00 00 	movabs $0x801675,%r14
  803003:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  803006:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80300b:	74 7d                	je     80308a <devpipe_read+0xcd>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  80300d:	8b 03                	mov    (%rbx),%eax
  80300f:	3b 43 04             	cmp    0x4(%rbx),%eax
  803012:	75 26                	jne    80303a <devpipe_read+0x7d>
            if (i > 0) return i;
  803014:	4d 85 ff             	test   %r15,%r15
  803017:	75 77                	jne    803090 <devpipe_read+0xd3>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  803019:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80301e:	48 89 da             	mov    %rbx,%rdx
  803021:	be 00 10 00 00       	mov    $0x1000,%esi
  803026:	4c 89 e7             	mov    %r12,%rdi
  803029:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  80302c:	85 c0                	test   %eax,%eax
  80302e:	74 72                	je     8030a2 <devpipe_read+0xe5>
            sys_yield();
  803030:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  803033:	8b 03                	mov    (%rbx),%eax
  803035:	3b 43 04             	cmp    0x4(%rbx),%eax
  803038:	74 df                	je     803019 <devpipe_read+0x5c>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80303a:	48 63 c8             	movslq %eax,%rcx
  80303d:	48 89 ca             	mov    %rcx,%rdx
  803040:	48 c1 ea 03          	shr    $0x3,%rdx
  803044:	48 be 81 00 01 02 04 	movabs $0x2010080402010081,%rsi
  80304b:	08 10 20 
  80304e:	48 89 d0             	mov    %rdx,%rax
  803051:	48 f7 e6             	mul    %rsi
  803054:	48 c1 ea 06          	shr    $0x6,%rdx
  803058:	48 89 d0             	mov    %rdx,%rax
  80305b:	48 c1 e0 09          	shl    $0x9,%rax
  80305f:	48 29 d0             	sub    %rdx,%rax
  803062:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803069:	00 
  80306a:	48 89 c8             	mov    %rcx,%rax
  80306d:	48 29 d0             	sub    %rdx,%rax
  803070:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  803075:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  803079:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  80307d:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  803080:	49 83 c7 01          	add    $0x1,%r15
  803084:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  803088:	75 83                	jne    80300d <devpipe_read+0x50>
    return n;
  80308a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80308e:	eb 03                	jmp    803093 <devpipe_read+0xd6>
            if (i > 0) return i;
  803090:	4c 89 f8             	mov    %r15,%rax
}
  803093:	48 83 c4 18          	add    $0x18,%rsp
  803097:	5b                   	pop    %rbx
  803098:	41 5c                	pop    %r12
  80309a:	41 5d                	pop    %r13
  80309c:	41 5e                	pop    %r14
  80309e:	41 5f                	pop    %r15
  8030a0:	5d                   	pop    %rbp
  8030a1:	c3                   	ret
            if (_pipeisclosed(fd, p)) return 0;
  8030a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8030a7:	eb ea                	jmp    803093 <devpipe_read+0xd6>

00000000008030a9 <pipe>:
pipe(int pfd[2]) {
  8030a9:	f3 0f 1e fa          	endbr64
  8030ad:	55                   	push   %rbp
  8030ae:	48 89 e5             	mov    %rsp,%rbp
  8030b1:	41 55                	push   %r13
  8030b3:	41 54                	push   %r12
  8030b5:	53                   	push   %rbx
  8030b6:	48 83 ec 18          	sub    $0x18,%rsp
  8030ba:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  8030bd:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  8030c1:	48 b8 0a 1b 80 00 00 	movabs $0x801b0a,%rax
  8030c8:	00 00 00 
  8030cb:	ff d0                	call   *%rax
  8030cd:	89 c3                	mov    %eax,%ebx
  8030cf:	85 c0                	test   %eax,%eax
  8030d1:	0f 88 a0 01 00 00    	js     803277 <pipe+0x1ce>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  8030d7:	b9 46 00 00 00       	mov    $0x46,%ecx
  8030dc:	ba 00 10 00 00       	mov    $0x1000,%edx
  8030e1:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8030e5:	bf 00 00 00 00       	mov    $0x0,%edi
  8030ea:	48 b8 10 17 80 00 00 	movabs $0x801710,%rax
  8030f1:	00 00 00 
  8030f4:	ff d0                	call   *%rax
  8030f6:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  8030f8:	85 c0                	test   %eax,%eax
  8030fa:	0f 88 77 01 00 00    	js     803277 <pipe+0x1ce>
    if ((res = fd_alloc(&fd1)) < 0 ||
  803100:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  803104:	48 b8 0a 1b 80 00 00 	movabs $0x801b0a,%rax
  80310b:	00 00 00 
  80310e:	ff d0                	call   *%rax
  803110:	89 c3                	mov    %eax,%ebx
  803112:	85 c0                	test   %eax,%eax
  803114:	0f 88 43 01 00 00    	js     80325d <pipe+0x1b4>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  80311a:	b9 46 00 00 00       	mov    $0x46,%ecx
  80311f:	ba 00 10 00 00       	mov    $0x1000,%edx
  803124:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  803128:	bf 00 00 00 00       	mov    $0x0,%edi
  80312d:	48 b8 10 17 80 00 00 	movabs $0x801710,%rax
  803134:	00 00 00 
  803137:	ff d0                	call   *%rax
  803139:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  80313b:	85 c0                	test   %eax,%eax
  80313d:	0f 88 1a 01 00 00    	js     80325d <pipe+0x1b4>
    va = fd2data(fd0);
  803143:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  803147:	48 b8 ea 1a 80 00 00 	movabs $0x801aea,%rax
  80314e:	00 00 00 
  803151:	ff d0                	call   *%rax
  803153:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  803156:	b9 46 00 00 00       	mov    $0x46,%ecx
  80315b:	ba 00 10 00 00       	mov    $0x1000,%edx
  803160:	48 89 c6             	mov    %rax,%rsi
  803163:	bf 00 00 00 00       	mov    $0x0,%edi
  803168:	48 b8 10 17 80 00 00 	movabs $0x801710,%rax
  80316f:	00 00 00 
  803172:	ff d0                	call   *%rax
  803174:	89 c3                	mov    %eax,%ebx
  803176:	85 c0                	test   %eax,%eax
  803178:	0f 88 c5 00 00 00    	js     803243 <pipe+0x19a>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  80317e:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  803182:	48 b8 ea 1a 80 00 00 	movabs $0x801aea,%rax
  803189:	00 00 00 
  80318c:	ff d0                	call   *%rax
  80318e:	48 89 c1             	mov    %rax,%rcx
  803191:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  803197:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  80319d:	ba 00 00 00 00       	mov    $0x0,%edx
  8031a2:	4c 89 ee             	mov    %r13,%rsi
  8031a5:	bf 00 00 00 00       	mov    $0x0,%edi
  8031aa:	48 b8 7b 17 80 00 00 	movabs $0x80177b,%rax
  8031b1:	00 00 00 
  8031b4:	ff d0                	call   *%rax
  8031b6:	89 c3                	mov    %eax,%ebx
  8031b8:	85 c0                	test   %eax,%eax
  8031ba:	78 6e                	js     80322a <pipe+0x181>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8031bc:	be 00 10 00 00       	mov    $0x1000,%esi
  8031c1:	4c 89 ef             	mov    %r13,%rdi
  8031c4:	48 b8 aa 16 80 00 00 	movabs $0x8016aa,%rax
  8031cb:	00 00 00 
  8031ce:	ff d0                	call   *%rax
  8031d0:	83 f8 02             	cmp    $0x2,%eax
  8031d3:	0f 85 ab 00 00 00    	jne    803284 <pipe+0x1db>
    fd0->fd_dev_id = devpipe.dev_id;
  8031d9:	a1 00 68 80 00 00 00 	movabs 0x806800,%eax
  8031e0:	00 00 
  8031e2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8031e6:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  8031e8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8031ec:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  8031f3:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8031f7:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  8031f9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8031fd:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  803204:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  803208:	48 bb d4 1a 80 00 00 	movabs $0x801ad4,%rbx
  80320f:	00 00 00 
  803212:	ff d3                	call   *%rbx
  803214:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  803218:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  80321c:	ff d3                	call   *%rbx
  80321e:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  803223:	bb 00 00 00 00       	mov    $0x0,%ebx
  803228:	eb 4d                	jmp    803277 <pipe+0x1ce>
    sys_unmap_region(0, va, PAGE_SIZE);
  80322a:	ba 00 10 00 00       	mov    $0x1000,%edx
  80322f:	4c 89 ee             	mov    %r13,%rsi
  803232:	bf 00 00 00 00       	mov    $0x0,%edi
  803237:	48 b8 50 18 80 00 00 	movabs $0x801850,%rax
  80323e:	00 00 00 
  803241:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  803243:	ba 00 10 00 00       	mov    $0x1000,%edx
  803248:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80324c:	bf 00 00 00 00       	mov    $0x0,%edi
  803251:	48 b8 50 18 80 00 00 	movabs $0x801850,%rax
  803258:	00 00 00 
  80325b:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  80325d:	ba 00 10 00 00       	mov    $0x1000,%edx
  803262:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  803266:	bf 00 00 00 00       	mov    $0x0,%edi
  80326b:	48 b8 50 18 80 00 00 	movabs $0x801850,%rax
  803272:	00 00 00 
  803275:	ff d0                	call   *%rax
}
  803277:	89 d8                	mov    %ebx,%eax
  803279:	48 83 c4 18          	add    $0x18,%rsp
  80327d:	5b                   	pop    %rbx
  80327e:	41 5c                	pop    %r12
  803280:	41 5d                	pop    %r13
  803282:	5d                   	pop    %rbp
  803283:	c3                   	ret
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  803284:	48 b9 20 45 80 00 00 	movabs $0x804520,%rcx
  80328b:	00 00 00 
  80328e:	48 ba d0 42 80 00 00 	movabs $0x8042d0,%rdx
  803295:	00 00 00 
  803298:	be 2e 00 00 00       	mov    $0x2e,%esi
  80329d:	48 bf 65 43 80 00 00 	movabs $0x804365,%rdi
  8032a4:	00 00 00 
  8032a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8032ac:	49 b8 66 06 80 00 00 	movabs $0x800666,%r8
  8032b3:	00 00 00 
  8032b6:	41 ff d0             	call   *%r8

00000000008032b9 <pipeisclosed>:
pipeisclosed(int fdnum) {
  8032b9:	f3 0f 1e fa          	endbr64
  8032bd:	55                   	push   %rbp
  8032be:	48 89 e5             	mov    %rsp,%rbp
  8032c1:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8032c5:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8032c9:	48 b8 6e 1b 80 00 00 	movabs $0x801b6e,%rax
  8032d0:	00 00 00 
  8032d3:	ff d0                	call   *%rax
    if (res < 0) return res;
  8032d5:	85 c0                	test   %eax,%eax
  8032d7:	78 35                	js     80330e <pipeisclosed+0x55>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  8032d9:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8032dd:	48 b8 ea 1a 80 00 00 	movabs $0x801aea,%rax
  8032e4:	00 00 00 
  8032e7:	ff d0                	call   *%rax
  8032e9:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8032ec:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8032f1:	be 00 10 00 00       	mov    $0x1000,%esi
  8032f6:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8032fa:	48 b8 e0 16 80 00 00 	movabs $0x8016e0,%rax
  803301:	00 00 00 
  803304:	ff d0                	call   *%rax
  803306:	85 c0                	test   %eax,%eax
  803308:	0f 94 c0             	sete   %al
  80330b:	0f b6 c0             	movzbl %al,%eax
}
  80330e:	c9                   	leave
  80330f:	c3                   	ret

0000000000803310 <wait>:
#include <inc/lib.h>

/* Waits until 'envid' exits. */
void
wait(envid_t envid) {
  803310:	f3 0f 1e fa          	endbr64
  803314:	55                   	push   %rbp
  803315:	48 89 e5             	mov    %rsp,%rbp
  803318:	41 55                	push   %r13
  80331a:	41 54                	push   %r12
  80331c:	53                   	push   %rbx
  80331d:	48 83 ec 08          	sub    $0x8,%rsp
    assert(envid != 0);
  803321:	85 ff                	test   %edi,%edi
  803323:	74 7d                	je     8033a2 <wait+0x92>
  803325:	41 89 fc             	mov    %edi,%r12d

    const volatile struct Env *env = &envs[ENVX(envid)];
  803328:	89 f8                	mov    %edi,%eax
  80332a:	25 ff 03 00 00       	and    $0x3ff,%eax

    while (env->env_id == envid &&
  80332f:	89 fa                	mov    %edi,%edx
  803331:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  803337:	48 8d 0c d2          	lea    (%rdx,%rdx,8),%rcx
  80333b:	48 8d 0c 4a          	lea    (%rdx,%rcx,2),%rcx
  80333f:	48 c1 e1 04          	shl    $0x4,%rcx
  803343:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  80334a:	00 00 00 
  80334d:	48 01 ca             	add    %rcx,%rdx
  803350:	8b 92 c8 00 00 00    	mov    0xc8(%rdx),%edx
  803356:	39 d7                	cmp    %edx,%edi
  803358:	75 3d                	jne    803397 <wait+0x87>
           env->env_status != ENV_FREE) {
  80335a:	48 98                	cltq
  80335c:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  803360:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  803364:	48 c1 e0 04          	shl    $0x4,%rax
  803368:	48 bb 00 00 a0 1f 80 	movabs $0x801fa00000,%rbx
  80336f:	00 00 00 
  803372:	48 01 c3             	add    %rax,%rbx
        sys_yield();
  803375:	49 bd 75 16 80 00 00 	movabs $0x801675,%r13
  80337c:	00 00 00 
           env->env_status != ENV_FREE) {
  80337f:	8b 83 d4 00 00 00    	mov    0xd4(%rbx),%eax
    while (env->env_id == envid &&
  803385:	85 c0                	test   %eax,%eax
  803387:	74 0e                	je     803397 <wait+0x87>
        sys_yield();
  803389:	41 ff d5             	call   *%r13
    while (env->env_id == envid &&
  80338c:	8b 83 c8 00 00 00    	mov    0xc8(%rbx),%eax
  803392:	44 39 e0             	cmp    %r12d,%eax
  803395:	74 e8                	je     80337f <wait+0x6f>
    }
}
  803397:	48 83 c4 08          	add    $0x8,%rsp
  80339b:	5b                   	pop    %rbx
  80339c:	41 5c                	pop    %r12
  80339e:	41 5d                	pop    %r13
  8033a0:	5d                   	pop    %rbp
  8033a1:	c3                   	ret
    assert(envid != 0);
  8033a2:	48 b9 75 43 80 00 00 	movabs $0x804375,%rcx
  8033a9:	00 00 00 
  8033ac:	48 ba d0 42 80 00 00 	movabs $0x8042d0,%rdx
  8033b3:	00 00 00 
  8033b6:	be 06 00 00 00       	mov    $0x6,%esi
  8033bb:	48 bf 80 43 80 00 00 	movabs $0x804380,%rdi
  8033c2:	00 00 00 
  8033c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8033ca:	49 b8 66 06 80 00 00 	movabs $0x800666,%r8
  8033d1:	00 00 00 
  8033d4:	41 ff d0             	call   *%r8

00000000008033d7 <get_uvpt_entry>:
extern volatile pde_t uvpd[];     /* VA of current page directory */
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
  8033d7:	f3 0f 1e fa          	endbr64
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8033db:	48 89 f8             	mov    %rdi,%rax
  8033de:	48 c1 e8 27          	shr    $0x27,%rax
  8033e2:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  8033e9:	7f 00 00 
  8033ec:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8033f0:	f6 c2 01             	test   $0x1,%dl
  8033f3:	74 6d                	je     803462 <get_uvpt_entry+0x8b>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8033f5:	48 89 f8             	mov    %rdi,%rax
  8033f8:	48 c1 e8 1e          	shr    $0x1e,%rax
  8033fc:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  803403:	7f 00 00 
  803406:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80340a:	f6 c2 01             	test   $0x1,%dl
  80340d:	74 62                	je     803471 <get_uvpt_entry+0x9a>
  80340f:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  803416:	7f 00 00 
  803419:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80341d:	f6 c2 80             	test   $0x80,%dl
  803420:	75 4f                	jne    803471 <get_uvpt_entry+0x9a>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  803422:	48 89 f8             	mov    %rdi,%rax
  803425:	48 c1 e8 15          	shr    $0x15,%rax
  803429:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  803430:	7f 00 00 
  803433:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  803437:	f6 c2 01             	test   $0x1,%dl
  80343a:	74 44                	je     803480 <get_uvpt_entry+0xa9>
  80343c:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  803443:	7f 00 00 
  803446:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80344a:	f6 c2 80             	test   $0x80,%dl
  80344d:	75 31                	jne    803480 <get_uvpt_entry+0xa9>
    return uvpt[VPT(va)];
  80344f:	48 c1 ef 0c          	shr    $0xc,%rdi
  803453:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  80345a:	7f 00 00 
  80345d:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  803461:	c3                   	ret
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  803462:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  803469:	7f 00 00 
  80346c:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  803470:	c3                   	ret
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  803471:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  803478:	7f 00 00 
  80347b:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80347f:	c3                   	ret
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  803480:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  803487:	7f 00 00 
  80348a:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80348e:	c3                   	ret

000000000080348f <get_phys_addr>:

uintptr_t
get_phys_addr(void *va) {
  80348f:	f3 0f 1e fa          	endbr64
  803493:	48 89 fa             	mov    %rdi,%rdx
    if (!(uvpml4[VPML4(va)] & PTE_P))
  803496:	48 89 f9             	mov    %rdi,%rcx
  803499:	48 c1 e9 27          	shr    $0x27,%rcx
  80349d:	48 b8 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rax
  8034a4:	7f 00 00 
  8034a7:	48 8b 0c c8          	mov    (%rax,%rcx,8),%rcx
        return -1;
  8034ab:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpml4[VPML4(va)] & PTE_P))
  8034b2:	f6 c1 01             	test   $0x1,%cl
  8034b5:	0f 84 b2 00 00 00    	je     80356d <get_phys_addr+0xde>
    if (!(uvpdp[VPDP(va)] & PTE_P))
  8034bb:	48 89 f9             	mov    %rdi,%rcx
  8034be:	48 c1 e9 1e          	shr    $0x1e,%rcx
  8034c2:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  8034c9:	7f 00 00 
  8034cc:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  8034d0:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpdp[VPDP(va)] & PTE_P))
  8034d7:	40 f6 c6 01          	test   $0x1,%sil
  8034db:	0f 84 8c 00 00 00    	je     80356d <get_phys_addr+0xde>
    if (uvpdp[VPDP(va)] & PTE_PS)
  8034e1:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  8034e8:	7f 00 00 
  8034eb:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8034ef:	a8 80                	test   $0x80,%al
  8034f1:	75 7b                	jne    80356e <get_phys_addr+0xdf>
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
    if (!(uvpd[VPD(va)] & PTE_P))
  8034f3:	48 89 f9             	mov    %rdi,%rcx
  8034f6:	48 c1 e9 15          	shr    $0x15,%rcx
  8034fa:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  803501:	7f 00 00 
  803504:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  803508:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpd[VPD(va)] & PTE_P))
  80350f:	40 f6 c6 01          	test   $0x1,%sil
  803513:	74 58                	je     80356d <get_phys_addr+0xde>
    if ((uvpd[VPD(va)] & PTE_PS))
  803515:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  80351c:	7f 00 00 
  80351f:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  803523:	a8 80                	test   $0x80,%al
  803525:	75 6c                	jne    803593 <get_phys_addr+0x104>
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
    if (!(uvpt[VPT(va)] & PTE_P))
  803527:	48 89 f9             	mov    %rdi,%rcx
  80352a:	48 c1 e9 0c          	shr    $0xc,%rcx
  80352e:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  803535:	7f 00 00 
  803538:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  80353c:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpt[VPT(va)] & PTE_P))
  803543:	40 f6 c6 01          	test   $0x1,%sil
  803547:	74 24                	je     80356d <get_phys_addr+0xde>
    return PTE_ADDR(uvpt[VPT(va)]) + PAGE_OFFSET(va);
  803549:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  803550:	7f 00 00 
  803553:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  803557:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  80355e:	ff ff 7f 
  803561:	48 21 c8             	and    %rcx,%rax
  803564:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  80356a:	48 09 d0             	or     %rdx,%rax
}
  80356d:	c3                   	ret
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
  80356e:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  803575:	7f 00 00 
  803578:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  80357c:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  803583:	ff ff 7f 
  803586:	48 21 c8             	and    %rcx,%rax
  803589:	81 e2 ff ff ff 3f    	and    $0x3fffffff,%edx
  80358f:	48 01 d0             	add    %rdx,%rax
  803592:	c3                   	ret
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
  803593:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  80359a:	7f 00 00 
  80359d:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8035a1:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  8035a8:	ff ff 7f 
  8035ab:	48 21 c8             	and    %rcx,%rax
  8035ae:	81 e2 ff ff 1f 00    	and    $0x1fffff,%edx
  8035b4:	48 01 d0             	add    %rdx,%rax
  8035b7:	c3                   	ret

00000000008035b8 <get_prot>:

int
get_prot(void *va) {
  8035b8:	f3 0f 1e fa          	endbr64
  8035bc:	55                   	push   %rbp
  8035bd:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  8035c0:	48 b8 d7 33 80 00 00 	movabs $0x8033d7,%rax
  8035c7:	00 00 00 
  8035ca:	ff d0                	call   *%rax
  8035cc:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
    if (pte & PTE_P) prot |= PROT_R;
  8035cf:	83 e0 01             	and    $0x1,%eax
  8035d2:	c1 e0 02             	shl    $0x2,%eax
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  8035d5:	89 d1                	mov    %edx,%ecx
  8035d7:	81 e1 00 0a 00 00    	and    $0xa00,%ecx
    if (pte & PTE_P) prot |= PROT_R;
  8035dd:	09 c8                	or     %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  8035df:	89 c1                	mov    %eax,%ecx
  8035e1:	83 c9 02             	or     $0x2,%ecx
  8035e4:	f6 c2 02             	test   $0x2,%dl
  8035e7:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  8035ea:	89 c1                	mov    %eax,%ecx
  8035ec:	83 c9 01             	or     $0x1,%ecx
  8035ef:	48 85 d2             	test   %rdx,%rdx
  8035f2:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  8035f5:	89 c1                	mov    %eax,%ecx
  8035f7:	83 c9 40             	or     $0x40,%ecx
  8035fa:	f6 c6 04             	test   $0x4,%dh
  8035fd:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  803600:	5d                   	pop    %rbp
  803601:	c3                   	ret

0000000000803602 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  803602:	f3 0f 1e fa          	endbr64
  803606:	55                   	push   %rbp
  803607:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  80360a:	48 b8 d7 33 80 00 00 	movabs $0x8033d7,%rax
  803611:	00 00 00 
  803614:	ff d0                	call   *%rax
    return pte & PTE_D;
  803616:	48 c1 e8 06          	shr    $0x6,%rax
  80361a:	83 e0 01             	and    $0x1,%eax
}
  80361d:	5d                   	pop    %rbp
  80361e:	c3                   	ret

000000000080361f <is_page_present>:

bool
is_page_present(void *va) {
  80361f:	f3 0f 1e fa          	endbr64
  803623:	55                   	push   %rbp
  803624:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  803627:	48 b8 d7 33 80 00 00 	movabs $0x8033d7,%rax
  80362e:	00 00 00 
  803631:	ff d0                	call   *%rax
  803633:	83 e0 01             	and    $0x1,%eax
}
  803636:	5d                   	pop    %rbp
  803637:	c3                   	ret

0000000000803638 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  803638:	f3 0f 1e fa          	endbr64
  80363c:	55                   	push   %rbp
  80363d:	48 89 e5             	mov    %rsp,%rbp
  803640:	41 57                	push   %r15
  803642:	41 56                	push   %r14
  803644:	41 55                	push   %r13
  803646:	41 54                	push   %r12
  803648:	53                   	push   %rbx
  803649:	48 83 ec 18          	sub    $0x18,%rsp
  80364d:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  803651:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
     * NOTE: Skip over larger pages/page directories for efficiency */
    // LAB 11: Your code here:

    int res = 0;
    (void)fun, (void)arg;
    uintptr_t va = 0;
  803655:	bb 00 00 00 00       	mov    $0x0,%ebx
    while (va < USER_STACK_TOP) {
        size_t size = 0;
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  80365a:	49 be 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%r14
  803661:	7f 00 00 
            size = 1LL << PML4_SHIFT;
            goto next;
        }

        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  803664:	49 bd 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%r13
  80366b:	7f 00 00 
    while (va < USER_STACK_TOP) {
  80366e:	49 bf ff 6f ff ff 7f 	movabs $0x7fffff6fff,%r15
  803675:	00 00 00 
  803678:	eb 73                	jmp    8036ed <foreach_shared_region+0xb5>
            }

            goto next;
        }

        if (!(uvpd[VPD(va)] & PTE_P)) {
  80367a:	48 89 d8             	mov    %rbx,%rax
  80367d:	48 c1 e8 15          	shr    $0x15,%rax
  803681:	48 b9 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rcx
  803688:	7f 00 00 
  80368b:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
            size = 1LL << PD_SHIFT;
  80368f:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
        if (!(uvpd[VPD(va)] & PTE_P)) {
  803695:	f6 c2 01             	test   $0x1,%dl
  803698:	74 4b                	je     8036e5 <foreach_shared_region+0xad>
            goto next;
        }

        if (uvpd[VPD(va)] & PTE_PS) {
  80369a:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
  80369e:	f6 c2 80             	test   $0x80,%dl
  8036a1:	74 11                	je     8036b4 <foreach_shared_region+0x7c>
            size = 1LL << PD_SHIFT;
            if (uvpd[VPD(va)] & PTE_SHARE) {
  8036a3:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
  8036a7:	f6 c4 04             	test   $0x4,%ah
  8036aa:	74 39                	je     8036e5 <foreach_shared_region+0xad>
            size = 1LL << PD_SHIFT;
  8036ac:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
  8036b2:	eb 20                	jmp    8036d4 <foreach_shared_region+0x9c>

            goto next;
        }

        size = PAGE_SIZE;
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  8036b4:	48 89 da             	mov    %rbx,%rdx
  8036b7:	48 c1 ea 0c          	shr    $0xc,%rdx
  8036bb:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  8036c2:	7f 00 00 
  8036c5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
        size = PAGE_SIZE;
  8036c9:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  8036cf:	f6 c4 04             	test   $0x4,%ah
  8036d2:	74 11                	je     8036e5 <foreach_shared_region+0xad>
            goto next;
        }

    map:
        fun((void *)va, (void *)(va + size), arg);
  8036d4:	49 8d 34 1c          	lea    (%r12,%rbx,1),%rsi
  8036d8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8036dc:	48 89 df             	mov    %rbx,%rdi
  8036df:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8036e3:	ff d0                	call   *%rax
    next:
        va += size;
  8036e5:	4c 01 e3             	add    %r12,%rbx
    while (va < USER_STACK_TOP) {
  8036e8:	49 39 df             	cmp    %rbx,%r15
  8036eb:	72 3e                	jb     80372b <foreach_shared_region+0xf3>
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  8036ed:	49 8b 06             	mov    (%r14),%rax
  8036f0:	a8 01                	test   $0x1,%al
  8036f2:	74 37                	je     80372b <foreach_shared_region+0xf3>
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  8036f4:	48 89 d8             	mov    %rbx,%rax
  8036f7:	48 c1 e8 1e          	shr    $0x1e,%rax
  8036fb:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
            size = 1LL << PDP_SHIFT;
  803700:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  803706:	f6 c2 01             	test   $0x1,%dl
  803709:	74 da                	je     8036e5 <foreach_shared_region+0xad>
        if (uvpdp[VPDP(va)] & PTE_PS) {
  80370b:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
  803710:	f6 c2 80             	test   $0x80,%dl
  803713:	0f 84 61 ff ff ff    	je     80367a <foreach_shared_region+0x42>
            if (uvpdp[VPDP(va)] & PTE_SHARE) {
  803719:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  80371e:	f6 c4 04             	test   $0x4,%ah
  803721:	74 c2                	je     8036e5 <foreach_shared_region+0xad>
            size = 1LL << PDP_SHIFT;
  803723:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
  803729:	eb a9                	jmp    8036d4 <foreach_shared_region+0x9c>
    }
    return res;
}
  80372b:	b8 00 00 00 00       	mov    $0x0,%eax
  803730:	48 83 c4 18          	add    $0x18,%rsp
  803734:	5b                   	pop    %rbx
  803735:	41 5c                	pop    %r12
  803737:	41 5d                	pop    %r13
  803739:	41 5e                	pop    %r14
  80373b:	41 5f                	pop    %r15
  80373d:	5d                   	pop    %rbp
  80373e:	c3                   	ret

000000000080373f <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  80373f:	f3 0f 1e fa          	endbr64
  803743:	55                   	push   %rbp
  803744:	48 89 e5             	mov    %rsp,%rbp
  803747:	41 54                	push   %r12
  803749:	53                   	push   %rbx
  80374a:	48 89 fb             	mov    %rdi,%rbx
  80374d:	48 89 f7             	mov    %rsi,%rdi
  803750:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  803753:	48 85 f6             	test   %rsi,%rsi
  803756:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  80375d:	00 00 00 
  803760:	48 0f 44 f8          	cmove  %rax,%rdi
    }
    int res = sys_ipc_recv(pg, PAGE_SIZE);
  803764:	be 00 10 00 00       	mov    $0x1000,%esi
  803769:	48 b8 32 1a 80 00 00 	movabs $0x801a32,%rax
  803770:	00 00 00 
  803773:	ff d0                	call   *%rax
    if (res < 0) {
  803775:	85 c0                	test   %eax,%eax
  803777:	78 45                	js     8037be <ipc_recv+0x7f>
        if (perm_store != NULL) {
            *perm_store = 0;
        }
        return res;
    } else {
        if (from_env_store != NULL) {
  803779:	48 85 db             	test   %rbx,%rbx
  80377c:	74 12                	je     803790 <ipc_recv+0x51>
            *from_env_store = thisenv->env_ipc_from;
  80377e:	48 a1 70 87 80 00 00 	movabs 0x808770,%rax
  803785:	00 00 00 
  803788:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  80378e:	89 03                	mov    %eax,(%rbx)
        }
        if (perm_store != NULL) {
  803790:	4d 85 e4             	test   %r12,%r12
  803793:	74 14                	je     8037a9 <ipc_recv+0x6a>
            *perm_store = thisenv->env_ipc_perm;
  803795:	48 a1 70 87 80 00 00 	movabs 0x808770,%rax
  80379c:	00 00 00 
  80379f:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  8037a5:	41 89 04 24          	mov    %eax,(%r12)
        }
        return thisenv->env_ipc_value;
  8037a9:	48 a1 70 87 80 00 00 	movabs 0x808770,%rax
  8037b0:	00 00 00 
  8037b3:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
    }
    return -1;
}
  8037b9:	5b                   	pop    %rbx
  8037ba:	41 5c                	pop    %r12
  8037bc:	5d                   	pop    %rbp
  8037bd:	c3                   	ret
        if (from_env_store != NULL) {
  8037be:	48 85 db             	test   %rbx,%rbx
  8037c1:	74 06                	je     8037c9 <ipc_recv+0x8a>
            *from_env_store = 0;
  8037c3:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store != NULL) {
  8037c9:	4d 85 e4             	test   %r12,%r12
  8037cc:	74 eb                	je     8037b9 <ipc_recv+0x7a>
            *perm_store = 0;
  8037ce:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  8037d5:	00 
  8037d6:	eb e1                	jmp    8037b9 <ipc_recv+0x7a>

00000000008037d8 <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  8037d8:	f3 0f 1e fa          	endbr64
  8037dc:	55                   	push   %rbp
  8037dd:	48 89 e5             	mov    %rsp,%rbp
  8037e0:	41 57                	push   %r15
  8037e2:	41 56                	push   %r14
  8037e4:	41 55                	push   %r13
  8037e6:	41 54                	push   %r12
  8037e8:	53                   	push   %rbx
  8037e9:	48 83 ec 18          	sub    $0x18,%rsp
  8037ed:	89 7d c4             	mov    %edi,-0x3c(%rbp)
  8037f0:	48 89 d3             	mov    %rdx,%rbx
  8037f3:	49 89 cc             	mov    %rcx,%r12
  8037f6:	45 89 c5             	mov    %r8d,%r13d
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  8037f9:	48 85 d2             	test   %rdx,%rdx
  8037fc:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  803803:	00 00 00 
  803806:	48 0f 44 d8          	cmove  %rax,%rbx
    }
    int res = sys_ipc_try_send(to_env, val, pg, size, perm);
  80380a:	89 f0                	mov    %esi,%eax
  80380c:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  803810:	48 89 da             	mov    %rbx,%rdx
  803813:	48 89 c6             	mov    %rax,%rsi
  803816:	48 b8 02 1a 80 00 00 	movabs $0x801a02,%rax
  80381d:	00 00 00 
  803820:	ff d0                	call   *%rax
    while (res < 0) {
  803822:	85 c0                	test   %eax,%eax
  803824:	79 65                	jns    80388b <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  803826:	83 f8 f5             	cmp    $0xfffffff5,%eax
  803829:	75 33                	jne    80385e <ipc_send+0x86>
            panic("Error: %i\n", res);
        }
        sys_yield();
  80382b:	49 bf 75 16 80 00 00 	movabs $0x801675,%r15
  803832:	00 00 00 
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  803835:	49 be 02 1a 80 00 00 	movabs $0x801a02,%r14
  80383c:	00 00 00 
        sys_yield();
  80383f:	41 ff d7             	call   *%r15
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  803842:	45 89 e8             	mov    %r13d,%r8d
  803845:	4c 89 e1             	mov    %r12,%rcx
  803848:	48 89 da             	mov    %rbx,%rdx
  80384b:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  80384f:	8b 7d c4             	mov    -0x3c(%rbp),%edi
  803852:	41 ff d6             	call   *%r14
    while (res < 0) {
  803855:	85 c0                	test   %eax,%eax
  803857:	79 32                	jns    80388b <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  803859:	83 f8 f5             	cmp    $0xfffffff5,%eax
  80385c:	74 e1                	je     80383f <ipc_send+0x67>
            panic("Error: %i\n", res);
  80385e:	89 c1                	mov    %eax,%ecx
  803860:	48 ba 8b 43 80 00 00 	movabs $0x80438b,%rdx
  803867:	00 00 00 
  80386a:	be 42 00 00 00       	mov    $0x42,%esi
  80386f:	48 bf 96 43 80 00 00 	movabs $0x804396,%rdi
  803876:	00 00 00 
  803879:	b8 00 00 00 00       	mov    $0x0,%eax
  80387e:	49 b8 66 06 80 00 00 	movabs $0x800666,%r8
  803885:	00 00 00 
  803888:	41 ff d0             	call   *%r8
    }
}
  80388b:	48 83 c4 18          	add    $0x18,%rsp
  80388f:	5b                   	pop    %rbx
  803890:	41 5c                	pop    %r12
  803892:	41 5d                	pop    %r13
  803894:	41 5e                	pop    %r14
  803896:	41 5f                	pop    %r15
  803898:	5d                   	pop    %rbp
  803899:	c3                   	ret

000000000080389a <ipc_find_env>:

/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
  80389a:	f3 0f 1e fa          	endbr64
    for (size_t i = 0; i < NENV; i++)
  80389e:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  8038a3:	48 b9 00 00 a0 1f 80 	movabs $0x801fa00000,%rcx
  8038aa:	00 00 00 
  8038ad:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8038b1:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  8038b5:	48 c1 e2 04          	shl    $0x4,%rdx
  8038b9:	48 01 ca             	add    %rcx,%rdx
  8038bc:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  8038c2:	39 fa                	cmp    %edi,%edx
  8038c4:	74 12                	je     8038d8 <ipc_find_env+0x3e>
    for (size_t i = 0; i < NENV; i++)
  8038c6:	48 83 c0 01          	add    $0x1,%rax
  8038ca:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  8038d0:	75 db                	jne    8038ad <ipc_find_env+0x13>
            return envs[i].env_id;
    return 0;
  8038d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8038d7:	c3                   	ret
            return envs[i].env_id;
  8038d8:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8038dc:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  8038e0:	48 c1 e2 04          	shl    $0x4,%rdx
  8038e4:	48 b8 00 00 a0 1f 80 	movabs $0x801fa00000,%rax
  8038eb:	00 00 00 
  8038ee:	48 01 d0             	add    %rdx,%rax
  8038f1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8038f7:	c3                   	ret

00000000008038f8 <__text_end>:
  8038f8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038ff:	00 00 00 
  803902:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803909:	00 00 00 
  80390c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803913:	00 00 00 
  803916:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80391d:	00 00 00 
  803920:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803927:	00 00 00 
  80392a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803931:	00 00 00 
  803934:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80393b:	00 00 00 
  80393e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803945:	00 00 00 
  803948:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80394f:	00 00 00 
  803952:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803959:	00 00 00 
  80395c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803963:	00 00 00 
  803966:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80396d:	00 00 00 
  803970:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803977:	00 00 00 
  80397a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803981:	00 00 00 
  803984:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80398b:	00 00 00 
  80398e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803995:	00 00 00 
  803998:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80399f:	00 00 00 
  8039a2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039a9:	00 00 00 
  8039ac:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039b3:	00 00 00 
  8039b6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039bd:	00 00 00 
  8039c0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039c7:	00 00 00 
  8039ca:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039d1:	00 00 00 
  8039d4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039db:	00 00 00 
  8039de:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039e5:	00 00 00 
  8039e8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039ef:	00 00 00 
  8039f2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039f9:	00 00 00 
  8039fc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a03:	00 00 00 
  803a06:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a0d:	00 00 00 
  803a10:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a17:	00 00 00 
  803a1a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a21:	00 00 00 
  803a24:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a2b:	00 00 00 
  803a2e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a35:	00 00 00 
  803a38:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a3f:	00 00 00 
  803a42:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a49:	00 00 00 
  803a4c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a53:	00 00 00 
  803a56:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a5d:	00 00 00 
  803a60:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a67:	00 00 00 
  803a6a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a71:	00 00 00 
  803a74:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a7b:	00 00 00 
  803a7e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a85:	00 00 00 
  803a88:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a8f:	00 00 00 
  803a92:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a99:	00 00 00 
  803a9c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803aa3:	00 00 00 
  803aa6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803aad:	00 00 00 
  803ab0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ab7:	00 00 00 
  803aba:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ac1:	00 00 00 
  803ac4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803acb:	00 00 00 
  803ace:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ad5:	00 00 00 
  803ad8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803adf:	00 00 00 
  803ae2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ae9:	00 00 00 
  803aec:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803af3:	00 00 00 
  803af6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803afd:	00 00 00 
  803b00:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b07:	00 00 00 
  803b0a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b11:	00 00 00 
  803b14:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b1b:	00 00 00 
  803b1e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b25:	00 00 00 
  803b28:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b2f:	00 00 00 
  803b32:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b39:	00 00 00 
  803b3c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b43:	00 00 00 
  803b46:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b4d:	00 00 00 
  803b50:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b57:	00 00 00 
  803b5a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b61:	00 00 00 
  803b64:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b6b:	00 00 00 
  803b6e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b75:	00 00 00 
  803b78:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b7f:	00 00 00 
  803b82:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b89:	00 00 00 
  803b8c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b93:	00 00 00 
  803b96:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b9d:	00 00 00 
  803ba0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ba7:	00 00 00 
  803baa:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bb1:	00 00 00 
  803bb4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bbb:	00 00 00 
  803bbe:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bc5:	00 00 00 
  803bc8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bcf:	00 00 00 
  803bd2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bd9:	00 00 00 
  803bdc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803be3:	00 00 00 
  803be6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bed:	00 00 00 
  803bf0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bf7:	00 00 00 
  803bfa:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c01:	00 00 00 
  803c04:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c0b:	00 00 00 
  803c0e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c15:	00 00 00 
  803c18:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c1f:	00 00 00 
  803c22:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c29:	00 00 00 
  803c2c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c33:	00 00 00 
  803c36:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c3d:	00 00 00 
  803c40:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c47:	00 00 00 
  803c4a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c51:	00 00 00 
  803c54:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c5b:	00 00 00 
  803c5e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c65:	00 00 00 
  803c68:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c6f:	00 00 00 
  803c72:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c79:	00 00 00 
  803c7c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c83:	00 00 00 
  803c86:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c8d:	00 00 00 
  803c90:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c97:	00 00 00 
  803c9a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ca1:	00 00 00 
  803ca4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cab:	00 00 00 
  803cae:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cb5:	00 00 00 
  803cb8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cbf:	00 00 00 
  803cc2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cc9:	00 00 00 
  803ccc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cd3:	00 00 00 
  803cd6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cdd:	00 00 00 
  803ce0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ce7:	00 00 00 
  803cea:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cf1:	00 00 00 
  803cf4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cfb:	00 00 00 
  803cfe:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d05:	00 00 00 
  803d08:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d0f:	00 00 00 
  803d12:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d19:	00 00 00 
  803d1c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d23:	00 00 00 
  803d26:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d2d:	00 00 00 
  803d30:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d37:	00 00 00 
  803d3a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d41:	00 00 00 
  803d44:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d4b:	00 00 00 
  803d4e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d55:	00 00 00 
  803d58:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d5f:	00 00 00 
  803d62:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d69:	00 00 00 
  803d6c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d73:	00 00 00 
  803d76:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d7d:	00 00 00 
  803d80:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d87:	00 00 00 
  803d8a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d91:	00 00 00 
  803d94:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d9b:	00 00 00 
  803d9e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803da5:	00 00 00 
  803da8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803daf:	00 00 00 
  803db2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803db9:	00 00 00 
  803dbc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dc3:	00 00 00 
  803dc6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dcd:	00 00 00 
  803dd0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dd7:	00 00 00 
  803dda:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803de1:	00 00 00 
  803de4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803deb:	00 00 00 
  803dee:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803df5:	00 00 00 
  803df8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dff:	00 00 00 
  803e02:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e09:	00 00 00 
  803e0c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e13:	00 00 00 
  803e16:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e1d:	00 00 00 
  803e20:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e27:	00 00 00 
  803e2a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e31:	00 00 00 
  803e34:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e3b:	00 00 00 
  803e3e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e45:	00 00 00 
  803e48:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e4f:	00 00 00 
  803e52:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e59:	00 00 00 
  803e5c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e63:	00 00 00 
  803e66:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e6d:	00 00 00 
  803e70:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e77:	00 00 00 
  803e7a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e81:	00 00 00 
  803e84:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e8b:	00 00 00 
  803e8e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e95:	00 00 00 
  803e98:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e9f:	00 00 00 
  803ea2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ea9:	00 00 00 
  803eac:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803eb3:	00 00 00 
  803eb6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ebd:	00 00 00 
  803ec0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ec7:	00 00 00 
  803eca:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ed1:	00 00 00 
  803ed4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803edb:	00 00 00 
  803ede:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ee5:	00 00 00 
  803ee8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803eef:	00 00 00 
  803ef2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ef9:	00 00 00 
  803efc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f03:	00 00 00 
  803f06:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f0d:	00 00 00 
  803f10:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f17:	00 00 00 
  803f1a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f21:	00 00 00 
  803f24:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f2b:	00 00 00 
  803f2e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f35:	00 00 00 
  803f38:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f3f:	00 00 00 
  803f42:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f49:	00 00 00 
  803f4c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f53:	00 00 00 
  803f56:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f5d:	00 00 00 
  803f60:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f67:	00 00 00 
  803f6a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f71:	00 00 00 
  803f74:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f7b:	00 00 00 
  803f7e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f85:	00 00 00 
  803f88:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f8f:	00 00 00 
  803f92:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f99:	00 00 00 
  803f9c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fa3:	00 00 00 
  803fa6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fad:	00 00 00 
  803fb0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fb7:	00 00 00 
  803fba:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fc1:	00 00 00 
  803fc4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fcb:	00 00 00 
  803fce:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fd5:	00 00 00 
  803fd8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fdf:	00 00 00 
  803fe2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fe9:	00 00 00 
  803fec:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ff3:	00 00 00 
  803ff6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ffd:	00 00 00 
