
obj/user/echo:     file format elf64-x86-64


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
  80001e:	e8 f4 00 00 00       	call   800117 <libmain>
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
  800036:	48 83 ec 18          	sub    $0x18,%rsp
    int i, nflag;

    nflag = 0;
    if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  80003a:	83 ff 01             	cmp    $0x1,%edi
  80003d:	7f 25                	jg     800064 <umain+0x3f>
        if (i > 1)
            write(1, " ", 1);
        write(1, argv[i], strlen(argv[i]));
    }
    if (!nflag)
        write(1, "\n", 1);
  80003f:	ba 01 00 00 00       	mov    $0x1,%edx
  800044:	48 be 37 30 80 00 00 	movabs $0x803037,%rsi
  80004b:	00 00 00 
  80004e:	bf 01 00 00 00       	mov    $0x1,%edi
  800053:	48 b8 ca 10 80 00 00 	movabs $0x8010ca,%rax
  80005a:	00 00 00 
  80005d:	ff d0                	call   *%rax
}
  80005f:	e9 a4 00 00 00       	jmp    800108 <umain+0xe3>
  800064:	41 89 fe             	mov    %edi,%r14d
  800067:	49 89 f4             	mov    %rsi,%r12
    if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  80006a:	48 8b 7e 08          	mov    0x8(%rsi),%rdi
  80006e:	48 be 00 30 80 00 00 	movabs $0x803000,%rsi
  800075:	00 00 00 
  800078:	48 b8 e9 02 80 00 00 	movabs $0x8002e9,%rax
  80007f:	00 00 00 
  800082:	ff d0                	call   *%rax
  800084:	85 c0                	test   %eax,%eax
  800086:	75 30                	jne    8000b8 <umain+0x93>
        argc--;
  800088:	41 83 ee 01          	sub    $0x1,%r14d
        argv++;
  80008c:	49 83 c4 08          	add    $0x8,%r12
    for (i = 1; i < argc; i++) {
  800090:	41 83 fe 01          	cmp    $0x1,%r14d
  800094:	7e 72                	jle    800108 <umain+0xe3>
        nflag = 1;
  800096:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%rbp)
  80009d:	bb 01 00 00 00       	mov    $0x1,%ebx
            write(1, " ", 1);
  8000a2:	49 bd ca 10 80 00 00 	movabs $0x8010ca,%r13
  8000a9:	00 00 00 
        write(1, argv[i], strlen(argv[i]));
  8000ac:	49 bf f0 01 80 00 00 	movabs $0x8001f0,%r15
  8000b3:	00 00 00 
  8000b6:	eb 28                	jmp    8000e0 <umain+0xbb>
  8000b8:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
  8000bf:	eb dc                	jmp    80009d <umain+0x78>
  8000c1:	49 8b 3c dc          	mov    (%r12,%rbx,8),%rdi
  8000c5:	41 ff d7             	call   *%r15
  8000c8:	48 89 c2             	mov    %rax,%rdx
  8000cb:	49 8b 34 dc          	mov    (%r12,%rbx,8),%rsi
  8000cf:	bf 01 00 00 00       	mov    $0x1,%edi
  8000d4:	41 ff d5             	call   *%r13
    for (i = 1; i < argc; i++) {
  8000d7:	48 83 c3 01          	add    $0x1,%rbx
  8000db:	41 39 de             	cmp    %ebx,%r14d
  8000de:	7e 1e                	jle    8000fe <umain+0xd9>
        if (i > 1)
  8000e0:	83 fb 01             	cmp    $0x1,%ebx
  8000e3:	7e dc                	jle    8000c1 <umain+0x9c>
            write(1, " ", 1);
  8000e5:	ba 01 00 00 00       	mov    $0x1,%edx
  8000ea:	48 be 03 30 80 00 00 	movabs $0x803003,%rsi
  8000f1:	00 00 00 
  8000f4:	bf 01 00 00 00       	mov    $0x1,%edi
  8000f9:	41 ff d5             	call   *%r13
  8000fc:	eb c3                	jmp    8000c1 <umain+0x9c>
    if (!nflag)
  8000fe:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  800102:	0f 84 37 ff ff ff    	je     80003f <umain+0x1a>
}
  800108:	48 83 c4 18          	add    $0x18,%rsp
  80010c:	5b                   	pop    %rbx
  80010d:	41 5c                	pop    %r12
  80010f:	41 5d                	pop    %r13
  800111:	41 5e                	pop    %r14
  800113:	41 5f                	pop    %r15
  800115:	5d                   	pop    %rbp
  800116:	c3                   	ret

0000000000800117 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  800117:	f3 0f 1e fa          	endbr64
  80011b:	55                   	push   %rbp
  80011c:	48 89 e5             	mov    %rsp,%rbp
  80011f:	41 56                	push   %r14
  800121:	41 55                	push   %r13
  800123:	41 54                	push   %r12
  800125:	53                   	push   %rbx
  800126:	41 89 fd             	mov    %edi,%r13d
  800129:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
     * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  80012c:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  800133:	00 00 00 
  800136:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  80013d:	00 00 00 
  800140:	48 39 c2             	cmp    %rax,%rdx
  800143:	73 17                	jae    80015c <libmain+0x45>
    void (**ctor)() = &__ctors_start;
  800145:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  800148:	49 89 c4             	mov    %rax,%r12
  80014b:	48 83 c3 08          	add    $0x8,%rbx
  80014f:	b8 00 00 00 00       	mov    $0x0,%eax
  800154:	ff 53 f8             	call   *-0x8(%rbx)
  800157:	4c 39 e3             	cmp    %r12,%rbx
  80015a:	72 ef                	jb     80014b <libmain+0x34>

    /* Set thisenv to point at our Env structure in envs[]. */

    // LAB 8: Your code here
    thisenv = &((struct Env *)UENVS)[ENVX(sys_getenvid())];
  80015c:	48 b8 6a 07 80 00 00 	movabs $0x80076a,%rax
  800163:	00 00 00 
  800166:	ff d0                	call   *%rax
  800168:	25 ff 03 00 00       	and    $0x3ff,%eax
  80016d:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  800171:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  800175:	48 c1 e0 04          	shl    $0x4,%rax
  800179:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  800180:	00 00 00 
  800183:	48 01 d0             	add    %rdx,%rax
  800186:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  80018d:	00 00 00 

    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  800190:	45 85 ed             	test   %r13d,%r13d
  800193:	7e 0d                	jle    8001a2 <libmain+0x8b>
  800195:	49 8b 06             	mov    (%r14),%rax
  800198:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  80019f:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  8001a2:	4c 89 f6             	mov    %r14,%rsi
  8001a5:	44 89 ef             	mov    %r13d,%edi
  8001a8:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  8001af:	00 00 00 
  8001b2:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  8001b4:	48 b8 c9 01 80 00 00 	movabs $0x8001c9,%rax
  8001bb:	00 00 00 
  8001be:	ff d0                	call   *%rax
#endif
}
  8001c0:	5b                   	pop    %rbx
  8001c1:	41 5c                	pop    %r12
  8001c3:	41 5d                	pop    %r13
  8001c5:	41 5e                	pop    %r14
  8001c7:	5d                   	pop    %rbp
  8001c8:	c3                   	ret

00000000008001c9 <exit>:

#include <inc/lib.h>

void
exit(void) {
  8001c9:	f3 0f 1e fa          	endbr64
  8001cd:	55                   	push   %rbp
  8001ce:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  8001d1:	48 b8 40 0e 80 00 00 	movabs $0x800e40,%rax
  8001d8:	00 00 00 
  8001db:	ff d0                	call   *%rax
    sys_env_destroy(0);
  8001dd:	bf 00 00 00 00       	mov    $0x0,%edi
  8001e2:	48 b8 fb 06 80 00 00 	movabs $0x8006fb,%rax
  8001e9:	00 00 00 
  8001ec:	ff d0                	call   *%rax
}
  8001ee:	5d                   	pop    %rbp
  8001ef:	c3                   	ret

00000000008001f0 <strlen>:
 * Primespipe runs 3x faster this way */

#define ASM 1

size_t
strlen(const char *s) {
  8001f0:	f3 0f 1e fa          	endbr64
    size_t n = 0;
    while (*s++) n++;
  8001f4:	80 3f 00             	cmpb   $0x0,(%rdi)
  8001f7:	74 10                	je     800209 <strlen+0x19>
    size_t n = 0;
  8001f9:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  8001fe:	48 83 c0 01          	add    $0x1,%rax
  800202:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800206:	75 f6                	jne    8001fe <strlen+0xe>
  800208:	c3                   	ret
    size_t n = 0;
  800209:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  80020e:	c3                   	ret

000000000080020f <strnlen>:

size_t
strnlen(const char *s, size_t size) {
  80020f:	f3 0f 1e fa          	endbr64
  800213:	48 89 f0             	mov    %rsi,%rax
    size_t n = 0;
  800216:	ba 00 00 00 00       	mov    $0x0,%edx
    while (n < size && *s++) n++;
  80021b:	48 85 f6             	test   %rsi,%rsi
  80021e:	74 10                	je     800230 <strnlen+0x21>
  800220:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  800224:	74 0b                	je     800231 <strnlen+0x22>
  800226:	48 83 c2 01          	add    $0x1,%rdx
  80022a:	48 39 d0             	cmp    %rdx,%rax
  80022d:	75 f1                	jne    800220 <strnlen+0x11>
  80022f:	c3                   	ret
  800230:	c3                   	ret
  800231:	48 89 d0             	mov    %rdx,%rax
    return n;
}
  800234:	c3                   	ret

0000000000800235 <strcpy>:

char *
strcpy(char *dst, const char *src) {
  800235:	f3 0f 1e fa          	endbr64
  800239:	48 89 f8             	mov    %rdi,%rax
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  80023c:	ba 00 00 00 00       	mov    $0x0,%edx
  800241:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  800245:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  800248:	48 83 c2 01          	add    $0x1,%rdx
  80024c:	84 c9                	test   %cl,%cl
  80024e:	75 f1                	jne    800241 <strcpy+0xc>
        ;
    return res;
}
  800250:	c3                   	ret

0000000000800251 <strcat>:

char *
strcat(char *dst, const char *src) {
  800251:	f3 0f 1e fa          	endbr64
  800255:	55                   	push   %rbp
  800256:	48 89 e5             	mov    %rsp,%rbp
  800259:	41 54                	push   %r12
  80025b:	53                   	push   %rbx
  80025c:	48 89 fb             	mov    %rdi,%rbx
  80025f:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800262:	48 b8 f0 01 80 00 00 	movabs $0x8001f0,%rax
  800269:	00 00 00 
  80026c:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  80026e:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800272:	4c 89 e6             	mov    %r12,%rsi
  800275:	48 b8 35 02 80 00 00 	movabs $0x800235,%rax
  80027c:	00 00 00 
  80027f:	ff d0                	call   *%rax
    return dst;
}
  800281:	48 89 d8             	mov    %rbx,%rax
  800284:	5b                   	pop    %rbx
  800285:	41 5c                	pop    %r12
  800287:	5d                   	pop    %rbp
  800288:	c3                   	ret

0000000000800289 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800289:	f3 0f 1e fa          	endbr64
  80028d:	48 89 f8             	mov    %rdi,%rax
    char *ret = dst;
    while (size-- > 0) {
  800290:	48 85 d2             	test   %rdx,%rdx
  800293:	74 1f                	je     8002b4 <strncpy+0x2b>
  800295:	48 01 fa             	add    %rdi,%rdx
  800298:	48 89 f9             	mov    %rdi,%rcx
        *dst++ = *src;
  80029b:	48 83 c1 01          	add    $0x1,%rcx
  80029f:	44 0f b6 06          	movzbl (%rsi),%r8d
  8002a3:	44 88 41 ff          	mov    %r8b,-0x1(%rcx)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  8002a7:	41 80 f8 01          	cmp    $0x1,%r8b
  8002ab:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  8002af:	48 39 ca             	cmp    %rcx,%rdx
  8002b2:	75 e7                	jne    80029b <strncpy+0x12>
    }
    return ret;
}
  8002b4:	c3                   	ret

00000000008002b5 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
  8002b5:	f3 0f 1e fa          	endbr64
    char *dst_in = dst;
    if (size) {
  8002b9:	48 89 f8             	mov    %rdi,%rax
  8002bc:	48 85 d2             	test   %rdx,%rdx
  8002bf:	74 24                	je     8002e5 <strlcpy+0x30>
        while (--size > 0 && *src)
  8002c1:	48 83 ea 01          	sub    $0x1,%rdx
  8002c5:	74 1b                	je     8002e2 <strlcpy+0x2d>
  8002c7:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  8002cb:	0f b6 16             	movzbl (%rsi),%edx
  8002ce:	84 d2                	test   %dl,%dl
  8002d0:	74 10                	je     8002e2 <strlcpy+0x2d>
            *dst++ = *src++;
  8002d2:	48 83 c6 01          	add    $0x1,%rsi
  8002d6:	48 83 c0 01          	add    $0x1,%rax
  8002da:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  8002dd:	48 39 c8             	cmp    %rcx,%rax
  8002e0:	75 e9                	jne    8002cb <strlcpy+0x16>
        *dst = '\0';
  8002e2:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  8002e5:	48 29 f8             	sub    %rdi,%rax
}
  8002e8:	c3                   	ret

00000000008002e9 <strcmp>:
    }
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
  8002e9:	f3 0f 1e fa          	endbr64
    while (*p && *p == *q) p++, q++;
  8002ed:	0f b6 07             	movzbl (%rdi),%eax
  8002f0:	84 c0                	test   %al,%al
  8002f2:	74 13                	je     800307 <strcmp+0x1e>
  8002f4:	38 06                	cmp    %al,(%rsi)
  8002f6:	75 0f                	jne    800307 <strcmp+0x1e>
  8002f8:	48 83 c7 01          	add    $0x1,%rdi
  8002fc:	48 83 c6 01          	add    $0x1,%rsi
  800300:	0f b6 07             	movzbl (%rdi),%eax
  800303:	84 c0                	test   %al,%al
  800305:	75 ed                	jne    8002f4 <strcmp+0xb>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800307:	0f b6 c0             	movzbl %al,%eax
  80030a:	0f b6 16             	movzbl (%rsi),%edx
  80030d:	29 d0                	sub    %edx,%eax
}
  80030f:	c3                   	ret

0000000000800310 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
  800310:	f3 0f 1e fa          	endbr64
    while (n && *p && *p == *q) n--, p++, q++;
  800314:	48 85 d2             	test   %rdx,%rdx
  800317:	74 1f                	je     800338 <strncmp+0x28>
  800319:	0f b6 07             	movzbl (%rdi),%eax
  80031c:	84 c0                	test   %al,%al
  80031e:	74 1e                	je     80033e <strncmp+0x2e>
  800320:	3a 06                	cmp    (%rsi),%al
  800322:	75 1a                	jne    80033e <strncmp+0x2e>
  800324:	48 83 c7 01          	add    $0x1,%rdi
  800328:	48 83 c6 01          	add    $0x1,%rsi
  80032c:	48 83 ea 01          	sub    $0x1,%rdx
  800330:	75 e7                	jne    800319 <strncmp+0x9>

    if (!n) return 0;
  800332:	b8 00 00 00 00       	mov    $0x0,%eax
  800337:	c3                   	ret
  800338:	b8 00 00 00 00       	mov    $0x0,%eax
  80033d:	c3                   	ret

    return (int)((unsigned char)*p - (unsigned char)*q);
  80033e:	0f b6 07             	movzbl (%rdi),%eax
  800341:	0f b6 16             	movzbl (%rsi),%edx
  800344:	29 d0                	sub    %edx,%eax
}
  800346:	c3                   	ret

0000000000800347 <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
  800347:	f3 0f 1e fa          	endbr64
    for (; *str; str++) {
  80034b:	0f b6 17             	movzbl (%rdi),%edx
  80034e:	84 d2                	test   %dl,%dl
  800350:	74 18                	je     80036a <strchr+0x23>
        if (*str == c) {
  800352:	0f be d2             	movsbl %dl,%edx
  800355:	39 f2                	cmp    %esi,%edx
  800357:	74 17                	je     800370 <strchr+0x29>
    for (; *str; str++) {
  800359:	48 83 c7 01          	add    $0x1,%rdi
  80035d:	0f b6 17             	movzbl (%rdi),%edx
  800360:	84 d2                	test   %dl,%dl
  800362:	75 ee                	jne    800352 <strchr+0xb>
            return (char *)str;
        }
    }
    return NULL;
  800364:	b8 00 00 00 00       	mov    $0x0,%eax
  800369:	c3                   	ret
  80036a:	b8 00 00 00 00       	mov    $0x0,%eax
  80036f:	c3                   	ret
            return (char *)str;
  800370:	48 89 f8             	mov    %rdi,%rax
}
  800373:	c3                   	ret

0000000000800374 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
  800374:	f3 0f 1e fa          	endbr64
  800378:	48 89 f8             	mov    %rdi,%rax
    for (; *str && *str != ch; str++) /* nothing */
  80037b:	0f b6 17             	movzbl (%rdi),%edx
  80037e:	84 d2                	test   %dl,%dl
  800380:	74 13                	je     800395 <strfind+0x21>
  800382:	0f be d2             	movsbl %dl,%edx
  800385:	39 f2                	cmp    %esi,%edx
  800387:	74 0b                	je     800394 <strfind+0x20>
  800389:	48 83 c0 01          	add    $0x1,%rax
  80038d:	0f b6 10             	movzbl (%rax),%edx
  800390:	84 d2                	test   %dl,%dl
  800392:	75 ee                	jne    800382 <strfind+0xe>
        ;
    return (char *)str;
}
  800394:	c3                   	ret
  800395:	c3                   	ret

0000000000800396 <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  800396:	f3 0f 1e fa          	endbr64
  80039a:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  80039d:	48 89 f8             	mov    %rdi,%rax
  8003a0:	48 f7 d8             	neg    %rax
  8003a3:	83 e0 07             	and    $0x7,%eax
  8003a6:	49 89 d1             	mov    %rdx,%r9
  8003a9:	49 29 c1             	sub    %rax,%r9
  8003ac:	78 36                	js     8003e4 <memset+0x4e>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  8003ae:	40 0f b6 c6          	movzbl %sil,%eax
  8003b2:	48 b9 01 01 01 01 01 	movabs $0x101010101010101,%rcx
  8003b9:	01 01 01 
  8003bc:	48 0f af c1          	imul   %rcx,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  8003c0:	40 f6 c7 07          	test   $0x7,%dil
  8003c4:	75 38                	jne    8003fe <memset+0x68>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  8003c6:	4c 89 c9             	mov    %r9,%rcx
  8003c9:	48 c1 f9 03          	sar    $0x3,%rcx
  8003cd:	74 0c                	je     8003db <memset+0x45>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  8003cf:	fc                   	cld
  8003d0:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  8003d3:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  8003d7:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  8003db:	4d 85 c9             	test   %r9,%r9
  8003de:	75 45                	jne    800425 <memset+0x8f>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  8003e0:	4c 89 c0             	mov    %r8,%rax
  8003e3:	c3                   	ret
        while (n-- > 0) *ptr++ = c;
  8003e4:	48 85 d2             	test   %rdx,%rdx
  8003e7:	74 f7                	je     8003e0 <memset+0x4a>
  8003e9:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  8003ec:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  8003ef:	48 83 c0 01          	add    $0x1,%rax
  8003f3:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  8003f7:	48 39 c2             	cmp    %rax,%rdx
  8003fa:	75 f3                	jne    8003ef <memset+0x59>
  8003fc:	eb e2                	jmp    8003e0 <memset+0x4a>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  8003fe:	40 f6 c7 01          	test   $0x1,%dil
  800402:	74 06                	je     80040a <memset+0x74>
  800404:	88 07                	mov    %al,(%rdi)
  800406:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  80040a:	40 f6 c7 02          	test   $0x2,%dil
  80040e:	74 07                	je     800417 <memset+0x81>
  800410:	66 89 07             	mov    %ax,(%rdi)
  800413:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  800417:	40 f6 c7 04          	test   $0x4,%dil
  80041b:	74 a9                	je     8003c6 <memset+0x30>
  80041d:	89 07                	mov    %eax,(%rdi)
  80041f:	48 83 c7 04          	add    $0x4,%rdi
  800423:	eb a1                	jmp    8003c6 <memset+0x30>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  800425:	41 f6 c1 04          	test   $0x4,%r9b
  800429:	74 1b                	je     800446 <memset+0xb0>
  80042b:	89 07                	mov    %eax,(%rdi)
  80042d:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800431:	41 f6 c1 02          	test   $0x2,%r9b
  800435:	74 07                	je     80043e <memset+0xa8>
  800437:	66 89 07             	mov    %ax,(%rdi)
  80043a:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  80043e:	41 f6 c1 01          	test   $0x1,%r9b
  800442:	74 9c                	je     8003e0 <memset+0x4a>
  800444:	eb 06                	jmp    80044c <memset+0xb6>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  800446:	41 f6 c1 02          	test   $0x2,%r9b
  80044a:	75 eb                	jne    800437 <memset+0xa1>
        if (ni & 1) *ptr = k;
  80044c:	88 07                	mov    %al,(%rdi)
  80044e:	eb 90                	jmp    8003e0 <memset+0x4a>

0000000000800450 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  800450:	f3 0f 1e fa          	endbr64
  800454:	48 89 f8             	mov    %rdi,%rax
  800457:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  80045a:	48 39 fe             	cmp    %rdi,%rsi
  80045d:	73 3b                	jae    80049a <memmove+0x4a>
  80045f:	48 8d 14 16          	lea    (%rsi,%rdx,1),%rdx
  800463:	48 39 d7             	cmp    %rdx,%rdi
  800466:	73 32                	jae    80049a <memmove+0x4a>
        s += n;
        d += n;
  800468:	48 8d 3c 0f          	lea    (%rdi,%rcx,1),%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  80046c:	48 89 d6             	mov    %rdx,%rsi
  80046f:	48 09 fe             	or     %rdi,%rsi
  800472:	48 09 ce             	or     %rcx,%rsi
  800475:	40 f6 c6 07          	test   $0x7,%sil
  800479:	75 12                	jne    80048d <memmove+0x3d>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  80047b:	48 83 ef 08          	sub    $0x8,%rdi
  80047f:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  800483:	48 c1 e9 03          	shr    $0x3,%rcx
  800487:	fd                   	std
  800488:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  80048b:	fc                   	cld
  80048c:	c3                   	ret
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  80048d:	48 83 ef 01          	sub    $0x1,%rdi
  800491:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  800495:	fd                   	std
  800496:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  800498:	eb f1                	jmp    80048b <memmove+0x3b>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  80049a:	48 89 f2             	mov    %rsi,%rdx
  80049d:	48 09 c2             	or     %rax,%rdx
  8004a0:	48 09 ca             	or     %rcx,%rdx
  8004a3:	f6 c2 07             	test   $0x7,%dl
  8004a6:	75 0c                	jne    8004b4 <memmove+0x64>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  8004a8:	48 c1 e9 03          	shr    $0x3,%rcx
  8004ac:	48 89 c7             	mov    %rax,%rdi
  8004af:	fc                   	cld
  8004b0:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  8004b3:	c3                   	ret
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  8004b4:	48 89 c7             	mov    %rax,%rdi
  8004b7:	fc                   	cld
  8004b8:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  8004ba:	c3                   	ret

00000000008004bb <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  8004bb:	f3 0f 1e fa          	endbr64
  8004bf:	55                   	push   %rbp
  8004c0:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  8004c3:	48 b8 50 04 80 00 00 	movabs $0x800450,%rax
  8004ca:	00 00 00 
  8004cd:	ff d0                	call   *%rax
}
  8004cf:	5d                   	pop    %rbp
  8004d0:	c3                   	ret

