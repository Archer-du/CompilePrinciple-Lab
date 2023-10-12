#include "cminusf_builder.hpp"
#include "GlobalVariable.hpp"
#include "ast.hpp"
#include "logging.hpp"
#include <cassert>

#define CONST_FP(num) ConstantFP::get((float)num, module.get())
#define CONST_INT(num) ConstantInt::get(num, module.get())

// types
Type *VOID_T;
Type *INT1_T;
Type *INT32_T;
Type *INT32PTR_T;
Type *FLOAT_T;
Type *FLOATPTR_T;

/*
 * use CMinusfBuilder::Scope to construct scopes
 * scope.enter: enter a new scope
 * scope.exit: exit current scope
 * scope.push: add a new binding to current scope
 * scope.find: find and return the value bound to the name
 */

Value* CminusfBuilder::visit(ASTProgram &node) {
    VOID_T = module->get_void_type();
    INT1_T = module->get_int1_type();
    INT32_T = module->get_int32_type();
    INT32PTR_T = module->get_int32_ptr_type();
    FLOAT_T = module->get_float_type();
    FLOATPTR_T = module->get_float_ptr_type();

    Value *ret_val = nullptr;
    for (auto &decl : node.declarations) {
        ret_val = decl->accept(*this);
    }
    return ret_val;
}

//设置context.val和context.type，返回num的Value指针
Value* CminusfBuilder::visit(ASTNum &node) {
    // This function is empty now.
    // Add some code here.
    if(node.type == TYPE_INT){
        context.val = CONST_INT(node.i_val);
    }
    else{
        context.val = CONST_FP(node.f_val);
    }
    context.type = context.val->get_type();
    context.ptr = nullptr;
    return context.val;
}

//返回变量空间的地址
Value* CminusfBuilder::visit(ASTVarDeclaration &node) {
    // This function is empty now.
    // Add some code here.
    Value *alloc = nullptr;
    if(node.type == TYPE_INT){
        if(node.num != nullptr){
            auto arrayType = ArrayType::get(INT32_T, node.num->i_val);
            //global
            if(context.func == nullptr)
                alloc = GlobalVariable::create(node.id, module.get(), arrayType, 
                                               false, ConstantZero::get(INT32_T, module.get()));
            //local
            else
                alloc = builder->create_alloca(arrayType);
        }
        else{
            //global
            if(context.func == nullptr)
                alloc = GlobalVariable::create(node.id, module.get(), INT32_T, 
                                               false, ConstantZero::get(INT32_T, module.get()));
            //local
            else
                alloc = builder->create_alloca(INT32_T);
        }
    }
    else if(node.type == TYPE_FLOAT){
        if(node.num != nullptr){
            auto arrayType = ArrayType::get(FLOAT_T, node.num->i_val);
            //global
            if(context.func == nullptr)
                alloc = GlobalVariable::create(node.id, module.get(), arrayType, 
                                               false, ConstantZero::get(FLOAT_T, module.get()));
            //local
            else
                alloc = builder->create_alloca(arrayType);
        }
        else{
            //global
            if(context.func == nullptr)
                alloc = GlobalVariable::create(node.id, module.get(), FLOAT_T, 
                                               false, ConstantZero::get(FLOAT_T, module.get()));
            //local
            else
                alloc = builder->create_alloca(FLOAT_T);
        }
    }
    else{
        LOG(ERROR) << "param type error."; 
        return nullptr;
    }
    scope.push(node.id, alloc);
    context.val = nullptr;
    context.ptr = alloc;
    return alloc;
}

Value* CminusfBuilder::visit(ASTFunDeclaration &node) {
    FunctionType *fun_type;
    Type *ret_type;
    std::vector<Type *> param_types;
    if (node.type == TYPE_INT)
        ret_type = INT32_T;
    else if (node.type == TYPE_FLOAT)
        ret_type = FLOAT_T;
    else
        ret_type = VOID_T;

    for (auto &param : node.params) {
        // Please accomplish param_types.
        param->accept(*this);
        param_types.push_back(context.type);
    }

    fun_type = FunctionType::get(ret_type, param_types);
    auto func = Function::create(fun_type, node.id, module.get());
    scope.push(node.id, func);
    context.func = func;
    auto funBB = BasicBlock::create(module.get(), "entry", func);
    builder->set_insert_point(funBB);
    scope.enter();
    std::vector<Value *> args;
    for (auto &arg : func->get_args()) {
        args.push_back(&arg);
    }
    for (int i = 0; i < node.params.size(); ++i) {
        // You need to deal with params and store them in the scope.
        auto alloc = builder->create_alloca(args[i]->get_type());
        builder->create_store(args[i], alloc);
        scope.push(node.params[i]->id, alloc);
    }
    node.compound_stmt->accept(*this);
    if (not builder->get_insert_block()->is_terminated()) 
    {
        if (context.func->get_return_type()->is_void_type())
            builder->create_void_ret();
        else if (context.func->get_return_type()->is_float_type())
            builder->create_ret(CONST_FP(0.));
        else
            builder->create_ret(CONST_INT(0));
    }
    scope.exit();
    context.func = nullptr;
    return nullptr;
}

