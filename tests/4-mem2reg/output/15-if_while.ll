; ModuleID = 'cminus'
source_filename = "/home/archer/cplabs/2023ustc-jianmu-compiler/tests/testcases_general/15-if_while.cminus"

declare i32 @input()

declare void @output(i32)

declare void @outputFloat(float)

declare void @neg_idx_except()

define i32 @main() {
label_entry:
  br label %label0
label0:                                                ; preds = %label_entry, %label12
  %op1 = phi i32 [ 0, %label_entry ], [ %op13, %label12 ]
  %op2 = phi i32 [ 10, %label_entry ], [ %op6, %label12 ]
  %op3 = phi i32 [ 0, %label_entry ], [ %op14, %label12 ]
  %op4 = icmp sgt i32 %op2, 0
  br i1 %op4, label %label5, label %label8
label5:                                                ; preds = %label0
  %op6 = sub i32 %op2, 1
  %op7 = icmp slt i32 %op6, 5
  br i1 %op7, label %label10, label %label15
label8:                                                ; preds = %label0
  %op9 = add i32 %op1, %op3
  ret i32 %op9
label10:                                                ; preds = %label5
  %op11 = add i32 %op1, %op6
  br label %label12
label12:                                                ; preds = %label10, %label15
  %op13 = phi i32 [ %op11, %label10 ], [ %op1, %label15 ]
  %op14 = phi i32 [ %op3, %label10 ], [ %op16, %label15 ]
  br label %label0
label15:                                                ; preds = %label5
  %op16 = add i32 %op3, %op6
  br label %label12
}
