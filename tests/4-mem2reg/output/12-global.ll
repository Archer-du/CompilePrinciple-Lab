; ModuleID = 'cminus'
source_filename = "/home/archer/cplabs/2023ustc-jianmu-compiler/tests/4-mem2reg/functional-cases/12-global.cminus"

@seed = global i32 zeroinitializer
declare i32 @input()

declare void @output(i32)

declare void @outputFloat(float)

declare void @neg_idx_except()

define i32 @randomLCG() {
label_entry:
  %op0 = load i32, i32* @seed
  %op1 = mul i32 %op0, 1103515245
  %op2 = add i32 %op1, 12345
  store i32 %op2, i32* @seed
  %op3 = load i32, i32* @seed
  ret i32 %op3
}
define i32 @randBin() {
label_entry:
  %op0 = call i32 @randomLCG()
  %op1 = icmp sgt i32 %op0, 0
  br i1 %op1, label %label2, label %label4
label2:                                                ; preds = %label_entry
  ret i32 1
label3:
  ret i32 0
label4:                                                ; preds = %label_entry
  ret i32 0
}
define i32 @returnToZeroSteps() {
label_entry:
  br label %label0
label0:                                                ; preds = %label_entry, %label17
  %op1 = phi i32 [ 0, %label_entry ], [ %op12, %label17 ]
  %op2 = phi i32 [ 0, %label_entry ], [ %op11, %label17 ]
  %op3 = icmp slt i32 %op1, 20
  br i1 %op3, label %label4, label %label7
label4:                                                ; preds = %label0
  %op5 = call i32 @randBin()
  %op6 = icmp sgt i32 %op5, 0
  br i1 %op6, label %label8, label %label14
label7:                                                ; preds = %label0
  ret i32 20
label8:                                                ; preds = %label4
  %op9 = add i32 %op2, 1
  br label %label10
label10:                                                ; preds = %label8, %label14
  %op11 = phi i32 [ %op9, %label8 ], [ %op15, %label14 ]
  %op12 = add i32 %op1, 1
  %op13 = icmp eq i32 %op11, 0
  br i1 %op13, label %label16, label %label17
label14:                                                ; preds = %label4
  %op15 = sub i32 %op2, 1
  br label %label10
label16:                                                ; preds = %label10
  ret i32 %op12
label17:                                                ; preds = %label10
  br label %label0
}
define i32 @main() {
label_entry:
  store i32 3407, i32* @seed
  br label %label0
label0:                                                ; preds = %label_entry, %label3
  %op1 = phi i32 [ 0, %label_entry ], [ %op5, %label3 ]
  %op2 = icmp slt i32 %op1, 20
  br i1 %op2, label %label3, label %label6
label3:                                                ; preds = %label0
  %op4 = call i32 @returnToZeroSteps()
  call void @output(i32 %op4)
  %op5 = add i32 %op1, 1
  br label %label0
label6:                                                ; preds = %label0
  ret i32 0
}