Value* CminusfBuilder::visit(ASTParam &node) {
    // This function is empty now.
    // Add some code here.
    switch (node.type) {
        case TYPE_INT: 
        context.type = (node.isarray? INT32PTR_T: INT32_T);
        break;
        case TYPE_FLOAT:
        context.type = (node.isarray? FLOATPTR_T: FLOAT_T);
        break;
        default: 
        LOG(ERROR) << "param type error."; 
        break;
    }
    return nullptr;
}

Value* CminusfBuilder::visit(ASTCompoundStmt &node) {
    // TODO: This function is not complete.
    // You may need to add some code here
    // to deal with complex statements. 
    scope.enter();
    for (auto &decl : node.local_declarations) {
        decl->accept(*this);
    }

    for (auto &stmt : node.statement_list) {
        stmt->accept(*this);
        // if (not builder->get_insert_block()->is_terminated())
        //     break;
    }
    scope.exit();
    return nullptr;
}

Value* CminusfBuilder::visit(ASTExpressionStmt &node) {
    // This function is empty now.
    // Add some code here.
    if(node.expression != nullptr){
        return node.expression->accept(*this);
    }
    return nullptr;
}

Value* CminusfBuilder::visit(ASTSelectionStmt &node) {
    // This function is empty now.
    // Add some code here.
    auto trueBB = BasicBlock::create(module.get(), "", context.func);
    auto retBB = BasicBlock::create(module.get(), "", context.func);
    scope.enter();
    node.expression->accept(*this);
    if(context.val == nullptr){
        context.val = builder->create_load(context.ptr);
    }
    if(not context.type->is_int1_type()){
        if(context.type->is_float_type()){
            context.val = builder->create_fcmp_gt(context.val, CONST_FP(0));
        }
        else if(context.type->is_int32_type()){
            context.val = builder->create_icmp_gt(context.val, CONST_INT(0));
        }
    }
    if(node.else_statement != nullptr){
        auto falseBB = BasicBlock::create(module.get(), "", context.func);
        builder->create_cond_br(context.val, trueBB, falseBB);

        builder->set_insert_point(trueBB);
        node.if_statement->accept(*this);
        if(not builder->get_insert_block()->is_terminated()){
            builder->create_br(retBB);
        }

        builder->set_insert_point(falseBB);
        node.else_statement->accept(*this);
    }
    else{
        builder->create_cond_br(context.val, trueBB, retBB);

        builder->set_insert_point(trueBB);
        node.if_statement->accept(*this);
    }
    if(not builder->get_insert_block()->is_terminated()){
        builder->create_br(retBB);
    }
    scope.exit();
    builder->set_insert_point(retBB);
    return nullptr;
}

Value* CminusfBuilder::visit(ASTIterationStmt &node) {
    // This function is empty now.
    // Add some code here.
    auto condBB = BasicBlock::create(module.get(), "", context.func);
    auto whileBB = BasicBlock::create(module.get(), "", context.func);
    auto retBB = BasicBlock::create(module.get(), "", context.func);
    scope.enter();
    builder->create_br(condBB);
    builder->set_insert_point(condBB);
    node.expression->accept(*this);
    if(context.val == nullptr){
        context.val = builder->create_load(context.ptr);
    }
    if(not context.type->is_int1_type()){
        if(context.type->is_float_type()){
            context.val = builder->create_fcmp_gt(context.val, CONST_FP(0));
        }
        else if(context.type->is_int32_type()){
            context.val = builder->create_icmp_gt(context.val, CONST_INT(0));
        }
    }
    builder->create_cond_br(context.val, whileBB, retBB);

    builder->set_insert_point(whileBB);
    node.statement->accept(*this);
    if(not builder->get_insert_block()->is_terminated()){
        builder->create_br(condBB);
    }
    scope.exit();

    builder->set_insert_point(retBB);
    return nullptr;
}

