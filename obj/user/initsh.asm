
obj/user/initsh:     file format elf64-x86-64


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
  80001e:	e8 b0 03 00 00       	call   8003d3 <libmain>
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
    int r;

    cprintf("initsh: running sh\n");
  800034:	48 bf 00 40 80 00 00 	movabs $0x804000,%rdi
  80003b:	00 00 00 
  80003e:	b8 00 00 00 00       	mov    $0x0,%eax
  800043:	48 ba 08 06 80 00 00 	movabs $0x800608,%rdx
  80004a:	00 00 00 
  80004d:	ff d2                	call   *%rdx

    /* Being run directly from kernel, so no file descriptors open yet */
    close(0);
  80004f:	bf 00 00 00 00       	mov    $0x0,%edi
  800054:	48 b8 25 1b 80 00 00 	movabs $0x801b25,%rax
  80005b:	00 00 00 
  80005e:	ff d0                	call   *%rax
    if ((r = opencons()) < 0)
  800060:	48 b8 68 03 80 00 00 	movabs $0x800368,%rax
  800067:	00 00 00 
  80006a:	ff d0                	call   *%rax
  80006c:	85 c0                	test   %eax,%eax
  80006e:	78 2f                	js     80009f <umain+0x7a>
        panic("opencons: %i", r);
    if (r != 0)
  800070:	74 5a                	je     8000cc <umain+0xa7>
        panic("first opencons used fd %d", r);
  800072:	89 c1                	mov    %eax,%ecx
  800074:	48 ba 2f 40 80 00 00 	movabs $0x80402f,%rdx
  80007b:	00 00 00 
  80007e:	be 0e 00 00 00       	mov    $0xe,%esi
  800083:	48 bf 21 40 80 00 00 	movabs $0x804021,%rdi
  80008a:	00 00 00 
  80008d:	b8 00 00 00 00       	mov    $0x0,%eax
  800092:	49 b8 ac 04 80 00 00 	movabs $0x8004ac,%r8
  800099:	00 00 00 
  80009c:	41 ff d0             	call   *%r8
        panic("opencons: %i", r);
  80009f:	89 c1                	mov    %eax,%ecx
  8000a1:	48 ba 14 40 80 00 00 	movabs $0x804014,%rdx
  8000a8:	00 00 00 
  8000ab:	be 0c 00 00 00       	mov    $0xc,%esi
  8000b0:	48 bf 21 40 80 00 00 	movabs $0x804021,%rdi
  8000b7:	00 00 00 
  8000ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8000bf:	49 b8 ac 04 80 00 00 	movabs $0x8004ac,%r8
  8000c6:	00 00 00 
  8000c9:	41 ff d0             	call   *%r8
    if ((r = dup(0, 1)) < 0)
  8000cc:	be 01 00 00 00       	mov    $0x1,%esi
  8000d1:	bf 00 00 00 00       	mov    $0x0,%edi
  8000d6:	48 b8 88 1b 80 00 00 	movabs $0x801b88,%rax
  8000dd:	00 00 00 
  8000e0:	ff d0                	call   *%rax
        panic("dup: %i", r);
    while (1) {
        cprintf("init: starting sh\n");
  8000e2:	49 be 51 40 80 00 00 	movabs $0x804051,%r14
  8000e9:	00 00 00 
  8000ec:	48 bb 08 06 80 00 00 	movabs $0x800608,%rbx
  8000f3:	00 00 00 
        r = spawnl("/sh", "sh", (char *)0);
  8000f6:	49 bd 65 40 80 00 00 	movabs $0x804065,%r13
  8000fd:	00 00 00 
  800100:	49 bc 64 40 80 00 00 	movabs $0x804064,%r12
  800107:	00 00 00 
    if ((r = dup(0, 1)) < 0)
  80010a:	85 c0                	test   %eax,%eax
  80010c:	79 40                	jns    80014e <umain+0x129>
        panic("dup: %i", r);
  80010e:	89 c1                	mov    %eax,%ecx
  800110:	48 ba 49 40 80 00 00 	movabs $0x804049,%rdx
  800117:	00 00 00 
  80011a:	be 10 00 00 00       	mov    $0x10,%esi
  80011f:	48 bf 21 40 80 00 00 	movabs $0x804021,%rdi
  800126:	00 00 00 
  800129:	b8 00 00 00 00       	mov    $0x0,%eax
  80012e:	49 b8 ac 04 80 00 00 	movabs $0x8004ac,%r8
  800135:	00 00 00 
  800138:	41 ff d0             	call   *%r8
        if (r < 0) {
            cprintf("init: spawn sh: %i\n", r);
  80013b:	89 c6                	mov    %eax,%esi
  80013d:	48 bf 68 40 80 00 00 	movabs $0x804068,%rdi
  800144:	00 00 00 
  800147:	b8 00 00 00 00       	mov    $0x0,%eax
  80014c:	ff d3                	call   *%rbx
        cprintf("init: starting sh\n");
  80014e:	4c 89 f7             	mov    %r14,%rdi
  800151:	b8 00 00 00 00       	mov    $0x0,%eax
  800156:	ff d3                	call   *%rbx
        r = spawnl("/sh", "sh", (char *)0);
  800158:	ba 00 00 00 00       	mov    $0x0,%edx
  80015d:	4c 89 ee             	mov    %r13,%rsi
  800160:	4c 89 e7             	mov    %r12,%rdi
  800163:	b8 00 00 00 00       	mov    $0x0,%eax
  800168:	48 b9 06 2b 80 00 00 	movabs $0x802b06,%rcx
  80016f:	00 00 00 
  800172:	ff d1                	call   *%rcx
        if (r < 0) {
  800174:	85 c0                	test   %eax,%eax
  800176:	78 c3                	js     80013b <umain+0x116>
            continue;
        }
        wait(r);
  800178:	89 c7                	mov    %eax,%edi
  80017a:	48 b8 56 31 80 00 00 	movabs $0x803156,%rax
  800181:	00 00 00 
  800184:	ff d0                	call   *%rax
  800186:	eb c6                	jmp    80014e <umain+0x129>

0000000000800188 <devcons_close>:

    return res;
}

static int
devcons_close(struct Fd *fd) {
  800188:	f3 0f 1e fa          	endbr64
    USED(fd);

    return 0;
}
  80018c:	b8 00 00 00 00       	mov    $0x0,%eax
  800191:	c3                   	ret

0000000000800192 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  800192:	f3 0f 1e fa          	endbr64
  800196:	55                   	push   %rbp
  800197:	48 89 e5             	mov    %rsp,%rbp
  80019a:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  80019d:	48 be 7c 40 80 00 00 	movabs $0x80407c,%rsi
  8001a4:	00 00 00 
  8001a7:	48 b8 51 0f 80 00 00 	movabs $0x800f51,%rax
  8001ae:	00 00 00 
  8001b1:	ff d0                	call   *%rax
    return 0;
}
  8001b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8001b8:	5d                   	pop    %rbp
  8001b9:	c3                   	ret

00000000008001ba <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  8001ba:	f3 0f 1e fa          	endbr64
  8001be:	55                   	push   %rbp
  8001bf:	48 89 e5             	mov    %rsp,%rbp
  8001c2:	41 57                	push   %r15
  8001c4:	41 56                	push   %r14
  8001c6:	41 55                	push   %r13
  8001c8:	41 54                	push   %r12
  8001ca:	53                   	push   %rbx
  8001cb:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  8001d2:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  8001d9:	48 85 d2             	test   %rdx,%rdx
  8001dc:	74 7a                	je     800258 <devcons_write+0x9e>
  8001de:	49 89 d6             	mov    %rdx,%r14
  8001e1:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  8001e7:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  8001ec:	49 bf 6c 11 80 00 00 	movabs $0x80116c,%r15
  8001f3:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  8001f6:	4c 89 f3             	mov    %r14,%rbx
  8001f9:	48 29 f3             	sub    %rsi,%rbx
  8001fc:	b8 7f 00 00 00       	mov    $0x7f,%eax
  800201:	48 39 c3             	cmp    %rax,%rbx
  800204:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  800208:	4c 63 eb             	movslq %ebx,%r13
  80020b:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  800212:	48 01 c6             	add    %rax,%rsi
  800215:	4c 89 ea             	mov    %r13,%rdx
  800218:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  80021f:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  800222:	4c 89 ee             	mov    %r13,%rsi
  800225:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  80022c:	48 b8 b1 13 80 00 00 	movabs $0x8013b1,%rax
  800233:	00 00 00 
  800236:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  800238:	41 01 dc             	add    %ebx,%r12d
  80023b:	49 63 f4             	movslq %r12d,%rsi
  80023e:	4c 39 f6             	cmp    %r14,%rsi
  800241:	72 b3                	jb     8001f6 <devcons_write+0x3c>
    return res;
  800243:	49 63 c4             	movslq %r12d,%rax
}
  800246:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  80024d:	5b                   	pop    %rbx
  80024e:	41 5c                	pop    %r12
  800250:	41 5d                	pop    %r13
  800252:	41 5e                	pop    %r14
  800254:	41 5f                	pop    %r15
  800256:	5d                   	pop    %rbp
  800257:	c3                   	ret
    for (res = 0; res < n; res += inc) {
  800258:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  80025e:	eb e3                	jmp    800243 <devcons_write+0x89>

0000000000800260 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  800260:	f3 0f 1e fa          	endbr64
  800264:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  800267:	ba 00 00 00 00       	mov    $0x0,%edx
  80026c:	48 85 c0             	test   %rax,%rax
  80026f:	74 55                	je     8002c6 <devcons_read+0x66>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  800271:	55                   	push   %rbp
  800272:	48 89 e5             	mov    %rsp,%rbp
  800275:	41 55                	push   %r13
  800277:	41 54                	push   %r12
  800279:	53                   	push   %rbx
  80027a:	48 83 ec 08          	sub    $0x8,%rsp
  80027e:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  800281:	48 bb e2 13 80 00 00 	movabs $0x8013e2,%rbx
  800288:	00 00 00 
  80028b:	49 bc bb 14 80 00 00 	movabs $0x8014bb,%r12
  800292:	00 00 00 
  800295:	eb 03                	jmp    80029a <devcons_read+0x3a>
  800297:	41 ff d4             	call   *%r12
  80029a:	ff d3                	call   *%rbx
  80029c:	85 c0                	test   %eax,%eax
  80029e:	74 f7                	je     800297 <devcons_read+0x37>
    if (c < 0) return c;
  8002a0:	48 63 d0             	movslq %eax,%rdx
  8002a3:	78 13                	js     8002b8 <devcons_read+0x58>
    if (c == 0x04) return 0;
  8002a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8002aa:	83 f8 04             	cmp    $0x4,%eax
  8002ad:	74 09                	je     8002b8 <devcons_read+0x58>
    *(char *)vbuf = (char)c;
  8002af:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  8002b3:	ba 01 00 00 00       	mov    $0x1,%edx
}
  8002b8:	48 89 d0             	mov    %rdx,%rax
  8002bb:	48 83 c4 08          	add    $0x8,%rsp
  8002bf:	5b                   	pop    %rbx
  8002c0:	41 5c                	pop    %r12
  8002c2:	41 5d                	pop    %r13
  8002c4:	5d                   	pop    %rbp
  8002c5:	c3                   	ret
  8002c6:	48 89 d0             	mov    %rdx,%rax
  8002c9:	c3                   	ret

00000000008002ca <cputchar>:
cputchar(int ch) {
  8002ca:	f3 0f 1e fa          	endbr64
  8002ce:	55                   	push   %rbp
  8002cf:	48 89 e5             	mov    %rsp,%rbp
  8002d2:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  8002d6:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  8002da:	be 01 00 00 00       	mov    $0x1,%esi
  8002df:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  8002e3:	48 b8 b1 13 80 00 00 	movabs $0x8013b1,%rax
  8002ea:	00 00 00 
  8002ed:	ff d0                	call   *%rax
}
  8002ef:	c9                   	leave
  8002f0:	c3                   	ret

00000000008002f1 <getchar>:
getchar(void) {
  8002f1:	f3 0f 1e fa          	endbr64
  8002f5:	55                   	push   %rbp
  8002f6:	48 89 e5             	mov    %rsp,%rbp
  8002f9:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  8002fd:	ba 01 00 00 00       	mov    $0x1,%edx
  800302:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  800306:	bf 00 00 00 00       	mov    $0x0,%edi
  80030b:	48 b8 af 1c 80 00 00 	movabs $0x801caf,%rax
  800312:	00 00 00 
  800315:	ff d0                	call   *%rax
  800317:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  800319:	85 c0                	test   %eax,%eax
  80031b:	78 06                	js     800323 <getchar+0x32>
  80031d:	74 08                	je     800327 <getchar+0x36>
  80031f:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  800323:	89 d0                	mov    %edx,%eax
  800325:	c9                   	leave
  800326:	c3                   	ret
    return res < 0 ? res : res ? c :
  800327:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  80032c:	eb f5                	jmp    800323 <getchar+0x32>

000000000080032e <iscons>:
iscons(int fdnum) {
  80032e:	f3 0f 1e fa          	endbr64
  800332:	55                   	push   %rbp
  800333:	48 89 e5             	mov    %rsp,%rbp
  800336:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  80033a:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  80033e:	48 b8 b4 19 80 00 00 	movabs $0x8019b4,%rax
  800345:	00 00 00 
  800348:	ff d0                	call   *%rax
    if (res < 0) return res;
  80034a:	85 c0                	test   %eax,%eax
  80034c:	78 18                	js     800366 <iscons+0x38>
    return fd->fd_dev_id == devcons.dev_id;
  80034e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800352:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  800359:	00 00 00 
  80035c:	8b 00                	mov    (%rax),%eax
  80035e:	39 02                	cmp    %eax,(%rdx)
  800360:	0f 94 c0             	sete   %al
  800363:	0f b6 c0             	movzbl %al,%eax
}
  800366:	c9                   	leave
  800367:	c3                   	ret

0000000000800368 <opencons>:
opencons(void) {
  800368:	f3 0f 1e fa          	endbr64
  80036c:	55                   	push   %rbp
  80036d:	48 89 e5             	mov    %rsp,%rbp
  800370:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  800374:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  800378:	48 b8 50 19 80 00 00 	movabs $0x801950,%rax
  80037f:	00 00 00 
  800382:	ff d0                	call   *%rax
  800384:	85 c0                	test   %eax,%eax
  800386:	78 49                	js     8003d1 <opencons+0x69>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  800388:	b9 46 00 00 00       	mov    $0x46,%ecx
  80038d:	ba 00 10 00 00       	mov    $0x1000,%edx
  800392:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  800396:	bf 00 00 00 00       	mov    $0x0,%edi
  80039b:	48 b8 56 15 80 00 00 	movabs $0x801556,%rax
  8003a2:	00 00 00 
  8003a5:	ff d0                	call   *%rax
  8003a7:	85 c0                	test   %eax,%eax
  8003a9:	78 26                	js     8003d1 <opencons+0x69>
    fd->fd_dev_id = devcons.dev_id;
  8003ab:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8003af:	a1 00 50 80 00 00 00 	movabs 0x805000,%eax
  8003b6:	00 00 
  8003b8:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  8003ba:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8003be:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  8003c5:	48 b8 1a 19 80 00 00 	movabs $0x80191a,%rax
  8003cc:	00 00 00 
  8003cf:	ff d0                	call   *%rax
}
  8003d1:	c9                   	leave
  8003d2:	c3                   	ret

00000000008003d3 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  8003d3:	f3 0f 1e fa          	endbr64
  8003d7:	55                   	push   %rbp
  8003d8:	48 89 e5             	mov    %rsp,%rbp
  8003db:	41 56                	push   %r14
  8003dd:	41 55                	push   %r13
  8003df:	41 54                	push   %r12
  8003e1:	53                   	push   %rbx
  8003e2:	41 89 fd             	mov    %edi,%r13d
  8003e5:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
     * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  8003e8:	48 ba b8 50 80 00 00 	movabs $0x8050b8,%rdx
  8003ef:	00 00 00 
  8003f2:	48 b8 b8 50 80 00 00 	movabs $0x8050b8,%rax
  8003f9:	00 00 00 
  8003fc:	48 39 c2             	cmp    %rax,%rdx
  8003ff:	73 17                	jae    800418 <libmain+0x45>
    void (**ctor)() = &__ctors_start;
  800401:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  800404:	49 89 c4             	mov    %rax,%r12
  800407:	48 83 c3 08          	add    $0x8,%rbx
  80040b:	b8 00 00 00 00       	mov    $0x0,%eax
  800410:	ff 53 f8             	call   *-0x8(%rbx)
  800413:	4c 39 e3             	cmp    %r12,%rbx
  800416:	72 ef                	jb     800407 <libmain+0x34>

    /* Set thisenv to point at our Env structure in envs[]. */

    // LAB 8: Your code here
    thisenv = &((struct Env *)UENVS)[ENVX(sys_getenvid())];
  800418:	48 b8 86 14 80 00 00 	movabs $0x801486,%rax
  80041f:	00 00 00 
  800422:	ff d0                	call   *%rax
  800424:	25 ff 03 00 00       	and    $0x3ff,%eax
  800429:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  80042d:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  800431:	48 c1 e0 04          	shl    $0x4,%rax
  800435:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  80043c:	00 00 00 
  80043f:	48 01 d0             	add    %rdx,%rax
  800442:	48 a3 00 60 80 00 00 	movabs %rax,0x806000
  800449:	00 00 00 

    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  80044c:	45 85 ed             	test   %r13d,%r13d
  80044f:	7e 0d                	jle    80045e <libmain+0x8b>
  800451:	49 8b 06             	mov    (%r14),%rax
  800454:	48 a3 38 50 80 00 00 	movabs %rax,0x805038
  80045b:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  80045e:	4c 89 f6             	mov    %r14,%rsi
  800461:	44 89 ef             	mov    %r13d,%edi
  800464:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  80046b:	00 00 00 
  80046e:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  800470:	48 b8 85 04 80 00 00 	movabs $0x800485,%rax
  800477:	00 00 00 
  80047a:	ff d0                	call   *%rax
#endif
}
  80047c:	5b                   	pop    %rbx
  80047d:	41 5c                	pop    %r12
  80047f:	41 5d                	pop    %r13
  800481:	41 5e                	pop    %r14
  800483:	5d                   	pop    %rbp
  800484:	c3                   	ret

0000000000800485 <exit>:

#include <inc/lib.h>

void
exit(void) {
  800485:	f3 0f 1e fa          	endbr64
  800489:	55                   	push   %rbp
  80048a:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  80048d:	48 b8 5c 1b 80 00 00 	movabs $0x801b5c,%rax
  800494:	00 00 00 
  800497:	ff d0                	call   *%rax
    sys_env_destroy(0);
  800499:	bf 00 00 00 00       	mov    $0x0,%edi
  80049e:	48 b8 17 14 80 00 00 	movabs $0x801417,%rax
  8004a5:	00 00 00 
  8004a8:	ff d0                	call   *%rax
}
  8004aa:	5d                   	pop    %rbp
  8004ab:	c3                   	ret

00000000008004ac <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  8004ac:	f3 0f 1e fa          	endbr64
  8004b0:	55                   	push   %rbp
  8004b1:	48 89 e5             	mov    %rsp,%rbp
  8004b4:	41 56                	push   %r14
  8004b6:	41 55                	push   %r13
  8004b8:	41 54                	push   %r12
  8004ba:	53                   	push   %rbx
  8004bb:	48 83 ec 50          	sub    $0x50,%rsp
  8004bf:	49 89 fc             	mov    %rdi,%r12
  8004c2:	41 89 f5             	mov    %esi,%r13d
  8004c5:	48 89 d3             	mov    %rdx,%rbx
  8004c8:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8004cc:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  8004d0:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  8004d4:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  8004db:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8004df:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  8004e3:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  8004e7:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  8004eb:	48 b8 38 50 80 00 00 	movabs $0x805038,%rax
  8004f2:	00 00 00 
  8004f5:	4c 8b 30             	mov    (%rax),%r14
  8004f8:	48 b8 86 14 80 00 00 	movabs $0x801486,%rax
  8004ff:	00 00 00 
  800502:	ff d0                	call   *%rax
  800504:	89 c6                	mov    %eax,%esi
  800506:	45 89 e8             	mov    %r13d,%r8d
  800509:	4c 89 e1             	mov    %r12,%rcx
  80050c:	4c 89 f2             	mov    %r14,%rdx
  80050f:	48 bf 58 43 80 00 00 	movabs $0x804358,%rdi
  800516:	00 00 00 
  800519:	b8 00 00 00 00       	mov    $0x0,%eax
  80051e:	49 bc 08 06 80 00 00 	movabs $0x800608,%r12
  800525:	00 00 00 
  800528:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  80052b:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  80052f:	48 89 df             	mov    %rbx,%rdi
  800532:	48 b8 a0 05 80 00 00 	movabs $0x8005a0,%rax
  800539:	00 00 00 
  80053c:	ff d0                	call   *%rax
    cprintf("\n");
  80053e:	48 bf 49 42 80 00 00 	movabs $0x804249,%rdi
  800545:	00 00 00 
  800548:	b8 00 00 00 00       	mov    $0x0,%eax
  80054d:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  800550:	cc                   	int3
  800551:	eb fd                	jmp    800550 <_panic+0xa4>

0000000000800553 <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  800553:	f3 0f 1e fa          	endbr64
  800557:	55                   	push   %rbp
  800558:	48 89 e5             	mov    %rsp,%rbp
  80055b:	53                   	push   %rbx
  80055c:	48 83 ec 08          	sub    $0x8,%rsp
  800560:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  800563:	8b 06                	mov    (%rsi),%eax
  800565:	8d 50 01             	lea    0x1(%rax),%edx
  800568:	89 16                	mov    %edx,(%rsi)
  80056a:	48 98                	cltq
  80056c:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  800571:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  800577:	74 0a                	je     800583 <putch+0x30>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  800579:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  80057d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800581:	c9                   	leave
  800582:	c3                   	ret
        sys_cputs(state->buf, state->offset);
  800583:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  800587:	be ff 00 00 00       	mov    $0xff,%esi
  80058c:	48 b8 b1 13 80 00 00 	movabs $0x8013b1,%rax
  800593:	00 00 00 
  800596:	ff d0                	call   *%rax
        state->offset = 0;
  800598:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  80059e:	eb d9                	jmp    800579 <putch+0x26>

00000000008005a0 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  8005a0:	f3 0f 1e fa          	endbr64
  8005a4:	55                   	push   %rbp
  8005a5:	48 89 e5             	mov    %rsp,%rbp
  8005a8:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8005af:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  8005b2:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  8005b9:	b9 21 00 00 00       	mov    $0x21,%ecx
  8005be:	b8 00 00 00 00       	mov    $0x0,%eax
  8005c3:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  8005c6:	48 89 f1             	mov    %rsi,%rcx
  8005c9:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  8005d0:	48 bf 53 05 80 00 00 	movabs $0x800553,%rdi
  8005d7:	00 00 00 
  8005da:	48 b8 68 07 80 00 00 	movabs $0x800768,%rax
  8005e1:	00 00 00 
  8005e4:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  8005e6:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  8005ed:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  8005f4:	48 b8 b1 13 80 00 00 	movabs $0x8013b1,%rax
  8005fb:	00 00 00 
  8005fe:	ff d0                	call   *%rax

    return state.count;
}
  800600:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  800606:	c9                   	leave
  800607:	c3                   	ret

0000000000800608 <cprintf>:

int
cprintf(const char *fmt, ...) {
  800608:	f3 0f 1e fa          	endbr64
  80060c:	55                   	push   %rbp
  80060d:	48 89 e5             	mov    %rsp,%rbp
  800610:	48 83 ec 50          	sub    $0x50,%rsp
  800614:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  800618:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80061c:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800620:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800624:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  800628:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  80062f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800633:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800637:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80063b:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  80063f:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  800643:	48 b8 a0 05 80 00 00 	movabs $0x8005a0,%rax
  80064a:	00 00 00 
  80064d:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  80064f:	c9                   	leave
  800650:	c3                   	ret

0000000000800651 <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  800651:	f3 0f 1e fa          	endbr64
  800655:	55                   	push   %rbp
  800656:	48 89 e5             	mov    %rsp,%rbp
  800659:	41 57                	push   %r15
  80065b:	41 56                	push   %r14
  80065d:	41 55                	push   %r13
  80065f:	41 54                	push   %r12
  800661:	53                   	push   %rbx
  800662:	48 83 ec 18          	sub    $0x18,%rsp
  800666:	49 89 fc             	mov    %rdi,%r12
  800669:	49 89 f5             	mov    %rsi,%r13
  80066c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  800670:	8b 45 10             	mov    0x10(%rbp),%eax
  800673:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  800676:	41 89 cf             	mov    %ecx,%r15d
  800679:	4c 39 fa             	cmp    %r15,%rdx
  80067c:	73 5b                	jae    8006d9 <print_num+0x88>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  80067e:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  800682:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  800686:	85 db                	test   %ebx,%ebx
  800688:	7e 0e                	jle    800698 <print_num+0x47>
            putch(padc, put_arg);
  80068a:	4c 89 ee             	mov    %r13,%rsi
  80068d:	44 89 f7             	mov    %r14d,%edi
  800690:	41 ff d4             	call   *%r12
        while (--width > 0) {
  800693:	83 eb 01             	sub    $0x1,%ebx
  800696:	75 f2                	jne    80068a <print_num+0x39>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  800698:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  80069c:	48 b9 a3 40 80 00 00 	movabs $0x8040a3,%rcx
  8006a3:	00 00 00 
  8006a6:	48 b8 92 40 80 00 00 	movabs $0x804092,%rax
  8006ad:	00 00 00 
  8006b0:	48 0f 45 c8          	cmovne %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  8006b4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8006b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8006bd:	49 f7 f7             	div    %r15
  8006c0:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  8006c4:	4c 89 ee             	mov    %r13,%rsi
  8006c7:	41 ff d4             	call   *%r12
}
  8006ca:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  8006ce:	5b                   	pop    %rbx
  8006cf:	41 5c                	pop    %r12
  8006d1:	41 5d                	pop    %r13
  8006d3:	41 5e                	pop    %r14
  8006d5:	41 5f                	pop    %r15
  8006d7:	5d                   	pop    %rbp
  8006d8:	c3                   	ret
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  8006d9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8006dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8006e2:	49 f7 f7             	div    %r15
  8006e5:	48 83 ec 08          	sub    $0x8,%rsp
  8006e9:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  8006ed:	52                   	push   %rdx
  8006ee:	45 0f be c9          	movsbl %r9b,%r9d
  8006f2:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  8006f6:	48 89 c2             	mov    %rax,%rdx
  8006f9:	48 b8 51 06 80 00 00 	movabs $0x800651,%rax
  800700:	00 00 00 
  800703:	ff d0                	call   *%rax
  800705:	48 83 c4 10          	add    $0x10,%rsp
  800709:	eb 8d                	jmp    800698 <print_num+0x47>

000000000080070b <sprintputch>:
    char *end;
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
  80070b:	f3 0f 1e fa          	endbr64
    state->count++;
  80070f:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  800713:	48 8b 06             	mov    (%rsi),%rax
  800716:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  80071a:	73 0a                	jae    800726 <sprintputch+0x1b>
        *state->start++ = ch;
  80071c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800720:	48 89 16             	mov    %rdx,(%rsi)
  800723:	40 88 38             	mov    %dil,(%rax)
    }
}
  800726:	c3                   	ret

0000000000800727 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  800727:	f3 0f 1e fa          	endbr64
  80072b:	55                   	push   %rbp
  80072c:	48 89 e5             	mov    %rsp,%rbp
  80072f:	48 83 ec 50          	sub    $0x50,%rsp
  800733:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800737:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  80073b:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  80073f:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800746:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80074a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80074e:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800752:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  800756:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  80075a:	48 b8 68 07 80 00 00 	movabs $0x800768,%rax
  800761:	00 00 00 
  800764:	ff d0                	call   *%rax
}
  800766:	c9                   	leave
  800767:	c3                   	ret

