define dso_local i32 @main() #0 {
  %1 = alloca float, align 4
  store float 0x40163851E0000000, float* %1, align 4
  %2 = load float, float* %1, align 4
  %3 = fcmp ogt float %2, 1.000000e+00
  br i1 %3, label %4, label %7
4:
  %5 = alloca i32, align 4
  store i32 233, i32* %5, align 4
  %6 = load i32, i32* %5, align 4
  ret i32 %6
7:
  %8 = alloca i32, align 4
  store i32 233, i32* %8, align 4
  %9 = load i32, i32* %8, align 4
  ret i32 %9
}
