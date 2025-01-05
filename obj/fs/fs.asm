
obj/fs/fs:     file format elf64-x86-64


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
  80001e:	e8 c5 3b 00 00       	call   803be8 <libmain>
    jmp .
  800023:	eb fe                	jmp    800023 <args_exist+0x10>

0000000000800025 <bc_pgfault>:
}

/* Fault any disk block that is read in to memory by
 * loading it from disk. */
static bool
bc_pgfault(struct UTrapframe *utf) {
  800025:	f3 0f 1e fa          	endbr64
    void *addr = (void *)utf->utf_fault_va;
  800029:	48 8b 17             	mov    (%rdi),%rdx
    blockno_t blockno = ((uintptr_t)addr - (uintptr_t)DISKMAP) / BLKSIZE;
  80002c:	48 8d ba 00 00 00 f0 	lea    -0x10000000(%rdx),%rdi
    int res;

    /* Check that the fault was within the block cache region */
    if (addr < (void *)DISKMAP || addr >= (void *)(DISKMAP + DISKSIZE)) return 0;
  800033:	b8 ff ff ff bf       	mov    $0xbfffffff,%eax
  800038:	48 39 f8             	cmp    %rdi,%rax
  80003b:	0f 82 e8 00 00 00    	jb     800129 <bc_pgfault+0x104>
bc_pgfault(struct UTrapframe *utf) {
  800041:	55                   	push   %rbp
  800042:	48 89 e5             	mov    %rsp,%rbp
  800045:	41 54                	push   %r12
  800047:	53                   	push   %rbx
    blockno_t blockno = ((uintptr_t)addr - (uintptr_t)DISKMAP) / BLKSIZE;
  800048:	48 89 fb             	mov    %rdi,%rbx
  80004b:	48 c1 eb 0c          	shr    $0xc,%rbx

    /* Sanity check the block number. */
    if (super && blockno >= super->s_nblocks)
  80004f:	48 a1 08 d0 80 00 00 	movabs 0x80d008,%rax
  800056:	00 00 00 
  800059:	48 85 c0             	test   %rax,%rax
  80005c:	74 0f                	je     80006d <bc_pgfault+0x48>
    blockno_t blockno = ((uintptr_t)addr - (uintptr_t)DISKMAP) / BLKSIZE;
  80005e:	89 d9                	mov    %ebx,%ecx
    if (super && blockno >= super->s_nblocks)
  800060:	44 8b 40 04          	mov    0x4(%rax),%r8d
  800064:	44 39 c3             	cmp    %r8d,%ebx
  800067:	0f 83 91 00 00 00    	jae    8000fe <bc_pgfault+0xd9>
    /* Allocate a page in the disk map region, read the contents
     * of the block from the disk into that page.
     * Hint: first round addr to page boundary. fs/nvme.c has code to read
     * the disk. */
    // LAB 10: Your code here
    addr = (void *)((uintptr_t)addr & (~0xfff));
  80006d:	48 81 e2 00 f0 ff ff 	and    $0xfffffffffffff000,%rdx
  800074:	49 89 d4             	mov    %rdx,%r12
    res = sys_alloc_region(CURENVID, addr, BLKSIZE, PROT_RW);
  800077:	b9 06 00 00 00       	mov    $0x6,%ecx
  80007c:	ba 00 10 00 00       	mov    $0x1000,%edx
  800081:	4c 89 e6             	mov    %r12,%rsi
  800084:	bf 00 00 00 00       	mov    $0x0,%edi
  800089:	48 b8 6b 4d 80 00 00 	movabs $0x804d6b,%rax
  800090:	00 00 00 
  800093:	ff d0                	call   *%rax
  800095:	89 c2                	mov    %eax,%edx
    if (res < 0) {
        return 0;
  800097:	b8 00 00 00 00       	mov    $0x0,%eax
    if (res < 0) {
  80009c:	85 d2                	test   %edx,%edx
  80009e:	78 59                	js     8000f9 <bc_pgfault+0xd4>
    }
    ((char *)addr)[0] = 0;
  8000a0:	41 c6 04 24 00       	movb   $0x0,(%r12)
    res = nvme_read(blockno * BLKSECTS, addr, BLKSECTS);
  8000a5:	48 8d 3c dd 00 00 00 	lea    0x0(,%rbx,8),%rdi
  8000ac:	00 
  8000ad:	ba 08 00 00 00       	mov    $0x8,%edx
  8000b2:	4c 89 e6             	mov    %r12,%rsi
  8000b5:	48 b8 81 3b 80 00 00 	movabs $0x803b81,%rax
  8000bc:	00 00 00 
  8000bf:	ff d0                	call   *%rax
  8000c1:	89 c2                	mov    %eax,%edx
    if (res < 0) {
        return 0;
  8000c3:	b8 00 00 00 00       	mov    $0x0,%eax
    if (res < 0) {
  8000c8:	85 d2                	test   %edx,%edx
  8000ca:	78 2d                	js     8000f9 <bc_pgfault+0xd4>
    }
    res = sys_map_region(CURENVID, addr, CURENVID, addr, BLKSIZE, PROT_RW);
  8000cc:	41 b9 06 00 00 00    	mov    $0x6,%r9d
  8000d2:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8000d8:	4c 89 e1             	mov    %r12,%rcx
  8000db:	ba 00 00 00 00       	mov    $0x0,%edx
  8000e0:	4c 89 e6             	mov    %r12,%rsi
  8000e3:	bf 00 00 00 00       	mov    $0x0,%edi
  8000e8:	48 b8 d6 4d 80 00 00 	movabs $0x804dd6,%rax
  8000ef:	00 00 00 
  8000f2:	ff d0                	call   *%rax
    if (res < 0) {
  8000f4:	f7 d0                	not    %eax
  8000f6:	c1 e8 1f             	shr    $0x1f,%eax
        return 0;
    }
    return 1;
}
  8000f9:	5b                   	pop    %rbx
  8000fa:	41 5c                	pop    %r12
  8000fc:	5d                   	pop    %rbp
  8000fd:	c3                   	ret
        panic("reading non-existent block %08x out of %08x\n", blockno, super->s_nblocks);
  8000fe:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  800105:	00 00 00 
  800108:	be 1e 00 00 00       	mov    $0x1e,%esi
  80010d:	48 bf 6c 73 80 00 00 	movabs $0x80736c,%rdi
  800114:	00 00 00 
  800117:	b8 00 00 00 00       	mov    $0x0,%eax
  80011c:	49 b9 c1 3c 80 00 00 	movabs $0x803cc1,%r9
  800123:	00 00 00 
  800126:	41 ff d1             	call   *%r9
    if (addr < (void *)DISKMAP || addr >= (void *)(DISKMAP + DISKSIZE)) return 0;
  800129:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80012e:	c3                   	ret

000000000080012f <diskaddr>:
diskaddr(blockno_t blockno) {
  80012f:	f3 0f 1e fa          	endbr64
    if (blockno == 0 || (super && blockno >= super->s_nblocks))
  800133:	85 ff                	test   %edi,%edi
  800135:	74 21                	je     800158 <diskaddr+0x29>
  800137:	48 a1 08 d0 80 00 00 	movabs 0x80d008,%rax
  80013e:	00 00 00 
  800141:	48 85 c0             	test   %rax,%rax
  800144:	74 05                	je     80014b <diskaddr+0x1c>
  800146:	3b 78 04             	cmp    0x4(%rax),%edi
  800149:	73 0d                	jae    800158 <diskaddr+0x29>
    void *r = (void *)(uintptr_t)(DISKMAP + blockno * BLKSIZE);
  80014b:	89 f8                	mov    %edi,%eax
  80014d:	48 05 00 00 01 00    	add    $0x10000,%rax
  800153:	48 c1 e0 0c          	shl    $0xc,%rax
}
  800157:	c3                   	ret
diskaddr(blockno_t blockno) {
  800158:	55                   	push   %rbp
  800159:	48 89 e5             	mov    %rsp,%rbp
        panic("bad block number %08x in diskaddr", blockno);
  80015c:	89 f9                	mov    %edi,%ecx
  80015e:	48 ba 38 70 80 00 00 	movabs $0x807038,%rdx
  800165:	00 00 00 
  800168:	be 09 00 00 00       	mov    $0x9,%esi
  80016d:	48 bf 6c 73 80 00 00 	movabs $0x80736c,%rdi
  800174:	00 00 00 
  800177:	b8 00 00 00 00       	mov    $0x0,%eax
  80017c:	49 b8 c1 3c 80 00 00 	movabs $0x803cc1,%r8
  800183:	00 00 00 
  800186:	41 ff d0             	call   *%r8

0000000000800189 <flush_block>:
 * nothing.
 * Hint: Use is_page_present(), is_page_dirty(), and nvme_write().
 * Hint: Use the PTE_SYSCALL constant when calling sys_map_region().
 * Hint: Don't forget to round addr down. */
void
flush_block(void *addr) {
  800189:	f3 0f 1e fa          	endbr64
  80018d:	55                   	push   %rbp
  80018e:	48 89 e5             	mov    %rsp,%rbp
  800191:	41 54                	push   %r12
  800193:	53                   	push   %rbx
  800194:	48 89 fb             	mov    %rdi,%rbx
    blockno_t blockno = ((uintptr_t)addr - (uintptr_t)DISKMAP) / BLKSIZE;
  800197:	48 8d 87 00 00 00 f0 	lea    -0x10000000(%rdi),%rax
  80019e:	49 89 c4             	mov    %rax,%r12
  8001a1:	49 c1 ec 0c          	shr    $0xc,%r12
    int res;

    if (addr < (void *)(uintptr_t)DISKMAP || addr >= (void *)(uintptr_t)(DISKMAP + DISKSIZE))
  8001a5:	ba ff ff ff bf       	mov    $0xbfffffff,%edx
  8001aa:	48 39 c2             	cmp    %rax,%rdx
  8001ad:	72 3f                	jb     8001ee <flush_block+0x65>
  8001af:	44 89 e1             	mov    %r12d,%ecx
        panic("flush_block of bad va %p", addr);
    if (blockno && super && blockno >= super->s_nblocks)
  8001b2:	45 85 e4             	test   %r12d,%r12d
  8001b5:	74 18                	je     8001cf <flush_block+0x46>
  8001b7:	48 a1 08 d0 80 00 00 	movabs 0x80d008,%rax
  8001be:	00 00 00 
  8001c1:	48 85 c0             	test   %rax,%rax
  8001c4:	74 09                	je     8001cf <flush_block+0x46>
  8001c6:	44 8b 40 04          	mov    0x4(%rax),%r8d
  8001ca:	45 39 c4             	cmp    %r8d,%r12d
  8001cd:	73 4d                	jae    80021c <flush_block+0x93>
        panic("reading non-existent block %08x out of %08x\n", blockno, super->s_nblocks);

    // LAB 10: Your code here.
    addr = (void *)((uintptr_t)addr & (~0xfff));
  8001cf:	48 81 e3 00 f0 ff ff 	and    $0xfffffffffffff000,%rbx
    if (!is_page_present(addr) || !is_page_dirty(addr)) {
  8001d6:	48 89 df             	mov    %rbx,%rdi
  8001d9:	48 b8 f8 67 80 00 00 	movabs $0x8067f8,%rax
  8001e0:	00 00 00 
  8001e3:	ff d0                	call   *%rax
  8001e5:	84 c0                	test   %al,%al
  8001e7:	75 5e                	jne    800247 <flush_block+0xbe>
    }
    res = sys_map_region(CURENVID, addr, CURENVID, addr, BLKSIZE, PROT_RW);
    if (res < 0) {
        return;
    }
}
  8001e9:	5b                   	pop    %rbx
  8001ea:	41 5c                	pop    %r12
  8001ec:	5d                   	pop    %rbp
  8001ed:	c3                   	ret
        panic("flush_block of bad va %p", addr);
  8001ee:	48 89 f9             	mov    %rdi,%rcx
  8001f1:	48 ba 74 73 80 00 00 	movabs $0x807374,%rdx
  8001f8:	00 00 00 
  8001fb:	be 43 00 00 00       	mov    $0x43,%esi
  800200:	48 bf 6c 73 80 00 00 	movabs $0x80736c,%rdi
  800207:	00 00 00 
  80020a:	b8 00 00 00 00       	mov    $0x0,%eax
  80020f:	49 b8 c1 3c 80 00 00 	movabs $0x803cc1,%r8
  800216:	00 00 00 
  800219:	41 ff d0             	call   *%r8
        panic("reading non-existent block %08x out of %08x\n", blockno, super->s_nblocks);
  80021c:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  800223:	00 00 00 
  800226:	be 45 00 00 00       	mov    $0x45,%esi
  80022b:	48 bf 6c 73 80 00 00 	movabs $0x80736c,%rdi
  800232:	00 00 00 
  800235:	b8 00 00 00 00       	mov    $0x0,%eax
  80023a:	49 b9 c1 3c 80 00 00 	movabs $0x803cc1,%r9
  800241:	00 00 00 
  800244:	41 ff d1             	call   *%r9
    if (!is_page_present(addr) || !is_page_dirty(addr)) {
  800247:	48 89 df             	mov    %rbx,%rdi
  80024a:	48 b8 db 67 80 00 00 	movabs $0x8067db,%rax
  800251:	00 00 00 
  800254:	ff d0                	call   *%rax
  800256:	84 c0                	test   %al,%al
  800258:	74 8f                	je     8001e9 <flush_block+0x60>
    res = nvme_write(blockno * BLKSECTS, addr, BLKSECTS);
  80025a:	44 89 e7             	mov    %r12d,%edi
  80025d:	48 c1 e7 03          	shl    $0x3,%rdi
  800261:	ba 08 00 00 00       	mov    $0x8,%edx
  800266:	48 89 de             	mov    %rbx,%rsi
  800269:	48 b8 1a 3b 80 00 00 	movabs $0x803b1a,%rax
  800270:	00 00 00 
  800273:	ff d0                	call   *%rax
    if (res < 0) {
  800275:	85 c0                	test   %eax,%eax
  800277:	0f 88 6c ff ff ff    	js     8001e9 <flush_block+0x60>
    res = sys_map_region(CURENVID, addr, CURENVID, addr, BLKSIZE, PROT_RW);
  80027d:	41 b9 06 00 00 00    	mov    $0x6,%r9d
  800283:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  800289:	48 89 d9             	mov    %rbx,%rcx
  80028c:	ba 00 00 00 00       	mov    $0x0,%edx
  800291:	48 89 de             	mov    %rbx,%rsi
  800294:	bf 00 00 00 00       	mov    $0x0,%edi
  800299:	48 b8 d6 4d 80 00 00 	movabs $0x804dd6,%rax
  8002a0:	00 00 00 
  8002a3:	ff d0                	call   *%rax
        return;
  8002a5:	e9 3f ff ff ff       	jmp    8001e9 <flush_block+0x60>

00000000008002aa <bc_init>:

    cprintf("block cache is good\n");
}

void
bc_init(void) {
  8002aa:	f3 0f 1e fa          	endbr64
  8002ae:	55                   	push   %rbp
  8002af:	48 89 e5             	mov    %rsp,%rbp
  8002b2:	41 54                	push   %r12
  8002b4:	53                   	push   %rbx
  8002b5:	48 81 ec 10 02 00 00 	sub    $0x210,%rsp
    struct Super super;
    add_pgfault_handler(bc_pgfault);
  8002bc:	48 bf 25 00 80 00 00 	movabs $0x800025,%rdi
  8002c3:	00 00 00 
  8002c6:	48 b8 bd 51 80 00 00 	movabs $0x8051bd,%rax
  8002cd:	00 00 00 
  8002d0:	ff d0                	call   *%rax
    memmove(&backup, diskaddr(1), sizeof backup);
  8002d2:	bf 01 00 00 00       	mov    $0x1,%edi
  8002d7:	48 bb 2f 01 80 00 00 	movabs $0x80012f,%rbx
  8002de:	00 00 00 
  8002e1:	ff d3                	call   *%rbx
  8002e3:	48 89 c6             	mov    %rax,%rsi
  8002e6:	ba 08 01 00 00       	mov    $0x108,%edx
  8002eb:	48 8d bd e0 fd ff ff 	lea    -0x220(%rbp),%rdi
  8002f2:	48 b8 81 49 80 00 00 	movabs $0x804981,%rax
  8002f9:	00 00 00 
  8002fc:	ff d0                	call   *%rax
    strcpy(diskaddr(1), "OOPS!\n");
  8002fe:	bf 01 00 00 00       	mov    $0x1,%edi
  800303:	ff d3                	call   *%rbx
  800305:	48 89 c7             	mov    %rax,%rdi
  800308:	48 be 8d 73 80 00 00 	movabs $0x80738d,%rsi
  80030f:	00 00 00 
  800312:	48 b8 66 47 80 00 00 	movabs $0x804766,%rax
  800319:	00 00 00 
  80031c:	ff d0                	call   *%rax
    flush_block(diskaddr(1));
  80031e:	bf 01 00 00 00       	mov    $0x1,%edi
  800323:	ff d3                	call   *%rbx
  800325:	48 89 c7             	mov    %rax,%rdi
  800328:	48 b8 89 01 80 00 00 	movabs $0x800189,%rax
  80032f:	00 00 00 
  800332:	ff d0                	call   *%rax
    assert(is_page_present(diskaddr(1)));
  800334:	bf 01 00 00 00       	mov    $0x1,%edi
  800339:	ff d3                	call   *%rbx
  80033b:	48 89 c7             	mov    %rax,%rdi
  80033e:	48 b8 f8 67 80 00 00 	movabs $0x8067f8,%rax
  800345:	00 00 00 
  800348:	ff d0                	call   *%rax
  80034a:	84 c0                	test   %al,%al
  80034c:	0f 84 25 01 00 00    	je     800477 <bc_init+0x1cd>
    assert(!is_page_dirty(diskaddr(1)));
  800352:	bf 01 00 00 00       	mov    $0x1,%edi
  800357:	48 b8 2f 01 80 00 00 	movabs $0x80012f,%rax
  80035e:	00 00 00 
  800361:	ff d0                	call   *%rax
  800363:	48 89 c7             	mov    %rax,%rdi
  800366:	48 b8 db 67 80 00 00 	movabs $0x8067db,%rax
  80036d:	00 00 00 
  800370:	ff d0                	call   *%rax
  800372:	84 c0                	test   %al,%al
  800374:	0f 85 2d 01 00 00    	jne    8004a7 <bc_init+0x1fd>
    sys_unmap_region(0, diskaddr(1), PAGE_SIZE);
  80037a:	bf 01 00 00 00       	mov    $0x1,%edi
  80037f:	48 bb 2f 01 80 00 00 	movabs $0x80012f,%rbx
  800386:	00 00 00 
  800389:	ff d3                	call   *%rbx
  80038b:	48 89 c6             	mov    %rax,%rsi
  80038e:	ba 00 10 00 00       	mov    $0x1000,%edx
  800393:	bf 00 00 00 00       	mov    $0x0,%edi
  800398:	48 b8 ab 4e 80 00 00 	movabs $0x804eab,%rax
  80039f:	00 00 00 
  8003a2:	ff d0                	call   *%rax
    assert(!is_page_present(diskaddr(1)));
  8003a4:	bf 01 00 00 00       	mov    $0x1,%edi
  8003a9:	ff d3                	call   *%rbx
  8003ab:	48 89 c7             	mov    %rax,%rdi
  8003ae:	48 b8 f8 67 80 00 00 	movabs $0x8067f8,%rax
  8003b5:	00 00 00 
  8003b8:	ff d0                	call   *%rax
  8003ba:	84 c0                	test   %al,%al
  8003bc:	0f 85 1a 01 00 00    	jne    8004dc <bc_init+0x232>
    assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  8003c2:	bf 01 00 00 00       	mov    $0x1,%edi
  8003c7:	48 b8 2f 01 80 00 00 	movabs $0x80012f,%rax
  8003ce:	00 00 00 
  8003d1:	ff d0                	call   *%rax
  8003d3:	48 89 c7             	mov    %rax,%rdi
  8003d6:	48 be 8d 73 80 00 00 	movabs $0x80738d,%rsi
  8003dd:	00 00 00 
  8003e0:	48 b8 1a 48 80 00 00 	movabs $0x80481a,%rax
  8003e7:	00 00 00 
  8003ea:	ff d0                	call   *%rax
  8003ec:	85 c0                	test   %eax,%eax
  8003ee:	0f 85 1d 01 00 00    	jne    800511 <bc_init+0x267>
    memmove(diskaddr(1), &backup, sizeof backup);
  8003f4:	bf 01 00 00 00       	mov    $0x1,%edi
  8003f9:	48 bb 2f 01 80 00 00 	movabs $0x80012f,%rbx
  800400:	00 00 00 
  800403:	ff d3                	call   *%rbx
  800405:	48 89 c7             	mov    %rax,%rdi
  800408:	ba 08 01 00 00       	mov    $0x108,%edx
  80040d:	48 8d b5 e0 fd ff ff 	lea    -0x220(%rbp),%rsi
  800414:	49 bc 81 49 80 00 00 	movabs $0x804981,%r12
  80041b:	00 00 00 
  80041e:	41 ff d4             	call   *%r12
    flush_block(diskaddr(1));
  800421:	bf 01 00 00 00       	mov    $0x1,%edi
  800426:	ff d3                	call   *%rbx
  800428:	48 89 c7             	mov    %rax,%rdi
  80042b:	48 b8 89 01 80 00 00 	movabs $0x800189,%rax
  800432:	00 00 00 
  800435:	ff d0                	call   *%rax
    cprintf("block cache is good\n");
  800437:	48 bf e3 73 80 00 00 	movabs $0x8073e3,%rdi
  80043e:	00 00 00 
  800441:	b8 00 00 00 00       	mov    $0x0,%eax
  800446:	48 ba 1d 3e 80 00 00 	movabs $0x803e1d,%rdx
  80044d:	00 00 00 
  800450:	ff d2                	call   *%rdx
    check_bc();

    /* Cache the super block by reading it once */
    memmove(&super, diskaddr(1), sizeof super);
  800452:	bf 01 00 00 00       	mov    $0x1,%edi
  800457:	ff d3                	call   *%rbx
  800459:	48 89 c6             	mov    %rax,%rsi
  80045c:	ba 08 01 00 00       	mov    $0x108,%edx
  800461:	48 8d bd e8 fe ff ff 	lea    -0x118(%rbp),%rdi
  800468:	41 ff d4             	call   *%r12
}
  80046b:	48 81 c4 10 02 00 00 	add    $0x210,%rsp
  800472:	5b                   	pop    %rbx
  800473:	41 5c                	pop    %r12
  800475:	5d                   	pop    %rbp
  800476:	c3                   	ret
    assert(is_page_present(diskaddr(1)));
  800477:	48 b9 c6 73 80 00 00 	movabs $0x8073c6,%rcx
  80047e:	00 00 00 
  800481:	48 ba 94 73 80 00 00 	movabs $0x807394,%rdx
  800488:	00 00 00 
  80048b:	be 62 00 00 00       	mov    $0x62,%esi
  800490:	48 bf 6c 73 80 00 00 	movabs $0x80736c,%rdi
  800497:	00 00 00 
  80049a:	49 b8 c1 3c 80 00 00 	movabs $0x803cc1,%r8
  8004a1:	00 00 00 
  8004a4:	41 ff d0             	call   *%r8
    assert(!is_page_dirty(diskaddr(1)));
  8004a7:	48 b9 a9 73 80 00 00 	movabs $0x8073a9,%rcx
  8004ae:	00 00 00 
  8004b1:	48 ba 94 73 80 00 00 	movabs $0x807394,%rdx
  8004b8:	00 00 00 
  8004bb:	be 63 00 00 00       	mov    $0x63,%esi
  8004c0:	48 bf 6c 73 80 00 00 	movabs $0x80736c,%rdi
  8004c7:	00 00 00 
  8004ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8004cf:	49 b8 c1 3c 80 00 00 	movabs $0x803cc1,%r8
  8004d6:	00 00 00 
  8004d9:	41 ff d0             	call   *%r8
    assert(!is_page_present(diskaddr(1)));
  8004dc:	48 b9 c5 73 80 00 00 	movabs $0x8073c5,%rcx
  8004e3:	00 00 00 
  8004e6:	48 ba 94 73 80 00 00 	movabs $0x807394,%rdx
  8004ed:	00 00 00 
  8004f0:	be 67 00 00 00       	mov    $0x67,%esi
  8004f5:	48 bf 6c 73 80 00 00 	movabs $0x80736c,%rdi
  8004fc:	00 00 00 
  8004ff:	b8 00 00 00 00       	mov    $0x0,%eax
  800504:	49 b8 c1 3c 80 00 00 	movabs $0x803cc1,%r8
  80050b:	00 00 00 
  80050e:	41 ff d0             	call   *%r8
    assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  800511:	48 b9 60 70 80 00 00 	movabs $0x807060,%rcx
  800518:	00 00 00 
  80051b:	48 ba 94 73 80 00 00 	movabs $0x807394,%rdx
  800522:	00 00 00 
  800525:	be 6a 00 00 00       	mov    $0x6a,%esi
  80052a:	48 bf 6c 73 80 00 00 	movabs $0x80736c,%rdi
  800531:	00 00 00 
  800534:	b8 00 00 00 00       	mov    $0x0,%eax
  800539:	49 b8 c1 3c 80 00 00 	movabs $0x803cc1,%r8
  800540:	00 00 00 
  800543:	41 ff d0             	call   *%r8

0000000000800546 <check_super>:
 *                         Super block
 ****************************************************************/

/* Validate the file system super-block. */
void
check_super(void) {
  800546:	f3 0f 1e fa          	endbr64
  80054a:	55                   	push   %rbp
  80054b:	48 89 e5             	mov    %rsp,%rbp
    if (super->s_magic != FS_MAGIC)
  80054e:	48 a1 08 d0 80 00 00 	movabs 0x80d008,%rax
  800555:	00 00 00 
  800558:	8b 08                	mov    (%rax),%ecx
  80055a:	81 f9 ae 30 05 4a    	cmp    $0x4a0530ae,%ecx
  800560:	75 26                	jne    800588 <check_super+0x42>
        panic("bad file system magic number %08x", super->s_magic);

    if (super->s_nblocks > DISKSIZE / BLKSIZE)
  800562:	81 78 04 00 00 0c 00 	cmpl   $0xc0000,0x4(%rax)
  800569:	77 48                	ja     8005b3 <check_super+0x6d>
        panic("file system is too large");

    cprintf("superblock is good\n");
  80056b:	48 bf 19 74 80 00 00 	movabs $0x807419,%rdi
  800572:	00 00 00 
  800575:	b8 00 00 00 00       	mov    $0x0,%eax
  80057a:	48 ba 1d 3e 80 00 00 	movabs $0x803e1d,%rdx
  800581:	00 00 00 
  800584:	ff d2                	call   *%rdx
}
  800586:	5d                   	pop    %rbp
  800587:	c3                   	ret
        panic("bad file system magic number %08x", super->s_magic);
  800588:	48 ba 88 70 80 00 00 	movabs $0x807088,%rdx
  80058f:	00 00 00 
  800592:	be 13 00 00 00       	mov    $0x13,%esi
  800597:	48 bf f8 73 80 00 00 	movabs $0x8073f8,%rdi
  80059e:	00 00 00 
  8005a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8005a6:	49 b8 c1 3c 80 00 00 	movabs $0x803cc1,%r8
  8005ad:	00 00 00 
  8005b0:	41 ff d0             	call   *%r8
        panic("file system is too large");
  8005b3:	48 ba 00 74 80 00 00 	movabs $0x807400,%rdx
  8005ba:	00 00 00 
  8005bd:	be 16 00 00 00       	mov    $0x16,%esi
  8005c2:	48 bf f8 73 80 00 00 	movabs $0x8073f8,%rdi
  8005c9:	00 00 00 
  8005cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8005d1:	48 b9 c1 3c 80 00 00 	movabs $0x803cc1,%rcx
  8005d8:	00 00 00 
  8005db:	ff d1                	call   *%rcx

00000000008005dd <block_is_free>:
 ****************************************************************/

/* Check to see if the block bitmap indicates that block 'blockno' is free.
 * Return 1 if the block is free, 0 if not. */
bool
block_is_free(blockno_t blockno) {
  8005dd:	f3 0f 1e fa          	endbr64
    if (super == 0 || blockno >= super->s_nblocks) return 0;
  8005e1:	48 a1 08 d0 80 00 00 	movabs 0x80d008,%rax
  8005e8:	00 00 00 
  8005eb:	48 85 c0             	test   %rax,%rax
  8005ee:	74 2d                	je     80061d <block_is_free+0x40>
  8005f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8005f5:	3b 78 04             	cmp    0x4(%rax),%edi
  8005f8:	73 20                	jae    80061a <block_is_free+0x3d>
    if (TSTBIT(bitmap, blockno)) return 1;
  8005fa:	89 fe                	mov    %edi,%esi
  8005fc:	c1 ee 05             	shr    $0x5,%esi
  8005ff:	89 f6                	mov    %esi,%esi
  800601:	ba 01 00 00 00       	mov    $0x1,%edx
  800606:	89 f9                	mov    %edi,%ecx
  800608:	d3 e2                	shl    %cl,%edx
  80060a:	48 a1 00 d0 80 00 00 	movabs 0x80d000,%rax
  800611:	00 00 00 
  800614:	23 14 b0             	and    (%rax,%rsi,4),%edx
  800617:	0f 95 c2             	setne  %dl
    return 0;
}
  80061a:	89 d0                	mov    %edx,%eax
  80061c:	c3                   	ret
    if (super == 0 || blockno >= super->s_nblocks) return 0;
  80061d:	ba 00 00 00 00       	mov    $0x0,%edx
  800622:	eb f6                	jmp    80061a <block_is_free+0x3d>

0000000000800624 <free_block>:

/* Mark a block free in the bitmap */
void
free_block(blockno_t blockno) {
  800624:	f3 0f 1e fa          	endbr64
    /* Blockno zero is the null pointer of block numbers. */
    if (blockno == 0) panic("attempt to free zero block");
  800628:	85 ff                	test   %edi,%edi
  80062a:	74 1e                	je     80064a <free_block+0x26>
    SETBIT(bitmap, blockno);
  80062c:	89 fa                	mov    %edi,%edx
  80062e:	c1 ea 05             	shr    $0x5,%edx
  800631:	89 d2                	mov    %edx,%edx
  800633:	48 a1 00 d0 80 00 00 	movabs 0x80d000,%rax
  80063a:	00 00 00 
  80063d:	be 01 00 00 00       	mov    $0x1,%esi
  800642:	89 f9                	mov    %edi,%ecx
  800644:	d3 e6                	shl    %cl,%esi
  800646:	09 34 90             	or     %esi,(%rax,%rdx,4)
  800649:	c3                   	ret
free_block(blockno_t blockno) {
  80064a:	55                   	push   %rbp
  80064b:	48 89 e5             	mov    %rsp,%rbp
    if (blockno == 0) panic("attempt to free zero block");
  80064e:	48 ba 2d 74 80 00 00 	movabs $0x80742d,%rdx
  800655:	00 00 00 
  800658:	be 2c 00 00 00       	mov    $0x2c,%esi
  80065d:	48 bf f8 73 80 00 00 	movabs $0x8073f8,%rdi
  800664:	00 00 00 
  800667:	b8 00 00 00 00       	mov    $0x0,%eax
  80066c:	48 b9 c1 3c 80 00 00 	movabs $0x803cc1,%rcx
  800673:	00 00 00 
  800676:	ff d1                	call   *%rcx

0000000000800678 <alloc_block>:
 * Return block number allocated on success,
 * 0 if we are out of blocks.
 *
 * Hint: use free_block as an example for manipulating the bitmap. */
blockno_t
alloc_block(void) {
  800678:	f3 0f 1e fa          	endbr64
  80067c:	55                   	push   %rbp
  80067d:	48 89 e5             	mov    %rsp,%rbp
  800680:	41 56                	push   %r14
  800682:	41 55                	push   %r13
  800684:	41 54                	push   %r12
  800686:	53                   	push   %rbx
    /* The bitmap consists of one or more blocks.  A single bitmap block
     * contains the in-use bits for BLKBITSIZE blocks.  There are
     * super->s_nblocks blocks in the disk altogether. */

    // LAB 10: Your code here
    for (int i = 2; i < super->s_nblocks; i++) {
  800687:	48 a1 08 d0 80 00 00 	movabs 0x80d008,%rax
  80068e:	00 00 00 
  800691:	44 8b 60 04          	mov    0x4(%rax),%r12d
  800695:	41 83 fc 02          	cmp    $0x2,%r12d
  800699:	76 7b                	jbe    800716 <alloc_block+0x9e>
  80069b:	bb 02 00 00 00       	mov    $0x2,%ebx
        if (block_is_free(i)) {
  8006a0:	49 be dd 05 80 00 00 	movabs $0x8005dd,%r14
  8006a7:	00 00 00 
  8006aa:	41 89 dd             	mov    %ebx,%r13d
  8006ad:	89 df                	mov    %ebx,%edi
  8006af:	41 ff d6             	call   *%r14
  8006b2:	84 c0                	test   %al,%al
  8006b4:	75 10                	jne    8006c6 <alloc_block+0x4e>
    for (int i = 2; i < super->s_nblocks; i++) {
  8006b6:	83 c3 01             	add    $0x1,%ebx
  8006b9:	41 39 dc             	cmp    %ebx,%r12d
  8006bc:	75 ec                	jne    8006aa <alloc_block+0x32>
            CLRBIT(bitmap, i);
            flush_block(diskaddr(2));
            return i;
        }
    }
    return 0;
  8006be:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  8006c4:	eb 44                	jmp    80070a <alloc_block+0x92>
            CLRBIT(bitmap, i);
  8006c6:	8d 53 1f             	lea    0x1f(%rbx),%edx
  8006c9:	85 db                	test   %ebx,%ebx
  8006cb:	0f 49 d3             	cmovns %ebx,%edx
  8006ce:	c1 fa 05             	sar    $0x5,%edx
  8006d1:	48 63 d2             	movslq %edx,%rdx
  8006d4:	48 a1 00 d0 80 00 00 	movabs 0x80d000,%rax
  8006db:	00 00 00 
  8006de:	be fe ff ff ff       	mov    $0xfffffffe,%esi
  8006e3:	89 d9                	mov    %ebx,%ecx
  8006e5:	d3 c6                	rol    %cl,%esi
  8006e7:	21 34 90             	and    %esi,(%rax,%rdx,4)
            flush_block(diskaddr(2));
  8006ea:	bf 02 00 00 00       	mov    $0x2,%edi
  8006ef:	48 b8 2f 01 80 00 00 	movabs $0x80012f,%rax
  8006f6:	00 00 00 
  8006f9:	ff d0                	call   *%rax
  8006fb:	48 89 c7             	mov    %rax,%rdi
  8006fe:	48 b8 89 01 80 00 00 	movabs $0x800189,%rax
  800705:	00 00 00 
  800708:	ff d0                	call   *%rax
}
  80070a:	44 89 e8             	mov    %r13d,%eax
  80070d:	5b                   	pop    %rbx
  80070e:	41 5c                	pop    %r12
  800710:	41 5d                	pop    %r13
  800712:	41 5e                	pop    %r14
  800714:	5d                   	pop    %rbp
  800715:	c3                   	ret
    return 0;
  800716:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  80071c:	eb ec                	jmp    80070a <alloc_block+0x92>

000000000080071e <check_bitmap>:
/* Validate the file system bitmap.
 *
 * Check that all reserved blocks -- 0, 1, and the bitmap blocks themselves --
 * are all marked as in-use. */
void
check_bitmap(void) {
  80071e:	f3 0f 1e fa          	endbr64
  800722:	55                   	push   %rbp
  800723:	48 89 e5             	mov    %rsp,%rbp
  800726:	41 55                	push   %r13
  800728:	41 54                	push   %r12
  80072a:	53                   	push   %rbx
  80072b:	48 83 ec 08          	sub    $0x8,%rsp

    /* Make sure all bitmap blocks are marked in-use */
    for (blockno_t i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  80072f:	48 a1 08 d0 80 00 00 	movabs 0x80d008,%rax
  800736:	00 00 00 
  800739:	8b 40 04             	mov    0x4(%rax),%eax
  80073c:	85 c0                	test   %eax,%eax
  80073e:	74 2a                	je     80076a <check_bitmap+0x4c>
  800740:	41 89 c4             	mov    %eax,%r12d
  800743:	bb 00 00 00 00       	mov    $0x0,%ebx
        assert(!block_is_free(2 + i));
  800748:	49 bd dd 05 80 00 00 	movabs $0x8005dd,%r13
  80074f:	00 00 00 
  800752:	8d 7b 02             	lea    0x2(%rbx),%edi
  800755:	41 ff d5             	call   *%r13
  800758:	84 c0                	test   %al,%al
  80075a:	75 62                	jne    8007be <check_bitmap+0xa0>
    for (blockno_t i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  80075c:	83 c3 01             	add    $0x1,%ebx
  80075f:	89 d8                	mov    %ebx,%eax
  800761:	48 c1 e0 0f          	shl    $0xf,%rax
  800765:	4c 39 e0             	cmp    %r12,%rax
  800768:	7c e8                	jl     800752 <check_bitmap+0x34>

    /* Make sure the reserved and root blocks are marked in-use. */

    assert(!block_is_free(1));
  80076a:	bf 01 00 00 00       	mov    $0x1,%edi
  80076f:	48 b8 dd 05 80 00 00 	movabs $0x8005dd,%rax
  800776:	00 00 00 
  800779:	ff d0                	call   *%rax
  80077b:	84 c0                	test   %al,%al
  80077d:	75 74                	jne    8007f3 <check_bitmap+0xd5>
    assert(!block_is_free(0));
  80077f:	bf 00 00 00 00       	mov    $0x0,%edi
  800784:	48 b8 dd 05 80 00 00 	movabs $0x8005dd,%rax
  80078b:	00 00 00 
  80078e:	ff d0                	call   *%rax
  800790:	84 c0                	test   %al,%al
  800792:	0f 85 90 00 00 00    	jne    800828 <check_bitmap+0x10a>

    cprintf("bitmap is good\n");
  800798:	48 bf 82 74 80 00 00 	movabs $0x807482,%rdi
  80079f:	00 00 00 
  8007a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8007a7:	48 ba 1d 3e 80 00 00 	movabs $0x803e1d,%rdx
  8007ae:	00 00 00 
  8007b1:	ff d2                	call   *%rdx
}
  8007b3:	48 83 c4 08          	add    $0x8,%rsp
  8007b7:	5b                   	pop    %rbx
  8007b8:	41 5c                	pop    %r12
  8007ba:	41 5d                	pop    %r13
  8007bc:	5d                   	pop    %rbp
  8007bd:	c3                   	ret
        assert(!block_is_free(2 + i));
  8007be:	48 b9 48 74 80 00 00 	movabs $0x807448,%rcx
  8007c5:	00 00 00 
  8007c8:	48 ba 94 73 80 00 00 	movabs $0x807394,%rdx
  8007cf:	00 00 00 
  8007d2:	be 52 00 00 00       	mov    $0x52,%esi
  8007d7:	48 bf f8 73 80 00 00 	movabs $0x8073f8,%rdi
  8007de:	00 00 00 
  8007e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8007e6:	49 b8 c1 3c 80 00 00 	movabs $0x803cc1,%r8
  8007ed:	00 00 00 
  8007f0:	41 ff d0             	call   *%r8
    assert(!block_is_free(1));
  8007f3:	48 b9 5e 74 80 00 00 	movabs $0x80745e,%rcx
  8007fa:	00 00 00 
  8007fd:	48 ba 94 73 80 00 00 	movabs $0x807394,%rdx
  800804:	00 00 00 
  800807:	be 56 00 00 00       	mov    $0x56,%esi
  80080c:	48 bf f8 73 80 00 00 	movabs $0x8073f8,%rdi
  800813:	00 00 00 
  800816:	b8 00 00 00 00       	mov    $0x0,%eax
  80081b:	49 b8 c1 3c 80 00 00 	movabs $0x803cc1,%r8
  800822:	00 00 00 
  800825:	41 ff d0             	call   *%r8
    assert(!block_is_free(0));
  800828:	48 b9 70 74 80 00 00 	movabs $0x807470,%rcx
  80082f:	00 00 00 
  800832:	48 ba 94 73 80 00 00 	movabs $0x807394,%rdx
  800839:	00 00 00 
  80083c:	be 57 00 00 00       	mov    $0x57,%esi
  800841:	48 bf f8 73 80 00 00 	movabs $0x8073f8,%rdi
  800848:	00 00 00 
  80084b:	b8 00 00 00 00       	mov    $0x0,%eax
  800850:	49 b8 c1 3c 80 00 00 	movabs $0x803cc1,%r8
  800857:	00 00 00 
  80085a:	41 ff d0             	call   *%r8

000000000080085d <fs_init>:
 *                    File system structures
 ****************************************************************/

/* Initialize the file system */
void
fs_init(void) {
  80085d:	f3 0f 1e fa          	endbr64
  800861:	55                   	push   %rbp
  800862:	48 89 e5             	mov    %rsp,%rbp
  800865:	53                   	push   %rbx
  800866:	48 83 ec 08          	sub    $0x8,%rsp
    static_assert(sizeof(struct File) == 256, "Unsupported file size");

    bc_init();
  80086a:	48 b8 aa 02 80 00 00 	movabs $0x8002aa,%rax
  800871:	00 00 00 
  800874:	ff d0                	call   *%rax

    /* Set "super" to point to the super block. */
    super = diskaddr(1);
  800876:	bf 01 00 00 00       	mov    $0x1,%edi
  80087b:	48 bb 2f 01 80 00 00 	movabs $0x80012f,%rbx
  800882:	00 00 00 
  800885:	ff d3                	call   *%rbx
  800887:	48 a3 08 d0 80 00 00 	movabs %rax,0x80d008
  80088e:	00 00 00 
    check_super();
  800891:	48 b8 46 05 80 00 00 	movabs $0x800546,%rax
  800898:	00 00 00 
  80089b:	ff d0                	call   *%rax

    /* Set "bitmap" to the beginning of the first bitmap block. */
    bitmap = diskaddr(2);
  80089d:	bf 02 00 00 00       	mov    $0x2,%edi
  8008a2:	ff d3                	call   *%rbx
  8008a4:	48 a3 00 d0 80 00 00 	movabs %rax,0x80d000
  8008ab:	00 00 00 

    check_bitmap();
  8008ae:	48 b8 1e 07 80 00 00 	movabs $0x80071e,%rax
  8008b5:	00 00 00 
  8008b8:	ff d0                	call   *%rax
}
  8008ba:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8008be:	c9                   	leave
  8008bf:	c3                   	ret

00000000008008c0 <file_block_walk>:
 *  -E_INVAL if filebno is out of range (it's >= NDIRECT + NINDIRECT).
 *
 * Analogy: This is like pgdir_walk for files.
 * Hint: Don't forget to clear any block you allocate. */
int
file_block_walk(struct File *f, blockno_t filebno, blockno_t **ppdiskbno, bool alloc) {
  8008c0:	f3 0f 1e fa          	endbr64
  8008c4:	55                   	push   %rbp
  8008c5:	48 89 e5             	mov    %rsp,%rbp
  8008c8:	41 55                	push   %r13
  8008ca:	41 54                	push   %r12
  8008cc:	53                   	push   %rbx
  8008cd:	48 83 ec 08          	sub    $0x8,%rsp
  8008d1:	49 89 fc             	mov    %rdi,%r12
  8008d4:	89 f3                	mov    %esi,%ebx
  8008d6:	49 89 d5             	mov    %rdx,%r13
    // LAB 10: Your code here

     *ppdiskbno = NULL;
  8008d9:	48 c7 02 00 00 00 00 	movq   $0x0,(%rdx)
    if (filebno < NDIRECT) {
  8008e0:	83 fe 09             	cmp    $0x9,%esi
  8008e3:	0f 86 8b 00 00 00    	jbe    800974 <file_block_walk+0xb4>
        *ppdiskbno = (uint32_t *)f->f_direct + filebno;
        return 0;
    }
    if (filebno >= NDIRECT + NINDIRECT) {
  8008e9:	81 fe 09 04 00 00    	cmp    $0x409,%esi
  8008ef:	0f 87 93 00 00 00    	ja     800988 <file_block_walk+0xc8>
        return -E_INVAL;
    }
    if (!f->f_indirect) {
  8008f5:	83 bf b0 00 00 00 00 	cmpl   $0x0,0xb0(%rdi)
  8008fc:	75 47                	jne    800945 <file_block_walk+0x85>
        if (!alloc) {
  8008fe:	84 c9                	test   %cl,%cl
  800900:	0f 84 89 00 00 00    	je     80098f <file_block_walk+0xcf>
            return -E_NOT_FOUND;
        }
        if (!(f->f_indirect = alloc_block())) {
  800906:	48 b8 78 06 80 00 00 	movabs $0x800678,%rax
  80090d:	00 00 00 
  800910:	ff d0                	call   *%rax
  800912:	89 c7                	mov    %eax,%edi
  800914:	41 89 84 24 b0 00 00 	mov    %eax,0xb0(%r12)
  80091b:	00 
  80091c:	85 c0                	test   %eax,%eax
  80091e:	74 76                	je     800996 <file_block_walk+0xd6>
            return -E_NO_DISK;
        }
        memset(diskaddr(f->f_indirect), 0, BLKSIZE);
  800920:	48 b8 2f 01 80 00 00 	movabs $0x80012f,%rax
  800927:	00 00 00 
  80092a:	ff d0                	call   *%rax
  80092c:	48 89 c7             	mov    %rax,%rdi
  80092f:	ba 00 10 00 00       	mov    $0x1000,%edx
  800934:	be 00 00 00 00       	mov    $0x0,%esi
  800939:	48 b8 c7 48 80 00 00 	movabs $0x8048c7,%rax
  800940:	00 00 00 
  800943:	ff d0                	call   *%rax
    }
    blockno_t *ind_block = (blockno_t *)diskaddr(f->f_indirect);
  800945:	41 8b bc 24 b0 00 00 	mov    0xb0(%r12),%edi
  80094c:	00 
  80094d:	48 b8 2f 01 80 00 00 	movabs $0x80012f,%rax
  800954:	00 00 00 
  800957:	ff d0                	call   *%rax
    *ppdiskbno = &ind_block[filebno - NDIRECT];
  800959:	8d 53 f6             	lea    -0xa(%rbx),%edx
  80095c:	48 8d 04 90          	lea    (%rax,%rdx,4),%rax
  800960:	49 89 45 00          	mov    %rax,0x0(%r13)
    return 0;
  800964:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800969:	48 83 c4 08          	add    $0x8,%rsp
  80096d:	5b                   	pop    %rbx
  80096e:	41 5c                	pop    %r12
  800970:	41 5d                	pop    %r13
  800972:	5d                   	pop    %rbp
  800973:	c3                   	ret
        *ppdiskbno = (uint32_t *)f->f_direct + filebno;
  800974:	89 f3                	mov    %esi,%ebx
  800976:	48 8d 84 9f 88 00 00 	lea    0x88(%rdi,%rbx,4),%rax
  80097d:	00 
  80097e:	48 89 02             	mov    %rax,(%rdx)
        return 0;
  800981:	b8 00 00 00 00       	mov    $0x0,%eax
  800986:	eb e1                	jmp    800969 <file_block_walk+0xa9>
        return -E_INVAL;
  800988:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80098d:	eb da                	jmp    800969 <file_block_walk+0xa9>
            return -E_NOT_FOUND;
  80098f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800994:	eb d3                	jmp    800969 <file_block_walk+0xa9>
            return -E_NO_DISK;
  800996:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80099b:	eb cc                	jmp    800969 <file_block_walk+0xa9>

000000000080099d <file_get_block>:
 *  -E_NO_DISK if a block needed to be allocated but the disk is full.
 *  -E_INVAL if filebno is out of range.
 *
 * Hint: Use file_block_walk and alloc_block. */
int
file_get_block(struct File *f, blockno_t filebno, char **blk) {
  80099d:	f3 0f 1e fa          	endbr64
  8009a1:	55                   	push   %rbp
  8009a2:	48 89 e5             	mov    %rsp,%rbp
  8009a5:	41 54                	push   %r12
  8009a7:	53                   	push   %rbx
  8009a8:	48 83 ec 10          	sub    $0x10,%rsp
  8009ac:	48 89 d3             	mov    %rdx,%rbx
    int res;
    // LAB 10: Your code here

    *blk = NULL;
  8009af:	48 c7 02 00 00 00 00 	movq   $0x0,(%rdx)
    blockno_t *blkno = 0;
    res = file_block_walk(f, filebno, &blkno, true);
  8009b6:	b9 01 00 00 00       	mov    $0x1,%ecx
  8009bb:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8009bf:	48 b8 c0 08 80 00 00 	movabs $0x8008c0,%rax
  8009c6:	00 00 00 
  8009c9:	ff d0                	call   *%rax
    if (res < 0) {
  8009cb:	85 c0                	test   %eax,%eax
  8009cd:	78 20                	js     8009ef <file_get_block+0x52>
        return res;
    }
    if (!(*blkno)) {
  8009cf:	4c 8b 65 e8          	mov    -0x18(%rbp),%r12
  8009d3:	41 8b 3c 24          	mov    (%r12),%edi
  8009d7:	85 ff                	test   %edi,%edi
  8009d9:	74 1d                	je     8009f8 <file_get_block+0x5b>
        *blkno = alloc_block();
    }
    if (!(*blkno)) {
        return -E_NO_DISK;
    }
    *blk = (char *)diskaddr(*blkno);
  8009db:	48 b8 2f 01 80 00 00 	movabs $0x80012f,%rax
  8009e2:	00 00 00 
  8009e5:	ff d0                	call   *%rax
  8009e7:	48 89 03             	mov    %rax,(%rbx)
    return 0;
  8009ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009ef:	48 83 c4 10          	add    $0x10,%rsp
  8009f3:	5b                   	pop    %rbx
  8009f4:	41 5c                	pop    %r12
  8009f6:	5d                   	pop    %rbp
  8009f7:	c3                   	ret
        *blkno = alloc_block();
  8009f8:	48 b8 78 06 80 00 00 	movabs $0x800678,%rax
  8009ff:	00 00 00 
  800a02:	ff d0                	call   *%rax
  800a04:	89 c7                	mov    %eax,%edi
  800a06:	41 89 04 24          	mov    %eax,(%r12)
    if (!(*blkno)) {
  800a0a:	85 c0                	test   %eax,%eax
  800a0c:	75 cd                	jne    8009db <file_get_block+0x3e>
        return -E_NO_DISK;
  800a0e:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  800a13:	eb da                	jmp    8009ef <file_get_block+0x52>

0000000000800a15 <walk_path>:
 * and set *pdir to the directory the file is in.
 * If we cannot find the file but find the directory
 * it should be in, set *pdir and copy the final path
 * element into lastelem. */
static int
walk_path(const char *path, struct File **pdir, struct File **pf, char *lastelem) {
  800a15:	f3 0f 1e fa          	endbr64
  800a19:	55                   	push   %rbp
  800a1a:	48 89 e5             	mov    %rsp,%rbp
  800a1d:	41 57                	push   %r15
  800a1f:	41 56                	push   %r14
  800a21:	41 55                	push   %r13
  800a23:	41 54                	push   %r12
  800a25:	53                   	push   %rbx
  800a26:	48 81 ec c8 00 00 00 	sub    $0xc8,%rsp
  800a2d:	48 89 d3             	mov    %rdx,%rbx
  800a30:	49 89 cd             	mov    %rcx,%r13
    while (*p == '/')
  800a33:	80 3f 2f             	cmpb   $0x2f,(%rdi)
  800a36:	75 09                	jne    800a41 <walk_path+0x2c>
        p++;
  800a38:	48 83 c7 01          	add    $0x1,%rdi
    while (*p == '/')
  800a3c:	80 3f 2f             	cmpb   $0x2f,(%rdi)
  800a3f:	74 f7                	je     800a38 <walk_path+0x23>
    int r;

    // if (*path != '/')
    //     return -E_BAD_PATH;
    path = skip_slash(path);
    f = &super->s_root;
  800a41:	48 a1 08 d0 80 00 00 	movabs 0x80d008,%rax
  800a48:	00 00 00 
  800a4b:	4c 8d 78 08          	lea    0x8(%rax),%r15
    dir = 0;
    name[0] = 0;
  800a4f:	c6 85 50 ff ff ff 00 	movb   $0x0,-0xb0(%rbp)

    if (pdir)
  800a56:	48 85 f6             	test   %rsi,%rsi
  800a59:	74 07                	je     800a62 <walk_path+0x4d>
        *pdir = 0;
  800a5b:	48 c7 06 00 00 00 00 	movq   $0x0,(%rsi)
    *pf = 0;
  800a62:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
    dir = 0;
  800a69:	ba 00 00 00 00       	mov    $0x0,%edx
            if (strcmp(f[j].f_name, name) == 0) {
  800a6e:	49 be 1a 48 80 00 00 	movabs $0x80481a,%r14
  800a75:	00 00 00 
  800a78:	48 89 b5 18 ff ff ff 	mov    %rsi,-0xe8(%rbp)
  800a7f:	48 89 fe             	mov    %rdi,%rsi
  800a82:	4c 89 ad 10 ff ff ff 	mov    %r13,-0xf0(%rbp)
    while (*path != '\0') {
  800a89:	e9 90 00 00 00       	jmp    800b1e <walk_path+0x109>
        dir = f;
        p = path;
        while (*path != '/' && *path != '\0')
  800a8e:	49 89 f4             	mov    %rsi,%r12
            path++;
        if (path - p >= MAXNAMELEN)
  800a91:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  800a97:	e9 b9 00 00 00       	jmp    800b55 <walk_path+0x140>
    while (*p == '/')
  800a9c:	4c 89 e6             	mov    %r12,%rsi
  800a9f:	e9 e9 00 00 00       	jmp    800b8d <walk_path+0x178>
    assert((dir->f_size % BLKSIZE) == 0);
  800aa4:	48 b9 92 74 80 00 00 	movabs $0x807492,%rcx
  800aab:	00 00 00 
  800aae:	48 ba 94 73 80 00 00 	movabs $0x807394,%rdx
  800ab5:	00 00 00 
  800ab8:	be c1 00 00 00       	mov    $0xc1,%esi
  800abd:	48 bf f8 73 80 00 00 	movabs $0x8073f8,%rdi
  800ac4:	00 00 00 
  800ac7:	b8 00 00 00 00       	mov    $0x0,%eax
  800acc:	49 b8 c1 3c 80 00 00 	movabs $0x803cc1,%r8
  800ad3:	00 00 00 
  800ad6:	41 ff d0             	call   *%r8
  800ad9:	48 8b b5 28 ff ff ff 	mov    -0xd8(%rbp),%rsi
  800ae0:	48 8b 9d 20 ff ff ff 	mov    -0xe0(%rbp),%rbx
  800ae7:	4c 89 bd 38 ff ff ff 	mov    %r15,-0xc8(%rbp)
  800aee:	eb 1c                	jmp    800b0c <walk_path+0xf7>
    for (blockno_t i = 0; i < nblock; i++) {
  800af0:	4c 89 bd 38 ff ff ff 	mov    %r15,-0xc8(%rbp)
    return -E_NOT_FOUND;
  800af7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800afc:	eb 0e                	jmp    800b0c <walk_path+0xf7>
  800afe:	48 8b b5 28 ff ff ff 	mov    -0xd8(%rbp),%rsi
  800b05:	48 8b 9d 20 ff ff ff 	mov    -0xe0(%rbp),%rbx
        dir = f;
  800b0c:	4c 89 fa             	mov    %r15,%rdx
        path = skip_slash(path);

        if (dir->f_type != FTYPE_DIR)
            return -E_NOT_FOUND;

        if ((r = dir_lookup(dir, name, &f)) < 0) {
  800b0f:	85 c0                	test   %eax,%eax
  800b11:	0f 88 48 01 00 00    	js     800c5f <walk_path+0x24a>
  800b17:	4c 8b bd 38 ff ff ff 	mov    -0xc8(%rbp),%r15
    while (*path != '\0') {
  800b1e:	0f b6 06             	movzbl (%rsi),%eax
  800b21:	84 c0                	test   %al,%al
  800b23:	0f 84 80 01 00 00    	je     800ca9 <walk_path+0x294>
        while (*path != '/' && *path != '\0')
  800b29:	3c 2f                	cmp    $0x2f,%al
  800b2b:	0f 84 5d ff ff ff    	je     800a8e <walk_path+0x79>
  800b31:	49 89 f4             	mov    %rsi,%r12
            path++;
  800b34:	49 83 c4 01          	add    $0x1,%r12
        while (*path != '/' && *path != '\0')
  800b38:	41 0f b6 04 24       	movzbl (%r12),%eax
  800b3d:	3c 2f                	cmp    $0x2f,%al
  800b3f:	74 04                	je     800b45 <walk_path+0x130>
  800b41:	84 c0                	test   %al,%al
  800b43:	75 ef                	jne    800b34 <walk_path+0x11f>
        if (path - p >= MAXNAMELEN)
  800b45:	4d 89 e5             	mov    %r12,%r13
  800b48:	49 29 f5             	sub    %rsi,%r13
  800b4b:	49 83 fd 7f          	cmp    $0x7f,%r13
  800b4f:	0f 8f 81 01 00 00    	jg     800cd6 <walk_path+0x2c1>
        memmove(name, p, path - p);
  800b55:	4c 89 ea             	mov    %r13,%rdx
  800b58:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  800b5f:	48 b8 81 49 80 00 00 	movabs $0x804981,%rax
  800b66:	00 00 00 
  800b69:	ff d0                	call   *%rax
        name[path - p] = '\0';
  800b6b:	42 c6 84 2d 50 ff ff 	movb   $0x0,-0xb0(%rbp,%r13,1)
  800b72:	ff 00 
    while (*p == '/')
  800b74:	41 80 3c 24 2f       	cmpb   $0x2f,(%r12)
  800b79:	0f 85 1d ff ff ff    	jne    800a9c <walk_path+0x87>
        p++;
  800b7f:	49 83 c4 01          	add    $0x1,%r12
    while (*p == '/')
  800b83:	41 80 3c 24 2f       	cmpb   $0x2f,(%r12)
  800b88:	74 f5                	je     800b7f <walk_path+0x16a>
  800b8a:	4c 89 e6             	mov    %r12,%rsi
        if (dir->f_type != FTYPE_DIR)
  800b8d:	41 83 bf 84 00 00 00 	cmpl   $0x1,0x84(%r15)
  800b94:	01 
  800b95:	0f 85 43 01 00 00    	jne    800cde <walk_path+0x2c9>
    assert((dir->f_size % BLKSIZE) == 0);
  800b9b:	41 8b 97 80 00 00 00 	mov    0x80(%r15),%edx
  800ba2:	f7 c2 ff 0f 00 00    	test   $0xfff,%edx
  800ba8:	0f 85 f6 fe ff ff    	jne    800aa4 <walk_path+0x8f>
    blockno_t nblock = dir->f_size / BLKSIZE;
  800bae:	8d 82 ff 0f 00 00    	lea    0xfff(%rdx),%eax
  800bb4:	85 d2                	test   %edx,%edx
  800bb6:	0f 49 c2             	cmovns %edx,%eax
    for (blockno_t i = 0; i < nblock; i++) {
  800bb9:	c1 f8 0c             	sar    $0xc,%eax
  800bbc:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%rbp)
  800bc2:	0f 84 28 ff ff ff    	je     800af0 <walk_path+0xdb>
  800bc8:	41 bc 00 00 00 00    	mov    $0x0,%r12d
            if (strcmp(f[j].f_name, name) == 0) {
  800bce:	48 89 b5 28 ff ff ff 	mov    %rsi,-0xd8(%rbp)
  800bd5:	48 89 9d 20 ff ff ff 	mov    %rbx,-0xe0(%rbp)
        int res = file_get_block(dir, i, &blk);
  800bdc:	48 8d 95 48 ff ff ff 	lea    -0xb8(%rbp),%rdx
  800be3:	44 89 e6             	mov    %r12d,%esi
  800be6:	4c 89 ff             	mov    %r15,%rdi
  800be9:	48 b8 9d 09 80 00 00 	movabs $0x80099d,%rax
  800bf0:	00 00 00 
  800bf3:	ff d0                	call   *%rax
        if (res < 0) return res;
  800bf5:	85 c0                	test   %eax,%eax
  800bf7:	0f 88 dc fe ff ff    	js     800ad9 <walk_path+0xc4>
        for (blockno_t j = 0; j < BLKFILES; j++)
  800bfd:	48 8b 9d 48 ff ff ff 	mov    -0xb8(%rbp),%rbx
  800c04:	4c 8d ab 00 10 00 00 	lea    0x1000(%rbx),%r13
            if (strcmp(f[j].f_name, name) == 0) {
  800c0b:	48 89 9d 38 ff ff ff 	mov    %rbx,-0xc8(%rbp)
  800c12:	48 8d b5 50 ff ff ff 	lea    -0xb0(%rbp),%rsi
  800c19:	48 89 df             	mov    %rbx,%rdi
  800c1c:	41 ff d6             	call   *%r14
  800c1f:	85 c0                	test   %eax,%eax
  800c21:	0f 84 d7 fe ff ff    	je     800afe <walk_path+0xe9>
        for (blockno_t j = 0; j < BLKFILES; j++)
  800c27:	48 81 c3 00 01 00 00 	add    $0x100,%rbx
  800c2e:	4c 39 eb             	cmp    %r13,%rbx
  800c31:	75 d8                	jne    800c0b <walk_path+0x1f6>
    for (blockno_t i = 0; i < nblock; i++) {
  800c33:	41 83 c4 01          	add    $0x1,%r12d
  800c37:	44 39 a5 34 ff ff ff 	cmp    %r12d,-0xcc(%rbp)
  800c3e:	75 9c                	jne    800bdc <walk_path+0x1c7>
  800c40:	48 8b b5 28 ff ff ff 	mov    -0xd8(%rbp),%rsi
  800c47:	48 8b 9d 20 ff ff ff 	mov    -0xe0(%rbp),%rbx
  800c4e:	4c 89 bd 38 ff ff ff 	mov    %r15,-0xc8(%rbp)
    return -E_NOT_FOUND;
  800c55:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800c5a:	e9 ad fe ff ff       	jmp    800b0c <walk_path+0xf7>
            if (r == -E_NOT_FOUND && *path == '\0') {
  800c5f:	41 89 c4             	mov    %eax,%r12d
  800c62:	48 89 f7             	mov    %rsi,%rdi
  800c65:	48 8b b5 18 ff ff ff 	mov    -0xe8(%rbp),%rsi
  800c6c:	4c 8b ad 10 ff ff ff 	mov    -0xf0(%rbp),%r13
  800c73:	83 f8 f1             	cmp    $0xfffffff1,%eax
  800c76:	75 49                	jne    800cc1 <walk_path+0x2ac>
  800c78:	80 3f 00             	cmpb   $0x0,(%rdi)
  800c7b:	75 44                	jne    800cc1 <walk_path+0x2ac>
                if (pdir)
  800c7d:	48 85 f6             	test   %rsi,%rsi
  800c80:	74 03                	je     800c85 <walk_path+0x270>
                    *pdir = dir;
  800c82:	4c 89 3e             	mov    %r15,(%rsi)
                if (lastelem)
  800c85:	4d 85 ed             	test   %r13,%r13
  800c88:	74 16                	je     800ca0 <walk_path+0x28b>
                    strcpy(lastelem, name);
  800c8a:	48 8d b5 50 ff ff ff 	lea    -0xb0(%rbp),%rsi
  800c91:	4c 89 ef             	mov    %r13,%rdi
  800c94:	48 b8 66 47 80 00 00 	movabs $0x804766,%rax
  800c9b:	00 00 00 
  800c9e:	ff d0                	call   *%rax
                *pf = 0;
  800ca0:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
  800ca7:	eb 18                	jmp    800cc1 <walk_path+0x2ac>
            }
            return r;
        }
    }

    if (pdir)
  800ca9:	48 8b b5 18 ff ff ff 	mov    -0xe8(%rbp),%rsi
  800cb0:	48 85 f6             	test   %rsi,%rsi
  800cb3:	74 03                	je     800cb8 <walk_path+0x2a3>
        *pdir = dir;
  800cb5:	48 89 16             	mov    %rdx,(%rsi)
    *pf = f;
  800cb8:	4c 89 3b             	mov    %r15,(%rbx)
    return 0;
  800cbb:	41 bc 00 00 00 00    	mov    $0x0,%r12d
}
  800cc1:	44 89 e0             	mov    %r12d,%eax
  800cc4:	48 81 c4 c8 00 00 00 	add    $0xc8,%rsp
  800ccb:	5b                   	pop    %rbx
  800ccc:	41 5c                	pop    %r12
  800cce:	41 5d                	pop    %r13
  800cd0:	41 5e                	pop    %r14
  800cd2:	41 5f                	pop    %r15
  800cd4:	5d                   	pop    %rbp
  800cd5:	c3                   	ret
            return -E_BAD_PATH;
  800cd6:	41 bc f0 ff ff ff    	mov    $0xfffffff0,%r12d
  800cdc:	eb e3                	jmp    800cc1 <walk_path+0x2ac>
            return -E_NOT_FOUND;
  800cde:	41 bc f1 ff ff ff    	mov    $0xfffffff1,%r12d
  800ce4:	eb db                	jmp    800cc1 <walk_path+0x2ac>

0000000000800ce6 <file_open>:
}

/* Open "path".  On success set *pf to point at the file and return 0.
 * On error return < 0. */
int
file_open(const char *path, struct File **pf) {
  800ce6:	f3 0f 1e fa          	endbr64
  800cea:	55                   	push   %rbp
  800ceb:	48 89 e5             	mov    %rsp,%rbp
  800cee:	48 89 f2             	mov    %rsi,%rdx
    return walk_path(path, 0, pf, 0);
  800cf1:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cf6:	be 00 00 00 00       	mov    $0x0,%esi
  800cfb:	48 b8 15 0a 80 00 00 	movabs $0x800a15,%rax
  800d02:	00 00 00 
  800d05:	ff d0                	call   *%rax
}
  800d07:	5d                   	pop    %rbp
  800d08:	c3                   	ret

0000000000800d09 <file_read>:

/* Read count bytes from f into buf, starting from seek position
 * offset.  This meant to mimic the standard pread function.
 * Returns the number of bytes read, < 0 on error. */
ssize_t
file_read(struct File *f, void *buf, size_t count, off_t offset) {
  800d09:	f3 0f 1e fa          	endbr64
  800d0d:	55                   	push   %rbp
  800d0e:	48 89 e5             	mov    %rsp,%rbp
  800d11:	41 57                	push   %r15
  800d13:	41 56                	push   %r14
  800d15:	41 55                	push   %r13
  800d17:	41 54                	push   %r12
  800d19:	53                   	push   %rbx
  800d1a:	48 83 ec 28          	sub    $0x28,%rsp
  800d1e:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
  800d22:	89 cb                	mov    %ecx,%ebx
    char *blk;

    if (offset >= f->f_size)
  800d24:	8b 8f 80 00 00 00    	mov    0x80(%rdi),%ecx
        return 0;
  800d2a:	b8 00 00 00 00       	mov    $0x0,%eax
    if (offset >= f->f_size)
  800d2f:	39 d9                	cmp    %ebx,%ecx
  800d31:	0f 8e 9c 00 00 00    	jle    800dd3 <file_read+0xca>
  800d37:	49 89 f5             	mov    %rsi,%r13

    count = MIN(count, f->f_size - offset);
  800d3a:	29 d9                	sub    %ebx,%ecx
  800d3c:	48 63 c9             	movslq %ecx,%rcx
  800d3f:	48 39 d1             	cmp    %rdx,%rcx
  800d42:	48 0f 46 d1          	cmovbe %rcx,%rdx
  800d46:	48 89 55 b0          	mov    %rdx,-0x50(%rbp)

    for (off_t pos = offset; pos < offset + count;) {
  800d4a:	4c 63 f3             	movslq %ebx,%r14
  800d4d:	4e 8d 3c 32          	lea    (%rdx,%r14,1),%r15
  800d51:	4d 39 fe             	cmp    %r15,%r14
  800d54:	73 79                	jae    800dcf <file_read+0xc6>
        int r = file_get_block(f, pos / BLKSIZE, &blk);
  800d56:	8d b3 ff 0f 00 00    	lea    0xfff(%rbx),%esi
  800d5c:	85 db                	test   %ebx,%ebx
  800d5e:	0f 49 f3             	cmovns %ebx,%esi
  800d61:	c1 fe 0c             	sar    $0xc,%esi
  800d64:	48 8d 55 c8          	lea    -0x38(%rbp),%rdx
  800d68:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  800d6c:	48 b8 9d 09 80 00 00 	movabs $0x80099d,%rax
  800d73:	00 00 00 
  800d76:	ff d0                	call   *%rax
        if (r < 0) return r;
  800d78:	85 c0                	test   %eax,%eax
  800d7a:	78 66                	js     800de2 <file_read+0xd9>

        int bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  800d7c:	89 d8                	mov    %ebx,%eax
  800d7e:	c1 f8 1f             	sar    $0x1f,%eax
  800d81:	c1 e8 14             	shr    $0x14,%eax
  800d84:	8d 34 03             	lea    (%rbx,%rax,1),%esi
  800d87:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
  800d8d:	29 c6                	sub    %eax,%esi
  800d8f:	48 63 f6             	movslq %esi,%rsi
  800d92:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
  800d98:	49 29 f4             	sub    %rsi,%r12
  800d9b:	4c 89 f8             	mov    %r15,%rax
  800d9e:	4c 29 f0             	sub    %r14,%rax
  800da1:	49 39 c4             	cmp    %rax,%r12
  800da4:	4c 0f 47 e0          	cmova  %rax,%r12
        memmove(buf, blk + pos % BLKSIZE, bn);
  800da8:	4d 63 f4             	movslq %r12d,%r14
  800dab:	48 03 75 c8          	add    -0x38(%rbp),%rsi
  800daf:	4c 89 f2             	mov    %r14,%rdx
  800db2:	4c 89 ef             	mov    %r13,%rdi
  800db5:	48 b8 81 49 80 00 00 	movabs $0x804981,%rax
  800dbc:	00 00 00 
  800dbf:	ff d0                	call   *%rax
        pos += bn;
  800dc1:	44 01 e3             	add    %r12d,%ebx
        buf += bn;
  800dc4:	4d 01 f5             	add    %r14,%r13
    for (off_t pos = offset; pos < offset + count;) {
  800dc7:	4c 63 f3             	movslq %ebx,%r14
  800dca:	4d 39 fe             	cmp    %r15,%r14
  800dcd:	72 87                	jb     800d56 <file_read+0x4d>
    }

    return count;
  800dcf:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
}
  800dd3:	48 83 c4 28          	add    $0x28,%rsp
  800dd7:	5b                   	pop    %rbx
  800dd8:	41 5c                	pop    %r12
  800dda:	41 5d                	pop    %r13
  800ddc:	41 5e                	pop    %r14
  800dde:	41 5f                	pop    %r15
  800de0:	5d                   	pop    %rbp
  800de1:	c3                   	ret
        if (r < 0) return r;
  800de2:	48 98                	cltq
  800de4:	eb ed                	jmp    800dd3 <file_read+0xca>

0000000000800de6 <file_set_size>:
    }
}

/* Set the size of file f, truncating or extending as necessary. */
int
file_set_size(struct File *f, off_t newsize) {
  800de6:	f3 0f 1e fa          	endbr64
  800dea:	55                   	push   %rbp
  800deb:	48 89 e5             	mov    %rsp,%rbp
  800dee:	41 57                	push   %r15
  800df0:	41 56                	push   %r14
  800df2:	41 55                	push   %r13
  800df4:	41 54                	push   %r12
  800df6:	53                   	push   %rbx
  800df7:	48 83 ec 28          	sub    $0x28,%rsp
  800dfb:	49 89 fc             	mov    %rdi,%r12
  800dfe:	89 75 bc             	mov    %esi,-0x44(%rbp)
    if (f->f_size > newsize)
  800e01:	8b 87 80 00 00 00    	mov    0x80(%rdi),%eax
  800e07:	39 f0                	cmp    %esi,%eax
  800e09:	7f 2e                	jg     800e39 <file_set_size+0x53>
        file_truncate_blocks(f, newsize);
    f->f_size = newsize;
  800e0b:	8b 45 bc             	mov    -0x44(%rbp),%eax
  800e0e:	41 89 84 24 80 00 00 	mov    %eax,0x80(%r12)
  800e15:	00 
    flush_block(f);
  800e16:	4c 89 e7             	mov    %r12,%rdi
  800e19:	48 b8 89 01 80 00 00 	movabs $0x800189,%rax
  800e20:	00 00 00 
  800e23:	ff d0                	call   *%rax
    return 0;
}
  800e25:	b8 00 00 00 00       	mov    $0x0,%eax
  800e2a:	48 83 c4 28          	add    $0x28,%rsp
  800e2e:	5b                   	pop    %rbx
  800e2f:	41 5c                	pop    %r12
  800e31:	41 5d                	pop    %r13
  800e33:	41 5e                	pop    %r14
  800e35:	41 5f                	pop    %r15
  800e37:	5d                   	pop    %rbp
  800e38:	c3                   	ret
    blockno_t old_nblocks = CEILDIV(f->f_size, BLKSIZE);
  800e39:	48 98                	cltq
  800e3b:	48 05 ff 0f 00 00    	add    $0xfff,%rax
  800e41:	48 c1 e8 0c          	shr    $0xc,%rax
  800e45:	41 89 c6             	mov    %eax,%r14d
    blockno_t new_nblocks = CEILDIV(newsize, BLKSIZE);
  800e48:	48 63 d6             	movslq %esi,%rdx
  800e4b:	48 81 c2 ff 0f 00 00 	add    $0xfff,%rdx
  800e52:	48 c1 ea 0c          	shr    $0xc,%rdx
  800e56:	48 89 55 b0          	mov    %rdx,-0x50(%rbp)
    for (blockno_t bno = new_nblocks; bno < old_nblocks; bno++) {
  800e5a:	39 c2                	cmp    %eax,%edx
  800e5c:	73 0e                	jae    800e6c <file_set_size+0x86>
  800e5e:	89 d3                	mov    %edx,%ebx
    int res = file_block_walk(f, filebno, &ptr, 0);
  800e60:	49 bf c0 08 80 00 00 	movabs $0x8008c0,%r15
  800e67:	00 00 00 
  800e6a:	eb 54                	jmp    800ec0 <file_set_size+0xda>
    if (new_nblocks <= NDIRECT && f->f_indirect) {
  800e6c:	83 7d b0 0a          	cmpl   $0xa,-0x50(%rbp)
  800e70:	77 99                	ja     800e0b <file_set_size+0x25>
  800e72:	41 8b bc 24 b0 00 00 	mov    0xb0(%r12),%edi
  800e79:	00 
  800e7a:	85 ff                	test   %edi,%edi
  800e7c:	74 8d                	je     800e0b <file_set_size+0x25>
        free_block(f->f_indirect);
  800e7e:	48 b8 24 06 80 00 00 	movabs $0x800624,%rax
  800e85:	00 00 00 
  800e88:	ff d0                	call   *%rax
        f->f_indirect = 0;
  800e8a:	41 c7 84 24 b0 00 00 	movl   $0x0,0xb0(%r12)
  800e91:	00 00 00 00 00 
  800e96:	e9 70 ff ff ff       	jmp    800e0b <file_set_size+0x25>
        if (res < 0) cprintf("warning: file_free_block: %i", res);
  800e9b:	89 c6                	mov    %eax,%esi
  800e9d:	48 bf af 74 80 00 00 	movabs $0x8074af,%rdi
  800ea4:	00 00 00 
  800ea7:	b8 00 00 00 00       	mov    $0x0,%eax
  800eac:	48 b9 1d 3e 80 00 00 	movabs $0x803e1d,%rcx
  800eb3:	00 00 00 
  800eb6:	ff d1                	call   *%rcx
    for (blockno_t bno = new_nblocks; bno < old_nblocks; bno++) {
  800eb8:	83 c3 01             	add    $0x1,%ebx
  800ebb:	44 39 f3             	cmp    %r14d,%ebx
  800ebe:	73 ac                	jae    800e6c <file_set_size+0x86>
    int res = file_block_walk(f, filebno, &ptr, 0);
  800ec0:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ec5:	48 8d 55 c8          	lea    -0x38(%rbp),%rdx
  800ec9:	89 de                	mov    %ebx,%esi
  800ecb:	4c 89 e7             	mov    %r12,%rdi
  800ece:	41 ff d7             	call   *%r15
    if (res < 0) return res;
  800ed1:	85 c0                	test   %eax,%eax
  800ed3:	78 c6                	js     800e9b <file_set_size+0xb5>
    if (*ptr) {
  800ed5:	4c 8b 6d c8          	mov    -0x38(%rbp),%r13
  800ed9:	41 8b 7d 00          	mov    0x0(%r13),%edi
  800edd:	85 ff                	test   %edi,%edi
  800edf:	74 d7                	je     800eb8 <file_set_size+0xd2>
        free_block(*ptr);
  800ee1:	48 b8 24 06 80 00 00 	movabs $0x800624,%rax
  800ee8:	00 00 00 
  800eeb:	ff d0                	call   *%rax
        *ptr = 0;
  800eed:	41 c7 45 00 00 00 00 	movl   $0x0,0x0(%r13)
  800ef4:	00 
  800ef5:	eb c1                	jmp    800eb8 <file_set_size+0xd2>

0000000000800ef7 <file_write>:
file_write(struct File *f, const void *buf, size_t count, off_t offset) {
  800ef7:	f3 0f 1e fa          	endbr64
  800efb:	55                   	push   %rbp
  800efc:	48 89 e5             	mov    %rsp,%rbp
  800eff:	41 57                	push   %r15
  800f01:	41 56                	push   %r14
  800f03:	41 55                	push   %r13
  800f05:	41 54                	push   %r12
  800f07:	53                   	push   %rbx
  800f08:	48 83 ec 38          	sub    $0x38,%rsp
  800f0c:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
  800f10:	49 89 f6             	mov    %rsi,%r14
  800f13:	48 89 55 b0          	mov    %rdx,-0x50(%rbp)
  800f17:	89 cb                	mov    %ecx,%ebx
    off_t old_size = f->f_size;
  800f19:	8b 87 80 00 00 00    	mov    0x80(%rdi),%eax
  800f1f:	89 45 ac             	mov    %eax,-0x54(%rbp)
    if (offset + count > f->f_size)
  800f22:	4c 63 e1             	movslq %ecx,%r12
  800f25:	4d 8d 3c 14          	lea    (%r12,%rdx,1),%r15
  800f29:	48 98                	cltq
  800f2b:	4c 39 f8             	cmp    %r15,%rax
  800f2e:	0f 82 a1 00 00 00    	jb     800fd5 <file_write+0xde>
    for (off_t pos = offset; pos < offset + count;) {
  800f34:	4d 39 fc             	cmp    %r15,%r12
  800f37:	0f 83 85 00 00 00    	jae    800fc2 <file_write+0xcb>
        if ((res = file_get_block(f, pos / BLKSIZE, &blk)) < 0) {
  800f3d:	8d b3 ff 0f 00 00    	lea    0xfff(%rbx),%esi
  800f43:	85 db                	test   %ebx,%ebx
  800f45:	0f 49 f3             	cmovns %ebx,%esi
  800f48:	c1 fe 0c             	sar    $0xc,%esi
  800f4b:	48 8d 55 c8          	lea    -0x38(%rbp),%rdx
  800f4f:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  800f53:	48 b8 9d 09 80 00 00 	movabs $0x80099d,%rax
  800f5a:	00 00 00 
  800f5d:	ff d0                	call   *%rax
  800f5f:	41 89 c5             	mov    %eax,%r13d
  800f62:	85 c0                	test   %eax,%eax
  800f64:	0f 88 8b 00 00 00    	js     800ff5 <file_write+0xfe>
        blockno_t bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  800f6a:	89 d8                	mov    %ebx,%eax
  800f6c:	c1 f8 1f             	sar    $0x1f,%eax
  800f6f:	c1 e8 14             	shr    $0x14,%eax
  800f72:	8d 3c 03             	lea    (%rbx,%rax,1),%edi
  800f75:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
  800f7b:	29 c7                	sub    %eax,%edi
  800f7d:	48 63 ff             	movslq %edi,%rdi
  800f80:	41 bd 00 10 00 00    	mov    $0x1000,%r13d
  800f86:	49 29 fd             	sub    %rdi,%r13
  800f89:	4c 89 f8             	mov    %r15,%rax
  800f8c:	4c 29 e0             	sub    %r12,%rax
  800f8f:	49 39 c5             	cmp    %rax,%r13
  800f92:	4c 0f 47 e8          	cmova  %rax,%r13
        memmove(blk + pos % BLKSIZE, buf, bn);
  800f96:	48 03 7d c8          	add    -0x38(%rbp),%rdi
  800f9a:	4c 89 ea             	mov    %r13,%rdx
  800f9d:	4c 89 f6             	mov    %r14,%rsi
  800fa0:	48 b8 81 49 80 00 00 	movabs $0x804981,%rax
  800fa7:	00 00 00 
  800faa:	ff d0                	call   *%rax
        pos += bn;
  800fac:	46 8d 24 2b          	lea    (%rbx,%r13,1),%r12d
  800fb0:	44 89 e3             	mov    %r12d,%ebx
        buf += bn;
  800fb3:	4d 01 ee             	add    %r13,%r14
    for (off_t pos = offset; pos < offset + count;) {
  800fb6:	4d 63 e4             	movslq %r12d,%r12
  800fb9:	4d 39 fc             	cmp    %r15,%r12
  800fbc:	0f 82 7b ff ff ff    	jb     800f3d <file_write+0x46>
    return count;
  800fc2:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
}
  800fc6:	48 83 c4 38          	add    $0x38,%rsp
  800fca:	5b                   	pop    %rbx
  800fcb:	41 5c                	pop    %r12
  800fcd:	41 5d                	pop    %r13
  800fcf:	41 5e                	pop    %r14
  800fd1:	41 5f                	pop    %r15
  800fd3:	5d                   	pop    %rbp
  800fd4:	c3                   	ret
        if ((res = file_set_size(f, offset + count)) < 0) return res;
  800fd5:	8b 45 b0             	mov    -0x50(%rbp),%eax
  800fd8:	8d 34 01             	lea    (%rcx,%rax,1),%esi
  800fdb:	48 b8 e6 0d 80 00 00 	movabs $0x800de6,%rax
  800fe2:	00 00 00 
  800fe5:	ff d0                	call   *%rax
  800fe7:	89 c2                	mov    %eax,%edx
  800fe9:	48 98                	cltq
  800feb:	85 d2                	test   %edx,%edx
  800fed:	0f 89 41 ff ff ff    	jns    800f34 <file_write+0x3d>
  800ff3:	eb d1                	jmp    800fc6 <file_write+0xcf>
            file_set_size(f, old_size);
  800ff5:	8b 75 ac             	mov    -0x54(%rbp),%esi
  800ff8:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  800ffc:	48 b8 e6 0d 80 00 00 	movabs $0x800de6,%rax
  801003:	00 00 00 
  801006:	ff d0                	call   *%rax
            return res;
  801008:	49 63 c5             	movslq %r13d,%rax
  80100b:	eb b9                	jmp    800fc6 <file_write+0xcf>

000000000080100d <file_flush>:
/* Flush the contents and metadata of file f out to disk.
 * Loop over all the blocks in file.
 * Translate the file block number into a disk block number
 * and then check whether that disk block is dirty.  If so, write it out. */
void
file_flush(struct File *f) {
  80100d:	f3 0f 1e fa          	endbr64
  801011:	55                   	push   %rbp
  801012:	48 89 e5             	mov    %rsp,%rbp
  801015:	41 57                	push   %r15
  801017:	41 56                	push   %r14
  801019:	41 55                	push   %r13
  80101b:	41 54                	push   %r12
  80101d:	53                   	push   %rbx
  80101e:	48 83 ec 18          	sub    $0x18,%rsp
  801022:	49 89 fc             	mov    %rdi,%r12
    blockno_t *pdiskbno;

    for (blockno_t i = 0; i < CEILDIV(f->f_size, BLKSIZE); i++) {
  801025:	48 63 87 80 00 00 00 	movslq 0x80(%rdi),%rax
  80102c:	48 05 ff 0f 00 00    	add    $0xfff,%rax
  801032:	48 c1 e8 0c          	shr    $0xc,%rax
  801036:	85 c0                	test   %eax,%eax
  801038:	74 6d                	je     8010a7 <file_flush+0x9a>
  80103a:	bb 00 00 00 00       	mov    $0x0,%ebx
        if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  80103f:	49 bd c0 08 80 00 00 	movabs $0x8008c0,%r13
  801046:	00 00 00 
            pdiskbno == NULL || *pdiskbno == 0)
            continue;
        flush_block(diskaddr(*pdiskbno));
  801049:	49 bf 2f 01 80 00 00 	movabs $0x80012f,%r15
  801050:	00 00 00 
  801053:	49 be 89 01 80 00 00 	movabs $0x800189,%r14
  80105a:	00 00 00 
  80105d:	eb 19                	jmp    801078 <file_flush+0x6b>
    for (blockno_t i = 0; i < CEILDIV(f->f_size, BLKSIZE); i++) {
  80105f:	83 c3 01             	add    $0x1,%ebx
  801062:	49 63 84 24 80 00 00 	movslq 0x80(%r12),%rax
  801069:	00 
  80106a:	48 05 ff 0f 00 00    	add    $0xfff,%rax
  801070:	48 c1 e8 0c          	shr    $0xc,%rax
  801074:	39 c3                	cmp    %eax,%ebx
  801076:	73 2f                	jae    8010a7 <file_flush+0x9a>
        if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  801078:	b9 00 00 00 00       	mov    $0x0,%ecx
  80107d:	48 8d 55 c8          	lea    -0x38(%rbp),%rdx
  801081:	89 de                	mov    %ebx,%esi
  801083:	4c 89 e7             	mov    %r12,%rdi
  801086:	41 ff d5             	call   *%r13
  801089:	85 c0                	test   %eax,%eax
  80108b:	78 d2                	js     80105f <file_flush+0x52>
            pdiskbno == NULL || *pdiskbno == 0)
  80108d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
        if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  801091:	48 85 c0             	test   %rax,%rax
  801094:	74 c9                	je     80105f <file_flush+0x52>
            pdiskbno == NULL || *pdiskbno == 0)
  801096:	8b 38                	mov    (%rax),%edi
  801098:	85 ff                	test   %edi,%edi
  80109a:	74 c3                	je     80105f <file_flush+0x52>
        flush_block(diskaddr(*pdiskbno));
  80109c:	41 ff d7             	call   *%r15
  80109f:	48 89 c7             	mov    %rax,%rdi
  8010a2:	41 ff d6             	call   *%r14
  8010a5:	eb b8                	jmp    80105f <file_flush+0x52>
    }
    if (f->f_indirect)
  8010a7:	41 8b bc 24 b0 00 00 	mov    0xb0(%r12),%edi
  8010ae:	00 
  8010af:	85 ff                	test   %edi,%edi
  8010b1:	75 1e                	jne    8010d1 <file_flush+0xc4>
        flush_block(diskaddr(f->f_indirect));
    flush_block(f);
  8010b3:	4c 89 e7             	mov    %r12,%rdi
  8010b6:	48 b8 89 01 80 00 00 	movabs $0x800189,%rax
  8010bd:	00 00 00 
  8010c0:	ff d0                	call   *%rax
}
  8010c2:	48 83 c4 18          	add    $0x18,%rsp
  8010c6:	5b                   	pop    %rbx
  8010c7:	41 5c                	pop    %r12
  8010c9:	41 5d                	pop    %r13
  8010cb:	41 5e                	pop    %r14
  8010cd:	41 5f                	pop    %r15
  8010cf:	5d                   	pop    %rbp
  8010d0:	c3                   	ret
        flush_block(diskaddr(f->f_indirect));
  8010d1:	48 b8 2f 01 80 00 00 	movabs $0x80012f,%rax
  8010d8:	00 00 00 
  8010db:	ff d0                	call   *%rax
  8010dd:	48 89 c7             	mov    %rax,%rdi
  8010e0:	48 b8 89 01 80 00 00 	movabs $0x800189,%rax
  8010e7:	00 00 00 
  8010ea:	ff d0                	call   *%rax
  8010ec:	eb c5                	jmp    8010b3 <file_flush+0xa6>

00000000008010ee <file_create>:
file_create(const char *path, struct File **pf) {
  8010ee:	f3 0f 1e fa          	endbr64
  8010f2:	55                   	push   %rbp
  8010f3:	48 89 e5             	mov    %rsp,%rbp
  8010f6:	41 57                	push   %r15
  8010f8:	41 56                	push   %r14
  8010fa:	41 55                	push   %r13
  8010fc:	41 54                	push   %r12
  8010fe:	53                   	push   %rbx
  8010ff:	48 81 ec b8 00 00 00 	sub    $0xb8,%rsp
  801106:	48 89 b5 28 ff ff ff 	mov    %rsi,-0xd8(%rbp)
    if (!(res = walk_path(path, &dir, &filp, name))) return -E_FILE_EXISTS;
  80110d:	48 8d 8d 50 ff ff ff 	lea    -0xb0(%rbp),%rcx
  801114:	48 8d 95 40 ff ff ff 	lea    -0xc0(%rbp),%rdx
  80111b:	48 8d b5 48 ff ff ff 	lea    -0xb8(%rbp),%rsi
  801122:	48 b8 15 0a 80 00 00 	movabs $0x800a15,%rax
  801129:	00 00 00 
  80112c:	ff d0                	call   *%rax
  80112e:	85 c0                	test   %eax,%eax
  801130:	0f 84 55 01 00 00    	je     80128b <file_create+0x19d>
  801136:	89 c3                	mov    %eax,%ebx
    if (res != -E_NOT_FOUND || dir == 0) return res;
  801138:	83 f8 f1             	cmp    $0xfffffff1,%eax
  80113b:	0f 85 fd 00 00 00    	jne    80123e <file_create+0x150>
  801141:	4c 8b ad 48 ff ff ff 	mov    -0xb8(%rbp),%r13
  801148:	4d 85 ed             	test   %r13,%r13
  80114b:	0f 84 ed 00 00 00    	je     80123e <file_create+0x150>
    assert((dir->f_size % BLKSIZE) == 0);
  801151:	41 8b 85 80 00 00 00 	mov    0x80(%r13),%eax
  801158:	89 c3                	mov    %eax,%ebx
  80115a:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
  801160:	0f 85 ec 00 00 00    	jne    801252 <file_create+0x164>
    blockno_t nblock = dir->f_size / BLKSIZE;
  801166:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  80116c:	85 c0                	test   %eax,%eax
  80116e:	0f 48 c2             	cmovs  %edx,%eax
    for (blockno_t i = 0; i < nblock; i++) {
  801171:	c1 f8 0c             	sar    $0xc,%eax
  801174:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%rbp)
  80117a:	74 56                	je     8011d2 <file_create+0xe4>
  80117c:	41 be 00 00 00 00    	mov    $0x0,%r14d
        int res = file_get_block(dir, i, &blk);
  801182:	49 bf 9d 09 80 00 00 	movabs $0x80099d,%r15
  801189:	00 00 00 
  80118c:	48 8d 95 38 ff ff ff 	lea    -0xc8(%rbp),%rdx
  801193:	44 89 f6             	mov    %r14d,%esi
  801196:	4c 89 ef             	mov    %r13,%rdi
  801199:	41 ff d7             	call   *%r15
        if (res < 0) return res;
  80119c:	85 c0                	test   %eax,%eax
  80119e:	0f 88 e3 00 00 00    	js     801287 <file_create+0x199>
        for (blockno_t j = 0; j < BLKFILES; j++) {
  8011a4:	48 8b 85 38 ff ff ff 	mov    -0xc8(%rbp),%rax
  8011ab:	48 8d 90 00 10 00 00 	lea    0x1000(%rax),%rdx
            if (f[j].f_name[0] == '\0') {
  8011b2:	49 89 c4             	mov    %rax,%r12
  8011b5:	80 38 00             	cmpb   $0x0,(%rax)
  8011b8:	74 4e                	je     801208 <file_create+0x11a>
        for (blockno_t j = 0; j < BLKFILES; j++) {
  8011ba:	48 05 00 01 00 00    	add    $0x100,%rax
  8011c0:	48 39 d0             	cmp    %rdx,%rax
  8011c3:	75 ed                	jne    8011b2 <file_create+0xc4>
    for (blockno_t i = 0; i < nblock; i++) {
  8011c5:	41 83 c6 01          	add    $0x1,%r14d
  8011c9:	44 39 b5 24 ff ff ff 	cmp    %r14d,-0xdc(%rbp)
  8011d0:	75 ba                	jne    80118c <file_create+0x9e>
    int res = file_get_block(dir, nblock, &blk);
  8011d2:	48 8d 95 38 ff ff ff 	lea    -0xc8(%rbp),%rdx
  8011d9:	8b b5 24 ff ff ff    	mov    -0xdc(%rbp),%esi
  8011df:	4c 89 ef             	mov    %r13,%rdi
  8011e2:	48 b8 9d 09 80 00 00 	movabs $0x80099d,%rax
  8011e9:	00 00 00 
  8011ec:	ff d0                	call   *%rax
    if (res < 0) return res;
  8011ee:	85 c0                	test   %eax,%eax
  8011f0:	0f 88 9c 00 00 00    	js     801292 <file_create+0x1a4>
    dir->f_size += BLKSIZE;
  8011f6:	41 81 85 80 00 00 00 	addl   $0x1000,0x80(%r13)
  8011fd:	00 10 00 00 
    *file = (struct File *)blk;
  801201:	4c 8b a5 38 ff ff ff 	mov    -0xc8(%rbp),%r12
  801208:	4c 89 a5 40 ff ff ff 	mov    %r12,-0xc0(%rbp)
    strcpy(filp->f_name, name);
  80120f:	48 8d b5 50 ff ff ff 	lea    -0xb0(%rbp),%rsi
  801216:	4c 89 e7             	mov    %r12,%rdi
  801219:	48 b8 66 47 80 00 00 	movabs $0x804766,%rax
  801220:	00 00 00 
  801223:	ff d0                	call   *%rax
    *pf = filp;
  801225:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  80122c:	4c 89 20             	mov    %r12,(%rax)
    file_flush(dir);
  80122f:	4c 89 ef             	mov    %r13,%rdi
  801232:	48 b8 0d 10 80 00 00 	movabs $0x80100d,%rax
  801239:	00 00 00 
  80123c:	ff d0                	call   *%rax
}
  80123e:	89 d8                	mov    %ebx,%eax
  801240:	48 81 c4 b8 00 00 00 	add    $0xb8,%rsp
  801247:	5b                   	pop    %rbx
  801248:	41 5c                	pop    %r12
  80124a:	41 5d                	pop    %r13
  80124c:	41 5e                	pop    %r14
  80124e:	41 5f                	pop    %r15
  801250:	5d                   	pop    %rbp
  801251:	c3                   	ret
    assert((dir->f_size % BLKSIZE) == 0);
  801252:	48 b9 92 74 80 00 00 	movabs $0x807492,%rcx
  801259:	00 00 00 
  80125c:	48 ba 94 73 80 00 00 	movabs $0x807394,%rdx
  801263:	00 00 00 
  801266:	be d8 00 00 00       	mov    $0xd8,%esi
  80126b:	48 bf f8 73 80 00 00 	movabs $0x8073f8,%rdi
  801272:	00 00 00 
  801275:	b8 00 00 00 00       	mov    $0x0,%eax
  80127a:	49 b8 c1 3c 80 00 00 	movabs $0x803cc1,%r8
  801281:	00 00 00 
  801284:	41 ff d0             	call   *%r8
    if ((res = dir_alloc_file(dir, &filp)) < 0) return res;
  801287:	89 c3                	mov    %eax,%ebx
  801289:	eb b3                	jmp    80123e <file_create+0x150>
    if (!(res = walk_path(path, &dir, &filp, name))) return -E_FILE_EXISTS;
  80128b:	bb ef ff ff ff       	mov    $0xffffffef,%ebx
  801290:	eb ac                	jmp    80123e <file_create+0x150>
    if ((res = dir_alloc_file(dir, &filp)) < 0) return res;
  801292:	89 c3                	mov    %eax,%ebx
  801294:	eb a8                	jmp    80123e <file_create+0x150>

0000000000801296 <fs_sync>:

/* Sync the entire file system.  A big hammer. */
void
fs_sync(void) {
  801296:	f3 0f 1e fa          	endbr64
    for (int i = 1; i < super->s_nblocks; i++) {
  80129a:	48 a1 08 d0 80 00 00 	movabs 0x80d008,%rax
  8012a1:	00 00 00 
  8012a4:	83 78 04 01          	cmpl   $0x1,0x4(%rax)
  8012a8:	76 4e                	jbe    8012f8 <fs_sync+0x62>
fs_sync(void) {
  8012aa:	55                   	push   %rbp
  8012ab:	48 89 e5             	mov    %rsp,%rbp
  8012ae:	41 56                	push   %r14
  8012b0:	41 55                	push   %r13
  8012b2:	41 54                	push   %r12
  8012b4:	53                   	push   %rbx
    for (int i = 1; i < super->s_nblocks; i++) {
  8012b5:	bb 01 00 00 00       	mov    $0x1,%ebx
        flush_block(diskaddr(i));
  8012ba:	49 be 2f 01 80 00 00 	movabs $0x80012f,%r14
  8012c1:	00 00 00 
  8012c4:	49 bd 89 01 80 00 00 	movabs $0x800189,%r13
  8012cb:	00 00 00 
    for (int i = 1; i < super->s_nblocks; i++) {
  8012ce:	49 bc 08 d0 80 00 00 	movabs $0x80d008,%r12
  8012d5:	00 00 00 
        flush_block(diskaddr(i));
  8012d8:	89 df                	mov    %ebx,%edi
  8012da:	41 ff d6             	call   *%r14
  8012dd:	48 89 c7             	mov    %rax,%rdi
  8012e0:	41 ff d5             	call   *%r13
    for (int i = 1; i < super->s_nblocks; i++) {
  8012e3:	83 c3 01             	add    $0x1,%ebx
  8012e6:	49 8b 04 24          	mov    (%r12),%rax
  8012ea:	3b 58 04             	cmp    0x4(%rax),%ebx
  8012ed:	72 e9                	jb     8012d8 <fs_sync+0x42>
    }
}
  8012ef:	5b                   	pop    %rbx
  8012f0:	41 5c                	pop    %r12
  8012f2:	41 5d                	pop    %r13
  8012f4:	41 5e                	pop    %r14
  8012f6:	5d                   	pop    %rbp
  8012f7:	c3                   	ret
  8012f8:	c3                   	ret

00000000008012f9 <serve_sync>:
    file_flush(o->o_file);
    return 0;
}

int
serve_sync(envid_t envid, union Fsipc *req) {
  8012f9:	f3 0f 1e fa          	endbr64
  8012fd:	55                   	push   %rbp
  8012fe:	48 89 e5             	mov    %rsp,%rbp
    fs_sync();
  801301:	48 b8 96 12 80 00 00 	movabs $0x801296,%rax
  801308:	00 00 00 
  80130b:	ff d0                	call   *%rax
    return 0;
}
  80130d:	b8 00 00 00 00       	mov    $0x0,%eax
  801312:	5d                   	pop    %rbp
  801313:	c3                   	ret

0000000000801314 <serve_init>:
serve_init(void) {
  801314:	f3 0f 1e fa          	endbr64
    for (size_t i = 0; i < MAXOPEN; i++) {
  801318:	48 ba 60 80 80 00 00 	movabs $0x808060,%rdx
  80131f:	00 00 00 
  801322:	b9 00 00 00 00       	mov    $0x0,%ecx
    uintptr_t va = FILE_BASE;
  801327:	48 b8 00 00 00 00 02 	movabs $0x200000000,%rax
  80132e:	00 00 00 
    for (size_t i = 0; i < MAXOPEN; i++) {
  801331:	48 be 00 00 20 00 02 	movabs $0x200200000,%rsi
  801338:	00 00 00 
        opentab[i].o_fileid = i;
  80133b:	89 0a                	mov    %ecx,(%rdx)
        opentab[i].o_fd = (struct Fd *)va;
  80133d:	48 89 42 18          	mov    %rax,0x18(%rdx)
        va += PAGE_SIZE;
  801341:	48 05 00 10 00 00    	add    $0x1000,%rax
    for (size_t i = 0; i < MAXOPEN; i++) {
  801347:	48 83 c1 01          	add    $0x1,%rcx
  80134b:	48 83 c2 20          	add    $0x20,%rdx
  80134f:	48 39 f0             	cmp    %rsi,%rax
  801352:	75 e7                	jne    80133b <serve_init+0x27>
}
  801354:	c3                   	ret

0000000000801355 <openfile_alloc>:
openfile_alloc(struct OpenFile **o) {
  801355:	f3 0f 1e fa          	endbr64
  801359:	55                   	push   %rbp
  80135a:	48 89 e5             	mov    %rsp,%rbp
  80135d:	41 56                	push   %r14
  80135f:	41 55                	push   %r13
  801361:	41 54                	push   %r12
  801363:	53                   	push   %rbx
  801364:	49 89 fc             	mov    %rdi,%r12
    for (size_t i = 0; i < MAXOPEN; i++) {
  801367:	49 bd 78 80 80 00 00 	movabs $0x808078,%r13
  80136e:	00 00 00 
  801371:	bb 00 00 00 00       	mov    $0x0,%ebx
        switch (sys_region_refs(opentab[i].o_fd, PAGE_SIZE)) {
  801376:	49 be 05 4d 80 00 00 	movabs $0x804d05,%r14
  80137d:	00 00 00 
  801380:	49 8b 7d 00          	mov    0x0(%r13),%rdi
  801384:	be 00 10 00 00       	mov    $0x1000,%esi
  801389:	41 ff d6             	call   *%r14
  80138c:	85 c0                	test   %eax,%eax
  80138e:	74 1d                	je     8013ad <openfile_alloc+0x58>
  801390:	83 f8 01             	cmp    $0x1,%eax
  801393:	74 4d                	je     8013e2 <openfile_alloc+0x8d>
    for (size_t i = 0; i < MAXOPEN; i++) {
  801395:	48 83 c3 01          	add    $0x1,%rbx
  801399:	49 83 c5 20          	add    $0x20,%r13
  80139d:	48 81 fb 00 02 00 00 	cmp    $0x200,%rbx
  8013a4:	75 da                	jne    801380 <openfile_alloc+0x2b>
    return -E_MAX_OPEN;
  8013a6:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  8013ab:	eb 70                	jmp    80141d <openfile_alloc+0xc8>
            int res = sys_alloc_region(0, opentab[i].o_fd, PAGE_SIZE, PROT_RW);
  8013ad:	48 89 d8             	mov    %rbx,%rax
  8013b0:	48 c1 e0 05          	shl    $0x5,%rax
  8013b4:	48 ba 60 80 80 00 00 	movabs $0x808060,%rdx
  8013bb:	00 00 00 
  8013be:	48 8b 74 02 18       	mov    0x18(%rdx,%rax,1),%rsi
  8013c3:	b9 06 00 00 00       	mov    $0x6,%ecx
  8013c8:	ba 00 10 00 00       	mov    $0x1000,%edx
  8013cd:	bf 00 00 00 00       	mov    $0x0,%edi
  8013d2:	48 b8 6b 4d 80 00 00 	movabs $0x804d6b,%rax
  8013d9:	00 00 00 
  8013dc:	ff d0                	call   *%rax
            if (res < 0) return res;
  8013de:	85 c0                	test   %eax,%eax
  8013e0:	78 3b                	js     80141d <openfile_alloc+0xc8>
            opentab[i].o_fileid += MAXOPEN;
  8013e2:	48 c1 e3 05          	shl    $0x5,%rbx
  8013e6:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  8013ed:	00 00 00 
  8013f0:	48 01 c3             	add    %rax,%rbx
  8013f3:	81 03 00 02 00 00    	addl   $0x200,(%rbx)
            *o = &opentab[i];
  8013f9:	49 89 1c 24          	mov    %rbx,(%r12)
            memset(opentab[i].o_fd, 0, PAGE_SIZE);
  8013fd:	48 8b 7b 18          	mov    0x18(%rbx),%rdi
  801401:	ba 00 10 00 00       	mov    $0x1000,%edx
  801406:	be 00 00 00 00       	mov    $0x0,%esi
  80140b:	48 b8 c7 48 80 00 00 	movabs $0x8048c7,%rax
  801412:	00 00 00 
  801415:	ff d0                	call   *%rax
            return (*o)->o_fileid;
  801417:	49 8b 04 24          	mov    (%r12),%rax
  80141b:	8b 00                	mov    (%rax),%eax
}
  80141d:	5b                   	pop    %rbx
  80141e:	41 5c                	pop    %r12
  801420:	41 5d                	pop    %r13
  801422:	41 5e                	pop    %r14
  801424:	5d                   	pop    %rbp
  801425:	c3                   	ret

0000000000801426 <openfile_lookup>:
openfile_lookup(envid_t envid, uint32_t fileid, struct OpenFile **po) {
  801426:	f3 0f 1e fa          	endbr64
  80142a:	55                   	push   %rbp
  80142b:	48 89 e5             	mov    %rsp,%rbp
  80142e:	41 56                	push   %r14
  801430:	41 55                	push   %r13
  801432:	41 54                	push   %r12
  801434:	53                   	push   %rbx
  801435:	41 89 f5             	mov    %esi,%r13d
  801438:	49 89 d6             	mov    %rdx,%r14
    o = &opentab[fileid % MAXOPEN];
  80143b:	41 89 f4             	mov    %esi,%r12d
  80143e:	41 81 e4 ff 01 00 00 	and    $0x1ff,%r12d
  801445:	44 89 e3             	mov    %r12d,%ebx
  801448:	48 c1 e3 05          	shl    $0x5,%rbx
  80144c:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  801453:	00 00 00 
  801456:	48 01 c3             	add    %rax,%rbx
    if (sys_region_refs(o->o_fd, PAGE_SIZE) <= 1 || o->o_fileid != fileid)
  801459:	48 8b 7b 18          	mov    0x18(%rbx),%rdi
  80145d:	be 00 10 00 00       	mov    $0x1000,%esi
  801462:	48 b8 05 4d 80 00 00 	movabs $0x804d05,%rax
  801469:	00 00 00 
  80146c:	ff d0                	call   *%rax
  80146e:	83 f8 01             	cmp    $0x1,%eax
  801471:	7e 28                	jle    80149b <openfile_lookup+0x75>
  801473:	45 89 e4             	mov    %r12d,%r12d
  801476:	49 c1 e4 05          	shl    $0x5,%r12
  80147a:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  801481:	00 00 00 
  801484:	46 39 2c 20          	cmp    %r13d,(%rax,%r12,1)
  801488:	75 18                	jne    8014a2 <openfile_lookup+0x7c>
    *po = o;
  80148a:	49 89 1e             	mov    %rbx,(%r14)
    return 0;
  80148d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801492:	5b                   	pop    %rbx
  801493:	41 5c                	pop    %r12
  801495:	41 5d                	pop    %r13
  801497:	41 5e                	pop    %r14
  801499:	5d                   	pop    %rbp
  80149a:	c3                   	ret
        return -E_INVAL;
  80149b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014a0:	eb f0                	jmp    801492 <openfile_lookup+0x6c>
  8014a2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014a7:	eb e9                	jmp    801492 <openfile_lookup+0x6c>

00000000008014a9 <serve_set_size>:
serve_set_size(envid_t envid, union Fsipc *ipc) {
  8014a9:	f3 0f 1e fa          	endbr64
  8014ad:	55                   	push   %rbp
  8014ae:	48 89 e5             	mov    %rsp,%rbp
  8014b1:	53                   	push   %rbx
  8014b2:	48 83 ec 18          	sub    $0x18,%rsp
  8014b6:	48 89 f3             	mov    %rsi,%rbx
    if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  8014b9:	8b 36                	mov    (%rsi),%esi
  8014bb:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8014bf:	48 b8 26 14 80 00 00 	movabs $0x801426,%rax
  8014c6:	00 00 00 
  8014c9:	ff d0                	call   *%rax
  8014cb:	85 c0                	test   %eax,%eax
  8014cd:	78 17                	js     8014e6 <serve_set_size+0x3d>
    return file_set_size(o->o_file, req->req_size);
  8014cf:	8b 73 04             	mov    0x4(%rbx),%esi
  8014d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014d6:	48 8b 78 08          	mov    0x8(%rax),%rdi
  8014da:	48 b8 e6 0d 80 00 00 	movabs $0x800de6,%rax
  8014e1:	00 00 00 
  8014e4:	ff d0                	call   *%rax
}
  8014e6:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8014ea:	c9                   	leave
  8014eb:	c3                   	ret

00000000008014ec <serve_read>:
serve_read(envid_t envid, union Fsipc *ipc) {
  8014ec:	f3 0f 1e fa          	endbr64
  8014f0:	55                   	push   %rbp
  8014f1:	48 89 e5             	mov    %rsp,%rbp
  8014f4:	41 54                	push   %r12
  8014f6:	53                   	push   %rbx
  8014f7:	48 83 ec 10          	sub    $0x10,%rsp
  8014fb:	48 89 f3             	mov    %rsi,%rbx
    struct OpenFile *open = NULL;
  8014fe:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  801505:	00 
    res = openfile_lookup(envid, ipc->read.req_fileid, &open);
  801506:	8b 36                	mov    (%rsi),%esi
  801508:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80150c:	48 b8 26 14 80 00 00 	movabs $0x801426,%rax
  801513:	00 00 00 
  801516:	ff d0                	call   *%rax
    if (res < 0) {
  801518:	85 c0                	test   %eax,%eax
  80151a:	78 39                	js     801555 <serve_read+0x69>
    struct File *file = open->o_file;
  80151c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    struct Fd *fd = open->o_fd;
  801520:	4c 8b 60 18          	mov    0x18(%rax),%r12
    res = file_read(file, ret->ret_buf, n, fd->fd_offset);
  801524:	41 8b 4c 24 04       	mov    0x4(%r12),%ecx
    size_t n = req->req_n < PAGE_SIZE ? req->req_n : PAGE_SIZE;
  801529:	48 8b 53 08          	mov    0x8(%rbx),%rdx
  80152d:	be 00 10 00 00       	mov    $0x1000,%esi
  801532:	48 39 f2             	cmp    %rsi,%rdx
  801535:	48 0f 47 d6          	cmova  %rsi,%rdx
    res = file_read(file, ret->ret_buf, n, fd->fd_offset);
  801539:	48 8b 78 08          	mov    0x8(%rax),%rdi
  80153d:	48 89 de             	mov    %rbx,%rsi
  801540:	48 b8 09 0d 80 00 00 	movabs $0x800d09,%rax
  801547:	00 00 00 
  80154a:	ff d0                	call   *%rax
    if (res < 0) {
  80154c:	85 c0                	test   %eax,%eax
  80154e:	78 05                	js     801555 <serve_read+0x69>
    fd->fd_offset += res;
  801550:	41 01 44 24 04       	add    %eax,0x4(%r12)
}
  801555:	48 83 c4 10          	add    $0x10,%rsp
  801559:	5b                   	pop    %rbx
  80155a:	41 5c                	pop    %r12
  80155c:	5d                   	pop    %rbp
  80155d:	c3                   	ret

000000000080155e <serve_write>:
serve_write(envid_t envid, union Fsipc *ipc) {
  80155e:	f3 0f 1e fa          	endbr64
  801562:	55                   	push   %rbp
  801563:	48 89 e5             	mov    %rsp,%rbp
  801566:	41 56                	push   %r14
  801568:	41 55                	push   %r13
  80156a:	41 54                	push   %r12
  80156c:	53                   	push   %rbx
  80156d:	48 83 ec 10          	sub    $0x10,%rsp
  801571:	48 89 f3             	mov    %rsi,%rbx
    struct OpenFile *open = NULL;
  801574:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  80157b:	00 
    res = openfile_lookup(envid, ipc->read.req_fileid, &open);
  80157c:	8b 36                	mov    (%rsi),%esi
  80157e:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  801582:	48 b8 26 14 80 00 00 	movabs $0x801426,%rax
  801589:	00 00 00 
  80158c:	ff d0                	call   *%rax
    if (res < 0) {
  80158e:	85 c0                	test   %eax,%eax
  801590:	78 61                	js     8015f3 <serve_write+0x95>
    struct File *file = open->o_file;
  801592:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801596:	4c 8b 70 08          	mov    0x8(%rax),%r14
    struct Fd *fd = open->o_fd;
  80159a:	4c 8b 68 18          	mov    0x18(%rax),%r13
    size_t n = req->req_n < PAGE_SIZE ? req->req_n : PAGE_SIZE;
  80159e:	4c 8b 63 08          	mov    0x8(%rbx),%r12
  8015a2:	b8 00 10 00 00       	mov    $0x1000,%eax
  8015a7:	49 39 c4             	cmp    %rax,%r12
  8015aa:	4c 0f 47 e0          	cmova  %rax,%r12
    res = file_write(file, req->req_buf, n, fd->fd_offset);
  8015ae:	41 8b 4d 04          	mov    0x4(%r13),%ecx
  8015b2:	48 8d 73 10          	lea    0x10(%rbx),%rsi
  8015b6:	4c 89 e2             	mov    %r12,%rdx
  8015b9:	4c 89 f7             	mov    %r14,%rdi
  8015bc:	48 b8 f7 0e 80 00 00 	movabs $0x800ef7,%rax
  8015c3:	00 00 00 
  8015c6:	ff d0                	call   *%rax
  8015c8:	48 89 c2             	mov    %rax,%rdx
    if (res < 0) {
  8015cb:	85 c0                	test   %eax,%eax
  8015cd:	78 24                	js     8015f3 <serve_write+0x95>
    if (fd->fd_offset + n > file->f_size) {
  8015cf:	41 8b 75 04          	mov    0x4(%r13),%esi
  8015d3:	48 63 ce             	movslq %esi,%rcx
  8015d6:	4c 01 e1             	add    %r12,%rcx
  8015d9:	49 63 be 80 00 00 00 	movslq 0x80(%r14),%rdi
  8015e0:	48 39 cf             	cmp    %rcx,%rdi
  8015e3:	73 0a                	jae    8015ef <serve_write+0x91>
        file->f_size = fd->fd_offset + n;
  8015e5:	44 01 e6             	add    %r12d,%esi
  8015e8:	41 89 b6 80 00 00 00 	mov    %esi,0x80(%r14)
    fd->fd_offset += res;
  8015ef:	41 01 55 04          	add    %edx,0x4(%r13)
}
  8015f3:	48 83 c4 10          	add    $0x10,%rsp
  8015f7:	5b                   	pop    %rbx
  8015f8:	41 5c                	pop    %r12
  8015fa:	41 5d                	pop    %r13
  8015fc:	41 5e                	pop    %r14
  8015fe:	5d                   	pop    %rbp
  8015ff:	c3                   	ret

0000000000801600 <serve_stat>:
serve_stat(envid_t envid, union Fsipc *ipc) {
  801600:	f3 0f 1e fa          	endbr64
  801604:	55                   	push   %rbp
  801605:	48 89 e5             	mov    %rsp,%rbp
  801608:	41 54                	push   %r12
  80160a:	53                   	push   %rbx
  80160b:	48 83 ec 10          	sub    $0x10,%rsp
  80160f:	48 89 f3             	mov    %rsi,%rbx
    int res = openfile_lookup(envid, req->req_fileid, &o);
  801612:	8b 36                	mov    (%rsi),%esi
  801614:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801618:	48 b8 26 14 80 00 00 	movabs $0x801426,%rax
  80161f:	00 00 00 
  801622:	ff d0                	call   *%rax
    if (res < 0) return res;
  801624:	85 c0                	test   %eax,%eax
  801626:	78 46                	js     80166e <serve_stat+0x6e>
    strcpy(ret->ret_name, o->o_file->f_name);
  801628:	4c 8b 65 e8          	mov    -0x18(%rbp),%r12
  80162c:	49 8b 74 24 08       	mov    0x8(%r12),%rsi
  801631:	48 89 df             	mov    %rbx,%rdi
  801634:	48 b8 66 47 80 00 00 	movabs $0x804766,%rax
  80163b:	00 00 00 
  80163e:	ff d0                	call   *%rax
    ret->ret_size = o->o_file->f_size;
  801640:	49 8b 44 24 08       	mov    0x8(%r12),%rax
  801645:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  80164b:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    ret->ret_isdir = (o->o_file->f_type == FTYPE_DIR);
  801651:	49 8b 44 24 08       	mov    0x8(%r12),%rax
  801656:	83 b8 84 00 00 00 01 	cmpl   $0x1,0x84(%rax)
  80165d:	0f 94 c0             	sete   %al
  801660:	0f b6 c0             	movzbl %al,%eax
  801663:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  801669:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80166e:	48 83 c4 10          	add    $0x10,%rsp
  801672:	5b                   	pop    %rbx
  801673:	41 5c                	pop    %r12
  801675:	5d                   	pop    %rbp
  801676:	c3                   	ret

0000000000801677 <serve_flush>:
serve_flush(envid_t envid, union Fsipc *ipc) {
  801677:	f3 0f 1e fa          	endbr64
  80167b:	55                   	push   %rbp
  80167c:	48 89 e5             	mov    %rsp,%rbp
  80167f:	48 83 ec 10          	sub    $0x10,%rsp
    int res = openfile_lookup(envid, req->req_fileid, &o);
  801683:	8b 36                	mov    (%rsi),%esi
  801685:	48 8d 55 f8          	lea    -0x8(%rbp),%rdx
  801689:	48 b8 26 14 80 00 00 	movabs $0x801426,%rax
  801690:	00 00 00 
  801693:	ff d0                	call   *%rax
    if (res < 0) return res;
  801695:	85 c0                	test   %eax,%eax
  801697:	78 19                	js     8016b2 <serve_flush+0x3b>
    file_flush(o->o_file);
  801699:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80169d:	48 8b 78 08          	mov    0x8(%rax),%rdi
  8016a1:	48 b8 0d 10 80 00 00 	movabs $0x80100d,%rax
  8016a8:	00 00 00 
  8016ab:	ff d0                	call   *%rax
    return 0;
  8016ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016b2:	c9                   	leave
  8016b3:	c3                   	ret

00000000008016b4 <serve_open>:
           void **pg_store, int *perm_store) {
  8016b4:	f3 0f 1e fa          	endbr64
  8016b8:	55                   	push   %rbp
  8016b9:	48 89 e5             	mov    %rsp,%rbp
  8016bc:	41 55                	push   %r13
  8016be:	41 54                	push   %r12
  8016c0:	53                   	push   %rbx
  8016c1:	48 81 ec 18 04 00 00 	sub    $0x418,%rsp
  8016c8:	48 89 f3             	mov    %rsi,%rbx
  8016cb:	49 89 d5             	mov    %rdx,%r13
  8016ce:	49 89 cc             	mov    %rcx,%r12
    memmove(path, req->req_path, MAXPATHLEN);
  8016d1:	ba 00 04 00 00       	mov    $0x400,%edx
  8016d6:	48 8d bd e0 fb ff ff 	lea    -0x420(%rbp),%rdi
  8016dd:	48 b8 81 49 80 00 00 	movabs $0x804981,%rax
  8016e4:	00 00 00 
  8016e7:	ff d0                	call   *%rax
    path[MAXPATHLEN - 1] = 0;
  8016e9:	c6 45 df 00          	movb   $0x0,-0x21(%rbp)
    if ((res = openfile_alloc(&o)) < 0) {
  8016ed:	48 8d bd d0 fb ff ff 	lea    -0x430(%rbp),%rdi
  8016f4:	48 b8 55 13 80 00 00 	movabs $0x801355,%rax
  8016fb:	00 00 00 
  8016fe:	ff d0                	call   *%rax
  801700:	85 c0                	test   %eax,%eax
  801702:	0f 88 fa 00 00 00    	js     801802 <serve_open+0x14e>
    if (req->req_omode & O_CREAT) {
  801708:	f6 83 01 04 00 00 01 	testb  $0x1,0x401(%rbx)
  80170f:	74 34                	je     801745 <serve_open+0x91>
        if ((res = file_create(path, &f)) < 0) {
  801711:	48 8d b5 d8 fb ff ff 	lea    -0x428(%rbp),%rsi
  801718:	48 8d bd e0 fb ff ff 	lea    -0x420(%rbp),%rdi
  80171f:	48 b8 ee 10 80 00 00 	movabs $0x8010ee,%rax
  801726:	00 00 00 
  801729:	ff d0                	call   *%rax
  80172b:	85 c0                	test   %eax,%eax
  80172d:	79 38                	jns    801767 <serve_open+0xb3>
            if (!(req->req_omode & O_EXCL) && res == -E_FILE_EXISTS)
  80172f:	f6 83 01 04 00 00 04 	testb  $0x4,0x401(%rbx)
  801736:	0f 85 c6 00 00 00    	jne    801802 <serve_open+0x14e>
  80173c:	83 f8 ef             	cmp    $0xffffffef,%eax
  80173f:	0f 85 bd 00 00 00    	jne    801802 <serve_open+0x14e>
        if ((res = file_open(path, &f)) < 0) {
  801745:	48 8d b5 d8 fb ff ff 	lea    -0x428(%rbp),%rsi
  80174c:	48 8d bd e0 fb ff ff 	lea    -0x420(%rbp),%rdi
  801753:	48 b8 e6 0c 80 00 00 	movabs $0x800ce6,%rax
  80175a:	00 00 00 
  80175d:	ff d0                	call   *%rax
  80175f:	85 c0                	test   %eax,%eax
  801761:	0f 88 9b 00 00 00    	js     801802 <serve_open+0x14e>
    if (req->req_omode & O_TRUNC) {
  801767:	f6 83 01 04 00 00 02 	testb  $0x2,0x401(%rbx)
  80176e:	74 1c                	je     80178c <serve_open+0xd8>
        if ((res = file_set_size(f, 0)) < 0) {
  801770:	be 00 00 00 00       	mov    $0x0,%esi
  801775:	48 8b bd d8 fb ff ff 	mov    -0x428(%rbp),%rdi
  80177c:	48 b8 e6 0d 80 00 00 	movabs $0x800de6,%rax
  801783:	00 00 00 
  801786:	ff d0                	call   *%rax
  801788:	85 c0                	test   %eax,%eax
  80178a:	78 76                	js     801802 <serve_open+0x14e>
    if ((res = file_open(path, &f)) < 0) {
  80178c:	48 8d b5 d8 fb ff ff 	lea    -0x428(%rbp),%rsi
  801793:	48 8d bd e0 fb ff ff 	lea    -0x420(%rbp),%rdi
  80179a:	48 b8 e6 0c 80 00 00 	movabs $0x800ce6,%rax
  8017a1:	00 00 00 
  8017a4:	ff d0                	call   *%rax
  8017a6:	85 c0                	test   %eax,%eax
  8017a8:	78 58                	js     801802 <serve_open+0x14e>
    o->o_file = f;
  8017aa:	48 8b 95 d0 fb ff ff 	mov    -0x430(%rbp),%rdx
  8017b1:	48 8b 85 d8 fb ff ff 	mov    -0x428(%rbp),%rax
  8017b8:	48 89 42 08          	mov    %rax,0x8(%rdx)
    o->o_fd->fd_file.id = o->o_fileid;
  8017bc:	48 8b 42 18          	mov    0x18(%rdx),%rax
  8017c0:	8b 0a                	mov    (%rdx),%ecx
  8017c2:	89 48 0c             	mov    %ecx,0xc(%rax)
    o->o_fd->fd_omode = req->req_omode & O_ACCMODE;
  8017c5:	48 8b 4a 18          	mov    0x18(%rdx),%rcx
  8017c9:	8b 83 00 04 00 00    	mov    0x400(%rbx),%eax
  8017cf:	83 e0 03             	and    $0x3,%eax
  8017d2:	89 41 08             	mov    %eax,0x8(%rcx)
    o->o_fd->fd_dev_id = devfile.dev_id;
  8017d5:	48 8b 4a 18          	mov    0x18(%rdx),%rcx
  8017d9:	a1 80 c0 80 00 00 00 	movabs 0x80c080,%eax
  8017e0:	00 00 
  8017e2:	89 01                	mov    %eax,(%rcx)
    o->o_mode = req->req_omode;
  8017e4:	8b 83 00 04 00 00    	mov    0x400(%rbx),%eax
  8017ea:	89 42 10             	mov    %eax,0x10(%rdx)
    *pg_store = o->o_fd;
  8017ed:	48 8b 42 18          	mov    0x18(%rdx),%rax
  8017f1:	49 89 45 00          	mov    %rax,0x0(%r13)
    *perm_store = PROT_RW | PROT_SHARE;
  8017f5:	41 c7 04 24 46 00 00 	movl   $0x46,(%r12)
  8017fc:	00 
    return 0;
  8017fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801802:	48 81 c4 18 04 00 00 	add    $0x418,%rsp
  801809:	5b                   	pop    %rbx
  80180a:	41 5c                	pop    %r12
  80180c:	41 5d                	pop    %r13
  80180e:	5d                   	pop    %rbp
  80180f:	c3                   	ret

0000000000801810 <serve>:
        [FSREQ_SET_SIZE] = serve_set_size,
        [FSREQ_SYNC] = serve_sync};
#define NHANDLERS (sizeof(handlers) / sizeof(handlers[0]))

void
serve(void) {
  801810:	f3 0f 1e fa          	endbr64
  801814:	55                   	push   %rbp
  801815:	48 89 e5             	mov    %rsp,%rbp
  801818:	41 56                	push   %r14
  80181a:	41 55                	push   %r13
  80181c:	41 54                	push   %r12
  80181e:	53                   	push   %rbx
  80181f:	48 83 ec 20          	sub    $0x20,%rsp
    void *pg;

    while (1) {
        perm = 0;
        size_t sz = PAGE_SIZE;
        req = ipc_recv((int32_t *)&whom, fsreq, &sz, &perm);
  801823:	48 bb 48 80 80 00 00 	movabs $0x808048,%rbx
  80182a:	00 00 00 
  80182d:	49 bc 43 54 80 00 00 	movabs $0x805443,%r12
  801834:	00 00 00 
            res = handlers[req](whom, fsreq);
        } else {
            cprintf("Invalid request code %d from %08x\n", req, whom);
            res = -E_INVAL;
        }
        ipc_send(whom, res, pg, PAGE_SIZE, perm);
  801837:	49 be dc 54 80 00 00 	movabs $0x8054dc,%r14
  80183e:	00 00 00 
        sys_unmap_region(0, fsreq, PAGE_SIZE);
  801841:	49 bd ab 4e 80 00 00 	movabs $0x804eab,%r13
  801848:	00 00 00 
  80184b:	eb 1e                	jmp    80186b <serve+0x5b>
            cprintf("Invalid request from %08x: no argument page\n", whom);
  80184d:	8b 75 dc             	mov    -0x24(%rbp),%esi
  801850:	48 bf b0 70 80 00 00 	movabs $0x8070b0,%rdi
  801857:	00 00 00 
  80185a:	b8 00 00 00 00       	mov    $0x0,%eax
  80185f:	48 ba 1d 3e 80 00 00 	movabs $0x803e1d,%rdx
  801866:	00 00 00 
  801869:	ff d2                	call   *%rdx
        perm = 0;
  80186b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
        size_t sz = PAGE_SIZE;
  801872:	48 c7 45 c8 00 10 00 	movq   $0x1000,-0x38(%rbp)
  801879:	00 
        req = ipc_recv((int32_t *)&whom, fsreq, &sz, &perm);
  80187a:	48 8b 33             	mov    (%rbx),%rsi
  80187d:	48 8d 4d d8          	lea    -0x28(%rbp),%rcx
  801881:	48 8d 55 c8          	lea    -0x38(%rbp),%rdx
  801885:	48 8d 7d dc          	lea    -0x24(%rbp),%rdi
  801889:	41 ff d4             	call   *%r12
  80188c:	89 c6                	mov    %eax,%esi
        if (!(perm & PROT_R)) {
  80188e:	f6 45 d8 04          	testb  $0x4,-0x28(%rbp)
  801892:	74 b9                	je     80184d <serve+0x3d>
        pg = NULL;
  801894:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  80189b:	00 
        if (req == FSREQ_OPEN) {
  80189c:	83 f8 01             	cmp    $0x1,%eax
  80189f:	74 26                	je     8018c7 <serve+0xb7>
        } else if (req < NHANDLERS && handlers[req]) {
  8018a1:	83 f8 08             	cmp    $0x8,%eax
  8018a4:	77 3f                	ja     8018e5 <serve+0xd5>
  8018a6:	89 c0                	mov    %eax,%eax
  8018a8:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8018af:	00 00 00 
  8018b2:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  8018b6:	48 85 c0             	test   %rax,%rax
  8018b9:	74 2a                	je     8018e5 <serve+0xd5>
            res = handlers[req](whom, fsreq);
  8018bb:	48 8b 33             	mov    (%rbx),%rsi
  8018be:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8018c1:	ff d0                	call   *%rax
  8018c3:	89 c6                	mov    %eax,%esi
  8018c5:	eb 41                	jmp    801908 <serve+0xf8>
            res = serve_open(whom, (struct Fsreq_open *)fsreq, &pg, &perm);
  8018c7:	48 8b 33             	mov    (%rbx),%rsi
  8018ca:	48 8d 4d d8          	lea    -0x28(%rbp),%rcx
  8018ce:	48 8d 55 d0          	lea    -0x30(%rbp),%rdx
  8018d2:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8018d5:	48 b8 b4 16 80 00 00 	movabs $0x8016b4,%rax
  8018dc:	00 00 00 
  8018df:	ff d0                	call   *%rax
  8018e1:	89 c6                	mov    %eax,%esi
  8018e3:	eb 23                	jmp    801908 <serve+0xf8>
            cprintf("Invalid request code %d from %08x\n", req, whom);
  8018e5:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8018e8:	48 bf e0 70 80 00 00 	movabs $0x8070e0,%rdi
  8018ef:	00 00 00 
  8018f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8018f7:	48 b9 1d 3e 80 00 00 	movabs $0x803e1d,%rcx
  8018fe:	00 00 00 
  801901:	ff d1                	call   *%rcx
            res = -E_INVAL;
  801903:	be fd ff ff ff       	mov    $0xfffffffd,%esi
        ipc_send(whom, res, pg, PAGE_SIZE, perm);
  801908:	44 8b 45 d8          	mov    -0x28(%rbp),%r8d
  80190c:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801911:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801915:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801918:	41 ff d6             	call   *%r14
        sys_unmap_region(0, fsreq, PAGE_SIZE);
  80191b:	48 8b 33             	mov    (%rbx),%rsi
  80191e:	ba 00 10 00 00       	mov    $0x1000,%edx
  801923:	bf 00 00 00 00       	mov    $0x0,%edi
  801928:	41 ff d5             	call   *%r13
  80192b:	e9 3b ff ff ff       	jmp    80186b <serve+0x5b>

0000000000801930 <umain>:
    }
}

void
umain(int argc, char **argv) {
  801930:	f3 0f 1e fa          	endbr64
  801934:	55                   	push   %rbp
  801935:	48 89 e5             	mov    %rsp,%rbp
  801938:	41 54                	push   %r12
  80193a:	53                   	push   %rbx
  80193b:	48 89 f3             	mov    %rsi,%rbx
    static_assert(sizeof(struct File) == 256, "Unsupported file size");
    binaryname = "fs";
  80193e:	48 b8 cc 74 80 00 00 	movabs $0x8074cc,%rax
  801945:	00 00 00 
  801948:	48 a3 68 c0 80 00 00 	movabs %rax,0x80c068
  80194f:	00 00 00 
    cprintf("FS is running\n");
  801952:	48 bf cf 74 80 00 00 	movabs $0x8074cf,%rdi
  801959:	00 00 00 
  80195c:	b8 00 00 00 00       	mov    $0x0,%eax
  801961:	49 bc 1d 3e 80 00 00 	movabs $0x803e1d,%r12
  801968:	00 00 00 
  80196b:	41 ff d4             	call   *%r12

    pci_init(argv);
  80196e:	48 89 df             	mov    %rbx,%rdi
  801971:	48 b8 43 2f 80 00 00 	movabs $0x802f43,%rax
  801978:	00 00 00 
  80197b:	ff d0                	call   *%rax
    nvme_init();
  80197d:	48 b8 f0 31 80 00 00 	movabs $0x8031f0,%rax
  801984:	00 00 00 
  801987:	ff d0                	call   *%rax
                 : "cc");
}

static inline void __attribute__((always_inline))
outw(int port, uint16_t data) {
    asm volatile("outw %0,%w1" ::"a"(data), "d"(port));
  801989:	b8 00 8a ff ff       	mov    $0xffff8a00,%eax
  80198e:	ba 00 8a 00 00       	mov    $0x8a00,%edx
  801993:	66 ef                	out    %ax,(%dx)

    /* Check that we are able to do I/O */
    outw(0x8A00, 0x8A00);
    cprintf("FS can do I/O\n");
  801995:	48 bf de 74 80 00 00 	movabs $0x8074de,%rdi
  80199c:	00 00 00 
  80199f:	b8 00 00 00 00       	mov    $0x0,%eax
  8019a4:	41 ff d4             	call   *%r12

    serve_init();
  8019a7:	48 b8 14 13 80 00 00 	movabs $0x801314,%rax
  8019ae:	00 00 00 
  8019b1:	ff d0                	call   *%rax
    fs_init();
  8019b3:	48 b8 5d 08 80 00 00 	movabs $0x80085d,%rax
  8019ba:	00 00 00 
  8019bd:	ff d0                	call   *%rax
    fs_test();
  8019bf:	48 b8 9f 1b 80 00 00 	movabs $0x801b9f,%rax
  8019c6:	00 00 00 
  8019c9:	ff d0                	call   *%rax
    serve();
  8019cb:	48 b8 10 18 80 00 00 	movabs $0x801810,%rax
  8019d2:	00 00 00 
  8019d5:	ff d0                	call   *%rax

00000000008019d7 <check_dir>:
check_consistency(void) {
    check_dir(&super->s_root);
}

void
check_dir(struct File *dir) {
  8019d7:	f3 0f 1e fa          	endbr64
    uint32_t *blk;
    struct File *files;

    blockno_t nblock = dir->f_size / BLKSIZE;
  8019db:	8b 8f 80 00 00 00    	mov    0x80(%rdi),%ecx
  8019e1:	8d 81 ff 0f 00 00    	lea    0xfff(%rcx),%eax
  8019e7:	85 c9                	test   %ecx,%ecx
  8019e9:	0f 49 c1             	cmovns %ecx,%eax
    for (blockno_t i = 0; i < nblock; ++i) {
  8019ec:	c1 f8 0c             	sar    $0xc,%eax
  8019ef:	0f 84 a9 01 00 00    	je     801b9e <check_dir+0x1c7>
check_dir(struct File *dir) {
  8019f5:	55                   	push   %rbp
  8019f6:	48 89 e5             	mov    %rsp,%rbp
  8019f9:	41 57                	push   %r15
  8019fb:	41 56                	push   %r14
  8019fd:	41 55                	push   %r13
  8019ff:	41 54                	push   %r12
  801a01:	53                   	push   %rbx
  801a02:	48 83 ec 28          	sub    $0x28,%rsp
  801a06:	41 89 c5             	mov    %eax,%r13d
    for (blockno_t i = 0; i < nblock; ++i) {
  801a09:	41 bc 00 00 00 00    	mov    $0x0,%r12d
        if (file_block_walk(dir, i, &blk, 0) < 0) continue;
  801a0f:	49 bf c0 08 80 00 00 	movabs $0x8008c0,%r15
  801a16:	00 00 00 
                        check_dir(f);
                    }
                    if (file_block_walk(f, k, &pdiskbno, 0) < 0 || pdiskbno == NULL || *pdiskbno == 0) {
                        continue;
                    }
                    assert(!block_is_free(*pdiskbno));
  801a19:	49 89 fe             	mov    %rdi,%r14
  801a1c:	e9 28 01 00 00       	jmp    801b49 <check_dir+0x172>
                        check_dir(f);
  801a21:	4c 89 e7             	mov    %r12,%rdi
  801a24:	48 b8 d7 19 80 00 00 	movabs $0x8019d7,%rax
  801a2b:	00 00 00 
  801a2e:	ff d0                	call   *%rax
  801a30:	eb 26                	jmp    801a58 <check_dir+0x81>
                for (blockno_t k = 0; k < CEILDIV(f->f_size, BLKSIZE); ++k) {
  801a32:	41 83 c5 01          	add    $0x1,%r13d
  801a36:	49 63 84 24 80 00 00 	movslq 0x80(%r12),%rax
  801a3d:	00 
  801a3e:	48 05 ff 0f 00 00    	add    $0xfff,%rax
  801a44:	48 c1 e8 0c          	shr    $0xc,%rax
  801a48:	41 39 c5             	cmp    %eax,%r13d
  801a4b:	73 75                	jae    801ac2 <check_dir+0xeb>
                    if (f->f_type == FTYPE_DIR) {
  801a4d:	41 83 bc 24 84 00 00 	cmpl   $0x1,0x84(%r12)
  801a54:	00 01 
  801a56:	74 c9                	je     801a21 <check_dir+0x4a>
                    if (file_block_walk(f, k, &pdiskbno, 0) < 0 || pdiskbno == NULL || *pdiskbno == 0) {
  801a58:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a5d:	48 8d 55 c0          	lea    -0x40(%rbp),%rdx
  801a61:	44 89 ee             	mov    %r13d,%esi
  801a64:	4c 89 e7             	mov    %r12,%rdi
  801a67:	41 ff d7             	call   *%r15
  801a6a:	85 c0                	test   %eax,%eax
  801a6c:	78 c4                	js     801a32 <check_dir+0x5b>
  801a6e:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801a72:	48 85 c0             	test   %rax,%rax
  801a75:	74 bb                	je     801a32 <check_dir+0x5b>
  801a77:	8b 38                	mov    (%rax),%edi
  801a79:	85 ff                	test   %edi,%edi
  801a7b:	74 b5                	je     801a32 <check_dir+0x5b>
                    assert(!block_is_free(*pdiskbno));
  801a7d:	48 b8 dd 05 80 00 00 	movabs $0x8005dd,%rax
  801a84:	00 00 00 
  801a87:	ff d0                	call   *%rax
  801a89:	84 c0                	test   %al,%al
  801a8b:	74 a5                	je     801a32 <check_dir+0x5b>
  801a8d:	48 b9 09 75 80 00 00 	movabs $0x807509,%rcx
  801a94:	00 00 00 
  801a97:	48 ba 94 73 80 00 00 	movabs $0x807394,%rdx
  801a9e:	00 00 00 
  801aa1:	be 28 00 00 00       	mov    $0x28,%esi
  801aa6:	48 bf 23 75 80 00 00 	movabs $0x807523,%rdi
  801aad:	00 00 00 
  801ab0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ab5:	49 b8 c1 3c 80 00 00 	movabs $0x803cc1,%r8
  801abc:	00 00 00 
  801abf:	41 ff d0             	call   *%r8
        for (blockno_t j = 0; j < BLKFILES; ++j) {
  801ac2:	48 81 c3 00 01 00 00 	add    $0x100,%rbx
  801ac9:	49 39 de             	cmp    %rbx,%r14
  801acc:	74 66                	je     801b34 <check_dir+0x15d>
            struct File *f = &(files[j]);
  801ace:	49 89 dc             	mov    %rbx,%r12
            if (strcmp(f->f_name, "\0") != 0) {
  801ad1:	48 be 01 7a 80 00 00 	movabs $0x807a01,%rsi
  801ad8:	00 00 00 
  801adb:	48 89 df             	mov    %rbx,%rdi
  801ade:	48 b8 1a 48 80 00 00 	movabs $0x80481a,%rax
  801ae5:	00 00 00 
  801ae8:	ff d0                	call   *%rax
  801aea:	85 c0                	test   %eax,%eax
  801aec:	74 d4                	je     801ac2 <check_dir+0xeb>
                blockno_t *pdiskbno = NULL;
  801aee:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
  801af5:	00 
                cprintf("checking consistency of %s\n", f->f_name);
  801af6:	48 89 de             	mov    %rbx,%rsi
  801af9:	48 bf ed 74 80 00 00 	movabs $0x8074ed,%rdi
  801b00:	00 00 00 
  801b03:	b8 00 00 00 00       	mov    $0x0,%eax
  801b08:	48 ba 1d 3e 80 00 00 	movabs $0x803e1d,%rdx
  801b0f:	00 00 00 
  801b12:	ff d2                	call   *%rdx
                for (blockno_t k = 0; k < CEILDIV(f->f_size, BLKSIZE); ++k) {
  801b14:	48 63 83 80 00 00 00 	movslq 0x80(%rbx),%rax
  801b1b:	48 05 ff 0f 00 00    	add    $0xfff,%rax
  801b21:	48 c1 e8 0c          	shr    $0xc,%rax
  801b25:	85 c0                	test   %eax,%eax
  801b27:	74 99                	je     801ac2 <check_dir+0xeb>
  801b29:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  801b2f:	e9 19 ff ff ff       	jmp    801a4d <check_dir+0x76>
  801b34:	44 8b 65 bc          	mov    -0x44(%rbp),%r12d
  801b38:	4c 8b 75 b0          	mov    -0x50(%rbp),%r14
  801b3c:	44 8b 6d b8          	mov    -0x48(%rbp),%r13d
    for (blockno_t i = 0; i < nblock; ++i) {
  801b40:	41 83 c4 01          	add    $0x1,%r12d
  801b44:	45 39 e5             	cmp    %r12d,%r13d
  801b47:	74 46                	je     801b8f <check_dir+0x1b8>
        if (file_block_walk(dir, i, &blk, 0) < 0) continue;
  801b49:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b4e:	48 8d 55 c8          	lea    -0x38(%rbp),%rdx
  801b52:	44 89 e6             	mov    %r12d,%esi
  801b55:	4c 89 f7             	mov    %r14,%rdi
  801b58:	41 ff d7             	call   *%r15
  801b5b:	85 c0                	test   %eax,%eax
  801b5d:	78 e1                	js     801b40 <check_dir+0x169>
        files = (struct File *)diskaddr(*blk);
  801b5f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801b63:	8b 38                	mov    (%rax),%edi
  801b65:	48 b8 2f 01 80 00 00 	movabs $0x80012f,%rax
  801b6c:	00 00 00 
  801b6f:	ff d0                	call   *%rax
  801b71:	48 89 c3             	mov    %rax,%rbx
        for (blockno_t j = 0; j < BLKFILES; ++j) {
  801b74:	48 8d 80 00 10 00 00 	lea    0x1000(%rax),%rax
            if (strcmp(f->f_name, "\0") != 0) {
  801b7b:	44 89 65 bc          	mov    %r12d,-0x44(%rbp)
  801b7f:	4c 89 75 b0          	mov    %r14,-0x50(%rbp)
  801b83:	49 89 c6             	mov    %rax,%r14
  801b86:	44 89 6d b8          	mov    %r13d,-0x48(%rbp)
  801b8a:	e9 3f ff ff ff       	jmp    801ace <check_dir+0xf7>
                }
            }
        }
    }
}
  801b8f:	48 83 c4 28          	add    $0x28,%rsp
  801b93:	5b                   	pop    %rbx
  801b94:	41 5c                	pop    %r12
  801b96:	41 5d                	pop    %r13
  801b98:	41 5e                	pop    %r14
  801b9a:	41 5f                	pop    %r15
  801b9c:	5d                   	pop    %rbp
  801b9d:	c3                   	ret
  801b9e:	c3                   	ret

0000000000801b9f <fs_test>:

void
fs_test(void) {
  801b9f:	f3 0f 1e fa          	endbr64
  801ba3:	55                   	push   %rbp
  801ba4:	48 89 e5             	mov    %rsp,%rbp
  801ba7:	53                   	push   %rbx
  801ba8:	48 83 ec 18          	sub    $0x18,%rsp
    int r;
    char *blk;
    uint32_t *bits;

    /* Back up bitmap */
    if ((r = sys_alloc_region(0, (void *)PAGE_SIZE, PAGE_SIZE, PROT_RW)) < 0)
  801bac:	b9 06 00 00 00       	mov    $0x6,%ecx
  801bb1:	ba 00 10 00 00       	mov    $0x1000,%edx
  801bb6:	be 00 10 00 00       	mov    $0x1000,%esi
  801bbb:	bf 00 00 00 00       	mov    $0x0,%edi
  801bc0:	48 b8 6b 4d 80 00 00 	movabs $0x804d6b,%rax
  801bc7:	00 00 00 
  801bca:	ff d0                	call   *%rax
  801bcc:	85 c0                	test   %eax,%eax
  801bce:	0f 88 34 03 00 00    	js     801f08 <fs_test+0x369>
        panic("sys_page_alloc: %i", r);
    bits = (uint32_t *)PAGE_SIZE;
    memmove(bits, bitmap, PAGE_SIZE);
  801bd4:	ba 00 10 00 00       	mov    $0x1000,%edx
  801bd9:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  801be0:	00 00 00 
  801be3:	48 8b 30             	mov    (%rax),%rsi
  801be6:	bf 00 10 00 00       	mov    $0x1000,%edi
  801beb:	48 b8 81 49 80 00 00 	movabs $0x804981,%rax
  801bf2:	00 00 00 
  801bf5:	ff d0                	call   *%rax
    /* Allocate block */
    if (!(r = alloc_block()))
  801bf7:	48 b8 78 06 80 00 00 	movabs $0x800678,%rax
  801bfe:	00 00 00 
  801c01:	ff d0                	call   *%rax
  801c03:	89 c1                	mov    %eax,%ecx
  801c05:	85 c0                	test   %eax,%eax
  801c07:	0f 84 28 03 00 00    	je     801f35 <fs_test+0x396>
        panic("alloc_block: %i", -E_NO_DISK);
    /* Check that block was free */
    assert(TSTBIT(bits, r));
  801c0d:	8d 50 1f             	lea    0x1f(%rax),%edx
  801c10:	0f 49 d0             	cmovns %eax,%edx
  801c13:	c1 fa 05             	sar    $0x5,%edx
  801c16:	48 63 d2             	movslq %edx,%rdx
  801c19:	b8 01 00 00 00       	mov    $0x1,%eax
  801c1e:	d3 e0                	shl    %cl,%eax
  801c20:	89 c1                	mov    %eax,%ecx
  801c22:	23 04 95 00 10 00 00 	and    0x1000(,%rdx,4),%eax
  801c29:	0f 84 36 03 00 00    	je     801f65 <fs_test+0x3c6>
    /* And is not free any more */
    assert(!TSTBIT(bitmap, r));
  801c2f:	48 a1 00 d0 80 00 00 	movabs 0x80d000,%rax
  801c36:	00 00 00 
  801c39:	23 0c 90             	and    (%rax,%rdx,4),%ecx
  801c3c:	0f 85 53 03 00 00    	jne    801f95 <fs_test+0x3f6>
    cprintf("alloc_block is good\n");
  801c42:	48 bf 73 75 80 00 00 	movabs $0x807573,%rdi
  801c49:	00 00 00 
  801c4c:	b8 00 00 00 00       	mov    $0x0,%eax
  801c51:	48 bb 1d 3e 80 00 00 	movabs $0x803e1d,%rbx
  801c58:	00 00 00 
  801c5b:	ff d3                	call   *%rbx
    check_dir(&super->s_root);
  801c5d:	48 a1 08 d0 80 00 00 	movabs 0x80d008,%rax
  801c64:	00 00 00 
  801c67:	48 8d 78 08          	lea    0x8(%rax),%rdi
  801c6b:	48 b8 d7 19 80 00 00 	movabs $0x8019d7,%rax
  801c72:	00 00 00 
  801c75:	ff d0                	call   *%rax
    check_consistency();
    cprintf("fs consistency is good\n");
  801c77:	48 bf 88 75 80 00 00 	movabs $0x807588,%rdi
  801c7e:	00 00 00 
  801c81:	b8 00 00 00 00       	mov    $0x0,%eax
  801c86:	ff d3                	call   *%rbx

    if ((r = file_open("/not-found", &f)) < 0 && r != -E_NOT_FOUND)
  801c88:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801c8c:	48 bf a0 75 80 00 00 	movabs $0x8075a0,%rdi
  801c93:	00 00 00 
  801c96:	48 b8 e6 0c 80 00 00 	movabs $0x800ce6,%rax
  801c9d:	00 00 00 
  801ca0:	ff d0                	call   *%rax
  801ca2:	85 c0                	test   %eax,%eax
  801ca4:	0f 88 20 03 00 00    	js     801fca <fs_test+0x42b>
        panic("file_open /not-found: %i", r);
    else if (r == 0)
  801caa:	0f 84 50 03 00 00    	je     802000 <fs_test+0x461>
        panic("file_open /not-found succeeded!");
    if ((r = file_open("/newmotd", &f)) < 0)
  801cb0:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  801cb4:	48 bf c4 75 80 00 00 	movabs $0x8075c4,%rdi
  801cbb:	00 00 00 
  801cbe:	48 b8 e6 0c 80 00 00 	movabs $0x800ce6,%rax
  801cc5:	00 00 00 
  801cc8:	ff d0                	call   *%rax
  801cca:	85 c0                	test   %eax,%eax
  801ccc:	0f 88 53 03 00 00    	js     802025 <fs_test+0x486>
        panic("file_open /newmotd: %i", r);
    cprintf("file_open is good\n");
  801cd2:	48 bf e4 75 80 00 00 	movabs $0x8075e4,%rdi
  801cd9:	00 00 00 
  801cdc:	b8 00 00 00 00       	mov    $0x0,%eax
  801ce1:	48 ba 1d 3e 80 00 00 	movabs $0x803e1d,%rdx
  801ce8:	00 00 00 
  801ceb:	ff d2                	call   *%rdx

    if ((r = file_get_block(f, 0, &blk)) < 0)
  801ced:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  801cf1:	be 00 00 00 00       	mov    $0x0,%esi
  801cf6:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801cfa:	48 b8 9d 09 80 00 00 	movabs $0x80099d,%rax
  801d01:	00 00 00 
  801d04:	ff d0                	call   *%rax
  801d06:	85 c0                	test   %eax,%eax
  801d08:	0f 88 44 03 00 00    	js     802052 <fs_test+0x4b3>
        panic("file_get_block: %i", r);
    if (strcmp(blk, msg) != 0)
  801d0e:	48 be 28 71 80 00 00 	movabs $0x807128,%rsi
  801d15:	00 00 00 
  801d18:	48 8b 7d e0          	mov    -0x20(%rbp),%rdi
  801d1c:	48 b8 1a 48 80 00 00 	movabs $0x80481a,%rax
  801d23:	00 00 00 
  801d26:	ff d0                	call   *%rax
  801d28:	85 c0                	test   %eax,%eax
  801d2a:	0f 85 4f 03 00 00    	jne    80207f <fs_test+0x4e0>
        panic("file_get_block returned wrong data");
    cprintf("file_get_block is good\n");
  801d30:	48 bf 0a 76 80 00 00 	movabs $0x80760a,%rdi
  801d37:	00 00 00 
  801d3a:	b8 00 00 00 00       	mov    $0x0,%eax
  801d3f:	48 ba 1d 3e 80 00 00 	movabs $0x803e1d,%rdx
  801d46:	00 00 00 
  801d49:	ff d2                	call   *%rdx

    *(volatile char *)blk = *(volatile char *)blk;
  801d4b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d4f:	0f b6 10             	movzbl (%rax),%edx
  801d52:	88 10                	mov    %dl,(%rax)
    assert(is_page_dirty(blk));
  801d54:	48 8b 7d e0          	mov    -0x20(%rbp),%rdi
  801d58:	48 b8 db 67 80 00 00 	movabs $0x8067db,%rax
  801d5f:	00 00 00 
  801d62:	ff d0                	call   *%rax
  801d64:	84 c0                	test   %al,%al
  801d66:	0f 84 3d 03 00 00    	je     8020a9 <fs_test+0x50a>
    file_flush(f);
  801d6c:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801d70:	48 b8 0d 10 80 00 00 	movabs $0x80100d,%rax
  801d77:	00 00 00 
  801d7a:	ff d0                	call   *%rax
    assert(!is_page_dirty(blk));
  801d7c:	48 8b 7d e0          	mov    -0x20(%rbp),%rdi
  801d80:	48 b8 db 67 80 00 00 	movabs $0x8067db,%rax
  801d87:	00 00 00 
  801d8a:	ff d0                	call   *%rax
  801d8c:	84 c0                	test   %al,%al
  801d8e:	0f 85 45 03 00 00    	jne    8020d9 <fs_test+0x53a>
    cprintf("file_flush is good\n");
  801d94:	48 bf 36 76 80 00 00 	movabs $0x807636,%rdi
  801d9b:	00 00 00 
  801d9e:	b8 00 00 00 00       	mov    $0x0,%eax
  801da3:	48 ba 1d 3e 80 00 00 	movabs $0x803e1d,%rdx
  801daa:	00 00 00 
  801dad:	ff d2                	call   *%rdx

    if ((r = file_set_size(f, 0)) < 0)
  801daf:	be 00 00 00 00       	mov    $0x0,%esi
  801db4:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801db8:	48 b8 e6 0d 80 00 00 	movabs $0x800de6,%rax
  801dbf:	00 00 00 
  801dc2:	ff d0                	call   *%rax
  801dc4:	85 c0                	test   %eax,%eax
  801dc6:	0f 88 42 03 00 00    	js     80210e <fs_test+0x56f>
        panic("file_set_size: %i", r);
    assert(f->f_direct[0] == 0);
  801dcc:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801dd0:	83 bf 88 00 00 00 00 	cmpl   $0x0,0x88(%rdi)
  801dd7:	0f 85 5e 03 00 00    	jne    80213b <fs_test+0x59c>
    assert(!is_page_dirty(f));
  801ddd:	48 b8 db 67 80 00 00 	movabs $0x8067db,%rax
  801de4:	00 00 00 
  801de7:	ff d0                	call   *%rax
  801de9:	84 c0                	test   %al,%al
  801deb:	0f 85 7f 03 00 00    	jne    802170 <fs_test+0x5d1>
    cprintf("file_truncate is good\n");
  801df1:	48 bf 82 76 80 00 00 	movabs $0x807682,%rdi
  801df8:	00 00 00 
  801dfb:	b8 00 00 00 00       	mov    $0x0,%eax
  801e00:	48 ba 1d 3e 80 00 00 	movabs $0x803e1d,%rdx
  801e07:	00 00 00 
  801e0a:	ff d2                	call   *%rdx

    if ((r = file_set_size(f, strlen(msg))) < 0)
  801e0c:	48 bf 28 71 80 00 00 	movabs $0x807128,%rdi
  801e13:	00 00 00 
  801e16:	48 b8 21 47 80 00 00 	movabs $0x804721,%rax
  801e1d:	00 00 00 
  801e20:	ff d0                	call   *%rax
  801e22:	89 c6                	mov    %eax,%esi
  801e24:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801e28:	48 b8 e6 0d 80 00 00 	movabs $0x800de6,%rax
  801e2f:	00 00 00 
  801e32:	ff d0                	call   *%rax
  801e34:	85 c0                	test   %eax,%eax
  801e36:	0f 88 69 03 00 00    	js     8021a5 <fs_test+0x606>
        panic("file_set_size 2: %i", r);
    assert(!is_page_dirty(f));
  801e3c:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801e40:	48 b8 db 67 80 00 00 	movabs $0x8067db,%rax
  801e47:	00 00 00 
  801e4a:	ff d0                	call   *%rax
  801e4c:	84 c0                	test   %al,%al
  801e4e:	0f 85 7e 03 00 00    	jne    8021d2 <fs_test+0x633>
    if ((r = file_get_block(f, 0, &blk)) < 0)
  801e54:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  801e58:	be 00 00 00 00       	mov    $0x0,%esi
  801e5d:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801e61:	48 b8 9d 09 80 00 00 	movabs $0x80099d,%rax
  801e68:	00 00 00 
  801e6b:	ff d0                	call   *%rax
  801e6d:	85 c0                	test   %eax,%eax
  801e6f:	0f 88 92 03 00 00    	js     802207 <fs_test+0x668>
        panic("file_get_block 2: %i", r);
    strcpy(blk, msg);
  801e75:	48 be 28 71 80 00 00 	movabs $0x807128,%rsi
  801e7c:	00 00 00 
  801e7f:	48 8b 7d e0          	mov    -0x20(%rbp),%rdi
  801e83:	48 b8 66 47 80 00 00 	movabs $0x804766,%rax
  801e8a:	00 00 00 
  801e8d:	ff d0                	call   *%rax
    assert(is_page_dirty(blk));
  801e8f:	48 8b 7d e0          	mov    -0x20(%rbp),%rdi
  801e93:	48 b8 db 67 80 00 00 	movabs $0x8067db,%rax
  801e9a:	00 00 00 
  801e9d:	ff d0                	call   *%rax
  801e9f:	84 c0                	test   %al,%al
  801ea1:	0f 84 8d 03 00 00    	je     802234 <fs_test+0x695>
    file_flush(f);
  801ea7:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801eab:	48 b8 0d 10 80 00 00 	movabs $0x80100d,%rax
  801eb2:	00 00 00 
  801eb5:	ff d0                	call   *%rax
    assert(!is_page_dirty(blk));
  801eb7:	48 8b 7d e0          	mov    -0x20(%rbp),%rdi
  801ebb:	48 b8 db 67 80 00 00 	movabs $0x8067db,%rax
  801ec2:	00 00 00 
  801ec5:	ff d0                	call   *%rax
  801ec7:	84 c0                	test   %al,%al
  801ec9:	0f 85 95 03 00 00    	jne    802264 <fs_test+0x6c5>
    assert(!is_page_dirty(f));
  801ecf:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801ed3:	48 b8 db 67 80 00 00 	movabs $0x8067db,%rax
  801eda:	00 00 00 
  801edd:	ff d0                	call   *%rax
  801edf:	84 c0                	test   %al,%al
  801ee1:	0f 85 b2 03 00 00    	jne    802299 <fs_test+0x6fa>
    cprintf("file rewrite is good\n");
  801ee7:	48 bf c2 76 80 00 00 	movabs $0x8076c2,%rdi
  801eee:	00 00 00 
  801ef1:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef6:	48 ba 1d 3e 80 00 00 	movabs $0x803e1d,%rdx
  801efd:	00 00 00 
  801f00:	ff d2                	call   *%rdx
}
  801f02:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  801f06:	c9                   	leave
  801f07:	c3                   	ret
        panic("sys_page_alloc: %i", r);
  801f08:	89 c1                	mov    %eax,%ecx
  801f0a:	48 ba 2d 75 80 00 00 	movabs $0x80752d,%rdx
  801f11:	00 00 00 
  801f14:	be 38 00 00 00       	mov    $0x38,%esi
  801f19:	48 bf 23 75 80 00 00 	movabs $0x807523,%rdi
  801f20:	00 00 00 
  801f23:	b8 00 00 00 00       	mov    $0x0,%eax
  801f28:	49 b8 c1 3c 80 00 00 	movabs $0x803cc1,%r8
  801f2f:	00 00 00 
  801f32:	41 ff d0             	call   *%r8
        panic("alloc_block: %i", -E_NO_DISK);
  801f35:	b9 f3 ff ff ff       	mov    $0xfffffff3,%ecx
  801f3a:	48 ba 40 75 80 00 00 	movabs $0x807540,%rdx
  801f41:	00 00 00 
  801f44:	be 3d 00 00 00       	mov    $0x3d,%esi
  801f49:	48 bf 23 75 80 00 00 	movabs $0x807523,%rdi
  801f50:	00 00 00 
  801f53:	b8 00 00 00 00       	mov    $0x0,%eax
  801f58:	49 b8 c1 3c 80 00 00 	movabs $0x803cc1,%r8
  801f5f:	00 00 00 
  801f62:	41 ff d0             	call   *%r8
    assert(TSTBIT(bits, r));
  801f65:	48 b9 50 75 80 00 00 	movabs $0x807550,%rcx
  801f6c:	00 00 00 
  801f6f:	48 ba 94 73 80 00 00 	movabs $0x807394,%rdx
  801f76:	00 00 00 
  801f79:	be 3f 00 00 00       	mov    $0x3f,%esi
  801f7e:	48 bf 23 75 80 00 00 	movabs $0x807523,%rdi
  801f85:	00 00 00 
  801f88:	49 b8 c1 3c 80 00 00 	movabs $0x803cc1,%r8
  801f8f:	00 00 00 
  801f92:	41 ff d0             	call   *%r8
    assert(!TSTBIT(bitmap, r));
  801f95:	48 b9 60 75 80 00 00 	movabs $0x807560,%rcx
  801f9c:	00 00 00 
  801f9f:	48 ba 94 73 80 00 00 	movabs $0x807394,%rdx
  801fa6:	00 00 00 
  801fa9:	be 41 00 00 00       	mov    $0x41,%esi
  801fae:	48 bf 23 75 80 00 00 	movabs $0x807523,%rdi
  801fb5:	00 00 00 
  801fb8:	b8 00 00 00 00       	mov    $0x0,%eax
  801fbd:	49 b8 c1 3c 80 00 00 	movabs $0x803cc1,%r8
  801fc4:	00 00 00 
  801fc7:	41 ff d0             	call   *%r8
    if ((r = file_open("/not-found", &f)) < 0 && r != -E_NOT_FOUND)
  801fca:	83 f8 f1             	cmp    $0xfffffff1,%eax
  801fcd:	0f 84 dd fc ff ff    	je     801cb0 <fs_test+0x111>
        panic("file_open /not-found: %i", r);
  801fd3:	89 c1                	mov    %eax,%ecx
  801fd5:	48 ba ab 75 80 00 00 	movabs $0x8075ab,%rdx
  801fdc:	00 00 00 
  801fdf:	be 47 00 00 00       	mov    $0x47,%esi
  801fe4:	48 bf 23 75 80 00 00 	movabs $0x807523,%rdi
  801feb:	00 00 00 
  801fee:	b8 00 00 00 00       	mov    $0x0,%eax
  801ff3:	49 b8 c1 3c 80 00 00 	movabs $0x803cc1,%r8
  801ffa:	00 00 00 
  801ffd:	41 ff d0             	call   *%r8
        panic("file_open /not-found succeeded!");
  802000:	48 ba 08 71 80 00 00 	movabs $0x807108,%rdx
  802007:	00 00 00 
  80200a:	be 49 00 00 00       	mov    $0x49,%esi
  80200f:	48 bf 23 75 80 00 00 	movabs $0x807523,%rdi
  802016:	00 00 00 
  802019:	48 b9 c1 3c 80 00 00 	movabs $0x803cc1,%rcx
  802020:	00 00 00 
  802023:	ff d1                	call   *%rcx
        panic("file_open /newmotd: %i", r);
  802025:	89 c1                	mov    %eax,%ecx
  802027:	48 ba cd 75 80 00 00 	movabs $0x8075cd,%rdx
  80202e:	00 00 00 
  802031:	be 4b 00 00 00       	mov    $0x4b,%esi
  802036:	48 bf 23 75 80 00 00 	movabs $0x807523,%rdi
  80203d:	00 00 00 
  802040:	b8 00 00 00 00       	mov    $0x0,%eax
  802045:	49 b8 c1 3c 80 00 00 	movabs $0x803cc1,%r8
  80204c:	00 00 00 
  80204f:	41 ff d0             	call   *%r8
        panic("file_get_block: %i", r);
  802052:	89 c1                	mov    %eax,%ecx
  802054:	48 ba f7 75 80 00 00 	movabs $0x8075f7,%rdx
  80205b:	00 00 00 
  80205e:	be 4f 00 00 00       	mov    $0x4f,%esi
  802063:	48 bf 23 75 80 00 00 	movabs $0x807523,%rdi
  80206a:	00 00 00 
  80206d:	b8 00 00 00 00       	mov    $0x0,%eax
  802072:	49 b8 c1 3c 80 00 00 	movabs $0x803cc1,%r8
  802079:	00 00 00 
  80207c:	41 ff d0             	call   *%r8
        panic("file_get_block returned wrong data");
  80207f:	48 ba 50 71 80 00 00 	movabs $0x807150,%rdx
  802086:	00 00 00 
  802089:	be 51 00 00 00       	mov    $0x51,%esi
  80208e:	48 bf 23 75 80 00 00 	movabs $0x807523,%rdi
  802095:	00 00 00 
  802098:	b8 00 00 00 00       	mov    $0x0,%eax
  80209d:	48 b9 c1 3c 80 00 00 	movabs $0x803cc1,%rcx
  8020a4:	00 00 00 
  8020a7:	ff d1                	call   *%rcx
    assert(is_page_dirty(blk));
  8020a9:	48 b9 23 76 80 00 00 	movabs $0x807623,%rcx
  8020b0:	00 00 00 
  8020b3:	48 ba 94 73 80 00 00 	movabs $0x807394,%rdx
  8020ba:	00 00 00 
  8020bd:	be 55 00 00 00       	mov    $0x55,%esi
  8020c2:	48 bf 23 75 80 00 00 	movabs $0x807523,%rdi
  8020c9:	00 00 00 
  8020cc:	49 b8 c1 3c 80 00 00 	movabs $0x803cc1,%r8
  8020d3:	00 00 00 
  8020d6:	41 ff d0             	call   *%r8
    assert(!is_page_dirty(blk));
  8020d9:	48 b9 22 76 80 00 00 	movabs $0x807622,%rcx
  8020e0:	00 00 00 
  8020e3:	48 ba 94 73 80 00 00 	movabs $0x807394,%rdx
  8020ea:	00 00 00 
  8020ed:	be 57 00 00 00       	mov    $0x57,%esi
  8020f2:	48 bf 23 75 80 00 00 	movabs $0x807523,%rdi
  8020f9:	00 00 00 
  8020fc:	b8 00 00 00 00       	mov    $0x0,%eax
  802101:	49 b8 c1 3c 80 00 00 	movabs $0x803cc1,%r8
  802108:	00 00 00 
  80210b:	41 ff d0             	call   *%r8
        panic("file_set_size: %i", r);
  80210e:	89 c1                	mov    %eax,%ecx
  802110:	48 ba 4a 76 80 00 00 	movabs $0x80764a,%rdx
  802117:	00 00 00 
  80211a:	be 5b 00 00 00       	mov    $0x5b,%esi
  80211f:	48 bf 23 75 80 00 00 	movabs $0x807523,%rdi
  802126:	00 00 00 
  802129:	b8 00 00 00 00       	mov    $0x0,%eax
  80212e:	49 b8 c1 3c 80 00 00 	movabs $0x803cc1,%r8
  802135:	00 00 00 
  802138:	41 ff d0             	call   *%r8
    assert(f->f_direct[0] == 0);
  80213b:	48 b9 5c 76 80 00 00 	movabs $0x80765c,%rcx
  802142:	00 00 00 
  802145:	48 ba 94 73 80 00 00 	movabs $0x807394,%rdx
  80214c:	00 00 00 
  80214f:	be 5c 00 00 00       	mov    $0x5c,%esi
  802154:	48 bf 23 75 80 00 00 	movabs $0x807523,%rdi
  80215b:	00 00 00 
  80215e:	b8 00 00 00 00       	mov    $0x0,%eax
  802163:	49 b8 c1 3c 80 00 00 	movabs $0x803cc1,%r8
  80216a:	00 00 00 
  80216d:	41 ff d0             	call   *%r8
    assert(!is_page_dirty(f));
  802170:	48 b9 70 76 80 00 00 	movabs $0x807670,%rcx
  802177:	00 00 00 
  80217a:	48 ba 94 73 80 00 00 	movabs $0x807394,%rdx
  802181:	00 00 00 
  802184:	be 5d 00 00 00       	mov    $0x5d,%esi
  802189:	48 bf 23 75 80 00 00 	movabs $0x807523,%rdi
  802190:	00 00 00 
  802193:	b8 00 00 00 00       	mov    $0x0,%eax
  802198:	49 b8 c1 3c 80 00 00 	movabs $0x803cc1,%r8
  80219f:	00 00 00 
  8021a2:	41 ff d0             	call   *%r8
        panic("file_set_size 2: %i", r);
  8021a5:	89 c1                	mov    %eax,%ecx
  8021a7:	48 ba 99 76 80 00 00 	movabs $0x807699,%rdx
  8021ae:	00 00 00 
  8021b1:	be 61 00 00 00       	mov    $0x61,%esi
  8021b6:	48 bf 23 75 80 00 00 	movabs $0x807523,%rdi
  8021bd:	00 00 00 
  8021c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c5:	49 b8 c1 3c 80 00 00 	movabs $0x803cc1,%r8
  8021cc:	00 00 00 
  8021cf:	41 ff d0             	call   *%r8
    assert(!is_page_dirty(f));
  8021d2:	48 b9 70 76 80 00 00 	movabs $0x807670,%rcx
  8021d9:	00 00 00 
  8021dc:	48 ba 94 73 80 00 00 	movabs $0x807394,%rdx
  8021e3:	00 00 00 
  8021e6:	be 62 00 00 00       	mov    $0x62,%esi
  8021eb:	48 bf 23 75 80 00 00 	movabs $0x807523,%rdi
  8021f2:	00 00 00 
  8021f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8021fa:	49 b8 c1 3c 80 00 00 	movabs $0x803cc1,%r8
  802201:	00 00 00 
  802204:	41 ff d0             	call   *%r8
        panic("file_get_block 2: %i", r);
  802207:	89 c1                	mov    %eax,%ecx
  802209:	48 ba ad 76 80 00 00 	movabs $0x8076ad,%rdx
  802210:	00 00 00 
  802213:	be 64 00 00 00       	mov    $0x64,%esi
  802218:	48 bf 23 75 80 00 00 	movabs $0x807523,%rdi
  80221f:	00 00 00 
  802222:	b8 00 00 00 00       	mov    $0x0,%eax
  802227:	49 b8 c1 3c 80 00 00 	movabs $0x803cc1,%r8
  80222e:	00 00 00 
  802231:	41 ff d0             	call   *%r8
    assert(is_page_dirty(blk));
  802234:	48 b9 23 76 80 00 00 	movabs $0x807623,%rcx
  80223b:	00 00 00 
  80223e:	48 ba 94 73 80 00 00 	movabs $0x807394,%rdx
  802245:	00 00 00 
  802248:	be 66 00 00 00       	mov    $0x66,%esi
  80224d:	48 bf 23 75 80 00 00 	movabs $0x807523,%rdi
  802254:	00 00 00 
  802257:	49 b8 c1 3c 80 00 00 	movabs $0x803cc1,%r8
  80225e:	00 00 00 
  802261:	41 ff d0             	call   *%r8
    assert(!is_page_dirty(blk));
  802264:	48 b9 22 76 80 00 00 	movabs $0x807622,%rcx
  80226b:	00 00 00 
  80226e:	48 ba 94 73 80 00 00 	movabs $0x807394,%rdx
  802275:	00 00 00 
  802278:	be 68 00 00 00       	mov    $0x68,%esi
  80227d:	48 bf 23 75 80 00 00 	movabs $0x807523,%rdi
  802284:	00 00 00 
  802287:	b8 00 00 00 00       	mov    $0x0,%eax
  80228c:	49 b8 c1 3c 80 00 00 	movabs $0x803cc1,%r8
  802293:	00 00 00 
  802296:	41 ff d0             	call   *%r8
    assert(!is_page_dirty(f));
  802299:	48 b9 70 76 80 00 00 	movabs $0x807670,%rcx
  8022a0:	00 00 00 
  8022a3:	48 ba 94 73 80 00 00 	movabs $0x807394,%rdx
  8022aa:	00 00 00 
  8022ad:	be 69 00 00 00       	mov    $0x69,%esi
  8022b2:	48 bf 23 75 80 00 00 	movabs $0x807523,%rdi
  8022b9:	00 00 00 
  8022bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8022c1:	49 b8 c1 3c 80 00 00 	movabs $0x803cc1,%r8
  8022c8:	00 00 00 
  8022cb:	41 ff d0             	call   *%r8

00000000008022ce <pci_iop_read_dword>:
    /* Select address for the next PCI access. */
    outl(PCI_PORT_ADDRESS, address);
}

static inline uint32_t
pci_iop_read_dword(struct PciDevice *pcid, uint8_t reg) {
  8022ce:	f3 0f 1e fa          	endbr64
                       ((uint32_t)pcid->bus << 16) |
  8022d2:	0f b6 47 10          	movzbl 0x10(%rdi),%eax
  8022d6:	c1 e0 10             	shl    $0x10,%eax
                       ((uint32_t)pcid->device << 11) |
  8022d9:	0f b6 57 11          	movzbl 0x11(%rdi),%edx
  8022dd:	c1 e2 0b             	shl    $0xb,%edx
                       ((uint32_t)pcid->bus << 16) |
  8022e0:	09 d0                	or     %edx,%eax
                       ((uint32_t)pcid->function << 8) | (reg & 0xFC);
  8022e2:	81 e6 fc 00 00 00    	and    $0xfc,%esi
  8022e8:	09 f0                	or     %esi,%eax
  8022ea:	0f b6 57 12          	movzbl 0x12(%rdi),%edx
  8022ee:	c1 e2 08             	shl    $0x8,%edx
  8022f1:	09 d0                	or     %edx,%eax
    uint32_t address = PCI_PORT_ENABLE_BIT |
  8022f3:	0d 00 00 00 80       	or     $0x80000000,%eax
                 : "cc");
}

static inline void __attribute__((always_inline))
outl(int port, uint32_t data) {
    asm volatile("outl %0,%w1" ::"a"(data), "d"(port));
  8022f8:	ba f8 0c 00 00       	mov    $0xcf8,%edx
  8022fd:	ef                   	out    %eax,(%dx)
    asm volatile("inl %w1,%0"
  8022fe:	ba fc 0c 00 00       	mov    $0xcfc,%edx
  802303:	ed                   	in     (%dx),%eax
     *      and read from PCI_PORT_DATA. */
    // LAB 10: Your code here
    pci_iop_select_address(pcid, reg);
    uint32_t data = inl(PCI_PORT_DATA);
    return data;
}
  802304:	c3                   	ret

0000000000802305 <pci_iop_write_dword>:

static inline void
pci_iop_write_dword(struct PciDevice *pcid, uint8_t reg, uint32_t value) {
  802305:	f3 0f 1e fa          	endbr64
  802309:	89 d1                	mov    %edx,%ecx
                       ((uint32_t)pcid->bus << 16) |
  80230b:	0f b6 47 10          	movzbl 0x10(%rdi),%eax
  80230f:	c1 e0 10             	shl    $0x10,%eax
                       ((uint32_t)pcid->device << 11) |
  802312:	0f b6 57 11          	movzbl 0x11(%rdi),%edx
  802316:	c1 e2 0b             	shl    $0xb,%edx
                       ((uint32_t)pcid->bus << 16) |
  802319:	09 d0                	or     %edx,%eax
                       ((uint32_t)pcid->function << 8) | (reg & 0xFC);
  80231b:	81 e6 fc 00 00 00    	and    $0xfc,%esi
  802321:	09 f0                	or     %esi,%eax
  802323:	0f b6 57 12          	movzbl 0x12(%rdi),%edx
  802327:	c1 e2 08             	shl    $0x8,%edx
  80232a:	09 d0                	or     %edx,%eax
    uint32_t address = PCI_PORT_ENABLE_BIT |
  80232c:	0d 00 00 00 80       	or     $0x80000000,%eax
    asm volatile("outl %0,%w1" ::"a"(data), "d"(port));
  802331:	ba f8 0c 00 00       	mov    $0xcf8,%edx
  802336:	ef                   	out    %eax,(%dx)
  802337:	ba fc 0c 00 00       	mov    $0xcfc,%edx
  80233c:	89 c8                	mov    %ecx,%eax
  80233e:	ef                   	out    %eax,(%dx)
    pci_iop_select_address(pcid, reg);
    /* Write 32-bit value to the selected PCI address */
    outl(PCI_PORT_DATA, value);
}
  80233f:	c3                   	ret

0000000000802340 <pci_ecam_read_word>:
    // LAB 10: Your code here
    return *(volatile uint32_t *)pci_ecam_addr(pcid, reg & 0xffc);
}

static inline uint16_t
pci_ecam_read_word(struct PciDevice *pcid, uint8_t reg) {
  802340:	f3 0f 1e fa          	endbr64
                             ((pcid->bus & 0xFF) << 20) +
  802344:	0f b6 57 10          	movzbl 0x10(%rdi),%edx
  802348:	c1 e2 14             	shl    $0x14,%edx
  80234b:	48 63 d2             	movslq %edx,%rdx
                             (reg & 0xFFF));
  80234e:	81 e6 fe 00 00 00    	and    $0xfe,%esi
                             ((pcid->function & 0x7) << 12) +
  802354:	48 01 f2             	add    %rsi,%rdx
                             ((pcid->device & 0x1F) << 15) +
  802357:	0f b6 47 11          	movzbl 0x11(%rdi),%eax
  80235b:	c1 e0 0f             	shl    $0xf,%eax
  80235e:	25 00 80 0f 00       	and    $0xf8000,%eax
                             ((pcid->function & 0x7) << 12) +
  802363:	48 01 c2             	add    %rax,%rdx
  802366:	0f b6 47 12          	movzbl 0x12(%rdi),%eax
  80236a:	c1 e0 0c             	shl    $0xc,%eax
  80236d:	25 00 70 00 00       	and    $0x7000,%eax
  802372:	48 01 c2             	add    %rax,%rdx
    return (volatile void *)(ecam_base_addr +
  802375:	48 a1 f0 d1 80 00 00 	movabs 0x80d1f0,%rax
  80237c:	00 00 00 
  80237f:	48 01 c2             	add    %rax,%rdx
    return *(volatile uint16_t *)pci_ecam_addr(pcid, reg & 0xffe);
  802382:	0f b7 02             	movzwl (%rdx),%eax
}
  802385:	c3                   	ret

0000000000802386 <parse_hex>:
        return 10 + c - 'A';
    return -1;
}

static unsigned long
parse_hex(char **str) {
  802386:	f3 0f 1e fa          	endbr64
    unsigned long x = 0;
  80238a:	b8 00 00 00 00       	mov    $0x0,%eax
  80238f:	eb 14                	jmp    8023a5 <parse_hex+0x1f>
        return 10 + c - 'a';
  802391:	8d 56 a9             	lea    -0x57(%rsi),%edx
    for (;; (*str)++) {
        int d = to_hexdigit(**str);
        if (d < 0)
            return x;

        x = (x << 4) + d;
  802394:	48 c1 e0 04          	shl    $0x4,%rax
  802398:	48 63 d2             	movslq %edx,%rdx
  80239b:	48 01 d0             	add    %rdx,%rax
    for (;; (*str)++) {
  80239e:	48 83 c1 01          	add    $0x1,%rcx
  8023a2:	48 89 0f             	mov    %rcx,(%rdi)
        int d = to_hexdigit(**str);
  8023a5:	48 8b 0f             	mov    (%rdi),%rcx
  8023a8:	0f be 31             	movsbl (%rcx),%esi
    if (c - '0' <= 9)
  8023ab:	8d 56 d0             	lea    -0x30(%rsi),%edx
  8023ae:	83 fa 09             	cmp    $0x9,%edx
  8023b1:	76 e1                	jbe    802394 <parse_hex+0xe>
    if (c - 'a' <= 'f' - 'a')
  8023b3:	8d 56 9f             	lea    -0x61(%rsi),%edx
  8023b6:	83 fa 05             	cmp    $0x5,%edx
  8023b9:	76 d6                	jbe    802391 <parse_hex+0xb>
    if (c - 'A' <= 'F' - 'A')
  8023bb:	8d 56 bf             	lea    -0x41(%rsi),%edx
  8023be:	83 fa 05             	cmp    $0x5,%edx
  8023c1:	77 05                	ja     8023c8 <parse_hex+0x42>
        return 10 + c - 'A';
  8023c3:	8d 56 c9             	lea    -0x37(%rsi),%edx
  8023c6:	eb cc                	jmp    802394 <parse_hex+0xe>
    }
}
  8023c8:	c3                   	ret

00000000008023c9 <pci_ecam_read_byte>:
pci_ecam_read_byte(struct PciDevice *pcid, uint8_t reg) {
  8023c9:	f3 0f 1e fa          	endbr64
                             ((pcid->bus & 0xFF) << 20) +
  8023cd:	0f b6 57 10          	movzbl 0x10(%rdi),%edx
  8023d1:	c1 e2 14             	shl    $0x14,%edx
  8023d4:	48 63 d2             	movslq %edx,%rdx
                             (reg & 0xFFF));
  8023d7:	40 0f b6 f6          	movzbl %sil,%esi
                             ((pcid->function & 0x7) << 12) +
  8023db:	48 01 f2             	add    %rsi,%rdx
                             ((pcid->device & 0x1F) << 15) +
  8023de:	0f b6 47 11          	movzbl 0x11(%rdi),%eax
  8023e2:	c1 e0 0f             	shl    $0xf,%eax
  8023e5:	25 00 80 0f 00       	and    $0xf8000,%eax
                             ((pcid->function & 0x7) << 12) +
  8023ea:	48 01 c2             	add    %rax,%rdx
  8023ed:	0f b6 47 12          	movzbl 0x12(%rdi),%eax
  8023f1:	c1 e0 0c             	shl    $0xc,%eax
  8023f4:	25 00 70 00 00       	and    $0x7000,%eax
  8023f9:	48 01 c2             	add    %rax,%rdx
    return (volatile void *)(ecam_base_addr +
  8023fc:	48 a1 f0 d1 80 00 00 	movabs 0x80d1f0,%rax
  802403:	00 00 00 
  802406:	48 01 c2             	add    %rax,%rdx
    return *(volatile uint8_t *)pci_ecam_addr(pcid, reg);
  802409:	0f b6 02             	movzbl (%rdx),%eax
}
  80240c:	c3                   	ret

000000000080240d <pci_ecam_write_byte>:
pci_ecam_write_byte(struct PciDevice *pcid, uint8_t reg, uint8_t value) {
  80240d:	f3 0f 1e fa          	endbr64
  802411:	48 89 f8             	mov    %rdi,%rax
  802414:	89 d7                	mov    %edx,%edi
                             ((pcid->bus & 0xFF) << 20) +
  802416:	0f b6 50 10          	movzbl 0x10(%rax),%edx
  80241a:	c1 e2 14             	shl    $0x14,%edx
  80241d:	48 63 d2             	movslq %edx,%rdx
                             (reg & 0xFFF));
  802420:	40 0f b6 f6          	movzbl %sil,%esi
                             ((pcid->function & 0x7) << 12) +
  802424:	48 01 f2             	add    %rsi,%rdx
                             ((pcid->device & 0x1F) << 15) +
  802427:	0f b6 48 11          	movzbl 0x11(%rax),%ecx
  80242b:	c1 e1 0f             	shl    $0xf,%ecx
  80242e:	81 e1 00 80 0f 00    	and    $0xf8000,%ecx
                             ((pcid->function & 0x7) << 12) +
  802434:	48 01 ca             	add    %rcx,%rdx
  802437:	0f b6 40 12          	movzbl 0x12(%rax),%eax
  80243b:	c1 e0 0c             	shl    $0xc,%eax
  80243e:	25 00 70 00 00       	and    $0x7000,%eax
  802443:	48 01 c2             	add    %rax,%rdx
    return (volatile void *)(ecam_base_addr +
  802446:	48 a1 f0 d1 80 00 00 	movabs 0x80d1f0,%rax
  80244d:	00 00 00 
  802450:	48 01 c2             	add    %rax,%rdx
    *(volatile uint8_t *)pci_ecam_addr(pcid, reg) = value;
  802453:	40 88 3a             	mov    %dil,(%rdx)
}
  802456:	c3                   	ret

0000000000802457 <pci_ecam_write_dword>:
pci_ecam_write_dword(struct PciDevice *pcid, uint8_t reg, uint32_t value) {
  802457:	f3 0f 1e fa          	endbr64
  80245b:	48 89 f8             	mov    %rdi,%rax
  80245e:	89 d7                	mov    %edx,%edi
                             ((pcid->bus & 0xFF) << 20) +
  802460:	0f b6 50 10          	movzbl 0x10(%rax),%edx
  802464:	c1 e2 14             	shl    $0x14,%edx
  802467:	48 63 d2             	movslq %edx,%rdx
                             (reg & 0xFFF));
  80246a:	81 e6 fc 00 00 00    	and    $0xfc,%esi
                             ((pcid->function & 0x7) << 12) +
  802470:	48 01 f2             	add    %rsi,%rdx
                             ((pcid->device & 0x1F) << 15) +
  802473:	0f b6 48 11          	movzbl 0x11(%rax),%ecx
  802477:	c1 e1 0f             	shl    $0xf,%ecx
  80247a:	81 e1 00 80 0f 00    	and    $0xf8000,%ecx
                             ((pcid->function & 0x7) << 12) +
  802480:	48 01 ca             	add    %rcx,%rdx
  802483:	0f b6 40 12          	movzbl 0x12(%rax),%eax
  802487:	c1 e0 0c             	shl    $0xc,%eax
  80248a:	25 00 70 00 00       	and    $0x7000,%eax
  80248f:	48 01 c2             	add    %rax,%rdx
    return (volatile void *)(ecam_base_addr +
  802492:	48 a1 f0 d1 80 00 00 	movabs 0x80d1f0,%rax
  802499:	00 00 00 
  80249c:	48 01 c2             	add    %rax,%rdx
    *(volatile uint32_t *)pci_ecam_addr(pcid, reg & 0xffc) = value;
  80249f:	89 3a                	mov    %edi,(%rdx)
}
  8024a1:	c3                   	ret

00000000008024a2 <pci_ecam_write_word>:
pci_ecam_write_word(struct PciDevice *pcid, uint8_t reg, uint16_t value) {
  8024a2:	f3 0f 1e fa          	endbr64
  8024a6:	48 89 f8             	mov    %rdi,%rax
  8024a9:	89 d7                	mov    %edx,%edi
                             ((pcid->bus & 0xFF) << 20) +
  8024ab:	0f b6 50 10          	movzbl 0x10(%rax),%edx
  8024af:	c1 e2 14             	shl    $0x14,%edx
  8024b2:	48 63 d2             	movslq %edx,%rdx
                             (reg & 0xFFF));
  8024b5:	81 e6 fe 00 00 00    	and    $0xfe,%esi
                             ((pcid->function & 0x7) << 12) +
  8024bb:	48 01 f2             	add    %rsi,%rdx
                             ((pcid->device & 0x1F) << 15) +
  8024be:	0f b6 48 11          	movzbl 0x11(%rax),%ecx
  8024c2:	c1 e1 0f             	shl    $0xf,%ecx
  8024c5:	81 e1 00 80 0f 00    	and    $0xf8000,%ecx
                             ((pcid->function & 0x7) << 12) +
  8024cb:	48 01 ca             	add    %rcx,%rdx
  8024ce:	0f b6 40 12          	movzbl 0x12(%rax),%eax
  8024d2:	c1 e0 0c             	shl    $0xc,%eax
  8024d5:	25 00 70 00 00       	and    $0x7000,%eax
  8024da:	48 01 c2             	add    %rax,%rdx
    return (volatile void *)(ecam_base_addr +
  8024dd:	48 a1 f0 d1 80 00 00 	movabs 0x80d1f0,%rax
  8024e4:	00 00 00 
  8024e7:	48 01 c2             	add    %rax,%rdx
    *(volatile uint16_t *)pci_ecam_addr(pcid, reg & 0xffe) = value;
  8024ea:	66 89 3a             	mov    %di,(%rdx)
}
  8024ed:	c3                   	ret

00000000008024ee <pci_ecam_read_dword>:
pci_ecam_read_dword(struct PciDevice *pcid, uint8_t reg) {
  8024ee:	f3 0f 1e fa          	endbr64
                             ((pcid->bus & 0xFF) << 20) +
  8024f2:	0f b6 57 10          	movzbl 0x10(%rdi),%edx
  8024f6:	c1 e2 14             	shl    $0x14,%edx
  8024f9:	48 63 d2             	movslq %edx,%rdx
                             (reg & 0xFFF));
  8024fc:	81 e6 fc 00 00 00    	and    $0xfc,%esi
                             ((pcid->function & 0x7) << 12) +
  802502:	48 01 f2             	add    %rsi,%rdx
                             ((pcid->device & 0x1F) << 15) +
  802505:	0f b6 47 11          	movzbl 0x11(%rdi),%eax
  802509:	c1 e0 0f             	shl    $0xf,%eax
  80250c:	25 00 80 0f 00       	and    $0xf8000,%eax
                             ((pcid->function & 0x7) << 12) +
  802511:	48 01 c2             	add    %rax,%rdx
  802514:	0f b6 47 12          	movzbl 0x12(%rdi),%eax
  802518:	c1 e0 0c             	shl    $0xc,%eax
  80251b:	25 00 70 00 00       	and    $0x7000,%eax
  802520:	48 01 c2             	add    %rax,%rdx
    return (volatile void *)(ecam_base_addr +
  802523:	48 a1 f0 d1 80 00 00 	movabs 0x80d1f0,%rax
  80252a:	00 00 00 
  80252d:	48 01 c2             	add    %rax,%rdx
    return *(volatile uint32_t *)pci_ecam_addr(pcid, reg & 0xffc);
  802530:	8b 02                	mov    (%rdx),%eax
}
  802532:	c3                   	ret

0000000000802533 <pci_iop_read_word>:
pci_iop_read_word(struct PciDevice *pcid, uint8_t reg) {
  802533:	f3 0f 1e fa          	endbr64
  802537:	89 f1                	mov    %esi,%ecx
                       ((uint32_t)pcid->bus << 16) |
  802539:	0f b6 47 10          	movzbl 0x10(%rdi),%eax
  80253d:	c1 e0 10             	shl    $0x10,%eax
                       ((uint32_t)pcid->device << 11) |
  802540:	0f b6 57 11          	movzbl 0x11(%rdi),%edx
  802544:	c1 e2 0b             	shl    $0xb,%edx
                       ((uint32_t)pcid->bus << 16) |
  802547:	09 d0                	or     %edx,%eax
                       ((uint32_t)pcid->function << 8) | (reg & 0xFC);
  802549:	89 f2                	mov    %esi,%edx
  80254b:	81 e2 fc 00 00 00    	and    $0xfc,%edx
  802551:	09 d0                	or     %edx,%eax
  802553:	0f b6 57 12          	movzbl 0x12(%rdi),%edx
  802557:	c1 e2 08             	shl    $0x8,%edx
  80255a:	09 d0                	or     %edx,%eax
    uint32_t address = PCI_PORT_ENABLE_BIT |
  80255c:	0d 00 00 00 80       	or     $0x80000000,%eax
  802561:	ba f8 0c 00 00       	mov    $0xcf8,%edx
  802566:	ef                   	out    %eax,(%dx)
    asm volatile("inl %w1,%0"
  802567:	ba fc 0c 00 00       	mov    $0xcfc,%edx
  80256c:	ed                   	in     (%dx),%eax
    return pci_iop_read_dword(pcid, reg) >> ((reg & 0x2) * 8);
  80256d:	83 e1 02             	and    $0x2,%ecx
  802570:	c1 e1 03             	shl    $0x3,%ecx
  802573:	d3 e8                	shr    %cl,%eax
}
  802575:	c3                   	ret

0000000000802576 <pci_iop_read_byte>:
pci_iop_read_byte(struct PciDevice *pcid, uint8_t reg) {
  802576:	f3 0f 1e fa          	endbr64
  80257a:	89 f1                	mov    %esi,%ecx
                       ((uint32_t)pcid->bus << 16) |
  80257c:	0f b6 47 10          	movzbl 0x10(%rdi),%eax
  802580:	c1 e0 10             	shl    $0x10,%eax
                       ((uint32_t)pcid->device << 11) |
  802583:	0f b6 57 11          	movzbl 0x11(%rdi),%edx
  802587:	c1 e2 0b             	shl    $0xb,%edx
                       ((uint32_t)pcid->bus << 16) |
  80258a:	09 d0                	or     %edx,%eax
                       ((uint32_t)pcid->function << 8) | (reg & 0xFC);
  80258c:	89 f2                	mov    %esi,%edx
  80258e:	81 e2 fc 00 00 00    	and    $0xfc,%edx
  802594:	09 d0                	or     %edx,%eax
  802596:	0f b6 57 12          	movzbl 0x12(%rdi),%edx
  80259a:	c1 e2 08             	shl    $0x8,%edx
  80259d:	09 d0                	or     %edx,%eax
    uint32_t address = PCI_PORT_ENABLE_BIT |
  80259f:	0d 00 00 00 80       	or     $0x80000000,%eax
    asm volatile("outl %0,%w1" ::"a"(data), "d"(port));
  8025a4:	ba f8 0c 00 00       	mov    $0xcf8,%edx
  8025a9:	ef                   	out    %eax,(%dx)
    asm volatile("inl %w1,%0"
  8025aa:	ba fc 0c 00 00       	mov    $0xcfc,%edx
  8025af:	ed                   	in     (%dx),%eax
    return pci_iop_read_dword(pcid, reg) >> ((reg & 0x3) * 8);
  8025b0:	83 e1 03             	and    $0x3,%ecx
  8025b3:	c1 e1 03             	shl    $0x3,%ecx
  8025b6:	d3 e8                	shr    %cl,%eax
}
  8025b8:	c3                   	ret

00000000008025b9 <pci_iop_write_byte>:
pci_iop_write_byte(struct PciDevice *pcid, uint8_t reg, uint8_t value) {
  8025b9:	f3 0f 1e fa          	endbr64
  8025bd:	89 f1                	mov    %esi,%ecx
  8025bf:	41 89 d0             	mov    %edx,%r8d
                       ((uint32_t)pcid->bus << 16) |
  8025c2:	0f b6 77 10          	movzbl 0x10(%rdi),%esi
  8025c6:	c1 e6 10             	shl    $0x10,%esi
                       ((uint32_t)pcid->device << 11) |
  8025c9:	0f b6 47 11          	movzbl 0x11(%rdi),%eax
  8025cd:	c1 e0 0b             	shl    $0xb,%eax
                       ((uint32_t)pcid->bus << 16) |
  8025d0:	09 c6                	or     %eax,%esi
                       ((uint32_t)pcid->function << 8) | (reg & 0xFC);
  8025d2:	89 c8                	mov    %ecx,%eax
  8025d4:	25 fc 00 00 00       	and    $0xfc,%eax
  8025d9:	09 c6                	or     %eax,%esi
  8025db:	0f b6 47 12          	movzbl 0x12(%rdi),%eax
  8025df:	c1 e0 08             	shl    $0x8,%eax
  8025e2:	09 c6                	or     %eax,%esi
    uint32_t address = PCI_PORT_ENABLE_BIT |
  8025e4:	81 ce 00 00 00 80    	or     $0x80000000,%esi
    asm volatile("outl %0,%w1" ::"a"(data), "d"(port));
  8025ea:	41 b9 f8 0c 00 00    	mov    $0xcf8,%r9d
  8025f0:	89 f0                	mov    %esi,%eax
  8025f2:	44 89 ca             	mov    %r9d,%edx
  8025f5:	ef                   	out    %eax,(%dx)
    asm volatile("inl %w1,%0"
  8025f6:	bf fc 0c 00 00       	mov    $0xcfc,%edi
  8025fb:	89 fa                	mov    %edi,%edx
  8025fd:	ed                   	in     (%dx),%eax
  8025fe:	41 89 c2             	mov    %eax,%r10d
    uint8_t shift = ((reg & 0x3) * 8);
  802601:	83 e1 03             	and    $0x3,%ecx
  802604:	c1 e1 03             	shl    $0x3,%ecx
    asm volatile("outl %0,%w1" ::"a"(data), "d"(port));
  802607:	89 f0                	mov    %esi,%eax
  802609:	44 89 ca             	mov    %r9d,%edx
  80260c:	ef                   	out    %eax,(%dx)
    uint32_t old_value = pci_iop_read_dword(pcid, reg) & ~(0xFF << shift);
  80260d:	b8 ff 00 00 00       	mov    $0xff,%eax
  802612:	d3 e0                	shl    %cl,%eax
  802614:	f7 d0                	not    %eax
  802616:	44 21 d0             	and    %r10d,%eax
    uint32_t new_value = value << shift;
  802619:	45 0f b6 c0          	movzbl %r8b,%r8d
  80261d:	41 d3 e0             	shl    %cl,%r8d
    pci_iop_write_dword(pcid, reg, new_value | old_value);
  802620:	44 09 c0             	or     %r8d,%eax
  802623:	89 fa                	mov    %edi,%edx
  802625:	ef                   	out    %eax,(%dx)
}
  802626:	c3                   	ret

0000000000802627 <pci_iop_write_word>:
pci_iop_write_word(struct PciDevice *pcid, uint8_t reg, uint16_t value) {
  802627:	f3 0f 1e fa          	endbr64
  80262b:	89 f1                	mov    %esi,%ecx
  80262d:	41 89 d0             	mov    %edx,%r8d
                       ((uint32_t)pcid->bus << 16) |
  802630:	0f b6 77 10          	movzbl 0x10(%rdi),%esi
  802634:	c1 e6 10             	shl    $0x10,%esi
                       ((uint32_t)pcid->device << 11) |
  802637:	0f b6 47 11          	movzbl 0x11(%rdi),%eax
  80263b:	c1 e0 0b             	shl    $0xb,%eax
                       ((uint32_t)pcid->bus << 16) |
  80263e:	09 c6                	or     %eax,%esi
                       ((uint32_t)pcid->function << 8) | (reg & 0xFC);
  802640:	89 c8                	mov    %ecx,%eax
  802642:	25 fc 00 00 00       	and    $0xfc,%eax
  802647:	09 c6                	or     %eax,%esi
  802649:	0f b6 47 12          	movzbl 0x12(%rdi),%eax
  80264d:	c1 e0 08             	shl    $0x8,%eax
  802650:	09 c6                	or     %eax,%esi
    uint32_t address = PCI_PORT_ENABLE_BIT |
  802652:	81 ce 00 00 00 80    	or     $0x80000000,%esi
  802658:	41 b9 f8 0c 00 00    	mov    $0xcf8,%r9d
  80265e:	89 f0                	mov    %esi,%eax
  802660:	44 89 ca             	mov    %r9d,%edx
  802663:	ef                   	out    %eax,(%dx)
    asm volatile("inl %w1,%0"
  802664:	bf fc 0c 00 00       	mov    $0xcfc,%edi
  802669:	89 fa                	mov    %edi,%edx
  80266b:	ed                   	in     (%dx),%eax
  80266c:	41 89 c2             	mov    %eax,%r10d
    uint8_t shift = ((reg & 0x2) * 8);
  80266f:	83 e1 02             	and    $0x2,%ecx
  802672:	c1 e1 03             	shl    $0x3,%ecx
    asm volatile("outl %0,%w1" ::"a"(data), "d"(port));
  802675:	89 f0                	mov    %esi,%eax
  802677:	44 89 ca             	mov    %r9d,%edx
  80267a:	ef                   	out    %eax,(%dx)
    uint32_t old_value = pci_iop_read_dword(pcid, reg) & ~(0xFFFF << shift);
  80267b:	b8 ff ff 00 00       	mov    $0xffff,%eax
  802680:	d3 e0                	shl    %cl,%eax
  802682:	f7 d0                	not    %eax
  802684:	44 21 d0             	and    %r10d,%eax
    uint32_t new_value = value << shift;
  802687:	45 0f b7 c0          	movzwl %r8w,%r8d
  80268b:	41 d3 e0             	shl    %cl,%r8d
    pci_iop_write_dword(pcid, reg, new_value | old_value);
  80268e:	44 09 c0             	or     %r8d,%eax
  802691:	89 fa                	mov    %edi,%edx
  802693:	ef                   	out    %eax,(%dx)
}
  802694:	c3                   	ret

0000000000802695 <init_pci_device>:
init_pci_device(uint8_t bus, uint8_t device, uint8_t function) {
  802695:	f3 0f 1e fa          	endbr64
  802699:	55                   	push   %rbp
  80269a:	48 89 e5             	mov    %rsp,%rbp
  80269d:	41 57                	push   %r15
  80269f:	41 56                	push   %r14
  8026a1:	41 55                	push   %r13
  8026a3:	41 54                	push   %r12
  8026a5:	53                   	push   %rbx
  8026a6:	48 83 ec 78          	sub    $0x78,%rsp
  8026aa:	41 89 ff             	mov    %edi,%r15d
    struct PciDevice tmp_dev = {.bus = bus, .device = device, .function = function};
  8026ad:	48 8d bd 78 ff ff ff 	lea    -0x88(%rbp),%rdi
  8026b4:	b9 0b 00 00 00       	mov    $0xb,%ecx
  8026b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8026be:	f3 48 ab             	rep stos %rax,%es:(%rdi)
  8026c1:	44 88 7d 88          	mov    %r15b,-0x78(%rbp)
  8026c5:	89 b5 6c ff ff ff    	mov    %esi,-0x94(%rbp)
  8026cb:	40 88 75 89          	mov    %sil,-0x77(%rbp)
  8026cf:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%rbp)
  8026d5:	88 55 8a             	mov    %dl,-0x76(%rbp)
    uint16_t vendor_id = pcie_io.read16(&tmp_dev, PCI_REG_VENDOR_ID);
  8026d8:	be 00 00 00 00       	mov    $0x0,%esi
  8026dd:	48 8d bd 78 ff ff ff 	lea    -0x88(%rbp),%rdi
  8026e4:	48 a1 c8 d1 80 00 00 	movabs 0x80d1c8,%rax
  8026eb:	00 00 00 
  8026ee:	ff d0                	call   *%rax
    if (vendor_id == PCI_DEVICE_VENDOR_NONE)
  8026f0:	66 83 f8 ff          	cmp    $0xffff,%ax
  8026f4:	0f 84 b6 02 00 00    	je     8029b0 <init_pci_device+0x31b>
    if (pcidev_cnt >= PCI_MAX_DEVICES)
  8026fa:	a1 20 d0 80 00 00 00 	movabs 0x80d020,%eax
  802701:	00 00 
  802703:	83 f8 09             	cmp    $0x9,%eax
  802706:	0f 8f bc 02 00 00    	jg     8029c8 <init_pci_device+0x333>
    return &pci_device_buffer[pcidev_cnt++];
  80270c:	89 c1                	mov    %eax,%ecx
  80270e:	8d 40 01             	lea    0x1(%rax),%eax
  802711:	a3 20 d0 80 00 00 00 	movabs %eax,0x80d020
  802718:	00 00 
  80271a:	89 8d 68 ff ff ff    	mov    %ecx,-0x98(%rbp)
  802720:	4c 63 e1             	movslq %ecx,%r12
  802723:	4b 8d 1c a4          	lea    (%r12,%r12,4),%rbx
  802727:	48 01 db             	add    %rbx,%rbx
  80272a:	4a 8d 04 23          	lea    (%rbx,%r12,1),%rax
  80272e:	49 bd 00 d2 80 00 00 	movabs $0x80d200,%r13
  802735:	00 00 00 
  802738:	4d 8d 74 c5 00       	lea    0x0(%r13,%rax,8),%r14
    memset(pcid, 0, sizeof(*pcid));
  80273d:	ba 58 00 00 00       	mov    $0x58,%edx
  802742:	be 00 00 00 00       	mov    $0x0,%esi
  802747:	4c 89 f7             	mov    %r14,%rdi
  80274a:	48 b8 c7 48 80 00 00 	movabs $0x8048c7,%rax
  802751:	00 00 00 
  802754:	ff d0                	call   *%rax
    pcid->bus = bus;
  802756:	4a 8d 04 23          	lea    (%rbx,%r12,1),%rax
  80275a:	45 88 7c c5 10       	mov    %r15b,0x10(%r13,%rax,8)
    pcid->device = device;
  80275f:	0f b6 bd 6c ff ff ff 	movzbl -0x94(%rbp),%edi
  802766:	41 88 7c c5 11       	mov    %dil,0x11(%r13,%rax,8)
    pcid->function = function;
  80276b:	0f b6 bd 60 ff ff ff 	movzbl -0xa0(%rbp),%edi
  802772:	41 88 7c c5 12       	mov    %dil,0x12(%r13,%rax,8)
    pcid->vendor_id = pcie_io.read16(pcid, PCI_REG_VENDOR_ID);
  802777:	49 bf c0 d1 80 00 00 	movabs $0x80d1c0,%r15
  80277e:	00 00 00 
  802781:	be 00 00 00 00       	mov    $0x0,%esi
  802786:	4c 89 f7             	mov    %r14,%rdi
  802789:	41 ff 57 08          	call   *0x8(%r15)
  80278d:	89 c2                	mov    %eax,%edx
  80278f:	4a 8d 04 23          	lea    (%rbx,%r12,1),%rax
  802793:	66 41 89 54 c5 14    	mov    %dx,0x14(%r13,%rax,8)
    pcid->device_id = pcie_io.read16(pcid, PCI_REG_DEVICE_ID);
  802799:	be 02 00 00 00       	mov    $0x2,%esi
  80279e:	4c 89 f7             	mov    %r14,%rdi
  8027a1:	41 ff 57 08          	call   *0x8(%r15)
  8027a5:	89 c2                	mov    %eax,%edx
  8027a7:	4a 8d 04 23          	lea    (%rbx,%r12,1),%rax
  8027ab:	66 41 89 54 c5 16    	mov    %dx,0x16(%r13,%rax,8)
    pcid->subvendor_id = pcie_io.read16(pcid, PCI_REG_SUB_VENDOR_ID);
  8027b1:	be 2c 00 00 00       	mov    $0x2c,%esi
  8027b6:	4c 89 f7             	mov    %r14,%rdi
  8027b9:	41 ff 57 08          	call   *0x8(%r15)
  8027bd:	89 c2                	mov    %eax,%edx
  8027bf:	4a 8d 04 23          	lea    (%rbx,%r12,1),%rax
  8027c3:	66 41 89 54 c5 18    	mov    %dx,0x18(%r13,%rax,8)
    pcid->subdevice_id = pcie_io.read16(pcid, PCI_REG_SUB_DEVICE_ID);
  8027c9:	be 2e 00 00 00       	mov    $0x2e,%esi
  8027ce:	4c 89 f7             	mov    %r14,%rdi
  8027d1:	41 ff 57 08          	call   *0x8(%r15)
  8027d5:	89 c2                	mov    %eax,%edx
  8027d7:	4a 8d 04 23          	lea    (%rbx,%r12,1),%rax
  8027db:	66 41 89 54 c5 1a    	mov    %dx,0x1a(%r13,%rax,8)
    pcid->revision_id = pcie_io.read8(pcid, PCI_REG_REVISION_ID);
  8027e1:	be 08 00 00 00       	mov    $0x8,%esi
  8027e6:	4c 89 f7             	mov    %r14,%rdi
  8027e9:	41 ff 57 10          	call   *0x10(%r15)
  8027ed:	89 c2                	mov    %eax,%edx
  8027ef:	4a 8d 04 23          	lea    (%rbx,%r12,1),%rax
  8027f3:	41 88 54 c5 1c       	mov    %dl,0x1c(%r13,%rax,8)
    pcid->class = pcie_io.read8(pcid, PCI_REG_CLASS);
  8027f8:	be 0b 00 00 00       	mov    $0xb,%esi
  8027fd:	4c 89 f7             	mov    %r14,%rdi
  802800:	41 ff 57 10          	call   *0x10(%r15)
  802804:	89 c2                	mov    %eax,%edx
  802806:	4a 8d 04 23          	lea    (%rbx,%r12,1),%rax
  80280a:	41 88 54 c5 1d       	mov    %dl,0x1d(%r13,%rax,8)
    pcid->subclass = pcie_io.read8(pcid, PCI_REG_SUBCLASS);
  80280f:	be 0a 00 00 00       	mov    $0xa,%esi
  802814:	4c 89 f7             	mov    %r14,%rdi
  802817:	41 ff 57 10          	call   *0x10(%r15)
  80281b:	89 c2                	mov    %eax,%edx
  80281d:	4a 8d 04 23          	lea    (%rbx,%r12,1),%rax
  802821:	41 88 54 c5 1e       	mov    %dl,0x1e(%r13,%rax,8)
    pcid->interface = pcie_io.read8(pcid, PCI_REG_PROG_IF);
  802826:	be 09 00 00 00       	mov    $0x9,%esi
  80282b:	4c 89 f7             	mov    %r14,%rdi
  80282e:	41 ff 57 10          	call   *0x10(%r15)
  802832:	89 c2                	mov    %eax,%edx
  802834:	4a 8d 04 23          	lea    (%rbx,%r12,1),%rax
  802838:	41 88 54 c5 1f       	mov    %dl,0x1f(%r13,%rax,8)
    pcid->header_type = pcie_io.read8(pcid, PCI_REG_HEADER_TYPE);
  80283d:	be 0e 00 00 00       	mov    $0xe,%esi
  802842:	4c 89 f7             	mov    %r14,%rdi
  802845:	41 ff 57 10          	call   *0x10(%r15)
  802849:	89 c2                	mov    %eax,%edx
  80284b:	4a 8d 04 23          	lea    (%rbx,%r12,1),%rax
  80284f:	41 88 54 c5 20       	mov    %dl,0x20(%r13,%rax,8)
    pcid->interrupt_pin = pcie_io.read8(pcid, PCI_REG_INTERRUPT_PIN);
  802854:	be 3d 00 00 00       	mov    $0x3d,%esi
  802859:	4c 89 f7             	mov    %r14,%rdi
  80285c:	41 ff 57 10          	call   *0x10(%r15)
  802860:	89 c2                	mov    %eax,%edx
  802862:	4a 8d 04 23          	lea    (%rbx,%r12,1),%rax
  802866:	41 88 54 c5 54       	mov    %dl,0x54(%r13,%rax,8)
    pcid->interrupt_line = pcie_io.read8(pcid, PCI_REG_INTERRUPT_LINE);
  80286b:	be 3c 00 00 00       	mov    $0x3c,%esi
  802870:	4c 89 f7             	mov    %r14,%rdi
  802873:	41 ff 57 10          	call   *0x10(%r15)
  802877:	89 c2                	mov    %eax,%edx
  802879:	4a 8d 04 23          	lea    (%rbx,%r12,1),%rax
  80287d:	41 88 54 c5 55       	mov    %dl,0x55(%r13,%rax,8)
    pcid->interrupt_no = 0;
  802882:	41 c6 44 c5 56 00    	movb   $0x0,0x56(%r13,%rax,8)
    for (uint8_t i = 0; i < PCI_BAR_COUNT; i++) {
  802888:	bb 00 00 00 00       	mov    $0x0,%ebx
        pcid->bars[i].port_mapped = (bar & PCI_BAR_TYPE_PORT) != 0;
  80288d:	4d 89 ec             	mov    %r13,%r12
  802890:	48 63 85 68 ff ff ff 	movslq -0x98(%rbp),%rax
  802897:	48 8d 14 80          	lea    (%rax,%rax,4),%rdx
  80289b:	4c 8d 3c 50          	lea    (%rax,%rdx,2),%r15
  80289f:	e9 ae 00 00 00       	jmp    802952 <init_pci_device+0x2bd>
            pcid->bars[i].base_address = bar & PCI_BAR_MEMORY_MASK;
  8028a4:	49 63 d5             	movslq %r13d,%rdx
  8028a7:	49 8d 74 17 04       	lea    0x4(%r15,%rdx,1),%rsi
  8028ac:	89 c2                	mov    %eax,%edx
  8028ae:	83 e2 f0             	and    $0xfffffff0,%edx
  8028b1:	41 89 54 f4 08       	mov    %edx,0x8(%r12,%rsi,8)
            pcid->bars[i].address_is_64bits = (bar & PCI_BAR_BITS64) != 0;
  8028b6:	89 c1                	mov    %eax,%ecx
  8028b8:	c1 e9 02             	shr    $0x2,%ecx
  8028bb:	83 e1 01             	and    $0x1,%ecx
  8028be:	01 c9                	add    %ecx,%ecx
  8028c0:	41 0f b6 54 f4 04    	movzbl 0x4(%r12,%rsi,8),%edx
  8028c6:	83 e2 f9             	and    $0xfffffff9,%edx
            pcid->bars[i].prefetchable = (bar & PCI_BAR_PREFETCHABLE) != 0;
  8028c9:	c1 e8 03             	shr    $0x3,%eax
  8028cc:	83 e0 01             	and    $0x1,%eax
  8028cf:	c1 e0 02             	shl    $0x2,%eax
  8028d2:	09 ca                	or     %ecx,%edx
  8028d4:	09 d0                	or     %edx,%eax
  8028d6:	41 88 44 f4 04       	mov    %al,0x4(%r12,%rsi,8)
            if (pcid->bars[i].address_is_64bits) {
  8028db:	a8 02                	test   $0x2,%al
  8028dd:	74 6b                	je     80294a <init_pci_device+0x2b5>
                pcid->bars[i + 1].address_is_64bits = 1;
  8028df:	41 8d 45 01          	lea    0x1(%r13),%eax
  8028e3:	48 98                	cltq
  8028e5:	49 8d 7c 07 04       	lea    0x4(%r15,%rax,1),%rdi
  8028ea:	48 89 bd 60 ff ff ff 	mov    %rdi,-0xa0(%rbp)
  8028f1:	41 80 4c fc 04 02    	orb    $0x2,0x4(%r12,%rdi,8)
                pcid->bars[i + 1].base_address = pcie_io.read32(pcid, PCI_REG_BAR0 + ((i + 1) * sizeof(uint32_t)));
  8028f7:	0f b6 b5 6c ff ff ff 	movzbl -0x94(%rbp),%esi
  8028fe:	83 c6 04             	add    $0x4,%esi
  802901:	40 0f b6 f6          	movzbl %sil,%esi
  802905:	4c 89 f7             	mov    %r14,%rdi
  802908:	48 b8 c0 d1 80 00 00 	movabs $0x80d1c0,%rax
  80290f:	00 00 00 
  802912:	ff 10                	call   *(%rax)
  802914:	48 8b bd 60 ff ff ff 	mov    -0xa0(%rbp),%rdi
  80291b:	41 89 44 fc 08       	mov    %eax,0x8(%r12,%rdi,8)
                pcid->bars[i + 1].prefetchable = pcid->bars[i].prefetchable;
  802920:	4d 63 ed             	movslq %r13d,%r13
  802923:	4b 8d 44 2f 04       	lea    0x4(%r15,%r13,1),%rax
  802928:	41 0f b6 54 c4 04    	movzbl 0x4(%r12,%rax,8),%edx
  80292e:	83 e2 04             	and    $0x4,%edx
  802931:	41 0f b6 44 fc 04    	movzbl 0x4(%r12,%rdi,8),%eax
  802937:	88 85 6c ff ff ff    	mov    %al,-0x94(%rbp)
  80293d:	83 e0 fb             	and    $0xfffffffb,%eax
  802940:	09 d0                	or     %edx,%eax
  802942:	41 88 44 fc 04       	mov    %al,0x4(%r12,%rdi,8)
                i++;
  802947:	83 c3 01             	add    $0x1,%ebx
    for (uint8_t i = 0; i < PCI_BAR_COUNT; i++) {
  80294a:	83 c3 01             	add    $0x1,%ebx
  80294d:	80 fb 05             	cmp    $0x5,%bl
  802950:	77 64                	ja     8029b6 <init_pci_device+0x321>
        uint32_t bar = pcie_io.read32(pcid, PCI_REG_BAR0 + (i * sizeof(uint32_t)));
  802952:	8d 04 9d 10 00 00 00 	lea    0x10(,%rbx,4),%eax
  802959:	88 85 6c ff ff ff    	mov    %al,-0x94(%rbp)
  80295f:	0f b6 f0             	movzbl %al,%esi
  802962:	4c 89 f7             	mov    %r14,%rdi
  802965:	48 b8 c0 d1 80 00 00 	movabs $0x80d1c0,%rax
  80296c:	00 00 00 
  80296f:	ff 10                	call   *(%rax)
        pcid->bars[i].port_mapped = (bar & PCI_BAR_TYPE_PORT) != 0;
  802971:	44 0f b6 eb          	movzbl %bl,%r13d
  802975:	0f b6 d3             	movzbl %bl,%edx
  802978:	4a 8d 4c 3a 04       	lea    0x4(%rdx,%r15,1),%rcx
  80297d:	89 c6                	mov    %eax,%esi
  80297f:	83 e6 01             	and    $0x1,%esi
  802982:	40 0f 95 c7          	setne  %dil
  802986:	41 0f b6 54 cc 04    	movzbl 0x4(%r12,%rcx,8),%edx
  80298c:	83 e2 fe             	and    $0xfffffffe,%edx
  80298f:	09 fa                	or     %edi,%edx
  802991:	41 88 54 cc 04       	mov    %dl,0x4(%r12,%rcx,8)
        if (pcid->bars[i].port_mapped) {
  802996:	85 f6                	test   %esi,%esi
  802998:	0f 84 06 ff ff ff    	je     8028a4 <init_pci_device+0x20f>
            pcid->bars[i].base_address = bar & PCI_BAR_PORT_MASK;
  80299e:	4d 63 ed             	movslq %r13d,%r13
  8029a1:	4b 8d 54 2f 04       	lea    0x4(%r15,%r13,1),%rdx
  8029a6:	83 e0 fc             	and    $0xfffffffc,%eax
  8029a9:	41 89 44 d4 08       	mov    %eax,0x8(%r12,%rdx,8)
  8029ae:	eb 9a                	jmp    80294a <init_pci_device+0x2b5>
        return NULL;
  8029b0:	41 be 00 00 00 00    	mov    $0x0,%r14d
}
  8029b6:	4c 89 f0             	mov    %r14,%rax
  8029b9:	48 83 c4 78          	add    $0x78,%rsp
  8029bd:	5b                   	pop    %rbx
  8029be:	41 5c                	pop    %r12
  8029c0:	41 5d                	pop    %r13
  8029c2:	41 5e                	pop    %r14
  8029c4:	41 5f                	pop    %r15
  8029c6:	5d                   	pop    %rbp
  8029c7:	c3                   	ret
        return NULL;
  8029c8:	41 be 00 00 00 00    	mov    $0x0,%r14d
  8029ce:	eb e6                	jmp    8029b6 <init_pci_device+0x321>

00000000008029d0 <pci_check_busses>:
pci_check_busses(uint8_t bus, struct PciDevice *parent) {
  8029d0:	f3 0f 1e fa          	endbr64
  8029d4:	55                   	push   %rbp
  8029d5:	48 89 e5             	mov    %rsp,%rbp
  8029d8:	41 57                	push   %r15
  8029da:	41 56                	push   %r14
  8029dc:	41 55                	push   %r13
  8029de:	41 54                	push   %r12
  8029e0:	53                   	push   %rbx
  8029e1:	48 83 ec 18          	sub    $0x18,%rsp
  8029e5:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  8029e9:	41 bc 00 00 00 00    	mov    $0x0,%r12d
        struct PciDevice *pcid = init_pci_device(bus, device, 0);
  8029ef:	40 0f b6 c7          	movzbl %dil,%eax
  8029f3:	89 45 cc             	mov    %eax,-0x34(%rbp)
  8029f6:	49 bf 95 26 80 00 00 	movabs $0x802695,%r15
  8029fd:	00 00 00 
    pcid->next = pci_device_list;
  802a00:	49 be 70 d5 80 00 00 	movabs $0x80d570,%r14
  802a07:	00 00 00 
  802a0a:	eb 40                	jmp    802a4c <pci_check_busses+0x7c>
  802a0c:	41 bd 01 00 00 00    	mov    $0x1,%r13d
  802a12:	eb 1b                	jmp    802a2f <pci_check_busses+0x5f>
    pcid->parent = parent;
  802a14:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  802a18:	48 89 08             	mov    %rcx,(%rax)
    pcid->next = pci_device_list;
  802a1b:	49 8b 16             	mov    (%r14),%rdx
  802a1e:	48 89 50 08          	mov    %rdx,0x8(%rax)
    pci_device_list = pcid;
  802a22:	49 89 06             	mov    %rax,(%r14)
            for (uint8_t func = 1; func < PCI_NUM_FUNCTIONS; func++) {
  802a25:	41 83 c5 01          	add    $0x1,%r13d
  802a29:	41 83 fd 08          	cmp    $0x8,%r13d
  802a2d:	74 4e                	je     802a7d <pci_check_busses+0xad>
                struct PciDevice *func_dev = init_pci_device(bus, device, func);
  802a2f:	44 89 ea             	mov    %r13d,%edx
  802a32:	8b 75 c8             	mov    -0x38(%rbp),%esi
  802a35:	8b 7d cc             	mov    -0x34(%rbp),%edi
  802a38:	41 ff d7             	call   *%r15
                if (!func_dev)
  802a3b:	48 85 c0             	test   %rax,%rax
  802a3e:	75 d4                	jne    802a14 <pci_check_busses+0x44>
  802a40:	eb e3                	jmp    802a25 <pci_check_busses+0x55>
    for (uint8_t device = 0; device < PCI_NUM_DEVICES; device++) {
  802a42:	41 83 c4 01          	add    $0x1,%r12d
  802a46:	41 83 fc 20          	cmp    $0x20,%r12d
  802a4a:	74 68                	je     802ab4 <pci_check_busses+0xe4>
        struct PciDevice *pcid = init_pci_device(bus, device, 0);
  802a4c:	44 89 65 c8          	mov    %r12d,-0x38(%rbp)
  802a50:	ba 00 00 00 00       	mov    $0x0,%edx
  802a55:	44 89 e6             	mov    %r12d,%esi
  802a58:	8b 7d cc             	mov    -0x34(%rbp),%edi
  802a5b:	41 ff d7             	call   *%r15
  802a5e:	48 89 c3             	mov    %rax,%rbx
        if (!pcid)
  802a61:	48 85 c0             	test   %rax,%rax
  802a64:	74 dc                	je     802a42 <pci_check_busses+0x72>
    pcid->parent = parent;
  802a66:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802a6a:	48 89 03             	mov    %rax,(%rbx)
    pcid->next = pci_device_list;
  802a6d:	49 8b 06             	mov    (%r14),%rax
  802a70:	48 89 43 08          	mov    %rax,0x8(%rbx)
    pci_device_list = pcid;
  802a74:	49 89 1e             	mov    %rbx,(%r14)
        if (pcid->header_type & PCI_HEADER_TYPE_MULTIFUNC) {
  802a77:	80 7b 20 00          	cmpb   $0x0,0x20(%rbx)
  802a7b:	78 8f                	js     802a0c <pci_check_busses+0x3c>
        if (pcid->class == PCI_CLASS_BRIDGE && pcid->subclass == PCI_SUBCLASS_BRIDGE_PCI) {
  802a7d:	8b 43 1c             	mov    0x1c(%rbx),%eax
  802a80:	25 00 ff ff 00       	and    $0xffff00,%eax
  802a85:	3d 00 06 04 00       	cmp    $0x40600,%eax
  802a8a:	75 b6                	jne    802a42 <pci_check_busses+0x72>
            uint16_t baread2 = pcie_io.read16(pcid, PCI_REG_BAR2);
  802a8c:	be 18 00 00 00       	mov    $0x18,%esi
  802a91:	48 89 df             	mov    %rbx,%rdi
  802a94:	48 a1 c8 d1 80 00 00 	movabs 0x80d1c8,%rax
  802a9b:	00 00 00 
  802a9e:	ff d0                	call   *%rax
            uint16_t secondary_bus = (baread2 & ~0x00FF) >> 8;
  802aa0:	0f b6 fc             	movzbl %ah,%edi
            pci_check_busses(secondary_bus, pcid);
  802aa3:	48 89 de             	mov    %rbx,%rsi
  802aa6:	48 b8 d0 29 80 00 00 	movabs $0x8029d0,%rax
  802aad:	00 00 00 
  802ab0:	ff d0                	call   *%rax
  802ab2:	eb 8e                	jmp    802a42 <pci_check_busses+0x72>
}
  802ab4:	48 83 c4 18          	add    $0x18,%rsp
  802ab8:	5b                   	pop    %rbx
  802ab9:	41 5c                	pop    %r12
  802abb:	41 5d                	pop    %r13
  802abd:	41 5e                	pop    %r14
  802abf:	41 5f                	pop    %r15
  802ac1:	5d                   	pop    %rbp
  802ac2:	c3                   	ret

0000000000802ac3 <find_pci_dev>:
find_pci_dev(int class, int sub) {
  802ac3:	f3 0f 1e fa          	endbr64
    for (int i = 0; i != PCI_MAX_DEVICES; i++) {
  802ac7:	48 b8 1d d2 80 00 00 	movabs $0x80d21d,%rax
  802ace:	00 00 00 
  802ad1:	ba 00 00 00 00       	mov    $0x0,%edx
  802ad6:	eb 0c                	jmp    802ae4 <find_pci_dev+0x21>
  802ad8:	83 c2 01             	add    $0x1,%edx
  802adb:	48 83 c0 58          	add    $0x58,%rax
  802adf:	83 fa 0a             	cmp    $0xa,%edx
  802ae2:	74 29                	je     802b0d <find_pci_dev+0x4a>
        if (pci_device_buffer[i].class == class &&
  802ae4:	0f b6 08             	movzbl (%rax),%ecx
  802ae7:	39 f9                	cmp    %edi,%ecx
  802ae9:	75 ed                	jne    802ad8 <find_pci_dev+0x15>
            pci_device_buffer[i].subclass == sub) {
  802aeb:	0f b6 48 01          	movzbl 0x1(%rax),%ecx
        if (pci_device_buffer[i].class == class &&
  802aef:	39 f1                	cmp    %esi,%ecx
  802af1:	75 e5                	jne    802ad8 <find_pci_dev+0x15>
            return &pci_device_buffer[i];
  802af3:	48 63 d2             	movslq %edx,%rdx
  802af6:	48 8d 04 92          	lea    (%rdx,%rdx,4),%rax
  802afa:	48 8d 14 42          	lea    (%rdx,%rax,2),%rdx
  802afe:	48 b8 00 d2 80 00 00 	movabs $0x80d200,%rax
  802b05:	00 00 00 
  802b08:	48 8d 04 d0          	lea    (%rax,%rdx,8),%rax
  802b0c:	c3                   	ret
    return 0;
  802b0d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b12:	c3                   	ret

0000000000802b13 <get_bar_size>:
get_bar_size(struct PciDevice *pcid, uint32_t barno) {
  802b13:	f3 0f 1e fa          	endbr64
  802b17:	55                   	push   %rbp
  802b18:	48 89 e5             	mov    %rsp,%rbp
  802b1b:	41 57                	push   %r15
  802b1d:	41 56                	push   %r14
  802b1f:	41 55                	push   %r13
  802b21:	41 54                	push   %r12
  802b23:	53                   	push   %rbx
  802b24:	48 83 ec 08          	sub    $0x8,%rsp
    if (pcid == NULL || barno >= PCI_BAR_COUNT)
  802b28:	48 85 ff             	test   %rdi,%rdi
  802b2b:	74 5e                	je     802b8b <get_bar_size+0x78>
  802b2d:	49 89 fc             	mov    %rdi,%r12
  802b30:	83 fe 05             	cmp    $0x5,%esi
  802b33:	77 56                	ja     802b8b <get_bar_size+0x78>
    uint32_t tmp = pcid->bars[barno].base_address;
  802b35:	89 f0                	mov    %esi,%eax
  802b37:	44 8b 6c c7 28       	mov    0x28(%rdi,%rax,8),%r13d
    pcie_io.write32(pcid, PCI_REG_BAR0 + 4 * barno, 0xFFFFFFFF);
  802b3c:	8d 34 b5 10 00 00 00 	lea    0x10(,%rsi,4),%esi
  802b43:	40 0f b6 de          	movzbl %sil,%ebx
  802b47:	49 bf c0 d1 80 00 00 	movabs $0x80d1c0,%r15
  802b4e:	00 00 00 
  802b51:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  802b56:	89 de                	mov    %ebx,%esi
  802b58:	41 ff 57 18          	call   *0x18(%r15)
    uint32_t outv = pcie_io.read32(pcid, PCI_REG_BAR0 + 4 * barno) & PCI_BAR_MEMORY_MASK;
  802b5c:	89 de                	mov    %ebx,%esi
  802b5e:	4c 89 e7             	mov    %r12,%rdi
  802b61:	41 ff 17             	call   *(%r15)
  802b64:	83 e0 f0             	and    $0xfffffff0,%eax
  802b67:	41 89 c6             	mov    %eax,%r14d
    uint32_t size = ~outv + 1;
  802b6a:	41 f7 de             	neg    %r14d
    pcie_io.write32(pcid, PCI_REG_BAR0 + 4 * barno, tmp);
  802b6d:	44 89 ea             	mov    %r13d,%edx
  802b70:	89 de                	mov    %ebx,%esi
  802b72:	4c 89 e7             	mov    %r12,%rdi
  802b75:	41 ff 57 18          	call   *0x18(%r15)
}
  802b79:	44 89 f0             	mov    %r14d,%eax
  802b7c:	48 83 c4 08          	add    $0x8,%rsp
  802b80:	5b                   	pop    %rbx
  802b81:	41 5c                	pop    %r12
  802b83:	41 5d                	pop    %r13
  802b85:	41 5e                	pop    %r14
  802b87:	41 5f                	pop    %r15
  802b89:	5d                   	pop    %rbp
  802b8a:	c3                   	ret
        return 0;
  802b8b:	41 be 00 00 00 00    	mov    $0x0,%r14d
  802b91:	eb e6                	jmp    802b79 <get_bar_size+0x66>

0000000000802b93 <get_bar_address>:
get_bar_address(struct PciDevice *pcid, uint32_t barno) {
  802b93:	f3 0f 1e fa          	endbr64
  802b97:	55                   	push   %rbp
  802b98:	48 89 e5             	mov    %rsp,%rbp
  802b9b:	53                   	push   %rbx
  802b9c:	48 83 ec 08          	sub    $0x8,%rsp
    if (pcid == NULL || barno >= PCI_BAR_COUNT)
  802ba0:	48 85 ff             	test   %rdi,%rdi
  802ba3:	74 28                	je     802bcd <get_bar_address+0x3a>
  802ba5:	83 fe 05             	cmp    $0x5,%esi
  802ba8:	77 23                	ja     802bcd <get_bar_address+0x3a>
    uintptr_t base_addr = pcid->bars[0].base_address;
  802baa:	8b 5f 28             	mov    0x28(%rdi),%ebx
    if (pcid->bars[0].address_is_64bits)
  802bad:	f6 47 24 02          	testb  $0x2,0x24(%rdi)
  802bb1:	74 1f                	je     802bd2 <get_bar_address+0x3f>
        base_addr |= (uint64_t)(pcie_io.read32(pcid, PCI_REG_BAR0 + 4)) << 32;
  802bb3:	be 14 00 00 00       	mov    $0x14,%esi
  802bb8:	48 a1 c0 d1 80 00 00 	movabs 0x80d1c0,%rax
  802bbf:	00 00 00 
  802bc2:	ff d0                	call   *%rax
  802bc4:	48 c1 e0 20          	shl    $0x20,%rax
  802bc8:	48 09 c3             	or     %rax,%rbx
  802bcb:	eb 05                	jmp    802bd2 <get_bar_address+0x3f>
        return 0;
  802bcd:	bb 00 00 00 00       	mov    $0x0,%ebx
}
  802bd2:	48 89 d8             	mov    %rbx,%rax
  802bd5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  802bd9:	c9                   	leave
  802bda:	c3                   	ret

0000000000802bdb <parse_argv>:
invalid:
    panic("Invalid ecam= format");
}

void
parse_argv(char **argv) {
  802bdb:	f3 0f 1e fa          	endbr64
  802bdf:	55                   	push   %rbp
  802be0:	48 89 e5             	mov    %rsp,%rbp
  802be3:	41 57                	push   %r15
  802be5:	41 56                	push   %r14
  802be7:	41 55                	push   %r13
  802be9:	41 54                	push   %r12
  802beb:	53                   	push   %rbx
  802bec:	48 83 ec 38          	sub    $0x38,%rsp
    ecam_base_addr = (volatile uint8_t *)ECAM_VADDR;
  802bf0:	48 b8 00 00 00 00 70 	movabs $0x7000000000,%rax
  802bf7:	00 00 00 
  802bfa:	48 a3 f0 d1 80 00 00 	movabs %rax,0x80d1f0
  802c01:	00 00 00 
     *   ecam=<base address>:<segment group>:<start bus>:<end bus>
     * with all values being hex numbers. So we need to parse them
     * and map physical memory regions accordingly.
     */

    if (argv)
  802c04:	48 85 ff             	test   %rdi,%rdi
  802c07:	0f 84 68 02 00 00    	je     802e75 <parse_argv+0x29a>
        for (argv++; *argv; argv++) {
  802c0d:	48 8d 5f 08          	lea    0x8(%rdi),%rbx
  802c11:	48 8b 7f 08          	mov    0x8(%rdi),%rdi
  802c15:	48 85 ff             	test   %rdi,%rdi
  802c18:	0f 84 57 02 00 00    	je     802e75 <parse_argv+0x29a>
    char *vaddr = (char *)ecam_base_addr;
  802c1e:	49 89 c5             	mov    %rax,%r13
            if (!strncmp(*argv, "ecam=", 5)) {
  802c21:	49 bf d8 76 80 00 00 	movabs $0x8076d8,%r15
  802c28:	00 00 00 
  802c2b:	49 be 41 48 80 00 00 	movabs $0x804841,%r14
  802c32:	00 00 00 
  802c35:	e9 84 00 00 00       	jmp    802cbe <parse_argv+0xe3>
    panic("Invalid ecam= format");
  802c3a:	48 ba de 76 80 00 00 	movabs $0x8076de,%rdx
  802c41:	00 00 00 
  802c44:	be b0 01 00 00       	mov    $0x1b0,%esi
  802c49:	48 bf f3 76 80 00 00 	movabs $0x8076f3,%rdi
  802c50:	00 00 00 
  802c53:	b8 00 00 00 00       	mov    $0x0,%eax
  802c58:	48 b9 c1 3c 80 00 00 	movabs $0x803cc1,%rcx
  802c5f:	00 00 00 
  802c62:	ff d1                	call   *%rcx


                uintptr_t size = PCI_ECAM_MEMSIZE * (ecam->end_bus - ecam->start_bus) * PCI_NUM_DEVICES * PCI_NUM_FUNCTIONS;
                int r = sys_map_physical_region(ecam->paddr, 0, ecam->vaddr, size, PROT_RW | PROT_CD);
                if (r < 0)
                    panic("sys_map_physical_region(): %i", r);
  802c64:	89 c1                	mov    %eax,%ecx
  802c66:	48 ba fc 76 80 00 00 	movabs $0x8076fc,%rdx
  802c6d:	00 00 00 
  802c70:	be ce 01 00 00       	mov    $0x1ce,%esi
  802c75:	48 bf f3 76 80 00 00 	movabs $0x8076f3,%rdi
  802c7c:	00 00 00 
  802c7f:	b8 00 00 00 00       	mov    $0x0,%eax
  802c84:	49 b8 c1 3c 80 00 00 	movabs $0x803cc1,%r8
  802c8b:	00 00 00 
  802c8e:	41 ff d0             	call   *%r8

                vaddr += size;
            } else if (!strncmp(*argv, "tscfreq=", 8)) {
  802c91:	48 8b 3b             	mov    (%rbx),%rdi
  802c94:	ba 08 00 00 00       	mov    $0x8,%edx
  802c99:	48 be 1a 77 80 00 00 	movabs $0x80771a,%rsi
  802ca0:	00 00 00 
  802ca3:	41 ff d6             	call   *%r14
  802ca6:	85 c0                	test   %eax,%eax
  802ca8:	0f 84 88 01 00 00    	je     802e36 <parse_argv+0x25b>
        for (argv++; *argv; argv++) {
  802cae:	48 83 c3 08          	add    $0x8,%rbx
  802cb2:	48 8b 3b             	mov    (%rbx),%rdi
  802cb5:	48 85 ff             	test   %rdi,%rdi
  802cb8:	0f 84 b7 01 00 00    	je     802e75 <parse_argv+0x29a>
            if (!strncmp(*argv, "ecam=", 5)) {
  802cbe:	ba 05 00 00 00       	mov    $0x5,%edx
  802cc3:	4c 89 fe             	mov    %r15,%rsi
  802cc6:	41 ff d6             	call   *%r14
  802cc9:	85 c0                	test   %eax,%eax
  802ccb:	75 c4                	jne    802c91 <parse_argv+0xb6>
                segments[segment_count++] = parse_ecam(*argv);
  802ccd:	48 8b 03             	mov    (%rbx),%rax
  802cd0:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  802cd4:	48 b8 28 d0 80 00 00 	movabs $0x80d028,%rax
  802cdb:	00 00 00 
  802cde:	4c 8b 20             	mov    (%rax),%r12
  802ce1:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  802ce6:	48 89 10             	mov    %rdx,(%rax)
    str += strlen("ecam=");
  802ce9:	4c 89 ff             	mov    %r15,%rdi
  802cec:	48 be 21 47 80 00 00 	movabs $0x804721,%rsi
  802cf3:	00 00 00 
  802cf6:	ff d6                	call   *%rsi
  802cf8:	48 8b 4d b8          	mov    -0x48(%rbp),%rcx
  802cfc:	48 01 c8             	add    %rcx,%rax
  802cff:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    seg.paddr = parse_hex(&str);
  802d03:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  802d07:	48 b8 86 23 80 00 00 	movabs $0x802386,%rax
  802d0e:	00 00 00 
  802d11:	ff d0                	call   *%rax
  802d13:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
    if (*str++ != ':')
  802d17:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802d1b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802d1f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  802d23:	80 38 3a             	cmpb   $0x3a,(%rax)
  802d26:	0f 85 0e ff ff ff    	jne    802c3a <parse_argv+0x5f>
    seg.segment = parse_hex(&str);
  802d2c:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  802d30:	48 b8 86 23 80 00 00 	movabs $0x802386,%rax
  802d37:	00 00 00 
  802d3a:	ff d0                	call   *%rax
  802d3c:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
    if (*str++ != ':')
  802d40:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802d44:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802d48:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  802d4c:	80 38 3a             	cmpb   $0x3a,(%rax)
  802d4f:	0f 85 e5 fe ff ff    	jne    802c3a <parse_argv+0x5f>
    seg.start_bus = parse_hex(&str);
  802d55:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  802d59:	48 b8 86 23 80 00 00 	movabs $0x802386,%rax
  802d60:	00 00 00 
  802d63:	ff d0                	call   *%rax
  802d65:	48 89 45 a8          	mov    %rax,-0x58(%rbp)
    if (*str++ != ':')
  802d69:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802d6d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802d71:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  802d75:	80 38 3a             	cmpb   $0x3a,(%rax)
  802d78:	0f 85 bc fe ff ff    	jne    802c3a <parse_argv+0x5f>
    seg.end_bus = parse_hex(&str);
  802d7e:	48 8d 4d c8          	lea    -0x38(%rbp),%rcx
  802d82:	48 89 cf             	mov    %rcx,%rdi
  802d85:	48 b8 86 23 80 00 00 	movabs $0x802386,%rax
  802d8c:	00 00 00 
  802d8f:	ff d0                	call   *%rax
  802d91:	48 89 c6             	mov    %rax,%rsi
                segments[segment_count++] = parse_ecam(*argv);
  802d94:	48 ba 40 d0 80 00 00 	movabs $0x80d040,%rdx
  802d9b:	00 00 00 
  802d9e:	4b 8d 04 24          	lea    (%r12,%r12,1),%rax
  802da2:	4a 8d 0c 20          	lea    (%rax,%r12,1),%rcx
  802da6:	48 8d 0c ca          	lea    (%rdx,%rcx,8),%rcx
  802daa:	48 c7 01 00 00 00 00 	movq   $0x0,(%rcx)
  802db1:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  802db5:	48 89 79 08          	mov    %rdi,0x8(%rcx)
  802db9:	0f b7 7d b0          	movzwl -0x50(%rbp),%edi
  802dbd:	66 89 79 10          	mov    %di,0x10(%rcx)
  802dc1:	0f b6 7d a8          	movzbl -0x58(%rbp),%edi
  802dc5:	40 88 79 12          	mov    %dil,0x12(%rcx)
  802dc9:	4c 01 e0             	add    %r12,%rax
    seg.end_bus = parse_hex(&str);
  802dcc:	40 88 74 c2 13       	mov    %sil,0x13(%rdx,%rax,8)
                struct ECAMSegment *ecam = &segments[segment_count - 1];
  802dd1:	48 a1 28 d0 80 00 00 	movabs 0x80d028,%rax
  802dd8:	00 00 00 
  802ddb:	48 83 e8 01          	sub    $0x1,%rax
                ecam->vaddr = vaddr;
  802ddf:	48 8d 0c 00          	lea    (%rax,%rax,1),%rcx
  802de3:	48 8d 34 01          	lea    (%rcx,%rax,1),%rsi
  802de7:	48 8d 34 f2          	lea    (%rdx,%rsi,8),%rsi
  802deb:	4c 89 2e             	mov    %r13,(%rsi)
                uintptr_t size = PCI_ECAM_MEMSIZE * (ecam->end_bus - ecam->start_bus) * PCI_NUM_DEVICES * PCI_NUM_FUNCTIONS;
  802dee:	44 0f b6 66 13       	movzbl 0x13(%rsi),%r12d
  802df3:	0f b6 76 12          	movzbl 0x12(%rsi),%esi
  802df7:	41 29 f4             	sub    %esi,%r12d
  802dfa:	41 c1 e4 14          	shl    $0x14,%r12d
  802dfe:	4d 63 e4             	movslq %r12d,%r12
                int r = sys_map_physical_region(ecam->paddr, 0, ecam->vaddr, size, PROT_RW | PROT_CD);
  802e01:	48 01 c1             	add    %rax,%rcx
  802e04:	48 8b 7c ca 08       	mov    0x8(%rdx,%rcx,8),%rdi
  802e09:	41 b8 1e 00 00 00    	mov    $0x1e,%r8d
  802e0f:	4c 89 e1             	mov    %r12,%rcx
  802e12:	4c 89 ea             	mov    %r13,%rdx
  802e15:	be 00 00 00 00       	mov    $0x0,%esi
  802e1a:	48 b8 3f 4e 80 00 00 	movabs $0x804e3f,%rax
  802e21:	00 00 00 
  802e24:	ff d0                	call   *%rax
                if (r < 0)
  802e26:	85 c0                	test   %eax,%eax
  802e28:	0f 88 36 fe ff ff    	js     802c64 <parse_argv+0x89>
                vaddr += size;
  802e2e:	4d 01 e5             	add    %r12,%r13
  802e31:	e9 78 fe ff ff       	jmp    802cae <parse_argv+0xd3>
                char *str = *argv;
  802e36:	4c 8b 23             	mov    (%rbx),%r12
                str += strlen("tscfreq=");
  802e39:	48 bf 1a 77 80 00 00 	movabs $0x80771a,%rdi
  802e40:	00 00 00 
  802e43:	48 b8 21 47 80 00 00 	movabs $0x804721,%rax
  802e4a:	00 00 00 
  802e4d:	ff d0                	call   *%rax
  802e4f:	49 01 c4             	add    %rax,%r12
  802e52:	4c 89 65 c8          	mov    %r12,-0x38(%rbp)
                tsc_freq = parse_hex(&str);
  802e56:	48 8d 7d c8          	lea    -0x38(%rbp),%rdi
  802e5a:	48 b8 86 23 80 00 00 	movabs $0x802386,%rax
  802e61:	00 00 00 
  802e64:	ff d0                	call   *%rax
  802e66:	48 a3 60 c0 80 00 00 	movabs %rax,0x80c060
  802e6d:	00 00 00 
                DEBUG("tsc_freq=%ld\n", tsc_freq);
  802e70:	e9 39 fe ff ff       	jmp    802cae <parse_argv+0xd3>
            }
        }

    if (segment_count == 0)
  802e75:	48 b8 28 d0 80 00 00 	movabs $0x80d028,%rax
  802e7c:	00 00 00 
  802e7f:	48 83 38 00          	cmpq   $0x0,(%rax)
  802e83:	49 b9 ce 22 80 00 00 	movabs $0x8022ce,%r9
  802e8a:	00 00 00 
  802e8d:	48 ba ee 24 80 00 00 	movabs $0x8024ee,%rdx
  802e94:	00 00 00 
  802e97:	4c 0f 45 ca          	cmovne %rdx,%r9
  802e9b:	49 b8 33 25 80 00 00 	movabs $0x802533,%r8
  802ea2:	00 00 00 
  802ea5:	48 ba 40 23 80 00 00 	movabs $0x802340,%rdx
  802eac:	00 00 00 
  802eaf:	4c 0f 45 c2          	cmovne %rdx,%r8
  802eb3:	48 bf 76 25 80 00 00 	movabs $0x802576,%rdi
  802eba:	00 00 00 
  802ebd:	48 ba c9 23 80 00 00 	movabs $0x8023c9,%rdx
  802ec4:	00 00 00 
  802ec7:	48 0f 45 fa          	cmovne %rdx,%rdi
  802ecb:	48 be 05 23 80 00 00 	movabs $0x802305,%rsi
  802ed2:	00 00 00 
  802ed5:	48 ba 57 24 80 00 00 	movabs $0x802457,%rdx
  802edc:	00 00 00 
  802edf:	48 0f 45 f2          	cmovne %rdx,%rsi
  802ee3:	48 b9 27 26 80 00 00 	movabs $0x802627,%rcx
  802eea:	00 00 00 
  802eed:	48 ba a2 24 80 00 00 	movabs $0x8024a2,%rdx
  802ef4:	00 00 00 
  802ef7:	48 0f 45 ca          	cmovne %rdx,%rcx
  802efb:	48 ba b9 25 80 00 00 	movabs $0x8025b9,%rdx
  802f02:	00 00 00 
  802f05:	48 b8 0d 24 80 00 00 	movabs $0x80240d,%rax
  802f0c:	00 00 00 
  802f0f:	48 0f 45 d0          	cmovne %rax,%rdx
        pcie_io.read32 = pci_iop_read_dword;
  802f13:	48 b8 c0 d1 80 00 00 	movabs $0x80d1c0,%rax
  802f1a:	00 00 00 
  802f1d:	4c 89 08             	mov    %r9,(%rax)
        pcie_io.read16 = pci_iop_read_word;
  802f20:	4c 89 40 08          	mov    %r8,0x8(%rax)
        pcie_io.read8 = pci_iop_read_byte;
  802f24:	48 89 78 10          	mov    %rdi,0x10(%rax)
        pcie_io.write32 = pci_iop_write_dword;
  802f28:	48 89 70 18          	mov    %rsi,0x18(%rax)
        pcie_io.write16 = pci_iop_write_word;
  802f2c:	48 89 48 20          	mov    %rcx,0x20(%rax)
        pcie_io.write8 = pci_iop_write_byte;
  802f30:	48 89 50 28          	mov    %rdx,0x28(%rax)
        pci_set_iomech(PCIE_IOPL);
    else
        pci_set_iomech(PCIE_ECAM);
}
  802f34:	48 83 c4 38          	add    $0x38,%rsp
  802f38:	5b                   	pop    %rbx
  802f39:	41 5c                	pop    %r12
  802f3b:	41 5d                	pop    %r13
  802f3d:	41 5e                	pop    %r14
  802f3f:	41 5f                	pop    %r15
  802f41:	5d                   	pop    %rbp
  802f42:	c3                   	ret

0000000000802f43 <pci_init>:

/*
 * Initialize PCI bus.
 */
void
pci_init(char **argv) {
  802f43:	f3 0f 1e fa          	endbr64
  802f47:	55                   	push   %rbp
  802f48:	48 89 e5             	mov    %rsp,%rbp
    parse_argv(argv);
  802f4b:	48 b8 db 2b 80 00 00 	movabs $0x802bdb,%rax
  802f52:	00 00 00 
  802f55:	ff d0                	call   *%rax

    init_class_descriptions();

    /* Scan all busses starting at bus 0. */
    pci_check_busses(0, NULL);
  802f57:	be 00 00 00 00       	mov    $0x0,%esi
  802f5c:	bf 00 00 00 00       	mov    $0x0,%edi
  802f61:	48 b8 d0 29 80 00 00 	movabs $0x8029d0,%rax
  802f68:	00 00 00 
  802f6b:	ff d0                	call   *%rax
}
  802f6d:	5d                   	pop    %rbp
  802f6e:	c3                   	ret

0000000000802f6f <nvme_wait_completion>:
 * @param   cid         cid
 * @param   timeout     timeout in seconds
 * @return  completion status (0 if ok).
 */
static int
nvme_wait_completion(struct NvmeController *ctl, struct NvmeQueueAttributes *q, int cid, int timeout) {
  802f6f:	f3 0f 1e fa          	endbr64
  802f73:	55                   	push   %rbp
  802f74:	48 89 e5             	mov    %rsp,%rbp
  802f77:	53                   	push   %rbx
  802f78:	49 89 fa             	mov    %rdi,%r10
  802f7b:	41 89 d3             	mov    %edx,%r11d
    volatile struct NvmeCQE *cqe = &q->cq[q->cq_head];
  802f7e:	8b 7e 28             	mov    0x28(%rsi),%edi
  802f81:	41 89 f8             	mov    %edi,%r8d
  802f84:	49 c1 e0 04          	shl    $0x4,%r8
  802f88:	4c 03 46 10          	add    0x10(%rsi),%r8
    if (cqe->p == q->cq_phase)
  802f8c:	44 0f b6 4e 2c       	movzbl 0x2c(%rsi),%r9d
                stat = -1;
            }

            return stat;
        } else if (endtsc == 0) {
            endtsc = read_tsc() + (uint64_t)timeout * tsc_freq;
  802f91:	48 63 d9             	movslq %ecx,%rbx
  802f94:	48 b8 60 c0 80 00 00 	movabs $0x80c060,%rax
  802f9b:	00 00 00 
  802f9e:	48 0f af 18          	imul   (%rax),%rbx
    uint64_t endtsc = 0;
  802fa2:	b9 00 00 00 00       	mov    $0x0,%ecx
  802fa7:	eb 47                	jmp    802ff0 <nvme_wait_completion+0x81>
        q->cq_head = 0;
  802fa9:	c7 46 28 00 00 00 00 	movl   $0x0,0x28(%rsi)
        q->cq_phase = !q->cq_phase;
  802fb0:	41 83 f1 01          	xor    $0x1,%r9d
  802fb4:	44 88 4e 2c          	mov    %r9b,0x2c(%rsi)
  802fb8:	eb 5b                	jmp    803015 <nvme_wait_completion+0xa6>
        }
    } while (read_tsc() < endtsc);

    return -NVME_CMD_TIMEOUT;
  802fba:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  802fbf:	eb 05                	jmp    802fc6 <nvme_wait_completion+0x57>
                return NVME_OK;
  802fc1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802fc6:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  802fca:	c9                   	leave
  802fcb:	c3                   	ret
        } else if (endtsc == 0) {
  802fcc:	48 85 c9             	test   %rcx,%rcx
  802fcf:	75 0f                	jne    802fe0 <nvme_wait_completion+0x71>
}

static inline uint64_t __attribute__((always_inline))
read_tsc(void) {
    uint32_t lo, hi;
    asm volatile("rdtsc"
  802fd1:	0f 31                	rdtsc
                 : "=a"(lo), "=d"(hi));
    return (uint64_t)lo | ((uint64_t)hi << 32);
  802fd3:	48 c1 e2 20          	shl    $0x20,%rdx
  802fd7:	89 c0                	mov    %eax,%eax
  802fd9:	48 09 c2             	or     %rax,%rdx
            endtsc = read_tsc() + (uint64_t)timeout * tsc_freq;
  802fdc:	48 8d 0c 1a          	lea    (%rdx,%rbx,1),%rcx
    asm volatile("rdtsc"
  802fe0:	0f 31                	rdtsc
    return (uint64_t)lo | ((uint64_t)hi << 32);
  802fe2:	48 c1 e2 20          	shl    $0x20,%rdx
  802fe6:	89 c0                	mov    %eax,%eax
  802fe8:	48 09 c2             	or     %rax,%rdx
    } while (read_tsc() < endtsc);
  802feb:	48 39 ca             	cmp    %rcx,%rdx
  802fee:	73 ca                	jae    802fba <nvme_wait_completion+0x4b>
    if (cqe->p == q->cq_phase)
  802ff0:	49 8b 40 08          	mov    0x8(%r8),%rax
  802ff4:	48 c1 e8 30          	shr    $0x30,%rax
  802ff8:	83 e0 01             	and    $0x1,%eax
  802ffb:	44 38 c8             	cmp    %r9b,%al
  802ffe:	74 cc                	je     802fcc <nvme_wait_completion+0x5d>
    *stat = cqe->psf & 0xFFFE;
  803000:	41 0f b7 40 0e       	movzwl 0xe(%r8),%eax
  803005:	25 fe ff 00 00       	and    $0xfffe,%eax
    if (++q->cq_head == q->size) {
  80300a:	83 c7 01             	add    $0x1,%edi
  80300d:	89 7e 28             	mov    %edi,0x28(%rsi)
  803010:	3b 7e 04             	cmp    0x4(%rsi),%edi
  803013:	74 94                	je     802fa9 <nvme_wait_completion+0x3a>
    *NVME_REG32(ctl->mmio_base_addr, q->cq_doorbell) = q->cq_head;
  803015:	8b 56 1c             	mov    0x1c(%rsi),%edx
  803018:	49 03 92 98 00 00 00 	add    0x98(%r10),%rdx
  80301f:	8b 4e 28             	mov    0x28(%rsi),%ecx
  803022:	89 0a                	mov    %ecx,(%rdx)
    return cqe->cid;
  803024:	41 0f b7 50 0c       	movzwl 0xc(%r8),%edx
  803029:	0f b7 d2             	movzwl %dx,%edx
            if (ret == cid && stat == 0) {
  80302c:	85 c0                	test   %eax,%eax
  80302e:	75 05                	jne    803035 <nvme_wait_completion+0xc6>
  803030:	41 39 d3             	cmp    %edx,%r11d
  803033:	74 8c                	je     802fc1 <nvme_wait_completion+0x52>
                stat = -1;
  803035:	41 39 d3             	cmp    %edx,%r11d
  803038:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  80303d:	0f 45 c2             	cmovne %edx,%eax
  803040:	eb 84                	jmp    802fc6 <nvme_wait_completion+0x57>

0000000000803042 <nvme_submit_cmd>:

static int
nvme_submit_cmd(struct NvmeController *ctl, struct NvmeQueueAttributes *q) {
  803042:	f3 0f 1e fa          	endbr64
    DEBUG("sq_tail = %d, base_addr = %p, drbl = %x",
          q->sq_tail, ctl->mmio_base_addr, q->sq_doorbell);
    q->sq_tail = (q->sq_tail + 1) % q->size;
  803046:	8b 46 24             	mov    0x24(%rsi),%eax
  803049:	83 c0 01             	add    $0x1,%eax
  80304c:	ba 00 00 00 00       	mov    $0x0,%edx
  803051:	f7 76 04             	divl   0x4(%rsi)
  803054:	89 56 24             	mov    %edx,0x24(%rsi)
    *NVME_REG32(ctl->mmio_base_addr, q->sq_doorbell) = q->sq_tail;
  803057:	8b 46 18             	mov    0x18(%rsi),%eax
  80305a:	48 03 87 98 00 00 00 	add    0x98(%rdi),%rax
  803061:	89 10                	mov    %edx,(%rax)

    return NVME_OK;
}
  803063:	b8 00 00 00 00       	mov    $0x0,%eax
  803068:	c3                   	ret

0000000000803069 <nvme_acmd_identify>:

static int
nvme_acmd_identify(struct NvmeController *ctl, int nsid, uint64_t prp1, uint64_t prp2) {
  803069:	f3 0f 1e fa          	endbr64
  80306d:	55                   	push   %rbp
  80306e:	48 89 e5             	mov    %rsp,%rbp
  803071:	41 57                	push   %r15
  803073:	41 56                	push   %r14
  803075:	41 55                	push   %r13
  803077:	41 54                	push   %r12
  803079:	53                   	push   %rbx
  80307a:	48 83 ec 18          	sub    $0x18,%rsp
  80307e:	49 89 fc             	mov    %rdi,%r12
  803081:	41 89 f5             	mov    %esi,%r13d
  803084:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  803088:	48 89 4d c0          	mov    %rcx,-0x40(%rbp)
    struct NvmeQueueAttributes *adminq = &ctl->adminq;
  80308c:	4c 8d bf a8 00 00 00 	lea    0xa8(%rdi),%r15
    int cid = adminq->sq_tail;
  803093:	44 8b b7 cc 00 00 00 	mov    0xcc(%rdi),%r14d
    struct NvmeACmdIdentify *cmd = &adminq->sq[cid].identify;
  80309a:	49 63 de             	movslq %r14d,%rbx
  80309d:	48 c1 e3 06          	shl    $0x6,%rbx
  8030a1:	48 03 9f b0 00 00 00 	add    0xb0(%rdi),%rbx

    DEBUG("sq = %d - %d cid = %#x nsid = %d, prp1 = %lx, prp2 = %lx", adminq->sq_head, adminq->sq_tail, cid, nsid, prp1, prp2);

    memset(cmd, 0, sizeof(*cmd));
  8030a8:	ba 40 00 00 00       	mov    $0x40,%edx
  8030ad:	be 00 00 00 00       	mov    $0x0,%esi
  8030b2:	48 89 df             	mov    %rbx,%rdi
  8030b5:	48 b8 c7 48 80 00 00 	movabs $0x8048c7,%rax
  8030bc:	00 00 00 
  8030bf:	ff d0                	call   *%rax
    cmd->common.opc = NVME_ACMD_IDENTIFY;
  8030c1:	c6 03 06             	movb   $0x6,(%rbx)
    cmd->common.cid = cid;
  8030c4:	66 44 89 73 02       	mov    %r14w,0x2(%rbx)
    cmd->common.nsid = nsid;
  8030c9:	44 89 6b 04          	mov    %r13d,0x4(%rbx)
    cmd->common.prp[0] = prp1;
  8030cd:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8030d1:	48 89 43 18          	mov    %rax,0x18(%rbx)
    cmd->common.prp[1] = prp2;
  8030d5:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8030d9:	48 89 43 20          	mov    %rax,0x20(%rbx)
    cmd->cns = nsid == 0 ? 1 : 0;
  8030dd:	45 85 ed             	test   %r13d,%r13d
  8030e0:	0f 94 c0             	sete   %al
  8030e3:	0f b6 c0             	movzbl %al,%eax
  8030e6:	89 43 28             	mov    %eax,0x28(%rbx)

    int err = nvme_submit_cmd(ctl, adminq);
  8030e9:	4c 89 fe             	mov    %r15,%rsi
  8030ec:	4c 89 e7             	mov    %r12,%rdi
  8030ef:	48 b8 42 30 80 00 00 	movabs $0x803042,%rax
  8030f6:	00 00 00 
  8030f9:	ff d0                	call   *%rax
    if (err)
  8030fb:	85 c0                	test   %eax,%eax
  8030fd:	74 0f                	je     80310e <nvme_acmd_identify+0xa5>
        return err;

    err = nvme_wait_completion(ctl, adminq, cid, 900);
    return err;
}
  8030ff:	48 83 c4 18          	add    $0x18,%rsp
  803103:	5b                   	pop    %rbx
  803104:	41 5c                	pop    %r12
  803106:	41 5d                	pop    %r13
  803108:	41 5e                	pop    %r14
  80310a:	41 5f                	pop    %r15
  80310c:	5d                   	pop    %rbp
  80310d:	c3                   	ret
    err = nvme_wait_completion(ctl, adminq, cid, 900);
  80310e:	b9 84 03 00 00       	mov    $0x384,%ecx
  803113:	44 89 f2             	mov    %r14d,%edx
  803116:	4c 89 fe             	mov    %r15,%rsi
  803119:	4c 89 e7             	mov    %r12,%rdi
  80311c:	48 b8 6f 2f 80 00 00 	movabs $0x802f6f,%rax
  803123:	00 00 00 
  803126:	ff d0                	call   *%rax
    return err;
  803128:	eb d5                	jmp    8030ff <nvme_acmd_identify+0x96>

000000000080312a <nvme_cmd_rw>:
 * @param   prp2        PRP2 address
 * @return  0 if ok else errcode != 0.
 */
static int
nvme_cmd_rw(struct NvmeController *ctl, struct NvmeQueueAttributes *ioq, int opc,
            int nsid, uint64_t slba, int nlb, uint64_t prp1, uint64_t prp2) {
  80312a:	f3 0f 1e fa          	endbr64
  80312e:	55                   	push   %rbp
  80312f:	48 89 e5             	mov    %rsp,%rbp
  803132:	41 57                	push   %r15
  803134:	41 56                	push   %r14
  803136:	41 55                	push   %r13
  803138:	41 54                	push   %r12
  80313a:	53                   	push   %rbx
  80313b:	48 83 ec 28          	sub    $0x28,%rsp
  80313f:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  803143:	49 89 f4             	mov    %rsi,%r12
  803146:	41 89 d6             	mov    %edx,%r14d
  803149:	41 89 cd             	mov    %ecx,%r13d
  80314c:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  803150:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
     *      Note the 'minus 1' for nlbs.
     * TIP: Fields common.fuse, common.psdt, mptr, prinfo, fua, lr, dsm, eilbrt, elbat
     *      and elbatm should remain zeroed. They are not used here.
     * TIP: Use ioq->sq_tail as cid like it is done in other commands for simplicity. */
    // LAB 10: Your code here
    int cid = ioq->sq_tail;
  803154:	44 8b 7e 24          	mov    0x24(%rsi),%r15d
    struct NvmeCmdRW *cmd = &ioq->sq[cid].rw;
  803158:	49 63 df             	movslq %r15d,%rbx
  80315b:	48 c1 e3 06          	shl    $0x6,%rbx
  80315f:	48 03 5e 08          	add    0x8(%rsi),%rbx
    memset(cmd, 0, sizeof(*cmd));
  803163:	ba 40 00 00 00       	mov    $0x40,%edx
  803168:	be 00 00 00 00       	mov    $0x0,%esi
  80316d:	48 89 df             	mov    %rbx,%rdi
  803170:	48 b8 c7 48 80 00 00 	movabs $0x8048c7,%rax
  803177:	00 00 00 
  80317a:	ff d0                	call   *%rax
    cmd->common.opc = opc;
  80317c:	44 88 33             	mov    %r14b,(%rbx)
    cmd->common.cid = cid;
  80317f:	66 44 89 7b 02       	mov    %r15w,0x2(%rbx)
    cmd->common.nsid = nsid;
  803184:	44 89 6b 04          	mov    %r13d,0x4(%rbx)
    cmd->common.prp[0] = prp1;
  803188:	48 8b 45 10          	mov    0x10(%rbp),%rax
  80318c:	48 89 43 18          	mov    %rax,0x18(%rbx)
    cmd->common.prp[1] = prp2;
  803190:	48 8b 45 18          	mov    0x18(%rbp),%rax
  803194:	48 89 43 20          	mov    %rax,0x20(%rbx)
    cmd->slba = slba;
  803198:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80319c:	48 89 43 28          	mov    %rax,0x28(%rbx)
    cmd->nlb = nlb - 1;
  8031a0:	0f b7 45 bc          	movzwl -0x44(%rbp),%eax
  8031a4:	83 e8 01             	sub    $0x1,%eax
  8031a7:	66 89 43 30          	mov    %ax,0x30(%rbx)
        opc == NVME_CMD_READ ? 'R' : 'W');
    /* Submit the command and synchronously wait for its completion
     * TIP: Use nvme_submit_cmd() and nvme_wait_completion(). Don't
     *      forget to check for potential errors! */
    // LAB 10: Your code here
    int err = nvme_submit_cmd(ctl, ioq);
  8031ab:	4c 89 e6             	mov    %r12,%rsi
  8031ae:	48 8b 5d c8          	mov    -0x38(%rbp),%rbx
  8031b2:	48 89 df             	mov    %rbx,%rdi
  8031b5:	48 b8 42 30 80 00 00 	movabs $0x803042,%rax
  8031bc:	00 00 00 
  8031bf:	ff d0                	call   *%rax
    if (err) {
  8031c1:	85 c0                	test   %eax,%eax
  8031c3:	74 0f                	je     8031d4 <nvme_cmd_rw+0xaa>
    }

    err = nvme_wait_completion(ctl, ioq, cid, 30);

    return err;
}
  8031c5:	48 83 c4 28          	add    $0x28,%rsp
  8031c9:	5b                   	pop    %rbx
  8031ca:	41 5c                	pop    %r12
  8031cc:	41 5d                	pop    %r13
  8031ce:	41 5e                	pop    %r14
  8031d0:	41 5f                	pop    %r15
  8031d2:	5d                   	pop    %rbp
  8031d3:	c3                   	ret
    err = nvme_wait_completion(ctl, ioq, cid, 30);
  8031d4:	b9 1e 00 00 00       	mov    $0x1e,%ecx
  8031d9:	44 89 fa             	mov    %r15d,%edx
  8031dc:	4c 89 e6             	mov    %r12,%rsi
  8031df:	48 89 df             	mov    %rbx,%rdi
  8031e2:	48 b8 6f 2f 80 00 00 	movabs $0x802f6f,%rax
  8031e9:	00 00 00 
  8031ec:	ff d0                	call   *%rax
    return err;
  8031ee:	eb d5                	jmp    8031c5 <nvme_cmd_rw+0x9b>

00000000008031f0 <nvme_init>:
nvme_init(void) {
  8031f0:	f3 0f 1e fa          	endbr64
  8031f4:	55                   	push   %rbp
  8031f5:	48 89 e5             	mov    %rsp,%rbp
  8031f8:	41 57                	push   %r15
  8031fa:	41 56                	push   %r14
  8031fc:	41 55                	push   %r13
  8031fe:	41 54                	push   %r12
  803200:	53                   	push   %rbx
  803201:	48 83 ec 08          	sub    $0x8,%rsp
    struct PciDevice *pcidevice = find_pci_dev(1, 8);
  803205:	be 08 00 00 00       	mov    $0x8,%esi
  80320a:	bf 01 00 00 00       	mov    $0x1,%edi
  80320f:	48 b8 c3 2a 80 00 00 	movabs $0x802ac3,%rax
  803216:	00 00 00 
  803219:	ff d0                	call   *%rax
    if (pcidevice == NULL)
  80321b:	48 85 c0             	test   %rax,%rax
  80321e:	0f 84 99 04 00 00    	je     8036bd <nvme_init+0x4cd>
  803224:	48 89 c7             	mov    %rax,%rdi
    ctl->pcidev = pcidevice;
  803227:	48 bb 80 d5 80 00 00 	movabs $0x80d580,%rbx
  80322e:	00 00 00 
  803231:	48 89 03             	mov    %rax,(%rbx)
    ctl->mmio_base_addr = (volatile uint8_t *)NVME_VADDR;
  803234:	48 b8 00 00 00 10 70 	movabs $0x7010000000,%rax
  80323b:	00 00 00 
  80323e:	48 89 83 98 00 00 00 	mov    %rax,0x98(%rbx)
    uintptr_t nvme_pa = get_bar_address(ctl->pcidev, 0);
  803245:	be 00 00 00 00       	mov    $0x0,%esi
  80324a:	48 b8 93 2b 80 00 00 	movabs $0x802b93,%rax
  803251:	00 00 00 
  803254:	ff d0                	call   *%rax
  803256:	49 89 c4             	mov    %rax,%r12
    uintptr_t memsize = get_bar_size(ctl->pcidev, 0);
  803259:	48 8b 3b             	mov    (%rbx),%rdi
  80325c:	be 00 00 00 00       	mov    $0x0,%esi
  803261:	48 b8 13 2b 80 00 00 	movabs $0x802b13,%rax
  803268:	00 00 00 
  80326b:	ff d0                	call   *%rax
  80326d:	89 c0                	mov    %eax,%eax
    memsize = memsize > NVME_MAX_MAP_MEM ? NVME_MAX_MAP_MEM : memsize;
  80326f:	ba 00 80 00 00       	mov    $0x8000,%edx
  803274:	48 39 d0             	cmp    %rdx,%rax
  803277:	48 89 d1             	mov    %rdx,%rcx
  80327a:	48 0f 46 c8          	cmovbe %rax,%rcx
    int res = sys_map_physical_region(nvme_pa, CURENVID, (void *)ctl->mmio_base_addr, memsize, PROT_RW | PROT_CD);
  80327e:	48 8b 93 98 00 00 00 	mov    0x98(%rbx),%rdx
  803285:	41 b8 1e 00 00 00    	mov    $0x1e,%r8d
  80328b:	be 00 00 00 00       	mov    $0x0,%esi
  803290:	4c 89 e7             	mov    %r12,%rdi
  803293:	48 b8 3f 4e 80 00 00 	movabs $0x804e3f,%rax
  80329a:	00 00 00 
  80329d:	ff d0                	call   *%rax
    if (res < 0) {
  80329f:	85 c0                	test   %eax,%eax
  8032a1:	0f 88 49 08 00 00    	js     803af0 <nvme_init+0x900>
    ctl->buffer = (void *)NVME_QUEUE_VADDR;
  8032a7:	48 be 00 00 00 20 70 	movabs $0x7020000000,%rsi
  8032ae:	00 00 00 
  8032b1:	48 89 f0             	mov    %rsi,%rax
  8032b4:	48 a3 20 d6 80 00 00 	movabs %rax,0x80d620
  8032bb:	00 00 00 
    int r = sys_alloc_region(0, ctl->buffer, NVME_PAGE_COUNT * PAGE_SIZE, PROT_RW | PROT_CD);
  8032be:	b9 1e 00 00 00       	mov    $0x1e,%ecx
  8032c3:	ba 00 40 00 00       	mov    $0x4000,%edx
  8032c8:	bf 00 00 00 00       	mov    $0x0,%edi
  8032cd:	48 b8 6b 4d 80 00 00 	movabs $0x804d6b,%rax
  8032d4:	00 00 00 
  8032d7:	ff d0                	call   *%rax
    if (r < 0)
  8032d9:	85 c0                	test   %eax,%eax
  8032db:	0f 88 06 04 00 00    	js     8036e7 <nvme_init+0x4f7>
        volatile char *page = (volatile char *)ctl->buffer + PAGE_SIZE * i;
  8032e1:	48 b8 80 d5 80 00 00 	movabs $0x80d580,%rax
  8032e8:	00 00 00 
  8032eb:	48 8b 90 a0 00 00 00 	mov    0xa0(%rax),%rdx
        *page = 0;
  8032f2:	c6 02 00             	movb   $0x0,(%rdx)
        volatile char *page = (volatile char *)ctl->buffer + PAGE_SIZE * i;
  8032f5:	48 8b 90 a0 00 00 00 	mov    0xa0(%rax),%rdx
        *page = 0;
  8032fc:	c6 82 00 10 00 00 00 	movb   $0x0,0x1000(%rdx)
  803303:	c6 82 00 20 00 00 00 	movb   $0x0,0x2000(%rdx)
  80330a:	c6 82 00 30 00 00 00 	movb   $0x0,0x3000(%rdx)
    volatile uint8_t *base = ctl->mmio_base_addr;
  803311:	48 8b 98 98 00 00 00 	mov    0x98(%rax),%rbx
    if (!base) {
  803318:	48 85 db             	test   %rbx,%rbx
  80331b:	0f 84 f0 03 00 00    	je     803711 <nvme_init+0x521>
    while ((*NVME_REG32(ctl->mmio_base_addr, NVME_REG_CSTS) & NVME_CSTS_RDY) == 0)
  803321:	8b 43 1c             	mov    0x1c(%rbx),%eax
  803324:	48 ba 80 d5 80 00 00 	movabs $0x80d580,%rdx
  80332b:	00 00 00 
  80332e:	a8 01                	test   $0x1,%al
  803330:	75 10                	jne    803342 <nvme_init+0x152>
        asm volatile("pause");
  803332:	f3 90                	pause
    while ((*NVME_REG32(ctl->mmio_base_addr, NVME_REG_CSTS) & NVME_CSTS_RDY) == 0)
  803334:	48 8b 82 98 00 00 00 	mov    0x98(%rdx),%rax
  80333b:	8b 40 1c             	mov    0x1c(%rax),%eax
  80333e:	a8 01                	test   $0x1,%al
  803340:	74 f0                	je     803332 <nvme_init+0x142>
    *NVME_REG32(base, NVME_REG_CC) &= ~NVME_CC_EN;
  803342:	8b 43 14             	mov    0x14(%rbx),%eax
  803345:	83 e0 fe             	and    $0xfffffffe,%eax
  803348:	89 43 14             	mov    %eax,0x14(%rbx)
    volatile uint8_t *base = ctl->mmio_base_addr;
  80334b:	48 a1 18 d6 80 00 00 	movabs 0x80d618,%rax
  803352:	00 00 00 
    union NvmeCapability cap = {.value = *NVME_REG64(base, NVME_REG_CAP)};
  803355:	48 8b 10             	mov    (%rax),%rdx
    if (!(cap.css & 1)) {
  803358:	48 0f ba e2 25       	bt     $0x25,%rdx
  80335d:	0f 83 c9 03 00 00    	jae    80372c <nvme_init+0x53c>
    ctl->ci.timeout = cap.to;    /* in 500ms units */
  803363:	48 be 80 d5 80 00 00 	movabs $0x80d580,%rsi
  80336a:	00 00 00 
  80336d:	48 89 d1             	mov    %rdx,%rcx
  803370:	48 c1 e9 18          	shr    $0x18,%rcx
  803374:	0f b6 c9             	movzbl %cl,%ecx
  803377:	66 89 4e 6a          	mov    %cx,0x6a(%rsi)
    ctl->ci.mpsmin = cap.mpsmin; /* 2 ^ (12 + MPSMIN) */
  80337b:	48 89 d1             	mov    %rdx,%rcx
  80337e:	48 c1 e9 30          	shr    $0x30,%rcx
  803382:	83 e1 0f             	and    $0xf,%ecx
  803385:	66 89 4e 6c          	mov    %cx,0x6c(%rsi)
    ctl->ci.mpsmax = cap.mpsmax; /* 2 ^ (12 + MPSMAX) */
  803389:	48 89 d7             	mov    %rdx,%rdi
  80338c:	48 c1 ef 34          	shr    $0x34,%rdi
  803390:	83 e7 0f             	and    $0xf,%edi
  803393:	66 89 7e 6e          	mov    %di,0x6e(%rsi)
    ctl->ci.pageshift = 12 + ctl->ci.mpsmin;
  803397:	83 c1 0c             	add    $0xc,%ecx
  80339a:	66 89 4e 50          	mov    %cx,0x50(%rsi)
    ctl->ci.pagesize = 1 << ctl->ci.pageshift;
  80339e:	0f b7 f9             	movzwl %cx,%edi
  8033a1:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  8033a7:	41 d3 e0             	shl    %cl,%r8d
  8033aa:	66 44 89 46 4e       	mov    %r8w,0x4e(%rsi)
    ctl->ci.maxqsize = cap.mqes + 1;
  8033af:	0f b7 ca             	movzwl %dx,%ecx
  8033b2:	83 c1 01             	add    $0x1,%ecx
  8033b5:	89 4e 64             	mov    %ecx,0x64(%rsi)
    ctl->ci.dbstride = 4 << cap.dstrd; /* in bytes */
  8033b8:	48 89 d1             	mov    %rdx,%rcx
  8033bb:	48 c1 e9 20          	shr    $0x20,%rcx
  8033bf:	83 e1 0f             	and    $0xf,%ecx
  8033c2:	ba 04 00 00 00       	mov    $0x4,%edx
  8033c7:	d3 e2                	shl    %cl,%edx
  8033c9:	66 89 56 68          	mov    %dx,0x68(%rsi)
    ctl->ci.maxppio = ctl->ci.pagesize / sizeof(uint64_t);
  8033cd:	66 41 c1 e8 03       	shr    $0x3,%r8w
  8033d2:	66 44 89 46 52       	mov    %r8w,0x52(%rsi)
                      ((ctl->ci.pageshift - 12) << NVME_CC_MPS) |
  8033d7:	83 ef 0c             	sub    $0xc,%edi
  8033da:	c1 e7 07             	shl    $0x7,%edi
                      (4 << NVME_CC_IOCQES) |
  8033dd:	81 cf 60 00 46 00    	or     $0x460060,%edi
    *NVME_REG32(base, NVME_REG_CC) = new_cc;
  8033e3:	89 78 14             	mov    %edi,0x14(%rax)
    err = nvme_setup_admin_queue(ctl, NVME_QUEUE_SIZE, ctl->buffer, ctl->buffer + PAGE_SIZE);
  8033e6:	48 8b 96 a0 00 00 00 	mov    0xa0(%rsi),%rdx
    volatile uint8_t *base = ctl->mmio_base_addr;
  8033ed:	4c 8b ae 98 00 00 00 	mov    0x98(%rsi),%r13
    assert(((uintptr_t)sqbuff & (PAGE_SIZE - 1)) == 0);
  8033f4:	f7 c2 ff 0f 00 00    	test   $0xfff,%edx
  8033fa:	0f 85 56 03 00 00    	jne    803756 <nvme_init+0x566>
            .cq_doorbell = NVME_CQnHDBL(ctl, 0),
  803400:	49 bc 80 d5 80 00 00 	movabs $0x80d580,%r12
  803407:	00 00 00 
  80340a:	41 0f b7 74 24 68    	movzwl 0x68(%r12),%esi
  803410:	81 c6 00 10 00 00    	add    $0x1000,%esi
    ctl->adminq = (struct NvmeQueueAttributes){
  803416:	49 8d bc 24 a8 00 00 	lea    0xa8(%r12),%rdi
  80341d:	00 
  80341e:	b9 06 00 00 00       	mov    $0x6,%ecx
  803423:	b8 00 00 00 00       	mov    $0x0,%eax
  803428:	f3 48 ab             	rep stos %rax,%es:(%rdi)
  80342b:	41 c7 84 24 ac 00 00 	movl   $0x20,0xac(%r12)
  803432:	00 20 00 00 00 
  803437:	49 89 94 24 b0 00 00 	mov    %rdx,0xb0(%r12)
  80343e:	00 
    err = nvme_setup_admin_queue(ctl, NVME_QUEUE_SIZE, ctl->buffer, ctl->buffer + PAGE_SIZE);
  80343f:	48 81 c2 00 10 00 00 	add    $0x1000,%rdx
  803446:	49 89 94 24 b8 00 00 	mov    %rdx,0xb8(%r12)
  80344d:	00 
    ctl->adminq = (struct NvmeQueueAttributes){
  80344e:	41 c7 84 24 c0 00 00 	movl   $0x1000,0xc0(%r12)
  803455:	00 00 10 00 00 
  80345a:	41 89 b4 24 c4 00 00 	mov    %esi,0xc4(%r12)
  803461:	00 
    *NVME_REG32(base, NVME_REG_AQA) = ((NVME_QUEUE_SIZE - 1) << 16) + NVME_QUEUE_SIZE - 1;
  803462:	41 c7 45 24 1f 00 1f 	movl   $0x1f001f,0x24(%r13)
  803469:	00 
    *NVME_REG64(base, NVME_REG_ASQ) = get_phys_addr(adminq->sq);
  80346a:	49 8b bc 24 b0 00 00 	mov    0xb0(%r12),%rdi
  803471:	00 
  803472:	49 be 68 66 80 00 00 	movabs $0x806668,%r14
  803479:	00 00 00 
  80347c:	41 ff d6             	call   *%r14
  80347f:	49 89 45 28          	mov    %rax,0x28(%r13)
    *NVME_REG64(base, NVME_REG_ACQ) = get_phys_addr(adminq->cq);
  803483:	49 8b bc 24 b8 00 00 	mov    0xb8(%r12),%rdi
  80348a:	00 
  80348b:	41 ff d6             	call   *%r14
  80348e:	49 89 45 30          	mov    %rax,0x30(%r13)
    *NVME_REG32(base, NVME_REG_CC) |= NVME_CC_EN;
  803492:	8b 43 14             	mov    0x14(%rbx),%eax
  803495:	83 c8 01             	or     $0x1,%eax
  803498:	89 43 14             	mov    %eax,0x14(%rbx)
    while ((*NVME_REG32(ctl->mmio_base_addr, NVME_REG_CSTS) & NVME_CSTS_RDY) == 0)
  80349b:	49 8b 84 24 98 00 00 	mov    0x98(%r12),%rax
  8034a2:	00 
  8034a3:	8b 40 1c             	mov    0x1c(%rax),%eax
  8034a6:	a8 01                	test   $0x1,%al
  8034a8:	75 13                	jne    8034bd <nvme_init+0x2cd>
  8034aa:	4c 89 e2             	mov    %r12,%rdx
        asm volatile("pause");
  8034ad:	f3 90                	pause
    while ((*NVME_REG32(ctl->mmio_base_addr, NVME_REG_CSTS) & NVME_CSTS_RDY) == 0)
  8034af:	48 8b 82 98 00 00 00 	mov    0x98(%rdx),%rax
  8034b6:	8b 40 1c             	mov    0x1c(%rax),%eax
  8034b9:	a8 01                	test   $0x1,%al
  8034bb:	74 f0                	je     8034ad <nvme_init+0x2bd>
    cprintf("NVMe enabled\n");
  8034bd:	48 bf 73 77 80 00 00 	movabs $0x807773,%rdi
  8034c4:	00 00 00 
  8034c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8034cc:	48 ba 1d 3e 80 00 00 	movabs $0x803e1d,%rdx
  8034d3:	00 00 00 
  8034d6:	ff d2                	call   *%rdx
    uint8_t *buff = ctl->buffer + PAGE_SIZE * 2;
  8034d8:	48 bb 80 d5 80 00 00 	movabs $0x80d580,%rbx
  8034df:	00 00 00 
  8034e2:	4c 8b a3 a0 00 00 00 	mov    0xa0(%rbx),%r12
  8034e9:	49 8d bc 24 00 20 00 	lea    0x2000(%r12),%rdi
  8034f0:	00 
    uintptr_t buff_pa = get_phys_addr(buff);
  8034f1:	48 b8 68 66 80 00 00 	movabs $0x806668,%rax
  8034f8:	00 00 00 
  8034fb:	ff d0                	call   *%rax
  8034fd:	48 89 c2             	mov    %rax,%rdx
    if (nvme_acmd_identify(ctl, 0, buff_pa, 0)) {
  803500:	b9 00 00 00 00       	mov    $0x0,%ecx
  803505:	be 00 00 00 00       	mov    $0x0,%esi
  80350a:	48 89 df             	mov    %rbx,%rdi
  80350d:	48 b8 69 30 80 00 00 	movabs $0x803069,%rax
  803514:	00 00 00 
  803517:	ff d0                	call   *%rax
  803519:	85 c0                	test   %eax,%eax
  80351b:	0f 85 72 01 00 00    	jne    803693 <nvme_init+0x4a3>
    ci->nscount = idc->nn;
  803521:	41 8b 94 24 04 22 00 	mov    0x2204(%r12),%edx
  803528:	00 
  803529:	66 89 53 54          	mov    %dx,0x54(%rbx)
    ci->vid = idc->vid;
  80352d:	41 0f b7 94 24 00 20 	movzwl 0x2000(%r12),%edx
  803534:	00 00 
  803536:	66 89 53 08          	mov    %dx,0x8(%rbx)
    memcpy(dst, src, len);
  80353a:	ba 28 00 00 00       	mov    $0x28,%edx
  80353f:	48 8d 5b 0a          	lea    0xa(%rbx),%rbx
  803543:	48 89 de             	mov    %rbx,%rsi
  803546:	48 89 df             	mov    %rbx,%rdi
  803549:	48 b8 ec 49 80 00 00 	movabs $0x8049ec,%rax
  803550:	00 00 00 
  803553:	ff d0                	call   *%rax
    for (size_t i = len - 1; i > 0 && dst[i] == ' '; i--)
  803555:	48 8d 43 27          	lea    0x27(%rbx),%rax
  803559:	80 38 20             	cmpb   $0x20,(%rax)
  80355c:	75 0c                	jne    80356a <nvme_init+0x37a>
        dst[i] = 0;
  80355e:	c6 00 00             	movb   $0x0,(%rax)
    for (size_t i = len - 1; i > 0 && dst[i] == ' '; i--)
  803561:	48 83 e8 01          	sub    $0x1,%rax
  803565:	48 39 c3             	cmp    %rax,%rbx
  803568:	75 ef                	jne    803559 <nvme_init+0x369>
    memcpy(dst, src, len);
  80356a:	ba 14 00 00 00       	mov    $0x14,%edx
  80356f:	48 bf b2 d5 80 00 00 	movabs $0x80d5b2,%rdi
  803576:	00 00 00 
  803579:	48 89 fe             	mov    %rdi,%rsi
  80357c:	48 b8 ec 49 80 00 00 	movabs $0x8049ec,%rax
  803583:	00 00 00 
  803586:	ff d0                	call   *%rax
    for (size_t i = len - 1; i > 0 && dst[i] == ' '; i--)
  803588:	48 b8 c5 d5 80 00 00 	movabs $0x80d5c5,%rax
  80358f:	00 00 00 
  803592:	48 8d 50 ed          	lea    -0x13(%rax),%rdx
  803596:	80 38 20             	cmpb   $0x20,(%rax)
  803599:	75 0c                	jne    8035a7 <nvme_init+0x3b7>
        dst[i] = 0;
  80359b:	c6 00 00             	movb   $0x0,(%rax)
    for (size_t i = len - 1; i > 0 && dst[i] == ' '; i--)
  80359e:	48 83 e8 01          	sub    $0x1,%rax
  8035a2:	48 39 d0             	cmp    %rdx,%rax
  8035a5:	75 ef                	jne    803596 <nvme_init+0x3a6>
    memcpy(dst, src, len);
  8035a7:	ba 08 00 00 00       	mov    $0x8,%edx
  8035ac:	48 bf c6 d5 80 00 00 	movabs $0x80d5c6,%rdi
  8035b3:	00 00 00 
  8035b6:	48 89 fe             	mov    %rdi,%rsi
  8035b9:	48 b8 ec 49 80 00 00 	movabs $0x8049ec,%rax
  8035c0:	00 00 00 
  8035c3:	ff d0                	call   *%rax
    for (size_t i = len - 1; i > 0 && dst[i] == ' '; i--)
  8035c5:	48 b8 cd d5 80 00 00 	movabs $0x80d5cd,%rax
  8035cc:	00 00 00 
  8035cf:	48 8d 50 f9          	lea    -0x7(%rax),%rdx
  8035d3:	80 38 20             	cmpb   $0x20,(%rax)
  8035d6:	75 0c                	jne    8035e4 <nvme_init+0x3f4>
        dst[i] = 0;
  8035d8:	c6 00 00             	movb   $0x0,(%rax)
    for (size_t i = len - 1; i > 0 && dst[i] == ' '; i--)
  8035db:	48 83 e8 01          	sub    $0x1,%rax
  8035df:	48 39 c2             	cmp    %rax,%rdx
  8035e2:	75 ef                	jne    8035d3 <nvme_init+0x3e3>
    if (idc->mdts) {
  8035e4:	41 0f b6 8c 24 4d 20 	movzbl 0x204d(%r12),%ecx
  8035eb:	00 00 
  8035ed:	84 c9                	test   %cl,%cl
  8035ef:	74 26                	je     803617 <nvme_init+0x427>
        int mp = 2 << (idc->mdts - 1);
  8035f1:	83 e9 01             	sub    $0x1,%ecx
  8035f4:	b8 02 00 00 00       	mov    $0x2,%eax
  8035f9:	d3 e0                	shl    %cl,%eax
        if (ci->maxppio > mp)
  8035fb:	48 ba 80 d5 80 00 00 	movabs $0x80d580,%rdx
  803602:	00 00 00 
  803605:	0f b7 52 52          	movzwl 0x52(%rdx),%edx
  803609:	39 d0                	cmp    %edx,%eax
  80360b:	7d 0a                	jge    803617 <nvme_init+0x427>
            ci->maxppio = mp;
  80360d:	66 a3 d2 d5 80 00 00 	movabs %ax,0x80d5d2
  803614:	00 00 00 
    int cid = adminq->sq_tail;
  803617:	49 bd 80 d5 80 00 00 	movabs $0x80d580,%r13
  80361e:	00 00 00 
  803621:	45 8b b5 cc 00 00 00 	mov    0xcc(%r13),%r14d
    struct NvmeACmdGetFeatures *cmd = &adminq->sq[cid].get_features;
  803628:	4d 63 e6             	movslq %r14d,%r12
  80362b:	4c 89 e3             	mov    %r12,%rbx
  80362e:	48 c1 e3 06          	shl    $0x6,%rbx
  803632:	49 03 9d b0 00 00 00 	add    0xb0(%r13),%rbx
    memset(cmd, 0, sizeof(*cmd));
  803639:	ba 40 00 00 00       	mov    $0x40,%edx
  80363e:	be 00 00 00 00       	mov    $0x0,%esi
  803643:	48 89 df             	mov    %rbx,%rdi
  803646:	48 b8 c7 48 80 00 00 	movabs $0x8048c7,%rax
  80364d:	00 00 00 
  803650:	ff d0                	call   *%rax
    cmd->common.opc = NVME_ACMD_GET_FEATURES;
  803652:	c6 03 0a             	movb   $0xa,(%rbx)
    cmd->common.cid = cid;
  803655:	66 44 89 73 02       	mov    %r14w,0x2(%rbx)
    cmd->common.nsid = nsid;
  80365a:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%rbx)
    cmd->common.prp[0] = prp1;
  803661:	48 c7 43 18 00 00 00 	movq   $0x0,0x18(%rbx)
  803668:	00 
    cmd->common.prp[1] = prp2;
  803669:	48 c7 43 20 00 00 00 	movq   $0x0,0x20(%rbx)
  803670:	00 
    cmd->fid = fid;
  803671:	c6 43 28 07          	movb   $0x7,0x28(%rbx)
    int err = nvme_submit_cmd(ctl, adminq);
  803675:	49 8d b5 a8 00 00 00 	lea    0xa8(%r13),%rsi
  80367c:	4c 89 ef             	mov    %r13,%rdi
  80367f:	48 b8 42 30 80 00 00 	movabs $0x803042,%rax
  803686:	00 00 00 
  803689:	ff d0                	call   *%rax
    if (err)
  80368b:	85 c0                	test   %eax,%eax
  80368d:	0f 84 f8 00 00 00    	je     80378b <nvme_init+0x59b>
        panic("NVMe contoller identification failed\n");
  803693:	48 ba f8 71 80 00 00 	movabs $0x8071f8,%rdx
  80369a:	00 00 00 
  80369d:	be 4d 01 00 00       	mov    $0x14d,%esi
  8036a2:	48 bf 3a 77 80 00 00 	movabs $0x80773a,%rdi
  8036a9:	00 00 00 
  8036ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8036b1:	48 b9 c1 3c 80 00 00 	movabs $0x803cc1,%rcx
  8036b8:	00 00 00 
  8036bb:	ff d1                	call   *%rcx
        panic("NVMe device not found\n");
  8036bd:	48 ba 23 77 80 00 00 	movabs $0x807723,%rdx
  8036c4:	00 00 00 
  8036c7:	be 3b 01 00 00       	mov    $0x13b,%esi
  8036cc:	48 bf 3a 77 80 00 00 	movabs $0x80773a,%rdi
  8036d3:	00 00 00 
  8036d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8036db:	48 b9 c1 3c 80 00 00 	movabs $0x803cc1,%rcx
  8036e2:	00 00 00 
  8036e5:	ff d1                	call   *%rcx
        panic("queue alloc failed");
  8036e7:	48 ba 44 77 80 00 00 	movabs $0x807744,%rdx
  8036ee:	00 00 00 
  8036f1:	be 2d 00 00 00       	mov    $0x2d,%esi
  8036f6:	48 bf 3a 77 80 00 00 	movabs $0x80773a,%rdi
  8036fd:	00 00 00 
  803700:	b8 00 00 00 00       	mov    $0x0,%eax
  803705:	48 b9 c1 3c 80 00 00 	movabs $0x803cc1,%rcx
  80370c:	00 00 00 
  80370f:	ff d1                	call   *%rcx
        cprintf("NVMe device is not mapped!\n");
  803711:	48 bf 57 77 80 00 00 	movabs $0x807757,%rdi
  803718:	00 00 00 
  80371b:	b8 00 00 00 00       	mov    $0x0,%eax
  803720:	48 ba 1d 3e 80 00 00 	movabs $0x803e1d,%rdx
  803727:	00 00 00 
  80372a:	ff d2                	call   *%rdx
        panic("NVMe device initialization failed\n");
  80372c:	48 ba 20 72 80 00 00 	movabs $0x807220,%rdx
  803733:	00 00 00 
  803736:	be 49 01 00 00       	mov    $0x149,%esi
  80373b:	48 bf 3a 77 80 00 00 	movabs $0x80773a,%rdi
  803742:	00 00 00 
  803745:	b8 00 00 00 00       	mov    $0x0,%eax
  80374a:	48 b9 c1 3c 80 00 00 	movabs $0x803cc1,%rcx
  803751:	00 00 00 
  803754:	ff d1                	call   *%rcx
    assert(((uintptr_t)sqbuff & (PAGE_SIZE - 1)) == 0);
  803756:	48 b9 78 71 80 00 00 	movabs $0x807178,%rcx
  80375d:	00 00 00 
  803760:	48 ba 94 73 80 00 00 	movabs $0x807394,%rdx
  803767:	00 00 00 
  80376a:	be 5a 00 00 00       	mov    $0x5a,%esi
  80376f:	48 bf 3a 77 80 00 00 	movabs $0x80773a,%rdi
  803776:	00 00 00 
  803779:	b8 00 00 00 00       	mov    $0x0,%eax
  80377e:	49 b8 c1 3c 80 00 00 	movabs $0x803cc1,%r8
  803785:	00 00 00 
  803788:	41 ff d0             	call   *%r8
    err = nvme_wait_completion(ctl, adminq, cid, 30);
  80378b:	b9 1e 00 00 00       	mov    $0x1e,%ecx
  803790:	44 89 f2             	mov    %r14d,%edx
  803793:	49 8d b5 a8 00 00 00 	lea    0xa8(%r13),%rsi
  80379a:	4c 89 ef             	mov    %r13,%rdi
  80379d:	48 b8 6f 2f 80 00 00 	movabs $0x802f6f,%rax
  8037a4:	00 00 00 
  8037a7:	ff d0                	call   *%rax
    if (err)
  8037a9:	85 c0                	test   %eax,%eax
  8037ab:	0f 85 e2 fe ff ff    	jne    803693 <nvme_init+0x4a3>
    *res = adminq->cq[cid].cs;
  8037b1:	4c 89 eb             	mov    %r13,%rbx
  8037b4:	49 c1 e4 04          	shl    $0x4,%r12
  8037b8:	4d 03 a5 b8 00 00 00 	add    0xb8(%r13),%r12
  8037bf:	41 8b 14 24          	mov    (%r12),%edx
    ci->maxqcount = (qnum.nsq < qnum.ncq ? qnum.nsq : qnum.ncq) + 1;
  8037c3:	89 d0                	mov    %edx,%eax
  8037c5:	c1 e8 10             	shr    $0x10,%eax
  8037c8:	66 39 d0             	cmp    %dx,%ax
  8037cb:	0f 47 c2             	cmova  %edx,%eax
  8037ce:	0f b7 c0             	movzwl %ax,%eax
  8037d1:	83 c0 01             	add    $0x1,%eax
  8037d4:	41 89 45 60          	mov    %eax,0x60(%r13)
    ci->qcount = MIN(ci->maxqcount, NVME_QUEUE_COUNT);
  8037d8:	41 c7 45 58 01 00 00 	movl   $0x1,0x58(%r13)
  8037df:	00 
    ci->qsize = MIN(ci->maxqsize, NVME_QUEUE_SIZE);
  8037e0:	41 8b 45 64          	mov    0x64(%r13),%eax
  8037e4:	ba 20 00 00 00       	mov    $0x20,%edx
  8037e9:	39 d0                	cmp    %edx,%eax
  8037eb:	0f 47 c2             	cmova  %edx,%eax
  8037ee:	41 89 45 5c          	mov    %eax,0x5c(%r13)
    uint8_t *buff = ctl->buffer + PAGE_SIZE * 2;
  8037f2:	4d 8b a5 a0 00 00 00 	mov    0xa0(%r13),%r12
  8037f9:	49 8d bc 24 00 20 00 	lea    0x2000(%r12),%rdi
  803800:	00 
    uintptr_t buff_pa = get_phys_addr(buff);
  803801:	48 b8 68 66 80 00 00 	movabs $0x806668,%rax
  803808:	00 00 00 
  80380b:	ff d0                	call   *%rax
  80380d:	48 89 c2             	mov    %rax,%rdx
    if (nvme_acmd_identify(ctl, id, buff_pa, 0)) {
  803810:	b9 00 00 00 00       	mov    $0x0,%ecx
  803815:	be 01 00 00 00       	mov    $0x1,%esi
  80381a:	4c 89 ef             	mov    %r13,%rdi
  80381d:	48 b8 69 30 80 00 00 	movabs $0x803069,%rax
  803824:	00 00 00 
  803827:	ff d0                	call   *%rax
  803829:	85 c0                	test   %eax,%eax
  80382b:	0f 85 95 02 00 00    	jne    803ac6 <nvme_init+0x8d6>
    ns->id = id;
  803831:	66 41 c7 45 70 01 00 	movw   $0x1,0x70(%r13)
    ns->blockcount = idns->ncap;
  803838:	49 8b 84 24 08 20 00 	mov    0x2008(%r12),%rax
  80383f:	00 
  803840:	49 89 45 78          	mov    %rax,0x78(%r13)
    ns->blockshift = idns->lbaf[idns->flbas & 0xF].lbads;
  803844:	41 0f b6 94 24 1a 20 	movzbl 0x201a(%r12),%edx
  80384b:	00 00 
  80384d:	83 e2 0f             	and    $0xf,%edx
  803850:	41 0f b6 8c 94 82 20 	movzbl 0x2082(%r12,%rdx,4),%ecx
  803857:	00 00 
  803859:	0f b6 f1             	movzbl %cl,%esi
  80385c:	66 41 89 b5 8a 00 00 	mov    %si,0x8a(%r13)
  803863:	00 
    ns->blocksize = 1 << ns->blockshift;
  803864:	ba 01 00 00 00       	mov    $0x1,%edx
  803869:	89 d7                	mov    %edx,%edi
  80386b:	d3 e7                	shl    %cl,%edi
  80386d:	66 41 89 bd 88 00 00 	mov    %di,0x88(%r13)
  803874:	00 
    ns->bpshift = ctl->ci.pageshift - ns->blockshift;
  803875:	41 0f b7 4d 50       	movzwl 0x50(%r13),%ecx
  80387a:	29 f1                	sub    %esi,%ecx
  80387c:	66 41 89 8d 8c 00 00 	mov    %cx,0x8c(%r13)
  803883:	00 
    ns->nbpp = 1 << ns->bpshift;
  803884:	d3 e2                	shl    %cl,%edx
  803886:	66 41 89 95 8e 00 00 	mov    %dx,0x8e(%r13)
  80388d:	00 
    ns->pagecount = ns->blockcount >> ns->bpshift;
  80388e:	48 d3 e8             	shr    %cl,%rax
  803891:	49 89 85 80 00 00 00 	mov    %rax,0x80(%r13)
    ns->maxbpio = ctl->ci.maxppio << ns->bpshift;
  803898:	41 0f b7 45 52       	movzwl 0x52(%r13),%eax
  80389d:	d3 e0                	shl    %cl,%eax
  80389f:	66 41 89 85 90 00 00 	mov    %ax,0x90(%r13)
  8038a6:	00 
    uint8_t *sqbuff = ctl->buffer + PAGE_SIZE * (2 * (qid + 1));
  8038a7:	49 8b bd a0 00 00 00 	mov    0xa0(%r13),%rdi
  8038ae:	4c 8d af 00 20 00 00 	lea    0x2000(%rdi),%r13
    uint8_t *cqbuff = ctl->buffer + PAGE_SIZE * (2 * (qid + 1) + 1);
  8038b5:	48 81 c7 00 30 00 00 	add    $0x3000,%rdi
            .sq_doorbell = NVME_SQnTDBL(ctl, qid + 1),
  8038bc:	0f b7 43 68          	movzwl 0x68(%rbx),%eax
    *ioq = (struct NvmeQueueAttributes){
  8038c0:	48 c7 83 f8 00 00 00 	movq   $0x0,0xf8(%rbx)
  8038c7:	00 00 00 00 
  8038cb:	48 c7 83 00 01 00 00 	movq   $0x0,0x100(%rbx)
  8038d2:	00 00 00 00 
  8038d6:	c7 83 d8 00 00 00 01 	movl   $0x1,0xd8(%rbx)
  8038dd:	00 00 00 
  8038e0:	c7 83 dc 00 00 00 20 	movl   $0x20,0xdc(%rbx)
  8038e7:	00 00 00 
  8038ea:	4c 89 ab e0 00 00 00 	mov    %r13,0xe0(%rbx)
  8038f1:	48 89 bb e8 00 00 00 	mov    %rdi,0xe8(%rbx)
            .sq_doorbell = NVME_SQnTDBL(ctl, qid + 1),
  8038f8:	8d 94 00 00 10 00 00 	lea    0x1000(%rax,%rax,1),%edx
  8038ff:	89 93 f0 00 00 00    	mov    %edx,0xf0(%rbx)
            .cq_doorbell = NVME_CQnHDBL(ctl, qid + 1),
  803905:	8d 84 40 00 10 00 00 	lea    0x1000(%rax,%rax,2),%eax
  80390c:	89 83 f4 00 00 00    	mov    %eax,0xf4(%rbx)
    int err = nvme_acmd_create_cq(ctl, ioq, get_phys_addr(cqbuff));
  803912:	48 b8 68 66 80 00 00 	movabs $0x806668,%rax
  803919:	00 00 00 
  80391c:	ff d0                	call   *%rax
  80391e:	49 89 c7             	mov    %rax,%r15
    int cid = adminq->sq_tail;
  803921:	44 8b b3 cc 00 00 00 	mov    0xcc(%rbx),%r14d
    struct NvmeACmdCreateCompletionQueue *cmd = &adminq->sq[cid].create_cq;
  803928:	4d 63 e6             	movslq %r14d,%r12
  80392b:	49 c1 e4 06          	shl    $0x6,%r12
  80392f:	4c 03 a3 b0 00 00 00 	add    0xb0(%rbx),%r12
    memset(cmd, 0, sizeof(*cmd));
  803936:	ba 40 00 00 00       	mov    $0x40,%edx
  80393b:	be 00 00 00 00       	mov    $0x0,%esi
  803940:	4c 89 e7             	mov    %r12,%rdi
  803943:	48 b8 c7 48 80 00 00 	movabs $0x8048c7,%rax
  80394a:	00 00 00 
  80394d:	ff d0                	call   *%rax
    cmd->common.opc = NVME_ACMD_CREATE_CQ;
  80394f:	41 c6 04 24 05       	movb   $0x5,(%r12)
    cmd->common.cid = cid;
  803954:	66 45 89 74 24 02    	mov    %r14w,0x2(%r12)
    cmd->common.prp[0] = prp;
  80395a:	4d 89 7c 24 18       	mov    %r15,0x18(%r12)
    cmd->pc = 1;
  80395f:	41 80 4c 24 2c 01    	orb    $0x1,0x2c(%r12)
    cmd->qid = ioq->id;
  803965:	8b 83 d8 00 00 00    	mov    0xd8(%rbx),%eax
  80396b:	66 41 89 44 24 28    	mov    %ax,0x28(%r12)
    cmd->qsize = ioq->size - 1;
  803971:	0f b7 83 dc 00 00 00 	movzwl 0xdc(%rbx),%eax
  803978:	83 e8 01             	sub    $0x1,%eax
  80397b:	66 41 89 44 24 2a    	mov    %ax,0x2a(%r12)
    int err = nvme_submit_cmd(ctl, adminq);
  803981:	48 8d b3 a8 00 00 00 	lea    0xa8(%rbx),%rsi
  803988:	48 89 df             	mov    %rbx,%rdi
  80398b:	48 b8 42 30 80 00 00 	movabs $0x803042,%rax
  803992:	00 00 00 
  803995:	ff d0                	call   *%rax
    if (err)
  803997:	85 c0                	test   %eax,%eax
  803999:	74 2a                	je     8039c5 <nvme_init+0x7d5>
        panic("NVMe queue initialization failed\n");
  80399b:	48 ba a8 71 80 00 00 	movabs $0x8071a8,%rdx
  8039a2:	00 00 00 
  8039a5:	be 55 01 00 00       	mov    $0x155,%esi
  8039aa:	48 bf 3a 77 80 00 00 	movabs $0x80773a,%rdi
  8039b1:	00 00 00 
  8039b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8039b9:	48 b9 c1 3c 80 00 00 	movabs $0x803cc1,%rcx
  8039c0:	00 00 00 
  8039c3:	ff d1                	call   *%rcx
    err = nvme_wait_completion(ctl, adminq, cid, 300);
  8039c5:	b9 2c 01 00 00       	mov    $0x12c,%ecx
  8039ca:	44 89 f2             	mov    %r14d,%edx
  8039cd:	48 8d b3 a8 00 00 00 	lea    0xa8(%rbx),%rsi
  8039d4:	48 89 df             	mov    %rbx,%rdi
  8039d7:	48 b8 6f 2f 80 00 00 	movabs $0x802f6f,%rax
  8039de:	00 00 00 
  8039e1:	ff d0                	call   *%rax
    if (err) {
  8039e3:	85 c0                	test   %eax,%eax
  8039e5:	75 b4                	jne    80399b <nvme_init+0x7ab>
    err = nvme_acmd_create_sq(ctl, ioq, get_phys_addr(sqbuff));
  8039e7:	4c 89 ef             	mov    %r13,%rdi
  8039ea:	48 b8 68 66 80 00 00 	movabs $0x806668,%rax
  8039f1:	00 00 00 
  8039f4:	ff d0                	call   *%rax
  8039f6:	49 89 c6             	mov    %rax,%r14
    int cid = adminq->sq_tail;
  8039f9:	49 89 dc             	mov    %rbx,%r12
  8039fc:	44 8b ab cc 00 00 00 	mov    0xcc(%rbx),%r13d
    struct NvmeACmdCreateSubmissionQueue *cmd = &adminq->sq[cid].create_sq;
  803a03:	49 63 dd             	movslq %r13d,%rbx
  803a06:	48 c1 e3 06          	shl    $0x6,%rbx
  803a0a:	49 03 9c 24 b0 00 00 	add    0xb0(%r12),%rbx
  803a11:	00 
    memset(cmd, 0, sizeof(*cmd));
  803a12:	ba 40 00 00 00       	mov    $0x40,%edx
  803a17:	be 00 00 00 00       	mov    $0x0,%esi
  803a1c:	48 89 df             	mov    %rbx,%rdi
  803a1f:	48 b8 c7 48 80 00 00 	movabs $0x8048c7,%rax
  803a26:	00 00 00 
  803a29:	ff d0                	call   *%rax
    cmd->common.opc = NVME_ACMD_CREATE_SQ;
  803a2b:	c6 03 01             	movb   $0x1,(%rbx)
    cmd->common.cid = cid;
  803a2e:	66 44 89 6b 02       	mov    %r13w,0x2(%rbx)
    cmd->common.prp[0] = prp;
  803a33:	4c 89 73 18          	mov    %r14,0x18(%rbx)
    cmd->qprio = 2; // 0=urgent 1=high 2=medium 3=low
  803a37:	0f b6 43 2c          	movzbl 0x2c(%rbx),%eax
  803a3b:	83 e0 f9             	and    $0xfffffff9,%eax
  803a3e:	83 c8 05             	or     $0x5,%eax
  803a41:	88 43 2c             	mov    %al,0x2c(%rbx)
    cmd->qid = ioq->id;
  803a44:	41 8b 84 24 d8 00 00 	mov    0xd8(%r12),%eax
  803a4b:	00 
  803a4c:	66 89 43 28          	mov    %ax,0x28(%rbx)
    cmd->cqid = ioq->id;
  803a50:	41 8b 84 24 d8 00 00 	mov    0xd8(%r12),%eax
  803a57:	00 
  803a58:	66 89 43 2e          	mov    %ax,0x2e(%rbx)
    cmd->qsize = ioq->size - 1;
  803a5c:	41 0f b7 84 24 dc 00 	movzwl 0xdc(%r12),%eax
  803a63:	00 00 
  803a65:	83 e8 01             	sub    $0x1,%eax
  803a68:	66 89 43 2a          	mov    %ax,0x2a(%rbx)
    int err = nvme_submit_cmd(ctl, adminq);
  803a6c:	49 8d b4 24 a8 00 00 	lea    0xa8(%r12),%rsi
  803a73:	00 
  803a74:	4c 89 e7             	mov    %r12,%rdi
  803a77:	48 b8 42 30 80 00 00 	movabs $0x803042,%rax
  803a7e:	00 00 00 
  803a81:	ff d0                	call   *%rax
    if (err)
  803a83:	85 c0                	test   %eax,%eax
  803a85:	0f 85 10 ff ff ff    	jne    80399b <nvme_init+0x7ab>
    err = nvme_wait_completion(ctl, adminq, cid, 30);
  803a8b:	b9 1e 00 00 00       	mov    $0x1e,%ecx
  803a90:	44 89 ea             	mov    %r13d,%edx
  803a93:	49 8d b4 24 a8 00 00 	lea    0xa8(%r12),%rsi
  803a9a:	00 
  803a9b:	4c 89 e7             	mov    %r12,%rdi
  803a9e:	48 b8 6f 2f 80 00 00 	movabs $0x802f6f,%rax
  803aa5:	00 00 00 
  803aa8:	ff d0                	call   *%rax
    if (err) {
  803aaa:	85 c0                	test   %eax,%eax
  803aac:	0f 85 e9 fe ff ff    	jne    80399b <nvme_init+0x7ab>
}
  803ab2:	b8 00 00 00 00       	mov    $0x0,%eax
  803ab7:	48 83 c4 08          	add    $0x8,%rsp
  803abb:	5b                   	pop    %rbx
  803abc:	41 5c                	pop    %r12
  803abe:	41 5d                	pop    %r13
  803ac0:	41 5e                	pop    %r14
  803ac2:	41 5f                	pop    %r15
  803ac4:	5d                   	pop    %rbp
  803ac5:	c3                   	ret
        panic("NVMe namespace identification failed\n");
  803ac6:	48 ba d0 71 80 00 00 	movabs $0x8071d0,%rdx
  803acd:	00 00 00 
  803ad0:	be 51 01 00 00       	mov    $0x151,%esi
  803ad5:	48 bf 3a 77 80 00 00 	movabs $0x80773a,%rdi
  803adc:	00 00 00 
  803adf:	b8 00 00 00 00       	mov    $0x0,%eax
  803ae4:	48 b9 c1 3c 80 00 00 	movabs $0x803cc1,%rcx
  803aeb:	00 00 00 
  803aee:	ff d1                	call   *%rcx
        panic("NVMe registers mapping failed\n");
  803af0:	48 ba 48 72 80 00 00 	movabs $0x807248,%rdx
  803af7:	00 00 00 
  803afa:	be 41 01 00 00       	mov    $0x141,%esi
  803aff:	48 bf 3a 77 80 00 00 	movabs $0x80773a,%rdi
  803b06:	00 00 00 
  803b09:	b8 00 00 00 00       	mov    $0x0,%eax
  803b0e:	48 b9 c1 3c 80 00 00 	movabs $0x803cc1,%rcx
  803b15:	00 00 00 
  803b18:	ff d1                	call   *%rcx

0000000000803b1a <nvme_write>:

int
nvme_write(uint64_t secno, const void *src, size_t nsecs) {
  803b1a:	f3 0f 1e fa          	endbr64
    if (!src)
  803b1e:	48 85 f6             	test   %rsi,%rsi
  803b21:	74 58                	je     803b7b <nvme_write+0x61>
nvme_write(uint64_t secno, const void *src, size_t nsecs) {
  803b23:	55                   	push   %rbp
  803b24:	48 89 e5             	mov    %rsp,%rbp
  803b27:	41 54                	push   %r12
  803b29:	53                   	push   %rbx
  803b2a:	48 89 fb             	mov    %rdi,%rbx
  803b2d:	48 89 f7             	mov    %rsi,%rdi
  803b30:	49 89 d4             	mov    %rdx,%r12
        return -NVME_BAD_ARG;

    return nvme_cmd_rw(&nvme, &nvme.ioq[0], NVME_CMD_WRITE,
  803b33:	48 b8 68 66 80 00 00 	movabs $0x806668,%rax
  803b3a:	00 00 00 
  803b3d:	ff d0                	call   *%rax
                       nvme.nsi.id, secno, nsecs, get_phys_addr((void *)src), 0);
  803b3f:	48 bf 80 d5 80 00 00 	movabs $0x80d580,%rdi
  803b46:	00 00 00 
    return nvme_cmd_rw(&nvme, &nvme.ioq[0], NVME_CMD_WRITE,
  803b49:	0f b7 4f 70          	movzwl 0x70(%rdi),%ecx
  803b4d:	6a 00                	push   $0x0
  803b4f:	50                   	push   %rax
  803b50:	45 89 e1             	mov    %r12d,%r9d
  803b53:	49 89 d8             	mov    %rbx,%r8
  803b56:	ba 01 00 00 00       	mov    $0x1,%edx
  803b5b:	48 8d b7 d8 00 00 00 	lea    0xd8(%rdi),%rsi
  803b62:	48 b8 2a 31 80 00 00 	movabs $0x80312a,%rax
  803b69:	00 00 00 
  803b6c:	ff d0                	call   *%rax
  803b6e:	48 83 c4 10          	add    $0x10,%rsp
}
  803b72:	48 8d 65 f0          	lea    -0x10(%rbp),%rsp
  803b76:	5b                   	pop    %rbx
  803b77:	41 5c                	pop    %r12
  803b79:	5d                   	pop    %rbp
  803b7a:	c3                   	ret
        return -NVME_BAD_ARG;
  803b7b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  803b80:	c3                   	ret

0000000000803b81 <nvme_read>:


int
nvme_read(uint64_t secno, void *dst, size_t nsecs) {
  803b81:	f3 0f 1e fa          	endbr64
    if (!dst)
  803b85:	48 85 f6             	test   %rsi,%rsi
  803b88:	74 58                	je     803be2 <nvme_read+0x61>
nvme_read(uint64_t secno, void *dst, size_t nsecs) {
  803b8a:	55                   	push   %rbp
  803b8b:	48 89 e5             	mov    %rsp,%rbp
  803b8e:	41 54                	push   %r12
  803b90:	53                   	push   %rbx
  803b91:	48 89 fb             	mov    %rdi,%rbx
  803b94:	48 89 f7             	mov    %rsi,%rdi
  803b97:	49 89 d4             	mov    %rdx,%r12
     * TIP: This is achieved in exactly the same way as the write command.
     *      Remember that the command takes physical address as an argument
     *      and 'dst' is a virtual address. */
    // LAB 10: Your code here

    return nvme_cmd_rw(&nvme, &nvme.ioq[0], NVME_CMD_READ, nvme.nsi.id, secno, nsecs, get_phys_addr(dst), 0);
  803b9a:	48 b8 68 66 80 00 00 	movabs $0x806668,%rax
  803ba1:	00 00 00 
  803ba4:	ff d0                	call   *%rax
  803ba6:	48 bf 80 d5 80 00 00 	movabs $0x80d580,%rdi
  803bad:	00 00 00 
  803bb0:	0f b7 4f 70          	movzwl 0x70(%rdi),%ecx
  803bb4:	6a 00                	push   $0x0
  803bb6:	50                   	push   %rax
  803bb7:	45 89 e1             	mov    %r12d,%r9d
  803bba:	49 89 d8             	mov    %rbx,%r8
  803bbd:	ba 02 00 00 00       	mov    $0x2,%edx
  803bc2:	48 8d b7 d8 00 00 00 	lea    0xd8(%rdi),%rsi
  803bc9:	48 b8 2a 31 80 00 00 	movabs $0x80312a,%rax
  803bd0:	00 00 00 
  803bd3:	ff d0                	call   *%rax
  803bd5:	48 83 c4 10          	add    $0x10,%rsp
}
  803bd9:	48 8d 65 f0          	lea    -0x10(%rbp),%rsp
  803bdd:	5b                   	pop    %rbx
  803bde:	41 5c                	pop    %r12
  803be0:	5d                   	pop    %rbp
  803be1:	c3                   	ret
        return -NVME_BAD_ARG;
  803be2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  803be7:	c3                   	ret

0000000000803be8 <libmain>:
#ifdef JOS_PROG
void (*volatile sys_exit)(void);
#endif

void
libmain(int argc, char **argv) {
  803be8:	f3 0f 1e fa          	endbr64
  803bec:	55                   	push   %rbp
  803bed:	48 89 e5             	mov    %rsp,%rbp
  803bf0:	41 56                	push   %r14
  803bf2:	41 55                	push   %r13
  803bf4:	41 54                	push   %r12
  803bf6:	53                   	push   %rbx
  803bf7:	41 89 fd             	mov    %edi,%r13d
  803bfa:	49 89 f6             	mov    %rsi,%r14
    /* Perform global constructor initialisation (e.g. asan)
     * This must be done as early as possible */
    extern void (*__ctors_start)(), (*__ctors_end)();
    void (**ctor)() = &__ctors_start;
    while (ctor < &__ctors_end) (*ctor++)();
  803bfd:	48 ba 38 c1 80 00 00 	movabs $0x80c138,%rdx
  803c04:	00 00 00 
  803c07:	48 b8 38 c1 80 00 00 	movabs $0x80c138,%rax
  803c0e:	00 00 00 
  803c11:	48 39 c2             	cmp    %rax,%rdx
  803c14:	73 17                	jae    803c2d <libmain+0x45>
    void (**ctor)() = &__ctors_start;
  803c16:	48 89 d3             	mov    %rdx,%rbx
    while (ctor < &__ctors_end) (*ctor++)();
  803c19:	49 89 c4             	mov    %rax,%r12
  803c1c:	48 83 c3 08          	add    $0x8,%rbx
  803c20:	b8 00 00 00 00       	mov    $0x0,%eax
  803c25:	ff 53 f8             	call   *-0x8(%rbx)
  803c28:	4c 39 e3             	cmp    %r12,%rbx
  803c2b:	72 ef                	jb     803c1c <libmain+0x34>

    /* Set thisenv to point at our Env structure in envs[]. */

    // LAB 8: Your code here
    thisenv = &((struct Env *)UENVS)[ENVX(sys_getenvid())];
  803c2d:	48 b8 9b 4c 80 00 00 	movabs $0x804c9b,%rax
  803c34:	00 00 00 
  803c37:	ff d0                	call   *%rax
  803c39:	25 ff 03 00 00       	and    $0x3ff,%eax
  803c3e:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  803c42:	48 8d 04 50          	lea    (%rax,%rdx,2),%rax
  803c46:	48 c1 e0 04          	shl    $0x4,%rax
  803c4a:	48 ba 00 00 a0 1f 80 	movabs $0x801fa00000,%rdx
  803c51:	00 00 00 
  803c54:	48 01 d0             	add    %rdx,%rax
  803c57:	48 a3 88 d6 80 00 00 	movabs %rax,0x80d688
  803c5e:	00 00 00 

    /* Save the name of the program so that panic() can use it */
    if (argc > 0) binaryname = argv[0];
  803c61:	45 85 ed             	test   %r13d,%r13d
  803c64:	7e 0d                	jle    803c73 <libmain+0x8b>
  803c66:	49 8b 06             	mov    (%r14),%rax
  803c69:	48 a3 68 c0 80 00 00 	movabs %rax,0x80c068
  803c70:	00 00 00 

    /* Call user main routine */
    umain(argc, argv);
  803c73:	4c 89 f6             	mov    %r14,%rsi
  803c76:	44 89 ef             	mov    %r13d,%edi
  803c79:	48 b8 30 19 80 00 00 	movabs $0x801930,%rax
  803c80:	00 00 00 
  803c83:	ff d0                	call   *%rax

#ifdef JOS_PROG
    sys_exit();
#else
    exit();
  803c85:	48 b8 9a 3c 80 00 00 	movabs $0x803c9a,%rax
  803c8c:	00 00 00 
  803c8f:	ff d0                	call   *%rax
#endif
}
  803c91:	5b                   	pop    %rbx
  803c92:	41 5c                	pop    %r12
  803c94:	41 5d                	pop    %r13
  803c96:	41 5e                	pop    %r14
  803c98:	5d                   	pop    %rbp
  803c99:	c3                   	ret

0000000000803c9a <exit>:

#include <inc/lib.h>

void
exit(void) {
  803c9a:	f3 0f 1e fa          	endbr64
  803c9e:	55                   	push   %rbp
  803c9f:	48 89 e5             	mov    %rsp,%rbp
    close_all();
  803ca2:	48 b8 3e 58 80 00 00 	movabs $0x80583e,%rax
  803ca9:	00 00 00 
  803cac:	ff d0                	call   *%rax
    sys_env_destroy(0);
  803cae:	bf 00 00 00 00       	mov    $0x0,%edi
  803cb3:	48 b8 2c 4c 80 00 00 	movabs $0x804c2c,%rax
  803cba:	00 00 00 
  803cbd:	ff d0                	call   *%rax
}
  803cbf:	5d                   	pop    %rbp
  803cc0:	c3                   	ret

0000000000803cc1 <_panic>:

/* Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor. */
void
_panic(const char *file, int line, const char *fmt, ...) {
  803cc1:	f3 0f 1e fa          	endbr64
  803cc5:	55                   	push   %rbp
  803cc6:	48 89 e5             	mov    %rsp,%rbp
  803cc9:	41 56                	push   %r14
  803ccb:	41 55                	push   %r13
  803ccd:	41 54                	push   %r12
  803ccf:	53                   	push   %rbx
  803cd0:	48 83 ec 50          	sub    $0x50,%rsp
  803cd4:	49 89 fc             	mov    %rdi,%r12
  803cd7:	41 89 f5             	mov    %esi,%r13d
  803cda:	48 89 d3             	mov    %rdx,%rbx
  803cdd:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  803ce1:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
  803ce5:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
    va_list ap;

    va_start(ap, fmt);
  803ce9:	c7 45 98 18 00 00 00 	movl   $0x18,-0x68(%rbp)
  803cf0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803cf4:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  803cf8:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  803cfc:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

    /* Print the panic message */
    cprintf("[%08x] user panic in %s at %s:%d: ",
  803d00:	48 b8 68 c0 80 00 00 	movabs $0x80c068,%rax
  803d07:	00 00 00 
  803d0a:	4c 8b 30             	mov    (%rax),%r14
  803d0d:	48 b8 9b 4c 80 00 00 	movabs $0x804c9b,%rax
  803d14:	00 00 00 
  803d17:	ff d0                	call   *%rax
  803d19:	89 c6                	mov    %eax,%esi
  803d1b:	45 89 e8             	mov    %r13d,%r8d
  803d1e:	4c 89 e1             	mov    %r12,%rcx
  803d21:	4c 89 f2             	mov    %r14,%rdx
  803d24:	48 bf 68 72 80 00 00 	movabs $0x807268,%rdi
  803d2b:	00 00 00 
  803d2e:	b8 00 00 00 00       	mov    $0x0,%eax
  803d33:	49 bc 1d 3e 80 00 00 	movabs $0x803e1d,%r12
  803d3a:	00 00 00 
  803d3d:	41 ff d4             	call   *%r12
            sys_getenvid(), binaryname, file, line);
    vcprintf(fmt, ap);
  803d40:	48 8d 75 98          	lea    -0x68(%rbp),%rsi
  803d44:	48 89 df             	mov    %rbx,%rdi
  803d47:	48 b8 b5 3d 80 00 00 	movabs $0x803db5,%rax
  803d4e:	00 00 00 
  803d51:	ff d0                	call   *%rax
    cprintf("\n");
  803d53:	48 bf 92 73 80 00 00 	movabs $0x807392,%rdi
  803d5a:	00 00 00 
  803d5d:	b8 00 00 00 00       	mov    $0x0,%eax
  803d62:	41 ff d4             	call   *%r12

    /* Cause a breakpoint exception */
    for (;;) asm volatile("int3");
  803d65:	cc                   	int3
  803d66:	eb fd                	jmp    803d65 <_panic+0xa4>

0000000000803d68 <putch>:
    int count;  /* total bytes printed so far */
    char buf[PRINTBUFSZ];
};

static void
putch(int ch, struct printbuf *state) {
  803d68:	f3 0f 1e fa          	endbr64
  803d6c:	55                   	push   %rbp
  803d6d:	48 89 e5             	mov    %rsp,%rbp
  803d70:	53                   	push   %rbx
  803d71:	48 83 ec 08          	sub    $0x8,%rsp
  803d75:	48 89 f3             	mov    %rsi,%rbx
    state->buf[state->offset++] = (char)ch;
  803d78:	8b 06                	mov    (%rsi),%eax
  803d7a:	8d 50 01             	lea    0x1(%rax),%edx
  803d7d:	89 16                	mov    %edx,(%rsi)
  803d7f:	48 98                	cltq
  803d81:	40 88 7c 06 08       	mov    %dil,0x8(%rsi,%rax,1)
    if (state->offset == PRINTBUFSZ - 1) {
  803d86:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  803d8c:	74 0a                	je     803d98 <putch+0x30>
        sys_cputs(state->buf, state->offset);
        state->offset = 0;
    }
    state->count++;
  803d8e:	83 43 04 01          	addl   $0x1,0x4(%rbx)
}
  803d92:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  803d96:	c9                   	leave
  803d97:	c3                   	ret
        sys_cputs(state->buf, state->offset);
  803d98:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  803d9c:	be ff 00 00 00       	mov    $0xff,%esi
  803da1:	48 b8 c6 4b 80 00 00 	movabs $0x804bc6,%rax
  803da8:	00 00 00 
  803dab:	ff d0                	call   *%rax
        state->offset = 0;
  803dad:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  803db3:	eb d9                	jmp    803d8e <putch+0x26>

0000000000803db5 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap) {
  803db5:	f3 0f 1e fa          	endbr64
  803db9:	55                   	push   %rbp
  803dba:	48 89 e5             	mov    %rsp,%rbp
  803dbd:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  803dc4:	48 89 fa             	mov    %rdi,%rdx
    struct printbuf state = {0};
  803dc7:	48 8d bd f8 fe ff ff 	lea    -0x108(%rbp),%rdi
  803dce:	b9 21 00 00 00       	mov    $0x21,%ecx
  803dd3:	b8 00 00 00 00       	mov    $0x0,%eax
  803dd8:	f3 48 ab             	rep stos %rax,%es:(%rdi)

    vprintfmt((void *)putch, &state, fmt, ap);
  803ddb:	48 89 f1             	mov    %rsi,%rcx
  803dde:	48 8d b5 f8 fe ff ff 	lea    -0x108(%rbp),%rsi
  803de5:	48 bf 68 3d 80 00 00 	movabs $0x803d68,%rdi
  803dec:	00 00 00 
  803def:	48 b8 7d 3f 80 00 00 	movabs $0x803f7d,%rax
  803df6:	00 00 00 
  803df9:	ff d0                	call   *%rax
    sys_cputs(state.buf, state.offset);
  803dfb:	48 63 b5 f8 fe ff ff 	movslq -0x108(%rbp),%rsi
  803e02:	48 8d bd 00 ff ff ff 	lea    -0x100(%rbp),%rdi
  803e09:	48 b8 c6 4b 80 00 00 	movabs $0x804bc6,%rax
  803e10:	00 00 00 
  803e13:	ff d0                	call   *%rax

    return state.count;
}
  803e15:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
  803e1b:	c9                   	leave
  803e1c:	c3                   	ret

0000000000803e1d <cprintf>:

int
cprintf(const char *fmt, ...) {
  803e1d:	f3 0f 1e fa          	endbr64
  803e21:	55                   	push   %rbp
  803e22:	48 89 e5             	mov    %rsp,%rbp
  803e25:	48 83 ec 50          	sub    $0x50,%rsp
  803e29:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
  803e2d:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803e31:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  803e35:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  803e39:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;
    int count;

    va_start(ap, fmt);
  803e3d:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
  803e44:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803e48:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  803e4c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803e50:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    count = vcprintf(fmt, ap);
  803e54:	48 8d 75 b8          	lea    -0x48(%rbp),%rsi
  803e58:	48 b8 b5 3d 80 00 00 	movabs $0x803db5,%rax
  803e5f:	00 00 00 
  803e62:	ff d0                	call   *%rax
    va_end(ap);

    return count;
}
  803e64:	c9                   	leave
  803e65:	c3                   	ret

0000000000803e66 <print_num>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void
print_num(void (*putch)(int, void *), void *put_arg,
          uintmax_t num, unsigned base, int width, char padc, bool capital) {
  803e66:	f3 0f 1e fa          	endbr64
  803e6a:	55                   	push   %rbp
  803e6b:	48 89 e5             	mov    %rsp,%rbp
  803e6e:	41 57                	push   %r15
  803e70:	41 56                	push   %r14
  803e72:	41 55                	push   %r13
  803e74:	41 54                	push   %r12
  803e76:	53                   	push   %rbx
  803e77:	48 83 ec 18          	sub    $0x18,%rsp
  803e7b:	49 89 fc             	mov    %rdi,%r12
  803e7e:	49 89 f5             	mov    %rsi,%r13
  803e81:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  803e85:	8b 45 10             	mov    0x10(%rbp),%eax
  803e88:	89 45 c4             	mov    %eax,-0x3c(%rbp)
    /* First recursively print all preceding (more significant) digits */
    if (num >= base) {
  803e8b:	41 89 cf             	mov    %ecx,%r15d
  803e8e:	4c 39 fa             	cmp    %r15,%rdx
  803e91:	73 5b                	jae    803eee <print_num+0x88>
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
    } else {
        /* Print any needed pad characters before first digit */
        while (--width > 0) {
  803e93:	41 8d 58 ff          	lea    -0x1(%r8),%ebx
            putch(padc, put_arg);
  803e97:	45 0f be f1          	movsbl %r9b,%r14d
        while (--width > 0) {
  803e9b:	85 db                	test   %ebx,%ebx
  803e9d:	7e 0e                	jle    803ead <print_num+0x47>
            putch(padc, put_arg);
  803e9f:	4c 89 ee             	mov    %r13,%rsi
  803ea2:	44 89 f7             	mov    %r14d,%edi
  803ea5:	41 ff d4             	call   *%r12
        while (--width > 0) {
  803ea8:	83 eb 01             	sub    $0x1,%ebx
  803eab:	75 f2                	jne    803e9f <print_num+0x39>
        }
    }

    const char *dig = capital ? "0123456789ABCDEF" : "0123456789abcdef";
  803ead:	80 7d c4 00          	cmpb   $0x0,-0x3c(%rbp)
  803eb1:	48 b9 9c 77 80 00 00 	movabs $0x80779c,%rcx
  803eb8:	00 00 00 
  803ebb:	48 b8 8b 77 80 00 00 	movabs $0x80778b,%rax
  803ec2:	00 00 00 
  803ec5:	48 0f 45 c8          	cmovne %rax,%rcx

    /* Then print this (the least significant) digit */
    putch(dig[num % base], put_arg);
  803ec9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803ecd:	ba 00 00 00 00       	mov    $0x0,%edx
  803ed2:	49 f7 f7             	div    %r15
  803ed5:	0f be 3c 11          	movsbl (%rcx,%rdx,1),%edi
  803ed9:	4c 89 ee             	mov    %r13,%rsi
  803edc:	41 ff d4             	call   *%r12
}
  803edf:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  803ee3:	5b                   	pop    %rbx
  803ee4:	41 5c                	pop    %r12
  803ee6:	41 5d                	pop    %r13
  803ee8:	41 5e                	pop    %r14
  803eea:	41 5f                	pop    %r15
  803eec:	5d                   	pop    %rbp
  803eed:	c3                   	ret
        print_num(putch, put_arg, num / base, base, width - 1, padc, capital);
  803eee:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803ef2:	ba 00 00 00 00       	mov    $0x0,%edx
  803ef7:	49 f7 f7             	div    %r15
  803efa:	48 83 ec 08          	sub    $0x8,%rsp
  803efe:	0f b6 55 c4          	movzbl -0x3c(%rbp),%edx
  803f02:	52                   	push   %rdx
  803f03:	45 0f be c9          	movsbl %r9b,%r9d
  803f07:	45 8d 40 ff          	lea    -0x1(%r8),%r8d
  803f0b:	48 89 c2             	mov    %rax,%rdx
  803f0e:	48 b8 66 3e 80 00 00 	movabs $0x803e66,%rax
  803f15:	00 00 00 
  803f18:	ff d0                	call   *%rax
  803f1a:	48 83 c4 10          	add    $0x10,%rsp
  803f1e:	eb 8d                	jmp    803ead <print_num+0x47>

0000000000803f20 <sprintputch>:
    char *end;
    int count;
};

static void
sprintputch(int ch, struct sprintbuf *state) {
  803f20:	f3 0f 1e fa          	endbr64
    state->count++;
  803f24:	83 46 10 01          	addl   $0x1,0x10(%rsi)
    if (state->start < state->end) {
  803f28:	48 8b 06             	mov    (%rsi),%rax
  803f2b:	48 3b 46 08          	cmp    0x8(%rsi),%rax
  803f2f:	73 0a                	jae    803f3b <sprintputch+0x1b>
        *state->start++ = ch;
  803f31:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803f35:	48 89 16             	mov    %rdx,(%rsi)
  803f38:	40 88 38             	mov    %dil,(%rax)
    }
}
  803f3b:	c3                   	ret

0000000000803f3c <printfmt>:
printfmt(void (*putch)(int, void *), void *putdat, const char *fmt, ...) {
  803f3c:	f3 0f 1e fa          	endbr64
  803f40:	55                   	push   %rbp
  803f41:	48 89 e5             	mov    %rsp,%rbp
  803f44:	48 83 ec 50          	sub    $0x50,%rsp
  803f48:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  803f4c:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  803f50:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(ap, fmt);
  803f54:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  803f5b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803f5f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  803f63:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803f67:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    vprintfmt(putch, putdat, fmt, ap);
  803f6b:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  803f6f:	48 b8 7d 3f 80 00 00 	movabs $0x803f7d,%rax
  803f76:	00 00 00 
  803f79:	ff d0                	call   *%rax
}
  803f7b:	c9                   	leave
  803f7c:	c3                   	ret

0000000000803f7d <vprintfmt>:
vprintfmt(void (*putch)(int, void *), void *put_arg, const char *fmt, va_list ap) {
  803f7d:	f3 0f 1e fa          	endbr64
  803f81:	55                   	push   %rbp
  803f82:	48 89 e5             	mov    %rsp,%rbp
  803f85:	41 57                	push   %r15
  803f87:	41 56                	push   %r14
  803f89:	41 55                	push   %r13
  803f8b:	41 54                	push   %r12
  803f8d:	53                   	push   %rbx
  803f8e:	48 83 ec 38          	sub    $0x38,%rsp
  803f92:	49 89 fe             	mov    %rdi,%r14
  803f95:	49 89 f5             	mov    %rsi,%r13
  803f98:	48 89 d3             	mov    %rdx,%rbx
    va_copy(aq, ap);
  803f9b:	48 8b 01             	mov    (%rcx),%rax
  803f9e:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  803fa2:	48 8b 41 08          	mov    0x8(%rcx),%rax
  803fa6:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  803faa:	48 8b 41 10          	mov    0x10(%rcx),%rax
  803fae:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        while ((ch = *ufmt++) != '%') {
  803fb2:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  803fb6:	0f b6 3b             	movzbl (%rbx),%edi
  803fb9:	40 80 ff 25          	cmp    $0x25,%dil
  803fbd:	74 18                	je     803fd7 <vprintfmt+0x5a>
            if (!ch) return;
  803fbf:	40 84 ff             	test   %dil,%dil
  803fc2:	0f 84 b2 06 00 00    	je     80467a <vprintfmt+0x6fd>
            putch(ch, put_arg);
  803fc8:	40 0f b6 ff          	movzbl %dil,%edi
  803fcc:	4c 89 ee             	mov    %r13,%rsi
  803fcf:	41 ff d6             	call   *%r14
        while ((ch = *ufmt++) != '%') {
  803fd2:	4c 89 e3             	mov    %r12,%rbx
  803fd5:	eb db                	jmp    803fb2 <vprintfmt+0x35>
        bool altflag = 0, zflag = 0;
  803fd7:	be 00 00 00 00       	mov    $0x0,%esi
  803fdc:	c6 45 ab 00          	movb   $0x0,-0x55(%rbp)
        unsigned lflag = 0, base = 10;
  803fe0:	ba 00 00 00 00       	mov    $0x0,%edx
        int width = -1, precision = -1;
  803fe5:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  803feb:	c7 45 ac ff ff ff ff 	movl   $0xffffffff,-0x54(%rbp)
        char padc = ' ';
  803ff2:	c6 45 aa 20          	movb   $0x20,-0x56(%rbp)
        switch (ch = *ufmt++) {
  803ff6:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  803ffb:	41 0f b6 04 24       	movzbl (%r12),%eax
  804000:	88 45 a0             	mov    %al,-0x60(%rbp)
  804003:	83 e8 23             	sub    $0x23,%eax
  804006:	3c 57                	cmp    $0x57,%al
  804008:	0f 87 52 06 00 00    	ja     804660 <vprintfmt+0x6e3>
  80400e:	0f b6 c0             	movzbl %al,%eax
  804011:	48 b9 20 7a 80 00 00 	movabs $0x807a20,%rcx
  804018:	00 00 00 
  80401b:	3e ff 24 c1          	notrack jmp *(%rcx,%rax,8)
  80401f:	49 89 dc             	mov    %rbx,%r12
            altflag = 1;
  804022:	c6 45 ab 01          	movb   $0x1,-0x55(%rbp)
  804026:	eb ce                	jmp    803ff6 <vprintfmt+0x79>
        switch (ch = *ufmt++) {
  804028:	49 89 dc             	mov    %rbx,%r12
  80402b:	be 01 00 00 00       	mov    $0x1,%esi
  804030:	eb c4                	jmp    803ff6 <vprintfmt+0x79>
            padc = ch;
  804032:	0f b6 45 a0          	movzbl -0x60(%rbp),%eax
  804036:	88 45 aa             	mov    %al,-0x56(%rbp)
        switch (ch = *ufmt++) {
  804039:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  80403c:	eb b8                	jmp    803ff6 <vprintfmt+0x79>
            precision = va_arg(aq, int);
  80403e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  804041:	83 f8 2f             	cmp    $0x2f,%eax
  804044:	77 24                	ja     80406a <vprintfmt+0xed>
  804046:	89 c1                	mov    %eax,%ecx
  804048:	48 03 4d c8          	add    -0x38(%rbp),%rcx
  80404c:	83 c0 08             	add    $0x8,%eax
  80404f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  804052:	44 8b 39             	mov    (%rcx),%r15d
        switch (ch = *ufmt++) {
  804055:	49 89 dc             	mov    %rbx,%r12
            if (width < 0) {
  804058:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  80405c:	79 98                	jns    803ff6 <vprintfmt+0x79>
                width = precision;
  80405e:	44 89 7d ac          	mov    %r15d,-0x54(%rbp)
                precision = -1;
  804062:	41 bf ff ff ff ff    	mov    $0xffffffff,%r15d
  804068:	eb 8c                	jmp    803ff6 <vprintfmt+0x79>
            precision = va_arg(aq, int);
  80406a:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  80406e:	48 8d 41 08          	lea    0x8(%rcx),%rax
  804072:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  804076:	eb da                	jmp    804052 <vprintfmt+0xd5>
                precision = precision * 10 + ch - '0';
  804078:	44 0f b6 7d a0       	movzbl -0x60(%rbp),%r15d
  80407d:	41 83 ef 30          	sub    $0x30,%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  804081:	41 0f b6 44 24 01    	movzbl 0x1(%r12),%eax
  804087:	3c 39                	cmp    $0x39,%al
  804089:	77 1c                	ja     8040a7 <vprintfmt+0x12a>
            for (precision = 0;; ++ufmt) {
  80408b:	48 83 c3 01          	add    $0x1,%rbx
                precision = precision * 10 + ch - '0';
  80408f:	43 8d 0c bf          	lea    (%r15,%r15,4),%ecx
  804093:	0f b6 c0             	movzbl %al,%eax
  804096:	44 8d 7c 48 d0       	lea    -0x30(%rax,%rcx,2),%r15d
                if ((ch = *ufmt) - '0' > 9) break;
  80409b:	0f b6 03             	movzbl (%rbx),%eax
  80409e:	3c 39                	cmp    $0x39,%al
  8040a0:	76 e9                	jbe    80408b <vprintfmt+0x10e>
        process_precision:
  8040a2:	49 89 dc             	mov    %rbx,%r12
  8040a5:	eb b1                	jmp    804058 <vprintfmt+0xdb>
        switch (ch = *ufmt++) {
  8040a7:	49 89 dc             	mov    %rbx,%r12
  8040aa:	eb ac                	jmp    804058 <vprintfmt+0xdb>
            width = MAX(0, width);
  8040ac:	8b 4d ac             	mov    -0x54(%rbp),%ecx
  8040af:	85 c9                	test   %ecx,%ecx
  8040b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8040b6:	0f 49 c1             	cmovns %ecx,%eax
  8040b9:	89 45 ac             	mov    %eax,-0x54(%rbp)
        switch (ch = *ufmt++) {
  8040bc:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  8040bf:	e9 32 ff ff ff       	jmp    803ff6 <vprintfmt+0x79>
            lflag++;
  8040c4:	83 c2 01             	add    $0x1,%edx
        switch (ch = *ufmt++) {
  8040c7:	49 89 dc             	mov    %rbx,%r12
            goto reswitch;
  8040ca:	e9 27 ff ff ff       	jmp    803ff6 <vprintfmt+0x79>
            putch(va_arg(aq, int), put_arg);
  8040cf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8040d2:	83 f8 2f             	cmp    $0x2f,%eax
  8040d5:	77 19                	ja     8040f0 <vprintfmt+0x173>
  8040d7:	89 c2                	mov    %eax,%edx
  8040d9:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8040dd:	83 c0 08             	add    $0x8,%eax
  8040e0:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8040e3:	8b 3a                	mov    (%rdx),%edi
  8040e5:	4c 89 ee             	mov    %r13,%rsi
  8040e8:	41 ff d6             	call   *%r14
            break;
  8040eb:	e9 c2 fe ff ff       	jmp    803fb2 <vprintfmt+0x35>
            putch(va_arg(aq, int), put_arg);
  8040f0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8040f4:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8040f8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8040fc:	eb e5                	jmp    8040e3 <vprintfmt+0x166>
            int err = va_arg(aq, int);
  8040fe:	8b 45 b8             	mov    -0x48(%rbp),%eax
  804101:	83 f8 2f             	cmp    $0x2f,%eax
  804104:	77 5a                	ja     804160 <vprintfmt+0x1e3>
  804106:	89 c2                	mov    %eax,%edx
  804108:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80410c:	83 c0 08             	add    $0x8,%eax
  80410f:	89 45 b8             	mov    %eax,-0x48(%rbp)
            if (err < 0) err = -err;
  804112:	8b 02                	mov    (%rdx),%eax
  804114:	89 c1                	mov    %eax,%ecx
  804116:	f7 d9                	neg    %ecx
  804118:	0f 48 c8             	cmovs  %eax,%ecx
            if (err >= MAXERROR || !(strerr = error_string[err])) {
  80411b:	83 f9 13             	cmp    $0x13,%ecx
  80411e:	7f 4e                	jg     80416e <vprintfmt+0x1f1>
  804120:	48 63 c1             	movslq %ecx,%rax
  804123:	48 ba e0 7c 80 00 00 	movabs $0x807ce0,%rdx
  80412a:	00 00 00 
  80412d:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  804131:	48 85 c0             	test   %rax,%rax
  804134:	74 38                	je     80416e <vprintfmt+0x1f1>
                printfmt(putch, put_arg, "%s", strerr);
  804136:	48 89 c1             	mov    %rax,%rcx
  804139:	48 ba a6 73 80 00 00 	movabs $0x8073a6,%rdx
  804140:	00 00 00 
  804143:	4c 89 ee             	mov    %r13,%rsi
  804146:	4c 89 f7             	mov    %r14,%rdi
  804149:	b8 00 00 00 00       	mov    $0x0,%eax
  80414e:	49 b8 3c 3f 80 00 00 	movabs $0x803f3c,%r8
  804155:	00 00 00 
  804158:	41 ff d0             	call   *%r8
  80415b:	e9 52 fe ff ff       	jmp    803fb2 <vprintfmt+0x35>
            int err = va_arg(aq, int);
  804160:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  804164:	48 8d 42 08          	lea    0x8(%rdx),%rax
  804168:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80416c:	eb a4                	jmp    804112 <vprintfmt+0x195>
                printfmt(putch, put_arg, "error %d", err);
  80416e:	48 ba b4 77 80 00 00 	movabs $0x8077b4,%rdx
  804175:	00 00 00 
  804178:	4c 89 ee             	mov    %r13,%rsi
  80417b:	4c 89 f7             	mov    %r14,%rdi
  80417e:	b8 00 00 00 00       	mov    $0x0,%eax
  804183:	49 b8 3c 3f 80 00 00 	movabs $0x803f3c,%r8
  80418a:	00 00 00 
  80418d:	41 ff d0             	call   *%r8
  804190:	e9 1d fe ff ff       	jmp    803fb2 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  804195:	8b 45 b8             	mov    -0x48(%rbp),%eax
  804198:	83 f8 2f             	cmp    $0x2f,%eax
  80419b:	77 6c                	ja     804209 <vprintfmt+0x28c>
  80419d:	89 c2                	mov    %eax,%edx
  80419f:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8041a3:	83 c0 08             	add    $0x8,%eax
  8041a6:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8041a9:	48 8b 12             	mov    (%rdx),%rdx
            if (!ptr) ptr = "(null)";
  8041ac:	48 85 d2             	test   %rdx,%rdx
  8041af:	48 b8 ad 77 80 00 00 	movabs $0x8077ad,%rax
  8041b6:	00 00 00 
  8041b9:	48 0f 45 c2          	cmovne %rdx,%rax
  8041bd:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
            if (width > 0 && padc != '-') {
  8041c1:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  8041c5:	7e 06                	jle    8041cd <vprintfmt+0x250>
  8041c7:	80 7d aa 2d          	cmpb   $0x2d,-0x56(%rbp)
  8041cb:	75 4a                	jne    804217 <vprintfmt+0x29a>
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  8041cd:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8041d1:	4c 8d 60 01          	lea    0x1(%rax),%r12
  8041d5:	0f b6 00             	movzbl (%rax),%eax
  8041d8:	84 c0                	test   %al,%al
  8041da:	0f 85 9a 00 00 00    	jne    80427a <vprintfmt+0x2fd>
            while (width-- > 0) putch(' ', put_arg);
  8041e0:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8041e3:	44 8d 60 ff          	lea    -0x1(%rax),%r12d
  8041e7:	85 c0                	test   %eax,%eax
  8041e9:	0f 8e c3 fd ff ff    	jle    803fb2 <vprintfmt+0x35>
  8041ef:	4c 89 ee             	mov    %r13,%rsi
  8041f2:	bf 20 00 00 00       	mov    $0x20,%edi
  8041f7:	41 ff d6             	call   *%r14
  8041fa:	41 83 ec 01          	sub    $0x1,%r12d
  8041fe:	41 83 fc ff          	cmp    $0xffffffff,%r12d
  804202:	75 eb                	jne    8041ef <vprintfmt+0x272>
  804204:	e9 a9 fd ff ff       	jmp    803fb2 <vprintfmt+0x35>
            const char *ptr = va_arg(aq, char *);
  804209:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80420d:	48 8d 42 08          	lea    0x8(%rdx),%rax
  804211:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  804215:	eb 92                	jmp    8041a9 <vprintfmt+0x22c>
                width -= strnlen(ptr, precision);
  804217:	49 63 f7             	movslq %r15d,%rsi
  80421a:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  80421e:	48 b8 40 47 80 00 00 	movabs $0x804740,%rax
  804225:	00 00 00 
  804228:	ff d0                	call   *%rax
  80422a:	48 89 c2             	mov    %rax,%rdx
  80422d:	8b 45 ac             	mov    -0x54(%rbp),%eax
  804230:	29 d0                	sub    %edx,%eax
                while (width-- > 0) putch(padc, put_arg);
  804232:	8d 70 ff             	lea    -0x1(%rax),%esi
  804235:	89 75 ac             	mov    %esi,-0x54(%rbp)
  804238:	85 c0                	test   %eax,%eax
  80423a:	7e 91                	jle    8041cd <vprintfmt+0x250>
  80423c:	44 0f be 65 aa       	movsbl -0x56(%rbp),%r12d
  804241:	4c 89 ee             	mov    %r13,%rsi
  804244:	44 89 e7             	mov    %r12d,%edi
  804247:	41 ff d6             	call   *%r14
  80424a:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  80424e:	8b 45 ac             	mov    -0x54(%rbp),%eax
  804251:	83 f8 ff             	cmp    $0xffffffff,%eax
  804254:	75 eb                	jne    804241 <vprintfmt+0x2c4>
  804256:	e9 72 ff ff ff       	jmp    8041cd <vprintfmt+0x250>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  80425b:	0f b6 f8             	movzbl %al,%edi
  80425e:	4c 89 ee             	mov    %r13,%rsi
  804261:	41 ff d6             	call   *%r14
            for (; (ch = *ptr++) && (precision < 0 || --precision >= 0); width--) {
  804264:	83 6d ac 01          	subl   $0x1,-0x54(%rbp)
  804268:	49 83 c4 01          	add    $0x1,%r12
  80426c:	41 0f b6 44 24 ff    	movzbl -0x1(%r12),%eax
  804272:	84 c0                	test   %al,%al
  804274:	0f 84 66 ff ff ff    	je     8041e0 <vprintfmt+0x263>
  80427a:	45 85 ff             	test   %r15d,%r15d
  80427d:	78 0a                	js     804289 <vprintfmt+0x30c>
  80427f:	41 83 ef 01          	sub    $0x1,%r15d
  804283:	0f 88 57 ff ff ff    	js     8041e0 <vprintfmt+0x263>
                putch(altflag && (ch < ' ' || ch > '~') ? '?' : ch, put_arg);
  804289:	80 7d ab 00          	cmpb   $0x0,-0x55(%rbp)
  80428d:	74 cc                	je     80425b <vprintfmt+0x2de>
  80428f:	8d 50 e0             	lea    -0x20(%rax),%edx
  804292:	bf 3f 00 00 00       	mov    $0x3f,%edi
  804297:	80 fa 5e             	cmp    $0x5e,%dl
  80429a:	77 c2                	ja     80425e <vprintfmt+0x2e1>
  80429c:	eb bd                	jmp    80425b <vprintfmt+0x2de>
    if (zflag) return va_arg(*ap, size_t);
  80429e:	40 84 f6             	test   %sil,%sil
  8042a1:	75 26                	jne    8042c9 <vprintfmt+0x34c>
    switch (lflag) {
  8042a3:	85 d2                	test   %edx,%edx
  8042a5:	74 59                	je     804300 <vprintfmt+0x383>
  8042a7:	83 fa 01             	cmp    $0x1,%edx
  8042aa:	74 7b                	je     804327 <vprintfmt+0x3aa>
        return va_arg(*ap, long long);
  8042ac:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8042af:	83 f8 2f             	cmp    $0x2f,%eax
  8042b2:	0f 87 96 00 00 00    	ja     80434e <vprintfmt+0x3d1>
  8042b8:	89 c2                	mov    %eax,%edx
  8042ba:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8042be:	83 c0 08             	add    $0x8,%eax
  8042c1:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8042c4:	4c 8b 22             	mov    (%rdx),%r12
  8042c7:	eb 17                	jmp    8042e0 <vprintfmt+0x363>
    if (zflag) return va_arg(*ap, size_t);
  8042c9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8042cc:	83 f8 2f             	cmp    $0x2f,%eax
  8042cf:	77 21                	ja     8042f2 <vprintfmt+0x375>
  8042d1:	89 c2                	mov    %eax,%edx
  8042d3:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8042d7:	83 c0 08             	add    $0x8,%eax
  8042da:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8042dd:	4c 8b 22             	mov    (%rdx),%r12
            if (i < 0) {
  8042e0:	4d 85 e4             	test   %r12,%r12
  8042e3:	78 7a                	js     80435f <vprintfmt+0x3e2>
            num = i;
  8042e5:	4c 89 e2             	mov    %r12,%rdx
        unsigned lflag = 0, base = 10;
  8042e8:	b9 0a 00 00 00       	mov    $0xa,%ecx
            goto number;
  8042ed:	e9 50 02 00 00       	jmp    804542 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8042f2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8042f6:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8042fa:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8042fe:	eb dd                	jmp    8042dd <vprintfmt+0x360>
        return va_arg(*ap, int);
  804300:	8b 45 b8             	mov    -0x48(%rbp),%eax
  804303:	83 f8 2f             	cmp    $0x2f,%eax
  804306:	77 11                	ja     804319 <vprintfmt+0x39c>
  804308:	89 c2                	mov    %eax,%edx
  80430a:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80430e:	83 c0 08             	add    $0x8,%eax
  804311:	89 45 b8             	mov    %eax,-0x48(%rbp)
  804314:	4c 63 22             	movslq (%rdx),%r12
  804317:	eb c7                	jmp    8042e0 <vprintfmt+0x363>
  804319:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80431d:	48 8d 42 08          	lea    0x8(%rdx),%rax
  804321:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  804325:	eb ed                	jmp    804314 <vprintfmt+0x397>
        return va_arg(*ap, long);
  804327:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80432a:	83 f8 2f             	cmp    $0x2f,%eax
  80432d:	77 11                	ja     804340 <vprintfmt+0x3c3>
  80432f:	89 c2                	mov    %eax,%edx
  804331:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  804335:	83 c0 08             	add    $0x8,%eax
  804338:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80433b:	4c 8b 22             	mov    (%rdx),%r12
  80433e:	eb a0                	jmp    8042e0 <vprintfmt+0x363>
  804340:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  804344:	48 8d 42 08          	lea    0x8(%rdx),%rax
  804348:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80434c:	eb ed                	jmp    80433b <vprintfmt+0x3be>
        return va_arg(*ap, long long);
  80434e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  804352:	48 8d 42 08          	lea    0x8(%rdx),%rax
  804356:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80435a:	e9 65 ff ff ff       	jmp    8042c4 <vprintfmt+0x347>
                putch('-', put_arg);
  80435f:	4c 89 ee             	mov    %r13,%rsi
  804362:	bf 2d 00 00 00       	mov    $0x2d,%edi
  804367:	41 ff d6             	call   *%r14
                i = -i;
  80436a:	49 f7 dc             	neg    %r12
  80436d:	e9 73 ff ff ff       	jmp    8042e5 <vprintfmt+0x368>
    if (zflag) return va_arg(*ap, size_t);
  804372:	40 84 f6             	test   %sil,%sil
  804375:	75 32                	jne    8043a9 <vprintfmt+0x42c>
    switch (lflag) {
  804377:	85 d2                	test   %edx,%edx
  804379:	74 5d                	je     8043d8 <vprintfmt+0x45b>
  80437b:	83 fa 01             	cmp    $0x1,%edx
  80437e:	0f 84 82 00 00 00    	je     804406 <vprintfmt+0x489>
        return va_arg(*ap, unsigned long long);
  804384:	8b 45 b8             	mov    -0x48(%rbp),%eax
  804387:	83 f8 2f             	cmp    $0x2f,%eax
  80438a:	0f 87 a5 00 00 00    	ja     804435 <vprintfmt+0x4b8>
  804390:	89 c2                	mov    %eax,%edx
  804392:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  804396:	83 c0 08             	add    $0x8,%eax
  804399:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80439c:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  80439f:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long long);
  8043a4:	e9 99 01 00 00       	jmp    804542 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8043a9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8043ac:	83 f8 2f             	cmp    $0x2f,%eax
  8043af:	77 19                	ja     8043ca <vprintfmt+0x44d>
  8043b1:	89 c2                	mov    %eax,%edx
  8043b3:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8043b7:	83 c0 08             	add    $0x8,%eax
  8043ba:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8043bd:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  8043c0:	b9 0a 00 00 00       	mov    $0xa,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8043c5:	e9 78 01 00 00       	jmp    804542 <vprintfmt+0x5c5>
  8043ca:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8043ce:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8043d2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8043d6:	eb e5                	jmp    8043bd <vprintfmt+0x440>
        return va_arg(*ap, unsigned int);
  8043d8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8043db:	83 f8 2f             	cmp    $0x2f,%eax
  8043de:	77 18                	ja     8043f8 <vprintfmt+0x47b>
  8043e0:	89 c2                	mov    %eax,%edx
  8043e2:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8043e6:	83 c0 08             	add    $0x8,%eax
  8043e9:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8043ec:	8b 12                	mov    (%rdx),%edx
        unsigned lflag = 0, base = 10;
  8043ee:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned int);
  8043f3:	e9 4a 01 00 00       	jmp    804542 <vprintfmt+0x5c5>
  8043f8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8043fc:	48 8d 42 08          	lea    0x8(%rdx),%rax
  804400:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  804404:	eb e6                	jmp    8043ec <vprintfmt+0x46f>
        return va_arg(*ap, unsigned long);
  804406:	8b 45 b8             	mov    -0x48(%rbp),%eax
  804409:	83 f8 2f             	cmp    $0x2f,%eax
  80440c:	77 19                	ja     804427 <vprintfmt+0x4aa>
  80440e:	89 c2                	mov    %eax,%edx
  804410:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  804414:	83 c0 08             	add    $0x8,%eax
  804417:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80441a:	48 8b 12             	mov    (%rdx),%rdx
        unsigned lflag = 0, base = 10;
  80441d:	b9 0a 00 00 00       	mov    $0xa,%ecx
        return va_arg(*ap, unsigned long);
  804422:	e9 1b 01 00 00       	jmp    804542 <vprintfmt+0x5c5>
  804427:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80442b:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80442f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  804433:	eb e5                	jmp    80441a <vprintfmt+0x49d>
        return va_arg(*ap, unsigned long long);
  804435:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  804439:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80443d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  804441:	e9 56 ff ff ff       	jmp    80439c <vprintfmt+0x41f>
    if (zflag) return va_arg(*ap, size_t);
  804446:	40 84 f6             	test   %sil,%sil
  804449:	75 2e                	jne    804479 <vprintfmt+0x4fc>
    switch (lflag) {
  80444b:	85 d2                	test   %edx,%edx
  80444d:	74 59                	je     8044a8 <vprintfmt+0x52b>
  80444f:	83 fa 01             	cmp    $0x1,%edx
  804452:	74 7f                	je     8044d3 <vprintfmt+0x556>
        return va_arg(*ap, unsigned long long);
  804454:	8b 45 b8             	mov    -0x48(%rbp),%eax
  804457:	83 f8 2f             	cmp    $0x2f,%eax
  80445a:	0f 87 9f 00 00 00    	ja     8044ff <vprintfmt+0x582>
  804460:	89 c2                	mov    %eax,%edx
  804462:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  804466:	83 c0 08             	add    $0x8,%eax
  804469:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80446c:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  80446f:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long long);
  804474:	e9 c9 00 00 00       	jmp    804542 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  804479:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80447c:	83 f8 2f             	cmp    $0x2f,%eax
  80447f:	77 19                	ja     80449a <vprintfmt+0x51d>
  804481:	89 c2                	mov    %eax,%edx
  804483:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  804487:	83 c0 08             	add    $0x8,%eax
  80448a:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80448d:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  804490:	b9 08 00 00 00       	mov    $0x8,%ecx
    if (zflag) return va_arg(*ap, size_t);
  804495:	e9 a8 00 00 00       	jmp    804542 <vprintfmt+0x5c5>
  80449a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80449e:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8044a2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8044a6:	eb e5                	jmp    80448d <vprintfmt+0x510>
        return va_arg(*ap, unsigned int);
  8044a8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8044ab:	83 f8 2f             	cmp    $0x2f,%eax
  8044ae:	77 15                	ja     8044c5 <vprintfmt+0x548>
  8044b0:	89 c2                	mov    %eax,%edx
  8044b2:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8044b6:	83 c0 08             	add    $0x8,%eax
  8044b9:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8044bc:	8b 12                	mov    (%rdx),%edx
            base = 8;
  8044be:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned int);
  8044c3:	eb 7d                	jmp    804542 <vprintfmt+0x5c5>
  8044c5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8044c9:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8044cd:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8044d1:	eb e9                	jmp    8044bc <vprintfmt+0x53f>
        return va_arg(*ap, unsigned long);
  8044d3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8044d6:	83 f8 2f             	cmp    $0x2f,%eax
  8044d9:	77 16                	ja     8044f1 <vprintfmt+0x574>
  8044db:	89 c2                	mov    %eax,%edx
  8044dd:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8044e1:	83 c0 08             	add    $0x8,%eax
  8044e4:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8044e7:	48 8b 12             	mov    (%rdx),%rdx
            base = 8;
  8044ea:	b9 08 00 00 00       	mov    $0x8,%ecx
        return va_arg(*ap, unsigned long);
  8044ef:	eb 51                	jmp    804542 <vprintfmt+0x5c5>
  8044f1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8044f5:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8044f9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8044fd:	eb e8                	jmp    8044e7 <vprintfmt+0x56a>
        return va_arg(*ap, unsigned long long);
  8044ff:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  804503:	48 8d 42 08          	lea    0x8(%rdx),%rax
  804507:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80450b:	e9 5c ff ff ff       	jmp    80446c <vprintfmt+0x4ef>
            putch('0', put_arg);
  804510:	4c 89 ee             	mov    %r13,%rsi
  804513:	bf 30 00 00 00       	mov    $0x30,%edi
  804518:	41 ff d6             	call   *%r14
            putch('x', put_arg);
  80451b:	4c 89 ee             	mov    %r13,%rsi
  80451e:	bf 78 00 00 00       	mov    $0x78,%edi
  804523:	41 ff d6             	call   *%r14
            num = (uintptr_t)va_arg(aq, void *);
  804526:	8b 45 b8             	mov    -0x48(%rbp),%eax
  804529:	83 f8 2f             	cmp    $0x2f,%eax
  80452c:	77 47                	ja     804575 <vprintfmt+0x5f8>
  80452e:	89 c2                	mov    %eax,%edx
  804530:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  804534:	83 c0 08             	add    $0x8,%eax
  804537:	89 45 b8             	mov    %eax,-0x48(%rbp)
  80453a:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  80453d:	b9 10 00 00 00       	mov    $0x10,%ecx
            print_num(putch, put_arg, num, base, width, padc, ch == 'X');
  804542:	48 83 ec 08          	sub    $0x8,%rsp
  804546:	80 7d a0 58          	cmpb   $0x58,-0x60(%rbp)
  80454a:	0f 94 c0             	sete   %al
  80454d:	0f b6 c0             	movzbl %al,%eax
  804550:	50                   	push   %rax
  804551:	44 0f be 4d aa       	movsbl -0x56(%rbp),%r9d
  804556:	44 8b 45 ac          	mov    -0x54(%rbp),%r8d
  80455a:	4c 89 ee             	mov    %r13,%rsi
  80455d:	4c 89 f7             	mov    %r14,%rdi
  804560:	48 b8 66 3e 80 00 00 	movabs $0x803e66,%rax
  804567:	00 00 00 
  80456a:	ff d0                	call   *%rax
            break;
  80456c:	48 83 c4 10          	add    $0x10,%rsp
  804570:	e9 3d fa ff ff       	jmp    803fb2 <vprintfmt+0x35>
            num = (uintptr_t)va_arg(aq, void *);
  804575:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  804579:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80457d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  804581:	eb b7                	jmp    80453a <vprintfmt+0x5bd>
    if (zflag) return va_arg(*ap, size_t);
  804583:	40 84 f6             	test   %sil,%sil
  804586:	75 2b                	jne    8045b3 <vprintfmt+0x636>
    switch (lflag) {
  804588:	85 d2                	test   %edx,%edx
  80458a:	74 56                	je     8045e2 <vprintfmt+0x665>
  80458c:	83 fa 01             	cmp    $0x1,%edx
  80458f:	74 7f                	je     804610 <vprintfmt+0x693>
        return va_arg(*ap, unsigned long long);
  804591:	8b 45 b8             	mov    -0x48(%rbp),%eax
  804594:	83 f8 2f             	cmp    $0x2f,%eax
  804597:	0f 87 a2 00 00 00    	ja     80463f <vprintfmt+0x6c2>
  80459d:	89 c2                	mov    %eax,%edx
  80459f:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8045a3:	83 c0 08             	add    $0x8,%eax
  8045a6:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8045a9:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  8045ac:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long long);
  8045b1:	eb 8f                	jmp    804542 <vprintfmt+0x5c5>
    if (zflag) return va_arg(*ap, size_t);
  8045b3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8045b6:	83 f8 2f             	cmp    $0x2f,%eax
  8045b9:	77 19                	ja     8045d4 <vprintfmt+0x657>
  8045bb:	89 c2                	mov    %eax,%edx
  8045bd:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8045c1:	83 c0 08             	add    $0x8,%eax
  8045c4:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8045c7:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  8045ca:	b9 10 00 00 00       	mov    $0x10,%ecx
    if (zflag) return va_arg(*ap, size_t);
  8045cf:	e9 6e ff ff ff       	jmp    804542 <vprintfmt+0x5c5>
  8045d4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8045d8:	48 8d 42 08          	lea    0x8(%rdx),%rax
  8045dc:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8045e0:	eb e5                	jmp    8045c7 <vprintfmt+0x64a>
        return va_arg(*ap, unsigned int);
  8045e2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8045e5:	83 f8 2f             	cmp    $0x2f,%eax
  8045e8:	77 18                	ja     804602 <vprintfmt+0x685>
  8045ea:	89 c2                	mov    %eax,%edx
  8045ec:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  8045f0:	83 c0 08             	add    $0x8,%eax
  8045f3:	89 45 b8             	mov    %eax,-0x48(%rbp)
  8045f6:	8b 12                	mov    (%rdx),%edx
            base = 16;
  8045f8:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned int);
  8045fd:	e9 40 ff ff ff       	jmp    804542 <vprintfmt+0x5c5>
  804602:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  804606:	48 8d 42 08          	lea    0x8(%rdx),%rax
  80460a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80460e:	eb e6                	jmp    8045f6 <vprintfmt+0x679>
        return va_arg(*ap, unsigned long);
  804610:	8b 45 b8             	mov    -0x48(%rbp),%eax
  804613:	83 f8 2f             	cmp    $0x2f,%eax
  804616:	77 19                	ja     804631 <vprintfmt+0x6b4>
  804618:	89 c2                	mov    %eax,%edx
  80461a:	48 03 55 c8          	add    -0x38(%rbp),%rdx
  80461e:	83 c0 08             	add    $0x8,%eax
  804621:	89 45 b8             	mov    %eax,-0x48(%rbp)
  804624:	48 8b 12             	mov    (%rdx),%rdx
            base = 16;
  804627:	b9 10 00 00 00       	mov    $0x10,%ecx
        return va_arg(*ap, unsigned long);
  80462c:	e9 11 ff ff ff       	jmp    804542 <vprintfmt+0x5c5>
  804631:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  804635:	48 8d 42 08          	lea    0x8(%rdx),%rax
  804639:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80463d:	eb e5                	jmp    804624 <vprintfmt+0x6a7>
        return va_arg(*ap, unsigned long long);
  80463f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  804643:	48 8d 42 08          	lea    0x8(%rdx),%rax
  804647:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  80464b:	e9 59 ff ff ff       	jmp    8045a9 <vprintfmt+0x62c>
            putch(ch, put_arg);
  804650:	4c 89 ee             	mov    %r13,%rsi
  804653:	bf 25 00 00 00       	mov    $0x25,%edi
  804658:	41 ff d6             	call   *%r14
            break;
  80465b:	e9 52 f9 ff ff       	jmp    803fb2 <vprintfmt+0x35>
            putch('%', put_arg);
  804660:	4c 89 ee             	mov    %r13,%rsi
  804663:	bf 25 00 00 00       	mov    $0x25,%edi
  804668:	41 ff d6             	call   *%r14
            while ((--ufmt)[-1] != '%') /* nothing */
  80466b:	48 83 eb 01          	sub    $0x1,%rbx
  80466f:	80 7b ff 25          	cmpb   $0x25,-0x1(%rbx)
  804673:	75 f6                	jne    80466b <vprintfmt+0x6ee>
  804675:	e9 38 f9 ff ff       	jmp    803fb2 <vprintfmt+0x35>
}
  80467a:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
  80467e:	5b                   	pop    %rbx
  80467f:	41 5c                	pop    %r12
  804681:	41 5d                	pop    %r13
  804683:	41 5e                	pop    %r14
  804685:	41 5f                	pop    %r15
  804687:	5d                   	pop    %rbp
  804688:	c3                   	ret

0000000000804689 <vsnprintf>:

int
vsnprintf(char *buf, size_t n, const char *fmt, va_list ap) {
  804689:	f3 0f 1e fa          	endbr64
  80468d:	55                   	push   %rbp
  80468e:	48 89 e5             	mov    %rsp,%rbp
  804691:	48 83 ec 20          	sub    $0x20,%rsp
    struct sprintbuf state = {buf, buf + n - 1, 0};
  804695:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804699:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  80469e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  8046a2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)

    if (!buf || n < 1) return -E_INVAL;
  8046a9:	48 85 ff             	test   %rdi,%rdi
  8046ac:	74 2b                	je     8046d9 <vsnprintf+0x50>
  8046ae:	48 85 f6             	test   %rsi,%rsi
  8046b1:	74 26                	je     8046d9 <vsnprintf+0x50>

    /* Print the string to the buffer */
    vprintfmt((void *)sprintputch, &state, fmt, ap);
  8046b3:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  8046b7:	48 bf 20 3f 80 00 00 	movabs $0x803f20,%rdi
  8046be:	00 00 00 
  8046c1:	48 b8 7d 3f 80 00 00 	movabs $0x803f7d,%rax
  8046c8:	00 00 00 
  8046cb:	ff d0                	call   *%rax

    /* Null terminate the buffer */
    *state.start = '\0';
  8046cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8046d1:	c6 00 00             	movb   $0x0,(%rax)

    return state.count;
  8046d4:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8046d7:	c9                   	leave
  8046d8:	c3                   	ret
    if (!buf || n < 1) return -E_INVAL;
  8046d9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8046de:	eb f7                	jmp    8046d7 <vsnprintf+0x4e>

00000000008046e0 <snprintf>:

int
snprintf(char *buf, size_t n, const char *fmt, ...) {
  8046e0:	f3 0f 1e fa          	endbr64
  8046e4:	55                   	push   %rbp
  8046e5:	48 89 e5             	mov    %rsp,%rbp
  8046e8:	48 83 ec 50          	sub    $0x50,%rsp
  8046ec:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8046f0:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  8046f4:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list ap;

    va_start(ap, fmt);
  8046f8:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  8046ff:	48 8d 45 10          	lea    0x10(%rbp),%rax
  804703:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  804707:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80470b:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int rc = vsnprintf(buf, n, fmt, ap);
  80470f:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  804713:	48 b8 89 46 80 00 00 	movabs $0x804689,%rax
  80471a:	00 00 00 
  80471d:	ff d0                	call   *%rax
    va_end(ap);

    return rc;
}
  80471f:	c9                   	leave
  804720:	c3                   	ret

0000000000804721 <strlen>:
 * Primespipe runs 3x faster this way */

#define ASM 1

size_t
strlen(const char *s) {
  804721:	f3 0f 1e fa          	endbr64
    size_t n = 0;
    while (*s++) n++;
  804725:	80 3f 00             	cmpb   $0x0,(%rdi)
  804728:	74 10                	je     80473a <strlen+0x19>
    size_t n = 0;
  80472a:	b8 00 00 00 00       	mov    $0x0,%eax
    while (*s++) n++;
  80472f:	48 83 c0 01          	add    $0x1,%rax
  804733:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  804737:	75 f6                	jne    80472f <strlen+0xe>
  804739:	c3                   	ret
    size_t n = 0;
  80473a:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
}
  80473f:	c3                   	ret

0000000000804740 <strnlen>:

size_t
strnlen(const char *s, size_t size) {
  804740:	f3 0f 1e fa          	endbr64
  804744:	48 89 f0             	mov    %rsi,%rax
    size_t n = 0;
  804747:	ba 00 00 00 00       	mov    $0x0,%edx
    while (n < size && *s++) n++;
  80474c:	48 85 f6             	test   %rsi,%rsi
  80474f:	74 10                	je     804761 <strnlen+0x21>
  804751:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  804755:	74 0b                	je     804762 <strnlen+0x22>
  804757:	48 83 c2 01          	add    $0x1,%rdx
  80475b:	48 39 d0             	cmp    %rdx,%rax
  80475e:	75 f1                	jne    804751 <strnlen+0x11>
  804760:	c3                   	ret
  804761:	c3                   	ret
  804762:	48 89 d0             	mov    %rdx,%rax
    return n;
}
  804765:	c3                   	ret

0000000000804766 <strcpy>:

char *
strcpy(char *dst, const char *src) {
  804766:	f3 0f 1e fa          	endbr64
  80476a:	48 89 f8             	mov    %rdi,%rax
    char *res = dst;
    while ((*dst++ = *src++)) /* nothing */
  80476d:	ba 00 00 00 00       	mov    $0x0,%edx
  804772:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  804776:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  804779:	48 83 c2 01          	add    $0x1,%rdx
  80477d:	84 c9                	test   %cl,%cl
  80477f:	75 f1                	jne    804772 <strcpy+0xc>
        ;
    return res;
}
  804781:	c3                   	ret

0000000000804782 <strcat>:

char *
strcat(char *dst, const char *src) {
  804782:	f3 0f 1e fa          	endbr64
  804786:	55                   	push   %rbp
  804787:	48 89 e5             	mov    %rsp,%rbp
  80478a:	41 54                	push   %r12
  80478c:	53                   	push   %rbx
  80478d:	48 89 fb             	mov    %rdi,%rbx
  804790:	49 89 f4             	mov    %rsi,%r12
    size_t len = strlen(dst);
  804793:	48 b8 21 47 80 00 00 	movabs $0x804721,%rax
  80479a:	00 00 00 
  80479d:	ff d0                	call   *%rax
    strcpy(dst + len, src);
  80479f:	48 8d 3c 03          	lea    (%rbx,%rax,1),%rdi
  8047a3:	4c 89 e6             	mov    %r12,%rsi
  8047a6:	48 b8 66 47 80 00 00 	movabs $0x804766,%rax
  8047ad:	00 00 00 
  8047b0:	ff d0                	call   *%rax
    return dst;
}
  8047b2:	48 89 d8             	mov    %rbx,%rax
  8047b5:	5b                   	pop    %rbx
  8047b6:	41 5c                	pop    %r12
  8047b8:	5d                   	pop    %rbp
  8047b9:	c3                   	ret

00000000008047ba <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8047ba:	f3 0f 1e fa          	endbr64
  8047be:	48 89 f8             	mov    %rdi,%rax
    char *ret = dst;
    while (size-- > 0) {
  8047c1:	48 85 d2             	test   %rdx,%rdx
  8047c4:	74 1f                	je     8047e5 <strncpy+0x2b>
  8047c6:	48 01 fa             	add    %rdi,%rdx
  8047c9:	48 89 f9             	mov    %rdi,%rcx
        *dst++ = *src;
  8047cc:	48 83 c1 01          	add    $0x1,%rcx
  8047d0:	44 0f b6 06          	movzbl (%rsi),%r8d
  8047d4:	44 88 41 ff          	mov    %r8b,-0x1(%rcx)
        /* If strlen(src) < size, null-pad
         * 'dst' out to 'size' chars */
        if (*src) src++;
  8047d8:	41 80 f8 01          	cmp    $0x1,%r8b
  8047dc:	48 83 de ff          	sbb    $0xffffffffffffffff,%rsi
    while (size-- > 0) {
  8047e0:	48 39 ca             	cmp    %rcx,%rdx
  8047e3:	75 e7                	jne    8047cc <strncpy+0x12>
    }
    return ret;
}
  8047e5:	c3                   	ret

00000000008047e6 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size) {
  8047e6:	f3 0f 1e fa          	endbr64
    char *dst_in = dst;
    if (size) {
  8047ea:	48 89 f8             	mov    %rdi,%rax
  8047ed:	48 85 d2             	test   %rdx,%rdx
  8047f0:	74 24                	je     804816 <strlcpy+0x30>
        while (--size > 0 && *src)
  8047f2:	48 83 ea 01          	sub    $0x1,%rdx
  8047f6:	74 1b                	je     804813 <strlcpy+0x2d>
  8047f8:	48 8d 0c 17          	lea    (%rdi,%rdx,1),%rcx
  8047fc:	0f b6 16             	movzbl (%rsi),%edx
  8047ff:	84 d2                	test   %dl,%dl
  804801:	74 10                	je     804813 <strlcpy+0x2d>
            *dst++ = *src++;
  804803:	48 83 c6 01          	add    $0x1,%rsi
  804807:	48 83 c0 01          	add    $0x1,%rax
  80480b:	88 50 ff             	mov    %dl,-0x1(%rax)
        while (--size > 0 && *src)
  80480e:	48 39 c8             	cmp    %rcx,%rax
  804811:	75 e9                	jne    8047fc <strlcpy+0x16>
        *dst = '\0';
  804813:	c6 00 00             	movb   $0x0,(%rax)
    }
    return dst - dst_in;
  804816:	48 29 f8             	sub    %rdi,%rax
}
  804819:	c3                   	ret

000000000080481a <strcmp>:
    }
    return dstlen + srclen;
}

int
strcmp(const char *p, const char *q) {
  80481a:	f3 0f 1e fa          	endbr64
    while (*p && *p == *q) p++, q++;
  80481e:	0f b6 07             	movzbl (%rdi),%eax
  804821:	84 c0                	test   %al,%al
  804823:	74 13                	je     804838 <strcmp+0x1e>
  804825:	38 06                	cmp    %al,(%rsi)
  804827:	75 0f                	jne    804838 <strcmp+0x1e>
  804829:	48 83 c7 01          	add    $0x1,%rdi
  80482d:	48 83 c6 01          	add    $0x1,%rsi
  804831:	0f b6 07             	movzbl (%rdi),%eax
  804834:	84 c0                	test   %al,%al
  804836:	75 ed                	jne    804825 <strcmp+0xb>
    return (int)((unsigned char)*p - (unsigned char)*q);
  804838:	0f b6 c0             	movzbl %al,%eax
  80483b:	0f b6 16             	movzbl (%rsi),%edx
  80483e:	29 d0                	sub    %edx,%eax
}
  804840:	c3                   	ret

0000000000804841 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n) {
  804841:	f3 0f 1e fa          	endbr64
    while (n && *p && *p == *q) n--, p++, q++;
  804845:	48 85 d2             	test   %rdx,%rdx
  804848:	74 1f                	je     804869 <strncmp+0x28>
  80484a:	0f b6 07             	movzbl (%rdi),%eax
  80484d:	84 c0                	test   %al,%al
  80484f:	74 1e                	je     80486f <strncmp+0x2e>
  804851:	3a 06                	cmp    (%rsi),%al
  804853:	75 1a                	jne    80486f <strncmp+0x2e>
  804855:	48 83 c7 01          	add    $0x1,%rdi
  804859:	48 83 c6 01          	add    $0x1,%rsi
  80485d:	48 83 ea 01          	sub    $0x1,%rdx
  804861:	75 e7                	jne    80484a <strncmp+0x9>

    if (!n) return 0;
  804863:	b8 00 00 00 00       	mov    $0x0,%eax
  804868:	c3                   	ret
  804869:	b8 00 00 00 00       	mov    $0x0,%eax
  80486e:	c3                   	ret

    return (int)((unsigned char)*p - (unsigned char)*q);
  80486f:	0f b6 07             	movzbl (%rdi),%eax
  804872:	0f b6 16             	movzbl (%rsi),%edx
  804875:	29 d0                	sub    %edx,%eax
}
  804877:	c3                   	ret

0000000000804878 <strchr>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a null pointer if the string has no 'c' */
char *
strchr(const char *str, int c) {
  804878:	f3 0f 1e fa          	endbr64
    for (; *str; str++) {
  80487c:	0f b6 17             	movzbl (%rdi),%edx
  80487f:	84 d2                	test   %dl,%dl
  804881:	74 18                	je     80489b <strchr+0x23>
        if (*str == c) {
  804883:	0f be d2             	movsbl %dl,%edx
  804886:	39 f2                	cmp    %esi,%edx
  804888:	74 17                	je     8048a1 <strchr+0x29>
    for (; *str; str++) {
  80488a:	48 83 c7 01          	add    $0x1,%rdi
  80488e:	0f b6 17             	movzbl (%rdi),%edx
  804891:	84 d2                	test   %dl,%dl
  804893:	75 ee                	jne    804883 <strchr+0xb>
            return (char *)str;
        }
    }
    return NULL;
  804895:	b8 00 00 00 00       	mov    $0x0,%eax
  80489a:	c3                   	ret
  80489b:	b8 00 00 00 00       	mov    $0x0,%eax
  8048a0:	c3                   	ret
            return (char *)str;
  8048a1:	48 89 f8             	mov    %rdi,%rax
}
  8048a4:	c3                   	ret

00000000008048a5 <strfind>:

/* Return a pointer to the first occurrence of 'c' in 's',
 *  * or a pointer to the string-ending null character if the string has no 'c' */
char *
strfind(const char *str, int ch) {
  8048a5:	f3 0f 1e fa          	endbr64
  8048a9:	48 89 f8             	mov    %rdi,%rax
    for (; *str && *str != ch; str++) /* nothing */
  8048ac:	0f b6 17             	movzbl (%rdi),%edx
  8048af:	84 d2                	test   %dl,%dl
  8048b1:	74 13                	je     8048c6 <strfind+0x21>
  8048b3:	0f be d2             	movsbl %dl,%edx
  8048b6:	39 f2                	cmp    %esi,%edx
  8048b8:	74 0b                	je     8048c5 <strfind+0x20>
  8048ba:	48 83 c0 01          	add    $0x1,%rax
  8048be:	0f b6 10             	movzbl (%rax),%edx
  8048c1:	84 d2                	test   %dl,%dl
  8048c3:	75 ee                	jne    8048b3 <strfind+0xe>
        ;
    return (char *)str;
}
  8048c5:	c3                   	ret
  8048c6:	c3                   	ret

00000000008048c7 <memset>:


#if ASM
void *
memset(void *v, int c, size_t n) {
  8048c7:	f3 0f 1e fa          	endbr64
  8048cb:	49 89 f8             	mov    %rdi,%r8
    uint8_t *ptr = v;
    ssize_t ni = n;

    if (__builtin_expect((ni -= ((8 - ((uintptr_t)v & 7))) & 7) < 0, 0)) {
  8048ce:	48 89 f8             	mov    %rdi,%rax
  8048d1:	48 f7 d8             	neg    %rax
  8048d4:	83 e0 07             	and    $0x7,%eax
  8048d7:	49 89 d1             	mov    %rdx,%r9
  8048da:	49 29 c1             	sub    %rax,%r9
  8048dd:	78 36                	js     804915 <memset+0x4e>
        while (n-- > 0) *ptr++ = c;
        return v;
    }

    uint64_t k = 0x101010101010101ULL * (c & 0xFFU);
  8048df:	40 0f b6 c6          	movzbl %sil,%eax
  8048e3:	48 b9 01 01 01 01 01 	movabs $0x101010101010101,%rcx
  8048ea:	01 01 01 
  8048ed:	48 0f af c1          	imul   %rcx,%rax

    if (__builtin_expect((uintptr_t)ptr & 7, 0)) {
  8048f1:	40 f6 c7 07          	test   $0x7,%dil
  8048f5:	75 38                	jne    80492f <memset+0x68>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
    }

    if (__builtin_expect(ni >> 3, 1)) {
  8048f7:	4c 89 c9             	mov    %r9,%rcx
  8048fa:	48 c1 f9 03          	sar    $0x3,%rcx
  8048fe:	74 0c                	je     80490c <memset+0x45>
        asm volatile("cld; rep stosq\n" ::"D"(ptr), "a"(k), "c"(ni >> 3)
  804900:	fc                   	cld
  804901:	f3 48 ab             	rep stos %rax,%es:(%rdi)
                     : "cc", "memory");
        ni &= 7;
  804904:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  804908:	41 83 e1 07          	and    $0x7,%r9d
    }

    if (__builtin_expect(ni, 0)) {
  80490c:	4d 85 c9             	test   %r9,%r9
  80490f:	75 45                	jne    804956 <memset+0x8f>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
        if (ni & 1) *ptr = k;
    }

    return v;
}
  804911:	4c 89 c0             	mov    %r8,%rax
  804914:	c3                   	ret
        while (n-- > 0) *ptr++ = c;
  804915:	48 85 d2             	test   %rdx,%rdx
  804918:	74 f7                	je     804911 <memset+0x4a>
  80491a:	48 01 fa             	add    %rdi,%rdx
    uint8_t *ptr = v;
  80491d:	48 89 f8             	mov    %rdi,%rax
        while (n-- > 0) *ptr++ = c;
  804920:	48 83 c0 01          	add    $0x1,%rax
  804924:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  804928:	48 39 c2             	cmp    %rax,%rdx
  80492b:	75 f3                	jne    804920 <memset+0x59>
  80492d:	eb e2                	jmp    804911 <memset+0x4a>
        if ((uintptr_t)ptr & 1) *ptr = k, ptr += 1;
  80492f:	40 f6 c7 01          	test   $0x1,%dil
  804933:	74 06                	je     80493b <memset+0x74>
  804935:	88 07                	mov    %al,(%rdi)
  804937:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
        if ((uintptr_t)ptr & 2) *(uint16_t *)ptr = k, ptr += 2;
  80493b:	40 f6 c7 02          	test   $0x2,%dil
  80493f:	74 07                	je     804948 <memset+0x81>
  804941:	66 89 07             	mov    %ax,(%rdi)
  804944:	48 83 c7 02          	add    $0x2,%rdi
        if ((uintptr_t)ptr & 4) *(uint32_t *)ptr = k, ptr += 4;
  804948:	40 f6 c7 04          	test   $0x4,%dil
  80494c:	74 a9                	je     8048f7 <memset+0x30>
  80494e:	89 07                	mov    %eax,(%rdi)
  804950:	48 83 c7 04          	add    $0x4,%rdi
  804954:	eb a1                	jmp    8048f7 <memset+0x30>
        if (ni & 4) *(uint32_t *)ptr = k, ptr += 4;
  804956:	41 f6 c1 04          	test   $0x4,%r9b
  80495a:	74 1b                	je     804977 <memset+0xb0>
  80495c:	89 07                	mov    %eax,(%rdi)
  80495e:	48 83 c7 04          	add    $0x4,%rdi
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  804962:	41 f6 c1 02          	test   $0x2,%r9b
  804966:	74 07                	je     80496f <memset+0xa8>
  804968:	66 89 07             	mov    %ax,(%rdi)
  80496b:	48 83 c7 02          	add    $0x2,%rdi
        if (ni & 1) *ptr = k;
  80496f:	41 f6 c1 01          	test   $0x1,%r9b
  804973:	74 9c                	je     804911 <memset+0x4a>
  804975:	eb 06                	jmp    80497d <memset+0xb6>
        if (ni & 2) *(uint16_t *)ptr = k, ptr += 2;
  804977:	41 f6 c1 02          	test   $0x2,%r9b
  80497b:	75 eb                	jne    804968 <memset+0xa1>
        if (ni & 1) *ptr = k;
  80497d:	88 07                	mov    %al,(%rdi)
  80497f:	eb 90                	jmp    804911 <memset+0x4a>

0000000000804981 <memmove>:

void *
memmove(void *dst, const void *src, size_t n) {
  804981:	f3 0f 1e fa          	endbr64
  804985:	48 89 f8             	mov    %rdi,%rax
  804988:	48 89 d1             	mov    %rdx,%rcx
    const char *s = src;
    char *d = dst;

    if (s < d && s + n > d) {
  80498b:	48 39 fe             	cmp    %rdi,%rsi
  80498e:	73 3b                	jae    8049cb <memmove+0x4a>
  804990:	48 8d 14 16          	lea    (%rsi,%rdx,1),%rdx
  804994:	48 39 d7             	cmp    %rdx,%rdi
  804997:	73 32                	jae    8049cb <memmove+0x4a>
        s += n;
        d += n;
  804999:	48 8d 3c 0f          	lea    (%rdi,%rcx,1),%rdi
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  80499d:	48 89 d6             	mov    %rdx,%rsi
  8049a0:	48 09 fe             	or     %rdi,%rsi
  8049a3:	48 09 ce             	or     %rcx,%rsi
  8049a6:	40 f6 c6 07          	test   $0x7,%sil
  8049aa:	75 12                	jne    8049be <memmove+0x3d>
            asm volatile("std; rep movsq\n" ::"D"(d - 8), "S"(s - 8), "c"(n / 8)
  8049ac:	48 83 ef 08          	sub    $0x8,%rdi
  8049b0:	48 8d 72 f8          	lea    -0x8(%rdx),%rsi
  8049b4:	48 c1 e9 03          	shr    $0x3,%rcx
  8049b8:	fd                   	std
  8049b9:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        } else {
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
                         : "cc", "memory");
        }
        /* Some versions of GCC rely on DF being clear */
        asm volatile("cld" ::
  8049bc:	fc                   	cld
  8049bd:	c3                   	ret
            asm volatile("std; rep movsb\n" ::"D"(d - 1), "S"(s - 1), "c"(n)
  8049be:	48 83 ef 01          	sub    $0x1,%rdi
  8049c2:	48 8d 72 ff          	lea    -0x1(%rdx),%rsi
  8049c6:	fd                   	std
  8049c7:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  8049c9:	eb f1                	jmp    8049bc <memmove+0x3b>
                             : "cc");
    } else {
        if (!(((intptr_t)s & 7) | ((intptr_t)d & 7) | (n & 7))) {
  8049cb:	48 89 f2             	mov    %rsi,%rdx
  8049ce:	48 09 c2             	or     %rax,%rdx
  8049d1:	48 09 ca             	or     %rcx,%rdx
  8049d4:	f6 c2 07             	test   $0x7,%dl
  8049d7:	75 0c                	jne    8049e5 <memmove+0x64>
            asm volatile("cld; rep movsq\n" ::"D"(d), "S"(s), "c"(n / 8)
  8049d9:	48 c1 e9 03          	shr    $0x3,%rcx
  8049dd:	48 89 c7             	mov    %rax,%rdi
  8049e0:	fc                   	cld
  8049e1:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  8049e4:	c3                   	ret
                         : "cc", "memory");
        } else {
            asm volatile("cld; rep movsb\n" ::"D"(d), "S"(s), "c"(n)
  8049e5:	48 89 c7             	mov    %rax,%rdi
  8049e8:	fc                   	cld
  8049e9:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
                         : "cc", "memory");
        }
    }
    return dst;
}
  8049eb:	c3                   	ret

00000000008049ec <memcpy>:
    return dst;
}
#endif

void *
memcpy(void *dst, const void *src, size_t n) {
  8049ec:	f3 0f 1e fa          	endbr64
  8049f0:	55                   	push   %rbp
  8049f1:	48 89 e5             	mov    %rsp,%rbp
    return memmove(dst, src, n);
  8049f4:	48 b8 81 49 80 00 00 	movabs $0x804981,%rax
  8049fb:	00 00 00 
  8049fe:	ff d0                	call   *%rax
}
  804a00:	5d                   	pop    %rbp
  804a01:	c3                   	ret

0000000000804a02 <strlcat>:
strlcat(char *restrict dst, const char *restrict src, size_t maxlen) {
  804a02:	f3 0f 1e fa          	endbr64
  804a06:	55                   	push   %rbp
  804a07:	48 89 e5             	mov    %rsp,%rbp
  804a0a:	41 57                	push   %r15
  804a0c:	41 56                	push   %r14
  804a0e:	41 55                	push   %r13
  804a10:	41 54                	push   %r12
  804a12:	53                   	push   %rbx
  804a13:	48 83 ec 08          	sub    $0x8,%rsp
  804a17:	49 89 fe             	mov    %rdi,%r14
  804a1a:	49 89 f7             	mov    %rsi,%r15
  804a1d:	48 89 d3             	mov    %rdx,%rbx
    const size_t srclen = strlen(src);
  804a20:	48 89 f7             	mov    %rsi,%rdi
  804a23:	48 b8 21 47 80 00 00 	movabs $0x804721,%rax
  804a2a:	00 00 00 
  804a2d:	ff d0                	call   *%rax
  804a2f:	49 89 c4             	mov    %rax,%r12
    const size_t dstlen = strnlen(dst, maxlen);
  804a32:	48 89 de             	mov    %rbx,%rsi
  804a35:	4c 89 f7             	mov    %r14,%rdi
  804a38:	48 b8 40 47 80 00 00 	movabs $0x804740,%rax
  804a3f:	00 00 00 
  804a42:	ff d0                	call   *%rax
  804a44:	49 89 c5             	mov    %rax,%r13
    if (dstlen == maxlen) return maxlen + srclen;
  804a47:	48 39 c3             	cmp    %rax,%rbx
  804a4a:	74 36                	je     804a82 <strlcat+0x80>
    if (srclen < maxlen - dstlen) {
  804a4c:	48 89 d8             	mov    %rbx,%rax
  804a4f:	4c 29 e8             	sub    %r13,%rax
  804a52:	49 39 c4             	cmp    %rax,%r12
  804a55:	73 31                	jae    804a88 <strlcat+0x86>
        memcpy(dst + dstlen, src, srclen + 1);
  804a57:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  804a5c:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  804a60:	4c 89 fe             	mov    %r15,%rsi
  804a63:	48 b8 ec 49 80 00 00 	movabs $0x8049ec,%rax
  804a6a:	00 00 00 
  804a6d:	ff d0                	call   *%rax
    return dstlen + srclen;
  804a6f:	4b 8d 04 2c          	lea    (%r12,%r13,1),%rax
}
  804a73:	48 83 c4 08          	add    $0x8,%rsp
  804a77:	5b                   	pop    %rbx
  804a78:	41 5c                	pop    %r12
  804a7a:	41 5d                	pop    %r13
  804a7c:	41 5e                	pop    %r14
  804a7e:	41 5f                	pop    %r15
  804a80:	5d                   	pop    %rbp
  804a81:	c3                   	ret
    if (dstlen == maxlen) return maxlen + srclen;
  804a82:	49 8d 04 04          	lea    (%r12,%rax,1),%rax
  804a86:	eb eb                	jmp    804a73 <strlcat+0x71>
        memcpy(dst + dstlen, src, maxlen - 1);
  804a88:	48 83 eb 01          	sub    $0x1,%rbx
  804a8c:	4b 8d 3c 2e          	lea    (%r14,%r13,1),%rdi
  804a90:	48 89 da             	mov    %rbx,%rdx
  804a93:	4c 89 fe             	mov    %r15,%rsi
  804a96:	48 b8 ec 49 80 00 00 	movabs $0x8049ec,%rax
  804a9d:	00 00 00 
  804aa0:	ff d0                	call   *%rax
        dst[dstlen + maxlen - 1] = '\0';
  804aa2:	49 01 de             	add    %rbx,%r14
  804aa5:	43 c6 04 2e 00       	movb   $0x0,(%r14,%r13,1)
  804aaa:	eb c3                	jmp    804a6f <strlcat+0x6d>

0000000000804aac <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n) {
  804aac:	f3 0f 1e fa          	endbr64
    const uint8_t *s1 = (const uint8_t *)v1;
    const uint8_t *s2 = (const uint8_t *)v2;

    while (n-- > 0) {
  804ab0:	48 85 d2             	test   %rdx,%rdx
  804ab3:	74 2d                	je     804ae2 <memcmp+0x36>
  804ab5:	b8 00 00 00 00       	mov    $0x0,%eax
        if (*s1 != *s2) {
  804aba:	0f b6 0c 07          	movzbl (%rdi,%rax,1),%ecx
  804abe:	44 0f b6 04 06       	movzbl (%rsi,%rax,1),%r8d
  804ac3:	44 38 c1             	cmp    %r8b,%cl
  804ac6:	75 0f                	jne    804ad7 <memcmp+0x2b>
    while (n-- > 0) {
  804ac8:	48 83 c0 01          	add    $0x1,%rax
  804acc:	48 39 c2             	cmp    %rax,%rdx
  804acf:	75 e9                	jne    804aba <memcmp+0xe>
            return (int)*s1 - (int)*s2;
        }
        s1++, s2++;
    }

    return 0;
  804ad1:	b8 00 00 00 00       	mov    $0x0,%eax
  804ad6:	c3                   	ret
            return (int)*s1 - (int)*s2;
  804ad7:	0f b6 c1             	movzbl %cl,%eax
  804ada:	45 0f b6 c0          	movzbl %r8b,%r8d
  804ade:	44 29 c0             	sub    %r8d,%eax
  804ae1:	c3                   	ret
    return 0;
  804ae2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804ae7:	c3                   	ret

0000000000804ae8 <memfind>:

void *
memfind(const void *src, int c, size_t n) {
  804ae8:	f3 0f 1e fa          	endbr64
    const void *end = (const char *)src + n;
  804aec:	48 8d 04 17          	lea    (%rdi,%rdx,1),%rax
    for (; src < end; src++) {
  804af0:	48 39 c7             	cmp    %rax,%rdi
  804af3:	73 0f                	jae    804b04 <memfind+0x1c>
        if (*(const unsigned char *)src == (unsigned char)c) break;
  804af5:	40 38 37             	cmp    %sil,(%rdi)
  804af8:	74 0e                	je     804b08 <memfind+0x20>
    for (; src < end; src++) {
  804afa:	48 83 c7 01          	add    $0x1,%rdi
  804afe:	48 39 f8             	cmp    %rdi,%rax
  804b01:	75 f2                	jne    804af5 <memfind+0xd>
  804b03:	c3                   	ret
  804b04:	48 89 f8             	mov    %rdi,%rax
  804b07:	c3                   	ret
  804b08:	48 89 f8             	mov    %rdi,%rax
    }
    return (void *)src;
}
  804b0b:	c3                   	ret

0000000000804b0c <strtol>:

long
strtol(const char *s, char **endptr, int base) {
  804b0c:	f3 0f 1e fa          	endbr64
  804b10:	49 89 f2             	mov    %rsi,%r10
    /* Gobble initial whitespace */
    while (*s == ' ' || *s == '\t') s++;
  804b13:	0f b6 37             	movzbl (%rdi),%esi
  804b16:	40 80 fe 20          	cmp    $0x20,%sil
  804b1a:	74 06                	je     804b22 <strtol+0x16>
  804b1c:	40 80 fe 09          	cmp    $0x9,%sil
  804b20:	75 13                	jne    804b35 <strtol+0x29>
  804b22:	48 83 c7 01          	add    $0x1,%rdi
  804b26:	0f b6 37             	movzbl (%rdi),%esi
  804b29:	40 80 fe 20          	cmp    $0x20,%sil
  804b2d:	74 f3                	je     804b22 <strtol+0x16>
  804b2f:	40 80 fe 09          	cmp    $0x9,%sil
  804b33:	74 ed                	je     804b22 <strtol+0x16>

    bool neg = *s == '-';

    /* Plus/minus sign */
    if (*s == '+' || *s == '-') s++;
  804b35:	8d 46 d5             	lea    -0x2b(%rsi),%eax
  804b38:	83 e0 fd             	and    $0xfffffffd,%eax
  804b3b:	3c 01                	cmp    $0x1,%al
  804b3d:	48 83 d7 00          	adc    $0x0,%rdi

    /* Hex or octal base prefix */
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  804b41:	f7 c2 ef ff ff ff    	test   $0xffffffef,%edx
  804b47:	75 0f                	jne    804b58 <strtol+0x4c>
  804b49:	80 3f 30             	cmpb   $0x30,(%rdi)
  804b4c:	74 14                	je     804b62 <strtol+0x56>
        s += 2;
    } else if (!base && s[0] == '0') {
        base = 8;
        s++;
    } else if (!base) {
        base = 10;
  804b4e:	85 d2                	test   %edx,%edx
  804b50:	b8 0a 00 00 00       	mov    $0xa,%eax
  804b55:	0f 44 d0             	cmove  %eax,%edx
    }

    /* Digits */
    long val = 0;
  804b58:	b8 00 00 00 00       	mov    $0x0,%eax
            break;

        if (dig >= base) break;

        /* We don't properly detect overflow! */
        val = val * base + dig;
  804b5d:	4c 63 ca             	movslq %edx,%r9
  804b60:	eb 36                	jmp    804b98 <strtol+0x8c>
    if ((!base || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  804b62:	80 7f 01 78          	cmpb   $0x78,0x1(%rdi)
  804b66:	74 0f                	je     804b77 <strtol+0x6b>
    } else if (!base && s[0] == '0') {
  804b68:	85 d2                	test   %edx,%edx
  804b6a:	75 ec                	jne    804b58 <strtol+0x4c>
        s++;
  804b6c:	48 83 c7 01          	add    $0x1,%rdi
        base = 8;
  804b70:	ba 08 00 00 00       	mov    $0x8,%edx
        s++;
  804b75:	eb e1                	jmp    804b58 <strtol+0x4c>
        s += 2;
  804b77:	48 83 c7 02          	add    $0x2,%rdi
        base = 16;
  804b7b:	ba 10 00 00 00       	mov    $0x10,%edx
        s += 2;
  804b80:	eb d6                	jmp    804b58 <strtol+0x4c>
            dig -= '0';
  804b82:	83 e9 30             	sub    $0x30,%ecx
        if (dig >= base) break;
  804b85:	44 0f b6 c1          	movzbl %cl,%r8d
  804b89:	41 39 d0             	cmp    %edx,%r8d
  804b8c:	7d 21                	jge    804baf <strtol+0xa3>
        val = val * base + dig;
  804b8e:	49 0f af c1          	imul   %r9,%rax
  804b92:	0f b6 c9             	movzbl %cl,%ecx
  804b95:	48 01 c8             	add    %rcx,%rax
        uint8_t dig = *s++;
  804b98:	48 83 c7 01          	add    $0x1,%rdi
  804b9c:	0f b6 4f ff          	movzbl -0x1(%rdi),%ecx
        if (dig - '0' < 10)
  804ba0:	80 f9 39             	cmp    $0x39,%cl
  804ba3:	76 dd                	jbe    804b82 <strtol+0x76>
        else if (dig - 'a' < 27)
  804ba5:	80 f9 7b             	cmp    $0x7b,%cl
  804ba8:	77 05                	ja     804baf <strtol+0xa3>
            dig -= 'a' - 10;
  804baa:	83 e9 57             	sub    $0x57,%ecx
  804bad:	eb d6                	jmp    804b85 <strtol+0x79>
    }

    if (endptr) *endptr = (char *)s;
  804baf:	4d 85 d2             	test   %r10,%r10
  804bb2:	74 03                	je     804bb7 <strtol+0xab>
  804bb4:	49 89 3a             	mov    %rdi,(%r10)

    return (neg ? -val : val);
  804bb7:	48 89 c2             	mov    %rax,%rdx
  804bba:	48 f7 da             	neg    %rdx
  804bbd:	40 80 fe 2d          	cmp    $0x2d,%sil
  804bc1:	48 0f 44 c2          	cmove  %rdx,%rax
}
  804bc5:	c3                   	ret

0000000000804bc6 <sys_cputs>:

    return ret;
}

void
sys_cputs(const char *s, size_t len) {
  804bc6:	f3 0f 1e fa          	endbr64
  804bca:	55                   	push   %rbp
  804bcb:	48 89 e5             	mov    %rsp,%rbp
  804bce:	53                   	push   %rbx
  804bcf:	48 89 fa             	mov    %rdi,%rdx
  804bd2:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  804bd5:	b8 00 00 00 00       	mov    $0x0,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  804bda:	bb 00 00 00 00       	mov    $0x0,%ebx
  804bdf:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  804be4:	be 00 00 00 00       	mov    $0x0,%esi
  804be9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  804bef:	cd 30                	int    $0x30
    syscall(SYS_cputs, 0, (uintptr_t)s, len, 0, 0, 0, 0);
}
  804bf1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  804bf5:	c9                   	leave
  804bf6:	c3                   	ret

0000000000804bf7 <sys_cgetc>:

int
sys_cgetc(void) {
  804bf7:	f3 0f 1e fa          	endbr64
  804bfb:	55                   	push   %rbp
  804bfc:	48 89 e5             	mov    %rsp,%rbp
  804bff:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  804c00:	b8 01 00 00 00       	mov    $0x1,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  804c05:	ba 00 00 00 00       	mov    $0x0,%edx
  804c0a:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  804c0f:	bb 00 00 00 00       	mov    $0x0,%ebx
  804c14:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  804c19:	be 00 00 00 00       	mov    $0x0,%esi
  804c1e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  804c24:	cd 30                	int    $0x30
    return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0, 0);
}
  804c26:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  804c2a:	c9                   	leave
  804c2b:	c3                   	ret

0000000000804c2c <sys_env_destroy>:

int
sys_env_destroy(envid_t envid) {
  804c2c:	f3 0f 1e fa          	endbr64
  804c30:	55                   	push   %rbp
  804c31:	48 89 e5             	mov    %rsp,%rbp
  804c34:	53                   	push   %rbx
  804c35:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0, 0);
  804c39:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  804c3c:	b8 03 00 00 00       	mov    $0x3,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  804c41:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  804c46:	bb 00 00 00 00       	mov    $0x0,%ebx
  804c4b:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  804c50:	be 00 00 00 00       	mov    $0x0,%esi
  804c55:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  804c5b:	cd 30                	int    $0x30
    if (check && ret > 0) {
  804c5d:	48 85 c0             	test   %rax,%rax
  804c60:	7f 06                	jg     804c68 <sys_env_destroy+0x3c>
}
  804c62:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  804c66:	c9                   	leave
  804c67:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  804c68:	49 89 c0             	mov    %rax,%r8
  804c6b:	b9 03 00 00 00       	mov    $0x3,%ecx
  804c70:	48 ba b0 72 80 00 00 	movabs $0x8072b0,%rdx
  804c77:	00 00 00 
  804c7a:	be 26 00 00 00       	mov    $0x26,%esi
  804c7f:	48 bf 1a 79 80 00 00 	movabs $0x80791a,%rdi
  804c86:	00 00 00 
  804c89:	b8 00 00 00 00       	mov    $0x0,%eax
  804c8e:	49 b9 c1 3c 80 00 00 	movabs $0x803cc1,%r9
  804c95:	00 00 00 
  804c98:	41 ff d1             	call   *%r9

0000000000804c9b <sys_getenvid>:

envid_t
sys_getenvid(void) {
  804c9b:	f3 0f 1e fa          	endbr64
  804c9f:	55                   	push   %rbp
  804ca0:	48 89 e5             	mov    %rsp,%rbp
  804ca3:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  804ca4:	b8 02 00 00 00       	mov    $0x2,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  804ca9:	ba 00 00 00 00       	mov    $0x0,%edx
  804cae:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  804cb3:	bb 00 00 00 00       	mov    $0x0,%ebx
  804cb8:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  804cbd:	be 00 00 00 00       	mov    $0x0,%esi
  804cc2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  804cc8:	cd 30                	int    $0x30
    return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0, 0);
}
  804cca:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  804cce:	c9                   	leave
  804ccf:	c3                   	ret

0000000000804cd0 <sys_yield>:

void
sys_yield(void) {
  804cd0:	f3 0f 1e fa          	endbr64
  804cd4:	55                   	push   %rbp
  804cd5:	48 89 e5             	mov    %rsp,%rbp
  804cd8:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  804cd9:	b8 0d 00 00 00       	mov    $0xd,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  804cde:	ba 00 00 00 00       	mov    $0x0,%edx
  804ce3:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  804ce8:	bb 00 00 00 00       	mov    $0x0,%ebx
  804ced:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  804cf2:	be 00 00 00 00       	mov    $0x0,%esi
  804cf7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  804cfd:	cd 30                	int    $0x30
    syscall(SYS_yield, 0, 0, 0, 0, 0, 0, 0);
}
  804cff:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  804d03:	c9                   	leave
  804d04:	c3                   	ret

0000000000804d05 <sys_region_refs>:

int
sys_region_refs(void *va, size_t size) {
  804d05:	f3 0f 1e fa          	endbr64
  804d09:	55                   	push   %rbp
  804d0a:	48 89 e5             	mov    %rsp,%rbp
  804d0d:	53                   	push   %rbx
  804d0e:	48 89 fa             	mov    %rdi,%rdx
  804d11:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  804d14:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  804d19:	48 bb 00 00 00 00 80 	movabs $0x8000000000,%rbx
  804d20:	00 00 00 
  804d23:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  804d28:	be 00 00 00 00       	mov    $0x0,%esi
  804d2d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  804d33:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, MAX_USER_ADDRESS, 0, 0, 0);
}
  804d35:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  804d39:	c9                   	leave
  804d3a:	c3                   	ret

0000000000804d3b <sys_region_refs2>:

int
sys_region_refs2(void *va, size_t size, void *va2, size_t size2) {
  804d3b:	f3 0f 1e fa          	endbr64
  804d3f:	55                   	push   %rbp
  804d40:	48 89 e5             	mov    %rsp,%rbp
  804d43:	53                   	push   %rbx
  804d44:	49 89 f8             	mov    %rdi,%r8
  804d47:	48 89 d3             	mov    %rdx,%rbx
  804d4a:	48 89 cf             	mov    %rcx,%rdi
    register uintptr_t _a0 asm("rax") = num,
  804d4d:	b8 08 00 00 00       	mov    $0x8,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  804d52:	4c 89 c2             	mov    %r8,%rdx
  804d55:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  804d58:	be 00 00 00 00       	mov    $0x0,%esi
  804d5d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  804d63:	cd 30                	int    $0x30
    return syscall(SYS_region_refs, 0, (uintptr_t)va, size, (uintptr_t)va2, size2, 0, 0);
}
  804d65:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  804d69:	c9                   	leave
  804d6a:	c3                   	ret

0000000000804d6b <sys_alloc_region>:

int
sys_alloc_region(envid_t envid, void *va, size_t size, int perm) {
  804d6b:	f3 0f 1e fa          	endbr64
  804d6f:	55                   	push   %rbp
  804d70:	48 89 e5             	mov    %rsp,%rbp
  804d73:	53                   	push   %rbx
  804d74:	48 83 ec 08          	sub    $0x8,%rsp
  804d78:	89 f8                	mov    %edi,%eax
  804d7a:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_alloc_region, 1, envid, (uintptr_t)va, size, perm, 0, 0);
  804d7d:	48 63 f9             	movslq %ecx,%rdi
  804d80:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  804d83:	b8 04 00 00 00       	mov    $0x4,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  804d88:	48 89 f1             	mov    %rsi,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  804d8b:	be 00 00 00 00       	mov    $0x0,%esi
  804d90:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  804d96:	cd 30                	int    $0x30
    if (check && ret > 0) {
  804d98:	48 85 c0             	test   %rax,%rax
  804d9b:	7f 06                	jg     804da3 <sys_alloc_region+0x38>
        platform_asan_unpoison(va, size);
    }
#endif

    return res;
}
  804d9d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  804da1:	c9                   	leave
  804da2:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  804da3:	49 89 c0             	mov    %rax,%r8
  804da6:	b9 04 00 00 00       	mov    $0x4,%ecx
  804dab:	48 ba b0 72 80 00 00 	movabs $0x8072b0,%rdx
  804db2:	00 00 00 
  804db5:	be 26 00 00 00       	mov    $0x26,%esi
  804dba:	48 bf 1a 79 80 00 00 	movabs $0x80791a,%rdi
  804dc1:	00 00 00 
  804dc4:	b8 00 00 00 00       	mov    $0x0,%eax
  804dc9:	49 b9 c1 3c 80 00 00 	movabs $0x803cc1,%r9
  804dd0:	00 00 00 
  804dd3:	41 ff d1             	call   *%r9

0000000000804dd6 <sys_map_region>:

int
sys_map_region(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, size_t size, int perm) {
  804dd6:	f3 0f 1e fa          	endbr64
  804dda:	55                   	push   %rbp
  804ddb:	48 89 e5             	mov    %rsp,%rbp
  804dde:	53                   	push   %rbx
  804ddf:	48 83 ec 08          	sub    $0x8,%rsp
  804de3:	89 f8                	mov    %edi,%eax
  804de5:	49 89 f2             	mov    %rsi,%r10
  804de8:	48 89 cf             	mov    %rcx,%rdi
  804deb:	4c 89 c6             	mov    %r8,%rsi
    int res = syscall(SYS_map_region, 1, srcenv, (uintptr_t)srcva, dstenv, (uintptr_t)dstva, size, perm);
  804dee:	48 63 da             	movslq %edx,%rbx
  804df1:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  804df4:	b8 05 00 00 00       	mov    $0x5,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  804df9:	4c 89 d1             	mov    %r10,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  804dfc:	4d 63 c1             	movslq %r9d,%r8
    asm volatile("int %1\n"
  804dff:	cd 30                	int    $0x30
    if (check && ret > 0) {
  804e01:	48 85 c0             	test   %rax,%rax
  804e04:	7f 06                	jg     804e0c <sys_map_region+0x36>
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res && dstenv == CURENVID)
        platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  804e06:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  804e0a:	c9                   	leave
  804e0b:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  804e0c:	49 89 c0             	mov    %rax,%r8
  804e0f:	b9 05 00 00 00       	mov    $0x5,%ecx
  804e14:	48 ba b0 72 80 00 00 	movabs $0x8072b0,%rdx
  804e1b:	00 00 00 
  804e1e:	be 26 00 00 00       	mov    $0x26,%esi
  804e23:	48 bf 1a 79 80 00 00 	movabs $0x80791a,%rdi
  804e2a:	00 00 00 
  804e2d:	b8 00 00 00 00       	mov    $0x0,%eax
  804e32:	49 b9 c1 3c 80 00 00 	movabs $0x803cc1,%r9
  804e39:	00 00 00 
  804e3c:	41 ff d1             	call   *%r9

0000000000804e3f <sys_map_physical_region>:

int
sys_map_physical_region(uintptr_t pa, envid_t dstenv, void *dstva, size_t size, int perm) {
  804e3f:	f3 0f 1e fa          	endbr64
  804e43:	55                   	push   %rbp
  804e44:	48 89 e5             	mov    %rsp,%rbp
  804e47:	53                   	push   %rbx
  804e48:	48 83 ec 08          	sub    $0x8,%rsp
  804e4c:	49 89 f9             	mov    %rdi,%r9
  804e4f:	89 f0                	mov    %esi,%eax
  804e51:	48 89 d3             	mov    %rdx,%rbx
  804e54:	48 89 cf             	mov    %rcx,%rdi
    int res = syscall(SYS_map_physical_region, 1, pa, dstenv, (uintptr_t)dstva, size, perm, 0);
  804e57:	49 63 f0             	movslq %r8d,%rsi
  804e5a:	48 63 c8             	movslq %eax,%rcx
    register uintptr_t _a0 asm("rax") = num,
  804e5d:	b8 06 00 00 00       	mov    $0x6,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  804e62:	4c 89 ca             	mov    %r9,%rdx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  804e65:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  804e6b:	cd 30                	int    $0x30
    if (check && ret > 0) {
  804e6d:	48 85 c0             	test   %rax,%rax
  804e70:	7f 06                	jg     804e78 <sys_map_physical_region+0x39>
#ifdef SANITIZE_USER_SHADOW_BASE
    platform_asan_unpoison(dstva, size);
#endif
    return res;
}
  804e72:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  804e76:	c9                   	leave
  804e77:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  804e78:	49 89 c0             	mov    %rax,%r8
  804e7b:	b9 06 00 00 00       	mov    $0x6,%ecx
  804e80:	48 ba b0 72 80 00 00 	movabs $0x8072b0,%rdx
  804e87:	00 00 00 
  804e8a:	be 26 00 00 00       	mov    $0x26,%esi
  804e8f:	48 bf 1a 79 80 00 00 	movabs $0x80791a,%rdi
  804e96:	00 00 00 
  804e99:	b8 00 00 00 00       	mov    $0x0,%eax
  804e9e:	49 b9 c1 3c 80 00 00 	movabs $0x803cc1,%r9
  804ea5:	00 00 00 
  804ea8:	41 ff d1             	call   *%r9

0000000000804eab <sys_unmap_region>:

int
sys_unmap_region(envid_t envid, void *va, size_t size) {
  804eab:	f3 0f 1e fa          	endbr64
  804eaf:	55                   	push   %rbp
  804eb0:	48 89 e5             	mov    %rsp,%rbp
  804eb3:	53                   	push   %rbx
  804eb4:	48 83 ec 08          	sub    $0x8,%rsp
  804eb8:	48 89 f1             	mov    %rsi,%rcx
  804ebb:	48 89 d3             	mov    %rdx,%rbx
    int res = syscall(SYS_unmap_region, 1, envid, (uintptr_t)va, size, 0, 0, 0);
  804ebe:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  804ec1:	b8 07 00 00 00       	mov    $0x7,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  804ec6:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  804ecb:	be 00 00 00 00       	mov    $0x0,%esi
  804ed0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  804ed6:	cd 30                	int    $0x30
    if (check && ret > 0) {
  804ed8:	48 85 c0             	test   %rax,%rax
  804edb:	7f 06                	jg     804ee3 <sys_unmap_region+0x38>
                 (uintptr_t)va >= SANITIZE_USER_SHADOW_SIZE + SANITIZE_USER_SHADOW_BASE)) {
        platform_asan_poison(va, size);
    }
#endif
    return res;
}
  804edd:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  804ee1:	c9                   	leave
  804ee2:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  804ee3:	49 89 c0             	mov    %rax,%r8
  804ee6:	b9 07 00 00 00       	mov    $0x7,%ecx
  804eeb:	48 ba b0 72 80 00 00 	movabs $0x8072b0,%rdx
  804ef2:	00 00 00 
  804ef5:	be 26 00 00 00       	mov    $0x26,%esi
  804efa:	48 bf 1a 79 80 00 00 	movabs $0x80791a,%rdi
  804f01:	00 00 00 
  804f04:	b8 00 00 00 00       	mov    $0x0,%eax
  804f09:	49 b9 c1 3c 80 00 00 	movabs $0x803cc1,%r9
  804f10:	00 00 00 
  804f13:	41 ff d1             	call   *%r9

0000000000804f16 <sys_env_set_status>:

/* sys_exofork is inlined in lib.h */

int
sys_env_set_status(envid_t envid, int status) {
  804f16:	f3 0f 1e fa          	endbr64
  804f1a:	55                   	push   %rbp
  804f1b:	48 89 e5             	mov    %rsp,%rbp
  804f1e:	53                   	push   %rbx
  804f1f:	48 83 ec 08          	sub    $0x8,%rsp
    return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0, 0);
  804f23:	48 63 ce             	movslq %esi,%rcx
  804f26:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  804f29:	b8 0a 00 00 00       	mov    $0xa,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  804f2e:	bb 00 00 00 00       	mov    $0x0,%ebx
  804f33:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  804f38:	be 00 00 00 00       	mov    $0x0,%esi
  804f3d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  804f43:	cd 30                	int    $0x30
    if (check && ret > 0) {
  804f45:	48 85 c0             	test   %rax,%rax
  804f48:	7f 06                	jg     804f50 <sys_env_set_status+0x3a>
}
  804f4a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  804f4e:	c9                   	leave
  804f4f:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  804f50:	49 89 c0             	mov    %rax,%r8
  804f53:	b9 0a 00 00 00       	mov    $0xa,%ecx
  804f58:	48 ba b0 72 80 00 00 	movabs $0x8072b0,%rdx
  804f5f:	00 00 00 
  804f62:	be 26 00 00 00       	mov    $0x26,%esi
  804f67:	48 bf 1a 79 80 00 00 	movabs $0x80791a,%rdi
  804f6e:	00 00 00 
  804f71:	b8 00 00 00 00       	mov    $0x0,%eax
  804f76:	49 b9 c1 3c 80 00 00 	movabs $0x803cc1,%r9
  804f7d:	00 00 00 
  804f80:	41 ff d1             	call   *%r9

0000000000804f83 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf) {
  804f83:	f3 0f 1e fa          	endbr64
  804f87:	55                   	push   %rbp
  804f88:	48 89 e5             	mov    %rsp,%rbp
  804f8b:	53                   	push   %rbx
  804f8c:	48 83 ec 08          	sub    $0x8,%rsp
  804f90:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_trapframe, 1, envid, (uintptr_t)tf, 0, 0, 0, 0);
  804f93:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  804f96:	b8 0b 00 00 00       	mov    $0xb,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  804f9b:	bb 00 00 00 00       	mov    $0x0,%ebx
  804fa0:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  804fa5:	be 00 00 00 00       	mov    $0x0,%esi
  804faa:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  804fb0:	cd 30                	int    $0x30
    if (check && ret > 0) {
  804fb2:	48 85 c0             	test   %rax,%rax
  804fb5:	7f 06                	jg     804fbd <sys_env_set_trapframe+0x3a>
}
  804fb7:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  804fbb:	c9                   	leave
  804fbc:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  804fbd:	49 89 c0             	mov    %rax,%r8
  804fc0:	b9 0b 00 00 00       	mov    $0xb,%ecx
  804fc5:	48 ba b0 72 80 00 00 	movabs $0x8072b0,%rdx
  804fcc:	00 00 00 
  804fcf:	be 26 00 00 00       	mov    $0x26,%esi
  804fd4:	48 bf 1a 79 80 00 00 	movabs $0x80791a,%rdi
  804fdb:	00 00 00 
  804fde:	b8 00 00 00 00       	mov    $0x0,%eax
  804fe3:	49 b9 c1 3c 80 00 00 	movabs $0x803cc1,%r9
  804fea:	00 00 00 
  804fed:	41 ff d1             	call   *%r9

0000000000804ff0 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall) {
  804ff0:	f3 0f 1e fa          	endbr64
  804ff4:	55                   	push   %rbp
  804ff5:	48 89 e5             	mov    %rsp,%rbp
  804ff8:	53                   	push   %rbx
  804ff9:	48 83 ec 08          	sub    $0x8,%rsp
  804ffd:	48 89 f1             	mov    %rsi,%rcx
    return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uintptr_t)upcall, 0, 0, 0, 0);
  805000:	48 63 d7             	movslq %edi,%rdx
    register uintptr_t _a0 asm("rax") = num,
  805003:	b8 0c 00 00 00       	mov    $0xc,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  805008:	bb 00 00 00 00       	mov    $0x0,%ebx
  80500d:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  805012:	be 00 00 00 00       	mov    $0x0,%esi
  805017:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  80501d:	cd 30                	int    $0x30
    if (check && ret > 0) {
  80501f:	48 85 c0             	test   %rax,%rax
  805022:	7f 06                	jg     80502a <sys_env_set_pgfault_upcall+0x3a>
}
  805024:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  805028:	c9                   	leave
  805029:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  80502a:	49 89 c0             	mov    %rax,%r8
  80502d:	b9 0c 00 00 00       	mov    $0xc,%ecx
  805032:	48 ba b0 72 80 00 00 	movabs $0x8072b0,%rdx
  805039:	00 00 00 
  80503c:	be 26 00 00 00       	mov    $0x26,%esi
  805041:	48 bf 1a 79 80 00 00 	movabs $0x80791a,%rdi
  805048:	00 00 00 
  80504b:	b8 00 00 00 00       	mov    $0x0,%eax
  805050:	49 b9 c1 3c 80 00 00 	movabs $0x803cc1,%r9
  805057:	00 00 00 
  80505a:	41 ff d1             	call   *%r9

000000000080505d <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uintptr_t value, void *srcva, size_t size, int perm) {
  80505d:	f3 0f 1e fa          	endbr64
  805061:	55                   	push   %rbp
  805062:	48 89 e5             	mov    %rsp,%rbp
  805065:	53                   	push   %rbx
  805066:	89 f8                	mov    %edi,%eax
  805068:	49 89 f1             	mov    %rsi,%r9
  80506b:	48 89 d3             	mov    %rdx,%rbx
  80506e:	48 89 cf             	mov    %rcx,%rdi
    return syscall(SYS_ipc_try_send, 0, envid, value, (uintptr_t)srcva, size, perm, 0);
  805071:	49 63 f0             	movslq %r8d,%rsi
  805074:	48 63 d0             	movslq %eax,%rdx
    register uintptr_t _a0 asm("rax") = num,
  805077:	b8 0e 00 00 00       	mov    $0xe,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  80507c:	4c 89 c9             	mov    %r9,%rcx
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80507f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  805085:	cd 30                	int    $0x30
}
  805087:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80508b:	c9                   	leave
  80508c:	c3                   	ret

000000000080508d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva, size_t size) {
  80508d:	f3 0f 1e fa          	endbr64
  805091:	55                   	push   %rbp
  805092:	48 89 e5             	mov    %rsp,%rbp
  805095:	53                   	push   %rbx
  805096:	48 83 ec 08          	sub    $0x8,%rsp
  80509a:	48 89 fa             	mov    %rdi,%rdx
  80509d:	48 89 f1             	mov    %rsi,%rcx
    register uintptr_t _a0 asm("rax") = num,
  8050a0:	b8 0f 00 00 00       	mov    $0xf,%eax
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  8050a5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8050aa:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  8050af:	be 00 00 00 00       	mov    $0x0,%esi
  8050b4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  8050ba:	cd 30                	int    $0x30
    if (check && ret > 0) {
  8050bc:	48 85 c0             	test   %rax,%rax
  8050bf:	7f 06                	jg     8050c7 <sys_ipc_recv+0x3a>
    int res = syscall(SYS_ipc_recv, 1, (uintptr_t)dstva, size, 0, 0, 0, 0);
#ifdef SANITIZE_USER_SHADOW_BASE
    if (!res) platform_asan_unpoison(dstva, thisenv->env_ipc_maxsz);
#endif
    return res;
}
  8050c1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  8050c5:	c9                   	leave
  8050c6:	c3                   	ret
        panic("syscall %zd returned %zd (> 0)", num, ret);
  8050c7:	49 89 c0             	mov    %rax,%r8
  8050ca:	b9 0f 00 00 00       	mov    $0xf,%ecx
  8050cf:	48 ba b0 72 80 00 00 	movabs $0x8072b0,%rdx
  8050d6:	00 00 00 
  8050d9:	be 26 00 00 00       	mov    $0x26,%esi
  8050de:	48 bf 1a 79 80 00 00 	movabs $0x80791a,%rdi
  8050e5:	00 00 00 
  8050e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8050ed:	49 b9 c1 3c 80 00 00 	movabs $0x803cc1,%r9
  8050f4:	00 00 00 
  8050f7:	41 ff d1             	call   *%r9

00000000008050fa <sys_gettime>:

int
sys_gettime(void) {
  8050fa:	f3 0f 1e fa          	endbr64
  8050fe:	55                   	push   %rbp
  8050ff:	48 89 e5             	mov    %rsp,%rbp
  805102:	53                   	push   %rbx
    register uintptr_t _a0 asm("rax") = num,
  805103:	b8 10 00 00 00       	mov    $0x10,%eax
                           _a1 asm("rdx") = a1, _a2 asm("rcx") = a2,
  805108:	ba 00 00 00 00       	mov    $0x0,%edx
  80510d:	b9 00 00 00 00       	mov    $0x0,%ecx
                           _a3 asm("rbx") = a3, _a4 asm("rdi") = a4,
  805112:	bb 00 00 00 00       	mov    $0x0,%ebx
  805117:	bf 00 00 00 00       	mov    $0x0,%edi
                           _a5 asm("rsi") = a5, _a6 asm("r8") = a6;
  80511c:	be 00 00 00 00       	mov    $0x0,%esi
  805121:	41 b8 00 00 00 00    	mov    $0x0,%r8d
    asm volatile("int %1\n"
  805127:	cd 30                	int    $0x30
    return syscall(SYS_gettime, 0, 0, 0, 0, 0, 0, 0);
}
  805129:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  80512d:	c9                   	leave
  80512e:	c3                   	ret

000000000080512f <_handle_vectored_pagefault>:
/* Vector size */
static size_t _pfhandler_off = 0;
static bool _pfhandler_inititiallized = 0;

void
_handle_vectored_pagefault(struct UTrapframe *utf) {
  80512f:	f3 0f 1e fa          	endbr64
  805133:	55                   	push   %rbp
  805134:	48 89 e5             	mov    %rsp,%rbp
  805137:	41 56                	push   %r14
  805139:	41 55                	push   %r13
  80513b:	41 54                	push   %r12
  80513d:	53                   	push   %rbx
  80513e:	49 89 fc             	mov    %rdi,%r12
    /* This trying to handle pagefault until
     * some handler returns 1, that indicates
     * successfully handled exception */
    for (size_t i = 0; i < _pfhandler_off; i++)
  805141:	48 b8 e8 d6 80 00 00 	movabs $0x80d6e8,%rax
  805148:	00 00 00 
  80514b:	48 83 38 00          	cmpq   $0x0,(%rax)
  80514f:	74 27                	je     805178 <_handle_vectored_pagefault+0x49>
  805151:	bb 00 00 00 00       	mov    $0x0,%ebx
        if (_pfhandler_vec[i](utf)) return;
  805156:	49 bd a0 d6 80 00 00 	movabs $0x80d6a0,%r13
  80515d:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++)
  805160:	49 89 c6             	mov    %rax,%r14
        if (_pfhandler_vec[i](utf)) return;
  805163:	4c 89 e7             	mov    %r12,%rdi
  805166:	41 ff 54 dd 00       	call   *0x0(%r13,%rbx,8)
  80516b:	84 c0                	test   %al,%al
  80516d:	75 45                	jne    8051b4 <_handle_vectored_pagefault+0x85>
    for (size_t i = 0; i < _pfhandler_off; i++)
  80516f:	48 83 c3 01          	add    $0x1,%rbx
  805173:	49 3b 1e             	cmp    (%r14),%rbx
  805176:	72 eb                	jb     805163 <_handle_vectored_pagefault+0x34>

    /* Unhandled exceptions just cause panic */
    panic("Userspace page fault rip=%08lX va=%08lX err=%x\n",
  805178:	49 8b 8c 24 88 00 00 	mov    0x88(%r12),%rcx
  80517f:	00 
  805180:	45 8b 4c 24 08       	mov    0x8(%r12),%r9d
  805185:	4d 8b 04 24          	mov    (%r12),%r8
  805189:	48 ba d0 72 80 00 00 	movabs $0x8072d0,%rdx
  805190:	00 00 00 
  805193:	be 1d 00 00 00       	mov    $0x1d,%esi
  805198:	48 bf 28 79 80 00 00 	movabs $0x807928,%rdi
  80519f:	00 00 00 
  8051a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8051a7:	49 ba c1 3c 80 00 00 	movabs $0x803cc1,%r10
  8051ae:	00 00 00 
  8051b1:	41 ff d2             	call   *%r10
          utf->utf_rip, utf->utf_fault_va, (int)utf->utf_err);
}
  8051b4:	5b                   	pop    %rbx
  8051b5:	41 5c                	pop    %r12
  8051b7:	41 5d                	pop    %r13
  8051b9:	41 5e                	pop    %r14
  8051bb:	5d                   	pop    %rbp
  8051bc:	c3                   	ret

00000000008051bd <add_pgfault_handler>:
 * The first time we register a handler, we need to
 * allocate an exception stack (one page of memory with its top
 * at USER_EXCEPTION_STACK_TOP), and tell the kernel to call the assembly-language
 * _pgfault_upcall routine when a page fault occurs. */
int
add_pgfault_handler(pf_handler_t handler) {
  8051bd:	f3 0f 1e fa          	endbr64
  8051c1:	55                   	push   %rbp
  8051c2:	48 89 e5             	mov    %rsp,%rbp
  8051c5:	53                   	push   %rbx
  8051c6:	48 83 ec 08          	sub    $0x8,%rsp
  8051ca:	48 89 fb             	mov    %rdi,%rbx
    int res = 0;
    if (!_pfhandler_inititiallized) {
  8051cd:	48 b8 e0 d6 80 00 00 	movabs $0x80d6e0,%rax
  8051d4:	00 00 00 
  8051d7:	80 38 00             	cmpb   $0x0,(%rax)
  8051da:	0f 84 84 00 00 00    	je     805264 <add_pgfault_handler+0xa7>
        _pfhandler_vec[_pfhandler_off++] = handler;
        _pfhandler_inititiallized = 1;
        goto end;
    }

    for (size_t i = 0; i < _pfhandler_off; i++)
  8051e0:	48 b8 e8 d6 80 00 00 	movabs $0x80d6e8,%rax
  8051e7:	00 00 00 
  8051ea:	48 8b 10             	mov    (%rax),%rdx
  8051ed:	b8 00 00 00 00       	mov    $0x0,%eax
        if (handler == _pfhandler_vec[i]) return 0;
  8051f2:	48 b9 a0 d6 80 00 00 	movabs $0x80d6a0,%rcx
  8051f9:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++)
  8051fc:	48 85 d2             	test   %rdx,%rdx
  8051ff:	74 19                	je     80521a <add_pgfault_handler+0x5d>
        if (handler == _pfhandler_vec[i]) return 0;
  805201:	48 39 1c c1          	cmp    %rbx,(%rcx,%rax,8)
  805205:	0f 84 e8 00 00 00    	je     8052f3 <add_pgfault_handler+0x136>
    for (size_t i = 0; i < _pfhandler_off; i++)
  80520b:	48 83 c0 01          	add    $0x1,%rax
  80520f:	48 39 d0             	cmp    %rdx,%rax
  805212:	75 ed                	jne    805201 <add_pgfault_handler+0x44>

    if (_pfhandler_off == MAX_PFHANDLER)
  805214:	48 83 fa 08          	cmp    $0x8,%rdx
  805218:	74 1c                	je     805236 <add_pgfault_handler+0x79>
        res = -E_INVAL;
    else
        _pfhandler_vec[_pfhandler_off++] = handler;
  80521a:	48 8d 42 01          	lea    0x1(%rdx),%rax
  80521e:	48 a3 e8 d6 80 00 00 	movabs %rax,0x80d6e8
  805225:	00 00 00 
  805228:	48 b8 a0 d6 80 00 00 	movabs $0x80d6a0,%rax
  80522f:	00 00 00 
  805232:	48 89 1c d0          	mov    %rbx,(%rax,%rdx,8)

end:
    res = sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  805236:	48 b8 9b 4c 80 00 00 	movabs $0x804c9b,%rax
  80523d:	00 00 00 
  805240:	ff d0                	call   *%rax
  805242:	89 c7                	mov    %eax,%edi
  805244:	48 be bd 53 80 00 00 	movabs $0x8053bd,%rsi
  80524b:	00 00 00 
  80524e:	48 b8 f0 4f 80 00 00 	movabs $0x804ff0,%rax
  805255:	00 00 00 
  805258:	ff d0                	call   *%rax
    if (res < 0) panic("set_pgfault_handler: %i", res);
  80525a:	85 c0                	test   %eax,%eax
  80525c:	78 68                	js     8052c6 <add_pgfault_handler+0x109>
    return res;
}
  80525e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  805262:	c9                   	leave
  805263:	c3                   	ret
        res = sys_alloc_region(sys_getenvid(), (void*)(USER_EXCEPTION_STACK_TOP - PAGE_SIZE), PAGE_SIZE, PROT_RW);
  805264:	48 b8 9b 4c 80 00 00 	movabs $0x804c9b,%rax
  80526b:	00 00 00 
  80526e:	ff d0                	call   *%rax
  805270:	89 c7                	mov    %eax,%edi
  805272:	b9 06 00 00 00       	mov    $0x6,%ecx
  805277:	ba 00 10 00 00       	mov    $0x1000,%edx
  80527c:	48 be 00 f0 ff ff 7f 	movabs $0x7ffffff000,%rsi
  805283:	00 00 00 
  805286:	48 b8 6b 4d 80 00 00 	movabs $0x804d6b,%rax
  80528d:	00 00 00 
  805290:	ff d0                	call   *%rax
        _pfhandler_vec[_pfhandler_off++] = handler;
  805292:	48 ba e8 d6 80 00 00 	movabs $0x80d6e8,%rdx
  805299:	00 00 00 
  80529c:	48 8b 02             	mov    (%rdx),%rax
  80529f:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8052a3:	48 89 0a             	mov    %rcx,(%rdx)
  8052a6:	48 ba a0 d6 80 00 00 	movabs $0x80d6a0,%rdx
  8052ad:	00 00 00 
  8052b0:	48 89 1c c2          	mov    %rbx,(%rdx,%rax,8)
        _pfhandler_inititiallized = 1;
  8052b4:	48 b8 e0 d6 80 00 00 	movabs $0x80d6e0,%rax
  8052bb:	00 00 00 
  8052be:	c6 00 01             	movb   $0x1,(%rax)
        goto end;
  8052c1:	e9 70 ff ff ff       	jmp    805236 <add_pgfault_handler+0x79>
    if (res < 0) panic("set_pgfault_handler: %i", res);
  8052c6:	89 c1                	mov    %eax,%ecx
  8052c8:	48 ba 36 79 80 00 00 	movabs $0x807936,%rdx
  8052cf:	00 00 00 
  8052d2:	be 3d 00 00 00       	mov    $0x3d,%esi
  8052d7:	48 bf 28 79 80 00 00 	movabs $0x807928,%rdi
  8052de:	00 00 00 
  8052e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8052e6:	49 b8 c1 3c 80 00 00 	movabs $0x803cc1,%r8
  8052ed:	00 00 00 
  8052f0:	41 ff d0             	call   *%r8
        if (handler == _pfhandler_vec[i]) return 0;
  8052f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8052f8:	e9 61 ff ff ff       	jmp    80525e <add_pgfault_handler+0xa1>

00000000008052fd <remove_pgfault_handler>:

void
remove_pgfault_handler(pf_handler_t handler) {
  8052fd:	f3 0f 1e fa          	endbr64
  805301:	55                   	push   %rbp
  805302:	48 89 e5             	mov    %rsp,%rbp
    assert(_pfhandler_inititiallized);
  805305:	48 b8 e0 d6 80 00 00 	movabs $0x80d6e0,%rax
  80530c:	00 00 00 
  80530f:	80 38 00             	cmpb   $0x0,(%rax)
  805312:	74 33                	je     805347 <remove_pgfault_handler+0x4a>
    for (size_t i = 0; i < _pfhandler_off; i++) {
  805314:	48 a1 e8 d6 80 00 00 	movabs 0x80d6e8,%rax
  80531b:	00 00 00 
  80531e:	b9 00 00 00 00       	mov    $0x0,%ecx
        if (_pfhandler_vec[i] == handler) {
  805323:	48 ba a0 d6 80 00 00 	movabs $0x80d6a0,%rdx
  80532a:	00 00 00 
    for (size_t i = 0; i < _pfhandler_off; i++) {
  80532d:	48 85 c0             	test   %rax,%rax
  805330:	0f 84 85 00 00 00    	je     8053bb <remove_pgfault_handler+0xbe>
        if (_pfhandler_vec[i] == handler) {
  805336:	48 39 3c ca          	cmp    %rdi,(%rdx,%rcx,8)
  80533a:	74 40                	je     80537c <remove_pgfault_handler+0x7f>
    for (size_t i = 0; i < _pfhandler_off; i++) {
  80533c:	48 83 c1 01          	add    $0x1,%rcx
  805340:	48 39 c1             	cmp    %rax,%rcx
  805343:	75 f1                	jne    805336 <remove_pgfault_handler+0x39>
  805345:	eb 74                	jmp    8053bb <remove_pgfault_handler+0xbe>
    assert(_pfhandler_inititiallized);
  805347:	48 b9 4e 79 80 00 00 	movabs $0x80794e,%rcx
  80534e:	00 00 00 
  805351:	48 ba 94 73 80 00 00 	movabs $0x807394,%rdx
  805358:	00 00 00 
  80535b:	be 43 00 00 00       	mov    $0x43,%esi
  805360:	48 bf 28 79 80 00 00 	movabs $0x807928,%rdi
  805367:	00 00 00 
  80536a:	b8 00 00 00 00       	mov    $0x0,%eax
  80536f:	49 b8 c1 3c 80 00 00 	movabs $0x803cc1,%r8
  805376:	00 00 00 
  805379:	41 ff d0             	call   *%r8
            memmove(_pfhandler_vec + i, _pfhandler_vec + i + 1, (_pfhandler_off - i - 1) * sizeof(*handler));
  80537c:	48 8d 34 cd 08 00 00 	lea    0x8(,%rcx,8),%rsi
  805383:	00 
  805384:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  805388:	48 29 ca             	sub    %rcx,%rdx
  80538b:	48 b8 a0 d6 80 00 00 	movabs $0x80d6a0,%rax
  805392:	00 00 00 
  805395:	48 8d 0c 06          	lea    (%rsi,%rax,1),%rcx
  805399:	48 8d 7c 30 f8       	lea    -0x8(%rax,%rsi,1),%rdi
  80539e:	48 89 ce             	mov    %rcx,%rsi
  8053a1:	48 b8 81 49 80 00 00 	movabs $0x804981,%rax
  8053a8:	00 00 00 
  8053ab:	ff d0                	call   *%rax
            _pfhandler_off--;
  8053ad:	48 b8 e8 d6 80 00 00 	movabs $0x80d6e8,%rax
  8053b4:	00 00 00 
  8053b7:	48 83 28 01          	subq   $0x1,(%rax)
            return;
        }
    }
}
  8053bb:	5d                   	pop    %rbp
  8053bc:	c3                   	ret

00000000008053bd <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
    # Call the C page fault handler.
    movq  %rsp,%rdi # passing the function argument in rdi
  8053bd:	48 89 e7             	mov    %rsp,%rdi
    movabs $_handle_vectored_pagefault, %rax
  8053c0:	48 b8 2f 51 80 00 00 	movabs $0x80512f,%rax
  8053c7:	00 00 00 
    call *%rax
  8053ca:	ff d0                	call   *%rax
    # registers are available for intermediate calculations.  You
    # may find that you have to rearrange your code in non-obvious
    # ways as registers become unavailable as scratch space.

    # LAB 9: Your code here
    movq %rsp, %rax
  8053cc:	48 89 e0             	mov    %rsp,%rax
    movq UTRAP_RIP(%rsp), %rbx
  8053cf:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  8053d6:	00 
    movq UTRAP_RSP(%rsp), %rsp
  8053d7:	48 8b a4 24 98 00 00 	mov    0x98(%rsp),%rsp
  8053de:	00 
    pushq %rbx
  8053df:	53                   	push   %rbx
    movq %rsp, UTRAP_RSP(%rax)
  8053e0:	48 89 a0 98 00 00 00 	mov    %rsp,0x98(%rax)

    # Restore the trap-time registers.  After you do this, you
    # can no longer modify any general-purpose registers (use POPA macro).
    # LAB 9: Your code here
    movq %rax, %rsp
  8053e7:	48 89 c4             	mov    %rax,%rsp
    addq $16, %rsp
  8053ea:	48 83 c4 10          	add    $0x10,%rsp
    POPA
  8053ee:	4c 8b 3c 24          	mov    (%rsp),%r15
  8053f2:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  8053f7:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  8053fc:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  805401:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  805406:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  80540b:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  805410:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  805415:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  80541a:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  80541f:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  805424:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  805429:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  80542e:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  805433:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  805438:	48 83 c4 78          	add    $0x78,%rsp
    addq $8, %rsp
  80543c:	48 83 c4 08          	add    $0x8,%rsp
    # Restore rflags from the stack.  After you do this, you can
    # no longer use arithmetic operations or anything else that
    # modifies rflags.
    # LAB 9: Your code here
	popfq
  805440:	9d                   	popf
    # Switch back to the adjusted trap-time stack.
    # LAB 9: Your code here
	popq %rsp
  805441:	5c                   	pop    %rsp
    # Return to re-execute the instruction that faulted.
    ret
  805442:	c3                   	ret

0000000000805443 <ipc_recv>:
 *   Use 'thisenv' to discover the value and who sent it.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value, since that's
 *   a perfectly valid place to map a page.) */
int32_t
ipc_recv(envid_t *from_env_store, void *pg, size_t *size, int *perm_store) {
  805443:	f3 0f 1e fa          	endbr64
  805447:	55                   	push   %rbp
  805448:	48 89 e5             	mov    %rsp,%rbp
  80544b:	41 54                	push   %r12
  80544d:	53                   	push   %rbx
  80544e:	48 89 fb             	mov    %rdi,%rbx
  805451:	48 89 f7             	mov    %rsi,%rdi
  805454:	49 89 cc             	mov    %rcx,%r12
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  805457:	48 85 f6             	test   %rsi,%rsi
  80545a:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  805461:	00 00 00 
  805464:	48 0f 44 f8          	cmove  %rax,%rdi
    }
    int res = sys_ipc_recv(pg, PAGE_SIZE);
  805468:	be 00 10 00 00       	mov    $0x1000,%esi
  80546d:	48 b8 8d 50 80 00 00 	movabs $0x80508d,%rax
  805474:	00 00 00 
  805477:	ff d0                	call   *%rax
    if (res < 0) {
  805479:	85 c0                	test   %eax,%eax
  80547b:	78 45                	js     8054c2 <ipc_recv+0x7f>
        if (perm_store != NULL) {
            *perm_store = 0;
        }
        return res;
    } else {
        if (from_env_store != NULL) {
  80547d:	48 85 db             	test   %rbx,%rbx
  805480:	74 12                	je     805494 <ipc_recv+0x51>
            *from_env_store = thisenv->env_ipc_from;
  805482:	48 a1 88 d6 80 00 00 	movabs 0x80d688,%rax
  805489:	00 00 00 
  80548c:	8b 80 24 01 00 00    	mov    0x124(%rax),%eax
  805492:	89 03                	mov    %eax,(%rbx)
        }
        if (perm_store != NULL) {
  805494:	4d 85 e4             	test   %r12,%r12
  805497:	74 14                	je     8054ad <ipc_recv+0x6a>
            *perm_store = thisenv->env_ipc_perm;
  805499:	48 a1 88 d6 80 00 00 	movabs 0x80d688,%rax
  8054a0:	00 00 00 
  8054a3:	8b 80 28 01 00 00    	mov    0x128(%rax),%eax
  8054a9:	41 89 04 24          	mov    %eax,(%r12)
        }
        return thisenv->env_ipc_value;
  8054ad:	48 a1 88 d6 80 00 00 	movabs 0x80d688,%rax
  8054b4:	00 00 00 
  8054b7:	8b 80 20 01 00 00    	mov    0x120(%rax),%eax
    }
    return -1;
}
  8054bd:	5b                   	pop    %rbx
  8054be:	41 5c                	pop    %r12
  8054c0:	5d                   	pop    %rbp
  8054c1:	c3                   	ret
        if (from_env_store != NULL) {
  8054c2:	48 85 db             	test   %rbx,%rbx
  8054c5:	74 06                	je     8054cd <ipc_recv+0x8a>
            *from_env_store = 0;
  8054c7:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
        if (perm_store != NULL) {
  8054cd:	4d 85 e4             	test   %r12,%r12
  8054d0:	74 eb                	je     8054bd <ipc_recv+0x7a>
            *perm_store = 0;
  8054d2:	41 c7 04 24 00 00 00 	movl   $0x0,(%r12)
  8054d9:	00 
  8054da:	eb e1                	jmp    8054bd <ipc_recv+0x7a>

00000000008054dc <ipc_send>:
 * Hint:
 *   Use sys_yield() to be CPU-friendly.
 *   If 'pg' is null, pass sys_ipc_recv a value that it will understand
 *   as meaning "no page".  (Zero is not the right value.) */
void
ipc_send(envid_t to_env, uint32_t val, void *pg, size_t size, int perm) {
  8054dc:	f3 0f 1e fa          	endbr64
  8054e0:	55                   	push   %rbp
  8054e1:	48 89 e5             	mov    %rsp,%rbp
  8054e4:	41 57                	push   %r15
  8054e6:	41 56                	push   %r14
  8054e8:	41 55                	push   %r13
  8054ea:	41 54                	push   %r12
  8054ec:	53                   	push   %rbx
  8054ed:	48 83 ec 18          	sub    $0x18,%rsp
  8054f1:	89 7d c4             	mov    %edi,-0x3c(%rbp)
  8054f4:	48 89 d3             	mov    %rdx,%rbx
  8054f7:	49 89 cc             	mov    %rcx,%r12
  8054fa:	45 89 c5             	mov    %r8d,%r13d
    // LAB 9: Your code here:
    if (pg == NULL) {
        pg = (void *)MAX_USER_ADDRESS;
  8054fd:	48 85 d2             	test   %rdx,%rdx
  805500:	48 b8 00 00 00 00 80 	movabs $0x8000000000,%rax
  805507:	00 00 00 
  80550a:	48 0f 44 d8          	cmove  %rax,%rbx
    }
    int res = sys_ipc_try_send(to_env, val, pg, size, perm);
  80550e:	89 f0                	mov    %esi,%eax
  805510:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  805514:	48 89 da             	mov    %rbx,%rdx
  805517:	48 89 c6             	mov    %rax,%rsi
  80551a:	48 b8 5d 50 80 00 00 	movabs $0x80505d,%rax
  805521:	00 00 00 
  805524:	ff d0                	call   *%rax
    while (res < 0) {
  805526:	85 c0                	test   %eax,%eax
  805528:	79 65                	jns    80558f <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  80552a:	83 f8 f5             	cmp    $0xfffffff5,%eax
  80552d:	75 33                	jne    805562 <ipc_send+0x86>
            panic("Error: %i\n", res);
        }
        sys_yield();
  80552f:	49 bf d0 4c 80 00 00 	movabs $0x804cd0,%r15
  805536:	00 00 00 
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  805539:	49 be 5d 50 80 00 00 	movabs $0x80505d,%r14
  805540:	00 00 00 
        sys_yield();
  805543:	41 ff d7             	call   *%r15
        res = sys_ipc_try_send(to_env, val, pg, size, perm);
  805546:	45 89 e8             	mov    %r13d,%r8d
  805549:	4c 89 e1             	mov    %r12,%rcx
  80554c:	48 89 da             	mov    %rbx,%rdx
  80554f:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  805553:	8b 7d c4             	mov    -0x3c(%rbp),%edi
  805556:	41 ff d6             	call   *%r14
    while (res < 0) {
  805559:	85 c0                	test   %eax,%eax
  80555b:	79 32                	jns    80558f <ipc_send+0xb3>
        if (res < 0 && res != -E_IPC_NOT_RECV) {
  80555d:	83 f8 f5             	cmp    $0xfffffff5,%eax
  805560:	74 e1                	je     805543 <ipc_send+0x67>
            panic("Error: %i\n", res);
  805562:	89 c1                	mov    %eax,%ecx
  805564:	48 ba 68 79 80 00 00 	movabs $0x807968,%rdx
  80556b:	00 00 00 
  80556e:	be 42 00 00 00       	mov    $0x42,%esi
  805573:	48 bf 73 79 80 00 00 	movabs $0x807973,%rdi
  80557a:	00 00 00 
  80557d:	b8 00 00 00 00       	mov    $0x0,%eax
  805582:	49 b8 c1 3c 80 00 00 	movabs $0x803cc1,%r8
  805589:	00 00 00 
  80558c:	41 ff d0             	call   *%r8
    }
}
  80558f:	48 83 c4 18          	add    $0x18,%rsp
  805593:	5b                   	pop    %rbx
  805594:	41 5c                	pop    %r12
  805596:	41 5d                	pop    %r13
  805598:	41 5e                	pop    %r14
  80559a:	41 5f                	pop    %r15
  80559c:	5d                   	pop    %rbp
  80559d:	c3                   	ret

000000000080559e <ipc_find_env>:

/* Find the first environment of the given type.  We'll use this to
 * find special environments.
 * Returns 0 if no such environment exists. */
envid_t
ipc_find_env(enum EnvType type) {
  80559e:	f3 0f 1e fa          	endbr64
    for (size_t i = 0; i < NENV; i++)
  8055a2:	b8 00 00 00 00       	mov    $0x0,%eax
        if (envs[i].env_type == type)
  8055a7:	48 b9 00 00 a0 1f 80 	movabs $0x801fa00000,%rcx
  8055ae:	00 00 00 
  8055b1:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8055b5:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  8055b9:	48 c1 e2 04          	shl    $0x4,%rdx
  8055bd:	48 01 ca             	add    %rcx,%rdx
  8055c0:	8b 92 d0 00 00 00    	mov    0xd0(%rdx),%edx
  8055c6:	39 fa                	cmp    %edi,%edx
  8055c8:	74 12                	je     8055dc <ipc_find_env+0x3e>
    for (size_t i = 0; i < NENV; i++)
  8055ca:	48 83 c0 01          	add    $0x1,%rax
  8055ce:	48 3d 00 04 00 00    	cmp    $0x400,%rax
  8055d4:	75 db                	jne    8055b1 <ipc_find_env+0x13>
            return envs[i].env_id;
    return 0;
  8055d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8055db:	c3                   	ret
            return envs[i].env_id;
  8055dc:	48 8d 14 c0          	lea    (%rax,%rax,8),%rdx
  8055e0:	48 8d 14 50          	lea    (%rax,%rdx,2),%rdx
  8055e4:	48 c1 e2 04          	shl    $0x4,%rdx
  8055e8:	48 b8 00 00 a0 1f 80 	movabs $0x801fa00000,%rax
  8055ef:	00 00 00 
  8055f2:	48 01 d0             	add    %rdx,%rax
  8055f5:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8055fb:	c3                   	ret

00000000008055fc <fd2num>:


/********************File descriptor manipulators***********************/

uint64_t
fd2num(struct Fd *fd) {
  8055fc:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  805600:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  805607:	ff ff ff 
  80560a:	48 01 f8             	add    %rdi,%rax
  80560d:	48 c1 e8 0c          	shr    $0xc,%rax
}
  805611:	c3                   	ret

0000000000805612 <fd2data>:

char *
fd2data(struct Fd *fd) {
  805612:	f3 0f 1e fa          	endbr64
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  805616:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80561d:	ff ff ff 
  805620:	48 01 f8             	add    %rdi,%rax
  805623:	48 c1 e8 0c          	shr    $0xc,%rax
    return INDEX2DATA(fd2num(fd));
  805627:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80562d:	48 c1 e0 0c          	shl    $0xc,%rax
}
  805631:	c3                   	ret

0000000000805632 <fd_alloc>:
 *
 * Returns 0 on success, < 0 on error.  Errors are:
 *  -E_MAX_FD: no more file descriptors
 * On error, *fd_store is set to 0. */
int
fd_alloc(struct Fd **fd_store) {
  805632:	f3 0f 1e fa          	endbr64
  805636:	55                   	push   %rbp
  805637:	48 89 e5             	mov    %rsp,%rbp
  80563a:	41 57                	push   %r15
  80563c:	41 56                	push   %r14
  80563e:	41 55                	push   %r13
  805640:	41 54                	push   %r12
  805642:	53                   	push   %rbx
  805643:	48 83 ec 08          	sub    $0x8,%rsp
  805647:	49 89 ff             	mov    %rdi,%r15
  80564a:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
    for (int i = 0; i < MAXFD; i++) {
        struct Fd *fd = INDEX2FD(i);
        if (!(get_prot(fd) & PROT_R)) {
  80564f:	49 bd 91 67 80 00 00 	movabs $0x806791,%r13
  805656:	00 00 00 
    for (int i = 0; i < MAXFD; i++) {
  805659:	41 be 00 00 02 d0    	mov    $0xd0020000,%r14d
        struct Fd *fd = INDEX2FD(i);
  80565f:	49 89 dc             	mov    %rbx,%r12
        if (!(get_prot(fd) & PROT_R)) {
  805662:	48 89 df             	mov    %rbx,%rdi
  805665:	41 ff d5             	call   *%r13
  805668:	83 e0 04             	and    $0x4,%eax
  80566b:	74 17                	je     805684 <fd_alloc+0x52>
    for (int i = 0; i < MAXFD; i++) {
  80566d:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  805674:	4c 39 f3             	cmp    %r14,%rbx
  805677:	75 e6                	jne    80565f <fd_alloc+0x2d>
  805679:	41 bc 00 00 00 00    	mov    $0x0,%r12d
            *fd_store = fd;
            return 0;
        }
    }
    *fd_store = 0;
    return -E_MAX_OPEN;
  80567f:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
            *fd_store = fd;
  805684:	4d 89 27             	mov    %r12,(%r15)
}
  805687:	48 83 c4 08          	add    $0x8,%rsp
  80568b:	5b                   	pop    %rbx
  80568c:	41 5c                	pop    %r12
  80568e:	41 5d                	pop    %r13
  805690:	41 5e                	pop    %r14
  805692:	41 5f                	pop    %r15
  805694:	5d                   	pop    %rbp
  805695:	c3                   	ret

0000000000805696 <fd_lookup>:
 *
 * Returns 0 on success (the page is in range and mapped), < 0 on error.
 * Errors are:
 *  -E_INVAL: fdnum was either not in range or not mapped. */
int
fd_lookup(int fdnum, struct Fd **fd_store) {
  805696:	f3 0f 1e fa          	endbr64
    if (fdnum < 0 || fdnum >= MAXFD) {
  80569a:	83 ff 1f             	cmp    $0x1f,%edi
  80569d:	77 39                	ja     8056d8 <fd_lookup+0x42>
fd_lookup(int fdnum, struct Fd **fd_store) {
  80569f:	55                   	push   %rbp
  8056a0:	48 89 e5             	mov    %rsp,%rbp
  8056a3:	41 54                	push   %r12
  8056a5:	53                   	push   %rbx
  8056a6:	49 89 f4             	mov    %rsi,%r12
        if (debug) cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    struct Fd *fd = INDEX2FD(fdnum);
  8056a9:	48 63 df             	movslq %edi,%rbx
  8056ac:	48 81 c3 00 00 0d 00 	add    $0xd0000,%rbx
  8056b3:	48 c1 e3 0c          	shl    $0xc,%rbx

    if (!(get_prot(fd) & PROT_R)) {
  8056b7:	48 89 df             	mov    %rbx,%rdi
  8056ba:	48 b8 91 67 80 00 00 	movabs $0x806791,%rax
  8056c1:	00 00 00 
  8056c4:	ff d0                	call   *%rax
  8056c6:	a8 04                	test   $0x4,%al
  8056c8:	74 14                	je     8056de <fd_lookup+0x48>
        if (debug) cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    *fd_store = fd;
  8056ca:	49 89 1c 24          	mov    %rbx,(%r12)
    return 0;
  8056ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8056d3:	5b                   	pop    %rbx
  8056d4:	41 5c                	pop    %r12
  8056d6:	5d                   	pop    %rbp
  8056d7:	c3                   	ret
        return -E_INVAL;
  8056d8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8056dd:	c3                   	ret
        return -E_INVAL;
  8056de:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8056e3:	eb ee                	jmp    8056d3 <fd_lookup+0x3d>

00000000008056e5 <dev_lookup>:
        &devpipe,
        &devcons,
        NULL};

int
dev_lookup(int dev_id, struct Dev **dev) {
  8056e5:	f3 0f 1e fa          	endbr64
  8056e9:	55                   	push   %rbp
  8056ea:	48 89 e5             	mov    %rsp,%rbp
  8056ed:	41 54                	push   %r12
  8056ef:	53                   	push   %rbx
  8056f0:	49 89 f4             	mov    %rsi,%r12
    for (size_t i = 0; devtab[i]; i++) {
  8056f3:	48 b8 80 7d 80 00 00 	movabs $0x807d80,%rax
  8056fa:	00 00 00 
  8056fd:	48 bb 80 c0 80 00 00 	movabs $0x80c080,%rbx
  805704:	00 00 00 
        if (devtab[i]->dev_id == dev_id) {
  805707:	39 3b                	cmp    %edi,(%rbx)
  805709:	74 47                	je     805752 <dev_lookup+0x6d>
    for (size_t i = 0; devtab[i]; i++) {
  80570b:	48 83 c0 08          	add    $0x8,%rax
  80570f:	48 8b 18             	mov    (%rax),%rbx
  805712:	48 85 db             	test   %rbx,%rbx
  805715:	75 f0                	jne    805707 <dev_lookup+0x22>
            *dev = devtab[i];
            return 0;
        }
    }
    cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  805717:	48 a1 88 d6 80 00 00 	movabs 0x80d688,%rax
  80571e:	00 00 00 
  805721:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  805727:	89 fa                	mov    %edi,%edx
  805729:	48 bf 00 73 80 00 00 	movabs $0x807300,%rdi
  805730:	00 00 00 
  805733:	b8 00 00 00 00       	mov    $0x0,%eax
  805738:	48 b9 1d 3e 80 00 00 	movabs $0x803e1d,%rcx
  80573f:	00 00 00 
  805742:	ff d1                	call   *%rcx
    *dev = 0;
    return -E_INVAL;
  805744:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
            *dev = devtab[i];
  805749:	49 89 1c 24          	mov    %rbx,(%r12)
}
  80574d:	5b                   	pop    %rbx
  80574e:	41 5c                	pop    %r12
  805750:	5d                   	pop    %rbp
  805751:	c3                   	ret
            return 0;
  805752:	b8 00 00 00 00       	mov    $0x0,%eax
  805757:	eb f0                	jmp    805749 <dev_lookup+0x64>

0000000000805759 <fd_close>:
fd_close(struct Fd *fd, bool must_exist) {
  805759:	f3 0f 1e fa          	endbr64
  80575d:	55                   	push   %rbp
  80575e:	48 89 e5             	mov    %rsp,%rbp
  805761:	41 55                	push   %r13
  805763:	41 54                	push   %r12
  805765:	53                   	push   %rbx
  805766:	48 83 ec 18          	sub    $0x18,%rsp
  80576a:	48 89 fb             	mov    %rdi,%rbx
  80576d:	41 89 f4             	mov    %esi,%r12d
    return ((uintptr_t)fd - FDTABLE) / PAGE_SIZE;
  805770:	48 bf 00 00 00 30 ff 	movabs $0xffffffff30000000,%rdi
  805777:	ff ff ff 
  80577a:	48 01 df             	add    %rbx,%rdi
  80577d:	48 c1 ef 0c          	shr    $0xc,%rdi
    if ((res = fd_lookup(fd2num(fd), &fd2)) < 0 || fd != fd2) {
  805781:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  805785:	48 b8 96 56 80 00 00 	movabs $0x805696,%rax
  80578c:	00 00 00 
  80578f:	ff d0                	call   *%rax
  805791:	41 89 c5             	mov    %eax,%r13d
  805794:	85 c0                	test   %eax,%eax
  805796:	78 06                	js     80579e <fd_close+0x45>
  805798:	48 39 5d d8          	cmp    %rbx,-0x28(%rbp)
  80579c:	74 1a                	je     8057b8 <fd_close+0x5f>
        return (must_exist ? res : 0);
  80579e:	45 84 e4             	test   %r12b,%r12b
  8057a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8057a6:	44 0f 44 e8          	cmove  %eax,%r13d
}
  8057aa:	44 89 e8             	mov    %r13d,%eax
  8057ad:	48 83 c4 18          	add    $0x18,%rsp
  8057b1:	5b                   	pop    %rbx
  8057b2:	41 5c                	pop    %r12
  8057b4:	41 5d                	pop    %r13
  8057b6:	5d                   	pop    %rbp
  8057b7:	c3                   	ret
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8057b8:	8b 3b                	mov    (%rbx),%edi
  8057ba:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8057be:	48 b8 e5 56 80 00 00 	movabs $0x8056e5,%rax
  8057c5:	00 00 00 
  8057c8:	ff d0                	call   *%rax
  8057ca:	41 89 c5             	mov    %eax,%r13d
  8057cd:	85 c0                	test   %eax,%eax
  8057cf:	78 1b                	js     8057ec <fd_close+0x93>
        res = dev->dev_close ? (*dev->dev_close)(fd) : 0;
  8057d1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8057d5:	48 8b 40 20          	mov    0x20(%rax),%rax
  8057d9:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  8057df:	48 85 c0             	test   %rax,%rax
  8057e2:	74 08                	je     8057ec <fd_close+0x93>
  8057e4:	48 89 df             	mov    %rbx,%rdi
  8057e7:	ff d0                	call   *%rax
  8057e9:	41 89 c5             	mov    %eax,%r13d
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  8057ec:	ba 00 10 00 00       	mov    $0x1000,%edx
  8057f1:	48 89 de             	mov    %rbx,%rsi
  8057f4:	bf 00 00 00 00       	mov    $0x0,%edi
  8057f9:	48 b8 ab 4e 80 00 00 	movabs $0x804eab,%rax
  805800:	00 00 00 
  805803:	ff d0                	call   *%rax
    return res;
  805805:	eb a3                	jmp    8057aa <fd_close+0x51>

0000000000805807 <close>:

int
close(int fdnum) {
  805807:	f3 0f 1e fa          	endbr64
  80580b:	55                   	push   %rbp
  80580c:	48 89 e5             	mov    %rsp,%rbp
  80580f:	48 83 ec 10          	sub    $0x10,%rsp
    struct Fd *fd;
    int res = fd_lookup(fdnum, &fd);
  805813:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  805817:	48 b8 96 56 80 00 00 	movabs $0x805696,%rax
  80581e:	00 00 00 
  805821:	ff d0                	call   *%rax
    if (res < 0) return res;
  805823:	85 c0                	test   %eax,%eax
  805825:	78 15                	js     80583c <close+0x35>

    return fd_close(fd, 1);
  805827:	be 01 00 00 00       	mov    $0x1,%esi
  80582c:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  805830:	48 b8 59 57 80 00 00 	movabs $0x805759,%rax
  805837:	00 00 00 
  80583a:	ff d0                	call   *%rax
}
  80583c:	c9                   	leave
  80583d:	c3                   	ret

000000000080583e <close_all>:

void
close_all(void) {
  80583e:	f3 0f 1e fa          	endbr64
  805842:	55                   	push   %rbp
  805843:	48 89 e5             	mov    %rsp,%rbp
  805846:	41 54                	push   %r12
  805848:	53                   	push   %rbx
    for (int i = 0; i < MAXFD; i++) close(i);
  805849:	bb 00 00 00 00       	mov    $0x0,%ebx
  80584e:	49 bc 07 58 80 00 00 	movabs $0x805807,%r12
  805855:	00 00 00 
  805858:	89 df                	mov    %ebx,%edi
  80585a:	41 ff d4             	call   *%r12
  80585d:	83 c3 01             	add    $0x1,%ebx
  805860:	83 fb 20             	cmp    $0x20,%ebx
  805863:	75 f3                	jne    805858 <close_all+0x1a>
}
  805865:	5b                   	pop    %rbx
  805866:	41 5c                	pop    %r12
  805868:	5d                   	pop    %rbp
  805869:	c3                   	ret

000000000080586a <dup>:
 * For instance, writing onto either file descriptor will affect the
 * file and the file offset of the other.
 * Closes any previously open file descriptor at 'newfdnum'.
 * This is implemented using virtual memory tricks (of course!). */
int
dup(int oldfdnum, int newfdnum) {
  80586a:	f3 0f 1e fa          	endbr64
  80586e:	55                   	push   %rbp
  80586f:	48 89 e5             	mov    %rsp,%rbp
  805872:	41 57                	push   %r15
  805874:	41 56                	push   %r14
  805876:	41 55                	push   %r13
  805878:	41 54                	push   %r12
  80587a:	53                   	push   %rbx
  80587b:	48 83 ec 18          	sub    $0x18,%rsp
  80587f:	41 89 f4             	mov    %esi,%r12d
    struct Fd *oldfd, *newfd;

    int res;
    if ((res = fd_lookup(oldfdnum, &oldfd)) < 0) return res;
  805882:	48 8d 75 c8          	lea    -0x38(%rbp),%rsi
  805886:	48 b8 96 56 80 00 00 	movabs $0x805696,%rax
  80588d:	00 00 00 
  805890:	ff d0                	call   *%rax
  805892:	89 c3                	mov    %eax,%ebx
  805894:	85 c0                	test   %eax,%eax
  805896:	0f 88 b8 00 00 00    	js     805954 <dup+0xea>
    close(newfdnum);
  80589c:	44 89 e7             	mov    %r12d,%edi
  80589f:	48 b8 07 58 80 00 00 	movabs $0x805807,%rax
  8058a6:	00 00 00 
  8058a9:	ff d0                	call   *%rax

    newfd = INDEX2FD(newfdnum);
  8058ab:	4d 63 ec             	movslq %r12d,%r13
  8058ae:	49 81 c5 00 00 0d 00 	add    $0xd0000,%r13
  8058b5:	49 c1 e5 0c          	shl    $0xc,%r13
    char *oldva = fd2data(oldfd);
  8058b9:	4c 8b 7d c8          	mov    -0x38(%rbp),%r15
  8058bd:	4c 89 ff             	mov    %r15,%rdi
  8058c0:	49 be 12 56 80 00 00 	movabs $0x805612,%r14
  8058c7:	00 00 00 
  8058ca:	41 ff d6             	call   *%r14
  8058cd:	48 89 c3             	mov    %rax,%rbx
    char *newva = fd2data(newfd);
  8058d0:	4c 89 ef             	mov    %r13,%rdi
  8058d3:	41 ff d6             	call   *%r14
  8058d6:	49 89 c6             	mov    %rax,%r14

    int prot = get_prot(oldva);
  8058d9:	48 89 df             	mov    %rbx,%rdi
  8058dc:	48 b8 91 67 80 00 00 	movabs $0x806791,%rax
  8058e3:	00 00 00 
  8058e6:	ff d0                	call   *%rax
    if (prot & PROT_R) {
  8058e8:	a8 04                	test   $0x4,%al
  8058ea:	74 2b                	je     805917 <dup+0xad>
        if ((res = sys_map_region(0, oldva, 0, newva, PAGE_SIZE, prot)) < 0) goto err;
  8058ec:	41 89 c1             	mov    %eax,%r9d
  8058ef:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  8058f5:	4c 89 f1             	mov    %r14,%rcx
  8058f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8058fd:	48 89 de             	mov    %rbx,%rsi
  805900:	bf 00 00 00 00       	mov    $0x0,%edi
  805905:	48 b8 d6 4d 80 00 00 	movabs $0x804dd6,%rax
  80590c:	00 00 00 
  80590f:	ff d0                	call   *%rax
  805911:	89 c3                	mov    %eax,%ebx
  805913:	85 c0                	test   %eax,%eax
  805915:	78 4e                	js     805965 <dup+0xfb>
    }
    prot = get_prot(oldfd);
  805917:	4c 89 ff             	mov    %r15,%rdi
  80591a:	48 b8 91 67 80 00 00 	movabs $0x806791,%rax
  805921:	00 00 00 
  805924:	ff d0                	call   *%rax
  805926:	41 89 c1             	mov    %eax,%r9d
    if ((res = sys_map_region(0, oldfd, 0, newfd, PAGE_SIZE, prot)) < 0) goto err;
  805929:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  80592f:	4c 89 e9             	mov    %r13,%rcx
  805932:	ba 00 00 00 00       	mov    $0x0,%edx
  805937:	4c 89 fe             	mov    %r15,%rsi
  80593a:	bf 00 00 00 00       	mov    $0x0,%edi
  80593f:	48 b8 d6 4d 80 00 00 	movabs $0x804dd6,%rax
  805946:	00 00 00 
  805949:	ff d0                	call   *%rax
  80594b:	89 c3                	mov    %eax,%ebx
  80594d:	85 c0                	test   %eax,%eax
  80594f:	78 14                	js     805965 <dup+0xfb>

    return newfdnum;
  805951:	44 89 e3             	mov    %r12d,%ebx

err:
    sys_unmap_region(0, newfd, PAGE_SIZE);
    sys_unmap_region(0, newva, PAGE_SIZE);
    return res;
}
  805954:	89 d8                	mov    %ebx,%eax
  805956:	48 83 c4 18          	add    $0x18,%rsp
  80595a:	5b                   	pop    %rbx
  80595b:	41 5c                	pop    %r12
  80595d:	41 5d                	pop    %r13
  80595f:	41 5e                	pop    %r14
  805961:	41 5f                	pop    %r15
  805963:	5d                   	pop    %rbp
  805964:	c3                   	ret
    sys_unmap_region(0, newfd, PAGE_SIZE);
  805965:	ba 00 10 00 00       	mov    $0x1000,%edx
  80596a:	4c 89 ee             	mov    %r13,%rsi
  80596d:	bf 00 00 00 00       	mov    $0x0,%edi
  805972:	49 bc ab 4e 80 00 00 	movabs $0x804eab,%r12
  805979:	00 00 00 
  80597c:	41 ff d4             	call   *%r12
    sys_unmap_region(0, newva, PAGE_SIZE);
  80597f:	ba 00 10 00 00       	mov    $0x1000,%edx
  805984:	4c 89 f6             	mov    %r14,%rsi
  805987:	bf 00 00 00 00       	mov    $0x0,%edi
  80598c:	41 ff d4             	call   *%r12
    return res;
  80598f:	eb c3                	jmp    805954 <dup+0xea>

0000000000805991 <read>:

ssize_t
read(int fdnum, void *buf, size_t n) {
  805991:	f3 0f 1e fa          	endbr64
  805995:	55                   	push   %rbp
  805996:	48 89 e5             	mov    %rsp,%rbp
  805999:	41 56                	push   %r14
  80599b:	41 55                	push   %r13
  80599d:	41 54                	push   %r12
  80599f:	53                   	push   %rbx
  8059a0:	48 83 ec 10          	sub    $0x10,%rsp
  8059a4:	89 fb                	mov    %edi,%ebx
  8059a6:	49 89 f4             	mov    %rsi,%r12
  8059a9:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  8059ac:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  8059b0:	48 b8 96 56 80 00 00 	movabs $0x805696,%rax
  8059b7:	00 00 00 
  8059ba:	ff d0                	call   *%rax
  8059bc:	85 c0                	test   %eax,%eax
  8059be:	78 4c                	js     805a0c <read+0x7b>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  8059c0:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  8059c4:	41 8b 3e             	mov    (%r14),%edi
  8059c7:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  8059cb:	48 b8 e5 56 80 00 00 	movabs $0x8056e5,%rax
  8059d2:	00 00 00 
  8059d5:	ff d0                	call   *%rax
  8059d7:	85 c0                	test   %eax,%eax
  8059d9:	78 35                	js     805a10 <read+0x7f>

    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8059db:	41 8b 46 08          	mov    0x8(%r14),%eax
  8059df:	83 e0 03             	and    $0x3,%eax
  8059e2:	83 f8 01             	cmp    $0x1,%eax
  8059e5:	74 2d                	je     805a14 <read+0x83>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_read) return -E_NOT_SUPP;
  8059e7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8059eb:	48 8b 40 10          	mov    0x10(%rax),%rax
  8059ef:	48 85 c0             	test   %rax,%rax
  8059f2:	74 56                	je     805a4a <read+0xb9>

    return (*dev->dev_read)(fd, buf, n);
  8059f4:	4c 89 ea             	mov    %r13,%rdx
  8059f7:	4c 89 e6             	mov    %r12,%rsi
  8059fa:	4c 89 f7             	mov    %r14,%rdi
  8059fd:	ff d0                	call   *%rax
}
  8059ff:	48 83 c4 10          	add    $0x10,%rsp
  805a03:	5b                   	pop    %rbx
  805a04:	41 5c                	pop    %r12
  805a06:	41 5d                	pop    %r13
  805a08:	41 5e                	pop    %r14
  805a0a:	5d                   	pop    %rbp
  805a0b:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  805a0c:	48 98                	cltq
  805a0e:	eb ef                	jmp    8059ff <read+0x6e>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  805a10:	48 98                	cltq
  805a12:	eb eb                	jmp    8059ff <read+0x6e>
        cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  805a14:	48 a1 88 d6 80 00 00 	movabs 0x80d688,%rax
  805a1b:	00 00 00 
  805a1e:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  805a24:	89 da                	mov    %ebx,%edx
  805a26:	48 bf 7d 79 80 00 00 	movabs $0x80797d,%rdi
  805a2d:	00 00 00 
  805a30:	b8 00 00 00 00       	mov    $0x0,%eax
  805a35:	48 b9 1d 3e 80 00 00 	movabs $0x803e1d,%rcx
  805a3c:	00 00 00 
  805a3f:	ff d1                	call   *%rcx
        return -E_INVAL;
  805a41:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  805a48:	eb b5                	jmp    8059ff <read+0x6e>
    if (!dev->dev_read) return -E_NOT_SUPP;
  805a4a:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  805a51:	eb ac                	jmp    8059ff <read+0x6e>

0000000000805a53 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n) {
  805a53:	f3 0f 1e fa          	endbr64
  805a57:	55                   	push   %rbp
  805a58:	48 89 e5             	mov    %rsp,%rbp
  805a5b:	41 57                	push   %r15
  805a5d:	41 56                	push   %r14
  805a5f:	41 55                	push   %r13
  805a61:	41 54                	push   %r12
  805a63:	53                   	push   %rbx
  805a64:	48 83 ec 08          	sub    $0x8,%rsp
    int inc = 1, res = 0;
    for (; inc && res < n; res += inc) {
  805a68:	48 85 d2             	test   %rdx,%rdx
  805a6b:	74 54                	je     805ac1 <readn+0x6e>
  805a6d:	41 89 fd             	mov    %edi,%r13d
  805a70:	49 89 f6             	mov    %rsi,%r14
  805a73:	49 89 d4             	mov    %rdx,%r12
    int inc = 1, res = 0;
  805a76:	bb 00 00 00 00       	mov    $0x0,%ebx
    for (; inc && res < n; res += inc) {
  805a7b:	be 00 00 00 00       	mov    $0x0,%esi
        inc = read(fdnum, (char *)buf + res, n - res);
  805a80:	49 bf 91 59 80 00 00 	movabs $0x805991,%r15
  805a87:	00 00 00 
  805a8a:	4c 89 e2             	mov    %r12,%rdx
  805a8d:	48 29 f2             	sub    %rsi,%rdx
  805a90:	4c 01 f6             	add    %r14,%rsi
  805a93:	44 89 ef             	mov    %r13d,%edi
  805a96:	41 ff d7             	call   *%r15
        if (inc < 0) return inc;
  805a99:	85 c0                	test   %eax,%eax
  805a9b:	78 20                	js     805abd <readn+0x6a>
    for (; inc && res < n; res += inc) {
  805a9d:	01 c3                	add    %eax,%ebx
  805a9f:	85 c0                	test   %eax,%eax
  805aa1:	74 08                	je     805aab <readn+0x58>
  805aa3:	48 63 f3             	movslq %ebx,%rsi
  805aa6:	4c 39 e6             	cmp    %r12,%rsi
  805aa9:	72 df                	jb     805a8a <readn+0x37>
    }
    return res;
  805aab:	48 63 c3             	movslq %ebx,%rax
}
  805aae:	48 83 c4 08          	add    $0x8,%rsp
  805ab2:	5b                   	pop    %rbx
  805ab3:	41 5c                	pop    %r12
  805ab5:	41 5d                	pop    %r13
  805ab7:	41 5e                	pop    %r14
  805ab9:	41 5f                	pop    %r15
  805abb:	5d                   	pop    %rbp
  805abc:	c3                   	ret
        if (inc < 0) return inc;
  805abd:	48 98                	cltq
  805abf:	eb ed                	jmp    805aae <readn+0x5b>
    int inc = 1, res = 0;
  805ac1:	bb 00 00 00 00       	mov    $0x0,%ebx
  805ac6:	eb e3                	jmp    805aab <readn+0x58>

0000000000805ac8 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n) {
  805ac8:	f3 0f 1e fa          	endbr64
  805acc:	55                   	push   %rbp
  805acd:	48 89 e5             	mov    %rsp,%rbp
  805ad0:	41 56                	push   %r14
  805ad2:	41 55                	push   %r13
  805ad4:	41 54                	push   %r12
  805ad6:	53                   	push   %rbx
  805ad7:	48 83 ec 10          	sub    $0x10,%rsp
  805adb:	89 fb                	mov    %edi,%ebx
  805add:	49 89 f4             	mov    %rsi,%r12
  805ae0:	49 89 d5             	mov    %rdx,%r13
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  805ae3:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  805ae7:	48 b8 96 56 80 00 00 	movabs $0x805696,%rax
  805aee:	00 00 00 
  805af1:	ff d0                	call   *%rax
  805af3:	85 c0                	test   %eax,%eax
  805af5:	78 47                	js     805b3e <write+0x76>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  805af7:	4c 8b 75 d8          	mov    -0x28(%rbp),%r14
  805afb:	41 8b 3e             	mov    (%r14),%edi
  805afe:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  805b02:	48 b8 e5 56 80 00 00 	movabs $0x8056e5,%rax
  805b09:	00 00 00 
  805b0c:	ff d0                	call   *%rax
  805b0e:	85 c0                	test   %eax,%eax
  805b10:	78 30                	js     805b42 <write+0x7a>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  805b12:	41 f6 46 08 03       	testb  $0x3,0x8(%r14)
  805b17:	74 2d                	je     805b46 <write+0x7e>
    if (debug) {
        cprintf("write %d %p %lu via dev %s\n",
                fdnum, buf, (unsigned long)n, dev->dev_name);
    }

    if (!dev->dev_write) return -E_NOT_SUPP;
  805b19:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805b1d:	48 8b 40 18          	mov    0x18(%rax),%rax
  805b21:	48 85 c0             	test   %rax,%rax
  805b24:	74 56                	je     805b7c <write+0xb4>

    return (*dev->dev_write)(fd, buf, n);
  805b26:	4c 89 ea             	mov    %r13,%rdx
  805b29:	4c 89 e6             	mov    %r12,%rsi
  805b2c:	4c 89 f7             	mov    %r14,%rdi
  805b2f:	ff d0                	call   *%rax
}
  805b31:	48 83 c4 10          	add    $0x10,%rsp
  805b35:	5b                   	pop    %rbx
  805b36:	41 5c                	pop    %r12
  805b38:	41 5d                	pop    %r13
  805b3a:	41 5e                	pop    %r14
  805b3c:	5d                   	pop    %rbp
  805b3d:	c3                   	ret
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  805b3e:	48 98                	cltq
  805b40:	eb ef                	jmp    805b31 <write+0x69>
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  805b42:	48 98                	cltq
  805b44:	eb eb                	jmp    805b31 <write+0x69>
        cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  805b46:	48 a1 88 d6 80 00 00 	movabs 0x80d688,%rax
  805b4d:	00 00 00 
  805b50:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
  805b56:	89 da                	mov    %ebx,%edx
  805b58:	48 bf 99 79 80 00 00 	movabs $0x807999,%rdi
  805b5f:	00 00 00 
  805b62:	b8 00 00 00 00       	mov    $0x0,%eax
  805b67:	48 b9 1d 3e 80 00 00 	movabs $0x803e1d,%rcx
  805b6e:	00 00 00 
  805b71:	ff d1                	call   *%rcx
        return -E_INVAL;
  805b73:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
  805b7a:	eb b5                	jmp    805b31 <write+0x69>
    if (!dev->dev_write) return -E_NOT_SUPP;
  805b7c:	48 c7 c0 ed ff ff ff 	mov    $0xffffffffffffffed,%rax
  805b83:	eb ac                	jmp    805b31 <write+0x69>

0000000000805b85 <seek>:

int
seek(int fdnum, off_t offset) {
  805b85:	f3 0f 1e fa          	endbr64
  805b89:	55                   	push   %rbp
  805b8a:	48 89 e5             	mov    %rsp,%rbp
  805b8d:	53                   	push   %rbx
  805b8e:	48 83 ec 18          	sub    $0x18,%rsp
  805b92:	89 f3                	mov    %esi,%ebx
    int res;
    struct Fd *fd;

    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  805b94:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  805b98:	48 b8 96 56 80 00 00 	movabs $0x805696,%rax
  805b9f:	00 00 00 
  805ba2:	ff d0                	call   *%rax
  805ba4:	85 c0                	test   %eax,%eax
  805ba6:	78 0c                	js     805bb4 <seek+0x2f>

    fd->fd_offset = offset;
  805ba8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805bac:	89 58 04             	mov    %ebx,0x4(%rax)
    return 0;
  805baf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805bb4:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  805bb8:	c9                   	leave
  805bb9:	c3                   	ret

0000000000805bba <ftruncate>:

int
ftruncate(int fdnum, off_t newsize) {
  805bba:	f3 0f 1e fa          	endbr64
  805bbe:	55                   	push   %rbp
  805bbf:	48 89 e5             	mov    %rsp,%rbp
  805bc2:	41 55                	push   %r13
  805bc4:	41 54                	push   %r12
  805bc6:	53                   	push   %rbx
  805bc7:	48 83 ec 18          	sub    $0x18,%rsp
  805bcb:	89 fb                	mov    %edi,%ebx
  805bcd:	41 89 f4             	mov    %esi,%r12d
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  805bd0:	48 8d 75 d8          	lea    -0x28(%rbp),%rsi
  805bd4:	48 b8 96 56 80 00 00 	movabs $0x805696,%rax
  805bdb:	00 00 00 
  805bde:	ff d0                	call   *%rax
  805be0:	85 c0                	test   %eax,%eax
  805be2:	78 38                	js     805c1c <ftruncate+0x62>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  805be4:	4c 8b 6d d8          	mov    -0x28(%rbp),%r13
  805be8:	41 8b 7d 00          	mov    0x0(%r13),%edi
  805bec:	48 8d 75 d0          	lea    -0x30(%rbp),%rsi
  805bf0:	48 b8 e5 56 80 00 00 	movabs $0x8056e5,%rax
  805bf7:	00 00 00 
  805bfa:	ff d0                	call   *%rax
  805bfc:	85 c0                	test   %eax,%eax
  805bfe:	78 1c                	js     805c1c <ftruncate+0x62>

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  805c00:	41 f6 45 08 03       	testb  $0x3,0x8(%r13)
  805c05:	74 20                	je     805c27 <ftruncate+0x6d>
        cprintf("[%08x] ftruncate %d -- bad mode\n",
                thisenv->env_id, fdnum);
        return -E_INVAL;
    }

    if (!dev->dev_trunc) return -E_NOT_SUPP;
  805c07:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805c0b:	48 8b 40 30          	mov    0x30(%rax),%rax
  805c0f:	48 85 c0             	test   %rax,%rax
  805c12:	74 47                	je     805c5b <ftruncate+0xa1>

    return (*dev->dev_trunc)(fd, newsize);
  805c14:	44 89 e6             	mov    %r12d,%esi
  805c17:	4c 89 ef             	mov    %r13,%rdi
  805c1a:	ff d0                	call   *%rax
}
  805c1c:	48 83 c4 18          	add    $0x18,%rsp
  805c20:	5b                   	pop    %rbx
  805c21:	41 5c                	pop    %r12
  805c23:	41 5d                	pop    %r13
  805c25:	5d                   	pop    %rbp
  805c26:	c3                   	ret
                thisenv->env_id, fdnum);
  805c27:	48 a1 88 d6 80 00 00 	movabs 0x80d688,%rax
  805c2e:	00 00 00 
  805c31:	8b b0 c8 00 00 00    	mov    0xc8(%rax),%esi
        cprintf("[%08x] ftruncate %d -- bad mode\n",
  805c37:	89 da                	mov    %ebx,%edx
  805c39:	48 bf 20 73 80 00 00 	movabs $0x807320,%rdi
  805c40:	00 00 00 
  805c43:	b8 00 00 00 00       	mov    $0x0,%eax
  805c48:	48 b9 1d 3e 80 00 00 	movabs $0x803e1d,%rcx
  805c4f:	00 00 00 
  805c52:	ff d1                	call   *%rcx
        return -E_INVAL;
  805c54:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  805c59:	eb c1                	jmp    805c1c <ftruncate+0x62>
    if (!dev->dev_trunc) return -E_NOT_SUPP;
  805c5b:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  805c60:	eb ba                	jmp    805c1c <ftruncate+0x62>

0000000000805c62 <fstat>:

int
fstat(int fdnum, struct Stat *stat) {
  805c62:	f3 0f 1e fa          	endbr64
  805c66:	55                   	push   %rbp
  805c67:	48 89 e5             	mov    %rsp,%rbp
  805c6a:	41 54                	push   %r12
  805c6c:	53                   	push   %rbx
  805c6d:	48 83 ec 10          	sub    $0x10,%rsp
  805c71:	48 89 f3             	mov    %rsi,%rbx
    int res;

    struct Fd *fd;
    if ((res = fd_lookup(fdnum, &fd)) < 0) return res;
  805c74:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  805c78:	48 b8 96 56 80 00 00 	movabs $0x805696,%rax
  805c7f:	00 00 00 
  805c82:	ff d0                	call   *%rax
  805c84:	85 c0                	test   %eax,%eax
  805c86:	78 4e                	js     805cd6 <fstat+0x74>

    struct Dev *dev;
    if ((res = dev_lookup(fd->fd_dev_id, &dev)) < 0) return res;
  805c88:	4c 8b 65 e8          	mov    -0x18(%rbp),%r12
  805c8c:	41 8b 3c 24          	mov    (%r12),%edi
  805c90:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
  805c94:	48 b8 e5 56 80 00 00 	movabs $0x8056e5,%rax
  805c9b:	00 00 00 
  805c9e:	ff d0                	call   *%rax
  805ca0:	85 c0                	test   %eax,%eax
  805ca2:	78 32                	js     805cd6 <fstat+0x74>

    if (!dev->dev_stat) return -E_NOT_SUPP;
  805ca4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805ca8:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  805cad:	74 30                	je     805cdf <fstat+0x7d>

    stat->st_name[0] = 0;
  805caf:	c6 03 00             	movb   $0x0,(%rbx)
    stat->st_size = 0;
  805cb2:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%rbx)
  805cb9:	00 00 00 
    stat->st_isdir = 0;
  805cbc:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  805cc3:	00 00 00 
    stat->st_dev = dev;
  805cc6:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)

    return (*dev->dev_stat)(fd, stat);
  805ccd:	48 89 de             	mov    %rbx,%rsi
  805cd0:	4c 89 e7             	mov    %r12,%rdi
  805cd3:	ff 50 28             	call   *0x28(%rax)
}
  805cd6:	48 83 c4 10          	add    $0x10,%rsp
  805cda:	5b                   	pop    %rbx
  805cdb:	41 5c                	pop    %r12
  805cdd:	5d                   	pop    %rbp
  805cde:	c3                   	ret
    if (!dev->dev_stat) return -E_NOT_SUPP;
  805cdf:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  805ce4:	eb f0                	jmp    805cd6 <fstat+0x74>

0000000000805ce6 <stat>:

int
stat(const char *path, struct Stat *stat) {
  805ce6:	f3 0f 1e fa          	endbr64
  805cea:	55                   	push   %rbp
  805ceb:	48 89 e5             	mov    %rsp,%rbp
  805cee:	41 54                	push   %r12
  805cf0:	53                   	push   %rbx
  805cf1:	49 89 f4             	mov    %rsi,%r12
    int fd = open(path, O_RDONLY);
  805cf4:	be 00 00 00 00       	mov    $0x0,%esi
  805cf9:	48 b8 c7 5f 80 00 00 	movabs $0x805fc7,%rax
  805d00:	00 00 00 
  805d03:	ff d0                	call   *%rax
  805d05:	89 c3                	mov    %eax,%ebx
    if (fd < 0) return fd;
  805d07:	85 c0                	test   %eax,%eax
  805d09:	78 25                	js     805d30 <stat+0x4a>

    int res = fstat(fd, stat);
  805d0b:	4c 89 e6             	mov    %r12,%rsi
  805d0e:	89 c7                	mov    %eax,%edi
  805d10:	48 b8 62 5c 80 00 00 	movabs $0x805c62,%rax
  805d17:	00 00 00 
  805d1a:	ff d0                	call   *%rax
  805d1c:	41 89 c4             	mov    %eax,%r12d
    close(fd);
  805d1f:	89 df                	mov    %ebx,%edi
  805d21:	48 b8 07 58 80 00 00 	movabs $0x805807,%rax
  805d28:	00 00 00 
  805d2b:	ff d0                	call   *%rax

    return res;
  805d2d:	44 89 e3             	mov    %r12d,%ebx
}
  805d30:	89 d8                	mov    %ebx,%eax
  805d32:	5b                   	pop    %rbx
  805d33:	41 5c                	pop    %r12
  805d35:	5d                   	pop    %rbp
  805d36:	c3                   	ret

0000000000805d37 <fsipc>:
 * response may be written back to fsipcbuf.
 * type: request code, passed as the simple integer IPC value.
 * dstva: virtual address at which to receive reply page, 0 if none.
 * Returns result from the file server. */
static int
fsipc(unsigned type, void *dstva) {
  805d37:	f3 0f 1e fa          	endbr64
  805d3b:	55                   	push   %rbp
  805d3c:	48 89 e5             	mov    %rsp,%rbp
  805d3f:	41 54                	push   %r12
  805d41:	53                   	push   %rbx
  805d42:	48 83 ec 10          	sub    $0x10,%rsp
  805d46:	41 89 fc             	mov    %edi,%r12d
  805d49:	48 89 f3             	mov    %rsi,%rbx
    static envid_t fsenv;

    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  805d4c:	48 b8 00 f0 80 00 00 	movabs $0x80f000,%rax
  805d53:	00 00 00 
  805d56:	83 38 00             	cmpl   $0x0,(%rax)
  805d59:	74 6e                	je     805dc9 <fsipc+0x92>

    if (debug) {
        cprintf("[%08x] fsipc %d %08x\n",
                thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
    }
    fsenv = ipc_find_env(ENV_TYPE_FS);
  805d5b:	bf 03 00 00 00       	mov    $0x3,%edi
  805d60:	48 b8 9e 55 80 00 00 	movabs $0x80559e,%rax
  805d67:	00 00 00 
  805d6a:	ff d0                	call   *%rax
  805d6c:	a3 00 f0 80 00 00 00 	movabs %eax,0x80f000
  805d73:	00 00 
    ipc_send(fsenv, type, &fsipcbuf, PAGE_SIZE, PROT_RW);
  805d75:	41 b8 06 00 00 00    	mov    $0x6,%r8d
  805d7b:	b9 00 10 00 00       	mov    $0x1000,%ecx
  805d80:	48 ba 00 e0 80 00 00 	movabs $0x80e000,%rdx
  805d87:	00 00 00 
  805d8a:	44 89 e6             	mov    %r12d,%esi
  805d8d:	89 c7                	mov    %eax,%edi
  805d8f:	48 b8 dc 54 80 00 00 	movabs $0x8054dc,%rax
  805d96:	00 00 00 
  805d99:	ff d0                	call   *%rax
    size_t maxsz = PAGE_SIZE;
  805d9b:	48 c7 45 e8 00 10 00 	movq   $0x1000,-0x18(%rbp)
  805da2:	00 
    return ipc_recv(NULL, dstva, &maxsz, NULL);
  805da3:	b9 00 00 00 00       	mov    $0x0,%ecx
  805da8:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  805dac:	48 89 de             	mov    %rbx,%rsi
  805daf:	bf 00 00 00 00       	mov    $0x0,%edi
  805db4:	48 b8 43 54 80 00 00 	movabs $0x805443,%rax
  805dbb:	00 00 00 
  805dbe:	ff d0                	call   *%rax
}
  805dc0:	48 83 c4 10          	add    $0x10,%rsp
  805dc4:	5b                   	pop    %rbx
  805dc5:	41 5c                	pop    %r12
  805dc7:	5d                   	pop    %rbp
  805dc8:	c3                   	ret
    if (!fsenv) fsenv = ipc_find_env(ENV_TYPE_FS);
  805dc9:	bf 03 00 00 00       	mov    $0x3,%edi
  805dce:	48 b8 9e 55 80 00 00 	movabs $0x80559e,%rax
  805dd5:	00 00 00 
  805dd8:	ff d0                	call   *%rax
  805dda:	a3 00 f0 80 00 00 00 	movabs %eax,0x80f000
  805de1:	00 00 
  805de3:	e9 73 ff ff ff       	jmp    805d5b <fsipc+0x24>

0000000000805de8 <devfile_trunc>:
    return 0;
}

/* Truncate or extend an open file to 'size' bytes */
static int
devfile_trunc(struct Fd *fd, off_t newsize) {
  805de8:	f3 0f 1e fa          	endbr64
  805dec:	55                   	push   %rbp
  805ded:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  805df0:	48 b8 00 e0 80 00 00 	movabs $0x80e000,%rax
  805df7:	00 00 00 
  805dfa:	8b 57 0c             	mov    0xc(%rdi),%edx
  805dfd:	89 10                	mov    %edx,(%rax)
    fsipcbuf.set_size.req_size = newsize;
  805dff:	89 70 04             	mov    %esi,0x4(%rax)

    return fsipc(FSREQ_SET_SIZE, NULL);
  805e02:	be 00 00 00 00       	mov    $0x0,%esi
  805e07:	bf 02 00 00 00       	mov    $0x2,%edi
  805e0c:	48 b8 37 5d 80 00 00 	movabs $0x805d37,%rax
  805e13:	00 00 00 
  805e16:	ff d0                	call   *%rax
}
  805e18:	5d                   	pop    %rbp
  805e19:	c3                   	ret

0000000000805e1a <devfile_flush>:
devfile_flush(struct Fd *fd) {
  805e1a:	f3 0f 1e fa          	endbr64
  805e1e:	55                   	push   %rbp
  805e1f:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.flush.req_fileid = fd->fd_file.id;
  805e22:	8b 47 0c             	mov    0xc(%rdi),%eax
  805e25:	a3 00 e0 80 00 00 00 	movabs %eax,0x80e000
  805e2c:	00 00 
    return fsipc(FSREQ_FLUSH, NULL);
  805e2e:	be 00 00 00 00       	mov    $0x0,%esi
  805e33:	bf 06 00 00 00       	mov    $0x6,%edi
  805e38:	48 b8 37 5d 80 00 00 	movabs $0x805d37,%rax
  805e3f:	00 00 00 
  805e42:	ff d0                	call   *%rax
}
  805e44:	5d                   	pop    %rbp
  805e45:	c3                   	ret

0000000000805e46 <devfile_stat>:
devfile_stat(struct Fd *fd, struct Stat *st) {
  805e46:	f3 0f 1e fa          	endbr64
  805e4a:	55                   	push   %rbp
  805e4b:	48 89 e5             	mov    %rsp,%rbp
  805e4e:	41 54                	push   %r12
  805e50:	53                   	push   %rbx
  805e51:	48 89 f3             	mov    %rsi,%rbx
    fsipcbuf.stat.req_fileid = fd->fd_file.id;
  805e54:	8b 47 0c             	mov    0xc(%rdi),%eax
  805e57:	a3 00 e0 80 00 00 00 	movabs %eax,0x80e000
  805e5e:	00 00 
    int res = fsipc(FSREQ_STAT, NULL);
  805e60:	be 00 00 00 00       	mov    $0x0,%esi
  805e65:	bf 05 00 00 00       	mov    $0x5,%edi
  805e6a:	48 b8 37 5d 80 00 00 	movabs $0x805d37,%rax
  805e71:	00 00 00 
  805e74:	ff d0                	call   *%rax
    if (res < 0) return res;
  805e76:	85 c0                	test   %eax,%eax
  805e78:	78 3d                	js     805eb7 <devfile_stat+0x71>
    strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  805e7a:	49 bc 00 e0 80 00 00 	movabs $0x80e000,%r12
  805e81:	00 00 00 
  805e84:	4c 89 e6             	mov    %r12,%rsi
  805e87:	48 89 df             	mov    %rbx,%rdi
  805e8a:	48 b8 66 47 80 00 00 	movabs $0x804766,%rax
  805e91:	00 00 00 
  805e94:	ff d0                	call   *%rax
    st->st_size = fsipcbuf.statRet.ret_size;
  805e96:	41 8b 84 24 80 00 00 	mov    0x80(%r12),%eax
  805e9d:	00 
  805e9e:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    st->st_isdir = fsipcbuf.statRet.ret_isdir;
  805ea4:	41 8b 84 24 84 00 00 	mov    0x84(%r12),%eax
  805eab:	00 
  805eac:	89 83 84 00 00 00    	mov    %eax,0x84(%rbx)
    return 0;
  805eb2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805eb7:	5b                   	pop    %rbx
  805eb8:	41 5c                	pop    %r12
  805eba:	5d                   	pop    %rbp
  805ebb:	c3                   	ret

0000000000805ebc <devfile_write>:
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  805ebc:	f3 0f 1e fa          	endbr64
    if (n >= sizeof(fsipcbuf.write.req_buf)) {
  805ec0:	48 81 fa ef 0f 00 00 	cmp    $0xfef,%rdx
  805ec7:	77 41                	ja     805f0a <devfile_write+0x4e>
devfile_write(struct Fd *fd, const void *buf, size_t n) {
  805ec9:	55                   	push   %rbp
  805eca:	48 89 e5             	mov    %rsp,%rbp
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  805ecd:	48 b8 00 e0 80 00 00 	movabs $0x80e000,%rax
  805ed4:	00 00 00 
  805ed7:	8b 4f 0c             	mov    0xc(%rdi),%ecx
  805eda:	89 08                	mov    %ecx,(%rax)
    fsipcbuf.write.req_n = n;
  805edc:	48 89 50 08          	mov    %rdx,0x8(%rax)
    memmove(fsipcbuf.write.req_buf, buf, n);
  805ee0:	48 8d 78 10          	lea    0x10(%rax),%rdi
  805ee4:	48 b8 81 49 80 00 00 	movabs $0x804981,%rax
  805eeb:	00 00 00 
  805eee:	ff d0                	call   *%rax
    res = fsipc(FSREQ_WRITE, NULL);
  805ef0:	be 00 00 00 00       	mov    $0x0,%esi
  805ef5:	bf 04 00 00 00       	mov    $0x4,%edi
  805efa:	48 b8 37 5d 80 00 00 	movabs $0x805d37,%rax
  805f01:	00 00 00 
  805f04:	ff d0                	call   *%rax
  805f06:	48 98                	cltq
}
  805f08:	5d                   	pop    %rbp
  805f09:	c3                   	ret
        return -E_INVAL;
  805f0a:	48 c7 c0 fd ff ff ff 	mov    $0xfffffffffffffffd,%rax
}
  805f11:	c3                   	ret

0000000000805f12 <devfile_read>:
devfile_read(struct Fd *fd, void *buf, size_t n) {
  805f12:	f3 0f 1e fa          	endbr64
  805f16:	55                   	push   %rbp
  805f17:	48 89 e5             	mov    %rsp,%rbp
  805f1a:	41 55                	push   %r13
  805f1c:	41 54                	push   %r12
  805f1e:	53                   	push   %rbx
  805f1f:	48 83 ec 08          	sub    $0x8,%rsp
  805f23:	49 89 f4             	mov    %rsi,%r12
  805f26:	48 89 d3             	mov    %rdx,%rbx
    fsipcbuf.read.req_fileid = fd->fd_file.id;
  805f29:	48 b8 00 e0 80 00 00 	movabs $0x80e000,%rax
  805f30:	00 00 00 
  805f33:	8b 57 0c             	mov    0xc(%rdi),%edx
  805f36:	89 10                	mov    %edx,(%rax)
    fsipcbuf.read.req_n = n;
  805f38:	48 89 58 08          	mov    %rbx,0x8(%rax)
    res = fsipc(FSREQ_READ, NULL);
  805f3c:	be 00 00 00 00       	mov    $0x0,%esi
  805f41:	bf 03 00 00 00       	mov    $0x3,%edi
  805f46:	48 b8 37 5d 80 00 00 	movabs $0x805d37,%rax
  805f4d:	00 00 00 
  805f50:	ff d0                	call   *%rax
  805f52:	4c 63 e8             	movslq %eax,%r13
    if (res < 0) {
  805f55:	4d 85 ed             	test   %r13,%r13
  805f58:	78 2a                	js     805f84 <devfile_read+0x72>
    assert(res <= n && res <= PAGE_SIZE);
  805f5a:	4c 89 ea             	mov    %r13,%rdx
  805f5d:	4c 39 eb             	cmp    %r13,%rbx
  805f60:	72 30                	jb     805f92 <devfile_read+0x80>
  805f62:	49 81 fd 00 10 00 00 	cmp    $0x1000,%r13
  805f69:	7f 27                	jg     805f92 <devfile_read+0x80>
    memmove(buf, &fsipcbuf, res);
  805f6b:	48 be 00 e0 80 00 00 	movabs $0x80e000,%rsi
  805f72:	00 00 00 
  805f75:	4c 89 e7             	mov    %r12,%rdi
  805f78:	48 b8 81 49 80 00 00 	movabs $0x804981,%rax
  805f7f:	00 00 00 
  805f82:	ff d0                	call   *%rax
}
  805f84:	4c 89 e8             	mov    %r13,%rax
  805f87:	48 83 c4 08          	add    $0x8,%rsp
  805f8b:	5b                   	pop    %rbx
  805f8c:	41 5c                	pop    %r12
  805f8e:	41 5d                	pop    %r13
  805f90:	5d                   	pop    %rbp
  805f91:	c3                   	ret
    assert(res <= n && res <= PAGE_SIZE);
  805f92:	48 b9 b6 79 80 00 00 	movabs $0x8079b6,%rcx
  805f99:	00 00 00 
  805f9c:	48 ba 94 73 80 00 00 	movabs $0x807394,%rdx
  805fa3:	00 00 00 
  805fa6:	be 7b 00 00 00       	mov    $0x7b,%esi
  805fab:	48 bf d3 79 80 00 00 	movabs $0x8079d3,%rdi
  805fb2:	00 00 00 
  805fb5:	b8 00 00 00 00       	mov    $0x0,%eax
  805fba:	49 b8 c1 3c 80 00 00 	movabs $0x803cc1,%r8
  805fc1:	00 00 00 
  805fc4:	41 ff d0             	call   *%r8

0000000000805fc7 <open>:
open(const char *path, int mode) {
  805fc7:	f3 0f 1e fa          	endbr64
  805fcb:	55                   	push   %rbp
  805fcc:	48 89 e5             	mov    %rsp,%rbp
  805fcf:	41 55                	push   %r13
  805fd1:	41 54                	push   %r12
  805fd3:	53                   	push   %rbx
  805fd4:	48 83 ec 18          	sub    $0x18,%rsp
  805fd8:	49 89 fc             	mov    %rdi,%r12
  805fdb:	41 89 f5             	mov    %esi,%r13d
    if (strlen(path) >= MAXPATHLEN)
  805fde:	48 b8 21 47 80 00 00 	movabs $0x804721,%rax
  805fe5:	00 00 00 
  805fe8:	ff d0                	call   *%rax
  805fea:	48 3d ff 03 00 00    	cmp    $0x3ff,%rax
  805ff0:	0f 87 8a 00 00 00    	ja     806080 <open+0xb9>
    if ((res = fd_alloc(&fd)) < 0) return res;
  805ff6:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  805ffa:	48 b8 32 56 80 00 00 	movabs $0x805632,%rax
  806001:	00 00 00 
  806004:	ff d0                	call   *%rax
  806006:	89 c3                	mov    %eax,%ebx
  806008:	85 c0                	test   %eax,%eax
  80600a:	78 50                	js     80605c <open+0x95>
    strcpy(fsipcbuf.open.req_path, path);
  80600c:	4c 89 e6             	mov    %r12,%rsi
  80600f:	48 bb 00 e0 80 00 00 	movabs $0x80e000,%rbx
  806016:	00 00 00 
  806019:	48 89 df             	mov    %rbx,%rdi
  80601c:	48 b8 66 47 80 00 00 	movabs $0x804766,%rax
  806023:	00 00 00 
  806026:	ff d0                	call   *%rax
    fsipcbuf.open.req_omode = mode;
  806028:	44 89 ab 00 04 00 00 	mov    %r13d,0x400(%rbx)
    if ((res = fsipc(FSREQ_OPEN, fd)) < 0) {
  80602f:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  806033:	bf 01 00 00 00       	mov    $0x1,%edi
  806038:	48 b8 37 5d 80 00 00 	movabs $0x805d37,%rax
  80603f:	00 00 00 
  806042:	ff d0                	call   *%rax
  806044:	89 c3                	mov    %eax,%ebx
  806046:	85 c0                	test   %eax,%eax
  806048:	78 1f                	js     806069 <open+0xa2>
    return fd2num(fd);
  80604a:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  80604e:	48 b8 fc 55 80 00 00 	movabs $0x8055fc,%rax
  806055:	00 00 00 
  806058:	ff d0                	call   *%rax
  80605a:	89 c3                	mov    %eax,%ebx
}
  80605c:	89 d8                	mov    %ebx,%eax
  80605e:	48 83 c4 18          	add    $0x18,%rsp
  806062:	5b                   	pop    %rbx
  806063:	41 5c                	pop    %r12
  806065:	41 5d                	pop    %r13
  806067:	5d                   	pop    %rbp
  806068:	c3                   	ret
        fd_close(fd, 0);
  806069:	be 00 00 00 00       	mov    $0x0,%esi
  80606e:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  806072:	48 b8 59 57 80 00 00 	movabs $0x805759,%rax
  806079:	00 00 00 
  80607c:	ff d0                	call   *%rax
        return res;
  80607e:	eb dc                	jmp    80605c <open+0x95>
        return -E_BAD_PATH;
  806080:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
  806085:	eb d5                	jmp    80605c <open+0x95>

0000000000806087 <sync>:

/* Synchronize disk with buffer cache */
int
sync(void) {
  806087:	f3 0f 1e fa          	endbr64
  80608b:	55                   	push   %rbp
  80608c:	48 89 e5             	mov    %rsp,%rbp
    /* Ask the file server to update the disk
     * by writing any dirty blocks in the buffer cache. */

    return fsipc(FSREQ_SYNC, NULL);
  80608f:	be 00 00 00 00       	mov    $0x0,%esi
  806094:	bf 08 00 00 00       	mov    $0x8,%edi
  806099:	48 b8 37 5d 80 00 00 	movabs $0x805d37,%rax
  8060a0:	00 00 00 
  8060a3:	ff d0                	call   *%rax
}
  8060a5:	5d                   	pop    %rbp
  8060a6:	c3                   	ret

00000000008060a7 <devpipe_stat>:

    return n;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat) {
  8060a7:	f3 0f 1e fa          	endbr64
  8060ab:	55                   	push   %rbp
  8060ac:	48 89 e5             	mov    %rsp,%rbp
  8060af:	41 54                	push   %r12
  8060b1:	53                   	push   %rbx
  8060b2:	48 89 f3             	mov    %rsi,%rbx
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  8060b5:	48 b8 12 56 80 00 00 	movabs $0x805612,%rax
  8060bc:	00 00 00 
  8060bf:	ff d0                	call   *%rax
  8060c1:	49 89 c4             	mov    %rax,%r12
    strcpy(stat->st_name, "<pipe>");
  8060c4:	48 be de 79 80 00 00 	movabs $0x8079de,%rsi
  8060cb:	00 00 00 
  8060ce:	48 89 df             	mov    %rbx,%rdi
  8060d1:	48 b8 66 47 80 00 00 	movabs $0x804766,%rax
  8060d8:	00 00 00 
  8060db:	ff d0                	call   *%rax
    stat->st_size = p->p_wpos - p->p_rpos;
  8060dd:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  8060e2:	41 2b 04 24          	sub    (%r12),%eax
  8060e6:	89 83 80 00 00 00    	mov    %eax,0x80(%rbx)
    stat->st_isdir = 0;
  8060ec:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%rbx)
  8060f3:	00 00 00 
    stat->st_dev = &devpipe;
  8060f6:	48 b8 c0 c0 80 00 00 	movabs $0x80c0c0,%rax
  8060fd:	00 00 00 
  806100:	48 89 83 88 00 00 00 	mov    %rax,0x88(%rbx)
    return 0;
}
  806107:	b8 00 00 00 00       	mov    $0x0,%eax
  80610c:	5b                   	pop    %rbx
  80610d:	41 5c                	pop    %r12
  80610f:	5d                   	pop    %rbp
  806110:	c3                   	ret

0000000000806111 <devpipe_close>:

static int
devpipe_close(struct Fd *fd) {
  806111:	f3 0f 1e fa          	endbr64
  806115:	55                   	push   %rbp
  806116:	48 89 e5             	mov    %rsp,%rbp
  806119:	41 54                	push   %r12
  80611b:	53                   	push   %rbx
  80611c:	48 89 fb             	mov    %rdi,%rbx
    USED(sys_unmap_region(0, fd, PAGE_SIZE));
  80611f:	ba 00 10 00 00       	mov    $0x1000,%edx
  806124:	48 89 fe             	mov    %rdi,%rsi
  806127:	bf 00 00 00 00       	mov    $0x0,%edi
  80612c:	49 bc ab 4e 80 00 00 	movabs $0x804eab,%r12
  806133:	00 00 00 
  806136:	41 ff d4             	call   *%r12
    return sys_unmap_region(0, fd2data(fd), PAGE_SIZE);
  806139:	48 89 df             	mov    %rbx,%rdi
  80613c:	48 b8 12 56 80 00 00 	movabs $0x805612,%rax
  806143:	00 00 00 
  806146:	ff d0                	call   *%rax
  806148:	48 89 c6             	mov    %rax,%rsi
  80614b:	ba 00 10 00 00       	mov    $0x1000,%edx
  806150:	bf 00 00 00 00       	mov    $0x0,%edi
  806155:	41 ff d4             	call   *%r12
}
  806158:	5b                   	pop    %rbx
  806159:	41 5c                	pop    %r12
  80615b:	5d                   	pop    %rbp
  80615c:	c3                   	ret

000000000080615d <devpipe_write>:
devpipe_write(struct Fd *fd, const void *vbuf, size_t n) {
  80615d:	f3 0f 1e fa          	endbr64
  806161:	55                   	push   %rbp
  806162:	48 89 e5             	mov    %rsp,%rbp
  806165:	41 57                	push   %r15
  806167:	41 56                	push   %r14
  806169:	41 55                	push   %r13
  80616b:	41 54                	push   %r12
  80616d:	53                   	push   %rbx
  80616e:	48 83 ec 18          	sub    $0x18,%rsp
  806172:	49 89 fc             	mov    %rdi,%r12
  806175:	49 89 f5             	mov    %rsi,%r13
  806178:	49 89 d7             	mov    %rdx,%r15
  80617b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  80617f:	48 b8 12 56 80 00 00 	movabs $0x805612,%rax
  806186:	00 00 00 
  806189:	ff d0                	call   *%rax
    for (size_t i = 0; i < n; i++) {
  80618b:	4d 85 ff             	test   %r15,%r15
  80618e:	0f 84 af 00 00 00    	je     806243 <devpipe_write+0xe6>
  806194:	48 89 c3             	mov    %rax,%rbx
  806197:	4c 89 f8             	mov    %r15,%rax
  80619a:	4d 89 ef             	mov    %r13,%r15
  80619d:	4c 01 e8             	add    %r13,%rax
  8061a0:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8061a4:	49 bd 3b 4d 80 00 00 	movabs $0x804d3b,%r13
  8061ab:	00 00 00 
            sys_yield();
  8061ae:	49 be d0 4c 80 00 00 	movabs $0x804cd0,%r14
  8061b5:	00 00 00 
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8061b8:	8b 73 04             	mov    0x4(%rbx),%esi
  8061bb:	48 63 ce             	movslq %esi,%rcx
  8061be:	48 63 03             	movslq (%rbx),%rax
  8061c1:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8061c7:	48 39 c1             	cmp    %rax,%rcx
  8061ca:	72 2e                	jb     8061fa <devpipe_write+0x9d>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8061cc:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8061d1:	48 89 da             	mov    %rbx,%rdx
  8061d4:	be 00 10 00 00       	mov    $0x1000,%esi
  8061d9:	4c 89 e7             	mov    %r12,%rdi
  8061dc:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8061df:	85 c0                	test   %eax,%eax
  8061e1:	74 66                	je     806249 <devpipe_write+0xec>
            sys_yield();
  8061e3:	41 ff d6             	call   *%r14
        while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) /* pipe is full */ {
  8061e6:	8b 73 04             	mov    0x4(%rbx),%esi
  8061e9:	48 63 ce             	movslq %esi,%rcx
  8061ec:	48 63 03             	movslq (%rbx),%rax
  8061ef:	48 05 f8 0f 00 00    	add    $0xff8,%rax
  8061f5:	48 39 c1             	cmp    %rax,%rcx
  8061f8:	73 d2                	jae    8061cc <devpipe_write+0x6f>
        p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8061fa:	41 0f b6 3f          	movzbl (%r15),%edi
  8061fe:	48 89 ca             	mov    %rcx,%rdx
  806201:	48 c1 ea 03          	shr    $0x3,%rdx
  806205:	48 b8 81 00 01 02 04 	movabs $0x2010080402010081,%rax
  80620c:	08 10 20 
  80620f:	48 f7 e2             	mul    %rdx
  806212:	48 c1 ea 06          	shr    $0x6,%rdx
  806216:	48 89 d0             	mov    %rdx,%rax
  806219:	48 c1 e0 09          	shl    $0x9,%rax
  80621d:	48 29 d0             	sub    %rdx,%rax
  806220:	48 c1 e0 03          	shl    $0x3,%rax
  806224:	48 29 c1             	sub    %rax,%rcx
  806227:	40 88 7c 0b 08       	mov    %dil,0x8(%rbx,%rcx,1)
        p->p_wpos++;
  80622c:	83 c6 01             	add    $0x1,%esi
  80622f:	89 73 04             	mov    %esi,0x4(%rbx)
    for (size_t i = 0; i < n; i++) {
  806232:	49 83 c7 01          	add    $0x1,%r15
  806236:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80623a:	49 39 c7             	cmp    %rax,%r15
  80623d:	0f 85 75 ff ff ff    	jne    8061b8 <devpipe_write+0x5b>
    return n;
  806243:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  806247:	eb 05                	jmp    80624e <devpipe_write+0xf1>
            if (_pipeisclosed(fd, p)) return 0;
  806249:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80624e:	48 83 c4 18          	add    $0x18,%rsp
  806252:	5b                   	pop    %rbx
  806253:	41 5c                	pop    %r12
  806255:	41 5d                	pop    %r13
  806257:	41 5e                	pop    %r14
  806259:	41 5f                	pop    %r15
  80625b:	5d                   	pop    %rbp
  80625c:	c3                   	ret

000000000080625d <devpipe_read>:
devpipe_read(struct Fd *fd, void *vbuf, size_t n) {
  80625d:	f3 0f 1e fa          	endbr64
  806261:	55                   	push   %rbp
  806262:	48 89 e5             	mov    %rsp,%rbp
  806265:	41 57                	push   %r15
  806267:	41 56                	push   %r14
  806269:	41 55                	push   %r13
  80626b:	41 54                	push   %r12
  80626d:	53                   	push   %rbx
  80626e:	48 83 ec 18          	sub    $0x18,%rsp
  806272:	49 89 fc             	mov    %rdi,%r12
  806275:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  806279:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    struct Pipe *p = (struct Pipe *)fd2data(fd);
  80627d:	48 b8 12 56 80 00 00 	movabs $0x805612,%rax
  806284:	00 00 00 
  806287:	ff d0                	call   *%rax
  806289:	48 89 c3             	mov    %rax,%rbx
    for (size_t i = 0; i < n; i++) {
  80628c:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  806292:	49 bd 3b 4d 80 00 00 	movabs $0x804d3b,%r13
  806299:	00 00 00 
            sys_yield();
  80629c:	49 be d0 4c 80 00 00 	movabs $0x804cd0,%r14
  8062a3:	00 00 00 
    for (size_t i = 0; i < n; i++) {
  8062a6:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8062ab:	74 7d                	je     80632a <devpipe_read+0xcd>
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8062ad:	8b 03                	mov    (%rbx),%eax
  8062af:	3b 43 04             	cmp    0x4(%rbx),%eax
  8062b2:	75 26                	jne    8062da <devpipe_read+0x7d>
            if (i > 0) return i;
  8062b4:	4d 85 ff             	test   %r15,%r15
  8062b7:	75 77                	jne    806330 <devpipe_read+0xd3>
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  8062b9:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8062be:	48 89 da             	mov    %rbx,%rdx
  8062c1:	be 00 10 00 00       	mov    $0x1000,%esi
  8062c6:	4c 89 e7             	mov    %r12,%rdi
  8062c9:	41 ff d5             	call   *%r13
            if (_pipeisclosed(fd, p)) return 0;
  8062cc:	85 c0                	test   %eax,%eax
  8062ce:	74 72                	je     806342 <devpipe_read+0xe5>
            sys_yield();
  8062d0:	41 ff d6             	call   *%r14
        while (p->p_rpos == p->p_wpos) /* pipe is empty */ {
  8062d3:	8b 03                	mov    (%rbx),%eax
  8062d5:	3b 43 04             	cmp    0x4(%rbx),%eax
  8062d8:	74 df                	je     8062b9 <devpipe_read+0x5c>
        buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8062da:	48 63 c8             	movslq %eax,%rcx
  8062dd:	48 89 ca             	mov    %rcx,%rdx
  8062e0:	48 c1 ea 03          	shr    $0x3,%rdx
  8062e4:	48 be 81 00 01 02 04 	movabs $0x2010080402010081,%rsi
  8062eb:	08 10 20 
  8062ee:	48 89 d0             	mov    %rdx,%rax
  8062f1:	48 f7 e6             	mul    %rsi
  8062f4:	48 c1 ea 06          	shr    $0x6,%rdx
  8062f8:	48 89 d0             	mov    %rdx,%rax
  8062fb:	48 c1 e0 09          	shl    $0x9,%rax
  8062ff:	48 29 d0             	sub    %rdx,%rax
  806302:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  806309:	00 
  80630a:	48 89 c8             	mov    %rcx,%rax
  80630d:	48 29 d0             	sub    %rdx,%rax
  806310:	0f b6 44 03 08       	movzbl 0x8(%rbx,%rax,1),%eax
  806315:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  806319:	42 88 04 39          	mov    %al,(%rcx,%r15,1)
        p->p_rpos++;
  80631d:	83 03 01             	addl   $0x1,(%rbx)
    for (size_t i = 0; i < n; i++) {
  806320:	49 83 c7 01          	add    $0x1,%r15
  806324:	4c 39 7d c8          	cmp    %r15,-0x38(%rbp)
  806328:	75 83                	jne    8062ad <devpipe_read+0x50>
    return n;
  80632a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80632e:	eb 03                	jmp    806333 <devpipe_read+0xd6>
            if (i > 0) return i;
  806330:	4c 89 f8             	mov    %r15,%rax
}
  806333:	48 83 c4 18          	add    $0x18,%rsp
  806337:	5b                   	pop    %rbx
  806338:	41 5c                	pop    %r12
  80633a:	41 5d                	pop    %r13
  80633c:	41 5e                	pop    %r14
  80633e:	41 5f                	pop    %r15
  806340:	5d                   	pop    %rbp
  806341:	c3                   	ret
            if (_pipeisclosed(fd, p)) return 0;
  806342:	b8 00 00 00 00       	mov    $0x0,%eax
  806347:	eb ea                	jmp    806333 <devpipe_read+0xd6>

0000000000806349 <pipe>:
pipe(int pfd[2]) {
  806349:	f3 0f 1e fa          	endbr64
  80634d:	55                   	push   %rbp
  80634e:	48 89 e5             	mov    %rsp,%rbp
  806351:	41 55                	push   %r13
  806353:	41 54                	push   %r12
  806355:	53                   	push   %rbx
  806356:	48 83 ec 18          	sub    $0x18,%rsp
  80635a:	49 89 fc             	mov    %rdi,%r12
    if ((res = fd_alloc(&fd0)) < 0 ||
  80635d:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  806361:	48 b8 32 56 80 00 00 	movabs $0x805632,%rax
  806368:	00 00 00 
  80636b:	ff d0                	call   *%rax
  80636d:	89 c3                	mov    %eax,%ebx
  80636f:	85 c0                	test   %eax,%eax
  806371:	0f 88 a0 01 00 00    	js     806517 <pipe+0x1ce>
        (res = sys_alloc_region(0, fd0, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err;
  806377:	b9 46 00 00 00       	mov    $0x46,%ecx
  80637c:	ba 00 10 00 00       	mov    $0x1000,%edx
  806381:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  806385:	bf 00 00 00 00       	mov    $0x0,%edi
  80638a:	48 b8 6b 4d 80 00 00 	movabs $0x804d6b,%rax
  806391:	00 00 00 
  806394:	ff d0                	call   *%rax
  806396:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd0)) < 0 ||
  806398:	85 c0                	test   %eax,%eax
  80639a:	0f 88 77 01 00 00    	js     806517 <pipe+0x1ce>
    if ((res = fd_alloc(&fd1)) < 0 ||
  8063a0:	48 8d 7d d0          	lea    -0x30(%rbp),%rdi
  8063a4:	48 b8 32 56 80 00 00 	movabs $0x805632,%rax
  8063ab:	00 00 00 
  8063ae:	ff d0                	call   *%rax
  8063b0:	89 c3                	mov    %eax,%ebx
  8063b2:	85 c0                	test   %eax,%eax
  8063b4:	0f 88 43 01 00 00    	js     8064fd <pipe+0x1b4>
        (res = sys_alloc_region(0, fd1, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err1;
  8063ba:	b9 46 00 00 00       	mov    $0x46,%ecx
  8063bf:	ba 00 10 00 00       	mov    $0x1000,%edx
  8063c4:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8063c8:	bf 00 00 00 00       	mov    $0x0,%edi
  8063cd:	48 b8 6b 4d 80 00 00 	movabs $0x804d6b,%rax
  8063d4:	00 00 00 
  8063d7:	ff d0                	call   *%rax
  8063d9:	89 c3                	mov    %eax,%ebx
    if ((res = fd_alloc(&fd1)) < 0 ||
  8063db:	85 c0                	test   %eax,%eax
  8063dd:	0f 88 1a 01 00 00    	js     8064fd <pipe+0x1b4>
    va = fd2data(fd0);
  8063e3:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8063e7:	48 b8 12 56 80 00 00 	movabs $0x805612,%rax
  8063ee:	00 00 00 
  8063f1:	ff d0                	call   *%rax
  8063f3:	49 89 c5             	mov    %rax,%r13
    if ((res = sys_alloc_region(0, va, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err2;
  8063f6:	b9 46 00 00 00       	mov    $0x46,%ecx
  8063fb:	ba 00 10 00 00       	mov    $0x1000,%edx
  806400:	48 89 c6             	mov    %rax,%rsi
  806403:	bf 00 00 00 00       	mov    $0x0,%edi
  806408:	48 b8 6b 4d 80 00 00 	movabs $0x804d6b,%rax
  80640f:	00 00 00 
  806412:	ff d0                	call   *%rax
  806414:	89 c3                	mov    %eax,%ebx
  806416:	85 c0                	test   %eax,%eax
  806418:	0f 88 c5 00 00 00    	js     8064e3 <pipe+0x19a>
    if ((res = sys_map_region(0, va, 0, fd2data(fd1), PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) goto err3;
  80641e:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  806422:	48 b8 12 56 80 00 00 	movabs $0x805612,%rax
  806429:	00 00 00 
  80642c:	ff d0                	call   *%rax
  80642e:	48 89 c1             	mov    %rax,%rcx
  806431:	41 b9 46 00 00 00    	mov    $0x46,%r9d
  806437:	41 b8 00 10 00 00    	mov    $0x1000,%r8d
  80643d:	ba 00 00 00 00       	mov    $0x0,%edx
  806442:	4c 89 ee             	mov    %r13,%rsi
  806445:	bf 00 00 00 00       	mov    $0x0,%edi
  80644a:	48 b8 d6 4d 80 00 00 	movabs $0x804dd6,%rax
  806451:	00 00 00 
  806454:	ff d0                	call   *%rax
  806456:	89 c3                	mov    %eax,%ebx
  806458:	85 c0                	test   %eax,%eax
  80645a:	78 6e                	js     8064ca <pipe+0x181>
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  80645c:	be 00 10 00 00       	mov    $0x1000,%esi
  806461:	4c 89 ef             	mov    %r13,%rdi
  806464:	48 b8 05 4d 80 00 00 	movabs $0x804d05,%rax
  80646b:	00 00 00 
  80646e:	ff d0                	call   *%rax
  806470:	83 f8 02             	cmp    $0x2,%eax
  806473:	0f 85 ab 00 00 00    	jne    806524 <pipe+0x1db>
    fd0->fd_dev_id = devpipe.dev_id;
  806479:	a1 c0 c0 80 00 00 00 	movabs 0x80c0c0,%eax
  806480:	00 00 
  806482:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  806486:	89 02                	mov    %eax,(%rdx)
    fd0->fd_omode = O_RDONLY;
  806488:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80648c:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
    fd1->fd_dev_id = devpipe.dev_id;
  806493:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  806497:	89 02                	mov    %eax,(%rdx)
    fd1->fd_omode = O_WRONLY;
  806499:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80649d:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
    pfd[0] = fd2num(fd0);
  8064a4:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
  8064a8:	48 bb fc 55 80 00 00 	movabs $0x8055fc,%rbx
  8064af:	00 00 00 
  8064b2:	ff d3                	call   *%rbx
  8064b4:	41 89 04 24          	mov    %eax,(%r12)
    pfd[1] = fd2num(fd1);
  8064b8:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8064bc:	ff d3                	call   *%rbx
  8064be:	41 89 44 24 04       	mov    %eax,0x4(%r12)
    return 0;
  8064c3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8064c8:	eb 4d                	jmp    806517 <pipe+0x1ce>
    sys_unmap_region(0, va, PAGE_SIZE);
  8064ca:	ba 00 10 00 00       	mov    $0x1000,%edx
  8064cf:	4c 89 ee             	mov    %r13,%rsi
  8064d2:	bf 00 00 00 00       	mov    $0x0,%edi
  8064d7:	48 b8 ab 4e 80 00 00 	movabs $0x804eab,%rax
  8064de:	00 00 00 
  8064e1:	ff d0                	call   *%rax
    sys_unmap_region(0, fd1, PAGE_SIZE);
  8064e3:	ba 00 10 00 00       	mov    $0x1000,%edx
  8064e8:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8064ec:	bf 00 00 00 00       	mov    $0x0,%edi
  8064f1:	48 b8 ab 4e 80 00 00 	movabs $0x804eab,%rax
  8064f8:	00 00 00 
  8064fb:	ff d0                	call   *%rax
    sys_unmap_region(0, fd0, PAGE_SIZE);
  8064fd:	ba 00 10 00 00       	mov    $0x1000,%edx
  806502:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  806506:	bf 00 00 00 00       	mov    $0x0,%edi
  80650b:	48 b8 ab 4e 80 00 00 	movabs $0x804eab,%rax
  806512:	00 00 00 
  806515:	ff d0                	call   *%rax
}
  806517:	89 d8                	mov    %ebx,%eax
  806519:	48 83 c4 18          	add    $0x18,%rsp
  80651d:	5b                   	pop    %rbx
  80651e:	41 5c                	pop    %r12
  806520:	41 5d                	pop    %r13
  806522:	5d                   	pop    %rbp
  806523:	c3                   	ret
    assert(sys_region_refs(va, PAGE_SIZE) == 2);
  806524:	48 b9 48 73 80 00 00 	movabs $0x807348,%rcx
  80652b:	00 00 00 
  80652e:	48 ba 94 73 80 00 00 	movabs $0x807394,%rdx
  806535:	00 00 00 
  806538:	be 2e 00 00 00       	mov    $0x2e,%esi
  80653d:	48 bf e5 79 80 00 00 	movabs $0x8079e5,%rdi
  806544:	00 00 00 
  806547:	b8 00 00 00 00       	mov    $0x0,%eax
  80654c:	49 b8 c1 3c 80 00 00 	movabs $0x803cc1,%r8
  806553:	00 00 00 
  806556:	41 ff d0             	call   *%r8

0000000000806559 <pipeisclosed>:
pipeisclosed(int fdnum) {
  806559:	f3 0f 1e fa          	endbr64
  80655d:	55                   	push   %rbp
  80655e:	48 89 e5             	mov    %rsp,%rbp
  806561:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  806565:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  806569:	48 b8 96 56 80 00 00 	movabs $0x805696,%rax
  806570:	00 00 00 
  806573:	ff d0                	call   *%rax
    if (res < 0) return res;
  806575:	85 c0                	test   %eax,%eax
  806577:	78 35                	js     8065ae <pipeisclosed+0x55>
    struct Pipe *pip = (struct Pipe *)fd2data(fd);
  806579:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80657d:	48 b8 12 56 80 00 00 	movabs $0x805612,%rax
  806584:	00 00 00 
  806587:	ff d0                	call   *%rax
  806589:	48 89 c2             	mov    %rax,%rdx
    return !sys_region_refs2(fd, PAGE_SIZE, p, PAGE_SIZE);
  80658c:	b9 00 10 00 00       	mov    $0x1000,%ecx
  806591:	be 00 10 00 00       	mov    $0x1000,%esi
  806596:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  80659a:	48 b8 3b 4d 80 00 00 	movabs $0x804d3b,%rax
  8065a1:	00 00 00 
  8065a4:	ff d0                	call   *%rax
  8065a6:	85 c0                	test   %eax,%eax
  8065a8:	0f 94 c0             	sete   %al
  8065ab:	0f b6 c0             	movzbl %al,%eax
}
  8065ae:	c9                   	leave
  8065af:	c3                   	ret

00000000008065b0 <get_uvpt_entry>:
extern volatile pde_t uvpd[];     /* VA of current page directory */
extern volatile pdpe_t uvpdp[];   /* VA of current page directory pointer */
extern volatile pml4e_t uvpml4[]; /* VA of current page map level 4 */

pte_t
get_uvpt_entry(void *va) {
  8065b0:	f3 0f 1e fa          	endbr64
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  8065b4:	48 89 f8             	mov    %rdi,%rax
  8065b7:	48 c1 e8 27          	shr    $0x27,%rax
  8065bb:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  8065c2:	7f 00 00 
  8065c5:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8065c9:	f6 c2 01             	test   $0x1,%dl
  8065cc:	74 6d                	je     80663b <get_uvpt_entry+0x8b>
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  8065ce:	48 89 f8             	mov    %rdi,%rax
  8065d1:	48 c1 e8 1e          	shr    $0x1e,%rax
  8065d5:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  8065dc:	7f 00 00 
  8065df:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8065e3:	f6 c2 01             	test   $0x1,%dl
  8065e6:	74 62                	je     80664a <get_uvpt_entry+0x9a>
  8065e8:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  8065ef:	7f 00 00 
  8065f2:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8065f6:	f6 c2 80             	test   $0x80,%dl
  8065f9:	75 4f                	jne    80664a <get_uvpt_entry+0x9a>
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  8065fb:	48 89 f8             	mov    %rdi,%rax
  8065fe:	48 c1 e8 15          	shr    $0x15,%rax
  806602:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  806609:	7f 00 00 
  80660c:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  806610:	f6 c2 01             	test   $0x1,%dl
  806613:	74 44                	je     806659 <get_uvpt_entry+0xa9>
  806615:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  80661c:	7f 00 00 
  80661f:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  806623:	f6 c2 80             	test   $0x80,%dl
  806626:	75 31                	jne    806659 <get_uvpt_entry+0xa9>
    return uvpt[VPT(va)];
  806628:	48 c1 ef 0c          	shr    $0xc,%rdi
  80662c:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  806633:	7f 00 00 
  806636:	48 8b 04 f8          	mov    (%rax,%rdi,8),%rax
}
  80663a:	c3                   	ret
    if (!(uvpml4[VPML4(va)] & PTE_P)) return uvpml4[VPML4(va)];
  80663b:	48 ba 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rdx
  806642:	7f 00 00 
  806645:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  806649:	c3                   	ret
    if (!(uvpdp[VPDP(va)] & PTE_P) || (uvpdp[VPDP(va)] & PTE_PS)) return uvpdp[VPDP(va)];
  80664a:	48 ba 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rdx
  806651:	7f 00 00 
  806654:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  806658:	c3                   	ret
    if (!(uvpd[VPD(va)] & PTE_P) || (uvpd[VPD(va)] & PTE_PS)) return uvpd[VPD(va)];
  806659:	48 ba 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rdx
  806660:	7f 00 00 
  806663:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
  806667:	c3                   	ret

0000000000806668 <get_phys_addr>:

uintptr_t
get_phys_addr(void *va) {
  806668:	f3 0f 1e fa          	endbr64
  80666c:	48 89 fa             	mov    %rdi,%rdx
    if (!(uvpml4[VPML4(va)] & PTE_P))
  80666f:	48 89 f9             	mov    %rdi,%rcx
  806672:	48 c1 e9 27          	shr    $0x27,%rcx
  806676:	48 b8 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%rax
  80667d:	7f 00 00 
  806680:	48 8b 0c c8          	mov    (%rax,%rcx,8),%rcx
        return -1;
  806684:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpml4[VPML4(va)] & PTE_P))
  80668b:	f6 c1 01             	test   $0x1,%cl
  80668e:	0f 84 b2 00 00 00    	je     806746 <get_phys_addr+0xde>
    if (!(uvpdp[VPDP(va)] & PTE_P))
  806694:	48 89 f9             	mov    %rdi,%rcx
  806697:	48 c1 e9 1e          	shr    $0x1e,%rcx
  80669b:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  8066a2:	7f 00 00 
  8066a5:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  8066a9:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpdp[VPDP(va)] & PTE_P))
  8066b0:	40 f6 c6 01          	test   $0x1,%sil
  8066b4:	0f 84 8c 00 00 00    	je     806746 <get_phys_addr+0xde>
    if (uvpdp[VPDP(va)] & PTE_PS)
  8066ba:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  8066c1:	7f 00 00 
  8066c4:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8066c8:	a8 80                	test   $0x80,%al
  8066ca:	75 7b                	jne    806747 <get_phys_addr+0xdf>
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
    if (!(uvpd[VPD(va)] & PTE_P))
  8066cc:	48 89 f9             	mov    %rdi,%rcx
  8066cf:	48 c1 e9 15          	shr    $0x15,%rcx
  8066d3:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  8066da:	7f 00 00 
  8066dd:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  8066e1:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpd[VPD(va)] & PTE_P))
  8066e8:	40 f6 c6 01          	test   $0x1,%sil
  8066ec:	74 58                	je     806746 <get_phys_addr+0xde>
    if ((uvpd[VPD(va)] & PTE_PS))
  8066ee:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  8066f5:	7f 00 00 
  8066f8:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  8066fc:	a8 80                	test   $0x80,%al
  8066fe:	75 6c                	jne    80676c <get_phys_addr+0x104>
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
    if (!(uvpt[VPT(va)] & PTE_P))
  806700:	48 89 f9             	mov    %rdi,%rcx
  806703:	48 c1 e9 0c          	shr    $0xc,%rcx
  806707:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  80670e:	7f 00 00 
  806711:	48 8b 34 c8          	mov    (%rax,%rcx,8),%rsi
        return -1;
  806715:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    if (!(uvpt[VPT(va)] & PTE_P))
  80671c:	40 f6 c6 01          	test   $0x1,%sil
  806720:	74 24                	je     806746 <get_phys_addr+0xde>
    return PTE_ADDR(uvpt[VPT(va)]) + PAGE_OFFSET(va);
  806722:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  806729:	7f 00 00 
  80672c:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  806730:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  806737:	ff ff 7f 
  80673a:	48 21 c8             	and    %rcx,%rax
  80673d:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  806743:	48 09 d0             	or     %rdx,%rax
}
  806746:	c3                   	ret
        return PTE_ADDR(uvpdp[VPDP(va)]) + ((uintptr_t)va & ((1ULL << PDP_SHIFT) - 1));
  806747:	48 b8 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%rax
  80674e:	7f 00 00 
  806751:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  806755:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  80675c:	ff ff 7f 
  80675f:	48 21 c8             	and    %rcx,%rax
  806762:	81 e2 ff ff ff 3f    	and    $0x3fffffff,%edx
  806768:	48 01 d0             	add    %rdx,%rax
  80676b:	c3                   	ret
        return PTE_ADDR(uvpd[VPD(va)]) + ((uintptr_t)va & ((1ULL << PD_SHIFT) - 1));
  80676c:	48 b8 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rax
  806773:	7f 00 00 
  806776:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  80677a:	48 b9 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rcx
  806781:	ff ff 7f 
  806784:	48 21 c8             	and    %rcx,%rax
  806787:	81 e2 ff ff 1f 00    	and    $0x1fffff,%edx
  80678d:	48 01 d0             	add    %rdx,%rax
  806790:	c3                   	ret

0000000000806791 <get_prot>:

int
get_prot(void *va) {
  806791:	f3 0f 1e fa          	endbr64
  806795:	55                   	push   %rbp
  806796:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  806799:	48 b8 b0 65 80 00 00 	movabs $0x8065b0,%rax
  8067a0:	00 00 00 
  8067a3:	ff d0                	call   *%rax
  8067a5:	48 89 c2             	mov    %rax,%rdx
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
    if (pte & PTE_P) prot |= PROT_R;
  8067a8:	83 e0 01             	and    $0x1,%eax
  8067ab:	c1 e0 02             	shl    $0x2,%eax
    int prot = pte & PTE_AVAIL & ~PTE_SHARE;
  8067ae:	89 d1                	mov    %edx,%ecx
  8067b0:	81 e1 00 0a 00 00    	and    $0xa00,%ecx
    if (pte & PTE_P) prot |= PROT_R;
  8067b6:	09 c8                	or     %ecx,%eax
    if (pte & PTE_W) prot |= PROT_W;
  8067b8:	89 c1                	mov    %eax,%ecx
  8067ba:	83 c9 02             	or     $0x2,%ecx
  8067bd:	f6 c2 02             	test   $0x2,%dl
  8067c0:	0f 45 c1             	cmovne %ecx,%eax
    if (!(pte & PTE_NX)) prot |= PROT_X;
  8067c3:	89 c1                	mov    %eax,%ecx
  8067c5:	83 c9 01             	or     $0x1,%ecx
  8067c8:	48 85 d2             	test   %rdx,%rdx
  8067cb:	0f 49 c1             	cmovns %ecx,%eax
    if (pte & PTE_SHARE) prot |= PROT_SHARE;
  8067ce:	89 c1                	mov    %eax,%ecx
  8067d0:	83 c9 40             	or     $0x40,%ecx
  8067d3:	f6 c6 04             	test   $0x4,%dh
  8067d6:	0f 45 c1             	cmovne %ecx,%eax
    return prot;
}
  8067d9:	5d                   	pop    %rbp
  8067da:	c3                   	ret

00000000008067db <is_page_dirty>:

bool
is_page_dirty(void *va) {
  8067db:	f3 0f 1e fa          	endbr64
  8067df:	55                   	push   %rbp
  8067e0:	48 89 e5             	mov    %rsp,%rbp
    pte_t pte = get_uvpt_entry(va);
  8067e3:	48 b8 b0 65 80 00 00 	movabs $0x8065b0,%rax
  8067ea:	00 00 00 
  8067ed:	ff d0                	call   *%rax
    return pte & PTE_D;
  8067ef:	48 c1 e8 06          	shr    $0x6,%rax
  8067f3:	83 e0 01             	and    $0x1,%eax
}
  8067f6:	5d                   	pop    %rbp
  8067f7:	c3                   	ret

00000000008067f8 <is_page_present>:

bool
is_page_present(void *va) {
  8067f8:	f3 0f 1e fa          	endbr64
  8067fc:	55                   	push   %rbp
  8067fd:	48 89 e5             	mov    %rsp,%rbp
    return get_uvpt_entry(va) & PTE_P;
  806800:	48 b8 b0 65 80 00 00 	movabs $0x8065b0,%rax
  806807:	00 00 00 
  80680a:	ff d0                	call   *%rax
  80680c:	83 e0 01             	and    $0x1,%eax
}
  80680f:	5d                   	pop    %rbp
  806810:	c3                   	ret

0000000000806811 <foreach_shared_region>:

int
foreach_shared_region(int (*fun)(void *start, void *end, void *arg), void *arg) {
  806811:	f3 0f 1e fa          	endbr64
  806815:	55                   	push   %rbp
  806816:	48 89 e5             	mov    %rsp,%rbp
  806819:	41 57                	push   %r15
  80681b:	41 56                	push   %r14
  80681d:	41 55                	push   %r13
  80681f:	41 54                	push   %r12
  806821:	53                   	push   %rbx
  806822:	48 83 ec 18          	sub    $0x18,%rsp
  806826:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80682a:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
     * NOTE: Skip over larger pages/page directories for efficiency */
    // LAB 11: Your code here:

    int res = 0;
    (void)fun, (void)arg;
    uintptr_t va = 0;
  80682e:	bb 00 00 00 00       	mov    $0x0,%ebx
    while (va < USER_STACK_TOP) {
        size_t size = 0;
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  806833:	49 be 00 f0 ef df bf 	movabs $0x7fbfdfeff000,%r14
  80683a:	7f 00 00 
            size = 1LL << PML4_SHIFT;
            goto next;
        }

        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  80683d:	49 bd 00 00 e0 df bf 	movabs $0x7fbfdfe00000,%r13
  806844:	7f 00 00 
    while (va < USER_STACK_TOP) {
  806847:	49 bf ff 6f ff ff 7f 	movabs $0x7fffff6fff,%r15
  80684e:	00 00 00 
  806851:	eb 73                	jmp    8068c6 <foreach_shared_region+0xb5>
            }

            goto next;
        }

        if (!(uvpd[VPD(va)] & PTE_P)) {
  806853:	48 89 d8             	mov    %rbx,%rax
  806856:	48 c1 e8 15          	shr    $0x15,%rax
  80685a:	48 b9 00 00 00 c0 bf 	movabs $0x7fbfc0000000,%rcx
  806861:	7f 00 00 
  806864:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
            size = 1LL << PD_SHIFT;
  806868:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
        if (!(uvpd[VPD(va)] & PTE_P)) {
  80686e:	f6 c2 01             	test   $0x1,%dl
  806871:	74 4b                	je     8068be <foreach_shared_region+0xad>
            goto next;
        }

        if (uvpd[VPD(va)] & PTE_PS) {
  806873:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
  806877:	f6 c2 80             	test   $0x80,%dl
  80687a:	74 11                	je     80688d <foreach_shared_region+0x7c>
            size = 1LL << PD_SHIFT;
            if (uvpd[VPD(va)] & PTE_SHARE) {
  80687c:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
  806880:	f6 c4 04             	test   $0x4,%ah
  806883:	74 39                	je     8068be <foreach_shared_region+0xad>
            size = 1LL << PD_SHIFT;
  806885:	41 bc 00 00 20 00    	mov    $0x200000,%r12d
  80688b:	eb 20                	jmp    8068ad <foreach_shared_region+0x9c>

            goto next;
        }

        size = PAGE_SIZE;
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  80688d:	48 89 da             	mov    %rbx,%rdx
  806890:	48 c1 ea 0c          	shr    $0xc,%rdx
  806894:	48 b8 00 00 00 00 80 	movabs $0x7f8000000000,%rax
  80689b:	7f 00 00 
  80689e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
        size = PAGE_SIZE;
  8068a2:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
        if (!(uvpt[VPT(va)] & PTE_SHARE)) {
  8068a8:	f6 c4 04             	test   $0x4,%ah
  8068ab:	74 11                	je     8068be <foreach_shared_region+0xad>
            goto next;
        }

    map:
        fun((void *)va, (void *)(va + size), arg);
  8068ad:	49 8d 34 1c          	lea    (%r12,%rbx,1),%rsi
  8068b1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8068b5:	48 89 df             	mov    %rbx,%rdi
  8068b8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8068bc:	ff d0                	call   *%rax
    next:
        va += size;
  8068be:	4c 01 e3             	add    %r12,%rbx
    while (va < USER_STACK_TOP) {
  8068c1:	49 39 df             	cmp    %rbx,%r15
  8068c4:	72 3e                	jb     806904 <foreach_shared_region+0xf3>
        if (!(uvpml4[VPML4(va)] & PTE_P)) {
  8068c6:	49 8b 06             	mov    (%r14),%rax
  8068c9:	a8 01                	test   $0x1,%al
  8068cb:	74 37                	je     806904 <foreach_shared_region+0xf3>
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  8068cd:	48 89 d8             	mov    %rbx,%rax
  8068d0:	48 c1 e8 1e          	shr    $0x1e,%rax
  8068d4:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
            size = 1LL << PDP_SHIFT;
  8068d9:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
        if (!(uvpdp[VPDP(va)] & PTE_P)) {
  8068df:	f6 c2 01             	test   $0x1,%dl
  8068e2:	74 da                	je     8068be <foreach_shared_region+0xad>
        if (uvpdp[VPDP(va)] & PTE_PS) {
  8068e4:	49 8b 54 c5 00       	mov    0x0(%r13,%rax,8),%rdx
  8068e9:	f6 c2 80             	test   $0x80,%dl
  8068ec:	0f 84 61 ff ff ff    	je     806853 <foreach_shared_region+0x42>
            if (uvpdp[VPDP(va)] & PTE_SHARE) {
  8068f2:	49 8b 44 c5 00       	mov    0x0(%r13,%rax,8),%rax
  8068f7:	f6 c4 04             	test   $0x4,%ah
  8068fa:	74 c2                	je     8068be <foreach_shared_region+0xad>
            size = 1LL << PDP_SHIFT;
  8068fc:	41 bc 00 00 00 40    	mov    $0x40000000,%r12d
  806902:	eb a9                	jmp    8068ad <foreach_shared_region+0x9c>
    }
    return res;
}
  806904:	b8 00 00 00 00       	mov    $0x0,%eax
  806909:	48 83 c4 18          	add    $0x18,%rsp
  80690d:	5b                   	pop    %rbx
  80690e:	41 5c                	pop    %r12
  806910:	41 5d                	pop    %r13
  806912:	41 5e                	pop    %r14
  806914:	41 5f                	pop    %r15
  806916:	5d                   	pop    %rbp
  806917:	c3                   	ret

0000000000806918 <devcons_close>:

    return res;
}

static int
devcons_close(struct Fd *fd) {
  806918:	f3 0f 1e fa          	endbr64
    USED(fd);

    return 0;
}
  80691c:	b8 00 00 00 00       	mov    $0x0,%eax
  806921:	c3                   	ret

0000000000806922 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat) {
  806922:	f3 0f 1e fa          	endbr64
  806926:	55                   	push   %rbp
  806927:	48 89 e5             	mov    %rsp,%rbp
  80692a:	48 89 f7             	mov    %rsi,%rdi
    strcpy(stat->st_name, "<cons>");
  80692d:	48 be f5 79 80 00 00 	movabs $0x8079f5,%rsi
  806934:	00 00 00 
  806937:	48 b8 66 47 80 00 00 	movabs $0x804766,%rax
  80693e:	00 00 00 
  806941:	ff d0                	call   *%rax
    return 0;
}
  806943:	b8 00 00 00 00       	mov    $0x0,%eax
  806948:	5d                   	pop    %rbp
  806949:	c3                   	ret

000000000080694a <devcons_write>:
devcons_write(struct Fd *fd, const void *vbuf, size_t n) {
  80694a:	f3 0f 1e fa          	endbr64
  80694e:	55                   	push   %rbp
  80694f:	48 89 e5             	mov    %rsp,%rbp
  806952:	41 57                	push   %r15
  806954:	41 56                	push   %r14
  806956:	41 55                	push   %r13
  806958:	41 54                	push   %r12
  80695a:	53                   	push   %rbx
  80695b:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  806962:	48 89 b5 48 ff ff ff 	mov    %rsi,-0xb8(%rbp)
    for (res = 0; res < n; res += inc) {
  806969:	48 85 d2             	test   %rdx,%rdx
  80696c:	74 7a                	je     8069e8 <devcons_write+0x9e>
  80696e:	49 89 d6             	mov    %rdx,%r14
  806971:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  806977:	be 00 00 00 00       	mov    $0x0,%esi
        memmove(buf, (char *)vbuf + res, inc);
  80697c:	49 bf 81 49 80 00 00 	movabs $0x804981,%r15
  806983:	00 00 00 
        inc = MIN(n - res, WRITEBUFSZ - 1);
  806986:	4c 89 f3             	mov    %r14,%rbx
  806989:	48 29 f3             	sub    %rsi,%rbx
  80698c:	b8 7f 00 00 00       	mov    $0x7f,%eax
  806991:	48 39 c3             	cmp    %rax,%rbx
  806994:	48 0f 47 d8          	cmova  %rax,%rbx
        memmove(buf, (char *)vbuf + res, inc);
  806998:	4c 63 eb             	movslq %ebx,%r13
  80699b:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  8069a2:	48 01 c6             	add    %rax,%rsi
  8069a5:	4c 89 ea             	mov    %r13,%rdx
  8069a8:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  8069af:	41 ff d7             	call   *%r15
        sys_cputs(buf, inc);
  8069b2:	4c 89 ee             	mov    %r13,%rsi
  8069b5:	48 8d bd 50 ff ff ff 	lea    -0xb0(%rbp),%rdi
  8069bc:	48 b8 c6 4b 80 00 00 	movabs $0x804bc6,%rax
  8069c3:	00 00 00 
  8069c6:	ff d0                	call   *%rax
    for (res = 0; res < n; res += inc) {
  8069c8:	41 01 dc             	add    %ebx,%r12d
  8069cb:	49 63 f4             	movslq %r12d,%rsi
  8069ce:	4c 39 f6             	cmp    %r14,%rsi
  8069d1:	72 b3                	jb     806986 <devcons_write+0x3c>
    return res;
  8069d3:	49 63 c4             	movslq %r12d,%rax
}
  8069d6:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  8069dd:	5b                   	pop    %rbx
  8069de:	41 5c                	pop    %r12
  8069e0:	41 5d                	pop    %r13
  8069e2:	41 5e                	pop    %r14
  8069e4:	41 5f                	pop    %r15
  8069e6:	5d                   	pop    %rbp
  8069e7:	c3                   	ret
    for (res = 0; res < n; res += inc) {
  8069e8:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  8069ee:	eb e3                	jmp    8069d3 <devcons_write+0x89>

00000000008069f0 <devcons_read>:
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  8069f0:	f3 0f 1e fa          	endbr64
  8069f4:	48 89 d0             	mov    %rdx,%rax
    if (!n) return 0;
  8069f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8069fc:	48 85 c0             	test   %rax,%rax
  8069ff:	74 55                	je     806a56 <devcons_read+0x66>
devcons_read(struct Fd *fd, void *vbuf, size_t n) {
  806a01:	55                   	push   %rbp
  806a02:	48 89 e5             	mov    %rsp,%rbp
  806a05:	41 55                	push   %r13
  806a07:	41 54                	push   %r12
  806a09:	53                   	push   %rbx
  806a0a:	48 83 ec 08          	sub    $0x8,%rsp
  806a0e:	49 89 f5             	mov    %rsi,%r13
    while (!(c = sys_cgetc())) sys_yield();
  806a11:	48 bb f7 4b 80 00 00 	movabs $0x804bf7,%rbx
  806a18:	00 00 00 
  806a1b:	49 bc d0 4c 80 00 00 	movabs $0x804cd0,%r12
  806a22:	00 00 00 
  806a25:	eb 03                	jmp    806a2a <devcons_read+0x3a>
  806a27:	41 ff d4             	call   *%r12
  806a2a:	ff d3                	call   *%rbx
  806a2c:	85 c0                	test   %eax,%eax
  806a2e:	74 f7                	je     806a27 <devcons_read+0x37>
    if (c < 0) return c;
  806a30:	48 63 d0             	movslq %eax,%rdx
  806a33:	78 13                	js     806a48 <devcons_read+0x58>
    if (c == 0x04) return 0;
  806a35:	ba 00 00 00 00       	mov    $0x0,%edx
  806a3a:	83 f8 04             	cmp    $0x4,%eax
  806a3d:	74 09                	je     806a48 <devcons_read+0x58>
    *(char *)vbuf = (char)c;
  806a3f:	41 88 45 00          	mov    %al,0x0(%r13)
    return 1;
  806a43:	ba 01 00 00 00       	mov    $0x1,%edx
}
  806a48:	48 89 d0             	mov    %rdx,%rax
  806a4b:	48 83 c4 08          	add    $0x8,%rsp
  806a4f:	5b                   	pop    %rbx
  806a50:	41 5c                	pop    %r12
  806a52:	41 5d                	pop    %r13
  806a54:	5d                   	pop    %rbp
  806a55:	c3                   	ret
  806a56:	48 89 d0             	mov    %rdx,%rax
  806a59:	c3                   	ret

0000000000806a5a <cputchar>:
cputchar(int ch) {
  806a5a:	f3 0f 1e fa          	endbr64
  806a5e:	55                   	push   %rbp
  806a5f:	48 89 e5             	mov    %rsp,%rbp
  806a62:	48 83 ec 10          	sub    $0x10,%rsp
    char c = (char)ch;
  806a66:	40 88 7d ff          	mov    %dil,-0x1(%rbp)
    sys_cputs(&c, 1);
  806a6a:	be 01 00 00 00       	mov    $0x1,%esi
  806a6f:	48 8d 7d ff          	lea    -0x1(%rbp),%rdi
  806a73:	48 b8 c6 4b 80 00 00 	movabs $0x804bc6,%rax
  806a7a:	00 00 00 
  806a7d:	ff d0                	call   *%rax
}
  806a7f:	c9                   	leave
  806a80:	c3                   	ret

0000000000806a81 <getchar>:
getchar(void) {
  806a81:	f3 0f 1e fa          	endbr64
  806a85:	55                   	push   %rbp
  806a86:	48 89 e5             	mov    %rsp,%rbp
  806a89:	48 83 ec 10          	sub    $0x10,%rsp
    int res = read(0, &c, 1);
  806a8d:	ba 01 00 00 00       	mov    $0x1,%edx
  806a92:	48 8d 75 ff          	lea    -0x1(%rbp),%rsi
  806a96:	bf 00 00 00 00       	mov    $0x0,%edi
  806a9b:	48 b8 91 59 80 00 00 	movabs $0x805991,%rax
  806aa2:	00 00 00 
  806aa5:	ff d0                	call   *%rax
  806aa7:	89 c2                	mov    %eax,%edx
    return res < 0 ? res : res ? c :
  806aa9:	85 c0                	test   %eax,%eax
  806aab:	78 06                	js     806ab3 <getchar+0x32>
  806aad:	74 08                	je     806ab7 <getchar+0x36>
  806aaf:	0f b6 55 ff          	movzbl -0x1(%rbp),%edx
}
  806ab3:	89 d0                	mov    %edx,%eax
  806ab5:	c9                   	leave
  806ab6:	c3                   	ret
    return res < 0 ? res : res ? c :
  806ab7:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  806abc:	eb f5                	jmp    806ab3 <getchar+0x32>

0000000000806abe <iscons>:
iscons(int fdnum) {
  806abe:	f3 0f 1e fa          	endbr64
  806ac2:	55                   	push   %rbp
  806ac3:	48 89 e5             	mov    %rsp,%rbp
  806ac6:	48 83 ec 10          	sub    $0x10,%rsp
    int res = fd_lookup(fdnum, &fd);
  806aca:	48 8d 75 f8          	lea    -0x8(%rbp),%rsi
  806ace:	48 b8 96 56 80 00 00 	movabs $0x805696,%rax
  806ad5:	00 00 00 
  806ad8:	ff d0                	call   *%rax
    if (res < 0) return res;
  806ada:	85 c0                	test   %eax,%eax
  806adc:	78 18                	js     806af6 <iscons+0x38>
    return fd->fd_dev_id == devcons.dev_id;
  806ade:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  806ae2:	48 b8 00 c1 80 00 00 	movabs $0x80c100,%rax
  806ae9:	00 00 00 
  806aec:	8b 00                	mov    (%rax),%eax
  806aee:	39 02                	cmp    %eax,(%rdx)
  806af0:	0f 94 c0             	sete   %al
  806af3:	0f b6 c0             	movzbl %al,%eax
}
  806af6:	c9                   	leave
  806af7:	c3                   	ret

0000000000806af8 <opencons>:
opencons(void) {
  806af8:	f3 0f 1e fa          	endbr64
  806afc:	55                   	push   %rbp
  806afd:	48 89 e5             	mov    %rsp,%rbp
  806b00:	48 83 ec 10          	sub    $0x10,%rsp
    if ((res = fd_alloc(&fd)) < 0) return res;
  806b04:	48 8d 7d f8          	lea    -0x8(%rbp),%rdi
  806b08:	48 b8 32 56 80 00 00 	movabs $0x805632,%rax
  806b0f:	00 00 00 
  806b12:	ff d0                	call   *%rax
  806b14:	85 c0                	test   %eax,%eax
  806b16:	78 49                	js     806b61 <opencons+0x69>
    if ((res = sys_alloc_region(0, fd, PAGE_SIZE, PROT_RW | PROT_SHARE)) < 0) return res;
  806b18:	b9 46 00 00 00       	mov    $0x46,%ecx
  806b1d:	ba 00 10 00 00       	mov    $0x1000,%edx
  806b22:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
  806b26:	bf 00 00 00 00       	mov    $0x0,%edi
  806b2b:	48 b8 6b 4d 80 00 00 	movabs $0x804d6b,%rax
  806b32:	00 00 00 
  806b35:	ff d0                	call   *%rax
  806b37:	85 c0                	test   %eax,%eax
  806b39:	78 26                	js     806b61 <opencons+0x69>
    fd->fd_dev_id = devcons.dev_id;
  806b3b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  806b3f:	a1 00 c1 80 00 00 00 	movabs 0x80c100,%eax
  806b46:	00 00 
  806b48:	89 02                	mov    %eax,(%rdx)
    fd->fd_omode = O_RDWR;
  806b4a:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  806b4e:	c7 47 08 02 00 00 00 	movl   $0x2,0x8(%rdi)
    return fd2num(fd);
  806b55:	48 b8 fc 55 80 00 00 	movabs $0x8055fc,%rax
  806b5c:	00 00 00 
  806b5f:	ff d0                	call   *%rax
}
  806b61:	c9                   	leave
  806b62:	c3                   	ret

0000000000806b63 <__text_end>:
  806b63:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806b6a:	00 00 00 
  806b6d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806b74:	00 00 00 
  806b77:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806b7e:	00 00 00 
  806b81:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806b88:	00 00 00 
  806b8b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806b92:	00 00 00 
  806b95:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806b9c:	00 00 00 
  806b9f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806ba6:	00 00 00 
  806ba9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806bb0:	00 00 00 
  806bb3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806bba:	00 00 00 
  806bbd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806bc4:	00 00 00 
  806bc7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806bce:	00 00 00 
  806bd1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806bd8:	00 00 00 
  806bdb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806be2:	00 00 00 
  806be5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806bec:	00 00 00 
  806bef:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806bf6:	00 00 00 
  806bf9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806c00:	00 00 00 
  806c03:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806c0a:	00 00 00 
  806c0d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806c14:	00 00 00 
  806c17:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806c1e:	00 00 00 
  806c21:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806c28:	00 00 00 
  806c2b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806c32:	00 00 00 
  806c35:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806c3c:	00 00 00 
  806c3f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806c46:	00 00 00 
  806c49:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806c50:	00 00 00 
  806c53:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806c5a:	00 00 00 
  806c5d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806c64:	00 00 00 
  806c67:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806c6e:	00 00 00 
  806c71:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806c78:	00 00 00 
  806c7b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806c82:	00 00 00 
  806c85:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806c8c:	00 00 00 
  806c8f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806c96:	00 00 00 
  806c99:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806ca0:	00 00 00 
  806ca3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806caa:	00 00 00 
  806cad:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806cb4:	00 00 00 
  806cb7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806cbe:	00 00 00 
  806cc1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806cc8:	00 00 00 
  806ccb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806cd2:	00 00 00 
  806cd5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806cdc:	00 00 00 
  806cdf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806ce6:	00 00 00 
  806ce9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806cf0:	00 00 00 
  806cf3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806cfa:	00 00 00 
  806cfd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806d04:	00 00 00 
  806d07:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806d0e:	00 00 00 
  806d11:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806d18:	00 00 00 
  806d1b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806d22:	00 00 00 
  806d25:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806d2c:	00 00 00 
  806d2f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806d36:	00 00 00 
  806d39:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806d40:	00 00 00 
  806d43:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806d4a:	00 00 00 
  806d4d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806d54:	00 00 00 
  806d57:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806d5e:	00 00 00 
  806d61:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806d68:	00 00 00 
  806d6b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806d72:	00 00 00 
  806d75:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806d7c:	00 00 00 
  806d7f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806d86:	00 00 00 
  806d89:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806d90:	00 00 00 
  806d93:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806d9a:	00 00 00 
  806d9d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806da4:	00 00 00 
  806da7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806dae:	00 00 00 
  806db1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806db8:	00 00 00 
  806dbb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806dc2:	00 00 00 
  806dc5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806dcc:	00 00 00 
  806dcf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806dd6:	00 00 00 
  806dd9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806de0:	00 00 00 
  806de3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806dea:	00 00 00 
  806ded:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806df4:	00 00 00 
  806df7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806dfe:	00 00 00 
  806e01:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806e08:	00 00 00 
  806e0b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806e12:	00 00 00 
  806e15:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806e1c:	00 00 00 
  806e1f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806e26:	00 00 00 
  806e29:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806e30:	00 00 00 
  806e33:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806e3a:	00 00 00 
  806e3d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806e44:	00 00 00 
  806e47:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806e4e:	00 00 00 
  806e51:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806e58:	00 00 00 
  806e5b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806e62:	00 00 00 
  806e65:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806e6c:	00 00 00 
  806e6f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806e76:	00 00 00 
  806e79:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806e80:	00 00 00 
  806e83:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806e8a:	00 00 00 
  806e8d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806e94:	00 00 00 
  806e97:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806e9e:	00 00 00 
  806ea1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806ea8:	00 00 00 
  806eab:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806eb2:	00 00 00 
  806eb5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806ebc:	00 00 00 
  806ebf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806ec6:	00 00 00 
  806ec9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806ed0:	00 00 00 
  806ed3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806eda:	00 00 00 
  806edd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806ee4:	00 00 00 
  806ee7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806eee:	00 00 00 
  806ef1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806ef8:	00 00 00 
  806efb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806f02:	00 00 00 
  806f05:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806f0c:	00 00 00 
  806f0f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806f16:	00 00 00 
  806f19:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806f20:	00 00 00 
  806f23:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806f2a:	00 00 00 
  806f2d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806f34:	00 00 00 
  806f37:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806f3e:	00 00 00 
  806f41:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806f48:	00 00 00 
  806f4b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806f52:	00 00 00 
  806f55:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806f5c:	00 00 00 
  806f5f:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806f66:	00 00 00 
  806f69:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806f70:	00 00 00 
  806f73:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806f7a:	00 00 00 
  806f7d:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806f84:	00 00 00 
  806f87:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806f8e:	00 00 00 
  806f91:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806f98:	00 00 00 
  806f9b:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806fa2:	00 00 00 
  806fa5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806fac:	00 00 00 
  806faf:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806fb6:	00 00 00 
  806fb9:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806fc0:	00 00 00 
  806fc3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806fca:	00 00 00 
  806fcd:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806fd4:	00 00 00 
  806fd7:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806fde:	00 00 00 
  806fe1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806fe8:	00 00 00 
  806feb:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806ff2:	00 00 00 
  806ff5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  806ffc:	00 00 00 
  806fff:	90                   	nop
