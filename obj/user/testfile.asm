
obj/user/testfile:     file format elf64-x86-64


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
  80001e:	e8 93 0a 00 00       	call   800ab6 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <xopen>:
const char *msg = "This is the NEW message of the day!\n\n";

#define FVA ((struct Fd *)0xA000000)

static int
xopen(const char *path, int mode) {
  800025:	f3 0f 1e fa          	endbr64
  800029:	55                   	push   %rbp
  80002a:	48 89 e5             	mov    %rsp,%rbp
  80002d:	41 54                	push   %r12
  80002f:	53                   	push   %rbx
  800030:	48 83 ec 10          	sub    $0x10,%rsp
  800034:	41 89 f4             	mov    %esi,%r12d
    extern union Fsipc fsipcbuf;
    envid_t fsenv;

    strcpy(fsipcbuf.open.req_path, path);
  800037:	48 89 fe             	mov    %rdi,%rsi
  80003a:	48 bb 00 70 80 00 00 	movabs $0x807000,%rbx
  800041:	00 00 00 
  800044:	48 89 df             	mov    %rbx,%rdi
  800047:	48 b8 34 16 80 00 00 	movabs $0x801634,%rax
  80004e:	00 00 00 
  800051:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  800053:	44 89 a3 00 04 00 00 	mov    %r12d,0x400(%rbx)

    fsenv = ipc_find_env(ENV_TYPE_FS);
  80005a:	bf 03 00 00 00       	mov    $0x3,%edi
  80005f:	48 b8 58 21 80 00 00 	movabs $0x802158,%rax
  800066:	00 00 00 
  800069:	ff d0                	call   *%rax
  80006b:	89 c7                	mov    %eax,%edi
    size_t sz = PAGE_SIZE;
  80006d:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  800074:	00 
    ipc_send(fsenv, FSREQ_OPEN, &fsipcbuf, sz, PROT_RW);
  800075:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  80007b:	b9 00 10 00 00       	mov    $0x1000,%ecx
  800080:	48 89 da             	mov    %rbx,%rdx
  800083:	be 01 00 00 00       	mov    $0x1,%esi
  800088:	48 b8 96 20 80 00 00 	movabs $0x802096,%rax
  80008f:	00 00 00 
  800092:	ff d0                	call   *%rax
    return ipc_recv(NULL, FVA, &sz, NULL);
  800094:	b9 00 00 00 00       	mov    $0x0,%ecx
  800099:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80009d:	be 00 00 00 0a       	mov    $0xa000000,%esi
  8000a2:	bf 00 00 00 00       	mov    $0x0,%edi
  8000a7:	48 b8 fd 1f 80 00 00 	movabs $0x801ffd,%rax
  8000ae:	00 00 00 
  8000b1:	ff d0                	call   *%rax
}
  8000b3:	48 83 c4 10          	add    $0x10,%rsp
  8000b7:	5b                   	pop    %rbx
  8000b8:	41 5c                	pop    %r12
  8000ba:	5d                   	pop    %rbp
  8000bb:	c3                   	ret

00000000008000bc <umain>:

