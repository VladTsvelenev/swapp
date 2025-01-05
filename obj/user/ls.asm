
obj/user/ls:     file format elf64-x86-64


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
  80001e:	e8 2b 04 00 00       	call   80044e <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <ls1>:
    if (n < 0)
        panic("error reading directory %s: %i", path, n);
}

void
ls1(const char *prefix, bool isdir, off_t size, const char *name) {
  800025:	f3 0f 1e fa          	endbr64
  800029:	55                   	push   %rbp
  80002a:	48 89 e5             	mov    %rsp,%rbp
  80002d:	41 55                	push   %r13
  80002f:	41 54                	push   %r12
  800031:	53                   	push   %rbx
  800032:	48 83 ec 08          	sub    $0x8,%rsp
  800036:	48 89 fb             	mov    %rdi,%rbx
  800039:	41 89 f4             	mov    %esi,%r12d
  80003c:	49 89 cd             	mov    %rcx,%r13
    const char *sep;

    if (flag['l'])
  80003f:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800046:	00 00 00 
  800049:	83 b8 b0 01 00 00 00 	cmpl   $0x0,0x1b0(%rax)
  800050:	74 29                	je     80007b <ls1+0x56>
  800052:	89 d6                	mov    %edx,%esi
        printf("%11d %c ", size, isdir ? 'd' : '-');
  800054:	41 80 fc 01          	cmp    $0x1,%r12b
  800058:	19 d2                	sbb    %edx,%edx
  80005a:	83 e2 c9             	and    $0xffffffc9,%edx
  80005d:	83 c2 64             	add    $0x64,%edx
  800060:	48 bf 02 40 80 00 00 	movabs $0x804002,%rdi
  800067:	00 00 00 
  80006a:	b8 00 00 00 00       	mov    $0x0,%eax
  80006f:	48 b9 31 27 80 00 00 	movabs $0x802731,%rcx
  800076:	00 00 00 
  800079:	ff d1                	call   *%rcx
    if (prefix) {
  80007b:	48 85 db             	test   %rbx,%rbx
  80007e:	74 2d                	je     8000ad <ls1+0x88>
        if (prefix[0] && prefix[strlen(prefix) - 1] != '/')
            sep = "/";
        else
            sep = "";
  800080:	48 ba 68 40 80 00 00 	movabs $0x804068,%rdx
  800087:	00 00 00 
        if (prefix[0] && prefix[strlen(prefix) - 1] != '/')
  80008a:	80 3b 00             	cmpb   $0x0,(%rbx)
  80008d:	75 7a                	jne    800109 <ls1+0xe4>
        printf("%s%s", prefix, sep);
  80008f:	48 89 de             	mov    %rbx,%rsi
  800092:	48 bf 0b 40 80 00 00 	movabs $0x80400b,%rdi
  800099:	00 00 00 
  80009c:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a1:	48 b9 31 27 80 00 00 	movabs $0x802731,%rcx
  8000a8:	00 00 00 
  8000ab:	ff d1                	call   *%rcx
    }
    printf("%s", name);
  8000ad:	4c 89 ee             	mov    %r13,%rsi
  8000b0:	48 bf 78 42 80 00 00 	movabs $0x804278,%rdi
  8000b7:	00 00 00 
  8000ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8000bf:	48 ba 31 27 80 00 00 	movabs $0x802731,%rdx
  8000c6:	00 00 00 
  8000c9:	ff d2                	call   *%rdx
    if (flag['F'] && isdir)
  8000cb:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8000d2:	00 00 00 
  8000d5:	83 b8 18 01 00 00 00 	cmpl   $0x0,0x118(%rax)
  8000dc:	74 05                	je     8000e3 <ls1+0xbe>
  8000de:	45 84 e4             	test   %r12b,%r12b
  8000e1:	75 57                	jne    80013a <ls1+0x115>
        printf("/");
    printf("\n");
  8000e3:	48 bf 67 40 80 00 00 	movabs $0x804067,%rdi
  8000ea:	00 00 00 
  8000ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f2:	48 ba 31 27 80 00 00 	movabs $0x802731,%rdx
  8000f9:	00 00 00 
  8000fc:	ff d2                	call   *%rdx
}
  8000fe:	48 83 c4 08          	add    $0x8,%rsp
  800102:	5b                   	pop    %rbx
  800103:	41 5c                	pop    %r12
  800105:	41 5d                	pop    %r13
  800107:	5d                   	pop    %rbp
  800108:	c3                   	ret
        if (prefix[0] && prefix[strlen(prefix) - 1] != '/')
  800109:	48 89 df             	mov    %rbx,%rdi
  80010c:	48 b8 87 0f 80 00 00 	movabs $0x800f87,%rax
  800113:	00 00 00 
  800116:	ff d0                	call   *%rax
            sep = "/";
  800118:	80 7c 03 ff 2f       	cmpb   $0x2f,-0x1(%rbx,%rax,1)
  80011d:	48 ba 68 40 80 00 00 	movabs $0x804068,%rdx
  800124:	00 00 00 
  800127:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  80012e:	00 00 00 
  800131:	48 0f 45 d0          	cmovne %rax,%rdx
  800135:	e9 55 ff ff ff       	jmp    80008f <ls1+0x6a>
        printf("/");
  80013a:	48 bf 00 40 80 00 00 	movabs $0x804000,%rdi
  800141:	00 00 00 
  800144:	b8 00 00 00 00       	mov    $0x0,%eax
  800149:	48 ba 31 27 80 00 00 	movabs $0x802731,%rdx
  800150:	00 00 00 
  800153:	ff d2                	call   *%rdx
  800155:	eb 8c                	jmp    8000e3 <ls1+0xbe>

0000000000800157 <lsdir>:
lsdir(const char *path, const char *prefix) {
  800157:	f3 0f 1e fa          	endbr64
  80015b:	55                   	push   %rbp
  80015c:	48 89 e5             	mov    %rsp,%rbp
  80015f:	41 56                	push   %r14
  800161:	41 55                	push   %r13
  800163:	41 54                	push   %r12
  800165:	53                   	push   %rbx
  800166:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80016d:	49 89 fd             	mov    %rdi,%r13
  800170:	49 89 f6             	mov    %rsi,%r14
    if ((fd = open(path, O_RDONLY)) < 0)
  800173:	be 00 00 00 00       	mov    $0x0,%esi
  800178:	48 b8 ea 24 80 00 00 	movabs $0x8024ea,%rax
  80017f:	00 00 00 
  800182:	ff d0                	call   *%rax
  800184:	89 c3                	mov    %eax,%ebx
  800186:	85 c0                	test   %eax,%eax
  800188:	78 58                	js     8001e2 <lsdir+0x8b>
    while ((n = readn(fd, &f, sizeof f)) == sizeof f)
  80018a:	49 bc 76 1f 80 00 00 	movabs $0x801f76,%r12
  800191:	00 00 00 
  800194:	ba 00 01 00 00       	mov    $0x100,%edx
  800199:	48 8d b5 e0 fe ff ff 	lea    -0x120(%rbp),%rsi
  8001a0:	89 df                	mov    %ebx,%edi
  8001a2:	41 ff d4             	call   *%r12
  8001a5:	3d 00 01 00 00       	cmp    $0x100,%eax
  8001aa:	75 67                	jne    800213 <lsdir+0xbc>
        if (f.f_name[0])
  8001ac:	80 bd e0 fe ff ff 00 	cmpb   $0x0,-0x120(%rbp)
  8001b3:	74 df                	je     800194 <lsdir+0x3d>
            ls1(prefix, f.f_type == FTYPE_DIR, f.f_size, f.f_name);
  8001b5:	83 bd 64 ff ff ff 01 	cmpl   $0x1,-0x9c(%rbp)
  8001bc:	40 0f 94 c6          	sete   %sil
  8001c0:	40 0f b6 f6          	movzbl %sil,%esi
  8001c4:	48 8d 8d e0 fe ff ff 	lea    -0x120(%rbp),%rcx
  8001cb:	8b 95 60 ff ff ff    	mov    -0xa0(%rbp),%edx
  8001d1:	4c 89 f7             	mov    %r14,%rdi
  8001d4:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  8001db:	00 00 00 
  8001de:	ff d0                	call   *%rax
  8001e0:	eb b2                	jmp    800194 <lsdir+0x3d>
        panic("open %s: %i", path, fd);
  8001e2:	41 89 c0             	mov    %eax,%r8d
  8001e5:	4c 89 e9             	mov    %r13,%rcx
  8001e8:	48 ba 10 40 80 00 00 	movabs $0x804010,%rdx
  8001ef:	00 00 00 
  8001f2:	be 1b 00 00 00       	mov    $0x1b,%esi
  8001f7:	48 bf 1c 40 80 00 00 	movabs $0x80401c,%rdi
  8001fe:	00 00 00 
  800201:	b8 00 00 00 00       	mov    $0x0,%eax
  800206:	49 b9 27 05 80 00 00 	movabs $0x800527,%r9
  80020d:	00 00 00 
  800210:	41 ff d1             	call   *%r9
    if (n > 0)
  800213:	85 c0                	test   %eax,%eax
  800215:	7f 12                	jg     800229 <lsdir+0xd2>
    if (n < 0)
  800217:	78 3e                	js     800257 <lsdir+0x100>
}
  800219:	48 81 c4 00 01 00 00 	add    $0x100,%rsp
  800220:	5b                   	pop    %rbx
  800221:	41 5c                	pop    %r12
  800223:	41 5d                	pop    %r13
  800225:	41 5e                	pop    %r14
  800227:	5d                   	pop    %rbp
  800228:	c3                   	ret
        panic("short read in directory %s", path);
  800229:	4c 89 e9             	mov    %r13,%rcx
  80022c:	48 ba 26 40 80 00 00 	movabs $0x804026,%rdx
  800233:	00 00 00 
  800236:	be 20 00 00 00       	mov    $0x20,%esi
  80023b:	48 bf 1c 40 80 00 00 	movabs $0x80401c,%rdi
  800242:	00 00 00 
  800245:	b8 00 00 00 00       	mov    $0x0,%eax
  80024a:	49 b8 27 05 80 00 00 	movabs $0x800527,%r8
  800251:	00 00 00 
  800254:	41 ff d0             	call   *%r8
        panic("error reading directory %s: %i", path, n);
  800257:	41 89 c0             	mov    %eax,%r8d
  80025a:	4c 89 e9             	mov    %r13,%rcx
  80025d:	48 ba c0 42 80 00 00 	movabs $0x8042c0,%rdx
  800264:	00 00 00 
  800267:	be 22 00 00 00       	mov    $0x22,%esi
  80026c:	48 bf 1c 40 80 00 00 	movabs $0x80401c,%rdi
  800273:	00 00 00 
  800276:	b8 00 00 00 00       	mov    $0x0,%eax
  80027b:	49 b9 27 05 80 00 00 	movabs $0x800527,%r9
  800282:	00 00 00 
  800285:	41 ff d1             	call   *%r9

0000000000800288 <ls>:
ls(const char *path, const char *prefix) {
  800288:	f3 0f 1e fa          	endbr64
  80028c:	55                   	push   %rbp
  80028d:	48 89 e5             	mov    %rsp,%rbp
  800290:	41 54                	push   %r12
  800292:	53                   	push   %rbx
  800293:	48 81 ec 90 00 00 00 	sub    $0x90,%rsp
  80029a:	48 89 fb             	mov    %rdi,%rbx
  80029d:	49 89 f4             	mov    %rsi,%r12
    if ((r = stat(path, &st)) < 0)
  8002a0:	48 8d b5 60 ff ff ff 	lea    -0xa0(%rbp),%rsi
  8002a7:	48 b8 09 22 80 00 00 	movabs $0x802209,%rax
  8002ae:	00 00 00 
  8002b1:	ff d0                	call   *%rax
  8002b3:	85 c0                	test   %eax,%eax
  8002b5:	78 47                	js     8002fe <ls+0x76>
    if (st.st_isdir && !flag['d'])
  8002b7:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8002ba:	85 c0                	test   %eax,%eax
  8002bc:	74 13                	je     8002d1 <ls+0x49>
  8002be:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  8002c5:	00 00 00 
  8002c8:	83 ba 90 01 00 00 00 	cmpl   $0x0,0x190(%rdx)
  8002cf:	74 5e                	je     80032f <ls+0xa7>
        ls1(0, st.st_isdir, st.st_size, path);
  8002d1:	85 c0                	test   %eax,%eax
  8002d3:	40 0f 95 c6          	setne  %sil
  8002d7:	40 0f b6 f6          	movzbl %sil,%esi
  8002db:	48 89 d9             	mov    %rbx,%rcx
  8002de:	8b 55 e0             	mov    -0x20(%rbp),%edx
  8002e1:	bf 00 00 00 00       	mov    $0x0,%edi
  8002e6:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  8002ed:	00 00 00 
  8002f0:	ff d0                	call   *%rax
}
  8002f2:	48 81 c4 90 00 00 00 	add    $0x90,%rsp
  8002f9:	5b                   	pop    %rbx
  8002fa:	41 5c                	pop    %r12
  8002fc:	5d                   	pop    %rbp
  8002fd:	c3                   	ret
        panic("stat %s: %i", path, r);
  8002fe:	41 89 c0             	mov    %eax,%r8d
  800301:	48 89 d9             	mov    %rbx,%rcx
  800304:	48 ba 41 40 80 00 00 	movabs $0x804041,%rdx
  80030b:	00 00 00 
  80030e:	be 0e 00 00 00       	mov    $0xe,%esi
  800313:	48 bf 1c 40 80 00 00 	movabs $0x80401c,%rdi
  80031a:	00 00 00 
  80031d:	b8 00 00 00 00       	mov    $0x0,%eax
  800322:	49 b9 27 05 80 00 00 	movabs $0x800527,%r9
  800329:	00 00 00 
  80032c:	41 ff d1             	call   *%r9
        lsdir(path, prefix);
  80032f:	4c 89 e6             	mov    %r12,%rsi
  800332:	48 89 df             	mov    %rbx,%rdi
  800335:	48 b8 57 01 80 00 00 	movabs $0x800157,%rax
  80033c:	00 00 00 
  80033f:	ff d0                	call   *%rax
  800341:	eb af                	jmp    8002f2 <ls+0x6a>

0000000000800343 <usage>:

void
usage(void) {
  800343:	f3 0f 1e fa          	endbr64
  800347:	55                   	push   %rbp
  800348:	48 89 e5             	mov    %rsp,%rbp
    printf("usage: ls [-dFl] [file...]\n");
  80034b:	48 bf 4d 40 80 00 00 	movabs $0x80404d,%rdi
  800352:	00 00 00 
  800355:	b8 00 00 00 00       	mov    $0x0,%eax
  80035a:	48 ba 31 27 80 00 00 	movabs $0x802731,%rdx
  800361:	00 00 00 
  800364:	ff d2                	call   *%rdx
    exit();
  800366:	48 b8 00 05 80 00 00 	movabs $0x800500,%rax
  80036d:	00 00 00 
  800370:	ff d0                	call   *%rax
}
  800372:	5d                   	pop    %rbp
  800373:	c3                   	ret

0000000000800374 <umain>:

void
umain(int argc, char **argv) {
  800374:	f3 0f 1e fa          	endbr64
  800378:	55                   	push   %rbp
  800379:	48 89 e5             	mov    %rsp,%rbp
  80037c:	41 57                	push   %r15
  80037e:	41 56                	push   %r14
  800380:	41 55                	push   %r13
  800382:	41 54                	push   %r12
  800384:	53                   	push   %rbx
  800385:	48 83 ec 38          	sub    $0x38,%rsp
  800389:	89 7d ac             	mov    %edi,-0x54(%rbp)
  80038c:	49 89 f4             	mov    %rsi,%r12
    int i;
    struct Argstate args;

    argstart(&argc, argv, &args);
  80038f:	48 8d 55 b0          	lea    -0x50(%rbp),%rdx
  800393:	48 8d 7d ac          	lea    -0x54(%rbp),%rdi
  800397:	48 b8 95 19 80 00 00 	movabs $0x801995,%rax
  80039e:	00 00 00 
  8003a1:	ff d0                	call   *%rax
    while ((i = argnext(&args)) >= 0)
  8003a3:	49 bd c6 19 80 00 00 	movabs $0x8019c6,%r13
  8003aa:	00 00 00 
        case 'F':
        case 'l':
            flag[i]++;
            break;
        default:
            usage();
  8003ad:	49 bf 43 03 80 00 00 	movabs $0x800343,%r15
  8003b4:	00 00 00 
        switch (i) {
  8003b7:	49 be 01 00 00 40 40 	movabs $0x4040000001,%r14
  8003be:	00 00 00 
            flag[i]++;
  8003c1:	48 bb 00 60 80 00 00 	movabs $0x806000,%rbx
  8003c8:	00 00 00 
    while ((i = argnext(&args)) >= 0)
  8003cb:	eb 06                	jmp    8003d3 <umain+0x5f>
            flag[i]++;
  8003cd:	48 98                	cltq
  8003cf:	83 04 83 01          	addl   $0x1,(%rbx,%rax,4)
    while ((i = argnext(&args)) >= 0)
  8003d3:	48 8d 7d b0          	lea    -0x50(%rbp),%rdi
  8003d7:	41 ff d5             	call   *%r13
  8003da:	85 c0                	test   %eax,%eax
  8003dc:	78 13                	js     8003f1 <umain+0x7d>
        switch (i) {
  8003de:	8d 50 ba             	lea    -0x46(%rax),%edx
  8003e1:	83 fa 26             	cmp    $0x26,%edx
  8003e4:	77 06                	ja     8003ec <umain+0x78>
  8003e6:	49 0f a3 d6          	bt     %rdx,%r14
  8003ea:	72 e1                	jb     8003cd <umain+0x59>
            usage();
  8003ec:	41 ff d7             	call   *%r15
  8003ef:	eb e2                	jmp    8003d3 <umain+0x5f>
        }

    if (argc == 1)
  8003f1:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8003f4:	83 f8 01             	cmp    $0x1,%eax
  8003f7:	74 33                	je     80042c <umain+0xb8>
        ls("/", "");
    else {
        for (i = 1; i < argc; i++)
  8003f9:	bb 01 00 00 00       	mov    $0x1,%ebx
            ls(argv[i], argv[i]);
  8003fe:	49 bd 88 02 80 00 00 	movabs $0x800288,%r13
  800405:	00 00 00 
        for (i = 1; i < argc; i++)
  800408:	7e 13                	jle    80041d <umain+0xa9>
            ls(argv[i], argv[i]);
  80040a:	49 8b 3c dc          	mov    (%r12,%rbx,8),%rdi
  80040e:	48 89 fe             	mov    %rdi,%rsi
  800411:	41 ff d5             	call   *%r13
        for (i = 1; i < argc; i++)
  800414:	48 83 c3 01          	add    $0x1,%rbx
  800418:	39 5d ac             	cmp    %ebx,-0x54(%rbp)
  80041b:	7f ed                	jg     80040a <umain+0x96>
    }
}
  80041d:	48 83 c4 38          	add    $0x38,%rsp
  800421:	5b                   	pop    %rbx
  800422:	41 5c                	pop    %r12
  800424:	41 5d                	pop    %r13
  800426:	41 5e                	pop    %r14
  800428:	41 5f                	pop    %r15
  80042a:	5d                   	pop    %rbp
  80042b:	c3                   	ret
        ls("/", "");
  80042c:	48 be 68 40 80 00 00 	movabs $0x804068,%rsi
  800433:	00 00 00 
  800436:	48 bf 00 40 80 00 00 	movabs $0x804000,%rdi
  80043d:	00 00 00 
  800440:	48 b8 88 02 80 00 00 	movabs $0x800288,%rax
  800447:	00 00 00 
  80044a:	ff d0                	call   *%rax
  80044c:	eb cf                	jmp    80041d <umain+0xa9>

000000000080044e <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  80044e:	f3 0f 1e fa          	endbr64
  800452:	55                   	push   %rbp
  800453:	48 89 e5             	mov    %rsp,%rbp
  800456:	41 56                	push   %r14
  800458:	41 55                	push   %r13
  80045a:	41 54                	push   %r12
  80045c:	53                   	push   %rbx
  80045d:	41 89 fd             	mov    %edi,%r13d
  800460:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
     * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  800463:	48 ba d8 50 80 00 00 	movabs $0x8050d8,%rdx
  80046a:	00 00 00 
  80046d:	48 b8 d8 50 80 00 00 	movabs $0x8050d8,%rax
  800474:	00 00 00 
  800477:	48 39 c2             	cmp    %rax,%rdx
  80047a:	73 17                	jae    800493 <libmain+0x45>
    void (**ctor)() = &__ctors_start;
  80047c:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  80047f:	49 89 c4             	mov    %rax,%r12
  800482:	48 83 c3 08          	add    $0x8,%rbx
  800486:	b8 00 00 00 00       	mov    $0x0,%eax
  80048b:	ff 53 f8             	call   *-0x8(%rbx)
  80048e:	4c 39 e3             	cmp    %r12,%rbx
  800491:	72 ef                	jb     800482 <libmain+0x34>

    /* Set thisenv to point at our Env structure in envs[]. */

    // LAB 8: Your code here
    thisenv = &((struct Env *)UENVS)[ENVX(sys_getenvid())];
  800493:	48 b8 01 15 80 00 00 	movabs $0x801501,%rax
  80049a:	00 00 00 
  80049d:	ff d0                	call   *%rax
  80049f:	25 ff 03 00 00       	and    $0x3ff,%eax
  8004a4:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8004a8:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8004ac:	48 c1 e0 04          	shl    $0x4,%rax
  8004b0:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  8004b7:	00 00 00 
  8004ba:	48 01 d0             	add    %rdx,%rax
  8004bd:	48 a3 00 64 80 00 00 	movabs %rax,0x806400
  8004c4:	00 00 00 

    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  8004c7:	45 85 ed             	test   %r13d,%r13d
  8004ca:	7e 0d                	jle    8004d9 <libmain+0x8b>
  8004cc:	49 8b 06             	mov    (%r14),%rax
  8004cf:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  8004d6:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  8004d9:	4c 89 f6             	mov    %r14,%rsi
  8004dc:	44 89 ef             	mov    %r13d,%edi
  8004df:	48 b8 74 03 80 00 00 	movabs $0x800374,%rax
  8004e6:	00 00 00 
  8004e9:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  8004eb:	48 b8 00 05 80 00 00 	movabs $0x800500,%rax
  8004f2:	00 00 00 
  8004f5:	ff d0                	call   *%rax
#endif
}
  8004f7:	5b                   	pop    %rbx
  8004f8:	41 5c                	pop    %r12
  8004fa:	41 5d                	pop    %r13
  8004fc:	41 5e                	pop    %r14
  8004fe:	5d                   	pop    %rbp
  8004ff:	c3                   	ret

0000000000800500 <exit>:

#include <inc/lib.h>

void
exit(void) {
  800500:	f3 0f 1e fa          	endbr64
  800504:	55                   	push   %rbp
  800505:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  800508:	48 b8 61 1d 80 00 00 	movabs $0x801d61,%rax
  80050f:	00 00 00 
  800512:	ff d0                	call   *%rax
    sys_env_destroy(0);
  800514:	bf 00 00 00 00       	mov    $0x0,%edi
  800519:	48 b8 92 14 80 00 00 	movabs $0x801492,%rax
  800520:	00 00 00 
  800523:	ff d0                	call   *%rax
}
  800525:	5d                   	pop    %rbp
  800526:	c3                   	ret

0000000000800527 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  800527:	f3 0f 1e fa          	endbr64
  80052b:	55                   	push   %rbp
  80052c:	48 89 e5             	mov    %rsp,%rbp
  80052f:	41 56                	push   %r14
  800531:	41 55                	push   %r13
  800533:	41 54                	push   %r12
  800535:	53                   	push   %rbx
  800536:	48 83 ec 50          	sub    $0x50,%rsp
  80053a:	49 89 fc             	mov    %rdi,%r12
  80053d:	41 89 f5             	mov    %esi,%r13d
  800540:	48 89 d3             	mov    %rdx,%rbx
  800543:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800547:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  80054b:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  80054f:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  800556:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80055a:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  80055e:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  800562:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  800566:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  80056d:	00 00 00 
  800570:	4c 8b 30             	mov    (%rax),%r14
  800573:	48 b8 01 15 80 00 00 	movabs $0x801501,%rax
  80057a:	00 00 00 
  80057d:	ff d0                	call   *%rax
  80057f:	89 c6                	mov    %eax,%esi
  800581:	45 89 e8             	mov    %r13d,%r8d
  800584:	4c 89 e1             	mov    %r12,%rcx
  800587:	4c 89 f2             	mov    %r14,%rdx
  80058a:	48 bf e0 42 80 00 00 	movabs $0x8042e0,%rdi
  800591:	00 00 00 
  800594:	b8 00 00 00 00       	mov    $0x0,%eax
  800599:	49 bc 83 06 80 00 00 	movabs $0x800683,%r12
  8005a0:	00 00 00 
  8005a3:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  8005a6:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  8005aa:	48 89 df             	mov    %rbx,%rdi
  8005ad:	48 b8 1b 06 80 00 00 	movabs $0x80061b,%rax
  8005b4:	00 00 00 
  8005b7:	ff d0                	call   *%rax
    cprintf("\n");
  8005b9:	48 bf 67 40 80 00 00 	movabs $0x804067,%rdi
  8005c0:	00 00 00 
  8005c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8005c8:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  8005cb:	cc                   	int3
  8005cc:	eb fd                	jmp    8005cb <_panic+0xa4>

00000000008005ce <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  8005ce:	f3 0f 1e fa          	endbr64
  8005d2:	55                   	push   %rbp
  8005d3:	48 89 e5             	mov    %rsp,%rbp
  8005d6:	53                   	push   %rbx
  8005d7:	48 83 ec 08          	sub    $0x8,%rsp
  8005db:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  8005de:	8b 06                	mov    (%rsi),%eax
  8005e0:	8d 50 01             	lea    0x1(%rax),%edx
  8005e3:	89 16                	mov    %edx,(%rsi)
  8005e5:	48 98                	cltq
  8005e7:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  8005ec:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  8005f2:	74 0a                	je     8005fe <putch+0x30>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  8005f4:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  8005f8:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8005fc:	c9                   	leave
  8005fd:	c3                   	ret
        sys_cputs(state->buf, state->offset);
  8005fe:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  800602:	be ff 00 00 00       	mov    $0xff,%esi
  800607:	48 b8 2c 14 80 00 00 	movabs $0x80142c,%rax
  80060e:	00 00 00 
  800611:	ff d0                	call   *%rax
        state->offset = 0;
  800613:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  800619:	eb d9                	jmp    8005f4 <putch+0x26>

000000000080061b <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  80061b:	f3 0f 1e fa          	endbr64
  80061f:	55                   	push   %rbp
  800620:	48 89 e5             	mov    %rsp,%rbp
  800623:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80062a:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  80062d:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  800634:	b9 21 00 00 00       	mov    $0x21,%ecx
  800639:	b8 00 00 00 00       	mov    $0x0,%eax
  80063e:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  800641:	48 89 f1             	mov    %rsi,%rcx
  800644:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  80064b:	48 bf ce 05 80 00 00 	movabs $0x8005ce,%rdi
  800652:	00 00 00 
  800655:	48 b8 e3 07 80 00 00 	movabs $0x8007e3,%rax
  80065c:	00 00 00 
  80065f:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  800661:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  800668:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  80066f:	48 b8 2c 14 80 00 00 	movabs $0x80142c,%rax
  800676:	00 00 00 
  800679:	ff d0                	call   *%rax

    return state.count;
}
  80067b:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  800681:	c9                   	leave
  800682:	c3                   	ret

0000000000800683 <cprintf>:

