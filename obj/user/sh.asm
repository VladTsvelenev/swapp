
obj/user/sh:     file format elf64-x86-64


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
  80001e:	e8 c2 0a 00 00       	call   800ae5 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <_gettoken>:

#define WHITESPACE " \t\r\n"
#define SYMBOLS    "<|>&;()"

int
_gettoken(char *s, char **p1, char **p2) {
  800025:	f3 0f 1e fa          	endbr64
    int t;

    if (s == 0) {
  800029:	48 85 ff             	test   %rdi,%rdi
  80002c:	0f 84 e3 00 00 00    	je     800115 <_gettoken+0xf0>
_gettoken(char *s, char **p1, char **p2) {
  800032:	55                   	push   %rbp
  800033:	48 89 e5             	mov    %rsp,%rbp
  800036:	41 57                	push   %r15
  800038:	41 56                	push   %r14
  80003a:	41 55                	push   %r13
  80003c:	41 54                	push   %r12
  80003e:	53                   	push   %rbx
  80003f:	48 83 ec 08          	sub    $0x8,%rsp
  800043:	48 89 fb             	mov    %rdi,%rbx
  800046:	49 89 f7             	mov    %rsi,%r15
  800049:	49 89 d6             	mov    %rdx,%r14
    }

    if (debug > 1)
        cprintf("GETTOKEN: %s\n", s);

    *p1 = 0;
  80004c:	48 c7 06 00 00 00 00 	movq   $0x0,(%rsi)
    *p2 = 0;
  800053:	48 c7 02 00 00 00 00 	movq   $0x0,(%rdx)

    while (strchr(WHITESPACE, *s))
  80005a:	49 bd 00 50 80 00 00 	movabs $0x805000,%r13
  800061:	00 00 00 
  800064:	49 bc 75 17 80 00 00 	movabs $0x801775,%r12
  80006b:	00 00 00 
  80006e:	eb 08                	jmp    800078 <_gettoken+0x53>
        *s++ = 0;
  800070:	48 83 c3 01          	add    $0x1,%rbx
  800074:	c6 43 ff 00          	movb   $0x0,-0x1(%rbx)
    while (strchr(WHITESPACE, *s))
  800078:	0f be 33             	movsbl (%rbx),%esi
  80007b:	4c 89 ef             	mov    %r13,%rdi
  80007e:	41 ff d4             	call   *%r12
  800081:	48 85 c0             	test   %rax,%rax
  800084:	75 ea                	jne    800070 <_gettoken+0x4b>
    if (*s == 0) {
  800086:	0f b6 33             	movzbl (%rbx),%esi
  800089:	40 84 f6             	test   %sil,%sil
  80008c:	75 0f                	jne    80009d <_gettoken+0x78>
        **p2 = 0;
        cprintf("WORD: %s\n", *p1);
        **p2 = t;
    }
    return 'w';
}
  80008e:	48 83 c4 08          	add    $0x8,%rsp
  800092:	5b                   	pop    %rbx
  800093:	41 5c                	pop    %r12
  800095:	41 5d                	pop    %r13
  800097:	41 5e                	pop    %r14
  800099:	41 5f                	pop    %r15
  80009b:	5d                   	pop    %rbp
  80009c:	c3                   	ret
    if (strchr(SYMBOLS, *s)) {
  80009d:	40 0f be f6          	movsbl %sil,%esi
  8000a1:	48 bf 09 50 80 00 00 	movabs $0x805009,%rdi
  8000a8:	00 00 00 
  8000ab:	48 b8 75 17 80 00 00 	movabs $0x801775,%rax
  8000b2:	00 00 00 
  8000b5:	ff d0                	call   *%rax
  8000b7:	48 85 c0             	test   %rax,%rax
  8000ba:	74 12                	je     8000ce <_gettoken+0xa9>
        t = *s;
  8000bc:	0f be 03             	movsbl (%rbx),%eax
        *p1 = s;
  8000bf:	49 89 1f             	mov    %rbx,(%r15)
        *s++ = 0;
  8000c2:	c6 03 00             	movb   $0x0,(%rbx)
  8000c5:	48 83 c3 01          	add    $0x1,%rbx
  8000c9:	49 89 1e             	mov    %rbx,(%r14)
        return t;
  8000cc:	eb c0                	jmp    80008e <_gettoken+0x69>
    *p1 = s;
  8000ce:	49 89 1f             	mov    %rbx,(%r15)
    while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  8000d1:	0f b6 33             	movzbl (%rbx),%esi
  8000d4:	49 bd 05 50 80 00 00 	movabs $0x805005,%r13
  8000db:	00 00 00 
  8000de:	49 bc 75 17 80 00 00 	movabs $0x801775,%r12
  8000e5:	00 00 00 
  8000e8:	40 84 f6             	test   %sil,%sil
  8000eb:	74 1b                	je     800108 <_gettoken+0xe3>
  8000ed:	40 0f be f6          	movsbl %sil,%esi
  8000f1:	4c 89 ef             	mov    %r13,%rdi
  8000f4:	41 ff d4             	call   *%r12
  8000f7:	48 85 c0             	test   %rax,%rax
  8000fa:	75 0c                	jne    800108 <_gettoken+0xe3>
        s++;
  8000fc:	48 83 c3 01          	add    $0x1,%rbx
    while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  800100:	0f b6 33             	movzbl (%rbx),%esi
  800103:	40 84 f6             	test   %sil,%sil
  800106:	75 e5                	jne    8000ed <_gettoken+0xc8>
    *p2 = s;
  800108:	49 89 1e             	mov    %rbx,(%r14)
    return 'w';
  80010b:	b8 77 00 00 00       	mov    $0x77,%eax
  800110:	e9 79 ff ff ff       	jmp    80008e <_gettoken+0x69>
        return 0;
  800115:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80011a:	c3                   	ret

000000000080011b <gettoken>:

int
gettoken(char *s, char **p1) {
  80011b:	f3 0f 1e fa          	endbr64
  80011f:	55                   	push   %rbp
  800120:	48 89 e5             	mov    %rsp,%rbp
  800123:	41 54                	push   %r12
  800125:	53                   	push   %rbx
    static int c, nc;
    static char *np1, *np2;

    if (s) {
  800126:	48 85 ff             	test   %rdi,%rdi
  800129:	74 33                	je     80015e <gettoken+0x43>
        nc = _gettoken(s, &np1, &np2);
  80012b:	48 ba 08 70 80 00 00 	movabs $0x807008,%rdx
  800132:	00 00 00 
  800135:	48 be 10 70 80 00 00 	movabs $0x807010,%rsi
  80013c:	00 00 00 
  80013f:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  800146:	00 00 00 
  800149:	ff d0                	call   *%rax
  80014b:	a3 04 70 80 00 00 00 	movabs %eax,0x807004
  800152:	00 00 
        return 0;
  800154:	b8 00 00 00 00       	mov    $0x0,%eax
    }
    c = nc;
    *p1 = np1;
    nc = _gettoken(np2, &np1, &np2);
    return c;
}
  800159:	5b                   	pop    %rbx
  80015a:	41 5c                	pop    %r12
  80015c:	5d                   	pop    %rbp
  80015d:	c3                   	ret
    c = nc;
  80015e:	48 bb 00 70 80 00 00 	movabs $0x807000,%rbx
  800165:	00 00 00 
  800168:	49 bc 04 70 80 00 00 	movabs $0x807004,%r12
  80016f:	00 00 00 
  800172:	41 8b 04 24          	mov    (%r12),%eax
  800176:	89 03                	mov    %eax,(%rbx)
    *p1 = np1;
  800178:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  80017f:	00 00 00 
  800182:	48 8b 10             	mov    (%rax),%rdx
  800185:	48 89 16             	mov    %rdx,(%rsi)
    nc = _gettoken(np2, &np1, &np2);
  800188:	48 ba 08 70 80 00 00 	movabs $0x807008,%rdx
  80018f:	00 00 00 
  800192:	48 8b 3a             	mov    (%rdx),%rdi
  800195:	48 89 c6             	mov    %rax,%rsi
  800198:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  80019f:	00 00 00 
  8001a2:	ff d0                	call   *%rax
  8001a4:	41 89 04 24          	mov    %eax,(%r12)
    return c;
  8001a8:	8b 03                	mov    (%rbx),%eax
  8001aa:	eb ad                	jmp    800159 <gettoken+0x3e>

00000000008001ac <runcmd>:
runcmd(char *s) {
  8001ac:	f3 0f 1e fa          	endbr64
  8001b0:	55                   	push   %rbp
  8001b1:	48 89 e5             	mov    %rsp,%rbp
  8001b4:	41 56                	push   %r14
  8001b6:	41 55                	push   %r13
  8001b8:	41 54                	push   %r12
  8001ba:	53                   	push   %rbx
  8001bb:	48 81 ec 90 04 00 00 	sub    $0x490,%rsp
    gettoken(s, 0);
  8001c2:	be 00 00 00 00       	mov    $0x0,%esi
  8001c7:	48 b8 1b 01 80 00 00 	movabs $0x80011b,%rax
  8001ce:	00 00 00 
  8001d1:	ff d0                	call   *%rax
        switch ((c = gettoken(0, &t))) {
  8001d3:	49 bd 1b 01 80 00 00 	movabs $0x80011b,%r13
  8001da:	00 00 00 
    argc = 0;
  8001dd:	41 bc 00 00 00 00    	mov    $0x0,%r12d
        switch ((c = gettoken(0, &t))) {
  8001e3:	48 8d b5 58 ff ff ff 	lea    -0xa8(%rbp),%rsi
  8001ea:	bf 00 00 00 00       	mov    $0x0,%edi
  8001ef:	41 ff d5             	call   *%r13
  8001f2:	89 c3                	mov    %eax,%ebx
  8001f4:	83 f8 3e             	cmp    $0x3e,%eax
  8001f7:	0f 84 93 01 00 00    	je     800390 <runcmd+0x1e4>
  8001fd:	7f 5e                	jg     80025d <runcmd+0xb1>
  8001ff:	85 c0                	test   %eax,%eax
  800201:	0f 84 c5 02 00 00    	je     8004cc <runcmd+0x320>
  800207:	83 f8 3c             	cmp    $0x3c,%eax
  80020a:	0f 85 94 03 00 00    	jne    8005a4 <runcmd+0x3f8>
            if (gettoken(0, &t) != 'w') {
  800210:	48 8d b5 58 ff ff ff 	lea    -0xa8(%rbp),%rsi
  800217:	bf 00 00 00 00       	mov    $0x0,%edi
  80021c:	48 b8 1b 01 80 00 00 	movabs $0x80011b,%rax
  800223:	00 00 00 
  800226:	ff d0                	call   *%rax
  800228:	83 f8 77             	cmp    $0x77,%eax
  80022b:	0f 85 e1 00 00 00    	jne    800312 <runcmd+0x166>
            if ((fd = open(t, O_RDONLY)) < 0) {
  800231:	4c 8b b5 58 ff ff ff 	mov    -0xa8(%rbp),%r14
  800238:	be 00 00 00 00       	mov    $0x0,%esi
  80023d:	4c 89 f7             	mov    %r14,%rdi
  800240:	48 b8 2b 2e 80 00 00 	movabs $0x802e2b,%rax
  800247:	00 00 00 
  80024a:	ff d0                	call   *%rax
  80024c:	89 c3                	mov    %eax,%ebx
  80024e:	85 c0                	test   %eax,%eax
  800250:	0f 88 e8 00 00 00    	js     80033e <runcmd+0x192>
            if (fd != 0) {
  800256:	74 8b                	je     8001e3 <runcmd+0x37>
  800258:	e9 0d 01 00 00       	jmp    80036a <runcmd+0x1be>
        switch ((c = gettoken(0, &t))) {
  80025d:	83 f8 77             	cmp    $0x77,%eax
  800260:	74 65                	je     8002c7 <runcmd+0x11b>
  800262:	83 f8 7c             	cmp    $0x7c,%eax
  800265:	0f 85 39 03 00 00    	jne    8005a4 <runcmd+0x3f8>
            if ((r = pipe(p)) < 0) {
  80026b:	48 8d bd 50 fb ff ff 	lea    -0x4b0(%rbp),%rdi
  800272:	48 b8 ed 3b 80 00 00 	movabs $0x803bed,%rax
  800279:	00 00 00 
  80027c:	ff d0                	call   *%rax
  80027e:	85 c0                	test   %eax,%eax
  800280:	0f 88 ce 01 00 00    	js     800454 <runcmd+0x2a8>
            if ((r = fork()) < 0) {
  800286:	48 b8 7a 21 80 00 00 	movabs $0x80217a,%rax
  80028d:	00 00 00 
  800290:	ff d0                	call   *%rax
  800292:	89 c3                	mov    %eax,%ebx
  800294:	85 c0                	test   %eax,%eax
  800296:	0f 88 e6 01 00 00    	js     800482 <runcmd+0x2d6>
            if (r == 0) {
  80029c:	0f 85 09 02 00 00    	jne    8004ab <runcmd+0x2ff>
                if (p[0] != 0) {
  8002a2:	8b bd 50 fb ff ff    	mov    -0x4b0(%rbp),%edi
  8002a8:	85 ff                	test   %edi,%edi
  8002aa:	0f 85 a4 02 00 00    	jne    800554 <runcmd+0x3a8>
                close(p[1]);
  8002b0:	8b bd 54 fb ff ff    	mov    -0x4ac(%rbp),%edi
  8002b6:	48 b8 6b 26 80 00 00 	movabs $0x80266b,%rax
  8002bd:	00 00 00 
  8002c0:	ff d0                	call   *%rax
                goto again;
  8002c2:	e9 16 ff ff ff       	jmp    8001dd <runcmd+0x31>
            if (argc == MAXARGS) {
  8002c7:	41 83 fc 10          	cmp    $0x10,%r12d
  8002cb:	74 1c                	je     8002e9 <runcmd+0x13d>
            argv[argc++] = t;
  8002cd:	49 63 c4             	movslq %r12d,%rax
  8002d0:	48 8b 95 58 ff ff ff 	mov    -0xa8(%rbp),%rdx
  8002d7:	48 89 94 c5 60 ff ff 	mov    %rdx,-0xa0(%rbp,%rax,8)
  8002de:	ff 
  8002df:	45 8d 64 24 01       	lea    0x1(%r12),%r12d
            break;
  8002e4:	e9 fa fe ff ff       	jmp    8001e3 <runcmd+0x37>
                cprintf("too many arguments\n");
  8002e9:	48 bf 11 50 80 00 00 	movabs $0x805011,%rdi
  8002f0:	00 00 00 
  8002f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8002f8:	48 ba 1a 0d 80 00 00 	movabs $0x800d1a,%rdx
  8002ff:	00 00 00 
  800302:	ff d2                	call   *%rdx
                exit();
  800304:	48 b8 97 0b 80 00 00 	movabs $0x800b97,%rax
  80030b:	00 00 00 
  80030e:	ff d0                	call   *%rax
  800310:	eb bb                	jmp    8002cd <runcmd+0x121>
                cprintf("syntax error: < not followed by word\n");
  800312:	48 bf 08 54 80 00 00 	movabs $0x805408,%rdi
  800319:	00 00 00 
  80031c:	b8 00 00 00 00       	mov    $0x0,%eax
  800321:	48 ba 1a 0d 80 00 00 	movabs $0x800d1a,%rdx
  800328:	00 00 00 
  80032b:	ff d2                	call   *%rdx
                exit();
  80032d:	48 b8 97 0b 80 00 00 	movabs $0x800b97,%rax
  800334:	00 00 00 
  800337:	ff d0                	call   *%rax
  800339:	e9 f3 fe ff ff       	jmp    800231 <runcmd+0x85>
                cprintf("open %s for read: %i", t, fd);
  80033e:	89 c2                	mov    %eax,%edx
  800340:	4c 89 f6             	mov    %r14,%rsi
  800343:	48 bf 25 50 80 00 00 	movabs $0x805025,%rdi
  80034a:	00 00 00 
  80034d:	b8 00 00 00 00       	mov    $0x0,%eax
  800352:	48 b9 1a 0d 80 00 00 	movabs $0x800d1a,%rcx
  800359:	00 00 00 
  80035c:	ff d1                	call   *%rcx
                exit();
  80035e:	48 b8 97 0b 80 00 00 	movabs $0x800b97,%rax
  800365:	00 00 00 
  800368:	ff d0                	call   *%rax
                dup(fd, 0);
  80036a:	be 00 00 00 00       	mov    $0x0,%esi
  80036f:	89 df                	mov    %ebx,%edi
  800371:	48 b8 ce 26 80 00 00 	movabs $0x8026ce,%rax
  800378:	00 00 00 
  80037b:	ff d0                	call   *%rax
                close(fd);
  80037d:	89 df                	mov    %ebx,%edi
  80037f:	48 b8 6b 26 80 00 00 	movabs $0x80266b,%rax
  800386:	00 00 00 
  800389:	ff d0                	call   *%rax
  80038b:	e9 53 fe ff ff       	jmp    8001e3 <runcmd+0x37>
            if (gettoken(0, &t) != 'w') {
  800390:	48 8d b5 58 ff ff ff 	lea    -0xa8(%rbp),%rsi
  800397:	bf 00 00 00 00       	mov    $0x0,%edi
  80039c:	48 b8 1b 01 80 00 00 	movabs $0x80011b,%rax
  8003a3:	00 00 00 
  8003a6:	ff d0                	call   *%rax
  8003a8:	83 f8 77             	cmp    $0x77,%eax
  8003ab:	75 2c                	jne    8003d9 <runcmd+0x22d>
            if ((fd = open(t, O_WRONLY | O_CREAT | O_TRUNC)) < 0) {
  8003ad:	4c 8b b5 58 ff ff ff 	mov    -0xa8(%rbp),%r14
  8003b4:	be 01 03 00 00       	mov    $0x301,%esi
  8003b9:	4c 89 f7             	mov    %r14,%rdi
  8003bc:	48 b8 2b 2e 80 00 00 	movabs $0x802e2b,%rax
  8003c3:	00 00 00 
  8003c6:	ff d0                	call   *%rax
  8003c8:	89 c3                	mov    %eax,%ebx
  8003ca:	85 c0                	test   %eax,%eax
  8003cc:	78 34                	js     800402 <runcmd+0x256>
            if (fd != 1) {
  8003ce:	83 f8 01             	cmp    $0x1,%eax
  8003d1:	0f 84 0c fe ff ff    	je     8001e3 <runcmd+0x37>
  8003d7:	eb 55                	jmp    80042e <runcmd+0x282>
                cprintf("syntax error: > not followed by word\n");
  8003d9:	48 bf 30 54 80 00 00 	movabs $0x805430,%rdi
  8003e0:	00 00 00 
  8003e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8003e8:	48 ba 1a 0d 80 00 00 	movabs $0x800d1a,%rdx
  8003ef:	00 00 00 
  8003f2:	ff d2                	call   *%rdx
                exit();
  8003f4:	48 b8 97 0b 80 00 00 	movabs $0x800b97,%rax
  8003fb:	00 00 00 
  8003fe:	ff d0                	call   *%rax
  800400:	eb ab                	jmp    8003ad <runcmd+0x201>
                cprintf("open %s for write: %i", t, fd);
  800402:	89 c2                	mov    %eax,%edx
  800404:	4c 89 f6             	mov    %r14,%rsi
  800407:	48 bf 3a 50 80 00 00 	movabs $0x80503a,%rdi
  80040e:	00 00 00 
  800411:	b8 00 00 00 00       	mov    $0x0,%eax
  800416:	48 b9 1a 0d 80 00 00 	movabs $0x800d1a,%rcx
  80041d:	00 00 00 
  800420:	ff d1                	call   *%rcx
                exit();
  800422:	48 b8 97 0b 80 00 00 	movabs $0x800b97,%rax
  800429:	00 00 00 
  80042c:	ff d0                	call   *%rax
                dup(fd, 1);
  80042e:	be 01 00 00 00       	mov    $0x1,%esi
  800433:	89 df                	mov    %ebx,%edi
  800435:	48 b8 ce 26 80 00 00 	movabs $0x8026ce,%rax
  80043c:	00 00 00 
  80043f:	ff d0                	call   *%rax
                close(fd);
  800441:	89 df                	mov    %ebx,%edi
  800443:	48 b8 6b 26 80 00 00 	movabs $0x80266b,%rax
  80044a:	00 00 00 
  80044d:	ff d0                	call   *%rax
  80044f:	e9 8f fd ff ff       	jmp    8001e3 <runcmd+0x37>
                cprintf("pipe: %i", r);
  800454:	89 c6                	mov    %eax,%esi
  800456:	48 bf 50 50 80 00 00 	movabs $0x805050,%rdi
  80045d:	00 00 00 
  800460:	b8 00 00 00 00       	mov    $0x0,%eax
  800465:	48 ba 1a 0d 80 00 00 	movabs $0x800d1a,%rdx
  80046c:	00 00 00 
  80046f:	ff d2                	call   *%rdx
                exit();
  800471:	48 b8 97 0b 80 00 00 	movabs $0x800b97,%rax
  800478:	00 00 00 
  80047b:	ff d0                	call   *%rax
  80047d:	e9 04 fe ff ff       	jmp    800286 <runcmd+0xda>
                cprintf("fork: %i", r);
  800482:	89 c6                	mov    %eax,%esi
  800484:	48 bf 59 50 80 00 00 	movabs $0x805059,%rdi
  80048b:	00 00 00 
  80048e:	b8 00 00 00 00       	mov    $0x0,%eax
  800493:	48 ba 1a 0d 80 00 00 	movabs $0x800d1a,%rdx
  80049a:	00 00 00 
  80049d:	ff d2                	call   *%rdx
                exit();
  80049f:	48 b8 97 0b 80 00 00 	movabs $0x800b97,%rax
  8004a6:	00 00 00 
  8004a9:	ff d0                	call   *%rax
                if (p[1] != 1) {
  8004ab:	8b bd 54 fb ff ff    	mov    -0x4ac(%rbp),%edi
  8004b1:	83 ff 01             	cmp    $0x1,%edi
  8004b4:	0f 85 c2 00 00 00    	jne    80057c <runcmd+0x3d0>
                close(p[0]);
  8004ba:	8b bd 50 fb ff ff    	mov    -0x4b0(%rbp),%edi
  8004c0:	48 b8 6b 26 80 00 00 	movabs $0x80266b,%rax
  8004c7:	00 00 00 
  8004ca:	ff d0                	call   *%rax
    if (argc == 0) {
  8004cc:	45 85 e4             	test   %r12d,%r12d
  8004cf:	74 73                	je     800544 <runcmd+0x398>
    if (argv[0][0] != '/') {
  8004d1:	48 8b b5 60 ff ff ff 	mov    -0xa0(%rbp),%rsi
  8004d8:	80 3e 2f             	cmpb   $0x2f,(%rsi)
  8004db:	0f 85 f0 00 00 00    	jne    8005d1 <runcmd+0x425>
    argv[argc] = 0;
  8004e1:	4d 63 e4             	movslq %r12d,%r12
  8004e4:	4a c7 84 e5 60 ff ff 	movq   $0x0,-0xa0(%rbp,%r12,8)
  8004eb:	ff 00 00 00 00 
    if ((r = spawn(argv[0], (const char **)argv)) < 0)
  8004f0:	48 8d b5 60 ff ff ff 	lea    -0xa0(%rbp),%rsi
  8004f7:	48 8b bd 60 ff ff ff 	mov    -0xa0(%rbp),%rdi
  8004fe:	48 b8 17 31 80 00 00 	movabs $0x803117,%rax
  800505:	00 00 00 
  800508:	ff d0                	call   *%rax
  80050a:	41 89 c4             	mov    %eax,%r12d
  80050d:	85 c0                	test   %eax,%eax
  80050f:	0f 88 e9 00 00 00    	js     8005fe <runcmd+0x452>
    close_all();
  800515:	48 b8 a2 26 80 00 00 	movabs $0x8026a2,%rax
  80051c:	00 00 00 
  80051f:	ff d0                	call   *%rax
        wait(r);
  800521:	44 89 e7             	mov    %r12d,%edi
  800524:	48 b8 54 3e 80 00 00 	movabs $0x803e54,%rax
  80052b:	00 00 00 
  80052e:	ff d0                	call   *%rax
    if (pipe_child) {
  800530:	85 db                	test   %ebx,%ebx
  800532:	0f 85 fb 00 00 00    	jne    800633 <runcmd+0x487>
    exit();
  800538:	48 b8 97 0b 80 00 00 	movabs $0x800b97,%rax
  80053f:	00 00 00 
  800542:	ff d0                	call   *%rax
}
  800544:	48 81 c4 90 04 00 00 	add    $0x490,%rsp
  80054b:	5b                   	pop    %rbx
  80054c:	41 5c                	pop    %r12
  80054e:	41 5d                	pop    %r13
  800550:	41 5e                	pop    %r14
  800552:	5d                   	pop    %rbp
  800553:	c3                   	ret
                    dup(p[0], 0);
  800554:	be 00 00 00 00       	mov    $0x0,%esi
  800559:	48 b8 ce 26 80 00 00 	movabs $0x8026ce,%rax
  800560:	00 00 00 
  800563:	ff d0                	call   *%rax
                    close(p[0]);
  800565:	8b bd 50 fb ff ff    	mov    -0x4b0(%rbp),%edi
  80056b:	48 b8 6b 26 80 00 00 	movabs $0x80266b,%rax
  800572:	00 00 00 
  800575:	ff d0                	call   *%rax
  800577:	e9 34 fd ff ff       	jmp    8002b0 <runcmd+0x104>
                    dup(p[1], 1);
  80057c:	be 01 00 00 00       	mov    $0x1,%esi
  800581:	48 b8 ce 26 80 00 00 	movabs $0x8026ce,%rax
  800588:	00 00 00 
  80058b:	ff d0                	call   *%rax
                    close(p[1]);
  80058d:	8b bd 54 fb ff ff    	mov    -0x4ac(%rbp),%edi
  800593:	48 b8 6b 26 80 00 00 	movabs $0x80266b,%rax
  80059a:	00 00 00 
  80059d:	ff d0                	call   *%rax
  80059f:	e9 16 ff ff ff       	jmp    8004ba <runcmd+0x30e>
            panic("bad return %d from gettoken", c);
  8005a4:	89 d9                	mov    %ebx,%ecx
  8005a6:	48 ba 62 50 80 00 00 	movabs $0x805062,%rdx
  8005ad:	00 00 00 
  8005b0:	be 70 00 00 00       	mov    $0x70,%esi
  8005b5:	48 bf 7e 50 80 00 00 	movabs $0x80507e,%rdi
  8005bc:	00 00 00 
  8005bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8005c4:	49 b8 be 0b 80 00 00 	movabs $0x800bbe,%r8
  8005cb:	00 00 00 
  8005ce:	41 ff d0             	call   *%r8
        argv0buf[0] = '/';
  8005d1:	c6 85 58 fb ff ff 2f 	movb   $0x2f,-0x4a8(%rbp)
        strcpy(argv0buf + 1, argv[0]);
  8005d8:	4c 8d ad 58 fb ff ff 	lea    -0x4a8(%rbp),%r13
  8005df:	48 8d bd 59 fb ff ff 	lea    -0x4a7(%rbp),%rdi
  8005e6:	48 b8 63 16 80 00 00 	movabs $0x801663,%rax
  8005ed:	00 00 00 
  8005f0:	ff d0                	call   *%rax
        argv[0] = argv0buf;
  8005f2:	4c 89 ad 60 ff ff ff 	mov    %r13,-0xa0(%rbp)
  8005f9:	e9 e3 fe ff ff       	jmp    8004e1 <runcmd+0x335>
        cprintf("spawn %s: %i\n", argv[0], r);
  8005fe:	89 c2                	mov    %eax,%edx
  800600:	48 8b b5 60 ff ff ff 	mov    -0xa0(%rbp),%rsi
  800607:	48 bf 88 50 80 00 00 	movabs $0x805088,%rdi
  80060e:	00 00 00 
  800611:	b8 00 00 00 00       	mov    $0x0,%eax
  800616:	48 b9 1a 0d 80 00 00 	movabs $0x800d1a,%rcx
  80061d:	00 00 00 
  800620:	ff d1                	call   *%rcx
    close_all();
  800622:	48 b8 a2 26 80 00 00 	movabs $0x8026a2,%rax
  800629:	00 00 00 
  80062c:	ff d0                	call   *%rax
    if (r >= 0) {
  80062e:	e9 fd fe ff ff       	jmp    800530 <runcmd+0x384>
        wait(pipe_child);
  800633:	89 df                	mov    %ebx,%edi
  800635:	48 b8 54 3e 80 00 00 	movabs $0x803e54,%rax
  80063c:	00 00 00 
  80063f:	ff d0                	call   *%rax
        if (debug) cprintf("[%08x] wait finished\n", thisenv->env_id);
  800641:	e9 f2 fe ff ff       	jmp    800538 <runcmd+0x38c>

0000000000800646 <usage>:

void
usage(void) {
  800646:	f3 0f 1e fa          	endbr64
  80064a:	55                   	push   %rbp
  80064b:	48 89 e5             	mov    %rsp,%rbp
    cprintf("usage: sh [-dix] [command-file]\n");
  80064e:	48 bf 58 54 80 00 00 	movabs $0x805458,%rdi
  800655:	00 00 00 
  800658:	b8 00 00 00 00       	mov    $0x0,%eax
  80065d:	48 ba 1a 0d 80 00 00 	movabs $0x800d1a,%rdx
  800664:	00 00 00 
  800667:	ff d2                	call   *%rdx
    exit();
  800669:	48 b8 97 0b 80 00 00 	movabs $0x800b97,%rax
  800670:	00 00 00 
  800673:	ff d0                	call   *%rax
}
  800675:	5d                   	pop    %rbp
  800676:	c3                   	ret

0000000000800677 <umain>:

void
umain(int argc, char **argv) {
  800677:	f3 0f 1e fa          	endbr64
  80067b:	55                   	push   %rbp
  80067c:	48 89 e5             	mov    %rsp,%rbp
  80067f:	41 57                	push   %r15
  800681:	41 56                	push   %r14
  800683:	41 55                	push   %r13
  800685:	41 54                	push   %r12
  800687:	53                   	push   %rbx
  800688:	48 83 ec 38          	sub    $0x38,%rsp
  80068c:	89 7d ac             	mov    %edi,-0x54(%rbp)
  80068f:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
    int r, interactive, echocmds;
    struct Argstate args;

    interactive = '?';
    echocmds = 0;
    argstart(&argc, argv, &args);
  800693:	48 8d 55 b0          	lea    -0x50(%rbp),%rdx
  800697:	48 8d 7d ac          	lea    -0x54(%rbp),%rdi
  80069b:	48 b8 d6 22 80 00 00 	movabs $0x8022d6,%rax
  8006a2:	00 00 00 
  8006a5:	ff d0                	call   *%rax
    echocmds = 0;
  8006a7:	41 bd 00 00 00 00    	mov    $0x0,%r13d
    interactive = '?';
  8006ad:	41 bc 3f 00 00 00    	mov    $0x3f,%r12d
    while ((r = argnext(&args)) >= 0) {
  8006b3:	48 bb 07 23 80 00 00 	movabs $0x802307,%rbx
  8006ba:	00 00 00 
        switch (r) {
  8006bd:	41 be 01 00 00 00    	mov    $0x1,%r14d
            break;
        case 'x':
            echocmds = 1;
            break;
        default:
            usage();
  8006c3:	49 bf 46 06 80 00 00 	movabs $0x800646,%r15
  8006ca:	00 00 00 
    while ((r = argnext(&args)) >= 0) {
  8006cd:	eb 08                	jmp    8006d7 <umain+0x60>
        switch (r) {
  8006cf:	45 89 f4             	mov    %r14d,%r12d
  8006d2:	eb 03                	jmp    8006d7 <umain+0x60>
            echocmds = 1;
  8006d4:	45 89 f5             	mov    %r14d,%r13d
    while ((r = argnext(&args)) >= 0) {
  8006d7:	48 8d 7d b0          	lea    -0x50(%rbp),%rdi
  8006db:	ff d3                	call   *%rbx
  8006dd:	85 c0                	test   %eax,%eax
  8006df:	78 14                	js     8006f5 <umain+0x7e>
        switch (r) {
  8006e1:	83 f8 69             	cmp    $0x69,%eax
  8006e4:	74 e9                	je     8006cf <umain+0x58>
  8006e6:	83 f8 78             	cmp    $0x78,%eax
  8006e9:	74 e9                	je     8006d4 <umain+0x5d>
  8006eb:	83 f8 64             	cmp    $0x64,%eax
  8006ee:	74 e7                	je     8006d7 <umain+0x60>
            usage();
  8006f0:	41 ff d7             	call   *%r15
  8006f3:	eb e2                	jmp    8006d7 <umain+0x60>
        }
    }

    if (argc > 2)
  8006f5:	83 7d ac 02          	cmpl   $0x2,-0x54(%rbp)
  8006f9:	7f 3f                	jg     80073a <umain+0xc3>
        usage();
    if (argc == 2) {
  8006fb:	83 7d ac 02          	cmpl   $0x2,-0x54(%rbp)
  8006ff:	74 47                	je     800748 <umain+0xd1>
        close(0);
        if ((r = open(argv[1], O_RDONLY)) < 0)
            panic("open %s: %i", argv[1], r);
        assert(r == 0);
    }
    if (interactive == '?')
  800701:	41 83 fc 3f          	cmp    $0x3f,%r12d
  800705:	0f 84 d8 00 00 00    	je     8007e3 <umain+0x16c>
  80070b:	45 85 e4             	test   %r12d,%r12d
  80070e:	49 bc be 50 80 00 00 	movabs $0x8050be,%r12
  800715:	00 00 00 
  800718:	b8 00 00 00 00       	mov    $0x0,%eax
  80071d:	4c 0f 44 e0          	cmove  %rax,%r12
        interactive = iscons(0);

    while (1) {
        char *buf;

        buf = readline(interactive ? "$ " : NULL);
  800721:	49 be c3 1a 80 00 00 	movabs $0x801ac3,%r14
  800728:	00 00 00 
        if (buf == NULL) {
            if (debug) cprintf("EXITING\n");
            exit(); /* end of file */
  80072b:	49 bf 97 0b 80 00 00 	movabs $0x800b97,%r15
  800732:	00 00 00 
  800735:	e9 22 01 00 00       	jmp    80085c <umain+0x1e5>
        usage();
  80073a:	48 b8 46 06 80 00 00 	movabs $0x800646,%rax
  800741:	00 00 00 
  800744:	ff d0                	call   *%rax
  800746:	eb b3                	jmp    8006fb <umain+0x84>
        close(0);
  800748:	bf 00 00 00 00       	mov    $0x0,%edi
  80074d:	48 b8 6b 26 80 00 00 	movabs $0x80266b,%rax
  800754:	00 00 00 
  800757:	ff d0                	call   *%rax
        if ((r = open(argv[1], O_RDONLY)) < 0)
  800759:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80075d:	48 8b 78 08          	mov    0x8(%rax),%rdi
  800761:	be 00 00 00 00       	mov    $0x0,%esi
  800766:	48 b8 2b 2e 80 00 00 	movabs $0x802e2b,%rax
  80076d:	00 00 00 
  800770:	ff d0                	call   *%rax
  800772:	85 c0                	test   %eax,%eax
  800774:	78 37                	js     8007ad <umain+0x136>
        assert(r == 0);
  800776:	74 89                	je     800701 <umain+0x8a>
  800778:	48 b9 a2 50 80 00 00 	movabs $0x8050a2,%rcx
  80077f:	00 00 00 
  800782:	48 ba a9 50 80 00 00 	movabs $0x8050a9,%rdx
  800789:	00 00 00 
  80078c:	be 16 01 00 00       	mov    $0x116,%esi
  800791:	48 bf 7e 50 80 00 00 	movabs $0x80507e,%rdi
  800798:	00 00 00 
  80079b:	b8 00 00 00 00       	mov    $0x0,%eax
  8007a0:	49 b8 be 0b 80 00 00 	movabs $0x800bbe,%r8
  8007a7:	00 00 00 
  8007aa:	41 ff d0             	call   *%r8
            panic("open %s: %i", argv[1], r);
  8007ad:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8007b1:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8007b5:	41 89 c0             	mov    %eax,%r8d
  8007b8:	48 ba 96 50 80 00 00 	movabs $0x805096,%rdx
  8007bf:	00 00 00 
  8007c2:	be 15 01 00 00       	mov    $0x115,%esi
  8007c7:	48 bf 7e 50 80 00 00 	movabs $0x80507e,%rdi
  8007ce:	00 00 00 
  8007d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8007d6:	49 b9 be 0b 80 00 00 	movabs $0x800bbe,%r9
  8007dd:	00 00 00 
  8007e0:	41 ff d1             	call   *%r9
        interactive = iscons(0);
  8007e3:	bf 00 00 00 00       	mov    $0x0,%edi
  8007e8:	48 b8 40 0a 80 00 00 	movabs $0x800a40,%rax
  8007ef:	00 00 00 
  8007f2:	ff d0                	call   *%rax
  8007f4:	41 89 c4             	mov    %eax,%r12d
  8007f7:	e9 0f ff ff ff       	jmp    80070b <umain+0x94>
            exit(); /* end of file */
  8007fc:	41 ff d7             	call   *%r15
  8007ff:	eb 69                	jmp    80086a <umain+0x1f3>
        }
        if (debug) cprintf("LINE: %s\n", buf);
        if (buf[0] == '#') continue;
        if (echocmds) printf("# %s\n", buf);
  800801:	48 89 de             	mov    %rbx,%rsi
  800804:	48 bf c1 50 80 00 00 	movabs $0x8050c1,%rdi
  80080b:	00 00 00 
  80080e:	b8 00 00 00 00       	mov    $0x0,%eax
  800813:	48 b9 72 30 80 00 00 	movabs $0x803072,%rcx
  80081a:	00 00 00 
  80081d:	ff d1                	call   *%rcx
  80081f:	eb 53                	jmp    800874 <umain+0x1fd>
        if (debug) cprintf("BEFORE FORK\n");
        if ((r = fork()) < 0) panic("fork: %i", r);
  800821:	89 c1                	mov    %eax,%ecx
  800823:	48 ba 59 50 80 00 00 	movabs $0x805059,%rdx
  80082a:	00 00 00 
  80082d:	be 27 01 00 00       	mov    $0x127,%esi
  800832:	48 bf 7e 50 80 00 00 	movabs $0x80507e,%rdi
  800839:	00 00 00 
  80083c:	b8 00 00 00 00       	mov    $0x0,%eax
  800841:	49 b8 be 0b 80 00 00 	movabs $0x800bbe,%r8
  800848:	00 00 00 
  80084b:	41 ff d0             	call   *%r8
        if (debug) cprintf("FORK: %d\n", r);
        if (r == 0) {
            runcmd(buf);
            exit();
        } else
            wait(r);
  80084e:	89 c7                	mov    %eax,%edi
  800850:	48 b8 54 3e 80 00 00 	movabs $0x803e54,%rax
  800857:	00 00 00 
  80085a:	ff d0                	call   *%rax
        buf = readline(interactive ? "$ " : NULL);
  80085c:	4c 89 e7             	mov    %r12,%rdi
  80085f:	41 ff d6             	call   *%r14
  800862:	48 89 c3             	mov    %rax,%rbx
        if (buf == NULL) {
  800865:	48 85 c0             	test   %rax,%rax
  800868:	74 92                	je     8007fc <umain+0x185>
        if (buf[0] == '#') continue;
  80086a:	80 3b 23             	cmpb   $0x23,(%rbx)
  80086d:	74 ed                	je     80085c <umain+0x1e5>
        if (echocmds) printf("# %s\n", buf);
  80086f:	45 85 ed             	test   %r13d,%r13d
  800872:	75 8d                	jne    800801 <umain+0x18a>
        if ((r = fork()) < 0) panic("fork: %i", r);
  800874:	48 b8 7a 21 80 00 00 	movabs $0x80217a,%rax
  80087b:	00 00 00 
  80087e:	ff d0                	call   *%rax
  800880:	85 c0                	test   %eax,%eax
  800882:	78 9d                	js     800821 <umain+0x1aa>
        if (r == 0) {
  800884:	75 c8                	jne    80084e <umain+0x1d7>
            runcmd(buf);
  800886:	48 89 df             	mov    %rbx,%rdi
  800889:	48 b8 ac 01 80 00 00 	movabs $0x8001ac,%rax
  800890:	00 00 00 
  800893:	ff d0                	call   *%rax
            exit();
  800895:	41 ff d7             	call   *%r15
  800898:	eb c2                	jmp    80085c <umain+0x1e5>

000000000080089a <devcons_close>:

    return res;
}

static int
devcons_close(struct Fd *fd) {
  80089a:	f3 0f 1e fa          	endbr64
    USED(fd);

    return 0;
}
  80089e:	b8 00 00 00 00       	mov    $0x0,%eax
  8008a3:	c3                   	ret

00000000008008a4 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  8008a4:	f3 0f 1e fa          	endbr64
  8008a8:	55                   	push   %rbp
  8008a9:	48 89 e5             	mov    %rsp,%rbp
  8008ac:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  8008af:	48 be c7 50 80 00 00 	movabs $0x8050c7,%rsi
  8008b6:	00 00 00 
  8008b9:	48 b8 63 16 80 00 00 	movabs $0x801663,%rax
  8008c0:	00 00 00 
  8008c3:	ff d0                	call   *%rax
    return 0;
}
  8008c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8008ca:	5d                   	pop    %rbp
  8008cb:	c3                   	ret

00000000008008cc <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  8008cc:	f3 0f 1e fa          	endbr64
  8008d0:	55                   	push   %rbp
  8008d1:	48 89 e5             	mov    %rsp,%rbp
  8008d4:	41 57                	push   %r15
  8008d6:	41 56                	push   %r14
  8008d8:	41 55                	push   %r13
  8008da:	41 54                	push   %r12
  8008dc:	53                   	push   %rbx
  8008dd:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  8008e4:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  8008eb:	48 85 d2             	test   %rdx,%rdx
  8008ee:	74 7a                	je     80096a <devcons_write+0x9e>
  8008f0:	49 89 d6             	mov    %rdx,%r14
  8008f3:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  8008f9:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  8008fe:	49 bf 7e 18 80 00 00 	movabs $0x80187e,%r15
  800905:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  800908:	4c 89 f3             	mov    %r14,%rbx
  80090b:	48 29 f3             	sub    %rsi,%rbx
  80090e:	b8 7f 00 00 00       	mov    $0x7f,%eax
  800913:	48 39 c3             	cmp    %rax,%rbx
  800916:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  80091a:	4c 63 eb             	movslq %ebx,%r13
  80091d:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  800924:	48 01 c6             	add    %rax,%rsi
  800927:	4c 89 ea             	mov    %r13,%rdx
  80092a:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  800931:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  800934:	4c 89 ee             	mov    %r13,%rsi
  800937:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  80093e:	48 b8 11 1c 80 00 00 	movabs $0x801c11,%rax
  800945:	00 00 00 
  800948:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  80094a:	41 01 dc             	add    %ebx,%r12d
  80094d:	49 63 f4             	movslq %r12d,%rsi
  800950:	4c 39 f6             	cmp    %r14,%rsi
  800953:	72 b3                	jb     800908 <devcons_write+0x3c>
    return res;
  800955:	49 63 c4             	movslq %r12d,%rax
}
  800958:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  80095f:	5b                   	pop    %rbx
  800960:	41 5c                	pop    %r12
  800962:	41 5d                	pop    %r13
  800964:	41 5e                	pop    %r14
  800966:	41 5f                	pop    %r15
  800968:	5d                   	pop    %rbp
  800969:	c3                   	ret
    for (res = 0; res < n; res += inc) {
  80096a:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  800970:	eb e3                	jmp    800955 <devcons_write+0x89>

0000000000800972 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  800972:	f3 0f 1e fa          	endbr64
  800976:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  800979:	ba 00 00 00 00       	mov    $0x0,%edx
  80097e:	48 85 c0             	test   %rax,%rax
  800981:	74 55                	je     8009d8 <devcons_read+0x66>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  800983:	55                   	push   %rbp
  800984:	48 89 e5             	mov    %rsp,%rbp
  800987:	41 55                	push   %r13
  800989:	41 54                	push   %r12
  80098b:	53                   	push   %rbx
  80098c:	48 83 ec 08          	sub    $0x8,%rsp
  800990:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  800993:	48 bb 42 1c 80 00 00 	movabs $0x801c42,%rbx
  80099a:	00 00 00 
  80099d:	49 bc 1b 1d 80 00 00 	movabs $0x801d1b,%r12
  8009a4:	00 00 00 
  8009a7:	eb 03                	jmp    8009ac <devcons_read+0x3a>
  8009a9:	41 ff d4             	call   *%r12
  8009ac:	ff d3                	call   *%rbx
  8009ae:	85 c0                	test   %eax,%eax
  8009b0:	74 f7                	je     8009a9 <devcons_read+0x37>
    if (c < 0) return c;
  8009b2:	48 63 d0             	movslq %eax,%rdx
  8009b5:	78 13                	js     8009ca <devcons_read+0x58>
    if (c == 0x04) return 0;
  8009b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8009bc:	83 f8 04             	cmp    $0x4,%eax
  8009bf:	74 09                	je     8009ca <devcons_read+0x58>
    *(char *)vbuf = (char)c;
  8009c1:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  8009c5:	ba 01 00 00 00       	mov    $0x1,%edx
}
  8009ca:	48 89 d0             	mov    %rdx,%rax
  8009cd:	48 83 c4 08          	add    $0x8,%rsp
  8009d1:	5b                   	pop    %rbx
  8009d2:	41 5c                	pop    %r12
  8009d4:	41 5d                	pop    %r13
  8009d6:	5d                   	pop    %rbp
  8009d7:	c3                   	ret
  8009d8:	48 89 d0             	mov    %rdx,%rax
  8009db:	c3                   	ret

00000000008009dc <cputchar>:
cputchar(int ch) {
  8009dc:	f3 0f 1e fa          	endbr64
  8009e0:	55                   	push   %rbp
  8009e1:	48 89 e5             	mov    %rsp,%rbp
  8009e4:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  8009e8:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  8009ec:	be 01 00 00 00       	mov    $0x1,%esi
  8009f1:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  8009f5:	48 b8 11 1c 80 00 00 	movabs $0x801c11,%rax
  8009fc:	00 00 00 
  8009ff:	ff d0                	call   *%rax
}
  800a01:	c9                   	leave
  800a02:	c3                   	ret

0000000000800a03 <getchar>:
getchar(void) {
  800a03:	f3 0f 1e fa          	endbr64
  800a07:	55                   	push   %rbp
  800a08:	48 89 e5             	mov    %rsp,%rbp
  800a0b:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  800a0f:	ba 01 00 00 00       	mov    $0x1,%edx
  800a14:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  800a18:	bf 00 00 00 00       	mov    $0x0,%edi
  800a1d:	48 b8 f5 27 80 00 00 	movabs $0x8027f5,%rax
  800a24:	00 00 00 
  800a27:	ff d0                	call   *%rax
  800a29:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  800a2b:	85 c0                	test   %eax,%eax
  800a2d:	78 06                	js     800a35 <getchar+0x32>
  800a2f:	74 08                	je     800a39 <getchar+0x36>
  800a31:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  800a35:	89 d0                	mov    %edx,%eax
  800a37:	c9                   	leave
  800a38:	c3                   	ret
    return res < 0 ? res : res ? c :
  800a39:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  800a3e:	eb f5                	jmp    800a35 <getchar+0x32>

0000000000800a40 <iscons>:
iscons(int fdnum) {
  800a40:	f3 0f 1e fa          	endbr64
  800a44:	55                   	push   %rbp
  800a45:	48 89 e5             	mov    %rsp,%rbp
  800a48:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  800a4c:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  800a50:	48 b8 fa 24 80 00 00 	movabs $0x8024fa,%rax
  800a57:	00 00 00 
  800a5a:	ff d0                	call   *%rax
    if (res < 0) return res;
  800a5c:	85 c0                	test   %eax,%eax
  800a5e:	78 18                	js     800a78 <iscons+0x38>
    return fd->fd_dev_id == devcons.dev_id;
  800a60:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800a64:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800a6b:	00 00 00 
  800a6e:	8b 00                	mov    (%rax),%eax
  800a70:	39 02                	cmp    %eax,(%rdx)
  800a72:	0f 94 c0             	sete   %al
  800a75:	0f b6 c0             	movzbl %al,%eax
}
  800a78:	c9                   	leave
  800a79:	c3                   	ret

0000000000800a7a <opencons>:
opencons(void) {
  800a7a:	f3 0f 1e fa          	endbr64
  800a7e:	55                   	push   %rbp
  800a7f:	48 89 e5             	mov    %rsp,%rbp
  800a82:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  800a86:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  800a8a:	48 b8 96 24 80 00 00 	movabs $0x802496,%rax
  800a91:	00 00 00 
  800a94:	ff d0                	call   *%rax
  800a96:	85 c0                	test   %eax,%eax
  800a98:	78 49                	js     800ae3 <opencons+0x69>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  800a9a:	b9 46 00 00 00       	mov    $0x46,%ecx
  800a9f:	ba 00 10 00 00       	mov    $0x1000,%edx
  800aa4:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  800aa8:	bf 00 00 00 00       	mov    $0x0,%edi
  800aad:	48 b8 b6 1d 80 00 00 	movabs $0x801db6,%rax
  800ab4:	00 00 00 
  800ab7:	ff d0                	call   *%rax
  800ab9:	85 c0                	test   %eax,%eax
  800abb:	78 26                	js     800ae3 <opencons+0x69>
    fd->fd_dev_id = devcons.dev_id;
  800abd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800ac1:	a1 00 60 80 00 00 00 	movabs 0x806000,%eax
  800ac8:	00 00 
  800aca:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  800acc:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  800ad0:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  800ad7:	48 b8 60 24 80 00 00 	movabs $0x802460,%rax
  800ade:	00 00 00 
  800ae1:	ff d0                	call   *%rax
}
  800ae3:	c9                   	leave
  800ae4:	c3                   	ret

0000000000800ae5 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  800ae5:	f3 0f 1e fa          	endbr64
  800ae9:	55                   	push   %rbp
  800aea:	48 89 e5             	mov    %rsp,%rbp
  800aed:	41 56                	push   %r14
  800aef:	41 55                	push   %r13
  800af1:	41 54                	push   %r12
  800af3:	53                   	push   %rbx
  800af4:	41 89 fd             	mov    %edi,%r13d
  800af7:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
     * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  800afa:	48 ba b8 60 80 00 00 	movabs $0x8060b8,%rdx
  800b01:	00 00 00 
  800b04:	48 b8 b8 60 80 00 00 	movabs $0x8060b8,%rax
  800b0b:	00 00 00 
  800b0e:	48 39 c2             	cmp    %rax,%rdx
  800b11:	73 17                	jae    800b2a <libmain+0x45>
    void (**ctor)() = &__ctors_start;
  800b13:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  800b16:	49 89 c4             	mov    %rax,%r12
  800b19:	48 83 c3 08          	add    $0x8,%rbx
  800b1d:	b8 00 00 00 00       	mov    $0x0,%eax
  800b22:	ff 53 f8             	call   *-0x8(%rbx)
  800b25:	4c 39 e3             	cmp    %r12,%rbx
  800b28:	72 ef                	jb     800b19 <libmain+0x34>

    /* Set thisenv to point at our Env structure in envs[]. */

    // LAB 8: Your code here
    thisenv = &((struct Env *)UENVS)[ENVX(sys_getenvid())];
  800b2a:	48 b8 e6 1c 80 00 00 	movabs $0x801ce6,%rax
  800b31:	00 00 00 
  800b34:	ff d0                	call   *%rax
  800b36:	25 ff 03 00 00       	and    $0x3ff,%eax
  800b3b:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  800b3f:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  800b43:	48 c1 e0 04          	shl    $0x4,%rax
  800b47:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  800b4e:	00 00 00 
  800b51:	48 01 d0             	add    %rdx,%rax
  800b54:	48 a3 18 70 80 00 00 	movabs %rax,0x807018
  800b5b:	00 00 00 

    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  800b5e:	45 85 ed             	test   %r13d,%r13d
  800b61:	7e 0d                	jle    800b70 <libmain+0x8b>
  800b63:	49 8b 06             	mov    (%r14),%rax
  800b66:	48 a3 38 60 80 00 00 	movabs %rax,0x806038
  800b6d:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  800b70:	4c 89 f6             	mov    %r14,%rsi
  800b73:	44 89 ef             	mov    %r13d,%edi
  800b76:	48 b8 77 06 80 00 00 	movabs $0x800677,%rax
  800b7d:	00 00 00 
  800b80:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  800b82:	48 b8 97 0b 80 00 00 	movabs $0x800b97,%rax
  800b89:	00 00 00 
  800b8c:	ff d0                	call   *%rax
#endif
}
  800b8e:	5b                   	pop    %rbx
  800b8f:	41 5c                	pop    %r12
  800b91:	41 5d                	pop    %r13
  800b93:	41 5e                	pop    %r14
  800b95:	5d                   	pop    %rbp
  800b96:	c3                   	ret

0000000000800b97 <exit>:

#include <inc/lib.h>

void
exit(void) {
  800b97:	f3 0f 1e fa          	endbr64
  800b9b:	55                   	push   %rbp
  800b9c:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  800b9f:	48 b8 a2 26 80 00 00 	movabs $0x8026a2,%rax
  800ba6:	00 00 00 
  800ba9:	ff d0                	call   *%rax
    sys_env_destroy(0);
  800bab:	bf 00 00 00 00       	mov    $0x0,%edi
  800bb0:	48 b8 77 1c 80 00 00 	movabs $0x801c77,%rax
  800bb7:	00 00 00 
  800bba:	ff d0                	call   *%rax
}
  800bbc:	5d                   	pop    %rbp
  800bbd:	c3                   	ret

0000000000800bbe <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  800bbe:	f3 0f 1e fa          	endbr64
  800bc2:	55                   	push   %rbp
  800bc3:	48 89 e5             	mov    %rsp,%rbp
  800bc6:	41 56                	push   %r14
  800bc8:	41 55                	push   %r13
  800bca:	41 54                	push   %r12
  800bcc:	53                   	push   %rbx
  800bcd:	48 83 ec 50          	sub    $0x50,%rsp
  800bd1:	49 89 fc             	mov    %rdi,%r12
  800bd4:	41 89 f5             	mov    %esi,%r13d
  800bd7:	48 89 d3             	mov    %rdx,%rbx
  800bda:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800bde:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  800be2:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800be6:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  800bed:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800bf1:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  800bf5:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  800bf9:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  800bfd:	48 b8 38 60 80 00 00 	movabs $0x806038,%rax
  800c04:	00 00 00 
  800c07:	4c 8b 30             	mov    (%rax),%r14
  800c0a:	48 b8 e6 1c 80 00 00 	movabs $0x801ce6,%rax
  800c11:	00 00 00 
  800c14:	ff d0                	call   *%rax
  800c16:	89 c6                	mov    %eax,%esi
  800c18:	45 89 e8             	mov    %r13d,%r8d
  800c1b:	4c 89 e1             	mov    %r12,%rcx
  800c1e:	4c 89 f2             	mov    %r14,%rdx
  800c21:	48 bf 80 54 80 00 00 	movabs $0x805480,%rdi
  800c28:	00 00 00 
  800c2b:	b8 00 00 00 00       	mov    $0x0,%eax
  800c30:	49 bc 1a 0d 80 00 00 	movabs $0x800d1a,%r12
  800c37:	00 00 00 
  800c3a:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  800c3d:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  800c41:	48 89 df             	mov    %rbx,%rdi
  800c44:	48 b8 b2 0c 80 00 00 	movabs $0x800cb2,%rax
  800c4b:	00 00 00 
  800c4e:	ff d0                	call   *%rax
    cprintf("\n");
  800c50:	48 bf 03 50 80 00 00 	movabs $0x805003,%rdi
  800c57:	00 00 00 
  800c5a:	b8 00 00 00 00       	mov    $0x0,%eax
  800c5f:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  800c62:	cc                   	int3
  800c63:	eb fd                	jmp    800c62 <_panic+0xa4>

0000000000800c65 <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  800c65:	f3 0f 1e fa          	endbr64
  800c69:	55                   	push   %rbp
  800c6a:	48 89 e5             	mov    %rsp,%rbp
  800c6d:	53                   	push   %rbx
  800c6e:	48 83 ec 08          	sub    $0x8,%rsp
  800c72:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  800c75:	8b 06                	mov    (%rsi),%eax
  800c77:	8d 50 01             	lea    0x1(%rax),%edx
  800c7a:	89 16                	mov    %edx,(%rsi)
  800c7c:	48 98                	cltq
  800c7e:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  800c83:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  800c89:	74 0a                	je     800c95 <putch+0x30>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  800c8b:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  800c8f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800c93:	c9                   	leave
  800c94:	c3                   	ret
        sys_cputs(state->buf, state->offset);
  800c95:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  800c99:	be ff 00 00 00       	mov    $0xff,%esi
  800c9e:	48 b8 11 1c 80 00 00 	movabs $0x801c11,%rax
  800ca5:	00 00 00 
  800ca8:	ff d0                	call   *%rax
        state->offset = 0;
  800caa:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  800cb0:	eb d9                	jmp    800c8b <putch+0x26>

0000000000800cb2 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  800cb2:	f3 0f 1e fa          	endbr64
  800cb6:	55                   	push   %rbp
  800cb7:	48 89 e5             	mov    %rsp,%rbp
  800cba:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800cc1:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  800cc4:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  800ccb:	b9 21 00 00 00       	mov    $0x21,%ecx
  800cd0:	b8 00 00 00 00       	mov    $0x0,%eax
  800cd5:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  800cd8:	48 89 f1             	mov    %rsi,%rcx
  800cdb:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  800ce2:	48 bf 65 0c 80 00 00 	movabs $0x800c65,%rdi
  800ce9:	00 00 00 
  800cec:	48 b8 7a 0e 80 00 00 	movabs $0x800e7a,%rax
  800cf3:	00 00 00 
  800cf6:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  800cf8:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  800cff:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  800d06:	48 b8 11 1c 80 00 00 	movabs $0x801c11,%rax
  800d0d:	00 00 00 
  800d10:	ff d0                	call   *%rax

    return state.count;
}
  800d12:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  800d18:	c9                   	leave
  800d19:	c3                   	ret

0000000000800d1a <cprintf>:

int
cprintf(const char *fmt, ...) {
  800d1a:	f3 0f 1e fa          	endbr64
  800d1e:	55                   	push   %rbp
  800d1f:	48 89 e5             	mov    %rsp,%rbp
  800d22:	48 83 ec 50          	sub    $0x50,%rsp
  800d26:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  800d2a:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  800d2e:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800d32:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800d36:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  800d3a:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  800d41:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d45:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800d49:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800d4d:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  800d51:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  800d55:	48 b8 b2 0c 80 00 00 	movabs $0x800cb2,%rax
  800d5c:	00 00 00 
  800d5f:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  800d61:	c9                   	leave
  800d62:	c3                   	ret

0000000000800d63 <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  800d63:	f3 0f 1e fa          	endbr64
  800d67:	55                   	push   %rbp
  800d68:	48 89 e5             	mov    %rsp,%rbp
  800d6b:	41 57                	push   %r15
  800d6d:	41 56                	push   %r14
  800d6f:	41 55                	push   %r13
  800d71:	41 54                	push   %r12
  800d73:	53                   	push   %rbx
  800d74:	48 83 ec 18          	sub    $0x18,%rsp
  800d78:	49 89 fc             	mov    %rdi,%r12
  800d7b:	49 89 f5             	mov    %rsi,%r13
  800d7e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  800d82:	8b 45 10             	mov    0x10(%rbp),%eax
  800d85:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  800d88:	41 89 cf             	mov    %ecx,%r15d
  800d8b:	4c 39 fa             	cmp    %r15,%rdx
  800d8e:	73 5b                	jae    800deb <print_num+0x88>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  800d90:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  800d94:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  800d98:	85 db                	test   %ebx,%ebx
  800d9a:	7e 0e                	jle    800daa <print_num+0x47>
            putch(padc, put_arg);
  800d9c:	4c 89 ee             	mov    %r13,%rsi
  800d9f:	44 89 f7             	mov    %r14d,%edi
  800da2:	41 ff d4             	call   *%r12
        while (--width > 0) {
  800da5:	83 eb 01             	sub    $0x1,%ebx
  800da8:	75 f2                	jne    800d9c <print_num+0x39>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  800daa:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  800dae:	48 b9 ee 50 80 00 00 	movabs $0x8050ee,%rcx
  800db5:	00 00 00 
  800db8:	48 b8 dd 50 80 00 00 	movabs $0x8050dd,%rax
  800dbf:	00 00 00 
  800dc2:	48 0f 45 c8          	cmovne %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  800dc6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800dca:	ba 00 00 00 00       	mov    $0x0,%edx
  800dcf:	49 f7 f7             	div    %r15
  800dd2:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  800dd6:	4c 89 ee             	mov    %r13,%rsi
  800dd9:	41 ff d4             	call   *%r12
}
  800ddc:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800de0:	5b                   	pop    %rbx
  800de1:	41 5c                	pop    %r12
  800de3:	41 5d                	pop    %r13
  800de5:	41 5e                	pop    %r14
  800de7:	41 5f                	pop    %r15
  800de9:	5d                   	pop    %rbp
  800dea:	c3                   	ret
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  800deb:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800def:	ba 00 00 00 00       	mov    $0x0,%edx
  800df4:	49 f7 f7             	div    %r15
  800df7:	48 83 ec 08          	sub    $0x8,%rsp
  800dfb:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  800dff:	52                   	push   %rdx
  800e00:	45 0f be c9          	movsbl %r9b,%r9d
  800e04:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  800e08:	48 89 c2             	mov    %rax,%rdx
  800e0b:	48 b8 63 0d 80 00 00 	movabs $0x800d63,%rax
  800e12:	00 00 00 
  800e15:	ff d0                	call   *%rax
  800e17:	48 83 c4 10          	add    $0x10,%rsp
  800e1b:	eb 8d                	jmp    800daa <print_num+0x47>

0000000000800e1d <sprintputch>:
    char *end;
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
  800e1d:	f3 0f 1e fa          	endbr64
    state->count++;
  800e21:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  800e25:	48 8b 06             	mov    (%rsi),%rax
  800e28:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  800e2c:	73 0a                	jae    800e38 <sprintputch+0x1b>
        *state->start++ = ch;
  800e2e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800e32:	48 89 16             	mov    %rdx,(%rsi)
  800e35:	40 88 38             	mov    %dil,(%rax)
    }
}
  800e38:	c3                   	ret

0000000000800e39 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  800e39:	f3 0f 1e fa          	endbr64
  800e3d:	55                   	push   %rbp
  800e3e:	48 89 e5             	mov    %rsp,%rbp
  800e41:	48 83 ec 50          	sub    $0x50,%rsp
  800e45:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800e49:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800e4d:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  800e51:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800e58:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e5c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800e60:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800e64:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  800e68:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800e6c:	48 b8 7a 0e 80 00 00 	movabs $0x800e7a,%rax
  800e73:	00 00 00 
  800e76:	ff d0                	call   *%rax
}
  800e78:	c9                   	leave
  800e79:	c3                   	ret

0000000000800e7a <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  800e7a:	f3 0f 1e fa          	endbr64
  800e7e:	55                   	push   %rbp
  800e7f:	48 89 e5             	mov    %rsp,%rbp
  800e82:	41 57                	push   %r15
  800e84:	41 56                	push   %r14
  800e86:	41 55                	push   %r13
  800e88:	41 54                	push   %r12
  800e8a:	53                   	push   %rbx
  800e8b:	48 83 ec 38          	sub    $0x38,%rsp
  800e8f:	49 89 fe             	mov    %rdi,%r14
  800e92:	49 89 f5             	mov    %rsi,%r13
  800e95:	48 89 d3             	mov    %rdx,%rbx
    va_copy(aq, ap);
  800e98:	48 8b 01             	mov    (%rcx),%rax
  800e9b:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  800e9f:	48 8b 41 08          	mov    0x8(%rcx),%rax
  800ea3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ea7:	48 8b 41 10          	mov    0x10(%rcx),%rax
  800eab:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  800eaf:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  800eb3:	0f b6 3b             	movzbl (%rbx),%edi
  800eb6:	40 80 ff 25          	cmp    $0x25,%dil
  800eba:	74 18                	je     800ed4 <vprintfmt+0x5a>
            if (!ch) return;
  800ebc:	40 84 ff             	test   %dil,%dil
  800ebf:	0f 84 b2 06 00 00    	je     801577 <vprintfmt+0x6fd>
            putch(ch, put_arg);
  800ec5:	40 0f b6 ff          	movzbl %dil,%edi
  800ec9:	4c 89 ee             	mov    %r13,%rsi
  800ecc:	41 ff d6             	call   *%r14
        while ((ch = *ufmt++) != '%') {
  800ecf:	4c 89 e3             	mov    %r12,%rbx
  800ed2:	eb db                	jmp    800eaf <vprintfmt+0x35>
        bool altflag = 0, zflag = 0;
  800ed4:	be 00 00 00 00       	mov    $0x0,%esi
  800ed9:	c6 45 ab 00          	movb   $0x0,-0x55(%rbp)
        unsigned lflag = 0, base = 10;
  800edd:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  800ee2:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  800ee8:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  800eef:	c6 45 aa 20          	movb   $0x20,-0x56(%rbp)
        switch (ch = *ufmt++) {
  800ef3:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  800ef8:	41 0f b6 04 24       	movzbl (%r12),%eax
  800efd:	88 45 a0             	mov    %al,-0x60(%rbp)
  800f00:	83 e8 23             	sub    $0x23,%eax
  800f03:	3c 57                	cmp    $0x57,%al
  800f05:	0f 87 52 06 00 00    	ja     80155d <vprintfmt+0x6e3>
  800f0b:	0f b6 c0             	movzbl %al,%eax
  800f0e:	48 b9 00 56 80 00 00 	movabs $0x805600,%rcx
  800f15:	00 00 00 
  800f18:	3e ff 24 c1          	notrack jmp *(%rcx,%rax,8)
  800f1c:	49 89 dc             	mov    %rbx,%r12
            altflag = 1;
  800f1f:	c6 45 ab 01          	movb   $0x1,-0x55(%rbp)
  800f23:	eb ce                	jmp    800ef3 <vprintfmt+0x79>
        switch (ch = *ufmt++) {
  800f25:	49 89 dc             	mov    %rbx,%r12
  800f28:	be 01 00 00 00       	mov    $0x1,%esi
  800f2d:	eb c4                	jmp    800ef3 <vprintfmt+0x79>
            padc = ch;
  800f2f:	0f b6 45 a0          	movzbl -0x60(%rbp),%eax
  800f33:	88 45 aa             	mov    %al,-0x56(%rbp)
        switch (ch = *ufmt++) {
  800f36:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  800f39:	eb b8                	jmp    800ef3 <vprintfmt+0x79>
            precision = va_arg(aq, int);
  800f3b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f3e:	83 f8 2f             	cmp    $0x2f,%eax
  800f41:	77 24                	ja     800f67 <vprintfmt+0xed>
  800f43:	89 c1                	mov    %eax,%ecx
  800f45:	48 03 4d c8          	add    -0x38(%rbp),%rcx
  800f49:	83 c0 08             	add    $0x8,%eax
  800f4c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800f4f:	44 8b 39             	mov    (%rcx),%r15d
        switch (ch = *ufmt++) {
  800f52:	49 89 dc             	mov    %rbx,%r12
            if (width < 0) {
  800f55:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800f59:	79 98                	jns    800ef3 <vprintfmt+0x79>
                width = precision;
  800f5b:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
                precision = -1;
  800f5f:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  800f65:	eb 8c                	jmp    800ef3 <vprintfmt+0x79>
            precision = va_arg(aq, int);
  800f67:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  800f6b:	48 8d 41 08          	lea    0x8(%rcx),%rax
  800f6f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800f73:	eb da                	jmp    800f4f <vprintfmt+0xd5>
                precision = precision * 10 + ch - '0';
  800f75:	44 0f b6 7d a0       	movzbl -0x60(%rbp),%r15d
  800f7a:	41 83 ef 30          	sub    $0x30,%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  800f7e:	41 0f b6 44 24 01    	movzbl 0x1(%r12),%eax
  800f84:	3c 39                	cmp    $0x39,%al
  800f86:	77 1c                	ja     800fa4 <vprintfmt+0x12a>
            for (precision = 0;; ++ufmt) {
  800f88:	48 83 c3 01          	add    $0x1,%rbx
                precision = precision * 10 + ch - '0';
  800f8c:	43 8d 0c bf          	lea    (%r15,%r15,4),%ecx
  800f90:	0f b6 c0             	movzbl %al,%eax
  800f93:	44 8d 7c 48 d0       	lea    -0x30(%rax,%rcx,2),%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  800f98:	0f b6 03             	movzbl (%rbx),%eax
  800f9b:	3c 39                	cmp    $0x39,%al
  800f9d:	76 e9                	jbe    800f88 <vprintfmt+0x10e>
        process_precision:
  800f9f:	49 89 dc             	mov    %rbx,%r12
  800fa2:	eb b1                	jmp    800f55 <vprintfmt+0xdb>
        switch (ch = *ufmt++) {
  800fa4:	49 89 dc             	mov    %rbx,%r12
  800fa7:	eb ac                	jmp    800f55 <vprintfmt+0xdb>
            width = MAX(0, width);
  800fa9:	8b 4d ac             	mov    -0x54(%rbp),%ecx
  800fac:	85 c9                	test   %ecx,%ecx
  800fae:	b8 00 00 00 00       	mov    $0x0,%eax
  800fb3:	0f 49 c1             	cmovns %ecx,%eax
  800fb6:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  800fb9:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  800fbc:	e9 32 ff ff ff       	jmp    800ef3 <vprintfmt+0x79>
            lflag++;
  800fc1:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  800fc4:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  800fc7:	e9 27 ff ff ff       	jmp    800ef3 <vprintfmt+0x79>
            putch(va_arg(aq, int), put_arg);
  800fcc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800fcf:	83 f8 2f             	cmp    $0x2f,%eax
  800fd2:	77 19                	ja     800fed <vprintfmt+0x173>
  800fd4:	89 c2                	mov    %eax,%edx
  800fd6:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800fda:	83 c0 08             	add    $0x8,%eax
  800fdd:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800fe0:	8b 3a                	mov    (%rdx),%edi
  800fe2:	4c 89 ee             	mov    %r13,%rsi
  800fe5:	41 ff d6             	call   *%r14
            break;
  800fe8:	e9 c2 fe ff ff       	jmp    800eaf <vprintfmt+0x35>
            putch(va_arg(aq, int), put_arg);
  800fed:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ff1:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800ff5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ff9:	eb e5                	jmp    800fe0 <vprintfmt+0x166>
            int err = va_arg(aq, int);
  800ffb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ffe:	83 f8 2f             	cmp    $0x2f,%eax
  801001:	77 5a                	ja     80105d <vprintfmt+0x1e3>
  801003:	89 c2                	mov    %eax,%edx
  801005:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  801009:	83 c0 08             	add    $0x8,%eax
  80100c:	89 45 b8             	mov    %eax,-0x48(%rbp)
            if (err < 0) err = -err;
  80100f:	8b 02                	mov    (%rdx),%eax
  801011:	89 c1                	mov    %eax,%ecx
  801013:	f7 d9                	neg    %ecx
  801015:	0f 48 c8             	cmovs  %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  801018:	83 f9 13             	cmp    $0x13,%ecx
  80101b:	7f 4e                	jg     80106b <vprintfmt+0x1f1>
  80101d:	48 63 c1             	movslq %ecx,%rax
  801020:	48 ba c0 58 80 00 00 	movabs $0x8058c0,%rdx
  801027:	00 00 00 
  80102a:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  80102e:	48 85 c0             	test   %rax,%rax
  801031:	74 38                	je     80106b <vprintfmt+0x1f1>
                printfmt(putch, put_arg, "%s", strerr);
  801033:	48 89 c1             	mov    %rax,%rcx
  801036:	48 ba bb 50 80 00 00 	movabs $0x8050bb,%rdx
  80103d:	00 00 00 
  801040:	4c 89 ee             	mov    %r13,%rsi
  801043:	4c 89 f7             	mov    %r14,%rdi
  801046:	b8 00 00 00 00       	mov    $0x0,%eax
  80104b:	49 b8 39 0e 80 00 00 	movabs $0x800e39,%r8
  801052:	00 00 00 
  801055:	41 ff d0             	call   *%r8
  801058:	e9 52 fe ff ff       	jmp    800eaf <vprintfmt+0x35>
            int err = va_arg(aq, int);
  80105d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801061:	48 8d 42 08          	lea    0x8(%rdx),%rax
  801065:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801069:	eb a4                	jmp    80100f <vprintfmt+0x195>
                printfmt(putch, put_arg, "error %d", err);
  80106b:	48 ba 06 51 80 00 00 	movabs $0x805106,%rdx
  801072:	00 00 00 
  801075:	4c 89 ee             	mov    %r13,%rsi
  801078:	4c 89 f7             	mov    %r14,%rdi
  80107b:	b8 00 00 00 00       	mov    $0x0,%eax
  801080:	49 b8 39 0e 80 00 00 	movabs $0x800e39,%r8
  801087:	00 00 00 
  80108a:	41 ff d0             	call   *%r8
  80108d:	e9 1d fe ff ff       	jmp    800eaf <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  801092:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801095:	83 f8 2f             	cmp    $0x2f,%eax
  801098:	77 6c                	ja     801106 <vprintfmt+0x28c>
  80109a:	89 c2                	mov    %eax,%edx
  80109c:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8010a0:	83 c0 08             	add    $0x8,%eax
  8010a3:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8010a6:	48 8b 12             	mov    (%rdx),%rdx
            if (!ptr) ptr = "(null)";
  8010a9:	48 85 d2             	test   %rdx,%rdx
  8010ac:	48 b8 ff 50 80 00 00 	movabs $0x8050ff,%rax
  8010b3:	00 00 00 
  8010b6:	48 0f 45 c2          	cmovne %rdx,%rax
  8010ba:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
            if (width > 0 && padc != '-') {
  8010be:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8010c2:	7e 06                	jle    8010ca <vprintfmt+0x250>
  8010c4:	80 7d aa 2d          	cmpb   $0x2d,-0x56(%rbp)
  8010c8:	75 4a                	jne    801114 <vprintfmt+0x29a>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  8010ca:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8010ce:	4c 8d 60 01          	lea    0x1(%rax),%r12
  8010d2:	0f b6 00             	movzbl (%rax),%eax
  8010d5:	84 c0                	test   %al,%al
  8010d7:	0f 85 9a 00 00 00    	jne    801177 <vprintfmt+0x2fd>
            while (width-- > 0) putch(' ', put_arg);
  8010dd:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8010e0:	44 8d 60 ff          	lea    -0x1(%rax),%r12d
  8010e4:	85 c0                	test   %eax,%eax
  8010e6:	0f 8e c3 fd ff ff    	jle    800eaf <vprintfmt+0x35>
  8010ec:	4c 89 ee             	mov    %r13,%rsi
  8010ef:	bf 20 00 00 00       	mov    $0x20,%edi
  8010f4:	41 ff d6             	call   *%r14
  8010f7:	41 83 ec 01          	sub    $0x1,%r12d
  8010fb:	41 83 fc ff          	cmp    $0xffffffff,%r12d
  8010ff:	75 eb                	jne    8010ec <vprintfmt+0x272>
  801101:	e9 a9 fd ff ff       	jmp    800eaf <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  801106:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80110a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80110e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801112:	eb 92                	jmp    8010a6 <vprintfmt+0x22c>
                width -= strnlen(ptr, precision);
  801114:	49 63 f7             	movslq %r15d,%rsi
  801117:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  80111b:	48 b8 3d 16 80 00 00 	movabs $0x80163d,%rax
  801122:	00 00 00 
  801125:	ff d0                	call   *%rax
  801127:	48 89 c2             	mov    %rax,%rdx
  80112a:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80112d:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  80112f:	8d 70 ff             	lea    -0x1(%rax),%esi
  801132:	89 75 ac             	mov    %esi,-0x54(%rbp)
  801135:	85 c0                	test   %eax,%eax
  801137:	7e 91                	jle    8010ca <vprintfmt+0x250>
  801139:	44 0f be 65 aa       	movsbl -0x56(%rbp),%r12d
  80113e:	4c 89 ee             	mov    %r13,%rsi
  801141:	44 89 e7             	mov    %r12d,%edi
  801144:	41 ff d6             	call   *%r14
  801147:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  80114b:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80114e:	83 f8 ff             	cmp    $0xffffffff,%eax
  801151:	75 eb                	jne    80113e <vprintfmt+0x2c4>
  801153:	e9 72 ff ff ff       	jmp    8010ca <vprintfmt+0x250>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  801158:	0f b6 f8             	movzbl %al,%edi
  80115b:	4c 89 ee             	mov    %r13,%rsi
  80115e:	41 ff d6             	call   *%r14
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  801161:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  801165:	49 83 c4 01          	add    $0x1,%r12
  801169:	41 0f b6 44 24 ff    	movzbl -0x1(%r12),%eax
  80116f:	84 c0                	test   %al,%al
  801171:	0f 84 66 ff ff ff    	je     8010dd <vprintfmt+0x263>
  801177:	45 85 ff             	test   %r15d,%r15d
  80117a:	78 0a                	js     801186 <vprintfmt+0x30c>
  80117c:	41 83 ef 01          	sub    $0x1,%r15d
  801180:	0f 88 57 ff ff ff    	js     8010dd <vprintfmt+0x263>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  801186:	80 7d ab 00          	cmpb   $0x0,-0x55(%rbp)
  80118a:	74 cc                	je     801158 <vprintfmt+0x2de>
  80118c:	8d 50 e0             	lea    -0x20(%rax),%edx
  80118f:	bf 3f 00 00 00       	mov    $0x3f,%edi
  801194:	80 fa 5e             	cmp    $0x5e,%dl
  801197:	77 c2                	ja     80115b <vprintfmt+0x2e1>
  801199:	eb bd                	jmp    801158 <vprintfmt+0x2de>
    if (zflag) return va_arg(*ap, size_t);
  80119b:	40 84 f6             	test   %sil,%sil
  80119e:	75 26                	jne    8011c6 <vprintfmt+0x34c>
    switch (lflag) {
  8011a0:	85 d2                	test   %edx,%edx
  8011a2:	74 59                	je     8011fd <vprintfmt+0x383>
  8011a4:	83 fa 01             	cmp    $0x1,%edx
  8011a7:	74 7b                	je     801224 <vprintfmt+0x3aa>
        return va_arg(*ap, long long);
  8011a9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8011ac:	83 f8 2f             	cmp    $0x2f,%eax
  8011af:	0f 87 96 00 00 00    	ja     80124b <vprintfmt+0x3d1>
  8011b5:	89 c2                	mov    %eax,%edx
  8011b7:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8011bb:	83 c0 08             	add    $0x8,%eax
  8011be:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8011c1:	4c 8b 22             	mov    (%rdx),%r12
  8011c4:	eb 17                	jmp    8011dd <vprintfmt+0x363>
    if (zflag) return va_arg(*ap, size_t);
  8011c6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8011c9:	83 f8 2f             	cmp    $0x2f,%eax
  8011cc:	77 21                	ja     8011ef <vprintfmt+0x375>
  8011ce:	89 c2                	mov    %eax,%edx
  8011d0:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8011d4:	83 c0 08             	add    $0x8,%eax
  8011d7:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8011da:	4c 8b 22             	mov    (%rdx),%r12
            if (i < 0) {
  8011dd:	4d 85 e4             	test   %r12,%r12
  8011e0:	78 7a                	js     80125c <vprintfmt+0x3e2>
            num = i;
  8011e2:	4c 89 e2             	mov    %r12,%rdx
        unsigned lflag = 0, base = 10;
  8011e5:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  8011ea:	e9 50 02 00 00       	jmp    80143f <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8011ef:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8011f3:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8011f7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8011fb:	eb dd                	jmp    8011da <vprintfmt+0x360>
        return va_arg(*ap, int);
  8011fd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801200:	83 f8 2f             	cmp    $0x2f,%eax
  801203:	77 11                	ja     801216 <vprintfmt+0x39c>
  801205:	89 c2                	mov    %eax,%edx
  801207:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80120b:	83 c0 08             	add    $0x8,%eax
  80120e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801211:	4c 63 22             	movslq (%rdx),%r12
  801214:	eb c7                	jmp    8011dd <vprintfmt+0x363>
  801216:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80121a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80121e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801222:	eb ed                	jmp    801211 <vprintfmt+0x397>
        return va_arg(*ap, long);
  801224:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801227:	83 f8 2f             	cmp    $0x2f,%eax
  80122a:	77 11                	ja     80123d <vprintfmt+0x3c3>
  80122c:	89 c2                	mov    %eax,%edx
  80122e:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  801232:	83 c0 08             	add    $0x8,%eax
  801235:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801238:	4c 8b 22             	mov    (%rdx),%r12
  80123b:	eb a0                	jmp    8011dd <vprintfmt+0x363>
  80123d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801241:	48 8d 42 08          	lea    0x8(%rdx),%rax
  801245:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801249:	eb ed                	jmp    801238 <vprintfmt+0x3be>
        return va_arg(*ap, long long);
  80124b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80124f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  801253:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801257:	e9 65 ff ff ff       	jmp    8011c1 <vprintfmt+0x347>
                putch('-', put_arg);
  80125c:	4c 89 ee             	mov    %r13,%rsi
  80125f:	bf 2d 00 00 00       	mov    $0x2d,%edi
  801264:	41 ff d6             	call   *%r14
                i = -i;
  801267:	49 f7 dc             	neg    %r12
  80126a:	e9 73 ff ff ff       	jmp    8011e2 <vprintfmt+0x368>
    if (zflag) return va_arg(*ap, size_t);
  80126f:	40 84 f6             	test   %sil,%sil
  801272:	75 32                	jne    8012a6 <vprintfmt+0x42c>
    switch (lflag) {
  801274:	85 d2                	test   %edx,%edx
  801276:	74 5d                	je     8012d5 <vprintfmt+0x45b>
  801278:	83 fa 01             	cmp    $0x1,%edx
  80127b:	0f 84 82 00 00 00    	je     801303 <vprintfmt+0x489>
        return va_arg(*ap, unsigned long long);
  801281:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801284:	83 f8 2f             	cmp    $0x2f,%eax
  801287:	0f 87 a5 00 00 00    	ja     801332 <vprintfmt+0x4b8>
  80128d:	89 c2                	mov    %eax,%edx
  80128f:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  801293:	83 c0 08             	add    $0x8,%eax
  801296:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801299:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  80129c:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  8012a1:	e9 99 01 00 00       	jmp    80143f <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8012a6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8012a9:	83 f8 2f             	cmp    $0x2f,%eax
  8012ac:	77 19                	ja     8012c7 <vprintfmt+0x44d>
  8012ae:	89 c2                	mov    %eax,%edx
  8012b0:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8012b4:	83 c0 08             	add    $0x8,%eax
  8012b7:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8012ba:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  8012bd:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8012c2:	e9 78 01 00 00       	jmp    80143f <vprintfmt+0x5c5>
  8012c7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8012cb:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8012cf:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8012d3:	eb e5                	jmp    8012ba <vprintfmt+0x440>
        return va_arg(*ap, unsigned int);
  8012d5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8012d8:	83 f8 2f             	cmp    $0x2f,%eax
  8012db:	77 18                	ja     8012f5 <vprintfmt+0x47b>
  8012dd:	89 c2                	mov    %eax,%edx
  8012df:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8012e3:	83 c0 08             	add    $0x8,%eax
  8012e6:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8012e9:	8b 12                	mov    (%rdx),%edx
        unsigned lflag = 0, base = 10;
  8012eb:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  8012f0:	e9 4a 01 00 00       	jmp    80143f <vprintfmt+0x5c5>
  8012f5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8012f9:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8012fd:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801301:	eb e6                	jmp    8012e9 <vprintfmt+0x46f>
        return va_arg(*ap, unsigned long);
  801303:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801306:	83 f8 2f             	cmp    $0x2f,%eax
  801309:	77 19                	ja     801324 <vprintfmt+0x4aa>
  80130b:	89 c2                	mov    %eax,%edx
  80130d:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  801311:	83 c0 08             	add    $0x8,%eax
  801314:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801317:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  80131a:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  80131f:	e9 1b 01 00 00       	jmp    80143f <vprintfmt+0x5c5>
  801324:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801328:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80132c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801330:	eb e5                	jmp    801317 <vprintfmt+0x49d>
        return va_arg(*ap, unsigned long long);
  801332:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801336:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80133a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80133e:	e9 56 ff ff ff       	jmp    801299 <vprintfmt+0x41f>
    if (zflag) return va_arg(*ap, size_t);
  801343:	40 84 f6             	test   %sil,%sil
  801346:	75 2e                	jne    801376 <vprintfmt+0x4fc>
    switch (lflag) {
  801348:	85 d2                	test   %edx,%edx
  80134a:	74 59                	je     8013a5 <vprintfmt+0x52b>
  80134c:	83 fa 01             	cmp    $0x1,%edx
  80134f:	74 7f                	je     8013d0 <vprintfmt+0x556>
        return va_arg(*ap, unsigned long long);
  801351:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801354:	83 f8 2f             	cmp    $0x2f,%eax
  801357:	0f 87 9f 00 00 00    	ja     8013fc <vprintfmt+0x582>
  80135d:	89 c2                	mov    %eax,%edx
  80135f:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  801363:	83 c0 08             	add    $0x8,%eax
  801366:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801369:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  80136c:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  801371:	e9 c9 00 00 00       	jmp    80143f <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  801376:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801379:	83 f8 2f             	cmp    $0x2f,%eax
  80137c:	77 19                	ja     801397 <vprintfmt+0x51d>
  80137e:	89 c2                	mov    %eax,%edx
  801380:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  801384:	83 c0 08             	add    $0x8,%eax
  801387:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80138a:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  80138d:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  801392:	e9 a8 00 00 00       	jmp    80143f <vprintfmt+0x5c5>
  801397:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80139b:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80139f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8013a3:	eb e5                	jmp    80138a <vprintfmt+0x510>
        return va_arg(*ap, unsigned int);
  8013a5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8013a8:	83 f8 2f             	cmp    $0x2f,%eax
  8013ab:	77 15                	ja     8013c2 <vprintfmt+0x548>
  8013ad:	89 c2                	mov    %eax,%edx
  8013af:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8013b3:	83 c0 08             	add    $0x8,%eax
  8013b6:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8013b9:	8b 12                	mov    (%rdx),%edx
            base = 8;
  8013bb:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  8013c0:	eb 7d                	jmp    80143f <vprintfmt+0x5c5>
  8013c2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8013c6:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8013ca:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8013ce:	eb e9                	jmp    8013b9 <vprintfmt+0x53f>
        return va_arg(*ap, unsigned long);
  8013d0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8013d3:	83 f8 2f             	cmp    $0x2f,%eax
  8013d6:	77 16                	ja     8013ee <vprintfmt+0x574>
  8013d8:	89 c2                	mov    %eax,%edx
  8013da:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8013de:	83 c0 08             	add    $0x8,%eax
  8013e1:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8013e4:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  8013e7:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  8013ec:	eb 51                	jmp    80143f <vprintfmt+0x5c5>
  8013ee:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8013f2:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8013f6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8013fa:	eb e8                	jmp    8013e4 <vprintfmt+0x56a>
        return va_arg(*ap, unsigned long long);
  8013fc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801400:	48 8d 42 08          	lea    0x8(%rdx),%rax
  801404:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801408:	e9 5c ff ff ff       	jmp    801369 <vprintfmt+0x4ef>
            putch('0', put_arg);
  80140d:	4c 89 ee             	mov    %r13,%rsi
  801410:	bf 30 00 00 00       	mov    $0x30,%edi
  801415:	41 ff d6             	call   *%r14
            putch('x', put_arg);
  801418:	4c 89 ee             	mov    %r13,%rsi
  80141b:	bf 78 00 00 00       	mov    $0x78,%edi
  801420:	41 ff d6             	call   *%r14
            num = (uintptr_t)va_arg(aq, void *);
  801423:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801426:	83 f8 2f             	cmp    $0x2f,%eax
  801429:	77 47                	ja     801472 <vprintfmt+0x5f8>
  80142b:	89 c2                	mov    %eax,%edx
  80142d:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  801431:	83 c0 08             	add    $0x8,%eax
  801434:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801437:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  80143a:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  80143f:	48 83 ec 08          	sub    $0x8,%rsp
  801443:	80 7d a0 58          	cmpb   $0x58,-0x60(%rbp)
  801447:	0f 94 c0             	sete   %al
  80144a:	0f b6 c0             	movzbl %al,%eax
  80144d:	50                   	push   %rax
  80144e:	44 0f be 4d aa       	movsbl -0x56(%rbp),%r9d
  801453:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  801457:	4c 89 ee             	mov    %r13,%rsi
  80145a:	4c 89 f7             	mov    %r14,%rdi
  80145d:	48 b8 63 0d 80 00 00 	movabs $0x800d63,%rax
  801464:	00 00 00 
  801467:	ff d0                	call   *%rax
            break;
  801469:	48 83 c4 10          	add    $0x10,%rsp
  80146d:	e9 3d fa ff ff       	jmp    800eaf <vprintfmt+0x35>
            num = (uintptr_t)va_arg(aq, void *);
  801472:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801476:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80147a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80147e:	eb b7                	jmp    801437 <vprintfmt+0x5bd>
    if (zflag) return va_arg(*ap, size_t);
  801480:	40 84 f6             	test   %sil,%sil
  801483:	75 2b                	jne    8014b0 <vprintfmt+0x636>
    switch (lflag) {
  801485:	85 d2                	test   %edx,%edx
  801487:	74 56                	je     8014df <vprintfmt+0x665>
  801489:	83 fa 01             	cmp    $0x1,%edx
  80148c:	74 7f                	je     80150d <vprintfmt+0x693>
        return va_arg(*ap, unsigned long long);
  80148e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801491:	83 f8 2f             	cmp    $0x2f,%eax
  801494:	0f 87 a2 00 00 00    	ja     80153c <vprintfmt+0x6c2>
  80149a:	89 c2                	mov    %eax,%edx
  80149c:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8014a0:	83 c0 08             	add    $0x8,%eax
  8014a3:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8014a6:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  8014a9:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  8014ae:	eb 8f                	jmp    80143f <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8014b0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8014b3:	83 f8 2f             	cmp    $0x2f,%eax
  8014b6:	77 19                	ja     8014d1 <vprintfmt+0x657>
  8014b8:	89 c2                	mov    %eax,%edx
  8014ba:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8014be:	83 c0 08             	add    $0x8,%eax
  8014c1:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8014c4:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  8014c7:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8014cc:	e9 6e ff ff ff       	jmp    80143f <vprintfmt+0x5c5>
  8014d1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8014d5:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8014d9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8014dd:	eb e5                	jmp    8014c4 <vprintfmt+0x64a>
        return va_arg(*ap, unsigned int);
  8014df:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8014e2:	83 f8 2f             	cmp    $0x2f,%eax
  8014e5:	77 18                	ja     8014ff <vprintfmt+0x685>
  8014e7:	89 c2                	mov    %eax,%edx
  8014e9:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8014ed:	83 c0 08             	add    $0x8,%eax
  8014f0:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8014f3:	8b 12                	mov    (%rdx),%edx
            base = 16;
  8014f5:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  8014fa:	e9 40 ff ff ff       	jmp    80143f <vprintfmt+0x5c5>
  8014ff:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801503:	48 8d 42 08          	lea    0x8(%rdx),%rax
  801507:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80150b:	eb e6                	jmp    8014f3 <vprintfmt+0x679>
        return va_arg(*ap, unsigned long);
  80150d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801510:	83 f8 2f             	cmp    $0x2f,%eax
  801513:	77 19                	ja     80152e <vprintfmt+0x6b4>
  801515:	89 c2                	mov    %eax,%edx
  801517:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80151b:	83 c0 08             	add    $0x8,%eax
  80151e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801521:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  801524:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  801529:	e9 11 ff ff ff       	jmp    80143f <vprintfmt+0x5c5>
  80152e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801532:	48 8d 42 08          	lea    0x8(%rdx),%rax
  801536:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80153a:	eb e5                	jmp    801521 <vprintfmt+0x6a7>
        return va_arg(*ap, unsigned long long);
  80153c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801540:	48 8d 42 08          	lea    0x8(%rdx),%rax
  801544:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801548:	e9 59 ff ff ff       	jmp    8014a6 <vprintfmt+0x62c>
            putch(ch, put_arg);
  80154d:	4c 89 ee             	mov    %r13,%rsi
  801550:	bf 25 00 00 00       	mov    $0x25,%edi
  801555:	41 ff d6             	call   *%r14
            break;
  801558:	e9 52 f9 ff ff       	jmp    800eaf <vprintfmt+0x35>
            putch('%', put_arg);
  80155d:	4c 89 ee             	mov    %r13,%rsi
  801560:	bf 25 00 00 00       	mov    $0x25,%edi
  801565:	41 ff d6             	call   *%r14
            while ((--ufmt)[-1] != '%') /* nothing */
  801568:	48 83 eb 01          	sub    $0x1,%rbx
  80156c:	80 7b ff 25          	cmpb   $0x25,-0x1(%rbx)
  801570:	75 f6                	jne    801568 <vprintfmt+0x6ee>
  801572:	e9 38 f9 ff ff       	jmp    800eaf <vprintfmt+0x35>
}
  801577:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  80157b:	5b                   	pop    %rbx
  80157c:	41 5c                	pop    %r12
  80157e:	41 5d                	pop    %r13
  801580:	41 5e                	pop    %r14
  801582:	41 5f                	pop    %r15
  801584:	5d                   	pop    %rbp
  801585:	c3                   	ret

0000000000801586 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  801586:	f3 0f 1e fa          	endbr64
  80158a:	55                   	push   %rbp
  80158b:	48 89 e5             	mov    %rsp,%rbp
  80158e:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  801592:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801596:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  80159b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  80159f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  8015a6:	48 85 ff             	test   %rdi,%rdi
  8015a9:	74 2b                	je     8015d6 <vsnprintf+0x50>
  8015ab:	48 85 f6             	test   %rsi,%rsi
  8015ae:	74 26                	je     8015d6 <vsnprintf+0x50>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  8015b0:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  8015b4:	48 bf 1d 0e 80 00 00 	movabs $0x800e1d,%rdi
  8015bb:	00 00 00 
  8015be:	48 b8 7a 0e 80 00 00 	movabs $0x800e7a,%rax
  8015c5:	00 00 00 
  8015c8:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  8015ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015ce:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  8015d1:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8015d4:	c9                   	leave
  8015d5:	c3                   	ret
    if (!buf || n < 1) return -E_INVAL;
  8015d6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015db:	eb f7                	jmp    8015d4 <vsnprintf+0x4e>

00000000008015dd <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  8015dd:	f3 0f 1e fa          	endbr64
  8015e1:	55                   	push   %rbp
  8015e2:	48 89 e5             	mov    %rsp,%rbp
  8015e5:	48 83 ec 50          	sub    $0x50,%rsp
  8015e9:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8015ed:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8015f1:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  8015f5:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  8015fc:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801600:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801604:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801608:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  80160c:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  801610:	48 b8 86 15 80 00 00 	movabs $0x801586,%rax
  801617:	00 00 00 
  80161a:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  80161c:	c9                   	leave
  80161d:	c3                   	ret

000000000080161e <strlen>:
 * Primespipe runs 3x faster this way */

#define ASM 1

size_t
strlen(const char *s) {
  80161e:	f3 0f 1e fa          	endbr64
    size_t n = 0;
    while (*s++) n++;
  801622:	80 3f 00             	cmpb   $0x0,(%rdi)
  801625:	74 10                	je     801637 <strlen+0x19>
    size_t n = 0;
  801627:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  80162c:	48 83 c0 01          	add    $0x1,%rax
  801630:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  801634:	75 f6                	jne    80162c <strlen+0xe>
  801636:	c3                   	ret
    size_t n = 0;
  801637:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  80163c:	c3                   	ret

000000000080163d <strnlen>:

size_t
strnlen(const char *s, size_t size) {
  80163d:	f3 0f 1e fa          	endbr64
  801641:	48 89 f0             	mov    %rsi,%rax
    size_t n = 0;
  801644:	ba 00 00 00 00       	mov    $0x0,%edx
    while (n < size && *s++) n++;
  801649:	48 85 f6             	test   %rsi,%rsi
  80164c:	74 10                	je     80165e <strnlen+0x21>
  80164e:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  801652:	74 0b                	je     80165f <strnlen+0x22>
  801654:	48 83 c2 01          	add    $0x1,%rdx
  801658:	48 39 d0             	cmp    %rdx,%rax
  80165b:	75 f1                	jne    80164e <strnlen+0x11>
  80165d:	c3                   	ret
  80165e:	c3                   	ret
  80165f:	48 89 d0             	mov    %rdx,%rax
    return n;
}
  801662:	c3                   	ret

0000000000801663 <strcpy>:

char *
strcpy(char *dst, const char *src) {
  801663:	f3 0f 1e fa          	endbr64
  801667:	48 89 f8             	mov    %rdi,%rax
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  80166a:	ba 00 00 00 00       	mov    $0x0,%edx
  80166f:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  801673:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  801676:	48 83 c2 01          	add    $0x1,%rdx
  80167a:	84 c9                	test   %cl,%cl
  80167c:	75 f1                	jne    80166f <strcpy+0xc>
        ;
    return res;
}
  80167e:	c3                   	ret

000000000080167f <strcat>:

char *
strcat(char *dst, const char *src) {
  80167f:	f3 0f 1e fa          	endbr64
  801683:	55                   	push   %rbp
  801684:	48 89 e5             	mov    %rsp,%rbp
  801687:	41 54                	push   %r12
  801689:	53                   	push   %rbx
  80168a:	48 89 fb             	mov    %rdi,%rbx
  80168d:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  801690:	48 b8 1e 16 80 00 00 	movabs $0x80161e,%rax
  801697:	00 00 00 
  80169a:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  80169c:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  8016a0:	4c 89 e6             	mov    %r12,%rsi
  8016a3:	48 b8 63 16 80 00 00 	movabs $0x801663,%rax
  8016aa:	00 00 00 
  8016ad:	ff d0                	call   *%rax
    return dst;
}
  8016af:	48 89 d8             	mov    %rbx,%rax
  8016b2:	5b                   	pop    %rbx
  8016b3:	41 5c                	pop    %r12
  8016b5:	5d                   	pop    %rbp
  8016b6:	c3                   	ret

00000000008016b7 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8016b7:	f3 0f 1e fa          	endbr64
  8016bb:	48 89 f8             	mov    %rdi,%rax
    char *ret = dst;
    while (size-- > 0) {
  8016be:	48 85 d2             	test   %rdx,%rdx
  8016c1:	74 1f                	je     8016e2 <strncpy+0x2b>
  8016c3:	48 01 fa             	add    %rdi,%rdx
  8016c6:	48 89 f9             	mov    %rdi,%rcx
        *dst++ = *src;
  8016c9:	48 83 c1 01          	add    $0x1,%rcx
  8016cd:	44 0f b6 06          	movzbl (%rsi),%r8d
  8016d1:	44 88 41 ff          	mov    %r8b,-0x1(%rcx)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  8016d5:	41 80 f8 01          	cmp    $0x1,%r8b
  8016d9:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  8016dd:	48 39 ca             	cmp    %rcx,%rdx
  8016e0:	75 e7                	jne    8016c9 <strncpy+0x12>
    }
    return ret;
}
  8016e2:	c3                   	ret

00000000008016e3 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
  8016e3:	f3 0f 1e fa          	endbr64
    char *dst_in = dst;
    if (size) {
  8016e7:	48 89 f8             	mov    %rdi,%rax
  8016ea:	48 85 d2             	test   %rdx,%rdx
  8016ed:	74 24                	je     801713 <strlcpy+0x30>
        while (--size > 0 && *src)
  8016ef:	48 83 ea 01          	sub    $0x1,%rdx
  8016f3:	74 1b                	je     801710 <strlcpy+0x2d>
  8016f5:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  8016f9:	0f b6 16             	movzbl (%rsi),%edx
  8016fc:	84 d2                	test   %dl,%dl
  8016fe:	74 10                	je     801710 <strlcpy+0x2d>
            *dst++ = *src++;
  801700:	48 83 c6 01          	add    $0x1,%rsi
  801704:	48 83 c0 01          	add    $0x1,%rax
  801708:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  80170b:	48 39 c8             	cmp    %rcx,%rax
  80170e:	75 e9                	jne    8016f9 <strlcpy+0x16>
        *dst = '\0';
  801710:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  801713:	48 29 f8             	sub    %rdi,%rax
}
  801716:	c3                   	ret

0000000000801717 <strcmp>:
    }
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
  801717:	f3 0f 1e fa          	endbr64
    while (*p && *p == *q) p++, q++;
  80171b:	0f b6 07             	movzbl (%rdi),%eax
  80171e:	84 c0                	test   %al,%al
  801720:	74 13                	je     801735 <strcmp+0x1e>
  801722:	38 06                	cmp    %al,(%rsi)
  801724:	75 0f                	jne    801735 <strcmp+0x1e>
  801726:	48 83 c7 01          	add    $0x1,%rdi
  80172a:	48 83 c6 01          	add    $0x1,%rsi
  80172e:	0f b6 07             	movzbl (%rdi),%eax
  801731:	84 c0                	test   %al,%al
  801733:	75 ed                	jne    801722 <strcmp+0xb>
    return (int)((unsigned char)*p - (unsigned char)*q);
  801735:	0f b6 c0             	movzbl %al,%eax
  801738:	0f b6 16             	movzbl (%rsi),%edx
  80173b:	29 d0                	sub    %edx,%eax
}
  80173d:	c3                   	ret

000000000080173e <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
  80173e:	f3 0f 1e fa          	endbr64
    while (n && *p && *p == *q) n--, p++, q++;
  801742:	48 85 d2             	test   %rdx,%rdx
  801745:	74 1f                	je     801766 <strncmp+0x28>
  801747:	0f b6 07             	movzbl (%rdi),%eax
  80174a:	84 c0                	test   %al,%al
  80174c:	74 1e                	je     80176c <strncmp+0x2e>
  80174e:	3a 06                	cmp    (%rsi),%al
  801750:	75 1a                	jne    80176c <strncmp+0x2e>
  801752:	48 83 c7 01          	add    $0x1,%rdi
  801756:	48 83 c6 01          	add    $0x1,%rsi
  80175a:	48 83 ea 01          	sub    $0x1,%rdx
  80175e:	75 e7                	jne    801747 <strncmp+0x9>

    if (!n) return 0;
  801760:	b8 00 00 00 00       	mov    $0x0,%eax
  801765:	c3                   	ret
  801766:	b8 00 00 00 00       	mov    $0x0,%eax
  80176b:	c3                   	ret

    return (int)((unsigned char)*p - (unsigned char)*q);
  80176c:	0f b6 07             	movzbl (%rdi),%eax
  80176f:	0f b6 16             	movzbl (%rsi),%edx
  801772:	29 d0                	sub    %edx,%eax
}
  801774:	c3                   	ret

0000000000801775 <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
  801775:	f3 0f 1e fa          	endbr64
    for (; *str; str++) {
  801779:	0f b6 17             	movzbl (%rdi),%edx
  80177c:	84 d2                	test   %dl,%dl
  80177e:	74 18                	je     801798 <strchr+0x23>
        if (*str == c) {
  801780:	0f be d2             	movsbl %dl,%edx
  801783:	39 f2                	cmp    %esi,%edx
  801785:	74 17                	je     80179e <strchr+0x29>
    for (; *str; str++) {
  801787:	48 83 c7 01          	add    $0x1,%rdi
  80178b:	0f b6 17             	movzbl (%rdi),%edx
  80178e:	84 d2                	test   %dl,%dl
  801790:	75 ee                	jne    801780 <strchr+0xb>
            return (char *)str;
        }
    }
    return NULL;
  801792:	b8 00 00 00 00       	mov    $0x0,%eax
  801797:	c3                   	ret
  801798:	b8 00 00 00 00       	mov    $0x0,%eax
  80179d:	c3                   	ret
            return (char *)str;
  80179e:	48 89 f8             	mov    %rdi,%rax
}
  8017a1:	c3                   	ret

00000000008017a2 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
  8017a2:	f3 0f 1e fa          	endbr64
  8017a6:	48 89 f8             	mov    %rdi,%rax
    for (; *str && *str != ch; str++) /* nothing */
  8017a9:	0f b6 17             	movzbl (%rdi),%edx
  8017ac:	84 d2                	test   %dl,%dl
  8017ae:	74 13                	je     8017c3 <strfind+0x21>
  8017b0:	0f be d2             	movsbl %dl,%edx
  8017b3:	39 f2                	cmp    %esi,%edx
  8017b5:	74 0b                	je     8017c2 <strfind+0x20>
  8017b7:	48 83 c0 01          	add    $0x1,%rax
  8017bb:	0f b6 10             	movzbl (%rax),%edx
  8017be:	84 d2                	test   %dl,%dl
  8017c0:	75 ee                	jne    8017b0 <strfind+0xe>
        ;
    return (char *)str;
}
  8017c2:	c3                   	ret
  8017c3:	c3                   	ret

00000000008017c4 <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  8017c4:	f3 0f 1e fa          	endbr64
  8017c8:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  8017cb:	48 89 f8             	mov    %rdi,%rax
  8017ce:	48 f7 d8             	neg    %rax
  8017d1:	83 e0 07             	and    $0x7,%eax
  8017d4:	49 89 d1             	mov    %rdx,%r9
  8017d7:	49 29 c1             	sub    %rax,%r9
  8017da:	78 36                	js     801812 <memset+0x4e>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  8017dc:	40 0f b6 c6          	movzbl %sil,%eax
  8017e0:	48 b9 01 01 01 01 01 	movabs $0x101010101010101,%rcx
  8017e7:	01 01 01 
  8017ea:	48 0f af c1          	imul   %rcx,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  8017ee:	40 f6 c7 07          	test   $0x7,%dil
  8017f2:	75 38                	jne    80182c <memset+0x68>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  8017f4:	4c 89 c9             	mov    %r9,%rcx
  8017f7:	48 c1 f9 03          	sar    $0x3,%rcx
  8017fb:	74 0c                	je     801809 <memset+0x45>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  8017fd:	fc                   	cld
  8017fe:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  801801:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  801805:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  801809:	4d 85 c9             	test   %r9,%r9
  80180c:	75 45                	jne    801853 <memset+0x8f>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  80180e:	4c 89 c0             	mov    %r8,%rax
  801811:	c3                   	ret
        while (n-- > 0) *ptr++ = c;
  801812:	48 85 d2             	test   %rdx,%rdx
  801815:	74 f7                	je     80180e <memset+0x4a>
  801817:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  80181a:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  80181d:	48 83 c0 01          	add    $0x1,%rax
  801821:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  801825:	48 39 c2             	cmp    %rax,%rdx
  801828:	75 f3                	jne    80181d <memset+0x59>
  80182a:	eb e2                	jmp    80180e <memset+0x4a>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  80182c:	40 f6 c7 01          	test   $0x1,%dil
  801830:	74 06                	je     801838 <memset+0x74>
  801832:	88 07                	mov    %al,(%rdi)
  801834:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  801838:	40 f6 c7 02          	test   $0x2,%dil
  80183c:	74 07                	je     801845 <memset+0x81>
  80183e:	66 89 07             	mov    %ax,(%rdi)
  801841:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  801845:	40 f6 c7 04          	test   $0x4,%dil
  801849:	74 a9                	je     8017f4 <memset+0x30>
  80184b:	89 07                	mov    %eax,(%rdi)
  80184d:	48 83 c7 04          	add    $0x4,%rdi
  801851:	eb a1                	jmp    8017f4 <memset+0x30>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  801853:	41 f6 c1 04          	test   $0x4,%r9b
  801857:	74 1b                	je     801874 <memset+0xb0>
  801859:	89 07                	mov    %eax,(%rdi)
  80185b:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  80185f:	41 f6 c1 02          	test   $0x2,%r9b
  801863:	74 07                	je     80186c <memset+0xa8>
  801865:	66 89 07             	mov    %ax,(%rdi)
  801868:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  80186c:	41 f6 c1 01          	test   $0x1,%r9b
  801870:	74 9c                	je     80180e <memset+0x4a>
  801872:	eb 06                	jmp    80187a <memset+0xb6>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  801874:	41 f6 c1 02          	test   $0x2,%r9b
  801878:	75 eb                	jne    801865 <memset+0xa1>
        if (ni & 1) *ptr = k;
  80187a:	88 07                	mov    %al,(%rdi)
  80187c:	eb 90                	jmp    80180e <memset+0x4a>

000000000080187e <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  80187e:	f3 0f 1e fa          	endbr64
  801882:	48 89 f8             	mov    %rdi,%rax
  801885:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  801888:	48 39 fe             	cmp    %rdi,%rsi
  80188b:	73 3b                	jae    8018c8 <memmove+0x4a>
  80188d:	48 8d 14 16          	lea    (%rsi,%rdx,1),%rdx
  801891:	48 39 d7             	cmp    %rdx,%rdi
  801894:	73 32                	jae    8018c8 <memmove+0x4a>
        s += n;
        d += n;
  801896:	48 8d 3c 0f          	lea    (%rdi,%rcx,1),%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  80189a:	48 89 d6             	mov    %rdx,%rsi
  80189d:	48 09 fe             	or     %rdi,%rsi
  8018a0:	48 09 ce             	or     %rcx,%rsi
  8018a3:	40 f6 c6 07          	test   $0x7,%sil
  8018a7:	75 12                	jne    8018bb <memmove+0x3d>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  8018a9:	48 83 ef 08          	sub    $0x8,%rdi
  8018ad:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  8018b1:	48 c1 e9 03          	shr    $0x3,%rcx
  8018b5:	fd                   	std
  8018b6:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  8018b9:	fc                   	cld
  8018ba:	c3                   	ret
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  8018bb:	48 83 ef 01          	sub    $0x1,%rdi
  8018bf:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  8018c3:	fd                   	std
  8018c4:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  8018c6:	eb f1                	jmp    8018b9 <memmove+0x3b>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  8018c8:	48 89 f2             	mov    %rsi,%rdx
  8018cb:	48 09 c2             	or     %rax,%rdx
  8018ce:	48 09 ca             	or     %rcx,%rdx
  8018d1:	f6 c2 07             	test   $0x7,%dl
  8018d4:	75 0c                	jne    8018e2 <memmove+0x64>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  8018d6:	48 c1 e9 03          	shr    $0x3,%rcx
  8018da:	48 89 c7             	mov    %rax,%rdi
  8018dd:	fc                   	cld
  8018de:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  8018e1:	c3                   	ret
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  8018e2:	48 89 c7             	mov    %rax,%rdi
  8018e5:	fc                   	cld
  8018e6:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  8018e8:	c3                   	ret

00000000008018e9 <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  8018e9:	f3 0f 1e fa          	endbr64
  8018ed:	55                   	push   %rbp
  8018ee:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  8018f1:	48 b8 7e 18 80 00 00 	movabs $0x80187e,%rax
  8018f8:	00 00 00 
  8018fb:	ff d0                	call   *%rax
}
  8018fd:	5d                   	pop    %rbp
  8018fe:	c3                   	ret

00000000008018ff <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  8018ff:	f3 0f 1e fa          	endbr64
  801903:	55                   	push   %rbp
  801904:	48 89 e5             	mov    %rsp,%rbp
  801907:	41 57                	push   %r15
  801909:	41 56                	push   %r14
  80190b:	41 55                	push   %r13
  80190d:	41 54                	push   %r12
  80190f:	53                   	push   %rbx
  801910:	48 83 ec 08          	sub    $0x8,%rsp
  801914:	49 89 fe             	mov    %rdi,%r14
  801917:	49 89 f7             	mov    %rsi,%r15
  80191a:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  80191d:	48 89 f7             	mov    %rsi,%rdi
  801920:	48 b8 1e 16 80 00 00 	movabs $0x80161e,%rax
  801927:	00 00 00 
  80192a:	ff d0                	call   *%rax
  80192c:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  80192f:	48 89 de             	mov    %rbx,%rsi
  801932:	4c 89 f7             	mov    %r14,%rdi
  801935:	48 b8 3d 16 80 00 00 	movabs $0x80163d,%rax
  80193c:	00 00 00 
  80193f:	ff d0                	call   *%rax
  801941:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  801944:	48 39 c3             	cmp    %rax,%rbx
  801947:	74 36                	je     80197f <strlcat+0x80>
    if (srclen < maxlen - dstlen) {
  801949:	48 89 d8             	mov    %rbx,%rax
  80194c:	4c 29 e8             	sub    %r13,%rax
  80194f:	49 39 c4             	cmp    %rax,%r12
  801952:	73 31                	jae    801985 <strlcat+0x86>
        memcpy(dst + dstlen, src, srclen + 1);
  801954:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  801959:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  80195d:	4c 89 fe             	mov    %r15,%rsi
  801960:	48 b8 e9 18 80 00 00 	movabs $0x8018e9,%rax
  801967:	00 00 00 
  80196a:	ff d0                	call   *%rax
    return dstlen + srclen;
  80196c:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  801970:	48 83 c4 08          	add    $0x8,%rsp
  801974:	5b                   	pop    %rbx
  801975:	41 5c                	pop    %r12
  801977:	41 5d                	pop    %r13
  801979:	41 5e                	pop    %r14
  80197b:	41 5f                	pop    %r15
  80197d:	5d                   	pop    %rbp
  80197e:	c3                   	ret
    if (dstlen == maxlen) return maxlen + srclen;
  80197f:	49 8d 04 04          	lea    (%r12,%rax,1),%rax
  801983:	eb eb                	jmp    801970 <strlcat+0x71>
        memcpy(dst + dstlen, src, maxlen - 1);
  801985:	48 83 eb 01          	sub    $0x1,%rbx
  801989:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  80198d:	48 89 da             	mov    %rbx,%rdx
  801990:	4c 89 fe             	mov    %r15,%rsi
  801993:	48 b8 e9 18 80 00 00 	movabs $0x8018e9,%rax
  80199a:	00 00 00 
  80199d:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  80199f:	49 01 de             	add    %rbx,%r14
  8019a2:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  8019a7:	eb c3                	jmp    80196c <strlcat+0x6d>

00000000008019a9 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  8019a9:	f3 0f 1e fa          	endbr64
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  8019ad:	48 85 d2             	test   %rdx,%rdx
  8019b0:	74 2d                	je     8019df <memcmp+0x36>
  8019b2:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  8019b7:	0f b6 0c 07          	movzbl (%rdi,%rax,1),%ecx
  8019bb:	44 0f b6 04 06       	movzbl (%rsi,%rax,1),%r8d
  8019c0:	44 38 c1             	cmp    %r8b,%cl
  8019c3:	75 0f                	jne    8019d4 <memcmp+0x2b>
    while (n-- > 0) {
  8019c5:	48 83 c0 01          	add    $0x1,%rax
  8019c9:	48 39 c2             	cmp    %rax,%rdx
  8019cc:	75 e9                	jne    8019b7 <memcmp+0xe>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  8019ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8019d3:	c3                   	ret
            return (int)*s1 - (int)*s2;
  8019d4:	0f b6 c1             	movzbl %cl,%eax
  8019d7:	45 0f b6 c0          	movzbl %r8b,%r8d
  8019db:	44 29 c0             	sub    %r8d,%eax
  8019de:	c3                   	ret
    return 0;
  8019df:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019e4:	c3                   	ret

00000000008019e5 <memfind>:

void *
memfind(const void *src, int c, size_t n) {
  8019e5:	f3 0f 1e fa          	endbr64
    const void *end = (const char *)src + n;
  8019e9:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  8019ed:	48 39 c7             	cmp    %rax,%rdi
  8019f0:	73 0f                	jae    801a01 <memfind+0x1c>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  8019f2:	40 38 37             	cmp    %sil,(%rdi)
  8019f5:	74 0e                	je     801a05 <memfind+0x20>
    for (; src < end; src++) {
  8019f7:	48 83 c7 01          	add    $0x1,%rdi
  8019fb:	48 39 f8             	cmp    %rdi,%rax
  8019fe:	75 f2                	jne    8019f2 <memfind+0xd>
  801a00:	c3                   	ret
  801a01:	48 89 f8             	mov    %rdi,%rax
  801a04:	c3                   	ret
  801a05:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  801a08:	c3                   	ret

0000000000801a09 <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  801a09:	f3 0f 1e fa          	endbr64
  801a0d:	49 89 f2             	mov    %rsi,%r10
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  801a10:	0f b6 37             	movzbl (%rdi),%esi
  801a13:	40 80 fe 20          	cmp    $0x20,%sil
  801a17:	74 06                	je     801a1f <strtol+0x16>
  801a19:	40 80 fe 09          	cmp    $0x9,%sil
  801a1d:	75 13                	jne    801a32 <strtol+0x29>
  801a1f:	48 83 c7 01          	add    $0x1,%rdi
  801a23:	0f b6 37             	movzbl (%rdi),%esi
  801a26:	40 80 fe 20          	cmp    $0x20,%sil
  801a2a:	74 f3                	je     801a1f <strtol+0x16>
  801a2c:	40 80 fe 09          	cmp    $0x9,%sil
  801a30:	74 ed                	je     801a1f <strtol+0x16>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  801a32:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  801a35:	83 e0 fd             	and    $0xfffffffd,%eax
  801a38:	3c 01                	cmp    $0x1,%al
  801a3a:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  801a3e:	f7 c2 ef ff ff ff    	test   $0xffffffef,%edx
  801a44:	75 0f                	jne    801a55 <strtol+0x4c>
  801a46:	80 3f 30             	cmpb   $0x30,(%rdi)
  801a49:	74 14                	je     801a5f <strtol+0x56>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  801a4b:	85 d2                	test   %edx,%edx
  801a4d:	b8 0a 00 00 00       	mov    $0xa,%eax
  801a52:	0f 44 d0             	cmove  %eax,%edx
    }

    /* Digits */
    long val = 0;
  801a55:	b8 00 00 00 00       	mov    $0x0,%eax
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  801a5a:	4c 63 ca             	movslq %edx,%r9
  801a5d:	eb 36                	jmp    801a95 <strtol+0x8c>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  801a5f:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  801a63:	74 0f                	je     801a74 <strtol+0x6b>
    } else if (!base && s[0] == '0') {
  801a65:	85 d2                	test   %edx,%edx
  801a67:	75 ec                	jne    801a55 <strtol+0x4c>
        s++;
  801a69:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  801a6d:	ba 08 00 00 00       	mov    $0x8,%edx
        s++;
  801a72:	eb e1                	jmp    801a55 <strtol+0x4c>
        s += 2;
  801a74:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  801a78:	ba 10 00 00 00       	mov    $0x10,%edx
        s += 2;
  801a7d:	eb d6                	jmp    801a55 <strtol+0x4c>
            dig -= '0';
  801a7f:	83 e9 30             	sub    $0x30,%ecx
        if (dig >= base) break;
  801a82:	44 0f b6 c1          	movzbl %cl,%r8d
  801a86:	41 39 d0             	cmp    %edx,%r8d
  801a89:	7d 21                	jge    801aac <strtol+0xa3>
        val = val * base + dig;
  801a8b:	49 0f af c1          	imul   %r9,%rax
  801a8f:	0f b6 c9             	movzbl %cl,%ecx
  801a92:	48 01 c8             	add    %rcx,%rax
        uint8_t dig = *s++;
  801a95:	48 83 c7 01          	add    $0x1,%rdi
  801a99:	0f b6 4f ff          	movzbl -0x1(%rdi),%ecx
        if (dig - '0' < 10)
  801a9d:	80 f9 39             	cmp    $0x39,%cl
  801aa0:	76 dd                	jbe    801a7f <strtol+0x76>
        else if (dig - 'a' < 27)
  801aa2:	80 f9 7b             	cmp    $0x7b,%cl
  801aa5:	77 05                	ja     801aac <strtol+0xa3>
            dig -= 'a' - 10;
  801aa7:	83 e9 57             	sub    $0x57,%ecx
  801aaa:	eb d6                	jmp    801a82 <strtol+0x79>
    }

    if (endptr) *endptr = (char *)s;
  801aac:	4d 85 d2             	test   %r10,%r10
  801aaf:	74 03                	je     801ab4 <strtol+0xab>
  801ab1:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  801ab4:	48 89 c2             	mov    %rax,%rdx
  801ab7:	48 f7 da             	neg    %rdx
  801aba:	40 80 fe 2d          	cmp    $0x2d,%sil
  801abe:	48 0f 44 c2          	cmove  %rdx,%rax
}
  801ac2:	c3                   	ret

0000000000801ac3 <readline>:
#define BUFLEN 1024

static char buf[BUFLEN];

char *
readline(const char *prompt) {
  801ac3:	f3 0f 1e fa          	endbr64
  801ac7:	55                   	push   %rbp
  801ac8:	48 89 e5             	mov    %rsp,%rbp
  801acb:	41 57                	push   %r15
  801acd:	41 56                	push   %r14
  801acf:	41 55                	push   %r13
  801ad1:	41 54                	push   %r12
  801ad3:	53                   	push   %rbx
  801ad4:	48 83 ec 08          	sub    $0x8,%rsp
    if (prompt) {
  801ad8:	48 85 ff             	test   %rdi,%rdi
  801adb:	74 23                	je     801b00 <readline+0x3d>
#if JOS_KERNEL
        cprintf("%s", prompt);
#else
        fprintf(1, "%s", prompt);
  801add:	48 89 fa             	mov    %rdi,%rdx
  801ae0:	48 be bb 50 80 00 00 	movabs $0x8050bb,%rsi
  801ae7:	00 00 00 
  801aea:	bf 01 00 00 00       	mov    $0x1,%edi
  801aef:	b8 00 00 00 00       	mov    $0x0,%eax
  801af4:	48 b9 2d 30 80 00 00 	movabs $0x80302d,%rcx
  801afb:	00 00 00 
  801afe:	ff d1                	call   *%rcx
#endif
    }

    bool echo = iscons(0);
  801b00:	bf 00 00 00 00       	mov    $0x0,%edi
  801b05:	48 b8 40 0a 80 00 00 	movabs $0x800a40,%rax
  801b0c:	00 00 00 
  801b0f:	ff d0                	call   *%rax
  801b11:	41 89 c6             	mov    %eax,%r14d

    for (size_t i = 0;;) {
  801b14:	41 bc 00 00 00 00    	mov    $0x0,%r12d
        int c = getchar();
  801b1a:	49 bd 03 0a 80 00 00 	movabs $0x800a03,%r13
  801b21:	00 00 00 
                cprintf("read error: %i\n", c);
            return NULL;
        } else if ((c == '\b' || c == '\x7F')) {
            if (i) {
                if (echo) {
                    cputchar('\b');
  801b24:	49 bf dc 09 80 00 00 	movabs $0x8009dc,%r15
  801b2b:	00 00 00 
  801b2e:	eb 46                	jmp    801b76 <readline+0xb3>
            return NULL;
  801b30:	b8 00 00 00 00       	mov    $0x0,%eax
            if (c != -E_EOF)
  801b35:	83 fb f4             	cmp    $0xfffffff4,%ebx
  801b38:	75 0f                	jne    801b49 <readline+0x86>
            }
            buf[i] = 0;
            return buf;
        }
    }
}
  801b3a:	48 83 c4 08          	add    $0x8,%rsp
  801b3e:	5b                   	pop    %rbx
  801b3f:	41 5c                	pop    %r12
  801b41:	41 5d                	pop    %r13
  801b43:	41 5e                	pop    %r14
  801b45:	41 5f                	pop    %r15
  801b47:	5d                   	pop    %rbp
  801b48:	c3                   	ret
                cprintf("read error: %i\n", c);
  801b49:	89 de                	mov    %ebx,%esi
  801b4b:	48 bf 6c 52 80 00 00 	movabs $0x80526c,%rdi
  801b52:	00 00 00 
  801b55:	48 ba 1a 0d 80 00 00 	movabs $0x800d1a,%rdx
  801b5c:	00 00 00 
  801b5f:	ff d2                	call   *%rdx
            return NULL;
  801b61:	b8 00 00 00 00       	mov    $0x0,%eax
  801b66:	eb d2                	jmp    801b3a <readline+0x77>
            if (i) {
  801b68:	4d 85 e4             	test   %r12,%r12
  801b6b:	74 09                	je     801b76 <readline+0xb3>
                if (echo) {
  801b6d:	45 85 f6             	test   %r14d,%r14d
  801b70:	75 3f                	jne    801bb1 <readline+0xee>
                i--;
  801b72:	49 83 ec 01          	sub    $0x1,%r12
        int c = getchar();
  801b76:	41 ff d5             	call   *%r13
  801b79:	89 c3                	mov    %eax,%ebx
        if (c < 0) {
  801b7b:	85 c0                	test   %eax,%eax
  801b7d:	78 b1                	js     801b30 <readline+0x6d>
        } else if ((c == '\b' || c == '\x7F')) {
  801b7f:	83 f8 08             	cmp    $0x8,%eax
  801b82:	74 e4                	je     801b68 <readline+0xa5>
  801b84:	83 f8 7f             	cmp    $0x7f,%eax
  801b87:	74 df                	je     801b68 <readline+0xa5>
        } else if (c >= ' ') {
  801b89:	83 f8 1f             	cmp    $0x1f,%eax
  801b8c:	7e 4d                	jle    801bdb <readline+0x118>
            if (i < BUFLEN - 1) {
  801b8e:	49 81 fc fe 03 00 00 	cmp    $0x3fe,%r12
  801b95:	77 df                	ja     801b76 <readline+0xb3>
                if (echo) {
  801b97:	45 85 f6             	test   %r14d,%r14d
  801b9a:	75 2f                	jne    801bcb <readline+0x108>
                buf[i++] = (char)c;
  801b9c:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  801ba3:	00 00 00 
  801ba6:	42 88 1c 20          	mov    %bl,(%rax,%r12,1)
  801baa:	4d 8d 64 24 01       	lea    0x1(%r12),%r12
  801baf:	eb c5                	jmp    801b76 <readline+0xb3>
                    cputchar('\b');
  801bb1:	bf 08 00 00 00       	mov    $0x8,%edi
  801bb6:	41 ff d7             	call   *%r15
                    cputchar(' ');
  801bb9:	bf 20 00 00 00       	mov    $0x20,%edi
  801bbe:	41 ff d7             	call   *%r15
                    cputchar('\b');
  801bc1:	bf 08 00 00 00       	mov    $0x8,%edi
  801bc6:	41 ff d7             	call   *%r15
  801bc9:	eb a7                	jmp    801b72 <readline+0xaf>
                    cputchar(c);
  801bcb:	89 c7                	mov    %eax,%edi
  801bcd:	48 b8 dc 09 80 00 00 	movabs $0x8009dc,%rax
  801bd4:	00 00 00 
  801bd7:	ff d0                	call   *%rax
  801bd9:	eb c1                	jmp    801b9c <readline+0xd9>
        } else if (c == '\n' || c == '\r') {
  801bdb:	83 f8 0a             	cmp    $0xa,%eax
  801bde:	74 05                	je     801be5 <readline+0x122>
  801be0:	83 f8 0d             	cmp    $0xd,%eax
  801be3:	75 91                	jne    801b76 <readline+0xb3>
            if (echo) {
  801be5:	45 85 f6             	test   %r14d,%r14d
  801be8:	75 14                	jne    801bfe <readline+0x13b>
            buf[i] = 0;
  801bea:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  801bf1:	00 00 00 
  801bf4:	42 c6 04 20 00       	movb   $0x0,(%rax,%r12,1)
            return buf;
  801bf9:	e9 3c ff ff ff       	jmp    801b3a <readline+0x77>
                cputchar('\n');
  801bfe:	bf 0a 00 00 00       	mov    $0xa,%edi
  801c03:	48 b8 dc 09 80 00 00 	movabs $0x8009dc,%rax
  801c0a:	00 00 00 
  801c0d:	ff d0                	call   *%rax
  801c0f:	eb d9                	jmp    801bea <readline+0x127>

0000000000801c11 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  801c11:	f3 0f 1e fa          	endbr64
  801c15:	55                   	push   %rbp
  801c16:	48 89 e5             	mov    %rsp,%rbp
  801c19:	53                   	push   %rbx
  801c1a:	48 89 fa             	mov    %rdi,%rdx
  801c1d:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801c20:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801c25:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c2a:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801c2f:	be 00 00 00 00       	mov    $0x0,%esi
  801c34:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801c3a:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  801c3c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801c40:	c9                   	leave
  801c41:	c3                   	ret

0000000000801c42 <sys_cgetc>:

int
sys_cgetc(void) {
  801c42:	f3 0f 1e fa          	endbr64
  801c46:	55                   	push   %rbp
  801c47:	48 89 e5             	mov    %rsp,%rbp
  801c4a:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801c4b:	b8 01 00 00 00       	mov    $0x1,%eax
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
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  801c71:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801c75:	c9                   	leave
  801c76:	c3                   	ret

0000000000801c77 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  801c77:	f3 0f 1e fa          	endbr64
  801c7b:	55                   	push   %rbp
  801c7c:	48 89 e5             	mov    %rsp,%rbp
  801c7f:	53                   	push   %rbx
  801c80:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  801c84:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801c87:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801c8c:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801c91:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c96:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801c9b:	be 00 00 00 00       	mov    $0x0,%esi
  801ca0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801ca6:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801ca8:	48 85 c0             	test   %rax,%rax
  801cab:	7f 06                	jg     801cb3 <sys_env_destroy+0x3c>
}
  801cad:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801cb1:	c9                   	leave
  801cb2:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801cb3:	49 89 c0             	mov    %rax,%r8
  801cb6:	b9 03 00 00 00       	mov    $0x3,%ecx
  801cbb:	48 ba c8 54 80 00 00 	movabs $0x8054c8,%rdx
  801cc2:	00 00 00 
  801cc5:	be 26 00 00 00       	mov    $0x26,%esi
  801cca:	48 bf 7c 52 80 00 00 	movabs $0x80527c,%rdi
  801cd1:	00 00 00 
  801cd4:	b8 00 00 00 00       	mov    $0x0,%eax
  801cd9:	49 b9 be 0b 80 00 00 	movabs $0x800bbe,%r9
  801ce0:	00 00 00 
  801ce3:	41 ff d1             	call   *%r9

0000000000801ce6 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  801ce6:	f3 0f 1e fa          	endbr64
  801cea:	55                   	push   %rbp
  801ceb:	48 89 e5             	mov    %rsp,%rbp
  801cee:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801cef:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801cf4:	ba 00 00 00 00       	mov    $0x0,%edx
  801cf9:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801cfe:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d03:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801d08:	be 00 00 00 00       	mov    $0x0,%esi
  801d0d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801d13:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  801d15:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801d19:	c9                   	leave
  801d1a:	c3                   	ret

0000000000801d1b <sys_yield>:

void
sys_yield(void) {
  801d1b:	f3 0f 1e fa          	endbr64
  801d1f:	55                   	push   %rbp
  801d20:	48 89 e5             	mov    %rsp,%rbp
  801d23:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801d24:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801d29:	ba 00 00 00 00       	mov    $0x0,%edx
  801d2e:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801d33:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d38:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801d3d:	be 00 00 00 00       	mov    $0x0,%esi
  801d42:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801d48:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  801d4a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801d4e:	c9                   	leave
  801d4f:	c3                   	ret

0000000000801d50 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  801d50:	f3 0f 1e fa          	endbr64
  801d54:	55                   	push   %rbp
  801d55:	48 89 e5             	mov    %rsp,%rbp
  801d58:	53                   	push   %rbx
  801d59:	48 89 fa             	mov    %rdi,%rdx
  801d5c:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801d5f:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801d64:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  801d6b:	00 00 00 
  801d6e:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801d73:	be 00 00 00 00       	mov    $0x0,%esi
  801d78:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801d7e:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  801d80:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801d84:	c9                   	leave
  801d85:	c3                   	ret

0000000000801d86 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  801d86:	f3 0f 1e fa          	endbr64
  801d8a:	55                   	push   %rbp
  801d8b:	48 89 e5             	mov    %rsp,%rbp
  801d8e:	53                   	push   %rbx
  801d8f:	49 89 f8             	mov    %rdi,%r8
  801d92:	48 89 d3             	mov    %rdx,%rbx
  801d95:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  801d98:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801d9d:	4c 89 c2             	mov    %r8,%rdx
  801da0:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801da3:	be 00 00 00 00       	mov    $0x0,%esi
  801da8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801dae:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  801db0:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801db4:	c9                   	leave
  801db5:	c3                   	ret

0000000000801db6 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  801db6:	f3 0f 1e fa          	endbr64
  801dba:	55                   	push   %rbp
  801dbb:	48 89 e5             	mov    %rsp,%rbp
  801dbe:	53                   	push   %rbx
  801dbf:	48 83 ec 08          	sub    $0x8,%rsp
  801dc3:	89 f8                	mov    %edi,%eax
  801dc5:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  801dc8:	48 63 f9             	movslq %ecx,%rdi
  801dcb:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801dce:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801dd3:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801dd6:	be 00 00 00 00       	mov    $0x0,%esi
  801ddb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801de1:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801de3:	48 85 c0             	test   %rax,%rax
  801de6:	7f 06                	jg     801dee <sys_alloc_region+0x38>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  801de8:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801dec:	c9                   	leave
  801ded:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801dee:	49 89 c0             	mov    %rax,%r8
  801df1:	b9 04 00 00 00       	mov    $0x4,%ecx
  801df6:	48 ba c8 54 80 00 00 	movabs $0x8054c8,%rdx
  801dfd:	00 00 00 
  801e00:	be 26 00 00 00       	mov    $0x26,%esi
  801e05:	48 bf 7c 52 80 00 00 	movabs $0x80527c,%rdi
  801e0c:	00 00 00 
  801e0f:	b8 00 00 00 00       	mov    $0x0,%eax
  801e14:	49 b9 be 0b 80 00 00 	movabs $0x800bbe,%r9
  801e1b:	00 00 00 
  801e1e:	41 ff d1             	call   *%r9

0000000000801e21 <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  801e21:	f3 0f 1e fa          	endbr64
  801e25:	55                   	push   %rbp
  801e26:	48 89 e5             	mov    %rsp,%rbp
  801e29:	53                   	push   %rbx
  801e2a:	48 83 ec 08          	sub    $0x8,%rsp
  801e2e:	89 f8                	mov    %edi,%eax
  801e30:	49 89 f2             	mov    %rsi,%r10
  801e33:	48 89 cf             	mov    %rcx,%rdi
  801e36:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  801e39:	48 63 da             	movslq %edx,%rbx
  801e3c:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801e3f:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801e44:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801e47:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  801e4a:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801e4c:	48 85 c0             	test   %rax,%rax
  801e4f:	7f 06                	jg     801e57 <sys_map_region+0x36>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  801e51:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801e55:	c9                   	leave
  801e56:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801e57:	49 89 c0             	mov    %rax,%r8
  801e5a:	b9 05 00 00 00       	mov    $0x5,%ecx
  801e5f:	48 ba c8 54 80 00 00 	movabs $0x8054c8,%rdx
  801e66:	00 00 00 
  801e69:	be 26 00 00 00       	mov    $0x26,%esi
  801e6e:	48 bf 7c 52 80 00 00 	movabs $0x80527c,%rdi
  801e75:	00 00 00 
  801e78:	b8 00 00 00 00       	mov    $0x0,%eax
  801e7d:	49 b9 be 0b 80 00 00 	movabs $0x800bbe,%r9
  801e84:	00 00 00 
  801e87:	41 ff d1             	call   *%r9

0000000000801e8a <sys_map_physical_region>:

int
sys_map_physical_region(uintptr_t pa, envid_t dstenv, void *dstva, size_t size, int perm) {
  801e8a:	f3 0f 1e fa          	endbr64
  801e8e:	55                   	push   %rbp
  801e8f:	48 89 e5             	mov    %rsp,%rbp
  801e92:	53                   	push   %rbx
  801e93:	48 83 ec 08          	sub    $0x8,%rsp
  801e97:	49 89 f9             	mov    %rdi,%r9
  801e9a:	89 f0                	mov    %esi,%eax
  801e9c:	48 89 d3             	mov    %rdx,%rbx
  801e9f:	48 89 cf             	mov    %rcx,%rdi
    int res = syscall(SYS_map_physical_region, 1, pa, dstenv, (uintptr_t)dstva, size, perm, 0);
  801ea2:	49 63 f0             	movslq %r8d,%rsi
  801ea5:	48 63 c8             	movslq %eax,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801ea8:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801ead:	4c 89 ca             	mov    %r9,%rdx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801eb0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801eb6:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801eb8:	48 85 c0             	test   %rax,%rax
  801ebb:	7f 06                	jg     801ec3 <sys_map_physical_region+0x39>
#ifdef SANITIZE_USER_SHADOW_BASE
    platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  801ebd:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801ec1:	c9                   	leave
  801ec2:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801ec3:	49 89 c0             	mov    %rax,%r8
  801ec6:	b9 06 00 00 00       	mov    $0x6,%ecx
  801ecb:	48 ba c8 54 80 00 00 	movabs $0x8054c8,%rdx
  801ed2:	00 00 00 
  801ed5:	be 26 00 00 00       	mov    $0x26,%esi
  801eda:	48 bf 7c 52 80 00 00 	movabs $0x80527c,%rdi
  801ee1:	00 00 00 
  801ee4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee9:	49 b9 be 0b 80 00 00 	movabs $0x800bbe,%r9
  801ef0:	00 00 00 
  801ef3:	41 ff d1             	call   *%r9

0000000000801ef6 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  801ef6:	f3 0f 1e fa          	endbr64
  801efa:	55                   	push   %rbp
  801efb:	48 89 e5             	mov    %rsp,%rbp
  801efe:	53                   	push   %rbx
  801eff:	48 83 ec 08          	sub    $0x8,%rsp
  801f03:	48 89 f1             	mov    %rsi,%rcx
  801f06:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  801f09:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801f0c:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801f11:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801f16:	be 00 00 00 00       	mov    $0x0,%esi
  801f1b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801f21:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801f23:	48 85 c0             	test   %rax,%rax
  801f26:	7f 06                	jg     801f2e <sys_unmap_region+0x38>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  801f28:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801f2c:	c9                   	leave
  801f2d:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801f2e:	49 89 c0             	mov    %rax,%r8
  801f31:	b9 07 00 00 00       	mov    $0x7,%ecx
  801f36:	48 ba c8 54 80 00 00 	movabs $0x8054c8,%rdx
  801f3d:	00 00 00 
  801f40:	be 26 00 00 00       	mov    $0x26,%esi
  801f45:	48 bf 7c 52 80 00 00 	movabs $0x80527c,%rdi
  801f4c:	00 00 00 
  801f4f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f54:	49 b9 be 0b 80 00 00 	movabs $0x800bbe,%r9
  801f5b:	00 00 00 
  801f5e:	41 ff d1             	call   *%r9

0000000000801f61 <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  801f61:	f3 0f 1e fa          	endbr64
  801f65:	55                   	push   %rbp
  801f66:	48 89 e5             	mov    %rsp,%rbp
  801f69:	53                   	push   %rbx
  801f6a:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  801f6e:	48 63 ce             	movslq %esi,%rcx
  801f71:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801f74:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801f79:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f7e:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801f83:	be 00 00 00 00       	mov    $0x0,%esi
  801f88:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801f8e:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801f90:	48 85 c0             	test   %rax,%rax
  801f93:	7f 06                	jg     801f9b <sys_env_set_status+0x3a>
}
  801f95:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801f99:	c9                   	leave
  801f9a:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801f9b:	49 89 c0             	mov    %rax,%r8
  801f9e:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801fa3:	48 ba c8 54 80 00 00 	movabs $0x8054c8,%rdx
  801faa:	00 00 00 
  801fad:	be 26 00 00 00       	mov    $0x26,%esi
  801fb2:	48 bf 7c 52 80 00 00 	movabs $0x80527c,%rdi
  801fb9:	00 00 00 
  801fbc:	b8 00 00 00 00       	mov    $0x0,%eax
  801fc1:	49 b9 be 0b 80 00 00 	movabs $0x800bbe,%r9
  801fc8:	00 00 00 
  801fcb:	41 ff d1             	call   *%r9

0000000000801fce <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  801fce:	f3 0f 1e fa          	endbr64
  801fd2:	55                   	push   %rbp
  801fd3:	48 89 e5             	mov    %rsp,%rbp
  801fd6:	53                   	push   %rbx
  801fd7:	48 83 ec 08          	sub    $0x8,%rsp
  801fdb:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  801fde:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801fe1:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801fe6:	bb 00 00 00 00       	mov    $0x0,%ebx
  801feb:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801ff0:	be 00 00 00 00       	mov    $0x0,%esi
  801ff5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801ffb:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801ffd:	48 85 c0             	test   %rax,%rax
  802000:	7f 06                	jg     802008 <sys_env_set_trapframe+0x3a>
}
  802002:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  802006:	c9                   	leave
  802007:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  802008:	49 89 c0             	mov    %rax,%r8
  80200b:	b9 0b 00 00 00       	mov    $0xb,%ecx
  802010:	48 ba c8 54 80 00 00 	movabs $0x8054c8,%rdx
  802017:	00 00 00 
  80201a:	be 26 00 00 00       	mov    $0x26,%esi
  80201f:	48 bf 7c 52 80 00 00 	movabs $0x80527c,%rdi
  802026:	00 00 00 
  802029:	b8 00 00 00 00       	mov    $0x0,%eax
  80202e:	49 b9 be 0b 80 00 00 	movabs $0x800bbe,%r9
  802035:	00 00 00 
  802038:	41 ff d1             	call   *%r9

000000000080203b <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  80203b:	f3 0f 1e fa          	endbr64
  80203f:	55                   	push   %rbp
  802040:	48 89 e5             	mov    %rsp,%rbp
  802043:	53                   	push   %rbx
  802044:	48 83 ec 08          	sub    $0x8,%rsp
  802048:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  80204b:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80204e:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  802053:	bb 00 00 00 00       	mov    $0x0,%ebx
  802058:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80205d:	be 00 00 00 00       	mov    $0x0,%esi
  802062:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  802068:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80206a:	48 85 c0             	test   %rax,%rax
  80206d:	7f 06                	jg     802075 <sys_env_set_pgfault_upcall+0x3a>
}
  80206f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  802073:	c9                   	leave
  802074:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  802075:	49 89 c0             	mov    %rax,%r8
  802078:	b9 0c 00 00 00       	mov    $0xc,%ecx
  80207d:	48 ba c8 54 80 00 00 	movabs $0x8054c8,%rdx
  802084:	00 00 00 
  802087:	be 26 00 00 00       	mov    $0x26,%esi
  80208c:	48 bf 7c 52 80 00 00 	movabs $0x80527c,%rdi
  802093:	00 00 00 
  802096:	b8 00 00 00 00       	mov    $0x0,%eax
  80209b:	49 b9 be 0b 80 00 00 	movabs $0x800bbe,%r9
  8020a2:	00 00 00 
  8020a5:	41 ff d1             	call   *%r9

00000000008020a8 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  8020a8:	f3 0f 1e fa          	endbr64
  8020ac:	55                   	push   %rbp
  8020ad:	48 89 e5             	mov    %rsp,%rbp
  8020b0:	53                   	push   %rbx
  8020b1:	89 f8                	mov    %edi,%eax
  8020b3:	49 89 f1             	mov    %rsi,%r9
  8020b6:	48 89 d3             	mov    %rdx,%rbx
  8020b9:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  8020bc:	49 63 f0             	movslq %r8d,%rsi
  8020bf:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8020c2:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8020c7:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8020ca:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8020d0:	cd 30                	int    $0x30
}
  8020d2:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8020d6:	c9                   	leave
  8020d7:	c3                   	ret

00000000008020d8 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  8020d8:	f3 0f 1e fa          	endbr64
  8020dc:	55                   	push   %rbp
  8020dd:	48 89 e5             	mov    %rsp,%rbp
  8020e0:	53                   	push   %rbx
  8020e1:	48 83 ec 08          	sub    $0x8,%rsp
  8020e5:	48 89 fa             	mov    %rdi,%rdx
  8020e8:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8020eb:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8020f0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8020f5:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8020fa:	be 00 00 00 00       	mov    $0x0,%esi
  8020ff:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  802105:	cd 30                	int    $0x30
    if (check && ret > 0) {
  802107:	48 85 c0             	test   %rax,%rax
  80210a:	7f 06                	jg     802112 <sys_ipc_recv+0x3a>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  80210c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  802110:	c9                   	leave
  802111:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  802112:	49 89 c0             	mov    %rax,%r8
  802115:	b9 0f 00 00 00       	mov    $0xf,%ecx
  80211a:	48 ba c8 54 80 00 00 	movabs $0x8054c8,%rdx
  802121:	00 00 00 
  802124:	be 26 00 00 00       	mov    $0x26,%esi
  802129:	48 bf 7c 52 80 00 00 	movabs $0x80527c,%rdi
  802130:	00 00 00 
  802133:	b8 00 00 00 00       	mov    $0x0,%eax
  802138:	49 b9 be 0b 80 00 00 	movabs $0x800bbe,%r9
  80213f:	00 00 00 
  802142:	41 ff d1             	call   *%r9

0000000000802145 <sys_gettime>:

int
sys_gettime(void) {
  802145:	f3 0f 1e fa          	endbr64
  802149:	55                   	push   %rbp
  80214a:	48 89 e5             	mov    %rsp,%rbp
  80214d:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80214e:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  802153:	ba 00 00 00 00       	mov    $0x0,%edx
  802158:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80215d:	bb 00 00 00 00       	mov    $0x0,%ebx
  802162:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  802167:	be 00 00 00 00       	mov    $0x0,%esi
  80216c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  802172:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  802174:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  802178:	c9                   	leave
  802179:	c3                   	ret

000000000080217a <fork>:
 *   Use sys_map_region, it can perform address space copying in one call
 *   Don't forget to set page fault handler in the child (using sys_env_set_pgfault_upcall()).
 *   Remember to fix "thisenv" in the child process.
 */
envid_t
fork(void) {
  80217a:	f3 0f 1e fa          	endbr64
  80217e:	55                   	push   %rbp
  80217f:	48 89 e5             	mov    %rsp,%rbp
  802182:	41 56                	push   %r14
  802184:	41 55                	push   %r13
  802186:	41 54                	push   %r12
  802188:	53                   	push   %rbx
    // LAB 9: Your code here.
    bool has_pgfault_upcall = thisenv->env_pgfault_upcall;
  802189:	48 a1 18 70 80 00 00 	movabs 0x807018,%rax
  802190:	00 00 00 
  802193:	4c 8b b0 00 01 00 00 	mov    0x100(%rax),%r14

/* This must be inlined. Exercise for reader: why? */
static inline envid_t __attribute__((always_inline))
sys_exofork(void) {
    envid_t ret;
    asm volatile("int %2"
  80219a:	b8 09 00 00 00       	mov    $0x9,%eax
  80219f:	cd 30                	int    $0x30
  8021a1:	41 89 c4             	mov    %eax,%r12d

    envid_t envid = sys_exofork();
    if (envid < 0) {
  8021a4:	85 c0                	test   %eax,%eax
  8021a6:	78 7f                	js     802227 <fork+0xad>
  8021a8:	89 c3                	mov    %eax,%ebx
        return envid;
    }
    if (envid == 0) {
  8021aa:	0f 84 83 00 00 00    	je     802233 <fork+0xb9>
        thisenv = &envs[ENVX(sys_getenvid())];
        return 0;
    }
    int res = sys_map_region(CURENVID, NULL, envid, NULL, MAX_USER_ADDRESS, PROT_ALL | PROT_LAZY | PROT_COMBINE);
  8021b0:	41 b9 ff 0f 00 00    	mov    $0xfff,%r9d
  8021b6:	49 b8 00 00 00 00 80 	movabs $0x8000000000,%r8
  8021bd:	00 00 00 
  8021c0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8021c5:	89 c2                	mov    %eax,%edx
  8021c7:	be 00 00 00 00       	mov    $0x0,%esi
  8021cc:	bf 00 00 00 00       	mov    $0x0,%edi
  8021d1:	48 b8 21 1e 80 00 00 	movabs $0x801e21,%rax
  8021d8:	00 00 00 
  8021db:	ff d0                	call   *%rax
  8021dd:	41 89 c5             	mov    %eax,%r13d
    if (res < 0) {
  8021e0:	85 c0                	test   %eax,%eax
  8021e2:	0f 88 81 00 00 00    	js     802269 <fork+0xef>
        sys_env_destroy(envid);
        return res;
    }
    if (has_pgfault_upcall) {
  8021e8:	4d 85 f6             	test   %r14,%r14
  8021eb:	74 20                	je     80220d <fork+0x93>
        res = sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  8021ed:	48 be 83 42 80 00 00 	movabs $0x804283,%rsi
  8021f4:	00 00 00 
  8021f7:	44 89 e7             	mov    %r12d,%edi
  8021fa:	48 b8 3b 20 80 00 00 	movabs $0x80203b,%rax
  802201:	00 00 00 
  802204:	ff d0                	call   *%rax
  802206:	41 89 c5             	mov    %eax,%r13d
        if (res < 0) {
  802209:	85 c0                	test   %eax,%eax
  80220b:	78 70                	js     80227d <fork+0x103>
            sys_env_destroy(envid);
            return res;
        }
    }
    res = sys_env_set_status(envid, ENV_RUNNABLE);
  80220d:	be 02 00 00 00       	mov    $0x2,%esi
  802212:	89 df                	mov    %ebx,%edi
  802214:	48 b8 61 1f 80 00 00 	movabs $0x801f61,%rax
  80221b:	00 00 00 
  80221e:	ff d0                	call   *%rax
  802220:	41 89 c5             	mov    %eax,%r13d
    if (res < 0) {
  802223:	85 c0                	test   %eax,%eax
  802225:	78 6a                	js     802291 <fork+0x117>
        sys_env_destroy(envid);
        return res;
    }
    return envid;
}
  802227:	44 89 e0             	mov    %r12d,%eax
  80222a:	5b                   	pop    %rbx
  80222b:	41 5c                	pop    %r12
  80222d:	41 5d                	pop    %r13
  80222f:	41 5e                	pop    %r14
  802231:	5d                   	pop    %rbp
  802232:	c3                   	ret
        thisenv = &envs[ENVX(sys_getenvid())];
  802233:	48 b8 e6 1c 80 00 00 	movabs $0x801ce6,%rax
  80223a:	00 00 00 
  80223d:	ff d0                	call   *%rax
  80223f:	25 ff 03 00 00       	and    $0x3ff,%eax
  802244:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802248:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  80224c:	48 c1 e0 04          	shl    $0x4,%rax
  802250:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  802257:	00 00 00 
  80225a:	48 01 d0             	add    %rdx,%rax
  80225d:	48 a3 18 70 80 00 00 	movabs %rax,0x807018
  802264:	00 00 00 
        return 0;
  802267:	eb be                	jmp    802227 <fork+0xad>
        sys_env_destroy(envid);
  802269:	44 89 e7             	mov    %r12d,%edi
  80226c:	48 b8 77 1c 80 00 00 	movabs $0x801c77,%rax
  802273:	00 00 00 
  802276:	ff d0                	call   *%rax
        return res;
  802278:	45 89 ec             	mov    %r13d,%r12d
  80227b:	eb aa                	jmp    802227 <fork+0xad>
            sys_env_destroy(envid);
  80227d:	44 89 e7             	mov    %r12d,%edi
  802280:	48 b8 77 1c 80 00 00 	movabs $0x801c77,%rax
  802287:	00 00 00 
  80228a:	ff d0                	call   *%rax
            return res;
  80228c:	45 89 ec             	mov    %r13d,%r12d
  80228f:	eb 96                	jmp    802227 <fork+0xad>
        sys_env_destroy(envid);
  802291:	89 df                	mov    %ebx,%edi
  802293:	48 b8 77 1c 80 00 00 	movabs $0x801c77,%rax
  80229a:	00 00 00 
  80229d:	ff d0                	call   *%rax
        return res;
  80229f:	45 89 ec             	mov    %r13d,%r12d
  8022a2:	eb 83                	jmp    802227 <fork+0xad>

00000000008022a4 <sfork>:

envid_t
sfork() {
  8022a4:	f3 0f 1e fa          	endbr64
  8022a8:	55                   	push   %rbp
  8022a9:	48 89 e5             	mov    %rsp,%rbp
    panic("sfork() is not implemented");
  8022ac:	48 ba 8a 52 80 00 00 	movabs $0x80528a,%rdx
  8022b3:	00 00 00 
  8022b6:	be 37 00 00 00       	mov    $0x37,%esi
  8022bb:	48 bf a5 52 80 00 00 	movabs $0x8052a5,%rdi
  8022c2:	00 00 00 
  8022c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8022ca:	48 b9 be 0b 80 00 00 	movabs $0x800bbe,%rcx
  8022d1:	00 00 00 
  8022d4:	ff d1                	call   *%rcx

00000000008022d6 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args) {
  8022d6:	f3 0f 1e fa          	endbr64
    args->argc = argc;
  8022da:	48 89 3a             	mov    %rdi,(%rdx)
    args->argv = (const char **)argv;
  8022dd:	48 89 72 08          	mov    %rsi,0x8(%rdx)
    args->curarg = (*argc > 1 && argv ? "" : NULL);
  8022e1:	83 3f 01             	cmpl   $0x1,(%rdi)
  8022e4:	7e 0f                	jle    8022f5 <argstart+0x1f>
  8022e6:	48 b8 04 50 80 00 00 	movabs $0x805004,%rax
  8022ed:	00 00 00 
  8022f0:	48 85 f6             	test   %rsi,%rsi
  8022f3:	75 05                	jne    8022fa <argstart+0x24>
  8022f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8022fa:	48 89 42 10          	mov    %rax,0x10(%rdx)
    args->argvalue = 0;
  8022fe:	48 c7 42 18 00 00 00 	movq   $0x0,0x18(%rdx)
  802305:	00 
}
  802306:	c3                   	ret

0000000000802307 <argnext>:

int
argnext(struct Argstate *args) {
  802307:	f3 0f 1e fa          	endbr64
    int arg;

    args->argvalue = 0;
  80230b:	48 c7 47 18 00 00 00 	movq   $0x0,0x18(%rdi)
  802312:	00 

    /* Done processing arguments if args->curarg == 0 */
    if (args->curarg == 0) return -1;
  802313:	48 8b 47 10          	mov    0x10(%rdi),%rax
  802317:	48 85 c0             	test   %rax,%rax
  80231a:	0f 84 8f 00 00 00    	je     8023af <argnext+0xa8>
argnext(struct Argstate *args) {
  802320:	55                   	push   %rbp
  802321:	48 89 e5             	mov    %rsp,%rbp
  802324:	53                   	push   %rbx
  802325:	48 83 ec 08          	sub    $0x8,%rsp
  802329:	48 89 fb             	mov    %rdi,%rbx

    if (!*args->curarg) {
  80232c:	80 38 00             	cmpb   $0x0,(%rax)
  80232f:	75 52                	jne    802383 <argnext+0x7c>
        /* Need to process the next argument
         * Check for end of argument list */
        if (*args->argc == 1 ||
  802331:	48 8b 17             	mov    (%rdi),%rdx
  802334:	83 3a 01             	cmpl   $0x1,(%rdx)
  802337:	74 67                	je     8023a0 <argnext+0x99>
            args->argv[1][0] != '-' ||
  802339:	48 8b 7f 08          	mov    0x8(%rdi),%rdi
  80233d:	48 8b 47 08          	mov    0x8(%rdi),%rax
        if (*args->argc == 1 ||
  802341:	80 38 2d             	cmpb   $0x2d,(%rax)
  802344:	75 5a                	jne    8023a0 <argnext+0x99>
            args->argv[1][0] != '-' ||
  802346:	80 78 01 00          	cmpb   $0x0,0x1(%rax)
  80234a:	74 54                	je     8023a0 <argnext+0x99>
            args->argv[1][1] == '\0') goto endofargs;

        /* Shift arguments down one */
        args->curarg = args->argv[1] + 1;
  80234c:	48 83 c0 01          	add    $0x1,%rax
  802350:	48 89 43 10          	mov    %rax,0x10(%rbx)
        memmove(args->argv + 1, args->argv + 2, sizeof(*args->argv) * (*args->argc - 1));
  802354:	8b 12                	mov    (%rdx),%edx
  802356:	83 ea 01             	sub    $0x1,%edx
  802359:	48 63 d2             	movslq %edx,%rdx
  80235c:	48 c1 e2 03          	shl    $0x3,%rdx
  802360:	48 8d 77 10          	lea    0x10(%rdi),%rsi
  802364:	48 83 c7 08          	add    $0x8,%rdi
  802368:	48 b8 7e 18 80 00 00 	movabs $0x80187e,%rax
  80236f:	00 00 00 
  802372:	ff d0                	call   *%rax

        (*args->argc)--;
  802374:	48 8b 03             	mov    (%rbx),%rax
  802377:	83 28 01             	subl   $0x1,(%rax)

        /* Check for "--": end of argument list */
        if (args->curarg[0] == '-' &&
  80237a:	48 8b 43 10          	mov    0x10(%rbx),%rax
  80237e:	80 38 2d             	cmpb   $0x2d,(%rax)
  802381:	74 17                	je     80239a <argnext+0x93>
            args->curarg[1] == '\0') goto endofargs;
    }

    arg = (unsigned char)*args->curarg;
  802383:	48 8b 43 10          	mov    0x10(%rbx),%rax
  802387:	0f b6 10             	movzbl (%rax),%edx
    args->curarg++;
  80238a:	48 83 c0 01          	add    $0x1,%rax
  80238e:	48 89 43 10          	mov    %rax,0x10(%rbx)
    return arg;

endofargs:
    args->curarg = 0;
    return -1;
}
  802392:	89 d0                	mov    %edx,%eax
  802394:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  802398:	c9                   	leave
  802399:	c3                   	ret
        if (args->curarg[0] == '-' &&
  80239a:	80 78 01 00          	cmpb   $0x0,0x1(%rax)
  80239e:	75 e3                	jne    802383 <argnext+0x7c>
    args->curarg = 0;
  8023a0:	48 c7 43 10 00 00 00 	movq   $0x0,0x10(%rbx)
  8023a7:	00 
    return -1;
  8023a8:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  8023ad:	eb e3                	jmp    802392 <argnext+0x8b>
    if (args->curarg == 0) return -1;
  8023af:	ba ff ff ff ff       	mov    $0xffffffff,%edx
}
  8023b4:	89 d0                	mov    %edx,%eax
  8023b6:	c3                   	ret

00000000008023b7 <argnextvalue>:
argvalue(struct Argstate *args) {
    return (char *)(args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args) {
  8023b7:	f3 0f 1e fa          	endbr64
    if (!args->curarg) return 0;
  8023bb:	48 8b 47 10          	mov    0x10(%rdi),%rax
  8023bf:	48 85 c0             	test   %rax,%rax
  8023c2:	74 7b                	je     80243f <argnextvalue+0x88>
argnextvalue(struct Argstate *args) {
  8023c4:	55                   	push   %rbp
  8023c5:	48 89 e5             	mov    %rsp,%rbp
  8023c8:	53                   	push   %rbx
  8023c9:	48 83 ec 08          	sub    $0x8,%rsp
  8023cd:	48 89 fb             	mov    %rdi,%rbx

    if (*args->curarg) {
  8023d0:	80 38 00             	cmpb   $0x0,(%rax)
  8023d3:	74 1c                	je     8023f1 <argnextvalue+0x3a>
        args->argvalue = args->curarg;
  8023d5:	48 89 47 18          	mov    %rax,0x18(%rdi)
        args->curarg = "";
  8023d9:	48 b8 04 50 80 00 00 	movabs $0x805004,%rax
  8023e0:	00 00 00 
  8023e3:	48 89 47 10          	mov    %rax,0x10(%rdi)
    } else {
        args->argvalue = 0;
        args->curarg = 0;
    }

    return (char *)args->argvalue;
  8023e7:	48 8b 43 18          	mov    0x18(%rbx),%rax
}
  8023eb:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8023ef:	c9                   	leave
  8023f0:	c3                   	ret
    } else if (*args->argc > 1) {
  8023f1:	48 8b 07             	mov    (%rdi),%rax
  8023f4:	83 38 01             	cmpl   $0x1,(%rax)
  8023f7:	7f 12                	jg     80240b <argnextvalue+0x54>
        args->argvalue = 0;
  8023f9:	48 c7 47 18 00 00 00 	movq   $0x0,0x18(%rdi)
  802400:	00 
        args->curarg = 0;
  802401:	48 c7 47 10 00 00 00 	movq   $0x0,0x10(%rdi)
  802408:	00 
  802409:	eb dc                	jmp    8023e7 <argnextvalue+0x30>
        args->argvalue = args->argv[1];
  80240b:	48 8b 7f 08          	mov    0x8(%rdi),%rdi
  80240f:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  802413:	48 89 53 18          	mov    %rdx,0x18(%rbx)
        memmove(args->argv + 1, args->argv + 2, sizeof(*args->argv) * (*args->argc - 1));
  802417:	8b 10                	mov    (%rax),%edx
  802419:	83 ea 01             	sub    $0x1,%edx
  80241c:	48 63 d2             	movslq %edx,%rdx
  80241f:	48 c1 e2 03          	shl    $0x3,%rdx
  802423:	48 8d 77 10          	lea    0x10(%rdi),%rsi
  802427:	48 83 c7 08          	add    $0x8,%rdi
  80242b:	48 b8 7e 18 80 00 00 	movabs $0x80187e,%rax
  802432:	00 00 00 
  802435:	ff d0                	call   *%rax
        (*args->argc)--;
  802437:	48 8b 03             	mov    (%rbx),%rax
  80243a:	83 28 01             	subl   $0x1,(%rax)
  80243d:	eb a8                	jmp    8023e7 <argnextvalue+0x30>
}
  80243f:	c3                   	ret

0000000000802440 <argvalue>:
argvalue(struct Argstate *args) {
  802440:	f3 0f 1e fa          	endbr64
    return (char *)(args->argvalue ? args->argvalue : argnextvalue(args));
  802444:	48 8b 47 18          	mov    0x18(%rdi),%rax
  802448:	48 85 c0             	test   %rax,%rax
  80244b:	74 01                	je     80244e <argvalue+0xe>
}
  80244d:	c3                   	ret
argvalue(struct Argstate *args) {
  80244e:	55                   	push   %rbp
  80244f:	48 89 e5             	mov    %rsp,%rbp
    return (char *)(args->argvalue ? args->argvalue : argnextvalue(args));
  802452:	48 b8 b7 23 80 00 00 	movabs $0x8023b7,%rax
  802459:	00 00 00 
  80245c:	ff d0                	call   *%rax
}
  80245e:	5d                   	pop    %rbp
  80245f:	c3                   	ret

0000000000802460 <fd2num>:


/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
  802460:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  802464:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80246b:	ff ff ff 
  80246e:	48 01 f8             	add    %rdi,%rax
  802471:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802475:	c3                   	ret

0000000000802476 <fd2data>:

char *
fd2data(struct Fd *fd) {
  802476:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80247a:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802481:	ff ff ff 
  802484:	48 01 f8             	add    %rdi,%rax
  802487:	48 c1 e8 0c          	shr    $0xc,%rax
    return INDEX2DATA(fd2num(fd));
  80248b:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802491:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802495:	c3                   	ret

0000000000802496 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  802496:	f3 0f 1e fa          	endbr64
  80249a:	55                   	push   %rbp
  80249b:	48 89 e5             	mov    %rsp,%rbp
  80249e:	41 57                	push   %r15
  8024a0:	41 56                	push   %r14
  8024a2:	41 55                	push   %r13
  8024a4:	41 54                	push   %r12
  8024a6:	53                   	push   %rbx
  8024a7:	48 83 ec 08          	sub    $0x8,%rsp
  8024ab:	49 89 ff             	mov    %rdi,%r15
  8024ae:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  8024b3:	49 bd fc 40 80 00 00 	movabs $0x8040fc,%r13
  8024ba:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  8024bd:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        struct Fd *fd = INDEX2FD(i);
  8024c3:	49 89 dc             	mov    %rbx,%r12
        if (!(get_prot(fd) & PROT_R)) {
  8024c6:	48 89 df             	mov    %rbx,%rdi
  8024c9:	41 ff d5             	call   *%r13
  8024cc:	83 e0 04             	and    $0x4,%eax
  8024cf:	74 17                	je     8024e8 <fd_alloc+0x52>
    for (int i = 0; i < MAXFD; i++) {
  8024d1:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  8024d8:	4c 39 f3             	cmp    %r14,%rbx
  8024db:	75 e6                	jne    8024c3 <fd_alloc+0x2d>
  8024dd:	41 bc 00 00 00 00    	mov    $0x0,%r12d
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
    return -E_MAX_OPEN;
  8024e3:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
            *fd_store = fd;
  8024e8:	4d 89 27             	mov    %r12,(%r15)
}
  8024eb:	48 83 c4 08          	add    $0x8,%rsp
  8024ef:	5b                   	pop    %rbx
  8024f0:	41 5c                	pop    %r12
  8024f2:	41 5d                	pop    %r13
  8024f4:	41 5e                	pop    %r14
  8024f6:	41 5f                	pop    %r15
  8024f8:	5d                   	pop    %rbp
  8024f9:	c3                   	ret

00000000008024fa <fd_lookup>:
 *
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
  8024fa:	f3 0f 1e fa          	endbr64
    if (fdnum < 0 || fdnum >= MAXFD) {
  8024fe:	83 ff 1f             	cmp    $0x1f,%edi
  802501:	77 39                	ja     80253c <fd_lookup+0x42>
fd_lookup(int fdnum, struct Fd **fd_store) {
  802503:	55                   	push   %rbp
  802504:	48 89 e5             	mov    %rsp,%rbp
  802507:	41 54                	push   %r12
  802509:	53                   	push   %rbx
  80250a:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  80250d:	48 63 df             	movslq %edi,%rbx
  802510:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  802517:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  80251b:	48 89 df             	mov    %rbx,%rdi
  80251e:	48 b8 fc 40 80 00 00 	movabs $0x8040fc,%rax
  802525:	00 00 00 
  802528:	ff d0                	call   *%rax
  80252a:	a8 04                	test   $0x4,%al
  80252c:	74 14                	je     802542 <fd_lookup+0x48>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  80252e:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  802532:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802537:	5b                   	pop    %rbx
  802538:	41 5c                	pop    %r12
  80253a:	5d                   	pop    %rbp
  80253b:	c3                   	ret
        return -E_INVAL;
  80253c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802541:	c3                   	ret
        return -E_INVAL;
  802542:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802547:	eb ee                	jmp    802537 <fd_lookup+0x3d>

0000000000802549 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  802549:	f3 0f 1e fa          	endbr64
  80254d:	55                   	push   %rbp
  80254e:	48 89 e5             	mov    %rsp,%rbp
  802551:	41 54                	push   %r12
  802553:	53                   	push   %rbx
  802554:	49 89 f4             	mov    %rsi,%r12
    for (size_t i = 0; devtab[i]; i++) {
  802557:	48 b8 60 59 80 00 00 	movabs $0x805960,%rax
  80255e:	00 00 00 
  802561:	48 bb 40 60 80 00 00 	movabs $0x806040,%rbx
  802568:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  80256b:	39 3b                	cmp    %edi,(%rbx)
  80256d:	74 47                	je     8025b6 <dev_lookup+0x6d>
    for (size_t i = 0; devtab[i]; i++) {
  80256f:	48 83 c0 08          	add    $0x8,%rax
  802573:	48 8b 18             	mov    (%rax),%rbx
  802576:	48 85 db             	test   %rbx,%rbx
  802579:	75 f0                	jne    80256b <dev_lookup+0x22>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80257b:	48 a1 18 70 80 00 00 	movabs 0x807018,%rax
  802582:	00 00 00 
  802585:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  80258b:	89 fa                	mov    %edi,%edx
  80258d:	48 bf e8 54 80 00 00 	movabs $0x8054e8,%rdi
  802594:	00 00 00 
  802597:	b8 00 00 00 00       	mov    $0x0,%eax
  80259c:	48 b9 1a 0d 80 00 00 	movabs $0x800d1a,%rcx
  8025a3:	00 00 00 
  8025a6:	ff d1                	call   *%rcx
    *dev = 0;
    return -E_INVAL;
  8025a8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
            *dev = devtab[i];
  8025ad:	49 89 1c 24          	mov    %rbx,(%r12)
}
  8025b1:	5b                   	pop    %rbx
  8025b2:	41 5c                	pop    %r12
  8025b4:	5d                   	pop    %rbp
  8025b5:	c3                   	ret
            return 0;
  8025b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8025bb:	eb f0                	jmp    8025ad <dev_lookup+0x64>

00000000008025bd <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  8025bd:	f3 0f 1e fa          	endbr64
  8025c1:	55                   	push   %rbp
  8025c2:	48 89 e5             	mov    %rsp,%rbp
  8025c5:	41 55                	push   %r13
  8025c7:	41 54                	push   %r12
  8025c9:	53                   	push   %rbx
  8025ca:	48 83 ec 18          	sub    $0x18,%rsp
  8025ce:	48 89 fb             	mov    %rdi,%rbx
  8025d1:	41 89 f4             	mov    %esi,%r12d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8025d4:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  8025db:	ff ff ff 
  8025de:	48 01 df             	add    %rbx,%rdi
  8025e1:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  8025e5:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8025e9:	48 b8 fa 24 80 00 00 	movabs $0x8024fa,%rax
  8025f0:	00 00 00 
  8025f3:	ff d0                	call   *%rax
  8025f5:	41 89 c5             	mov    %eax,%r13d
  8025f8:	85 c0                	test   %eax,%eax
  8025fa:	78 06                	js     802602 <fd_close+0x45>
  8025fc:	48 39 5d d8          	cmp    %rbx,-0x28(%rbp)
  802600:	74 1a                	je     80261c <fd_close+0x5f>
        return (must_exist ? res : 0);
  802602:	45 84 e4             	test   %r12b,%r12b
  802605:	b8 00 00 00 00       	mov    $0x0,%eax
  80260a:	44 0f 44 e8          	cmove  %eax,%r13d
}
  80260e:	44 89 e8             	mov    %r13d,%eax
  802611:	48 83 c4 18          	add    $0x18,%rsp
  802615:	5b                   	pop    %rbx
  802616:	41 5c                	pop    %r12
  802618:	41 5d                	pop    %r13
  80261a:	5d                   	pop    %rbp
  80261b:	c3                   	ret
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80261c:	8b 3b                	mov    (%rbx),%edi
  80261e:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  802622:	48 b8 49 25 80 00 00 	movabs $0x802549,%rax
  802629:	00 00 00 
  80262c:	ff d0                	call   *%rax
  80262e:	41 89 c5             	mov    %eax,%r13d
  802631:	85 c0                	test   %eax,%eax
  802633:	78 1b                	js     802650 <fd_close+0x93>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  802635:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802639:	48 8b 40 20          	mov    0x20(%rax),%rax
  80263d:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  802643:	48 85 c0             	test   %rax,%rax
  802646:	74 08                	je     802650 <fd_close+0x93>
  802648:	48 89 df             	mov    %rbx,%rdi
  80264b:	ff d0                	call   *%rax
  80264d:	41 89 c5             	mov    %eax,%r13d
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  802650:	ba 00 10 00 00       	mov    $0x1000,%edx
  802655:	48 89 de             	mov    %rbx,%rsi
  802658:	bf 00 00 00 00       	mov    $0x0,%edi
  80265d:	48 b8 f6 1e 80 00 00 	movabs $0x801ef6,%rax
  802664:	00 00 00 
  802667:	ff d0                	call   *%rax
    return res;
  802669:	eb a3                	jmp    80260e <fd_close+0x51>

000000000080266b <close>:

int
close(int fdnum) {
  80266b:	f3 0f 1e fa          	endbr64
  80266f:	55                   	push   %rbp
  802670:	48 89 e5             	mov    %rsp,%rbp
  802673:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  802677:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  80267b:	48 b8 fa 24 80 00 00 	movabs $0x8024fa,%rax
  802682:	00 00 00 
  802685:	ff d0                	call   *%rax
    if (res < 0) return res;
  802687:	85 c0                	test   %eax,%eax
  802689:	78 15                	js     8026a0 <close+0x35>

    return fd_close(fd, 1);
  80268b:	be 01 00 00 00       	mov    $0x1,%esi
  802690:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802694:	48 b8 bd 25 80 00 00 	movabs $0x8025bd,%rax
  80269b:	00 00 00 
  80269e:	ff d0                	call   *%rax
}
  8026a0:	c9                   	leave
  8026a1:	c3                   	ret

00000000008026a2 <close_all>:

void
close_all(void) {
  8026a2:	f3 0f 1e fa          	endbr64
  8026a6:	55                   	push   %rbp
  8026a7:	48 89 e5             	mov    %rsp,%rbp
  8026aa:	41 54                	push   %r12
  8026ac:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  8026ad:	bb 00 00 00 00       	mov    $0x0,%ebx
  8026b2:	49 bc 6b 26 80 00 00 	movabs $0x80266b,%r12
  8026b9:	00 00 00 
  8026bc:	89 df                	mov    %ebx,%edi
  8026be:	41 ff d4             	call   *%r12
  8026c1:	83 c3 01             	add    $0x1,%ebx
  8026c4:	83 fb 20             	cmp    $0x20,%ebx
  8026c7:	75 f3                	jne    8026bc <close_all+0x1a>
}
  8026c9:	5b                   	pop    %rbx
  8026ca:	41 5c                	pop    %r12
  8026cc:	5d                   	pop    %rbp
  8026cd:	c3                   	ret

00000000008026ce <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  8026ce:	f3 0f 1e fa          	endbr64
  8026d2:	55                   	push   %rbp
  8026d3:	48 89 e5             	mov    %rsp,%rbp
  8026d6:	41 57                	push   %r15
  8026d8:	41 56                	push   %r14
  8026da:	41 55                	push   %r13
  8026dc:	41 54                	push   %r12
  8026de:	53                   	push   %rbx
  8026df:	48 83 ec 18          	sub    $0x18,%rsp
  8026e3:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  8026e6:	48 8d 75 c8          	lea    -0x38(%rbp),%rsi
  8026ea:	48 b8 fa 24 80 00 00 	movabs $0x8024fa,%rax
  8026f1:	00 00 00 
  8026f4:	ff d0                	call   *%rax
  8026f6:	89 c3                	mov    %eax,%ebx
  8026f8:	85 c0                	test   %eax,%eax
  8026fa:	0f 88 b8 00 00 00    	js     8027b8 <dup+0xea>
    close(newfdnum);
  802700:	44 89 e7             	mov    %r12d,%edi
  802703:	48 b8 6b 26 80 00 00 	movabs $0x80266b,%rax
  80270a:	00 00 00 
  80270d:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  80270f:	4d 63 ec             	movslq %r12d,%r13
  802712:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  802719:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  80271d:	4c 8b 7d c8          	mov    -0x38(%rbp),%r15
  802721:	4c 89 ff             	mov    %r15,%rdi
  802724:	49 be 76 24 80 00 00 	movabs $0x802476,%r14
  80272b:	00 00 00 
  80272e:	41 ff d6             	call   *%r14
  802731:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  802734:	4c 89 ef             	mov    %r13,%rdi
  802737:	41 ff d6             	call   *%r14
  80273a:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  80273d:	48 89 df             	mov    %rbx,%rdi
  802740:	48 b8 fc 40 80 00 00 	movabs $0x8040fc,%rax
  802747:	00 00 00 
  80274a:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  80274c:	a8 04                	test   $0x4,%al
  80274e:	74 2b                	je     80277b <dup+0xad>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  802750:	41 89 c1             	mov    %eax,%r9d
  802753:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  802759:	4c 89 f1             	mov    %r14,%rcx
  80275c:	ba 00 00 00 00       	mov    $0x0,%edx
  802761:	48 89 de             	mov    %rbx,%rsi
  802764:	bf 00 00 00 00       	mov    $0x0,%edi
  802769:	48 b8 21 1e 80 00 00 	movabs $0x801e21,%rax
  802770:	00 00 00 
  802773:	ff d0                	call   *%rax
  802775:	89 c3                	mov    %eax,%ebx
  802777:	85 c0                	test   %eax,%eax
  802779:	78 4e                	js     8027c9 <dup+0xfb>
    }
    prot = get_prot(oldfd);
  80277b:	4c 89 ff             	mov    %r15,%rdi
  80277e:	48 b8 fc 40 80 00 00 	movabs $0x8040fc,%rax
  802785:	00 00 00 
  802788:	ff d0                	call   *%rax
  80278a:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  80278d:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  802793:	4c 89 e9             	mov    %r13,%rcx
  802796:	ba 00 00 00 00       	mov    $0x0,%edx
  80279b:	4c 89 fe             	mov    %r15,%rsi
  80279e:	bf 00 00 00 00       	mov    $0x0,%edi
  8027a3:	48 b8 21 1e 80 00 00 	movabs $0x801e21,%rax
  8027aa:	00 00 00 
  8027ad:	ff d0                	call   *%rax
  8027af:	89 c3                	mov    %eax,%ebx
  8027b1:	85 c0                	test   %eax,%eax
  8027b3:	78 14                	js     8027c9 <dup+0xfb>

    return newfdnum;
  8027b5:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  8027b8:	89 d8                	mov    %ebx,%eax
  8027ba:	48 83 c4 18          	add    $0x18,%rsp
  8027be:	5b                   	pop    %rbx
  8027bf:	41 5c                	pop    %r12
  8027c1:	41 5d                	pop    %r13
  8027c3:	41 5e                	pop    %r14
  8027c5:	41 5f                	pop    %r15
  8027c7:	5d                   	pop    %rbp
  8027c8:	c3                   	ret
    sys_unmap_region(0, newfd, PAGE_SIZE);
  8027c9:	ba 00 10 00 00       	mov    $0x1000,%edx
  8027ce:	4c 89 ee             	mov    %r13,%rsi
  8027d1:	bf 00 00 00 00       	mov    $0x0,%edi
  8027d6:	49 bc f6 1e 80 00 00 	movabs $0x801ef6,%r12
  8027dd:	00 00 00 
  8027e0:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  8027e3:	ba 00 10 00 00       	mov    $0x1000,%edx
  8027e8:	4c 89 f6             	mov    %r14,%rsi
  8027eb:	bf 00 00 00 00       	mov    $0x0,%edi
  8027f0:	41 ff d4             	call   *%r12
    return res;
  8027f3:	eb c3                	jmp    8027b8 <dup+0xea>

00000000008027f5 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  8027f5:	f3 0f 1e fa          	endbr64
  8027f9:	55                   	push   %rbp
  8027fa:	48 89 e5             	mov    %rsp,%rbp
  8027fd:	41 56                	push   %r14
  8027ff:	41 55                	push   %r13
  802801:	41 54                	push   %r12
  802803:	53                   	push   %rbx
  802804:	48 83 ec 10          	sub    $0x10,%rsp
  802808:	89 fb                	mov    %edi,%ebx
  80280a:	49 89 f4             	mov    %rsi,%r12
  80280d:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  802810:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  802814:	48 b8 fa 24 80 00 00 	movabs $0x8024fa,%rax
  80281b:	00 00 00 
  80281e:	ff d0                	call   *%rax
  802820:	85 c0                	test   %eax,%eax
  802822:	78 4c                	js     802870 <read+0x7b>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  802824:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  802828:	41 8b 3e             	mov    (%r14),%edi
  80282b:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  80282f:	48 b8 49 25 80 00 00 	movabs $0x802549,%rax
  802836:	00 00 00 
  802839:	ff d0                	call   *%rax
  80283b:	85 c0                	test   %eax,%eax
  80283d:	78 35                	js     802874 <read+0x7f>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80283f:	41 8b 46 08          	mov    0x8(%r14),%eax
  802843:	83 e0 03             	and    $0x3,%eax
  802846:	83 f8 01             	cmp    $0x1,%eax
  802849:	74 2d                	je     802878 <read+0x83>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  80284b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80284f:	48 8b 40 10          	mov    0x10(%rax),%rax
  802853:	48 85 c0             	test   %rax,%rax
  802856:	74 56                	je     8028ae <read+0xb9>

    return (*dev->dev_read)(fd, buf, n);
  802858:	4c 89 ea             	mov    %r13,%rdx
  80285b:	4c 89 e6             	mov    %r12,%rsi
  80285e:	4c 89 f7             	mov    %r14,%rdi
  802861:	ff d0                	call   *%rax
}
  802863:	48 83 c4 10          	add    $0x10,%rsp
  802867:	5b                   	pop    %rbx
  802868:	41 5c                	pop    %r12
  80286a:	41 5d                	pop    %r13
  80286c:	41 5e                	pop    %r14
  80286e:	5d                   	pop    %rbp
  80286f:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  802870:	48 98                	cltq
  802872:	eb ef                	jmp    802863 <read+0x6e>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  802874:	48 98                	cltq
  802876:	eb eb                	jmp    802863 <read+0x6e>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802878:	48 a1 18 70 80 00 00 	movabs 0x807018,%rax
  80287f:	00 00 00 
  802882:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  802888:	89 da                	mov    %ebx,%edx
  80288a:	48 bf b0 52 80 00 00 	movabs $0x8052b0,%rdi
  802891:	00 00 00 
  802894:	b8 00 00 00 00       	mov    $0x0,%eax
  802899:	48 b9 1a 0d 80 00 00 	movabs $0x800d1a,%rcx
  8028a0:	00 00 00 
  8028a3:	ff d1                	call   *%rcx
        return -E_INVAL;
  8028a5:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  8028ac:	eb b5                	jmp    802863 <read+0x6e>
    if (!dev->dev_read) return -E_NOT_SUPP;
  8028ae:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  8028b5:	eb ac                	jmp    802863 <read+0x6e>

00000000008028b7 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  8028b7:	f3 0f 1e fa          	endbr64
  8028bb:	55                   	push   %rbp
  8028bc:	48 89 e5             	mov    %rsp,%rbp
  8028bf:	41 57                	push   %r15
  8028c1:	41 56                	push   %r14
  8028c3:	41 55                	push   %r13
  8028c5:	41 54                	push   %r12
  8028c7:	53                   	push   %rbx
  8028c8:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  8028cc:	48 85 d2             	test   %rdx,%rdx
  8028cf:	74 54                	je     802925 <readn+0x6e>
  8028d1:	41 89 fd             	mov    %edi,%r13d
  8028d4:	49 89 f6             	mov    %rsi,%r14
  8028d7:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  8028da:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  8028df:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  8028e4:	49 bf f5 27 80 00 00 	movabs $0x8027f5,%r15
  8028eb:	00 00 00 
  8028ee:	4c 89 e2             	mov    %r12,%rdx
  8028f1:	48 29 f2             	sub    %rsi,%rdx
  8028f4:	4c 01 f6             	add    %r14,%rsi
  8028f7:	44 89 ef             	mov    %r13d,%edi
  8028fa:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  8028fd:	85 c0                	test   %eax,%eax
  8028ff:	78 20                	js     802921 <readn+0x6a>
    for (; inc && res < n; res += inc) {
  802901:	01 c3                	add    %eax,%ebx
  802903:	85 c0                	test   %eax,%eax
  802905:	74 08                	je     80290f <readn+0x58>
  802907:	48 63 f3             	movslq %ebx,%rsi
  80290a:	4c 39 e6             	cmp    %r12,%rsi
  80290d:	72 df                	jb     8028ee <readn+0x37>
    }
    return res;
  80290f:	48 63 c3             	movslq %ebx,%rax
}
  802912:	48 83 c4 08          	add    $0x8,%rsp
  802916:	5b                   	pop    %rbx
  802917:	41 5c                	pop    %r12
  802919:	41 5d                	pop    %r13
  80291b:	41 5e                	pop    %r14
  80291d:	41 5f                	pop    %r15
  80291f:	5d                   	pop    %rbp
  802920:	c3                   	ret
        if (inc < 0) return inc;
  802921:	48 98                	cltq
  802923:	eb ed                	jmp    802912 <readn+0x5b>
    int inc = 1, res = 0;
  802925:	bb 00 00 00 00       	mov    $0x0,%ebx
  80292a:	eb e3                	jmp    80290f <readn+0x58>

000000000080292c <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  80292c:	f3 0f 1e fa          	endbr64
  802930:	55                   	push   %rbp
  802931:	48 89 e5             	mov    %rsp,%rbp
  802934:	41 56                	push   %r14
  802936:	41 55                	push   %r13
  802938:	41 54                	push   %r12
  80293a:	53                   	push   %rbx
  80293b:	48 83 ec 10          	sub    $0x10,%rsp
  80293f:	89 fb                	mov    %edi,%ebx
  802941:	49 89 f4             	mov    %rsi,%r12
  802944:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  802947:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  80294b:	48 b8 fa 24 80 00 00 	movabs $0x8024fa,%rax
  802952:	00 00 00 
  802955:	ff d0                	call   *%rax
  802957:	85 c0                	test   %eax,%eax
  802959:	78 47                	js     8029a2 <write+0x76>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  80295b:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  80295f:	41 8b 3e             	mov    (%r14),%edi
  802962:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  802966:	48 b8 49 25 80 00 00 	movabs $0x802549,%rax
  80296d:	00 00 00 
  802970:	ff d0                	call   *%rax
  802972:	85 c0                	test   %eax,%eax
  802974:	78 30                	js     8029a6 <write+0x7a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802976:	41 f6 46 08 03       	testb  $0x3,0x8(%r14)
  80297b:	74 2d                	je     8029aa <write+0x7e>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  80297d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802981:	48 8b 40 18          	mov    0x18(%rax),%rax
  802985:	48 85 c0             	test   %rax,%rax
  802988:	74 56                	je     8029e0 <write+0xb4>

    return (*dev->dev_write)(fd, buf, n);
  80298a:	4c 89 ea             	mov    %r13,%rdx
  80298d:	4c 89 e6             	mov    %r12,%rsi
  802990:	4c 89 f7             	mov    %r14,%rdi
  802993:	ff d0                	call   *%rax
}
  802995:	48 83 c4 10          	add    $0x10,%rsp
  802999:	5b                   	pop    %rbx
  80299a:	41 5c                	pop    %r12
  80299c:	41 5d                	pop    %r13
  80299e:	41 5e                	pop    %r14
  8029a0:	5d                   	pop    %rbp
  8029a1:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8029a2:	48 98                	cltq
  8029a4:	eb ef                	jmp    802995 <write+0x69>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8029a6:	48 98                	cltq
  8029a8:	eb eb                	jmp    802995 <write+0x69>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8029aa:	48 a1 18 70 80 00 00 	movabs 0x807018,%rax
  8029b1:	00 00 00 
  8029b4:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  8029ba:	89 da                	mov    %ebx,%edx
  8029bc:	48 bf cc 52 80 00 00 	movabs $0x8052cc,%rdi
  8029c3:	00 00 00 
  8029c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8029cb:	48 b9 1a 0d 80 00 00 	movabs $0x800d1a,%rcx
  8029d2:	00 00 00 
  8029d5:	ff d1                	call   *%rcx
        return -E_INVAL;
  8029d7:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  8029de:	eb b5                	jmp    802995 <write+0x69>
    if (!dev->dev_write) return -E_NOT_SUPP;
  8029e0:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  8029e7:	eb ac                	jmp    802995 <write+0x69>

00000000008029e9 <seek>:

int
seek(int fdnum, off_t offset) {
  8029e9:	f3 0f 1e fa          	endbr64
  8029ed:	55                   	push   %rbp
  8029ee:	48 89 e5             	mov    %rsp,%rbp
  8029f1:	53                   	push   %rbx
  8029f2:	48 83 ec 18          	sub    $0x18,%rsp
  8029f6:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8029f8:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  8029fc:	48 b8 fa 24 80 00 00 	movabs $0x8024fa,%rax
  802a03:	00 00 00 
  802a06:	ff d0                	call   *%rax
  802a08:	85 c0                	test   %eax,%eax
  802a0a:	78 0c                	js     802a18 <seek+0x2f>

    fd->fd_offset = offset;
  802a0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a10:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  802a13:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a18:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  802a1c:	c9                   	leave
  802a1d:	c3                   	ret

0000000000802a1e <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  802a1e:	f3 0f 1e fa          	endbr64
  802a22:	55                   	push   %rbp
  802a23:	48 89 e5             	mov    %rsp,%rbp
  802a26:	41 55                	push   %r13
  802a28:	41 54                	push   %r12
  802a2a:	53                   	push   %rbx
  802a2b:	48 83 ec 18          	sub    $0x18,%rsp
  802a2f:	89 fb                	mov    %edi,%ebx
  802a31:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  802a34:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  802a38:	48 b8 fa 24 80 00 00 	movabs $0x8024fa,%rax
  802a3f:	00 00 00 
  802a42:	ff d0                	call   *%rax
  802a44:	85 c0                	test   %eax,%eax
  802a46:	78 38                	js     802a80 <ftruncate+0x62>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  802a48:	4c 8b 6d d8          	mov    -0x28(%rbp),%r13
  802a4c:	41 8b 7d 00          	mov    0x0(%r13),%edi
  802a50:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  802a54:	48 b8 49 25 80 00 00 	movabs $0x802549,%rax
  802a5b:	00 00 00 
  802a5e:	ff d0                	call   *%rax
  802a60:	85 c0                	test   %eax,%eax
  802a62:	78 1c                	js     802a80 <ftruncate+0x62>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802a64:	41 f6 45 08 03       	testb  $0x3,0x8(%r13)
  802a69:	74 20                	je     802a8b <ftruncate+0x6d>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  802a6b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a6f:	48 8b 40 30          	mov    0x30(%rax),%rax
  802a73:	48 85 c0             	test   %rax,%rax
  802a76:	74 47                	je     802abf <ftruncate+0xa1>

    return (*dev->dev_trunc)(fd, newsize);
  802a78:	44 89 e6             	mov    %r12d,%esi
  802a7b:	4c 89 ef             	mov    %r13,%rdi
  802a7e:	ff d0                	call   *%rax
}
  802a80:	48 83 c4 18          	add    $0x18,%rsp
  802a84:	5b                   	pop    %rbx
  802a85:	41 5c                	pop    %r12
  802a87:	41 5d                	pop    %r13
  802a89:	5d                   	pop    %rbp
  802a8a:	c3                   	ret
                thisenv->env_id, fdnum);
  802a8b:	48 a1 18 70 80 00 00 	movabs 0x807018,%rax
  802a92:	00 00 00 
  802a95:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  802a9b:	89 da                	mov    %ebx,%edx
  802a9d:	48 bf 08 55 80 00 00 	movabs $0x805508,%rdi
  802aa4:	00 00 00 
  802aa7:	b8 00 00 00 00       	mov    $0x0,%eax
  802aac:	48 b9 1a 0d 80 00 00 	movabs $0x800d1a,%rcx
  802ab3:	00 00 00 
  802ab6:	ff d1                	call   *%rcx
        return -E_INVAL;
  802ab8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802abd:	eb c1                	jmp    802a80 <ftruncate+0x62>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  802abf:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  802ac4:	eb ba                	jmp    802a80 <ftruncate+0x62>

0000000000802ac6 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  802ac6:	f3 0f 1e fa          	endbr64
  802aca:	55                   	push   %rbp
  802acb:	48 89 e5             	mov    %rsp,%rbp
  802ace:	41 54                	push   %r12
  802ad0:	53                   	push   %rbx
  802ad1:	48 83 ec 10          	sub    $0x10,%rsp
  802ad5:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  802ad8:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  802adc:	48 b8 fa 24 80 00 00 	movabs $0x8024fa,%rax
  802ae3:	00 00 00 
  802ae6:	ff d0                	call   *%rax
  802ae8:	85 c0                	test   %eax,%eax
  802aea:	78 4e                	js     802b3a <fstat+0x74>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  802aec:	4c 8b 65 e8          	mov    -0x18(%rbp),%r12
  802af0:	41 8b 3c 24          	mov    (%r12),%edi
  802af4:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  802af8:	48 b8 49 25 80 00 00 	movabs $0x802549,%rax
  802aff:	00 00 00 
  802b02:	ff d0                	call   *%rax
  802b04:	85 c0                	test   %eax,%eax
  802b06:	78 32                	js     802b3a <fstat+0x74>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  802b08:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b0c:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  802b11:	74 30                	je     802b43 <fstat+0x7d>

    stat->st_name[0] = 0;
  802b13:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  802b16:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  802b1d:	00 00 00 
    stat->st_isdir = 0;
  802b20:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  802b27:	00 00 00 
    stat->st_dev = dev;
  802b2a:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  802b31:	48 89 de             	mov    %rbx,%rsi
  802b34:	4c 89 e7             	mov    %r12,%rdi
  802b37:	ff 50 28             	call   *0x28(%rax)
}
  802b3a:	48 83 c4 10          	add    $0x10,%rsp
  802b3e:	5b                   	pop    %rbx
  802b3f:	41 5c                	pop    %r12
  802b41:	5d                   	pop    %rbp
  802b42:	c3                   	ret
    if (!dev->dev_stat) return -E_NOT_SUPP;
  802b43:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  802b48:	eb f0                	jmp    802b3a <fstat+0x74>

0000000000802b4a <stat>:

int
stat(const char *path, struct Stat *stat) {
  802b4a:	f3 0f 1e fa          	endbr64
  802b4e:	55                   	push   %rbp
  802b4f:	48 89 e5             	mov    %rsp,%rbp
  802b52:	41 54                	push   %r12
  802b54:	53                   	push   %rbx
  802b55:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  802b58:	be 00 00 00 00       	mov    $0x0,%esi
  802b5d:	48 b8 2b 2e 80 00 00 	movabs $0x802e2b,%rax
  802b64:	00 00 00 
  802b67:	ff d0                	call   *%rax
  802b69:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  802b6b:	85 c0                	test   %eax,%eax
  802b6d:	78 25                	js     802b94 <stat+0x4a>

    int res = fstat(fd, stat);
  802b6f:	4c 89 e6             	mov    %r12,%rsi
  802b72:	89 c7                	mov    %eax,%edi
  802b74:	48 b8 c6 2a 80 00 00 	movabs $0x802ac6,%rax
  802b7b:	00 00 00 
  802b7e:	ff d0                	call   *%rax
  802b80:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  802b83:	89 df                	mov    %ebx,%edi
  802b85:	48 b8 6b 26 80 00 00 	movabs $0x80266b,%rax
  802b8c:	00 00 00 
  802b8f:	ff d0                	call   *%rax

    return res;
  802b91:	44 89 e3             	mov    %r12d,%ebx
}
  802b94:	89 d8                	mov    %ebx,%eax
  802b96:	5b                   	pop    %rbx
  802b97:	41 5c                	pop    %r12
  802b99:	5d                   	pop    %rbp
  802b9a:	c3                   	ret

0000000000802b9b <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  802b9b:	f3 0f 1e fa          	endbr64
  802b9f:	55                   	push   %rbp
  802ba0:	48 89 e5             	mov    %rsp,%rbp
  802ba3:	41 54                	push   %r12
  802ba5:	53                   	push   %rbx
  802ba6:	48 83 ec 10          	sub    $0x10,%rsp
  802baa:	41 89 fc             	mov    %edi,%r12d
  802bad:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  802bb0:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802bb7:	00 00 00 
  802bba:	83 38 00             	cmpl   $0x0,(%rax)
  802bbd:	74 6e                	je     802c2d <fsipc+0x92>

    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }
    fsenv = ipc_find_env(ENV_TYPE_FS);
  802bbf:	bf 03 00 00 00       	mov    $0x3,%edi
  802bc4:	48 b8 64 44 80 00 00 	movabs $0x804464,%rax
  802bcb:	00 00 00 
  802bce:	ff d0                	call   *%rax
  802bd0:	a3 00 90 80 00 00 00 	movabs %eax,0x809000
  802bd7:	00 00 
    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  802bd9:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  802bdf:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802be4:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802beb:	00 00 00 
  802bee:	44 89 e6             	mov    %r12d,%esi
  802bf1:	89 c7                	mov    %eax,%edi
  802bf3:	48 b8 a2 43 80 00 00 	movabs $0x8043a2,%rax
  802bfa:	00 00 00 
  802bfd:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  802bff:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  802c06:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  802c07:	b9 00 00 00 00       	mov    $0x0,%ecx
  802c0c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c10:	48 89 de             	mov    %rbx,%rsi
  802c13:	bf 00 00 00 00       	mov    $0x0,%edi
  802c18:	48 b8 09 43 80 00 00 	movabs $0x804309,%rax
  802c1f:	00 00 00 
  802c22:	ff d0                	call   *%rax
}
  802c24:	48 83 c4 10          	add    $0x10,%rsp
  802c28:	5b                   	pop    %rbx
  802c29:	41 5c                	pop    %r12
  802c2b:	5d                   	pop    %rbp
  802c2c:	c3                   	ret
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  802c2d:	bf 03 00 00 00       	mov    $0x3,%edi
  802c32:	48 b8 64 44 80 00 00 	movabs $0x804464,%rax
  802c39:	00 00 00 
  802c3c:	ff d0                	call   *%rax
  802c3e:	a3 00 90 80 00 00 00 	movabs %eax,0x809000
  802c45:	00 00 
  802c47:	e9 73 ff ff ff       	jmp    802bbf <fsipc+0x24>

0000000000802c4c <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  802c4c:	f3 0f 1e fa          	endbr64
  802c50:	55                   	push   %rbp
  802c51:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802c54:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c5b:	00 00 00 
  802c5e:	8b 57 0c             	mov    0xc(%rdi),%edx
  802c61:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  802c63:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  802c66:	be 00 00 00 00       	mov    $0x0,%esi
  802c6b:	bf 02 00 00 00       	mov    $0x2,%edi
  802c70:	48 b8 9b 2b 80 00 00 	movabs $0x802b9b,%rax
  802c77:	00 00 00 
  802c7a:	ff d0                	call   *%rax
}
  802c7c:	5d                   	pop    %rbp
  802c7d:	c3                   	ret

0000000000802c7e <devfile_flush>:
devfile_flush(struct Fd *fd) {
  802c7e:	f3 0f 1e fa          	endbr64
  802c82:	55                   	push   %rbp
  802c83:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802c86:	8b 47 0c             	mov    0xc(%rdi),%eax
  802c89:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  802c90:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  802c92:	be 00 00 00 00       	mov    $0x0,%esi
  802c97:	bf 06 00 00 00       	mov    $0x6,%edi
  802c9c:	48 b8 9b 2b 80 00 00 	movabs $0x802b9b,%rax
  802ca3:	00 00 00 
  802ca6:	ff d0                	call   *%rax
}
  802ca8:	5d                   	pop    %rbp
  802ca9:	c3                   	ret

0000000000802caa <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  802caa:	f3 0f 1e fa          	endbr64
  802cae:	55                   	push   %rbp
  802caf:	48 89 e5             	mov    %rsp,%rbp
  802cb2:	41 54                	push   %r12
  802cb4:	53                   	push   %rbx
  802cb5:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802cb8:	8b 47 0c             	mov    0xc(%rdi),%eax
  802cbb:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  802cc2:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  802cc4:	be 00 00 00 00       	mov    $0x0,%esi
  802cc9:	bf 05 00 00 00       	mov    $0x5,%edi
  802cce:	48 b8 9b 2b 80 00 00 	movabs $0x802b9b,%rax
  802cd5:	00 00 00 
  802cd8:	ff d0                	call   *%rax
    if (res < 0) return res;
  802cda:	85 c0                	test   %eax,%eax
  802cdc:	78 3d                	js     802d1b <devfile_stat+0x71>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802cde:	49 bc 00 80 80 00 00 	movabs $0x808000,%r12
  802ce5:	00 00 00 
  802ce8:	4c 89 e6             	mov    %r12,%rsi
  802ceb:	48 89 df             	mov    %rbx,%rdi
  802cee:	48 b8 63 16 80 00 00 	movabs $0x801663,%rax
  802cf5:	00 00 00 
  802cf8:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  802cfa:	41 8b 84 24 80 00 00 	mov    0x80(%r12),%eax
  802d01:	00 
  802d02:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802d08:	41 8b 84 24 84 00 00 	mov    0x84(%r12),%eax
  802d0f:	00 
  802d10:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  802d16:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d1b:	5b                   	pop    %rbx
  802d1c:	41 5c                	pop    %r12
  802d1e:	5d                   	pop    %rbp
  802d1f:	c3                   	ret

0000000000802d20 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  802d20:	f3 0f 1e fa          	endbr64
    if (n >= sizeof(fsipcbuf.write.req_buf)) {
  802d24:	48 81 fa ef 0f 00 00 	cmp    $0xfef,%rdx
  802d2b:	77 41                	ja     802d6e <devfile_write+0x4e>
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  802d2d:	55                   	push   %rbp
  802d2e:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  802d31:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d38:	00 00 00 
  802d3b:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  802d3e:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.write.req_n = n;
  802d40:	48 89 50 08          	mov    %rdx,0x8(%rax)
    memmove(fsipcbuf.write.req_buf, buf, n);
  802d44:	48 8d 78 10          	lea    0x10(%rax),%rdi
  802d48:	48 b8 7e 18 80 00 00 	movabs $0x80187e,%rax
  802d4f:	00 00 00 
  802d52:	ff d0                	call   *%rax
    res = fsipc(FSREQ_WRITE, NULL);
  802d54:	be 00 00 00 00       	mov    $0x0,%esi
  802d59:	bf 04 00 00 00       	mov    $0x4,%edi
  802d5e:	48 b8 9b 2b 80 00 00 	movabs $0x802b9b,%rax
  802d65:	00 00 00 
  802d68:	ff d0                	call   *%rax
  802d6a:	48 98                	cltq
}
  802d6c:	5d                   	pop    %rbp
  802d6d:	c3                   	ret
        return -E_INVAL;
  802d6e:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
}
  802d75:	c3                   	ret

0000000000802d76 <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  802d76:	f3 0f 1e fa          	endbr64
  802d7a:	55                   	push   %rbp
  802d7b:	48 89 e5             	mov    %rsp,%rbp
  802d7e:	41 55                	push   %r13
  802d80:	41 54                	push   %r12
  802d82:	53                   	push   %rbx
  802d83:	48 83 ec 08          	sub    $0x8,%rsp
  802d87:	49 89 f4             	mov    %rsi,%r12
  802d8a:	48 89 d3             	mov    %rdx,%rbx
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  802d8d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d94:	00 00 00 
  802d97:	8b 57 0c             	mov    0xc(%rdi),%edx
  802d9a:	89 10                	mov    %edx,(%rax)
    fsipcbuf.read.req_n = n;
  802d9c:	48 89 58 08          	mov    %rbx,0x8(%rax)
    res = fsipc(FSREQ_READ, NULL);
  802da0:	be 00 00 00 00       	mov    $0x0,%esi
  802da5:	bf 03 00 00 00       	mov    $0x3,%edi
  802daa:	48 b8 9b 2b 80 00 00 	movabs $0x802b9b,%rax
  802db1:	00 00 00 
  802db4:	ff d0                	call   *%rax
  802db6:	4c 63 e8             	movslq %eax,%r13
    if (res < 0) {
  802db9:	4d 85 ed             	test   %r13,%r13
  802dbc:	78 2a                	js     802de8 <devfile_read+0x72>
    assert(res <= n && res <= PAGE_SIZE);
  802dbe:	4c 89 ea             	mov    %r13,%rdx
  802dc1:	4c 39 eb             	cmp    %r13,%rbx
  802dc4:	72 30                	jb     802df6 <devfile_read+0x80>
  802dc6:	49 81 fd 00 10 00 00 	cmp    $0x1000,%r13
  802dcd:	7f 27                	jg     802df6 <devfile_read+0x80>
    memmove(buf, &fsipcbuf, res);
  802dcf:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802dd6:	00 00 00 
  802dd9:	4c 89 e7             	mov    %r12,%rdi
  802ddc:	48 b8 7e 18 80 00 00 	movabs $0x80187e,%rax
  802de3:	00 00 00 
  802de6:	ff d0                	call   *%rax
}
  802de8:	4c 89 e8             	mov    %r13,%rax
  802deb:	48 83 c4 08          	add    $0x8,%rsp
  802def:	5b                   	pop    %rbx
  802df0:	41 5c                	pop    %r12
  802df2:	41 5d                	pop    %r13
  802df4:	5d                   	pop    %rbp
  802df5:	c3                   	ret
    assert(res <= n && res <= PAGE_SIZE);
  802df6:	48 b9 e9 52 80 00 00 	movabs $0x8052e9,%rcx
  802dfd:	00 00 00 
  802e00:	48 ba a9 50 80 00 00 	movabs $0x8050a9,%rdx
  802e07:	00 00 00 
  802e0a:	be 7b 00 00 00       	mov    $0x7b,%esi
  802e0f:	48 bf 06 53 80 00 00 	movabs $0x805306,%rdi
  802e16:	00 00 00 
  802e19:	b8 00 00 00 00       	mov    $0x0,%eax
  802e1e:	49 b8 be 0b 80 00 00 	movabs $0x800bbe,%r8
  802e25:	00 00 00 
  802e28:	41 ff d0             	call   *%r8

0000000000802e2b <open>:
open(const char *path, int mode) {
  802e2b:	f3 0f 1e fa          	endbr64
  802e2f:	55                   	push   %rbp
  802e30:	48 89 e5             	mov    %rsp,%rbp
  802e33:	41 55                	push   %r13
  802e35:	41 54                	push   %r12
  802e37:	53                   	push   %rbx
  802e38:	48 83 ec 18          	sub    $0x18,%rsp
  802e3c:	49 89 fc             	mov    %rdi,%r12
  802e3f:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  802e42:	48 b8 1e 16 80 00 00 	movabs $0x80161e,%rax
  802e49:	00 00 00 
  802e4c:	ff d0                	call   *%rax
  802e4e:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  802e54:	0f 87 8a 00 00 00    	ja     802ee4 <open+0xb9>
    if ((res = fd_alloc(&fd)) < 0) return res;
  802e5a:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802e5e:	48 b8 96 24 80 00 00 	movabs $0x802496,%rax
  802e65:	00 00 00 
  802e68:	ff d0                	call   *%rax
  802e6a:	89 c3                	mov    %eax,%ebx
  802e6c:	85 c0                	test   %eax,%eax
  802e6e:	78 50                	js     802ec0 <open+0x95>
    strcpy(fsipcbuf.open.req_path, path);
  802e70:	4c 89 e6             	mov    %r12,%rsi
  802e73:	48 bb 00 80 80 00 00 	movabs $0x808000,%rbx
  802e7a:	00 00 00 
  802e7d:	48 89 df             	mov    %rbx,%rdi
  802e80:	48 b8 63 16 80 00 00 	movabs $0x801663,%rax
  802e87:	00 00 00 
  802e8a:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  802e8c:	44 89 ab 00 04 00 00 	mov    %r13d,0x400(%rbx)
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  802e93:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802e97:	bf 01 00 00 00       	mov    $0x1,%edi
  802e9c:	48 b8 9b 2b 80 00 00 	movabs $0x802b9b,%rax
  802ea3:	00 00 00 
  802ea6:	ff d0                	call   *%rax
  802ea8:	89 c3                	mov    %eax,%ebx
  802eaa:	85 c0                	test   %eax,%eax
  802eac:	78 1f                	js     802ecd <open+0xa2>
    return fd2num(fd);
  802eae:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802eb2:	48 b8 60 24 80 00 00 	movabs $0x802460,%rax
  802eb9:	00 00 00 
  802ebc:	ff d0                	call   *%rax
  802ebe:	89 c3                	mov    %eax,%ebx
}
  802ec0:	89 d8                	mov    %ebx,%eax
  802ec2:	48 83 c4 18          	add    $0x18,%rsp
  802ec6:	5b                   	pop    %rbx
  802ec7:	41 5c                	pop    %r12
  802ec9:	41 5d                	pop    %r13
  802ecb:	5d                   	pop    %rbp
  802ecc:	c3                   	ret
        fd_close(fd, 0);
  802ecd:	be 00 00 00 00       	mov    $0x0,%esi
  802ed2:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802ed6:	48 b8 bd 25 80 00 00 	movabs $0x8025bd,%rax
  802edd:	00 00 00 
  802ee0:	ff d0                	call   *%rax
        return res;
  802ee2:	eb dc                	jmp    802ec0 <open+0x95>
        return -E_BAD_PATH;
  802ee4:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  802ee9:	eb d5                	jmp    802ec0 <open+0x95>

0000000000802eeb <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  802eeb:	f3 0f 1e fa          	endbr64
  802eef:	55                   	push   %rbp
  802ef0:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  802ef3:	be 00 00 00 00       	mov    $0x0,%esi
  802ef8:	bf 08 00 00 00       	mov    $0x8,%edi
  802efd:	48 b8 9b 2b 80 00 00 	movabs $0x802b9b,%rax
  802f04:	00 00 00 
  802f07:	ff d0                	call   *%rax
}
  802f09:	5d                   	pop    %rbp
  802f0a:	c3                   	ret

0000000000802f0b <writebuf>:
    int error;      /* First error that occurred */
    char buf[PRINTBUFSZ];
};

static void
writebuf(struct printbuf *state) {
  802f0b:	f3 0f 1e fa          	endbr64
    if (state->error > 0) {
  802f0f:	83 7f 10 00          	cmpl   $0x0,0x10(%rdi)
  802f13:	7f 01                	jg     802f16 <writebuf+0xb>
  802f15:	c3                   	ret
writebuf(struct printbuf *state) {
  802f16:	55                   	push   %rbp
  802f17:	48 89 e5             	mov    %rsp,%rbp
  802f1a:	53                   	push   %rbx
  802f1b:	48 83 ec 08          	sub    $0x8,%rsp
  802f1f:	48 89 fb             	mov    %rdi,%rbx
        ssize_t result = write(state->fd, state->buf, state->offset);
  802f22:	48 63 57 04          	movslq 0x4(%rdi),%rdx
  802f26:	48 8d 77 14          	lea    0x14(%rdi),%rsi
  802f2a:	8b 3f                	mov    (%rdi),%edi
  802f2c:	48 b8 2c 29 80 00 00 	movabs $0x80292c,%rax
  802f33:	00 00 00 
  802f36:	ff d0                	call   *%rax
        if (result > 0) state->result += result;
  802f38:	48 85 c0             	test   %rax,%rax
  802f3b:	7e 04                	jle    802f41 <writebuf+0x36>
  802f3d:	48 01 43 08          	add    %rax,0x8(%rbx)

        /* Error, or wrote less than supplied */
        if (result != state->offset)
  802f41:	48 63 53 04          	movslq 0x4(%rbx),%rdx
  802f45:	48 39 c2             	cmp    %rax,%rdx
  802f48:	74 0f                	je     802f59 <writebuf+0x4e>
            state->error = MIN(0, result);
  802f4a:	48 85 c0             	test   %rax,%rax
  802f4d:	ba 00 00 00 00       	mov    $0x0,%edx
  802f52:	48 0f 4f c2          	cmovg  %rdx,%rax
  802f56:	89 43 10             	mov    %eax,0x10(%rbx)
    }
}
  802f59:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  802f5d:	c9                   	leave
  802f5e:	c3                   	ret

0000000000802f5f <putch>:

static void
putch(int ch, void *arg) {
  802f5f:	f3 0f 1e fa          	endbr64
    struct printbuf *state = (struct printbuf *)arg;
    state->buf[state->offset++] = ch;
  802f63:	8b 46 04             	mov    0x4(%rsi),%eax
  802f66:	8d 50 01             	lea    0x1(%rax),%edx
  802f69:	89 56 04             	mov    %edx,0x4(%rsi)
  802f6c:	48 98                	cltq
  802f6e:	40 88 7c 06 14       	mov    %dil,0x14(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ) {
  802f73:	81 fa 00 01 00 00    	cmp    $0x100,%edx
  802f79:	74 01                	je     802f7c <putch+0x1d>
  802f7b:	c3                   	ret
putch(int ch, void *arg) {
  802f7c:	55                   	push   %rbp
  802f7d:	48 89 e5             	mov    %rsp,%rbp
  802f80:	53                   	push   %rbx
  802f81:	48 83 ec 08          	sub    $0x8,%rsp
  802f85:	48 89 f3             	mov    %rsi,%rbx
        writebuf(state);
  802f88:	48 89 f7             	mov    %rsi,%rdi
  802f8b:	48 b8 0b 2f 80 00 00 	movabs $0x802f0b,%rax
  802f92:	00 00 00 
  802f95:	ff d0                	call   *%rax
        state->offset = 0;
  802f97:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%rbx)
    }
}
  802f9e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  802fa2:	c9                   	leave
  802fa3:	c3                   	ret

0000000000802fa4 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap) {
  802fa4:	f3 0f 1e fa          	endbr64
  802fa8:	55                   	push   %rbp
  802fa9:	48 89 e5             	mov    %rsp,%rbp
  802fac:	48 81 ec 20 01 00 00 	sub    $0x120,%rsp
  802fb3:	48 89 d1             	mov    %rdx,%rcx
    struct printbuf state;
    state.fd = fd;
  802fb6:	89 bd e8 fe ff ff    	mov    %edi,-0x118(%rbp)
    state.offset = 0;
  802fbc:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%rbp)
  802fc3:	00 00 00 
    state.result = 0;
  802fc6:	48 c7 85 f0 fe ff ff 	movq   $0x0,-0x110(%rbp)
  802fcd:	00 00 00 00 
    state.error = 1;
  802fd1:	c7 85 f8 fe ff ff 01 	movl   $0x1,-0x108(%rbp)
  802fd8:	00 00 00 

    vprintfmt(putch, &state, fmt, ap);
  802fdb:	48 89 f2             	mov    %rsi,%rdx
  802fde:	48 8d b5 e8 fe ff ff 	lea    -0x118(%rbp),%rsi
  802fe5:	48 bf 5f 2f 80 00 00 	movabs $0x802f5f,%rdi
  802fec:	00 00 00 
  802fef:	48 b8 7a 0e 80 00 00 	movabs $0x800e7a,%rax
  802ff6:	00 00 00 
  802ff9:	ff d0                	call   *%rax
    if (state.offset > 0) writebuf(&state);
  802ffb:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%rbp)
  803002:	7f 14                	jg     803018 <vfprintf+0x74>

    return (state.result ? state.result : state.error);
  803004:	48 8b 85 f0 fe ff ff 	mov    -0x110(%rbp),%rax
  80300b:	48 85 c0             	test   %rax,%rax
  80300e:	75 06                	jne    803016 <vfprintf+0x72>
  803010:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
}
  803016:	c9                   	leave
  803017:	c3                   	ret
    if (state.offset > 0) writebuf(&state);
  803018:	48 8d bd e8 fe ff ff 	lea    -0x118(%rbp),%rdi
  80301f:	48 b8 0b 2f 80 00 00 	movabs $0x802f0b,%rax
  803026:	00 00 00 
  803029:	ff d0                	call   *%rax
  80302b:	eb d7                	jmp    803004 <vfprintf+0x60>

000000000080302d <fprintf>:

int
fprintf(int fd, const char *fmt, ...) {
  80302d:	f3 0f 1e fa          	endbr64
  803031:	55                   	push   %rbp
  803032:	48 89 e5             	mov    %rsp,%rbp
  803035:	48 83 ec 50          	sub    $0x50,%rsp
  803039:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80303d:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  803041:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  803045:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    va_start(ap, fmt);
  803049:	c7 45 b8 10 00 00 00 	movl   $0x10,-0x48(%rbp)
  803050:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803054:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  803058:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80305c:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int res = vfprintf(fd, fmt, ap);
  803060:	48 8d 55 b8          	lea    -0x48(%rbp),%rdx
  803064:	48 b8 a4 2f 80 00 00 	movabs $0x802fa4,%rax
  80306b:	00 00 00 
  80306e:	ff d0                	call   *%rax
    va_end(ap);

    return res;
}
  803070:	c9                   	leave
  803071:	c3                   	ret

0000000000803072 <printf>:

int
printf(const char *fmt, ...) {
  803072:	f3 0f 1e fa          	endbr64
  803076:	55                   	push   %rbp
  803077:	48 89 e5             	mov    %rsp,%rbp
  80307a:	48 83 ec 50          	sub    $0x50,%rsp
  80307e:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  803082:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803086:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80308a:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  80308e:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    va_start(ap, fmt);
  803092:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  803099:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80309d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8030a1:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8030a5:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int res = vfprintf(1, fmt, ap);
  8030a9:	48 8d 55 b8          	lea    -0x48(%rbp),%rdx
  8030ad:	48 89 fe             	mov    %rdi,%rsi
  8030b0:	bf 01 00 00 00       	mov    $0x1,%edi
  8030b5:	48 b8 a4 2f 80 00 00 	movabs $0x802fa4,%rax
  8030bc:	00 00 00 
  8030bf:	ff d0                	call   *%rax
    va_end(ap);

    return res;
}
  8030c1:	c9                   	leave
  8030c2:	c3                   	ret

00000000008030c3 <copy_shared_region>:
    if (sys_unmap_region(0, UTEMP, USER_STACK_SIZE) < 0) goto error;
    return res;
}

static int
copy_shared_region(void *start, void *end, void *arg) {
  8030c3:	f3 0f 1e fa          	endbr64
  8030c7:	55                   	push   %rbp
  8030c8:	48 89 e5             	mov    %rsp,%rbp
  8030cb:	41 55                	push   %r13
  8030cd:	41 54                	push   %r12
  8030cf:	53                   	push   %rbx
  8030d0:	48 83 ec 08          	sub    $0x8,%rsp
  8030d4:	48 89 fb             	mov    %rdi,%rbx
  8030d7:	49 89 f4             	mov    %rsi,%r12
    envid_t child = *(envid_t *)arg;
  8030da:	44 8b 2a             	mov    (%rdx),%r13d
    return sys_map_region(0, start, child, start, end - start, get_prot(start));
  8030dd:	48 b8 fc 40 80 00 00 	movabs $0x8040fc,%rax
  8030e4:	00 00 00 
  8030e7:	ff d0                	call   *%rax
  8030e9:	41 89 c1             	mov    %eax,%r9d
  8030ec:	4d 89 e0             	mov    %r12,%r8
  8030ef:	49 29 d8             	sub    %rbx,%r8
  8030f2:	48 89 d9             	mov    %rbx,%rcx
  8030f5:	44 89 ea             	mov    %r13d,%edx
  8030f8:	48 89 de             	mov    %rbx,%rsi
  8030fb:	bf 00 00 00 00       	mov    $0x0,%edi
  803100:	48 b8 21 1e 80 00 00 	movabs $0x801e21,%rax
  803107:	00 00 00 
  80310a:	ff d0                	call   *%rax
}
  80310c:	48 83 c4 08          	add    $0x8,%rsp
  803110:	5b                   	pop    %rbx
  803111:	41 5c                	pop    %r12
  803113:	41 5d                	pop    %r13
  803115:	5d                   	pop    %rbp
  803116:	c3                   	ret

0000000000803117 <spawn>:
spawn(const char *prog, const char **argv) {
  803117:	f3 0f 1e fa          	endbr64
  80311b:	55                   	push   %rbp
  80311c:	48 89 e5             	mov    %rsp,%rbp
  80311f:	41 57                	push   %r15
  803121:	41 56                	push   %r14
  803123:	41 55                	push   %r13
  803125:	41 54                	push   %r12
  803127:	53                   	push   %rbx
  803128:	48 81 ec f8 02 00 00 	sub    $0x2f8,%rsp
  80312f:	49 89 f4             	mov    %rsi,%r12
    int fd = open(prog, O_RDONLY);
  803132:	be 00 00 00 00       	mov    $0x0,%esi
  803137:	48 b8 2b 2e 80 00 00 	movabs $0x802e2b,%rax
  80313e:	00 00 00 
  803141:	ff d0                	call   *%rax
  803143:	89 85 fc fc ff ff    	mov    %eax,-0x304(%rbp)
    if (fd < 0) return fd;
  803149:	85 c0                	test   %eax,%eax
  80314b:	0f 88 30 06 00 00    	js     803781 <spawn+0x66a>
  803151:	89 c7                	mov    %eax,%edi
    res = readn(fd, elf_buf, sizeof(elf_buf));
  803153:	ba 00 02 00 00       	mov    $0x200,%edx
  803158:	48 8d b5 d0 fd ff ff 	lea    -0x230(%rbp),%rsi
  80315f:	48 b8 b7 28 80 00 00 	movabs $0x8028b7,%rax
  803166:	00 00 00 
  803169:	ff d0                	call   *%rax
  80316b:	89 c6                	mov    %eax,%esi
    if (res != sizeof(elf_buf)) {
  80316d:	3d 00 02 00 00       	cmp    $0x200,%eax
  803172:	0f 85 7d 02 00 00    	jne    8033f5 <spawn+0x2de>
        elf->e_elf[1] != 1 /* little endian */ ||
  803178:	48 b8 ff ff ff ff ff 	movabs $0xffffffffffffff,%rax
  80317f:	ff ff 00 
  803182:	48 23 85 d0 fd ff ff 	and    -0x230(%rbp),%rax
    if (elf->e_magic != ELF_MAGIC ||
  803189:	48 ba 7f 45 4c 46 02 	movabs $0x10102464c457f,%rdx
  803190:	01 01 00 
  803193:	48 39 d0             	cmp    %rdx,%rax
  803196:	0f 85 95 02 00 00    	jne    803431 <spawn+0x31a>
        elf->e_type != ET_EXEC /* executable */ ||
  80319c:	81 bd e0 fd ff ff 02 	cmpl   $0x3e0002,-0x220(%rbp)
  8031a3:	00 3e 00 
  8031a6:	0f 85 85 02 00 00    	jne    803431 <spawn+0x31a>
  8031ac:	b8 09 00 00 00       	mov    $0x9,%eax
  8031b1:	cd 30                	int    $0x30
  8031b3:	41 89 c6             	mov    %eax,%r14d
  8031b6:	89 c3                	mov    %eax,%ebx
    if ((int)(res = sys_exofork()) < 0) goto error2;
  8031b8:	85 c0                	test   %eax,%eax
  8031ba:	0f 88 a9 05 00 00    	js     803769 <spawn+0x652>
    envid_t child = res;
  8031c0:	89 85 cc fd ff ff    	mov    %eax,-0x234(%rbp)
    struct Trapframe child_tf = envs[ENVX(child)].env_tf;
  8031c6:	25 ff 03 00 00       	and    $0x3ff,%eax
  8031cb:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8031cf:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8031d3:	48 c1 e0 04          	shl    $0x4,%rax
  8031d7:	48 be 00 00 a0 1f 80 	movabs $0x801fa00000,%rsi
  8031de:	00 00 00 
  8031e1:	48 01 c6             	add    %rax,%rsi
  8031e4:	48 8b 06             	mov    (%rsi),%rax
  8031e7:	48 89 85 0c fd ff ff 	mov    %rax,-0x2f4(%rbp)
  8031ee:	48 8b 86 b8 00 00 00 	mov    0xb8(%rsi),%rax
  8031f5:	48 89 85 c4 fd ff ff 	mov    %rax,-0x23c(%rbp)
  8031fc:	48 8d bd 10 fd ff ff 	lea    -0x2f0(%rbp),%rdi
  803203:	48 c7 c1 fc ff ff ff 	mov    $0xfffffffffffffffc,%rcx
  80320a:	48 29 ce             	sub    %rcx,%rsi
  80320d:	81 c1 c0 00 00 00    	add    $0xc0,%ecx
  803213:	c1 e9 03             	shr    $0x3,%ecx
  803216:	89 c9                	mov    %ecx,%ecx
  803218:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
    child_tf.tf_rip = elf->e_entry;
  80321b:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  803222:	48 89 85 a4 fd ff ff 	mov    %rax,-0x25c(%rbp)
    for (argc = 0; argv[argc] != 0; argc++)
  803229:	49 8b 3c 24          	mov    (%r12),%rdi
  80322d:	48 85 ff             	test   %rdi,%rdi
  803230:	0f 84 7f 05 00 00    	je     8037b5 <spawn+0x69e>
  803236:	41 bd 01 00 00 00    	mov    $0x1,%r13d
    string_size = 0;
  80323c:	41 bf 00 00 00 00    	mov    $0x0,%r15d
        string_size += strlen(argv[argc]) + 1;
  803242:	48 bb 1e 16 80 00 00 	movabs $0x80161e,%rbx
  803249:	00 00 00 
  80324c:	ff d3                	call   *%rbx
  80324e:	4c 01 f8             	add    %r15,%rax
  803251:	4c 8d 78 01          	lea    0x1(%rax),%r15
    for (argc = 0; argv[argc] != 0; argc++)
  803255:	4c 89 ea             	mov    %r13,%rdx
  803258:	49 83 c5 01          	add    $0x1,%r13
  80325c:	4b 8b 7c ec f8       	mov    -0x8(%r12,%r13,8),%rdi
  803261:	48 85 ff             	test   %rdi,%rdi
  803264:	75 e6                	jne    80324c <spawn+0x135>
    string_store = (char *)UTEMP + USER_STACK_SIZE - string_size;
  803266:	49 89 d5             	mov    %rdx,%r13
  803269:	48 89 95 e8 fc ff ff 	mov    %rdx,-0x318(%rbp)
  803270:	48 f7 d0             	not    %rax
  803273:	48 8d 98 00 00 41 00 	lea    0x410000(%rax),%rbx
    argv_store = (uintptr_t *)(ROUNDDOWN(string_store, sizeof(uintptr_t)) - sizeof(uintptr_t) * (argc + 1));
  80327a:	49 89 df             	mov    %rbx,%r15
  80327d:	49 83 e7 f8          	and    $0xfffffffffffffff8,%r15
  803281:	4c 89 bd e0 fc ff ff 	mov    %r15,-0x320(%rbp)
  803288:	89 d0                	mov    %edx,%eax
  80328a:	83 c0 01             	add    $0x1,%eax
  80328d:	48 98                	cltq
  80328f:	48 c1 e0 03          	shl    $0x3,%rax
  803293:	49 29 c7             	sub    %rax,%r15
  803296:	4c 89 bd f0 fc ff ff 	mov    %r15,-0x310(%rbp)
    if ((void *)(argv_store - 2) < (void *)UTEMP) return -E_NO_MEM;
  80329d:	49 8d 47 f0          	lea    -0x10(%r15),%rax
  8032a1:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  8032a7:	0f 86 ff 04 00 00    	jbe    8037ac <spawn+0x695>
    if ((res = sys_alloc_region(0, UTEMP, USER_STACK_SIZE, PROT_RW)) < 0) return res;
  8032ad:	b9 06 00 00 00       	mov    $0x6,%ecx
  8032b2:	ba 00 00 01 00       	mov    $0x10000,%edx
  8032b7:	be 00 00 40 00       	mov    $0x400000,%esi
  8032bc:	48 b8 b6 1d 80 00 00 	movabs $0x801db6,%rax
  8032c3:	00 00 00 
  8032c6:	ff d0                	call   *%rax
  8032c8:	85 c0                	test   %eax,%eax
  8032ca:	0f 88 e1 04 00 00    	js     8037b1 <spawn+0x69a>
    for (i = 0; i < argc; i++) {
  8032d0:	4c 89 e8             	mov    %r13,%rax
  8032d3:	45 85 ed             	test   %r13d,%r13d
  8032d6:	7e 54                	jle    80332c <spawn+0x215>
  8032d8:	4d 89 fd             	mov    %r15,%r13
  8032db:	48 98                	cltq
  8032dd:	4d 8d 3c c7          	lea    (%r15,%rax,8),%r15
        argv_store[i] = UTEMP2USTACK(string_store);
  8032e1:	48 b8 00 70 fe ff 7f 	movabs $0x7ffffe7000,%rax
  8032e8:	00 00 00 
  8032eb:	48 8d 84 03 00 00 c0 	lea    -0x400000(%rbx,%rax,1),%rax
  8032f2:	ff 
  8032f3:	49 89 45 00          	mov    %rax,0x0(%r13)
        strcpy(string_store, argv[i]);
  8032f7:	49 8b 34 24          	mov    (%r12),%rsi
  8032fb:	48 89 df             	mov    %rbx,%rdi
  8032fe:	48 b8 63 16 80 00 00 	movabs $0x801663,%rax
  803305:	00 00 00 
  803308:	ff d0                	call   *%rax
        string_store += strlen(argv[i]) + 1;
  80330a:	49 8b 3c 24          	mov    (%r12),%rdi
  80330e:	48 b8 1e 16 80 00 00 	movabs $0x80161e,%rax
  803315:	00 00 00 
  803318:	ff d0                	call   *%rax
  80331a:	48 8d 5c 03 01       	lea    0x1(%rbx,%rax,1),%rbx
    for (i = 0; i < argc; i++) {
  80331f:	49 83 c5 08          	add    $0x8,%r13
  803323:	49 83 c4 08          	add    $0x8,%r12
  803327:	4d 39 fd             	cmp    %r15,%r13
  80332a:	75 b5                	jne    8032e1 <spawn+0x1ca>
    argv_store[argc] = 0;
  80332c:	48 8b 85 e0 fc ff ff 	mov    -0x320(%rbp),%rax
  803333:	48 c7 40 f8 00 00 00 	movq   $0x0,-0x8(%rax)
  80333a:	00 
    assert(string_store == (char *)UTEMP + USER_STACK_SIZE);
  80333b:	48 81 fb 00 00 41 00 	cmp    $0x410000,%rbx
  803342:	0f 85 30 01 00 00    	jne    803478 <spawn+0x361>
    argv_store[-1] = UTEMP2USTACK(argv_store);
  803348:	48 b9 00 70 fe ff 7f 	movabs $0x7ffffe7000,%rcx
  80334f:	00 00 00 
  803352:	48 8b b5 f0 fc ff ff 	mov    -0x310(%rbp),%rsi
  803359:	48 8d 84 0e 00 00 c0 	lea    -0x400000(%rsi,%rcx,1),%rax
  803360:	ff 
  803361:	48 89 46 f8          	mov    %rax,-0x8(%rsi)
    argv_store[-2] = argc;
  803365:	48 8b 85 e8 fc ff ff 	mov    -0x318(%rbp),%rax
  80336c:	48 89 46 f0          	mov    %rax,-0x10(%rsi)
    tf->tf_rsp = UTEMP2USTACK(&argv_store[-2]);
  803370:	48 b8 f0 6f fe ff 7f 	movabs $0x7ffffe6ff0,%rax
  803377:	00 00 00 
  80337a:	48 8d 84 06 00 00 c0 	lea    -0x400000(%rsi,%rax,1),%rax
  803381:	ff 
  803382:	48 89 85 bc fd ff ff 	mov    %rax,-0x244(%rbp)
    if (sys_map_region(0, UTEMP, child, (void *)(USER_STACK_TOP - USER_STACK_SIZE),
  803389:	41 b9 06 00 00 00    	mov    $0x6,%r9d
  80338f:	41 b8 00 00 01 00    	mov    $0x10000,%r8d
  803395:	44 89 f2             	mov    %r14d,%edx
  803398:	be 00 00 40 00       	mov    $0x400000,%esi
  80339d:	bf 00 00 00 00       	mov    $0x0,%edi
  8033a2:	48 b8 21 1e 80 00 00 	movabs $0x801e21,%rax
  8033a9:	00 00 00 
  8033ac:	ff d0                	call   *%rax
    if (sys_unmap_region(0, UTEMP, USER_STACK_SIZE) < 0) goto error;
  8033ae:	48 bb f6 1e 80 00 00 	movabs $0x801ef6,%rbx
  8033b5:	00 00 00 
  8033b8:	ba 00 00 01 00       	mov    $0x10000,%edx
  8033bd:	be 00 00 40 00       	mov    $0x400000,%esi
  8033c2:	bf 00 00 00 00       	mov    $0x0,%edi
  8033c7:	ff d3                	call   *%rbx
  8033c9:	85 c0                	test   %eax,%eax
  8033cb:	78 eb                	js     8033b8 <spawn+0x2a1>
    struct Proghdr *ph = (struct Proghdr *)(elf_buf + elf->e_phoff);
  8033cd:	48 8b 85 f0 fd ff ff 	mov    -0x210(%rbp),%rax
  8033d4:	4c 8d b4 05 d0 fd ff 	lea    -0x230(%rbp,%rax,1),%r14
  8033db:	ff 
    for (size_t i = 0; i < elf->e_phnum; i++, ph++) {
  8033dc:	66 83 bd 08 fe ff ff 	cmpw   $0x0,-0x1f8(%rbp)
  8033e3:	00 
  8033e4:	0f 84 68 02 00 00    	je     803652 <spawn+0x53b>
  8033ea:	41 bf 00 00 00 00    	mov    $0x0,%r15d
  8033f0:	e9 c5 01 00 00       	jmp    8035ba <spawn+0x4a3>
        cprintf("Wrong ELF header size or read error: %i\n", res);
  8033f5:	48 bf 30 55 80 00 00 	movabs $0x805530,%rdi
  8033fc:	00 00 00 
  8033ff:	b8 00 00 00 00       	mov    $0x0,%eax
  803404:	48 ba 1a 0d 80 00 00 	movabs $0x800d1a,%rdx
  80340b:	00 00 00 
  80340e:	ff d2                	call   *%rdx
        close(fd);
  803410:	8b bd fc fc ff ff    	mov    -0x304(%rbp),%edi
  803416:	48 b8 6b 26 80 00 00 	movabs $0x80266b,%rax
  80341d:	00 00 00 
  803420:	ff d0                	call   *%rax
        return -E_NOT_EXEC;
  803422:	c7 85 fc fc ff ff ee 	movl   $0xffffffee,-0x304(%rbp)
  803429:	ff ff ff 
  80342c:	e9 50 03 00 00       	jmp    803781 <spawn+0x66a>
        cprintf("Elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  803431:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  803436:	8b b5 d0 fd ff ff    	mov    -0x230(%rbp),%esi
  80343c:	48 bf 11 53 80 00 00 	movabs $0x805311,%rdi
  803443:	00 00 00 
  803446:	b8 00 00 00 00       	mov    $0x0,%eax
  80344b:	48 b9 1a 0d 80 00 00 	movabs $0x800d1a,%rcx
  803452:	00 00 00 
  803455:	ff d1                	call   *%rcx
        close(fd);
  803457:	8b bd fc fc ff ff    	mov    -0x304(%rbp),%edi
  80345d:	48 b8 6b 26 80 00 00 	movabs $0x80266b,%rax
  803464:	00 00 00 
  803467:	ff d0                	call   *%rax
        return -E_NOT_EXEC;
  803469:	c7 85 fc fc ff ff ee 	movl   $0xffffffee,-0x304(%rbp)
  803470:	ff ff ff 
  803473:	e9 09 03 00 00       	jmp    803781 <spawn+0x66a>
    assert(string_store == (char *)UTEMP + USER_STACK_SIZE);
  803478:	48 b9 60 55 80 00 00 	movabs $0x805560,%rcx
  80347f:	00 00 00 
  803482:	48 ba a9 50 80 00 00 	movabs $0x8050a9,%rdx
  803489:	00 00 00 
  80348c:	be f0 00 00 00       	mov    $0xf0,%esi
  803491:	48 bf 2b 53 80 00 00 	movabs $0x80532b,%rdi
  803498:	00 00 00 
  80349b:	b8 00 00 00 00       	mov    $0x0,%eax
  8034a0:	49 b8 be 0b 80 00 00 	movabs $0x800bbe,%r8
  8034a7:	00 00 00 
  8034aa:	41 ff d0             	call   *%r8
    /* seek() fd to fileoffset  */
    /* read filesz to UTEMP */
    /* Map read section conents to child */
    /* Unmap it from parent */
    if (filesz != 0) {
        res = sys_alloc_region(CURENVID, UTEMP, filesz, perm | PROT_W);
  8034ad:	8b 8d f0 fc ff ff    	mov    -0x310(%rbp),%ecx
  8034b3:	83 c9 02             	or     $0x2,%ecx
  8034b6:	48 89 da             	mov    %rbx,%rdx
  8034b9:	be 00 00 40 00       	mov    $0x400000,%esi
  8034be:	bf 00 00 00 00       	mov    $0x0,%edi
  8034c3:	48 b8 b6 1d 80 00 00 	movabs $0x801db6,%rax
  8034ca:	00 00 00 
  8034cd:	ff d0                	call   *%rax
        if (res < 0) {
  8034cf:	85 c0                	test   %eax,%eax
  8034d1:	0f 88 7e 02 00 00    	js     803755 <spawn+0x63e>
            return res;
        }

        res = seek(fd, fileoffset);
  8034d7:	8b b5 e8 fc ff ff    	mov    -0x318(%rbp),%esi
  8034dd:	8b bd fc fc ff ff    	mov    -0x304(%rbp),%edi
  8034e3:	48 b8 e9 29 80 00 00 	movabs $0x8029e9,%rax
  8034ea:	00 00 00 
  8034ed:	ff d0                	call   *%rax
        if (res < 0) {
  8034ef:	85 c0                	test   %eax,%eax
  8034f1:	0f 88 a2 02 00 00    	js     803799 <spawn+0x682>
            return res;
        }

        res = readn(fd, (void *)UTEMP, filesz);
  8034f7:	48 89 da             	mov    %rbx,%rdx
  8034fa:	be 00 00 40 00       	mov    $0x400000,%esi
  8034ff:	8b bd fc fc ff ff    	mov    -0x304(%rbp),%edi
  803505:	48 b8 b7 28 80 00 00 	movabs $0x8028b7,%rax
  80350c:	00 00 00 
  80350f:	ff d0                	call   *%rax
        if (res < 0) {
  803511:	85 c0                	test   %eax,%eax
  803513:	0f 88 84 02 00 00    	js     80379d <spawn+0x686>
            return res;
        }

        res = sys_map_region(CURENVID, (void *)UTEMP, child, (void *)va, filesz, perm);
  803519:	44 8b 8d f0 fc ff ff 	mov    -0x310(%rbp),%r9d
  803520:	49 89 d8             	mov    %rbx,%r8
  803523:	4c 89 e1             	mov    %r12,%rcx
  803526:	8b 95 e0 fc ff ff    	mov    -0x320(%rbp),%edx
  80352c:	be 00 00 40 00       	mov    $0x400000,%esi
  803531:	bf 00 00 00 00       	mov    $0x0,%edi
  803536:	48 b8 21 1e 80 00 00 	movabs $0x801e21,%rax
  80353d:	00 00 00 
  803540:	ff d0                	call   *%rax
        if (res < 0) {
  803542:	85 c0                	test   %eax,%eax
  803544:	0f 88 57 02 00 00    	js     8037a1 <spawn+0x68a>
            return res;
        }

        res = sys_unmap_region(CURENVID, UTEMP, filesz);
  80354a:	48 89 da             	mov    %rbx,%rdx
  80354d:	be 00 00 40 00       	mov    $0x400000,%esi
  803552:	bf 00 00 00 00       	mov    $0x0,%edi
  803557:	48 b8 f6 1e 80 00 00 	movabs $0x801ef6,%rax
  80355e:	00 00 00 
  803561:	ff d0                	call   *%rax
        if (res < 0) {
  803563:	85 c0                	test   %eax,%eax
  803565:	0f 89 ca 00 00 00    	jns    803635 <spawn+0x51e>
  80356b:	89 c3                	mov    %eax,%ebx
  80356d:	e9 e5 01 00 00       	jmp    803757 <spawn+0x640>
            return res;
        }
    }

    if (memsz > filesz) {
        res = sys_alloc_region(child, (void *)(va + filesz), (memsz - filesz), perm | ALLOC_ZERO);
  803572:	8b 8d f0 fc ff ff    	mov    -0x310(%rbp),%ecx
  803578:	81 c9 00 00 10 00    	or     $0x100000,%ecx
  80357e:	4c 89 ea             	mov    %r13,%rdx
  803581:	48 29 da             	sub    %rbx,%rdx
  803584:	4a 8d 34 23          	lea    (%rbx,%r12,1),%rsi
  803588:	8b bd e0 fc ff ff    	mov    -0x320(%rbp),%edi
  80358e:	48 b8 b6 1d 80 00 00 	movabs $0x801db6,%rax
  803595:	00 00 00 
  803598:	ff d0                	call   *%rax
        if ((res = map_segment(child, ph->p_va, ph->p_memsz,
  80359a:	85 c0                	test   %eax,%eax
  80359c:	0f 88 a1 00 00 00    	js     803643 <spawn+0x52c>
    for (size_t i = 0; i < elf->e_phnum; i++, ph++) {
  8035a2:	49 83 c7 01          	add    $0x1,%r15
  8035a6:	49 83 c6 38          	add    $0x38,%r14
  8035aa:	0f b7 85 08 fe ff ff 	movzwl -0x1f8(%rbp),%eax
  8035b1:	49 39 c7             	cmp    %rax,%r15
  8035b4:	0f 83 98 00 00 00    	jae    803652 <spawn+0x53b>
        if (ph->p_type != ELF_PROG_LOAD) continue;
  8035ba:	41 83 3e 01          	cmpl   $0x1,(%r14)
  8035be:	75 e2                	jne    8035a2 <spawn+0x48b>
        if (ph->p_flags & ELF_PROG_FLAG_WRITE) perm |= PROT_W;
  8035c0:	41 8b 46 04          	mov    0x4(%r14),%eax
  8035c4:	89 c2                	mov    %eax,%edx
  8035c6:	83 e2 02             	and    $0x2,%edx
        if (ph->p_flags & ELF_PROG_FLAG_READ) perm |= PROT_R;
  8035c9:	89 d1                	mov    %edx,%ecx
  8035cb:	83 c9 04             	or     $0x4,%ecx
  8035ce:	a8 04                	test   $0x4,%al
  8035d0:	0f 45 d1             	cmovne %ecx,%edx
        if (ph->p_flags & ELF_PROG_FLAG_EXEC) perm |= PROT_X;
  8035d3:	83 e0 01             	and    $0x1,%eax
  8035d6:	09 d0                	or     %edx,%eax
  8035d8:	89 85 f0 fc ff ff    	mov    %eax,-0x310(%rbp)
        if ((res = map_segment(child, ph->p_va, ph->p_memsz,
  8035de:	49 8b 46 08          	mov    0x8(%r14),%rax
  8035e2:	89 85 e8 fc ff ff    	mov    %eax,-0x318(%rbp)
  8035e8:	49 8b 5e 20          	mov    0x20(%r14),%rbx
  8035ec:	4d 8b 6e 28          	mov    0x28(%r14),%r13
  8035f0:	4d 8b 66 10          	mov    0x10(%r14),%r12
  8035f4:	8b 8d cc fd ff ff    	mov    -0x234(%rbp),%ecx
  8035fa:	89 8d e0 fc ff ff    	mov    %ecx,-0x320(%rbp)
    if (res) {
  803600:	44 89 e2             	mov    %r12d,%edx
  803603:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  803609:	74 14                	je     80361f <spawn+0x508>
        va -= res;
  80360b:	48 63 ca             	movslq %edx,%rcx
  80360e:	49 29 cc             	sub    %rcx,%r12
        memsz += res;
  803611:	49 01 cd             	add    %rcx,%r13
        filesz += res;
  803614:	48 01 cb             	add    %rcx,%rbx
        fileoffset -= res;
  803617:	29 d0                	sub    %edx,%eax
  803619:	89 85 e8 fc ff ff    	mov    %eax,-0x318(%rbp)
    if (filesz > HUGE_PAGE_SIZE) {
  80361f:	48 81 fb 00 00 20 00 	cmp    $0x200000,%rbx
  803626:	0f 87 79 01 00 00    	ja     8037a5 <spawn+0x68e>
    if (filesz != 0) {
  80362c:	48 85 db             	test   %rbx,%rbx
  80362f:	0f 85 78 fe ff ff    	jne    8034ad <spawn+0x396>
    if (memsz > filesz) {
  803635:	4c 39 eb             	cmp    %r13,%rbx
  803638:	0f 83 64 ff ff ff    	jae    8035a2 <spawn+0x48b>
  80363e:	e9 2f ff ff ff       	jmp    803572 <spawn+0x45b>
        if (res < 0) {
  803643:	ba 00 00 00 00       	mov    $0x0,%edx
  803648:	0f 4e d0             	cmovle %eax,%edx
  80364b:	89 d3                	mov    %edx,%ebx
  80364d:	e9 05 01 00 00       	jmp    803757 <spawn+0x640>
    close(fd);
  803652:	8b bd fc fc ff ff    	mov    -0x304(%rbp),%edi
  803658:	48 b8 6b 26 80 00 00 	movabs $0x80266b,%rax
  80365f:	00 00 00 
  803662:	ff d0                	call   *%rax
    if ((res = foreach_shared_region(copy_shared_region, &child)) < 0)
  803664:	48 8d b5 cc fd ff ff 	lea    -0x234(%rbp),%rsi
  80366b:	48 bf c3 30 80 00 00 	movabs $0x8030c3,%rdi
  803672:	00 00 00 
  803675:	48 b8 7c 41 80 00 00 	movabs $0x80417c,%rax
  80367c:	00 00 00 
  80367f:	ff d0                	call   *%rax
  803681:	85 c0                	test   %eax,%eax
  803683:	78 49                	js     8036ce <spawn+0x5b7>
    if ((res = sys_env_set_trapframe(child, &child_tf)) < 0)
  803685:	48 8d b5 0c fd ff ff 	lea    -0x2f4(%rbp),%rsi
  80368c:	8b bd cc fd ff ff    	mov    -0x234(%rbp),%edi
  803692:	48 b8 ce 1f 80 00 00 	movabs $0x801fce,%rax
  803699:	00 00 00 
  80369c:	ff d0                	call   *%rax
  80369e:	85 c0                	test   %eax,%eax
  8036a0:	78 59                	js     8036fb <spawn+0x5e4>
    if ((res = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  8036a2:	be 02 00 00 00       	mov    $0x2,%esi
  8036a7:	8b bd cc fd ff ff    	mov    -0x234(%rbp),%edi
  8036ad:	48 b8 61 1f 80 00 00 	movabs $0x801f61,%rax
  8036b4:	00 00 00 
  8036b7:	ff d0                	call   *%rax
  8036b9:	85 c0                	test   %eax,%eax
  8036bb:	78 6b                	js     803728 <spawn+0x611>
    return child;
  8036bd:	8b 85 cc fd ff ff    	mov    -0x234(%rbp),%eax
  8036c3:	89 85 fc fc ff ff    	mov    %eax,-0x304(%rbp)
  8036c9:	e9 b3 00 00 00       	jmp    803781 <spawn+0x66a>
        panic("copy_shared_region: %i", res);
  8036ce:	89 c1                	mov    %eax,%ecx
  8036d0:	48 ba 37 53 80 00 00 	movabs $0x805337,%rdx
  8036d7:	00 00 00 
  8036da:	be 84 00 00 00       	mov    $0x84,%esi
  8036df:	48 bf 2b 53 80 00 00 	movabs $0x80532b,%rdi
  8036e6:	00 00 00 
  8036e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8036ee:	49 b8 be 0b 80 00 00 	movabs $0x800bbe,%r8
  8036f5:	00 00 00 
  8036f8:	41 ff d0             	call   *%r8
        panic("sys_env_set_trapframe: %i", res);
  8036fb:	89 c1                	mov    %eax,%ecx
  8036fd:	48 ba 4e 53 80 00 00 	movabs $0x80534e,%rdx
  803704:	00 00 00 
  803707:	be 87 00 00 00       	mov    $0x87,%esi
  80370c:	48 bf 2b 53 80 00 00 	movabs $0x80532b,%rdi
  803713:	00 00 00 
  803716:	b8 00 00 00 00       	mov    $0x0,%eax
  80371b:	49 b8 be 0b 80 00 00 	movabs $0x800bbe,%r8
  803722:	00 00 00 
  803725:	41 ff d0             	call   *%r8
        panic("sys_env_set_status: %i", res);
  803728:	89 c1                	mov    %eax,%ecx
  80372a:	48 ba 68 53 80 00 00 	movabs $0x805368,%rdx
  803731:	00 00 00 
  803734:	be 8a 00 00 00       	mov    $0x8a,%esi
  803739:	48 bf 2b 53 80 00 00 	movabs $0x80532b,%rdi
  803740:	00 00 00 
  803743:	b8 00 00 00 00       	mov    $0x0,%eax
  803748:	49 b8 be 0b 80 00 00 	movabs $0x800bbe,%r8
  80374f:	00 00 00 
  803752:	41 ff d0             	call   *%r8
  803755:	89 c3                	mov    %eax,%ebx
    sys_env_destroy(child);
  803757:	8b bd cc fd ff ff    	mov    -0x234(%rbp),%edi
  80375d:	48 b8 77 1c 80 00 00 	movabs $0x801c77,%rax
  803764:	00 00 00 
  803767:	ff d0                	call   *%rax
    close(fd);
  803769:	8b bd fc fc ff ff    	mov    -0x304(%rbp),%edi
  80376f:	48 b8 6b 26 80 00 00 	movabs $0x80266b,%rax
  803776:	00 00 00 
  803779:	ff d0                	call   *%rax
    return res;
  80377b:	89 9d fc fc ff ff    	mov    %ebx,-0x304(%rbp)
}
  803781:	8b 85 fc fc ff ff    	mov    -0x304(%rbp),%eax
  803787:	48 81 c4 f8 02 00 00 	add    $0x2f8,%rsp
  80378e:	5b                   	pop    %rbx
  80378f:	41 5c                	pop    %r12
  803791:	41 5d                	pop    %r13
  803793:	41 5e                	pop    %r14
  803795:	41 5f                	pop    %r15
  803797:	5d                   	pop    %rbp
  803798:	c3                   	ret
  803799:	89 c3                	mov    %eax,%ebx
  80379b:	eb ba                	jmp    803757 <spawn+0x640>
  80379d:	89 c3                	mov    %eax,%ebx
  80379f:	eb b6                	jmp    803757 <spawn+0x640>
  8037a1:	89 c3                	mov    %eax,%ebx
  8037a3:	eb b2                	jmp    803757 <spawn+0x640>
        return -E_INVAL;
  8037a5:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
  8037aa:	eb ab                	jmp    803757 <spawn+0x640>
    if ((void *)(argv_store - 2) < (void *)UTEMP) return -E_NO_MEM;
  8037ac:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
    if ((res = init_stack(child, argv, &child_tf)) < 0) goto error;
  8037b1:	89 c3                	mov    %eax,%ebx
  8037b3:	eb a2                	jmp    803757 <spawn+0x640>
    if ((res = sys_alloc_region(0, UTEMP, USER_STACK_SIZE, PROT_RW)) < 0) return res;
  8037b5:	b9 06 00 00 00       	mov    $0x6,%ecx
  8037ba:	ba 00 00 01 00       	mov    $0x10000,%edx
  8037bf:	be 00 00 40 00       	mov    $0x400000,%esi
  8037c4:	bf 00 00 00 00       	mov    $0x0,%edi
  8037c9:	48 b8 b6 1d 80 00 00 	movabs $0x801db6,%rax
  8037d0:	00 00 00 
  8037d3:	ff d0                	call   *%rax
  8037d5:	85 c0                	test   %eax,%eax
  8037d7:	78 d8                	js     8037b1 <spawn+0x69a>
    for (argc = 0; argv[argc] != 0; argc++)
  8037d9:	48 c7 85 e8 fc ff ff 	movq   $0x0,-0x318(%rbp)
  8037e0:	00 00 00 00 
    argv_store = (uintptr_t *)(ROUNDDOWN(string_store, sizeof(uintptr_t)) - sizeof(uintptr_t) * (argc + 1));
  8037e4:	48 c7 85 f0 fc ff ff 	movq   $0x40fff8,-0x310(%rbp)
  8037eb:	f8 ff 40 00 
  8037ef:	48 c7 85 e0 fc ff ff 	movq   $0x410000,-0x320(%rbp)
  8037f6:	00 00 41 00 
    string_store = (char *)UTEMP + USER_STACK_SIZE - string_size;
  8037fa:	bb 00 00 41 00       	mov    $0x410000,%ebx
  8037ff:	e9 28 fb ff ff       	jmp    80332c <spawn+0x215>

0000000000803804 <spawnl>:
spawnl(const char *prog, const char *arg0, ...) {
  803804:	f3 0f 1e fa          	endbr64
  803808:	55                   	push   %rbp
  803809:	48 89 e5             	mov    %rsp,%rbp
  80380c:	48 83 ec 50          	sub    $0x50,%rsp
  803810:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803814:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  803818:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  80381c:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(vl, arg0);
  803820:	c7 45 b8 10 00 00 00 	movl   $0x10,-0x48(%rbp)
  803827:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80382b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80382f:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803833:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int argc = 0;
  803837:	b9 00 00 00 00       	mov    $0x0,%ecx
    while (va_arg(vl, void *) != NULL) argc++;
  80383c:	eb 15                	jmp    803853 <spawnl+0x4f>
  80383e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803842:	48 8d 42 08          	lea    0x8(%rdx),%rax
  803846:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80384a:	48 83 3a 00          	cmpq   $0x0,(%rdx)
  80384e:	74 1c                	je     80386c <spawnl+0x68>
  803850:	83 c1 01             	add    $0x1,%ecx
  803853:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803856:	83 f8 2f             	cmp    $0x2f,%eax
  803859:	77 e3                	ja     80383e <spawnl+0x3a>
  80385b:	89 c2                	mov    %eax,%edx
  80385d:	4c 8d 55 d0          	lea    -0x30(%rbp),%r10
  803861:	4c 01 d2             	add    %r10,%rdx
  803864:	83 c0 08             	add    $0x8,%eax
  803867:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80386a:	eb de                	jmp    80384a <spawnl+0x46>
    const char *argv[argc + 2];
  80386c:	8d 41 02             	lea    0x2(%rcx),%eax
  80386f:	48 98                	cltq
  803871:	48 8d 04 c5 0f 00 00 	lea    0xf(,%rax,8),%rax
  803878:	00 
  803879:	49 89 c0             	mov    %rax,%r8
  80387c:	49 83 e0 f0          	and    $0xfffffffffffffff0,%r8
  803880:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  803886:	48 89 e2             	mov    %rsp,%rdx
  803889:	48 29 c2             	sub    %rax,%rdx
  80388c:	48 39 d4             	cmp    %rdx,%rsp
  80388f:	74 12                	je     8038a3 <spawnl+0x9f>
  803891:	48 81 ec 00 10 00 00 	sub    $0x1000,%rsp
  803898:	48 83 8c 24 f8 0f 00 	orq    $0x0,0xff8(%rsp)
  80389f:	00 00 
  8038a1:	eb e9                	jmp    80388c <spawnl+0x88>
  8038a3:	4c 89 c0             	mov    %r8,%rax
  8038a6:	25 ff 0f 00 00       	and    $0xfff,%eax
  8038ab:	48 29 c4             	sub    %rax,%rsp
  8038ae:	48 85 c0             	test   %rax,%rax
  8038b1:	74 06                	je     8038b9 <spawnl+0xb5>
  8038b3:	48 83 4c 04 f8 00    	orq    $0x0,-0x8(%rsp,%rax,1)
  8038b9:	4c 8d 4c 24 07       	lea    0x7(%rsp),%r9
  8038be:	4c 89 c8             	mov    %r9,%rax
  8038c1:	48 c1 e8 03          	shr    $0x3,%rax
  8038c5:	49 83 e1 f8          	and    $0xfffffffffffffff8,%r9
    argv[0] = arg0;
  8038c9:	48 89 34 c5 00 00 00 	mov    %rsi,0x0(,%rax,8)
  8038d0:	00 
    argv[argc + 1] = NULL;
  8038d1:	8d 41 01             	lea    0x1(%rcx),%eax
  8038d4:	48 98                	cltq
  8038d6:	49 c7 04 c1 00 00 00 	movq   $0x0,(%r9,%rax,8)
  8038dd:	00 
    va_start(vl, arg0);
  8038de:	c7 45 b8 10 00 00 00 	movl   $0x10,-0x48(%rbp)
  8038e5:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8038e9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8038ed:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8038f1:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    for (i = 0; i < argc; i++) {
  8038f5:	85 c9                	test   %ecx,%ecx
  8038f7:	74 41                	je     80393a <spawnl+0x136>
        argv[i + 1] = va_arg(vl, const char *);
  8038f9:	49 89 c0             	mov    %rax,%r8
  8038fc:	49 8d 41 08          	lea    0x8(%r9),%rax
  803900:	8d 51 ff             	lea    -0x1(%rcx),%edx
  803903:	49 8d 74 d1 10       	lea    0x10(%r9,%rdx,8),%rsi
  803908:	eb 1b                	jmp    803925 <spawnl+0x121>
  80390a:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  80390e:	48 8d 51 08          	lea    0x8(%rcx),%rdx
  803912:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803916:	48 8b 11             	mov    (%rcx),%rdx
  803919:	48 89 10             	mov    %rdx,(%rax)
    for (i = 0; i < argc; i++) {
  80391c:	48 83 c0 08          	add    $0x8,%rax
  803920:	48 39 f0             	cmp    %rsi,%rax
  803923:	74 15                	je     80393a <spawnl+0x136>
        argv[i + 1] = va_arg(vl, const char *);
  803925:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803928:	83 fa 2f             	cmp    $0x2f,%edx
  80392b:	77 dd                	ja     80390a <spawnl+0x106>
  80392d:	89 d1                	mov    %edx,%ecx
  80392f:	4c 01 c1             	add    %r8,%rcx
  803932:	83 c2 08             	add    $0x8,%edx
  803935:	89 55 b8             	mov    %edx,-0x48(%rbp)
  803938:	eb dc                	jmp    803916 <spawnl+0x112>
    return spawn(prog, argv);
  80393a:	4c 89 ce             	mov    %r9,%rsi
  80393d:	48 b8 17 31 80 00 00 	movabs $0x803117,%rax
  803944:	00 00 00 
  803947:	ff d0                	call   *%rax
}
  803949:	c9                   	leave
  80394a:	c3                   	ret

000000000080394b <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  80394b:	f3 0f 1e fa          	endbr64
  80394f:	55                   	push   %rbp
  803950:	48 89 e5             	mov    %rsp,%rbp
  803953:	41 54                	push   %r12
  803955:	53                   	push   %rbx
  803956:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  803959:	48 b8 76 24 80 00 00 	movabs $0x802476,%rax
  803960:	00 00 00 
  803963:	ff d0                	call   *%rax
  803965:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  803968:	48 be 7f 53 80 00 00 	movabs $0x80537f,%rsi
  80396f:	00 00 00 
  803972:	48 89 df             	mov    %rbx,%rdi
  803975:	48 b8 63 16 80 00 00 	movabs $0x801663,%rax
  80397c:	00 00 00 
  80397f:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  803981:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  803986:	41 2b 04 24          	sub    (%r12),%eax
  80398a:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  803990:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  803997:	00 00 00 
    stat->st_dev = &devpipe;
  80399a:	48 b8 80 60 80 00 00 	movabs $0x806080,%rax
  8039a1:	00 00 00 
  8039a4:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  8039ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8039b0:	5b                   	pop    %rbx
  8039b1:	41 5c                	pop    %r12
  8039b3:	5d                   	pop    %rbp
  8039b4:	c3                   	ret

00000000008039b5 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  8039b5:	f3 0f 1e fa          	endbr64
  8039b9:	55                   	push   %rbp
  8039ba:	48 89 e5             	mov    %rsp,%rbp
  8039bd:	41 54                	push   %r12
  8039bf:	53                   	push   %rbx
  8039c0:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  8039c3:	ba 00 10 00 00       	mov    $0x1000,%edx
  8039c8:	48 89 fe             	mov    %rdi,%rsi
  8039cb:	bf 00 00 00 00       	mov    $0x0,%edi
  8039d0:	49 bc f6 1e 80 00 00 	movabs $0x801ef6,%r12
  8039d7:	00 00 00 
  8039da:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  8039dd:	48 89 df             	mov    %rbx,%rdi
  8039e0:	48 b8 76 24 80 00 00 	movabs $0x802476,%rax
  8039e7:	00 00 00 
  8039ea:	ff d0                	call   *%rax
  8039ec:	48 89 c6             	mov    %rax,%rsi
  8039ef:	ba 00 10 00 00       	mov    $0x1000,%edx
  8039f4:	bf 00 00 00 00       	mov    $0x0,%edi
  8039f9:	41 ff d4             	call   *%r12
}
  8039fc:	5b                   	pop    %rbx
  8039fd:	41 5c                	pop    %r12
  8039ff:	5d                   	pop    %rbp
  803a00:	c3                   	ret

0000000000803a01 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  803a01:	f3 0f 1e fa          	endbr64
  803a05:	55                   	push   %rbp
  803a06:	48 89 e5             	mov    %rsp,%rbp
  803a09:	41 57                	push   %r15
  803a0b:	41 56                	push   %r14
  803a0d:	41 55                	push   %r13
  803a0f:	41 54                	push   %r12
  803a11:	53                   	push   %rbx
  803a12:	48 83 ec 18          	sub    $0x18,%rsp
  803a16:	49 89 fc             	mov    %rdi,%r12
  803a19:	49 89 f5             	mov    %rsi,%r13
  803a1c:	49 89 d7             	mov    %rdx,%r15
  803a1f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  803a23:	48 b8 76 24 80 00 00 	movabs $0x802476,%rax
  803a2a:	00 00 00 
  803a2d:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  803a2f:	4d 85 ff             	test   %r15,%r15
  803a32:	0f 84 af 00 00 00    	je     803ae7 <devpipe_write+0xe6>
  803a38:	48 89 c3             	mov    %rax,%rbx
  803a3b:	4c 89 f8             	mov    %r15,%rax
  803a3e:	4d 89 ef             	mov    %r13,%r15
  803a41:	4c 01 e8             	add    %r13,%rax
  803a44:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  803a48:	49 bd 86 1d 80 00 00 	movabs $0x801d86,%r13
  803a4f:	00 00 00 
            sys_yield();
  803a52:	49 be 1b 1d 80 00 00 	movabs $0x801d1b,%r14
  803a59:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  803a5c:	8b 73 04             	mov    0x4(%rbx),%esi
  803a5f:	48 63 ce             	movslq %esi,%rcx
  803a62:	48 63 03             	movslq (%rbx),%rax
  803a65:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  803a6b:	48 39 c1             	cmp    %rax,%rcx
  803a6e:	72 2e                	jb     803a9e <devpipe_write+0x9d>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  803a70:	b9 00 10 00 00       	mov    $0x1000,%ecx
  803a75:	48 89 da             	mov    %rbx,%rdx
  803a78:	be 00 10 00 00       	mov    $0x1000,%esi
  803a7d:	4c 89 e7             	mov    %r12,%rdi
  803a80:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  803a83:	85 c0                	test   %eax,%eax
  803a85:	74 66                	je     803aed <devpipe_write+0xec>
            sys_yield();
  803a87:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  803a8a:	8b 73 04             	mov    0x4(%rbx),%esi
  803a8d:	48 63 ce             	movslq %esi,%rcx
  803a90:	48 63 03             	movslq (%rbx),%rax
  803a93:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  803a99:	48 39 c1             	cmp    %rax,%rcx
  803a9c:	73 d2                	jae    803a70 <devpipe_write+0x6f>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803a9e:	41 0f b6 3f          	movzbl (%r15),%edi
  803aa2:	48 89 ca             	mov    %rcx,%rdx
  803aa5:	48 c1 ea 03          	shr    $0x3,%rdx
  803aa9:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  803ab0:	08 10 20 
  803ab3:	48 f7 e2             	mul    %rdx
  803ab6:	48 c1 ea 06          	shr    $0x6,%rdx
  803aba:	48 89 d0             	mov    %rdx,%rax
  803abd:	48 c1 e0 09          	shl    $0x9,%rax
  803ac1:	48 29 d0             	sub    %rdx,%rax
  803ac4:	48 c1 e0 03          	shl    $0x3,%rax
  803ac8:	48 29 c1             	sub    %rax,%rcx
  803acb:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  803ad0:	83 c6 01             	add    $0x1,%esi
  803ad3:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  803ad6:	49 83 c7 01          	add    $0x1,%r15
  803ada:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803ade:	49 39 c7             	cmp    %rax,%r15
  803ae1:	0f 85 75 ff ff ff    	jne    803a5c <devpipe_write+0x5b>
    return n;
  803ae7:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803aeb:	eb 05                	jmp    803af2 <devpipe_write+0xf1>
            if (_pipeisclosed(fd, p)) return 0;
  803aed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803af2:	48 83 c4 18          	add    $0x18,%rsp
  803af6:	5b                   	pop    %rbx
  803af7:	41 5c                	pop    %r12
  803af9:	41 5d                	pop    %r13
  803afb:	41 5e                	pop    %r14
  803afd:	41 5f                	pop    %r15
  803aff:	5d                   	pop    %rbp
  803b00:	c3                   	ret

0000000000803b01 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  803b01:	f3 0f 1e fa          	endbr64
  803b05:	55                   	push   %rbp
  803b06:	48 89 e5             	mov    %rsp,%rbp
  803b09:	41 57                	push   %r15
  803b0b:	41 56                	push   %r14
  803b0d:	41 55                	push   %r13
  803b0f:	41 54                	push   %r12
  803b11:	53                   	push   %rbx
  803b12:	48 83 ec 18          	sub    $0x18,%rsp
  803b16:	49 89 fc             	mov    %rdi,%r12
  803b19:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  803b1d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  803b21:	48 b8 76 24 80 00 00 	movabs $0x802476,%rax
  803b28:	00 00 00 
  803b2b:	ff d0                	call   *%rax
  803b2d:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  803b30:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  803b36:	49 bd 86 1d 80 00 00 	movabs $0x801d86,%r13
  803b3d:	00 00 00 
            sys_yield();
  803b40:	49 be 1b 1d 80 00 00 	movabs $0x801d1b,%r14
  803b47:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  803b4a:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  803b4f:	74 7d                	je     803bce <devpipe_read+0xcd>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  803b51:	8b 03                	mov    (%rbx),%eax
  803b53:	3b 43 04             	cmp    0x4(%rbx),%eax
  803b56:	75 26                	jne    803b7e <devpipe_read+0x7d>
            if (i > 0) return i;
  803b58:	4d 85 ff             	test   %r15,%r15
  803b5b:	75 77                	jne    803bd4 <devpipe_read+0xd3>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  803b5d:	b9 00 10 00 00       	mov    $0x1000,%ecx
  803b62:	48 89 da             	mov    %rbx,%rdx
  803b65:	be 00 10 00 00       	mov    $0x1000,%esi
  803b6a:	4c 89 e7             	mov    %r12,%rdi
  803b6d:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  803b70:	85 c0                	test   %eax,%eax
  803b72:	74 72                	je     803be6 <devpipe_read+0xe5>
            sys_yield();
  803b74:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  803b77:	8b 03                	mov    (%rbx),%eax
  803b79:	3b 43 04             	cmp    0x4(%rbx),%eax
  803b7c:	74 df                	je     803b5d <devpipe_read+0x5c>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803b7e:	48 63 c8             	movslq %eax,%rcx
  803b81:	48 89 ca             	mov    %rcx,%rdx
  803b84:	48 c1 ea 03          	shr    $0x3,%rdx
  803b88:	48 be 81 00 01 02 04 	movabs $0x2010080402010081,%rsi
  803b8f:	08 10 20 
  803b92:	48 89 d0             	mov    %rdx,%rax
  803b95:	48 f7 e6             	mul    %rsi
  803b98:	48 c1 ea 06          	shr    $0x6,%rdx
  803b9c:	48 89 d0             	mov    %rdx,%rax
  803b9f:	48 c1 e0 09          	shl    $0x9,%rax
  803ba3:	48 29 d0             	sub    %rdx,%rax
  803ba6:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803bad:	00 
  803bae:	48 89 c8             	mov    %rcx,%rax
  803bb1:	48 29 d0             	sub    %rdx,%rax
  803bb4:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  803bb9:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  803bbd:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  803bc1:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  803bc4:	49 83 c7 01          	add    $0x1,%r15
  803bc8:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  803bcc:	75 83                	jne    803b51 <devpipe_read+0x50>
    return n;
  803bce:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803bd2:	eb 03                	jmp    803bd7 <devpipe_read+0xd6>
            if (i > 0) return i;
  803bd4:	4c 89 f8             	mov    %r15,%rax
}
  803bd7:	48 83 c4 18          	add    $0x18,%rsp
  803bdb:	5b                   	pop    %rbx
  803bdc:	41 5c                	pop    %r12
  803bde:	41 5d                	pop    %r13
  803be0:	41 5e                	pop    %r14
  803be2:	41 5f                	pop    %r15
  803be4:	5d                   	pop    %rbp
  803be5:	c3                   	ret
            if (_pipeisclosed(fd, p)) return 0;
  803be6:	b8 00 00 00 00       	mov    $0x0,%eax
  803beb:	eb ea                	jmp    803bd7 <devpipe_read+0xd6>

0000000000803bed <pipe>:
pipe(int pfd[2]) {
  803bed:	f3 0f 1e fa          	endbr64
  803bf1:	55                   	push   %rbp
  803bf2:	48 89 e5             	mov    %rsp,%rbp
  803bf5:	41 55                	push   %r13
  803bf7:	41 54                	push   %r12
  803bf9:	53                   	push   %rbx
  803bfa:	48 83 ec 18          	sub    $0x18,%rsp
  803bfe:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  803c01:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  803c05:	48 b8 96 24 80 00 00 	movabs $0x802496,%rax
  803c0c:	00 00 00 
  803c0f:	ff d0                	call   *%rax
  803c11:	89 c3                	mov    %eax,%ebx
  803c13:	85 c0                	test   %eax,%eax
  803c15:	0f 88 a0 01 00 00    	js     803dbb <pipe+0x1ce>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  803c1b:	b9 46 00 00 00       	mov    $0x46,%ecx
  803c20:	ba 00 10 00 00       	mov    $0x1000,%edx
  803c25:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  803c29:	bf 00 00 00 00       	mov    $0x0,%edi
  803c2e:	48 b8 b6 1d 80 00 00 	movabs $0x801db6,%rax
  803c35:	00 00 00 
  803c38:	ff d0                	call   *%rax
  803c3a:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  803c3c:	85 c0                	test   %eax,%eax
  803c3e:	0f 88 77 01 00 00    	js     803dbb <pipe+0x1ce>
    if ((res = fd_alloc(&fd1)) < 0 ||
  803c44:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  803c48:	48 b8 96 24 80 00 00 	movabs $0x802496,%rax
  803c4f:	00 00 00 
  803c52:	ff d0                	call   *%rax
  803c54:	89 c3                	mov    %eax,%ebx
  803c56:	85 c0                	test   %eax,%eax
  803c58:	0f 88 43 01 00 00    	js     803da1 <pipe+0x1b4>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  803c5e:	b9 46 00 00 00       	mov    $0x46,%ecx
  803c63:	ba 00 10 00 00       	mov    $0x1000,%edx
  803c68:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  803c6c:	bf 00 00 00 00       	mov    $0x0,%edi
  803c71:	48 b8 b6 1d 80 00 00 	movabs $0x801db6,%rax
  803c78:	00 00 00 
  803c7b:	ff d0                	call   *%rax
  803c7d:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  803c7f:	85 c0                	test   %eax,%eax
  803c81:	0f 88 1a 01 00 00    	js     803da1 <pipe+0x1b4>
    va = fd2data(fd0);
  803c87:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  803c8b:	48 b8 76 24 80 00 00 	movabs $0x802476,%rax
  803c92:	00 00 00 
  803c95:	ff d0                	call   *%rax
  803c97:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  803c9a:	b9 46 00 00 00       	mov    $0x46,%ecx
  803c9f:	ba 00 10 00 00       	mov    $0x1000,%edx
  803ca4:	48 89 c6             	mov    %rax,%rsi
  803ca7:	bf 00 00 00 00       	mov    $0x0,%edi
  803cac:	48 b8 b6 1d 80 00 00 	movabs $0x801db6,%rax
  803cb3:	00 00 00 
  803cb6:	ff d0                	call   *%rax
  803cb8:	89 c3                	mov    %eax,%ebx
  803cba:	85 c0                	test   %eax,%eax
  803cbc:	0f 88 c5 00 00 00    	js     803d87 <pipe+0x19a>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  803cc2:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  803cc6:	48 b8 76 24 80 00 00 	movabs $0x802476,%rax
  803ccd:	00 00 00 
  803cd0:	ff d0                	call   *%rax
  803cd2:	48 89 c1             	mov    %rax,%rcx
  803cd5:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  803cdb:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  803ce1:	ba 00 00 00 00       	mov    $0x0,%edx
  803ce6:	4c 89 ee             	mov    %r13,%rsi
  803ce9:	bf 00 00 00 00       	mov    $0x0,%edi
  803cee:	48 b8 21 1e 80 00 00 	movabs $0x801e21,%rax
  803cf5:	00 00 00 
  803cf8:	ff d0                	call   *%rax
  803cfa:	89 c3                	mov    %eax,%ebx
  803cfc:	85 c0                	test   %eax,%eax
  803cfe:	78 6e                	js     803d6e <pipe+0x181>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  803d00:	be 00 10 00 00       	mov    $0x1000,%esi
  803d05:	4c 89 ef             	mov    %r13,%rdi
  803d08:	48 b8 50 1d 80 00 00 	movabs $0x801d50,%rax
  803d0f:	00 00 00 
  803d12:	ff d0                	call   *%rax
  803d14:	83 f8 02             	cmp    $0x2,%eax
  803d17:	0f 85 ab 00 00 00    	jne    803dc8 <pipe+0x1db>
    fd0->fd_dev_id = devpipe.dev_id;
  803d1d:	a1 80 60 80 00 00 00 	movabs 0x806080,%eax
  803d24:	00 00 
  803d26:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803d2a:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  803d2c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803d30:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  803d37:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  803d3b:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  803d3d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d41:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  803d48:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  803d4c:	48 bb 60 24 80 00 00 	movabs $0x802460,%rbx
  803d53:	00 00 00 
  803d56:	ff d3                	call   *%rbx
  803d58:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  803d5c:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  803d60:	ff d3                	call   *%rbx
  803d62:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  803d67:	bb 00 00 00 00       	mov    $0x0,%ebx
  803d6c:	eb 4d                	jmp    803dbb <pipe+0x1ce>
    sys_unmap_region(0, va, PAGE_SIZE);
  803d6e:	ba 00 10 00 00       	mov    $0x1000,%edx
  803d73:	4c 89 ee             	mov    %r13,%rsi
  803d76:	bf 00 00 00 00       	mov    $0x0,%edi
  803d7b:	48 b8 f6 1e 80 00 00 	movabs $0x801ef6,%rax
  803d82:	00 00 00 
  803d85:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  803d87:	ba 00 10 00 00       	mov    $0x1000,%edx
  803d8c:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  803d90:	bf 00 00 00 00       	mov    $0x0,%edi
  803d95:	48 b8 f6 1e 80 00 00 	movabs $0x801ef6,%rax
  803d9c:	00 00 00 
  803d9f:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  803da1:	ba 00 10 00 00       	mov    $0x1000,%edx
  803da6:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  803daa:	bf 00 00 00 00       	mov    $0x0,%edi
  803daf:	48 b8 f6 1e 80 00 00 	movabs $0x801ef6,%rax
  803db6:	00 00 00 
  803db9:	ff d0                	call   *%rax
}
  803dbb:	89 d8                	mov    %ebx,%eax
  803dbd:	48 83 c4 18          	add    $0x18,%rsp
  803dc1:	5b                   	pop    %rbx
  803dc2:	41 5c                	pop    %r12
  803dc4:	41 5d                	pop    %r13
  803dc6:	5d                   	pop    %rbp
  803dc7:	c3                   	ret
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  803dc8:	48 b9 90 55 80 00 00 	movabs $0x805590,%rcx
  803dcf:	00 00 00 
  803dd2:	48 ba a9 50 80 00 00 	movabs $0x8050a9,%rdx
  803dd9:	00 00 00 
  803ddc:	be 2e 00 00 00       	mov    $0x2e,%esi
  803de1:	48 bf 86 53 80 00 00 	movabs $0x805386,%rdi
  803de8:	00 00 00 
  803deb:	b8 00 00 00 00       	mov    $0x0,%eax
  803df0:	49 b8 be 0b 80 00 00 	movabs $0x800bbe,%r8
  803df7:	00 00 00 
  803dfa:	41 ff d0             	call   *%r8

0000000000803dfd <pipeisclosed>:
pipeisclosed(int fdnum) {
  803dfd:	f3 0f 1e fa          	endbr64
  803e01:	55                   	push   %rbp
  803e02:	48 89 e5             	mov    %rsp,%rbp
  803e05:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  803e09:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  803e0d:	48 b8 fa 24 80 00 00 	movabs $0x8024fa,%rax
  803e14:	00 00 00 
  803e17:	ff d0                	call   *%rax
    if (res < 0) return res;
  803e19:	85 c0                	test   %eax,%eax
  803e1b:	78 35                	js     803e52 <pipeisclosed+0x55>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  803e1d:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  803e21:	48 b8 76 24 80 00 00 	movabs $0x802476,%rax
  803e28:	00 00 00 
  803e2b:	ff d0                	call   *%rax
  803e2d:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  803e30:	b9 00 10 00 00       	mov    $0x1000,%ecx
  803e35:	be 00 10 00 00       	mov    $0x1000,%esi
  803e3a:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  803e3e:	48 b8 86 1d 80 00 00 	movabs $0x801d86,%rax
  803e45:	00 00 00 
  803e48:	ff d0                	call   *%rax
  803e4a:	85 c0                	test   %eax,%eax
  803e4c:	0f 94 c0             	sete   %al
  803e4f:	0f b6 c0             	movzbl %al,%eax
}
  803e52:	c9                   	leave
  803e53:	c3                   	ret

0000000000803e54 <wait>:
#include <inc/lib.h>

/* Waits until 'envid' exits. */
void
wait(envid_t envid) {
  803e54:	f3 0f 1e fa          	endbr64
  803e58:	55                   	push   %rbp
  803e59:	48 89 e5             	mov    %rsp,%rbp
  803e5c:	41 55                	push   %r13
  803e5e:	41 54                	push   %r12
  803e60:	53                   	push   %rbx
  803e61:	48 83 ec 08          	sub    $0x8,%rsp
    assert(envid != 0);
  803e65:	85 ff                	test   %edi,%edi
  803e67:	74 7d                	je     803ee6 <wait+0x92>
  803e69:	41 89 fc             	mov    %edi,%r12d

    const volatile struct Env *env = &envs[ENVX(envid)];
  803e6c:	89 f8                	mov    %edi,%eax
  803e6e:	25 ff 03 00 00       	and    $0x3ff,%eax

    while (env->env_id == envid &&
  803e73:	89 fa                	mov    %edi,%edx
  803e75:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  803e7b:	48 8d 0c d2          	lea    (%rdx,%rdx,8),%rcx
  803e7f:	48 8d 0c 4a          	lea    (%rdx,%rcx,2),%rcx
  803e83:	48 c1 e1 04          	shl    $0x4,%rcx
  803e87:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  803e8e:	00 00 00 
  803e91:	48 01 ca             	add    %rcx,%rdx
  803e94:	8b 92 c8 00 00 00    	mov    0xc8(%rdx),%edx
  803e9a:	39 d7                	cmp    %edx,%edi
  803e9c:	75 3d                	jne    803edb <wait+0x87>
           env->env_status != ENV_FREE) {
  803e9e:	48 98                	cltq
  803ea0:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  803ea4:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  803ea8:	48 c1 e0 04          	shl    $0x4,%rax
  803eac:	48 bb 00 00 a0 1f 80 	movabs $0x801fa00000,%rbx
  803eb3:	00 00 00 
  803eb6:	48 01 c3             	add    %rax,%rbx
        sys_yield();
  803eb9:	49 bd 1b 1d 80 00 00 	movabs $0x801d1b,%r13
  803ec0:	00 00 00 
           env->env_status != ENV_FREE) {
  803ec3:	8b 83 d4 00 00 00    	mov    0xd4(%rbx),%eax
    while (env->env_id == envid &&
  803ec9:	85 c0                	test   %eax,%eax
  803ecb:	74 0e                	je     803edb <wait+0x87>
        sys_yield();
  803ecd:	41 ff d5             	call   *%r13
    while (env->env_id == envid &&
  803ed0:	8b 83 c8 00 00 00    	mov    0xc8(%rbx),%eax
  803ed6:	44 39 e0             	cmp    %r12d,%eax
  803ed9:	74 e8                	je     803ec3 <wait+0x6f>
    }
}
  803edb:	48 83 c4 08          	add    $0x8,%rsp
  803edf:	5b                   	pop    %rbx
  803ee0:	41 5c                	pop    %r12
  803ee2:	41 5d                	pop    %r13
  803ee4:	5d                   	pop    %rbp
  803ee5:	c3                   	ret
    assert(envid != 0);
  803ee6:	48 b9 96 53 80 00 00 	movabs $0x805396,%rcx
  803eed:	00 00 00 
  803ef0:	48 ba a9 50 80 00 00 	movabs $0x8050a9,%rdx
  803ef7:	00 00 00 
  803efa:	be 06 00 00 00       	mov    $0x6,%esi
  803eff:	48 bf a1 53 80 00 00 	movabs $0x8053a1,%rdi
  803f06:	00 00 00 
  803f09:	b8 00 00 00 00       	mov    $0x0,%eax
  803f0e:	49 b8 be 0b 80 00 00 	movabs $0x800bbe,%r8
  803f15:	00 00 00 
  803f18:	41 ff d0             	call   *%r8

0000000000803f1b <get_uvpt_entry>:
extern volatile pde_t uvpd[];     /* VA of current page directory */
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
  803f1b:	f3 0f 1e fa          	endbr64
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  803f1f:	48 89 f8             	mov    %rdi,%rax
  803f22:	48 c1 e8 27          	shr    $0x27,%rax
  803f26:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  803f2d:	7f 00 00 
  803f30:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  803f34:	f6 c2 01             	test   $0x1,%dl
  803f37:	74 6d                	je     803fa6 <get_uvpt_entry+0x8b>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  803f39:	48 89 f8             	mov    %rdi,%rax
  803f3c:	48 c1 e8 1e          	shr    $0x1e,%rax
  803f40:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  803f47:	7f 00 00 
  803f4a:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  803f4e:	f6 c2 01             	test   $0x1,%dl
  803f51:	74 62                	je     803fb5 <get_uvpt_entry+0x9a>
  803f53:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  803f5a:	7f 00 00 
  803f5d:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  803f61:	f6 c2 80             	test   $0x80,%dl
  803f64:	75 4f                	jne    803fb5 <get_uvpt_entry+0x9a>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  803f66:	48 89 f8             	mov    %rdi,%rax
  803f69:	48 c1 e8 15          	shr    $0x15,%rax
  803f6d:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  803f74:	7f 00 00 
  803f77:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  803f7b:	f6 c2 01             	test   $0x1,%dl
  803f7e:	74 44                	je     803fc4 <get_uvpt_entry+0xa9>
  803f80:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  803f87:	7f 00 00 
  803f8a:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  803f8e:	f6 c2 80             	test   $0x80,%dl
  803f91:	75 31                	jne    803fc4 <get_uvpt_entry+0xa9>
    return uvpt[VPT(va)];
  803f93:	48 c1 ef 0c          	shr    $0xc,%rdi
  803f97:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  803f9e:	7f 00 00 
  803fa1:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  803fa5:	c3                   	ret
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  803fa6:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  803fad:	7f 00 00 
  803fb0:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  803fb4:	c3                   	ret
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  803fb5:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  803fbc:	7f 00 00 
  803fbf:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  803fc3:	c3                   	ret
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  803fc4:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  803fcb:	7f 00 00 
  803fce:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  803fd2:	c3                   	ret

0000000000803fd3 <get_phys_addr>:

uintptr_t
get_phys_addr(void *va) {
  803fd3:	f3 0f 1e fa          	endbr64
  803fd7:	48 89 fa             	mov    %rdi,%rdx
    if (!(uvpml4[VPML4(va)] & PTE_P))
  803fda:	48 89 f9             	mov    %rdi,%rcx
  803fdd:	48 c1 e9 27          	shr    $0x27,%rcx
  803fe1:	48 b8 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rax
  803fe8:	7f 00 00 
  803feb:	48 8b 0c c8          	mov    (%rax,%rcx,8),%rcx
        return -1;
  803fef:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpml4[VPML4(va)] & PTE_P))
  803ff6:	f6 c1 01             	test   $0x1,%cl
  803ff9:	0f 84 b2 00 00 00    	je     8040b1 <get_phys_addr+0xde>
    if (!(uvpdp[VPDP(va)] & PTE_P))
  803fff:	48 89 f9             	mov    %rdi,%rcx
  804002:	48 c1 e9 1e          	shr    $0x1e,%rcx
  804006:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  80400d:	7f 00 00 
  804010:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  804014:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpdp[VPDP(va)] & PTE_P))
  80401b:	40 f6 c6 01          	test   $0x1,%sil
  80401f:	0f 84 8c 00 00 00    	je     8040b1 <get_phys_addr+0xde>
    if (uvpdp[VPDP(va)] & PTE_PS)
  804025:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  80402c:	7f 00 00 
  80402f:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  804033:	a8 80                	test   $0x80,%al
  804035:	75 7b                	jne    8040b2 <get_phys_addr+0xdf>
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
    if (!(uvpd[VPD(va)] & PTE_P))
  804037:	48 89 f9             	mov    %rdi,%rcx
  80403a:	48 c1 e9 15          	shr    $0x15,%rcx
  80403e:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  804045:	7f 00 00 
  804048:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  80404c:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpd[VPD(va)] & PTE_P))
  804053:	40 f6 c6 01          	test   $0x1,%sil
  804057:	74 58                	je     8040b1 <get_phys_addr+0xde>
    if ((uvpd[VPD(va)] & PTE_PS))
  804059:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  804060:	7f 00 00 
  804063:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  804067:	a8 80                	test   $0x80,%al
  804069:	75 6c                	jne    8040d7 <get_phys_addr+0x104>
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
    if (!(uvpt[VPT(va)] & PTE_P))
  80406b:	48 89 f9             	mov    %rdi,%rcx
  80406e:	48 c1 e9 0c          	shr    $0xc,%rcx
  804072:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  804079:	7f 00 00 
  80407c:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  804080:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpt[VPT(va)] & PTE_P))
  804087:	40 f6 c6 01          	test   $0x1,%sil
  80408b:	74 24                	je     8040b1 <get_phys_addr+0xde>
    return PTE_ADDR(uvpt[VPT(va)]) + PAGE_OFFSET(va);
  80408d:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  804094:	7f 00 00 
  804097:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  80409b:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  8040a2:	ff ff 7f 
  8040a5:	48 21 c8             	and    %rcx,%rax
  8040a8:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  8040ae:	48 09 d0             	or     %rdx,%rax
}
  8040b1:	c3                   	ret
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
  8040b2:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  8040b9:	7f 00 00 
  8040bc:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8040c0:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  8040c7:	ff ff 7f 
  8040ca:	48 21 c8             	and    %rcx,%rax
  8040cd:	81 e2 ff ff ff 3f    	and    $0x3fffffff,%edx
  8040d3:	48 01 d0             	add    %rdx,%rax
  8040d6:	c3                   	ret
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
  8040d7:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  8040de:	7f 00 00 
  8040e1:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8040e5:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  8040ec:	ff ff 7f 
  8040ef:	48 21 c8             	and    %rcx,%rax
  8040f2:	81 e2 ff ff 1f 00    	and    $0x1fffff,%edx
  8040f8:	48 01 d0             	add    %rdx,%rax
  8040fb:	c3                   	ret

00000000008040fc <get_prot>:

int
get_prot(void *va) {
  8040fc:	f3 0f 1e fa          	endbr64
  804100:	55                   	push   %rbp
  804101:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  804104:	48 b8 1b 3f 80 00 00 	movabs $0x803f1b,%rax
  80410b:	00 00 00 
  80410e:	ff d0                	call   *%rax
  804110:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
    if (pte & PTE_P) prot |= PROT_R;
  804113:	83 e0 01             	and    $0x1,%eax
  804116:	c1 e0 02             	shl    $0x2,%eax
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  804119:	89 d1                	mov    %edx,%ecx
  80411b:	81 e1 00 0a 00 00    	and    $0xa00,%ecx
    if (pte & PTE_P) prot |= PROT_R;
  804121:	09 c8                	or     %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  804123:	89 c1                	mov    %eax,%ecx
  804125:	83 c9 02             	or     $0x2,%ecx
  804128:	f6 c2 02             	test   $0x2,%dl
  80412b:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  80412e:	89 c1                	mov    %eax,%ecx
  804130:	83 c9 01             	or     $0x1,%ecx
  804133:	48 85 d2             	test   %rdx,%rdx
  804136:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  804139:	89 c1                	mov    %eax,%ecx
  80413b:	83 c9 40             	or     $0x40,%ecx
  80413e:	f6 c6 04             	test   $0x4,%dh
  804141:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  804144:	5d                   	pop    %rbp
  804145:	c3                   	ret

0000000000804146 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  804146:	f3 0f 1e fa          	endbr64
  80414a:	55                   	push   %rbp
  80414b:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  80414e:	48 b8 1b 3f 80 00 00 	movabs $0x803f1b,%rax
  804155:	00 00 00 
  804158:	ff d0                	call   *%rax
    return pte & PTE_D;
  80415a:	48 c1 e8 06          	shr    $0x6,%rax
  80415e:	83 e0 01             	and    $0x1,%eax
}
  804161:	5d                   	pop    %rbp
  804162:	c3                   	ret

0000000000804163 <is_page_present>:

bool
is_page_present(void *va) {
  804163:	f3 0f 1e fa          	endbr64
  804167:	55                   	push   %rbp
  804168:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  80416b:	48 b8 1b 3f 80 00 00 	movabs $0x803f1b,%rax
  804172:	00 00 00 
  804175:	ff d0                	call   *%rax
  804177:	83 e0 01             	and    $0x1,%eax
}
  80417a:	5d                   	pop    %rbp
  80417b:	c3                   	ret

000000000080417c <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  80417c:	f3 0f 1e fa          	endbr64
  804180:	55                   	push   %rbp
  804181:	48 89 e5             	mov    %rsp,%rbp
  804184:	41 57                	push   %r15
  804186:	41 56                	push   %r14
  804188:	41 55                	push   %r13
  80418a:	41 54                	push   %r12
  80418c:	53                   	push   %rbx
  80418d:	48 83 ec 18          	sub    $0x18,%rsp
  804191:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  804195:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
     * NOTE: Skip over larger pages/page directories for efficiency */
    // LAB 11: Your code here:

    int res = 0;
    (void)fun, (void)arg;
    uintptr_t va = 0;
  804199:	bb 00 00 00 00       	mov    $0x0,%ebx
    while (va < USER_STACK_TOP) {
        size_t size = 0;
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  80419e:	49 be 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%r14
  8041a5:	7f 00 00 
            size = 1LL << PML4_SHIFT;
            goto next;
        }

        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  8041a8:	49 bd 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%r13
  8041af:	7f 00 00 
    while (va < USER_STACK_TOP) {
  8041b2:	49 bf ff 6f ff ff 7f 	movabs $0x7fffff6fff,%r15
  8041b9:	00 00 00 
  8041bc:	eb 73                	jmp    804231 <foreach_shared_region+0xb5>
            }

            goto next;
        }

        if (!(uvpd[VPD(va)] & PTE_P)) {
  8041be:	48 89 d8             	mov    %rbx,%rax
  8041c1:	48 c1 e8 15          	shr    $0x15,%rax
  8041c5:	48 b9 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rcx
  8041cc:	7f 00 00 
  8041cf:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
            size = 1LL << PD_SHIFT;
  8041d3:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
        if (!(uvpd[VPD(va)] & PTE_P)) {
  8041d9:	f6 c2 01             	test   $0x1,%dl
  8041dc:	74 4b                	je     804229 <foreach_shared_region+0xad>
            goto next;
        }

        if (uvpd[VPD(va)] & PTE_PS) {
  8041de:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
  8041e2:	f6 c2 80             	test   $0x80,%dl
  8041e5:	74 11                	je     8041f8 <foreach_shared_region+0x7c>
            size = 1LL << PD_SHIFT;
            if (uvpd[VPD(va)] & PTE_SHARE) {
  8041e7:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
  8041eb:	f6 c4 04             	test   $0x4,%ah
  8041ee:	74 39                	je     804229 <foreach_shared_region+0xad>
            size = 1LL << PD_SHIFT;
  8041f0:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
  8041f6:	eb 20                	jmp    804218 <foreach_shared_region+0x9c>

            goto next;
        }

        size = PAGE_SIZE;
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  8041f8:	48 89 da             	mov    %rbx,%rdx
  8041fb:	48 c1 ea 0c          	shr    $0xc,%rdx
  8041ff:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  804206:	7f 00 00 
  804209:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
        size = PAGE_SIZE;
  80420d:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  804213:	f6 c4 04             	test   $0x4,%ah
  804216:	74 11                	je     804229 <foreach_shared_region+0xad>
            goto next;
        }

    map:
        fun((void *)va, (void *)(va + size), arg);
  804218:	49 8d 34 1c          	lea    (%r12,%rbx,1),%rsi
  80421c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  804220:	48 89 df             	mov    %rbx,%rdi
  804223:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804227:	ff d0                	call   *%rax
    next:
        va += size;
  804229:	4c 01 e3             	add    %r12,%rbx
    while (va < USER_STACK_TOP) {
  80422c:	49 39 df             	cmp    %rbx,%r15
  80422f:	72 3e                	jb     80426f <foreach_shared_region+0xf3>
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  804231:	49 8b 06             	mov    (%r14),%rax
  804234:	a8 01                	test   $0x1,%al
  804236:	74 37                	je     80426f <foreach_shared_region+0xf3>
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  804238:	48 89 d8             	mov    %rbx,%rax
  80423b:	48 c1 e8 1e          	shr    $0x1e,%rax
  80423f:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
            size = 1LL << PDP_SHIFT;
  804244:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  80424a:	f6 c2 01             	test   $0x1,%dl
  80424d:	74 da                	je     804229 <foreach_shared_region+0xad>
        if (uvpdp[VPDP(va)] & PTE_PS) {
  80424f:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
  804254:	f6 c2 80             	test   $0x80,%dl
  804257:	0f 84 61 ff ff ff    	je     8041be <foreach_shared_region+0x42>
            if (uvpdp[VPDP(va)] & PTE_SHARE) {
  80425d:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  804262:	f6 c4 04             	test   $0x4,%ah
  804265:	74 c2                	je     804229 <foreach_shared_region+0xad>
            size = 1LL << PDP_SHIFT;
  804267:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
  80426d:	eb a9                	jmp    804218 <foreach_shared_region+0x9c>
    }
    return res;
}
  80426f:	b8 00 00 00 00       	mov    $0x0,%eax
  804274:	48 83 c4 18          	add    $0x18,%rsp
  804278:	5b                   	pop    %rbx
  804279:	41 5c                	pop    %r12
  80427b:	41 5d                	pop    %r13
  80427d:	41 5e                	pop    %r14
  80427f:	41 5f                	pop    %r15
  804281:	5d                   	pop    %rbp
  804282:	c3                   	ret

0000000000804283 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
    # Call the C page fault handler.
    movq  %rsp,%rdi # passing the function argument in rdi
  804283:	48 89 e7             	mov    %rsp,%rdi
    movabs $_handle_vectored_pagefault, %rax
  804286:	48 b8 c2 44 80 00 00 	movabs $0x8044c2,%rax
  80428d:	00 00 00 
    call *%rax
  804290:	ff d0                	call   *%rax
    # registers are available for intermediate calculations.  You
    # may find that you have to rearrange your code in non-obvious
    # ways as registers become unavailable as scratch space.

    # LAB 9: Your code here
    movq %rsp, %rax
  804292:	48 89 e0             	mov    %rsp,%rax
    movq UTRAP_RIP(%rsp), %rbx
  804295:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  80429c:	00 
    movq UTRAP_RSP(%rsp), %rsp
  80429d:	48 8b a4 24 98 00 00 	mov    0x98(%rsp),%rsp
  8042a4:	00 
    pushq %rbx
  8042a5:	53                   	push   %rbx
    movq %rsp, UTRAP_RSP(%rax)
  8042a6:	48 89 a0 98 00 00 00 	mov    %rsp,0x98(%rax)

    # Restore the trap-time registers.  After you do this, you
    # can no longer modify any general-purpose registers (use POPA macro).
    # LAB 9: Your code here
    movq %rax, %rsp
  8042ad:	48 89 c4             	mov    %rax,%rsp
    addq $16, %rsp
  8042b0:	48 83 c4 10          	add    $0x10,%rsp
    POPA
  8042b4:	4c 8b 3c 24          	mov    (%rsp),%r15
  8042b8:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  8042bd:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  8042c2:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  8042c7:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  8042cc:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  8042d1:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  8042d6:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  8042db:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  8042e0:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  8042e5:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  8042ea:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  8042ef:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  8042f4:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  8042f9:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8042fe:	48 83 c4 78          	add    $0x78,%rsp
    addq $8, %rsp
  804302:	48 83 c4 08          	add    $0x8,%rsp
    # Restore rflags from the stack.  After you do this, you can
    # no longer use arithmetic operations or anything else that
    # modifies rflags.
    # LAB 9: Your code here
	popfq
  804306:	9d                   	popf
    # Switch back to the adjusted trap-time stack.
    # LAB 9: Your code here
	popq %rsp
  804307:	5c                   	pop    %rsp
    # Return to re-execute the instruction that faulted.
    ret
  804308:	c3                   	ret

0000000000804309 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  804309:	f3 0f 1e fa          	endbr64
  80430d:	55                   	push   %rbp
  80430e:	48 89 e5             	mov    %rsp,%rbp
  804311:	41 54                	push   %r12
  804313:	53                   	push   %rbx
  804314:	48 89 fb             	mov    %rdi,%rbx
  804317:	48 89 f7             	mov    %rsi,%rdi
  80431a:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  80431d:	48 85 f6             	test   %rsi,%rsi
  804320:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  804327:	00 00 00 
  80432a:	48 0f 44 f8          	cmove  %rax,%rdi
    }
    int res = sys_ipc_recv(pg, PAGE_SIZE);
  80432e:	be 00 10 00 00       	mov    $0x1000,%esi
  804333:	48 b8 d8 20 80 00 00 	movabs $0x8020d8,%rax
  80433a:	00 00 00 
  80433d:	ff d0                	call   *%rax
    if (res < 0) {
  80433f:	85 c0                	test   %eax,%eax
  804341:	78 45                	js     804388 <ipc_recv+0x7f>
        if (perm_store != NULL) {
            *perm_store = 0;
        }
        return res;
    } else {
        if (from_env_store != NULL) {
  804343:	48 85 db             	test   %rbx,%rbx
  804346:	74 12                	je     80435a <ipc_recv+0x51>
            *from_env_store = thisenv->env_ipc_from;
  804348:	48 a1 18 70 80 00 00 	movabs 0x807018,%rax
  80434f:	00 00 00 
  804352:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  804358:	89 03                	mov    %eax,(%rbx)
        }
        if (perm_store != NULL) {
  80435a:	4d 85 e4             	test   %r12,%r12
  80435d:	74 14                	je     804373 <ipc_recv+0x6a>
            *perm_store = thisenv->env_ipc_perm;
  80435f:	48 a1 18 70 80 00 00 	movabs 0x807018,%rax
  804366:	00 00 00 
  804369:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  80436f:	41 89 04 24          	mov    %eax,(%r12)
        }
        return thisenv->env_ipc_value;
  804373:	48 a1 18 70 80 00 00 	movabs 0x807018,%rax
  80437a:	00 00 00 
  80437d:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
    }
    return -1;
}
  804383:	5b                   	pop    %rbx
  804384:	41 5c                	pop    %r12
  804386:	5d                   	pop    %rbp
  804387:	c3                   	ret
        if (from_env_store != NULL) {
  804388:	48 85 db             	test   %rbx,%rbx
  80438b:	74 06                	je     804393 <ipc_recv+0x8a>
            *from_env_store = 0;
  80438d:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store != NULL) {
  804393:	4d 85 e4             	test   %r12,%r12
  804396:	74 eb                	je     804383 <ipc_recv+0x7a>
            *perm_store = 0;
  804398:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  80439f:	00 
  8043a0:	eb e1                	jmp    804383 <ipc_recv+0x7a>

00000000008043a2 <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  8043a2:	f3 0f 1e fa          	endbr64
  8043a6:	55                   	push   %rbp
  8043a7:	48 89 e5             	mov    %rsp,%rbp
  8043aa:	41 57                	push   %r15
  8043ac:	41 56                	push   %r14
  8043ae:	41 55                	push   %r13
  8043b0:	41 54                	push   %r12
  8043b2:	53                   	push   %rbx
  8043b3:	48 83 ec 18          	sub    $0x18,%rsp
  8043b7:	89 7d c4             	mov    %edi,-0x3c(%rbp)
  8043ba:	48 89 d3             	mov    %rdx,%rbx
  8043bd:	49 89 cc             	mov    %rcx,%r12
  8043c0:	45 89 c5             	mov    %r8d,%r13d
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  8043c3:	48 85 d2             	test   %rdx,%rdx
  8043c6:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  8043cd:	00 00 00 
  8043d0:	48 0f 44 d8          	cmove  %rax,%rbx
    }
    int res = sys_ipc_try_send(to_env, val, pg, size, perm);
  8043d4:	89 f0                	mov    %esi,%eax
  8043d6:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  8043da:	48 89 da             	mov    %rbx,%rdx
  8043dd:	48 89 c6             	mov    %rax,%rsi
  8043e0:	48 b8 a8 20 80 00 00 	movabs $0x8020a8,%rax
  8043e7:	00 00 00 
  8043ea:	ff d0                	call   *%rax
    while (res < 0) {
  8043ec:	85 c0                	test   %eax,%eax
  8043ee:	79 65                	jns    804455 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  8043f0:	83 f8 f5             	cmp    $0xfffffff5,%eax
  8043f3:	75 33                	jne    804428 <ipc_send+0x86>
            panic("Error: %i\n", res);
        }
        sys_yield();
  8043f5:	49 bf 1b 1d 80 00 00 	movabs $0x801d1b,%r15
  8043fc:	00 00 00 
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  8043ff:	49 be a8 20 80 00 00 	movabs $0x8020a8,%r14
  804406:	00 00 00 
        sys_yield();
  804409:	41 ff d7             	call   *%r15
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  80440c:	45 89 e8             	mov    %r13d,%r8d
  80440f:	4c 89 e1             	mov    %r12,%rcx
  804412:	48 89 da             	mov    %rbx,%rdx
  804415:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  804419:	8b 7d c4             	mov    -0x3c(%rbp),%edi
  80441c:	41 ff d6             	call   *%r14
    while (res < 0) {
  80441f:	85 c0                	test   %eax,%eax
  804421:	79 32                	jns    804455 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  804423:	83 f8 f5             	cmp    $0xfffffff5,%eax
  804426:	74 e1                	je     804409 <ipc_send+0x67>
            panic("Error: %i\n", res);
  804428:	89 c1                	mov    %eax,%ecx
  80442a:	48 ba ac 53 80 00 00 	movabs $0x8053ac,%rdx
  804431:	00 00 00 
  804434:	be 42 00 00 00       	mov    $0x42,%esi
  804439:	48 bf b7 53 80 00 00 	movabs $0x8053b7,%rdi
  804440:	00 00 00 
  804443:	b8 00 00 00 00       	mov    $0x0,%eax
  804448:	49 b8 be 0b 80 00 00 	movabs $0x800bbe,%r8
  80444f:	00 00 00 
  804452:	41 ff d0             	call   *%r8
    }
}
  804455:	48 83 c4 18          	add    $0x18,%rsp
  804459:	5b                   	pop    %rbx
  80445a:	41 5c                	pop    %r12
  80445c:	41 5d                	pop    %r13
  80445e:	41 5e                	pop    %r14
  804460:	41 5f                	pop    %r15
  804462:	5d                   	pop    %rbp
  804463:	c3                   	ret

0000000000804464 <ipc_find_env>:

/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
  804464:	f3 0f 1e fa          	endbr64
    for (size_t i = 0; i < NENV; i++)
  804468:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  80446d:	48 b9 00 00 a0 1f 80 	movabs $0x801fa00000,%rcx
  804474:	00 00 00 
  804477:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  80447b:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  80447f:	48 c1 e2 04          	shl    $0x4,%rdx
  804483:	48 01 ca             	add    %rcx,%rdx
  804486:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  80448c:	39 fa                	cmp    %edi,%edx
  80448e:	74 12                	je     8044a2 <ipc_find_env+0x3e>
    for (size_t i = 0; i < NENV; i++)
  804490:	48 83 c0 01          	add    $0x1,%rax
  804494:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  80449a:	75 db                	jne    804477 <ipc_find_env+0x13>
            return envs[i].env_id;
    return 0;
  80449c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8044a1:	c3                   	ret
            return envs[i].env_id;
  8044a2:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8044a6:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  8044aa:	48 c1 e2 04          	shl    $0x4,%rdx
  8044ae:	48 b8 00 00 a0 1f 80 	movabs $0x801fa00000,%rax
  8044b5:	00 00 00 
  8044b8:	48 01 d0             	add    %rdx,%rax
  8044bb:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8044c1:	c3                   	ret

00000000008044c2 <_handle_vectored_pagefault>:
/* Vector size */
static size_t _pfhandler_off = 0;
static bool _pfhandler_inititiallized = 0;

void
_handle_vectored_pagefault(struct UTrapframe *utf) {
  8044c2:	f3 0f 1e fa          	endbr64
  8044c6:	55                   	push   %rbp
  8044c7:	48 89 e5             	mov    %rsp,%rbp
  8044ca:	41 56                	push   %r14
  8044cc:	41 55                	push   %r13
  8044ce:	41 54                	push   %r12
  8044d0:	53                   	push   %rbx
  8044d1:	49 89 fc             	mov    %rdi,%r12
    /* This trying to handle pagefault until
     * some handler returns 1, that indicates
     * successfully handled exception */
    for (size_t i = 0; i < _pfhandler_off; i++)
  8044d4:	48 b8 68 90 80 00 00 	movabs $0x809068,%rax
  8044db:	00 00 00 
  8044de:	48 83 38 00          	cmpq   $0x0,(%rax)
  8044e2:	74 27                	je     80450b <_handle_vectored_pagefault+0x49>
  8044e4:	bb 00 00 00 00       	mov    $0x0,%ebx
        if (_pfhandler_vec[i](utf)) return;
  8044e9:	49 bd 20 90 80 00 00 	movabs $0x809020,%r13
  8044f0:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++)
  8044f3:	49 89 c6             	mov    %rax,%r14
        if (_pfhandler_vec[i](utf)) return;
  8044f6:	4c 89 e7             	mov    %r12,%rdi
  8044f9:	41 ff 54 dd 00       	call   *0x0(%r13,%rbx,8)
  8044fe:	84 c0                	test   %al,%al
  804500:	75 45                	jne    804547 <_handle_vectored_pagefault+0x85>
    for (size_t i = 0; i < _pfhandler_off; i++)
  804502:	48 83 c3 01          	add    $0x1,%rbx
  804506:	49 3b 1e             	cmp    (%r14),%rbx
  804509:	72 eb                	jb     8044f6 <_handle_vectored_pagefault+0x34>

    /* Unhandled exceptions just cause panic */
    panic("Userspace page fault rip=%08lX va=%08lX err=%x\n",
  80450b:	49 8b 8c 24 88 00 00 	mov    0x88(%r12),%rcx
  804512:	00 
  804513:	45 8b 4c 24 08       	mov    0x8(%r12),%r9d
  804518:	4d 8b 04 24          	mov    (%r12),%r8
  80451c:	48 ba b8 55 80 00 00 	movabs $0x8055b8,%rdx
  804523:	00 00 00 
  804526:	be 1d 00 00 00       	mov    $0x1d,%esi
  80452b:	48 bf c1 53 80 00 00 	movabs $0x8053c1,%rdi
  804532:	00 00 00 
  804535:	b8 00 00 00 00       	mov    $0x0,%eax
  80453a:	49 ba be 0b 80 00 00 	movabs $0x800bbe,%r10
  804541:	00 00 00 
  804544:	41 ff d2             	call   *%r10
          utf->utf_rip, utf->utf_fault_va, (int)utf->utf_err);
}
  804547:	5b                   	pop    %rbx
  804548:	41 5c                	pop    %r12
  80454a:	41 5d                	pop    %r13
  80454c:	41 5e                	pop    %r14
  80454e:	5d                   	pop    %rbp
  80454f:	c3                   	ret

0000000000804550 <add_pgfault_handler>:
 * The first time we register a handler, we need to
 * allocate an exception stack (one page of memory with its top
 * at USER_EXCEPTION_STACK_TOP), and tell the kernel to call the assembly-language
 * _pgfault_upcall routine when a page fault occurs. */
int
add_pgfault_handler(pf_handler_t handler) {
  804550:	f3 0f 1e fa          	endbr64
  804554:	55                   	push   %rbp
  804555:	48 89 e5             	mov    %rsp,%rbp
  804558:	53                   	push   %rbx
  804559:	48 83 ec 08          	sub    $0x8,%rsp
  80455d:	48 89 fb             	mov    %rdi,%rbx
    int res = 0;
    if (!_pfhandler_inititiallized) {
  804560:	48 b8 60 90 80 00 00 	movabs $0x809060,%rax
  804567:	00 00 00 
  80456a:	80 38 00             	cmpb   $0x0,(%rax)
  80456d:	0f 84 84 00 00 00    	je     8045f7 <add_pgfault_handler+0xa7>
        _pfhandler_vec[_pfhandler_off++] = handler;
        _pfhandler_inititiallized = 1;
        goto end;
    }

    for (size_t i = 0; i < _pfhandler_off; i++)
  804573:	48 b8 68 90 80 00 00 	movabs $0x809068,%rax
  80457a:	00 00 00 
  80457d:	48 8b 10             	mov    (%rax),%rdx
  804580:	b8 00 00 00 00       	mov    $0x0,%eax
        if (handler == _pfhandler_vec[i]) return 0;
  804585:	48 b9 20 90 80 00 00 	movabs $0x809020,%rcx
  80458c:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++)
  80458f:	48 85 d2             	test   %rdx,%rdx
  804592:	74 19                	je     8045ad <add_pgfault_handler+0x5d>
        if (handler == _pfhandler_vec[i]) return 0;
  804594:	48 39 1c c1          	cmp    %rbx,(%rcx,%rax,8)
  804598:	0f 84 e8 00 00 00    	je     804686 <add_pgfault_handler+0x136>
    for (size_t i = 0; i < _pfhandler_off; i++)
  80459e:	48 83 c0 01          	add    $0x1,%rax
  8045a2:	48 39 d0             	cmp    %rdx,%rax
  8045a5:	75 ed                	jne    804594 <add_pgfault_handler+0x44>

    if (_pfhandler_off == MAX_PFHANDLER)
  8045a7:	48 83 fa 08          	cmp    $0x8,%rdx
  8045ab:	74 1c                	je     8045c9 <add_pgfault_handler+0x79>
        res = -E_INVAL;
    else
        _pfhandler_vec[_pfhandler_off++] = handler;
  8045ad:	48 8d 42 01          	lea    0x1(%rdx),%rax
  8045b1:	48 a3 68 90 80 00 00 	movabs %rax,0x809068
  8045b8:	00 00 00 
  8045bb:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  8045c2:	00 00 00 
  8045c5:	48 89 1c d0          	mov    %rbx,(%rax,%rdx,8)

end:
    res = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  8045c9:	48 b8 e6 1c 80 00 00 	movabs $0x801ce6,%rax
  8045d0:	00 00 00 
  8045d3:	ff d0                	call   *%rax
  8045d5:	89 c7                	mov    %eax,%edi
  8045d7:	48 be 83 42 80 00 00 	movabs $0x804283,%rsi
  8045de:	00 00 00 
  8045e1:	48 b8 3b 20 80 00 00 	movabs $0x80203b,%rax
  8045e8:	00 00 00 
  8045eb:	ff d0                	call   *%rax
    if (res < 0) panic("set_pgfault_handler: %i", res);
  8045ed:	85 c0                	test   %eax,%eax
  8045ef:	78 68                	js     804659 <add_pgfault_handler+0x109>
    return res;
}
  8045f1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8045f5:	c9                   	leave
  8045f6:	c3                   	ret
        res = sys_alloc_region(sys_getenvid(), (void*)(USER_EXCEPTION_STACK_TOP - PAGE_SIZE), PAGE_SIZE, PROT_RW);
  8045f7:	48 b8 e6 1c 80 00 00 	movabs $0x801ce6,%rax
  8045fe:	00 00 00 
  804601:	ff d0                	call   *%rax
  804603:	89 c7                	mov    %eax,%edi
  804605:	b9 06 00 00 00       	mov    $0x6,%ecx
  80460a:	ba 00 10 00 00       	mov    $0x1000,%edx
  80460f:	48 be 00 f0 ff ff 7f 	movabs $0x7ffffff000,%rsi
  804616:	00 00 00 
  804619:	48 b8 b6 1d 80 00 00 	movabs $0x801db6,%rax
  804620:	00 00 00 
  804623:	ff d0                	call   *%rax
        _pfhandler_vec[_pfhandler_off++] = handler;
  804625:	48 ba 68 90 80 00 00 	movabs $0x809068,%rdx
  80462c:	00 00 00 
  80462f:	48 8b 02             	mov    (%rdx),%rax
  804632:	48 8d 48 01          	lea    0x1(%rax),%rcx
  804636:	48 89 0a             	mov    %rcx,(%rdx)
  804639:	48 ba 20 90 80 00 00 	movabs $0x809020,%rdx
  804640:	00 00 00 
  804643:	48 89 1c c2          	mov    %rbx,(%rdx,%rax,8)
        _pfhandler_inititiallized = 1;
  804647:	48 b8 60 90 80 00 00 	movabs $0x809060,%rax
  80464e:	00 00 00 
  804651:	c6 00 01             	movb   $0x1,(%rax)
        goto end;
  804654:	e9 70 ff ff ff       	jmp    8045c9 <add_pgfault_handler+0x79>
    if (res < 0) panic("set_pgfault_handler: %i", res);
  804659:	89 c1                	mov    %eax,%ecx
  80465b:	48 ba cf 53 80 00 00 	movabs $0x8053cf,%rdx
  804662:	00 00 00 
  804665:	be 3d 00 00 00       	mov    $0x3d,%esi
  80466a:	48 bf c1 53 80 00 00 	movabs $0x8053c1,%rdi
  804671:	00 00 00 
  804674:	b8 00 00 00 00       	mov    $0x0,%eax
  804679:	49 b8 be 0b 80 00 00 	movabs $0x800bbe,%r8
  804680:	00 00 00 
  804683:	41 ff d0             	call   *%r8
        if (handler == _pfhandler_vec[i]) return 0;
  804686:	b8 00 00 00 00       	mov    $0x0,%eax
  80468b:	e9 61 ff ff ff       	jmp    8045f1 <add_pgfault_handler+0xa1>

0000000000804690 <remove_pgfault_handler>:

void
remove_pgfault_handler(pf_handler_t handler) {
  804690:	f3 0f 1e fa          	endbr64
  804694:	55                   	push   %rbp
  804695:	48 89 e5             	mov    %rsp,%rbp
    assert(_pfhandler_inititiallized);
  804698:	48 b8 60 90 80 00 00 	movabs $0x809060,%rax
  80469f:	00 00 00 
  8046a2:	80 38 00             	cmpb   $0x0,(%rax)
  8046a5:	74 33                	je     8046da <remove_pgfault_handler+0x4a>
    for (size_t i = 0; i < _pfhandler_off; i++) {
  8046a7:	48 a1 68 90 80 00 00 	movabs 0x809068,%rax
  8046ae:	00 00 00 
  8046b1:	b9 00 00 00 00       	mov    $0x0,%ecx
        if (_pfhandler_vec[i] == handler) {
  8046b6:	48 ba 20 90 80 00 00 	movabs $0x809020,%rdx
  8046bd:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++) {
  8046c0:	48 85 c0             	test   %rax,%rax
  8046c3:	0f 84 85 00 00 00    	je     80474e <remove_pgfault_handler+0xbe>
        if (_pfhandler_vec[i] == handler) {
  8046c9:	48 39 3c ca          	cmp    %rdi,(%rdx,%rcx,8)
  8046cd:	74 40                	je     80470f <remove_pgfault_handler+0x7f>
    for (size_t i = 0; i < _pfhandler_off; i++) {
  8046cf:	48 83 c1 01          	add    $0x1,%rcx
  8046d3:	48 39 c1             	cmp    %rax,%rcx
  8046d6:	75 f1                	jne    8046c9 <remove_pgfault_handler+0x39>
  8046d8:	eb 74                	jmp    80474e <remove_pgfault_handler+0xbe>
    assert(_pfhandler_inititiallized);
  8046da:	48 b9 e7 53 80 00 00 	movabs $0x8053e7,%rcx
  8046e1:	00 00 00 
  8046e4:	48 ba a9 50 80 00 00 	movabs $0x8050a9,%rdx
  8046eb:	00 00 00 
  8046ee:	be 43 00 00 00       	mov    $0x43,%esi
  8046f3:	48 bf c1 53 80 00 00 	movabs $0x8053c1,%rdi
  8046fa:	00 00 00 
  8046fd:	b8 00 00 00 00       	mov    $0x0,%eax
  804702:	49 b8 be 0b 80 00 00 	movabs $0x800bbe,%r8
  804709:	00 00 00 
  80470c:	41 ff d0             	call   *%r8
            memmove(_pfhandler_vec + i, _pfhandler_vec + i + 1, (_pfhandler_off - i - 1) * sizeof(*handler));
  80470f:	48 8d 34 cd 08 00 00 	lea    0x8(,%rcx,8),%rsi
  804716:	00 
  804717:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80471b:	48 29 ca             	sub    %rcx,%rdx
  80471e:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  804725:	00 00 00 
  804728:	48 8d 0c 06          	lea    (%rsi,%rax,1),%rcx
  80472c:	48 8d 7c 30 f8       	lea    -0x8(%rax,%rsi,1),%rdi
  804731:	48 89 ce             	mov    %rcx,%rsi
  804734:	48 b8 7e 18 80 00 00 	movabs $0x80187e,%rax
  80473b:	00 00 00 
  80473e:	ff d0                	call   *%rax
            _pfhandler_off--;
  804740:	48 b8 68 90 80 00 00 	movabs $0x809068,%rax
  804747:	00 00 00 
  80474a:	48 83 28 01          	subq   $0x1,(%rax)
            return;
        }
    }
}
  80474e:	5d                   	pop    %rbp
  80474f:	c3                   	ret

0000000000804750 <__text_end>:
  804750:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804757:	00 00 00 
  80475a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804761:	00 00 00 
  804764:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80476b:	00 00 00 
  80476e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804775:	00 00 00 
  804778:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80477f:	00 00 00 
  804782:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804789:	00 00 00 
  80478c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804793:	00 00 00 
  804796:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80479d:	00 00 00 
  8047a0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8047a7:	00 00 00 
  8047aa:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8047b1:	00 00 00 
  8047b4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8047bb:	00 00 00 
  8047be:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8047c5:	00 00 00 
  8047c8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8047cf:	00 00 00 
  8047d2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8047d9:	00 00 00 
  8047dc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8047e3:	00 00 00 
  8047e6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8047ed:	00 00 00 
  8047f0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8047f7:	00 00 00 
  8047fa:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804801:	00 00 00 
  804804:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80480b:	00 00 00 
  80480e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804815:	00 00 00 
  804818:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80481f:	00 00 00 
  804822:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804829:	00 00 00 
  80482c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804833:	00 00 00 
  804836:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80483d:	00 00 00 
  804840:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804847:	00 00 00 
  80484a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804851:	00 00 00 
  804854:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80485b:	00 00 00 
  80485e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804865:	00 00 00 
  804868:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80486f:	00 00 00 
  804872:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804879:	00 00 00 
  80487c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804883:	00 00 00 
  804886:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80488d:	00 00 00 
  804890:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804897:	00 00 00 
  80489a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8048a1:	00 00 00 
  8048a4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8048ab:	00 00 00 
  8048ae:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8048b5:	00 00 00 
  8048b8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8048bf:	00 00 00 
  8048c2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8048c9:	00 00 00 
  8048cc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8048d3:	00 00 00 
  8048d6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8048dd:	00 00 00 
  8048e0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8048e7:	00 00 00 
  8048ea:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8048f1:	00 00 00 
  8048f4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8048fb:	00 00 00 
  8048fe:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804905:	00 00 00 
  804908:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80490f:	00 00 00 
  804912:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804919:	00 00 00 
  80491c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804923:	00 00 00 
  804926:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80492d:	00 00 00 
  804930:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804937:	00 00 00 
  80493a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804941:	00 00 00 
  804944:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80494b:	00 00 00 
  80494e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804955:	00 00 00 
  804958:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80495f:	00 00 00 
  804962:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804969:	00 00 00 
  80496c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804973:	00 00 00 
  804976:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80497d:	00 00 00 
  804980:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804987:	00 00 00 
  80498a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804991:	00 00 00 
  804994:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80499b:	00 00 00 
  80499e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8049a5:	00 00 00 
  8049a8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8049af:	00 00 00 
  8049b2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8049b9:	00 00 00 
  8049bc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8049c3:	00 00 00 
  8049c6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8049cd:	00 00 00 
  8049d0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8049d7:	00 00 00 
  8049da:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8049e1:	00 00 00 
  8049e4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8049eb:	00 00 00 
  8049ee:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8049f5:	00 00 00 
  8049f8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8049ff:	00 00 00 
  804a02:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804a09:	00 00 00 
  804a0c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804a13:	00 00 00 
  804a16:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804a1d:	00 00 00 
  804a20:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804a27:	00 00 00 
  804a2a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804a31:	00 00 00 
  804a34:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804a3b:	00 00 00 
  804a3e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804a45:	00 00 00 
  804a48:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804a4f:	00 00 00 
  804a52:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804a59:	00 00 00 
  804a5c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804a63:	00 00 00 
  804a66:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804a6d:	00 00 00 
  804a70:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804a77:	00 00 00 
  804a7a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804a81:	00 00 00 
  804a84:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804a8b:	00 00 00 
  804a8e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804a95:	00 00 00 
  804a98:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804a9f:	00 00 00 
  804aa2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804aa9:	00 00 00 
  804aac:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804ab3:	00 00 00 
  804ab6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804abd:	00 00 00 
  804ac0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804ac7:	00 00 00 
  804aca:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804ad1:	00 00 00 
  804ad4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804adb:	00 00 00 
  804ade:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804ae5:	00 00 00 
  804ae8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804aef:	00 00 00 
  804af2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804af9:	00 00 00 
  804afc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804b03:	00 00 00 
  804b06:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804b0d:	00 00 00 
  804b10:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804b17:	00 00 00 
  804b1a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804b21:	00 00 00 
  804b24:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804b2b:	00 00 00 
  804b2e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804b35:	00 00 00 
  804b38:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804b3f:	00 00 00 
  804b42:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804b49:	00 00 00 
  804b4c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804b53:	00 00 00 
  804b56:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804b5d:	00 00 00 
  804b60:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804b67:	00 00 00 
  804b6a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804b71:	00 00 00 
  804b74:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804b7b:	00 00 00 
  804b7e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804b85:	00 00 00 
  804b88:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804b8f:	00 00 00 
  804b92:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804b99:	00 00 00 
  804b9c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804ba3:	00 00 00 
  804ba6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804bad:	00 00 00 
  804bb0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804bb7:	00 00 00 
  804bba:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804bc1:	00 00 00 
  804bc4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804bcb:	00 00 00 
  804bce:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804bd5:	00 00 00 
  804bd8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804bdf:	00 00 00 
  804be2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804be9:	00 00 00 
  804bec:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804bf3:	00 00 00 
  804bf6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804bfd:	00 00 00 
  804c00:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804c07:	00 00 00 
  804c0a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804c11:	00 00 00 
  804c14:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804c1b:	00 00 00 
  804c1e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804c25:	00 00 00 
  804c28:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804c2f:	00 00 00 
  804c32:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804c39:	00 00 00 
  804c3c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804c43:	00 00 00 
  804c46:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804c4d:	00 00 00 
  804c50:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804c57:	00 00 00 
  804c5a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804c61:	00 00 00 
  804c64:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804c6b:	00 00 00 
  804c6e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804c75:	00 00 00 
  804c78:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804c7f:	00 00 00 
  804c82:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804c89:	00 00 00 
  804c8c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804c93:	00 00 00 
  804c96:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804c9d:	00 00 00 
  804ca0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804ca7:	00 00 00 
  804caa:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804cb1:	00 00 00 
  804cb4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804cbb:	00 00 00 
  804cbe:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804cc5:	00 00 00 
  804cc8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804ccf:	00 00 00 
  804cd2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804cd9:	00 00 00 
  804cdc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804ce3:	00 00 00 
  804ce6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804ced:	00 00 00 
  804cf0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804cf7:	00 00 00 
  804cfa:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804d01:	00 00 00 
  804d04:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804d0b:	00 00 00 
  804d0e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804d15:	00 00 00 
  804d18:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804d1f:	00 00 00 
  804d22:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804d29:	00 00 00 
  804d2c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804d33:	00 00 00 
  804d36:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804d3d:	00 00 00 
  804d40:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804d47:	00 00 00 
  804d4a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804d51:	00 00 00 
  804d54:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804d5b:	00 00 00 
  804d5e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804d65:	00 00 00 
  804d68:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804d6f:	00 00 00 
  804d72:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804d79:	00 00 00 
  804d7c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804d83:	00 00 00 
  804d86:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804d8d:	00 00 00 
  804d90:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804d97:	00 00 00 
  804d9a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804da1:	00 00 00 
  804da4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804dab:	00 00 00 
  804dae:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804db5:	00 00 00 
  804db8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804dbf:	00 00 00 
  804dc2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804dc9:	00 00 00 
  804dcc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804dd3:	00 00 00 
  804dd6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804ddd:	00 00 00 
  804de0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804de7:	00 00 00 
  804dea:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804df1:	00 00 00 
  804df4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804dfb:	00 00 00 
  804dfe:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804e05:	00 00 00 
  804e08:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804e0f:	00 00 00 
  804e12:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804e19:	00 00 00 
  804e1c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804e23:	00 00 00 
  804e26:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804e2d:	00 00 00 
  804e30:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804e37:	00 00 00 
  804e3a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804e41:	00 00 00 
  804e44:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804e4b:	00 00 00 
  804e4e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804e55:	00 00 00 
  804e58:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804e5f:	00 00 00 
  804e62:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804e69:	00 00 00 
  804e6c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804e73:	00 00 00 
  804e76:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804e7d:	00 00 00 
  804e80:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804e87:	00 00 00 
  804e8a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804e91:	00 00 00 
  804e94:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804e9b:	00 00 00 
  804e9e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804ea5:	00 00 00 
  804ea8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804eaf:	00 00 00 
  804eb2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804eb9:	00 00 00 
  804ebc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804ec3:	00 00 00 
  804ec6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804ecd:	00 00 00 
  804ed0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804ed7:	00 00 00 
  804eda:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804ee1:	00 00 00 
  804ee4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804eeb:	00 00 00 
  804eee:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804ef5:	00 00 00 
  804ef8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804eff:	00 00 00 
  804f02:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804f09:	00 00 00 
  804f0c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804f13:	00 00 00 
  804f16:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804f1d:	00 00 00 
  804f20:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804f27:	00 00 00 
  804f2a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804f31:	00 00 00 
  804f34:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804f3b:	00 00 00 
  804f3e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804f45:	00 00 00 
  804f48:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804f4f:	00 00 00 
  804f52:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804f59:	00 00 00 
  804f5c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804f63:	00 00 00 
  804f66:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804f6d:	00 00 00 
  804f70:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804f77:	00 00 00 
  804f7a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804f81:	00 00 00 
  804f84:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804f8b:	00 00 00 
  804f8e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804f95:	00 00 00 
  804f98:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804f9f:	00 00 00 
  804fa2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804fa9:	00 00 00 
  804fac:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804fb3:	00 00 00 
  804fb6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804fbd:	00 00 00 
  804fc0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804fc7:	00 00 00 
  804fca:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804fd1:	00 00 00 
  804fd4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804fdb:	00 00 00 
  804fde:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804fe5:	00 00 00 
  804fe8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804fef:	00 00 00 
  804ff2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  804ff9:	00 00 00 
  804ffc:	0f 1f 40 00          	nopl   0x0(%rax)
