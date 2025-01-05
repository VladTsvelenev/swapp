
obj/user/date:     file format elf64-x86-64


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
  80001e:	e8 63 03 00 00       	call   800386 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <umain>:
#include <inc/time.h>
#include <inc/stdio.h>
#include <inc/lib.h>

void
umain(int argc, char **argv) {
  800025:	f3 0f 1e fa          	endbr64
  800029:	55                   	push   %rbp
  80002a:	48 89 e5             	mov    %rsp,%rbp
  80002d:	53                   	push   %rbx
  80002e:	48 83 ec 58          	sub    $0x58,%rsp
    char time[20];
    int now = sys_gettime();
  800032:	48 b8 f1 17 80 00 00 	movabs $0x8017f1,%rax
  800039:	00 00 00 
  80003c:	ff d0                	call   *%rax
  80003e:	41 89 c0             	mov    %eax,%r8d

inline static void
mktime(int time, struct tm *tm) {
    // TODO Support negative timestamps

    int year = 1970 + (time / (DAY * 366 + 1));
  800041:	48 63 f0             	movslq %eax,%rsi
  800044:	48 69 f6 c1 40 fa 10 	imul   $0x10fa40c1,%rsi,%rsi
  80004b:	48 c1 fe 35          	sar    $0x35,%rsi
  80004f:	c1 f8 1f             	sar    $0x1f,%eax
  800052:	29 c6                	sub    %eax,%esi
  800054:	8d be b2 07 00 00    	lea    0x7b2(%rsi),%edi
    while (time >= DAY * (Y2DAYS(year + 1) - Y2DAYS(1970))) year++;
  80005a:	81 c6 b3 07 00 00    	add    $0x7b3,%esi
  800060:	69 f6 6d 01 00 00    	imul   $0x16d,%esi,%esi
  800066:	89 f9                	mov    %edi,%ecx
  800068:	83 c7 01             	add    $0x1,%edi
  80006b:	8d 41 03             	lea    0x3(%rcx),%eax
  80006e:	85 c9                	test   %ecx,%ecx
  800070:	0f 49 c1             	cmovns %ecx,%eax
  800073:	c1 f8 02             	sar    $0x2,%eax
  800076:	01 f0                	add    %esi,%eax
  800078:	48 63 d1             	movslq %ecx,%rdx
  80007b:	48 69 d2 1f 85 eb 51 	imul   $0x51eb851f,%rdx,%rdx
  800082:	48 89 d3             	mov    %rdx,%rbx
  800085:	48 c1 fb 25          	sar    $0x25,%rbx
  800089:	49 89 db             	mov    %rbx,%r11
  80008c:	41 89 c9             	mov    %ecx,%r9d
  80008f:	41 c1 f9 1f          	sar    $0x1f,%r9d
  800093:	45 89 ca             	mov    %r9d,%r10d
  800096:	41 29 da             	sub    %ebx,%r10d
  800099:	44 01 d0             	add    %r10d,%eax
  80009c:	48 c1 fa 27          	sar    $0x27,%rdx
  8000a0:	44 29 ca             	sub    %r9d,%edx
  8000a3:	8d 84 10 59 05 f5 ff 	lea    -0xafaa7(%rax,%rdx,1),%eax
  8000aa:	69 c0 80 51 01 00    	imul   $0x15180,%eax,%eax
  8000b0:	81 c6 6d 01 00 00    	add    $0x16d,%esi
  8000b6:	41 39 c0             	cmp    %eax,%r8d
  8000b9:	7d ab                	jge    800066 <umain+0x41>
    tm->tm_year = year - 1900;
    time -= DAY * (Y2DAYS(year) - Y2DAYS(1970));
  8000bb:	69 f1 6d 01 00 00    	imul   $0x16d,%ecx,%esi
  8000c1:	8d 41 02             	lea    0x2(%rcx),%eax
  8000c4:	89 ca                	mov    %ecx,%edx
  8000c6:	83 ea 01             	sub    $0x1,%edx
  8000c9:	0f 49 c2             	cmovns %edx,%eax
  8000cc:	c1 f8 02             	sar    $0x2,%eax
  8000cf:	01 c6                	add    %eax,%esi
  8000d1:	48 63 c2             	movslq %edx,%rax
  8000d4:	48 69 c0 1f 85 eb 51 	imul   $0x51eb851f,%rax,%rax
  8000db:	48 89 c3             	mov    %rax,%rbx
  8000de:	48 c1 fb 25          	sar    $0x25,%rbx
  8000e2:	c1 fa 1f             	sar    $0x1f,%edx
  8000e5:	89 d7                	mov    %edx,%edi
  8000e7:	29 df                	sub    %ebx,%edi
  8000e9:	01 fe                	add    %edi,%esi
  8000eb:	48 c1 f8 27          	sar    $0x27,%rax
  8000ef:	29 d0                	sub    %edx,%eax
  8000f1:	8d b4 06 59 05 f5 ff 	lea    -0xafaa7(%rsi,%rax,1),%esi
  8000f8:	69 f6 80 ae fe ff    	imul   $0xfffeae80,%esi,%esi
  8000fe:	44 01 c6             	add    %r8d,%esi

    int month = time / (DAY * 32);
    while (time >= DAY * (M2DAYS(month + 1, year))) month++;
  800101:	4c 63 c9             	movslq %ecx,%r9
  800104:	4d 69 c9 1f 85 eb 51 	imul   $0x51eb851f,%r9,%r9
  80010b:	4c 89 c8             	mov    %r9,%rax
  80010e:	48 c1 f8 27          	sar    $0x27,%rax
  800112:	49 89 c2             	mov    %rax,%r10
  800115:	89 c8                	mov    %ecx,%eax
  800117:	c1 f8 1f             	sar    $0x1f,%eax
  80011a:	41 29 c2             	sub    %eax,%r10d
  80011d:	41 69 d2 90 01 00 00 	imul   $0x190,%r10d,%edx
  800124:	41 89 ca             	mov    %ecx,%r10d
  800127:	41 29 d2             	sub    %edx,%r10d
  80012a:	4d 89 d9             	mov    %r11,%r9
  80012d:	41 29 c1             	sub    %eax,%r9d
  800130:	41 6b c1 64          	imul   $0x64,%r9d,%eax
  800134:	41 89 c9             	mov    %ecx,%r9d
  800137:	41 29 c1             	sub    %eax,%r9d
    int month = time / (DAY * 32);
  80013a:	48 63 d6             	movslq %esi,%rdx
  80013d:	48 69 d2 07 45 2e c2 	imul   $0xffffffffc22e4507,%rdx,%rdx
  800144:	48 c1 ea 20          	shr    $0x20,%rdx
  800148:	01 f2                	add    %esi,%edx
  80014a:	c1 fa 15             	sar    $0x15,%edx
  80014d:	89 f0                	mov    %esi,%eax
  80014f:	c1 f8 1f             	sar    $0x1f,%eax
  800152:	29 c2                	sub    %eax,%edx
  800154:	48 63 d2             	movslq %edx,%rdx
    while (time >= DAY * (M2DAYS(month + 1, year))) month++;
  800157:	41 89 cb             	mov    %ecx,%r11d
  80015a:	41 83 e3 03          	and    $0x3,%r11d
  80015e:	44 89 cb             	mov    %r9d,%ebx
  800161:	eb 21                	jmp    800184 <umain+0x15f>
  800163:	85 d2                	test   %edx,%edx
  800165:	40 0f 9f c7          	setg   %dil
  800169:	40 0f b6 ff          	movzbl %dil,%edi
  80016d:	4c 8d 42 01          	lea    0x1(%rdx),%r8
  800171:	01 f8                	add    %edi,%eax
  800173:	69 c0 80 51 01 00    	imul   $0x15180,%eax,%eax
  800179:	39 c6                	cmp    %eax,%esi
  80017b:	0f 8c 89 00 00 00    	jl     80020a <umain+0x1e5>
  800181:	4c 89 c2             	mov    %r8,%rdx
  800184:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%rbp)
  80018b:	c7 45 ac 1f 00 00 00 	movl   $0x1f,-0x54(%rbp)
  800192:	c7 45 b0 3b 00 00 00 	movl   $0x3b,-0x50(%rbp)
  800199:	c7 45 b4 5a 00 00 00 	movl   $0x5a,-0x4c(%rbp)
  8001a0:	c7 45 b8 78 00 00 00 	movl   $0x78,-0x48(%rbp)
  8001a7:	c7 45 bc 97 00 00 00 	movl   $0x97,-0x44(%rbp)
  8001ae:	c7 45 c0 b5 00 00 00 	movl   $0xb5,-0x40(%rbp)
  8001b5:	c7 45 c4 d4 00 00 00 	movl   $0xd4,-0x3c(%rbp)
  8001bc:	c7 45 c8 f3 00 00 00 	movl   $0xf3,-0x38(%rbp)
  8001c3:	c7 45 cc 11 01 00 00 	movl   $0x111,-0x34(%rbp)
  8001ca:	c7 45 d0 30 01 00 00 	movl   $0x130,-0x30(%rbp)
  8001d1:	c7 45 d4 4e 01 00 00 	movl   $0x14e,-0x2c(%rbp)
  8001d8:	c7 45 d8 6d 01 00 00 	movl   $0x16d,-0x28(%rbp)
  8001df:	8b 44 95 ac          	mov    -0x54(%rbp,%rdx,4),%eax
  8001e3:	45 85 d2             	test   %r10d,%r10d
  8001e6:	0f 84 77 ff ff ff    	je     800163 <umain+0x13e>
  8001ec:	bf 00 00 00 00       	mov    $0x0,%edi
  8001f1:	45 85 db             	test   %r11d,%r11d
  8001f4:	0f 85 73 ff ff ff    	jne    80016d <umain+0x148>
  8001fa:	89 df                	mov    %ebx,%edi
  8001fc:	45 85 c9             	test   %r9d,%r9d
  8001ff:	0f 84 68 ff ff ff    	je     80016d <umain+0x148>
  800205:	e9 59 ff ff ff       	jmp    800163 <umain+0x13e>
  80020a:	89 d7                	mov    %edx,%edi
    tm->tm_mon = month;
    time -= DAY * M2DAYS(month, year);
  80020c:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%rbp)
  800213:	c7 45 ac 1f 00 00 00 	movl   $0x1f,-0x54(%rbp)
  80021a:	c7 45 b0 3b 00 00 00 	movl   $0x3b,-0x50(%rbp)
  800221:	c7 45 b4 5a 00 00 00 	movl   $0x5a,-0x4c(%rbp)
  800228:	c7 45 b8 78 00 00 00 	movl   $0x78,-0x48(%rbp)
  80022f:	c7 45 bc 97 00 00 00 	movl   $0x97,-0x44(%rbp)
  800236:	c7 45 c0 b5 00 00 00 	movl   $0xb5,-0x40(%rbp)
  80023d:	c7 45 c4 d4 00 00 00 	movl   $0xd4,-0x3c(%rbp)
  800244:	c7 45 c8 f3 00 00 00 	movl   $0xf3,-0x38(%rbp)
  80024b:	c7 45 cc 11 01 00 00 	movl   $0x111,-0x34(%rbp)
  800252:	c7 45 d0 30 01 00 00 	movl   $0x130,-0x30(%rbp)
  800259:	c7 45 d4 4e 01 00 00 	movl   $0x14e,-0x2c(%rbp)
  800260:	c7 45 d8 6d 01 00 00 	movl   $0x16d,-0x28(%rbp)
  800267:	48 63 c2             	movslq %edx,%rax
  80026a:	8b 44 85 a8          	mov    -0x58(%rbp,%rax,4),%eax
  80026e:	45 85 d2             	test   %r10d,%r10d
  800271:	74 0e                	je     800281 <umain+0x25c>
  800273:	f6 c1 03             	test   $0x3,%cl
  800276:	0f 85 ff 00 00 00    	jne    80037b <umain+0x356>
  80027c:	45 85 c9             	test   %r9d,%r9d
  80027f:	74 0b                	je     80028c <umain+0x267>
  800281:	83 ff 01             	cmp    $0x1,%edi
  800284:	41 0f 9f c1          	setg   %r9b
  800288:	45 0f b6 c9          	movzbl %r9b,%r9d
  80028c:	44 01 c8             	add    %r9d,%eax
  80028f:	69 c0 80 51 01 00    	imul   $0x15180,%eax,%eax
  800295:	29 c6                	sub    %eax,%esi

    tm->tm_mday = time / DAY + 1;
    time %= DAY;
  800297:	48 63 c6             	movslq %esi,%rax
  80029a:	48 69 c0 07 45 2e c2 	imul   $0xffffffffc22e4507,%rax,%rax
  8002a1:	48 c1 e8 20          	shr    $0x20,%rax
  8002a5:	01 f0                	add    %esi,%eax
  8002a7:	c1 f8 10             	sar    $0x10,%eax
  8002aa:	41 89 f3             	mov    %esi,%r11d
  8002ad:	41 c1 fb 1f          	sar    $0x1f,%r11d
  8002b1:	41 89 c2             	mov    %eax,%r10d
  8002b4:	45 29 da             	sub    %r11d,%r10d
  8002b7:	41 69 fa 80 51 01 00 	imul   $0x15180,%r10d,%edi
  8002be:	29 fe                	sub    %edi,%esi
  8002c0:	41 89 f2             	mov    %esi,%r10d
    tm->tm_hour = time / HOUR;
    time %= HOUR;
  8002c3:	48 63 f6             	movslq %esi,%rsi
  8002c6:	48 69 f6 c5 b3 a2 91 	imul   $0xffffffff91a2b3c5,%rsi,%rsi
  8002cd:	48 c1 ee 20          	shr    $0x20,%rsi
  8002d1:	44 01 d6             	add    %r10d,%esi
  8002d4:	c1 fe 0b             	sar    $0xb,%esi
  8002d7:	41 89 f0             	mov    %esi,%r8d
  8002da:	45 89 d1             	mov    %r10d,%r9d
  8002dd:	41 c1 f9 1f          	sar    $0x1f,%r9d
  8002e1:	89 f7                	mov    %esi,%edi
  8002e3:	44 29 cf             	sub    %r9d,%edi
  8002e6:	69 f7 10 0e 00 00    	imul   $0xe10,%edi,%esi
  8002ec:	44 89 d7             	mov    %r10d,%edi
  8002ef:	29 f7                	sub    %esi,%edi
    tm->tm_mday = time / DAY + 1;
  8002f1:	44 29 d8             	sub    %r11d,%eax
  8002f4:	89 c6                	mov    %eax,%esi
}

inline static void
snprint_datetime(char *buf, int size, struct tm *tm) {
    assert(size >= 10 + 1 + 8 + 1);
    snprintf(buf, size, "%04d-%02d-%02d %02d:%02d:%02d",
  8002f6:	48 83 ec 08          	sub    $0x8,%rsp
    time %= MINUTE;
  8002fa:	48 63 c7             	movslq %edi,%rax
  8002fd:	48 69 c0 89 88 88 88 	imul   $0xffffffff88888889,%rax,%rax
  800304:	48 c1 e8 20          	shr    $0x20,%rax
  800308:	01 f8                	add    %edi,%eax
  80030a:	c1 f8 05             	sar    $0x5,%eax
  80030d:	41 89 fa             	mov    %edi,%r10d
  800310:	41 c1 fa 1f          	sar    $0x1f,%r10d
  800314:	44 29 d0             	sub    %r10d,%eax
  800317:	44 6b d0 3c          	imul   $0x3c,%eax,%r10d
  80031b:	44 29 d7             	sub    %r10d,%edi
    snprintf(buf, size, "%04d-%02d-%02d %02d:%02d:%02d",
  80031e:	57                   	push   %rdi
  80031f:	50                   	push   %rax
    tm->tm_hour = time / HOUR;
  800320:	45 29 c8             	sub    %r9d,%r8d
    snprintf(buf, size, "%04d-%02d-%02d %02d:%02d:%02d",
  800323:	41 50                	push   %r8
  800325:	44 8d 4e 01          	lea    0x1(%rsi),%r9d
  800329:	44 8d 42 01          	lea    0x1(%rdx),%r8d
  80032d:	48 ba 00 30 80 00 00 	movabs $0x803000,%rdx
  800334:	00 00 00 
  800337:	be 14 00 00 00       	mov    $0x14,%esi
  80033c:	48 8d 7d dc          	lea    -0x24(%rbp),%rdi
  800340:	b8 00 00 00 00       	mov    $0x0,%eax
  800345:	49 ba d7 0d 80 00 00 	movabs $0x800dd7,%r10
  80034c:	00 00 00 
  80034f:	41 ff d2             	call   *%r10
    struct tm tnow;

    mktime(now, &tnow);

    snprint_datetime(time, 20, &tnow);
    cprintf("DATE: %s\n", time);
  800352:	48 83 c4 20          	add    $0x20,%rsp
  800356:	48 8d 75 dc          	lea    -0x24(%rbp),%rsi
  80035a:	48 bf 1e 30 80 00 00 	movabs $0x80301e,%rdi
  800361:	00 00 00 
  800364:	b8 00 00 00 00       	mov    $0x0,%eax
  800369:	48 ba 14 05 80 00 00 	movabs $0x800514,%rdx
  800370:	00 00 00 
  800373:	ff d2                	call   *%rdx
}
  800375:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800379:	c9                   	leave
  80037a:	c3                   	ret
    time -= DAY * M2DAYS(month, year);
  80037b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800381:	e9 06 ff ff ff       	jmp    80028c <umain+0x267>

0000000000800386 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  800386:	f3 0f 1e fa          	endbr64
  80038a:	55                   	push   %rbp
  80038b:	48 89 e5             	mov    %rsp,%rbp
  80038e:	41 56                	push   %r14
  800390:	41 55                	push   %r13
  800392:	41 54                	push   %r12
  800394:	53                   	push   %rbx
  800395:	41 89 fd             	mov    %edi,%r13d
  800398:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
     * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  80039b:	48 ba d8 40 80 00 00 	movabs $0x8040d8,%rdx
  8003a2:	00 00 00 
  8003a5:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  8003ac:	00 00 00 
  8003af:	48 39 c2             	cmp    %rax,%rdx
  8003b2:	73 17                	jae    8003cb <libmain+0x45>
    void (**ctor)() = &__ctors_start;
  8003b4:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  8003b7:	49 89 c4             	mov    %rax,%r12
  8003ba:	48 83 c3 08          	add    $0x8,%rbx
  8003be:	b8 00 00 00 00       	mov    $0x0,%eax
  8003c3:	ff 53 f8             	call   *-0x8(%rbx)
  8003c6:	4c 39 e3             	cmp    %r12,%rbx
  8003c9:	72 ef                	jb     8003ba <libmain+0x34>

    /* Set thisenv to point at our Env structure in envs[]. */

    // LAB 8: Your code here
    thisenv = &((struct Env *)UENVS)[ENVX(sys_getenvid())];
  8003cb:	48 b8 92 13 80 00 00 	movabs $0x801392,%rax
  8003d2:	00 00 00 
  8003d5:	ff d0                	call   *%rax
  8003d7:	25 ff 03 00 00       	and    $0x3ff,%eax
  8003dc:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8003e0:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  8003e4:	48 c1 e0 04          	shl    $0x4,%rax
  8003e8:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  8003ef:	00 00 00 
  8003f2:	48 01 d0             	add    %rdx,%rax
  8003f5:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  8003fc:	00 00 00 

    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  8003ff:	45 85 ed             	test   %r13d,%r13d
  800402:	7e 0d                	jle    800411 <libmain+0x8b>
  800404:	49 8b 06             	mov    (%r14),%rax
  800407:	48 a3 00 40 80 00 00 	movabs %rax,0x804000
  80040e:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  800411:	4c 89 f6             	mov    %r14,%rsi
  800414:	44 89 ef             	mov    %r13d,%edi
  800417:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  80041e:	00 00 00 
  800421:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  800423:	48 b8 38 04 80 00 00 	movabs $0x800438,%rax
  80042a:	00 00 00 
  80042d:	ff d0                	call   *%rax
#endif
}
  80042f:	5b                   	pop    %rbx
  800430:	41 5c                	pop    %r12
  800432:	41 5d                	pop    %r13
  800434:	41 5e                	pop    %r14
  800436:	5d                   	pop    %rbp
  800437:	c3                   	ret

0000000000800438 <exit>:

#include <inc/lib.h>

void
exit(void) {
  800438:	f3 0f 1e fa          	endbr64
  80043c:	55                   	push   %rbp
  80043d:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  800440:	48 b8 68 1a 80 00 00 	movabs $0x801a68,%rax
  800447:	00 00 00 
  80044a:	ff d0                	call   *%rax
    sys_env_destroy(0);
  80044c:	bf 00 00 00 00       	mov    $0x0,%edi
  800451:	48 b8 23 13 80 00 00 	movabs $0x801323,%rax
  800458:	00 00 00 
  80045b:	ff d0                	call   *%rax
}
  80045d:	5d                   	pop    %rbp
  80045e:	c3                   	ret

000000000080045f <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  80045f:	f3 0f 1e fa          	endbr64
  800463:	55                   	push   %rbp
  800464:	48 89 e5             	mov    %rsp,%rbp
  800467:	53                   	push   %rbx
  800468:	48 83 ec 08          	sub    $0x8,%rsp
  80046c:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  80046f:	8b 06                	mov    (%rsi),%eax
  800471:	8d 50 01             	lea    0x1(%rax),%edx
  800474:	89 16                	mov    %edx,(%rsi)
  800476:	48 98                	cltq
  800478:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  80047d:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  800483:	74 0a                	je     80048f <putch+0x30>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  800485:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  800489:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80048d:	c9                   	leave
  80048e:	c3                   	ret
        sys_cputs(state->buf, state->offset);
  80048f:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  800493:	be ff 00 00 00       	mov    $0xff,%esi
  800498:	48 b8 bd 12 80 00 00 	movabs $0x8012bd,%rax
  80049f:	00 00 00 
  8004a2:	ff d0                	call   *%rax
        state->offset = 0;
  8004a4:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  8004aa:	eb d9                	jmp    800485 <putch+0x26>

00000000008004ac <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  8004ac:	f3 0f 1e fa          	endbr64
  8004b0:	55                   	push   %rbp
  8004b1:	48 89 e5             	mov    %rsp,%rbp
  8004b4:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8004bb:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  8004be:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  8004c5:	b9 21 00 00 00       	mov    $0x21,%ecx
  8004ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8004cf:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  8004d2:	48 89 f1             	mov    %rsi,%rcx
  8004d5:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  8004dc:	48 bf 5f 04 80 00 00 	movabs $0x80045f,%rdi
  8004e3:	00 00 00 
  8004e6:	48 b8 74 06 80 00 00 	movabs $0x800674,%rax
  8004ed:	00 00 00 
  8004f0:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  8004f2:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  8004f9:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  800500:	48 b8 bd 12 80 00 00 	movabs $0x8012bd,%rax
  800507:	00 00 00 
  80050a:	ff d0                	call   *%rax

    return state.count;
}
  80050c:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  800512:	c9                   	leave
  800513:	c3                   	ret

0000000000800514 <cprintf>:

int
cprintf(const char *fmt, ...) {
  800514:	f3 0f 1e fa          	endbr64
  800518:	55                   	push   %rbp
  800519:	48 89 e5             	mov    %rsp,%rbp
  80051c:	48 83 ec 50          	sub    $0x50,%rsp
  800520:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  800524:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  800528:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80052c:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800530:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  800534:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  80053b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80053f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800543:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800547:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  80054b:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  80054f:	48 b8 ac 04 80 00 00 	movabs $0x8004ac,%rax
  800556:	00 00 00 
  800559:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  80055b:	c9                   	leave
  80055c:	c3                   	ret

000000000080055d <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  80055d:	f3 0f 1e fa          	endbr64
  800561:	55                   	push   %rbp
  800562:	48 89 e5             	mov    %rsp,%rbp
  800565:	41 57                	push   %r15
  800567:	41 56                	push   %r14
  800569:	41 55                	push   %r13
  80056b:	41 54                	push   %r12
  80056d:	53                   	push   %rbx
  80056e:	48 83 ec 18          	sub    $0x18,%rsp
  800572:	49 89 fc             	mov    %rdi,%r12
  800575:	49 89 f5             	mov    %rsi,%r13
  800578:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  80057c:	8b 45 10             	mov    0x10(%rbp),%eax
  80057f:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  800582:	41 89 cf             	mov    %ecx,%r15d
  800585:	4c 39 fa             	cmp    %r15,%rdx
  800588:	73 5b                	jae    8005e5 <print_num+0x88>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  80058a:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  80058e:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  800592:	85 db                	test   %ebx,%ebx
  800594:	7e 0e                	jle    8005a4 <print_num+0x47>
            putch(padc, put_arg);
  800596:	4c 89 ee             	mov    %r13,%rsi
  800599:	44 89 f7             	mov    %r14d,%edi
  80059c:	41 ff d4             	call   *%r12
        while (--width > 0) {
  80059f:	83 eb 01             	sub    $0x1,%ebx
  8005a2:	75 f2                	jne    800596 <print_num+0x39>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  8005a4:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  8005a8:	48 b9 43 30 80 00 00 	movabs $0x803043,%rcx
  8005af:	00 00 00 
  8005b2:	48 b8 32 30 80 00 00 	movabs $0x803032,%rax
  8005b9:	00 00 00 
  8005bc:	48 0f 45 c8          	cmovne %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  8005c0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8005c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c9:	49 f7 f7             	div    %r15
  8005cc:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  8005d0:	4c 89 ee             	mov    %r13,%rsi
  8005d3:	41 ff d4             	call   *%r12
}
  8005d6:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  8005da:	5b                   	pop    %rbx
  8005db:	41 5c                	pop    %r12
  8005dd:	41 5d                	pop    %r13
  8005df:	41 5e                	pop    %r14
  8005e1:	41 5f                	pop    %r15
  8005e3:	5d                   	pop    %rbp
  8005e4:	c3                   	ret
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  8005e5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8005e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ee:	49 f7 f7             	div    %r15
  8005f1:	48 83 ec 08          	sub    $0x8,%rsp
  8005f5:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  8005f9:	52                   	push   %rdx
  8005fa:	45 0f be c9          	movsbl %r9b,%r9d
  8005fe:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  800602:	48 89 c2             	mov    %rax,%rdx
  800605:	48 b8 5d 05 80 00 00 	movabs $0x80055d,%rax
  80060c:	00 00 00 
  80060f:	ff d0                	call   *%rax
  800611:	48 83 c4 10          	add    $0x10,%rsp
  800615:	eb 8d                	jmp    8005a4 <print_num+0x47>

0000000000800617 <sprintputch>:
    char *end;
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
  800617:	f3 0f 1e fa          	endbr64
    state->count++;
  80061b:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  80061f:	48 8b 06             	mov    (%rsi),%rax
  800622:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  800626:	73 0a                	jae    800632 <sprintputch+0x1b>
        *state->start++ = ch;
  800628:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80062c:	48 89 16             	mov    %rdx,(%rsi)
  80062f:	40 88 38             	mov    %dil,(%rax)
    }
}
  800632:	c3                   	ret