int
cprintf(const char *fmt, ...) {
  800683:	f3 0f 1e fa          	endbr64
  800687:	55                   	push   %rbp
  800688:	48 89 e5             	mov    %rsp,%rbp
  80068b:	48 83 ec 50          	sub    $0x50,%rsp
  80068f:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  800693:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  800697:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80069b:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  80069f:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  8006a3:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  8006aa:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8006ae:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8006b2:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8006b6:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  8006ba:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  8006be:	48 b8 1b 06 80 00 00 	movabs $0x80061b,%rax
  8006c5:	00 00 00 
  8006c8:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  8006ca:	c9                   	leave
  8006cb:	c3                   	ret

00000000008006cc <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  8006cc:	f3 0f 1e fa          	endbr64
  8006d0:	55                   	push   %rbp
  8006d1:	48 89 e5             	mov    %rsp,%rbp
  8006d4:	41 57                	push   %r15
  8006d6:	41 56                	push   %r14
  8006d8:	41 55                	push   %r13
  8006da:	41 54                	push   %r12
  8006dc:	53                   	push   %rbx
  8006dd:	48 83 ec 18          	sub    $0x18,%rsp
  8006e1:	49 89 fc             	mov    %rdi,%r12
  8006e4:	49 89 f5             	mov    %rsi,%r13
  8006e7:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  8006eb:	8b 45 10             	mov    0x10(%rbp),%eax
  8006ee:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  8006f1:	41 89 cf             	mov    %ecx,%r15d
  8006f4:	4c 39 fa             	cmp    %r15,%rdx
  8006f7:	73 5b                	jae    800754 <print_num+0x88>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  8006f9:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  8006fd:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  800701:	85 db                	test   %ebx,%ebx
  800703:	7e 0e                	jle    800713 <print_num+0x47>
            putch(padc, put_arg);
  800705:	4c 89 ee             	mov    %r13,%rsi
  800708:	44 89 f7             	mov    %r14d,%edi
  80070b:	41 ff d4             	call   *%r12
        while (--width > 0) {
  80070e:	83 eb 01             	sub    $0x1,%ebx
  800711:	75 f2                	jne    800705 <print_num+0x39>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  800713:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  800717:	48 b9 84 40 80 00 00 	movabs $0x804084,%rcx
  80071e:	00 00 00 
  800721:	48 b8 73 40 80 00 00 	movabs $0x804073,%rax
  800728:	00 00 00 
  80072b:	48 0f 45 c8          	cmovne %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  80072f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800733:	ba 00 00 00 00       	mov    $0x0,%edx
  800738:	49 f7 f7             	div    %r15
  80073b:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  80073f:	4c 89 ee             	mov    %r13,%rsi
  800742:	41 ff d4             	call   *%r12
}
  800745:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800749:	5b                   	pop    %rbx
  80074a:	41 5c                	pop    %r12
  80074c:	41 5d                	pop    %r13
  80074e:	41 5e                	pop    %r14
  800750:	41 5f                	pop    %r15
  800752:	5d                   	pop    %rbp
  800753:	c3                   	ret
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  800754:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800758:	ba 00 00 00 00       	mov    $0x0,%edx
  80075d:	49 f7 f7             	div    %r15
  800760:	48 83 ec 08          	sub    $0x8,%rsp
  800764:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  800768:	52                   	push   %rdx
  800769:	45 0f be c9          	movsbl %r9b,%r9d
  80076d:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  800771:	48 89 c2             	mov    %rax,%rdx
  800774:	48 b8 cc 06 80 00 00 	movabs $0x8006cc,%rax
  80077b:	00 00 00 
  80077e:	ff d0                	call   *%rax
  800780:	48 83 c4 10          	add    $0x10,%rsp
  800784:	eb 8d                	jmp    800713 <print_num+0x47>

0000000000800786 <sprintputch>:
    char *end;
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
  800786:	f3 0f 1e fa          	endbr64
    state->count++;
  80078a:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  80078e:	48 8b 06             	mov    (%rsi),%rax
  800791:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  800795:	73 0a                	jae    8007a1 <sprintputch+0x1b>
        *state->start++ = ch;
  800797:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80079b:	48 89 16             	mov    %rdx,(%rsi)
  80079e:	40 88 38             	mov    %dil,(%rax)
    }
}
  8007a1:	c3                   	ret

00000000008007a2 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  8007a2:	f3 0f 1e fa          	endbr64
  8007a6:	55                   	push   %rbp
  8007a7:	48 89 e5             	mov    %rsp,%rbp
  8007aa:	48 83 ec 50          	sub    $0x50,%rsp
  8007ae:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8007b2:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8007b6:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  8007ba:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  8007c1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8007c5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007c9:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8007cd:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  8007d1:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  8007d5:	48 b8 e3 07 80 00 00 	movabs $0x8007e3,%rax
  8007dc:	00 00 00 
  8007df:	ff d0                	call   *%rax
}
  8007e1:	c9                   	leave
  8007e2:	c3                   	ret

