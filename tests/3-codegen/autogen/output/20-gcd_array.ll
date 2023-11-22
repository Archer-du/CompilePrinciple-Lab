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
  %op2 = alloca i32
  store i32 %arg0, i32* %op2
  %op3 = alloca i32
  store i32 %arg1, i32* %op3
  %op4 = load i32, i32* %op3
  %op5 = icmp eq i32 %op4, 0
  br i1 %op5, label %label6, label %label9
label6:                                                ; preds = %label_entry
  %op7 = load i32, i32* %op2
  ret i32 %op7
label8:
  ret i32 0
label9:                                                ; preds = %label_entry
  %op10 = load i32, i32* %op3
  %op11 = load i32, i32* %op2
  %op12 = load i32, i32* %op2
  %op13 = load i32, i32* %op3
  %op14 = sdiv i32 %op12, %op13
  %op15 = load i32, i32* %op3
  %op16 = mul i32 %op14, %op15
  %op17 = sub i32 %op11, %op16
  %op18 = call i32 @gcd(i32 %op10, i32 %op17)
  ret i32 %op18
}
define i32 @funArray(i32* %arg0, i32* %arg1) {
label_entry:
  %op2 = alloca i32*
  store i32* %arg0, i32** %op2
  %op3 = alloca i32*
  store i32* %arg1, i32** %op3
  %op4 = alloca i32
  %op5 = alloca i32
  %op6 = alloca i32
  %op7 = icmp sge i32 0, 0
  br i1 %op7, label %label9, label %label8
label8:                                                ; preds = %label_entry
  call void @neg_idx_except()
  br label %label9
label9:                                                ; preds = %label_entry, %label8
  %op10 = load i32*, i32** %op2
  %op11 = getelementptr i32, i32* %op10, i32 0
  %op12 = load i32, i32* %op11
  store i32 %op12, i32* %op4
  %op13 = icmp sge i32 0, 0
  br i1 %op13, label %label15, label %label14
label14:                                                ; preds = %label9
  call void @neg_idx_except()
  br label %label15
label15:                                                ; preds = %label9, %label14
  %op16 = load i32*, i32** %op3
  %op17 = getelementptr i32, i32* %op16, i32 0
  %op18 = load i32, i32* %op17
  store i32 %op18, i32* %op5
  %op19 = load i32, i32* %op4
  %op20 = load i32, i32* %op5
  %op21 = icmp slt i32 %op19, %op20
  br i1 %op21, label %label22, label %label26
label22:                                                ; preds = %label15
  %op23 = load i32, i32* %op4
  store i32 %op23, i32* %op6
  %op24 = load i32, i32* %op5
  store i32 %op24, i32* %op4
  %op25 = load i32, i32* %op6
  store i32 %op25, i32* %op5
  br label %label26
label26:                                                ; preds = %label15, %label22
  %op27 = load i32, i32* %op4
  %op28 = load i32, i32* %op5
  %op29 = call i32 @gcd(i32 %op27, i32 %op28)
  ret i32 %op29
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
