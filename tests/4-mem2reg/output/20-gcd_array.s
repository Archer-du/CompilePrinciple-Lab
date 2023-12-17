# Global variables
	.text
	.section .bss, "aw", @nobits
	.globl x
	.type x, @object
	.size x, 4
x:
	.space 4
	.globl y
	.type y, @object
	.size y, 4
y:
	.space 4
	.text
	.globl gcd
	.type gcd, @function
gcd:
	st.d $ra, $sp, -8
	st.d $fp, $sp, -16
	addi.d $fp, $sp, 0
	addi.d $sp, $sp, -48
	st.w $a0, $fp, -20
	st.w $a1, $fp, -24
.gcd_label_entry:
# %op2 = icmp eq i32 %arg1, 0
	ld.w $t0, $fp, -24
	addi.w $t1, $zero, 0
	xor $t2, $t0, $t1
	nor $t2, $t2, $zero
	sltui $t2, $t2, -1
	nor $t2, $t2, $zero
	andi $t2, $t2, 1
	st.b $t2, $fp, -25
# br i1 %op2, label %label3, label %label5
	ld.b $t0, $fp, -25
	bnez $t0, .gcd_label3
	b .gcd_label5
.gcd_label3:
# ret i32 %arg0
	ld.w $a0, $fp, -20
	b gcd_exit
.gcd_label4:
# ret i32 0
	addi.w $a0, $zero, 0
	b gcd_exit
.gcd_label5:
# %op6 = sdiv i32 %arg0, %arg1
	ld.w $t0, $fp, -20
	ld.w $t1, $fp, -24
	div.w $t2, $t0, $t1
	st.w $t2, $fp, -32
# %op7 = mul i32 %op6, %arg1
	ld.w $t0, $fp, -32
	ld.w $t1, $fp, -24
	mul.w $t2, $t0, $t1
	st.w $t2, $fp, -36
# %op8 = sub i32 %arg0, %op7
	ld.w $t0, $fp, -20
	ld.w $t1, $fp, -36
	sub.w $t2, $t0, $t1
	st.w $t2, $fp, -40
# %op9 = call i32 @gcd(i32 %arg1, i32 %op8)
	ld.w $a0, $fp, -24
	ld.w $a1, $fp, -40
	bl gcd
	st.w $a0, $fp, -44
# ret i32 %op9
	ld.w $a0, $fp, -44
	b gcd_exit
gcd_exit:
	addi.d $sp, $sp, 48
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
	.globl funArray
	.type funArray, @function
funArray:
	st.d $ra, $sp, -8
	st.d $fp, $sp, -16
	addi.d $fp, $sp, 0
	addi.d $sp, $sp, -96
	st.d $a0, $fp, -24
	st.d $a1, $fp, -32
.funArray_label_entry:
# %op2 = icmp sge i32 0, 0
	addi.w $t0, $zero, 0
	addi.w $t1, $zero, 0
	slt $t3, $t1, $t0
	xor $t2, $t0, $t1
	nor $t2, $t2, $zero
	sltui $t2, $t2, -1
	nor $t2, $t2, $zero
	andi $t2, $t2, 1
	or $t2, $t2, $t3
	st.b $t2, $fp, -33
# br i1 %op2, label %label4, label %label3
	ld.b $t0, $fp, -33
	bnez $t0, .funArray_label4
	b .funArray_label3
.funArray_label3:
# call void @neg_idx_except()
	bl neg_idx_except
# br label %label4
	b .funArray_label4
.funArray_label4:
# %op5 = getelementptr i32, i32* %arg0, i32 0
	ld.d $t0, $fp, -24
	addi.w $t1, $zero, 0
	bstrpick.d $t1, $t1, 31, 0
	lu12i.w $t2, 0
	ori $t2, $t2, 4
	bstrpick.d $t2, $t2, 31, 0
	mul.d $t1, $t1, $t2
	add.d $t0, $t0, $t1
	st.d $t0, $fp, -48
# %op6 = load i32, i32* %op5
	ld.d $t0, $fp, -48
	ld.w $t0, $t0, 0
	st.w $t0, $fp, -52
# %op7 = icmp sge i32 0, 0
	addi.w $t0, $zero, 0
	addi.w $t1, $zero, 0
	slt $t3, $t1, $t0
	xor $t2, $t0, $t1
	nor $t2, $t2, $zero
	sltui $t2, $t2, -1
	nor $t2, $t2, $zero
	andi $t2, $t2, 1
	or $t2, $t2, $t3
	st.b $t2, $fp, -53
# br i1 %op7, label %label9, label %label8
	ld.b $t0, $fp, -53
	bnez $t0, .funArray_label9
	b .funArray_label8
.funArray_label8:
# call void @neg_idx_except()
	bl neg_idx_except
# br label %label9
	b .funArray_label9
.funArray_label9:
# %op10 = getelementptr i32, i32* %arg1, i32 0
	ld.d $t0, $fp, -32
	addi.w $t1, $zero, 0
	bstrpick.d $t1, $t1, 31, 0
	lu12i.w $t2, 0
	ori $t2, $t2, 4
	bstrpick.d $t2, $t2, 31, 0
	mul.d $t1, $t1, $t2
	add.d $t0, $t0, $t1
	st.d $t0, $fp, -64
# %op11 = load i32, i32* %op10
	ld.d $t0, $fp, -64
	ld.w $t0, $t0, 0
	st.w $t0, $fp, -68