0000000000800633 <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  800633:	f3 0f 1e fa          	endbr64
  800637:	55                   	push   %rbp
  800638:	48 89 e5             	mov    %rsp,%rbp
  80063b:	48 83 ec 50          	sub    $0x50,%rsp
  80063f:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800643:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800647:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  80064b:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800652:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800656:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80065a:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80065e:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  800662:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800666:	48 b8 74 06 80 00 00 	movabs $0x800674,%rax
  80066d:	00 00 00 
  800670:	ff d0                	call   *%rax
}
  800672:	c9                   	leave
  800673:	c3                   	ret

0000000000800674 <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  800674:	f3 0f 1e fa          	endbr64
  800678:	55                   	push   %rbp
  800679:	48 89 e5             	mov    %rsp,%rbp
  80067c:	41 57                	push   %r15
  80067e:	41 56                	push   %r14
  800680:	41 55                	push   %r13
  800682:	41 54                	push   %r12
  800684:	53                   	push   %rbx
  800685:	48 83 ec 38          	sub    $0x38,%rsp
  800689:	49 89 fe             	mov    %rdi,%r14
  80068c:	49 89 f5             	mov    %rsi,%r13
  80068f:	48 89 d3             	mov    %rdx,%rbx
    va_copy(aq, ap);
  800692:	48 8b 01             	mov    (%rcx),%rax
  800695:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  800699:	48 8b 41 08          	mov    0x8(%rcx),%rax
  80069d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8006a1:	48 8b 41 10          	mov    0x10(%rcx),%rax
  8006a5:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  8006a9:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  8006ad:	0f b6 3b             	movzbl (%rbx),%edi
  8006b0:	40 80 ff 25          	cmp    $0x25,%dil
  8006b4:	74 18                	je     8006ce <vprintfmt+0x5a>
            if (!ch) return;
  8006b6:	40 84 ff             	test   %dil,%dil
  8006b9:	0f 84 b2 06 00 00    	je     800d71 <vprintfmt+0x6fd>
            putch(ch, put_arg);
  8006bf:	40 0f b6 ff          	movzbl %dil,%edi
  8006c3:	4c 89 ee             	mov    %r13,%rsi
  8006c6:	41 ff d6             	call   *%r14
        while ((ch = *ufmt++) != '%') {
  8006c9:	4c 89 e3             	mov    %r12,%rbx
  8006cc:	eb db                	jmp    8006a9 <vprintfmt+0x35>
        bool altflag = 0, zflag = 0;
  8006ce:	be 00 00 00 00       	mov    $0x0,%esi
  8006d3:	c6 45 ab 00          	movb   $0x0,-0x55(%rbp)
        unsigned lflag = 0, base = 10;
  8006d7:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  8006dc:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  8006e2:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  8006e9:	c6 45 aa 20          	movb   $0x20,-0x56(%rbp)
        switch (ch = *ufmt++) {
  8006ed:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  8006f2:	41 0f b6 04 24       	movzbl (%r12),%eax
  8006f7:	88 45 a0             	mov    %al,-0x60(%rbp)
  8006fa:	83 e8 23             	sub    $0x23,%eax
  8006fd:	3c 57                	cmp    $0x57,%al
  8006ff:	0f 87 52 06 00 00    	ja     800d57 <vprintfmt+0x6e3>
  800705:	0f b6 c0             	movzbl %al,%eax
  800708:	48 b9 80 32 80 00 00 	movabs $0x803280,%rcx
  80070f:	00 00 00 
  800712:	3e ff 24 c1          	notrack jmp *(%rcx,%rax,8)
  800716:	49 89 dc             	mov    %rbx,%r12
            altflag = 1;
  800719:	c6 45 ab 01          	movb   $0x1,-0x55(%rbp)
  80071d:	eb ce                	jmp    8006ed <vprintfmt+0x79>
        switch (ch = *ufmt++) {
  80071f:	49 89 dc             	mov    %rbx,%r12
  800722:	be 01 00 00 00       	mov    $0x1,%esi
  800727:	eb c4                	jmp    8006ed <vprintfmt+0x79>
            padc = ch;
  800729:	0f b6 45 a0          	movzbl -0x60(%rbp),%eax
  80072d:	88 45 aa             	mov    %al,-0x56(%rbp)
        switch (ch = *ufmt++) {
  800730:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  800733:	eb b8                	jmp    8006ed <vprintfmt+0x79>
            precision = va_arg(aq, int);
  800735:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800738:	83 f8 2f             	cmp    $0x2f,%eax
  80073b:	77 24                	ja     800761 <vprintfmt+0xed>
  80073d:	89 c1                	mov    %eax,%ecx
  80073f:	48 03 4d c8          	add    -0x38(%rbp),%rcx
  800743:	83 c0 08             	add    $0x8,%eax
  800746:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800749:	44 8b 39             	mov    (%rcx),%r15d
        switch (ch = *ufmt++) {
  80074c:	49 89 dc             	mov    %rbx,%r12
            if (width < 0) {
  80074f:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  800753:	79 98                	jns    8006ed <vprintfmt+0x79>
                width = precision;
  800755:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
                precision = -1;
  800759:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  80075f:	eb 8c                	jmp    8006ed <vprintfmt+0x79>
            precision = va_arg(aq, int);
  800761:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  800765:	48 8d 41 08          	lea    0x8(%rcx),%rax
  800769:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80076d:	eb da                	jmp    800749 <vprintfmt+0xd5>
                precision = precision * 10 + ch - '0';
  80076f:	44 0f b6 7d a0       	movzbl -0x60(%rbp),%r15d
  800774:	41 83 ef 30          	sub    $0x30,%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  800778:	41 0f b6 44 24 01    	movzbl 0x1(%r12),%eax
  80077e:	3c 39                	cmp    $0x39,%al
  800780:	77 1c                	ja     80079e <vprintfmt+0x12a>
            for (precision = 0;; ++ufmt) {
  800782:	48 83 c3 01          	add    $0x1,%rbx
                precision = precision * 10 + ch - '0';
  800786:	43 8d 0c bf          	lea    (%r15,%r15,4),%ecx
  80078a:	0f b6 c0             	movzbl %al,%eax
  80078d:	44 8d 7c 48 d0       	lea    -0x30(%rax,%rcx,2),%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  800792:	0f b6 03             	movzbl (%rbx),%eax
  800795:	3c 39                	cmp    $0x39,%al
  800797:	76 e9                	jbe    800782 <vprintfmt+0x10e>
        process_precision:
  800799:	49 89 dc             	mov    %rbx,%r12
  80079c:	eb b1                	jmp    80074f <vprintfmt+0xdb>
        switch (ch = *ufmt++) {
  80079e:	49 89 dc             	mov    %rbx,%r12
  8007a1:	eb ac                	jmp    80074f <vprintfmt+0xdb>
            width = MAX(0, width);
  8007a3:	8b 4d ac             	mov    -0x54(%rbp),%ecx
  8007a6:	85 c9                	test   %ecx,%ecx
  8007a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8007ad:	0f 49 c1             	cmovns %ecx,%eax
  8007b0:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  8007b3:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  8007b6:	e9 32 ff ff ff       	jmp    8006ed <vprintfmt+0x79>
            lflag++;
  8007bb:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  8007be:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  8007c1:	e9 27 ff ff ff       	jmp    8006ed <vprintfmt+0x79>
            putch(va_arg(aq, int), put_arg);
  8007c6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007c9:	83 f8 2f             	cmp    $0x2f,%eax
  8007cc:	77 19                	ja     8007e7 <vprintfmt+0x173>
  8007ce:	89 c2                	mov    %eax,%edx
  8007d0:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8007d4:	83 c0 08             	add    $0x8,%eax
  8007d7:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8007da:	8b 3a                	mov    (%rdx),%edi
  8007dc:	4c 89 ee             	mov    %r13,%rsi
  8007df:	41 ff d6             	call   *%r14
            break;
  8007e2:	e9 c2 fe ff ff       	jmp    8006a9 <vprintfmt+0x35>
            putch(va_arg(aq, int), put_arg);
  8007e7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007eb:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8007ef:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8007f3:	eb e5                	jmp    8007da <vprintfmt+0x166>
            int err = va_arg(aq, int);
  8007f5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007f8:	83 f8 2f             	cmp    $0x2f,%eax
  8007fb:	77 5a                	ja     800857 <vprintfmt+0x1e3>
  8007fd:	89 c2                	mov    %eax,%edx
  8007ff:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800803:	83 c0 08             	add    $0x8,%eax
  800806:	89 45 b8             	mov    %eax,-0x48(%rbp)
            if (err < 0) err = -err;
  800809:	8b 02                	mov    (%rdx),%eax
  80080b:	89 c1                	mov    %eax,%ecx
  80080d:	f7 d9                	neg    %ecx
  80080f:	0f 48 c8             	cmovs  %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  800812:	83 f9 13             	cmp    $0x13,%ecx
  800815:	7f 4e                	jg     800865 <vprintfmt+0x1f1>
  800817:	48 63 c1             	movslq %ecx,%rax
  80081a:	48 ba 40 35 80 00 00 	movabs $0x803540,%rdx
  800821:	00 00 00 
  800824:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  800828:	48 85 c0             	test   %rax,%rax
  80082b:	74 38                	je     800865 <vprintfmt+0x1f1>
                printfmt(putch, put_arg, "%s", strerr);
  80082d:	48 89 c1             	mov    %rax,%rcx
  800830:	48 ba 37 32 80 00 00 	movabs $0x803237,%rdx
  800837:	00 00 00 
  80083a:	4c 89 ee             	mov    %r13,%rsi
  80083d:	4c 89 f7             	mov    %r14,%rdi
  800840:	b8 00 00 00 00       	mov    $0x0,%eax
  800845:	49 b8 33 06 80 00 00 	movabs $0x800633,%r8
  80084c:	00 00 00 
  80084f:	41 ff d0             	call   *%r8
  800852:	e9 52 fe ff ff       	jmp    8006a9 <vprintfmt+0x35>
            int err = va_arg(aq, int);
  800857:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80085b:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80085f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800863:	eb a4                	jmp    800809 <vprintfmt+0x195>
                printfmt(putch, put_arg, "error %d", err);
  800865:	48 ba 5b 30 80 00 00 	movabs $0x80305b,%rdx
  80086c:	00 00 00 
  80086f:	4c 89 ee             	mov    %r13,%rsi
  800872:	4c 89 f7             	mov    %r14,%rdi
  800875:	b8 00 00 00 00       	mov    $0x0,%eax
  80087a:	49 b8 33 06 80 00 00 	movabs $0x800633,%r8
  800881:	00 00 00 
  800884:	41 ff d0             	call   *%r8
  800887:	e9 1d fe ff ff       	jmp    8006a9 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  80088c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80088f:	83 f8 2f             	cmp    $0x2f,%eax
  800892:	77 6c                	ja     800900 <vprintfmt+0x28c>
  800894:	89 c2                	mov    %eax,%edx
  800896:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80089a:	83 c0 08             	add    $0x8,%eax
  80089d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8008a0:	48 8b 12             	mov    (%rdx),%rdx
            if (!ptr) ptr = "(null)";
  8008a3:	48 85 d2             	test   %rdx,%rdx
  8008a6:	48 b8 54 30 80 00 00 	movabs $0x803054,%rax
  8008ad:	00 00 00 
  8008b0:	48 0f 45 c2          	cmovne %rdx,%rax
  8008b4:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
            if (width > 0 && padc != '-') {
  8008b8:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8008bc:	7e 06                	jle    8008c4 <vprintfmt+0x250>
  8008be:	80 7d aa 2d          	cmpb   $0x2d,-0x56(%rbp)
  8008c2:	75 4a                	jne    80090e <vprintfmt+0x29a>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  8008c4:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8008c8:	4c 8d 60 01          	lea    0x1(%rax),%r12
  8008cc:	0f b6 00             	movzbl (%rax),%eax
  8008cf:	84 c0                	test   %al,%al
  8008d1:	0f 85 9a 00 00 00    	jne    800971 <vprintfmt+0x2fd>
            while (width-- > 0) putch(' ', put_arg);
  8008d7:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8008da:	44 8d 60 ff          	lea    -0x1(%rax),%r12d
  8008de:	85 c0                	test   %eax,%eax
  8008e0:	0f 8e c3 fd ff ff    	jle    8006a9 <vprintfmt+0x35>
  8008e6:	4c 89 ee             	mov    %r13,%rsi
  8008e9:	bf 20 00 00 00       	mov    $0x20,%edi
  8008ee:	41 ff d6             	call   *%r14
  8008f1:	41 83 ec 01          	sub    $0x1,%r12d
  8008f5:	41 83 fc ff          	cmp    $0xffffffff,%r12d
  8008f9:	75 eb                	jne    8008e6 <vprintfmt+0x272>
  8008fb:	e9 a9 fd ff ff       	jmp    8006a9 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  800900:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800904:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800908:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80090c:	eb 92                	jmp    8008a0 <vprintfmt+0x22c>
                width -= strnlen(ptr, precision);
  80090e:	49 63 f7             	movslq %r15d,%rsi
  800911:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  800915:	48 b8 37 0e 80 00 00 	movabs $0x800e37,%rax
  80091c:	00 00 00 
  80091f:	ff d0                	call   *%rax
  800921:	48 89 c2             	mov    %rax,%rdx
  800924:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800927:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  800929:	8d 70 ff             	lea    -0x1(%rax),%esi
  80092c:	89 75 ac             	mov    %esi,-0x54(%rbp)
  80092f:	85 c0                	test   %eax,%eax
  800931:	7e 91                	jle    8008c4 <vprintfmt+0x250>
  800933:	44 0f be 65 aa       	movsbl -0x56(%rbp),%r12d
  800938:	4c 89 ee             	mov    %r13,%rsi
  80093b:	44 89 e7             	mov    %r12d,%edi
  80093e:	41 ff d6             	call   *%r14
  800941:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  800945:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800948:	83 f8 ff             	cmp    $0xffffffff,%eax
  80094b:	75 eb                	jne    800938 <vprintfmt+0x2c4>
  80094d:	e9 72 ff ff ff       	jmp    8008c4 <vprintfmt+0x250>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800952:	0f b6 f8             	movzbl %al,%edi
  800955:	4c 89 ee             	mov    %r13,%rsi
  800958:	41 ff d6             	call   *%r14
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  80095b:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  80095f:	49 83 c4 01          	add    $0x1,%r12
  800963:	41 0f b6 44 24 ff    	movzbl -0x1(%r12),%eax
  800969:	84 c0                	test   %al,%al
  80096b:	0f 84 66 ff ff ff    	je     8008d7 <vprintfmt+0x263>
  800971:	45 85 ff             	test   %r15d,%r15d
  800974:	78 0a                	js     800980 <vprintfmt+0x30c>
  800976:	41 83 ef 01          	sub    $0x1,%r15d
  80097a:	0f 88 57 ff ff ff    	js     8008d7 <vprintfmt+0x263>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  800980:	80 7d ab 00          	cmpb   $0x0,-0x55(%rbp)
  800984:	74 cc                	je     800952 <vprintfmt+0x2de>
  800986:	8d 50 e0             	lea    -0x20(%rax),%edx
  800989:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80098e:	80 fa 5e             	cmp    $0x5e,%dl
  800991:	77 c2                	ja     800955 <vprintfmt+0x2e1>
  800993:	eb bd                	jmp    800952 <vprintfmt+0x2de>
    if (zflag) return va_arg(*ap, size_t);
  800995:	40 84 f6             	test   %sil,%sil
  800998:	75 26                	jne    8009c0 <vprintfmt+0x34c>
    switch (lflag) {
  80099a:	85 d2                	test   %edx,%edx
  80099c:	74 59                	je     8009f7 <vprintfmt+0x383>
  80099e:	83 fa 01             	cmp    $0x1,%edx
  8009a1:	74 7b                	je     800a1e <vprintfmt+0x3aa>
        return va_arg(*ap, long long);
  8009a3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009a6:	83 f8 2f             	cmp    $0x2f,%eax
  8009a9:	0f 87 96 00 00 00    	ja     800a45 <vprintfmt+0x3d1>
  8009af:	89 c2                	mov    %eax,%edx
  8009b1:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8009b5:	83 c0 08             	add    $0x8,%eax
  8009b8:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009bb:	4c 8b 22             	mov    (%rdx),%r12
  8009be:	eb 17                	jmp    8009d7 <vprintfmt+0x363>
    if (zflag) return va_arg(*ap, size_t);
  8009c0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009c3:	83 f8 2f             	cmp    $0x2f,%eax
  8009c6:	77 21                	ja     8009e9 <vprintfmt+0x375>
  8009c8:	89 c2                	mov    %eax,%edx
  8009ca:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8009ce:	83 c0 08             	add    $0x8,%eax
  8009d1:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8009d4:	4c 8b 22             	mov    (%rdx),%r12
            if (i < 0) {
  8009d7:	4d 85 e4             	test   %r12,%r12
  8009da:	78 7a                	js     800a56 <vprintfmt+0x3e2>
            num = i;
  8009dc:	4c 89 e2             	mov    %r12,%rdx
        unsigned lflag = 0, base = 10;
  8009df:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  8009e4:	e9 50 02 00 00       	jmp    800c39 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8009e9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009ed:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8009f1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8009f5:	eb dd                	jmp    8009d4 <vprintfmt+0x360>
        return va_arg(*ap, int);
  8009f7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009fa:	83 f8 2f             	cmp    $0x2f,%eax
  8009fd:	77 11                	ja     800a10 <vprintfmt+0x39c>
  8009ff:	89 c2                	mov    %eax,%edx
  800a01:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a05:	83 c0 08             	add    $0x8,%eax
  800a08:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a0b:	4c 63 22             	movslq (%rdx),%r12
  800a0e:	eb c7                	jmp    8009d7 <vprintfmt+0x363>
  800a10:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a14:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a18:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a1c:	eb ed                	jmp    800a0b <vprintfmt+0x397>
        return va_arg(*ap, long);
  800a1e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a21:	83 f8 2f             	cmp    $0x2f,%eax
  800a24:	77 11                	ja     800a37 <vprintfmt+0x3c3>
  800a26:	89 c2                	mov    %eax,%edx
  800a28:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a2c:	83 c0 08             	add    $0x8,%eax
  800a2f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a32:	4c 8b 22             	mov    (%rdx),%r12
  800a35:	eb a0                	jmp    8009d7 <vprintfmt+0x363>
  800a37:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a3b:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a3f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a43:	eb ed                	jmp    800a32 <vprintfmt+0x3be>
        return va_arg(*ap, long long);
  800a45:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a49:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800a4d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800a51:	e9 65 ff ff ff       	jmp    8009bb <vprintfmt+0x347>
                putch('-', put_arg);
  800a56:	4c 89 ee             	mov    %r13,%rsi
  800a59:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800a5e:	41 ff d6             	call   *%r14
                i = -i;
  800a61:	49 f7 dc             	neg    %r12
  800a64:	e9 73 ff ff ff       	jmp    8009dc <vprintfmt+0x368>
    if (zflag) return va_arg(*ap, size_t);
  800a69:	40 84 f6             	test   %sil,%sil
  800a6c:	75 32                	jne    800aa0 <vprintfmt+0x42c>
    switch (lflag) {
  800a6e:	85 d2                	test   %edx,%edx
  800a70:	74 5d                	je     800acf <vprintfmt+0x45b>
  800a72:	83 fa 01             	cmp    $0x1,%edx
  800a75:	0f 84 82 00 00 00    	je     800afd <vprintfmt+0x489>
        return va_arg(*ap, unsigned long long);
  800a7b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a7e:	83 f8 2f             	cmp    $0x2f,%eax
  800a81:	0f 87 a5 00 00 00    	ja     800b2c <vprintfmt+0x4b8>
  800a87:	89 c2                	mov    %eax,%edx
  800a89:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800a8d:	83 c0 08             	add    $0x8,%eax
  800a90:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800a93:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800a96:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  800a9b:	e9 99 01 00 00       	jmp    800c39 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800aa0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aa3:	83 f8 2f             	cmp    $0x2f,%eax
  800aa6:	77 19                	ja     800ac1 <vprintfmt+0x44d>
  800aa8:	89 c2                	mov    %eax,%edx
  800aaa:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800aae:	83 c0 08             	add    $0x8,%eax
  800ab1:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ab4:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800ab7:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800abc:	e9 78 01 00 00       	jmp    800c39 <vprintfmt+0x5c5>
  800ac1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ac5:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800ac9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800acd:	eb e5                	jmp    800ab4 <vprintfmt+0x440>
        return va_arg(*ap, unsigned int);
  800acf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ad2:	83 f8 2f             	cmp    $0x2f,%eax
  800ad5:	77 18                	ja     800aef <vprintfmt+0x47b>
  800ad7:	89 c2                	mov    %eax,%edx
  800ad9:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800add:	83 c0 08             	add    $0x8,%eax
  800ae0:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ae3:	8b 12                	mov    (%rdx),%edx
        unsigned lflag = 0, base = 10;
  800ae5:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  800aea:	e9 4a 01 00 00       	jmp    800c39 <vprintfmt+0x5c5>
  800aef:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800af3:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800af7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800afb:	eb e6                	jmp    800ae3 <vprintfmt+0x46f>
        return va_arg(*ap, unsigned long);
  800afd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b00:	83 f8 2f             	cmp    $0x2f,%eax
  800b03:	77 19                	ja     800b1e <vprintfmt+0x4aa>
  800b05:	89 c2                	mov    %eax,%edx
  800b07:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b0b:	83 c0 08             	add    $0x8,%eax
  800b0e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b11:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  800b14:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  800b19:	e9 1b 01 00 00       	jmp    800c39 <vprintfmt+0x5c5>
  800b1e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b22:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b26:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b2a:	eb e5                	jmp    800b11 <vprintfmt+0x49d>
        return va_arg(*ap, unsigned long long);
  800b2c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b30:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b34:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b38:	e9 56 ff ff ff       	jmp    800a93 <vprintfmt+0x41f>
    if (zflag) return va_arg(*ap, size_t);
  800b3d:	40 84 f6             	test   %sil,%sil
  800b40:	75 2e                	jne    800b70 <vprintfmt+0x4fc>
    switch (lflag) {
  800b42:	85 d2                	test   %edx,%edx
  800b44:	74 59                	je     800b9f <vprintfmt+0x52b>
  800b46:	83 fa 01             	cmp    $0x1,%edx
  800b49:	74 7f                	je     800bca <vprintfmt+0x556>
        return va_arg(*ap, unsigned long long);
  800b4b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b4e:	83 f8 2f             	cmp    $0x2f,%eax
  800b51:	0f 87 9f 00 00 00    	ja     800bf6 <vprintfmt+0x582>
  800b57:	89 c2                	mov    %eax,%edx
  800b59:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b5d:	83 c0 08             	add    $0x8,%eax
  800b60:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b63:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800b66:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  800b6b:	e9 c9 00 00 00       	jmp    800c39 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800b70:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b73:	83 f8 2f             	cmp    $0x2f,%eax
  800b76:	77 19                	ja     800b91 <vprintfmt+0x51d>
  800b78:	89 c2                	mov    %eax,%edx
  800b7a:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800b7e:	83 c0 08             	add    $0x8,%eax
  800b81:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800b84:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800b87:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800b8c:	e9 a8 00 00 00       	jmp    800c39 <vprintfmt+0x5c5>
  800b91:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b95:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800b99:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800b9d:	eb e5                	jmp    800b84 <vprintfmt+0x510>
        return va_arg(*ap, unsigned int);
  800b9f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ba2:	83 f8 2f             	cmp    $0x2f,%eax
  800ba5:	77 15                	ja     800bbc <vprintfmt+0x548>
  800ba7:	89 c2                	mov    %eax,%edx
  800ba9:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800bad:	83 c0 08             	add    $0x8,%eax
  800bb0:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800bb3:	8b 12                	mov    (%rdx),%edx
            base = 8;
  800bb5:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  800bba:	eb 7d                	jmp    800c39 <vprintfmt+0x5c5>
  800bbc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bc0:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800bc4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800bc8:	eb e9                	jmp    800bb3 <vprintfmt+0x53f>
        return va_arg(*ap, unsigned long);
  800bca:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bcd:	83 f8 2f             	cmp    $0x2f,%eax
  800bd0:	77 16                	ja     800be8 <vprintfmt+0x574>
  800bd2:	89 c2                	mov    %eax,%edx
  800bd4:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800bd8:	83 c0 08             	add    $0x8,%eax
  800bdb:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800bde:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  800be1:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  800be6:	eb 51                	jmp    800c39 <vprintfmt+0x5c5>
  800be8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bec:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800bf0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800bf4:	eb e8                	jmp    800bde <vprintfmt+0x56a>
        return va_arg(*ap, unsigned long long);
  800bf6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bfa:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800bfe:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c02:	e9 5c ff ff ff       	jmp    800b63 <vprintfmt+0x4ef>
            putch('0', put_arg);
  800c07:	4c 89 ee             	mov    %r13,%rsi
  800c0a:	bf 30 00 00 00       	mov    $0x30,%edi
  800c0f:	41 ff d6             	call   *%r14
            putch('x', put_arg);
  800c12:	4c 89 ee             	mov    %r13,%rsi
  800c15:	bf 78 00 00 00       	mov    $0x78,%edi
  800c1a:	41 ff d6             	call   *%r14
            num = (uintptr_t)va_arg(aq, void *);
  800c1d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c20:	83 f8 2f             	cmp    $0x2f,%eax
  800c23:	77 47                	ja     800c6c <vprintfmt+0x5f8>
  800c25:	89 c2                	mov    %eax,%edx
  800c27:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800c2b:	83 c0 08             	add    $0x8,%eax
  800c2e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800c31:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800c34:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  800c39:	48 83 ec 08          	sub    $0x8,%rsp
  800c3d:	80 7d a0 58          	cmpb   $0x58,-0x60(%rbp)
  800c41:	0f 94 c0             	sete   %al
  800c44:	0f b6 c0             	movzbl %al,%eax
  800c47:	50                   	push   %rax
  800c48:	44 0f be 4d aa       	movsbl -0x56(%rbp),%r9d
  800c4d:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  800c51:	4c 89 ee             	mov    %r13,%rsi
  800c54:	4c 89 f7             	mov    %r14,%rdi
  800c57:	48 b8 5d 05 80 00 00 	movabs $0x80055d,%rax
  800c5e:	00 00 00 
  800c61:	ff d0                	call   *%rax
            break;
  800c63:	48 83 c4 10          	add    $0x10,%rsp
  800c67:	e9 3d fa ff ff       	jmp    8006a9 <vprintfmt+0x35>
            num = (uintptr_t)va_arg(aq, void *);
  800c6c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c70:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800c74:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800c78:	eb b7                	jmp    800c31 <vprintfmt+0x5bd>
    if (zflag) return va_arg(*ap, size_t);
  800c7a:	40 84 f6             	test   %sil,%sil
  800c7d:	75 2b                	jne    800caa <vprintfmt+0x636>
    switch (lflag) {
  800c7f:	85 d2                	test   %edx,%edx
  800c81:	74 56                	je     800cd9 <vprintfmt+0x665>
  800c83:	83 fa 01             	cmp    $0x1,%edx
  800c86:	74 7f                	je     800d07 <vprintfmt+0x693>
        return va_arg(*ap, unsigned long long);
  800c88:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c8b:	83 f8 2f             	cmp    $0x2f,%eax
  800c8e:	0f 87 a2 00 00 00    	ja     800d36 <vprintfmt+0x6c2>
  800c94:	89 c2                	mov    %eax,%edx
  800c96:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800c9a:	83 c0 08             	add    $0x8,%eax
  800c9d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ca0:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800ca3:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  800ca8:	eb 8f                	jmp    800c39 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  800caa:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cad:	83 f8 2f             	cmp    $0x2f,%eax
  800cb0:	77 19                	ja     800ccb <vprintfmt+0x657>
  800cb2:	89 c2                	mov    %eax,%edx
  800cb4:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800cb8:	83 c0 08             	add    $0x8,%eax
  800cbb:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800cbe:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800cc1:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  800cc6:	e9 6e ff ff ff       	jmp    800c39 <vprintfmt+0x5c5>
  800ccb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ccf:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800cd3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800cd7:	eb e5                	jmp    800cbe <vprintfmt+0x64a>
        return va_arg(*ap, unsigned int);
  800cd9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cdc:	83 f8 2f             	cmp    $0x2f,%eax
  800cdf:	77 18                	ja     800cf9 <vprintfmt+0x685>
  800ce1:	89 c2                	mov    %eax,%edx
  800ce3:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800ce7:	83 c0 08             	add    $0x8,%eax
  800cea:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800ced:	8b 12                	mov    (%rdx),%edx
            base = 16;
  800cef:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  800cf4:	e9 40 ff ff ff       	jmp    800c39 <vprintfmt+0x5c5>
  800cf9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cfd:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800d01:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800d05:	eb e6                	jmp    800ced <vprintfmt+0x679>
        return va_arg(*ap, unsigned long);
  800d07:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d0a:	83 f8 2f             	cmp    $0x2f,%eax
  800d0d:	77 19                	ja     800d28 <vprintfmt+0x6b4>
  800d0f:	89 c2                	mov    %eax,%edx
  800d11:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  800d15:	83 c0 08             	add    $0x8,%eax
  800d18:	89 45 b8             	mov    %eax,-0x48(%rbp)
  800d1b:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  800d1e:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  800d23:	e9 11 ff ff ff       	jmp    800c39 <vprintfmt+0x5c5>
  800d28:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d2c:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800d30:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800d34:	eb e5                	jmp    800d1b <vprintfmt+0x6a7>
        return va_arg(*ap, unsigned long long);
  800d36:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d3a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  800d3e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800d42:	e9 59 ff ff ff       	jmp    800ca0 <vprintfmt+0x62c>
            putch(ch, put_arg);
  800d47:	4c 89 ee             	mov    %r13,%rsi
  800d4a:	bf 25 00 00 00       	mov    $0x25,%edi
  800d4f:	41 ff d6             	call   *%r14
            break;
  800d52:	e9 52 f9 ff ff       	jmp    8006a9 <vprintfmt+0x35>
            putch('%', put_arg);
  800d57:	4c 89 ee             	mov    %r13,%rsi
  800d5a:	bf 25 00 00 00       	mov    $0x25,%edi
  800d5f:	41 ff d6             	call   *%r14
            while ((--ufmt)[-1] != '%') /* nothing */
  800d62:	48 83 eb 01          	sub    $0x1,%rbx
  800d66:	80 7b ff 25          	cmpb   $0x25,-0x1(%rbx)
  800d6a:	75 f6                	jne    800d62 <vprintfmt+0x6ee>
  800d6c:	e9 38 f9 ff ff       	jmp    8006a9 <vprintfmt+0x35>
}
  800d71:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800d75:	5b                   	pop    %rbx
  800d76:	41 5c                	pop    %r12
  800d78:	41 5d                	pop    %r13
  800d7a:	41 5e                	pop    %r14
  800d7c:	41 5f                	pop    %r15
  800d7e:	5d                   	pop    %rbp
  800d7f:	c3                   	ret

0000000000800d80 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  800d80:	f3 0f 1e fa          	endbr64
  800d84:	55                   	push   %rbp
  800d85:	48 89 e5             	mov    %rsp,%rbp
  800d88:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  800d8c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800d90:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  800d95:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800d99:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  800da0:	48 85 ff             	test   %rdi,%rdi
  800da3:	74 2b                	je     800dd0 <vsnprintf+0x50>
  800da5:	48 85 f6             	test   %rsi,%rsi
  800da8:	74 26                	je     800dd0 <vsnprintf+0x50>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  800daa:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  800dae:	48 bf 17 06 80 00 00 	movabs $0x800617,%rdi
  800db5:	00 00 00 
  800db8:	48 b8 74 06 80 00 00 	movabs $0x800674,%rax
  800dbf:	00 00 00 
  800dc2:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  800dc4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dc8:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  800dcb:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800dce:	c9                   	leave
  800dcf:	c3                   	ret
    if (!buf || n < 1) return -E_INVAL;
  800dd0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800dd5:	eb f7                	jmp    800dce <vsnprintf+0x4e>

0000000000800dd7 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  800dd7:	f3 0f 1e fa          	endbr64
  800ddb:	55                   	push   %rbp
  800ddc:	48 89 e5             	mov    %rsp,%rbp
  800ddf:	48 83 ec 50          	sub    $0x50,%rsp
  800de3:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800de7:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800deb:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800def:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  800df6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800dfa:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800dfe:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800e02:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  800e06:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  800e0a:	48 b8 80 0d 80 00 00 	movabs $0x800d80,%rax
  800e11:	00 00 00 
  800e14:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  800e16:	c9                   	leave
  800e17:	c3                   	ret

0000000000800e18 <strlen>:
 * Primespipe runs 3x faster this way */

#define ASM 1

size_t
strlen(const char *s) {
  800e18:	f3 0f 1e fa          	endbr64
    size_t n = 0;
    while (*s++) n++;
  800e1c:	80 3f 00             	cmpb   $0x0,(%rdi)
  800e1f:	74 10                	je     800e31 <strlen+0x19>
    size_t n = 0;
  800e21:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  800e26:	48 83 c0 01          	add    $0x1,%rax
  800e2a:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  800e2e:	75 f6                	jne    800e26 <strlen+0xe>
  800e30:	c3                   	ret
    size_t n = 0;
  800e31:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  800e36:	c3                   	ret

0000000000800e37 <strnlen>:

size_t
strnlen(const char *s, size_t size) {
  800e37:	f3 0f 1e fa          	endbr64
  800e3b:	48 89 f0             	mov    %rsi,%rax
    size_t n = 0;
  800e3e:	ba 00 00 00 00       	mov    $0x0,%edx
    while (n < size && *s++) n++;
  800e43:	48 85 f6             	test   %rsi,%rsi
  800e46:	74 10                	je     800e58 <strnlen+0x21>
  800e48:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  800e4c:	74 0b                	je     800e59 <strnlen+0x22>
  800e4e:	48 83 c2 01          	add    $0x1,%rdx
  800e52:	48 39 d0             	cmp    %rdx,%rax
  800e55:	75 f1                	jne    800e48 <strnlen+0x11>
  800e57:	c3                   	ret
  800e58:	c3                   	ret
  800e59:	48 89 d0             	mov    %rdx,%rax
    return n;
}
  800e5c:	c3                   	ret

0000000000800e5d <strcpy>:

char *
strcpy(char *dst, const char *src) {
  800e5d:	f3 0f 1e fa          	endbr64
  800e61:	48 89 f8             	mov    %rdi,%rax
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  800e64:	ba 00 00 00 00       	mov    $0x0,%edx
  800e69:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  800e6d:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  800e70:	48 83 c2 01          	add    $0x1,%rdx
  800e74:	84 c9                	test   %cl,%cl
  800e76:	75 f1                	jne    800e69 <strcpy+0xc>
        ;
    return res;
}
  800e78:	c3                   	ret

0000000000800e79 <strcat>:

char *
strcat(char *dst, const char *src) {
  800e79:	f3 0f 1e fa          	endbr64
  800e7d:	55                   	push   %rbp
  800e7e:	48 89 e5             	mov    %rsp,%rbp
  800e81:	41 54                	push   %r12
  800e83:	53                   	push   %rbx
  800e84:	48 89 fb             	mov    %rdi,%rbx
  800e87:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  800e8a:	48 b8 18 0e 80 00 00 	movabs $0x800e18,%rax
  800e91:	00 00 00 
  800e94:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  800e96:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  800e9a:	4c 89 e6             	mov    %r12,%rsi
  800e9d:	48 b8 5d 0e 80 00 00 	movabs $0x800e5d,%rax
  800ea4:	00 00 00 
  800ea7:	ff d0                	call   *%rax
    return dst;
}
  800ea9:	48 89 d8             	mov    %rbx,%rax
  800eac:	5b                   	pop    %rbx
  800ead:	41 5c                	pop    %r12
  800eaf:	5d                   	pop    %rbp
  800eb0:	c3                   	ret

0000000000800eb1 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800eb1:	f3 0f 1e fa          	endbr64
  800eb5:	48 89 f8             	mov    %rdi,%rax
    char *ret = dst;
    while (size-- > 0) {
  800eb8:	48 85 d2             	test   %rdx,%rdx
  800ebb:	74 1f                	je     800edc <strncpy+0x2b>
  800ebd:	48 01 fa             	add    %rdi,%rdx
  800ec0:	48 89 f9             	mov    %rdi,%rcx
        *dst++ = *src;
  800ec3:	48 83 c1 01          	add    $0x1,%rcx
  800ec7:	44 0f b6 06          	movzbl (%rsi),%r8d
  800ecb:	44 88 41 ff          	mov    %r8b,-0x1(%rcx)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  800ecf:	41 80 f8 01          	cmp    $0x1,%r8b
  800ed3:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  800ed7:	48 39 ca             	cmp    %rcx,%rdx
  800eda:	75 e7                	jne    800ec3 <strncpy+0x12>
    }
    return ret;
}
  800edc:	c3                   	ret

0000000000800edd <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
  800edd:	f3 0f 1e fa          	endbr64
    char *dst_in = dst;
    if (size) {
  800ee1:	48 89 f8             	mov    %rdi,%rax
  800ee4:	48 85 d2             	test   %rdx,%rdx
  800ee7:	74 24                	je     800f0d <strlcpy+0x30>
        while (--size > 0 && *src)
  800ee9:	48 83 ea 01          	sub    $0x1,%rdx
  800eed:	74 1b                	je     800f0a <strlcpy+0x2d>
  800eef:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  800ef3:	0f b6 16             	movzbl (%rsi),%edx
  800ef6:	84 d2                	test   %dl,%dl
  800ef8:	74 10                	je     800f0a <strlcpy+0x2d>
            *dst++ = *src++;
  800efa:	48 83 c6 01          	add    $0x1,%rsi
  800efe:	48 83 c0 01          	add    $0x1,%rax
  800f02:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  800f05:	48 39 c8             	cmp    %rcx,%rax
  800f08:	75 e9                	jne    800ef3 <strlcpy+0x16>
        *dst = '\0';
  800f0a:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  800f0d:	48 29 f8             	sub    %rdi,%rax
}
  800f10:	c3                   	ret

0000000000800f11 <strcmp>:
    }
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
  800f11:	f3 0f 1e fa          	endbr64
    while (*p && *p == *q) p++, q++;
  800f15:	0f b6 07             	movzbl (%rdi),%eax
  800f18:	84 c0                	test   %al,%al
  800f1a:	74 13                	je     800f2f <strcmp+0x1e>
  800f1c:	38 06                	cmp    %al,(%rsi)
  800f1e:	75 0f                	jne    800f2f <strcmp+0x1e>
  800f20:	48 83 c7 01          	add    $0x1,%rdi
  800f24:	48 83 c6 01          	add    $0x1,%rsi
  800f28:	0f b6 07             	movzbl (%rdi),%eax
  800f2b:	84 c0                	test   %al,%al
  800f2d:	75 ed                	jne    800f1c <strcmp+0xb>
    return (int)((unsigned char)*p - (unsigned char)*q);
  800f2f:	0f b6 c0             	movzbl %al,%eax
  800f32:	0f b6 16             	movzbl (%rsi),%edx
  800f35:	29 d0                	sub    %edx,%eax
}
  800f37:	c3                   	ret

0000000000800f38 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
  800f38:	f3 0f 1e fa          	endbr64
    while (n && *p && *p == *q) n--, p++, q++;
  800f3c:	48 85 d2             	test   %rdx,%rdx
  800f3f:	74 1f                	je     800f60 <strncmp+0x28>
  800f41:	0f b6 07             	movzbl (%rdi),%eax
  800f44:	84 c0                	test   %al,%al
  800f46:	74 1e                	je     800f66 <strncmp+0x2e>
  800f48:	3a 06                	cmp    (%rsi),%al
  800f4a:	75 1a                	jne    800f66 <strncmp+0x2e>
  800f4c:	48 83 c7 01          	add    $0x1,%rdi
  800f50:	48 83 c6 01          	add    $0x1,%rsi
  800f54:	48 83 ea 01          	sub    $0x1,%rdx
  800f58:	75 e7                	jne    800f41 <strncmp+0x9>

    if (!n) return 0;
  800f5a:	b8 00 00 00 00       	mov    $0x0,%eax
  800f5f:	c3                   	ret
  800f60:	b8 00 00 00 00       	mov    $0x0,%eax
  800f65:	c3                   	ret

    return (int)((unsigned char)*p - (unsigned char)*q);
  800f66:	0f b6 07             	movzbl (%rdi),%eax
  800f69:	0f b6 16             	movzbl (%rsi),%edx
  800f6c:	29 d0                	sub    %edx,%eax
}
  800f6e:	c3                   	ret

0000000000800f6f <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
  800f6f:	f3 0f 1e fa          	endbr64
    for (; *str; str++) {
  800f73:	0f b6 17             	movzbl (%rdi),%edx
  800f76:	84 d2                	test   %dl,%dl
  800f78:	74 18                	je     800f92 <strchr+0x23>
        if (*str == c) {
  800f7a:	0f be d2             	movsbl %dl,%edx
  800f7d:	39 f2                	cmp    %esi,%edx
  800f7f:	74 17                	je     800f98 <strchr+0x29>
    for (; *str; str++) {
  800f81:	48 83 c7 01          	add    $0x1,%rdi
  800f85:	0f b6 17             	movzbl (%rdi),%edx
  800f88:	84 d2                	test   %dl,%dl
  800f8a:	75 ee                	jne    800f7a <strchr+0xb>
            return (char *)str;
        }
    }
    return NULL;
  800f8c:	b8 00 00 00 00       	mov    $0x0,%eax
  800f91:	c3                   	ret
  800f92:	b8 00 00 00 00       	mov    $0x0,%eax
  800f97:	c3                   	ret
            return (char *)str;
  800f98:	48 89 f8             	mov    %rdi,%rax
}
  800f9b:	c3                   	ret

0000000000800f9c <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
  800f9c:	f3 0f 1e fa          	endbr64
  800fa0:	48 89 f8             	mov    %rdi,%rax
    for (; *str && *str != ch; str++) /* nothing */
  800fa3:	0f b6 17             	movzbl (%rdi),%edx
  800fa6:	84 d2                	test   %dl,%dl
  800fa8:	74 13                	je     800fbd <strfind+0x21>
  800faa:	0f be d2             	movsbl %dl,%edx
  800fad:	39 f2                	cmp    %esi,%edx
  800faf:	74 0b                	je     800fbc <strfind+0x20>
  800fb1:	48 83 c0 01          	add    $0x1,%rax
  800fb5:	0f b6 10             	movzbl (%rax),%edx
  800fb8:	84 d2                	test   %dl,%dl
  800fba:	75 ee                	jne    800faa <strfind+0xe>
        ;
    return (char *)str;
}
  800fbc:	c3                   	ret
  800fbd:	c3                   	ret

0000000000800fbe <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  800fbe:	f3 0f 1e fa          	endbr64
  800fc2:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  800fc5:	48 89 f8             	mov    %rdi,%rax
  800fc8:	48 f7 d8             	neg    %rax
  800fcb:	83 e0 07             	and    $0x7,%eax
  800fce:	49 89 d1             	mov    %rdx,%r9
  800fd1:	49 29 c1             	sub    %rax,%r9
  800fd4:	78 36                	js     80100c <memset+0x4e>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  800fd6:	40 0f b6 c6          	movzbl %sil,%eax
  800fda:	48 b9 01 01 01 01 01 	movabs $0x101010101010101,%rcx
  800fe1:	01 01 01 
  800fe4:	48 0f af c1          	imul   %rcx,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  800fe8:	40 f6 c7 07          	test   $0x7,%dil
  800fec:	75 38                	jne    801026 <memset+0x68>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  800fee:	4c 89 c9             	mov    %r9,%rcx
  800ff1:	48 c1 f9 03          	sar    $0x3,%rcx
  800ff5:	74 0c                	je     801003 <memset+0x45>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  800ff7:	fc                   	cld
  800ff8:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  800ffb:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  800fff:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  801003:	4d 85 c9             	test   %r9,%r9
  801006:	75 45                	jne    80104d <memset+0x8f>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  801008:	4c 89 c0             	mov    %r8,%rax
  80100b:	c3                   	ret
        while (n-- > 0) *ptr++ = c;
  80100c:	48 85 d2             	test   %rdx,%rdx
  80100f:	74 f7                	je     801008 <memset+0x4a>
  801011:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  801014:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  801017:	48 83 c0 01          	add    $0x1,%rax
  80101b:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  80101f:	48 39 c2             	cmp    %rax,%rdx
  801022:	75 f3                	jne    801017 <memset+0x59>
  801024:	eb e2                	jmp    801008 <memset+0x4a>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  801026:	40 f6 c7 01          	test   $0x1,%dil
  80102a:	74 06                	je     801032 <memset+0x74>
  80102c:	88 07                	mov    %al,(%rdi)
  80102e:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  801032:	40 f6 c7 02          	test   $0x2,%dil
  801036:	74 07                	je     80103f <memset+0x81>
  801038:	66 89 07             	mov    %ax,(%rdi)
  80103b:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  80103f:	40 f6 c7 04          	test   $0x4,%dil
  801043:	74 a9                	je     800fee <memset+0x30>
  801045:	89 07                	mov    %eax,(%rdi)
  801047:	48 83 c7 04          	add    $0x4,%rdi
  80104b:	eb a1                	jmp    800fee <memset+0x30>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  80104d:	41 f6 c1 04          	test   $0x4,%r9b
  801051:	74 1b                	je     80106e <memset+0xb0>
  801053:	89 07                	mov    %eax,(%rdi)
  801055:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  801059:	41 f6 c1 02          	test   $0x2,%r9b
  80105d:	74 07                	je     801066 <memset+0xa8>
  80105f:	66 89 07             	mov    %ax,(%rdi)
  801062:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  801066:	41 f6 c1 01          	test   $0x1,%r9b
  80106a:	74 9c                	je     801008 <memset+0x4a>
  80106c:	eb 06                	jmp    801074 <memset+0xb6>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  80106e:	41 f6 c1 02          	test   $0x2,%r9b
  801072:	75 eb                	jne    80105f <memset+0xa1>
        if (ni & 1) *ptr = k;
  801074:	88 07                	mov    %al,(%rdi)
  801076:	eb 90                	jmp    801008 <memset+0x4a>

0000000000801078 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  801078:	f3 0f 1e fa          	endbr64
  80107c:	48 89 f8             	mov    %rdi,%rax
  80107f:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  801082:	48 39 fe             	cmp    %rdi,%rsi
  801085:	73 3b                	jae    8010c2 <memmove+0x4a>
  801087:	48 8d 14 16          	lea    (%rsi,%rdx,1),%rdx
  80108b:	48 39 d7             	cmp    %rdx,%rdi
  80108e:	73 32                	jae    8010c2 <memmove+0x4a>
        s += n;
        d += n;
  801090:	48 8d 3c 0f          	lea    (%rdi,%rcx,1),%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  801094:	48 89 d6             	mov    %rdx,%rsi
  801097:	48 09 fe             	or     %rdi,%rsi
  80109a:	48 09 ce             	or     %rcx,%rsi
  80109d:	40 f6 c6 07          	test   $0x7,%sil
  8010a1:	75 12                	jne    8010b5 <memmove+0x3d>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  8010a3:	48 83 ef 08          	sub    $0x8,%rdi
  8010a7:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  8010ab:	48 c1 e9 03          	shr    $0x3,%rcx
  8010af:	fd                   	std
  8010b0:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  8010b3:	fc                   	cld
  8010b4:	c3                   	ret
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  8010b5:	48 83 ef 01          	sub    $0x1,%rdi
  8010b9:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  8010bd:	fd                   	std
  8010be:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  8010c0:	eb f1                	jmp    8010b3 <memmove+0x3b>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  8010c2:	48 89 f2             	mov    %rsi,%rdx
  8010c5:	48 09 c2             	or     %rax,%rdx
  8010c8:	48 09 ca             	or     %rcx,%rdx
  8010cb:	f6 c2 07             	test   $0x7,%dl
  8010ce:	75 0c                	jne    8010dc <memmove+0x64>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  8010d0:	48 c1 e9 03          	shr    $0x3,%rcx
  8010d4:	48 89 c7             	mov    %rax,%rdi
  8010d7:	fc                   	cld
  8010d8:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  8010db:	c3                   	ret
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  8010dc:	48 89 c7             	mov    %rax,%rdi
  8010df:	fc                   	cld
  8010e0:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  8010e2:	c3                   	ret

00000000008010e3 <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  8010e3:	f3 0f 1e fa          	endbr64
  8010e7:	55                   	push   %rbp
  8010e8:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  8010eb:	48 b8 78 10 80 00 00 	movabs $0x801078,%rax
  8010f2:	00 00 00 
  8010f5:	ff d0                	call   *%rax
}
  8010f7:	5d                   	pop    %rbp
  8010f8:	c3                   	ret

00000000008010f9 <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  8010f9:	f3 0f 1e fa          	endbr64
  8010fd:	55                   	push   %rbp
  8010fe:	48 89 e5             	mov    %rsp,%rbp
  801101:	41 57                	push   %r15
  801103:	41 56                	push   %r14
  801105:	41 55                	push   %r13
  801107:	41 54                	push   %r12
  801109:	53                   	push   %rbx
  80110a:	48 83 ec 08          	sub    $0x8,%rsp
  80110e:	49 89 fe             	mov    %rdi,%r14
  801111:	49 89 f7             	mov    %rsi,%r15
  801114:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  801117:	48 89 f7             	mov    %rsi,%rdi
  80111a:	48 b8 18 0e 80 00 00 	movabs $0x800e18,%rax
  801121:	00 00 00 
  801124:	ff d0                	call   *%rax
  801126:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  801129:	48 89 de             	mov    %rbx,%rsi
  80112c:	4c 89 f7             	mov    %r14,%rdi
  80112f:	48 b8 37 0e 80 00 00 	movabs $0x800e37,%rax
  801136:	00 00 00 
  801139:	ff d0                	call   *%rax
  80113b:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  80113e:	48 39 c3             	cmp    %rax,%rbx
  801141:	74 36                	je     801179 <strlcat+0x80>
    if (srclen < maxlen - dstlen) {
  801143:	48 89 d8             	mov    %rbx,%rax
  801146:	4c 29 e8             	sub    %r13,%rax
  801149:	49 39 c4             	cmp    %rax,%r12
  80114c:	73 31                	jae    80117f <strlcat+0x86>
        memcpy(dst + dstlen, src, srclen + 1);
  80114e:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  801153:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  801157:	4c 89 fe             	mov    %r15,%rsi
  80115a:	48 b8 e3 10 80 00 00 	movabs $0x8010e3,%rax
  801161:	00 00 00 
  801164:	ff d0                	call   *%rax
    return dstlen + srclen;
  801166:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  80116a:	48 83 c4 08          	add    $0x8,%rsp
  80116e:	5b                   	pop    %rbx
  80116f:	41 5c                	pop    %r12
  801171:	41 5d                	pop    %r13
  801173:	41 5e                	pop    %r14
  801175:	41 5f                	pop    %r15
  801177:	5d                   	pop    %rbp
  801178:	c3                   	ret
    if (dstlen == maxlen) return maxlen + srclen;
  801179:	49 8d 04 04          	lea    (%r12,%rax,1),%rax
  80117d:	eb eb                	jmp    80116a <strlcat+0x71>
        memcpy(dst + dstlen, src, maxlen - 1);
  80117f:	48 83 eb 01          	sub    $0x1,%rbx
  801183:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  801187:	48 89 da             	mov    %rbx,%rdx
  80118a:	4c 89 fe             	mov    %r15,%rsi
  80118d:	48 b8 e3 10 80 00 00 	movabs $0x8010e3,%rax
  801194:	00 00 00 
  801197:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  801199:	49 01 de             	add    %rbx,%r14
  80119c:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  8011a1:	eb c3                	jmp    801166 <strlcat+0x6d>

00000000008011a3 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  8011a3:	f3 0f 1e fa          	endbr64
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  8011a7:	48 85 d2             	test   %rdx,%rdx
  8011aa:	74 2d                	je     8011d9 <memcmp+0x36>
  8011ac:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  8011b1:	0f b6 0c 07          	movzbl (%rdi,%rax,1),%ecx
  8011b5:	44 0f b6 04 06       	movzbl (%rsi,%rax,1),%r8d
  8011ba:	44 38 c1             	cmp    %r8b,%cl
  8011bd:	75 0f                	jne    8011ce <memcmp+0x2b>
    while (n-- > 0) {
  8011bf:	48 83 c0 01          	add    $0x1,%rax
  8011c3:	48 39 c2             	cmp    %rax,%rdx
  8011c6:	75 e9                	jne    8011b1 <memcmp+0xe>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  8011c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8011cd:	c3                   	ret
            return (int)*s1 - (int)*s2;
  8011ce:	0f b6 c1             	movzbl %cl,%eax
  8011d1:	45 0f b6 c0          	movzbl %r8b,%r8d
  8011d5:	44 29 c0             	sub    %r8d,%eax
  8011d8:	c3                   	ret
    return 0;
  8011d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011de:	c3                   	ret

00000000008011df <memfind>:

void *
memfind(const void *src, int c, size_t n) {
  8011df:	f3 0f 1e fa          	endbr64
    const void *end = (const char *)src + n;
  8011e3:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  8011e7:	48 39 c7             	cmp    %rax,%rdi
  8011ea:	73 0f                	jae    8011fb <memfind+0x1c>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  8011ec:	40 38 37             	cmp    %sil,(%rdi)
  8011ef:	74 0e                	je     8011ff <memfind+0x20>
    for (; src < end; src++) {
  8011f1:	48 83 c7 01          	add    $0x1,%rdi
  8011f5:	48 39 f8             	cmp    %rdi,%rax
  8011f8:	75 f2                	jne    8011ec <memfind+0xd>
  8011fa:	c3                   	ret
  8011fb:	48 89 f8             	mov    %rdi,%rax
  8011fe:	c3                   	ret
  8011ff:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  801202:	c3                   	ret

0000000000801203 <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  801203:	f3 0f 1e fa          	endbr64
  801207:	49 89 f2             	mov    %rsi,%r10
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  80120a:	0f b6 37             	movzbl (%rdi),%esi
  80120d:	40 80 fe 20          	cmp    $0x20,%sil
  801211:	74 06                	je     801219 <strtol+0x16>
  801213:	40 80 fe 09          	cmp    $0x9,%sil
  801217:	75 13                	jne    80122c <strtol+0x29>
  801219:	48 83 c7 01          	add    $0x1,%rdi
  80121d:	0f b6 37             	movzbl (%rdi),%esi
  801220:	40 80 fe 20          	cmp    $0x20,%sil
  801224:	74 f3                	je     801219 <strtol+0x16>
  801226:	40 80 fe 09          	cmp    $0x9,%sil
  80122a:	74 ed                	je     801219 <strtol+0x16>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  80122c:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  80122f:	83 e0 fd             	and    $0xfffffffd,%eax
  801232:	3c 01                	cmp    $0x1,%al
  801234:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  801238:	f7 c2 ef ff ff ff    	test   $0xffffffef,%edx
  80123e:	75 0f                	jne    80124f <strtol+0x4c>
  801240:	80 3f 30             	cmpb   $0x30,(%rdi)
  801243:	74 14                	je     801259 <strtol+0x56>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  801245:	85 d2                	test   %edx,%edx
  801247:	b8 0a 00 00 00       	mov    $0xa,%eax
  80124c:	0f 44 d0             	cmove  %eax,%edx
    }

    /* Digits */
    long val = 0;
  80124f:	b8 00 00 00 00       	mov    $0x0,%eax
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  801254:	4c 63 ca             	movslq %edx,%r9
  801257:	eb 36                	jmp    80128f <strtol+0x8c>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  801259:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  80125d:	74 0f                	je     80126e <strtol+0x6b>
    } else if (!base && s[0] == '0') {
  80125f:	85 d2                	test   %edx,%edx
  801261:	75 ec                	jne    80124f <strtol+0x4c>
        s++;
  801263:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  801267:	ba 08 00 00 00       	mov    $0x8,%edx
        s++;
  80126c:	eb e1                	jmp    80124f <strtol+0x4c>
        s += 2;
  80126e:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  801272:	ba 10 00 00 00       	mov    $0x10,%edx
        s += 2;
  801277:	eb d6                	jmp    80124f <strtol+0x4c>
            dig -= '0';
  801279:	83 e9 30             	sub    $0x30,%ecx
        if (dig >= base) break;
  80127c:	44 0f b6 c1          	movzbl %cl,%r8d
  801280:	41 39 d0             	cmp    %edx,%r8d
  801283:	7d 21                	jge    8012a6 <strtol+0xa3>
        val = val * base + dig;
  801285:	49 0f af c1          	imul   %r9,%rax
  801289:	0f b6 c9             	movzbl %cl,%ecx
  80128c:	48 01 c8             	add    %rcx,%rax
        uint8_t dig = *s++;
  80128f:	48 83 c7 01          	add    $0x1,%rdi
  801293:	0f b6 4f ff          	movzbl -0x1(%rdi),%ecx
        if (dig - '0' < 10)
  801297:	80 f9 39             	cmp    $0x39,%cl
  80129a:	76 dd                	jbe    801279 <strtol+0x76>
        else if (dig - 'a' < 27)
  80129c:	80 f9 7b             	cmp    $0x7b,%cl
  80129f:	77 05                	ja     8012a6 <strtol+0xa3>
            dig -= 'a' - 10;
  8012a1:	83 e9 57             	sub    $0x57,%ecx
  8012a4:	eb d6                	jmp    80127c <strtol+0x79>
    }

    if (endptr) *endptr = (char *)s;
  8012a6:	4d 85 d2             	test   %r10,%r10
  8012a9:	74 03                	je     8012ae <strtol+0xab>
  8012ab:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  8012ae:	48 89 c2             	mov    %rax,%rdx
  8012b1:	48 f7 da             	neg    %rdx
  8012b4:	40 80 fe 2d          	cmp    $0x2d,%sil
  8012b8:	48 0f 44 c2          	cmove  %rdx,%rax
}
  8012bc:	c3                   	ret

00000000008012bd <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  8012bd:	f3 0f 1e fa          	endbr64
  8012c1:	55                   	push   %rbp
  8012c2:	48 89 e5             	mov    %rsp,%rbp
  8012c5:	53                   	push   %rbx
  8012c6:	48 89 fa             	mov    %rdi,%rdx
  8012c9:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8012cc:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8012d1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012d6:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8012db:	be 00 00 00 00       	mov    $0x0,%esi
  8012e0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8012e6:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  8012e8:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8012ec:	c9                   	leave
  8012ed:	c3                   	ret

00000000008012ee <sys_cgetc>:

int
sys_cgetc(void) {
  8012ee:	f3 0f 1e fa          	endbr64
  8012f2:	55                   	push   %rbp
  8012f3:	48 89 e5             	mov    %rsp,%rbp
  8012f6:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8012f7:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8012fc:	ba 00 00 00 00       	mov    $0x0,%edx
  801301:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801306:	bb 00 00 00 00       	mov    $0x0,%ebx
  80130b:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801310:	be 00 00 00 00       	mov    $0x0,%esi
  801315:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80131b:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  80131d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801321:	c9                   	leave
  801322:	c3                   	ret

0000000000801323 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  801323:	f3 0f 1e fa          	endbr64
  801327:	55                   	push   %rbp
  801328:	48 89 e5             	mov    %rsp,%rbp
  80132b:	53                   	push   %rbx
  80132c:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  801330:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801333:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801338:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80133d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801342:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801347:	be 00 00 00 00       	mov    $0x0,%esi
  80134c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801352:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801354:	48 85 c0             	test   %rax,%rax
  801357:	7f 06                	jg     80135f <sys_env_destroy+0x3c>
}
  801359:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80135d:	c9                   	leave
  80135e:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80135f:	49 89 c0             	mov    %rax,%r8
  801362:	b9 03 00 00 00       	mov    $0x3,%ecx
  801367:	48 ba 00 36 80 00 00 	movabs $0x803600,%rdx
  80136e:	00 00 00 
  801371:	be 26 00 00 00       	mov    $0x26,%esi
  801376:	48 bf c1 31 80 00 00 	movabs $0x8031c1,%rdi
  80137d:	00 00 00 
  801380:	b8 00 00 00 00       	mov    $0x0,%eax
  801385:	49 b9 8d 2d 80 00 00 	movabs $0x802d8d,%r9
  80138c:	00 00 00 
  80138f:	41 ff d1             	call   *%r9

0000000000801392 <sys_getenvid>:

envid_t
sys_getenvid(void) {
  801392:	f3 0f 1e fa          	endbr64
  801396:	55                   	push   %rbp
  801397:	48 89 e5             	mov    %rsp,%rbp
  80139a:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  80139b:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8013a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8013a5:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8013aa:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013af:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013b4:	be 00 00 00 00       	mov    $0x0,%esi
  8013b9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013bf:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  8013c1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013c5:	c9                   	leave
  8013c6:	c3                   	ret

00000000008013c7 <sys_yield>:

void
sys_yield(void) {
  8013c7:	f3 0f 1e fa          	endbr64
  8013cb:	55                   	push   %rbp
  8013cc:	48 89 e5             	mov    %rsp,%rbp
  8013cf:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8013d0:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8013d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8013da:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8013df:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013e4:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8013e9:	be 00 00 00 00       	mov    $0x0,%esi
  8013ee:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8013f4:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  8013f6:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8013fa:	c9                   	leave
  8013fb:	c3                   	ret

00000000008013fc <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  8013fc:	f3 0f 1e fa          	endbr64
  801400:	55                   	push   %rbp
  801401:	48 89 e5             	mov    %rsp,%rbp
  801404:	53                   	push   %rbx
  801405:	48 89 fa             	mov    %rdi,%rdx
  801408:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  80140b:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801410:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  801417:	00 00 00 
  80141a:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80141f:	be 00 00 00 00       	mov    $0x0,%esi
  801424:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80142a:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  80142c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801430:	c9                   	leave
  801431:	c3                   	ret

0000000000801432 <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  801432:	f3 0f 1e fa          	endbr64
  801436:	55                   	push   %rbp
  801437:	48 89 e5             	mov    %rsp,%rbp
  80143a:	53                   	push   %rbx
  80143b:	49 89 f8             	mov    %rdi,%r8
  80143e:	48 89 d3             	mov    %rdx,%rbx
  801441:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  801444:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801449:	4c 89 c2             	mov    %r8,%rdx
  80144c:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80144f:	be 00 00 00 00       	mov    $0x0,%esi
  801454:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80145a:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  80145c:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801460:	c9                   	leave
  801461:	c3                   	ret

0000000000801462 <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  801462:	f3 0f 1e fa          	endbr64
  801466:	55                   	push   %rbp
  801467:	48 89 e5             	mov    %rsp,%rbp
  80146a:	53                   	push   %rbx
  80146b:	48 83 ec 08          	sub    $0x8,%rsp
  80146f:	89 f8                	mov    %edi,%eax
  801471:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  801474:	48 63 f9             	movslq %ecx,%rdi
  801477:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80147a:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80147f:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801482:	be 00 00 00 00       	mov    $0x0,%esi
  801487:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80148d:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80148f:	48 85 c0             	test   %rax,%rax
  801492:	7f 06                	jg     80149a <sys_alloc_region+0x38>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  801494:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801498:	c9                   	leave
  801499:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80149a:	49 89 c0             	mov    %rax,%r8
  80149d:	b9 04 00 00 00       	mov    $0x4,%ecx
  8014a2:	48 ba 00 36 80 00 00 	movabs $0x803600,%rdx
  8014a9:	00 00 00 
  8014ac:	be 26 00 00 00       	mov    $0x26,%esi
  8014b1:	48 bf c1 31 80 00 00 	movabs $0x8031c1,%rdi
  8014b8:	00 00 00 
  8014bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c0:	49 b9 8d 2d 80 00 00 	movabs $0x802d8d,%r9
  8014c7:	00 00 00 
  8014ca:	41 ff d1             	call   *%r9

00000000008014cd <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  8014cd:	f3 0f 1e fa          	endbr64
  8014d1:	55                   	push   %rbp
  8014d2:	48 89 e5             	mov    %rsp,%rbp
  8014d5:	53                   	push   %rbx
  8014d6:	48 83 ec 08          	sub    $0x8,%rsp
  8014da:	89 f8                	mov    %edi,%eax
  8014dc:	49 89 f2             	mov    %rsi,%r10
  8014df:	48 89 cf             	mov    %rcx,%rdi
  8014e2:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  8014e5:	48 63 da             	movslq %edx,%rbx
  8014e8:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8014eb:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8014f0:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8014f3:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  8014f6:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8014f8:	48 85 c0             	test   %rax,%rax
  8014fb:	7f 06                	jg     801503 <sys_map_region+0x36>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  8014fd:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801501:	c9                   	leave
  801502:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801503:	49 89 c0             	mov    %rax,%r8
  801506:	b9 05 00 00 00       	mov    $0x5,%ecx
  80150b:	48 ba 00 36 80 00 00 	movabs $0x803600,%rdx
  801512:	00 00 00 
  801515:	be 26 00 00 00       	mov    $0x26,%esi
  80151a:	48 bf c1 31 80 00 00 	movabs $0x8031c1,%rdi
  801521:	00 00 00 
  801524:	b8 00 00 00 00       	mov    $0x0,%eax
  801529:	49 b9 8d 2d 80 00 00 	movabs $0x802d8d,%r9
  801530:	00 00 00 
  801533:	41 ff d1             	call   *%r9

0000000000801536 <sys_map_physical_region>:

int
sys_map_physical_region(uintptr_t pa, envid_t dstenv, void *dstva, size_t size, int perm) {
  801536:	f3 0f 1e fa          	endbr64
  80153a:	55                   	push   %rbp
  80153b:	48 89 e5             	mov    %rsp,%rbp
  80153e:	53                   	push   %rbx
  80153f:	48 83 ec 08          	sub    $0x8,%rsp
  801543:	49 89 f9             	mov    %rdi,%r9
  801546:	89 f0                	mov    %esi,%eax
  801548:	48 89 d3             	mov    %rdx,%rbx
  80154b:	48 89 cf             	mov    %rcx,%rdi
    int res = syscall(SYS_map_physical_region, 1, pa, dstenv, (uintptr_t)dstva, size, perm, 0);
  80154e:	49 63 f0             	movslq %r8d,%rsi
  801551:	48 63 c8             	movslq %eax,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801554:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801559:	4c 89 ca             	mov    %r9,%rdx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80155c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801562:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801564:	48 85 c0             	test   %rax,%rax
  801567:	7f 06                	jg     80156f <sys_map_physical_region+0x39>
#ifdef SANITIZE_USER_SHADOW_BASE
    platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  801569:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80156d:	c9                   	leave
  80156e:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80156f:	49 89 c0             	mov    %rax,%r8
  801572:	b9 06 00 00 00       	mov    $0x6,%ecx
  801577:	48 ba 00 36 80 00 00 	movabs $0x803600,%rdx
  80157e:	00 00 00 
  801581:	be 26 00 00 00       	mov    $0x26,%esi
  801586:	48 bf c1 31 80 00 00 	movabs $0x8031c1,%rdi
  80158d:	00 00 00 
  801590:	b8 00 00 00 00       	mov    $0x0,%eax
  801595:	49 b9 8d 2d 80 00 00 	movabs $0x802d8d,%r9
  80159c:	00 00 00 
  80159f:	41 ff d1             	call   *%r9

00000000008015a2 <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  8015a2:	f3 0f 1e fa          	endbr64
  8015a6:	55                   	push   %rbp
  8015a7:	48 89 e5             	mov    %rsp,%rbp
  8015aa:	53                   	push   %rbx
  8015ab:	48 83 ec 08          	sub    $0x8,%rsp
  8015af:	48 89 f1             	mov    %rsi,%rcx
  8015b2:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  8015b5:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8015b8:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8015bd:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8015c2:	be 00 00 00 00       	mov    $0x0,%esi
  8015c7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8015cd:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8015cf:	48 85 c0             	test   %rax,%rax
  8015d2:	7f 06                	jg     8015da <sys_unmap_region+0x38>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  8015d4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8015d8:	c9                   	leave
  8015d9:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8015da:	49 89 c0             	mov    %rax,%r8
  8015dd:	b9 07 00 00 00       	mov    $0x7,%ecx
  8015e2:	48 ba 00 36 80 00 00 	movabs $0x803600,%rdx
  8015e9:	00 00 00 
  8015ec:	be 26 00 00 00       	mov    $0x26,%esi
  8015f1:	48 bf c1 31 80 00 00 	movabs $0x8031c1,%rdi
  8015f8:	00 00 00 
  8015fb:	b8 00 00 00 00       	mov    $0x0,%eax
  801600:	49 b9 8d 2d 80 00 00 	movabs $0x802d8d,%r9
  801607:	00 00 00 
  80160a:	41 ff d1             	call   *%r9

000000000080160d <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  80160d:	f3 0f 1e fa          	endbr64
  801611:	55                   	push   %rbp
  801612:	48 89 e5             	mov    %rsp,%rbp
  801615:	53                   	push   %rbx
  801616:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  80161a:	48 63 ce             	movslq %esi,%rcx
  80161d:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801620:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801625:	bb 00 00 00 00       	mov    $0x0,%ebx
  80162a:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80162f:	be 00 00 00 00       	mov    $0x0,%esi
  801634:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80163a:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80163c:	48 85 c0             	test   %rax,%rax
  80163f:	7f 06                	jg     801647 <sys_env_set_status+0x3a>
}
  801641:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801645:	c9                   	leave
  801646:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801647:	49 89 c0             	mov    %rax,%r8
  80164a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80164f:	48 ba 00 36 80 00 00 	movabs $0x803600,%rdx
  801656:	00 00 00 
  801659:	be 26 00 00 00       	mov    $0x26,%esi
  80165e:	48 bf c1 31 80 00 00 	movabs $0x8031c1,%rdi
  801665:	00 00 00 
  801668:	b8 00 00 00 00       	mov    $0x0,%eax
  80166d:	49 b9 8d 2d 80 00 00 	movabs $0x802d8d,%r9
  801674:	00 00 00 
  801677:	41 ff d1             	call   *%r9

000000000080167a <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  80167a:	f3 0f 1e fa          	endbr64
  80167e:	55                   	push   %rbp
  80167f:	48 89 e5             	mov    %rsp,%rbp
  801682:	53                   	push   %rbx
  801683:	48 83 ec 08          	sub    $0x8,%rsp
  801687:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  80168a:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80168d:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801692:	bb 00 00 00 00       	mov    $0x0,%ebx
  801697:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80169c:	be 00 00 00 00       	mov    $0x0,%esi
  8016a1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8016a7:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8016a9:	48 85 c0             	test   %rax,%rax
  8016ac:	7f 06                	jg     8016b4 <sys_env_set_trapframe+0x3a>
}
  8016ae:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8016b2:	c9                   	leave
  8016b3:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8016b4:	49 89 c0             	mov    %rax,%r8
  8016b7:	b9 0b 00 00 00       	mov    $0xb,%ecx
  8016bc:	48 ba 00 36 80 00 00 	movabs $0x803600,%rdx
  8016c3:	00 00 00 
  8016c6:	be 26 00 00 00       	mov    $0x26,%esi
  8016cb:	48 bf c1 31 80 00 00 	movabs $0x8031c1,%rdi
  8016d2:	00 00 00 
  8016d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8016da:	49 b9 8d 2d 80 00 00 	movabs $0x802d8d,%r9
  8016e1:	00 00 00 
  8016e4:	41 ff d1             	call   *%r9

00000000008016e7 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  8016e7:	f3 0f 1e fa          	endbr64
  8016eb:	55                   	push   %rbp
  8016ec:	48 89 e5             	mov    %rsp,%rbp
  8016ef:	53                   	push   %rbx
  8016f0:	48 83 ec 08          	sub    $0x8,%rsp
  8016f4:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  8016f7:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  8016fa:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8016ff:	bb 00 00 00 00       	mov    $0x0,%ebx
  801704:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801709:	be 00 00 00 00       	mov    $0x0,%esi
  80170e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801714:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801716:	48 85 c0             	test   %rax,%rax
  801719:	7f 06                	jg     801721 <sys_env_set_pgfault_upcall+0x3a>
}
  80171b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80171f:	c9                   	leave
  801720:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801721:	49 89 c0             	mov    %rax,%r8
  801724:	b9 0c 00 00 00       	mov    $0xc,%ecx
  801729:	48 ba 00 36 80 00 00 	movabs $0x803600,%rdx
  801730:	00 00 00 
  801733:	be 26 00 00 00       	mov    $0x26,%esi
  801738:	48 bf c1 31 80 00 00 	movabs $0x8031c1,%rdi
  80173f:	00 00 00 
  801742:	b8 00 00 00 00       	mov    $0x0,%eax
  801747:	49 b9 8d 2d 80 00 00 	movabs $0x802d8d,%r9
  80174e:	00 00 00 
  801751:	41 ff d1             	call   *%r9

0000000000801754 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  801754:	f3 0f 1e fa          	endbr64
  801758:	55                   	push   %rbp
  801759:	48 89 e5             	mov    %rsp,%rbp
  80175c:	53                   	push   %rbx
  80175d:	89 f8                	mov    %edi,%eax
  80175f:	49 89 f1             	mov    %rsi,%r9
  801762:	48 89 d3             	mov    %rdx,%rbx
  801765:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  801768:	49 63 f0             	movslq %r8d,%rsi
  80176b:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80176e:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801773:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801776:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80177c:	cd 30                	int    $0x30
}
  80177e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801782:	c9                   	leave
  801783:	c3                   	ret

0000000000801784 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  801784:	f3 0f 1e fa          	endbr64
  801788:	55                   	push   %rbp
  801789:	48 89 e5             	mov    %rsp,%rbp
  80178c:	53                   	push   %rbx
  80178d:	48 83 ec 08          	sub    $0x8,%rsp
  801791:	48 89 fa             	mov    %rdi,%rdx
  801794:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801797:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80179c:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017a1:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8017a6:	be 00 00 00 00       	mov    $0x0,%esi
  8017ab:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8017b1:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8017b3:	48 85 c0             	test   %rax,%rax
  8017b6:	7f 06                	jg     8017be <sys_ipc_recv+0x3a>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  8017b8:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8017bc:	c9                   	leave
  8017bd:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8017be:	49 89 c0             	mov    %rax,%r8
  8017c1:	b9 0f 00 00 00       	mov    $0xf,%ecx
  8017c6:	48 ba 00 36 80 00 00 	movabs $0x803600,%rdx
  8017cd:	00 00 00 
  8017d0:	be 26 00 00 00       	mov    $0x26,%esi
  8017d5:	48 bf c1 31 80 00 00 	movabs $0x8031c1,%rdi
  8017dc:	00 00 00 
  8017df:	b8 00 00 00 00       	mov    $0x0,%eax
  8017e4:	49 b9 8d 2d 80 00 00 	movabs $0x802d8d,%r9
  8017eb:	00 00 00 
  8017ee:	41 ff d1             	call   *%r9

00000000008017f1 <sys_gettime>:

int
sys_gettime(void) {
  8017f1:	f3 0f 1e fa          	endbr64
  8017f5:	55                   	push   %rbp
  8017f6:	48 89 e5             	mov    %rsp,%rbp
  8017f9:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  8017fa:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  8017ff:	ba 00 00 00 00       	mov    $0x0,%edx
  801804:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801809:	bb 00 00 00 00       	mov    $0x0,%ebx
  80180e:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801813:	be 00 00 00 00       	mov    $0x0,%esi
  801818:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80181e:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  801820:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801824:	c9                   	leave
  801825:	c3                   	ret

0000000000801826 <fd2num>:


/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
  801826:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80182a:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801831:	ff ff ff 
  801834:	48 01 f8             	add    %rdi,%rax
  801837:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80183b:	c3                   	ret

000000000080183c <fd2data>:

char *
fd2data(struct Fd *fd) {
  80183c:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  801840:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801847:	ff ff ff 
  80184a:	48 01 f8             	add    %rdi,%rax
  80184d:	48 c1 e8 0c          	shr    $0xc,%rax
    return INDEX2DATA(fd2num(fd));
  801851:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801857:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80185b:	c3                   	ret

000000000080185c <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  80185c:	f3 0f 1e fa          	endbr64
  801860:	55                   	push   %rbp
  801861:	48 89 e5             	mov    %rsp,%rbp
  801864:	41 57                	push   %r15
  801866:	41 56                	push   %r14
  801868:	41 55                	push   %r13
  80186a:	41 54                	push   %r12
  80186c:	53                   	push   %rbx
  80186d:	48 83 ec 08          	sub    $0x8,%rsp
  801871:	49 89 ff             	mov    %rdi,%r15
  801874:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  801879:	49 bd bb 29 80 00 00 	movabs $0x8029bb,%r13
  801880:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  801883:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        struct Fd *fd = INDEX2FD(i);
  801889:	49 89 dc             	mov    %rbx,%r12
        if (!(get_prot(fd) & PROT_R)) {
  80188c:	48 89 df             	mov    %rbx,%rdi
  80188f:	41 ff d5             	call   *%r13
  801892:	83 e0 04             	and    $0x4,%eax
  801895:	74 17                	je     8018ae <fd_alloc+0x52>
    for (int i = 0; i < MAXFD; i++) {
  801897:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  80189e:	4c 39 f3             	cmp    %r14,%rbx
  8018a1:	75 e6                	jne    801889 <fd_alloc+0x2d>
  8018a3:	41 bc 00 00 00 00    	mov    $0x0,%r12d
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
    return -E_MAX_OPEN;
  8018a9:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
            *fd_store = fd;
  8018ae:	4d 89 27             	mov    %r12,(%r15)
}
  8018b1:	48 83 c4 08          	add    $0x8,%rsp
  8018b5:	5b                   	pop    %rbx
  8018b6:	41 5c                	pop    %r12
  8018b8:	41 5d                	pop    %r13
  8018ba:	41 5e                	pop    %r14
  8018bc:	41 5f                	pop    %r15
  8018be:	5d                   	pop    %rbp
  8018bf:	c3                   	ret

00000000008018c0 <fd_lookup>:
 *
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
  8018c0:	f3 0f 1e fa          	endbr64
    if (fdnum < 0 || fdnum >= MAXFD) {
  8018c4:	83 ff 1f             	cmp    $0x1f,%edi
  8018c7:	77 39                	ja     801902 <fd_lookup+0x42>
fd_lookup(int fdnum, struct Fd **fd_store) {
  8018c9:	55                   	push   %rbp
  8018ca:	48 89 e5             	mov    %rsp,%rbp
  8018cd:	41 54                	push   %r12
  8018cf:	53                   	push   %rbx
  8018d0:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  8018d3:	48 63 df             	movslq %edi,%rbx
  8018d6:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  8018dd:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  8018e1:	48 89 df             	mov    %rbx,%rdi
  8018e4:	48 b8 bb 29 80 00 00 	movabs $0x8029bb,%rax
  8018eb:	00 00 00 
  8018ee:	ff d0                	call   *%rax
  8018f0:	a8 04                	test   $0x4,%al
  8018f2:	74 14                	je     801908 <fd_lookup+0x48>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  8018f4:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  8018f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018fd:	5b                   	pop    %rbx
  8018fe:	41 5c                	pop    %r12
  801900:	5d                   	pop    %rbp
  801901:	c3                   	ret
        return -E_INVAL;
  801902:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801907:	c3                   	ret
        return -E_INVAL;
  801908:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80190d:	eb ee                	jmp    8018fd <fd_lookup+0x3d>

000000000080190f <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  80190f:	f3 0f 1e fa          	endbr64
  801913:	55                   	push   %rbp
  801914:	48 89 e5             	mov    %rsp,%rbp
  801917:	41 54                	push   %r12
  801919:	53                   	push   %rbx
  80191a:	49 89 f4             	mov    %rsi,%r12
    for (size_t i = 0; devtab[i]; i++) {
  80191d:	48 b8 c0 36 80 00 00 	movabs $0x8036c0,%rax
  801924:	00 00 00 
  801927:	48 bb 20 40 80 00 00 	movabs $0x804020,%rbx
  80192e:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  801931:	39 3b                	cmp    %edi,(%rbx)
  801933:	74 47                	je     80197c <dev_lookup+0x6d>
    for (size_t i = 0; devtab[i]; i++) {
  801935:	48 83 c0 08          	add    $0x8,%rax
  801939:	48 8b 18             	mov    (%rax),%rbx
  80193c:	48 85 db             	test   %rbx,%rbx
  80193f:	75 f0                	jne    801931 <dev_lookup+0x22>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801941:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801948:	00 00 00 
  80194b:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801951:	89 fa                	mov    %edi,%edx
  801953:	48 bf 20 36 80 00 00 	movabs $0x803620,%rdi
  80195a:	00 00 00 
  80195d:	b8 00 00 00 00       	mov    $0x0,%eax
  801962:	48 b9 14 05 80 00 00 	movabs $0x800514,%rcx
  801969:	00 00 00 
  80196c:	ff d1                	call   *%rcx
    *dev = 0;
    return -E_INVAL;
  80196e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
            *dev = devtab[i];
  801973:	49 89 1c 24          	mov    %rbx,(%r12)
}
  801977:	5b                   	pop    %rbx
  801978:	41 5c                	pop    %r12
  80197a:	5d                   	pop    %rbp
  80197b:	c3                   	ret
            return 0;
  80197c:	b8 00 00 00 00       	mov    $0x0,%eax
  801981:	eb f0                	jmp    801973 <dev_lookup+0x64>

0000000000801983 <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  801983:	f3 0f 1e fa          	endbr64
  801987:	55                   	push   %rbp
  801988:	48 89 e5             	mov    %rsp,%rbp
  80198b:	41 55                	push   %r13
  80198d:	41 54                	push   %r12
  80198f:	53                   	push   %rbx
  801990:	48 83 ec 18          	sub    $0x18,%rsp
  801994:	48 89 fb             	mov    %rdi,%rbx
  801997:	41 89 f4             	mov    %esi,%r12d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80199a:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  8019a1:	ff ff ff 
  8019a4:	48 01 df             	add    %rbx,%rdi
  8019a7:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  8019ab:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8019af:	48 b8 c0 18 80 00 00 	movabs $0x8018c0,%rax
  8019b6:	00 00 00 
  8019b9:	ff d0                	call   *%rax
  8019bb:	41 89 c5             	mov    %eax,%r13d
  8019be:	85 c0                	test   %eax,%eax
  8019c0:	78 06                	js     8019c8 <fd_close+0x45>
  8019c2:	48 39 5d d8          	cmp    %rbx,-0x28(%rbp)
  8019c6:	74 1a                	je     8019e2 <fd_close+0x5f>
        return (must_exist ? res : 0);
  8019c8:	45 84 e4             	test   %r12b,%r12b
  8019cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8019d0:	44 0f 44 e8          	cmove  %eax,%r13d
}
  8019d4:	44 89 e8             	mov    %r13d,%eax
  8019d7:	48 83 c4 18          	add    $0x18,%rsp
  8019db:	5b                   	pop    %rbx
  8019dc:	41 5c                	pop    %r12
  8019de:	41 5d                	pop    %r13
  8019e0:	5d                   	pop    %rbp
  8019e1:	c3                   	ret
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8019e2:	8b 3b                	mov    (%rbx),%edi
  8019e4:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8019e8:	48 b8 0f 19 80 00 00 	movabs $0x80190f,%rax
  8019ef:	00 00 00 
  8019f2:	ff d0                	call   *%rax
  8019f4:	41 89 c5             	mov    %eax,%r13d
  8019f7:	85 c0                	test   %eax,%eax
  8019f9:	78 1b                	js     801a16 <fd_close+0x93>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  8019fb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019ff:	48 8b 40 20          	mov    0x20(%rax),%rax
  801a03:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  801a09:	48 85 c0             	test   %rax,%rax
  801a0c:	74 08                	je     801a16 <fd_close+0x93>
  801a0e:	48 89 df             	mov    %rbx,%rdi
  801a11:	ff d0                	call   *%rax
  801a13:	41 89 c5             	mov    %eax,%r13d
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  801a16:	ba 00 10 00 00       	mov    $0x1000,%edx
  801a1b:	48 89 de             	mov    %rbx,%rsi
  801a1e:	bf 00 00 00 00       	mov    $0x0,%edi
  801a23:	48 b8 a2 15 80 00 00 	movabs $0x8015a2,%rax
  801a2a:	00 00 00 
  801a2d:	ff d0                	call   *%rax
    return res;
  801a2f:	eb a3                	jmp    8019d4 <fd_close+0x51>

0000000000801a31 <close>:

int
close(int fdnum) {
  801a31:	f3 0f 1e fa          	endbr64
  801a35:	55                   	push   %rbp
  801a36:	48 89 e5             	mov    %rsp,%rbp
  801a39:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  801a3d:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  801a41:	48 b8 c0 18 80 00 00 	movabs $0x8018c0,%rax
  801a48:	00 00 00 
  801a4b:	ff d0                	call   *%rax
    if (res < 0) return res;
  801a4d:	85 c0                	test   %eax,%eax
  801a4f:	78 15                	js     801a66 <close+0x35>

    return fd_close(fd, 1);
  801a51:	be 01 00 00 00       	mov    $0x1,%esi
  801a56:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  801a5a:	48 b8 83 19 80 00 00 	movabs $0x801983,%rax
  801a61:	00 00 00 
  801a64:	ff d0                	call   *%rax
}
  801a66:	c9                   	leave
  801a67:	c3                   	ret

0000000000801a68 <close_all>:

void
close_all(void) {
  801a68:	f3 0f 1e fa          	endbr64
  801a6c:	55                   	push   %rbp
  801a6d:	48 89 e5             	mov    %rsp,%rbp
  801a70:	41 54                	push   %r12
  801a72:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  801a73:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a78:	49 bc 31 1a 80 00 00 	movabs $0x801a31,%r12
  801a7f:	00 00 00 
  801a82:	89 df                	mov    %ebx,%edi
  801a84:	41 ff d4             	call   *%r12
  801a87:	83 c3 01             	add    $0x1,%ebx
  801a8a:	83 fb 20             	cmp    $0x20,%ebx
  801a8d:	75 f3                	jne    801a82 <close_all+0x1a>
}
  801a8f:	5b                   	pop    %rbx
  801a90:	41 5c                	pop    %r12
  801a92:	5d                   	pop    %rbp
  801a93:	c3                   	ret

0000000000801a94 <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  801a94:	f3 0f 1e fa          	endbr64
  801a98:	55                   	push   %rbp
  801a99:	48 89 e5             	mov    %rsp,%rbp
  801a9c:	41 57                	push   %r15
  801a9e:	41 56                	push   %r14
  801aa0:	41 55                	push   %r13
  801aa2:	41 54                	push   %r12
  801aa4:	53                   	push   %rbx
  801aa5:	48 83 ec 18          	sub    $0x18,%rsp
  801aa9:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  801aac:	48 8d 75 c8          	lea    -0x38(%rbp),%rsi
  801ab0:	48 b8 c0 18 80 00 00 	movabs $0x8018c0,%rax
  801ab7:	00 00 00 
  801aba:	ff d0                	call   *%rax
  801abc:	89 c3                	mov    %eax,%ebx
  801abe:	85 c0                	test   %eax,%eax
  801ac0:	0f 88 b8 00 00 00    	js     801b7e <dup+0xea>
    close(newfdnum);
  801ac6:	44 89 e7             	mov    %r12d,%edi
  801ac9:	48 b8 31 1a 80 00 00 	movabs $0x801a31,%rax
  801ad0:	00 00 00 
  801ad3:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  801ad5:	4d 63 ec             	movslq %r12d,%r13
  801ad8:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  801adf:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  801ae3:	4c 8b 7d c8          	mov    -0x38(%rbp),%r15
  801ae7:	4c 89 ff             	mov    %r15,%rdi
  801aea:	49 be 3c 18 80 00 00 	movabs $0x80183c,%r14
  801af1:	00 00 00 
  801af4:	41 ff d6             	call   *%r14
  801af7:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  801afa:	4c 89 ef             	mov    %r13,%rdi
  801afd:	41 ff d6             	call   *%r14
  801b00:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  801b03:	48 89 df             	mov    %rbx,%rdi
  801b06:	48 b8 bb 29 80 00 00 	movabs $0x8029bb,%rax
  801b0d:	00 00 00 
  801b10:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  801b12:	a8 04                	test   $0x4,%al
  801b14:	74 2b                	je     801b41 <dup+0xad>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  801b16:	41 89 c1             	mov    %eax,%r9d
  801b19:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801b1f:	4c 89 f1             	mov    %r14,%rcx
  801b22:	ba 00 00 00 00       	mov    $0x0,%edx
  801b27:	48 89 de             	mov    %rbx,%rsi
  801b2a:	bf 00 00 00 00       	mov    $0x0,%edi
  801b2f:	48 b8 cd 14 80 00 00 	movabs $0x8014cd,%rax
  801b36:	00 00 00 
  801b39:	ff d0                	call   *%rax
  801b3b:	89 c3                	mov    %eax,%ebx
  801b3d:	85 c0                	test   %eax,%eax
  801b3f:	78 4e                	js     801b8f <dup+0xfb>
    }
    prot = get_prot(oldfd);
  801b41:	4c 89 ff             	mov    %r15,%rdi
  801b44:	48 b8 bb 29 80 00 00 	movabs $0x8029bb,%rax
  801b4b:	00 00 00 
  801b4e:	ff d0                	call   *%rax
  801b50:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  801b53:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  801b59:	4c 89 e9             	mov    %r13,%rcx
  801b5c:	ba 00 00 00 00       	mov    $0x0,%edx
  801b61:	4c 89 fe             	mov    %r15,%rsi
  801b64:	bf 00 00 00 00       	mov    $0x0,%edi
  801b69:	48 b8 cd 14 80 00 00 	movabs $0x8014cd,%rax
  801b70:	00 00 00 
  801b73:	ff d0                	call   *%rax
  801b75:	89 c3                	mov    %eax,%ebx
  801b77:	85 c0                	test   %eax,%eax
  801b79:	78 14                	js     801b8f <dup+0xfb>

    return newfdnum;
  801b7b:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  801b7e:	89 d8                	mov    %ebx,%eax
  801b80:	48 83 c4 18          	add    $0x18,%rsp
  801b84:	5b                   	pop    %rbx
  801b85:	41 5c                	pop    %r12
  801b87:	41 5d                	pop    %r13
  801b89:	41 5e                	pop    %r14
  801b8b:	41 5f                	pop    %r15
  801b8d:	5d                   	pop    %rbp
  801b8e:	c3                   	ret
    sys_unmap_region(0, newfd, PAGE_SIZE);
  801b8f:	ba 00 10 00 00       	mov    $0x1000,%edx
  801b94:	4c 89 ee             	mov    %r13,%rsi
  801b97:	bf 00 00 00 00       	mov    $0x0,%edi
  801b9c:	49 bc a2 15 80 00 00 	movabs $0x8015a2,%r12
  801ba3:	00 00 00 
  801ba6:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  801ba9:	ba 00 10 00 00       	mov    $0x1000,%edx
  801bae:	4c 89 f6             	mov    %r14,%rsi
  801bb1:	bf 00 00 00 00       	mov    $0x0,%edi
  801bb6:	41 ff d4             	call   *%r12
    return res;
  801bb9:	eb c3                	jmp    801b7e <dup+0xea>

0000000000801bbb <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  801bbb:	f3 0f 1e fa          	endbr64
  801bbf:	55                   	push   %rbp
  801bc0:	48 89 e5             	mov    %rsp,%rbp
  801bc3:	41 56                	push   %r14
  801bc5:	41 55                	push   %r13
  801bc7:	41 54                	push   %r12
  801bc9:	53                   	push   %rbx
  801bca:	48 83 ec 10          	sub    $0x10,%rsp
  801bce:	89 fb                	mov    %edi,%ebx
  801bd0:	49 89 f4             	mov    %rsi,%r12
  801bd3:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801bd6:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801bda:	48 b8 c0 18 80 00 00 	movabs $0x8018c0,%rax
  801be1:	00 00 00 
  801be4:	ff d0                	call   *%rax
  801be6:	85 c0                	test   %eax,%eax
  801be8:	78 4c                	js     801c36 <read+0x7b>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801bea:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801bee:	41 8b 3e             	mov    (%r14),%edi
  801bf1:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801bf5:	48 b8 0f 19 80 00 00 	movabs $0x80190f,%rax
  801bfc:	00 00 00 
  801bff:	ff d0                	call   *%rax
  801c01:	85 c0                	test   %eax,%eax
  801c03:	78 35                	js     801c3a <read+0x7f>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801c05:	41 8b 46 08          	mov    0x8(%r14),%eax
  801c09:	83 e0 03             	and    $0x3,%eax
  801c0c:	83 f8 01             	cmp    $0x1,%eax
  801c0f:	74 2d                	je     801c3e <read+0x83>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  801c11:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801c15:	48 8b 40 10          	mov    0x10(%rax),%rax
  801c19:	48 85 c0             	test   %rax,%rax
  801c1c:	74 56                	je     801c74 <read+0xb9>

    return (*dev->dev_read)(fd, buf, n);
  801c1e:	4c 89 ea             	mov    %r13,%rdx
  801c21:	4c 89 e6             	mov    %r12,%rsi
  801c24:	4c 89 f7             	mov    %r14,%rdi
  801c27:	ff d0                	call   *%rax
}
  801c29:	48 83 c4 10          	add    $0x10,%rsp
  801c2d:	5b                   	pop    %rbx
  801c2e:	41 5c                	pop    %r12
  801c30:	41 5d                	pop    %r13
  801c32:	41 5e                	pop    %r14
  801c34:	5d                   	pop    %rbp
  801c35:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801c36:	48 98                	cltq
  801c38:	eb ef                	jmp    801c29 <read+0x6e>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801c3a:	48 98                	cltq
  801c3c:	eb eb                	jmp    801c29 <read+0x6e>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801c3e:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801c45:	00 00 00 
  801c48:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801c4e:	89 da                	mov    %ebx,%edx
  801c50:	48 bf cf 31 80 00 00 	movabs $0x8031cf,%rdi
  801c57:	00 00 00 
  801c5a:	b8 00 00 00 00       	mov    $0x0,%eax
  801c5f:	48 b9 14 05 80 00 00 	movabs $0x800514,%rcx
  801c66:	00 00 00 
  801c69:	ff d1                	call   *%rcx
        return -E_INVAL;
  801c6b:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801c72:	eb b5                	jmp    801c29 <read+0x6e>
    if (!dev->dev_read) return -E_NOT_SUPP;
  801c74:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801c7b:	eb ac                	jmp    801c29 <read+0x6e>

0000000000801c7d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  801c7d:	f3 0f 1e fa          	endbr64
  801c81:	55                   	push   %rbp
  801c82:	48 89 e5             	mov    %rsp,%rbp
  801c85:	41 57                	push   %r15
  801c87:	41 56                	push   %r14
  801c89:	41 55                	push   %r13
  801c8b:	41 54                	push   %r12
  801c8d:	53                   	push   %rbx
  801c8e:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  801c92:	48 85 d2             	test   %rdx,%rdx
  801c95:	74 54                	je     801ceb <readn+0x6e>
  801c97:	41 89 fd             	mov    %edi,%r13d
  801c9a:	49 89 f6             	mov    %rsi,%r14
  801c9d:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  801ca0:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  801ca5:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  801caa:	49 bf bb 1b 80 00 00 	movabs $0x801bbb,%r15
  801cb1:	00 00 00 
  801cb4:	4c 89 e2             	mov    %r12,%rdx
  801cb7:	48 29 f2             	sub    %rsi,%rdx
  801cba:	4c 01 f6             	add    %r14,%rsi
  801cbd:	44 89 ef             	mov    %r13d,%edi
  801cc0:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  801cc3:	85 c0                	test   %eax,%eax
  801cc5:	78 20                	js     801ce7 <readn+0x6a>
    for (; inc && res < n; res += inc) {
  801cc7:	01 c3                	add    %eax,%ebx
  801cc9:	85 c0                	test   %eax,%eax
  801ccb:	74 08                	je     801cd5 <readn+0x58>
  801ccd:	48 63 f3             	movslq %ebx,%rsi
  801cd0:	4c 39 e6             	cmp    %r12,%rsi
  801cd3:	72 df                	jb     801cb4 <readn+0x37>
    }
    return res;
  801cd5:	48 63 c3             	movslq %ebx,%rax
}
  801cd8:	48 83 c4 08          	add    $0x8,%rsp
  801cdc:	5b                   	pop    %rbx
  801cdd:	41 5c                	pop    %r12
  801cdf:	41 5d                	pop    %r13
  801ce1:	41 5e                	pop    %r14
  801ce3:	41 5f                	pop    %r15
  801ce5:	5d                   	pop    %rbp
  801ce6:	c3                   	ret
        if (inc < 0) return inc;
  801ce7:	48 98                	cltq
  801ce9:	eb ed                	jmp    801cd8 <readn+0x5b>
    int inc = 1, res = 0;
  801ceb:	bb 00 00 00 00       	mov    $0x0,%ebx
  801cf0:	eb e3                	jmp    801cd5 <readn+0x58>

0000000000801cf2 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  801cf2:	f3 0f 1e fa          	endbr64
  801cf6:	55                   	push   %rbp
  801cf7:	48 89 e5             	mov    %rsp,%rbp
  801cfa:	41 56                	push   %r14
  801cfc:	41 55                	push   %r13
  801cfe:	41 54                	push   %r12
  801d00:	53                   	push   %rbx
  801d01:	48 83 ec 10          	sub    $0x10,%rsp
  801d05:	89 fb                	mov    %edi,%ebx
  801d07:	49 89 f4             	mov    %rsi,%r12
  801d0a:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801d0d:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801d11:	48 b8 c0 18 80 00 00 	movabs $0x8018c0,%rax
  801d18:	00 00 00 
  801d1b:	ff d0                	call   *%rax
  801d1d:	85 c0                	test   %eax,%eax
  801d1f:	78 47                	js     801d68 <write+0x76>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801d21:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  801d25:	41 8b 3e             	mov    (%r14),%edi
  801d28:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801d2c:	48 b8 0f 19 80 00 00 	movabs $0x80190f,%rax
  801d33:	00 00 00 
  801d36:	ff d0                	call   *%rax
  801d38:	85 c0                	test   %eax,%eax
  801d3a:	78 30                	js     801d6c <write+0x7a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801d3c:	41 f6 46 08 03       	testb  $0x3,0x8(%r14)
  801d41:	74 2d                	je     801d70 <write+0x7e>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  801d43:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d47:	48 8b 40 18          	mov    0x18(%rax),%rax
  801d4b:	48 85 c0             	test   %rax,%rax
  801d4e:	74 56                	je     801da6 <write+0xb4>

    return (*dev->dev_write)(fd, buf, n);
  801d50:	4c 89 ea             	mov    %r13,%rdx
  801d53:	4c 89 e6             	mov    %r12,%rsi
  801d56:	4c 89 f7             	mov    %r14,%rdi
  801d59:	ff d0                	call   *%rax
}
  801d5b:	48 83 c4 10          	add    $0x10,%rsp
  801d5f:	5b                   	pop    %rbx
  801d60:	41 5c                	pop    %r12
  801d62:	41 5d                	pop    %r13
  801d64:	41 5e                	pop    %r14
  801d66:	5d                   	pop    %rbp
  801d67:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801d68:	48 98                	cltq
  801d6a:	eb ef                	jmp    801d5b <write+0x69>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801d6c:	48 98                	cltq
  801d6e:	eb eb                	jmp    801d5b <write+0x69>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801d70:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801d77:	00 00 00 
  801d7a:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  801d80:	89 da                	mov    %ebx,%edx
  801d82:	48 bf eb 31 80 00 00 	movabs $0x8031eb,%rdi
  801d89:	00 00 00 
  801d8c:	b8 00 00 00 00       	mov    $0x0,%eax
  801d91:	48 b9 14 05 80 00 00 	movabs $0x800514,%rcx
  801d98:	00 00 00 
  801d9b:	ff d1                	call   *%rcx
        return -E_INVAL;
  801d9d:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  801da4:	eb b5                	jmp    801d5b <write+0x69>
    if (!dev->dev_write) return -E_NOT_SUPP;
  801da6:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  801dad:	eb ac                	jmp    801d5b <write+0x69>

0000000000801daf <seek>:

int
seek(int fdnum, off_t offset) {
  801daf:	f3 0f 1e fa          	endbr64
  801db3:	55                   	push   %rbp
  801db4:	48 89 e5             	mov    %rsp,%rbp
  801db7:	53                   	push   %rbx
  801db8:	48 83 ec 18          	sub    $0x18,%rsp
  801dbc:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801dbe:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801dc2:	48 b8 c0 18 80 00 00 	movabs $0x8018c0,%rax
  801dc9:	00 00 00 
  801dcc:	ff d0                	call   *%rax
  801dce:	85 c0                	test   %eax,%eax
  801dd0:	78 0c                	js     801dde <seek+0x2f>

    fd->fd_offset = offset;
  801dd2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dd6:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  801dd9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dde:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801de2:	c9                   	leave
  801de3:	c3                   	ret

0000000000801de4 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  801de4:	f3 0f 1e fa          	endbr64
  801de8:	55                   	push   %rbp
  801de9:	48 89 e5             	mov    %rsp,%rbp
  801dec:	41 55                	push   %r13
  801dee:	41 54                	push   %r12
  801df0:	53                   	push   %rbx
  801df1:	48 83 ec 18          	sub    $0x18,%rsp
  801df5:	89 fb                	mov    %edi,%ebx
  801df7:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801dfa:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  801dfe:	48 b8 c0 18 80 00 00 	movabs $0x8018c0,%rax
  801e05:	00 00 00 
  801e08:	ff d0                	call   *%rax
  801e0a:	85 c0                	test   %eax,%eax
  801e0c:	78 38                	js     801e46 <ftruncate+0x62>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801e0e:	4c 8b 6d d8          	mov    -0x28(%rbp),%r13
  801e12:	41 8b 7d 00          	mov    0x0(%r13),%edi
  801e16:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  801e1a:	48 b8 0f 19 80 00 00 	movabs $0x80190f,%rax
  801e21:	00 00 00 
  801e24:	ff d0                	call   *%rax
  801e26:	85 c0                	test   %eax,%eax
  801e28:	78 1c                	js     801e46 <ftruncate+0x62>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801e2a:	41 f6 45 08 03       	testb  $0x3,0x8(%r13)
  801e2f:	74 20                	je     801e51 <ftruncate+0x6d>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801e31:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801e35:	48 8b 40 30          	mov    0x30(%rax),%rax
  801e39:	48 85 c0             	test   %rax,%rax
  801e3c:	74 47                	je     801e85 <ftruncate+0xa1>

    return (*dev->dev_trunc)(fd, newsize);
  801e3e:	44 89 e6             	mov    %r12d,%esi
  801e41:	4c 89 ef             	mov    %r13,%rdi
  801e44:	ff d0                	call   *%rax
}
  801e46:	48 83 c4 18          	add    $0x18,%rsp
  801e4a:	5b                   	pop    %rbx
  801e4b:	41 5c                	pop    %r12
  801e4d:	41 5d                	pop    %r13
  801e4f:	5d                   	pop    %rbp
  801e50:	c3                   	ret
                thisenv->env_id, fdnum);
  801e51:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  801e58:	00 00 00 
  801e5b:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  801e61:	89 da                	mov    %ebx,%edx
  801e63:	48 bf 40 36 80 00 00 	movabs $0x803640,%rdi
  801e6a:	00 00 00 
  801e6d:	b8 00 00 00 00       	mov    $0x0,%eax
  801e72:	48 b9 14 05 80 00 00 	movabs $0x800514,%rcx
  801e79:	00 00 00 
  801e7c:	ff d1                	call   *%rcx
        return -E_INVAL;
  801e7e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e83:	eb c1                	jmp    801e46 <ftruncate+0x62>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  801e85:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801e8a:	eb ba                	jmp    801e46 <ftruncate+0x62>

0000000000801e8c <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  801e8c:	f3 0f 1e fa          	endbr64
  801e90:	55                   	push   %rbp
  801e91:	48 89 e5             	mov    %rsp,%rbp
  801e94:	41 54                	push   %r12
  801e96:	53                   	push   %rbx
  801e97:	48 83 ec 10          	sub    $0x10,%rsp
  801e9b:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  801e9e:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801ea2:	48 b8 c0 18 80 00 00 	movabs $0x8018c0,%rax
  801ea9:	00 00 00 
  801eac:	ff d0                	call   *%rax
  801eae:	85 c0                	test   %eax,%eax
  801eb0:	78 4e                	js     801f00 <fstat+0x74>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  801eb2:	4c 8b 65 e8          	mov    -0x18(%rbp),%r12
  801eb6:	41 8b 3c 24          	mov    (%r12),%edi
  801eba:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  801ebe:	48 b8 0f 19 80 00 00 	movabs $0x80190f,%rax
  801ec5:	00 00 00 
  801ec8:	ff d0                	call   *%rax
  801eca:	85 c0                	test   %eax,%eax
  801ecc:	78 32                	js     801f00 <fstat+0x74>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  801ece:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ed2:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  801ed7:	74 30                	je     801f09 <fstat+0x7d>

    stat->st_name[0] = 0;
  801ed9:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  801edc:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  801ee3:	00 00 00 
    stat->st_isdir = 0;
  801ee6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  801eed:	00 00 00 
    stat->st_dev = dev;
  801ef0:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  801ef7:	48 89 de             	mov    %rbx,%rsi
  801efa:	4c 89 e7             	mov    %r12,%rdi
  801efd:	ff 50 28             	call   *0x28(%rax)
}
  801f00:	48 83 c4 10          	add    $0x10,%rsp
  801f04:	5b                   	pop    %rbx
  801f05:	41 5c                	pop    %r12
  801f07:	5d                   	pop    %rbp
  801f08:	c3                   	ret
    if (!dev->dev_stat) return -E_NOT_SUPP;
  801f09:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  801f0e:	eb f0                	jmp    801f00 <fstat+0x74>

0000000000801f10 <stat>:

int
stat(const char *path, struct Stat *stat) {
  801f10:	f3 0f 1e fa          	endbr64
  801f14:	55                   	push   %rbp
  801f15:	48 89 e5             	mov    %rsp,%rbp
  801f18:	41 54                	push   %r12
  801f1a:	53                   	push   %rbx
  801f1b:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  801f1e:	be 00 00 00 00       	mov    $0x0,%esi
  801f23:	48 b8 f1 21 80 00 00 	movabs $0x8021f1,%rax
  801f2a:	00 00 00 
  801f2d:	ff d0                	call   *%rax
  801f2f:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  801f31:	85 c0                	test   %eax,%eax
  801f33:	78 25                	js     801f5a <stat+0x4a>

    int res = fstat(fd, stat);
  801f35:	4c 89 e6             	mov    %r12,%rsi
  801f38:	89 c7                	mov    %eax,%edi
  801f3a:	48 b8 8c 1e 80 00 00 	movabs $0x801e8c,%rax
  801f41:	00 00 00 
  801f44:	ff d0                	call   *%rax
  801f46:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  801f49:	89 df                	mov    %ebx,%edi
  801f4b:	48 b8 31 1a 80 00 00 	movabs $0x801a31,%rax
  801f52:	00 00 00 
  801f55:	ff d0                	call   *%rax

    return res;
  801f57:	44 89 e3             	mov    %r12d,%ebx
}
  801f5a:	89 d8                	mov    %ebx,%eax
  801f5c:	5b                   	pop    %rbx
  801f5d:	41 5c                	pop    %r12
  801f5f:	5d                   	pop    %rbp
  801f60:	c3                   	ret

0000000000801f61 <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  801f61:	f3 0f 1e fa          	endbr64
  801f65:	55                   	push   %rbp
  801f66:	48 89 e5             	mov    %rsp,%rbp
  801f69:	41 54                	push   %r12
  801f6b:	53                   	push   %rbx
  801f6c:	48 83 ec 10          	sub    $0x10,%rsp
  801f70:	41 89 fc             	mov    %edi,%r12d
  801f73:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801f76:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801f7d:	00 00 00 
  801f80:	83 38 00             	cmpl   $0x0,(%rax)
  801f83:	74 6e                	je     801ff3 <fsipc+0x92>

    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }
    fsenv = ipc_find_env(ENV_TYPE_FS);
  801f85:	bf 03 00 00 00       	mov    $0x3,%edi
  801f8a:	48 b8 8f 2f 80 00 00 	movabs $0x802f8f,%rax
  801f91:	00 00 00 
  801f94:	ff d0                	call   *%rax
  801f96:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  801f9d:	00 00 
    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  801f9f:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  801fa5:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801faa:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  801fb1:	00 00 00 
  801fb4:	44 89 e6             	mov    %r12d,%esi
  801fb7:	89 c7                	mov    %eax,%edi
  801fb9:	48 b8 cd 2e 80 00 00 	movabs $0x802ecd,%rax
  801fc0:	00 00 00 
  801fc3:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  801fc5:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  801fcc:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  801fcd:	b9 00 00 00 00       	mov    $0x0,%ecx
  801fd2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801fd6:	48 89 de             	mov    %rbx,%rsi
  801fd9:	bf 00 00 00 00       	mov    $0x0,%edi
  801fde:	48 b8 34 2e 80 00 00 	movabs $0x802e34,%rax
  801fe5:	00 00 00 
  801fe8:	ff d0                	call   *%rax
}
  801fea:	48 83 c4 10          	add    $0x10,%rsp
  801fee:	5b                   	pop    %rbx
  801fef:	41 5c                	pop    %r12
  801ff1:	5d                   	pop    %rbp
  801ff2:	c3                   	ret
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  801ff3:	bf 03 00 00 00       	mov    $0x3,%edi
  801ff8:	48 b8 8f 2f 80 00 00 	movabs $0x802f8f,%rax
  801fff:	00 00 00 
  802002:	ff d0                	call   *%rax
  802004:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  80200b:	00 00 
  80200d:	e9 73 ff ff ff       	jmp    801f85 <fsipc+0x24>

0000000000802012 <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  802012:	f3 0f 1e fa          	endbr64
  802016:	55                   	push   %rbp
  802017:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80201a:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  802021:	00 00 00 
  802024:	8b 57 0c             	mov    0xc(%rdi),%edx
  802027:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  802029:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  80202c:	be 00 00 00 00       	mov    $0x0,%esi
  802031:	bf 02 00 00 00       	mov    $0x2,%edi
  802036:	48 b8 61 1f 80 00 00 	movabs $0x801f61,%rax
  80203d:	00 00 00 
  802040:	ff d0                	call   *%rax
}
  802042:	5d                   	pop    %rbp
  802043:	c3                   	ret

0000000000802044 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  802044:	f3 0f 1e fa          	endbr64
  802048:	55                   	push   %rbp
  802049:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80204c:	8b 47 0c             	mov    0xc(%rdi),%eax
  80204f:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  802056:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  802058:	be 00 00 00 00       	mov    $0x0,%esi
  80205d:	bf 06 00 00 00       	mov    $0x6,%edi
  802062:	48 b8 61 1f 80 00 00 	movabs $0x801f61,%rax
  802069:	00 00 00 
  80206c:	ff d0                	call   *%rax
}
  80206e:	5d                   	pop    %rbp
  80206f:	c3                   	ret

0000000000802070 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  802070:	f3 0f 1e fa          	endbr64
  802074:	55                   	push   %rbp
  802075:	48 89 e5             	mov    %rsp,%rbp
  802078:	41 54                	push   %r12
  80207a:	53                   	push   %rbx
  80207b:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80207e:	8b 47 0c             	mov    0xc(%rdi),%eax
  802081:	a3 00 60 80 00 00 00 	movabs %eax,0x806000
  802088:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  80208a:	be 00 00 00 00       	mov    $0x0,%esi
  80208f:	bf 05 00 00 00       	mov    $0x5,%edi
  802094:	48 b8 61 1f 80 00 00 	movabs $0x801f61,%rax
  80209b:	00 00 00 
  80209e:	ff d0                	call   *%rax
    if (res < 0) return res;
  8020a0:	85 c0                	test   %eax,%eax
  8020a2:	78 3d                	js     8020e1 <devfile_stat+0x71>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8020a4:	49 bc 00 60 80 00 00 	movabs $0x806000,%r12
  8020ab:	00 00 00 
  8020ae:	4c 89 e6             	mov    %r12,%rsi
  8020b1:	48 89 df             	mov    %rbx,%rdi
  8020b4:	48 b8 5d 0e 80 00 00 	movabs $0x800e5d,%rax
  8020bb:	00 00 00 
  8020be:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  8020c0:	41 8b 84 24 80 00 00 	mov    0x80(%r12),%eax
  8020c7:	00 
  8020c8:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8020ce:	41 8b 84 24 84 00 00 	mov    0x84(%r12),%eax
  8020d5:	00 
  8020d6:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  8020dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020e1:	5b                   	pop    %rbx
  8020e2:	41 5c                	pop    %r12
  8020e4:	5d                   	pop    %rbp
  8020e5:	c3                   	ret

00000000008020e6 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  8020e6:	f3 0f 1e fa          	endbr64
    if (n >= sizeof(fsipcbuf.write.req_buf)) {
  8020ea:	48 81 fa ef 0f 00 00 	cmp    $0xfef,%rdx
  8020f1:	77 41                	ja     802134 <devfile_write+0x4e>
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  8020f3:	55                   	push   %rbp
  8020f4:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  8020f7:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8020fe:	00 00 00 
  802101:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  802104:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.write.req_n = n;
  802106:	48 89 50 08          	mov    %rdx,0x8(%rax)
    memmove(fsipcbuf.write.req_buf, buf, n);
  80210a:	48 8d 78 10          	lea    0x10(%rax),%rdi
  80210e:	48 b8 78 10 80 00 00 	movabs $0x801078,%rax
  802115:	00 00 00 
  802118:	ff d0                	call   *%rax
    res = fsipc(FSREQ_WRITE, NULL);
  80211a:	be 00 00 00 00       	mov    $0x0,%esi
  80211f:	bf 04 00 00 00       	mov    $0x4,%edi
  802124:	48 b8 61 1f 80 00 00 	movabs $0x801f61,%rax
  80212b:	00 00 00 
  80212e:	ff d0                	call   *%rax
  802130:	48 98                	cltq
}
  802132:	5d                   	pop    %rbp
  802133:	c3                   	ret
        return -E_INVAL;
  802134:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
}
  80213b:	c3                   	ret

000000000080213c <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  80213c:	f3 0f 1e fa          	endbr64
  802140:	55                   	push   %rbp
  802141:	48 89 e5             	mov    %rsp,%rbp
  802144:	41 55                	push   %r13
  802146:	41 54                	push   %r12
  802148:	53                   	push   %rbx
  802149:	48 83 ec 08          	sub    $0x8,%rsp
  80214d:	49 89 f4             	mov    %rsi,%r12
  802150:	48 89 d3             	mov    %rdx,%rbx
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  802153:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80215a:	00 00 00 
  80215d:	8b 57 0c             	mov    0xc(%rdi),%edx
  802160:	89 10                	mov    %edx,(%rax)
    fsipcbuf.read.req_n = n;
  802162:	48 89 58 08          	mov    %rbx,0x8(%rax)
    res = fsipc(FSREQ_READ, NULL);
  802166:	be 00 00 00 00       	mov    $0x0,%esi
  80216b:	bf 03 00 00 00       	mov    $0x3,%edi
  802170:	48 b8 61 1f 80 00 00 	movabs $0x801f61,%rax
  802177:	00 00 00 
  80217a:	ff d0                	call   *%rax
  80217c:	4c 63 e8             	movslq %eax,%r13
    if (res < 0) {
  80217f:	4d 85 ed             	test   %r13,%r13
  802182:	78 2a                	js     8021ae <devfile_read+0x72>
    assert(res <= n && res <= PAGE_SIZE);
  802184:	4c 89 ea             	mov    %r13,%rdx
  802187:	4c 39 eb             	cmp    %r13,%rbx
  80218a:	72 30                	jb     8021bc <devfile_read+0x80>
  80218c:	49 81 fd 00 10 00 00 	cmp    $0x1000,%r13
  802193:	7f 27                	jg     8021bc <devfile_read+0x80>
    memmove(buf, &fsipcbuf, res);
  802195:	48 be 00 60 80 00 00 	movabs $0x806000,%rsi
  80219c:	00 00 00 
  80219f:	4c 89 e7             	mov    %r12,%rdi
  8021a2:	48 b8 78 10 80 00 00 	movabs $0x801078,%rax
  8021a9:	00 00 00 
  8021ac:	ff d0                	call   *%rax
}
  8021ae:	4c 89 e8             	mov    %r13,%rax
  8021b1:	48 83 c4 08          	add    $0x8,%rsp
  8021b5:	5b                   	pop    %rbx
  8021b6:	41 5c                	pop    %r12
  8021b8:	41 5d                	pop    %r13
  8021ba:	5d                   	pop    %rbp
  8021bb:	c3                   	ret
    assert(res <= n && res <= PAGE_SIZE);
  8021bc:	48 b9 08 32 80 00 00 	movabs $0x803208,%rcx
  8021c3:	00 00 00 
  8021c6:	48 ba 25 32 80 00 00 	movabs $0x803225,%rdx
  8021cd:	00 00 00 
  8021d0:	be 7b 00 00 00       	mov    $0x7b,%esi
  8021d5:	48 bf 3a 32 80 00 00 	movabs $0x80323a,%rdi
  8021dc:	00 00 00 
  8021df:	b8 00 00 00 00       	mov    $0x0,%eax
  8021e4:	49 b8 8d 2d 80 00 00 	movabs $0x802d8d,%r8
  8021eb:	00 00 00 
  8021ee:	41 ff d0             	call   *%r8

00000000008021f1 <open>:
open(const char *path, int mode) {
  8021f1:	f3 0f 1e fa          	endbr64
  8021f5:	55                   	push   %rbp
  8021f6:	48 89 e5             	mov    %rsp,%rbp
  8021f9:	41 55                	push   %r13
  8021fb:	41 54                	push   %r12
  8021fd:	53                   	push   %rbx
  8021fe:	48 83 ec 18          	sub    $0x18,%rsp
  802202:	49 89 fc             	mov    %rdi,%r12
  802205:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  802208:	48 b8 18 0e 80 00 00 	movabs $0x800e18,%rax
  80220f:	00 00 00 
  802212:	ff d0                	call   *%rax
  802214:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  80221a:	0f 87 8a 00 00 00    	ja     8022aa <open+0xb9>
    if ((res = fd_alloc(&fd)) < 0) return res;
  802220:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802224:	48 b8 5c 18 80 00 00 	movabs $0x80185c,%rax
  80222b:	00 00 00 
  80222e:	ff d0                	call   *%rax
  802230:	89 c3                	mov    %eax,%ebx
  802232:	85 c0                	test   %eax,%eax
  802234:	78 50                	js     802286 <open+0x95>
    strcpy(fsipcbuf.open.req_path, path);
  802236:	4c 89 e6             	mov    %r12,%rsi
  802239:	48 bb 00 60 80 00 00 	movabs $0x806000,%rbx
  802240:	00 00 00 
  802243:	48 89 df             	mov    %rbx,%rdi
  802246:	48 b8 5d 0e 80 00 00 	movabs $0x800e5d,%rax
  80224d:	00 00 00 
  802250:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  802252:	44 89 ab 00 04 00 00 	mov    %r13d,0x400(%rbx)
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  802259:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80225d:	bf 01 00 00 00       	mov    $0x1,%edi
  802262:	48 b8 61 1f 80 00 00 	movabs $0x801f61,%rax
  802269:	00 00 00 
  80226c:	ff d0                	call   *%rax
  80226e:	89 c3                	mov    %eax,%ebx
  802270:	85 c0                	test   %eax,%eax
  802272:	78 1f                	js     802293 <open+0xa2>
    return fd2num(fd);
  802274:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802278:	48 b8 26 18 80 00 00 	movabs $0x801826,%rax
  80227f:	00 00 00 
  802282:	ff d0                	call   *%rax
  802284:	89 c3                	mov    %eax,%ebx
}
  802286:	89 d8                	mov    %ebx,%eax
  802288:	48 83 c4 18          	add    $0x18,%rsp
  80228c:	5b                   	pop    %rbx
  80228d:	41 5c                	pop    %r12
  80228f:	41 5d                	pop    %r13
  802291:	5d                   	pop    %rbp
  802292:	c3                   	ret
        fd_close(fd, 0);
  802293:	be 00 00 00 00       	mov    $0x0,%esi
  802298:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80229c:	48 b8 83 19 80 00 00 	movabs $0x801983,%rax
  8022a3:	00 00 00 
  8022a6:	ff d0                	call   *%rax
        return res;
  8022a8:	eb dc                	jmp    802286 <open+0x95>
        return -E_BAD_PATH;
  8022aa:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  8022af:	eb d5                	jmp    802286 <open+0x95>

00000000008022b1 <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  8022b1:	f3 0f 1e fa          	endbr64
  8022b5:	55                   	push   %rbp
  8022b6:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  8022b9:	be 00 00 00 00       	mov    $0x0,%esi
  8022be:	bf 08 00 00 00       	mov    $0x8,%edi
  8022c3:	48 b8 61 1f 80 00 00 	movabs $0x801f61,%rax
  8022ca:	00 00 00 
  8022cd:	ff d0                	call   *%rax
}
  8022cf:	5d                   	pop    %rbp
  8022d0:	c3                   	ret

00000000008022d1 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  8022d1:	f3 0f 1e fa          	endbr64
  8022d5:	55                   	push   %rbp
  8022d6:	48 89 e5             	mov    %rsp,%rbp
  8022d9:	41 54                	push   %r12
  8022db:	53                   	push   %rbx
  8022dc:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8022df:	48 b8 3c 18 80 00 00 	movabs $0x80183c,%rax
  8022e6:	00 00 00 
  8022e9:	ff d0                	call   *%rax
  8022eb:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  8022ee:	48 be 45 32 80 00 00 	movabs $0x803245,%rsi
  8022f5:	00 00 00 
  8022f8:	48 89 df             	mov    %rbx,%rdi
  8022fb:	48 b8 5d 0e 80 00 00 	movabs $0x800e5d,%rax
  802302:	00 00 00 
  802305:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  802307:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  80230c:	41 2b 04 24          	sub    (%r12),%eax
  802310:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  802316:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  80231d:	00 00 00 
    stat->st_dev = &devpipe;
  802320:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  802327:	00 00 00 
  80232a:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  802331:	b8 00 00 00 00       	mov    $0x0,%eax
  802336:	5b                   	pop    %rbx
  802337:	41 5c                	pop    %r12
  802339:	5d                   	pop    %rbp
  80233a:	c3                   	ret

000000000080233b <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  80233b:	f3 0f 1e fa          	endbr64
  80233f:	55                   	push   %rbp
  802340:	48 89 e5             	mov    %rsp,%rbp
  802343:	41 54                	push   %r12
  802345:	53                   	push   %rbx
  802346:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  802349:	ba 00 10 00 00       	mov    $0x1000,%edx
  80234e:	48 89 fe             	mov    %rdi,%rsi
  802351:	bf 00 00 00 00       	mov    $0x0,%edi
  802356:	49 bc a2 15 80 00 00 	movabs $0x8015a2,%r12
  80235d:	00 00 00 
  802360:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  802363:	48 89 df             	mov    %rbx,%rdi
  802366:	48 b8 3c 18 80 00 00 	movabs $0x80183c,%rax
  80236d:	00 00 00 
  802370:	ff d0                	call   *%rax
  802372:	48 89 c6             	mov    %rax,%rsi
  802375:	ba 00 10 00 00       	mov    $0x1000,%edx
  80237a:	bf 00 00 00 00       	mov    $0x0,%edi
  80237f:	41 ff d4             	call   *%r12
}
  802382:	5b                   	pop    %rbx
  802383:	41 5c                	pop    %r12
  802385:	5d                   	pop    %rbp
  802386:	c3                   	ret

0000000000802387 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  802387:	f3 0f 1e fa          	endbr64
  80238b:	55                   	push   %rbp
  80238c:	48 89 e5             	mov    %rsp,%rbp
  80238f:	41 57                	push   %r15
  802391:	41 56                	push   %r14
  802393:	41 55                	push   %r13
  802395:	41 54                	push   %r12
  802397:	53                   	push   %rbx
  802398:	48 83 ec 18          	sub    $0x18,%rsp
  80239c:	49 89 fc             	mov    %rdi,%r12
  80239f:	49 89 f5             	mov    %rsi,%r13
  8023a2:	49 89 d7             	mov    %rdx,%r15
  8023a5:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8023a9:	48 b8 3c 18 80 00 00 	movabs $0x80183c,%rax
  8023b0:	00 00 00 
  8023b3:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  8023b5:	4d 85 ff             	test   %r15,%r15
  8023b8:	0f 84 af 00 00 00    	je     80246d <devpipe_write+0xe6>
  8023be:	48 89 c3             	mov    %rax,%rbx
  8023c1:	4c 89 f8             	mov    %r15,%rax
  8023c4:	4d 89 ef             	mov    %r13,%r15
  8023c7:	4c 01 e8             	add    %r13,%rax
  8023ca:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8023ce:	49 bd 32 14 80 00 00 	movabs $0x801432,%r13
  8023d5:	00 00 00 
            sys_yield();
  8023d8:	49 be c7 13 80 00 00 	movabs $0x8013c7,%r14
  8023df:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8023e2:	8b 73 04             	mov    0x4(%rbx),%esi
  8023e5:	48 63 ce             	movslq %esi,%rcx
  8023e8:	48 63 03             	movslq (%rbx),%rax
  8023eb:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8023f1:	48 39 c1             	cmp    %rax,%rcx
  8023f4:	72 2e                	jb     802424 <devpipe_write+0x9d>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8023f6:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8023fb:	48 89 da             	mov    %rbx,%rdx
  8023fe:	be 00 10 00 00       	mov    $0x1000,%esi
  802403:	4c 89 e7             	mov    %r12,%rdi
  802406:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  802409:	85 c0                	test   %eax,%eax
  80240b:	74 66                	je     802473 <devpipe_write+0xec>
            sys_yield();
  80240d:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  802410:	8b 73 04             	mov    0x4(%rbx),%esi
  802413:	48 63 ce             	movslq %esi,%rcx
  802416:	48 63 03             	movslq (%rbx),%rax
  802419:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  80241f:	48 39 c1             	cmp    %rax,%rcx
  802422:	73 d2                	jae    8023f6 <devpipe_write+0x6f>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802424:	41 0f b6 3f          	movzbl (%r15),%edi
  802428:	48 89 ca             	mov    %rcx,%rdx
  80242b:	48 c1 ea 03          	shr    $0x3,%rdx
  80242f:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  802436:	08 10 20 
  802439:	48 f7 e2             	mul    %rdx
  80243c:	48 c1 ea 06          	shr    $0x6,%rdx
  802440:	48 89 d0             	mov    %rdx,%rax
  802443:	48 c1 e0 09          	shl    $0x9,%rax
  802447:	48 29 d0             	sub    %rdx,%rax
  80244a:	48 c1 e0 03          	shl    $0x3,%rax
  80244e:	48 29 c1             	sub    %rax,%rcx
  802451:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  802456:	83 c6 01             	add    $0x1,%esi
  802459:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  80245c:	49 83 c7 01          	add    $0x1,%r15
  802460:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802464:	49 39 c7             	cmp    %rax,%r15
  802467:	0f 85 75 ff ff ff    	jne    8023e2 <devpipe_write+0x5b>
    return n;
  80246d:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802471:	eb 05                	jmp    802478 <devpipe_write+0xf1>
            if (_pipeisclosed(fd, p)) return 0;
  802473:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802478:	48 83 c4 18          	add    $0x18,%rsp
  80247c:	5b                   	pop    %rbx
  80247d:	41 5c                	pop    %r12
  80247f:	41 5d                	pop    %r13
  802481:	41 5e                	pop    %r14
  802483:	41 5f                	pop    %r15
  802485:	5d                   	pop    %rbp
  802486:	c3                   	ret