00000000008007e3 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  8007e3:	f3 0f 1e fa          	endbr64
  8007e7:	55                   	push   %rbp
  8007e8:	48 89 e5             	mov    %rsp,%rbp
  8007eb:	41 57                	push   %r15
  8007ed:	41 56                	push   %r14
  8007ef:	41 55                	push   %r13
  8007f1:	41 54                	push   %r12
  8007f3:	53                   	push   %rbx
  8007f4:	48 83 ec 38          	sub    $0x38,%rsp
  8007f8:	49 89 fe             	mov    %rdi,%r14
  8007fb:	49 89 f5             	mov    %rsi,%r13
  8007fe:	48 89 d3             	mov    %rdx,%rbx
    va_copy(aq, ap);
  800801:	48 8b 01             	mov    (%rcx),%rax
  800804:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  800808:	48 8b 41 08          	mov    0x8(%rcx),%rax
  80080c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800810:	48 8b 41 10          	mov    0x10(%rcx),%rax
  800814:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  800818:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  80081c:	0f b6 3b             	movzbl (%rbx),%edi
  80081f:	40 80 ff 25          	cmp    $0x25,%dil
  800823:	74 18                	je     80083d <vprintfmt+0x5a>
            if (!ch) return;
  800825:	40 84 ff             	test   %dil,%dil
  800828:	0f 84 b2 06 00 00    	je     800ee0 <vprintfmt+0x6fd>
            putch(ch, put_arg);
  80082e:	40 0f b6 ff          	movzbl %dil,%edi
  800832:	4c 89 ee             	mov    %r13,%rsi
  800835:	41 ff d6             	call   *%r14
        while ((ch = *ufmt++) != '%') {
  800838:	4c 89 e3             	mov    %r12,%rbx
  80083b:	eb db                	jmp    800818 <vprintfmt+0x35>
        bool altflag = 0, zflag = 0;
  80083d:	be 00 00 00 00       	mov    $0x0,%esi
  800842:	c6 45 ab 00          	movb   $0x0,-0x55(%rbp)
        unsigned lflag = 0, base = 10;
  800846:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  80084b:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  800851:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  800858:	c6 45 aa 20          	movb   $0x20,-0x56(%rbp)
        switch (ch = *ufmt++) {
  80085c:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  800861:	41 0f b6 04 24       	movzbl (%r12),%eax
  800866:	88 45 a0             	mov    %al,-0x60(%rbp)
  800869:	83 e8 23             	sub    $0x23,%eax
  80086c:	3c 57                	cmp    $0x57,%al
  80086e:	0f 87 52 06 00 00    	ja     800ec6 <vprintfmt+0x6e3>
  800874:	0f b6 c0             	movzbl %al,%eax
  800877:	48 b9 c0 43 80 00 00 	movabs $0x8043c0,%rcx
  80087e:	00 00 00 
  800881:	3e ff 24 c1          	notrack jmp *(%rcx,%rax,8)
  800885:	49 89 dc             	mov    %rbx,%r12
            altflag = 1;
  800888:	c6 45 ab 01          	movb   $0x1,-0x55(%rbp)
  80088c:	eb ce                	jmp    80085c <vprintfmt+0x79>
        switch (ch = *ufmt++) {
  80088e:	49 89 dc             	mov    %rbx,%r12
  800891:	be 01 00 00 00       	mov    $0x1,%esi
  800896:	eb c4                	jmp    80085c <vprintfmt+0x79>
            padc = ch;
  800898:	0f b6 45 a0          	movzbl -0x60(%rbp),%eax
  80089c:	88 45 aa             	mov    %al,-0x56(%rbp)
        switch (ch = *ufmt++) {
  80089f:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  8008a2:	eb b8                	jmp    80085c <vprintfmt+0x79>
            precision = va_arg(aq, int);
  8008a4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008a7:	83 f8 2f             	cmp    $0x2f,%eax
  8008aa:	77 24                	ja     8008d0 <vprintfmt+0xed>
  8008ac:	89 c1                	mov    %eax,%ecx
  8008ae:	48 03 4d c8          	add    -0x38(%rbp),%rcx
  8008b2:	83 c0 08             	add    $0x8,%eax
  8008b5:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008b8:	44 8b 39             	mov    (%rcx),%r15d
        switch (ch = *ufmt++) {
  8008bb:	49 89 dc             	mov    %rbx,%r12
            if (width < 0) {
  8008be:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8008c2:	79 98                	jns    80085c <vprintfmt+0x79>
                width = precision;
  8008c4:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
                precision = -1;
  8008c8:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  8008ce:	eb 8c                	jmp    80085c <vprintfmt+0x79>
            precision = va_arg(aq, int);
  8008d0:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8008d4:	48 8d 41 08          	lea    0x8(%rcx),%rax
  8008d8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8008dc:	eb da                	jmp    8008b8 <vprintfmt+0xd5>
                precision = precision * 10 + ch - '0';
  8008de:	44 0f b6 7d a0       	movzbl -0x60(%rbp),%r15d
  8008e3:	41 83 ef 30          	sub    $0x30,%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  8008e7:	41 0f b6 44 24 01    	movzbl 0x1(%r12),%eax
  8008ed:	3c 39                	cmp    $0x39,%al
  8008ef:	77 1c                	ja     80090d <vprintfmt+0x12a>
            for (precision = 0;; ++ufmt) {
  8008f1:	48 83 c3 01          	add    $0x1,%rbx
                precision = precision * 10 + ch - '0';
  8008f5:	43 8d 0c bf          	lea    (%r15,%r15,4),%ecx
  8008f9:	0f b6 c0             	movzbl %al,%eax
  8008fc:	44 8d 7c 48 d0       	lea    -0x30(%rax,%rcx,2),%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  800901:	0f b6 03             	movzbl (%rbx),%eax
  800904:	3c 39                	cmp    $0x39,%al
  800906:	76 e9                	jbe    8008f1 <vprintfmt+0x10e>
        process_precision:
  800908:	49 89 dc             	mov    %rbx,%r12
  80090b:	eb b1                	jmp    8008be <vprintfmt+0xdb>
        switch (ch = *ufmt++) {
  80090d:	49 89 dc             	mov    %rbx,%r12
  800910:	eb ac                	jmp    8008be <vprintfmt+0xdb>
            width = MAX(0, width);
  800912:	8b 4d ac             	mov    -0x54(%rbp),%ecx
  800915:	85 c9                	test   %ecx,%ecx
  800917:	b8 00 00 00 00       	mov    $0x0,%eax
  80091c:	0f 49 c1             	cmovns %ecx,%eax
  80091f:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  800922:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  800925:	e9 32 ff ff ff       	jmp    80085c <vprintfmt+0x79>
            lflag++;
  80092a:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  80092d:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  800930:	e9 27 ff ff ff       	jmp    80085c <vprintfmt+0x79>
            putch(va_arg(aq, int), put_arg);
  800935:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800938:	83 f8 2f             	cmp    $0x2f,%eax
  80093b:	77 19                	ja     800956 <vprintfmt+0x173>
  80093d:	89 c2                	mov    %eax,%edx
  80093f:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800943:	83 c0 08             	add    $0x8,%eax
  800946:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800949:	8b 3a                	mov    (%rdx),%edi
  80094b:	4c 89 ee             	mov    %r13,%rsi
  80094e:	41 ff d6             	call   *%r14
            break;
  800951:	e9 c2 fe ff ff       	jmp    800818 <vprintfmt+0x35>
            putch(va_arg(aq, int), put_arg);
  800956:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80095a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80095e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800962:	eb e5                	jmp    800949 <vprintfmt+0x166>
            int err = va_arg(aq, int);
  800964:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800967:	83 f8 2f             	cmp    $0x2f,%eax
  80096a:	77 5a                	ja     8009c6 <vprintfmt+0x1e3>
  80096c:	89 c2                	mov    %eax,%edx
  80096e:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800972:	83 c0 08             	add    $0x8,%eax
  800975:	89 45 b8             	mov    %eax,-0x48(%rbp)
            if (err < 0) err = -err;
  800978:	8b 02                	mov    (%rdx),%eax
  80097a:	89 c1                	mov    %eax,%ecx
  80097c:	f7 d9                	neg    %ecx
  80097e:	0f 48 c8             	cmovs  %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  800981:	83 f9 13             	cmp    $0x13,%ecx
  800984:	7f 4e                	jg     8009d4 <vprintfmt+0x1f1>
  800986:	48 63 c1             	movslq %ecx,%rax
  800989:	48 ba 80 46 80 00 00 	movabs $0x804680,%rdx
  800990:	00 00 00 
  800993:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  800997:	48 85 c0             	test   %rax,%rax
  80099a:	74 38                	je     8009d4 <vprintfmt+0x1f1>
                printfmt(putch, put_arg, "%s", strerr);
  80099c:	48 89 c1             	mov    %rax,%rcx
  80099f:	48 ba 78 42 80 00 00 	movabs $0x804278,%rdx
  8009a6:	00 00 00 
  8009a9:	4c 89 ee             	mov    %r13,%rsi
  8009ac:	4c 89 f7             	mov    %r14,%rdi
  8009af:	b8 00 00 00 00       	mov    $0x0,%eax
  8009b4:	49 b8 a2 07 80 00 00 	movabs $0x8007a2,%r8
  8009bb:	00 00 00 
  8009be:	41 ff d0             	call   *%r8
  8009c1:	e9 52 fe ff ff       	jmp    800818 <vprintfmt+0x35>
            int err = va_arg(aq, int);
  8009c6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009ca:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009ce:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009d2:	eb a4                	jmp    800978 <vprintfmt+0x195>
                printfmt(putch, put_arg, "error %d", err);
  8009d4:	48 ba 9c 40 80 00 00 	movabs $0x80409c,%rdx
  8009db:	00 00 00 
  8009de:	4c 89 ee             	mov    %r13,%rsi
  8009e1:	4c 89 f7             	mov    %r14,%rdi
  8009e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8009e9:	49 b8 a2 07 80 00 00 	movabs $0x8007a2,%r8
  8009f0:	00 00 00 
  8009f3:	41 ff d0             	call   *%r8
  8009f6:	e9 1d fe ff ff       	jmp    800818 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  8009fb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009fe:	83 f8 2f             	cmp    $0x2f,%eax
  800a01:	77 6c                	ja     800a6f <vprintfmt+0x28c>
  800a03:	89 c2                	mov    %eax,%edx
  800a05:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a09:	83 c0 08             	add    $0x8,%eax
  800a0c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a0f:	48 8b 12             	mov    (%rdx),%rdx
            if (!ptr) ptr = "(null)";
  800a12:	48 85 d2             	test   %rdx,%rdx
  800a15:	48 b8 95 40 80 00 00 	movabs $0x804095,%rax
  800a1c:	00 00 00 
  800a1f:	48 0f 45 c2          	cmovne %rdx,%rax
  800a23:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
            if (width > 0 && padc != '-') {
  800a27:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800a2b:	7e 06                	jle    800a33 <vprintfmt+0x250>
  800a2d:	80 7d aa 2d          	cmpb   $0x2d,-0x56(%rbp)
  800a31:	75 4a                	jne    800a7d <vprintfmt+0x29a>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800a33:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800a37:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800a3b:	0f b6 00             	movzbl (%rax),%eax
  800a3e:	84 c0                	test   %al,%al
  800a40:	0f 85 9a 00 00 00    	jne    800ae0 <vprintfmt+0x2fd>
            while (width-- > 0) putch(' ', put_arg);
  800a46:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800a49:	44 8d 60 ff          	lea    -0x1(%rax),%r12d
  800a4d:	85 c0                	test   %eax,%eax
  800a4f:	0f 8e c3 fd ff ff    	jle    800818 <vprintfmt+0x35>
  800a55:	4c 89 ee             	mov    %r13,%rsi
  800a58:	bf 20 00 00 00       	mov    $0x20,%edi
  800a5d:	41 ff d6             	call   *%r14
  800a60:	41 83 ec 01          	sub    $0x1,%r12d
  800a64:	41 83 fc ff          	cmp    $0xffffffff,%r12d
  800a68:	75 eb                	jne    800a55 <vprintfmt+0x272>
  800a6a:	e9 a9 fd ff ff       	jmp    800818 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  800a6f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a73:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a77:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a7b:	eb 92                	jmp    800a0f <vprintfmt+0x22c>
                width -= strnlen(ptr, precision);
  800a7d:	49 63 f7             	movslq %r15d,%rsi
  800a80:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  800a84:	48 b8 a6 0f 80 00 00 	movabs $0x800fa6,%rax
  800a8b:	00 00 00 
  800a8e:	ff d0                	call   *%rax
  800a90:	48 89 c2             	mov    %rax,%rdx
  800a93:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800a96:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  800a98:	8d 70 ff             	lea    -0x1(%rax),%esi
  800a9b:	89 75 ac             	mov    %esi,-0x54(%rbp)
  800a9e:	85 c0                	test   %eax,%eax
  800aa0:	7e 91                	jle    800a33 <vprintfmt+0x250>
  800aa2:	44 0f be 65 aa       	movsbl -0x56(%rbp),%r12d
  800aa7:	4c 89 ee             	mov    %r13,%rsi
  800aaa:	44 89 e7             	mov    %r12d,%edi
  800aad:	41 ff d6             	call   *%r14
  800ab0:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  800ab4:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800ab7:	83 f8 ff             	cmp    $0xffffffff,%eax
  800aba:	75 eb                	jne    800aa7 <vprintfmt+0x2c4>
  800abc:	e9 72 ff ff ff       	jmp    800a33 <vprintfmt+0x250>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800ac1:	0f b6 f8             	movzbl %al,%edi
  800ac4:	4c 89 ee             	mov    %r13,%rsi
  800ac7:	41 ff d6             	call   *%r14
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  800aca:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  800ace:	49 83 c4 01          	add    $0x1,%r12
  800ad2:	41 0f b6 44 24 ff    	movzbl -0x1(%r12),%eax
  800ad8:	84 c0                	test   %al,%al
  800ada:	0f 84 66 ff ff ff    	je     800a46 <vprintfmt+0x263>
  800ae0:	45 85 ff             	test   %r15d,%r15d
  800ae3:	78 0a                	js     800aef <vprintfmt+0x30c>
  800ae5:	41 83 ef 01          	sub    $0x1,%r15d
  800ae9:	0f 88 57 ff ff ff    	js     800a46 <vprintfmt+0x263>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800aef:	80 7d ab 00          	cmpb   $0x0,-0x55(%rbp)
  800af3:	74 cc                	je     800ac1 <vprintfmt+0x2de>
  800af5:	8d 50 e0             	lea    -0x20(%rax),%edx
  800af8:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800afd:	80 fa 5e             	cmp    $0x5e,%dl
  800b00:	77 c2                	ja     800ac4 <vprintfmt+0x2e1>
  800b02:	eb bd                	jmp    800ac1 <vprintfmt+0x2de>
    if (zflag) return va_arg(*ap, size_t);
  800b04:	40 84 f6             	test   %sil,%sil
  800b07:	75 26                	jne    800b2f <vprintfmt+0x34c>
    switch (lflag) {
  800b09:	85 d2                	test   %edx,%edx
  800b0b:	74 59                	je     800b66 <vprintfmt+0x383>
  800b0d:	83 fa 01             	cmp    $0x1,%edx
  800b10:	74 7b                	je     800b8d <vprintfmt+0x3aa>
        return va_arg(*ap, long long);
  800b12:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b15:	83 f8 2f             	cmp    $0x2f,%eax
  800b18:	0f 87 96 00 00 00    	ja     800bb4 <vprintfmt+0x3d1>
  800b1e:	89 c2                	mov    %eax,%edx
  800b20:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b24:	83 c0 08             	add    $0x8,%eax
  800b27:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b2a:	4c 8b 22             	mov    (%rdx),%r12
  800b2d:	eb 17                	jmp    800b46 <vprintfmt+0x363>
    if (zflag) return va_arg(*ap, size_t);
  800b2f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b32:	83 f8 2f             	cmp    $0x2f,%eax
  800b35:	77 21                	ja     800b58 <vprintfmt+0x375>
  800b37:	89 c2                	mov    %eax,%edx
  800b39:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b3d:	83 c0 08             	add    $0x8,%eax
  800b40:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b43:	4c 8b 22             	mov    (%rdx),%r12
            if (i < 0) {
  800b46:	4d 85 e4             	test   %r12,%r12
  800b49:	78 7a                	js     800bc5 <vprintfmt+0x3e2>
            num = i;
  800b4b:	4c 89 e2             	mov    %r12,%rdx
        unsigned lflag = 0, base = 10;
  800b4e:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  800b53:	e9 50 02 00 00       	jmp    800da8 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800b58:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b5c:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b60:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b64:	eb dd                	jmp    800b43 <vprintfmt+0x360>
        return va_arg(*ap, int);
  800b66:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b69:	83 f8 2f             	cmp    $0x2f,%eax
  800b6c:	77 11                	ja     800b7f <vprintfmt+0x39c>
  800b6e:	89 c2                	mov    %eax,%edx
  800b70:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b74:	83 c0 08             	add    $0x8,%eax
  800b77:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b7a:	4c 63 22             	movslq (%rdx),%r12
  800b7d:	eb c7                	jmp    800b46 <vprintfmt+0x363>
  800b7f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b83:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b87:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b8b:	eb ed                	jmp    800b7a <vprintfmt+0x397>
        return va_arg(*ap, long);
  800b8d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b90:	83 f8 2f             	cmp    $0x2f,%eax
  800b93:	77 11                	ja     800ba6 <vprintfmt+0x3c3>
  800b95:	89 c2                	mov    %eax,%edx
  800b97:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b9b:	83 c0 08             	add    $0x8,%eax
  800b9e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ba1:	4c 8b 22             	mov    (%rdx),%r12
  800ba4:	eb a0                	jmp    800b46 <vprintfmt+0x363>
  800ba6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800baa:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800bae:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800bb2:	eb ed                	jmp    800ba1 <vprintfmt+0x3be>
        return va_arg(*ap, long long);
  800bb4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bb8:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800bbc:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800bc0:	e9 65 ff ff ff       	jmp    800b2a <vprintfmt+0x347>
                putch('-', put_arg);
  800bc5:	4c 89 ee             	mov    %r13,%rsi
  800bc8:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800bcd:	41 ff d6             	call   *%r14
                i = -i;
  800bd0:	49 f7 dc             	neg    %r12
  800bd3:	e9 73 ff ff ff       	jmp    800b4b <vprintfmt+0x368>
    if (zflag) return va_arg(*ap, size_t);
  800bd8:	40 84 f6             	test   %sil,%sil
  800bdb:	75 32                	jne    800c0f <vprintfmt+0x42c>
    switch (lflag) {
  800bdd:	85 d2                	test   %edx,%edx
  800bdf:	74 5d                	je     800c3e <vprintfmt+0x45b>
  800be1:	83 fa 01             	cmp    $0x1,%edx
  800be4:	0f 84 82 00 00 00    	je     800c6c <vprintfmt+0x489>
        return va_arg(*ap, unsigned long long);
  800bea:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bed:	83 f8 2f             	cmp    $0x2f,%eax
  800bf0:	0f 87 a5 00 00 00    	ja     800c9b <vprintfmt+0x4b8>
  800bf6:	89 c2                	mov    %eax,%edx
  800bf8:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800bfc:	83 c0 08             	add    $0x8,%eax
  800bff:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c02:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800c05:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  800c0a:	e9 99 01 00 00       	jmp    800da8 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800c0f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c12:	83 f8 2f             	cmp    $0x2f,%eax
  800c15:	77 19                	ja     800c30 <vprintfmt+0x44d>
  800c17:	89 c2                	mov    %eax,%edx
  800c19:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800c1d:	83 c0 08             	add    $0x8,%eax
  800c20:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c23:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800c26:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800c2b:	e9 78 01 00 00       	jmp    800da8 <vprintfmt+0x5c5>
  800c30:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c34:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800c38:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c3c:	eb e5                	jmp    800c23 <vprintfmt+0x440>
        return va_arg(*ap, unsigned int);
  800c3e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c41:	83 f8 2f             	cmp    $0x2f,%eax
  800c44:	77 18                	ja     800c5e <vprintfmt+0x47b>
  800c46:	89 c2                	mov    %eax,%edx
  800c48:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800c4c:	83 c0 08             	add    $0x8,%eax
  800c4f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c52:	8b 12                	mov    (%rdx),%edx
        unsigned lflag = 0, base = 10;
  800c54:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  800c59:	e9 4a 01 00 00       	jmp    800da8 <vprintfmt+0x5c5>
  800c5e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c62:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800c66:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c6a:	eb e6                	jmp    800c52 <vprintfmt+0x46f>
        return va_arg(*ap, unsigned long);
  800c6c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c6f:	83 f8 2f             	cmp    $0x2f,%eax
  800c72:	77 19                	ja     800c8d <vprintfmt+0x4aa>
  800c74:	89 c2                	mov    %eax,%edx
  800c76:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800c7a:	83 c0 08             	add    $0x8,%eax
  800c7d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c80:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800c83:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  800c88:	e9 1b 01 00 00       	jmp    800da8 <vprintfmt+0x5c5>
  800c8d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c91:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800c95:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c99:	eb e5                	jmp    800c80 <vprintfmt+0x49d>
        return va_arg(*ap, unsigned long long);
  800c9b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c9f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800ca3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ca7:	e9 56 ff ff ff       	jmp    800c02 <vprintfmt+0x41f>
    if (zflag) return va_arg(*ap, size_t);
  800cac:	40 84 f6             	test   %sil,%sil
  800caf:	75 2e                	jne    800cdf <vprintfmt+0x4fc>
    switch (lflag) {
  800cb1:	85 d2                	test   %edx,%edx
  800cb3:	74 59                	je     800d0e <vprintfmt+0x52b>
  800cb5:	83 fa 01             	cmp    $0x1,%edx
  800cb8:	74 7f                	je     800d39 <vprintfmt+0x556>
        return va_arg(*ap, unsigned long long);
  800cba:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cbd:	83 f8 2f             	cmp    $0x2f,%eax
  800cc0:	0f 87 9f 00 00 00    	ja     800d65 <vprintfmt+0x582>
  800cc6:	89 c2                	mov    %eax,%edx
  800cc8:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800ccc:	83 c0 08             	add    $0x8,%eax
  800ccf:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800cd2:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800cd5:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  800cda:	e9 c9 00 00 00       	jmp    800da8 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800cdf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ce2:	83 f8 2f             	cmp    $0x2f,%eax
  800ce5:	77 19                	ja     800d00 <vprintfmt+0x51d>
  800ce7:	89 c2                	mov    %eax,%edx
  800ce9:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800ced:	83 c0 08             	add    $0x8,%eax
  800cf0:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800cf3:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800cf6:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800cfb:	e9 a8 00 00 00       	jmp    800da8 <vprintfmt+0x5c5>
  800d00:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d04:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800d08:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800d0c:	eb e5                	jmp    800cf3 <vprintfmt+0x510>
        return va_arg(*ap, unsigned int);
  800d0e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d11:	83 f8 2f             	cmp    $0x2f,%eax
  800d14:	77 15                	ja     800d2b <vprintfmt+0x548>
  800d16:	89 c2                	mov    %eax,%edx
  800d18:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800d1c:	83 c0 08             	add    $0x8,%eax
  800d1f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800d22:	8b 12                	mov    (%rdx),%edx
            base = 8;
  800d24:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  800d29:	eb 7d                	jmp    800da8 <vprintfmt+0x5c5>
  800d2b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d2f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800d33:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800d37:	eb e9                	jmp    800d22 <vprintfmt+0x53f>
        return va_arg(*ap, unsigned long);
  800d39:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d3c:	83 f8 2f             	cmp    $0x2f,%eax
  800d3f:	77 16                	ja     800d57 <vprintfmt+0x574>
  800d41:	89 c2                	mov    %eax,%edx
  800d43:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800d47:	83 c0 08             	add    $0x8,%eax
  800d4a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800d4d:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800d50:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  800d55:	eb 51                	jmp    800da8 <vprintfmt+0x5c5>
  800d57:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d5b:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800d5f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800d63:	eb e8                	jmp    800d4d <vprintfmt+0x56a>
        return va_arg(*ap, unsigned long long);
  800d65:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d69:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800d6d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800d71:	e9 5c ff ff ff       	jmp    800cd2 <vprintfmt+0x4ef>
            putch('0', put_arg);
  800d76:	4c 89 ee             	mov    %r13,%rsi
  800d79:	bf 30 00 00 00       	mov    $0x30,%edi
  800d7e:	41 ff d6             	call   *%r14
            putch('x', put_arg);
  800d81:	4c 89 ee             	mov    %r13,%rsi
  800d84:	bf 78 00 00 00       	mov    $0x78,%edi
  800d89:	41 ff d6             	call   *%r14
            num = (uintptr_t)va_arg(aq, void *);
  800d8c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d8f:	83 f8 2f             	cmp    $0x2f,%eax
  800d92:	77 47                	ja     800ddb <vprintfmt+0x5f8>
  800d94:	89 c2                	mov    %eax,%edx
  800d96:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800d9a:	83 c0 08             	add    $0x8,%eax
  800d9d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800da0:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800da3:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  800da8:	48 83 ec 08          	sub    $0x8,%rsp
  800dac:	80 7d a0 58          	cmpb   $0x58,-0x60(%rbp)
  800db0:	0f 94 c0             	sete   %al
  800db3:	0f b6 c0             	movzbl %al,%eax
  800db6:	50                   	push   %rax
  800db7:	44 0f be 4d aa       	movsbl -0x56(%rbp),%r9d
  800dbc:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  800dc0:	4c 89 ee             	mov    %r13,%rsi
  800dc3:	4c 89 f7             	mov    %r14,%rdi
  800dc6:	48 b8 cc 06 80 00 00 	movabs $0x8006cc,%rax
  800dcd:	00 00 00 
  800dd0:	ff d0                	call   *%rax
            break;
  800dd2:	48 83 c4 10          	add    $0x10,%rsp
  800dd6:	e9 3d fa ff ff       	jmp    800818 <vprintfmt+0x35>
            num = (uintptr_t)va_arg(aq, void *);
  800ddb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ddf:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800de3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800de7:	eb b7                	jmp    800da0 <vprintfmt+0x5bd>
    if (zflag) return va_arg(*ap, size_t);
  800de9:	40 84 f6             	test   %sil,%sil
  800dec:	75 2b                	jne    800e19 <vprintfmt+0x636>
    switch (lflag) {
  800dee:	85 d2                	test   %edx,%edx
  800df0:	74 56                	je     800e48 <vprintfmt+0x665>
  800df2:	83 fa 01             	cmp    $0x1,%edx
  800df5:	74 7f                	je     800e76 <vprintfmt+0x693>
        return va_arg(*ap, unsigned long long);
  800df7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800dfa:	83 f8 2f             	cmp    $0x2f,%eax
  800dfd:	0f 87 a2 00 00 00    	ja     800ea5 <vprintfmt+0x6c2>
  800e03:	89 c2                	mov    %eax,%edx
  800e05:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800e09:	83 c0 08             	add    $0x8,%eax
  800e0c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800e0f:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800e12:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800e17:	eb 8f                	jmp    800da8 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800e19:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e1c:	83 f8 2f             	cmp    $0x2f,%eax
  800e1f:	77 19                	ja     800e3a <vprintfmt+0x657>
  800e21:	89 c2                	mov    %eax,%edx
  800e23:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800e27:	83 c0 08             	add    $0x8,%eax
  800e2a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800e2d:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800e30:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800e35:	e9 6e ff ff ff       	jmp    800da8 <vprintfmt+0x5c5>
  800e3a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e3e:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800e42:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800e46:	eb e5                	jmp    800e2d <vprintfmt+0x64a>
        return va_arg(*ap, unsigned int);
  800e48:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e4b:	83 f8 2f             	cmp    $0x2f,%eax
  800e4e:	77 18                	ja     800e68 <vprintfmt+0x685>
  800e50:	89 c2                	mov    %eax,%edx
  800e52:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800e56:	83 c0 08             	add    $0x8,%eax
  800e59:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800e5c:	8b 12                	mov    (%rdx),%edx
            base = 16;
  800e5e:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  800e63:	e9 40 ff ff ff       	jmp    800da8 <vprintfmt+0x5c5>
  800e68:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e6c:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800e70:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800e74:	eb e6                	jmp    800e5c <vprintfmt+0x679>
        return va_arg(*ap, unsigned long);
  800e76:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e79:	83 f8 2f             	cmp    $0x2f,%eax
  800e7c:	77 19                	ja     800e97 <vprintfmt+0x6b4>
  800e7e:	89 c2                	mov    %eax,%edx
  800e80:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800e84:	83 c0 08             	add    $0x8,%eax
  800e87:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800e8a:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800e8d:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800e92:	e9 11 ff ff ff       	jmp    800da8 <vprintfmt+0x5c5>
  800e97:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e9b:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800e9f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800ea3:	eb e5                	jmp    800e8a <vprintfmt+0x6a7>
        return va_arg(*ap, unsigned long long);
  800ea5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ea9:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800ead:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800eb1:	e9 59 ff ff ff       	jmp    800e0f <vprintfmt+0x62c>
            putch(ch, put_arg);
  800eb6:	4c 89 ee             	mov    %r13,%rsi
  800eb9:	bf 25 00 00 00       	mov    $0x25,%edi
  800ebe:	41 ff d6             	call   *%r14
            break;
  800ec1:	e9 52 f9 ff ff       	jmp    800818 <vprintfmt+0x35>
            putch('%', put_arg);
  800ec6:	4c 89 ee             	mov    %r13,%rsi
  800ec9:	bf 25 00 00 00       	mov    $0x25,%edi
  800ece:	41 ff d6             	call   *%r14
            while ((--ufmt)[-1] != '%') /* nothing */
  800ed1:	48 83 eb 01          	sub    $0x1,%rbx
  800ed5:	80 7b ff 25          	cmpb   $0x25,-0x1(%rbx)
  800ed9:	75 f6                	jne    800ed1 <vprintfmt+0x6ee>
  800edb:	e9 38 f9 ff ff       	jmp    800818 <vprintfmt+0x35>
}
  800ee0:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800ee4:	5b                   	pop    %rbx
  800ee5:	41 5c                	pop    %r12
  800ee7:	41 5d                	pop    %r13
  800ee9:	41 5e                	pop    %r14
  800eeb:	41 5f                	pop    %r15
  800eed:	5d                   	pop    %rbp
  800eee:	c3                   	ret

0000000000800eef <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800eef:	f3 0f 1e fa          	endbr64
  800ef3:	55                   	push   %rbp
  800ef4:	48 89 e5             	mov    %rsp,%rbp
  800ef7:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800efb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800eff:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800f04:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800f08:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800f0f:	48 85 ff             	test   %rdi,%rdi
  800f12:	74 2b                	je     800f3f <vsnprintf+0x50>
  800f14:	48 85 f6             	test   %rsi,%rsi
  800f17:	74 26                	je     800f3f <vsnprintf+0x50>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800f19:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800f1d:	48 bf 86 07 80 00 00 	movabs $0x800786,%rdi
  800f24:	00 00 00 
  800f27:	48 b8 e3 07 80 00 00 	movabs $0x8007e3,%rax
  800f2e:	00 00 00 
  800f31:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800f33:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f37:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800f3a:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800f3d:	c9                   	leave
  800f3e:	c3                   	ret
    if (!buf || n < 1) return -E_INVAL;
  800f3f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f44:	eb f7                	jmp    800f3d <vsnprintf+0x4e>

0000000000800f46 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800f46:	f3 0f 1e fa          	endbr64
  800f4a:	55                   	push   %rbp
  800f4b:	48 89 e5             	mov    %rsp,%rbp
  800f4e:	48 83 ec 50          	sub    $0x50,%rsp
  800f52:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800f56:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800f5a:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800f5e:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800f65:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f69:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800f6d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800f71:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800f75:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800f79:	48 b8 ef 0e 80 00 00 	movabs $0x800eef,%rax
  800f80:	00 00 00 
  800f83:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800f85:	c9                   	leave
  800f86:	c3                   	ret

0000000000800f87 <strlen>:
 * Primespipe runs 3x faster this way */

#define ASM 1

size_t
strlen(const char *s) {
  800f87:	f3 0f 1e fa          	endbr64
    size_t n = 0;
    while (*s++) n++;
  800f8b:	80 3f 00             	cmpb   $0x0,(%rdi)
  800f8e:	74 10                	je     800fa0 <strlen+0x19>
    size_t n = 0;
  800f90:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800f95:	48 83 c0 01          	add    $0x1,%rax
  800f99:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800f9d:	75 f6                	jne    800f95 <strlen+0xe>
  800f9f:	c3                   	ret
    size_t n = 0;
  800fa0:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800fa5:	c3                   	ret

0000000000800fa6 <strnlen>:

size_t
strnlen(const char *s, size_t size) {
  800fa6:	f3 0f 1e fa          	endbr64
  800faa:	48 89 f0             	mov    %rsi,%rax
    size_t n = 0;
  800fad:	ba 00 00 00 00       	mov    $0x0,%edx
    while (n < size && *s++) n++;
  800fb2:	48 85 f6             	test   %rsi,%rsi
  800fb5:	74 10                	je     800fc7 <strnlen+0x21>
  800fb7:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  800fbb:	74 0b                	je     800fc8 <strnlen+0x22>
  800fbd:	48 83 c2 01          	add    $0x1,%rdx
  800fc1:	48 39 d0             	cmp    %rdx,%rax
  800fc4:	75 f1                	jne    800fb7 <strnlen+0x11>
  800fc6:	c3                   	ret
  800fc7:	c3                   	ret
  800fc8:	48 89 d0             	mov    %rdx,%rax
    return n;
}
  800fcb:	c3                   	ret

0000000000800fcc <strcpy>:

char *
strcpy(char *dst, const char *src) {
  800fcc:	f3 0f 1e fa          	endbr64
  800fd0:	48 89 f8             	mov    %rdi,%rax
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800fd3:	ba 00 00 00 00       	mov    $0x0,%edx
  800fd8:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  800fdc:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  800fdf:	48 83 c2 01          	add    $0x1,%rdx
  800fe3:	84 c9                	test   %cl,%cl
  800fe5:	75 f1                	jne    800fd8 <strcpy+0xc>
        ;
    return res;
}
  800fe7:	c3                   	ret

0000000000800fe8 <strcat>:

char *
strcat(char *dst, const char *src) {
  800fe8:	f3 0f 1e fa          	endbr64
  800fec:	55                   	push   %rbp
  800fed:	48 89 e5             	mov    %rsp,%rbp
  800ff0:	41 54                	push   %r12
  800ff2:	53                   	push   %rbx
  800ff3:	48 89 fb             	mov    %rdi,%rbx
  800ff6:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800ff9:	48 b8 87 0f 80 00 00 	movabs $0x800f87,%rax
  801000:	00 00 00 
  801003:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  801005:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  801009:	4c 89 e6             	mov    %r12,%rsi
  80100c:	48 b8 cc 0f 80 00 00 	movabs $0x800fcc,%rax
  801013:	00 00 00 
  801016:	ff d0                	call   *%rax
    return dst;
}
  801018:	48 89 d8             	mov    %rbx,%rax
  80101b:	5b                   	pop    %rbx
  80101c:	41 5c                	pop    %r12
  80101e:	5d                   	pop    %rbp
  80101f:	c3                   	ret

0000000000801020 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801020:	f3 0f 1e fa          	endbr64
  801024:	48 89 f8             	mov    %rdi,%rax
    char *ret = dst;
    while (size-- > 0) {
  801027:	48 85 d2             	test   %rdx,%rdx
  80102a:	74 1f                	je     80104b <strncpy+0x2b>
  80102c:	48 01 fa             	add    %rdi,%rdx
  80102f:	48 89 f9             	mov    %rdi,%rcx
        *dst++ = *src;
  801032:	48 83 c1 01          	add    $0x1,%rcx
  801036:	44 0f b6 06          	movzbl (%rsi),%r8d
  80103a:	44 88 41 ff          	mov    %r8b,-0x1(%rcx)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  80103e:	41 80 f8 01          	cmp    $0x1,%r8b
  801042:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  801046:	48 39 ca             	cmp    %rcx,%rdx
  801049:	75 e7                	jne    801032 <strncpy+0x12>
    }
    return ret;
}
  80104b:	c3                   	ret

000000000080104c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
  80104c:	f3 0f 1e fa          	endbr64
    char *dst_in = dst;
    if (size) {
  801050:	48 89 f8             	mov    %rdi,%rax
  801053:	48 85 d2             	test   %rdx,%rdx
  801056:	74 24                	je     80107c <strlcpy+0x30>
        while (--size > 0 && *src)
  801058:	48 83 ea 01          	sub    $0x1,%rdx
  80105c:	74 1b                	je     801079 <strlcpy+0x2d>
  80105e:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  801062:	0f b6 16             	movzbl (%rsi),%edx
  801065:	84 d2                	test   %dl,%dl
  801067:	74 10                	je     801079 <strlcpy+0x2d>
            *dst++ = *src++;
  801069:	48 83 c6 01          	add    $0x1,%rsi
  80106d:	48 83 c0 01          	add    $0x1,%rax
  801071:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  801074:	48 39 c8             	cmp    %rcx,%rax
  801077:	75 e9                	jne    801062 <strlcpy+0x16>
        *dst = '\0';
  801079:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  80107c:	48 29 f8             	sub    %rdi,%rax
}
  80107f:	c3                   	ret

0000000000801080 <strcmp>:
    }
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
  801080:	f3 0f 1e fa          	endbr64
    while (*p && *p == *q) p++, q++;
  801084:	0f b6 07             	movzbl (%rdi),%eax
  801087:	84 c0                	test   %al,%al
  801089:	74 13                	je     80109e <strcmp+0x1e>
  80108b:	38 06                	cmp    %al,(%rsi)
  80108d:	75 0f                	jne    80109e <strcmp+0x1e>
  80108f:	48 83 c7 01          	add    $0x1,%rdi
  801093:	48 83 c6 01          	add    $0x1,%rsi
  801097:	0f b6 07             	movzbl (%rdi),%eax
  80109a:	84 c0                	test   %al,%al
  80109c:	75 ed                	jne    80108b <strcmp+0xb>
    return (int)((unsigned char)*p - (unsigned char)*q);
  80109e:	0f b6 c0             	movzbl %al,%eax
  8010a1:	0f b6 16             	movzbl (%rsi),%edx
  8010a4:	29 d0                	sub    %edx,%eax
}
  8010a6:	c3                   	ret

00000000008010a7 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
  8010a7:	f3 0f 1e fa          	endbr64
    while (n && *p && *p == *q) n--, p++, q++;
  8010ab:	48 85 d2             	test   %rdx,%rdx
  8010ae:	74 1f                	je     8010cf <strncmp+0x28>
  8010b0:	0f b6 07             	movzbl (%rdi),%eax
  8010b3:	84 c0                	test   %al,%al
  8010b5:	74 1e                	je     8010d5 <strncmp+0x2e>
  8010b7:	3a 06                	cmp    (%rsi),%al
  8010b9:	75 1a                	jne    8010d5 <strncmp+0x2e>
  8010bb:	48 83 c7 01          	add    $0x1,%rdi
  8010bf:	48 83 c6 01          	add    $0x1,%rsi
  8010c3:	48 83 ea 01          	sub    $0x1,%rdx
  8010c7:	75 e7                	jne    8010b0 <strncmp+0x9>

    if (!n) return 0;
  8010c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8010ce:	c3                   	ret
  8010cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8010d4:	c3                   	ret

    return (int)((unsigned char)*p - (unsigned char)*q);
  8010d5:	0f b6 07             	movzbl (%rdi),%eax
  8010d8:	0f b6 16             	movzbl (%rsi),%edx
  8010db:	29 d0                	sub    %edx,%eax
}
  8010dd:	c3                   	ret

00000000008010de <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
  8010de:	f3 0f 1e fa          	endbr64
    for (; *str; str++) {
  8010e2:	0f b6 17             	movzbl (%rdi),%edx
  8010e5:	84 d2                	test   %dl,%dl
  8010e7:	74 18                	je     801101 <strchr+0x23>
        if (*str == c) {
  8010e9:	0f be d2             	movsbl %dl,%edx
  8010ec:	39 f2                	cmp    %esi,%edx
  8010ee:	74 17                	je     801107 <strchr+0x29>
    for (; *str; str++) {
  8010f0:	48 83 c7 01          	add    $0x1,%rdi
  8010f4:	0f b6 17             	movzbl (%rdi),%edx
  8010f7:	84 d2                	test   %dl,%dl
  8010f9:	75 ee                	jne    8010e9 <strchr+0xb>
            return (char *)str;
        }
    }
    return NULL;
  8010fb:	b8 00 00 00 00       	mov    $0x0,%eax
  801100:	c3                   	ret
  801101:	b8 00 00 00 00       	mov    $0x0,%eax
  801106:	c3                   	ret
            return (char *)str;
  801107:	48 89 f8             	mov    %rdi,%rax
}
  80110a:	c3                   	ret

000000000080110b <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
  80110b:	f3 0f 1e fa          	endbr64
  80110f:	48 89 f8             	mov    %rdi,%rax
    for (; *str && *str != ch; str++) /* nothing */
  801112:	0f b6 17             	movzbl (%rdi),%edx
  801115:	84 d2                	test   %dl,%dl
  801117:	74 13                	je     80112c <strfind+0x21>
  801119:	0f be d2             	movsbl %dl,%edx
  80111c:	39 f2                	cmp    %esi,%edx
  80111e:	74 0b                	je     80112b <strfind+0x20>
  801120:	48 83 c0 01          	add    $0x1,%rax
  801124:	0f b6 10             	movzbl (%rax),%edx
  801127:	84 d2                	test   %dl,%dl
  801129:	75 ee                	jne    801119 <strfind+0xe>
        ;
    return (char *)str;
}
  80112b:	c3                   	ret
  80112c:	c3                   	ret

000000000080112d <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  80112d:	f3 0f 1e fa          	endbr64
  801131:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  801134:	48 89 f8             	mov    %rdi,%rax
  801137:	48 f7 d8             	neg    %rax
  80113a:	83 e0 07             	and    $0x7,%eax
  80113d:	49 89 d1             	mov    %rdx,%r9
  801140:	49 29 c1             	sub    %rax,%r9
  801143:	78 36                	js     80117b <memset+0x4e>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  801145:	40 0f b6 c6          	movzbl %sil,%eax
  801149:	48 b9 01 01 01 01 01 	movabs $0x101010101010101,%rcx
  801150:	01 01 01 
  801153:	48 0f af c1          	imul   %rcx,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  801157:	40 f6 c7 07          	test   $0x7,%dil
  80115b:	75 38                	jne    801195 <memset+0x68>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  80115d:	4c 89 c9             	mov    %r9,%rcx
  801160:	48 c1 f9 03          	sar    $0x3,%rcx
  801164:	74 0c                	je     801172 <memset+0x45>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  801166:	fc                   	cld
  801167:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  80116a:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  80116e:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  801172:	4d 85 c9             	test   %r9,%r9
  801175:	75 45                	jne    8011bc <memset+0x8f>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  801177:	4c 89 c0             	mov    %r8,%rax
  80117a:	c3                   	ret
        while (n-- > 0) *ptr++ = c;
  80117b:	48 85 d2             	test   %rdx,%rdx
  80117e:	74 f7                	je     801177 <memset+0x4a>
  801180:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  801183:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  801186:	48 83 c0 01          	add    $0x1,%rax
  80118a:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  80118e:	48 39 c2             	cmp    %rax,%rdx
  801191:	75 f3                	jne    801186 <memset+0x59>
  801193:	eb e2                	jmp    801177 <memset+0x4a>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  801195:	40 f6 c7 01          	test   $0x1,%dil
  801199:	74 06                	je     8011a1 <memset+0x74>
  80119b:	88 07                	mov    %al,(%rdi)
  80119d:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  8011a1:	40 f6 c7 02          	test   $0x2,%dil
  8011a5:	74 07                	je     8011ae <memset+0x81>
  8011a7:	66 89 07             	mov    %ax,(%rdi)
  8011aa:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  8011ae:	40 f6 c7 04          	test   $0x4,%dil
  8011b2:	74 a9                	je     80115d <memset+0x30>
  8011b4:	89 07                	mov    %eax,(%rdi)
  8011b6:	48 83 c7 04          	add    $0x4,%rdi
  8011ba:	eb a1                	jmp    80115d <memset+0x30>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  8011bc:	41 f6 c1 04          	test   $0x4,%r9b
  8011c0:	74 1b                	je     8011dd <memset+0xb0>
  8011c2:	89 07                	mov    %eax,(%rdi)
  8011c4:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  8011c8:	41 f6 c1 02          	test   $0x2,%r9b
  8011cc:	74 07                	je     8011d5 <memset+0xa8>
  8011ce:	66 89 07             	mov    %ax,(%rdi)
  8011d1:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  8011d5:	41 f6 c1 01          	test   $0x1,%r9b
  8011d9:	74 9c                	je     801177 <memset+0x4a>
  8011db:	eb 06                	jmp    8011e3 <memset+0xb6>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  8011dd:	41 f6 c1 02          	test   $0x2,%r9b
  8011e1:	75 eb                	jne    8011ce <memset+0xa1>
        if (ni & 1) *ptr = k;
  8011e3:	88 07                	mov    %al,(%rdi)
  8011e5:	eb 90                	jmp    801177 <memset+0x4a>

00000000008011e7 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  8011e7:	f3 0f 1e fa          	endbr64
  8011eb:	48 89 f8             	mov    %rdi,%rax
  8011ee:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  8011f1:	48 39 fe             	cmp    %rdi,%rsi
  8011f4:	73 3b                	jae    801231 <memmove+0x4a>
  8011f6:	48 8d 14 16          	lea    (%rsi,%rdx,1),%rdx
  8011fa:	48 39 d7             	cmp    %rdx,%rdi
  8011fd:	73 32                	jae    801231 <memmove+0x4a>
        s += n;
        d += n;
  8011ff:	48 8d 3c 0f          	lea    (%rdi,%rcx,1),%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  801203:	48 89 d6             	mov    %rdx,%rsi
  801206:	48 09 fe             	or     %rdi,%rsi
  801209:	48 09 ce             	or     %rcx,%rsi
  80120c:	40 f6 c6 07          	test   $0x7,%sil
  801210:	75 12                	jne    801224 <memmove+0x3d>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  801212:	48 83 ef 08          	sub    $0x8,%rdi
  801216:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  80121a:	48 c1 e9 03          	shr    $0x3,%rcx
  80121e:	fd                   	std
  80121f:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  801222:	fc                   	cld
  801223:	c3                   	ret
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  801224:	48 83 ef 01          	sub    $0x1,%rdi
  801228:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  80122c:	fd                   	std
  80122d:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  80122f:	eb f1                	jmp    801222 <memmove+0x3b>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  801231:	48 89 f2             	mov    %rsi,%rdx
  801234:	48 09 c2             	or     %rax,%rdx
  801237:	48 09 ca             	or     %rcx,%rdx
  80123a:	f6 c2 07             	test   $0x7,%dl
  80123d:	75 0c                	jne    80124b <memmove+0x64>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  80123f:	48 c1 e9 03          	shr    $0x3,%rcx
  801243:	48 89 c7             	mov    %rax,%rdi
  801246:	fc                   	cld
  801247:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  80124a:	c3                   	ret
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  80124b:	48 89 c7             	mov    %rax,%rdi
  80124e:	fc                   	cld
  80124f:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  801251:	c3                   	ret

0000000000801252 <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  801252:	f3 0f 1e fa          	endbr64
  801256:	55                   	push   %rbp
  801257:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  80125a:	48 b8 e7 11 80 00 00 	movabs $0x8011e7,%rax
  801261:	00 00 00 
  801264:	ff d0                	call   *%rax
}
  801266:	5d                   	pop    %rbp
  801267:	c3                   	ret

0000000000801268 <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  801268:	f3 0f 1e fa          	endbr64
  80126c:	55                   	push   %rbp
  80126d:	48 89 e5             	mov    %rsp,%rbp
  801270:	41 57                	push   %r15
  801272:	41 56                	push   %r14
  801274:	41 55                	push   %r13
  801276:	41 54                	push   %r12
  801278:	53                   	push   %rbx
  801279:	48 83 ec 08          	sub    $0x8,%rsp
  80127d:	49 89 fe             	mov    %rdi,%r14
  801280:	49 89 f7             	mov    %rsi,%r15
  801283:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  801286:	48 89 f7             	mov    %rsi,%rdi
  801289:	48 b8 87 0f 80 00 00 	movabs $0x800f87,%rax
  801290:	00 00 00 
  801293:	ff d0                	call   *%rax
  801295:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  801298:	48 89 de             	mov    %rbx,%rsi
  80129b:	4c 89 f7             	mov    %r14,%rdi
  80129e:	48 b8 a6 0f 80 00 00 	movabs $0x800fa6,%rax
  8012a5:	00 00 00 
  8012a8:	ff d0                	call   *%rax
  8012aa:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  8012ad:	48 39 c3             	cmp    %rax,%rbx
  8012b0:	74 36                	je     8012e8 <strlcat+0x80>
    if (srclen < maxlen - dstlen) {
  8012b2:	48 89 d8             	mov    %rbx,%rax
  8012b5:	4c 29 e8             	sub    %r13,%rax
  8012b8:	49 39 c4             	cmp    %rax,%r12
  8012bb:	73 31                	jae    8012ee <strlcat+0x86>
        memcpy(dst + dstlen, src, srclen + 1);
  8012bd:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  8012c2:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  8012c6:	4c 89 fe             	mov    %r15,%rsi
  8012c9:	48 b8 52 12 80 00 00 	movabs $0x801252,%rax
  8012d0:	00 00 00 
  8012d3:	ff d0                	call   *%rax
    return dstlen + srclen;
  8012d5:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  8012d9:	48 83 c4 08          	add    $0x8,%rsp
  8012dd:	5b                   	pop    %rbx
  8012de:	41 5c                	pop    %r12
  8012e0:	41 5d                	pop    %r13
  8012e2:	41 5e                	pop    %r14
  8012e4:	41 5f                	pop    %r15
  8012e6:	5d                   	pop    %rbp
  8012e7:	c3                   	ret
    if (dstlen == maxlen) return maxlen + srclen;
  8012e8:	49 8d 04 04          	lea    (%r12,%rax,1),%rax
  8012ec:	eb eb                	jmp    8012d9 <strlcat+0x71>
        memcpy(dst + dstlen, src, maxlen - 1);
  8012ee:	48 83 eb 01          	sub    $0x1,%rbx
  8012f2:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  8012f6:	48 89 da             	mov    %rbx,%rdx
  8012f9:	4c 89 fe             	mov    %r15,%rsi
  8012fc:	48 b8 52 12 80 00 00 	movabs $0x801252,%rax
  801303:	00 00 00 
  801306:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  801308:	49 01 de             	add    %rbx,%r14
  80130b:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  801310:	eb c3                	jmp    8012d5 <strlcat+0x6d>

0000000000801312 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  801312:	f3 0f 1e fa          	endbr64
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  801316:	48 85 d2             	test   %rdx,%rdx
  801319:	74 2d                	je     801348 <memcmp+0x36>
  80131b:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  801320:	0f b6 0c 07          	movzbl (%rdi,%rax,1),%ecx
  801324:	44 0f b6 04 06       	movzbl (%rsi,%rax,1),%r8d
  801329:	44 38 c1             	cmp    %r8b,%cl
  80132c:	75 0f                	jne    80133d <memcmp+0x2b>
    while (n-- > 0) {
  80132e:	48 83 c0 01          	add    $0x1,%rax
  801332:	48 39 c2             	cmp    %rax,%rdx
  801335:	75 e9                	jne    801320 <memcmp+0xe>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  801337:	b8 00 00 00 00       	mov    $0x0,%eax
  80133c:	c3                   	ret
            return (int)*s1 - (int)*s2;
  80133d:	0f b6 c1             	movzbl %cl,%eax
  801340:	45 0f b6 c0          	movzbl %r8b,%r8d
  801344:	44 29 c0             	sub    %r8d,%eax
  801347:	c3                   	ret
    return 0;
  801348:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80134d:	c3                   	ret

000000000080134e <memfind>:

void *
memfind(const void *src, int c, size_t n) {
  80134e:	f3 0f 1e fa          	endbr64
    const void *end = (const char *)src + n;
  801352:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  801356:	48 39 c7             	cmp    %rax,%rdi
  801359:	73 0f                	jae    80136a <memfind+0x1c>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  80135b:	40 38 37             	cmp    %sil,(%rdi)
  80135e:	74 0e                	je     80136e <memfind+0x20>
    for (; src < end; src++) {
  801360:	48 83 c7 01          	add    $0x1,%rdi
  801364:	48 39 f8             	cmp    %rdi,%rax
  801367:	75 f2                	jne    80135b <memfind+0xd>
  801369:	c3                   	ret
  80136a:	48 89 f8             	mov    %rdi,%rax
  80136d:	c3                   	ret
  80136e:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  801371:	c3                   	ret

0000000000801372 <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  801372:	f3 0f 1e fa          	endbr64
  801376:	49 89 f2             	mov    %rsi,%r10
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  801379:	0f b6 37             	movzbl (%rdi),%esi
  80137c:	40 80 fe 20          	cmp    $0x20,%sil
  801380:	74 06                	je     801388 <strtol+0x16>
  801382:	40 80 fe 09          	cmp    $0x9,%sil
  801386:	75 13                	jne    80139b <strtol+0x29>
  801388:	48 83 c7 01          	add    $0x1,%rdi
  80138c:	0f b6 37             	movzbl (%rdi),%esi
  80138f:	40 80 fe 20          	cmp    $0x20,%sil
  801393:	74 f3                	je     801388 <strtol+0x16>
  801395:	40 80 fe 09          	cmp    $0x9,%sil
  801399:	74 ed                	je     801388 <strtol+0x16>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  80139b:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  80139e:	83 e0 fd             	and    $0xfffffffd,%eax
  8013a1:	3c 01                	cmp    $0x1,%al
  8013a3:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  8013a7:	f7 c2 ef ff ff ff    	test   $0xffffffef,%edx
  8013ad:	75 0f                	jne    8013be <strtol+0x4c>
  8013af:	80 3f 30             	cmpb   $0x30,(%rdi)
  8013b2:	74 14                	je     8013c8 <strtol+0x56>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  8013b4:	85 d2                	test   %edx,%edx
  8013b6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8013bb:	0f 44 d0             	cmove  %eax,%edx
    }

    /* Digits */
    long val = 0;
  8013be:	b8 00 00 00 00       	mov    $0x0,%eax
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  8013c3:	4c 63 ca             	movslq %edx,%r9
  8013c6:	eb 36                	jmp    8013fe <strtol+0x8c>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  8013c8:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  8013cc:	74 0f                	je     8013dd <strtol+0x6b>
    } else if (!base && s[0] == '0') {
  8013ce:	85 d2                	test   %edx,%edx
  8013d0:	75 ec                	jne    8013be <strtol+0x4c>
        s++;
  8013d2:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  8013d6:	ba 08 00 00 00       	mov    $0x8,%edx
        s++;
  8013db:	eb e1                	jmp    8013be <strtol+0x4c>
        s += 2;
  8013dd:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  8013e1:	ba 10 00 00 00       	mov    $0x10,%edx
        s += 2;
  8013e6:	eb d6                	jmp    8013be <strtol+0x4c>
            dig -= '0';
  8013e8:	83 e9 30             	sub    $0x30,%ecx
        if (dig >= base) break;
  8013eb:	44 0f b6 c1          	movzbl %cl,%r8d
  8013ef:	41 39 d0             	cmp    %edx,%r8d
  8013f2:	7d 21                	jge    801415 <strtol+0xa3>
        val = val * base + dig;
  8013f4:	49 0f af c1          	imul   %r9,%rax
  8013f8:	0f b6 c9             	movzbl %cl,%ecx
  8013fb:	48 01 c8             	add    %rcx,%rax
        uint8_t dig = *s++;
  8013fe:	48 83 c7 01          	add    $0x1,%rdi
  801402:	0f b6 4f ff          	movzbl -0x1(%rdi),%ecx
        if (dig - '0' < 10)
  801406:	80 f9 39             	cmp    $0x39,%cl
  801409:	76 dd                	jbe    8013e8 <strtol+0x76>
        else if (dig - 'a' < 27)
  80140b:	80 f9 7b             	cmp    $0x7b,%cl
  80140e:	77 05                	ja     801415 <strtol+0xa3>
            dig -= 'a' - 10;
  801410:	83 e9 57             	sub    $0x57,%ecx
  801413:	eb d6                	jmp    8013eb <strtol+0x79>
    }

    if (endptr) *endptr = (char *)s;
  801415:	4d 85 d2             	test   %r10,%r10
  801418:	74 03                	je     80141d <strtol+0xab>
  80141a:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  80141d:	48 89 c2             	mov    %rax,%rdx
  801420:	48 f7 da             	neg    %rdx
  801423:	40 80 fe 2d          	cmp    $0x2d,%sil
  801427:	48 0f 44 c2          	cmove  %rdx,%rax
}
  80142b:	c3                   	ret

000000000080142c <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  80142c:	f3 0f 1e fa          	endbr64
  801430:	55                   	push   %rbp
  801431:	48 89 e5             	mov    %rsp,%rbp
  801434:	53                   	push   %rbx
  801435:	48 89 fa             	mov    %rdi,%rdx
  801438:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80143b:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801440:	bb 00 00 00 00       	mov    $0x0,%ebx
  801445:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80144a:	be 00 00 00 00       	mov    $0x0,%esi
  80144f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801455:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  801457:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80145b:	c9                   	leave
  80145c:	c3                   	ret

000000000080145d <sys_cgetc>:

int
sys_cgetc(void) {
  80145d:	f3 0f 1e fa          	endbr64
  801461:	55                   	push   %rbp
  801462:	48 89 e5             	mov    %rsp,%rbp
  801465:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801466:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80146b:	ba 00 00 00 00       	mov    $0x0,%edx
  801470:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801475:	bb 00 00 00 00       	mov    $0x0,%ebx
  80147a:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80147f:	be 00 00 00 00       	mov    $0x0,%esi
  801484:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80148a:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  80148c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801490:	c9                   	leave
  801491:	c3                   	ret

0000000000801492 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  801492:	f3 0f 1e fa          	endbr64
  801496:	55                   	push   %rbp
  801497:	48 89 e5             	mov    %rsp,%rbp
  80149a:	53                   	push   %rbx
  80149b:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  80149f:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8014a2:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8014a7:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8014ac:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014b1:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8014b6:	be 00 00 00 00       	mov    $0x0,%esi
  8014bb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8014c1:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8014c3:	48 85 c0             	test   %rax,%rax
  8014c6:	7f 06                	jg     8014ce <sys_env_destroy+0x3c>
}
  8014c8:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014cc:	c9                   	leave
  8014cd:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8014ce:	49 89 c0             	mov    %rax,%r8
  8014d1:	b9 03 00 00 00       	mov    $0x3,%ecx
  8014d6:	48 ba 28 43 80 00 00 	movabs $0x804328,%rdx
  8014dd:	00 00 00 
  8014e0:	be 26 00 00 00       	mov    $0x26,%esi
  8014e5:	48 bf 02 42 80 00 00 	movabs $0x804202,%rdi
  8014ec:	00 00 00 
  8014ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8014f4:	49 b9 27 05 80 00 00 	movabs $0x800527,%r9
  8014fb:	00 00 00 
  8014fe:	41 ff d1             	call   *%r9

0000000000801501 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  801501:	f3 0f 1e fa          	endbr64
  801505:	55                   	push   %rbp
  801506:	48 89 e5             	mov    %rsp,%rbp
  801509:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80150a:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80150f:	ba 00 00 00 00       	mov    $0x0,%edx
  801514:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801519:	bb 00 00 00 00       	mov    $0x0,%ebx
  80151e:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801523:	be 00 00 00 00       	mov    $0x0,%esi
  801528:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80152e:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  801530:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801534:	c9                   	leave
  801535:	c3                   	ret

0000000000801536 <sys_yield>:

void
sys_yield(void) {
  801536:	f3 0f 1e fa          	endbr64
  80153a:	55                   	push   %rbp
  80153b:	48 89 e5             	mov    %rsp,%rbp
  80153e:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80153f:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801544:	ba 00 00 00 00       	mov    $0x0,%edx
  801549:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80154e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801553:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801558:	be 00 00 00 00       	mov    $0x0,%esi
  80155d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801563:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  801565:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801569:	c9                   	leave
  80156a:	c3                   	ret

000000000080156b <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  80156b:	f3 0f 1e fa          	endbr64
  80156f:	55                   	push   %rbp
  801570:	48 89 e5             	mov    %rsp,%rbp
  801573:	53                   	push   %rbx
  801574:	48 89 fa             	mov    %rdi,%rdx
  801577:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80157a:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80157f:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  801586:	00 00 00 
  801589:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80158e:	be 00 00 00 00       	mov    $0x0,%esi
  801593:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801599:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  80159b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80159f:	c9                   	leave
  8015a0:	c3                   	ret

00000000008015a1 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  8015a1:	f3 0f 1e fa          	endbr64
  8015a5:	55                   	push   %rbp
  8015a6:	48 89 e5             	mov    %rsp,%rbp
  8015a9:	53                   	push   %rbx
  8015aa:	49 89 f8             	mov    %rdi,%r8
  8015ad:	48 89 d3             	mov    %rdx,%rbx
  8015b0:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  8015b3:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8015b8:	4c 89 c2             	mov    %r8,%rdx
  8015bb:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8015be:	be 00 00 00 00       	mov    $0x0,%esi
  8015c3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8015c9:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  8015cb:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8015cf:	c9                   	leave
  8015d0:	c3                   	ret

00000000008015d1 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  8015d1:	f3 0f 1e fa          	endbr64
  8015d5:	55                   	push   %rbp
  8015d6:	48 89 e5             	mov    %rsp,%rbp
  8015d9:	53                   	push   %rbx
  8015da:	48 83 ec 08          	sub    $0x8,%rsp
  8015de:	89 f8                	mov    %edi,%eax
  8015e0:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  8015e3:	48 63 f9             	movslq %ecx,%rdi
  8015e6:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8015e9:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8015ee:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8015f1:	be 00 00 00 00       	mov    $0x0,%esi
  8015f6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8015fc:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8015fe:	48 85 c0             	test   %rax,%rax
  801601:	7f 06                	jg     801609 <sys_alloc_region+0x38>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  801603:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801607:	c9                   	leave
  801608:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801609:	49 89 c0             	mov    %rax,%r8
  80160c:	b9 04 00 00 00       	mov    $0x4,%ecx
  801611:	48 ba 28 43 80 00 00 	movabs $0x804328,%rdx
  801618:	00 00 00 
  80161b:	be 26 00 00 00       	mov    $0x26,%esi
  801620:	48 bf 02 42 80 00 00 	movabs $0x804202,%rdi
  801627:	00 00 00 
  80162a:	b8 00 00 00 00       	mov    $0x0,%eax
  80162f:	49 b9 27 05 80 00 00 	movabs $0x800527,%r9
  801636:	00 00 00 
  801639:	41 ff d1             	call   *%r9

000000000080163c <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  80163c:	f3 0f 1e fa          	endbr64
  801640:	55                   	push   %rbp
  801641:	48 89 e5             	mov    %rsp,%rbp
  801644:	53                   	push   %rbx
  801645:	48 83 ec 08          	sub    $0x8,%rsp
  801649:	89 f8                	mov    %edi,%eax
  80164b:	49 89 f2             	mov    %rsi,%r10
  80164e:	48 89 cf             	mov    %rcx,%rdi
  801651:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  801654:	48 63 da             	movslq %edx,%rbx
  801657:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80165a:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80165f:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801662:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  801665:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801667:	48 85 c0             	test   %rax,%rax
  80166a:	7f 06                	jg     801672 <sys_map_region+0x36>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  80166c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801670:	c9                   	leave
  801671:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801672:	49 89 c0             	mov    %rax,%r8
  801675:	b9 05 00 00 00       	mov    $0x5,%ecx
  80167a:	48 ba 28 43 80 00 00 	movabs $0x804328,%rdx
  801681:	00 00 00 
  801684:	be 26 00 00 00       	mov    $0x26,%esi
  801689:	48 bf 02 42 80 00 00 	movabs $0x804202,%rdi
  801690:	00 00 00 
  801693:	b8 00 00 00 00       	mov    $0x0,%eax
  801698:	49 b9 27 05 80 00 00 	movabs $0x800527,%r9
  80169f:	00 00 00 
  8016a2:	41 ff d1             	call   *%r9

00000000008016a5 <sys_map_physical_region>:

int
sys_map_physical_region(uintptr_t pa, envid_t dstenv, void *dstva, size_t size, int perm) {
  8016a5:	f3 0f 1e fa          	endbr64
  8016a9:	55                   	push   %rbp
  8016aa:	48 89 e5             	mov    %rsp,%rbp
  8016ad:	53                   	push   %rbx
  8016ae:	48 83 ec 08          	sub    $0x8,%rsp
  8016b2:	49 89 f9             	mov    %rdi,%r9
  8016b5:	89 f0                	mov    %esi,%eax
  8016b7:	48 89 d3             	mov    %rdx,%rbx
  8016ba:	48 89 cf             	mov    %rcx,%rdi
    int res = syscall(SYS_map_physical_region, 1, pa, dstenv, (uintptr_t)dstva, size, perm, 0);
  8016bd:	49 63 f0             	movslq %r8d,%rsi
  8016c0:	48 63 c8             	movslq %eax,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8016c3:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8016c8:	4c 89 ca             	mov    %r9,%rdx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8016cb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8016d1:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8016d3:	48 85 c0             	test   %rax,%rax
  8016d6:	7f 06                	jg     8016de <sys_map_physical_region+0x39>
#ifdef SANITIZE_USER_SHADOW_BASE
    platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  8016d8:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8016dc:	c9                   	leave
  8016dd:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8016de:	49 89 c0             	mov    %rax,%r8
  8016e1:	b9 06 00 00 00       	mov    $0x6,%ecx
  8016e6:	48 ba 28 43 80 00 00 	movabs $0x804328,%rdx
  8016ed:	00 00 00 
  8016f0:	be 26 00 00 00       	mov    $0x26,%esi
  8016f5:	48 bf 02 42 80 00 00 	movabs $0x804202,%rdi
  8016fc:	00 00 00 
  8016ff:	b8 00 00 00 00       	mov    $0x0,%eax
  801704:	49 b9 27 05 80 00 00 	movabs $0x800527,%r9
  80170b:	00 00 00 
  80170e:	41 ff d1             	call   *%r9

0000000000801711 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  801711:	f3 0f 1e fa          	endbr64
  801715:	55                   	push   %rbp
  801716:	48 89 e5             	mov    %rsp,%rbp
  801719:	53                   	push   %rbx
  80171a:	48 83 ec 08          	sub    $0x8,%rsp
  80171e:	48 89 f1             	mov    %rsi,%rcx
  801721:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  801724:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801727:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80172c:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801731:	be 00 00 00 00       	mov    $0x0,%esi
  801736:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80173c:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80173e:	48 85 c0             	test   %rax,%rax
  801741:	7f 06                	jg     801749 <sys_unmap_region+0x38>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  801743:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801747:	c9                   	leave
  801748:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801749:	49 89 c0             	mov    %rax,%r8
  80174c:	b9 07 00 00 00       	mov    $0x7,%ecx
  801751:	48 ba 28 43 80 00 00 	movabs $0x804328,%rdx
  801758:	00 00 00 
  80175b:	be 26 00 00 00       	mov    $0x26,%esi
  801760:	48 bf 02 42 80 00 00 	movabs $0x804202,%rdi
  801767:	00 00 00 
  80176a:	b8 00 00 00 00       	mov    $0x0,%eax
  80176f:	49 b9 27 05 80 00 00 	movabs $0x800527,%r9
  801776:	00 00 00 
  801779:	41 ff d1             	call   *%r9

000000000080177c <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  80177c:	f3 0f 1e fa          	endbr64
  801780:	55                   	push   %rbp
  801781:	48 89 e5             	mov    %rsp,%rbp
  801784:	53                   	push   %rbx
  801785:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  801789:	48 63 ce             	movslq %esi,%rcx
  80178c:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80178f:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801794:	bb 00 00 00 00       	mov    $0x0,%ebx
  801799:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80179e:	be 00 00 00 00       	mov    $0x0,%esi
  8017a3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8017a9:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8017ab:	48 85 c0             	test   %rax,%rax
  8017ae:	7f 06                	jg     8017b6 <sys_env_set_status+0x3a>
}
  8017b0:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8017b4:	c9                   	leave
  8017b5:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8017b6:	49 89 c0             	mov    %rax,%r8
  8017b9:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8017be:	48 ba 28 43 80 00 00 	movabs $0x804328,%rdx
  8017c5:	00 00 00 
  8017c8:	be 26 00 00 00       	mov    $0x26,%esi
  8017cd:	48 bf 02 42 80 00 00 	movabs $0x804202,%rdi
  8017d4:	00 00 00 
  8017d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8017dc:	49 b9 27 05 80 00 00 	movabs $0x800527,%r9
  8017e3:	00 00 00 
  8017e6:	41 ff d1             	call   *%r9

00000000008017e9 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  8017e9:	f3 0f 1e fa          	endbr64
  8017ed:	55                   	push   %rbp
  8017ee:	48 89 e5             	mov    %rsp,%rbp
  8017f1:	53                   	push   %rbx
  8017f2:	48 83 ec 08          	sub    $0x8,%rsp
  8017f6:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  8017f9:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8017fc:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801801:	bb 00 00 00 00       	mov    $0x0,%ebx
  801806:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80180b:	be 00 00 00 00       	mov    $0x0,%esi
  801810:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801816:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801818:	48 85 c0             	test   %rax,%rax
  80181b:	7f 06                	jg     801823 <sys_env_set_trapframe+0x3a>
}
  80181d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801821:	c9                   	leave
  801822:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801823:	49 89 c0             	mov    %rax,%r8
  801826:	b9 0b 00 00 00       	mov    $0xb,%ecx
  80182b:	48 ba 28 43 80 00 00 	movabs $0x804328,%rdx
  801832:	00 00 00 
  801835:	be 26 00 00 00       	mov    $0x26,%esi
  80183a:	48 bf 02 42 80 00 00 	movabs $0x804202,%rdi
  801841:	00 00 00 
  801844:	b8 00 00 00 00       	mov    $0x0,%eax
  801849:	49 b9 27 05 80 00 00 	movabs $0x800527,%r9
  801850:	00 00 00 
  801853:	41 ff d1             	call   *%r9

0000000000801856 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  801856:	f3 0f 1e fa          	endbr64
  80185a:	55                   	push   %rbp
  80185b:	48 89 e5             	mov    %rsp,%rbp
  80185e:	53                   	push   %rbx
  80185f:	48 83 ec 08          	sub    $0x8,%rsp
  801863:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  801866:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801869:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80186e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801873:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801878:	be 00 00 00 00       	mov    $0x0,%esi
  80187d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801883:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801885:	48 85 c0             	test   %rax,%rax
  801888:	7f 06                	jg     801890 <sys_env_set_pgfault_upcall+0x3a>
}
  80188a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80188e:	c9                   	leave
  80188f:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801890:	49 89 c0             	mov    %rax,%r8
  801893:	b9 0c 00 00 00       	mov    $0xc,%ecx
  801898:	48 ba 28 43 80 00 00 	movabs $0x804328,%rdx
  80189f:	00 00 00 
  8018a2:	be 26 00 00 00       	mov    $0x26,%esi
  8018a7:	48 bf 02 42 80 00 00 	movabs $0x804202,%rdi
  8018ae:	00 00 00 
  8018b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8018b6:	49 b9 27 05 80 00 00 	movabs $0x800527,%r9
  8018bd:	00 00 00 
  8018c0:	41 ff d1             	call   *%r9

00000000008018c3 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  8018c3:	f3 0f 1e fa          	endbr64
  8018c7:	55                   	push   %rbp
  8018c8:	48 89 e5             	mov    %rsp,%rbp
  8018cb:	53                   	push   %rbx
  8018cc:	89 f8                	mov    %edi,%eax
  8018ce:	49 89 f1             	mov    %rsi,%r9
  8018d1:	48 89 d3             	mov    %rdx,%rbx
  8018d4:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  8018d7:	49 63 f0             	movslq %r8d,%rsi
  8018da:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8018dd:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8018e2:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8018e5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8018eb:	cd 30                	int    $0x30
}
  8018ed:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8018f1:	c9                   	leave
  8018f2:	c3                   	ret

00000000008018f3 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  8018f3:	f3 0f 1e fa          	endbr64
  8018f7:	55                   	push   %rbp
  8018f8:	48 89 e5             	mov    %rsp,%rbp
  8018fb:	53                   	push   %rbx
  8018fc:	48 83 ec 08          	sub    $0x8,%rsp
  801900:	48 89 fa             	mov    %rdi,%rdx
  801903:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801906:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80190b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801910:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801915:	be 00 00 00 00       	mov    $0x0,%esi
  80191a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801920:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801922:	48 85 c0             	test   %rax,%rax
  801925:	7f 06                	jg     80192d <sys_ipc_recv+0x3a>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  801927:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80192b:	c9                   	leave
  80192c:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80192d:	49 89 c0             	mov    %rax,%r8
  801930:	b9 0f 00 00 00       	mov    $0xf,%ecx
  801935:	48 ba 28 43 80 00 00 	movabs $0x804328,%rdx
  80193c:	00 00 00 
  80193f:	be 26 00 00 00       	mov    $0x26,%esi
  801944:	48 bf 02 42 80 00 00 	movabs $0x804202,%rdi
  80194b:	00 00 00 
  80194e:	b8 00 00 00 00       	mov    $0x0,%eax
  801953:	49 b9 27 05 80 00 00 	movabs $0x800527,%r9
  80195a:	00 00 00 
  80195d:	41 ff d1             	call   *%r9

0000000000801960 <sys_gettime>:

int
sys_gettime(void) {
  801960:	f3 0f 1e fa          	endbr64
  801964:	55                   	push   %rbp
  801965:	48 89 e5             	mov    %rsp,%rbp
  801968:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801969:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80196e:	ba 00 00 00 00       	mov    $0x0,%edx
  801973:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801978:	bb 00 00 00 00       	mov    $0x0,%ebx
  80197d:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801982:	be 00 00 00 00       	mov    $0x0,%esi
  801987:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80198d:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  80198f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801993:	c9                   	leave
  801994:	c3                   	ret

0000000000801995 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args) {
  801995:	f3 0f 1e fa          	endbr64
    args->argc = argc;
  801999:	48 89 3a             	mov    %rdi,(%rdx)
    args->argv = (const char **)argv;
  80199c:	48 89 72 08          	mov    %rsi,0x8(%rdx)
    args->curarg = (*argc > 1 && argv ? "" : NULL);
  8019a0:	83 3f 01             	cmpl   $0x1,(%rdi)
  8019a3:	7e 0f                	jle    8019b4 <argstart+0x1f>
  8019a5:	48 b8 68 40 80 00 00 	movabs $0x804068,%rax
  8019ac:	00 00 00 
  8019af:	48 85 f6             	test   %rsi,%rsi
  8019b2:	75 05                	jne    8019b9 <argstart+0x24>
  8019b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8019b9:	48 89 42 10          	mov    %rax,0x10(%rdx)
    args->argvalue = 0;
  8019bd:	48 c7 42 18 00 00 00 	movq   $0x0,0x18(%rdx)
  8019c4:	00 
}
  8019c5:	c3                   	ret

00000000008019c6 <argnext>:

int
argnext(struct Argstate *args) {
  8019c6:	f3 0f 1e fa          	endbr64
    int arg;

    args->argvalue = 0;
  8019ca:	48 c7 47 18 00 00 00 	movq   $0x0,0x18(%rdi)
  8019d1:	00 

    /* Done processing arguments if args->curarg == 0 */
    if (args->curarg == 0) return -1;
  8019d2:	48 8b 47 10          	mov    0x10(%rdi),%rax
  8019d6:	48 85 c0             	test   %rax,%rax
  8019d9:	0f 84 8f 00 00 00    	je     801a6e <argnext+0xa8>
argnext(struct Argstate *args) {
  8019df:	55                   	push   %rbp
  8019e0:	48 89 e5             	mov    %rsp,%rbp
  8019e3:	53                   	push   %rbx
  8019e4:	48 83 ec 08          	sub    $0x8,%rsp
  8019e8:	48 89 fb             	mov    %rdi,%rbx

    if (!*args->curarg) {
  8019eb:	80 38 00             	cmpb   $0x0,(%rax)
  8019ee:	75 52                	jne    801a42 <argnext+0x7c>
        /* Need to process the next argument
         * Check for end of argument list */
        if (*args->argc == 1 ||
  8019f0:	48 8b 17             	mov    (%rdi),%rdx
  8019f3:	83 3a 01             	cmpl   $0x1,(%rdx)
  8019f6:	74 67                	je     801a5f <argnext+0x99>
            args->argv[1][0] != '-' ||
  8019f8:	48 8b 7f 08          	mov    0x8(%rdi),%rdi
  8019fc:	48 8b 47 08          	mov    0x8(%rdi),%rax
        if (*args->argc == 1 ||
  801a00:	80 38 2d             	cmpb   $0x2d,(%rax)
  801a03:	75 5a                	jne    801a5f <argnext+0x99>
            args->argv[1][0] != '-' ||
  801a05:	80 78 01 00          	cmpb   $0x0,0x1(%rax)
  801a09:	74 54                	je     801a5f <argnext+0x99>
            args->argv[1][1] == '\0') goto endofargs;

        /* Shift arguments down one */
        args->curarg = args->argv[1] + 1;
  801a0b:	48 83 c0 01          	add    $0x1,%rax
  801a0f:	48 89 43 10          	mov    %rax,0x10(%rbx)
        memmove(args->argv + 1, args->argv + 2, sizeof(*args->argv) * (*args->argc - 1));
  801a13:	8b 12                	mov    (%rdx),%edx
  801a15:	83 ea 01             	sub    $0x1,%edx
  801a18:	48 63 d2             	movslq %edx,%rdx
  801a1b:	48 c1 e2 03          	shl    $0x3,%rdx
  801a1f:	48 8d 77 10          	lea    0x10(%rdi),%rsi
  801a23:	48 83 c7 08          	add    $0x8,%rdi
  801a27:	48 b8 e7 11 80 00 00 	movabs $0x8011e7,%rax
  801a2e:	00 00 00 
  801a31:	ff d0                	call   *%rax

        (*args->argc)--;
  801a33:	48 8b 03             	mov    (%rbx),%rax
  801a36:	83 28 01             	subl   $0x1,(%rax)

        /* Check for "--": end of argument list */
        if (args->curarg[0] == '-' &&
  801a39:	48 8b 43 10          	mov    0x10(%rbx),%rax
  801a3d:	80 38 2d             	cmpb   $0x2d,(%rax)
  801a40:	74 17                	je     801a59 <argnext+0x93>
            args->curarg[1] == '\0') goto endofargs;
    }

    arg = (unsigned char)*args->curarg;
  801a42:	48 8b 43 10          	mov    0x10(%rbx),%rax
  801a46:	0f b6 10             	movzbl (%rax),%edx
    args->curarg++;
  801a49:	48 83 c0 01          	add    $0x1,%rax
  801a4d:	48 89 43 10          	mov    %rax,0x10(%rbx)
    return arg;

endofargs:
    args->curarg = 0;
    return -1;
}
  801a51:	89 d0                	mov    %edx,%eax
  801a53:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801a57:	c9                   	leave
  801a58:	c3                   	ret
        if (args->curarg[0] == '-' &&
  801a59:	80 78 01 00          	cmpb   $0x0,0x1(%rax)
  801a5d:	75 e3                	jne    801a42 <argnext+0x7c>
    args->curarg = 0;
  801a5f:	48 c7 43 10 00 00 00 	movq   $0x0,0x10(%rbx)
  801a66:	00 
    return -1;
  801a67:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  801a6c:	eb e3                	jmp    801a51 <argnext+0x8b>
    if (args->curarg == 0) return -1;
  801a6e:	ba ff ff ff ff       	mov    $0xffffffff,%edx
}
  801a73:	89 d0                	mov    %edx,%eax
  801a75:	c3                   	ret

0000000000801a76 <argnextvalue>:
argvalue(struct Argstate *args) {
    return (char *)(args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args) {
  801a76:	f3 0f 1e fa          	endbr64
    if (!args->curarg) return 0;
  801a7a:	48 8b 47 10          	mov    0x10(%rdi),%rax
  801a7e:	48 85 c0             	test   %rax,%rax
  801a81:	74 7b                	je     801afe <argnextvalue+0x88>
argnextvalue(struct Argstate *args) {
  801a83:	55                   	push   %rbp
  801a84:	48 89 e5             	mov    %rsp,%rbp
  801a87:	53                   	push   %rbx
  801a88:	48 83 ec 08          	sub    $0x8,%rsp
  801a8c:	48 89 fb             	mov    %rdi,%rbx

    if (*args->curarg) {
  801a8f:	80 38 00             	cmpb   $0x0,(%rax)
  801a92:	74 1c                	je     801ab0 <argnextvalue+0x3a>
        args->argvalue = args->curarg;
  801a94:	48 89 47 18          	mov    %rax,0x18(%rdi)
        args->curarg = "";
  801a98:	48 b8 68 40 80 00 00 	movabs $0x804068,%rax
  801a9f:	00 00 00 
  801aa2:	48 89 47 10          	mov    %rax,0x10(%rdi)
    } else {
        args->argvalue = 0;
        args->curarg = 0;
    }

    return (char *)args->argvalue;
  801aa6:	48 8b 43 18          	mov    0x18(%rbx),%rax
}
  801aaa:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801aae:	c9                   	leave
  801aaf:	c3                   	ret
    } else if (*args->argc > 1) {
  801ab0:	48 8b 07             	mov    (%rdi),%rax
  801ab3:	83 38 01             	cmpl   $0x1,(%rax)
  801ab6:	7f 12                	jg     801aca <argnextvalue+0x54>
        args->argvalue = 0;
  801ab8:	48 c7 47 18 00 00 00 	movq   $0x0,0x18(%rdi)
  801abf:	00 
        args->curarg = 0;
  801ac0:	48 c7 47 10 00 00 00 	movq   $0x0,0x10(%rdi)
  801ac7:	00 
  801ac8:	eb dc                	jmp    801aa6 <argnextvalue+0x30>
        args->argvalue = args->argv[1];
  801aca:	48 8b 7f 08          	mov    0x8(%rdi),%rdi
  801ace:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  801ad2:	48 89 53 18          	mov    %rdx,0x18(%rbx)
        memmove(args->argv + 1, args->argv + 2, sizeof(*args->argv) * (*args->argc - 1));
  801ad6:	8b 10                	mov    (%rax),%edx
  801ad8:	83 ea 01             	sub    $0x1,%edx
  801adb:	48 63 d2             	movslq %edx,%rdx
  801ade:	48 c1 e2 03          	shl    $0x3,%rdx
  801ae2:	48 8d 77 10          	lea    0x10(%rdi),%rsi
  801ae6:	48 83 c7 08          	add    $0x8,%rdi
  801aea:	48 b8 e7 11 80 00 00 	movabs $0x8011e7,%rax
  801af1:	00 00 00 
  801af4:	ff d0                	call   *%rax
        (*args->argc)--;
  801af6:	48 8b 03             	mov    (%rbx),%rax
  801af9:	83 28 01             	subl   $0x1,(%rax)
  801afc:	eb a8                	jmp    801aa6 <argnextvalue+0x30>
}
  801afe:	c3                   	ret

0000000000801aff <argvalue>:
argvalue(struct Argstate *args) {
  801aff:	f3 0f 1e fa          	endbr64
    return (char *)(args->argvalue ? args->argvalue : argnextvalue(args));
  801b03:	48 8b 47 18          	mov    0x18(%rdi),%rax
  801b07:	48 85 c0             	test   %rax,%rax
  801b0a:	74 01                	je     801b0d <argvalue+0xe>
}
  801b0c:	c3                   	ret
argvalue(struct Argstate *args) {
  801b0d:	55                   	push   %rbp
  801b0e:	48 89 e5             	mov    %rsp,%rbp
    return (char *)(args->argvalue ? args->argvalue : argnextvalue(args));
  801b11:	48 b8 76 1a 80 00 00 	movabs $0x801a76,%rax
  801b18:	00 00 00 
  801b1b:	ff d0                	call   *%rax
}
  801b1d:	5d                   	pop    %rbp
  801b1e:	c3                   	ret

0000000000801b1f <fd2num>:


/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
  801b1f:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801b23:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801b2a:	ff ff ff 
  801b2d:	48 01 f8             	add    %rdi,%rax
  801b30:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801b34:	c3                   	ret

0000000000801b35 <fd2data>:

char *
fd2data(struct Fd *fd) {
  801b35:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801b39:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801b40:	ff ff ff 
  801b43:	48 01 f8             	add    %rdi,%rax
  801b46:	48 c1 e8 0c          	shr    $0xc,%rax
    return INDEX2DATA(fd2num(fd));
  801b4a:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801b50:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801b54:	c3                   	ret

0000000000801b55 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  801b55:	f3 0f 1e fa          	endbr64
  801b59:	55                   	push   %rbp
  801b5a:	48 89 e5             	mov    %rsp,%rbp
  801b5d:	41 57                	push   %r15
  801b5f:	41 56                	push   %r14
  801b61:	41 55                	push   %r13
  801b63:	41 54                	push   %r12
  801b65:	53                   	push   %rbx
  801b66:	48 83 ec 08          	sub    $0x8,%rsp
  801b6a:	49 89 ff             	mov    %rdi,%r15
  801b6d:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  801b72:	49 bd 6c 2e 80 00 00 	movabs $0x802e6c,%r13
  801b79:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  801b7c:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        struct Fd *fd = INDEX2FD(i);
  801b82:	49 89 dc             	mov    %rbx,%r12
        if (!(get_prot(fd) & PROT_R)) {
  801b85:	48 89 df             	mov    %rbx,%rdi
  801b88:	41 ff d5             	call   *%r13
  801b8b:	83 e0 04             	and    $0x4,%eax
  801b8e:	74 17                	je     801ba7 <fd_alloc+0x52>
    for (int i = 0; i < MAXFD; i++) {
  801b90:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  801b97:	4c 39 f3             	cmp    %r14,%rbx
  801b9a:	75 e6                	jne    801b82 <fd_alloc+0x2d>
  801b9c:	41 bc 00 00 00 00    	mov    $0x0,%r12d
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
    return -E_MAX_OPEN;
  801ba2:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
            *fd_store = fd;
  801ba7:	4d 89 27             	mov    %r12,(%r15)
}
  801baa:	48 83 c4 08          	add    $0x8,%rsp
  801bae:	5b                   	pop    %rbx
  801baf:	41 5c                	pop    %r12
  801bb1:	41 5d                	pop    %r13
  801bb3:	41 5e                	pop    %r14
  801bb5:	41 5f                	pop    %r15
  801bb7:	5d                   	pop    %rbp
  801bb8:	c3                   	ret

0000000000801bb9 <fd_lookup>:
 *
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
  801bb9:	f3 0f 1e fa          	endbr64
    if (fdnum < 0 || fdnum >= MAXFD) {
  801bbd:	83 ff 1f             	cmp    $0x1f,%edi
  801bc0:	77 39                	ja     801bfb <fd_lookup+0x42>
fd_lookup(int fdnum, struct Fd **fd_store) {
  801bc2:	55                   	push   %rbp
  801bc3:	48 89 e5             	mov    %rsp,%rbp
  801bc6:	41 54                	push   %r12
  801bc8:	53                   	push   %rbx
  801bc9:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  801bcc:	48 63 df             	movslq %edi,%rbx
  801bcf:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  801bd6:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  801bda:	48 89 df             	mov    %rbx,%rdi
  801bdd:	48 b8 6c 2e 80 00 00 	movabs $0x802e6c,%rax
  801be4:	00 00 00 
  801be7:	ff d0                	call   *%rax
  801be9:	a8 04                	test   $0x4,%al
  801beb:	74 14                	je     801c01 <fd_lookup+0x48>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  801bed:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  801bf1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bf6:	5b                   	pop    %rbx
  801bf7:	41 5c                	pop    %r12
  801bf9:	5d                   	pop    %rbp
  801bfa:	c3                   	ret
        return -E_INVAL;
  801bfb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801c00:	c3                   	ret
        return -E_INVAL;
  801c01:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c06:	eb ee                	jmp    801bf6 <fd_lookup+0x3d>

0000000000801c08 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  801c08:	f3 0f 1e fa          	endbr64
  801c0c:	55                   	push   %rbp
  801c0d:	48 89 e5             	mov    %rsp,%rbp
  801c10:	41 54                	push   %r12
  801c12:	53                   	push   %rbx
  801c13:	49 89 f4             	mov    %rsi,%r12
    for (size_t i = 0; devtab[i]; i++) {
  801c16:	48 b8 20 47 80 00 00 	movabs $0x804720,%rax
  801c1d:	00 00 00 
  801c20:	48 bb 20 50 80 00 00 	movabs $0x805020,%rbx
  801c27:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  801c2a:	39 3b                	cmp    %edi,(%rbx)
  801c2c:	74 47                	je     801c75 <dev_lookup+0x6d>
    for (size_t i = 0; devtab[i]; i++) {
  801c2e:	48 83 c0 08          	add    $0x8,%rax
  801c32:	48 8b 18             	mov    (%rax),%rbx
  801c35:	48 85 db             	test   %rbx,%rbx
  801c38:	75 f0                	jne    801c2a <dev_lookup+0x22>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801c3a:	48 a1 00 64 80 00 00 	movabs 0x806400,%rax
  801c41:	00 00 00 
  801c44:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801c4a:	89 fa                	mov    %edi,%edx
  801c4c:	48 bf 48 43 80 00 00 	movabs $0x804348,%rdi
  801c53:	00 00 00 
  801c56:	b8 00 00 00 00       	mov    $0x0,%eax
  801c5b:	48 b9 83 06 80 00 00 	movabs $0x800683,%rcx
  801c62:	00 00 00 
  801c65:	ff d1                	call   *%rcx
    *dev = 0;
    return -E_INVAL;
  801c67:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
            *dev = devtab[i];
  801c6c:	49 89 1c 24          	mov    %rbx,(%r12)
}
  801c70:	5b                   	pop    %rbx
  801c71:	41 5c                	pop    %r12
  801c73:	5d                   	pop    %rbp
  801c74:	c3                   	ret
            return 0;
  801c75:	b8 00 00 00 00       	mov    $0x0,%eax
  801c7a:	eb f0                	jmp    801c6c <dev_lookup+0x64>

0000000000801c7c <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  801c7c:	f3 0f 1e fa          	endbr64
  801c80:	55                   	push   %rbp
  801c81:	48 89 e5             	mov    %rsp,%rbp
  801c84:	41 55                	push   %r13
  801c86:	41 54                	push   %r12
  801c88:	53                   	push   %rbx
  801c89:	48 83 ec 18          	sub    $0x18,%rsp
  801c8d:	48 89 fb             	mov    %rdi,%rbx
  801c90:	41 89 f4             	mov    %esi,%r12d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801c93:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  801c9a:	ff ff ff 
  801c9d:	48 01 df             	add    %rbx,%rdi
  801ca0:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  801ca4:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801ca8:	48 b8 b9 1b 80 00 00 	movabs $0x801bb9,%rax
  801caf:	00 00 00 
  801cb2:	ff d0                	call   *%rax
  801cb4:	41 89 c5             	mov    %eax,%r13d
  801cb7:	85 c0                	test   %eax,%eax
  801cb9:	78 06                	js     801cc1 <fd_close+0x45>
  801cbb:	48 39 5d d8          	cmp    %rbx,-0x28(%rbp)
  801cbf:	74 1a                	je     801cdb <fd_close+0x5f>
        return (must_exist ? res : 0);
  801cc1:	45 84 e4             	test   %r12b,%r12b
  801cc4:	b8 00 00 00 00       	mov    $0x0,%eax
  801cc9:	44 0f 44 e8          	cmove  %eax,%r13d
}
  801ccd:	44 89 e8             	mov    %r13d,%eax
  801cd0:	48 83 c4 18          	add    $0x18,%rsp
  801cd4:	5b                   	pop    %rbx
  801cd5:	41 5c                	pop    %r12
  801cd7:	41 5d                	pop    %r13
  801cd9:	5d                   	pop    %rbp
  801cda:	c3                   	ret
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801cdb:	8b 3b                	mov    (%rbx),%edi
  801cdd:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801ce1:	48 b8 08 1c 80 00 00 	movabs $0x801c08,%rax
  801ce8:	00 00 00 
  801ceb:	ff d0                	call   *%rax
  801ced:	41 89 c5             	mov    %eax,%r13d
  801cf0:	85 c0                	test   %eax,%eax
  801cf2:	78 1b                	js     801d0f <fd_close+0x93>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  801cf4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801cf8:	48 8b 40 20          	mov    0x20(%rax),%rax
  801cfc:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  801d02:	48 85 c0             	test   %rax,%rax
  801d05:	74 08                	je     801d0f <fd_close+0x93>
  801d07:	48 89 df             	mov    %rbx,%rdi
  801d0a:	ff d0                	call   *%rax
  801d0c:	41 89 c5             	mov    %eax,%r13d
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801d0f:	ba 00 10 00 00       	mov    $0x1000,%edx
  801d14:	48 89 de             	mov    %rbx,%rsi
  801d17:	bf 00 00 00 00       	mov    $0x0,%edi
  801d1c:	48 b8 11 17 80 00 00 	movabs $0x801711,%rax
  801d23:	00 00 00 
  801d26:	ff d0                	call   *%rax
    return res;
  801d28:	eb a3                	jmp    801ccd <fd_close+0x51>

0000000000801d2a <close>:

int
close(int fdnum) {
  801d2a:	f3 0f 1e fa          	endbr64
  801d2e:	55                   	push   %rbp
  801d2f:	48 89 e5             	mov    %rsp,%rbp
  801d32:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  801d36:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801d3a:	48 b8 b9 1b 80 00 00 	movabs $0x801bb9,%rax
  801d41:	00 00 00 
  801d44:	ff d0                	call   *%rax
    if (res < 0) return res;
  801d46:	85 c0                	test   %eax,%eax
  801d48:	78 15                	js     801d5f <close+0x35>

    return fd_close(fd, 1);
  801d4a:	be 01 00 00 00       	mov    $0x1,%esi
  801d4f:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801d53:	48 b8 7c 1c 80 00 00 	movabs $0x801c7c,%rax
  801d5a:	00 00 00 
  801d5d:	ff d0                	call   *%rax
}
  801d5f:	c9                   	leave
  801d60:	c3                   	ret

0000000000801d61 <close_all>:

void
close_all(void) {
  801d61:	f3 0f 1e fa          	endbr64
  801d65:	55                   	push   %rbp
  801d66:	48 89 e5             	mov    %rsp,%rbp
  801d69:	41 54                	push   %r12
  801d6b:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  801d6c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d71:	49 bc 2a 1d 80 00 00 	movabs $0x801d2a,%r12
  801d78:	00 00 00 
  801d7b:	89 df                	mov    %ebx,%edi
  801d7d:	41 ff d4             	call   *%r12
  801d80:	83 c3 01             	add    $0x1,%ebx
  801d83:	83 fb 20             	cmp    $0x20,%ebx
  801d86:	75 f3                	jne    801d7b <close_all+0x1a>
}
  801d88:	5b                   	pop    %rbx
  801d89:	41 5c                	pop    %r12
  801d8b:	5d                   	pop    %rbp
  801d8c:	c3                   	ret

0000000000801d8d <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  801d8d:	f3 0f 1e fa          	endbr64
  801d91:	55                   	push   %rbp
  801d92:	48 89 e5             	mov    %rsp,%rbp
  801d95:	41 57                	push   %r15
  801d97:	41 56                	push   %r14
  801d99:	41 55                	push   %r13
  801d9b:	41 54                	push   %r12
  801d9d:	53                   	push   %rbx
  801d9e:	48 83 ec 18          	sub    $0x18,%rsp
  801da2:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  801da5:	48 8d 75 c8          	lea    -0x38(%rbp),%rsi
  801da9:	48 b8 b9 1b 80 00 00 	movabs $0x801bb9,%rax
  801db0:	00 00 00 
  801db3:	ff d0                	call   *%rax
  801db5:	89 c3                	mov    %eax,%ebx
  801db7:	85 c0                	test   %eax,%eax
  801db9:	0f 88 b8 00 00 00    	js     801e77 <dup+0xea>
    close(newfdnum);
  801dbf:	44 89 e7             	mov    %r12d,%edi
  801dc2:	48 b8 2a 1d 80 00 00 	movabs $0x801d2a,%rax
  801dc9:	00 00 00 
  801dcc:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  801dce:	4d 63 ec             	movslq %r12d,%r13
  801dd1:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  801dd8:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  801ddc:	4c 8b 7d c8          	mov    -0x38(%rbp),%r15
  801de0:	4c 89 ff             	mov    %r15,%rdi
  801de3:	49 be 35 1b 80 00 00 	movabs $0x801b35,%r14
  801dea:	00 00 00 
  801ded:	41 ff d6             	call   *%r14
  801df0:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  801df3:	4c 89 ef             	mov    %r13,%rdi
  801df6:	41 ff d6             	call   *%r14
  801df9:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  801dfc:	48 89 df             	mov    %rbx,%rdi
  801dff:	48 b8 6c 2e 80 00 00 	movabs $0x802e6c,%rax
  801e06:	00 00 00 
  801e09:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  801e0b:	a8 04                	test   $0x4,%al
  801e0d:	74 2b                	je     801e3a <dup+0xad>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  801e0f:	41 89 c1             	mov    %eax,%r9d
  801e12:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801e18:	4c 89 f1             	mov    %r14,%rcx
  801e1b:	ba 00 00 00 00       	mov    $0x0,%edx
  801e20:	48 89 de             	mov    %rbx,%rsi
  801e23:	bf 00 00 00 00       	mov    $0x0,%edi
  801e28:	48 b8 3c 16 80 00 00 	movabs $0x80163c,%rax
  801e2f:	00 00 00 
  801e32:	ff d0                	call   *%rax
  801e34:	89 c3                	mov    %eax,%ebx
  801e36:	85 c0                	test   %eax,%eax
  801e38:	78 4e                	js     801e88 <dup+0xfb>
    }
    prot = get_prot(oldfd);
  801e3a:	4c 89 ff             	mov    %r15,%rdi
  801e3d:	48 b8 6c 2e 80 00 00 	movabs $0x802e6c,%rax
  801e44:	00 00 00 
  801e47:	ff d0                	call   *%rax
  801e49:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  801e4c:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801e52:	4c 89 e9             	mov    %r13,%rcx
  801e55:	ba 00 00 00 00       	mov    $0x0,%edx
  801e5a:	4c 89 fe             	mov    %r15,%rsi
  801e5d:	bf 00 00 00 00       	mov    $0x0,%edi
  801e62:	48 b8 3c 16 80 00 00 	movabs $0x80163c,%rax
  801e69:	00 00 00 
  801e6c:	ff d0                	call   *%rax
  801e6e:	89 c3                	mov    %eax,%ebx
  801e70:	85 c0                	test   %eax,%eax
  801e72:	78 14                	js     801e88 <dup+0xfb>

    return newfdnum;
  801e74:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  801e77:	89 d8                	mov    %ebx,%eax
  801e79:	48 83 c4 18          	add    $0x18,%rsp
  801e7d:	5b                   	pop    %rbx
  801e7e:	41 5c                	pop    %r12
  801e80:	41 5d                	pop    %r13
  801e82:	41 5e                	pop    %r14
  801e84:	41 5f                	pop    %r15
  801e86:	5d                   	pop    %rbp
  801e87:	c3                   	ret
    sys_unmap_region(0, newfd, PAGE_SIZE);
  801e88:	ba 00 10 00 00       	mov    $0x1000,%edx
  801e8d:	4c 89 ee             	mov    %r13,%rsi
  801e90:	bf 00 00 00 00       	mov    $0x0,%edi
  801e95:	49 bc 11 17 80 00 00 	movabs $0x801711,%r12
  801e9c:	00 00 00 
  801e9f:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  801ea2:	ba 00 10 00 00       	mov    $0x1000,%edx
  801ea7:	4c 89 f6             	mov    %r14,%rsi
  801eaa:	bf 00 00 00 00       	mov    $0x0,%edi
  801eaf:	41 ff d4             	call   *%r12
    return res;
  801eb2:	eb c3                	jmp    801e77 <dup+0xea>

0000000000801eb4 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  801eb4:	f3 0f 1e fa          	endbr64
  801eb8:	55                   	push   %rbp
  801eb9:	48 89 e5             	mov    %rsp,%rbp
  801ebc:	41 56                	push   %r14
  801ebe:	41 55                	push   %r13
  801ec0:	41 54                	push   %r12
  801ec2:	53                   	push   %rbx
  801ec3:	48 83 ec 10          	sub    $0x10,%rsp
  801ec7:	89 fb                	mov    %edi,%ebx
  801ec9:	49 89 f4             	mov    %rsi,%r12
  801ecc:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801ecf:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801ed3:	48 b8 b9 1b 80 00 00 	movabs $0x801bb9,%rax
  801eda:	00 00 00 
  801edd:	ff d0                	call   *%rax
  801edf:	85 c0                	test   %eax,%eax
  801ee1:	78 4c                	js     801f2f <read+0x7b>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801ee3:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801ee7:	41 8b 3e             	mov    (%r14),%edi
  801eea:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801eee:	48 b8 08 1c 80 00 00 	movabs $0x801c08,%rax
  801ef5:	00 00 00 
  801ef8:	ff d0                	call   *%rax
  801efa:	85 c0                	test   %eax,%eax
  801efc:	78 35                	js     801f33 <read+0x7f>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801efe:	41 8b 46 08          	mov    0x8(%r14),%eax
  801f02:	83 e0 03             	and    $0x3,%eax
  801f05:	83 f8 01             	cmp    $0x1,%eax
  801f08:	74 2d                	je     801f37 <read+0x83>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  801f0a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801f0e:	48 8b 40 10          	mov    0x10(%rax),%rax
  801f12:	48 85 c0             	test   %rax,%rax
  801f15:	74 56                	je     801f6d <read+0xb9>

    return (*dev->dev_read)(fd, buf, n);
  801f17:	4c 89 ea             	mov    %r13,%rdx
  801f1a:	4c 89 e6             	mov    %r12,%rsi
  801f1d:	4c 89 f7             	mov    %r14,%rdi
  801f20:	ff d0                	call   *%rax
}
  801f22:	48 83 c4 10          	add    $0x10,%rsp
  801f26:	5b                   	pop    %rbx
  801f27:	41 5c                	pop    %r12
  801f29:	41 5d                	pop    %r13
  801f2b:	41 5e                	pop    %r14
  801f2d:	5d                   	pop    %rbp
  801f2e:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801f2f:	48 98                	cltq
  801f31:	eb ef                	jmp    801f22 <read+0x6e>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801f33:	48 98                	cltq
  801f35:	eb eb                	jmp    801f22 <read+0x6e>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801f37:	48 a1 00 64 80 00 00 	movabs 0x806400,%rax
  801f3e:	00 00 00 
  801f41:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801f47:	89 da                	mov    %ebx,%edx
  801f49:	48 bf 10 42 80 00 00 	movabs $0x804210,%rdi
  801f50:	00 00 00 
  801f53:	b8 00 00 00 00       	mov    $0x0,%eax
  801f58:	48 b9 83 06 80 00 00 	movabs $0x800683,%rcx
  801f5f:	00 00 00 
  801f62:	ff d1                	call   *%rcx
        return -E_INVAL;
  801f64:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801f6b:	eb b5                	jmp    801f22 <read+0x6e>
    if (!dev->dev_read) return -E_NOT_SUPP;
  801f6d:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801f74:	eb ac                	jmp    801f22 <read+0x6e>

0000000000801f76 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801f76:	f3 0f 1e fa          	endbr64
  801f7a:	55                   	push   %rbp
  801f7b:	48 89 e5             	mov    %rsp,%rbp
  801f7e:	41 57                	push   %r15
  801f80:	41 56                	push   %r14
  801f82:	41 55                	push   %r13
  801f84:	41 54                	push   %r12
  801f86:	53                   	push   %rbx
  801f87:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801f8b:	48 85 d2             	test   %rdx,%rdx
  801f8e:	74 54                	je     801fe4 <readn+0x6e>
  801f90:	41 89 fd             	mov    %edi,%r13d
  801f93:	49 89 f6             	mov    %rsi,%r14
  801f96:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801f99:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801f9e:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801fa3:	49 bf b4 1e 80 00 00 	movabs $0x801eb4,%r15
  801faa:	00 00 00 
  801fad:	4c 89 e2             	mov    %r12,%rdx
  801fb0:	48 29 f2             	sub    %rsi,%rdx
  801fb3:	4c 01 f6             	add    %r14,%rsi
  801fb6:	44 89 ef             	mov    %r13d,%edi
  801fb9:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  801fbc:	85 c0                	test   %eax,%eax
  801fbe:	78 20                	js     801fe0 <readn+0x6a>
    for (; inc && res < n; res += inc) {
  801fc0:	01 c3                	add    %eax,%ebx
  801fc2:	85 c0                	test   %eax,%eax
  801fc4:	74 08                	je     801fce <readn+0x58>
  801fc6:	48 63 f3             	movslq %ebx,%rsi
  801fc9:	4c 39 e6             	cmp    %r12,%rsi
  801fcc:	72 df                	jb     801fad <readn+0x37>
    }
    return res;
  801fce:	48 63 c3             	movslq %ebx,%rax
}
  801fd1:	48 83 c4 08          	add    $0x8,%rsp
  801fd5:	5b                   	pop    %rbx
  801fd6:	41 5c                	pop    %r12
  801fd8:	41 5d                	pop    %r13
  801fda:	41 5e                	pop    %r14
  801fdc:	41 5f                	pop    %r15
  801fde:	5d                   	pop    %rbp
  801fdf:	c3                   	ret
        if (inc < 0) return inc;
  801fe0:	48 98                	cltq
  801fe2:	eb ed                	jmp    801fd1 <readn+0x5b>
    int inc = 1, res = 0;
  801fe4:	bb 00 00 00 00       	mov    $0x0,%ebx
  801fe9:	eb e3                	jmp    801fce <readn+0x58>

0000000000801feb <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  801feb:	f3 0f 1e fa          	endbr64
  801fef:	55                   	push   %rbp
  801ff0:	48 89 e5             	mov    %rsp,%rbp
  801ff3:	41 56                	push   %r14
  801ff5:	41 55                	push   %r13
  801ff7:	41 54                	push   %r12
  801ff9:	53                   	push   %rbx
  801ffa:	48 83 ec 10          	sub    $0x10,%rsp
  801ffe:	89 fb                	mov    %edi,%ebx
  802000:	49 89 f4             	mov    %rsi,%r12
  802003:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  802006:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  80200a:	48 b8 b9 1b 80 00 00 	movabs $0x801bb9,%rax
  802011:	00 00 00 
  802014:	ff d0                	call   *%rax
  802016:	85 c0                	test   %eax,%eax
  802018:	78 47                	js     802061 <write+0x76>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  80201a:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  80201e:	41 8b 3e             	mov    (%r14),%edi
  802021:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  802025:	48 b8 08 1c 80 00 00 	movabs $0x801c08,%rax
  80202c:	00 00 00 
  80202f:	ff d0                	call   *%rax
  802031:	85 c0                	test   %eax,%eax
  802033:	78 30                	js     802065 <write+0x7a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802035:	41 f6 46 08 03       	testb  $0x3,0x8(%r14)
  80203a:	74 2d                	je     802069 <write+0x7e>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  80203c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802040:	48 8b 40 18          	mov    0x18(%rax),%rax
  802044:	48 85 c0             	test   %rax,%rax
  802047:	74 56                	je     80209f <write+0xb4>

    return (*dev->dev_write)(fd, buf, n);
  802049:	4c 89 ea             	mov    %r13,%rdx
  80204c:	4c 89 e6             	mov    %r12,%rsi
  80204f:	4c 89 f7             	mov    %r14,%rdi
  802052:	ff d0                	call   *%rax
}
  802054:	48 83 c4 10          	add    $0x10,%rsp
  802058:	5b                   	pop    %rbx
  802059:	41 5c                	pop    %r12
  80205b:	41 5d                	pop    %r13
  80205d:	41 5e                	pop    %r14
  80205f:	5d                   	pop    %rbp
  802060:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  802061:	48 98                	cltq
  802063:	eb ef                	jmp    802054 <write+0x69>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  802065:	48 98                	cltq
  802067:	eb eb                	jmp    802054 <write+0x69>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802069:	48 a1 00 64 80 00 00 	movabs 0x806400,%rax
  802070:	00 00 00 
  802073:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  802079:	89 da                	mov    %ebx,%edx
  80207b:	48 bf 2c 42 80 00 00 	movabs $0x80422c,%rdi
  802082:	00 00 00 
  802085:	b8 00 00 00 00       	mov    $0x0,%eax
  80208a:	48 b9 83 06 80 00 00 	movabs $0x800683,%rcx
  802091:	00 00 00 
  802094:	ff d1                	call   *%rcx
        return -E_INVAL;
  802096:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  80209d:	eb b5                	jmp    802054 <write+0x69>
    if (!dev->dev_write) return -E_NOT_SUPP;
  80209f:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  8020a6:	eb ac                	jmp    802054 <write+0x69>

00000000008020a8 <seek>:

int
seek(int fdnum, off_t offset) {
  8020a8:	f3 0f 1e fa          	endbr64
  8020ac:	55                   	push   %rbp
  8020ad:	48 89 e5             	mov    %rsp,%rbp
  8020b0:	53                   	push   %rbx
  8020b1:	48 83 ec 18          	sub    $0x18,%rsp
  8020b5:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8020b7:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  8020bb:	48 b8 b9 1b 80 00 00 	movabs $0x801bb9,%rax
  8020c2:	00 00 00 
  8020c5:	ff d0                	call   *%rax
  8020c7:	85 c0                	test   %eax,%eax
  8020c9:	78 0c                	js     8020d7 <seek+0x2f>

    fd->fd_offset = offset;
  8020cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020cf:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  8020d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020d7:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8020db:	c9                   	leave
  8020dc:	c3                   	ret

00000000008020dd <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  8020dd:	f3 0f 1e fa          	endbr64
  8020e1:	55                   	push   %rbp
  8020e2:	48 89 e5             	mov    %rsp,%rbp
  8020e5:	41 55                	push   %r13
  8020e7:	41 54                	push   %r12
  8020e9:	53                   	push   %rbx
  8020ea:	48 83 ec 18          	sub    $0x18,%rsp
  8020ee:	89 fb                	mov    %edi,%ebx
  8020f0:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8020f3:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8020f7:	48 b8 b9 1b 80 00 00 	movabs $0x801bb9,%rax
  8020fe:	00 00 00 
  802101:	ff d0                	call   *%rax
  802103:	85 c0                	test   %eax,%eax
  802105:	78 38                	js     80213f <ftruncate+0x62>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  802107:	4c 8b 6d d8          	mov    -0x28(%rbp),%r13
  80210b:	41 8b 7d 00          	mov    0x0(%r13),%edi
  80210f:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  802113:	48 b8 08 1c 80 00 00 	movabs $0x801c08,%rax
  80211a:	00 00 00 
  80211d:	ff d0                	call   *%rax
  80211f:	85 c0                	test   %eax,%eax
  802121:	78 1c                	js     80213f <ftruncate+0x62>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802123:	41 f6 45 08 03       	testb  $0x3,0x8(%r13)
  802128:	74 20                	je     80214a <ftruncate+0x6d>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  80212a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80212e:	48 8b 40 30          	mov    0x30(%rax),%rax
  802132:	48 85 c0             	test   %rax,%rax
  802135:	74 47                	je     80217e <ftruncate+0xa1>

    return (*dev->dev_trunc)(fd, newsize);
  802137:	44 89 e6             	mov    %r12d,%esi
  80213a:	4c 89 ef             	mov    %r13,%rdi
  80213d:	ff d0                	call   *%rax
}
  80213f:	48 83 c4 18          	add    $0x18,%rsp
  802143:	5b                   	pop    %rbx
  802144:	41 5c                	pop    %r12
  802146:	41 5d                	pop    %r13
  802148:	5d                   	pop    %rbp
  802149:	c3                   	ret
                thisenv->env_id, fdnum);
  80214a:	48 a1 00 64 80 00 00 	movabs 0x806400,%rax
  802151:	00 00 00 
  802154:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  80215a:	89 da                	mov    %ebx,%edx
  80215c:	48 bf 68 43 80 00 00 	movabs $0x804368,%rdi
  802163:	00 00 00 
  802166:	b8 00 00 00 00       	mov    $0x0,%eax
  80216b:	48 b9 83 06 80 00 00 	movabs $0x800683,%rcx
  802172:	00 00 00 
  802175:	ff d1                	call   *%rcx
        return -E_INVAL;
  802177:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80217c:	eb c1                	jmp    80213f <ftruncate+0x62>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  80217e:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  802183:	eb ba                	jmp    80213f <ftruncate+0x62>

0000000000802185 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  802185:	f3 0f 1e fa          	endbr64
  802189:	55                   	push   %rbp
  80218a:	48 89 e5             	mov    %rsp,%rbp
  80218d:	41 54                	push   %r12
  80218f:	53                   	push   %rbx
  802190:	48 83 ec 10          	sub    $0x10,%rsp
  802194:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  802197:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  80219b:	48 b8 b9 1b 80 00 00 	movabs $0x801bb9,%rax
  8021a2:	00 00 00 
  8021a5:	ff d0                	call   *%rax
  8021a7:	85 c0                	test   %eax,%eax
  8021a9:	78 4e                	js     8021f9 <fstat+0x74>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8021ab:	4c 8b 65 e8          	mov    -0x18(%rbp),%r12
  8021af:	41 8b 3c 24          	mov    (%r12),%edi
  8021b3:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  8021b7:	48 b8 08 1c 80 00 00 	movabs $0x801c08,%rax
  8021be:	00 00 00 
  8021c1:	ff d0                	call   *%rax
  8021c3:	85 c0                	test   %eax,%eax
  8021c5:	78 32                	js     8021f9 <fstat+0x74>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  8021c7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8021cb:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  8021d0:	74 30                	je     802202 <fstat+0x7d>

    stat->st_name[0] = 0;
  8021d2:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  8021d5:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  8021dc:	00 00 00 
    stat->st_isdir = 0;
  8021df:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  8021e6:	00 00 00 
    stat->st_dev = dev;
  8021e9:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  8021f0:	48 89 de             	mov    %rbx,%rsi
  8021f3:	4c 89 e7             	mov    %r12,%rdi
  8021f6:	ff 50 28             	call   *0x28(%rax)
}
  8021f9:	48 83 c4 10          	add    $0x10,%rsp
  8021fd:	5b                   	pop    %rbx
  8021fe:	41 5c                	pop    %r12
  802200:	5d                   	pop    %rbp
  802201:	c3                   	ret
    if (!dev->dev_stat) return -E_NOT_SUPP;
  802202:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  802207:	eb f0                	jmp    8021f9 <fstat+0x74>

0000000000802209 <stat>:

int
stat(const char *path, struct Stat *stat) {
  802209:	f3 0f 1e fa          	endbr64
  80220d:	55                   	push   %rbp
  80220e:	48 89 e5             	mov    %rsp,%rbp
  802211:	41 54                	push   %r12
  802213:	53                   	push   %rbx
  802214:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  802217:	be 00 00 00 00       	mov    $0x0,%esi
  80221c:	48 b8 ea 24 80 00 00 	movabs $0x8024ea,%rax
  802223:	00 00 00 
  802226:	ff d0                	call   *%rax
  802228:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  80222a:	85 c0                	test   %eax,%eax
  80222c:	78 25                	js     802253 <stat+0x4a>

    int res = fstat(fd, stat);
  80222e:	4c 89 e6             	mov    %r12,%rsi
  802231:	89 c7                	mov    %eax,%edi
  802233:	48 b8 85 21 80 00 00 	movabs $0x802185,%rax
  80223a:	00 00 00 
  80223d:	ff d0                	call   *%rax
  80223f:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  802242:	89 df                	mov    %ebx,%edi
  802244:	48 b8 2a 1d 80 00 00 	movabs $0x801d2a,%rax
  80224b:	00 00 00 
  80224e:	ff d0                	call   *%rax

    return res;
  802250:	44 89 e3             	mov    %r12d,%ebx
}
  802253:	89 d8                	mov    %ebx,%eax
  802255:	5b                   	pop    %rbx
  802256:	41 5c                	pop    %r12
  802258:	5d                   	pop    %rbp
  802259:	c3                   	ret

000000000080225a <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  80225a:	f3 0f 1e fa          	endbr64
  80225e:	55                   	push   %rbp
  80225f:	48 89 e5             	mov    %rsp,%rbp
  802262:	41 54                	push   %r12
  802264:	53                   	push   %rbx
  802265:	48 83 ec 10          	sub    $0x10,%rsp
  802269:	41 89 fc             	mov    %edi,%r12d
  80226c:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  80226f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802276:	00 00 00 
  802279:	83 38 00             	cmpl   $0x0,(%rax)
  80227c:	74 6e                	je     8022ec <fsipc+0x92>

    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }
    fsenv = ipc_find_env(ENV_TYPE_FS);
  80227e:	bf 03 00 00 00       	mov    $0x3,%edi
  802283:	48 b8 99 33 80 00 00 	movabs $0x803399,%rax
  80228a:	00 00 00 
  80228d:	ff d0                	call   *%rax
  80228f:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  802296:	00 00 
    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  802298:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  80229e:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8022a3:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8022aa:	00 00 00 
  8022ad:	44 89 e6             	mov    %r12d,%esi
  8022b0:	89 c7                	mov    %eax,%edi
  8022b2:	48 b8 d7 32 80 00 00 	movabs $0x8032d7,%rax
  8022b9:	00 00 00 
  8022bc:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  8022be:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  8022c5:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  8022c6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8022cb:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8022cf:	48 89 de             	mov    %rbx,%rsi
  8022d2:	bf 00 00 00 00       	mov    $0x0,%edi
  8022d7:	48 b8 3e 32 80 00 00 	movabs $0x80323e,%rax
  8022de:	00 00 00 
  8022e1:	ff d0                	call   *%rax
}
  8022e3:	48 83 c4 10          	add    $0x10,%rsp
  8022e7:	5b                   	pop    %rbx
  8022e8:	41 5c                	pop    %r12
  8022ea:	5d                   	pop    %rbp
  8022eb:	c3                   	ret
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  8022ec:	bf 03 00 00 00       	mov    $0x3,%edi
  8022f1:	48 b8 99 33 80 00 00 	movabs $0x803399,%rax
  8022f8:	00 00 00 
  8022fb:	ff d0                	call   *%rax
  8022fd:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  802304:	00 00 
  802306:	e9 73 ff ff ff       	jmp    80227e <fsipc+0x24>

000000000080230b <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  80230b:	f3 0f 1e fa          	endbr64
  80230f:	55                   	push   %rbp
  802310:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802313:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80231a:	00 00 00 
  80231d:	8b 57 0c             	mov    0xc(%rdi),%edx
  802320:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  802322:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  802325:	be 00 00 00 00       	mov    $0x0,%esi
  80232a:	bf 02 00 00 00       	mov    $0x2,%edi
  80232f:	48 b8 5a 22 80 00 00 	movabs $0x80225a,%rax
  802336:	00 00 00 
  802339:	ff d0                	call   *%rax
}
  80233b:	5d                   	pop    %rbp
  80233c:	c3                   	ret

000000000080233d <devfile_flush>:
devfile_flush(struct Fd *fd) {
  80233d:	f3 0f 1e fa          	endbr64
  802341:	55                   	push   %rbp
  802342:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802345:	8b 47 0c             	mov    0xc(%rdi),%eax
  802348:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  80234f:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  802351:	be 00 00 00 00       	mov    $0x0,%esi
  802356:	bf 06 00 00 00       	mov    $0x6,%edi
  80235b:	48 b8 5a 22 80 00 00 	movabs $0x80225a,%rax
  802362:	00 00 00 
  802365:	ff d0                	call   *%rax
}
  802367:	5d                   	pop    %rbp
  802368:	c3                   	ret

0000000000802369 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  802369:	f3 0f 1e fa          	endbr64
  80236d:	55                   	push   %rbp
  80236e:	48 89 e5             	mov    %rsp,%rbp
  802371:	41 54                	push   %r12
  802373:	53                   	push   %rbx
  802374:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802377:	8b 47 0c             	mov    0xc(%rdi),%eax
  80237a:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  802381:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  802383:	be 00 00 00 00       	mov    $0x0,%esi
  802388:	bf 05 00 00 00       	mov    $0x5,%edi
  80238d:	48 b8 5a 22 80 00 00 	movabs $0x80225a,%rax
  802394:	00 00 00 
  802397:	ff d0                	call   *%rax
    if (res < 0) return res;
  802399:	85 c0                	test   %eax,%eax
  80239b:	78 3d                	js     8023da <devfile_stat+0x71>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80239d:	49 bc 00 70 80 00 00 	movabs $0x807000,%r12
  8023a4:	00 00 00 
  8023a7:	4c 89 e6             	mov    %r12,%rsi
  8023aa:	48 89 df             	mov    %rbx,%rdi
  8023ad:	48 b8 cc 0f 80 00 00 	movabs $0x800fcc,%rax
  8023b4:	00 00 00 
  8023b7:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  8023b9:	41 8b 84 24 80 00 00 	mov    0x80(%r12),%eax
  8023c0:	00 
  8023c1:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8023c7:	41 8b 84 24 84 00 00 	mov    0x84(%r12),%eax
  8023ce:	00 
  8023cf:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  8023d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023da:	5b                   	pop    %rbx
  8023db:	41 5c                	pop    %r12
  8023dd:	5d                   	pop    %rbp
  8023de:	c3                   	ret

00000000008023df <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  8023df:	f3 0f 1e fa          	endbr64
    if (n >= sizeof(fsipcbuf.write.req_buf)) {
  8023e3:	48 81 fa ef 0f 00 00 	cmp    $0xfef,%rdx
  8023ea:	77 41                	ja     80242d <devfile_write+0x4e>
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  8023ec:	55                   	push   %rbp
  8023ed:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  8023f0:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8023f7:	00 00 00 
  8023fa:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  8023fd:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.write.req_n = n;
  8023ff:	48 89 50 08          	mov    %rdx,0x8(%rax)
    memmove(fsipcbuf.write.req_buf, buf, n);
  802403:	48 8d 78 10          	lea    0x10(%rax),%rdi
  802407:	48 b8 e7 11 80 00 00 	movabs $0x8011e7,%rax
  80240e:	00 00 00 
  802411:	ff d0                	call   *%rax
    res = fsipc(FSREQ_WRITE, NULL);
  802413:	be 00 00 00 00       	mov    $0x0,%esi
  802418:	bf 04 00 00 00       	mov    $0x4,%edi
  80241d:	48 b8 5a 22 80 00 00 	movabs $0x80225a,%rax
  802424:	00 00 00 
  802427:	ff d0                	call   *%rax
  802429:	48 98                	cltq
}
  80242b:	5d                   	pop    %rbp
  80242c:	c3                   	ret
        return -E_INVAL;
  80242d:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
}
  802434:	c3                   	ret

0000000000802435 <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  802435:	f3 0f 1e fa          	endbr64
  802439:	55                   	push   %rbp
  80243a:	48 89 e5             	mov    %rsp,%rbp
  80243d:	41 55                	push   %r13
  80243f:	41 54                	push   %r12
  802441:	53                   	push   %rbx
  802442:	48 83 ec 08          	sub    $0x8,%rsp
  802446:	49 89 f4             	mov    %rsi,%r12
  802449:	48 89 d3             	mov    %rdx,%rbx
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  80244c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802453:	00 00 00 
  802456:	8b 57 0c             	mov    0xc(%rdi),%edx
  802459:	89 10                	mov    %edx,(%rax)
    fsipcbuf.read.req_n = n;
  80245b:	48 89 58 08          	mov    %rbx,0x8(%rax)
    res = fsipc(FSREQ_READ, NULL);
  80245f:	be 00 00 00 00       	mov    $0x0,%esi
  802464:	bf 03 00 00 00       	mov    $0x3,%edi
  802469:	48 b8 5a 22 80 00 00 	movabs $0x80225a,%rax
  802470:	00 00 00 
  802473:	ff d0                	call   *%rax
  802475:	4c 63 e8             	movslq %eax,%r13
    if (res < 0) {
  802478:	4d 85 ed             	test   %r13,%r13
  80247b:	78 2a                	js     8024a7 <devfile_read+0x72>
    assert(res <= n && res <= PAGE_SIZE);
  80247d:	4c 89 ea             	mov    %r13,%rdx
  802480:	4c 39 eb             	cmp    %r13,%rbx
  802483:	72 30                	jb     8024b5 <devfile_read+0x80>
  802485:	49 81 fd 00 10 00 00 	cmp    $0x1000,%r13
  80248c:	7f 27                	jg     8024b5 <devfile_read+0x80>
    memmove(buf, &fsipcbuf, res);
  80248e:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802495:	00 00 00 
  802498:	4c 89 e7             	mov    %r12,%rdi
  80249b:	48 b8 e7 11 80 00 00 	movabs $0x8011e7,%rax
  8024a2:	00 00 00 
  8024a5:	ff d0                	call   *%rax
}
  8024a7:	4c 89 e8             	mov    %r13,%rax
  8024aa:	48 83 c4 08          	add    $0x8,%rsp
  8024ae:	5b                   	pop    %rbx
  8024af:	41 5c                	pop    %r12
  8024b1:	41 5d                	pop    %r13
  8024b3:	5d                   	pop    %rbp
  8024b4:	c3                   	ret
    assert(res <= n && res <= PAGE_SIZE);
  8024b5:	48 b9 49 42 80 00 00 	movabs $0x804249,%rcx
  8024bc:	00 00 00 
  8024bf:	48 ba 66 42 80 00 00 	movabs $0x804266,%rdx
  8024c6:	00 00 00 
  8024c9:	be 7b 00 00 00       	mov    $0x7b,%esi
  8024ce:	48 bf 7b 42 80 00 00 	movabs $0x80427b,%rdi
  8024d5:	00 00 00 
  8024d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8024dd:	49 b8 27 05 80 00 00 	movabs $0x800527,%r8
  8024e4:	00 00 00 
  8024e7:	41 ff d0             	call   *%r8

00000000008024ea <open>:
open(const char *path, int mode) {
  8024ea:	f3 0f 1e fa          	endbr64
  8024ee:	55                   	push   %rbp
  8024ef:	48 89 e5             	mov    %rsp,%rbp
  8024f2:	41 55                	push   %r13
  8024f4:	41 54                	push   %r12
  8024f6:	53                   	push   %rbx
  8024f7:	48 83 ec 18          	sub    $0x18,%rsp
  8024fb:	49 89 fc             	mov    %rdi,%r12
  8024fe:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  802501:	48 b8 87 0f 80 00 00 	movabs $0x800f87,%rax
  802508:	00 00 00 
  80250b:	ff d0                	call   *%rax
  80250d:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  802513:	0f 87 8a 00 00 00    	ja     8025a3 <open+0xb9>
    if ((res = fd_alloc(&fd)) < 0) return res;
  802519:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  80251d:	48 b8 55 1b 80 00 00 	movabs $0x801b55,%rax
  802524:	00 00 00 
  802527:	ff d0                	call   *%rax
  802529:	89 c3                	mov    %eax,%ebx
  80252b:	85 c0                	test   %eax,%eax
  80252d:	78 50                	js     80257f <open+0x95>
    strcpy(fsipcbuf.open.req_path, path);
  80252f:	4c 89 e6             	mov    %r12,%rsi
  802532:	48 bb 00 70 80 00 00 	movabs $0x807000,%rbx
  802539:	00 00 00 
  80253c:	48 89 df             	mov    %rbx,%rdi
  80253f:	48 b8 cc 0f 80 00 00 	movabs $0x800fcc,%rax
  802546:	00 00 00 
  802549:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  80254b:	44 89 ab 00 04 00 00 	mov    %r13d,0x400(%rbx)
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  802552:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802556:	bf 01 00 00 00       	mov    $0x1,%edi
  80255b:	48 b8 5a 22 80 00 00 	movabs $0x80225a,%rax
  802562:	00 00 00 
  802565:	ff d0                	call   *%rax
  802567:	89 c3                	mov    %eax,%ebx
  802569:	85 c0                	test   %eax,%eax
  80256b:	78 1f                	js     80258c <open+0xa2>
    return fd2num(fd);
  80256d:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802571:	48 b8 1f 1b 80 00 00 	movabs $0x801b1f,%rax
  802578:	00 00 00 
  80257b:	ff d0                	call   *%rax
  80257d:	89 c3                	mov    %eax,%ebx
}
  80257f:	89 d8                	mov    %ebx,%eax
  802581:	48 83 c4 18          	add    $0x18,%rsp
  802585:	5b                   	pop    %rbx
  802586:	41 5c                	pop    %r12
  802588:	41 5d                	pop    %r13
  80258a:	5d                   	pop    %rbp
  80258b:	c3                   	ret
        fd_close(fd, 0);
  80258c:	be 00 00 00 00       	mov    $0x0,%esi
  802591:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802595:	48 b8 7c 1c 80 00 00 	movabs $0x801c7c,%rax
  80259c:	00 00 00 
  80259f:	ff d0                	call   *%rax
        return res;
  8025a1:	eb dc                	jmp    80257f <open+0x95>
        return -E_BAD_PATH;
  8025a3:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  8025a8:	eb d5                	jmp    80257f <open+0x95>

00000000008025aa <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  8025aa:	f3 0f 1e fa          	endbr64
  8025ae:	55                   	push   %rbp
  8025af:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  8025b2:	be 00 00 00 00       	mov    $0x0,%esi
  8025b7:	bf 08 00 00 00       	mov    $0x8,%edi
  8025bc:	48 b8 5a 22 80 00 00 	movabs $0x80225a,%rax
  8025c3:	00 00 00 
  8025c6:	ff d0                	call   *%rax
}
  8025c8:	5d                   	pop    %rbp
  8025c9:	c3                   	ret

00000000008025ca <writebuf>:
    int error;      /* First error that occurred */
    char buf[PRINTBUFSZ];
};

static void
writebuf(struct printbuf *state) {
  8025ca:	f3 0f 1e fa          	endbr64
    if (state->error > 0) {
  8025ce:	83 7f 10 00          	cmpl   $0x0,0x10(%rdi)
  8025d2:	7f 01                	jg     8025d5 <writebuf+0xb>
  8025d4:	c3                   	ret
writebuf(struct printbuf *state) {
  8025d5:	55                   	push   %rbp
  8025d6:	48 89 e5             	mov    %rsp,%rbp
  8025d9:	53                   	push   %rbx
  8025da:	48 83 ec 08          	sub    $0x8,%rsp
  8025de:	48 89 fb             	mov    %rdi,%rbx
        ssize_t result = write(state->fd, state->buf, state->offset);
  8025e1:	48 63 57 04          	movslq 0x4(%rdi),%rdx
  8025e5:	48 8d 77 14          	lea    0x14(%rdi),%rsi
  8025e9:	8b 3f                	mov    (%rdi),%edi
  8025eb:	48 b8 eb 1f 80 00 00 	movabs $0x801feb,%rax
  8025f2:	00 00 00 
  8025f5:	ff d0                	call   *%rax
        if (result > 0) state->result += result;
  8025f7:	48 85 c0             	test   %rax,%rax
  8025fa:	7e 04                	jle    802600 <writebuf+0x36>
  8025fc:	48 01 43 08          	add    %rax,0x8(%rbx)

        /* Error, or wrote less than supplied */
        if (result != state->offset)
  802600:	48 63 53 04          	movslq 0x4(%rbx),%rdx
  802604:	48 39 c2             	cmp    %rax,%rdx
  802607:	74 0f                	je     802618 <writebuf+0x4e>
            state->error = MIN(0, result);
  802609:	48 85 c0             	test   %rax,%rax
  80260c:	ba 00 00 00 00       	mov    $0x0,%edx
  802611:	48 0f 4f c2          	cmovg  %rdx,%rax
  802615:	89 43 10             	mov    %eax,0x10(%rbx)
    }
}
  802618:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80261c:	c9                   	leave
  80261d:	c3                   	ret

000000000080261e <putch>:

static void
putch(int ch, void *arg) {
  80261e:	f3 0f 1e fa          	endbr64
    struct printbuf *state = (struct printbuf *)arg;
    state->buf[state->offset++] = ch;
  802622:	8b 46 04             	mov    0x4(%rsi),%eax
  802625:	8d 50 01             	lea    0x1(%rax),%edx
  802628:	89 56 04             	mov    %edx,0x4(%rsi)
  80262b:	48 98                	cltq
  80262d:	40 88 7c 06 14       	mov    %dil,0x14(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ) {
  802632:	81 fa 00 01 00 00    	cmp    $0x100,%edx
  802638:	74 01                	je     80263b <putch+0x1d>
  80263a:	c3                   	ret
putch(int ch, void *arg) {
  80263b:	55                   	push   %rbp
  80263c:	48 89 e5             	mov    %rsp,%rbp
  80263f:	53                   	push   %rbx
  802640:	48 83 ec 08          	sub    $0x8,%rsp
  802644:	48 89 f3             	mov    %rsi,%rbx
        writebuf(state);
  802647:	48 89 f7             	mov    %rsi,%rdi
  80264a:	48 b8 ca 25 80 00 00 	movabs $0x8025ca,%rax
  802651:	00 00 00 
  802654:	ff d0                	call   *%rax
        state->offset = 0;
  802656:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%rbx)
    }
}
  80265d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  802661:	c9                   	leave
  802662:	c3                   	ret

0000000000802663 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap) {
  802663:	f3 0f 1e fa          	endbr64
  802667:	55                   	push   %rbp
  802668:	48 89 e5             	mov    %rsp,%rbp
  80266b:	48 81 ec 20 01 00 00 	sub    $0x120,%rsp
  802672:	48 89 d1             	mov    %rdx,%rcx
    struct printbuf state;
    state.fd = fd;
  802675:	89 bd e8 fe ff ff    	mov    %edi,-0x118(%rbp)
    state.offset = 0;
  80267b:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%rbp)
  802682:	00 00 00 
    state.result = 0;
  802685:	48 c7 85 f0 fe ff ff 	movq   $0x0,-0x110(%rbp)
  80268c:	00 00 00 00 
    state.error = 1;
  802690:	c7 85 f8 fe ff ff 01 	movl   $0x1,-0x108(%rbp)
  802697:	00 00 00 

    vprintfmt(putch, &state, fmt, ap);
  80269a:	48 89 f2             	mov    %rsi,%rdx
  80269d:	48 8d b5 e8 fe ff ff 	lea    -0x118(%rbp),%rsi
  8026a4:	48 bf 1e 26 80 00 00 	movabs $0x80261e,%rdi
  8026ab:	00 00 00 
  8026ae:	48 b8 e3 07 80 00 00 	movabs $0x8007e3,%rax
  8026b5:	00 00 00 
  8026b8:	ff d0                	call   *%rax
    if (state.offset > 0) writebuf(&state);
  8026ba:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%rbp)
  8026c1:	7f 14                	jg     8026d7 <vfprintf+0x74>

    return (state.result ? state.result : state.error);
  8026c3:	48 8b 85 f0 fe ff ff 	mov    -0x110(%rbp),%rax
  8026ca:	48 85 c0             	test   %rax,%rax
  8026cd:	75 06                	jne    8026d5 <vfprintf+0x72>
  8026cf:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
}
  8026d5:	c9                   	leave
  8026d6:	c3                   	ret
    if (state.offset > 0) writebuf(&state);
  8026d7:	48 8d bd e8 fe ff ff 	lea    -0x118(%rbp),%rdi
  8026de:	48 b8 ca 25 80 00 00 	movabs $0x8025ca,%rax
  8026e5:	00 00 00 
  8026e8:	ff d0                	call   *%rax
  8026ea:	eb d7                	jmp    8026c3 <vfprintf+0x60>