00000000008004d1 <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  8004d1:	f3 0f 1e fa          	endbr64
  8004d5:	55                   	push   %rbp
  8004d6:	48 89 e5             	mov    %rsp,%rbp
  8004d9:	41 57                	push   %r15
  8004db:	41 56                	push   %r14
  8004dd:	41 55                	push   %r13
  8004df:	41 54                	push   %r12
  8004e1:	53                   	push   %rbx
  8004e2:	48 83 ec 08          	sub    $0x8,%rsp
  8004e6:	49 89 fe             	mov    %rdi,%r14
  8004e9:	49 89 f7             	mov    %rsi,%r15
  8004ec:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  8004ef:	48 89 f7             	mov    %rsi,%rdi
  8004f2:	48 b8 f0 01 80 00 00 	movabs $0x8001f0,%rax
  8004f9:	00 00 00 
  8004fc:	ff d0                	call   *%rax
  8004fe:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  800501:	48 89 de             	mov    %rbx,%rsi
  800504:	4c 89 f7             	mov    %r14,%rdi
  800507:	48 b8 0f 02 80 00 00 	movabs $0x80020f,%rax
  80050e:	00 00 00 
  800511:	ff d0                	call   *%rax
  800513:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  800516:	48 39 c3             	cmp    %rax,%rbx
  800519:	74 36                	je     800551 <strlcat+0x80>
    if (srclen < maxlen - dstlen) {
  80051b:	48 89 d8             	mov    %rbx,%rax
  80051e:	4c 29 e8             	sub    %r13,%rax
  800521:	49 39 c4             	cmp    %rax,%r12
  800524:	73 31                	jae    800557 <strlcat+0x86>
        memcpy(dst + dstlen, src, srclen + 1);
  800526:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  80052b:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  80052f:	4c 89 fe             	mov    %r15,%rsi
  800532:	48 b8 bb 04 80 00 00 	movabs $0x8004bb,%rax
  800539:	00 00 00 
  80053c:	ff d0                	call   *%rax
    return dstlen + srclen;
  80053e:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  800542:	48 83 c4 08          	add    $0x8,%rsp
  800546:	5b                   	pop    %rbx
  800547:	41 5c                	pop    %r12
  800549:	41 5d                	pop    %r13
  80054b:	41 5e                	pop    %r14
  80054d:	41 5f                	pop    %r15
  80054f:	5d                   	pop    %rbp
  800550:	c3                   	ret
    if (dstlen == maxlen) return maxlen + srclen;
  800551:	49 8d 04 04          	lea    (%r12,%rax,1),%rax
  800555:	eb eb                	jmp    800542 <strlcat+0x71>
        memcpy(dst + dstlen, src, maxlen - 1);
  800557:	48 83 eb 01          	sub    $0x1,%rbx
  80055b:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  80055f:	48 89 da             	mov    %rbx,%rdx
  800562:	4c 89 fe             	mov    %r15,%rsi
  800565:	48 b8 bb 04 80 00 00 	movabs $0x8004bb,%rax
  80056c:	00 00 00 
  80056f:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  800571:	49 01 de             	add    %rbx,%r14
  800574:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  800579:	eb c3                	jmp    80053e <strlcat+0x6d>

000000000080057b <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  80057b:	f3 0f 1e fa          	endbr64
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  80057f:	48 85 d2             	test   %rdx,%rdx
  800582:	74 2d                	je     8005b1 <memcmp+0x36>
  800584:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  800589:	0f b6 0c 07          	movzbl (%rdi,%rax,1),%ecx
  80058d:	44 0f b6 04 06       	movzbl (%rsi,%rax,1),%r8d
  800592:	44 38 c1             	cmp    %r8b,%cl
  800595:	75 0f                	jne    8005a6 <memcmp+0x2b>
    while (n-- > 0) {
  800597:	48 83 c0 01          	add    $0x1,%rax
  80059b:	48 39 c2             	cmp    %rax,%rdx
  80059e:	75 e9                	jne    800589 <memcmp+0xe>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  8005a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8005a5:	c3                   	ret
            return (int)*s1 - (int)*s2;
  8005a6:	0f b6 c1             	movzbl %cl,%eax
  8005a9:	45 0f b6 c0          	movzbl %r8b,%r8d
  8005ad:	44 29 c0             	sub    %r8d,%eax
  8005b0:	c3                   	ret
    return 0;
  8005b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8005b6:	c3                   	ret

00000000008005b7 <memfind>:

void *
memfind(const void *src, int c, size_t n) {
  8005b7:	f3 0f 1e fa          	endbr64
    const void *end = (const char *)src + n;
  8005bb:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  8005bf:	48 39 c7             	cmp    %rax,%rdi
  8005c2:	73 0f                	jae    8005d3 <memfind+0x1c>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  8005c4:	40 38 37             	cmp    %sil,(%rdi)
  8005c7:	74 0e                	je     8005d7 <memfind+0x20>
    for (; src < end; src++) {
  8005c9:	48 83 c7 01          	add    $0x1,%rdi
  8005cd:	48 39 f8             	cmp    %rdi,%rax
  8005d0:	75 f2                	jne    8005c4 <memfind+0xd>
  8005d2:	c3                   	ret
  8005d3:	48 89 f8             	mov    %rdi,%rax
  8005d6:	c3                   	ret
  8005d7:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  8005da:	c3                   	ret

00000000008005db <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  8005db:	f3 0f 1e fa          	endbr64
  8005df:	49 89 f2             	mov    %rsi,%r10
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  8005e2:	0f b6 37             	movzbl (%rdi),%esi
  8005e5:	40 80 fe 20          	cmp    $0x20,%sil
  8005e9:	74 06                	je     8005f1 <strtol+0x16>
  8005eb:	40 80 fe 09          	cmp    $0x9,%sil
  8005ef:	75 13                	jne    800604 <strtol+0x29>
  8005f1:	48 83 c7 01          	add    $0x1,%rdi
  8005f5:	0f b6 37             	movzbl (%rdi),%esi
  8005f8:	40 80 fe 20          	cmp    $0x20,%sil
  8005fc:	74 f3                	je     8005f1 <strtol+0x16>
  8005fe:	40 80 fe 09          	cmp    $0x9,%sil
  800602:	74 ed                	je     8005f1 <strtol+0x16>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  800604:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  800607:	83 e0 fd             	and    $0xfffffffd,%eax
  80060a:	3c 01                	cmp    $0x1,%al
  80060c:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  800610:	f7 c2 ef ff ff ff    	test   $0xffffffef,%edx
  800616:	75 0f                	jne    800627 <strtol+0x4c>
  800618:	80 3f 30             	cmpb   $0x30,(%rdi)
  80061b:	74 14                	je     800631 <strtol+0x56>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  80061d:	85 d2                	test   %edx,%edx
  80061f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800624:	0f 44 d0             	cmove  %eax,%edx
    }

    /* Digits */
    long val = 0;
  800627:	b8 00 00 00 00       	mov    $0x0,%eax
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  80062c:	4c 63 ca             	movslq %edx,%r9
  80062f:	eb 36                	jmp    800667 <strtol+0x8c>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  800631:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  800635:	74 0f                	je     800646 <strtol+0x6b>
    } else if (!base && s[0] == '0') {
  800637:	85 d2                	test   %edx,%edx
  800639:	75 ec                	jne    800627 <strtol+0x4c>
        s++;
  80063b:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  80063f:	ba 08 00 00 00       	mov    $0x8,%edx
        s++;
  800644:	eb e1                	jmp    800627 <strtol+0x4c>
        s += 2;
  800646:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  80064a:	ba 10 00 00 00       	mov    $0x10,%edx
        s += 2;
  80064f:	eb d6                	jmp    800627 <strtol+0x4c>
            dig -= '0';
  800651:	83 e9 30             	sub    $0x30,%ecx
        if (dig >= base) break;
  800654:	44 0f b6 c1          	movzbl %cl,%r8d
  800658:	41 39 d0             	cmp    %edx,%r8d
  80065b:	7d 21                	jge    80067e <strtol+0xa3>
        val = val * base + dig;
  80065d:	49 0f af c1          	imul   %r9,%rax
  800661:	0f b6 c9             	movzbl %cl,%ecx
  800664:	48 01 c8             	add    %rcx,%rax
        uint8_t dig = *s++;
  800667:	48 83 c7 01          	add    $0x1,%rdi
  80066b:	0f b6 4f ff          	movzbl -0x1(%rdi),%ecx
        if (dig - '0' < 10)
  80066f:	80 f9 39             	cmp    $0x39,%cl
  800672:	76 dd                	jbe    800651 <strtol+0x76>
        else if (dig - 'a' < 27)
  800674:	80 f9 7b             	cmp    $0x7b,%cl
  800677:	77 05                	ja     80067e <strtol+0xa3>
            dig -= 'a' - 10;
  800679:	83 e9 57             	sub    $0x57,%ecx
  80067c:	eb d6                	jmp    800654 <strtol+0x79>
    }

    if (endptr) *endptr = (char *)s;
  80067e:	4d 85 d2             	test   %r10,%r10
  800681:	74 03                	je     800686 <strtol+0xab>
  800683:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  800686:	48 89 c2             	mov    %rax,%rdx
  800689:	48 f7 da             	neg    %rdx
  80068c:	40 80 fe 2d          	cmp    $0x2d,%sil
  800690:	48 0f 44 c2          	cmove  %rdx,%rax
}
  800694:	c3                   	ret

0000000000800695 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  800695:	f3 0f 1e fa          	endbr64
  800699:	55                   	push   %rbp
  80069a:	48 89 e5             	mov    %rsp,%rbp
  80069d:	53                   	push   %rbx
  80069e:	48 89 fa             	mov    %rdi,%rdx
  8006a1:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8006a4:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8006a9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006ae:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8006b3:	be 00 00 00 00       	mov    $0x0,%esi
  8006b8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8006be:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  8006c0:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8006c4:	c9                   	leave
  8006c5:	c3                   	ret

00000000008006c6 <sys_cgetc>:

int
sys_cgetc(void) {
  8006c6:	f3 0f 1e fa          	endbr64
  8006ca:	55                   	push   %rbp
  8006cb:	48 89 e5             	mov    %rsp,%rbp
  8006ce:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8006cf:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8006d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d9:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8006de:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006e3:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8006e8:	be 00 00 00 00       	mov    $0x0,%esi
  8006ed:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8006f3:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  8006f5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8006f9:	c9                   	leave
  8006fa:	c3                   	ret

00000000008006fb <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  8006fb:	f3 0f 1e fa          	endbr64
  8006ff:	55                   	push   %rbp
  800700:	48 89 e5             	mov    %rsp,%rbp
  800703:	53                   	push   %rbx
  800704:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  800708:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80070b:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800710:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800715:	bb 00 00 00 00       	mov    $0x0,%ebx
  80071a:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80071f:	be 00 00 00 00       	mov    $0x0,%esi
  800724:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80072a:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80072c:	48 85 c0             	test   %rax,%rax
  80072f:	7f 06                	jg     800737 <sys_env_destroy+0x3c>
}
  800731:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800735:	c9                   	leave
  800736:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800737:	49 89 c0             	mov    %rax,%r8
  80073a:	b9 03 00 00 00       	mov    $0x3,%ecx
  80073f:	48 ba 60 32 80 00 00 	movabs $0x803260,%rdx
  800746:	00 00 00 
  800749:	be 26 00 00 00       	mov    $0x26,%esi
  80074e:	48 bf 0f 30 80 00 00 	movabs $0x80300f,%rdi
  800755:	00 00 00 
  800758:	b8 00 00 00 00       	mov    $0x0,%eax
  80075d:	49 b9 65 21 80 00 00 	movabs $0x802165,%r9
  800764:	00 00 00 
  800767:	41 ff d1             	call   *%r9

000000000080076a <sys_getenvid>:

envid_t
sys_getenvid(void) {
  80076a:	f3 0f 1e fa          	endbr64
  80076e:	55                   	push   %rbp
  80076f:	48 89 e5             	mov    %rsp,%rbp
  800772:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800773:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800778:	ba 00 00 00 00       	mov    $0x0,%edx
  80077d:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800782:	bb 00 00 00 00       	mov    $0x0,%ebx
  800787:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80078c:	be 00 00 00 00       	mov    $0x0,%esi
  800791:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800797:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  800799:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80079d:	c9                   	leave
  80079e:	c3                   	ret

000000000080079f <sys_yield>:

void
sys_yield(void) {
  80079f:	f3 0f 1e fa          	endbr64
  8007a3:	55                   	push   %rbp
  8007a4:	48 89 e5             	mov    %rsp,%rbp
  8007a7:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8007a8:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8007ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b2:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8007b7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007bc:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8007c1:	be 00 00 00 00       	mov    $0x0,%esi
  8007c6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8007cc:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  8007ce:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8007d2:	c9                   	leave
  8007d3:	c3                   	ret

00000000008007d4 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  8007d4:	f3 0f 1e fa          	endbr64
  8007d8:	55                   	push   %rbp
  8007d9:	48 89 e5             	mov    %rsp,%rbp
  8007dc:	53                   	push   %rbx
  8007dd:	48 89 fa             	mov    %rdi,%rdx
  8007e0:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8007e3:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8007e8:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  8007ef:	00 00 00 
  8007f2:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8007f7:	be 00 00 00 00       	mov    $0x0,%esi
  8007fc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800802:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  800804:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800808:	c9                   	leave
  800809:	c3                   	ret

000000000080080a <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  80080a:	f3 0f 1e fa          	endbr64
  80080e:	55                   	push   %rbp
  80080f:	48 89 e5             	mov    %rsp,%rbp
  800812:	53                   	push   %rbx
  800813:	49 89 f8             	mov    %rdi,%r8
  800816:	48 89 d3             	mov    %rdx,%rbx
  800819:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  80081c:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800821:	4c 89 c2             	mov    %r8,%rdx
  800824:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800827:	be 00 00 00 00       	mov    $0x0,%esi
  80082c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800832:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  800834:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800838:	c9                   	leave
  800839:	c3                   	ret

000000000080083a <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  80083a:	f3 0f 1e fa          	endbr64
  80083e:	55                   	push   %rbp
  80083f:	48 89 e5             	mov    %rsp,%rbp
  800842:	53                   	push   %rbx
  800843:	48 83 ec 08          	sub    $0x8,%rsp
  800847:	89 f8                	mov    %edi,%eax
  800849:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  80084c:	48 63 f9             	movslq %ecx,%rdi
  80084f:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800852:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800857:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80085a:	be 00 00 00 00       	mov    $0x0,%esi
  80085f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800865:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800867:	48 85 c0             	test   %rax,%rax
  80086a:	7f 06                	jg     800872 <sys_alloc_region+0x38>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  80086c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800870:	c9                   	leave
  800871:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800872:	49 89 c0             	mov    %rax,%r8
  800875:	b9 04 00 00 00       	mov    $0x4,%ecx
  80087a:	48 ba 60 32 80 00 00 	movabs $0x803260,%rdx
  800881:	00 00 00 
  800884:	be 26 00 00 00       	mov    $0x26,%esi
  800889:	48 bf 0f 30 80 00 00 	movabs $0x80300f,%rdi
  800890:	00 00 00 
  800893:	b8 00 00 00 00       	mov    $0x0,%eax
  800898:	49 b9 65 21 80 00 00 	movabs $0x802165,%r9
  80089f:	00 00 00 
  8008a2:	41 ff d1             	call   *%r9

00000000008008a5 <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  8008a5:	f3 0f 1e fa          	endbr64
  8008a9:	55                   	push   %rbp
  8008aa:	48 89 e5             	mov    %rsp,%rbp
  8008ad:	53                   	push   %rbx
  8008ae:	48 83 ec 08          	sub    $0x8,%rsp
  8008b2:	89 f8                	mov    %edi,%eax
  8008b4:	49 89 f2             	mov    %rsi,%r10
  8008b7:	48 89 cf             	mov    %rcx,%rdi
  8008ba:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  8008bd:	48 63 da             	movslq %edx,%rbx
  8008c0:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8008c3:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8008c8:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8008cb:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  8008ce:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8008d0:	48 85 c0             	test   %rax,%rax
  8008d3:	7f 06                	jg     8008db <sys_map_region+0x36>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  8008d5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8008d9:	c9                   	leave
  8008da:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8008db:	49 89 c0             	mov    %rax,%r8
  8008de:	b9 05 00 00 00       	mov    $0x5,%ecx
  8008e3:	48 ba 60 32 80 00 00 	movabs $0x803260,%rdx
  8008ea:	00 00 00 
  8008ed:	be 26 00 00 00       	mov    $0x26,%esi
  8008f2:	48 bf 0f 30 80 00 00 	movabs $0x80300f,%rdi
  8008f9:	00 00 00 
  8008fc:	b8 00 00 00 00       	mov    $0x0,%eax
  800901:	49 b9 65 21 80 00 00 	movabs $0x802165,%r9
  800908:	00 00 00 
  80090b:	41 ff d1             	call   *%r9

000000000080090e <sys_map_physical_region>:

int
sys_map_physical_region(uintptr_t pa, envid_t dstenv, void *dstva, size_t size, int perm) {
  80090e:	f3 0f 1e fa          	endbr64
  800912:	55                   	push   %rbp
  800913:	48 89 e5             	mov    %rsp,%rbp
  800916:	53                   	push   %rbx
  800917:	48 83 ec 08          	sub    $0x8,%rsp
  80091b:	49 89 f9             	mov    %rdi,%r9
  80091e:	89 f0                	mov    %esi,%eax
  800920:	48 89 d3             	mov    %rdx,%rbx
  800923:	48 89 cf             	mov    %rcx,%rdi
    int res = syscall(SYS_map_physical_region, 1, pa, dstenv, (uintptr_t)dstva, size, perm, 0);
  800926:	49 63 f0             	movslq %r8d,%rsi
  800929:	48 63 c8             	movslq %eax,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80092c:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800931:	4c 89 ca             	mov    %r9,%rdx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800934:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80093a:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80093c:	48 85 c0             	test   %rax,%rax
  80093f:	7f 06                	jg     800947 <sys_map_physical_region+0x39>
#ifdef SANITIZE_USER_SHADOW_BASE
    platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  800941:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800945:	c9                   	leave
  800946:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800947:	49 89 c0             	mov    %rax,%r8
  80094a:	b9 06 00 00 00       	mov    $0x6,%ecx
  80094f:	48 ba 60 32 80 00 00 	movabs $0x803260,%rdx
  800956:	00 00 00 
  800959:	be 26 00 00 00       	mov    $0x26,%esi
  80095e:	48 bf 0f 30 80 00 00 	movabs $0x80300f,%rdi
  800965:	00 00 00 
  800968:	b8 00 00 00 00       	mov    $0x0,%eax
  80096d:	49 b9 65 21 80 00 00 	movabs $0x802165,%r9
  800974:	00 00 00 
  800977:	41 ff d1             	call   *%r9

000000000080097a <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  80097a:	f3 0f 1e fa          	endbr64
  80097e:	55                   	push   %rbp
  80097f:	48 89 e5             	mov    %rsp,%rbp
  800982:	53                   	push   %rbx
  800983:	48 83 ec 08          	sub    $0x8,%rsp
  800987:	48 89 f1             	mov    %rsi,%rcx
  80098a:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  80098d:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800990:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800995:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80099a:	be 00 00 00 00       	mov    $0x0,%esi
  80099f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8009a5:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8009a7:	48 85 c0             	test   %rax,%rax
  8009aa:	7f 06                	jg     8009b2 <sys_unmap_region+0x38>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  8009ac:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8009b0:	c9                   	leave
  8009b1:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8009b2:	49 89 c0             	mov    %rax,%r8
  8009b5:	b9 07 00 00 00       	mov    $0x7,%ecx
  8009ba:	48 ba 60 32 80 00 00 	movabs $0x803260,%rdx
  8009c1:	00 00 00 
  8009c4:	be 26 00 00 00       	mov    $0x26,%esi
  8009c9:	48 bf 0f 30 80 00 00 	movabs $0x80300f,%rdi
  8009d0:	00 00 00 
  8009d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8009d8:	49 b9 65 21 80 00 00 	movabs $0x802165,%r9
  8009df:	00 00 00 
  8009e2:	41 ff d1             	call   *%r9

00000000008009e5 <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  8009e5:	f3 0f 1e fa          	endbr64
  8009e9:	55                   	push   %rbp
  8009ea:	48 89 e5             	mov    %rsp,%rbp
  8009ed:	53                   	push   %rbx
  8009ee:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  8009f2:	48 63 ce             	movslq %esi,%rcx
  8009f5:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8009f8:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8009fd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a02:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800a07:	be 00 00 00 00       	mov    $0x0,%esi
  800a0c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800a12:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800a14:	48 85 c0             	test   %rax,%rax
  800a17:	7f 06                	jg     800a1f <sys_env_set_status+0x3a>
}
  800a19:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800a1d:	c9                   	leave
  800a1e:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800a1f:	49 89 c0             	mov    %rax,%r8
  800a22:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800a27:	48 ba 60 32 80 00 00 	movabs $0x803260,%rdx
  800a2e:	00 00 00 
  800a31:	be 26 00 00 00       	mov    $0x26,%esi
  800a36:	48 bf 0f 30 80 00 00 	movabs $0x80300f,%rdi
  800a3d:	00 00 00 
  800a40:	b8 00 00 00 00       	mov    $0x0,%eax
  800a45:	49 b9 65 21 80 00 00 	movabs $0x802165,%r9
  800a4c:	00 00 00 
  800a4f:	41 ff d1             	call   *%r9

0000000000800a52 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  800a52:	f3 0f 1e fa          	endbr64
  800a56:	55                   	push   %rbp
  800a57:	48 89 e5             	mov    %rsp,%rbp
  800a5a:	53                   	push   %rbx
  800a5b:	48 83 ec 08          	sub    $0x8,%rsp
  800a5f:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  800a62:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800a65:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800a6a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a6f:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800a74:	be 00 00 00 00       	mov    $0x0,%esi
  800a79:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800a7f:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800a81:	48 85 c0             	test   %rax,%rax
  800a84:	7f 06                	jg     800a8c <sys_env_set_trapframe+0x3a>
}
  800a86:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800a8a:	c9                   	leave
  800a8b:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800a8c:	49 89 c0             	mov    %rax,%r8
  800a8f:	b9 0b 00 00 00       	mov    $0xb,%ecx
  800a94:	48 ba 60 32 80 00 00 	movabs $0x803260,%rdx
  800a9b:	00 00 00 
  800a9e:	be 26 00 00 00       	mov    $0x26,%esi
  800aa3:	48 bf 0f 30 80 00 00 	movabs $0x80300f,%rdi
  800aaa:	00 00 00 
  800aad:	b8 00 00 00 00       	mov    $0x0,%eax
  800ab2:	49 b9 65 21 80 00 00 	movabs $0x802165,%r9
  800ab9:	00 00 00 
  800abc:	41 ff d1             	call   *%r9

0000000000800abf <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  800abf:	f3 0f 1e fa          	endbr64
  800ac3:	55                   	push   %rbp
  800ac4:	48 89 e5             	mov    %rsp,%rbp
  800ac7:	53                   	push   %rbx
  800ac8:	48 83 ec 08          	sub    $0x8,%rsp
  800acc:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  800acf:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800ad2:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800ad7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800adc:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800ae1:	be 00 00 00 00       	mov    $0x0,%esi
  800ae6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800aec:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800aee:	48 85 c0             	test   %rax,%rax
  800af1:	7f 06                	jg     800af9 <sys_env_set_pgfault_upcall+0x3a>
}
  800af3:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800af7:	c9                   	leave
  800af8:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800af9:	49 89 c0             	mov    %rax,%r8
  800afc:	b9 0c 00 00 00       	mov    $0xc,%ecx
  800b01:	48 ba 60 32 80 00 00 	movabs $0x803260,%rdx
  800b08:	00 00 00 
  800b0b:	be 26 00 00 00       	mov    $0x26,%esi
  800b10:	48 bf 0f 30 80 00 00 	movabs $0x80300f,%rdi
  800b17:	00 00 00 
  800b1a:	b8 00 00 00 00       	mov    $0x0,%eax
  800b1f:	49 b9 65 21 80 00 00 	movabs $0x802165,%r9
  800b26:	00 00 00 
  800b29:	41 ff d1             	call   *%r9

0000000000800b2c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  800b2c:	f3 0f 1e fa          	endbr64
  800b30:	55                   	push   %rbp
  800b31:	48 89 e5             	mov    %rsp,%rbp
  800b34:	53                   	push   %rbx
  800b35:	89 f8                	mov    %edi,%eax
  800b37:	49 89 f1             	mov    %rsi,%r9
  800b3a:	48 89 d3             	mov    %rdx,%rbx
  800b3d:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  800b40:	49 63 f0             	movslq %r8d,%rsi
  800b43:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  800b46:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800b4b:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800b4e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800b54:	cd 30                	int    $0x30
}
  800b56:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800b5a:	c9                   	leave
  800b5b:	c3                   	ret

