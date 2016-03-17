/* A Bison parser, made by GNU Bison 3.0.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2013 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    IMPLIES = 258,
    DOT = 259,
    PLUS = 260,
    MINUS = 261,
    EQUALS = 262,
    NOT = 263,
    IS = 264,
    UNEQUALS = 265,
    SMALLER = 266,
    SMALLER_EQUALS = 267,
    GREATER = 268,
    GREATER_EQUALS = 269,
    COMMA = 270,
    OPEN_PARA = 271,
    CLOSE_PARA = 272,
    OPEN_BRA = 273,
    CLOSE_BRA = 274,
    PIPE = 275,
    ASTERIX = 276,
    COLON = 277,
    NEW_LINE_FEED = 278,
    NUMBER = 279,
    CONST_ID = 280,
    VAR_ID = 281
  };
#endif
/* Tokens.  */
#define IMPLIES 258
#define DOT 259
#define PLUS 260
#define MINUS 261
#define EQUALS 262
#define NOT 263
#define IS 264
#define UNEQUALS 265
#define SMALLER 266
#define SMALLER_EQUALS 267
#define GREATER 268
#define GREATER_EQUALS 269
#define COMMA 270
#define OPEN_PARA 271
#define CLOSE_PARA 272
#define OPEN_BRA 273
#define CLOSE_BRA 274
#define PIPE 275
#define ASTERIX 276
#define COLON 277
#define NEW_LINE_FEED 278
#define NUMBER 279
#define CONST_ID 280
#define VAR_ID 281

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE YYSTYPE;
union YYSTYPE
{
#line 5 "parser_prolog_hornclauses.y" /* yacc.c:1909  */

char* str;
int num;

#line 111 "y.tab.h" /* yacc.c:1909  */
};
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