void
umain(int argc, char **argv) {
  8000bc:	f3 0f 1e fa          	endbr64
  8000c0:	55                   	push   %rbp
  8000c1:	48 89 e5             	mov    %rsp,%rbp
  8000c4:	41 55                	push   %r13
  8000c6:	41 54                	push   %r12
  8000c8:	53                   	push   %rbx
  8000c9:	48 81 ec a8 02 00 00 	sub    $0x2a8,%rsp
    struct Fd fdcopy;
    struct Stat st;
    char buf[512];

    /* We open files manually first, to avoid the FD layer */
    if ((r = xopen("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  8000d0:	be 00 00 00 00       	mov    $0x0,%esi
  8000d5:	48 bf 00 40 80 00 00 	movabs $0x804000,%rdi
  8000dc:	00 00 00 
  8000df:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  8000e6:	00 00 00 
  8000e9:	ff d0                	call   *%rax
  8000eb:	48 63 c8             	movslq %eax,%rcx
  8000ee:	48 85 c9             	test   %rcx,%rcx
  8000f1:	0f 89 70 05 00 00    	jns    800667 <umain+0x5ab>
  8000f7:	48 83 f9 f1          	cmp    $0xfffffffffffffff1,%rcx
  8000fb:	0f 85 3b 05 00 00    	jne    80063c <umain+0x580>
        panic("serve_open /not-found: %ld", (long)r);
    else if (r >= 0)
        panic("serve_open /not-found succeeded!");

    if ((r = xopen("/newmotd", O_RDONLY)) < 0)
  800101:	be 00 00 00 00       	mov    $0x0,%esi
  800106:	48 bf 36 40 80 00 00 	movabs $0x804036,%rdi
  80010d:	00 00 00 
  800110:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  800117:	00 00 00 
  80011a:	ff d0                	call   *%rax
  80011c:	48 63 c8             	movslq %eax,%rcx
  80011f:	48 85 c9             	test   %rcx,%rcx
  800122:	0f 88 69 05 00 00    	js     800691 <umain+0x5d5>
        panic("serve_open /newmotd: %ld", (long)r);
    if (FVA->fd_dev_id != 'f' || FVA->fd_offset != 0 || FVA->fd_omode != O_RDONLY)
  800128:	83 3c 25 00 00 00 0a 	cmpl   $0x66,0xa000000
  80012f:	66 
  800130:	0f 85 86 05 00 00    	jne    8006bc <umain+0x600>
  800136:	83 3c 25 04 00 00 0a 	cmpl   $0x0,0xa000004
  80013d:	00 
  80013e:	0f 85 78 05 00 00    	jne    8006bc <umain+0x600>
  800144:	83 3c 25 08 00 00 0a 	cmpl   $0x0,0xa000008
  80014b:	00 
  80014c:	0f 85 6a 05 00 00    	jne    8006bc <umain+0x600>
        panic("serve_open did not fill struct Fd correctly\n");
    cprintf("serve_open is good\n");
  800152:	48 bf 58 40 80 00 00 	movabs $0x804058,%rdi
  800159:	00 00 00 
  80015c:	b8 00 00 00 00       	mov    $0x0,%eax
  800161:	48 ba eb 0c 80 00 00 	movabs $0x800ceb,%rdx
  800168:	00 00 00 
  80016b:	ff d2                	call   *%rdx

    if ((r = devfile.dev_stat(FVA, &st)) < 0)
  80016d:	48 8d b5 40 ff ff ff 	lea    -0xc0(%rbp),%rsi
  800174:	bf 00 00 00 0a       	mov    $0xa000000,%edi
  800179:	48 a1 48 50 80 00 00 	movabs 0x805048,%rax
  800180:	00 00 00 
  800183:	ff d0                	call   *%rax
  800185:	48 63 c8             	movslq %eax,%rcx
  800188:	48 85 c9             	test   %rcx,%rcx
  80018b:	0f 88 55 05 00 00    	js     8006e6 <umain+0x62a>
        panic("file_stat: %ld", (long)r);
    if (strlen(msg) != st.st_size)
  800191:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  800198:	00 00 00 
  80019b:	48 8b 38             	mov    (%rax),%rdi
  80019e:	48 b8 ef 15 80 00 00 	movabs $0x8015ef,%rax
  8001a5:	00 00 00 
  8001a8:	ff d0                	call   *%rax
  8001aa:	48 89 c2             	mov    %rax,%rdx
  8001ad:	48 63 45 c0          	movslq -0x40(%rbp),%rax
  8001b1:	48 39 c2             	cmp    %rax,%rdx
  8001b4:	0f 85 57 05 00 00    	jne    800711 <umain+0x655>
        panic("file_stat returned size %ld wanted %zd\n", (long)st.st_size, strlen(msg));
    cprintf("file_stat is good\n");
  8001ba:	48 bf 7b 40 80 00 00 	movabs $0x80407b,%rdi
  8001c1:	00 00 00 
  8001c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8001c9:	48 ba eb 0c 80 00 00 	movabs $0x800ceb,%rdx
  8001d0:	00 00 00 
  8001d3:	ff d2                	call   *%rdx

    memset(buf, 0, sizeof buf);
  8001d5:	ba 00 02 00 00       	mov    $0x200,%edx
  8001da:	be 00 00 00 00       	mov    $0x0,%esi
  8001df:	48 8d bd 40 fd ff ff 	lea    -0x2c0(%rbp),%rdi
  8001e6:	48 b8 95 17 80 00 00 	movabs $0x801795,%rax
  8001ed:	00 00 00 
  8001f0:	ff d0                	call   *%rax
    if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  8001f2:	ba 00 02 00 00       	mov    $0x200,%edx
  8001f7:	48 8d b5 40 fd ff ff 	lea    -0x2c0(%rbp),%rsi
  8001fe:	bf 00 00 00 0a       	mov    $0xa000000,%edi
  800203:	48 a1 30 50 80 00 00 	movabs 0x805030,%rax
  80020a:	00 00 00 
  80020d:	ff d0                	call   *%rax
  80020f:	48 85 c0             	test   %rax,%rax
  800212:	0f 88 44 05 00 00    	js     80075c <umain+0x6a0>
        panic("file_read: %ld", (long)r);
    if (strcmp(buf, msg) != 0)
  800218:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  80021f:	00 00 00 
  800222:	48 8b 30             	mov    (%rax),%rsi
  800225:	48 8d bd 40 fd ff ff 	lea    -0x2c0(%rbp),%rdi
  80022c:	48 b8 e8 16 80 00 00 	movabs $0x8016e8,%rax
  800233:	00 00 00 
  800236:	ff d0                	call   *%rax
  800238:	85 c0                	test   %eax,%eax
  80023a:	0f 85 4a 05 00 00    	jne    80078a <umain+0x6ce>
        panic("file_read returned wrong data");
    cprintf("file_read is good\n");
  800240:	48 bf bb 40 80 00 00 	movabs $0x8040bb,%rdi
  800247:	00 00 00 
  80024a:	b8 00 00 00 00       	mov    $0x0,%eax
  80024f:	48 ba eb 0c 80 00 00 	movabs $0x800ceb,%rdx
  800256:	00 00 00 
  800259:	ff d2                	call   *%rdx

    if ((r = devfile.dev_close(FVA)) < 0)
  80025b:	bf 00 00 00 0a       	mov    $0xa000000,%edi
  800260:	48 a1 40 50 80 00 00 	movabs 0x805040,%rax
  800267:	00 00 00 
  80026a:	ff d0                	call   *%rax
  80026c:	48 63 c8             	movslq %eax,%rcx
  80026f:	48 85 c9             	test   %rcx,%rcx
  800272:	0f 88 3c 05 00 00    	js     8007b4 <umain+0x6f8>
        panic("file_close: %ld", (long)r);
    cprintf("file_close is good\n");
  800278:	48 bf de 40 80 00 00 	movabs $0x8040de,%rdi
  80027f:	00 00 00 
  800282:	b8 00 00 00 00       	mov    $0x0,%eax
  800287:	48 ba eb 0c 80 00 00 	movabs $0x800ceb,%rdx
  80028e:	00 00 00 
  800291:	ff d2                	call   *%rdx

    /* We're about to unmap the FD, but still need a way to get
     * the stale filenum to serve_read, so we make a local copy.
     * The file server won't think it's stale until we unmap the
     * FD page. */
    fdcopy = *FVA;
  800293:	48 8b 04 25 00 00 00 	mov    0xa000000,%rax
  80029a:	0a 
  80029b:	48 8b 14 25 08 00 00 	mov    0xa000008,%rdx
  8002a2:	0a 
  8002a3:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8002a7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
    sys_unmap_region(0, FVA, PAGE_SIZE);
  8002ab:	ba 00 10 00 00       	mov    $0x1000,%edx
  8002b0:	be 00 00 00 0a       	mov    $0xa000000,%esi
  8002b5:	bf 00 00 00 00       	mov    $0x0,%edi
  8002ba:	48 b8 79 1d 80 00 00 	movabs $0x801d79,%rax
  8002c1:	00 00 00 
  8002c4:	ff d0                	call   *%rax

    if ((r = devfile.dev_read(&fdcopy, buf, sizeof buf)) != -E_INVAL)
  8002c6:	ba 00 02 00 00       	mov    $0x200,%edx
  8002cb:	48 8d b5 40 fd ff ff 	lea    -0x2c0(%rbp),%rsi
  8002d2:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  8002d6:	48 a1 30 50 80 00 00 	movabs 0x805030,%rax
  8002dd:	00 00 00 
  8002e0:	ff d0                	call   *%rax
  8002e2:	48 83 f8 fd          	cmp    $0xfffffffffffffffd,%rax
  8002e6:	0f 85 f3 04 00 00    	jne    8007df <umain+0x723>
        panic("serve_read does not handle stale fileids correctly: %ld", (long)r);
    cprintf("stale fileid is good\n");
  8002ec:	48 bf f2 40 80 00 00 	movabs $0x8040f2,%rdi
  8002f3:	00 00 00 
  8002f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8002fb:	48 ba eb 0c 80 00 00 	movabs $0x800ceb,%rdx
  800302:	00 00 00 
  800305:	ff d2                	call   *%rdx

    /* Try writing */
    if ((r = xopen("/new-file", O_RDWR | O_CREAT)) < 0)
  800307:	be 02 01 00 00       	mov    $0x102,%esi
  80030c:	48 bf 08 41 80 00 00 	movabs $0x804108,%rdi
  800313:	00 00 00 
  800316:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  80031d:	00 00 00 
  800320:	ff d0                	call   *%rax
  800322:	48 63 c8             	movslq %eax,%rcx
  800325:	48 85 c9             	test   %rcx,%rcx
  800328:	0f 88 df 04 00 00    	js     80080d <umain+0x751>
        panic("serve_open /new-file: %ld", (long)r);

    if ((r = devfile.dev_write(FVA, msg, strlen(msg))) != strlen(msg))
  80032e:	48 b8 38 50 80 00 00 	movabs $0x805038,%rax
  800335:	00 00 00 
  800338:	48 8b 18             	mov    (%rax),%rbx
  80033b:	49 bc 00 50 80 00 00 	movabs $0x805000,%r12
  800342:	00 00 00 
  800345:	49 8b 3c 24          	mov    (%r12),%rdi
  800349:	49 bd ef 15 80 00 00 	movabs $0x8015ef,%r13
  800350:	00 00 00 
  800353:	41 ff d5             	call   *%r13
  800356:	48 89 c2             	mov    %rax,%rdx
  800359:	49 8b 34 24          	mov    (%r12),%rsi
  80035d:	bf 00 00 00 0a       	mov    $0xa000000,%edi
  800362:	ff d3                	call   *%rbx
  800364:	48 89 c3             	mov    %rax,%rbx
  800367:	49 8b 3c 24          	mov    (%r12),%rdi
  80036b:	41 ff d5             	call   *%r13
  80036e:	48 39 c3             	cmp    %rax,%rbx
  800371:	0f 85 c1 04 00 00    	jne    800838 <umain+0x77c>
        panic("file_write: %ld", (long)r);
    cprintf("file_write is good\n");
  800377:	48 bf 3c 41 80 00 00 	movabs $0x80413c,%rdi
  80037e:	00 00 00 
  800381:	b8 00 00 00 00       	mov    $0x0,%eax
  800386:	48 ba eb 0c 80 00 00 	movabs $0x800ceb,%rdx
  80038d:	00 00 00 
  800390:	ff d2                	call   *%rdx

    FVA->fd_offset = 0;
  800392:	c7 04 25 04 00 00 0a 	movl   $0x0,0xa000004
  800399:	00 00 00 00 
    memset(buf, 0, sizeof buf);
  80039d:	ba 00 02 00 00       	mov    $0x200,%edx
  8003a2:	be 00 00 00 00       	mov    $0x0,%esi
  8003a7:	48 8d bd 40 fd ff ff 	lea    -0x2c0(%rbp),%rdi
  8003ae:	48 b8 95 17 80 00 00 	movabs $0x801795,%rax
  8003b5:	00 00 00 
  8003b8:	ff d0                	call   *%rax
    if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  8003ba:	ba 00 02 00 00       	mov    $0x200,%edx
  8003bf:	48 8d b5 40 fd ff ff 	lea    -0x2c0(%rbp),%rsi
  8003c6:	bf 00 00 00 0a       	mov    $0xa000000,%edi
  8003cb:	48 a1 30 50 80 00 00 	movabs 0x805030,%rax
  8003d2:	00 00 00 
  8003d5:	ff d0                	call   *%rax
  8003d7:	48 89 c3             	mov    %rax,%rbx
  8003da:	48 85 c0             	test   %rax,%rax
  8003dd:	0f 88 83 04 00 00    	js     800866 <umain+0x7aa>
        panic("file_read after file_write: %ld", (long)r);
    if (r != strlen(msg))
  8003e3:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8003ea:	00 00 00 
  8003ed:	48 8b 38             	mov    (%rax),%rdi
  8003f0:	48 b8 ef 15 80 00 00 	movabs $0x8015ef,%rax
  8003f7:	00 00 00 
  8003fa:	ff d0                	call   *%rax
  8003fc:	48 39 d8             	cmp    %rbx,%rax
  8003ff:	0f 85 8f 04 00 00    	jne    800894 <umain+0x7d8>
        panic("file_read after file_write returned wrong length: %ld", (long)r);
    if (strcmp(buf, msg) != 0)
  800405:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  80040c:	00 00 00 
  80040f:	48 8b 30             	mov    (%rax),%rsi
  800412:	48 8d bd 40 fd ff ff 	lea    -0x2c0(%rbp),%rdi
  800419:	48 b8 e8 16 80 00 00 	movabs $0x8016e8,%rax
  800420:	00 00 00 
  800423:	ff d0                	call   *%rax
  800425:	85 c0                	test   %eax,%eax
  800427:	0f 85 95 04 00 00    	jne    8008c2 <umain+0x806>
        panic("file_read after file_write returned wrong data");
    cprintf("file_read after file_write is good\n");
  80042d:	48 bf 60 45 80 00 00 	movabs $0x804560,%rdi
  800434:	00 00 00 
  800437:	b8 00 00 00 00       	mov    $0x0,%eax
  80043c:	48 ba eb 0c 80 00 00 	movabs $0x800ceb,%rdx
  800443:	00 00 00 
  800446:	ff d2                	call   *%rdx

    /* Now we'll try out open */
    if ((r = open("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  800448:	be 00 00 00 00       	mov    $0x0,%esi
  80044d:	48 bf 00 40 80 00 00 	movabs $0x804000,%rdi
  800454:	00 00 00 
  800457:	48 b8 81 2b 80 00 00 	movabs $0x802b81,%rax
  80045e:	00 00 00 
  800461:	ff d0                	call   *%rax
  800463:	48 63 c8             	movslq %eax,%rcx
  800466:	48 85 c9             	test   %rcx,%rcx
  800469:	0f 89 a8 04 00 00    	jns    800917 <umain+0x85b>
  80046f:	48 83 f9 f1          	cmp    $0xfffffffffffffff1,%rcx
  800473:	0f 85 73 04 00 00    	jne    8008ec <umain+0x830>
        panic("open /not-found: %ld", (long)r);
    else if (r >= 0)
        panic("open /not-found succeeded!");

    if ((r = open("/newmotd", O_RDONLY)) < 0)
  800479:	be 00 00 00 00       	mov    $0x0,%esi
  80047e:	48 bf 36 40 80 00 00 	movabs $0x804036,%rdi
  800485:	00 00 00 
  800488:	48 b8 81 2b 80 00 00 	movabs $0x802b81,%rax
  80048f:	00 00 00 
  800492:	ff d0                	call   *%rax
  800494:	48 98                	cltq
  800496:	48 85 c0             	test   %rax,%rax
  800499:	0f 88 a2 04 00 00    	js     800941 <umain+0x885>
        panic("open /newmotd: %ld", (long)r);
    fd = (struct Fd *)(0xD0000000 + r * PAGE_SIZE);
  80049f:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8004a5:	48 c1 e0 0c          	shl    $0xc,%rax
    if (fd->fd_dev_id != 'f' || fd->fd_offset != 0 || fd->fd_omode != O_RDONLY)
  8004a9:	83 38 66             	cmpl   $0x66,(%rax)
  8004ac:	0f 85 bd 04 00 00    	jne    80096f <umain+0x8b3>
  8004b2:	83 78 04 00          	cmpl   $0x0,0x4(%rax)
  8004b6:	0f 85 b3 04 00 00    	jne    80096f <umain+0x8b3>
  8004bc:	83 78 08 00          	cmpl   $0x0,0x8(%rax)
  8004c0:	0f 85 a9 04 00 00    	jne    80096f <umain+0x8b3>
        panic("open did not fill struct Fd correctly\n");
    cprintf("open is good\n");
  8004c6:	48 bf 5e 40 80 00 00 	movabs $0x80405e,%rdi
  8004cd:	00 00 00 
  8004d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8004d5:	48 ba eb 0c 80 00 00 	movabs $0x800ceb,%rdx
  8004dc:	00 00 00 
  8004df:	ff d2                	call   *%rdx

    /* Try files with indirect blocks */
    if ((f = open("/big", O_WRONLY | O_CREAT)) < 0)
  8004e1:	be 01 01 00 00       	mov    $0x101,%esi
  8004e6:	48 bf 6b 41 80 00 00 	movabs $0x80416b,%rdi
  8004ed:	00 00 00 
  8004f0:	48 b8 81 2b 80 00 00 	movabs $0x802b81,%rax
  8004f7:	00 00 00 
  8004fa:	ff d0                	call   *%rax
  8004fc:	41 89 c4             	mov    %eax,%r12d
  8004ff:	48 63 c8             	movslq %eax,%rcx
  800502:	48 85 c9             	test   %rcx,%rcx
  800505:	0f 88 8e 04 00 00    	js     800999 <umain+0x8dd>
        panic("creat /big: %ld", (long)f);
    memset(buf, 0, sizeof(buf));
  80050b:	ba 00 02 00 00       	mov    $0x200,%edx
  800510:	be 00 00 00 00       	mov    $0x0,%esi
  800515:	48 8d bd 40 fd ff ff 	lea    -0x2c0(%rbp),%rdi
  80051c:	48 b8 95 17 80 00 00 	movabs $0x801795,%rax
  800523:	00 00 00 
  800526:	ff d0                	call   *%rax
    for (int64_t i = 0; i < (NDIRECT * 3) * BLKSIZE; i += sizeof(buf)) {
  800528:	bb 00 00 00 00       	mov    $0x0,%ebx
        *(int *)buf = i;
        if ((r = write(f, buf, sizeof(buf))) < 0)
  80052d:	49 bd 82 26 80 00 00 	movabs $0x802682,%r13
  800534:	00 00 00 
        *(int *)buf = i;
  800537:	89 9d 40 fd ff ff    	mov    %ebx,-0x2c0(%rbp)
        if ((r = write(f, buf, sizeof(buf))) < 0)
  80053d:	ba 00 02 00 00       	mov    $0x200,%edx
  800542:	48 8d b5 40 fd ff ff 	lea    -0x2c0(%rbp),%rsi
  800549:	44 89 e7             	mov    %r12d,%edi
  80054c:	41 ff d5             	call   *%r13
  80054f:	48 85 c0             	test   %rax,%rax
  800552:	0f 88 6c 04 00 00    	js     8009c4 <umain+0x908>
    for (int64_t i = 0; i < (NDIRECT * 3) * BLKSIZE; i += sizeof(buf)) {
  800558:	48 8d 83 00 02 00 00 	lea    0x200(%rbx),%rax
  80055f:	48 89 c3             	mov    %rax,%rbx
  800562:	48 3d 00 e0 01 00    	cmp    $0x1e000,%rax
  800568:	75 cd                	jne    800537 <umain+0x47b>
            panic("write /big@%ld: %ld", (long)i, (long)r);
    }
    close(f);
  80056a:	44 89 e7             	mov    %r12d,%edi
  80056d:	48 b8 c1 23 80 00 00 	movabs $0x8023c1,%rax
  800574:	00 00 00 
  800577:	ff d0                	call   *%rax

    if ((f = open("/big", O_RDONLY)) < 0)
  800579:	be 00 00 00 00       	mov    $0x0,%esi
  80057e:	48 bf 6b 41 80 00 00 	movabs $0x80416b,%rdi
  800585:	00 00 00 
  800588:	48 b8 81 2b 80 00 00 	movabs $0x802b81,%rax
  80058f:	00 00 00 
  800592:	ff d0                	call   *%rax
  800594:	41 89 c4             	mov    %eax,%r12d
  800597:	48 63 c8             	movslq %eax,%rcx
  80059a:	48 85 c9             	test   %rcx,%rcx
  80059d:	0f 88 52 04 00 00    	js     8009f5 <umain+0x939>
        panic("open /big: %ld", (long)f);
    for (int64_t i = 0; i < (NDIRECT * 3) * BLKSIZE; i += sizeof(buf)) {
  8005a3:	bb 00 00 00 00       	mov    $0x0,%ebx
        *(int *)buf = i;
        if ((r = readn(f, buf, sizeof(buf))) < 0)
  8005a8:	49 bd 0d 26 80 00 00 	movabs $0x80260d,%r13
  8005af:	00 00 00 
        *(int *)buf = i;
  8005b2:	89 9d 40 fd ff ff    	mov    %ebx,-0x2c0(%rbp)
        if ((r = readn(f, buf, sizeof(buf))) < 0)
  8005b8:	ba 00 02 00 00       	mov    $0x200,%edx
  8005bd:	48 8d b5 40 fd ff ff 	lea    -0x2c0(%rbp),%rsi
  8005c4:	44 89 e7             	mov    %r12d,%edi
  8005c7:	41 ff d5             	call   *%r13
  8005ca:	48 85 c0             	test   %rax,%rax
  8005cd:	0f 88 4d 04 00 00    	js     800a20 <umain+0x964>
            panic("read /big@%ld: %ld", (long)i, (long)r);
        if (r != sizeof(buf))
  8005d3:	48 3d 00 02 00 00    	cmp    $0x200,%rax
  8005d9:	0f 85 72 04 00 00    	jne    800a51 <umain+0x995>
            panic("read /big from %ld returned %ld < %d bytes",
                  (long)i, (long)r, (uint32_t)sizeof(buf));
        if (*(int *)buf != i)
  8005df:	44 8b 85 40 fd ff ff 	mov    -0x2c0(%rbp),%r8d
  8005e6:	49 63 c0             	movslq %r8d,%rax
  8005e9:	48 39 d8             	cmp    %rbx,%rax
  8005ec:	0f 85 96 04 00 00    	jne    800a88 <umain+0x9cc>
    for (int64_t i = 0; i < (NDIRECT * 3) * BLKSIZE; i += sizeof(buf)) {
  8005f2:	48 8d 83 00 02 00 00 	lea    0x200(%rbx),%rax
  8005f9:	48 89 c3             	mov    %rax,%rbx
  8005fc:	48 3d 00 e0 01 00    	cmp    $0x1e000,%rax
  800602:	75 ae                	jne    8005b2 <umain+0x4f6>
            panic("read /big from %ld returned bad data %d",
                  (long)i, *(int *)buf);
    }
    close(f);
  800604:	44 89 e7             	mov    %r12d,%edi
  800607:	48 b8 c1 23 80 00 00 	movabs $0x8023c1,%rax
  80060e:	00 00 00 
  800611:	ff d0                	call   *%rax
    cprintf("large file is good\n");
  800613:	48 bf b6 41 80 00 00 	movabs $0x8041b6,%rdi
  80061a:	00 00 00 
  80061d:	b8 00 00 00 00       	mov    $0x0,%eax
  800622:	48 ba eb 0c 80 00 00 	movabs $0x800ceb,%rdx
  800629:	00 00 00 
  80062c:	ff d2                	call   *%rdx
}
  80062e:	48 81 c4 a8 02 00 00 	add    $0x2a8,%rsp
  800635:	5b                   	pop    %rbx
  800636:	41 5c                	pop    %r12
  800638:	41 5d                	pop    %r13
  80063a:	5d                   	pop    %rbp
  80063b:	c3                   	ret
        panic("serve_open /not-found: %ld", (long)r);
  80063c:	48 ba 0b 40 80 00 00 	movabs $0x80400b,%rdx
  800643:	00 00 00 
  800646:	be 1f 00 00 00       	mov    $0x1f,%esi
  80064b:	48 bf 26 40 80 00 00 	movabs $0x804026,%rdi
  800652:	00 00 00 
  800655:	b8 00 00 00 00       	mov    $0x0,%eax
  80065a:	49 b8 8f 0b 80 00 00 	movabs $0x800b8f,%r8
  800661:	00 00 00 
  800664:	41 ff d0             	call   *%r8
        panic("serve_open /not-found succeeded!");
  800667:	48 ba 20 44 80 00 00 	movabs $0x804420,%rdx
  80066e:	00 00 00 
  800671:	be 21 00 00 00       	mov    $0x21,%esi
  800676:	48 bf 26 40 80 00 00 	movabs $0x804026,%rdi
  80067d:	00 00 00 
  800680:	b8 00 00 00 00       	mov    $0x0,%eax
  800685:	48 b9 8f 0b 80 00 00 	movabs $0x800b8f,%rcx
  80068c:	00 00 00 
  80068f:	ff d1                	call   *%rcx
        panic("serve_open /newmotd: %ld", (long)r);
  800691:	48 ba 3f 40 80 00 00 	movabs $0x80403f,%rdx
  800698:	00 00 00 
  80069b:	be 24 00 00 00       	mov    $0x24,%esi
  8006a0:	48 bf 26 40 80 00 00 	movabs $0x804026,%rdi
  8006a7:	00 00 00 
  8006aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8006af:	49 b8 8f 0b 80 00 00 	movabs $0x800b8f,%r8
  8006b6:	00 00 00 
  8006b9:	41 ff d0             	call   *%r8
        panic("serve_open did not fill struct Fd correctly\n");
  8006bc:	48 ba 48 44 80 00 00 	movabs $0x804448,%rdx
  8006c3:	00 00 00 
  8006c6:	be 26 00 00 00       	mov    $0x26,%esi
  8006cb:	48 bf 26 40 80 00 00 	movabs $0x804026,%rdi
  8006d2:	00 00 00 
  8006d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8006da:	48 b9 8f 0b 80 00 00 	movabs $0x800b8f,%rcx
  8006e1:	00 00 00 
  8006e4:	ff d1                	call   *%rcx
        panic("file_stat: %ld", (long)r);
  8006e6:	48 ba 6c 40 80 00 00 	movabs $0x80406c,%rdx
  8006ed:	00 00 00 
  8006f0:	be 2a 00 00 00       	mov    $0x2a,%esi
  8006f5:	48 bf 26 40 80 00 00 	movabs $0x804026,%rdi
  8006fc:	00 00 00 
  8006ff:	b8 00 00 00 00       	mov    $0x0,%eax
  800704:	49 b8 8f 0b 80 00 00 	movabs $0x800b8f,%r8
  80070b:	00 00 00 
  80070e:	41 ff d0             	call   *%r8
        panic("file_stat returned size %ld wanted %zd\n", (long)st.st_size, strlen(msg));
  800711:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  800718:	00 00 00 
  80071b:	48 8b 38             	mov    (%rax),%rdi
  80071e:	48 b8 ef 15 80 00 00 	movabs $0x8015ef,%rax
  800725:	00 00 00 
  800728:	ff d0                	call   *%rax
  80072a:	49 89 c0             	mov    %rax,%r8
  80072d:	48 63 4d c0          	movslq -0x40(%rbp),%rcx
  800731:	48 ba 78 44 80 00 00 	movabs $0x804478,%rdx
  800738:	00 00 00 
  80073b:	be 2c 00 00 00       	mov    $0x2c,%esi
  800740:	48 bf 26 40 80 00 00 	movabs $0x804026,%rdi
  800747:	00 00 00 
  80074a:	b8 00 00 00 00       	mov    $0x0,%eax
  80074f:	49 b9 8f 0b 80 00 00 	movabs $0x800b8f,%r9
  800756:	00 00 00 
  800759:	41 ff d1             	call   *%r9
        panic("file_read: %ld", (long)r);
  80075c:	48 89 c1             	mov    %rax,%rcx
  80075f:	48 ba 8e 40 80 00 00 	movabs $0x80408e,%rdx
  800766:	00 00 00 
  800769:	be 31 00 00 00       	mov    $0x31,%esi
  80076e:	48 bf 26 40 80 00 00 	movabs $0x804026,%rdi
  800775:	00 00 00 
  800778:	b8 00 00 00 00       	mov    $0x0,%eax
  80077d:	49 b8 8f 0b 80 00 00 	movabs $0x800b8f,%r8
  800784:	00 00 00 
  800787:	41 ff d0             	call   *%r8
        panic("file_read returned wrong data");
  80078a:	48 ba 9d 40 80 00 00 	movabs $0x80409d,%rdx
  800791:	00 00 00 
  800794:	be 33 00 00 00       	mov    $0x33,%esi
  800799:	48 bf 26 40 80 00 00 	movabs $0x804026,%rdi
  8007a0:	00 00 00 
  8007a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8007a8:	48 b9 8f 0b 80 00 00 	movabs $0x800b8f,%rcx
  8007af:	00 00 00 
  8007b2:	ff d1                	call   *%rcx
        panic("file_close: %ld", (long)r);
  8007b4:	48 ba ce 40 80 00 00 	movabs $0x8040ce,%rdx
  8007bb:	00 00 00 
  8007be:	be 37 00 00 00       	mov    $0x37,%esi
  8007c3:	48 bf 26 40 80 00 00 	movabs $0x804026,%rdi
  8007ca:	00 00 00 
  8007cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8007d2:	49 b8 8f 0b 80 00 00 	movabs $0x800b8f,%r8
  8007d9:	00 00 00 
  8007dc:	41 ff d0             	call   *%r8
        panic("serve_read does not handle stale fileids correctly: %ld", (long)r);
  8007df:	48 89 c1             	mov    %rax,%rcx
  8007e2:	48 ba a0 44 80 00 00 	movabs $0x8044a0,%rdx
  8007e9:	00 00 00 
  8007ec:	be 42 00 00 00       	mov    $0x42,%esi
  8007f1:	48 bf 26 40 80 00 00 	movabs $0x804026,%rdi
  8007f8:	00 00 00 
  8007fb:	b8 00 00 00 00       	mov    $0x0,%eax
  800800:	49 b8 8f 0b 80 00 00 	movabs $0x800b8f,%r8
  800807:	00 00 00 
  80080a:	41 ff d0             	call   *%r8
        panic("serve_open /new-file: %ld", (long)r);
  80080d:	48 ba 12 41 80 00 00 	movabs $0x804112,%rdx
  800814:	00 00 00 
  800817:	be 47 00 00 00       	mov    $0x47,%esi
  80081c:	48 bf 26 40 80 00 00 	movabs $0x804026,%rdi
  800823:	00 00 00 
  800826:	b8 00 00 00 00       	mov    $0x0,%eax
  80082b:	49 b8 8f 0b 80 00 00 	movabs $0x800b8f,%r8
  800832:	00 00 00 
  800835:	41 ff d0             	call   *%r8
        panic("file_write: %ld", (long)r);
  800838:	48 89 d9             	mov    %rbx,%rcx
  80083b:	48 ba 2c 41 80 00 00 	movabs $0x80412c,%rdx
  800842:	00 00 00 
  800845:	be 4a 00 00 00       	mov    $0x4a,%esi
  80084a:	48 bf 26 40 80 00 00 	movabs $0x804026,%rdi
  800851:	00 00 00 
  800854:	b8 00 00 00 00       	mov    $0x0,%eax
  800859:	49 b8 8f 0b 80 00 00 	movabs $0x800b8f,%r8
  800860:	00 00 00 
  800863:	41 ff d0             	call   *%r8
        panic("file_read after file_write: %ld", (long)r);
  800866:	48 89 c1             	mov    %rax,%rcx
  800869:	48 ba d8 44 80 00 00 	movabs $0x8044d8,%rdx
  800870:	00 00 00 
  800873:	be 50 00 00 00       	mov    $0x50,%esi
  800878:	48 bf 26 40 80 00 00 	movabs $0x804026,%rdi
  80087f:	00 00 00 
  800882:	b8 00 00 00 00       	mov    $0x0,%eax
  800887:	49 b8 8f 0b 80 00 00 	movabs $0x800b8f,%r8
  80088e:	00 00 00 
  800891:	41 ff d0             	call   *%r8
        panic("file_read after file_write returned wrong length: %ld", (long)r);
  800894:	48 89 d9             	mov    %rbx,%rcx
  800897:	48 ba f8 44 80 00 00 	movabs $0x8044f8,%rdx
  80089e:	00 00 00 
  8008a1:	be 52 00 00 00       	mov    $0x52,%esi
  8008a6:	48 bf 26 40 80 00 00 	movabs $0x804026,%rdi
  8008ad:	00 00 00 
  8008b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8008b5:	49 b8 8f 0b 80 00 00 	movabs $0x800b8f,%r8
  8008bc:	00 00 00 
  8008bf:	41 ff d0             	call   *%r8
        panic("file_read after file_write returned wrong data");
  8008c2:	48 ba 30 45 80 00 00 	movabs $0x804530,%rdx
  8008c9:	00 00 00 
  8008cc:	be 54 00 00 00       	mov    $0x54,%esi
  8008d1:	48 bf 26 40 80 00 00 	movabs $0x804026,%rdi
  8008d8:	00 00 00 
  8008db:	b8 00 00 00 00       	mov    $0x0,%eax
  8008e0:	48 b9 8f 0b 80 00 00 	movabs $0x800b8f,%rcx
  8008e7:	00 00 00 
  8008ea:	ff d1                	call   *%rcx
        panic("open /not-found: %ld", (long)r);
  8008ec:	48 ba 11 40 80 00 00 	movabs $0x804011,%rdx
  8008f3:	00 00 00 
  8008f6:	be 59 00 00 00       	mov    $0x59,%esi
  8008fb:	48 bf 26 40 80 00 00 	movabs $0x804026,%rdi
  800902:	00 00 00 
  800905:	b8 00 00 00 00       	mov    $0x0,%eax
  80090a:	49 b8 8f 0b 80 00 00 	movabs $0x800b8f,%r8
  800911:	00 00 00 
  800914:	41 ff d0             	call   *%r8
        panic("open /not-found succeeded!");
  800917:	48 ba 50 41 80 00 00 	movabs $0x804150,%rdx
  80091e:	00 00 00 
  800921:	be 5b 00 00 00       	mov    $0x5b,%esi
  800926:	48 bf 26 40 80 00 00 	movabs $0x804026,%rdi
  80092d:	00 00 00 
  800930:	b8 00 00 00 00       	mov    $0x0,%eax
  800935:	48 b9 8f 0b 80 00 00 	movabs $0x800b8f,%rcx
  80093c:	00 00 00 
  80093f:	ff d1                	call   *%rcx
        panic("open /newmotd: %ld", (long)r);
  800941:	48 89 c1             	mov    %rax,%rcx
  800944:	48 ba 45 40 80 00 00 	movabs $0x804045,%rdx
  80094b:	00 00 00 
  80094e:	be 5e 00 00 00       	mov    $0x5e,%esi
  800953:	48 bf 26 40 80 00 00 	movabs $0x804026,%rdi
  80095a:	00 00 00 
  80095d:	b8 00 00 00 00       	mov    $0x0,%eax
  800962:	49 b8 8f 0b 80 00 00 	movabs $0x800b8f,%r8
  800969:	00 00 00 
  80096c:	41 ff d0             	call   *%r8
        panic("open did not fill struct Fd correctly\n");
  80096f:	48 ba 88 45 80 00 00 	movabs $0x804588,%rdx
  800976:	00 00 00 
  800979:	be 61 00 00 00       	mov    $0x61,%esi
  80097e:	48 bf 26 40 80 00 00 	movabs $0x804026,%rdi
  800985:	00 00 00 
  800988:	b8 00 00 00 00       	mov    $0x0,%eax
  80098d:	48 b9 8f 0b 80 00 00 	movabs $0x800b8f,%rcx
  800994:	00 00 00 
  800997:	ff d1                	call   *%rcx
        panic("creat /big: %ld", (long)f);
  800999:	48 ba 70 41 80 00 00 	movabs $0x804170,%rdx
  8009a0:	00 00 00 
  8009a3:	be 66 00 00 00       	mov    $0x66,%esi
  8009a8:	48 bf 26 40 80 00 00 	movabs $0x804026,%rdi
  8009af:	00 00 00 
  8009b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8009b7:	49 b8 8f 0b 80 00 00 	movabs $0x800b8f,%r8
  8009be:	00 00 00 
  8009c1:	41 ff d0             	call   *%r8
            panic("write /big@%ld: %ld", (long)i, (long)r);
  8009c4:	49 89 c0             	mov    %rax,%r8
  8009c7:	48 89 d9             	mov    %rbx,%rcx
  8009ca:	48 ba 80 41 80 00 00 	movabs $0x804180,%rdx
  8009d1:	00 00 00 
  8009d4:	be 6b 00 00 00       	mov    $0x6b,%esi
  8009d9:	48 bf 26 40 80 00 00 	movabs $0x804026,%rdi
  8009e0:	00 00 00 
  8009e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8009e8:	49 b9 8f 0b 80 00 00 	movabs $0x800b8f,%r9
  8009ef:	00 00 00 
  8009f2:	41 ff d1             	call   *%r9
        panic("open /big: %ld", (long)f);
  8009f5:	48 ba 94 41 80 00 00 	movabs $0x804194,%rdx
  8009fc:	00 00 00 
  8009ff:	be 70 00 00 00       	mov    $0x70,%esi
  800a04:	48 bf 26 40 80 00 00 	movabs $0x804026,%rdi
  800a0b:	00 00 00 
  800a0e:	b8 00 00 00 00       	mov    $0x0,%eax
  800a13:	49 b8 8f 0b 80 00 00 	movabs $0x800b8f,%r8
  800a1a:	00 00 00 
  800a1d:	41 ff d0             	call   *%r8
            panic("read /big@%ld: %ld", (long)i, (long)r);
  800a20:	49 89 c0             	mov    %rax,%r8
  800a23:	48 89 d9             	mov    %rbx,%rcx
  800a26:	48 ba a3 41 80 00 00 	movabs $0x8041a3,%rdx
  800a2d:	00 00 00 
  800a30:	be 74 00 00 00       	mov    $0x74,%esi
  800a35:	48 bf 26 40 80 00 00 	movabs $0x804026,%rdi
  800a3c:	00 00 00 
  800a3f:	b8 00 00 00 00       	mov    $0x0,%eax
  800a44:	49 b9 8f 0b 80 00 00 	movabs $0x800b8f,%r9
  800a4b:	00 00 00 
  800a4e:	41 ff d1             	call   *%r9
            panic("read /big from %ld returned %ld < %d bytes",
  800a51:	41 b9 00 02 00 00    	mov    $0x200,%r9d
  800a57:	49 89 c0             	mov    %rax,%r8
  800a5a:	48 89 d9             	mov    %rbx,%rcx
  800a5d:	48 ba b0 45 80 00 00 	movabs $0x8045b0,%rdx
  800a64:	00 00 00 
  800a67:	be 76 00 00 00       	mov    $0x76,%esi
  800a6c:	48 bf 26 40 80 00 00 	movabs $0x804026,%rdi
  800a73:	00 00 00 
  800a76:	b8 00 00 00 00       	mov    $0x0,%eax
  800a7b:	49 ba 8f 0b 80 00 00 	movabs $0x800b8f,%r10
  800a82:	00 00 00 
  800a85:	41 ff d2             	call   *%r10
            panic("read /big from %ld returned bad data %d",
  800a88:	48 89 d9             	mov    %rbx,%rcx
  800a8b:	48 ba e0 45 80 00 00 	movabs $0x8045e0,%rdx
  800a92:	00 00 00 
  800a95:	be 79 00 00 00       	mov    $0x79,%esi
  800a9a:	48 bf 26 40 80 00 00 	movabs $0x804026,%rdi
  800aa1:	00 00 00 
  800aa4:	b8 00 00 00 00       	mov    $0x0,%eax
  800aa9:	49 b9 8f 0b 80 00 00 	movabs $0x800b8f,%r9
  800ab0:	00 00 00 
  800ab3:	41 ff d1             	call   *%r9

0000000000800ab6 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  800ab6:	f3 0f 1e fa          	endbr64
  800aba:	55                   	push   %rbp
  800abb:	48 89 e5             	mov    %rsp,%rbp
  800abe:	41 56                	push   %r14
  800ac0:	41 55                	push   %r13
  800ac2:	41 54                	push   %r12
  800ac4:	53                   	push   %rbx
  800ac5:	41 89 fd             	mov    %edi,%r13d
  800ac8:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
     * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  800acb:	48 ba d8 50 80 00 00 	movabs $0x8050d8,%rdx
  800ad2:	00 00 00 
  800ad5:	48 b8 d8 50 80 00 00 	movabs $0x8050d8,%rax
  800adc:	00 00 00 
  800adf:	48 39 c2             	cmp    %rax,%rdx
  800ae2:	73 17                	jae    800afb <libmain+0x45>
    void (**ctor)() = &__ctors_start;
  800ae4:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  800ae7:	49 89 c4             	mov    %rax,%r12
  800aea:	48 83 c3 08          	add    $0x8,%rbx
  800aee:	b8 00 00 00 00       	mov    $0x0,%eax
  800af3:	ff 53 f8             	call   *-0x8(%rbx)
  800af6:	4c 39 e3             	cmp    %r12,%rbx
  800af9:	72 ef                	jb     800aea <libmain+0x34>

    /* Set thisenv to point at our Env structure in envs[]. */

    // LAB 8: Your code here
    thisenv = &((struct Env *)UENVS)[ENVX(sys_getenvid())];
  800afb:	48 b8 69 1b 80 00 00 	movabs $0x801b69,%rax
  800b02:	00 00 00 
  800b05:	ff d0                	call   *%rax
  800b07:	25 ff 03 00 00       	and    $0x3ff,%eax
  800b0c:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  800b10:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  800b14:	48 c1 e0 04          	shl    $0x4,%rax
  800b18:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  800b1f:	00 00 00 
  800b22:	48 01 d0             	add    %rdx,%rax
  800b25:	48 a3 00 60 80 00 00 	movabs %rax,0x806000
  800b2c:	00 00 00 

    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  800b2f:	45 85 ed             	test   %r13d,%r13d
  800b32:	7e 0d                	jle    800b41 <libmain+0x8b>
  800b34:	49 8b 06             	mov    (%r14),%rax
  800b37:	48 a3 08 50 80 00 00 	movabs %rax,0x805008
  800b3e:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  800b41:	4c 89 f6             	mov    %r14,%rsi
  800b44:	44 89 ef             	mov    %r13d,%edi
  800b47:	48 b8 bc 00 80 00 00 	movabs $0x8000bc,%rax
  800b4e:	00 00 00 
  800b51:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  800b53:	48 b8 68 0b 80 00 00 	movabs $0x800b68,%rax
  800b5a:	00 00 00 
  800b5d:	ff d0                	call   *%rax
#endif
}
  800b5f:	5b                   	pop    %rbx
  800b60:	41 5c                	pop    %r12
  800b62:	41 5d                	pop    %r13
  800b64:	41 5e                	pop    %r14
  800b66:	5d                   	pop    %rbp
  800b67:	c3                   	ret

0000000000800b68 <exit>:

#include <inc/lib.h>

void
exit(void) {
  800b68:	f3 0f 1e fa          	endbr64
  800b6c:	55                   	push   %rbp
  800b6d:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  800b70:	48 b8 f8 23 80 00 00 	movabs $0x8023f8,%rax
  800b77:	00 00 00 
  800b7a:	ff d0                	call   *%rax
    sys_env_destroy(0);
  800b7c:	bf 00 00 00 00       	mov    $0x0,%edi
  800b81:	48 b8 fa 1a 80 00 00 	movabs $0x801afa,%rax
  800b88:	00 00 00 
  800b8b:	ff d0                	call   *%rax
}
  800b8d:	5d                   	pop    %rbp
  800b8e:	c3                   	ret

0000000000800b8f <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  800b8f:	f3 0f 1e fa          	endbr64
  800b93:	55                   	push   %rbp
  800b94:	48 89 e5             	mov    %rsp,%rbp
  800b97:	41 56                	push   %r14
  800b99:	41 55                	push   %r13
  800b9b:	41 54                	push   %r12
  800b9d:	53                   	push   %rbx
  800b9e:	48 83 ec 50          	sub    $0x50,%rsp
  800ba2:	49 89 fc             	mov    %rdi,%r12
  800ba5:	41 89 f5             	mov    %esi,%r13d
  800ba8:	48 89 d3             	mov    %rdx,%rbx
  800bab:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800baf:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  800bb3:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800bb7:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  800bbe:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800bc2:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  800bc6:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  800bca:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  800bce:	48 b8 08 50 80 00 00 	movabs $0x805008,%rax
  800bd5:	00 00 00 
  800bd8:	4c 8b 30             	mov    (%rax),%r14
  800bdb:	48 b8 69 1b 80 00 00 	movabs $0x801b69,%rax
  800be2:	00 00 00 
  800be5:	ff d0                	call   *%rax
  800be7:	89 c6                	mov    %eax,%esi
  800be9:	45 89 e8             	mov    %r13d,%r8d
  800bec:	4c 89 e1             	mov    %r12,%rcx
  800bef:	4c 89 f2             	mov    %r14,%rdx
  800bf2:	48 bf 30 46 80 00 00 	movabs $0x804630,%rdi
  800bf9:	00 00 00 
  800bfc:	b8 00 00 00 00       	mov    $0x0,%eax
  800c01:	49 bc eb 0c 80 00 00 	movabs $0x800ceb,%r12
  800c08:	00 00 00 
  800c0b:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  800c0e:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  800c12:	48 89 df             	mov    %rbx,%rdi
  800c15:	48 b8 83 0c 80 00 00 	movabs $0x800c83,%rax
  800c1c:	00 00 00 
  800c1f:	ff d0                	call   *%rax
    cprintf("\n");
  800c21:	48 bf cc 40 80 00 00 	movabs $0x8040cc,%rdi
  800c28:	00 00 00 
  800c2b:	b8 00 00 00 00       	mov    $0x0,%eax
  800c30:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  800c33:	cc                   	int3
  800c34:	eb fd                	jmp    800c33 <_panic+0xa4>

0000000000800c36 <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  800c36:	f3 0f 1e fa          	endbr64
  800c3a:	55                   	push   %rbp
  800c3b:	48 89 e5             	mov    %rsp,%rbp
  800c3e:	53                   	push   %rbx
  800c3f:	48 83 ec 08          	sub    $0x8,%rsp
  800c43:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  800c46:	8b 06                	mov    (%rsi),%eax
  800c48:	8d 50 01             	lea    0x1(%rax),%edx
  800c4b:	89 16                	mov    %edx,(%rsi)
  800c4d:	48 98                	cltq
  800c4f:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  800c54:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  800c5a:	74 0a                	je     800c66 <putch+0x30>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  800c5c:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  800c60:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800c64:	c9                   	leave
  800c65:	c3                   	ret
        sys_cputs(state->buf, state->offset);
  800c66:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  800c6a:	be ff 00 00 00       	mov    $0xff,%esi
  800c6f:	48 b8 94 1a 80 00 00 	movabs $0x801a94,%rax
  800c76:	00 00 00 
  800c79:	ff d0                	call   *%rax
        state->offset = 0;
  800c7b:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  800c81:	eb d9                	jmp    800c5c <putch+0x26>

0000000000800c83 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  800c83:	f3 0f 1e fa          	endbr64
  800c87:	55                   	push   %rbp
  800c88:	48 89 e5             	mov    %rsp,%rbp
  800c8b:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800c92:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  800c95:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  800c9c:	b9 21 00 00 00       	mov    $0x21,%ecx
  800ca1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ca6:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  800ca9:	48 89 f1             	mov    %rsi,%rcx
  800cac:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  800cb3:	48 bf 36 0c 80 00 00 	movabs $0x800c36,%rdi
  800cba:	00 00 00 
  800cbd:	48 b8 4b 0e 80 00 00 	movabs $0x800e4b,%rax
  800cc4:	00 00 00 
  800cc7:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  800cc9:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  800cd0:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  800cd7:	48 b8 94 1a 80 00 00 	movabs $0x801a94,%rax
  800cde:	00 00 00 
  800ce1:	ff d0                	call   *%rax

    return state.count;
}
  800ce3:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  800ce9:	c9                   	leave
  800cea:	c3                   	ret

0000000000800ceb <cprintf>:

int
cprintf(const char *fmt, ...) {
  800ceb:	f3 0f 1e fa          	endbr64
  800cef:	55                   	push   %rbp
  800cf0:	48 89 e5             	mov    %rsp,%rbp
  800cf3:	48 83 ec 50          	sub    $0x50,%rsp
  800cf7:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  800cfb:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  800cff:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800d03:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800d07:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  800d0b:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  800d12:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d16:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800d1a:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800d1e:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  800d22:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  800d26:	48 b8 83 0c 80 00 00 	movabs $0x800c83,%rax
  800d2d:	00 00 00 
  800d30:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  800d32:	c9                   	leave
  800d33:	c3                   	ret

0000000000800d34 <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  800d34:	f3 0f 1e fa          	endbr64
  800d38:	55                   	push   %rbp
  800d39:	48 89 e5             	mov    %rsp,%rbp
  800d3c:	41 57                	push   %r15
  800d3e:	41 56                	push   %r14
  800d40:	41 55                	push   %r13
  800d42:	41 54                	push   %r12
  800d44:	53                   	push   %rbx
  800d45:	48 83 ec 18          	sub    $0x18,%rsp
  800d49:	49 89 fc             	mov    %rdi,%r12
  800d4c:	49 89 f5             	mov    %rsi,%r13
  800d4f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  800d53:	8b 45 10             	mov    0x10(%rbp),%eax
  800d56:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  800d59:	41 89 cf             	mov    %ecx,%r15d
  800d5c:	4c 39 fa             	cmp    %r15,%rdx
  800d5f:	73 5b                	jae    800dbc <print_num+0x88>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  800d61:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  800d65:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  800d69:	85 db                	test   %ebx,%ebx
  800d6b:	7e 0e                	jle    800d7b <print_num+0x47>
            putch(padc, put_arg);
  800d6d:	4c 89 ee             	mov    %r13,%rsi
  800d70:	44 89 f7             	mov    %r14d,%edi
  800d73:	41 ff d4             	call   *%r12
        while (--width > 0) {
  800d76:	83 eb 01             	sub    $0x1,%ebx
  800d79:	75 f2                	jne    800d6d <print_num+0x39>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  800d7b:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  800d7f:	48 b9 e5 41 80 00 00 	movabs $0x8041e5,%rcx
  800d86:	00 00 00 
  800d89:	48 b8 d4 41 80 00 00 	movabs $0x8041d4,%rax
  800d90:	00 00 00 
  800d93:	48 0f 45 c8          	cmovne %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  800d97:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d9b:	ba 00 00 00 00       	mov    $0x0,%edx
  800da0:	49 f7 f7             	div    %r15
  800da3:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  800da7:	4c 89 ee             	mov    %r13,%rsi
  800daa:	41 ff d4             	call   *%r12
}
  800dad:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800db1:	5b                   	pop    %rbx
  800db2:	41 5c                	pop    %r12
  800db4:	41 5d                	pop    %r13
  800db6:	41 5e                	pop    %r14
  800db8:	41 5f                	pop    %r15
  800dba:	5d                   	pop    %rbp
  800dbb:	c3                   	ret
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  800dbc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800dc0:	ba 00 00 00 00       	mov    $0x0,%edx
  800dc5:	49 f7 f7             	div    %r15
  800dc8:	48 83 ec 08          	sub    $0x8,%rsp
  800dcc:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  800dd0:	52                   	push   %rdx
  800dd1:	45 0f be c9          	movsbl %r9b,%r9d
  800dd5:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  800dd9:	48 89 c2             	mov    %rax,%rdx
  800ddc:	48 b8 34 0d 80 00 00 	movabs $0x800d34,%rax
  800de3:	00 00 00 
  800de6:	ff d0                	call   *%rax
  800de8:	48 83 c4 10          	add    $0x10,%rsp
  800dec:	eb 8d                	jmp    800d7b <print_num+0x47>

0000000000800dee <sprintputch>:
    char *end;
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
  800dee:	f3 0f 1e fa          	endbr64
    state->count++;
  800df2:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  800df6:	48 8b 06             	mov    (%rsi),%rax
  800df9:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  800dfd:	73 0a                	jae    800e09 <sprintputch+0x1b>
        *state->start++ = ch;
  800dff:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800e03:	48 89 16             	mov    %rdx,(%rsi)
  800e06:	40 88 38             	mov    %dil,(%rax)
    }
}
  800e09:	c3                   	ret

0000000000800e0a <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  800e0a:	f3 0f 1e fa          	endbr64
  800e0e:	55                   	push   %rbp
  800e0f:	48 89 e5             	mov    %rsp,%rbp
  800e12:	48 83 ec 50          	sub    $0x50,%rsp
  800e16:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800e1a:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800e1e:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  800e22:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800e29:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e2d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800e31:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800e35:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  800e39:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800e3d:	48 b8 4b 0e 80 00 00 	movabs $0x800e4b,%rax
  800e44:	00 00 00 
  800e47:	ff d0                	call   *%rax
}
  800e49:	c9                   	leave
  800e4a:	c3                   	ret

0000000000800e4b <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  800e4b:	f3 0f 1e fa          	endbr64
  800e4f:	55                   	push   %rbp
  800e50:	48 89 e5             	mov    %rsp,%rbp
  800e53:	41 57                	push   %r15
  800e55:	41 56                	push   %r14
  800e57:	41 55                	push   %r13
  800e59:	41 54                	push   %r12
  800e5b:	53                   	push   %rbx
  800e5c:	48 83 ec 38          	sub    $0x38,%rsp
  800e60:	49 89 fe             	mov    %rdi,%r14
  800e63:	49 89 f5             	mov    %rsi,%r13
  800e66:	48 89 d3             	mov    %rdx,%rbx
    va_copy(aq, ap);
  800e69:	48 8b 01             	mov    (%rcx),%rax
  800e6c:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  800e70:	48 8b 41 08          	mov    0x8(%rcx),%rax
  800e74:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800e78:	48 8b 41 10          	mov    0x10(%rcx),%rax
  800e7c:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  800e80:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  800e84:	0f b6 3b             	movzbl (%rbx),%edi
  800e87:	40 80 ff 25          	cmp    $0x25,%dil
  800e8b:	74 18                	je     800ea5 <vprintfmt+0x5a>
            if (!ch) return;
  800e8d:	40 84 ff             	test   %dil,%dil
  800e90:	0f 84 b2 06 00 00    	je     801548 <vprintfmt+0x6fd>
            putch(ch, put_arg);
  800e96:	40 0f b6 ff          	movzbl %dil,%edi
  800e9a:	4c 89 ee             	mov    %r13,%rsi
  800e9d:	41 ff d6             	call   *%r14
        while ((ch = *ufmt++) != '%') {
  800ea0:	4c 89 e3             	mov    %r12,%rbx
  800ea3:	eb db                	jmp    800e80 <vprintfmt+0x35>
        bool altflag = 0, zflag = 0;
  800ea5:	be 00 00 00 00       	mov    $0x0,%esi
  800eaa:	c6 45 ab 00          	movb   $0x0,-0x55(%rbp)
        unsigned lflag = 0, base = 10;
  800eae:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  800eb3:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  800eb9:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  800ec0:	c6 45 aa 20          	movb   $0x20,-0x56(%rbp)
        switch (ch = *ufmt++) {
  800ec4:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  800ec9:	41 0f b6 04 24       	movzbl (%r12),%eax
  800ece:	88 45 a0             	mov    %al,-0x60(%rbp)
  800ed1:	83 e8 23             	sub    $0x23,%eax
  800ed4:	3c 57                	cmp    $0x57,%al
  800ed6:	0f 87 52 06 00 00    	ja     80152e <vprintfmt+0x6e3>
  800edc:	0f b6 c0             	movzbl %al,%eax
  800edf:	48 b9 20 47 80 00 00 	movabs $0x804720,%rcx
  800ee6:	00 00 00 
  800ee9:	3e ff 24 c1          	notrack jmp *(%rcx,%rax,8)
  800eed:	49 89 dc             	mov    %rbx,%r12
            altflag = 1;
  800ef0:	c6 45 ab 01          	movb   $0x1,-0x55(%rbp)
  800ef4:	eb ce                	jmp    800ec4 <vprintfmt+0x79>
        switch (ch = *ufmt++) {
  800ef6:	49 89 dc             	mov    %rbx,%r12
  800ef9:	be 01 00 00 00       	mov    $0x1,%esi
  800efe:	eb c4                	jmp    800ec4 <vprintfmt+0x79>
            padc = ch;
  800f00:	0f b6 45 a0          	movzbl -0x60(%rbp),%eax
  800f04:	88 45 aa             	mov    %al,-0x56(%rbp)
        switch (ch = *ufmt++) {
  800f07:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  800f0a:	eb b8                	jmp    800ec4 <vprintfmt+0x79>
            precision = va_arg(aq, int);
  800f0c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f0f:	83 f8 2f             	cmp    $0x2f,%eax
  800f12:	77 24                	ja     800f38 <vprintfmt+0xed>
  800f14:	89 c1                	mov    %eax,%ecx
  800f16:	48 03 4d c8          	add    -0x38(%rbp),%rcx
  800f1a:	83 c0 08             	add    $0x8,%eax
  800f1d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800f20:	44 8b 39             	mov    (%rcx),%r15d
        switch (ch = *ufmt++) {
  800f23:	49 89 dc             	mov    %rbx,%r12
            if (width < 0) {
  800f26:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800f2a:	79 98                	jns    800ec4 <vprintfmt+0x79>
                width = precision;
  800f2c:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
                precision = -1;
  800f30:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  800f36:	eb 8c                	jmp    800ec4 <vprintfmt+0x79>
            precision = va_arg(aq, int);
  800f38:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  800f3c:	48 8d 41 08          	lea    0x8(%rcx),%rax
  800f40:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800f44:	eb da                	jmp    800f20 <vprintfmt+0xd5>
                precision = precision * 10 + ch - '0';
  800f46:	44 0f b6 7d a0       	movzbl -0x60(%rbp),%r15d
  800f4b:	41 83 ef 30          	sub    $0x30,%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  800f4f:	41 0f b6 44 24 01    	movzbl 0x1(%r12),%eax
  800f55:	3c 39                	cmp    $0x39,%al
  800f57:	77 1c                	ja     800f75 <vprintfmt+0x12a>
            for (precision = 0;; ++ufmt) {
  800f59:	48 83 c3 01          	add    $0x1,%rbx
                precision = precision * 10 + ch - '0';
  800f5d:	43 8d 0c bf          	lea    (%r15,%r15,4),%ecx
  800f61:	0f b6 c0             	movzbl %al,%eax
  800f64:	44 8d 7c 48 d0       	lea    -0x30(%rax,%rcx,2),%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  800f69:	0f b6 03             	movzbl (%rbx),%eax
  800f6c:	3c 39                	cmp    $0x39,%al
  800f6e:	76 e9                	jbe    800f59 <vprintfmt+0x10e>
        process_precision:
  800f70:	49 89 dc             	mov    %rbx,%r12
  800f73:	eb b1                	jmp    800f26 <vprintfmt+0xdb>
        switch (ch = *ufmt++) {
  800f75:	49 89 dc             	mov    %rbx,%r12
  800f78:	eb ac                	jmp    800f26 <vprintfmt+0xdb>
            width = MAX(0, width);
  800f7a:	8b 4d ac             	mov    -0x54(%rbp),%ecx
  800f7d:	85 c9                	test   %ecx,%ecx
  800f7f:	b8 00 00 00 00       	mov    $0x0,%eax
  800f84:	0f 49 c1             	cmovns %ecx,%eax
  800f87:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  800f8a:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  800f8d:	e9 32 ff ff ff       	jmp    800ec4 <vprintfmt+0x79>
            lflag++;
  800f92:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  800f95:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  800f98:	e9 27 ff ff ff       	jmp    800ec4 <vprintfmt+0x79>
            putch(va_arg(aq, int), put_arg);
  800f9d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800fa0:	83 f8 2f             	cmp    $0x2f,%eax
  800fa3:	77 19                	ja     800fbe <vprintfmt+0x173>
  800fa5:	89 c2                	mov    %eax,%edx
  800fa7:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800fab:	83 c0 08             	add    $0x8,%eax
  800fae:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800fb1:	8b 3a                	mov    (%rdx),%edi
  800fb3:	4c 89 ee             	mov    %r13,%rsi
  800fb6:	41 ff d6             	call   *%r14
            break;
  800fb9:	e9 c2 fe ff ff       	jmp    800e80 <vprintfmt+0x35>
            putch(va_arg(aq, int), put_arg);
  800fbe:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800fc2:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800fc6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800fca:	eb e5                	jmp    800fb1 <vprintfmt+0x166>
            int err = va_arg(aq, int);
  800fcc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800fcf:	83 f8 2f             	cmp    $0x2f,%eax
  800fd2:	77 5a                	ja     80102e <vprintfmt+0x1e3>
  800fd4:	89 c2                	mov    %eax,%edx
  800fd6:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800fda:	83 c0 08             	add    $0x8,%eax
  800fdd:	89 45 b8             	mov    %eax,-0x48(%rbp)
            if (err < 0) err = -err;
  800fe0:	8b 02                	mov    (%rdx),%eax
  800fe2:	89 c1                	mov    %eax,%ecx
  800fe4:	f7 d9                	neg    %ecx
  800fe6:	0f 48 c8             	cmovs  %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  800fe9:	83 f9 13             	cmp    $0x13,%ecx
  800fec:	7f 4e                	jg     80103c <vprintfmt+0x1f1>
  800fee:	48 63 c1             	movslq %ecx,%rax
  800ff1:	48 ba e0 49 80 00 00 	movabs $0x8049e0,%rdx
  800ff8:	00 00 00 
  800ffb:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  800fff:	48 85 c0             	test   %rax,%rax
  801002:	74 38                	je     80103c <vprintfmt+0x1f1>
                printfmt(putch, put_arg, "%s", strerr);
  801004:	48 89 c1             	mov    %rax,%rcx
  801007:	48 ba ee 43 80 00 00 	movabs $0x8043ee,%rdx
  80100e:	00 00 00 
  801011:	4c 89 ee             	mov    %r13,%rsi
  801014:	4c 89 f7             	mov    %r14,%rdi
  801017:	b8 00 00 00 00       	mov    $0x0,%eax
  80101c:	49 b8 0a 0e 80 00 00 	movabs $0x800e0a,%r8
  801023:	00 00 00 
  801026:	41 ff d0             	call   *%r8
  801029:	e9 52 fe ff ff       	jmp    800e80 <vprintfmt+0x35>
            int err = va_arg(aq, int);
  80102e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801032:	48 8d 42 08          	lea    0x8(%rdx),%rax
  801036:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80103a:	eb a4                	jmp    800fe0 <vprintfmt+0x195>
                printfmt(putch, put_arg, "error %d", err);
  80103c:	48 ba fd 41 80 00 00 	movabs $0x8041fd,%rdx
  801043:	00 00 00 
  801046:	4c 89 ee             	mov    %r13,%rsi
  801049:	4c 89 f7             	mov    %r14,%rdi
  80104c:	b8 00 00 00 00       	mov    $0x0,%eax
  801051:	49 b8 0a 0e 80 00 00 	movabs $0x800e0a,%r8
  801058:	00 00 00 
  80105b:	41 ff d0             	call   *%r8
  80105e:	e9 1d fe ff ff       	jmp    800e80 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  801063:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801066:	83 f8 2f             	cmp    $0x2f,%eax
  801069:	77 6c                	ja     8010d7 <vprintfmt+0x28c>
  80106b:	89 c2                	mov    %eax,%edx
  80106d:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  801071:	83 c0 08             	add    $0x8,%eax
  801074:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801077:	48 8b 12             	mov    (%rdx),%rdx
            if (!ptr) ptr = "(null)";
  80107a:	48 85 d2             	test   %rdx,%rdx
  80107d:	48 b8 f6 41 80 00 00 	movabs $0x8041f6,%rax
  801084:	00 00 00 
  801087:	48 0f 45 c2          	cmovne %rdx,%rax
  80108b:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
            if (width > 0 && padc != '-') {
  80108f:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  801093:	7e 06                	jle    80109b <vprintfmt+0x250>
  801095:	80 7d aa 2d          	cmpb   $0x2d,-0x56(%rbp)
  801099:	75 4a                	jne    8010e5 <vprintfmt+0x29a>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  80109b:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80109f:	4c 8d 60 01          	lea    0x1(%rax),%r12
  8010a3:	0f b6 00             	movzbl (%rax),%eax
  8010a6:	84 c0                	test   %al,%al
  8010a8:	0f 85 9a 00 00 00    	jne    801148 <vprintfmt+0x2fd>
            while (width-- > 0) putch(' ', put_arg);
  8010ae:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8010b1:	44 8d 60 ff          	lea    -0x1(%rax),%r12d
  8010b5:	85 c0                	test   %eax,%eax
  8010b7:	0f 8e c3 fd ff ff    	jle    800e80 <vprintfmt+0x35>
  8010bd:	4c 89 ee             	mov    %r13,%rsi
  8010c0:	bf 20 00 00 00       	mov    $0x20,%edi
  8010c5:	41 ff d6             	call   *%r14
  8010c8:	41 83 ec 01          	sub    $0x1,%r12d
  8010cc:	41 83 fc ff          	cmp    $0xffffffff,%r12d
  8010d0:	75 eb                	jne    8010bd <vprintfmt+0x272>
  8010d2:	e9 a9 fd ff ff       	jmp    800e80 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  8010d7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8010db:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8010df:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8010e3:	eb 92                	jmp    801077 <vprintfmt+0x22c>
                width -= strnlen(ptr, precision);
  8010e5:	49 63 f7             	movslq %r15d,%rsi
  8010e8:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  8010ec:	48 b8 0e 16 80 00 00 	movabs $0x80160e,%rax
  8010f3:	00 00 00 
  8010f6:	ff d0                	call   *%rax
  8010f8:	48 89 c2             	mov    %rax,%rdx
  8010fb:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8010fe:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  801100:	8d 70 ff             	lea    -0x1(%rax),%esi
  801103:	89 75 ac             	mov    %esi,-0x54(%rbp)
  801106:	85 c0                	test   %eax,%eax
  801108:	7e 91                	jle    80109b <vprintfmt+0x250>
  80110a:	44 0f be 65 aa       	movsbl -0x56(%rbp),%r12d
  80110f:	4c 89 ee             	mov    %r13,%rsi
  801112:	44 89 e7             	mov    %r12d,%edi
  801115:	41 ff d6             	call   *%r14
  801118:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  80111c:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80111f:	83 f8 ff             	cmp    $0xffffffff,%eax
  801122:	75 eb                	jne    80110f <vprintfmt+0x2c4>
  801124:	e9 72 ff ff ff       	jmp    80109b <vprintfmt+0x250>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  801129:	0f b6 f8             	movzbl %al,%edi
  80112c:	4c 89 ee             	mov    %r13,%rsi
  80112f:	41 ff d6             	call   *%r14
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  801132:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  801136:	49 83 c4 01          	add    $0x1,%r12
  80113a:	41 0f b6 44 24 ff    	movzbl -0x1(%r12),%eax
  801140:	84 c0                	test   %al,%al
  801142:	0f 84 66 ff ff ff    	je     8010ae <vprintfmt+0x263>
  801148:	45 85 ff             	test   %r15d,%r15d
  80114b:	78 0a                	js     801157 <vprintfmt+0x30c>
  80114d:	41 83 ef 01          	sub    $0x1,%r15d
  801151:	0f 88 57 ff ff ff    	js     8010ae <vprintfmt+0x263>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  801157:	80 7d ab 00          	cmpb   $0x0,-0x55(%rbp)
  80115b:	74 cc                	je     801129 <vprintfmt+0x2de>
  80115d:	8d 50 e0             	lea    -0x20(%rax),%edx
  801160:	bf 3f 00 00 00       	mov    $0x3f,%edi
  801165:	80 fa 5e             	cmp    $0x5e,%dl
  801168:	77 c2                	ja     80112c <vprintfmt+0x2e1>
  80116a:	eb bd                	jmp    801129 <vprintfmt+0x2de>
    if (zflag) return va_arg(*ap, size_t);
  80116c:	40 84 f6             	test   %sil,%sil
  80116f:	75 26                	jne    801197 <vprintfmt+0x34c>
    switch (lflag) {
  801171:	85 d2                	test   %edx,%edx
  801173:	74 59                	je     8011ce <vprintfmt+0x383>
  801175:	83 fa 01             	cmp    $0x1,%edx
  801178:	74 7b                	je     8011f5 <vprintfmt+0x3aa>
        return va_arg(*ap, long long);
  80117a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80117d:	83 f8 2f             	cmp    $0x2f,%eax
  801180:	0f 87 96 00 00 00    	ja     80121c <vprintfmt+0x3d1>
  801186:	89 c2                	mov    %eax,%edx
  801188:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80118c:	83 c0 08             	add    $0x8,%eax
  80118f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801192:	4c 8b 22             	mov    (%rdx),%r12
  801195:	eb 17                	jmp    8011ae <vprintfmt+0x363>
    if (zflag) return va_arg(*ap, size_t);
  801197:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80119a:	83 f8 2f             	cmp    $0x2f,%eax
  80119d:	77 21                	ja     8011c0 <vprintfmt+0x375>
  80119f:	89 c2                	mov    %eax,%edx
  8011a1:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8011a5:	83 c0 08             	add    $0x8,%eax
  8011a8:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8011ab:	4c 8b 22             	mov    (%rdx),%r12
            if (i < 0) {
  8011ae:	4d 85 e4             	test   %r12,%r12
  8011b1:	78 7a                	js     80122d <vprintfmt+0x3e2>
            num = i;
  8011b3:	4c 89 e2             	mov    %r12,%rdx
        unsigned lflag = 0, base = 10;
  8011b6:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  8011bb:	e9 50 02 00 00       	jmp    801410 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8011c0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8011c4:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8011c8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8011cc:	eb dd                	jmp    8011ab <vprintfmt+0x360>
        return va_arg(*ap, int);
  8011ce:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8011d1:	83 f8 2f             	cmp    $0x2f,%eax
  8011d4:	77 11                	ja     8011e7 <vprintfmt+0x39c>
  8011d6:	89 c2                	mov    %eax,%edx
  8011d8:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8011dc:	83 c0 08             	add    $0x8,%eax
  8011df:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8011e2:	4c 63 22             	movslq (%rdx),%r12
  8011e5:	eb c7                	jmp    8011ae <vprintfmt+0x363>
  8011e7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8011eb:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8011ef:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8011f3:	eb ed                	jmp    8011e2 <vprintfmt+0x397>
        return va_arg(*ap, long);
  8011f5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8011f8:	83 f8 2f             	cmp    $0x2f,%eax
  8011fb:	77 11                	ja     80120e <vprintfmt+0x3c3>
  8011fd:	89 c2                	mov    %eax,%edx
  8011ff:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  801203:	83 c0 08             	add    $0x8,%eax
  801206:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801209:	4c 8b 22             	mov    (%rdx),%r12
  80120c:	eb a0                	jmp    8011ae <vprintfmt+0x363>
  80120e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801212:	48 8d 42 08          	lea    0x8(%rdx),%rax
  801216:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80121a:	eb ed                	jmp    801209 <vprintfmt+0x3be>
        return va_arg(*ap, long long);
  80121c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801220:	48 8d 42 08          	lea    0x8(%rdx),%rax
  801224:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801228:	e9 65 ff ff ff       	jmp    801192 <vprintfmt+0x347>
                putch('-', put_arg);
  80122d:	4c 89 ee             	mov    %r13,%rsi
  801230:	bf 2d 00 00 00       	mov    $0x2d,%edi
  801235:	41 ff d6             	call   *%r14
                i = -i;
  801238:	49 f7 dc             	neg    %r12
  80123b:	e9 73 ff ff ff       	jmp    8011b3 <vprintfmt+0x368>
    if (zflag) return va_arg(*ap, size_t);
  801240:	40 84 f6             	test   %sil,%sil
  801243:	75 32                	jne    801277 <vprintfmt+0x42c>
    switch (lflag) {
  801245:	85 d2                	test   %edx,%edx
  801247:	74 5d                	je     8012a6 <vprintfmt+0x45b>
  801249:	83 fa 01             	cmp    $0x1,%edx
  80124c:	0f 84 82 00 00 00    	je     8012d4 <vprintfmt+0x489>
        return va_arg(*ap, unsigned long long);
  801252:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801255:	83 f8 2f             	cmp    $0x2f,%eax
  801258:	0f 87 a5 00 00 00    	ja     801303 <vprintfmt+0x4b8>
  80125e:	89 c2                	mov    %eax,%edx
  801260:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  801264:	83 c0 08             	add    $0x8,%eax
  801267:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80126a:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  80126d:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  801272:	e9 99 01 00 00       	jmp    801410 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  801277:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80127a:	83 f8 2f             	cmp    $0x2f,%eax
  80127d:	77 19                	ja     801298 <vprintfmt+0x44d>
  80127f:	89 c2                	mov    %eax,%edx
  801281:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  801285:	83 c0 08             	add    $0x8,%eax
  801288:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80128b:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  80128e:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  801293:	e9 78 01 00 00       	jmp    801410 <vprintfmt+0x5c5>
  801298:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80129c:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8012a0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8012a4:	eb e5                	jmp    80128b <vprintfmt+0x440>
        return va_arg(*ap, unsigned int);
  8012a6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8012a9:	83 f8 2f             	cmp    $0x2f,%eax
  8012ac:	77 18                	ja     8012c6 <vprintfmt+0x47b>
  8012ae:	89 c2                	mov    %eax,%edx
  8012b0:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8012b4:	83 c0 08             	add    $0x8,%eax
  8012b7:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8012ba:	8b 12                	mov    (%rdx),%edx
        unsigned lflag = 0, base = 10;
  8012bc:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  8012c1:	e9 4a 01 00 00       	jmp    801410 <vprintfmt+0x5c5>
  8012c6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8012ca:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8012ce:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8012d2:	eb e6                	jmp    8012ba <vprintfmt+0x46f>
        return va_arg(*ap, unsigned long);
  8012d4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8012d7:	83 f8 2f             	cmp    $0x2f,%eax
  8012da:	77 19                	ja     8012f5 <vprintfmt+0x4aa>
  8012dc:	89 c2                	mov    %eax,%edx
  8012de:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8012e2:	83 c0 08             	add    $0x8,%eax
  8012e5:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8012e8:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  8012eb:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  8012f0:	e9 1b 01 00 00       	jmp    801410 <vprintfmt+0x5c5>
  8012f5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8012f9:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8012fd:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801301:	eb e5                	jmp    8012e8 <vprintfmt+0x49d>
        return va_arg(*ap, unsigned long long);
  801303:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801307:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80130b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80130f:	e9 56 ff ff ff       	jmp    80126a <vprintfmt+0x41f>
    if (zflag) return va_arg(*ap, size_t);
  801314:	40 84 f6             	test   %sil,%sil
  801317:	75 2e                	jne    801347 <vprintfmt+0x4fc>
    switch (lflag) {
  801319:	85 d2                	test   %edx,%edx
  80131b:	74 59                	je     801376 <vprintfmt+0x52b>
  80131d:	83 fa 01             	cmp    $0x1,%edx
  801320:	74 7f                	je     8013a1 <vprintfmt+0x556>
        return va_arg(*ap, unsigned long long);
  801322:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801325:	83 f8 2f             	cmp    $0x2f,%eax
  801328:	0f 87 9f 00 00 00    	ja     8013cd <vprintfmt+0x582>
  80132e:	89 c2                	mov    %eax,%edx
  801330:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  801334:	83 c0 08             	add    $0x8,%eax
  801337:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80133a:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  80133d:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  801342:	e9 c9 00 00 00       	jmp    801410 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  801347:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80134a:	83 f8 2f             	cmp    $0x2f,%eax
  80134d:	77 19                	ja     801368 <vprintfmt+0x51d>
  80134f:	89 c2                	mov    %eax,%edx
  801351:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  801355:	83 c0 08             	add    $0x8,%eax
  801358:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80135b:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  80135e:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  801363:	e9 a8 00 00 00       	jmp    801410 <vprintfmt+0x5c5>
  801368:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80136c:	48 8d 42 08          	lea    0x8(%rdx),%rax
  801370:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801374:	eb e5                	jmp    80135b <vprintfmt+0x510>
        return va_arg(*ap, unsigned int);
  801376:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801379:	83 f8 2f             	cmp    $0x2f,%eax
  80137c:	77 15                	ja     801393 <vprintfmt+0x548>
  80137e:	89 c2                	mov    %eax,%edx
  801380:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  801384:	83 c0 08             	add    $0x8,%eax
  801387:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80138a:	8b 12                	mov    (%rdx),%edx
            base = 8;
  80138c:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  801391:	eb 7d                	jmp    801410 <vprintfmt+0x5c5>
  801393:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801397:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80139b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80139f:	eb e9                	jmp    80138a <vprintfmt+0x53f>
        return va_arg(*ap, unsigned long);
  8013a1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8013a4:	83 f8 2f             	cmp    $0x2f,%eax
  8013a7:	77 16                	ja     8013bf <vprintfmt+0x574>
  8013a9:	89 c2                	mov    %eax,%edx
  8013ab:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8013af:	83 c0 08             	add    $0x8,%eax
  8013b2:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8013b5:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  8013b8:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  8013bd:	eb 51                	jmp    801410 <vprintfmt+0x5c5>
  8013bf:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8013c3:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8013c7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8013cb:	eb e8                	jmp    8013b5 <vprintfmt+0x56a>
        return va_arg(*ap, unsigned long long);
  8013cd:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8013d1:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8013d5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8013d9:	e9 5c ff ff ff       	jmp    80133a <vprintfmt+0x4ef>
            putch('0', put_arg);
  8013de:	4c 89 ee             	mov    %r13,%rsi
  8013e1:	bf 30 00 00 00       	mov    $0x30,%edi
  8013e6:	41 ff d6             	call   *%r14
            putch('x', put_arg);
  8013e9:	4c 89 ee             	mov    %r13,%rsi
  8013ec:	bf 78 00 00 00       	mov    $0x78,%edi
  8013f1:	41 ff d6             	call   *%r14
            num = (uintptr_t)va_arg(aq, void *);
  8013f4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8013f7:	83 f8 2f             	cmp    $0x2f,%eax
  8013fa:	77 47                	ja     801443 <vprintfmt+0x5f8>
  8013fc:	89 c2                	mov    %eax,%edx
  8013fe:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  801402:	83 c0 08             	add    $0x8,%eax
  801405:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801408:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  80140b:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  801410:	48 83 ec 08          	sub    $0x8,%rsp
  801414:	80 7d a0 58          	cmpb   $0x58,-0x60(%rbp)
  801418:	0f 94 c0             	sete   %al
  80141b:	0f b6 c0             	movzbl %al,%eax
  80141e:	50                   	push   %rax
  80141f:	44 0f be 4d aa       	movsbl -0x56(%rbp),%r9d
  801424:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  801428:	4c 89 ee             	mov    %r13,%rsi
  80142b:	4c 89 f7             	mov    %r14,%rdi
  80142e:	48 b8 34 0d 80 00 00 	movabs $0x800d34,%rax
  801435:	00 00 00 
  801438:	ff d0                	call   *%rax
            break;
  80143a:	48 83 c4 10          	add    $0x10,%rsp
  80143e:	e9 3d fa ff ff       	jmp    800e80 <vprintfmt+0x35>
            num = (uintptr_t)va_arg(aq, void *);
  801443:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801447:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80144b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80144f:	eb b7                	jmp    801408 <vprintfmt+0x5bd>
    if (zflag) return va_arg(*ap, size_t);
  801451:	40 84 f6             	test   %sil,%sil
  801454:	75 2b                	jne    801481 <vprintfmt+0x636>
    switch (lflag) {
  801456:	85 d2                	test   %edx,%edx
  801458:	74 56                	je     8014b0 <vprintfmt+0x665>
  80145a:	83 fa 01             	cmp    $0x1,%edx
  80145d:	74 7f                	je     8014de <vprintfmt+0x693>
        return va_arg(*ap, unsigned long long);
  80145f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801462:	83 f8 2f             	cmp    $0x2f,%eax
  801465:	0f 87 a2 00 00 00    	ja     80150d <vprintfmt+0x6c2>
  80146b:	89 c2                	mov    %eax,%edx
  80146d:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  801471:	83 c0 08             	add    $0x8,%eax
  801474:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801477:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  80147a:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  80147f:	eb 8f                	jmp    801410 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  801481:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801484:	83 f8 2f             	cmp    $0x2f,%eax
  801487:	77 19                	ja     8014a2 <vprintfmt+0x657>
  801489:	89 c2                	mov    %eax,%edx
  80148b:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80148f:	83 c0 08             	add    $0x8,%eax
  801492:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801495:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  801498:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  80149d:	e9 6e ff ff ff       	jmp    801410 <vprintfmt+0x5c5>
  8014a2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8014a6:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8014aa:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8014ae:	eb e5                	jmp    801495 <vprintfmt+0x64a>
        return va_arg(*ap, unsigned int);
  8014b0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8014b3:	83 f8 2f             	cmp    $0x2f,%eax
  8014b6:	77 18                	ja     8014d0 <vprintfmt+0x685>
  8014b8:	89 c2                	mov    %eax,%edx
  8014ba:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8014be:	83 c0 08             	add    $0x8,%eax
  8014c1:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8014c4:	8b 12                	mov    (%rdx),%edx
            base = 16;
  8014c6:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  8014cb:	e9 40 ff ff ff       	jmp    801410 <vprintfmt+0x5c5>
  8014d0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8014d4:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8014d8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8014dc:	eb e6                	jmp    8014c4 <vprintfmt+0x679>
        return va_arg(*ap, unsigned long);
  8014de:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8014e1:	83 f8 2f             	cmp    $0x2f,%eax
  8014e4:	77 19                	ja     8014ff <vprintfmt+0x6b4>
  8014e6:	89 c2                	mov    %eax,%edx
  8014e8:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8014ec:	83 c0 08             	add    $0x8,%eax
  8014ef:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8014f2:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  8014f5:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  8014fa:	e9 11 ff ff ff       	jmp    801410 <vprintfmt+0x5c5>
  8014ff:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801503:	48 8d 42 08          	lea    0x8(%rdx),%rax
  801507:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80150b:	eb e5                	jmp    8014f2 <vprintfmt+0x6a7>
        return va_arg(*ap, unsigned long long);
  80150d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801511:	48 8d 42 08          	lea    0x8(%rdx),%rax
  801515:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801519:	e9 59 ff ff ff       	jmp    801477 <vprintfmt+0x62c>
            putch(ch, put_arg);
  80151e:	4c 89 ee             	mov    %r13,%rsi
  801521:	bf 25 00 00 00       	mov    $0x25,%edi
  801526:	41 ff d6             	call   *%r14
            break;
  801529:	e9 52 f9 ff ff       	jmp    800e80 <vprintfmt+0x35>
            putch('%', put_arg);
  80152e:	4c 89 ee             	mov    %r13,%rsi
  801531:	bf 25 00 00 00       	mov    $0x25,%edi
  801536:	41 ff d6             	call   *%r14
            while ((--ufmt)[-1] != '%') /* nothing */
  801539:	48 83 eb 01          	sub    $0x1,%rbx
  80153d:	80 7b ff 25          	cmpb   $0x25,-0x1(%rbx)
  801541:	75 f6                	jne    801539 <vprintfmt+0x6ee>
  801543:	e9 38 f9 ff ff       	jmp    800e80 <vprintfmt+0x35>
}
  801548:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  80154c:	5b                   	pop    %rbx
  80154d:	41 5c                	pop    %r12
  80154f:	41 5d                	pop    %r13
  801551:	41 5e                	pop    %r14
  801553:	41 5f                	pop    %r15
  801555:	5d                   	pop    %rbp
  801556:	c3                   	ret

0000000000801557 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  801557:	f3 0f 1e fa          	endbr64
  80155b:	55                   	push   %rbp
  80155c:	48 89 e5             	mov    %rsp,%rbp
  80155f:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  801563:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801567:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  80156c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  801570:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  801577:	48 85 ff             	test   %rdi,%rdi
  80157a:	74 2b                	je     8015a7 <vsnprintf+0x50>
  80157c:	48 85 f6             	test   %rsi,%rsi
  80157f:	74 26                	je     8015a7 <vsnprintf+0x50>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  801581:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801585:	48 bf ee 0d 80 00 00 	movabs $0x800dee,%rdi
  80158c:	00 00 00 
  80158f:	48 b8 4b 0e 80 00 00 	movabs $0x800e4b,%rax
  801596:	00 00 00 
  801599:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  80159b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80159f:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  8015a2:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8015a5:	c9                   	leave
  8015a6:	c3                   	ret
    if (!buf || n < 1) return -E_INVAL;
  8015a7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015ac:	eb f7                	jmp    8015a5 <vsnprintf+0x4e>

00000000008015ae <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  8015ae:	f3 0f 1e fa          	endbr64
  8015b2:	55                   	push   %rbp
  8015b3:	48 89 e5             	mov    %rsp,%rbp
  8015b6:	48 83 ec 50          	sub    $0x50,%rsp
  8015ba:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8015be:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8015c2:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  8015c6:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  8015cd:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8015d1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8015d5:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8015d9:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  8015dd:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  8015e1:	48 b8 57 15 80 00 00 	movabs $0x801557,%rax
  8015e8:	00 00 00 
  8015eb:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  8015ed:	c9                   	leave
  8015ee:	c3                   	ret

00000000008015ef <strlen>:
 * Primespipe runs 3x faster this way */

#define ASM 1

size_t
strlen(const char *s) {
  8015ef:	f3 0f 1e fa          	endbr64
    size_t n = 0;
    while (*s++) n++;
  8015f3:	80 3f 00             	cmpb   $0x0,(%rdi)
  8015f6:	74 10                	je     801608 <strlen+0x19>
    size_t n = 0;
  8015f8:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  8015fd:	48 83 c0 01          	add    $0x1,%rax
  801601:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  801605:	75 f6                	jne    8015fd <strlen+0xe>
  801607:	c3                   	ret
    size_t n = 0;
  801608:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  80160d:	c3                   	ret

000000000080160e <strnlen>:

size_t
strnlen(const char *s, size_t size) {
  80160e:	f3 0f 1e fa          	endbr64
  801612:	48 89 f0             	mov    %rsi,%rax
    size_t n = 0;
  801615:	ba 00 00 00 00       	mov    $0x0,%edx
    while (n < size && *s++) n++;
  80161a:	48 85 f6             	test   %rsi,%rsi
  80161d:	74 10                	je     80162f <strnlen+0x21>
  80161f:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  801623:	74 0b                	je     801630 <strnlen+0x22>
  801625:	48 83 c2 01          	add    $0x1,%rdx
  801629:	48 39 d0             	cmp    %rdx,%rax
  80162c:	75 f1                	jne    80161f <strnlen+0x11>
  80162e:	c3                   	ret
  80162f:	c3                   	ret
  801630:	48 89 d0             	mov    %rdx,%rax
    return n;
}
  801633:	c3                   	ret

0000000000801634 <strcpy>:

char *
strcpy(char *dst, const char *src) {
  801634:	f3 0f 1e fa          	endbr64
  801638:	48 89 f8             	mov    %rdi,%rax
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  80163b:	ba 00 00 00 00       	mov    $0x0,%edx
  801640:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  801644:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  801647:	48 83 c2 01          	add    $0x1,%rdx
  80164b:	84 c9                	test   %cl,%cl
  80164d:	75 f1                	jne    801640 <strcpy+0xc>
        ;
    return res;
}
  80164f:	c3                   	ret

0000000000801650 <strcat>:

char *
strcat(char *dst, const char *src) {
  801650:	f3 0f 1e fa          	endbr64
  801654:	55                   	push   %rbp
  801655:	48 89 e5             	mov    %rsp,%rbp
  801658:	41 54                	push   %r12
  80165a:	53                   	push   %rbx
  80165b:	48 89 fb             	mov    %rdi,%rbx
  80165e:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  801661:	48 b8 ef 15 80 00 00 	movabs $0x8015ef,%rax
  801668:	00 00 00 
  80166b:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  80166d:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  801671:	4c 89 e6             	mov    %r12,%rsi
  801674:	48 b8 34 16 80 00 00 	movabs $0x801634,%rax
  80167b:	00 00 00 
  80167e:	ff d0                	call   *%rax
    return dst;
}
  801680:	48 89 d8             	mov    %rbx,%rax
  801683:	5b                   	pop    %rbx
  801684:	41 5c                	pop    %r12
  801686:	5d                   	pop    %rbp
  801687:	c3                   	ret

0000000000801688 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801688:	f3 0f 1e fa          	endbr64
  80168c:	48 89 f8             	mov    %rdi,%rax
    char *ret = dst;
    while (size-- > 0) {
  80168f:	48 85 d2             	test   %rdx,%rdx
  801692:	74 1f                	je     8016b3 <strncpy+0x2b>
  801694:	48 01 fa             	add    %rdi,%rdx
  801697:	48 89 f9             	mov    %rdi,%rcx
        *dst++ = *src;
  80169a:	48 83 c1 01          	add    $0x1,%rcx
  80169e:	44 0f b6 06          	movzbl (%rsi),%r8d
  8016a2:	44 88 41 ff          	mov    %r8b,-0x1(%rcx)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  8016a6:	41 80 f8 01          	cmp    $0x1,%r8b
  8016aa:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  8016ae:	48 39 ca             	cmp    %rcx,%rdx
  8016b1:	75 e7                	jne    80169a <strncpy+0x12>
    }
    return ret;
}
  8016b3:	c3                   	ret

00000000008016b4 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
  8016b4:	f3 0f 1e fa          	endbr64
    char *dst_in = dst;
    if (size) {
  8016b8:	48 89 f8             	mov    %rdi,%rax
  8016bb:	48 85 d2             	test   %rdx,%rdx
  8016be:	74 24                	je     8016e4 <strlcpy+0x30>
        while (--size > 0 && *src)
  8016c0:	48 83 ea 01          	sub    $0x1,%rdx
  8016c4:	74 1b                	je     8016e1 <strlcpy+0x2d>
  8016c6:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  8016ca:	0f b6 16             	movzbl (%rsi),%edx
  8016cd:	84 d2                	test   %dl,%dl
  8016cf:	74 10                	je     8016e1 <strlcpy+0x2d>
            *dst++ = *src++;
  8016d1:	48 83 c6 01          	add    $0x1,%rsi
  8016d5:	48 83 c0 01          	add    $0x1,%rax
  8016d9:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  8016dc:	48 39 c8             	cmp    %rcx,%rax
  8016df:	75 e9                	jne    8016ca <strlcpy+0x16>
        *dst = '\0';
  8016e1:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  8016e4:	48 29 f8             	sub    %rdi,%rax
}
  8016e7:	c3                   	ret

00000000008016e8 <strcmp>:
    }
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
  8016e8:	f3 0f 1e fa          	endbr64
    while (*p && *p == *q) p++, q++;
  8016ec:	0f b6 07             	movzbl (%rdi),%eax
  8016ef:	84 c0                	test   %al,%al
  8016f1:	74 13                	je     801706 <strcmp+0x1e>
  8016f3:	38 06                	cmp    %al,(%rsi)
  8016f5:	75 0f                	jne    801706 <strcmp+0x1e>
  8016f7:	48 83 c7 01          	add    $0x1,%rdi
  8016fb:	48 83 c6 01          	add    $0x1,%rsi
  8016ff:	0f b6 07             	movzbl (%rdi),%eax
  801702:	84 c0                	test   %al,%al
  801704:	75 ed                	jne    8016f3 <strcmp+0xb>
    return (int)((unsigned char)*p - (unsigned char)*q);
  801706:	0f b6 c0             	movzbl %al,%eax
  801709:	0f b6 16             	movzbl (%rsi),%edx
  80170c:	29 d0                	sub    %edx,%eax
}
  80170e:	c3                   	ret

000000000080170f <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
  80170f:	f3 0f 1e fa          	endbr64
    while (n && *p && *p == *q) n--, p++, q++;
  801713:	48 85 d2             	test   %rdx,%rdx
  801716:	74 1f                	je     801737 <strncmp+0x28>
  801718:	0f b6 07             	movzbl (%rdi),%eax
  80171b:	84 c0                	test   %al,%al
  80171d:	74 1e                	je     80173d <strncmp+0x2e>
  80171f:	3a 06                	cmp    (%rsi),%al
  801721:	75 1a                	jne    80173d <strncmp+0x2e>
  801723:	48 83 c7 01          	add    $0x1,%rdi
  801727:	48 83 c6 01          	add    $0x1,%rsi
  80172b:	48 83 ea 01          	sub    $0x1,%rdx
  80172f:	75 e7                	jne    801718 <strncmp+0x9>

    if (!n) return 0;
  801731:	b8 00 00 00 00       	mov    $0x0,%eax
  801736:	c3                   	ret
  801737:	b8 00 00 00 00       	mov    $0x0,%eax
  80173c:	c3                   	ret

    return (int)((unsigned char)*p - (unsigned char)*q);
  80173d:	0f b6 07             	movzbl (%rdi),%eax
  801740:	0f b6 16             	movzbl (%rsi),%edx
  801743:	29 d0                	sub    %edx,%eax
}
  801745:	c3                   	ret

0000000000801746 <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
  801746:	f3 0f 1e fa          	endbr64
    for (; *str; str++) {
  80174a:	0f b6 17             	movzbl (%rdi),%edx
  80174d:	84 d2                	test   %dl,%dl
  80174f:	74 18                	je     801769 <strchr+0x23>
        if (*str == c) {
  801751:	0f be d2             	movsbl %dl,%edx
  801754:	39 f2                	cmp    %esi,%edx
  801756:	74 17                	je     80176f <strchr+0x29>
    for (; *str; str++) {
  801758:	48 83 c7 01          	add    $0x1,%rdi
  80175c:	0f b6 17             	movzbl (%rdi),%edx
  80175f:	84 d2                	test   %dl,%dl
  801761:	75 ee                	jne    801751 <strchr+0xb>
            return (char *)str;
        }
    }
    return NULL;
  801763:	b8 00 00 00 00       	mov    $0x0,%eax
  801768:	c3                   	ret
  801769:	b8 00 00 00 00       	mov    $0x0,%eax
  80176e:	c3                   	ret
            return (char *)str;
  80176f:	48 89 f8             	mov    %rdi,%rax
}
  801772:	c3                   	ret

0000000000801773 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
  801773:	f3 0f 1e fa          	endbr64
  801777:	48 89 f8             	mov    %rdi,%rax
    for (; *str && *str != ch; str++) /* nothing */
  80177a:	0f b6 17             	movzbl (%rdi),%edx
  80177d:	84 d2                	test   %dl,%dl
  80177f:	74 13                	je     801794 <strfind+0x21>
  801781:	0f be d2             	movsbl %dl,%edx
  801784:	39 f2                	cmp    %esi,%edx
  801786:	74 0b                	je     801793 <strfind+0x20>
  801788:	48 83 c0 01          	add    $0x1,%rax
  80178c:	0f b6 10             	movzbl (%rax),%edx
  80178f:	84 d2                	test   %dl,%dl
  801791:	75 ee                	jne    801781 <strfind+0xe>
        ;
    return (char *)str;
}
  801793:	c3                   	ret
  801794:	c3                   	ret

0000000000801795 <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  801795:	f3 0f 1e fa          	endbr64
  801799:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  80179c:	48 89 f8             	mov    %rdi,%rax
  80179f:	48 f7 d8             	neg    %rax
  8017a2:	83 e0 07             	and    $0x7,%eax
  8017a5:	49 89 d1             	mov    %rdx,%r9
  8017a8:	49 29 c1             	sub    %rax,%r9
  8017ab:	78 36                	js     8017e3 <memset+0x4e>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  8017ad:	40 0f b6 c6          	movzbl %sil,%eax
  8017b1:	48 b9 01 01 01 01 01 	movabs $0x101010101010101,%rcx
  8017b8:	01 01 01 
  8017bb:	48 0f af c1          	imul   %rcx,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  8017bf:	40 f6 c7 07          	test   $0x7,%dil
  8017c3:	75 38                	jne    8017fd <memset+0x68>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  8017c5:	4c 89 c9             	mov    %r9,%rcx
  8017c8:	48 c1 f9 03          	sar    $0x3,%rcx
  8017cc:	74 0c                	je     8017da <memset+0x45>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  8017ce:	fc                   	cld
  8017cf:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  8017d2:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  8017d6:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  8017da:	4d 85 c9             	test   %r9,%r9
  8017dd:	75 45                	jne    801824 <memset+0x8f>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  8017df:	4c 89 c0             	mov    %r8,%rax
  8017e2:	c3                   	ret
        while (n-- > 0) *ptr++ = c;
  8017e3:	48 85 d2             	test   %rdx,%rdx
  8017e6:	74 f7                	je     8017df <memset+0x4a>
  8017e8:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  8017eb:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  8017ee:	48 83 c0 01          	add    $0x1,%rax
  8017f2:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  8017f6:	48 39 c2             	cmp    %rax,%rdx
  8017f9:	75 f3                	jne    8017ee <memset+0x59>
  8017fb:	eb e2                	jmp    8017df <memset+0x4a>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  8017fd:	40 f6 c7 01          	test   $0x1,%dil
  801801:	74 06                	je     801809 <memset+0x74>
  801803:	88 07                	mov    %al,(%rdi)
  801805:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  801809:	40 f6 c7 02          	test   $0x2,%dil
  80180d:	74 07                	je     801816 <memset+0x81>
  80180f:	66 89 07             	mov    %ax,(%rdi)
  801812:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  801816:	40 f6 c7 04          	test   $0x4,%dil
  80181a:	74 a9                	je     8017c5 <memset+0x30>
  80181c:	89 07                	mov    %eax,(%rdi)
  80181e:	48 83 c7 04          	add    $0x4,%rdi
  801822:	eb a1                	jmp    8017c5 <memset+0x30>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  801824:	41 f6 c1 04          	test   $0x4,%r9b
  801828:	74 1b                	je     801845 <memset+0xb0>
  80182a:	89 07                	mov    %eax,(%rdi)
  80182c:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  801830:	41 f6 c1 02          	test   $0x2,%r9b
  801834:	74 07                	je     80183d <memset+0xa8>
  801836:	66 89 07             	mov    %ax,(%rdi)
  801839:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  80183d:	41 f6 c1 01          	test   $0x1,%r9b
  801841:	74 9c                	je     8017df <memset+0x4a>
  801843:	eb 06                	jmp    80184b <memset+0xb6>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  801845:	41 f6 c1 02          	test   $0x2,%r9b
  801849:	75 eb                	jne    801836 <memset+0xa1>
        if (ni & 1) *ptr = k;
  80184b:	88 07                	mov    %al,(%rdi)
  80184d:	eb 90                	jmp    8017df <memset+0x4a>

000000000080184f <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  80184f:	f3 0f 1e fa          	endbr64
  801853:	48 89 f8             	mov    %rdi,%rax
  801856:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  801859:	48 39 fe             	cmp    %rdi,%rsi
  80185c:	73 3b                	jae    801899 <memmove+0x4a>
  80185e:	48 8d 14 16          	lea    (%rsi,%rdx,1),%rdx
  801862:	48 39 d7             	cmp    %rdx,%rdi
  801865:	73 32                	jae    801899 <memmove+0x4a>
        s += n;
        d += n;
  801867:	48 8d 3c 0f          	lea    (%rdi,%rcx,1),%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  80186b:	48 89 d6             	mov    %rdx,%rsi
  80186e:	48 09 fe             	or     %rdi,%rsi
  801871:	48 09 ce             	or     %rcx,%rsi
  801874:	40 f6 c6 07          	test   $0x7,%sil
  801878:	75 12                	jne    80188c <memmove+0x3d>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  80187a:	48 83 ef 08          	sub    $0x8,%rdi
  80187e:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  801882:	48 c1 e9 03          	shr    $0x3,%rcx
  801886:	fd                   	std
  801887:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  80188a:	fc                   	cld
  80188b:	c3                   	ret
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  80188c:	48 83 ef 01          	sub    $0x1,%rdi
  801890:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  801894:	fd                   	std
  801895:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  801897:	eb f1                	jmp    80188a <memmove+0x3b>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  801899:	48 89 f2             	mov    %rsi,%rdx
  80189c:	48 09 c2             	or     %rax,%rdx
  80189f:	48 09 ca             	or     %rcx,%rdx
  8018a2:	f6 c2 07             	test   $0x7,%dl
  8018a5:	75 0c                	jne    8018b3 <memmove+0x64>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  8018a7:	48 c1 e9 03          	shr    $0x3,%rcx
  8018ab:	48 89 c7             	mov    %rax,%rdi
  8018ae:	fc                   	cld
  8018af:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  8018b2:	c3                   	ret
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  8018b3:	48 89 c7             	mov    %rax,%rdi
  8018b6:	fc                   	cld
  8018b7:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  8018b9:	c3                   	ret

00000000008018ba <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  8018ba:	f3 0f 1e fa          	endbr64
  8018be:	55                   	push   %rbp
  8018bf:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  8018c2:	48 b8 4f 18 80 00 00 	movabs $0x80184f,%rax
  8018c9:	00 00 00 
  8018cc:	ff d0                	call   *%rax
}
  8018ce:	5d                   	pop    %rbp
  8018cf:	c3                   	ret

00000000008018d0 <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  8018d0:	f3 0f 1e fa          	endbr64
  8018d4:	55                   	push   %rbp
  8018d5:	48 89 e5             	mov    %rsp,%rbp
  8018d8:	41 57                	push   %r15
  8018da:	41 56                	push   %r14
  8018dc:	41 55                	push   %r13
  8018de:	41 54                	push   %r12
  8018e0:	53                   	push   %rbx
  8018e1:	48 83 ec 08          	sub    $0x8,%rsp
  8018e5:	49 89 fe             	mov    %rdi,%r14
  8018e8:	49 89 f7             	mov    %rsi,%r15
  8018eb:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  8018ee:	48 89 f7             	mov    %rsi,%rdi
  8018f1:	48 b8 ef 15 80 00 00 	movabs $0x8015ef,%rax
  8018f8:	00 00 00 
  8018fb:	ff d0                	call   *%rax
  8018fd:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  801900:	48 89 de             	mov    %rbx,%rsi
  801903:	4c 89 f7             	mov    %r14,%rdi
  801906:	48 b8 0e 16 80 00 00 	movabs $0x80160e,%rax
  80190d:	00 00 00 
  801910:	ff d0                	call   *%rax
  801912:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  801915:	48 39 c3             	cmp    %rax,%rbx
  801918:	74 36                	je     801950 <strlcat+0x80>
    if (srclen < maxlen - dstlen) {
  80191a:	48 89 d8             	mov    %rbx,%rax
  80191d:	4c 29 e8             	sub    %r13,%rax
  801920:	49 39 c4             	cmp    %rax,%r12
  801923:	73 31                	jae    801956 <strlcat+0x86>
        memcpy(dst + dstlen, src, srclen + 1);
  801925:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  80192a:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  80192e:	4c 89 fe             	mov    %r15,%rsi
  801931:	48 b8 ba 18 80 00 00 	movabs $0x8018ba,%rax
  801938:	00 00 00 
  80193b:	ff d0                	call   *%rax
    return dstlen + srclen;
  80193d:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  801941:	48 83 c4 08          	add    $0x8,%rsp
  801945:	5b                   	pop    %rbx
  801946:	41 5c                	pop    %r12
  801948:	41 5d                	pop    %r13
  80194a:	41 5e                	pop    %r14
  80194c:	41 5f                	pop    %r15
  80194e:	5d                   	pop    %rbp
  80194f:	c3                   	ret
    if (dstlen == maxlen) return maxlen + srclen;
  801950:	49 8d 04 04          	lea    (%r12,%rax,1),%rax
  801954:	eb eb                	jmp    801941 <strlcat+0x71>
        memcpy(dst + dstlen, src, maxlen - 1);
  801956:	48 83 eb 01          	sub    $0x1,%rbx
  80195a:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  80195e:	48 89 da             	mov    %rbx,%rdx
  801961:	4c 89 fe             	mov    %r15,%rsi
  801964:	48 b8 ba 18 80 00 00 	movabs $0x8018ba,%rax
  80196b:	00 00 00 
  80196e:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  801970:	49 01 de             	add    %rbx,%r14
  801973:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  801978:	eb c3                	jmp    80193d <strlcat+0x6d>

000000000080197a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  80197a:	f3 0f 1e fa          	endbr64
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  80197e:	48 85 d2             	test   %rdx,%rdx
  801981:	74 2d                	je     8019b0 <memcmp+0x36>
  801983:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  801988:	0f b6 0c 07          	movzbl (%rdi,%rax,1),%ecx
  80198c:	44 0f b6 04 06       	movzbl (%rsi,%rax,1),%r8d
  801991:	44 38 c1             	cmp    %r8b,%cl
  801994:	75 0f                	jne    8019a5 <memcmp+0x2b>
    while (n-- > 0) {
  801996:	48 83 c0 01          	add    $0x1,%rax
  80199a:	48 39 c2             	cmp    %rax,%rdx
  80199d:	75 e9                	jne    801988 <memcmp+0xe>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  80199f:	b8 00 00 00 00       	mov    $0x0,%eax
  8019a4:	c3                   	ret
            return (int)*s1 - (int)*s2;
  8019a5:	0f b6 c1             	movzbl %cl,%eax
  8019a8:	45 0f b6 c0          	movzbl %r8b,%r8d
  8019ac:	44 29 c0             	sub    %r8d,%eax
  8019af:	c3                   	ret
    return 0;
  8019b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019b5:	c3                   	ret

00000000008019b6 <memfind>:

void *
memfind(const void *src, int c, size_t n) {
  8019b6:	f3 0f 1e fa          	endbr64
    const void *end = (const char *)src + n;
  8019ba:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  8019be:	48 39 c7             	cmp    %rax,%rdi
  8019c1:	73 0f                	jae    8019d2 <memfind+0x1c>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  8019c3:	40 38 37             	cmp    %sil,(%rdi)
  8019c6:	74 0e                	je     8019d6 <memfind+0x20>
    for (; src < end; src++) {
  8019c8:	48 83 c7 01          	add    $0x1,%rdi
  8019cc:	48 39 f8             	cmp    %rdi,%rax
  8019cf:	75 f2                	jne    8019c3 <memfind+0xd>
  8019d1:	c3                   	ret
  8019d2:	48 89 f8             	mov    %rdi,%rax
  8019d5:	c3                   	ret
  8019d6:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  8019d9:	c3                   	ret

00000000008019da <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  8019da:	f3 0f 1e fa          	endbr64
  8019de:	49 89 f2             	mov    %rsi,%r10
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  8019e1:	0f b6 37             	movzbl (%rdi),%esi
  8019e4:	40 80 fe 20          	cmp    $0x20,%sil
  8019e8:	74 06                	je     8019f0 <strtol+0x16>
  8019ea:	40 80 fe 09          	cmp    $0x9,%sil
  8019ee:	75 13                	jne    801a03 <strtol+0x29>
  8019f0:	48 83 c7 01          	add    $0x1,%rdi
  8019f4:	0f b6 37             	movzbl (%rdi),%esi
  8019f7:	40 80 fe 20          	cmp    $0x20,%sil
  8019fb:	74 f3                	je     8019f0 <strtol+0x16>
  8019fd:	40 80 fe 09          	cmp    $0x9,%sil
  801a01:	74 ed                	je     8019f0 <strtol+0x16>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  801a03:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  801a06:	83 e0 fd             	and    $0xfffffffd,%eax
  801a09:	3c 01                	cmp    $0x1,%al
  801a0b:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  801a0f:	f7 c2 ef ff ff ff    	test   $0xffffffef,%edx
  801a15:	75 0f                	jne    801a26 <strtol+0x4c>
  801a17:	80 3f 30             	cmpb   $0x30,(%rdi)
  801a1a:	74 14                	je     801a30 <strtol+0x56>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  801a1c:	85 d2                	test   %edx,%edx
  801a1e:	b8 0a 00 00 00       	mov    $0xa,%eax
  801a23:	0f 44 d0             	cmove  %eax,%edx
    }

    /* Digits */
    long val = 0;
  801a26:	b8 00 00 00 00       	mov    $0x0,%eax
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  801a2b:	4c 63 ca             	movslq %edx,%r9
  801a2e:	eb 36                	jmp    801a66 <strtol+0x8c>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  801a30:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  801a34:	74 0f                	je     801a45 <strtol+0x6b>
    } else if (!base && s[0] == '0') {
  801a36:	85 d2                	test   %edx,%edx
  801a38:	75 ec                	jne    801a26 <strtol+0x4c>
        s++;
  801a3a:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  801a3e:	ba 08 00 00 00       	mov    $0x8,%edx
        s++;
  801a43:	eb e1                	jmp    801a26 <strtol+0x4c>
        s += 2;
  801a45:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  801a49:	ba 10 00 00 00       	mov    $0x10,%edx
        s += 2;
  801a4e:	eb d6                	jmp    801a26 <strtol+0x4c>
            dig -= '0';
  801a50:	83 e9 30             	sub    $0x30,%ecx
        if (dig >= base) break;
  801a53:	44 0f b6 c1          	movzbl %cl,%r8d
  801a57:	41 39 d0             	cmp    %edx,%r8d
  801a5a:	7d 21                	jge    801a7d <strtol+0xa3>
        val = val * base + dig;
  801a5c:	49 0f af c1          	imul   %r9,%rax
  801a60:	0f b6 c9             	movzbl %cl,%ecx
  801a63:	48 01 c8             	add    %rcx,%rax
        uint8_t dig = *s++;
  801a66:	48 83 c7 01          	add    $0x1,%rdi
  801a6a:	0f b6 4f ff          	movzbl -0x1(%rdi),%ecx
        if (dig - '0' < 10)
  801a6e:	80 f9 39             	cmp    $0x39,%cl
  801a71:	76 dd                	jbe    801a50 <strtol+0x76>
        else if (dig - 'a' < 27)
  801a73:	80 f9 7b             	cmp    $0x7b,%cl
  801a76:	77 05                	ja     801a7d <strtol+0xa3>
            dig -= 'a' - 10;
  801a78:	83 e9 57             	sub    $0x57,%ecx
  801a7b:	eb d6                	jmp    801a53 <strtol+0x79>
    }

    if (endptr) *endptr = (char *)s;
  801a7d:	4d 85 d2             	test   %r10,%r10
  801a80:	74 03                	je     801a85 <strtol+0xab>
  801a82:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  801a85:	48 89 c2             	mov    %rax,%rdx
  801a88:	48 f7 da             	neg    %rdx
  801a8b:	40 80 fe 2d          	cmp    $0x2d,%sil
  801a8f:	48 0f 44 c2          	cmove  %rdx,%rax
}
  801a93:	c3                   	ret

0000000000801a94 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  801a94:	f3 0f 1e fa          	endbr64
  801a98:	55                   	push   %rbp
  801a99:	48 89 e5             	mov    %rsp,%rbp
  801a9c:	53                   	push   %rbx
  801a9d:	48 89 fa             	mov    %rdi,%rdx
  801aa0:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801aa3:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801aa8:	bb 00 00 00 00       	mov    $0x0,%ebx
  801aad:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801ab2:	be 00 00 00 00       	mov    $0x0,%esi
  801ab7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801abd:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  801abf:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801ac3:	c9                   	leave
  801ac4:	c3                   	ret

0000000000801ac5 <sys_cgetc>:

int
sys_cgetc(void) {
  801ac5:	f3 0f 1e fa          	endbr64
  801ac9:	55                   	push   %rbp
  801aca:	48 89 e5             	mov    %rsp,%rbp
  801acd:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801ace:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801ad3:	ba 00 00 00 00       	mov    $0x0,%edx
  801ad8:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801add:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ae2:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801ae7:	be 00 00 00 00       	mov    $0x0,%esi
  801aec:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801af2:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  801af4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801af8:	c9                   	leave
  801af9:	c3                   	ret

0000000000801afa <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  801afa:	f3 0f 1e fa          	endbr64
  801afe:	55                   	push   %rbp
  801aff:	48 89 e5             	mov    %rsp,%rbp
  801b02:	53                   	push   %rbx
  801b03:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  801b07:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801b0a:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801b0f:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801b14:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b19:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801b1e:	be 00 00 00 00       	mov    $0x0,%esi
  801b23:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801b29:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801b2b:	48 85 c0             	test   %rax,%rax
  801b2e:	7f 06                	jg     801b36 <sys_env_destroy+0x3c>
}
  801b30:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801b34:	c9                   	leave
  801b35:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801b36:	49 89 c0             	mov    %rax,%r8
  801b39:	b9 03 00 00 00       	mov    $0x3,%ecx
  801b3e:	48 ba 78 46 80 00 00 	movabs $0x804678,%rdx
  801b45:	00 00 00 
  801b48:	be 26 00 00 00       	mov    $0x26,%esi
  801b4d:	48 bf 63 43 80 00 00 	movabs $0x804363,%rdi
  801b54:	00 00 00 
  801b57:	b8 00 00 00 00       	mov    $0x0,%eax
  801b5c:	49 b9 8f 0b 80 00 00 	movabs $0x800b8f,%r9
  801b63:	00 00 00 
  801b66:	41 ff d1             	call   *%r9

0000000000801b69 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  801b69:	f3 0f 1e fa          	endbr64
  801b6d:	55                   	push   %rbp
  801b6e:	48 89 e5             	mov    %rsp,%rbp
  801b71:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801b72:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801b77:	ba 00 00 00 00       	mov    $0x0,%edx
  801b7c:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801b81:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b86:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801b8b:	be 00 00 00 00       	mov    $0x0,%esi
  801b90:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801b96:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  801b98:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801b9c:	c9                   	leave
  801b9d:	c3                   	ret

0000000000801b9e <sys_yield>:

void
sys_yield(void) {
  801b9e:	f3 0f 1e fa          	endbr64
  801ba2:	55                   	push   %rbp
  801ba3:	48 89 e5             	mov    %rsp,%rbp
  801ba6:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801ba7:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801bac:	ba 00 00 00 00       	mov    $0x0,%edx
  801bb1:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801bb6:	bb 00 00 00 00       	mov    $0x0,%ebx
  801bbb:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801bc0:	be 00 00 00 00       	mov    $0x0,%esi
  801bc5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801bcb:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  801bcd:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801bd1:	c9                   	leave
  801bd2:	c3                   	ret

0000000000801bd3 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  801bd3:	f3 0f 1e fa          	endbr64
  801bd7:	55                   	push   %rbp
  801bd8:	48 89 e5             	mov    %rsp,%rbp
  801bdb:	53                   	push   %rbx
  801bdc:	48 89 fa             	mov    %rdi,%rdx
  801bdf:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801be2:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801be7:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  801bee:	00 00 00 
  801bf1:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801bf6:	be 00 00 00 00       	mov    $0x0,%esi
  801bfb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801c01:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  801c03:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801c07:	c9                   	leave
  801c08:	c3                   	ret

0000000000801c09 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  801c09:	f3 0f 1e fa          	endbr64
  801c0d:	55                   	push   %rbp
  801c0e:	48 89 e5             	mov    %rsp,%rbp
  801c11:	53                   	push   %rbx
  801c12:	49 89 f8             	mov    %rdi,%r8
  801c15:	48 89 d3             	mov    %rdx,%rbx
  801c18:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  801c1b:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801c20:	4c 89 c2             	mov    %r8,%rdx
  801c23:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801c26:	be 00 00 00 00       	mov    $0x0,%esi
  801c2b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801c31:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  801c33:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801c37:	c9                   	leave
  801c38:	c3                   	ret

0000000000801c39 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  801c39:	f3 0f 1e fa          	endbr64
  801c3d:	55                   	push   %rbp
  801c3e:	48 89 e5             	mov    %rsp,%rbp
  801c41:	53                   	push   %rbx
  801c42:	48 83 ec 08          	sub    $0x8,%rsp
  801c46:	89 f8                	mov    %edi,%eax
  801c48:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  801c4b:	48 63 f9             	movslq %ecx,%rdi
  801c4e:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801c51:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801c56:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801c59:	be 00 00 00 00       	mov    $0x0,%esi
  801c5e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801c64:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801c66:	48 85 c0             	test   %rax,%rax
  801c69:	7f 06                	jg     801c71 <sys_alloc_region+0x38>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  801c6b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801c6f:	c9                   	leave
  801c70:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801c71:	49 89 c0             	mov    %rax,%r8
  801c74:	b9 04 00 00 00       	mov    $0x4,%ecx
  801c79:	48 ba 78 46 80 00 00 	movabs $0x804678,%rdx
  801c80:	00 00 00 
  801c83:	be 26 00 00 00       	mov    $0x26,%esi
  801c88:	48 bf 63 43 80 00 00 	movabs $0x804363,%rdi
  801c8f:	00 00 00 
  801c92:	b8 00 00 00 00       	mov    $0x0,%eax
  801c97:	49 b9 8f 0b 80 00 00 	movabs $0x800b8f,%r9
  801c9e:	00 00 00 
  801ca1:	41 ff d1             	call   *%r9

0000000000801ca4 <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  801ca4:	f3 0f 1e fa          	endbr64
  801ca8:	55                   	push   %rbp
  801ca9:	48 89 e5             	mov    %rsp,%rbp
  801cac:	53                   	push   %rbx
  801cad:	48 83 ec 08          	sub    $0x8,%rsp
  801cb1:	89 f8                	mov    %edi,%eax
  801cb3:	49 89 f2             	mov    %rsi,%r10
  801cb6:	48 89 cf             	mov    %rcx,%rdi
  801cb9:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  801cbc:	48 63 da             	movslq %edx,%rbx
  801cbf:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801cc2:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801cc7:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801cca:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  801ccd:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801ccf:	48 85 c0             	test   %rax,%rax
  801cd2:	7f 06                	jg     801cda <sys_map_region+0x36>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  801cd4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801cd8:	c9                   	leave
  801cd9:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801cda:	49 89 c0             	mov    %rax,%r8
  801cdd:	b9 05 00 00 00       	mov    $0x5,%ecx
  801ce2:	48 ba 78 46 80 00 00 	movabs $0x804678,%rdx
  801ce9:	00 00 00 
  801cec:	be 26 00 00 00       	mov    $0x26,%esi
  801cf1:	48 bf 63 43 80 00 00 	movabs $0x804363,%rdi
  801cf8:	00 00 00 
  801cfb:	b8 00 00 00 00       	mov    $0x0,%eax
  801d00:	49 b9 8f 0b 80 00 00 	movabs $0x800b8f,%r9
  801d07:	00 00 00 
  801d0a:	41 ff d1             	call   *%r9

0000000000801d0d <sys_map_physical_region>:

int
sys_map_physical_region(uintptr_t pa, envid_t dstenv, void *dstva, size_t size, int perm) {
  801d0d:	f3 0f 1e fa          	endbr64
  801d11:	55                   	push   %rbp
  801d12:	48 89 e5             	mov    %rsp,%rbp
  801d15:	53                   	push   %rbx
  801d16:	48 83 ec 08          	sub    $0x8,%rsp
  801d1a:	49 89 f9             	mov    %rdi,%r9
  801d1d:	89 f0                	mov    %esi,%eax
  801d1f:	48 89 d3             	mov    %rdx,%rbx
  801d22:	48 89 cf             	mov    %rcx,%rdi
    int res = syscall(SYS_map_physical_region, 1, pa, dstenv, (uintptr_t)dstva, size, perm, 0);
  801d25:	49 63 f0             	movslq %r8d,%rsi
  801d28:	48 63 c8             	movslq %eax,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801d2b:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801d30:	4c 89 ca             	mov    %r9,%rdx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801d33:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801d39:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801d3b:	48 85 c0             	test   %rax,%rax
  801d3e:	7f 06                	jg     801d46 <sys_map_physical_region+0x39>
#ifdef SANITIZE_USER_SHADOW_BASE
    platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  801d40:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801d44:	c9                   	leave
  801d45:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801d46:	49 89 c0             	mov    %rax,%r8
  801d49:	b9 06 00 00 00       	mov    $0x6,%ecx
  801d4e:	48 ba 78 46 80 00 00 	movabs $0x804678,%rdx
  801d55:	00 00 00 
  801d58:	be 26 00 00 00       	mov    $0x26,%esi
  801d5d:	48 bf 63 43 80 00 00 	movabs $0x804363,%rdi
  801d64:	00 00 00 
  801d67:	b8 00 00 00 00       	mov    $0x0,%eax
  801d6c:	49 b9 8f 0b 80 00 00 	movabs $0x800b8f,%r9
  801d73:	00 00 00 
  801d76:	41 ff d1             	call   *%r9

0000000000801d79 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  801d79:	f3 0f 1e fa          	endbr64
  801d7d:	55                   	push   %rbp
  801d7e:	48 89 e5             	mov    %rsp,%rbp
  801d81:	53                   	push   %rbx
  801d82:	48 83 ec 08          	sub    $0x8,%rsp
  801d86:	48 89 f1             	mov    %rsi,%rcx
  801d89:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  801d8c:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801d8f:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801d94:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801d99:	be 00 00 00 00       	mov    $0x0,%esi
  801d9e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801da4:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801da6:	48 85 c0             	test   %rax,%rax
  801da9:	7f 06                	jg     801db1 <sys_unmap_region+0x38>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  801dab:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801daf:	c9                   	leave
  801db0:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801db1:	49 89 c0             	mov    %rax,%r8
  801db4:	b9 07 00 00 00       	mov    $0x7,%ecx
  801db9:	48 ba 78 46 80 00 00 	movabs $0x804678,%rdx
  801dc0:	00 00 00 
  801dc3:	be 26 00 00 00       	mov    $0x26,%esi
  801dc8:	48 bf 63 43 80 00 00 	movabs $0x804363,%rdi
  801dcf:	00 00 00 
  801dd2:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd7:	49 b9 8f 0b 80 00 00 	movabs $0x800b8f,%r9
  801dde:	00 00 00 
  801de1:	41 ff d1             	call   *%r9

0000000000801de4 <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  801de4:	f3 0f 1e fa          	endbr64
  801de8:	55                   	push   %rbp
  801de9:	48 89 e5             	mov    %rsp,%rbp
  801dec:	53                   	push   %rbx
  801ded:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  801df1:	48 63 ce             	movslq %esi,%rcx
  801df4:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801df7:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801dfc:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e01:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801e06:	be 00 00 00 00       	mov    $0x0,%esi
  801e0b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801e11:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801e13:	48 85 c0             	test   %rax,%rax
  801e16:	7f 06                	jg     801e1e <sys_env_set_status+0x3a>
}
  801e18:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801e1c:	c9                   	leave
  801e1d:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801e1e:	49 89 c0             	mov    %rax,%r8
  801e21:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801e26:	48 ba 78 46 80 00 00 	movabs $0x804678,%rdx
  801e2d:	00 00 00 
  801e30:	be 26 00 00 00       	mov    $0x26,%esi
  801e35:	48 bf 63 43 80 00 00 	movabs $0x804363,%rdi
  801e3c:	00 00 00 
  801e3f:	b8 00 00 00 00       	mov    $0x0,%eax
  801e44:	49 b9 8f 0b 80 00 00 	movabs $0x800b8f,%r9
  801e4b:	00 00 00 
  801e4e:	41 ff d1             	call   *%r9

0000000000801e51 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  801e51:	f3 0f 1e fa          	endbr64
  801e55:	55                   	push   %rbp
  801e56:	48 89 e5             	mov    %rsp,%rbp
  801e59:	53                   	push   %rbx
  801e5a:	48 83 ec 08          	sub    $0x8,%rsp
  801e5e:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  801e61:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801e64:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801e69:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e6e:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801e73:	be 00 00 00 00       	mov    $0x0,%esi
  801e78:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801e7e:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801e80:	48 85 c0             	test   %rax,%rax
  801e83:	7f 06                	jg     801e8b <sys_env_set_trapframe+0x3a>
}
  801e85:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801e89:	c9                   	leave
  801e8a:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801e8b:	49 89 c0             	mov    %rax,%r8
  801e8e:	b9 0b 00 00 00       	mov    $0xb,%ecx
  801e93:	48 ba 78 46 80 00 00 	movabs $0x804678,%rdx
  801e9a:	00 00 00 
  801e9d:	be 26 00 00 00       	mov    $0x26,%esi
  801ea2:	48 bf 63 43 80 00 00 	movabs $0x804363,%rdi
  801ea9:	00 00 00 
  801eac:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb1:	49 b9 8f 0b 80 00 00 	movabs $0x800b8f,%r9
  801eb8:	00 00 00 
  801ebb:	41 ff d1             	call   *%r9

0000000000801ebe <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  801ebe:	f3 0f 1e fa          	endbr64
  801ec2:	55                   	push   %rbp
  801ec3:	48 89 e5             	mov    %rsp,%rbp
  801ec6:	53                   	push   %rbx
  801ec7:	48 83 ec 08          	sub    $0x8,%rsp
  801ecb:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  801ece:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801ed1:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801ed6:	bb 00 00 00 00       	mov    $0x0,%ebx
  801edb:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801ee0:	be 00 00 00 00       	mov    $0x0,%esi
  801ee5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801eeb:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801eed:	48 85 c0             	test   %rax,%rax
  801ef0:	7f 06                	jg     801ef8 <sys_env_set_pgfault_upcall+0x3a>
}
  801ef2:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801ef6:	c9                   	leave
  801ef7:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801ef8:	49 89 c0             	mov    %rax,%r8
  801efb:	b9 0c 00 00 00       	mov    $0xc,%ecx
  801f00:	48 ba 78 46 80 00 00 	movabs $0x804678,%rdx
  801f07:	00 00 00 
  801f0a:	be 26 00 00 00       	mov    $0x26,%esi
  801f0f:	48 bf 63 43 80 00 00 	movabs $0x804363,%rdi
  801f16:	00 00 00 
  801f19:	b8 00 00 00 00       	mov    $0x0,%eax
  801f1e:	49 b9 8f 0b 80 00 00 	movabs $0x800b8f,%r9
  801f25:	00 00 00 
  801f28:	41 ff d1             	call   *%r9

0000000000801f2b <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  801f2b:	f3 0f 1e fa          	endbr64
  801f2f:	55                   	push   %rbp
  801f30:	48 89 e5             	mov    %rsp,%rbp
  801f33:	53                   	push   %rbx
  801f34:	89 f8                	mov    %edi,%eax
  801f36:	49 89 f1             	mov    %rsi,%r9
  801f39:	48 89 d3             	mov    %rdx,%rbx
  801f3c:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  801f3f:	49 63 f0             	movslq %r8d,%rsi
  801f42:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801f45:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801f4a:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801f4d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801f53:	cd 30                	int    $0x30
}
  801f55:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801f59:	c9                   	leave
  801f5a:	c3                   	ret

0000000000801f5b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  801f5b:	f3 0f 1e fa          	endbr64
  801f5f:	55                   	push   %rbp
  801f60:	48 89 e5             	mov    %rsp,%rbp
  801f63:	53                   	push   %rbx
  801f64:	48 83 ec 08          	sub    $0x8,%rsp
  801f68:	48 89 fa             	mov    %rdi,%rdx
  801f6b:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801f6e:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801f73:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f78:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801f7d:	be 00 00 00 00       	mov    $0x0,%esi
  801f82:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801f88:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801f8a:	48 85 c0             	test   %rax,%rax
  801f8d:	7f 06                	jg     801f95 <sys_ipc_recv+0x3a>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  801f8f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801f93:	c9                   	leave
  801f94:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801f95:	49 89 c0             	mov    %rax,%r8
  801f98:	b9 0f 00 00 00       	mov    $0xf,%ecx
  801f9d:	48 ba 78 46 80 00 00 	movabs $0x804678,%rdx
  801fa4:	00 00 00 
  801fa7:	be 26 00 00 00       	mov    $0x26,%esi
  801fac:	48 bf 63 43 80 00 00 	movabs $0x804363,%rdi
  801fb3:	00 00 00 
  801fb6:	b8 00 00 00 00       	mov    $0x0,%eax
  801fbb:	49 b9 8f 0b 80 00 00 	movabs $0x800b8f,%r9
  801fc2:	00 00 00 
  801fc5:	41 ff d1             	call   *%r9

0000000000801fc8 <sys_gettime>:

int
sys_gettime(void) {
  801fc8:	f3 0f 1e fa          	endbr64
  801fcc:	55                   	push   %rbp
  801fcd:	48 89 e5             	mov    %rsp,%rbp
  801fd0:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801fd1:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801fd6:	ba 00 00 00 00       	mov    $0x0,%edx
  801fdb:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801fe0:	bb 00 00 00 00       	mov    $0x0,%ebx
  801fe5:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801fea:	be 00 00 00 00       	mov    $0x0,%esi
  801fef:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801ff5:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  801ff7:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801ffb:	c9                   	leave
  801ffc:	c3                   	ret

0000000000801ffd <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  801ffd:	f3 0f 1e fa          	endbr64
  802001:	55                   	push   %rbp
  802002:	48 89 e5             	mov    %rsp,%rbp
  802005:	41 54                	push   %r12
  802007:	53                   	push   %rbx
  802008:	48 89 fb             	mov    %rdi,%rbx
  80200b:	48 89 f7             	mov    %rsi,%rdi
  80200e:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802011:	48 85 f6             	test   %rsi,%rsi
  802014:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  80201b:	00 00 00 
  80201e:	48 0f 44 f8          	cmove  %rax,%rdi
    }
    int res = sys_ipc_recv(pg, PAGE_SIZE);
  802022:	be 00 10 00 00       	mov    $0x1000,%esi
  802027:	48 b8 5b 1f 80 00 00 	movabs $0x801f5b,%rax
  80202e:	00 00 00 
  802031:	ff d0                	call   *%rax
    if (res < 0) {
  802033:	85 c0                	test   %eax,%eax
  802035:	78 45                	js     80207c <ipc_recv+0x7f>
        if (perm_store != NULL) {
            *perm_store = 0;
        }
        return res;
    } else {
        if (from_env_store != NULL) {
  802037:	48 85 db             	test   %rbx,%rbx
  80203a:	74 12                	je     80204e <ipc_recv+0x51>
            *from_env_store = thisenv->env_ipc_from;
  80203c:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  802043:	00 00 00 
  802046:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  80204c:	89 03                	mov    %eax,(%rbx)
        }
        if (perm_store != NULL) {
  80204e:	4d 85 e4             	test   %r12,%r12
  802051:	74 14                	je     802067 <ipc_recv+0x6a>
            *perm_store = thisenv->env_ipc_perm;
  802053:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  80205a:	00 00 00 
  80205d:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  802063:	41 89 04 24          	mov    %eax,(%r12)
        }
        return thisenv->env_ipc_value;
  802067:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  80206e:	00 00 00 
  802071:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
    }
    return -1;
}
  802077:	5b                   	pop    %rbx
  802078:	41 5c                	pop    %r12
  80207a:	5d                   	pop    %rbp
  80207b:	c3                   	ret
        if (from_env_store != NULL) {
  80207c:	48 85 db             	test   %rbx,%rbx
  80207f:	74 06                	je     802087 <ipc_recv+0x8a>
            *from_env_store = 0;
  802081:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store != NULL) {
  802087:	4d 85 e4             	test   %r12,%r12
  80208a:	74 eb                	je     802077 <ipc_recv+0x7a>
            *perm_store = 0;
  80208c:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  802093:	00 
  802094:	eb e1                	jmp    802077 <ipc_recv+0x7a>

0000000000802096 <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  802096:	f3 0f 1e fa          	endbr64
  80209a:	55                   	push   %rbp
  80209b:	48 89 e5             	mov    %rsp,%rbp
  80209e:	41 57                	push   %r15
  8020a0:	41 56                	push   %r14
  8020a2:	41 55                	push   %r13
  8020a4:	41 54                	push   %r12
  8020a6:	53                   	push   %rbx
  8020a7:	48 83 ec 18          	sub    $0x18,%rsp
  8020ab:	89 7d c4             	mov    %edi,-0x3c(%rbp)
  8020ae:	48 89 d3             	mov    %rdx,%rbx
  8020b1:	49 89 cc             	mov    %rcx,%r12
  8020b4:	45 89 c5             	mov    %r8d,%r13d
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  8020b7:	48 85 d2             	test   %rdx,%rdx
  8020ba:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  8020c1:	00 00 00 
  8020c4:	48 0f 44 d8          	cmove  %rax,%rbx
    }
    int res = sys_ipc_try_send(to_env, val, pg, size, perm);
  8020c8:	89 f0                	mov    %esi,%eax
  8020ca:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  8020ce:	48 89 da             	mov    %rbx,%rdx
  8020d1:	48 89 c6             	mov    %rax,%rsi
  8020d4:	48 b8 2b 1f 80 00 00 	movabs $0x801f2b,%rax
  8020db:	00 00 00 
  8020de:	ff d0                	call   *%rax
    while (res < 0) {
  8020e0:	85 c0                	test   %eax,%eax
  8020e2:	79 65                	jns    802149 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  8020e4:	83 f8 f5             	cmp    $0xfffffff5,%eax
  8020e7:	75 33                	jne    80211c <ipc_send+0x86>
            panic("Error: %i\n", res);
        }
        sys_yield();
  8020e9:	49 bf 9e 1b 80 00 00 	movabs $0x801b9e,%r15
  8020f0:	00 00 00 
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  8020f3:	49 be 2b 1f 80 00 00 	movabs $0x801f2b,%r14
  8020fa:	00 00 00 
        sys_yield();
  8020fd:	41 ff d7             	call   *%r15
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802100:	45 89 e8             	mov    %r13d,%r8d
  802103:	4c 89 e1             	mov    %r12,%rcx
  802106:	48 89 da             	mov    %rbx,%rdx
  802109:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  80210d:	8b 7d c4             	mov    -0x3c(%rbp),%edi
  802110:	41 ff d6             	call   *%r14
    while (res < 0) {
  802113:	85 c0                	test   %eax,%eax
  802115:	79 32                	jns    802149 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802117:	83 f8 f5             	cmp    $0xfffffff5,%eax
  80211a:	74 e1                	je     8020fd <ipc_send+0x67>
            panic("Error: %i\n", res);
  80211c:	89 c1                	mov    %eax,%ecx
  80211e:	48 ba 71 43 80 00 00 	movabs $0x804371,%rdx
  802125:	00 00 00 
  802128:	be 42 00 00 00       	mov    $0x42,%esi
  80212d:	48 bf 7c 43 80 00 00 	movabs $0x80437c,%rdi
  802134:	00 00 00 
  802137:	b8 00 00 00 00       	mov    $0x0,%eax
  80213c:	49 b8 8f 0b 80 00 00 	movabs $0x800b8f,%r8
  802143:	00 00 00 
  802146:	41 ff d0             	call   *%r8
    }
}
  802149:	48 83 c4 18          	add    $0x18,%rsp
  80214d:	5b                   	pop    %rbx
  80214e:	41 5c                	pop    %r12
  802150:	41 5d                	pop    %r13
  802152:	41 5e                	pop    %r14
  802154:	41 5f                	pop    %r15
  802156:	5d                   	pop    %rbp
  802157:	c3                   	ret

0000000000802158 <ipc_find_env>:

/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
  802158:	f3 0f 1e fa          	endbr64
    for (size_t i = 0; i < NENV; i++)
  80215c:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  802161:	48 b9 00 00 a0 1f 80 	movabs $0x801fa00000,%rcx
  802168:	00 00 00 
  80216b:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  80216f:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802173:	48 c1 e2 04          	shl    $0x4,%rdx
  802177:	48 01 ca             	add    %rcx,%rdx
  80217a:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  802180:	39 fa                	cmp    %edi,%edx
  802182:	74 12                	je     802196 <ipc_find_env+0x3e>
    for (size_t i = 0; i < NENV; i++)
  802184:	48 83 c0 01          	add    $0x1,%rax
  802188:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  80218e:	75 db                	jne    80216b <ipc_find_env+0x13>
            return envs[i].env_id;
    return 0;
  802190:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802195:	c3                   	ret
            return envs[i].env_id;
  802196:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  80219a:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  80219e:	48 c1 e2 04          	shl    $0x4,%rdx
  8021a2:	48 b8 00 00 a0 1f 80 	movabs $0x801fa00000,%rax
  8021a9:	00 00 00 
  8021ac:	48 01 d0             	add    %rdx,%rax
  8021af:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8021b5:	c3                   	ret

00000000008021b6 <fd2num>:


/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
  8021b6:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8021ba:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8021c1:	ff ff ff 
  8021c4:	48 01 f8             	add    %rdi,%rax
  8021c7:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8021cb:	c3                   	ret

00000000008021cc <fd2data>:

char *
fd2data(struct Fd *fd) {
  8021cc:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8021d0:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8021d7:	ff ff ff 
  8021da:	48 01 f8             	add    %rdi,%rax
  8021dd:	48 c1 e8 0c          	shr    $0xc,%rax
    return INDEX2DATA(fd2num(fd));
  8021e1:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8021e7:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8021eb:	c3                   	ret

00000000008021ec <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  8021ec:	f3 0f 1e fa          	endbr64
  8021f0:	55                   	push   %rbp
  8021f1:	48 89 e5             	mov    %rsp,%rbp
  8021f4:	41 57                	push   %r15
  8021f6:	41 56                	push   %r14
  8021f8:	41 55                	push   %r13
  8021fa:	41 54                	push   %r12
  8021fc:	53                   	push   %rbx
  8021fd:	48 83 ec 08          	sub    $0x8,%rsp
  802201:	49 89 ff             	mov    %rdi,%r15
  802204:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  802209:	49 bd 4b 33 80 00 00 	movabs $0x80334b,%r13
  802210:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  802213:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        struct Fd *fd = INDEX2FD(i);
  802219:	49 89 dc             	mov    %rbx,%r12
        if (!(get_prot(fd) & PROT_R)) {
  80221c:	48 89 df             	mov    %rbx,%rdi
  80221f:	41 ff d5             	call   *%r13
  802222:	83 e0 04             	and    $0x4,%eax
  802225:	74 17                	je     80223e <fd_alloc+0x52>
    for (int i = 0; i < MAXFD; i++) {
  802227:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  80222e:	4c 39 f3             	cmp    %r14,%rbx
  802231:	75 e6                	jne    802219 <fd_alloc+0x2d>
  802233:	41 bc 00 00 00 00    	mov    $0x0,%r12d
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
    return -E_MAX_OPEN;
  802239:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
            *fd_store = fd;
  80223e:	4d 89 27             	mov    %r12,(%r15)
}
  802241:	48 83 c4 08          	add    $0x8,%rsp
  802245:	5b                   	pop    %rbx
  802246:	41 5c                	pop    %r12
  802248:	41 5d                	pop    %r13
  80224a:	41 5e                	pop    %r14
  80224c:	41 5f                	pop    %r15
  80224e:	5d                   	pop    %rbp
  80224f:	c3                   	ret

0000000000802250 <fd_lookup>:
 *
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
  802250:	f3 0f 1e fa          	endbr64
    if (fdnum < 0 || fdnum >= MAXFD) {
  802254:	83 ff 1f             	cmp    $0x1f,%edi
  802257:	77 39                	ja     802292 <fd_lookup+0x42>
fd_lookup(int fdnum, struct Fd **fd_store) {
  802259:	55                   	push   %rbp
  80225a:	48 89 e5             	mov    %rsp,%rbp
  80225d:	41 54                	push   %r12
  80225f:	53                   	push   %rbx
  802260:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  802263:	48 63 df             	movslq %edi,%rbx
  802266:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  80226d:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  802271:	48 89 df             	mov    %rbx,%rdi
  802274:	48 b8 4b 33 80 00 00 	movabs $0x80334b,%rax
  80227b:	00 00 00 
  80227e:	ff d0                	call   *%rax
  802280:	a8 04                	test   $0x4,%al
  802282:	74 14                	je     802298 <fd_lookup+0x48>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  802284:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  802288:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80228d:	5b                   	pop    %rbx
  80228e:	41 5c                	pop    %r12
  802290:	5d                   	pop    %rbp
  802291:	c3                   	ret
        return -E_INVAL;
  802292:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802297:	c3                   	ret
        return -E_INVAL;
  802298:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80229d:	eb ee                	jmp    80228d <fd_lookup+0x3d>

000000000080229f <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  80229f:	f3 0f 1e fa          	endbr64
  8022a3:	55                   	push   %rbp
  8022a4:	48 89 e5             	mov    %rsp,%rbp
  8022a7:	41 54                	push   %r12
  8022a9:	53                   	push   %rbx
  8022aa:	49 89 f4             	mov    %rsi,%r12
    for (size_t i = 0; devtab[i]; i++) {
  8022ad:	48 b8 80 4a 80 00 00 	movabs $0x804a80,%rax
  8022b4:	00 00 00 
  8022b7:	48 bb 20 50 80 00 00 	movabs $0x805020,%rbx
  8022be:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  8022c1:	39 3b                	cmp    %edi,(%rbx)
  8022c3:	74 47                	je     80230c <dev_lookup+0x6d>
    for (size_t i = 0; devtab[i]; i++) {
  8022c5:	48 83 c0 08          	add    $0x8,%rax
  8022c9:	48 8b 18             	mov    (%rax),%rbx
  8022cc:	48 85 db             	test   %rbx,%rbx
  8022cf:	75 f0                	jne    8022c1 <dev_lookup+0x22>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8022d1:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  8022d8:	00 00 00 
  8022db:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  8022e1:	89 fa                	mov    %edi,%edx
  8022e3:	48 bf 98 46 80 00 00 	movabs $0x804698,%rdi
  8022ea:	00 00 00 
  8022ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8022f2:	48 b9 eb 0c 80 00 00 	movabs $0x800ceb,%rcx
  8022f9:	00 00 00 
  8022fc:	ff d1                	call   *%rcx
    *dev = 0;
    return -E_INVAL;
  8022fe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
            *dev = devtab[i];
  802303:	49 89 1c 24          	mov    %rbx,(%r12)
}
  802307:	5b                   	pop    %rbx
  802308:	41 5c                	pop    %r12
  80230a:	5d                   	pop    %rbp
  80230b:	c3                   	ret
            return 0;
  80230c:	b8 00 00 00 00       	mov    $0x0,%eax
  802311:	eb f0                	jmp    802303 <dev_lookup+0x64>

0000000000802313 <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  802313:	f3 0f 1e fa          	endbr64
  802317:	55                   	push   %rbp
  802318:	48 89 e5             	mov    %rsp,%rbp
  80231b:	41 55                	push   %r13
  80231d:	41 54                	push   %r12
  80231f:	53                   	push   %rbx
  802320:	48 83 ec 18          	sub    $0x18,%rsp
  802324:	48 89 fb             	mov    %rdi,%rbx
  802327:	41 89 f4             	mov    %esi,%r12d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80232a:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  802331:	ff ff ff 
  802334:	48 01 df             	add    %rbx,%rdi
  802337:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  80233b:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  80233f:	48 b8 50 22 80 00 00 	movabs $0x802250,%rax
  802346:	00 00 00 
  802349:	ff d0                	call   *%rax
  80234b:	41 89 c5             	mov    %eax,%r13d
  80234e:	85 c0                	test   %eax,%eax
  802350:	78 06                	js     802358 <fd_close+0x45>
  802352:	48 39 5d d8          	cmp    %rbx,-0x28(%rbp)
  802356:	74 1a                	je     802372 <fd_close+0x5f>
        return (must_exist ? res : 0);
  802358:	45 84 e4             	test   %r12b,%r12b
  80235b:	b8 00 00 00 00       	mov    $0x0,%eax
  802360:	44 0f 44 e8          	cmove  %eax,%r13d
}
  802364:	44 89 e8             	mov    %r13d,%eax
  802367:	48 83 c4 18          	add    $0x18,%rsp
  80236b:	5b                   	pop    %rbx
  80236c:	41 5c                	pop    %r12
  80236e:	41 5d                	pop    %r13
  802370:	5d                   	pop    %rbp
  802371:	c3                   	ret
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802372:	8b 3b                	mov    (%rbx),%edi
  802374:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  802378:	48 b8 9f 22 80 00 00 	movabs $0x80229f,%rax
  80237f:	00 00 00 
  802382:	ff d0                	call   *%rax
  802384:	41 89 c5             	mov    %eax,%r13d
  802387:	85 c0                	test   %eax,%eax
  802389:	78 1b                	js     8023a6 <fd_close+0x93>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  80238b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80238f:	48 8b 40 20          	mov    0x20(%rax),%rax
  802393:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  802399:	48 85 c0             	test   %rax,%rax
  80239c:	74 08                	je     8023a6 <fd_close+0x93>
  80239e:	48 89 df             	mov    %rbx,%rdi
  8023a1:	ff d0                	call   *%rax
  8023a3:	41 89 c5             	mov    %eax,%r13d
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  8023a6:	ba 00 10 00 00       	mov    $0x1000,%edx
  8023ab:	48 89 de             	mov    %rbx,%rsi
  8023ae:	bf 00 00 00 00       	mov    $0x0,%edi
  8023b3:	48 b8 79 1d 80 00 00 	movabs $0x801d79,%rax
  8023ba:	00 00 00 
  8023bd:	ff d0                	call   *%rax
    return res;
  8023bf:	eb a3                	jmp    802364 <fd_close+0x51>

00000000008023c1 <close>:

int
close(int fdnum) {
  8023c1:	f3 0f 1e fa          	endbr64
  8023c5:	55                   	push   %rbp
  8023c6:	48 89 e5             	mov    %rsp,%rbp
  8023c9:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  8023cd:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8023d1:	48 b8 50 22 80 00 00 	movabs $0x802250,%rax
  8023d8:	00 00 00 
  8023db:	ff d0                	call   *%rax
    if (res < 0) return res;
  8023dd:	85 c0                	test   %eax,%eax
  8023df:	78 15                	js     8023f6 <close+0x35>

    return fd_close(fd, 1);
  8023e1:	be 01 00 00 00       	mov    $0x1,%esi
  8023e6:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8023ea:	48 b8 13 23 80 00 00 	movabs $0x802313,%rax
  8023f1:	00 00 00 
  8023f4:	ff d0                	call   *%rax
}
  8023f6:	c9                   	leave
  8023f7:	c3                   	ret

00000000008023f8 <close_all>:

void
close_all(void) {
  8023f8:	f3 0f 1e fa          	endbr64
  8023fc:	55                   	push   %rbp
  8023fd:	48 89 e5             	mov    %rsp,%rbp
  802400:	41 54                	push   %r12
  802402:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  802403:	bb 00 00 00 00       	mov    $0x0,%ebx
  802408:	49 bc c1 23 80 00 00 	movabs $0x8023c1,%r12
  80240f:	00 00 00 
  802412:	89 df                	mov    %ebx,%edi
  802414:	41 ff d4             	call   *%r12
  802417:	83 c3 01             	add    $0x1,%ebx
  80241a:	83 fb 20             	cmp    $0x20,%ebx
  80241d:	75 f3                	jne    802412 <close_all+0x1a>
}
  80241f:	5b                   	pop    %rbx
  802420:	41 5c                	pop    %r12
  802422:	5d                   	pop    %rbp
  802423:	c3                   	ret

0000000000802424 <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  802424:	f3 0f 1e fa          	endbr64
  802428:	55                   	push   %rbp
  802429:	48 89 e5             	mov    %rsp,%rbp
  80242c:	41 57                	push   %r15
  80242e:	41 56                	push   %r14
  802430:	41 55                	push   %r13
  802432:	41 54                	push   %r12
  802434:	53                   	push   %rbx
  802435:	48 83 ec 18          	sub    $0x18,%rsp
  802439:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  80243c:	48 8d 75 c8          	lea    -0x38(%rbp),%rsi
  802440:	48 b8 50 22 80 00 00 	movabs $0x802250,%rax
  802447:	00 00 00 
  80244a:	ff d0                	call   *%rax
  80244c:	89 c3                	mov    %eax,%ebx
  80244e:	85 c0                	test   %eax,%eax
  802450:	0f 88 b8 00 00 00    	js     80250e <dup+0xea>
    close(newfdnum);
  802456:	44 89 e7             	mov    %r12d,%edi
  802459:	48 b8 c1 23 80 00 00 	movabs $0x8023c1,%rax
  802460:	00 00 00 
  802463:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  802465:	4d 63 ec             	movslq %r12d,%r13
  802468:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  80246f:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  802473:	4c 8b 7d c8          	mov    -0x38(%rbp),%r15
  802477:	4c 89 ff             	mov    %r15,%rdi
  80247a:	49 be cc 21 80 00 00 	movabs $0x8021cc,%r14
  802481:	00 00 00 
  802484:	41 ff d6             	call   *%r14
  802487:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  80248a:	4c 89 ef             	mov    %r13,%rdi
  80248d:	41 ff d6             	call   *%r14
  802490:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  802493:	48 89 df             	mov    %rbx,%rdi
  802496:	48 b8 4b 33 80 00 00 	movabs $0x80334b,%rax
  80249d:	00 00 00 
  8024a0:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  8024a2:	a8 04                	test   $0x4,%al
  8024a4:	74 2b                	je     8024d1 <dup+0xad>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  8024a6:	41 89 c1             	mov    %eax,%r9d
  8024a9:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8024af:	4c 89 f1             	mov    %r14,%rcx
  8024b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8024b7:	48 89 de             	mov    %rbx,%rsi
  8024ba:	bf 00 00 00 00       	mov    $0x0,%edi
  8024bf:	48 b8 a4 1c 80 00 00 	movabs $0x801ca4,%rax
  8024c6:	00 00 00 
  8024c9:	ff d0                	call   *%rax
  8024cb:	89 c3                	mov    %eax,%ebx
  8024cd:	85 c0                	test   %eax,%eax
  8024cf:	78 4e                	js     80251f <dup+0xfb>
    }
    prot = get_prot(oldfd);
  8024d1:	4c 89 ff             	mov    %r15,%rdi
  8024d4:	48 b8 4b 33 80 00 00 	movabs $0x80334b,%rax
  8024db:	00 00 00 
  8024de:	ff d0                	call   *%rax
  8024e0:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  8024e3:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8024e9:	4c 89 e9             	mov    %r13,%rcx
  8024ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8024f1:	4c 89 fe             	mov    %r15,%rsi
  8024f4:	bf 00 00 00 00       	mov    $0x0,%edi
  8024f9:	48 b8 a4 1c 80 00 00 	movabs $0x801ca4,%rax
  802500:	00 00 00 
  802503:	ff d0                	call   *%rax
  802505:	89 c3                	mov    %eax,%ebx
  802507:	85 c0                	test   %eax,%eax
  802509:	78 14                	js     80251f <dup+0xfb>

    return newfdnum;
  80250b:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  80250e:	89 d8                	mov    %ebx,%eax
  802510:	48 83 c4 18          	add    $0x18,%rsp
  802514:	5b                   	pop    %rbx
  802515:	41 5c                	pop    %r12
  802517:	41 5d                	pop    %r13
  802519:	41 5e                	pop    %r14
  80251b:	41 5f                	pop    %r15
  80251d:	5d                   	pop    %rbp
  80251e:	c3                   	ret
    sys_unmap_region(0, newfd, PAGE_SIZE);
  80251f:	ba 00 10 00 00       	mov    $0x1000,%edx
  802524:	4c 89 ee             	mov    %r13,%rsi
  802527:	bf 00 00 00 00       	mov    $0x0,%edi
  80252c:	49 bc 79 1d 80 00 00 	movabs $0x801d79,%r12
  802533:	00 00 00 
  802536:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  802539:	ba 00 10 00 00       	mov    $0x1000,%edx
  80253e:	4c 89 f6             	mov    %r14,%rsi
  802541:	bf 00 00 00 00       	mov    $0x0,%edi
  802546:	41 ff d4             	call   *%r12
    return res;
  802549:	eb c3                	jmp    80250e <dup+0xea>

000000000080254b <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  80254b:	f3 0f 1e fa          	endbr64
  80254f:	55                   	push   %rbp
  802550:	48 89 e5             	mov    %rsp,%rbp
  802553:	41 56                	push   %r14
  802555:	41 55                	push   %r13
  802557:	41 54                	push   %r12
  802559:	53                   	push   %rbx
  80255a:	48 83 ec 10          	sub    $0x10,%rsp
  80255e:	89 fb                	mov    %edi,%ebx
  802560:	49 89 f4             	mov    %rsi,%r12
  802563:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  802566:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  80256a:	48 b8 50 22 80 00 00 	movabs $0x802250,%rax
  802571:	00 00 00 
  802574:	ff d0                	call   *%rax
  802576:	85 c0                	test   %eax,%eax
  802578:	78 4c                	js     8025c6 <read+0x7b>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  80257a:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  80257e:	41 8b 3e             	mov    (%r14),%edi
  802581:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  802585:	48 b8 9f 22 80 00 00 	movabs $0x80229f,%rax
  80258c:	00 00 00 
  80258f:	ff d0                	call   *%rax
  802591:	85 c0                	test   %eax,%eax
  802593:	78 35                	js     8025ca <read+0x7f>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802595:	41 8b 46 08          	mov    0x8(%r14),%eax
  802599:	83 e0 03             	and    $0x3,%eax
  80259c:	83 f8 01             	cmp    $0x1,%eax
  80259f:	74 2d                	je     8025ce <read+0x83>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  8025a1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025a5:	48 8b 40 10          	mov    0x10(%rax),%rax
  8025a9:	48 85 c0             	test   %rax,%rax
  8025ac:	74 56                	je     802604 <read+0xb9>

    return (*dev->dev_read)(fd, buf, n);
  8025ae:	4c 89 ea             	mov    %r13,%rdx
  8025b1:	4c 89 e6             	mov    %r12,%rsi
  8025b4:	4c 89 f7             	mov    %r14,%rdi
  8025b7:	ff d0                	call   *%rax
}
  8025b9:	48 83 c4 10          	add    $0x10,%rsp
  8025bd:	5b                   	pop    %rbx
  8025be:	41 5c                	pop    %r12
  8025c0:	41 5d                	pop    %r13
  8025c2:	41 5e                	pop    %r14
  8025c4:	5d                   	pop    %rbp
  8025c5:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8025c6:	48 98                	cltq
  8025c8:	eb ef                	jmp    8025b9 <read+0x6e>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8025ca:	48 98                	cltq
  8025cc:	eb eb                	jmp    8025b9 <read+0x6e>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8025ce:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  8025d5:	00 00 00 
  8025d8:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  8025de:	89 da                	mov    %ebx,%edx
  8025e0:	48 bf 86 43 80 00 00 	movabs $0x804386,%rdi
  8025e7:	00 00 00 
  8025ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ef:	48 b9 eb 0c 80 00 00 	movabs $0x800ceb,%rcx
  8025f6:	00 00 00 
  8025f9:	ff d1                	call   *%rcx
        return -E_INVAL;
  8025fb:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  802602:	eb b5                	jmp    8025b9 <read+0x6e>
    if (!dev->dev_read) return -E_NOT_SUPP;
  802604:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  80260b:	eb ac                	jmp    8025b9 <read+0x6e>

000000000080260d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  80260d:	f3 0f 1e fa          	endbr64
  802611:	55                   	push   %rbp
  802612:	48 89 e5             	mov    %rsp,%rbp
  802615:	41 57                	push   %r15
  802617:	41 56                	push   %r14
  802619:	41 55                	push   %r13
  80261b:	41 54                	push   %r12
  80261d:	53                   	push   %rbx
  80261e:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  802622:	48 85 d2             	test   %rdx,%rdx
  802625:	74 54                	je     80267b <readn+0x6e>
  802627:	41 89 fd             	mov    %edi,%r13d
  80262a:	49 89 f6             	mov    %rsi,%r14
  80262d:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  802630:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  802635:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  80263a:	49 bf 4b 25 80 00 00 	movabs $0x80254b,%r15
  802641:	00 00 00 
  802644:	4c 89 e2             	mov    %r12,%rdx
  802647:	48 29 f2             	sub    %rsi,%rdx
  80264a:	4c 01 f6             	add    %r14,%rsi
  80264d:	44 89 ef             	mov    %r13d,%edi
  802650:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  802653:	85 c0                	test   %eax,%eax
  802655:	78 20                	js     802677 <readn+0x6a>
    for (; inc && res < n; res += inc) {
  802657:	01 c3                	add    %eax,%ebx
  802659:	85 c0                	test   %eax,%eax
  80265b:	74 08                	je     802665 <readn+0x58>
  80265d:	48 63 f3             	movslq %ebx,%rsi
  802660:	4c 39 e6             	cmp    %r12,%rsi
  802663:	72 df                	jb     802644 <readn+0x37>
    }
    return res;
  802665:	48 63 c3             	movslq %ebx,%rax
}
  802668:	48 83 c4 08          	add    $0x8,%rsp
  80266c:	5b                   	pop    %rbx
  80266d:	41 5c                	pop    %r12
  80266f:	41 5d                	pop    %r13
  802671:	41 5e                	pop    %r14
  802673:	41 5f                	pop    %r15
  802675:	5d                   	pop    %rbp
  802676:	c3                   	ret
        if (inc < 0) return inc;
  802677:	48 98                	cltq
  802679:	eb ed                	jmp    802668 <readn+0x5b>
    int inc = 1, res = 0;
  80267b:	bb 00 00 00 00       	mov    $0x0,%ebx
  802680:	eb e3                	jmp    802665 <readn+0x58>

0000000000802682 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  802682:	f3 0f 1e fa          	endbr64
  802686:	55                   	push   %rbp
  802687:	48 89 e5             	mov    %rsp,%rbp
  80268a:	41 56                	push   %r14
  80268c:	41 55                	push   %r13
  80268e:	41 54                	push   %r12
  802690:	53                   	push   %rbx
  802691:	48 83 ec 10          	sub    $0x10,%rsp
  802695:	89 fb                	mov    %edi,%ebx
  802697:	49 89 f4             	mov    %rsi,%r12
  80269a:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  80269d:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8026a1:	48 b8 50 22 80 00 00 	movabs $0x802250,%rax
  8026a8:	00 00 00 
  8026ab:	ff d0                	call   *%rax
  8026ad:	85 c0                	test   %eax,%eax
  8026af:	78 47                	js     8026f8 <write+0x76>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8026b1:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  8026b5:	41 8b 3e             	mov    (%r14),%edi
  8026b8:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8026bc:	48 b8 9f 22 80 00 00 	movabs $0x80229f,%rax
  8026c3:	00 00 00 
  8026c6:	ff d0                	call   *%rax
  8026c8:	85 c0                	test   %eax,%eax
  8026ca:	78 30                	js     8026fc <write+0x7a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8026cc:	41 f6 46 08 03       	testb  $0x3,0x8(%r14)
  8026d1:	74 2d                	je     802700 <write+0x7e>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  8026d3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026d7:	48 8b 40 18          	mov    0x18(%rax),%rax
  8026db:	48 85 c0             	test   %rax,%rax
  8026de:	74 56                	je     802736 <write+0xb4>

    return (*dev->dev_write)(fd, buf, n);
  8026e0:	4c 89 ea             	mov    %r13,%rdx
  8026e3:	4c 89 e6             	mov    %r12,%rsi
  8026e6:	4c 89 f7             	mov    %r14,%rdi
  8026e9:	ff d0                	call   *%rax
}
  8026eb:	48 83 c4 10          	add    $0x10,%rsp
  8026ef:	5b                   	pop    %rbx
  8026f0:	41 5c                	pop    %r12
  8026f2:	41 5d                	pop    %r13
  8026f4:	41 5e                	pop    %r14
  8026f6:	5d                   	pop    %rbp
  8026f7:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8026f8:	48 98                	cltq
  8026fa:	eb ef                	jmp    8026eb <write+0x69>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8026fc:	48 98                	cltq
  8026fe:	eb eb                	jmp    8026eb <write+0x69>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802700:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  802707:	00 00 00 
  80270a:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  802710:	89 da                	mov    %ebx,%edx
  802712:	48 bf a2 43 80 00 00 	movabs $0x8043a2,%rdi
  802719:	00 00 00 
  80271c:	b8 00 00 00 00       	mov    $0x0,%eax
  802721:	48 b9 eb 0c 80 00 00 	movabs $0x800ceb,%rcx
  802728:	00 00 00 
  80272b:	ff d1                	call   *%rcx
        return -E_INVAL;
  80272d:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  802734:	eb b5                	jmp    8026eb <write+0x69>
    if (!dev->dev_write) return -E_NOT_SUPP;
  802736:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  80273d:	eb ac                	jmp    8026eb <write+0x69>

000000000080273f <seek>:

int
seek(int fdnum, off_t offset) {
  80273f:	f3 0f 1e fa          	endbr64
  802743:	55                   	push   %rbp
  802744:	48 89 e5             	mov    %rsp,%rbp
  802747:	53                   	push   %rbx
  802748:	48 83 ec 18          	sub    $0x18,%rsp
  80274c:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  80274e:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  802752:	48 b8 50 22 80 00 00 	movabs $0x802250,%rax
  802759:	00 00 00 
  80275c:	ff d0                	call   *%rax
  80275e:	85 c0                	test   %eax,%eax
  802760:	78 0c                	js     80276e <seek+0x2f>

    fd->fd_offset = offset;
  802762:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802766:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  802769:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80276e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  802772:	c9                   	leave
  802773:	c3                   	ret

0000000000802774 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  802774:	f3 0f 1e fa          	endbr64
  802778:	55                   	push   %rbp
  802779:	48 89 e5             	mov    %rsp,%rbp
  80277c:	41 55                	push   %r13
  80277e:	41 54                	push   %r12
  802780:	53                   	push   %rbx
  802781:	48 83 ec 18          	sub    $0x18,%rsp
  802785:	89 fb                	mov    %edi,%ebx
  802787:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  80278a:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  80278e:	48 b8 50 22 80 00 00 	movabs $0x802250,%rax
  802795:	00 00 00 
  802798:	ff d0                	call   *%rax
  80279a:	85 c0                	test   %eax,%eax
  80279c:	78 38                	js     8027d6 <ftruncate+0x62>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  80279e:	4c 8b 6d d8          	mov    -0x28(%rbp),%r13
  8027a2:	41 8b 7d 00          	mov    0x0(%r13),%edi
  8027a6:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8027aa:	48 b8 9f 22 80 00 00 	movabs $0x80229f,%rax
  8027b1:	00 00 00 
  8027b4:	ff d0                	call   *%rax
  8027b6:	85 c0                	test   %eax,%eax
  8027b8:	78 1c                	js     8027d6 <ftruncate+0x62>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8027ba:	41 f6 45 08 03       	testb  $0x3,0x8(%r13)
  8027bf:	74 20                	je     8027e1 <ftruncate+0x6d>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  8027c1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8027c5:	48 8b 40 30          	mov    0x30(%rax),%rax
  8027c9:	48 85 c0             	test   %rax,%rax
  8027cc:	74 47                	je     802815 <ftruncate+0xa1>

    return (*dev->dev_trunc)(fd, newsize);
  8027ce:	44 89 e6             	mov    %r12d,%esi
  8027d1:	4c 89 ef             	mov    %r13,%rdi
  8027d4:	ff d0                	call   *%rax
}
  8027d6:	48 83 c4 18          	add    $0x18,%rsp
  8027da:	5b                   	pop    %rbx
  8027db:	41 5c                	pop    %r12
  8027dd:	41 5d                	pop    %r13
  8027df:	5d                   	pop    %rbp
  8027e0:	c3                   	ret
                thisenv->env_id, fdnum);
  8027e1:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  8027e8:	00 00 00 
  8027eb:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  8027f1:	89 da                	mov    %ebx,%edx
  8027f3:	48 bf b8 46 80 00 00 	movabs $0x8046b8,%rdi
  8027fa:	00 00 00 
  8027fd:	b8 00 00 00 00       	mov    $0x0,%eax
  802802:	48 b9 eb 0c 80 00 00 	movabs $0x800ceb,%rcx
  802809:	00 00 00 
  80280c:	ff d1                	call   *%rcx
        return -E_INVAL;
  80280e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802813:	eb c1                	jmp    8027d6 <ftruncate+0x62>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  802815:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  80281a:	eb ba                	jmp    8027d6 <ftruncate+0x62>

000000000080281c <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  80281c:	f3 0f 1e fa          	endbr64
  802820:	55                   	push   %rbp
  802821:	48 89 e5             	mov    %rsp,%rbp
  802824:	41 54                	push   %r12
  802826:	53                   	push   %rbx
  802827:	48 83 ec 10          	sub    $0x10,%rsp
  80282b:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  80282e:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  802832:	48 b8 50 22 80 00 00 	movabs $0x802250,%rax
  802839:	00 00 00 
  80283c:	ff d0                	call   *%rax
  80283e:	85 c0                	test   %eax,%eax
  802840:	78 4e                	js     802890 <fstat+0x74>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  802842:	4c 8b 65 e8          	mov    -0x18(%rbp),%r12
  802846:	41 8b 3c 24          	mov    (%r12),%edi
  80284a:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  80284e:	48 b8 9f 22 80 00 00 	movabs $0x80229f,%rax
  802855:	00 00 00 
  802858:	ff d0                	call   *%rax
  80285a:	85 c0                	test   %eax,%eax
  80285c:	78 32                	js     802890 <fstat+0x74>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  80285e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802862:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  802867:	74 30                	je     802899 <fstat+0x7d>

    stat->st_name[0] = 0;
  802869:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  80286c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  802873:	00 00 00 
    stat->st_isdir = 0;
  802876:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  80287d:	00 00 00 
    stat->st_dev = dev;
  802880:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  802887:	48 89 de             	mov    %rbx,%rsi
  80288a:	4c 89 e7             	mov    %r12,%rdi
  80288d:	ff 50 28             	call   *0x28(%rax)
}
  802890:	48 83 c4 10          	add    $0x10,%rsp
  802894:	5b                   	pop    %rbx
  802895:	41 5c                	pop    %r12
  802897:	5d                   	pop    %rbp
  802898:	c3                   	ret
    if (!dev->dev_stat) return -E_NOT_SUPP;
  802899:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  80289e:	eb f0                	jmp    802890 <fstat+0x74>

00000000008028a0 <stat>:

int
stat(const char *path, struct Stat *stat) {
  8028a0:	f3 0f 1e fa          	endbr64
  8028a4:	55                   	push   %rbp
  8028a5:	48 89 e5             	mov    %rsp,%rbp
  8028a8:	41 54                	push   %r12
  8028aa:	53                   	push   %rbx
  8028ab:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  8028ae:	be 00 00 00 00       	mov    $0x0,%esi
  8028b3:	48 b8 81 2b 80 00 00 	movabs $0x802b81,%rax
  8028ba:	00 00 00 
  8028bd:	ff d0                	call   *%rax
  8028bf:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  8028c1:	85 c0                	test   %eax,%eax
  8028c3:	78 25                	js     8028ea <stat+0x4a>

    int res = fstat(fd, stat);
  8028c5:	4c 89 e6             	mov    %r12,%rsi
  8028c8:	89 c7                	mov    %eax,%edi
  8028ca:	48 b8 1c 28 80 00 00 	movabs $0x80281c,%rax
  8028d1:	00 00 00 
  8028d4:	ff d0                	call   *%rax
  8028d6:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  8028d9:	89 df                	mov    %ebx,%edi
  8028db:	48 b8 c1 23 80 00 00 	movabs $0x8023c1,%rax
  8028e2:	00 00 00 
  8028e5:	ff d0                	call   *%rax

    return res;
  8028e7:	44 89 e3             	mov    %r12d,%ebx
}
  8028ea:	89 d8                	mov    %ebx,%eax
  8028ec:	5b                   	pop    %rbx
  8028ed:	41 5c                	pop    %r12
  8028ef:	5d                   	pop    %rbp
  8028f0:	c3                   	ret

00000000008028f1 <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  8028f1:	f3 0f 1e fa          	endbr64
  8028f5:	55                   	push   %rbp
  8028f6:	48 89 e5             	mov    %rsp,%rbp
  8028f9:	41 54                	push   %r12
  8028fb:	53                   	push   %rbx
  8028fc:	48 83 ec 10          	sub    $0x10,%rsp
  802900:	41 89 fc             	mov    %edi,%r12d
  802903:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  802906:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80290d:	00 00 00 
  802910:	83 38 00             	cmpl   $0x0,(%rax)
  802913:	74 6e                	je     802983 <fsipc+0x92>

    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }
    fsenv = ipc_find_env(ENV_TYPE_FS);
  802915:	bf 03 00 00 00       	mov    $0x3,%edi
  80291a:	48 b8 58 21 80 00 00 	movabs $0x802158,%rax
  802921:	00 00 00 
  802924:	ff d0                	call   *%rax
  802926:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  80292d:	00 00 
    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  80292f:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  802935:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80293a:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802941:	00 00 00 
  802944:	44 89 e6             	mov    %r12d,%esi
  802947:	89 c7                	mov    %eax,%edi
  802949:	48 b8 96 20 80 00 00 	movabs $0x802096,%rax
  802950:	00 00 00 
  802953:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  802955:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  80295c:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  80295d:	b9 00 00 00 00       	mov    $0x0,%ecx
  802962:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802966:	48 89 de             	mov    %rbx,%rsi
  802969:	bf 00 00 00 00       	mov    $0x0,%edi
  80296e:	48 b8 fd 1f 80 00 00 	movabs $0x801ffd,%rax
  802975:	00 00 00 
  802978:	ff d0                	call   *%rax
}
  80297a:	48 83 c4 10          	add    $0x10,%rsp
  80297e:	5b                   	pop    %rbx
  80297f:	41 5c                	pop    %r12
  802981:	5d                   	pop    %rbp
  802982:	c3                   	ret
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  802983:	bf 03 00 00 00       	mov    $0x3,%edi
  802988:	48 b8 58 21 80 00 00 	movabs $0x802158,%rax
  80298f:	00 00 00 
  802992:	ff d0                	call   *%rax
  802994:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  80299b:	00 00 
  80299d:	e9 73 ff ff ff       	jmp    802915 <fsipc+0x24>

00000000008029a2 <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  8029a2:	f3 0f 1e fa          	endbr64
  8029a6:	55                   	push   %rbp
  8029a7:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8029aa:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8029b1:	00 00 00 
  8029b4:	8b 57 0c             	mov    0xc(%rdi),%edx
  8029b7:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  8029b9:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  8029bc:	be 00 00 00 00       	mov    $0x0,%esi
  8029c1:	bf 02 00 00 00       	mov    $0x2,%edi
  8029c6:	48 b8 f1 28 80 00 00 	movabs $0x8028f1,%rax
  8029cd:	00 00 00 
  8029d0:	ff d0                	call   *%rax
}
  8029d2:	5d                   	pop    %rbp
  8029d3:	c3                   	ret

00000000008029d4 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  8029d4:	f3 0f 1e fa          	endbr64
  8029d8:	55                   	push   %rbp
  8029d9:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8029dc:	8b 47 0c             	mov    0xc(%rdi),%eax
  8029df:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  8029e6:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  8029e8:	be 00 00 00 00       	mov    $0x0,%esi
  8029ed:	bf 06 00 00 00       	mov    $0x6,%edi
  8029f2:	48 b8 f1 28 80 00 00 	movabs $0x8028f1,%rax
  8029f9:	00 00 00 
  8029fc:	ff d0                	call   *%rax
}
  8029fe:	5d                   	pop    %rbp
  8029ff:	c3                   	ret

0000000000802a00 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  802a00:	f3 0f 1e fa          	endbr64
  802a04:	55                   	push   %rbp
  802a05:	48 89 e5             	mov    %rsp,%rbp
  802a08:	41 54                	push   %r12
  802a0a:	53                   	push   %rbx
  802a0b:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802a0e:	8b 47 0c             	mov    0xc(%rdi),%eax
  802a11:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  802a18:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  802a1a:	be 00 00 00 00       	mov    $0x0,%esi
  802a1f:	bf 05 00 00 00       	mov    $0x5,%edi
  802a24:	48 b8 f1 28 80 00 00 	movabs $0x8028f1,%rax
  802a2b:	00 00 00 
  802a2e:	ff d0                	call   *%rax
    if (res < 0) return res;
  802a30:	85 c0                	test   %eax,%eax
  802a32:	78 3d                	js     802a71 <devfile_stat+0x71>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802a34:	49 bc 00 70 80 00 00 	movabs $0x807000,%r12
  802a3b:	00 00 00 
  802a3e:	4c 89 e6             	mov    %r12,%rsi
  802a41:	48 89 df             	mov    %rbx,%rdi
  802a44:	48 b8 34 16 80 00 00 	movabs $0x801634,%rax
  802a4b:	00 00 00 
  802a4e:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  802a50:	41 8b 84 24 80 00 00 	mov    0x80(%r12),%eax
  802a57:	00 
  802a58:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802a5e:	41 8b 84 24 84 00 00 	mov    0x84(%r12),%eax
  802a65:	00 
  802a66:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  802a6c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a71:	5b                   	pop    %rbx
  802a72:	41 5c                	pop    %r12
  802a74:	5d                   	pop    %rbp
  802a75:	c3                   	ret

0000000000802a76 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  802a76:	f3 0f 1e fa          	endbr64
    if (n >= sizeof(fsipcbuf.write.req_buf)) {
  802a7a:	48 81 fa ef 0f 00 00 	cmp    $0xfef,%rdx
  802a81:	77 41                	ja     802ac4 <devfile_write+0x4e>
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  802a83:	55                   	push   %rbp
  802a84:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  802a87:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802a8e:	00 00 00 
  802a91:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  802a94:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.write.req_n = n;
  802a96:	48 89 50 08          	mov    %rdx,0x8(%rax)
    memmove(fsipcbuf.write.req_buf, buf, n);
  802a9a:	48 8d 78 10          	lea    0x10(%rax),%rdi
  802a9e:	48 b8 4f 18 80 00 00 	movabs $0x80184f,%rax
  802aa5:	00 00 00 
  802aa8:	ff d0                	call   *%rax
    res = fsipc(FSREQ_WRITE, NULL);
  802aaa:	be 00 00 00 00       	mov    $0x0,%esi
  802aaf:	bf 04 00 00 00       	mov    $0x4,%edi
  802ab4:	48 b8 f1 28 80 00 00 	movabs $0x8028f1,%rax
  802abb:	00 00 00 
  802abe:	ff d0                	call   *%rax
  802ac0:	48 98                	cltq
}
  802ac2:	5d                   	pop    %rbp
  802ac3:	c3                   	ret
        return -E_INVAL;
  802ac4:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
}
  802acb:	c3                   	ret

0000000000802acc <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  802acc:	f3 0f 1e fa          	endbr64
  802ad0:	55                   	push   %rbp
  802ad1:	48 89 e5             	mov    %rsp,%rbp
  802ad4:	41 55                	push   %r13
  802ad6:	41 54                	push   %r12
  802ad8:	53                   	push   %rbx
  802ad9:	48 83 ec 08          	sub    $0x8,%rsp
  802add:	49 89 f4             	mov    %rsi,%r12
  802ae0:	48 89 d3             	mov    %rdx,%rbx
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  802ae3:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802aea:	00 00 00 
  802aed:	8b 57 0c             	mov    0xc(%rdi),%edx
  802af0:	89 10                	mov    %edx,(%rax)
    fsipcbuf.read.req_n = n;
  802af2:	48 89 58 08          	mov    %rbx,0x8(%rax)
    res = fsipc(FSREQ_READ, NULL);
  802af6:	be 00 00 00 00       	mov    $0x0,%esi
  802afb:	bf 03 00 00 00       	mov    $0x3,%edi
  802b00:	48 b8 f1 28 80 00 00 	movabs $0x8028f1,%rax
  802b07:	00 00 00 
  802b0a:	ff d0                	call   *%rax
  802b0c:	4c 63 e8             	movslq %eax,%r13
    if (res < 0) {
  802b0f:	4d 85 ed             	test   %r13,%r13
  802b12:	78 2a                	js     802b3e <devfile_read+0x72>
    assert(res <= n && res <= PAGE_SIZE);
  802b14:	4c 89 ea             	mov    %r13,%rdx
  802b17:	4c 39 eb             	cmp    %r13,%rbx
  802b1a:	72 30                	jb     802b4c <devfile_read+0x80>
  802b1c:	49 81 fd 00 10 00 00 	cmp    $0x1000,%r13
  802b23:	7f 27                	jg     802b4c <devfile_read+0x80>
    memmove(buf, &fsipcbuf, res);
  802b25:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802b2c:	00 00 00 
  802b2f:	4c 89 e7             	mov    %r12,%rdi
  802b32:	48 b8 4f 18 80 00 00 	movabs $0x80184f,%rax
  802b39:	00 00 00 
  802b3c:	ff d0                	call   *%rax
}
  802b3e:	4c 89 e8             	mov    %r13,%rax
  802b41:	48 83 c4 08          	add    $0x8,%rsp
  802b45:	5b                   	pop    %rbx
  802b46:	41 5c                	pop    %r12
  802b48:	41 5d                	pop    %r13
  802b4a:	5d                   	pop    %rbp
  802b4b:	c3                   	ret
    assert(res <= n && res <= PAGE_SIZE);
  802b4c:	48 b9 bf 43 80 00 00 	movabs $0x8043bf,%rcx
  802b53:	00 00 00 
  802b56:	48 ba dc 43 80 00 00 	movabs $0x8043dc,%rdx
  802b5d:	00 00 00 
  802b60:	be 7b 00 00 00       	mov    $0x7b,%esi
  802b65:	48 bf f1 43 80 00 00 	movabs $0x8043f1,%rdi
  802b6c:	00 00 00 
  802b6f:	b8 00 00 00 00       	mov    $0x0,%eax
  802b74:	49 b8 8f 0b 80 00 00 	movabs $0x800b8f,%r8
  802b7b:	00 00 00 
  802b7e:	41 ff d0             	call   *%r8

0000000000802b81 <open>:
open(const char *path, int mode) {
  802b81:	f3 0f 1e fa          	endbr64
  802b85:	55                   	push   %rbp
  802b86:	48 89 e5             	mov    %rsp,%rbp
  802b89:	41 55                	push   %r13
  802b8b:	41 54                	push   %r12
  802b8d:	53                   	push   %rbx
  802b8e:	48 83 ec 18          	sub    $0x18,%rsp
  802b92:	49 89 fc             	mov    %rdi,%r12
  802b95:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  802b98:	48 b8 ef 15 80 00 00 	movabs $0x8015ef,%rax
  802b9f:	00 00 00 
  802ba2:	ff d0                	call   *%rax
  802ba4:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  802baa:	0f 87 8a 00 00 00    	ja     802c3a <open+0xb9>
    if ((res = fd_alloc(&fd)) < 0) return res;
  802bb0:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802bb4:	48 b8 ec 21 80 00 00 	movabs $0x8021ec,%rax
  802bbb:	00 00 00 
  802bbe:	ff d0                	call   *%rax
  802bc0:	89 c3                	mov    %eax,%ebx
  802bc2:	85 c0                	test   %eax,%eax
  802bc4:	78 50                	js     802c16 <open+0x95>
    strcpy(fsipcbuf.open.req_path, path);
  802bc6:	4c 89 e6             	mov    %r12,%rsi
  802bc9:	48 bb 00 70 80 00 00 	movabs $0x807000,%rbx
  802bd0:	00 00 00 
  802bd3:	48 89 df             	mov    %rbx,%rdi
  802bd6:	48 b8 34 16 80 00 00 	movabs $0x801634,%rax
  802bdd:	00 00 00 
  802be0:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  802be2:	44 89 ab 00 04 00 00 	mov    %r13d,0x400(%rbx)
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  802be9:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802bed:	bf 01 00 00 00       	mov    $0x1,%edi
  802bf2:	48 b8 f1 28 80 00 00 	movabs $0x8028f1,%rax
  802bf9:	00 00 00 
  802bfc:	ff d0                	call   *%rax
  802bfe:	89 c3                	mov    %eax,%ebx
  802c00:	85 c0                	test   %eax,%eax
  802c02:	78 1f                	js     802c23 <open+0xa2>
    return fd2num(fd);
  802c04:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802c08:	48 b8 b6 21 80 00 00 	movabs $0x8021b6,%rax
  802c0f:	00 00 00 
  802c12:	ff d0                	call   *%rax
  802c14:	89 c3                	mov    %eax,%ebx
}
  802c16:	89 d8                	mov    %ebx,%eax
  802c18:	48 83 c4 18          	add    $0x18,%rsp
  802c1c:	5b                   	pop    %rbx
  802c1d:	41 5c                	pop    %r12
  802c1f:	41 5d                	pop    %r13
  802c21:	5d                   	pop    %rbp
  802c22:	c3                   	ret
        fd_close(fd, 0);
  802c23:	be 00 00 00 00       	mov    $0x0,%esi
  802c28:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802c2c:	48 b8 13 23 80 00 00 	movabs $0x802313,%rax
  802c33:	00 00 00 
  802c36:	ff d0                	call   *%rax
        return res;
  802c38:	eb dc                	jmp    802c16 <open+0x95>
        return -E_BAD_PATH;
  802c3a:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  802c3f:	eb d5                	jmp    802c16 <open+0x95>

0000000000802c41 <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  802c41:	f3 0f 1e fa          	endbr64
  802c45:	55                   	push   %rbp
  802c46:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  802c49:	be 00 00 00 00       	mov    $0x0,%esi
  802c4e:	bf 08 00 00 00       	mov    $0x8,%edi
  802c53:	48 b8 f1 28 80 00 00 	movabs $0x8028f1,%rax
  802c5a:	00 00 00 
  802c5d:	ff d0                	call   *%rax
}
  802c5f:	5d                   	pop    %rbp
  802c60:	c3                   	ret

0000000000802c61 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  802c61:	f3 0f 1e fa          	endbr64
  802c65:	55                   	push   %rbp
  802c66:	48 89 e5             	mov    %rsp,%rbp
  802c69:	41 54                	push   %r12
  802c6b:	53                   	push   %rbx
  802c6c:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802c6f:	48 b8 cc 21 80 00 00 	movabs $0x8021cc,%rax
  802c76:	00 00 00 
  802c79:	ff d0                	call   *%rax
  802c7b:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  802c7e:	48 be fc 43 80 00 00 	movabs $0x8043fc,%rsi
  802c85:	00 00 00 
  802c88:	48 89 df             	mov    %rbx,%rdi
  802c8b:	48 b8 34 16 80 00 00 	movabs $0x801634,%rax
  802c92:	00 00 00 
  802c95:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  802c97:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  802c9c:	41 2b 04 24          	sub    (%r12),%eax
  802ca0:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  802ca6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  802cad:	00 00 00 
    stat->st_dev = &devpipe;
  802cb0:	48 b8 60 50 80 00 00 	movabs $0x805060,%rax
  802cb7:	00 00 00 
  802cba:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  802cc1:	b8 00 00 00 00       	mov    $0x0,%eax
  802cc6:	5b                   	pop    %rbx
  802cc7:	41 5c                	pop    %r12
  802cc9:	5d                   	pop    %rbp
  802cca:	c3                   	ret

0000000000802ccb <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  802ccb:	f3 0f 1e fa          	endbr64
  802ccf:	55                   	push   %rbp
  802cd0:	48 89 e5             	mov    %rsp,%rbp
  802cd3:	41 54                	push   %r12
  802cd5:	53                   	push   %rbx
  802cd6:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  802cd9:	ba 00 10 00 00       	mov    $0x1000,%edx
  802cde:	48 89 fe             	mov    %rdi,%rsi
  802ce1:	bf 00 00 00 00       	mov    $0x0,%edi
  802ce6:	49 bc 79 1d 80 00 00 	movabs $0x801d79,%r12
  802ced:	00 00 00 
  802cf0:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  802cf3:	48 89 df             	mov    %rbx,%rdi
  802cf6:	48 b8 cc 21 80 00 00 	movabs $0x8021cc,%rax
  802cfd:	00 00 00 
  802d00:	ff d0                	call   *%rax
  802d02:	48 89 c6             	mov    %rax,%rsi
  802d05:	ba 00 10 00 00       	mov    $0x1000,%edx
  802d0a:	bf 00 00 00 00       	mov    $0x0,%edi
  802d0f:	41 ff d4             	call   *%r12
}
  802d12:	5b                   	pop    %rbx
  802d13:	41 5c                	pop    %r12
  802d15:	5d                   	pop    %rbp
  802d16:	c3                   	ret

0000000000802d17 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  802d17:	f3 0f 1e fa          	endbr64
  802d1b:	55                   	push   %rbp
  802d1c:	48 89 e5             	mov    %rsp,%rbp
  802d1f:	41 57                	push   %r15
  802d21:	41 56                	push   %r14
  802d23:	41 55                	push   %r13
  802d25:	41 54                	push   %r12
  802d27:	53                   	push   %rbx
  802d28:	48 83 ec 18          	sub    $0x18,%rsp
  802d2c:	49 89 fc             	mov    %rdi,%r12
  802d2f:	49 89 f5             	mov    %rsi,%r13
  802d32:	49 89 d7             	mov    %rdx,%r15
  802d35:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802d39:	48 b8 cc 21 80 00 00 	movabs $0x8021cc,%rax
  802d40:	00 00 00 
  802d43:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  802d45:	4d 85 ff             	test   %r15,%r15
  802d48:	0f 84 af 00 00 00    	je     802dfd <devpipe_write+0xe6>
  802d4e:	48 89 c3             	mov    %rax,%rbx
  802d51:	4c 89 f8             	mov    %r15,%rax
  802d54:	4d 89 ef             	mov    %r13,%r15
  802d57:	4c 01 e8             	add    %r13,%rax
  802d5a:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802d5e:	49 bd 09 1c 80 00 00 	movabs $0x801c09,%r13
  802d65:	00 00 00 
            sys_yield();
  802d68:	49 be 9e 1b 80 00 00 	movabs $0x801b9e,%r14
  802d6f:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  802d72:	8b 73 04             	mov    0x4(%rbx),%esi
  802d75:	48 63 ce             	movslq %esi,%rcx
  802d78:	48 63 03             	movslq (%rbx),%rax
  802d7b:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  802d81:	48 39 c1             	cmp    %rax,%rcx
  802d84:	72 2e                	jb     802db4 <devpipe_write+0x9d>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802d86:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802d8b:	48 89 da             	mov    %rbx,%rdx
  802d8e:	be 00 10 00 00       	mov    $0x1000,%esi
  802d93:	4c 89 e7             	mov    %r12,%rdi
  802d96:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802d99:	85 c0                	test   %eax,%eax
  802d9b:	74 66                	je     802e03 <devpipe_write+0xec>
            sys_yield();
  802d9d:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  802da0:	8b 73 04             	mov    0x4(%rbx),%esi
  802da3:	48 63 ce             	movslq %esi,%rcx
  802da6:	48 63 03             	movslq (%rbx),%rax
  802da9:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  802daf:	48 39 c1             	cmp    %rax,%rcx
  802db2:	73 d2                	jae    802d86 <devpipe_write+0x6f>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802db4:	41 0f b6 3f          	movzbl (%r15),%edi
  802db8:	48 89 ca             	mov    %rcx,%rdx
  802dbb:	48 c1 ea 03          	shr    $0x3,%rdx
  802dbf:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  802dc6:	08 10 20 
  802dc9:	48 f7 e2             	mul    %rdx
  802dcc:	48 c1 ea 06          	shr    $0x6,%rdx
  802dd0:	48 89 d0             	mov    %rdx,%rax
  802dd3:	48 c1 e0 09          	shl    $0x9,%rax
  802dd7:	48 29 d0             	sub    %rdx,%rax
  802dda:	48 c1 e0 03          	shl    $0x3,%rax
  802dde:	48 29 c1             	sub    %rax,%rcx
  802de1:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  802de6:	83 c6 01             	add    $0x1,%esi
  802de9:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  802dec:	49 83 c7 01          	add    $0x1,%r15
  802df0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802df4:	49 39 c7             	cmp    %rax,%r15
  802df7:	0f 85 75 ff ff ff    	jne    802d72 <devpipe_write+0x5b>
    return n;
  802dfd:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802e01:	eb 05                	jmp    802e08 <devpipe_write+0xf1>
            if (_pipeisclosed(fd, p)) return 0;
  802e03:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e08:	48 83 c4 18          	add    $0x18,%rsp
  802e0c:	5b                   	pop    %rbx
  802e0d:	41 5c                	pop    %r12
  802e0f:	41 5d                	pop    %r13
  802e11:	41 5e                	pop    %r14
  802e13:	41 5f                	pop    %r15
  802e15:	5d                   	pop    %rbp
  802e16:	c3                   	ret

0000000000802e17 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  802e17:	f3 0f 1e fa          	endbr64
  802e1b:	55                   	push   %rbp
  802e1c:	48 89 e5             	mov    %rsp,%rbp
  802e1f:	41 57                	push   %r15
  802e21:	41 56                	push   %r14
  802e23:	41 55                	push   %r13
  802e25:	41 54                	push   %r12
  802e27:	53                   	push   %rbx
  802e28:	48 83 ec 18          	sub    $0x18,%rsp
  802e2c:	49 89 fc             	mov    %rdi,%r12
  802e2f:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  802e33:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802e37:	48 b8 cc 21 80 00 00 	movabs $0x8021cc,%rax
  802e3e:	00 00 00 
  802e41:	ff d0                	call   *%rax
  802e43:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  802e46:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802e4c:	49 bd 09 1c 80 00 00 	movabs $0x801c09,%r13
  802e53:	00 00 00 
            sys_yield();
  802e56:	49 be 9e 1b 80 00 00 	movabs $0x801b9e,%r14
  802e5d:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  802e60:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  802e65:	74 7d                	je     802ee4 <devpipe_read+0xcd>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802e67:	8b 03                	mov    (%rbx),%eax
  802e69:	3b 43 04             	cmp    0x4(%rbx),%eax
  802e6c:	75 26                	jne    802e94 <devpipe_read+0x7d>
            if (i > 0) return i;
  802e6e:	4d 85 ff             	test   %r15,%r15
  802e71:	75 77                	jne    802eea <devpipe_read+0xd3>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802e73:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802e78:	48 89 da             	mov    %rbx,%rdx
  802e7b:	be 00 10 00 00       	mov    $0x1000,%esi
  802e80:	4c 89 e7             	mov    %r12,%rdi
  802e83:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802e86:	85 c0                	test   %eax,%eax
  802e88:	74 72                	je     802efc <devpipe_read+0xe5>
            sys_yield();
  802e8a:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802e8d:	8b 03                	mov    (%rbx),%eax
  802e8f:	3b 43 04             	cmp    0x4(%rbx),%eax
  802e92:	74 df                	je     802e73 <devpipe_read+0x5c>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802e94:	48 63 c8             	movslq %eax,%rcx
  802e97:	48 89 ca             	mov    %rcx,%rdx
  802e9a:	48 c1 ea 03          	shr    $0x3,%rdx
  802e9e:	48 be 81 00 01 02 04 	movabs $0x2010080402010081,%rsi
  802ea5:	08 10 20 
  802ea8:	48 89 d0             	mov    %rdx,%rax
  802eab:	48 f7 e6             	mul    %rsi
  802eae:	48 c1 ea 06          	shr    $0x6,%rdx
  802eb2:	48 89 d0             	mov    %rdx,%rax
  802eb5:	48 c1 e0 09          	shl    $0x9,%rax
  802eb9:	48 29 d0             	sub    %rdx,%rax
  802ebc:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802ec3:	00 
  802ec4:	48 89 c8             	mov    %rcx,%rax
  802ec7:	48 29 d0             	sub    %rdx,%rax
  802eca:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  802ecf:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  802ed3:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  802ed7:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  802eda:	49 83 c7 01          	add    $0x1,%r15
  802ede:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  802ee2:	75 83                	jne    802e67 <devpipe_read+0x50>
    return n;
  802ee4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802ee8:	eb 03                	jmp    802eed <devpipe_read+0xd6>
            if (i > 0) return i;
  802eea:	4c 89 f8             	mov    %r15,%rax
}
  802eed:	48 83 c4 18          	add    $0x18,%rsp
  802ef1:	5b                   	pop    %rbx
  802ef2:	41 5c                	pop    %r12
  802ef4:	41 5d                	pop    %r13
  802ef6:	41 5e                	pop    %r14
  802ef8:	41 5f                	pop    %r15
  802efa:	5d                   	pop    %rbp
  802efb:	c3                   	ret
            if (_pipeisclosed(fd, p)) return 0;
  802efc:	b8 00 00 00 00       	mov    $0x0,%eax
  802f01:	eb ea                	jmp    802eed <devpipe_read+0xd6>

0000000000802f03 <pipe>:
pipe(int pfd[2]) {
  802f03:	f3 0f 1e fa          	endbr64
  802f07:	55                   	push   %rbp
  802f08:	48 89 e5             	mov    %rsp,%rbp
  802f0b:	41 55                	push   %r13
  802f0d:	41 54                	push   %r12
  802f0f:	53                   	push   %rbx
  802f10:	48 83 ec 18          	sub    $0x18,%rsp
  802f14:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  802f17:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802f1b:	48 b8 ec 21 80 00 00 	movabs $0x8021ec,%rax
  802f22:	00 00 00 
  802f25:	ff d0                	call   *%rax
  802f27:	89 c3                	mov    %eax,%ebx
  802f29:	85 c0                	test   %eax,%eax
  802f2b:	0f 88 a0 01 00 00    	js     8030d1 <pipe+0x1ce>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  802f31:	b9 46 00 00 00       	mov    $0x46,%ecx
  802f36:	ba 00 10 00 00       	mov    $0x1000,%edx
  802f3b:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802f3f:	bf 00 00 00 00       	mov    $0x0,%edi
  802f44:	48 b8 39 1c 80 00 00 	movabs $0x801c39,%rax
  802f4b:	00 00 00 
  802f4e:	ff d0                	call   *%rax
  802f50:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  802f52:	85 c0                	test   %eax,%eax
  802f54:	0f 88 77 01 00 00    	js     8030d1 <pipe+0x1ce>
    if ((res = fd_alloc(&fd1)) < 0 ||
  802f5a:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  802f5e:	48 b8 ec 21 80 00 00 	movabs $0x8021ec,%rax
  802f65:	00 00 00 
  802f68:	ff d0                	call   *%rax
  802f6a:	89 c3                	mov    %eax,%ebx
  802f6c:	85 c0                	test   %eax,%eax
  802f6e:	0f 88 43 01 00 00    	js     8030b7 <pipe+0x1b4>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  802f74:	b9 46 00 00 00       	mov    $0x46,%ecx
  802f79:	ba 00 10 00 00       	mov    $0x1000,%edx
  802f7e:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802f82:	bf 00 00 00 00       	mov    $0x0,%edi
  802f87:	48 b8 39 1c 80 00 00 	movabs $0x801c39,%rax
  802f8e:	00 00 00 
  802f91:	ff d0                	call   *%rax
  802f93:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  802f95:	85 c0                	test   %eax,%eax
  802f97:	0f 88 1a 01 00 00    	js     8030b7 <pipe+0x1b4>
    va = fd2data(fd0);
  802f9d:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802fa1:	48 b8 cc 21 80 00 00 	movabs $0x8021cc,%rax
  802fa8:	00 00 00 
  802fab:	ff d0                	call   *%rax
  802fad:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  802fb0:	b9 46 00 00 00       	mov    $0x46,%ecx
  802fb5:	ba 00 10 00 00       	mov    $0x1000,%edx
  802fba:	48 89 c6             	mov    %rax,%rsi
  802fbd:	bf 00 00 00 00       	mov    $0x0,%edi
  802fc2:	48 b8 39 1c 80 00 00 	movabs $0x801c39,%rax
  802fc9:	00 00 00 
  802fcc:	ff d0                	call   *%rax
  802fce:	89 c3                	mov    %eax,%ebx
  802fd0:	85 c0                	test   %eax,%eax
  802fd2:	0f 88 c5 00 00 00    	js     80309d <pipe+0x19a>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  802fd8:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802fdc:	48 b8 cc 21 80 00 00 	movabs $0x8021cc,%rax
  802fe3:	00 00 00 
  802fe6:	ff d0                	call   *%rax
  802fe8:	48 89 c1             	mov    %rax,%rcx
  802feb:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  802ff1:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  802ff7:	ba 00 00 00 00       	mov    $0x0,%edx
  802ffc:	4c 89 ee             	mov    %r13,%rsi
  802fff:	bf 00 00 00 00       	mov    $0x0,%edi
  803004:	48 b8 a4 1c 80 00 00 	movabs $0x801ca4,%rax
  80300b:	00 00 00 
  80300e:	ff d0                	call   *%rax
  803010:	89 c3                	mov    %eax,%ebx
  803012:	85 c0                	test   %eax,%eax
  803014:	78 6e                	js     803084 <pipe+0x181>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  803016:	be 00 10 00 00       	mov    $0x1000,%esi
  80301b:	4c 89 ef             	mov    %r13,%rdi
  80301e:	48 b8 d3 1b 80 00 00 	movabs $0x801bd3,%rax
  803025:	00 00 00 
  803028:	ff d0                	call   *%rax
  80302a:	83 f8 02             	cmp    $0x2,%eax
  80302d:	0f 85 ab 00 00 00    	jne    8030de <pipe+0x1db>
    fd0->fd_dev_id = devpipe.dev_id;
  803033:	a1 60 50 80 00 00 00 	movabs 0x805060,%eax
  80303a:	00 00 
  80303c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803040:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  803042:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803046:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  80304d:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  803051:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  803053:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803057:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  80305e:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  803062:	48 bb b6 21 80 00 00 	movabs $0x8021b6,%rbx
  803069:	00 00 00 
  80306c:	ff d3                	call   *%rbx
  80306e:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  803072:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  803076:	ff d3                	call   *%rbx
  803078:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  80307d:	bb 00 00 00 00       	mov    $0x0,%ebx
  803082:	eb 4d                	jmp    8030d1 <pipe+0x1ce>
    sys_unmap_region(0, va, PAGE_SIZE);
  803084:	ba 00 10 00 00       	mov    $0x1000,%edx
  803089:	4c 89 ee             	mov    %r13,%rsi
  80308c:	bf 00 00 00 00       	mov    $0x0,%edi
  803091:	48 b8 79 1d 80 00 00 	movabs $0x801d79,%rax
  803098:	00 00 00 
  80309b:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  80309d:	ba 00 10 00 00       	mov    $0x1000,%edx
  8030a2:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8030a6:	bf 00 00 00 00       	mov    $0x0,%edi
  8030ab:	48 b8 79 1d 80 00 00 	movabs $0x801d79,%rax
  8030b2:	00 00 00 
  8030b5:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  8030b7:	ba 00 10 00 00       	mov    $0x1000,%edx
  8030bc:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8030c0:	bf 00 00 00 00       	mov    $0x0,%edi
  8030c5:	48 b8 79 1d 80 00 00 	movabs $0x801d79,%rax
  8030cc:	00 00 00 
  8030cf:	ff d0                	call   *%rax
}
  8030d1:	89 d8                	mov    %ebx,%eax
  8030d3:	48 83 c4 18          	add    $0x18,%rsp
  8030d7:	5b                   	pop    %rbx
  8030d8:	41 5c                	pop    %r12
  8030da:	41 5d                	pop    %r13
  8030dc:	5d                   	pop    %rbp
  8030dd:	c3                   	ret
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8030de:	48 b9 e0 46 80 00 00 	movabs $0x8046e0,%rcx
  8030e5:	00 00 00 
  8030e8:	48 ba dc 43 80 00 00 	movabs $0x8043dc,%rdx
  8030ef:	00 00 00 
  8030f2:	be 2e 00 00 00       	mov    $0x2e,%esi
  8030f7:	48 bf 03 44 80 00 00 	movabs $0x804403,%rdi
  8030fe:	00 00 00 
  803101:	b8 00 00 00 00       	mov    $0x0,%eax
  803106:	49 b8 8f 0b 80 00 00 	movabs $0x800b8f,%r8
  80310d:	00 00 00 
  803110:	41 ff d0             	call   *%r8

0000000000803113 <pipeisclosed>:
pipeisclosed(int fdnum) {
  803113:	f3 0f 1e fa          	endbr64
  803117:	55                   	push   %rbp
  803118:	48 89 e5             	mov    %rsp,%rbp
  80311b:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  80311f:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  803123:	48 b8 50 22 80 00 00 	movabs $0x802250,%rax
  80312a:	00 00 00 
  80312d:	ff d0                	call   *%rax
    if (res < 0) return res;
  80312f:	85 c0                	test   %eax,%eax
  803131:	78 35                	js     803168 <pipeisclosed+0x55>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  803133:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  803137:	48 b8 cc 21 80 00 00 	movabs $0x8021cc,%rax
  80313e:	00 00 00 
  803141:	ff d0                	call   *%rax
  803143:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  803146:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80314b:	be 00 10 00 00       	mov    $0x1000,%esi
  803150:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  803154:	48 b8 09 1c 80 00 00 	movabs $0x801c09,%rax
  80315b:	00 00 00 
  80315e:	ff d0                	call   *%rax
  803160:	85 c0                	test   %eax,%eax
  803162:	0f 94 c0             	sete   %al
  803165:	0f b6 c0             	movzbl %al,%eax
}
  803168:	c9                   	leave
  803169:	c3                   	ret

000000000080316a <get_uvpt_entry>:
extern volatile pde_t uvpd[];     /* VA of current page directory */
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
  80316a:	f3 0f 1e fa          	endbr64
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  80316e:	48 89 f8             	mov    %rdi,%rax
  803171:	48 c1 e8 27          	shr    $0x27,%rax
  803175:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  80317c:	7f 00 00 
  80317f:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  803183:	f6 c2 01             	test   $0x1,%dl
  803186:	74 6d                	je     8031f5 <get_uvpt_entry+0x8b>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  803188:	48 89 f8             	mov    %rdi,%rax
  80318b:	48 c1 e8 1e          	shr    $0x1e,%rax
  80318f:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  803196:	7f 00 00 
  803199:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80319d:	f6 c2 01             	test   $0x1,%dl
  8031a0:	74 62                	je     803204 <get_uvpt_entry+0x9a>
  8031a2:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  8031a9:	7f 00 00 
  8031ac:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8031b0:	f6 c2 80             	test   $0x80,%dl
  8031b3:	75 4f                	jne    803204 <get_uvpt_entry+0x9a>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8031b5:	48 89 f8             	mov    %rdi,%rax
  8031b8:	48 c1 e8 15          	shr    $0x15,%rax
  8031bc:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  8031c3:	7f 00 00 
  8031c6:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8031ca:	f6 c2 01             	test   $0x1,%dl
  8031cd:	74 44                	je     803213 <get_uvpt_entry+0xa9>
  8031cf:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  8031d6:	7f 00 00 
  8031d9:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8031dd:	f6 c2 80             	test   $0x80,%dl
  8031e0:	75 31                	jne    803213 <get_uvpt_entry+0xa9>
    return uvpt[VPT(va)];
  8031e2:	48 c1 ef 0c          	shr    $0xc,%rdi
  8031e6:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  8031ed:	7f 00 00 
  8031f0:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  8031f4:	c3                   	ret
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8031f5:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  8031fc:	7f 00 00 
  8031ff:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  803203:	c3                   	ret
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  803204:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  80320b:	7f 00 00 
  80320e:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  803212:	c3                   	ret
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  803213:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  80321a:	7f 00 00 
  80321d:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  803221:	c3                   	ret

0000000000803222 <get_phys_addr>:

uintptr_t
get_phys_addr(void *va) {
  803222:	f3 0f 1e fa          	endbr64
  803226:	48 89 fa             	mov    %rdi,%rdx
    if (!(uvpml4[VPML4(va)] & PTE_P))
  803229:	48 89 f9             	mov    %rdi,%rcx
  80322c:	48 c1 e9 27          	shr    $0x27,%rcx
  803230:	48 b8 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rax
  803237:	7f 00 00 
  80323a:	48 8b 0c c8          	mov    (%rax,%rcx,8),%rcx
        return -1;
  80323e:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpml4[VPML4(va)] & PTE_P))
  803245:	f6 c1 01             	test   $0x1,%cl
  803248:	0f 84 b2 00 00 00    	je     803300 <get_phys_addr+0xde>
    if (!(uvpdp[VPDP(va)] & PTE_P))
  80324e:	48 89 f9             	mov    %rdi,%rcx
  803251:	48 c1 e9 1e          	shr    $0x1e,%rcx
  803255:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  80325c:	7f 00 00 
  80325f:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  803263:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpdp[VPDP(va)] & PTE_P))
  80326a:	40 f6 c6 01          	test   $0x1,%sil
  80326e:	0f 84 8c 00 00 00    	je     803300 <get_phys_addr+0xde>
    if (uvpdp[VPDP(va)] & PTE_PS)
  803274:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  80327b:	7f 00 00 
  80327e:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  803282:	a8 80                	test   $0x80,%al
  803284:	75 7b                	jne    803301 <get_phys_addr+0xdf>
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
    if (!(uvpd[VPD(va)] & PTE_P))
  803286:	48 89 f9             	mov    %rdi,%rcx
  803289:	48 c1 e9 15          	shr    $0x15,%rcx
  80328d:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  803294:	7f 00 00 
  803297:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  80329b:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpd[VPD(va)] & PTE_P))
  8032a2:	40 f6 c6 01          	test   $0x1,%sil
  8032a6:	74 58                	je     803300 <get_phys_addr+0xde>
    if ((uvpd[VPD(va)] & PTE_PS))
  8032a8:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  8032af:	7f 00 00 
  8032b2:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8032b6:	a8 80                	test   $0x80,%al
  8032b8:	75 6c                	jne    803326 <get_phys_addr+0x104>
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
    if (!(uvpt[VPT(va)] & PTE_P))
  8032ba:	48 89 f9             	mov    %rdi,%rcx
  8032bd:	48 c1 e9 0c          	shr    $0xc,%rcx
  8032c1:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  8032c8:	7f 00 00 
  8032cb:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  8032cf:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpt[VPT(va)] & PTE_P))
  8032d6:	40 f6 c6 01          	test   $0x1,%sil
  8032da:	74 24                	je     803300 <get_phys_addr+0xde>
    return PTE_ADDR(uvpt[VPT(va)]) + PAGE_OFFSET(va);
  8032dc:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  8032e3:	7f 00 00 
  8032e6:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8032ea:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  8032f1:	ff ff 7f 
  8032f4:	48 21 c8             	and    %rcx,%rax
  8032f7:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  8032fd:	48 09 d0             	or     %rdx,%rax
}
  803300:	c3                   	ret
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
  803301:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  803308:	7f 00 00 
  80330b:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  80330f:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  803316:	ff ff 7f 
  803319:	48 21 c8             	and    %rcx,%rax
  80331c:	81 e2 ff ff ff 3f    	and    $0x3fffffff,%edx
  803322:	48 01 d0             	add    %rdx,%rax
  803325:	c3                   	ret
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
  803326:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  80332d:	7f 00 00 
  803330:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  803334:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  80333b:	ff ff 7f 
  80333e:	48 21 c8             	and    %rcx,%rax
  803341:	81 e2 ff ff 1f 00    	and    $0x1fffff,%edx
  803347:	48 01 d0             	add    %rdx,%rax
  80334a:	c3                   	ret