0000000000800b5c <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  800b5c:	f3 0f 1e fa          	endbr64
  800b60:	55                   	push   %rbp
  800b61:	48 89 e5             	mov    %rsp,%rbp
  800b64:	53                   	push   %rbx
  800b65:	48 83 ec 08          	sub    $0x8,%rsp
  800b69:	48 89 fa             	mov    %rdi,%rdx
  800b6c:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  800b6f:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800b74:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b79:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800b7e:	be 00 00 00 00       	mov    $0x0,%esi
  800b83:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800b89:	cd 30                	int    $0x30
    if (check && ret > 0) {
  800b8b:	48 85 c0             	test   %rax,%rax
  800b8e:	7f 06                	jg     800b96 <sys_ipc_recv+0x3a>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  800b90:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800b94:	c9                   	leave
  800b95:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  800b96:	49 89 c0             	mov    %rax,%r8
  800b99:	b9 0f 00 00 00       	mov    $0xf,%ecx
  800b9e:	48 ba 60 32 80 00 00 	movabs $0x803260,%rdx
  800ba5:	00 00 00 
  800ba8:	be 26 00 00 00       	mov    $0x26,%esi
  800bad:	48 bf 0f 30 80 00 00 	movabs $0x80300f,%rdi
  800bb4:	00 00 00 
  800bb7:	b8 00 00 00 00       	mov    $0x0,%eax
  800bbc:	49 b9 65 21 80 00 00 	movabs $0x802165,%r9
  800bc3:	00 00 00 
  800bc6:	41 ff d1             	call   *%r9

0000000000800bc9 <sys_gettime>:

int
sys_gettime(void) {
  800bc9:	f3 0f 1e fa          	endbr64
  800bcd:	55                   	push   %rbp
  800bce:	48 89 e5             	mov    %rsp,%rbp
  800bd1:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  800bd2:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  800bd7:	ba 00 00 00 00       	mov    $0x0,%edx
  800bdc:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  800be1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800be6:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  800beb:	be 00 00 00 00       	mov    $0x0,%esi
  800bf0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  800bf6:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  800bf8:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800bfc:	c9                   	leave
  800bfd:	c3                   	ret

0000000000800bfe <fd2num>:


/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
  800bfe:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  800c02:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  800c09:	ff ff ff 
  800c0c:	48 01 f8             	add    %rdi,%rax
  800c0f:	48 c1 e8 0c          	shr    $0xc,%rax
}
  800c13:	c3                   	ret

0000000000800c14 <fd2data>:

char *
fd2data(struct Fd *fd) {
  800c14:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  800c18:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  800c1f:	ff ff ff 
  800c22:	48 01 f8             	add    %rdi,%rax
  800c25:	48 c1 e8 0c          	shr    $0xc,%rax
    return INDEX2DATA(fd2num(fd));
  800c29:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  800c2f:	48 c1 e0 0c          	shl    $0xc,%rax
}
  800c33:	c3                   	ret

0000000000800c34 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  800c34:	f3 0f 1e fa          	endbr64
  800c38:	55                   	push   %rbp
  800c39:	48 89 e5             	mov    %rsp,%rbp
  800c3c:	41 57                	push   %r15
  800c3e:	41 56                	push   %r14
  800c40:	41 55                	push   %r13
  800c42:	41 54                	push   %r12
  800c44:	53                   	push   %rbx
  800c45:	48 83 ec 08          	sub    $0x8,%rsp
  800c49:	49 89 ff             	mov    %rdi,%r15
  800c4c:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  800c51:	49 bd 93 1d 80 00 00 	movabs $0x801d93,%r13
  800c58:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  800c5b:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        struct Fd *fd = INDEX2FD(i);
  800c61:	49 89 dc             	mov    %rbx,%r12
        if (!(get_prot(fd) & PROT_R)) {
  800c64:	48 89 df             	mov    %rbx,%rdi
  800c67:	41 ff d5             	call   *%r13
  800c6a:	83 e0 04             	and    $0x4,%eax
  800c6d:	74 17                	je     800c86 <fd_alloc+0x52>
    for (int i = 0; i < MAXFD; i++) {
  800c6f:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  800c76:	4c 39 f3             	cmp    %r14,%rbx
  800c79:	75 e6                	jne    800c61 <fd_alloc+0x2d>
  800c7b:	41 bc 00 00 00 00    	mov    $0x0,%r12d
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
    return -E_MAX_OPEN;
  800c81:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
            *fd_store = fd;
  800c86:	4d 89 27             	mov    %r12,(%r15)
}
  800c89:	48 83 c4 08          	add    $0x8,%rsp
  800c8d:	5b                   	pop    %rbx
  800c8e:	41 5c                	pop    %r12
  800c90:	41 5d                	pop    %r13
  800c92:	41 5e                	pop    %r14
  800c94:	41 5f                	pop    %r15
  800c96:	5d                   	pop    %rbp
  800c97:	c3                   	ret

0000000000800c98 <fd_lookup>:
 *
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
  800c98:	f3 0f 1e fa          	endbr64
    if (fdnum < 0 || fdnum >= MAXFD) {
  800c9c:	83 ff 1f             	cmp    $0x1f,%edi
  800c9f:	77 39                	ja     800cda <fd_lookup+0x42>
fd_lookup(int fdnum, struct Fd **fd_store) {
  800ca1:	55                   	push   %rbp
  800ca2:	48 89 e5             	mov    %rsp,%rbp
  800ca5:	41 54                	push   %r12
  800ca7:	53                   	push   %rbx
  800ca8:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  800cab:	48 63 df             	movslq %edi,%rbx
  800cae:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  800cb5:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  800cb9:	48 89 df             	mov    %rbx,%rdi
  800cbc:	48 b8 93 1d 80 00 00 	movabs $0x801d93,%rax
  800cc3:	00 00 00 
  800cc6:	ff d0                	call   *%rax
  800cc8:	a8 04                	test   $0x4,%al
  800cca:	74 14                	je     800ce0 <fd_lookup+0x48>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  800ccc:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  800cd0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cd5:	5b                   	pop    %rbx
  800cd6:	41 5c                	pop    %r12
  800cd8:	5d                   	pop    %rbp
  800cd9:	c3                   	ret
        return -E_INVAL;
  800cda:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800cdf:	c3                   	ret
        return -E_INVAL;
  800ce0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ce5:	eb ee                	jmp    800cd5 <fd_lookup+0x3d>

0000000000800ce7 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  800ce7:	f3 0f 1e fa          	endbr64
  800ceb:	55                   	push   %rbp
  800cec:	48 89 e5             	mov    %rsp,%rbp
  800cef:	41 54                	push   %r12
  800cf1:	53                   	push   %rbx
  800cf2:	49 89 f4             	mov    %rsi,%r12
    for (size_t i = 0; devtab[i]; i++) {
  800cf5:	48 b8 40 33 80 00 00 	movabs $0x803340,%rax
  800cfc:	00 00 00 
  800cff:	48 bb 20 40 80 00 00 	movabs $0x804020,%rbx
  800d06:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  800d09:	39 3b                	cmp    %edi,(%rbx)
  800d0b:	74 47                	je     800d54 <dev_lookup+0x6d>
    for (size_t i = 0; devtab[i]; i++) {
  800d0d:	48 83 c0 08          	add    $0x8,%rax
  800d11:	48 8b 18             	mov    (%rax),%rbx
  800d14:	48 85 db             	test   %rbx,%rbx
  800d17:	75 f0                	jne    800d09 <dev_lookup+0x22>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800d19:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  800d20:	00 00 00 
  800d23:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  800d29:	89 fa                	mov    %edi,%edx
  800d2b:	48 bf 80 32 80 00 00 	movabs $0x803280,%rdi
  800d32:	00 00 00 
  800d35:	b8 00 00 00 00       	mov    $0x0,%eax
  800d3a:	48 b9 c1 22 80 00 00 	movabs $0x8022c1,%rcx
  800d41:	00 00 00 
  800d44:	ff d1                	call   *%rcx
    *dev = 0;
    return -E_INVAL;
  800d46:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
            *dev = devtab[i];
  800d4b:	49 89 1c 24          	mov    %rbx,(%r12)
}
  800d4f:	5b                   	pop    %rbx
  800d50:	41 5c                	pop    %r12
  800d52:	5d                   	pop    %rbp
  800d53:	c3                   	ret
            return 0;
  800d54:	b8 00 00 00 00       	mov    $0x0,%eax
  800d59:	eb f0                	jmp    800d4b <dev_lookup+0x64>

0000000000800d5b <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  800d5b:	f3 0f 1e fa          	endbr64
  800d5f:	55                   	push   %rbp
  800d60:	48 89 e5             	mov    %rsp,%rbp
  800d63:	41 55                	push   %r13
  800d65:	41 54                	push   %r12
  800d67:	53                   	push   %rbx
  800d68:	48 83 ec 18          	sub    $0x18,%rsp
  800d6c:	48 89 fb             	mov    %rdi,%rbx
  800d6f:	41 89 f4             	mov    %esi,%r12d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  800d72:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  800d79:	ff ff ff 
  800d7c:	48 01 df             	add    %rbx,%rdi
  800d7f:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  800d83:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800d87:	48 b8 98 0c 80 00 00 	movabs $0x800c98,%rax
  800d8e:	00 00 00 
  800d91:	ff d0                	call   *%rax
  800d93:	41 89 c5             	mov    %eax,%r13d
  800d96:	85 c0                	test   %eax,%eax
  800d98:	78 06                	js     800da0 <fd_close+0x45>
  800d9a:	48 39 5d d8          	cmp    %rbx,-0x28(%rbp)
  800d9e:	74 1a                	je     800dba <fd_close+0x5f>
        return (must_exist ? res : 0);
  800da0:	45 84 e4             	test   %r12b,%r12b
  800da3:	b8 00 00 00 00       	mov    $0x0,%eax
  800da8:	44 0f 44 e8          	cmove  %eax,%r13d
}
  800dac:	44 89 e8             	mov    %r13d,%eax
  800daf:	48 83 c4 18          	add    $0x18,%rsp
  800db3:	5b                   	pop    %rbx
  800db4:	41 5c                	pop    %r12
  800db6:	41 5d                	pop    %r13
  800db8:	5d                   	pop    %rbp
  800db9:	c3                   	ret
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800dba:	8b 3b                	mov    (%rbx),%edi
  800dbc:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800dc0:	48 b8 e7 0c 80 00 00 	movabs $0x800ce7,%rax
  800dc7:	00 00 00 
  800dca:	ff d0                	call   *%rax
  800dcc:	41 89 c5             	mov    %eax,%r13d
  800dcf:	85 c0                	test   %eax,%eax
  800dd1:	78 1b                	js     800dee <fd_close+0x93>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  800dd3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800dd7:	48 8b 40 20          	mov    0x20(%rax),%rax
  800ddb:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  800de1:	48 85 c0             	test   %rax,%rax
  800de4:	74 08                	je     800dee <fd_close+0x93>
  800de6:	48 89 df             	mov    %rbx,%rdi
  800de9:	ff d0                	call   *%rax
  800deb:	41 89 c5             	mov    %eax,%r13d
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  800dee:	ba 00 10 00 00       	mov    $0x1000,%edx
  800df3:	48 89 de             	mov    %rbx,%rsi
  800df6:	bf 00 00 00 00       	mov    $0x0,%edi
  800dfb:	48 b8 7a 09 80 00 00 	movabs $0x80097a,%rax
  800e02:	00 00 00 
  800e05:	ff d0                	call   *%rax
    return res;
  800e07:	eb a3                	jmp    800dac <fd_close+0x51>

0000000000800e09 <close>:

int
close(int fdnum) {
  800e09:	f3 0f 1e fa          	endbr64
  800e0d:	55                   	push   %rbp
  800e0e:	48 89 e5             	mov    %rsp,%rbp
  800e11:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  800e15:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  800e19:	48 b8 98 0c 80 00 00 	movabs $0x800c98,%rax
  800e20:	00 00 00 
  800e23:	ff d0                	call   *%rax
    if (res < 0) return res;
  800e25:	85 c0                	test   %eax,%eax
  800e27:	78 15                	js     800e3e <close+0x35>

    return fd_close(fd, 1);
  800e29:	be 01 00 00 00       	mov    $0x1,%esi
  800e2e:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  800e32:	48 b8 5b 0d 80 00 00 	movabs $0x800d5b,%rax
  800e39:	00 00 00 
  800e3c:	ff d0                	call   *%rax
}
  800e3e:	c9                   	leave
  800e3f:	c3                   	ret

0000000000800e40 <close_all>:

void
close_all(void) {
  800e40:	f3 0f 1e fa          	endbr64
  800e44:	55                   	push   %rbp
  800e45:	48 89 e5             	mov    %rsp,%rbp
  800e48:	41 54                	push   %r12
  800e4a:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  800e4b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e50:	49 bc 09 0e 80 00 00 	movabs $0x800e09,%r12
  800e57:	00 00 00 
  800e5a:	89 df                	mov    %ebx,%edi
  800e5c:	41 ff d4             	call   *%r12
  800e5f:	83 c3 01             	add    $0x1,%ebx
  800e62:	83 fb 20             	cmp    $0x20,%ebx
  800e65:	75 f3                	jne    800e5a <close_all+0x1a>
}
  800e67:	5b                   	pop    %rbx
  800e68:	41 5c                	pop    %r12
  800e6a:	5d                   	pop    %rbp
  800e6b:	c3                   	ret

0000000000800e6c <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  800e6c:	f3 0f 1e fa          	endbr64
  800e70:	55                   	push   %rbp
  800e71:	48 89 e5             	mov    %rsp,%rbp
  800e74:	41 57                	push   %r15
  800e76:	41 56                	push   %r14
  800e78:	41 55                	push   %r13
  800e7a:	41 54                	push   %r12
  800e7c:	53                   	push   %rbx
  800e7d:	48 83 ec 18          	sub    $0x18,%rsp
  800e81:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  800e84:	48 8d 75 c8          	lea    -0x38(%rbp),%rsi
  800e88:	48 b8 98 0c 80 00 00 	movabs $0x800c98,%rax
  800e8f:	00 00 00 
  800e92:	ff d0                	call   *%rax
  800e94:	89 c3                	mov    %eax,%ebx
  800e96:	85 c0                	test   %eax,%eax
  800e98:	0f 88 b8 00 00 00    	js     800f56 <dup+0xea>
    close(newfdnum);
  800e9e:	44 89 e7             	mov    %r12d,%edi
  800ea1:	48 b8 09 0e 80 00 00 	movabs $0x800e09,%rax
  800ea8:	00 00 00 
  800eab:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  800ead:	4d 63 ec             	movslq %r12d,%r13
  800eb0:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  800eb7:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  800ebb:	4c 8b 7d c8          	mov    -0x38(%rbp),%r15
  800ebf:	4c 89 ff             	mov    %r15,%rdi
  800ec2:	49 be 14 0c 80 00 00 	movabs $0x800c14,%r14
  800ec9:	00 00 00 
  800ecc:	41 ff d6             	call   *%r14
  800ecf:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  800ed2:	4c 89 ef             	mov    %r13,%rdi
  800ed5:	41 ff d6             	call   *%r14
  800ed8:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  800edb:	48 89 df             	mov    %rbx,%rdi
  800ede:	48 b8 93 1d 80 00 00 	movabs $0x801d93,%rax
  800ee5:	00 00 00 
  800ee8:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  800eea:	a8 04                	test   $0x4,%al
  800eec:	74 2b                	je     800f19 <dup+0xad>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  800eee:	41 89 c1             	mov    %eax,%r9d
  800ef1:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  800ef7:	4c 89 f1             	mov    %r14,%rcx
  800efa:	ba 00 00 00 00       	mov    $0x0,%edx
  800eff:	48 89 de             	mov    %rbx,%rsi
  800f02:	bf 00 00 00 00       	mov    $0x0,%edi
  800f07:	48 b8 a5 08 80 00 00 	movabs $0x8008a5,%rax
  800f0e:	00 00 00 
  800f11:	ff d0                	call   *%rax
  800f13:	89 c3                	mov    %eax,%ebx
  800f15:	85 c0                	test   %eax,%eax
  800f17:	78 4e                	js     800f67 <dup+0xfb>
    }
    prot = get_prot(oldfd);
  800f19:	4c 89 ff             	mov    %r15,%rdi
  800f1c:	48 b8 93 1d 80 00 00 	movabs $0x801d93,%rax
  800f23:	00 00 00 
  800f26:	ff d0                	call   *%rax
  800f28:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  800f2b:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  800f31:	4c 89 e9             	mov    %r13,%rcx
  800f34:	ba 00 00 00 00       	mov    $0x0,%edx
  800f39:	4c 89 fe             	mov    %r15,%rsi
  800f3c:	bf 00 00 00 00       	mov    $0x0,%edi
  800f41:	48 b8 a5 08 80 00 00 	movabs $0x8008a5,%rax
  800f48:	00 00 00 
  800f4b:	ff d0                	call   *%rax
  800f4d:	89 c3                	mov    %eax,%ebx
  800f4f:	85 c0                	test   %eax,%eax
  800f51:	78 14                	js     800f67 <dup+0xfb>

    return newfdnum;
  800f53:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  800f56:	89 d8                	mov    %ebx,%eax
  800f58:	48 83 c4 18          	add    $0x18,%rsp
  800f5c:	5b                   	pop    %rbx
  800f5d:	41 5c                	pop    %r12
  800f5f:	41 5d                	pop    %r13
  800f61:	41 5e                	pop    %r14
  800f63:	41 5f                	pop    %r15
  800f65:	5d                   	pop    %rbp
  800f66:	c3                   	ret
    sys_unmap_region(0, newfd, PAGE_SIZE);
  800f67:	ba 00 10 00 00       	mov    $0x1000,%edx
  800f6c:	4c 89 ee             	mov    %r13,%rsi
  800f6f:	bf 00 00 00 00       	mov    $0x0,%edi
  800f74:	49 bc 7a 09 80 00 00 	movabs $0x80097a,%r12
  800f7b:	00 00 00 
  800f7e:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  800f81:	ba 00 10 00 00       	mov    $0x1000,%edx
  800f86:	4c 89 f6             	mov    %r14,%rsi
  800f89:	bf 00 00 00 00       	mov    $0x0,%edi
  800f8e:	41 ff d4             	call   *%r12
    return res;
  800f91:	eb c3                	jmp    800f56 <dup+0xea>

0000000000800f93 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  800f93:	f3 0f 1e fa          	endbr64
  800f97:	55                   	push   %rbp
  800f98:	48 89 e5             	mov    %rsp,%rbp
  800f9b:	41 56                	push   %r14
  800f9d:	41 55                	push   %r13
  800f9f:	41 54                	push   %r12
  800fa1:	53                   	push   %rbx
  800fa2:	48 83 ec 10          	sub    $0x10,%rsp
  800fa6:	89 fb                	mov    %edi,%ebx
  800fa8:	49 89 f4             	mov    %rsi,%r12
  800fab:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  800fae:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  800fb2:	48 b8 98 0c 80 00 00 	movabs $0x800c98,%rax
  800fb9:	00 00 00 
  800fbc:	ff d0                	call   *%rax
  800fbe:	85 c0                	test   %eax,%eax
  800fc0:	78 4c                	js     80100e <read+0x7b>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  800fc2:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  800fc6:	41 8b 3e             	mov    (%r14),%edi
  800fc9:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  800fcd:	48 b8 e7 0c 80 00 00 	movabs $0x800ce7,%rax
  800fd4:	00 00 00 
  800fd7:	ff d0                	call   *%rax
  800fd9:	85 c0                	test   %eax,%eax
  800fdb:	78 35                	js     801012 <read+0x7f>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800fdd:	41 8b 46 08          	mov    0x8(%r14),%eax
  800fe1:	83 e0 03             	and    $0x3,%eax
  800fe4:	83 f8 01             	cmp    $0x1,%eax
  800fe7:	74 2d                	je     801016 <read+0x83>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  800fe9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800fed:	48 8b 40 10          	mov    0x10(%rax),%rax
  800ff1:	48 85 c0             	test   %rax,%rax
  800ff4:	74 56                	je     80104c <read+0xb9>

    return (*dev->dev_read)(fd, buf, n);
  800ff6:	4c 89 ea             	mov    %r13,%rdx
  800ff9:	4c 89 e6             	mov    %r12,%rsi
  800ffc:	4c 89 f7             	mov    %r14,%rdi
  800fff:	ff d0                	call   *%rax
}
  801001:	48 83 c4 10          	add    $0x10,%rsp
  801005:	5b                   	pop    %rbx
  801006:	41 5c                	pop    %r12
  801008:	41 5d                	pop    %r13
  80100a:	41 5e                	pop    %r14
  80100c:	5d                   	pop    %rbp
  80100d:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  80100e:	48 98                	cltq
  801010:	eb ef                	jmp    801001 <read+0x6e>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801012:	48 98                	cltq
  801014:	eb eb                	jmp    801001 <read+0x6e>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801016:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  80101d:	00 00 00 
  801020:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801026:	89 da                	mov    %ebx,%edx
  801028:	48 bf 1d 30 80 00 00 	movabs $0x80301d,%rdi
  80102f:	00 00 00 
  801032:	b8 00 00 00 00       	mov    $0x0,%eax
  801037:	48 b9 c1 22 80 00 00 	movabs $0x8022c1,%rcx
  80103e:	00 00 00 
  801041:	ff d1                	call   *%rcx
        return -E_INVAL;
  801043:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  80104a:	eb b5                	jmp    801001 <read+0x6e>
    if (!dev->dev_read) return -E_NOT_SUPP;
  80104c:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801053:	eb ac                	jmp    801001 <read+0x6e>

0000000000801055 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801055:	f3 0f 1e fa          	endbr64
  801059:	55                   	push   %rbp
  80105a:	48 89 e5             	mov    %rsp,%rbp
  80105d:	41 57                	push   %r15
  80105f:	41 56                	push   %r14
  801061:	41 55                	push   %r13
  801063:	41 54                	push   %r12
  801065:	53                   	push   %rbx
  801066:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  80106a:	48 85 d2             	test   %rdx,%rdx
  80106d:	74 54                	je     8010c3 <readn+0x6e>
  80106f:	41 89 fd             	mov    %edi,%r13d
  801072:	49 89 f6             	mov    %rsi,%r14
  801075:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801078:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  80107d:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801082:	49 bf 93 0f 80 00 00 	movabs $0x800f93,%r15
  801089:	00 00 00 
  80108c:	4c 89 e2             	mov    %r12,%rdx
  80108f:	48 29 f2             	sub    %rsi,%rdx
  801092:	4c 01 f6             	add    %r14,%rsi
  801095:	44 89 ef             	mov    %r13d,%edi
  801098:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  80109b:	85 c0                	test   %eax,%eax
  80109d:	78 20                	js     8010bf <readn+0x6a>
    for (; inc && res < n; res += inc) {
  80109f:	01 c3                	add    %eax,%ebx
  8010a1:	85 c0                	test   %eax,%eax
  8010a3:	74 08                	je     8010ad <readn+0x58>
  8010a5:	48 63 f3             	movslq %ebx,%rsi
  8010a8:	4c 39 e6             	cmp    %r12,%rsi
  8010ab:	72 df                	jb     80108c <readn+0x37>
    }
    return res;
  8010ad:	48 63 c3             	movslq %ebx,%rax
}
  8010b0:	48 83 c4 08          	add    $0x8,%rsp
  8010b4:	5b                   	pop    %rbx
  8010b5:	41 5c                	pop    %r12
  8010b7:	41 5d                	pop    %r13
  8010b9:	41 5e                	pop    %r14
  8010bb:	41 5f                	pop    %r15
  8010bd:	5d                   	pop    %rbp
  8010be:	c3                   	ret
        if (inc < 0) return inc;
  8010bf:	48 98                	cltq
  8010c1:	eb ed                	jmp    8010b0 <readn+0x5b>
    int inc = 1, res = 0;
  8010c3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010c8:	eb e3                	jmp    8010ad <readn+0x58>

00000000008010ca <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  8010ca:	f3 0f 1e fa          	endbr64
  8010ce:	55                   	push   %rbp
  8010cf:	48 89 e5             	mov    %rsp,%rbp
  8010d2:	41 56                	push   %r14
  8010d4:	41 55                	push   %r13
  8010d6:	41 54                	push   %r12
  8010d8:	53                   	push   %rbx
  8010d9:	48 83 ec 10          	sub    $0x10,%rsp
  8010dd:	89 fb                	mov    %edi,%ebx
  8010df:	49 89 f4             	mov    %rsi,%r12
  8010e2:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8010e5:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8010e9:	48 b8 98 0c 80 00 00 	movabs $0x800c98,%rax
  8010f0:	00 00 00 
  8010f3:	ff d0                	call   *%rax
  8010f5:	85 c0                	test   %eax,%eax
  8010f7:	78 47                	js     801140 <write+0x76>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8010f9:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  8010fd:	41 8b 3e             	mov    (%r14),%edi
  801100:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801104:	48 b8 e7 0c 80 00 00 	movabs $0x800ce7,%rax
  80110b:	00 00 00 
  80110e:	ff d0                	call   *%rax
  801110:	85 c0                	test   %eax,%eax
  801112:	78 30                	js     801144 <write+0x7a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801114:	41 f6 46 08 03       	testb  $0x3,0x8(%r14)
  801119:	74 2d                	je     801148 <write+0x7e>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  80111b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80111f:	48 8b 40 18          	mov    0x18(%rax),%rax
  801123:	48 85 c0             	test   %rax,%rax
  801126:	74 56                	je     80117e <write+0xb4>

    return (*dev->dev_write)(fd, buf, n);
  801128:	4c 89 ea             	mov    %r13,%rdx
  80112b:	4c 89 e6             	mov    %r12,%rsi
  80112e:	4c 89 f7             	mov    %r14,%rdi
  801131:	ff d0                	call   *%rax
}
  801133:	48 83 c4 10          	add    $0x10,%rsp
  801137:	5b                   	pop    %rbx
  801138:	41 5c                	pop    %r12
  80113a:	41 5d                	pop    %r13
  80113c:	41 5e                	pop    %r14
  80113e:	5d                   	pop    %rbp
  80113f:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801140:	48 98                	cltq
  801142:	eb ef                	jmp    801133 <write+0x69>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801144:	48 98                	cltq
  801146:	eb eb                	jmp    801133 <write+0x69>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801148:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  80114f:	00 00 00 
  801152:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801158:	89 da                	mov    %ebx,%edx
  80115a:	48 bf 39 30 80 00 00 	movabs $0x803039,%rdi
  801161:	00 00 00 
  801164:	b8 00 00 00 00       	mov    $0x0,%eax
  801169:	48 b9 c1 22 80 00 00 	movabs $0x8022c1,%rcx
  801170:	00 00 00 
  801173:	ff d1                	call   *%rcx
        return -E_INVAL;
  801175:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  80117c:	eb b5                	jmp    801133 <write+0x69>
    if (!dev->dev_write) return -E_NOT_SUPP;
  80117e:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801185:	eb ac                	jmp    801133 <write+0x69>

