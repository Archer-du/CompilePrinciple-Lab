; ModuleID = 'cminus'
source_filename = "/home/archer/cplabs/2023ustc-jianmu-compiler/tests/4-mem2reg/functional-cases/13-complex.cminus"

@n = global i32 zeroinitializer
@m = global i32 zeroinitializer
@w = global [5 x i32] zeroinitializer
@v = global [5 x i32] zeroinitializer
@dp = global [66 x i32] zeroinitializer
declare i32 @input()

declare void @output(i32)

declare void @outputFloat(float)

declare void @neg_idx_except()

define i32 @max(i32 %arg0, i32 %arg1) {
label_entry:
  %op2 = icmp sgt i32 %arg0, %arg1
  br i1 %op2, label %label3, label %label5
label3:                                                ; preds = %label_entry
  ret i32 %arg0
label4:
  ret i32 0
label5:                                                ; preds = %label_entry
  ret i32 %arg1
}
define i32 @knapsack(i32 %arg0, i32 %arg1) {
label_entry:
  %op2 = icmp sle i32 %arg1, 0
  br i1 %op2, label %label3, label %label4
label3:                                                ; preds = %label_entry
  ret i32 0
label4:                                                ; preds = %label_entry
  %op5 = icmp eq i32 %arg0, 0
  br i1 %op5, label %label6, label %label7
label6:                                                ; preds = %label4
  ret i32 0
label7:                                                ; preds = %label4
  %op8 = mul i32 %arg0, 11
  %op9 = add i32 %op8, %arg1
  %op10 = icmp sge i32 %op9, 0
  br i1 %op10, label %label19, label %label18
label11:                                                ; preds = %label19
  %op12 = mul i32 %arg0, 11
  %op13 = add i32 %op12, %arg1
  %op14 = icmp sge i32 %op13, 0
  br i1 %op14, label %label24, label %label23
label15:                                                ; preds = %label19
  %op16 = sub i32 %arg0, 1
  %op17 = icmp sge i32 %op16, 0
  br i1 %op17, label %label36, label %label35
label18:                                                ; preds = %label7
  call void @neg_idx_except()
  br label %label19
label19:                                                ; preds = %label7, %label18
  %op20 = getelementptr [66 x i32], [66 x i32]* @dp, i32 0, i32 %op9
  %op21 = load i32, i32* %op20
  %op22 = icmp sge i32 %op21, 0
  br i1 %op22, label %label11, label %label15
label23:                                                ; preds = %label11
  call void @neg_idx_except()
  br label %label24
label24:                                                ; preds = %label11, %label23
  %op25 = getelementptr [66 x i32], [66 x i32]* @dp, i32 0, i32 %op13
  %op26 = load i32, i32* %op25
  ret i32 %op26
label27:                                                ; preds = %label36
  %op28 = sub i32 %arg0, 1
  %op29 = call i32 @knapsack(i32 %op28, i32 %arg1)
  br label %label30
label30:                                                ; preds = %label27, %label55
  %op31 = phi i32 [ %op29, %label27 ], [ %op59, %label55 ]
  %op32 = mul i32 %arg0, 11
  %op33 = add i32 %op32, %arg1
  %op34 = icmp sge i32 %op33, 0
  br i1 %op34, label %label61, label %label60
label35:                                                ; preds = %label15
  call void @neg_idx_except()
  br label %label36
label36:                                                ; preds = %label15, %label35
  %op37 = getelementptr [5 x i32], [5 x i32]* @w, i32 0, i32 %op16
  %op38 = load i32, i32* %op37
  %op39 = icmp slt i32 %arg1, %op38
  br i1 %op39, label %label27, label %label40
label40:                                                ; preds = %label36
  %op41 = sub i32 %arg0, 1
  %op42 = call i32 @knapsack(i32 %op41, i32 %arg1)
  %op43 = sub i32 %arg0, 1
  %op44 = sub i32 %arg0, 1
  %op45 = icmp sge i32 %op44, 0
  br i1 %op45, label %label47, label %label46
label46:                                                ; preds = %label40
  call void @neg_idx_except()
  br label %label47
label47:                                                ; preds = %label40, %label46
  %op48 = getelementptr [5 x i32], [5 x i32]* @w, i32 0, i32 %op44
  %op49 = load i32, i32* %op48
  %op50 = sub i32 %arg1, %op49
  %op51 = call i32 @knapsack(i32 %op43, i32 %op50)
  %op52 = sub i32 %arg0, 1
  %op53 = icmp sge i32 %op52, 0
  br i1 %op53, label %label55, label %label54
label54:                                                ; preds = %label47
  call void @neg_idx_except()
  br label %label55
label55:                                                ; preds = %label47, %label54
  %op56 = getelementptr [5 x i32], [5 x i32]* @v, i32 0, i32 %op52
  %op57 = load i32, i32* %op56
  %op58 = add i32 %op51, %op57
  %op59 = call i32 @max(i32 %op42, i32 %op58)
  br label %label30
label60:                                                ; preds = %label30
  call void @neg_idx_except()
  br label %label61
label61:                                                ; preds = %label30, %label60
  %op62 = getelementptr [66 x i32], [66 x i32]* @dp, i32 0, i32 %op33
  store i32 %op31, i32* %op62
  ret i32 %op31
}
define i32 @main() {
label_entry:
  store i32 5, i32* @n
  store i32 10, i32* @m
  %op0 = icmp sge i32 0, 0
  br i1 %op0, label %label2, label %label1
label1:                                                ; preds = %label_entry
  call void @neg_idx_except()
  br label %label2
label2:                                                ; preds = %label_entry, %label1
  %op3 = getelementptr [5 x i32], [5 x i32]* @w, i32 0, i32 0
  store i32 2, i32* %op3
  %op4 = icmp sge i32 1, 0
  br i1 %op4, label %label6, label %label5
label5:                                                ; preds = %label2
  call void @neg_idx_except()
  br label %label6
label6:                                                ; preds = %label2, %label5
  %op7 = getelementptr [5 x i32], [5 x i32]* @w, i32 0, i32 1
  store i32 2, i32* %op7
  %op8 = icmp sge i32 2, 0
  br i1 %op8, label %label10, label %label9
label9:                                                ; preds = %label6
  call void @neg_idx_except()
  br label %label10
label10:                                                ; preds = %label6, %label9
  %op11 = getelementptr [5 x i32], [5 x i32]* @w, i32 0, i32 2
  store i32 6, i32* %op11
  %op12 = icmp sge i32 3, 0
  br i1 %op12, label %label14, label %label13
label13:                                                ; preds = %label10
  call void @neg_idx_except()
  br label %label14
label14:                                                ; preds = %label10, %label13
  %op15 = getelementptr [5 x i32], [5 x i32]* @w, i32 0, i32 3
  store i32 5, i32* %op15
  %op16 = icmp sge i32 4, 0
  br i1 %op16, label %label18, label %label17
label17:                                                ; preds = %label14
  call void @neg_idx_except()
  br label %label18
label18:                                                ; preds = %label14, %label17
  %op19 = getelementptr [5 x i32], [5 x i32]* @w, i32 0, i32 4
  store i32 4, i32* %op19
  %op20 = icmp sge i32 0, 0
  br i1 %op20, label %label22, label %label21
label21:                                                ; preds = %label18
  call void @neg_idx_except()
  br label %label22
label22:                                                ; preds = %label18, %label21
  %op23 = getelementptr [5 x i32], [5 x i32]* @v, i32 0, i32 0
  store i32 6, i32* %op23
  %op24 = icmp sge i32 1, 0
  br i1 %op24, label %label26, label %label25
label25:                                                ; preds = %label22
  call void @neg_idx_except()
  br label %label26
label26:                                                ; preds = %label22, %label25
  %op27 = getelementptr [5 x i32], [5 x i32]* @v, i32 0, i32 1
  store i32 3, i32* %op27
  %op28 = icmp sge i32 2, 0
  br i1 %op28, label %label30, label %label29
label29:                                                ; preds = %label26
  call void @neg_idx_except()
  br label %label30
label30:                                                ; preds = %label26, %label29
  %op31 = getelementptr [5 x i32], [5 x i32]* @v, i32 0, i32 2
  store i32 5, i32* %op31
  %op32 = icmp sge i32 3, 0
  br i1 %op32, label %label34, label %label33
label33:                                                ; preds = %label30
  call void @neg_idx_except()
  br label %label34
label34:                                                ; preds = %label30, %label33
  %op35 = getelementptr [5 x i32], [5 x i32]* @v, i32 0, i32 3
  store i32 4, i32* %op35
  %op36 = icmp sge i32 4, 0
  br i1 %op36, label %label38, label %label37
label37:                                                ; preds = %label34
  call void @neg_idx_except()
  br label %label38
label38:                                                ; preds = %label34, %label37
  %op39 = getelementptr [5 x i32], [5 x i32]* @v, i32 0, i32 4
  store i32 6, i32* %op39
  br label %label40
label40:                                                ; preds = %label38, %label50
  %op41 = phi i32 [ 0, %label38 ], [ %op53, %label50 ]
  %op42 = icmp slt i32 %op41, 66
  br i1 %op42, label %label43, label %label45
label43:                                                ; preds = %label40
  %op44 = icmp sge i32 %op41, 0
  br i1 %op44, label %label50, label %label49
label45:                                                ; preds = %label40
  %op46 = load i32, i32* @n
  %op47 = load i32, i32* @m
  %op48 = call i32 @knapsack(i32 %op46, i32 %op47)
  call void @output(i32 %op48)
  ret i32 0
label49:                                                ; preds = %label43
  call void @neg_idx_except()
  br label %label50
label50:                                                ; preds = %label43, %label49
  %op51 = getelementptr [66 x i32], [66 x i32]* @dp, i32 0, i32 %op41
  %op52 = sub i32 0, 1
  store i32 %op52, i32* %op51
  %op53 = add i32 %op41, 1
  br label %label40
}
