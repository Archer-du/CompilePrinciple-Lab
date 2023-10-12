define i32 @main() {
label_entry:
  %op0 = alloca i32
  store i32 0, i32* %op0
  %op1 = alloca i32
  store i32 10, i32* %op1
  %op2 = alloca i32
  store i32 0, i32* %op2
  br label %label_condBB
label_condBB:                                                ; preds = %label_entry, %label_whileBB
  %op3 = load i32, i32* %op2
  %op4 = icmp slt i32 %op3, 10
  br i1 %op4, label %label_whileBB, label %label10
label_whileBB:                                                ; preds = %label_condBB
  %op5 = load i32, i32* %op2
  %op6 = add i32 %op5, 1
  store i32 %op6, i32* %op2
  %op7 = load i32, i32* %op1
  %op8 = load i32, i32* %op2
  %op9 = add i32 %op7, %op8
  store i32 %op9, i32* %op1
  br label %label_condBB
label10:                                                ; preds = %label_condBB
  %op11 = load i32, i32* %op1
  store i32 %op11, i32* %op0
  %op12 = load i32, i32* %op0
  ret i32 %op12
}