0000000000801187 <seek>:

int
seek(int fdnum, off_t offset) {
  801187:	f3 0f 1e fa          	endbr64
  80118b:	55                   	push   %rbp
  80118c:	48 89 e5             	mov    %rsp,%rbp
  80118f:	53                   	push   %rbx
  801190:	48 83 ec 18          	sub    $0x18,%rsp
  801194:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801196:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  80119a:	48 b8 98 0c 80 00 00 	movabs $0x800c98,%rax
  8011a1:	00 00 00 
  8011a4:	ff d0                	call   *%rax
  8011a6:	85 c0                	test   %eax,%eax
  8011a8:	78 0c                	js     8011b6 <seek+0x2f>

    fd->fd_offset = offset;
  8011aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ae:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  8011b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011b6:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8011ba:	c9                   	leave
  8011bb:	c3                   	ret

00000000008011bc <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  8011bc:	f3 0f 1e fa          	endbr64
  8011c0:	55                   	push   %rbp
  8011c1:	48 89 e5             	mov    %rsp,%rbp
  8011c4:	41 55                	push   %r13
  8011c6:	41 54                	push   %r12
  8011c8:	53                   	push   %rbx
  8011c9:	48 83 ec 18          	sub    $0x18,%rsp
  8011cd:	89 fb                	mov    %edi,%ebx
  8011cf:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8011d2:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8011d6:	48 b8 98 0c 80 00 00 	movabs $0x800c98,%rax
  8011dd:	00 00 00 
  8011e0:	ff d0                	call   *%rax
  8011e2:	85 c0                	test   %eax,%eax
  8011e4:	78 38                	js     80121e <ftruncate+0x62>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8011e6:	4c 8b 6d d8          	mov    -0x28(%rbp),%r13
  8011ea:	41 8b 7d 00          	mov    0x0(%r13),%edi
  8011ee:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8011f2:	48 b8 e7 0c 80 00 00 	movabs $0x800ce7,%rax
  8011f9:	00 00 00 
  8011fc:	ff d0                	call   *%rax
  8011fe:	85 c0                	test   %eax,%eax
  801200:	78 1c                	js     80121e <ftruncate+0x62>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801202:	41 f6 45 08 03       	testb  $0x3,0x8(%r13)
  801207:	74 20                	je     801229 <ftruncate+0x6d>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801209:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80120d:	48 8b 40 30          	mov    0x30(%rax),%rax
  801211:	48 85 c0             	test   %rax,%rax
  801214:	74 47                	je     80125d <ftruncate+0xa1>

    return (*dev->dev_trunc)(fd, newsize);
  801216:	44 89 e6             	mov    %r12d,%esi
  801219:	4c 89 ef             	mov    %r13,%rdi
  80121c:	ff d0                	call   *%rax
}
  80121e:	48 83 c4 18          	add    $0x18,%rsp
  801222:	5b                   	pop    %rbx
  801223:	41 5c                	pop    %r12
  801225:	41 5d                	pop    %r13
  801227:	5d                   	pop    %rbp
  801228:	c3                   	ret
                thisenv->env_id, fdnum);
  801229:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801230:	00 00 00 
  801233:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801239:	89 da                	mov    %ebx,%edx
  80123b:	48 bf a0 32 80 00 00 	movabs $0x8032a0,%rdi
  801242:	00 00 00 
  801245:	b8 00 00 00 00       	mov    $0x0,%eax
  80124a:	48 b9 c1 22 80 00 00 	movabs $0x8022c1,%rcx
  801251:	00 00 00 
  801254:	ff d1                	call   *%rcx
        return -E_INVAL;
  801256:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80125b:	eb c1                	jmp    80121e <ftruncate+0x62>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  80125d:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801262:	eb ba                	jmp    80121e <ftruncate+0x62>

0000000000801264 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  801264:	f3 0f 1e fa          	endbr64
  801268:	55                   	push   %rbp
  801269:	48 89 e5             	mov    %rsp,%rbp
  80126c:	41 54                	push   %r12
  80126e:	53                   	push   %rbx
  80126f:	48 83 ec 10          	sub    $0x10,%rsp
  801273:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801276:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  80127a:	48 b8 98 0c 80 00 00 	movabs $0x800c98,%rax
  801281:	00 00 00 
  801284:	ff d0                	call   *%rax
  801286:	85 c0                	test   %eax,%eax
  801288:	78 4e                	js     8012d8 <fstat+0x74>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  80128a:	4c 8b 65 e8          	mov    -0x18(%rbp),%r12
  80128e:	41 8b 3c 24          	mov    (%r12),%edi
  801292:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801296:	48 b8 e7 0c 80 00 00 	movabs $0x800ce7,%rax
  80129d:	00 00 00 
  8012a0:	ff d0                	call   *%rax
  8012a2:	85 c0                	test   %eax,%eax
  8012a4:	78 32                	js     8012d8 <fstat+0x74>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  8012a6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012aa:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  8012af:	74 30                	je     8012e1 <fstat+0x7d>

    stat->st_name[0] = 0;
  8012b1:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  8012b4:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  8012bb:	00 00 00 
    stat->st_isdir = 0;
  8012be:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  8012c5:	00 00 00 
    stat->st_dev = dev;
  8012c8:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  8012cf:	48 89 de             	mov    %rbx,%rsi
  8012d2:	4c 89 e7             	mov    %r12,%rdi
  8012d5:	ff 50 28             	call   *0x28(%rax)
}
  8012d8:	48 83 c4 10          	add    $0x10,%rsp
  8012dc:	5b                   	pop    %rbx
  8012dd:	41 5c                	pop    %r12
  8012df:	5d                   	pop    %rbp
  8012e0:	c3                   	ret
    if (!dev->dev_stat) return -E_NOT_SUPP;
  8012e1:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  8012e6:	eb f0                	jmp    8012d8 <fstat+0x74>

00000000008012e8 <stat>:

int
stat(const char *path, struct Stat *stat) {
  8012e8:	f3 0f 1e fa          	endbr64
  8012ec:	55                   	push   %rbp
  8012ed:	48 89 e5             	mov    %rsp,%rbp
  8012f0:	41 54                	push   %r12
  8012f2:	53                   	push   %rbx
  8012f3:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  8012f6:	be 00 00 00 00       	mov    $0x0,%esi
  8012fb:	48 b8 c9 15 80 00 00 	movabs $0x8015c9,%rax
  801302:	00 00 00 
  801305:	ff d0                	call   *%rax
  801307:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  801309:	85 c0                	test   %eax,%eax
  80130b:	78 25                	js     801332 <stat+0x4a>

    int res = fstat(fd, stat);
  80130d:	4c 89 e6             	mov    %r12,%rsi
  801310:	89 c7                	mov    %eax,%edi
  801312:	48 b8 64 12 80 00 00 	movabs $0x801264,%rax
  801319:	00 00 00 
  80131c:	ff d0                	call   *%rax
  80131e:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  801321:	89 df                	mov    %ebx,%edi
  801323:	48 b8 09 0e 80 00 00 	movabs $0x800e09,%rax
  80132a:	00 00 00 
  80132d:	ff d0                	call   *%rax

    return res;
  80132f:	44 89 e3             	mov    %r12d,%ebx
}
  801332:	89 d8                	mov    %ebx,%eax
  801334:	5b                   	pop    %rbx
  801335:	41 5c                	pop    %r12
  801337:	5d                   	pop    %rbp
  801338:	c3                   	ret

0000000000801339 <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  801339:	f3 0f 1e fa          	endbr64
  80133d:	55                   	push   %rbp
  80133e:	48 89 e5             	mov    %rsp,%rbp
  801341:	41 54                	push   %r12
  801343:	53                   	push   %rbx
  801344:	48 83 ec 10          	sub    $0x10,%rsp
  801348:	41 89 fc             	mov    %edi,%r12d
  80134b:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  80134e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801355:	00 00 00 
  801358:	83 38 00             	cmpl   $0x0,(%rax)
  80135b:	74 6e                	je     8013cb <fsipc+0x92>

    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }
    fsenv = ipc_find_env(ENV_TYPE_FS);
  80135d:	bf 03 00 00 00       	mov    $0x3,%edi
  801362:	48 b8 20 2d 80 00 00 	movabs $0x802d20,%rax
  801369:	00 00 00 
  80136c:	ff d0                	call   *%rax
  80136e:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  801375:	00 00 
    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  801377:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  80137d:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801382:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  801389:	00 00 00 
  80138c:	44 89 e6             	mov    %r12d,%esi
  80138f:	89 c7                	mov    %eax,%edi
  801391:	48 b8 5e 2c 80 00 00 	movabs $0x802c5e,%rax
  801398:	00 00 00 
  80139b:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  80139d:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  8013a4:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  8013a5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8013aa:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8013ae:	48 89 de             	mov    %rbx,%rsi
  8013b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8013b6:	48 b8 c5 2b 80 00 00 	movabs $0x802bc5,%rax
  8013bd:	00 00 00 
  8013c0:	ff d0                	call   *%rax
}
  8013c2:	48 83 c4 10          	add    $0x10,%rsp
  8013c6:	5b                   	pop    %rbx
  8013c7:	41 5c                	pop    %r12
  8013c9:	5d                   	pop    %rbp
  8013ca:	c3                   	ret
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  8013cb:	bf 03 00 00 00       	mov    $0x3,%edi
  8013d0:	48 b8 20 2d 80 00 00 	movabs $0x802d20,%rax
  8013d7:	00 00 00 
  8013da:	ff d0                	call   *%rax
  8013dc:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  8013e3:	00 00 
  8013e5:	e9 73 ff ff ff       	jmp    80135d <fsipc+0x24>

00000000008013ea <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  8013ea:	f3 0f 1e fa          	endbr64
  8013ee:	55                   	push   %rbp
  8013ef:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8013f2:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8013f9:	00 00 00 
  8013fc:	8b 57 0c             	mov    0xc(%rdi),%edx
  8013ff:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  801401:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  801404:	be 00 00 00 00       	mov    $0x0,%esi
  801409:	bf 02 00 00 00       	mov    $0x2,%edi
  80140e:	48 b8 39 13 80 00 00 	movabs $0x801339,%rax
  801415:	00 00 00 
  801418:	ff d0                	call   *%rax
}
  80141a:	5d                   	pop    %rbp
  80141b:	c3                   	ret

000000000080141c <devfile_flush>:
devfile_flush(struct Fd *fd) {
  80141c:	f3 0f 1e fa          	endbr64
  801420:	55                   	push   %rbp
  801421:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801424:	8b 47 0c             	mov    0xc(%rdi),%eax
  801427:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  80142e:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  801430:	be 00 00 00 00       	mov    $0x0,%esi
  801435:	bf 06 00 00 00       	mov    $0x6,%edi
  80143a:	48 b8 39 13 80 00 00 	movabs $0x801339,%rax
  801441:	00 00 00 
  801444:	ff d0                	call   *%rax
}
  801446:	5d                   	pop    %rbp
  801447:	c3                   	ret

0000000000801448 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  801448:	f3 0f 1e fa          	endbr64
  80144c:	55                   	push   %rbp
  80144d:	48 89 e5             	mov    %rsp,%rbp
  801450:	41 54                	push   %r12
  801452:	53                   	push   %rbx
  801453:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801456:	8b 47 0c             	mov    0xc(%rdi),%eax
  801459:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  801460:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  801462:	be 00 00 00 00       	mov    $0x0,%esi
  801467:	bf 05 00 00 00       	mov    $0x5,%edi
  80146c:	48 b8 39 13 80 00 00 	movabs $0x801339,%rax
  801473:	00 00 00 
  801476:	ff d0                	call   *%rax
    if (res < 0) return res;
  801478:	85 c0                	test   %eax,%eax
  80147a:	78 3d                	js     8014b9 <devfile_stat+0x71>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80147c:	49 bc 00 60 80 00 00 	movabs $0x806000,%r12
  801483:	00 00 00 
  801486:	4c 89 e6             	mov    %r12,%rsi
  801489:	48 89 df             	mov    %rbx,%rdi
  80148c:	48 b8 35 02 80 00 00 	movabs $0x800235,%rax
  801493:	00 00 00 
  801496:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  801498:	41 8b 84 24 80 00 00 	mov    0x80(%r12),%eax
  80149f:	00 
  8014a0:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8014a6:	41 8b 84 24 84 00 00 	mov    0x84(%r12),%eax
  8014ad:	00 
  8014ae:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  8014b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014b9:	5b                   	pop    %rbx
  8014ba:	41 5c                	pop    %r12
  8014bc:	5d                   	pop    %rbp
  8014bd:	c3                   	ret

00000000008014be <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  8014be:	f3 0f 1e fa          	endbr64
    if (n >= sizeof(fsipcbuf.write.req_buf)) {
  8014c2:	48 81 fa ef 0f 00 00 	cmp    $0xfef,%rdx
  8014c9:	77 41                	ja     80150c <devfile_write+0x4e>
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  8014cb:	55                   	push   %rbp
  8014cc:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  8014cf:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8014d6:	00 00 00 
  8014d9:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  8014dc:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.write.req_n = n;
  8014de:	48 89 50 08          	mov    %rdx,0x8(%rax)
    memmove(fsipcbuf.write.req_buf, buf, n);
  8014e2:	48 8d 78 10          	lea    0x10(%rax),%rdi
  8014e6:	48 b8 50 04 80 00 00 	movabs $0x800450,%rax
  8014ed:	00 00 00 
  8014f0:	ff d0                	call   *%rax
    res = fsipc(FSREQ_WRITE, NULL);
  8014f2:	be 00 00 00 00       	mov    $0x0,%esi
  8014f7:	bf 04 00 00 00       	mov    $0x4,%edi
  8014fc:	48 b8 39 13 80 00 00 	movabs $0x801339,%rax
  801503:	00 00 00 
  801506:	ff d0                	call   *%rax
  801508:	48 98                	cltq
}
  80150a:	5d                   	pop    %rbp
  80150b:	c3                   	ret
        return -E_INVAL;
  80150c:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
}
  801513:	c3                   	ret

0000000000801514 <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  801514:	f3 0f 1e fa          	endbr64
  801518:	55                   	push   %rbp
  801519:	48 89 e5             	mov    %rsp,%rbp
  80151c:	41 55                	push   %r13
  80151e:	41 54                	push   %r12
  801520:	53                   	push   %rbx
  801521:	48 83 ec 08          	sub    $0x8,%rsp
  801525:	49 89 f4             	mov    %rsi,%r12
  801528:	48 89 d3             	mov    %rdx,%rbx
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  80152b:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  801532:	00 00 00 
  801535:	8b 57 0c             	mov    0xc(%rdi),%edx
  801538:	89 10                	mov    %edx,(%rax)
    fsipcbuf.read.req_n = n;
  80153a:	48 89 58 08          	mov    %rbx,0x8(%rax)
    res = fsipc(FSREQ_READ, NULL);
  80153e:	be 00 00 00 00       	mov    $0x0,%esi
  801543:	bf 03 00 00 00       	mov    $0x3,%edi
  801548:	48 b8 39 13 80 00 00 	movabs $0x801339,%rax
  80154f:	00 00 00 
  801552:	ff d0                	call   *%rax
  801554:	4c 63 e8             	movslq %eax,%r13
    if (res < 0) {
  801557:	4d 85 ed             	test   %r13,%r13
  80155a:	78 2a                	js     801586 <devfile_read+0x72>
    assert(res <= n && res <= PAGE_SIZE);
  80155c:	4c 89 ea             	mov    %r13,%rdx
  80155f:	4c 39 eb             	cmp    %r13,%rbx
  801562:	72 30                	jb     801594 <devfile_read+0x80>
  801564:	49 81 fd 00 10 00 00 	cmp    $0x1000,%r13
  80156b:	7f 27                	jg     801594 <devfile_read+0x80>
    memmove(buf, &fsipcbuf, res);
  80156d:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  801574:	00 00 00 
  801577:	4c 89 e7             	mov    %r12,%rdi
  80157a:	48 b8 50 04 80 00 00 	movabs $0x800450,%rax
  801581:	00 00 00 
  801584:	ff d0                	call   *%rax
}
  801586:	4c 89 e8             	mov    %r13,%rax
  801589:	48 83 c4 08          	add    $0x8,%rsp
  80158d:	5b                   	pop    %rbx
  80158e:	41 5c                	pop    %r12
  801590:	41 5d                	pop    %r13
  801592:	5d                   	pop    %rbp
  801593:	c3                   	ret
    assert(res <= n && res <= PAGE_SIZE);
  801594:	48 b9 56 30 80 00 00 	movabs $0x803056,%rcx
  80159b:	00 00 00 
  80159e:	48 ba 73 30 80 00 00 	movabs $0x803073,%rdx
  8015a5:	00 00 00 
  8015a8:	be 7b 00 00 00       	mov    $0x7b,%esi
  8015ad:	48 bf 88 30 80 00 00 	movabs $0x803088,%rdi
  8015b4:	00 00 00 
  8015b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8015bc:	49 b8 65 21 80 00 00 	movabs $0x802165,%r8
  8015c3:	00 00 00 
  8015c6:	41 ff d0             	call   *%r8

00000000008015c9 <open>:
open(const char *path, int mode) {
  8015c9:	f3 0f 1e fa          	endbr64
  8015cd:	55                   	push   %rbp
  8015ce:	48 89 e5             	mov    %rsp,%rbp
  8015d1:	41 55                	push   %r13
  8015d3:	41 54                	push   %r12
  8015d5:	53                   	push   %rbx
  8015d6:	48 83 ec 18          	sub    $0x18,%rsp
  8015da:	49 89 fc             	mov    %rdi,%r12
  8015dd:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  8015e0:	48 b8 f0 01 80 00 00 	movabs $0x8001f0,%rax
  8015e7:	00 00 00 
  8015ea:	ff d0                	call   *%rax
  8015ec:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  8015f2:	0f 87 8a 00 00 00    	ja     801682 <open+0xb9>
    if ((res = fd_alloc(&fd)) < 0) return res;
  8015f8:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  8015fc:	48 b8 34 0c 80 00 00 	movabs $0x800c34,%rax
  801603:	00 00 00 
  801606:	ff d0                	call   *%rax
  801608:	89 c3                	mov    %eax,%ebx
  80160a:	85 c0                	test   %eax,%eax
  80160c:	78 50                	js     80165e <open+0x95>
    strcpy(fsipcbuf.open.req_path, path);
  80160e:	4c 89 e6             	mov    %r12,%rsi
  801611:	48 bb 00 60 80 00 00 	movabs $0x806000,%rbx
  801618:	00 00 00 
  80161b:	48 89 df             	mov    %rbx,%rdi
  80161e:	48 b8 35 02 80 00 00 	movabs $0x800235,%rax
  801625:	00 00 00 
  801628:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  80162a:	44 89 ab 00 04 00 00 	mov    %r13d,0x400(%rbx)
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  801631:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801635:	bf 01 00 00 00       	mov    $0x1,%edi
  80163a:	48 b8 39 13 80 00 00 	movabs $0x801339,%rax
  801641:	00 00 00 
  801644:	ff d0                	call   *%rax
  801646:	89 c3                	mov    %eax,%ebx
  801648:	85 c0                	test   %eax,%eax
  80164a:	78 1f                	js     80166b <open+0xa2>
    return fd2num(fd);
  80164c:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801650:	48 b8 fe 0b 80 00 00 	movabs $0x800bfe,%rax
  801657:	00 00 00 
  80165a:	ff d0                	call   *%rax
  80165c:	89 c3                	mov    %eax,%ebx
}
  80165e:	89 d8                	mov    %ebx,%eax
  801660:	48 83 c4 18          	add    $0x18,%rsp
  801664:	5b                   	pop    %rbx
  801665:	41 5c                	pop    %r12
  801667:	41 5d                	pop    %r13
  801669:	5d                   	pop    %rbp
  80166a:	c3                   	ret
        fd_close(fd, 0);
  80166b:	be 00 00 00 00       	mov    $0x0,%esi
  801670:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801674:	48 b8 5b 0d 80 00 00 	movabs $0x800d5b,%rax
  80167b:	00 00 00 
  80167e:	ff d0                	call   *%rax
        return res;
  801680:	eb dc                	jmp    80165e <open+0x95>
        return -E_BAD_PATH;
  801682:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  801687:	eb d5                	jmp    80165e <open+0x95>

