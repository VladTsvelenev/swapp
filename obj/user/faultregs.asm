
obj/user/faultregs:     file format elf64-x86-64


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
  80001e:	e8 c6 0c 00 00       	call   800ce9 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <check_regs>:

static struct regs before, during, after;

static void
check_regs(struct regs *a, const char *an, struct regs *b, const char *bn,
           const char *testname) {
  800025:	f3 0f 1e fa          	endbr64
  800029:	55                   	push   %rbp
  80002a:	48 89 e5             	mov    %rsp,%rbp
  80002d:	41 57                	push   %r15
  80002f:	41 56                	push   %r14
  800031:	41 55                	push   %r13
  800033:	41 54                	push   %r12
  800035:	53                   	push   %rbx
  800036:	48 83 ec 08          	sub    $0x8,%rsp
  80003a:	49 89 fc             	mov    %rdi,%r12
  80003d:	48 89 d3             	mov    %rdx,%rbx
  800040:	4d 89 c6             	mov    %r8,%r14
    int mismatch = 0;

    cprintf("%-6s %-8s %-8s\n", "", an, bn);
  800043:	48 89 f2             	mov    %rsi,%rdx
  800046:	48 be 33 40 80 00 00 	movabs $0x804033,%rsi
  80004d:	00 00 00 
  800050:	48 bf 00 40 80 00 00 	movabs $0x804000,%rdi
  800057:	00 00 00 
  80005a:	b8 00 00 00 00       	mov    $0x0,%eax
  80005f:	49 bd 1e 0f 80 00 00 	movabs $0x800f1e,%r13
  800066:	00 00 00 
  800069:	41 ff d5             	call   *%r13
            cprintf("MISMATCH\n");                                                             \
            mismatch = 1;                                                                      \
        }                                                                                      \
    } while (0)

    CHECK(r14, regs.reg_r14);
  80006c:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  800070:	49 8b 54 24 08       	mov    0x8(%r12),%rdx
  800075:	48 be 10 40 80 00 00 	movabs $0x804010,%rsi
  80007c:	00 00 00 
  80007f:	48 bf 14 40 80 00 00 	movabs $0x804014,%rdi
  800086:	00 00 00 
  800089:	b8 00 00 00 00       	mov    $0x0,%eax
  80008e:	41 ff d5             	call   *%r13
  800091:	48 8b 43 08          	mov    0x8(%rbx),%rax
  800095:	49 39 44 24 08       	cmp    %rax,0x8(%r12)
  80009a:	0f 84 48 06 00 00    	je     8006e8 <check_regs+0x6c3>
  8000a0:	48 bf 2a 40 80 00 00 	movabs $0x80402a,%rdi
  8000a7:	00 00 00 
  8000aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8000af:	48 ba 1e 0f 80 00 00 	movabs $0x800f1e,%rdx
  8000b6:	00 00 00 
  8000b9:	ff d2                	call   *%rdx
  8000bb:	41 bd 01 00 00 00    	mov    $0x1,%r13d
    CHECK(r13, regs.reg_r13);
  8000c1:	48 8b 4b 10          	mov    0x10(%rbx),%rcx
  8000c5:	49 8b 54 24 10       	mov    0x10(%r12),%rdx
  8000ca:	48 be 34 40 80 00 00 	movabs $0x804034,%rsi
  8000d1:	00 00 00 
  8000d4:	48 bf 14 40 80 00 00 	movabs $0x804014,%rdi
  8000db:	00 00 00 
  8000de:	b8 00 00 00 00       	mov    $0x0,%eax
  8000e3:	49 b8 1e 0f 80 00 00 	movabs $0x800f1e,%r8
  8000ea:	00 00 00 
  8000ed:	41 ff d0             	call   *%r8
  8000f0:	48 8b 43 10          	mov    0x10(%rbx),%rax
  8000f4:	49 39 44 24 10       	cmp    %rax,0x10(%r12)
  8000f9:	0f 84 06 06 00 00    	je     800705 <check_regs+0x6e0>
  8000ff:	48 bf 2a 40 80 00 00 	movabs $0x80402a,%rdi
  800106:	00 00 00 
  800109:	b8 00 00 00 00       	mov    $0x0,%eax
  80010e:	48 ba 1e 0f 80 00 00 	movabs $0x800f1e,%rdx
  800115:	00 00 00 
  800118:	ff d2                	call   *%rdx
  80011a:	41 bd 01 00 00 00    	mov    $0x1,%r13d
    CHECK(r12, regs.reg_r12);
  800120:	48 8b 4b 18          	mov    0x18(%rbx),%rcx
  800124:	49 8b 54 24 18       	mov    0x18(%r12),%rdx
  800129:	48 be 38 40 80 00 00 	movabs $0x804038,%rsi
  800130:	00 00 00 
  800133:	48 bf 14 40 80 00 00 	movabs $0x804014,%rdi
  80013a:	00 00 00 
  80013d:	b8 00 00 00 00       	mov    $0x0,%eax
  800142:	49 b8 1e 0f 80 00 00 	movabs $0x800f1e,%r8
  800149:	00 00 00 
  80014c:	41 ff d0             	call   *%r8
  80014f:	48 8b 43 18          	mov    0x18(%rbx),%rax
  800153:	49 39 44 24 18       	cmp    %rax,0x18(%r12)
  800158:	0f 84 c7 05 00 00    	je     800725 <check_regs+0x700>
  80015e:	48 bf 2a 40 80 00 00 	movabs $0x80402a,%rdi
  800165:	00 00 00 
  800168:	b8 00 00 00 00       	mov    $0x0,%eax
  80016d:	48 ba 1e 0f 80 00 00 	movabs $0x800f1e,%rdx
  800174:	00 00 00 
  800177:	ff d2                	call   *%rdx
  800179:	41 bd 01 00 00 00    	mov    $0x1,%r13d
    CHECK(r11, regs.reg_r11);
  80017f:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  800183:	49 8b 54 24 20       	mov    0x20(%r12),%rdx
  800188:	48 be 3c 40 80 00 00 	movabs $0x80403c,%rsi
  80018f:	00 00 00 
  800192:	48 bf 14 40 80 00 00 	movabs $0x804014,%rdi
  800199:	00 00 00 
  80019c:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a1:	49 b8 1e 0f 80 00 00 	movabs $0x800f1e,%r8
  8001a8:	00 00 00 
  8001ab:	41 ff d0             	call   *%r8
  8001ae:	48 8b 43 20          	mov    0x20(%rbx),%rax
  8001b2:	49 39 44 24 20       	cmp    %rax,0x20(%r12)
  8001b7:	0f 84 88 05 00 00    	je     800745 <check_regs+0x720>
  8001bd:	48 bf 2a 40 80 00 00 	movabs $0x80402a,%rdi
  8001c4:	00 00 00 
  8001c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8001cc:	48 ba 1e 0f 80 00 00 	movabs $0x800f1e,%rdx
  8001d3:	00 00 00 
  8001d6:	ff d2                	call   *%rdx
  8001d8:	41 bd 01 00 00 00    	mov    $0x1,%r13d
    CHECK(r10, regs.reg_r10);
  8001de:	48 8b 4b 28          	mov    0x28(%rbx),%rcx
  8001e2:	49 8b 54 24 28       	mov    0x28(%r12),%rdx
  8001e7:	48 be 40 40 80 00 00 	movabs $0x804040,%rsi
  8001ee:	00 00 00 
  8001f1:	48 bf 14 40 80 00 00 	movabs $0x804014,%rdi
  8001f8:	00 00 00 
  8001fb:	b8 00 00 00 00       	mov    $0x0,%eax
  800200:	49 b8 1e 0f 80 00 00 	movabs $0x800f1e,%r8
  800207:	00 00 00 
  80020a:	41 ff d0             	call   *%r8
  80020d:	48 8b 43 28          	mov    0x28(%rbx),%rax
  800211:	49 39 44 24 28       	cmp    %rax,0x28(%r12)
  800216:	0f 84 49 05 00 00    	je     800765 <check_regs+0x740>
  80021c:	48 bf 2a 40 80 00 00 	movabs $0x80402a,%rdi
  800223:	00 00 00 
  800226:	b8 00 00 00 00       	mov    $0x0,%eax
  80022b:	48 ba 1e 0f 80 00 00 	movabs $0x800f1e,%rdx
  800232:	00 00 00 
  800235:	ff d2                	call   *%rdx
  800237:	41 bd 01 00 00 00    	mov    $0x1,%r13d
    CHECK(rsi, regs.reg_rsi);
  80023d:	48 8b 4b 40          	mov    0x40(%rbx),%rcx
  800241:	49 8b 54 24 40       	mov    0x40(%r12),%rdx
  800246:	48 be 44 40 80 00 00 	movabs $0x804044,%rsi
  80024d:	00 00 00 
  800250:	48 bf 14 40 80 00 00 	movabs $0x804014,%rdi
  800257:	00 00 00 
  80025a:	b8 00 00 00 00       	mov    $0x0,%eax
  80025f:	49 b8 1e 0f 80 00 00 	movabs $0x800f1e,%r8
  800266:	00 00 00 
  800269:	41 ff d0             	call   *%r8
  80026c:	48 8b 43 40          	mov    0x40(%rbx),%rax
  800270:	49 39 44 24 40       	cmp    %rax,0x40(%r12)
  800275:	0f 84 0a 05 00 00    	je     800785 <check_regs+0x760>
  80027b:	48 bf 2a 40 80 00 00 	movabs $0x80402a,%rdi
  800282:	00 00 00 
  800285:	b8 00 00 00 00       	mov    $0x0,%eax
  80028a:	48 ba 1e 0f 80 00 00 	movabs $0x800f1e,%rdx
  800291:	00 00 00 
  800294:	ff d2                	call   *%rdx
  800296:	41 bd 01 00 00 00    	mov    $0x1,%r13d
    CHECK(rdi, regs.reg_rdi);
  80029c:	48 8b 4b 48          	mov    0x48(%rbx),%rcx
  8002a0:	49 8b 54 24 48       	mov    0x48(%r12),%rdx
  8002a5:	48 be 48 40 80 00 00 	movabs $0x804048,%rsi
  8002ac:	00 00 00 
  8002af:	48 bf 14 40 80 00 00 	movabs $0x804014,%rdi
  8002b6:	00 00 00 
  8002b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8002be:	49 b8 1e 0f 80 00 00 	movabs $0x800f1e,%r8
  8002c5:	00 00 00 
  8002c8:	41 ff d0             	call   *%r8
  8002cb:	48 8b 43 48          	mov    0x48(%rbx),%rax
  8002cf:	49 39 44 24 48       	cmp    %rax,0x48(%r12)
  8002d4:	0f 84 cb 04 00 00    	je     8007a5 <check_regs+0x780>
  8002da:	48 bf 2a 40 80 00 00 	movabs $0x80402a,%rdi
  8002e1:	00 00 00 
  8002e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8002e9:	48 ba 1e 0f 80 00 00 	movabs $0x800f1e,%rdx
  8002f0:	00 00 00 
  8002f3:	ff d2                	call   *%rdx
  8002f5:	41 bd 01 00 00 00    	mov    $0x1,%r13d
    CHECK(rdi, regs.reg_rdi);
  8002fb:	48 8b 4b 48          	mov    0x48(%rbx),%rcx
  8002ff:	49 8b 54 24 48       	mov    0x48(%r12),%rdx
  800304:	48 be 48 40 80 00 00 	movabs $0x804048,%rsi
  80030b:	00 00 00 
  80030e:	48 bf 14 40 80 00 00 	movabs $0x804014,%rdi
  800315:	00 00 00 
  800318:	b8 00 00 00 00       	mov    $0x0,%eax
  80031d:	49 b8 1e 0f 80 00 00 	movabs $0x800f1e,%r8
  800324:	00 00 00 
  800327:	41 ff d0             	call   *%r8
  80032a:	48 8b 43 48          	mov    0x48(%rbx),%rax
  80032e:	49 39 44 24 48       	cmp    %rax,0x48(%r12)
  800333:	0f 84 8c 04 00 00    	je     8007c5 <check_regs+0x7a0>
  800339:	48 bf 2a 40 80 00 00 	movabs $0x80402a,%rdi
  800340:	00 00 00 
  800343:	b8 00 00 00 00       	mov    $0x0,%eax
  800348:	48 ba 1e 0f 80 00 00 	movabs $0x800f1e,%rdx
  80034f:	00 00 00 
  800352:	ff d2                	call   *%rdx
  800354:	41 bd 01 00 00 00    	mov    $0x1,%r13d
    CHECK(rsi, regs.reg_rsi);
  80035a:	48 8b 4b 40          	mov    0x40(%rbx),%rcx
  80035e:	49 8b 54 24 40       	mov    0x40(%r12),%rdx
  800363:	48 be 44 40 80 00 00 	movabs $0x804044,%rsi
  80036a:	00 00 00 
  80036d:	48 bf 14 40 80 00 00 	movabs $0x804014,%rdi
  800374:	00 00 00 
  800377:	b8 00 00 00 00       	mov    $0x0,%eax
  80037c:	49 b8 1e 0f 80 00 00 	movabs $0x800f1e,%r8
  800383:	00 00 00 
  800386:	41 ff d0             	call   *%r8
  800389:	48 8b 43 40          	mov    0x40(%rbx),%rax
  80038d:	49 39 44 24 40       	cmp    %rax,0x40(%r12)
  800392:	0f 84 4d 04 00 00    	je     8007e5 <check_regs+0x7c0>
  800398:	48 bf 2a 40 80 00 00 	movabs $0x80402a,%rdi
  80039f:	00 00 00 
  8003a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8003a7:	48 ba 1e 0f 80 00 00 	movabs $0x800f1e,%rdx
  8003ae:	00 00 00 
  8003b1:	ff d2                	call   *%rdx
  8003b3:	41 bd 01 00 00 00    	mov    $0x1,%r13d
    CHECK(rbp, regs.reg_rbp);
  8003b9:	48 8b 4b 50          	mov    0x50(%rbx),%rcx
  8003bd:	49 8b 54 24 50       	mov    0x50(%r12),%rdx
  8003c2:	48 be 4c 40 80 00 00 	movabs $0x80404c,%rsi
  8003c9:	00 00 00 
  8003cc:	48 bf 14 40 80 00 00 	movabs $0x804014,%rdi
  8003d3:	00 00 00 
  8003d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8003db:	49 b8 1e 0f 80 00 00 	movabs $0x800f1e,%r8
  8003e2:	00 00 00 
  8003e5:	41 ff d0             	call   *%r8
  8003e8:	48 8b 43 50          	mov    0x50(%rbx),%rax
  8003ec:	49 39 44 24 50       	cmp    %rax,0x50(%r12)
  8003f1:	0f 84 0e 04 00 00    	je     800805 <check_regs+0x7e0>
  8003f7:	48 bf 2a 40 80 00 00 	movabs $0x80402a,%rdi
  8003fe:	00 00 00 
  800401:	b8 00 00 00 00       	mov    $0x0,%eax
  800406:	48 ba 1e 0f 80 00 00 	movabs $0x800f1e,%rdx
  80040d:	00 00 00 
  800410:	ff d2                	call   *%rdx
  800412:	41 bd 01 00 00 00    	mov    $0x1,%r13d
    CHECK(rbx, regs.reg_rbx);
  800418:	48 8b 4b 68          	mov    0x68(%rbx),%rcx
  80041c:	49 8b 54 24 68       	mov    0x68(%r12),%rdx
  800421:	48 be 50 40 80 00 00 	movabs $0x804050,%rsi
  800428:	00 00 00 
  80042b:	48 bf 14 40 80 00 00 	movabs $0x804014,%rdi
  800432:	00 00 00 
  800435:	b8 00 00 00 00       	mov    $0x0,%eax
  80043a:	49 b8 1e 0f 80 00 00 	movabs $0x800f1e,%r8
  800441:	00 00 00 
  800444:	41 ff d0             	call   *%r8
  800447:	48 8b 43 68          	mov    0x68(%rbx),%rax
  80044b:	49 39 44 24 68       	cmp    %rax,0x68(%r12)
  800450:	0f 84 cf 03 00 00    	je     800825 <check_regs+0x800>
  800456:	48 bf 2a 40 80 00 00 	movabs $0x80402a,%rdi
  80045d:	00 00 00 
  800460:	b8 00 00 00 00       	mov    $0x0,%eax
  800465:	48 ba 1e 0f 80 00 00 	movabs $0x800f1e,%rdx
  80046c:	00 00 00 
  80046f:	ff d2                	call   *%rdx
  800471:	41 bd 01 00 00 00    	mov    $0x1,%r13d
    CHECK(rdx, regs.reg_rdx);
  800477:	48 8b 4b 58          	mov    0x58(%rbx),%rcx
  80047b:	49 8b 54 24 58       	mov    0x58(%r12),%rdx
  800480:	48 be 54 40 80 00 00 	movabs $0x804054,%rsi
  800487:	00 00 00 
  80048a:	48 bf 14 40 80 00 00 	movabs $0x804014,%rdi
  800491:	00 00 00 
  800494:	b8 00 00 00 00       	mov    $0x0,%eax
  800499:	49 b8 1e 0f 80 00 00 	movabs $0x800f1e,%r8
  8004a0:	00 00 00 
  8004a3:	41 ff d0             	call   *%r8
  8004a6:	48 8b 43 58          	mov    0x58(%rbx),%rax
  8004aa:	49 39 44 24 58       	cmp    %rax,0x58(%r12)
  8004af:	0f 84 90 03 00 00    	je     800845 <check_regs+0x820>
  8004b5:	48 bf 2a 40 80 00 00 	movabs $0x80402a,%rdi
  8004bc:	00 00 00 
  8004bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c4:	48 ba 1e 0f 80 00 00 	movabs $0x800f1e,%rdx
  8004cb:	00 00 00 
  8004ce:	ff d2                	call   *%rdx
  8004d0:	41 bd 01 00 00 00    	mov    $0x1,%r13d
    CHECK(rcx, regs.reg_rcx);
  8004d6:	48 8b 4b 60          	mov    0x60(%rbx),%rcx
  8004da:	49 8b 54 24 60       	mov    0x60(%r12),%rdx
  8004df:	48 be 58 40 80 00 00 	movabs $0x804058,%rsi
  8004e6:	00 00 00 
  8004e9:	48 bf 14 40 80 00 00 	movabs $0x804014,%rdi
  8004f0:	00 00 00 
  8004f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8004f8:	49 b8 1e 0f 80 00 00 	movabs $0x800f1e,%r8
  8004ff:	00 00 00 
  800502:	41 ff d0             	call   *%r8
  800505:	48 8b 43 60          	mov    0x60(%rbx),%rax
  800509:	49 39 44 24 60       	cmp    %rax,0x60(%r12)
  80050e:	0f 84 51 03 00 00    	je     800865 <check_regs+0x840>
  800514:	48 bf 2a 40 80 00 00 	movabs $0x80402a,%rdi
  80051b:	00 00 00 
  80051e:	b8 00 00 00 00       	mov    $0x0,%eax
  800523:	48 ba 1e 0f 80 00 00 	movabs $0x800f1e,%rdx
  80052a:	00 00 00 
  80052d:	ff d2                	call   *%rdx
  80052f:	41 bd 01 00 00 00    	mov    $0x1,%r13d
    CHECK(rax, regs.reg_rax);
  800535:	48 8b 4b 70          	mov    0x70(%rbx),%rcx
  800539:	49 8b 54 24 70       	mov    0x70(%r12),%rdx
  80053e:	48 be 5c 40 80 00 00 	movabs $0x80405c,%rsi
  800545:	00 00 00 
  800548:	48 bf 14 40 80 00 00 	movabs $0x804014,%rdi
  80054f:	00 00 00 
  800552:	b8 00 00 00 00       	mov    $0x0,%eax
  800557:	49 b8 1e 0f 80 00 00 	movabs $0x800f1e,%r8
  80055e:	00 00 00 
  800561:	41 ff d0             	call   *%r8
  800564:	48 8b 43 70          	mov    0x70(%rbx),%rax
  800568:	49 39 44 24 70       	cmp    %rax,0x70(%r12)
  80056d:	0f 84 12 03 00 00    	je     800885 <check_regs+0x860>
  800573:	48 bf 2a 40 80 00 00 	movabs $0x80402a,%rdi
  80057a:	00 00 00 
  80057d:	b8 00 00 00 00       	mov    $0x0,%eax
  800582:	48 ba 1e 0f 80 00 00 	movabs $0x800f1e,%rdx
  800589:	00 00 00 
  80058c:	ff d2                	call   *%rdx
  80058e:	41 bd 01 00 00 00    	mov    $0x1,%r13d
    CHECK(rip, rip);
  800594:	48 8b 4b 78          	mov    0x78(%rbx),%rcx
  800598:	49 8b 54 24 78       	mov    0x78(%r12),%rdx
  80059d:	48 be 60 40 80 00 00 	movabs $0x804060,%rsi
  8005a4:	00 00 00 
  8005a7:	48 bf 14 40 80 00 00 	movabs $0x804014,%rdi
  8005ae:	00 00 00 
  8005b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8005b6:	49 b8 1e 0f 80 00 00 	movabs $0x800f1e,%r8
  8005bd:	00 00 00 
  8005c0:	41 ff d0             	call   *%r8
  8005c3:	48 8b 43 78          	mov    0x78(%rbx),%rax
  8005c7:	49 39 44 24 78       	cmp    %rax,0x78(%r12)
  8005cc:	0f 84 d3 02 00 00    	je     8008a5 <check_regs+0x880>
  8005d2:	48 bf 2a 40 80 00 00 	movabs $0x80402a,%rdi
  8005d9:	00 00 00 
  8005dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8005e1:	48 ba 1e 0f 80 00 00 	movabs $0x800f1e,%rdx
  8005e8:	00 00 00 
  8005eb:	ff d2                	call   *%rdx
  8005ed:	41 bd 01 00 00 00    	mov    $0x1,%r13d
    CHECK(rflags, rflags);
  8005f3:	48 8b 8b 80 00 00 00 	mov    0x80(%rbx),%rcx
  8005fa:	49 8b 94 24 80 00 00 	mov    0x80(%r12),%rdx
  800601:	00 
  800602:	48 be 64 40 80 00 00 	movabs $0x804064,%rsi
  800609:	00 00 00 
  80060c:	48 bf 14 40 80 00 00 	movabs $0x804014,%rdi
  800613:	00 00 00 
  800616:	b8 00 00 00 00       	mov    $0x0,%eax
  80061b:	49 b8 1e 0f 80 00 00 	movabs $0x800f1e,%r8
  800622:	00 00 00 
  800625:	41 ff d0             	call   *%r8
  800628:	48 8b 83 80 00 00 00 	mov    0x80(%rbx),%rax
  80062f:	49 39 84 24 80 00 00 	cmp    %rax,0x80(%r12)
  800636:	00 
  800637:	0f 84 88 02 00 00    	je     8008c5 <check_regs+0x8a0>
  80063d:	48 bf 2a 40 80 00 00 	movabs $0x80402a,%rdi
  800644:	00 00 00 
  800647:	b8 00 00 00 00       	mov    $0x0,%eax
  80064c:	49 bd 1e 0f 80 00 00 	movabs $0x800f1e,%r13
  800653:	00 00 00 
  800656:	41 ff d5             	call   *%r13
    CHECK(rsp, rsp);
  800659:	48 8b 8b 88 00 00 00 	mov    0x88(%rbx),%rcx
  800660:	49 8b 94 24 88 00 00 	mov    0x88(%r12),%rdx
  800667:	00 
  800668:	48 be 6b 40 80 00 00 	movabs $0x80406b,%rsi
  80066f:	00 00 00 
  800672:	48 bf 14 40 80 00 00 	movabs $0x804014,%rdi
  800679:	00 00 00 
  80067c:	b8 00 00 00 00       	mov    $0x0,%eax
  800681:	41 ff d5             	call   *%r13
  800684:	48 8b 83 88 00 00 00 	mov    0x88(%rbx),%rax
  80068b:	49 39 84 24 88 00 00 	cmp    %rax,0x88(%r12)
  800692:	00 
  800693:	0f 84 ea 02 00 00    	je     800983 <check_regs+0x95e>
  800699:	48 bf 2a 40 80 00 00 	movabs $0x80402a,%rdi
  8006a0:	00 00 00 
  8006a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8006a8:	48 bb 1e 0f 80 00 00 	movabs $0x800f1e,%rbx
  8006af:	00 00 00 
  8006b2:	ff d3                	call   *%rbx

#undef CHECK

    cprintf("Registers %s ", testname);
  8006b4:	4c 89 f6             	mov    %r14,%rsi
  8006b7:	48 bf 6f 40 80 00 00 	movabs $0x80406f,%rdi
  8006be:	00 00 00 
  8006c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8006c6:	ff d3                	call   *%rbx
    if (!mismatch)
        cprintf("OK\n");
    else
        cprintf("MISMATCH\n");
  8006c8:	48 bf 2a 40 80 00 00 	movabs $0x80402a,%rdi
  8006cf:	00 00 00 
  8006d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8006d7:	48 ba 1e 0f 80 00 00 	movabs $0x800f1e,%rdx
  8006de:	00 00 00 
  8006e1:	ff d2                	call   *%rdx
}
  8006e3:	e9 8c 02 00 00       	jmp    800974 <check_regs+0x94f>
    CHECK(r14, regs.reg_r14);
  8006e8:	48 bf 26 40 80 00 00 	movabs $0x804026,%rdi
  8006ef:	00 00 00 
  8006f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8006f7:	41 ff d5             	call   *%r13
    int mismatch = 0;
  8006fa:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  800700:	e9 bc f9 ff ff       	jmp    8000c1 <check_regs+0x9c>
    CHECK(r13, regs.reg_r13);
  800705:	48 bf 26 40 80 00 00 	movabs $0x804026,%rdi
  80070c:	00 00 00 
  80070f:	b8 00 00 00 00       	mov    $0x0,%eax
  800714:	48 ba 1e 0f 80 00 00 	movabs $0x800f1e,%rdx
  80071b:	00 00 00 
  80071e:	ff d2                	call   *%rdx
  800720:	e9 fb f9 ff ff       	jmp    800120 <check_regs+0xfb>
    CHECK(r12, regs.reg_r12);
  800725:	48 bf 26 40 80 00 00 	movabs $0x804026,%rdi
  80072c:	00 00 00 
  80072f:	b8 00 00 00 00       	mov    $0x0,%eax
  800734:	48 ba 1e 0f 80 00 00 	movabs $0x800f1e,%rdx
  80073b:	00 00 00 
  80073e:	ff d2                	call   *%rdx
  800740:	e9 3a fa ff ff       	jmp    80017f <check_regs+0x15a>
    CHECK(r11, regs.reg_r11);
  800745:	48 bf 26 40 80 00 00 	movabs $0x804026,%rdi
  80074c:	00 00 00 
  80074f:	b8 00 00 00 00       	mov    $0x0,%eax
  800754:	48 ba 1e 0f 80 00 00 	movabs $0x800f1e,%rdx
  80075b:	00 00 00 
  80075e:	ff d2                	call   *%rdx
  800760:	e9 79 fa ff ff       	jmp    8001de <check_regs+0x1b9>
    CHECK(r10, regs.reg_r10);
  800765:	48 bf 26 40 80 00 00 	movabs $0x804026,%rdi
  80076c:	00 00 00 
  80076f:	b8 00 00 00 00       	mov    $0x0,%eax
  800774:	48 ba 1e 0f 80 00 00 	movabs $0x800f1e,%rdx
  80077b:	00 00 00 
  80077e:	ff d2                	call   *%rdx
  800780:	e9 b8 fa ff ff       	jmp    80023d <check_regs+0x218>
    CHECK(rsi, regs.reg_rsi);
  800785:	48 bf 26 40 80 00 00 	movabs $0x804026,%rdi
  80078c:	00 00 00 
  80078f:	b8 00 00 00 00       	mov    $0x0,%eax
  800794:	48 ba 1e 0f 80 00 00 	movabs $0x800f1e,%rdx
  80079b:	00 00 00 
  80079e:	ff d2                	call   *%rdx
  8007a0:	e9 f7 fa ff ff       	jmp    80029c <check_regs+0x277>
    CHECK(rdi, regs.reg_rdi);
  8007a5:	48 bf 26 40 80 00 00 	movabs $0x804026,%rdi
  8007ac:	00 00 00 
  8007af:	b8 00 00 00 00       	mov    $0x0,%eax
  8007b4:	48 ba 1e 0f 80 00 00 	movabs $0x800f1e,%rdx
  8007bb:	00 00 00 
  8007be:	ff d2                	call   *%rdx
  8007c0:	e9 36 fb ff ff       	jmp    8002fb <check_regs+0x2d6>
    CHECK(rdi, regs.reg_rdi);
  8007c5:	48 bf 26 40 80 00 00 	movabs $0x804026,%rdi
  8007cc:	00 00 00 
  8007cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8007d4:	48 ba 1e 0f 80 00 00 	movabs $0x800f1e,%rdx
  8007db:	00 00 00 
  8007de:	ff d2                	call   *%rdx
  8007e0:	e9 75 fb ff ff       	jmp    80035a <check_regs+0x335>
    CHECK(rsi, regs.reg_rsi);
  8007e5:	48 bf 26 40 80 00 00 	movabs $0x804026,%rdi
  8007ec:	00 00 00 
  8007ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8007f4:	48 ba 1e 0f 80 00 00 	movabs $0x800f1e,%rdx
  8007fb:	00 00 00 
  8007fe:	ff d2                	call   *%rdx
  800800:	e9 b4 fb ff ff       	jmp    8003b9 <check_regs+0x394>
    CHECK(rbp, regs.reg_rbp);
  800805:	48 bf 26 40 80 00 00 	movabs $0x804026,%rdi
  80080c:	00 00 00 
  80080f:	b8 00 00 00 00       	mov    $0x0,%eax
  800814:	48 ba 1e 0f 80 00 00 	movabs $0x800f1e,%rdx
  80081b:	00 00 00 
  80081e:	ff d2                	call   *%rdx
  800820:	e9 f3 fb ff ff       	jmp    800418 <check_regs+0x3f3>
    CHECK(rbx, regs.reg_rbx);
  800825:	48 bf 26 40 80 00 00 	movabs $0x804026,%rdi
  80082c:	00 00 00 
  80082f:	b8 00 00 00 00       	mov    $0x0,%eax
  800834:	48 ba 1e 0f 80 00 00 	movabs $0x800f1e,%rdx
  80083b:	00 00 00 
  80083e:	ff d2                	call   *%rdx
  800840:	e9 32 fc ff ff       	jmp    800477 <check_regs+0x452>
    CHECK(rdx, regs.reg_rdx);
  800845:	48 bf 26 40 80 00 00 	movabs $0x804026,%rdi
  80084c:	00 00 00 
  80084f:	b8 00 00 00 00       	mov    $0x0,%eax
  800854:	48 ba 1e 0f 80 00 00 	movabs $0x800f1e,%rdx
  80085b:	00 00 00 
  80085e:	ff d2                	call   *%rdx
  800860:	e9 71 fc ff ff       	jmp    8004d6 <check_regs+0x4b1>
    CHECK(rcx, regs.reg_rcx);
  800865:	48 bf 26 40 80 00 00 	movabs $0x804026,%rdi
  80086c:	00 00 00 
  80086f:	b8 00 00 00 00       	mov    $0x0,%eax
  800874:	48 ba 1e 0f 80 00 00 	movabs $0x800f1e,%rdx
  80087b:	00 00 00 
  80087e:	ff d2                	call   *%rdx
  800880:	e9 b0 fc ff ff       	jmp    800535 <check_regs+0x510>
    CHECK(rax, regs.reg_rax);
  800885:	48 bf 26 40 80 00 00 	movabs $0x804026,%rdi
  80088c:	00 00 00 
  80088f:	b8 00 00 00 00       	mov    $0x0,%eax
  800894:	48 ba 1e 0f 80 00 00 	movabs $0x800f1e,%rdx
  80089b:	00 00 00 
  80089e:	ff d2                	call   *%rdx
  8008a0:	e9 ef fc ff ff       	jmp    800594 <check_regs+0x56f>
    CHECK(rip, rip);
  8008a5:	48 bf 26 40 80 00 00 	movabs $0x804026,%rdi
  8008ac:	00 00 00 
  8008af:	b8 00 00 00 00       	mov    $0x0,%eax
  8008b4:	48 ba 1e 0f 80 00 00 	movabs $0x800f1e,%rdx
  8008bb:	00 00 00 
  8008be:	ff d2                	call   *%rdx
  8008c0:	e9 2e fd ff ff       	jmp    8005f3 <check_regs+0x5ce>
    CHECK(rflags, rflags);
  8008c5:	48 bf 26 40 80 00 00 	movabs $0x804026,%rdi
  8008cc:	00 00 00 
  8008cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8008d4:	49 bf 1e 0f 80 00 00 	movabs $0x800f1e,%r15
  8008db:	00 00 00 
  8008de:	41 ff d7             	call   *%r15
    CHECK(rsp, rsp);
  8008e1:	48 8b 8b 88 00 00 00 	mov    0x88(%rbx),%rcx
  8008e8:	49 8b 94 24 88 00 00 	mov    0x88(%r12),%rdx
  8008ef:	00 
  8008f0:	48 be 6b 40 80 00 00 	movabs $0x80406b,%rsi
  8008f7:	00 00 00 
  8008fa:	48 bf 14 40 80 00 00 	movabs $0x804014,%rdi
  800901:	00 00 00 
  800904:	b8 00 00 00 00       	mov    $0x0,%eax
  800909:	41 ff d7             	call   *%r15
  80090c:	48 8b 83 88 00 00 00 	mov    0x88(%rbx),%rax
  800913:	49 39 84 24 88 00 00 	cmp    %rax,0x88(%r12)
  80091a:	00 
  80091b:	0f 85 78 fd ff ff    	jne    800699 <check_regs+0x674>
  800921:	48 bf 26 40 80 00 00 	movabs $0x804026,%rdi
  800928:	00 00 00 
  80092b:	b8 00 00 00 00       	mov    $0x0,%eax
  800930:	48 bb 1e 0f 80 00 00 	movabs $0x800f1e,%rbx
  800937:	00 00 00 
  80093a:	ff d3                	call   *%rbx
    cprintf("Registers %s ", testname);
  80093c:	4c 89 f6             	mov    %r14,%rsi
  80093f:	48 bf 6f 40 80 00 00 	movabs $0x80406f,%rdi
  800946:	00 00 00 
  800949:	b8 00 00 00 00       	mov    $0x0,%eax
  80094e:	ff d3                	call   *%rbx
    if (!mismatch)
  800950:	45 85 ed             	test   %r13d,%r13d
  800953:	0f 85 6f fd ff ff    	jne    8006c8 <check_regs+0x6a3>
        cprintf("OK\n");
  800959:	48 bf 26 40 80 00 00 	movabs $0x804026,%rdi
  800960:	00 00 00 
  800963:	b8 00 00 00 00       	mov    $0x0,%eax
  800968:	48 ba 1e 0f 80 00 00 	movabs $0x800f1e,%rdx
  80096f:	00 00 00 
  800972:	ff d2                	call   *%rdx
}
  800974:	48 83 c4 08          	add    $0x8,%rsp
  800978:	5b                   	pop    %rbx
  800979:	41 5c                	pop    %r12
  80097b:	41 5d                	pop    %r13
  80097d:	41 5e                	pop    %r14
  80097f:	41 5f                	pop    %r15
  800981:	5d                   	pop    %rbp
  800982:	c3                   	ret
    CHECK(rsp, rsp);
  800983:	48 bf 26 40 80 00 00 	movabs $0x804026,%rdi
  80098a:	00 00 00 
  80098d:	b8 00 00 00 00       	mov    $0x0,%eax
  800992:	48 bb 1e 0f 80 00 00 	movabs $0x800f1e,%rbx
  800999:	00 00 00 
  80099c:	ff d3                	call   *%rbx
    cprintf("Registers %s ", testname);
  80099e:	4c 89 f6             	mov    %r14,%rsi
  8009a1:	48 bf 6f 40 80 00 00 	movabs $0x80406f,%rdi
  8009a8:	00 00 00 
  8009ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8009b0:	ff d3                	call   *%rbx
    if (!mismatch)
  8009b2:	e9 11 fd ff ff       	jmp    8006c8 <check_regs+0x6a3>

