#include "BasicBlock.hpp"
#include "Constant.hpp"
#include "Function.hpp"
#include "IRBuilder.hpp"
#include "Module.hpp"
#include "Type.hpp"

#include <iostream>
#include <memory>

// 定义一个从常数值获取/创建 ConstantInt 类实例化的宏，方便多次调用
#define CONST_INT(num) \
    ConstantInt::get(num, module)

// 定义一个从常数值获取/创建 ConstantFP 类实例化的宏，方便多次调用
#define CONST_FP(num) \
    ConstantFP::get(num, module)

/*
*
*int main() {
*    int a[10];
*    a[0] = 10;
*    a[1] = a[0] * 2;
*    return a[1];
*}
*/

int main() {
    auto module = new Module();
    auto builder = new IRBuilder(nullptr, module);
    Type *Int32Type = module->get_int32_type();
    auto *arrayType = ArrayType::get(Int32Type, 10);

    auto mainFun = Function::create(FunctionType::get(Int32Type, {}), "main", module);
    auto bb = BasicBlock::create(module, "entry", mainFun);
    builder->set_insert_point(bb);
    auto retAlloca = builder->create_alloca(Int32Type);
    builder->create_store(CONST_INT(0), retAlloca);

    auto aAlloca = builder->create_alloca(arrayType);

    auto aGep = builder->create_gep(aAlloca, {CONST_INT(0), CONST_INT(0)});
    builder->create_store(CONST_INT(10), aGep);

    auto aLoad = builder->create_load(aGep);
    auto mul = builder->create_imul(aLoad, CONST_INT(2));
    aGep = builder->create_gep(aAlloca, {CONST_INT(0), CONST_INT(1)});
    builder->create_store(mul, aGep);

    aLoad = builder->create_load(aGep);
    builder->create_store(aLoad, retAlloca);
    auto retLoad = builder->create_load(retAlloca);
    builder->create_ret(retLoad);

    std::cout << module->print();
    delete module;
    return 0;
}