00000000008026ec <fprintf>:

int
fprintf(int fd, const char *fmt, ...) {
  8026ec:	f3 0f 1e fa          	endbr64
  8026f0:	55                   	push   %rbp
  8026f1:	48 89 e5             	mov    %rsp,%rbp
  8026f4:	48 83 ec 50          	sub    $0x50,%rsp
  8026f8:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8026fc:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802700:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  802704:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    va_start(ap, fmt);
  802708:	c7 45 b8 10 00 00 00 	movl   $0x10,-0x48(%rbp)
  80270f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802713:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802717:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80271b:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int res = vfprintf(fd, fmt, ap);
  80271f:	48 8d 55 b8          	lea    -0x48(%rbp),%rdx
  802723:	48 b8 63 26 80 00 00 	movabs $0x802663,%rax
  80272a:	00 00 00 
  80272d:	ff d0                	call   *%rax
    va_end(ap);

    return res;
}
  80272f:	c9                   	leave
  802730:	c3                   	ret

0000000000802731 <printf>:

int
printf(const char *fmt, ...) {
  802731:	f3 0f 1e fa          	endbr64
  802735:	55                   	push   %rbp
  802736:	48 89 e5             	mov    %rsp,%rbp
  802739:	48 83 ec 50          	sub    $0x50,%rsp
  80273d:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  802741:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  802745:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802749:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  80274d:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    va_start(ap, fmt);
  802751:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  802758:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80275c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802760:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802764:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int res = vfprintf(1, fmt, ap);
  802768:	48 8d 55 b8          	lea    -0x48(%rbp),%rdx
  80276c:	48 89 fe             	mov    %rdi,%rsi
  80276f:	bf 01 00 00 00       	mov    $0x1,%edi
  802774:	48 b8 63 26 80 00 00 	movabs $0x802663,%rax
  80277b:	00 00 00 
  80277e:	ff d0                	call   *%rax
    va_end(ap);

    return res;
}
  802780:	c9                   	leave
  802781:	c3                   	ret

