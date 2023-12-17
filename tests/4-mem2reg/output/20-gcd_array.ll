; ModuleID = 'cminus'
source_filename = "/home/archer/cplabs/2023ustc-jianmu-compiler/tests/testcases_general/20-gcd_array.cminus"

@x = global [1 x i32] zeroinitializer
@y = global [1 x i32] zeroinitializer
declare i32 @input()

declare void @output(i32)

declare void @outputFloat(float)

declare void @neg_idx_except()

define i32 @gcd(i32 %arg0, i32 %arg1) {
label_entry:
  %op2 = icmp eq i32 %arg1, 0
  br i1 %op2, label %label3, label %label5
label3:                                                ; preds = %label_entry
  ret i32 %arg0
label4:
  ret i32 0
label5:                                                ; preds = %label_entry
  %op6 = sdiv i32 %arg0, %arg1
  %op7 = mul i32 %op6, %arg1
  %op8 = sub i32 %arg0, %op7
  %op9 = call i32 @gcd(i32 %arg1, i32 %op8)
  ret i32 %op9
}
define i32 @funArray(i32* %arg0, i32* %arg1) {
label_entry:
  %op2 = icmp sge i32 0, 0
  br i1 %op2, label %label4, label %label3
label3:                                                ; preds = %label_entry
  call void @neg_idx_except()
  br label %label4
label4:                                                ; preds = %label_entry, %label3
  %op5 = getelementptr i32, i32* %arg0, i32 0
  %op6 = load i32, i32* %op5
  %op7 = icmp sge i32 0, 0
  br i1 %op7, label %label9, label %label8
label8:                                                ; preds = %label4
  call void @neg_idx_except()
  br label %label9
label9:                                                ; preds = %label4, %label8
  %op10 = getelementptr i32, i32* %arg1, i32 0
  %op11 = load i32, i32* %op10
  %op12 = icmp slt i32 %op6, %op11
  br i1 %op12, label %label13, label %label14
label13:                                                ; preds = %label9
  br label %label14
label14:                                                ; preds = %label9, %label13
  %op15 = phi i32 [ %op11, %label9 ], [ %op6, %label13 ]
  %op16 = phi i32 [ %op6, %label9 ], [ %op11, %label13 ]
  %op17 = call i32 @gcd(i32 %op16, i32 %op15)
  ret i32 %op17
}
define i32 @main() {
label_entry:
  %op0 = icmp sge i32 0, 0
  br i1 %op0, label %label2, label %label1
label1:                                                ; preds = %label_entry
  call void @neg_idx_except()
  br label %label2
label2:                                                ; preds = %label_entry, %label1
  %op3 = getelementptr [1 x i32], [1 x i32]* @x, i32 0, i32 0
  store i32 90, i32* %op3
  %op4 = icmp sge i32 0, 0
  br i1 %op4, label %label6, label %label5
label5:                                                ; preds = %label2
  call void @neg_idx_except()
  br label %label6
label6:                                                ; preds = %label2, %label5
  %op7 = getelementptr [1 x i32], [1 x i32]* @y, i32 0, i32 0
  store i32 18, i32* %op7
  %op8 = getelementptr [1 x i32], [1 x i32]* @x, i32 0, i32 0
  %op9 = getelementptr [1 x i32], [1 x i32]* @y, i32 0, i32 0
  %op10 = call i32 @funArray(i32* %op8, i32* %op9)
  ret i32 %op10
}