0000000000800768 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  800768:	f3 0f 1e fa          	endbr64
  80076c:	55                   	push   %rbp
  80076d:	48 89 e5             	mov    %rsp,%rbp
  800770:	41 57                	push   %r15
  800772:	41 56                	push   %r14
  800774:	41 55                	push   %r13
  800776:	41 54                	push   %r12
  800778:	53                   	push   %rbx
  800779:	48 83 ec 38          	sub    $0x38,%rsp
  80077d:	49 89 fe             	mov    %rdi,%r14
  800780:	49 89 f5             	mov    %rsi,%r13
  800783:	48 89 d3             	mov    %rdx,%rbx
    va_copy(aq, ap);
  800786:	48 8b 01             	mov    (%rcx),%rax
  800789:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  80078d:	48 8b 41 08          	mov    0x8(%rcx),%rax
  800791:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800795:	48 8b 41 10          	mov    0x10(%rcx),%rax
  800799:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  80079d:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  8007a1:	0f b6 3b             	movzbl (%rbx),%edi
  8007a4:	40 80 ff 25          	cmp    $0x25,%dil
  8007a8:	74 18                	je     8007c2 <vprintfmt+0x5a>
            if (!ch) return;
  8007aa:	40 84 ff             	test   %dil,%dil
  8007ad:	0f 84 b2 06 00 00    	je     800e65 <vprintfmt+0x6fd>
            putch(ch, put_arg);
  8007b3:	40 0f b6 ff          	movzbl %dil,%edi
  8007b7:	4c 89 ee             	mov    %r13,%rsi
  8007ba:	41 ff d6             	call   *%r14
        while ((ch = *ufmt++) != '%') {
  8007bd:	4c 89 e3             	mov    %r12,%rbx
  8007c0:	eb db                	jmp    80079d <vprintfmt+0x35>
        bool altflag = 0, zflag = 0;
  8007c2:	be 00 00 00 00       	mov    $0x0,%esi
  8007c7:	c6 45 ab 00          	movb   $0x0,-0x55(%rbp)
        unsigned lflag = 0, base = 10;
  8007cb:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  8007d0:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  8007d6:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  8007dd:	c6 45 aa 20          	movb   $0x20,-0x56(%rbp)
        switch (ch = *ufmt++) {
  8007e1:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  8007e6:	41 0f b6 04 24       	movzbl (%r12),%eax
  8007eb:	88 45 a0             	mov    %al,-0x60(%rbp)
  8007ee:	83 e8 23             	sub    $0x23,%eax
  8007f1:	3c 57                	cmp    $0x57,%al
  8007f3:	0f 87 52 06 00 00    	ja     800e4b <vprintfmt+0x6e3>
  8007f9:	0f b6 c0             	movzbl %al,%eax
  8007fc:	48 b9 a0 44 80 00 00 	movabs $0x8044a0,%rcx
  800803:	00 00 00 
  800806:	3e ff 24 c1          	notrack jmp *(%rcx,%rax,8)
  80080a:	49 89 dc             	mov    %rbx,%r12
            altflag = 1;
  80080d:	c6 45 ab 01          	movb   $0x1,-0x55(%rbp)
  800811:	eb ce                	jmp    8007e1 <vprintfmt+0x79>
        switch (ch = *ufmt++) {
  800813:	49 89 dc             	mov    %rbx,%r12
  800816:	be 01 00 00 00       	mov    $0x1,%esi
  80081b:	eb c4                	jmp    8007e1 <vprintfmt+0x79>
            padc = ch;
  80081d:	0f b6 45 a0          	movzbl -0x60(%rbp),%eax
  800821:	88 45 aa             	mov    %al,-0x56(%rbp)
        switch (ch = *ufmt++) {
  800824:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  800827:	eb b8                	jmp    8007e1 <vprintfmt+0x79>
            precision = va_arg(aq, int);
  800829:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80082c:	83 f8 2f             	cmp    $0x2f,%eax
  80082f:	77 24                	ja     800855 <vprintfmt+0xed>
  800831:	89 c1                	mov    %eax,%ecx
  800833:	48 03 4d c8          	add    -0x38(%rbp),%rcx
  800837:	83 c0 08             	add    $0x8,%eax
  80083a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80083d:	44 8b 39             	mov    (%rcx),%r15d
        switch (ch = *ufmt++) {
  800840:	49 89 dc             	mov    %rbx,%r12
            if (width < 0) {
  800843:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800847:	79 98                	jns    8007e1 <vprintfmt+0x79>
                width = precision;
  800849:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
                precision = -1;
  80084d:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  800853:	eb 8c                	jmp    8007e1 <vprintfmt+0x79>
            precision = va_arg(aq, int);
  800855:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  800859:	48 8d 41 08          	lea    0x8(%rcx),%rax
  80085d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800861:	eb da                	jmp    80083d <vprintfmt+0xd5>
                precision = precision * 10 + ch - '0';
  800863:	44 0f b6 7d a0       	movzbl -0x60(%rbp),%r15d
  800868:	41 83 ef 30          	sub    $0x30,%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  80086c:	41 0f b6 44 24 01    	movzbl 0x1(%r12),%eax
  800872:	3c 39                	cmp    $0x39,%al
  800874:	77 1c                	ja     800892 <vprintfmt+0x12a>
            for (precision = 0;; ++ufmt) {
  800876:	48 83 c3 01          	add    $0x1,%rbx
                precision = precision * 10 + ch - '0';
  80087a:	43 8d 0c bf          	lea    (%r15,%r15,4),%ecx
  80087e:	0f b6 c0             	movzbl %al,%eax
  800881:	44 8d 7c 48 d0       	lea    -0x30(%rax,%rcx,2),%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  800886:	0f b6 03             	movzbl (%rbx),%eax
  800889:	3c 39                	cmp    $0x39,%al
  80088b:	76 e9                	jbe    800876 <vprintfmt+0x10e>
        process_precision:
  80088d:	49 89 dc             	mov    %rbx,%r12
  800890:	eb b1                	jmp    800843 <vprintfmt+0xdb>
        switch (ch = *ufmt++) {
  800892:	49 89 dc             	mov    %rbx,%r12
  800895:	eb ac                	jmp    800843 <vprintfmt+0xdb>
            width = MAX(0, width);
  800897:	8b 4d ac             	mov    -0x54(%rbp),%ecx
  80089a:	85 c9                	test   %ecx,%ecx
  80089c:	b8 00 00 00 00       	mov    $0x0,%eax
  8008a1:	0f 49 c1             	cmovns %ecx,%eax
  8008a4:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  8008a7:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  8008aa:	e9 32 ff ff ff       	jmp    8007e1 <vprintfmt+0x79>
            lflag++;
  8008af:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  8008b2:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  8008b5:	e9 27 ff ff ff       	jmp    8007e1 <vprintfmt+0x79>
            putch(va_arg(aq, int), put_arg);
  8008ba:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008bd:	83 f8 2f             	cmp    $0x2f,%eax
  8008c0:	77 19                	ja     8008db <vprintfmt+0x173>
  8008c2:	89 c2                	mov    %eax,%edx
  8008c4:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8008c8:	83 c0 08             	add    $0x8,%eax
  8008cb:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008ce:	8b 3a                	mov    (%rdx),%edi
  8008d0:	4c 89 ee             	mov    %r13,%rsi
  8008d3:	41 ff d6             	call   *%r14
            break;
  8008d6:	e9 c2 fe ff ff       	jmp    80079d <vprintfmt+0x35>
            putch(va_arg(aq, int), put_arg);
  8008db:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008df:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8008e3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008e7:	eb e5                	jmp    8008ce <vprintfmt+0x166>
            int err = va_arg(aq, int);
  8008e9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008ec:	83 f8 2f             	cmp    $0x2f,%eax
  8008ef:	77 5a                	ja     80094b <vprintfmt+0x1e3>
  8008f1:	89 c2                	mov    %eax,%edx
  8008f3:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8008f7:	83 c0 08             	add    $0x8,%eax
  8008fa:	89 45 b8             	mov    %eax,-0x48(%rbp)
            if (err < 0) err = -err;
  8008fd:	8b 02                	mov    (%rdx),%eax
  8008ff:	89 c1                	mov    %eax,%ecx
  800901:	f7 d9                	neg    %ecx
  800903:	0f 48 c8             	cmovs  %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  800906:	83 f9 13             	cmp    $0x13,%ecx
  800909:	7f 4e                	jg     800959 <vprintfmt+0x1f1>
  80090b:	48 63 c1             	movslq %ecx,%rax
  80090e:	48 ba 60 47 80 00 00 	movabs $0x804760,%rdx
  800915:	00 00 00 
  800918:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80091c:	48 85 c0             	test   %rax,%rax
  80091f:	74 38                	je     800959 <vprintfmt+0x1f1>
                printfmt(putch, put_arg, "%s", strerr);
  800921:	48 89 c1             	mov    %rax,%rcx
  800924:	48 ba 97 42 80 00 00 	movabs $0x804297,%rdx
  80092b:	00 00 00 
  80092e:	4c 89 ee             	mov    %r13,%rsi
  800931:	4c 89 f7             	mov    %r14,%rdi
  800934:	b8 00 00 00 00       	mov    $0x0,%eax
  800939:	49 b8 27 07 80 00 00 	movabs $0x800727,%r8
  800940:	00 00 00 
  800943:	41 ff d0             	call   *%r8
  800946:	e9 52 fe ff ff       	jmp    80079d <vprintfmt+0x35>
            int err = va_arg(aq, int);
  80094b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80094f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800953:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800957:	eb a4                	jmp    8008fd <vprintfmt+0x195>
                printfmt(putch, put_arg, "error %d", err);
  800959:	48 ba bb 40 80 00 00 	movabs $0x8040bb,%rdx
  800960:	00 00 00 
  800963:	4c 89 ee             	mov    %r13,%rsi
  800966:	4c 89 f7             	mov    %r14,%rdi
  800969:	b8 00 00 00 00       	mov    $0x0,%eax
  80096e:	49 b8 27 07 80 00 00 	movabs $0x800727,%r8
  800975:	00 00 00 
  800978:	41 ff d0             	call   *%r8
  80097b:	e9 1d fe ff ff       	jmp    80079d <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  800980:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800983:	83 f8 2f             	cmp    $0x2f,%eax
  800986:	77 6c                	ja     8009f4 <vprintfmt+0x28c>
  800988:	89 c2                	mov    %eax,%edx
  80098a:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80098e:	83 c0 08             	add    $0x8,%eax
  800991:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800994:	48 8b 12             	mov    (%rdx),%rdx
            if (!ptr) ptr = "(null)";
  800997:	48 85 d2             	test   %rdx,%rdx
  80099a:	48 b8 b4 40 80 00 00 	movabs $0x8040b4,%rax
  8009a1:	00 00 00 
  8009a4:	48 0f 45 c2          	cmovne %rdx,%rax
  8009a8:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
            if (width > 0 && padc != '-') {
  8009ac:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8009b0:	7e 06                	jle    8009b8 <vprintfmt+0x250>
  8009b2:	80 7d aa 2d          	cmpb   $0x2d,-0x56(%rbp)
  8009b6:	75 4a                	jne    800a02 <vprintfmt+0x29a>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  8009b8:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8009bc:	4c 8d 60 01          	lea    0x1(%rax),%r12
  8009c0:	0f b6 00             	movzbl (%rax),%eax
  8009c3:	84 c0                	test   %al,%al
  8009c5:	0f 85 9a 00 00 00    	jne    800a65 <vprintfmt+0x2fd>
            while (width-- > 0) putch(' ', put_arg);
  8009cb:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8009ce:	44 8d 60 ff          	lea    -0x1(%rax),%r12d
  8009d2:	85 c0                	test   %eax,%eax
  8009d4:	0f 8e c3 fd ff ff    	jle    80079d <vprintfmt+0x35>
  8009da:	4c 89 ee             	mov    %r13,%rsi
  8009dd:	bf 20 00 00 00       	mov    $0x20,%edi
  8009e2:	41 ff d6             	call   *%r14
  8009e5:	41 83 ec 01          	sub    $0x1,%r12d
  8009e9:	41 83 fc ff          	cmp    $0xffffffff,%r12d
  8009ed:	75 eb                	jne    8009da <vprintfmt+0x272>
  8009ef:	e9 a9 fd ff ff       	jmp    80079d <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  8009f4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009f8:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009fc:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a00:	eb 92                	jmp    800994 <vprintfmt+0x22c>
                width -= strnlen(ptr, precision);
  800a02:	49 63 f7             	movslq %r15d,%rsi
  800a05:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  800a09:	48 b8 2b 0f 80 00 00 	movabs $0x800f2b,%rax
  800a10:	00 00 00 
  800a13:	ff d0                	call   *%rax
  800a15:	48 89 c2             	mov    %rax,%rdx
  800a18:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800a1b:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  800a1d:	8d 70 ff             	lea    -0x1(%rax),%esi
  800a20:	89 75 ac             	mov    %esi,-0x54(%rbp)
  800a23:	85 c0                	test   %eax,%eax
  800a25:	7e 91                	jle    8009b8 <vprintfmt+0x250>
  800a27:	44 0f be 65 aa       	movsbl -0x56(%rbp),%r12d
  800a2c:	4c 89 ee             	mov    %r13,%rsi
  800a2f:	44 89 e7             	mov    %r12d,%edi
  800a32:	41 ff d6             	call   *%r14
  800a35:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  800a39:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800a3c:	83 f8 ff             	cmp    $0xffffffff,%eax
  800a3f:	75 eb                	jne    800a2c <vprintfmt+0x2c4>
  800a41:	e9 72 ff ff ff       	jmp    8009b8 <vprintfmt+0x250>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800a46:	0f b6 f8             	movzbl %al,%edi
  800a49:	4c 89 ee             	mov    %r13,%rsi
  800a4c:	41 ff d6             	call   *%r14
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800a4f:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  800a53:	49 83 c4 01          	add    $0x1,%r12
  800a57:	41 0f b6 44 24 ff    	movzbl -0x1(%r12),%eax
  800a5d:	84 c0                	test   %al,%al
  800a5f:	0f 84 66 ff ff ff    	je     8009cb <vprintfmt+0x263>
  800a65:	45 85 ff             	test   %r15d,%r15d
  800a68:	78 0a                	js     800a74 <vprintfmt+0x30c>
  800a6a:	41 83 ef 01          	sub    $0x1,%r15d
  800a6e:	0f 88 57 ff ff ff    	js     8009cb <vprintfmt+0x263>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800a74:	80 7d ab 00          	cmpb   $0x0,-0x55(%rbp)
  800a78:	74 cc                	je     800a46 <vprintfmt+0x2de>
  800a7a:	8d 50 e0             	lea    -0x20(%rax),%edx
  800a7d:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800a82:	80 fa 5e             	cmp    $0x5e,%dl
  800a85:	77 c2                	ja     800a49 <vprintfmt+0x2e1>
  800a87:	eb bd                	jmp    800a46 <vprintfmt+0x2de>
    if (zflag) return va_arg(*ap, size_t);
  800a89:	40 84 f6             	test   %sil,%sil
  800a8c:	75 26                	jne    800ab4 <vprintfmt+0x34c>
    switch (lflag) {
  800a8e:	85 d2                	test   %edx,%edx
  800a90:	74 59                	je     800aeb <vprintfmt+0x383>
  800a92:	83 fa 01             	cmp    $0x1,%edx
  800a95:	74 7b                	je     800b12 <vprintfmt+0x3aa>
        return va_arg(*ap, long long);
  800a97:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a9a:	83 f8 2f             	cmp    $0x2f,%eax
  800a9d:	0f 87 96 00 00 00    	ja     800b39 <vprintfmt+0x3d1>
  800aa3:	89 c2                	mov    %eax,%edx
  800aa5:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800aa9:	83 c0 08             	add    $0x8,%eax
  800aac:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800aaf:	4c 8b 22             	mov    (%rdx),%r12
  800ab2:	eb 17                	jmp    800acb <vprintfmt+0x363>
    if (zflag) return va_arg(*ap, size_t);
  800ab4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ab7:	83 f8 2f             	cmp    $0x2f,%eax
  800aba:	77 21                	ja     800add <vprintfmt+0x375>
  800abc:	89 c2                	mov    %eax,%edx
  800abe:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800ac2:	83 c0 08             	add    $0x8,%eax
  800ac5:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ac8:	4c 8b 22             	mov    (%rdx),%r12
            if (i < 0) {
  800acb:	4d 85 e4             	test   %r12,%r12
  800ace:	78 7a                	js     800b4a <vprintfmt+0x3e2>
            num = i;
  800ad0:	4c 89 e2             	mov    %r12,%rdx
        unsigned lflag = 0, base = 10;
  800ad3:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  800ad8:	e9 50 02 00 00       	jmp    800d2d <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800add:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ae1:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800ae5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ae9:	eb dd                	jmp    800ac8 <vprintfmt+0x360>
        return va_arg(*ap, int);
  800aeb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aee:	83 f8 2f             	cmp    $0x2f,%eax
  800af1:	77 11                	ja     800b04 <vprintfmt+0x39c>
  800af3:	89 c2                	mov    %eax,%edx
  800af5:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800af9:	83 c0 08             	add    $0x8,%eax
  800afc:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800aff:	4c 63 22             	movslq (%rdx),%r12
  800b02:	eb c7                	jmp    800acb <vprintfmt+0x363>
  800b04:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b08:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b0c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b10:	eb ed                	jmp    800aff <vprintfmt+0x397>
        return va_arg(*ap, long);
  800b12:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b15:	83 f8 2f             	cmp    $0x2f,%eax
  800b18:	77 11                	ja     800b2b <vprintfmt+0x3c3>
  800b1a:	89 c2                	mov    %eax,%edx
  800b1c:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b20:	83 c0 08             	add    $0x8,%eax
  800b23:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b26:	4c 8b 22             	mov    (%rdx),%r12
  800b29:	eb a0                	jmp    800acb <vprintfmt+0x363>
  800b2b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b2f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b33:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b37:	eb ed                	jmp    800b26 <vprintfmt+0x3be>
        return va_arg(*ap, long long);
  800b39:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b3d:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b41:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b45:	e9 65 ff ff ff       	jmp    800aaf <vprintfmt+0x347>
                putch('-', put_arg);
  800b4a:	4c 89 ee             	mov    %r13,%rsi
  800b4d:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800b52:	41 ff d6             	call   *%r14
                i = -i;
  800b55:	49 f7 dc             	neg    %r12
  800b58:	e9 73 ff ff ff       	jmp    800ad0 <vprintfmt+0x368>
    if (zflag) return va_arg(*ap, size_t);
  800b5d:	40 84 f6             	test   %sil,%sil
  800b60:	75 32                	jne    800b94 <vprintfmt+0x42c>
    switch (lflag) {
  800b62:	85 d2                	test   %edx,%edx
  800b64:	74 5d                	je     800bc3 <vprintfmt+0x45b>
  800b66:	83 fa 01             	cmp    $0x1,%edx
  800b69:	0f 84 82 00 00 00    	je     800bf1 <vprintfmt+0x489>
        return va_arg(*ap, unsigned long long);
  800b6f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b72:	83 f8 2f             	cmp    $0x2f,%eax
  800b75:	0f 87 a5 00 00 00    	ja     800c20 <vprintfmt+0x4b8>
  800b7b:	89 c2                	mov    %eax,%edx
  800b7d:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b81:	83 c0 08             	add    $0x8,%eax
  800b84:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b87:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800b8a:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  800b8f:	e9 99 01 00 00       	jmp    800d2d <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800b94:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b97:	83 f8 2f             	cmp    $0x2f,%eax
  800b9a:	77 19                	ja     800bb5 <vprintfmt+0x44d>
  800b9c:	89 c2                	mov    %eax,%edx
  800b9e:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800ba2:	83 c0 08             	add    $0x8,%eax
  800ba5:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ba8:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800bab:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800bb0:	e9 78 01 00 00       	jmp    800d2d <vprintfmt+0x5c5>
  800bb5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bb9:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800bbd:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800bc1:	eb e5                	jmp    800ba8 <vprintfmt+0x440>
        return va_arg(*ap, unsigned int);
  800bc3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bc6:	83 f8 2f             	cmp    $0x2f,%eax
  800bc9:	77 18                	ja     800be3 <vprintfmt+0x47b>
  800bcb:	89 c2                	mov    %eax,%edx
  800bcd:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800bd1:	83 c0 08             	add    $0x8,%eax
  800bd4:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800bd7:	8b 12                	mov    (%rdx),%edx
        unsigned lflag = 0, base = 10;
  800bd9:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  800bde:	e9 4a 01 00 00       	jmp    800d2d <vprintfmt+0x5c5>
  800be3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800be7:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800beb:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800bef:	eb e6                	jmp    800bd7 <vprintfmt+0x46f>
        return va_arg(*ap, unsigned long);
  800bf1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bf4:	83 f8 2f             	cmp    $0x2f,%eax
  800bf7:	77 19                	ja     800c12 <vprintfmt+0x4aa>
  800bf9:	89 c2                	mov    %eax,%edx
  800bfb:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800bff:	83 c0 08             	add    $0x8,%eax
  800c02:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c05:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800c08:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  800c0d:	e9 1b 01 00 00       	jmp    800d2d <vprintfmt+0x5c5>
  800c12:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c16:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800c1a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c1e:	eb e5                	jmp    800c05 <vprintfmt+0x49d>
        return va_arg(*ap, unsigned long long);
  800c20:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c24:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800c28:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c2c:	e9 56 ff ff ff       	jmp    800b87 <vprintfmt+0x41f>
    if (zflag) return va_arg(*ap, size_t);
  800c31:	40 84 f6             	test   %sil,%sil
  800c34:	75 2e                	jne    800c64 <vprintfmt+0x4fc>
    switch (lflag) {
  800c36:	85 d2                	test   %edx,%edx
  800c38:	74 59                	je     800c93 <vprintfmt+0x52b>
  800c3a:	83 fa 01             	cmp    $0x1,%edx
  800c3d:	74 7f                	je     800cbe <vprintfmt+0x556>
        return va_arg(*ap, unsigned long long);
  800c3f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c42:	83 f8 2f             	cmp    $0x2f,%eax
  800c45:	0f 87 9f 00 00 00    	ja     800cea <vprintfmt+0x582>
  800c4b:	89 c2                	mov    %eax,%edx
  800c4d:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800c51:	83 c0 08             	add    $0x8,%eax
  800c54:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c57:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800c5a:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  800c5f:	e9 c9 00 00 00       	jmp    800d2d <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800c64:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c67:	83 f8 2f             	cmp    $0x2f,%eax
  800c6a:	77 19                	ja     800c85 <vprintfmt+0x51d>
  800c6c:	89 c2                	mov    %eax,%edx
  800c6e:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800c72:	83 c0 08             	add    $0x8,%eax
  800c75:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c78:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800c7b:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800c80:	e9 a8 00 00 00       	jmp    800d2d <vprintfmt+0x5c5>
  800c85:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c89:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800c8d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c91:	eb e5                	jmp    800c78 <vprintfmt+0x510>
        return va_arg(*ap, unsigned int);
  800c93:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c96:	83 f8 2f             	cmp    $0x2f,%eax
  800c99:	77 15                	ja     800cb0 <vprintfmt+0x548>
  800c9b:	89 c2                	mov    %eax,%edx
  800c9d:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800ca1:	83 c0 08             	add    $0x8,%eax
  800ca4:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ca7:	8b 12                	mov    (%rdx),%edx
            base = 8;
  800ca9:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  800cae:	eb 7d                	jmp    800d2d <vprintfmt+0x5c5>
  800cb0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cb4:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800cb8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800cbc:	eb e9                	jmp    800ca7 <vprintfmt+0x53f>
        return va_arg(*ap, unsigned long);
  800cbe:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cc1:	83 f8 2f             	cmp    $0x2f,%eax
  800cc4:	77 16                	ja     800cdc <vprintfmt+0x574>
  800cc6:	89 c2                	mov    %eax,%edx
  800cc8:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800ccc:	83 c0 08             	add    $0x8,%eax
  800ccf:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800cd2:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800cd5:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  800cda:	eb 51                	jmp    800d2d <vprintfmt+0x5c5>
  800cdc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ce0:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800ce4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ce8:	eb e8                	jmp    800cd2 <vprintfmt+0x56a>
        return va_arg(*ap, unsigned long long);
  800cea:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cee:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800cf2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800cf6:	e9 5c ff ff ff       	jmp    800c57 <vprintfmt+0x4ef>
            putch('0', put_arg);
  800cfb:	4c 89 ee             	mov    %r13,%rsi
  800cfe:	bf 30 00 00 00       	mov    $0x30,%edi
  800d03:	41 ff d6             	call   *%r14
            putch('x', put_arg);
  800d06:	4c 89 ee             	mov    %r13,%rsi
  800d09:	bf 78 00 00 00       	mov    $0x78,%edi
  800d0e:	41 ff d6             	call   *%r14
            num = (uintptr_t)va_arg(aq, void *);
  800d11:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d14:	83 f8 2f             	cmp    $0x2f,%eax
  800d17:	77 47                	ja     800d60 <vprintfmt+0x5f8>
  800d19:	89 c2                	mov    %eax,%edx
  800d1b:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800d1f:	83 c0 08             	add    $0x8,%eax
  800d22:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800d25:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800d28:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  800d2d:	48 83 ec 08          	sub    $0x8,%rsp
  800d31:	80 7d a0 58          	cmpb   $0x58,-0x60(%rbp)
  800d35:	0f 94 c0             	sete   %al
  800d38:	0f b6 c0             	movzbl %al,%eax
  800d3b:	50                   	push   %rax
  800d3c:	44 0f be 4d aa       	movsbl -0x56(%rbp),%r9d
  800d41:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  800d45:	4c 89 ee             	mov    %r13,%rsi
  800d48:	4c 89 f7             	mov    %r14,%rdi
  800d4b:	48 b8 51 06 80 00 00 	movabs $0x800651,%rax
  800d52:	00 00 00 
  800d55:	ff d0                	call   *%rax
            break;
  800d57:	48 83 c4 10          	add    $0x10,%rsp
  800d5b:	e9 3d fa ff ff       	jmp    80079d <vprintfmt+0x35>
            num = (uintptr_t)va_arg(aq, void *);
  800d60:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d64:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800d68:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800d6c:	eb b7                	jmp    800d25 <vprintfmt+0x5bd>
    if (zflag) return va_arg(*ap, size_t);
  800d6e:	40 84 f6             	test   %sil,%sil
  800d71:	75 2b                	jne    800d9e <vprintfmt+0x636>
    switch (lflag) {
  800d73:	85 d2                	test   %edx,%edx
  800d75:	74 56                	je     800dcd <vprintfmt+0x665>
  800d77:	83 fa 01             	cmp    $0x1,%edx
  800d7a:	74 7f                	je     800dfb <vprintfmt+0x693>
        return va_arg(*ap, unsigned long long);
  800d7c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d7f:	83 f8 2f             	cmp    $0x2f,%eax
  800d82:	0f 87 a2 00 00 00    	ja     800e2a <vprintfmt+0x6c2>
  800d88:	89 c2                	mov    %eax,%edx
  800d8a:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800d8e:	83 c0 08             	add    $0x8,%eax
  800d91:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800d94:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800d97:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800d9c:	eb 8f                	jmp    800d2d <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800d9e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800da1:	83 f8 2f             	cmp    $0x2f,%eax
  800da4:	77 19                	ja     800dbf <vprintfmt+0x657>
  800da6:	89 c2                	mov    %eax,%edx
  800da8:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800dac:	83 c0 08             	add    $0x8,%eax
  800daf:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800db2:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800db5:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800dba:	e9 6e ff ff ff       	jmp    800d2d <vprintfmt+0x5c5>
  800dbf:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800dc3:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800dc7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800dcb:	eb e5                	jmp    800db2 <vprintfmt+0x64a>
        return va_arg(*ap, unsigned int);
  800dcd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800dd0:	83 f8 2f             	cmp    $0x2f,%eax
  800dd3:	77 18                	ja     800ded <vprintfmt+0x685>
  800dd5:	89 c2                	mov    %eax,%edx
  800dd7:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800ddb:	83 c0 08             	add    $0x8,%eax
  800dde:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800de1:	8b 12                	mov    (%rdx),%edx
            base = 16;
  800de3:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  800de8:	e9 40 ff ff ff       	jmp    800d2d <vprintfmt+0x5c5>
  800ded:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800df1:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800df5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800df9:	eb e6                	jmp    800de1 <vprintfmt+0x679>
        return va_arg(*ap, unsigned long);
  800dfb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800dfe:	83 f8 2f             	cmp    $0x2f,%eax
  800e01:	77 19                	ja     800e1c <vprintfmt+0x6b4>
  800e03:	89 c2                	mov    %eax,%edx
  800e05:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800e09:	83 c0 08             	add    $0x8,%eax
  800e0c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800e0f:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800e12:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800e17:	e9 11 ff ff ff       	jmp    800d2d <vprintfmt+0x5c5>
  800e1c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e20:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800e24:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800e28:	eb e5                	jmp    800e0f <vprintfmt+0x6a7>
        return va_arg(*ap, unsigned long long);
  800e2a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e2e:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800e32:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800e36:	e9 59 ff ff ff       	jmp    800d94 <vprintfmt+0x62c>
            putch(ch, put_arg);
  800e3b:	4c 89 ee             	mov    %r13,%rsi
  800e3e:	bf 25 00 00 00       	mov    $0x25,%edi
  800e43:	41 ff d6             	call   *%r14
            break;
  800e46:	e9 52 f9 ff ff       	jmp    80079d <vprintfmt+0x35>
            putch('%', put_arg);
  800e4b:	4c 89 ee             	mov    %r13,%rsi
  800e4e:	bf 25 00 00 00       	mov    $0x25,%edi
  800e53:	41 ff d6             	call   *%r14
            while ((--ufmt)[-1] != '%') /* nothing */
  800e56:	48 83 eb 01          	sub    $0x1,%rbx
  800e5a:	80 7b ff 25          	cmpb   $0x25,-0x1(%rbx)
  800e5e:	75 f6                	jne    800e56 <vprintfmt+0x6ee>
  800e60:	e9 38 f9 ff ff       	jmp    80079d <vprintfmt+0x35>
}
  800e65:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800e69:	5b                   	pop    %rbx
  800e6a:	41 5c                	pop    %r12
  800e6c:	41 5d                	pop    %r13
  800e6e:	41 5e                	pop    %r14
  800e70:	41 5f                	pop    %r15
  800e72:	5d                   	pop    %rbp
  800e73:	c3                   	ret

0000000000800e74 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800e74:	f3 0f 1e fa          	endbr64
  800e78:	55                   	push   %rbp
  800e79:	48 89 e5             	mov    %rsp,%rbp
  800e7c:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800e80:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e84:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800e89:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800e8d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800e94:	48 85 ff             	test   %rdi,%rdi
  800e97:	74 2b                	je     800ec4 <vsnprintf+0x50>
  800e99:	48 85 f6             	test   %rsi,%rsi
  800e9c:	74 26                	je     800ec4 <vsnprintf+0x50>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800e9e:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800ea2:	48 bf 0b 07 80 00 00 	movabs $0x80070b,%rdi
  800ea9:	00 00 00 
  800eac:	48 b8 68 07 80 00 00 	movabs $0x800768,%rax
  800eb3:	00 00 00 
  800eb6:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800eb8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ebc:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800ebf:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800ec2:	c9                   	leave
  800ec3:	c3                   	ret
    if (!buf || n < 1) return -E_INVAL;
  800ec4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ec9:	eb f7                	jmp    800ec2 <vsnprintf+0x4e>

0000000000800ecb <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800ecb:	f3 0f 1e fa          	endbr64
  800ecf:	55                   	push   %rbp
  800ed0:	48 89 e5             	mov    %rsp,%rbp
  800ed3:	48 83 ec 50          	sub    $0x50,%rsp
  800ed7:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800edb:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800edf:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800ee3:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800eea:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800eee:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ef2:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800ef6:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800efa:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800efe:	48 b8 74 0e 80 00 00 	movabs $0x800e74,%rax
  800f05:	00 00 00 
  800f08:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800f0a:	c9                   	leave
  800f0b:	c3                   	ret

0000000000800f0c <strlen>:
 * Primespipe runs 3x faster this way */

#define ASM 1

size_t
strlen(const char *s) {
  800f0c:	f3 0f 1e fa          	endbr64
    size_t n = 0;
    while (*s++) n++;
  800f10:	80 3f 00             	cmpb   $0x0,(%rdi)
  800f13:	74 10                	je     800f25 <strlen+0x19>
    size_t n = 0;
  800f15:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800f1a:	48 83 c0 01          	add    $0x1,%rax
  800f1e:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800f22:	75 f6                	jne    800f1a <strlen+0xe>
  800f24:	c3                   	ret
    size_t n = 0;
  800f25:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800f2a:	c3                   	ret

0000000000800f2b <strnlen>:

size_t
strnlen(const char *s, size_t size) {
  800f2b:	f3 0f 1e fa          	endbr64
  800f2f:	48 89 f0             	mov    %rsi,%rax
    size_t n = 0;
  800f32:	ba 00 00 00 00       	mov    $0x0,%edx
    while (n < size && *s++) n++;
  800f37:	48 85 f6             	test   %rsi,%rsi
  800f3a:	74 10                	je     800f4c <strnlen+0x21>
  800f3c:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  800f40:	74 0b                	je     800f4d <strnlen+0x22>
  800f42:	48 83 c2 01          	add    $0x1,%rdx
  800f46:	48 39 d0             	cmp    %rdx,%rax
  800f49:	75 f1                	jne    800f3c <strnlen+0x11>
  800f4b:	c3                   	ret
  800f4c:	c3                   	ret
  800f4d:	48 89 d0             	mov    %rdx,%rax
    return n;
}
  800f50:	c3                   	ret

0000000000800f51 <strcpy>:

char *
strcpy(char *dst, const char *src) {
  800f51:	f3 0f 1e fa          	endbr64
  800f55:	48 89 f8             	mov    %rdi,%rax
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800f58:	ba 00 00 00 00       	mov    $0x0,%edx
  800f5d:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  800f61:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  800f64:	48 83 c2 01          	add    $0x1,%rdx
  800f68:	84 c9                	test   %cl,%cl
  800f6a:	75 f1                	jne    800f5d <strcpy+0xc>
        ;
    return res;
}
  800f6c:	c3                   	ret

0000000000800f6d <strcat>:

char *
strcat(char *dst, const char *src) {
  800f6d:	f3 0f 1e fa          	endbr64
  800f71:	55                   	push   %rbp
  800f72:	48 89 e5             	mov    %rsp,%rbp
  800f75:	41 54                	push   %r12
  800f77:	53                   	push   %rbx
  800f78:	48 89 fb             	mov    %rdi,%rbx
  800f7b:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800f7e:	48 b8 0c 0f 80 00 00 	movabs $0x800f0c,%rax
  800f85:	00 00 00 
  800f88:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800f8a:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800f8e:	4c 89 e6             	mov    %r12,%rsi
  800f91:	48 b8 51 0f 80 00 00 	movabs $0x800f51,%rax
  800f98:	00 00 00 
  800f9b:	ff d0                	call   *%rax
    return dst;
}
  800f9d:	48 89 d8             	mov    %rbx,%rax
  800fa0:	5b                   	pop    %rbx
  800fa1:	41 5c                	pop    %r12
  800fa3:	5d                   	pop    %rbp
  800fa4:	c3                   	ret

0000000000800fa5 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800fa5:	f3 0f 1e fa          	endbr64
  800fa9:	48 89 f8             	mov    %rdi,%rax
    char *ret = dst;
    while (size-- > 0) {
  800fac:	48 85 d2             	test   %rdx,%rdx
  800faf:	74 1f                	je     800fd0 <strncpy+0x2b>
  800fb1:	48 01 fa             	add    %rdi,%rdx
  800fb4:	48 89 f9             	mov    %rdi,%rcx
        *dst++ = *src;
  800fb7:	48 83 c1 01          	add    $0x1,%rcx
  800fbb:	44 0f b6 06          	movzbl (%rsi),%r8d
  800fbf:	44 88 41 ff          	mov    %r8b,-0x1(%rcx)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800fc3:	41 80 f8 01          	cmp    $0x1,%r8b
  800fc7:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800fcb:	48 39 ca             	cmp    %rcx,%rdx
  800fce:	75 e7                	jne    800fb7 <strncpy+0x12>
    }
    return ret;
}
  800fd0:	c3                   	ret

0000000000800fd1 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
  800fd1:	f3 0f 1e fa          	endbr64
    char *dst_in = dst;
    if (size) {
  800fd5:	48 89 f8             	mov    %rdi,%rax
  800fd8:	48 85 d2             	test   %rdx,%rdx
  800fdb:	74 24                	je     801001 <strlcpy+0x30>
        while (--size > 0 && *src)
  800fdd:	48 83 ea 01          	sub    $0x1,%rdx
  800fe1:	74 1b                	je     800ffe <strlcpy+0x2d>
  800fe3:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800fe7:	0f b6 16             	movzbl (%rsi),%edx
  800fea:	84 d2                	test   %dl,%dl
  800fec:	74 10                	je     800ffe <strlcpy+0x2d>
            *dst++ = *src++;
  800fee:	48 83 c6 01          	add    $0x1,%rsi
  800ff2:	48 83 c0 01          	add    $0x1,%rax
  800ff6:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800ff9:	48 39 c8             	cmp    %rcx,%rax
  800ffc:	75 e9                	jne    800fe7 <strlcpy+0x16>
        *dst = '\0';
  800ffe:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  801001:	48 29 f8             	sub    %rdi,%rax
}
  801004:	c3                   	ret

0000000000801005 <strcmp>:
    }
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
  801005:	f3 0f 1e fa          	endbr64
    while (*p && *p == *q) p++, q++;
  801009:	0f b6 07             	movzbl (%rdi),%eax
  80100c:	84 c0                	test   %al,%al
  80100e:	74 13                	je     801023 <strcmp+0x1e>
  801010:	38 06                	cmp    %al,(%rsi)
  801012:	75 0f                	jne    801023 <strcmp+0x1e>
  801014:	48 83 c7 01          	add    $0x1,%rdi
  801018:	48 83 c6 01          	add    $0x1,%rsi
  80101c:	0f b6 07             	movzbl (%rdi),%eax
  80101f:	84 c0                	test   %al,%al
  801021:	75 ed                	jne    801010 <strcmp+0xb>
    return (int)((unsigned char)*p - (unsigned char)*q);
  801023:	0f b6 c0             	movzbl %al,%eax
  801026:	0f b6 16             	movzbl (%rsi),%edx
  801029:	29 d0                	sub    %edx,%eax
}
  80102b:	c3                   	ret

000000000080102c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
  80102c:	f3 0f 1e fa          	endbr64
    while (n && *p && *p == *q) n--, p++, q++;
  801030:	48 85 d2             	test   %rdx,%rdx
  801033:	74 1f                	je     801054 <strncmp+0x28>
  801035:	0f b6 07             	movzbl (%rdi),%eax
  801038:	84 c0                	test   %al,%al
  80103a:	74 1e                	je     80105a <strncmp+0x2e>
  80103c:	3a 06                	cmp    (%rsi),%al
  80103e:	75 1a                	jne    80105a <strncmp+0x2e>
  801040:	48 83 c7 01          	add    $0x1,%rdi
  801044:	48 83 c6 01          	add    $0x1,%rsi
  801048:	48 83 ea 01          	sub    $0x1,%rdx
  80104c:	75 e7                	jne    801035 <strncmp+0x9>

    if (!n) return 0;
  80104e:	b8 00 00 00 00       	mov    $0x0,%eax
  801053:	c3                   	ret
  801054:	b8 00 00 00 00       	mov    $0x0,%eax
  801059:	c3                   	ret

    return (int)((unsigned char)*p - (unsigned char)*q);
  80105a:	0f b6 07             	movzbl (%rdi),%eax
  80105d:	0f b6 16             	movzbl (%rsi),%edx
  801060:	29 d0                	sub    %edx,%eax
}
  801062:	c3                   	ret

0000000000801063 <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
  801063:	f3 0f 1e fa          	endbr64
    for (; *str; str++) {
  801067:	0f b6 17             	movzbl (%rdi),%edx
  80106a:	84 d2                	test   %dl,%dl
  80106c:	74 18                	je     801086 <strchr+0x23>
        if (*str == c) {
  80106e:	0f be d2             	movsbl %dl,%edx
  801071:	39 f2                	cmp    %esi,%edx
  801073:	74 17                	je     80108c <strchr+0x29>
    for (; *str; str++) {
  801075:	48 83 c7 01          	add    $0x1,%rdi
  801079:	0f b6 17             	movzbl (%rdi),%edx
  80107c:	84 d2                	test   %dl,%dl
  80107e:	75 ee                	jne    80106e <strchr+0xb>
            return (char *)str;
        }
    }
    return NULL;
  801080:	b8 00 00 00 00       	mov    $0x0,%eax
  801085:	c3                   	ret
  801086:	b8 00 00 00 00       	mov    $0x0,%eax
  80108b:	c3                   	ret
            return (char *)str;
  80108c:	48 89 f8             	mov    %rdi,%rax
}
  80108f:	c3                   	ret

0000000000801090 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
  801090:	f3 0f 1e fa          	endbr64
  801094:	48 89 f8             	mov    %rdi,%rax
    for (; *str && *str != ch; str++) /* nothing */
  801097:	0f b6 17             	movzbl (%rdi),%edx
  80109a:	84 d2                	test   %dl,%dl
  80109c:	74 13                	je     8010b1 <strfind+0x21>
  80109e:	0f be d2             	movsbl %dl,%edx
  8010a1:	39 f2                	cmp    %esi,%edx
  8010a3:	74 0b                	je     8010b0 <strfind+0x20>
  8010a5:	48 83 c0 01          	add    $0x1,%rax
  8010a9:	0f b6 10             	movzbl (%rax),%edx
  8010ac:	84 d2                	test   %dl,%dl
  8010ae:	75 ee                	jne    80109e <strfind+0xe>
        ;
    return (char *)str;
}
  8010b0:	c3                   	ret
  8010b1:	c3                   	ret

00000000008010b2 <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  8010b2:	f3 0f 1e fa          	endbr64
  8010b6:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  8010b9:	48 89 f8             	mov    %rdi,%rax
  8010bc:	48 f7 d8             	neg    %rax
  8010bf:	83 e0 07             	and    $0x7,%eax
  8010c2:	49 89 d1             	mov    %rdx,%r9
  8010c5:	49 29 c1             	sub    %rax,%r9
  8010c8:	78 36                	js     801100 <memset+0x4e>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  8010ca:	40 0f b6 c6          	movzbl %sil,%eax
  8010ce:	48 b9 01 01 01 01 01 	movabs $0x101010101010101,%rcx
  8010d5:	01 01 01 
  8010d8:	48 0f af c1          	imul   %rcx,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  8010dc:	40 f6 c7 07          	test   $0x7,%dil
  8010e0:	75 38                	jne    80111a <memset+0x68>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  8010e2:	4c 89 c9             	mov    %r9,%rcx
  8010e5:	48 c1 f9 03          	sar    $0x3,%rcx
  8010e9:	74 0c                	je     8010f7 <memset+0x45>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  8010eb:	fc                   	cld
  8010ec:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  8010ef:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  8010f3:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  8010f7:	4d 85 c9             	test   %r9,%r9
  8010fa:	75 45                	jne    801141 <memset+0x8f>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  8010fc:	4c 89 c0             	mov    %r8,%rax
  8010ff:	c3                   	ret
        while (n-- > 0) *ptr++ = c;
  801100:	48 85 d2             	test   %rdx,%rdx
  801103:	74 f7                	je     8010fc <memset+0x4a>
  801105:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  801108:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  80110b:	48 83 c0 01          	add    $0x1,%rax
  80110f:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  801113:	48 39 c2             	cmp    %rax,%rdx
  801116:	75 f3                	jne    80110b <memset+0x59>
  801118:	eb e2                	jmp    8010fc <memset+0x4a>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  80111a:	40 f6 c7 01          	test   $0x1,%dil
  80111e:	74 06                	je     801126 <memset+0x74>
  801120:	88 07                	mov    %al,(%rdi)
  801122:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  801126:	40 f6 c7 02          	test   $0x2,%dil
  80112a:	74 07                	je     801133 <memset+0x81>
  80112c:	66 89 07             	mov    %ax,(%rdi)
  80112f:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  801133:	40 f6 c7 04          	test   $0x4,%dil
  801137:	74 a9                	je     8010e2 <memset+0x30>
  801139:	89 07                	mov    %eax,(%rdi)
  80113b:	48 83 c7 04          	add    $0x4,%rdi
  80113f:	eb a1                	jmp    8010e2 <memset+0x30>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  801141:	41 f6 c1 04          	test   $0x4,%r9b
  801145:	74 1b                	je     801162 <memset+0xb0>
  801147:	89 07                	mov    %eax,(%rdi)
  801149:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  80114d:	41 f6 c1 02          	test   $0x2,%r9b
  801151:	74 07                	je     80115a <memset+0xa8>
  801153:	66 89 07             	mov    %ax,(%rdi)
  801156:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  80115a:	41 f6 c1 01          	test   $0x1,%r9b
  80115e:	74 9c                	je     8010fc <memset+0x4a>
  801160:	eb 06                	jmp    801168 <memset+0xb6>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  801162:	41 f6 c1 02          	test   $0x2,%r9b
  801166:	75 eb                	jne    801153 <memset+0xa1>
        if (ni & 1) *ptr = k;
  801168:	88 07                	mov    %al,(%rdi)
  80116a:	eb 90                	jmp    8010fc <memset+0x4a>

000000000080116c <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  80116c:	f3 0f 1e fa          	endbr64
  801170:	48 89 f8             	mov    %rdi,%rax
  801173:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  801176:	48 39 fe             	cmp    %rdi,%rsi
  801179:	73 3b                	jae    8011b6 <memmove+0x4a>
  80117b:	48 8d 14 16          	lea    (%rsi,%rdx,1),%rdx
  80117f:	48 39 d7             	cmp    %rdx,%rdi
  801182:	73 32                	jae    8011b6 <memmove+0x4a>
        s += n;
        d += n;
  801184:	48 8d 3c 0f          	lea    (%rdi,%rcx,1),%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  801188:	48 89 d6             	mov    %rdx,%rsi
  80118b:	48 09 fe             	or     %rdi,%rsi
  80118e:	48 09 ce             	or     %rcx,%rsi
  801191:	40 f6 c6 07          	test   $0x7,%sil
  801195:	75 12                	jne    8011a9 <memmove+0x3d>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  801197:	48 83 ef 08          	sub    $0x8,%rdi
  80119b:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  80119f:	48 c1 e9 03          	shr    $0x3,%rcx
  8011a3:	fd                   	std
  8011a4:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  8011a7:	fc                   	cld
  8011a8:	c3                   	ret
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  8011a9:	48 83 ef 01          	sub    $0x1,%rdi
  8011ad:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  8011b1:	fd                   	std
  8011b2:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  8011b4:	eb f1                	jmp    8011a7 <memmove+0x3b>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  8011b6:	48 89 f2             	mov    %rsi,%rdx
  8011b9:	48 09 c2             	or     %rax,%rdx
  8011bc:	48 09 ca             	or     %rcx,%rdx
  8011bf:	f6 c2 07             	test   $0x7,%dl
  8011c2:	75 0c                	jne    8011d0 <memmove+0x64>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  8011c4:	48 c1 e9 03          	shr    $0x3,%rcx
  8011c8:	48 89 c7             	mov    %rax,%rdi
  8011cb:	fc                   	cld
  8011cc:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  8011cf:	c3                   	ret
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  8011d0:	48 89 c7             	mov    %rax,%rdi
  8011d3:	fc                   	cld
  8011d4:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  8011d6:	c3                   	ret

00000000008011d7 <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  8011d7:	f3 0f 1e fa          	endbr64
  8011db:	55                   	push   %rbp
  8011dc:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  8011df:	48 b8 6c 11 80 00 00 	movabs $0x80116c,%rax
  8011e6:	00 00 00 
  8011e9:	ff d0                	call   *%rax
}
  8011eb:	5d                   	pop    %rbp
  8011ec:	c3                   	ret

00000000008011ed <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  8011ed:	f3 0f 1e fa          	endbr64
  8011f1:	55                   	push   %rbp
  8011f2:	48 89 e5             	mov    %rsp,%rbp
  8011f5:	41 57                	push   %r15
  8011f7:	41 56                	push   %r14
  8011f9:	41 55                	push   %r13
  8011fb:	41 54                	push   %r12
  8011fd:	53                   	push   %rbx
  8011fe:	48 83 ec 08          	sub    $0x8,%rsp
  801202:	49 89 fe             	mov    %rdi,%r14
  801205:	49 89 f7             	mov    %rsi,%r15
  801208:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  80120b:	48 89 f7             	mov    %rsi,%rdi
  80120e:	48 b8 0c 0f 80 00 00 	movabs $0x800f0c,%rax
  801215:	00 00 00 
  801218:	ff d0                	call   *%rax
  80121a:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  80121d:	48 89 de             	mov    %rbx,%rsi
  801220:	4c 89 f7             	mov    %r14,%rdi
  801223:	48 b8 2b 0f 80 00 00 	movabs $0x800f2b,%rax
  80122a:	00 00 00 
  80122d:	ff d0                	call   *%rax
  80122f:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  801232:	48 39 c3             	cmp    %rax,%rbx
  801235:	74 36                	je     80126d <strlcat+0x80>
    if (srclen < maxlen - dstlen) {
  801237:	48 89 d8             	mov    %rbx,%rax
  80123a:	4c 29 e8             	sub    %r13,%rax
  80123d:	49 39 c4             	cmp    %rax,%r12
  801240:	73 31                	jae    801273 <strlcat+0x86>
        memcpy(dst + dstlen, src, srclen + 1);
  801242:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  801247:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  80124b:	4c 89 fe             	mov    %r15,%rsi
  80124e:	48 b8 d7 11 80 00 00 	movabs $0x8011d7,%rax
  801255:	00 00 00 
  801258:	ff d0                	call   *%rax
    return dstlen + srclen;
  80125a:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  80125e:	48 83 c4 08          	add    $0x8,%rsp
  801262:	5b                   	pop    %rbx
  801263:	41 5c                	pop    %r12
  801265:	41 5d                	pop    %r13
  801267:	41 5e                	pop    %r14
  801269:	41 5f                	pop    %r15
  80126b:	5d                   	pop    %rbp
  80126c:	c3                   	ret
    if (dstlen == maxlen) return maxlen + srclen;
  80126d:	49 8d 04 04          	lea    (%r12,%rax,1),%rax
  801271:	eb eb                	jmp    80125e <strlcat+0x71>
        memcpy(dst + dstlen, src, maxlen - 1);
  801273:	48 83 eb 01          	sub    $0x1,%rbx
  801277:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  80127b:	48 89 da             	mov    %rbx,%rdx
  80127e:	4c 89 fe             	mov    %r15,%rsi
  801281:	48 b8 d7 11 80 00 00 	movabs $0x8011d7,%rax
  801288:	00 00 00 
  80128b:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  80128d:	49 01 de             	add    %rbx,%r14
  801290:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  801295:	eb c3                	jmp    80125a <strlcat+0x6d>

0000000000801297 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  801297:	f3 0f 1e fa          	endbr64
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  80129b:	48 85 d2             	test   %rdx,%rdx
  80129e:	74 2d                	je     8012cd <memcmp+0x36>
  8012a0:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  8012a5:	0f b6 0c 07          	movzbl (%rdi,%rax,1),%ecx
  8012a9:	44 0f b6 04 06       	movzbl (%rsi,%rax,1),%r8d
  8012ae:	44 38 c1             	cmp    %r8b,%cl
  8012b1:	75 0f                	jne    8012c2 <memcmp+0x2b>
    while (n-- > 0) {
  8012b3:	48 83 c0 01          	add    $0x1,%rax
  8012b7:	48 39 c2             	cmp    %rax,%rdx
  8012ba:	75 e9                	jne    8012a5 <memcmp+0xe>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  8012bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8012c1:	c3                   	ret
            return (int)*s1 - (int)*s2;
  8012c2:	0f b6 c1             	movzbl %cl,%eax
  8012c5:	45 0f b6 c0          	movzbl %r8b,%r8d
  8012c9:	44 29 c0             	sub    %r8d,%eax
  8012cc:	c3                   	ret
    return 0;
  8012cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012d2:	c3                   	ret

00000000008012d3 <memfind>:

void *
memfind(const void *src, int c, size_t n) {
  8012d3:	f3 0f 1e fa          	endbr64
    const void *end = (const char *)src + n;
  8012d7:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  8012db:	48 39 c7             	cmp    %rax,%rdi
  8012de:	73 0f                	jae    8012ef <memfind+0x1c>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  8012e0:	40 38 37             	cmp    %sil,(%rdi)
  8012e3:	74 0e                	je     8012f3 <memfind+0x20>
    for (; src < end; src++) {
  8012e5:	48 83 c7 01          	add    $0x1,%rdi
  8012e9:	48 39 f8             	cmp    %rdi,%rax
  8012ec:	75 f2                	jne    8012e0 <memfind+0xd>
  8012ee:	c3                   	ret
  8012ef:	48 89 f8             	mov    %rdi,%rax
  8012f2:	c3                   	ret
  8012f3:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  8012f6:	c3                   	ret

00000000008012f7 <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  8012f7:	f3 0f 1e fa          	endbr64
  8012fb:	49 89 f2             	mov    %rsi,%r10
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  8012fe:	0f b6 37             	movzbl (%rdi),%esi
  801301:	40 80 fe 20          	cmp    $0x20,%sil
  801305:	74 06                	je     80130d <strtol+0x16>
  801307:	40 80 fe 09          	cmp    $0x9,%sil
  80130b:	75 13                	jne    801320 <strtol+0x29>
  80130d:	48 83 c7 01          	add    $0x1,%rdi
  801311:	0f b6 37             	movzbl (%rdi),%esi
  801314:	40 80 fe 20          	cmp    $0x20,%sil
  801318:	74 f3                	je     80130d <strtol+0x16>
  80131a:	40 80 fe 09          	cmp    $0x9,%sil
  80131e:	74 ed                	je     80130d <strtol+0x16>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  801320:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  801323:	83 e0 fd             	and    $0xfffffffd,%eax
  801326:	3c 01                	cmp    $0x1,%al
  801328:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  80132c:	f7 c2 ef ff ff ff    	test   $0xffffffef,%edx
  801332:	75 0f                	jne    801343 <strtol+0x4c>
  801334:	80 3f 30             	cmpb   $0x30,(%rdi)
  801337:	74 14                	je     80134d <strtol+0x56>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  801339:	85 d2                	test   %edx,%edx
  80133b:	b8 0a 00 00 00       	mov    $0xa,%eax
  801340:	0f 44 d0             	cmove  %eax,%edx
    }

    /* Digits */
    long val = 0;
  801343:	b8 00 00 00 00       	mov    $0x0,%eax
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  801348:	4c 63 ca             	movslq %edx,%r9
  80134b:	eb 36                	jmp    801383 <strtol+0x8c>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  80134d:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  801351:	74 0f                	je     801362 <strtol+0x6b>
    } else if (!base && s[0] == '0') {
  801353:	85 d2                	test   %edx,%edx
  801355:	75 ec                	jne    801343 <strtol+0x4c>
        s++;
  801357:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  80135b:	ba 08 00 00 00       	mov    $0x8,%edx
        s++;
  801360:	eb e1                	jmp    801343 <strtol+0x4c>
        s += 2;
  801362:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  801366:	ba 10 00 00 00       	mov    $0x10,%edx
        s += 2;
  80136b:	eb d6                	jmp    801343 <strtol+0x4c>
            dig -= '0';
  80136d:	83 e9 30             	sub    $0x30,%ecx
        if (dig >= base) break;
  801370:	44 0f b6 c1          	movzbl %cl,%r8d
  801374:	41 39 d0             	cmp    %edx,%r8d
  801377:	7d 21                	jge    80139a <strtol+0xa3>
        val = val * base + dig;
  801379:	49 0f af c1          	imul   %r9,%rax
  80137d:	0f b6 c9             	movzbl %cl,%ecx
  801380:	48 01 c8             	add    %rcx,%rax
        uint8_t dig = *s++;
  801383:	48 83 c7 01          	add    $0x1,%rdi
  801387:	0f b6 4f ff          	movzbl -0x1(%rdi),%ecx
        if (dig - '0' < 10)
  80138b:	80 f9 39             	cmp    $0x39,%cl
  80138e:	76 dd                	jbe    80136d <strtol+0x76>
        else if (dig - 'a' < 27)
  801390:	80 f9 7b             	cmp    $0x7b,%cl
  801393:	77 05                	ja     80139a <strtol+0xa3>
            dig -= 'a' - 10;
  801395:	83 e9 57             	sub    $0x57,%ecx
  801398:	eb d6                	jmp    801370 <strtol+0x79>
    }

    if (endptr) *endptr = (char *)s;
  80139a:	4d 85 d2             	test   %r10,%r10
  80139d:	74 03                	je     8013a2 <strtol+0xab>
  80139f:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  8013a2:	48 89 c2             	mov    %rax,%rdx
  8013a5:	48 f7 da             	neg    %rdx
  8013a8:	40 80 fe 2d          	cmp    $0x2d,%sil
  8013ac:	48 0f 44 c2          	cmove  %rdx,%rax
}
  8013b0:	c3                   	ret

00000000008013b1 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  8013b1:	f3 0f 1e fa          	endbr64
  8013b5:	55                   	push   %rbp
  8013b6:	48 89 e5             	mov    %rsp,%rbp
  8013b9:	53                   	push   %rbx
  8013ba:	48 89 fa             	mov    %rdi,%rdx
  8013bd:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8013c0:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8013c5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013ca:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013cf:	be 00 00 00 00       	mov    $0x0,%esi
  8013d4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013da:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  8013dc:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013e0:	c9                   	leave
  8013e1:	c3                   	ret

00000000008013e2 <sys_cgetc>:

int
sys_cgetc(void) {
  8013e2:	f3 0f 1e fa          	endbr64
  8013e6:	55                   	push   %rbp
  8013e7:	48 89 e5             	mov    %rsp,%rbp
  8013ea:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8013eb:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8013f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8013f5:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8013fa:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013ff:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801404:	be 00 00 00 00       	mov    $0x0,%esi
  801409:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80140f:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  801411:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801415:	c9                   	leave
  801416:	c3                   	ret

0000000000801417 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  801417:	f3 0f 1e fa          	endbr64
  80141b:	55                   	push   %rbp
  80141c:	48 89 e5             	mov    %rsp,%rbp
  80141f:	53                   	push   %rbx
  801420:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  801424:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801427:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80142c:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801431:	bb 00 00 00 00       	mov    $0x0,%ebx
  801436:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80143b:	be 00 00 00 00       	mov    $0x0,%esi
  801440:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801446:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801448:	48 85 c0             	test   %rax,%rax
  80144b:	7f 06                	jg     801453 <sys_env_destroy+0x3c>
}
  80144d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801451:	c9                   	leave
  801452:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801453:	49 89 c0             	mov    %rax,%r8
  801456:	b9 03 00 00 00       	mov    $0x3,%ecx
  80145b:	48 ba a0 43 80 00 00 	movabs $0x8043a0,%rdx
  801462:	00 00 00 
  801465:	be 26 00 00 00       	mov    $0x26,%esi
  80146a:	48 bf 21 42 80 00 00 	movabs $0x804221,%rdi
  801471:	00 00 00 
  801474:	b8 00 00 00 00       	mov    $0x0,%eax
  801479:	49 b9 ac 04 80 00 00 	movabs $0x8004ac,%r9
  801480:	00 00 00 
  801483:	41 ff d1             	call   *%r9

0000000000801486 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  801486:	f3 0f 1e fa          	endbr64
  80148a:	55                   	push   %rbp
  80148b:	48 89 e5             	mov    %rsp,%rbp
  80148e:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80148f:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801494:	ba 00 00 00 00       	mov    $0x0,%edx
  801499:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80149e:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014a3:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8014a8:	be 00 00 00 00       	mov    $0x0,%esi
  8014ad:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8014b3:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  8014b5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014b9:	c9                   	leave
  8014ba:	c3                   	ret

00000000008014bb <sys_yield>:

void
sys_yield(void) {
  8014bb:	f3 0f 1e fa          	endbr64
  8014bf:	55                   	push   %rbp
  8014c0:	48 89 e5             	mov    %rsp,%rbp
  8014c3:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8014c4:	b8 0d 00 00 00       	mov    $0xd,%eax
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
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  8014ea:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014ee:	c9                   	leave
  8014ef:	c3                   	ret

00000000008014f0 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  8014f0:	f3 0f 1e fa          	endbr64
  8014f4:	55                   	push   %rbp
  8014f5:	48 89 e5             	mov    %rsp,%rbp
  8014f8:	53                   	push   %rbx
  8014f9:	48 89 fa             	mov    %rdi,%rdx
  8014fc:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8014ff:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801504:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  80150b:	00 00 00 
  80150e:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801513:	be 00 00 00 00       	mov    $0x0,%esi
  801518:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80151e:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  801520:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801524:	c9                   	leave
  801525:	c3                   	ret

0000000000801526 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  801526:	f3 0f 1e fa          	endbr64
  80152a:	55                   	push   %rbp
  80152b:	48 89 e5             	mov    %rsp,%rbp
  80152e:	53                   	push   %rbx
  80152f:	49 89 f8             	mov    %rdi,%r8
  801532:	48 89 d3             	mov    %rdx,%rbx
  801535:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  801538:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80153d:	4c 89 c2             	mov    %r8,%rdx
  801540:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801543:	be 00 00 00 00       	mov    $0x0,%esi
  801548:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80154e:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  801550:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801554:	c9                   	leave
  801555:	c3                   	ret

0000000000801556 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  801556:	f3 0f 1e fa          	endbr64
  80155a:	55                   	push   %rbp
  80155b:	48 89 e5             	mov    %rsp,%rbp
  80155e:	53                   	push   %rbx
  80155f:	48 83 ec 08          	sub    $0x8,%rsp
  801563:	89 f8                	mov    %edi,%eax
  801565:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  801568:	48 63 f9             	movslq %ecx,%rdi
  80156b:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80156e:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801573:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801576:	be 00 00 00 00       	mov    $0x0,%esi
  80157b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801581:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801583:	48 85 c0             	test   %rax,%rax
  801586:	7f 06                	jg     80158e <sys_alloc_region+0x38>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  801588:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80158c:	c9                   	leave
  80158d:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80158e:	49 89 c0             	mov    %rax,%r8
  801591:	b9 04 00 00 00       	mov    $0x4,%ecx
  801596:	48 ba a0 43 80 00 00 	movabs $0x8043a0,%rdx
  80159d:	00 00 00 
  8015a0:	be 26 00 00 00       	mov    $0x26,%esi
  8015a5:	48 bf 21 42 80 00 00 	movabs $0x804221,%rdi
  8015ac:	00 00 00 
  8015af:	b8 00 00 00 00       	mov    $0x0,%eax
  8015b4:	49 b9 ac 04 80 00 00 	movabs $0x8004ac,%r9
  8015bb:	00 00 00 
  8015be:	41 ff d1             	call   *%r9

00000000008015c1 <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  8015c1:	f3 0f 1e fa          	endbr64
  8015c5:	55                   	push   %rbp
  8015c6:	48 89 e5             	mov    %rsp,%rbp
  8015c9:	53                   	push   %rbx
  8015ca:	48 83 ec 08          	sub    $0x8,%rsp
  8015ce:	89 f8                	mov    %edi,%eax
  8015d0:	49 89 f2             	mov    %rsi,%r10
  8015d3:	48 89 cf             	mov    %rcx,%rdi
  8015d6:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  8015d9:	48 63 da             	movslq %edx,%rbx
  8015dc:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8015df:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8015e4:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8015e7:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  8015ea:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8015ec:	48 85 c0             	test   %rax,%rax
  8015ef:	7f 06                	jg     8015f7 <sys_map_region+0x36>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  8015f1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8015f5:	c9                   	leave
  8015f6:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8015f7:	49 89 c0             	mov    %rax,%r8
  8015fa:	b9 05 00 00 00       	mov    $0x5,%ecx
  8015ff:	48 ba a0 43 80 00 00 	movabs $0x8043a0,%rdx
  801606:	00 00 00 
  801609:	be 26 00 00 00       	mov    $0x26,%esi
  80160e:	48 bf 21 42 80 00 00 	movabs $0x804221,%rdi
  801615:	00 00 00 
  801618:	b8 00 00 00 00       	mov    $0x0,%eax
  80161d:	49 b9 ac 04 80 00 00 	movabs $0x8004ac,%r9
  801624:	00 00 00 
  801627:	41 ff d1             	call   *%r9

000000000080162a <sys_map_physical_region>:

int
sys_map_physical_region(uintptr_t pa, envid_t dstenv, void *dstva, size_t size, int perm) {
  80162a:	f3 0f 1e fa          	endbr64
  80162e:	55                   	push   %rbp
  80162f:	48 89 e5             	mov    %rsp,%rbp
  801632:	53                   	push   %rbx
  801633:	48 83 ec 08          	sub    $0x8,%rsp
  801637:	49 89 f9             	mov    %rdi,%r9
  80163a:	89 f0                	mov    %esi,%eax
  80163c:	48 89 d3             	mov    %rdx,%rbx
  80163f:	48 89 cf             	mov    %rcx,%rdi
    int res = syscall(SYS_map_physical_region, 1, pa, dstenv, (uintptr_t)dstva, size, perm, 0);
  801642:	49 63 f0             	movslq %r8d,%rsi
  801645:	48 63 c8             	movslq %eax,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801648:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80164d:	4c 89 ca             	mov    %r9,%rdx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801650:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801656:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801658:	48 85 c0             	test   %rax,%rax
  80165b:	7f 06                	jg     801663 <sys_map_physical_region+0x39>
#ifdef SANITIZE_USER_SHADOW_BASE
    platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  80165d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801661:	c9                   	leave
  801662:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801663:	49 89 c0             	mov    %rax,%r8
  801666:	b9 06 00 00 00       	mov    $0x6,%ecx
  80166b:	48 ba a0 43 80 00 00 	movabs $0x8043a0,%rdx
  801672:	00 00 00 
  801675:	be 26 00 00 00       	mov    $0x26,%esi
  80167a:	48 bf 21 42 80 00 00 	movabs $0x804221,%rdi
  801681:	00 00 00 
  801684:	b8 00 00 00 00       	mov    $0x0,%eax
  801689:	49 b9 ac 04 80 00 00 	movabs $0x8004ac,%r9
  801690:	00 00 00 
  801693:	41 ff d1             	call   *%r9

0000000000801696 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  801696:	f3 0f 1e fa          	endbr64
  80169a:	55                   	push   %rbp
  80169b:	48 89 e5             	mov    %rsp,%rbp
  80169e:	53                   	push   %rbx
  80169f:	48 83 ec 08          	sub    $0x8,%rsp
  8016a3:	48 89 f1             	mov    %rsi,%rcx
  8016a6:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  8016a9:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8016ac:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8016b1:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8016b6:	be 00 00 00 00       	mov    $0x0,%esi
  8016bb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8016c1:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8016c3:	48 85 c0             	test   %rax,%rax
  8016c6:	7f 06                	jg     8016ce <sys_unmap_region+0x38>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  8016c8:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8016cc:	c9                   	leave
  8016cd:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8016ce:	49 89 c0             	mov    %rax,%r8
  8016d1:	b9 07 00 00 00       	mov    $0x7,%ecx
  8016d6:	48 ba a0 43 80 00 00 	movabs $0x8043a0,%rdx
  8016dd:	00 00 00 
  8016e0:	be 26 00 00 00       	mov    $0x26,%esi
  8016e5:	48 bf 21 42 80 00 00 	movabs $0x804221,%rdi
  8016ec:	00 00 00 
  8016ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f4:	49 b9 ac 04 80 00 00 	movabs $0x8004ac,%r9
  8016fb:	00 00 00 
  8016fe:	41 ff d1             	call   *%r9

0000000000801701 <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  801701:	f3 0f 1e fa          	endbr64
  801705:	55                   	push   %rbp
  801706:	48 89 e5             	mov    %rsp,%rbp
  801709:	53                   	push   %rbx
  80170a:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  80170e:	48 63 ce             	movslq %esi,%rcx
  801711:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801714:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801719:	bb 00 00 00 00       	mov    $0x0,%ebx
  80171e:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801723:	be 00 00 00 00       	mov    $0x0,%esi
  801728:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80172e:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801730:	48 85 c0             	test   %rax,%rax
  801733:	7f 06                	jg     80173b <sys_env_set_status+0x3a>
}
  801735:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801739:	c9                   	leave
  80173a:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80173b:	49 89 c0             	mov    %rax,%r8
  80173e:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801743:	48 ba a0 43 80 00 00 	movabs $0x8043a0,%rdx
  80174a:	00 00 00 
  80174d:	be 26 00 00 00       	mov    $0x26,%esi
  801752:	48 bf 21 42 80 00 00 	movabs $0x804221,%rdi
  801759:	00 00 00 
  80175c:	b8 00 00 00 00       	mov    $0x0,%eax
  801761:	49 b9 ac 04 80 00 00 	movabs $0x8004ac,%r9
  801768:	00 00 00 
  80176b:	41 ff d1             	call   *%r9

000000000080176e <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  80176e:	f3 0f 1e fa          	endbr64
  801772:	55                   	push   %rbp
  801773:	48 89 e5             	mov    %rsp,%rbp
  801776:	53                   	push   %rbx
  801777:	48 83 ec 08          	sub    $0x8,%rsp
  80177b:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  80177e:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801781:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801786:	bb 00 00 00 00       	mov    $0x0,%ebx
  80178b:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801790:	be 00 00 00 00       	mov    $0x0,%esi
  801795:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80179b:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80179d:	48 85 c0             	test   %rax,%rax
  8017a0:	7f 06                	jg     8017a8 <sys_env_set_trapframe+0x3a>
}
  8017a2:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8017a6:	c9                   	leave
  8017a7:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8017a8:	49 89 c0             	mov    %rax,%r8
  8017ab:	b9 0b 00 00 00       	mov    $0xb,%ecx
  8017b0:	48 ba a0 43 80 00 00 	movabs $0x8043a0,%rdx
  8017b7:	00 00 00 
  8017ba:	be 26 00 00 00       	mov    $0x26,%esi
  8017bf:	48 bf 21 42 80 00 00 	movabs $0x804221,%rdi
  8017c6:	00 00 00 
  8017c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ce:	49 b9 ac 04 80 00 00 	movabs $0x8004ac,%r9
  8017d5:	00 00 00 
  8017d8:	41 ff d1             	call   *%r9

00000000008017db <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  8017db:	f3 0f 1e fa          	endbr64
  8017df:	55                   	push   %rbp
  8017e0:	48 89 e5             	mov    %rsp,%rbp
  8017e3:	53                   	push   %rbx
  8017e4:	48 83 ec 08          	sub    $0x8,%rsp
  8017e8:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  8017eb:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8017ee:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8017f3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017f8:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8017fd:	be 00 00 00 00       	mov    $0x0,%esi
  801802:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801808:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80180a:	48 85 c0             	test   %rax,%rax
  80180d:	7f 06                	jg     801815 <sys_env_set_pgfault_upcall+0x3a>
}
  80180f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801813:	c9                   	leave
  801814:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801815:	49 89 c0             	mov    %rax,%r8
  801818:	b9 0c 00 00 00       	mov    $0xc,%ecx
  80181d:	48 ba a0 43 80 00 00 	movabs $0x8043a0,%rdx
  801824:	00 00 00 
  801827:	be 26 00 00 00       	mov    $0x26,%esi
  80182c:	48 bf 21 42 80 00 00 	movabs $0x804221,%rdi
  801833:	00 00 00 
  801836:	b8 00 00 00 00       	mov    $0x0,%eax
  80183b:	49 b9 ac 04 80 00 00 	movabs $0x8004ac,%r9
  801842:	00 00 00 
  801845:	41 ff d1             	call   *%r9

0000000000801848 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  801848:	f3 0f 1e fa          	endbr64
  80184c:	55                   	push   %rbp
  80184d:	48 89 e5             	mov    %rsp,%rbp
  801850:	53                   	push   %rbx
  801851:	89 f8                	mov    %edi,%eax
  801853:	49 89 f1             	mov    %rsi,%r9
  801856:	48 89 d3             	mov    %rdx,%rbx
  801859:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  80185c:	49 63 f0             	movslq %r8d,%rsi
  80185f:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801862:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801867:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80186a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801870:	cd 30                	int    $0x30
}
  801872:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801876:	c9                   	leave
  801877:	c3                   	ret

0000000000801878 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  801878:	f3 0f 1e fa          	endbr64
  80187c:	55                   	push   %rbp
  80187d:	48 89 e5             	mov    %rsp,%rbp
  801880:	53                   	push   %rbx
  801881:	48 83 ec 08          	sub    $0x8,%rsp
  801885:	48 89 fa             	mov    %rdi,%rdx
  801888:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80188b:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801890:	bb 00 00 00 00       	mov    $0x0,%ebx
  801895:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80189a:	be 00 00 00 00       	mov    $0x0,%esi
  80189f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8018a5:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8018a7:	48 85 c0             	test   %rax,%rax
  8018aa:	7f 06                	jg     8018b2 <sys_ipc_recv+0x3a>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  8018ac:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8018b0:	c9                   	leave
  8018b1:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8018b2:	49 89 c0             	mov    %rax,%r8
  8018b5:	b9 0f 00 00 00       	mov    $0xf,%ecx
  8018ba:	48 ba a0 43 80 00 00 	movabs $0x8043a0,%rdx
  8018c1:	00 00 00 
  8018c4:	be 26 00 00 00       	mov    $0x26,%esi
  8018c9:	48 bf 21 42 80 00 00 	movabs $0x804221,%rdi
  8018d0:	00 00 00 
  8018d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8018d8:	49 b9 ac 04 80 00 00 	movabs $0x8004ac,%r9
  8018df:	00 00 00 
  8018e2:	41 ff d1             	call   *%r9

00000000008018e5 <sys_gettime>:

int
sys_gettime(void) {
  8018e5:	f3 0f 1e fa          	endbr64
  8018e9:	55                   	push   %rbp
  8018ea:	48 89 e5             	mov    %rsp,%rbp
  8018ed:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8018ee:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8018f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8018f8:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8018fd:	bb 00 00 00 00       	mov    $0x0,%ebx
  801902:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801907:	be 00 00 00 00       	mov    $0x0,%esi
  80190c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801912:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  801914:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801918:	c9                   	leave
  801919:	c3                   	ret

000000000080191a <fd2num>:


/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
  80191a:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80191e:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801925:	ff ff ff 
  801928:	48 01 f8             	add    %rdi,%rax
  80192b:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80192f:	c3                   	ret

0000000000801930 <fd2data>:

char *
fd2data(struct Fd *fd) {
  801930:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801934:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80193b:	ff ff ff 
  80193e:	48 01 f8             	add    %rdi,%rax
  801941:	48 c1 e8 0c          	shr    $0xc,%rax
    return INDEX2DATA(fd2num(fd));
  801945:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80194b:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80194f:	c3                   	ret

0000000000801950 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  801950:	f3 0f 1e fa          	endbr64
  801954:	55                   	push   %rbp
  801955:	48 89 e5             	mov    %rsp,%rbp
  801958:	41 57                	push   %r15
  80195a:	41 56                	push   %r14
  80195c:	41 55                	push   %r13
  80195e:	41 54                	push   %r12
  801960:	53                   	push   %rbx
  801961:	48 83 ec 08          	sub    $0x8,%rsp
  801965:	49 89 ff             	mov    %rdi,%r15
  801968:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  80196d:	49 bd fe 33 80 00 00 	movabs $0x8033fe,%r13
  801974:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  801977:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        struct Fd *fd = INDEX2FD(i);
  80197d:	49 89 dc             	mov    %rbx,%r12
        if (!(get_prot(fd) & PROT_R)) {
  801980:	48 89 df             	mov    %rbx,%rdi
  801983:	41 ff d5             	call   *%r13
  801986:	83 e0 04             	and    $0x4,%eax
  801989:	74 17                	je     8019a2 <fd_alloc+0x52>
    for (int i = 0; i < MAXFD; i++) {
  80198b:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  801992:	4c 39 f3             	cmp    %r14,%rbx
  801995:	75 e6                	jne    80197d <fd_alloc+0x2d>
  801997:	41 bc 00 00 00 00    	mov    $0x0,%r12d
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
    return -E_MAX_OPEN;
  80199d:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
            *fd_store = fd;
  8019a2:	4d 89 27             	mov    %r12,(%r15)
}
  8019a5:	48 83 c4 08          	add    $0x8,%rsp
  8019a9:	5b                   	pop    %rbx
  8019aa:	41 5c                	pop    %r12
  8019ac:	41 5d                	pop    %r13
  8019ae:	41 5e                	pop    %r14
  8019b0:	41 5f                	pop    %r15
  8019b2:	5d                   	pop    %rbp
  8019b3:	c3                   	ret

00000000008019b4 <fd_lookup>:
 *
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
  8019b4:	f3 0f 1e fa          	endbr64
    if (fdnum < 0 || fdnum >= MAXFD) {
  8019b8:	83 ff 1f             	cmp    $0x1f,%edi
  8019bb:	77 39                	ja     8019f6 <fd_lookup+0x42>
fd_lookup(int fdnum, struct Fd **fd_store) {
  8019bd:	55                   	push   %rbp
  8019be:	48 89 e5             	mov    %rsp,%rbp
  8019c1:	41 54                	push   %r12
  8019c3:	53                   	push   %rbx
  8019c4:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  8019c7:	48 63 df             	movslq %edi,%rbx
  8019ca:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  8019d1:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  8019d5:	48 89 df             	mov    %rbx,%rdi
  8019d8:	48 b8 fe 33 80 00 00 	movabs $0x8033fe,%rax
  8019df:	00 00 00 
  8019e2:	ff d0                	call   *%rax
  8019e4:	a8 04                	test   $0x4,%al
  8019e6:	74 14                	je     8019fc <fd_lookup+0x48>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  8019e8:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  8019ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019f1:	5b                   	pop    %rbx
  8019f2:	41 5c                	pop    %r12
  8019f4:	5d                   	pop    %rbp
  8019f5:	c3                   	ret
        return -E_INVAL;
  8019f6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8019fb:	c3                   	ret
        return -E_INVAL;
  8019fc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a01:	eb ee                	jmp    8019f1 <fd_lookup+0x3d>

0000000000801a03 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  801a03:	f3 0f 1e fa          	endbr64
  801a07:	55                   	push   %rbp
  801a08:	48 89 e5             	mov    %rsp,%rbp
  801a0b:	41 54                	push   %r12
  801a0d:	53                   	push   %rbx
  801a0e:	49 89 f4             	mov    %rsi,%r12
    for (size_t i = 0; devtab[i]; i++) {
  801a11:	48 b8 00 48 80 00 00 	movabs $0x804800,%rax
  801a18:	00 00 00 
  801a1b:	48 bb 40 50 80 00 00 	movabs $0x805040,%rbx
  801a22:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  801a25:	39 3b                	cmp    %edi,(%rbx)
  801a27:	74 47                	je     801a70 <dev_lookup+0x6d>
    for (size_t i = 0; devtab[i]; i++) {
  801a29:	48 83 c0 08          	add    $0x8,%rax
  801a2d:	48 8b 18             	mov    (%rax),%rbx
  801a30:	48 85 db             	test   %rbx,%rbx
  801a33:	75 f0                	jne    801a25 <dev_lookup+0x22>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801a35:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801a3c:	00 00 00 
  801a3f:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801a45:	89 fa                	mov    %edi,%edx
  801a47:	48 bf c0 43 80 00 00 	movabs $0x8043c0,%rdi
  801a4e:	00 00 00 
  801a51:	b8 00 00 00 00       	mov    $0x0,%eax
  801a56:	48 b9 08 06 80 00 00 	movabs $0x800608,%rcx
  801a5d:	00 00 00 
  801a60:	ff d1                	call   *%rcx
    *dev = 0;
    return -E_INVAL;
  801a62:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
            *dev = devtab[i];
  801a67:	49 89 1c 24          	mov    %rbx,(%r12)
}
  801a6b:	5b                   	pop    %rbx
  801a6c:	41 5c                	pop    %r12
  801a6e:	5d                   	pop    %rbp
  801a6f:	c3                   	ret
            return 0;
  801a70:	b8 00 00 00 00       	mov    $0x0,%eax
  801a75:	eb f0                	jmp    801a67 <dev_lookup+0x64>

0000000000801a77 <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  801a77:	f3 0f 1e fa          	endbr64
  801a7b:	55                   	push   %rbp
  801a7c:	48 89 e5             	mov    %rsp,%rbp
  801a7f:	41 55                	push   %r13
  801a81:	41 54                	push   %r12
  801a83:	53                   	push   %rbx
  801a84:	48 83 ec 18          	sub    $0x18,%rsp
  801a88:	48 89 fb             	mov    %rdi,%rbx
  801a8b:	41 89 f4             	mov    %esi,%r12d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801a8e:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  801a95:	ff ff ff 
  801a98:	48 01 df             	add    %rbx,%rdi
  801a9b:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  801a9f:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801aa3:	48 b8 b4 19 80 00 00 	movabs $0x8019b4,%rax
  801aaa:	00 00 00 
  801aad:	ff d0                	call   *%rax
  801aaf:	41 89 c5             	mov    %eax,%r13d
  801ab2:	85 c0                	test   %eax,%eax
  801ab4:	78 06                	js     801abc <fd_close+0x45>
  801ab6:	48 39 5d d8          	cmp    %rbx,-0x28(%rbp)
  801aba:	74 1a                	je     801ad6 <fd_close+0x5f>
        return (must_exist ? res : 0);
  801abc:	45 84 e4             	test   %r12b,%r12b
  801abf:	b8 00 00 00 00       	mov    $0x0,%eax
  801ac4:	44 0f 44 e8          	cmove  %eax,%r13d
}
  801ac8:	44 89 e8             	mov    %r13d,%eax
  801acb:	48 83 c4 18          	add    $0x18,%rsp
  801acf:	5b                   	pop    %rbx
  801ad0:	41 5c                	pop    %r12
  801ad2:	41 5d                	pop    %r13
  801ad4:	5d                   	pop    %rbp
  801ad5:	c3                   	ret
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801ad6:	8b 3b                	mov    (%rbx),%edi
  801ad8:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801adc:	48 b8 03 1a 80 00 00 	movabs $0x801a03,%rax
  801ae3:	00 00 00 
  801ae6:	ff d0                	call   *%rax
  801ae8:	41 89 c5             	mov    %eax,%r13d
  801aeb:	85 c0                	test   %eax,%eax
  801aed:	78 1b                	js     801b0a <fd_close+0x93>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  801aef:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801af3:	48 8b 40 20          	mov    0x20(%rax),%rax
  801af7:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  801afd:	48 85 c0             	test   %rax,%rax
  801b00:	74 08                	je     801b0a <fd_close+0x93>
  801b02:	48 89 df             	mov    %rbx,%rdi
  801b05:	ff d0                	call   *%rax
  801b07:	41 89 c5             	mov    %eax,%r13d
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801b0a:	ba 00 10 00 00       	mov    $0x1000,%edx
  801b0f:	48 89 de             	mov    %rbx,%rsi
  801b12:	bf 00 00 00 00       	mov    $0x0,%edi
  801b17:	48 b8 96 16 80 00 00 	movabs $0x801696,%rax
  801b1e:	00 00 00 
  801b21:	ff d0                	call   *%rax
    return res;
  801b23:	eb a3                	jmp    801ac8 <fd_close+0x51>

0000000000801b25 <close>:

int
close(int fdnum) {
  801b25:	f3 0f 1e fa          	endbr64
  801b29:	55                   	push   %rbp
  801b2a:	48 89 e5             	mov    %rsp,%rbp
  801b2d:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  801b31:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801b35:	48 b8 b4 19 80 00 00 	movabs $0x8019b4,%rax
  801b3c:	00 00 00 
  801b3f:	ff d0                	call   *%rax
    if (res < 0) return res;
  801b41:	85 c0                	test   %eax,%eax
  801b43:	78 15                	js     801b5a <close+0x35>

    return fd_close(fd, 1);
  801b45:	be 01 00 00 00       	mov    $0x1,%esi
  801b4a:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801b4e:	48 b8 77 1a 80 00 00 	movabs $0x801a77,%rax
  801b55:	00 00 00 
  801b58:	ff d0                	call   *%rax
}
  801b5a:	c9                   	leave
  801b5b:	c3                   	ret

0000000000801b5c <close_all>:

void
close_all(void) {
  801b5c:	f3 0f 1e fa          	endbr64
  801b60:	55                   	push   %rbp
  801b61:	48 89 e5             	mov    %rsp,%rbp
  801b64:	41 54                	push   %r12
  801b66:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  801b67:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b6c:	49 bc 25 1b 80 00 00 	movabs $0x801b25,%r12
  801b73:	00 00 00 
  801b76:	89 df                	mov    %ebx,%edi
  801b78:	41 ff d4             	call   *%r12
  801b7b:	83 c3 01             	add    $0x1,%ebx
  801b7e:	83 fb 20             	cmp    $0x20,%ebx
  801b81:	75 f3                	jne    801b76 <close_all+0x1a>
}
  801b83:	5b                   	pop    %rbx
  801b84:	41 5c                	pop    %r12
  801b86:	5d                   	pop    %rbp
  801b87:	c3                   	ret

0000000000801b88 <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  801b88:	f3 0f 1e fa          	endbr64
  801b8c:	55                   	push   %rbp
  801b8d:	48 89 e5             	mov    %rsp,%rbp
  801b90:	41 57                	push   %r15
  801b92:	41 56                	push   %r14
  801b94:	41 55                	push   %r13
  801b96:	41 54                	push   %r12
  801b98:	53                   	push   %rbx
  801b99:	48 83 ec 18          	sub    $0x18,%rsp
  801b9d:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  801ba0:	48 8d 75 c8          	lea    -0x38(%rbp),%rsi
  801ba4:	48 b8 b4 19 80 00 00 	movabs $0x8019b4,%rax
  801bab:	00 00 00 
  801bae:	ff d0                	call   *%rax
  801bb0:	89 c3                	mov    %eax,%ebx
  801bb2:	85 c0                	test   %eax,%eax
  801bb4:	0f 88 b8 00 00 00    	js     801c72 <dup+0xea>
    close(newfdnum);
  801bba:	44 89 e7             	mov    %r12d,%edi
  801bbd:	48 b8 25 1b 80 00 00 	movabs $0x801b25,%rax
  801bc4:	00 00 00 
  801bc7:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  801bc9:	4d 63 ec             	movslq %r12d,%r13
  801bcc:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  801bd3:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  801bd7:	4c 8b 7d c8          	mov    -0x38(%rbp),%r15
  801bdb:	4c 89 ff             	mov    %r15,%rdi
  801bde:	49 be 30 19 80 00 00 	movabs $0x801930,%r14
  801be5:	00 00 00 
  801be8:	41 ff d6             	call   *%r14
  801beb:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  801bee:	4c 89 ef             	mov    %r13,%rdi
  801bf1:	41 ff d6             	call   *%r14
  801bf4:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  801bf7:	48 89 df             	mov    %rbx,%rdi
  801bfa:	48 b8 fe 33 80 00 00 	movabs $0x8033fe,%rax
  801c01:	00 00 00 
  801c04:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  801c06:	a8 04                	test   $0x4,%al
  801c08:	74 2b                	je     801c35 <dup+0xad>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  801c0a:	41 89 c1             	mov    %eax,%r9d
  801c0d:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801c13:	4c 89 f1             	mov    %r14,%rcx
  801c16:	ba 00 00 00 00       	mov    $0x0,%edx
  801c1b:	48 89 de             	mov    %rbx,%rsi
  801c1e:	bf 00 00 00 00       	mov    $0x0,%edi
  801c23:	48 b8 c1 15 80 00 00 	movabs $0x8015c1,%rax
  801c2a:	00 00 00 
  801c2d:	ff d0                	call   *%rax
  801c2f:	89 c3                	mov    %eax,%ebx
  801c31:	85 c0                	test   %eax,%eax
  801c33:	78 4e                	js     801c83 <dup+0xfb>
    }
    prot = get_prot(oldfd);
  801c35:	4c 89 ff             	mov    %r15,%rdi
  801c38:	48 b8 fe 33 80 00 00 	movabs $0x8033fe,%rax
  801c3f:	00 00 00 
  801c42:	ff d0                	call   *%rax
  801c44:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  801c47:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801c4d:	4c 89 e9             	mov    %r13,%rcx
  801c50:	ba 00 00 00 00       	mov    $0x0,%edx
  801c55:	4c 89 fe             	mov    %r15,%rsi
  801c58:	bf 00 00 00 00       	mov    $0x0,%edi
  801c5d:	48 b8 c1 15 80 00 00 	movabs $0x8015c1,%rax
  801c64:	00 00 00 
  801c67:	ff d0                	call   *%rax
  801c69:	89 c3                	mov    %eax,%ebx
  801c6b:	85 c0                	test   %eax,%eax
  801c6d:	78 14                	js     801c83 <dup+0xfb>

    return newfdnum;
  801c6f:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  801c72:	89 d8                	mov    %ebx,%eax
  801c74:	48 83 c4 18          	add    $0x18,%rsp
  801c78:	5b                   	pop    %rbx
  801c79:	41 5c                	pop    %r12
  801c7b:	41 5d                	pop    %r13
  801c7d:	41 5e                	pop    %r14
  801c7f:	41 5f                	pop    %r15
  801c81:	5d                   	pop    %rbp
  801c82:	c3                   	ret
    sys_unmap_region(0, newfd, PAGE_SIZE);
  801c83:	ba 00 10 00 00       	mov    $0x1000,%edx
  801c88:	4c 89 ee             	mov    %r13,%rsi
  801c8b:	bf 00 00 00 00       	mov    $0x0,%edi
  801c90:	49 bc 96 16 80 00 00 	movabs $0x801696,%r12
  801c97:	00 00 00 
  801c9a:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  801c9d:	ba 00 10 00 00       	mov    $0x1000,%edx
  801ca2:	4c 89 f6             	mov    %r14,%rsi
  801ca5:	bf 00 00 00 00       	mov    $0x0,%edi
  801caa:	41 ff d4             	call   *%r12
    return res;
  801cad:	eb c3                	jmp    801c72 <dup+0xea>

0000000000801caf <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  801caf:	f3 0f 1e fa          	endbr64
  801cb3:	55                   	push   %rbp
  801cb4:	48 89 e5             	mov    %rsp,%rbp
  801cb7:	41 56                	push   %r14
  801cb9:	41 55                	push   %r13
  801cbb:	41 54                	push   %r12
  801cbd:	53                   	push   %rbx
  801cbe:	48 83 ec 10          	sub    $0x10,%rsp
  801cc2:	89 fb                	mov    %edi,%ebx
  801cc4:	49 89 f4             	mov    %rsi,%r12
  801cc7:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801cca:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801cce:	48 b8 b4 19 80 00 00 	movabs $0x8019b4,%rax
  801cd5:	00 00 00 
  801cd8:	ff d0                	call   *%rax
  801cda:	85 c0                	test   %eax,%eax
  801cdc:	78 4c                	js     801d2a <read+0x7b>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801cde:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801ce2:	41 8b 3e             	mov    (%r14),%edi
  801ce5:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801ce9:	48 b8 03 1a 80 00 00 	movabs $0x801a03,%rax
  801cf0:	00 00 00 
  801cf3:	ff d0                	call   *%rax
  801cf5:	85 c0                	test   %eax,%eax
  801cf7:	78 35                	js     801d2e <read+0x7f>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801cf9:	41 8b 46 08          	mov    0x8(%r14),%eax
  801cfd:	83 e0 03             	and    $0x3,%eax
  801d00:	83 f8 01             	cmp    $0x1,%eax
  801d03:	74 2d                	je     801d32 <read+0x83>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  801d05:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d09:	48 8b 40 10          	mov    0x10(%rax),%rax
  801d0d:	48 85 c0             	test   %rax,%rax
  801d10:	74 56                	je     801d68 <read+0xb9>

    return (*dev->dev_read)(fd, buf, n);
  801d12:	4c 89 ea             	mov    %r13,%rdx
  801d15:	4c 89 e6             	mov    %r12,%rsi
  801d18:	4c 89 f7             	mov    %r14,%rdi
  801d1b:	ff d0                	call   *%rax
}
  801d1d:	48 83 c4 10          	add    $0x10,%rsp
  801d21:	5b                   	pop    %rbx
  801d22:	41 5c                	pop    %r12
  801d24:	41 5d                	pop    %r13
  801d26:	41 5e                	pop    %r14
  801d28:	5d                   	pop    %rbp
  801d29:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801d2a:	48 98                	cltq
  801d2c:	eb ef                	jmp    801d1d <read+0x6e>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801d2e:	48 98                	cltq
  801d30:	eb eb                	jmp    801d1d <read+0x6e>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801d32:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801d39:	00 00 00 
  801d3c:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801d42:	89 da                	mov    %ebx,%edx
  801d44:	48 bf 2f 42 80 00 00 	movabs $0x80422f,%rdi
  801d4b:	00 00 00 
  801d4e:	b8 00 00 00 00       	mov    $0x0,%eax
  801d53:	48 b9 08 06 80 00 00 	movabs $0x800608,%rcx
  801d5a:	00 00 00 
  801d5d:	ff d1                	call   *%rcx
        return -E_INVAL;
  801d5f:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801d66:	eb b5                	jmp    801d1d <read+0x6e>
    if (!dev->dev_read) return -E_NOT_SUPP;
  801d68:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801d6f:	eb ac                	jmp    801d1d <read+0x6e>

0000000000801d71 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801d71:	f3 0f 1e fa          	endbr64
  801d75:	55                   	push   %rbp
  801d76:	48 89 e5             	mov    %rsp,%rbp
  801d79:	41 57                	push   %r15
  801d7b:	41 56                	push   %r14
  801d7d:	41 55                	push   %r13
  801d7f:	41 54                	push   %r12
  801d81:	53                   	push   %rbx
  801d82:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801d86:	48 85 d2             	test   %rdx,%rdx
  801d89:	74 54                	je     801ddf <readn+0x6e>
  801d8b:	41 89 fd             	mov    %edi,%r13d
  801d8e:	49 89 f6             	mov    %rsi,%r14
  801d91:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801d94:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801d99:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801d9e:	49 bf af 1c 80 00 00 	movabs $0x801caf,%r15
  801da5:	00 00 00 
  801da8:	4c 89 e2             	mov    %r12,%rdx
  801dab:	48 29 f2             	sub    %rsi,%rdx
  801dae:	4c 01 f6             	add    %r14,%rsi
  801db1:	44 89 ef             	mov    %r13d,%edi
  801db4:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  801db7:	85 c0                	test   %eax,%eax
  801db9:	78 20                	js     801ddb <readn+0x6a>
    for (; inc && res < n; res += inc) {
  801dbb:	01 c3                	add    %eax,%ebx
  801dbd:	85 c0                	test   %eax,%eax
  801dbf:	74 08                	je     801dc9 <readn+0x58>
  801dc1:	48 63 f3             	movslq %ebx,%rsi
  801dc4:	4c 39 e6             	cmp    %r12,%rsi
  801dc7:	72 df                	jb     801da8 <readn+0x37>
    }
    return res;
  801dc9:	48 63 c3             	movslq %ebx,%rax
}
  801dcc:	48 83 c4 08          	add    $0x8,%rsp
  801dd0:	5b                   	pop    %rbx
  801dd1:	41 5c                	pop    %r12
  801dd3:	41 5d                	pop    %r13
  801dd5:	41 5e                	pop    %r14
  801dd7:	41 5f                	pop    %r15
  801dd9:	5d                   	pop    %rbp
  801dda:	c3                   	ret
        if (inc < 0) return inc;
  801ddb:	48 98                	cltq
  801ddd:	eb ed                	jmp    801dcc <readn+0x5b>
    int inc = 1, res = 0;
  801ddf:	bb 00 00 00 00       	mov    $0x0,%ebx
  801de4:	eb e3                	jmp    801dc9 <readn+0x58>

0000000000801de6 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  801de6:	f3 0f 1e fa          	endbr64
  801dea:	55                   	push   %rbp
  801deb:	48 89 e5             	mov    %rsp,%rbp
  801dee:	41 56                	push   %r14
  801df0:	41 55                	push   %r13
  801df2:	41 54                	push   %r12
  801df4:	53                   	push   %rbx
  801df5:	48 83 ec 10          	sub    $0x10,%rsp
  801df9:	89 fb                	mov    %edi,%ebx
  801dfb:	49 89 f4             	mov    %rsi,%r12
  801dfe:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801e01:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801e05:	48 b8 b4 19 80 00 00 	movabs $0x8019b4,%rax
  801e0c:	00 00 00 
  801e0f:	ff d0                	call   *%rax
  801e11:	85 c0                	test   %eax,%eax
  801e13:	78 47                	js     801e5c <write+0x76>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801e15:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801e19:	41 8b 3e             	mov    (%r14),%edi
  801e1c:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801e20:	48 b8 03 1a 80 00 00 	movabs $0x801a03,%rax
  801e27:	00 00 00 
  801e2a:	ff d0                	call   *%rax
  801e2c:	85 c0                	test   %eax,%eax
  801e2e:	78 30                	js     801e60 <write+0x7a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801e30:	41 f6 46 08 03       	testb  $0x3,0x8(%r14)
  801e35:	74 2d                	je     801e64 <write+0x7e>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801e37:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801e3b:	48 8b 40 18          	mov    0x18(%rax),%rax
  801e3f:	48 85 c0             	test   %rax,%rax
  801e42:	74 56                	je     801e9a <write+0xb4>

    return (*dev->dev_write)(fd, buf, n);
  801e44:	4c 89 ea             	mov    %r13,%rdx
  801e47:	4c 89 e6             	mov    %r12,%rsi
  801e4a:	4c 89 f7             	mov    %r14,%rdi
  801e4d:	ff d0                	call   *%rax
}
  801e4f:	48 83 c4 10          	add    $0x10,%rsp
  801e53:	5b                   	pop    %rbx
  801e54:	41 5c                	pop    %r12
  801e56:	41 5d                	pop    %r13
  801e58:	41 5e                	pop    %r14
  801e5a:	5d                   	pop    %rbp
  801e5b:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801e5c:	48 98                	cltq
  801e5e:	eb ef                	jmp    801e4f <write+0x69>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801e60:	48 98                	cltq
  801e62:	eb eb                	jmp    801e4f <write+0x69>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801e64:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801e6b:	00 00 00 
  801e6e:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801e74:	89 da                	mov    %ebx,%edx
  801e76:	48 bf 4b 42 80 00 00 	movabs $0x80424b,%rdi
  801e7d:	00 00 00 
  801e80:	b8 00 00 00 00       	mov    $0x0,%eax
  801e85:	48 b9 08 06 80 00 00 	movabs $0x800608,%rcx
  801e8c:	00 00 00 
  801e8f:	ff d1                	call   *%rcx
        return -E_INVAL;
  801e91:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801e98:	eb b5                	jmp    801e4f <write+0x69>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801e9a:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801ea1:	eb ac                	jmp    801e4f <write+0x69>

0000000000801ea3 <seek>:

int
seek(int fdnum, off_t offset) {
  801ea3:	f3 0f 1e fa          	endbr64
  801ea7:	55                   	push   %rbp
  801ea8:	48 89 e5             	mov    %rsp,%rbp
  801eab:	53                   	push   %rbx
  801eac:	48 83 ec 18          	sub    $0x18,%rsp
  801eb0:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801eb2:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801eb6:	48 b8 b4 19 80 00 00 	movabs $0x8019b4,%rax
  801ebd:	00 00 00 
  801ec0:	ff d0                	call   *%rax
  801ec2:	85 c0                	test   %eax,%eax
  801ec4:	78 0c                	js     801ed2 <seek+0x2f>

    fd->fd_offset = offset;
  801ec6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801eca:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  801ecd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ed2:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801ed6:	c9                   	leave
  801ed7:	c3                   	ret

0000000000801ed8 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  801ed8:	f3 0f 1e fa          	endbr64
  801edc:	55                   	push   %rbp
  801edd:	48 89 e5             	mov    %rsp,%rbp
  801ee0:	41 55                	push   %r13
  801ee2:	41 54                	push   %r12
  801ee4:	53                   	push   %rbx
  801ee5:	48 83 ec 18          	sub    $0x18,%rsp
  801ee9:	89 fb                	mov    %edi,%ebx
  801eeb:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801eee:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801ef2:	48 b8 b4 19 80 00 00 	movabs $0x8019b4,%rax
  801ef9:	00 00 00 
  801efc:	ff d0                	call   *%rax
  801efe:	85 c0                	test   %eax,%eax
  801f00:	78 38                	js     801f3a <ftruncate+0x62>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801f02:	4c 8b 6d d8          	mov    -0x28(%rbp),%r13
  801f06:	41 8b 7d 00          	mov    0x0(%r13),%edi
  801f0a:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801f0e:	48 b8 03 1a 80 00 00 	movabs $0x801a03,%rax
  801f15:	00 00 00 
  801f18:	ff d0                	call   *%rax
  801f1a:	85 c0                	test   %eax,%eax
  801f1c:	78 1c                	js     801f3a <ftruncate+0x62>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801f1e:	41 f6 45 08 03       	testb  $0x3,0x8(%r13)
  801f23:	74 20                	je     801f45 <ftruncate+0x6d>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801f25:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801f29:	48 8b 40 30          	mov    0x30(%rax),%rax
  801f2d:	48 85 c0             	test   %rax,%rax
  801f30:	74 47                	je     801f79 <ftruncate+0xa1>

    return (*dev->dev_trunc)(fd, newsize);
  801f32:	44 89 e6             	mov    %r12d,%esi
  801f35:	4c 89 ef             	mov    %r13,%rdi
  801f38:	ff d0                	call   *%rax
}
  801f3a:	48 83 c4 18          	add    $0x18,%rsp
  801f3e:	5b                   	pop    %rbx
  801f3f:	41 5c                	pop    %r12
  801f41:	41 5d                	pop    %r13
  801f43:	5d                   	pop    %rbp
  801f44:	c3                   	ret
                thisenv->env_id, fdnum);
  801f45:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801f4c:	00 00 00 
  801f4f:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801f55:	89 da                	mov    %ebx,%edx
  801f57:	48 bf e8 43 80 00 00 	movabs $0x8043e8,%rdi
  801f5e:	00 00 00 
  801f61:	b8 00 00 00 00       	mov    $0x0,%eax
  801f66:	48 b9 08 06 80 00 00 	movabs $0x800608,%rcx
  801f6d:	00 00 00 
  801f70:	ff d1                	call   *%rcx
        return -E_INVAL;
  801f72:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f77:	eb c1                	jmp    801f3a <ftruncate+0x62>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801f79:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801f7e:	eb ba                	jmp    801f3a <ftruncate+0x62>

0000000000801f80 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  801f80:	f3 0f 1e fa          	endbr64
  801f84:	55                   	push   %rbp
  801f85:	48 89 e5             	mov    %rsp,%rbp
  801f88:	41 54                	push   %r12
  801f8a:	53                   	push   %rbx
  801f8b:	48 83 ec 10          	sub    $0x10,%rsp
  801f8f:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801f92:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801f96:	48 b8 b4 19 80 00 00 	movabs $0x8019b4,%rax
  801f9d:	00 00 00 
  801fa0:	ff d0                	call   *%rax
  801fa2:	85 c0                	test   %eax,%eax
  801fa4:	78 4e                	js     801ff4 <fstat+0x74>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801fa6:	4c 8b 65 e8          	mov    -0x18(%rbp),%r12
  801faa:	41 8b 3c 24          	mov    (%r12),%edi
  801fae:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801fb2:	48 b8 03 1a 80 00 00 	movabs $0x801a03,%rax
  801fb9:	00 00 00 
  801fbc:	ff d0                	call   *%rax
  801fbe:	85 c0                	test   %eax,%eax
  801fc0:	78 32                	js     801ff4 <fstat+0x74>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  801fc2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fc6:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  801fcb:	74 30                	je     801ffd <fstat+0x7d>

    stat->st_name[0] = 0;
  801fcd:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  801fd0:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  801fd7:	00 00 00 
    stat->st_isdir = 0;
  801fda:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801fe1:	00 00 00 
    stat->st_dev = dev;
  801fe4:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  801feb:	48 89 de             	mov    %rbx,%rsi
  801fee:	4c 89 e7             	mov    %r12,%rdi
  801ff1:	ff 50 28             	call   *0x28(%rax)
}
  801ff4:	48 83 c4 10          	add    $0x10,%rsp
  801ff8:	5b                   	pop    %rbx
  801ff9:	41 5c                	pop    %r12
  801ffb:	5d                   	pop    %rbp
  801ffc:	c3                   	ret
    if (!dev->dev_stat) return -E_NOT_SUPP;
  801ffd:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  802002:	eb f0                	jmp    801ff4 <fstat+0x74>

0000000000802004 <stat>:

int
stat(const char *path, struct Stat *stat) {
  802004:	f3 0f 1e fa          	endbr64
  802008:	55                   	push   %rbp
  802009:	48 89 e5             	mov    %rsp,%rbp
  80200c:	41 54                	push   %r12
  80200e:	53                   	push   %rbx
  80200f:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  802012:	be 00 00 00 00       	mov    $0x0,%esi
  802017:	48 b8 e5 22 80 00 00 	movabs $0x8022e5,%rax
  80201e:	00 00 00 
  802021:	ff d0                	call   *%rax
  802023:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  802025:	85 c0                	test   %eax,%eax
  802027:	78 25                	js     80204e <stat+0x4a>

    int res = fstat(fd, stat);
  802029:	4c 89 e6             	mov    %r12,%rsi
  80202c:	89 c7                	mov    %eax,%edi
  80202e:	48 b8 80 1f 80 00 00 	movabs $0x801f80,%rax
  802035:	00 00 00 
  802038:	ff d0                	call   *%rax
  80203a:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  80203d:	89 df                	mov    %ebx,%edi
  80203f:	48 b8 25 1b 80 00 00 	movabs $0x801b25,%rax
  802046:	00 00 00 
  802049:	ff d0                	call   *%rax

    return res;
  80204b:	44 89 e3             	mov    %r12d,%ebx
}
  80204e:	89 d8                	mov    %ebx,%eax
  802050:	5b                   	pop    %rbx
  802051:	41 5c                	pop    %r12
  802053:	5d                   	pop    %rbp
  802054:	c3                   	ret

0000000000802055 <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  802055:	f3 0f 1e fa          	endbr64
  802059:	55                   	push   %rbp
  80205a:	48 89 e5             	mov    %rsp,%rbp
  80205d:	41 54                	push   %r12
  80205f:	53                   	push   %rbx
  802060:	48 83 ec 10          	sub    $0x10,%rsp
  802064:	41 89 fc             	mov    %edi,%r12d
  802067:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  80206a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802071:	00 00 00 
  802074:	83 38 00             	cmpl   $0x0,(%rax)
  802077:	74 6e                	je     8020e7 <fsipc+0x92>

    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }
    fsenv = ipc_find_env(ENV_TYPE_FS);
  802079:	bf 03 00 00 00       	mov    $0x3,%edi
  80207e:	48 b8 e0 36 80 00 00 	movabs $0x8036e0,%rax
  802085:	00 00 00 
  802088:	ff d0                	call   *%rax
  80208a:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  802091:	00 00 
    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  802093:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  802099:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80209e:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8020a5:	00 00 00 
  8020a8:	44 89 e6             	mov    %r12d,%esi
  8020ab:	89 c7                	mov    %eax,%edi
  8020ad:	48 b8 1e 36 80 00 00 	movabs $0x80361e,%rax
  8020b4:	00 00 00 
  8020b7:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  8020b9:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  8020c0:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  8020c1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8020c6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8020ca:	48 89 de             	mov    %rbx,%rsi
  8020cd:	bf 00 00 00 00       	mov    $0x0,%edi
  8020d2:	48 b8 85 35 80 00 00 	movabs $0x803585,%rax
  8020d9:	00 00 00 
  8020dc:	ff d0                	call   *%rax
}
  8020de:	48 83 c4 10          	add    $0x10,%rsp
  8020e2:	5b                   	pop    %rbx
  8020e3:	41 5c                	pop    %r12
  8020e5:	5d                   	pop    %rbp
  8020e6:	c3                   	ret
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  8020e7:	bf 03 00 00 00       	mov    $0x3,%edi
  8020ec:	48 b8 e0 36 80 00 00 	movabs $0x8036e0,%rax
  8020f3:	00 00 00 
  8020f6:	ff d0                	call   *%rax
  8020f8:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  8020ff:	00 00 
  802101:	e9 73 ff ff ff       	jmp    802079 <fsipc+0x24>

0000000000802106 <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  802106:	f3 0f 1e fa          	endbr64
  80210a:	55                   	push   %rbp
  80210b:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80210e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802115:	00 00 00 
  802118:	8b 57 0c             	mov    0xc(%rdi),%edx
  80211b:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  80211d:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  802120:	be 00 00 00 00       	mov    $0x0,%esi
  802125:	bf 02 00 00 00       	mov    $0x2,%edi
  80212a:	48 b8 55 20 80 00 00 	movabs $0x802055,%rax
  802131:	00 00 00 
  802134:	ff d0                	call   *%rax
}
  802136:	5d                   	pop    %rbp
  802137:	c3                   	ret

0000000000802138 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  802138:	f3 0f 1e fa          	endbr64
  80213c:	55                   	push   %rbp
  80213d:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802140:	8b 47 0c             	mov    0xc(%rdi),%eax
  802143:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  80214a:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  80214c:	be 00 00 00 00       	mov    $0x0,%esi
  802151:	bf 06 00 00 00       	mov    $0x6,%edi
  802156:	48 b8 55 20 80 00 00 	movabs $0x802055,%rax
  80215d:	00 00 00 
  802160:	ff d0                	call   *%rax
}
  802162:	5d                   	pop    %rbp
  802163:	c3                   	ret

0000000000802164 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  802164:	f3 0f 1e fa          	endbr64
  802168:	55                   	push   %rbp
  802169:	48 89 e5             	mov    %rsp,%rbp
  80216c:	41 54                	push   %r12
  80216e:	53                   	push   %rbx
  80216f:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802172:	8b 47 0c             	mov    0xc(%rdi),%eax
  802175:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  80217c:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  80217e:	be 00 00 00 00       	mov    $0x0,%esi
  802183:	bf 05 00 00 00       	mov    $0x5,%edi
  802188:	48 b8 55 20 80 00 00 	movabs $0x802055,%rax
  80218f:	00 00 00 
  802192:	ff d0                	call   *%rax
    if (res < 0) return res;
  802194:	85 c0                	test   %eax,%eax
  802196:	78 3d                	js     8021d5 <devfile_stat+0x71>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802198:	49 bc 00 70 80 00 00 	movabs $0x807000,%r12
  80219f:	00 00 00 
  8021a2:	4c 89 e6             	mov    %r12,%rsi
  8021a5:	48 89 df             	mov    %rbx,%rdi
  8021a8:	48 b8 51 0f 80 00 00 	movabs $0x800f51,%rax
  8021af:	00 00 00 
  8021b2:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  8021b4:	41 8b 84 24 80 00 00 	mov    0x80(%r12),%eax
  8021bb:	00 
  8021bc:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8021c2:	41 8b 84 24 84 00 00 	mov    0x84(%r12),%eax
  8021c9:	00 
  8021ca:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  8021d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021d5:	5b                   	pop    %rbx
  8021d6:	41 5c                	pop    %r12
  8021d8:	5d                   	pop    %rbp
  8021d9:	c3                   	ret

00000000008021da <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  8021da:	f3 0f 1e fa          	endbr64
    if (n >= sizeof(fsipcbuf.write.req_buf)) {
  8021de:	48 81 fa ef 0f 00 00 	cmp    $0xfef,%rdx
  8021e5:	77 41                	ja     802228 <devfile_write+0x4e>
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  8021e7:	55                   	push   %rbp
  8021e8:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  8021eb:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8021f2:	00 00 00 
  8021f5:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  8021f8:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.write.req_n = n;
  8021fa:	48 89 50 08          	mov    %rdx,0x8(%rax)
    memmove(fsipcbuf.write.req_buf, buf, n);
  8021fe:	48 8d 78 10          	lea    0x10(%rax),%rdi
  802202:	48 b8 6c 11 80 00 00 	movabs $0x80116c,%rax
  802209:	00 00 00 
  80220c:	ff d0                	call   *%rax
    res = fsipc(FSREQ_WRITE, NULL);
  80220e:	be 00 00 00 00       	mov    $0x0,%esi
  802213:	bf 04 00 00 00       	mov    $0x4,%edi
  802218:	48 b8 55 20 80 00 00 	movabs $0x802055,%rax
  80221f:	00 00 00 
  802222:	ff d0                	call   *%rax
  802224:	48 98                	cltq
}
  802226:	5d                   	pop    %rbp
  802227:	c3                   	ret
        return -E_INVAL;
  802228:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
}
  80222f:	c3                   	ret

0000000000802230 <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  802230:	f3 0f 1e fa          	endbr64
  802234:	55                   	push   %rbp
  802235:	48 89 e5             	mov    %rsp,%rbp
  802238:	41 55                	push   %r13
  80223a:	41 54                	push   %r12
  80223c:	53                   	push   %rbx
  80223d:	48 83 ec 08          	sub    $0x8,%rsp
  802241:	49 89 f4             	mov    %rsi,%r12
  802244:	48 89 d3             	mov    %rdx,%rbx
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  802247:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80224e:	00 00 00 
  802251:	8b 57 0c             	mov    0xc(%rdi),%edx
  802254:	89 10                	mov    %edx,(%rax)
    fsipcbuf.read.req_n = n;
  802256:	48 89 58 08          	mov    %rbx,0x8(%rax)
    res = fsipc(FSREQ_READ, NULL);
  80225a:	be 00 00 00 00       	mov    $0x0,%esi
  80225f:	bf 03 00 00 00       	mov    $0x3,%edi
  802264:	48 b8 55 20 80 00 00 	movabs $0x802055,%rax
  80226b:	00 00 00 
  80226e:	ff d0                	call   *%rax
  802270:	4c 63 e8             	movslq %eax,%r13
    if (res < 0) {
  802273:	4d 85 ed             	test   %r13,%r13
  802276:	78 2a                	js     8022a2 <devfile_read+0x72>
    assert(res <= n && res <= PAGE_SIZE);
  802278:	4c 89 ea             	mov    %r13,%rdx
  80227b:	4c 39 eb             	cmp    %r13,%rbx
  80227e:	72 30                	jb     8022b0 <devfile_read+0x80>
  802280:	49 81 fd 00 10 00 00 	cmp    $0x1000,%r13
  802287:	7f 27                	jg     8022b0 <devfile_read+0x80>
    memmove(buf, &fsipcbuf, res);
  802289:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802290:	00 00 00 
  802293:	4c 89 e7             	mov    %r12,%rdi
  802296:	48 b8 6c 11 80 00 00 	movabs $0x80116c,%rax
  80229d:	00 00 00 
  8022a0:	ff d0                	call   *%rax
}
  8022a2:	4c 89 e8             	mov    %r13,%rax
  8022a5:	48 83 c4 08          	add    $0x8,%rsp
  8022a9:	5b                   	pop    %rbx
  8022aa:	41 5c                	pop    %r12
  8022ac:	41 5d                	pop    %r13
  8022ae:	5d                   	pop    %rbp
  8022af:	c3                   	ret
    assert(res <= n && res <= PAGE_SIZE);
  8022b0:	48 b9 68 42 80 00 00 	movabs $0x804268,%rcx
  8022b7:	00 00 00 
  8022ba:	48 ba 85 42 80 00 00 	movabs $0x804285,%rdx
  8022c1:	00 00 00 
  8022c4:	be 7b 00 00 00       	mov    $0x7b,%esi
  8022c9:	48 bf 9a 42 80 00 00 	movabs $0x80429a,%rdi
  8022d0:	00 00 00 
  8022d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d8:	49 b8 ac 04 80 00 00 	movabs $0x8004ac,%r8
  8022df:	00 00 00 
  8022e2:	41 ff d0             	call   *%r8

00000000008022e5 <open>:
open(const char *path, int mode) {
  8022e5:	f3 0f 1e fa          	endbr64
  8022e9:	55                   	push   %rbp
  8022ea:	48 89 e5             	mov    %rsp,%rbp
  8022ed:	41 55                	push   %r13
  8022ef:	41 54                	push   %r12
  8022f1:	53                   	push   %rbx
  8022f2:	48 83 ec 18          	sub    $0x18,%rsp
  8022f6:	49 89 fc             	mov    %rdi,%r12
  8022f9:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  8022fc:	48 b8 0c 0f 80 00 00 	movabs $0x800f0c,%rax
  802303:	00 00 00 
  802306:	ff d0                	call   *%rax
  802308:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  80230e:	0f 87 8a 00 00 00    	ja     80239e <open+0xb9>
    if ((res = fd_alloc(&fd)) < 0) return res;
  802314:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802318:	48 b8 50 19 80 00 00 	movabs $0x801950,%rax
  80231f:	00 00 00 
  802322:	ff d0                	call   *%rax
  802324:	89 c3                	mov    %eax,%ebx
  802326:	85 c0                	test   %eax,%eax
  802328:	78 50                	js     80237a <open+0x95>
    strcpy(fsipcbuf.open.req_path, path);
  80232a:	4c 89 e6             	mov    %r12,%rsi
  80232d:	48 bb 00 70 80 00 00 	movabs $0x807000,%rbx
  802334:	00 00 00 
  802337:	48 89 df             	mov    %rbx,%rdi
  80233a:	48 b8 51 0f 80 00 00 	movabs $0x800f51,%rax
  802341:	00 00 00 
  802344:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  802346:	44 89 ab 00 04 00 00 	mov    %r13d,0x400(%rbx)
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  80234d:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802351:	bf 01 00 00 00       	mov    $0x1,%edi
  802356:	48 b8 55 20 80 00 00 	movabs $0x802055,%rax
  80235d:	00 00 00 
  802360:	ff d0                	call   *%rax
  802362:	89 c3                	mov    %eax,%ebx
  802364:	85 c0                	test   %eax,%eax
  802366:	78 1f                	js     802387 <open+0xa2>
    return fd2num(fd);
  802368:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80236c:	48 b8 1a 19 80 00 00 	movabs $0x80191a,%rax
  802373:	00 00 00 
  802376:	ff d0                	call   *%rax
  802378:	89 c3                	mov    %eax,%ebx
}
  80237a:	89 d8                	mov    %ebx,%eax
  80237c:	48 83 c4 18          	add    $0x18,%rsp
  802380:	5b                   	pop    %rbx
  802381:	41 5c                	pop    %r12
  802383:	41 5d                	pop    %r13
  802385:	5d                   	pop    %rbp
  802386:	c3                   	ret
        fd_close(fd, 0);
  802387:	be 00 00 00 00       	mov    $0x0,%esi
  80238c:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802390:	48 b8 77 1a 80 00 00 	movabs $0x801a77,%rax
  802397:	00 00 00 
  80239a:	ff d0                	call   *%rax
        return res;
  80239c:	eb dc                	jmp    80237a <open+0x95>
        return -E_BAD_PATH;
  80239e:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  8023a3:	eb d5                	jmp    80237a <open+0x95>

00000000008023a5 <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  8023a5:	f3 0f 1e fa          	endbr64
  8023a9:	55                   	push   %rbp
  8023aa:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  8023ad:	be 00 00 00 00       	mov    $0x0,%esi
  8023b2:	bf 08 00 00 00       	mov    $0x8,%edi
  8023b7:	48 b8 55 20 80 00 00 	movabs $0x802055,%rax
  8023be:	00 00 00 
  8023c1:	ff d0                	call   *%rax
}
  8023c3:	5d                   	pop    %rbp
  8023c4:	c3                   	ret

