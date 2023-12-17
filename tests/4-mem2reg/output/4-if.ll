; ModuleID = 'cminus'
source_filename = "/home/archer/cplabs/2023ustc-jianmu-compiler/tests/4-mem2reg/functional-cases/4-if.cminus"

declare i32 @input()

declare void @output(i32)

declare void @outputFloat(float)

declare void @neg_idx_except()

define i32 @main() {
label_entry:
  %op0 = icmp sgt i32 11, 22
  br i1 %op0, label %label1, label %label4
label1:                                                ; preds = %label_entry
  %op2 = icmp sgt i32 11, 33
  br i1 %op2, label %label6, label %label8
label3:                                                ; preds = %label7, %label10
  ret i32 0
label4:                                                ; preds = %label_entry
  %op5 = icmp slt i32 33, 22
  br i1 %op5, label %label9, label %label11
label6:                                                ; preds = %label1
  call void @output(i32 11)
  br label %label7
label7:                                                ; preds = %label6, %label8
  br label %label3
label8:                                                ; preds = %label1
  call void @output(i32 33)
  br label %label7
label9:                                                ; preds = %label4
  call void @output(i32 22)
  br label %label10
label10:                                                ; preds = %label9, %label11
  br label %label3
label11:                                                ; preds = %label4
  call void @output(i32 33)
  br label %label10
}