0000000000802487 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  802487:	f3 0f 1e fa          	endbr64
  80248b:	55                   	push   %rbp
  80248c:	48 89 e5             	mov    %rsp,%rbp
  80248f:	41 57                	push   %r15
  802491:	41 56                	push   %r14
  802493:	41 55                	push   %r13
  802495:	41 54                	push   %r12
  802497:	53                   	push   %rbx
  802498:	48 83 ec 18          	sub    $0x18,%rsp
  80249c:	49 89 fc             	mov    %rdi,%r12
  80249f:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  8024a3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8024a7:	48 b8 3c 18 80 00 00 	movabs $0x80183c,%rax
  8024ae:	00 00 00 
  8024b1:	ff d0                	call   *%rax
  8024b3:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  8024b6:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8024bc:	49 bd 32 14 80 00 00 	movabs $0x801432,%r13
  8024c3:	00 00 00 
            sys_yield();
  8024c6:	49 be c7 13 80 00 00 	movabs $0x8013c7,%r14
  8024cd:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  8024d0:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8024d5:	74 7d                	je     802554 <devpipe_read+0xcd>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8024d7:	8b 03                	mov    (%rbx),%eax
  8024d9:	3b 43 04             	cmp    0x4(%rbx),%eax
  8024dc:	75 26                	jne    802504 <devpipe_read+0x7d>
            if (i > 0) return i;
  8024de:	4d 85 ff             	test   %r15,%r15
  8024e1:	75 77                	jne    80255a <devpipe_read+0xd3>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8024e3:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8024e8:	48 89 da             	mov    %rbx,%rdx
  8024eb:	be 00 10 00 00       	mov    $0x1000,%esi
  8024f0:	4c 89 e7             	mov    %r12,%rdi
  8024f3:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8024f6:	85 c0                	test   %eax,%eax
  8024f8:	74 72                	je     80256c <devpipe_read+0xe5>
            sys_yield();
  8024fa:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8024fd:	8b 03                	mov    (%rbx),%eax
  8024ff:	3b 43 04             	cmp    0x4(%rbx),%eax
  802502:	74 df                	je     8024e3 <devpipe_read+0x5c>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802504:	48 63 c8             	movslq %eax,%rcx
  802507:	48 89 ca             	mov    %rcx,%rdx
  80250a:	48 c1 ea 03          	shr    $0x3,%rdx
  80250e:	48 be 81 00 01 02 04 	movabs $0x2010080402010081,%rsi
  802515:	08 10 20 
  802518:	48 89 d0             	mov    %rdx,%rax
  80251b:	48 f7 e6             	mul    %rsi
  80251e:	48 c1 ea 06          	shr    $0x6,%rdx
  802522:	48 89 d0             	mov    %rdx,%rax
  802525:	48 c1 e0 09          	shl    $0x9,%rax
  802529:	48 29 d0             	sub    %rdx,%rax
  80252c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802533:	00 
  802534:	48 89 c8             	mov    %rcx,%rax
  802537:	48 29 d0             	sub    %rdx,%rax
  80253a:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  80253f:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  802543:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  802547:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  80254a:	49 83 c7 01          	add    $0x1,%r15
  80254e:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  802552:	75 83                	jne    8024d7 <devpipe_read+0x50>
    return n;
  802554:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802558:	eb 03                	jmp    80255d <devpipe_read+0xd6>
            if (i > 0) return i;
  80255a:	4c 89 f8             	mov    %r15,%rax
}
  80255d:	48 83 c4 18          	add    $0x18,%rsp
  802561:	5b                   	pop    %rbx
  802562:	41 5c                	pop    %r12
  802564:	41 5d                	pop    %r13
  802566:	41 5e                	pop    %r14
  802568:	41 5f                	pop    %r15
  80256a:	5d                   	pop    %rbp
  80256b:	c3                   	ret
            if (_pipeisclosed(fd, p)) return 0;
  80256c:	b8 00 00 00 00       	mov    $0x0,%eax
  802571:	eb ea                	jmp    80255d <devpipe_read+0xd6>

