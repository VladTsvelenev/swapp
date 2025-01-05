
obj/user/testkbd:     file format elf64-x86-64


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
  80001e:	e8 95 03 00 00       	call   8003b8 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <umain>:

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
  800034:	bb 0a 00 00 00       	mov    $0xa,%ebx
    int r;

    /* Spin for a bit to let the console quiet */
    for (int i = 0; i < 10; ++i)
        sys_yield();
  800039:	49 bc ee 15 80 00 00 	movabs $0x8015ee,%r12
  800040:	00 00 00 
  800043:	41 ff d4             	call   *%r12
    for (int i = 0; i < 10; ++i)
  800046:	83 eb 01             	sub    $0x1,%ebx
  800049:	75 f8                	jne    800043 <umain+0x1e>

    close(0);
  80004b:	bf 00 00 00 00       	mov    $0x0,%edi
  800050:	48 b8 58 1c 80 00 00 	movabs $0x801c58,%rax
  800057:	00 00 00 
  80005a:	ff d0                	call   *%rax
    if ((r = opencons()) < 0)
  80005c:	48 b8 4d 03 80 00 00 	movabs $0x80034d,%rax
  800063:	00 00 00 
  800066:	ff d0                	call   *%rax
  800068:	85 c0                	test   %eax,%eax
  80006a:	78 2f                	js     80009b <umain+0x76>
        panic("opencons: %i", r);
    if (r != 0)
  80006c:	74 5a                	je     8000c8 <umain+0xa3>
        panic("first opencons used fd %d", r);
  80006e:	89 c1                	mov    %eax,%ecx
  800070:	48 ba 1c 40 80 00 00 	movabs $0x80401c,%rdx
  800077:	00 00 00 
  80007a:	be 10 00 00 00       	mov    $0x10,%esi
  80007f:	48 bf 0d 40 80 00 00 	movabs $0x80400d,%rdi
  800086:	00 00 00 
  800089:	b8 00 00 00 00       	mov    $0x0,%eax
  80008e:	49 b8 91 04 80 00 00 	movabs $0x800491,%r8
  800095:	00 00 00 
  800098:	41 ff d0             	call   *%r8
        panic("opencons: %i", r);
  80009b:	89 c1                	mov    %eax,%ecx
  80009d:	48 ba 00 40 80 00 00 	movabs $0x804000,%rdx
  8000a4:	00 00 00 
  8000a7:	be 0e 00 00 00       	mov    $0xe,%esi
  8000ac:	48 bf 0d 40 80 00 00 	movabs $0x80400d,%rdi
  8000b3:	00 00 00 
  8000b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8000bb:	49 b8 91 04 80 00 00 	movabs $0x800491,%r8
  8000c2:	00 00 00 
  8000c5:	41 ff d0             	call   *%r8
    if ((r = dup(0, 1)) < 0)
  8000c8:	be 01 00 00 00       	mov    $0x1,%esi
  8000cd:	bf 00 00 00 00       	mov    $0x0,%edi
  8000d2:	48 b8 bb 1c 80 00 00 	movabs $0x801cbb,%rax
  8000d9:	00 00 00 
  8000dc:	ff d0                	call   *%rax
        panic("dup: %i", r);

    for (;;) {
        char *buf;

        buf = readline("Type a line: ");
  8000de:	49 bc 3e 40 80 00 00 	movabs $0x80403e,%r12
  8000e5:	00 00 00 
  8000e8:	48 bb 96 13 80 00 00 	movabs $0x801396,%rbx
  8000ef:	00 00 00 
        if (buf != NULL)
            fprintf(1, "%s\n", buf);
        else
            fprintf(1, "(end of file received)\n");
  8000f2:	49 be 50 40 80 00 00 	movabs $0x804050,%r14
  8000f9:	00 00 00 
  8000fc:	49 bd 1a 26 80 00 00 	movabs $0x80261a,%r13
  800103:	00 00 00 
    if ((r = dup(0, 1)) < 0)
  800106:	85 c0                	test   %eax,%eax
  800108:	79 44                	jns    80014e <umain+0x129>
        panic("dup: %i", r);
  80010a:	89 c1                	mov    %eax,%ecx
  80010c:	48 ba 36 40 80 00 00 	movabs $0x804036,%rdx
  800113:	00 00 00 
  800116:	be 12 00 00 00       	mov    $0x12,%esi
  80011b:	48 bf 0d 40 80 00 00 	movabs $0x80400d,%rdi
  800122:	00 00 00 
  800125:	b8 00 00 00 00       	mov    $0x0,%eax
  80012a:	49 b8 91 04 80 00 00 	movabs $0x800491,%r8
  800131:	00 00 00 
  800134:	41 ff d0             	call   *%r8
            fprintf(1, "%s\n", buf);
  800137:	48 be 4c 40 80 00 00 	movabs $0x80404c,%rsi
  80013e:	00 00 00 
  800141:	bf 01 00 00 00       	mov    $0x1,%edi
  800146:	b8 00 00 00 00       	mov    $0x0,%eax
  80014b:	41 ff d5             	call   *%r13
        buf = readline("Type a line: ");
  80014e:	4c 89 e7             	mov    %r12,%rdi
  800151:	ff d3                	call   *%rbx
  800153:	48 89 c2             	mov    %rax,%rdx
        if (buf != NULL)
  800156:	48 85 c0             	test   %rax,%rax
  800159:	75 dc                	jne    800137 <umain+0x112>
            fprintf(1, "(end of file received)\n");
  80015b:	4c 89 f6             	mov    %r14,%rsi
  80015e:	bf 01 00 00 00       	mov    $0x1,%edi
  800163:	b8 00 00 00 00       	mov    $0x0,%eax
  800168:	41 ff d5             	call   *%r13
  80016b:	eb e1                	jmp    80014e <umain+0x129>

000000000080016d <devcons_close>:

    return res;
}

static int
devcons_close(struct Fd *fd) {
  80016d:	f3 0f 1e fa          	endbr64
    USED(fd);

    return 0;
}
  800171:	b8 00 00 00 00       	mov    $0x0,%eax
  800176:	c3                   	ret

0000000000800177 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  800177:	f3 0f 1e fa          	endbr64
  80017b:	55                   	push   %rbp
  80017c:	48 89 e5             	mov    %rsp,%rbp
  80017f:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  800182:	48 be 68 40 80 00 00 	movabs $0x804068,%rsi
  800189:	00 00 00 
  80018c:	48 b8 36 0f 80 00 00 	movabs $0x800f36,%rax
  800193:	00 00 00 
  800196:	ff d0                	call   *%rax
    return 0;
}
  800198:	b8 00 00 00 00       	mov    $0x0,%eax
  80019d:	5d                   	pop    %rbp
  80019e:	c3                   	ret

000000000080019f <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  80019f:	f3 0f 1e fa          	endbr64
  8001a3:	55                   	push   %rbp
  8001a4:	48 89 e5             	mov    %rsp,%rbp
  8001a7:	41 57                	push   %r15
  8001a9:	41 56                	push   %r14
  8001ab:	41 55                	push   %r13
  8001ad:	41 54                	push   %r12
  8001af:	53                   	push   %rbx
  8001b0:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  8001b7:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  8001be:	48 85 d2             	test   %rdx,%rdx
  8001c1:	74 7a                	je     80023d <devcons_write+0x9e>
  8001c3:	49 89 d6             	mov    %rdx,%r14
  8001c6:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  8001cc:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  8001d1:	49 bf 51 11 80 00 00 	movabs $0x801151,%r15
  8001d8:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  8001db:	4c 89 f3             	mov    %r14,%rbx
  8001de:	48 29 f3             	sub    %rsi,%rbx
  8001e1:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8001e6:	48 39 c3             	cmp    %rax,%rbx
  8001e9:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  8001ed:	4c 63 eb             	movslq %ebx,%r13
  8001f0:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  8001f7:	48 01 c6             	add    %rax,%rsi
  8001fa:	4c 89 ea             	mov    %r13,%rdx
  8001fd:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  800204:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  800207:	4c 89 ee             	mov    %r13,%rsi
  80020a:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  800211:	48 b8 e4 14 80 00 00 	movabs $0x8014e4,%rax
  800218:	00 00 00 
  80021b:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  80021d:	41 01 dc             	add    %ebx,%r12d
  800220:	49 63 f4             	movslq %r12d,%rsi
  800223:	4c 39 f6             	cmp    %r14,%rsi
  800226:	72 b3                	jb     8001db <devcons_write+0x3c>
    return res;
  800228:	49 63 c4             	movslq %r12d,%rax
}
  80022b:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  800232:	5b                   	pop    %rbx
  800233:	41 5c                	pop    %r12
  800235:	41 5d                	pop    %r13
  800237:	41 5e                	pop    %r14
  800239:	41 5f                	pop    %r15
  80023b:	5d                   	pop    %rbp
  80023c:	c3                   	ret
    for (res = 0; res < n; res += inc) {
  80023d:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  800243:	eb e3                	jmp    800228 <devcons_write+0x89>

0000000000800245 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  800245:	f3 0f 1e fa          	endbr64
  800249:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  80024c:	ba 00 00 00 00       	mov    $0x0,%edx
  800251:	48 85 c0             	test   %rax,%rax
  800254:	74 55                	je     8002ab <devcons_read+0x66>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  800256:	55                   	push   %rbp
  800257:	48 89 e5             	mov    %rsp,%rbp
  80025a:	41 55                	push   %r13
  80025c:	41 54                	push   %r12
  80025e:	53                   	push   %rbx
  80025f:	48 83 ec 08          	sub    $0x8,%rsp
  800263:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  800266:	48 bb 15 15 80 00 00 	movabs $0x801515,%rbx
  80026d:	00 00 00 
  800270:	49 bc ee 15 80 00 00 	movabs $0x8015ee,%r12
  800277:	00 00 00 
  80027a:	eb 03                	jmp    80027f <devcons_read+0x3a>
  80027c:	41 ff d4             	call   *%r12
  80027f:	ff d3                	call   *%rbx
  800281:	85 c0                	test   %eax,%eax
  800283:	74 f7                	je     80027c <devcons_read+0x37>
    if (c < 0) return c;
  800285:	48 63 d0             	movslq %eax,%rdx
  800288:	78 13                	js     80029d <devcons_read+0x58>
    if (c == 0x04) return 0;
  80028a:	ba 00 00 00 00       	mov    $0x0,%edx
  80028f:	83 f8 04             	cmp    $0x4,%eax
  800292:	74 09                	je     80029d <devcons_read+0x58>
    *(char *)vbuf = (char)c;
  800294:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  800298:	ba 01 00 00 00       	mov    $0x1,%edx
}
  80029d:	48 89 d0             	mov    %rdx,%rax
  8002a0:	48 83 c4 08          	add    $0x8,%rsp
  8002a4:	5b                   	pop    %rbx
  8002a5:	41 5c                	pop    %r12
  8002a7:	41 5d                	pop    %r13
  8002a9:	5d                   	pop    %rbp
  8002aa:	c3                   	ret
  8002ab:	48 89 d0             	mov    %rdx,%rax
  8002ae:	c3                   	ret

00000000008002af <cputchar>:
cputchar(int ch) {
  8002af:	f3 0f 1e fa          	endbr64
  8002b3:	55                   	push   %rbp
  8002b4:	48 89 e5             	mov    %rsp,%rbp
  8002b7:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  8002bb:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  8002bf:	be 01 00 00 00       	mov    $0x1,%esi
  8002c4:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  8002c8:	48 b8 e4 14 80 00 00 	movabs $0x8014e4,%rax
  8002cf:	00 00 00 
  8002d2:	ff d0                	call   *%rax
}
  8002d4:	c9                   	leave
  8002d5:	c3                   	ret

00000000008002d6 <getchar>:
getchar(void) {
  8002d6:	f3 0f 1e fa          	endbr64
  8002da:	55                   	push   %rbp
  8002db:	48 89 e5             	mov    %rsp,%rbp
  8002de:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  8002e2:	ba 01 00 00 00       	mov    $0x1,%edx
  8002e7:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  8002eb:	bf 00 00 00 00       	mov    $0x0,%edi
  8002f0:	48 b8 e2 1d 80 00 00 	movabs $0x801de2,%rax
  8002f7:	00 00 00 
  8002fa:	ff d0                	call   *%rax
  8002fc:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  8002fe:	85 c0                	test   %eax,%eax
  800300:	78 06                	js     800308 <getchar+0x32>
  800302:	74 08                	je     80030c <getchar+0x36>
  800304:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  800308:	89 d0                	mov    %edx,%eax
  80030a:	c9                   	leave
  80030b:	c3                   	ret
    return res < 0 ? res : res ? c :
  80030c:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  800311:	eb f5                	jmp    800308 <getchar+0x32>

0000000000800313 <iscons>:
iscons(int fdnum) {
  800313:	f3 0f 1e fa          	endbr64
  800317:	55                   	push   %rbp
  800318:	48 89 e5             	mov    %rsp,%rbp
  80031b:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  80031f:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  800323:	48 b8 e7 1a 80 00 00 	movabs $0x801ae7,%rax
  80032a:	00 00 00 
  80032d:	ff d0                	call   *%rax
    if (res < 0) return res;
  80032f:	85 c0                	test   %eax,%eax
  800331:	78 18                	js     80034b <iscons+0x38>
    return fd->fd_dev_id == devcons.dev_id;
  800333:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800337:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  80033e:	00 00 00 
  800341:	8b 00                	mov    (%rax),%eax
  800343:	39 02                	cmp    %eax,(%rdx)
  800345:	0f 94 c0             	sete   %al
  800348:	0f b6 c0             	movzbl %al,%eax
}
  80034b:	c9                   	leave
  80034c:	c3                   	ret

000000000080034d <opencons>:
opencons(void) {
  80034d:	f3 0f 1e fa          	endbr64
  800351:	55                   	push   %rbp
  800352:	48 89 e5             	mov    %rsp,%rbp
  800355:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  800359:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  80035d:	48 b8 83 1a 80 00 00 	movabs $0x801a83,%rax
  800364:	00 00 00 
  800367:	ff d0                	call   *%rax
  800369:	85 c0                	test   %eax,%eax
  80036b:	78 49                	js     8003b6 <opencons+0x69>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  80036d:	b9 46 00 00 00       	mov    $0x46,%ecx
  800372:	ba 00 10 00 00       	mov    $0x1000,%edx
  800377:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  80037b:	bf 00 00 00 00       	mov    $0x0,%edi
  800380:	48 b8 89 16 80 00 00 	movabs $0x801689,%rax
  800387:	00 00 00 
  80038a:	ff d0                	call   *%rax
  80038c:	85 c0                	test   %eax,%eax
  80038e:	78 26                	js     8003b6 <opencons+0x69>
    fd->fd_dev_id = devcons.dev_id;
  800390:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800394:	a1 00 50 80 00 00 00 	movabs 0x805000,%eax
  80039b:	00 00 
  80039d:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  80039f:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8003a3:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  8003aa:	48 b8 4d 1a 80 00 00 	movabs $0x801a4d,%rax
  8003b1:	00 00 00 
  8003b4:	ff d0                	call   *%rax
}
  8003b6:	c9                   	leave
  8003b7:	c3                   	ret

00000000008003b8 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  8003b8:	f3 0f 1e fa          	endbr64
  8003bc:	55                   	push   %rbp
  8003bd:	48 89 e5             	mov    %rsp,%rbp
  8003c0:	41 56                	push   %r14
  8003c2:	41 55                	push   %r13
  8003c4:	41 54                	push   %r12
  8003c6:	53                   	push   %rbx
  8003c7:	41 89 fd             	mov    %edi,%r13d
  8003ca:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
     * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  8003cd:	48 ba b8 50 80 00 00 	movabs $0x8050b8,%rdx
  8003d4:	00 00 00 
  8003d7:	48 b8 b8 50 80 00 00 	movabs $0x8050b8,%rax
  8003de:	00 00 00 
  8003e1:	48 39 c2             	cmp    %rax,%rdx
  8003e4:	73 17                	jae    8003fd <libmain+0x45>
    void (**ctor)() = &__ctors_start;
  8003e6:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  8003e9:	49 89 c4             	mov    %rax,%r12
  8003ec:	48 83 c3 08          	add    $0x8,%rbx
  8003f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8003f5:	ff 53 f8             	call   *-0x8(%rbx)
  8003f8:	4c 39 e3             	cmp    %r12,%rbx
  8003fb:	72 ef                	jb     8003ec <libmain+0x34>

    /* Set thisenv to point at our Env structure in envs[]. */

    // LAB 8: Your code here
    thisenv = &((struct Env *)UENVS)[ENVX(sys_getenvid())];
  8003fd:	48 b8 b9 15 80 00 00 	movabs $0x8015b9,%rax
  800404:	00 00 00 
  800407:	ff d0                	call   *%rax
  800409:	25 ff 03 00 00       	and    $0x3ff,%eax
  80040e:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  800412:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  800416:	48 c1 e0 04          	shl    $0x4,%rax
  80041a:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  800421:	00 00 00 
  800424:	48 01 d0             	add    %rdx,%rax
  800427:	48 a3 00 60 80 00 00 	movabs %rax,0x806000
  80042e:	00 00 00 

    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  800431:	45 85 ed             	test   %r13d,%r13d
  800434:	7e 0d                	jle    800443 <libmain+0x8b>
  800436:	49 8b 06             	mov    (%r14),%rax
  800439:	48 a3 38 50 80 00 00 	movabs %rax,0x805038
  800440:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  800443:	4c 89 f6             	mov    %r14,%rsi
  800446:	44 89 ef             	mov    %r13d,%edi
  800449:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  800450:	00 00 00 
  800453:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  800455:	48 b8 6a 04 80 00 00 	movabs $0x80046a,%rax
  80045c:	00 00 00 
  80045f:	ff d0                	call   *%rax
#endif
}
  800461:	5b                   	pop    %rbx
  800462:	41 5c                	pop    %r12
  800464:	41 5d                	pop    %r13
  800466:	41 5e                	pop    %r14
  800468:	5d                   	pop    %rbp
  800469:	c3                   	ret

000000000080046a <exit>:

#include <inc/lib.h>

void
exit(void) {
  80046a:	f3 0f 1e fa          	endbr64
  80046e:	55                   	push   %rbp
  80046f:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  800472:	48 b8 8f 1c 80 00 00 	movabs $0x801c8f,%rax
  800479:	00 00 00 
  80047c:	ff d0                	call   *%rax
    sys_env_destroy(0);
  80047e:	bf 00 00 00 00       	mov    $0x0,%edi
  800483:	48 b8 4a 15 80 00 00 	movabs $0x80154a,%rax
  80048a:	00 00 00 
  80048d:	ff d0                	call   *%rax
}
  80048f:	5d                   	pop    %rbp
  800490:	c3                   	ret

0000000000800491 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  800491:	f3 0f 1e fa          	endbr64
  800495:	55                   	push   %rbp
  800496:	48 89 e5             	mov    %rsp,%rbp
  800499:	41 56                	push   %r14
  80049b:	41 55                	push   %r13
  80049d:	41 54                	push   %r12
  80049f:	53                   	push   %rbx
  8004a0:	48 83 ec 50          	sub    $0x50,%rsp
  8004a4:	49 89 fc             	mov    %rdi,%r12
  8004a7:	41 89 f5             	mov    %esi,%r13d
  8004aa:	48 89 d3             	mov    %rdx,%rbx
  8004ad:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8004b1:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  8004b5:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  8004b9:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  8004c0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8004c4:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  8004c8:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  8004cc:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  8004d0:	48 b8 38 50 80 00 00 	movabs $0x805038,%rax
  8004d7:	00 00 00 
  8004da:	4c 8b 30             	mov    (%rax),%r14
  8004dd:	48 b8 b9 15 80 00 00 	movabs $0x8015b9,%rax
  8004e4:	00 00 00 
  8004e7:	ff d0                	call   *%rax
  8004e9:	89 c6                	mov    %eax,%esi
  8004eb:	45 89 e8             	mov    %r13d,%r8d
  8004ee:	4c 89 e1             	mov    %r12,%rcx
  8004f1:	4c 89 f2             	mov    %r14,%rdx
  8004f4:	48 bf d0 42 80 00 00 	movabs $0x8042d0,%rdi
  8004fb:	00 00 00 
  8004fe:	b8 00 00 00 00       	mov    $0x0,%eax
  800503:	49 bc ed 05 80 00 00 	movabs $0x8005ed,%r12
  80050a:	00 00 00 
  80050d:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  800510:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  800514:	48 89 df             	mov    %rbx,%rdi
  800517:	48 b8 85 05 80 00 00 	movabs $0x800585,%rax
  80051e:	00 00 00 
  800521:	ff d0                	call   *%rax
    cprintf("\n");
  800523:	48 bf 66 40 80 00 00 	movabs $0x804066,%rdi
  80052a:	00 00 00 
  80052d:	b8 00 00 00 00       	mov    $0x0,%eax
  800532:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  800535:	cc                   	int3
  800536:	eb fd                	jmp    800535 <_panic+0xa4>

0000000000800538 <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  800538:	f3 0f 1e fa          	endbr64
  80053c:	55                   	push   %rbp
  80053d:	48 89 e5             	mov    %rsp,%rbp
  800540:	53                   	push   %rbx
  800541:	48 83 ec 08          	sub    $0x8,%rsp
  800545:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  800548:	8b 06                	mov    (%rsi),%eax
  80054a:	8d 50 01             	lea    0x1(%rax),%edx
  80054d:	89 16                	mov    %edx,(%rsi)
  80054f:	48 98                	cltq
  800551:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  800556:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  80055c:	74 0a                	je     800568 <putch+0x30>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  80055e:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  800562:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800566:	c9                   	leave
  800567:	c3                   	ret
        sys_cputs(state->buf, state->offset);
  800568:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  80056c:	be ff 00 00 00       	mov    $0xff,%esi
  800571:	48 b8 e4 14 80 00 00 	movabs $0x8014e4,%rax
  800578:	00 00 00 
  80057b:	ff d0                	call   *%rax
        state->offset = 0;
  80057d:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  800583:	eb d9                	jmp    80055e <putch+0x26>

0000000000800585 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  800585:	f3 0f 1e fa          	endbr64
  800589:	55                   	push   %rbp
  80058a:	48 89 e5             	mov    %rsp,%rbp
  80058d:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800594:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  800597:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  80059e:	b9 21 00 00 00       	mov    $0x21,%ecx
  8005a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8005a8:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  8005ab:	48 89 f1             	mov    %rsi,%rcx
  8005ae:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  8005b5:	48 bf 38 05 80 00 00 	movabs $0x800538,%rdi
  8005bc:	00 00 00 
  8005bf:	48 b8 4d 07 80 00 00 	movabs $0x80074d,%rax
  8005c6:	00 00 00 
  8005c9:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  8005cb:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  8005d2:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  8005d9:	48 b8 e4 14 80 00 00 	movabs $0x8014e4,%rax
  8005e0:	00 00 00 
  8005e3:	ff d0                	call   *%rax

    return state.count;
}
  8005e5:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  8005eb:	c9                   	leave
  8005ec:	c3                   	ret

00000000008005ed <cprintf>:

int
cprintf(const char *fmt, ...) {
  8005ed:	f3 0f 1e fa          	endbr64
  8005f1:	55                   	push   %rbp
  8005f2:	48 89 e5             	mov    %rsp,%rbp
  8005f5:	48 83 ec 50          	sub    $0x50,%rsp
  8005f9:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  8005fd:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  800601:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800605:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800609:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  80060d:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  800614:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800618:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80061c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800620:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  800624:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  800628:	48 b8 85 05 80 00 00 	movabs $0x800585,%rax
  80062f:	00 00 00 
  800632:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  800634:	c9                   	leave
  800635:	c3                   	ret

0000000000800636 <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  800636:	f3 0f 1e fa          	endbr64
  80063a:	55                   	push   %rbp
  80063b:	48 89 e5             	mov    %rsp,%rbp
  80063e:	41 57                	push   %r15
  800640:	41 56                	push   %r14
  800642:	41 55                	push   %r13
  800644:	41 54                	push   %r12
  800646:	53                   	push   %rbx
  800647:	48 83 ec 18          	sub    $0x18,%rsp
  80064b:	49 89 fc             	mov    %rdi,%r12
  80064e:	49 89 f5             	mov    %rsi,%r13
  800651:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  800655:	8b 45 10             	mov    0x10(%rbp),%eax
  800658:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  80065b:	41 89 cf             	mov    %ecx,%r15d
  80065e:	4c 39 fa             	cmp    %r15,%rdx
  800661:	73 5b                	jae    8006be <print_num+0x88>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  800663:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  800667:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  80066b:	85 db                	test   %ebx,%ebx
  80066d:	7e 0e                	jle    80067d <print_num+0x47>
            putch(padc, put_arg);
  80066f:	4c 89 ee             	mov    %r13,%rsi
  800672:	44 89 f7             	mov    %r14d,%edi
  800675:	41 ff d4             	call   *%r12
        while (--width > 0) {
  800678:	83 eb 01             	sub    $0x1,%ebx
  80067b:	75 f2                	jne    80066f <print_num+0x39>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  80067d:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  800681:	48 b9 8f 40 80 00 00 	movabs $0x80408f,%rcx
  800688:	00 00 00 
  80068b:	48 b8 7e 40 80 00 00 	movabs $0x80407e,%rax
  800692:	00 00 00 
  800695:	48 0f 45 c8          	cmovne %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  800699:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80069d:	ba 00 00 00 00       	mov    $0x0,%edx
  8006a2:	49 f7 f7             	div    %r15
  8006a5:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  8006a9:	4c 89 ee             	mov    %r13,%rsi
  8006ac:	41 ff d4             	call   *%r12
}
  8006af:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  8006b3:	5b                   	pop    %rbx
  8006b4:	41 5c                	pop    %r12
  8006b6:	41 5d                	pop    %r13
  8006b8:	41 5e                	pop    %r14
  8006ba:	41 5f                	pop    %r15
  8006bc:	5d                   	pop    %rbp
  8006bd:	c3                   	ret
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  8006be:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8006c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c7:	49 f7 f7             	div    %r15
  8006ca:	48 83 ec 08          	sub    $0x8,%rsp
  8006ce:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  8006d2:	52                   	push   %rdx
  8006d3:	45 0f be c9          	movsbl %r9b,%r9d
  8006d7:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  8006db:	48 89 c2             	mov    %rax,%rdx
  8006de:	48 b8 36 06 80 00 00 	movabs $0x800636,%rax
  8006e5:	00 00 00 
  8006e8:	ff d0                	call   *%rax
  8006ea:	48 83 c4 10          	add    $0x10,%rsp
  8006ee:	eb 8d                	jmp    80067d <print_num+0x47>

00000000008006f0 <sprintputch>:
    char *end;
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
  8006f0:	f3 0f 1e fa          	endbr64
    state->count++;
  8006f4:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  8006f8:	48 8b 06             	mov    (%rsi),%rax
  8006fb:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  8006ff:	73 0a                	jae    80070b <sprintputch+0x1b>
        *state->start++ = ch;
  800701:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800705:	48 89 16             	mov    %rdx,(%rsi)
  800708:	40 88 38             	mov    %dil,(%rax)
    }
}
  80070b:	c3                   	ret

000000000080070c <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  80070c:	f3 0f 1e fa          	endbr64
  800710:	55                   	push   %rbp
  800711:	48 89 e5             	mov    %rsp,%rbp
  800714:	48 83 ec 50          	sub    $0x50,%rsp
  800718:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80071c:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800720:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  800724:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  80072b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80072f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800733:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800737:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  80073b:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  80073f:	48 b8 4d 07 80 00 00 	movabs $0x80074d,%rax
  800746:	00 00 00 
  800749:	ff d0                	call   *%rax
}
  80074b:	c9                   	leave
  80074c:	c3                   	ret