00000000008009b7 <pgfault>:

static bool
pgfault(struct UTrapframe *utf) {
  8009b7:	f3 0f 1e fa          	endbr64
  8009bb:	55                   	push   %rbp
  8009bc:	48 89 e5             	mov    %rsp,%rbp
    int r;

    if (utf->utf_fault_va != (uint64_t)UTEMP)
  8009bf:	48 8b 0f             	mov    (%rdi),%rcx
  8009c2:	48 81 f9 00 00 40 00 	cmp    $0x400000,%rcx
  8009c9:	0f 85 13 01 00 00    	jne    800ae2 <pgfault+0x12b>
        panic("pgfault expected at UTEMP, got 0x%08lx (rip %08lx)",
              (unsigned long)utf->utf_fault_va, (unsigned long)utf->utf_rip);

    /* Check registers in UTrapframe */
    during.regs = utf->utf_regs;
  8009cf:	48 be a0 60 80 00 00 	movabs $0x8060a0,%rsi
  8009d6:	00 00 00 
  8009d9:	48 8b 57 10          	mov    0x10(%rdi),%rdx
  8009dd:	48 89 16             	mov    %rdx,(%rsi)
  8009e0:	48 8b 57 18          	mov    0x18(%rdi),%rdx
  8009e4:	48 89 56 08          	mov    %rdx,0x8(%rsi)
  8009e8:	48 8b 57 20          	mov    0x20(%rdi),%rdx
  8009ec:	48 89 56 10          	mov    %rdx,0x10(%rsi)
  8009f0:	48 8b 57 28          	mov    0x28(%rdi),%rdx
  8009f4:	48 89 56 18          	mov    %rdx,0x18(%rsi)
  8009f8:	48 8b 57 30          	mov    0x30(%rdi),%rdx
  8009fc:	48 89 56 20          	mov    %rdx,0x20(%rsi)
  800a00:	48 8b 57 38          	mov    0x38(%rdi),%rdx
  800a04:	48 89 56 28          	mov    %rdx,0x28(%rsi)
  800a08:	48 8b 57 40          	mov    0x40(%rdi),%rdx
  800a0c:	48 89 56 30          	mov    %rdx,0x30(%rsi)
  800a10:	48 8b 57 48          	mov    0x48(%rdi),%rdx
  800a14:	48 89 56 38          	mov    %rdx,0x38(%rsi)
  800a18:	48 8b 57 50          	mov    0x50(%rdi),%rdx
  800a1c:	48 89 56 40          	mov    %rdx,0x40(%rsi)
  800a20:	48 8b 57 58          	mov    0x58(%rdi),%rdx
  800a24:	48 89 56 48          	mov    %rdx,0x48(%rsi)
  800a28:	48 8b 57 60          	mov    0x60(%rdi),%rdx
  800a2c:	48 89 56 50          	mov    %rdx,0x50(%rsi)
  800a30:	48 8b 57 68          	mov    0x68(%rdi),%rdx
  800a34:	48 89 56 58          	mov    %rdx,0x58(%rsi)
  800a38:	48 8b 57 70          	mov    0x70(%rdi),%rdx
  800a3c:	48 89 56 60          	mov    %rdx,0x60(%rsi)
  800a40:	48 8b 57 78          	mov    0x78(%rdi),%rdx
  800a44:	48 89 56 68          	mov    %rdx,0x68(%rsi)
  800a48:	48 8b 97 80 00 00 00 	mov    0x80(%rdi),%rdx
  800a4f:	48 89 56 70          	mov    %rdx,0x70(%rsi)
    during.rip = utf->utf_rip;
  800a53:	48 8b 97 88 00 00 00 	mov    0x88(%rdi),%rdx
  800a5a:	48 89 56 78          	mov    %rdx,0x78(%rsi)
    during.rflags = utf->utf_rflags & 0xfff;
  800a5e:	48 8b 97 90 00 00 00 	mov    0x90(%rdi),%rdx
  800a65:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  800a6b:	48 89 96 80 00 00 00 	mov    %rdx,0x80(%rsi)
    during.rsp = utf->utf_rsp;
  800a72:	48 8b 87 98 00 00 00 	mov    0x98(%rdi),%rax
  800a79:	48 89 86 88 00 00 00 	mov    %rax,0x88(%rsi)
    check_regs(&before, "before", &during, "during", "in UTrapframe");
  800a80:	49 b8 8e 40 80 00 00 	movabs $0x80408e,%r8
  800a87:	00 00 00 
  800a8a:	48 b9 9c 40 80 00 00 	movabs $0x80409c,%rcx
  800a91:	00 00 00 
  800a94:	48 89 f2             	mov    %rsi,%rdx
  800a97:	48 be a3 40 80 00 00 	movabs $0x8040a3,%rsi
  800a9e:	00 00 00 
  800aa1:	48 bf 40 61 80 00 00 	movabs $0x806140,%rdi
  800aa8:	00 00 00 
  800aab:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  800ab2:	00 00 00 
  800ab5:	ff d0                	call   *%rax
    ;

    /* Map UTEMP so the write succeeds */
    if ((r = sys_alloc_region(0, UTEMP, PAGE_SIZE, PROT_RW)) < 0)
  800ab7:	b9 06 00 00 00       	mov    $0x6,%ecx
  800abc:	ba 00 10 00 00       	mov    $0x1000,%edx
  800ac1:	be 00 00 40 00       	mov    $0x400000,%esi
  800ac6:	bf 00 00 00 00       	mov    $0x0,%edi
  800acb:	48 b8 6c 1e 80 00 00 	movabs $0x801e6c,%rax
  800ad2:	00 00 00 
  800ad5:	ff d0                	call   *%rax
  800ad7:	85 c0                	test   %eax,%eax
  800ad9:	78 39                	js     800b14 <pgfault+0x15d>
        panic("sys_page_alloc: %i", r);
    return 1;
}
  800adb:	b8 01 00 00 00       	mov    $0x1,%eax
  800ae0:	5d                   	pop    %rbp
  800ae1:	c3                   	ret
        panic("pgfault expected at UTEMP, got 0x%08lx (rip %08lx)",
  800ae2:	4c 8b 87 88 00 00 00 	mov    0x88(%rdi),%r8
  800ae9:	48 ba 70 43 80 00 00 	movabs $0x804370,%rdx
  800af0:	00 00 00 
  800af3:	be 62 00 00 00       	mov    $0x62,%esi
  800af8:	48 bf 7d 40 80 00 00 	movabs $0x80407d,%rdi
  800aff:	00 00 00 
  800b02:	b8 00 00 00 00       	mov    $0x0,%eax
  800b07:	49 b9 c2 0d 80 00 00 	movabs $0x800dc2,%r9
  800b0e:	00 00 00 
  800b11:	41 ff d1             	call   *%r9
        panic("sys_page_alloc: %i", r);
  800b14:	89 c1                	mov    %eax,%ecx
  800b16:	48 ba aa 40 80 00 00 	movabs $0x8040aa,%rdx
  800b1d:	00 00 00 
  800b20:	be 6f 00 00 00       	mov    $0x6f,%esi
  800b25:	48 bf 7d 40 80 00 00 	movabs $0x80407d,%rdi
  800b2c:	00 00 00 
  800b2f:	b8 00 00 00 00       	mov    $0x0,%eax
  800b34:	49 b8 c2 0d 80 00 00 	movabs $0x800dc2,%r8
  800b3b:	00 00 00 
  800b3e:	41 ff d0             	call   *%r8

0000000000800b41 <umain>:

void
umain(int argc, char **argv) {
  800b41:	f3 0f 1e fa          	endbr64
  800b45:	55                   	push   %rbp
  800b46:	48 89 e5             	mov    %rsp,%rbp
    add_pgfault_handler(pgfault);
  800b49:	48 bf b7 09 80 00 00 	movabs $0x8009b7,%rdi
  800b50:	00 00 00 
  800b53:	48 b8 be 22 80 00 00 	movabs $0x8022be,%rax
  800b5a:	00 00 00 
  800b5d:	ff d0                	call   *%rax

    __asm __volatile(
  800b5f:	48 b8 40 61 80 00 00 	movabs $0x806140,%rax
  800b66:	00 00 00 
  800b69:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  800b70:	00 00 00 
  800b73:	50                   	push   %rax
  800b74:	52                   	push   %rdx
  800b75:	50                   	push   %rax
  800b76:	9c                   	pushf
  800b77:	58                   	pop    %rax
  800b78:	48 0d d4 08 00 00    	or     $0x8d4,%rax
  800b7e:	50                   	push   %rax
  800b7f:	9d                   	popf
  800b80:	4c 8b 7c 24 10       	mov    0x10(%rsp),%r15
  800b85:	49 89 87 80 00 00 00 	mov    %rax,0x80(%r15)
  800b8c:	48 8d 04 25 d8 0b 80 	lea    0x800bd8,%rax
  800b93:	00 
  800b94:	49 89 47 78          	mov    %rax,0x78(%r15)
  800b98:	58                   	pop    %rax
  800b99:	4d 89 77 08          	mov    %r14,0x8(%r15)
  800b9d:	4d 89 6f 10          	mov    %r13,0x10(%r15)
  800ba1:	4d 89 67 18          	mov    %r12,0x18(%r15)
  800ba5:	4d 89 5f 20          	mov    %r11,0x20(%r15)
  800ba9:	4d 89 57 28          	mov    %r10,0x28(%r15)
  800bad:	4d 89 4f 30          	mov    %r9,0x30(%r15)
  800bb1:	4d 89 47 38          	mov    %r8,0x38(%r15)
  800bb5:	49 89 77 40          	mov    %rsi,0x40(%r15)
  800bb9:	49 89 7f 48          	mov    %rdi,0x48(%r15)
  800bbd:	49 89 6f 50          	mov    %rbp,0x50(%r15)
  800bc1:	49 89 57 58          	mov    %rdx,0x58(%r15)
  800bc5:	49 89 4f 60          	mov    %rcx,0x60(%r15)
  800bc9:	49 89 5f 68          	mov    %rbx,0x68(%r15)
  800bcd:	49 89 47 70          	mov    %rax,0x70(%r15)
  800bd1:	49 89 a7 88 00 00 00 	mov    %rsp,0x88(%r15)
  800bd8:	c7 04 25 00 00 40 00 	movl   $0x2a,0x400000
  800bdf:	2a 00 00 00 
  800be3:	4c 8b 3c 24          	mov    (%rsp),%r15
  800be7:	4d 89 77 08          	mov    %r14,0x8(%r15)
  800beb:	4d 89 6f 10          	mov    %r13,0x10(%r15)
  800bef:	4d 89 67 18          	mov    %r12,0x18(%r15)
  800bf3:	4d 89 5f 20          	mov    %r11,0x20(%r15)
  800bf7:	4d 89 57 28          	mov    %r10,0x28(%r15)
  800bfb:	4d 89 4f 30          	mov    %r9,0x30(%r15)
  800bff:	4d 89 47 38          	mov    %r8,0x38(%r15)
  800c03:	49 89 77 40          	mov    %rsi,0x40(%r15)
  800c07:	49 89 7f 48          	mov    %rdi,0x48(%r15)
  800c0b:	49 89 6f 50          	mov    %rbp,0x50(%r15)
  800c0f:	49 89 57 58          	mov    %rdx,0x58(%r15)
  800c13:	49 89 4f 60          	mov    %rcx,0x60(%r15)
  800c17:	49 89 5f 68          	mov    %rbx,0x68(%r15)
  800c1b:	49 89 47 70          	mov    %rax,0x70(%r15)
  800c1f:	49 89 a7 88 00 00 00 	mov    %rsp,0x88(%r15)
  800c26:	4c 8b 7c 24 08       	mov    0x8(%rsp),%r15
  800c2b:	4d 8b 77 08          	mov    0x8(%r15),%r14
  800c2f:	4d 8b 6f 10          	mov    0x10(%r15),%r13
  800c33:	4d 8b 67 18          	mov    0x18(%r15),%r12
  800c37:	4d 8b 5f 20          	mov    0x20(%r15),%r11
  800c3b:	4d 8b 57 28          	mov    0x28(%r15),%r10
  800c3f:	4d 8b 4f 30          	mov    0x30(%r15),%r9
  800c43:	4d 8b 47 38          	mov    0x38(%r15),%r8
  800c47:	49 8b 77 40          	mov    0x40(%r15),%rsi
  800c4b:	49 8b 7f 48          	mov    0x48(%r15),%rdi
  800c4f:	49 8b 6f 50          	mov    0x50(%r15),%rbp
  800c53:	49 8b 57 58          	mov    0x58(%r15),%rdx
  800c57:	49 8b 4f 60          	mov    0x60(%r15),%rcx
  800c5b:	49 8b 5f 68          	mov    0x68(%r15),%rbx
  800c5f:	49 8b 47 70          	mov    0x70(%r15),%rax
  800c63:	49 8b a7 88 00 00 00 	mov    0x88(%r15),%rsp
  800c6a:	50                   	push   %rax
  800c6b:	9c                   	pushf
  800c6c:	58                   	pop    %rax
  800c6d:	4c 8b 7c 24 08       	mov    0x8(%rsp),%r15
  800c72:	49 89 87 80 00 00 00 	mov    %rax,0x80(%r15)
  800c79:	58                   	pop    %rax
            : "memory", "cc");

    /* Check UTEMP to roughly determine that EIP was restored
     * correctly (of course, we probably wouldn't get this far if
     * it weren't) */
    if (*(int *)UTEMP != 42)
  800c7a:	83 3c 25 00 00 40 00 	cmpl   $0x2a,0x400000
  800c81:	2a 
  800c82:	75 48                	jne    800ccc <umain+0x18b>
        cprintf("RIP after page-fault MISMATCH\n");
    after.rip = before.rip;
  800c84:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  800c8b:	00 00 00 
  800c8e:	48 bf 40 61 80 00 00 	movabs $0x806140,%rdi
  800c95:	00 00 00 
  800c98:	48 8b 47 78          	mov    0x78(%rdi),%rax
  800c9c:	48 89 42 78          	mov    %rax,0x78(%rdx)

    check_regs(&before, "before", &after, "after", "after page-fault");
  800ca0:	49 b8 bd 40 80 00 00 	movabs $0x8040bd,%r8
  800ca7:	00 00 00 
  800caa:	48 b9 ce 40 80 00 00 	movabs $0x8040ce,%rcx
  800cb1:	00 00 00 
  800cb4:	48 be a3 40 80 00 00 	movabs $0x8040a3,%rsi
  800cbb:	00 00 00 
  800cbe:	48 b8 25 00 80 00 00 	movabs $0x800025,%rax
  800cc5:	00 00 00 
  800cc8:	ff d0                	call   *%rax
}
  800cca:	5d                   	pop    %rbp
  800ccb:	c3                   	ret
        cprintf("RIP after page-fault MISMATCH\n");
  800ccc:	48 bf a8 43 80 00 00 	movabs $0x8043a8,%rdi
  800cd3:	00 00 00 
  800cd6:	b8 00 00 00 00       	mov    $0x0,%eax
  800cdb:	48 ba 1e 0f 80 00 00 	movabs $0x800f1e,%rdx
  800ce2:	00 00 00 
  800ce5:	ff d2                	call   *%rdx
  800ce7:	eb 9b                	jmp    800c84 <umain+0x143>

0000000000800ce9 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  800ce9:	f3 0f 1e fa          	endbr64
  800ced:	55                   	push   %rbp
  800cee:	48 89 e5             	mov    %rsp,%rbp
  800cf1:	41 56                	push   %r14
  800cf3:	41 55                	push   %r13
  800cf5:	41 54                	push   %r12
  800cf7:	53                   	push   %rbx
  800cf8:	41 89 fd             	mov    %edi,%r13d
  800cfb:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
     * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  800cfe:	48 ba d8 50 80 00 00 	movabs $0x8050d8,%rdx
  800d05:	00 00 00 
  800d08:	48 b8 d8 50 80 00 00 	movabs $0x8050d8,%rax
  800d0f:	00 00 00 
  800d12:	48 39 c2             	cmp    %rax,%rdx
  800d15:	73 17                	jae    800d2e <libmain+0x45>
    void (**ctor)() = &__ctors_start;
  800d17:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  800d1a:	49 89 c4             	mov    %rax,%r12
  800d1d:	48 83 c3 08          	add    $0x8,%rbx
  800d21:	b8 00 00 00 00       	mov    $0x0,%eax
  800d26:	ff 53 f8             	call   *-0x8(%rbx)
  800d29:	4c 39 e3             	cmp    %r12,%rbx
  800d2c:	72 ef                	jb     800d1d <libmain+0x34>

    /* Set thisenv to point at our Env structure in envs[]. */

    // LAB 8: Your code here
    thisenv = &((struct Env *)UENVS)[ENVX(sys_getenvid())];
  800d2e:	48 b8 9c 1d 80 00 00 	movabs $0x801d9c,%rax
  800d35:	00 00 00 
  800d38:	ff d0                	call   *%rax
  800d3a:	25 ff 03 00 00       	and    $0x3ff,%eax
  800d3f:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  800d43:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  800d47:	48 c1 e0 04          	shl    $0x4,%rax
  800d4b:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  800d52:	00 00 00 
  800d55:	48 01 d0             	add    %rdx,%rax
  800d58:	48 a3 d0 61 80 00 00 	movabs %rax,0x8061d0
  800d5f:	00 00 00 

    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  800d62:	45 85 ed             	test   %r13d,%r13d
  800d65:	7e 0d                	jle    800d74 <libmain+0x8b>
  800d67:	49 8b 06             	mov    (%r14),%rax
  800d6a:	48 a3 00 50 80 00 00 	movabs %rax,0x805000
  800d71:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  800d74:	4c 89 f6             	mov    %r14,%rsi
  800d77:	44 89 ef             	mov    %r13d,%edi
  800d7a:	48 b8 41 0b 80 00 00 	movabs $0x800b41,%rax
  800d81:	00 00 00 
  800d84:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  800d86:	48 b8 9b 0d 80 00 00 	movabs $0x800d9b,%rax
  800d8d:	00 00 00 
  800d90:	ff d0                	call   *%rax
#endif
}
  800d92:	5b                   	pop    %rbx
  800d93:	41 5c                	pop    %r12
  800d95:	41 5d                	pop    %r13
  800d97:	41 5e                	pop    %r14
  800d99:	5d                   	pop    %rbp
  800d9a:	c3                   	ret

0000000000800d9b <exit>:

#include <inc/lib.h>

void
exit(void) {
  800d9b:	f3 0f 1e fa          	endbr64
  800d9f:	55                   	push   %rbp
  800da0:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  800da3:	48 b8 86 27 80 00 00 	movabs $0x802786,%rax
  800daa:	00 00 00 
  800dad:	ff d0                	call   *%rax
    sys_env_destroy(0);
  800daf:	bf 00 00 00 00       	mov    $0x0,%edi
  800db4:	48 b8 2d 1d 80 00 00 	movabs $0x801d2d,%rax
  800dbb:	00 00 00 
  800dbe:	ff d0                	call   *%rax
}
  800dc0:	5d                   	pop    %rbp
  800dc1:	c3                   	ret

0000000000800dc2 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  800dc2:	f3 0f 1e fa          	endbr64
  800dc6:	55                   	push   %rbp
  800dc7:	48 89 e5             	mov    %rsp,%rbp
  800dca:	41 56                	push   %r14
  800dcc:	41 55                	push   %r13
  800dce:	41 54                	push   %r12
  800dd0:	53                   	push   %rbx
  800dd1:	48 83 ec 50          	sub    $0x50,%rsp
  800dd5:	49 89 fc             	mov    %rdi,%r12
  800dd8:	41 89 f5             	mov    %esi,%r13d
  800ddb:	48 89 d3             	mov    %rdx,%rbx
  800dde:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800de2:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  800de6:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  800dea:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  800df1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800df5:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  800df9:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  800dfd:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  800e01:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  800e08:	00 00 00 
  800e0b:	4c 8b 30             	mov    (%rax),%r14
  800e0e:	48 b8 9c 1d 80 00 00 	movabs $0x801d9c,%rax
  800e15:	00 00 00 
  800e18:	ff d0                	call   *%rax
  800e1a:	89 c6                	mov    %eax,%esi
  800e1c:	45 89 e8             	mov    %r13d,%r8d
  800e1f:	4c 89 e1             	mov    %r12,%rcx
  800e22:	4c 89 f2             	mov    %r14,%rdx
  800e25:	48 bf c8 43 80 00 00 	movabs $0x8043c8,%rdi
  800e2c:	00 00 00 
  800e2f:	b8 00 00 00 00       	mov    $0x0,%eax
  800e34:	49 bc 1e 0f 80 00 00 	movabs $0x800f1e,%r12
  800e3b:	00 00 00 
  800e3e:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  800e41:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  800e45:	48 89 df             	mov    %rbx,%rdi
  800e48:	48 b8 b6 0e 80 00 00 	movabs $0x800eb6,%rax
  800e4f:	00 00 00 
  800e52:	ff d0                	call   *%rax
    cprintf("\n");
  800e54:	48 bf 32 40 80 00 00 	movabs $0x804032,%rdi
  800e5b:	00 00 00 
  800e5e:	b8 00 00 00 00       	mov    $0x0,%eax
  800e63:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  800e66:	cc                   	int3
  800e67:	eb fd                	jmp    800e66 <_panic+0xa4>

0000000000800e69 <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  800e69:	f3 0f 1e fa          	endbr64
  800e6d:	55                   	push   %rbp
  800e6e:	48 89 e5             	mov    %rsp,%rbp
  800e71:	53                   	push   %rbx
  800e72:	48 83 ec 08          	sub    $0x8,%rsp
  800e76:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  800e79:	8b 06                	mov    (%rsi),%eax
  800e7b:	8d 50 01             	lea    0x1(%rax),%edx
  800e7e:	89 16                	mov    %edx,(%rsi)
  800e80:	48 98                	cltq
  800e82:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  800e87:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  800e8d:	74 0a                	je     800e99 <putch+0x30>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  800e8f:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  800e93:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  800e97:	c9                   	leave
  800e98:	c3                   	ret
        sys_cputs(state->buf, state->offset);
  800e99:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  800e9d:	be ff 00 00 00       	mov    $0xff,%esi
  800ea2:	48 b8 c7 1c 80 00 00 	movabs $0x801cc7,%rax
  800ea9:	00 00 00 
  800eac:	ff d0                	call   *%rax
        state->offset = 0;
  800eae:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  800eb4:	eb d9                	jmp    800e8f <putch+0x26>

0000000000800eb6 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  800eb6:	f3 0f 1e fa          	endbr64
  800eba:	55                   	push   %rbp
  800ebb:	48 89 e5             	mov    %rsp,%rbp
  800ebe:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800ec5:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  800ec8:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  800ecf:	b9 21 00 00 00       	mov    $0x21,%ecx
  800ed4:	b8 00 00 00 00       	mov    $0x0,%eax
  800ed9:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  800edc:	48 89 f1             	mov    %rsi,%rcx
  800edf:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  800ee6:	48 bf 69 0e 80 00 00 	movabs $0x800e69,%rdi
  800eed:	00 00 00 
  800ef0:	48 b8 7e 10 80 00 00 	movabs $0x80107e,%rax
  800ef7:	00 00 00 
  800efa:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  800efc:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  800f03:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  800f0a:	48 b8 c7 1c 80 00 00 	movabs $0x801cc7,%rax
  800f11:	00 00 00 
  800f14:	ff d0                	call   *%rax

    return state.count;
}
  800f16:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  800f1c:	c9                   	leave
  800f1d:	c3                   	ret

0000000000800f1e <cprintf>:

int
cprintf(const char *fmt, ...) {
  800f1e:	f3 0f 1e fa          	endbr64
  800f22:	55                   	push   %rbp
  800f23:	48 89 e5             	mov    %rsp,%rbp
  800f26:	48 83 ec 50          	sub    $0x50,%rsp
  800f2a:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  800f2e:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  800f32:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800f36:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  800f3a:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  800f3e:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  800f45:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f49:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800f4d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800f51:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  800f55:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  800f59:	48 b8 b6 0e 80 00 00 	movabs $0x800eb6,%rax
  800f60:	00 00 00 
  800f63:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  800f65:	c9                   	leave
  800f66:	c3                   	ret

0000000000800f67 <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  800f67:	f3 0f 1e fa          	endbr64
  800f6b:	55                   	push   %rbp
  800f6c:	48 89 e5             	mov    %rsp,%rbp
  800f6f:	41 57                	push   %r15
  800f71:	41 56                	push   %r14
  800f73:	41 55                	push   %r13
  800f75:	41 54                	push   %r12
  800f77:	53                   	push   %rbx
  800f78:	48 83 ec 18          	sub    $0x18,%rsp
  800f7c:	49 89 fc             	mov    %rdi,%r12
  800f7f:	49 89 f5             	mov    %rsi,%r13
  800f82:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  800f86:	8b 45 10             	mov    0x10(%rbp),%eax
  800f89:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  800f8c:	41 89 cf             	mov    %ecx,%r15d
  800f8f:	4c 39 fa             	cmp    %r15,%rdx
  800f92:	73 5b                	jae    800fef <print_num+0x88>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  800f94:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  800f98:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  800f9c:	85 db                	test   %ebx,%ebx
  800f9e:	7e 0e                	jle    800fae <print_num+0x47>
            putch(padc, put_arg);
  800fa0:	4c 89 ee             	mov    %r13,%rsi
  800fa3:	44 89 f7             	mov    %r14d,%edi
  800fa6:	41 ff d4             	call   *%r12
        while (--width > 0) {
  800fa9:	83 eb 01             	sub    $0x1,%ebx
  800fac:	75 f2                	jne    800fa0 <print_num+0x39>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  800fae:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  800fb2:	48 b9 ef 40 80 00 00 	movabs $0x8040ef,%rcx
  800fb9:	00 00 00 
  800fbc:	48 b8 de 40 80 00 00 	movabs $0x8040de,%rax
  800fc3:	00 00 00 
  800fc6:	48 0f 45 c8          	cmovne %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  800fca:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800fce:	ba 00 00 00 00       	mov    $0x0,%edx
  800fd3:	49 f7 f7             	div    %r15
  800fd6:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  800fda:	4c 89 ee             	mov    %r13,%rsi
  800fdd:	41 ff d4             	call   *%r12
}
  800fe0:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  800fe4:	5b                   	pop    %rbx
  800fe5:	41 5c                	pop    %r12
  800fe7:	41 5d                	pop    %r13
  800fe9:	41 5e                	pop    %r14
  800feb:	41 5f                	pop    %r15
  800fed:	5d                   	pop    %rbp
  800fee:	c3                   	ret
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  800fef:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ff3:	ba 00 00 00 00       	mov    $0x0,%edx
  800ff8:	49 f7 f7             	div    %r15
  800ffb:	48 83 ec 08          	sub    $0x8,%rsp
  800fff:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  801003:	52                   	push   %rdx
  801004:	45 0f be c9          	movsbl %r9b,%r9d
  801008:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  80100c:	48 89 c2             	mov    %rax,%rdx
  80100f:	48 b8 67 0f 80 00 00 	movabs $0x800f67,%rax
  801016:	00 00 00 
  801019:	ff d0                	call   *%rax
  80101b:	48 83 c4 10          	add    $0x10,%rsp
  80101f:	eb 8d                	jmp    800fae <print_num+0x47>

0000000000801021 <sprintputch>:
    char *end;
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
  801021:	f3 0f 1e fa          	endbr64
    state->count++;
  801025:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  801029:	48 8b 06             	mov    (%rsi),%rax
  80102c:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  801030:	73 0a                	jae    80103c <sprintputch+0x1b>
        *state->start++ = ch;
  801032:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801036:	48 89 16             	mov    %rdx,(%rsi)
  801039:	40 88 38             	mov    %dil,(%rax)
    }
}
  80103c:	c3                   	ret

000000000080103d <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  80103d:	f3 0f 1e fa          	endbr64
  801041:	55                   	push   %rbp
  801042:	48 89 e5             	mov    %rsp,%rbp
  801045:	48 83 ec 50          	sub    $0x50,%rsp
  801049:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80104d:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  801051:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  801055:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  80105c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801060:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801064:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801068:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  80106c:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  801070:	48 b8 7e 10 80 00 00 	movabs $0x80107e,%rax
  801077:	00 00 00 
  80107a:	ff d0                	call   *%rax
}
  80107c:	c9                   	leave
  80107d:	c3                   	ret

