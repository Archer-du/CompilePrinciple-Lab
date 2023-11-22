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
	addi.d $sp, $sp, -112
	st.w $a0, $fp, -20
	st.w $a1, $fp, -24
.gcd_label_entry:
# %op2 = alloca i32
	addi.d $t0, $fp, -36
	st.d $t0, $fp, -32
# store i32 %arg0, i32* %op2
	ld.d $t0, $fp, -32
	ld.w $t1, $fp, -20
	st.w $t1, $t0, 0
# %op3 = alloca i32
	addi.d $t0, $fp, -52
	st.d $t0, $fp, -48
# store i32 %arg1, i32* %op3
	ld.d $t0, $fp, -48
	ld.w $t1, $fp, -24
	st.w $t1, $t0, 0
# %op4 = load i32, i32* %op3
	ld.d $t0, $fp, -48
	ld.w $t0, $t0, 0
	st.w $t0, $fp, -56
# %op5 = icmp eq i32 %op4, 0
	ld.w $t0, $fp, -56
	addi.w $t1, $zero, 0
	xor $t2, $t0, $t1
	nor $t2, $t2, $zero
	sltui $t2, $t2, -1
	nor $t2, $t2, $zero
	andi $t2, $t2, 1
	st.b $t2, $fp, -57
# br i1 %op5, label %label6, label %label9
	ld.b $t0, $fp, -57
	bnez $t0, .gcd_label6
	b .gcd_label9
.gcd_label6:
# %op7 = load i32, i32* %op2
	ld.d $t0, $fp, -32
	ld.w $t0, $t0, 0
	st.w $t0, $fp, -64
# ret i32 %op7
	ld.w $a0, $fp, -64
	b gcd_exit
.gcd_label8:
# ret i32 0
	addi.w $a0, $zero, 0
	b gcd_exit
.gcd_label9:
# %op10 = load i32, i32* %op3
	ld.d $t0, $fp, -48
	ld.w $t0, $t0, 0
	st.w $t0, $fp, -68
# %op11 = load i32, i32* %op2
	ld.d $t0, $fp, -32
	ld.w $t0, $t0, 0
	st.w $t0, $fp, -72
# %op12 = load i32, i32* %op2
	ld.d $t0, $fp, -32
	ld.w $t0, $t0, 0
	st.w $t0, $fp, -76
# %op13 = load i32, i32* %op3
	ld.d $t0, $fp, -48
	ld.w $t0, $t0, 0
	st.w $t0, $fp, -80
# %op14 = sdiv i32 %op12, %op13
	ld.w $t0, $fp, -76
	ld.w $t1, $fp, -80
	div.w $t2, $t0, $t1
	st.w $t2, $fp, -84
# %op15 = load i32, i32* %op3
	ld.d $t0, $fp, -48
	ld.w $t0, $t0, 0
	st.w $t0, $fp, -88
# %op16 = mul i32 %op14, %op15
	ld.w $t0, $fp, -84
	ld.w $t1, $fp, -88
	mul.w $t2, $t0, $t1
	st.w $t2, $fp, -92
# %op17 = sub i32 %op11, %op16
	ld.w $t0, $fp, -72
	ld.w $t1, $fp, -92
	sub.w $t2, $t0, $t1
	st.w $t2, $fp, -96
# %op18 = call i32 @gcd(i32 %op10, i32 %op17)
	ld.w $a0, $fp, -68
	ld.w $a1, $fp, -96
	bl gcd
	st.w $a0, $fp, -100
# ret i32 %op18
	ld.w $a0, $fp, -100
	b gcd_exit
gcd_exit:
	addi.d $sp, $sp, 112
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
	.globl funArray
	.type funArray, @function
funArray:
	st.d $ra, $sp, -8
	st.d $fp, $sp, -16
	addi.d $fp, $sp, 0
	addi.d $sp, $sp, -192
	st.d $a0, $fp, -24
	st.d $a1, $fp, -32
.funArray_label_entry:
# %op2 = alloca i32*
	addi.d $t0, $fp, -48
	st.d $t0, $fp, -40
# store i32* %arg0, i32** %op2
	ld.d $t0, $fp, -40
	ld.d $t1, $fp, -24
	st.d $t1, $t0, 0
# %op3 = alloca i32*
	addi.d $t0, $fp, -64
	st.d $t0, $fp, -56
# store i32* %arg1, i32** %op3
	ld.d $t0, $fp, -56
	ld.d $t1, $fp, -32
	st.d $t1, $t0, 0
# %op4 = alloca i32
	addi.d $t0, $fp, -76
	st.d $t0, $fp, -72
# %op5 = alloca i32
	addi.d $t0, $fp, -92
	st.d $t0, $fp, -88
# %op6 = alloca i32
	addi.d $t0, $fp, -108
	st.d $t0, $fp, -104
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
	st.b $t2, $fp, -109
# br i1 %op7, label %label9, label %label8
	ld.b $t0, $fp, -109
	bnez $t0, .funArray_label9
	b .funArray_label8
.funArray_label8:
# call void @neg_idx_except()
	bl neg_idx_except