0000000000802782 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  802782:	f3 0f 1e fa          	endbr64
  802786:	55                   	push   %rbp
  802787:	48 89 e5             	mov    %rsp,%rbp
  80278a:	41 54                	push   %r12
  80278c:	53                   	push   %rbx
  80278d:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802790:	48 b8 35 1b 80 00 00 	movabs $0x801b35,%rax
  802797:	00 00 00 
  80279a:	ff d0                	call   *%rax
  80279c:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  80279f:	48 be 86 42 80 00 00 	movabs $0x804286,%rsi
  8027a6:	00 00 00 
  8027a9:	48 89 df             	mov    %rbx,%rdi
  8027ac:	48 b8 cc 0f 80 00 00 	movabs $0x800fcc,%rax
  8027b3:	00 00 00 
  8027b6:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  8027b8:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  8027bd:	41 2b 04 24          	sub    (%r12),%eax
  8027c1:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  8027c7:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  8027ce:	00 00 00 
    stat->st_dev = &devpipe;
  8027d1:	48 b8 60 50 80 00 00 	movabs $0x805060,%rax
  8027d8:	00 00 00 
  8027db:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  8027e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8027e7:	5b                   	pop    %rbx
  8027e8:	41 5c                	pop    %r12
  8027ea:	5d                   	pop    %rbp
  8027eb:	c3                   	ret