0000000000802573 <pipe>:
pipe(int pfd[2]) {
  802573:	f3 0f 1e fa          	endbr64
  802577:	55                   	push   %rbp
  802578:	48 89 e5             	mov    %rsp,%rbp
  80257b:	41 55                	push   %r13
  80257d:	41 54                	push   %r12
  80257f:	53                   	push   %rbx
  802580:	48 83 ec 18          	sub    $0x18,%rsp
  802584:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  802587:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  80258b:	48 b8 5c 18 80 00 00 	movabs $0x80185c,%rax
  802592:	00 00 00 
  802595:	ff d0                	call   *%rax
  802597:	89 c3                	mov    %eax,%ebx
  802599:	85 c0                	test   %eax,%eax
  80259b:	0f 88 a0 01 00 00    	js     802741 <pipe+0x1ce>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  8025a1:	b9 46 00 00 00       	mov    $0x46,%ecx
  8025a6:	ba 00 10 00 00       	mov    $0x1000,%edx
  8025ab:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8025af:	bf 00 00 00 00       	mov    $0x0,%edi
  8025b4:	48 b8 62 14 80 00 00 	movabs $0x801462,%rax
  8025bb:	00 00 00 
  8025be:	ff d0                	call   *%rax
  8025c0:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  8025c2:	85 c0                	test   %eax,%eax
  8025c4:	0f 88 77 01 00 00    	js     802741 <pipe+0x1ce>
    if ((res = fd_alloc(&fd1)) < 0 ||
  8025ca:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  8025ce:	48 b8 5c 18 80 00 00 	movabs $0x80185c,%rax
  8025d5:	00 00 00 
  8025d8:	ff d0                	call   *%rax
  8025da:	89 c3                	mov    %eax,%ebx
  8025dc:	85 c0                	test   %eax,%eax
  8025de:	0f 88 43 01 00 00    	js     802727 <pipe+0x1b4>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  8025e4:	b9 46 00 00 00       	mov    $0x46,%ecx
  8025e9:	ba 00 10 00 00       	mov    $0x1000,%edx
  8025ee:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8025f2:	bf 00 00 00 00       	mov    $0x0,%edi
  8025f7:	48 b8 62 14 80 00 00 	movabs $0x801462,%rax
  8025fe:	00 00 00 
  802601:	ff d0                	call   *%rax
  802603:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  802605:	85 c0                	test   %eax,%eax
  802607:	0f 88 1a 01 00 00    	js     802727 <pipe+0x1b4>
    va = fd2data(fd0);
  80260d:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802611:	48 b8 3c 18 80 00 00 	movabs $0x80183c,%rax
  802618:	00 00 00 
  80261b:	ff d0                	call   *%rax
  80261d:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  802620:	b9 46 00 00 00       	mov    $0x46,%ecx
  802625:	ba 00 10 00 00       	mov    $0x1000,%edx
  80262a:	48 89 c6             	mov    %rax,%rsi
  80262d:	bf 00 00 00 00       	mov    $0x0,%edi
  802632:	48 b8 62 14 80 00 00 	movabs $0x801462,%rax
  802639:	00 00 00 
  80263c:	ff d0                	call   *%rax
  80263e:	89 c3                	mov    %eax,%ebx
  802640:	85 c0                	test   %eax,%eax
  802642:	0f 88 c5 00 00 00    	js     80270d <pipe+0x19a>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  802648:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  80264c:	48 b8 3c 18 80 00 00 	movabs $0x80183c,%rax
  802653:	00 00 00 
  802656:	ff d0                	call   *%rax
  802658:	48 89 c1             	mov    %rax,%rcx
  80265b:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  802661:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  802667:	ba 00 00 00 00       	mov    $0x0,%edx
  80266c:	4c 89 ee             	mov    %r13,%rsi
  80266f:	bf 00 00 00 00       	mov    $0x0,%edi
  802674:	48 b8 cd 14 80 00 00 	movabs $0x8014cd,%rax
  80267b:	00 00 00 
  80267e:	ff d0                	call   *%rax
  802680:	89 c3                	mov    %eax,%ebx
  802682:	85 c0                	test   %eax,%eax
  802684:	78 6e                	js     8026f4 <pipe+0x181>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  802686:	be 00 10 00 00       	mov    $0x1000,%esi
  80268b:	4c 89 ef             	mov    %r13,%rdi
  80268e:	48 b8 fc 13 80 00 00 	movabs $0x8013fc,%rax
  802695:	00 00 00 
  802698:	ff d0                	call   *%rax
  80269a:	83 f8 02             	cmp    $0x2,%eax
  80269d:	0f 85 ab 00 00 00    	jne    80274e <pipe+0x1db>
    fd0->fd_dev_id = devpipe.dev_id;
  8026a3:	a1 60 40 80 00 00 00 	movabs 0x804060,%eax
  8026aa:	00 00 
  8026ac:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8026b0:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  8026b2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8026b6:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  8026bd:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8026c1:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  8026c3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026c7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  8026ce:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8026d2:	48 bb 26 18 80 00 00 	movabs $0x801826,%rbx
  8026d9:	00 00 00 
  8026dc:	ff d3                	call   *%rbx
  8026de:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  8026e2:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8026e6:	ff d3                	call   *%rbx
  8026e8:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  8026ed:	bb 00 00 00 00       	mov    $0x0,%ebx
  8026f2:	eb 4d                	jmp    802741 <pipe+0x1ce>
    sys_unmap_region(0, va, PAGE_SIZE);
  8026f4:	ba 00 10 00 00       	mov    $0x1000,%edx
  8026f9:	4c 89 ee             	mov    %r13,%rsi
  8026fc:	bf 00 00 00 00       	mov    $0x0,%edi
  802701:	48 b8 a2 15 80 00 00 	movabs $0x8015a2,%rax
  802708:	00 00 00 
  80270b:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  80270d:	ba 00 10 00 00       	mov    $0x1000,%edx
  802712:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802716:	bf 00 00 00 00       	mov    $0x0,%edi
  80271b:	48 b8 a2 15 80 00 00 	movabs $0x8015a2,%rax
  802722:	00 00 00 
  802725:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  802727:	ba 00 10 00 00       	mov    $0x1000,%edx
  80272c:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802730:	bf 00 00 00 00       	mov    $0x0,%edi
  802735:	48 b8 a2 15 80 00 00 	movabs $0x8015a2,%rax
  80273c:	00 00 00 
  80273f:	ff d0                	call   *%rax
}
  802741:	89 d8                	mov    %ebx,%eax
  802743:	48 83 c4 18          	add    $0x18,%rsp
  802747:	5b                   	pop    %rbx
  802748:	41 5c                	pop    %r12
  80274a:	41 5d                	pop    %r13
  80274c:	5d                   	pop    %rbp
  80274d:	c3                   	ret
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  80274e:	48 b9 68 36 80 00 00 	movabs $0x803668,%rcx
  802755:	00 00 00 
  802758:	48 ba 25 32 80 00 00 	movabs $0x803225,%rdx
  80275f:	00 00 00 
  802762:	be 2e 00 00 00       	mov    $0x2e,%esi
  802767:	48 bf 4c 32 80 00 00 	movabs $0x80324c,%rdi
  80276e:	00 00 00 
  802771:	b8 00 00 00 00       	mov    $0x0,%eax
  802776:	49 b8 8d 2d 80 00 00 	movabs $0x802d8d,%r8
  80277d:	00 00 00 
  802780:	41 ff d0             	call   *%r8

0000000000802783 <pipeisclosed>:
pipeisclosed(int fdnum) {
  802783:	f3 0f 1e fa          	endbr64
  802787:	55                   	push   %rbp
  802788:	48 89 e5             	mov    %rsp,%rbp
  80278b:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  80278f:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802793:	48 b8 c0 18 80 00 00 	movabs $0x8018c0,%rax
  80279a:	00 00 00 
  80279d:	ff d0                	call   *%rax
    if (res < 0) return res;
  80279f:	85 c0                	test   %eax,%eax
  8027a1:	78 35                	js     8027d8 <pipeisclosed+0x55>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  8027a3:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8027a7:	48 b8 3c 18 80 00 00 	movabs $0x80183c,%rax
  8027ae:	00 00 00 
  8027b1:	ff d0                	call   *%rax
  8027b3:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8027b6:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8027bb:	be 00 10 00 00       	mov    $0x1000,%esi
  8027c0:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8027c4:	48 b8 32 14 80 00 00 	movabs $0x801432,%rax
  8027cb:	00 00 00 
  8027ce:	ff d0                	call   *%rax
  8027d0:	85 c0                	test   %eax,%eax
  8027d2:	0f 94 c0             	sete   %al
  8027d5:	0f b6 c0             	movzbl %al,%eax
}
  8027d8:	c9                   	leave
  8027d9:	c3                   	ret

00000000008027da <get_uvpt_entry>:
extern volatile pde_t uvpd[];     /* VA of current page directory */
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
  8027da:	f3 0f 1e fa          	endbr64
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8027de:	48 89 f8             	mov    %rdi,%rax
  8027e1:	48 c1 e8 27          	shr    $0x27,%rax
  8027e5:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  8027ec:	7f 00 00 
  8027ef:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8027f3:	f6 c2 01             	test   $0x1,%dl
  8027f6:	74 6d                	je     802865 <get_uvpt_entry+0x8b>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8027f8:	48 89 f8             	mov    %rdi,%rax
  8027fb:	48 c1 e8 1e          	shr    $0x1e,%rax
  8027ff:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  802806:	7f 00 00 
  802809:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80280d:	f6 c2 01             	test   $0x1,%dl
  802810:	74 62                	je     802874 <get_uvpt_entry+0x9a>
  802812:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  802819:	7f 00 00 
  80281c:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  802820:	f6 c2 80             	test   $0x80,%dl
  802823:	75 4f                	jne    802874 <get_uvpt_entry+0x9a>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802825:	48 89 f8             	mov    %rdi,%rax
  802828:	48 c1 e8 15          	shr    $0x15,%rax
  80282c:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802833:	7f 00 00 
  802836:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80283a:	f6 c2 01             	test   $0x1,%dl
  80283d:	74 44                	je     802883 <get_uvpt_entry+0xa9>
  80283f:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  802846:	7f 00 00 
  802849:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80284d:	f6 c2 80             	test   $0x80,%dl
  802850:	75 31                	jne    802883 <get_uvpt_entry+0xa9>
    return uvpt[VPT(va)];
  802852:	48 c1 ef 0c          	shr    $0xc,%rdi
  802856:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  80285d:	7f 00 00 
  802860:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  802864:	c3                   	ret
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  802865:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  80286c:	7f 00 00 
  80286f:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802873:	c3                   	ret
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  802874:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  80287b:	7f 00 00 
  80287e:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802882:	c3                   	ret
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  802883:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  80288a:	7f 00 00 
  80288d:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  802891:	c3                   	ret

0000000000802892 <get_phys_addr>:

uintptr_t
get_phys_addr(void *va) {
  802892:	f3 0f 1e fa          	endbr64
  802896:	48 89 fa             	mov    %rdi,%rdx
    if (!(uvpml4[VPML4(va)] & PTE_P))
  802899:	48 89 f9             	mov    %rdi,%rcx
  80289c:	48 c1 e9 27          	shr    $0x27,%rcx
  8028a0:	48 b8 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rax
  8028a7:	7f 00 00 
  8028aa:	48 8b 0c c8          	mov    (%rax,%rcx,8),%rcx
        return -1;
  8028ae:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpml4[VPML4(va)] & PTE_P))
  8028b5:	f6 c1 01             	test   $0x1,%cl
  8028b8:	0f 84 b2 00 00 00    	je     802970 <get_phys_addr+0xde>
    if (!(uvpdp[VPDP(va)] & PTE_P))
  8028be:	48 89 f9             	mov    %rdi,%rcx
  8028c1:	48 c1 e9 1e          	shr    $0x1e,%rcx
  8028c5:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  8028cc:	7f 00 00 
  8028cf:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  8028d3:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpdp[VPDP(va)] & PTE_P))
  8028da:	40 f6 c6 01          	test   $0x1,%sil
  8028de:	0f 84 8c 00 00 00    	je     802970 <get_phys_addr+0xde>
    if (uvpdp[VPDP(va)] & PTE_PS)
  8028e4:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  8028eb:	7f 00 00 
  8028ee:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8028f2:	a8 80                	test   $0x80,%al
  8028f4:	75 7b                	jne    802971 <get_phys_addr+0xdf>
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
    if (!(uvpd[VPD(va)] & PTE_P))
  8028f6:	48 89 f9             	mov    %rdi,%rcx
  8028f9:	48 c1 e9 15          	shr    $0x15,%rcx
  8028fd:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  802904:	7f 00 00 
  802907:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  80290b:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpd[VPD(va)] & PTE_P))
  802912:	40 f6 c6 01          	test   $0x1,%sil
  802916:	74 58                	je     802970 <get_phys_addr+0xde>
    if ((uvpd[VPD(va)] & PTE_PS))
  802918:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  80291f:	7f 00 00 
  802922:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  802926:	a8 80                	test   $0x80,%al
  802928:	75 6c                	jne    802996 <get_phys_addr+0x104>
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
    if (!(uvpt[VPT(va)] & PTE_P))
  80292a:	48 89 f9             	mov    %rdi,%rcx
  80292d:	48 c1 e9 0c          	shr    $0xc,%rcx
  802931:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802938:	7f 00 00 
  80293b:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  80293f:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpt[VPT(va)] & PTE_P))
  802946:	40 f6 c6 01          	test   $0x1,%sil
  80294a:	74 24                	je     802970 <get_phys_addr+0xde>
    return PTE_ADDR(uvpt[VPT(va)]) + PAGE_OFFSET(va);
  80294c:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802953:	7f 00 00 
  802956:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  80295a:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802961:	ff ff 7f 
  802964:	48 21 c8             	and    %rcx,%rax
  802967:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  80296d:	48 09 d0             	or     %rdx,%rax
}
  802970:	c3                   	ret
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
  802971:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  802978:	7f 00 00 
  80297b:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  80297f:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  802986:	ff ff 7f 
  802989:	48 21 c8             	and    %rcx,%rax
  80298c:	81 e2 ff ff ff 3f    	and    $0x3fffffff,%edx
  802992:	48 01 d0             	add    %rdx,%rax
  802995:	c3                   	ret
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
  802996:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  80299d:	7f 00 00 
  8029a0:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8029a4:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  8029ab:	ff ff 7f 
  8029ae:	48 21 c8             	and    %rcx,%rax
  8029b1:	81 e2 ff ff 1f 00    	and    $0x1fffff,%edx
  8029b7:	48 01 d0             	add    %rdx,%rax
  8029ba:	c3                   	ret

