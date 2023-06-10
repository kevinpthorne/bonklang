grammar Bonk;

module: statement* EOF;

statement:
	importStatement ';'
	| typeDeclaration ';'
	| funcDeclaration
	| expression ';'
	| whileStatement
	| ifStatement
	| matchStatement
	| returnStatement ';';

importStatement: Identifier '=' Import;
typeDeclaration:
	UserTypeIdentifier genericTypeVar? Type '=' type;
funcDeclaration: Identifier funcType funcBody;

genericTypeVar: '<' UserTypeIdentifier '>';

type:
	'(' type ')'
	| funcType
	| productType
	| type '|' type
	| genericType
	| terminalType;
productType: '(' (attributeDecl (',' attributeDecl)*)* ')';
genericType: UserTypeIdentifier '<' type '>';
terminalType: (CharType | IntType | UserTypeIdentifier);
funcType: productType '->' type;

attributeDecl: Identifier (type defaultValue? | funcType funcBody);
defaultValue: '=' expression;
funcBody: '='? blockBody | '=' lambdaBody;
blockBody: '{' statement* '}';
lambdaBody:
	expression (',' | ';');
	// I really hate this. ',' should only be used for inline product type definitions

whileStatement: 'while' expression '{' statement* '}';
ifStatement: 'if' expression '{' statement+ '}' elseStatement?;
elseStatement: 'else' '{' statement+ '}';
matchStatement:
	'match' expression '{' patternCase (',' patternCase) '}';
patternCase: (expression | '*') '=>' (
		expression
		| '{' statement* '}'
	);
returnStatement: 'return' expression?;

expression:
	lvalue
	| '(' expression ')'
	// Unary
	| <assoc = right>('+' | '-' | 'not' | '\\' | '*') expression // right-to-left
	// PEMDAS
	| expression '^' expression
	| expression ('*' | '/') expression // left-to-right
	| expression ('+' | '-') expression
	// Bool stuff
	| expression ( '<' | '<=' | '>' | '>=') expression
	| expression ('==' | '!=') expression
	| expression ('and' | 'or') expression
	// Assignment stuff
	| <assoc = right> lvalue type? (
		'='
		| '+='
		| '-='
		| '*='
		| '/='
	) expression
	// Literals
	| (NumLiteral | StrLiteral | UserTypeIdentifier);

lvalue:
	'(' lvalue ')' lvalueSuffix?
	// function(), (something)()
	| lvalue arguments lvalueSuffix?
	// foo
	| Identifier lvalueSuffix?
	// Foo. ...
	| UserTypeIdentifier lvalueSuffix
	// new Thing(), new int[], new Thing[]
	| 'new' type arguments lvalueSuffix?;

lvalueSuffix:
	// foo.bar
	'.' Identifier lvalueSuffix?;
	// // foo[0]
	// | index lvalueSuffix?;

argumentList: expression (',' expression)*;
namedArgs: Identifier '=' expression (',' namedArgs);
arguments: '(' argumentList? namedArgs?')';

IntType: 'Int';
CharType: 'Char';
IndexType: '[]';

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

Whitespace: (' ' | '\t' | '\r\n' | '\r' | '\n') -> skip;
Comment: '//' ~[\r\n]* -> skip;
// Temp: ';' -> skip;

fragment Upper: [A-Z];
fragment Lower: [a-z];
fragment Alpha: [a-zA-Z];
fragment Digit: [0-9];