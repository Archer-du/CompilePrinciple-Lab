	.text
	.globl main
	.type main, @function
main:
	st.d $ra, $sp, -8
	st.d $fp, $sp, -16
	addi.d $fp, $sp, 0
	addi.d $sp, $sp, -64
.main_label_entry:
# br label %label0
	addi.w $t0, $zero, 0
	st.w $t0, $fp, -20
	addi.w $t0, $zero, 10
	st.w $t0, $fp, -24
	addi.w $t0, $zero, 0
	st.w $t0, $fp, -28
	b .main_label0
.main_label0:
# %op1 = phi i32 [ 0, %label_entry ], [ %op13, %label12 ]
# %op2 = phi i32 [ 10, %label_entry ], [ %op6, %label12 ]
# %op3 = phi i32 [ 0, %label_entry ], [ %op14, %label12 ]
# %op4 = icmp sgt i32 %op2, 0
	ld.w $t0, $fp, -24
	addi.w $t1, $zero, 0
	slt $t2, $t1, $t0
	st.b $t2, $fp, -29
# br i1 %op4, label %label5, label %label8
	ld.b $t0, $fp, -29
	bnez $t0, .main_label5
	b .main_label8
.main_label5:
# %op6 = sub i32 %op2, 1
	ld.w $t0, $fp, -24
	addi.w $t1, $zero, 1
	sub.w $t2, $t0, $t1
	st.w $t2, $fp, -36
# %op7 = icmp slt i32 %op6, 5
	ld.w $t0, $fp, -36
	addi.w $t1, $zero, 5
	slt $t2, $t0, $t1
	st.b $t2, $fp, -37
# br i1 %op7, label %label10, label %label15
	ld.b $t0, $fp, -37
	bnez $t0, .main_label10
	b .main_label15
.main_label8:
# %op9 = add i32 %op1, %op3
	ld.w $t0, $fp, -20
	ld.w $t1, $fp, -28
	add.w $t2, $t0, $t1
	st.w $t2, $fp, -44
# ret i32 %op9
	ld.w $a0, $fp, -44
	b main_exit
.main_label10:
# %op11 = add i32 %op1, %op6
	ld.w $t0, $fp, -20
	ld.w $t1, $fp, -36
	add.w $t2, $t0, $t1
	st.w $t2, $fp, -48
# br label %label12
	ld.w $t0, $fp, -48
	st.w $t0, $fp, -52
	ld.w $t0, $fp, -28
	st.w $t0, $fp, -56
	b .main_label12
.main_label12:
# %op13 = phi i32 [ %op11, %label10 ], [ %op1, %label15 ]
# %op14 = phi i32 [ %op3, %label10 ], [ %op16, %label15 ]
# br label %label0
	ld.w $t0, $fp, -52
	st.w $t0, $fp, -20
	ld.w $t0, $fp, -36
	st.w $t0, $fp, -24
	ld.w $t0, $fp, -56
	st.w $t0, $fp, -28
	b .main_label0
.main_label15:
# %op16 = add i32 %op3, %op6
	ld.w $t0, $fp, -28
	ld.w $t1, $fp, -36
	add.w $t2, $t0, $t1
	st.w $t2, $fp, -60
# br label %label12
	ld.w $t0, $fp, -20
	st.w $t0, $fp, -52
	ld.w $t0, $fp, -60
	st.w $t0, $fp, -56
	b .main_label12
main_exit:
	addi.d $sp, $sp, 64
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
