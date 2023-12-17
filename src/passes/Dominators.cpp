#include "Dominators.hpp"
#include "BasicBlock.hpp"
#include <iostream>

void Dominators::run() {
    for (auto &f1 : m_->get_functions()) {
        auto f = &f1;
        if (f->get_basic_blocks().size() == 0)
            continue;
        for (auto &bb1 : f->get_basic_blocks()) {
            auto bb = &bb1;
            idom_.insert({bb, {}});
            dom_frontier_.insert({bb, {}});
            dom_tree_succ_blocks_.insert({bb, {}});
        }

        reverse_post_order_blockinfo_.clear();
        reverse_post_order_id_.clear();
        visited_blocks_.clear();
        reverse_post_order_visit(f->get_entry_block());
        int i = 0;
        for(auto &bb : reverse_post_order_blockinfo_){
            reverse_post_order_id_.insert({bb, i++});
        }

        create_idom(f);
        create_dominance_frontier(f);
        create_dom_tree_succ(f);
    }
}
void Dominators::reverse_post_order_visit(BasicBlock *bb)
{
    visited_blocks_.insert(bb);
    for (auto& b : bb->get_succ_basic_blocks()) {
        if (visited_blocks_.find(b) == visited_blocks_.end())
            reverse_post_order_visit(b);
    }
    reverse_post_order_blockinfo_.push_front(bb);
}

BasicBlock *Dominators::intersect(BasicBlock *bb1, BasicBlock *bb2){
    auto finger1 = bb1;
    auto finger2 = bb2;
    while(reverse_post_order_id_[finger1] != reverse_post_order_id_[finger2]){
        while(reverse_post_order_id_[finger1] > reverse_post_order_id_[finger2]){
            finger1 = idom_[finger1];
        }
        while(reverse_post_order_id_[finger2] > reverse_post_order_id_[finger1]){
            finger2 = idom_[finger2];
        }
    }
    return finger1;
}

void Dominators::create_idom(Function *f) {
    // 分析得到 f 中各个基本块的 idom
    // FIXME
    auto start_node = f->get_entry_block();
    idom_[start_node] = start_node;
    bool changed = true;
    while (changed) {
        changed = false;
        for(auto& b : reverse_post_order_blockinfo_){
            if(b == start_node) continue;
            BasicBlock *new_idom;
            for(auto& p : b->get_pre_basic_blocks()){
                if(idom_[p] != nullptr){
                    new_idom = p;
                    break;
                }
            }
            assert(new_idom != nullptr);
            for(auto& p : b->get_pre_basic_blocks()){
                if(p == new_idom) continue;
                if(idom_[p] != nullptr){
                    new_idom = intersect(p, new_idom);
                }
            }
            if(idom_[b] != new_idom){
                idom_[b] = new_idom;
                changed = true;
            }
        }
    }
}

void Dominators::create_dominance_frontier(Function *f) {
    // 分析得到 f 中各个基本块的支配边界集合
    for(auto& b : reverse_post_order_blockinfo_){
        if(b->get_pre_basic_blocks().size() >= 2){
            for(auto &p : b->get_pre_basic_blocks()){
                auto runner = p;
                while(runner != idom_[b]){
                    dom_frontier_[runner].insert(b);
                    runner = idom_[runner];
                }
            }
        }
    }
}

void Dominators::create_dom_tree_succ(Function *f) {
    // 分析得到 f 中各个基本块的支配树后继
    for(auto& b : reverse_post_order_blockinfo_){
        if(b != f->get_entry_block()){
            dom_tree_succ_blocks_[idom_[b]].insert(b);
        }
    }
    // for(auto &set : dom_tree_succ_blocks_){
    //     for(auto &bb : set.second){
    //         std::cout << reverse_post_order_id_[bb] << " ";
    //     }
    //     std::cout << std::endl;
    // }
}