000000000080074d <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  80074d:	f3 0f 1e fa          	endbr64
  800751:	55                   	push   %rbp
  800752:	48 89 e5             	mov    %rsp,%rbp
  800755:	41 57                	push   %r15
  800757:	41 56                	push   %r14
  800759:	41 55                	push   %r13
  80075b:	41 54                	push   %r12
  80075d:	53                   	push   %rbx
  80075e:	48 83 ec 38          	sub    $0x38,%rsp
  800762:	49 89 fe             	mov    %rdi,%r14
  800765:	49 89 f5             	mov    %rsi,%r13
  800768:	48 89 d3             	mov    %rdx,%rbx
    va_copy(aq, ap);
  80076b:	48 8b 01             	mov    (%rcx),%rax
  80076e:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  800772:	48 8b 41 08          	mov    0x8(%rcx),%rax
  800776:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80077a:	48 8b 41 10          	mov    0x10(%rcx),%rax
  80077e:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  800782:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  800786:	0f b6 3b             	movzbl (%rbx),%edi
  800789:	40 80 ff 25          	cmp    $0x25,%dil
  80078d:	74 18                	je     8007a7 <vprintfmt+0x5a>
            if (!ch) return;
  80078f:	40 84 ff             	test   %dil,%dil
  800792:	0f 84 b2 06 00 00    	je     800e4a <vprintfmt+0x6fd>
            putch(ch, put_arg);
  800798:	40 0f b6 ff          	movzbl %dil,%edi
  80079c:	4c 89 ee             	mov    %r13,%rsi
  80079f:	41 ff d6             	call   *%r14
        while ((ch = *ufmt++) != '%') {
  8007a2:	4c 89 e3             	mov    %r12,%rbx
  8007a5:	eb db                	jmp    800782 <vprintfmt+0x35>
        bool altflag = 0, zflag = 0;
  8007a7:	be 00 00 00 00       	mov    $0x0,%esi
  8007ac:	c6 45 ab 00          	movb   $0x0,-0x55(%rbp)
        unsigned lflag = 0, base = 10;
  8007b0:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  8007b5:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  8007bb:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  8007c2:	c6 45 aa 20          	movb   $0x20,-0x56(%rbp)
        switch (ch = *ufmt++) {
  8007c6:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  8007cb:	41 0f b6 04 24       	movzbl (%r12),%eax
  8007d0:	88 45 a0             	mov    %al,-0x60(%rbp)
  8007d3:	83 e8 23             	sub    $0x23,%eax
  8007d6:	3c 57                	cmp    $0x57,%al
  8007d8:	0f 87 52 06 00 00    	ja     800e30 <vprintfmt+0x6e3>
  8007de:	0f b6 c0             	movzbl %al,%eax
  8007e1:	48 b9 c0 43 80 00 00 	movabs $0x8043c0,%rcx
  8007e8:	00 00 00 
  8007eb:	3e ff 24 c1          	notrack jmp *(%rcx,%rax,8)
  8007ef:	49 89 dc             	mov    %rbx,%r12
            altflag = 1;
  8007f2:	c6 45 ab 01          	movb   $0x1,-0x55(%rbp)
  8007f6:	eb ce                	jmp    8007c6 <vprintfmt+0x79>
        switch (ch = *ufmt++) {
  8007f8:	49 89 dc             	mov    %rbx,%r12
  8007fb:	be 01 00 00 00       	mov    $0x1,%esi
  800800:	eb c4                	jmp    8007c6 <vprintfmt+0x79>
            padc = ch;
  800802:	0f b6 45 a0          	movzbl -0x60(%rbp),%eax
  800806:	88 45 aa             	mov    %al,-0x56(%rbp)
        switch (ch = *ufmt++) {
  800809:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  80080c:	eb b8                	jmp    8007c6 <vprintfmt+0x79>
            precision = va_arg(aq, int);
  80080e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800811:	83 f8 2f             	cmp    $0x2f,%eax
  800814:	77 24                	ja     80083a <vprintfmt+0xed>
  800816:	89 c1                	mov    %eax,%ecx
  800818:	48 03 4d c8          	add    -0x38(%rbp),%rcx
  80081c:	83 c0 08             	add    $0x8,%eax
  80081f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800822:	44 8b 39             	mov    (%rcx),%r15d
        switch (ch = *ufmt++) {
  800825:	49 89 dc             	mov    %rbx,%r12
            if (width < 0) {
  800828:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  80082c:	79 98                	jns    8007c6 <vprintfmt+0x79>
                width = precision;
  80082e:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
                precision = -1;
  800832:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  800838:	eb 8c                	jmp    8007c6 <vprintfmt+0x79>
            precision = va_arg(aq, int);
  80083a:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  80083e:	48 8d 41 08          	lea    0x8(%rcx),%rax
  800842:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800846:	eb da                	jmp    800822 <vprintfmt+0xd5>
                precision = precision * 10 + ch - '0';
  800848:	44 0f b6 7d a0       	movzbl -0x60(%rbp),%r15d
  80084d:	41 83 ef 30          	sub    $0x30,%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  800851:	41 0f b6 44 24 01    	movzbl 0x1(%r12),%eax
  800857:	3c 39                	cmp    $0x39,%al
  800859:	77 1c                	ja     800877 <vprintfmt+0x12a>
            for (precision = 0;; ++ufmt) {
  80085b:	48 83 c3 01          	add    $0x1,%rbx
                precision = precision * 10 + ch - '0';
  80085f:	43 8d 0c bf          	lea    (%r15,%r15,4),%ecx
  800863:	0f b6 c0             	movzbl %al,%eax
  800866:	44 8d 7c 48 d0       	lea    -0x30(%rax,%rcx,2),%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  80086b:	0f b6 03             	movzbl (%rbx),%eax
  80086e:	3c 39                	cmp    $0x39,%al
  800870:	76 e9                	jbe    80085b <vprintfmt+0x10e>
        process_precision:
  800872:	49 89 dc             	mov    %rbx,%r12
  800875:	eb b1                	jmp    800828 <vprintfmt+0xdb>
        switch (ch = *ufmt++) {
  800877:	49 89 dc             	mov    %rbx,%r12
  80087a:	eb ac                	jmp    800828 <vprintfmt+0xdb>
            width = MAX(0, width);
  80087c:	8b 4d ac             	mov    -0x54(%rbp),%ecx
  80087f:	85 c9                	test   %ecx,%ecx
  800881:	b8 00 00 00 00       	mov    $0x0,%eax
  800886:	0f 49 c1             	cmovns %ecx,%eax
  800889:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  80088c:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  80088f:	e9 32 ff ff ff       	jmp    8007c6 <vprintfmt+0x79>
            lflag++;
  800894:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  800897:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  80089a:	e9 27 ff ff ff       	jmp    8007c6 <vprintfmt+0x79>
            putch(va_arg(aq, int), put_arg);
  80089f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008a2:	83 f8 2f             	cmp    $0x2f,%eax
  8008a5:	77 19                	ja     8008c0 <vprintfmt+0x173>
  8008a7:	89 c2                	mov    %eax,%edx
  8008a9:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8008ad:	83 c0 08             	add    $0x8,%eax
  8008b0:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008b3:	8b 3a                	mov    (%rdx),%edi
  8008b5:	4c 89 ee             	mov    %r13,%rsi
  8008b8:	41 ff d6             	call   *%r14
            break;
  8008bb:	e9 c2 fe ff ff       	jmp    800782 <vprintfmt+0x35>
            putch(va_arg(aq, int), put_arg);
  8008c0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008c4:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8008c8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008cc:	eb e5                	jmp    8008b3 <vprintfmt+0x166>
            int err = va_arg(aq, int);
  8008ce:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008d1:	83 f8 2f             	cmp    $0x2f,%eax
  8008d4:	77 5a                	ja     800930 <vprintfmt+0x1e3>
  8008d6:	89 c2                	mov    %eax,%edx
  8008d8:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8008dc:	83 c0 08             	add    $0x8,%eax
  8008df:	89 45 b8             	mov    %eax,-0x48(%rbp)
            if (err < 0) err = -err;
  8008e2:	8b 02                	mov    (%rdx),%eax
  8008e4:	89 c1                	mov    %eax,%ecx
  8008e6:	f7 d9                	neg    %ecx
  8008e8:	0f 48 c8             	cmovs  %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  8008eb:	83 f9 13             	cmp    $0x13,%ecx
  8008ee:	7f 4e                	jg     80093e <vprintfmt+0x1f1>
  8008f0:	48 63 c1             	movslq %ecx,%rax
  8008f3:	48 ba 80 46 80 00 00 	movabs $0x804680,%rdx
  8008fa:	00 00 00 
  8008fd:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  800901:	48 85 c0             	test   %rax,%rax
  800904:	74 38                	je     80093e <vprintfmt+0x1f1>
                printfmt(putch, put_arg, "%s", strerr);
  800906:	48 89 c1             	mov    %rax,%rcx
  800909:	48 ba 93 42 80 00 00 	movabs $0x804293,%rdx
  800910:	00 00 00 
  800913:	4c 89 ee             	mov    %r13,%rsi
  800916:	4c 89 f7             	mov    %r14,%rdi
  800919:	b8 00 00 00 00       	mov    $0x0,%eax
  80091e:	49 b8 0c 07 80 00 00 	movabs $0x80070c,%r8
  800925:	00 00 00 
  800928:	41 ff d0             	call   *%r8
  80092b:	e9 52 fe ff ff       	jmp    800782 <vprintfmt+0x35>
            int err = va_arg(aq, int);
  800930:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800934:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800938:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80093c:	eb a4                	jmp    8008e2 <vprintfmt+0x195>
                printfmt(putch, put_arg, "error %d", err);
  80093e:	48 ba a7 40 80 00 00 	movabs $0x8040a7,%rdx
  800945:	00 00 00 
  800948:	4c 89 ee             	mov    %r13,%rsi
  80094b:	4c 89 f7             	mov    %r14,%rdi
  80094e:	b8 00 00 00 00       	mov    $0x0,%eax
  800953:	49 b8 0c 07 80 00 00 	movabs $0x80070c,%r8
  80095a:	00 00 00 
  80095d:	41 ff d0             	call   *%r8
  800960:	e9 1d fe ff ff       	jmp    800782 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  800965:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800968:	83 f8 2f             	cmp    $0x2f,%eax
  80096b:	77 6c                	ja     8009d9 <vprintfmt+0x28c>
  80096d:	89 c2                	mov    %eax,%edx
  80096f:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800973:	83 c0 08             	add    $0x8,%eax
  800976:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800979:	48 8b 12             	mov    (%rdx),%rdx
            if (!ptr) ptr = "(null)";
  80097c:	48 85 d2             	test   %rdx,%rdx
  80097f:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  800986:	00 00 00 
  800989:	48 0f 45 c2          	cmovne %rdx,%rax
  80098d:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
            if (width > 0 && padc != '-') {
  800991:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800995:	7e 06                	jle    80099d <vprintfmt+0x250>
  800997:	80 7d aa 2d          	cmpb   $0x2d,-0x56(%rbp)
  80099b:	75 4a                	jne    8009e7 <vprintfmt+0x29a>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  80099d:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8009a1:	4c 8d 60 01          	lea    0x1(%rax),%r12
  8009a5:	0f b6 00             	movzbl (%rax),%eax
  8009a8:	84 c0                	test   %al,%al
  8009aa:	0f 85 9a 00 00 00    	jne    800a4a <vprintfmt+0x2fd>
            while (width-- > 0) putch(' ', put_arg);
  8009b0:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8009b3:	44 8d 60 ff          	lea    -0x1(%rax),%r12d
  8009b7:	85 c0                	test   %eax,%eax
  8009b9:	0f 8e c3 fd ff ff    	jle    800782 <vprintfmt+0x35>
  8009bf:	4c 89 ee             	mov    %r13,%rsi
  8009c2:	bf 20 00 00 00       	mov    $0x20,%edi
  8009c7:	41 ff d6             	call   *%r14
  8009ca:	41 83 ec 01          	sub    $0x1,%r12d
  8009ce:	41 83 fc ff          	cmp    $0xffffffff,%r12d
  8009d2:	75 eb                	jne    8009bf <vprintfmt+0x272>
  8009d4:	e9 a9 fd ff ff       	jmp    800782 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  8009d9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009dd:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009e1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009e5:	eb 92                	jmp    800979 <vprintfmt+0x22c>
                width -= strnlen(ptr, precision);
  8009e7:	49 63 f7             	movslq %r15d,%rsi
  8009ea:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  8009ee:	48 b8 10 0f 80 00 00 	movabs $0x800f10,%rax
  8009f5:	00 00 00 
  8009f8:	ff d0                	call   *%rax
  8009fa:	48 89 c2             	mov    %rax,%rdx
  8009fd:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800a00:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  800a02:	8d 70 ff             	lea    -0x1(%rax),%esi
  800a05:	89 75 ac             	mov    %esi,-0x54(%rbp)
  800a08:	85 c0                	test   %eax,%eax
  800a0a:	7e 91                	jle    80099d <vprintfmt+0x250>
  800a0c:	44 0f be 65 aa       	movsbl -0x56(%rbp),%r12d
  800a11:	4c 89 ee             	mov    %r13,%rsi
  800a14:	44 89 e7             	mov    %r12d,%edi
  800a17:	41 ff d6             	call   *%r14
  800a1a:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  800a1e:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800a21:	83 f8 ff             	cmp    $0xffffffff,%eax
  800a24:	75 eb                	jne    800a11 <vprintfmt+0x2c4>
  800a26:	e9 72 ff ff ff       	jmp    80099d <vprintfmt+0x250>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800a2b:	0f b6 f8             	movzbl %al,%edi
  800a2e:	4c 89 ee             	mov    %r13,%rsi
  800a31:	41 ff d6             	call   *%r14
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800a34:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  800a38:	49 83 c4 01          	add    $0x1,%r12
  800a3c:	41 0f b6 44 24 ff    	movzbl -0x1(%r12),%eax
  800a42:	84 c0                	test   %al,%al
  800a44:	0f 84 66 ff ff ff    	je     8009b0 <vprintfmt+0x263>
  800a4a:	45 85 ff             	test   %r15d,%r15d
  800a4d:	78 0a                	js     800a59 <vprintfmt+0x30c>
  800a4f:	41 83 ef 01          	sub    $0x1,%r15d
  800a53:	0f 88 57 ff ff ff    	js     8009b0 <vprintfmt+0x263>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800a59:	80 7d ab 00          	cmpb   $0x0,-0x55(%rbp)
  800a5d:	74 cc                	je     800a2b <vprintfmt+0x2de>
  800a5f:	8d 50 e0             	lea    -0x20(%rax),%edx
  800a62:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800a67:	80 fa 5e             	cmp    $0x5e,%dl
  800a6a:	77 c2                	ja     800a2e <vprintfmt+0x2e1>
  800a6c:	eb bd                	jmp    800a2b <vprintfmt+0x2de>
    if (zflag) return va_arg(*ap, size_t);
  800a6e:	40 84 f6             	test   %sil,%sil
  800a71:	75 26                	jne    800a99 <vprintfmt+0x34c>
    switch (lflag) {
  800a73:	85 d2                	test   %edx,%edx
  800a75:	74 59                	je     800ad0 <vprintfmt+0x383>
  800a77:	83 fa 01             	cmp    $0x1,%edx
  800a7a:	74 7b                	je     800af7 <vprintfmt+0x3aa>
        return va_arg(*ap, long long);
  800a7c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a7f:	83 f8 2f             	cmp    $0x2f,%eax
  800a82:	0f 87 96 00 00 00    	ja     800b1e <vprintfmt+0x3d1>
  800a88:	89 c2                	mov    %eax,%edx
  800a8a:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a8e:	83 c0 08             	add    $0x8,%eax
  800a91:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a94:	4c 8b 22             	mov    (%rdx),%r12
  800a97:	eb 17                	jmp    800ab0 <vprintfmt+0x363>
    if (zflag) return va_arg(*ap, size_t);
  800a99:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a9c:	83 f8 2f             	cmp    $0x2f,%eax
  800a9f:	77 21                	ja     800ac2 <vprintfmt+0x375>
  800aa1:	89 c2                	mov    %eax,%edx
  800aa3:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800aa7:	83 c0 08             	add    $0x8,%eax
  800aaa:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800aad:	4c 8b 22             	mov    (%rdx),%r12
            if (i < 0) {
  800ab0:	4d 85 e4             	test   %r12,%r12
  800ab3:	78 7a                	js     800b2f <vprintfmt+0x3e2>
            num = i;
  800ab5:	4c 89 e2             	mov    %r12,%rdx
        unsigned lflag = 0, base = 10;
  800ab8:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  800abd:	e9 50 02 00 00       	jmp    800d12 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800ac2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ac6:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800aca:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ace:	eb dd                	jmp    800aad <vprintfmt+0x360>
        return va_arg(*ap, int);
  800ad0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ad3:	83 f8 2f             	cmp    $0x2f,%eax
  800ad6:	77 11                	ja     800ae9 <vprintfmt+0x39c>
  800ad8:	89 c2                	mov    %eax,%edx
  800ada:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800ade:	83 c0 08             	add    $0x8,%eax
  800ae1:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ae4:	4c 63 22             	movslq (%rdx),%r12
  800ae7:	eb c7                	jmp    800ab0 <vprintfmt+0x363>
  800ae9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800aed:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800af1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800af5:	eb ed                	jmp    800ae4 <vprintfmt+0x397>
        return va_arg(*ap, long);
  800af7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800afa:	83 f8 2f             	cmp    $0x2f,%eax
  800afd:	77 11                	ja     800b10 <vprintfmt+0x3c3>
  800aff:	89 c2                	mov    %eax,%edx
  800b01:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b05:	83 c0 08             	add    $0x8,%eax
  800b08:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b0b:	4c 8b 22             	mov    (%rdx),%r12
  800b0e:	eb a0                	jmp    800ab0 <vprintfmt+0x363>
  800b10:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b14:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b18:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b1c:	eb ed                	jmp    800b0b <vprintfmt+0x3be>
        return va_arg(*ap, long long);
  800b1e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b22:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b26:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b2a:	e9 65 ff ff ff       	jmp    800a94 <vprintfmt+0x347>
                putch('-', put_arg);
  800b2f:	4c 89 ee             	mov    %r13,%rsi
  800b32:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800b37:	41 ff d6             	call   *%r14
                i = -i;
  800b3a:	49 f7 dc             	neg    %r12
  800b3d:	e9 73 ff ff ff       	jmp    800ab5 <vprintfmt+0x368>
    if (zflag) return va_arg(*ap, size_t);
  800b42:	40 84 f6             	test   %sil,%sil
  800b45:	75 32                	jne    800b79 <vprintfmt+0x42c>
    switch (lflag) {
  800b47:	85 d2                	test   %edx,%edx
  800b49:	74 5d                	je     800ba8 <vprintfmt+0x45b>
  800b4b:	83 fa 01             	cmp    $0x1,%edx
  800b4e:	0f 84 82 00 00 00    	je     800bd6 <vprintfmt+0x489>
        return va_arg(*ap, unsigned long long);
  800b54:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b57:	83 f8 2f             	cmp    $0x2f,%eax
  800b5a:	0f 87 a5 00 00 00    	ja     800c05 <vprintfmt+0x4b8>
  800b60:	89 c2                	mov    %eax,%edx
  800b62:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b66:	83 c0 08             	add    $0x8,%eax
  800b69:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b6c:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800b6f:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  800b74:	e9 99 01 00 00       	jmp    800d12 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800b79:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b7c:	83 f8 2f             	cmp    $0x2f,%eax
  800b7f:	77 19                	ja     800b9a <vprintfmt+0x44d>
  800b81:	89 c2                	mov    %eax,%edx
  800b83:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b87:	83 c0 08             	add    $0x8,%eax
  800b8a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b8d:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800b90:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800b95:	e9 78 01 00 00       	jmp    800d12 <vprintfmt+0x5c5>
  800b9a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b9e:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800ba2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ba6:	eb e5                	jmp    800b8d <vprintfmt+0x440>
        return va_arg(*ap, unsigned int);
  800ba8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bab:	83 f8 2f             	cmp    $0x2f,%eax
  800bae:	77 18                	ja     800bc8 <vprintfmt+0x47b>
  800bb0:	89 c2                	mov    %eax,%edx
  800bb2:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800bb6:	83 c0 08             	add    $0x8,%eax
  800bb9:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800bbc:	8b 12                	mov    (%rdx),%edx
        unsigned lflag = 0, base = 10;
  800bbe:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  800bc3:	e9 4a 01 00 00       	jmp    800d12 <vprintfmt+0x5c5>
  800bc8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bcc:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800bd0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800bd4:	eb e6                	jmp    800bbc <vprintfmt+0x46f>
        return va_arg(*ap, unsigned long);
  800bd6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bd9:	83 f8 2f             	cmp    $0x2f,%eax
  800bdc:	77 19                	ja     800bf7 <vprintfmt+0x4aa>
  800bde:	89 c2                	mov    %eax,%edx
  800be0:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800be4:	83 c0 08             	add    $0x8,%eax
  800be7:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800bea:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800bed:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  800bf2:	e9 1b 01 00 00       	jmp    800d12 <vprintfmt+0x5c5>
  800bf7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bfb:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800bff:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c03:	eb e5                	jmp    800bea <vprintfmt+0x49d>
        return va_arg(*ap, unsigned long long);
  800c05:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c09:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800c0d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c11:	e9 56 ff ff ff       	jmp    800b6c <vprintfmt+0x41f>
    if (zflag) return va_arg(*ap, size_t);
  800c16:	40 84 f6             	test   %sil,%sil
  800c19:	75 2e                	jne    800c49 <vprintfmt+0x4fc>
    switch (lflag) {
  800c1b:	85 d2                	test   %edx,%edx
  800c1d:	74 59                	je     800c78 <vprintfmt+0x52b>
  800c1f:	83 fa 01             	cmp    $0x1,%edx
  800c22:	74 7f                	je     800ca3 <vprintfmt+0x556>
        return va_arg(*ap, unsigned long long);
  800c24:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c27:	83 f8 2f             	cmp    $0x2f,%eax
  800c2a:	0f 87 9f 00 00 00    	ja     800ccf <vprintfmt+0x582>
  800c30:	89 c2                	mov    %eax,%edx
  800c32:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800c36:	83 c0 08             	add    $0x8,%eax
  800c39:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c3c:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800c3f:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  800c44:	e9 c9 00 00 00       	jmp    800d12 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800c49:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c4c:	83 f8 2f             	cmp    $0x2f,%eax
  800c4f:	77 19                	ja     800c6a <vprintfmt+0x51d>
  800c51:	89 c2                	mov    %eax,%edx
  800c53:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800c57:	83 c0 08             	add    $0x8,%eax
  800c5a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c5d:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800c60:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800c65:	e9 a8 00 00 00       	jmp    800d12 <vprintfmt+0x5c5>
  800c6a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c6e:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800c72:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c76:	eb e5                	jmp    800c5d <vprintfmt+0x510>
        return va_arg(*ap, unsigned int);
  800c78:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c7b:	83 f8 2f             	cmp    $0x2f,%eax
  800c7e:	77 15                	ja     800c95 <vprintfmt+0x548>
  800c80:	89 c2                	mov    %eax,%edx
  800c82:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800c86:	83 c0 08             	add    $0x8,%eax
  800c89:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c8c:	8b 12                	mov    (%rdx),%edx
            base = 8;
  800c8e:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  800c93:	eb 7d                	jmp    800d12 <vprintfmt+0x5c5>
  800c95:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c99:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800c9d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ca1:	eb e9                	jmp    800c8c <vprintfmt+0x53f>
        return va_arg(*ap, unsigned long);
  800ca3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ca6:	83 f8 2f             	cmp    $0x2f,%eax
  800ca9:	77 16                	ja     800cc1 <vprintfmt+0x574>
  800cab:	89 c2                	mov    %eax,%edx
  800cad:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800cb1:	83 c0 08             	add    $0x8,%eax
  800cb4:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800cb7:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800cba:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  800cbf:	eb 51                	jmp    800d12 <vprintfmt+0x5c5>
  800cc1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cc5:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800cc9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ccd:	eb e8                	jmp    800cb7 <vprintfmt+0x56a>
        return va_arg(*ap, unsigned long long);
  800ccf:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cd3:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800cd7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800cdb:	e9 5c ff ff ff       	jmp    800c3c <vprintfmt+0x4ef>
            putch('0', put_arg);
  800ce0:	4c 89 ee             	mov    %r13,%rsi
  800ce3:	bf 30 00 00 00       	mov    $0x30,%edi
  800ce8:	41 ff d6             	call   *%r14
            putch('x', put_arg);
  800ceb:	4c 89 ee             	mov    %r13,%rsi
  800cee:	bf 78 00 00 00       	mov    $0x78,%edi
  800cf3:	41 ff d6             	call   *%r14
            num = (uintptr_t)va_arg(aq, void *);
  800cf6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cf9:	83 f8 2f             	cmp    $0x2f,%eax
  800cfc:	77 47                	ja     800d45 <vprintfmt+0x5f8>
  800cfe:	89 c2                	mov    %eax,%edx
  800d00:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800d04:	83 c0 08             	add    $0x8,%eax
  800d07:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800d0a:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800d0d:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  800d12:	48 83 ec 08          	sub    $0x8,%rsp
  800d16:	80 7d a0 58          	cmpb   $0x58,-0x60(%rbp)
  800d1a:	0f 94 c0             	sete   %al
  800d1d:	0f b6 c0             	movzbl %al,%eax
  800d20:	50                   	push   %rax
  800d21:	44 0f be 4d aa       	movsbl -0x56(%rbp),%r9d
  800d26:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  800d2a:	4c 89 ee             	mov    %r13,%rsi
  800d2d:	4c 89 f7             	mov    %r14,%rdi
  800d30:	48 b8 36 06 80 00 00 	movabs $0x800636,%rax
  800d37:	00 00 00 
  800d3a:	ff d0                	call   *%rax
            break;
  800d3c:	48 83 c4 10          	add    $0x10,%rsp
  800d40:	e9 3d fa ff ff       	jmp    800782 <vprintfmt+0x35>
            num = (uintptr_t)va_arg(aq, void *);
  800d45:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d49:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800d4d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800d51:	eb b7                	jmp    800d0a <vprintfmt+0x5bd>
    if (zflag) return va_arg(*ap, size_t);
  800d53:	40 84 f6             	test   %sil,%sil
  800d56:	75 2b                	jne    800d83 <vprintfmt+0x636>
    switch (lflag) {
  800d58:	85 d2                	test   %edx,%edx
  800d5a:	74 56                	je     800db2 <vprintfmt+0x665>
  800d5c:	83 fa 01             	cmp    $0x1,%edx
  800d5f:	74 7f                	je     800de0 <vprintfmt+0x693>
        return va_arg(*ap, unsigned long long);
  800d61:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d64:	83 f8 2f             	cmp    $0x2f,%eax
  800d67:	0f 87 a2 00 00 00    	ja     800e0f <vprintfmt+0x6c2>
  800d6d:	89 c2                	mov    %eax,%edx
  800d6f:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800d73:	83 c0 08             	add    $0x8,%eax
  800d76:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800d79:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800d7c:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800d81:	eb 8f                	jmp    800d12 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800d83:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d86:	83 f8 2f             	cmp    $0x2f,%eax
  800d89:	77 19                	ja     800da4 <vprintfmt+0x657>
  800d8b:	89 c2                	mov    %eax,%edx
  800d8d:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800d91:	83 c0 08             	add    $0x8,%eax
  800d94:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800d97:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800d9a:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800d9f:	e9 6e ff ff ff       	jmp    800d12 <vprintfmt+0x5c5>
  800da4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800da8:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800dac:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800db0:	eb e5                	jmp    800d97 <vprintfmt+0x64a>
        return va_arg(*ap, unsigned int);
  800db2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800db5:	83 f8 2f             	cmp    $0x2f,%eax
  800db8:	77 18                	ja     800dd2 <vprintfmt+0x685>
  800dba:	89 c2                	mov    %eax,%edx
  800dbc:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800dc0:	83 c0 08             	add    $0x8,%eax
  800dc3:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800dc6:	8b 12                	mov    (%rdx),%edx
            base = 16;
  800dc8:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  800dcd:	e9 40 ff ff ff       	jmp    800d12 <vprintfmt+0x5c5>
  800dd2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800dd6:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800dda:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800dde:	eb e6                	jmp    800dc6 <vprintfmt+0x679>
        return va_arg(*ap, unsigned long);
  800de0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800de3:	83 f8 2f             	cmp    $0x2f,%eax
  800de6:	77 19                	ja     800e01 <vprintfmt+0x6b4>
  800de8:	89 c2                	mov    %eax,%edx
  800dea:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800dee:	83 c0 08             	add    $0x8,%eax
  800df1:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800df4:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800df7:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800dfc:	e9 11 ff ff ff       	jmp    800d12 <vprintfmt+0x5c5>
  800e01:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e05:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800e09:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800e0d:	eb e5                	jmp    800df4 <vprintfmt+0x6a7>
        return va_arg(*ap, unsigned long long);
  800e0f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e13:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800e17:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800e1b:	e9 59 ff ff ff       	jmp    800d79 <vprintfmt+0x62c>
            putch(ch, put_arg);
  800e20:	4c 89 ee             	mov    %r13,%rsi
  800e23:	bf 25 00 00 00       	mov    $0x25,%edi
  800e28:	41 ff d6             	call   *%r14
            break;
  800e2b:	e9 52 f9 ff ff       	jmp    800782 <vprintfmt+0x35>
            putch('%', put_arg);
  800e30:	4c 89 ee             	mov    %r13,%rsi
  800e33:	bf 25 00 00 00       	mov    $0x25,%edi
  800e38:	41 ff d6             	call   *%r14
            while ((--ufmt)[-1] != '%') /* nothing */
  800e3b:	48 83 eb 01          	sub    $0x1,%rbx
  800e3f:	80 7b ff 25          	cmpb   $0x25,-0x1(%rbx)
  800e43:	75 f6                	jne    800e3b <vprintfmt+0x6ee>
  800e45:	e9 38 f9 ff ff       	jmp    800782 <vprintfmt+0x35>
}
  800e4a:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800e4e:	5b                   	pop    %rbx
  800e4f:	41 5c                	pop    %r12
  800e51:	41 5d                	pop    %r13
  800e53:	41 5e                	pop    %r14
  800e55:	41 5f                	pop    %r15
  800e57:	5d                   	pop    %rbp
  800e58:	c3                   	ret

0000000000800e59 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800e59:	f3 0f 1e fa          	endbr64
  800e5d:	55                   	push   %rbp
  800e5e:	48 89 e5             	mov    %rsp,%rbp
  800e61:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800e65:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e69:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800e6e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800e72:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800e79:	48 85 ff             	test   %rdi,%rdi
  800e7c:	74 2b                	je     800ea9 <vsnprintf+0x50>
  800e7e:	48 85 f6             	test   %rsi,%rsi
  800e81:	74 26                	je     800ea9 <vsnprintf+0x50>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800e83:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800e87:	48 bf f0 06 80 00 00 	movabs $0x8006f0,%rdi
  800e8e:	00 00 00 
  800e91:	48 b8 4d 07 80 00 00 	movabs $0x80074d,%rax
  800e98:	00 00 00 
  800e9b:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800e9d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ea1:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800ea4:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800ea7:	c9                   	leave
  800ea8:	c3                   	ret
    if (!buf || n < 1) return -E_INVAL;
  800ea9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800eae:	eb f7                	jmp    800ea7 <vsnprintf+0x4e>

0000000000800eb0 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800eb0:	f3 0f 1e fa          	endbr64
  800eb4:	55                   	push   %rbp
  800eb5:	48 89 e5             	mov    %rsp,%rbp
  800eb8:	48 83 ec 50          	sub    $0x50,%rsp
  800ebc:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800ec0:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800ec4:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800ec8:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800ecf:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800ed3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ed7:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800edb:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800edf:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800ee3:	48 b8 59 0e 80 00 00 	movabs $0x800e59,%rax
  800eea:	00 00 00 
  800eed:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800eef:	c9                   	leave
  800ef0:	c3                   	ret

0000000000800ef1 <strlen>:
 * Primespipe runs 3x faster this way */

#define ASM 1

size_t
strlen(const char *s) {
  800ef1:	f3 0f 1e fa          	endbr64
    size_t n = 0;
    while (*s++) n++;
  800ef5:	80 3f 00             	cmpb   $0x0,(%rdi)
  800ef8:	74 10                	je     800f0a <strlen+0x19>
    size_t n = 0;
  800efa:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800eff:	48 83 c0 01          	add    $0x1,%rax
  800f03:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800f07:	75 f6                	jne    800eff <strlen+0xe>
  800f09:	c3                   	ret
    size_t n = 0;
  800f0a:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800f0f:	c3                   	ret

0000000000800f10 <strnlen>:

size_t
strnlen(const char *s, size_t size) {
  800f10:	f3 0f 1e fa          	endbr64
  800f14:	48 89 f0             	mov    %rsi,%rax
    size_t n = 0;
  800f17:	ba 00 00 00 00       	mov    $0x0,%edx
    while (n < size && *s++) n++;
  800f1c:	48 85 f6             	test   %rsi,%rsi
  800f1f:	74 10                	je     800f31 <strnlen+0x21>
  800f21:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  800f25:	74 0b                	je     800f32 <strnlen+0x22>
  800f27:	48 83 c2 01          	add    $0x1,%rdx
  800f2b:	48 39 d0             	cmp    %rdx,%rax
  800f2e:	75 f1                	jne    800f21 <strnlen+0x11>
  800f30:	c3                   	ret
  800f31:	c3                   	ret
  800f32:	48 89 d0             	mov    %rdx,%rax
    return n;
}
  800f35:	c3                   	ret

0000000000800f36 <strcpy>:

char *
strcpy(char *dst, const char *src) {
  800f36:	f3 0f 1e fa          	endbr64
  800f3a:	48 89 f8             	mov    %rdi,%rax
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800f3d:	ba 00 00 00 00       	mov    $0x0,%edx
  800f42:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  800f46:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  800f49:	48 83 c2 01          	add    $0x1,%rdx
  800f4d:	84 c9                	test   %cl,%cl
  800f4f:	75 f1                	jne    800f42 <strcpy+0xc>
        ;
    return res;
}
  800f51:	c3                   	ret

0000000000800f52 <strcat>:

char *
strcat(char *dst, const char *src) {
  800f52:	f3 0f 1e fa          	endbr64
  800f56:	55                   	push   %rbp
  800f57:	48 89 e5             	mov    %rsp,%rbp
  800f5a:	41 54                	push   %r12
  800f5c:	53                   	push   %rbx
  800f5d:	48 89 fb             	mov    %rdi,%rbx
  800f60:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800f63:	48 b8 f1 0e 80 00 00 	movabs $0x800ef1,%rax
  800f6a:	00 00 00 
  800f6d:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800f6f:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800f73:	4c 89 e6             	mov    %r12,%rsi
  800f76:	48 b8 36 0f 80 00 00 	movabs $0x800f36,%rax
  800f7d:	00 00 00 
  800f80:	ff d0                	call   *%rax
    return dst;
}
  800f82:	48 89 d8             	mov    %rbx,%rax
  800f85:	5b                   	pop    %rbx
  800f86:	41 5c                	pop    %r12
  800f88:	5d                   	pop    %rbp
  800f89:	c3                   	ret

0000000000800f8a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800f8a:	f3 0f 1e fa          	endbr64
  800f8e:	48 89 f8             	mov    %rdi,%rax
    char *ret = dst;
    while (size-- > 0) {
  800f91:	48 85 d2             	test   %rdx,%rdx
  800f94:	74 1f                	je     800fb5 <strncpy+0x2b>
  800f96:	48 01 fa             	add    %rdi,%rdx
  800f99:	48 89 f9             	mov    %rdi,%rcx
        *dst++ = *src;
  800f9c:	48 83 c1 01          	add    $0x1,%rcx
  800fa0:	44 0f b6 06          	movzbl (%rsi),%r8d
  800fa4:	44 88 41 ff          	mov    %r8b,-0x1(%rcx)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800fa8:	41 80 f8 01          	cmp    $0x1,%r8b
  800fac:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800fb0:	48 39 ca             	cmp    %rcx,%rdx
  800fb3:	75 e7                	jne    800f9c <strncpy+0x12>
    }
    return ret;
}
  800fb5:	c3                   	ret

0000000000800fb6 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
  800fb6:	f3 0f 1e fa          	endbr64
    char *dst_in = dst;
    if (size) {
  800fba:	48 89 f8             	mov    %rdi,%rax
  800fbd:	48 85 d2             	test   %rdx,%rdx
  800fc0:	74 24                	je     800fe6 <strlcpy+0x30>
        while (--size > 0 && *src)
  800fc2:	48 83 ea 01          	sub    $0x1,%rdx
  800fc6:	74 1b                	je     800fe3 <strlcpy+0x2d>
  800fc8:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800fcc:	0f b6 16             	movzbl (%rsi),%edx
  800fcf:	84 d2                	test   %dl,%dl
  800fd1:	74 10                	je     800fe3 <strlcpy+0x2d>
            *dst++ = *src++;
  800fd3:	48 83 c6 01          	add    $0x1,%rsi
  800fd7:	48 83 c0 01          	add    $0x1,%rax
  800fdb:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800fde:	48 39 c8             	cmp    %rcx,%rax
  800fe1:	75 e9                	jne    800fcc <strlcpy+0x16>
        *dst = '\0';
  800fe3:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800fe6:	48 29 f8             	sub    %rdi,%rax
}
  800fe9:	c3                   	ret

0000000000800fea <strcmp>:
    }
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
  800fea:	f3 0f 1e fa          	endbr64
    while (*p && *p == *q) p++, q++;
  800fee:	0f b6 07             	movzbl (%rdi),%eax
  800ff1:	84 c0                	test   %al,%al
  800ff3:	74 13                	je     801008 <strcmp+0x1e>
  800ff5:	38 06                	cmp    %al,(%rsi)
  800ff7:	75 0f                	jne    801008 <strcmp+0x1e>
  800ff9:	48 83 c7 01          	add    $0x1,%rdi
  800ffd:	48 83 c6 01          	add    $0x1,%rsi
  801001:	0f b6 07             	movzbl (%rdi),%eax
  801004:	84 c0                	test   %al,%al
  801006:	75 ed                	jne    800ff5 <strcmp+0xb>
    return (int)((unsigned char)*p - (unsigned char)*q);
  801008:	0f b6 c0             	movzbl %al,%eax
  80100b:	0f b6 16             	movzbl (%rsi),%edx
  80100e:	29 d0                	sub    %edx,%eax
}
  801010:	c3                   	ret

0000000000801011 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
  801011:	f3 0f 1e fa          	endbr64
    while (n && *p && *p == *q) n--, p++, q++;
  801015:	48 85 d2             	test   %rdx,%rdx
  801018:	74 1f                	je     801039 <strncmp+0x28>
  80101a:	0f b6 07             	movzbl (%rdi),%eax
  80101d:	84 c0                	test   %al,%al
  80101f:	74 1e                	je     80103f <strncmp+0x2e>
  801021:	3a 06                	cmp    (%rsi),%al
  801023:	75 1a                	jne    80103f <strncmp+0x2e>
  801025:	48 83 c7 01          	add    $0x1,%rdi
  801029:	48 83 c6 01          	add    $0x1,%rsi
  80102d:	48 83 ea 01          	sub    $0x1,%rdx
  801031:	75 e7                	jne    80101a <strncmp+0x9>

    if (!n) return 0;
  801033:	b8 00 00 00 00       	mov    $0x0,%eax
  801038:	c3                   	ret
  801039:	b8 00 00 00 00       	mov    $0x0,%eax
  80103e:	c3                   	ret

    return (int)((unsigned char)*p - (unsigned char)*q);
  80103f:	0f b6 07             	movzbl (%rdi),%eax
  801042:	0f b6 16             	movzbl (%rsi),%edx
  801045:	29 d0                	sub    %edx,%eax
}
  801047:	c3                   	ret

0000000000801048 <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
  801048:	f3 0f 1e fa          	endbr64
    for (; *str; str++) {
  80104c:	0f b6 17             	movzbl (%rdi),%edx
  80104f:	84 d2                	test   %dl,%dl
  801051:	74 18                	je     80106b <strchr+0x23>
        if (*str == c) {
  801053:	0f be d2             	movsbl %dl,%edx
  801056:	39 f2                	cmp    %esi,%edx
  801058:	74 17                	je     801071 <strchr+0x29>
    for (; *str; str++) {
  80105a:	48 83 c7 01          	add    $0x1,%rdi
  80105e:	0f b6 17             	movzbl (%rdi),%edx
  801061:	84 d2                	test   %dl,%dl
  801063:	75 ee                	jne    801053 <strchr+0xb>
            return (char *)str;
        }
    }
    return NULL;
  801065:	b8 00 00 00 00       	mov    $0x0,%eax
  80106a:	c3                   	ret
  80106b:	b8 00 00 00 00       	mov    $0x0,%eax
  801070:	c3                   	ret
            return (char *)str;
  801071:	48 89 f8             	mov    %rdi,%rax
}
  801074:	c3                   	ret

0000000000801075 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
  801075:	f3 0f 1e fa          	endbr64
  801079:	48 89 f8             	mov    %rdi,%rax
    for (; *str && *str != ch; str++) /* nothing */
  80107c:	0f b6 17             	movzbl (%rdi),%edx
  80107f:	84 d2                	test   %dl,%dl
  801081:	74 13                	je     801096 <strfind+0x21>
  801083:	0f be d2             	movsbl %dl,%edx
  801086:	39 f2                	cmp    %esi,%edx
  801088:	74 0b                	je     801095 <strfind+0x20>
  80108a:	48 83 c0 01          	add    $0x1,%rax
  80108e:	0f b6 10             	movzbl (%rax),%edx
  801091:	84 d2                	test   %dl,%dl
  801093:	75 ee                	jne    801083 <strfind+0xe>
        ;
    return (char *)str;
}
  801095:	c3                   	ret
  801096:	c3                   	ret

0000000000801097 <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  801097:	f3 0f 1e fa          	endbr64
  80109b:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  80109e:	48 89 f8             	mov    %rdi,%rax
  8010a1:	48 f7 d8             	neg    %rax
  8010a4:	83 e0 07             	and    $0x7,%eax
  8010a7:	49 89 d1             	mov    %rdx,%r9
  8010aa:	49 29 c1             	sub    %rax,%r9
  8010ad:	78 36                	js     8010e5 <memset+0x4e>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  8010af:	40 0f b6 c6          	movzbl %sil,%eax
  8010b3:	48 b9 01 01 01 01 01 	movabs $0x101010101010101,%rcx
  8010ba:	01 01 01 
  8010bd:	48 0f af c1          	imul   %rcx,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  8010c1:	40 f6 c7 07          	test   $0x7,%dil
  8010c5:	75 38                	jne    8010ff <memset+0x68>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  8010c7:	4c 89 c9             	mov    %r9,%rcx
  8010ca:	48 c1 f9 03          	sar    $0x3,%rcx
  8010ce:	74 0c                	je     8010dc <memset+0x45>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  8010d0:	fc                   	cld
  8010d1:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  8010d4:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  8010d8:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  8010dc:	4d 85 c9             	test   %r9,%r9
  8010df:	75 45                	jne    801126 <memset+0x8f>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  8010e1:	4c 89 c0             	mov    %r8,%rax
  8010e4:	c3                   	ret
        while (n-- > 0) *ptr++ = c;
  8010e5:	48 85 d2             	test   %rdx,%rdx
  8010e8:	74 f7                	je     8010e1 <memset+0x4a>
  8010ea:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  8010ed:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  8010f0:	48 83 c0 01          	add    $0x1,%rax
  8010f4:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  8010f8:	48 39 c2             	cmp    %rax,%rdx
  8010fb:	75 f3                	jne    8010f0 <memset+0x59>
  8010fd:	eb e2                	jmp    8010e1 <memset+0x4a>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  8010ff:	40 f6 c7 01          	test   $0x1,%dil
  801103:	74 06                	je     80110b <memset+0x74>
  801105:	88 07                	mov    %al,(%rdi)
  801107:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  80110b:	40 f6 c7 02          	test   $0x2,%dil
  80110f:	74 07                	je     801118 <memset+0x81>
  801111:	66 89 07             	mov    %ax,(%rdi)
  801114:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  801118:	40 f6 c7 04          	test   $0x4,%dil
  80111c:	74 a9                	je     8010c7 <memset+0x30>
  80111e:	89 07                	mov    %eax,(%rdi)
  801120:	48 83 c7 04          	add    $0x4,%rdi
  801124:	eb a1                	jmp    8010c7 <memset+0x30>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  801126:	41 f6 c1 04          	test   $0x4,%r9b
  80112a:	74 1b                	je     801147 <memset+0xb0>
  80112c:	89 07                	mov    %eax,(%rdi)
  80112e:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  801132:	41 f6 c1 02          	test   $0x2,%r9b
  801136:	74 07                	je     80113f <memset+0xa8>
  801138:	66 89 07             	mov    %ax,(%rdi)
  80113b:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  80113f:	41 f6 c1 01          	test   $0x1,%r9b
  801143:	74 9c                	je     8010e1 <memset+0x4a>
  801145:	eb 06                	jmp    80114d <memset+0xb6>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  801147:	41 f6 c1 02          	test   $0x2,%r9b
  80114b:	75 eb                	jne    801138 <memset+0xa1>
        if (ni & 1) *ptr = k;
  80114d:	88 07                	mov    %al,(%rdi)
  80114f:	eb 90                	jmp    8010e1 <memset+0x4a>

0000000000801151 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  801151:	f3 0f 1e fa          	endbr64
  801155:	48 89 f8             	mov    %rdi,%rax
  801158:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  80115b:	48 39 fe             	cmp    %rdi,%rsi
  80115e:	73 3b                	jae    80119b <memmove+0x4a>
  801160:	48 8d 14 16          	lea    (%rsi,%rdx,1),%rdx
  801164:	48 39 d7             	cmp    %rdx,%rdi
  801167:	73 32                	jae    80119b <memmove+0x4a>
        s += n;
        d += n;
  801169:	48 8d 3c 0f          	lea    (%rdi,%rcx,1),%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  80116d:	48 89 d6             	mov    %rdx,%rsi
  801170:	48 09 fe             	or     %rdi,%rsi
  801173:	48 09 ce             	or     %rcx,%rsi
  801176:	40 f6 c6 07          	test   $0x7,%sil
  80117a:	75 12                	jne    80118e <memmove+0x3d>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  80117c:	48 83 ef 08          	sub    $0x8,%rdi
  801180:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  801184:	48 c1 e9 03          	shr    $0x3,%rcx
  801188:	fd                   	std
  801189:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  80118c:	fc                   	cld
  80118d:	c3                   	ret
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  80118e:	48 83 ef 01          	sub    $0x1,%rdi
  801192:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  801196:	fd                   	std
  801197:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  801199:	eb f1                	jmp    80118c <memmove+0x3b>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  80119b:	48 89 f2             	mov    %rsi,%rdx
  80119e:	48 09 c2             	or     %rax,%rdx
  8011a1:	48 09 ca             	or     %rcx,%rdx
  8011a4:	f6 c2 07             	test   $0x7,%dl
  8011a7:	75 0c                	jne    8011b5 <memmove+0x64>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  8011a9:	48 c1 e9 03          	shr    $0x3,%rcx
  8011ad:	48 89 c7             	mov    %rax,%rdi
  8011b0:	fc                   	cld
  8011b1:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  8011b4:	c3                   	ret
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  8011b5:	48 89 c7             	mov    %rax,%rdi
  8011b8:	fc                   	cld
  8011b9:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  8011bb:	c3                   	ret

00000000008011bc <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  8011bc:	f3 0f 1e fa          	endbr64
  8011c0:	55                   	push   %rbp
  8011c1:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  8011c4:	48 b8 51 11 80 00 00 	movabs $0x801151,%rax
  8011cb:	00 00 00 
  8011ce:	ff d0                	call   *%rax
}
  8011d0:	5d                   	pop    %rbp
  8011d1:	c3                   	ret

00000000008011d2 <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  8011d2:	f3 0f 1e fa          	endbr64
  8011d6:	55                   	push   %rbp
  8011d7:	48 89 e5             	mov    %rsp,%rbp
  8011da:	41 57                	push   %r15
  8011dc:	41 56                	push   %r14
  8011de:	41 55                	push   %r13
  8011e0:	41 54                	push   %r12
  8011e2:	53                   	push   %rbx
  8011e3:	48 83 ec 08          	sub    $0x8,%rsp
  8011e7:	49 89 fe             	mov    %rdi,%r14
  8011ea:	49 89 f7             	mov    %rsi,%r15
  8011ed:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  8011f0:	48 89 f7             	mov    %rsi,%rdi
  8011f3:	48 b8 f1 0e 80 00 00 	movabs $0x800ef1,%rax
  8011fa:	00 00 00 
  8011fd:	ff d0                	call   *%rax
  8011ff:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  801202:	48 89 de             	mov    %rbx,%rsi
  801205:	4c 89 f7             	mov    %r14,%rdi
  801208:	48 b8 10 0f 80 00 00 	movabs $0x800f10,%rax
  80120f:	00 00 00 
  801212:	ff d0                	call   *%rax
  801214:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  801217:	48 39 c3             	cmp    %rax,%rbx
  80121a:	74 36                	je     801252 <strlcat+0x80>
    if (srclen < maxlen - dstlen) {
  80121c:	48 89 d8             	mov    %rbx,%rax
  80121f:	4c 29 e8             	sub    %r13,%rax
  801222:	49 39 c4             	cmp    %rax,%r12
  801225:	73 31                	jae    801258 <strlcat+0x86>
        memcpy(dst + dstlen, src, srclen + 1);
  801227:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  80122c:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  801230:	4c 89 fe             	mov    %r15,%rsi
  801233:	48 b8 bc 11 80 00 00 	movabs $0x8011bc,%rax
  80123a:	00 00 00 
  80123d:	ff d0                	call   *%rax
    return dstlen + srclen;
  80123f:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  801243:	48 83 c4 08          	add    $0x8,%rsp
  801247:	5b                   	pop    %rbx
  801248:	41 5c                	pop    %r12
  80124a:	41 5d                	pop    %r13
  80124c:	41 5e                	pop    %r14
  80124e:	41 5f                	pop    %r15
  801250:	5d                   	pop    %rbp
  801251:	c3                   	ret
    if (dstlen == maxlen) return maxlen + srclen;
  801252:	49 8d 04 04          	lea    (%r12,%rax,1),%rax
  801256:	eb eb                	jmp    801243 <strlcat+0x71>
        memcpy(dst + dstlen, src, maxlen - 1);
  801258:	48 83 eb 01          	sub    $0x1,%rbx
  80125c:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  801260:	48 89 da             	mov    %rbx,%rdx
  801263:	4c 89 fe             	mov    %r15,%rsi
  801266:	48 b8 bc 11 80 00 00 	movabs $0x8011bc,%rax
  80126d:	00 00 00 
  801270:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  801272:	49 01 de             	add    %rbx,%r14
  801275:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  80127a:	eb c3                	jmp    80123f <strlcat+0x6d>

000000000080127c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  80127c:	f3 0f 1e fa          	endbr64
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  801280:	48 85 d2             	test   %rdx,%rdx
  801283:	74 2d                	je     8012b2 <memcmp+0x36>
  801285:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  80128a:	0f b6 0c 07          	movzbl (%rdi,%rax,1),%ecx
  80128e:	44 0f b6 04 06       	movzbl (%rsi,%rax,1),%r8d
  801293:	44 38 c1             	cmp    %r8b,%cl
  801296:	75 0f                	jne    8012a7 <memcmp+0x2b>
    while (n-- > 0) {
  801298:	48 83 c0 01          	add    $0x1,%rax
  80129c:	48 39 c2             	cmp    %rax,%rdx
  80129f:	75 e9                	jne    80128a <memcmp+0xe>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  8012a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8012a6:	c3                   	ret
            return (int)*s1 - (int)*s2;
  8012a7:	0f b6 c1             	movzbl %cl,%eax
  8012aa:	45 0f b6 c0          	movzbl %r8b,%r8d
  8012ae:	44 29 c0             	sub    %r8d,%eax
  8012b1:	c3                   	ret
    return 0;
  8012b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012b7:	c3                   	ret

00000000008012b8 <memfind>:

void *
memfind(const void *src, int c, size_t n) {
  8012b8:	f3 0f 1e fa          	endbr64
    const void *end = (const char *)src + n;
  8012bc:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  8012c0:	48 39 c7             	cmp    %rax,%rdi
  8012c3:	73 0f                	jae    8012d4 <memfind+0x1c>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  8012c5:	40 38 37             	cmp    %sil,(%rdi)
  8012c8:	74 0e                	je     8012d8 <memfind+0x20>
    for (; src < end; src++) {
  8012ca:	48 83 c7 01          	add    $0x1,%rdi
  8012ce:	48 39 f8             	cmp    %rdi,%rax
  8012d1:	75 f2                	jne    8012c5 <memfind+0xd>
  8012d3:	c3                   	ret
  8012d4:	48 89 f8             	mov    %rdi,%rax
  8012d7:	c3                   	ret
  8012d8:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  8012db:	c3                   	ret

00000000008012dc <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  8012dc:	f3 0f 1e fa          	endbr64
  8012e0:	49 89 f2             	mov    %rsi,%r10
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  8012e3:	0f b6 37             	movzbl (%rdi),%esi
  8012e6:	40 80 fe 20          	cmp    $0x20,%sil
  8012ea:	74 06                	je     8012f2 <strtol+0x16>
  8012ec:	40 80 fe 09          	cmp    $0x9,%sil
  8012f0:	75 13                	jne    801305 <strtol+0x29>
  8012f2:	48 83 c7 01          	add    $0x1,%rdi
  8012f6:	0f b6 37             	movzbl (%rdi),%esi
  8012f9:	40 80 fe 20          	cmp    $0x20,%sil
  8012fd:	74 f3                	je     8012f2 <strtol+0x16>
  8012ff:	40 80 fe 09          	cmp    $0x9,%sil
  801303:	74 ed                	je     8012f2 <strtol+0x16>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  801305:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  801308:	83 e0 fd             	and    $0xfffffffd,%eax
  80130b:	3c 01                	cmp    $0x1,%al
  80130d:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  801311:	f7 c2 ef ff ff ff    	test   $0xffffffef,%edx
  801317:	75 0f                	jne    801328 <strtol+0x4c>
  801319:	80 3f 30             	cmpb   $0x30,(%rdi)
  80131c:	74 14                	je     801332 <strtol+0x56>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  80131e:	85 d2                	test   %edx,%edx
  801320:	b8 0a 00 00 00       	mov    $0xa,%eax
  801325:	0f 44 d0             	cmove  %eax,%edx
    }

    /* Digits */
    long val = 0;
  801328:	b8 00 00 00 00       	mov    $0x0,%eax
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  80132d:	4c 63 ca             	movslq %edx,%r9
  801330:	eb 36                	jmp    801368 <strtol+0x8c>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  801332:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  801336:	74 0f                	je     801347 <strtol+0x6b>
    } else if (!base && s[0] == '0') {
  801338:	85 d2                	test   %edx,%edx
  80133a:	75 ec                	jne    801328 <strtol+0x4c>
        s++;
  80133c:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  801340:	ba 08 00 00 00       	mov    $0x8,%edx
        s++;
  801345:	eb e1                	jmp    801328 <strtol+0x4c>
        s += 2;
  801347:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  80134b:	ba 10 00 00 00       	mov    $0x10,%edx
        s += 2;
  801350:	eb d6                	jmp    801328 <strtol+0x4c>
            dig -= '0';
  801352:	83 e9 30             	sub    $0x30,%ecx
        if (dig >= base) break;
  801355:	44 0f b6 c1          	movzbl %cl,%r8d
  801359:	41 39 d0             	cmp    %edx,%r8d
  80135c:	7d 21                	jge    80137f <strtol+0xa3>
        val = val * base + dig;
  80135e:	49 0f af c1          	imul   %r9,%rax
  801362:	0f b6 c9             	movzbl %cl,%ecx
  801365:	48 01 c8             	add    %rcx,%rax
        uint8_t dig = *s++;
  801368:	48 83 c7 01          	add    $0x1,%rdi
  80136c:	0f b6 4f ff          	movzbl -0x1(%rdi),%ecx
        if (dig - '0' < 10)
  801370:	80 f9 39             	cmp    $0x39,%cl
  801373:	76 dd                	jbe    801352 <strtol+0x76>
        else if (dig - 'a' < 27)
  801375:	80 f9 7b             	cmp    $0x7b,%cl
  801378:	77 05                	ja     80137f <strtol+0xa3>
            dig -= 'a' - 10;
  80137a:	83 e9 57             	sub    $0x57,%ecx
  80137d:	eb d6                	jmp    801355 <strtol+0x79>
    }

    if (endptr) *endptr = (char *)s;
  80137f:	4d 85 d2             	test   %r10,%r10
  801382:	74 03                	je     801387 <strtol+0xab>
  801384:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  801387:	48 89 c2             	mov    %rax,%rdx
  80138a:	48 f7 da             	neg    %rdx
  80138d:	40 80 fe 2d          	cmp    $0x2d,%sil
  801391:	48 0f 44 c2          	cmove  %rdx,%rax
}
  801395:	c3                   	ret

0000000000801396 <readline>:
#define BUFLEN 1024

static char buf[BUFLEN];

char *
readline(const char *prompt) {
  801396:	f3 0f 1e fa          	endbr64
  80139a:	55                   	push   %rbp
  80139b:	48 89 e5             	mov    %rsp,%rbp
  80139e:	41 57                	push   %r15
  8013a0:	41 56                	push   %r14
  8013a2:	41 55                	push   %r13
  8013a4:	41 54                	push   %r12
  8013a6:	53                   	push   %rbx
  8013a7:	48 83 ec 08          	sub    $0x8,%rsp
    if (prompt) {
  8013ab:	48 85 ff             	test   %rdi,%rdi
  8013ae:	74 23                	je     8013d3 <readline+0x3d>
#if JOS_KERNEL
        cprintf("%s", prompt);
#else
        fprintf(1, "%s", prompt);
  8013b0:	48 89 fa             	mov    %rdi,%rdx
  8013b3:	48 be 93 42 80 00 00 	movabs $0x804293,%rsi
  8013ba:	00 00 00 
  8013bd:	bf 01 00 00 00       	mov    $0x1,%edi
  8013c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8013c7:	48 b9 1a 26 80 00 00 	movabs $0x80261a,%rcx
  8013ce:	00 00 00 
  8013d1:	ff d1                	call   *%rcx
#endif
    }

    bool echo = iscons(0);
  8013d3:	bf 00 00 00 00       	mov    $0x0,%edi
  8013d8:	48 b8 13 03 80 00 00 	movabs $0x800313,%rax
  8013df:	00 00 00 
  8013e2:	ff d0                	call   *%rax
  8013e4:	41 89 c6             	mov    %eax,%r14d

    for (size_t i = 0;;) {
  8013e7:	41 bc 00 00 00 00    	mov    $0x0,%r12d
        int c = getchar();
  8013ed:	49 bd d6 02 80 00 00 	movabs $0x8002d6,%r13
  8013f4:	00 00 00 
                cprintf("read error: %i\n", c);
            return NULL;
        } else if ((c == '\b' || c == '\x7F')) {
            if (i) {
                if (echo) {
                    cputchar('\b');
  8013f7:	49 bf af 02 80 00 00 	movabs $0x8002af,%r15
  8013fe:	00 00 00 
  801401:	eb 46                	jmp    801449 <readline+0xb3>
            return NULL;
  801403:	b8 00 00 00 00       	mov    $0x0,%eax
            if (c != -E_EOF)
  801408:	83 fb f4             	cmp    $0xfffffff4,%ebx
  80140b:	75 0f                	jne    80141c <readline+0x86>
            }
            buf[i] = 0;
            return buf;
        }
    }
}
  80140d:	48 83 c4 08          	add    $0x8,%rsp
  801411:	5b                   	pop    %rbx
  801412:	41 5c                	pop    %r12
  801414:	41 5d                	pop    %r13
  801416:	41 5e                	pop    %r14
  801418:	41 5f                	pop    %r15
  80141a:	5d                   	pop    %rbp
  80141b:	c3                   	ret
                cprintf("read error: %i\n", c);
  80141c:	89 de                	mov    %ebx,%esi
  80141e:	48 bf 0d 42 80 00 00 	movabs $0x80420d,%rdi
  801425:	00 00 00 
  801428:	48 ba ed 05 80 00 00 	movabs $0x8005ed,%rdx
  80142f:	00 00 00 
  801432:	ff d2                	call   *%rdx
            return NULL;
  801434:	b8 00 00 00 00       	mov    $0x0,%eax
  801439:	eb d2                	jmp    80140d <readline+0x77>
            if (i) {
  80143b:	4d 85 e4             	test   %r12,%r12
  80143e:	74 09                	je     801449 <readline+0xb3>
                if (echo) {
  801440:	45 85 f6             	test   %r14d,%r14d
  801443:	75 3f                	jne    801484 <readline+0xee>
                i--;
  801445:	49 83 ec 01          	sub    $0x1,%r12
        int c = getchar();
  801449:	41 ff d5             	call   *%r13
  80144c:	89 c3                	mov    %eax,%ebx
        if (c < 0) {
  80144e:	85 c0                	test   %eax,%eax
  801450:	78 b1                	js     801403 <readline+0x6d>
        } else if ((c == '\b' || c == '\x7F')) {
  801452:	83 f8 08             	cmp    $0x8,%eax
  801455:	74 e4                	je     80143b <readline+0xa5>
  801457:	83 f8 7f             	cmp    $0x7f,%eax
  80145a:	74 df                	je     80143b <readline+0xa5>
        } else if (c >= ' ') {
  80145c:	83 f8 1f             	cmp    $0x1f,%eax
  80145f:	7e 4d                	jle    8014ae <readline+0x118>
            if (i < BUFLEN - 1) {
  801461:	49 81 fc fe 03 00 00 	cmp    $0x3fe,%r12
  801468:	77 df                	ja     801449 <readline+0xb3>
                if (echo) {
  80146a:	45 85 f6             	test   %r14d,%r14d
  80146d:	75 2f                	jne    80149e <readline+0x108>
                buf[i++] = (char)c;
  80146f:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801476:	00 00 00 
  801479:	42 88 1c 20          	mov    %bl,(%rax,%r12,1)
  80147d:	4d 8d 64 24 01       	lea    0x1(%r12),%r12
  801482:	eb c5                	jmp    801449 <readline+0xb3>
                    cputchar('\b');
  801484:	bf 08 00 00 00       	mov    $0x8,%edi
  801489:	41 ff d7             	call   *%r15
                    cputchar(' ');
  80148c:	bf 20 00 00 00       	mov    $0x20,%edi
  801491:	41 ff d7             	call   *%r15
                    cputchar('\b');
  801494:	bf 08 00 00 00       	mov    $0x8,%edi
  801499:	41 ff d7             	call   *%r15
  80149c:	eb a7                	jmp    801445 <readline+0xaf>
                    cputchar(c);
  80149e:	89 c7                	mov    %eax,%edi
  8014a0:	48 b8 af 02 80 00 00 	movabs $0x8002af,%rax
  8014a7:	00 00 00 
  8014aa:	ff d0                	call   *%rax
  8014ac:	eb c1                	jmp    80146f <readline+0xd9>
        } else if (c == '\n' || c == '\r') {
  8014ae:	83 f8 0a             	cmp    $0xa,%eax
  8014b1:	74 05                	je     8014b8 <readline+0x122>
  8014b3:	83 f8 0d             	cmp    $0xd,%eax
  8014b6:	75 91                	jne    801449 <readline+0xb3>
            if (echo) {
  8014b8:	45 85 f6             	test   %r14d,%r14d
  8014bb:	75 14                	jne    8014d1 <readline+0x13b>
            buf[i] = 0;
  8014bd:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8014c4:	00 00 00 
  8014c7:	42 c6 04 20 00       	movb   $0x0,(%rax,%r12,1)
            return buf;
  8014cc:	e9 3c ff ff ff       	jmp    80140d <readline+0x77>
                cputchar('\n');
  8014d1:	bf 0a 00 00 00       	mov    $0xa,%edi
  8014d6:	48 b8 af 02 80 00 00 	movabs $0x8002af,%rax
  8014dd:	00 00 00 
  8014e0:	ff d0                	call   *%rax
  8014e2:	eb d9                	jmp    8014bd <readline+0x127>

00000000008014e4 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  8014e4:	f3 0f 1e fa          	endbr64
  8014e8:	55                   	push   %rbp
  8014e9:	48 89 e5             	mov    %rsp,%rbp
  8014ec:	53                   	push   %rbx
  8014ed:	48 89 fa             	mov    %rdi,%rdx
  8014f0:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8014f3:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8014f8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014fd:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801502:	be 00 00 00 00       	mov    $0x0,%esi
  801507:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80150d:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  80150f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801513:	c9                   	leave
  801514:	c3                   	ret

0000000000801515 <sys_cgetc>:

int
sys_cgetc(void) {
  801515:	f3 0f 1e fa          	endbr64
  801519:	55                   	push   %rbp
  80151a:	48 89 e5             	mov    %rsp,%rbp
  80151d:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80151e:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801523:	ba 00 00 00 00       	mov    $0x0,%edx
  801528:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80152d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801532:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801537:	be 00 00 00 00       	mov    $0x0,%esi
  80153c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801542:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  801544:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801548:	c9                   	leave
  801549:	c3                   	ret

000000000080154a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  80154a:	f3 0f 1e fa          	endbr64
  80154e:	55                   	push   %rbp
  80154f:	48 89 e5             	mov    %rsp,%rbp
  801552:	53                   	push   %rbx
  801553:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  801557:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80155a:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80155f:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801564:	bb 00 00 00 00       	mov    $0x0,%ebx
  801569:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80156e:	be 00 00 00 00       	mov    $0x0,%esi
  801573:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801579:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80157b:	48 85 c0             	test   %rax,%rax
  80157e:	7f 06                	jg     801586 <sys_env_destroy+0x3c>
}
  801580:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801584:	c9                   	leave
  801585:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801586:	49 89 c0             	mov    %rax,%r8
  801589:	b9 03 00 00 00       	mov    $0x3,%ecx
  80158e:	48 ba 18 43 80 00 00 	movabs $0x804318,%rdx
  801595:	00 00 00 
  801598:	be 26 00 00 00       	mov    $0x26,%esi
  80159d:	48 bf 1d 42 80 00 00 	movabs $0x80421d,%rdi
  8015a4:	00 00 00 
  8015a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ac:	49 b9 91 04 80 00 00 	movabs $0x800491,%r9
  8015b3:	00 00 00 
  8015b6:	41 ff d1             	call   *%r9

00000000008015b9 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  8015b9:	f3 0f 1e fa          	endbr64
  8015bd:	55                   	push   %rbp
  8015be:	48 89 e5             	mov    %rsp,%rbp
  8015c1:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8015c2:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8015c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8015cc:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8015d1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015d6:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8015db:	be 00 00 00 00       	mov    $0x0,%esi
  8015e0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8015e6:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  8015e8:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8015ec:	c9                   	leave
  8015ed:	c3                   	ret

00000000008015ee <sys_yield>:

void
sys_yield(void) {
  8015ee:	f3 0f 1e fa          	endbr64
  8015f2:	55                   	push   %rbp
  8015f3:	48 89 e5             	mov    %rsp,%rbp
  8015f6:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8015f7:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8015fc:	ba 00 00 00 00       	mov    $0x0,%edx
  801601:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801606:	bb 00 00 00 00       	mov    $0x0,%ebx
  80160b:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801610:	be 00 00 00 00       	mov    $0x0,%esi
  801615:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80161b:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  80161d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801621:	c9                   	leave
  801622:	c3                   	ret

0000000000801623 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  801623:	f3 0f 1e fa          	endbr64
  801627:	55                   	push   %rbp
  801628:	48 89 e5             	mov    %rsp,%rbp
  80162b:	53                   	push   %rbx
  80162c:	48 89 fa             	mov    %rdi,%rdx
  80162f:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801632:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801637:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  80163e:	00 00 00 
  801641:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801646:	be 00 00 00 00       	mov    $0x0,%esi
  80164b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801651:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  801653:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801657:	c9                   	leave
  801658:	c3                   	ret

0000000000801659 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  801659:	f3 0f 1e fa          	endbr64
  80165d:	55                   	push   %rbp
  80165e:	48 89 e5             	mov    %rsp,%rbp
  801661:	53                   	push   %rbx
  801662:	49 89 f8             	mov    %rdi,%r8
  801665:	48 89 d3             	mov    %rdx,%rbx
  801668:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  80166b:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801670:	4c 89 c2             	mov    %r8,%rdx
  801673:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801676:	be 00 00 00 00       	mov    $0x0,%esi
  80167b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801681:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  801683:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801687:	c9                   	leave
  801688:	c3                   	ret

0000000000801689 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  801689:	f3 0f 1e fa          	endbr64
  80168d:	55                   	push   %rbp
  80168e:	48 89 e5             	mov    %rsp,%rbp
  801691:	53                   	push   %rbx
  801692:	48 83 ec 08          	sub    $0x8,%rsp
  801696:	89 f8                	mov    %edi,%eax
  801698:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  80169b:	48 63 f9             	movslq %ecx,%rdi
  80169e:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8016a1:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8016a6:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8016a9:	be 00 00 00 00       	mov    $0x0,%esi
  8016ae:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8016b4:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8016b6:	48 85 c0             	test   %rax,%rax
  8016b9:	7f 06                	jg     8016c1 <sys_alloc_region+0x38>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  8016bb:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8016bf:	c9                   	leave
  8016c0:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8016c1:	49 89 c0             	mov    %rax,%r8
  8016c4:	b9 04 00 00 00       	mov    $0x4,%ecx
  8016c9:	48 ba 18 43 80 00 00 	movabs $0x804318,%rdx
  8016d0:	00 00 00 
  8016d3:	be 26 00 00 00       	mov    $0x26,%esi
  8016d8:	48 bf 1d 42 80 00 00 	movabs $0x80421d,%rdi
  8016df:	00 00 00 
  8016e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e7:	49 b9 91 04 80 00 00 	movabs $0x800491,%r9
  8016ee:	00 00 00 
  8016f1:	41 ff d1             	call   *%r9

00000000008016f4 <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  8016f4:	f3 0f 1e fa          	endbr64
  8016f8:	55                   	push   %rbp
  8016f9:	48 89 e5             	mov    %rsp,%rbp
  8016fc:	53                   	push   %rbx
  8016fd:	48 83 ec 08          	sub    $0x8,%rsp
  801701:	89 f8                	mov    %edi,%eax
  801703:	49 89 f2             	mov    %rsi,%r10
  801706:	48 89 cf             	mov    %rcx,%rdi
  801709:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  80170c:	48 63 da             	movslq %edx,%rbx
  80170f:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801712:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801717:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80171a:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  80171d:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80171f:	48 85 c0             	test   %rax,%rax
  801722:	7f 06                	jg     80172a <sys_map_region+0x36>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  801724:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801728:	c9                   	leave
  801729:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80172a:	49 89 c0             	mov    %rax,%r8
  80172d:	b9 05 00 00 00       	mov    $0x5,%ecx
  801732:	48 ba 18 43 80 00 00 	movabs $0x804318,%rdx
  801739:	00 00 00 
  80173c:	be 26 00 00 00       	mov    $0x26,%esi
  801741:	48 bf 1d 42 80 00 00 	movabs $0x80421d,%rdi
  801748:	00 00 00 
  80174b:	b8 00 00 00 00       	mov    $0x0,%eax
  801750:	49 b9 91 04 80 00 00 	movabs $0x800491,%r9
  801757:	00 00 00 
  80175a:	41 ff d1             	call   *%r9

000000000080175d <sys_map_physical_region>:

int
sys_map_physical_region(uintptr_t pa, envid_t dstenv, void *dstva, size_t size, int perm) {
  80175d:	f3 0f 1e fa          	endbr64
  801761:	55                   	push   %rbp
  801762:	48 89 e5             	mov    %rsp,%rbp
  801765:	53                   	push   %rbx
  801766:	48 83 ec 08          	sub    $0x8,%rsp
  80176a:	49 89 f9             	mov    %rdi,%r9
  80176d:	89 f0                	mov    %esi,%eax
  80176f:	48 89 d3             	mov    %rdx,%rbx
  801772:	48 89 cf             	mov    %rcx,%rdi
    int res = syscall(SYS_map_physical_region, 1, pa, dstenv, (uintptr_t)dstva, size, perm, 0);
  801775:	49 63 f0             	movslq %r8d,%rsi
  801778:	48 63 c8             	movslq %eax,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80177b:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801780:	4c 89 ca             	mov    %r9,%rdx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801783:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801789:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80178b:	48 85 c0             	test   %rax,%rax
  80178e:	7f 06                	jg     801796 <sys_map_physical_region+0x39>
#ifdef SANITIZE_USER_SHADOW_BASE
    platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  801790:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801794:	c9                   	leave
  801795:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801796:	49 89 c0             	mov    %rax,%r8
  801799:	b9 06 00 00 00       	mov    $0x6,%ecx
  80179e:	48 ba 18 43 80 00 00 	movabs $0x804318,%rdx
  8017a5:	00 00 00 
  8017a8:	be 26 00 00 00       	mov    $0x26,%esi
  8017ad:	48 bf 1d 42 80 00 00 	movabs $0x80421d,%rdi
  8017b4:	00 00 00 
  8017b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8017bc:	49 b9 91 04 80 00 00 	movabs $0x800491,%r9
  8017c3:	00 00 00 
  8017c6:	41 ff d1             	call   *%r9

00000000008017c9 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  8017c9:	f3 0f 1e fa          	endbr64
  8017cd:	55                   	push   %rbp
  8017ce:	48 89 e5             	mov    %rsp,%rbp
  8017d1:	53                   	push   %rbx
  8017d2:	48 83 ec 08          	sub    $0x8,%rsp
  8017d6:	48 89 f1             	mov    %rsi,%rcx
  8017d9:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  8017dc:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8017df:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8017e4:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8017e9:	be 00 00 00 00       	mov    $0x0,%esi
  8017ee:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8017f4:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8017f6:	48 85 c0             	test   %rax,%rax
  8017f9:	7f 06                	jg     801801 <sys_unmap_region+0x38>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  8017fb:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8017ff:	c9                   	leave
  801800:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801801:	49 89 c0             	mov    %rax,%r8
  801804:	b9 07 00 00 00       	mov    $0x7,%ecx
  801809:	48 ba 18 43 80 00 00 	movabs $0x804318,%rdx
  801810:	00 00 00 
  801813:	be 26 00 00 00       	mov    $0x26,%esi
  801818:	48 bf 1d 42 80 00 00 	movabs $0x80421d,%rdi
  80181f:	00 00 00 
  801822:	b8 00 00 00 00       	mov    $0x0,%eax
  801827:	49 b9 91 04 80 00 00 	movabs $0x800491,%r9
  80182e:	00 00 00 
  801831:	41 ff d1             	call   *%r9

0000000000801834 <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  801834:	f3 0f 1e fa          	endbr64
  801838:	55                   	push   %rbp
  801839:	48 89 e5             	mov    %rsp,%rbp
  80183c:	53                   	push   %rbx
  80183d:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  801841:	48 63 ce             	movslq %esi,%rcx
  801844:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801847:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80184c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801851:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801856:	be 00 00 00 00       	mov    $0x0,%esi
  80185b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801861:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801863:	48 85 c0             	test   %rax,%rax
  801866:	7f 06                	jg     80186e <sys_env_set_status+0x3a>
}
  801868:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80186c:	c9                   	leave
  80186d:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80186e:	49 89 c0             	mov    %rax,%r8
  801871:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801876:	48 ba 18 43 80 00 00 	movabs $0x804318,%rdx
  80187d:	00 00 00 
  801880:	be 26 00 00 00       	mov    $0x26,%esi
  801885:	48 bf 1d 42 80 00 00 	movabs $0x80421d,%rdi
  80188c:	00 00 00 
  80188f:	b8 00 00 00 00       	mov    $0x0,%eax
  801894:	49 b9 91 04 80 00 00 	movabs $0x800491,%r9
  80189b:	00 00 00 
  80189e:	41 ff d1             	call   *%r9

00000000008018a1 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  8018a1:	f3 0f 1e fa          	endbr64
  8018a5:	55                   	push   %rbp
  8018a6:	48 89 e5             	mov    %rsp,%rbp
  8018a9:	53                   	push   %rbx
  8018aa:	48 83 ec 08          	sub    $0x8,%rsp
  8018ae:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  8018b1:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8018b4:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8018b9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018be:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8018c3:	be 00 00 00 00       	mov    $0x0,%esi
  8018c8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8018ce:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8018d0:	48 85 c0             	test   %rax,%rax
  8018d3:	7f 06                	jg     8018db <sys_env_set_trapframe+0x3a>
}
  8018d5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8018d9:	c9                   	leave
  8018da:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8018db:	49 89 c0             	mov    %rax,%r8
  8018de:	b9 0b 00 00 00       	mov    $0xb,%ecx
  8018e3:	48 ba 18 43 80 00 00 	movabs $0x804318,%rdx
  8018ea:	00 00 00 
  8018ed:	be 26 00 00 00       	mov    $0x26,%esi
  8018f2:	48 bf 1d 42 80 00 00 	movabs $0x80421d,%rdi
  8018f9:	00 00 00 
  8018fc:	b8 00 00 00 00       	mov    $0x0,%eax
  801901:	49 b9 91 04 80 00 00 	movabs $0x800491,%r9
  801908:	00 00 00 
  80190b:	41 ff d1             	call   *%r9

000000000080190e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  80190e:	f3 0f 1e fa          	endbr64
  801912:	55                   	push   %rbp
  801913:	48 89 e5             	mov    %rsp,%rbp
  801916:	53                   	push   %rbx
  801917:	48 83 ec 08          	sub    $0x8,%rsp
  80191b:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  80191e:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801921:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801926:	bb 00 00 00 00       	mov    $0x0,%ebx
  80192b:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801930:	be 00 00 00 00       	mov    $0x0,%esi
  801935:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80193b:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80193d:	48 85 c0             	test   %rax,%rax
  801940:	7f 06                	jg     801948 <sys_env_set_pgfault_upcall+0x3a>
}
  801942:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801946:	c9                   	leave
  801947:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801948:	49 89 c0             	mov    %rax,%r8
  80194b:	b9 0c 00 00 00       	mov    $0xc,%ecx
  801950:	48 ba 18 43 80 00 00 	movabs $0x804318,%rdx
  801957:	00 00 00 
  80195a:	be 26 00 00 00       	mov    $0x26,%esi
  80195f:	48 bf 1d 42 80 00 00 	movabs $0x80421d,%rdi
  801966:	00 00 00 
  801969:	b8 00 00 00 00       	mov    $0x0,%eax
  80196e:	49 b9 91 04 80 00 00 	movabs $0x800491,%r9
  801975:	00 00 00 
  801978:	41 ff d1             	call   *%r9

000000000080197b <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  80197b:	f3 0f 1e fa          	endbr64
  80197f:	55                   	push   %rbp
  801980:	48 89 e5             	mov    %rsp,%rbp
  801983:	53                   	push   %rbx
  801984:	89 f8                	mov    %edi,%eax
  801986:	49 89 f1             	mov    %rsi,%r9
  801989:	48 89 d3             	mov    %rdx,%rbx
  80198c:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  80198f:	49 63 f0             	movslq %r8d,%rsi
  801992:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801995:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80199a:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80199d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8019a3:	cd 30                	int    $0x30
}
  8019a5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8019a9:	c9                   	leave
  8019aa:	c3                   	ret

00000000008019ab <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  8019ab:	f3 0f 1e fa          	endbr64
  8019af:	55                   	push   %rbp
  8019b0:	48 89 e5             	mov    %rsp,%rbp
  8019b3:	53                   	push   %rbx
  8019b4:	48 83 ec 08          	sub    $0x8,%rsp
  8019b8:	48 89 fa             	mov    %rdi,%rdx
  8019bb:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8019be:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8019c3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019c8:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8019cd:	be 00 00 00 00       	mov    $0x0,%esi
  8019d2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8019d8:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8019da:	48 85 c0             	test   %rax,%rax
  8019dd:	7f 06                	jg     8019e5 <sys_ipc_recv+0x3a>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  8019df:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8019e3:	c9                   	leave
  8019e4:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8019e5:	49 89 c0             	mov    %rax,%r8
  8019e8:	b9 0f 00 00 00       	mov    $0xf,%ecx
  8019ed:	48 ba 18 43 80 00 00 	movabs $0x804318,%rdx
  8019f4:	00 00 00 
  8019f7:	be 26 00 00 00       	mov    $0x26,%esi
  8019fc:	48 bf 1d 42 80 00 00 	movabs $0x80421d,%rdi
  801a03:	00 00 00 
  801a06:	b8 00 00 00 00       	mov    $0x0,%eax
  801a0b:	49 b9 91 04 80 00 00 	movabs $0x800491,%r9
  801a12:	00 00 00 
  801a15:	41 ff d1             	call   *%r9

0000000000801a18 <sys_gettime>:

int
sys_gettime(void) {
  801a18:	f3 0f 1e fa          	endbr64
  801a1c:	55                   	push   %rbp
  801a1d:	48 89 e5             	mov    %rsp,%rbp
  801a20:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801a21:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801a26:	ba 00 00 00 00       	mov    $0x0,%edx
  801a2b:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801a30:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a35:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801a3a:	be 00 00 00 00       	mov    $0x0,%esi
  801a3f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801a45:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  801a47:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801a4b:	c9                   	leave
  801a4c:	c3                   	ret

0000000000801a4d <fd2num>:


/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
  801a4d:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801a51:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801a58:	ff ff ff 
  801a5b:	48 01 f8             	add    %rdi,%rax
  801a5e:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801a62:	c3                   	ret

0000000000801a63 <fd2data>:

char *
fd2data(struct Fd *fd) {
  801a63:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801a67:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801a6e:	ff ff ff 
  801a71:	48 01 f8             	add    %rdi,%rax
  801a74:	48 c1 e8 0c          	shr    $0xc,%rax
    return INDEX2DATA(fd2num(fd));
  801a78:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801a7e:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801a82:	c3                   	ret

0000000000801a83 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  801a83:	f3 0f 1e fa          	endbr64
  801a87:	55                   	push   %rbp
  801a88:	48 89 e5             	mov    %rsp,%rbp
  801a8b:	41 57                	push   %r15
  801a8d:	41 56                	push   %r14
  801a8f:	41 55                	push   %r13
  801a91:	41 54                	push   %r12
  801a93:	53                   	push   %rbx
  801a94:	48 83 ec 08          	sub    $0x8,%rsp
  801a98:	49 89 ff             	mov    %rdi,%r15
  801a9b:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  801aa0:	49 bd 9a 2d 80 00 00 	movabs $0x802d9a,%r13
  801aa7:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  801aaa:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        struct Fd *fd = INDEX2FD(i);
  801ab0:	49 89 dc             	mov    %rbx,%r12
        if (!(get_prot(fd) & PROT_R)) {
  801ab3:	48 89 df             	mov    %rbx,%rdi
  801ab6:	41 ff d5             	call   *%r13
  801ab9:	83 e0 04             	and    $0x4,%eax
  801abc:	74 17                	je     801ad5 <fd_alloc+0x52>
    for (int i = 0; i < MAXFD; i++) {
  801abe:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  801ac5:	4c 39 f3             	cmp    %r14,%rbx
  801ac8:	75 e6                	jne    801ab0 <fd_alloc+0x2d>
  801aca:	41 bc 00 00 00 00    	mov    $0x0,%r12d
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
    return -E_MAX_OPEN;
  801ad0:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
            *fd_store = fd;
  801ad5:	4d 89 27             	mov    %r12,(%r15)
}
  801ad8:	48 83 c4 08          	add    $0x8,%rsp
  801adc:	5b                   	pop    %rbx
  801add:	41 5c                	pop    %r12
  801adf:	41 5d                	pop    %r13
  801ae1:	41 5e                	pop    %r14
  801ae3:	41 5f                	pop    %r15
  801ae5:	5d                   	pop    %rbp
  801ae6:	c3                   	ret

0000000000801ae7 <fd_lookup>:
 *
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
  801ae7:	f3 0f 1e fa          	endbr64
    if (fdnum < 0 || fdnum >= MAXFD) {
  801aeb:	83 ff 1f             	cmp    $0x1f,%edi
  801aee:	77 39                	ja     801b29 <fd_lookup+0x42>
fd_lookup(int fdnum, struct Fd **fd_store) {
  801af0:	55                   	push   %rbp
  801af1:	48 89 e5             	mov    %rsp,%rbp
  801af4:	41 54                	push   %r12
  801af6:	53                   	push   %rbx
  801af7:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  801afa:	48 63 df             	movslq %edi,%rbx
  801afd:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  801b04:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  801b08:	48 89 df             	mov    %rbx,%rdi
  801b0b:	48 b8 9a 2d 80 00 00 	movabs $0x802d9a,%rax
  801b12:	00 00 00 
  801b15:	ff d0                	call   *%rax
  801b17:	a8 04                	test   $0x4,%al
  801b19:	74 14                	je     801b2f <fd_lookup+0x48>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  801b1b:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  801b1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b24:	5b                   	pop    %rbx
  801b25:	41 5c                	pop    %r12
  801b27:	5d                   	pop    %rbp
  801b28:	c3                   	ret
        return -E_INVAL;
  801b29:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801b2e:	c3                   	ret
        return -E_INVAL;
  801b2f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b34:	eb ee                	jmp    801b24 <fd_lookup+0x3d>

0000000000801b36 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  801b36:	f3 0f 1e fa          	endbr64
  801b3a:	55                   	push   %rbp
  801b3b:	48 89 e5             	mov    %rsp,%rbp
  801b3e:	41 54                	push   %r12
  801b40:	53                   	push   %rbx
  801b41:	49 89 f4             	mov    %rsi,%r12
    for (size_t i = 0; devtab[i]; i++) {
  801b44:	48 b8 20 47 80 00 00 	movabs $0x804720,%rax
  801b4b:	00 00 00 
  801b4e:	48 bb 40 50 80 00 00 	movabs $0x805040,%rbx
  801b55:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  801b58:	39 3b                	cmp    %edi,(%rbx)
  801b5a:	74 47                	je     801ba3 <dev_lookup+0x6d>
    for (size_t i = 0; devtab[i]; i++) {
  801b5c:	48 83 c0 08          	add    $0x8,%rax
  801b60:	48 8b 18             	mov    (%rax),%rbx
  801b63:	48 85 db             	test   %rbx,%rbx
  801b66:	75 f0                	jne    801b58 <dev_lookup+0x22>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801b68:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801b6f:	00 00 00 
  801b72:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801b78:	89 fa                	mov    %edi,%edx
  801b7a:	48 bf 38 43 80 00 00 	movabs $0x804338,%rdi
  801b81:	00 00 00 
  801b84:	b8 00 00 00 00       	mov    $0x0,%eax
  801b89:	48 b9 ed 05 80 00 00 	movabs $0x8005ed,%rcx
  801b90:	00 00 00 
  801b93:	ff d1                	call   *%rcx
    *dev = 0;
    return -E_INVAL;
  801b95:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
            *dev = devtab[i];
  801b9a:	49 89 1c 24          	mov    %rbx,(%r12)
}
  801b9e:	5b                   	pop    %rbx
  801b9f:	41 5c                	pop    %r12
  801ba1:	5d                   	pop    %rbp
  801ba2:	c3                   	ret
            return 0;
  801ba3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ba8:	eb f0                	jmp    801b9a <dev_lookup+0x64>

0000000000801baa <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  801baa:	f3 0f 1e fa          	endbr64
  801bae:	55                   	push   %rbp
  801baf:	48 89 e5             	mov    %rsp,%rbp
  801bb2:	41 55                	push   %r13
  801bb4:	41 54                	push   %r12
  801bb6:	53                   	push   %rbx
  801bb7:	48 83 ec 18          	sub    $0x18,%rsp
  801bbb:	48 89 fb             	mov    %rdi,%rbx
  801bbe:	41 89 f4             	mov    %esi,%r12d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801bc1:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  801bc8:	ff ff ff 
  801bcb:	48 01 df             	add    %rbx,%rdi
  801bce:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  801bd2:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801bd6:	48 b8 e7 1a 80 00 00 	movabs $0x801ae7,%rax
  801bdd:	00 00 00 
  801be0:	ff d0                	call   *%rax
  801be2:	41 89 c5             	mov    %eax,%r13d
  801be5:	85 c0                	test   %eax,%eax
  801be7:	78 06                	js     801bef <fd_close+0x45>
  801be9:	48 39 5d d8          	cmp    %rbx,-0x28(%rbp)
  801bed:	74 1a                	je     801c09 <fd_close+0x5f>
        return (must_exist ? res : 0);
  801bef:	45 84 e4             	test   %r12b,%r12b
  801bf2:	b8 00 00 00 00       	mov    $0x0,%eax
  801bf7:	44 0f 44 e8          	cmove  %eax,%r13d
}
  801bfb:	44 89 e8             	mov    %r13d,%eax
  801bfe:	48 83 c4 18          	add    $0x18,%rsp
  801c02:	5b                   	pop    %rbx
  801c03:	41 5c                	pop    %r12
  801c05:	41 5d                	pop    %r13
  801c07:	5d                   	pop    %rbp
  801c08:	c3                   	ret
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801c09:	8b 3b                	mov    (%rbx),%edi
  801c0b:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801c0f:	48 b8 36 1b 80 00 00 	movabs $0x801b36,%rax
  801c16:	00 00 00 
  801c19:	ff d0                	call   *%rax
  801c1b:	41 89 c5             	mov    %eax,%r13d
  801c1e:	85 c0                	test   %eax,%eax
  801c20:	78 1b                	js     801c3d <fd_close+0x93>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  801c22:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801c26:	48 8b 40 20          	mov    0x20(%rax),%rax
  801c2a:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  801c30:	48 85 c0             	test   %rax,%rax
  801c33:	74 08                	je     801c3d <fd_close+0x93>
  801c35:	48 89 df             	mov    %rbx,%rdi
  801c38:	ff d0                	call   *%rax
  801c3a:	41 89 c5             	mov    %eax,%r13d
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801c3d:	ba 00 10 00 00       	mov    $0x1000,%edx
  801c42:	48 89 de             	mov    %rbx,%rsi
  801c45:	bf 00 00 00 00       	mov    $0x0,%edi
  801c4a:	48 b8 c9 17 80 00 00 	movabs $0x8017c9,%rax
  801c51:	00 00 00 
  801c54:	ff d0                	call   *%rax
    return res;
  801c56:	eb a3                	jmp    801bfb <fd_close+0x51>

0000000000801c58 <close>:

int
close(int fdnum) {
  801c58:	f3 0f 1e fa          	endbr64
  801c5c:	55                   	push   %rbp
  801c5d:	48 89 e5             	mov    %rsp,%rbp
  801c60:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  801c64:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801c68:	48 b8 e7 1a 80 00 00 	movabs $0x801ae7,%rax
  801c6f:	00 00 00 
  801c72:	ff d0                	call   *%rax
    if (res < 0) return res;
  801c74:	85 c0                	test   %eax,%eax
  801c76:	78 15                	js     801c8d <close+0x35>

    return fd_close(fd, 1);
  801c78:	be 01 00 00 00       	mov    $0x1,%esi
  801c7d:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801c81:	48 b8 aa 1b 80 00 00 	movabs $0x801baa,%rax
  801c88:	00 00 00 
  801c8b:	ff d0                	call   *%rax
}
  801c8d:	c9                   	leave
  801c8e:	c3                   	ret

0000000000801c8f <close_all>:

void
close_all(void) {
  801c8f:	f3 0f 1e fa          	endbr64
  801c93:	55                   	push   %rbp
  801c94:	48 89 e5             	mov    %rsp,%rbp
  801c97:	41 54                	push   %r12
  801c99:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  801c9a:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c9f:	49 bc 58 1c 80 00 00 	movabs $0x801c58,%r12
  801ca6:	00 00 00 
  801ca9:	89 df                	mov    %ebx,%edi
  801cab:	41 ff d4             	call   *%r12
  801cae:	83 c3 01             	add    $0x1,%ebx
  801cb1:	83 fb 20             	cmp    $0x20,%ebx
  801cb4:	75 f3                	jne    801ca9 <close_all+0x1a>
}
  801cb6:	5b                   	pop    %rbx
  801cb7:	41 5c                	pop    %r12
  801cb9:	5d                   	pop    %rbp
  801cba:	c3                   	ret

0000000000801cbb <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  801cbb:	f3 0f 1e fa          	endbr64
  801cbf:	55                   	push   %rbp
  801cc0:	48 89 e5             	mov    %rsp,%rbp
  801cc3:	41 57                	push   %r15
  801cc5:	41 56                	push   %r14
  801cc7:	41 55                	push   %r13
  801cc9:	41 54                	push   %r12
  801ccb:	53                   	push   %rbx
  801ccc:	48 83 ec 18          	sub    $0x18,%rsp
  801cd0:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  801cd3:	48 8d 75 c8          	lea    -0x38(%rbp),%rsi
  801cd7:	48 b8 e7 1a 80 00 00 	movabs $0x801ae7,%rax
  801cde:	00 00 00 
  801ce1:	ff d0                	call   *%rax
  801ce3:	89 c3                	mov    %eax,%ebx
  801ce5:	85 c0                	test   %eax,%eax
  801ce7:	0f 88 b8 00 00 00    	js     801da5 <dup+0xea>
    close(newfdnum);
  801ced:	44 89 e7             	mov    %r12d,%edi
  801cf0:	48 b8 58 1c 80 00 00 	movabs $0x801c58,%rax
  801cf7:	00 00 00 
  801cfa:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  801cfc:	4d 63 ec             	movslq %r12d,%r13
  801cff:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  801d06:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  801d0a:	4c 8b 7d c8          	mov    -0x38(%rbp),%r15
  801d0e:	4c 89 ff             	mov    %r15,%rdi
  801d11:	49 be 63 1a 80 00 00 	movabs $0x801a63,%r14
  801d18:	00 00 00 
  801d1b:	41 ff d6             	call   *%r14
  801d1e:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  801d21:	4c 89 ef             	mov    %r13,%rdi
  801d24:	41 ff d6             	call   *%r14
  801d27:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  801d2a:	48 89 df             	mov    %rbx,%rdi
  801d2d:	48 b8 9a 2d 80 00 00 	movabs $0x802d9a,%rax
  801d34:	00 00 00 
  801d37:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  801d39:	a8 04                	test   $0x4,%al
  801d3b:	74 2b                	je     801d68 <dup+0xad>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  801d3d:	41 89 c1             	mov    %eax,%r9d
  801d40:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801d46:	4c 89 f1             	mov    %r14,%rcx
  801d49:	ba 00 00 00 00       	mov    $0x0,%edx
  801d4e:	48 89 de             	mov    %rbx,%rsi
  801d51:	bf 00 00 00 00       	mov    $0x0,%edi
  801d56:	48 b8 f4 16 80 00 00 	movabs $0x8016f4,%rax
  801d5d:	00 00 00 
  801d60:	ff d0                	call   *%rax
  801d62:	89 c3                	mov    %eax,%ebx
  801d64:	85 c0                	test   %eax,%eax
  801d66:	78 4e                	js     801db6 <dup+0xfb>
    }
    prot = get_prot(oldfd);
  801d68:	4c 89 ff             	mov    %r15,%rdi
  801d6b:	48 b8 9a 2d 80 00 00 	movabs $0x802d9a,%rax
  801d72:	00 00 00 
  801d75:	ff d0                	call   *%rax
  801d77:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  801d7a:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801d80:	4c 89 e9             	mov    %r13,%rcx
  801d83:	ba 00 00 00 00       	mov    $0x0,%edx
  801d88:	4c 89 fe             	mov    %r15,%rsi
  801d8b:	bf 00 00 00 00       	mov    $0x0,%edi
  801d90:	48 b8 f4 16 80 00 00 	movabs $0x8016f4,%rax
  801d97:	00 00 00 
  801d9a:	ff d0                	call   *%rax
  801d9c:	89 c3                	mov    %eax,%ebx
  801d9e:	85 c0                	test   %eax,%eax
  801da0:	78 14                	js     801db6 <dup+0xfb>

    return newfdnum;
  801da2:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  801da5:	89 d8                	mov    %ebx,%eax
  801da7:	48 83 c4 18          	add    $0x18,%rsp
  801dab:	5b                   	pop    %rbx
  801dac:	41 5c                	pop    %r12
  801dae:	41 5d                	pop    %r13
  801db0:	41 5e                	pop    %r14
  801db2:	41 5f                	pop    %r15
  801db4:	5d                   	pop    %rbp
  801db5:	c3                   	ret
    sys_unmap_region(0, newfd, PAGE_SIZE);
  801db6:	ba 00 10 00 00       	mov    $0x1000,%edx
  801dbb:	4c 89 ee             	mov    %r13,%rsi
  801dbe:	bf 00 00 00 00       	mov    $0x0,%edi
  801dc3:	49 bc c9 17 80 00 00 	movabs $0x8017c9,%r12
  801dca:	00 00 00 
  801dcd:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  801dd0:	ba 00 10 00 00       	mov    $0x1000,%edx
  801dd5:	4c 89 f6             	mov    %r14,%rsi
  801dd8:	bf 00 00 00 00       	mov    $0x0,%edi
  801ddd:	41 ff d4             	call   *%r12
    return res;
  801de0:	eb c3                	jmp    801da5 <dup+0xea>

0000000000801de2 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  801de2:	f3 0f 1e fa          	endbr64
  801de6:	55                   	push   %rbp
  801de7:	48 89 e5             	mov    %rsp,%rbp
  801dea:	41 56                	push   %r14
  801dec:	41 55                	push   %r13
  801dee:	41 54                	push   %r12
  801df0:	53                   	push   %rbx
  801df1:	48 83 ec 10          	sub    $0x10,%rsp
  801df5:	89 fb                	mov    %edi,%ebx
  801df7:	49 89 f4             	mov    %rsi,%r12
  801dfa:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801dfd:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801e01:	48 b8 e7 1a 80 00 00 	movabs $0x801ae7,%rax
  801e08:	00 00 00 
  801e0b:	ff d0                	call   *%rax
  801e0d:	85 c0                	test   %eax,%eax
  801e0f:	78 4c                	js     801e5d <read+0x7b>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801e11:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801e15:	41 8b 3e             	mov    (%r14),%edi
  801e18:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801e1c:	48 b8 36 1b 80 00 00 	movabs $0x801b36,%rax
  801e23:	00 00 00 
  801e26:	ff d0                	call   *%rax
  801e28:	85 c0                	test   %eax,%eax
  801e2a:	78 35                	js     801e61 <read+0x7f>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801e2c:	41 8b 46 08          	mov    0x8(%r14),%eax
  801e30:	83 e0 03             	and    $0x3,%eax
  801e33:	83 f8 01             	cmp    $0x1,%eax
  801e36:	74 2d                	je     801e65 <read+0x83>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  801e38:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801e3c:	48 8b 40 10          	mov    0x10(%rax),%rax
  801e40:	48 85 c0             	test   %rax,%rax
  801e43:	74 56                	je     801e9b <read+0xb9>

    return (*dev->dev_read)(fd, buf, n);
  801e45:	4c 89 ea             	mov    %r13,%rdx
  801e48:	4c 89 e6             	mov    %r12,%rsi
  801e4b:	4c 89 f7             	mov    %r14,%rdi
  801e4e:	ff d0                	call   *%rax
}
  801e50:	48 83 c4 10          	add    $0x10,%rsp
  801e54:	5b                   	pop    %rbx
  801e55:	41 5c                	pop    %r12
  801e57:	41 5d                	pop    %r13
  801e59:	41 5e                	pop    %r14
  801e5b:	5d                   	pop    %rbp
  801e5c:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801e5d:	48 98                	cltq
  801e5f:	eb ef                	jmp    801e50 <read+0x6e>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801e61:	48 98                	cltq
  801e63:	eb eb                	jmp    801e50 <read+0x6e>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801e65:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801e6c:	00 00 00 
  801e6f:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801e75:	89 da                	mov    %ebx,%edx
  801e77:	48 bf 2b 42 80 00 00 	movabs $0x80422b,%rdi
  801e7e:	00 00 00 
  801e81:	b8 00 00 00 00       	mov    $0x0,%eax
  801e86:	48 b9 ed 05 80 00 00 	movabs $0x8005ed,%rcx
  801e8d:	00 00 00 
  801e90:	ff d1                	call   *%rcx
        return -E_INVAL;
  801e92:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801e99:	eb b5                	jmp    801e50 <read+0x6e>
    if (!dev->dev_read) return -E_NOT_SUPP;
  801e9b:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801ea2:	eb ac                	jmp    801e50 <read+0x6e>

0000000000801ea4 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801ea4:	f3 0f 1e fa          	endbr64
  801ea8:	55                   	push   %rbp
  801ea9:	48 89 e5             	mov    %rsp,%rbp
  801eac:	41 57                	push   %r15
  801eae:	41 56                	push   %r14
  801eb0:	41 55                	push   %r13
  801eb2:	41 54                	push   %r12
  801eb4:	53                   	push   %rbx
  801eb5:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801eb9:	48 85 d2             	test   %rdx,%rdx
  801ebc:	74 54                	je     801f12 <readn+0x6e>
  801ebe:	41 89 fd             	mov    %edi,%r13d
  801ec1:	49 89 f6             	mov    %rsi,%r14
  801ec4:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801ec7:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801ecc:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801ed1:	49 bf e2 1d 80 00 00 	movabs $0x801de2,%r15
  801ed8:	00 00 00 
  801edb:	4c 89 e2             	mov    %r12,%rdx
  801ede:	48 29 f2             	sub    %rsi,%rdx
  801ee1:	4c 01 f6             	add    %r14,%rsi
  801ee4:	44 89 ef             	mov    %r13d,%edi
  801ee7:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  801eea:	85 c0                	test   %eax,%eax
  801eec:	78 20                	js     801f0e <readn+0x6a>
    for (; inc && res < n; res += inc) {
  801eee:	01 c3                	add    %eax,%ebx
  801ef0:	85 c0                	test   %eax,%eax
  801ef2:	74 08                	je     801efc <readn+0x58>
  801ef4:	48 63 f3             	movslq %ebx,%rsi
  801ef7:	4c 39 e6             	cmp    %r12,%rsi
  801efa:	72 df                	jb     801edb <readn+0x37>
    }
    return res;
  801efc:	48 63 c3             	movslq %ebx,%rax
}
  801eff:	48 83 c4 08          	add    $0x8,%rsp
  801f03:	5b                   	pop    %rbx
  801f04:	41 5c                	pop    %r12
  801f06:	41 5d                	pop    %r13
  801f08:	41 5e                	pop    %r14
  801f0a:	41 5f                	pop    %r15
  801f0c:	5d                   	pop    %rbp
  801f0d:	c3                   	ret
        if (inc < 0) return inc;
  801f0e:	48 98                	cltq
  801f10:	eb ed                	jmp    801eff <readn+0x5b>
    int inc = 1, res = 0;
  801f12:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f17:	eb e3                	jmp    801efc <readn+0x58>

0000000000801f19 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  801f19:	f3 0f 1e fa          	endbr64
  801f1d:	55                   	push   %rbp
  801f1e:	48 89 e5             	mov    %rsp,%rbp
  801f21:	41 56                	push   %r14
  801f23:	41 55                	push   %r13
  801f25:	41 54                	push   %r12
  801f27:	53                   	push   %rbx
  801f28:	48 83 ec 10          	sub    $0x10,%rsp
  801f2c:	89 fb                	mov    %edi,%ebx
  801f2e:	49 89 f4             	mov    %rsi,%r12
  801f31:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801f34:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801f38:	48 b8 e7 1a 80 00 00 	movabs $0x801ae7,%rax
  801f3f:	00 00 00 
  801f42:	ff d0                	call   *%rax
  801f44:	85 c0                	test   %eax,%eax
  801f46:	78 47                	js     801f8f <write+0x76>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801f48:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801f4c:	41 8b 3e             	mov    (%r14),%edi
  801f4f:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801f53:	48 b8 36 1b 80 00 00 	movabs $0x801b36,%rax
  801f5a:	00 00 00 
  801f5d:	ff d0                	call   *%rax
  801f5f:	85 c0                	test   %eax,%eax
  801f61:	78 30                	js     801f93 <write+0x7a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801f63:	41 f6 46 08 03       	testb  $0x3,0x8(%r14)
  801f68:	74 2d                	je     801f97 <write+0x7e>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801f6a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801f6e:	48 8b 40 18          	mov    0x18(%rax),%rax
  801f72:	48 85 c0             	test   %rax,%rax
  801f75:	74 56                	je     801fcd <write+0xb4>

    return (*dev->dev_write)(fd, buf, n);
  801f77:	4c 89 ea             	mov    %r13,%rdx
  801f7a:	4c 89 e6             	mov    %r12,%rsi
  801f7d:	4c 89 f7             	mov    %r14,%rdi
  801f80:	ff d0                	call   *%rax
}
  801f82:	48 83 c4 10          	add    $0x10,%rsp
  801f86:	5b                   	pop    %rbx
  801f87:	41 5c                	pop    %r12
  801f89:	41 5d                	pop    %r13
  801f8b:	41 5e                	pop    %r14
  801f8d:	5d                   	pop    %rbp
  801f8e:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801f8f:	48 98                	cltq
  801f91:	eb ef                	jmp    801f82 <write+0x69>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801f93:	48 98                	cltq
  801f95:	eb eb                	jmp    801f82 <write+0x69>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801f97:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801f9e:	00 00 00 
  801fa1:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801fa7:	89 da                	mov    %ebx,%edx
  801fa9:	48 bf 47 42 80 00 00 	movabs $0x804247,%rdi
  801fb0:	00 00 00 
  801fb3:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb8:	48 b9 ed 05 80 00 00 	movabs $0x8005ed,%rcx
  801fbf:	00 00 00 
  801fc2:	ff d1                	call   *%rcx
        return -E_INVAL;
  801fc4:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801fcb:	eb b5                	jmp    801f82 <write+0x69>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801fcd:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801fd4:	eb ac                	jmp    801f82 <write+0x69>

0000000000801fd6 <seek>:

int
seek(int fdnum, off_t offset) {
  801fd6:	f3 0f 1e fa          	endbr64
  801fda:	55                   	push   %rbp
  801fdb:	48 89 e5             	mov    %rsp,%rbp
  801fde:	53                   	push   %rbx
  801fdf:	48 83 ec 18          	sub    $0x18,%rsp
  801fe3:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801fe5:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801fe9:	48 b8 e7 1a 80 00 00 	movabs $0x801ae7,%rax
  801ff0:	00 00 00 
  801ff3:	ff d0                	call   *%rax
  801ff5:	85 c0                	test   %eax,%eax
  801ff7:	78 0c                	js     802005 <seek+0x2f>

    fd->fd_offset = offset;
  801ff9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ffd:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  802000:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802005:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  802009:	c9                   	leave
  80200a:	c3                   	ret

000000000080200b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  80200b:	f3 0f 1e fa          	endbr64
  80200f:	55                   	push   %rbp
  802010:	48 89 e5             	mov    %rsp,%rbp
  802013:	41 55                	push   %r13
  802015:	41 54                	push   %r12
  802017:	53                   	push   %rbx
  802018:	48 83 ec 18          	sub    $0x18,%rsp
  80201c:	89 fb                	mov    %edi,%ebx
  80201e:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  802021:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  802025:	48 b8 e7 1a 80 00 00 	movabs $0x801ae7,%rax
  80202c:	00 00 00 
  80202f:	ff d0                	call   *%rax
  802031:	85 c0                	test   %eax,%eax
  802033:	78 38                	js     80206d <ftruncate+0x62>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  802035:	4c 8b 6d d8          	mov    -0x28(%rbp),%r13
  802039:	41 8b 7d 00          	mov    0x0(%r13),%edi
  80203d:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  802041:	48 b8 36 1b 80 00 00 	movabs $0x801b36,%rax
  802048:	00 00 00 
  80204b:	ff d0                	call   *%rax
  80204d:	85 c0                	test   %eax,%eax
  80204f:	78 1c                	js     80206d <ftruncate+0x62>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802051:	41 f6 45 08 03       	testb  $0x3,0x8(%r13)
  802056:	74 20                	je     802078 <ftruncate+0x6d>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  802058:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80205c:	48 8b 40 30          	mov    0x30(%rax),%rax
  802060:	48 85 c0             	test   %rax,%rax
  802063:	74 47                	je     8020ac <ftruncate+0xa1>

    return (*dev->dev_trunc)(fd, newsize);
  802065:	44 89 e6             	mov    %r12d,%esi
  802068:	4c 89 ef             	mov    %r13,%rdi
  80206b:	ff d0                	call   *%rax
}
  80206d:	48 83 c4 18          	add    $0x18,%rsp
  802071:	5b                   	pop    %rbx
  802072:	41 5c                	pop    %r12
  802074:	41 5d                	pop    %r13
  802076:	5d                   	pop    %rbp
  802077:	c3                   	ret
                thisenv->env_id, fdnum);
  802078:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  80207f:	00 00 00 
  802082:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  802088:	89 da                	mov    %ebx,%edx
  80208a:	48 bf 58 43 80 00 00 	movabs $0x804358,%rdi
  802091:	00 00 00 
  802094:	b8 00 00 00 00       	mov    $0x0,%eax
  802099:	48 b9 ed 05 80 00 00 	movabs $0x8005ed,%rcx
  8020a0:	00 00 00 
  8020a3:	ff d1                	call   *%rcx
        return -E_INVAL;
  8020a5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8020aa:	eb c1                	jmp    80206d <ftruncate+0x62>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  8020ac:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  8020b1:	eb ba                	jmp    80206d <ftruncate+0x62>

00000000008020b3 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  8020b3:	f3 0f 1e fa          	endbr64
  8020b7:	55                   	push   %rbp
  8020b8:	48 89 e5             	mov    %rsp,%rbp
  8020bb:	41 54                	push   %r12
  8020bd:	53                   	push   %rbx
  8020be:	48 83 ec 10          	sub    $0x10,%rsp
  8020c2:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8020c5:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  8020c9:	48 b8 e7 1a 80 00 00 	movabs $0x801ae7,%rax
  8020d0:	00 00 00 
  8020d3:	ff d0                	call   *%rax
  8020d5:	85 c0                	test   %eax,%eax
  8020d7:	78 4e                	js     802127 <fstat+0x74>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8020d9:	4c 8b 65 e8          	mov    -0x18(%rbp),%r12
  8020dd:	41 8b 3c 24          	mov    (%r12),%edi
  8020e1:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  8020e5:	48 b8 36 1b 80 00 00 	movabs $0x801b36,%rax
  8020ec:	00 00 00 
  8020ef:	ff d0                	call   *%rax
  8020f1:	85 c0                	test   %eax,%eax
  8020f3:	78 32                	js     802127 <fstat+0x74>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  8020f5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020f9:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  8020fe:	74 30                	je     802130 <fstat+0x7d>

    stat->st_name[0] = 0;
  802100:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  802103:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  80210a:	00 00 00 
    stat->st_isdir = 0;
  80210d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  802114:	00 00 00 
    stat->st_dev = dev;
  802117:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  80211e:	48 89 de             	mov    %rbx,%rsi
  802121:	4c 89 e7             	mov    %r12,%rdi
  802124:	ff 50 28             	call   *0x28(%rax)
}
  802127:	48 83 c4 10          	add    $0x10,%rsp
  80212b:	5b                   	pop    %rbx
  80212c:	41 5c                	pop    %r12
  80212e:	5d                   	pop    %rbp
  80212f:	c3                   	ret
    if (!dev->dev_stat) return -E_NOT_SUPP;
  802130:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  802135:	eb f0                	jmp    802127 <fstat+0x74>

0000000000802137 <stat>:

int
stat(const char *path, struct Stat *stat) {
  802137:	f3 0f 1e fa          	endbr64
  80213b:	55                   	push   %rbp
  80213c:	48 89 e5             	mov    %rsp,%rbp
  80213f:	41 54                	push   %r12
  802141:	53                   	push   %rbx
  802142:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  802145:	be 00 00 00 00       	mov    $0x0,%esi
  80214a:	48 b8 18 24 80 00 00 	movabs $0x802418,%rax
  802151:	00 00 00 
  802154:	ff d0                	call   *%rax
  802156:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  802158:	85 c0                	test   %eax,%eax
  80215a:	78 25                	js     802181 <stat+0x4a>

    int res = fstat(fd, stat);
  80215c:	4c 89 e6             	mov    %r12,%rsi
  80215f:	89 c7                	mov    %eax,%edi
  802161:	48 b8 b3 20 80 00 00 	movabs $0x8020b3,%rax
  802168:	00 00 00 
  80216b:	ff d0                	call   *%rax
  80216d:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  802170:	89 df                	mov    %ebx,%edi
  802172:	48 b8 58 1c 80 00 00 	movabs $0x801c58,%rax
  802179:	00 00 00 
  80217c:	ff d0                	call   *%rax

    return res;
  80217e:	44 89 e3             	mov    %r12d,%ebx
}
  802181:	89 d8                	mov    %ebx,%eax
  802183:	5b                   	pop    %rbx
  802184:	41 5c                	pop    %r12
  802186:	5d                   	pop    %rbp
  802187:	c3                   	ret

0000000000802188 <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  802188:	f3 0f 1e fa          	endbr64
  80218c:	55                   	push   %rbp
  80218d:	48 89 e5             	mov    %rsp,%rbp
  802190:	41 54                	push   %r12
  802192:	53                   	push   %rbx
  802193:	48 83 ec 10          	sub    $0x10,%rsp
  802197:	41 89 fc             	mov    %edi,%r12d
  80219a:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  80219d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8021a4:	00 00 00 
  8021a7:	83 38 00             	cmpl   $0x0,(%rax)
  8021aa:	74 6e                	je     80221a <fsipc+0x92>

    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }
    fsenv = ipc_find_env(ENV_TYPE_FS);
  8021ac:	bf 03 00 00 00       	mov    $0x3,%edi
  8021b1:	48 b8 7c 30 80 00 00 	movabs $0x80307c,%rax
  8021b8:	00 00 00 
  8021bb:	ff d0                	call   *%rax
  8021bd:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  8021c4:	00 00 
    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  8021c6:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  8021cc:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8021d1:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8021d8:	00 00 00 
  8021db:	44 89 e6             	mov    %r12d,%esi
  8021de:	89 c7                	mov    %eax,%edi
  8021e0:	48 b8 ba 2f 80 00 00 	movabs $0x802fba,%rax
  8021e7:	00 00 00 
  8021ea:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  8021ec:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  8021f3:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  8021f4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8021f9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8021fd:	48 89 de             	mov    %rbx,%rsi
  802200:	bf 00 00 00 00       	mov    $0x0,%edi
  802205:	48 b8 21 2f 80 00 00 	movabs $0x802f21,%rax
  80220c:	00 00 00 
  80220f:	ff d0                	call   *%rax
}
  802211:	48 83 c4 10          	add    $0x10,%rsp
  802215:	5b                   	pop    %rbx
  802216:	41 5c                	pop    %r12
  802218:	5d                   	pop    %rbp
  802219:	c3                   	ret
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  80221a:	bf 03 00 00 00       	mov    $0x3,%edi
  80221f:	48 b8 7c 30 80 00 00 	movabs $0x80307c,%rax
  802226:	00 00 00 
  802229:	ff d0                	call   *%rax
  80222b:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  802232:	00 00 
  802234:	e9 73 ff ff ff       	jmp    8021ac <fsipc+0x24>

0000000000802239 <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  802239:	f3 0f 1e fa          	endbr64
  80223d:	55                   	push   %rbp
  80223e:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802241:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802248:	00 00 00 
  80224b:	8b 57 0c             	mov    0xc(%rdi),%edx
  80224e:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  802250:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  802253:	be 00 00 00 00       	mov    $0x0,%esi
  802258:	bf 02 00 00 00       	mov    $0x2,%edi
  80225d:	48 b8 88 21 80 00 00 	movabs $0x802188,%rax
  802264:	00 00 00 
  802267:	ff d0                	call   *%rax
}
  802269:	5d                   	pop    %rbp
  80226a:	c3                   	ret

000000000080226b <devfile_flush>:
devfile_flush(struct Fd *fd) {
  80226b:	f3 0f 1e fa          	endbr64
  80226f:	55                   	push   %rbp
  802270:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802273:	8b 47 0c             	mov    0xc(%rdi),%eax
  802276:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  80227d:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  80227f:	be 00 00 00 00       	mov    $0x0,%esi
  802284:	bf 06 00 00 00       	mov    $0x6,%edi
  802289:	48 b8 88 21 80 00 00 	movabs $0x802188,%rax
  802290:	00 00 00 
  802293:	ff d0                	call   *%rax
}
  802295:	5d                   	pop    %rbp
  802296:	c3                   	ret

0000000000802297 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  802297:	f3 0f 1e fa          	endbr64
  80229b:	55                   	push   %rbp
  80229c:	48 89 e5             	mov    %rsp,%rbp
  80229f:	41 54                	push   %r12
  8022a1:	53                   	push   %rbx
  8022a2:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8022a5:	8b 47 0c             	mov    0xc(%rdi),%eax
  8022a8:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  8022af:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  8022b1:	be 00 00 00 00       	mov    $0x0,%esi
  8022b6:	bf 05 00 00 00       	mov    $0x5,%edi
  8022bb:	48 b8 88 21 80 00 00 	movabs $0x802188,%rax
  8022c2:	00 00 00 
  8022c5:	ff d0                	call   *%rax
    if (res < 0) return res;
  8022c7:	85 c0                	test   %eax,%eax
  8022c9:	78 3d                	js     802308 <devfile_stat+0x71>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8022cb:	49 bc 00 70 80 00 00 	movabs $0x807000,%r12
  8022d2:	00 00 00 
  8022d5:	4c 89 e6             	mov    %r12,%rsi
  8022d8:	48 89 df             	mov    %rbx,%rdi
  8022db:	48 b8 36 0f 80 00 00 	movabs $0x800f36,%rax
  8022e2:	00 00 00 
  8022e5:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  8022e7:	41 8b 84 24 80 00 00 	mov    0x80(%r12),%eax
  8022ee:	00 
  8022ef:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8022f5:	41 8b 84 24 84 00 00 	mov    0x84(%r12),%eax
  8022fc:	00 
  8022fd:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  802303:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802308:	5b                   	pop    %rbx
  802309:	41 5c                	pop    %r12
  80230b:	5d                   	pop    %rbp
  80230c:	c3                   	ret

000000000080230d <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  80230d:	f3 0f 1e fa          	endbr64
    if (n >= sizeof(fsipcbuf.write.req_buf)) {
  802311:	48 81 fa ef 0f 00 00 	cmp    $0xfef,%rdx
  802318:	77 41                	ja     80235b <devfile_write+0x4e>
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  80231a:	55                   	push   %rbp
  80231b:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  80231e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802325:	00 00 00 
  802328:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  80232b:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.write.req_n = n;
  80232d:	48 89 50 08          	mov    %rdx,0x8(%rax)
    memmove(fsipcbuf.write.req_buf, buf, n);
  802331:	48 8d 78 10          	lea    0x10(%rax),%rdi
  802335:	48 b8 51 11 80 00 00 	movabs $0x801151,%rax
  80233c:	00 00 00 
  80233f:	ff d0                	call   *%rax
    res = fsipc(FSREQ_WRITE, NULL);
  802341:	be 00 00 00 00       	mov    $0x0,%esi
  802346:	bf 04 00 00 00       	mov    $0x4,%edi
  80234b:	48 b8 88 21 80 00 00 	movabs $0x802188,%rax
  802352:	00 00 00 
  802355:	ff d0                	call   *%rax
  802357:	48 98                	cltq
}
  802359:	5d                   	pop    %rbp
  80235a:	c3                   	ret
        return -E_INVAL;
  80235b:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
}
  802362:	c3                   	ret

0000000000802363 <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  802363:	f3 0f 1e fa          	endbr64
  802367:	55                   	push   %rbp
  802368:	48 89 e5             	mov    %rsp,%rbp
  80236b:	41 55                	push   %r13
  80236d:	41 54                	push   %r12
  80236f:	53                   	push   %rbx
  802370:	48 83 ec 08          	sub    $0x8,%rsp
  802374:	49 89 f4             	mov    %rsi,%r12
  802377:	48 89 d3             	mov    %rdx,%rbx
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  80237a:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802381:	00 00 00 
  802384:	8b 57 0c             	mov    0xc(%rdi),%edx
  802387:	89 10                	mov    %edx,(%rax)
    fsipcbuf.read.req_n = n;
  802389:	48 89 58 08          	mov    %rbx,0x8(%rax)
    res = fsipc(FSREQ_READ, NULL);
  80238d:	be 00 00 00 00       	mov    $0x0,%esi
  802392:	bf 03 00 00 00       	mov    $0x3,%edi
  802397:	48 b8 88 21 80 00 00 	movabs $0x802188,%rax
  80239e:	00 00 00 
  8023a1:	ff d0                	call   *%rax
  8023a3:	4c 63 e8             	movslq %eax,%r13
    if (res < 0) {
  8023a6:	4d 85 ed             	test   %r13,%r13
  8023a9:	78 2a                	js     8023d5 <devfile_read+0x72>
    assert(res <= n && res <= PAGE_SIZE);
  8023ab:	4c 89 ea             	mov    %r13,%rdx
  8023ae:	4c 39 eb             	cmp    %r13,%rbx
  8023b1:	72 30                	jb     8023e3 <devfile_read+0x80>
  8023b3:	49 81 fd 00 10 00 00 	cmp    $0x1000,%r13
  8023ba:	7f 27                	jg     8023e3 <devfile_read+0x80>
    memmove(buf, &fsipcbuf, res);
  8023bc:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  8023c3:	00 00 00 
  8023c6:	4c 89 e7             	mov    %r12,%rdi
  8023c9:	48 b8 51 11 80 00 00 	movabs $0x801151,%rax
  8023d0:	00 00 00 
  8023d3:	ff d0                	call   *%rax
}
  8023d5:	4c 89 e8             	mov    %r13,%rax
  8023d8:	48 83 c4 08          	add    $0x8,%rsp
  8023dc:	5b                   	pop    %rbx
  8023dd:	41 5c                	pop    %r12
  8023df:	41 5d                	pop    %r13
  8023e1:	5d                   	pop    %rbp
  8023e2:	c3                   	ret
    assert(res <= n && res <= PAGE_SIZE);
  8023e3:	48 b9 64 42 80 00 00 	movabs $0x804264,%rcx
  8023ea:	00 00 00 
  8023ed:	48 ba 81 42 80 00 00 	movabs $0x804281,%rdx
  8023f4:	00 00 00 
  8023f7:	be 7b 00 00 00       	mov    $0x7b,%esi
  8023fc:	48 bf 96 42 80 00 00 	movabs $0x804296,%rdi
  802403:	00 00 00 
  802406:	b8 00 00 00 00       	mov    $0x0,%eax
  80240b:	49 b8 91 04 80 00 00 	movabs $0x800491,%r8
  802412:	00 00 00 
  802415:	41 ff d0             	call   *%r8

0000000000802418 <open>:
open(const char *path, int mode) {
  802418:	f3 0f 1e fa          	endbr64
  80241c:	55                   	push   %rbp
  80241d:	48 89 e5             	mov    %rsp,%rbp
  802420:	41 55                	push   %r13
  802422:	41 54                	push   %r12
  802424:	53                   	push   %rbx
  802425:	48 83 ec 18          	sub    $0x18,%rsp
  802429:	49 89 fc             	mov    %rdi,%r12
  80242c:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  80242f:	48 b8 f1 0e 80 00 00 	movabs $0x800ef1,%rax
  802436:	00 00 00 
  802439:	ff d0                	call   *%rax
  80243b:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  802441:	0f 87 8a 00 00 00    	ja     8024d1 <open+0xb9>
    if ((res = fd_alloc(&fd)) < 0) return res;
  802447:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  80244b:	48 b8 83 1a 80 00 00 	movabs $0x801a83,%rax
  802452:	00 00 00 
  802455:	ff d0                	call   *%rax
  802457:	89 c3                	mov    %eax,%ebx
  802459:	85 c0                	test   %eax,%eax
  80245b:	78 50                	js     8024ad <open+0x95>
    strcpy(fsipcbuf.open.req_path, path);
  80245d:	4c 89 e6             	mov    %r12,%rsi
  802460:	48 bb 00 70 80 00 00 	movabs $0x807000,%rbx
  802467:	00 00 00 
  80246a:	48 89 df             	mov    %rbx,%rdi
  80246d:	48 b8 36 0f 80 00 00 	movabs $0x800f36,%rax
  802474:	00 00 00 
  802477:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  802479:	44 89 ab 00 04 00 00 	mov    %r13d,0x400(%rbx)
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  802480:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802484:	bf 01 00 00 00       	mov    $0x1,%edi
  802489:	48 b8 88 21 80 00 00 	movabs $0x802188,%rax
  802490:	00 00 00 
  802493:	ff d0                	call   *%rax
  802495:	89 c3                	mov    %eax,%ebx
  802497:	85 c0                	test   %eax,%eax
  802499:	78 1f                	js     8024ba <open+0xa2>
    return fd2num(fd);
  80249b:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80249f:	48 b8 4d 1a 80 00 00 	movabs $0x801a4d,%rax
  8024a6:	00 00 00 
  8024a9:	ff d0                	call   *%rax
  8024ab:	89 c3                	mov    %eax,%ebx
}
  8024ad:	89 d8                	mov    %ebx,%eax
  8024af:	48 83 c4 18          	add    $0x18,%rsp
  8024b3:	5b                   	pop    %rbx
  8024b4:	41 5c                	pop    %r12
  8024b6:	41 5d                	pop    %r13
  8024b8:	5d                   	pop    %rbp
  8024b9:	c3                   	ret
        fd_close(fd, 0);
  8024ba:	be 00 00 00 00       	mov    $0x0,%esi
  8024bf:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8024c3:	48 b8 aa 1b 80 00 00 	movabs $0x801baa,%rax
  8024ca:	00 00 00 
  8024cd:	ff d0                	call   *%rax
        return res;
  8024cf:	eb dc                	jmp    8024ad <open+0x95>
        return -E_BAD_PATH;
  8024d1:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  8024d6:	eb d5                	jmp    8024ad <open+0x95>

00000000008024d8 <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  8024d8:	f3 0f 1e fa          	endbr64
  8024dc:	55                   	push   %rbp
  8024dd:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  8024e0:	be 00 00 00 00       	mov    $0x0,%esi
  8024e5:	bf 08 00 00 00       	mov    $0x8,%edi
  8024ea:	48 b8 88 21 80 00 00 	movabs $0x802188,%rax
  8024f1:	00 00 00 
  8024f4:	ff d0                	call   *%rax
}
  8024f6:	5d                   	pop    %rbp
  8024f7:	c3                   	ret

00000000008024f8 <writebuf>:
    int error;      /* First error that occurred */
    char buf[PRINTBUFSZ];
};

static void
writebuf(struct printbuf *state) {
  8024f8:	f3 0f 1e fa          	endbr64
    if (state->error > 0) {
  8024fc:	83 7f 10 00          	cmpl   $0x0,0x10(%rdi)
  802500:	7f 01                	jg     802503 <writebuf+0xb>
  802502:	c3                   	ret
writebuf(struct printbuf *state) {
  802503:	55                   	push   %rbp
  802504:	48 89 e5             	mov    %rsp,%rbp
  802507:	53                   	push   %rbx
  802508:	48 83 ec 08          	sub    $0x8,%rsp
  80250c:	48 89 fb             	mov    %rdi,%rbx
        ssize_t result = write(state->fd, state->buf, state->offset);
  80250f:	48 63 57 04          	movslq 0x4(%rdi),%rdx
  802513:	48 8d 77 14          	lea    0x14(%rdi),%rsi
  802517:	8b 3f                	mov    (%rdi),%edi
  802519:	48 b8 19 1f 80 00 00 	movabs $0x801f19,%rax
  802520:	00 00 00 
  802523:	ff d0                	call   *%rax
        if (result > 0) state->result += result;
  802525:	48 85 c0             	test   %rax,%rax
  802528:	7e 04                	jle    80252e <writebuf+0x36>
  80252a:	48 01 43 08          	add    %rax,0x8(%rbx)

        /* Error, or wrote less than supplied */
        if (result != state->offset)
  80252e:	48 63 53 04          	movslq 0x4(%rbx),%rdx
  802532:	48 39 c2             	cmp    %rax,%rdx
  802535:	74 0f                	je     802546 <writebuf+0x4e>
            state->error = MIN(0, result);
  802537:	48 85 c0             	test   %rax,%rax
  80253a:	ba 00 00 00 00       	mov    $0x0,%edx
  80253f:	48 0f 4f c2          	cmovg  %rdx,%rax
  802543:	89 43 10             	mov    %eax,0x10(%rbx)
    }
}
  802546:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80254a:	c9                   	leave
  80254b:	c3                   	ret

000000000080254c <putch>:

static void
putch(int ch, void *arg) {
  80254c:	f3 0f 1e fa          	endbr64
    struct printbuf *state = (struct printbuf *)arg;
    state->buf[state->offset++] = ch;
  802550:	8b 46 04             	mov    0x4(%rsi),%eax
  802553:	8d 50 01             	lea    0x1(%rax),%edx
  802556:	89 56 04             	mov    %edx,0x4(%rsi)
  802559:	48 98                	cltq
  80255b:	40 88 7c 06 14       	mov    %dil,0x14(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ) {
  802560:	81 fa 00 01 00 00    	cmp    $0x100,%edx
  802566:	74 01                	je     802569 <putch+0x1d>
  802568:	c3                   	ret
putch(int ch, void *arg) {
  802569:	55                   	push   %rbp
  80256a:	48 89 e5             	mov    %rsp,%rbp
  80256d:	53                   	push   %rbx
  80256e:	48 83 ec 08          	sub    $0x8,%rsp
  802572:	48 89 f3             	mov    %rsi,%rbx
        writebuf(state);
  802575:	48 89 f7             	mov    %rsi,%rdi
  802578:	48 b8 f8 24 80 00 00 	movabs $0x8024f8,%rax
  80257f:	00 00 00 
  802582:	ff d0                	call   *%rax
        state->offset = 0;
  802584:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%rbx)
    }
}
  80258b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80258f:	c9                   	leave
  802590:	c3                   	ret

0000000000802591 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap) {
  802591:	f3 0f 1e fa          	endbr64
  802595:	55                   	push   %rbp
  802596:	48 89 e5             	mov    %rsp,%rbp
  802599:	48 81 ec 20 01 00 00 	sub    $0x120,%rsp
  8025a0:	48 89 d1             	mov    %rdx,%rcx
    struct printbuf state;
    state.fd = fd;
  8025a3:	89 bd e8 fe ff ff    	mov    %edi,-0x118(%rbp)
    state.offset = 0;
  8025a9:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%rbp)
  8025b0:	00 00 00 
    state.result = 0;
  8025b3:	48 c7 85 f0 fe ff ff 	movq   $0x0,-0x110(%rbp)
  8025ba:	00 00 00 00 
    state.error = 1;
  8025be:	c7 85 f8 fe ff ff 01 	movl   $0x1,-0x108(%rbp)
  8025c5:	00 00 00 

    vprintfmt(putch, &state, fmt, ap);
  8025c8:	48 89 f2             	mov    %rsi,%rdx
  8025cb:	48 8d b5 e8 fe ff ff 	lea    -0x118(%rbp),%rsi
  8025d2:	48 bf 4c 25 80 00 00 	movabs $0x80254c,%rdi
  8025d9:	00 00 00 
  8025dc:	48 b8 4d 07 80 00 00 	movabs $0x80074d,%rax
  8025e3:	00 00 00 
  8025e6:	ff d0                	call   *%rax
    if (state.offset > 0) writebuf(&state);
  8025e8:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%rbp)
  8025ef:	7f 14                	jg     802605 <vfprintf+0x74>

    return (state.result ? state.result : state.error);
  8025f1:	48 8b 85 f0 fe ff ff 	mov    -0x110(%rbp),%rax
  8025f8:	48 85 c0             	test   %rax,%rax
  8025fb:	75 06                	jne    802603 <vfprintf+0x72>
  8025fd:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
}
  802603:	c9                   	leave
  802604:	c3                   	ret
    if (state.offset > 0) writebuf(&state);
  802605:	48 8d bd e8 fe ff ff 	lea    -0x118(%rbp),%rdi
  80260c:	48 b8 f8 24 80 00 00 	movabs $0x8024f8,%rax
  802613:	00 00 00 
  802616:	ff d0                	call   *%rax
  802618:	eb d7                	jmp    8025f1 <vfprintf+0x60>

000000000080261a <fprintf>:

int
fprintf(int fd, const char *fmt, ...) {
  80261a:	f3 0f 1e fa          	endbr64
  80261e:	55                   	push   %rbp
  80261f:	48 89 e5             	mov    %rsp,%rbp
  802622:	48 83 ec 50          	sub    $0x50,%rsp
  802626:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80262a:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80262e:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  802632:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    va_start(ap, fmt);
  802636:	c7 45 b8 10 00 00 00 	movl   $0x10,-0x48(%rbp)
  80263d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802641:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802645:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802649:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int res = vfprintf(fd, fmt, ap);
  80264d:	48 8d 55 b8          	lea    -0x48(%rbp),%rdx
  802651:	48 b8 91 25 80 00 00 	movabs $0x802591,%rax
  802658:	00 00 00 
  80265b:	ff d0                	call   *%rax
    va_end(ap);

    return res;
}
  80265d:	c9                   	leave
  80265e:	c3                   	ret

000000000080265f <printf>:

int
printf(const char *fmt, ...) {
  80265f:	f3 0f 1e fa          	endbr64
  802663:	55                   	push   %rbp
  802664:	48 89 e5             	mov    %rsp,%rbp
  802667:	48 83 ec 50          	sub    $0x50,%rsp
  80266b:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  80266f:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  802673:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802677:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  80267b:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    va_start(ap, fmt);
  80267f:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  802686:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80268a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80268e:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802692:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int res = vfprintf(1, fmt, ap);
  802696:	48 8d 55 b8          	lea    -0x48(%rbp),%rdx
  80269a:	48 89 fe             	mov    %rdi,%rsi
  80269d:	bf 01 00 00 00       	mov    $0x1,%edi
  8026a2:	48 b8 91 25 80 00 00 	movabs $0x802591,%rax
  8026a9:	00 00 00 
  8026ac:	ff d0                	call   *%rax
    va_end(ap);

    return res;
}
  8026ae:	c9                   	leave
  8026af:	c3                   	ret

00000000008026b0 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  8026b0:	f3 0f 1e fa          	endbr64
  8026b4:	55                   	push   %rbp
  8026b5:	48 89 e5             	mov    %rsp,%rbp
  8026b8:	41 54                	push   %r12
  8026ba:	53                   	push   %rbx
  8026bb:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8026be:	48 b8 63 1a 80 00 00 	movabs $0x801a63,%rax
  8026c5:	00 00 00 
  8026c8:	ff d0                	call   *%rax
  8026ca:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  8026cd:	48 be a1 42 80 00 00 	movabs $0x8042a1,%rsi
  8026d4:	00 00 00 
  8026d7:	48 89 df             	mov    %rbx,%rdi
  8026da:	48 b8 36 0f 80 00 00 	movabs $0x800f36,%rax
  8026e1:	00 00 00 
  8026e4:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  8026e6:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  8026eb:	41 2b 04 24          	sub    (%r12),%eax
  8026ef:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  8026f5:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  8026fc:	00 00 00 
    stat->st_dev = &devpipe;
  8026ff:	48 b8 80 50 80 00 00 	movabs $0x805080,%rax
  802706:	00 00 00 
  802709:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  802710:	b8 00 00 00 00       	mov    $0x0,%eax
  802715:	5b                   	pop    %rbx
  802716:	41 5c                	pop    %r12
  802718:	5d                   	pop    %rbp
  802719:	c3                   	ret

000000000080271a <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  80271a:	f3 0f 1e fa          	endbr64
  80271e:	55                   	push   %rbp
  80271f:	48 89 e5             	mov    %rsp,%rbp
  802722:	41 54                	push   %r12
  802724:	53                   	push   %rbx
  802725:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  802728:	ba 00 10 00 00       	mov    $0x1000,%edx
  80272d:	48 89 fe             	mov    %rdi,%rsi
  802730:	bf 00 00 00 00       	mov    $0x0,%edi
  802735:	49 bc c9 17 80 00 00 	movabs $0x8017c9,%r12
  80273c:	00 00 00 
  80273f:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  802742:	48 89 df             	mov    %rbx,%rdi
  802745:	48 b8 63 1a 80 00 00 	movabs $0x801a63,%rax
  80274c:	00 00 00 
  80274f:	ff d0                	call   *%rax
  802751:	48 89 c6             	mov    %rax,%rsi
  802754:	ba 00 10 00 00       	mov    $0x1000,%edx
  802759:	bf 00 00 00 00       	mov    $0x0,%edi
  80275e:	41 ff d4             	call   *%r12
}
  802761:	5b                   	pop    %rbx
  802762:	41 5c                	pop    %r12
  802764:	5d                   	pop    %rbp
  802765:	c3                   	ret

0000000000802766 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  802766:	f3 0f 1e fa          	endbr64
  80276a:	55                   	push   %rbp
  80276b:	48 89 e5             	mov    %rsp,%rbp
  80276e:	41 57                	push   %r15
  802770:	41 56                	push   %r14
  802772:	41 55                	push   %r13
  802774:	41 54                	push   %r12
  802776:	53                   	push   %rbx
  802777:	48 83 ec 18          	sub    $0x18,%rsp
  80277b:	49 89 fc             	mov    %rdi,%r12
  80277e:	49 89 f5             	mov    %rsi,%r13
  802781:	49 89 d7             	mov    %rdx,%r15
  802784:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802788:	48 b8 63 1a 80 00 00 	movabs $0x801a63,%rax
  80278f:	00 00 00 
  802792:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  802794:	4d 85 ff             	test   %r15,%r15
  802797:	0f 84 af 00 00 00    	je     80284c <devpipe_write+0xe6>
  80279d:	48 89 c3             	mov    %rax,%rbx
  8027a0:	4c 89 f8             	mov    %r15,%rax
  8027a3:	4d 89 ef             	mov    %r13,%r15
  8027a6:	4c 01 e8             	add    %r13,%rax
  8027a9:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8027ad:	49 bd 59 16 80 00 00 	movabs $0x801659,%r13
  8027b4:	00 00 00 
            sys_yield();
  8027b7:	49 be ee 15 80 00 00 	movabs $0x8015ee,%r14
  8027be:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8027c1:	8b 73 04             	mov    0x4(%rbx),%esi
  8027c4:	48 63 ce             	movslq %esi,%rcx
  8027c7:	48 63 03             	movslq (%rbx),%rax
  8027ca:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8027d0:	48 39 c1             	cmp    %rax,%rcx
  8027d3:	72 2e                	jb     802803 <devpipe_write+0x9d>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8027d5:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8027da:	48 89 da             	mov    %rbx,%rdx
  8027dd:	be 00 10 00 00       	mov    $0x1000,%esi
  8027e2:	4c 89 e7             	mov    %r12,%rdi
  8027e5:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8027e8:	85 c0                	test   %eax,%eax
  8027ea:	74 66                	je     802852 <devpipe_write+0xec>
            sys_yield();
  8027ec:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8027ef:	8b 73 04             	mov    0x4(%rbx),%esi
  8027f2:	48 63 ce             	movslq %esi,%rcx
  8027f5:	48 63 03             	movslq (%rbx),%rax
  8027f8:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8027fe:	48 39 c1             	cmp    %rax,%rcx
  802801:	73 d2                	jae    8027d5 <devpipe_write+0x6f>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802803:	41 0f b6 3f          	movzbl (%r15),%edi
  802807:	48 89 ca             	mov    %rcx,%rdx
  80280a:	48 c1 ea 03          	shr    $0x3,%rdx
  80280e:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  802815:	08 10 20 
  802818:	48 f7 e2             	mul    %rdx
  80281b:	48 c1 ea 06          	shr    $0x6,%rdx
  80281f:	48 89 d0             	mov    %rdx,%rax
  802822:	48 c1 e0 09          	shl    $0x9,%rax
  802826:	48 29 d0             	sub    %rdx,%rax
  802829:	48 c1 e0 03          	shl    $0x3,%rax
  80282d:	48 29 c1             	sub    %rax,%rcx
  802830:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  802835:	83 c6 01             	add    $0x1,%esi
  802838:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  80283b:	49 83 c7 01          	add    $0x1,%r15
  80283f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802843:	49 39 c7             	cmp    %rax,%r15
  802846:	0f 85 75 ff ff ff    	jne    8027c1 <devpipe_write+0x5b>
    return n;
  80284c:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802850:	eb 05                	jmp    802857 <devpipe_write+0xf1>
            if (_pipeisclosed(fd, p)) return 0;
  802852:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802857:	48 83 c4 18          	add    $0x18,%rsp
  80285b:	5b                   	pop    %rbx
  80285c:	41 5c                	pop    %r12
  80285e:	41 5d                	pop    %r13
  802860:	41 5e                	pop    %r14
  802862:	41 5f                	pop    %r15
  802864:	5d                   	pop    %rbp
  802865:	c3                   	ret

0000000000802866 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  802866:	f3 0f 1e fa          	endbr64
  80286a:	55                   	push   %rbp
  80286b:	48 89 e5             	mov    %rsp,%rbp
  80286e:	41 57                	push   %r15
  802870:	41 56                	push   %r14
  802872:	41 55                	push   %r13
  802874:	41 54                	push   %r12
  802876:	53                   	push   %rbx
  802877:	48 83 ec 18          	sub    $0x18,%rsp
  80287b:	49 89 fc             	mov    %rdi,%r12
  80287e:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  802882:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802886:	48 b8 63 1a 80 00 00 	movabs $0x801a63,%rax
  80288d:	00 00 00 
  802890:	ff d0                	call   *%rax
  802892:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  802895:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80289b:	49 bd 59 16 80 00 00 	movabs $0x801659,%r13
  8028a2:	00 00 00 
            sys_yield();
  8028a5:	49 be ee 15 80 00 00 	movabs $0x8015ee,%r14
  8028ac:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  8028af:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8028b4:	74 7d                	je     802933 <devpipe_read+0xcd>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8028b6:	8b 03                	mov    (%rbx),%eax
  8028b8:	3b 43 04             	cmp    0x4(%rbx),%eax
  8028bb:	75 26                	jne    8028e3 <devpipe_read+0x7d>
            if (i > 0) return i;
  8028bd:	4d 85 ff             	test   %r15,%r15
  8028c0:	75 77                	jne    802939 <devpipe_read+0xd3>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8028c2:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8028c7:	48 89 da             	mov    %rbx,%rdx
  8028ca:	be 00 10 00 00       	mov    $0x1000,%esi
  8028cf:	4c 89 e7             	mov    %r12,%rdi
  8028d2:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8028d5:	85 c0                	test   %eax,%eax
  8028d7:	74 72                	je     80294b <devpipe_read+0xe5>
            sys_yield();
  8028d9:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8028dc:	8b 03                	mov    (%rbx),%eax
  8028de:	3b 43 04             	cmp    0x4(%rbx),%eax
  8028e1:	74 df                	je     8028c2 <devpipe_read+0x5c>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8028e3:	48 63 c8             	movslq %eax,%rcx
  8028e6:	48 89 ca             	mov    %rcx,%rdx
  8028e9:	48 c1 ea 03          	shr    $0x3,%rdx
  8028ed:	48 be 81 00 01 02 04 	movabs $0x2010080402010081,%rsi
  8028f4:	08 10 20 
  8028f7:	48 89 d0             	mov    %rdx,%rax
  8028fa:	48 f7 e6             	mul    %rsi
  8028fd:	48 c1 ea 06          	shr    $0x6,%rdx
  802901:	48 89 d0             	mov    %rdx,%rax
  802904:	48 c1 e0 09          	shl    $0x9,%rax
  802908:	48 29 d0             	sub    %rdx,%rax
  80290b:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802912:	00 
  802913:	48 89 c8             	mov    %rcx,%rax
  802916:	48 29 d0             	sub    %rdx,%rax
  802919:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  80291e:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  802922:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  802926:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  802929:	49 83 c7 01          	add    $0x1,%r15
  80292d:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  802931:	75 83                	jne    8028b6 <devpipe_read+0x50>
    return n;
  802933:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802937:	eb 03                	jmp    80293c <devpipe_read+0xd6>
            if (i > 0) return i;
  802939:	4c 89 f8             	mov    %r15,%rax
}
  80293c:	48 83 c4 18          	add    $0x18,%rsp
  802940:	5b                   	pop    %rbx
  802941:	41 5c                	pop    %r12
  802943:	41 5d                	pop    %r13
  802945:	41 5e                	pop    %r14
  802947:	41 5f                	pop    %r15
  802949:	5d                   	pop    %rbp
  80294a:	c3                   	ret
            if (_pipeisclosed(fd, p)) return 0;
  80294b:	b8 00 00 00 00       	mov    $0x0,%eax
  802950:	eb ea                	jmp    80293c <devpipe_read+0xd6>

0000000000802952 <pipe>:
pipe(int pfd[2]) {
  802952:	f3 0f 1e fa          	endbr64
  802956:	55                   	push   %rbp
  802957:	48 89 e5             	mov    %rsp,%rbp
  80295a:	41 55                	push   %r13
  80295c:	41 54                	push   %r12
  80295e:	53                   	push   %rbx
  80295f:	48 83 ec 18          	sub    $0x18,%rsp
  802963:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  802966:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  80296a:	48 b8 83 1a 80 00 00 	movabs $0x801a83,%rax
  802971:	00 00 00 
  802974:	ff d0                	call   *%rax
  802976:	89 c3                	mov    %eax,%ebx
  802978:	85 c0                	test   %eax,%eax
  80297a:	0f 88 a0 01 00 00    	js     802b20 <pipe+0x1ce>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  802980:	b9 46 00 00 00       	mov    $0x46,%ecx
  802985:	ba 00 10 00 00       	mov    $0x1000,%edx
  80298a:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80298e:	bf 00 00 00 00       	mov    $0x0,%edi
  802993:	48 b8 89 16 80 00 00 	movabs $0x801689,%rax
  80299a:	00 00 00 
  80299d:	ff d0                	call   *%rax
  80299f:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  8029a1:	85 c0                	test   %eax,%eax
  8029a3:	0f 88 77 01 00 00    	js     802b20 <pipe+0x1ce>
    if ((res = fd_alloc(&fd1)) < 0 ||
  8029a9:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  8029ad:	48 b8 83 1a 80 00 00 	movabs $0x801a83,%rax
  8029b4:	00 00 00 
  8029b7:	ff d0                	call   *%rax
  8029b9:	89 c3                	mov    %eax,%ebx
  8029bb:	85 c0                	test   %eax,%eax
  8029bd:	0f 88 43 01 00 00    	js     802b06 <pipe+0x1b4>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  8029c3:	b9 46 00 00 00       	mov    $0x46,%ecx
  8029c8:	ba 00 10 00 00       	mov    $0x1000,%edx
  8029cd:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8029d1:	bf 00 00 00 00       	mov    $0x0,%edi
  8029d6:	48 b8 89 16 80 00 00 	movabs $0x801689,%rax
  8029dd:	00 00 00 
  8029e0:	ff d0                	call   *%rax
  8029e2:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  8029e4:	85 c0                	test   %eax,%eax
  8029e6:	0f 88 1a 01 00 00    	js     802b06 <pipe+0x1b4>
    va = fd2data(fd0);
  8029ec:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8029f0:	48 b8 63 1a 80 00 00 	movabs $0x801a63,%rax
  8029f7:	00 00 00 
  8029fa:	ff d0                	call   *%rax
  8029fc:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  8029ff:	b9 46 00 00 00       	mov    $0x46,%ecx
  802a04:	ba 00 10 00 00       	mov    $0x1000,%edx
  802a09:	48 89 c6             	mov    %rax,%rsi
  802a0c:	bf 00 00 00 00       	mov    $0x0,%edi
  802a11:	48 b8 89 16 80 00 00 	movabs $0x801689,%rax
  802a18:	00 00 00 
  802a1b:	ff d0                	call   *%rax
  802a1d:	89 c3                	mov    %eax,%ebx
  802a1f:	85 c0                	test   %eax,%eax
  802a21:	0f 88 c5 00 00 00    	js     802aec <pipe+0x19a>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  802a27:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802a2b:	48 b8 63 1a 80 00 00 	movabs $0x801a63,%rax
  802a32:	00 00 00 
  802a35:	ff d0                	call   *%rax
  802a37:	48 89 c1             	mov    %rax,%rcx
  802a3a:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  802a40:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  802a46:	ba 00 00 00 00       	mov    $0x0,%edx
  802a4b:	4c 89 ee             	mov    %r13,%rsi
  802a4e:	bf 00 00 00 00       	mov    $0x0,%edi
  802a53:	48 b8 f4 16 80 00 00 	movabs $0x8016f4,%rax
  802a5a:	00 00 00 
  802a5d:	ff d0                	call   *%rax
  802a5f:	89 c3                	mov    %eax,%ebx
  802a61:	85 c0                	test   %eax,%eax
  802a63:	78 6e                	js     802ad3 <pipe+0x181>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802a65:	be 00 10 00 00       	mov    $0x1000,%esi
  802a6a:	4c 89 ef             	mov    %r13,%rdi
  802a6d:	48 b8 23 16 80 00 00 	movabs $0x801623,%rax
  802a74:	00 00 00 
  802a77:	ff d0                	call   *%rax
  802a79:	83 f8 02             	cmp    $0x2,%eax
  802a7c:	0f 85 ab 00 00 00    	jne    802b2d <pipe+0x1db>
    fd0->fd_dev_id = devpipe.dev_id;
  802a82:	a1 80 50 80 00 00 00 	movabs 0x805080,%eax
  802a89:	00 00 
  802a8b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a8f:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  802a91:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a95:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  802a9c:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802aa0:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  802aa2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802aa6:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  802aad:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802ab1:	48 bb 4d 1a 80 00 00 	movabs $0x801a4d,%rbx
  802ab8:	00 00 00 
  802abb:	ff d3                	call   *%rbx
  802abd:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  802ac1:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802ac5:	ff d3                	call   *%rbx
  802ac7:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  802acc:	bb 00 00 00 00       	mov    $0x0,%ebx
  802ad1:	eb 4d                	jmp    802b20 <pipe+0x1ce>
    sys_unmap_region(0, va, PAGE_SIZE);
  802ad3:	ba 00 10 00 00       	mov    $0x1000,%edx
  802ad8:	4c 89 ee             	mov    %r13,%rsi
  802adb:	bf 00 00 00 00       	mov    $0x0,%edi
  802ae0:	48 b8 c9 17 80 00 00 	movabs $0x8017c9,%rax
  802ae7:	00 00 00 
  802aea:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  802aec:	ba 00 10 00 00       	mov    $0x1000,%edx
  802af1:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802af5:	bf 00 00 00 00       	mov    $0x0,%edi
  802afa:	48 b8 c9 17 80 00 00 	movabs $0x8017c9,%rax
  802b01:	00 00 00 
  802b04:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  802b06:	ba 00 10 00 00       	mov    $0x1000,%edx
  802b0b:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802b0f:	bf 00 00 00 00       	mov    $0x0,%edi
  802b14:	48 b8 c9 17 80 00 00 	movabs $0x8017c9,%rax
  802b1b:	00 00 00 
  802b1e:	ff d0                	call   *%rax
}
  802b20:	89 d8                	mov    %ebx,%eax
  802b22:	48 83 c4 18          	add    $0x18,%rsp
  802b26:	5b                   	pop    %rbx
  802b27:	41 5c                	pop    %r12
  802b29:	41 5d                	pop    %r13
  802b2b:	5d                   	pop    %rbp
  802b2c:	c3                   	ret
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802b2d:	48 b9 80 43 80 00 00 	movabs $0x804380,%rcx
  802b34:	00 00 00 
  802b37:	48 ba 81 42 80 00 00 	movabs $0x804281,%rdx
  802b3e:	00 00 00 
  802b41:	be 2e 00 00 00       	mov    $0x2e,%esi
  802b46:	48 bf a8 42 80 00 00 	movabs $0x8042a8,%rdi
  802b4d:	00 00 00 
  802b50:	b8 00 00 00 00       	mov    $0x0,%eax
  802b55:	49 b8 91 04 80 00 00 	movabs $0x800491,%r8
  802b5c:	00 00 00 
  802b5f:	41 ff d0             	call   *%r8

0000000000802b62 <pipeisclosed>:
pipeisclosed(int fdnum) {
  802b62:	f3 0f 1e fa          	endbr64
  802b66:	55                   	push   %rbp
  802b67:	48 89 e5             	mov    %rsp,%rbp
  802b6a:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802b6e:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802b72:	48 b8 e7 1a 80 00 00 	movabs $0x801ae7,%rax
  802b79:	00 00 00 
  802b7c:	ff d0                	call   *%rax
    if (res < 0) return res;
  802b7e:	85 c0                	test   %eax,%eax
  802b80:	78 35                	js     802bb7 <pipeisclosed+0x55>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  802b82:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802b86:	48 b8 63 1a 80 00 00 	movabs $0x801a63,%rax
  802b8d:	00 00 00 
  802b90:	ff d0                	call   *%rax
  802b92:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802b95:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802b9a:	be 00 10 00 00       	mov    $0x1000,%esi
  802b9f:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802ba3:	48 b8 59 16 80 00 00 	movabs $0x801659,%rax
  802baa:	00 00 00 
  802bad:	ff d0                	call   *%rax
  802baf:	85 c0                	test   %eax,%eax
  802bb1:	0f 94 c0             	sete   %al
  802bb4:	0f b6 c0             	movzbl %al,%eax
}
  802bb7:	c9                   	leave
  802bb8:	c3                   	ret

0000000000802bb9 <get_uvpt_entry>:
extern volatile pde_t uvpd[];     /* VA of current page directory */
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
  802bb9:	f3 0f 1e fa          	endbr64
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802bbd:	48 89 f8             	mov    %rdi,%rax
  802bc0:	48 c1 e8 27          	shr    $0x27,%rax
  802bc4:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  802bcb:	7f 00 00 
  802bce:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802bd2:	f6 c2 01             	test   $0x1,%dl
  802bd5:	74 6d                	je     802c44 <get_uvpt_entry+0x8b>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  802bd7:	48 89 f8             	mov    %rdi,%rax
  802bda:	48 c1 e8 1e          	shr    $0x1e,%rax
  802bde:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  802be5:	7f 00 00 
  802be8:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802bec:	f6 c2 01             	test   $0x1,%dl
  802bef:	74 62                	je     802c53 <get_uvpt_entry+0x9a>
  802bf1:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  802bf8:	7f 00 00 
  802bfb:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802bff:	f6 c2 80             	test   $0x80,%dl
  802c02:	75 4f                	jne    802c53 <get_uvpt_entry+0x9a>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802c04:	48 89 f8             	mov    %rdi,%rax
  802c07:	48 c1 e8 15          	shr    $0x15,%rax
  802c0b:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802c12:	7f 00 00 
  802c15:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802c19:	f6 c2 01             	test   $0x1,%dl
  802c1c:	74 44                	je     802c62 <get_uvpt_entry+0xa9>
  802c1e:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802c25:	7f 00 00 
  802c28:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802c2c:	f6 c2 80             	test   $0x80,%dl
  802c2f:	75 31                	jne    802c62 <get_uvpt_entry+0xa9>
    return uvpt[VPT(va)];
  802c31:	48 c1 ef 0c          	shr    $0xc,%rdi
  802c35:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802c3c:	7f 00 00 
  802c3f:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  802c43:	c3                   	ret
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802c44:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  802c4b:	7f 00 00 
  802c4e:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802c52:	c3                   	ret
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  802c53:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  802c5a:	7f 00 00 
  802c5d:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802c61:	c3                   	ret
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802c62:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802c69:	7f 00 00 
  802c6c:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802c70:	c3                   	ret

0000000000802c71 <get_phys_addr>:

uintptr_t
get_phys_addr(void *va) {
  802c71:	f3 0f 1e fa          	endbr64
  802c75:	48 89 fa             	mov    %rdi,%rdx
    if (!(uvpml4[VPML4(va)] & PTE_P))
  802c78:	48 89 f9             	mov    %rdi,%rcx
  802c7b:	48 c1 e9 27          	shr    $0x27,%rcx
  802c7f:	48 b8 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rax
  802c86:	7f 00 00 
  802c89:	48 8b 0c c8          	mov    (%rax,%rcx,8),%rcx
        return -1;
  802c8d:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpml4[VPML4(va)] & PTE_P))
  802c94:	f6 c1 01             	test   $0x1,%cl
  802c97:	0f 84 b2 00 00 00    	je     802d4f <get_phys_addr+0xde>
    if (!(uvpdp[VPDP(va)] & PTE_P))
  802c9d:	48 89 f9             	mov    %rdi,%rcx
  802ca0:	48 c1 e9 1e          	shr    $0x1e,%rcx
  802ca4:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802cab:	7f 00 00 
  802cae:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  802cb2:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpdp[VPDP(va)] & PTE_P))
  802cb9:	40 f6 c6 01          	test   $0x1,%sil
  802cbd:	0f 84 8c 00 00 00    	je     802d4f <get_phys_addr+0xde>
    if (uvpdp[VPDP(va)] & PTE_PS)
  802cc3:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802cca:	7f 00 00 
  802ccd:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802cd1:	a8 80                	test   $0x80,%al
  802cd3:	75 7b                	jne    802d50 <get_phys_addr+0xdf>
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
    if (!(uvpd[VPD(va)] & PTE_P))
  802cd5:	48 89 f9             	mov    %rdi,%rcx
  802cd8:	48 c1 e9 15          	shr    $0x15,%rcx
  802cdc:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  802ce3:	7f 00 00 
  802ce6:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  802cea:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpd[VPD(va)] & PTE_P))
  802cf1:	40 f6 c6 01          	test   $0x1,%sil
  802cf5:	74 58                	je     802d4f <get_phys_addr+0xde>
    if ((uvpd[VPD(va)] & PTE_PS))
  802cf7:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  802cfe:	7f 00 00 
  802d01:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802d05:	a8 80                	test   $0x80,%al
  802d07:	75 6c                	jne    802d75 <get_phys_addr+0x104>
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
    if (!(uvpt[VPT(va)] & PTE_P))
  802d09:	48 89 f9             	mov    %rdi,%rcx
  802d0c:	48 c1 e9 0c          	shr    $0xc,%rcx
  802d10:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802d17:	7f 00 00 
  802d1a:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  802d1e:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpt[VPT(va)] & PTE_P))
  802d25:	40 f6 c6 01          	test   $0x1,%sil
  802d29:	74 24                	je     802d4f <get_phys_addr+0xde>
    return PTE_ADDR(uvpt[VPT(va)]) + PAGE_OFFSET(va);
  802d2b:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802d32:	7f 00 00 
  802d35:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802d39:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802d40:	ff ff 7f 
  802d43:	48 21 c8             	and    %rcx,%rax
  802d46:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  802d4c:	48 09 d0             	or     %rdx,%rax
}
  802d4f:	c3                   	ret
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
  802d50:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802d57:	7f 00 00 
  802d5a:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802d5e:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802d65:	ff ff 7f 
  802d68:	48 21 c8             	and    %rcx,%rax
  802d6b:	81 e2 ff ff ff 3f    	and    $0x3fffffff,%edx
  802d71:	48 01 d0             	add    %rdx,%rax
  802d74:	c3                   	ret
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
  802d75:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  802d7c:	7f 00 00 
  802d7f:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802d83:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802d8a:	ff ff 7f 
  802d8d:	48 21 c8             	and    %rcx,%rax
  802d90:	81 e2 ff ff 1f 00    	and    $0x1fffff,%edx
  802d96:	48 01 d0             	add    %rdx,%rax
  802d99:	c3                   	ret