0000000000801689 <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  801689:	f3 0f 1e fa          	endbr64
  80168d:	55                   	push   %rbp
  80168e:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  801691:	be 00 00 00 00       	mov    $0x0,%esi
  801696:	bf 08 00 00 00       	mov    $0x8,%edi
  80169b:	48 b8 39 13 80 00 00 	movabs $0x801339,%rax
  8016a2:	00 00 00 
  8016a5:	ff d0                	call   *%rax
}
  8016a7:	5d                   	pop    %rbp
  8016a8:	c3                   	ret

00000000008016a9 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  8016a9:	f3 0f 1e fa          	endbr64
  8016ad:	55                   	push   %rbp
  8016ae:	48 89 e5             	mov    %rsp,%rbp
  8016b1:	41 54                	push   %r12
  8016b3:	53                   	push   %rbx
  8016b4:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8016b7:	48 b8 14 0c 80 00 00 	movabs $0x800c14,%rax
  8016be:	00 00 00 
  8016c1:	ff d0                	call   *%rax
  8016c3:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  8016c6:	48 be 93 30 80 00 00 	movabs $0x803093,%rsi
  8016cd:	00 00 00 
  8016d0:	48 89 df             	mov    %rbx,%rdi
  8016d3:	48 b8 35 02 80 00 00 	movabs $0x800235,%rax
  8016da:	00 00 00 
  8016dd:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  8016df:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  8016e4:	41 2b 04 24          	sub    (%r12),%eax
  8016e8:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  8016ee:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  8016f5:	00 00 00 
    stat->st_dev = &devpipe;
  8016f8:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  8016ff:	00 00 00 
  801702:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  801709:	b8 00 00 00 00       	mov    $0x0,%eax
  80170e:	5b                   	pop    %rbx
  80170f:	41 5c                	pop    %r12
  801711:	5d                   	pop    %rbp
  801712:	c3                   	ret

0000000000801713 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  801713:	f3 0f 1e fa          	endbr64
  801717:	55                   	push   %rbp
  801718:	48 89 e5             	mov    %rsp,%rbp
  80171b:	41 54                	push   %r12
  80171d:	53                   	push   %rbx
  80171e:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801721:	ba 00 10 00 00       	mov    $0x1000,%edx
  801726:	48 89 fe             	mov    %rdi,%rsi
  801729:	bf 00 00 00 00       	mov    $0x0,%edi
  80172e:	49 bc 7a 09 80 00 00 	movabs $0x80097a,%r12
  801735:	00 00 00 
  801738:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  80173b:	48 89 df             	mov    %rbx,%rdi
  80173e:	48 b8 14 0c 80 00 00 	movabs $0x800c14,%rax
  801745:	00 00 00 
  801748:	ff d0                	call   *%rax
  80174a:	48 89 c6             	mov    %rax,%rsi
  80174d:	ba 00 10 00 00       	mov    $0x1000,%edx
  801752:	bf 00 00 00 00       	mov    $0x0,%edi
  801757:	41 ff d4             	call   *%r12
}
  80175a:	5b                   	pop    %rbx
  80175b:	41 5c                	pop    %r12
  80175d:	5d                   	pop    %rbp
  80175e:	c3                   	ret

000000000080175f <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  80175f:	f3 0f 1e fa          	endbr64
  801763:	55                   	push   %rbp
  801764:	48 89 e5             	mov    %rsp,%rbp
  801767:	41 57                	push   %r15
  801769:	41 56                	push   %r14
  80176b:	41 55                	push   %r13
  80176d:	41 54                	push   %r12
  80176f:	53                   	push   %rbx
  801770:	48 83 ec 18          	sub    $0x18,%rsp
  801774:	49 89 fc             	mov    %rdi,%r12
  801777:	49 89 f5             	mov    %rsi,%r13
  80177a:	49 89 d7             	mov    %rdx,%r15
  80177d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  801781:	48 b8 14 0c 80 00 00 	movabs $0x800c14,%rax
  801788:	00 00 00 
  80178b:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  80178d:	4d 85 ff             	test   %r15,%r15
  801790:	0f 84 af 00 00 00    	je     801845 <devpipe_write+0xe6>
  801796:	48 89 c3             	mov    %rax,%rbx
  801799:	4c 89 f8             	mov    %r15,%rax
  80179c:	4d 89 ef             	mov    %r13,%r15
  80179f:	4c 01 e8             	add    %r13,%rax
  8017a2:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8017a6:	49 bd 0a 08 80 00 00 	movabs $0x80080a,%r13
  8017ad:	00 00 00 
            sys_yield();
  8017b0:	49 be 9f 07 80 00 00 	movabs $0x80079f,%r14
  8017b7:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8017ba:	8b 73 04             	mov    0x4(%rbx),%esi
  8017bd:	48 63 ce             	movslq %esi,%rcx
  8017c0:	48 63 03             	movslq (%rbx),%rax
  8017c3:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8017c9:	48 39 c1             	cmp    %rax,%rcx
  8017cc:	72 2e                	jb     8017fc <devpipe_write+0x9d>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8017ce:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8017d3:	48 89 da             	mov    %rbx,%rdx
  8017d6:	be 00 10 00 00       	mov    $0x1000,%esi
  8017db:	4c 89 e7             	mov    %r12,%rdi
  8017de:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8017e1:	85 c0                	test   %eax,%eax
  8017e3:	74 66                	je     80184b <devpipe_write+0xec>
            sys_yield();
  8017e5:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8017e8:	8b 73 04             	mov    0x4(%rbx),%esi
  8017eb:	48 63 ce             	movslq %esi,%rcx
  8017ee:	48 63 03             	movslq (%rbx),%rax
  8017f1:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8017f7:	48 39 c1             	cmp    %rax,%rcx
  8017fa:	73 d2                	jae    8017ce <devpipe_write+0x6f>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8017fc:	41 0f b6 3f          	movzbl (%r15),%edi
  801800:	48 89 ca             	mov    %rcx,%rdx
  801803:	48 c1 ea 03          	shr    $0x3,%rdx
  801807:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  80180e:	08 10 20 
  801811:	48 f7 e2             	mul    %rdx
  801814:	48 c1 ea 06          	shr    $0x6,%rdx
  801818:	48 89 d0             	mov    %rdx,%rax
  80181b:	48 c1 e0 09          	shl    $0x9,%rax
  80181f:	48 29 d0             	sub    %rdx,%rax
  801822:	48 c1 e0 03          	shl    $0x3,%rax
  801826:	48 29 c1             	sub    %rax,%rcx
  801829:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  80182e:	83 c6 01             	add    $0x1,%esi
  801831:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  801834:	49 83 c7 01          	add    $0x1,%r15
  801838:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80183c:	49 39 c7             	cmp    %rax,%r15
  80183f:	0f 85 75 ff ff ff    	jne    8017ba <devpipe_write+0x5b>
    return n;
  801845:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801849:	eb 05                	jmp    801850 <devpipe_write+0xf1>
            if (_pipeisclosed(fd, p)) return 0;
  80184b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801850:	48 83 c4 18          	add    $0x18,%rsp
  801854:	5b                   	pop    %rbx
  801855:	41 5c                	pop    %r12
  801857:	41 5d                	pop    %r13
  801859:	41 5e                	pop    %r14
  80185b:	41 5f                	pop    %r15
  80185d:	5d                   	pop    %rbp
  80185e:	c3                   	ret

000000000080185f <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  80185f:	f3 0f 1e fa          	endbr64
  801863:	55                   	push   %rbp
  801864:	48 89 e5             	mov    %rsp,%rbp
  801867:	41 57                	push   %r15
  801869:	41 56                	push   %r14
  80186b:	41 55                	push   %r13
  80186d:	41 54                	push   %r12
  80186f:	53                   	push   %rbx
  801870:	48 83 ec 18          	sub    $0x18,%rsp
  801874:	49 89 fc             	mov    %rdi,%r12
  801877:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  80187b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  80187f:	48 b8 14 0c 80 00 00 	movabs $0x800c14,%rax
  801886:	00 00 00 
  801889:	ff d0                	call   *%rax
  80188b:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  80188e:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801894:	49 bd 0a 08 80 00 00 	movabs $0x80080a,%r13
  80189b:	00 00 00 
            sys_yield();
  80189e:	49 be 9f 07 80 00 00 	movabs $0x80079f,%r14
  8018a5:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  8018a8:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8018ad:	74 7d                	je     80192c <devpipe_read+0xcd>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8018af:	8b 03                	mov    (%rbx),%eax
  8018b1:	3b 43 04             	cmp    0x4(%rbx),%eax
  8018b4:	75 26                	jne    8018dc <devpipe_read+0x7d>
            if (i > 0) return i;
  8018b6:	4d 85 ff             	test   %r15,%r15
  8018b9:	75 77                	jne    801932 <devpipe_read+0xd3>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8018bb:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8018c0:	48 89 da             	mov    %rbx,%rdx
  8018c3:	be 00 10 00 00       	mov    $0x1000,%esi
  8018c8:	4c 89 e7             	mov    %r12,%rdi
  8018cb:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8018ce:	85 c0                	test   %eax,%eax
  8018d0:	74 72                	je     801944 <devpipe_read+0xe5>
            sys_yield();
  8018d2:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8018d5:	8b 03                	mov    (%rbx),%eax
  8018d7:	3b 43 04             	cmp    0x4(%rbx),%eax
  8018da:	74 df                	je     8018bb <devpipe_read+0x5c>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8018dc:	48 63 c8             	movslq %eax,%rcx
  8018df:	48 89 ca             	mov    %rcx,%rdx
  8018e2:	48 c1 ea 03          	shr    $0x3,%rdx
  8018e6:	48 be 81 00 01 02 04 	movabs $0x2010080402010081,%rsi
  8018ed:	08 10 20 
  8018f0:	48 89 d0             	mov    %rdx,%rax
  8018f3:	48 f7 e6             	mul    %rsi
  8018f6:	48 c1 ea 06          	shr    $0x6,%rdx
  8018fa:	48 89 d0             	mov    %rdx,%rax
  8018fd:	48 c1 e0 09          	shl    $0x9,%rax
  801901:	48 29 d0             	sub    %rdx,%rax
  801904:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80190b:	00 
  80190c:	48 89 c8             	mov    %rcx,%rax
  80190f:	48 29 d0             	sub    %rdx,%rax
  801912:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  801917:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  80191b:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  80191f:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  801922:	49 83 c7 01          	add    $0x1,%r15
  801926:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  80192a:	75 83                	jne    8018af <devpipe_read+0x50>
    return n;
  80192c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801930:	eb 03                	jmp    801935 <devpipe_read+0xd6>
            if (i > 0) return i;
  801932:	4c 89 f8             	mov    %r15,%rax
}
  801935:	48 83 c4 18          	add    $0x18,%rsp
  801939:	5b                   	pop    %rbx
  80193a:	41 5c                	pop    %r12
  80193c:	41 5d                	pop    %r13
  80193e:	41 5e                	pop    %r14
  801940:	41 5f                	pop    %r15
  801942:	5d                   	pop    %rbp
  801943:	c3                   	ret
            if (_pipeisclosed(fd, p)) return 0;
  801944:	b8 00 00 00 00       	mov    $0x0,%eax
  801949:	eb ea                	jmp    801935 <devpipe_read+0xd6>

000000000080194b <pipe>:
pipe(int pfd[2]) {
  80194b:	f3 0f 1e fa          	endbr64
  80194f:	55                   	push   %rbp
  801950:	48 89 e5             	mov    %rsp,%rbp
  801953:	41 55                	push   %r13
  801955:	41 54                	push   %r12
  801957:	53                   	push   %rbx
  801958:	48 83 ec 18          	sub    $0x18,%rsp
  80195c:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  80195f:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  801963:	48 b8 34 0c 80 00 00 	movabs $0x800c34,%rax
  80196a:	00 00 00 
  80196d:	ff d0                	call   *%rax
  80196f:	89 c3                	mov    %eax,%ebx
  801971:	85 c0                	test   %eax,%eax
  801973:	0f 88 a0 01 00 00    	js     801b19 <pipe+0x1ce>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  801979:	b9 46 00 00 00       	mov    $0x46,%ecx
  80197e:	ba 00 10 00 00       	mov    $0x1000,%edx
  801983:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801987:	bf 00 00 00 00       	mov    $0x0,%edi
  80198c:	48 b8 3a 08 80 00 00 	movabs $0x80083a,%rax
  801993:	00 00 00 
  801996:	ff d0                	call   *%rax
  801998:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  80199a:	85 c0                	test   %eax,%eax
  80199c:	0f 88 77 01 00 00    	js     801b19 <pipe+0x1ce>
    if ((res = fd_alloc(&fd1)) < 0 ||
  8019a2:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  8019a6:	48 b8 34 0c 80 00 00 	movabs $0x800c34,%rax
  8019ad:	00 00 00 
  8019b0:	ff d0                	call   *%rax
  8019b2:	89 c3                	mov    %eax,%ebx
  8019b4:	85 c0                	test   %eax,%eax
  8019b6:	0f 88 43 01 00 00    	js     801aff <pipe+0x1b4>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  8019bc:	b9 46 00 00 00       	mov    $0x46,%ecx
  8019c1:	ba 00 10 00 00       	mov    $0x1000,%edx
  8019c6:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8019ca:	bf 00 00 00 00       	mov    $0x0,%edi
  8019cf:	48 b8 3a 08 80 00 00 	movabs $0x80083a,%rax
  8019d6:	00 00 00 
  8019d9:	ff d0                	call   *%rax
  8019db:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  8019dd:	85 c0                	test   %eax,%eax
  8019df:	0f 88 1a 01 00 00    	js     801aff <pipe+0x1b4>
    va = fd2data(fd0);
  8019e5:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8019e9:	48 b8 14 0c 80 00 00 	movabs $0x800c14,%rax
  8019f0:	00 00 00 
  8019f3:	ff d0                	call   *%rax
  8019f5:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  8019f8:	b9 46 00 00 00       	mov    $0x46,%ecx
  8019fd:	ba 00 10 00 00       	mov    $0x1000,%edx
  801a02:	48 89 c6             	mov    %rax,%rsi
  801a05:	bf 00 00 00 00       	mov    $0x0,%edi
  801a0a:	48 b8 3a 08 80 00 00 	movabs $0x80083a,%rax
  801a11:	00 00 00 
  801a14:	ff d0                	call   *%rax
  801a16:	89 c3                	mov    %eax,%ebx
  801a18:	85 c0                	test   %eax,%eax
  801a1a:	0f 88 c5 00 00 00    	js     801ae5 <pipe+0x19a>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  801a20:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  801a24:	48 b8 14 0c 80 00 00 	movabs $0x800c14,%rax
  801a2b:	00 00 00 
  801a2e:	ff d0                	call   *%rax
  801a30:	48 89 c1             	mov    %rax,%rcx
  801a33:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  801a39:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801a3f:	ba 00 00 00 00       	mov    $0x0,%edx
  801a44:	4c 89 ee             	mov    %r13,%rsi
  801a47:	bf 00 00 00 00       	mov    $0x0,%edi
  801a4c:	48 b8 a5 08 80 00 00 	movabs $0x8008a5,%rax
  801a53:	00 00 00 
  801a56:	ff d0                	call   *%rax
  801a58:	89 c3                	mov    %eax,%ebx
  801a5a:	85 c0                	test   %eax,%eax
  801a5c:	78 6e                	js     801acc <pipe+0x181>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  801a5e:	be 00 10 00 00       	mov    $0x1000,%esi
  801a63:	4c 89 ef             	mov    %r13,%rdi
  801a66:	48 b8 d4 07 80 00 00 	movabs $0x8007d4,%rax
  801a6d:	00 00 00 
  801a70:	ff d0                	call   *%rax
  801a72:	83 f8 02             	cmp    $0x2,%eax
  801a75:	0f 85 ab 00 00 00    	jne    801b26 <pipe+0x1db>
    fd0->fd_dev_id = devpipe.dev_id;
  801a7b:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  801a82:	00 00 
  801a84:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801a88:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  801a8a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801a8e:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  801a95:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801a99:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  801a9b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a9f:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  801aa6:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  801aaa:	48 bb fe 0b 80 00 00 	movabs $0x800bfe,%rbx
  801ab1:	00 00 00 
  801ab4:	ff d3                	call   *%rbx
  801ab6:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  801aba:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  801abe:	ff d3                	call   *%rbx
  801ac0:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  801ac5:	bb 00 00 00 00       	mov    $0x0,%ebx
  801aca:	eb 4d                	jmp    801b19 <pipe+0x1ce>
    sys_unmap_region(0, va, PAGE_SIZE);
  801acc:	ba 00 10 00 00       	mov    $0x1000,%edx
  801ad1:	4c 89 ee             	mov    %r13,%rsi
  801ad4:	bf 00 00 00 00       	mov    $0x0,%edi
  801ad9:	48 b8 7a 09 80 00 00 	movabs $0x80097a,%rax
  801ae0:	00 00 00 
  801ae3:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  801ae5:	ba 00 10 00 00       	mov    $0x1000,%edx
  801aea:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  801aee:	bf 00 00 00 00       	mov    $0x0,%edi
  801af3:	48 b8 7a 09 80 00 00 	movabs $0x80097a,%rax
  801afa:	00 00 00 
  801afd:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  801aff:	ba 00 10 00 00       	mov    $0x1000,%edx
  801b04:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801b08:	bf 00 00 00 00       	mov    $0x0,%edi
  801b0d:	48 b8 7a 09 80 00 00 	movabs $0x80097a,%rax
  801b14:	00 00 00 
  801b17:	ff d0                	call   *%rax
}
  801b19:	89 d8                	mov    %ebx,%eax
  801b1b:	48 83 c4 18          	add    $0x18,%rsp
  801b1f:	5b                   	pop    %rbx
  801b20:	41 5c                	pop    %r12
  801b22:	41 5d                	pop    %r13
  801b24:	5d                   	pop    %rbp
  801b25:	c3                   	ret
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  801b26:	48 b9 c8 32 80 00 00 	movabs $0x8032c8,%rcx
  801b2d:	00 00 00 
  801b30:	48 ba 73 30 80 00 00 	movabs $0x803073,%rdx
  801b37:	00 00 00 
  801b3a:	be 2e 00 00 00       	mov    $0x2e,%esi
  801b3f:	48 bf 9a 30 80 00 00 	movabs $0x80309a,%rdi
  801b46:	00 00 00 
  801b49:	b8 00 00 00 00       	mov    $0x0,%eax
  801b4e:	49 b8 65 21 80 00 00 	movabs $0x802165,%r8
  801b55:	00 00 00 
  801b58:	41 ff d0             	call   *%r8

0000000000801b5b <pipeisclosed>:
pipeisclosed(int fdnum) {
  801b5b:	f3 0f 1e fa          	endbr64
  801b5f:	55                   	push   %rbp
  801b60:	48 89 e5             	mov    %rsp,%rbp
  801b63:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  801b67:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801b6b:	48 b8 98 0c 80 00 00 	movabs $0x800c98,%rax
  801b72:	00 00 00 
  801b75:	ff d0                	call   *%rax
    if (res < 0) return res;
  801b77:	85 c0                	test   %eax,%eax
  801b79:	78 35                	js     801bb0 <pipeisclosed+0x55>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  801b7b:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801b7f:	48 b8 14 0c 80 00 00 	movabs $0x800c14,%rax
  801b86:	00 00 00 
  801b89:	ff d0                	call   *%rax
  801b8b:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  801b8e:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801b93:	be 00 10 00 00       	mov    $0x1000,%esi
  801b98:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801b9c:	48 b8 0a 08 80 00 00 	movabs $0x80080a,%rax
  801ba3:	00 00 00 
  801ba6:	ff d0                	call   *%rax
  801ba8:	85 c0                	test   %eax,%eax
  801baa:	0f 94 c0             	sete   %al
  801bad:	0f b6 c0             	movzbl %al,%eax
}
  801bb0:	c9                   	leave
  801bb1:	c3                   	ret

0000000000801bb2 <get_uvpt_entry>:
extern volatile pde_t uvpd[];     /* VA of current page directory */
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
  801bb2:	f3 0f 1e fa          	endbr64
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  801bb6:	48 89 f8             	mov    %rdi,%rax
  801bb9:	48 c1 e8 27          	shr    $0x27,%rax
  801bbd:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  801bc4:	7f 00 00 
  801bc7:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801bcb:	f6 c2 01             	test   $0x1,%dl
  801bce:	74 6d                	je     801c3d <get_uvpt_entry+0x8b>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  801bd0:	48 89 f8             	mov    %rdi,%rax
  801bd3:	48 c1 e8 1e          	shr    $0x1e,%rax
  801bd7:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  801bde:	7f 00 00 
  801be1:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801be5:	f6 c2 01             	test   $0x1,%dl
  801be8:	74 62                	je     801c4c <get_uvpt_entry+0x9a>
  801bea:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  801bf1:	7f 00 00 
  801bf4:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801bf8:	f6 c2 80             	test   $0x80,%dl
  801bfb:	75 4f                	jne    801c4c <get_uvpt_entry+0x9a>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  801bfd:	48 89 f8             	mov    %rdi,%rax
  801c00:	48 c1 e8 15          	shr    $0x15,%rax
  801c04:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  801c0b:	7f 00 00 
  801c0e:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801c12:	f6 c2 01             	test   $0x1,%dl
  801c15:	74 44                	je     801c5b <get_uvpt_entry+0xa9>
  801c17:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  801c1e:	7f 00 00 
  801c21:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  801c25:	f6 c2 80             	test   $0x80,%dl
  801c28:	75 31                	jne    801c5b <get_uvpt_entry+0xa9>
    return uvpt[VPT(va)];
  801c2a:	48 c1 ef 0c          	shr    $0xc,%rdi
  801c2e:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  801c35:	7f 00 00 
  801c38:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  801c3c:	c3                   	ret
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  801c3d:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  801c44:	7f 00 00 
  801c47:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  801c4b:	c3                   	ret
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  801c4c:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  801c53:	7f 00 00 
  801c56:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  801c5a:	c3                   	ret
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  801c5b:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  801c62:	7f 00 00 
  801c65:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  801c69:	c3                   	ret

0000000000801c6a <get_phys_addr>:

uintptr_t
get_phys_addr(void *va) {
  801c6a:	f3 0f 1e fa          	endbr64
  801c6e:	48 89 fa             	mov    %rdi,%rdx
    if (!(uvpml4[VPML4(va)] & PTE_P))
  801c71:	48 89 f9             	mov    %rdi,%rcx
  801c74:	48 c1 e9 27          	shr    $0x27,%rcx
  801c78:	48 b8 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rax
  801c7f:	7f 00 00 
  801c82:	48 8b 0c c8          	mov    (%rax,%rcx,8),%rcx
        return -1;
  801c86:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpml4[VPML4(va)] & PTE_P))
  801c8d:	f6 c1 01             	test   $0x1,%cl
  801c90:	0f 84 b2 00 00 00    	je     801d48 <get_phys_addr+0xde>
    if (!(uvpdp[VPDP(va)] & PTE_P))
  801c96:	48 89 f9             	mov    %rdi,%rcx
  801c99:	48 c1 e9 1e          	shr    $0x1e,%rcx
  801c9d:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  801ca4:	7f 00 00 
  801ca7:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  801cab:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpdp[VPDP(va)] & PTE_P))
  801cb2:	40 f6 c6 01          	test   $0x1,%sil
  801cb6:	0f 84 8c 00 00 00    	je     801d48 <get_phys_addr+0xde>
    if (uvpdp[VPDP(va)] & PTE_PS)
  801cbc:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  801cc3:	7f 00 00 
  801cc6:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  801cca:	a8 80                	test   $0x80,%al
  801ccc:	75 7b                	jne    801d49 <get_phys_addr+0xdf>
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
    if (!(uvpd[VPD(va)] & PTE_P))
  801cce:	48 89 f9             	mov    %rdi,%rcx
  801cd1:	48 c1 e9 15          	shr    $0x15,%rcx
  801cd5:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  801cdc:	7f 00 00 
  801cdf:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  801ce3:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpd[VPD(va)] & PTE_P))
  801cea:	40 f6 c6 01          	test   $0x1,%sil
  801cee:	74 58                	je     801d48 <get_phys_addr+0xde>
    if ((uvpd[VPD(va)] & PTE_PS))
  801cf0:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  801cf7:	7f 00 00 
  801cfa:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  801cfe:	a8 80                	test   $0x80,%al
  801d00:	75 6c                	jne    801d6e <get_phys_addr+0x104>
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
    if (!(uvpt[VPT(va)] & PTE_P))
  801d02:	48 89 f9             	mov    %rdi,%rcx
  801d05:	48 c1 e9 0c          	shr    $0xc,%rcx
  801d09:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  801d10:	7f 00 00 
  801d13:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  801d17:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpt[VPT(va)] & PTE_P))
  801d1e:	40 f6 c6 01          	test   $0x1,%sil
  801d22:	74 24                	je     801d48 <get_phys_addr+0xde>
    return PTE_ADDR(uvpt[VPT(va)]) + PAGE_OFFSET(va);
  801d24:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  801d2b:	7f 00 00 
  801d2e:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  801d32:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  801d39:	ff ff 7f 
  801d3c:	48 21 c8             	and    %rcx,%rax
  801d3f:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  801d45:	48 09 d0             	or     %rdx,%rax
}
  801d48:	c3                   	ret
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
  801d49:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  801d50:	7f 00 00 
  801d53:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  801d57:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  801d5e:	ff ff 7f 
  801d61:	48 21 c8             	and    %rcx,%rax
  801d64:	81 e2 ff ff ff 3f    	and    $0x3fffffff,%edx
  801d6a:	48 01 d0             	add    %rdx,%rax
  801d6d:	c3                   	ret
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
  801d6e:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  801d75:	7f 00 00 
  801d78:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  801d7c:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  801d83:	ff ff 7f 
  801d86:	48 21 c8             	and    %rcx,%rax
  801d89:	81 e2 ff ff 1f 00    	and    $0x1fffff,%edx
  801d8f:	48 01 d0             	add    %rdx,%rax
  801d92:	c3                   	ret

