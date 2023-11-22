; ModuleID = 'cminus'
source_filename = "/home/archer/cplabs/2023ustc-jianmu-compiler/tests/testcases_general/15-if_while.cminus"

declare i32 @input()

declare void @output(i32)

declare void @outputFloat(float)

declare void @neg_idx_except()

define i32 @main() {
label_entry:
  %op0 = alloca i32
  %op1 = alloca i32
  %op2 = alloca i32
  store i32 0, i32* %op1
  store i32 0, i32* %op2
  store i32 10, i32* %op0
  br label %label3
label3:                                                ; preds = %label_entry, %label19
  %op4 = load i32, i32* %op0
  %op5 = icmp sgt i32 %op4, 0
  br i1 %op5, label %label6, label %label11
label6:                                                ; preds = %label3
  %op7 = load i32, i32* %op0
  %op8 = sub i32 %op7, 1
  store i32 %op8, i32* %op0
  %op9 = load i32, i32* %op0
  %op10 = icmp slt i32 %op9, 5
  br i1 %op10, label %label15, label %label20
label11:                                                ; preds = %label3
  %op12 = load i32, i32* %op1
  %op13 = load i32, i32* %op2
  %op14 = add i32 %op12, %op13
  ret i32 %op14
label15:                                                ; preds = %label6
  %op16 = load i32, i32* %op1
  %op17 = load i32, i32* %op0
  %op18 = add i32 %op16, %op17
  store i32 %op18, i32* %op1
  br label %label19
label19:                                                ; preds = %label15, %label20
  br label %label3
label20:                                                ; preds = %label6
  %op21 = load i32, i32* %op2
  %op22 = load i32, i32* %op0
  %op23 = add i32 %op21, %op22
  store i32 %op23, i32* %op2
  br label %label19
}