00000000008023c5 <copy_shared_region>:
    if (sys_unmap_region(0, UTEMP, USER_STACK_SIZE) < 0) goto error;
    return res;
}

static int
copy_shared_region(void *start, void *end, void *arg) {
  8023c5:	f3 0f 1e fa          	endbr64
  8023c9:	55                   	push   %rbp
  8023ca:	48 89 e5             	mov    %rsp,%rbp
  8023cd:	41 55                	push   %r13
  8023cf:	41 54                	push   %r12
  8023d1:	53                   	push   %rbx
  8023d2:	48 83 ec 08          	sub    $0x8,%rsp
  8023d6:	48 89 fb             	mov    %rdi,%rbx
  8023d9:	49 89 f4             	mov    %rsi,%r12
    envid_t child = *(envid_t *)arg;
  8023dc:	44 8b 2a             	mov    (%rdx),%r13d
    return sys_map_region(0, start, child, start, end - start, get_prot(start));
  8023df:	48 b8 fe 33 80 00 00 	movabs $0x8033fe,%rax
  8023e6:	00 00 00 
  8023e9:	ff d0                	call   *%rax
  8023eb:	41 89 c1             	mov    %eax,%r9d
  8023ee:	4d 89 e0             	mov    %r12,%r8
  8023f1:	49 29 d8             	sub    %rbx,%r8
  8023f4:	48 89 d9             	mov    %rbx,%rcx
  8023f7:	44 89 ea             	mov    %r13d,%edx
  8023fa:	48 89 de             	mov    %rbx,%rsi
  8023fd:	bf 00 00 00 00       	mov    $0x0,%edi
  802402:	48 b8 c1 15 80 00 00 	movabs $0x8015c1,%rax
  802409:	00 00 00 
  80240c:	ff d0                	call   *%rax
}
  80240e:	48 83 c4 08          	add    $0x8,%rsp
  802412:	5b                   	pop    %rbx
  802413:	41 5c                	pop    %r12
  802415:	41 5d                	pop    %r13
  802417:	5d                   	pop    %rbp
  802418:	c3                   	ret

