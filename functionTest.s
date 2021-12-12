	.file	"functionTest.cpp"
	.text
	.local	_ZL16assemblies_mutex
	.comm	_ZL16assemblies_mutex,40,32
	.local	_ZL17loaded_assemblies
	.comm	_ZL17loaded_assemblies,8,8
	.section	.rodata
.LC0:
	.string	"mono_os_mutex_lock"
	.align 8
.LC1:
	.string	"%s: pthread_mutex_lock failed with \"%s\" (%d)"
	.text
	.type	_ZL18mono_os_mutex_lockP15pthread_mutex_t, @function
_ZL18mono_os_mutex_lockP15pthread_mutex_t:
.LFB9:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	pthread_mutex_lock@PLT
	movl	%eax, -4(%rbp)
	cmpl	$0, -4(%rbp)
	setne	%al
	movzbl	%al, %eax
	testl	%eax, %eax
	setne	%al
	movzbl	%al, %eax
	testq	%rax, %rax
	je	.L4
	movl	-4(%rbp), %eax
	movl	%eax, %edi
	call	_Z10g_strerrori@PLT
	movl	-4(%rbp), %edx
	movl	%edx, %r9d
	movq	%rax, %r8
	leaq	.LC0(%rip), %rcx
	leaq	.LC1(%rip), %rdx
	movl	$4, %esi
	movl	$0, %edi
	movl	$0, %eax
	call	_Z5g_logPKciS0_z@PLT
.L3:
	jmp	.L3
.L4:
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	_ZL18mono_os_mutex_lockP15pthread_mutex_t, .-_ZL18mono_os_mutex_lockP15pthread_mutex_t
	.section	.rodata
.LC2:
	.string	"mono_os_mutex_unlock"
	.align 8
.LC3:
	.string	"%s: pthread_mutex_unlock failed with \"%s\" (%d)"
	.text
	.type	_ZL20mono_os_mutex_unlockP15pthread_mutex_t, @function
_ZL20mono_os_mutex_unlockP15pthread_mutex_t:
.LFB10:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	pthread_mutex_unlock@PLT
	movl	%eax, -4(%rbp)
	cmpl	$0, -4(%rbp)
	setne	%al
	movzbl	%al, %eax
	testl	%eax, %eax
	setne	%al
	movzbl	%al, %eax
	testq	%rax, %rax
	je	.L8
	movl	-4(%rbp), %eax
	movl	%eax, %edi
	call	_Z10g_strerrori@PLT
	movl	-4(%rbp), %edx
	movl	%edx, %r9d
	movq	%rax, %r8
	leaq	.LC2(%rip), %rcx
	leaq	.LC3(%rip), %rdx
	movl	$4, %esi
	movl	$0, %edi
	movl	$0, %eax
	call	_Z5g_logPKciS0_z@PLT
.L7:
	jmp	.L7
.L8:
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	_ZL20mono_os_mutex_unlockP15pthread_mutex_t, .-_ZL20mono_os_mutex_unlockP15pthread_mutex_t
	.globl	_Z21mono_assembly_foreachPFvPvS_ES_
	.type	_Z21mono_assembly_foreachPFvPvS_ES_, @function
_Z21mono_assembly_foreachPFvPvS_ES_:
.LFB11:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	leaq	_ZL16assemblies_mutex(%rip), %rdi
	call	_ZL18mono_os_mutex_lockP15pthread_mutex_t
	movq	_ZL17loaded_assemblies(%rip), %rax
	movq	%rax, %rdi
	call	_Z11g_list_copyPv@PLT
	movq	%rax, -8(%rbp)
	leaq	_ZL16assemblies_mutex(%rip), %rdi
	call	_ZL20mono_os_mutex_unlockP15pthread_mutex_t
	movq	_ZL17loaded_assemblies(%rip), %rax
	movq	-32(%rbp), %rdx
	movq	-24(%rbp), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	_Z14g_list_foreachPvPFvS_S_ES_@PLT
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	_Z11g_list_freePv@PLT
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	_Z21mono_assembly_foreachPFvPvS_ES_, .-_Z21mono_assembly_foreachPFvPvS_ES_
	.ident	"GCC: (Ubuntu 10.3.0-1ubuntu1) 10.3.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	 1f - 0f
	.long	 4f - 1f
	.long	 5
0:
	.string	 "GNU"
1:
	.align 8
	.long	 0xc0000002
	.long	 3f - 2f
2:
	.long	 0x3
3:
	.align 8
4:
