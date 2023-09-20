%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

#include "syntax_tree.h"

// external functions from lex
extern int yylex();
extern int yyparse();
extern int yyrestart();
extern FILE * yyin;

// external variables from lexical_analyzer module
extern int lines;
extern char * yytext;
extern int pos_end;
extern int pos_start;

// Global syntax tree
syntax_tree *gt;

// Error reporting
void yyerror(const char *s);

// Helper functions written for you with love
syntax_tree_node *node(const char *node_name, int children_num, ...);
%}

/* TODO: Complete this definition.
   Hint: See pass_node(), node(), and syntax_tree.h.
         Use forward declaring. */
%union {
    struct _syntax_tree_node *node;
}

/* TODO: Your tokens here. */
%token <node> ERROR
%token <node> ADD SUB MUL DIV
%token <node> LT GT LE GE EQ NE
%token <node> ASSIGN
%token <node> SEM
%token <node> COMMA
%token <node> LPAREN
%token <node> RPAREN
%token <node> LSQBRA
%token <node> RSQBRA
%token <node> LCURBRA
%token <node> RCURBRA
%token <node> ELSE
%token <node> IF
%token <node> INT
%token <node> RETURN
%token <node> VOID
%token <node> WHILE
%token <node> FLOAT
%token <node> ID
%token <node> INTEGER
%token <node> FLOATPOINT


%right ASSIGN
%left EQ NE
%left LT LE GT GE
%left ADD SUB
%left MUL DIV
%left LPAREN RPAREN LSQBRA RSQBRA LCURBRA RCURBRA


%type <node> program

%type <node> type-specifier relop addop mulop
%type <node> declaration-list declaration var-declaration fun-declaration local-declarations
%type <node> compound-stmt statement-list statement expression-stmt iteration-stmt selection-stmt return-stmt
%type <node> expression simple-expression var additive-expression term factor integer floatpoint call
%type <node> params param-list param args arg-list

%start program

%%


program
    : declaration-list 
    {$$ = node("program", 1, $1); gt->root = $$;};

declaration-list
    : declaration-list declaration
    {$$ = node("declaration-list", 2, $1, $2);}
    | declaration
    {$$ = node("declaration-list", 1, $1);};

declaration
    : var-declaration
    {$$ = node("declaration", 1, $1);}
    | fun-declaration
    {$$ = node("declaration", 1, $1);};

var-declaration
    : type-specifier ID SEM
    {$$ = node("var-declaration", 3, $1, $2, $3);}
    | type-specifier ID LSQBRA INTEGER RSQBRA SEM
    {$$ = node("var-declaration", 6, $1, $2, $3, $4, $5, $6);};

type-specifier
    : INT
    {$$ = node("type-specifier", 1, $1);}
    | FLOAT
    {$$ = node("type-specifier", 1, $1);}
    | VOID
    {$$ = node("type-specifier", 1, $1);};

fun-declaration
    : type-specifier ID LPAREN params RPAREN compound-stmt
    {$$ = node("fun-declaration", 6, $1, $2, $3, $4, $5, $6);};

params
    : param-list
    {$$ = node("params", 1, $1);}
    | VOID
    {$$ = node("params", 1, $1);};

param-list
    : param-list COMMA param
    {$$ = node("param-list", 3, $1, $2, $3);}
    | param
    {$$ = node("param-list", 1, $1);};

param
    : type-specifier ID
    {$$ = node("param", 2, $1, $2);}
    | type-specifier ID LSQBRA RSQBRA
    {$$ = node("param", 4, $1, $2, $3, $4);};

compound-stmt
    : LCURBRA local-declarations statement-list RCURBRA
    {$$ = node("compound-stmt", 4, $1, $2, $3, $4);};

local-declarations
    : local-declarations var-declaration
    {$$ = node("local-declarations", 2, $1, $2);}
    | 
    {$$ = node("local-declarations", 0);};

statement-list
    : statement-list statement
    {$$ = node("statement-list", 2, $1, $2);}
    | 
    {$$ = node("statement-list", 0);};

statement
    : expression-stmt
    {$$ = node("statement", 1, $1);}
    | compound-stmt
    {$$ = node("statement", 1, $1);}
    | selection-stmt
    {$$ = node("statement", 1, $1);}
    | iteration-stmt
    {$$ = node("statement", 1, $1);}
    | return-stmt
    {$$ = node("statement", 1, $1);};

expression-stmt
    : expression SEM
    {$$ = node("expression-stmt", 2, $1, $2);}
    | SEM
    {$$ = node("expression-stmt", 1, $1);};