# br label %label9
	b .funArray_label9
.funArray_label9:
# %op10 = load i32*, i32** %op2
	ld.d $t0, $fp, -40
	ld.d $t0, $t0, 0
	st.d $t0, $fp, -120
# %op11 = getelementptr i32, i32* %op10, i32 0
	ld.d $t0, $fp, -120
	addi.w $t1, $zero, 0
	bstrpick.d $t1, $t1, 31, 0
	lu12i.w $t2, 0
	ori $t2, $t2, 4
	bstrpick.d $t2, $t2, 31, 0
	mul.d $t1, $t1, $t2
	add.d $t0, $t0, $t1
	st.d $t0, $fp, -128
# %op12 = load i32, i32* %op11
	ld.d $t0, $fp, -128
	ld.w $t0, $t0, 0
	st.w $t0, $fp, -132
# store i32 %op12, i32* %op4
	ld.d $t0, $fp, -72
	ld.w $t1, $fp, -132
	st.w $t1, $t0, 0
# %op13 = icmp sge i32 0, 0
	addi.w $t0, $zero, 0
	addi.w $t1, $zero, 0
	slt $t3, $t1, $t0
	xor $t2, $t0, $t1
	nor $t2, $t2, $zero
	sltui $t2, $t2, -1
	nor $t2, $t2, $zero
	andi $t2, $t2, 1
	or $t2, $t2, $t3
	st.b $t2, $fp, -133
# br i1 %op13, label %label15, label %label14
	ld.b $t0, $fp, -133
	bnez $t0, .funArray_label15
	b .funArray_label14
.funArray_label14:
# call void @neg_idx_except()
	bl neg_idx_except
# br label %label15
	b .funArray_label15
.funArray_label15:
# %op16 = load i32*, i32** %op3
	ld.d $t0, $fp, -56
	ld.d $t0, $t0, 0
	st.d $t0, $fp, -144
# %op17 = getelementptr i32, i32* %op16, i32 0
	ld.d $t0, $fp, -144
	addi.w $t1, $zero, 0
	bstrpick.d $t1, $t1, 31, 0
	lu12i.w $t2, 0
	ori $t2, $t2, 4
	bstrpick.d $t2, $t2, 31, 0
	mul.d $t1, $t1, $t2
	add.d $t0, $t0, $t1
	st.d $t0, $fp, -152
# %op18 = load i32, i32* %op17
	ld.d $t0, $fp, -152
	ld.w $t0, $t0, 0
	st.w $t0, $fp, -156
# store i32 %op18, i32* %op5
	ld.d $t0, $fp, -88
	ld.w $t1, $fp, -156
	st.w $t1, $t0, 0
# %op19 = load i32, i32* %op4
	ld.d $t0, $fp, -72
	ld.w $t0, $t0, 0
	st.w $t0, $fp, -160
# %op20 = load i32, i32* %op5
	ld.d $t0, $fp, -88
	ld.w $t0, $t0, 0
	st.w $t0, $fp, -164
# %op21 = icmp slt i32 %op19, %op20
	ld.w $t0, $fp, -160
	ld.w $t1, $fp, -164
	slt $t2, $t0, $t1
	st.b $t2, $fp, -165
# br i1 %op21, label %label22, label %label26
	ld.b $t0, $fp, -165
	bnez $t0, .funArray_label22
	b .funArray_label26
.funArray_label22:
# %op23 = load i32, i32* %op4
	ld.d $t0, $fp, -72
	ld.w $t0, $t0, 0
	st.w $t0, $fp, -172
# store i32 %op23, i32* %op6
	ld.d $t0, $fp, -104
	ld.w $t1, $fp, -172
	st.w $t1, $t0, 0
# %op24 = load i32, i32* %op5
	ld.d $t0, $fp, -88
	ld.w $t0, $t0, 0
	st.w $t0, $fp, -176
# store i32 %op24, i32* %op4
	ld.d $t0, $fp, -72
	ld.w $t1, $fp, -176
	st.w $t1, $t0, 0
# %op25 = load i32, i32* %op6
	ld.d $t0, $fp, -104
	ld.w $t0, $t0, 0
	st.w $t0, $fp, -180
# store i32 %op25, i32* %op5
	ld.d $t0, $fp, -88
	ld.w $t1, $fp, -180
	st.w $t1, $t0, 0
# br label %label26
	b .funArray_label26
.funArray_label26:
# %op27 = load i32, i32* %op4
	ld.d $t0, $fp, -72
	ld.w $t0, $t0, 0
	st.w $t0, $fp, -184
# %op28 = load i32, i32* %op5
	ld.d $t0, $fp, -88
	ld.w $t0, $t0, 0
	st.w $t0, $fp, -188
# %op29 = call i32 @gcd(i32 %op27, i32 %op28)
	ld.w $a0, $fp, -184
	ld.w $a1, $fp, -188
	bl gcd
	st.w $a0, $fp, -192
# ret i32 %op29
	ld.w $a0, $fp, -192
	b funArray_exit
funArray_exit:
	addi.d $sp, $sp, 192
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