000000000080107e <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  80107e:	f3 0f 1e fa          	endbr64
  801082:	55                   	push   %rbp
  801083:	48 89 e5             	mov    %rsp,%rbp
  801086:	41 57                	push   %r15
  801088:	41 56                	push   %r14
  80108a:	41 55                	push   %r13
  80108c:	41 54                	push   %r12
  80108e:	53                   	push   %rbx
  80108f:	48 83 ec 38          	sub    $0x38,%rsp
  801093:	49 89 fe             	mov    %rdi,%r14
  801096:	49 89 f5             	mov    %rsi,%r13
  801099:	48 89 d3             	mov    %rdx,%rbx
    va_copy(aq, ap);
  80109c:	48 8b 01             	mov    (%rcx),%rax
  80109f:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  8010a3:	48 8b 41 08          	mov    0x8(%rcx),%rax
  8010a7:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8010ab:	48 8b 41 10          	mov    0x10(%rcx),%rax
  8010af:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  8010b3:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  8010b7:	0f b6 3b             	movzbl (%rbx),%edi
  8010ba:	40 80 ff 25          	cmp    $0x25,%dil
  8010be:	74 18                	je     8010d8 <vprintfmt+0x5a>
            if (!ch) return;
  8010c0:	40 84 ff             	test   %dil,%dil
  8010c3:	0f 84 b2 06 00 00    	je     80177b <vprintfmt+0x6fd>
            putch(ch, put_arg);
  8010c9:	40 0f b6 ff          	movzbl %dil,%edi
  8010cd:	4c 89 ee             	mov    %r13,%rsi
  8010d0:	41 ff d6             	call   *%r14
        while ((ch = *ufmt++) != '%') {
  8010d3:	4c 89 e3             	mov    %r12,%rbx
  8010d6:	eb db                	jmp    8010b3 <vprintfmt+0x35>
        bool altflag = 0, zflag = 0;
  8010d8:	be 00 00 00 00       	mov    $0x0,%esi
  8010dd:	c6 45 ab 00          	movb   $0x0,-0x55(%rbp)
        unsigned lflag = 0, base = 10;
  8010e1:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  8010e6:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  8010ec:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  8010f3:	c6 45 aa 20          	movb   $0x20,-0x56(%rbp)
        switch (ch = *ufmt++) {
  8010f7:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  8010fc:	41 0f b6 04 24       	movzbl (%r12),%eax
  801101:	88 45 a0             	mov    %al,-0x60(%rbp)
  801104:	83 e8 23             	sub    $0x23,%eax
  801107:	3c 57                	cmp    $0x57,%al
  801109:	0f 87 52 06 00 00    	ja     801761 <vprintfmt+0x6e3>
  80110f:	0f b6 c0             	movzbl %al,%eax
  801112:	48 b9 e0 44 80 00 00 	movabs $0x8044e0,%rcx
  801119:	00 00 00 
  80111c:	3e ff 24 c1          	notrack jmp *(%rcx,%rax,8)
  801120:	49 89 dc             	mov    %rbx,%r12
            altflag = 1;
  801123:	c6 45 ab 01          	movb   $0x1,-0x55(%rbp)
  801127:	eb ce                	jmp    8010f7 <vprintfmt+0x79>
        switch (ch = *ufmt++) {
  801129:	49 89 dc             	mov    %rbx,%r12
  80112c:	be 01 00 00 00       	mov    $0x1,%esi
  801131:	eb c4                	jmp    8010f7 <vprintfmt+0x79>
            padc = ch;
  801133:	0f b6 45 a0          	movzbl -0x60(%rbp),%eax
  801137:	88 45 aa             	mov    %al,-0x56(%rbp)
        switch (ch = *ufmt++) {
  80113a:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  80113d:	eb b8                	jmp    8010f7 <vprintfmt+0x79>
            precision = va_arg(aq, int);
  80113f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801142:	83 f8 2f             	cmp    $0x2f,%eax
  801145:	77 24                	ja     80116b <vprintfmt+0xed>
  801147:	89 c1                	mov    %eax,%ecx
  801149:	48 03 4d c8          	add    -0x38(%rbp),%rcx
  80114d:	83 c0 08             	add    $0x8,%eax
  801150:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801153:	44 8b 39             	mov    (%rcx),%r15d
        switch (ch = *ufmt++) {
  801156:	49 89 dc             	mov    %rbx,%r12
            if (width < 0) {
  801159:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  80115d:	79 98                	jns    8010f7 <vprintfmt+0x79>
                width = precision;
  80115f:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
                precision = -1;
  801163:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  801169:	eb 8c                	jmp    8010f7 <vprintfmt+0x79>
            precision = va_arg(aq, int);
  80116b:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  80116f:	48 8d 41 08          	lea    0x8(%rcx),%rax
  801173:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801177:	eb da                	jmp    801153 <vprintfmt+0xd5>
                precision = precision * 10 + ch - '0';
  801179:	44 0f b6 7d a0       	movzbl -0x60(%rbp),%r15d
  80117e:	41 83 ef 30          	sub    $0x30,%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  801182:	41 0f b6 44 24 01    	movzbl 0x1(%r12),%eax
  801188:	3c 39                	cmp    $0x39,%al
  80118a:	77 1c                	ja     8011a8 <vprintfmt+0x12a>
            for (precision = 0;; ++ufmt) {
  80118c:	48 83 c3 01          	add    $0x1,%rbx
                precision = precision * 10 + ch - '0';
  801190:	43 8d 0c bf          	lea    (%r15,%r15,4),%ecx
  801194:	0f b6 c0             	movzbl %al,%eax
  801197:	44 8d 7c 48 d0       	lea    -0x30(%rax,%rcx,2),%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  80119c:	0f b6 03             	movzbl (%rbx),%eax
  80119f:	3c 39                	cmp    $0x39,%al
  8011a1:	76 e9                	jbe    80118c <vprintfmt+0x10e>
        process_precision:
  8011a3:	49 89 dc             	mov    %rbx,%r12
  8011a6:	eb b1                	jmp    801159 <vprintfmt+0xdb>
        switch (ch = *ufmt++) {
  8011a8:	49 89 dc             	mov    %rbx,%r12
  8011ab:	eb ac                	jmp    801159 <vprintfmt+0xdb>
            width = MAX(0, width);
  8011ad:	8b 4d ac             	mov    -0x54(%rbp),%ecx
  8011b0:	85 c9                	test   %ecx,%ecx
  8011b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8011b7:	0f 49 c1             	cmovns %ecx,%eax
  8011ba:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  8011bd:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  8011c0:	e9 32 ff ff ff       	jmp    8010f7 <vprintfmt+0x79>
            lflag++;
  8011c5:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  8011c8:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  8011cb:	e9 27 ff ff ff       	jmp    8010f7 <vprintfmt+0x79>
            putch(va_arg(aq, int), put_arg);
  8011d0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8011d3:	83 f8 2f             	cmp    $0x2f,%eax
  8011d6:	77 19                	ja     8011f1 <vprintfmt+0x173>
  8011d8:	89 c2                	mov    %eax,%edx
  8011da:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8011de:	83 c0 08             	add    $0x8,%eax
  8011e1:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8011e4:	8b 3a                	mov    (%rdx),%edi
  8011e6:	4c 89 ee             	mov    %r13,%rsi
  8011e9:	41 ff d6             	call   *%r14
            break;
  8011ec:	e9 c2 fe ff ff       	jmp    8010b3 <vprintfmt+0x35>
            putch(va_arg(aq, int), put_arg);
  8011f1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8011f5:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8011f9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8011fd:	eb e5                	jmp    8011e4 <vprintfmt+0x166>
            int err = va_arg(aq, int);
  8011ff:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801202:	83 f8 2f             	cmp    $0x2f,%eax
  801205:	77 5a                	ja     801261 <vprintfmt+0x1e3>
  801207:	89 c2                	mov    %eax,%edx
  801209:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80120d:	83 c0 08             	add    $0x8,%eax
  801210:	89 45 b8             	mov    %eax,-0x48(%rbp)
            if (err < 0) err = -err;
  801213:	8b 02                	mov    (%rdx),%eax
  801215:	89 c1                	mov    %eax,%ecx
  801217:	f7 d9                	neg    %ecx
  801219:	0f 48 c8             	cmovs  %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  80121c:	83 f9 13             	cmp    $0x13,%ecx
  80121f:	7f 4e                	jg     80126f <vprintfmt+0x1f1>
  801221:	48 63 c1             	movslq %ecx,%rax
  801224:	48 ba a0 47 80 00 00 	movabs $0x8047a0,%rdx
  80122b:	00 00 00 
  80122e:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  801232:	48 85 c0             	test   %rax,%rax
  801235:	74 38                	je     80126f <vprintfmt+0x1f1>
                printfmt(putch, put_arg, "%s", strerr);
  801237:	48 89 c1             	mov    %rax,%rcx
  80123a:	48 ba cd 42 80 00 00 	movabs $0x8042cd,%rdx
  801241:	00 00 00 
  801244:	4c 89 ee             	mov    %r13,%rsi
  801247:	4c 89 f7             	mov    %r14,%rdi
  80124a:	b8 00 00 00 00       	mov    $0x0,%eax
  80124f:	49 b8 3d 10 80 00 00 	movabs $0x80103d,%r8
  801256:	00 00 00 
  801259:	41 ff d0             	call   *%r8
  80125c:	e9 52 fe ff ff       	jmp    8010b3 <vprintfmt+0x35>
            int err = va_arg(aq, int);
  801261:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801265:	48 8d 42 08          	lea    0x8(%rdx),%rax
  801269:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80126d:	eb a4                	jmp    801213 <vprintfmt+0x195>
                printfmt(putch, put_arg, "error %d", err);
  80126f:	48 ba 07 41 80 00 00 	movabs $0x804107,%rdx
  801276:	00 00 00 
  801279:	4c 89 ee             	mov    %r13,%rsi
  80127c:	4c 89 f7             	mov    %r14,%rdi
  80127f:	b8 00 00 00 00       	mov    $0x0,%eax
  801284:	49 b8 3d 10 80 00 00 	movabs $0x80103d,%r8
  80128b:	00 00 00 
  80128e:	41 ff d0             	call   *%r8
  801291:	e9 1d fe ff ff       	jmp    8010b3 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  801296:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801299:	83 f8 2f             	cmp    $0x2f,%eax
  80129c:	77 6c                	ja     80130a <vprintfmt+0x28c>
  80129e:	89 c2                	mov    %eax,%edx
  8012a0:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8012a4:	83 c0 08             	add    $0x8,%eax
  8012a7:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8012aa:	48 8b 12             	mov    (%rdx),%rdx
            if (!ptr) ptr = "(null)";
  8012ad:	48 85 d2             	test   %rdx,%rdx
  8012b0:	48 b8 00 41 80 00 00 	movabs $0x804100,%rax
  8012b7:	00 00 00 
  8012ba:	48 0f 45 c2          	cmovne %rdx,%rax
  8012be:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
            if (width > 0 && padc != '-') {
  8012c2:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8012c6:	7e 06                	jle    8012ce <vprintfmt+0x250>
  8012c8:	80 7d aa 2d          	cmpb   $0x2d,-0x56(%rbp)
  8012cc:	75 4a                	jne    801318 <vprintfmt+0x29a>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  8012ce:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8012d2:	4c 8d 60 01          	lea    0x1(%rax),%r12
  8012d6:	0f b6 00             	movzbl (%rax),%eax
  8012d9:	84 c0                	test   %al,%al
  8012db:	0f 85 9a 00 00 00    	jne    80137b <vprintfmt+0x2fd>
            while (width-- > 0) putch(' ', put_arg);
  8012e1:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8012e4:	44 8d 60 ff          	lea    -0x1(%rax),%r12d
  8012e8:	85 c0                	test   %eax,%eax
  8012ea:	0f 8e c3 fd ff ff    	jle    8010b3 <vprintfmt+0x35>
  8012f0:	4c 89 ee             	mov    %r13,%rsi
  8012f3:	bf 20 00 00 00       	mov    $0x20,%edi
  8012f8:	41 ff d6             	call   *%r14
  8012fb:	41 83 ec 01          	sub    $0x1,%r12d
  8012ff:	41 83 fc ff          	cmp    $0xffffffff,%r12d
  801303:	75 eb                	jne    8012f0 <vprintfmt+0x272>
  801305:	e9 a9 fd ff ff       	jmp    8010b3 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  80130a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80130e:	48 8d 42 08          	lea    0x8(%rdx),%rax
  801312:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801316:	eb 92                	jmp    8012aa <vprintfmt+0x22c>
                width -= strnlen(ptr, precision);
  801318:	49 63 f7             	movslq %r15d,%rsi
  80131b:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  80131f:	48 b8 41 18 80 00 00 	movabs $0x801841,%rax
  801326:	00 00 00 
  801329:	ff d0                	call   *%rax
  80132b:	48 89 c2             	mov    %rax,%rdx
  80132e:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801331:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  801333:	8d 70 ff             	lea    -0x1(%rax),%esi
  801336:	89 75 ac             	mov    %esi,-0x54(%rbp)
  801339:	85 c0                	test   %eax,%eax
  80133b:	7e 91                	jle    8012ce <vprintfmt+0x250>
  80133d:	44 0f be 65 aa       	movsbl -0x56(%rbp),%r12d
  801342:	4c 89 ee             	mov    %r13,%rsi
  801345:	44 89 e7             	mov    %r12d,%edi
  801348:	41 ff d6             	call   *%r14
  80134b:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  80134f:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801352:	83 f8 ff             	cmp    $0xffffffff,%eax
  801355:	75 eb                	jne    801342 <vprintfmt+0x2c4>
  801357:	e9 72 ff ff ff       	jmp    8012ce <vprintfmt+0x250>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  80135c:	0f b6 f8             	movzbl %al,%edi
  80135f:	4c 89 ee             	mov    %r13,%rsi
  801362:	41 ff d6             	call   *%r14
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  801365:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  801369:	49 83 c4 01          	add    $0x1,%r12
  80136d:	41 0f b6 44 24 ff    	movzbl -0x1(%r12),%eax
  801373:	84 c0                	test   %al,%al
  801375:	0f 84 66 ff ff ff    	je     8012e1 <vprintfmt+0x263>
  80137b:	45 85 ff             	test   %r15d,%r15d
  80137e:	78 0a                	js     80138a <vprintfmt+0x30c>
  801380:	41 83 ef 01          	sub    $0x1,%r15d
  801384:	0f 88 57 ff ff ff    	js     8012e1 <vprintfmt+0x263>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  80138a:	80 7d ab 00          	cmpb   $0x0,-0x55(%rbp)
  80138e:	74 cc                	je     80135c <vprintfmt+0x2de>
  801390:	8d 50 e0             	lea    -0x20(%rax),%edx
  801393:	bf 3f 00 00 00       	mov    $0x3f,%edi
  801398:	80 fa 5e             	cmp    $0x5e,%dl
  80139b:	77 c2                	ja     80135f <vprintfmt+0x2e1>
  80139d:	eb bd                	jmp    80135c <vprintfmt+0x2de>
    if (zflag) return va_arg(*ap, size_t);
  80139f:	40 84 f6             	test   %sil,%sil
  8013a2:	75 26                	jne    8013ca <vprintfmt+0x34c>
    switch (lflag) {
  8013a4:	85 d2                	test   %edx,%edx
  8013a6:	74 59                	je     801401 <vprintfmt+0x383>
  8013a8:	83 fa 01             	cmp    $0x1,%edx
  8013ab:	74 7b                	je     801428 <vprintfmt+0x3aa>
        return va_arg(*ap, long long);
  8013ad:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8013b0:	83 f8 2f             	cmp    $0x2f,%eax
  8013b3:	0f 87 96 00 00 00    	ja     80144f <vprintfmt+0x3d1>
  8013b9:	89 c2                	mov    %eax,%edx
  8013bb:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8013bf:	83 c0 08             	add    $0x8,%eax
  8013c2:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8013c5:	4c 8b 22             	mov    (%rdx),%r12
  8013c8:	eb 17                	jmp    8013e1 <vprintfmt+0x363>
    if (zflag) return va_arg(*ap, size_t);
  8013ca:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8013cd:	83 f8 2f             	cmp    $0x2f,%eax
  8013d0:	77 21                	ja     8013f3 <vprintfmt+0x375>
  8013d2:	89 c2                	mov    %eax,%edx
  8013d4:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8013d8:	83 c0 08             	add    $0x8,%eax
  8013db:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8013de:	4c 8b 22             	mov    (%rdx),%r12
            if (i < 0) {
  8013e1:	4d 85 e4             	test   %r12,%r12
  8013e4:	78 7a                	js     801460 <vprintfmt+0x3e2>
            num = i;
  8013e6:	4c 89 e2             	mov    %r12,%rdx
        unsigned lflag = 0, base = 10;
  8013e9:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  8013ee:	e9 50 02 00 00       	jmp    801643 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8013f3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8013f7:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8013fb:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8013ff:	eb dd                	jmp    8013de <vprintfmt+0x360>
        return va_arg(*ap, int);
  801401:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801404:	83 f8 2f             	cmp    $0x2f,%eax
  801407:	77 11                	ja     80141a <vprintfmt+0x39c>
  801409:	89 c2                	mov    %eax,%edx
  80140b:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80140f:	83 c0 08             	add    $0x8,%eax
  801412:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801415:	4c 63 22             	movslq (%rdx),%r12
  801418:	eb c7                	jmp    8013e1 <vprintfmt+0x363>
  80141a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80141e:	48 8d 42 08          	lea    0x8(%rdx),%rax
  801422:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801426:	eb ed                	jmp    801415 <vprintfmt+0x397>
        return va_arg(*ap, long);
  801428:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80142b:	83 f8 2f             	cmp    $0x2f,%eax
  80142e:	77 11                	ja     801441 <vprintfmt+0x3c3>
  801430:	89 c2                	mov    %eax,%edx
  801432:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  801436:	83 c0 08             	add    $0x8,%eax
  801439:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80143c:	4c 8b 22             	mov    (%rdx),%r12
  80143f:	eb a0                	jmp    8013e1 <vprintfmt+0x363>
  801441:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801445:	48 8d 42 08          	lea    0x8(%rdx),%rax
  801449:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80144d:	eb ed                	jmp    80143c <vprintfmt+0x3be>
        return va_arg(*ap, long long);
  80144f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801453:	48 8d 42 08          	lea    0x8(%rdx),%rax
  801457:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80145b:	e9 65 ff ff ff       	jmp    8013c5 <vprintfmt+0x347>
                putch('-', put_arg);
  801460:	4c 89 ee             	mov    %r13,%rsi
  801463:	bf 2d 00 00 00       	mov    $0x2d,%edi
  801468:	41 ff d6             	call   *%r14
                i = -i;
  80146b:	49 f7 dc             	neg    %r12
  80146e:	e9 73 ff ff ff       	jmp    8013e6 <vprintfmt+0x368>
    if (zflag) return va_arg(*ap, size_t);
  801473:	40 84 f6             	test   %sil,%sil
  801476:	75 32                	jne    8014aa <vprintfmt+0x42c>
    switch (lflag) {
  801478:	85 d2                	test   %edx,%edx
  80147a:	74 5d                	je     8014d9 <vprintfmt+0x45b>
  80147c:	83 fa 01             	cmp    $0x1,%edx
  80147f:	0f 84 82 00 00 00    	je     801507 <vprintfmt+0x489>
        return va_arg(*ap, unsigned long long);
  801485:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801488:	83 f8 2f             	cmp    $0x2f,%eax
  80148b:	0f 87 a5 00 00 00    	ja     801536 <vprintfmt+0x4b8>
  801491:	89 c2                	mov    %eax,%edx
  801493:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  801497:	83 c0 08             	add    $0x8,%eax
  80149a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80149d:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  8014a0:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  8014a5:	e9 99 01 00 00       	jmp    801643 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8014aa:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8014ad:	83 f8 2f             	cmp    $0x2f,%eax
  8014b0:	77 19                	ja     8014cb <vprintfmt+0x44d>
  8014b2:	89 c2                	mov    %eax,%edx
  8014b4:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8014b8:	83 c0 08             	add    $0x8,%eax
  8014bb:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8014be:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  8014c1:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8014c6:	e9 78 01 00 00       	jmp    801643 <vprintfmt+0x5c5>
  8014cb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8014cf:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8014d3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8014d7:	eb e5                	jmp    8014be <vprintfmt+0x440>
        return va_arg(*ap, unsigned int);
  8014d9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8014dc:	83 f8 2f             	cmp    $0x2f,%eax
  8014df:	77 18                	ja     8014f9 <vprintfmt+0x47b>
  8014e1:	89 c2                	mov    %eax,%edx
  8014e3:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8014e7:	83 c0 08             	add    $0x8,%eax
  8014ea:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8014ed:	8b 12                	mov    (%rdx),%edx
        unsigned lflag = 0, base = 10;
  8014ef:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  8014f4:	e9 4a 01 00 00       	jmp    801643 <vprintfmt+0x5c5>
  8014f9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8014fd:	48 8d 42 08          	lea    0x8(%rdx),%rax
  801501:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801505:	eb e6                	jmp    8014ed <vprintfmt+0x46f>
        return va_arg(*ap, unsigned long);
  801507:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80150a:	83 f8 2f             	cmp    $0x2f,%eax
  80150d:	77 19                	ja     801528 <vprintfmt+0x4aa>
  80150f:	89 c2                	mov    %eax,%edx
  801511:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  801515:	83 c0 08             	add    $0x8,%eax
  801518:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80151b:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  80151e:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  801523:	e9 1b 01 00 00       	jmp    801643 <vprintfmt+0x5c5>
  801528:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80152c:	48 8d 42 08          	lea    0x8(%rdx),%rax
  801530:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801534:	eb e5                	jmp    80151b <vprintfmt+0x49d>
        return va_arg(*ap, unsigned long long);
  801536:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80153a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80153e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801542:	e9 56 ff ff ff       	jmp    80149d <vprintfmt+0x41f>
    if (zflag) return va_arg(*ap, size_t);
  801547:	40 84 f6             	test   %sil,%sil
  80154a:	75 2e                	jne    80157a <vprintfmt+0x4fc>
    switch (lflag) {
  80154c:	85 d2                	test   %edx,%edx
  80154e:	74 59                	je     8015a9 <vprintfmt+0x52b>
  801550:	83 fa 01             	cmp    $0x1,%edx
  801553:	74 7f                	je     8015d4 <vprintfmt+0x556>
        return va_arg(*ap, unsigned long long);
  801555:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801558:	83 f8 2f             	cmp    $0x2f,%eax
  80155b:	0f 87 9f 00 00 00    	ja     801600 <vprintfmt+0x582>
  801561:	89 c2                	mov    %eax,%edx
  801563:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  801567:	83 c0 08             	add    $0x8,%eax
  80156a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80156d:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  801570:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  801575:	e9 c9 00 00 00       	jmp    801643 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  80157a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80157d:	83 f8 2f             	cmp    $0x2f,%eax
  801580:	77 19                	ja     80159b <vprintfmt+0x51d>
  801582:	89 c2                	mov    %eax,%edx
  801584:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  801588:	83 c0 08             	add    $0x8,%eax
  80158b:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80158e:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  801591:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  801596:	e9 a8 00 00 00       	jmp    801643 <vprintfmt+0x5c5>
  80159b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80159f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8015a3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8015a7:	eb e5                	jmp    80158e <vprintfmt+0x510>
        return va_arg(*ap, unsigned int);
  8015a9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8015ac:	83 f8 2f             	cmp    $0x2f,%eax
  8015af:	77 15                	ja     8015c6 <vprintfmt+0x548>
  8015b1:	89 c2                	mov    %eax,%edx
  8015b3:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8015b7:	83 c0 08             	add    $0x8,%eax
  8015ba:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8015bd:	8b 12                	mov    (%rdx),%edx
            base = 8;
  8015bf:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  8015c4:	eb 7d                	jmp    801643 <vprintfmt+0x5c5>
  8015c6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8015ca:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8015ce:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8015d2:	eb e9                	jmp    8015bd <vprintfmt+0x53f>
        return va_arg(*ap, unsigned long);
  8015d4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8015d7:	83 f8 2f             	cmp    $0x2f,%eax
  8015da:	77 16                	ja     8015f2 <vprintfmt+0x574>
  8015dc:	89 c2                	mov    %eax,%edx
  8015de:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8015e2:	83 c0 08             	add    $0x8,%eax
  8015e5:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8015e8:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  8015eb:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  8015f0:	eb 51                	jmp    801643 <vprintfmt+0x5c5>
  8015f2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8015f6:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8015fa:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8015fe:	eb e8                	jmp    8015e8 <vprintfmt+0x56a>
        return va_arg(*ap, unsigned long long);
  801600:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801604:	48 8d 42 08          	lea    0x8(%rdx),%rax
  801608:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80160c:	e9 5c ff ff ff       	jmp    80156d <vprintfmt+0x4ef>
            putch('0', put_arg);
  801611:	4c 89 ee             	mov    %r13,%rsi
  801614:	bf 30 00 00 00       	mov    $0x30,%edi
  801619:	41 ff d6             	call   *%r14
            putch('x', put_arg);
  80161c:	4c 89 ee             	mov    %r13,%rsi
  80161f:	bf 78 00 00 00       	mov    $0x78,%edi
  801624:	41 ff d6             	call   *%r14
            num = (uintptr_t)va_arg(aq, void *);
  801627:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80162a:	83 f8 2f             	cmp    $0x2f,%eax
  80162d:	77 47                	ja     801676 <vprintfmt+0x5f8>
  80162f:	89 c2                	mov    %eax,%edx
  801631:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  801635:	83 c0 08             	add    $0x8,%eax
  801638:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80163b:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  80163e:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  801643:	48 83 ec 08          	sub    $0x8,%rsp
  801647:	80 7d a0 58          	cmpb   $0x58,-0x60(%rbp)
  80164b:	0f 94 c0             	sete   %al
  80164e:	0f b6 c0             	movzbl %al,%eax
  801651:	50                   	push   %rax
  801652:	44 0f be 4d aa       	movsbl -0x56(%rbp),%r9d
  801657:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  80165b:	4c 89 ee             	mov    %r13,%rsi
  80165e:	4c 89 f7             	mov    %r14,%rdi
  801661:	48 b8 67 0f 80 00 00 	movabs $0x800f67,%rax
  801668:	00 00 00 
  80166b:	ff d0                	call   *%rax
            break;
  80166d:	48 83 c4 10          	add    $0x10,%rsp
  801671:	e9 3d fa ff ff       	jmp    8010b3 <vprintfmt+0x35>
            num = (uintptr_t)va_arg(aq, void *);
  801676:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80167a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80167e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801682:	eb b7                	jmp    80163b <vprintfmt+0x5bd>
    if (zflag) return va_arg(*ap, size_t);
  801684:	40 84 f6             	test   %sil,%sil
  801687:	75 2b                	jne    8016b4 <vprintfmt+0x636>
    switch (lflag) {
  801689:	85 d2                	test   %edx,%edx
  80168b:	74 56                	je     8016e3 <vprintfmt+0x665>
  80168d:	83 fa 01             	cmp    $0x1,%edx
  801690:	74 7f                	je     801711 <vprintfmt+0x693>
        return va_arg(*ap, unsigned long long);
  801692:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801695:	83 f8 2f             	cmp    $0x2f,%eax
  801698:	0f 87 a2 00 00 00    	ja     801740 <vprintfmt+0x6c2>
  80169e:	89 c2                	mov    %eax,%edx
  8016a0:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8016a4:	83 c0 08             	add    $0x8,%eax
  8016a7:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8016aa:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  8016ad:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  8016b2:	eb 8f                	jmp    801643 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8016b4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8016b7:	83 f8 2f             	cmp    $0x2f,%eax
  8016ba:	77 19                	ja     8016d5 <vprintfmt+0x657>
  8016bc:	89 c2                	mov    %eax,%edx
  8016be:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8016c2:	83 c0 08             	add    $0x8,%eax
  8016c5:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8016c8:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  8016cb:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8016d0:	e9 6e ff ff ff       	jmp    801643 <vprintfmt+0x5c5>
  8016d5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8016d9:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8016dd:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8016e1:	eb e5                	jmp    8016c8 <vprintfmt+0x64a>
        return va_arg(*ap, unsigned int);
  8016e3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8016e6:	83 f8 2f             	cmp    $0x2f,%eax
  8016e9:	77 18                	ja     801703 <vprintfmt+0x685>
  8016eb:	89 c2                	mov    %eax,%edx
  8016ed:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8016f1:	83 c0 08             	add    $0x8,%eax
  8016f4:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8016f7:	8b 12                	mov    (%rdx),%edx
            base = 16;
  8016f9:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  8016fe:	e9 40 ff ff ff       	jmp    801643 <vprintfmt+0x5c5>
  801703:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801707:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80170b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80170f:	eb e6                	jmp    8016f7 <vprintfmt+0x679>
        return va_arg(*ap, unsigned long);
  801711:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801714:	83 f8 2f             	cmp    $0x2f,%eax
  801717:	77 19                	ja     801732 <vprintfmt+0x6b4>
  801719:	89 c2                	mov    %eax,%edx
  80171b:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80171f:	83 c0 08             	add    $0x8,%eax
  801722:	89 45 b8             	mov    %eax,-0x48(%rbp)
  801725:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  801728:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  80172d:	e9 11 ff ff ff       	jmp    801643 <vprintfmt+0x5c5>
  801732:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801736:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80173a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80173e:	eb e5                	jmp    801725 <vprintfmt+0x6a7>
        return va_arg(*ap, unsigned long long);
  801740:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801744:	48 8d 42 08          	lea    0x8(%rdx),%rax
  801748:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80174c:	e9 59 ff ff ff       	jmp    8016aa <vprintfmt+0x62c>
            putch(ch, put_arg);
  801751:	4c 89 ee             	mov    %r13,%rsi
  801754:	bf 25 00 00 00       	mov    $0x25,%edi
  801759:	41 ff d6             	call   *%r14
            break;
  80175c:	e9 52 f9 ff ff       	jmp    8010b3 <vprintfmt+0x35>
            putch('%', put_arg);
  801761:	4c 89 ee             	mov    %r13,%rsi
  801764:	bf 25 00 00 00       	mov    $0x25,%edi
  801769:	41 ff d6             	call   *%r14
            while ((--ufmt)[-1] != '%') /* nothing */
  80176c:	48 83 eb 01          	sub    $0x1,%rbx
  801770:	80 7b ff 25          	cmpb   $0x25,-0x1(%rbx)
  801774:	75 f6                	jne    80176c <vprintfmt+0x6ee>
  801776:	e9 38 f9 ff ff       	jmp    8010b3 <vprintfmt+0x35>
}
  80177b:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  80177f:	5b                   	pop    %rbx
  801780:	41 5c                	pop    %r12
  801782:	41 5d                	pop    %r13
  801784:	41 5e                	pop    %r14
  801786:	41 5f                	pop    %r15
  801788:	5d                   	pop    %rbp
  801789:	c3                   	ret

000000000080178a <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  80178a:	f3 0f 1e fa          	endbr64
  80178e:	55                   	push   %rbp
  80178f:	48 89 e5             	mov    %rsp,%rbp
  801792:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  801796:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80179a:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  80179f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  8017a3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  8017aa:	48 85 ff             	test   %rdi,%rdi
  8017ad:	74 2b                	je     8017da <vsnprintf+0x50>
  8017af:	48 85 f6             	test   %rsi,%rsi
  8017b2:	74 26                	je     8017da <vsnprintf+0x50>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  8017b4:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  8017b8:	48 bf 21 10 80 00 00 	movabs $0x801021,%rdi
  8017bf:	00 00 00 
  8017c2:	48 b8 7e 10 80 00 00 	movabs $0x80107e,%rax
  8017c9:	00 00 00 
  8017cc:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  8017ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017d2:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  8017d5:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8017d8:	c9                   	leave
  8017d9:	c3                   	ret
    if (!buf || n < 1) return -E_INVAL;
  8017da:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017df:	eb f7                	jmp    8017d8 <vsnprintf+0x4e>

00000000008017e1 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  8017e1:	f3 0f 1e fa          	endbr64
  8017e5:	55                   	push   %rbp
  8017e6:	48 89 e5             	mov    %rsp,%rbp
  8017e9:	48 83 ec 50          	sub    $0x50,%rsp
  8017ed:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8017f1:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8017f5:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  8017f9:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  801800:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801804:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  801808:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80180c:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  801810:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  801814:	48 b8 8a 17 80 00 00 	movabs $0x80178a,%rax
  80181b:	00 00 00 
  80181e:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  801820:	c9                   	leave
  801821:	c3                   	ret

0000000000801822 <strlen>:
 * Primespipe runs 3x faster this way */

#define ASM 1

size_t
strlen(const char *s) {
  801822:	f3 0f 1e fa          	endbr64
    size_t n = 0;
    while (*s++) n++;
  801826:	80 3f 00             	cmpb   $0x0,(%rdi)
  801829:	74 10                	je     80183b <strlen+0x19>
    size_t n = 0;
  80182b:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  801830:	48 83 c0 01          	add    $0x1,%rax
  801834:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  801838:	75 f6                	jne    801830 <strlen+0xe>
  80183a:	c3                   	ret
    size_t n = 0;
  80183b:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  801840:	c3                   	ret

0000000000801841 <strnlen>:

size_t
strnlen(const char *s, size_t size) {
  801841:	f3 0f 1e fa          	endbr64
  801845:	48 89 f0             	mov    %rsi,%rax
    size_t n = 0;
  801848:	ba 00 00 00 00       	mov    $0x0,%edx
    while (n < size && *s++) n++;
  80184d:	48 85 f6             	test   %rsi,%rsi
  801850:	74 10                	je     801862 <strnlen+0x21>
  801852:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  801856:	74 0b                	je     801863 <strnlen+0x22>
  801858:	48 83 c2 01          	add    $0x1,%rdx
  80185c:	48 39 d0             	cmp    %rdx,%rax
  80185f:	75 f1                	jne    801852 <strnlen+0x11>
  801861:	c3                   	ret
  801862:	c3                   	ret
  801863:	48 89 d0             	mov    %rdx,%rax
    return n;
}
  801866:	c3                   	ret

0000000000801867 <strcpy>:

char *
strcpy(char *dst, const char *src) {
  801867:	f3 0f 1e fa          	endbr64
  80186b:	48 89 f8             	mov    %rdi,%rax
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  80186e:	ba 00 00 00 00       	mov    $0x0,%edx
  801873:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  801877:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  80187a:	48 83 c2 01          	add    $0x1,%rdx
  80187e:	84 c9                	test   %cl,%cl
  801880:	75 f1                	jne    801873 <strcpy+0xc>
        ;
    return res;
}
  801882:	c3                   	ret

0000000000801883 <strcat>:

char *
strcat(char *dst, const char *src) {
  801883:	f3 0f 1e fa          	endbr64
  801887:	55                   	push   %rbp
  801888:	48 89 e5             	mov    %rsp,%rbp
  80188b:	41 54                	push   %r12
  80188d:	53                   	push   %rbx
  80188e:	48 89 fb             	mov    %rdi,%rbx
  801891:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  801894:	48 b8 22 18 80 00 00 	movabs $0x801822,%rax
  80189b:	00 00 00 
  80189e:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  8018a0:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  8018a4:	4c 89 e6             	mov    %r12,%rsi
  8018a7:	48 b8 67 18 80 00 00 	movabs $0x801867,%rax
  8018ae:	00 00 00 
  8018b1:	ff d0                	call   *%rax
    return dst;
}
  8018b3:	48 89 d8             	mov    %rbx,%rax
  8018b6:	5b                   	pop    %rbx
  8018b7:	41 5c                	pop    %r12
  8018b9:	5d                   	pop    %rbp
  8018ba:	c3                   	ret

00000000008018bb <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8018bb:	f3 0f 1e fa          	endbr64
  8018bf:	48 89 f8             	mov    %rdi,%rax
    char *ret = dst;
    while (size-- > 0) {
  8018c2:	48 85 d2             	test   %rdx,%rdx
  8018c5:	74 1f                	je     8018e6 <strncpy+0x2b>
  8018c7:	48 01 fa             	add    %rdi,%rdx
  8018ca:	48 89 f9             	mov    %rdi,%rcx
        *dst++ = *src;
  8018cd:	48 83 c1 01          	add    $0x1,%rcx
  8018d1:	44 0f b6 06          	movzbl (%rsi),%r8d
  8018d5:	44 88 41 ff          	mov    %r8b,-0x1(%rcx)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  8018d9:	41 80 f8 01          	cmp    $0x1,%r8b
  8018dd:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  8018e1:	48 39 ca             	cmp    %rcx,%rdx
  8018e4:	75 e7                	jne    8018cd <strncpy+0x12>
    }
    return ret;
}
  8018e6:	c3                   	ret

00000000008018e7 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
  8018e7:	f3 0f 1e fa          	endbr64
    char *dst_in = dst;
    if (size) {
  8018eb:	48 89 f8             	mov    %rdi,%rax
  8018ee:	48 85 d2             	test   %rdx,%rdx
  8018f1:	74 24                	je     801917 <strlcpy+0x30>
        while (--size > 0 && *src)
  8018f3:	48 83 ea 01          	sub    $0x1,%rdx
  8018f7:	74 1b                	je     801914 <strlcpy+0x2d>
  8018f9:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  8018fd:	0f b6 16             	movzbl (%rsi),%edx
  801900:	84 d2                	test   %dl,%dl
  801902:	74 10                	je     801914 <strlcpy+0x2d>
            *dst++ = *src++;
  801904:	48 83 c6 01          	add    $0x1,%rsi
  801908:	48 83 c0 01          	add    $0x1,%rax
  80190c:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  80190f:	48 39 c8             	cmp    %rcx,%rax
  801912:	75 e9                	jne    8018fd <strlcpy+0x16>
        *dst = '\0';
  801914:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  801917:	48 29 f8             	sub    %rdi,%rax
}
  80191a:	c3                   	ret

000000000080191b <strcmp>:
    }
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
  80191b:	f3 0f 1e fa          	endbr64
    while (*p && *p == *q) p++, q++;
  80191f:	0f b6 07             	movzbl (%rdi),%eax
  801922:	84 c0                	test   %al,%al
  801924:	74 13                	je     801939 <strcmp+0x1e>
  801926:	38 06                	cmp    %al,(%rsi)
  801928:	75 0f                	jne    801939 <strcmp+0x1e>
  80192a:	48 83 c7 01          	add    $0x1,%rdi
  80192e:	48 83 c6 01          	add    $0x1,%rsi
  801932:	0f b6 07             	movzbl (%rdi),%eax
  801935:	84 c0                	test   %al,%al
  801937:	75 ed                	jne    801926 <strcmp+0xb>
    return (int)((unsigned char)*p - (unsigned char)*q);
  801939:	0f b6 c0             	movzbl %al,%eax
  80193c:	0f b6 16             	movzbl (%rsi),%edx
  80193f:	29 d0                	sub    %edx,%eax
}
  801941:	c3                   	ret

0000000000801942 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
  801942:	f3 0f 1e fa          	endbr64
    while (n && *p && *p == *q) n--, p++, q++;
  801946:	48 85 d2             	test   %rdx,%rdx
  801949:	74 1f                	je     80196a <strncmp+0x28>
  80194b:	0f b6 07             	movzbl (%rdi),%eax
  80194e:	84 c0                	test   %al,%al
  801950:	74 1e                	je     801970 <strncmp+0x2e>
  801952:	3a 06                	cmp    (%rsi),%al
  801954:	75 1a                	jne    801970 <strncmp+0x2e>
  801956:	48 83 c7 01          	add    $0x1,%rdi
  80195a:	48 83 c6 01          	add    $0x1,%rsi
  80195e:	48 83 ea 01          	sub    $0x1,%rdx
  801962:	75 e7                	jne    80194b <strncmp+0x9>

    if (!n) return 0;
  801964:	b8 00 00 00 00       	mov    $0x0,%eax
  801969:	c3                   	ret
  80196a:	b8 00 00 00 00       	mov    $0x0,%eax
  80196f:	c3                   	ret

    return (int)((unsigned char)*p - (unsigned char)*q);
  801970:	0f b6 07             	movzbl (%rdi),%eax
  801973:	0f b6 16             	movzbl (%rsi),%edx
  801976:	29 d0                	sub    %edx,%eax
}
  801978:	c3                   	ret

0000000000801979 <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
  801979:	f3 0f 1e fa          	endbr64
    for (; *str; str++) {
  80197d:	0f b6 17             	movzbl (%rdi),%edx
  801980:	84 d2                	test   %dl,%dl
  801982:	74 18                	je     80199c <strchr+0x23>
        if (*str == c) {
  801984:	0f be d2             	movsbl %dl,%edx
  801987:	39 f2                	cmp    %esi,%edx
  801989:	74 17                	je     8019a2 <strchr+0x29>
    for (; *str; str++) {
  80198b:	48 83 c7 01          	add    $0x1,%rdi
  80198f:	0f b6 17             	movzbl (%rdi),%edx
  801992:	84 d2                	test   %dl,%dl
  801994:	75 ee                	jne    801984 <strchr+0xb>
            return (char *)str;
        }
    }
    return NULL;
  801996:	b8 00 00 00 00       	mov    $0x0,%eax
  80199b:	c3                   	ret
  80199c:	b8 00 00 00 00       	mov    $0x0,%eax
  8019a1:	c3                   	ret
            return (char *)str;
  8019a2:	48 89 f8             	mov    %rdi,%rax
}
  8019a5:	c3                   	ret

00000000008019a6 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
  8019a6:	f3 0f 1e fa          	endbr64
  8019aa:	48 89 f8             	mov    %rdi,%rax
    for (; *str && *str != ch; str++) /* nothing */
  8019ad:	0f b6 17             	movzbl (%rdi),%edx
  8019b0:	84 d2                	test   %dl,%dl
  8019b2:	74 13                	je     8019c7 <strfind+0x21>
  8019b4:	0f be d2             	movsbl %dl,%edx
  8019b7:	39 f2                	cmp    %esi,%edx
  8019b9:	74 0b                	je     8019c6 <strfind+0x20>
  8019bb:	48 83 c0 01          	add    $0x1,%rax
  8019bf:	0f b6 10             	movzbl (%rax),%edx
  8019c2:	84 d2                	test   %dl,%dl
  8019c4:	75 ee                	jne    8019b4 <strfind+0xe>
        ;
    return (char *)str;
}
  8019c6:	c3                   	ret
  8019c7:	c3                   	ret

00000000008019c8 <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  8019c8:	f3 0f 1e fa          	endbr64
  8019cc:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  8019cf:	48 89 f8             	mov    %rdi,%rax
  8019d2:	48 f7 d8             	neg    %rax
  8019d5:	83 e0 07             	and    $0x7,%eax
  8019d8:	49 89 d1             	mov    %rdx,%r9
  8019db:	49 29 c1             	sub    %rax,%r9
  8019de:	78 36                	js     801a16 <memset+0x4e>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  8019e0:	40 0f b6 c6          	movzbl %sil,%eax
  8019e4:	48 b9 01 01 01 01 01 	movabs $0x101010101010101,%rcx
  8019eb:	01 01 01 
  8019ee:	48 0f af c1          	imul   %rcx,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  8019f2:	40 f6 c7 07          	test   $0x7,%dil
  8019f6:	75 38                	jne    801a30 <memset+0x68>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  8019f8:	4c 89 c9             	mov    %r9,%rcx
  8019fb:	48 c1 f9 03          	sar    $0x3,%rcx
  8019ff:	74 0c                	je     801a0d <memset+0x45>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  801a01:	fc                   	cld
  801a02:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  801a05:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  801a09:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  801a0d:	4d 85 c9             	test   %r9,%r9
  801a10:	75 45                	jne    801a57 <memset+0x8f>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  801a12:	4c 89 c0             	mov    %r8,%rax
  801a15:	c3                   	ret
        while (n-- > 0) *ptr++ = c;
  801a16:	48 85 d2             	test   %rdx,%rdx
  801a19:	74 f7                	je     801a12 <memset+0x4a>
  801a1b:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  801a1e:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  801a21:	48 83 c0 01          	add    $0x1,%rax
  801a25:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  801a29:	48 39 c2             	cmp    %rax,%rdx
  801a2c:	75 f3                	jne    801a21 <memset+0x59>
  801a2e:	eb e2                	jmp    801a12 <memset+0x4a>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  801a30:	40 f6 c7 01          	test   $0x1,%dil
  801a34:	74 06                	je     801a3c <memset+0x74>
  801a36:	88 07                	mov    %al,(%rdi)
  801a38:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  801a3c:	40 f6 c7 02          	test   $0x2,%dil
  801a40:	74 07                	je     801a49 <memset+0x81>
  801a42:	66 89 07             	mov    %ax,(%rdi)
  801a45:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  801a49:	40 f6 c7 04          	test   $0x4,%dil
  801a4d:	74 a9                	je     8019f8 <memset+0x30>
  801a4f:	89 07                	mov    %eax,(%rdi)
  801a51:	48 83 c7 04          	add    $0x4,%rdi
  801a55:	eb a1                	jmp    8019f8 <memset+0x30>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  801a57:	41 f6 c1 04          	test   $0x4,%r9b
  801a5b:	74 1b                	je     801a78 <memset+0xb0>
  801a5d:	89 07                	mov    %eax,(%rdi)
  801a5f:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  801a63:	41 f6 c1 02          	test   $0x2,%r9b
  801a67:	74 07                	je     801a70 <memset+0xa8>
  801a69:	66 89 07             	mov    %ax,(%rdi)
  801a6c:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  801a70:	41 f6 c1 01          	test   $0x1,%r9b
  801a74:	74 9c                	je     801a12 <memset+0x4a>
  801a76:	eb 06                	jmp    801a7e <memset+0xb6>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  801a78:	41 f6 c1 02          	test   $0x2,%r9b
  801a7c:	75 eb                	jne    801a69 <memset+0xa1>
        if (ni & 1) *ptr = k;
  801a7e:	88 07                	mov    %al,(%rdi)
  801a80:	eb 90                	jmp    801a12 <memset+0x4a>

0000000000801a82 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  801a82:	f3 0f 1e fa          	endbr64
  801a86:	48 89 f8             	mov    %rdi,%rax
  801a89:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  801a8c:	48 39 fe             	cmp    %rdi,%rsi
  801a8f:	73 3b                	jae    801acc <memmove+0x4a>
  801a91:	48 8d 14 16          	lea    (%rsi,%rdx,1),%rdx
  801a95:	48 39 d7             	cmp    %rdx,%rdi
  801a98:	73 32                	jae    801acc <memmove+0x4a>
        s += n;
        d += n;
  801a9a:	48 8d 3c 0f          	lea    (%rdi,%rcx,1),%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  801a9e:	48 89 d6             	mov    %rdx,%rsi
  801aa1:	48 09 fe             	or     %rdi,%rsi
  801aa4:	48 09 ce             	or     %rcx,%rsi
  801aa7:	40 f6 c6 07          	test   $0x7,%sil
  801aab:	75 12                	jne    801abf <memmove+0x3d>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  801aad:	48 83 ef 08          	sub    $0x8,%rdi
  801ab1:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  801ab5:	48 c1 e9 03          	shr    $0x3,%rcx
  801ab9:	fd                   	std
  801aba:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  801abd:	fc                   	cld
  801abe:	c3                   	ret
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  801abf:	48 83 ef 01          	sub    $0x1,%rdi
  801ac3:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  801ac7:	fd                   	std
  801ac8:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  801aca:	eb f1                	jmp    801abd <memmove+0x3b>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  801acc:	48 89 f2             	mov    %rsi,%rdx
  801acf:	48 09 c2             	or     %rax,%rdx
  801ad2:	48 09 ca             	or     %rcx,%rdx
  801ad5:	f6 c2 07             	test   $0x7,%dl
  801ad8:	75 0c                	jne    801ae6 <memmove+0x64>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  801ada:	48 c1 e9 03          	shr    $0x3,%rcx
  801ade:	48 89 c7             	mov    %rax,%rdi
  801ae1:	fc                   	cld
  801ae2:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  801ae5:	c3                   	ret
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  801ae6:	48 89 c7             	mov    %rax,%rdi
  801ae9:	fc                   	cld
  801aea:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  801aec:	c3                   	ret

0000000000801aed <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  801aed:	f3 0f 1e fa          	endbr64
  801af1:	55                   	push   %rbp
  801af2:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  801af5:	48 b8 82 1a 80 00 00 	movabs $0x801a82,%rax
  801afc:	00 00 00 
  801aff:	ff d0                	call   *%rax
}
  801b01:	5d                   	pop    %rbp
  801b02:	c3                   	ret

0000000000801b03 <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  801b03:	f3 0f 1e fa          	endbr64
  801b07:	55                   	push   %rbp
  801b08:	48 89 e5             	mov    %rsp,%rbp
  801b0b:	41 57                	push   %r15
  801b0d:	41 56                	push   %r14
  801b0f:	41 55                	push   %r13
  801b11:	41 54                	push   %r12
  801b13:	53                   	push   %rbx
  801b14:	48 83 ec 08          	sub    $0x8,%rsp
  801b18:	49 89 fe             	mov    %rdi,%r14
  801b1b:	49 89 f7             	mov    %rsi,%r15
  801b1e:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  801b21:	48 89 f7             	mov    %rsi,%rdi
  801b24:	48 b8 22 18 80 00 00 	movabs $0x801822,%rax
  801b2b:	00 00 00 
  801b2e:	ff d0                	call   *%rax
  801b30:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  801b33:	48 89 de             	mov    %rbx,%rsi
  801b36:	4c 89 f7             	mov    %r14,%rdi
  801b39:	48 b8 41 18 80 00 00 	movabs $0x801841,%rax
  801b40:	00 00 00 
  801b43:	ff d0                	call   *%rax
  801b45:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  801b48:	48 39 c3             	cmp    %rax,%rbx
  801b4b:	74 36                	je     801b83 <strlcat+0x80>
    if (srclen < maxlen - dstlen) {
  801b4d:	48 89 d8             	mov    %rbx,%rax
  801b50:	4c 29 e8             	sub    %r13,%rax
  801b53:	49 39 c4             	cmp    %rax,%r12
  801b56:	73 31                	jae    801b89 <strlcat+0x86>
        memcpy(dst + dstlen, src, srclen + 1);
  801b58:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  801b5d:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  801b61:	4c 89 fe             	mov    %r15,%rsi
  801b64:	48 b8 ed 1a 80 00 00 	movabs $0x801aed,%rax
  801b6b:	00 00 00 
  801b6e:	ff d0                	call   *%rax
    return dstlen + srclen;
  801b70:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  801b74:	48 83 c4 08          	add    $0x8,%rsp
  801b78:	5b                   	pop    %rbx
  801b79:	41 5c                	pop    %r12
  801b7b:	41 5d                	pop    %r13
  801b7d:	41 5e                	pop    %r14
  801b7f:	41 5f                	pop    %r15
  801b81:	5d                   	pop    %rbp
  801b82:	c3                   	ret
    if (dstlen == maxlen) return maxlen + srclen;
  801b83:	49 8d 04 04          	lea    (%r12,%rax,1),%rax
  801b87:	eb eb                	jmp    801b74 <strlcat+0x71>
        memcpy(dst + dstlen, src, maxlen - 1);
  801b89:	48 83 eb 01          	sub    $0x1,%rbx
  801b8d:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  801b91:	48 89 da             	mov    %rbx,%rdx
  801b94:	4c 89 fe             	mov    %r15,%rsi
  801b97:	48 b8 ed 1a 80 00 00 	movabs $0x801aed,%rax
  801b9e:	00 00 00 
  801ba1:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  801ba3:	49 01 de             	add    %rbx,%r14
  801ba6:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  801bab:	eb c3                	jmp    801b70 <strlcat+0x6d>

0000000000801bad <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  801bad:	f3 0f 1e fa          	endbr64
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  801bb1:	48 85 d2             	test   %rdx,%rdx
  801bb4:	74 2d                	je     801be3 <memcmp+0x36>
  801bb6:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  801bbb:	0f b6 0c 07          	movzbl (%rdi,%rax,1),%ecx
  801bbf:	44 0f b6 04 06       	movzbl (%rsi,%rax,1),%r8d
  801bc4:	44 38 c1             	cmp    %r8b,%cl
  801bc7:	75 0f                	jne    801bd8 <memcmp+0x2b>
    while (n-- > 0) {
  801bc9:	48 83 c0 01          	add    $0x1,%rax
  801bcd:	48 39 c2             	cmp    %rax,%rdx
  801bd0:	75 e9                	jne    801bbb <memcmp+0xe>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  801bd2:	b8 00 00 00 00       	mov    $0x0,%eax
  801bd7:	c3                   	ret
            return (int)*s1 - (int)*s2;
  801bd8:	0f b6 c1             	movzbl %cl,%eax
  801bdb:	45 0f b6 c0          	movzbl %r8b,%r8d
  801bdf:	44 29 c0             	sub    %r8d,%eax
  801be2:	c3                   	ret
    return 0;
  801be3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801be8:	c3                   	ret

0000000000801be9 <memfind>:

void *
memfind(const void *src, int c, size_t n) {
  801be9:	f3 0f 1e fa          	endbr64
    const void *end = (const char *)src + n;
  801bed:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  801bf1:	48 39 c7             	cmp    %rax,%rdi
  801bf4:	73 0f                	jae    801c05 <memfind+0x1c>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  801bf6:	40 38 37             	cmp    %sil,(%rdi)
  801bf9:	74 0e                	je     801c09 <memfind+0x20>
    for (; src < end; src++) {
  801bfb:	48 83 c7 01          	add    $0x1,%rdi
  801bff:	48 39 f8             	cmp    %rdi,%rax
  801c02:	75 f2                	jne    801bf6 <memfind+0xd>
  801c04:	c3                   	ret
  801c05:	48 89 f8             	mov    %rdi,%rax
  801c08:	c3                   	ret
  801c09:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  801c0c:	c3                   	ret

0000000000801c0d <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  801c0d:	f3 0f 1e fa          	endbr64
  801c11:	49 89 f2             	mov    %rsi,%r10
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  801c14:	0f b6 37             	movzbl (%rdi),%esi
  801c17:	40 80 fe 20          	cmp    $0x20,%sil
  801c1b:	74 06                	je     801c23 <strtol+0x16>
  801c1d:	40 80 fe 09          	cmp    $0x9,%sil
  801c21:	75 13                	jne    801c36 <strtol+0x29>
  801c23:	48 83 c7 01          	add    $0x1,%rdi
  801c27:	0f b6 37             	movzbl (%rdi),%esi
  801c2a:	40 80 fe 20          	cmp    $0x20,%sil
  801c2e:	74 f3                	je     801c23 <strtol+0x16>
  801c30:	40 80 fe 09          	cmp    $0x9,%sil
  801c34:	74 ed                	je     801c23 <strtol+0x16>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  801c36:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  801c39:	83 e0 fd             	and    $0xfffffffd,%eax
  801c3c:	3c 01                	cmp    $0x1,%al
  801c3e:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  801c42:	f7 c2 ef ff ff ff    	test   $0xffffffef,%edx
  801c48:	75 0f                	jne    801c59 <strtol+0x4c>
  801c4a:	80 3f 30             	cmpb   $0x30,(%rdi)
  801c4d:	74 14                	je     801c63 <strtol+0x56>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  801c4f:	85 d2                	test   %edx,%edx
  801c51:	b8 0a 00 00 00       	mov    $0xa,%eax
  801c56:	0f 44 d0             	cmove  %eax,%edx
    }

    /* Digits */
    long val = 0;
  801c59:	b8 00 00 00 00       	mov    $0x0,%eax
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  801c5e:	4c 63 ca             	movslq %edx,%r9
  801c61:	eb 36                	jmp    801c99 <strtol+0x8c>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  801c63:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  801c67:	74 0f                	je     801c78 <strtol+0x6b>
    } else if (!base && s[0] == '0') {
  801c69:	85 d2                	test   %edx,%edx
  801c6b:	75 ec                	jne    801c59 <strtol+0x4c>
        s++;
  801c6d:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  801c71:	ba 08 00 00 00       	mov    $0x8,%edx
        s++;
  801c76:	eb e1                	jmp    801c59 <strtol+0x4c>
        s += 2;
  801c78:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  801c7c:	ba 10 00 00 00       	mov    $0x10,%edx
        s += 2;
  801c81:	eb d6                	jmp    801c59 <strtol+0x4c>
            dig -= '0';
  801c83:	83 e9 30             	sub    $0x30,%ecx
        if (dig >= base) break;
  801c86:	44 0f b6 c1          	movzbl %cl,%r8d
  801c8a:	41 39 d0             	cmp    %edx,%r8d
  801c8d:	7d 21                	jge    801cb0 <strtol+0xa3>
        val = val * base + dig;
  801c8f:	49 0f af c1          	imul   %r9,%rax
  801c93:	0f b6 c9             	movzbl %cl,%ecx
  801c96:	48 01 c8             	add    %rcx,%rax
        uint8_t dig = *s++;
  801c99:	48 83 c7 01          	add    $0x1,%rdi
  801c9d:	0f b6 4f ff          	movzbl -0x1(%rdi),%ecx
        if (dig - '0' < 10)
  801ca1:	80 f9 39             	cmp    $0x39,%cl
  801ca4:	76 dd                	jbe    801c83 <strtol+0x76>
        else if (dig - 'a' < 27)
  801ca6:	80 f9 7b             	cmp    $0x7b,%cl
  801ca9:	77 05                	ja     801cb0 <strtol+0xa3>
            dig -= 'a' - 10;
  801cab:	83 e9 57             	sub    $0x57,%ecx
  801cae:	eb d6                	jmp    801c86 <strtol+0x79>
    }

    if (endptr) *endptr = (char *)s;
  801cb0:	4d 85 d2             	test   %r10,%r10
  801cb3:	74 03                	je     801cb8 <strtol+0xab>
  801cb5:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  801cb8:	48 89 c2             	mov    %rax,%rdx
  801cbb:	48 f7 da             	neg    %rdx
  801cbe:	40 80 fe 2d          	cmp    $0x2d,%sil
  801cc2:	48 0f 44 c2          	cmove  %rdx,%rax
}
  801cc6:	c3                   	ret

0000000000801cc7 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  801cc7:	f3 0f 1e fa          	endbr64
  801ccb:	55                   	push   %rbp
  801ccc:	48 89 e5             	mov    %rsp,%rbp
  801ccf:	53                   	push   %rbx
  801cd0:	48 89 fa             	mov    %rdi,%rdx
  801cd3:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801cd6:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801cdb:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ce0:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801ce5:	be 00 00 00 00       	mov    $0x0,%esi
  801cea:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801cf0:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  801cf2:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801cf6:	c9                   	leave
  801cf7:	c3                   	ret

0000000000801cf8 <sys_cgetc>:

int
sys_cgetc(void) {
  801cf8:	f3 0f 1e fa          	endbr64
  801cfc:	55                   	push   %rbp
  801cfd:	48 89 e5             	mov    %rsp,%rbp
  801d00:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801d01:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801d06:	ba 00 00 00 00       	mov    $0x0,%edx
  801d0b:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801d10:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d15:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801d1a:	be 00 00 00 00       	mov    $0x0,%esi
  801d1f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801d25:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  801d27:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801d2b:	c9                   	leave
  801d2c:	c3                   	ret

0000000000801d2d <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  801d2d:	f3 0f 1e fa          	endbr64
  801d31:	55                   	push   %rbp
  801d32:	48 89 e5             	mov    %rsp,%rbp
  801d35:	53                   	push   %rbx
  801d36:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  801d3a:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801d3d:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801d42:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801d47:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d4c:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801d51:	be 00 00 00 00       	mov    $0x0,%esi
  801d56:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801d5c:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801d5e:	48 85 c0             	test   %rax,%rax
  801d61:	7f 06                	jg     801d69 <sys_env_destroy+0x3c>
}
  801d63:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801d67:	c9                   	leave
  801d68:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801d69:	49 89 c0             	mov    %rax,%r8
  801d6c:	b9 03 00 00 00       	mov    $0x3,%ecx
  801d71:	48 ba 10 44 80 00 00 	movabs $0x804410,%rdx
  801d78:	00 00 00 
  801d7b:	be 26 00 00 00       	mov    $0x26,%esi
  801d80:	48 bf 6d 42 80 00 00 	movabs $0x80426d,%rdi
  801d87:	00 00 00 
  801d8a:	b8 00 00 00 00       	mov    $0x0,%eax
  801d8f:	49 b9 c2 0d 80 00 00 	movabs $0x800dc2,%r9
  801d96:	00 00 00 
  801d99:	41 ff d1             	call   *%r9

0000000000801d9c <sys_getenvid>:

envid_t
sys_getenvid(void) {
  801d9c:	f3 0f 1e fa          	endbr64
  801da0:	55                   	push   %rbp
  801da1:	48 89 e5             	mov    %rsp,%rbp
  801da4:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801da5:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801daa:	ba 00 00 00 00       	mov    $0x0,%edx
  801daf:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801db4:	bb 00 00 00 00       	mov    $0x0,%ebx
  801db9:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801dbe:	be 00 00 00 00       	mov    $0x0,%esi
  801dc3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801dc9:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  801dcb:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801dcf:	c9                   	leave
  801dd0:	c3                   	ret

0000000000801dd1 <sys_yield>:

void
sys_yield(void) {
  801dd1:	f3 0f 1e fa          	endbr64
  801dd5:	55                   	push   %rbp
  801dd6:	48 89 e5             	mov    %rsp,%rbp
  801dd9:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  801dda:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801ddf:	ba 00 00 00 00       	mov    $0x0,%edx
  801de4:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801de9:	bb 00 00 00 00       	mov    $0x0,%ebx
  801dee:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801df3:	be 00 00 00 00       	mov    $0x0,%esi
  801df8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801dfe:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  801e00:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801e04:	c9                   	leave
  801e05:	c3                   	ret

0000000000801e06 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  801e06:	f3 0f 1e fa          	endbr64
  801e0a:	55                   	push   %rbp
  801e0b:	48 89 e5             	mov    %rsp,%rbp
  801e0e:	53                   	push   %rbx
  801e0f:	48 89 fa             	mov    %rdi,%rdx
  801e12:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801e15:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801e1a:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  801e21:	00 00 00 
  801e24:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801e29:	be 00 00 00 00       	mov    $0x0,%esi
  801e2e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801e34:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  801e36:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801e3a:	c9                   	leave
  801e3b:	c3                   	ret

0000000000801e3c <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  801e3c:	f3 0f 1e fa          	endbr64
  801e40:	55                   	push   %rbp
  801e41:	48 89 e5             	mov    %rsp,%rbp
  801e44:	53                   	push   %rbx
  801e45:	49 89 f8             	mov    %rdi,%r8
  801e48:	48 89 d3             	mov    %rdx,%rbx
  801e4b:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  801e4e:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801e53:	4c 89 c2             	mov    %r8,%rdx
  801e56:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801e59:	be 00 00 00 00       	mov    $0x0,%esi
  801e5e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801e64:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  801e66:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801e6a:	c9                   	leave
  801e6b:	c3                   	ret

0000000000801e6c <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  801e6c:	f3 0f 1e fa          	endbr64
  801e70:	55                   	push   %rbp
  801e71:	48 89 e5             	mov    %rsp,%rbp
  801e74:	53                   	push   %rbx
  801e75:	48 83 ec 08          	sub    $0x8,%rsp
  801e79:	89 f8                	mov    %edi,%eax
  801e7b:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  801e7e:	48 63 f9             	movslq %ecx,%rdi
  801e81:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801e84:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801e89:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801e8c:	be 00 00 00 00       	mov    $0x0,%esi
  801e91:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801e97:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801e99:	48 85 c0             	test   %rax,%rax
  801e9c:	7f 06                	jg     801ea4 <sys_alloc_region+0x38>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  801e9e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801ea2:	c9                   	leave
  801ea3:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801ea4:	49 89 c0             	mov    %rax,%r8
  801ea7:	b9 04 00 00 00       	mov    $0x4,%ecx
  801eac:	48 ba 10 44 80 00 00 	movabs $0x804410,%rdx
  801eb3:	00 00 00 
  801eb6:	be 26 00 00 00       	mov    $0x26,%esi
  801ebb:	48 bf 6d 42 80 00 00 	movabs $0x80426d,%rdi
  801ec2:	00 00 00 
  801ec5:	b8 00 00 00 00       	mov    $0x0,%eax
  801eca:	49 b9 c2 0d 80 00 00 	movabs $0x800dc2,%r9
  801ed1:	00 00 00 
  801ed4:	41 ff d1             	call   *%r9

0000000000801ed7 <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  801ed7:	f3 0f 1e fa          	endbr64
  801edb:	55                   	push   %rbp
  801edc:	48 89 e5             	mov    %rsp,%rbp
  801edf:	53                   	push   %rbx
  801ee0:	48 83 ec 08          	sub    $0x8,%rsp
  801ee4:	89 f8                	mov    %edi,%eax
  801ee6:	49 89 f2             	mov    %rsi,%r10
  801ee9:	48 89 cf             	mov    %rcx,%rdi
  801eec:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  801eef:	48 63 da             	movslq %edx,%rbx
  801ef2:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801ef5:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801efa:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801efd:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  801f00:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801f02:	48 85 c0             	test   %rax,%rax
  801f05:	7f 06                	jg     801f0d <sys_map_region+0x36>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  801f07:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801f0b:	c9                   	leave
  801f0c:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801f0d:	49 89 c0             	mov    %rax,%r8
  801f10:	b9 05 00 00 00       	mov    $0x5,%ecx
  801f15:	48 ba 10 44 80 00 00 	movabs $0x804410,%rdx
  801f1c:	00 00 00 
  801f1f:	be 26 00 00 00       	mov    $0x26,%esi
  801f24:	48 bf 6d 42 80 00 00 	movabs $0x80426d,%rdi
  801f2b:	00 00 00 
  801f2e:	b8 00 00 00 00       	mov    $0x0,%eax
  801f33:	49 b9 c2 0d 80 00 00 	movabs $0x800dc2,%r9
  801f3a:	00 00 00 
  801f3d:	41 ff d1             	call   *%r9

0000000000801f40 <sys_map_physical_region>:

int
sys_map_physical_region(uintptr_t pa, envid_t dstenv, void *dstva, size_t size, int perm) {
  801f40:	f3 0f 1e fa          	endbr64
  801f44:	55                   	push   %rbp
  801f45:	48 89 e5             	mov    %rsp,%rbp
  801f48:	53                   	push   %rbx
  801f49:	48 83 ec 08          	sub    $0x8,%rsp
  801f4d:	49 89 f9             	mov    %rdi,%r9
  801f50:	89 f0                	mov    %esi,%eax
  801f52:	48 89 d3             	mov    %rdx,%rbx
  801f55:	48 89 cf             	mov    %rcx,%rdi
    int res = syscall(SYS_map_physical_region, 1, pa, dstenv, (uintptr_t)dstva, size, perm, 0);
  801f58:	49 63 f0             	movslq %r8d,%rsi
  801f5b:	48 63 c8             	movslq %eax,%rcx
    register uintptr_t _a0 asm("rax") = num,
  801f5e:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  801f63:	4c 89 ca             	mov    %r9,%rdx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801f66:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801f6c:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801f6e:	48 85 c0             	test   %rax,%rax
  801f71:	7f 06                	jg     801f79 <sys_map_physical_region+0x39>
#ifdef SANITIZE_USER_SHADOW_BASE
    platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  801f73:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801f77:	c9                   	leave
  801f78:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801f79:	49 89 c0             	mov    %rax,%r8
  801f7c:	b9 06 00 00 00       	mov    $0x6,%ecx
  801f81:	48 ba 10 44 80 00 00 	movabs $0x804410,%rdx
  801f88:	00 00 00 
  801f8b:	be 26 00 00 00       	mov    $0x26,%esi
  801f90:	48 bf 6d 42 80 00 00 	movabs $0x80426d,%rdi
  801f97:	00 00 00 
  801f9a:	b8 00 00 00 00       	mov    $0x0,%eax
  801f9f:	49 b9 c2 0d 80 00 00 	movabs $0x800dc2,%r9
  801fa6:	00 00 00 
  801fa9:	41 ff d1             	call   *%r9

0000000000801fac <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  801fac:	f3 0f 1e fa          	endbr64
  801fb0:	55                   	push   %rbp
  801fb1:	48 89 e5             	mov    %rsp,%rbp
  801fb4:	53                   	push   %rbx
  801fb5:	48 83 ec 08          	sub    $0x8,%rsp
  801fb9:	48 89 f1             	mov    %rsi,%rcx
  801fbc:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  801fbf:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  801fc2:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  801fc7:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  801fcc:	be 00 00 00 00       	mov    $0x0,%esi
  801fd1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  801fd7:	cd 30                	int    $0x30
    if (check && ret > 0) {
  801fd9:	48 85 c0             	test   %rax,%rax
  801fdc:	7f 06                	jg     801fe4 <sys_unmap_region+0x38>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  801fde:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801fe2:	c9                   	leave
  801fe3:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  801fe4:	49 89 c0             	mov    %rax,%r8
  801fe7:	b9 07 00 00 00       	mov    $0x7,%ecx
  801fec:	48 ba 10 44 80 00 00 	movabs $0x804410,%rdx
  801ff3:	00 00 00 
  801ff6:	be 26 00 00 00       	mov    $0x26,%esi
  801ffb:	48 bf 6d 42 80 00 00 	movabs $0x80426d,%rdi
  802002:	00 00 00 
  802005:	b8 00 00 00 00       	mov    $0x0,%eax
  80200a:	49 b9 c2 0d 80 00 00 	movabs $0x800dc2,%r9
  802011:	00 00 00 
  802014:	41 ff d1             	call   *%r9

0000000000802017 <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  802017:	f3 0f 1e fa          	endbr64
  80201b:	55                   	push   %rbp
  80201c:	48 89 e5             	mov    %rsp,%rbp
  80201f:	53                   	push   %rbx
  802020:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  802024:	48 63 ce             	movslq %esi,%rcx
  802027:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  80202a:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80202f:	bb 00 00 00 00       	mov    $0x0,%ebx
  802034:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  802039:	be 00 00 00 00       	mov    $0x0,%esi
  80203e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  802044:	cd 30                	int    $0x30
    if (check && ret > 0) {
  802046:	48 85 c0             	test   %rax,%rax
  802049:	7f 06                	jg     802051 <sys_env_set_status+0x3a>
}
  80204b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80204f:	c9                   	leave
  802050:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  802051:	49 89 c0             	mov    %rax,%r8
  802054:	b9 0a 00 00 00       	mov    $0xa,%ecx
  802059:	48 ba 10 44 80 00 00 	movabs $0x804410,%rdx
  802060:	00 00 00 
  802063:	be 26 00 00 00       	mov    $0x26,%esi
  802068:	48 bf 6d 42 80 00 00 	movabs $0x80426d,%rdi
  80206f:	00 00 00 
  802072:	b8 00 00 00 00       	mov    $0x0,%eax
  802077:	49 b9 c2 0d 80 00 00 	movabs $0x800dc2,%r9
  80207e:	00 00 00 
  802081:	41 ff d1             	call   *%r9

0000000000802084 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  802084:	f3 0f 1e fa          	endbr64
  802088:	55                   	push   %rbp
  802089:	48 89 e5             	mov    %rsp,%rbp
  80208c:	53                   	push   %rbx
  80208d:	48 83 ec 08          	sub    $0x8,%rsp
  802091:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  802094:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  802097:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  80209c:	bb 00 00 00 00       	mov    $0x0,%ebx
  8020a1:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8020a6:	be 00 00 00 00       	mov    $0x0,%esi
  8020ab:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8020b1:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8020b3:	48 85 c0             	test   %rax,%rax
  8020b6:	7f 06                	jg     8020be <sys_env_set_trapframe+0x3a>
}
  8020b8:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8020bc:	c9                   	leave
  8020bd:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8020be:	49 89 c0             	mov    %rax,%r8
  8020c1:	b9 0b 00 00 00       	mov    $0xb,%ecx
  8020c6:	48 ba 10 44 80 00 00 	movabs $0x804410,%rdx
  8020cd:	00 00 00 
  8020d0:	be 26 00 00 00       	mov    $0x26,%esi
  8020d5:	48 bf 6d 42 80 00 00 	movabs $0x80426d,%rdi
  8020dc:	00 00 00 
  8020df:	b8 00 00 00 00       	mov    $0x0,%eax
  8020e4:	49 b9 c2 0d 80 00 00 	movabs $0x800dc2,%r9
  8020eb:	00 00 00 
  8020ee:	41 ff d1             	call   *%r9

00000000008020f1 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  8020f1:	f3 0f 1e fa          	endbr64
  8020f5:	55                   	push   %rbp
  8020f6:	48 89 e5             	mov    %rsp,%rbp
  8020f9:	53                   	push   %rbx
  8020fa:	48 83 ec 08          	sub    $0x8,%rsp
  8020fe:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  802101:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  802104:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  802109:	bb 00 00 00 00       	mov    $0x0,%ebx
  80210e:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  802113:	be 00 00 00 00       	mov    $0x0,%esi
  802118:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80211e:	cd 30                	int    $0x30
    if (check && ret > 0) {
  802120:	48 85 c0             	test   %rax,%rax
  802123:	7f 06                	jg     80212b <sys_env_set_pgfault_upcall+0x3a>
}
  802125:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  802129:	c9                   	leave
  80212a:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80212b:	49 89 c0             	mov    %rax,%r8
  80212e:	b9 0c 00 00 00       	mov    $0xc,%ecx
  802133:	48 ba 10 44 80 00 00 	movabs $0x804410,%rdx
  80213a:	00 00 00 
  80213d:	be 26 00 00 00       	mov    $0x26,%esi
  802142:	48 bf 6d 42 80 00 00 	movabs $0x80426d,%rdi
  802149:	00 00 00 
  80214c:	b8 00 00 00 00       	mov    $0x0,%eax
  802151:	49 b9 c2 0d 80 00 00 	movabs $0x800dc2,%r9
  802158:	00 00 00 
  80215b:	41 ff d1             	call   *%r9

000000000080215e <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  80215e:	f3 0f 1e fa          	endbr64
  802162:	55                   	push   %rbp
  802163:	48 89 e5             	mov    %rsp,%rbp
  802166:	53                   	push   %rbx
  802167:	89 f8                	mov    %edi,%eax
  802169:	49 89 f1             	mov    %rsi,%r9
  80216c:	48 89 d3             	mov    %rdx,%rbx
  80216f:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  802172:	49 63 f0             	movslq %r8d,%rsi
  802175:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  802178:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80217d:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  802180:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  802186:	cd 30                	int    $0x30
}
  802188:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80218c:	c9                   	leave
  80218d:	c3                   	ret

000000000080218e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  80218e:	f3 0f 1e fa          	endbr64
  802192:	55                   	push   %rbp
  802193:	48 89 e5             	mov    %rsp,%rbp
  802196:	53                   	push   %rbx
  802197:	48 83 ec 08          	sub    $0x8,%rsp
  80219b:	48 89 fa             	mov    %rdi,%rdx
  80219e:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8021a1:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8021a6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8021ab:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8021b0:	be 00 00 00 00       	mov    $0x0,%esi
  8021b5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8021bb:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8021bd:	48 85 c0             	test   %rax,%rax
  8021c0:	7f 06                	jg     8021c8 <sys_ipc_recv+0x3a>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  8021c2:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8021c6:	c9                   	leave
  8021c7:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8021c8:	49 89 c0             	mov    %rax,%r8
  8021cb:	b9 0f 00 00 00       	mov    $0xf,%ecx
  8021d0:	48 ba 10 44 80 00 00 	movabs $0x804410,%rdx
  8021d7:	00 00 00 
  8021da:	be 26 00 00 00       	mov    $0x26,%esi
  8021df:	48 bf 6d 42 80 00 00 	movabs $0x80426d,%rdi
  8021e6:	00 00 00 
  8021e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ee:	49 b9 c2 0d 80 00 00 	movabs $0x800dc2,%r9
  8021f5:	00 00 00 
  8021f8:	41 ff d1             	call   *%r9

00000000008021fb <sys_gettime>:

int
sys_gettime(void) {
  8021fb:	f3 0f 1e fa          	endbr64
  8021ff:	55                   	push   %rbp
  802200:	48 89 e5             	mov    %rsp,%rbp
  802203:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  802204:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  802209:	ba 00 00 00 00       	mov    $0x0,%edx
  80220e:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  802213:	bb 00 00 00 00       	mov    $0x0,%ebx
  802218:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80221d:	be 00 00 00 00       	mov    $0x0,%esi
  802222:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  802228:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  80222a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80222e:	c9                   	leave
  80222f:	c3                   	ret

0000000000802230 <_handle_vectored_pagefault>:
/* Vector size */
static size_t _pfhandler_off = 0;
static bool _pfhandler_inititiallized = 0;

void
_handle_vectored_pagefault(struct UTrapframe *utf) {
  802230:	f3 0f 1e fa          	endbr64
  802234:	55                   	push   %rbp
  802235:	48 89 e5             	mov    %rsp,%rbp
  802238:	41 56                	push   %r14
  80223a:	41 55                	push   %r13
  80223c:	41 54                	push   %r12
  80223e:	53                   	push   %rbx
  80223f:	49 89 fc             	mov    %rdi,%r12
    /* This trying to handle pagefault until
     * some handler returns 1, that indicates
     * successfully handled exception */
    for (size_t i = 0; i < _pfhandler_off; i++)
  802242:	48 b8 28 62 80 00 00 	movabs $0x806228,%rax
  802249:	00 00 00 
  80224c:	48 83 38 00          	cmpq   $0x0,(%rax)
  802250:	74 27                	je     802279 <_handle_vectored_pagefault+0x49>
  802252:	bb 00 00 00 00       	mov    $0x0,%ebx
        if (_pfhandler_vec[i](utf)) return;
  802257:	49 bd e0 61 80 00 00 	movabs $0x8061e0,%r13
  80225e:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++)
  802261:	49 89 c6             	mov    %rax,%r14
        if (_pfhandler_vec[i](utf)) return;
  802264:	4c 89 e7             	mov    %r12,%rdi
  802267:	41 ff 54 dd 00       	call   *0x0(%r13,%rbx,8)
  80226c:	84 c0                	test   %al,%al
  80226e:	75 45                	jne    8022b5 <_handle_vectored_pagefault+0x85>
    for (size_t i = 0; i < _pfhandler_off; i++)
  802270:	48 83 c3 01          	add    $0x1,%rbx
  802274:	49 3b 1e             	cmp    (%r14),%rbx
  802277:	72 eb                	jb     802264 <_handle_vectored_pagefault+0x34>

    /* Unhandled exceptions just cause panic */
    panic("Userspace page fault rip=%08lX va=%08lX err=%x\n",
  802279:	49 8b 8c 24 88 00 00 	mov    0x88(%r12),%rcx
  802280:	00 
  802281:	45 8b 4c 24 08       	mov    0x8(%r12),%r9d
  802286:	4d 8b 04 24          	mov    (%r12),%r8
  80228a:	48 ba 30 44 80 00 00 	movabs $0x804430,%rdx
  802291:	00 00 00 
  802294:	be 1d 00 00 00       	mov    $0x1d,%esi
  802299:	48 bf 7b 42 80 00 00 	movabs $0x80427b,%rdi
  8022a0:	00 00 00 
  8022a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8022a8:	49 ba c2 0d 80 00 00 	movabs $0x800dc2,%r10
  8022af:	00 00 00 
  8022b2:	41 ff d2             	call   *%r10
          utf->utf_rip, utf->utf_fault_va, (int)utf->utf_err);
}
  8022b5:	5b                   	pop    %rbx
  8022b6:	41 5c                	pop    %r12
  8022b8:	41 5d                	pop    %r13
  8022ba:	41 5e                	pop    %r14
  8022bc:	5d                   	pop    %rbp
  8022bd:	c3                   	ret

00000000008022be <add_pgfault_handler>:
 * The first time we register a handler, we need to
 * allocate an exception stack (one page of memory with its top
 * at USER_EXCEPTION_STACK_TOP), and tell the kernel to call the assembly-language
 * _pgfault_upcall routine when a page fault occurs. */
int
add_pgfault_handler(pf_handler_t handler) {
  8022be:	f3 0f 1e fa          	endbr64
  8022c2:	55                   	push   %rbp
  8022c3:	48 89 e5             	mov    %rsp,%rbp
  8022c6:	53                   	push   %rbx
  8022c7:	48 83 ec 08          	sub    $0x8,%rsp
  8022cb:	48 89 fb             	mov    %rdi,%rbx
    int res = 0;
    if (!_pfhandler_inititiallized) {
  8022ce:	48 b8 20 62 80 00 00 	movabs $0x806220,%rax
  8022d5:	00 00 00 
  8022d8:	80 38 00             	cmpb   $0x0,(%rax)
  8022db:	0f 84 84 00 00 00    	je     802365 <add_pgfault_handler+0xa7>
        _pfhandler_vec[_pfhandler_off++] = handler;
        _pfhandler_inititiallized = 1;
        goto end;
    }

    for (size_t i = 0; i < _pfhandler_off; i++)
  8022e1:	48 b8 28 62 80 00 00 	movabs $0x806228,%rax
  8022e8:	00 00 00 
  8022eb:	48 8b 10             	mov    (%rax),%rdx
  8022ee:	b8 00 00 00 00       	mov    $0x0,%eax
        if (handler == _pfhandler_vec[i]) return 0;
  8022f3:	48 b9 e0 61 80 00 00 	movabs $0x8061e0,%rcx
  8022fa:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++)
  8022fd:	48 85 d2             	test   %rdx,%rdx
  802300:	74 19                	je     80231b <add_pgfault_handler+0x5d>
        if (handler == _pfhandler_vec[i]) return 0;
  802302:	48 39 1c c1          	cmp    %rbx,(%rcx,%rax,8)
  802306:	0f 84 e8 00 00 00    	je     8023f4 <add_pgfault_handler+0x136>
    for (size_t i = 0; i < _pfhandler_off; i++)
  80230c:	48 83 c0 01          	add    $0x1,%rax
  802310:	48 39 d0             	cmp    %rdx,%rax
  802313:	75 ed                	jne    802302 <add_pgfault_handler+0x44>

    if (_pfhandler_off == MAX_PFHANDLER)
  802315:	48 83 fa 08          	cmp    $0x8,%rdx
  802319:	74 1c                	je     802337 <add_pgfault_handler+0x79>
        res = -E_INVAL;
    else
        _pfhandler_vec[_pfhandler_off++] = handler;
  80231b:	48 8d 42 01          	lea    0x1(%rdx),%rax
  80231f:	48 a3 28 62 80 00 00 	movabs %rax,0x806228
  802326:	00 00 00 
  802329:	48 b8 e0 61 80 00 00 	movabs $0x8061e0,%rax
  802330:	00 00 00 
  802333:	48 89 1c d0          	mov    %rbx,(%rax,%rdx,8)

end:
    res = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  802337:	48 b8 9c 1d 80 00 00 	movabs $0x801d9c,%rax
  80233e:	00 00 00 
  802341:	ff d0                	call   *%rax
  802343:	89 c7                	mov    %eax,%edi
  802345:	48 be be 24 80 00 00 	movabs $0x8024be,%rsi
  80234c:	00 00 00 
  80234f:	48 b8 f1 20 80 00 00 	movabs $0x8020f1,%rax
  802356:	00 00 00 
  802359:	ff d0                	call   *%rax
    if (res < 0) panic("set_pgfault_handler: %i", res);
  80235b:	85 c0                	test   %eax,%eax
  80235d:	78 68                	js     8023c7 <add_pgfault_handler+0x109>
    return res;
}
  80235f:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  802363:	c9                   	leave
  802364:	c3                   	ret
        res = sys_alloc_region(sys_getenvid(), (void*)(USER_EXCEPTION_STACK_TOP - PAGE_SIZE), PAGE_SIZE, PROT_RW);
  802365:	48 b8 9c 1d 80 00 00 	movabs $0x801d9c,%rax
  80236c:	00 00 00 
  80236f:	ff d0                	call   *%rax
  802371:	89 c7                	mov    %eax,%edi
  802373:	b9 06 00 00 00       	mov    $0x6,%ecx
  802378:	ba 00 10 00 00       	mov    $0x1000,%edx
  80237d:	48 be 00 f0 ff ff 7f 	movabs $0x7ffffff000,%rsi
  802384:	00 00 00 
  802387:	48 b8 6c 1e 80 00 00 	movabs $0x801e6c,%rax
  80238e:	00 00 00 
  802391:	ff d0                	call   *%rax
        _pfhandler_vec[_pfhandler_off++] = handler;
  802393:	48 ba 28 62 80 00 00 	movabs $0x806228,%rdx
  80239a:	00 00 00 
  80239d:	48 8b 02             	mov    (%rdx),%rax
  8023a0:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8023a4:	48 89 0a             	mov    %rcx,(%rdx)
  8023a7:	48 ba e0 61 80 00 00 	movabs $0x8061e0,%rdx
  8023ae:	00 00 00 
  8023b1:	48 89 1c c2          	mov    %rbx,(%rdx,%rax,8)
        _pfhandler_inititiallized = 1;
  8023b5:	48 b8 20 62 80 00 00 	movabs $0x806220,%rax
  8023bc:	00 00 00 
  8023bf:	c6 00 01             	movb   $0x1,(%rax)
        goto end;
  8023c2:	e9 70 ff ff ff       	jmp    802337 <add_pgfault_handler+0x79>
    if (res < 0) panic("set_pgfault_handler: %i", res);
  8023c7:	89 c1                	mov    %eax,%ecx
  8023c9:	48 ba 89 42 80 00 00 	movabs $0x804289,%rdx
  8023d0:	00 00 00 
  8023d3:	be 3d 00 00 00       	mov    $0x3d,%esi
  8023d8:	48 bf 7b 42 80 00 00 	movabs $0x80427b,%rdi
  8023df:	00 00 00 
  8023e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8023e7:	49 b8 c2 0d 80 00 00 	movabs $0x800dc2,%r8
  8023ee:	00 00 00 
  8023f1:	41 ff d0             	call   *%r8
        if (handler == _pfhandler_vec[i]) return 0;
  8023f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8023f9:	e9 61 ff ff ff       	jmp    80235f <add_pgfault_handler+0xa1>

00000000008023fe <remove_pgfault_handler>:

void
remove_pgfault_handler(pf_handler_t handler) {
  8023fe:	f3 0f 1e fa          	endbr64
  802402:	55                   	push   %rbp
  802403:	48 89 e5             	mov    %rsp,%rbp
    assert(_pfhandler_inititiallized);
  802406:	48 b8 20 62 80 00 00 	movabs $0x806220,%rax
  80240d:	00 00 00 
  802410:	80 38 00             	cmpb   $0x0,(%rax)
  802413:	74 33                	je     802448 <remove_pgfault_handler+0x4a>
    for (size_t i = 0; i < _pfhandler_off; i++) {
  802415:	48 a1 28 62 80 00 00 	movabs 0x806228,%rax
  80241c:	00 00 00 
  80241f:	b9 00 00 00 00       	mov    $0x0,%ecx
        if (_pfhandler_vec[i] == handler) {
  802424:	48 ba e0 61 80 00 00 	movabs $0x8061e0,%rdx
  80242b:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++) {
  80242e:	48 85 c0             	test   %rax,%rax
  802431:	0f 84 85 00 00 00    	je     8024bc <remove_pgfault_handler+0xbe>
        if (_pfhandler_vec[i] == handler) {
  802437:	48 39 3c ca          	cmp    %rdi,(%rdx,%rcx,8)
  80243b:	74 40                	je     80247d <remove_pgfault_handler+0x7f>
    for (size_t i = 0; i < _pfhandler_off; i++) {
  80243d:	48 83 c1 01          	add    $0x1,%rcx
  802441:	48 39 c1             	cmp    %rax,%rcx
  802444:	75 f1                	jne    802437 <remove_pgfault_handler+0x39>
  802446:	eb 74                	jmp    8024bc <remove_pgfault_handler+0xbe>
    assert(_pfhandler_inititiallized);
  802448:	48 b9 a1 42 80 00 00 	movabs $0x8042a1,%rcx
  80244f:	00 00 00 
  802452:	48 ba bb 42 80 00 00 	movabs $0x8042bb,%rdx
  802459:	00 00 00 
  80245c:	be 43 00 00 00       	mov    $0x43,%esi
  802461:	48 bf 7b 42 80 00 00 	movabs $0x80427b,%rdi
  802468:	00 00 00 
  80246b:	b8 00 00 00 00       	mov    $0x0,%eax
  802470:	49 b8 c2 0d 80 00 00 	movabs $0x800dc2,%r8
  802477:	00 00 00 
  80247a:	41 ff d0             	call   *%r8
            memmove(_pfhandler_vec + i, _pfhandler_vec + i + 1, (_pfhandler_off - i - 1) * sizeof(*handler));
  80247d:	48 8d 34 cd 08 00 00 	lea    0x8(,%rcx,8),%rsi
  802484:	00 
  802485:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  802489:	48 29 ca             	sub    %rcx,%rdx
  80248c:	48 b8 e0 61 80 00 00 	movabs $0x8061e0,%rax
  802493:	00 00 00 
  802496:	48 8d 0c 06          	lea    (%rsi,%rax,1),%rcx
  80249a:	48 8d 7c 30 f8       	lea    -0x8(%rax,%rsi,1),%rdi
  80249f:	48 89 ce             	mov    %rcx,%rsi
  8024a2:	48 b8 82 1a 80 00 00 	movabs $0x801a82,%rax
  8024a9:	00 00 00 
  8024ac:	ff d0                	call   *%rax
            _pfhandler_off--;
  8024ae:	48 b8 28 62 80 00 00 	movabs $0x806228,%rax
  8024b5:	00 00 00 
  8024b8:	48 83 28 01          	subq   $0x1,(%rax)
            return;
        }
    }
}
  8024bc:	5d                   	pop    %rbp
  8024bd:	c3                   	ret

00000000008024be <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
    # Call the C page fault handler.
    movq  %rsp,%rdi # passing the function argument in rdi
  8024be:	48 89 e7             	mov    %rsp,%rdi
    movabs $_handle_vectored_pagefault, %rax
  8024c1:	48 b8 30 22 80 00 00 	movabs $0x802230,%rax
  8024c8:	00 00 00 
    call *%rax
  8024cb:	ff d0                	call   *%rax
    # registers are available for intermediate calculations.  You
    # may find that you have to rearrange your code in non-obvious
    # ways as registers become unavailable as scratch space.

    # LAB 9: Your code here
    movq %rsp, %rax
  8024cd:	48 89 e0             	mov    %rsp,%rax
    movq UTRAP_RIP(%rsp), %rbx
  8024d0:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  8024d7:	00 
    movq UTRAP_RSP(%rsp), %rsp
  8024d8:	48 8b a4 24 98 00 00 	mov    0x98(%rsp),%rsp
  8024df:	00 
    pushq %rbx
  8024e0:	53                   	push   %rbx
    movq %rsp, UTRAP_RSP(%rax)
  8024e1:	48 89 a0 98 00 00 00 	mov    %rsp,0x98(%rax)

    # Restore the trap-time registers.  After you do this, you
    # can no longer modify any general-purpose registers (use POPA macro).
    # LAB 9: Your code here
    movq %rax, %rsp
  8024e8:	48 89 c4             	mov    %rax,%rsp
    addq $16, %rsp
  8024eb:	48 83 c4 10          	add    $0x10,%rsp
    POPA
  8024ef:	4c 8b 3c 24          	mov    (%rsp),%r15
  8024f3:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  8024f8:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  8024fd:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  802502:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  802507:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  80250c:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  802511:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  802516:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  80251b:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  802520:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  802525:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  80252a:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  80252f:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  802534:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  802539:	48 83 c4 78          	add    $0x78,%rsp
    addq $8, %rsp
  80253d:	48 83 c4 08          	add    $0x8,%rsp
    # Restore rflags from the stack.  After you do this, you can
    # no longer use arithmetic operations or anything else that
    # modifies rflags.
    # LAB 9: Your code here
	popfq
  802541:	9d                   	popf
    # Switch back to the adjusted trap-time stack.
    # LAB 9: Your code here
	popq %rsp
  802542:	5c                   	pop    %rsp
    # Return to re-execute the instruction that faulted.
    ret
  802543:	c3                   	ret

0000000000802544 <fd2num>:


/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
  802544:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  802548:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80254f:	ff ff ff 
  802552:	48 01 f8             	add    %rdi,%rax
  802555:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802559:	c3                   	ret

000000000080255a <fd2data>:

char *
fd2data(struct Fd *fd) {
  80255a:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  80255e:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802565:	ff ff ff 
  802568:	48 01 f8             	add    %rdi,%rax
  80256b:	48 c1 e8 0c          	shr    $0xc,%rax
    return INDEX2DATA(fd2num(fd));
  80256f:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802575:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802579:	c3                   	ret

000000000080257a <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  80257a:	f3 0f 1e fa          	endbr64
  80257e:	55                   	push   %rbp
  80257f:	48 89 e5             	mov    %rsp,%rbp
  802582:	41 57                	push   %r15
  802584:	41 56                	push   %r14
  802586:	41 55                	push   %r13
  802588:	41 54                	push   %r12
  80258a:	53                   	push   %rbx
  80258b:	48 83 ec 08          	sub    $0x8,%rsp
  80258f:	49 89 ff             	mov    %rdi,%r15
  802592:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  802597:	49 bd d9 36 80 00 00 	movabs $0x8036d9,%r13
  80259e:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  8025a1:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        struct Fd *fd = INDEX2FD(i);
  8025a7:	49 89 dc             	mov    %rbx,%r12
        if (!(get_prot(fd) & PROT_R)) {
  8025aa:	48 89 df             	mov    %rbx,%rdi
  8025ad:	41 ff d5             	call   *%r13
  8025b0:	83 e0 04             	and    $0x4,%eax
  8025b3:	74 17                	je     8025cc <fd_alloc+0x52>
    for (int i = 0; i < MAXFD; i++) {
  8025b5:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  8025bc:	4c 39 f3             	cmp    %r14,%rbx
  8025bf:	75 e6                	jne    8025a7 <fd_alloc+0x2d>
  8025c1:	41 bc 00 00 00 00    	mov    $0x0,%r12d
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
    return -E_MAX_OPEN;
  8025c7:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
            *fd_store = fd;
  8025cc:	4d 89 27             	mov    %r12,(%r15)
}
  8025cf:	48 83 c4 08          	add    $0x8,%rsp
  8025d3:	5b                   	pop    %rbx
  8025d4:	41 5c                	pop    %r12
  8025d6:	41 5d                	pop    %r13
  8025d8:	41 5e                	pop    %r14
  8025da:	41 5f                	pop    %r15
  8025dc:	5d                   	pop    %rbp
  8025dd:	c3                   	ret

00000000008025de <fd_lookup>:
 *
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
  8025de:	f3 0f 1e fa          	endbr64
    if (fdnum < 0 || fdnum >= MAXFD) {
  8025e2:	83 ff 1f             	cmp    $0x1f,%edi
  8025e5:	77 39                	ja     802620 <fd_lookup+0x42>
fd_lookup(int fdnum, struct Fd **fd_store) {
  8025e7:	55                   	push   %rbp
  8025e8:	48 89 e5             	mov    %rsp,%rbp
  8025eb:	41 54                	push   %r12
  8025ed:	53                   	push   %rbx
  8025ee:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  8025f1:	48 63 df             	movslq %edi,%rbx
  8025f4:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  8025fb:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  8025ff:	48 89 df             	mov    %rbx,%rdi
  802602:	48 b8 d9 36 80 00 00 	movabs $0x8036d9,%rax
  802609:	00 00 00 
  80260c:	ff d0                	call   *%rax
  80260e:	a8 04                	test   $0x4,%al
  802610:	74 14                	je     802626 <fd_lookup+0x48>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  802612:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  802616:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80261b:	5b                   	pop    %rbx
  80261c:	41 5c                	pop    %r12
  80261e:	5d                   	pop    %rbp
  80261f:	c3                   	ret
        return -E_INVAL;
  802620:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802625:	c3                   	ret
        return -E_INVAL;
  802626:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80262b:	eb ee                	jmp    80261b <fd_lookup+0x3d>

000000000080262d <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  80262d:	f3 0f 1e fa          	endbr64
  802631:	55                   	push   %rbp
  802632:	48 89 e5             	mov    %rsp,%rbp
  802635:	41 54                	push   %r12
  802637:	53                   	push   %rbx
  802638:	49 89 f4             	mov    %rsi,%r12
    for (size_t i = 0; devtab[i]; i++) {
  80263b:	48 b8 40 48 80 00 00 	movabs $0x804840,%rax
  802642:	00 00 00 
  802645:	48 bb 20 50 80 00 00 	movabs $0x805020,%rbx
  80264c:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  80264f:	39 3b                	cmp    %edi,(%rbx)
  802651:	74 47                	je     80269a <dev_lookup+0x6d>
    for (size_t i = 0; devtab[i]; i++) {
  802653:	48 83 c0 08          	add    $0x8,%rax
  802657:	48 8b 18             	mov    (%rax),%rbx
  80265a:	48 85 db             	test   %rbx,%rbx
  80265d:	75 f0                	jne    80264f <dev_lookup+0x22>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80265f:	48 a1 d0 61 80 00 00 	movabs 0x8061d0,%rax
  802666:	00 00 00 
  802669:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  80266f:	89 fa                	mov    %edi,%edx
  802671:	48 bf 60 44 80 00 00 	movabs $0x804460,%rdi
  802678:	00 00 00 
  80267b:	b8 00 00 00 00       	mov    $0x0,%eax
  802680:	48 b9 1e 0f 80 00 00 	movabs $0x800f1e,%rcx
  802687:	00 00 00 
  80268a:	ff d1                	call   *%rcx
    *dev = 0;
    return -E_INVAL;
  80268c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
            *dev = devtab[i];
  802691:	49 89 1c 24          	mov    %rbx,(%r12)
}
  802695:	5b                   	pop    %rbx
  802696:	41 5c                	pop    %r12
  802698:	5d                   	pop    %rbp
  802699:	c3                   	ret
            return 0;
  80269a:	b8 00 00 00 00       	mov    $0x0,%eax
  80269f:	eb f0                	jmp    802691 <dev_lookup+0x64>

00000000008026a1 <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  8026a1:	f3 0f 1e fa          	endbr64
  8026a5:	55                   	push   %rbp
  8026a6:	48 89 e5             	mov    %rsp,%rbp
  8026a9:	41 55                	push   %r13
  8026ab:	41 54                	push   %r12
  8026ad:	53                   	push   %rbx
  8026ae:	48 83 ec 18          	sub    $0x18,%rsp
  8026b2:	48 89 fb             	mov    %rdi,%rbx
  8026b5:	41 89 f4             	mov    %esi,%r12d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  8026b8:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  8026bf:	ff ff ff 
  8026c2:	48 01 df             	add    %rbx,%rdi
  8026c5:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  8026c9:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8026cd:	48 b8 de 25 80 00 00 	movabs $0x8025de,%rax
  8026d4:	00 00 00 
  8026d7:	ff d0                	call   *%rax
  8026d9:	41 89 c5             	mov    %eax,%r13d
  8026dc:	85 c0                	test   %eax,%eax
  8026de:	78 06                	js     8026e6 <fd_close+0x45>
  8026e0:	48 39 5d d8          	cmp    %rbx,-0x28(%rbp)
  8026e4:	74 1a                	je     802700 <fd_close+0x5f>
        return (must_exist ? res : 0);
  8026e6:	45 84 e4             	test   %r12b,%r12b
  8026e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ee:	44 0f 44 e8          	cmove  %eax,%r13d
}
  8026f2:	44 89 e8             	mov    %r13d,%eax
  8026f5:	48 83 c4 18          	add    $0x18,%rsp
  8026f9:	5b                   	pop    %rbx
  8026fa:	41 5c                	pop    %r12
  8026fc:	41 5d                	pop    %r13
  8026fe:	5d                   	pop    %rbp
  8026ff:	c3                   	ret
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802700:	8b 3b                	mov    (%rbx),%edi
  802702:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  802706:	48 b8 2d 26 80 00 00 	movabs $0x80262d,%rax
  80270d:	00 00 00 
  802710:	ff d0                	call   *%rax
  802712:	41 89 c5             	mov    %eax,%r13d
  802715:	85 c0                	test   %eax,%eax
  802717:	78 1b                	js     802734 <fd_close+0x93>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  802719:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80271d:	48 8b 40 20          	mov    0x20(%rax),%rax
  802721:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  802727:	48 85 c0             	test   %rax,%rax
  80272a:	74 08                	je     802734 <fd_close+0x93>
  80272c:	48 89 df             	mov    %rbx,%rdi
  80272f:	ff d0                	call   *%rax
  802731:	41 89 c5             	mov    %eax,%r13d
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  802734:	ba 00 10 00 00       	mov    $0x1000,%edx
  802739:	48 89 de             	mov    %rbx,%rsi
  80273c:	bf 00 00 00 00       	mov    $0x0,%edi
  802741:	48 b8 ac 1f 80 00 00 	movabs $0x801fac,%rax
  802748:	00 00 00 
  80274b:	ff d0                	call   *%rax
    return res;
  80274d:	eb a3                	jmp    8026f2 <fd_close+0x51>

000000000080274f <close>:

int
close(int fdnum) {
  80274f:	f3 0f 1e fa          	endbr64
  802753:	55                   	push   %rbp
  802754:	48 89 e5             	mov    %rsp,%rbp
  802757:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  80275b:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  80275f:	48 b8 de 25 80 00 00 	movabs $0x8025de,%rax
  802766:	00 00 00 
  802769:	ff d0                	call   *%rax
    if (res < 0) return res;
  80276b:	85 c0                	test   %eax,%eax
  80276d:	78 15                	js     802784 <close+0x35>

    return fd_close(fd, 1);
  80276f:	be 01 00 00 00       	mov    $0x1,%esi
  802774:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  802778:	48 b8 a1 26 80 00 00 	movabs $0x8026a1,%rax
  80277f:	00 00 00 
  802782:	ff d0                	call   *%rax
}
  802784:	c9                   	leave
  802785:	c3                   	ret

0000000000802786 <close_all>:

void
close_all(void) {
  802786:	f3 0f 1e fa          	endbr64
  80278a:	55                   	push   %rbp
  80278b:	48 89 e5             	mov    %rsp,%rbp
  80278e:	41 54                	push   %r12
  802790:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  802791:	bb 00 00 00 00       	mov    $0x0,%ebx
  802796:	49 bc 4f 27 80 00 00 	movabs $0x80274f,%r12
  80279d:	00 00 00 
  8027a0:	89 df                	mov    %ebx,%edi
  8027a2:	41 ff d4             	call   *%r12
  8027a5:	83 c3 01             	add    $0x1,%ebx
  8027a8:	83 fb 20             	cmp    $0x20,%ebx
  8027ab:	75 f3                	jne    8027a0 <close_all+0x1a>
}
  8027ad:	5b                   	pop    %rbx
  8027ae:	41 5c                	pop    %r12
  8027b0:	5d                   	pop    %rbp
  8027b1:	c3                   	ret

00000000008027b2 <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  8027b2:	f3 0f 1e fa          	endbr64
  8027b6:	55                   	push   %rbp
  8027b7:	48 89 e5             	mov    %rsp,%rbp
  8027ba:	41 57                	push   %r15
  8027bc:	41 56                	push   %r14
  8027be:	41 55                	push   %r13
  8027c0:	41 54                	push   %r12
  8027c2:	53                   	push   %rbx
  8027c3:	48 83 ec 18          	sub    $0x18,%rsp
  8027c7:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  8027ca:	48 8d 75 c8          	lea    -0x38(%rbp),%rsi
  8027ce:	48 b8 de 25 80 00 00 	movabs $0x8025de,%rax
  8027d5:	00 00 00 
  8027d8:	ff d0                	call   *%rax
  8027da:	89 c3                	mov    %eax,%ebx
  8027dc:	85 c0                	test   %eax,%eax
  8027de:	0f 88 b8 00 00 00    	js     80289c <dup+0xea>
    close(newfdnum);
  8027e4:	44 89 e7             	mov    %r12d,%edi
  8027e7:	48 b8 4f 27 80 00 00 	movabs $0x80274f,%rax
  8027ee:	00 00 00 
  8027f1:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  8027f3:	4d 63 ec             	movslq %r12d,%r13
  8027f6:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  8027fd:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  802801:	4c 8b 7d c8          	mov    -0x38(%rbp),%r15
  802805:	4c 89 ff             	mov    %r15,%rdi
  802808:	49 be 5a 25 80 00 00 	movabs $0x80255a,%r14
  80280f:	00 00 00 
  802812:	41 ff d6             	call   *%r14
  802815:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  802818:	4c 89 ef             	mov    %r13,%rdi
  80281b:	41 ff d6             	call   *%r14
  80281e:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  802821:	48 89 df             	mov    %rbx,%rdi
  802824:	48 b8 d9 36 80 00 00 	movabs $0x8036d9,%rax
  80282b:	00 00 00 
  80282e:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  802830:	a8 04                	test   $0x4,%al
  802832:	74 2b                	je     80285f <dup+0xad>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  802834:	41 89 c1             	mov    %eax,%r9d
  802837:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  80283d:	4c 89 f1             	mov    %r14,%rcx
  802840:	ba 00 00 00 00       	mov    $0x0,%edx
  802845:	48 89 de             	mov    %rbx,%rsi
  802848:	bf 00 00 00 00       	mov    $0x0,%edi
  80284d:	48 b8 d7 1e 80 00 00 	movabs $0x801ed7,%rax
  802854:	00 00 00 
  802857:	ff d0                	call   *%rax
  802859:	89 c3                	mov    %eax,%ebx
  80285b:	85 c0                	test   %eax,%eax
  80285d:	78 4e                	js     8028ad <dup+0xfb>
    }
    prot = get_prot(oldfd);
  80285f:	4c 89 ff             	mov    %r15,%rdi
  802862:	48 b8 d9 36 80 00 00 	movabs $0x8036d9,%rax
  802869:	00 00 00 
  80286c:	ff d0                	call   *%rax
  80286e:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  802871:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  802877:	4c 89 e9             	mov    %r13,%rcx
  80287a:	ba 00 00 00 00       	mov    $0x0,%edx
  80287f:	4c 89 fe             	mov    %r15,%rsi
  802882:	bf 00 00 00 00       	mov    $0x0,%edi
  802887:	48 b8 d7 1e 80 00 00 	movabs $0x801ed7,%rax
  80288e:	00 00 00 
  802891:	ff d0                	call   *%rax
  802893:	89 c3                	mov    %eax,%ebx
  802895:	85 c0                	test   %eax,%eax
  802897:	78 14                	js     8028ad <dup+0xfb>

    return newfdnum;
  802899:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  80289c:	89 d8                	mov    %ebx,%eax
  80289e:	48 83 c4 18          	add    $0x18,%rsp
  8028a2:	5b                   	pop    %rbx
  8028a3:	41 5c                	pop    %r12
  8028a5:	41 5d                	pop    %r13
  8028a7:	41 5e                	pop    %r14
  8028a9:	41 5f                	pop    %r15
  8028ab:	5d                   	pop    %rbp
  8028ac:	c3                   	ret
    sys_unmap_region(0, newfd, PAGE_SIZE);
  8028ad:	ba 00 10 00 00       	mov    $0x1000,%edx
  8028b2:	4c 89 ee             	mov    %r13,%rsi
  8028b5:	bf 00 00 00 00       	mov    $0x0,%edi
  8028ba:	49 bc ac 1f 80 00 00 	movabs $0x801fac,%r12
  8028c1:	00 00 00 
  8028c4:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  8028c7:	ba 00 10 00 00       	mov    $0x1000,%edx
  8028cc:	4c 89 f6             	mov    %r14,%rsi
  8028cf:	bf 00 00 00 00       	mov    $0x0,%edi
  8028d4:	41 ff d4             	call   *%r12
    return res;
  8028d7:	eb c3                	jmp    80289c <dup+0xea>

00000000008028d9 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  8028d9:	f3 0f 1e fa          	endbr64
  8028dd:	55                   	push   %rbp
  8028de:	48 89 e5             	mov    %rsp,%rbp
  8028e1:	41 56                	push   %r14
  8028e3:	41 55                	push   %r13
  8028e5:	41 54                	push   %r12
  8028e7:	53                   	push   %rbx
  8028e8:	48 83 ec 10          	sub    $0x10,%rsp
  8028ec:	89 fb                	mov    %edi,%ebx
  8028ee:	49 89 f4             	mov    %rsi,%r12
  8028f1:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8028f4:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8028f8:	48 b8 de 25 80 00 00 	movabs $0x8025de,%rax
  8028ff:	00 00 00 
  802902:	ff d0                	call   *%rax
  802904:	85 c0                	test   %eax,%eax
  802906:	78 4c                	js     802954 <read+0x7b>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  802908:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  80290c:	41 8b 3e             	mov    (%r14),%edi
  80290f:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  802913:	48 b8 2d 26 80 00 00 	movabs $0x80262d,%rax
  80291a:	00 00 00 
  80291d:	ff d0                	call   *%rax
  80291f:	85 c0                	test   %eax,%eax
  802921:	78 35                	js     802958 <read+0x7f>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802923:	41 8b 46 08          	mov    0x8(%r14),%eax
  802927:	83 e0 03             	and    $0x3,%eax
  80292a:	83 f8 01             	cmp    $0x1,%eax
  80292d:	74 2d                	je     80295c <read+0x83>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  80292f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802933:	48 8b 40 10          	mov    0x10(%rax),%rax
  802937:	48 85 c0             	test   %rax,%rax
  80293a:	74 56                	je     802992 <read+0xb9>

    return (*dev->dev_read)(fd, buf, n);
  80293c:	4c 89 ea             	mov    %r13,%rdx
  80293f:	4c 89 e6             	mov    %r12,%rsi
  802942:	4c 89 f7             	mov    %r14,%rdi
  802945:	ff d0                	call   *%rax
}
  802947:	48 83 c4 10          	add    $0x10,%rsp
  80294b:	5b                   	pop    %rbx
  80294c:	41 5c                	pop    %r12
  80294e:	41 5d                	pop    %r13
  802950:	41 5e                	pop    %r14
  802952:	5d                   	pop    %rbp
  802953:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  802954:	48 98                	cltq
  802956:	eb ef                	jmp    802947 <read+0x6e>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  802958:	48 98                	cltq
  80295a:	eb eb                	jmp    802947 <read+0x6e>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80295c:	48 a1 d0 61 80 00 00 	movabs 0x8061d0,%rax
  802963:	00 00 00 
  802966:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  80296c:	89 da                	mov    %ebx,%edx
  80296e:	48 bf d0 42 80 00 00 	movabs $0x8042d0,%rdi
  802975:	00 00 00 
  802978:	b8 00 00 00 00       	mov    $0x0,%eax
  80297d:	48 b9 1e 0f 80 00 00 	movabs $0x800f1e,%rcx
  802984:	00 00 00 
  802987:	ff d1                	call   *%rcx
        return -E_INVAL;
  802989:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  802990:	eb b5                	jmp    802947 <read+0x6e>
    if (!dev->dev_read) return -E_NOT_SUPP;
  802992:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  802999:	eb ac                	jmp    802947 <read+0x6e>

000000000080299b <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  80299b:	f3 0f 1e fa          	endbr64
  80299f:	55                   	push   %rbp
  8029a0:	48 89 e5             	mov    %rsp,%rbp
  8029a3:	41 57                	push   %r15
  8029a5:	41 56                	push   %r14
  8029a7:	41 55                	push   %r13
  8029a9:	41 54                	push   %r12
  8029ab:	53                   	push   %rbx
  8029ac:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  8029b0:	48 85 d2             	test   %rdx,%rdx
  8029b3:	74 54                	je     802a09 <readn+0x6e>
  8029b5:	41 89 fd             	mov    %edi,%r13d
  8029b8:	49 89 f6             	mov    %rsi,%r14
  8029bb:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  8029be:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  8029c3:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  8029c8:	49 bf d9 28 80 00 00 	movabs $0x8028d9,%r15
  8029cf:	00 00 00 
  8029d2:	4c 89 e2             	mov    %r12,%rdx
  8029d5:	48 29 f2             	sub    %rsi,%rdx
  8029d8:	4c 01 f6             	add    %r14,%rsi
  8029db:	44 89 ef             	mov    %r13d,%edi
  8029de:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  8029e1:	85 c0                	test   %eax,%eax
  8029e3:	78 20                	js     802a05 <readn+0x6a>
    for (; inc && res < n; res += inc) {
  8029e5:	01 c3                	add    %eax,%ebx
  8029e7:	85 c0                	test   %eax,%eax
  8029e9:	74 08                	je     8029f3 <readn+0x58>
  8029eb:	48 63 f3             	movslq %ebx,%rsi
  8029ee:	4c 39 e6             	cmp    %r12,%rsi
  8029f1:	72 df                	jb     8029d2 <readn+0x37>
    }
    return res;
  8029f3:	48 63 c3             	movslq %ebx,%rax
}
  8029f6:	48 83 c4 08          	add    $0x8,%rsp
  8029fa:	5b                   	pop    %rbx
  8029fb:	41 5c                	pop    %r12
  8029fd:	41 5d                	pop    %r13
  8029ff:	41 5e                	pop    %r14
  802a01:	41 5f                	pop    %r15
  802a03:	5d                   	pop    %rbp
  802a04:	c3                   	ret
        if (inc < 0) return inc;
  802a05:	48 98                	cltq
  802a07:	eb ed                	jmp    8029f6 <readn+0x5b>
    int inc = 1, res = 0;
  802a09:	bb 00 00 00 00       	mov    $0x0,%ebx
  802a0e:	eb e3                	jmp    8029f3 <readn+0x58>

0000000000802a10 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  802a10:	f3 0f 1e fa          	endbr64
  802a14:	55                   	push   %rbp
  802a15:	48 89 e5             	mov    %rsp,%rbp
  802a18:	41 56                	push   %r14
  802a1a:	41 55                	push   %r13
  802a1c:	41 54                	push   %r12
  802a1e:	53                   	push   %rbx
  802a1f:	48 83 ec 10          	sub    $0x10,%rsp
  802a23:	89 fb                	mov    %edi,%ebx
  802a25:	49 89 f4             	mov    %rsi,%r12
  802a28:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  802a2b:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  802a2f:	48 b8 de 25 80 00 00 	movabs $0x8025de,%rax
  802a36:	00 00 00 
  802a39:	ff d0                	call   *%rax
  802a3b:	85 c0                	test   %eax,%eax
  802a3d:	78 47                	js     802a86 <write+0x76>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  802a3f:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  802a43:	41 8b 3e             	mov    (%r14),%edi
  802a46:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  802a4a:	48 b8 2d 26 80 00 00 	movabs $0x80262d,%rax
  802a51:	00 00 00 
  802a54:	ff d0                	call   *%rax
  802a56:	85 c0                	test   %eax,%eax
  802a58:	78 30                	js     802a8a <write+0x7a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802a5a:	41 f6 46 08 03       	testb  $0x3,0x8(%r14)
  802a5f:	74 2d                	je     802a8e <write+0x7e>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  802a61:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a65:	48 8b 40 18          	mov    0x18(%rax),%rax
  802a69:	48 85 c0             	test   %rax,%rax
  802a6c:	74 56                	je     802ac4 <write+0xb4>

    return (*dev->dev_write)(fd, buf, n);
  802a6e:	4c 89 ea             	mov    %r13,%rdx
  802a71:	4c 89 e6             	mov    %r12,%rsi
  802a74:	4c 89 f7             	mov    %r14,%rdi
  802a77:	ff d0                	call   *%rax
}
  802a79:	48 83 c4 10          	add    $0x10,%rsp
  802a7d:	5b                   	pop    %rbx
  802a7e:	41 5c                	pop    %r12
  802a80:	41 5d                	pop    %r13
  802a82:	41 5e                	pop    %r14
  802a84:	5d                   	pop    %rbp
  802a85:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  802a86:	48 98                	cltq
  802a88:	eb ef                	jmp    802a79 <write+0x69>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  802a8a:	48 98                	cltq
  802a8c:	eb eb                	jmp    802a79 <write+0x69>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802a8e:	48 a1 d0 61 80 00 00 	movabs 0x8061d0,%rax
  802a95:	00 00 00 
  802a98:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  802a9e:	89 da                	mov    %ebx,%edx
  802aa0:	48 bf ec 42 80 00 00 	movabs $0x8042ec,%rdi
  802aa7:	00 00 00 
  802aaa:	b8 00 00 00 00       	mov    $0x0,%eax
  802aaf:	48 b9 1e 0f 80 00 00 	movabs $0x800f1e,%rcx
  802ab6:	00 00 00 
  802ab9:	ff d1                	call   *%rcx
        return -E_INVAL;
  802abb:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  802ac2:	eb b5                	jmp    802a79 <write+0x69>
    if (!dev->dev_write) return -E_NOT_SUPP;
  802ac4:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  802acb:	eb ac                	jmp    802a79 <write+0x69>

0000000000802acd <seek>:

int
seek(int fdnum, off_t offset) {
  802acd:	f3 0f 1e fa          	endbr64
  802ad1:	55                   	push   %rbp
  802ad2:	48 89 e5             	mov    %rsp,%rbp
  802ad5:	53                   	push   %rbx
  802ad6:	48 83 ec 18          	sub    $0x18,%rsp
  802ada:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  802adc:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  802ae0:	48 b8 de 25 80 00 00 	movabs $0x8025de,%rax
  802ae7:	00 00 00 
  802aea:	ff d0                	call   *%rax
  802aec:	85 c0                	test   %eax,%eax
  802aee:	78 0c                	js     802afc <seek+0x2f>

    fd->fd_offset = offset;
  802af0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802af4:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  802af7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802afc:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  802b00:	c9                   	leave
  802b01:	c3                   	ret

0000000000802b02 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  802b02:	f3 0f 1e fa          	endbr64
  802b06:	55                   	push   %rbp
  802b07:	48 89 e5             	mov    %rsp,%rbp
  802b0a:	41 55                	push   %r13
  802b0c:	41 54                	push   %r12
  802b0e:	53                   	push   %rbx
  802b0f:	48 83 ec 18          	sub    $0x18,%rsp
  802b13:	89 fb                	mov    %edi,%ebx
  802b15:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  802b18:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  802b1c:	48 b8 de 25 80 00 00 	movabs $0x8025de,%rax
  802b23:	00 00 00 
  802b26:	ff d0                	call   *%rax
  802b28:	85 c0                	test   %eax,%eax
  802b2a:	78 38                	js     802b64 <ftruncate+0x62>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  802b2c:	4c 8b 6d d8          	mov    -0x28(%rbp),%r13
  802b30:	41 8b 7d 00          	mov    0x0(%r13),%edi
  802b34:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  802b38:	48 b8 2d 26 80 00 00 	movabs $0x80262d,%rax
  802b3f:	00 00 00 
  802b42:	ff d0                	call   *%rax
  802b44:	85 c0                	test   %eax,%eax
  802b46:	78 1c                	js     802b64 <ftruncate+0x62>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802b48:	41 f6 45 08 03       	testb  $0x3,0x8(%r13)
  802b4d:	74 20                	je     802b6f <ftruncate+0x6d>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  802b4f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b53:	48 8b 40 30          	mov    0x30(%rax),%rax
  802b57:	48 85 c0             	test   %rax,%rax
  802b5a:	74 47                	je     802ba3 <ftruncate+0xa1>

    return (*dev->dev_trunc)(fd, newsize);
  802b5c:	44 89 e6             	mov    %r12d,%esi
  802b5f:	4c 89 ef             	mov    %r13,%rdi
  802b62:	ff d0                	call   *%rax
}
  802b64:	48 83 c4 18          	add    $0x18,%rsp
  802b68:	5b                   	pop    %rbx
  802b69:	41 5c                	pop    %r12
  802b6b:	41 5d                	pop    %r13
  802b6d:	5d                   	pop    %rbp
  802b6e:	c3                   	ret
                thisenv->env_id, fdnum);
  802b6f:	48 a1 d0 61 80 00 00 	movabs 0x8061d0,%rax
  802b76:	00 00 00 
  802b79:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  802b7f:	89 da                	mov    %ebx,%edx
  802b81:	48 bf 80 44 80 00 00 	movabs $0x804480,%rdi
  802b88:	00 00 00 
  802b8b:	b8 00 00 00 00       	mov    $0x0,%eax
  802b90:	48 b9 1e 0f 80 00 00 	movabs $0x800f1e,%rcx
  802b97:	00 00 00 
  802b9a:	ff d1                	call   *%rcx
        return -E_INVAL;
  802b9c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ba1:	eb c1                	jmp    802b64 <ftruncate+0x62>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  802ba3:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  802ba8:	eb ba                	jmp    802b64 <ftruncate+0x62>

0000000000802baa <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  802baa:	f3 0f 1e fa          	endbr64
  802bae:	55                   	push   %rbp
  802baf:	48 89 e5             	mov    %rsp,%rbp
  802bb2:	41 54                	push   %r12
  802bb4:	53                   	push   %rbx
  802bb5:	48 83 ec 10          	sub    $0x10,%rsp
  802bb9:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  802bbc:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  802bc0:	48 b8 de 25 80 00 00 	movabs $0x8025de,%rax
  802bc7:	00 00 00 
  802bca:	ff d0                	call   *%rax
  802bcc:	85 c0                	test   %eax,%eax
  802bce:	78 4e                	js     802c1e <fstat+0x74>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  802bd0:	4c 8b 65 e8          	mov    -0x18(%rbp),%r12
  802bd4:	41 8b 3c 24          	mov    (%r12),%edi
  802bd8:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  802bdc:	48 b8 2d 26 80 00 00 	movabs $0x80262d,%rax
  802be3:	00 00 00 
  802be6:	ff d0                	call   *%rax
  802be8:	85 c0                	test   %eax,%eax
  802bea:	78 32                	js     802c1e <fstat+0x74>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  802bec:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bf0:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  802bf5:	74 30                	je     802c27 <fstat+0x7d>

    stat->st_name[0] = 0;
  802bf7:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  802bfa:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  802c01:	00 00 00 
    stat->st_isdir = 0;
  802c04:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  802c0b:	00 00 00 
    stat->st_dev = dev;
  802c0e:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  802c15:	48 89 de             	mov    %rbx,%rsi
  802c18:	4c 89 e7             	mov    %r12,%rdi
  802c1b:	ff 50 28             	call   *0x28(%rax)
}
  802c1e:	48 83 c4 10          	add    $0x10,%rsp
  802c22:	5b                   	pop    %rbx
  802c23:	41 5c                	pop    %r12
  802c25:	5d                   	pop    %rbp
  802c26:	c3                   	ret
    if (!dev->dev_stat) return -E_NOT_SUPP;
  802c27:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  802c2c:	eb f0                	jmp    802c1e <fstat+0x74>

0000000000802c2e <stat>:

int
stat(const char *path, struct Stat *stat) {
  802c2e:	f3 0f 1e fa          	endbr64
  802c32:	55                   	push   %rbp
  802c33:	48 89 e5             	mov    %rsp,%rbp
  802c36:	41 54                	push   %r12
  802c38:	53                   	push   %rbx
  802c39:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  802c3c:	be 00 00 00 00       	mov    $0x0,%esi
  802c41:	48 b8 0f 2f 80 00 00 	movabs $0x802f0f,%rax
  802c48:	00 00 00 
  802c4b:	ff d0                	call   *%rax
  802c4d:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  802c4f:	85 c0                	test   %eax,%eax
  802c51:	78 25                	js     802c78 <stat+0x4a>

    int res = fstat(fd, stat);
  802c53:	4c 89 e6             	mov    %r12,%rsi
  802c56:	89 c7                	mov    %eax,%edi
  802c58:	48 b8 aa 2b 80 00 00 	movabs $0x802baa,%rax
  802c5f:	00 00 00 
  802c62:	ff d0                	call   *%rax
  802c64:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  802c67:	89 df                	mov    %ebx,%edi
  802c69:	48 b8 4f 27 80 00 00 	movabs $0x80274f,%rax
  802c70:	00 00 00 
  802c73:	ff d0                	call   *%rax

    return res;
  802c75:	44 89 e3             	mov    %r12d,%ebx
}
  802c78:	89 d8                	mov    %ebx,%eax
  802c7a:	5b                   	pop    %rbx
  802c7b:	41 5c                	pop    %r12
  802c7d:	5d                   	pop    %rbp
  802c7e:	c3                   	ret

0000000000802c7f <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  802c7f:	f3 0f 1e fa          	endbr64
  802c83:	55                   	push   %rbp
  802c84:	48 89 e5             	mov    %rsp,%rbp
  802c87:	41 54                	push   %r12
  802c89:	53                   	push   %rbx
  802c8a:	48 83 ec 10          	sub    $0x10,%rsp
  802c8e:	41 89 fc             	mov    %edi,%r12d
  802c91:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  802c94:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c9b:	00 00 00 
  802c9e:	83 38 00             	cmpl   $0x0,(%rax)
  802ca1:	74 6e                	je     802d11 <fsipc+0x92>

    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }
    fsenv = ipc_find_env(ENV_TYPE_FS);
  802ca3:	bf 03 00 00 00       	mov    $0x3,%edi
  802ca8:	48 b8 06 3c 80 00 00 	movabs $0x803c06,%rax
  802caf:	00 00 00 
  802cb2:	ff d0                	call   *%rax
  802cb4:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  802cbb:	00 00 
    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  802cbd:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  802cc3:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802cc8:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802ccf:	00 00 00 
  802cd2:	44 89 e6             	mov    %r12d,%esi
  802cd5:	89 c7                	mov    %eax,%edi
  802cd7:	48 b8 44 3b 80 00 00 	movabs $0x803b44,%rax
  802cde:	00 00 00 
  802ce1:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  802ce3:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  802cea:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  802ceb:	b9 00 00 00 00       	mov    $0x0,%ecx
  802cf0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802cf4:	48 89 de             	mov    %rbx,%rsi
  802cf7:	bf 00 00 00 00       	mov    $0x0,%edi
  802cfc:	48 b8 ab 3a 80 00 00 	movabs $0x803aab,%rax
  802d03:	00 00 00 
  802d06:	ff d0                	call   *%rax
}
  802d08:	48 83 c4 10          	add    $0x10,%rsp
  802d0c:	5b                   	pop    %rbx
  802d0d:	41 5c                	pop    %r12
  802d0f:	5d                   	pop    %rbp
  802d10:	c3                   	ret
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  802d11:	bf 03 00 00 00       	mov    $0x3,%edi
  802d16:	48 b8 06 3c 80 00 00 	movabs $0x803c06,%rax
  802d1d:	00 00 00 
  802d20:	ff d0                	call   *%rax
  802d22:	a3 00 80 80 00 00 00 	movabs %eax,0x808000
  802d29:	00 00 
  802d2b:	e9 73 ff ff ff       	jmp    802ca3 <fsipc+0x24>

0000000000802d30 <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  802d30:	f3 0f 1e fa          	endbr64
  802d34:	55                   	push   %rbp
  802d35:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802d38:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802d3f:	00 00 00 
  802d42:	8b 57 0c             	mov    0xc(%rdi),%edx
  802d45:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  802d47:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  802d4a:	be 00 00 00 00       	mov    $0x0,%esi
  802d4f:	bf 02 00 00 00       	mov    $0x2,%edi
  802d54:	48 b8 7f 2c 80 00 00 	movabs $0x802c7f,%rax
  802d5b:	00 00 00 
  802d5e:	ff d0                	call   *%rax
}
  802d60:	5d                   	pop    %rbp
  802d61:	c3                   	ret

0000000000802d62 <devfile_flush>:
devfile_flush(struct Fd *fd) {
  802d62:	f3 0f 1e fa          	endbr64
  802d66:	55                   	push   %rbp
  802d67:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802d6a:	8b 47 0c             	mov    0xc(%rdi),%eax
  802d6d:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  802d74:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  802d76:	be 00 00 00 00       	mov    $0x0,%esi
  802d7b:	bf 06 00 00 00       	mov    $0x6,%edi
  802d80:	48 b8 7f 2c 80 00 00 	movabs $0x802c7f,%rax
  802d87:	00 00 00 
  802d8a:	ff d0                	call   *%rax
}
  802d8c:	5d                   	pop    %rbp
  802d8d:	c3                   	ret

0000000000802d8e <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  802d8e:	f3 0f 1e fa          	endbr64
  802d92:	55                   	push   %rbp
  802d93:	48 89 e5             	mov    %rsp,%rbp
  802d96:	41 54                	push   %r12
  802d98:	53                   	push   %rbx
  802d99:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802d9c:	8b 47 0c             	mov    0xc(%rdi),%eax
  802d9f:	a3 00 70 80 00 00 00 	movabs %eax,0x807000
  802da6:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  802da8:	be 00 00 00 00       	mov    $0x0,%esi
  802dad:	bf 05 00 00 00       	mov    $0x5,%edi
  802db2:	48 b8 7f 2c 80 00 00 	movabs $0x802c7f,%rax
  802db9:	00 00 00 
  802dbc:	ff d0                	call   *%rax
    if (res < 0) return res;
  802dbe:	85 c0                	test   %eax,%eax
  802dc0:	78 3d                	js     802dff <devfile_stat+0x71>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802dc2:	49 bc 00 70 80 00 00 	movabs $0x807000,%r12
  802dc9:	00 00 00 
  802dcc:	4c 89 e6             	mov    %r12,%rsi
  802dcf:	48 89 df             	mov    %rbx,%rdi
  802dd2:	48 b8 67 18 80 00 00 	movabs $0x801867,%rax
  802dd9:	00 00 00 
  802ddc:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  802dde:	41 8b 84 24 80 00 00 	mov    0x80(%r12),%eax
  802de5:	00 
  802de6:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802dec:	41 8b 84 24 84 00 00 	mov    0x84(%r12),%eax
  802df3:	00 
  802df4:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  802dfa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802dff:	5b                   	pop    %rbx
  802e00:	41 5c                	pop    %r12
  802e02:	5d                   	pop    %rbp
  802e03:	c3                   	ret

0000000000802e04 <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  802e04:	f3 0f 1e fa          	endbr64
    if (n >= sizeof(fsipcbuf.write.req_buf)) {
  802e08:	48 81 fa ef 0f 00 00 	cmp    $0xfef,%rdx
  802e0f:	77 41                	ja     802e52 <devfile_write+0x4e>
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  802e11:	55                   	push   %rbp
  802e12:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  802e15:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802e1c:	00 00 00 
  802e1f:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  802e22:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.write.req_n = n;
  802e24:	48 89 50 08          	mov    %rdx,0x8(%rax)
    memmove(fsipcbuf.write.req_buf, buf, n);
  802e28:	48 8d 78 10          	lea    0x10(%rax),%rdi
  802e2c:	48 b8 82 1a 80 00 00 	movabs $0x801a82,%rax
  802e33:	00 00 00 
  802e36:	ff d0                	call   *%rax
    res = fsipc(FSREQ_WRITE, NULL);
  802e38:	be 00 00 00 00       	mov    $0x0,%esi
  802e3d:	bf 04 00 00 00       	mov    $0x4,%edi
  802e42:	48 b8 7f 2c 80 00 00 	movabs $0x802c7f,%rax
  802e49:	00 00 00 
  802e4c:	ff d0                	call   *%rax
  802e4e:	48 98                	cltq
}
  802e50:	5d                   	pop    %rbp
  802e51:	c3                   	ret
        return -E_INVAL;
  802e52:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
}
  802e59:	c3                   	ret

0000000000802e5a <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  802e5a:	f3 0f 1e fa          	endbr64
  802e5e:	55                   	push   %rbp
  802e5f:	48 89 e5             	mov    %rsp,%rbp
  802e62:	41 55                	push   %r13
  802e64:	41 54                	push   %r12
  802e66:	53                   	push   %rbx
  802e67:	48 83 ec 08          	sub    $0x8,%rsp
  802e6b:	49 89 f4             	mov    %rsi,%r12
  802e6e:	48 89 d3             	mov    %rdx,%rbx
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  802e71:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802e78:	00 00 00 
  802e7b:	8b 57 0c             	mov    0xc(%rdi),%edx
  802e7e:	89 10                	mov    %edx,(%rax)
    fsipcbuf.read.req_n = n;
  802e80:	48 89 58 08          	mov    %rbx,0x8(%rax)
    res = fsipc(FSREQ_READ, NULL);
  802e84:	be 00 00 00 00       	mov    $0x0,%esi
  802e89:	bf 03 00 00 00       	mov    $0x3,%edi
  802e8e:	48 b8 7f 2c 80 00 00 	movabs $0x802c7f,%rax
  802e95:	00 00 00 
  802e98:	ff d0                	call   *%rax
  802e9a:	4c 63 e8             	movslq %eax,%r13
    if (res < 0) {
  802e9d:	4d 85 ed             	test   %r13,%r13
  802ea0:	78 2a                	js     802ecc <devfile_read+0x72>
    assert(res <= n && res <= PAGE_SIZE);
  802ea2:	4c 89 ea             	mov    %r13,%rdx
  802ea5:	4c 39 eb             	cmp    %r13,%rbx
  802ea8:	72 30                	jb     802eda <devfile_read+0x80>
  802eaa:	49 81 fd 00 10 00 00 	cmp    $0x1000,%r13
  802eb1:	7f 27                	jg     802eda <devfile_read+0x80>
    memmove(buf, &fsipcbuf, res);
  802eb3:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802eba:	00 00 00 
  802ebd:	4c 89 e7             	mov    %r12,%rdi
  802ec0:	48 b8 82 1a 80 00 00 	movabs $0x801a82,%rax
  802ec7:	00 00 00 
  802eca:	ff d0                	call   *%rax
}
  802ecc:	4c 89 e8             	mov    %r13,%rax
  802ecf:	48 83 c4 08          	add    $0x8,%rsp
  802ed3:	5b                   	pop    %rbx
  802ed4:	41 5c                	pop    %r12
  802ed6:	41 5d                	pop    %r13
  802ed8:	5d                   	pop    %rbp
  802ed9:	c3                   	ret
    assert(res <= n && res <= PAGE_SIZE);
  802eda:	48 b9 09 43 80 00 00 	movabs $0x804309,%rcx
  802ee1:	00 00 00 
  802ee4:	48 ba bb 42 80 00 00 	movabs $0x8042bb,%rdx
  802eeb:	00 00 00 
  802eee:	be 7b 00 00 00       	mov    $0x7b,%esi
  802ef3:	48 bf 26 43 80 00 00 	movabs $0x804326,%rdi
  802efa:	00 00 00 
  802efd:	b8 00 00 00 00       	mov    $0x0,%eax
  802f02:	49 b8 c2 0d 80 00 00 	movabs $0x800dc2,%r8
  802f09:	00 00 00 
  802f0c:	41 ff d0             	call   *%r8

0000000000802f0f <open>:
open(const char *path, int mode) {
  802f0f:	f3 0f 1e fa          	endbr64
  802f13:	55                   	push   %rbp
  802f14:	48 89 e5             	mov    %rsp,%rbp
  802f17:	41 55                	push   %r13
  802f19:	41 54                	push   %r12
  802f1b:	53                   	push   %rbx
  802f1c:	48 83 ec 18          	sub    $0x18,%rsp
  802f20:	49 89 fc             	mov    %rdi,%r12
  802f23:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  802f26:	48 b8 22 18 80 00 00 	movabs $0x801822,%rax
  802f2d:	00 00 00 
  802f30:	ff d0                	call   *%rax
  802f32:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  802f38:	0f 87 8a 00 00 00    	ja     802fc8 <open+0xb9>
    if ((res = fd_alloc(&fd)) < 0) return res;
  802f3e:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  802f42:	48 b8 7a 25 80 00 00 	movabs $0x80257a,%rax
  802f49:	00 00 00 
  802f4c:	ff d0                	call   *%rax
  802f4e:	89 c3                	mov    %eax,%ebx
  802f50:	85 c0                	test   %eax,%eax
  802f52:	78 50                	js     802fa4 <open+0x95>
    strcpy(fsipcbuf.open.req_path, path);
  802f54:	4c 89 e6             	mov    %r12,%rsi
  802f57:	48 bb 00 70 80 00 00 	movabs $0x807000,%rbx
  802f5e:	00 00 00 
  802f61:	48 89 df             	mov    %rbx,%rdi
  802f64:	48 b8 67 18 80 00 00 	movabs $0x801867,%rax
  802f6b:	00 00 00 
  802f6e:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  802f70:	44 89 ab 00 04 00 00 	mov    %r13d,0x400(%rbx)
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  802f77:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802f7b:	bf 01 00 00 00       	mov    $0x1,%edi
  802f80:	48 b8 7f 2c 80 00 00 	movabs $0x802c7f,%rax
  802f87:	00 00 00 
  802f8a:	ff d0                	call   *%rax
  802f8c:	89 c3                	mov    %eax,%ebx
  802f8e:	85 c0                	test   %eax,%eax
  802f90:	78 1f                	js     802fb1 <open+0xa2>
    return fd2num(fd);
  802f92:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802f96:	48 b8 44 25 80 00 00 	movabs $0x802544,%rax
  802f9d:	00 00 00 
  802fa0:	ff d0                	call   *%rax
  802fa2:	89 c3                	mov    %eax,%ebx
}
  802fa4:	89 d8                	mov    %ebx,%eax
  802fa6:	48 83 c4 18          	add    $0x18,%rsp
  802faa:	5b                   	pop    %rbx
  802fab:	41 5c                	pop    %r12
  802fad:	41 5d                	pop    %r13
  802faf:	5d                   	pop    %rbp
  802fb0:	c3                   	ret
        fd_close(fd, 0);
  802fb1:	be 00 00 00 00       	mov    $0x0,%esi
  802fb6:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  802fba:	48 b8 a1 26 80 00 00 	movabs $0x8026a1,%rax
  802fc1:	00 00 00 
  802fc4:	ff d0                	call   *%rax
        return res;
  802fc6:	eb dc                	jmp    802fa4 <open+0x95>
        return -E_BAD_PATH;
  802fc8:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  802fcd:	eb d5                	jmp    802fa4 <open+0x95>

0000000000802fcf <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  802fcf:	f3 0f 1e fa          	endbr64
  802fd3:	55                   	push   %rbp
  802fd4:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  802fd7:	be 00 00 00 00       	mov    $0x0,%esi
  802fdc:	bf 08 00 00 00       	mov    $0x8,%edi
  802fe1:	48 b8 7f 2c 80 00 00 	movabs $0x802c7f,%rax
  802fe8:	00 00 00 
  802feb:	ff d0                	call   *%rax
}
  802fed:	5d                   	pop    %rbp
  802fee:	c3                   	ret

0000000000802fef <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  802fef:	f3 0f 1e fa          	endbr64
  802ff3:	55                   	push   %rbp
  802ff4:	48 89 e5             	mov    %rsp,%rbp
  802ff7:	41 54                	push   %r12
  802ff9:	53                   	push   %rbx
  802ffa:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  802ffd:	48 b8 5a 25 80 00 00 	movabs $0x80255a,%rax
  803004:	00 00 00 
  803007:	ff d0                	call   *%rax
  803009:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  80300c:	48 be 31 43 80 00 00 	movabs $0x804331,%rsi
  803013:	00 00 00 
  803016:	48 89 df             	mov    %rbx,%rdi
  803019:	48 b8 67 18 80 00 00 	movabs $0x801867,%rax
  803020:	00 00 00 
  803023:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  803025:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  80302a:	41 2b 04 24          	sub    (%r12),%eax
  80302e:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  803034:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  80303b:	00 00 00 
    stat->st_dev = &devpipe;
  80303e:	48 b8 60 50 80 00 00 	movabs $0x805060,%rax
  803045:	00 00 00 
  803048:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  80304f:	b8 00 00 00 00       	mov    $0x0,%eax
  803054:	5b                   	pop    %rbx
  803055:	41 5c                	pop    %r12
  803057:	5d                   	pop    %rbp
  803058:	c3                   	ret

0000000000803059 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  803059:	f3 0f 1e fa          	endbr64
  80305d:	55                   	push   %rbp
  80305e:	48 89 e5             	mov    %rsp,%rbp
  803061:	41 54                	push   %r12
  803063:	53                   	push   %rbx
  803064:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  803067:	ba 00 10 00 00       	mov    $0x1000,%edx
  80306c:	48 89 fe             	mov    %rdi,%rsi
  80306f:	bf 00 00 00 00       	mov    $0x0,%edi
  803074:	49 bc ac 1f 80 00 00 	movabs $0x801fac,%r12
  80307b:	00 00 00 
  80307e:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  803081:	48 89 df             	mov    %rbx,%rdi
  803084:	48 b8 5a 25 80 00 00 	movabs $0x80255a,%rax
  80308b:	00 00 00 
  80308e:	ff d0                	call   *%rax
  803090:	48 89 c6             	mov    %rax,%rsi
  803093:	ba 00 10 00 00       	mov    $0x1000,%edx
  803098:	bf 00 00 00 00       	mov    $0x0,%edi
  80309d:	41 ff d4             	call   *%r12
}
  8030a0:	5b                   	pop    %rbx
  8030a1:	41 5c                	pop    %r12
  8030a3:	5d                   	pop    %rbp
  8030a4:	c3                   	ret

00000000008030a5 <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  8030a5:	f3 0f 1e fa          	endbr64
  8030a9:	55                   	push   %rbp
  8030aa:	48 89 e5             	mov    %rsp,%rbp
  8030ad:	41 57                	push   %r15
  8030af:	41 56                	push   %r14
  8030b1:	41 55                	push   %r13
  8030b3:	41 54                	push   %r12
  8030b5:	53                   	push   %rbx
  8030b6:	48 83 ec 18          	sub    $0x18,%rsp
  8030ba:	49 89 fc             	mov    %rdi,%r12
  8030bd:	49 89 f5             	mov    %rsi,%r13
  8030c0:	49 89 d7             	mov    %rdx,%r15
  8030c3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8030c7:	48 b8 5a 25 80 00 00 	movabs $0x80255a,%rax
  8030ce:	00 00 00 
  8030d1:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  8030d3:	4d 85 ff             	test   %r15,%r15
  8030d6:	0f 84 af 00 00 00    	je     80318b <devpipe_write+0xe6>
  8030dc:	48 89 c3             	mov    %rax,%rbx
  8030df:	4c 89 f8             	mov    %r15,%rax
  8030e2:	4d 89 ef             	mov    %r13,%r15
  8030e5:	4c 01 e8             	add    %r13,%rax
  8030e8:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8030ec:	49 bd 3c 1e 80 00 00 	movabs $0x801e3c,%r13
  8030f3:	00 00 00 
            sys_yield();
  8030f6:	49 be d1 1d 80 00 00 	movabs $0x801dd1,%r14
  8030fd:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  803100:	8b 73 04             	mov    0x4(%rbx),%esi
  803103:	48 63 ce             	movslq %esi,%rcx
  803106:	48 63 03             	movslq (%rbx),%rax
  803109:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  80310f:	48 39 c1             	cmp    %rax,%rcx
  803112:	72 2e                	jb     803142 <devpipe_write+0x9d>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  803114:	b9 00 10 00 00       	mov    $0x1000,%ecx
  803119:	48 89 da             	mov    %rbx,%rdx
  80311c:	be 00 10 00 00       	mov    $0x1000,%esi
  803121:	4c 89 e7             	mov    %r12,%rdi
  803124:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  803127:	85 c0                	test   %eax,%eax
  803129:	74 66                	je     803191 <devpipe_write+0xec>
            sys_yield();
  80312b:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  80312e:	8b 73 04             	mov    0x4(%rbx),%esi
  803131:	48 63 ce             	movslq %esi,%rcx
  803134:	48 63 03             	movslq (%rbx),%rax
  803137:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  80313d:	48 39 c1             	cmp    %rax,%rcx
  803140:	73 d2                	jae    803114 <devpipe_write+0x6f>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803142:	41 0f b6 3f          	movzbl (%r15),%edi
  803146:	48 89 ca             	mov    %rcx,%rdx
  803149:	48 c1 ea 03          	shr    $0x3,%rdx
  80314d:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  803154:	08 10 20 
  803157:	48 f7 e2             	mul    %rdx
  80315a:	48 c1 ea 06          	shr    $0x6,%rdx
  80315e:	48 89 d0             	mov    %rdx,%rax
  803161:	48 c1 e0 09          	shl    $0x9,%rax
  803165:	48 29 d0             	sub    %rdx,%rax
  803168:	48 c1 e0 03          	shl    $0x3,%rax
  80316c:	48 29 c1             	sub    %rax,%rcx
  80316f:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  803174:	83 c6 01             	add    $0x1,%esi
  803177:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  80317a:	49 83 c7 01          	add    $0x1,%r15
  80317e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803182:	49 39 c7             	cmp    %rax,%r15
  803185:	0f 85 75 ff ff ff    	jne    803100 <devpipe_write+0x5b>
    return n;
  80318b:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80318f:	eb 05                	jmp    803196 <devpipe_write+0xf1>
            if (_pipeisclosed(fd, p)) return 0;
  803191:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803196:	48 83 c4 18          	add    $0x18,%rsp
  80319a:	5b                   	pop    %rbx
  80319b:	41 5c                	pop    %r12
  80319d:	41 5d                	pop    %r13
  80319f:	41 5e                	pop    %r14
  8031a1:	41 5f                	pop    %r15
  8031a3:	5d                   	pop    %rbp
  8031a4:	c3                   	ret

00000000008031a5 <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  8031a5:	f3 0f 1e fa          	endbr64
  8031a9:	55                   	push   %rbp
  8031aa:	48 89 e5             	mov    %rsp,%rbp
  8031ad:	41 57                	push   %r15
  8031af:	41 56                	push   %r14
  8031b1:	41 55                	push   %r13
  8031b3:	41 54                	push   %r12
  8031b5:	53                   	push   %rbx
  8031b6:	48 83 ec 18          	sub    $0x18,%rsp
  8031ba:	49 89 fc             	mov    %rdi,%r12
  8031bd:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  8031c1:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8031c5:	48 b8 5a 25 80 00 00 	movabs $0x80255a,%rax
  8031cc:	00 00 00 
  8031cf:	ff d0                	call   *%rax
  8031d1:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  8031d4:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8031da:	49 bd 3c 1e 80 00 00 	movabs $0x801e3c,%r13
  8031e1:	00 00 00 
            sys_yield();
  8031e4:	49 be d1 1d 80 00 00 	movabs $0x801dd1,%r14
  8031eb:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  8031ee:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8031f3:	74 7d                	je     803272 <devpipe_read+0xcd>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8031f5:	8b 03                	mov    (%rbx),%eax
  8031f7:	3b 43 04             	cmp    0x4(%rbx),%eax
  8031fa:	75 26                	jne    803222 <devpipe_read+0x7d>
            if (i > 0) return i;
  8031fc:	4d 85 ff             	test   %r15,%r15
  8031ff:	75 77                	jne    803278 <devpipe_read+0xd3>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  803201:	b9 00 10 00 00       	mov    $0x1000,%ecx
  803206:	48 89 da             	mov    %rbx,%rdx
  803209:	be 00 10 00 00       	mov    $0x1000,%esi
  80320e:	4c 89 e7             	mov    %r12,%rdi
  803211:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  803214:	85 c0                	test   %eax,%eax
  803216:	74 72                	je     80328a <devpipe_read+0xe5>
            sys_yield();
  803218:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  80321b:	8b 03                	mov    (%rbx),%eax
  80321d:	3b 43 04             	cmp    0x4(%rbx),%eax
  803220:	74 df                	je     803201 <devpipe_read+0x5c>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803222:	48 63 c8             	movslq %eax,%rcx
  803225:	48 89 ca             	mov    %rcx,%rdx
  803228:	48 c1 ea 03          	shr    $0x3,%rdx
  80322c:	48 be 81 00 01 02 04 	movabs $0x2010080402010081,%rsi
  803233:	08 10 20 
  803236:	48 89 d0             	mov    %rdx,%rax
  803239:	48 f7 e6             	mul    %rsi
  80323c:	48 c1 ea 06          	shr    $0x6,%rdx
  803240:	48 89 d0             	mov    %rdx,%rax
  803243:	48 c1 e0 09          	shl    $0x9,%rax
  803247:	48 29 d0             	sub    %rdx,%rax
  80324a:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803251:	00 
  803252:	48 89 c8             	mov    %rcx,%rax
  803255:	48 29 d0             	sub    %rdx,%rax
  803258:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  80325d:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  803261:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  803265:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  803268:	49 83 c7 01          	add    $0x1,%r15
  80326c:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  803270:	75 83                	jne    8031f5 <devpipe_read+0x50>
    return n;
  803272:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803276:	eb 03                	jmp    80327b <devpipe_read+0xd6>
            if (i > 0) return i;
  803278:	4c 89 f8             	mov    %r15,%rax
}
  80327b:	48 83 c4 18          	add    $0x18,%rsp
  80327f:	5b                   	pop    %rbx
  803280:	41 5c                	pop    %r12
  803282:	41 5d                	pop    %r13
  803284:	41 5e                	pop    %r14
  803286:	41 5f                	pop    %r15
  803288:	5d                   	pop    %rbp
  803289:	c3                   	ret
            if (_pipeisclosed(fd, p)) return 0;
  80328a:	b8 00 00 00 00       	mov    $0x0,%eax
  80328f:	eb ea                	jmp    80327b <devpipe_read+0xd6>

0000000000803291 <pipe>:
pipe(int pfd[2]) {
  803291:	f3 0f 1e fa          	endbr64
  803295:	55                   	push   %rbp
  803296:	48 89 e5             	mov    %rsp,%rbp
  803299:	41 55                	push   %r13
  80329b:	41 54                	push   %r12
  80329d:	53                   	push   %rbx
  80329e:	48 83 ec 18          	sub    $0x18,%rsp
  8032a2:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  8032a5:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  8032a9:	48 b8 7a 25 80 00 00 	movabs $0x80257a,%rax
  8032b0:	00 00 00 
  8032b3:	ff d0                	call   *%rax
  8032b5:	89 c3                	mov    %eax,%ebx
  8032b7:	85 c0                	test   %eax,%eax
  8032b9:	0f 88 a0 01 00 00    	js     80345f <pipe+0x1ce>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  8032bf:	b9 46 00 00 00       	mov    $0x46,%ecx
  8032c4:	ba 00 10 00 00       	mov    $0x1000,%edx
  8032c9:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  8032cd:	bf 00 00 00 00       	mov    $0x0,%edi
  8032d2:	48 b8 6c 1e 80 00 00 	movabs $0x801e6c,%rax
  8032d9:	00 00 00 
  8032dc:	ff d0                	call   *%rax
  8032de:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  8032e0:	85 c0                	test   %eax,%eax
  8032e2:	0f 88 77 01 00 00    	js     80345f <pipe+0x1ce>
    if ((res = fd_alloc(&fd1)) < 0 ||
  8032e8:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  8032ec:	48 b8 7a 25 80 00 00 	movabs $0x80257a,%rax
  8032f3:	00 00 00 
  8032f6:	ff d0                	call   *%rax
  8032f8:	89 c3                	mov    %eax,%ebx
  8032fa:	85 c0                	test   %eax,%eax
  8032fc:	0f 88 43 01 00 00    	js     803445 <pipe+0x1b4>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  803302:	b9 46 00 00 00       	mov    $0x46,%ecx
  803307:	ba 00 10 00 00       	mov    $0x1000,%edx
  80330c:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  803310:	bf 00 00 00 00       	mov    $0x0,%edi
  803315:	48 b8 6c 1e 80 00 00 	movabs $0x801e6c,%rax
  80331c:	00 00 00 
  80331f:	ff d0                	call   *%rax
  803321:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  803323:	85 c0                	test   %eax,%eax
  803325:	0f 88 1a 01 00 00    	js     803445 <pipe+0x1b4>
    va = fd2data(fd0);
  80332b:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80332f:	48 b8 5a 25 80 00 00 	movabs $0x80255a,%rax
  803336:	00 00 00 
  803339:	ff d0                	call   *%rax
  80333b:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  80333e:	b9 46 00 00 00       	mov    $0x46,%ecx
  803343:	ba 00 10 00 00       	mov    $0x1000,%edx
  803348:	48 89 c6             	mov    %rax,%rsi
  80334b:	bf 00 00 00 00       	mov    $0x0,%edi
  803350:	48 b8 6c 1e 80 00 00 	movabs $0x801e6c,%rax
  803357:	00 00 00 
  80335a:	ff d0                	call   *%rax
  80335c:	89 c3                	mov    %eax,%ebx
  80335e:	85 c0                	test   %eax,%eax
  803360:	0f 88 c5 00 00 00    	js     80342b <pipe+0x19a>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  803366:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  80336a:	48 b8 5a 25 80 00 00 	movabs $0x80255a,%rax
  803371:	00 00 00 
  803374:	ff d0                	call   *%rax
  803376:	48 89 c1             	mov    %rax,%rcx
  803379:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  80337f:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  803385:	ba 00 00 00 00       	mov    $0x0,%edx
  80338a:	4c 89 ee             	mov    %r13,%rsi
  80338d:	bf 00 00 00 00       	mov    $0x0,%edi
  803392:	48 b8 d7 1e 80 00 00 	movabs $0x801ed7,%rax
  803399:	00 00 00 
  80339c:	ff d0                	call   *%rax
  80339e:	89 c3                	mov    %eax,%ebx
  8033a0:	85 c0                	test   %eax,%eax
  8033a2:	78 6e                	js     803412 <pipe+0x181>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  8033a4:	be 00 10 00 00       	mov    $0x1000,%esi
  8033a9:	4c 89 ef             	mov    %r13,%rdi
  8033ac:	48 b8 06 1e 80 00 00 	movabs $0x801e06,%rax
  8033b3:	00 00 00 
  8033b6:	ff d0                	call   *%rax
  8033b8:	83 f8 02             	cmp    $0x2,%eax
  8033bb:	0f 85 ab 00 00 00    	jne    80346c <pipe+0x1db>
    fd0->fd_dev_id = devpipe.dev_id;
  8033c1:	a1 60 50 80 00 00 00 	movabs 0x805060,%eax
  8033c8:	00 00 
  8033ca:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8033ce:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  8033d0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8033d4:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  8033db:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8033df:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  8033e1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033e5:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  8033ec:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8033f0:	48 bb 44 25 80 00 00 	movabs $0x802544,%rbx
  8033f7:	00 00 00 
  8033fa:	ff d3                	call   *%rbx
  8033fc:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  803400:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  803404:	ff d3                	call   *%rbx
  803406:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  80340b:	bb 00 00 00 00       	mov    $0x0,%ebx
  803410:	eb 4d                	jmp    80345f <pipe+0x1ce>
    sys_unmap_region(0, va, PAGE_SIZE);
  803412:	ba 00 10 00 00       	mov    $0x1000,%edx
  803417:	4c 89 ee             	mov    %r13,%rsi
  80341a:	bf 00 00 00 00       	mov    $0x0,%edi
  80341f:	48 b8 ac 1f 80 00 00 	movabs $0x801fac,%rax
  803426:	00 00 00 
  803429:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  80342b:	ba 00 10 00 00       	mov    $0x1000,%edx
  803430:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  803434:	bf 00 00 00 00       	mov    $0x0,%edi
  803439:	48 b8 ac 1f 80 00 00 	movabs $0x801fac,%rax
  803440:	00 00 00 
  803443:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  803445:	ba 00 10 00 00       	mov    $0x1000,%edx
  80344a:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80344e:	bf 00 00 00 00       	mov    $0x0,%edi
  803453:	48 b8 ac 1f 80 00 00 	movabs $0x801fac,%rax
  80345a:	00 00 00 
  80345d:	ff d0                	call   *%rax
}
  80345f:	89 d8                	mov    %ebx,%eax
  803461:	48 83 c4 18          	add    $0x18,%rsp
  803465:	5b                   	pop    %rbx
  803466:	41 5c                	pop    %r12
  803468:	41 5d                	pop    %r13
  80346a:	5d                   	pop    %rbp
  80346b:	c3                   	ret
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  80346c:	48 b9 a8 44 80 00 00 	movabs $0x8044a8,%rcx
  803473:	00 00 00 
  803476:	48 ba bb 42 80 00 00 	movabs $0x8042bb,%rdx
  80347d:	00 00 00 
  803480:	be 2e 00 00 00       	mov    $0x2e,%esi
  803485:	48 bf 38 43 80 00 00 	movabs $0x804338,%rdi
  80348c:	00 00 00 
  80348f:	b8 00 00 00 00       	mov    $0x0,%eax
  803494:	49 b8 c2 0d 80 00 00 	movabs $0x800dc2,%r8
  80349b:	00 00 00 
  80349e:	41 ff d0             	call   *%r8

00000000008034a1 <pipeisclosed>:
pipeisclosed(int fdnum) {
  8034a1:	f3 0f 1e fa          	endbr64
  8034a5:	55                   	push   %rbp
  8034a6:	48 89 e5             	mov    %rsp,%rbp
  8034a9:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  8034ad:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  8034b1:	48 b8 de 25 80 00 00 	movabs $0x8025de,%rax
  8034b8:	00 00 00 
  8034bb:	ff d0                	call   *%rax
    if (res < 0) return res;
  8034bd:	85 c0                	test   %eax,%eax
  8034bf:	78 35                	js     8034f6 <pipeisclosed+0x55>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  8034c1:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8034c5:	48 b8 5a 25 80 00 00 	movabs $0x80255a,%rax
  8034cc:	00 00 00 
  8034cf:	ff d0                	call   *%rax
  8034d1:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8034d4:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8034d9:	be 00 10 00 00       	mov    $0x1000,%esi
  8034de:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  8034e2:	48 b8 3c 1e 80 00 00 	movabs $0x801e3c,%rax
  8034e9:	00 00 00 
  8034ec:	ff d0                	call   *%rax
  8034ee:	85 c0                	test   %eax,%eax
  8034f0:	0f 94 c0             	sete   %al
  8034f3:	0f b6 c0             	movzbl %al,%eax
}
  8034f6:	c9                   	leave
  8034f7:	c3                   	ret

00000000008034f8 <get_uvpt_entry>:
extern volatile pde_t uvpd[];     /* VA of current page directory */
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
  8034f8:	f3 0f 1e fa          	endbr64
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8034fc:	48 89 f8             	mov    %rdi,%rax
  8034ff:	48 c1 e8 27          	shr    $0x27,%rax
  803503:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  80350a:	7f 00 00 
  80350d:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  803511:	f6 c2 01             	test   $0x1,%dl
  803514:	74 6d                	je     803583 <get_uvpt_entry+0x8b>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  803516:	48 89 f8             	mov    %rdi,%rax
  803519:	48 c1 e8 1e          	shr    $0x1e,%rax
  80351d:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  803524:	7f 00 00 
  803527:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80352b:	f6 c2 01             	test   $0x1,%dl
  80352e:	74 62                	je     803592 <get_uvpt_entry+0x9a>
  803530:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  803537:	7f 00 00 
  80353a:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80353e:	f6 c2 80             	test   $0x80,%dl
  803541:	75 4f                	jne    803592 <get_uvpt_entry+0x9a>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  803543:	48 89 f8             	mov    %rdi,%rax
  803546:	48 c1 e8 15          	shr    $0x15,%rax
  80354a:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  803551:	7f 00 00 
  803554:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  803558:	f6 c2 01             	test   $0x1,%dl
  80355b:	74 44                	je     8035a1 <get_uvpt_entry+0xa9>
  80355d:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  803564:	7f 00 00 
  803567:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  80356b:	f6 c2 80             	test   $0x80,%dl
  80356e:	75 31                	jne    8035a1 <get_uvpt_entry+0xa9>
    return uvpt[VPT(va)];
  803570:	48 c1 ef 0c          	shr    $0xc,%rdi
  803574:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  80357b:	7f 00 00 
  80357e:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  803582:	c3                   	ret
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  803583:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  80358a:	7f 00 00 
  80358d:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  803591:	c3                   	ret
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  803592:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  803599:	7f 00 00 
  80359c:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8035a0:	c3                   	ret
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8035a1:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  8035a8:	7f 00 00 
  8035ab:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8035af:	c3                   	ret

00000000008035b0 <get_phys_addr>:

uintptr_t
get_phys_addr(void *va) {
  8035b0:	f3 0f 1e fa          	endbr64
  8035b4:	48 89 fa             	mov    %rdi,%rdx
    if (!(uvpml4[VPML4(va)] & PTE_P))
  8035b7:	48 89 f9             	mov    %rdi,%rcx
  8035ba:	48 c1 e9 27          	shr    $0x27,%rcx
  8035be:	48 b8 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rax
  8035c5:	7f 00 00 
  8035c8:	48 8b 0c c8          	mov    (%rax,%rcx,8),%rcx
        return -1;
  8035cc:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpml4[VPML4(va)] & PTE_P))
  8035d3:	f6 c1 01             	test   $0x1,%cl
  8035d6:	0f 84 b2 00 00 00    	je     80368e <get_phys_addr+0xde>
    if (!(uvpdp[VPDP(va)] & PTE_P))
  8035dc:	48 89 f9             	mov    %rdi,%rcx
  8035df:	48 c1 e9 1e          	shr    $0x1e,%rcx
  8035e3:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  8035ea:	7f 00 00 
  8035ed:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  8035f1:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpdp[VPDP(va)] & PTE_P))
  8035f8:	40 f6 c6 01          	test   $0x1,%sil
  8035fc:	0f 84 8c 00 00 00    	je     80368e <get_phys_addr+0xde>
    if (uvpdp[VPDP(va)] & PTE_PS)
  803602:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  803609:	7f 00 00 
  80360c:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  803610:	a8 80                	test   $0x80,%al
  803612:	75 7b                	jne    80368f <get_phys_addr+0xdf>
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
    if (!(uvpd[VPD(va)] & PTE_P))
  803614:	48 89 f9             	mov    %rdi,%rcx
  803617:	48 c1 e9 15          	shr    $0x15,%rcx
  80361b:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  803622:	7f 00 00 
  803625:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  803629:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpd[VPD(va)] & PTE_P))
  803630:	40 f6 c6 01          	test   $0x1,%sil
  803634:	74 58                	je     80368e <get_phys_addr+0xde>
    if ((uvpd[VPD(va)] & PTE_PS))
  803636:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  80363d:	7f 00 00 
  803640:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  803644:	a8 80                	test   $0x80,%al
  803646:	75 6c                	jne    8036b4 <get_phys_addr+0x104>
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
    if (!(uvpt[VPT(va)] & PTE_P))
  803648:	48 89 f9             	mov    %rdi,%rcx
  80364b:	48 c1 e9 0c          	shr    $0xc,%rcx
  80364f:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  803656:	7f 00 00 
  803659:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  80365d:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpt[VPT(va)] & PTE_P))
  803664:	40 f6 c6 01          	test   $0x1,%sil
  803668:	74 24                	je     80368e <get_phys_addr+0xde>
    return PTE_ADDR(uvpt[VPT(va)]) + PAGE_OFFSET(va);
  80366a:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  803671:	7f 00 00 
  803674:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  803678:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  80367f:	ff ff 7f 
  803682:	48 21 c8             	and    %rcx,%rax
  803685:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  80368b:	48 09 d0             	or     %rdx,%rax
}
  80368e:	c3                   	ret
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
  80368f:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  803696:	7f 00 00 
  803699:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  80369d:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  8036a4:	ff ff 7f 
  8036a7:	48 21 c8             	and    %rcx,%rax
  8036aa:	81 e2 ff ff ff 3f    	and    $0x3fffffff,%edx
  8036b0:	48 01 d0             	add    %rdx,%rax
  8036b3:	c3                   	ret
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
  8036b4:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  8036bb:	7f 00 00 
  8036be:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8036c2:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  8036c9:	ff ff 7f 
  8036cc:	48 21 c8             	and    %rcx,%rax
  8036cf:	81 e2 ff ff 1f 00    	and    $0x1fffff,%edx
  8036d5:	48 01 d0             	add    %rdx,%rax
  8036d8:	c3                   	ret

