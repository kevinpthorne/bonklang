grammar Bonk;
options {
	language = Dart;
}

module: importStatement* typeDeclaration* statement* EOF;

statement:
	funcDeclaration
	| expression ';'
	// | assignment ';'
	| whileStatement
	| ifStatement
    | matchStatement
	| returnStatement ';';

importStatement: Identifier '=' Import;
typeDeclaration: UserTypeIdentifier Type '=' type;
funcDeclaration: Identifier funcType '='? '{' statement* '}';
// assignment: lvalue type? '=' expression;

type:
	productType
	| type '|' type
	| terminalType;
productType: '(' ((Identifier type) (',' Identifier type)*)* ')';
terminalType: StrType | IntType | UserTypeIdentifier;
funcType: productType ('->' type)?;

whileStatement: 'while' expression '{' statement* '}';
ifStatement: 'if' expression '{' statement+ '}' elseStatement?;
elseStatement: 'else' '{' statement+ '}';
matchStatement: 'match' expression '{' patternCase (',' patternCase) '}';
patternCase: (expression | '*') '=>' (expression | '{' statement* '}');
returnStatement: 'return' expression?;


expression:
	lvalue
	| '(' expression ')'
	// Unary
	| <assoc = right>('+' | '-' | 'not') expression // right-to-left
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
	// new Thing(), new int[], new Thing[]
	| 'new' type (arguments | index) lvalueSuffix?;

lvalueSuffix:
	// foo.bar
	'.' Identifier lvalueSuffix?
	// foo[0]
	| index lvalueSuffix?;

index: '[' expression? ']';
argumentList: expression (',' expression)*;
arguments: '(' argumentList? ')';

StrType: 'Str';
IntType: 'Int';

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
NumLiteral: Digit+;

Whitespace: (' ' | '\t' | '\r\n' | '\r' | '\n') -> skip;
Comment: '//' ~[\r\n]* -> skip;
// Temp: ';' -> skip;

fragment Upper: [A-Z];
fragment Lower: [a-z];
fragment Alpha: [a-zA-Z];
fragment Digit: [0-9];