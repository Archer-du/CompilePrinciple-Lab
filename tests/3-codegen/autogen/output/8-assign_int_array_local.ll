; ModuleID = 'cminus'
source_filename = "/home/archer/cplabs/2023ustc-jianmu-compiler/tests/testcases_general/8-assign_int_array_local.cminus"

declare i32 @input()

declare void @output(i32)

declare void @outputFloat(float)

declare void @neg_idx_except()

define i32 @main() {
label_entry:
  %op0 = alloca [10 x i32]
  %op1 = icmp sge i32 3, 0
  br i1 %op1, label %label3, label %label2
label2:                                                ; preds = %label_entry
  call void @neg_idx_except()
  br label %label3
label3:                                                ; preds = %label_entry, %label2
  %op4 = getelementptr [10 x i32], [10 x i32]* %op0, i32 0, i32 3
  store i32 1234, i32* %op4
  %op5 = icmp sge i32 3, 0
  br i1 %op5, label %label7, label %label6
label6:                                                ; preds = %label3
  call void @neg_idx_except()
  br label %label7
label7:                                                ; preds = %label3, %label6
  %op8 = getelementptr [10 x i32], [10 x i32]* %op0, i32 0, i32 3
  %op9 = load i32, i32* %op8
  ret i32 %op9
}