00000000008036d9 <get_prot>:

int
get_prot(void *va) {
  8036d9:	f3 0f 1e fa          	endbr64
  8036dd:	55                   	push   %rbp
  8036de:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  8036e1:	48 b8 f8 34 80 00 00 	movabs $0x8034f8,%rax
  8036e8:	00 00 00 
  8036eb:	ff d0                	call   *%rax
  8036ed:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
    if (pte & PTE_P) prot |= PROT_R;
  8036f0:	83 e0 01             	and    $0x1,%eax
  8036f3:	c1 e0 02             	shl    $0x2,%eax
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  8036f6:	89 d1                	mov    %edx,%ecx
  8036f8:	81 e1 00 0a 00 00    	and    $0xa00,%ecx
    if (pte & PTE_P) prot |= PROT_R;
  8036fe:	09 c8                	or     %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  803700:	89 c1                	mov    %eax,%ecx
  803702:	83 c9 02             	or     $0x2,%ecx
  803705:	f6 c2 02             	test   $0x2,%dl
  803708:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  80370b:	89 c1                	mov    %eax,%ecx
  80370d:	83 c9 01             	or     $0x1,%ecx
  803710:	48 85 d2             	test   %rdx,%rdx
  803713:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  803716:	89 c1                	mov    %eax,%ecx
  803718:	83 c9 40             	or     $0x40,%ecx
  80371b:	f6 c6 04             	test   $0x4,%dh
  80371e:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  803721:	5d                   	pop    %rbp
  803722:	c3                   	ret

0000000000803723 <is_page_dirty>:

bool
is_page_dirty(void *va) {
  803723:	f3 0f 1e fa          	endbr64
  803727:	55                   	push   %rbp
  803728:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  80372b:	48 b8 f8 34 80 00 00 	movabs $0x8034f8,%rax
  803732:	00 00 00 
  803735:	ff d0                	call   *%rax
    return pte & PTE_D;
  803737:	48 c1 e8 06          	shr    $0x6,%rax
  80373b:	83 e0 01             	and    $0x1,%eax
}
  80373e:	5d                   	pop    %rbp
  80373f:	c3                   	ret

0000000000803740 <is_page_present>:

bool
is_page_present(void *va) {
  803740:	f3 0f 1e fa          	endbr64
  803744:	55                   	push   %rbp
  803745:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  803748:	48 b8 f8 34 80 00 00 	movabs $0x8034f8,%rax
  80374f:	00 00 00 
  803752:	ff d0                	call   *%rax
  803754:	83 e0 01             	and    $0x1,%eax
}
  803757:	5d                   	pop    %rbp
  803758:	c3                   	ret

0000000000803759 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  803759:	f3 0f 1e fa          	endbr64
  80375d:	55                   	push   %rbp
  80375e:	48 89 e5             	mov    %rsp,%rbp
  803761:	41 57                	push   %r15
  803763:	41 56                	push   %r14
  803765:	41 55                	push   %r13
  803767:	41 54                	push   %r12
  803769:	53                   	push   %rbx
  80376a:	48 83 ec 18          	sub    $0x18,%rsp
  80376e:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  803772:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
     * NOTE: Skip over larger pages/page directories for efficiency */
    // LAB 11: Your code here:

    int res = 0;
    (void)fun, (void)arg;
    uintptr_t va = 0;
  803776:	bb 00 00 00 00       	mov    $0x0,%ebx
    while (va < USER_STACK_TOP) {
        size_t size = 0;
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  80377b:	49 be 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%r14
  803782:	7f 00 00 
            size = 1LL << PML4_SHIFT;
            goto next;
        }

        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  803785:	49 bd 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%r13
  80378c:	7f 00 00 
    while (va < USER_STACK_TOP) {
  80378f:	49 bf ff 6f ff ff 7f 	movabs $0x7fffff6fff,%r15
  803796:	00 00 00 
  803799:	eb 73                	jmp    80380e <foreach_shared_region+0xb5>
            }

            goto next;
        }

        if (!(uvpd[VPD(va)] & PTE_P)) {
  80379b:	48 89 d8             	mov    %rbx,%rax
  80379e:	48 c1 e8 15          	shr    $0x15,%rax
  8037a2:	48 b9 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rcx
  8037a9:	7f 00 00 
  8037ac:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
            size = 1LL << PD_SHIFT;
  8037b0:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
        if (!(uvpd[VPD(va)] & PTE_P)) {
  8037b6:	f6 c2 01             	test   $0x1,%dl
  8037b9:	74 4b                	je     803806 <foreach_shared_region+0xad>
            goto next;
        }

        if (uvpd[VPD(va)] & PTE_PS) {
  8037bb:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
  8037bf:	f6 c2 80             	test   $0x80,%dl
  8037c2:	74 11                	je     8037d5 <foreach_shared_region+0x7c>
            size = 1LL << PD_SHIFT;
            if (uvpd[VPD(va)] & PTE_SHARE) {
  8037c4:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
  8037c8:	f6 c4 04             	test   $0x4,%ah
  8037cb:	74 39                	je     803806 <foreach_shared_region+0xad>
            size = 1LL << PD_SHIFT;
  8037cd:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
  8037d3:	eb 20                	jmp    8037f5 <foreach_shared_region+0x9c>

            goto next;
        }

        size = PAGE_SIZE;
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  8037d5:	48 89 da             	mov    %rbx,%rdx
  8037d8:	48 c1 ea 0c          	shr    $0xc,%rdx
  8037dc:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  8037e3:	7f 00 00 
  8037e6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
        size = PAGE_SIZE;
  8037ea:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  8037f0:	f6 c4 04             	test   $0x4,%ah
  8037f3:	74 11                	je     803806 <foreach_shared_region+0xad>
            goto next;
        }

    map:
        fun((void *)va, (void *)(va + size), arg);
  8037f5:	49 8d 34 1c          	lea    (%r12,%rbx,1),%rsi
  8037f9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8037fd:	48 89 df             	mov    %rbx,%rdi
  803800:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803804:	ff d0                	call   *%rax
    next:
        va += size;
  803806:	4c 01 e3             	add    %r12,%rbx
    while (va < USER_STACK_TOP) {
  803809:	49 39 df             	cmp    %rbx,%r15
  80380c:	72 3e                	jb     80384c <foreach_shared_region+0xf3>
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  80380e:	49 8b 06             	mov    (%r14),%rax
  803811:	a8 01                	test   $0x1,%al
  803813:	74 37                	je     80384c <foreach_shared_region+0xf3>
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  803815:	48 89 d8             	mov    %rbx,%rax
  803818:	48 c1 e8 1e          	shr    $0x1e,%rax
  80381c:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
            size = 1LL << PDP_SHIFT;
  803821:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  803827:	f6 c2 01             	test   $0x1,%dl
  80382a:	74 da                	je     803806 <foreach_shared_region+0xad>
        if (uvpdp[VPDP(va)] & PTE_PS) {
  80382c:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
  803831:	f6 c2 80             	test   $0x80,%dl
  803834:	0f 84 61 ff ff ff    	je     80379b <foreach_shared_region+0x42>
            if (uvpdp[VPDP(va)] & PTE_SHARE) {
  80383a:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  80383f:	f6 c4 04             	test   $0x4,%ah
  803842:	74 c2                	je     803806 <foreach_shared_region+0xad>
            size = 1LL << PDP_SHIFT;
  803844:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
  80384a:	eb a9                	jmp    8037f5 <foreach_shared_region+0x9c>
    }
    return res;
}
  80384c:	b8 00 00 00 00       	mov    $0x0,%eax
  803851:	48 83 c4 18          	add    $0x18,%rsp
  803855:	5b                   	pop    %rbx
  803856:	41 5c                	pop    %r12
  803858:	41 5d                	pop    %r13
  80385a:	41 5e                	pop    %r14
  80385c:	41 5f                	pop    %r15
  80385e:	5d                   	pop    %rbp
  80385f:	c3                   	ret

0000000000803860 <devcons_close>:

    return res;
}

static int
devcons_close(struct Fd *fd) {
  803860:	f3 0f 1e fa          	endbr64
    USED(fd);

    return 0;
}
  803864:	b8 00 00 00 00       	mov    $0x0,%eax
  803869:	c3                   	ret

000000000080386a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  80386a:	f3 0f 1e fa          	endbr64
  80386e:	55                   	push   %rbp
  80386f:	48 89 e5             	mov    %rsp,%rbp
  803872:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  803875:	48 be 48 43 80 00 00 	movabs $0x804348,%rsi
  80387c:	00 00 00 
  80387f:	48 b8 67 18 80 00 00 	movabs $0x801867,%rax
  803886:	00 00 00 
  803889:	ff d0                	call   *%rax
    return 0;
}
  80388b:	b8 00 00 00 00       	mov    $0x0,%eax
  803890:	5d                   	pop    %rbp
  803891:	c3                   	ret

