
/* description: Parses and executes mathematical expressions. */

/* lexical grammar */
%lex
%%

\s+                   /* skip whitespace */
"<"                   return 'OPEN_ANG'
">"                   return 'CLOSE_ANG'
"/"                   return 'SLASH'
[A-z 0-9 !']+         return 'TEXT'
<<EOF>>               return 'EOF'

/lex

%start expressions

%% /* language grammar */

expressions
    : ROOT EOF
        { typeof console !== 'undefined' ? console.log($1) : print($1);
          return $1; }
    ;

ROOT
    : OPENING_TAG CLOSING_TAG
    {$$ = $1}
    | OPENING_TAG TEXT CLOSING_TAG
    {$$ = {[Object.keys($1)[0]] : $2}}
    | OPENING_TAG NODES CLOSING_TAG
    {$$ = {[Object.keys($1)[0]] : $2}}
    ;

NODES
    : NODE
    {$$ = $1}
    | NODES NODE
    {$$ = joinObjects($1, $2)}
    ;

NODE
    : OPENING_TAG CLOSING_TAG
    {$$ = $1}
    | OPENING_TAG TEXT CLOSING_TAG
    {$$ = {[Object.keys($1)[0]] : $2}}
    | OPENING_TAG NODE CLOSING_TAG
    {$$ = {[Object.keys($1)[0]] : $2}}
    ;

OPENING_TAG
    : OPEN_ANG TEXT CLOSE_ANG
    {$$ = {[$2] : ""}}
    ;

CLOSING_TAG
    : OPEN_ANG SLASH TEXT CLOSE_ANG
    ;

%%

const joinObjects = (a, b) => {
    Object.entries(b).forEach(([k,v])=> a[k] = v)
    return a;
}