0000000000802d9a <get_prot>:

int
get_prot(void *va) {
  802d9a:	f3 0f 1e fa          	endbr64
  802d9e:	55                   	push   %rbp
  802d9f:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802da2:	48 b8 b9 2b 80 00 00 	movabs $0x802bb9,%rax
  802da9:	00 00 00 
  802dac:	ff d0                	call   *%rax
  802dae:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
    if (pte & PTE_P) prot |= PROT_R;
  802db1:	83 e0 01             	and    $0x1,%eax
  802db4:	c1 e0 02             	shl    $0x2,%eax
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  802db7:	89 d1                	mov    %edx,%ecx
  802db9:	81 e1 00 0a 00 00    	and    $0xa00,%ecx
    if (pte & PTE_P) prot |= PROT_R;
  802dbf:	09 c8                	or     %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  802dc1:	89 c1                	mov    %eax,%ecx
  802dc3:	83 c9 02             	or     $0x2,%ecx
  802dc6:	f6 c2 02             	test   $0x2,%dl
  802dc9:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  802dcc:	89 c1                	mov    %eax,%ecx
  802dce:	83 c9 01             	or     $0x1,%ecx
  802dd1:	48 85 d2             	test   %rdx,%rdx
  802dd4:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  802dd7:	89 c1                	mov    %eax,%ecx
  802dd9:	83 c9 40             	or     $0x40,%ecx
  802ddc:	f6 c6 04             	test   $0x4,%dh
  802ddf:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  802de2:	5d                   	pop    %rbp
  802de3:	c3                   	ret

0000000000802de4 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  802de4:	f3 0f 1e fa          	endbr64
  802de8:	55                   	push   %rbp
  802de9:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802dec:	48 b8 b9 2b 80 00 00 	movabs $0x802bb9,%rax
  802df3:	00 00 00 
  802df6:	ff d0                	call   *%rax
    return pte & PTE_D;
  802df8:	48 c1 e8 06          	shr    $0x6,%rax
  802dfc:	83 e0 01             	and    $0x1,%eax
}
  802dff:	5d                   	pop    %rbp
  802e00:	c3                   	ret

