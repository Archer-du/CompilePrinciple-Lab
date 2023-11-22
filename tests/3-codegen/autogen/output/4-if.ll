; ModuleID = 'cminus'
source_filename = "/home/archer/cplabs/2023ustc-jianmu-compiler/tests/3-codegen/autogen/testcases/4-if.cminus"

declare i32 @input()

declare void @output(i32)

declare void @outputFloat(float)

declare void @neg_idx_except()

define i32 @main() {
label_entry:
  %op0 = alloca i32
  %op1 = alloca i32
  %op2 = alloca i32
  store i32 11, i32* %op0
  store i32 22, i32* %op1
  store i32 33, i32* %op2
  %op3 = load i32, i32* %op0
  %op4 = load i32, i32* %op1
  %op5 = icmp sgt i32 %op3, %op4
  br i1 %op5, label %label6, label %label11
label6:                                                ; preds = %label_entry
  %op7 = load i32, i32* %op0
  %op8 = load i32, i32* %op2
  %op9 = icmp sgt i32 %op7, %op8
  br i1 %op9, label %label15, label %label18
label10:                                                ; preds = %label17, %label22
  ret i32 0
label11:                                                ; preds = %label_entry
  %op12 = load i32, i32* %op2
  %op13 = load i32, i32* %op1
  %op14 = icmp slt i32 %op12, %op13
  br i1 %op14, label %label20, label %label23
label15:                                                ; preds = %label6
  %op16 = load i32, i32* %op0
  call void @output(i32 %op16)
  br label %label17
label17:                                                ; preds = %label15, %label18
  br label %label10
label18:                                                ; preds = %label6
  %op19 = load i32, i32* %op2
  call void @output(i32 %op19)
  br label %label17
label20:                                                ; preds = %label11
  %op21 = load i32, i32* %op1
  call void @output(i32 %op21)
  br label %label22
label22:                                                ; preds = %label20, %label23
  br label %label10
label23:                                                ; preds = %label11
  %op24 = load i32, i32* %op2
  call void @output(i32 %op24)
  br label %label22
}