00000000008027ec <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  8027ec:	f3 0f 1e fa          	endbr64
  8027f0:	55                   	push   %rbp
  8027f1:	48 89 e5             	mov    %rsp,%rbp
  8027f4:	41 54                	push   %r12
  8027f6:	53                   	push   %rbx
  8027f7:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  8027fa:	ba 00 10 00 00       	mov    $0x1000,%edx
  8027ff:	48 89 fe             	mov    %rdi,%rsi
  802802:	bf 00 00 00 00       	mov    $0x0,%edi
  802807:	49 bc 11 17 80 00 00 	movabs $0x801711,%r12
  80280e:	00 00 00 
  802811:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  802814:	48 89 df             	mov    %rbx,%rdi
  802817:	48 b8 35 1b 80 00 00 	movabs $0x801b35,%rax
  80281e:	00 00 00 
  802821:	ff d0                	call   *%rax
  802823:	48 89 c6             	mov    %rax,%rsi
  802826:	ba 00 10 00 00       	mov    $0x1000,%edx
  80282b:	bf 00 00 00 00       	mov    $0x0,%edi
  802830:	41 ff d4             	call   *%r12
}
  802833:	5b                   	pop    %rbx
  802834:	41 5c                	pop    %r12
  802836:	5d                   	pop    %rbp
  802837:	c3                   	ret

0000000000802838 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  802838:	f3 0f 1e fa          	endbr64
  80283c:	55                   	push   %rbp
  80283d:	48 89 e5             	mov    %rsp,%rbp
  802840:	41 57                	push   %r15
  802842:	41 56                	push   %r14
  802844:	41 55                	push   %r13
  802846:	41 54                	push   %r12
  802848:	53                   	push   %rbx
  802849:	48 83 ec 18          	sub    $0x18,%rsp
  80284d:	49 89 fc             	mov    %rdi,%r12
  802850:	49 89 f5             	mov    %rsi,%r13
  802853:	49 89 d7             	mov    %rdx,%r15
  802856:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  80285a:	48 b8 35 1b 80 00 00 	movabs $0x801b35,%rax
  802861:	00 00 00 
  802864:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  802866:	4d 85 ff             	test   %r15,%r15
  802869:	0f 84 af 00 00 00    	je     80291e <devpipe_write+0xe6>
  80286f:	48 89 c3             	mov    %rax,%rbx
  802872:	4c 89 f8             	mov    %r15,%rax
  802875:	4d 89 ef             	mov    %r13,%r15
  802878:	4c 01 e8             	add    %r13,%rax
  80287b:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80287f:	49 bd a1 15 80 00 00 	movabs $0x8015a1,%r13
  802886:	00 00 00 
            sys_yield();
  802889:	49 be 36 15 80 00 00 	movabs $0x801536,%r14
  802890:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  802893:	8b 73 04             	mov    0x4(%rbx),%esi
  802896:	48 63 ce             	movslq %esi,%rcx
  802899:	48 63 03             	movslq (%rbx),%rax
  80289c:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8028a2:	48 39 c1             	cmp    %rax,%rcx
  8028a5:	72 2e                	jb     8028d5 <devpipe_write+0x9d>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8028a7:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8028ac:	48 89 da             	mov    %rbx,%rdx
  8028af:	be 00 10 00 00       	mov    $0x1000,%esi
  8028b4:	4c 89 e7             	mov    %r12,%rdi
  8028b7:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8028ba:	85 c0                	test   %eax,%eax
  8028bc:	74 66                	je     802924 <devpipe_write+0xec>
            sys_yield();
  8028be:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8028c1:	8b 73 04             	mov    0x4(%rbx),%esi
  8028c4:	48 63 ce             	movslq %esi,%rcx
  8028c7:	48 63 03             	movslq (%rbx),%rax
  8028ca:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8028d0:	48 39 c1             	cmp    %rax,%rcx
  8028d3:	73 d2                	jae    8028a7 <devpipe_write+0x6f>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8028d5:	41 0f b6 3f          	movzbl (%r15),%edi
  8028d9:	48 89 ca             	mov    %rcx,%rdx
  8028dc:	48 c1 ea 03          	shr    $0x3,%rdx
  8028e0:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  8028e7:	08 10 20 
  8028ea:	48 f7 e2             	mul    %rdx
  8028ed:	48 c1 ea 06          	shr    $0x6,%rdx
  8028f1:	48 89 d0             	mov    %rdx,%rax
  8028f4:	48 c1 e0 09          	shl    $0x9,%rax
  8028f8:	48 29 d0             	sub    %rdx,%rax
  8028fb:	48 c1 e0 03          	shl    $0x3,%rax
  8028ff:	48 29 c1             	sub    %rax,%rcx
  802902:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  802907:	83 c6 01             	add    $0x1,%esi
  80290a:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  80290d:	49 83 c7 01          	add    $0x1,%r15
  802911:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802915:	49 39 c7             	cmp    %rax,%r15
  802918:	0f 85 75 ff ff ff    	jne    802893 <devpipe_write+0x5b>
    return n;
  80291e:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802922:	eb 05                	jmp    802929 <devpipe_write+0xf1>
            if (_pipeisclosed(fd, p)) return 0;
  802924:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802929:	48 83 c4 18          	add    $0x18,%rsp
  80292d:	5b                   	pop    %rbx
  80292e:	41 5c                	pop    %r12
  802930:	41 5d                	pop    %r13
  802932:	41 5e                	pop    %r14
  802934:	41 5f                	pop    %r15
  802936:	5d                   	pop    %rbp
  802937:	c3                   	ret

