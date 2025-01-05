
obj/user/testshell:     file format elf64-x86-64


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
  80001e:	e8 0d 07 00 00       	call   800730 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <wrong>:

    breakpoint();
}

void
wrong(int rfd, int kfd, int off, char c1, char c2) {
  800025:	f3 0f 1e fa          	endbr64
  800029:	55                   	push   %rbp
  80002a:	48 89 e5             	mov    %rsp,%rbp
  80002d:	41 57                	push   %r15
  80002f:	41 56                	push   %r14
  800031:	41 55                	push   %r13
  800033:	41 54                	push   %r12
  800035:	53                   	push   %rbx
  800036:	48 81 ec 88 00 00 00 	sub    $0x88,%rsp
  80003d:	89 fb                	mov    %edi,%ebx
  80003f:	41 89 f4             	mov    %esi,%r12d
  800042:	41 89 d6             	mov    %edx,%r14d
  800045:	41 89 cd             	mov    %ecx,%r13d
  800048:	44 89 85 5c ff ff ff 	mov    %r8d,-0xa4(%rbp)
    char buf[100];
    int n;

    seek(rfd, off);
  80004f:	89 d6                	mov    %edx,%esi
  800051:	49 bf 5c 23 80 00 00 	movabs $0x80235c,%r15
  800058:	00 00 00 
  80005b:	41 ff d7             	call   *%r15
    seek(kfd, off);
  80005e:	44 89 f6             	mov    %r14d,%esi
  800061:	44 89 e7             	mov    %r12d,%edi
  800064:	41 ff d7             	call   *%r15

    cprintf("shell produced incorrect output.\n");
  800067:	48 bf 00 40 80 00 00 	movabs $0x804000,%rdi
  80006e:	00 00 00 
  800071:	b8 00 00 00 00       	mov    $0x0,%eax
  800076:	49 be 65 09 80 00 00 	movabs $0x800965,%r14
  80007d:	00 00 00 
  800080:	41 ff d6             	call   *%r14
    cprintf("expected:\n===\n%c", c1);
  800083:	41 0f be f5          	movsbl %r13b,%esi
  800087:	48 bf e0 41 80 00 00 	movabs $0x8041e0,%rdi
  80008e:	00 00 00 
  800091:	b8 00 00 00 00       	mov    $0x0,%eax
  800096:	41 ff d6             	call   *%r14
    while ((n = read(kfd, buf, sizeof buf - 1)) > 0)
  800099:	49 bd 68 21 80 00 00 	movabs $0x802168,%r13
  8000a0:	00 00 00 
        sys_cputs(buf, n);
  8000a3:	49 be 0e 17 80 00 00 	movabs $0x80170e,%r14
  8000aa:	00 00 00 
    while ((n = read(kfd, buf, sizeof buf - 1)) > 0)
  8000ad:	eb 0d                	jmp    8000bc <wrong+0x97>
        sys_cputs(buf, n);
  8000af:	48 63 f0             	movslq %eax,%rsi
  8000b2:	48 8d bd 6c ff ff ff 	lea    -0x94(%rbp),%rdi
  8000b9:	41 ff d6             	call   *%r14
    while ((n = read(kfd, buf, sizeof buf - 1)) > 0)
  8000bc:	ba 63 00 00 00       	mov    $0x63,%edx
  8000c1:	48 8d b5 6c ff ff ff 	lea    -0x94(%rbp),%rsi
  8000c8:	44 89 e7             	mov    %r12d,%edi
  8000cb:	41 ff d5             	call   *%r13
  8000ce:	85 c0                	test   %eax,%eax
  8000d0:	7f dd                	jg     8000af <wrong+0x8a>
    cprintf("===\ngot:\n===\n%c", c2);
  8000d2:	0f be b5 5c ff ff ff 	movsbl -0xa4(%rbp),%esi
  8000d9:	48 bf f1 41 80 00 00 	movabs $0x8041f1,%rdi
  8000e0:	00 00 00 
  8000e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8000e8:	48 ba 65 09 80 00 00 	movabs $0x800965,%rdx
  8000ef:	00 00 00 
  8000f2:	ff d2                	call   *%rdx
    while ((n = read(rfd, buf, sizeof buf - 1)) > 0)
  8000f4:	49 bc 68 21 80 00 00 	movabs $0x802168,%r12
  8000fb:	00 00 00 
        sys_cputs(buf, n);
  8000fe:	49 bd 0e 17 80 00 00 	movabs $0x80170e,%r13
  800105:	00 00 00 
    while ((n = read(rfd, buf, sizeof buf - 1)) > 0)
  800108:	eb 0d                	jmp    800117 <wrong+0xf2>
        sys_cputs(buf, n);
  80010a:	48 63 f0             	movslq %eax,%rsi
  80010d:	48 8d bd 6c ff ff ff 	lea    -0x94(%rbp),%rdi
  800114:	41 ff d5             	call   *%r13
    while ((n = read(rfd, buf, sizeof buf - 1)) > 0)
  800117:	ba 63 00 00 00       	mov    $0x63,%edx
  80011c:	48 8d b5 6c ff ff ff 	lea    -0x94(%rbp),%rsi
  800123:	89 df                	mov    %ebx,%edi
  800125:	41 ff d4             	call   *%r12
  800128:	85 c0                	test   %eax,%eax
  80012a:	7f de                	jg     80010a <wrong+0xe5>
    cprintf("===\n");
  80012c:	48 bf 01 42 80 00 00 	movabs $0x804201,%rdi
  800133:	00 00 00 
  800136:	b8 00 00 00 00       	mov    $0x0,%eax
  80013b:	48 ba 65 09 80 00 00 	movabs $0x800965,%rdx
  800142:	00 00 00 
  800145:	ff d2                	call   *%rdx
    exit();
  800147:	48 b8 e2 07 80 00 00 	movabs $0x8007e2,%rax
  80014e:	00 00 00 
  800151:	ff d0                	call   *%rax
}
  800153:	48 81 c4 88 00 00 00 	add    $0x88,%rsp
  80015a:	5b                   	pop    %rbx
  80015b:	41 5c                	pop    %r12
  80015d:	41 5d                	pop    %r13
  80015f:	41 5e                	pop    %r14
  800161:	41 5f                	pop    %r15
  800163:	5d                   	pop    %rbp
  800164:	c3                   	ret

0000000000800165 <umain>:
umain(int argc, char **argv) {
  800165:	f3 0f 1e fa          	endbr64
  800169:	55                   	push   %rbp
  80016a:	48 89 e5             	mov    %rsp,%rbp
  80016d:	41 57                	push   %r15
  80016f:	41 56                	push   %r14
  800171:	41 55                	push   %r13
  800173:	41 54                	push   %r12
  800175:	53                   	push   %rbx
  800176:	48 83 ec 28          	sub    $0x28,%rsp
    close(0);
  80017a:	bf 00 00 00 00       	mov    $0x0,%edi
  80017f:	48 bb de 1f 80 00 00 	movabs $0x801fde,%rbx
  800186:	00 00 00 
  800189:	ff d3                	call   *%rbx
    close(1);
  80018b:	bf 01 00 00 00       	mov    $0x1,%edi
  800190:	ff d3                	call   *%rbx
    opencons();
  800192:	48 bb c5 06 80 00 00 	movabs $0x8006c5,%rbx
  800199:	00 00 00 
  80019c:	ff d3                	call   *%rbx
    opencons();
  80019e:	ff d3                	call   *%rbx
    if ((rfd = open("testshell.sh", O_RDONLY)) < 0)
  8001a0:	be 00 00 00 00       	mov    $0x0,%esi
  8001a5:	48 bf 06 42 80 00 00 	movabs $0x804206,%rdi
  8001ac:	00 00 00 
  8001af:	48 b8 9e 27 80 00 00 	movabs $0x80279e,%rax
  8001b6:	00 00 00 
  8001b9:	ff d0                	call   *%rax
  8001bb:	89 c3                	mov    %eax,%ebx
  8001bd:	85 c0                	test   %eax,%eax
  8001bf:	0f 88 4c 01 00 00    	js     800311 <umain+0x1ac>
    if ((wfd = pipe(pfds)) < 0)
  8001c5:	48 8d 7d c4          	lea    -0x3c(%rbp),%rdi
  8001c9:	48 b8 a8 33 80 00 00 	movabs $0x8033a8,%rax
  8001d0:	00 00 00 
  8001d3:	ff d0                	call   *%rax
  8001d5:	85 c0                	test   %eax,%eax
  8001d7:	0f 88 61 01 00 00    	js     80033e <umain+0x1d9>
    wfd = pfds[1];
  8001dd:	44 8b 65 c8          	mov    -0x38(%rbp),%r12d
    cprintf("running sh -x < testshell.sh | cat\n");
  8001e1:	48 bf 28 40 80 00 00 	movabs $0x804028,%rdi
  8001e8:	00 00 00 
  8001eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8001f0:	48 ba 65 09 80 00 00 	movabs $0x800965,%rdx
  8001f7:	00 00 00 
  8001fa:	ff d2                	call   *%rdx
    if ((r = fork()) < 0)
  8001fc:	48 b8 77 1c 80 00 00 	movabs $0x801c77,%rax
  800203:	00 00 00 
  800206:	ff d0                	call   *%rax
  800208:	85 c0                	test   %eax,%eax
  80020a:	0f 88 5b 01 00 00    	js     80036b <umain+0x206>
    if (r == 0) {
  800210:	0f 85 a9 00 00 00    	jne    8002bf <umain+0x15a>
        dup(rfd, 0);
  800216:	be 00 00 00 00       	mov    $0x0,%esi
  80021b:	89 df                	mov    %ebx,%edi
  80021d:	49 bd 41 20 80 00 00 	movabs $0x802041,%r13
  800224:	00 00 00 
  800227:	41 ff d5             	call   *%r13
        dup(wfd, 1);
  80022a:	be 01 00 00 00       	mov    $0x1,%esi
  80022f:	44 89 e7             	mov    %r12d,%edi
  800232:	41 ff d5             	call   *%r13
        close(rfd);
  800235:	89 df                	mov    %ebx,%edi
  800237:	49 bd de 1f 80 00 00 	movabs $0x801fde,%r13
  80023e:	00 00 00 
  800241:	41 ff d5             	call   *%r13
        close(wfd);
  800244:	44 89 e7             	mov    %r12d,%edi
  800247:	41 ff d5             	call   *%r13
        if ((r = spawnl("/sh", "sh", "-x", 0)) < 0)
  80024a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80024f:	48 ba 4c 42 80 00 00 	movabs $0x80424c,%rdx
  800256:	00 00 00 
  800259:	48 be 10 42 80 00 00 	movabs $0x804210,%rsi
  800260:	00 00 00 
  800263:	48 bf 4f 42 80 00 00 	movabs $0x80424f,%rdi
  80026a:	00 00 00 
  80026d:	b8 00 00 00 00       	mov    $0x0,%eax
  800272:	49 b8 bf 2f 80 00 00 	movabs $0x802fbf,%r8
  800279:	00 00 00 
  80027c:	41 ff d0             	call   *%r8
  80027f:	41 89 c5             	mov    %eax,%r13d
  800282:	85 c0                	test   %eax,%eax
  800284:	0f 88 0e 01 00 00    	js     800398 <umain+0x233>
        close(0);
  80028a:	bf 00 00 00 00       	mov    $0x0,%edi
  80028f:	49 be de 1f 80 00 00 	movabs $0x801fde,%r14
  800296:	00 00 00 
  800299:	41 ff d6             	call   *%r14
        close(1);
  80029c:	bf 01 00 00 00       	mov    $0x1,%edi
  8002a1:	41 ff d6             	call   *%r14
        wait(r);
  8002a4:	44 89 ef             	mov    %r13d,%edi
  8002a7:	48 b8 0f 36 80 00 00 	movabs $0x80360f,%rax
  8002ae:	00 00 00 
  8002b1:	ff d0                	call   *%rax
        exit();
  8002b3:	48 b8 e2 07 80 00 00 	movabs $0x8007e2,%rax
  8002ba:	00 00 00 
  8002bd:	ff d0                	call   *%rax
    close(rfd);
  8002bf:	89 df                	mov    %ebx,%edi
  8002c1:	48 bb de 1f 80 00 00 	movabs $0x801fde,%rbx
  8002c8:	00 00 00 
  8002cb:	ff d3                	call   *%rbx
    close(wfd);
  8002cd:	44 89 e7             	mov    %r12d,%edi
  8002d0:	ff d3                	call   *%rbx
    rfd = pfds[0];
  8002d2:	44 8b 7d c4          	mov    -0x3c(%rbp),%r15d
    if ((kfd = open("testshell.key", O_RDONLY)) < 0)
  8002d6:	be 00 00 00 00       	mov    $0x0,%esi
  8002db:	48 bf 5d 42 80 00 00 	movabs $0x80425d,%rdi
  8002e2:	00 00 00 
  8002e5:	48 b8 9e 27 80 00 00 	movabs $0x80279e,%rax
  8002ec:	00 00 00 
  8002ef:	ff d0                	call   *%rax
  8002f1:	41 89 c6             	mov    %eax,%r14d
  8002f4:	85 c0                	test   %eax,%eax
  8002f6:	0f 88 c9 00 00 00    	js     8003c5 <umain+0x260>
    for (off = 0;; off++) {
  8002fc:	41 bc 00 00 00 00    	mov    $0x0,%r12d
        n1 = read(rfd, &c1, 1);
  800302:	49 bd 68 21 80 00 00 	movabs $0x802168,%r13
  800309:	00 00 00 
  80030c:	e9 5c 01 00 00       	jmp    80046d <umain+0x308>
        panic("open testshell.sh: %i", rfd);
  800311:	89 c1                	mov    %eax,%ecx
  800313:	48 ba 13 42 80 00 00 	movabs $0x804213,%rdx
  80031a:	00 00 00 
  80031d:	be 12 00 00 00       	mov    $0x12,%esi
  800322:	48 bf 29 42 80 00 00 	movabs $0x804229,%rdi
  800329:	00 00 00 
  80032c:	b8 00 00 00 00       	mov    $0x0,%eax
  800331:	49 b8 09 08 80 00 00 	movabs $0x800809,%r8
  800338:	00 00 00 
  80033b:	41 ff d0             	call   *%r8
        panic("pipe: %i", wfd);
  80033e:	89 c1                	mov    %eax,%ecx
  800340:	48 ba 3a 42 80 00 00 	movabs $0x80423a,%rdx
  800347:	00 00 00 
  80034a:	be 14 00 00 00       	mov    $0x14,%esi
  80034f:	48 bf 29 42 80 00 00 	movabs $0x804229,%rdi
  800356:	00 00 00 
  800359:	b8 00 00 00 00       	mov    $0x0,%eax
  80035e:	49 b8 09 08 80 00 00 	movabs $0x800809,%r8
  800365:	00 00 00 
  800368:	41 ff d0             	call   *%r8
        panic("fork: %i", r);
  80036b:	89 c1                	mov    %eax,%ecx
  80036d:	48 ba 43 42 80 00 00 	movabs $0x804243,%rdx
  800374:	00 00 00 
  800377:	be 19 00 00 00       	mov    $0x19,%esi
  80037c:	48 bf 29 42 80 00 00 	movabs $0x804229,%rdi
  800383:	00 00 00 
  800386:	b8 00 00 00 00       	mov    $0x0,%eax
  80038b:	49 b8 09 08 80 00 00 	movabs $0x800809,%r8
  800392:	00 00 00 
  800395:	41 ff d0             	call   *%r8
            panic("spawn: %i", r);
  800398:	89 c1                	mov    %eax,%ecx
  80039a:	48 ba 53 42 80 00 00 	movabs $0x804253,%rdx
  8003a1:	00 00 00 
  8003a4:	be 20 00 00 00       	mov    $0x20,%esi
  8003a9:	48 bf 29 42 80 00 00 	movabs $0x804229,%rdi
  8003b0:	00 00 00 
  8003b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8003b8:	49 b8 09 08 80 00 00 	movabs $0x800809,%r8
  8003bf:	00 00 00 
  8003c2:	41 ff d0             	call   *%r8
        panic("open testshell.key for reading: %i", kfd);
  8003c5:	89 c1                	mov    %eax,%ecx
  8003c7:	48 ba 50 40 80 00 00 	movabs $0x804050,%rdx
  8003ce:	00 00 00 
  8003d1:	be 2b 00 00 00       	mov    $0x2b,%esi
  8003d6:	48 bf 29 42 80 00 00 	movabs $0x804229,%rdi
  8003dd:	00 00 00 
  8003e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8003e5:	49 b8 09 08 80 00 00 	movabs $0x800809,%r8
  8003ec:	00 00 00 
  8003ef:	41 ff d0             	call   *%r8
            panic("reading testshell.out: %i", n1);
  8003f2:	8b 4d bc             	mov    -0x44(%rbp),%ecx
  8003f5:	48 ba 6b 42 80 00 00 	movabs $0x80426b,%rdx
  8003fc:	00 00 00 
  8003ff:	be 31 00 00 00       	mov    $0x31,%esi
  800404:	48 bf 29 42 80 00 00 	movabs $0x804229,%rdi
  80040b:	00 00 00 
  80040e:	b8 00 00 00 00       	mov    $0x0,%eax
  800413:	49 b8 09 08 80 00 00 	movabs $0x800809,%r8
  80041a:	00 00 00 
  80041d:	41 ff d0             	call   *%r8
            panic("reading testshell.key: %i", n2);
  800420:	48 ba 85 42 80 00 00 	movabs $0x804285,%rdx
  800427:	00 00 00 
  80042a:	be 33 00 00 00       	mov    $0x33,%esi
  80042f:	48 bf 29 42 80 00 00 	movabs $0x804229,%rdi
  800436:	00 00 00 
  800439:	b8 00 00 00 00       	mov    $0x0,%eax
  80043e:	49 b8 09 08 80 00 00 	movabs $0x800809,%r8
  800445:	00 00 00 
  800448:	41 ff d0             	call   *%r8
            wrong(rfd, kfd, off, c1, c2);
  80044b:	0f be 4d cf          	movsbl -0x31(%rbp),%ecx
  80044f:	44 0f be 45 ce       	movsbl -0x32(%rbp),%r8d
  800454:	44 89 e2             	mov    %r12d,%edx
  800457:	44 89 f6             	mov    %r14d,%esi
  80045a:	44 89 ff             	mov    %r15d,%edi
  80045d:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  800464:	00 00 00 
  800467:	ff d0                	call   *%rax
    for (off = 0;; off++) {
  800469:	41 83 c4 01          	add    $0x1,%r12d
        n1 = read(rfd, &c1, 1);
  80046d:	ba 01 00 00 00       	mov    $0x1,%edx
  800472:	48 8d 75 cf          	lea    -0x31(%rbp),%rsi
  800476:	44 89 ff             	mov    %r15d,%edi
  800479:	41 ff d5             	call   *%r13
  80047c:	48 89 c3             	mov    %rax,%rbx
  80047f:	89 45 bc             	mov    %eax,-0x44(%rbp)
        n2 = read(kfd, &c2, 1);
  800482:	ba 01 00 00 00       	mov    $0x1,%edx
  800487:	48 8d 75 ce          	lea    -0x32(%rbp),%rsi
  80048b:	44 89 f7             	mov    %r14d,%edi
  80048e:	41 ff d5             	call   *%r13
  800491:	89 c1                	mov    %eax,%ecx
        if (n1 < 0)
  800493:	85 db                	test   %ebx,%ebx
  800495:	0f 88 57 ff ff ff    	js     8003f2 <umain+0x28d>
        if (n2 < 0)
  80049b:	85 c0                	test   %eax,%eax
  80049d:	78 81                	js     800420 <umain+0x2bb>
        if (n1 == 0 && n2 == 0)
  80049f:	89 c2                	mov    %eax,%edx
  8004a1:	09 da                	or     %ebx,%edx
  8004a3:	74 15                	je     8004ba <umain+0x355>
        if (n1 != 1 || n2 != 1 || c1 != c2) {
  8004a5:	83 fb 01             	cmp    $0x1,%ebx
  8004a8:	75 a1                	jne    80044b <umain+0x2e6>
  8004aa:	83 f8 01             	cmp    $0x1,%eax
  8004ad:	75 9c                	jne    80044b <umain+0x2e6>
  8004af:	0f b6 45 ce          	movzbl -0x32(%rbp),%eax
  8004b3:	38 45 cf             	cmp    %al,-0x31(%rbp)
  8004b6:	75 93                	jne    80044b <umain+0x2e6>
  8004b8:	eb af                	jmp    800469 <umain+0x304>
    cprintf("shell ran correctly\n");
  8004ba:	48 bf 9f 42 80 00 00 	movabs $0x80429f,%rdi
  8004c1:	00 00 00 
  8004c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c9:	48 ba 65 09 80 00 00 	movabs $0x800965,%rdx
  8004d0:	00 00 00 
  8004d3:	ff d2                	call   *%rdx

#include <inc/types.h>

static inline void __attribute__((always_inline))
breakpoint(void) {
    asm volatile("int3");
  8004d5:	cc                   	int3
}
  8004d6:	48 83 c4 28          	add    $0x28,%rsp
  8004da:	5b                   	pop    %rbx
  8004db:	41 5c                	pop    %r12
  8004dd:	41 5d                	pop    %r13
  8004df:	41 5e                	pop    %r14
  8004e1:	41 5f                	pop    %r15
  8004e3:	5d                   	pop    %rbp
  8004e4:	c3                   	ret

00000000008004e5 <devcons_close>:

    return res;
}

static int
devcons_close(struct Fd *fd) {
  8004e5:	f3 0f 1e fa          	endbr64
    USED(fd);

    return 0;
}
  8004e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ee:	c3                   	ret

00000000008004ef <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  8004ef:	f3 0f 1e fa          	endbr64
  8004f3:	55                   	push   %rbp
  8004f4:	48 89 e5             	mov    %rsp,%rbp
  8004f7:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  8004fa:	48 be b4 42 80 00 00 	movabs $0x8042b4,%rsi
  800501:	00 00 00 
  800504:	48 b8 ae 12 80 00 00 	movabs $0x8012ae,%rax
  80050b:	00 00 00 
  80050e:	ff d0                	call   *%rax
    return 0;
}
  800510:	b8 00 00 00 00       	mov    $0x0,%eax
  800515:	5d                   	pop    %rbp
  800516:	c3                   	ret

0000000000800517 <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  800517:	f3 0f 1e fa          	endbr64
  80051b:	55                   	push   %rbp
  80051c:	48 89 e5             	mov    %rsp,%rbp
  80051f:	41 57                	push   %r15
  800521:	41 56                	push   %r14
  800523:	41 55                	push   %r13
  800525:	41 54                	push   %r12
  800527:	53                   	push   %rbx
  800528:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  80052f:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  800536:	48 85 d2             	test   %rdx,%rdx
  800539:	74 7a                	je     8005b5 <devcons_write+0x9e>
  80053b:	49 89 d6             	mov    %rdx,%r14
  80053e:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  800544:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  800549:	49 bf c9 14 80 00 00 	movabs $0x8014c9,%r15
  800550:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  800553:	4c 89 f3             	mov    %r14,%rbx
  800556:	48 29 f3             	sub    %rsi,%rbx
  800559:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80055e:	48 39 c3             	cmp    %rax,%rbx
  800561:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  800565:	4c 63 eb             	movslq %ebx,%r13
  800568:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  80056f:	48 01 c6             	add    %rax,%rsi
  800572:	4c 89 ea             	mov    %r13,%rdx
  800575:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  80057c:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  80057f:	4c 89 ee             	mov    %r13,%rsi
  800582:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  800589:	48 b8 0e 17 80 00 00 	movabs $0x80170e,%rax
  800590:	00 00 00 
  800593:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  800595:	41 01 dc             	add    %ebx,%r12d
  800598:	49 63 f4             	movslq %r12d,%rsi
  80059b:	4c 39 f6             	cmp    %r14,%rsi
  80059e:	72 b3                	jb     800553 <devcons_write+0x3c>
    return res;
  8005a0:	49 63 c4             	movslq %r12d,%rax
}
  8005a3:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  8005aa:	5b                   	pop    %rbx
  8005ab:	41 5c                	pop    %r12
  8005ad:	41 5d                	pop    %r13
  8005af:	41 5e                	pop    %r14
  8005b1:	41 5f                	pop    %r15
  8005b3:	5d                   	pop    %rbp
  8005b4:	c3                   	ret
    for (res = 0; res < n; res += inc) {
  8005b5:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  8005bb:	eb e3                	jmp    8005a0 <devcons_write+0x89>

00000000008005bd <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  8005bd:	f3 0f 1e fa          	endbr64
  8005c1:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  8005c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c9:	48 85 c0             	test   %rax,%rax
  8005cc:	74 55                	je     800623 <devcons_read+0x66>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  8005ce:	55                   	push   %rbp
  8005cf:	48 89 e5             	mov    %rsp,%rbp
  8005d2:	41 55                	push   %r13
  8005d4:	41 54                	push   %r12
  8005d6:	53                   	push   %rbx
  8005d7:	48 83 ec 08          	sub    $0x8,%rsp
  8005db:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  8005de:	48 bb 3f 17 80 00 00 	movabs $0x80173f,%rbx
  8005e5:	00 00 00 
  8005e8:	49 bc 18 18 80 00 00 	movabs $0x801818,%r12
  8005ef:	00 00 00 
  8005f2:	eb 03                	jmp    8005f7 <devcons_read+0x3a>
  8005f4:	41 ff d4             	call   *%r12
  8005f7:	ff d3                	call   *%rbx
  8005f9:	85 c0                	test   %eax,%eax
  8005fb:	74 f7                	je     8005f4 <devcons_read+0x37>
    if (c < 0) return c;
  8005fd:	48 63 d0             	movslq %eax,%rdx
  800600:	78 13                	js     800615 <devcons_read+0x58>
    if (c == 0x04) return 0;
  800602:	ba 00 00 00 00       	mov    $0x0,%edx
  800607:	83 f8 04             	cmp    $0x4,%eax
  80060a:	74 09                	je     800615 <devcons_read+0x58>
    *(char *)vbuf = (char)c;
  80060c:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  800610:	ba 01 00 00 00       	mov    $0x1,%edx
}
  800615:	48 89 d0             	mov    %rdx,%rax
  800618:	48 83 c4 08          	add    $0x8,%rsp
  80061c:	5b                   	pop    %rbx
  80061d:	41 5c                	pop    %r12
  80061f:	41 5d                	pop    %r13
  800621:	5d                   	pop    %rbp
  800622:	c3                   	ret
  800623:	48 89 d0             	mov    %rdx,%rax
  800626:	c3                   	ret

0000000000800627 <cputchar>:
cputchar(int ch) {
  800627:	f3 0f 1e fa          	endbr64
  80062b:	55                   	push   %rbp
  80062c:	48 89 e5             	mov    %rsp,%rbp
  80062f:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  800633:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  800637:	be 01 00 00 00       	mov    $0x1,%esi
  80063c:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  800640:	48 b8 0e 17 80 00 00 	movabs $0x80170e,%rax
  800647:	00 00 00 
  80064a:	ff d0                	call   *%rax
}
  80064c:	c9                   	leave
  80064d:	c3                   	ret

000000000080064e <getchar>:
getchar(void) {
  80064e:	f3 0f 1e fa          	endbr64
  800652:	55                   	push   %rbp
  800653:	48 89 e5             	mov    %rsp,%rbp
  800656:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  80065a:	ba 01 00 00 00       	mov    $0x1,%edx
  80065f:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  800663:	bf 00 00 00 00       	mov    $0x0,%edi
  800668:	48 b8 68 21 80 00 00 	movabs $0x802168,%rax
  80066f:	00 00 00 
  800672:	ff d0                	call   *%rax
  800674:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  800676:	85 c0                	test   %eax,%eax
  800678:	78 06                	js     800680 <getchar+0x32>
  80067a:	74 08                	je     800684 <getchar+0x36>
  80067c:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  800680:	89 d0                	mov    %edx,%eax
  800682:	c9                   	leave
  800683:	c3                   	ret
    return res < 0 ? res : res ? c :
  800684:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  800689:	eb f5                	jmp    800680 <getchar+0x32>

000000000080068b <iscons>:
iscons(int fdnum) {
  80068b:	f3 0f 1e fa          	endbr64
  80068f:	55                   	push   %rbp
  800690:	48 89 e5             	mov    %rsp,%rbp
  800693:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  800697:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  80069b:	48 b8 6d 1e 80 00 00 	movabs $0x801e6d,%rax
  8006a2:	00 00 00 
  8006a5:	ff d0                	call   *%rax
    if (res < 0) return res;
  8006a7:	85 c0                	test   %eax,%eax
  8006a9:	78 18                	js     8006c3 <iscons+0x38>
    return fd->fd_dev_id == devcons.dev_id;
  8006ab:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8006af:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8006b6:	00 00 00 
  8006b9:	8b 00                	mov    (%rax),%eax
  8006bb:	39 02                	cmp    %eax,(%rdx)
  8006bd:	0f 94 c0             	sete   %al
  8006c0:	0f b6 c0             	movzbl %al,%eax
}
  8006c3:	c9                   	leave
  8006c4:	c3                   	ret

00000000008006c5 <opencons>:
opencons(void) {
  8006c5:	f3 0f 1e fa          	endbr64
  8006c9:	55                   	push   %rbp
  8006ca:	48 89 e5             	mov    %rsp,%rbp
  8006cd:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  8006d1:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  8006d5:	48 b8 09 1e 80 00 00 	movabs $0x801e09,%rax
  8006dc:	00 00 00 
  8006df:	ff d0                	call   *%rax
  8006e1:	85 c0                	test   %eax,%eax
  8006e3:	78 49                	js     80072e <opencons+0x69>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  8006e5:	b9 46 00 00 00       	mov    $0x46,%ecx
  8006ea:	ba 00 10 00 00       	mov    $0x1000,%edx
  8006ef:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  8006f3:	bf 00 00 00 00       	mov    $0x0,%edi
  8006f8:	48 b8 b3 18 80 00 00 	movabs $0x8018b3,%rax
  8006ff:	00 00 00 
  800702:	ff d0                	call   *%rax
  800704:	85 c0                	test   %eax,%eax
  800706:	78 26                	js     80072e <opencons+0x69>
    fd->fd_dev_id = devcons.dev_id;
  800708:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80070c:	a1 00 50 80 00 00 00 	movabs 0x805000,%eax
  800713:	00 00 
  800715:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  800717:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80071b:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  800722:	48 b8 d3 1d 80 00 00 	movabs $0x801dd3,%rax
  800729:	00 00 00 
  80072c:	ff d0                	call   *%rax
}
  80072e:	c9                   	leave
  80072f:	c3                   	ret

0000000000800730 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  800730:	f3 0f 1e fa          	endbr64
  800734:	55                   	push   %rbp
  800735:	48 89 e5             	mov    %rsp,%rbp
  800738:	41 56                	push   %r14
  80073a:	41 55                	push   %r13
  80073c:	41 54                	push   %r12
  80073e:	53                   	push   %rbx
  80073f:	41 89 fd             	mov    %edi,%r13d
  800742:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
     * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  800745:	48 ba b8 50 80 00 00 	movabs $0x8050b8,%rdx
  80074c:	00 00 00 
  80074f:	48 b8 b8 50 80 00 00 	movabs $0x8050b8,%rax
  800756:	00 00 00 
  800759:	48 39 c2             	cmp    %rax,%rdx
  80075c:	73 17                	jae    800775 <libmain+0x45>
    void (**ctor)() = &__ctors_start;
  80075e:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  800761:	49 89 c4             	mov    %rax,%r12
  800764:	48 83 c3 08          	add    $0x8,%rbx
  800768:	b8 00 00 00 00       	mov    $0x0,%eax
  80076d:	ff 53 f8             	call   *-0x8(%rbx)
  800770:	4c 39 e3             	cmp    %r12,%rbx
  800773:	72 ef                	jb     800764 <libmain+0x34>

    /* Set thisenv to point at our Env structure in envs[]. */

    // LAB 8: Your code here
    thisenv = &((struct Env *)UENVS)[ENVX(sys_getenvid())];
  800775:	48 b8 e3 17 80 00 00 	movabs $0x8017e3,%rax
  80077c:	00 00 00 
  80077f:	ff d0                	call   *%rax
  800781:	25 ff 03 00 00       	and    $0x3ff,%eax
  800786:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  80078a:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  80078e:	48 c1 e0 04          	shl    $0x4,%rax
  800792:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  800799:	00 00 00 
  80079c:	48 01 d0             	add    %rdx,%rax
  80079f:	48 a3 00 60 80 00 00 	movabs %rax,0x806000
  8007a6:	00 00 00 

    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  8007a9:	45 85 ed             	test   %r13d,%r13d
  8007ac:	7e 0d                	jle    8007bb <libmain+0x8b>
  8007ae:	49 8b 06             	mov    (%r14),%rax
  8007b1:	48 a3 38 50 80 00 00 	movabs %rax,0x805038
  8007b8:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  8007bb:	4c 89 f6             	mov    %r14,%rsi
  8007be:	44 89 ef             	mov    %r13d,%edi
  8007c1:	48 b8 65 01 80 00 00 	movabs $0x800165,%rax
  8007c8:	00 00 00 
  8007cb:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  8007cd:	48 b8 e2 07 80 00 00 	movabs $0x8007e2,%rax
  8007d4:	00 00 00 
  8007d7:	ff d0                	call   *%rax
#endif
}
  8007d9:	5b                   	pop    %rbx
  8007da:	41 5c                	pop    %r12
  8007dc:	41 5d                	pop    %r13
  8007de:	41 5e                	pop    %r14
  8007e0:	5d                   	pop    %rbp
  8007e1:	c3                   	ret

00000000008007e2 <exit>:

#include <inc/lib.h>

void
exit(void) {
  8007e2:	f3 0f 1e fa          	endbr64
  8007e6:	55                   	push   %rbp
  8007e7:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  8007ea:	48 b8 15 20 80 00 00 	movabs $0x802015,%rax
  8007f1:	00 00 00 
  8007f4:	ff d0                	call   *%rax
    sys_env_destroy(0);
  8007f6:	bf 00 00 00 00       	mov    $0x0,%edi
  8007fb:	48 b8 74 17 80 00 00 	movabs $0x801774,%rax
  800802:	00 00 00 
  800805:	ff d0                	call   *%rax
}
  800807:	5d                   	pop    %rbp
  800808:	c3                   	ret

0000000000800809 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  800809:	f3 0f 1e fa          	endbr64
  80080d:	55                   	push   %rbp
  80080e:	48 89 e5             	mov    %rsp,%rbp
  800811:	41 56                	push   %r14
  800813:	41 55                	push   %r13
  800815:	41 54                	push   %r12
  800817:	53                   	push   %rbx
  800818:	48 83 ec 50          	sub    $0x50,%rsp
  80081c:	49 89 fc             	mov    %rdi,%r12
  80081f:	41 89 f5             	mov    %esi,%r13d
  800822:	48 89 d3             	mov    %rdx,%rbx
  800825:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800829:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  80082d:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800831:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  800838:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80083c:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  800840:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  800844:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  800848:	48 b8 38 50 80 00 00 	movabs $0x805038,%rax
  80084f:	00 00 00 
  800852:	4c 8b 30             	mov    (%rax),%r14
  800855:	48 b8 e3 17 80 00 00 	movabs $0x8017e3,%rax
  80085c:	00 00 00 
  80085f:	ff d0                	call   *%rax
  800861:	89 c6                	mov    %eax,%esi
  800863:	45 89 e8             	mov    %r13d,%r8d
  800866:	4c 89 e1             	mov    %r12,%rcx
  800869:	4c 89 f2             	mov    %r14,%rdx
  80086c:	48 bf 78 40 80 00 00 	movabs $0x804078,%rdi
  800873:	00 00 00 
  800876:	b8 00 00 00 00       	mov    $0x0,%eax
  80087b:	49 bc 65 09 80 00 00 	movabs $0x800965,%r12
  800882:	00 00 00 
  800885:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  800888:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  80088c:	48 89 df             	mov    %rbx,%rdi
  80088f:	48 b8 fd 08 80 00 00 	movabs $0x8008fd,%rax
  800896:	00 00 00 
  800899:	ff d0                	call   *%rax
    cprintf("\n");
  80089b:	48 bf 04 42 80 00 00 	movabs $0x804204,%rdi
  8008a2:	00 00 00 
  8008a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8008aa:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  8008ad:	cc                   	int3
  8008ae:	eb fd                	jmp    8008ad <_panic+0xa4>

00000000008008b0 <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  8008b0:	f3 0f 1e fa          	endbr64
  8008b4:	55                   	push   %rbp
  8008b5:	48 89 e5             	mov    %rsp,%rbp
  8008b8:	53                   	push   %rbx
  8008b9:	48 83 ec 08          	sub    $0x8,%rsp
  8008bd:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  8008c0:	8b 06                	mov    (%rsi),%eax
  8008c2:	8d 50 01             	lea    0x1(%rax),%edx
  8008c5:	89 16                	mov    %edx,(%rsi)
  8008c7:	48 98                	cltq
  8008c9:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  8008ce:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  8008d4:	74 0a                	je     8008e0 <putch+0x30>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  8008d6:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  8008da:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8008de:	c9                   	leave
  8008df:	c3                   	ret
        sys_cputs(state->buf, state->offset);
  8008e0:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  8008e4:	be ff 00 00 00       	mov    $0xff,%esi
  8008e9:	48 b8 0e 17 80 00 00 	movabs $0x80170e,%rax
  8008f0:	00 00 00 
  8008f3:	ff d0                	call   *%rax
        state->offset = 0;
  8008f5:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  8008fb:	eb d9                	jmp    8008d6 <putch+0x26>

00000000008008fd <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  8008fd:	f3 0f 1e fa          	endbr64
  800901:	55                   	push   %rbp
  800902:	48 89 e5             	mov    %rsp,%rbp
  800905:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80090c:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  80090f:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  800916:	b9 21 00 00 00       	mov    $0x21,%ecx
  80091b:	b8 00 00 00 00       	mov    $0x0,%eax
  800920:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  800923:	48 89 f1             	mov    %rsi,%rcx
  800926:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  80092d:	48 bf b0 08 80 00 00 	movabs $0x8008b0,%rdi
  800934:	00 00 00 
  800937:	48 b8 c5 0a 80 00 00 	movabs $0x800ac5,%rax
  80093e:	00 00 00 
  800941:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  800943:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  80094a:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  800951:	48 b8 0e 17 80 00 00 	movabs $0x80170e,%rax
  800958:	00 00 00 
  80095b:	ff d0                	call   *%rax

    return state.count;
}
  80095d:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  800963:	c9                   	leave
  800964:	c3                   	ret

0000000000800965 <cprintf>:

int
cprintf(const char *fmt, ...) {
  800965:	f3 0f 1e fa          	endbr64
  800969:	55                   	push   %rbp
  80096a:	48 89 e5             	mov    %rsp,%rbp
  80096d:	48 83 ec 50          	sub    $0x50,%rsp
  800971:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  800975:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  800979:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80097d:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800981:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  800985:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  80098c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800990:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800994:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800998:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  80099c:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  8009a0:	48 b8 fd 08 80 00 00 	movabs $0x8008fd,%rax
  8009a7:	00 00 00 
  8009aa:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  8009ac:	c9                   	leave
  8009ad:	c3                   	ret

00000000008009ae <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  8009ae:	f3 0f 1e fa          	endbr64
  8009b2:	55                   	push   %rbp
  8009b3:	48 89 e5             	mov    %rsp,%rbp
  8009b6:	41 57                	push   %r15
  8009b8:	41 56                	push   %r14
  8009ba:	41 55                	push   %r13
  8009bc:	41 54                	push   %r12
  8009be:	53                   	push   %rbx
  8009bf:	48 83 ec 18          	sub    $0x18,%rsp
  8009c3:	49 89 fc             	mov    %rdi,%r12
  8009c6:	49 89 f5             	mov    %rsi,%r13
  8009c9:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  8009cd:	8b 45 10             	mov    0x10(%rbp),%eax
  8009d0:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  8009d3:	41 89 cf             	mov    %ecx,%r15d
  8009d6:	4c 39 fa             	cmp    %r15,%rdx
  8009d9:	73 5b                	jae    800a36 <print_num+0x88>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  8009db:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  8009df:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  8009e3:	85 db                	test   %ebx,%ebx
  8009e5:	7e 0e                	jle    8009f5 <print_num+0x47>
            putch(padc, put_arg);
  8009e7:	4c 89 ee             	mov    %r13,%rsi
  8009ea:	44 89 f7             	mov    %r14d,%edi
  8009ed:	41 ff d4             	call   *%r12
        while (--width > 0) {
  8009f0:	83 eb 01             	sub    $0x1,%ebx
  8009f3:	75 f2                	jne    8009e7 <print_num+0x39>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  8009f5:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  8009f9:	48 b9 db 42 80 00 00 	movabs $0x8042db,%rcx
  800a00:	00 00 00 
  800a03:	48 b8 ca 42 80 00 00 	movabs $0x8042ca,%rax
  800a0a:	00 00 00 
  800a0d:	48 0f 45 c8          	cmovne %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  800a11:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800a15:	ba 00 00 00 00       	mov    $0x0,%edx
  800a1a:	49 f7 f7             	div    %r15
  800a1d:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  800a21:	4c 89 ee             	mov    %r13,%rsi
  800a24:	41 ff d4             	call   *%r12
}
  800a27:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800a2b:	5b                   	pop    %rbx
  800a2c:	41 5c                	pop    %r12
  800a2e:	41 5d                	pop    %r13
  800a30:	41 5e                	pop    %r14
  800a32:	41 5f                	pop    %r15
  800a34:	5d                   	pop    %rbp
  800a35:	c3                   	ret
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  800a36:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800a3a:	ba 00 00 00 00       	mov    $0x0,%edx
  800a3f:	49 f7 f7             	div    %r15
  800a42:	48 83 ec 08          	sub    $0x8,%rsp
  800a46:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  800a4a:	52                   	push   %rdx
  800a4b:	45 0f be c9          	movsbl %r9b,%r9d
  800a4f:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  800a53:	48 89 c2             	mov    %rax,%rdx
  800a56:	48 b8 ae 09 80 00 00 	movabs $0x8009ae,%rax
  800a5d:	00 00 00 
  800a60:	ff d0                	call   *%rax
  800a62:	48 83 c4 10          	add    $0x10,%rsp
  800a66:	eb 8d                	jmp    8009f5 <print_num+0x47>

0000000000800a68 <sprintputch>:
    char *end;
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
  800a68:	f3 0f 1e fa          	endbr64
    state->count++;
  800a6c:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  800a70:	48 8b 06             	mov    (%rsi),%rax
  800a73:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  800a77:	73 0a                	jae    800a83 <sprintputch+0x1b>
        *state->start++ = ch;
  800a79:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a7d:	48 89 16             	mov    %rdx,(%rsi)
  800a80:	40 88 38             	mov    %dil,(%rax)
    }
}
  800a83:	c3                   	ret