selection-stmt
    : IF LPAREN expression RPAREN statement
    {$$ = node("selection-stmt", 5, $1, $2, $3, $4, $5);}
    | IF LPAREN expression RPAREN statement ELSE statement
    {$$ = node("selection-stmt", 7, $1, $2, $3, $4, $5, $6, $7);};

iteration-stmt
    : WHILE LPAREN expression RPAREN statement
    {$$ = node("iteration-stmt", 5, $1, $2, $3, $4, $5);};

return-stmt
    : RETURN SEM
    {$$ = node("return-stmt", 2, $1, $2);};
    | RETURN expression SEM
    {$$ = node("return-stmt", 3, $1, $2, $3);};

expression
    : var ASSIGN expression
    {$$ = node("expression", 3, $1, $2, $3);}
    | simple-expression
    {$$ = node("expression", 1, $1);};

var 
    : ID
    {$$ = node("var", 1, $1);}
    | ID LSQBRA expression RSQBRA
    {$$ = node("var", 4, $1, $2, $3, $4);};

simple-expression
    : additive-expression relop additive-expression
    {$$ = node("simple-expression", 3, $1, $2, $3);}
    | additive-expression
    {$$ = node("simple-expression", 1, $1);};

relop
    : LE 
    {$$ = node("relop", 1, $1);}
    | LT 
    {$$ = node("relop", 1, $1);}
    | GT 
    {$$ = node("relop", 1, $1);}
    | GE 
    {$$ = node("relop", 1, $1);}
    | EQ 
    {$$ = node("relop", 1, $1);}
    | NE
    {$$ = node("relop", 1, $1);};

additive-expression
    : additive-expression addop term
    {$$ = node("additive-expression", 3, $1, $2, $3);}
    | term
    {$$ = node("additive-expression", 1, $1);};

addop
    : ADD 
    {$$ = node("addop", 1, $1);}
    | SUB
    {$$ = node("addop", 1, $1);};

term
    : term mulop factor
    {$$ = node("term", 3, $1, $2, $3);}
    | factor
    {$$ = node("term", 1, $1);}

mulop
    : MUL 
    {$$ = node("mulop", 1, $1);}
    | DIV
    {$$ = node("mulop", 1, $1);};

factor
    : LPAREN expression RPAREN
    {$$ = node("factor", 3, $1, $2, $3);}
    | var
    {$$ = node("factor", 1, $1);}
    | call
    {$$ = node("factor", 1, $1);}
    | integer
    {$$ = node("factor", 1, $1);}
    | floatpoint
    {$$ = node("factor", 1, $1);};

integer
    : INTEGER
    {$$ = node("integer", 1, $1);};

floatpoint
    : FLOATPOINT
    {$$ = node("float", 1, $1);};

call
    : ID LPAREN args RPAREN
    {$$ = node("call", 4, $1, $2, $3, $4);};

args
    : arg-list
    {$$ = node("args", 1, $1);}
    | 
    {$$ = node("args", 0);};

arg-list
    : arg-list COMMA expression
    {$$ = node("arg-list", 3, $1, $2, $3);}
    | expression
    {$$ = node("arg-list", 1, $1);};
%%

/// The error reporting function.
void yyerror(const char * s)
{
    // TO STUDENTS: This is just an example.
    // You can customize it as you like.
    fprintf(stderr, "error at line %d column %d: %s\n", lines, pos_start, s);
}

/// Parse input from file `input_path`, and prints the parsing results
/// to stdout.  If input_path is NULL, read from stdin.
///
/// This function initializes essential states before running yyparse().
syntax_tree *parse(const char *input_path)
{
    if (input_path != NULL) {
        if (!(yyin = fopen(input_path, "r"))) {
            fprintf(stderr, "[ERR] Open input file %s failed.\n", input_path);
            exit(1);
        }
    } else {
        yyin = stdin;
    }

    lines = pos_start = pos_end = 1;
    gt = new_syntax_tree();
    yyrestart(yyin);
    yyparse();
    return gt;
}

/// A helper function to quickly construct a tree node.
///
/// e.g. $$ = node("program", 1, $1);
syntax_tree_node *node(const char *name, int children_num, ...)
{
    syntax_tree_node *p = new_syntax_tree_node(name);
    syntax_tree_node *child;
    if (children_num == 0) {
        child = new_syntax_tree_node("epsilon");
        syntax_tree_add_child(p, child);
    } else {
        va_list ap;
        va_start(ap, children_num);
        for (int i = 0; i < children_num; ++i) {
            child = va_arg(ap, syntax_tree_node *);
            syntax_tree_add_child(p, child);
        }
        va_end(ap);
    }
    return p;
}