Value* CminusfBuilder::visit(ASTReturnStmt &node) {
    if (node.expression == nullptr) {
        builder->create_void_ret();
        return nullptr;
    } else {
        // The given code is incomplete.
        // You need to solve other return cases (e.g. return an integer).
        node.expression->accept(*this);
        if(context.val == nullptr){
            context.val = builder->create_load(context.ptr);
        }
        if(context.type->is_int1_type()){
            context.val = builder->create_zext(context.val, INT32_T);
            context.type = INT32_T;
        }
        assert((context.type->is_int32_type() || context.type->is_float_type()) &&
               "invalid return type");
        if(context.func->get_return_type()->is_float_type() && context.type->is_int32_type()){
            context.val = builder->create_sitofp(context.val, FLOAT_T);
        }
        if(context.func->get_return_type()->is_int32_type() && context.type->is_float_type()){
            context.val = builder->create_fptosi(context.val, INT32_T);
        }
        builder->create_ret(context.val);
    }
    return nullptr;
}

Value* CminusfBuilder::visit(ASTVar &node) {
    // This function is empty now.
    // Add some code here.
    if(node.expression == nullptr){
        context.ptr = scope.find(node.id);
    }
    //数组类型
    else{
        node.expression->accept(*this);
        Value* val = context.val;
        if(val == nullptr){
            val = builder->create_load(context.ptr);
        }
        if(context.type->is_int1_type()){
            val = builder->create_zext(val, INT32_T);
        }
        if(context.type->is_float_type()){
            val = builder->create_fptosi(val, INT32_T);
        }
        context.type = INT32_T;
        auto pos = builder->create_icmp_ge(val, CONST_INT(0));
        auto excp = BasicBlock::create(module.get(), "", context.func);
        auto ctn = BasicBlock::create(module.get(), "", context.func);
        builder->create_cond_br(pos, ctn, excp);

        builder->set_insert_point(excp);
        builder->create_call(scope.find("neg_idx_except"), std::vector<Value *>()); 
        builder->create_br(ctn);

        builder->set_insert_point(ctn);
        assert((context.type->is_int32_type() || context.type->is_float_type()) &&
               "invalid index type");

        auto idx = val;
        if(scope.find(node.id)->get_type()->get_pointer_element_type()->is_pointer_type()){
            auto load = builder->create_load(scope.find(node.id));
            context.ptr = builder->create_gep(load, {idx});
        }
        else{
            context.ptr = builder->create_gep(scope.find(node.id), {CONST_INT(0), idx});
        }
    }
    context.val = nullptr;
    context.type = context.ptr->get_type()->get_pointer_element_type();
    return nullptr;
}

Value* CminusfBuilder::visit(ASTAssignExpression &node) {
    // This function is empty now.
    // Add some code here.
    node.var->accept(*this);
    auto ptr = context.ptr;
    auto d_type = context.type;
    node.expression->accept(*this);
    if(context.val == nullptr){
        context.val = builder->create_load(context.ptr);
    }
    auto val = context.val;
    auto s_type = context.type;
    if(s_type->is_int1_type()){
        val = builder->create_zext(val, INT32_T);
        s_type = INT32_T;
    }
    assert((s_type->is_int32_type() || s_type->is_float_type()) &&
           (d_type->is_int32_type() || d_type->is_float_type()) &&
           "failed assigning expr of invalid type");
    if(d_type->is_float_type() && s_type->is_int32_type()){
        val = builder->create_sitofp(val, FLOAT_T);
    }
    if(d_type->is_int32_type() && s_type->is_float_type()){
        val = builder->create_fptosi(val, INT32_T);
    }
    builder->create_store(val, ptr);
    context.val = val;
    return nullptr;
}

