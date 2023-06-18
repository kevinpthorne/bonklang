grammar Bonk;

module: statement* EOF;

statement:
	importStatement ('(' StrLiteral ')')? ';'
	| typeDeclaration ';'
	| funcDeclaration ';'
	| assignmentStatement ';'
	| expression ';'
	| whileStatement
	| ifStatement
	| breakStatement ';'
	| continueStatement ';'
	| matchStatement
	| returnStatement ';';

importStatement: Identifier '=' Import;
typeDeclaration:
	UserTypeIdentifier genericTypeVar? Type '=' type;
funcDeclaration: Identifier funcType funcBody;

genericTypeVar: '<' UserTypeIdentifier '>';

type:
	funcType
	| productType
	| genericType
	| terminalType
	| sumType;
funcType: productType (':' | '->') type;
productType: '(' (attributeDecl ( ',' attributeDecl)*)* ')';
sumType: summableType ('|' summableType)+;
summableType: genericType | terminalType;
genericType: terminalType '<' type '>';
terminalType: CharType | IntType | UserTypeIdentifier;

attributeDecl: Identifier (type defaultValue? | funcType funcBody);
defaultValue: '=' expression;
funcBody: blockBody | '=>' lambdaBody;
blockBody: '{' statement* '}';
lambdaBody: expression;

assignmentStatement: <assoc = right> lvalue type? (
		'='
		| '+='
		| '-='
		| '*='
		| '/='
	) expression;
whileStatement: 'while' expression blockBody;
ifStatement: 'if' expression blockBody elseStatement?;
elseStatement: 'else' blockBody;
matchStatement:
	'match' expression '{' patternCase (',' patternCase) '}';
patternCase: (expression | kleeneStar) '=>' (
		expression
		| blockBody
	);
kleeneStar: Multiply;
breakStatement: 'break';
continueStatement: 'continue';
returnStatement: 'return' expression?;

expression:
	lvalue
	| '(' expression ')'
	// Unary
	| <assoc = right>(Subtract | NOT | Deref | Ref) expression // right-to-left
	// PEMDAS
	| expression Exponent expression
	| expression (Multiply | Divide) expression // left-to-right
	| expression (Add | Subtract) expression
	// Bool stuff
	| expression (LE | LEQ | GE | GEQ) expression
	| expression (Equiv | XOR) expression
	| expression (AND | OR) expression
	// Literals
	| (NumLiteral | StrLiteral | CharLiteral | BoolLiteral | UserTypeIdentifier);

lvalue:
	'(' lvalue ')' lvalueSuffix?
	// function(), (something)()
	| lvalue arguments lvalueSuffix?
	// foo
	| Identifier lvalueSuffix?
	// Foo. ...
	| summableType lvalueSuffix
	// Foo()
	| summableType arguments lvalueSuffix?;

lvalueSuffix:
	// foo.bar
	'.' Identifier lvalueSuffix?;

argumentList: expression (',' expression)*;
namedArgs: Identifier '=' expression (',' Identifier '=' expression)*;
arguments: '(' argumentList? (',' namedArgs)?')';

// operators tokens
NOT: 'not';
Deref: '@';
Ref: '\\';
Exponent: '^';
Multiply: '*';
Divide: '/';
Add: '+';
Subtract: '-';
LE: '<';
LEQ: '<=';
GE: '>';
GEQ: '>=';
Equiv: '==';
XOR: '!=';
AND: 'and';
OR: 'or';

IntType: 'Int';
CharType: 'Char';

Import: 'import';
Type: 'type';
Identifier: (Lower) (Alpha | '_' | Digit)*;
UserTypeIdentifier: (Upper) (Alpha | '_' | Digit)*;

fragment Printable: // ASCII
	[\u0020-\u0026\u0028-\u005B\u005D-\u007E];
fragment Nonprintable: // ASCII, but limited
	'\\r'
	| '\\n'
	| '\\t'
	| '\\\\'
	| '\\\'';
fragment AChar: (Nonprintable | Printable);
StrLiteral: '"' AChar* '"';
CharLiteral: '\'' AChar '\'';
NumLiteral: Digit+;
BoolLiteral: 'true' | 'false';

Whitespace: (' ' | '\t' | '\r\n' | '\r' | '\n') -> skip;
Comment: '//' ~[\r\n]* -> skip;
// Temp: ';' -> skip;

fragment Upper: [A-Z];
fragment Lower: [a-z];
fragment Alpha: [a-zA-Z];
fragment Digit: [0-9];