0000000000802938 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  802938:	f3 0f 1e fa          	endbr64
  80293c:	55                   	push   %rbp
  80293d:	48 89 e5             	mov    %rsp,%rbp
  802940:	41 57                	push   %r15
  802942:	41 56                	push   %r14
  802944:	41 55                	push   %r13
  802946:	41 54                	push   %r12
  802948:	53                   	push   %rbx
  802949:	48 83 ec 18          	sub    $0x18,%rsp
  80294d:	49 89 fc             	mov    %rdi,%r12
  802950:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  802954:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802958:	48 b8 35 1b 80 00 00 	movabs $0x801b35,%rax
  80295f:	00 00 00 
  802962:	ff d0                	call   *%rax
  802964:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  802967:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80296d:	49 bd a1 15 80 00 00 	movabs $0x8015a1,%r13
  802974:	00 00 00 
            sys_yield();
  802977:	49 be 36 15 80 00 00 	movabs $0x801536,%r14
  80297e:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  802981:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  802986:	74 7d                	je     802a05 <devpipe_read+0xcd>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  802988:	8b 03                	mov    (%rbx),%eax
  80298a:	3b 43 04             	cmp    0x4(%rbx),%eax
  80298d:	75 26                	jne    8029b5 <devpipe_read+0x7d>
            if (i > 0) return i;
  80298f:	4d 85 ff             	test   %r15,%r15
  802992:	75 77                	jne    802a0b <devpipe_read+0xd3>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802994:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802999:	48 89 da             	mov    %rbx,%rdx
  80299c:	be 00 10 00 00       	mov    $0x1000,%esi
  8029a1:	4c 89 e7             	mov    %r12,%rdi
  8029a4:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8029a7:	85 c0                	test   %eax,%eax
  8029a9:	74 72                	je     802a1d <devpipe_read+0xe5>
            sys_yield();
  8029ab:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8029ae:	8b 03                	mov    (%rbx),%eax
  8029b0:	3b 43 04             	cmp    0x4(%rbx),%eax
  8029b3:	74 df                	je     802994 <devpipe_read+0x5c>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8029b5:	48 63 c8             	movslq %eax,%rcx
  8029b8:	48 89 ca             	mov    %rcx,%rdx
  8029bb:	48 c1 ea 03          	shr    $0x3,%rdx
  8029bf:	48 be 81 00 01 02 04 	movabs $0x2010080402010081,%rsi
  8029c6:	08 10 20 
  8029c9:	48 89 d0             	mov    %rdx,%rax
  8029cc:	48 f7 e6             	mul    %rsi
  8029cf:	48 c1 ea 06          	shr    $0x6,%rdx
  8029d3:	48 89 d0             	mov    %rdx,%rax
  8029d6:	48 c1 e0 09          	shl    $0x9,%rax
  8029da:	48 29 d0             	sub    %rdx,%rax
  8029dd:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8029e4:	00 
  8029e5:	48 89 c8             	mov    %rcx,%rax
  8029e8:	48 29 d0             	sub    %rdx,%rax
  8029eb:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  8029f0:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8029f4:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  8029f8:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  8029fb:	49 83 c7 01          	add    $0x1,%r15
  8029ff:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  802a03:	75 83                	jne    802988 <devpipe_read+0x50>
    return n;
  802a05:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802a09:	eb 03                	jmp    802a0e <devpipe_read+0xd6>
            if (i > 0) return i;
  802a0b:	4c 89 f8             	mov    %r15,%rax
}
  802a0e:	48 83 c4 18          	add    $0x18,%rsp
  802a12:	5b                   	pop    %rbx
  802a13:	41 5c                	pop    %r12
  802a15:	41 5d                	pop    %r13
  802a17:	41 5e                	pop    %r14
  802a19:	41 5f                	pop    %r15
  802a1b:	5d                   	pop    %rbp
  802a1c:	c3                   	ret
            if (_pipeisclosed(fd, p)) return 0;
  802a1d:	b8 00 00 00 00       	mov    $0x0,%eax
  802a22:	eb ea                	jmp    802a0e <devpipe_read+0xd6>

0000000000802a24 <pipe>:
pipe(int pfd[2]) {
  802a24:	f3 0f 1e fa          	endbr64
  802a28:	55                   	push   %rbp
  802a29:	48 89 e5             	mov    %rsp,%rbp
  802a2c:	41 55                	push   %r13
  802a2e:	41 54                	push   %r12
  802a30:	53                   	push   %rbx
  802a31:	48 83 ec 18          	sub    $0x18,%rsp
  802a35:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  802a38:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802a3c:	48 b8 55 1b 80 00 00 	movabs $0x801b55,%rax
  802a43:	00 00 00 
  802a46:	ff d0                	call   *%rax
  802a48:	89 c3                	mov    %eax,%ebx
  802a4a:	85 c0                	test   %eax,%eax
  802a4c:	0f 88 a0 01 00 00    	js     802bf2 <pipe+0x1ce>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  802a52:	b9 46 00 00 00       	mov    $0x46,%ecx
  802a57:	ba 00 10 00 00       	mov    $0x1000,%edx
  802a5c:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802a60:	bf 00 00 00 00       	mov    $0x0,%edi
  802a65:	48 b8 d1 15 80 00 00 	movabs $0x8015d1,%rax
  802a6c:	00 00 00 
  802a6f:	ff d0                	call   *%rax
  802a71:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  802a73:	85 c0                	test   %eax,%eax
  802a75:	0f 88 77 01 00 00    	js     802bf2 <pipe+0x1ce>
    if ((res = fd_alloc(&fd1)) < 0 ||
  802a7b:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  802a7f:	48 b8 55 1b 80 00 00 	movabs $0x801b55,%rax
  802a86:	00 00 00 
  802a89:	ff d0                	call   *%rax
  802a8b:	89 c3                	mov    %eax,%ebx
  802a8d:	85 c0                	test   %eax,%eax
  802a8f:	0f 88 43 01 00 00    	js     802bd8 <pipe+0x1b4>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  802a95:	b9 46 00 00 00       	mov    $0x46,%ecx
  802a9a:	ba 00 10 00 00       	mov    $0x1000,%edx
  802a9f:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802aa3:	bf 00 00 00 00       	mov    $0x0,%edi
  802aa8:	48 b8 d1 15 80 00 00 	movabs $0x8015d1,%rax
  802aaf:	00 00 00 
  802ab2:	ff d0                	call   *%rax
  802ab4:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  802ab6:	85 c0                	test   %eax,%eax
  802ab8:	0f 88 1a 01 00 00    	js     802bd8 <pipe+0x1b4>
    va = fd2data(fd0);
  802abe:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802ac2:	48 b8 35 1b 80 00 00 	movabs $0x801b35,%rax
  802ac9:	00 00 00 
  802acc:	ff d0                	call   *%rax
  802ace:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  802ad1:	b9 46 00 00 00       	mov    $0x46,%ecx
  802ad6:	ba 00 10 00 00       	mov    $0x1000,%edx
  802adb:	48 89 c6             	mov    %rax,%rsi
  802ade:	bf 00 00 00 00       	mov    $0x0,%edi
  802ae3:	48 b8 d1 15 80 00 00 	movabs $0x8015d1,%rax
  802aea:	00 00 00 
  802aed:	ff d0                	call   *%rax
  802aef:	89 c3                	mov    %eax,%ebx
  802af1:	85 c0                	test   %eax,%eax
  802af3:	0f 88 c5 00 00 00    	js     802bbe <pipe+0x19a>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  802af9:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802afd:	48 b8 35 1b 80 00 00 	movabs $0x801b35,%rax
  802b04:	00 00 00 
  802b07:	ff d0                	call   *%rax
  802b09:	48 89 c1             	mov    %rax,%rcx
  802b0c:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  802b12:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  802b18:	ba 00 00 00 00       	mov    $0x0,%edx
  802b1d:	4c 89 ee             	mov    %r13,%rsi
  802b20:	bf 00 00 00 00       	mov    $0x0,%edi
  802b25:	48 b8 3c 16 80 00 00 	movabs $0x80163c,%rax
  802b2c:	00 00 00 
  802b2f:	ff d0                	call   *%rax
  802b31:	89 c3                	mov    %eax,%ebx
  802b33:	85 c0                	test   %eax,%eax
  802b35:	78 6e                	js     802ba5 <pipe+0x181>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802b37:	be 00 10 00 00       	mov    $0x1000,%esi
  802b3c:	4c 89 ef             	mov    %r13,%rdi
  802b3f:	48 b8 6b 15 80 00 00 	movabs $0x80156b,%rax
  802b46:	00 00 00 
  802b49:	ff d0                	call   *%rax
  802b4b:	83 f8 02             	cmp    $0x2,%eax
  802b4e:	0f 85 ab 00 00 00    	jne    802bff <pipe+0x1db>
    fd0->fd_dev_id = devpipe.dev_id;
  802b54:	a1 60 50 80 00 00 00 	movabs 0x805060,%eax
  802b5b:	00 00 
  802b5d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802b61:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  802b63:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802b67:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  802b6e:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802b72:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  802b74:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b78:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  802b7f:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802b83:	48 bb 1f 1b 80 00 00 	movabs $0x801b1f,%rbx
  802b8a:	00 00 00 
  802b8d:	ff d3                	call   *%rbx
  802b8f:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  802b93:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  802b97:	ff d3                	call   *%rbx
  802b99:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  802b9e:	bb 00 00 00 00       	mov    $0x0,%ebx
  802ba3:	eb 4d                	jmp    802bf2 <pipe+0x1ce>
    sys_unmap_region(0, va, PAGE_SIZE);
  802ba5:	ba 00 10 00 00       	mov    $0x1000,%edx
  802baa:	4c 89 ee             	mov    %r13,%rsi
  802bad:	bf 00 00 00 00       	mov    $0x0,%edi
  802bb2:	48 b8 11 17 80 00 00 	movabs $0x801711,%rax
  802bb9:	00 00 00 
  802bbc:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  802bbe:	ba 00 10 00 00       	mov    $0x1000,%edx
  802bc3:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802bc7:	bf 00 00 00 00       	mov    $0x0,%edi
  802bcc:	48 b8 11 17 80 00 00 	movabs $0x801711,%rax
  802bd3:	00 00 00 
  802bd6:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  802bd8:	ba 00 10 00 00       	mov    $0x1000,%edx
  802bdd:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802be1:	bf 00 00 00 00       	mov    $0x0,%edi
  802be6:	48 b8 11 17 80 00 00 	movabs $0x801711,%rax
  802bed:	00 00 00 
  802bf0:	ff d0                	call   *%rax
}
  802bf2:	89 d8                	mov    %ebx,%eax
  802bf4:	48 83 c4 18          	add    $0x18,%rsp
  802bf8:	5b                   	pop    %rbx
  802bf9:	41 5c                	pop    %r12
  802bfb:	41 5d                	pop    %r13
  802bfd:	5d                   	pop    %rbp
  802bfe:	c3                   	ret
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802bff:	48 b9 90 43 80 00 00 	movabs $0x804390,%rcx
  802c06:	00 00 00 
  802c09:	48 ba 66 42 80 00 00 	movabs $0x804266,%rdx
  802c10:	00 00 00 
  802c13:	be 2e 00 00 00       	mov    $0x2e,%esi
  802c18:	48 bf 8d 42 80 00 00 	movabs $0x80428d,%rdi
  802c1f:	00 00 00 
  802c22:	b8 00 00 00 00       	mov    $0x0,%eax
  802c27:	49 b8 27 05 80 00 00 	movabs $0x800527,%r8
  802c2e:	00 00 00 
  802c31:	41 ff d0             	call   *%r8

0000000000802c34 <pipeisclosed>:
pipeisclosed(int fdnum) {
  802c34:	f3 0f 1e fa          	endbr64
  802c38:	55                   	push   %rbp
  802c39:	48 89 e5             	mov    %rsp,%rbp
  802c3c:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802c40:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802c44:	48 b8 b9 1b 80 00 00 	movabs $0x801bb9,%rax
  802c4b:	00 00 00 
  802c4e:	ff d0                	call   *%rax
    if (res < 0) return res;
  802c50:	85 c0                	test   %eax,%eax
  802c52:	78 35                	js     802c89 <pipeisclosed+0x55>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  802c54:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802c58:	48 b8 35 1b 80 00 00 	movabs $0x801b35,%rax
  802c5f:	00 00 00 
  802c62:	ff d0                	call   *%rax
  802c64:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  802c67:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802c6c:	be 00 10 00 00       	mov    $0x1000,%esi
  802c71:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802c75:	48 b8 a1 15 80 00 00 	movabs $0x8015a1,%rax
  802c7c:	00 00 00 
  802c7f:	ff d0                	call   *%rax
  802c81:	85 c0                	test   %eax,%eax
  802c83:	0f 94 c0             	sete   %al
  802c86:	0f b6 c0             	movzbl %al,%eax
}
  802c89:	c9                   	leave
  802c8a:	c3                   	ret

0000000000802c8b <get_uvpt_entry>:
extern volatile pde_t uvpd[];     /* VA of current page directory */
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
  802c8b:	f3 0f 1e fa          	endbr64
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802c8f:	48 89 f8             	mov    %rdi,%rax
  802c92:	48 c1 e8 27          	shr    $0x27,%rax
  802c96:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  802c9d:	7f 00 00 
  802ca0:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802ca4:	f6 c2 01             	test   $0x1,%dl
  802ca7:	74 6d                	je     802d16 <get_uvpt_entry+0x8b>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  802ca9:	48 89 f8             	mov    %rdi,%rax
  802cac:	48 c1 e8 1e          	shr    $0x1e,%rax
  802cb0:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  802cb7:	7f 00 00 
  802cba:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802cbe:	f6 c2 01             	test   $0x1,%dl
  802cc1:	74 62                	je     802d25 <get_uvpt_entry+0x9a>
  802cc3:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  802cca:	7f 00 00 
  802ccd:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802cd1:	f6 c2 80             	test   $0x80,%dl
  802cd4:	75 4f                	jne    802d25 <get_uvpt_entry+0x9a>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802cd6:	48 89 f8             	mov    %rdi,%rax
  802cd9:	48 c1 e8 15          	shr    $0x15,%rax
  802cdd:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802ce4:	7f 00 00 
  802ce7:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802ceb:	f6 c2 01             	test   $0x1,%dl
  802cee:	74 44                	je     802d34 <get_uvpt_entry+0xa9>
  802cf0:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802cf7:	7f 00 00 
  802cfa:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802cfe:	f6 c2 80             	test   $0x80,%dl
  802d01:	75 31                	jne    802d34 <get_uvpt_entry+0xa9>
    return uvpt[VPT(va)];
  802d03:	48 c1 ef 0c          	shr    $0xc,%rdi
  802d07:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802d0e:	7f 00 00 
  802d11:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  802d15:	c3                   	ret
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802d16:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  802d1d:	7f 00 00 
  802d20:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802d24:	c3                   	ret
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  802d25:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  802d2c:	7f 00 00 
  802d2f:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802d33:	c3                   	ret
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802d34:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802d3b:	7f 00 00 
  802d3e:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802d42:	c3                   	ret

0000000000802d43 <get_phys_addr>:

uintptr_t
get_phys_addr(void *va) {
  802d43:	f3 0f 1e fa          	endbr64
  802d47:	48 89 fa             	mov    %rdi,%rdx
    if (!(uvpml4[VPML4(va)] & PTE_P))
  802d4a:	48 89 f9             	mov    %rdi,%rcx
  802d4d:	48 c1 e9 27          	shr    $0x27,%rcx
  802d51:	48 b8 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rax
  802d58:	7f 00 00 
  802d5b:	48 8b 0c c8          	mov    (%rax,%rcx,8),%rcx
        return -1;
  802d5f:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpml4[VPML4(va)] & PTE_P))
  802d66:	f6 c1 01             	test   $0x1,%cl
  802d69:	0f 84 b2 00 00 00    	je     802e21 <get_phys_addr+0xde>
    if (!(uvpdp[VPDP(va)] & PTE_P))
  802d6f:	48 89 f9             	mov    %rdi,%rcx
  802d72:	48 c1 e9 1e          	shr    $0x1e,%rcx
  802d76:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802d7d:	7f 00 00 
  802d80:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  802d84:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpdp[VPDP(va)] & PTE_P))
  802d8b:	40 f6 c6 01          	test   $0x1,%sil
  802d8f:	0f 84 8c 00 00 00    	je     802e21 <get_phys_addr+0xde>
    if (uvpdp[VPDP(va)] & PTE_PS)
  802d95:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802d9c:	7f 00 00 
  802d9f:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802da3:	a8 80                	test   $0x80,%al
  802da5:	75 7b                	jne    802e22 <get_phys_addr+0xdf>
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
    if (!(uvpd[VPD(va)] & PTE_P))
  802da7:	48 89 f9             	mov    %rdi,%rcx
  802daa:	48 c1 e9 15          	shr    $0x15,%rcx
  802dae:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  802db5:	7f 00 00 
  802db8:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  802dbc:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpd[VPD(va)] & PTE_P))
  802dc3:	40 f6 c6 01          	test   $0x1,%sil
  802dc7:	74 58                	je     802e21 <get_phys_addr+0xde>
    if ((uvpd[VPD(va)] & PTE_PS))
  802dc9:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  802dd0:	7f 00 00 
  802dd3:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802dd7:	a8 80                	test   $0x80,%al
  802dd9:	75 6c                	jne    802e47 <get_phys_addr+0x104>
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
    if (!(uvpt[VPT(va)] & PTE_P))
  802ddb:	48 89 f9             	mov    %rdi,%rcx
  802dde:	48 c1 e9 0c          	shr    $0xc,%rcx
  802de2:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802de9:	7f 00 00 
  802dec:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  802df0:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpt[VPT(va)] & PTE_P))
  802df7:	40 f6 c6 01          	test   $0x1,%sil
  802dfb:	74 24                	je     802e21 <get_phys_addr+0xde>
    return PTE_ADDR(uvpt[VPT(va)]) + PAGE_OFFSET(va);
  802dfd:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802e04:	7f 00 00 
  802e07:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802e0b:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802e12:	ff ff 7f 
  802e15:	48 21 c8             	and    %rcx,%rax
  802e18:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  802e1e:	48 09 d0             	or     %rdx,%rax
}
  802e21:	c3                   	ret
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
  802e22:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802e29:	7f 00 00 
  802e2c:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802e30:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802e37:	ff ff 7f 
  802e3a:	48 21 c8             	and    %rcx,%rax
  802e3d:	81 e2 ff ff ff 3f    	and    $0x3fffffff,%edx
  802e43:	48 01 d0             	add    %rdx,%rax
  802e46:	c3                   	ret
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
  802e47:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  802e4e:	7f 00 00 
  802e51:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802e55:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802e5c:	ff ff 7f 
  802e5f:	48 21 c8             	and    %rcx,%rax
  802e62:	81 e2 ff ff 1f 00    	and    $0x1fffff,%edx
  802e68:	48 01 d0             	add    %rdx,%rax
  802e6b:	c3                   	ret

0000000000802e6c <get_prot>:

int
get_prot(void *va) {
  802e6c:	f3 0f 1e fa          	endbr64
  802e70:	55                   	push   %rbp
  802e71:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802e74:	48 b8 8b 2c 80 00 00 	movabs $0x802c8b,%rax
  802e7b:	00 00 00 
  802e7e:	ff d0                	call   *%rax
  802e80:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
    if (pte & PTE_P) prot |= PROT_R;
  802e83:	83 e0 01             	and    $0x1,%eax
  802e86:	c1 e0 02             	shl    $0x2,%eax
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  802e89:	89 d1                	mov    %edx,%ecx
  802e8b:	81 e1 00 0a 00 00    	and    $0xa00,%ecx
    if (pte & PTE_P) prot |= PROT_R;
  802e91:	09 c8                	or     %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  802e93:	89 c1                	mov    %eax,%ecx
  802e95:	83 c9 02             	or     $0x2,%ecx
  802e98:	f6 c2 02             	test   $0x2,%dl
  802e9b:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  802e9e:	89 c1                	mov    %eax,%ecx
  802ea0:	83 c9 01             	or     $0x1,%ecx
  802ea3:	48 85 d2             	test   %rdx,%rdx
  802ea6:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  802ea9:	89 c1                	mov    %eax,%ecx
  802eab:	83 c9 40             	or     $0x40,%ecx
  802eae:	f6 c6 04             	test   $0x4,%dh
  802eb1:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  802eb4:	5d                   	pop    %rbp
  802eb5:	c3                   	ret

0000000000802eb6 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  802eb6:	f3 0f 1e fa          	endbr64
  802eba:	55                   	push   %rbp
  802ebb:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802ebe:	48 b8 8b 2c 80 00 00 	movabs $0x802c8b,%rax
  802ec5:	00 00 00 
  802ec8:	ff d0                	call   *%rax
    return pte & PTE_D;
  802eca:	48 c1 e8 06          	shr    $0x6,%rax
  802ece:	83 e0 01             	and    $0x1,%eax
}
  802ed1:	5d                   	pop    %rbp
  802ed2:	c3                   	ret

0000000000802ed3 <is_page_present>:

bool
is_page_present(void *va) {
  802ed3:	f3 0f 1e fa          	endbr64
  802ed7:	55                   	push   %rbp
  802ed8:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  802edb:	48 b8 8b 2c 80 00 00 	movabs $0x802c8b,%rax
  802ee2:	00 00 00 
  802ee5:	ff d0                	call   *%rax
  802ee7:	83 e0 01             	and    $0x1,%eax
}
  802eea:	5d                   	pop    %rbp
  802eeb:	c3                   	ret

0000000000802eec <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  802eec:	f3 0f 1e fa          	endbr64
  802ef0:	55                   	push   %rbp
  802ef1:	48 89 e5             	mov    %rsp,%rbp
  802ef4:	41 57                	push   %r15
  802ef6:	41 56                	push   %r14
  802ef8:	41 55                	push   %r13
  802efa:	41 54                	push   %r12
  802efc:	53                   	push   %rbx
  802efd:	48 83 ec 18          	sub    $0x18,%rsp
  802f01:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  802f05:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
     * NOTE: Skip over larger pages/page directories for efficiency */
    // LAB 11: Your code here:

    int res = 0;
    (void)fun, (void)arg;
    uintptr_t va = 0;
  802f09:	bb 00 00 00 00       	mov    $0x0,%ebx
    while (va < USER_STACK_TOP) {
        size_t size = 0;
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  802f0e:	49 be 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%r14
  802f15:	7f 00 00 
            size = 1LL << PML4_SHIFT;
            goto next;
        }

        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802f18:	49 bd 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%r13
  802f1f:	7f 00 00 
    while (va < USER_STACK_TOP) {
  802f22:	49 bf ff 6f ff ff 7f 	movabs $0x7fffff6fff,%r15
  802f29:	00 00 00 
  802f2c:	eb 73                	jmp    802fa1 <foreach_shared_region+0xb5>
            }

            goto next;
        }

        if (!(uvpd[VPD(va)] & PTE_P)) {
  802f2e:	48 89 d8             	mov    %rbx,%rax
  802f31:	48 c1 e8 15          	shr    $0x15,%rax
  802f35:	48 b9 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rcx
  802f3c:	7f 00 00 
  802f3f:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
            size = 1LL << PD_SHIFT;
  802f43:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
        if (!(uvpd[VPD(va)] & PTE_P)) {
  802f49:	f6 c2 01             	test   $0x1,%dl
  802f4c:	74 4b                	je     802f99 <foreach_shared_region+0xad>
            goto next;
        }

        if (uvpd[VPD(va)] & PTE_PS) {
  802f4e:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
  802f52:	f6 c2 80             	test   $0x80,%dl
  802f55:	74 11                	je     802f68 <foreach_shared_region+0x7c>
            size = 1LL << PD_SHIFT;
            if (uvpd[VPD(va)] & PTE_SHARE) {
  802f57:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
  802f5b:	f6 c4 04             	test   $0x4,%ah
  802f5e:	74 39                	je     802f99 <foreach_shared_region+0xad>
            size = 1LL << PD_SHIFT;
  802f60:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
  802f66:	eb 20                	jmp    802f88 <foreach_shared_region+0x9c>

            goto next;
        }

        size = PAGE_SIZE;
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  802f68:	48 89 da             	mov    %rbx,%rdx
  802f6b:	48 c1 ea 0c          	shr    $0xc,%rdx
  802f6f:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802f76:	7f 00 00 
  802f79:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
        size = PAGE_SIZE;
  802f7d:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  802f83:	f6 c4 04             	test   $0x4,%ah
  802f86:	74 11                	je     802f99 <foreach_shared_region+0xad>
            goto next;
        }

    map:
        fun((void *)va, (void *)(va + size), arg);
  802f88:	49 8d 34 1c          	lea    (%r12,%rbx,1),%rsi
  802f8c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802f90:	48 89 df             	mov    %rbx,%rdi
  802f93:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802f97:	ff d0                	call   *%rax
    next:
        va += size;
  802f99:	4c 01 e3             	add    %r12,%rbx
    while (va < USER_STACK_TOP) {
  802f9c:	49 39 df             	cmp    %rbx,%r15
  802f9f:	72 3e                	jb     802fdf <foreach_shared_region+0xf3>
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  802fa1:	49 8b 06             	mov    (%r14),%rax
  802fa4:	a8 01                	test   $0x1,%al
  802fa6:	74 37                	je     802fdf <foreach_shared_region+0xf3>
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802fa8:	48 89 d8             	mov    %rbx,%rax
  802fab:	48 c1 e8 1e          	shr    $0x1e,%rax
  802faf:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
            size = 1LL << PDP_SHIFT;
  802fb4:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802fba:	f6 c2 01             	test   $0x1,%dl
  802fbd:	74 da                	je     802f99 <foreach_shared_region+0xad>
        if (uvpdp[VPDP(va)] & PTE_PS) {
  802fbf:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
  802fc4:	f6 c2 80             	test   $0x80,%dl
  802fc7:	0f 84 61 ff ff ff    	je     802f2e <foreach_shared_region+0x42>
            if (uvpdp[VPDP(va)] & PTE_SHARE) {
  802fcd:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  802fd2:	f6 c4 04             	test   $0x4,%ah
  802fd5:	74 c2                	je     802f99 <foreach_shared_region+0xad>
            size = 1LL << PDP_SHIFT;
  802fd7:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
  802fdd:	eb a9                	jmp    802f88 <foreach_shared_region+0x9c>
    }
    return res;
}
  802fdf:	b8 00 00 00 00       	mov    $0x0,%eax
  802fe4:	48 83 c4 18          	add    $0x18,%rsp
  802fe8:	5b                   	pop    %rbx
  802fe9:	41 5c                	pop    %r12
  802feb:	41 5d                	pop    %r13
  802fed:	41 5e                	pop    %r14
  802fef:	41 5f                	pop    %r15
  802ff1:	5d                   	pop    %rbp
  802ff2:	c3                   	ret

0000000000802ff3 <devcons_close>:

    return res;
}

static int
devcons_close(struct Fd *fd) {
  802ff3:	f3 0f 1e fa          	endbr64
    USED(fd);

    return 0;
}
  802ff7:	b8 00 00 00 00       	mov    $0x0,%eax
  802ffc:	c3                   	ret

0000000000802ffd <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  802ffd:	f3 0f 1e fa          	endbr64
  803001:	55                   	push   %rbp
  803002:	48 89 e5             	mov    %rsp,%rbp
  803005:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  803008:	48 be 9d 42 80 00 00 	movabs $0x80429d,%rsi
  80300f:	00 00 00 
  803012:	48 b8 cc 0f 80 00 00 	movabs $0x800fcc,%rax
  803019:	00 00 00 
  80301c:	ff d0                	call   *%rax
    return 0;
}
  80301e:	b8 00 00 00 00       	mov    $0x0,%eax
  803023:	5d                   	pop    %rbp
  803024:	c3                   	ret