Value* CminusfBuilder::visit(ASTSimpleExpression &node) {
    // This function is empty now.
    // Add some code here.
    if(node.additive_expression_r == nullptr){
        return node.additive_expression_l->accept(*this);
    }
    else{
        node.additive_expression_l->accept(*this);
        if(context.val == nullptr){
            context.val = builder->create_load(context.ptr);
        }
        auto l_val = context.val;
        auto l_type = context.type;
        if(l_type->is_int1_type()){
            l_val = builder->create_zext(l_val, INT32_T);
            l_type = INT32_T;
        }
        node.additive_expression_r->accept(*this);
        if(context.val == nullptr){
            context.val = builder->create_load(context.ptr);
        }
        auto r_val = context.val;
        auto r_type = context.type;
        if(r_type->is_int1_type()){
            r_val = builder->create_zext(r_val, INT32_T);
            r_type = INT32_T;
        }
        assert((r_type->is_int32_type() || r_type->is_float_type()) &&
               (l_type->is_int32_type() || l_type->is_float_type()) &&
               "invalid spl expr operator");

        context.type = INT1_T;
        if(l_type->is_float_type() && r_type->is_int32_type()){
            r_val = builder->create_sitofp(r_val, FLOAT_T);
        }
        if(l_type->is_int32_type() && r_type->is_float_type()){
            l_val = builder->create_sitofp(l_val, FLOAT_T);
        }
        switch (node.op) {
            case OP_LE:
            if(l_type->is_int32_type() && r_type->is_int32_type()){
                context.val = builder->create_icmp_le(l_val, r_val);
            }
            else{
                context.val = builder->create_fcmp_le(l_val, r_val);
            }
            break;
            case OP_LT:
            if(l_type->is_int32_type() && r_type->is_int32_type()){
                context.val = builder->create_icmp_lt(l_val, r_val);
            }
            else{
                context.val = builder->create_fcmp_lt(l_val, r_val);
            }
            break;
            case OP_GE:
            if(l_type->is_int32_type() && r_type->is_int32_type()){
                context.val = builder->create_icmp_ge(l_val, r_val);
            }
            else{
                context.val = builder->create_fcmp_ge(l_val, r_val);
            }
            break;
            case OP_GT:
            if(l_type->is_int32_type() && r_type->is_int32_type()){
                context.val = builder->create_icmp_gt(l_val, r_val);
            }
            else{
                context.val = builder->create_fcmp_gt(l_val, r_val);
            }
            break;
            case OP_EQ:
            if(l_type->is_int32_type() && r_type->is_int32_type()){
                context.val = builder->create_icmp_eq(l_val, r_val);
            }
            else{
                context.val = builder->create_fcmp_eq(l_val, r_val);
            }
            break;
            case OP_NEQ:
            if(l_type->is_int32_type() && r_type->is_int32_type()){
                context.val = builder->create_icmp_ne(l_val, r_val);
            }
            else{
                context.val = builder->create_fcmp_ne(l_val, r_val);
            }
            break;
            default:
            LOG(ERROR) << "relop error";
            break;
        }
    }
    return nullptr;
}

Value* CminusfBuilder::visit(ASTAdditiveExpression &node) {
    // This function is empty now.
    // Add some code here.
    if(node.additive_expression == nullptr){
        node.term->accept(*this);
    }
    else{
        node.additive_expression->accept(*this);
        if(context.val == nullptr){
            context.val = builder->create_load(context.ptr);
        }
        auto l_val = context.val;
        auto l_type = context.type;
        if(l_type->is_int1_type()){
            l_val = builder->create_zext(l_val, INT32_T);
            l_type = INT32_T;
        }
        node.term->accept(*this);
        if(context.val == nullptr){
            context.val = builder->create_load(context.ptr);
        }
        auto r_val = context.val;
        auto r_type = context.type;
        if(r_type->is_int1_type()){
            r_val = builder->create_zext(r_val, INT32_T);
            r_type = INT32_T;
        }
        assert((r_type->is_int32_type() || r_type->is_float_type()) &&
               (l_type->is_int32_type() || l_type->is_float_type()) &&
               "invalid add expr operator");
        if(node.op == OP_PLUS){
            if(l_type->is_int32_type() && r_type->is_int32_type()){
                context.val = builder->create_iadd(l_val, r_val);
                context.type = INT32_T;
            }
            else{
                if(r_type->is_int32_type()){
                    r_val = builder->create_sitofp(r_val, FLOAT_T);
                }
                if(l_type->is_int32_type()){
                    l_val = builder->create_sitofp(l_val, INT32_T);
                }
                context.val = builder->create_fadd(l_val, r_val);
                context.type = FLOAT_T;
            }
        }
        //node.op == OP_MINUS
        else if(node.op == OP_MINUS){
            if(l_type->is_int32_type() && r_type->is_int32_type()){
                context.val = builder->create_isub(l_val, r_val);
                context.type = INT32_T;
            }
            else{
                if(r_type->is_int32_type()){
                    r_val = builder->create_sitofp(r_val, FLOAT_T);
                }
                if(l_type->is_int32_type()){
                    l_val = builder->create_sitofp(l_val, INT32_T);
                }
                context.val = builder->create_fsub(l_val, r_val);
                context.type = FLOAT_T;
            }
        }
    }
    return nullptr;
}

