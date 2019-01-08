grammar Query;

options {
}

expression : expr EOF;

expr        : '(' expr ')'                          #ParensExpr
            | expr op=(MULTIPLY | DIVIDE) expr      #MulDivExpr
            | expr op=(PLUS | MINUS) expr           #AddSubExpr
            | expr comparator expr                  #CompareExpr
            | NOT expr                              #UnaryExpr
            | expr AND expr                         #AndExpr
            | expr OR expr                          #OrExpr
            | FIELD                                 #FieldExpr
            | literal                               #ConstExpr
            | ANG '(' expr ')'          #FunctionExpr
            | FOO '(' expr ')'          #FunctionExpr
            | BAR '(' expr ')'          #FunctionExpr
            | SUM '(' expr ')'          #FunctionExpr
            | FORMAT '(' expr ')'          #FunctionExpr
            | COUNT_DISTINCT '(' expr ')'          #FunctionExpr
            | CASE '(' expr ')'          #FunctionExpr
            | CASE '(' expr ',' expr ')'          #FunctionExpr
            | CASE '(' expr ',' expr ',' expr ')'          #FunctionExpr
            | CASE '(' expr ',' expr ',' expr ',' expr ')'          #FunctionExpr
            | CASE '(' expr ',' expr ',' expr ',' expr ',' expr ')'          #FunctionExpr
            | CASE '(' expr ',' expr ',' expr ',' expr ',' expr ',' expr ')'          #FunctionExpr
            | CASE '(' expr ',' expr ',' expr ',' expr ',' expr ',' expr ',' expr ')'          #FunctionExpr
            | CASE '(' expr ',' expr ',' expr ',' expr ',' expr ',' expr ',' expr ',' expr ')'          #FunctionExpr
            | CASE '(' expr ',' expr ',' expr ',' expr ',' expr ',' expr ',' expr ',' expr ',' expr ')'          #FunctionExpr
            | CASE '(' expr ',' expr ',' expr ',' expr ',' expr ',' expr ',' expr ',' expr ',' expr ',' expr ')'          #FunctionExpr
            | FUNC_NAME '(' paramList? ')'          #FunctionExpr
            // Error conditions
            | expr op=binaryOperator       {this.notifyErrorListeners($op.text + " operator missing second argument");}    #BinOpErr
            | FUNC_NAME '(' paramList?     {this.notifyErrorListeners("Missing close parenthesis");}                       #FuncMissingRParen
            | INVALID_FIELD                {this.notifyErrorListeners("Invalid field reference");}                         #InvalidField
            ;

literal     : QUOTED_STRING
            | NUMBER
            | bool
            | NULL
            ;

paramList   : expr (',' expr)*
            ;

NULL : 'NULL' | 'null';

TRUE : 'TRUE' | 'true';
FALSE : 'FALSE' | 'false';

bool : TRUE | FALSE;

OR : 'OR' | '|';
AND : 'AND' | '&';
NOT : 'NOT' | '!';

PLUS       : '+' ;
MINUS      : '-' ;
MULTIPLY   : '*' ;
DIVIDE     : '/' ;

arithmetic : PLUS | MINUS | MULTIPLY | DIVIDE ;

GT         : '>' ;
GE         : '>=' ;
LT         : '<' ;
LE         : '<=' ;
EQ         : '=' ;
NE         : '!=' ;
ON         : 'ON' ;

comparator : GT | GE | LT | LE | EQ | NE | ON;

binaryOperator : arithmetic | comparator | AND | OR ;

fragment LETTER : [a-zA-Z];
fragment DIGIT : [0-9];
fragment ESCAPED_CHAR : '\\' ~[\n\r];

NUMBER : '-'? DIGIT+ ('.' DIGIT+)?;
QUOTED_STRING :   '"' ( ESCAPED_CHAR | ~[\n\r\\"] )*? '"';

fragment FIELD_CHAR : ESCAPED_CHAR | ~[\n\r\\[\]]; // Square brackes and backslash must be escaped, everything else is safe
FIELD : '[' FIELD_CHAR+ ']';
INVALID_FIELD : '[' FIELD_CHAR*;

FUNC_NAME : LETTER(LETTER | DIGIT | '_')* ; // Functions must start with a letter and can contain underscores

ANG : 'ANG' ; // Functions must start with a letter and can contain underscores
FOO : 'FOO' ; // Functions must start with a letter and can contain underscores
BAR : 'BAR' ; // Functions must start with a letter and can contain underscores
SUM : 'SUM' ; // Functions must start with a letter and can contain underscores
FORMAT : 'FORMAT' ; // Functions must start with a letter and can contain underscores
COUNT_DISTINCT : 'COUNT_DISTINCT' ; // Functions must start with a letter and can contain underscores
CASE : 'CASE' ; // Functions must start with a letter and can contain underscores

WS: [ \t\n\r]+ -> skip ;