0000000000803892 <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  803892:	f3 0f 1e fa          	endbr64
  803896:	55                   	push   %rbp
  803897:	48 89 e5             	mov    %rsp,%rbp
  80389a:	41 57                	push   %r15
  80389c:	41 56                	push   %r14
  80389e:	41 55                	push   %r13
  8038a0:	41 54                	push   %r12
  8038a2:	53                   	push   %rbx
  8038a3:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  8038aa:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  8038b1:	48 85 d2             	test   %rdx,%rdx
  8038b4:	74 7a                	je     803930 <devcons_write+0x9e>
  8038b6:	49 89 d6             	mov    %rdx,%r14
  8038b9:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  8038bf:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  8038c4:	49 bf 82 1a 80 00 00 	movabs $0x801a82,%r15
  8038cb:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  8038ce:	4c 89 f3             	mov    %r14,%rbx
  8038d1:	48 29 f3             	sub    %rsi,%rbx
  8038d4:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8038d9:	48 39 c3             	cmp    %rax,%rbx
  8038dc:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  8038e0:	4c 63 eb             	movslq %ebx,%r13
  8038e3:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  8038ea:	48 01 c6             	add    %rax,%rsi
  8038ed:	4c 89 ea             	mov    %r13,%rdx
  8038f0:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  8038f7:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  8038fa:	4c 89 ee             	mov    %r13,%rsi
  8038fd:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  803904:	48 b8 c7 1c 80 00 00 	movabs $0x801cc7,%rax
  80390b:	00 00 00 
  80390e:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  803910:	41 01 dc             	add    %ebx,%r12d
  803913:	49 63 f4             	movslq %r12d,%rsi
  803916:	4c 39 f6             	cmp    %r14,%rsi
  803919:	72 b3                	jb     8038ce <devcons_write+0x3c>
    return res;
  80391b:	49 63 c4             	movslq %r12d,%rax
}
  80391e:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  803925:	5b                   	pop    %rbx
  803926:	41 5c                	pop    %r12
  803928:	41 5d                	pop    %r13
  80392a:	41 5e                	pop    %r14
  80392c:	41 5f                	pop    %r15
  80392e:	5d                   	pop    %rbp
  80392f:	c3                   	ret
    for (res = 0; res < n; res += inc) {
  803930:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  803936:	eb e3                	jmp    80391b <devcons_write+0x89>

0000000000803938 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  803938:	f3 0f 1e fa          	endbr64
  80393c:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  80393f:	ba 00 00 00 00       	mov    $0x0,%edx
  803944:	48 85 c0             	test   %rax,%rax
  803947:	74 55                	je     80399e <devcons_read+0x66>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  803949:	55                   	push   %rbp
  80394a:	48 89 e5             	mov    %rsp,%rbp
  80394d:	41 55                	push   %r13
  80394f:	41 54                	push   %r12
  803951:	53                   	push   %rbx
  803952:	48 83 ec 08          	sub    $0x8,%rsp
  803956:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  803959:	48 bb f8 1c 80 00 00 	movabs $0x801cf8,%rbx
  803960:	00 00 00 
  803963:	49 bc d1 1d 80 00 00 	movabs $0x801dd1,%r12
  80396a:	00 00 00 
  80396d:	eb 03                	jmp    803972 <devcons_read+0x3a>
  80396f:	41 ff d4             	call   *%r12
  803972:	ff d3                	call   *%rbx
  803974:	85 c0                	test   %eax,%eax
  803976:	74 f7                	je     80396f <devcons_read+0x37>
    if (c < 0) return c;
  803978:	48 63 d0             	movslq %eax,%rdx
  80397b:	78 13                	js     803990 <devcons_read+0x58>
    if (c == 0x04) return 0;
  80397d:	ba 00 00 00 00       	mov    $0x0,%edx
  803982:	83 f8 04             	cmp    $0x4,%eax
  803985:	74 09                	je     803990 <devcons_read+0x58>
    *(char *)vbuf = (char)c;
  803987:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  80398b:	ba 01 00 00 00       	mov    $0x1,%edx
}
  803990:	48 89 d0             	mov    %rdx,%rax
  803993:	48 83 c4 08          	add    $0x8,%rsp
  803997:	5b                   	pop    %rbx
  803998:	41 5c                	pop    %r12
  80399a:	41 5d                	pop    %r13
  80399c:	5d                   	pop    %rbp
  80399d:	c3                   	ret
  80399e:	48 89 d0             	mov    %rdx,%rax
  8039a1:	c3                   	ret