0000000000801d93 <get_prot>:

int
get_prot(void *va) {
  801d93:	f3 0f 1e fa          	endbr64
  801d97:	55                   	push   %rbp
  801d98:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  801d9b:	48 b8 b2 1b 80 00 00 	movabs $0x801bb2,%rax
  801da2:	00 00 00 
  801da5:	ff d0                	call   *%rax
  801da7:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
    if (pte & PTE_P) prot |= PROT_R;
  801daa:	83 e0 01             	and    $0x1,%eax
  801dad:	c1 e0 02             	shl    $0x2,%eax
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  801db0:	89 d1                	mov    %edx,%ecx
  801db2:	81 e1 00 0a 00 00    	and    $0xa00,%ecx
    if (pte & PTE_P) prot |= PROT_R;
  801db8:	09 c8                	or     %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  801dba:	89 c1                	mov    %eax,%ecx
  801dbc:	83 c9 02             	or     $0x2,%ecx
  801dbf:	f6 c2 02             	test   $0x2,%dl
  801dc2:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  801dc5:	89 c1                	mov    %eax,%ecx
  801dc7:	83 c9 01             	or     $0x1,%ecx
  801dca:	48 85 d2             	test   %rdx,%rdx
  801dcd:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  801dd0:	89 c1                	mov    %eax,%ecx
  801dd2:	83 c9 40             	or     $0x40,%ecx
  801dd5:	f6 c6 04             	test   $0x4,%dh
  801dd8:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  801ddb:	5d                   	pop    %rbp
  801ddc:	c3                   	ret

0000000000801ddd <is_page_dirty>:

bool
is_page_dirty(void *va) {
  801ddd:	f3 0f 1e fa          	endbr64
  801de1:	55                   	push   %rbp
  801de2:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  801de5:	48 b8 b2 1b 80 00 00 	movabs $0x801bb2,%rax
  801dec:	00 00 00 
  801def:	ff d0                	call   *%rax
    return pte & PTE_D;
  801df1:	48 c1 e8 06          	shr    $0x6,%rax
  801df5:	83 e0 01             	and    $0x1,%eax
}
  801df8:	5d                   	pop    %rbp
  801df9:	c3                   	ret

0000000000801dfa <is_page_present>:

bool
is_page_present(void *va) {
  801dfa:	f3 0f 1e fa          	endbr64
  801dfe:	55                   	push   %rbp
  801dff:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  801e02:	48 b8 b2 1b 80 00 00 	movabs $0x801bb2,%rax
  801e09:	00 00 00 
  801e0c:	ff d0                	call   *%rax
  801e0e:	83 e0 01             	and    $0x1,%eax
}
  801e11:	5d                   	pop    %rbp
  801e12:	c3                   	ret

0000000000801e13 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  801e13:	f3 0f 1e fa          	endbr64
  801e17:	55                   	push   %rbp
  801e18:	48 89 e5             	mov    %rsp,%rbp
  801e1b:	41 57                	push   %r15
  801e1d:	41 56                	push   %r14
  801e1f:	41 55                	push   %r13
  801e21:	41 54                	push   %r12
  801e23:	53                   	push   %rbx
  801e24:	48 83 ec 18          	sub    $0x18,%rsp
  801e28:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801e2c:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
     * NOTE: Skip over larger pages/page directories for efficiency */
    // LAB 11: Your code here:

    int res = 0;
    (void)fun, (void)arg;
    uintptr_t va = 0;
  801e30:	bb 00 00 00 00       	mov    $0x0,%ebx
    while (va < USER_STACK_TOP) {
        size_t size = 0;
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  801e35:	49 be 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%r14
  801e3c:	7f 00 00 
            size = 1LL << PML4_SHIFT;
            goto next;
        }

        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  801e3f:	49 bd 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%r13
  801e46:	7f 00 00 
    while (va < USER_STACK_TOP) {
  801e49:	49 bf ff 6f ff ff 7f 	movabs $0x7fffff6fff,%r15
  801e50:	00 00 00 
  801e53:	eb 73                	jmp    801ec8 <foreach_shared_region+0xb5>
            }

            goto next;
        }

        if (!(uvpd[VPD(va)] & PTE_P)) {
  801e55:	48 89 d8             	mov    %rbx,%rax
  801e58:	48 c1 e8 15          	shr    $0x15,%rax
  801e5c:	48 b9 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rcx
  801e63:	7f 00 00 
  801e66:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
            size = 1LL << PD_SHIFT;
  801e6a:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
        if (!(uvpd[VPD(va)] & PTE_P)) {
  801e70:	f6 c2 01             	test   $0x1,%dl
  801e73:	74 4b                	je     801ec0 <foreach_shared_region+0xad>
            goto next;
        }

        if (uvpd[VPD(va)] & PTE_PS) {
  801e75:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
  801e79:	f6 c2 80             	test   $0x80,%dl
  801e7c:	74 11                	je     801e8f <foreach_shared_region+0x7c>
            size = 1LL << PD_SHIFT;
            if (uvpd[VPD(va)] & PTE_SHARE) {
  801e7e:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
  801e82:	f6 c4 04             	test   $0x4,%ah
  801e85:	74 39                	je     801ec0 <foreach_shared_region+0xad>
            size = 1LL << PD_SHIFT;
  801e87:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
  801e8d:	eb 20                	jmp    801eaf <foreach_shared_region+0x9c>

            goto next;
        }

        size = PAGE_SIZE;
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  801e8f:	48 89 da             	mov    %rbx,%rdx
  801e92:	48 c1 ea 0c          	shr    $0xc,%rdx
  801e96:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  801e9d:	7f 00 00 
  801ea0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
        size = PAGE_SIZE;
  801ea4:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  801eaa:	f6 c4 04             	test   $0x4,%ah
  801ead:	74 11                	je     801ec0 <foreach_shared_region+0xad>
            goto next;
        }

    map:
        fun((void *)va, (void *)(va + size), arg);
  801eaf:	49 8d 34 1c          	lea    (%r12,%rbx,1),%rsi
  801eb3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801eb7:	48 89 df             	mov    %rbx,%rdi
  801eba:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801ebe:	ff d0                	call   *%rax
    next:
        va += size;
  801ec0:	4c 01 e3             	add    %r12,%rbx
    while (va < USER_STACK_TOP) {
  801ec3:	49 39 df             	cmp    %rbx,%r15
  801ec6:	72 3e                	jb     801f06 <foreach_shared_region+0xf3>
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  801ec8:	49 8b 06             	mov    (%r14),%rax
  801ecb:	a8 01                	test   $0x1,%al
  801ecd:	74 37                	je     801f06 <foreach_shared_region+0xf3>
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  801ecf:	48 89 d8             	mov    %rbx,%rax
  801ed2:	48 c1 e8 1e          	shr    $0x1e,%rax
  801ed6:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
            size = 1LL << PDP_SHIFT;
  801edb:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  801ee1:	f6 c2 01             	test   $0x1,%dl
  801ee4:	74 da                	je     801ec0 <foreach_shared_region+0xad>
        if (uvpdp[VPDP(va)] & PTE_PS) {
  801ee6:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
  801eeb:	f6 c2 80             	test   $0x80,%dl
  801eee:	0f 84 61 ff ff ff    	je     801e55 <foreach_shared_region+0x42>
            if (uvpdp[VPDP(va)] & PTE_SHARE) {
  801ef4:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  801ef9:	f6 c4 04             	test   $0x4,%ah
  801efc:	74 c2                	je     801ec0 <foreach_shared_region+0xad>
            size = 1LL << PDP_SHIFT;
  801efe:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
  801f04:	eb a9                	jmp    801eaf <foreach_shared_region+0x9c>
    }
    return res;
}
  801f06:	b8 00 00 00 00       	mov    $0x0,%eax
  801f0b:	48 83 c4 18          	add    $0x18,%rsp
  801f0f:	5b                   	pop    %rbx
  801f10:	41 5c                	pop    %r12
  801f12:	41 5d                	pop    %r13
  801f14:	41 5e                	pop    %r14
  801f16:	41 5f                	pop    %r15
  801f18:	5d                   	pop    %rbp
  801f19:	c3                   	ret

0000000000801f1a <devcons_close>:

    return res;
}

static int
devcons_close(struct Fd *fd) {
  801f1a:	f3 0f 1e fa          	endbr64
    USED(fd);

    return 0;
}
  801f1e:	b8 00 00 00 00       	mov    $0x0,%eax
  801f23:	c3                   	ret

0000000000801f24 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  801f24:	f3 0f 1e fa          	endbr64
  801f28:	55                   	push   %rbp
  801f29:	48 89 e5             	mov    %rsp,%rbp
  801f2c:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  801f2f:	48 be aa 30 80 00 00 	movabs $0x8030aa,%rsi
  801f36:	00 00 00 
  801f39:	48 b8 35 02 80 00 00 	movabs $0x800235,%rax
  801f40:	00 00 00 
  801f43:	ff d0                	call   *%rax
    return 0;
}
  801f45:	b8 00 00 00 00       	mov    $0x0,%eax
  801f4a:	5d                   	pop    %rbp
  801f4b:	c3                   	ret

0000000000801f4c <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  801f4c:	f3 0f 1e fa          	endbr64
  801f50:	55                   	push   %rbp
  801f51:	48 89 e5             	mov    %rsp,%rbp
  801f54:	41 57                	push   %r15
  801f56:	41 56                	push   %r14
  801f58:	41 55                	push   %r13
  801f5a:	41 54                	push   %r12
  801f5c:	53                   	push   %rbx
  801f5d:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  801f64:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  801f6b:	48 85 d2             	test   %rdx,%rdx
  801f6e:	74 7a                	je     801fea <devcons_write+0x9e>
  801f70:	49 89 d6             	mov    %rdx,%r14
  801f73:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  801f79:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  801f7e:	49 bf 50 04 80 00 00 	movabs $0x800450,%r15
  801f85:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  801f88:	4c 89 f3             	mov    %r14,%rbx
  801f8b:	48 29 f3             	sub    %rsi,%rbx
  801f8e:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801f93:	48 39 c3             	cmp    %rax,%rbx
  801f96:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  801f9a:	4c 63 eb             	movslq %ebx,%r13
  801f9d:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  801fa4:	48 01 c6             	add    %rax,%rsi
  801fa7:	4c 89 ea             	mov    %r13,%rdx
  801faa:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  801fb1:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  801fb4:	4c 89 ee             	mov    %r13,%rsi
  801fb7:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  801fbe:	48 b8 95 06 80 00 00 	movabs $0x800695,%rax
  801fc5:	00 00 00 
  801fc8:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  801fca:	41 01 dc             	add    %ebx,%r12d
  801fcd:	49 63 f4             	movslq %r12d,%rsi
  801fd0:	4c 39 f6             	cmp    %r14,%rsi
  801fd3:	72 b3                	jb     801f88 <devcons_write+0x3c>
    return res;
  801fd5:	49 63 c4             	movslq %r12d,%rax
}
  801fd8:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  801fdf:	5b                   	pop    %rbx
  801fe0:	41 5c                	pop    %r12
  801fe2:	41 5d                	pop    %r13
  801fe4:	41 5e                	pop    %r14
  801fe6:	41 5f                	pop    %r15
  801fe8:	5d                   	pop    %rbp
  801fe9:	c3                   	ret
    for (res = 0; res < n; res += inc) {
  801fea:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  801ff0:	eb e3                	jmp    801fd5 <devcons_write+0x89>

0000000000801ff2 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  801ff2:	f3 0f 1e fa          	endbr64
  801ff6:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  801ff9:	ba 00 00 00 00       	mov    $0x0,%edx
  801ffe:	48 85 c0             	test   %rax,%rax
  802001:	74 55                	je     802058 <devcons_read+0x66>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802003:	55                   	push   %rbp
  802004:	48 89 e5             	mov    %rsp,%rbp
  802007:	41 55                	push   %r13
  802009:	41 54                	push   %r12
  80200b:	53                   	push   %rbx
  80200c:	48 83 ec 08          	sub    $0x8,%rsp
  802010:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  802013:	48 bb c6 06 80 00 00 	movabs $0x8006c6,%rbx
  80201a:	00 00 00 
  80201d:	49 bc 9f 07 80 00 00 	movabs $0x80079f,%r12
  802024:	00 00 00 
  802027:	eb 03                	jmp    80202c <devcons_read+0x3a>
  802029:	41 ff d4             	call   *%r12
  80202c:	ff d3                	call   *%rbx
  80202e:	85 c0                	test   %eax,%eax
  802030:	74 f7                	je     802029 <devcons_read+0x37>
    if (c < 0) return c;
  802032:	48 63 d0             	movslq %eax,%rdx
  802035:	78 13                	js     80204a <devcons_read+0x58>
    if (c == 0x04) return 0;
  802037:	ba 00 00 00 00       	mov    $0x0,%edx
  80203c:	83 f8 04             	cmp    $0x4,%eax
  80203f:	74 09                	je     80204a <devcons_read+0x58>
    *(char *)vbuf = (char)c;
  802041:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  802045:	ba 01 00 00 00       	mov    $0x1,%edx
}
  80204a:	48 89 d0             	mov    %rdx,%rax
  80204d:	48 83 c4 08          	add    $0x8,%rsp
  802051:	5b                   	pop    %rbx
  802052:	41 5c                	pop    %r12
  802054:	41 5d                	pop    %r13
  802056:	5d                   	pop    %rbp
  802057:	c3                   	ret
  802058:	48 89 d0             	mov    %rdx,%rax
  80205b:	c3                   	ret

000000000080205c <cputchar>:
cputchar(int ch) {
  80205c:	f3 0f 1e fa          	endbr64
  802060:	55                   	push   %rbp
  802061:	48 89 e5             	mov    %rsp,%rbp
  802064:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  802068:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  80206c:	be 01 00 00 00       	mov    $0x1,%esi
  802071:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  802075:	48 b8 95 06 80 00 00 	movabs $0x800695,%rax
  80207c:	00 00 00 
  80207f:	ff d0                	call   *%rax
}
  802081:	c9                   	leave
  802082:	c3                   	ret

0000000000802083 <getchar>:
getchar(void) {
  802083:	f3 0f 1e fa          	endbr64
  802087:	55                   	push   %rbp
  802088:	48 89 e5             	mov    %rsp,%rbp
  80208b:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  80208f:	ba 01 00 00 00       	mov    $0x1,%edx
  802094:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  802098:	bf 00 00 00 00       	mov    $0x0,%edi
  80209d:	48 b8 93 0f 80 00 00 	movabs $0x800f93,%rax
  8020a4:	00 00 00 
  8020a7:	ff d0                	call   *%rax
  8020a9:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  8020ab:	85 c0                	test   %eax,%eax
  8020ad:	78 06                	js     8020b5 <getchar+0x32>
  8020af:	74 08                	je     8020b9 <getchar+0x36>
  8020b1:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  8020b5:	89 d0                	mov    %edx,%eax
  8020b7:	c9                   	leave
  8020b8:	c3                   	ret
    return res < 0 ? res : res ? c :
  8020b9:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  8020be:	eb f5                	jmp    8020b5 <getchar+0x32>

00000000008020c0 <iscons>:
iscons(int fdnum) {
  8020c0:	f3 0f 1e fa          	endbr64
  8020c4:	55                   	push   %rbp
  8020c5:	48 89 e5             	mov    %rsp,%rbp
  8020c8:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8020cc:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8020d0:	48 b8 98 0c 80 00 00 	movabs $0x800c98,%rax
  8020d7:	00 00 00 
  8020da:	ff d0                	call   *%rax
    if (res < 0) return res;
  8020dc:	85 c0                	test   %eax,%eax
  8020de:	78 18                	js     8020f8 <iscons+0x38>
    return fd->fd_dev_id == devcons.dev_id;
  8020e0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8020e4:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  8020eb:	00 00 00 
  8020ee:	8b 00                	mov    (%rax),%eax
  8020f0:	39 02                	cmp    %eax,(%rdx)
  8020f2:	0f 94 c0             	sete   %al
  8020f5:	0f b6 c0             	movzbl %al,%eax
}
  8020f8:	c9                   	leave
  8020f9:	c3                   	ret

00000000008020fa <opencons>:
opencons(void) {
  8020fa:	f3 0f 1e fa          	endbr64
  8020fe:	55                   	push   %rbp
  8020ff:	48 89 e5             	mov    %rsp,%rbp
  802102:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  802106:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  80210a:	48 b8 34 0c 80 00 00 	movabs $0x800c34,%rax
  802111:	00 00 00 
  802114:	ff d0                	call   *%rax
  802116:	85 c0                	test   %eax,%eax
  802118:	78 49                	js     802163 <opencons+0x69>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  80211a:	b9 46 00 00 00       	mov    $0x46,%ecx
  80211f:	ba 00 10 00 00       	mov    $0x1000,%edx
  802124:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  802128:	bf 00 00 00 00       	mov    $0x0,%edi
  80212d:	48 b8 3a 08 80 00 00 	movabs $0x80083a,%rax
  802134:	00 00 00 
  802137:	ff d0                	call   *%rax
  802139:	85 c0                	test   %eax,%eax
  80213b:	78 26                	js     802163 <opencons+0x69>
    fd->fd_dev_id = devcons.dev_id;
  80213d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802141:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  802148:	00 00 
  80214a:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  80214c:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802150:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  802157:	48 b8 fe 0b 80 00 00 	movabs $0x800bfe,%rax
  80215e:	00 00 00 
  802161:	ff d0                	call   *%rax
}
  802163:	c9                   	leave
  802164:	c3                   	ret

0000000000802165 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  802165:	f3 0f 1e fa          	endbr64
  802169:	55                   	push   %rbp
  80216a:	48 89 e5             	mov    %rsp,%rbp
  80216d:	41 56                	push   %r14
  80216f:	41 55                	push   %r13
  802171:	41 54                	push   %r12
  802173:	53                   	push   %rbx
  802174:	48 83 ec 50          	sub    $0x50,%rsp
  802178:	49 89 fc             	mov    %rdi,%r12
  80217b:	41 89 f5             	mov    %esi,%r13d
  80217e:	48 89 d3             	mov    %rdx,%rbx
  802181:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  802185:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  802189:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  80218d:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  802194:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802198:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  80219c:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  8021a0:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  8021a4:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  8021ab:	00 00 00 
  8021ae:	4c 8b 30             	mov    (%rax),%r14
  8021b1:	48 b8 6a 07 80 00 00 	movabs $0x80076a,%rax
  8021b8:	00 00 00 
  8021bb:	ff d0                	call   *%rax
  8021bd:	89 c6                	mov    %eax,%esi
  8021bf:	45 89 e8             	mov    %r13d,%r8d
  8021c2:	4c 89 e1             	mov    %r12,%rcx
  8021c5:	4c 89 f2             	mov    %r14,%rdx
  8021c8:	48 bf f0 32 80 00 00 	movabs $0x8032f0,%rdi
  8021cf:	00 00 00 
  8021d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8021d7:	49 bc c1 22 80 00 00 	movabs $0x8022c1,%r12
  8021de:	00 00 00 
  8021e1:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  8021e4:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  8021e8:	48 89 df             	mov    %rbx,%rdi
  8021eb:	48 b8 59 22 80 00 00 	movabs $0x802259,%rax
  8021f2:	00 00 00 
  8021f5:	ff d0                	call   *%rax
    cprintf("\n");
  8021f7:	48 bf 37 30 80 00 00 	movabs $0x803037,%rdi
  8021fe:	00 00 00 
  802201:	b8 00 00 00 00       	mov    $0x0,%eax
  802206:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  802209:	cc                   	int3
  80220a:	eb fd                	jmp    802209 <_panic+0xa4>

000000000080220c <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  80220c:	f3 0f 1e fa          	endbr64
  802210:	55                   	push   %rbp
  802211:	48 89 e5             	mov    %rsp,%rbp
  802214:	53                   	push   %rbx
  802215:	48 83 ec 08          	sub    $0x8,%rsp
  802219:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  80221c:	8b 06                	mov    (%rsi),%eax
  80221e:	8d 50 01             	lea    0x1(%rax),%edx
  802221:	89 16                	mov    %edx,(%rsi)
  802223:	48 98                	cltq
  802225:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  80222a:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  802230:	74 0a                	je     80223c <putch+0x30>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  802232:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  802236:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80223a:	c9                   	leave
  80223b:	c3                   	ret
        sys_cputs(state->buf, state->offset);
  80223c:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  802240:	be ff 00 00 00       	mov    $0xff,%esi
  802245:	48 b8 95 06 80 00 00 	movabs $0x800695,%rax
  80224c:	00 00 00 
  80224f:	ff d0                	call   *%rax
        state->offset = 0;
  802251:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  802257:	eb d9                	jmp    802232 <putch+0x26>

0000000000802259 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  802259:	f3 0f 1e fa          	endbr64
  80225d:	55                   	push   %rbp
  80225e:	48 89 e5             	mov    %rsp,%rbp
  802261:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  802268:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  80226b:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  802272:	b9 21 00 00 00       	mov    $0x21,%ecx
  802277:	b8 00 00 00 00       	mov    $0x0,%eax
  80227c:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  80227f:	48 89 f1             	mov    %rsi,%rcx
  802282:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  802289:	48 bf 0c 22 80 00 00 	movabs $0x80220c,%rdi
  802290:	00 00 00 
  802293:	48 b8 21 24 80 00 00 	movabs $0x802421,%rax
  80229a:	00 00 00 
  80229d:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  80229f:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  8022a6:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  8022ad:	48 b8 95 06 80 00 00 	movabs $0x800695,%rax
  8022b4:	00 00 00 
  8022b7:	ff d0                	call   *%rax

    return state.count;
}
  8022b9:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  8022bf:	c9                   	leave
  8022c0:	c3                   	ret

