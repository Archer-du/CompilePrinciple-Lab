	.text
	.globl main
	.type main, @function
main:
	st.d $ra, $sp, -8
	st.d $fp, $sp, -16
	addi.d $fp, $sp, 0
	addi.d $sp, $sp, -48
.main_label_entry:
# br label %label0
	addi.w $t0, $zero, 0
	st.w $t0, $fp, -20
	addi.w $t0, $zero, 10
	st.w $t0, $fp, -24
	b .main_label0
.main_label0:
# %op1 = phi i32 [ 0, %label_entry ], [ %op9, %label13 ]
# %op2 = phi i32 [ 10, %label_entry ], [ %op5, %label13 ]
# %op3 = icmp sgt i32 %op2, 0
	ld.w $t0, $fp, -24
	addi.w $t1, $zero, 0
	slt $t2, $t1, $t0
	st.b $t2, $fp, -25
# br i1 %op3, label %label4, label %label6
	ld.b $t0, $fp, -25
	bnez $t0, .main_label4
	b .main_label6
.main_label4:
# %op5 = sub i32 %op2, 1
	ld.w $t0, $fp, -24
	addi.w $t1, $zero, 1
	sub.w $t2, $t0, $t1
	st.w $t2, $fp, -32
# br label %label8
	ld.w $t0, $fp, -32
	st.w $t0, $fp, -40
	b .main_label8
.main_label6:
# %op7 = add i32 %op2, %op1
	ld.w $t0, $fp, -24
	ld.w $t1, $fp, -20
	add.w $t2, $t0, $t1
	st.w $t2, $fp, -36
# ret i32 %op7
	ld.w $a0, $fp, -36
	b main_exit
.main_label8:
# %op9 = phi i32 [ %op5, %label4 ], [ %op12, %label11 ]
# %op10 = icmp sgt i32 %op9, 0
	ld.w $t0, $fp, -40
	addi.w $t1, $zero, 0
	slt $t2, $t1, $t0
	st.b $t2, $fp, -41
# br i1 %op10, label %label11, label %label13
	ld.b $t0, $fp, -41
	bnez $t0, .main_label11
	b .main_label13
.main_label11:
# %op12 = sub i32 %op9, 1
	ld.w $t0, $fp, -40
	addi.w $t1, $zero, 1
	sub.w $t2, $t0, $t1
	st.w $t2, $fp, -48
# br label %label8
	ld.w $t0, $fp, -48
	st.w $t0, $fp, -40
	b .main_label8
.main_label13:
# br label %label0
	ld.w $t0, $fp, -40
	st.w $t0, $fp, -20
	ld.w $t0, $fp, -32
	st.w $t0, $fp, -24
	b .main_label0
main_exit:
	addi.d $sp, $sp, 48
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra