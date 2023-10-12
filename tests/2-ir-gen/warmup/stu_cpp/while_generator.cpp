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
    int a;
    int i;
    a = 10;
    i = 0;
    while (i < 10) {
        i = i + 1;
        a = a + i;
    }
    return a;
}
*/

int main() {
    auto module = new Module();
    auto builder = new IRBuilder(nullptr, module);
    Type *Int32Type = module->get_int32_type();

    auto mainFun = Function::create(FunctionType::get(Int32Type, {}), "main", module);
    auto bb = BasicBlock::create(module, "entry", mainFun);

    builder->set_insert_point(bb);
    auto retAlloca = builder->create_alloca(Int32Type);
    builder->create_store(CONST_INT(0), retAlloca);
    auto aAlloca = builder->create_alloca(Int32Type);
    builder->create_store(CONST_INT(10), aAlloca);
    auto iAlloca = builder->create_alloca(Int32Type);
    builder->create_store(CONST_INT(0), iAlloca);

    auto condBB = BasicBlock::create(module, "condBB", mainFun);
    auto whileBB = BasicBlock::create(module, "whileBB", mainFun);
    auto retBB = BasicBlock::create(module, "", mainFun);

    builder->create_br(condBB);

    builder->set_insert_point(condBB);
    auto iLoad = builder->create_load(iAlloca);
    auto icmp = builder->create_icmp_lt(iLoad, CONST_INT(10));
    auto br = builder->create_cond_br(icmp, whileBB, retBB);

    builder->set_insert_point(whileBB);
    iLoad = builder->create_load(iAlloca);
    auto add = builder->create_iadd(iLoad, CONST_INT(1));
    builder->create_store(add, iAlloca);
    auto aLoad = builder->create_load(aAlloca);
    iLoad = builder->create_load(iAlloca);
    add = builder->create_iadd(aLoad, iLoad);
    builder->create_store(add, aAlloca);
    builder->create_br(condBB);

    builder->set_insert_point(retBB);
    aLoad = builder->create_load(aAlloca);
    builder->create_store(aLoad, retAlloca);
    auto retLoad = builder->create_load(retAlloca);
    builder->create_ret(retLoad);

    std::cout << module->print();
    delete module;
    return 0;
}