00000000008022c1 <cprintf>:

int
cprintf(const char *fmt, ...) {
  8022c1:	f3 0f 1e fa          	endbr64
  8022c5:	55                   	push   %rbp
  8022c6:	48 89 e5             	mov    %rsp,%rbp
  8022c9:	48 83 ec 50          	sub    $0x50,%rsp
  8022cd:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  8022d1:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8022d5:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8022d9:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8022dd:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  8022e1:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  8022e8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8022ec:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8022f0:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8022f4:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  8022f8:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  8022fc:	48 b8 59 22 80 00 00 	movabs $0x802259,%rax
  802303:	00 00 00 
  802306:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  802308:	c9                   	leave
  802309:	c3                   	ret

000000000080230a <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  80230a:	f3 0f 1e fa          	endbr64
  80230e:	55                   	push   %rbp
  80230f:	48 89 e5             	mov    %rsp,%rbp
  802312:	41 57                	push   %r15
  802314:	41 56                	push   %r14
  802316:	41 55                	push   %r13
  802318:	41 54                	push   %r12
  80231a:	53                   	push   %rbx
  80231b:	48 83 ec 18          	sub    $0x18,%rsp
  80231f:	49 89 fc             	mov    %rdi,%r12
  802322:	49 89 f5             	mov    %rsi,%r13
  802325:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  802329:	8b 45 10             	mov    0x10(%rbp),%eax
  80232c:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  80232f:	41 89 cf             	mov    %ecx,%r15d
  802332:	4c 39 fa             	cmp    %r15,%rdx
  802335:	73 5b                	jae    802392 <print_num+0x88>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  802337:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  80233b:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  80233f:	85 db                	test   %ebx,%ebx
  802341:	7e 0e                	jle    802351 <print_num+0x47>
            putch(padc, put_arg);
  802343:	4c 89 ee             	mov    %r13,%rsi
  802346:	44 89 f7             	mov    %r14d,%edi
  802349:	41 ff d4             	call   *%r12
        while (--width > 0) {
  80234c:	83 eb 01             	sub    $0x1,%ebx
  80234f:	75 f2                	jne    802343 <print_num+0x39>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  802351:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  802355:	48 b9 c7 30 80 00 00 	movabs $0x8030c7,%rcx
  80235c:	00 00 00 
  80235f:	48 b8 b6 30 80 00 00 	movabs $0x8030b6,%rax
  802366:	00 00 00 
  802369:	48 0f 45 c8          	cmovne %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  80236d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802371:	ba 00 00 00 00       	mov    $0x0,%edx
  802376:	49 f7 f7             	div    %r15
  802379:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  80237d:	4c 89 ee             	mov    %r13,%rsi
  802380:	41 ff d4             	call   *%r12
}
  802383:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  802387:	5b                   	pop    %rbx
  802388:	41 5c                	pop    %r12
  80238a:	41 5d                	pop    %r13
  80238c:	41 5e                	pop    %r14
  80238e:	41 5f                	pop    %r15
  802390:	5d                   	pop    %rbp
  802391:	c3                   	ret
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  802392:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802396:	ba 00 00 00 00       	mov    $0x0,%edx
  80239b:	49 f7 f7             	div    %r15
  80239e:	48 83 ec 08          	sub    $0x8,%rsp
  8023a2:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  8023a6:	52                   	push   %rdx
  8023a7:	45 0f be c9          	movsbl %r9b,%r9d
  8023ab:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  8023af:	48 89 c2             	mov    %rax,%rdx
  8023b2:	48 b8 0a 23 80 00 00 	movabs $0x80230a,%rax
  8023b9:	00 00 00 
  8023bc:	ff d0                	call   *%rax
  8023be:	48 83 c4 10          	add    $0x10,%rsp
  8023c2:	eb 8d                	jmp    802351 <print_num+0x47>

00000000008023c4 <sprintputch>:
    char *end;
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
  8023c4:	f3 0f 1e fa          	endbr64
    state->count++;
  8023c8:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  8023cc:	48 8b 06             	mov    (%rsi),%rax
  8023cf:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  8023d3:	73 0a                	jae    8023df <sprintputch+0x1b>
        *state->start++ = ch;
  8023d5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8023d9:	48 89 16             	mov    %rdx,(%rsi)
  8023dc:	40 88 38             	mov    %dil,(%rax)
    }
}
  8023df:	c3                   	ret

00000000008023e0 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  8023e0:	f3 0f 1e fa          	endbr64
  8023e4:	55                   	push   %rbp
  8023e5:	48 89 e5             	mov    %rsp,%rbp
  8023e8:	48 83 ec 50          	sub    $0x50,%rsp
  8023ec:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8023f0:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8023f4:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  8023f8:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  8023ff:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802403:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802407:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80240b:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  80240f:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  802413:	48 b8 21 24 80 00 00 	movabs $0x802421,%rax
  80241a:	00 00 00 
  80241d:	ff d0                	call   *%rax
}
  80241f:	c9                   	leave
  802420:	c3                   	ret

