define dso_local i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  store i32 10, i32* %2, align 4
  store i32 0, i32* %3, align 4
  br label %4
4:
  %5 = load i32, i32* %3, align 4
  %6 = icmp slt i32 %5, 10
  br i1 %6, label %7, label %13
7:
  %8 = load i32, i32* %3, align 4
  %9 = add i32 %8, 1
  store i32 %9, i32* %3, align 4
  %10 = load i32, i32* %2, align 4
  %11 = load i32, i32* %3, align 4
  %12 = add i32 %10, %11
  store i32 %12, i32* %2, align 4
  br label %4
13:
  %14 = load i32, i32* %2, align 4
  ret i32 %14
}