0000000000802e01 <is_page_present>:

bool
is_page_present(void *va) {
  802e01:	f3 0f 1e fa          	endbr64
  802e05:	55                   	push   %rbp
  802e06:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  802e09:	48 b8 b9 2b 80 00 00 	movabs $0x802bb9,%rax
  802e10:	00 00 00 
  802e13:	ff d0                	call   *%rax
  802e15:	83 e0 01             	and    $0x1,%eax
}
  802e18:	5d                   	pop    %rbp
  802e19:	c3                   	ret

0000000000802e1a <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  802e1a:	f3 0f 1e fa          	endbr64
  802e1e:	55                   	push   %rbp
  802e1f:	48 89 e5             	mov    %rsp,%rbp
  802e22:	41 57                	push   %r15
  802e24:	41 56                	push   %r14
  802e26:	41 55                	push   %r13
  802e28:	41 54                	push   %r12
  802e2a:	53                   	push   %rbx
  802e2b:	48 83 ec 18          	sub    $0x18,%rsp
  802e2f:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  802e33:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
     * NOTE: Skip over larger pages/page directories for efficiency */
    // LAB 11: Your code here:

    int res = 0;
    (void)fun, (void)arg;
    uintptr_t va = 0;
  802e37:	bb 00 00 00 00       	mov    $0x0,%ebx
    while (va < USER_STACK_TOP) {
        size_t size = 0;
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  802e3c:	49 be 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%r14
  802e43:	7f 00 00 
            size = 1LL << PML4_SHIFT;
            goto next;
        }

        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802e46:	49 bd 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%r13
  802e4d:	7f 00 00 
    while (va < USER_STACK_TOP) {
  802e50:	49 bf ff 6f ff ff 7f 	movabs $0x7fffff6fff,%r15
  802e57:	00 00 00 
  802e5a:	eb 73                	jmp    802ecf <foreach_shared_region+0xb5>
            }

            goto next;
        }

        if (!(uvpd[VPD(va)] & PTE_P)) {
  802e5c:	48 89 d8             	mov    %rbx,%rax
  802e5f:	48 c1 e8 15          	shr    $0x15,%rax
  802e63:	48 b9 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rcx
  802e6a:	7f 00 00 
  802e6d:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
            size = 1LL << PD_SHIFT;
  802e71:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
        if (!(uvpd[VPD(va)] & PTE_P)) {
  802e77:	f6 c2 01             	test   $0x1,%dl
  802e7a:	74 4b                	je     802ec7 <foreach_shared_region+0xad>
            goto next;
        }

        if (uvpd[VPD(va)] & PTE_PS) {
  802e7c:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
  802e80:	f6 c2 80             	test   $0x80,%dl
  802e83:	74 11                	je     802e96 <foreach_shared_region+0x7c>
            size = 1LL << PD_SHIFT;
            if (uvpd[VPD(va)] & PTE_SHARE) {
  802e85:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
  802e89:	f6 c4 04             	test   $0x4,%ah
  802e8c:	74 39                	je     802ec7 <foreach_shared_region+0xad>
            size = 1LL << PD_SHIFT;
  802e8e:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
  802e94:	eb 20                	jmp    802eb6 <foreach_shared_region+0x9c>

            goto next;
        }

        size = PAGE_SIZE;
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  802e96:	48 89 da             	mov    %rbx,%rdx
  802e99:	48 c1 ea 0c          	shr    $0xc,%rdx
  802e9d:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802ea4:	7f 00 00 
  802ea7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
        size = PAGE_SIZE;
  802eab:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  802eb1:	f6 c4 04             	test   $0x4,%ah
  802eb4:	74 11                	je     802ec7 <foreach_shared_region+0xad>
            goto next;
        }

    map:
        fun((void *)va, (void *)(va + size), arg);
  802eb6:	49 8d 34 1c          	lea    (%r12,%rbx,1),%rsi
  802eba:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802ebe:	48 89 df             	mov    %rbx,%rdi
  802ec1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802ec5:	ff d0                	call   *%rax
    next:
        va += size;
  802ec7:	4c 01 e3             	add    %r12,%rbx
    while (va < USER_STACK_TOP) {
  802eca:	49 39 df             	cmp    %rbx,%r15
  802ecd:	72 3e                	jb     802f0d <foreach_shared_region+0xf3>
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  802ecf:	49 8b 06             	mov    (%r14),%rax
  802ed2:	a8 01                	test   $0x1,%al
  802ed4:	74 37                	je     802f0d <foreach_shared_region+0xf3>
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802ed6:	48 89 d8             	mov    %rbx,%rax
  802ed9:	48 c1 e8 1e          	shr    $0x1e,%rax
  802edd:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
            size = 1LL << PDP_SHIFT;
  802ee2:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802ee8:	f6 c2 01             	test   $0x1,%dl
  802eeb:	74 da                	je     802ec7 <foreach_shared_region+0xad>
        if (uvpdp[VPDP(va)] & PTE_PS) {
  802eed:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
  802ef2:	f6 c2 80             	test   $0x80,%dl
  802ef5:	0f 84 61 ff ff ff    	je     802e5c <foreach_shared_region+0x42>
            if (uvpdp[VPDP(va)] & PTE_SHARE) {
  802efb:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  802f00:	f6 c4 04             	test   $0x4,%ah
  802f03:	74 c2                	je     802ec7 <foreach_shared_region+0xad>
            size = 1LL << PDP_SHIFT;
  802f05:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
  802f0b:	eb a9                	jmp    802eb6 <foreach_shared_region+0x9c>
    }
    return res;
}
  802f0d:	b8 00 00 00 00       	mov    $0x0,%eax
  802f12:	48 83 c4 18          	add    $0x18,%rsp
  802f16:	5b                   	pop    %rbx
  802f17:	41 5c                	pop    %r12
  802f19:	41 5d                	pop    %r13
  802f1b:	41 5e                	pop    %r14
  802f1d:	41 5f                	pop    %r15
  802f1f:	5d                   	pop    %rbp
  802f20:	c3                   	ret

0000000000802f21 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802f21:	f3 0f 1e fa          	endbr64
  802f25:	55                   	push   %rbp
  802f26:	48 89 e5             	mov    %rsp,%rbp
  802f29:	41 54                	push   %r12
  802f2b:	53                   	push   %rbx
  802f2c:	48 89 fb             	mov    %rdi,%rbx
  802f2f:	48 89 f7             	mov    %rsi,%rdi
  802f32:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802f35:	48 85 f6             	test   %rsi,%rsi
  802f38:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802f3f:	00 00 00 
  802f42:	48 0f 44 f8          	cmove  %rax,%rdi
    }
    int res = sys_ipc_recv(pg, PAGE_SIZE);
  802f46:	be 00 10 00 00       	mov    $0x1000,%esi
  802f4b:	48 b8 ab 19 80 00 00 	movabs $0x8019ab,%rax
  802f52:	00 00 00 
  802f55:	ff d0                	call   *%rax
    if (res < 0) {
  802f57:	85 c0                	test   %eax,%eax
  802f59:	78 45                	js     802fa0 <ipc_recv+0x7f>
        if (perm_store != NULL) {
            *perm_store = 0;
        }
        return res;
    } else {
        if (from_env_store != NULL) {
  802f5b:	48 85 db             	test   %rbx,%rbx
  802f5e:	74 12                	je     802f72 <ipc_recv+0x51>
            *from_env_store = thisenv->env_ipc_from;
  802f60:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  802f67:	00 00 00 
  802f6a:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  802f70:	89 03                	mov    %eax,(%rbx)
        }
        if (perm_store != NULL) {
  802f72:	4d 85 e4             	test   %r12,%r12
  802f75:	74 14                	je     802f8b <ipc_recv+0x6a>
            *perm_store = thisenv->env_ipc_perm;
  802f77:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  802f7e:	00 00 00 
  802f81:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  802f87:	41 89 04 24          	mov    %eax,(%r12)
        }
        return thisenv->env_ipc_value;
  802f8b:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  802f92:	00 00 00 
  802f95:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
    }
    return -1;
}
  802f9b:	5b                   	pop    %rbx
  802f9c:	41 5c                	pop    %r12
  802f9e:	5d                   	pop    %rbp
  802f9f:	c3                   	ret
        if (from_env_store != NULL) {
  802fa0:	48 85 db             	test   %rbx,%rbx
  802fa3:	74 06                	je     802fab <ipc_recv+0x8a>
            *from_env_store = 0;
  802fa5:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store != NULL) {
  802fab:	4d 85 e4             	test   %r12,%r12
  802fae:	74 eb                	je     802f9b <ipc_recv+0x7a>
            *perm_store = 0;
  802fb0:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  802fb7:	00 
  802fb8:	eb e1                	jmp    802f9b <ipc_recv+0x7a>

0000000000802fba <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  802fba:	f3 0f 1e fa          	endbr64
  802fbe:	55                   	push   %rbp
  802fbf:	48 89 e5             	mov    %rsp,%rbp
  802fc2:	41 57                	push   %r15
  802fc4:	41 56                	push   %r14
  802fc6:	41 55                	push   %r13
  802fc8:	41 54                	push   %r12
  802fca:	53                   	push   %rbx
  802fcb:	48 83 ec 18          	sub    $0x18,%rsp
  802fcf:	89 7d c4             	mov    %edi,-0x3c(%rbp)
  802fd2:	48 89 d3             	mov    %rdx,%rbx
  802fd5:	49 89 cc             	mov    %rcx,%r12
  802fd8:	45 89 c5             	mov    %r8d,%r13d
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802fdb:	48 85 d2             	test   %rdx,%rdx
  802fde:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802fe5:	00 00 00 
  802fe8:	48 0f 44 d8          	cmove  %rax,%rbx
    }
    int res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802fec:	89 f0                	mov    %esi,%eax
  802fee:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  802ff2:	48 89 da             	mov    %rbx,%rdx
  802ff5:	48 89 c6             	mov    %rax,%rsi
  802ff8:	48 b8 7b 19 80 00 00 	movabs $0x80197b,%rax
  802fff:	00 00 00 
  803002:	ff d0                	call   *%rax
    while (res < 0) {
  803004:	85 c0                	test   %eax,%eax
  803006:	79 65                	jns    80306d <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  803008:	83 f8 f5             	cmp    $0xfffffff5,%eax
  80300b:	75 33                	jne    803040 <ipc_send+0x86>
            panic("Error: %i\n", res);
        }
        sys_yield();
  80300d:	49 bf ee 15 80 00 00 	movabs $0x8015ee,%r15
  803014:	00 00 00 
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  803017:	49 be 7b 19 80 00 00 	movabs $0x80197b,%r14
  80301e:	00 00 00 
        sys_yield();
  803021:	41 ff d7             	call   *%r15
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  803024:	45 89 e8             	mov    %r13d,%r8d
  803027:	4c 89 e1             	mov    %r12,%rcx
  80302a:	48 89 da             	mov    %rbx,%rdx
  80302d:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  803031:	8b 7d c4             	mov    -0x3c(%rbp),%edi
  803034:	41 ff d6             	call   *%r14
    while (res < 0) {
  803037:	85 c0                	test   %eax,%eax
  803039:	79 32                	jns    80306d <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  80303b:	83 f8 f5             	cmp    $0xfffffff5,%eax
  80303e:	74 e1                	je     803021 <ipc_send+0x67>
            panic("Error: %i\n", res);
  803040:	89 c1                	mov    %eax,%ecx
  803042:	48 ba b8 42 80 00 00 	movabs $0x8042b8,%rdx
  803049:	00 00 00 
  80304c:	be 42 00 00 00       	mov    $0x42,%esi
  803051:	48 bf c3 42 80 00 00 	movabs $0x8042c3,%rdi
  803058:	00 00 00 
  80305b:	b8 00 00 00 00       	mov    $0x0,%eax
  803060:	49 b8 91 04 80 00 00 	movabs $0x800491,%r8
  803067:	00 00 00 
  80306a:	41 ff d0             	call   *%r8
    }
}
  80306d:	48 83 c4 18          	add    $0x18,%rsp
  803071:	5b                   	pop    %rbx
  803072:	41 5c                	pop    %r12
  803074:	41 5d                	pop    %r13
  803076:	41 5e                	pop    %r14
  803078:	41 5f                	pop    %r15
  80307a:	5d                   	pop    %rbp
  80307b:	c3                   	ret

