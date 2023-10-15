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
	UserTypeIdentifier genericTypeVar? (Type | PartialType) '=' type;
funcDeclaration: lvalue funcType funcBody?;

genericTypeVar: '<' UserTypeIdentifier '>';

type:
	productType
	| genericType
	| terminalType
	| sumType;
funcType: productType (':' | '->') type;

productType: '(' (productTypeElement ( ',' productTypeElement)*)* ')';
sumType: summableType ('|' summableType)+;
summableType: genericType | terminalType;
genericType: terminalType '<' (type | funcType) '>';
terminalType: CharType | IntType | FloatType | UserTypeIdentifier;

productTypeElement: typeSpread | attributeDecl;
typeSpread: '...' UserTypeIdentifier;
attributeDecl: Identifier (type defaultValue? | funcType funcBody?);
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
	| (literal | UserTypeIdentifier);

literal:
	NumLiteral
	| StrLiteral
	| CharLiteral
	| BoolLiteral;

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
	'.' Identifier lvalueSuffix?
	// foo.{bar = 4; baz = 5;};
	| '.' '{' statement+ '}';

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
FloatType: 'Float';

Import: 'import';
Type: 'type';
PartialType: 'partialtype';
Identifier: Lower (Alpha | '_' | Digit)*;
UserTypeIdentifier: '&'? Upper (Alpha | '_' | Digit)*;

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
NumLiteral: Digit+ ('.' Digit+)?;
BoolLiteral: 'true' | 'false';

Whitespace: (' ' | '\t' | '\r\n' | '\r' | '\n') -> skip;
Comment: '//' ~[\r\n]* -> skip;
// Temp: ';' -> skip;

fragment Upper: [A-Z];
fragment Lower: [a-z];
fragment Alpha: [a-zA-Z];
fragment Digit: [0-9];