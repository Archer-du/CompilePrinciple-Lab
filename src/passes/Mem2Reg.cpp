#include "Mem2Reg.hpp"
#include "Constant.hpp"
#include "IRBuilder.hpp"
#include "Instruction.hpp"
#include "Value.hpp"

#include <cassert>
#include <iostream>
#include <map>
#include <memory>
#include <set>
#include <stack>
#include <unordered_set>

void Mem2Reg::run() {
    // 创建支配树分析 Pass 的实例
    dominators_ = std::make_unique<Dominators>(m_);
    // 建立支配树
    dominators_->run();
    // 以函数为单元遍历实现 Mem2Reg 算法
    for (auto &f : m_->get_functions()) {
        if (f.is_declaration())
            continue;
        func_ = &f;
        if (func_->get_basic_blocks().size() >= 1) {
            // 对应伪代码中 phi 指令插入的阶段
            generate_phi();
            stack_map_.clear();
            for(auto& var : mem_vars){
                stack_map_.insert({var, {}});
            }
            // 对应伪代码中重命名阶段
            rename(func_->get_entry_block());
        }
        // 后续 DeadCode 将移除冗余的局部变量的分配空间
    }
}

void Mem2Reg::generate_phi() {
    mem_vars.clear();
    global_name.clear();
    defs.clear();
    phi_lval_map_.clear();
    // 步骤一：找到活跃在多个 block 的全局名字集合，以及它们所属的 bb 块
    for(auto &bb : func_->get_basic_blocks()){
        for(auto &inst : bb.get_instructions()){
            if(inst.is_store()){
                auto store_inst = static_cast<StoreInst *>(&inst);
                auto lval = store_inst->get_lval();
                if(is_valid_ptr(lval)){
                    mem_vars.insert(lval);
                    if(defs.find(lval) == defs.end()){
                        defs.insert({lval, {}});
                    }
                    defs[lval].insert(&bb);
                }
            }
        }
    }
    for(auto &bb : func_->get_basic_blocks()){
        for(auto &inst : bb.get_instructions()){
            if(inst.is_store()){
                auto store_inst = static_cast<StoreInst *>(&inst);
                auto lval = store_inst->get_lval();
                if(is_valid_ptr(lval)){
                    for(auto &use : lval->get_use_list()){
                        if(auto user_inst = dynamic_cast<Instruction *>(use.val_)){
                            if(user_inst->get_parent() != &bb){
                                global_name.insert(lval);
                                break;
                            }
                        }
                    }
                }
            }
        }
    }
    // 步骤二：从支配树获取支配边界信息，并在对应位置插入 phi 指令
    for(auto& var : global_name){
        std::set<BasicBlock *> phi_inserted_blocks;
        std::set<BasicBlock *> var_defined_blocks;
        for(auto& d : defs[var]){
            var_defined_blocks.insert(d);
        }
        while(not var_defined_blocks.empty()){
            auto x = *var_defined_blocks.begin();
            var_defined_blocks.erase(var_defined_blocks.begin());
            for(auto &y : dominators_->get_dominance_frontier(x)){
                if(phi_inserted_blocks.find(y) == phi_inserted_blocks.end()){
                    auto phi = PhiInst::create_phi(var->get_type()->get_pointer_element_type(), y);
                    y->add_instr_begin(phi);
                    phi_lval_map_.insert({phi, var});
                    phi_inserted_blocks.insert(y);
                    if(defs[var].find(y) == defs[var].end()){
                        var_defined_blocks.insert(y);
                    }
                }
            }
        }
    }
}

void Mem2Reg::rename(BasicBlock *bb) {
    // TODO
    std::set<Instruction *> late_delete_inst;
    for(auto &inst : bb->get_instructions()){
        // 步骤三：将 phi 指令作为 lval 的最新定值，lval 即是为局部变量 alloca 出的地址空间
        if(inst.is_phi()){
            auto lval = phi_lval_map_[static_cast<PhiInst *>(&inst)];
            stack_map_[lval].push(&inst);
        }
        // 步骤四：用 lval 最新的定值替代对应的load指令
        if(inst.is_load()){
            auto load_inst = static_cast<LoadInst *>(&inst);
            auto ptr = load_inst->get_lval();
            if(is_valid_ptr(ptr)){
                inst.replace_all_use_with(stack_map_[ptr].top());
            }
        }
        // 步骤五：将 store 指令的 rval，也即被存入内存的值，作为 lval 的最新定值
        if(inst.is_store()){
            auto store_inst = static_cast<StoreInst *>(&inst);
            auto lval = store_inst->get_lval();
            auto rval = store_inst->get_rval();
            if(is_valid_ptr(lval)){
                stack_map_[lval].push(rval);
                late_delete_inst.insert(&inst);
            }
        }
    }
    // 步骤六：为 lval 对应的 phi 指令参数补充完整
    for(auto &s : bb->get_succ_basic_blocks()){
        for(auto &inst : s->get_instructions()){
            if(inst.is_phi()){
                //REVIEW
                auto phi_inst = static_cast<PhiInst *>(&inst);
                if(phi_lval_map_.find(phi_inst) != phi_lval_map_.end()){
                    // lval的栈顶元素一定存在
                    auto lval = phi_lval_map_[phi_inst];
                    if(stack_map_.find(lval) != stack_map_.end()){
                        if(stack_map_[lval].size() != 0){
                            phi_inst->add_phi_pair_operand(stack_map_[lval].top(), bb);
                        }
                        else{
                            if(lval->get_type()->get_pointer_element_type()->is_float_type()){
                                phi_inst->add_phi_pair_operand(ConstantFP::get(.0, m_), bb);
                            }
                            else if(lval->get_type()->get_pointer_element_type()->is_int32_type()){
                                phi_inst->add_phi_pair_operand(ConstantInt::get(0, m_), bb);
                            }
                            else assert(false);
                        }
                    }
                }
            }
        }
    }
    // 步骤七：对 bb 在支配树上的所有后继节点，递归执行 re_name 操作
    for(auto &s : dominators_->get_dom_tree_succ_blocks(bb)){
        rename(s);
    }
    // 步骤八：pop出 lval 的最新定值
    for(auto &inst : bb->get_instructions()){
        if(inst.is_phi()){
            auto lval = phi_lval_map_[static_cast<PhiInst *>(&inst)];
            stack_map_[lval].pop();
        }
        if(inst.is_store()){
            auto store_inst = static_cast<StoreInst *>(&inst);
            auto lval = store_inst->get_lval();
            if(is_valid_ptr(lval)){
                stack_map_[lval].pop();
            }
        }
    }
    // 步骤九：清除冗余的指令
    for(auto& inst : late_delete_inst){
        bb->erase_instr(inst);
    }
    // alloca remove TODO
}