00000000008029bb <get_prot>:

int
get_prot(void *va) {
  8029bb:	f3 0f 1e fa          	endbr64
  8029bf:	55                   	push   %rbp
  8029c0:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  8029c3:	48 b8 da 27 80 00 00 	movabs $0x8027da,%rax
  8029ca:	00 00 00 
  8029cd:	ff d0                	call   *%rax
  8029cf:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
    if (pte & PTE_P) prot |= PROT_R;
  8029d2:	83 e0 01             	and    $0x1,%eax
  8029d5:	c1 e0 02             	shl    $0x2,%eax
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  8029d8:	89 d1                	mov    %edx,%ecx
  8029da:	81 e1 00 0a 00 00    	and    $0xa00,%ecx
    if (pte & PTE_P) prot |= PROT_R;
  8029e0:	09 c8                	or     %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  8029e2:	89 c1                	mov    %eax,%ecx
  8029e4:	83 c9 02             	or     $0x2,%ecx
  8029e7:	f6 c2 02             	test   $0x2,%dl
  8029ea:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  8029ed:	89 c1                	mov    %eax,%ecx
  8029ef:	83 c9 01             	or     $0x1,%ecx
  8029f2:	48 85 d2             	test   %rdx,%rdx
  8029f5:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  8029f8:	89 c1                	mov    %eax,%ecx
  8029fa:	83 c9 40             	or     $0x40,%ecx
  8029fd:	f6 c6 04             	test   $0x4,%dh
  802a00:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  802a03:	5d                   	pop    %rbp
  802a04:	c3                   	ret

0000000000802a05 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  802a05:	f3 0f 1e fa          	endbr64
  802a09:	55                   	push   %rbp
  802a0a:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  802a0d:	48 b8 da 27 80 00 00 	movabs $0x8027da,%rax
  802a14:	00 00 00 
  802a17:	ff d0                	call   *%rax
    return pte & PTE_D;
  802a19:	48 c1 e8 06          	shr    $0x6,%rax
  802a1d:	83 e0 01             	and    $0x1,%eax
}
  802a20:	5d                   	pop    %rbp
  802a21:	c3                   	ret

