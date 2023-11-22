; ModuleID = 'cminus'
source_filename = "/home/archer/cplabs/2023ustc-jianmu-compiler/tests/3-codegen/autogen/testcases/13-complex.cminus"

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
  %op2 = alloca i32
  store i32 %arg0, i32* %op2
  %op3 = alloca i32
  store i32 %arg1, i32* %op3
  %op4 = load i32, i32* %op2
  %op5 = load i32, i32* %op3
  %op6 = icmp sgt i32 %op4, %op5
  br i1 %op6, label %label7, label %label10
label7:                                                ; preds = %label_entry
  %op8 = load i32, i32* %op2
  ret i32 %op8
label9:
  ret i32 0
label10:                                                ; preds = %label_entry
  %op11 = load i32, i32* %op3
  ret i32 %op11
}
define i32 @knapsack(i32 %arg0, i32 %arg1) {
label_entry:
  %op2 = alloca i32
  store i32 %arg0, i32* %op2
  %op3 = alloca i32
  store i32 %arg1, i32* %op3
  %op4 = alloca i32
  %op5 = load i32, i32* %op3
  %op6 = icmp sle i32 %op5, 0
  br i1 %op6, label %label7, label %label8
label7:                                                ; preds = %label_entry
  ret i32 0
label8:                                                ; preds = %label_entry
  %op9 = load i32, i32* %op2
  %op10 = icmp eq i32 %op9, 0
  br i1 %op10, label %label11, label %label12
label11:                                                ; preds = %label8
  ret i32 0
label12:                                                ; preds = %label8
  %op13 = load i32, i32* %op2
  %op14 = mul i32 %op13, 11
  %op15 = load i32, i32* %op3
  %op16 = add i32 %op14, %op15
  %op17 = icmp sge i32 %op16, 0
  br i1 %op17, label %label30, label %label29
label18:                                                ; preds = %label30
  %op19 = load i32, i32* %op2
  %op20 = mul i32 %op19, 11
  %op21 = load i32, i32* %op3
  %op22 = add i32 %op20, %op21
  %op23 = icmp sge i32 %op22, 0
  br i1 %op23, label %label35, label %label34
label24:                                                ; preds = %label30
  %op25 = load i32, i32* %op3
  %op26 = load i32, i32* %op2
  %op27 = sub i32 %op26, 1
  %op28 = icmp sge i32 %op27, 0
  br i1 %op28, label %label50, label %label49
label29:                                                ; preds = %label12
  call void @neg_idx_except()
  br label %label30
label30:                                                ; preds = %label12, %label29
  %op31 = getelementptr [66 x i32], [66 x i32]* @dp, i32 0, i32 %op16
  %op32 = load i32, i32* %op31
  %op33 = icmp sge i32 %op32, 0
  br i1 %op33, label %label18, label %label24
label34:                                                ; preds = %label18
  call void @neg_idx_except()
  br label %label35
label35:                                                ; preds = %label18, %label34
  %op36 = getelementptr [66 x i32], [66 x i32]* @dp, i32 0, i32 %op22
  %op37 = load i32, i32* %op36
  ret i32 %op37
label38:                                                ; preds = %label50
  %op39 = load i32, i32* %op2
  %op40 = sub i32 %op39, 1
  %op41 = load i32, i32* %op3
  %op42 = call i32 @knapsack(i32 %op40, i32 %op41)
  store i32 %op42, i32* %op4
  br label %label43
label43:                                                ; preds = %label38, %label75
  %op44 = load i32, i32* %op2
  %op45 = mul i32 %op44, 11
  %op46 = load i32, i32* %op3
  %op47 = add i32 %op45, %op46
  %op48 = icmp sge i32 %op47, 0
  br i1 %op48, label %label81, label %label80
label49:                                                ; preds = %label24
  call void @neg_idx_except()
  br label %label50
label50:                                                ; preds = %label24, %label49
  %op51 = getelementptr [5 x i32], [5 x i32]* @w, i32 0, i32 %op27
  %op52 = load i32, i32* %op51
  %op53 = icmp slt i32 %op25, %op52
  br i1 %op53, label %label38, label %label54
label54:                                                ; preds = %label50
  %op55 = load i32, i32* %op2
  %op56 = sub i32 %op55, 1
  %op57 = load i32, i32* %op3
  %op58 = call i32 @knapsack(i32 %op56, i32 %op57)
  %op59 = load i32, i32* %op2
  %op60 = sub i32 %op59, 1
  %op61 = load i32, i32* %op3
  %op62 = load i32, i32* %op2
  %op63 = sub i32 %op62, 1
  %op64 = icmp sge i32 %op63, 0
  br i1 %op64, label %label66, label %label65
label65:                                                ; preds = %label54
  call void @neg_idx_except()
  br label %label66
label66:                                                ; preds = %label54, %label65
  %op67 = getelementptr [5 x i32], [5 x i32]* @w, i32 0, i32 %op63
  %op68 = load i32, i32* %op67
  %op69 = sub i32 %op61, %op68
  %op70 = call i32 @knapsack(i32 %op60, i32 %op69)
  %op71 = load i32, i32* %op2
  %op72 = sub i32 %op71, 1
  %op73 = icmp sge i32 %op72, 0
  br i1 %op73, label %label75, label %label74
label74:                                                ; preds = %label66
  call void @neg_idx_except()
  br label %label75
label75:                                                ; preds = %label66, %label74
  %op76 = getelementptr [5 x i32], [5 x i32]* @v, i32 0, i32 %op72
  %op77 = load i32, i32* %op76
  %op78 = add i32 %op70, %op77
  %op79 = call i32 @max(i32 %op58, i32 %op78)
  store i32 %op79, i32* %op4
  br label %label43
label80:                                                ; preds = %label43
  call void @neg_idx_except()
  br label %label81
label81:                                                ; preds = %label43, %label80
  %op82 = getelementptr [66 x i32], [66 x i32]* @dp, i32 0, i32 %op47
  %op83 = load i32, i32* %op4
  store i32 %op83, i32* %op82
  %op84 = load i32, i32* %op4
  ret i32 %op84
}
define i32 @main() {
label_entry:
  %op0 = alloca i32
  store i32 0, i32* %op0
  store i32 5, i32* @n
  store i32 10, i32* @m
  %op1 = icmp sge i32 0, 0
  br i1 %op1, label %label3, label %label2
label2:                                                ; preds = %label_entry
  call void @neg_idx_except()
  br label %label3
label3:                                                ; preds = %label_entry, %label2
  %op4 = getelementptr [5 x i32], [5 x i32]* @w, i32 0, i32 0
  store i32 2, i32* %op4
  %op5 = icmp sge i32 1, 0
  br i1 %op5, label %label7, label %label6
label6:                                                ; preds = %label3
  call void @neg_idx_except()
  br label %label7
label7:                                                ; preds = %label3, %label6
  %op8 = getelementptr [5 x i32], [5 x i32]* @w, i32 0, i32 1
  store i32 2, i32* %op8
  %op9 = icmp sge i32 2, 0
  br i1 %op9, label %label11, label %label10
label10:                                                ; preds = %label7
  call void @neg_idx_except()
  br label %label11
label11:                                                ; preds = %label7, %label10
  %op12 = getelementptr [5 x i32], [5 x i32]* @w, i32 0, i32 2
  store i32 6, i32* %op12
  %op13 = icmp sge i32 3, 0
  br i1 %op13, label %label15, label %label14
label14:                                                ; preds = %label11
  call void @neg_idx_except()
  br label %label15
label15:                                                ; preds = %label11, %label14
  %op16 = getelementptr [5 x i32], [5 x i32]* @w, i32 0, i32 3
  store i32 5, i32* %op16
  %op17 = icmp sge i32 4, 0
  br i1 %op17, label %label19, label %label18
label18:                                                ; preds = %label15
  call void @neg_idx_except()
  br label %label19
label19:                                                ; preds = %label15, %label18
  %op20 = getelementptr [5 x i32], [5 x i32]* @w, i32 0, i32 4
  store i32 4, i32* %op20
  %op21 = icmp sge i32 0, 0
  br i1 %op21, label %label23, label %label22
label22:                                                ; preds = %label19
  call void @neg_idx_except()
  br label %label23
label23:                                                ; preds = %label19, %label22
  %op24 = getelementptr [5 x i32], [5 x i32]* @v, i32 0, i32 0
  store i32 6, i32* %op24
  %op25 = icmp sge i32 1, 0
  br i1 %op25, label %label27, label %label26
label26:                                                ; preds = %label23
  call void @neg_idx_except()
  br label %label27
label27:                                                ; preds = %label23, %label26
  %op28 = getelementptr [5 x i32], [5 x i32]* @v, i32 0, i32 1
  store i32 3, i32* %op28
  %op29 = icmp sge i32 2, 0
  br i1 %op29, label %label31, label %label30
label30:                                                ; preds = %label27
  call void @neg_idx_except()
  br label %label31
label31:                                                ; preds = %label27, %label30
  %op32 = getelementptr [5 x i32], [5 x i32]* @v, i32 0, i32 2
  store i32 5, i32* %op32
  %op33 = icmp sge i32 3, 0
  br i1 %op33, label %label35, label %label34
label34:                                                ; preds = %label31
  call void @neg_idx_except()
  br label %label35
label35:                                                ; preds = %label31, %label34
  %op36 = getelementptr [5 x i32], [5 x i32]* @v, i32 0, i32 3
  store i32 4, i32* %op36
  %op37 = icmp sge i32 4, 0
  br i1 %op37, label %label39, label %label38
label38:                                                ; preds = %label35
  call void @neg_idx_except()
  br label %label39
label39:                                                ; preds = %label35, %label38
  %op40 = getelementptr [5 x i32], [5 x i32]* @v, i32 0, i32 4
  store i32 6, i32* %op40
  br label %label41
label41:                                                ; preds = %label39, %label52
  %op42 = load i32, i32* %op0
  %op43 = icmp slt i32 %op42, 66
  br i1 %op43, label %label44, label %label47
label44:                                                ; preds = %label41
  %op45 = load i32, i32* %op0
  %op46 = icmp sge i32 %op45, 0
  br i1 %op46, label %label52, label %label51
label47:                                                ; preds = %label41
  %op48 = load i32, i32* @n
  %op49 = load i32, i32* @m
  %op50 = call i32 @knapsack(i32 %op48, i32 %op49)
  call void @output(i32 %op50)
  ret i32 0
label51:                                                ; preds = %label44
  call void @neg_idx_except()
  br label %label52
label52:                                                ; preds = %label44, %label51
  %op53 = getelementptr [66 x i32], [66 x i32]* @dp, i32 0, i32 %op45
  %op54 = sub i32 0, 1
  store i32 %op54, i32* %op53
  %op55 = load i32, i32* %op0
  %op56 = add i32 %op55, 1
  store i32 %op56, i32* %op0
  br label %label41
}