00000000008039a2 <cputchar>:
cputchar(int ch) {
  8039a2:	f3 0f 1e fa          	endbr64
  8039a6:	55                   	push   %rbp
  8039a7:	48 89 e5             	mov    %rsp,%rbp
  8039aa:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  8039ae:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  8039b2:	be 01 00 00 00       	mov    $0x1,%esi
  8039b7:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  8039bb:	48 b8 c7 1c 80 00 00 	movabs $0x801cc7,%rax
  8039c2:	00 00 00 
  8039c5:	ff d0                	call   *%rax
}
  8039c7:	c9                   	leave
  8039c8:	c3                   	ret

00000000008039c9 <getchar>:
getchar(void) {
  8039c9:	f3 0f 1e fa          	endbr64
  8039cd:	55                   	push   %rbp
  8039ce:	48 89 e5             	mov    %rsp,%rbp
  8039d1:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  8039d5:	ba 01 00 00 00       	mov    $0x1,%edx
  8039da:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  8039de:	bf 00 00 00 00       	mov    $0x0,%edi
  8039e3:	48 b8 d9 28 80 00 00 	movabs $0x8028d9,%rax
  8039ea:	00 00 00 
  8039ed:	ff d0                	call   *%rax
  8039ef:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  8039f1:	85 c0                	test   %eax,%eax
  8039f3:	78 06                	js     8039fb <getchar+0x32>
  8039f5:	74 08                	je     8039ff <getchar+0x36>
  8039f7:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  8039fb:	89 d0                	mov    %edx,%eax
  8039fd:	c9                   	leave
  8039fe:	c3                   	ret
    return res < 0 ? res : res ? c :
  8039ff:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  803a04:	eb f5                	jmp    8039fb <getchar+0x32>

0000000000803a06 <iscons>:
iscons(int fdnum) {
  803a06:	f3 0f 1e fa          	endbr64
  803a0a:	55                   	push   %rbp
  803a0b:	48 89 e5             	mov    %rsp,%rbp
  803a0e:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  803a12:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  803a16:	48 b8 de 25 80 00 00 	movabs $0x8025de,%rax
  803a1d:	00 00 00 
  803a20:	ff d0                	call   *%rax
    if (res < 0) return res;
  803a22:	85 c0                	test   %eax,%eax
  803a24:	78 18                	js     803a3e <iscons+0x38>
    return fd->fd_dev_id == devcons.dev_id;
  803a26:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803a2a:	48 b8 a0 50 80 00 00 	movabs $0x8050a0,%rax
  803a31:	00 00 00 
  803a34:	8b 00                	mov    (%rax),%eax
  803a36:	39 02                	cmp    %eax,(%rdx)
  803a38:	0f 94 c0             	sete   %al
  803a3b:	0f b6 c0             	movzbl %al,%eax
}
  803a3e:	c9                   	leave
  803a3f:	c3                   	ret

0000000000803a40 <opencons>:
opencons(void) {
  803a40:	f3 0f 1e fa          	endbr64
  803a44:	55                   	push   %rbp
  803a45:	48 89 e5             	mov    %rsp,%rbp
  803a48:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  803a4c:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  803a50:	48 b8 7a 25 80 00 00 	movabs $0x80257a,%rax
  803a57:	00 00 00 
  803a5a:	ff d0                	call   *%rax
  803a5c:	85 c0                	test   %eax,%eax
  803a5e:	78 49                	js     803aa9 <opencons+0x69>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  803a60:	b9 46 00 00 00       	mov    $0x46,%ecx
  803a65:	ba 00 10 00 00       	mov    $0x1000,%edx
  803a6a:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  803a6e:	bf 00 00 00 00       	mov    $0x0,%edi
  803a73:	48 b8 6c 1e 80 00 00 	movabs $0x801e6c,%rax
  803a7a:	00 00 00 
  803a7d:	ff d0                	call   *%rax
  803a7f:	85 c0                	test   %eax,%eax
  803a81:	78 26                	js     803aa9 <opencons+0x69>
    fd->fd_dev_id = devcons.dev_id;
  803a83:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803a87:	a1 a0 50 80 00 00 00 	movabs 0x8050a0,%eax
  803a8e:	00 00 
  803a90:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  803a92:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  803a96:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  803a9d:	48 b8 44 25 80 00 00 	movabs $0x802544,%rax
  803aa4:	00 00 00 
  803aa7:	ff d0                	call   *%rax
}
  803aa9:	c9                   	leave
  803aaa:	c3                   	ret

0000000000803aab <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  803aab:	f3 0f 1e fa          	endbr64
  803aaf:	55                   	push   %rbp
  803ab0:	48 89 e5             	mov    %rsp,%rbp
  803ab3:	41 54                	push   %r12
  803ab5:	53                   	push   %rbx
  803ab6:	48 89 fb             	mov    %rdi,%rbx
  803ab9:	48 89 f7             	mov    %rsi,%rdi
  803abc:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  803abf:	48 85 f6             	test   %rsi,%rsi
  803ac2:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  803ac9:	00 00 00 
  803acc:	48 0f 44 f8          	cmove  %rax,%rdi
    }
    int res = sys_ipc_recv(pg, PAGE_SIZE);
  803ad0:	be 00 10 00 00       	mov    $0x1000,%esi
  803ad5:	48 b8 8e 21 80 00 00 	movabs $0x80218e,%rax
  803adc:	00 00 00 
  803adf:	ff d0                	call   *%rax
    if (res < 0) {
  803ae1:	85 c0                	test   %eax,%eax
  803ae3:	78 45                	js     803b2a <ipc_recv+0x7f>
        if (perm_store != NULL) {
            *perm_store = 0;
        }
        return res;
    } else {
        if (from_env_store != NULL) {
  803ae5:	48 85 db             	test   %rbx,%rbx
  803ae8:	74 12                	je     803afc <ipc_recv+0x51>
            *from_env_store = thisenv->env_ipc_from;
  803aea:	48 a1 d0 61 80 00 00 	movabs 0x8061d0,%rax
  803af1:	00 00 00 
  803af4:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  803afa:	89 03                	mov    %eax,(%rbx)
        }
        if (perm_store != NULL) {
  803afc:	4d 85 e4             	test   %r12,%r12
  803aff:	74 14                	je     803b15 <ipc_recv+0x6a>
            *perm_store = thisenv->env_ipc_perm;
  803b01:	48 a1 d0 61 80 00 00 	movabs 0x8061d0,%rax
  803b08:	00 00 00 
  803b0b:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  803b11:	41 89 04 24          	mov    %eax,(%r12)
        }
        return thisenv->env_ipc_value;
  803b15:	48 a1 d0 61 80 00 00 	movabs 0x8061d0,%rax
  803b1c:	00 00 00 
  803b1f:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
    }
    return -1;
}
  803b25:	5b                   	pop    %rbx
  803b26:	41 5c                	pop    %r12
  803b28:	5d                   	pop    %rbp
  803b29:	c3                   	ret
        if (from_env_store != NULL) {
  803b2a:	48 85 db             	test   %rbx,%rbx
  803b2d:	74 06                	je     803b35 <ipc_recv+0x8a>
            *from_env_store = 0;
  803b2f:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store != NULL) {
  803b35:	4d 85 e4             	test   %r12,%r12
  803b38:	74 eb                	je     803b25 <ipc_recv+0x7a>
            *perm_store = 0;
  803b3a:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  803b41:	00 
  803b42:	eb e1                	jmp    803b25 <ipc_recv+0x7a>

0000000000803b44 <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  803b44:	f3 0f 1e fa          	endbr64
  803b48:	55                   	push   %rbp
  803b49:	48 89 e5             	mov    %rsp,%rbp
  803b4c:	41 57                	push   %r15
  803b4e:	41 56                	push   %r14
  803b50:	41 55                	push   %r13
  803b52:	41 54                	push   %r12
  803b54:	53                   	push   %rbx
  803b55:	48 83 ec 18          	sub    $0x18,%rsp
  803b59:	89 7d c4             	mov    %edi,-0x3c(%rbp)
  803b5c:	48 89 d3             	mov    %rdx,%rbx
  803b5f:	49 89 cc             	mov    %rcx,%r12
  803b62:	45 89 c5             	mov    %r8d,%r13d
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  803b65:	48 85 d2             	test   %rdx,%rdx
  803b68:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  803b6f:	00 00 00 
  803b72:	48 0f 44 d8          	cmove  %rax,%rbx
    }
    int res = sys_ipc_try_send(to_env, val, pg, size, perm);
  803b76:	89 f0                	mov    %esi,%eax
  803b78:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  803b7c:	48 89 da             	mov    %rbx,%rdx
  803b7f:	48 89 c6             	mov    %rax,%rsi
  803b82:	48 b8 5e 21 80 00 00 	movabs $0x80215e,%rax
  803b89:	00 00 00 
  803b8c:	ff d0                	call   *%rax
    while (res < 0) {
  803b8e:	85 c0                	test   %eax,%eax
  803b90:	79 65                	jns    803bf7 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  803b92:	83 f8 f5             	cmp    $0xfffffff5,%eax
  803b95:	75 33                	jne    803bca <ipc_send+0x86>
            panic("Error: %i\n", res);
        }
        sys_yield();
  803b97:	49 bf d1 1d 80 00 00 	movabs $0x801dd1,%r15
  803b9e:	00 00 00 
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  803ba1:	49 be 5e 21 80 00 00 	movabs $0x80215e,%r14
  803ba8:	00 00 00 
        sys_yield();
  803bab:	41 ff d7             	call   *%r15
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  803bae:	45 89 e8             	mov    %r13d,%r8d
  803bb1:	4c 89 e1             	mov    %r12,%rcx
  803bb4:	48 89 da             	mov    %rbx,%rdx
  803bb7:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  803bbb:	8b 7d c4             	mov    -0x3c(%rbp),%edi
  803bbe:	41 ff d6             	call   *%r14
    while (res < 0) {
  803bc1:	85 c0                	test   %eax,%eax
  803bc3:	79 32                	jns    803bf7 <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  803bc5:	83 f8 f5             	cmp    $0xfffffff5,%eax
  803bc8:	74 e1                	je     803bab <ipc_send+0x67>
            panic("Error: %i\n", res);
  803bca:	89 c1                	mov    %eax,%ecx
  803bcc:	48 ba 54 43 80 00 00 	movabs $0x804354,%rdx
  803bd3:	00 00 00 
  803bd6:	be 42 00 00 00       	mov    $0x42,%esi
  803bdb:	48 bf 5f 43 80 00 00 	movabs $0x80435f,%rdi
  803be2:	00 00 00 
  803be5:	b8 00 00 00 00       	mov    $0x0,%eax
  803bea:	49 b8 c2 0d 80 00 00 	movabs $0x800dc2,%r8
  803bf1:	00 00 00 
  803bf4:	41 ff d0             	call   *%r8
    }
}
  803bf7:	48 83 c4 18          	add    $0x18,%rsp
  803bfb:	5b                   	pop    %rbx
  803bfc:	41 5c                	pop    %r12
  803bfe:	41 5d                	pop    %r13
  803c00:	41 5e                	pop    %r14
  803c02:	41 5f                	pop    %r15
  803c04:	5d                   	pop    %rbp
  803c05:	c3                   	ret