0000000000802a22 <is_page_present>:

bool
is_page_present(void *va) {
  802a22:	f3 0f 1e fa          	endbr64
  802a26:	55                   	push   %rbp
  802a27:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  802a2a:	48 b8 da 27 80 00 00 	movabs $0x8027da,%rax
  802a31:	00 00 00 
  802a34:	ff d0                	call   *%rax
  802a36:	83 e0 01             	and    $0x1,%eax
}
  802a39:	5d                   	pop    %rbp
  802a3a:	c3                   	ret

0000000000802a3b <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  802a3b:	f3 0f 1e fa          	endbr64
  802a3f:	55                   	push   %rbp
  802a40:	48 89 e5             	mov    %rsp,%rbp
  802a43:	41 57                	push   %r15
  802a45:	41 56                	push   %r14
  802a47:	41 55                	push   %r13
  802a49:	41 54                	push   %r12
  802a4b:	53                   	push   %rbx
  802a4c:	48 83 ec 18          	sub    $0x18,%rsp
  802a50:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  802a54:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
     * NOTE: Skip over larger pages/page directories for efficiency */
    // LAB 11: Your code here:

    int res = 0;
    (void)fun, (void)arg;
    uintptr_t va = 0;
  802a58:	bb 00 00 00 00       	mov    $0x0,%ebx
    while (va < USER_STACK_TOP) {
        size_t size = 0;
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  802a5d:	49 be 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%r14
  802a64:	7f 00 00 
            size = 1LL << PML4_SHIFT;
            goto next;
        }

        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802a67:	49 bd 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%r13
  802a6e:	7f 00 00 
    while (va < USER_STACK_TOP) {
  802a71:	49 bf ff 6f ff ff 7f 	movabs $0x7fffff6fff,%r15
  802a78:	00 00 00 
  802a7b:	eb 73                	jmp    802af0 <foreach_shared_region+0xb5>
            }

            goto next;
        }

        if (!(uvpd[VPD(va)] & PTE_P)) {
  802a7d:	48 89 d8             	mov    %rbx,%rax
  802a80:	48 c1 e8 15          	shr    $0x15,%rax
  802a84:	48 b9 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rcx
  802a8b:	7f 00 00 
  802a8e:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
            size = 1LL << PD_SHIFT;
  802a92:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
        if (!(uvpd[VPD(va)] & PTE_P)) {
  802a98:	f6 c2 01             	test   $0x1,%dl
  802a9b:	74 4b                	je     802ae8 <foreach_shared_region+0xad>
            goto next;
        }

        if (uvpd[VPD(va)] & PTE_PS) {
  802a9d:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
  802aa1:	f6 c2 80             	test   $0x80,%dl
  802aa4:	74 11                	je     802ab7 <foreach_shared_region+0x7c>
            size = 1LL << PD_SHIFT;
            if (uvpd[VPD(va)] & PTE_SHARE) {
  802aa6:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
  802aaa:	f6 c4 04             	test   $0x4,%ah
  802aad:	74 39                	je     802ae8 <foreach_shared_region+0xad>
            size = 1LL << PD_SHIFT;
  802aaf:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
  802ab5:	eb 20                	jmp    802ad7 <foreach_shared_region+0x9c>

            goto next;
        }

        size = PAGE_SIZE;
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  802ab7:	48 89 da             	mov    %rbx,%rdx
  802aba:	48 c1 ea 0c          	shr    $0xc,%rdx
  802abe:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  802ac5:	7f 00 00 
  802ac8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
        size = PAGE_SIZE;
  802acc:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  802ad2:	f6 c4 04             	test   $0x4,%ah
  802ad5:	74 11                	je     802ae8 <foreach_shared_region+0xad>
            goto next;
        }

    map:
        fun((void *)va, (void *)(va + size), arg);
  802ad7:	49 8d 34 1c          	lea    (%r12,%rbx,1),%rsi
  802adb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802adf:	48 89 df             	mov    %rbx,%rdi
  802ae2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802ae6:	ff d0                	call   *%rax
    next:
        va += size;
  802ae8:	4c 01 e3             	add    %r12,%rbx
    while (va < USER_STACK_TOP) {
  802aeb:	49 39 df             	cmp    %rbx,%r15
  802aee:	72 3e                	jb     802b2e <foreach_shared_region+0xf3>
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  802af0:	49 8b 06             	mov    (%r14),%rax
  802af3:	a8 01                	test   $0x1,%al
  802af5:	74 37                	je     802b2e <foreach_shared_region+0xf3>
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802af7:	48 89 d8             	mov    %rbx,%rax
  802afa:	48 c1 e8 1e          	shr    $0x1e,%rax
  802afe:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
            size = 1LL << PDP_SHIFT;
  802b03:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  802b09:	f6 c2 01             	test   $0x1,%dl
  802b0c:	74 da                	je     802ae8 <foreach_shared_region+0xad>
        if (uvpdp[VPDP(va)] & PTE_PS) {
  802b0e:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
  802b13:	f6 c2 80             	test   $0x80,%dl
  802b16:	0f 84 61 ff ff ff    	je     802a7d <foreach_shared_region+0x42>
            if (uvpdp[VPDP(va)] & PTE_SHARE) {
  802b1c:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  802b21:	f6 c4 04             	test   $0x4,%ah
  802b24:	74 c2                	je     802ae8 <foreach_shared_region+0xad>
            size = 1LL << PDP_SHIFT;
  802b26:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
  802b2c:	eb a9                	jmp    802ad7 <foreach_shared_region+0x9c>
    }
    return res;
}
  802b2e:	b8 00 00 00 00       	mov    $0x0,%eax
  802b33:	48 83 c4 18          	add    $0x18,%rsp
  802b37:	5b                   	pop    %rbx
  802b38:	41 5c                	pop    %r12
  802b3a:	41 5d                	pop    %r13
  802b3c:	41 5e                	pop    %r14
  802b3e:	41 5f                	pop    %r15
  802b40:	5d                   	pop    %rbp
  802b41:	c3                   	ret

0000000000802b42 <devcons_close>:

    return res;
}

static int
devcons_close(struct Fd *fd) {
  802b42:	f3 0f 1e fa          	endbr64
    USED(fd);

    return 0;
}
  802b46:	b8 00 00 00 00       	mov    $0x0,%eax
  802b4b:	c3                   	ret

0000000000802b4c <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  802b4c:	f3 0f 1e fa          	endbr64
  802b50:	55                   	push   %rbp
  802b51:	48 89 e5             	mov    %rsp,%rbp
  802b54:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  802b57:	48 be 5c 32 80 00 00 	movabs $0x80325c,%rsi
  802b5e:	00 00 00 
  802b61:	48 b8 5d 0e 80 00 00 	movabs $0x800e5d,%rax
  802b68:	00 00 00 
  802b6b:	ff d0                	call   *%rax
    return 0;
}
  802b6d:	b8 00 00 00 00       	mov    $0x0,%eax
  802b72:	5d                   	pop    %rbp
  802b73:	c3                   	ret

