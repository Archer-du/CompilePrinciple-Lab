	.text
	.globl factorial
	.type factorial, @function
factorial:
	st.d $ra, $sp, -8
	st.d $fp, $sp, -16
	addi.d $fp, $sp, 0
	addi.d $sp, $sp, -64
	st.w $a0, $fp, -20
.factorial_label_entry:
# %op1 = alloca i32
	addi.d $t0, $fp, -36
	st.d $t0, $fp, -32
# %op2 = icmp eq i32 %arg0, 0
	ld.w $t0, $fp, -20
	addi.w $t1, $zero, 0
	xor $t2, $t0, $t1
	nor $t2, $t2, $zero
	sltui $t2, $t2, -1
	nor $t2, $t2, $zero
	andi $t2, $t2, 1
	st.b $t2, $fp, -37
# br i1 %op2, label %label3, label %label5
	ld.b $t0, $fp, -37
	bnez $t0, .factorial_label3
	b .factorial_label5
.factorial_label3:
# ret i32 1
	addi.w $a0, $zero, 1
	b factorial_exit
.factorial_label4:
# ret i32 0
	addi.w $a0, $zero, 0
	b factorial_exit
.factorial_label5:
# %op6 = load i32, i32* %op1
	ld.d $t0, $fp, -32
	ld.w $t0, $t0, 0
	st.w $t0, $fp, -44
# %op7 = load i32, i32* %op1
	ld.d $t0, $fp, -32
	ld.w $t0, $t0, 0
	st.w $t0, $fp, -48
# %op8 = sub i32 %op7, 1
	ld.w $t0, $fp, -48
	addi.w $t1, $zero, 1
	sub.w $t2, $t0, $t1
	st.w $t2, $fp, -52
# %op9 = call i32 @factorial(i32 %op8)
	ld.w $a0, $fp, -52
	bl factorial
	st.w $a0, $fp, -56
# %op10 = mul i32 %op6, %op9
	ld.w $t0, $fp, -44
	ld.w $t1, $fp, -56
	mul.w $t2, $t0, $t1
	st.w $t2, $fp, -60
# ret i32 %op10
	ld.w $a0, $fp, -60
	b factorial_exit
factorial_exit:
	addi.d $sp, $sp, 64
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
# %op0 = call i32 @factorial(i32 10)
	addi.w $a0, $zero, 10
	bl factorial
	st.w $a0, $fp, -20
# ret i32 %op0
	ld.w $a0, $fp, -20
	b main_exit
main_exit:
	addi.d $sp, $sp, 32
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