0000000000803c06 <ipc_find_env>:

/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
  803c06:	f3 0f 1e fa          	endbr64
    for (size_t i = 0; i < NENV; i++)
  803c0a:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  803c0f:	48 b9 00 00 a0 1f 80 	movabs $0x801fa00000,%rcx
  803c16:	00 00 00 
  803c19:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  803c1d:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  803c21:	48 c1 e2 04          	shl    $0x4,%rdx
  803c25:	48 01 ca             	add    %rcx,%rdx
  803c28:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  803c2e:	39 fa                	cmp    %edi,%edx
  803c30:	74 12                	je     803c44 <ipc_find_env+0x3e>
    for (size_t i = 0; i < NENV; i++)
  803c32:	48 83 c0 01          	add    $0x1,%rax
  803c36:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  803c3c:	75 db                	jne    803c19 <ipc_find_env+0x13>
            return envs[i].env_id;
    return 0;
  803c3e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803c43:	c3                   	ret
            return envs[i].env_id;
  803c44:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  803c48:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  803c4c:	48 c1 e2 04          	shl    $0x4,%rdx
  803c50:	48 b8 00 00 a0 1f 80 	movabs $0x801fa00000,%rax
  803c57:	00 00 00 
  803c5a:	48 01 d0             	add    %rdx,%rax
  803c5d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803c63:	c3                   	ret