000000000080334b <get_prot>:

int
get_prot(void *va) {
  80334b:	f3 0f 1e fa          	endbr64
  80334f:	55                   	push   %rbp
  803350:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  803353:	48 b8 6a 31 80 00 00 	movabs $0x80316a,%rax
  80335a:	00 00 00 
  80335d:	ff d0                	call   *%rax
  80335f:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
    if (pte & PTE_P) prot |= PROT_R;
  803362:	83 e0 01             	and    $0x1,%eax
  803365:	c1 e0 02             	shl    $0x2,%eax
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  803368:	89 d1                	mov    %edx,%ecx
  80336a:	81 e1 00 0a 00 00    	and    $0xa00,%ecx
    if (pte & PTE_P) prot |= PROT_R;
  803370:	09 c8                	or     %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  803372:	89 c1                	mov    %eax,%ecx
  803374:	83 c9 02             	or     $0x2,%ecx
  803377:	f6 c2 02             	test   $0x2,%dl
  80337a:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  80337d:	89 c1                	mov    %eax,%ecx
  80337f:	83 c9 01             	or     $0x1,%ecx
  803382:	48 85 d2             	test   %rdx,%rdx
  803385:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  803388:	89 c1                	mov    %eax,%ecx
  80338a:	83 c9 40             	or     $0x40,%ecx
  80338d:	f6 c6 04             	test   $0x4,%dh
  803390:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  803393:	5d                   	pop    %rbp
  803394:	c3                   	ret

0000000000803395 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  803395:	f3 0f 1e fa          	endbr64
  803399:	55                   	push   %rbp
  80339a:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  80339d:	48 b8 6a 31 80 00 00 	movabs $0x80316a,%rax
  8033a4:	00 00 00 
  8033a7:	ff d0                	call   *%rax
    return pte & PTE_D;
  8033a9:	48 c1 e8 06          	shr    $0x6,%rax
  8033ad:	83 e0 01             	and    $0x1,%eax
}
  8033b0:	5d                   	pop    %rbp
  8033b1:	c3                   	ret