0000000000802b74 <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  802b74:	f3 0f 1e fa          	endbr64
  802b78:	55                   	push   %rbp
  802b79:	48 89 e5             	mov    %rsp,%rbp
  802b7c:	41 57                	push   %r15
  802b7e:	41 56                	push   %r14
  802b80:	41 55                	push   %r13
  802b82:	41 54                	push   %r12
  802b84:	53                   	push   %rbx
  802b85:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  802b8c:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  802b93:	48 85 d2             	test   %rdx,%rdx
  802b96:	74 7a                	je     802c12 <devcons_write+0x9e>
  802b98:	49 89 d6             	mov    %rdx,%r14
  802b9b:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802ba1:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  802ba6:	49 bf 78 10 80 00 00 	movabs $0x801078,%r15
  802bad:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  802bb0:	4c 89 f3             	mov    %r14,%rbx
  802bb3:	48 29 f3             	sub    %rsi,%rbx
  802bb6:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802bbb:	48 39 c3             	cmp    %rax,%rbx
  802bbe:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  802bc2:	4c 63 eb             	movslq %ebx,%r13
  802bc5:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  802bcc:	48 01 c6             	add    %rax,%rsi
  802bcf:	4c 89 ea             	mov    %r13,%rdx
  802bd2:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802bd9:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  802bdc:	4c 89 ee             	mov    %r13,%rsi
  802bdf:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  802be6:	48 b8 bd 12 80 00 00 	movabs $0x8012bd,%rax
  802bed:	00 00 00 
  802bf0:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  802bf2:	41 01 dc             	add    %ebx,%r12d
  802bf5:	49 63 f4             	movslq %r12d,%rsi
  802bf8:	4c 39 f6             	cmp    %r14,%rsi
  802bfb:	72 b3                	jb     802bb0 <devcons_write+0x3c>
    return res;
  802bfd:	49 63 c4             	movslq %r12d,%rax
}
  802c00:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  802c07:	5b                   	pop    %rbx
  802c08:	41 5c                	pop    %r12
  802c0a:	41 5d                	pop    %r13
  802c0c:	41 5e                	pop    %r14
  802c0e:	41 5f                	pop    %r15
  802c10:	5d                   	pop    %rbp
  802c11:	c3                   	ret
    for (res = 0; res < n; res += inc) {
  802c12:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  802c18:	eb e3                	jmp    802bfd <devcons_write+0x89>

0000000000802c1a <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802c1a:	f3 0f 1e fa          	endbr64
  802c1e:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  802c21:	ba 00 00 00 00       	mov    $0x0,%edx
  802c26:	48 85 c0             	test   %rax,%rax
  802c29:	74 55                	je     802c80 <devcons_read+0x66>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  802c2b:	55                   	push   %rbp
  802c2c:	48 89 e5             	mov    %rsp,%rbp
  802c2f:	41 55                	push   %r13
  802c31:	41 54                	push   %r12
  802c33:	53                   	push   %rbx
  802c34:	48 83 ec 08          	sub    $0x8,%rsp
  802c38:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  802c3b:	48 bb ee 12 80 00 00 	movabs $0x8012ee,%rbx
  802c42:	00 00 00 
  802c45:	49 bc c7 13 80 00 00 	movabs $0x8013c7,%r12
  802c4c:	00 00 00 
  802c4f:	eb 03                	jmp    802c54 <devcons_read+0x3a>
  802c51:	41 ff d4             	call   *%r12
  802c54:	ff d3                	call   *%rbx
  802c56:	85 c0                	test   %eax,%eax
  802c58:	74 f7                	je     802c51 <devcons_read+0x37>
    if (c < 0) return c;
  802c5a:	48 63 d0             	movslq %eax,%rdx
  802c5d:	78 13                	js     802c72 <devcons_read+0x58>
    if (c == 0x04) return 0;
  802c5f:	ba 00 00 00 00       	mov    $0x0,%edx
  802c64:	83 f8 04             	cmp    $0x4,%eax
  802c67:	74 09                	je     802c72 <devcons_read+0x58>
    *(char *)vbuf = (char)c;
  802c69:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  802c6d:	ba 01 00 00 00       	mov    $0x1,%edx
}
  802c72:	48 89 d0             	mov    %rdx,%rax
  802c75:	48 83 c4 08          	add    $0x8,%rsp
  802c79:	5b                   	pop    %rbx
  802c7a:	41 5c                	pop    %r12
  802c7c:	41 5d                	pop    %r13
  802c7e:	5d                   	pop    %rbp
  802c7f:	c3                   	ret
  802c80:	48 89 d0             	mov    %rdx,%rax
  802c83:	c3                   	ret

0000000000802c84 <cputchar>:
cputchar(int ch) {
  802c84:	f3 0f 1e fa          	endbr64
  802c88:	55                   	push   %rbp
  802c89:	48 89 e5             	mov    %rsp,%rbp
  802c8c:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  802c90:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  802c94:	be 01 00 00 00       	mov    $0x1,%esi
  802c99:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  802c9d:	48 b8 bd 12 80 00 00 	movabs $0x8012bd,%rax
  802ca4:	00 00 00 
  802ca7:	ff d0                	call   *%rax
}
  802ca9:	c9                   	leave
  802caa:	c3                   	ret

0000000000802cab <getchar>:
getchar(void) {
  802cab:	f3 0f 1e fa          	endbr64
  802caf:	55                   	push   %rbp
  802cb0:	48 89 e5             	mov    %rsp,%rbp
  802cb3:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  802cb7:	ba 01 00 00 00       	mov    $0x1,%edx
  802cbc:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  802cc0:	bf 00 00 00 00       	mov    $0x0,%edi
  802cc5:	48 b8 bb 1b 80 00 00 	movabs $0x801bbb,%rax
  802ccc:	00 00 00 
  802ccf:	ff d0                	call   *%rax
  802cd1:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  802cd3:	85 c0                	test   %eax,%eax
  802cd5:	78 06                	js     802cdd <getchar+0x32>
  802cd7:	74 08                	je     802ce1 <getchar+0x36>
  802cd9:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  802cdd:	89 d0                	mov    %edx,%eax
  802cdf:	c9                   	leave
  802ce0:	c3                   	ret
    return res < 0 ? res : res ? c :
  802ce1:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  802ce6:	eb f5                	jmp    802cdd <getchar+0x32>

0000000000802ce8 <iscons>:
iscons(int fdnum) {
  802ce8:	f3 0f 1e fa          	endbr64
  802cec:	55                   	push   %rbp
  802ced:	48 89 e5             	mov    %rsp,%rbp
  802cf0:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  802cf4:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  802cf8:	48 b8 c0 18 80 00 00 	movabs $0x8018c0,%rax
  802cff:	00 00 00 
  802d02:	ff d0                	call   *%rax
    if (res < 0) return res;
  802d04:	85 c0                	test   %eax,%eax
  802d06:	78 18                	js     802d20 <iscons+0x38>
    return fd->fd_dev_id == devcons.dev_id;
  802d08:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802d0c:	48 b8 a0 40 80 00 00 	movabs $0x8040a0,%rax
  802d13:	00 00 00 
  802d16:	8b 00                	mov    (%rax),%eax
  802d18:	39 02                	cmp    %eax,(%rdx)
  802d1a:	0f 94 c0             	sete   %al
  802d1d:	0f b6 c0             	movzbl %al,%eax
}
  802d20:	c9                   	leave
  802d21:	c3                   	ret

0000000000802d22 <opencons>:
opencons(void) {
  802d22:	f3 0f 1e fa          	endbr64
  802d26:	55                   	push   %rbp
  802d27:	48 89 e5             	mov    %rsp,%rbp
  802d2a:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  802d2e:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  802d32:	48 b8 5c 18 80 00 00 	movabs $0x80185c,%rax
  802d39:	00 00 00 
  802d3c:	ff d0                	call   *%rax
  802d3e:	85 c0                	test   %eax,%eax
  802d40:	78 49                	js     802d8b <opencons+0x69>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  802d42:	b9 46 00 00 00       	mov    $0x46,%ecx
  802d47:	ba 00 10 00 00       	mov    $0x1000,%edx
  802d4c:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  802d50:	bf 00 00 00 00       	mov    $0x0,%edi
  802d55:	48 b8 62 14 80 00 00 	movabs $0x801462,%rax
  802d5c:	00 00 00 
  802d5f:	ff d0                	call   *%rax
  802d61:	85 c0                	test   %eax,%eax
  802d63:	78 26                	js     802d8b <opencons+0x69>
    fd->fd_dev_id = devcons.dev_id;
  802d65:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802d69:	a1 a0 40 80 00 00 00 	movabs 0x8040a0,%eax
  802d70:	00 00 
  802d72:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  802d74:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802d78:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  802d7f:	48 b8 26 18 80 00 00 	movabs $0x801826,%rax
  802d86:	00 00 00 
  802d89:	ff d0                	call   *%rax
}
  802d8b:	c9                   	leave
  802d8c:	c3                   	ret

0000000000802d8d <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  802d8d:	f3 0f 1e fa          	endbr64
  802d91:	55                   	push   %rbp
  802d92:	48 89 e5             	mov    %rsp,%rbp
  802d95:	41 56                	push   %r14
  802d97:	41 55                	push   %r13
  802d99:	41 54                	push   %r12
  802d9b:	53                   	push   %rbx
  802d9c:	48 83 ec 50          	sub    $0x50,%rsp
  802da0:	49 89 fc             	mov    %rdi,%r12
  802da3:	41 89 f5             	mov    %esi,%r13d
  802da6:	48 89 d3             	mov    %rdx,%rbx
  802da9:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  802dad:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  802db1:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  802db5:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  802dbc:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802dc0:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  802dc4:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  802dc8:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  802dcc:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  802dd3:	00 00 00 
  802dd6:	4c 8b 30             	mov    (%rax),%r14
  802dd9:	48 b8 92 13 80 00 00 	movabs $0x801392,%rax
  802de0:	00 00 00 
  802de3:	ff d0                	call   *%rax
  802de5:	89 c6                	mov    %eax,%esi
  802de7:	45 89 e8             	mov    %r13d,%r8d
  802dea:	4c 89 e1             	mov    %r12,%rcx
  802ded:	4c 89 f2             	mov    %r14,%rdx
  802df0:	48 bf 90 36 80 00 00 	movabs $0x803690,%rdi
  802df7:	00 00 00 
  802dfa:	b8 00 00 00 00       	mov    $0x0,%eax
  802dff:	49 bc 14 05 80 00 00 	movabs $0x800514,%r12
  802e06:	00 00 00 
  802e09:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  802e0c:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  802e10:	48 89 df             	mov    %rbx,%rdi
  802e13:	48 b8 ac 04 80 00 00 	movabs $0x8004ac,%rax
  802e1a:	00 00 00 
  802e1d:	ff d0                	call   *%rax
    cprintf("\n");
  802e1f:	48 bf e9 31 80 00 00 	movabs $0x8031e9,%rdi
  802e26:	00 00 00 
  802e29:	b8 00 00 00 00       	mov    $0x0,%eax
  802e2e:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  802e31:	cc                   	int3
  802e32:	eb fd                	jmp    802e31 <_panic+0xa4>

0000000000802e34 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  802e34:	f3 0f 1e fa          	endbr64
  802e38:	55                   	push   %rbp
  802e39:	48 89 e5             	mov    %rsp,%rbp
  802e3c:	41 54                	push   %r12
  802e3e:	53                   	push   %rbx
  802e3f:	48 89 fb             	mov    %rdi,%rbx
  802e42:	48 89 f7             	mov    %rsi,%rdi
  802e45:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802e48:	48 85 f6             	test   %rsi,%rsi
  802e4b:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802e52:	00 00 00 
  802e55:	48 0f 44 f8          	cmove  %rax,%rdi
    }
    int res = sys_ipc_recv(pg, PAGE_SIZE);
  802e59:	be 00 10 00 00       	mov    $0x1000,%esi
  802e5e:	48 b8 84 17 80 00 00 	movabs $0x801784,%rax
  802e65:	00 00 00 
  802e68:	ff d0                	call   *%rax
    if (res < 0) {
  802e6a:	85 c0                	test   %eax,%eax
  802e6c:	78 45                	js     802eb3 <ipc_recv+0x7f>
        if (perm_store != NULL) {
            *perm_store = 0;
        }
        return res;
    } else {
        if (from_env_store != NULL) {
  802e6e:	48 85 db             	test   %rbx,%rbx
  802e71:	74 12                	je     802e85 <ipc_recv+0x51>
            *from_env_store = thisenv->env_ipc_from;
  802e73:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802e7a:	00 00 00 
  802e7d:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  802e83:	89 03                	mov    %eax,(%rbx)
        }
        if (perm_store != NULL) {
  802e85:	4d 85 e4             	test   %r12,%r12
  802e88:	74 14                	je     802e9e <ipc_recv+0x6a>
            *perm_store = thisenv->env_ipc_perm;
  802e8a:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802e91:	00 00 00 
  802e94:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  802e9a:	41 89 04 24          	mov    %eax,(%r12)
        }
        return thisenv->env_ipc_value;
  802e9e:	48 a1 00 50 80 00 00 	movabs 0x805000,%rax
  802ea5:	00 00 00 
  802ea8:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
    }
    return -1;
}
  802eae:	5b                   	pop    %rbx
  802eaf:	41 5c                	pop    %r12
  802eb1:	5d                   	pop    %rbp
  802eb2:	c3                   	ret
        if (from_env_store != NULL) {
  802eb3:	48 85 db             	test   %rbx,%rbx
  802eb6:	74 06                	je     802ebe <ipc_recv+0x8a>
            *from_env_store = 0;
  802eb8:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store != NULL) {
  802ebe:	4d 85 e4             	test   %r12,%r12
  802ec1:	74 eb                	je     802eae <ipc_recv+0x7a>
            *perm_store = 0;
  802ec3:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  802eca:	00 
  802ecb:	eb e1                	jmp    802eae <ipc_recv+0x7a>

0000000000802ecd <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  802ecd:	f3 0f 1e fa          	endbr64
  802ed1:	55                   	push   %rbp
  802ed2:	48 89 e5             	mov    %rsp,%rbp
  802ed5:	41 57                	push   %r15
  802ed7:	41 56                	push   %r14
  802ed9:	41 55                	push   %r13
  802edb:	41 54                	push   %r12
  802edd:	53                   	push   %rbx
  802ede:	48 83 ec 18          	sub    $0x18,%rsp
  802ee2:	89 7d c4             	mov    %edi,-0x3c(%rbp)
  802ee5:	48 89 d3             	mov    %rdx,%rbx
  802ee8:	49 89 cc             	mov    %rcx,%r12
  802eeb:	45 89 c5             	mov    %r8d,%r13d
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  802eee:	48 85 d2             	test   %rdx,%rdx
  802ef1:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  802ef8:	00 00 00 
  802efb:	48 0f 44 d8          	cmove  %rax,%rbx
    }
    int res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802eff:	89 f0                	mov    %esi,%eax
  802f01:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  802f05:	48 89 da             	mov    %rbx,%rdx
  802f08:	48 89 c6             	mov    %rax,%rsi
  802f0b:	48 b8 54 17 80 00 00 	movabs $0x801754,%rax
  802f12:	00 00 00 
  802f15:	ff d0                	call   *%rax
    while (res < 0) {
  802f17:	85 c0                	test   %eax,%eax
  802f19:	79 65                	jns    802f80 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802f1b:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802f1e:	75 33                	jne    802f53 <ipc_send+0x86>
            panic("Error: %i\n", res);
        }
        sys_yield();
  802f20:	49 bf c7 13 80 00 00 	movabs $0x8013c7,%r15
  802f27:	00 00 00 
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802f2a:	49 be 54 17 80 00 00 	movabs $0x801754,%r14
  802f31:	00 00 00 
        sys_yield();
  802f34:	41 ff d7             	call   *%r15
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  802f37:	45 89 e8             	mov    %r13d,%r8d
  802f3a:	4c 89 e1             	mov    %r12,%rcx
  802f3d:	48 89 da             	mov    %rbx,%rdx
  802f40:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  802f44:	8b 7d c4             	mov    -0x3c(%rbp),%edi
  802f47:	41 ff d6             	call   *%r14
    while (res < 0) {
  802f4a:	85 c0                	test   %eax,%eax
  802f4c:	79 32                	jns    802f80 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  802f4e:	83 f8 f5             	cmp    $0xfffffff5,%eax
  802f51:	74 e1                	je     802f34 <ipc_send+0x67>
            panic("Error: %i\n", res);
  802f53:	89 c1                	mov    %eax,%ecx
  802f55:	48 ba 68 32 80 00 00 	movabs $0x803268,%rdx
  802f5c:	00 00 00 
  802f5f:	be 42 00 00 00       	mov    $0x42,%esi
  802f64:	48 bf 73 32 80 00 00 	movabs $0x803273,%rdi
  802f6b:	00 00 00 
  802f6e:	b8 00 00 00 00       	mov    $0x0,%eax
  802f73:	49 b8 8d 2d 80 00 00 	movabs $0x802d8d,%r8
  802f7a:	00 00 00 
  802f7d:	41 ff d0             	call   *%r8
    }
}
  802f80:	48 83 c4 18          	add    $0x18,%rsp
  802f84:	5b                   	pop    %rbx
  802f85:	41 5c                	pop    %r12
  802f87:	41 5d                	pop    %r13
  802f89:	41 5e                	pop    %r14
  802f8b:	41 5f                	pop    %r15
  802f8d:	5d                   	pop    %rbp
  802f8e:	c3                   	ret

0000000000802f8f <ipc_find_env>:

/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
  802f8f:	f3 0f 1e fa          	endbr64
    for (size_t i = 0; i < NENV; i++)
  802f93:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  802f98:	48 b9 00 00 a0 1f 80 	movabs $0x801fa00000,%rcx
  802f9f:	00 00 00 
  802fa2:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802fa6:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802faa:	48 c1 e2 04          	shl    $0x4,%rdx
  802fae:	48 01 ca             	add    %rcx,%rdx
  802fb1:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  802fb7:	39 fa                	cmp    %edi,%edx
  802fb9:	74 12                	je     802fcd <ipc_find_env+0x3e>
    for (size_t i = 0; i < NENV; i++)
  802fbb:	48 83 c0 01          	add    $0x1,%rax
  802fbf:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  802fc5:	75 db                	jne    802fa2 <ipc_find_env+0x13>
            return envs[i].env_id;
    return 0;
  802fc7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802fcc:	c3                   	ret
            return envs[i].env_id;
  802fcd:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  802fd1:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  802fd5:	48 c1 e2 04          	shl    $0x4,%rdx
  802fd9:	48 b8 00 00 a0 1f 80 	movabs $0x801fa00000,%rax
  802fe0:	00 00 00 
  802fe3:	48 01 d0             	add    %rdx,%rax
  802fe6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802fec:	c3                   	ret

0000000000802fed <__text_end>:
  802fed:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  802ff4:	00 00 00 
  802ff7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  802ffe:	00 00 