# %op12 = icmp slt i32 %op6, %op11
	ld.w $t0, $fp, -52
	ld.w $t1, $fp, -68
	slt $t2, $t0, $t1
	st.b $t2, $fp, -69
# br i1 %op12, label %label13, label %label14
	ld.b $t0, $fp, -69
	ld.w $t0, $fp, -68
	st.w $t0, $fp, -76
	ld.w $t0, $fp, -52
	st.w $t0, $fp, -80
	bnez $t0, .funArray_label13
	b .funArray_label14
.funArray_label13:
# br label %label14
	ld.w $t0, $fp, -52
	st.w $t0, $fp, -76
	ld.w $t0, $fp, -68
	st.w $t0, $fp, -80
	b .funArray_label14
.funArray_label14:
# %op15 = phi i32 [ %op11, %label9 ], [ %op6, %label13 ]
# %op16 = phi i32 [ %op6, %label9 ], [ %op11, %label13 ]
# %op17 = call i32 @gcd(i32 %op16, i32 %op15)
	ld.w $a0, $fp, -80
	ld.w $a1, $fp, -76
	bl gcd
	st.w $a0, $fp, -84
# ret i32 %op17
	ld.w $a0, $fp, -84
	b funArray_exit
funArray_exit:
	addi.d $sp, $sp, 96
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
	.globl main
	.type main, @function
main:
	st.d $ra, $sp, -8
	st.d $fp, $sp, -16
	addi.d $fp, $sp, 0
	addi.d $sp, $sp, -80
.main_label_entry:
# %op0 = icmp sge i32 0, 0
	addi.w $t0, $zero, 0
	addi.w $t1, $zero, 0
	slt $t3, $t1, $t0
	xor $t2, $t0, $t1
	nor $t2, $t2, $zero
	sltui $t2, $t2, -1
	nor $t2, $t2, $zero
	andi $t2, $t2, 1
	or $t2, $t2, $t3
	st.b $t2, $fp, -17
# br i1 %op0, label %label2, label %label1
	ld.b $t0, $fp, -17
	bnez $t0, .main_label2
	b .main_label1
.main_label1:
# call void @neg_idx_except()
	bl neg_idx_except
# br label %label2
	b .main_label2
.main_label2:
# %op3 = getelementptr [1 x i32], [1 x i32]* @x, i32 0, i32 0
	la.local $t0, x
	addi.w $t1, $zero, 0
	bstrpick.d $t1, $t1, 31, 0
	lu12i.w $t2, 0
	ori $t2, $t2, 4
	bstrpick.d $t2, $t2, 31, 0
	mul.d $t1, $t1, $t2
	add.d $t0, $t0, $t1
	st.d $t0, $fp, -32
# store i32 90, i32* %op3
	ld.d $t0, $fp, -32
	addi.w $t1, $zero, 90
	st.w $t1, $t0, 0
# %op4 = icmp sge i32 0, 0
	addi.w $t0, $zero, 0
	addi.w $t1, $zero, 0
	slt $t3, $t1, $t0
	xor $t2, $t0, $t1
	nor $t2, $t2, $zero
	sltui $t2, $t2, -1
	nor $t2, $t2, $zero
	andi $t2, $t2, 1
	or $t2, $t2, $t3
	st.b $t2, $fp, -33
# br i1 %op4, label %label6, label %label5
	ld.b $t0, $fp, -33
	bnez $t0, .main_label6
	b .main_label5
.main_label5:
# call void @neg_idx_except()
	bl neg_idx_except
# br label %label6
	b .main_label6
.main_label6:
# %op7 = getelementptr [1 x i32], [1 x i32]* @y, i32 0, i32 0
	la.local $t0, y
	addi.w $t1, $zero, 0
	bstrpick.d $t1, $t1, 31, 0
	lu12i.w $t2, 0
	ori $t2, $t2, 4
	bstrpick.d $t2, $t2, 31, 0
	mul.d $t1, $t1, $t2
	add.d $t0, $t0, $t1
	st.d $t0, $fp, -48
# store i32 18, i32* %op7
	ld.d $t0, $fp, -48
	addi.w $t1, $zero, 18
	st.w $t1, $t0, 0
# %op8 = getelementptr [1 x i32], [1 x i32]* @x, i32 0, i32 0
	la.local $t0, x
	addi.w $t1, $zero, 0
	bstrpick.d $t1, $t1, 31, 0
	lu12i.w $t2, 0
	ori $t2, $t2, 4
	bstrpick.d $t2, $t2, 31, 0
	mul.d $t1, $t1, $t2
	add.d $t0, $t0, $t1
	st.d $t0, $fp, -56
# %op9 = getelementptr [1 x i32], [1 x i32]* @y, i32 0, i32 0
	la.local $t0, y
	addi.w $t1, $zero, 0
	bstrpick.d $t1, $t1, 31, 0
	lu12i.w $t2, 0
	ori $t2, $t2, 4
	bstrpick.d $t2, $t2, 31, 0
	mul.d $t1, $t1, $t2
	add.d $t0, $t0, $t1
	st.d $t0, $fp, -64
# %op10 = call i32 @funArray(i32* %op8, i32* %op9)
	ld.d $a0, $fp, -56
	ld.d $a1, $fp, -64
	bl funArray
	st.w $a0, $fp, -68
# ret i32 %op10
	ld.w $a0, $fp, -68
	b main_exit
main_exit:
	addi.d $sp, $sp, 80
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