00000000008033b2 <is_page_present>:

bool
is_page_present(void *va) {
  8033b2:	f3 0f 1e fa          	endbr64
  8033b6:	55                   	push   %rbp
  8033b7:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  8033ba:	48 b8 6a 31 80 00 00 	movabs $0x80316a,%rax
  8033c1:	00 00 00 
  8033c4:	ff d0                	call   *%rax
  8033c6:	83 e0 01             	and    $0x1,%eax
}
  8033c9:	5d                   	pop    %rbp
  8033ca:	c3                   	ret

00000000008033cb <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  8033cb:	f3 0f 1e fa          	endbr64
  8033cf:	55                   	push   %rbp
  8033d0:	48 89 e5             	mov    %rsp,%rbp
  8033d3:	41 57                	push   %r15
  8033d5:	41 56                	push   %r14
  8033d7:	41 55                	push   %r13
  8033d9:	41 54                	push   %r12
  8033db:	53                   	push   %rbx
  8033dc:	48 83 ec 18          	sub    $0x18,%rsp
  8033e0:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8033e4:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
     * NOTE: Skip over larger pages/page directories for efficiency */
    // LAB 11: Your code here:

    int res = 0;
    (void)fun, (void)arg;
    uintptr_t va = 0;
  8033e8:	bb 00 00 00 00       	mov    $0x0,%ebx
    while (va < USER_STACK_TOP) {
        size_t size = 0;
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  8033ed:	49 be 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%r14
  8033f4:	7f 00 00 
            size = 1LL << PML4_SHIFT;
            goto next;
        }

        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  8033f7:	49 bd 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%r13
  8033fe:	7f 00 00 
    while (va < USER_STACK_TOP) {
  803401:	49 bf ff 6f ff ff 7f 	movabs $0x7fffff6fff,%r15
  803408:	00 00 00 
  80340b:	eb 73                	jmp    803480 <foreach_shared_region+0xb5>
            }

            goto next;
        }

        if (!(uvpd[VPD(va)] & PTE_P)) {
  80340d:	48 89 d8             	mov    %rbx,%rax
  803410:	48 c1 e8 15          	shr    $0x15,%rax
  803414:	48 b9 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rcx
  80341b:	7f 00 00 
  80341e:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
            size = 1LL << PD_SHIFT;
  803422:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
        if (!(uvpd[VPD(va)] & PTE_P)) {
  803428:	f6 c2 01             	test   $0x1,%dl
  80342b:	74 4b                	je     803478 <foreach_shared_region+0xad>
            goto next;
        }

        if (uvpd[VPD(va)] & PTE_PS) {
  80342d:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
  803431:	f6 c2 80             	test   $0x80,%dl
  803434:	74 11                	je     803447 <foreach_shared_region+0x7c>
            size = 1LL << PD_SHIFT;
            if (uvpd[VPD(va)] & PTE_SHARE) {
  803436:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
  80343a:	f6 c4 04             	test   $0x4,%ah
  80343d:	74 39                	je     803478 <foreach_shared_region+0xad>
            size = 1LL << PD_SHIFT;
  80343f:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
  803445:	eb 20                	jmp    803467 <foreach_shared_region+0x9c>

            goto next;
        }

        size = PAGE_SIZE;
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  803447:	48 89 da             	mov    %rbx,%rdx
  80344a:	48 c1 ea 0c          	shr    $0xc,%rdx
  80344e:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  803455:	7f 00 00 
  803458:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
        size = PAGE_SIZE;
  80345c:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  803462:	f6 c4 04             	test   $0x4,%ah
  803465:	74 11                	je     803478 <foreach_shared_region+0xad>
            goto next;
        }

    map:
        fun((void *)va, (void *)(va + size), arg);
  803467:	49 8d 34 1c          	lea    (%r12,%rbx,1),%rsi
  80346b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80346f:	48 89 df             	mov    %rbx,%rdi
  803472:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803476:	ff d0                	call   *%rax
    next:
        va += size;
  803478:	4c 01 e3             	add    %r12,%rbx
    while (va < USER_STACK_TOP) {
  80347b:	49 39 df             	cmp    %rbx,%r15
  80347e:	72 3e                	jb     8034be <foreach_shared_region+0xf3>
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  803480:	49 8b 06             	mov    (%r14),%rax
  803483:	a8 01                	test   $0x1,%al
  803485:	74 37                	je     8034be <foreach_shared_region+0xf3>
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  803487:	48 89 d8             	mov    %rbx,%rax
  80348a:	48 c1 e8 1e          	shr    $0x1e,%rax
  80348e:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
            size = 1LL << PDP_SHIFT;
  803493:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  803499:	f6 c2 01             	test   $0x1,%dl
  80349c:	74 da                	je     803478 <foreach_shared_region+0xad>
        if (uvpdp[VPDP(va)] & PTE_PS) {
  80349e:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
  8034a3:	f6 c2 80             	test   $0x80,%dl
  8034a6:	0f 84 61 ff ff ff    	je     80340d <foreach_shared_region+0x42>
            if (uvpdp[VPDP(va)] & PTE_SHARE) {
  8034ac:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  8034b1:	f6 c4 04             	test   $0x4,%ah
  8034b4:	74 c2                	je     803478 <foreach_shared_region+0xad>
            size = 1LL << PDP_SHIFT;
  8034b6:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
  8034bc:	eb a9                	jmp    803467 <foreach_shared_region+0x9c>
    }
    return res;
}
  8034be:	b8 00 00 00 00       	mov    $0x0,%eax
  8034c3:	48 83 c4 18          	add    $0x18,%rsp
  8034c7:	5b                   	pop    %rbx
  8034c8:	41 5c                	pop    %r12
  8034ca:	41 5d                	pop    %r13
  8034cc:	41 5e                	pop    %r14
  8034ce:	41 5f                	pop    %r15
  8034d0:	5d                   	pop    %rbp
  8034d1:	c3                   	ret

00000000008034d2 <devcons_close>:

    return res;
}

static int
devcons_close(struct Fd *fd) {
  8034d2:	f3 0f 1e fa          	endbr64
    USED(fd);

    return 0;
}
  8034d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8034db:	c3                   	ret

00000000008034dc <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  8034dc:	f3 0f 1e fa          	endbr64
  8034e0:	55                   	push   %rbp
  8034e1:	48 89 e5             	mov    %rsp,%rbp
  8034e4:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  8034e7:	48 be 13 44 80 00 00 	movabs $0x804413,%rsi
  8034ee:	00 00 00 
  8034f1:	48 b8 34 16 80 00 00 	movabs $0x801634,%rax
  8034f8:	00 00 00 
  8034fb:	ff d0                	call   *%rax
    return 0;
}
  8034fd:	b8 00 00 00 00       	mov    $0x0,%eax
  803502:	5d                   	pop    %rbp
  803503:	c3                   	ret