0000000000802419 <spawn>:
spawn(const char *prog, const char **argv) {
  802419:	f3 0f 1e fa          	endbr64
  80241d:	55                   	push   %rbp
  80241e:	48 89 e5             	mov    %rsp,%rbp
  802421:	41 57                	push   %r15
  802423:	41 56                	push   %r14
  802425:	41 55                	push   %r13
  802427:	41 54                	push   %r12
  802429:	53                   	push   %rbx
  80242a:	48 81 ec f8 02 00 00 	sub    $0x2f8,%rsp
  802431:	49 89 f4             	mov    %rsi,%r12
    int fd = open(prog, O_RDONLY);
  802434:	be 00 00 00 00       	mov    $0x0,%esi
  802439:	48 b8 e5 22 80 00 00 	movabs $0x8022e5,%rax
  802440:	00 00 00 
  802443:	ff d0                	call   *%rax
  802445:	89 85 fc fc ff ff    	mov    %eax,-0x304(%rbp)
    if (fd < 0) return fd;
  80244b:	85 c0                	test   %eax,%eax
  80244d:	0f 88 30 06 00 00    	js     802a83 <spawn+0x66a>
  802453:	89 c7                	mov    %eax,%edi
    res = readn(fd, elf_buf, sizeof(elf_buf));
  802455:	ba 00 02 00 00       	mov    $0x200,%edx
  80245a:	48 8d b5 d0 fd ff ff 	lea    -0x230(%rbp),%rsi
  802461:	48 b8 71 1d 80 00 00 	movabs $0x801d71,%rax
  802468:	00 00 00 
  80246b:	ff d0                	call   *%rax
  80246d:	89 c6                	mov    %eax,%esi
    if (res != sizeof(elf_buf)) {
  80246f:	3d 00 02 00 00       	cmp    $0x200,%eax
  802474:	0f 85 7d 02 00 00    	jne    8026f7 <spawn+0x2de>
        elf->e_elf[1] != 1 /* little endian */ ||
  80247a:	48 b8 ff ff ff ff ff 	movabs $0xffffffffffffff,%rax
  802481:	ff ff 00 
  802484:	48 23 85 d0 fd ff ff 	and    -0x230(%rbp),%rax
    if (elf->e_magic != ELF_MAGIC ||
  80248b:	48 ba 7f 45 4c 46 02 	movabs $0x10102464c457f,%rdx
  802492:	01 01 00 
  802495:	48 39 d0             	cmp    %rdx,%rax
  802498:	0f 85 95 02 00 00    	jne    802733 <spawn+0x31a>
        elf->e_type != ET_EXEC /* executable */ ||
  80249e:	81 bd e0 fd ff ff 02 	cmpl   $0x3e0002,-0x220(%rbp)
  8024a5:	00 3e 00 
  8024a8:	0f 85 85 02 00 00    	jne    802733 <spawn+0x31a>

/* This must be inlined. Exercise for reader: why? */
static inline envid_t __attribute__((always_inline))
sys_exofork(void) {
    envid_t ret;
    asm volatile("int %2"
  8024ae:	b8 09 00 00 00       	mov    $0x9,%eax
  8024b3:	cd 30                	int    $0x30
  8024b5:	41 89 c6             	mov    %eax,%r14d
  8024b8:	89 c3                	mov    %eax,%ebx
    if ((int)(res = sys_exofork()) < 0) goto error2;
  8024ba:	85 c0                	test   %eax,%eax
  8024bc:	0f 88 a9 05 00 00    	js     802a6b <spawn+0x652>
    envid_t child = res;
  8024c2:	89 85 cc fd ff ff    	mov    %eax,-0x234(%rbp)
    struct Trapframe child_tf = envs[ENVX(child)].env_tf;
  8024c8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8024cd:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8024d1:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8024d5:	48 c1 e0 04          	shl    $0x4,%rax
  8024d9:	48 be 00 00 a0 1f 80 	movabs $0x801fa00000,%rsi
  8024e0:	00 00 00 
  8024e3:	48 01 c6             	add    %rax,%rsi
  8024e6:	48 8b 06             	mov    (%rsi),%rax
  8024e9:	48 89 85 0c fd ff ff 	mov    %rax,-0x2f4(%rbp)
  8024f0:	48 8b 86 b8 00 00 00 	mov    0xb8(%rsi),%rax
  8024f7:	48 89 85 c4 fd ff ff 	mov    %rax,-0x23c(%rbp)
  8024fe:	48 8d bd 10 fd ff ff 	lea    -0x2f0(%rbp),%rdi
  802505:	48 c7 c1 fc ff ff ff 	mov    $0xfffffffffffffffc,%rcx
  80250c:	48 29 ce             	sub    %rcx,%rsi
  80250f:	81 c1 c0 00 00 00    	add    $0xc0,%ecx
  802515:	c1 e9 03             	shr    $0x3,%ecx
  802518:	89 c9                	mov    %ecx,%ecx
  80251a:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
    child_tf.tf_rip = elf->e_entry;
  80251d:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802524:	48 89 85 a4 fd ff ff 	mov    %rax,-0x25c(%rbp)
    for (argc = 0; argv[argc] != 0; argc++)
  80252b:	49 8b 3c 24          	mov    (%r12),%rdi
  80252f:	48 85 ff             	test   %rdi,%rdi
  802532:	0f 84 7f 05 00 00    	je     802ab7 <spawn+0x69e>
  802538:	41 bd 01 00 00 00    	mov    $0x1,%r13d
    string_size = 0;
  80253e:	41 bf 00 00 00 00    	mov    $0x0,%r15d
        string_size += strlen(argv[argc]) + 1;
  802544:	48 bb 0c 0f 80 00 00 	movabs $0x800f0c,%rbx
  80254b:	00 00 00 
  80254e:	ff d3                	call   *%rbx
  802550:	4c 01 f8             	add    %r15,%rax
  802553:	4c 8d 78 01          	lea    0x1(%rax),%r15
    for (argc = 0; argv[argc] != 0; argc++)
  802557:	4c 89 ea             	mov    %r13,%rdx
  80255a:	49 83 c5 01          	add    $0x1,%r13
  80255e:	4b 8b 7c ec f8       	mov    -0x8(%r12,%r13,8),%rdi
  802563:	48 85 ff             	test   %rdi,%rdi
  802566:	75 e6                	jne    80254e <spawn+0x135>
    string_store = (char *)UTEMP + USER_STACK_SIZE - string_size;
  802568:	49 89 d5             	mov    %rdx,%r13
  80256b:	48 89 95 e8 fc ff ff 	mov    %rdx,-0x318(%rbp)
  802572:	48 f7 d0             	not    %rax
  802575:	48 8d 98 00 00 41 00 	lea    0x410000(%rax),%rbx
    argv_store = (uintptr_t *)(ROUNDDOWN(string_store, sizeof(uintptr_t)) - sizeof(uintptr_t) * (argc + 1));
  80257c:	49 89 df             	mov    %rbx,%r15
  80257f:	49 83 e7 f8          	and    $0xfffffffffffffff8,%r15
  802583:	4c 89 bd e0 fc ff ff 	mov    %r15,-0x320(%rbp)
  80258a:	89 d0                	mov    %edx,%eax
  80258c:	83 c0 01             	add    $0x1,%eax
  80258f:	48 98                	cltq
  802591:	48 c1 e0 03          	shl    $0x3,%rax
  802595:	49 29 c7             	sub    %rax,%r15
  802598:	4c 89 bd f0 fc ff ff 	mov    %r15,-0x310(%rbp)
    if ((void *)(argv_store - 2) < (void *)UTEMP) return -E_NO_MEM;
  80259f:	49 8d 47 f0          	lea    -0x10(%r15),%rax
  8025a3:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  8025a9:	0f 86 ff 04 00 00    	jbe    802aae <spawn+0x695>
    if ((res = sys_alloc_region(0, UTEMP, USER_STACK_SIZE, PROT_RW)) < 0) return res;
  8025af:	b9 06 00 00 00       	mov    $0x6,%ecx
  8025b4:	ba 00 00 01 00       	mov    $0x10000,%edx
  8025b9:	be 00 00 40 00       	mov    $0x400000,%esi
  8025be:	48 b8 56 15 80 00 00 	movabs $0x801556,%rax
  8025c5:	00 00 00 
  8025c8:	ff d0                	call   *%rax
  8025ca:	85 c0                	test   %eax,%eax
  8025cc:	0f 88 e1 04 00 00    	js     802ab3 <spawn+0x69a>
    for (i = 0; i < argc; i++) {
  8025d2:	4c 89 e8             	mov    %r13,%rax
  8025d5:	45 85 ed             	test   %r13d,%r13d
  8025d8:	7e 54                	jle    80262e <spawn+0x215>
  8025da:	4d 89 fd             	mov    %r15,%r13
  8025dd:	48 98                	cltq
  8025df:	4d 8d 3c c7          	lea    (%r15,%rax,8),%r15
        argv_store[i] = UTEMP2USTACK(string_store);
  8025e3:	48 b8 00 70 fe ff 7f 	movabs $0x7ffffe7000,%rax
  8025ea:	00 00 00 
  8025ed:	48 8d 84 03 00 00 c0 	lea    -0x400000(%rbx,%rax,1),%rax
  8025f4:	ff 
  8025f5:	49 89 45 00          	mov    %rax,0x0(%r13)
        strcpy(string_store, argv[i]);
  8025f9:	49 8b 34 24          	mov    (%r12),%rsi
  8025fd:	48 89 df             	mov    %rbx,%rdi
  802600:	48 b8 51 0f 80 00 00 	movabs $0x800f51,%rax
  802607:	00 00 00 
  80260a:	ff d0                	call   *%rax
        string_store += strlen(argv[i]) + 1;
  80260c:	49 8b 3c 24          	mov    (%r12),%rdi
  802610:	48 b8 0c 0f 80 00 00 	movabs $0x800f0c,%rax
  802617:	00 00 00 
  80261a:	ff d0                	call   *%rax
  80261c:	48 8d 5c 03 01       	lea    0x1(%rbx,%rax,1),%rbx
    for (i = 0; i < argc; i++) {
  802621:	49 83 c5 08          	add    $0x8,%r13
  802625:	49 83 c4 08          	add    $0x8,%r12
  802629:	4d 39 fd             	cmp    %r15,%r13
  80262c:	75 b5                	jne    8025e3 <spawn+0x1ca>
    argv_store[argc] = 0;
  80262e:	48 8b 85 e0 fc ff ff 	mov    -0x320(%rbp),%rax
  802635:	48 c7 40 f8 00 00 00 	movq   $0x0,-0x8(%rax)
  80263c:	00 
    assert(string_store == (char *)UTEMP + USER_STACK_SIZE);
  80263d:	48 81 fb 00 00 41 00 	cmp    $0x410000,%rbx
  802644:	0f 85 30 01 00 00    	jne    80277a <spawn+0x361>
    argv_store[-1] = UTEMP2USTACK(argv_store);
  80264a:	48 b9 00 70 fe ff 7f 	movabs $0x7ffffe7000,%rcx
  802651:	00 00 00 
  802654:	48 8b b5 f0 fc ff ff 	mov    -0x310(%rbp),%rsi
  80265b:	48 8d 84 0e 00 00 c0 	lea    -0x400000(%rsi,%rcx,1),%rax
  802662:	ff 
  802663:	48 89 46 f8          	mov    %rax,-0x8(%rsi)
    argv_store[-2] = argc;
  802667:	48 8b 85 e8 fc ff ff 	mov    -0x318(%rbp),%rax
  80266e:	48 89 46 f0          	mov    %rax,-0x10(%rsi)
    tf->tf_rsp = UTEMP2USTACK(&argv_store[-2]);
  802672:	48 b8 f0 6f fe ff 7f 	movabs $0x7ffffe6ff0,%rax
  802679:	00 00 00 
  80267c:	48 8d 84 06 00 00 c0 	lea    -0x400000(%rsi,%rax,1),%rax
  802683:	ff 
  802684:	48 89 85 bc fd ff ff 	mov    %rax,-0x244(%rbp)
    if (sys_map_region(0, UTEMP, child, (void *)(USER_STACK_TOP - USER_STACK_SIZE),
  80268b:	41 b9 06 00 00 00    	mov    $0x6,%r9d
  802691:	41 b8 00 00 01 00    	mov    $0x10000,%r8d
  802697:	44 89 f2             	mov    %r14d,%edx
  80269a:	be 00 00 40 00       	mov    $0x400000,%esi
  80269f:	bf 00 00 00 00       	mov    $0x0,%edi
  8026a4:	48 b8 c1 15 80 00 00 	movabs $0x8015c1,%rax
  8026ab:	00 00 00 
  8026ae:	ff d0                	call   *%rax
    if (sys_unmap_region(0, UTEMP, USER_STACK_SIZE) < 0) goto error;
  8026b0:	48 bb 96 16 80 00 00 	movabs $0x801696,%rbx
  8026b7:	00 00 00 
  8026ba:	ba 00 00 01 00       	mov    $0x10000,%edx
  8026bf:	be 00 00 40 00       	mov    $0x400000,%esi
  8026c4:	bf 00 00 00 00       	mov    $0x0,%edi
  8026c9:	ff d3                	call   *%rbx
  8026cb:	85 c0                	test   %eax,%eax
  8026cd:	78 eb                	js     8026ba <spawn+0x2a1>
    struct Proghdr *ph = (struct Proghdr *)(elf_buf + elf->e_phoff);
  8026cf:	48 8b 85 f0 fd ff ff 	mov    -0x210(%rbp),%rax
  8026d6:	4c 8d b4 05 d0 fd ff 	lea    -0x230(%rbp,%rax,1),%r14
  8026dd:	ff 
    for (size_t i = 0; i < elf->e_phnum; i++, ph++) {
  8026de:	66 83 bd 08 fe ff ff 	cmpw   $0x0,-0x1f8(%rbp)
  8026e5:	00 
  8026e6:	0f 84 68 02 00 00    	je     802954 <spawn+0x53b>
  8026ec:	41 bf 00 00 00 00    	mov    $0x0,%r15d
  8026f2:	e9 c5 01 00 00       	jmp    8028bc <spawn+0x4a3>
        cprintf("Wrong ELF header size or read error: %i\n", res);
  8026f7:	48 bf 10 44 80 00 00 	movabs $0x804410,%rdi
  8026fe:	00 00 00 
  802701:	b8 00 00 00 00       	mov    $0x0,%eax
  802706:	48 ba 08 06 80 00 00 	movabs $0x800608,%rdx
  80270d:	00 00 00 
  802710:	ff d2                	call   *%rdx
        close(fd);
  802712:	8b bd fc fc ff ff    	mov    -0x304(%rbp),%edi
  802718:	48 b8 25 1b 80 00 00 	movabs $0x801b25,%rax
  80271f:	00 00 00 
  802722:	ff d0                	call   *%rax
        return -E_NOT_EXEC;
  802724:	c7 85 fc fc ff ff ee 	movl   $0xffffffee,-0x304(%rbp)
  80272b:	ff ff ff 
  80272e:	e9 50 03 00 00       	jmp    802a83 <spawn+0x66a>
        cprintf("Elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  802733:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  802738:	8b b5 d0 fd ff ff    	mov    -0x230(%rbp),%esi
  80273e:	48 bf a5 42 80 00 00 	movabs $0x8042a5,%rdi
  802745:	00 00 00 
  802748:	b8 00 00 00 00       	mov    $0x0,%eax
  80274d:	48 b9 08 06 80 00 00 	movabs $0x800608,%rcx
  802754:	00 00 00 
  802757:	ff d1                	call   *%rcx
        close(fd);
  802759:	8b bd fc fc ff ff    	mov    -0x304(%rbp),%edi
  80275f:	48 b8 25 1b 80 00 00 	movabs $0x801b25,%rax
  802766:	00 00 00 
  802769:	ff d0                	call   *%rax
        return -E_NOT_EXEC;
  80276b:	c7 85 fc fc ff ff ee 	movl   $0xffffffee,-0x304(%rbp)
  802772:	ff ff ff 
  802775:	e9 09 03 00 00       	jmp    802a83 <spawn+0x66a>
    assert(string_store == (char *)UTEMP + USER_STACK_SIZE);
  80277a:	48 b9 40 44 80 00 00 	movabs $0x804440,%rcx
  802781:	00 00 00 
  802784:	48 ba 85 42 80 00 00 	movabs $0x804285,%rdx
  80278b:	00 00 00 
  80278e:	be f0 00 00 00       	mov    $0xf0,%esi
  802793:	48 bf bf 42 80 00 00 	movabs $0x8042bf,%rdi
  80279a:	00 00 00 
  80279d:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a2:	49 b8 ac 04 80 00 00 	movabs $0x8004ac,%r8
  8027a9:	00 00 00 
  8027ac:	41 ff d0             	call   *%r8
    /* seek() fd to fileoffset  */
    /* read filesz to UTEMP */
    /* Map read section conents to child */
    /* Unmap it from parent */
    if (filesz != 0) {
        res = sys_alloc_region(CURENVID, UTEMP, filesz, perm | PROT_W);
  8027af:	8b 8d f0 fc ff ff    	mov    -0x310(%rbp),%ecx
  8027b5:	83 c9 02             	or     $0x2,%ecx
  8027b8:	48 89 da             	mov    %rbx,%rdx
  8027bb:	be 00 00 40 00       	mov    $0x400000,%esi
  8027c0:	bf 00 00 00 00       	mov    $0x0,%edi
  8027c5:	48 b8 56 15 80 00 00 	movabs $0x801556,%rax
  8027cc:	00 00 00 
  8027cf:	ff d0                	call   *%rax
        if (res < 0) {
  8027d1:	85 c0                	test   %eax,%eax
  8027d3:	0f 88 7e 02 00 00    	js     802a57 <spawn+0x63e>
            return res;
        }

        res = seek(fd, fileoffset);
  8027d9:	8b b5 e8 fc ff ff    	mov    -0x318(%rbp),%esi
  8027df:	8b bd fc fc ff ff    	mov    -0x304(%rbp),%edi
  8027e5:	48 b8 a3 1e 80 00 00 	movabs $0x801ea3,%rax
  8027ec:	00 00 00 
  8027ef:	ff d0                	call   *%rax
        if (res < 0) {
  8027f1:	85 c0                	test   %eax,%eax
  8027f3:	0f 88 a2 02 00 00    	js     802a9b <spawn+0x682>
            return res;
        }

        res = readn(fd, (void *)UTEMP, filesz);
  8027f9:	48 89 da             	mov    %rbx,%rdx
  8027fc:	be 00 00 40 00       	mov    $0x400000,%esi
  802801:	8b bd fc fc ff ff    	mov    -0x304(%rbp),%edi
  802807:	48 b8 71 1d 80 00 00 	movabs $0x801d71,%rax
  80280e:	00 00 00 
  802811:	ff d0                	call   *%rax
        if (res < 0) {
  802813:	85 c0                	test   %eax,%eax
  802815:	0f 88 84 02 00 00    	js     802a9f <spawn+0x686>
            return res;
        }

        res = sys_map_region(CURENVID, (void *)UTEMP, child, (void *)va, filesz, perm);
  80281b:	44 8b 8d f0 fc ff ff 	mov    -0x310(%rbp),%r9d
  802822:	49 89 d8             	mov    %rbx,%r8
  802825:	4c 89 e1             	mov    %r12,%rcx
  802828:	8b 95 e0 fc ff ff    	mov    -0x320(%rbp),%edx
  80282e:	be 00 00 40 00       	mov    $0x400000,%esi
  802833:	bf 00 00 00 00       	mov    $0x0,%edi
  802838:	48 b8 c1 15 80 00 00 	movabs $0x8015c1,%rax
  80283f:	00 00 00 
  802842:	ff d0                	call   *%rax
        if (res < 0) {
  802844:	85 c0                	test   %eax,%eax
  802846:	0f 88 57 02 00 00    	js     802aa3 <spawn+0x68a>
            return res;
        }

        res = sys_unmap_region(CURENVID, UTEMP, filesz);
  80284c:	48 89 da             	mov    %rbx,%rdx
  80284f:	be 00 00 40 00       	mov    $0x400000,%esi
  802854:	bf 00 00 00 00       	mov    $0x0,%edi
  802859:	48 b8 96 16 80 00 00 	movabs $0x801696,%rax
  802860:	00 00 00 
  802863:	ff d0                	call   *%rax
        if (res < 0) {
  802865:	85 c0                	test   %eax,%eax
  802867:	0f 89 ca 00 00 00    	jns    802937 <spawn+0x51e>
  80286d:	89 c3                	mov    %eax,%ebx
  80286f:	e9 e5 01 00 00       	jmp    802a59 <spawn+0x640>
            return res;
        }
    }

    if (memsz > filesz) {
        res = sys_alloc_region(child, (void *)(va + filesz), (memsz - filesz), perm | ALLOC_ZERO);
  802874:	8b 8d f0 fc ff ff    	mov    -0x310(%rbp),%ecx
  80287a:	81 c9 00 00 10 00    	or     $0x100000,%ecx
  802880:	4c 89 ea             	mov    %r13,%rdx
  802883:	48 29 da             	sub    %rbx,%rdx
  802886:	4a 8d 34 23          	lea    (%rbx,%r12,1),%rsi
  80288a:	8b bd e0 fc ff ff    	mov    -0x320(%rbp),%edi
  802890:	48 b8 56 15 80 00 00 	movabs $0x801556,%rax
  802897:	00 00 00 
  80289a:	ff d0                	call   *%rax
        if ((res = map_segment(child, ph->p_va, ph->p_memsz,
  80289c:	85 c0                	test   %eax,%eax
  80289e:	0f 88 a1 00 00 00    	js     802945 <spawn+0x52c>
    for (size_t i = 0; i < elf->e_phnum; i++, ph++) {
  8028a4:	49 83 c7 01          	add    $0x1,%r15
  8028a8:	49 83 c6 38          	add    $0x38,%r14
  8028ac:	0f b7 85 08 fe ff ff 	movzwl -0x1f8(%rbp),%eax
  8028b3:	49 39 c7             	cmp    %rax,%r15
  8028b6:	0f 83 98 00 00 00    	jae    802954 <spawn+0x53b>
        if (ph->p_type != ELF_PROG_LOAD) continue;
  8028bc:	41 83 3e 01          	cmpl   $0x1,(%r14)
  8028c0:	75 e2                	jne    8028a4 <spawn+0x48b>
        if (ph->p_flags & ELF_PROG_FLAG_WRITE) perm |= PROT_W;
  8028c2:	41 8b 46 04          	mov    0x4(%r14),%eax
  8028c6:	89 c2                	mov    %eax,%edx
  8028c8:	83 e2 02             	and    $0x2,%edx
        if (ph->p_flags & ELF_PROG_FLAG_READ) perm |= PROT_R;
  8028cb:	89 d1                	mov    %edx,%ecx
  8028cd:	83 c9 04             	or     $0x4,%ecx
  8028d0:	a8 04                	test   $0x4,%al
  8028d2:	0f 45 d1             	cmovne %ecx,%edx
        if (ph->p_flags & ELF_PROG_FLAG_EXEC) perm |= PROT_X;
  8028d5:	83 e0 01             	and    $0x1,%eax
  8028d8:	09 d0                	or     %edx,%eax
  8028da:	89 85 f0 fc ff ff    	mov    %eax,-0x310(%rbp)
        if ((res = map_segment(child, ph->p_va, ph->p_memsz,
  8028e0:	49 8b 46 08          	mov    0x8(%r14),%rax
  8028e4:	89 85 e8 fc ff ff    	mov    %eax,-0x318(%rbp)
  8028ea:	49 8b 5e 20          	mov    0x20(%r14),%rbx
  8028ee:	4d 8b 6e 28          	mov    0x28(%r14),%r13
  8028f2:	4d 8b 66 10          	mov    0x10(%r14),%r12
  8028f6:	8b 8d cc fd ff ff    	mov    -0x234(%rbp),%ecx
  8028fc:	89 8d e0 fc ff ff    	mov    %ecx,-0x320(%rbp)
    if (res) {
  802902:	44 89 e2             	mov    %r12d,%edx
  802905:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  80290b:	74 14                	je     802921 <spawn+0x508>
        va -= res;
  80290d:	48 63 ca             	movslq %edx,%rcx
  802910:	49 29 cc             	sub    %rcx,%r12
        memsz += res;
  802913:	49 01 cd             	add    %rcx,%r13
        filesz += res;
  802916:	48 01 cb             	add    %rcx,%rbx
        fileoffset -= res;
  802919:	29 d0                	sub    %edx,%eax
  80291b:	89 85 e8 fc ff ff    	mov    %eax,-0x318(%rbp)
    if (filesz > HUGE_PAGE_SIZE) {
  802921:	48 81 fb 00 00 20 00 	cmp    $0x200000,%rbx
  802928:	0f 87 79 01 00 00    	ja     802aa7 <spawn+0x68e>
    if (filesz != 0) {
  80292e:	48 85 db             	test   %rbx,%rbx
  802931:	0f 85 78 fe ff ff    	jne    8027af <spawn+0x396>
    if (memsz > filesz) {
  802937:	4c 39 eb             	cmp    %r13,%rbx
  80293a:	0f 83 64 ff ff ff    	jae    8028a4 <spawn+0x48b>
  802940:	e9 2f ff ff ff       	jmp    802874 <spawn+0x45b>
        if (res < 0) {
  802945:	ba 00 00 00 00       	mov    $0x0,%edx
  80294a:	0f 4e d0             	cmovle %eax,%edx
  80294d:	89 d3                	mov    %edx,%ebx
  80294f:	e9 05 01 00 00       	jmp    802a59 <spawn+0x640>
    close(fd);
  802954:	8b bd fc fc ff ff    	mov    -0x304(%rbp),%edi
  80295a:	48 b8 25 1b 80 00 00 	movabs $0x801b25,%rax
  802961:	00 00 00 
  802964:	ff d0                	call   *%rax
    if ((res = foreach_shared_region(copy_shared_region, &child)) < 0)
  802966:	48 8d b5 cc fd ff ff 	lea    -0x234(%rbp),%rsi
  80296d:	48 bf c5 23 80 00 00 	movabs $0x8023c5,%rdi
  802974:	00 00 00 
  802977:	48 b8 7e 34 80 00 00 	movabs $0x80347e,%rax
  80297e:	00 00 00 
  802981:	ff d0                	call   *%rax
  802983:	85 c0                	test   %eax,%eax
  802985:	78 49                	js     8029d0 <spawn+0x5b7>
    if ((res = sys_env_set_trapframe(child, &child_tf)) < 0)
  802987:	48 8d b5 0c fd ff ff 	lea    -0x2f4(%rbp),%rsi
  80298e:	8b bd cc fd ff ff    	mov    -0x234(%rbp),%edi
  802994:	48 b8 6e 17 80 00 00 	movabs $0x80176e,%rax
  80299b:	00 00 00 
  80299e:	ff d0                	call   *%rax
  8029a0:	85 c0                	test   %eax,%eax
  8029a2:	78 59                	js     8029fd <spawn+0x5e4>
    if ((res = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  8029a4:	be 02 00 00 00       	mov    $0x2,%esi
  8029a9:	8b bd cc fd ff ff    	mov    -0x234(%rbp),%edi
  8029af:	48 b8 01 17 80 00 00 	movabs $0x801701,%rax
  8029b6:	00 00 00 
  8029b9:	ff d0                	call   *%rax
  8029bb:	85 c0                	test   %eax,%eax
  8029bd:	78 6b                	js     802a2a <spawn+0x611>
    return child;
  8029bf:	8b 85 cc fd ff ff    	mov    -0x234(%rbp),%eax
  8029c5:	89 85 fc fc ff ff    	mov    %eax,-0x304(%rbp)
  8029cb:	e9 b3 00 00 00       	jmp    802a83 <spawn+0x66a>
        panic("copy_shared_region: %i", res);
  8029d0:	89 c1                	mov    %eax,%ecx
  8029d2:	48 ba cb 42 80 00 00 	movabs $0x8042cb,%rdx
  8029d9:	00 00 00 
  8029dc:	be 84 00 00 00       	mov    $0x84,%esi
  8029e1:	48 bf bf 42 80 00 00 	movabs $0x8042bf,%rdi
  8029e8:	00 00 00 
  8029eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8029f0:	49 b8 ac 04 80 00 00 	movabs $0x8004ac,%r8
  8029f7:	00 00 00 
  8029fa:	41 ff d0             	call   *%r8
        panic("sys_env_set_trapframe: %i", res);
  8029fd:	89 c1                	mov    %eax,%ecx
  8029ff:	48 ba e2 42 80 00 00 	movabs $0x8042e2,%rdx
  802a06:	00 00 00 
  802a09:	be 87 00 00 00       	mov    $0x87,%esi
  802a0e:	48 bf bf 42 80 00 00 	movabs $0x8042bf,%rdi
  802a15:	00 00 00 
  802a18:	b8 00 00 00 00       	mov    $0x0,%eax
  802a1d:	49 b8 ac 04 80 00 00 	movabs $0x8004ac,%r8
  802a24:	00 00 00 
  802a27:	41 ff d0             	call   *%r8
        panic("sys_env_set_status: %i", res);
  802a2a:	89 c1                	mov    %eax,%ecx
  802a2c:	48 ba fc 42 80 00 00 	movabs $0x8042fc,%rdx
  802a33:	00 00 00 
  802a36:	be 8a 00 00 00       	mov    $0x8a,%esi
  802a3b:	48 bf bf 42 80 00 00 	movabs $0x8042bf,%rdi
  802a42:	00 00 00 
  802a45:	b8 00 00 00 00       	mov    $0x0,%eax
  802a4a:	49 b8 ac 04 80 00 00 	movabs $0x8004ac,%r8
  802a51:	00 00 00 
  802a54:	41 ff d0             	call   *%r8
  802a57:	89 c3                	mov    %eax,%ebx
    sys_env_destroy(child);
  802a59:	8b bd cc fd ff ff    	mov    -0x234(%rbp),%edi
  802a5f:	48 b8 17 14 80 00 00 	movabs $0x801417,%rax
  802a66:	00 00 00 
  802a69:	ff d0                	call   *%rax
    close(fd);
  802a6b:	8b bd fc fc ff ff    	mov    -0x304(%rbp),%edi
  802a71:	48 b8 25 1b 80 00 00 	movabs $0x801b25,%rax
  802a78:	00 00 00 
  802a7b:	ff d0                	call   *%rax
    return res;
  802a7d:	89 9d fc fc ff ff    	mov    %ebx,-0x304(%rbp)
}
  802a83:	8b 85 fc fc ff ff    	mov    -0x304(%rbp),%eax
  802a89:	48 81 c4 f8 02 00 00 	add    $0x2f8,%rsp
  802a90:	5b                   	pop    %rbx
  802a91:	41 5c                	pop    %r12
  802a93:	41 5d                	pop    %r13
  802a95:	41 5e                	pop    %r14
  802a97:	41 5f                	pop    %r15
  802a99:	5d                   	pop    %rbp
  802a9a:	c3                   	ret
  802a9b:	89 c3                	mov    %eax,%ebx
  802a9d:	eb ba                	jmp    802a59 <spawn+0x640>
  802a9f:	89 c3                	mov    %eax,%ebx
  802aa1:	eb b6                	jmp    802a59 <spawn+0x640>
  802aa3:	89 c3                	mov    %eax,%ebx
  802aa5:	eb b2                	jmp    802a59 <spawn+0x640>
        return -E_INVAL;
  802aa7:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
  802aac:	eb ab                	jmp    802a59 <spawn+0x640>
    if ((void *)(argv_store - 2) < (void *)UTEMP) return -E_NO_MEM;
  802aae:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
    if ((res = init_stack(child, argv, &child_tf)) < 0) goto error;
  802ab3:	89 c3                	mov    %eax,%ebx
  802ab5:	eb a2                	jmp    802a59 <spawn+0x640>
    if ((res = sys_alloc_region(0, UTEMP, USER_STACK_SIZE, PROT_RW)) < 0) return res;
  802ab7:	b9 06 00 00 00       	mov    $0x6,%ecx
  802abc:	ba 00 00 01 00       	mov    $0x10000,%edx
  802ac1:	be 00 00 40 00       	mov    $0x400000,%esi
  802ac6:	bf 00 00 00 00       	mov    $0x0,%edi
  802acb:	48 b8 56 15 80 00 00 	movabs $0x801556,%rax
  802ad2:	00 00 00 
  802ad5:	ff d0                	call   *%rax
  802ad7:	85 c0                	test   %eax,%eax
  802ad9:	78 d8                	js     802ab3 <spawn+0x69a>
    for (argc = 0; argv[argc] != 0; argc++)
  802adb:	48 c7 85 e8 fc ff ff 	movq   $0x0,-0x318(%rbp)
  802ae2:	00 00 00 00 
    argv_store = (uintptr_t *)(ROUNDDOWN(string_store, sizeof(uintptr_t)) - sizeof(uintptr_t) * (argc + 1));
  802ae6:	48 c7 85 f0 fc ff ff 	movq   $0x40fff8,-0x310(%rbp)
  802aed:	f8 ff 40 00 
  802af1:	48 c7 85 e0 fc ff ff 	movq   $0x410000,-0x320(%rbp)
  802af8:	00 00 41 00 
    string_store = (char *)UTEMP + USER_STACK_SIZE - string_size;
  802afc:	bb 00 00 41 00       	mov    $0x410000,%ebx
  802b01:	e9 28 fb ff ff       	jmp    80262e <spawn+0x215>

0000000000802b06 <spawnl>:
spawnl(const char *prog, const char *arg0, ...) {
  802b06:	f3 0f 1e fa          	endbr64
  802b0a:	55                   	push   %rbp
  802b0b:	48 89 e5             	mov    %rsp,%rbp
  802b0e:	48 83 ec 50          	sub    $0x50,%rsp
  802b12:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  802b16:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802b1a:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  802b1e:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(vl, arg0);
  802b22:	c7 45 b8 10 00 00 00 	movl   $0x10,-0x48(%rbp)
  802b29:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802b2d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802b31:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802b35:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int argc = 0;
  802b39:	b9 00 00 00 00       	mov    $0x0,%ecx
    while (va_arg(vl, void *) != NULL) argc++;
  802b3e:	eb 15                	jmp    802b55 <spawnl+0x4f>
  802b40:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802b44:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802b48:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802b4c:	48 83 3a 00          	cmpq   $0x0,(%rdx)
  802b50:	74 1c                	je     802b6e <spawnl+0x68>
  802b52:	83 c1 01             	add    $0x1,%ecx
  802b55:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802b58:	83 f8 2f             	cmp    $0x2f,%eax
  802b5b:	77 e3                	ja     802b40 <spawnl+0x3a>
  802b5d:	89 c2                	mov    %eax,%edx
  802b5f:	4c 8d 55 d0          	lea    -0x30(%rbp),%r10
  802b63:	4c 01 d2             	add    %r10,%rdx
  802b66:	83 c0 08             	add    $0x8,%eax
  802b69:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802b6c:	eb de                	jmp    802b4c <spawnl+0x46>
    const char *argv[argc + 2];
  802b6e:	8d 41 02             	lea    0x2(%rcx),%eax
  802b71:	48 98                	cltq
  802b73:	48 8d 04 c5 0f 00 00 	lea    0xf(,%rax,8),%rax
  802b7a:	00 
  802b7b:	49 89 c0             	mov    %rax,%r8
  802b7e:	49 83 e0 f0          	and    $0xfffffffffffffff0,%r8
  802b82:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802b88:	48 89 e2             	mov    %rsp,%rdx
  802b8b:	48 29 c2             	sub    %rax,%rdx
  802b8e:	48 39 d4             	cmp    %rdx,%rsp
  802b91:	74 12                	je     802ba5 <spawnl+0x9f>
  802b93:	48 81 ec 00 10 00 00 	sub    $0x1000,%rsp
  802b9a:	48 83 8c 24 f8 0f 00 	orq    $0x0,0xff8(%rsp)
  802ba1:	00 00 
  802ba3:	eb e9                	jmp    802b8e <spawnl+0x88>
  802ba5:	4c 89 c0             	mov    %r8,%rax
  802ba8:	25 ff 0f 00 00       	and    $0xfff,%eax
  802bad:	48 29 c4             	sub    %rax,%rsp
  802bb0:	48 85 c0             	test   %rax,%rax
  802bb3:	74 06                	je     802bbb <spawnl+0xb5>
  802bb5:	48 83 4c 04 f8 00    	orq    $0x0,-0x8(%rsp,%rax,1)
  802bbb:	4c 8d 4c 24 07       	lea    0x7(%rsp),%r9
  802bc0:	4c 89 c8             	mov    %r9,%rax
  802bc3:	48 c1 e8 03          	shr    $0x3,%rax
  802bc7:	49 83 e1 f8          	and    $0xfffffffffffffff8,%r9
    argv[0] = arg0;
  802bcb:	48 89 34 c5 00 00 00 	mov    %rsi,0x0(,%rax,8)
  802bd2:	00 
    argv[argc + 1] = NULL;
  802bd3:	8d 41 01             	lea    0x1(%rcx),%eax
  802bd6:	48 98                	cltq
  802bd8:	49 c7 04 c1 00 00 00 	movq   $0x0,(%r9,%rax,8)
  802bdf:	00 
    va_start(vl, arg0);
  802be0:	c7 45 b8 10 00 00 00 	movl   $0x10,-0x48(%rbp)
  802be7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802beb:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802bef:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802bf3:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    for (i = 0; i < argc; i++) {
  802bf7:	85 c9                	test   %ecx,%ecx
  802bf9:	74 41                	je     802c3c <spawnl+0x136>
        argv[i + 1] = va_arg(vl, const char *);
  802bfb:	49 89 c0             	mov    %rax,%r8
  802bfe:	49 8d 41 08          	lea    0x8(%r9),%rax
  802c02:	8d 51 ff             	lea    -0x1(%rcx),%edx
  802c05:	49 8d 74 d1 10       	lea    0x10(%r9,%rdx,8),%rsi
  802c0a:	eb 1b                	jmp    802c27 <spawnl+0x121>
  802c0c:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  802c10:	48 8d 51 08          	lea    0x8(%rcx),%rdx
  802c14:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802c18:	48 8b 11             	mov    (%rcx),%rdx
  802c1b:	48 89 10             	mov    %rdx,(%rax)
    for (i = 0; i < argc; i++) {
  802c1e:	48 83 c0 08          	add    $0x8,%rax
  802c22:	48 39 f0             	cmp    %rsi,%rax
  802c25:	74 15                	je     802c3c <spawnl+0x136>
        argv[i + 1] = va_arg(vl, const char *);
  802c27:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802c2a:	83 fa 2f             	cmp    $0x2f,%edx
  802c2d:	77 dd                	ja     802c0c <spawnl+0x106>
  802c2f:	89 d1                	mov    %edx,%ecx
  802c31:	4c 01 c1             	add    %r8,%rcx
  802c34:	83 c2 08             	add    $0x8,%edx
  802c37:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802c3a:	eb dc                	jmp    802c18 <spawnl+0x112>
    return spawn(prog, argv);
  802c3c:	4c 89 ce             	mov    %r9,%rsi
  802c3f:	48 b8 19 24 80 00 00 	movabs $0x802419,%rax
  802c46:	00 00 00 
  802c49:	ff d0                	call   *%rax
}
  802c4b:	c9                   	leave
  802c4c:	c3                   	ret

0000000000802c4d <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  802c4d:	f3 0f 1e fa          	endbr64
  802c51:	55                   	push   %rbp
  802c52:	48 89 e5             	mov    %rsp,%rbp
  802c55:	41 54                	push   %r12
  802c57:	53                   	push   %rbx
  802c58:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802c5b:	48 b8 30 19 80 00 00 	movabs $0x801930,%rax
  802c62:	00 00 00 
  802c65:	ff d0                	call   *%rax
  802c67:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  802c6a:	48 be 13 43 80 00 00 	movabs $0x804313,%rsi
  802c71:	00 00 00 
  802c74:	48 89 df             	mov    %rbx,%rdi
  802c77:	48 b8 51 0f 80 00 00 	movabs $0x800f51,%rax
  802c7e:	00 00 00 
  802c81:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  802c83:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  802c88:	41 2b 04 24          	sub    (%r12),%eax
  802c8c:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  802c92:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  802c99:	00 00 00 
    stat->st_dev = &devpipe;
  802c9c:	48 b8 80 50 80 00 00 	movabs $0x805080,%rax
  802ca3:	00 00 00 
  802ca6:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  802cad:	b8 00 00 00 00       	mov    $0x0,%eax
  802cb2:	5b                   	pop    %rbx
  802cb3:	41 5c                	pop    %r12
  802cb5:	5d                   	pop    %rbp
  802cb6:	c3                   	ret

0000000000802cb7 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  802cb7:	f3 0f 1e fa          	endbr64
  802cbb:	55                   	push   %rbp
  802cbc:	48 89 e5             	mov    %rsp,%rbp
  802cbf:	41 54                	push   %r12
  802cc1:	53                   	push   %rbx
  802cc2:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  802cc5:	ba 00 10 00 00       	mov    $0x1000,%edx
  802cca:	48 89 fe             	mov    %rdi,%rsi
  802ccd:	bf 00 00 00 00       	mov    $0x0,%edi
  802cd2:	49 bc 96 16 80 00 00 	movabs $0x801696,%r12
  802cd9:	00 00 00 
  802cdc:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  802cdf:	48 89 df             	mov    %rbx,%rdi
  802ce2:	48 b8 30 19 80 00 00 	movabs $0x801930,%rax
  802ce9:	00 00 00 
  802cec:	ff d0                	call   *%rax
  802cee:	48 89 c6             	mov    %rax,%rsi
  802cf1:	ba 00 10 00 00       	mov    $0x1000,%edx
  802cf6:	bf 00 00 00 00       	mov    $0x0,%edi
  802cfb:	41 ff d4             	call   *%r12
}
  802cfe:	5b                   	pop    %rbx
  802cff:	41 5c                	pop    %r12
  802d01:	5d                   	pop    %rbp
  802d02:	c3                   	ret

0000000000802d03 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  802d03:	f3 0f 1e fa          	endbr64
  802d07:	55                   	push   %rbp
  802d08:	48 89 e5             	mov    %rsp,%rbp
  802d0b:	41 57                	push   %r15
  802d0d:	41 56                	push   %r14
  802d0f:	41 55                	push   %r13
  802d11:	41 54                	push   %r12
  802d13:	53                   	push   %rbx
  802d14:	48 83 ec 18          	sub    $0x18,%rsp
  802d18:	49 89 fc             	mov    %rdi,%r12
  802d1b:	49 89 f5             	mov    %rsi,%r13
  802d1e:	49 89 d7             	mov    %rdx,%r15
  802d21:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802d25:	48 b8 30 19 80 00 00 	movabs $0x801930,%rax
  802d2c:	00 00 00 
  802d2f:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  802d31:	4d 85 ff             	test   %r15,%r15
  802d34:	0f 84 af 00 00 00    	je     802de9 <devpipe_write+0xe6>
  802d3a:	48 89 c3             	mov    %rax,%rbx
  802d3d:	4c 89 f8             	mov    %r15,%rax
  802d40:	4d 89 ef             	mov    %r13,%r15
  802d43:	4c 01 e8             	add    %r13,%rax
  802d46:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802d4a:	49 bd 26 15 80 00 00 	movabs $0x801526,%r13
  802d51:	00 00 00 
            sys_yield();
  802d54:	49 be bb 14 80 00 00 	movabs $0x8014bb,%r14
  802d5b:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  802d5e:	8b 73 04             	mov    0x4(%rbx),%esi
  802d61:	48 63 ce             	movslq %esi,%rcx
  802d64:	48 63 03             	movslq (%rbx),%rax
  802d67:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  802d6d:	48 39 c1             	cmp    %rax,%rcx
  802d70:	72 2e                	jb     802da0 <devpipe_write+0x9d>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802d72:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802d77:	48 89 da             	mov    %rbx,%rdx
  802d7a:	be 00 10 00 00       	mov    $0x1000,%esi
  802d7f:	4c 89 e7             	mov    %r12,%rdi
  802d82:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802d85:	85 c0                	test   %eax,%eax
  802d87:	74 66                	je     802def <devpipe_write+0xec>
            sys_yield();
  802d89:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  802d8c:	8b 73 04             	mov    0x4(%rbx),%esi
  802d8f:	48 63 ce             	movslq %esi,%rcx
  802d92:	48 63 03             	movslq (%rbx),%rax
  802d95:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  802d9b:	48 39 c1             	cmp    %rax,%rcx
  802d9e:	73 d2                	jae    802d72 <devpipe_write+0x6f>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802da0:	41 0f b6 3f          	movzbl (%r15),%edi
  802da4:	48 89 ca             	mov    %rcx,%rdx
  802da7:	48 c1 ea 03          	shr    $0x3,%rdx
  802dab:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  802db2:	08 10 20 
  802db5:	48 f7 e2             	mul    %rdx
  802db8:	48 c1 ea 06          	shr    $0x6,%rdx
  802dbc:	48 89 d0             	mov    %rdx,%rax
  802dbf:	48 c1 e0 09          	shl    $0x9,%rax
  802dc3:	48 29 d0             	sub    %rdx,%rax
  802dc6:	48 c1 e0 03          	shl    $0x3,%rax
  802dca:	48 29 c1             	sub    %rax,%rcx
  802dcd:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  802dd2:	83 c6 01             	add    $0x1,%esi
  802dd5:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  802dd8:	49 83 c7 01          	add    $0x1,%r15
  802ddc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802de0:	49 39 c7             	cmp    %rax,%r15
  802de3:	0f 85 75 ff ff ff    	jne    802d5e <devpipe_write+0x5b>
    return n;
  802de9:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802ded:	eb 05                	jmp    802df4 <devpipe_write+0xf1>
            if (_pipeisclosed(fd, p)) return 0;
  802def:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802df4:	48 83 c4 18          	add    $0x18,%rsp
  802df8:	5b                   	pop    %rbx
  802df9:	41 5c                	pop    %r12
  802dfb:	41 5d                	pop    %r13
  802dfd:	41 5e                	pop    %r14
  802dff:	41 5f                	pop    %r15
  802e01:	5d                   	pop    %rbp
  802e02:	c3                   	ret

0000000000802e03 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  802e03:	f3 0f 1e fa          	endbr64
  802e07:	55                   	push   %rbp
  802e08:	48 89 e5             	mov    %rsp,%rbp
  802e0b:	41 57                	push   %r15
  802e0d:	41 56                	push   %r14
  802e0f:	41 55                	push   %r13
  802e11:	41 54                	push   %r12
  802e13:	53                   	push   %rbx
  802e14:	48 83 ec 18          	sub    $0x18,%rsp
  802e18:	49 89 fc             	mov    %rdi,%r12
  802e1b:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  802e1f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802e23:	48 b8 30 19 80 00 00 	movabs $0x801930,%rax
  802e2a:	00 00 00 
  802e2d:	ff d0                	call   *%rax
  802e2f:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  802e32:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802e38:	49 bd 26 15 80 00 00 	movabs $0x801526,%r13
  802e3f:	00 00 00 
            sys_yield();
  802e42:	49 be bb 14 80 00 00 	movabs $0x8014bb,%r14
  802e49:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  802e4c:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  802e51:	74 7d                	je     802ed0 <devpipe_read+0xcd>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802e53:	8b 03                	mov    (%rbx),%eax
  802e55:	3b 43 04             	cmp    0x4(%rbx),%eax
  802e58:	75 26                	jne    802e80 <devpipe_read+0x7d>
            if (i > 0) return i;
  802e5a:	4d 85 ff             	test   %r15,%r15
  802e5d:	75 77                	jne    802ed6 <devpipe_read+0xd3>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802e5f:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802e64:	48 89 da             	mov    %rbx,%rdx
  802e67:	be 00 10 00 00       	mov    $0x1000,%esi
  802e6c:	4c 89 e7             	mov    %r12,%rdi
  802e6f:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802e72:	85 c0                	test   %eax,%eax
  802e74:	74 72                	je     802ee8 <devpipe_read+0xe5>
            sys_yield();
  802e76:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802e79:	8b 03                	mov    (%rbx),%eax
  802e7b:	3b 43 04             	cmp    0x4(%rbx),%eax
  802e7e:	74 df                	je     802e5f <devpipe_read+0x5c>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802e80:	48 63 c8             	movslq %eax,%rcx
  802e83:	48 89 ca             	mov    %rcx,%rdx
  802e86:	48 c1 ea 03          	shr    $0x3,%rdx
  802e8a:	48 be 81 00 01 02 04 	movabs $0x2010080402010081,%rsi
  802e91:	08 10 20 
  802e94:	48 89 d0             	mov    %rdx,%rax
  802e97:	48 f7 e6             	mul    %rsi
  802e9a:	48 c1 ea 06          	shr    $0x6,%rdx
  802e9e:	48 89 d0             	mov    %rdx,%rax
  802ea1:	48 c1 e0 09          	shl    $0x9,%rax
  802ea5:	48 29 d0             	sub    %rdx,%rax
  802ea8:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802eaf:	00 
  802eb0:	48 89 c8             	mov    %rcx,%rax
  802eb3:	48 29 d0             	sub    %rdx,%rax
  802eb6:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  802ebb:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  802ebf:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  802ec3:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  802ec6:	49 83 c7 01          	add    $0x1,%r15
  802eca:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  802ece:	75 83                	jne    802e53 <devpipe_read+0x50>
    return n;
  802ed0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802ed4:	eb 03                	jmp    802ed9 <devpipe_read+0xd6>
            if (i > 0) return i;
  802ed6:	4c 89 f8             	mov    %r15,%rax
}
  802ed9:	48 83 c4 18          	add    $0x18,%rsp
  802edd:	5b                   	pop    %rbx
  802ede:	41 5c                	pop    %r12
  802ee0:	41 5d                	pop    %r13
  802ee2:	41 5e                	pop    %r14
  802ee4:	41 5f                	pop    %r15
  802ee6:	5d                   	pop    %rbp
  802ee7:	c3                   	ret
            if (_pipeisclosed(fd, p)) return 0;
  802ee8:	b8 00 00 00 00       	mov    $0x0,%eax
  802eed:	eb ea                	jmp    802ed9 <devpipe_read+0xd6>

0000000000802eef <pipe>:
pipe(int pfd[2]) {
  802eef:	f3 0f 1e fa          	endbr64
  802ef3:	55                   	push   %rbp
  802ef4:	48 89 e5             	mov    %rsp,%rbp
  802ef7:	41 55                	push   %r13
  802ef9:	41 54                	push   %r12
  802efb:	53                   	push   %rbx
  802efc:	48 83 ec 18          	sub    $0x18,%rsp
  802f00:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  802f03:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802f07:	48 b8 50 19 80 00 00 	movabs $0x801950,%rax
  802f0e:	00 00 00 
  802f11:	ff d0                	call   *%rax
  802f13:	89 c3                	mov    %eax,%ebx
  802f15:	85 c0                	test   %eax,%eax
  802f17:	0f 88 a0 01 00 00    	js     8030bd <pipe+0x1ce>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  802f1d:	b9 46 00 00 00       	mov    $0x46,%ecx
  802f22:	ba 00 10 00 00       	mov    $0x1000,%edx
  802f27:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802f2b:	bf 00 00 00 00       	mov    $0x0,%edi
  802f30:	48 b8 56 15 80 00 00 	movabs $0x801556,%rax
  802f37:	00 00 00 
  802f3a:	ff d0                	call   *%rax
  802f3c:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  802f3e:	85 c0                	test   %eax,%eax
  802f40:	0f 88 77 01 00 00    	js     8030bd <pipe+0x1ce>
    if ((res = fd_alloc(&fd1)) < 0 ||
  802f46:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  802f4a:	48 b8 50 19 80 00 00 	movabs $0x801950,%rax
  802f51:	00 00 00 
  802f54:	ff d0                	call   *%rax
  802f56:	89 c3                	mov    %eax,%ebx
  802f58:	85 c0                	test   %eax,%eax
  802f5a:	0f 88 43 01 00 00    	js     8030a3 <pipe+0x1b4>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  802f60:	b9 46 00 00 00       	mov    $0x46,%ecx
  802f65:	ba 00 10 00 00       	mov    $0x1000,%edx
  802f6a:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802f6e:	bf 00 00 00 00       	mov    $0x0,%edi
  802f73:	48 b8 56 15 80 00 00 	movabs $0x801556,%rax
  802f7a:	00 00 00 
  802f7d:	ff d0                	call   *%rax
  802f7f:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  802f81:	85 c0                	test   %eax,%eax
  802f83:	0f 88 1a 01 00 00    	js     8030a3 <pipe+0x1b4>
    va = fd2data(fd0);
  802f89:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802f8d:	48 b8 30 19 80 00 00 	movabs $0x801930,%rax
  802f94:	00 00 00 
  802f97:	ff d0                	call   *%rax
  802f99:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  802f9c:	b9 46 00 00 00       	mov    $0x46,%ecx
  802fa1:	ba 00 10 00 00       	mov    $0x1000,%edx
  802fa6:	48 89 c6             	mov    %rax,%rsi
  802fa9:	bf 00 00 00 00       	mov    $0x0,%edi
  802fae:	48 b8 56 15 80 00 00 	movabs $0x801556,%rax
  802fb5:	00 00 00 
  802fb8:	ff d0                	call   *%rax
  802fba:	89 c3                	mov    %eax,%ebx
  802fbc:	85 c0                	test   %eax,%eax
  802fbe:	0f 88 c5 00 00 00    	js     803089 <pipe+0x19a>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  802fc4:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802fc8:	48 b8 30 19 80 00 00 	movabs $0x801930,%rax
  802fcf:	00 00 00 
  802fd2:	ff d0                	call   *%rax
  802fd4:	48 89 c1             	mov    %rax,%rcx
  802fd7:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  802fdd:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  802fe3:	ba 00 00 00 00       	mov    $0x0,%edx
  802fe8:	4c 89 ee             	mov    %r13,%rsi
  802feb:	bf 00 00 00 00       	mov    $0x0,%edi
  802ff0:	48 b8 c1 15 80 00 00 	movabs $0x8015c1,%rax
  802ff7:	00 00 00 
  802ffa:	ff d0                	call   *%rax
  802ffc:	89 c3                	mov    %eax,%ebx
  802ffe:	85 c0                	test   %eax,%eax
  803000:	78 6e                	js     803070 <pipe+0x181>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  803002:	be 00 10 00 00       	mov    $0x1000,%esi
  803007:	4c 89 ef             	mov    %r13,%rdi
  80300a:	48 b8 f0 14 80 00 00 	movabs $0x8014f0,%rax
  803011:	00 00 00 
  803014:	ff d0                	call   *%rax
  803016:	83 f8 02             	cmp    $0x2,%eax
  803019:	0f 85 ab 00 00 00    	jne    8030ca <pipe+0x1db>
    fd0->fd_dev_id = devpipe.dev_id;
  80301f:	a1 80 50 80 00 00 00 	movabs 0x805080,%eax
  803026:	00 00 
  803028:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80302c:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  80302e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803032:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  803039:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80303d:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  80303f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803043:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  80304a:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80304e:	48 bb 1a 19 80 00 00 	movabs $0x80191a,%rbx
  803055:	00 00 00 
  803058:	ff d3                	call   *%rbx
  80305a:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  80305e:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  803062:	ff d3                	call   *%rbx
  803064:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  803069:	bb 00 00 00 00       	mov    $0x0,%ebx
  80306e:	eb 4d                	jmp    8030bd <pipe+0x1ce>
    sys_unmap_region(0, va, PAGE_SIZE);
  803070:	ba 00 10 00 00       	mov    $0x1000,%edx
  803075:	4c 89 ee             	mov    %r13,%rsi
  803078:	bf 00 00 00 00       	mov    $0x0,%edi
  80307d:	48 b8 96 16 80 00 00 	movabs $0x801696,%rax
  803084:	00 00 00 
  803087:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  803089:	ba 00 10 00 00       	mov    $0x1000,%edx
  80308e:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  803092:	bf 00 00 00 00       	mov    $0x0,%edi
  803097:	48 b8 96 16 80 00 00 	movabs $0x801696,%rax
  80309e:	00 00 00 
  8030a1:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  8030a3:	ba 00 10 00 00       	mov    $0x1000,%edx
  8030a8:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8030ac:	bf 00 00 00 00       	mov    $0x0,%edi
  8030b1:	48 b8 96 16 80 00 00 	movabs $0x801696,%rax
  8030b8:	00 00 00 
  8030bb:	ff d0                	call   *%rax
}
  8030bd:	89 d8                	mov    %ebx,%eax
  8030bf:	48 83 c4 18          	add    $0x18,%rsp
  8030c3:	5b                   	pop    %rbx
  8030c4:	41 5c                	pop    %r12
  8030c6:	41 5d                	pop    %r13
  8030c8:	5d                   	pop    %rbp
  8030c9:	c3                   	ret
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8030ca:	48 b9 70 44 80 00 00 	movabs $0x804470,%rcx
  8030d1:	00 00 00 
  8030d4:	48 ba 85 42 80 00 00 	movabs $0x804285,%rdx
  8030db:	00 00 00 
  8030de:	be 2e 00 00 00       	mov    $0x2e,%esi
  8030e3:	48 bf 1a 43 80 00 00 	movabs $0x80431a,%rdi
  8030ea:	00 00 00 
  8030ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8030f2:	49 b8 ac 04 80 00 00 	movabs $0x8004ac,%r8
  8030f9:	00 00 00 
  8030fc:	41 ff d0             	call   *%r8

00000000008030ff <pipeisclosed>:
pipeisclosed(int fdnum) {
  8030ff:	f3 0f 1e fa          	endbr64
  803103:	55                   	push   %rbp
  803104:	48 89 e5             	mov    %rsp,%rbp
  803107:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  80310b:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  80310f:	48 b8 b4 19 80 00 00 	movabs $0x8019b4,%rax
  803116:	00 00 00 
  803119:	ff d0                	call   *%rax
    if (res < 0) return res;
  80311b:	85 c0                	test   %eax,%eax
  80311d:	78 35                	js     803154 <pipeisclosed+0x55>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  80311f:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  803123:	48 b8 30 19 80 00 00 	movabs $0x801930,%rax
  80312a:	00 00 00 
  80312d:	ff d0                	call   *%rax
  80312f:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  803132:	b9 00 10 00 00       	mov    $0x1000,%ecx
  803137:	be 00 10 00 00       	mov    $0x1000,%esi
  80313c:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  803140:	48 b8 26 15 80 00 00 	movabs $0x801526,%rax
  803147:	00 00 00 
  80314a:	ff d0                	call   *%rax
  80314c:	85 c0                	test   %eax,%eax
  80314e:	0f 94 c0             	sete   %al
  803151:	0f b6 c0             	movzbl %al,%eax
}
  803154:	c9                   	leave
  803155:	c3                   	ret

0000000000803156 <wait>:
#include <inc/lib.h>

/* Waits until 'envid' exits. */
void
wait(envid_t envid) {
  803156:	f3 0f 1e fa          	endbr64
  80315a:	55                   	push   %rbp
  80315b:	48 89 e5             	mov    %rsp,%rbp
  80315e:	41 55                	push   %r13
  803160:	41 54                	push   %r12
  803162:	53                   	push   %rbx
  803163:	48 83 ec 08          	sub    $0x8,%rsp
    assert(envid != 0);
  803167:	85 ff                	test   %edi,%edi
  803169:	74 7d                	je     8031e8 <wait+0x92>
  80316b:	41 89 fc             	mov    %edi,%r12d

    const volatile struct Env *env = &envs[ENVX(envid)];
  80316e:	89 f8                	mov    %edi,%eax
  803170:	25 ff 03 00 00       	and    $0x3ff,%eax

    while (env->env_id == envid &&
  803175:	89 fa                	mov    %edi,%edx
  803177:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  80317d:	48 8d 0c d2          	lea    (%rdx,%rdx,8),%rcx
  803181:	48 8d 0c 4a          	lea    (%rdx,%rcx,2),%rcx
  803185:	48 c1 e1 04          	shl    $0x4,%rcx
  803189:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  803190:	00 00 00 
  803193:	48 01 ca             	add    %rcx,%rdx
  803196:	8b 92 c8 00 00 00    	mov    0xc8(%rdx),%edx
  80319c:	39 d7                	cmp    %edx,%edi
  80319e:	75 3d                	jne    8031dd <wait+0x87>
           env->env_status != ENV_FREE) {
  8031a0:	48 98                	cltq
  8031a2:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8031a6:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8031aa:	48 c1 e0 04          	shl    $0x4,%rax
  8031ae:	48 bb 00 00 a0 1f 80 	movabs $0x801fa00000,%rbx
  8031b5:	00 00 00 
  8031b8:	48 01 c3             	add    %rax,%rbx
        sys_yield();
  8031bb:	49 bd bb 14 80 00 00 	movabs $0x8014bb,%r13
  8031c2:	00 00 00 
           env->env_status != ENV_FREE) {
  8031c5:	8b 83 d4 00 00 00    	mov    0xd4(%rbx),%eax
    while (env->env_id == envid &&
  8031cb:	85 c0                	test   %eax,%eax
  8031cd:	74 0e                	je     8031dd <wait+0x87>
        sys_yield();
  8031cf:	41 ff d5             	call   *%r13
    while (env->env_id == envid &&
  8031d2:	8b 83 c8 00 00 00    	mov    0xc8(%rbx),%eax
  8031d8:	44 39 e0             	cmp    %r12d,%eax
  8031db:	74 e8                	je     8031c5 <wait+0x6f>
    }
}
  8031dd:	48 83 c4 08          	add    $0x8,%rsp
  8031e1:	5b                   	pop    %rbx
  8031e2:	41 5c                	pop    %r12
  8031e4:	41 5d                	pop    %r13
  8031e6:	5d                   	pop    %rbp
  8031e7:	c3                   	ret
    assert(envid != 0);
  8031e8:	48 b9 2a 43 80 00 00 	movabs $0x80432a,%rcx
  8031ef:	00 00 00 
  8031f2:	48 ba 85 42 80 00 00 	movabs $0x804285,%rdx
  8031f9:	00 00 00 
  8031fc:	be 06 00 00 00       	mov    $0x6,%esi
  803201:	48 bf 35 43 80 00 00 	movabs $0x804335,%rdi
  803208:	00 00 00 
  80320b:	b8 00 00 00 00       	mov    $0x0,%eax
  803210:	49 b8 ac 04 80 00 00 	movabs $0x8004ac,%r8
  803217:	00 00 00 
  80321a:	41 ff d0             	call   *%r8

000000000080321d <get_uvpt_entry>:
extern volatile pde_t uvpd[];     /* VA of current page directory */
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
  80321d:	f3 0f 1e fa          	endbr64
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  803221:	48 89 f8             	mov    %rdi,%rax
  803224:	48 c1 e8 27          	shr    $0x27,%rax
  803228:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  80322f:	7f 00 00 
  803232:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  803236:	f6 c2 01             	test   $0x1,%dl
  803239:	74 6d                	je     8032a8 <get_uvpt_entry+0x8b>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  80323b:	48 89 f8             	mov    %rdi,%rax
  80323e:	48 c1 e8 1e          	shr    $0x1e,%rax
  803242:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  803249:	7f 00 00 
  80324c:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  803250:	f6 c2 01             	test   $0x1,%dl
  803253:	74 62                	je     8032b7 <get_uvpt_entry+0x9a>
  803255:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  80325c:	7f 00 00 
  80325f:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  803263:	f6 c2 80             	test   $0x80,%dl
  803266:	75 4f                	jne    8032b7 <get_uvpt_entry+0x9a>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  803268:	48 89 f8             	mov    %rdi,%rax
  80326b:	48 c1 e8 15          	shr    $0x15,%rax
  80326f:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  803276:	7f 00 00 
  803279:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80327d:	f6 c2 01             	test   $0x1,%dl
  803280:	74 44                	je     8032c6 <get_uvpt_entry+0xa9>
  803282:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  803289:	7f 00 00 
  80328c:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  803290:	f6 c2 80             	test   $0x80,%dl
  803293:	75 31                	jne    8032c6 <get_uvpt_entry+0xa9>
    return uvpt[VPT(va)];
  803295:	48 c1 ef 0c          	shr    $0xc,%rdi
  803299:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  8032a0:	7f 00 00 
  8032a3:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  8032a7:	c3                   	ret
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8032a8:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  8032af:	7f 00 00 
  8032b2:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8032b6:	c3                   	ret
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8032b7:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  8032be:	7f 00 00 
  8032c1:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8032c5:	c3                   	ret
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8032c6:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  8032cd:	7f 00 00 
  8032d0:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8032d4:	c3                   	ret

00000000008032d5 <get_phys_addr>:

uintptr_t
get_phys_addr(void *va) {
  8032d5:	f3 0f 1e fa          	endbr64
  8032d9:	48 89 fa             	mov    %rdi,%rdx
    if (!(uvpml4[VPML4(va)] & PTE_P))
  8032dc:	48 89 f9             	mov    %rdi,%rcx
  8032df:	48 c1 e9 27          	shr    $0x27,%rcx
  8032e3:	48 b8 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rax
  8032ea:	7f 00 00 
  8032ed:	48 8b 0c c8          	mov    (%rax,%rcx,8),%rcx
        return -1;
  8032f1:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpml4[VPML4(va)] & PTE_P))
  8032f8:	f6 c1 01             	test   $0x1,%cl
  8032fb:	0f 84 b2 00 00 00    	je     8033b3 <get_phys_addr+0xde>
    if (!(uvpdp[VPDP(va)] & PTE_P))
  803301:	48 89 f9             	mov    %rdi,%rcx
  803304:	48 c1 e9 1e          	shr    $0x1e,%rcx
  803308:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  80330f:	7f 00 00 
  803312:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  803316:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpdp[VPDP(va)] & PTE_P))
  80331d:	40 f6 c6 01          	test   $0x1,%sil
  803321:	0f 84 8c 00 00 00    	je     8033b3 <get_phys_addr+0xde>
    if (uvpdp[VPDP(va)] & PTE_PS)
  803327:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  80332e:	7f 00 00 
  803331:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  803335:	a8 80                	test   $0x80,%al
  803337:	75 7b                	jne    8033b4 <get_phys_addr+0xdf>
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
    if (!(uvpd[VPD(va)] & PTE_P))
  803339:	48 89 f9             	mov    %rdi,%rcx
  80333c:	48 c1 e9 15          	shr    $0x15,%rcx
  803340:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  803347:	7f 00 00 
  80334a:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  80334e:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpd[VPD(va)] & PTE_P))
  803355:	40 f6 c6 01          	test   $0x1,%sil
  803359:	74 58                	je     8033b3 <get_phys_addr+0xde>
    if ((uvpd[VPD(va)] & PTE_PS))
  80335b:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  803362:	7f 00 00 
  803365:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  803369:	a8 80                	test   $0x80,%al
  80336b:	75 6c                	jne    8033d9 <get_phys_addr+0x104>
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
    if (!(uvpt[VPT(va)] & PTE_P))
  80336d:	48 89 f9             	mov    %rdi,%rcx
  803370:	48 c1 e9 0c          	shr    $0xc,%rcx
  803374:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  80337b:	7f 00 00 
  80337e:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  803382:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpt[VPT(va)] & PTE_P))
  803389:	40 f6 c6 01          	test   $0x1,%sil
  80338d:	74 24                	je     8033b3 <get_phys_addr+0xde>
    return PTE_ADDR(uvpt[VPT(va)]) + PAGE_OFFSET(va);
  80338f:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  803396:	7f 00 00 
  803399:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  80339d:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  8033a4:	ff ff 7f 
  8033a7:	48 21 c8             	and    %rcx,%rax
  8033aa:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  8033b0:	48 09 d0             	or     %rdx,%rax
}
  8033b3:	c3                   	ret
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
  8033b4:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  8033bb:	7f 00 00 
  8033be:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8033c2:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  8033c9:	ff ff 7f 
  8033cc:	48 21 c8             	and    %rcx,%rax
  8033cf:	81 e2 ff ff ff 3f    	and    $0x3fffffff,%edx
  8033d5:	48 01 d0             	add    %rdx,%rax
  8033d8:	c3                   	ret
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
  8033d9:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  8033e0:	7f 00 00 
  8033e3:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8033e7:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  8033ee:	ff ff 7f 
  8033f1:	48 21 c8             	and    %rcx,%rax
  8033f4:	81 e2 ff ff 1f 00    	and    $0x1fffff,%edx
  8033fa:	48 01 d0             	add    %rdx,%rax
  8033fd:	c3                   	ret

00000000008033fe <get_prot>:

int
get_prot(void *va) {
  8033fe:	f3 0f 1e fa          	endbr64
  803402:	55                   	push   %rbp
  803403:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  803406:	48 b8 1d 32 80 00 00 	movabs $0x80321d,%rax
  80340d:	00 00 00 
  803410:	ff d0                	call   *%rax
  803412:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
    if (pte & PTE_P) prot |= PROT_R;
  803415:	83 e0 01             	and    $0x1,%eax
  803418:	c1 e0 02             	shl    $0x2,%eax
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  80341b:	89 d1                	mov    %edx,%ecx
  80341d:	81 e1 00 0a 00 00    	and    $0xa00,%ecx
    if (pte & PTE_P) prot |= PROT_R;
  803423:	09 c8                	or     %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  803425:	89 c1                	mov    %eax,%ecx
  803427:	83 c9 02             	or     $0x2,%ecx
  80342a:	f6 c2 02             	test   $0x2,%dl
  80342d:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  803430:	89 c1                	mov    %eax,%ecx
  803432:	83 c9 01             	or     $0x1,%ecx
  803435:	48 85 d2             	test   %rdx,%rdx
  803438:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  80343b:	89 c1                	mov    %eax,%ecx
  80343d:	83 c9 40             	or     $0x40,%ecx
  803440:	f6 c6 04             	test   $0x4,%dh
  803443:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  803446:	5d                   	pop    %rbp
  803447:	c3                   	ret

0000000000803448 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  803448:	f3 0f 1e fa          	endbr64
  80344c:	55                   	push   %rbp
  80344d:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  803450:	48 b8 1d 32 80 00 00 	movabs $0x80321d,%rax
  803457:	00 00 00 
  80345a:	ff d0                	call   *%rax
    return pte & PTE_D;
  80345c:	48 c1 e8 06          	shr    $0x6,%rax
  803460:	83 e0 01             	and    $0x1,%eax
}
  803463:	5d                   	pop    %rbp
  803464:	c3                   	ret

0000000000803465 <is_page_present>:

bool
is_page_present(void *va) {
  803465:	f3 0f 1e fa          	endbr64
  803469:	55                   	push   %rbp
  80346a:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  80346d:	48 b8 1d 32 80 00 00 	movabs $0x80321d,%rax
  803474:	00 00 00 
  803477:	ff d0                	call   *%rax
  803479:	83 e0 01             	and    $0x1,%eax
}
  80347c:	5d                   	pop    %rbp
  80347d:	c3                   	ret

000000000080347e <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  80347e:	f3 0f 1e fa          	endbr64
  803482:	55                   	push   %rbp
  803483:	48 89 e5             	mov    %rsp,%rbp
  803486:	41 57                	push   %r15
  803488:	41 56                	push   %r14
  80348a:	41 55                	push   %r13
  80348c:	41 54                	push   %r12
  80348e:	53                   	push   %rbx
  80348f:	48 83 ec 18          	sub    $0x18,%rsp
  803493:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  803497:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
     * NOTE: Skip over larger pages/page directories for efficiency */
    // LAB 11: Your code here:

    int res = 0;
    (void)fun, (void)arg;
    uintptr_t va = 0;
  80349b:	bb 00 00 00 00       	mov    $0x0,%ebx
    while (va < USER_STACK_TOP) {
        size_t size = 0;
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  8034a0:	49 be 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%r14
  8034a7:	7f 00 00 
            size = 1LL << PML4_SHIFT;
            goto next;
        }

        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  8034aa:	49 bd 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%r13
  8034b1:	7f 00 00 
    while (va < USER_STACK_TOP) {
  8034b4:	49 bf ff 6f ff ff 7f 	movabs $0x7fffff6fff,%r15
  8034bb:	00 00 00 
  8034be:	eb 73                	jmp    803533 <foreach_shared_region+0xb5>
            }

            goto next;
        }

        if (!(uvpd[VPD(va)] & PTE_P)) {
  8034c0:	48 89 d8             	mov    %rbx,%rax
  8034c3:	48 c1 e8 15          	shr    $0x15,%rax
  8034c7:	48 b9 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rcx
  8034ce:	7f 00 00 
  8034d1:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
            size = 1LL << PD_SHIFT;
  8034d5:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
        if (!(uvpd[VPD(va)] & PTE_P)) {
  8034db:	f6 c2 01             	test   $0x1,%dl
  8034de:	74 4b                	je     80352b <foreach_shared_region+0xad>
            goto next;
        }

        if (uvpd[VPD(va)] & PTE_PS) {
  8034e0:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
  8034e4:	f6 c2 80             	test   $0x80,%dl
  8034e7:	74 11                	je     8034fa <foreach_shared_region+0x7c>
            size = 1LL << PD_SHIFT;
            if (uvpd[VPD(va)] & PTE_SHARE) {
  8034e9:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
  8034ed:	f6 c4 04             	test   $0x4,%ah
  8034f0:	74 39                	je     80352b <foreach_shared_region+0xad>
            size = 1LL << PD_SHIFT;
  8034f2:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
  8034f8:	eb 20                	jmp    80351a <foreach_shared_region+0x9c>

            goto next;
        }

        size = PAGE_SIZE;
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  8034fa:	48 89 da             	mov    %rbx,%rdx
  8034fd:	48 c1 ea 0c          	shr    $0xc,%rdx
  803501:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  803508:	7f 00 00 
  80350b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
        size = PAGE_SIZE;
  80350f:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  803515:	f6 c4 04             	test   $0x4,%ah
  803518:	74 11                	je     80352b <foreach_shared_region+0xad>
            goto next;
        }

    map:
        fun((void *)va, (void *)(va + size), arg);
  80351a:	49 8d 34 1c          	lea    (%r12,%rbx,1),%rsi
  80351e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803522:	48 89 df             	mov    %rbx,%rdi
  803525:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803529:	ff d0                	call   *%rax
    next:
        va += size;
  80352b:	4c 01 e3             	add    %r12,%rbx
    while (va < USER_STACK_TOP) {
  80352e:	49 39 df             	cmp    %rbx,%r15
  803531:	72 3e                	jb     803571 <foreach_shared_region+0xf3>
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  803533:	49 8b 06             	mov    (%r14),%rax
  803536:	a8 01                	test   $0x1,%al
  803538:	74 37                	je     803571 <foreach_shared_region+0xf3>
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  80353a:	48 89 d8             	mov    %rbx,%rax
  80353d:	48 c1 e8 1e          	shr    $0x1e,%rax
  803541:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
            size = 1LL << PDP_SHIFT;
  803546:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  80354c:	f6 c2 01             	test   $0x1,%dl
  80354f:	74 da                	je     80352b <foreach_shared_region+0xad>
        if (uvpdp[VPDP(va)] & PTE_PS) {
  803551:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
  803556:	f6 c2 80             	test   $0x80,%dl
  803559:	0f 84 61 ff ff ff    	je     8034c0 <foreach_shared_region+0x42>
            if (uvpdp[VPDP(va)] & PTE_SHARE) {
  80355f:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  803564:	f6 c4 04             	test   $0x4,%ah
  803567:	74 c2                	je     80352b <foreach_shared_region+0xad>
            size = 1LL << PDP_SHIFT;
  803569:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
  80356f:	eb a9                	jmp    80351a <foreach_shared_region+0x9c>
    }
    return res;
}
  803571:	b8 00 00 00 00       	mov    $0x0,%eax
  803576:	48 83 c4 18          	add    $0x18,%rsp
  80357a:	5b                   	pop    %rbx
  80357b:	41 5c                	pop    %r12
  80357d:	41 5d                	pop    %r13
  80357f:	41 5e                	pop    %r14
  803581:	41 5f                	pop    %r15
  803583:	5d                   	pop    %rbp
  803584:	c3                   	ret

0000000000803585 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  803585:	f3 0f 1e fa          	endbr64
  803589:	55                   	push   %rbp
  80358a:	48 89 e5             	mov    %rsp,%rbp
  80358d:	41 54                	push   %r12
  80358f:	53                   	push   %rbx
  803590:	48 89 fb             	mov    %rdi,%rbx
  803593:	48 89 f7             	mov    %rsi,%rdi
  803596:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  803599:	48 85 f6             	test   %rsi,%rsi
  80359c:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  8035a3:	00 00 00 
  8035a6:	48 0f 44 f8          	cmove  %rax,%rdi
    }
    int res = sys_ipc_recv(pg, PAGE_SIZE);
  8035aa:	be 00 10 00 00       	mov    $0x1000,%esi
  8035af:	48 b8 78 18 80 00 00 	movabs $0x801878,%rax
  8035b6:	00 00 00 
  8035b9:	ff d0                	call   *%rax
    if (res < 0) {
  8035bb:	85 c0                	test   %eax,%eax
  8035bd:	78 45                	js     803604 <ipc_recv+0x7f>
        if (perm_store != NULL) {
            *perm_store = 0;
        }
        return res;
    } else {
        if (from_env_store != NULL) {
  8035bf:	48 85 db             	test   %rbx,%rbx
  8035c2:	74 12                	je     8035d6 <ipc_recv+0x51>
            *from_env_store = thisenv->env_ipc_from;
  8035c4:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  8035cb:	00 00 00 
  8035ce:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  8035d4:	89 03                	mov    %eax,(%rbx)
        }
        if (perm_store != NULL) {
  8035d6:	4d 85 e4             	test   %r12,%r12
  8035d9:	74 14                	je     8035ef <ipc_recv+0x6a>
            *perm_store = thisenv->env_ipc_perm;
  8035db:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  8035e2:	00 00 00 
  8035e5:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  8035eb:	41 89 04 24          	mov    %eax,(%r12)
        }
        return thisenv->env_ipc_value;
  8035ef:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  8035f6:	00 00 00 
  8035f9:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
    }
    return -1;
}
  8035ff:	5b                   	pop    %rbx
  803600:	41 5c                	pop    %r12
  803602:	5d                   	pop    %rbp
  803603:	c3                   	ret
        if (from_env_store != NULL) {
  803604:	48 85 db             	test   %rbx,%rbx
  803607:	74 06                	je     80360f <ipc_recv+0x8a>
            *from_env_store = 0;
  803609:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store != NULL) {
  80360f:	4d 85 e4             	test   %r12,%r12
  803612:	74 eb                	je     8035ff <ipc_recv+0x7a>
            *perm_store = 0;
  803614:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  80361b:	00 
  80361c:	eb e1                	jmp    8035ff <ipc_recv+0x7a>

000000000080361e <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  80361e:	f3 0f 1e fa          	endbr64
  803622:	55                   	push   %rbp
  803623:	48 89 e5             	mov    %rsp,%rbp
  803626:	41 57                	push   %r15
  803628:	41 56                	push   %r14
  80362a:	41 55                	push   %r13
  80362c:	41 54                	push   %r12
  80362e:	53                   	push   %rbx
  80362f:	48 83 ec 18          	sub    $0x18,%rsp
  803633:	89 7d c4             	mov    %edi,-0x3c(%rbp)
  803636:	48 89 d3             	mov    %rdx,%rbx
  803639:	49 89 cc             	mov    %rcx,%r12
  80363c:	45 89 c5             	mov    %r8d,%r13d
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  80363f:	48 85 d2             	test   %rdx,%rdx
  803642:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  803649:	00 00 00 
  80364c:	48 0f 44 d8          	cmove  %rax,%rbx
    }
    int res = sys_ipc_try_send(to_env, val, pg, size, perm);
  803650:	89 f0                	mov    %esi,%eax
  803652:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  803656:	48 89 da             	mov    %rbx,%rdx
  803659:	48 89 c6             	mov    %rax,%rsi
  80365c:	48 b8 48 18 80 00 00 	movabs $0x801848,%rax
  803663:	00 00 00 
  803666:	ff d0                	call   *%rax
    while (res < 0) {
  803668:	85 c0                	test   %eax,%eax
  80366a:	79 65                	jns    8036d1 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  80366c:	83 f8 f5             	cmp    $0xfffffff5,%eax
  80366f:	75 33                	jne    8036a4 <ipc_send+0x86>
            panic("Error: %i\n", res);
        }
        sys_yield();
  803671:	49 bf bb 14 80 00 00 	movabs $0x8014bb,%r15
  803678:	00 00 00 
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  80367b:	49 be 48 18 80 00 00 	movabs $0x801848,%r14
  803682:	00 00 00 
        sys_yield();
  803685:	41 ff d7             	call   *%r15
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  803688:	45 89 e8             	mov    %r13d,%r8d
  80368b:	4c 89 e1             	mov    %r12,%rcx
  80368e:	48 89 da             	mov    %rbx,%rdx
  803691:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  803695:	8b 7d c4             	mov    -0x3c(%rbp),%edi
  803698:	41 ff d6             	call   *%r14
    while (res < 0) {
  80369b:	85 c0                	test   %eax,%eax
  80369d:	79 32                	jns    8036d1 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  80369f:	83 f8 f5             	cmp    $0xfffffff5,%eax
  8036a2:	74 e1                	je     803685 <ipc_send+0x67>
            panic("Error: %i\n", res);
  8036a4:	89 c1                	mov    %eax,%ecx
  8036a6:	48 ba 40 43 80 00 00 	movabs $0x804340,%rdx
  8036ad:	00 00 00 
  8036b0:	be 42 00 00 00       	mov    $0x42,%esi
  8036b5:	48 bf 4b 43 80 00 00 	movabs $0x80434b,%rdi
  8036bc:	00 00 00 
  8036bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8036c4:	49 b8 ac 04 80 00 00 	movabs $0x8004ac,%r8
  8036cb:	00 00 00 
  8036ce:	41 ff d0             	call   *%r8
    }
}
  8036d1:	48 83 c4 18          	add    $0x18,%rsp
  8036d5:	5b                   	pop    %rbx
  8036d6:	41 5c                	pop    %r12
  8036d8:	41 5d                	pop    %r13
  8036da:	41 5e                	pop    %r14
  8036dc:	41 5f                	pop    %r15
  8036de:	5d                   	pop    %rbp
  8036df:	c3                   	ret

00000000008036e0 <ipc_find_env>:

/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
  8036e0:	f3 0f 1e fa          	endbr64
    for (size_t i = 0; i < NENV; i++)
  8036e4:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  8036e9:	48 b9 00 00 a0 1f 80 	movabs $0x801fa00000,%rcx
  8036f0:	00 00 00 
  8036f3:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8036f7:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  8036fb:	48 c1 e2 04          	shl    $0x4,%rdx
  8036ff:	48 01 ca             	add    %rcx,%rdx
  803702:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  803708:	39 fa                	cmp    %edi,%edx
  80370a:	74 12                	je     80371e <ipc_find_env+0x3e>
    for (size_t i = 0; i < NENV; i++)
  80370c:	48 83 c0 01          	add    $0x1,%rax
  803710:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  803716:	75 db                	jne    8036f3 <ipc_find_env+0x13>
            return envs[i].env_id;
    return 0;
  803718:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80371d:	c3                   	ret
            return envs[i].env_id;
  80371e:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  803722:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  803726:	48 c1 e2 04          	shl    $0x4,%rdx
  80372a:	48 b8 00 00 a0 1f 80 	movabs $0x801fa00000,%rax
  803731:	00 00 00 
  803734:	48 01 d0             	add    %rdx,%rax
  803737:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80373d:	c3                   	ret

000000000080373e <__text_end>:
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