0000000000800a84 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  800a84:	f3 0f 1e fa          	endbr64
  800a88:	55                   	push   %rbp
  800a89:	48 89 e5             	mov    %rsp,%rbp
  800a8c:	48 83 ec 50          	sub    $0x50,%rsp
  800a90:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800a94:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800a98:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  800a9c:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800aa3:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800aa7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800aab:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800aaf:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  800ab3:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800ab7:	48 b8 c5 0a 80 00 00 	movabs $0x800ac5,%rax
  800abe:	00 00 00 
  800ac1:	ff d0                	call   *%rax
}
  800ac3:	c9                   	leave
  800ac4:	c3                   	ret

0000000000800ac5 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  800ac5:	f3 0f 1e fa          	endbr64
  800ac9:	55                   	push   %rbp
  800aca:	48 89 e5             	mov    %rsp,%rbp
  800acd:	41 57                	push   %r15
  800acf:	41 56                	push   %r14
  800ad1:	41 55                	push   %r13
  800ad3:	41 54                	push   %r12
  800ad5:	53                   	push   %rbx
  800ad6:	48 83 ec 38          	sub    $0x38,%rsp
  800ada:	49 89 fe             	mov    %rdi,%r14
  800add:	49 89 f5             	mov    %rsi,%r13
  800ae0:	48 89 d3             	mov    %rdx,%rbx
    va_copy(aq, ap);
  800ae3:	48 8b 01             	mov    (%rcx),%rax
  800ae6:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  800aea:	48 8b 41 08          	mov    0x8(%rcx),%rax
  800aee:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800af2:	48 8b 41 10          	mov    0x10(%rcx),%rax
  800af6:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  800afa:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  800afe:	0f b6 3b             	movzbl (%rbx),%edi
  800b01:	40 80 ff 25          	cmp    $0x25,%dil
  800b05:	74 18                	je     800b1f <vprintfmt+0x5a>
            if (!ch) return;
  800b07:	40 84 ff             	test   %dil,%dil
  800b0a:	0f 84 b2 06 00 00    	je     8011c2 <vprintfmt+0x6fd>
            putch(ch, put_arg);
  800b10:	40 0f b6 ff          	movzbl %dil,%edi
  800b14:	4c 89 ee             	mov    %r13,%rsi
  800b17:	41 ff d6             	call   *%r14
        while ((ch = *ufmt++) != '%') {
  800b1a:	4c 89 e3             	mov    %r12,%rbx
  800b1d:	eb db                	jmp    800afa <vprintfmt+0x35>
        bool altflag = 0, zflag = 0;
  800b1f:	be 00 00 00 00       	mov    $0x0,%esi
  800b24:	c6 45 ab 00          	movb   $0x0,-0x55(%rbp)
        unsigned lflag = 0, base = 10;
  800b28:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  800b2d:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  800b33:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  800b3a:	c6 45 aa 20          	movb   $0x20,-0x56(%rbp)
        switch (ch = *ufmt++) {
  800b3e:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  800b43:	41 0f b6 04 24       	movzbl (%r12),%eax
  800b48:	88 45 a0             	mov    %al,-0x60(%rbp)
  800b4b:	83 e8 23             	sub    $0x23,%eax
  800b4e:	3c 57                	cmp    $0x57,%al
  800b50:	0f 87 52 06 00 00    	ja     8011a8 <vprintfmt+0x6e3>
  800b56:	0f b6 c0             	movzbl %al,%eax
  800b59:	48 b9 00 46 80 00 00 	movabs $0x804600,%rcx
  800b60:	00 00 00 
  800b63:	3e ff 24 c1          	notrack jmp *(%rcx,%rax,8)
  800b67:	49 89 dc             	mov    %rbx,%r12
            altflag = 1;
  800b6a:	c6 45 ab 01          	movb   $0x1,-0x55(%rbp)
  800b6e:	eb ce                	jmp    800b3e <vprintfmt+0x79>
        switch (ch = *ufmt++) {
  800b70:	49 89 dc             	mov    %rbx,%r12
  800b73:	be 01 00 00 00       	mov    $0x1,%esi
  800b78:	eb c4                	jmp    800b3e <vprintfmt+0x79>
            padc = ch;
  800b7a:	0f b6 45 a0          	movzbl -0x60(%rbp),%eax
  800b7e:	88 45 aa             	mov    %al,-0x56(%rbp)
        switch (ch = *ufmt++) {
  800b81:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  800b84:	eb b8                	jmp    800b3e <vprintfmt+0x79>
            precision = va_arg(aq, int);
  800b86:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b89:	83 f8 2f             	cmp    $0x2f,%eax
  800b8c:	77 24                	ja     800bb2 <vprintfmt+0xed>
  800b8e:	89 c1                	mov    %eax,%ecx
  800b90:	48 03 4d c8          	add    -0x38(%rbp),%rcx
  800b94:	83 c0 08             	add    $0x8,%eax
  800b97:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b9a:	44 8b 39             	mov    (%rcx),%r15d
        switch (ch = *ufmt++) {
  800b9d:	49 89 dc             	mov    %rbx,%r12
            if (width < 0) {
  800ba0:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800ba4:	79 98                	jns    800b3e <vprintfmt+0x79>
                width = precision;
  800ba6:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
                precision = -1;
  800baa:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  800bb0:	eb 8c                	jmp    800b3e <vprintfmt+0x79>
            precision = va_arg(aq, int);
  800bb2:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  800bb6:	48 8d 41 08          	lea    0x8(%rcx),%rax
  800bba:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800bbe:	eb da                	jmp    800b9a <vprintfmt+0xd5>
                precision = precision * 10 + ch - '0';
  800bc0:	44 0f b6 7d a0       	movzbl -0x60(%rbp),%r15d
  800bc5:	41 83 ef 30          	sub    $0x30,%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  800bc9:	41 0f b6 44 24 01    	movzbl 0x1(%r12),%eax
  800bcf:	3c 39                	cmp    $0x39,%al
  800bd1:	77 1c                	ja     800bef <vprintfmt+0x12a>
            for (precision = 0;; ++ufmt) {
  800bd3:	48 83 c3 01          	add    $0x1,%rbx
                precision = precision * 10 + ch - '0';
  800bd7:	43 8d 0c bf          	lea    (%r15,%r15,4),%ecx
  800bdb:	0f b6 c0             	movzbl %al,%eax
  800bde:	44 8d 7c 48 d0       	lea    -0x30(%rax,%rcx,2),%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  800be3:	0f b6 03             	movzbl (%rbx),%eax
  800be6:	3c 39                	cmp    $0x39,%al
  800be8:	76 e9                	jbe    800bd3 <vprintfmt+0x10e>
        process_precision:
  800bea:	49 89 dc             	mov    %rbx,%r12
  800bed:	eb b1                	jmp    800ba0 <vprintfmt+0xdb>
        switch (ch = *ufmt++) {
  800bef:	49 89 dc             	mov    %rbx,%r12
  800bf2:	eb ac                	jmp    800ba0 <vprintfmt+0xdb>
            width = MAX(0, width);
  800bf4:	8b 4d ac             	mov    -0x54(%rbp),%ecx
  800bf7:	85 c9                	test   %ecx,%ecx
  800bf9:	b8 00 00 00 00       	mov    $0x0,%eax
  800bfe:	0f 49 c1             	cmovns %ecx,%eax
  800c01:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  800c04:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  800c07:	e9 32 ff ff ff       	jmp    800b3e <vprintfmt+0x79>
            lflag++;
  800c0c:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  800c0f:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  800c12:	e9 27 ff ff ff       	jmp    800b3e <vprintfmt+0x79>
            putch(va_arg(aq, int), put_arg);
  800c17:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c1a:	83 f8 2f             	cmp    $0x2f,%eax
  800c1d:	77 19                	ja     800c38 <vprintfmt+0x173>
  800c1f:	89 c2                	mov    %eax,%edx
  800c21:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800c25:	83 c0 08             	add    $0x8,%eax
  800c28:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c2b:	8b 3a                	mov    (%rdx),%edi
  800c2d:	4c 89 ee             	mov    %r13,%rsi
  800c30:	41 ff d6             	call   *%r14
            break;
  800c33:	e9 c2 fe ff ff       	jmp    800afa <vprintfmt+0x35>
            putch(va_arg(aq, int), put_arg);
  800c38:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c3c:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800c40:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c44:	eb e5                	jmp    800c2b <vprintfmt+0x166>
            int err = va_arg(aq, int);
  800c46:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c49:	83 f8 2f             	cmp    $0x2f,%eax
  800c4c:	77 5a                	ja     800ca8 <vprintfmt+0x1e3>
  800c4e:	89 c2                	mov    %eax,%edx
  800c50:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800c54:	83 c0 08             	add    $0x8,%eax
  800c57:	89 45 b8             	mov    %eax,-0x48(%rbp)
            if (err < 0) err = -err;
  800c5a:	8b 02                	mov    (%rdx),%eax
  800c5c:	89 c1                	mov    %eax,%ecx
  800c5e:	f7 d9                	neg    %ecx
  800c60:	0f 48 c8             	cmovs  %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  800c63:	83 f9 13             	cmp    $0x13,%ecx
  800c66:	7f 4e                	jg     800cb6 <vprintfmt+0x1f1>
  800c68:	48 63 c1             	movslq %ecx,%rax
  800c6b:	48 ba c0 48 80 00 00 	movabs $0x8048c0,%rdx
  800c72:	00 00 00 
  800c75:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  800c79:	48 85 c0             	test   %rax,%rax
  800c7c:	74 38                	je     800cb6 <vprintfmt+0x1f1>
                printfmt(putch, put_arg, "%s", strerr);
  800c7e:	48 89 c1             	mov    %rax,%rcx
  800c81:	48 ba f5 44 80 00 00 	movabs $0x8044f5,%rdx
  800c88:	00 00 00 
  800c8b:	4c 89 ee             	mov    %r13,%rsi
  800c8e:	4c 89 f7             	mov    %r14,%rdi
  800c91:	b8 00 00 00 00       	mov    $0x0,%eax
  800c96:	49 b8 84 0a 80 00 00 	movabs $0x800a84,%r8
  800c9d:	00 00 00 
  800ca0:	41 ff d0             	call   *%r8
  800ca3:	e9 52 fe ff ff       	jmp    800afa <vprintfmt+0x35>
            int err = va_arg(aq, int);
  800ca8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cac:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800cb0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800cb4:	eb a4                	jmp    800c5a <vprintfmt+0x195>
                printfmt(putch, put_arg, "error %d", err);
  800cb6:	48 ba f3 42 80 00 00 	movabs $0x8042f3,%rdx
  800cbd:	00 00 00 
  800cc0:	4c 89 ee             	mov    %r13,%rsi
  800cc3:	4c 89 f7             	mov    %r14,%rdi
  800cc6:	b8 00 00 00 00       	mov    $0x0,%eax
  800ccb:	49 b8 84 0a 80 00 00 	movabs $0x800a84,%r8
  800cd2:	00 00 00 
  800cd5:	41 ff d0             	call   *%r8
  800cd8:	e9 1d fe ff ff       	jmp    800afa <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  800cdd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ce0:	83 f8 2f             	cmp    $0x2f,%eax
  800ce3:	77 6c                	ja     800d51 <vprintfmt+0x28c>
  800ce5:	89 c2                	mov    %eax,%edx
  800ce7:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800ceb:	83 c0 08             	add    $0x8,%eax
  800cee:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800cf1:	48 8b 12             	mov    (%rdx),%rdx
            if (!ptr) ptr = "(null)";
  800cf4:	48 85 d2             	test   %rdx,%rdx
  800cf7:	48 b8 ec 42 80 00 00 	movabs $0x8042ec,%rax
  800cfe:	00 00 00 
  800d01:	48 0f 45 c2          	cmovne %rdx,%rax
  800d05:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
            if (width > 0 && padc != '-') {
  800d09:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800d0d:	7e 06                	jle    800d15 <vprintfmt+0x250>
  800d0f:	80 7d aa 2d          	cmpb   $0x2d,-0x56(%rbp)
  800d13:	75 4a                	jne    800d5f <vprintfmt+0x29a>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800d15:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d19:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800d1d:	0f b6 00             	movzbl (%rax),%eax
  800d20:	84 c0                	test   %al,%al
  800d22:	0f 85 9a 00 00 00    	jne    800dc2 <vprintfmt+0x2fd>
            while (width-- > 0) putch(' ', put_arg);
  800d28:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800d2b:	44 8d 60 ff          	lea    -0x1(%rax),%r12d
  800d2f:	85 c0                	test   %eax,%eax
  800d31:	0f 8e c3 fd ff ff    	jle    800afa <vprintfmt+0x35>
  800d37:	4c 89 ee             	mov    %r13,%rsi
  800d3a:	bf 20 00 00 00       	mov    $0x20,%edi
  800d3f:	41 ff d6             	call   *%r14
  800d42:	41 83 ec 01          	sub    $0x1,%r12d
  800d46:	41 83 fc ff          	cmp    $0xffffffff,%r12d
  800d4a:	75 eb                	jne    800d37 <vprintfmt+0x272>
  800d4c:	e9 a9 fd ff ff       	jmp    800afa <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  800d51:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d55:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800d59:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800d5d:	eb 92                	jmp    800cf1 <vprintfmt+0x22c>
                width -= strnlen(ptr, precision);
  800d5f:	49 63 f7             	movslq %r15d,%rsi
  800d62:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  800d66:	48 b8 88 12 80 00 00 	movabs $0x801288,%rax
  800d6d:	00 00 00 
  800d70:	ff d0                	call   *%rax
  800d72:	48 89 c2             	mov    %rax,%rdx
  800d75:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800d78:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  800d7a:	8d 70 ff             	lea    -0x1(%rax),%esi
  800d7d:	89 75 ac             	mov    %esi,-0x54(%rbp)
  800d80:	85 c0                	test   %eax,%eax
  800d82:	7e 91                	jle    800d15 <vprintfmt+0x250>
  800d84:	44 0f be 65 aa       	movsbl -0x56(%rbp),%r12d
  800d89:	4c 89 ee             	mov    %r13,%rsi
  800d8c:	44 89 e7             	mov    %r12d,%edi
  800d8f:	41 ff d6             	call   *%r14
  800d92:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  800d96:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800d99:	83 f8 ff             	cmp    $0xffffffff,%eax
  800d9c:	75 eb                	jne    800d89 <vprintfmt+0x2c4>
  800d9e:	e9 72 ff ff ff       	jmp    800d15 <vprintfmt+0x250>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800da3:	0f b6 f8             	movzbl %al,%edi
  800da6:	4c 89 ee             	mov    %r13,%rsi
  800da9:	41 ff d6             	call   *%r14
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800dac:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  800db0:	49 83 c4 01          	add    $0x1,%r12
  800db4:	41 0f b6 44 24 ff    	movzbl -0x1(%r12),%eax
  800dba:	84 c0                	test   %al,%al
  800dbc:	0f 84 66 ff ff ff    	je     800d28 <vprintfmt+0x263>
  800dc2:	45 85 ff             	test   %r15d,%r15d
  800dc5:	78 0a                	js     800dd1 <vprintfmt+0x30c>
  800dc7:	41 83 ef 01          	sub    $0x1,%r15d
  800dcb:	0f 88 57 ff ff ff    	js     800d28 <vprintfmt+0x263>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800dd1:	80 7d ab 00          	cmpb   $0x0,-0x55(%rbp)
  800dd5:	74 cc                	je     800da3 <vprintfmt+0x2de>
  800dd7:	8d 50 e0             	lea    -0x20(%rax),%edx
  800dda:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800ddf:	80 fa 5e             	cmp    $0x5e,%dl
  800de2:	77 c2                	ja     800da6 <vprintfmt+0x2e1>
  800de4:	eb bd                	jmp    800da3 <vprintfmt+0x2de>
    if (zflag) return va_arg(*ap, size_t);
  800de6:	40 84 f6             	test   %sil,%sil
  800de9:	75 26                	jne    800e11 <vprintfmt+0x34c>
    switch (lflag) {
  800deb:	85 d2                	test   %edx,%edx
  800ded:	74 59                	je     800e48 <vprintfmt+0x383>
  800def:	83 fa 01             	cmp    $0x1,%edx
  800df2:	74 7b                	je     800e6f <vprintfmt+0x3aa>
        return va_arg(*ap, long long);
  800df4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800df7:	83 f8 2f             	cmp    $0x2f,%eax
  800dfa:	0f 87 96 00 00 00    	ja     800e96 <vprintfmt+0x3d1>
  800e00:	89 c2                	mov    %eax,%edx
  800e02:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800e06:	83 c0 08             	add    $0x8,%eax
  800e09:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800e0c:	4c 8b 22             	mov    (%rdx),%r12
  800e0f:	eb 17                	jmp    800e28 <vprintfmt+0x363>
    if (zflag) return va_arg(*ap, size_t);
  800e11:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e14:	83 f8 2f             	cmp    $0x2f,%eax
  800e17:	77 21                	ja     800e3a <vprintfmt+0x375>
  800e19:	89 c2                	mov    %eax,%edx
  800e1b:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800e1f:	83 c0 08             	add    $0x8,%eax
  800e22:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800e25:	4c 8b 22             	mov    (%rdx),%r12
            if (i < 0) {
  800e28:	4d 85 e4             	test   %r12,%r12
  800e2b:	78 7a                	js     800ea7 <vprintfmt+0x3e2>
            num = i;
  800e2d:	4c 89 e2             	mov    %r12,%rdx
        unsigned lflag = 0, base = 10;
  800e30:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  800e35:	e9 50 02 00 00       	jmp    80108a <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800e3a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e3e:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800e42:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800e46:	eb dd                	jmp    800e25 <vprintfmt+0x360>
        return va_arg(*ap, int);
  800e48:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e4b:	83 f8 2f             	cmp    $0x2f,%eax
  800e4e:	77 11                	ja     800e61 <vprintfmt+0x39c>
  800e50:	89 c2                	mov    %eax,%edx
  800e52:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800e56:	83 c0 08             	add    $0x8,%eax
  800e59:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800e5c:	4c 63 22             	movslq (%rdx),%r12
  800e5f:	eb c7                	jmp    800e28 <vprintfmt+0x363>
  800e61:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e65:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800e69:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800e6d:	eb ed                	jmp    800e5c <vprintfmt+0x397>
        return va_arg(*ap, long);
  800e6f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e72:	83 f8 2f             	cmp    $0x2f,%eax
  800e75:	77 11                	ja     800e88 <vprintfmt+0x3c3>
  800e77:	89 c2                	mov    %eax,%edx
  800e79:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800e7d:	83 c0 08             	add    $0x8,%eax
  800e80:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800e83:	4c 8b 22             	mov    (%rdx),%r12
  800e86:	eb a0                	jmp    800e28 <vprintfmt+0x363>
  800e88:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e8c:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800e90:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800e94:	eb ed                	jmp    800e83 <vprintfmt+0x3be>
        return va_arg(*ap, long long);
  800e96:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e9a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800e9e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ea2:	e9 65 ff ff ff       	jmp    800e0c <vprintfmt+0x347>
                putch('-', put_arg);
  800ea7:	4c 89 ee             	mov    %r13,%rsi
  800eaa:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800eaf:	41 ff d6             	call   *%r14
                i = -i;
  800eb2:	49 f7 dc             	neg    %r12
  800eb5:	e9 73 ff ff ff       	jmp    800e2d <vprintfmt+0x368>
    if (zflag) return va_arg(*ap, size_t);
  800eba:	40 84 f6             	test   %sil,%sil
  800ebd:	75 32                	jne    800ef1 <vprintfmt+0x42c>
    switch (lflag) {
  800ebf:	85 d2                	test   %edx,%edx
  800ec1:	74 5d                	je     800f20 <vprintfmt+0x45b>
  800ec3:	83 fa 01             	cmp    $0x1,%edx
  800ec6:	0f 84 82 00 00 00    	je     800f4e <vprintfmt+0x489>
        return va_arg(*ap, unsigned long long);
  800ecc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ecf:	83 f8 2f             	cmp    $0x2f,%eax
  800ed2:	0f 87 a5 00 00 00    	ja     800f7d <vprintfmt+0x4b8>
  800ed8:	89 c2                	mov    %eax,%edx
  800eda:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800ede:	83 c0 08             	add    $0x8,%eax
  800ee1:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ee4:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800ee7:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  800eec:	e9 99 01 00 00       	jmp    80108a <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800ef1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ef4:	83 f8 2f             	cmp    $0x2f,%eax
  800ef7:	77 19                	ja     800f12 <vprintfmt+0x44d>
  800ef9:	89 c2                	mov    %eax,%edx
  800efb:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800eff:	83 c0 08             	add    $0x8,%eax
  800f02:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800f05:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800f08:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800f0d:	e9 78 01 00 00       	jmp    80108a <vprintfmt+0x5c5>
  800f12:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800f16:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800f1a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800f1e:	eb e5                	jmp    800f05 <vprintfmt+0x440>
        return va_arg(*ap, unsigned int);
  800f20:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f23:	83 f8 2f             	cmp    $0x2f,%eax
  800f26:	77 18                	ja     800f40 <vprintfmt+0x47b>
  800f28:	89 c2                	mov    %eax,%edx
  800f2a:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800f2e:	83 c0 08             	add    $0x8,%eax
  800f31:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800f34:	8b 12                	mov    (%rdx),%edx
        unsigned lflag = 0, base = 10;
  800f36:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  800f3b:	e9 4a 01 00 00       	jmp    80108a <vprintfmt+0x5c5>
  800f40:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800f44:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800f48:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800f4c:	eb e6                	jmp    800f34 <vprintfmt+0x46f>
        return va_arg(*ap, unsigned long);
  800f4e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f51:	83 f8 2f             	cmp    $0x2f,%eax
  800f54:	77 19                	ja     800f6f <vprintfmt+0x4aa>
  800f56:	89 c2                	mov    %eax,%edx
  800f58:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800f5c:	83 c0 08             	add    $0x8,%eax
  800f5f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800f62:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800f65:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  800f6a:	e9 1b 01 00 00       	jmp    80108a <vprintfmt+0x5c5>
  800f6f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800f73:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800f77:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800f7b:	eb e5                	jmp    800f62 <vprintfmt+0x49d>
        return va_arg(*ap, unsigned long long);
  800f7d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800f81:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800f85:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800f89:	e9 56 ff ff ff       	jmp    800ee4 <vprintfmt+0x41f>
    if (zflag) return va_arg(*ap, size_t);
  800f8e:	40 84 f6             	test   %sil,%sil
  800f91:	75 2e                	jne    800fc1 <vprintfmt+0x4fc>
    switch (lflag) {
  800f93:	85 d2                	test   %edx,%edx
  800f95:	74 59                	je     800ff0 <vprintfmt+0x52b>
  800f97:	83 fa 01             	cmp    $0x1,%edx
  800f9a:	74 7f                	je     80101b <vprintfmt+0x556>
        return va_arg(*ap, unsigned long long);
  800f9c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f9f:	83 f8 2f             	cmp    $0x2f,%eax
  800fa2:	0f 87 9f 00 00 00    	ja     801047 <vprintfmt+0x582>
  800fa8:	89 c2                	mov    %eax,%edx
  800faa:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800fae:	83 c0 08             	add    $0x8,%eax
  800fb1:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800fb4:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800fb7:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  800fbc:	e9 c9 00 00 00       	jmp    80108a <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800fc1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800fc4:	83 f8 2f             	cmp    $0x2f,%eax
  800fc7:	77 19                	ja     800fe2 <vprintfmt+0x51d>
  800fc9:	89 c2                	mov    %eax,%edx
  800fcb:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800fcf:	83 c0 08             	add    $0x8,%eax
  800fd2:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800fd5:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800fd8:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800fdd:	e9 a8 00 00 00       	jmp    80108a <vprintfmt+0x5c5>
  800fe2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800fe6:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800fea:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800fee:	eb e5                	jmp    800fd5 <vprintfmt+0x510>
        return va_arg(*ap, unsigned int);
  800ff0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ff3:	83 f8 2f             	cmp    $0x2f,%eax
  800ff6:	77 15                	ja     80100d <vprintfmt+0x548>
  800ff8:	89 c2                	mov    %eax,%edx
  800ffa:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800ffe:	83 c0 08             	add    $0x8,%eax
  801001:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801004:	8b 12                	mov    (%rdx),%edx
            base = 8;
  801006:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  80100b:	eb 7d                	jmp    80108a <vprintfmt+0x5c5>
  80100d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801011:	48 8d 42 08          	lea    0x8(%rdx),%rax
  801015:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801019:	eb e9                	jmp    801004 <vprintfmt+0x53f>
        return va_arg(*ap, unsigned long);
  80101b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80101e:	83 f8 2f             	cmp    $0x2f,%eax
  801021:	77 16                	ja     801039 <vprintfmt+0x574>
  801023:	89 c2                	mov    %eax,%edx
  801025:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  801029:	83 c0 08             	add    $0x8,%eax
  80102c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80102f:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  801032:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  801037:	eb 51                	jmp    80108a <vprintfmt+0x5c5>
  801039:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80103d:	48 8d 42 08          	lea    0x8(%rdx),%rax
  801041:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801045:	eb e8                	jmp    80102f <vprintfmt+0x56a>
        return va_arg(*ap, unsigned long long);
  801047:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80104b:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80104f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801053:	e9 5c ff ff ff       	jmp    800fb4 <vprintfmt+0x4ef>
            putch('0', put_arg);
  801058:	4c 89 ee             	mov    %r13,%rsi
  80105b:	bf 30 00 00 00       	mov    $0x30,%edi
  801060:	41 ff d6             	call   *%r14
            putch('x', put_arg);
  801063:	4c 89 ee             	mov    %r13,%rsi
  801066:	bf 78 00 00 00       	mov    $0x78,%edi
  80106b:	41 ff d6             	call   *%r14
            num = (uintptr_t)va_arg(aq, void *);
  80106e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801071:	83 f8 2f             	cmp    $0x2f,%eax
  801074:	77 47                	ja     8010bd <vprintfmt+0x5f8>
  801076:	89 c2                	mov    %eax,%edx
  801078:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80107c:	83 c0 08             	add    $0x8,%eax
  80107f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801082:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  801085:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  80108a:	48 83 ec 08          	sub    $0x8,%rsp
  80108e:	80 7d a0 58          	cmpb   $0x58,-0x60(%rbp)
  801092:	0f 94 c0             	sete   %al
  801095:	0f b6 c0             	movzbl %al,%eax
  801098:	50                   	push   %rax
  801099:	44 0f be 4d aa       	movsbl -0x56(%rbp),%r9d
  80109e:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  8010a2:	4c 89 ee             	mov    %r13,%rsi
  8010a5:	4c 89 f7             	mov    %r14,%rdi
  8010a8:	48 b8 ae 09 80 00 00 	movabs $0x8009ae,%rax
  8010af:	00 00 00 
  8010b2:	ff d0                	call   *%rax
            break;
  8010b4:	48 83 c4 10          	add    $0x10,%rsp
  8010b8:	e9 3d fa ff ff       	jmp    800afa <vprintfmt+0x35>
            num = (uintptr_t)va_arg(aq, void *);
  8010bd:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8010c1:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8010c5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8010c9:	eb b7                	jmp    801082 <vprintfmt+0x5bd>
    if (zflag) return va_arg(*ap, size_t);
  8010cb:	40 84 f6             	test   %sil,%sil
  8010ce:	75 2b                	jne    8010fb <vprintfmt+0x636>
    switch (lflag) {
  8010d0:	85 d2                	test   %edx,%edx
  8010d2:	74 56                	je     80112a <vprintfmt+0x665>
  8010d4:	83 fa 01             	cmp    $0x1,%edx
  8010d7:	74 7f                	je     801158 <vprintfmt+0x693>
        return va_arg(*ap, unsigned long long);
  8010d9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8010dc:	83 f8 2f             	cmp    $0x2f,%eax
  8010df:	0f 87 a2 00 00 00    	ja     801187 <vprintfmt+0x6c2>
  8010e5:	89 c2                	mov    %eax,%edx
  8010e7:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8010eb:	83 c0 08             	add    $0x8,%eax
  8010ee:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8010f1:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  8010f4:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  8010f9:	eb 8f                	jmp    80108a <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8010fb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8010fe:	83 f8 2f             	cmp    $0x2f,%eax
  801101:	77 19                	ja     80111c <vprintfmt+0x657>
  801103:	89 c2                	mov    %eax,%edx
  801105:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  801109:	83 c0 08             	add    $0x8,%eax
  80110c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80110f:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  801112:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  801117:	e9 6e ff ff ff       	jmp    80108a <vprintfmt+0x5c5>
  80111c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801120:	48 8d 42 08          	lea    0x8(%rdx),%rax
  801124:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801128:	eb e5                	jmp    80110f <vprintfmt+0x64a>
        return va_arg(*ap, unsigned int);
  80112a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80112d:	83 f8 2f             	cmp    $0x2f,%eax
  801130:	77 18                	ja     80114a <vprintfmt+0x685>
  801132:	89 c2                	mov    %eax,%edx
  801134:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  801138:	83 c0 08             	add    $0x8,%eax
  80113b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80113e:	8b 12                	mov    (%rdx),%edx
            base = 16;
  801140:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  801145:	e9 40 ff ff ff       	jmp    80108a <vprintfmt+0x5c5>
  80114a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80114e:	48 8d 42 08          	lea    0x8(%rdx),%rax
  801152:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801156:	eb e6                	jmp    80113e <vprintfmt+0x679>
        return va_arg(*ap, unsigned long);
  801158:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80115b:	83 f8 2f             	cmp    $0x2f,%eax
  80115e:	77 19                	ja     801179 <vprintfmt+0x6b4>
  801160:	89 c2                	mov    %eax,%edx
  801162:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  801166:	83 c0 08             	add    $0x8,%eax
  801169:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80116c:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  80116f:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  801174:	e9 11 ff ff ff       	jmp    80108a <vprintfmt+0x5c5>
  801179:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80117d:	48 8d 42 08          	lea    0x8(%rdx),%rax
  801181:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801185:	eb e5                	jmp    80116c <vprintfmt+0x6a7>
        return va_arg(*ap, unsigned long long);
  801187:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80118b:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80118f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801193:	e9 59 ff ff ff       	jmp    8010f1 <vprintfmt+0x62c>
            putch(ch, put_arg);
  801198:	4c 89 ee             	mov    %r13,%rsi
  80119b:	bf 25 00 00 00       	mov    $0x25,%edi
  8011a0:	41 ff d6             	call   *%r14
            break;
  8011a3:	e9 52 f9 ff ff       	jmp    800afa <vprintfmt+0x35>
            putch('%', put_arg);
  8011a8:	4c 89 ee             	mov    %r13,%rsi
  8011ab:	bf 25 00 00 00       	mov    $0x25,%edi
  8011b0:	41 ff d6             	call   *%r14
            while ((--ufmt)[-1] != '%') /* nothing */
  8011b3:	48 83 eb 01          	sub    $0x1,%rbx
  8011b7:	80 7b ff 25          	cmpb   $0x25,-0x1(%rbx)
  8011bb:	75 f6                	jne    8011b3 <vprintfmt+0x6ee>
  8011bd:	e9 38 f9 ff ff       	jmp    800afa <vprintfmt+0x35>
}
  8011c2:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  8011c6:	5b                   	pop    %rbx
  8011c7:	41 5c                	pop    %r12
  8011c9:	41 5d                	pop    %r13
  8011cb:	41 5e                	pop    %r14
  8011cd:	41 5f                	pop    %r15
  8011cf:	5d                   	pop    %rbp
  8011d0:	c3                   	ret

00000000008011d1 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  8011d1:	f3 0f 1e fa          	endbr64
  8011d5:	55                   	push   %rbp
  8011d6:	48 89 e5             	mov    %rsp,%rbp
  8011d9:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  8011dd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011e1:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  8011e6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  8011ea:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  8011f1:	48 85 ff             	test   %rdi,%rdi
  8011f4:	74 2b                	je     801221 <vsnprintf+0x50>
  8011f6:	48 85 f6             	test   %rsi,%rsi
  8011f9:	74 26                	je     801221 <vsnprintf+0x50>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  8011fb:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  8011ff:	48 bf 68 0a 80 00 00 	movabs $0x800a68,%rdi
  801206:	00 00 00 
  801209:	48 b8 c5 0a 80 00 00 	movabs $0x800ac5,%rax
  801210:	00 00 00 
  801213:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  801215:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801219:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  80121c:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80121f:	c9                   	leave
  801220:	c3                   	ret
    if (!buf || n < 1) return -E_INVAL;
  801221:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801226:	eb f7                	jmp    80121f <vsnprintf+0x4e>

0000000000801228 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  801228:	f3 0f 1e fa          	endbr64
  80122c:	55                   	push   %rbp
  80122d:	48 89 e5             	mov    %rsp,%rbp
  801230:	48 83 ec 50          	sub    $0x50,%rsp
  801234:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801238:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  80123c:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  801240:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  801247:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80124b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80124f:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801253:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  801257:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  80125b:	48 b8 d1 11 80 00 00 	movabs $0x8011d1,%rax
  801262:	00 00 00 
  801265:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  801267:	c9                   	leave
  801268:	c3                   	ret

0000000000801269 <strlen>:
 * Primespipe runs 3x faster this way */

#define ASM 1

size_t
strlen(const char *s) {
  801269:	f3 0f 1e fa          	endbr64
    size_t n = 0;
    while (*s++) n++;
  80126d:	80 3f 00             	cmpb   $0x0,(%rdi)
  801270:	74 10                	je     801282 <strlen+0x19>
    size_t n = 0;
  801272:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  801277:	48 83 c0 01          	add    $0x1,%rax
  80127b:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  80127f:	75 f6                	jne    801277 <strlen+0xe>
  801281:	c3                   	ret
    size_t n = 0;
  801282:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  801287:	c3                   	ret

0000000000801288 <strnlen>:

size_t
strnlen(const char *s, size_t size) {
  801288:	f3 0f 1e fa          	endbr64
  80128c:	48 89 f0             	mov    %rsi,%rax
    size_t n = 0;
  80128f:	ba 00 00 00 00       	mov    $0x0,%edx
    while (n < size && *s++) n++;
  801294:	48 85 f6             	test   %rsi,%rsi
  801297:	74 10                	je     8012a9 <strnlen+0x21>
  801299:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  80129d:	74 0b                	je     8012aa <strnlen+0x22>
  80129f:	48 83 c2 01          	add    $0x1,%rdx
  8012a3:	48 39 d0             	cmp    %rdx,%rax
  8012a6:	75 f1                	jne    801299 <strnlen+0x11>
  8012a8:	c3                   	ret
  8012a9:	c3                   	ret
  8012aa:	48 89 d0             	mov    %rdx,%rax
    return n;
}
  8012ad:	c3                   	ret

00000000008012ae <strcpy>:

char *
strcpy(char *dst, const char *src) {
  8012ae:	f3 0f 1e fa          	endbr64
  8012b2:	48 89 f8             	mov    %rdi,%rax
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  8012b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8012ba:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  8012be:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  8012c1:	48 83 c2 01          	add    $0x1,%rdx
  8012c5:	84 c9                	test   %cl,%cl
  8012c7:	75 f1                	jne    8012ba <strcpy+0xc>
        ;
    return res;
}
  8012c9:	c3                   	ret

00000000008012ca <strcat>:

char *
strcat(char *dst, const char *src) {
  8012ca:	f3 0f 1e fa          	endbr64
  8012ce:	55                   	push   %rbp
  8012cf:	48 89 e5             	mov    %rsp,%rbp
  8012d2:	41 54                	push   %r12
  8012d4:	53                   	push   %rbx
  8012d5:	48 89 fb             	mov    %rdi,%rbx
  8012d8:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  8012db:	48 b8 69 12 80 00 00 	movabs $0x801269,%rax
  8012e2:	00 00 00 
  8012e5:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  8012e7:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  8012eb:	4c 89 e6             	mov    %r12,%rsi
  8012ee:	48 b8 ae 12 80 00 00 	movabs $0x8012ae,%rax
  8012f5:	00 00 00 
  8012f8:	ff d0                	call   *%rax
    return dst;
}
  8012fa:	48 89 d8             	mov    %rbx,%rax
  8012fd:	5b                   	pop    %rbx
  8012fe:	41 5c                	pop    %r12
  801300:	5d                   	pop    %rbp
  801301:	c3                   	ret

0000000000801302 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801302:	f3 0f 1e fa          	endbr64
  801306:	48 89 f8             	mov    %rdi,%rax
    char *ret = dst;
    while (size-- > 0) {
  801309:	48 85 d2             	test   %rdx,%rdx
  80130c:	74 1f                	je     80132d <strncpy+0x2b>
  80130e:	48 01 fa             	add    %rdi,%rdx
  801311:	48 89 f9             	mov    %rdi,%rcx
        *dst++ = *src;
  801314:	48 83 c1 01          	add    $0x1,%rcx
  801318:	44 0f b6 06          	movzbl (%rsi),%r8d
  80131c:	44 88 41 ff          	mov    %r8b,-0x1(%rcx)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  801320:	41 80 f8 01          	cmp    $0x1,%r8b
  801324:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  801328:	48 39 ca             	cmp    %rcx,%rdx
  80132b:	75 e7                	jne    801314 <strncpy+0x12>
    }
    return ret;
}
  80132d:	c3                   	ret

000000000080132e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
  80132e:	f3 0f 1e fa          	endbr64
    char *dst_in = dst;
    if (size) {
  801332:	48 89 f8             	mov    %rdi,%rax
  801335:	48 85 d2             	test   %rdx,%rdx
  801338:	74 24                	je     80135e <strlcpy+0x30>
        while (--size > 0 && *src)
  80133a:	48 83 ea 01          	sub    $0x1,%rdx
  80133e:	74 1b                	je     80135b <strlcpy+0x2d>
  801340:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  801344:	0f b6 16             	movzbl (%rsi),%edx
  801347:	84 d2                	test   %dl,%dl
  801349:	74 10                	je     80135b <strlcpy+0x2d>
            *dst++ = *src++;
  80134b:	48 83 c6 01          	add    $0x1,%rsi
  80134f:	48 83 c0 01          	add    $0x1,%rax
  801353:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  801356:	48 39 c8             	cmp    %rcx,%rax
  801359:	75 e9                	jne    801344 <strlcpy+0x16>
        *dst = '\0';
  80135b:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  80135e:	48 29 f8             	sub    %rdi,%rax
}
  801361:	c3                   	ret

0000000000801362 <strcmp>:
    }
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
  801362:	f3 0f 1e fa          	endbr64
    while (*p && *p == *q) p++, q++;
  801366:	0f b6 07             	movzbl (%rdi),%eax
  801369:	84 c0                	test   %al,%al
  80136b:	74 13                	je     801380 <strcmp+0x1e>
  80136d:	38 06                	cmp    %al,(%rsi)
  80136f:	75 0f                	jne    801380 <strcmp+0x1e>
  801371:	48 83 c7 01          	add    $0x1,%rdi
  801375:	48 83 c6 01          	add    $0x1,%rsi
  801379:	0f b6 07             	movzbl (%rdi),%eax
  80137c:	84 c0                	test   %al,%al
  80137e:	75 ed                	jne    80136d <strcmp+0xb>
    return (int)((unsigned char)*p - (unsigned char)*q);
  801380:	0f b6 c0             	movzbl %al,%eax
  801383:	0f b6 16             	movzbl (%rsi),%edx
  801386:	29 d0                	sub    %edx,%eax
}
  801388:	c3                   	ret

0000000000801389 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
  801389:	f3 0f 1e fa          	endbr64
    while (n && *p && *p == *q) n--, p++, q++;
  80138d:	48 85 d2             	test   %rdx,%rdx
  801390:	74 1f                	je     8013b1 <strncmp+0x28>
  801392:	0f b6 07             	movzbl (%rdi),%eax
  801395:	84 c0                	test   %al,%al
  801397:	74 1e                	je     8013b7 <strncmp+0x2e>
  801399:	3a 06                	cmp    (%rsi),%al
  80139b:	75 1a                	jne    8013b7 <strncmp+0x2e>
  80139d:	48 83 c7 01          	add    $0x1,%rdi
  8013a1:	48 83 c6 01          	add    $0x1,%rsi
  8013a5:	48 83 ea 01          	sub    $0x1,%rdx
  8013a9:	75 e7                	jne    801392 <strncmp+0x9>

    if (!n) return 0;
  8013ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8013b0:	c3                   	ret
  8013b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8013b6:	c3                   	ret

    return (int)((unsigned char)*p - (unsigned char)*q);
  8013b7:	0f b6 07             	movzbl (%rdi),%eax
  8013ba:	0f b6 16             	movzbl (%rsi),%edx
  8013bd:	29 d0                	sub    %edx,%eax
}
  8013bf:	c3                   	ret

00000000008013c0 <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
  8013c0:	f3 0f 1e fa          	endbr64
    for (; *str; str++) {
  8013c4:	0f b6 17             	movzbl (%rdi),%edx
  8013c7:	84 d2                	test   %dl,%dl
  8013c9:	74 18                	je     8013e3 <strchr+0x23>
        if (*str == c) {
  8013cb:	0f be d2             	movsbl %dl,%edx
  8013ce:	39 f2                	cmp    %esi,%edx
  8013d0:	74 17                	je     8013e9 <strchr+0x29>
    for (; *str; str++) {
  8013d2:	48 83 c7 01          	add    $0x1,%rdi
  8013d6:	0f b6 17             	movzbl (%rdi),%edx
  8013d9:	84 d2                	test   %dl,%dl
  8013db:	75 ee                	jne    8013cb <strchr+0xb>
            return (char *)str;
        }
    }
    return NULL;
  8013dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8013e2:	c3                   	ret
  8013e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8013e8:	c3                   	ret
            return (char *)str;
  8013e9:	48 89 f8             	mov    %rdi,%rax
}
  8013ec:	c3                   	ret

00000000008013ed <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
  8013ed:	f3 0f 1e fa          	endbr64
  8013f1:	48 89 f8             	mov    %rdi,%rax
    for (; *str && *str != ch; str++) /* nothing */
  8013f4:	0f b6 17             	movzbl (%rdi),%edx
  8013f7:	84 d2                	test   %dl,%dl
  8013f9:	74 13                	je     80140e <strfind+0x21>
  8013fb:	0f be d2             	movsbl %dl,%edx
  8013fe:	39 f2                	cmp    %esi,%edx
  801400:	74 0b                	je     80140d <strfind+0x20>
  801402:	48 83 c0 01          	add    $0x1,%rax
  801406:	0f b6 10             	movzbl (%rax),%edx
  801409:	84 d2                	test   %dl,%dl
  80140b:	75 ee                	jne    8013fb <strfind+0xe>
        ;
    return (char *)str;
}
  80140d:	c3                   	ret
  80140e:	c3                   	ret

000000000080140f <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  80140f:	f3 0f 1e fa          	endbr64
  801413:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  801416:	48 89 f8             	mov    %rdi,%rax
  801419:	48 f7 d8             	neg    %rax
  80141c:	83 e0 07             	and    $0x7,%eax
  80141f:	49 89 d1             	mov    %rdx,%r9
  801422:	49 29 c1             	sub    %rax,%r9
  801425:	78 36                	js     80145d <memset+0x4e>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  801427:	40 0f b6 c6          	movzbl %sil,%eax
  80142b:	48 b9 01 01 01 01 01 	movabs $0x101010101010101,%rcx
  801432:	01 01 01 
  801435:	48 0f af c1          	imul   %rcx,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  801439:	40 f6 c7 07          	test   $0x7,%dil
  80143d:	75 38                	jne    801477 <memset+0x68>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  80143f:	4c 89 c9             	mov    %r9,%rcx
  801442:	48 c1 f9 03          	sar    $0x3,%rcx
  801446:	74 0c                	je     801454 <memset+0x45>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  801448:	fc                   	cld
  801449:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  80144c:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  801450:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  801454:	4d 85 c9             	test   %r9,%r9
  801457:	75 45                	jne    80149e <memset+0x8f>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  801459:	4c 89 c0             	mov    %r8,%rax
  80145c:	c3                   	ret
        while (n-- > 0) *ptr++ = c;
  80145d:	48 85 d2             	test   %rdx,%rdx
  801460:	74 f7                	je     801459 <memset+0x4a>
  801462:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  801465:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  801468:	48 83 c0 01          	add    $0x1,%rax
  80146c:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  801470:	48 39 c2             	cmp    %rax,%rdx
  801473:	75 f3                	jne    801468 <memset+0x59>
  801475:	eb e2                	jmp    801459 <memset+0x4a>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  801477:	40 f6 c7 01          	test   $0x1,%dil
  80147b:	74 06                	je     801483 <memset+0x74>
  80147d:	88 07                	mov    %al,(%rdi)
  80147f:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  801483:	40 f6 c7 02          	test   $0x2,%dil
  801487:	74 07                	je     801490 <memset+0x81>
  801489:	66 89 07             	mov    %ax,(%rdi)
  80148c:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  801490:	40 f6 c7 04          	test   $0x4,%dil
  801494:	74 a9                	je     80143f <memset+0x30>
  801496:	89 07                	mov    %eax,(%rdi)
  801498:	48 83 c7 04          	add    $0x4,%rdi
  80149c:	eb a1                	jmp    80143f <memset+0x30>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  80149e:	41 f6 c1 04          	test   $0x4,%r9b
  8014a2:	74 1b                	je     8014bf <memset+0xb0>
  8014a4:	89 07                	mov    %eax,(%rdi)
  8014a6:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  8014aa:	41 f6 c1 02          	test   $0x2,%r9b
  8014ae:	74 07                	je     8014b7 <memset+0xa8>
  8014b0:	66 89 07             	mov    %ax,(%rdi)
  8014b3:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  8014b7:	41 f6 c1 01          	test   $0x1,%r9b
  8014bb:	74 9c                	je     801459 <memset+0x4a>
  8014bd:	eb 06                	jmp    8014c5 <memset+0xb6>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  8014bf:	41 f6 c1 02          	test   $0x2,%r9b
  8014c3:	75 eb                	jne    8014b0 <memset+0xa1>
        if (ni & 1) *ptr = k;
  8014c5:	88 07                	mov    %al,(%rdi)
  8014c7:	eb 90                	jmp    801459 <memset+0x4a>

00000000008014c9 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  8014c9:	f3 0f 1e fa          	endbr64
  8014cd:	48 89 f8             	mov    %rdi,%rax
  8014d0:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  8014d3:	48 39 fe             	cmp    %rdi,%rsi
  8014d6:	73 3b                	jae    801513 <memmove+0x4a>
  8014d8:	48 8d 14 16          	lea    (%rsi,%rdx,1),%rdx
  8014dc:	48 39 d7             	cmp    %rdx,%rdi
  8014df:	73 32                	jae    801513 <memmove+0x4a>
        s += n;
        d += n;
  8014e1:	48 8d 3c 0f          	lea    (%rdi,%rcx,1),%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  8014e5:	48 89 d6             	mov    %rdx,%rsi
  8014e8:	48 09 fe             	or     %rdi,%rsi
  8014eb:	48 09 ce             	or     %rcx,%rsi
  8014ee:	40 f6 c6 07          	test   $0x7,%sil
  8014f2:	75 12                	jne    801506 <memmove+0x3d>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  8014f4:	48 83 ef 08          	sub    $0x8,%rdi
  8014f8:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  8014fc:	48 c1 e9 03          	shr    $0x3,%rcx
  801500:	fd                   	std
  801501:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  801504:	fc                   	cld
  801505:	c3                   	ret
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  801506:	48 83 ef 01          	sub    $0x1,%rdi
  80150a:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  80150e:	fd                   	std
  80150f:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  801511:	eb f1                	jmp    801504 <memmove+0x3b>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  801513:	48 89 f2             	mov    %rsi,%rdx
  801516:	48 09 c2             	or     %rax,%rdx
  801519:	48 09 ca             	or     %rcx,%rdx
  80151c:	f6 c2 07             	test   $0x7,%dl
  80151f:	75 0c                	jne    80152d <memmove+0x64>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  801521:	48 c1 e9 03          	shr    $0x3,%rcx
  801525:	48 89 c7             	mov    %rax,%rdi
  801528:	fc                   	cld
  801529:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  80152c:	c3                   	ret
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  80152d:	48 89 c7             	mov    %rax,%rdi
  801530:	fc                   	cld
  801531:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  801533:	c3                   	ret

0000000000801534 <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  801534:	f3 0f 1e fa          	endbr64
  801538:	55                   	push   %rbp
  801539:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  80153c:	48 b8 c9 14 80 00 00 	movabs $0x8014c9,%rax
  801543:	00 00 00 
  801546:	ff d0                	call   *%rax
}
  801548:	5d                   	pop    %rbp
  801549:	c3                   	ret

000000000080154a <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  80154a:	f3 0f 1e fa          	endbr64
  80154e:	55                   	push   %rbp
  80154f:	48 89 e5             	mov    %rsp,%rbp
  801552:	41 57                	push   %r15
  801554:	41 56                	push   %r14
  801556:	41 55                	push   %r13
  801558:	41 54                	push   %r12
  80155a:	53                   	push   %rbx
  80155b:	48 83 ec 08          	sub    $0x8,%rsp
  80155f:	49 89 fe             	mov    %rdi,%r14
  801562:	49 89 f7             	mov    %rsi,%r15
  801565:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  801568:	48 89 f7             	mov    %rsi,%rdi
  80156b:	48 b8 69 12 80 00 00 	movabs $0x801269,%rax
  801572:	00 00 00 
  801575:	ff d0                	call   *%rax
  801577:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  80157a:	48 89 de             	mov    %rbx,%rsi
  80157d:	4c 89 f7             	mov    %r14,%rdi
  801580:	48 b8 88 12 80 00 00 	movabs $0x801288,%rax
  801587:	00 00 00 
  80158a:	ff d0                	call   *%rax
  80158c:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  80158f:	48 39 c3             	cmp    %rax,%rbx
  801592:	74 36                	je     8015ca <strlcat+0x80>
    if (srclen < maxlen - dstlen) {
  801594:	48 89 d8             	mov    %rbx,%rax
  801597:	4c 29 e8             	sub    %r13,%rax
  80159a:	49 39 c4             	cmp    %rax,%r12
  80159d:	73 31                	jae    8015d0 <strlcat+0x86>
        memcpy(dst + dstlen, src, srclen + 1);
  80159f:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  8015a4:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  8015a8:	4c 89 fe             	mov    %r15,%rsi
  8015ab:	48 b8 34 15 80 00 00 	movabs $0x801534,%rax
  8015b2:	00 00 00 
  8015b5:	ff d0                	call   *%rax
    return dstlen + srclen;
  8015b7:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  8015bb:	48 83 c4 08          	add    $0x8,%rsp
  8015bf:	5b                   	pop    %rbx
  8015c0:	41 5c                	pop    %r12
  8015c2:	41 5d                	pop    %r13
  8015c4:	41 5e                	pop    %r14
  8015c6:	41 5f                	pop    %r15
  8015c8:	5d                   	pop    %rbp
  8015c9:	c3                   	ret
    if (dstlen == maxlen) return maxlen + srclen;
  8015ca:	49 8d 04 04          	lea    (%r12,%rax,1),%rax
  8015ce:	eb eb                	jmp    8015bb <strlcat+0x71>
        memcpy(dst + dstlen, src, maxlen - 1);
  8015d0:	48 83 eb 01          	sub    $0x1,%rbx
  8015d4:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  8015d8:	48 89 da             	mov    %rbx,%rdx
  8015db:	4c 89 fe             	mov    %r15,%rsi
  8015de:	48 b8 34 15 80 00 00 	movabs $0x801534,%rax
  8015e5:	00 00 00 
  8015e8:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  8015ea:	49 01 de             	add    %rbx,%r14
  8015ed:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  8015f2:	eb c3                	jmp    8015b7 <strlcat+0x6d>

00000000008015f4 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  8015f4:	f3 0f 1e fa          	endbr64
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  8015f8:	48 85 d2             	test   %rdx,%rdx
  8015fb:	74 2d                	je     80162a <memcmp+0x36>
  8015fd:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  801602:	0f b6 0c 07          	movzbl (%rdi,%rax,1),%ecx
  801606:	44 0f b6 04 06       	movzbl (%rsi,%rax,1),%r8d
  80160b:	44 38 c1             	cmp    %r8b,%cl
  80160e:	75 0f                	jne    80161f <memcmp+0x2b>
    while (n-- > 0) {
  801610:	48 83 c0 01          	add    $0x1,%rax
  801614:	48 39 c2             	cmp    %rax,%rdx
  801617:	75 e9                	jne    801602 <memcmp+0xe>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  801619:	b8 00 00 00 00       	mov    $0x0,%eax
  80161e:	c3                   	ret
            return (int)*s1 - (int)*s2;
  80161f:	0f b6 c1             	movzbl %cl,%eax
  801622:	45 0f b6 c0          	movzbl %r8b,%r8d
  801626:	44 29 c0             	sub    %r8d,%eax
  801629:	c3                   	ret
    return 0;
  80162a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80162f:	c3                   	ret

0000000000801630 <memfind>:

void *
memfind(const void *src, int c, size_t n) {
  801630:	f3 0f 1e fa          	endbr64
    const void *end = (const char *)src + n;
  801634:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  801638:	48 39 c7             	cmp    %rax,%rdi
  80163b:	73 0f                	jae    80164c <memfind+0x1c>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  80163d:	40 38 37             	cmp    %sil,(%rdi)
  801640:	74 0e                	je     801650 <memfind+0x20>
    for (; src < end; src++) {
  801642:	48 83 c7 01          	add    $0x1,%rdi
  801646:	48 39 f8             	cmp    %rdi,%rax
  801649:	75 f2                	jne    80163d <memfind+0xd>
  80164b:	c3                   	ret
  80164c:	48 89 f8             	mov    %rdi,%rax
  80164f:	c3                   	ret
  801650:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  801653:	c3                   	ret

0000000000801654 <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  801654:	f3 0f 1e fa          	endbr64
  801658:	49 89 f2             	mov    %rsi,%r10
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  80165b:	0f b6 37             	movzbl (%rdi),%esi
  80165e:	40 80 fe 20          	cmp    $0x20,%sil
  801662:	74 06                	je     80166a <strtol+0x16>
  801664:	40 80 fe 09          	cmp    $0x9,%sil
  801668:	75 13                	jne    80167d <strtol+0x29>
  80166a:	48 83 c7 01          	add    $0x1,%rdi
  80166e:	0f b6 37             	movzbl (%rdi),%esi
  801671:	40 80 fe 20          	cmp    $0x20,%sil
  801675:	74 f3                	je     80166a <strtol+0x16>
  801677:	40 80 fe 09          	cmp    $0x9,%sil
  80167b:	74 ed                	je     80166a <strtol+0x16>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  80167d:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  801680:	83 e0 fd             	and    $0xfffffffd,%eax
  801683:	3c 01                	cmp    $0x1,%al
  801685:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  801689:	f7 c2 ef ff ff ff    	test   $0xffffffef,%edx
  80168f:	75 0f                	jne    8016a0 <strtol+0x4c>
  801691:	80 3f 30             	cmpb   $0x30,(%rdi)
  801694:	74 14                	je     8016aa <strtol+0x56>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  801696:	85 d2                	test   %edx,%edx
  801698:	b8 0a 00 00 00       	mov    $0xa,%eax
  80169d:	0f 44 d0             	cmove  %eax,%edx
    }

    /* Digits */
    long val = 0;
  8016a0:	b8 00 00 00 00       	mov    $0x0,%eax
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  8016a5:	4c 63 ca             	movslq %edx,%r9
  8016a8:	eb 36                	jmp    8016e0 <strtol+0x8c>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  8016aa:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  8016ae:	74 0f                	je     8016bf <strtol+0x6b>
    } else if (!base && s[0] == '0') {
  8016b0:	85 d2                	test   %edx,%edx
  8016b2:	75 ec                	jne    8016a0 <strtol+0x4c>
        s++;
  8016b4:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  8016b8:	ba 08 00 00 00       	mov    $0x8,%edx
        s++;
  8016bd:	eb e1                	jmp    8016a0 <strtol+0x4c>
        s += 2;
  8016bf:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  8016c3:	ba 10 00 00 00       	mov    $0x10,%edx
        s += 2;
  8016c8:	eb d6                	jmp    8016a0 <strtol+0x4c>
            dig -= '0';
  8016ca:	83 e9 30             	sub    $0x30,%ecx
        if (dig >= base) break;
  8016cd:	44 0f b6 c1          	movzbl %cl,%r8d
  8016d1:	41 39 d0             	cmp    %edx,%r8d
  8016d4:	7d 21                	jge    8016f7 <strtol+0xa3>
        val = val * base + dig;
  8016d6:	49 0f af c1          	imul   %r9,%rax
  8016da:	0f b6 c9             	movzbl %cl,%ecx
  8016dd:	48 01 c8             	add    %rcx,%rax
        uint8_t dig = *s++;
  8016e0:	48 83 c7 01          	add    $0x1,%rdi
  8016e4:	0f b6 4f ff          	movzbl -0x1(%rdi),%ecx
        if (dig - '0' < 10)
  8016e8:	80 f9 39             	cmp    $0x39,%cl
  8016eb:	76 dd                	jbe    8016ca <strtol+0x76>
        else if (dig - 'a' < 27)
  8016ed:	80 f9 7b             	cmp    $0x7b,%cl
  8016f0:	77 05                	ja     8016f7 <strtol+0xa3>
            dig -= 'a' - 10;
  8016f2:	83 e9 57             	sub    $0x57,%ecx
  8016f5:	eb d6                	jmp    8016cd <strtol+0x79>
    }

    if (endptr) *endptr = (char *)s;
  8016f7:	4d 85 d2             	test   %r10,%r10
  8016fa:	74 03                	je     8016ff <strtol+0xab>
  8016fc:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  8016ff:	48 89 c2             	mov    %rax,%rdx
  801702:	48 f7 da             	neg    %rdx
  801705:	40 80 fe 2d          	cmp    $0x2d,%sil
  801709:	48 0f 44 c2          	cmove  %rdx,%rax
}
  80170d:	c3                   	ret

000000000080170e <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  80170e:	f3 0f 1e fa          	endbr64
  801712:	55                   	push   %rbp
  801713:	48 89 e5             	mov    %rsp,%rbp
  801716:	53                   	push   %rbx
  801717:	48 89 fa             	mov    %rdi,%rdx
  80171a:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80171d:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801722:	bb 00 00 00 00       	mov    $0x0,%ebx
  801727:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80172c:	be 00 00 00 00       	mov    $0x0,%esi
  801731:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801737:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  801739:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80173d:	c9                   	leave
  80173e:	c3                   	ret

000000000080173f <sys_cgetc>:

int
sys_cgetc(void) {
  80173f:	f3 0f 1e fa          	endbr64
  801743:	55                   	push   %rbp
  801744:	48 89 e5             	mov    %rsp,%rbp
  801747:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801748:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80174d:	ba 00 00 00 00       	mov    $0x0,%edx
  801752:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801757:	bb 00 00 00 00       	mov    $0x0,%ebx
  80175c:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801761:	be 00 00 00 00       	mov    $0x0,%esi
  801766:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80176c:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  80176e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801772:	c9                   	leave
  801773:	c3                   	ret

0000000000801774 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  801774:	f3 0f 1e fa          	endbr64
  801778:	55                   	push   %rbp
  801779:	48 89 e5             	mov    %rsp,%rbp
  80177c:	53                   	push   %rbx
  80177d:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  801781:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801784:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801789:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80178e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801793:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801798:	be 00 00 00 00       	mov    $0x0,%esi
  80179d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8017a3:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8017a5:	48 85 c0             	test   %rax,%rax
  8017a8:	7f 06                	jg     8017b0 <sys_env_destroy+0x3c>
}
  8017aa:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8017ae:	c9                   	leave
  8017af:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8017b0:	49 89 c0             	mov    %rax,%r8
  8017b3:	b9 03 00 00 00       	mov    $0x3,%ecx
  8017b8:	48 ba c0 40 80 00 00 	movabs $0x8040c0,%rdx
  8017bf:	00 00 00 
  8017c2:	be 26 00 00 00       	mov    $0x26,%esi
  8017c7:	48 bf 59 44 80 00 00 	movabs $0x804459,%rdi
  8017ce:	00 00 00 
  8017d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8017d6:	49 b9 09 08 80 00 00 	movabs $0x800809,%r9
  8017dd:	00 00 00 
  8017e0:	41 ff d1             	call   *%r9

00000000008017e3 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  8017e3:	f3 0f 1e fa          	endbr64
  8017e7:	55                   	push   %rbp
  8017e8:	48 89 e5             	mov    %rsp,%rbp
  8017eb:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8017ec:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8017f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8017f6:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8017fb:	bb 00 00 00 00       	mov    $0x0,%ebx
  801800:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801805:	be 00 00 00 00       	mov    $0x0,%esi
  80180a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801810:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  801812:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801816:	c9                   	leave
  801817:	c3                   	ret

0000000000801818 <sys_yield>:

void
sys_yield(void) {
  801818:	f3 0f 1e fa          	endbr64
  80181c:	55                   	push   %rbp
  80181d:	48 89 e5             	mov    %rsp,%rbp
  801820:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801821:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801826:	ba 00 00 00 00       	mov    $0x0,%edx
  80182b:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801830:	bb 00 00 00 00       	mov    $0x0,%ebx
  801835:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80183a:	be 00 00 00 00       	mov    $0x0,%esi
  80183f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801845:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  801847:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80184b:	c9                   	leave
  80184c:	c3                   	ret

000000000080184d <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  80184d:	f3 0f 1e fa          	endbr64
  801851:	55                   	push   %rbp
  801852:	48 89 e5             	mov    %rsp,%rbp
  801855:	53                   	push   %rbx
  801856:	48 89 fa             	mov    %rdi,%rdx
  801859:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80185c:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801861:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  801868:	00 00 00 
  80186b:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801870:	be 00 00 00 00       	mov    $0x0,%esi
  801875:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80187b:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  80187d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801881:	c9                   	leave
  801882:	c3                   	ret

0000000000801883 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  801883:	f3 0f 1e fa          	endbr64
  801887:	55                   	push   %rbp
  801888:	48 89 e5             	mov    %rsp,%rbp
  80188b:	53                   	push   %rbx
  80188c:	49 89 f8             	mov    %rdi,%r8
  80188f:	48 89 d3             	mov    %rdx,%rbx
  801892:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  801895:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80189a:	4c 89 c2             	mov    %r8,%rdx
  80189d:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8018a0:	be 00 00 00 00       	mov    $0x0,%esi
  8018a5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8018ab:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  8018ad:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8018b1:	c9                   	leave
  8018b2:	c3                   	ret

00000000008018b3 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  8018b3:	f3 0f 1e fa          	endbr64
  8018b7:	55                   	push   %rbp
  8018b8:	48 89 e5             	mov    %rsp,%rbp
  8018bb:	53                   	push   %rbx
  8018bc:	48 83 ec 08          	sub    $0x8,%rsp
  8018c0:	89 f8                	mov    %edi,%eax
  8018c2:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  8018c5:	48 63 f9             	movslq %ecx,%rdi
  8018c8:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8018cb:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8018d0:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8018d3:	be 00 00 00 00       	mov    $0x0,%esi
  8018d8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8018de:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8018e0:	48 85 c0             	test   %rax,%rax
  8018e3:	7f 06                	jg     8018eb <sys_alloc_region+0x38>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  8018e5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8018e9:	c9                   	leave
  8018ea:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8018eb:	49 89 c0             	mov    %rax,%r8
  8018ee:	b9 04 00 00 00       	mov    $0x4,%ecx
  8018f3:	48 ba c0 40 80 00 00 	movabs $0x8040c0,%rdx
  8018fa:	00 00 00 
  8018fd:	be 26 00 00 00       	mov    $0x26,%esi
  801902:	48 bf 59 44 80 00 00 	movabs $0x804459,%rdi
  801909:	00 00 00 
  80190c:	b8 00 00 00 00       	mov    $0x0,%eax
  801911:	49 b9 09 08 80 00 00 	movabs $0x800809,%r9
  801918:	00 00 00 
  80191b:	41 ff d1             	call   *%r9

000000000080191e <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  80191e:	f3 0f 1e fa          	endbr64
  801922:	55                   	push   %rbp
  801923:	48 89 e5             	mov    %rsp,%rbp
  801926:	53                   	push   %rbx
  801927:	48 83 ec 08          	sub    $0x8,%rsp
  80192b:	89 f8                	mov    %edi,%eax
  80192d:	49 89 f2             	mov    %rsi,%r10
  801930:	48 89 cf             	mov    %rcx,%rdi
  801933:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  801936:	48 63 da             	movslq %edx,%rbx
  801939:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80193c:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801941:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801944:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  801947:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801949:	48 85 c0             	test   %rax,%rax
  80194c:	7f 06                	jg     801954 <sys_map_region+0x36>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  80194e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801952:	c9                   	leave
  801953:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801954:	49 89 c0             	mov    %rax,%r8
  801957:	b9 05 00 00 00       	mov    $0x5,%ecx
  80195c:	48 ba c0 40 80 00 00 	movabs $0x8040c0,%rdx
  801963:	00 00 00 
  801966:	be 26 00 00 00       	mov    $0x26,%esi
  80196b:	48 bf 59 44 80 00 00 	movabs $0x804459,%rdi
  801972:	00 00 00 
  801975:	b8 00 00 00 00       	mov    $0x0,%eax
  80197a:	49 b9 09 08 80 00 00 	movabs $0x800809,%r9
  801981:	00 00 00 
  801984:	41 ff d1             	call   *%r9

0000000000801987 <sys_map_physical_region>:

int
sys_map_physical_region(uintptr_t pa, envid_t dstenv, void *dstva, size_t size, int perm) {
  801987:	f3 0f 1e fa          	endbr64
  80198b:	55                   	push   %rbp
  80198c:	48 89 e5             	mov    %rsp,%rbp
  80198f:	53                   	push   %rbx
  801990:	48 83 ec 08          	sub    $0x8,%rsp
  801994:	49 89 f9             	mov    %rdi,%r9
  801997:	89 f0                	mov    %esi,%eax
  801999:	48 89 d3             	mov    %rdx,%rbx
  80199c:	48 89 cf             	mov    %rcx,%rdi
    int res = syscall(SYS_map_physical_region, 1, pa, dstenv, (uintptr_t)dstva, size, perm, 0);
  80199f:	49 63 f0             	movslq %r8d,%rsi
  8019a2:	48 63 c8             	movslq %eax,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8019a5:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8019aa:	4c 89 ca             	mov    %r9,%rdx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8019ad:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8019b3:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8019b5:	48 85 c0             	test   %rax,%rax
  8019b8:	7f 06                	jg     8019c0 <sys_map_physical_region+0x39>
#ifdef SANITIZE_USER_SHADOW_BASE
    platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  8019ba:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8019be:	c9                   	leave
  8019bf:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8019c0:	49 89 c0             	mov    %rax,%r8
  8019c3:	b9 06 00 00 00       	mov    $0x6,%ecx
  8019c8:	48 ba c0 40 80 00 00 	movabs $0x8040c0,%rdx
  8019cf:	00 00 00 
  8019d2:	be 26 00 00 00       	mov    $0x26,%esi
  8019d7:	48 bf 59 44 80 00 00 	movabs $0x804459,%rdi
  8019de:	00 00 00 
  8019e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8019e6:	49 b9 09 08 80 00 00 	movabs $0x800809,%r9
  8019ed:	00 00 00 
  8019f0:	41 ff d1             	call   *%r9

00000000008019f3 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  8019f3:	f3 0f 1e fa          	endbr64
  8019f7:	55                   	push   %rbp
  8019f8:	48 89 e5             	mov    %rsp,%rbp
  8019fb:	53                   	push   %rbx
  8019fc:	48 83 ec 08          	sub    $0x8,%rsp
  801a00:	48 89 f1             	mov    %rsi,%rcx
  801a03:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  801a06:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801a09:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801a0e:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801a13:	be 00 00 00 00       	mov    $0x0,%esi
  801a18:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801a1e:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801a20:	48 85 c0             	test   %rax,%rax
  801a23:	7f 06                	jg     801a2b <sys_unmap_region+0x38>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  801a25:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801a29:	c9                   	leave
  801a2a:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801a2b:	49 89 c0             	mov    %rax,%r8
  801a2e:	b9 07 00 00 00       	mov    $0x7,%ecx
  801a33:	48 ba c0 40 80 00 00 	movabs $0x8040c0,%rdx
  801a3a:	00 00 00 
  801a3d:	be 26 00 00 00       	mov    $0x26,%esi
  801a42:	48 bf 59 44 80 00 00 	movabs $0x804459,%rdi
  801a49:	00 00 00 
  801a4c:	b8 00 00 00 00       	mov    $0x0,%eax
  801a51:	49 b9 09 08 80 00 00 	movabs $0x800809,%r9
  801a58:	00 00 00 
  801a5b:	41 ff d1             	call   *%r9

0000000000801a5e <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  801a5e:	f3 0f 1e fa          	endbr64
  801a62:	55                   	push   %rbp
  801a63:	48 89 e5             	mov    %rsp,%rbp
  801a66:	53                   	push   %rbx
  801a67:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  801a6b:	48 63 ce             	movslq %esi,%rcx
  801a6e:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801a71:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801a76:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a7b:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801a80:	be 00 00 00 00       	mov    $0x0,%esi
  801a85:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801a8b:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801a8d:	48 85 c0             	test   %rax,%rax
  801a90:	7f 06                	jg     801a98 <sys_env_set_status+0x3a>
}
  801a92:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801a96:	c9                   	leave
  801a97:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801a98:	49 89 c0             	mov    %rax,%r8
  801a9b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801aa0:	48 ba c0 40 80 00 00 	movabs $0x8040c0,%rdx
  801aa7:	00 00 00 
  801aaa:	be 26 00 00 00       	mov    $0x26,%esi
  801aaf:	48 bf 59 44 80 00 00 	movabs $0x804459,%rdi
  801ab6:	00 00 00 
  801ab9:	b8 00 00 00 00       	mov    $0x0,%eax
  801abe:	49 b9 09 08 80 00 00 	movabs $0x800809,%r9
  801ac5:	00 00 00 
  801ac8:	41 ff d1             	call   *%r9

0000000000801acb <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  801acb:	f3 0f 1e fa          	endbr64
  801acf:	55                   	push   %rbp
  801ad0:	48 89 e5             	mov    %rsp,%rbp
  801ad3:	53                   	push   %rbx
  801ad4:	48 83 ec 08          	sub    $0x8,%rsp
  801ad8:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  801adb:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801ade:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801ae3:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ae8:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801aed:	be 00 00 00 00       	mov    $0x0,%esi
  801af2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801af8:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801afa:	48 85 c0             	test   %rax,%rax
  801afd:	7f 06                	jg     801b05 <sys_env_set_trapframe+0x3a>
}
  801aff:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801b03:	c9                   	leave
  801b04:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801b05:	49 89 c0             	mov    %rax,%r8
  801b08:	b9 0b 00 00 00       	mov    $0xb,%ecx
  801b0d:	48 ba c0 40 80 00 00 	movabs $0x8040c0,%rdx
  801b14:	00 00 00 
  801b17:	be 26 00 00 00       	mov    $0x26,%esi
  801b1c:	48 bf 59 44 80 00 00 	movabs $0x804459,%rdi
  801b23:	00 00 00 
  801b26:	b8 00 00 00 00       	mov    $0x0,%eax
  801b2b:	49 b9 09 08 80 00 00 	movabs $0x800809,%r9
  801b32:	00 00 00 
  801b35:	41 ff d1             	call   *%r9

0000000000801b38 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  801b38:	f3 0f 1e fa          	endbr64
  801b3c:	55                   	push   %rbp
  801b3d:	48 89 e5             	mov    %rsp,%rbp
  801b40:	53                   	push   %rbx
  801b41:	48 83 ec 08          	sub    $0x8,%rsp
  801b45:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  801b48:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801b4b:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801b50:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b55:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801b5a:	be 00 00 00 00       	mov    $0x0,%esi
  801b5f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801b65:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801b67:	48 85 c0             	test   %rax,%rax
  801b6a:	7f 06                	jg     801b72 <sys_env_set_pgfault_upcall+0x3a>
}
  801b6c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801b70:	c9                   	leave
  801b71:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801b72:	49 89 c0             	mov    %rax,%r8
  801b75:	b9 0c 00 00 00       	mov    $0xc,%ecx
  801b7a:	48 ba c0 40 80 00 00 	movabs $0x8040c0,%rdx
  801b81:	00 00 00 
  801b84:	be 26 00 00 00       	mov    $0x26,%esi
  801b89:	48 bf 59 44 80 00 00 	movabs $0x804459,%rdi
  801b90:	00 00 00 
  801b93:	b8 00 00 00 00       	mov    $0x0,%eax
  801b98:	49 b9 09 08 80 00 00 	movabs $0x800809,%r9
  801b9f:	00 00 00 
  801ba2:	41 ff d1             	call   *%r9

0000000000801ba5 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  801ba5:	f3 0f 1e fa          	endbr64
  801ba9:	55                   	push   %rbp
  801baa:	48 89 e5             	mov    %rsp,%rbp
  801bad:	53                   	push   %rbx
  801bae:	89 f8                	mov    %edi,%eax
  801bb0:	49 89 f1             	mov    %rsi,%r9
  801bb3:	48 89 d3             	mov    %rdx,%rbx
  801bb6:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  801bb9:	49 63 f0             	movslq %r8d,%rsi
  801bbc:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801bbf:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801bc4:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801bc7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801bcd:	cd 30                	int    $0x30
}
  801bcf:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801bd3:	c9                   	leave
  801bd4:	c3                   	ret

0000000000801bd5 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  801bd5:	f3 0f 1e fa          	endbr64
  801bd9:	55                   	push   %rbp
  801bda:	48 89 e5             	mov    %rsp,%rbp
  801bdd:	53                   	push   %rbx
  801bde:	48 83 ec 08          	sub    $0x8,%rsp
  801be2:	48 89 fa             	mov    %rdi,%rdx
  801be5:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801be8:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801bed:	bb 00 00 00 00       	mov    $0x0,%ebx
  801bf2:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801bf7:	be 00 00 00 00       	mov    $0x0,%esi
  801bfc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801c02:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801c04:	48 85 c0             	test   %rax,%rax
  801c07:	7f 06                	jg     801c0f <sys_ipc_recv+0x3a>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  801c09:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801c0d:	c9                   	leave
  801c0e:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801c0f:	49 89 c0             	mov    %rax,%r8
  801c12:	b9 0f 00 00 00       	mov    $0xf,%ecx
  801c17:	48 ba c0 40 80 00 00 	movabs $0x8040c0,%rdx
  801c1e:	00 00 00 
  801c21:	be 26 00 00 00       	mov    $0x26,%esi
  801c26:	48 bf 59 44 80 00 00 	movabs $0x804459,%rdi
  801c2d:	00 00 00 
  801c30:	b8 00 00 00 00       	mov    $0x0,%eax
  801c35:	49 b9 09 08 80 00 00 	movabs $0x800809,%r9
  801c3c:	00 00 00 
  801c3f:	41 ff d1             	call   *%r9

0000000000801c42 <sys_gettime>:

int
sys_gettime(void) {
  801c42:	f3 0f 1e fa          	endbr64
  801c46:	55                   	push   %rbp
  801c47:	48 89 e5             	mov    %rsp,%rbp
  801c4a:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801c4b:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801c50:	ba 00 00 00 00       	mov    $0x0,%edx
  801c55:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801c5a:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c5f:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801c64:	be 00 00 00 00       	mov    $0x0,%esi
  801c69:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801c6f:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  801c71:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801c75:	c9                   	leave
  801c76:	c3                   	ret

0000000000801c77 <fork>:
 *   Use sys_map_region, it can perform address space copying in one call
 *   Don't forget to set page fault handler in the child (using sys_env_set_pgfault_upcall()).
 *   Remember to fix "thisenv" in the child process.
 */
envid_t
fork(void) {
  801c77:	f3 0f 1e fa          	endbr64
  801c7b:	55                   	push   %rbp
  801c7c:	48 89 e5             	mov    %rsp,%rbp
  801c7f:	41 56                	push   %r14
  801c81:	41 55                	push   %r13
  801c83:	41 54                	push   %r12
  801c85:	53                   	push   %rbx
    // LAB 9: Your code here.
    bool has_pgfault_upcall = thisenv->env_pgfault_upcall;
  801c86:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801c8d:	00 00 00 
  801c90:	4c 8b b0 00 01 00 00 	mov    0x100(%rax),%r14

/* This must be inlined. Exercise for reader: why? */
static inline envid_t __attribute__((always_inline))
sys_exofork(void) {
    envid_t ret;
    asm volatile("int %2"
  801c97:	b8 09 00 00 00       	mov    $0x9,%eax
  801c9c:	cd 30                	int    $0x30
  801c9e:	41 89 c4             	mov    %eax,%r12d

    envid_t envid = sys_exofork();
    if (envid < 0) {
  801ca1:	85 c0                	test   %eax,%eax
  801ca3:	78 7f                	js     801d24 <fork+0xad>
  801ca5:	89 c3                	mov    %eax,%ebx
        return envid;
    }
    if (envid == 0) {
  801ca7:	0f 84 83 00 00 00    	je     801d30 <fork+0xb9>
        thisenv = &envs[ENVX(sys_getenvid())];
        return 0;
    }
    int res = sys_map_region(CURENVID, NULL, envid, NULL, MAX_USER_ADDRESS, PROT_ALL | PROT_LAZY | PROT_COMBINE);
  801cad:	41 b9 ff 0f 00 00    	mov    $0xfff,%r9d
  801cb3:	49 b8 00 00 00 00 80 	movabs $0x8000000000,%r8
  801cba:	00 00 00 
  801cbd:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cc2:	89 c2                	mov    %eax,%edx
  801cc4:	be 00 00 00 00       	mov    $0x0,%esi
  801cc9:	bf 00 00 00 00       	mov    $0x0,%edi
  801cce:	48 b8 1e 19 80 00 00 	movabs $0x80191e,%rax
  801cd5:	00 00 00 
  801cd8:	ff d0                	call   *%rax
  801cda:	41 89 c5             	mov    %eax,%r13d
    if (res < 0) {
  801cdd:	85 c0                	test   %eax,%eax
  801cdf:	0f 88 81 00 00 00    	js     801d66 <fork+0xef>
        sys_env_destroy(envid);
        return res;
    }
    if (has_pgfault_upcall) {
  801ce5:	4d 85 f6             	test   %r14,%r14
  801ce8:	74 20                	je     801d0a <fork+0x93>
        res = sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  801cea:	48 be 3e 3a 80 00 00 	movabs $0x803a3e,%rsi
  801cf1:	00 00 00 
  801cf4:	44 89 e7             	mov    %r12d,%edi
  801cf7:	48 b8 38 1b 80 00 00 	movabs $0x801b38,%rax
  801cfe:	00 00 00 
  801d01:	ff d0                	call   *%rax
  801d03:	41 89 c5             	mov    %eax,%r13d
        if (res < 0) {
  801d06:	85 c0                	test   %eax,%eax
  801d08:	78 70                	js     801d7a <fork+0x103>
            sys_env_destroy(envid);
            return res;
        }
    }
    res = sys_env_set_status(envid, ENV_RUNNABLE);
  801d0a:	be 02 00 00 00       	mov    $0x2,%esi
  801d0f:	89 df                	mov    %ebx,%edi
  801d11:	48 b8 5e 1a 80 00 00 	movabs $0x801a5e,%rax
  801d18:	00 00 00 
  801d1b:	ff d0                	call   *%rax
  801d1d:	41 89 c5             	mov    %eax,%r13d
    if (res < 0) {
  801d20:	85 c0                	test   %eax,%eax
  801d22:	78 6a                	js     801d8e <fork+0x117>
        sys_env_destroy(envid);
        return res;
    }
    return envid;
}
  801d24:	44 89 e0             	mov    %r12d,%eax
  801d27:	5b                   	pop    %rbx
  801d28:	41 5c                	pop    %r12
  801d2a:	41 5d                	pop    %r13
  801d2c:	41 5e                	pop    %r14
  801d2e:	5d                   	pop    %rbp
  801d2f:	c3                   	ret
        thisenv = &envs[ENVX(sys_getenvid())];
  801d30:	48 b8 e3 17 80 00 00 	movabs $0x8017e3,%rax
  801d37:	00 00 00 
  801d3a:	ff d0                	call   *%rax
  801d3c:	25 ff 03 00 00       	and    $0x3ff,%eax
  801d41:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  801d45:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  801d49:	48 c1 e0 04          	shl    $0x4,%rax
  801d4d:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  801d54:	00 00 00 
  801d57:	48 01 d0             	add    %rdx,%rax
  801d5a:	48 a3 00 60 80 00 00 	movabs %rax,0x806000
  801d61:	00 00 00 
        return 0;
  801d64:	eb be                	jmp    801d24 <fork+0xad>
        sys_env_destroy(envid);
  801d66:	44 89 e7             	mov    %r12d,%edi
  801d69:	48 b8 74 17 80 00 00 	movabs $0x801774,%rax
  801d70:	00 00 00 
  801d73:	ff d0                	call   *%rax
        return res;
  801d75:	45 89 ec             	mov    %r13d,%r12d
  801d78:	eb aa                	jmp    801d24 <fork+0xad>
            sys_env_destroy(envid);
  801d7a:	44 89 e7             	mov    %r12d,%edi
  801d7d:	48 b8 74 17 80 00 00 	movabs $0x801774,%rax
  801d84:	00 00 00 
  801d87:	ff d0                	call   *%rax
            return res;
  801d89:	45 89 ec             	mov    %r13d,%r12d
  801d8c:	eb 96                	jmp    801d24 <fork+0xad>
        sys_env_destroy(envid);
  801d8e:	89 df                	mov    %ebx,%edi
  801d90:	48 b8 74 17 80 00 00 	movabs $0x801774,%rax
  801d97:	00 00 00 
  801d9a:	ff d0                	call   *%rax
        return res;
  801d9c:	45 89 ec             	mov    %r13d,%r12d
  801d9f:	eb 83                	jmp    801d24 <fork+0xad>

0000000000801da1 <sfork>:

envid_t
sfork() {
  801da1:	f3 0f 1e fa          	endbr64
  801da5:	55                   	push   %rbp
  801da6:	48 89 e5             	mov    %rsp,%rbp
    panic("sfork() is not implemented");
  801da9:	48 ba 67 44 80 00 00 	movabs $0x804467,%rdx
  801db0:	00 00 00 
  801db3:	be 37 00 00 00       	mov    $0x37,%esi
  801db8:	48 bf 82 44 80 00 00 	movabs $0x804482,%rdi
  801dbf:	00 00 00 
  801dc2:	b8 00 00 00 00       	mov    $0x0,%eax
  801dc7:	48 b9 09 08 80 00 00 	movabs $0x800809,%rcx
  801dce:	00 00 00 
  801dd1:	ff d1                	call   *%rcx

0000000000801dd3 <fd2num>:


/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
  801dd3:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801dd7:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801dde:	ff ff ff 
  801de1:	48 01 f8             	add    %rdi,%rax
  801de4:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801de8:	c3                   	ret

0000000000801de9 <fd2data>:

char *
fd2data(struct Fd *fd) {
  801de9:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801ded:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801df4:	ff ff ff 
  801df7:	48 01 f8             	add    %rdi,%rax
  801dfa:	48 c1 e8 0c          	shr    $0xc,%rax
    return INDEX2DATA(fd2num(fd));
  801dfe:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801e04:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801e08:	c3                   	ret

0000000000801e09 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  801e09:	f3 0f 1e fa          	endbr64
  801e0d:	55                   	push   %rbp
  801e0e:	48 89 e5             	mov    %rsp,%rbp
  801e11:	41 57                	push   %r15
  801e13:	41 56                	push   %r14
  801e15:	41 55                	push   %r13
  801e17:	41 54                	push   %r12
  801e19:	53                   	push   %rbx
  801e1a:	48 83 ec 08          	sub    $0x8,%rsp
  801e1e:	49 89 ff             	mov    %rdi,%r15
  801e21:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  801e26:	49 bd b7 38 80 00 00 	movabs $0x8038b7,%r13
  801e2d:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  801e30:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        struct Fd *fd = INDEX2FD(i);
  801e36:	49 89 dc             	mov    %rbx,%r12
        if (!(get_prot(fd) & PROT_R)) {
  801e39:	48 89 df             	mov    %rbx,%rdi
  801e3c:	41 ff d5             	call   *%r13
  801e3f:	83 e0 04             	and    $0x4,%eax
  801e42:	74 17                	je     801e5b <fd_alloc+0x52>
    for (int i = 0; i < MAXFD; i++) {
  801e44:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  801e4b:	4c 39 f3             	cmp    %r14,%rbx
  801e4e:	75 e6                	jne    801e36 <fd_alloc+0x2d>
  801e50:	41 bc 00 00 00 00    	mov    $0x0,%r12d
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
    return -E_MAX_OPEN;
  801e56:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
            *fd_store = fd;
  801e5b:	4d 89 27             	mov    %r12,(%r15)
}
  801e5e:	48 83 c4 08          	add    $0x8,%rsp
  801e62:	5b                   	pop    %rbx
  801e63:	41 5c                	pop    %r12
  801e65:	41 5d                	pop    %r13
  801e67:	41 5e                	pop    %r14
  801e69:	41 5f                	pop    %r15
  801e6b:	5d                   	pop    %rbp
  801e6c:	c3                   	ret

0000000000801e6d <fd_lookup>:
 *
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
  801e6d:	f3 0f 1e fa          	endbr64
    if (fdnum < 0 || fdnum >= MAXFD) {
  801e71:	83 ff 1f             	cmp    $0x1f,%edi
  801e74:	77 39                	ja     801eaf <fd_lookup+0x42>
fd_lookup(int fdnum, struct Fd **fd_store) {
  801e76:	55                   	push   %rbp
  801e77:	48 89 e5             	mov    %rsp,%rbp
  801e7a:	41 54                	push   %r12
  801e7c:	53                   	push   %rbx
  801e7d:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  801e80:	48 63 df             	movslq %edi,%rbx
  801e83:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  801e8a:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  801e8e:	48 89 df             	mov    %rbx,%rdi
  801e91:	48 b8 b7 38 80 00 00 	movabs $0x8038b7,%rax
  801e98:	00 00 00 
  801e9b:	ff d0                	call   *%rax
  801e9d:	a8 04                	test   $0x4,%al
  801e9f:	74 14                	je     801eb5 <fd_lookup+0x48>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  801ea1:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  801ea5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eaa:	5b                   	pop    %rbx
  801eab:	41 5c                	pop    %r12
  801ead:	5d                   	pop    %rbp
  801eae:	c3                   	ret
        return -E_INVAL;
  801eaf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801eb4:	c3                   	ret
        return -E_INVAL;
  801eb5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801eba:	eb ee                	jmp    801eaa <fd_lookup+0x3d>

0000000000801ebc <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  801ebc:	f3 0f 1e fa          	endbr64
  801ec0:	55                   	push   %rbp
  801ec1:	48 89 e5             	mov    %rsp,%rbp
  801ec4:	41 54                	push   %r12
  801ec6:	53                   	push   %rbx
  801ec7:	49 89 f4             	mov    %rsi,%r12
    for (size_t i = 0; devtab[i]; i++) {
  801eca:	48 b8 60 49 80 00 00 	movabs $0x804960,%rax
  801ed1:	00 00 00 
  801ed4:	48 bb 40 50 80 00 00 	movabs $0x805040,%rbx
  801edb:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  801ede:	39 3b                	cmp    %edi,(%rbx)
  801ee0:	74 47                	je     801f29 <dev_lookup+0x6d>
    for (size_t i = 0; devtab[i]; i++) {
  801ee2:	48 83 c0 08          	add    $0x8,%rax
  801ee6:	48 8b 18             	mov    (%rax),%rbx
  801ee9:	48 85 db             	test   %rbx,%rbx
  801eec:	75 f0                	jne    801ede <dev_lookup+0x22>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801eee:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  801ef5:	00 00 00 
  801ef8:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801efe:	89 fa                	mov    %edi,%edx
  801f00:	48 bf e0 40 80 00 00 	movabs $0x8040e0,%rdi
  801f07:	00 00 00 
  801f0a:	b8 00 00 00 00       	mov    $0x0,%eax
  801f0f:	48 b9 65 09 80 00 00 	movabs $0x800965,%rcx
  801f16:	00 00 00 
  801f19:	ff d1                	call   *%rcx
    *dev = 0;
    return -E_INVAL;
  801f1b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
            *dev = devtab[i];
  801f20:	49 89 1c 24          	mov    %rbx,(%r12)
}
  801f24:	5b                   	pop    %rbx
  801f25:	41 5c                	pop    %r12
  801f27:	5d                   	pop    %rbp
  801f28:	c3                   	ret
            return 0;
  801f29:	b8 00 00 00 00       	mov    $0x0,%eax
  801f2e:	eb f0                	jmp    801f20 <dev_lookup+0x64>

0000000000801f30 <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  801f30:	f3 0f 1e fa          	endbr64
  801f34:	55                   	push   %rbp
  801f35:	48 89 e5             	mov    %rsp,%rbp
  801f38:	41 55                	push   %r13
  801f3a:	41 54                	push   %r12
  801f3c:	53                   	push   %rbx
  801f3d:	48 83 ec 18          	sub    $0x18,%rsp
  801f41:	48 89 fb             	mov    %rdi,%rbx
  801f44:	41 89 f4             	mov    %esi,%r12d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801f47:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  801f4e:	ff ff ff 
  801f51:	48 01 df             	add    %rbx,%rdi
  801f54:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  801f58:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801f5c:	48 b8 6d 1e 80 00 00 	movabs $0x801e6d,%rax
  801f63:	00 00 00 
  801f66:	ff d0                	call   *%rax
  801f68:	41 89 c5             	mov    %eax,%r13d
  801f6b:	85 c0                	test   %eax,%eax
  801f6d:	78 06                	js     801f75 <fd_close+0x45>
  801f6f:	48 39 5d d8          	cmp    %rbx,-0x28(%rbp)
  801f73:	74 1a                	je     801f8f <fd_close+0x5f>
        return (must_exist ? res : 0);
  801f75:	45 84 e4             	test   %r12b,%r12b
  801f78:	b8 00 00 00 00       	mov    $0x0,%eax
  801f7d:	44 0f 44 e8          	cmove  %eax,%r13d
}
  801f81:	44 89 e8             	mov    %r13d,%eax
  801f84:	48 83 c4 18          	add    $0x18,%rsp
  801f88:	5b                   	pop    %rbx
  801f89:	41 5c                	pop    %r12
  801f8b:	41 5d                	pop    %r13
  801f8d:	5d                   	pop    %rbp
  801f8e:	c3                   	ret
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801f8f:	8b 3b                	mov    (%rbx),%edi
  801f91:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801f95:	48 b8 bc 1e 80 00 00 	movabs $0x801ebc,%rax
  801f9c:	00 00 00 
  801f9f:	ff d0                	call   *%rax
  801fa1:	41 89 c5             	mov    %eax,%r13d
  801fa4:	85 c0                	test   %eax,%eax
  801fa6:	78 1b                	js     801fc3 <fd_close+0x93>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  801fa8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801fac:	48 8b 40 20          	mov    0x20(%rax),%rax
  801fb0:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  801fb6:	48 85 c0             	test   %rax,%rax
  801fb9:	74 08                	je     801fc3 <fd_close+0x93>
  801fbb:	48 89 df             	mov    %rbx,%rdi
  801fbe:	ff d0                	call   *%rax
  801fc0:	41 89 c5             	mov    %eax,%r13d
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801fc3:	ba 00 10 00 00       	mov    $0x1000,%edx
  801fc8:	48 89 de             	mov    %rbx,%rsi
  801fcb:	bf 00 00 00 00       	mov    $0x0,%edi
  801fd0:	48 b8 f3 19 80 00 00 	movabs $0x8019f3,%rax
  801fd7:	00 00 00 
  801fda:	ff d0                	call   *%rax
    return res;
  801fdc:	eb a3                	jmp    801f81 <fd_close+0x51>

0000000000801fde <close>:

int
close(int fdnum) {
  801fde:	f3 0f 1e fa          	endbr64
  801fe2:	55                   	push   %rbp
  801fe3:	48 89 e5             	mov    %rsp,%rbp
  801fe6:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  801fea:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801fee:	48 b8 6d 1e 80 00 00 	movabs $0x801e6d,%rax
  801ff5:	00 00 00 
  801ff8:	ff d0                	call   *%rax
    if (res < 0) return res;
  801ffa:	85 c0                	test   %eax,%eax
  801ffc:	78 15                	js     802013 <close+0x35>

    return fd_close(fd, 1);
  801ffe:	be 01 00 00 00       	mov    $0x1,%esi
  802003:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802007:	48 b8 30 1f 80 00 00 	movabs $0x801f30,%rax
  80200e:	00 00 00 
  802011:	ff d0                	call   *%rax
}
  802013:	c9                   	leave
  802014:	c3                   	ret

0000000000802015 <close_all>:

void
close_all(void) {
  802015:	f3 0f 1e fa          	endbr64
  802019:	55                   	push   %rbp
  80201a:	48 89 e5             	mov    %rsp,%rbp
  80201d:	41 54                	push   %r12
  80201f:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  802020:	bb 00 00 00 00       	mov    $0x0,%ebx
  802025:	49 bc de 1f 80 00 00 	movabs $0x801fde,%r12
  80202c:	00 00 00 
  80202f:	89 df                	mov    %ebx,%edi
  802031:	41 ff d4             	call   *%r12
  802034:	83 c3 01             	add    $0x1,%ebx
  802037:	83 fb 20             	cmp    $0x20,%ebx
  80203a:	75 f3                	jne    80202f <close_all+0x1a>
}
  80203c:	5b                   	pop    %rbx
  80203d:	41 5c                	pop    %r12
  80203f:	5d                   	pop    %rbp
  802040:	c3                   	ret

0000000000802041 <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  802041:	f3 0f 1e fa          	endbr64
  802045:	55                   	push   %rbp
  802046:	48 89 e5             	mov    %rsp,%rbp
  802049:	41 57                	push   %r15
  80204b:	41 56                	push   %r14
  80204d:	41 55                	push   %r13
  80204f:	41 54                	push   %r12
  802051:	53                   	push   %rbx
  802052:	48 83 ec 18          	sub    $0x18,%rsp
  802056:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  802059:	48 8d 75 c8          	lea    -0x38(%rbp),%rsi
  80205d:	48 b8 6d 1e 80 00 00 	movabs $0x801e6d,%rax
  802064:	00 00 00 
  802067:	ff d0                	call   *%rax
  802069:	89 c3                	mov    %eax,%ebx
  80206b:	85 c0                	test   %eax,%eax
  80206d:	0f 88 b8 00 00 00    	js     80212b <dup+0xea>
    close(newfdnum);
  802073:	44 89 e7             	mov    %r12d,%edi
  802076:	48 b8 de 1f 80 00 00 	movabs $0x801fde,%rax
  80207d:	00 00 00 
  802080:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  802082:	4d 63 ec             	movslq %r12d,%r13
  802085:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  80208c:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  802090:	4c 8b 7d c8          	mov    -0x38(%rbp),%r15
  802094:	4c 89 ff             	mov    %r15,%rdi
  802097:	49 be e9 1d 80 00 00 	movabs $0x801de9,%r14
  80209e:	00 00 00 
  8020a1:	41 ff d6             	call   *%r14
  8020a4:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  8020a7:	4c 89 ef             	mov    %r13,%rdi
  8020aa:	41 ff d6             	call   *%r14
  8020ad:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  8020b0:	48 89 df             	mov    %rbx,%rdi
  8020b3:	48 b8 b7 38 80 00 00 	movabs $0x8038b7,%rax
  8020ba:	00 00 00 
  8020bd:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  8020bf:	a8 04                	test   $0x4,%al
  8020c1:	74 2b                	je     8020ee <dup+0xad>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  8020c3:	41 89 c1             	mov    %eax,%r9d
  8020c6:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8020cc:	4c 89 f1             	mov    %r14,%rcx
  8020cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8020d4:	48 89 de             	mov    %rbx,%rsi
  8020d7:	bf 00 00 00 00       	mov    $0x0,%edi
  8020dc:	48 b8 1e 19 80 00 00 	movabs $0x80191e,%rax
  8020e3:	00 00 00 
  8020e6:	ff d0                	call   *%rax
  8020e8:	89 c3                	mov    %eax,%ebx
  8020ea:	85 c0                	test   %eax,%eax
  8020ec:	78 4e                	js     80213c <dup+0xfb>
    }
    prot = get_prot(oldfd);
  8020ee:	4c 89 ff             	mov    %r15,%rdi
  8020f1:	48 b8 b7 38 80 00 00 	movabs $0x8038b7,%rax
  8020f8:	00 00 00 
  8020fb:	ff d0                	call   *%rax
  8020fd:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  802100:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  802106:	4c 89 e9             	mov    %r13,%rcx
  802109:	ba 00 00 00 00       	mov    $0x0,%edx
  80210e:	4c 89 fe             	mov    %r15,%rsi
  802111:	bf 00 00 00 00       	mov    $0x0,%edi
  802116:	48 b8 1e 19 80 00 00 	movabs $0x80191e,%rax
  80211d:	00 00 00 
  802120:	ff d0                	call   *%rax
  802122:	89 c3                	mov    %eax,%ebx
  802124:	85 c0                	test   %eax,%eax
  802126:	78 14                	js     80213c <dup+0xfb>

    return newfdnum;
  802128:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  80212b:	89 d8                	mov    %ebx,%eax
  80212d:	48 83 c4 18          	add    $0x18,%rsp
  802131:	5b                   	pop    %rbx
  802132:	41 5c                	pop    %r12
  802134:	41 5d                	pop    %r13
  802136:	41 5e                	pop    %r14
  802138:	41 5f                	pop    %r15
  80213a:	5d                   	pop    %rbp
  80213b:	c3                   	ret
    sys_unmap_region(0, newfd, PAGE_SIZE);
  80213c:	ba 00 10 00 00       	mov    $0x1000,%edx
  802141:	4c 89 ee             	mov    %r13,%rsi
  802144:	bf 00 00 00 00       	mov    $0x0,%edi
  802149:	49 bc f3 19 80 00 00 	movabs $0x8019f3,%r12
  802150:	00 00 00 
  802153:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  802156:	ba 00 10 00 00       	mov    $0x1000,%edx
  80215b:	4c 89 f6             	mov    %r14,%rsi
  80215e:	bf 00 00 00 00       	mov    $0x0,%edi
  802163:	41 ff d4             	call   *%r12
    return res;
  802166:	eb c3                	jmp    80212b <dup+0xea>

0000000000802168 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  802168:	f3 0f 1e fa          	endbr64
  80216c:	55                   	push   %rbp
  80216d:	48 89 e5             	mov    %rsp,%rbp
  802170:	41 56                	push   %r14
  802172:	41 55                	push   %r13
  802174:	41 54                	push   %r12
  802176:	53                   	push   %rbx
  802177:	48 83 ec 10          	sub    $0x10,%rsp
  80217b:	89 fb                	mov    %edi,%ebx
  80217d:	49 89 f4             	mov    %rsi,%r12
  802180:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  802183:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  802187:	48 b8 6d 1e 80 00 00 	movabs $0x801e6d,%rax
  80218e:	00 00 00 
  802191:	ff d0                	call   *%rax
  802193:	85 c0                	test   %eax,%eax
  802195:	78 4c                	js     8021e3 <read+0x7b>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  802197:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  80219b:	41 8b 3e             	mov    (%r14),%edi
  80219e:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8021a2:	48 b8 bc 1e 80 00 00 	movabs $0x801ebc,%rax
  8021a9:	00 00 00 
  8021ac:	ff d0                	call   *%rax
  8021ae:	85 c0                	test   %eax,%eax
  8021b0:	78 35                	js     8021e7 <read+0x7f>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8021b2:	41 8b 46 08          	mov    0x8(%r14),%eax
  8021b6:	83 e0 03             	and    $0x3,%eax
  8021b9:	83 f8 01             	cmp    $0x1,%eax
  8021bc:	74 2d                	je     8021eb <read+0x83>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  8021be:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8021c2:	48 8b 40 10          	mov    0x10(%rax),%rax
  8021c6:	48 85 c0             	test   %rax,%rax
  8021c9:	74 56                	je     802221 <read+0xb9>

    return (*dev->dev_read)(fd, buf, n);
  8021cb:	4c 89 ea             	mov    %r13,%rdx
  8021ce:	4c 89 e6             	mov    %r12,%rsi
  8021d1:	4c 89 f7             	mov    %r14,%rdi
  8021d4:	ff d0                	call   *%rax
}
  8021d6:	48 83 c4 10          	add    $0x10,%rsp
  8021da:	5b                   	pop    %rbx
  8021db:	41 5c                	pop    %r12
  8021dd:	41 5d                	pop    %r13
  8021df:	41 5e                	pop    %r14
  8021e1:	5d                   	pop    %rbp
  8021e2:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8021e3:	48 98                	cltq
  8021e5:	eb ef                	jmp    8021d6 <read+0x6e>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8021e7:	48 98                	cltq
  8021e9:	eb eb                	jmp    8021d6 <read+0x6e>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8021eb:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  8021f2:	00 00 00 
  8021f5:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  8021fb:	89 da                	mov    %ebx,%edx
  8021fd:	48 bf 8d 44 80 00 00 	movabs $0x80448d,%rdi
  802204:	00 00 00 
  802207:	b8 00 00 00 00       	mov    $0x0,%eax
  80220c:	48 b9 65 09 80 00 00 	movabs $0x800965,%rcx
  802213:	00 00 00 
  802216:	ff d1                	call   *%rcx
        return -E_INVAL;
  802218:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  80221f:	eb b5                	jmp    8021d6 <read+0x6e>
    if (!dev->dev_read) return -E_NOT_SUPP;
  802221:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  802228:	eb ac                	jmp    8021d6 <read+0x6e>

000000000080222a <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  80222a:	f3 0f 1e fa          	endbr64
  80222e:	55                   	push   %rbp
  80222f:	48 89 e5             	mov    %rsp,%rbp
  802232:	41 57                	push   %r15
  802234:	41 56                	push   %r14
  802236:	41 55                	push   %r13
  802238:	41 54                	push   %r12
  80223a:	53                   	push   %rbx
  80223b:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  80223f:	48 85 d2             	test   %rdx,%rdx
  802242:	74 54                	je     802298 <readn+0x6e>
  802244:	41 89 fd             	mov    %edi,%r13d
  802247:	49 89 f6             	mov    %rsi,%r14
  80224a:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  80224d:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  802252:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  802257:	49 bf 68 21 80 00 00 	movabs $0x802168,%r15
  80225e:	00 00 00 
  802261:	4c 89 e2             	mov    %r12,%rdx
  802264:	48 29 f2             	sub    %rsi,%rdx
  802267:	4c 01 f6             	add    %r14,%rsi
  80226a:	44 89 ef             	mov    %r13d,%edi
  80226d:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  802270:	85 c0                	test   %eax,%eax
  802272:	78 20                	js     802294 <readn+0x6a>
    for (; inc && res < n; res += inc) {
  802274:	01 c3                	add    %eax,%ebx
  802276:	85 c0                	test   %eax,%eax
  802278:	74 08                	je     802282 <readn+0x58>
  80227a:	48 63 f3             	movslq %ebx,%rsi
  80227d:	4c 39 e6             	cmp    %r12,%rsi
  802280:	72 df                	jb     802261 <readn+0x37>
    }
    return res;
  802282:	48 63 c3             	movslq %ebx,%rax
}
  802285:	48 83 c4 08          	add    $0x8,%rsp
  802289:	5b                   	pop    %rbx
  80228a:	41 5c                	pop    %r12
  80228c:	41 5d                	pop    %r13
  80228e:	41 5e                	pop    %r14
  802290:	41 5f                	pop    %r15
  802292:	5d                   	pop    %rbp
  802293:	c3                   	ret
        if (inc < 0) return inc;
  802294:	48 98                	cltq
  802296:	eb ed                	jmp    802285 <readn+0x5b>
    int inc = 1, res = 0;
  802298:	bb 00 00 00 00       	mov    $0x0,%ebx
  80229d:	eb e3                	jmp    802282 <readn+0x58>

000000000080229f <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  80229f:	f3 0f 1e fa          	endbr64
  8022a3:	55                   	push   %rbp
  8022a4:	48 89 e5             	mov    %rsp,%rbp
  8022a7:	41 56                	push   %r14
  8022a9:	41 55                	push   %r13
  8022ab:	41 54                	push   %r12
  8022ad:	53                   	push   %rbx
  8022ae:	48 83 ec 10          	sub    $0x10,%rsp
  8022b2:	89 fb                	mov    %edi,%ebx
  8022b4:	49 89 f4             	mov    %rsi,%r12
  8022b7:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8022ba:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8022be:	48 b8 6d 1e 80 00 00 	movabs $0x801e6d,%rax
  8022c5:	00 00 00 
  8022c8:	ff d0                	call   *%rax
  8022ca:	85 c0                	test   %eax,%eax
  8022cc:	78 47                	js     802315 <write+0x76>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8022ce:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  8022d2:	41 8b 3e             	mov    (%r14),%edi
  8022d5:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8022d9:	48 b8 bc 1e 80 00 00 	movabs $0x801ebc,%rax
  8022e0:	00 00 00 
  8022e3:	ff d0                	call   *%rax
  8022e5:	85 c0                	test   %eax,%eax
  8022e7:	78 30                	js     802319 <write+0x7a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8022e9:	41 f6 46 08 03       	testb  $0x3,0x8(%r14)
  8022ee:	74 2d                	je     80231d <write+0x7e>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  8022f0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8022f4:	48 8b 40 18          	mov    0x18(%rax),%rax
  8022f8:	48 85 c0             	test   %rax,%rax
  8022fb:	74 56                	je     802353 <write+0xb4>

    return (*dev->dev_write)(fd, buf, n);
  8022fd:	4c 89 ea             	mov    %r13,%rdx
  802300:	4c 89 e6             	mov    %r12,%rsi
  802303:	4c 89 f7             	mov    %r14,%rdi
  802306:	ff d0                	call   *%rax
}
  802308:	48 83 c4 10          	add    $0x10,%rsp
  80230c:	5b                   	pop    %rbx
  80230d:	41 5c                	pop    %r12
  80230f:	41 5d                	pop    %r13
  802311:	41 5e                	pop    %r14
  802313:	5d                   	pop    %rbp
  802314:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  802315:	48 98                	cltq
  802317:	eb ef                	jmp    802308 <write+0x69>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  802319:	48 98                	cltq
  80231b:	eb eb                	jmp    802308 <write+0x69>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80231d:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  802324:	00 00 00 
  802327:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  80232d:	89 da                	mov    %ebx,%edx
  80232f:	48 bf a9 44 80 00 00 	movabs $0x8044a9,%rdi
  802336:	00 00 00 
  802339:	b8 00 00 00 00       	mov    $0x0,%eax
  80233e:	48 b9 65 09 80 00 00 	movabs $0x800965,%rcx
  802345:	00 00 00 
  802348:	ff d1                	call   *%rcx
        return -E_INVAL;
  80234a:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  802351:	eb b5                	jmp    802308 <write+0x69>
    if (!dev->dev_write) return -E_NOT_SUPP;
  802353:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  80235a:	eb ac                	jmp    802308 <write+0x69>

000000000080235c <seek>:

int
seek(int fdnum, off_t offset) {
  80235c:	f3 0f 1e fa          	endbr64
  802360:	55                   	push   %rbp
  802361:	48 89 e5             	mov    %rsp,%rbp
  802364:	53                   	push   %rbx
  802365:	48 83 ec 18          	sub    $0x18,%rsp
  802369:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  80236b:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  80236f:	48 b8 6d 1e 80 00 00 	movabs $0x801e6d,%rax
  802376:	00 00 00 
  802379:	ff d0                	call   *%rax
  80237b:	85 c0                	test   %eax,%eax
  80237d:	78 0c                	js     80238b <seek+0x2f>

    fd->fd_offset = offset;
  80237f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802383:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  802386:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80238b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80238f:	c9                   	leave
  802390:	c3                   	ret

0000000000802391 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  802391:	f3 0f 1e fa          	endbr64
  802395:	55                   	push   %rbp
  802396:	48 89 e5             	mov    %rsp,%rbp
  802399:	41 55                	push   %r13
  80239b:	41 54                	push   %r12
  80239d:	53                   	push   %rbx
  80239e:	48 83 ec 18          	sub    $0x18,%rsp
  8023a2:	89 fb                	mov    %edi,%ebx
  8023a4:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8023a7:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8023ab:	48 b8 6d 1e 80 00 00 	movabs $0x801e6d,%rax
  8023b2:	00 00 00 
  8023b5:	ff d0                	call   *%rax
  8023b7:	85 c0                	test   %eax,%eax
  8023b9:	78 38                	js     8023f3 <ftruncate+0x62>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8023bb:	4c 8b 6d d8          	mov    -0x28(%rbp),%r13
  8023bf:	41 8b 7d 00          	mov    0x0(%r13),%edi
  8023c3:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8023c7:	48 b8 bc 1e 80 00 00 	movabs $0x801ebc,%rax
  8023ce:	00 00 00 
  8023d1:	ff d0                	call   *%rax
  8023d3:	85 c0                	test   %eax,%eax
  8023d5:	78 1c                	js     8023f3 <ftruncate+0x62>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8023d7:	41 f6 45 08 03       	testb  $0x3,0x8(%r13)
  8023dc:	74 20                	je     8023fe <ftruncate+0x6d>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  8023de:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8023e2:	48 8b 40 30          	mov    0x30(%rax),%rax
  8023e6:	48 85 c0             	test   %rax,%rax
  8023e9:	74 47                	je     802432 <ftruncate+0xa1>

    return (*dev->dev_trunc)(fd, newsize);
  8023eb:	44 89 e6             	mov    %r12d,%esi
  8023ee:	4c 89 ef             	mov    %r13,%rdi
  8023f1:	ff d0                	call   *%rax
}
  8023f3:	48 83 c4 18          	add    $0x18,%rsp
  8023f7:	5b                   	pop    %rbx
  8023f8:	41 5c                	pop    %r12
  8023fa:	41 5d                	pop    %r13
  8023fc:	5d                   	pop    %rbp
  8023fd:	c3                   	ret
                thisenv->env_id, fdnum);
  8023fe:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  802405:	00 00 00 
  802408:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  80240e:	89 da                	mov    %ebx,%edx
  802410:	48 bf 00 41 80 00 00 	movabs $0x804100,%rdi
  802417:	00 00 00 
  80241a:	b8 00 00 00 00       	mov    $0x0,%eax
  80241f:	48 b9 65 09 80 00 00 	movabs $0x800965,%rcx
  802426:	00 00 00 
  802429:	ff d1                	call   *%rcx
        return -E_INVAL;
  80242b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802430:	eb c1                	jmp    8023f3 <ftruncate+0x62>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  802432:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  802437:	eb ba                	jmp    8023f3 <ftruncate+0x62>

0000000000802439 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  802439:	f3 0f 1e fa          	endbr64
  80243d:	55                   	push   %rbp
  80243e:	48 89 e5             	mov    %rsp,%rbp
  802441:	41 54                	push   %r12
  802443:	53                   	push   %rbx
  802444:	48 83 ec 10          	sub    $0x10,%rsp
  802448:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  80244b:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  80244f:	48 b8 6d 1e 80 00 00 	movabs $0x801e6d,%rax
  802456:	00 00 00 
  802459:	ff d0                	call   *%rax
  80245b:	85 c0                	test   %eax,%eax
  80245d:	78 4e                	js     8024ad <fstat+0x74>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  80245f:	4c 8b 65 e8          	mov    -0x18(%rbp),%r12
  802463:	41 8b 3c 24          	mov    (%r12),%edi
  802467:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  80246b:	48 b8 bc 1e 80 00 00 	movabs $0x801ebc,%rax
  802472:	00 00 00 
  802475:	ff d0                	call   *%rax
  802477:	85 c0                	test   %eax,%eax
  802479:	78 32                	js     8024ad <fstat+0x74>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  80247b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80247f:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  802484:	74 30                	je     8024b6 <fstat+0x7d>

    stat->st_name[0] = 0;
  802486:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  802489:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  802490:	00 00 00 
    stat->st_isdir = 0;
  802493:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  80249a:	00 00 00 
    stat->st_dev = dev;
  80249d:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  8024a4:	48 89 de             	mov    %rbx,%rsi
  8024a7:	4c 89 e7             	mov    %r12,%rdi
  8024aa:	ff 50 28             	call   *0x28(%rax)
}
  8024ad:	48 83 c4 10          	add    $0x10,%rsp
  8024b1:	5b                   	pop    %rbx
  8024b2:	41 5c                	pop    %r12
  8024b4:	5d                   	pop    %rbp
  8024b5:	c3                   	ret
    if (!dev->dev_stat) return -E_NOT_SUPP;
  8024b6:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  8024bb:	eb f0                	jmp    8024ad <fstat+0x74>

00000000008024bd <stat>:

int
stat(const char *path, struct Stat *stat) {
  8024bd:	f3 0f 1e fa          	endbr64
  8024c1:	55                   	push   %rbp
  8024c2:	48 89 e5             	mov    %rsp,%rbp
  8024c5:	41 54                	push   %r12
  8024c7:	53                   	push   %rbx
  8024c8:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  8024cb:	be 00 00 00 00       	mov    $0x0,%esi
  8024d0:	48 b8 9e 27 80 00 00 	movabs $0x80279e,%rax
  8024d7:	00 00 00 
  8024da:	ff d0                	call   *%rax
  8024dc:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  8024de:	85 c0                	test   %eax,%eax
  8024e0:	78 25                	js     802507 <stat+0x4a>

    int res = fstat(fd, stat);
  8024e2:	4c 89 e6             	mov    %r12,%rsi
  8024e5:	89 c7                	mov    %eax,%edi
  8024e7:	48 b8 39 24 80 00 00 	movabs $0x802439,%rax
  8024ee:	00 00 00 
  8024f1:	ff d0                	call   *%rax
  8024f3:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  8024f6:	89 df                	mov    %ebx,%edi
  8024f8:	48 b8 de 1f 80 00 00 	movabs $0x801fde,%rax
  8024ff:	00 00 00 
  802502:	ff d0                	call   *%rax

    return res;
  802504:	44 89 e3             	mov    %r12d,%ebx
}
  802507:	89 d8                	mov    %ebx,%eax
  802509:	5b                   	pop    %rbx
  80250a:	41 5c                	pop    %r12
  80250c:	5d                   	pop    %rbp
  80250d:	c3                   	ret

000000000080250e <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  80250e:	f3 0f 1e fa          	endbr64
  802512:	55                   	push   %rbp
  802513:	48 89 e5             	mov    %rsp,%rbp
  802516:	41 54                	push   %r12
  802518:	53                   	push   %rbx
  802519:	48 83 ec 10          	sub    $0x10,%rsp
  80251d:	41 89 fc             	mov    %edi,%r12d
  802520:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  802523:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80252a:	00 00 00 
  80252d:	83 38 00             	cmpl   $0x0,(%rax)
  802530:	74 6e                	je     8025a0 <fsipc+0x92>

    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }
    fsenv = ipc_find_env(ENV_TYPE_FS);
  802532:	bf 03 00 00 00       	mov    $0x3,%edi
  802537:	48 b8 1f 3c 80 00 00 	movabs $0x803c1f,%rax
  80253e:	00 00 00 
  802541:	ff d0                	call   *%rax
  802543:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  80254a:	00 00 
    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  80254c:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  802552:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802557:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  80255e:	00 00 00 
  802561:	44 89 e6             	mov    %r12d,%esi
  802564:	89 c7                	mov    %eax,%edi
  802566:	48 b8 5d 3b 80 00 00 	movabs $0x803b5d,%rax
  80256d:	00 00 00 
  802570:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  802572:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  802579:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  80257a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80257f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802583:	48 89 de             	mov    %rbx,%rsi
  802586:	bf 00 00 00 00       	mov    $0x0,%edi
  80258b:	48 b8 c4 3a 80 00 00 	movabs $0x803ac4,%rax
  802592:	00 00 00 
  802595:	ff d0                	call   *%rax
}
  802597:	48 83 c4 10          	add    $0x10,%rsp
  80259b:	5b                   	pop    %rbx
  80259c:	41 5c                	pop    %r12
  80259e:	5d                   	pop    %rbp
  80259f:	c3                   	ret
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  8025a0:	bf 03 00 00 00       	mov    $0x3,%edi
  8025a5:	48 b8 1f 3c 80 00 00 	movabs $0x803c1f,%rax
  8025ac:	00 00 00 
  8025af:	ff d0                	call   *%rax
  8025b1:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  8025b8:	00 00 
  8025ba:	e9 73 ff ff ff       	jmp    802532 <fsipc+0x24>

00000000008025bf <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  8025bf:	f3 0f 1e fa          	endbr64
  8025c3:	55                   	push   %rbp
  8025c4:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8025c7:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8025ce:	00 00 00 
  8025d1:	8b 57 0c             	mov    0xc(%rdi),%edx
  8025d4:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  8025d6:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  8025d9:	be 00 00 00 00       	mov    $0x0,%esi
  8025de:	bf 02 00 00 00       	mov    $0x2,%edi
  8025e3:	48 b8 0e 25 80 00 00 	movabs $0x80250e,%rax
  8025ea:	00 00 00 
  8025ed:	ff d0                	call   *%rax
}
  8025ef:	5d                   	pop    %rbp
  8025f0:	c3                   	ret

00000000008025f1 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  8025f1:	f3 0f 1e fa          	endbr64
  8025f5:	55                   	push   %rbp
  8025f6:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8025f9:	8b 47 0c             	mov    0xc(%rdi),%eax
  8025fc:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  802603:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  802605:	be 00 00 00 00       	mov    $0x0,%esi
  80260a:	bf 06 00 00 00       	mov    $0x6,%edi
  80260f:	48 b8 0e 25 80 00 00 	movabs $0x80250e,%rax
  802616:	00 00 00 
  802619:	ff d0                	call   *%rax
}
  80261b:	5d                   	pop    %rbp
  80261c:	c3                   	ret

000000000080261d <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  80261d:	f3 0f 1e fa          	endbr64
  802621:	55                   	push   %rbp
  802622:	48 89 e5             	mov    %rsp,%rbp
  802625:	41 54                	push   %r12
  802627:	53                   	push   %rbx
  802628:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80262b:	8b 47 0c             	mov    0xc(%rdi),%eax
  80262e:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  802635:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  802637:	be 00 00 00 00       	mov    $0x0,%esi
  80263c:	bf 05 00 00 00       	mov    $0x5,%edi
  802641:	48 b8 0e 25 80 00 00 	movabs $0x80250e,%rax
  802648:	00 00 00 
  80264b:	ff d0                	call   *%rax
    if (res < 0) return res;
  80264d:	85 c0                	test   %eax,%eax
  80264f:	78 3d                	js     80268e <devfile_stat+0x71>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802651:	49 bc 00 70 80 00 00 	movabs $0x807000,%r12
  802658:	00 00 00 
  80265b:	4c 89 e6             	mov    %r12,%rsi
  80265e:	48 89 df             	mov    %rbx,%rdi
  802661:	48 b8 ae 12 80 00 00 	movabs $0x8012ae,%rax
  802668:	00 00 00 
  80266b:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  80266d:	41 8b 84 24 80 00 00 	mov    0x80(%r12),%eax
  802674:	00 
  802675:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80267b:	41 8b 84 24 84 00 00 	mov    0x84(%r12),%eax
  802682:	00 
  802683:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  802689:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80268e:	5b                   	pop    %rbx
  80268f:	41 5c                	pop    %r12
  802691:	5d                   	pop    %rbp
  802692:	c3                   	ret

0000000000802693 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  802693:	f3 0f 1e fa          	endbr64
    if (n >= sizeof(fsipcbuf.write.req_buf)) {
  802697:	48 81 fa ef 0f 00 00 	cmp    $0xfef,%rdx
  80269e:	77 41                	ja     8026e1 <devfile_write+0x4e>
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  8026a0:	55                   	push   %rbp
  8026a1:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  8026a4:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8026ab:	00 00 00 
  8026ae:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  8026b1:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.write.req_n = n;
  8026b3:	48 89 50 08          	mov    %rdx,0x8(%rax)
    memmove(fsipcbuf.write.req_buf, buf, n);
  8026b7:	48 8d 78 10          	lea    0x10(%rax),%rdi
  8026bb:	48 b8 c9 14 80 00 00 	movabs $0x8014c9,%rax
  8026c2:	00 00 00 
  8026c5:	ff d0                	call   *%rax
    res = fsipc(FSREQ_WRITE, NULL);
  8026c7:	be 00 00 00 00       	mov    $0x0,%esi
  8026cc:	bf 04 00 00 00       	mov    $0x4,%edi
  8026d1:	48 b8 0e 25 80 00 00 	movabs $0x80250e,%rax
  8026d8:	00 00 00 
  8026db:	ff d0                	call   *%rax
  8026dd:	48 98                	cltq
}
  8026df:	5d                   	pop    %rbp
  8026e0:	c3                   	ret
        return -E_INVAL;
  8026e1:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
}
  8026e8:	c3                   	ret

00000000008026e9 <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  8026e9:	f3 0f 1e fa          	endbr64
  8026ed:	55                   	push   %rbp
  8026ee:	48 89 e5             	mov    %rsp,%rbp
  8026f1:	41 55                	push   %r13
  8026f3:	41 54                	push   %r12
  8026f5:	53                   	push   %rbx
  8026f6:	48 83 ec 08          	sub    $0x8,%rsp
  8026fa:	49 89 f4             	mov    %rsi,%r12
  8026fd:	48 89 d3             	mov    %rdx,%rbx
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  802700:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802707:	00 00 00 
  80270a:	8b 57 0c             	mov    0xc(%rdi),%edx
  80270d:	89 10                	mov    %edx,(%rax)
    fsipcbuf.read.req_n = n;
  80270f:	48 89 58 08          	mov    %rbx,0x8(%rax)
    res = fsipc(FSREQ_READ, NULL);
  802713:	be 00 00 00 00       	mov    $0x0,%esi
  802718:	bf 03 00 00 00       	mov    $0x3,%edi
  80271d:	48 b8 0e 25 80 00 00 	movabs $0x80250e,%rax
  802724:	00 00 00 
  802727:	ff d0                	call   *%rax
  802729:	4c 63 e8             	movslq %eax,%r13
    if (res < 0) {
  80272c:	4d 85 ed             	test   %r13,%r13
  80272f:	78 2a                	js     80275b <devfile_read+0x72>
    assert(res <= n && res <= PAGE_SIZE);
  802731:	4c 89 ea             	mov    %r13,%rdx
  802734:	4c 39 eb             	cmp    %r13,%rbx
  802737:	72 30                	jb     802769 <devfile_read+0x80>
  802739:	49 81 fd 00 10 00 00 	cmp    $0x1000,%r13
  802740:	7f 27                	jg     802769 <devfile_read+0x80>
    memmove(buf, &fsipcbuf, res);
  802742:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802749:	00 00 00 
  80274c:	4c 89 e7             	mov    %r12,%rdi
  80274f:	48 b8 c9 14 80 00 00 	movabs $0x8014c9,%rax
  802756:	00 00 00 
  802759:	ff d0                	call   *%rax
}
  80275b:	4c 89 e8             	mov    %r13,%rax
  80275e:	48 83 c4 08          	add    $0x8,%rsp
  802762:	5b                   	pop    %rbx
  802763:	41 5c                	pop    %r12
  802765:	41 5d                	pop    %r13
  802767:	5d                   	pop    %rbp
  802768:	c3                   	ret
    assert(res <= n && res <= PAGE_SIZE);
  802769:	48 b9 c6 44 80 00 00 	movabs $0x8044c6,%rcx
  802770:	00 00 00 
  802773:	48 ba e3 44 80 00 00 	movabs $0x8044e3,%rdx
  80277a:	00 00 00 
  80277d:	be 7b 00 00 00       	mov    $0x7b,%esi
  802782:	48 bf f8 44 80 00 00 	movabs $0x8044f8,%rdi
  802789:	00 00 00 
  80278c:	b8 00 00 00 00       	mov    $0x0,%eax
  802791:	49 b8 09 08 80 00 00 	movabs $0x800809,%r8
  802798:	00 00 00 
  80279b:	41 ff d0             	call   *%r8

000000000080279e <open>:
open(const char *path, int mode) {
  80279e:	f3 0f 1e fa          	endbr64
  8027a2:	55                   	push   %rbp
  8027a3:	48 89 e5             	mov    %rsp,%rbp
  8027a6:	41 55                	push   %r13
  8027a8:	41 54                	push   %r12
  8027aa:	53                   	push   %rbx
  8027ab:	48 83 ec 18          	sub    $0x18,%rsp
  8027af:	49 89 fc             	mov    %rdi,%r12
  8027b2:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  8027b5:	48 b8 69 12 80 00 00 	movabs $0x801269,%rax
  8027bc:	00 00 00 
  8027bf:	ff d0                	call   *%rax
  8027c1:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  8027c7:	0f 87 8a 00 00 00    	ja     802857 <open+0xb9>
    if ((res = fd_alloc(&fd)) < 0) return res;
  8027cd:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  8027d1:	48 b8 09 1e 80 00 00 	movabs $0x801e09,%rax
  8027d8:	00 00 00 
  8027db:	ff d0                	call   *%rax
  8027dd:	89 c3                	mov    %eax,%ebx
  8027df:	85 c0                	test   %eax,%eax
  8027e1:	78 50                	js     802833 <open+0x95>
    strcpy(fsipcbuf.open.req_path, path);
  8027e3:	4c 89 e6             	mov    %r12,%rsi
  8027e6:	48 bb 00 70 80 00 00 	movabs $0x807000,%rbx
  8027ed:	00 00 00 
  8027f0:	48 89 df             	mov    %rbx,%rdi
  8027f3:	48 b8 ae 12 80 00 00 	movabs $0x8012ae,%rax
  8027fa:	00 00 00 
  8027fd:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  8027ff:	44 89 ab 00 04 00 00 	mov    %r13d,0x400(%rbx)
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  802806:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80280a:	bf 01 00 00 00       	mov    $0x1,%edi
  80280f:	48 b8 0e 25 80 00 00 	movabs $0x80250e,%rax
  802816:	00 00 00 
  802819:	ff d0                	call   *%rax
  80281b:	89 c3                	mov    %eax,%ebx
  80281d:	85 c0                	test   %eax,%eax
  80281f:	78 1f                	js     802840 <open+0xa2>
    return fd2num(fd);
  802821:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802825:	48 b8 d3 1d 80 00 00 	movabs $0x801dd3,%rax
  80282c:	00 00 00 
  80282f:	ff d0                	call   *%rax
  802831:	89 c3                	mov    %eax,%ebx
}
  802833:	89 d8                	mov    %ebx,%eax
  802835:	48 83 c4 18          	add    $0x18,%rsp
  802839:	5b                   	pop    %rbx
  80283a:	41 5c                	pop    %r12
  80283c:	41 5d                	pop    %r13
  80283e:	5d                   	pop    %rbp
  80283f:	c3                   	ret
        fd_close(fd, 0);
  802840:	be 00 00 00 00       	mov    $0x0,%esi
  802845:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802849:	48 b8 30 1f 80 00 00 	movabs $0x801f30,%rax
  802850:	00 00 00 
  802853:	ff d0                	call   *%rax
        return res;
  802855:	eb dc                	jmp    802833 <open+0x95>
        return -E_BAD_PATH;
  802857:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  80285c:	eb d5                	jmp    802833 <open+0x95>

000000000080285e <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  80285e:	f3 0f 1e fa          	endbr64
  802862:	55                   	push   %rbp
  802863:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  802866:	be 00 00 00 00       	mov    $0x0,%esi
  80286b:	bf 08 00 00 00       	mov    $0x8,%edi
  802870:	48 b8 0e 25 80 00 00 	movabs $0x80250e,%rax
  802877:	00 00 00 
  80287a:	ff d0                	call   *%rax
}
  80287c:	5d                   	pop    %rbp
  80287d:	c3                   	ret

000000000080287e <copy_shared_region>:
    if (sys_unmap_region(0, UTEMP, USER_STACK_SIZE) < 0) goto error;
    return res;
}

static int
copy_shared_region(void *start, void *end, void *arg) {
  80287e:	f3 0f 1e fa          	endbr64
  802882:	55                   	push   %rbp
  802883:	48 89 e5             	mov    %rsp,%rbp
  802886:	41 55                	push   %r13
  802888:	41 54                	push   %r12
  80288a:	53                   	push   %rbx
  80288b:	48 83 ec 08          	sub    $0x8,%rsp
  80288f:	48 89 fb             	mov    %rdi,%rbx
  802892:	49 89 f4             	mov    %rsi,%r12
    envid_t child = *(envid_t *)arg;
  802895:	44 8b 2a             	mov    (%rdx),%r13d
    return sys_map_region(0, start, child, start, end - start, get_prot(start));
  802898:	48 b8 b7 38 80 00 00 	movabs $0x8038b7,%rax
  80289f:	00 00 00 
  8028a2:	ff d0                	call   *%rax
  8028a4:	41 89 c1             	mov    %eax,%r9d
  8028a7:	4d 89 e0             	mov    %r12,%r8
  8028aa:	49 29 d8             	sub    %rbx,%r8
  8028ad:	48 89 d9             	mov    %rbx,%rcx
  8028b0:	44 89 ea             	mov    %r13d,%edx
  8028b3:	48 89 de             	mov    %rbx,%rsi
  8028b6:	bf 00 00 00 00       	mov    $0x0,%edi
  8028bb:	48 b8 1e 19 80 00 00 	movabs $0x80191e,%rax
  8028c2:	00 00 00 
  8028c5:	ff d0                	call   *%rax
}
  8028c7:	48 83 c4 08          	add    $0x8,%rsp
  8028cb:	5b                   	pop    %rbx
  8028cc:	41 5c                	pop    %r12
  8028ce:	41 5d                	pop    %r13
  8028d0:	5d                   	pop    %rbp
  8028d1:	c3                   	ret

00000000008028d2 <spawn>:
spawn(const char *prog, const char **argv) {
  8028d2:	f3 0f 1e fa          	endbr64
  8028d6:	55                   	push   %rbp
  8028d7:	48 89 e5             	mov    %rsp,%rbp
  8028da:	41 57                	push   %r15
  8028dc:	41 56                	push   %r14
  8028de:	41 55                	push   %r13
  8028e0:	41 54                	push   %r12
  8028e2:	53                   	push   %rbx
  8028e3:	48 81 ec f8 02 00 00 	sub    $0x2f8,%rsp
  8028ea:	49 89 f4             	mov    %rsi,%r12
    int fd = open(prog, O_RDONLY);
  8028ed:	be 00 00 00 00       	mov    $0x0,%esi
  8028f2:	48 b8 9e 27 80 00 00 	movabs $0x80279e,%rax
  8028f9:	00 00 00 
  8028fc:	ff d0                	call   *%rax
  8028fe:	89 85 fc fc ff ff    	mov    %eax,-0x304(%rbp)
    if (fd < 0) return fd;
  802904:	85 c0                	test   %eax,%eax
  802906:	0f 88 30 06 00 00    	js     802f3c <spawn+0x66a>
  80290c:	89 c7                	mov    %eax,%edi
    res = readn(fd, elf_buf, sizeof(elf_buf));
  80290e:	ba 00 02 00 00       	mov    $0x200,%edx
  802913:	48 8d b5 d0 fd ff ff 	lea    -0x230(%rbp),%rsi
  80291a:	48 b8 2a 22 80 00 00 	movabs $0x80222a,%rax
  802921:	00 00 00 
  802924:	ff d0                	call   *%rax
  802926:	89 c6                	mov    %eax,%esi
    if (res != sizeof(elf_buf)) {
  802928:	3d 00 02 00 00       	cmp    $0x200,%eax
  80292d:	0f 85 7d 02 00 00    	jne    802bb0 <spawn+0x2de>
        elf->e_elf[1] != 1 /* little endian */ ||
  802933:	48 b8 ff ff ff ff ff 	movabs $0xffffffffffffff,%rax
  80293a:	ff ff 00 
  80293d:	48 23 85 d0 fd ff ff 	and    -0x230(%rbp),%rax
    if (elf->e_magic != ELF_MAGIC ||
  802944:	48 ba 7f 45 4c 46 02 	movabs $0x10102464c457f,%rdx
  80294b:	01 01 00 
  80294e:	48 39 d0             	cmp    %rdx,%rax
  802951:	0f 85 95 02 00 00    	jne    802bec <spawn+0x31a>
        elf->e_type != ET_EXEC /* executable */ ||
  802957:	81 bd e0 fd ff ff 02 	cmpl   $0x3e0002,-0x220(%rbp)
  80295e:	00 3e 00 
  802961:	0f 85 85 02 00 00    	jne    802bec <spawn+0x31a>
  802967:	b8 09 00 00 00       	mov    $0x9,%eax
  80296c:	cd 30                	int    $0x30
  80296e:	41 89 c6             	mov    %eax,%r14d
  802971:	89 c3                	mov    %eax,%ebx
    if ((int)(res = sys_exofork()) < 0) goto error2;
  802973:	85 c0                	test   %eax,%eax
  802975:	0f 88 a9 05 00 00    	js     802f24 <spawn+0x652>
    envid_t child = res;
  80297b:	89 85 cc fd ff ff    	mov    %eax,-0x234(%rbp)
    struct Trapframe child_tf = envs[ENVX(child)].env_tf;
  802981:	25 ff 03 00 00       	and    $0x3ff,%eax
  802986:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  80298a:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  80298e:	48 c1 e0 04          	shl    $0x4,%rax
  802992:	48 be 00 00 a0 1f 80 	movabs $0x801fa00000,%rsi
  802999:	00 00 00 
  80299c:	48 01 c6             	add    %rax,%rsi
  80299f:	48 8b 06             	mov    (%rsi),%rax
  8029a2:	48 89 85 0c fd ff ff 	mov    %rax,-0x2f4(%rbp)
  8029a9:	48 8b 86 b8 00 00 00 	mov    0xb8(%rsi),%rax
  8029b0:	48 89 85 c4 fd ff ff 	mov    %rax,-0x23c(%rbp)
  8029b7:	48 8d bd 10 fd ff ff 	lea    -0x2f0(%rbp),%rdi
  8029be:	48 c7 c1 fc ff ff ff 	mov    $0xfffffffffffffffc,%rcx
  8029c5:	48 29 ce             	sub    %rcx,%rsi
  8029c8:	81 c1 c0 00 00 00    	add    $0xc0,%ecx
  8029ce:	c1 e9 03             	shr    $0x3,%ecx
  8029d1:	89 c9                	mov    %ecx,%ecx
  8029d3:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
    child_tf.tf_rip = elf->e_entry;
  8029d6:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8029dd:	48 89 85 a4 fd ff ff 	mov    %rax,-0x25c(%rbp)
    for (argc = 0; argv[argc] != 0; argc++)
  8029e4:	49 8b 3c 24          	mov    (%r12),%rdi
  8029e8:	48 85 ff             	test   %rdi,%rdi
  8029eb:	0f 84 7f 05 00 00    	je     802f70 <spawn+0x69e>
  8029f1:	41 bd 01 00 00 00    	mov    $0x1,%r13d
    string_size = 0;
  8029f7:	41 bf 00 00 00 00    	mov    $0x0,%r15d
        string_size += strlen(argv[argc]) + 1;
  8029fd:	48 bb 69 12 80 00 00 	movabs $0x801269,%rbx
  802a04:	00 00 00 
  802a07:	ff d3                	call   *%rbx
  802a09:	4c 01 f8             	add    %r15,%rax
  802a0c:	4c 8d 78 01          	lea    0x1(%rax),%r15
    for (argc = 0; argv[argc] != 0; argc++)
  802a10:	4c 89 ea             	mov    %r13,%rdx
  802a13:	49 83 c5 01          	add    $0x1,%r13
  802a17:	4b 8b 7c ec f8       	mov    -0x8(%r12,%r13,8),%rdi
  802a1c:	48 85 ff             	test   %rdi,%rdi
  802a1f:	75 e6                	jne    802a07 <spawn+0x135>
    string_store = (char *)UTEMP + USER_STACK_SIZE - string_size;
  802a21:	49 89 d5             	mov    %rdx,%r13
  802a24:	48 89 95 e8 fc ff ff 	mov    %rdx,-0x318(%rbp)
  802a2b:	48 f7 d0             	not    %rax
  802a2e:	48 8d 98 00 00 41 00 	lea    0x410000(%rax),%rbx
    argv_store = (uintptr_t *)(ROUNDDOWN(string_store, sizeof(uintptr_t)) - sizeof(uintptr_t) * (argc + 1));
  802a35:	49 89 df             	mov    %rbx,%r15
  802a38:	49 83 e7 f8          	and    $0xfffffffffffffff8,%r15
  802a3c:	4c 89 bd e0 fc ff ff 	mov    %r15,-0x320(%rbp)
  802a43:	89 d0                	mov    %edx,%eax
  802a45:	83 c0 01             	add    $0x1,%eax
  802a48:	48 98                	cltq
  802a4a:	48 c1 e0 03          	shl    $0x3,%rax
  802a4e:	49 29 c7             	sub    %rax,%r15
  802a51:	4c 89 bd f0 fc ff ff 	mov    %r15,-0x310(%rbp)
    if ((void *)(argv_store - 2) < (void *)UTEMP) return -E_NO_MEM;
  802a58:	49 8d 47 f0          	lea    -0x10(%r15),%rax
  802a5c:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  802a62:	0f 86 ff 04 00 00    	jbe    802f67 <spawn+0x695>
    if ((res = sys_alloc_region(0, UTEMP, USER_STACK_SIZE, PROT_RW)) < 0) return res;
  802a68:	b9 06 00 00 00       	mov    $0x6,%ecx
  802a6d:	ba 00 00 01 00       	mov    $0x10000,%edx
  802a72:	be 00 00 40 00       	mov    $0x400000,%esi
  802a77:	48 b8 b3 18 80 00 00 	movabs $0x8018b3,%rax
  802a7e:	00 00 00 
  802a81:	ff d0                	call   *%rax
  802a83:	85 c0                	test   %eax,%eax
  802a85:	0f 88 e1 04 00 00    	js     802f6c <spawn+0x69a>
    for (i = 0; i < argc; i++) {
  802a8b:	4c 89 e8             	mov    %r13,%rax
  802a8e:	45 85 ed             	test   %r13d,%r13d
  802a91:	7e 54                	jle    802ae7 <spawn+0x215>
  802a93:	4d 89 fd             	mov    %r15,%r13
  802a96:	48 98                	cltq
  802a98:	4d 8d 3c c7          	lea    (%r15,%rax,8),%r15
        argv_store[i] = UTEMP2USTACK(string_store);
  802a9c:	48 b8 00 70 fe ff 7f 	movabs $0x7ffffe7000,%rax
  802aa3:	00 00 00 
  802aa6:	48 8d 84 03 00 00 c0 	lea    -0x400000(%rbx,%rax,1),%rax
  802aad:	ff 
  802aae:	49 89 45 00          	mov    %rax,0x0(%r13)
        strcpy(string_store, argv[i]);
  802ab2:	49 8b 34 24          	mov    (%r12),%rsi
  802ab6:	48 89 df             	mov    %rbx,%rdi
  802ab9:	48 b8 ae 12 80 00 00 	movabs $0x8012ae,%rax
  802ac0:	00 00 00 
  802ac3:	ff d0                	call   *%rax
        string_store += strlen(argv[i]) + 1;
  802ac5:	49 8b 3c 24          	mov    (%r12),%rdi
  802ac9:	48 b8 69 12 80 00 00 	movabs $0x801269,%rax
  802ad0:	00 00 00 
  802ad3:	ff d0                	call   *%rax
  802ad5:	48 8d 5c 03 01       	lea    0x1(%rbx,%rax,1),%rbx
    for (i = 0; i < argc; i++) {
  802ada:	49 83 c5 08          	add    $0x8,%r13
  802ade:	49 83 c4 08          	add    $0x8,%r12
  802ae2:	4d 39 fd             	cmp    %r15,%r13
  802ae5:	75 b5                	jne    802a9c <spawn+0x1ca>
    argv_store[argc] = 0;
  802ae7:	48 8b 85 e0 fc ff ff 	mov    -0x320(%rbp),%rax
  802aee:	48 c7 40 f8 00 00 00 	movq   $0x0,-0x8(%rax)
  802af5:	00 
    assert(string_store == (char *)UTEMP + USER_STACK_SIZE);
  802af6:	48 81 fb 00 00 41 00 	cmp    $0x410000,%rbx
  802afd:	0f 85 30 01 00 00    	jne    802c33 <spawn+0x361>
    argv_store[-1] = UTEMP2USTACK(argv_store);
  802b03:	48 b9 00 70 fe ff 7f 	movabs $0x7ffffe7000,%rcx
  802b0a:	00 00 00 
  802b0d:	48 8b b5 f0 fc ff ff 	mov    -0x310(%rbp),%rsi
  802b14:	48 8d 84 0e 00 00 c0 	lea    -0x400000(%rsi,%rcx,1),%rax
  802b1b:	ff 
  802b1c:	48 89 46 f8          	mov    %rax,-0x8(%rsi)
    argv_store[-2] = argc;
  802b20:	48 8b 85 e8 fc ff ff 	mov    -0x318(%rbp),%rax
  802b27:	48 89 46 f0          	mov    %rax,-0x10(%rsi)
    tf->tf_rsp = UTEMP2USTACK(&argv_store[-2]);
  802b2b:	48 b8 f0 6f fe ff 7f 	movabs $0x7ffffe6ff0,%rax
  802b32:	00 00 00 
  802b35:	48 8d 84 06 00 00 c0 	lea    -0x400000(%rsi,%rax,1),%rax
  802b3c:	ff 
  802b3d:	48 89 85 bc fd ff ff 	mov    %rax,-0x244(%rbp)
    if (sys_map_region(0, UTEMP, child, (void *)(USER_STACK_TOP - USER_STACK_SIZE),
  802b44:	41 b9 06 00 00 00    	mov    $0x6,%r9d
  802b4a:	41 b8 00 00 01 00    	mov    $0x10000,%r8d
  802b50:	44 89 f2             	mov    %r14d,%edx
  802b53:	be 00 00 40 00       	mov    $0x400000,%esi
  802b58:	bf 00 00 00 00       	mov    $0x0,%edi
  802b5d:	48 b8 1e 19 80 00 00 	movabs $0x80191e,%rax
  802b64:	00 00 00 
  802b67:	ff d0                	call   *%rax
    if (sys_unmap_region(0, UTEMP, USER_STACK_SIZE) < 0) goto error;
  802b69:	48 bb f3 19 80 00 00 	movabs $0x8019f3,%rbx
  802b70:	00 00 00 
  802b73:	ba 00 00 01 00       	mov    $0x10000,%edx
  802b78:	be 00 00 40 00       	mov    $0x400000,%esi
  802b7d:	bf 00 00 00 00       	mov    $0x0,%edi
  802b82:	ff d3                	call   *%rbx
  802b84:	85 c0                	test   %eax,%eax
  802b86:	78 eb                	js     802b73 <spawn+0x2a1>
    struct Proghdr *ph = (struct Proghdr *)(elf_buf + elf->e_phoff);
  802b88:	48 8b 85 f0 fd ff ff 	mov    -0x210(%rbp),%rax
  802b8f:	4c 8d b4 05 d0 fd ff 	lea    -0x230(%rbp,%rax,1),%r14
  802b96:	ff 
    for (size_t i = 0; i < elf->e_phnum; i++, ph++) {
  802b97:	66 83 bd 08 fe ff ff 	cmpw   $0x0,-0x1f8(%rbp)
  802b9e:	00 
  802b9f:	0f 84 68 02 00 00    	je     802e0d <spawn+0x53b>
  802ba5:	41 bf 00 00 00 00    	mov    $0x0,%r15d
  802bab:	e9 c5 01 00 00       	jmp    802d75 <spawn+0x4a3>
        cprintf("Wrong ELF header size or read error: %i\n", res);
  802bb0:	48 bf 28 41 80 00 00 	movabs $0x804128,%rdi
  802bb7:	00 00 00 
  802bba:	b8 00 00 00 00       	mov    $0x0,%eax
  802bbf:	48 ba 65 09 80 00 00 	movabs $0x800965,%rdx
  802bc6:	00 00 00 
  802bc9:	ff d2                	call   *%rdx
        close(fd);
  802bcb:	8b bd fc fc ff ff    	mov    -0x304(%rbp),%edi
  802bd1:	48 b8 de 1f 80 00 00 	movabs $0x801fde,%rax
  802bd8:	00 00 00 
  802bdb:	ff d0                	call   *%rax
        return -E_NOT_EXEC;
  802bdd:	c7 85 fc fc ff ff ee 	movl   $0xffffffee,-0x304(%rbp)
  802be4:	ff ff ff 
  802be7:	e9 50 03 00 00       	jmp    802f3c <spawn+0x66a>
        cprintf("Elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  802bec:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  802bf1:	8b b5 d0 fd ff ff    	mov    -0x230(%rbp),%esi
  802bf7:	48 bf 03 45 80 00 00 	movabs $0x804503,%rdi
  802bfe:	00 00 00 
  802c01:	b8 00 00 00 00       	mov    $0x0,%eax
  802c06:	48 b9 65 09 80 00 00 	movabs $0x800965,%rcx
  802c0d:	00 00 00 
  802c10:	ff d1                	call   *%rcx
        close(fd);
  802c12:	8b bd fc fc ff ff    	mov    -0x304(%rbp),%edi
  802c18:	48 b8 de 1f 80 00 00 	movabs $0x801fde,%rax
  802c1f:	00 00 00 
  802c22:	ff d0                	call   *%rax
        return -E_NOT_EXEC;
  802c24:	c7 85 fc fc ff ff ee 	movl   $0xffffffee,-0x304(%rbp)
  802c2b:	ff ff ff 
  802c2e:	e9 09 03 00 00       	jmp    802f3c <spawn+0x66a>
    assert(string_store == (char *)UTEMP + USER_STACK_SIZE);
  802c33:	48 b9 58 41 80 00 00 	movabs $0x804158,%rcx
  802c3a:	00 00 00 
  802c3d:	48 ba e3 44 80 00 00 	movabs $0x8044e3,%rdx
  802c44:	00 00 00 
  802c47:	be f0 00 00 00       	mov    $0xf0,%esi
  802c4c:	48 bf 1d 45 80 00 00 	movabs $0x80451d,%rdi
  802c53:	00 00 00 
  802c56:	b8 00 00 00 00       	mov    $0x0,%eax
  802c5b:	49 b8 09 08 80 00 00 	movabs $0x800809,%r8
  802c62:	00 00 00 
  802c65:	41 ff d0             	call   *%r8
    /* seek() fd to fileoffset  */
    /* read filesz to UTEMP */
    /* Map read section conents to child */
    /* Unmap it from parent */
    if (filesz != 0) {
        res = sys_alloc_region(CURENVID, UTEMP, filesz, perm | PROT_W);
  802c68:	8b 8d f0 fc ff ff    	mov    -0x310(%rbp),%ecx
  802c6e:	83 c9 02             	or     $0x2,%ecx
  802c71:	48 89 da             	mov    %rbx,%rdx
  802c74:	be 00 00 40 00       	mov    $0x400000,%esi
  802c79:	bf 00 00 00 00       	mov    $0x0,%edi
  802c7e:	48 b8 b3 18 80 00 00 	movabs $0x8018b3,%rax
  802c85:	00 00 00 
  802c88:	ff d0                	call   *%rax
        if (res < 0) {
  802c8a:	85 c0                	test   %eax,%eax
  802c8c:	0f 88 7e 02 00 00    	js     802f10 <spawn+0x63e>
            return res;
        }

        res = seek(fd, fileoffset);
  802c92:	8b b5 e8 fc ff ff    	mov    -0x318(%rbp),%esi
  802c98:	8b bd fc fc ff ff    	mov    -0x304(%rbp),%edi
  802c9e:	48 b8 5c 23 80 00 00 	movabs $0x80235c,%rax
  802ca5:	00 00 00 
  802ca8:	ff d0                	call   *%rax
        if (res < 0) {
  802caa:	85 c0                	test   %eax,%eax
  802cac:	0f 88 a2 02 00 00    	js     802f54 <spawn+0x682>
            return res;
        }

        res = readn(fd, (void *)UTEMP, filesz);
  802cb2:	48 89 da             	mov    %rbx,%rdx
  802cb5:	be 00 00 40 00       	mov    $0x400000,%esi
  802cba:	8b bd fc fc ff ff    	mov    -0x304(%rbp),%edi
  802cc0:	48 b8 2a 22 80 00 00 	movabs $0x80222a,%rax
  802cc7:	00 00 00 
  802cca:	ff d0                	call   *%rax
        if (res < 0) {
  802ccc:	85 c0                	test   %eax,%eax
  802cce:	0f 88 84 02 00 00    	js     802f58 <spawn+0x686>
            return res;
        }

        res = sys_map_region(CURENVID, (void *)UTEMP, child, (void *)va, filesz, perm);
  802cd4:	44 8b 8d f0 fc ff ff 	mov    -0x310(%rbp),%r9d
  802cdb:	49 89 d8             	mov    %rbx,%r8
  802cde:	4c 89 e1             	mov    %r12,%rcx
  802ce1:	8b 95 e0 fc ff ff    	mov    -0x320(%rbp),%edx
  802ce7:	be 00 00 40 00       	mov    $0x400000,%esi
  802cec:	bf 00 00 00 00       	mov    $0x0,%edi
  802cf1:	48 b8 1e 19 80 00 00 	movabs $0x80191e,%rax
  802cf8:	00 00 00 
  802cfb:	ff d0                	call   *%rax
        if (res < 0) {
  802cfd:	85 c0                	test   %eax,%eax
  802cff:	0f 88 57 02 00 00    	js     802f5c <spawn+0x68a>
            return res;
        }

        res = sys_unmap_region(CURENVID, UTEMP, filesz);
  802d05:	48 89 da             	mov    %rbx,%rdx
  802d08:	be 00 00 40 00       	mov    $0x400000,%esi
  802d0d:	bf 00 00 00 00       	mov    $0x0,%edi
  802d12:	48 b8 f3 19 80 00 00 	movabs $0x8019f3,%rax
  802d19:	00 00 00 
  802d1c:	ff d0                	call   *%rax
        if (res < 0) {
  802d1e:	85 c0                	test   %eax,%eax
  802d20:	0f 89 ca 00 00 00    	jns    802df0 <spawn+0x51e>
  802d26:	89 c3                	mov    %eax,%ebx
  802d28:	e9 e5 01 00 00       	jmp    802f12 <spawn+0x640>
            return res;
        }
    }

    if (memsz > filesz) {
        res = sys_alloc_region(child, (void *)(va + filesz), (memsz - filesz), perm | ALLOC_ZERO);
  802d2d:	8b 8d f0 fc ff ff    	mov    -0x310(%rbp),%ecx
  802d33:	81 c9 00 00 10 00    	or     $0x100000,%ecx
  802d39:	4c 89 ea             	mov    %r13,%rdx
  802d3c:	48 29 da             	sub    %rbx,%rdx
  802d3f:	4a 8d 34 23          	lea    (%rbx,%r12,1),%rsi
  802d43:	8b bd e0 fc ff ff    	mov    -0x320(%rbp),%edi
  802d49:	48 b8 b3 18 80 00 00 	movabs $0x8018b3,%rax
  802d50:	00 00 00 
  802d53:	ff d0                	call   *%rax
        if ((res = map_segment(child, ph->p_va, ph->p_memsz,
  802d55:	85 c0                	test   %eax,%eax
  802d57:	0f 88 a1 00 00 00    	js     802dfe <spawn+0x52c>
    for (size_t i = 0; i < elf->e_phnum; i++, ph++) {
  802d5d:	49 83 c7 01          	add    $0x1,%r15
  802d61:	49 83 c6 38          	add    $0x38,%r14
  802d65:	0f b7 85 08 fe ff ff 	movzwl -0x1f8(%rbp),%eax
  802d6c:	49 39 c7             	cmp    %rax,%r15
  802d6f:	0f 83 98 00 00 00    	jae    802e0d <spawn+0x53b>
        if (ph->p_type != ELF_PROG_LOAD) continue;
  802d75:	41 83 3e 01          	cmpl   $0x1,(%r14)
  802d79:	75 e2                	jne    802d5d <spawn+0x48b>
        if (ph->p_flags & ELF_PROG_FLAG_WRITE) perm |= PROT_W;
  802d7b:	41 8b 46 04          	mov    0x4(%r14),%eax
  802d7f:	89 c2                	mov    %eax,%edx
  802d81:	83 e2 02             	and    $0x2,%edx
        if (ph->p_flags & ELF_PROG_FLAG_READ) perm |= PROT_R;
  802d84:	89 d1                	mov    %edx,%ecx
  802d86:	83 c9 04             	or     $0x4,%ecx
  802d89:	a8 04                	test   $0x4,%al
  802d8b:	0f 45 d1             	cmovne %ecx,%edx
        if (ph->p_flags & ELF_PROG_FLAG_EXEC) perm |= PROT_X;
  802d8e:	83 e0 01             	and    $0x1,%eax
  802d91:	09 d0                	or     %edx,%eax
  802d93:	89 85 f0 fc ff ff    	mov    %eax,-0x310(%rbp)
        if ((res = map_segment(child, ph->p_va, ph->p_memsz,
  802d99:	49 8b 46 08          	mov    0x8(%r14),%rax
  802d9d:	89 85 e8 fc ff ff    	mov    %eax,-0x318(%rbp)
  802da3:	49 8b 5e 20          	mov    0x20(%r14),%rbx
  802da7:	4d 8b 6e 28          	mov    0x28(%r14),%r13
  802dab:	4d 8b 66 10          	mov    0x10(%r14),%r12
  802daf:	8b 8d cc fd ff ff    	mov    -0x234(%rbp),%ecx
  802db5:	89 8d e0 fc ff ff    	mov    %ecx,-0x320(%rbp)
    if (res) {
  802dbb:	44 89 e2             	mov    %r12d,%edx
  802dbe:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  802dc4:	74 14                	je     802dda <spawn+0x508>
        va -= res;
  802dc6:	48 63 ca             	movslq %edx,%rcx
  802dc9:	49 29 cc             	sub    %rcx,%r12
        memsz += res;
  802dcc:	49 01 cd             	add    %rcx,%r13
        filesz += res;
  802dcf:	48 01 cb             	add    %rcx,%rbx
        fileoffset -= res;
  802dd2:	29 d0                	sub    %edx,%eax
  802dd4:	89 85 e8 fc ff ff    	mov    %eax,-0x318(%rbp)
    if (filesz > HUGE_PAGE_SIZE) {
  802dda:	48 81 fb 00 00 20 00 	cmp    $0x200000,%rbx
  802de1:	0f 87 79 01 00 00    	ja     802f60 <spawn+0x68e>
    if (filesz != 0) {
  802de7:	48 85 db             	test   %rbx,%rbx
  802dea:	0f 85 78 fe ff ff    	jne    802c68 <spawn+0x396>
    if (memsz > filesz) {
  802df0:	4c 39 eb             	cmp    %r13,%rbx
  802df3:	0f 83 64 ff ff ff    	jae    802d5d <spawn+0x48b>
  802df9:	e9 2f ff ff ff       	jmp    802d2d <spawn+0x45b>
        if (res < 0) {
  802dfe:	ba 00 00 00 00       	mov    $0x0,%edx
  802e03:	0f 4e d0             	cmovle %eax,%edx
  802e06:	89 d3                	mov    %edx,%ebx
  802e08:	e9 05 01 00 00       	jmp    802f12 <spawn+0x640>
    close(fd);
  802e0d:	8b bd fc fc ff ff    	mov    -0x304(%rbp),%edi
  802e13:	48 b8 de 1f 80 00 00 	movabs $0x801fde,%rax
  802e1a:	00 00 00 
  802e1d:	ff d0                	call   *%rax
    if ((res = foreach_shared_region(copy_shared_region, &child)) < 0)
  802e1f:	48 8d b5 cc fd ff ff 	lea    -0x234(%rbp),%rsi
  802e26:	48 bf 7e 28 80 00 00 	movabs $0x80287e,%rdi
  802e2d:	00 00 00 
  802e30:	48 b8 37 39 80 00 00 	movabs $0x803937,%rax
  802e37:	00 00 00 
  802e3a:	ff d0                	call   *%rax
  802e3c:	85 c0                	test   %eax,%eax
  802e3e:	78 49                	js     802e89 <spawn+0x5b7>
    if ((res = sys_env_set_trapframe(child, &child_tf)) < 0)
  802e40:	48 8d b5 0c fd ff ff 	lea    -0x2f4(%rbp),%rsi
  802e47:	8b bd cc fd ff ff    	mov    -0x234(%rbp),%edi
  802e4d:	48 b8 cb 1a 80 00 00 	movabs $0x801acb,%rax
  802e54:	00 00 00 
  802e57:	ff d0                	call   *%rax
  802e59:	85 c0                	test   %eax,%eax
  802e5b:	78 59                	js     802eb6 <spawn+0x5e4>
    if ((res = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802e5d:	be 02 00 00 00       	mov    $0x2,%esi
  802e62:	8b bd cc fd ff ff    	mov    -0x234(%rbp),%edi
  802e68:	48 b8 5e 1a 80 00 00 	movabs $0x801a5e,%rax
  802e6f:	00 00 00 
  802e72:	ff d0                	call   *%rax
  802e74:	85 c0                	test   %eax,%eax
  802e76:	78 6b                	js     802ee3 <spawn+0x611>
    return child;
  802e78:	8b 85 cc fd ff ff    	mov    -0x234(%rbp),%eax
  802e7e:	89 85 fc fc ff ff    	mov    %eax,-0x304(%rbp)
  802e84:	e9 b3 00 00 00       	jmp    802f3c <spawn+0x66a>
        panic("copy_shared_region: %i", res);
  802e89:	89 c1                	mov    %eax,%ecx
  802e8b:	48 ba 29 45 80 00 00 	movabs $0x804529,%rdx
  802e92:	00 00 00 
  802e95:	be 84 00 00 00       	mov    $0x84,%esi
  802e9a:	48 bf 1d 45 80 00 00 	movabs $0x80451d,%rdi
  802ea1:	00 00 00 
  802ea4:	b8 00 00 00 00       	mov    $0x0,%eax
  802ea9:	49 b8 09 08 80 00 00 	movabs $0x800809,%r8
  802eb0:	00 00 00 
  802eb3:	41 ff d0             	call   *%r8
        panic("sys_env_set_trapframe: %i", res);
  802eb6:	89 c1                	mov    %eax,%ecx
  802eb8:	48 ba 40 45 80 00 00 	movabs $0x804540,%rdx
  802ebf:	00 00 00 
  802ec2:	be 87 00 00 00       	mov    $0x87,%esi
  802ec7:	48 bf 1d 45 80 00 00 	movabs $0x80451d,%rdi
  802ece:	00 00 00 
  802ed1:	b8 00 00 00 00       	mov    $0x0,%eax
  802ed6:	49 b8 09 08 80 00 00 	movabs $0x800809,%r8
  802edd:	00 00 00 
  802ee0:	41 ff d0             	call   *%r8
        panic("sys_env_set_status: %i", res);
  802ee3:	89 c1                	mov    %eax,%ecx
  802ee5:	48 ba 5a 45 80 00 00 	movabs $0x80455a,%rdx
  802eec:	00 00 00 
  802eef:	be 8a 00 00 00       	mov    $0x8a,%esi
  802ef4:	48 bf 1d 45 80 00 00 	movabs $0x80451d,%rdi
  802efb:	00 00 00 
  802efe:	b8 00 00 00 00       	mov    $0x0,%eax
  802f03:	49 b8 09 08 80 00 00 	movabs $0x800809,%r8
  802f0a:	00 00 00 
  802f0d:	41 ff d0             	call   *%r8
  802f10:	89 c3                	mov    %eax,%ebx
    sys_env_destroy(child);
  802f12:	8b bd cc fd ff ff    	mov    -0x234(%rbp),%edi
  802f18:	48 b8 74 17 80 00 00 	movabs $0x801774,%rax
  802f1f:	00 00 00 
  802f22:	ff d0                	call   *%rax
    close(fd);
  802f24:	8b bd fc fc ff ff    	mov    -0x304(%rbp),%edi
  802f2a:	48 b8 de 1f 80 00 00 	movabs $0x801fde,%rax
  802f31:	00 00 00 
  802f34:	ff d0                	call   *%rax
    return res;
  802f36:	89 9d fc fc ff ff    	mov    %ebx,-0x304(%rbp)
}
  802f3c:	8b 85 fc fc ff ff    	mov    -0x304(%rbp),%eax
  802f42:	48 81 c4 f8 02 00 00 	add    $0x2f8,%rsp
  802f49:	5b                   	pop    %rbx
  802f4a:	41 5c                	pop    %r12
  802f4c:	41 5d                	pop    %r13
  802f4e:	41 5e                	pop    %r14
  802f50:	41 5f                	pop    %r15
  802f52:	5d                   	pop    %rbp
  802f53:	c3                   	ret
  802f54:	89 c3                	mov    %eax,%ebx
  802f56:	eb ba                	jmp    802f12 <spawn+0x640>
  802f58:	89 c3                	mov    %eax,%ebx
  802f5a:	eb b6                	jmp    802f12 <spawn+0x640>
  802f5c:	89 c3                	mov    %eax,%ebx
  802f5e:	eb b2                	jmp    802f12 <spawn+0x640>
        return -E_INVAL;
  802f60:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
  802f65:	eb ab                	jmp    802f12 <spawn+0x640>
    if ((void *)(argv_store - 2) < (void *)UTEMP) return -E_NO_MEM;
  802f67:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
    if ((res = init_stack(child, argv, &child_tf)) < 0) goto error;
  802f6c:	89 c3                	mov    %eax,%ebx
  802f6e:	eb a2                	jmp    802f12 <spawn+0x640>
    if ((res = sys_alloc_region(0, UTEMP, USER_STACK_SIZE, PROT_RW)) < 0) return res;
  802f70:	b9 06 00 00 00       	mov    $0x6,%ecx
  802f75:	ba 00 00 01 00       	mov    $0x10000,%edx
  802f7a:	be 00 00 40 00       	mov    $0x400000,%esi
  802f7f:	bf 00 00 00 00       	mov    $0x0,%edi
  802f84:	48 b8 b3 18 80 00 00 	movabs $0x8018b3,%rax
  802f8b:	00 00 00 
  802f8e:	ff d0                	call   *%rax
  802f90:	85 c0                	test   %eax,%eax
  802f92:	78 d8                	js     802f6c <spawn+0x69a>
    for (argc = 0; argv[argc] != 0; argc++)
  802f94:	48 c7 85 e8 fc ff ff 	movq   $0x0,-0x318(%rbp)
  802f9b:	00 00 00 00 
    argv_store = (uintptr_t *)(ROUNDDOWN(string_store, sizeof(uintptr_t)) - sizeof(uintptr_t) * (argc + 1));
  802f9f:	48 c7 85 f0 fc ff ff 	movq   $0x40fff8,-0x310(%rbp)
  802fa6:	f8 ff 40 00 
  802faa:	48 c7 85 e0 fc ff ff 	movq   $0x410000,-0x320(%rbp)
  802fb1:	00 00 41 00 
    string_store = (char *)UTEMP + USER_STACK_SIZE - string_size;
  802fb5:	bb 00 00 41 00       	mov    $0x410000,%ebx
  802fba:	e9 28 fb ff ff       	jmp    802ae7 <spawn+0x215>

0000000000802fbf <spawnl>:
spawnl(const char *prog, const char *arg0, ...) {
  802fbf:	f3 0f 1e fa          	endbr64
  802fc3:	55                   	push   %rbp
  802fc4:	48 89 e5             	mov    %rsp,%rbp
  802fc7:	48 83 ec 50          	sub    $0x50,%rsp
  802fcb:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  802fcf:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802fd3:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  802fd7:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(vl, arg0);
  802fdb:	c7 45 b8 10 00 00 00 	movl   $0x10,-0x48(%rbp)
  802fe2:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802fe6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802fea:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802fee:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int argc = 0;
  802ff2:	b9 00 00 00 00       	mov    $0x0,%ecx
    while (va_arg(vl, void *) != NULL) argc++;
  802ff7:	eb 15                	jmp    80300e <spawnl+0x4f>
  802ff9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802ffd:	48 8d 42 08          	lea    0x8(%rdx),%rax
  803001:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  803005:	48 83 3a 00          	cmpq   $0x0,(%rdx)
  803009:	74 1c                	je     803027 <spawnl+0x68>
  80300b:	83 c1 01             	add    $0x1,%ecx
  80300e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803011:	83 f8 2f             	cmp    $0x2f,%eax
  803014:	77 e3                	ja     802ff9 <spawnl+0x3a>
  803016:	89 c2                	mov    %eax,%edx
  803018:	4c 8d 55 d0          	lea    -0x30(%rbp),%r10
  80301c:	4c 01 d2             	add    %r10,%rdx
  80301f:	83 c0 08             	add    $0x8,%eax
  803022:	89 45 b8             	mov    %eax,-0x48(%rbp)
  803025:	eb de                	jmp    803005 <spawnl+0x46>
    const char *argv[argc + 2];
  803027:	8d 41 02             	lea    0x2(%rcx),%eax
  80302a:	48 98                	cltq
  80302c:	48 8d 04 c5 0f 00 00 	lea    0xf(,%rax,8),%rax
  803033:	00 
  803034:	49 89 c0             	mov    %rax,%r8
  803037:	49 83 e0 f0          	and    $0xfffffffffffffff0,%r8
  80303b:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  803041:	48 89 e2             	mov    %rsp,%rdx
  803044:	48 29 c2             	sub    %rax,%rdx
  803047:	48 39 d4             	cmp    %rdx,%rsp
  80304a:	74 12                	je     80305e <spawnl+0x9f>
  80304c:	48 81 ec 00 10 00 00 	sub    $0x1000,%rsp
  803053:	48 83 8c 24 f8 0f 00 	orq    $0x0,0xff8(%rsp)
  80305a:	00 00 
  80305c:	eb e9                	jmp    803047 <spawnl+0x88>
  80305e:	4c 89 c0             	mov    %r8,%rax
  803061:	25 ff 0f 00 00       	and    $0xfff,%eax
  803066:	48 29 c4             	sub    %rax,%rsp
  803069:	48 85 c0             	test   %rax,%rax
  80306c:	74 06                	je     803074 <spawnl+0xb5>
  80306e:	48 83 4c 04 f8 00    	orq    $0x0,-0x8(%rsp,%rax,1)
  803074:	4c 8d 4c 24 07       	lea    0x7(%rsp),%r9
  803079:	4c 89 c8             	mov    %r9,%rax
  80307c:	48 c1 e8 03          	shr    $0x3,%rax
  803080:	49 83 e1 f8          	and    $0xfffffffffffffff8,%r9
    argv[0] = arg0;
  803084:	48 89 34 c5 00 00 00 	mov    %rsi,0x0(,%rax,8)
  80308b:	00 
    argv[argc + 1] = NULL;
  80308c:	8d 41 01             	lea    0x1(%rcx),%eax
  80308f:	48 98                	cltq
  803091:	49 c7 04 c1 00 00 00 	movq   $0x0,(%r9,%rax,8)
  803098:	00 
    va_start(vl, arg0);
  803099:	c7 45 b8 10 00 00 00 	movl   $0x10,-0x48(%rbp)
  8030a0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8030a4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8030a8:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8030ac:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    for (i = 0; i < argc; i++) {
  8030b0:	85 c9                	test   %ecx,%ecx
  8030b2:	74 41                	je     8030f5 <spawnl+0x136>
        argv[i + 1] = va_arg(vl, const char *);
  8030b4:	49 89 c0             	mov    %rax,%r8
  8030b7:	49 8d 41 08          	lea    0x8(%r9),%rax
  8030bb:	8d 51 ff             	lea    -0x1(%rcx),%edx
  8030be:	49 8d 74 d1 10       	lea    0x10(%r9,%rdx,8),%rsi
  8030c3:	eb 1b                	jmp    8030e0 <spawnl+0x121>
  8030c5:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8030c9:	48 8d 51 08          	lea    0x8(%rcx),%rdx
  8030cd:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8030d1:	48 8b 11             	mov    (%rcx),%rdx
  8030d4:	48 89 10             	mov    %rdx,(%rax)
    for (i = 0; i < argc; i++) {
  8030d7:	48 83 c0 08          	add    $0x8,%rax
  8030db:	48 39 f0             	cmp    %rsi,%rax
  8030de:	74 15                	je     8030f5 <spawnl+0x136>
        argv[i + 1] = va_arg(vl, const char *);
  8030e0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8030e3:	83 fa 2f             	cmp    $0x2f,%edx
  8030e6:	77 dd                	ja     8030c5 <spawnl+0x106>
  8030e8:	89 d1                	mov    %edx,%ecx
  8030ea:	4c 01 c1             	add    %r8,%rcx
  8030ed:	83 c2 08             	add    $0x8,%edx
  8030f0:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8030f3:	eb dc                	jmp    8030d1 <spawnl+0x112>
    return spawn(prog, argv);
  8030f5:	4c 89 ce             	mov    %r9,%rsi
  8030f8:	48 b8 d2 28 80 00 00 	movabs $0x8028d2,%rax
  8030ff:	00 00 00 
  803102:	ff d0                	call   *%rax
}
  803104:	c9                   	leave
  803105:	c3                   	ret

0000000000803106 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  803106:	f3 0f 1e fa          	endbr64
  80310a:	55                   	push   %rbp
  80310b:	48 89 e5             	mov    %rsp,%rbp
  80310e:	41 54                	push   %r12
  803110:	53                   	push   %rbx
  803111:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  803114:	48 b8 e9 1d 80 00 00 	movabs $0x801de9,%rax
  80311b:	00 00 00 
  80311e:	ff d0                	call   *%rax
  803120:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  803123:	48 be 71 45 80 00 00 	movabs $0x804571,%rsi
  80312a:	00 00 00 
  80312d:	48 89 df             	mov    %rbx,%rdi
  803130:	48 b8 ae 12 80 00 00 	movabs $0x8012ae,%rax
  803137:	00 00 00 
  80313a:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  80313c:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  803141:	41 2b 04 24          	sub    (%r12),%eax
  803145:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  80314b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  803152:	00 00 00 
    stat->st_dev = &devpipe;
  803155:	48 b8 80 50 80 00 00 	movabs $0x805080,%rax
  80315c:	00 00 00 
  80315f:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  803166:	b8 00 00 00 00       	mov    $0x0,%eax
  80316b:	5b                   	pop    %rbx
  80316c:	41 5c                	pop    %r12
  80316e:	5d                   	pop    %rbp
  80316f:	c3                   	ret

0000000000803170 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  803170:	f3 0f 1e fa          	endbr64
  803174:	55                   	push   %rbp
  803175:	48 89 e5             	mov    %rsp,%rbp
  803178:	41 54                	push   %r12
  80317a:	53                   	push   %rbx
  80317b:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  80317e:	ba 00 10 00 00       	mov    $0x1000,%edx
  803183:	48 89 fe             	mov    %rdi,%rsi
  803186:	bf 00 00 00 00       	mov    $0x0,%edi
  80318b:	49 bc f3 19 80 00 00 	movabs $0x8019f3,%r12
  803192:	00 00 00 
  803195:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  803198:	48 89 df             	mov    %rbx,%rdi
  80319b:	48 b8 e9 1d 80 00 00 	movabs $0x801de9,%rax
  8031a2:	00 00 00 
  8031a5:	ff d0                	call   *%rax
  8031a7:	48 89 c6             	mov    %rax,%rsi
  8031aa:	ba 00 10 00 00       	mov    $0x1000,%edx
  8031af:	bf 00 00 00 00       	mov    $0x0,%edi
  8031b4:	41 ff d4             	call   *%r12
}
  8031b7:	5b                   	pop    %rbx
  8031b8:	41 5c                	pop    %r12
  8031ba:	5d                   	pop    %rbp
  8031bb:	c3                   	ret

00000000008031bc <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  8031bc:	f3 0f 1e fa          	endbr64
  8031c0:	55                   	push   %rbp
  8031c1:	48 89 e5             	mov    %rsp,%rbp
  8031c4:	41 57                	push   %r15
  8031c6:	41 56                	push   %r14
  8031c8:	41 55                	push   %r13
  8031ca:	41 54                	push   %r12
  8031cc:	53                   	push   %rbx
  8031cd:	48 83 ec 18          	sub    $0x18,%rsp
  8031d1:	49 89 fc             	mov    %rdi,%r12
  8031d4:	49 89 f5             	mov    %rsi,%r13
  8031d7:	49 89 d7             	mov    %rdx,%r15
  8031da:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8031de:	48 b8 e9 1d 80 00 00 	movabs $0x801de9,%rax
  8031e5:	00 00 00 
  8031e8:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  8031ea:	4d 85 ff             	test   %r15,%r15
  8031ed:	0f 84 af 00 00 00    	je     8032a2 <devpipe_write+0xe6>
  8031f3:	48 89 c3             	mov    %rax,%rbx
  8031f6:	4c 89 f8             	mov    %r15,%rax
  8031f9:	4d 89 ef             	mov    %r13,%r15
  8031fc:	4c 01 e8             	add    %r13,%rax
  8031ff:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  803203:	49 bd 83 18 80 00 00 	movabs $0x801883,%r13
  80320a:	00 00 00 
            sys_yield();
  80320d:	49 be 18 18 80 00 00 	movabs $0x801818,%r14
  803214:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  803217:	8b 73 04             	mov    0x4(%rbx),%esi
  80321a:	48 63 ce             	movslq %esi,%rcx
  80321d:	48 63 03             	movslq (%rbx),%rax
  803220:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  803226:	48 39 c1             	cmp    %rax,%rcx
  803229:	72 2e                	jb     803259 <devpipe_write+0x9d>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80322b:	b9 00 10 00 00       	mov    $0x1000,%ecx
  803230:	48 89 da             	mov    %rbx,%rdx
  803233:	be 00 10 00 00       	mov    $0x1000,%esi
  803238:	4c 89 e7             	mov    %r12,%rdi
  80323b:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  80323e:	85 c0                	test   %eax,%eax
  803240:	74 66                	je     8032a8 <devpipe_write+0xec>
            sys_yield();
  803242:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  803245:	8b 73 04             	mov    0x4(%rbx),%esi
  803248:	48 63 ce             	movslq %esi,%rcx
  80324b:	48 63 03             	movslq (%rbx),%rax
  80324e:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  803254:	48 39 c1             	cmp    %rax,%rcx
  803257:	73 d2                	jae    80322b <devpipe_write+0x6f>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803259:	41 0f b6 3f          	movzbl (%r15),%edi
  80325d:	48 89 ca             	mov    %rcx,%rdx
  803260:	48 c1 ea 03          	shr    $0x3,%rdx
  803264:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  80326b:	08 10 20 
  80326e:	48 f7 e2             	mul    %rdx
  803271:	48 c1 ea 06          	shr    $0x6,%rdx
  803275:	48 89 d0             	mov    %rdx,%rax
  803278:	48 c1 e0 09          	shl    $0x9,%rax
  80327c:	48 29 d0             	sub    %rdx,%rax
  80327f:	48 c1 e0 03          	shl    $0x3,%rax
  803283:	48 29 c1             	sub    %rax,%rcx
  803286:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  80328b:	83 c6 01             	add    $0x1,%esi
  80328e:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  803291:	49 83 c7 01          	add    $0x1,%r15
  803295:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803299:	49 39 c7             	cmp    %rax,%r15
  80329c:	0f 85 75 ff ff ff    	jne    803217 <devpipe_write+0x5b>
    return n;
  8032a2:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8032a6:	eb 05                	jmp    8032ad <devpipe_write+0xf1>
            if (_pipeisclosed(fd, p)) return 0;
  8032a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8032ad:	48 83 c4 18          	add    $0x18,%rsp
  8032b1:	5b                   	pop    %rbx
  8032b2:	41 5c                	pop    %r12
  8032b4:	41 5d                	pop    %r13
  8032b6:	41 5e                	pop    %r14
  8032b8:	41 5f                	pop    %r15
  8032ba:	5d                   	pop    %rbp
  8032bb:	c3                   	ret

00000000008032bc <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  8032bc:	f3 0f 1e fa          	endbr64
  8032c0:	55                   	push   %rbp
  8032c1:	48 89 e5             	mov    %rsp,%rbp
  8032c4:	41 57                	push   %r15
  8032c6:	41 56                	push   %r14
  8032c8:	41 55                	push   %r13
  8032ca:	41 54                	push   %r12
  8032cc:	53                   	push   %rbx
  8032cd:	48 83 ec 18          	sub    $0x18,%rsp
  8032d1:	49 89 fc             	mov    %rdi,%r12
  8032d4:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  8032d8:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8032dc:	48 b8 e9 1d 80 00 00 	movabs $0x801de9,%rax
  8032e3:	00 00 00 
  8032e6:	ff d0                	call   *%rax
  8032e8:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  8032eb:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8032f1:	49 bd 83 18 80 00 00 	movabs $0x801883,%r13
  8032f8:	00 00 00 
            sys_yield();
  8032fb:	49 be 18 18 80 00 00 	movabs $0x801818,%r14
  803302:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  803305:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80330a:	74 7d                	je     803389 <devpipe_read+0xcd>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  80330c:	8b 03                	mov    (%rbx),%eax
  80330e:	3b 43 04             	cmp    0x4(%rbx),%eax
  803311:	75 26                	jne    803339 <devpipe_read+0x7d>
            if (i > 0) return i;
  803313:	4d 85 ff             	test   %r15,%r15
  803316:	75 77                	jne    80338f <devpipe_read+0xd3>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  803318:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80331d:	48 89 da             	mov    %rbx,%rdx
  803320:	be 00 10 00 00       	mov    $0x1000,%esi
  803325:	4c 89 e7             	mov    %r12,%rdi
  803328:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  80332b:	85 c0                	test   %eax,%eax
  80332d:	74 72                	je     8033a1 <devpipe_read+0xe5>
            sys_yield();
  80332f:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  803332:	8b 03                	mov    (%rbx),%eax
  803334:	3b 43 04             	cmp    0x4(%rbx),%eax
  803337:	74 df                	je     803318 <devpipe_read+0x5c>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803339:	48 63 c8             	movslq %eax,%rcx
  80333c:	48 89 ca             	mov    %rcx,%rdx
  80333f:	48 c1 ea 03          	shr    $0x3,%rdx
  803343:	48 be 81 00 01 02 04 	movabs $0x2010080402010081,%rsi
  80334a:	08 10 20 
  80334d:	48 89 d0             	mov    %rdx,%rax
  803350:	48 f7 e6             	mul    %rsi
  803353:	48 c1 ea 06          	shr    $0x6,%rdx
  803357:	48 89 d0             	mov    %rdx,%rax
  80335a:	48 c1 e0 09          	shl    $0x9,%rax
  80335e:	48 29 d0             	sub    %rdx,%rax
  803361:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803368:	00 
  803369:	48 89 c8             	mov    %rcx,%rax
  80336c:	48 29 d0             	sub    %rdx,%rax
  80336f:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  803374:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  803378:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  80337c:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  80337f:	49 83 c7 01          	add    $0x1,%r15
  803383:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  803387:	75 83                	jne    80330c <devpipe_read+0x50>
    return n;
  803389:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80338d:	eb 03                	jmp    803392 <devpipe_read+0xd6>
            if (i > 0) return i;
  80338f:	4c 89 f8             	mov    %r15,%rax
}
  803392:	48 83 c4 18          	add    $0x18,%rsp
  803396:	5b                   	pop    %rbx
  803397:	41 5c                	pop    %r12
  803399:	41 5d                	pop    %r13
  80339b:	41 5e                	pop    %r14
  80339d:	41 5f                	pop    %r15
  80339f:	5d                   	pop    %rbp
  8033a0:	c3                   	ret
            if (_pipeisclosed(fd, p)) return 0;
  8033a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8033a6:	eb ea                	jmp    803392 <devpipe_read+0xd6>

00000000008033a8 <pipe>:
pipe(int pfd[2]) {
  8033a8:	f3 0f 1e fa          	endbr64
  8033ac:	55                   	push   %rbp
  8033ad:	48 89 e5             	mov    %rsp,%rbp
  8033b0:	41 55                	push   %r13
  8033b2:	41 54                	push   %r12
  8033b4:	53                   	push   %rbx
  8033b5:	48 83 ec 18          	sub    $0x18,%rsp
  8033b9:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  8033bc:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  8033c0:	48 b8 09 1e 80 00 00 	movabs $0x801e09,%rax
  8033c7:	00 00 00 
  8033ca:	ff d0                	call   *%rax
  8033cc:	89 c3                	mov    %eax,%ebx
  8033ce:	85 c0                	test   %eax,%eax
  8033d0:	0f 88 a0 01 00 00    	js     803576 <pipe+0x1ce>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  8033d6:	b9 46 00 00 00       	mov    $0x46,%ecx
  8033db:	ba 00 10 00 00       	mov    $0x1000,%edx
  8033e0:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8033e4:	bf 00 00 00 00       	mov    $0x0,%edi
  8033e9:	48 b8 b3 18 80 00 00 	movabs $0x8018b3,%rax
  8033f0:	00 00 00 
  8033f3:	ff d0                	call   *%rax
  8033f5:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  8033f7:	85 c0                	test   %eax,%eax
  8033f9:	0f 88 77 01 00 00    	js     803576 <pipe+0x1ce>
    if ((res = fd_alloc(&fd1)) < 0 ||
  8033ff:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  803403:	48 b8 09 1e 80 00 00 	movabs $0x801e09,%rax
  80340a:	00 00 00 
  80340d:	ff d0                	call   *%rax
  80340f:	89 c3                	mov    %eax,%ebx
  803411:	85 c0                	test   %eax,%eax
  803413:	0f 88 43 01 00 00    	js     80355c <pipe+0x1b4>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  803419:	b9 46 00 00 00       	mov    $0x46,%ecx
  80341e:	ba 00 10 00 00       	mov    $0x1000,%edx
  803423:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  803427:	bf 00 00 00 00       	mov    $0x0,%edi
  80342c:	48 b8 b3 18 80 00 00 	movabs $0x8018b3,%rax
  803433:	00 00 00 
  803436:	ff d0                	call   *%rax
  803438:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  80343a:	85 c0                	test   %eax,%eax
  80343c:	0f 88 1a 01 00 00    	js     80355c <pipe+0x1b4>
    va = fd2data(fd0);
  803442:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  803446:	48 b8 e9 1d 80 00 00 	movabs $0x801de9,%rax
  80344d:	00 00 00 
  803450:	ff d0                	call   *%rax
  803452:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  803455:	b9 46 00 00 00       	mov    $0x46,%ecx
  80345a:	ba 00 10 00 00       	mov    $0x1000,%edx
  80345f:	48 89 c6             	mov    %rax,%rsi
  803462:	bf 00 00 00 00       	mov    $0x0,%edi
  803467:	48 b8 b3 18 80 00 00 	movabs $0x8018b3,%rax
  80346e:	00 00 00 
  803471:	ff d0                	call   *%rax
  803473:	89 c3                	mov    %eax,%ebx
  803475:	85 c0                	test   %eax,%eax
  803477:	0f 88 c5 00 00 00    	js     803542 <pipe+0x19a>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  80347d:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  803481:	48 b8 e9 1d 80 00 00 	movabs $0x801de9,%rax
  803488:	00 00 00 
  80348b:	ff d0                	call   *%rax
  80348d:	48 89 c1             	mov    %rax,%rcx
  803490:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  803496:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  80349c:	ba 00 00 00 00       	mov    $0x0,%edx
  8034a1:	4c 89 ee             	mov    %r13,%rsi
  8034a4:	bf 00 00 00 00       	mov    $0x0,%edi
  8034a9:	48 b8 1e 19 80 00 00 	movabs $0x80191e,%rax
  8034b0:	00 00 00 
  8034b3:	ff d0                	call   *%rax
  8034b5:	89 c3                	mov    %eax,%ebx
  8034b7:	85 c0                	test   %eax,%eax
  8034b9:	78 6e                	js     803529 <pipe+0x181>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8034bb:	be 00 10 00 00       	mov    $0x1000,%esi
  8034c0:	4c 89 ef             	mov    %r13,%rdi
  8034c3:	48 b8 4d 18 80 00 00 	movabs $0x80184d,%rax
  8034ca:	00 00 00 
  8034cd:	ff d0                	call   *%rax
  8034cf:	83 f8 02             	cmp    $0x2,%eax
  8034d2:	0f 85 ab 00 00 00    	jne    803583 <pipe+0x1db>
    fd0->fd_dev_id = devpipe.dev_id;
  8034d8:	a1 80 50 80 00 00 00 	movabs 0x805080,%eax
  8034df:	00 00 
  8034e1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8034e5:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  8034e7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8034eb:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  8034f2:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8034f6:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  8034f8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034fc:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  803503:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  803507:	48 bb d3 1d 80 00 00 	movabs $0x801dd3,%rbx
  80350e:	00 00 00 
  803511:	ff d3                	call   *%rbx
  803513:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  803517:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  80351b:	ff d3                	call   *%rbx
  80351d:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  803522:	bb 00 00 00 00       	mov    $0x0,%ebx
  803527:	eb 4d                	jmp    803576 <pipe+0x1ce>
    sys_unmap_region(0, va, PAGE_SIZE);
  803529:	ba 00 10 00 00       	mov    $0x1000,%edx
  80352e:	4c 89 ee             	mov    %r13,%rsi
  803531:	bf 00 00 00 00       	mov    $0x0,%edi
  803536:	48 b8 f3 19 80 00 00 	movabs $0x8019f3,%rax
  80353d:	00 00 00 
  803540:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  803542:	ba 00 10 00 00       	mov    $0x1000,%edx
  803547:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80354b:	bf 00 00 00 00       	mov    $0x0,%edi
  803550:	48 b8 f3 19 80 00 00 	movabs $0x8019f3,%rax
  803557:	00 00 00 
  80355a:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  80355c:	ba 00 10 00 00       	mov    $0x1000,%edx
  803561:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  803565:	bf 00 00 00 00       	mov    $0x0,%edi
  80356a:	48 b8 f3 19 80 00 00 	movabs $0x8019f3,%rax
  803571:	00 00 00 
  803574:	ff d0                	call   *%rax
}
  803576:	89 d8                	mov    %ebx,%eax
  803578:	48 83 c4 18          	add    $0x18,%rsp
  80357c:	5b                   	pop    %rbx
  80357d:	41 5c                	pop    %r12
  80357f:	41 5d                	pop    %r13
  803581:	5d                   	pop    %rbp
  803582:	c3                   	ret
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  803583:	48 b9 88 41 80 00 00 	movabs $0x804188,%rcx
  80358a:	00 00 00 
  80358d:	48 ba e3 44 80 00 00 	movabs $0x8044e3,%rdx
  803594:	00 00 00 
  803597:	be 2e 00 00 00       	mov    $0x2e,%esi
  80359c:	48 bf 78 45 80 00 00 	movabs $0x804578,%rdi
  8035a3:	00 00 00 
  8035a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8035ab:	49 b8 09 08 80 00 00 	movabs $0x800809,%r8
  8035b2:	00 00 00 
  8035b5:	41 ff d0             	call   *%r8

00000000008035b8 <pipeisclosed>:
pipeisclosed(int fdnum) {
  8035b8:	f3 0f 1e fa          	endbr64
  8035bc:	55                   	push   %rbp
  8035bd:	48 89 e5             	mov    %rsp,%rbp
  8035c0:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8035c4:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8035c8:	48 b8 6d 1e 80 00 00 	movabs $0x801e6d,%rax
  8035cf:	00 00 00 
  8035d2:	ff d0                	call   *%rax
    if (res < 0) return res;
  8035d4:	85 c0                	test   %eax,%eax
  8035d6:	78 35                	js     80360d <pipeisclosed+0x55>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  8035d8:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8035dc:	48 b8 e9 1d 80 00 00 	movabs $0x801de9,%rax
  8035e3:	00 00 00 
  8035e6:	ff d0                	call   *%rax
  8035e8:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8035eb:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8035f0:	be 00 10 00 00       	mov    $0x1000,%esi
  8035f5:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8035f9:	48 b8 83 18 80 00 00 	movabs $0x801883,%rax
  803600:	00 00 00 
  803603:	ff d0                	call   *%rax
  803605:	85 c0                	test   %eax,%eax
  803607:	0f 94 c0             	sete   %al
  80360a:	0f b6 c0             	movzbl %al,%eax
}
  80360d:	c9                   	leave
  80360e:	c3                   	ret

000000000080360f <wait>:
#include <inc/lib.h>

/* Waits until 'envid' exits. */
void
wait(envid_t envid) {
  80360f:	f3 0f 1e fa          	endbr64
  803613:	55                   	push   %rbp
  803614:	48 89 e5             	mov    %rsp,%rbp
  803617:	41 55                	push   %r13
  803619:	41 54                	push   %r12
  80361b:	53                   	push   %rbx
  80361c:	48 83 ec 08          	sub    $0x8,%rsp
    assert(envid != 0);
  803620:	85 ff                	test   %edi,%edi
  803622:	74 7d                	je     8036a1 <wait+0x92>
  803624:	41 89 fc             	mov    %edi,%r12d

    const volatile struct Env *env = &envs[ENVX(envid)];
  803627:	89 f8                	mov    %edi,%eax
  803629:	25 ff 03 00 00       	and    $0x3ff,%eax

    while (env->env_id == envid &&
  80362e:	89 fa                	mov    %edi,%edx
  803630:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  803636:	48 8d 0c d2          	lea    (%rdx,%rdx,8),%rcx
  80363a:	48 8d 0c 4a          	lea    (%rdx,%rcx,2),%rcx
  80363e:	48 c1 e1 04          	shl    $0x4,%rcx
  803642:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  803649:	00 00 00 
  80364c:	48 01 ca             	add    %rcx,%rdx
  80364f:	8b 92 c8 00 00 00    	mov    0xc8(%rdx),%edx
  803655:	39 d7                	cmp    %edx,%edi
  803657:	75 3d                	jne    803696 <wait+0x87>
           env->env_status != ENV_FREE) {
  803659:	48 98                	cltq
  80365b:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  80365f:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  803663:	48 c1 e0 04          	shl    $0x4,%rax
  803667:	48 bb 00 00 a0 1f 80 	movabs $0x801fa00000,%rbx
  80366e:	00 00 00 
  803671:	48 01 c3             	add    %rax,%rbx
        sys_yield();
  803674:	49 bd 18 18 80 00 00 	movabs $0x801818,%r13
  80367b:	00 00 00 
           env->env_status != ENV_FREE) {
  80367e:	8b 83 d4 00 00 00    	mov    0xd4(%rbx),%eax
    while (env->env_id == envid &&
  803684:	85 c0                	test   %eax,%eax
  803686:	74 0e                	je     803696 <wait+0x87>
        sys_yield();
  803688:	41 ff d5             	call   *%r13
    while (env->env_id == envid &&
  80368b:	8b 83 c8 00 00 00    	mov    0xc8(%rbx),%eax
  803691:	44 39 e0             	cmp    %r12d,%eax
  803694:	74 e8                	je     80367e <wait+0x6f>
    }
}
  803696:	48 83 c4 08          	add    $0x8,%rsp
  80369a:	5b                   	pop    %rbx
  80369b:	41 5c                	pop    %r12
  80369d:	41 5d                	pop    %r13
  80369f:	5d                   	pop    %rbp
  8036a0:	c3                   	ret
    assert(envid != 0);
  8036a1:	48 b9 88 45 80 00 00 	movabs $0x804588,%rcx
  8036a8:	00 00 00 
  8036ab:	48 ba e3 44 80 00 00 	movabs $0x8044e3,%rdx
  8036b2:	00 00 00 
  8036b5:	be 06 00 00 00       	mov    $0x6,%esi
  8036ba:	48 bf 93 45 80 00 00 	movabs $0x804593,%rdi
  8036c1:	00 00 00 
  8036c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8036c9:	49 b8 09 08 80 00 00 	movabs $0x800809,%r8
  8036d0:	00 00 00 
  8036d3:	41 ff d0             	call   *%r8

00000000008036d6 <get_uvpt_entry>:
extern volatile pde_t uvpd[];     /* VA of current page directory */
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
  8036d6:	f3 0f 1e fa          	endbr64
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8036da:	48 89 f8             	mov    %rdi,%rax
  8036dd:	48 c1 e8 27          	shr    $0x27,%rax
  8036e1:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  8036e8:	7f 00 00 
  8036eb:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8036ef:	f6 c2 01             	test   $0x1,%dl
  8036f2:	74 6d                	je     803761 <get_uvpt_entry+0x8b>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8036f4:	48 89 f8             	mov    %rdi,%rax
  8036f7:	48 c1 e8 1e          	shr    $0x1e,%rax
  8036fb:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  803702:	7f 00 00 
  803705:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  803709:	f6 c2 01             	test   $0x1,%dl
  80370c:	74 62                	je     803770 <get_uvpt_entry+0x9a>
  80370e:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  803715:	7f 00 00 
  803718:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80371c:	f6 c2 80             	test   $0x80,%dl
  80371f:	75 4f                	jne    803770 <get_uvpt_entry+0x9a>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  803721:	48 89 f8             	mov    %rdi,%rax
  803724:	48 c1 e8 15          	shr    $0x15,%rax
  803728:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  80372f:	7f 00 00 
  803732:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  803736:	f6 c2 01             	test   $0x1,%dl
  803739:	74 44                	je     80377f <get_uvpt_entry+0xa9>
  80373b:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  803742:	7f 00 00 
  803745:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  803749:	f6 c2 80             	test   $0x80,%dl
  80374c:	75 31                	jne    80377f <get_uvpt_entry+0xa9>
    return uvpt[VPT(va)];
  80374e:	48 c1 ef 0c          	shr    $0xc,%rdi
  803752:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  803759:	7f 00 00 
  80375c:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  803760:	c3                   	ret
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  803761:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  803768:	7f 00 00 
  80376b:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80376f:	c3                   	ret
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  803770:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  803777:	7f 00 00 
  80377a:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80377e:	c3                   	ret
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  80377f:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  803786:	7f 00 00 
  803789:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80378d:	c3                   	ret

000000000080378e <get_phys_addr>:

uintptr_t
get_phys_addr(void *va) {
  80378e:	f3 0f 1e fa          	endbr64
  803792:	48 89 fa             	mov    %rdi,%rdx
    if (!(uvpml4[VPML4(va)] & PTE_P))
  803795:	48 89 f9             	mov    %rdi,%rcx
  803798:	48 c1 e9 27          	shr    $0x27,%rcx
  80379c:	48 b8 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rax
  8037a3:	7f 00 00 
  8037a6:	48 8b 0c c8          	mov    (%rax,%rcx,8),%rcx
        return -1;
  8037aa:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpml4[VPML4(va)] & PTE_P))
  8037b1:	f6 c1 01             	test   $0x1,%cl
  8037b4:	0f 84 b2 00 00 00    	je     80386c <get_phys_addr+0xde>
    if (!(uvpdp[VPDP(va)] & PTE_P))
  8037ba:	48 89 f9             	mov    %rdi,%rcx
  8037bd:	48 c1 e9 1e          	shr    $0x1e,%rcx
  8037c1:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  8037c8:	7f 00 00 
  8037cb:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  8037cf:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpdp[VPDP(va)] & PTE_P))
  8037d6:	40 f6 c6 01          	test   $0x1,%sil
  8037da:	0f 84 8c 00 00 00    	je     80386c <get_phys_addr+0xde>
    if (uvpdp[VPDP(va)] & PTE_PS)
  8037e0:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  8037e7:	7f 00 00 
  8037ea:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8037ee:	a8 80                	test   $0x80,%al
  8037f0:	75 7b                	jne    80386d <get_phys_addr+0xdf>
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
    if (!(uvpd[VPD(va)] & PTE_P))
  8037f2:	48 89 f9             	mov    %rdi,%rcx
  8037f5:	48 c1 e9 15          	shr    $0x15,%rcx
  8037f9:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  803800:	7f 00 00 
  803803:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  803807:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpd[VPD(va)] & PTE_P))
  80380e:	40 f6 c6 01          	test   $0x1,%sil
  803812:	74 58                	je     80386c <get_phys_addr+0xde>
    if ((uvpd[VPD(va)] & PTE_PS))
  803814:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  80381b:	7f 00 00 
  80381e:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  803822:	a8 80                	test   $0x80,%al
  803824:	75 6c                	jne    803892 <get_phys_addr+0x104>
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
    if (!(uvpt[VPT(va)] & PTE_P))
  803826:	48 89 f9             	mov    %rdi,%rcx
  803829:	48 c1 e9 0c          	shr    $0xc,%rcx
  80382d:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  803834:	7f 00 00 
  803837:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  80383b:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpt[VPT(va)] & PTE_P))
  803842:	40 f6 c6 01          	test   $0x1,%sil
  803846:	74 24                	je     80386c <get_phys_addr+0xde>
    return PTE_ADDR(uvpt[VPT(va)]) + PAGE_OFFSET(va);
  803848:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  80384f:	7f 00 00 
  803852:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  803856:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  80385d:	ff ff 7f 
  803860:	48 21 c8             	and    %rcx,%rax
  803863:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  803869:	48 09 d0             	or     %rdx,%rax
}
  80386c:	c3                   	ret
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
  80386d:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  803874:	7f 00 00 
  803877:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  80387b:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  803882:	ff ff 7f 
  803885:	48 21 c8             	and    %rcx,%rax
  803888:	81 e2 ff ff ff 3f    	and    $0x3fffffff,%edx
  80388e:	48 01 d0             	add    %rdx,%rax
  803891:	c3                   	ret
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
  803892:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  803899:	7f 00 00 
  80389c:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8038a0:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  8038a7:	ff ff 7f 
  8038aa:	48 21 c8             	and    %rcx,%rax
  8038ad:	81 e2 ff ff 1f 00    	and    $0x1fffff,%edx
  8038b3:	48 01 d0             	add    %rdx,%rax
  8038b6:	c3                   	ret

00000000008038b7 <get_prot>:

int
get_prot(void *va) {
  8038b7:	f3 0f 1e fa          	endbr64
  8038bb:	55                   	push   %rbp
  8038bc:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  8038bf:	48 b8 d6 36 80 00 00 	movabs $0x8036d6,%rax
  8038c6:	00 00 00 
  8038c9:	ff d0                	call   *%rax
  8038cb:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
    if (pte & PTE_P) prot |= PROT_R;
  8038ce:	83 e0 01             	and    $0x1,%eax
  8038d1:	c1 e0 02             	shl    $0x2,%eax
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  8038d4:	89 d1                	mov    %edx,%ecx
  8038d6:	81 e1 00 0a 00 00    	and    $0xa00,%ecx
    if (pte & PTE_P) prot |= PROT_R;
  8038dc:	09 c8                	or     %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  8038de:	89 c1                	mov    %eax,%ecx
  8038e0:	83 c9 02             	or     $0x2,%ecx
  8038e3:	f6 c2 02             	test   $0x2,%dl
  8038e6:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  8038e9:	89 c1                	mov    %eax,%ecx
  8038eb:	83 c9 01             	or     $0x1,%ecx
  8038ee:	48 85 d2             	test   %rdx,%rdx
  8038f1:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  8038f4:	89 c1                	mov    %eax,%ecx
  8038f6:	83 c9 40             	or     $0x40,%ecx
  8038f9:	f6 c6 04             	test   $0x4,%dh
  8038fc:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  8038ff:	5d                   	pop    %rbp
  803900:	c3                   	ret

0000000000803901 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  803901:	f3 0f 1e fa          	endbr64
  803905:	55                   	push   %rbp
  803906:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  803909:	48 b8 d6 36 80 00 00 	movabs $0x8036d6,%rax
  803910:	00 00 00 
  803913:	ff d0                	call   *%rax
    return pte & PTE_D;
  803915:	48 c1 e8 06          	shr    $0x6,%rax
  803919:	83 e0 01             	and    $0x1,%eax
}
  80391c:	5d                   	pop    %rbp
  80391d:	c3                   	ret

000000000080391e <is_page_present>:

bool
is_page_present(void *va) {
  80391e:	f3 0f 1e fa          	endbr64
  803922:	55                   	push   %rbp
  803923:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  803926:	48 b8 d6 36 80 00 00 	movabs $0x8036d6,%rax
  80392d:	00 00 00 
  803930:	ff d0                	call   *%rax
  803932:	83 e0 01             	and    $0x1,%eax
}
  803935:	5d                   	pop    %rbp
  803936:	c3                   	ret

0000000000803937 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  803937:	f3 0f 1e fa          	endbr64
  80393b:	55                   	push   %rbp
  80393c:	48 89 e5             	mov    %rsp,%rbp
  80393f:	41 57                	push   %r15
  803941:	41 56                	push   %r14
  803943:	41 55                	push   %r13
  803945:	41 54                	push   %r12
  803947:	53                   	push   %rbx
  803948:	48 83 ec 18          	sub    $0x18,%rsp
  80394c:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  803950:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
     * NOTE: Skip over larger pages/page directories for efficiency */
    // LAB 11: Your code here:

    int res = 0;
    (void)fun, (void)arg;
    uintptr_t va = 0;
  803954:	bb 00 00 00 00       	mov    $0x0,%ebx
    while (va < USER_STACK_TOP) {
        size_t size = 0;
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  803959:	49 be 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%r14
  803960:	7f 00 00 
            size = 1LL << PML4_SHIFT;
            goto next;
        }

        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  803963:	49 bd 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%r13
  80396a:	7f 00 00 
    while (va < USER_STACK_TOP) {
  80396d:	49 bf ff 6f ff ff 7f 	movabs $0x7fffff6fff,%r15
  803974:	00 00 00 
  803977:	eb 73                	jmp    8039ec <foreach_shared_region+0xb5>
            }

            goto next;
        }

        if (!(uvpd[VPD(va)] & PTE_P)) {
  803979:	48 89 d8             	mov    %rbx,%rax
  80397c:	48 c1 e8 15          	shr    $0x15,%rax
  803980:	48 b9 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rcx
  803987:	7f 00 00 
  80398a:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
            size = 1LL << PD_SHIFT;
  80398e:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
        if (!(uvpd[VPD(va)] & PTE_P)) {
  803994:	f6 c2 01             	test   $0x1,%dl
  803997:	74 4b                	je     8039e4 <foreach_shared_region+0xad>
            goto next;
        }

        if (uvpd[VPD(va)] & PTE_PS) {
  803999:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
  80399d:	f6 c2 80             	test   $0x80,%dl
  8039a0:	74 11                	je     8039b3 <foreach_shared_region+0x7c>
            size = 1LL << PD_SHIFT;
            if (uvpd[VPD(va)] & PTE_SHARE) {
  8039a2:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
  8039a6:	f6 c4 04             	test   $0x4,%ah
  8039a9:	74 39                	je     8039e4 <foreach_shared_region+0xad>
            size = 1LL << PD_SHIFT;
  8039ab:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
  8039b1:	eb 20                	jmp    8039d3 <foreach_shared_region+0x9c>

            goto next;
        }

        size = PAGE_SIZE;
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  8039b3:	48 89 da             	mov    %rbx,%rdx
  8039b6:	48 c1 ea 0c          	shr    $0xc,%rdx
  8039ba:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  8039c1:	7f 00 00 
  8039c4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
        size = PAGE_SIZE;
  8039c8:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  8039ce:	f6 c4 04             	test   $0x4,%ah
  8039d1:	74 11                	je     8039e4 <foreach_shared_region+0xad>
            goto next;
        }

    map:
        fun((void *)va, (void *)(va + size), arg);
  8039d3:	49 8d 34 1c          	lea    (%r12,%rbx,1),%rsi
  8039d7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8039db:	48 89 df             	mov    %rbx,%rdi
  8039de:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8039e2:	ff d0                	call   *%rax
    next:
        va += size;
  8039e4:	4c 01 e3             	add    %r12,%rbx
    while (va < USER_STACK_TOP) {
  8039e7:	49 39 df             	cmp    %rbx,%r15
  8039ea:	72 3e                	jb     803a2a <foreach_shared_region+0xf3>
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  8039ec:	49 8b 06             	mov    (%r14),%rax
  8039ef:	a8 01                	test   $0x1,%al
  8039f1:	74 37                	je     803a2a <foreach_shared_region+0xf3>
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  8039f3:	48 89 d8             	mov    %rbx,%rax
  8039f6:	48 c1 e8 1e          	shr    $0x1e,%rax
  8039fa:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
            size = 1LL << PDP_SHIFT;
  8039ff:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  803a05:	f6 c2 01             	test   $0x1,%dl
  803a08:	74 da                	je     8039e4 <foreach_shared_region+0xad>
        if (uvpdp[VPDP(va)] & PTE_PS) {
  803a0a:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
  803a0f:	f6 c2 80             	test   $0x80,%dl
  803a12:	0f 84 61 ff ff ff    	je     803979 <foreach_shared_region+0x42>
            if (uvpdp[VPDP(va)] & PTE_SHARE) {
  803a18:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  803a1d:	f6 c4 04             	test   $0x4,%ah
  803a20:	74 c2                	je     8039e4 <foreach_shared_region+0xad>
            size = 1LL << PDP_SHIFT;
  803a22:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
  803a28:	eb a9                	jmp    8039d3 <foreach_shared_region+0x9c>
    }
    return res;
}
  803a2a:	b8 00 00 00 00       	mov    $0x0,%eax
  803a2f:	48 83 c4 18          	add    $0x18,%rsp
  803a33:	5b                   	pop    %rbx
  803a34:	41 5c                	pop    %r12
  803a36:	41 5d                	pop    %r13
  803a38:	41 5e                	pop    %r14
  803a3a:	41 5f                	pop    %r15
  803a3c:	5d                   	pop    %rbp
  803a3d:	c3                   	ret

0000000000803a3e <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
    # Call the C page fault handler.
    movq  %rsp,%rdi # passing the function argument in rdi
  803a3e:	48 89 e7             	mov    %rsp,%rdi
    movabs $_handle_vectored_pagefault, %rax
  803a41:	48 b8 7d 3c 80 00 00 	movabs $0x803c7d,%rax
  803a48:	00 00 00 
    call *%rax
  803a4b:	ff d0                	call   *%rax
    # registers are available for intermediate calculations.  You
    # may find that you have to rearrange your code in non-obvious
    # ways as registers become unavailable as scratch space.

    # LAB 9: Your code here
    movq %rsp, %rax
  803a4d:	48 89 e0             	mov    %rsp,%rax
    movq UTRAP_RIP(%rsp), %rbx
  803a50:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  803a57:	00 
    movq UTRAP_RSP(%rsp), %rsp
  803a58:	48 8b a4 24 98 00 00 	mov    0x98(%rsp),%rsp
  803a5f:	00 
    pushq %rbx
  803a60:	53                   	push   %rbx
    movq %rsp, UTRAP_RSP(%rax)
  803a61:	48 89 a0 98 00 00 00 	mov    %rsp,0x98(%rax)

    # Restore the trap-time registers.  After you do this, you
    # can no longer modify any general-purpose registers (use POPA macro).
    # LAB 9: Your code here
    movq %rax, %rsp
  803a68:	48 89 c4             	mov    %rax,%rsp
    addq $16, %rsp
  803a6b:	48 83 c4 10          	add    $0x10,%rsp
    POPA
  803a6f:	4c 8b 3c 24          	mov    (%rsp),%r15
  803a73:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  803a78:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  803a7d:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  803a82:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  803a87:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  803a8c:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  803a91:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  803a96:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  803a9b:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  803aa0:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  803aa5:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  803aaa:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  803aaf:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  803ab4:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  803ab9:	48 83 c4 78          	add    $0x78,%rsp
    addq $8, %rsp
  803abd:	48 83 c4 08          	add    $0x8,%rsp
    # Restore rflags from the stack.  After you do this, you can
    # no longer use arithmetic operations or anything else that
    # modifies rflags.
    # LAB 9: Your code here
	popfq
  803ac1:	9d                   	popf
    # Switch back to the adjusted trap-time stack.
    # LAB 9: Your code here
	popq %rsp
  803ac2:	5c                   	pop    %rsp
    # Return to re-execute the instruction that faulted.
    ret
  803ac3:	c3                   	ret

0000000000803ac4 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  803ac4:	f3 0f 1e fa          	endbr64
  803ac8:	55                   	push   %rbp
  803ac9:	48 89 e5             	mov    %rsp,%rbp
  803acc:	41 54                	push   %r12
  803ace:	53                   	push   %rbx
  803acf:	48 89 fb             	mov    %rdi,%rbx
  803ad2:	48 89 f7             	mov    %rsi,%rdi
  803ad5:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  803ad8:	48 85 f6             	test   %rsi,%rsi
  803adb:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  803ae2:	00 00 00 
  803ae5:	48 0f 44 f8          	cmove  %rax,%rdi
    }
    int res = sys_ipc_recv(pg, PAGE_SIZE);
  803ae9:	be 00 10 00 00       	mov    $0x1000,%esi
  803aee:	48 b8 d5 1b 80 00 00 	movabs $0x801bd5,%rax
  803af5:	00 00 00 
  803af8:	ff d0                	call   *%rax
    if (res < 0) {
  803afa:	85 c0                	test   %eax,%eax
  803afc:	78 45                	js     803b43 <ipc_recv+0x7f>
        if (perm_store != NULL) {
            *perm_store = 0;
        }
        return res;
    } else {
        if (from_env_store != NULL) {
  803afe:	48 85 db             	test   %rbx,%rbx
  803b01:	74 12                	je     803b15 <ipc_recv+0x51>
            *from_env_store = thisenv->env_ipc_from;
  803b03:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  803b0a:	00 00 00 
  803b0d:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  803b13:	89 03                	mov    %eax,(%rbx)
        }
        if (perm_store != NULL) {
  803b15:	4d 85 e4             	test   %r12,%r12
  803b18:	74 14                	je     803b2e <ipc_recv+0x6a>
            *perm_store = thisenv->env_ipc_perm;
  803b1a:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  803b21:	00 00 00 
  803b24:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  803b2a:	41 89 04 24          	mov    %eax,(%r12)
        }
        return thisenv->env_ipc_value;
  803b2e:	48 a1 00 60 80 00 00 	movabs 0x806000,%rax
  803b35:	00 00 00 
  803b38:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
    }
    return -1;
}
  803b3e:	5b                   	pop    %rbx
  803b3f:	41 5c                	pop    %r12
  803b41:	5d                   	pop    %rbp
  803b42:	c3                   	ret
        if (from_env_store != NULL) {
  803b43:	48 85 db             	test   %rbx,%rbx
  803b46:	74 06                	je     803b4e <ipc_recv+0x8a>
            *from_env_store = 0;
  803b48:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store != NULL) {
  803b4e:	4d 85 e4             	test   %r12,%r12
  803b51:	74 eb                	je     803b3e <ipc_recv+0x7a>
            *perm_store = 0;
  803b53:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  803b5a:	00 
  803b5b:	eb e1                	jmp    803b3e <ipc_recv+0x7a>

0000000000803b5d <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  803b5d:	f3 0f 1e fa          	endbr64
  803b61:	55                   	push   %rbp
  803b62:	48 89 e5             	mov    %rsp,%rbp
  803b65:	41 57                	push   %r15
  803b67:	41 56                	push   %r14
  803b69:	41 55                	push   %r13
  803b6b:	41 54                	push   %r12
  803b6d:	53                   	push   %rbx
  803b6e:	48 83 ec 18          	sub    $0x18,%rsp
  803b72:	89 7d c4             	mov    %edi,-0x3c(%rbp)
  803b75:	48 89 d3             	mov    %rdx,%rbx
  803b78:	49 89 cc             	mov    %rcx,%r12
  803b7b:	45 89 c5             	mov    %r8d,%r13d
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  803b7e:	48 85 d2             	test   %rdx,%rdx
  803b81:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  803b88:	00 00 00 
  803b8b:	48 0f 44 d8          	cmove  %rax,%rbx
    }
    int res = sys_ipc_try_send(to_env, val, pg, size, perm);
  803b8f:	89 f0                	mov    %esi,%eax
  803b91:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  803b95:	48 89 da             	mov    %rbx,%rdx
  803b98:	48 89 c6             	mov    %rax,%rsi
  803b9b:	48 b8 a5 1b 80 00 00 	movabs $0x801ba5,%rax
  803ba2:	00 00 00 
  803ba5:	ff d0                	call   *%rax
    while (res < 0) {
  803ba7:	85 c0                	test   %eax,%eax
  803ba9:	79 65                	jns    803c10 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  803bab:	83 f8 f5             	cmp    $0xfffffff5,%eax
  803bae:	75 33                	jne    803be3 <ipc_send+0x86>
            panic("Error: %i\n", res);
        }
        sys_yield();
  803bb0:	49 bf 18 18 80 00 00 	movabs $0x801818,%r15
  803bb7:	00 00 00 
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  803bba:	49 be a5 1b 80 00 00 	movabs $0x801ba5,%r14
  803bc1:	00 00 00 
        sys_yield();
  803bc4:	41 ff d7             	call   *%r15
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  803bc7:	45 89 e8             	mov    %r13d,%r8d
  803bca:	4c 89 e1             	mov    %r12,%rcx
  803bcd:	48 89 da             	mov    %rbx,%rdx
  803bd0:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  803bd4:	8b 7d c4             	mov    -0x3c(%rbp),%edi
  803bd7:	41 ff d6             	call   *%r14
    while (res < 0) {
  803bda:	85 c0                	test   %eax,%eax
  803bdc:	79 32                	jns    803c10 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  803bde:	83 f8 f5             	cmp    $0xfffffff5,%eax
  803be1:	74 e1                	je     803bc4 <ipc_send+0x67>
            panic("Error: %i\n", res);
  803be3:	89 c1                	mov    %eax,%ecx
  803be5:	48 ba 9e 45 80 00 00 	movabs $0x80459e,%rdx
  803bec:	00 00 00 
  803bef:	be 42 00 00 00       	mov    $0x42,%esi
  803bf4:	48 bf a9 45 80 00 00 	movabs $0x8045a9,%rdi
  803bfb:	00 00 00 
  803bfe:	b8 00 00 00 00       	mov    $0x0,%eax
  803c03:	49 b8 09 08 80 00 00 	movabs $0x800809,%r8
  803c0a:	00 00 00 
  803c0d:	41 ff d0             	call   *%r8
    }
}
  803c10:	48 83 c4 18          	add    $0x18,%rsp
  803c14:	5b                   	pop    %rbx
  803c15:	41 5c                	pop    %r12
  803c17:	41 5d                	pop    %r13
  803c19:	41 5e                	pop    %r14
  803c1b:	41 5f                	pop    %r15
  803c1d:	5d                   	pop    %rbp
  803c1e:	c3                   	ret

0000000000803c1f <ipc_find_env>:

/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
  803c1f:	f3 0f 1e fa          	endbr64
    for (size_t i = 0; i < NENV; i++)
  803c23:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  803c28:	48 b9 00 00 a0 1f 80 	movabs $0x801fa00000,%rcx
  803c2f:	00 00 00 
  803c32:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  803c36:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  803c3a:	48 c1 e2 04          	shl    $0x4,%rdx
  803c3e:	48 01 ca             	add    %rcx,%rdx
  803c41:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  803c47:	39 fa                	cmp    %edi,%edx
  803c49:	74 12                	je     803c5d <ipc_find_env+0x3e>
    for (size_t i = 0; i < NENV; i++)
  803c4b:	48 83 c0 01          	add    $0x1,%rax
  803c4f:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  803c55:	75 db                	jne    803c32 <ipc_find_env+0x13>
            return envs[i].env_id;
    return 0;
  803c57:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803c5c:	c3                   	ret
            return envs[i].env_id;
  803c5d:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  803c61:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  803c65:	48 c1 e2 04          	shl    $0x4,%rdx
  803c69:	48 b8 00 00 a0 1f 80 	movabs $0x801fa00000,%rax
  803c70:	00 00 00 
  803c73:	48 01 d0             	add    %rdx,%rax
  803c76:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803c7c:	c3                   	ret

0000000000803c7d <_handle_vectored_pagefault>:
/* Vector size */
static size_t _pfhandler_off = 0;
static bool _pfhandler_inititiallized = 0;

void
_handle_vectored_pagefault(struct UTrapframe *utf) {
  803c7d:	f3 0f 1e fa          	endbr64
  803c81:	55                   	push   %rbp
  803c82:	48 89 e5             	mov    %rsp,%rbp
  803c85:	41 56                	push   %r14
  803c87:	41 55                	push   %r13
  803c89:	41 54                	push   %r12
  803c8b:	53                   	push   %rbx
  803c8c:	49 89 fc             	mov    %rdi,%r12
    /* This trying to handle pagefault until
     * some handler returns 1, that indicates
     * successfully handled exception */
    for (size_t i = 0; i < _pfhandler_off; i++)
  803c8f:	48 b8 68 80 80 00 00 	movabs $0x808068,%rax
  803c96:	00 00 00 
  803c99:	48 83 38 00          	cmpq   $0x0,(%rax)
  803c9d:	74 27                	je     803cc6 <_handle_vectored_pagefault+0x49>
  803c9f:	bb 00 00 00 00       	mov    $0x0,%ebx
        if (_pfhandler_vec[i](utf)) return;
  803ca4:	49 bd 20 80 80 00 00 	movabs $0x808020,%r13
  803cab:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++)
  803cae:	49 89 c6             	mov    %rax,%r14
        if (_pfhandler_vec[i](utf)) return;
  803cb1:	4c 89 e7             	mov    %r12,%rdi
  803cb4:	41 ff 54 dd 00       	call   *0x0(%r13,%rbx,8)
  803cb9:	84 c0                	test   %al,%al
  803cbb:	75 45                	jne    803d02 <_handle_vectored_pagefault+0x85>
    for (size_t i = 0; i < _pfhandler_off; i++)
  803cbd:	48 83 c3 01          	add    $0x1,%rbx
  803cc1:	49 3b 1e             	cmp    (%r14),%rbx
  803cc4:	72 eb                	jb     803cb1 <_handle_vectored_pagefault+0x34>

    /* Unhandled exceptions just cause panic */
    panic("Userspace page fault rip=%08lX va=%08lX err=%x\n",
  803cc6:	49 8b 8c 24 88 00 00 	mov    0x88(%r12),%rcx
  803ccd:	00 
  803cce:	45 8b 4c 24 08       	mov    0x8(%r12),%r9d
  803cd3:	4d 8b 04 24          	mov    (%r12),%r8
  803cd7:	48 ba b0 41 80 00 00 	movabs $0x8041b0,%rdx
  803cde:	00 00 00 
  803ce1:	be 1d 00 00 00       	mov    $0x1d,%esi
  803ce6:	48 bf b3 45 80 00 00 	movabs $0x8045b3,%rdi
  803ced:	00 00 00 
  803cf0:	b8 00 00 00 00       	mov    $0x0,%eax
  803cf5:	49 ba 09 08 80 00 00 	movabs $0x800809,%r10
  803cfc:	00 00 00 
  803cff:	41 ff d2             	call   *%r10
          utf->utf_rip, utf->utf_fault_va, (int)utf->utf_err);
}
  803d02:	5b                   	pop    %rbx
  803d03:	41 5c                	pop    %r12
  803d05:	41 5d                	pop    %r13
  803d07:	41 5e                	pop    %r14
  803d09:	5d                   	pop    %rbp
  803d0a:	c3                   	ret

0000000000803d0b <add_pgfault_handler>:
 * The first time we register a handler, we need to
 * allocate an exception stack (one page of memory with its top
 * at USER_EXCEPTION_STACK_TOP), and tell the kernel to call the assembly-language
 * _pgfault_upcall routine when a page fault occurs. */
int
add_pgfault_handler(pf_handler_t handler) {
  803d0b:	f3 0f 1e fa          	endbr64
  803d0f:	55                   	push   %rbp
  803d10:	48 89 e5             	mov    %rsp,%rbp
  803d13:	53                   	push   %rbx
  803d14:	48 83 ec 08          	sub    $0x8,%rsp
  803d18:	48 89 fb             	mov    %rdi,%rbx
    int res = 0;
    if (!_pfhandler_inititiallized) {
  803d1b:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  803d22:	00 00 00 
  803d25:	80 38 00             	cmpb   $0x0,(%rax)
  803d28:	0f 84 84 00 00 00    	je     803db2 <add_pgfault_handler+0xa7>
        _pfhandler_vec[_pfhandler_off++] = handler;
        _pfhandler_inititiallized = 1;
        goto end;
    }

    for (size_t i = 0; i < _pfhandler_off; i++)
  803d2e:	48 b8 68 80 80 00 00 	movabs $0x808068,%rax
  803d35:	00 00 00 
  803d38:	48 8b 10             	mov    (%rax),%rdx
  803d3b:	b8 00 00 00 00       	mov    $0x0,%eax
        if (handler == _pfhandler_vec[i]) return 0;
  803d40:	48 b9 20 80 80 00 00 	movabs $0x808020,%rcx
  803d47:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++)
  803d4a:	48 85 d2             	test   %rdx,%rdx
  803d4d:	74 19                	je     803d68 <add_pgfault_handler+0x5d>
        if (handler == _pfhandler_vec[i]) return 0;
  803d4f:	48 39 1c c1          	cmp    %rbx,(%rcx,%rax,8)
  803d53:	0f 84 e8 00 00 00    	je     803e41 <add_pgfault_handler+0x136>
    for (size_t i = 0; i < _pfhandler_off; i++)
  803d59:	48 83 c0 01          	add    $0x1,%rax
  803d5d:	48 39 d0             	cmp    %rdx,%rax
  803d60:	75 ed                	jne    803d4f <add_pgfault_handler+0x44>

    if (_pfhandler_off == MAX_PFHANDLER)
  803d62:	48 83 fa 08          	cmp    $0x8,%rdx
  803d66:	74 1c                	je     803d84 <add_pgfault_handler+0x79>
        res = -E_INVAL;
    else
        _pfhandler_vec[_pfhandler_off++] = handler;
  803d68:	48 8d 42 01          	lea    0x1(%rdx),%rax
  803d6c:	48 a3 68 80 80 00 00 	movabs %rax,0x808068
  803d73:	00 00 00 
  803d76:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  803d7d:	00 00 00 
  803d80:	48 89 1c d0          	mov    %rbx,(%rax,%rdx,8)

end:
    res = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  803d84:	48 b8 e3 17 80 00 00 	movabs $0x8017e3,%rax
  803d8b:	00 00 00 
  803d8e:	ff d0                	call   *%rax
  803d90:	89 c7                	mov    %eax,%edi
  803d92:	48 be 3e 3a 80 00 00 	movabs $0x803a3e,%rsi
  803d99:	00 00 00 
  803d9c:	48 b8 38 1b 80 00 00 	movabs $0x801b38,%rax
  803da3:	00 00 00 
  803da6:	ff d0                	call   *%rax
    if (res < 0) panic("set_pgfault_handler: %i", res);
  803da8:	85 c0                	test   %eax,%eax
  803daa:	78 68                	js     803e14 <add_pgfault_handler+0x109>
    return res;
}
  803dac:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  803db0:	c9                   	leave
  803db1:	c3                   	ret
        res = sys_alloc_region(sys_getenvid(), (void*)(USER_EXCEPTION_STACK_TOP - PAGE_SIZE), PAGE_SIZE, PROT_RW);
  803db2:	48 b8 e3 17 80 00 00 	movabs $0x8017e3,%rax
  803db9:	00 00 00 
  803dbc:	ff d0                	call   *%rax
  803dbe:	89 c7                	mov    %eax,%edi
  803dc0:	b9 06 00 00 00       	mov    $0x6,%ecx
  803dc5:	ba 00 10 00 00       	mov    $0x1000,%edx
  803dca:	48 be 00 f0 ff ff 7f 	movabs $0x7ffffff000,%rsi
  803dd1:	00 00 00 
  803dd4:	48 b8 b3 18 80 00 00 	movabs $0x8018b3,%rax
  803ddb:	00 00 00 
  803dde:	ff d0                	call   *%rax
        _pfhandler_vec[_pfhandler_off++] = handler;
  803de0:	48 ba 68 80 80 00 00 	movabs $0x808068,%rdx
  803de7:	00 00 00 
  803dea:	48 8b 02             	mov    (%rdx),%rax
  803ded:	48 8d 48 01          	lea    0x1(%rax),%rcx
  803df1:	48 89 0a             	mov    %rcx,(%rdx)
  803df4:	48 ba 20 80 80 00 00 	movabs $0x808020,%rdx
  803dfb:	00 00 00 
  803dfe:	48 89 1c c2          	mov    %rbx,(%rdx,%rax,8)
        _pfhandler_inititiallized = 1;
  803e02:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  803e09:	00 00 00 
  803e0c:	c6 00 01             	movb   $0x1,(%rax)
        goto end;
  803e0f:	e9 70 ff ff ff       	jmp    803d84 <add_pgfault_handler+0x79>
    if (res < 0) panic("set_pgfault_handler: %i", res);
  803e14:	89 c1                	mov    %eax,%ecx
  803e16:	48 ba c1 45 80 00 00 	movabs $0x8045c1,%rdx
  803e1d:	00 00 00 
  803e20:	be 3d 00 00 00       	mov    $0x3d,%esi
  803e25:	48 bf b3 45 80 00 00 	movabs $0x8045b3,%rdi
  803e2c:	00 00 00 
  803e2f:	b8 00 00 00 00       	mov    $0x0,%eax
  803e34:	49 b8 09 08 80 00 00 	movabs $0x800809,%r8
  803e3b:	00 00 00 
  803e3e:	41 ff d0             	call   *%r8
        if (handler == _pfhandler_vec[i]) return 0;
  803e41:	b8 00 00 00 00       	mov    $0x0,%eax
  803e46:	e9 61 ff ff ff       	jmp    803dac <add_pgfault_handler+0xa1>

0000000000803e4b <remove_pgfault_handler>:

void
remove_pgfault_handler(pf_handler_t handler) {
  803e4b:	f3 0f 1e fa          	endbr64
  803e4f:	55                   	push   %rbp
  803e50:	48 89 e5             	mov    %rsp,%rbp
    assert(_pfhandler_inititiallized);
  803e53:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  803e5a:	00 00 00 
  803e5d:	80 38 00             	cmpb   $0x0,(%rax)
  803e60:	74 33                	je     803e95 <remove_pgfault_handler+0x4a>
    for (size_t i = 0; i < _pfhandler_off; i++) {
  803e62:	48 a1 68 80 80 00 00 	movabs 0x808068,%rax
  803e69:	00 00 00 
  803e6c:	b9 00 00 00 00       	mov    $0x0,%ecx
        if (_pfhandler_vec[i] == handler) {
  803e71:	48 ba 20 80 80 00 00 	movabs $0x808020,%rdx
  803e78:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++) {
  803e7b:	48 85 c0             	test   %rax,%rax
  803e7e:	0f 84 85 00 00 00    	je     803f09 <remove_pgfault_handler+0xbe>
        if (_pfhandler_vec[i] == handler) {
  803e84:	48 39 3c ca          	cmp    %rdi,(%rdx,%rcx,8)
  803e88:	74 40                	je     803eca <remove_pgfault_handler+0x7f>
    for (size_t i = 0; i < _pfhandler_off; i++) {
  803e8a:	48 83 c1 01          	add    $0x1,%rcx
  803e8e:	48 39 c1             	cmp    %rax,%rcx
  803e91:	75 f1                	jne    803e84 <remove_pgfault_handler+0x39>
  803e93:	eb 74                	jmp    803f09 <remove_pgfault_handler+0xbe>
    assert(_pfhandler_inititiallized);
  803e95:	48 b9 d9 45 80 00 00 	movabs $0x8045d9,%rcx
  803e9c:	00 00 00 
  803e9f:	48 ba e3 44 80 00 00 	movabs $0x8044e3,%rdx
  803ea6:	00 00 00 
  803ea9:	be 43 00 00 00       	mov    $0x43,%esi
  803eae:	48 bf b3 45 80 00 00 	movabs $0x8045b3,%rdi
  803eb5:	00 00 00 
  803eb8:	b8 00 00 00 00       	mov    $0x0,%eax
  803ebd:	49 b8 09 08 80 00 00 	movabs $0x800809,%r8
  803ec4:	00 00 00 
  803ec7:	41 ff d0             	call   *%r8
            memmove(_pfhandler_vec + i, _pfhandler_vec + i + 1, (_pfhandler_off - i - 1) * sizeof(*handler));
  803eca:	48 8d 34 cd 08 00 00 	lea    0x8(,%rcx,8),%rsi
  803ed1:	00 
  803ed2:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  803ed6:	48 29 ca             	sub    %rcx,%rdx
  803ed9:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  803ee0:	00 00 00 
  803ee3:	48 8d 0c 06          	lea    (%rsi,%rax,1),%rcx
  803ee7:	48 8d 7c 30 f8       	lea    -0x8(%rax,%rsi,1),%rdi
  803eec:	48 89 ce             	mov    %rcx,%rsi
  803eef:	48 b8 c9 14 80 00 00 	movabs $0x8014c9,%rax
  803ef6:	00 00 00 
  803ef9:	ff d0                	call   *%rax
            _pfhandler_off--;
  803efb:	48 b8 68 80 80 00 00 	movabs $0x808068,%rax
  803f02:	00 00 00 
  803f05:	48 83 28 01          	subq   $0x1,(%rax)
            return;
        }
    }
}
  803f09:	5d                   	pop    %rbp
  803f0a:	c3                   	ret

0000000000803f0b <__text_end>:
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