0000000000803504 <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  803504:	f3 0f 1e fa          	endbr64
  803508:	55                   	push   %rbp
  803509:	48 89 e5             	mov    %rsp,%rbp
  80350c:	41 57                	push   %r15
  80350e:	41 56                	push   %r14
  803510:	41 55                	push   %r13
  803512:	41 54                	push   %r12
  803514:	53                   	push   %rbx
  803515:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  80351c:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  803523:	48 85 d2             	test   %rdx,%rdx
  803526:	74 7a                	je     8035a2 <devcons_write+0x9e>
  803528:	49 89 d6             	mov    %rdx,%r14
  80352b:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  803531:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  803536:	49 bf 4f 18 80 00 00 	movabs $0x80184f,%r15
  80353d:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  803540:	4c 89 f3             	mov    %r14,%rbx
  803543:	48 29 f3             	sub    %rsi,%rbx
  803546:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80354b:	48 39 c3             	cmp    %rax,%rbx
  80354e:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  803552:	4c 63 eb             	movslq %ebx,%r13
  803555:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  80355c:	48 01 c6             	add    %rax,%rsi
  80355f:	4c 89 ea             	mov    %r13,%rdx
  803562:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  803569:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  80356c:	4c 89 ee             	mov    %r13,%rsi
  80356f:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  803576:	48 b8 94 1a 80 00 00 	movabs $0x801a94,%rax
  80357d:	00 00 00 
  803580:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  803582:	41 01 dc             	add    %ebx,%r12d
  803585:	49 63 f4             	movslq %r12d,%rsi
  803588:	4c 39 f6             	cmp    %r14,%rsi
  80358b:	72 b3                	jb     803540 <devcons_write+0x3c>
    return res;
  80358d:	49 63 c4             	movslq %r12d,%rax
}
  803590:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  803597:	5b                   	pop    %rbx
  803598:	41 5c                	pop    %r12
  80359a:	41 5d                	pop    %r13
  80359c:	41 5e                	pop    %r14
  80359e:	41 5f                	pop    %r15
  8035a0:	5d                   	pop    %rbp
  8035a1:	c3                   	ret
    for (res = 0; res < n; res += inc) {
  8035a2:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  8035a8:	eb e3                	jmp    80358d <devcons_write+0x89>

00000000008035aa <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  8035aa:	f3 0f 1e fa          	endbr64
  8035ae:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  8035b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8035b6:	48 85 c0             	test   %rax,%rax
  8035b9:	74 55                	je     803610 <devcons_read+0x66>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  8035bb:	55                   	push   %rbp
  8035bc:	48 89 e5             	mov    %rsp,%rbp
  8035bf:	41 55                	push   %r13
  8035c1:	41 54                	push   %r12
  8035c3:	53                   	push   %rbx
  8035c4:	48 83 ec 08          	sub    $0x8,%rsp
  8035c8:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  8035cb:	48 bb c5 1a 80 00 00 	movabs $0x801ac5,%rbx
  8035d2:	00 00 00 
  8035d5:	49 bc 9e 1b 80 00 00 	movabs $0x801b9e,%r12
  8035dc:	00 00 00 
  8035df:	eb 03                	jmp    8035e4 <devcons_read+0x3a>
  8035e1:	41 ff d4             	call   *%r12
  8035e4:	ff d3                	call   *%rbx
  8035e6:	85 c0                	test   %eax,%eax
  8035e8:	74 f7                	je     8035e1 <devcons_read+0x37>
    if (c < 0) return c;
  8035ea:	48 63 d0             	movslq %eax,%rdx
  8035ed:	78 13                	js     803602 <devcons_read+0x58>
    if (c == 0x04) return 0;
  8035ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8035f4:	83 f8 04             	cmp    $0x4,%eax
  8035f7:	74 09                	je     803602 <devcons_read+0x58>
    *(char *)vbuf = (char)c;
  8035f9:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  8035fd:	ba 01 00 00 00       	mov    $0x1,%edx
}
  803602:	48 89 d0             	mov    %rdx,%rax
  803605:	48 83 c4 08          	add    $0x8,%rsp
  803609:	5b                   	pop    %rbx
  80360a:	41 5c                	pop    %r12
  80360c:	41 5d                	pop    %r13
  80360e:	5d                   	pop    %rbp
  80360f:	c3                   	ret
  803610:	48 89 d0             	mov    %rdx,%rax
  803613:	c3                   	ret

