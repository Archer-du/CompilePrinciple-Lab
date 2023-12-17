	.text
	.globl min
	.type min, @function
min:
	st.d $ra, $sp, -8
	st.d $fp, $sp, -16
	addi.d $fp, $sp, 0
	addi.d $sp, $sp, -32
	st.w $a0, $fp, -20
	st.w $a1, $fp, -24
.min_label_entry:
# %op2 = icmp sle i32 %arg0, %arg1
	ld.w $t0, $fp, -20
	ld.w $t1, $fp, -24
	slt $t3, $t0, $t1
	xor $t2, $t0, $t1
	nor $t2, $t2, $zero
	sltui $t2, $t2, -1
	nor $t2, $t2, $zero
	andi $t2, $t2, 1
	or $t2, $t2, $t3
	st.b $t2, $fp, -25
# br i1 %op2, label %label3, label %label5
	ld.b $t0, $fp, -25
	bnez $t0, .min_label3
	b .min_label5
.min_label3:
# ret i32 %arg0
	ld.w $a0, $fp, -20
	b min_exit
.min_label4:
# ret i32 0
	addi.w $a0, $zero, 0
	b min_exit
.min_label5:
# ret i32 %arg1
	ld.w $a0, $fp, -24
	b min_exit
min_exit:
	addi.d $sp, $sp, 32
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
	.globl main
	.type main, @function
main:
	st.d $ra, $sp, -8
	st.d $fp, $sp, -16
	addi.d $fp, $sp, 0
	addi.d $sp, $sp, -32
.main_label_entry:
# %op0 = call i32 @min(i32 11, i32 22)
	addi.w $a0, $zero, 11
	addi.w $a1, $zero, 22
	bl min
	st.w $a0, $fp, -20
# call void @output(i32 %op0)
	ld.w $a0, $fp, -20
	bl output
# %op1 = call i32 @min(i32 22, i32 33)
	addi.w $a0, $zero, 22
	addi.w $a1, $zero, 33
	bl min
	st.w $a0, $fp, -24
# call void @output(i32 %op1)
	ld.w $a0, $fp, -24
	bl output
# %op2 = call i32 @min(i32 33, i32 11)
	addi.w $a0, $zero, 33
	addi.w $a1, $zero, 11
	bl min
	st.w $a0, $fp, -28
# call void @output(i32 %op2)
	ld.w $a0, $fp, -28
	bl output
# ret i32 0
	addi.w $a0, $zero, 0
	b main_exit
main_exit:
	addi.d $sp, $sp, 32
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
