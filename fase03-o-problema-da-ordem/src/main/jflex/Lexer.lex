package br.maua.cic303;

import java_cup.runtime.*;

%%

%class Lexer
%public
%unicode
%implements java_cup.runtime.Scanner
%function next_token
%type java_cup.runtime.Symbol
%line
%column

%{
    private Symbol tok(int type) {
        return new Symbol(type, yyline, yycolumn);
    }

    private Symbol tok(int type, Object value) {
        return new Symbol(type, yyline, yycolumn, value);
    }
%}

/* ========================================================================= */
/* MACROS                                                                    */
/* ========================================================================= */
LineTerminator = \r|\n|\r\n
WhiteSpace     = {LineTerminator} | [ \t\f]

Number = [0-9]+(\.[0-9]+)?([Ee][+-]?[0-9]+)?

Letter = [a-zA-Z]
Digit  = [0-9]
Identifier = {Letter}({Letter}|{Digit}|_){0,31}

%%

<YYINITIAL> {

    /* Ignorar espaços */
    {WhiteSpace}    { }

    /* ========================= */
    /* PALAVRAS RESERVADAS       */
    /* ========================= */
    "if"            { return tok(sym.IF); }
    "then"          { return tok(sym.THEN); }
    "else"          { return tok(sym.ELSE); }
    "while"         { return tok(sym.WHILE); }

    /* ========================= */
    /* PONTUAÇÃO                 */
    /* ========================= */
    "("             { return tok(sym.LPAREN); }
    ")"             { return tok(sym.RPAREN); }
    "{"             { return tok(sym.LBRACE); }
    "}"             { return tok(sym.RBRACE); }
    ";"             { return tok(sym.SEMI); }

    /* ========================= */
    /* OPERADORES RELACIONAIS    */
    /* IMPORTANTE: ORDEM!        */
    /* ========================= */
    "=="            { return tok(sym.REL_OP, yytext()); }
    "!="            { return tok(sym.REL_OP, yytext()); }
    "<="            { return tok(sym.REL_OP, yytext()); }
    ">="            { return tok(sym.REL_OP, yytext()); }
    "<"             { return tok(sym.REL_OP, yytext()); }
    ">"             { return tok(sym.REL_OP, yytext()); }

    /* ========================= */
    /* ATRIBUIÇÃO                */
    /* ========================= */
    "="             { return tok(sym.ASSIGN); }

    /* ========================= */
    /* OPERADORES MATEMÁTICOS    */
    /* ========================= */
    "+" | "-"       { return tok(sym.ADD_OP, yytext()); }
    "*" | "/" | "%" { return tok(sym.MUL_OP, yytext()); }

    /* ========================= */
    /* IDENTIFICADORES E NÚMEROS */
    /* ========================= */
    {Identifier}    { return tok(sym.ID, yytext()); }
    {Number}        { return tok(sym.NUMBER, yytext()); }

    /* ERRO: identificador > 32 chars */
    {Letter}({Letter}|{Digit}|_){32} {
        throw new RuntimeException("Erro Léxico: Identificador ultrapassou 32 caracteres -> " + yytext());
    }

    /* ERRO genérico */
    . {
        throw new RuntimeException("Erro Léxico: Caractere Ilegal -> " + yytext());
    }
}

/* EOF */
<<EOF>> { return tok(sym.EOF); }