0000000000803614 <cputchar>:
cputchar(int ch) {
  803614:	f3 0f 1e fa          	endbr64
  803618:	55                   	push   %rbp
  803619:	48 89 e5             	mov    %rsp,%rbp
  80361c:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  803620:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  803624:	be 01 00 00 00       	mov    $0x1,%esi
  803629:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  80362d:	48 b8 94 1a 80 00 00 	movabs $0x801a94,%rax
  803634:	00 00 00 
  803637:	ff d0                	call   *%rax
}
  803639:	c9                   	leave
  80363a:	c3                   	ret

000000000080363b <getchar>:
getchar(void) {
  80363b:	f3 0f 1e fa          	endbr64
  80363f:	55                   	push   %rbp
  803640:	48 89 e5             	mov    %rsp,%rbp
  803643:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  803647:	ba 01 00 00 00       	mov    $0x1,%edx
  80364c:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  803650:	bf 00 00 00 00       	mov    $0x0,%edi
  803655:	48 b8 4b 25 80 00 00 	movabs $0x80254b,%rax
  80365c:	00 00 00 
  80365f:	ff d0                	call   *%rax
  803661:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  803663:	85 c0                	test   %eax,%eax
  803665:	78 06                	js     80366d <getchar+0x32>
  803667:	74 08                	je     803671 <getchar+0x36>
  803669:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  80366d:	89 d0                	mov    %edx,%eax
  80366f:	c9                   	leave
  803670:	c3                   	ret
    return res < 0 ? res : res ? c :
  803671:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  803676:	eb f5                	jmp    80366d <getchar+0x32>

0000000000803678 <iscons>:
iscons(int fdnum) {
  803678:	f3 0f 1e fa          	endbr64
  80367c:	55                   	push   %rbp
  80367d:	48 89 e5             	mov    %rsp,%rbp
  803680:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  803684:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  803688:	48 b8 50 22 80 00 00 	movabs $0x802250,%rax
  80368f:	00 00 00 
  803692:	ff d0                	call   *%rax
    if (res < 0) return res;
  803694:	85 c0                	test   %eax,%eax
  803696:	78 18                	js     8036b0 <iscons+0x38>
    return fd->fd_dev_id == devcons.dev_id;
  803698:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80369c:	48 b8 a0 50 80 00 00 	movabs $0x8050a0,%rax
  8036a3:	00 00 00 
  8036a6:	8b 00                	mov    (%rax),%eax
  8036a8:	39 02                	cmp    %eax,(%rdx)
  8036aa:	0f 94 c0             	sete   %al
  8036ad:	0f b6 c0             	movzbl %al,%eax
}
  8036b0:	c9                   	leave
  8036b1:	c3                   	ret

00000000008036b2 <opencons>:
opencons(void) {
  8036b2:	f3 0f 1e fa          	endbr64
  8036b6:	55                   	push   %rbp
  8036b7:	48 89 e5             	mov    %rsp,%rbp
  8036ba:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  8036be:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  8036c2:	48 b8 ec 21 80 00 00 	movabs $0x8021ec,%rax
  8036c9:	00 00 00 
  8036cc:	ff d0                	call   *%rax
  8036ce:	85 c0                	test   %eax,%eax
  8036d0:	78 49                	js     80371b <opencons+0x69>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  8036d2:	b9 46 00 00 00       	mov    $0x46,%ecx
  8036d7:	ba 00 10 00 00       	mov    $0x1000,%edx
  8036dc:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  8036e0:	bf 00 00 00 00       	mov    $0x0,%edi
  8036e5:	48 b8 39 1c 80 00 00 	movabs $0x801c39,%rax
  8036ec:	00 00 00 
  8036ef:	ff d0                	call   *%rax
  8036f1:	85 c0                	test   %eax,%eax
  8036f3:	78 26                	js     80371b <opencons+0x69>
    fd->fd_dev_id = devcons.dev_id;
  8036f5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8036f9:	a1 a0 50 80 00 00 00 	movabs 0x8050a0,%eax
  803700:	00 00 
  803702:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  803704:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  803708:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  80370f:	48 b8 b6 21 80 00 00 	movabs $0x8021b6,%rax
  803716:	00 00 00 
  803719:	ff d0                	call   *%rax
}
  80371b:	c9                   	leave
  80371c:	c3                   	ret

000000000080371d <__text_end>:
  80371d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803724:	00 00 00 
  803727:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80372e:	00 00 00 
  803731:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803738:	00 00 00 
  80373b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803742:	00 00 00 
  803745:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80374c:	00 00 00 
  80374f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803756:	00 00 00 
  803759:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803760:	00 00 00 
  803763:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80376a:	00 00 00 
  80376d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803774:	00 00 00 
  803777:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80377e:	00 00 00 
  803781:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803788:	00 00 00 
  80378b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803792:	00 00 00 
  803795:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80379c:	00 00 00 
  80379f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037a6:	00 00 00 
  8037a9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037b0:	00 00 00 
  8037b3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037ba:	00 00 00 
  8037bd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037c4:	00 00 00 
  8037c7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037ce:	00 00 00 
  8037d1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037d8:	00 00 00 
  8037db:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037e2:	00 00 00 
  8037e5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037ec:	00 00 00 
  8037ef:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037f6:	00 00 00 
  8037f9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803800:	00 00 00 
  803803:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80380a:	00 00 00 
  80380d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803814:	00 00 00 
  803817:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80381e:	00 00 00 
  803821:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803828:	00 00 00 
  80382b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803832:	00 00 00 
  803835:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80383c:	00 00 00 
  80383f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803846:	00 00 00 
  803849:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803850:	00 00 00 
  803853:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80385a:	00 00 00 
  80385d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803864:	00 00 00 
  803867:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80386e:	00 00 00 
  803871:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803878:	00 00 00 
  80387b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803882:	00 00 00 
  803885:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80388c:	00 00 00 
  80388f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803896:	00 00 00 
  803899:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038a0:	00 00 00 
  8038a3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038aa:	00 00 00 
  8038ad:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038b4:	00 00 00 
  8038b7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038be:	00 00 00 
  8038c1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038c8:	00 00 00 
  8038cb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038d2:	00 00 00 
  8038d5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038dc:	00 00 00 
  8038df:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038e6:	00 00 00 
  8038e9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038f0:	00 00 00 
  8038f3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038fa:	00 00 00 
  8038fd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803904:	00 00 00 
  803907:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80390e:	00 00 00 
  803911:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803918:	00 00 00 
  80391b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803922:	00 00 00 
  803925:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80392c:	00 00 00 
  80392f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803936:	00 00 00 
  803939:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803940:	00 00 00 
  803943:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80394a:	00 00 00 
  80394d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803954:	00 00 00 
  803957:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80395e:	00 00 00 
  803961:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803968:	00 00 00 
  80396b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803972:	00 00 00 
  803975:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80397c:	00 00 00 
  80397f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803986:	00 00 00 
  803989:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803990:	00 00 00 
  803993:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80399a:	00 00 00 
  80399d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039a4:	00 00 00 
  8039a7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039ae:	00 00 00 
  8039b1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039b8:	00 00 00 
  8039bb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039c2:	00 00 00 
  8039c5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039cc:	00 00 00 
  8039cf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039d6:	00 00 00 
  8039d9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039e0:	00 00 00 
  8039e3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039ea:	00 00 00 
  8039ed:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039f4:	00 00 00 
  8039f7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039fe:	00 00 00 
  803a01:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a08:	00 00 00 
  803a0b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a12:	00 00 00 
  803a15:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a1c:	00 00 00 
  803a1f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a26:	00 00 00 
  803a29:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a30:	00 00 00 
  803a33:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a3a:	00 00 00 
  803a3d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a44:	00 00 00 
  803a47:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a4e:	00 00 00 
  803a51:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a58:	00 00 00 
  803a5b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a62:	00 00 00 
  803a65:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a6c:	00 00 00 
  803a6f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a76:	00 00 00 
  803a79:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a80:	00 00 00 
  803a83:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a8a:	00 00 00 
  803a8d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a94:	00 00 00 
  803a97:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a9e:	00 00 00 
  803aa1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803aa8:	00 00 00 
  803aab:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ab2:	00 00 00 
  803ab5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803abc:	00 00 00 
  803abf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ac6:	00 00 00 
  803ac9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ad0:	00 00 00 
  803ad3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ada:	00 00 00 
  803add:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ae4:	00 00 00 
  803ae7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803aee:	00 00 00 
  803af1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803af8:	00 00 00 
  803afb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b02:	00 00 00 
  803b05:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b0c:	00 00 00 
  803b0f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b16:	00 00 00 
  803b19:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b20:	00 00 00 
  803b23:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b2a:	00 00 00 
  803b2d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b34:	00 00 00 
  803b37:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b3e:	00 00 00 
  803b41:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b48:	00 00 00 
  803b4b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b52:	00 00 00 
  803b55:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b5c:	00 00 00 
  803b5f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b66:	00 00 00 
  803b69:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b70:	00 00 00 
  803b73:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b7a:	00 00 00 
  803b7d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b84:	00 00 00 
  803b87:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b8e:	00 00 00 
  803b91:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b98:	00 00 00 
  803b9b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ba2:	00 00 00 
  803ba5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bac:	00 00 00 
  803baf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bb6:	00 00 00 
  803bb9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bc0:	00 00 00 
  803bc3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bca:	00 00 00 
  803bcd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bd4:	00 00 00 
  803bd7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bde:	00 00 00 
  803be1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803be8:	00 00 00 
  803beb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bf2:	00 00 00 
  803bf5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bfc:	00 00 00 
  803bff:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c06:	00 00 00 
  803c09:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c10:	00 00 00 
  803c13:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c1a:	00 00 00 
  803c1d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c24:	00 00 00 
  803c27:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c2e:	00 00 00 
  803c31:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c38:	00 00 00 
  803c3b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c42:	00 00 00 
  803c45:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c4c:	00 00 00 
  803c4f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c56:	00 00 00 
  803c59:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c60:	00 00 00 
  803c63:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c6a:	00 00 00 
  803c6d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c74:	00 00 00 
  803c77:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c7e:	00 00 00 
  803c81:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c88:	00 00 00 
  803c8b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c92:	00 00 00 
  803c95:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c9c:	00 00 00 
  803c9f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ca6:	00 00 00 
  803ca9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cb0:	00 00 00 
  803cb3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cba:	00 00 00 
  803cbd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cc4:	00 00 00 
  803cc7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cce:	00 00 00 
  803cd1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cd8:	00 00 00 
  803cdb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ce2:	00 00 00 
  803ce5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cec:	00 00 00 
  803cef:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cf6:	00 00 00 
  803cf9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d00:	00 00 00 
  803d03:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d0a:	00 00 00 
  803d0d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d14:	00 00 00 
  803d17:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d1e:	00 00 00 
  803d21:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d28:	00 00 00 
  803d2b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d32:	00 00 00 
  803d35:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d3c:	00 00 00 
  803d3f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d46:	00 00 00 
  803d49:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d50:	00 00 00 
  803d53:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d5a:	00 00 00 
  803d5d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d64:	00 00 00 
  803d67:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d6e:	00 00 00 
  803d71:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d78:	00 00 00 
  803d7b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d82:	00 00 00 
  803d85:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d8c:	00 00 00 
  803d8f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d96:	00 00 00 
  803d99:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803da0:	00 00 00 
  803da3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803daa:	00 00 00 
  803dad:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803db4:	00 00 00 
  803db7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dbe:	00 00 00 
  803dc1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dc8:	00 00 00 
  803dcb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dd2:	00 00 00 
  803dd5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ddc:	00 00 00 
  803ddf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803de6:	00 00 00 
  803de9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803df0:	00 00 00 
  803df3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dfa:	00 00 00 
  803dfd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e04:	00 00 00 
  803e07:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e0e:	00 00 00 
  803e11:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e18:	00 00 00 
  803e1b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e22:	00 00 00 
  803e25:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e2c:	00 00 00 
  803e2f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e36:	00 00 00 
  803e39:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e40:	00 00 00 
  803e43:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e4a:	00 00 00 
  803e4d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e54:	00 00 00 
  803e57:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e5e:	00 00 00 
  803e61:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e68:	00 00 00 
  803e6b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e72:	00 00 00 
  803e75:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e7c:	00 00 00 
  803e7f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e86:	00 00 00 
  803e89:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e90:	00 00 00 
  803e93:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e9a:	00 00 00 
  803e9d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ea4:	00 00 00 
  803ea7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803eae:	00 00 00 
  803eb1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803eb8:	00 00 00 
  803ebb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ec2:	00 00 00 
  803ec5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ecc:	00 00 00 
  803ecf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ed6:	00 00 00 
  803ed9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ee0:	00 00 00 
  803ee3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803eea:	00 00 00 
  803eed:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ef4:	00 00 00 
  803ef7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803efe:	00 00 00 
  803f01:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f08:	00 00 00 
  803f0b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f12:	00 00 00 
  803f15:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f1c:	00 00 00 
  803f1f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f26:	00 00 00 
  803f29:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f30:	00 00 00 
  803f33:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f3a:	00 00 00 
  803f3d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f44:	00 00 00 
  803f47:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f4e:	00 00 00 
  803f51:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f58:	00 00 00 
  803f5b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f62:	00 00 00 
  803f65:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f6c:	00 00 00 
  803f6f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f76:	00 00 00 
  803f79:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f80:	00 00 00 
  803f83:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f8a:	00 00 00 
  803f8d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f94:	00 00 00 
  803f97:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f9e:	00 00 00 
  803fa1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fa8:	00 00 00 
  803fab:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fb2:	00 00 00 
  803fb5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fbc:	00 00 00 
  803fbf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fc6:	00 00 00 
  803fc9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fd0:	00 00 00 
  803fd3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fda:	00 00 00 
  803fdd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fe4:	00 00 00 
  803fe7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fee:	00 00 00 
  803ff1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ff8:	00 00 00 
  803ffb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