000000000080307c <ipc_find_env>:

/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
  80307c:	f3 0f 1e fa          	endbr64
    for (size_t i = 0; i < NENV; i++)
  803080:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  803085:	48 b9 00 00 a0 1f 80 	movabs $0x801fa00000,%rcx
  80308c:	00 00 00 
  80308f:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  803093:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  803097:	48 c1 e2 04          	shl    $0x4,%rdx
  80309b:	48 01 ca             	add    %rcx,%rdx
  80309e:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  8030a4:	39 fa                	cmp    %edi,%edx
  8030a6:	74 12                	je     8030ba <ipc_find_env+0x3e>
    for (size_t i = 0; i < NENV; i++)
  8030a8:	48 83 c0 01          	add    $0x1,%rax
  8030ac:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  8030b2:	75 db                	jne    80308f <ipc_find_env+0x13>
            return envs[i].env_id;
    return 0;
  8030b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030b9:	c3                   	ret
            return envs[i].env_id;
  8030ba:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8030be:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  8030c2:	48 c1 e2 04          	shl    $0x4,%rdx
  8030c6:	48 b8 00 00 a0 1f 80 	movabs $0x801fa00000,%rax
  8030cd:	00 00 00 
  8030d0:	48 01 d0             	add    %rdx,%rax
  8030d3:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8030d9:	c3                   	ret

