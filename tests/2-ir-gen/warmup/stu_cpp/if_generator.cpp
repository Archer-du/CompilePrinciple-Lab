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
int main() {
    float a = 5.555;
    if (a > 1)
        return 233;
    return 0;
}
*/

int main() {
    auto module = new Module();
    auto builder = new IRBuilder(nullptr, module);
    Type *Int32Type = module->get_int32_type();
    Type *Fp32Type = module->get_float_type();

    auto mainFun = Function::create(FunctionType::get(Int32Type, {}), "main", module);
    auto bb = BasicBlock::create(module, "entry", mainFun);

    builder->set_insert_point(bb);
    auto retAlloca = builder->create_alloca(Int32Type);
    builder->create_store(CONST_INT(0), retAlloca);
    auto aAlloca = builder->create_alloca(Fp32Type);
    builder->create_store(CONST_FP(5.555), aAlloca);

    auto aLoad = builder->create_load(aAlloca);
    auto fcmp = builder->create_fcmp_gt(aLoad, CONST_FP(1));

    auto trueBB = BasicBlock::create(module, "trueBB", mainFun);
    auto retBB = BasicBlock::create(module, "", mainFun);
    auto br = builder->create_cond_br(fcmp, trueBB, retBB);

    builder->set_insert_point(trueBB);
    builder->create_store(CONST_INT(233), retAlloca);
    builder->create_br(retBB);

    builder->set_insert_point(retBB);
    auto retLoad = builder->create_load(retAlloca);
    builder->create_ret(retLoad);

    std::cout << module->print();
    delete module;
    return 0;
}
