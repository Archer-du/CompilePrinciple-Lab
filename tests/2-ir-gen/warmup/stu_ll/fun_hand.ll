define dso_local i32 @callee(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  %3 = load i32, i32* %2, align 4
  %4 = mul i32 %3, 2
  ret i32 %4
}
define dso_local i32 @main() #0 {
  %1 = call i32 @callee(i32 noundef 110)
  ret i32 %1
}