0000000000803c64 <__text_end>:
  803c64:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c6b:	00 00 00 
  803c6e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c75:	00 00 00 
  803c78:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c7f:	00 00 00 
  803c82:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c89:	00 00 00 
  803c8c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c93:	00 00 00 
  803c96:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803c9d:	00 00 00 
  803ca0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ca7:	00 00 00 
  803caa:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cb1:	00 00 00 
  803cb4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cbb:	00 00 00 
  803cbe:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cc5:	00 00 00 
  803cc8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ccf:	00 00 00 
  803cd2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cd9:	00 00 00 
  803cdc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ce3:	00 00 00 
  803ce6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ced:	00 00 00 
  803cf0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803cf7:	00 00 00 
  803cfa:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d01:	00 00 00 
  803d04:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d0b:	00 00 00 
  803d0e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d15:	00 00 00 
  803d18:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d1f:	00 00 00 
  803d22:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d29:	00 00 00 
  803d2c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d33:	00 00 00 
  803d36:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d3d:	00 00 00 
  803d40:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d47:	00 00 00 
  803d4a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d51:	00 00 00 
  803d54:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d5b:	00 00 00 
  803d5e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d65:	00 00 00 
  803d68:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d6f:	00 00 00 
  803d72:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d79:	00 00 00 
  803d7c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d83:	00 00 00 
  803d86:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d8d:	00 00 00 
  803d90:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803d97:	00 00 00 
  803d9a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803da1:	00 00 00 
  803da4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dab:	00 00 00 
  803dae:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803db5:	00 00 00 
  803db8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dbf:	00 00 00 
  803dc2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dc9:	00 00 00 
  803dcc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dd3:	00 00 00 
  803dd6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ddd:	00 00 00 
  803de0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803de7:	00 00 00 
  803dea:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803df1:	00 00 00 
  803df4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803dfb:	00 00 00 
  803dfe:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e05:	00 00 00 
  803e08:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e0f:	00 00 00 
  803e12:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e19:	00 00 00 
  803e1c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e23:	00 00 00 
  803e26:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e2d:	00 00 00 
  803e30:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e37:	00 00 00 
  803e3a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e41:	00 00 00 
  803e44:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e4b:	00 00 00 
  803e4e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e55:	00 00 00 
  803e58:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e5f:	00 00 00 
  803e62:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e69:	00 00 00 
  803e6c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e73:	00 00 00 
  803e76:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e7d:	00 00 00 
  803e80:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e87:	00 00 00 
  803e8a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e91:	00 00 00 
  803e94:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803e9b:	00 00 00 
  803e9e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ea5:	00 00 00 
  803ea8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803eaf:	00 00 00 
  803eb2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803eb9:	00 00 00 
  803ebc:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ec3:	00 00 00 
  803ec6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ecd:	00 00 00 
  803ed0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ed7:	00 00 00 
  803eda:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ee1:	00 00 00 
  803ee4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803eeb:	00 00 00 
  803eee:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ef5:	00 00 00 
  803ef8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803eff:	00 00 00 
  803f02:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f09:	00 00 00 
  803f0c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f13:	00 00 00 
  803f16:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f1d:	00 00 00 
  803f20:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f27:	00 00 00 
  803f2a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f31:	00 00 00 
  803f34:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f3b:	00 00 00 
  803f3e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f45:	00 00 00 
  803f48:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f4f:	00 00 00 
  803f52:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f59:	00 00 00 
  803f5c:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f63:	00 00 00 
  803f66:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f6d:	00 00 00 
  803f70:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f77:	00 00 00 
  803f7a:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f81:	00 00 00 
  803f84:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f8b:	00 00 00 
  803f8e:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f95:	00 00 00 
  803f98:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803f9f:	00 00 00 
  803fa2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fa9:	00 00 00 
  803fac:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fb3:	00 00 00 
  803fb6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fbd:	00 00 00 
  803fc0:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fc7:	00 00 00 
  803fca:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fd1:	00 00 00 
  803fd4:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fdb:	00 00 00 
  803fde:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fe5:	00 00 00 
  803fe8:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803fef:	00 00 00 
  803ff2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  803ff9:	00 00 00 
  803ffc:	0f 1f 40 00          	nopl   0x0(%rax)