00000000008030da <__text_end>:
  8030da:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8030e1:	00 00 00 
  8030e4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8030eb:	00 00 00 
  8030ee:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8030f5:	00 00 00 
  8030f8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8030ff:	00 00 00 
  803102:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803109:	00 00 00 
  80310c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803113:	00 00 00 
  803116:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80311d:	00 00 00 
  803120:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803127:	00 00 00 
  80312a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803131:	00 00 00 
  803134:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80313b:	00 00 00 
  80313e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803145:	00 00 00 
  803148:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80314f:	00 00 00 
  803152:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803159:	00 00 00 
  80315c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803163:	00 00 00 
  803166:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80316d:	00 00 00 
  803170:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803177:	00 00 00 
  80317a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803181:	00 00 00 
  803184:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80318b:	00 00 00 
  80318e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803195:	00 00 00 
  803198:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80319f:	00 00 00 
  8031a2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8031a9:	00 00 00 
  8031ac:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8031b3:	00 00 00 
  8031b6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8031bd:	00 00 00 
  8031c0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8031c7:	00 00 00 
  8031ca:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8031d1:	00 00 00 
  8031d4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8031db:	00 00 00 
  8031de:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8031e5:	00 00 00 
  8031e8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8031ef:	00 00 00 
  8031f2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8031f9:	00 00 00 
  8031fc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803203:	00 00 00 
  803206:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80320d:	00 00 00 
  803210:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803217:	00 00 00 
  80321a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803221:	00 00 00 
  803224:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80322b:	00 00 00 
  80322e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803235:	00 00 00 
  803238:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80323f:	00 00 00 
  803242:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803249:	00 00 00 
  80324c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803253:	00 00 00 
  803256:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80325d:	00 00 00 
  803260:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803267:	00 00 00 
  80326a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803271:	00 00 00 
  803274:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80327b:	00 00 00 
  80327e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803285:	00 00 00 
  803288:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80328f:	00 00 00 
  803292:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803299:	00 00 00 
  80329c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032a3:	00 00 00 
  8032a6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032ad:	00 00 00 
  8032b0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032b7:	00 00 00 
  8032ba:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032c1:	00 00 00 
  8032c4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032cb:	00 00 00 
  8032ce:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032d5:	00 00 00 
  8032d8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032df:	00 00 00 
  8032e2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032e9:	00 00 00 
  8032ec:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032f3:	00 00 00 
  8032f6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8032fd:	00 00 00 
  803300:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803307:	00 00 00 
  80330a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803311:	00 00 00 
  803314:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80331b:	00 00 00 
  80331e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803325:	00 00 00 
  803328:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80332f:	00 00 00 
  803332:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803339:	00 00 00 
  80333c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803343:	00 00 00 
  803346:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80334d:	00 00 00 
  803350:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803357:	00 00 00 
  80335a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803361:	00 00 00 
  803364:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80336b:	00 00 00 
  80336e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803375:	00 00 00 
  803378:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80337f:	00 00 00 
  803382:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803389:	00 00 00 
  80338c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803393:	00 00 00 
  803396:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80339d:	00 00 00 
  8033a0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033a7:	00 00 00 
  8033aa:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033b1:	00 00 00 
  8033b4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033bb:	00 00 00 
  8033be:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033c5:	00 00 00 
  8033c8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033cf:	00 00 00 
  8033d2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033d9:	00 00 00 
  8033dc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033e3:	00 00 00 
  8033e6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033ed:	00 00 00 
  8033f0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033f7:	00 00 00 
  8033fa:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803401:	00 00 00 
  803404:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80340b:	00 00 00 
  80340e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803415:	00 00 00 
  803418:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80341f:	00 00 00 
  803422:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803429:	00 00 00 
  80342c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803433:	00 00 00 
  803436:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80343d:	00 00 00 
  803440:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803447:	00 00 00 
  80344a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803451:	00 00 00 
  803454:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80345b:	00 00 00 
  80345e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803465:	00 00 00 
  803468:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80346f:	00 00 00 
  803472:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803479:	00 00 00 
  80347c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803483:	00 00 00 
  803486:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80348d:	00 00 00 
  803490:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803497:	00 00 00 
  80349a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034a1:	00 00 00 
  8034a4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034ab:	00 00 00 
  8034ae:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034b5:	00 00 00 
  8034b8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034bf:	00 00 00 
  8034c2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034c9:	00 00 00 
  8034cc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034d3:	00 00 00 
  8034d6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034dd:	00 00 00 
  8034e0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034e7:	00 00 00 
  8034ea:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034f1:	00 00 00 
  8034f4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034fb:	00 00 00 
  8034fe:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803505:	00 00 00 
  803508:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80350f:	00 00 00 
  803512:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803519:	00 00 00 
  80351c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803523:	00 00 00 
  803526:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80352d:	00 00 00 
  803530:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803537:	00 00 00 
  80353a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803541:	00 00 00 
  803544:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80354b:	00 00 00 
  80354e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803555:	00 00 00 
  803558:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80355f:	00 00 00 
  803562:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803569:	00 00 00 
  80356c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803573:	00 00 00 
  803576:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80357d:	00 00 00 
  803580:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803587:	00 00 00 
  80358a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803591:	00 00 00 
  803594:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80359b:	00 00 00 
  80359e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035a5:	00 00 00 
  8035a8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035af:	00 00 00 
  8035b2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035b9:	00 00 00 
  8035bc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035c3:	00 00 00 
  8035c6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035cd:	00 00 00 
  8035d0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035d7:	00 00 00 
  8035da:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035e1:	00 00 00 
  8035e4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035eb:	00 00 00 
  8035ee:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035f5:	00 00 00 
  8035f8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035ff:	00 00 00 
  803602:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803609:	00 00 00 
  80360c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803613:	00 00 00 
  803616:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80361d:	00 00 00 
  803620:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803627:	00 00 00 
  80362a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803631:	00 00 00 
  803634:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80363b:	00 00 00 
  80363e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803645:	00 00 00 
  803648:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80364f:	00 00 00 
  803652:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803659:	00 00 00 
  80365c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803663:	00 00 00 
  803666:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80366d:	00 00 00 
  803670:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803677:	00 00 00 
  80367a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803681:	00 00 00 
  803684:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80368b:	00 00 00 
  80368e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803695:	00 00 00 
  803698:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80369f:	00 00 00 
  8036a2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036a9:	00 00 00 
  8036ac:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036b3:	00 00 00 
  8036b6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036bd:	00 00 00 
  8036c0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036c7:	00 00 00 
  8036ca:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036d1:	00 00 00 
  8036d4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036db:	00 00 00 
  8036de:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036e5:	00 00 00 
  8036e8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036ef:	00 00 00 
  8036f2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036f9:	00 00 00 
  8036fc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803703:	00 00 00 
  803706:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80370d:	00 00 00 
  803710:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803717:	00 00 00 
  80371a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803721:	00 00 00 
  803724:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80372b:	00 00 00 
  80372e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803735:	00 00 00 
  803738:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80373f:	00 00 00 
  803742:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803749:	00 00 00 
  80374c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803753:	00 00 00 
  803756:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80375d:	00 00 00 
  803760:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803767:	00 00 00 
  80376a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803771:	00 00 00 
  803774:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80377b:	00 00 00 
  80377e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803785:	00 00 00 
  803788:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80378f:	00 00 00 
  803792:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803799:	00 00 00 
  80379c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037a3:	00 00 00 
  8037a6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037ad:	00 00 00 
  8037b0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037b7:	00 00 00 
  8037ba:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037c1:	00 00 00 
  8037c4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037cb:	00 00 00 
  8037ce:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037d5:	00 00 00 
  8037d8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037df:	00 00 00 
  8037e2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037e9:	00 00 00 
  8037ec:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037f3:	00 00 00 
  8037f6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037fd:	00 00 00 
  803800:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803807:	00 00 00 
  80380a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803811:	00 00 00 
  803814:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80381b:	00 00 00 
  80381e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803825:	00 00 00 
  803828:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80382f:	00 00 00 
  803832:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803839:	00 00 00 
  80383c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803843:	00 00 00 
  803846:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80384d:	00 00 00 
  803850:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803857:	00 00 00 
  80385a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803861:	00 00 00 
  803864:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80386b:	00 00 00 
  80386e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803875:	00 00 00 
  803878:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80387f:	00 00 00 
  803882:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803889:	00 00 00 
  80388c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803893:	00 00 00 
  803896:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80389d:	00 00 00 
  8038a0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038a7:	00 00 00 
  8038aa:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038b1:	00 00 00 
  8038b4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038bb:	00 00 00 
  8038be:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038c5:	00 00 00 
  8038c8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038cf:	00 00 00 
  8038d2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038d9:	00 00 00 
  8038dc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038e3:	00 00 00 
  8038e6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038ed:	00 00 00 
  8038f0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038f7:	00 00 00 
  8038fa:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803901:	00 00 00 
  803904:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80390b:	00 00 00 
  80390e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803915:	00 00 00 
  803918:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80391f:	00 00 00 
  803922:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803929:	00 00 00 
  80392c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803933:	00 00 00 
  803936:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80393d:	00 00 00 
  803940:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803947:	00 00 00 
  80394a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803951:	00 00 00 
  803954:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80395b:	00 00 00 
  80395e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803965:	00 00 00 
  803968:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80396f:	00 00 00 
  803972:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803979:	00 00 00 
  80397c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803983:	00 00 00 
  803986:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80398d:	00 00 00 
  803990:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803997:	00 00 00 
  80399a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039a1:	00 00 00 
  8039a4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039ab:	00 00 00 
  8039ae:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039b5:	00 00 00 
  8039b8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039bf:	00 00 00 
  8039c2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039c9:	00 00 00 
  8039cc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039d3:	00 00 00 
  8039d6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039dd:	00 00 00 
  8039e0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039e7:	00 00 00 
  8039ea:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039f1:	00 00 00 
  8039f4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039fb:	00 00 00 
  8039fe:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a05:	00 00 00 
  803a08:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a0f:	00 00 00 
  803a12:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a19:	00 00 00 
  803a1c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a23:	00 00 00 
  803a26:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a2d:	00 00 00 
  803a30:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a37:	00 00 00 
  803a3a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a41:	00 00 00 
  803a44:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a4b:	00 00 00 
  803a4e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a55:	00 00 00 
  803a58:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a5f:	00 00 00 
  803a62:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a69:	00 00 00 
  803a6c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a73:	00 00 00 
  803a76:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a7d:	00 00 00 
  803a80:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a87:	00 00 00 
  803a8a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a91:	00 00 00 
  803a94:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a9b:	00 00 00 
  803a9e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803aa5:	00 00 00 
  803aa8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803aaf:	00 00 00 
  803ab2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ab9:	00 00 00 
  803abc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ac3:	00 00 00 
  803ac6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803acd:	00 00 00 
  803ad0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ad7:	00 00 00 
  803ada:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ae1:	00 00 00 
  803ae4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803aeb:	00 00 00 
  803aee:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803af5:	00 00 00 
  803af8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803aff:	00 00 00 
  803b02:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b09:	00 00 00 
  803b0c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b13:	00 00 00 
  803b16:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b1d:	00 00 00 
  803b20:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b27:	00 00 00 
  803b2a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b31:	00 00 00 
  803b34:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b3b:	00 00 00 
  803b3e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b45:	00 00 00 
  803b48:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b4f:	00 00 00 
  803b52:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b59:	00 00 00 
  803b5c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b63:	00 00 00 
  803b66:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b6d:	00 00 00 
  803b70:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b77:	00 00 00 
  803b7a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b81:	00 00 00 
  803b84:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b8b:	00 00 00 
  803b8e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b95:	00 00 00 
  803b98:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b9f:	00 00 00 
  803ba2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ba9:	00 00 00 
  803bac:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bb3:	00 00 00 
  803bb6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bbd:	00 00 00 
  803bc0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bc7:	00 00 00 
  803bca:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bd1:	00 00 00 
  803bd4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bdb:	00 00 00 
  803bde:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803be5:	00 00 00 
  803be8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bef:	00 00 00 
  803bf2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bf9:	00 00 00 
  803bfc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c03:	00 00 00 
  803c06:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c0d:	00 00 00 
  803c10:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c17:	00 00 00 
  803c1a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c21:	00 00 00 
  803c24:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c2b:	00 00 00 
  803c2e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c35:	00 00 00 
  803c38:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c3f:	00 00 00 
  803c42:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c49:	00 00 00 
  803c4c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c53:	00 00 00 
  803c56:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c5d:	00 00 00 
  803c60:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c67:	00 00 00 
  803c6a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c71:	00 00 00 
  803c74:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c7b:	00 00 00 
  803c7e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c85:	00 00 00 
  803c88:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c8f:	00 00 00 
  803c92:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c99:	00 00 00 
  803c9c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ca3:	00 00 00 
  803ca6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cad:	00 00 00 
  803cb0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cb7:	00 00 00 
  803cba:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cc1:	00 00 00 
  803cc4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ccb:	00 00 00 
  803cce:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cd5:	00 00 00 
  803cd8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cdf:	00 00 00 
  803ce2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ce9:	00 00 00 
  803cec:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cf3:	00 00 00 
  803cf6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cfd:	00 00 00 
  803d00:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d07:	00 00 00 
  803d0a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d11:	00 00 00 
  803d14:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d1b:	00 00 00 
  803d1e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d25:	00 00 00 
  803d28:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d2f:	00 00 00 
  803d32:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d39:	00 00 00 
  803d3c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d43:	00 00 00 
  803d46:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d4d:	00 00 00 
  803d50:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d57:	00 00 00 
  803d5a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d61:	00 00 00 
  803d64:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d6b:	00 00 00 
  803d6e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d75:	00 00 00 
  803d78:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d7f:	00 00 00 
  803d82:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d89:	00 00 00 
  803d8c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d93:	00 00 00 
  803d96:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d9d:	00 00 00 
  803da0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803da7:	00 00 00 
  803daa:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803db1:	00 00 00 
  803db4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dbb:	00 00 00 
  803dbe:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dc5:	00 00 00 
  803dc8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dcf:	00 00 00 
  803dd2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dd9:	00 00 00 
  803ddc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803de3:	00 00 00 
  803de6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ded:	00 00 00 
  803df0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803df7:	00 00 00 
  803dfa:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e01:	00 00 00 
  803e04:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e0b:	00 00 00 
  803e0e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e15:	00 00 00 
  803e18:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e1f:	00 00 00 
  803e22:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e29:	00 00 00 
  803e2c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e33:	00 00 00 
  803e36:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e3d:	00 00 00 
  803e40:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e47:	00 00 00 
  803e4a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e51:	00 00 00 
  803e54:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e5b:	00 00 00 
  803e5e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e65:	00 00 00 
  803e68:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e6f:	00 00 00 
  803e72:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e79:	00 00 00 
  803e7c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e83:	00 00 00 
  803e86:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e8d:	00 00 00 
  803e90:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e97:	00 00 00 
  803e9a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ea1:	00 00 00 
  803ea4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803eab:	00 00 00 
  803eae:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803eb5:	00 00 00 
  803eb8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ebf:	00 00 00 
  803ec2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ec9:	00 00 00 
  803ecc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ed3:	00 00 00 
  803ed6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803edd:	00 00 00 
  803ee0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ee7:	00 00 00 
  803eea:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ef1:	00 00 00 
  803ef4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803efb:	00 00 00 
  803efe:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f05:	00 00 00 
  803f08:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f0f:	00 00 00 
  803f12:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f19:	00 00 00 
  803f1c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f23:	00 00 00 
  803f26:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f2d:	00 00 00 
  803f30:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f37:	00 00 00 
  803f3a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f41:	00 00 00 
  803f44:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f4b:	00 00 00 
  803f4e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f55:	00 00 00 
  803f58:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f5f:	00 00 00 
  803f62:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f69:	00 00 00 
  803f6c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f73:	00 00 00 
  803f76:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f7d:	00 00 00 
  803f80:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f87:	00 00 00 
  803f8a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f91:	00 00 00 
  803f94:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f9b:	00 00 00 
  803f9e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fa5:	00 00 00 
  803fa8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803faf:	00 00 00 
  803fb2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fb9:	00 00 00 
  803fbc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fc3:	00 00 00 
  803fc6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fcd:	00 00 00 
  803fd0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fd7:	00 00 00 
  803fda:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fe1:	00 00 00 
  803fe4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803feb:	00 00 00 
  803fee:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ff5:	00 00 00 
  803ff8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  803fff:	00 