0000000000803025 <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  803025:	f3 0f 1e fa          	endbr64
  803029:	55                   	push   %rbp
  80302a:	48 89 e5             	mov    %rsp,%rbp
  80302d:	41 57                	push   %r15
  80302f:	41 56                	push   %r14
  803031:	41 55                	push   %r13
  803033:	41 54                	push   %r12
  803035:	53                   	push   %rbx
  803036:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  80303d:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  803044:	48 85 d2             	test   %rdx,%rdx
  803047:	74 7a                	je     8030c3 <devcons_write+0x9e>
  803049:	49 89 d6             	mov    %rdx,%r14
  80304c:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  803052:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  803057:	49 bf e7 11 80 00 00 	movabs $0x8011e7,%r15
  80305e:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  803061:	4c 89 f3             	mov    %r14,%rbx
  803064:	48 29 f3             	sub    %rsi,%rbx
  803067:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80306c:	48 39 c3             	cmp    %rax,%rbx
  80306f:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  803073:	4c 63 eb             	movslq %ebx,%r13
  803076:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  80307d:	48 01 c6             	add    %rax,%rsi
  803080:	4c 89 ea             	mov    %r13,%rdx
  803083:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  80308a:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  80308d:	4c 89 ee             	mov    %r13,%rsi
  803090:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  803097:	48 b8 2c 14 80 00 00 	movabs $0x80142c,%rax
  80309e:	00 00 00 
  8030a1:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  8030a3:	41 01 dc             	add    %ebx,%r12d
  8030a6:	49 63 f4             	movslq %r12d,%rsi
  8030a9:	4c 39 f6             	cmp    %r14,%rsi
  8030ac:	72 b3                	jb     803061 <devcons_write+0x3c>
    return res;
  8030ae:	49 63 c4             	movslq %r12d,%rax
}
  8030b1:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  8030b8:	5b                   	pop    %rbx
  8030b9:	41 5c                	pop    %r12
  8030bb:	41 5d                	pop    %r13
  8030bd:	41 5e                	pop    %r14
  8030bf:	41 5f                	pop    %r15
  8030c1:	5d                   	pop    %rbp
  8030c2:	c3                   	ret
    for (res = 0; res < n; res += inc) {
  8030c3:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  8030c9:	eb e3                	jmp    8030ae <devcons_write+0x89>

00000000008030cb <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  8030cb:	f3 0f 1e fa          	endbr64
  8030cf:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  8030d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8030d7:	48 85 c0             	test   %rax,%rax
  8030da:	74 55                	je     803131 <devcons_read+0x66>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  8030dc:	55                   	push   %rbp
  8030dd:	48 89 e5             	mov    %rsp,%rbp
  8030e0:	41 55                	push   %r13
  8030e2:	41 54                	push   %r12
  8030e4:	53                   	push   %rbx
  8030e5:	48 83 ec 08          	sub    $0x8,%rsp
  8030e9:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  8030ec:	48 bb 5d 14 80 00 00 	movabs $0x80145d,%rbx
  8030f3:	00 00 00 
  8030f6:	49 bc 36 15 80 00 00 	movabs $0x801536,%r12
  8030fd:	00 00 00 
  803100:	eb 03                	jmp    803105 <devcons_read+0x3a>
  803102:	41 ff d4             	call   *%r12
  803105:	ff d3                	call   *%rbx
  803107:	85 c0                	test   %eax,%eax
  803109:	74 f7                	je     803102 <devcons_read+0x37>
    if (c < 0) return c;
  80310b:	48 63 d0             	movslq %eax,%rdx
  80310e:	78 13                	js     803123 <devcons_read+0x58>
    if (c == 0x04) return 0;
  803110:	ba 00 00 00 00       	mov    $0x0,%edx
  803115:	83 f8 04             	cmp    $0x4,%eax
  803118:	74 09                	je     803123 <devcons_read+0x58>
    *(char *)vbuf = (char)c;
  80311a:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  80311e:	ba 01 00 00 00       	mov    $0x1,%edx
}
  803123:	48 89 d0             	mov    %rdx,%rax
  803126:	48 83 c4 08          	add    $0x8,%rsp
  80312a:	5b                   	pop    %rbx
  80312b:	41 5c                	pop    %r12
  80312d:	41 5d                	pop    %r13
  80312f:	5d                   	pop    %rbp
  803130:	c3                   	ret
  803131:	48 89 d0             	mov    %rdx,%rax
  803134:	c3                   	ret

0000000000803135 <cputchar>:
cputchar(int ch) {
  803135:	f3 0f 1e fa          	endbr64
  803139:	55                   	push   %rbp
  80313a:	48 89 e5             	mov    %rsp,%rbp
  80313d:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  803141:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  803145:	be 01 00 00 00       	mov    $0x1,%esi
  80314a:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  80314e:	48 b8 2c 14 80 00 00 	movabs $0x80142c,%rax
  803155:	00 00 00 
  803158:	ff d0                	call   *%rax
}
  80315a:	c9                   	leave
  80315b:	c3                   	ret

000000000080315c <getchar>:
getchar(void) {
  80315c:	f3 0f 1e fa          	endbr64
  803160:	55                   	push   %rbp
  803161:	48 89 e5             	mov    %rsp,%rbp
  803164:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  803168:	ba 01 00 00 00       	mov    $0x1,%edx
  80316d:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  803171:	bf 00 00 00 00       	mov    $0x0,%edi
  803176:	48 b8 b4 1e 80 00 00 	movabs $0x801eb4,%rax
  80317d:	00 00 00 
  803180:	ff d0                	call   *%rax
  803182:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  803184:	85 c0                	test   %eax,%eax
  803186:	78 06                	js     80318e <getchar+0x32>
  803188:	74 08                	je     803192 <getchar+0x36>
  80318a:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  80318e:	89 d0                	mov    %edx,%eax
  803190:	c9                   	leave
  803191:	c3                   	ret
    return res < 0 ? res : res ? c :
  803192:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  803197:	eb f5                	jmp    80318e <getchar+0x32>

0000000000803199 <iscons>:
iscons(int fdnum) {
  803199:	f3 0f 1e fa          	endbr64
  80319d:	55                   	push   %rbp
  80319e:	48 89 e5             	mov    %rsp,%rbp
  8031a1:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8031a5:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8031a9:	48 b8 b9 1b 80 00 00 	movabs $0x801bb9,%rax
  8031b0:	00 00 00 
  8031b3:	ff d0                	call   *%rax
    if (res < 0) return res;
  8031b5:	85 c0                	test   %eax,%eax
  8031b7:	78 18                	js     8031d1 <iscons+0x38>
    return fd->fd_dev_id == devcons.dev_id;
  8031b9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8031bd:	48 b8 a0 50 80 00 00 	movabs $0x8050a0,%rax
  8031c4:	00 00 00 
  8031c7:	8b 00                	mov    (%rax),%eax
  8031c9:	39 02                	cmp    %eax,(%rdx)
  8031cb:	0f 94 c0             	sete   %al
  8031ce:	0f b6 c0             	movzbl %al,%eax
}
  8031d1:	c9                   	leave
  8031d2:	c3                   	ret

00000000008031d3 <opencons>:
opencons(void) {
  8031d3:	f3 0f 1e fa          	endbr64
  8031d7:	55                   	push   %rbp
  8031d8:	48 89 e5             	mov    %rsp,%rbp
  8031db:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  8031df:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  8031e3:	48 b8 55 1b 80 00 00 	movabs $0x801b55,%rax
  8031ea:	00 00 00 
  8031ed:	ff d0                	call   *%rax
  8031ef:	85 c0                	test   %eax,%eax
  8031f1:	78 49                	js     80323c <opencons+0x69>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  8031f3:	b9 46 00 00 00       	mov    $0x46,%ecx
  8031f8:	ba 00 10 00 00       	mov    $0x1000,%edx
  8031fd:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  803201:	bf 00 00 00 00       	mov    $0x0,%edi
  803206:	48 b8 d1 15 80 00 00 	movabs $0x8015d1,%rax
  80320d:	00 00 00 
  803210:	ff d0                	call   *%rax
  803212:	85 c0                	test   %eax,%eax
  803214:	78 26                	js     80323c <opencons+0x69>
    fd->fd_dev_id = devcons.dev_id;
  803216:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80321a:	a1 a0 50 80 00 00 00 	movabs 0x8050a0,%eax
  803221:	00 00 
  803223:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  803225:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  803229:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  803230:	48 b8 1f 1b 80 00 00 	movabs $0x801b1f,%rax
  803237:	00 00 00 
  80323a:	ff d0                	call   *%rax
}
  80323c:	c9                   	leave
  80323d:	c3                   	ret

000000000080323e <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  80323e:	f3 0f 1e fa          	endbr64
  803242:	55                   	push   %rbp
  803243:	48 89 e5             	mov    %rsp,%rbp
  803246:	41 54                	push   %r12
  803248:	53                   	push   %rbx
  803249:	48 89 fb             	mov    %rdi,%rbx
  80324c:	48 89 f7             	mov    %rsi,%rdi
  80324f:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  803252:	48 85 f6             	test   %rsi,%rsi
  803255:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  80325c:	00 00 00 
  80325f:	48 0f 44 f8          	cmove  %rax,%rdi
    }
    int res = sys_ipc_recv(pg, PAGE_SIZE);
  803263:	be 00 10 00 00       	mov    $0x1000,%esi
  803268:	48 b8 f3 18 80 00 00 	movabs $0x8018f3,%rax
  80326f:	00 00 00 
  803272:	ff d0                	call   *%rax
    if (res < 0) {
  803274:	85 c0                	test   %eax,%eax
  803276:	78 45                	js     8032bd <ipc_recv+0x7f>
        if (perm_store != NULL) {
            *perm_store = 0;
        }
        return res;
    } else {
        if (from_env_store != NULL) {
  803278:	48 85 db             	test   %rbx,%rbx
  80327b:	74 12                	je     80328f <ipc_recv+0x51>
            *from_env_store = thisenv->env_ipc_from;
  80327d:	48 a1 00 64 80 00 00 	movabs 0x806400,%rax
  803284:	00 00 00 
  803287:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  80328d:	89 03                	mov    %eax,(%rbx)
        }
        if (perm_store != NULL) {
  80328f:	4d 85 e4             	test   %r12,%r12
  803292:	74 14                	je     8032a8 <ipc_recv+0x6a>
            *perm_store = thisenv->env_ipc_perm;
  803294:	48 a1 00 64 80 00 00 	movabs 0x806400,%rax
  80329b:	00 00 00 
  80329e:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  8032a4:	41 89 04 24          	mov    %eax,(%r12)
        }
        return thisenv->env_ipc_value;
  8032a8:	48 a1 00 64 80 00 00 	movabs 0x806400,%rax
  8032af:	00 00 00 
  8032b2:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
    }
    return -1;
}
  8032b8:	5b                   	pop    %rbx
  8032b9:	41 5c                	pop    %r12
  8032bb:	5d                   	pop    %rbp
  8032bc:	c3                   	ret
        if (from_env_store != NULL) {
  8032bd:	48 85 db             	test   %rbx,%rbx
  8032c0:	74 06                	je     8032c8 <ipc_recv+0x8a>
            *from_env_store = 0;
  8032c2:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store != NULL) {
  8032c8:	4d 85 e4             	test   %r12,%r12
  8032cb:	74 eb                	je     8032b8 <ipc_recv+0x7a>
            *perm_store = 0;
  8032cd:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  8032d4:	00 
  8032d5:	eb e1                	jmp    8032b8 <ipc_recv+0x7a>

00000000008032d7 <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  8032d7:	f3 0f 1e fa          	endbr64
  8032db:	55                   	push   %rbp
  8032dc:	48 89 e5             	mov    %rsp,%rbp
  8032df:	41 57                	push   %r15
  8032e1:	41 56                	push   %r14
  8032e3:	41 55                	push   %r13
  8032e5:	41 54                	push   %r12
  8032e7:	53                   	push   %rbx
  8032e8:	48 83 ec 18          	sub    $0x18,%rsp
  8032ec:	89 7d c4             	mov    %edi,-0x3c(%rbp)
  8032ef:	48 89 d3             	mov    %rdx,%rbx
  8032f2:	49 89 cc             	mov    %rcx,%r12
  8032f5:	45 89 c5             	mov    %r8d,%r13d
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  8032f8:	48 85 d2             	test   %rdx,%rdx
  8032fb:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  803302:	00 00 00 
  803305:	48 0f 44 d8          	cmove  %rax,%rbx
    }
    int res = sys_ipc_try_send(to_env, val, pg, size, perm);
  803309:	89 f0                	mov    %esi,%eax
  80330b:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  80330f:	48 89 da             	mov    %rbx,%rdx
  803312:	48 89 c6             	mov    %rax,%rsi
  803315:	48 b8 c3 18 80 00 00 	movabs $0x8018c3,%rax
  80331c:	00 00 00 
  80331f:	ff d0                	call   *%rax
    while (res < 0) {
  803321:	85 c0                	test   %eax,%eax
  803323:	79 65                	jns    80338a <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  803325:	83 f8 f5             	cmp    $0xfffffff5,%eax
  803328:	75 33                	jne    80335d <ipc_send+0x86>
            panic("Error: %i\n", res);
        }
        sys_yield();
  80332a:	49 bf 36 15 80 00 00 	movabs $0x801536,%r15
  803331:	00 00 00 
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  803334:	49 be c3 18 80 00 00 	movabs $0x8018c3,%r14
  80333b:	00 00 00 
        sys_yield();
  80333e:	41 ff d7             	call   *%r15
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  803341:	45 89 e8             	mov    %r13d,%r8d
  803344:	4c 89 e1             	mov    %r12,%rcx
  803347:	48 89 da             	mov    %rbx,%rdx
  80334a:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  80334e:	8b 7d c4             	mov    -0x3c(%rbp),%edi
  803351:	41 ff d6             	call   *%r14
    while (res < 0) {
  803354:	85 c0                	test   %eax,%eax
  803356:	79 32                	jns    80338a <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  803358:	83 f8 f5             	cmp    $0xfffffff5,%eax
  80335b:	74 e1                	je     80333e <ipc_send+0x67>
            panic("Error: %i\n", res);
  80335d:	89 c1                	mov    %eax,%ecx
  80335f:	48 ba a9 42 80 00 00 	movabs $0x8042a9,%rdx
  803366:	00 00 00 
  803369:	be 42 00 00 00       	mov    $0x42,%esi
  80336e:	48 bf b4 42 80 00 00 	movabs $0x8042b4,%rdi
  803375:	00 00 00 
  803378:	b8 00 00 00 00       	mov    $0x0,%eax
  80337d:	49 b8 27 05 80 00 00 	movabs $0x800527,%r8
  803384:	00 00 00 
  803387:	41 ff d0             	call   *%r8
    }
}
  80338a:	48 83 c4 18          	add    $0x18,%rsp
  80338e:	5b                   	pop    %rbx
  80338f:	41 5c                	pop    %r12
  803391:	41 5d                	pop    %r13
  803393:	41 5e                	pop    %r14
  803395:	41 5f                	pop    %r15
  803397:	5d                   	pop    %rbp
  803398:	c3                   	ret

0000000000803399 <ipc_find_env>:

/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
  803399:	f3 0f 1e fa          	endbr64
    for (size_t i = 0; i < NENV; i++)
  80339d:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  8033a2:	48 b9 00 00 a0 1f 80 	movabs $0x801fa00000,%rcx
  8033a9:	00 00 00 
  8033ac:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8033b0:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  8033b4:	48 c1 e2 04          	shl    $0x4,%rdx
  8033b8:	48 01 ca             	add    %rcx,%rdx
  8033bb:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  8033c1:	39 fa                	cmp    %edi,%edx
  8033c3:	74 12                	je     8033d7 <ipc_find_env+0x3e>
    for (size_t i = 0; i < NENV; i++)
  8033c5:	48 83 c0 01          	add    $0x1,%rax
  8033c9:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  8033cf:	75 db                	jne    8033ac <ipc_find_env+0x13>
            return envs[i].env_id;
    return 0;
  8033d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8033d6:	c3                   	ret
            return envs[i].env_id;
  8033d7:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8033db:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  8033df:	48 c1 e2 04          	shl    $0x4,%rdx
  8033e3:	48 b8 00 00 a0 1f 80 	movabs $0x801fa00000,%rax
  8033ea:	00 00 00 
  8033ed:	48 01 d0             	add    %rdx,%rax
  8033f0:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8033f6:	c3                   	ret

00000000008033f7 <__text_end>:
  8033f7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8033fe:	00 00 00 
  803401:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803408:	00 00 00 
  80340b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803412:	00 00 00 
  803415:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80341c:	00 00 00 
  80341f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803426:	00 00 00 
  803429:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803430:	00 00 00 
  803433:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80343a:	00 00 00 
  80343d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803444:	00 00 00 
  803447:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80344e:	00 00 00 
  803451:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803458:	00 00 00 
  80345b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803462:	00 00 00 
  803465:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80346c:	00 00 00 
  80346f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803476:	00 00 00 
  803479:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803480:	00 00 00 
  803483:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80348a:	00 00 00 
  80348d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803494:	00 00 00 
  803497:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80349e:	00 00 00 
  8034a1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034a8:	00 00 00 
  8034ab:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034b2:	00 00 00 
  8034b5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034bc:	00 00 00 
  8034bf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034c6:	00 00 00 
  8034c9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034d0:	00 00 00 
  8034d3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034da:	00 00 00 
  8034dd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034e4:	00 00 00 
  8034e7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034ee:	00 00 00 
  8034f1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8034f8:	00 00 00 
  8034fb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803502:	00 00 00 
  803505:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80350c:	00 00 00 
  80350f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803516:	00 00 00 
  803519:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803520:	00 00 00 
  803523:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80352a:	00 00 00 
  80352d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803534:	00 00 00 
  803537:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80353e:	00 00 00 
  803541:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803548:	00 00 00 
  80354b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803552:	00 00 00 
  803555:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80355c:	00 00 00 
  80355f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803566:	00 00 00 
  803569:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803570:	00 00 00 
  803573:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80357a:	00 00 00 
  80357d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803584:	00 00 00 
  803587:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80358e:	00 00 00 
  803591:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803598:	00 00 00 
  80359b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035a2:	00 00 00 
  8035a5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035ac:	00 00 00 
  8035af:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035b6:	00 00 00 
  8035b9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035c0:	00 00 00 
  8035c3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035ca:	00 00 00 
  8035cd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035d4:	00 00 00 
  8035d7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035de:	00 00 00 
  8035e1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035e8:	00 00 00 
  8035eb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035f2:	00 00 00 
  8035f5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8035fc:	00 00 00 
  8035ff:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803606:	00 00 00 
  803609:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803610:	00 00 00 
  803613:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80361a:	00 00 00 
  80361d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803624:	00 00 00 
  803627:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80362e:	00 00 00 
  803631:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803638:	00 00 00 
  80363b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803642:	00 00 00 
  803645:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80364c:	00 00 00 
  80364f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803656:	00 00 00 
  803659:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803660:	00 00 00 
  803663:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80366a:	00 00 00 
  80366d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803674:	00 00 00 
  803677:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80367e:	00 00 00 
  803681:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803688:	00 00 00 
  80368b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803692:	00 00 00 
  803695:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80369c:	00 00 00 
  80369f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036a6:	00 00 00 
  8036a9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036b0:	00 00 00 
  8036b3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036ba:	00 00 00 
  8036bd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036c4:	00 00 00 
  8036c7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036ce:	00 00 00 
  8036d1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036d8:	00 00 00 
  8036db:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036e2:	00 00 00 
  8036e5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036ec:	00 00 00 
  8036ef:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8036f6:	00 00 00 
  8036f9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803700:	00 00 00 
  803703:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80370a:	00 00 00 
  80370d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803714:	00 00 00 
  803717:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80371e:	00 00 00 
  803721:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803728:	00 00 00 
  80372b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803732:	00 00 00 
  803735:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80373c:	00 00 00 
  80373f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803746:	00 00 00 
  803749:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803750:	00 00 00 
  803753:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80375a:	00 00 00 
  80375d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803764:	00 00 00 
  803767:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80376e:	00 00 00 
  803771:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803778:	00 00 00 
  80377b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803782:	00 00 00 
  803785:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80378c:	00 00 00 
  80378f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803796:	00 00 00 
  803799:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037a0:	00 00 00 
  8037a3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037aa:	00 00 00 
  8037ad:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037b4:	00 00 00 
  8037b7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037be:	00 00 00 
  8037c1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037c8:	00 00 00 
  8037cb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037d2:	00 00 00 
  8037d5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037dc:	00 00 00 
  8037df:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037e6:	00 00 00 
  8037e9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037f0:	00 00 00 
  8037f3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8037fa:	00 00 00 
  8037fd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803804:	00 00 00 
  803807:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80380e:	00 00 00 
  803811:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803818:	00 00 00 
  80381b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803822:	00 00 00 
  803825:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80382c:	00 00 00 
  80382f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803836:	00 00 00 
  803839:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803840:	00 00 00 
  803843:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80384a:	00 00 00 
  80384d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803854:	00 00 00 
  803857:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80385e:	00 00 00 
  803861:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803868:	00 00 00 
  80386b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803872:	00 00 00 
  803875:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80387c:	00 00 00 
  80387f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803886:	00 00 00 
  803889:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803890:	00 00 00 
  803893:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80389a:	00 00 00 
  80389d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038a4:	00 00 00 
  8038a7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038ae:	00 00 00 
  8038b1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038b8:	00 00 00 
  8038bb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038c2:	00 00 00 
  8038c5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038cc:	00 00 00 
  8038cf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038d6:	00 00 00 
  8038d9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038e0:	00 00 00 
  8038e3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038ea:	00 00 00 
  8038ed:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038f4:	00 00 00 
  8038f7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8038fe:	00 00 00 
  803901:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803908:	00 00 00 
  80390b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803912:	00 00 00 
  803915:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80391c:	00 00 00 
  80391f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803926:	00 00 00 
  803929:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803930:	00 00 00 
  803933:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80393a:	00 00 00 
  80393d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803944:	00 00 00 
  803947:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80394e:	00 00 00 
  803951:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803958:	00 00 00 
  80395b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803962:	00 00 00 
  803965:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80396c:	00 00 00 
  80396f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803976:	00 00 00 
  803979:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803980:	00 00 00 
  803983:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80398a:	00 00 00 
  80398d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803994:	00 00 00 
  803997:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  80399e:	00 00 00 
  8039a1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039a8:	00 00 00 
  8039ab:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039b2:	00 00 00 
  8039b5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039bc:	00 00 00 
  8039bf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039c6:	00 00 00 
  8039c9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039d0:	00 00 00 
  8039d3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039da:	00 00 00 
  8039dd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039e4:	00 00 00 
  8039e7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039ee:	00 00 00 
  8039f1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  8039f8:	00 00 00 
  8039fb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a02:	00 00 00 
  803a05:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a0c:	00 00 00 
  803a0f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a16:	00 00 00 
  803a19:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a20:	00 00 00 
  803a23:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a2a:	00 00 00 
  803a2d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a34:	00 00 00 
  803a37:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a3e:	00 00 00 
  803a41:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a48:	00 00 00 
  803a4b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a52:	00 00 00 
  803a55:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a5c:	00 00 00 
  803a5f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a66:	00 00 00 
  803a69:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a70:	00 00 00 
  803a73:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a7a:	00 00 00 
  803a7d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a84:	00 00 00 
  803a87:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a8e:	00 00 00 
  803a91:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803a98:	00 00 00 
  803a9b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803aa2:	00 00 00 
  803aa5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803aac:	00 00 00 
  803aaf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ab6:	00 00 00 
  803ab9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ac0:	00 00 00 
  803ac3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803aca:	00 00 00 
  803acd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ad4:	00 00 00 
  803ad7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ade:	00 00 00 
  803ae1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ae8:	00 00 00 
  803aeb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803af2:	00 00 00 
  803af5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803afc:	00 00 00 
  803aff:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b06:	00 00 00 
  803b09:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b10:	00 00 00 
  803b13:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b1a:	00 00 00 
  803b1d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b24:	00 00 00 
  803b27:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b2e:	00 00 00 
  803b31:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b38:	00 00 00 
  803b3b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b42:	00 00 00 
  803b45:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b4c:	00 00 00 
  803b4f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b56:	00 00 00 
  803b59:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b60:	00 00 00 
  803b63:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b6a:	00 00 00 
  803b6d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b74:	00 00 00 
  803b77:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b7e:	00 00 00 
  803b81:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b88:	00 00 00 
  803b8b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b92:	00 00 00 
  803b95:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803b9c:	00 00 00 
  803b9f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ba6:	00 00 00 
  803ba9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bb0:	00 00 00 
  803bb3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bba:	00 00 00 
  803bbd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bc4:	00 00 00 
  803bc7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bce:	00 00 00 
  803bd1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bd8:	00 00 00 
  803bdb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803be2:	00 00 00 
  803be5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bec:	00 00 00 
  803bef:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803bf6:	00 00 00 
  803bf9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c00:	00 00 00 
  803c03:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c0a:	00 00 00 
  803c0d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c14:	00 00 00 
  803c17:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c1e:	00 00 00 
  803c21:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c28:	00 00 00 
  803c2b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c32:	00 00 00 
  803c35:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c3c:	00 00 00 
  803c3f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c46:	00 00 00 
  803c49:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c50:	00 00 00 
  803c53:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c5a:	00 00 00 
  803c5d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c64:	00 00 00 
  803c67:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c6e:	00 00 00 
  803c71:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c78:	00 00 00 
  803c7b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c82:	00 00 00 
  803c85:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c8c:	00 00 00 
  803c8f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c96:	00 00 00 
  803c99:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ca0:	00 00 00 
  803ca3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803caa:	00 00 00 
  803cad:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cb4:	00 00 00 
  803cb7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cbe:	00 00 00 
  803cc1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cc8:	00 00 00 
  803ccb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cd2:	00 00 00 
  803cd5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cdc:	00 00 00 
  803cdf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ce6:	00 00 00 
  803ce9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cf0:	00 00 00 
  803cf3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cfa:	00 00 00 
  803cfd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d04:	00 00 00 
  803d07:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d0e:	00 00 00 
  803d11:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d18:	00 00 00 
  803d1b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d22:	00 00 00 
  803d25:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d2c:	00 00 00 
  803d2f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d36:	00 00 00 
  803d39:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d40:	00 00 00 
  803d43:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d4a:	00 00 00 
  803d4d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d54:	00 00 00 
  803d57:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d5e:	00 00 00 
  803d61:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d68:	00 00 00 
  803d6b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d72:	00 00 00 
  803d75:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d7c:	00 00 00 
  803d7f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d86:	00 00 00 
  803d89:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d90:	00 00 00 
  803d93:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d9a:	00 00 00 
  803d9d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803da4:	00 00 00 
  803da7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dae:	00 00 00 
  803db1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803db8:	00 00 00 
  803dbb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dc2:	00 00 00 
  803dc5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dcc:	00 00 00 
  803dcf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dd6:	00 00 00 
  803dd9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803de0:	00 00 00 
  803de3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dea:	00 00 00 
  803ded:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803df4:	00 00 00 
  803df7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dfe:	00 00 00 
  803e01:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e08:	00 00 00 
  803e0b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e12:	00 00 00 
  803e15:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e1c:	00 00 00 
  803e1f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e26:	00 00 00 
  803e29:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e30:	00 00 00 
  803e33:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e3a:	00 00 00 
  803e3d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e44:	00 00 00 
  803e47:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e4e:	00 00 00 
  803e51:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e58:	00 00 00 
  803e5b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e62:	00 00 00 
  803e65:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e6c:	00 00 00 
  803e6f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e76:	00 00 00 
  803e79:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e80:	00 00 00 
  803e83:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e8a:	00 00 00 
  803e8d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e94:	00 00 00 
  803e97:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e9e:	00 00 00 
  803ea1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ea8:	00 00 00 
  803eab:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803eb2:	00 00 00 
  803eb5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ebc:	00 00 00 
  803ebf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ec6:	00 00 00 
  803ec9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ed0:	00 00 00 
  803ed3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803eda:	00 00 00 
  803edd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ee4:	00 00 00 
  803ee7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803eee:	00 00 00 
  803ef1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ef8:	00 00 00 
  803efb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f02:	00 00 00 
  803f05:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f0c:	00 00 00 
  803f0f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f16:	00 00 00 
  803f19:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f20:	00 00 00 
  803f23:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f2a:	00 00 00 
  803f2d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f34:	00 00 00 
  803f37:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f3e:	00 00 00 
  803f41:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f48:	00 00 00 
  803f4b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f52:	00 00 00 
  803f55:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f5c:	00 00 00 
  803f5f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f66:	00 00 00 
  803f69:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f70:	00 00 00 
  803f73:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f7a:	00 00 00 
  803f7d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f84:	00 00 00 
  803f87:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f8e:	00 00 00 
  803f91:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f98:	00 00 00 
  803f9b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fa2:	00 00 00 
  803fa5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fac:	00 00 00 
  803faf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fb6:	00 00 00 
  803fb9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fc0:	00 00 00 
  803fc3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fca:	00 00 00 
  803fcd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fd4:	00 00 00 
  803fd7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fde:	00 00 00 
  803fe1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fe8:	00 00 00 
  803feb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ff2:	00 00 00 
  803ff5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ffc:	00 00 00 
  803fff:	90                   	nop