0000000000802421 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  802421:	f3 0f 1e fa          	endbr64
  802425:	55                   	push   %rbp
  802426:	48 89 e5             	mov    %rsp,%rbp
  802429:	41 57                	push   %r15
  80242b:	41 56                	push   %r14
  80242d:	41 55                	push   %r13
  80242f:	41 54                	push   %r12
  802431:	53                   	push   %rbx
  802432:	48 83 ec 38          	sub    $0x38,%rsp
  802436:	49 89 fe             	mov    %rdi,%r14
  802439:	49 89 f5             	mov    %rsi,%r13
  80243c:	48 89 d3             	mov    %rdx,%rbx
    va_copy(aq, ap);
  80243f:	48 8b 01             	mov    (%rcx),%rax
  802442:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  802446:	48 8b 41 08          	mov    0x8(%rcx),%rax
  80244a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80244e:	48 8b 41 10          	mov    0x10(%rcx),%rax
  802452:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  802456:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  80245a:	0f b6 3b             	movzbl (%rbx),%edi
  80245d:	40 80 ff 25          	cmp    $0x25,%dil
  802461:	74 18                	je     80247b <vprintfmt+0x5a>
            if (!ch) return;
  802463:	40 84 ff             	test   %dil,%dil
  802466:	0f 84 b2 06 00 00    	je     802b1e <vprintfmt+0x6fd>
            putch(ch, put_arg);
  80246c:	40 0f b6 ff          	movzbl %dil,%edi
  802470:	4c 89 ee             	mov    %r13,%rsi
  802473:	41 ff d6             	call   *%r14
        while ((ch = *ufmt++) != '%') {
  802476:	4c 89 e3             	mov    %r12,%rbx
  802479:	eb db                	jmp    802456 <vprintfmt+0x35>
        bool altflag = 0, zflag = 0;
  80247b:	be 00 00 00 00       	mov    $0x0,%esi
  802480:	c6 45 ab 00          	movb   $0x0,-0x55(%rbp)
        unsigned lflag = 0, base = 10;
  802484:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  802489:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  80248f:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  802496:	c6 45 aa 20          	movb   $0x20,-0x56(%rbp)
        switch (ch = *ufmt++) {
  80249a:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  80249f:	41 0f b6 04 24       	movzbl (%r12),%eax
  8024a4:	88 45 a0             	mov    %al,-0x60(%rbp)
  8024a7:	83 e8 23             	sub    $0x23,%eax
  8024aa:	3c 57                	cmp    $0x57,%al
  8024ac:	0f 87 52 06 00 00    	ja     802b04 <vprintfmt+0x6e3>
  8024b2:	0f b6 c0             	movzbl %al,%eax
  8024b5:	48 b9 60 33 80 00 00 	movabs $0x803360,%rcx
  8024bc:	00 00 00 
  8024bf:	3e ff 24 c1          	notrack jmp *(%rcx,%rax,8)
  8024c3:	49 89 dc             	mov    %rbx,%r12
            altflag = 1;
  8024c6:	c6 45 ab 01          	movb   $0x1,-0x55(%rbp)
  8024ca:	eb ce                	jmp    80249a <vprintfmt+0x79>
        switch (ch = *ufmt++) {
  8024cc:	49 89 dc             	mov    %rbx,%r12
  8024cf:	be 01 00 00 00       	mov    $0x1,%esi
  8024d4:	eb c4                	jmp    80249a <vprintfmt+0x79>
            padc = ch;
  8024d6:	0f b6 45 a0          	movzbl -0x60(%rbp),%eax
  8024da:	88 45 aa             	mov    %al,-0x56(%rbp)
        switch (ch = *ufmt++) {
  8024dd:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  8024e0:	eb b8                	jmp    80249a <vprintfmt+0x79>
            precision = va_arg(aq, int);
  8024e2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8024e5:	83 f8 2f             	cmp    $0x2f,%eax
  8024e8:	77 24                	ja     80250e <vprintfmt+0xed>
  8024ea:	89 c1                	mov    %eax,%ecx
  8024ec:	48 03 4d c8          	add    -0x38(%rbp),%rcx
  8024f0:	83 c0 08             	add    $0x8,%eax
  8024f3:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8024f6:	44 8b 39             	mov    (%rcx),%r15d
        switch (ch = *ufmt++) {
  8024f9:	49 89 dc             	mov    %rbx,%r12
            if (width < 0) {
  8024fc:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  802500:	79 98                	jns    80249a <vprintfmt+0x79>
                width = precision;
  802502:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
                precision = -1;
  802506:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  80250c:	eb 8c                	jmp    80249a <vprintfmt+0x79>
            precision = va_arg(aq, int);
  80250e:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  802512:	48 8d 41 08          	lea    0x8(%rcx),%rax
  802516:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80251a:	eb da                	jmp    8024f6 <vprintfmt+0xd5>
                precision = precision * 10 + ch - '0';
  80251c:	44 0f b6 7d a0       	movzbl -0x60(%rbp),%r15d
  802521:	41 83 ef 30          	sub    $0x30,%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  802525:	41 0f b6 44 24 01    	movzbl 0x1(%r12),%eax
  80252b:	3c 39                	cmp    $0x39,%al
  80252d:	77 1c                	ja     80254b <vprintfmt+0x12a>
            for (precision = 0;; ++ufmt) {
  80252f:	48 83 c3 01          	add    $0x1,%rbx
                precision = precision * 10 + ch - '0';
  802533:	43 8d 0c bf          	lea    (%r15,%r15,4),%ecx
  802537:	0f b6 c0             	movzbl %al,%eax
  80253a:	44 8d 7c 48 d0       	lea    -0x30(%rax,%rcx,2),%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  80253f:	0f b6 03             	movzbl (%rbx),%eax
  802542:	3c 39                	cmp    $0x39,%al
  802544:	76 e9                	jbe    80252f <vprintfmt+0x10e>
        process_precision:
  802546:	49 89 dc             	mov    %rbx,%r12
  802549:	eb b1                	jmp    8024fc <vprintfmt+0xdb>
        switch (ch = *ufmt++) {
  80254b:	49 89 dc             	mov    %rbx,%r12
  80254e:	eb ac                	jmp    8024fc <vprintfmt+0xdb>
            width = MAX(0, width);
  802550:	8b 4d ac             	mov    -0x54(%rbp),%ecx
  802553:	85 c9                	test   %ecx,%ecx
  802555:	b8 00 00 00 00       	mov    $0x0,%eax
  80255a:	0f 49 c1             	cmovns %ecx,%eax
  80255d:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  802560:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  802563:	e9 32 ff ff ff       	jmp    80249a <vprintfmt+0x79>
            lflag++;
  802568:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  80256b:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  80256e:	e9 27 ff ff ff       	jmp    80249a <vprintfmt+0x79>
            putch(va_arg(aq, int), put_arg);
  802573:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802576:	83 f8 2f             	cmp    $0x2f,%eax
  802579:	77 19                	ja     802594 <vprintfmt+0x173>
  80257b:	89 c2                	mov    %eax,%edx
  80257d:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802581:	83 c0 08             	add    $0x8,%eax
  802584:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802587:	8b 3a                	mov    (%rdx),%edi
  802589:	4c 89 ee             	mov    %r13,%rsi
  80258c:	41 ff d6             	call   *%r14
            break;
  80258f:	e9 c2 fe ff ff       	jmp    802456 <vprintfmt+0x35>
            putch(va_arg(aq, int), put_arg);
  802594:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802598:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80259c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8025a0:	eb e5                	jmp    802587 <vprintfmt+0x166>
            int err = va_arg(aq, int);
  8025a2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8025a5:	83 f8 2f             	cmp    $0x2f,%eax
  8025a8:	77 5a                	ja     802604 <vprintfmt+0x1e3>
  8025aa:	89 c2                	mov    %eax,%edx
  8025ac:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8025b0:	83 c0 08             	add    $0x8,%eax
  8025b3:	89 45 b8             	mov    %eax,-0x48(%rbp)
            if (err < 0) err = -err;
  8025b6:	8b 02                	mov    (%rdx),%eax
  8025b8:	89 c1                	mov    %eax,%ecx
  8025ba:	f7 d9                	neg    %ecx
  8025bc:	0f 48 c8             	cmovs  %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  8025bf:	83 f9 13             	cmp    $0x13,%ecx
  8025c2:	7f 4e                	jg     802612 <vprintfmt+0x1f1>
  8025c4:	48 63 c1             	movslq %ecx,%rax
  8025c7:	48 ba 20 36 80 00 00 	movabs $0x803620,%rdx
  8025ce:	00 00 00 
  8025d1:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8025d5:	48 85 c0             	test   %rax,%rax
  8025d8:	74 38                	je     802612 <vprintfmt+0x1f1>
                printfmt(putch, put_arg, "%s", strerr);
  8025da:	48 89 c1             	mov    %rax,%rcx
  8025dd:	48 ba 85 30 80 00 00 	movabs $0x803085,%rdx
  8025e4:	00 00 00 
  8025e7:	4c 89 ee             	mov    %r13,%rsi
  8025ea:	4c 89 f7             	mov    %r14,%rdi
  8025ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8025f2:	49 b8 e0 23 80 00 00 	movabs $0x8023e0,%r8
  8025f9:	00 00 00 
  8025fc:	41 ff d0             	call   *%r8
  8025ff:	e9 52 fe ff ff       	jmp    802456 <vprintfmt+0x35>
            int err = va_arg(aq, int);
  802604:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802608:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80260c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802610:	eb a4                	jmp    8025b6 <vprintfmt+0x195>
                printfmt(putch, put_arg, "error %d", err);
  802612:	48 ba df 30 80 00 00 	movabs $0x8030df,%rdx
  802619:	00 00 00 
  80261c:	4c 89 ee             	mov    %r13,%rsi
  80261f:	4c 89 f7             	mov    %r14,%rdi
  802622:	b8 00 00 00 00       	mov    $0x0,%eax
  802627:	49 b8 e0 23 80 00 00 	movabs $0x8023e0,%r8
  80262e:	00 00 00 
  802631:	41 ff d0             	call   *%r8
  802634:	e9 1d fe ff ff       	jmp    802456 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  802639:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80263c:	83 f8 2f             	cmp    $0x2f,%eax
  80263f:	77 6c                	ja     8026ad <vprintfmt+0x28c>
  802641:	89 c2                	mov    %eax,%edx
  802643:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802647:	83 c0 08             	add    $0x8,%eax
  80264a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80264d:	48 8b 12             	mov    (%rdx),%rdx
            if (!ptr) ptr = "(null)";
  802650:	48 85 d2             	test   %rdx,%rdx
  802653:	48 b8 d8 30 80 00 00 	movabs $0x8030d8,%rax
  80265a:	00 00 00 
  80265d:	48 0f 45 c2          	cmovne %rdx,%rax
  802661:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
            if (width > 0 && padc != '-') {
  802665:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  802669:	7e 06                	jle    802671 <vprintfmt+0x250>
  80266b:	80 7d aa 2d          	cmpb   $0x2d,-0x56(%rbp)
  80266f:	75 4a                	jne    8026bb <vprintfmt+0x29a>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  802671:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  802675:	4c 8d 60 01          	lea    0x1(%rax),%r12
  802679:	0f b6 00             	movzbl (%rax),%eax
  80267c:	84 c0                	test   %al,%al
  80267e:	0f 85 9a 00 00 00    	jne    80271e <vprintfmt+0x2fd>
            while (width-- > 0) putch(' ', put_arg);
  802684:	8b 45 ac             	mov    -0x54(%rbp),%eax
  802687:	44 8d 60 ff          	lea    -0x1(%rax),%r12d
  80268b:	85 c0                	test   %eax,%eax
  80268d:	0f 8e c3 fd ff ff    	jle    802456 <vprintfmt+0x35>
  802693:	4c 89 ee             	mov    %r13,%rsi
  802696:	bf 20 00 00 00       	mov    $0x20,%edi
  80269b:	41 ff d6             	call   *%r14
  80269e:	41 83 ec 01          	sub    $0x1,%r12d
  8026a2:	41 83 fc ff          	cmp    $0xffffffff,%r12d
  8026a6:	75 eb                	jne    802693 <vprintfmt+0x272>
  8026a8:	e9 a9 fd ff ff       	jmp    802456 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  8026ad:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8026b1:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8026b5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8026b9:	eb 92                	jmp    80264d <vprintfmt+0x22c>
                width -= strnlen(ptr, precision);
  8026bb:	49 63 f7             	movslq %r15d,%rsi
  8026be:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  8026c2:	48 b8 0f 02 80 00 00 	movabs $0x80020f,%rax
  8026c9:	00 00 00 
  8026cc:	ff d0                	call   *%rax
  8026ce:	48 89 c2             	mov    %rax,%rdx
  8026d1:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8026d4:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  8026d6:	8d 70 ff             	lea    -0x1(%rax),%esi
  8026d9:	89 75 ac             	mov    %esi,-0x54(%rbp)
  8026dc:	85 c0                	test   %eax,%eax
  8026de:	7e 91                	jle    802671 <vprintfmt+0x250>
  8026e0:	44 0f be 65 aa       	movsbl -0x56(%rbp),%r12d
  8026e5:	4c 89 ee             	mov    %r13,%rsi
  8026e8:	44 89 e7             	mov    %r12d,%edi
  8026eb:	41 ff d6             	call   *%r14
  8026ee:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  8026f2:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8026f5:	83 f8 ff             	cmp    $0xffffffff,%eax
  8026f8:	75 eb                	jne    8026e5 <vprintfmt+0x2c4>
  8026fa:	e9 72 ff ff ff       	jmp    802671 <vprintfmt+0x250>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  8026ff:	0f b6 f8             	movzbl %al,%edi
  802702:	4c 89 ee             	mov    %r13,%rsi
  802705:	41 ff d6             	call   *%r14
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  802708:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  80270c:	49 83 c4 01          	add    $0x1,%r12
  802710:	41 0f b6 44 24 ff    	movzbl -0x1(%r12),%eax
  802716:	84 c0                	test   %al,%al
  802718:	0f 84 66 ff ff ff    	je     802684 <vprintfmt+0x263>
  80271e:	45 85 ff             	test   %r15d,%r15d
  802721:	78 0a                	js     80272d <vprintfmt+0x30c>
  802723:	41 83 ef 01          	sub    $0x1,%r15d
  802727:	0f 88 57 ff ff ff    	js     802684 <vprintfmt+0x263>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  80272d:	80 7d ab 00          	cmpb   $0x0,-0x55(%rbp)
  802731:	74 cc                	je     8026ff <vprintfmt+0x2de>
  802733:	8d 50 e0             	lea    -0x20(%rax),%edx
  802736:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80273b:	80 fa 5e             	cmp    $0x5e,%dl
  80273e:	77 c2                	ja     802702 <vprintfmt+0x2e1>
  802740:	eb bd                	jmp    8026ff <vprintfmt+0x2de>
    if (zflag) return va_arg(*ap, size_t);
  802742:	40 84 f6             	test   %sil,%sil
  802745:	75 26                	jne    80276d <vprintfmt+0x34c>
    switch (lflag) {
  802747:	85 d2                	test   %edx,%edx
  802749:	74 59                	je     8027a4 <vprintfmt+0x383>
  80274b:	83 fa 01             	cmp    $0x1,%edx
  80274e:	74 7b                	je     8027cb <vprintfmt+0x3aa>
        return va_arg(*ap, long long);
  802750:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802753:	83 f8 2f             	cmp    $0x2f,%eax
  802756:	0f 87 96 00 00 00    	ja     8027f2 <vprintfmt+0x3d1>
  80275c:	89 c2                	mov    %eax,%edx
  80275e:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802762:	83 c0 08             	add    $0x8,%eax
  802765:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802768:	4c 8b 22             	mov    (%rdx),%r12
  80276b:	eb 17                	jmp    802784 <vprintfmt+0x363>
    if (zflag) return va_arg(*ap, size_t);
  80276d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802770:	83 f8 2f             	cmp    $0x2f,%eax
  802773:	77 21                	ja     802796 <vprintfmt+0x375>
  802775:	89 c2                	mov    %eax,%edx
  802777:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80277b:	83 c0 08             	add    $0x8,%eax
  80277e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802781:	4c 8b 22             	mov    (%rdx),%r12
            if (i < 0) {
  802784:	4d 85 e4             	test   %r12,%r12
  802787:	78 7a                	js     802803 <vprintfmt+0x3e2>
            num = i;
  802789:	4c 89 e2             	mov    %r12,%rdx
        unsigned lflag = 0, base = 10;
  80278c:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  802791:	e9 50 02 00 00       	jmp    8029e6 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  802796:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80279a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80279e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8027a2:	eb dd                	jmp    802781 <vprintfmt+0x360>
        return va_arg(*ap, int);
  8027a4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8027a7:	83 f8 2f             	cmp    $0x2f,%eax
  8027aa:	77 11                	ja     8027bd <vprintfmt+0x39c>
  8027ac:	89 c2                	mov    %eax,%edx
  8027ae:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8027b2:	83 c0 08             	add    $0x8,%eax
  8027b5:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8027b8:	4c 63 22             	movslq (%rdx),%r12
  8027bb:	eb c7                	jmp    802784 <vprintfmt+0x363>
  8027bd:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8027c1:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8027c5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8027c9:	eb ed                	jmp    8027b8 <vprintfmt+0x397>
        return va_arg(*ap, long);
  8027cb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8027ce:	83 f8 2f             	cmp    $0x2f,%eax
  8027d1:	77 11                	ja     8027e4 <vprintfmt+0x3c3>
  8027d3:	89 c2                	mov    %eax,%edx
  8027d5:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8027d9:	83 c0 08             	add    $0x8,%eax
  8027dc:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8027df:	4c 8b 22             	mov    (%rdx),%r12
  8027e2:	eb a0                	jmp    802784 <vprintfmt+0x363>
  8027e4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8027e8:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8027ec:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8027f0:	eb ed                	jmp    8027df <vprintfmt+0x3be>
        return va_arg(*ap, long long);
  8027f2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8027f6:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8027fa:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8027fe:	e9 65 ff ff ff       	jmp    802768 <vprintfmt+0x347>
                putch('-', put_arg);
  802803:	4c 89 ee             	mov    %r13,%rsi
  802806:	bf 2d 00 00 00       	mov    $0x2d,%edi
  80280b:	41 ff d6             	call   *%r14
                i = -i;
  80280e:	49 f7 dc             	neg    %r12
  802811:	e9 73 ff ff ff       	jmp    802789 <vprintfmt+0x368>
    if (zflag) return va_arg(*ap, size_t);
  802816:	40 84 f6             	test   %sil,%sil
  802819:	75 32                	jne    80284d <vprintfmt+0x42c>
    switch (lflag) {
  80281b:	85 d2                	test   %edx,%edx
  80281d:	74 5d                	je     80287c <vprintfmt+0x45b>
  80281f:	83 fa 01             	cmp    $0x1,%edx
  802822:	0f 84 82 00 00 00    	je     8028aa <vprintfmt+0x489>
        return va_arg(*ap, unsigned long long);
  802828:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80282b:	83 f8 2f             	cmp    $0x2f,%eax
  80282e:	0f 87 a5 00 00 00    	ja     8028d9 <vprintfmt+0x4b8>
  802834:	89 c2                	mov    %eax,%edx
  802836:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80283a:	83 c0 08             	add    $0x8,%eax
  80283d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802840:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  802843:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  802848:	e9 99 01 00 00       	jmp    8029e6 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  80284d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802850:	83 f8 2f             	cmp    $0x2f,%eax
  802853:	77 19                	ja     80286e <vprintfmt+0x44d>
  802855:	89 c2                	mov    %eax,%edx
  802857:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80285b:	83 c0 08             	add    $0x8,%eax
  80285e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802861:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  802864:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  802869:	e9 78 01 00 00       	jmp    8029e6 <vprintfmt+0x5c5>
  80286e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802872:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802876:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80287a:	eb e5                	jmp    802861 <vprintfmt+0x440>
        return va_arg(*ap, unsigned int);
  80287c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80287f:	83 f8 2f             	cmp    $0x2f,%eax
  802882:	77 18                	ja     80289c <vprintfmt+0x47b>
  802884:	89 c2                	mov    %eax,%edx
  802886:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80288a:	83 c0 08             	add    $0x8,%eax
  80288d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802890:	8b 12                	mov    (%rdx),%edx
        unsigned lflag = 0, base = 10;
  802892:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  802897:	e9 4a 01 00 00       	jmp    8029e6 <vprintfmt+0x5c5>
  80289c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8028a0:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8028a4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8028a8:	eb e6                	jmp    802890 <vprintfmt+0x46f>
        return va_arg(*ap, unsigned long);
  8028aa:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8028ad:	83 f8 2f             	cmp    $0x2f,%eax
  8028b0:	77 19                	ja     8028cb <vprintfmt+0x4aa>
  8028b2:	89 c2                	mov    %eax,%edx
  8028b4:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8028b8:	83 c0 08             	add    $0x8,%eax
  8028bb:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8028be:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  8028c1:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  8028c6:	e9 1b 01 00 00       	jmp    8029e6 <vprintfmt+0x5c5>
  8028cb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8028cf:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8028d3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8028d7:	eb e5                	jmp    8028be <vprintfmt+0x49d>
        return va_arg(*ap, unsigned long long);
  8028d9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8028dd:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8028e1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8028e5:	e9 56 ff ff ff       	jmp    802840 <vprintfmt+0x41f>
    if (zflag) return va_arg(*ap, size_t);
  8028ea:	40 84 f6             	test   %sil,%sil
  8028ed:	75 2e                	jne    80291d <vprintfmt+0x4fc>
    switch (lflag) {
  8028ef:	85 d2                	test   %edx,%edx
  8028f1:	74 59                	je     80294c <vprintfmt+0x52b>
  8028f3:	83 fa 01             	cmp    $0x1,%edx
  8028f6:	74 7f                	je     802977 <vprintfmt+0x556>
        return va_arg(*ap, unsigned long long);
  8028f8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8028fb:	83 f8 2f             	cmp    $0x2f,%eax
  8028fe:	0f 87 9f 00 00 00    	ja     8029a3 <vprintfmt+0x582>
  802904:	89 c2                	mov    %eax,%edx
  802906:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80290a:	83 c0 08             	add    $0x8,%eax
  80290d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802910:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  802913:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  802918:	e9 c9 00 00 00       	jmp    8029e6 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  80291d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802920:	83 f8 2f             	cmp    $0x2f,%eax
  802923:	77 19                	ja     80293e <vprintfmt+0x51d>
  802925:	89 c2                	mov    %eax,%edx
  802927:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80292b:	83 c0 08             	add    $0x8,%eax
  80292e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802931:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  802934:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  802939:	e9 a8 00 00 00       	jmp    8029e6 <vprintfmt+0x5c5>
  80293e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802942:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802946:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80294a:	eb e5                	jmp    802931 <vprintfmt+0x510>
        return va_arg(*ap, unsigned int);
  80294c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80294f:	83 f8 2f             	cmp    $0x2f,%eax
  802952:	77 15                	ja     802969 <vprintfmt+0x548>
  802954:	89 c2                	mov    %eax,%edx
  802956:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80295a:	83 c0 08             	add    $0x8,%eax
  80295d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802960:	8b 12                	mov    (%rdx),%edx
            base = 8;
  802962:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  802967:	eb 7d                	jmp    8029e6 <vprintfmt+0x5c5>
  802969:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80296d:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802971:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802975:	eb e9                	jmp    802960 <vprintfmt+0x53f>
        return va_arg(*ap, unsigned long);
  802977:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80297a:	83 f8 2f             	cmp    $0x2f,%eax
  80297d:	77 16                	ja     802995 <vprintfmt+0x574>
  80297f:	89 c2                	mov    %eax,%edx
  802981:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802985:	83 c0 08             	add    $0x8,%eax
  802988:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80298b:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  80298e:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  802993:	eb 51                	jmp    8029e6 <vprintfmt+0x5c5>
  802995:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802999:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80299d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8029a1:	eb e8                	jmp    80298b <vprintfmt+0x56a>
        return va_arg(*ap, unsigned long long);
  8029a3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8029a7:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8029ab:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8029af:	e9 5c ff ff ff       	jmp    802910 <vprintfmt+0x4ef>
            putch('0', put_arg);
  8029b4:	4c 89 ee             	mov    %r13,%rsi
  8029b7:	bf 30 00 00 00       	mov    $0x30,%edi
  8029bc:	41 ff d6             	call   *%r14
            putch('x', put_arg);
  8029bf:	4c 89 ee             	mov    %r13,%rsi
  8029c2:	bf 78 00 00 00       	mov    $0x78,%edi
  8029c7:	41 ff d6             	call   *%r14
            num = (uintptr_t)va_arg(aq, void *);
  8029ca:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8029cd:	83 f8 2f             	cmp    $0x2f,%eax
  8029d0:	77 47                	ja     802a19 <vprintfmt+0x5f8>
  8029d2:	89 c2                	mov    %eax,%edx
  8029d4:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8029d8:	83 c0 08             	add    $0x8,%eax
  8029db:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8029de:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  8029e1:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  8029e6:	48 83 ec 08          	sub    $0x8,%rsp
  8029ea:	80 7d a0 58          	cmpb   $0x58,-0x60(%rbp)
  8029ee:	0f 94 c0             	sete   %al
  8029f1:	0f b6 c0             	movzbl %al,%eax
  8029f4:	50                   	push   %rax
  8029f5:	44 0f be 4d aa       	movsbl -0x56(%rbp),%r9d
  8029fa:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  8029fe:	4c 89 ee             	mov    %r13,%rsi
  802a01:	4c 89 f7             	mov    %r14,%rdi
  802a04:	48 b8 0a 23 80 00 00 	movabs $0x80230a,%rax
  802a0b:	00 00 00 
  802a0e:	ff d0                	call   *%rax
            break;
  802a10:	48 83 c4 10          	add    $0x10,%rsp
  802a14:	e9 3d fa ff ff       	jmp    802456 <vprintfmt+0x35>
            num = (uintptr_t)va_arg(aq, void *);
  802a19:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802a1d:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802a21:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802a25:	eb b7                	jmp    8029de <vprintfmt+0x5bd>
    if (zflag) return va_arg(*ap, size_t);
  802a27:	40 84 f6             	test   %sil,%sil
  802a2a:	75 2b                	jne    802a57 <vprintfmt+0x636>
    switch (lflag) {
  802a2c:	85 d2                	test   %edx,%edx
  802a2e:	74 56                	je     802a86 <vprintfmt+0x665>
  802a30:	83 fa 01             	cmp    $0x1,%edx
  802a33:	74 7f                	je     802ab4 <vprintfmt+0x693>
        return va_arg(*ap, unsigned long long);
  802a35:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802a38:	83 f8 2f             	cmp    $0x2f,%eax
  802a3b:	0f 87 a2 00 00 00    	ja     802ae3 <vprintfmt+0x6c2>
  802a41:	89 c2                	mov    %eax,%edx
  802a43:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802a47:	83 c0 08             	add    $0x8,%eax
  802a4a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802a4d:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  802a50:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  802a55:	eb 8f                	jmp    8029e6 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  802a57:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802a5a:	83 f8 2f             	cmp    $0x2f,%eax
  802a5d:	77 19                	ja     802a78 <vprintfmt+0x657>
  802a5f:	89 c2                	mov    %eax,%edx
  802a61:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802a65:	83 c0 08             	add    $0x8,%eax
  802a68:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802a6b:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  802a6e:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  802a73:	e9 6e ff ff ff       	jmp    8029e6 <vprintfmt+0x5c5>
  802a78:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802a7c:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802a80:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802a84:	eb e5                	jmp    802a6b <vprintfmt+0x64a>
        return va_arg(*ap, unsigned int);
  802a86:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802a89:	83 f8 2f             	cmp    $0x2f,%eax
  802a8c:	77 18                	ja     802aa6 <vprintfmt+0x685>
  802a8e:	89 c2                	mov    %eax,%edx
  802a90:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802a94:	83 c0 08             	add    $0x8,%eax
  802a97:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802a9a:	8b 12                	mov    (%rdx),%edx
            base = 16;
  802a9c:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  802aa1:	e9 40 ff ff ff       	jmp    8029e6 <vprintfmt+0x5c5>
  802aa6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802aaa:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802aae:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802ab2:	eb e6                	jmp    802a9a <vprintfmt+0x679>
        return va_arg(*ap, unsigned long);
  802ab4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802ab7:	83 f8 2f             	cmp    $0x2f,%eax
  802aba:	77 19                	ja     802ad5 <vprintfmt+0x6b4>
  802abc:	89 c2                	mov    %eax,%edx
  802abe:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  802ac2:	83 c0 08             	add    $0x8,%eax
  802ac5:	89 45 b8             	mov    %eax,-0x48(%rbp)
  802ac8:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  802acb:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  802ad0:	e9 11 ff ff ff       	jmp    8029e6 <vprintfmt+0x5c5>
  802ad5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802ad9:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802add:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802ae1:	eb e5                	jmp    802ac8 <vprintfmt+0x6a7>
        return va_arg(*ap, unsigned long long);
  802ae3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802ae7:	48 8d 42 08          	lea    0x8(%rdx),%rax
  802aeb:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802aef:	e9 59 ff ff ff       	jmp    802a4d <vprintfmt+0x62c>
            putch(ch, put_arg);
  802af4:	4c 89 ee             	mov    %r13,%rsi
  802af7:	bf 25 00 00 00       	mov    $0x25,%edi
  802afc:	41 ff d6             	call   *%r14
            break;
  802aff:	e9 52 f9 ff ff       	jmp    802456 <vprintfmt+0x35>
            putch('%', put_arg);
  802b04:	4c 89 ee             	mov    %r13,%rsi
  802b07:	bf 25 00 00 00       	mov    $0x25,%edi
  802b0c:	41 ff d6             	call   *%r14
            while ((--ufmt)[-1] != '%') /* nothing */
  802b0f:	48 83 eb 01          	sub    $0x1,%rbx
  802b13:	80 7b ff 25          	cmpb   $0x25,-0x1(%rbx)
  802b17:	75 f6                	jne    802b0f <vprintfmt+0x6ee>
  802b19:	e9 38 f9 ff ff       	jmp    802456 <vprintfmt+0x35>
}
  802b1e:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  802b22:	5b                   	pop    %rbx
  802b23:	41 5c                	pop    %r12
  802b25:	41 5d                	pop    %r13
  802b27:	41 5e                	pop    %r14
  802b29:	41 5f                	pop    %r15
  802b2b:	5d                   	pop    %rbp
  802b2c:	c3                   	ret

0000000000802b2d <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  802b2d:	f3 0f 1e fa          	endbr64
  802b31:	55                   	push   %rbp
  802b32:	48 89 e5             	mov    %rsp,%rbp
  802b35:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  802b39:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b3d:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  802b42:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  802b46:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  802b4d:	48 85 ff             	test   %rdi,%rdi
  802b50:	74 2b                	je     802b7d <vsnprintf+0x50>
  802b52:	48 85 f6             	test   %rsi,%rsi
  802b55:	74 26                	je     802b7d <vsnprintf+0x50>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  802b57:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  802b5b:	48 bf c4 23 80 00 00 	movabs $0x8023c4,%rdi
  802b62:	00 00 00 
  802b65:	48 b8 21 24 80 00 00 	movabs $0x802421,%rax
  802b6c:	00 00 00 
  802b6f:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  802b71:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b75:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  802b78:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802b7b:	c9                   	leave
  802b7c:	c3                   	ret
    if (!buf || n < 1) return -E_INVAL;
  802b7d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b82:	eb f7                	jmp    802b7b <vsnprintf+0x4e>

0000000000802b84 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  802b84:	f3 0f 1e fa          	endbr64
  802b88:	55                   	push   %rbp
  802b89:	48 89 e5             	mov    %rsp,%rbp
  802b8c:	48 83 ec 50          	sub    $0x50,%rsp
  802b90:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802b94:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  802b98:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  802b9c:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  802ba3:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802ba7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  802bab:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802baf:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  802bb3:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  802bb7:	48 b8 2d 2b 80 00 00 	movabs $0x802b2d,%rax
  802bbe:	00 00 00 
  802bc1:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  802bc3:	c9                   	leave
  802bc4:	c3                   	ret

0000000000802bc5 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802bc5:	f3 0f 1e fa          	endbr64
  802bc9:	55                   	push   %rbp
  802bca:	48 89 e5             	mov    %rsp,%rbp
  802bcd:	41 54                	push   %r12
  802bcf:	53                   	push   %rbx
  802bd0:	48 89 fb             	mov    %rdi,%rbx
  802bd3:	48 89 f7             	mov    %rsi,%rdi
  802bd6:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802bd9:	48 85 f6             	test   %rsi,%rsi
  802bdc:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802be3:	00 00 00 
  802be6:	48 0f 44 f8          	cmove  %rax,%rdi
    }
    int res = sys_ipc_recv(pg, PAGE_SIZE);
  802bea:	be 00 10 00 00       	mov    $0x1000,%esi
  802bef:	48 b8 5c 0b 80 00 00 	movabs $0x800b5c,%rax
  802bf6:	00 00 00 
  802bf9:	ff d0                	call   *%rax
    if (res < 0) {
  802bfb:	85 c0                	test   %eax,%eax
  802bfd:	78 45                	js     802c44 <ipc_recv+0x7f>
        if (perm_store != NULL) {
            *perm_store = 0;
        }
        return res;
    } else {
        if (from_env_store != NULL) {
  802bff:	48 85 db             	test   %rbx,%rbx
  802c02:	74 12                	je     802c16 <ipc_recv+0x51>
            *from_env_store = thisenv->env_ipc_from;
  802c04:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802c0b:	00 00 00 
  802c0e:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  802c14:	89 03                	mov    %eax,(%rbx)
        }
        if (perm_store != NULL) {
  802c16:	4d 85 e4             	test   %r12,%r12
  802c19:	74 14                	je     802c2f <ipc_recv+0x6a>
            *perm_store = thisenv->env_ipc_perm;
  802c1b:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802c22:	00 00 00 
  802c25:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  802c2b:	41 89 04 24          	mov    %eax,(%r12)
        }
        return thisenv->env_ipc_value;
  802c2f:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802c36:	00 00 00 
  802c39:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
    }
    return -1;
}
  802c3f:	5b                   	pop    %rbx
  802c40:	41 5c                	pop    %r12
  802c42:	5d                   	pop    %rbp
  802c43:	c3                   	ret
        if (from_env_store != NULL) {
  802c44:	48 85 db             	test   %rbx,%rbx
  802c47:	74 06                	je     802c4f <ipc_recv+0x8a>
            *from_env_store = 0;
  802c49:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store != NULL) {
  802c4f:	4d 85 e4             	test   %r12,%r12
  802c52:	74 eb                	je     802c3f <ipc_recv+0x7a>
            *perm_store = 0;
  802c54:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  802c5b:	00 
  802c5c:	eb e1                	jmp    802c3f <ipc_recv+0x7a>

0000000000802c5e <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  802c5e:	f3 0f 1e fa          	endbr64
  802c62:	55                   	push   %rbp
  802c63:	48 89 e5             	mov    %rsp,%rbp
  802c66:	41 57                	push   %r15
  802c68:	41 56                	push   %r14
  802c6a:	41 55                	push   %r13
  802c6c:	41 54                	push   %r12
  802c6e:	53                   	push   %rbx
  802c6f:	48 83 ec 18          	sub    $0x18,%rsp
  802c73:	89 7d c4             	mov    %edi,-0x3c(%rbp)
  802c76:	48 89 d3             	mov    %rdx,%rbx
  802c79:	49 89 cc             	mov    %rcx,%r12
  802c7c:	45 89 c5             	mov    %r8d,%r13d
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802c7f:	48 85 d2             	test   %rdx,%rdx
  802c82:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802c89:	00 00 00 
  802c8c:	48 0f 44 d8          	cmove  %rax,%rbx
    }
    int res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802c90:	89 f0                	mov    %esi,%eax
  802c92:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  802c96:	48 89 da             	mov    %rbx,%rdx
  802c99:	48 89 c6             	mov    %rax,%rsi
  802c9c:	48 b8 2c 0b 80 00 00 	movabs $0x800b2c,%rax
  802ca3:	00 00 00 
  802ca6:	ff d0                	call   *%rax
    while (res < 0) {
  802ca8:	85 c0                	test   %eax,%eax
  802caa:	79 65                	jns    802d11 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802cac:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802caf:	75 33                	jne    802ce4 <ipc_send+0x86>
            panic("Error: %i\n", res);
        }
        sys_yield();
  802cb1:	49 bf 9f 07 80 00 00 	movabs $0x80079f,%r15
  802cb8:	00 00 00 
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802cbb:	49 be 2c 0b 80 00 00 	movabs $0x800b2c,%r14
  802cc2:	00 00 00 
        sys_yield();
  802cc5:	41 ff d7             	call   *%r15
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802cc8:	45 89 e8             	mov    %r13d,%r8d
  802ccb:	4c 89 e1             	mov    %r12,%rcx
  802cce:	48 89 da             	mov    %rbx,%rdx
  802cd1:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  802cd5:	8b 7d c4             	mov    -0x3c(%rbp),%edi
  802cd8:	41 ff d6             	call   *%r14
    while (res < 0) {
  802cdb:	85 c0                	test   %eax,%eax
  802cdd:	79 32                	jns    802d11 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802cdf:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802ce2:	74 e1                	je     802cc5 <ipc_send+0x67>
            panic("Error: %i\n", res);
  802ce4:	89 c1                	mov    %eax,%ecx
  802ce6:	48 ba 45 32 80 00 00 	movabs $0x803245,%rdx
  802ced:	00 00 00 
  802cf0:	be 42 00 00 00       	mov    $0x42,%esi
  802cf5:	48 bf 50 32 80 00 00 	movabs $0x803250,%rdi
  802cfc:	00 00 00 
  802cff:	b8 00 00 00 00       	mov    $0x0,%eax
  802d04:	49 b8 65 21 80 00 00 	movabs $0x802165,%r8
  802d0b:	00 00 00 
  802d0e:	41 ff d0             	call   *%r8
    }
}
  802d11:	48 83 c4 18          	add    $0x18,%rsp
  802d15:	5b                   	pop    %rbx
  802d16:	41 5c                	pop    %r12
  802d18:	41 5d                	pop    %r13
  802d1a:	41 5e                	pop    %r14
  802d1c:	41 5f                	pop    %r15
  802d1e:	5d                   	pop    %rbp
  802d1f:	c3                   	ret

0000000000802d20 <ipc_find_env>:

/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
  802d20:	f3 0f 1e fa          	endbr64
    for (size_t i = 0; i < NENV; i++)
  802d24:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  802d29:	48 b9 00 00 a0 1f 80 	movabs $0x801fa00000,%rcx
  802d30:	00 00 00 
  802d33:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802d37:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802d3b:	48 c1 e2 04          	shl    $0x4,%rdx
  802d3f:	48 01 ca             	add    %rcx,%rdx
  802d42:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  802d48:	39 fa                	cmp    %edi,%edx
  802d4a:	74 12                	je     802d5e <ipc_find_env+0x3e>
    for (size_t i = 0; i < NENV; i++)
  802d4c:	48 83 c0 01          	add    $0x1,%rax
  802d50:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  802d56:	75 db                	jne    802d33 <ipc_find_env+0x13>
            return envs[i].env_id;
    return 0;
  802d58:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d5d:	c3                   	ret
            return envs[i].env_id;
  802d5e:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802d62:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802d66:	48 c1 e2 04          	shl    $0x4,%rdx
  802d6a:	48 b8 00 00 a0 1f 80 	movabs $0x801fa00000,%rax
  802d71:	00 00 00 
  802d74:	48 01 d0             	add    %rdx,%rax
  802d77:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802d7d:	c3                   	ret

0000000000802d7e <__text_end>:
  802d7e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d85:	00 00 00 
  802d88:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d8f:	00 00 00 
  802d92:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802d99:	00 00 00 
  802d9c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802da3:	00 00 00 
  802da6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dad:	00 00 00 
  802db0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802db7:	00 00 00 
  802dba:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dc1:	00 00 00 
  802dc4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dcb:	00 00 00 
  802dce:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dd5:	00 00 00 
  802dd8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ddf:	00 00 00 
  802de2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802de9:	00 00 00 
  802dec:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802df3:	00 00 00 
  802df6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802dfd:	00 00 00 
  802e00:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e07:	00 00 00 
  802e0a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e11:	00 00 00 
  802e14:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e1b:	00 00 00 
  802e1e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e25:	00 00 00 
  802e28:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e2f:	00 00 00 
  802e32:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e39:	00 00 00 
  802e3c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e43:	00 00 00 
  802e46:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e4d:	00 00 00 
  802e50:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e57:	00 00 00 
  802e5a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e61:	00 00 00 
  802e64:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e6b:	00 00 00 
  802e6e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e75:	00 00 00 
  802e78:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e7f:	00 00 00 
  802e82:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e89:	00 00 00 
  802e8c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e93:	00 00 00 
  802e96:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802e9d:	00 00 00 
  802ea0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ea7:	00 00 00 
  802eaa:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802eb1:	00 00 00 
  802eb4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ebb:	00 00 00 
  802ebe:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ec5:	00 00 00 
  802ec8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ecf:	00 00 00 
  802ed2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ed9:	00 00 00 
  802edc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ee3:	00 00 00 
  802ee6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802eed:	00 00 00 
  802ef0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ef7:	00 00 00 
  802efa:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f01:	00 00 00 
  802f04:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f0b:	00 00 00 
  802f0e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f15:	00 00 00 
  802f18:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f1f:	00 00 00 
  802f22:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f29:	00 00 00 
  802f2c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f33:	00 00 00 
  802f36:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f3d:	00 00 00 
  802f40:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f47:	00 00 00 
  802f4a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f51:	00 00 00 
  802f54:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f5b:	00 00 00 
  802f5e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f65:	00 00 00 
  802f68:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f6f:	00 00 00 
  802f72:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f79:	00 00 00 
  802f7c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f83:	00 00 00 
  802f86:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f8d:	00 00 00 
  802f90:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802f97:	00 00 00 
  802f9a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fa1:	00 00 00 
  802fa4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fab:	00 00 00 
  802fae:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fb5:	00 00 00 
  802fb8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fbf:	00 00 00 
  802fc2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fc9:	00 00 00 
  802fcc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fd3:	00 00 00 
  802fd6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fdd:	00 00 00 
  802fe0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802fe7:	00 00 00 
  802fea:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ff1:	00 00 00 
  802ff4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ffb:	00 00 00 
  802ffe:	66 90                	xchg   %ax,%ax
