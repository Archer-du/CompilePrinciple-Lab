	.text
	.globl store
	.type store, @function
store:
	st.d $ra, $sp, -8
	st.d $fp, $sp, -16
	addi.d $fp, $sp, 0
	addi.d $sp, $sp, -48
	st.d $a0, $fp, -24
	st.w $a1, $fp, -28
	st.w $a2, $fp, -32
.store_label_entry:
# %op3 = icmp sge i32 %arg1, 0
	ld.w $t0, $fp, -28
	addi.w $t1, $zero, 0
	slt $t3, $t1, $t0
	xor $t2, $t0, $t1
	nor $t2, $t2, $zero
	sltui $t2, $t2, -1
	nor $t2, $t2, $zero
	andi $t2, $t2, 1
	or $t2, $t2, $t3
	st.b $t2, $fp, -33
# br i1 %op3, label %label5, label %label4
	ld.b $t0, $fp, -33
	bnez $t0, .store_label5
	b .store_label4
.store_label4:
# call void @neg_idx_except()
	bl neg_idx_except
# br label %label5
	b .store_label5
.store_label5:
# %op6 = getelementptr i32, i32* %arg0, i32 %arg1
	ld.d $t0, $fp, -24
	ld.w $t1, $fp, -28
	bstrpick.d $t1, $t1, 31, 0
	lu12i.w $t2, 0
	ori $t2, $t2, 4
	bstrpick.d $t2, $t2, 31, 0
	mul.d $t1, $t1, $t2
	add.d $t0, $t0, $t1
	st.d $t0, $fp, -48
# store i32 %arg2, i32* %op6
	ld.d $t0, $fp, -48
	ld.w $t1, $fp, -32
	st.w $t1, $t0, 0
# ret i32 %arg2
	ld.w $a0, $fp, -32
	b store_exit
store_exit:
	addi.d $sp, $sp, 48
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
	.globl main
	.type main, @function
main:
	st.d $ra, $sp, -8
	st.d $fp, $sp, -16
	addi.d $fp, $sp, 0
	addi.d $sp, $sp, -144
.main_label_entry:
# %op0 = alloca [10 x i32]
	addi.d $t0, $fp, -64
	st.d $t0, $fp, -24
# br label %label1
	addi.w $t0, $zero, 0
	st.w $t0, $fp, -68
	b .main_label1
.main_label1:
# %op2 = phi i32 [ 0, %label_entry ], [ %op8, %label4 ]
# %op3 = icmp slt i32 %op2, 10
	ld.w $t0, $fp, -68
	addi.w $t1, $zero, 10
	slt $t2, $t0, $t1
	st.b $t2, $fp, -69
# br i1 %op3, label %label4, label %label9
	ld.b $t0, $fp, -69
	bnez $t0, .main_label4
	b .main_label9
.main_label4:
# %op5 = mul i32 %op2, 2
	ld.w $t0, $fp, -68
	addi.w $t1, $zero, 2
	mul.w $t2, $t0, $t1
	st.w $t2, $fp, -76
# %op6 = getelementptr [10 x i32], [10 x i32]* %op0, i32 0, i32 0
	ld.d $t0, $fp, -24
	addi.w $t1, $zero, 0
	bstrpick.d $t1, $t1, 31, 0
	lu12i.w $t2, 0
	ori $t2, $t2, 4
	bstrpick.d $t2, $t2, 31, 0
	mul.d $t1, $t1, $t2
	add.d $t0, $t0, $t1
	st.d $t0, $fp, -88
# %op7 = call i32 @store(i32* %op6, i32 %op2, i32 %op5)
	ld.d $a0, $fp, -88
	ld.w $a1, $fp, -68
	ld.w $a2, $fp, -76
	bl store
	st.w $a0, $fp, -92
# %op8 = add i32 %op2, 1
	ld.w $t0, $fp, -68
	addi.w $t1, $zero, 1
	add.w $t2, $t0, $t1
	st.w $t2, $fp, -96
# br label %label1
	ld.w $t0, $fp, -96
	st.w $t0, $fp, -68
	b .main_label1
.main_label9:
# br label %label10
	addi.w $t0, $zero, 0
	st.w $t0, $fp, -100
	addi.w $t0, $zero, 0
	st.w $t0, $fp, -104
	b .main_label10
.main_label10:
# %op11 = phi i32 [ 0, %label9 ], [ %op21, %label18 ]
# %op12 = phi i32 [ 0, %label9 ], [ %op22, %label18 ]
# %op13 = icmp slt i32 %op12, 10
	ld.w $t0, $fp, -104
	addi.w $t1, $zero, 10
	slt $t2, $t0, $t1
	st.b $t2, $fp, -105
# br i1 %op13, label %label14, label %label16
	ld.b $t0, $fp, -105
	bnez $t0, .main_label14
	b .main_label16
.main_label14:
# %op15 = icmp sge i32 %op12, 0
	ld.w $t0, $fp, -104
	addi.w $t1, $zero, 0
	slt $t3, $t1, $t0
	xor $t2, $t0, $t1
	nor $t2, $t2, $zero
	sltui $t2, $t2, -1
	nor $t2, $t2, $zero
	andi $t2, $t2, 1
	or $t2, $t2, $t3
	st.b $t2, $fp, -106
# br i1 %op15, label %label18, label %label17
	ld.b $t0, $fp, -106
	bnez $t0, .main_label18
	b .main_label17
.main_label16:
# call void @output(i32 %op11)
	ld.w $a0, $fp, -100
	bl output
# ret i32 0
	addi.w $a0, $zero, 0
	b main_exit
.main_label17:
# call void @neg_idx_except()
	bl neg_idx_except
# br label %label18
	b .main_label18
.main_label18:
# %op19 = getelementptr [10 x i32], [10 x i32]* %op0, i32 0, i32 %op12
	ld.d $t0, $fp, -24
	ld.w $t1, $fp, -104
	bstrpick.d $t1, $t1, 31, 0
	lu12i.w $t2, 0
	ori $t2, $t2, 4
	bstrpick.d $t2, $t2, 31, 0
	mul.d $t1, $t1, $t2
	add.d $t0, $t0, $t1
	st.d $t0, $fp, -120
# %op20 = load i32, i32* %op19
	ld.d $t0, $fp, -120
	ld.w $t0, $t0, 0
	st.w $t0, $fp, -124
# %op21 = add i32 %op11, %op20
	ld.w $t0, $fp, -100
	ld.w $t1, $fp, -124
	add.w $t2, $t0, $t1
	st.w $t2, $fp, -128
# %op22 = add i32 %op12, 1
	ld.w $t0, $fp, -104
	addi.w $t1, $zero, 1
	add.w $t2, $t0, $t1
	st.w $t2, $fp, -132
# br label %label10
	ld.w $t0, $fp, -128
	st.w $t0, $fp, -100
	ld.w $t0, $fp, -132
	st.w $t0, $fp, -104
	b .main_label10
main_exit:
	addi.d $sp, $sp, 144
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
