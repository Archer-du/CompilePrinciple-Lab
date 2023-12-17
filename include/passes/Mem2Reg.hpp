#pragma once

#include "Dominators.hpp"
#include "Instruction.hpp"
#include "Value.hpp"

#include <map>
#include <memory>
#include <stack>

class Mem2Reg : public Pass {
  private:
    Function *func_;
    std::unique_ptr<Dominators> dominators_;
    // TODO 添加需要的变量
    std::set<Value *> mem_vars;
    std::set<Value *> global_name;
    std::unordered_map<Value *, Dominators::BBSet> defs{};
    std::map<PhiInst *, Value *> phi_lval_map_{};
    std::map<Value *, std::stack<Value *>> stack_map_;

  public:
    Mem2Reg(Module *m) : Pass(m) {}
    ~Mem2Reg() = default;

    void run() override;

    void generate_phi();
    void rename(BasicBlock *bb);

    static inline bool is_global_variable(Value *l_val) {
        return dynamic_cast<GlobalVariable *>(l_val) != nullptr;
    }
    static inline bool is_gep_instr(Value *l_val) {
        return dynamic_cast<GetElementPtrInst *>(l_val) != nullptr;
    }

    static inline bool is_valid_ptr(Value *l_val) {
        return not is_global_variable(l_val) and not is_gep_instr(l_val);
    }
};