Value* CminusfBuilder::visit(ASTTerm &node) {
    // This function is empty now.
    // Add some code here.
    if(node.term == nullptr){
        node.factor->accept(*this);
    }
    else{
        node.term->accept(*this);
        if(context.val == nullptr){
            context.val = builder->create_load(context.ptr);
        }
        auto l_val = context.val;
        auto l_type = context.type;
        if(l_type->is_int1_type()){
            l_val = builder->create_zext(l_val, INT32_T);
            l_type = INT32_T;
        }
        node.factor->accept(*this);
        if(context.val == nullptr){
            context.val = builder->create_load(context.ptr);
        }
        auto r_val = context.val;
        auto r_type = context.type;
        if(r_type->is_int1_type()){
            r_val = builder->create_zext(r_val, INT32_T);
            r_type = INT32_T;
        }
        assert((r_type->is_int32_type() || r_type->is_float_type()) &&
               (l_type->is_int32_type() || l_type->is_float_type()) &&
               "invalid term operator");
        if(node.op == OP_MUL){
            if(l_type->is_int32_type() && r_type->is_int32_type()){
                context.val = builder->create_imul(l_val, r_val);
                context.type = INT32_T;
            }
            else{
                if(r_type->is_int32_type()){
                    r_val = builder->create_sitofp(r_val, FLOAT_T);
                }
                if(l_type->is_int32_type()){
                    l_val = builder->create_sitofp(l_val, INT32_T);
                }
                context.val = builder->create_fmul(l_val, r_val);
                context.type = FLOAT_T;
            }
        }
        else{
            if(l_type->is_int32_type() && r_type->is_int32_type()){
                context.val = builder->create_isdiv(l_val, r_val);
                context.type = INT32_T;
            }
            else{
                if(r_type->is_int32_type()){
                    r_val = builder->create_sitofp(r_val, FLOAT_T);
                }
                if(l_type->is_int32_type()){
                    l_val = builder->create_sitofp(l_val, INT32_T);
                }
                context.val = builder->create_fdiv(l_val, r_val);
                context.type = FLOAT_T;
            }
        }
    }
    return nullptr;
}

Value* CminusfBuilder::visit(ASTCall &node) {
    // This function is empty now.
    // Add some code here.
    auto func = static_cast<Function *>(scope.find(node.id));
    std::vector<Value *> args;
    for(auto& arg : node.args){
        arg->accept(*this);
        //var 类型访问
        if(context.val == nullptr){
            if(context.ptr->get_type()->get_pointer_element_type()->is_float_type() ||
                context.ptr->get_type()->get_pointer_element_type()->is_int32_type()){
                context.val = builder->create_load(context.ptr);
            }
            else context.val = context.ptr;
        }
        args.push_back(context.val);
    }
    for(int i = 0; i < args.size(); i++){
        Type *paramType = func->get_function_type()->get_param_type(i);
        if(args[i]->get_type()->is_int1_type()){
            args[i] = builder->create_zext(args[i], INT32_T);
        }
        Type *argType = args[i]->get_type();
        assert(argType->is_int32_type() || argType->is_float_type() || argType->is_pointer_type());
        if(paramType->is_pointer_type()){
            if(args[i]->get_type()->get_pointer_element_type()->is_pointer_type()){
                args[i] = builder->create_load(args[i]);
            }
            else{
                args[i] = builder->create_gep(args[i], {CONST_INT(0), CONST_INT(0)});
            }
        }
        if(paramType != argType){
            if(paramType->is_int32_type()){
                args[i] = builder->create_fptosi(args[i], INT32_T);
            }
            if(paramType->is_float_type()){
                args[i] = builder->create_sitofp(args[i], FLOAT_T);
            }
        }
    }
    context.val = builder->create_call(func, args);
    context.type = context.val->get_type();
    return nullptr;
}
