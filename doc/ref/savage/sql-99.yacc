/*
** Derived from file sql-99.bnf version 2.8 dated 2004/07/26 18:00:06
*/
/* Using Appendix G of "SQL:1999 Understanding Relational Language Components" by J */
/* Melton and A R Simon (Morgan Kaufmann, May 2001, ISBN 0-55860-456-1) */
/* as the primary source of the syntax, here is the BNF syntax for SQL-99. */
/* The Word 97 version of this document is available from: */
/* --## <a href="http://www.mkp.com/books_catalog/catalog.asp?ISBN=1-55860-456-1"> */
/* --## http://www.mkp.com/books_catalog/catalog.asp?ISBN=1-55860-456-1 </a>. */
/* Note that this version of this file includes the corrections from ISO 9075:1999/Cor.1:2000. */
/* The plain text version of this grammar is */
/* --## <a href='sql-99.bnf'> sql-99.bnf </a>. */
/*  Key SQL Statements and Fragments */
/*  ALTER DOMAIN <alter domain statement> */
/*  ALTER TABLE <alter table statement> */
/*  CLOSE cursor <close statement> */
/*  Column definition <column definition> */
/*  COMMIT WORK <commit statement> */
/*  CONNECT <connect statement> */
/*  CREATE ASSERTION <assertion definition> */
/*  CREATE CHARACTER SET <character set definition> */
/*  CREATE COLLATION <collation definition> */
/*  CREATE DOMAIN <domain definition> */
/*  CREATE FUNCTION <schema function> */
/*  CREATE PROCEDURE <schema procedure> */
/*  CREATE SCHEMA <schema definition> */
/*  CREATE TABLE <table definition> */
/*  CREATE TRANSLATION <translation definition> */
/*  CREATE TRIGGER <trigger definition> */
/*  CREATE VIEW <view definition> */
/*  Data type <data type> */
/*  DEALLOCATE PREPARE <deallocate prepared statement> */
/*  DECLARE cursor <declare cursor> <dynamic declare cursor> */
/*  DECLARE LOCAL TEMPORARY TABLE <temporary table declaration> */
/*  DELETE <delete statement: positioned> <delete statement: searched> <dynamic delete statement: positioned> */
/*  DESCRIBE <describe statement> */
/*  DESCRIPTOR statements <system descriptor statement> */
/*  DISCONNECT <disconnect statement> */
/*  EXECUTE <execute statement> */
/*  EXECUTE IMMEDIATE <execute immediate statement> */
/*  FETCH cursor <fetch statement> */
/*  FROM clause <from clause> */
/*  GET DIAGNOSTICS <get diagnostics statement> */
/*  GRANT <grant statement> */
/*  GROUP BY clause <group by clause> */
/*  HAVING clause <having clause> */
/*  INSERT <insert statement> */
/*  Literals <literal> */
/*  OPEN cursor <open statement> */
/*  ORDER BY clause <order by clause> */
/*  PREPARE <prepare statement> */
/*  REVOKE <revoke statement> */
/*  ROLLBACK WORK <rollback statement> */
/*  SAVEPOINT <savepoint statement> */
/*  Search condition <search condition> <regular expression> */
/*  SELECT <query specification> */
/*  SET CATALOG <set catalog statement> */
/*  SET CONNECTION <set connection statement> */
/*  SET CONSTRAINTS <set constraints mode statement> */
/*  SET NAMES <set names statement> */
/*  SET SCHEMA <set schema statement> */
/*  SET SESSION AUTHORIZATION <set session user identifier statement> */
/*  SET TIME ZONE <set local time zone statement> */
/*  SET TRANSACTION <set transaction statement> */
/*  SQL Client MODULE <SQL-client module definition> */
/*  UPDATE <update statement: positioned> <update statement: searched> <dynamic update statement: positioned> */
/*  Value expression <value expression> */
/*  WHERE clause <where clause> */
/*  Identifying the version of SQL in use */
/* This material (starting with <SQL object identifier>) is defined in */
/* section 6.3 "Object Identifier for Database Language SQL" of ISO/IEC */
/* 9075-1:1999 (SQL Framework). */
/* It is used to express the capabilities of an implementation. */
/* The package names are identifiers such as 'PKG001', equivalent to */
/* 'Enhanced datetime facilities', as defined in the informative Annex B to */
/* SQL Framework. */
/* Each such package identifies a number of features that are provided when */
/* the SQL object identifier claims to provide the package. */
/* The parenthesized (i) and (n) are italic in the SQL standard. */
/* It is not clear exactly what this should look like, despite all the */
/* information. */
/* However, it is also not important; this is not really a part of the SQL */
/* language per se. */
/* Note that the package numbers are PKG001 to PKG009, for example. */
/* We still have to devise a mechanism to persuade bnf2yacc.pl to ignore */
/* this information. */
/* UNK: (n)No <left paren> 0 <right paren> */
/* The original used sqlbindings199x, but the x should clearly be a 9. */
/*  Basic Definitions of Characters Used, Tokens, Symbols, Etc. */
/* Most of this section would normally be handled within the lexical */
/* analyzer rather than in the grammar proper. */
/* Further, the original document does not quote the various single */
/* characters, which makes it hard to process automatically. */
/*  Literal Numbers, Strings, Dates and Times */
/*  <SQL-client module definition> modified per ISO 9075:1999/Cor.1:2000(E) */
/*  <identifier body> modified per ISO 9075:1999/Cor.1:2000(E). */
/*  <identifier body> also rationalized by removing curly brackets */
/* around <identifier part> because they are unnecessary and inconsistent */
/* with other places where '...' modifies a single non-terminal. */
/* Note that the two successive double quote characters must have no other */
/* character (such as a space) between them. */
/* The lexical analyzer would normally deal with this sort of issue. */
/*  Data Types */
/* The trigraphs are strictly sequences of characters, not sequences of tokens. */
/* There may not be any spaces between the characters. */
/* Normally, the lexical analyzer would return the trigraphs as a simple symbol. */
/*  Literals */
/* The <quote symbol> rule consists of two immediately adjacent <quote> */
/* marks with no spaces. */
/* As usual, this would be best handled in the lexical analyzer, not in the */
/* grammar. */
/* The <bracketed comment> rule included '!! (See the Syntax Rules)'. */
/* This probably says something about the <slash> <asterisk> and <asterisk> */
/* <slash> needing to be adjacent characters rather than adjacent tokens. */
/*  Constraints */
/*  Search Condition */
/*  Queries */
/*  <sort specification> modified per ISO 9075:1999/Cor.1:2000(E) */
/*  Rules from <group by clause> to <grouping set> modified per ISO 9075:1999/Cor.1:2000(E) */
/*  Query expression components */
/*  <subtype treatment> to <target subtype> modified per ISO 9075:1999/Cor.1:2000(E) */
/* UNK: -> */
/*  It is not remotely clear why this was needed in this grammar. */
/*  <constructor method selection> added per ISO 9075:1999/Cor.1:2000(E) */
/*   */
/* Note that <double colon> must be a pair of characters with no */
/* intervening space, not a pair of colon symbols separated by arbitrary */
/* white space. */
/* Normally, the lexical analyzer would return <double colon> as a symbol. */
/*  <regular expression substring function> modified per ISO 9075:1999/Cor.1:2000(E) */
/* The <not equals>, <less than or equals operator> and <greater than or */
/* equals operator> should be handled by the lexical analyzer as token */
/* symbols, not by the grammar. */
/* As usual, spaces are not allowed between the two characters. */
/*  Previously, the expression in curly braces was not in square brackets. */
/*  Consequently, every <in value list> had to have at least two items in it. */
/*  Regular Expressions for SIMILAR TO */
/* These regular expressions are not referenced anywhere else in the */
/* document, but define the structure that the <character value expression> */
/* used in <similar pattern> must have. */
/* Structurally, these regular expressions are similar to 'egrep' */
/* expressions, except they use underscore in place of dot, and percent is */
/* equivalent to dot star in 'egrep'. */
/* The other omission is the use of caret (aka circumflex) to mark the */
/* start of the matched text and dollar to mark the end of the matched */
/* text. */
/*  More about constraints */
/* The standard documents UNIQUE ( VALUE ) but there is no explanation of */
/* why that is different from the UNIQUE <left paren> VALUE <right paren> */
/* used here. */
/*  Module contents */
/*  SQL Procedures */
/*  <host parameter declaration setup> modified per ISO 9075:1999/Cor.1:2000(E) */
/*  SQL Schema Definition Statements */
/*  <SQL schema definition statement> modified per ISO 9075:1999/Cor.1:2000(E) */
/*  <schema element> modified per ISO 9075:1999/Cor.1:2000(E) */
/*  <specific routine designator> modified per ISO 9075:1999/Cor.1:2000(E) */
/*  <specific routine designator> modified per ISO 9075:1999/Cor.1:2000(E) */
/*  <user-defined type body> modified per ISO 9075:1999/Cor.1:2000(E) */
/*  <partial method specification> modified per ISO 9075:1999/Cor.1:2000(E) */
/*  <specific method name> added per ISO 9075:1999/Cor.1:2000(E) */
/*  <method characteristic> modified per ISO 9075:1999/Cor.1:2000(E) */
/*  <routine characteristic> modified per ISO 9075:1999/Cor.1:2000(E) */
/*  <external body reference> modified per ISO 9075:1999/Cor.1:2000(E) */
/*  <method specification designator> modified per ISO 9075:1999/Cor.1:2000(E) */
/*  <user-defined ordering specification> modified per ISO 9075:1999/Cor.1:2000(E) */
/*  <transform definition> modified per ISO 9075:1999/Cor.1:2000(E) */
/*  SQL Schema Manipulation Statements */
/*  <drop method specification> modified per ISO 9075:1999/Cor.1:2000(E) */
/*  <specific method specification designator> added per ISO 9075:1999/Cor.1:2000(E) */
/*  <drop user-defined ordering statement> modified per ISO 9075:1999/Cor.1:2000(E) */
/*  <drop transform statement> modified per ISO 9075:1999/Cor.1:2000(E) */
/*  SQL Data Manipulation Statements */
/*  <target table> modified per ISO 9075:1999/Cor.1:2000(E) */
/*  <update target> modified per ISO 9075:1999/Cor.1:2000(E) */
/*  SQL Control Statements */
/*  Transaction Management */
/*  <savepoint specifier> modified per ISO 9075:1999/Cor.1:2000(E) */
/*  Connection Management */
/*  Session Attributes */
/*  <new invocation> modified per ISO 9075:1999/Cor.1:2000(E) */
/*  <reserved word> modified per ISO 9075:1999/Cor.1:2000(E) */
/*  <non-reserved word> modified per ISO 9075:1999/Cor.1:2000(E) */
/*  Dynamic SQL */
/* Much, if not all, of the following material comes from ISO/IEC 9075-5:1999, SQL/Bindings. */
/*   */
/* Note that <double period> must be a pair of period characters with no */
/* intervening space, not a pair of period symbols separated by arbitrary */
/* white space. */
/* Normally, the lexical analyzer would return <double period> as a symbol. */
/* The standard documents 'CHARACTER KIND = n' but there is no explanation */
/* of the italic 'n' that is used. */
/* Presumably, it is an integer literal, hence <unsigned integer>. */
/* The standard documents 'SQLSTATE ( <SQLSTATE class value> [ , <SQLSTATE */
/* subclass value> ] )', but it is not clear why the <left paren>, <comma> */
/* and <right paren> are not designated more accurately. */
/*  END OF SQL-99 GRAMMAR */
/*  Notes on Automatically Converting the SQL-99 Grammar to a YACC Grammar */
/* Automatic translation of this grammar is non-trivial for a number of */
/* reasons. */
/* One is that the grammar has a number of actions '!! */
/* (See the Syntax Rules.)' which cannot be translated automatically. */
/* Another is that the grammar contains rules that are usually better */
/* handled by the lexical analyzer than the grammar proper. */
/* Then there are incomplete rules such as those which reference parts 6 */
/* to 10 (they are not defined; indeed, part 7, which was going to be */
/* SQL/Temporal, is in complete abeyance), and the packages (almost */
/* completely undefined in the grammar). */
/* It is not clear whether these can be ignored, or annotated out of the */
/* way. */
/* Another complication is automatically generating rules to deal with */
/* optional components and repetitive components in the grammar. */
/* Square brackets do not contain alternative non-terminals; all those */
/* expressions are contained within curly brackets within the square */
/* brackets. */
/* However, some square brackets do contain alternative terminals. */
/* Curly brackets contain and group mandatory elements. */
/* However, they are usually used in conjunction with the 'one or more */
/* times' repeater ellipsis '...' mark. */
%{
/*
** BNF Grammar for ISO/IEC 9075:1999 - Database Language SQL (SQL-99)
*/
%}

%token 0
%token 01
%token 1
%token 2
%token 3
%token 4
%token 5
%token 6
%token 7
%token 77
%token 8
%token 9
%token 9075
%token A
%token ABS
%token ABSOLUTE
%token ACTION
%token ADA
%token ADD
%token ADMIN
%token AFTER
%token ALL
%token ALLOCATE
%token ALTER
%token AND
%token ANY
%token ARE
%token ARRAY
%token AS
%token ASC
%token ASENSITIVE
%token ASSERTION
%token ASSIGNMENT
%token ASYMMETRIC
%token AT
%token ATOMIC
%token ATTRIBUTE
%token AUTHORIZATION
%token AVG
%token AllocConnect
%token AllocEnv
%token AllocHandle
%token AllocStmt
%token B
%token BEFORE
%token BEGIN
%token BETWEEN
%token BIN
%token BINARY
%token BIT
%token BIT_LENGTH
%token BLOB
%token BOOLEAN
%token BOTH
%token BREADTH
%token BY
%token BindCol
%token BindParameter
%token C
%token CALL
%token CALLED
%token CARDINALITY
%token CASCADE
%token CASCADED
%token CASE
%token CAST
%token CATALOG
%token CATALOG_NAME
%token CHAIN
%token CHAR
%token CHARACTER
%token CHARACTERISTICS
%token CHARACTER_LENGTH
%token CHARACTER_SET_CATALOG
%token CHARACTER_SET_NAME
%token CHARACTER_SET_SCHEMA
%token CHAR_LENGTH
%token CHECK
%token CHECKED
%token CLASS_ORIGIN
%token CLOB
%token CLOSE
%token COALESCE
%token COBOL
%token COLLATE
%token COLLATION
%token COLLATION_CATALOG
%token COLLATION_NAME
%token COLLATION_SCHEMA
%token COLUMN
%token COLUMN_NAME
%token COMMAND_FUNCTION
%token COMMAND_FUNCTION_CODE
%token COMMIT
%token COMMITTED
%token CONDITION
%token CONDITION_IDENTIFIER
%token CONDITION_NUMBER
%token CONNECT
%token CONNECTION
%token CONNECTION_NAME
%token CONSTRAINT
%token CONSTRAINTS
%token CONSTRAINT_CATALOG
%token CONSTRAINT_NAME
%token CONSTRAINT_SCHEMA
%token CONSTRUCTOR
%token CONTAINS
%token CONTINUE
%token CONVERT
%token CORRESPONDING
%token COUNT
%token CREATE
%token CROSS
%token CUBE
%token CURRENT
%token CURRENT_DATE
%token CURRENT_DEFAULT_TRANSFORM_GROUP
%token CURRENT_PATH
%token CURRENT_ROLE
%token CURRENT_TIME
%token CURRENT_TIMESTAMP
%token CURRENT_TRANSFORM_GROUP_FOR_TYPE
%token CURRENT_USER
%token CURSOR
%token CURSOR_NAME
%token CYCLE
%token Cancel
%token CloseCursor
%token ColAttribute
%token ColumnPrivileges
%token Columns
%token Connect
%token CopyDesc
%token D
%token DATA
%token DATE
%token DATETIME_INTERVAL_CODE
%token DATETIME_INTERVAL_PRECISION
%token DAY
%token DCL
%token DEALLOCATE
%token DEC
%token DECIMAL
%token DECLARE
%token DEF
%token DEFAULT
%token DEFERRABLE
%token DEFERRED
%token DEFIN
%token DEFINED
%token DEFINER
%token DEFOUT
%token DEGREE
%token DELETE
%token DEPTH
%token DEREF
%token DERIVED
%token DESC
%token DESCRIBE
%token DESCRIPTOR
%token DETERMINISTIC
%token DIAGNOSTICS
%token DISCONNECT
%token DISPATCH
%token DISPLAY
%token DISTINCT
%token DO
%token DOMAIN
%token DOUBLE
%token DOUBLE_PRECISION
%token DROP
%token DYNAMIC
%token DYNAMIC_FUNCTION
%token DYNAMIC_FUNCTION_CODE
%token DataSources
%token DescribeCol
%token Disconnect
%token E
%token EACH
%token ELSE
%token ELSEIF
%token END
%token END-EXEC
%token EQUALS
%token ESCAPE
%token EVERY
%token EXCEPT
%token EXCEPTION
%token EXEC
%token EXECUTE
%token EXISTS
%token EXIT
%token EXTERNAL
%token EXTRACT
%token EndTran
%token Error
%token ExecDirect
%token Execute
%token F
%token FALSE
%token FETCH
%token FINAL
%token FIRST
%token FIXED
%token FLOAT
%token FOR
%token FOREIGN
%token FORTRAN
%token FOUND
%token FREE
%token FROM
%token FULL
%token FUNCTION
%token Fetch
%token FetchScroll
%token ForeignKeys
%token FreeConnect
%token FreeEnv
%token FreeHandle
%token FreeStmt
%token G
%token GENERAL
%token GENERATED
%token GET
%token GLOBAL
%token GO
%token GOTO
%token GRANT
%token GRANTED
%token GROUP
%token GROUPING
%token GetConnectAttr
%token GetCursorName
%token GetData
%token GetDescField
%token GetDescRec
%token GetDiagField
%token GetDiagRec
%token GetEnvAttr
%token GetFeatureInfo
%token GetFunctions
%token GetInfo
%token GetLength
%token GetParamData
%token GetPosition
%token GetSessionInfo
%token GetStmtAttr
%token GetSubString
%token GetTypeInfo
%token H
%token HANDLE
%token HANDLER
%token HAVING
%token HIERARCHY
%token HOLD
%token HOUR
%token High
%token I
%token IDENTITY
%token IF
%token IMMEDIATE
%token IMPLEMENTATION
%token IN
%token INDICATOR
%token INDICATOR_TYPE
%token INITIALLY
%token INNER
%token INOUT
%token INPUT
%token INSENSITIVE
%token INSERT
%token INSTANCE
%token INSTANTIABLE
%token INT
%token INTEGER
%token INTERSECT
%token INTERVAL
%token INTO
%token INVOKER
%token IS
%token ISOLATION
%token ITERATE
%token IntegrityNo
%token IntegrityYes
%token Interfaces.SQL
%token Intermediate
%token J
%token JOIN
%token K
%token KEY
%token KEY_MEMBER
%token KEY_TYPE
%token KIND
%token L
%token LANGUAGE
%token LARGE
%token LAST
%token LATERAL
%token LEADING
%token LEAVE
%token LEFT
%token LENGTH
%token LEVEL
%token LIKE
%token LOCAL
%token LOCALTIME
%token LOCALTIMESTAMP
%token LOCATOR
%token LOGICAL
%token LOOP
%token LOWER
%token Low
%token M
%token MAP
%token MATCH
%token MAX
%token MESSAGE_LENGTH
%token MESSAGE_OCTET_LENGTH
%token MESSAGE_TEXT
%token METHOD
%token MIN
%token MINUTE
%token MOD
%token MODIFIES
%token MODULE
%token MONTH
%token MORE
%token MUMPS
%token MoreResults
%token N
%token NAME
%token NAMES
%token NATIONAL
%token NATURAL
%token NCHAR
%token NCLOB
%token NESTING
%token NEW
%token NEXT
%token NO
%token NONE
%token NOT
%token NULL
%token NULLABLE
%token NULLIF
%token NUMBER
%token NUMERIC
%token NextResult
%token NumResultCols
%token O
%token OBJECT
%token OCTET_LENGTH
%token OF
%token OLD
%token ON
%token ONLY
%token OPEN
%token OPTION
%token OPTIONS
%token OR
%token ORDER
%token ORDERING
%token ORDINALITY
%token OUT
%token OUTER
%token OUTPUT
%token OVERLAPS
%token OVERLAY
%token OVERRIDING
%token P
%token PACKED
%token PAD
%token PARAMETER
%token PARAMETER_MODE
%token PARAMETER_NAME
%token PARAMETER_ORDINAL_POSITION
%token PARAMETER_SPECIFIC_CATALOG
%token PARAMETER_SPECIFIC_NAME
%token PARAMETER_SPECIFIC_SCHEMA
%token PARTIAL
%token PASCAL
%token PATH
%token PIC
%token PICTURE
%token PLACING
%token PLI
%token POSITION
%token PRECISION
%token PREPARE
%token PRESERVE
%token PRIMARY
%token PRIOR
%token PRIVILEGES
%token PROCEDURE
%token PUBLIC
%token ParamData
%token Part-
%token Prepare
%token PrimaryKeys
%token PutData
%token Q
%token R
%token READ
%token READS
%token REAL
%token RECURSIVE
%token REDO
%token REF
%token REFERENCES
%token REFERENCING
%token RELATIVE
%token RELEASE
%token REPEAT
%token REPEATABLE
%token RESIGNAL
%token RESTRICT
%token RESULT
%token RETURN
%token RETURNED_CARDINALITY
%token RETURNED_LENGTH
%token RETURNED_OCTET_LENGTH
%token RETURNED_SQLSTATE
%token RETURNS
%token REVOKE
%token RIGHT
%token ROLE
%token ROLLBACK
%token ROLLUP
%token ROUTINE
%token ROUTINE_CATALOG
%token ROUTINE_NAME
%token ROUTINE_SCHEMA
%token ROW
%token ROWS
%token ROW_COUNT
%token RowCount
%token S
%token SAVEPOINT
%token SCALE
%token SCHEMA
%token SCHEMA_NAME
%token SCOPE
%token SCOPE_CATALOG
%token SCOPE_NAME
%token SCOPE_SCHEMA
%token SCROLL
%token SEARCH
%token SECOND
%token SECTION
%token SECURITY
%token SELECT
%token SELF
%token SENSITIVE
%token SEPARATE
%token SERIALIZABLE
%token SERVER_NAME
%token SESSION
%token SESSION_USER
%token SET
%token SETS
%token SIGN
%token SIGNAL
%token SIMILAR
%token SIMPLE
%token SIZE
%token SMALLINT
%token SOME
%token SOURCE
%token SPACE
%token SPECIFIC
%token SPECIFICTYPE
%token SPECIFIC_NAME
%token SQL
%token SQLEXCEPTION
%token SQLR
%token SQLSTATE
%token SQLSTATE_TYPE
%token SQLWARNING
%token START
%token STATE
%token STATEMENT
%token STATIC
%token STRUCTURE
%token STYLE
%token SUBCLASS_ORIGIN
%token SUBSTRING
%token SUM
%token SYMMETRIC
%token SYSTEM
%token SYSTEM_USER
%token SetConnectAttr
%token SetCursorName
%token SetDescField
%token SetDescRec
%token SetEnvAttr
%token SetStmtAttr
%token SpecialColumns
%token StartTran
%token T
%token TABLE
%token TABLE_NAME
%token TEMPORARY
%token THEN
%token TIME
%token TIMESTAMP
%token TIMEZONE_HOUR
%token TIMEZONE_MINUTE
%token TO
%token TOP_LEVEL_COUNT
%token TRAILING
%token TRANSACTION
%token TRANSACTIONS_COMMITTED
%token TRANSACTIONS_ROLLED_BACK
%token TRANSACTION_ACTIVE
%token TRANSFORM
%token TRANSFORMS
%token TRANSLATE
%token TRANSLATION
%token TREAT
%token TRIGGER
%token TRIGGER_CATALOG
%token TRIGGER_NAME
%token TRIGGER_SCHEMA
%token TRIM
%token TRUE
%token TYPE
%token TablePrivileges
%token Tables
%token U
%token UNCOMMITTED
%token UNDER
%token UNDO
%token UNION
%token UNIQUE
%token UNKNOWN
%token UNNAMED
%token UNNEST
%token UNTIL
%token UPDATE
%token UPPER
%token USAGE
%token USER
%token USER_DEFINED_TYPE_CATALOG
%token USER_DEFINED_TYPE_NAME
%token USER_DEFINED_TYPE_SCHEMA
%token USING
%token V
%token VALUE
%token VALUES
%token VARCHAR
%token VARYING
%token VIEW
%token W
%token WHEN
%token WHENEVER
%token WHERE
%token WHILE
%token WITH
%token WITHOUT
%token WORK
%token WRITE
%token X
%token Y
%token YEAR
%token Z
%token ZONE
%token _
%token a
%token auto
%token b
%token c
%token char
%token const
%token d
%token directno
%token directyes
%token double
%token e
%token edition1987
%token edition1989
%token edition1992
%token edition1999
%token embeddedAda
%token embeddedC
%token embeddedCOBOL
%token embeddedFortran
%token embeddedMUMPS
%token embeddedPLI
%token embeddedPascal
%token embeddedno
%token extern
%token f
%token float
%token g
%token h
%token i
%token iso
%token j
%token k
%token l
%token long
%token m
%token moduleno
%token moduleyes
%token n
%token o
%token p
%token q
%token r
%token s
%token short
%token sqlbindings1999
%token sqlcli1999
%token sqlpsm1999
%token standard
%token static
%token t
%token u
%token unsigned
%token v
%token volatile
%token w
%token x
%token y
%token z

/* The following non-terminals were not defined */
%token module_name
%token package_pkg_i_no
%token package_pkg_i_yes
%token part_10
%token part_3
%token part_4
%token part_5
%token part_6
%token part_7
%token part_8
%token part_9
%token slash
%token target_data_type
/* End of undefined non-terminals */

/*
%rule absolute_value_expression
%rule action
%rule actual_identifier
%rule ada_array_locator_variable
%rule ada_assignment_operator
%rule ada_blob_locator_variable
%rule ada_blob_variable
%rule ada_clob_locator_variable
%rule ada_clob_variable
%rule ada_derived_type_specification
%rule ada_host_identifier
%rule ada_initial_value
%rule ada_qualified_type_specification
%rule ada_ref_variable
%rule ada_type_specification
%rule ada_unqualified_type_specification
%rule ada_user_defined_type_locator_variable
%rule ada_user_defined_type_variable
%rule ada_variable_definition
%rule add_attribute_definition
%rule add_column_definition
%rule add_column_scope_clause
%rule add_domain_constraint_definition
%rule add_original_method_specification
%rule add_overriding_method_specification
%rule add_table_constraint_definition
%rule all
%rule all_fields_reference
%rule allocate_cursor_statement
%rule allocate_descriptor_statement
%rule alphabetic_character
%rule alter_column_action
%rule alter_column_definition
%rule alter_domain_action
%rule alter_domain_statement
%rule alter_routine_behaviour
%rule alter_routine_characteristic
%rule alter_routine_characteristics
%rule alter_routine_statement
%rule alter_table_action
%rule alter_table_statement
%rule alter_type_action
%rule alter_type_statement
%rule alternate_underscore
%rule ampersand
%rule approximate_numeric_literal
%rule approximate_numeric_type
%rule arc1
%rule arc2
%rule arc3
%rule array_concatenation
%rule array_element
%rule array_element_list
%rule array_specification
%rule array_value_constructor
%rule array_value_expression
%rule array_value_expression_1
%rule array_value_expression_2
%rule array_value_list_constructor
%rule as_clause
%rule assertion_definition
%rule assignment_source
%rule assignment_statement
%rule assignment_target
%rule asterisk
%rule asterisked_identifier
%rule asterisked_identifier_chain
%rule attribute_default
%rule attribute_definition
%rule attribute_name
%rule attribute_or_method_reference
%rule authorization_identifier
%rule basic_identifier_chain
%rule beginning_label
%rule between_predicate
%rule binary_large_object_string_type
%rule binary_string_literal
%rule bit
%rule bit_concatenation
%rule bit_factor
%rule bit_length_expression
%rule bit_primary
%rule bit_string_literal
%rule bit_string_type
%rule bit_substring_function
%rule bit_value_expression
%rule bit_value_function
%rule blob_concatenation
%rule blob_factor
%rule blob_overlay_function
%rule blob_position_expression
%rule blob_primary
%rule blob_substring_function
%rule blob_trim_function
%rule blob_trim_operands
%rule blob_trim_source
%rule blob_value_expression
%rule blob_value_function
%rule boolean_factor
%rule boolean_literal
%rule boolean_primary
%rule boolean_term
%rule boolean_test
%rule boolean_type
%rule boolean_value_expression
%rule bracketed_comment
%rule bracketed_comment_contents
%rule bracketed_comment_introducer
%rule bracketed_comment_terminator
%rule c_array_locator_variable
%rule c_array_specification
%rule c_bit_variable
%rule c_blob_locator_variable
%rule c_blob_variable
%rule c_character_type
%rule c_character_variable
%rule c_class_modifier
%rule c_clob_locator_variable
%rule c_clob_variable
%rule c_derived_variable
%rule c_host_identifier
%rule c_initial_value
%rule c_nchar_variable
%rule c_nchar_varying_variable
%rule c_nclob_variable
%rule c_numeric_variable
%rule c_ref_variable
%rule c_storage_class
%rule c_user_defined_type_locator_variable
%rule c_user_defined_type_variable
%rule c_varchar_variable
%rule c_variable_definition
%rule c_variable_specification
%rule call_statement
%rule cardinality_expression
%rule case_abbreviation
%rule case_expression
%rule case_operand
%rule case_specification
%rule case_statement
%rule case_statement_else_clause
%rule cast_function
%rule cast_operand
%rule cast_option
%rule cast_specification
%rule cast_target
%rule cast_to_distinct
%rule cast_to_distinct_identifier
%rule cast_to_ref
%rule cast_to_ref_identifier
%rule cast_to_source
%rule cast_to_source_identifier
%rule cast_to_type
%rule cast_to_type_identifier
%rule catalog_name
%rule catalog_name_characteristic
%rule char_length_expression
%rule character_enumeration
%rule character_factor
%rule character_like_predicate
%rule character_match_value
%rule character_overlay_function
%rule character_pattern
%rule character_primary
%rule character_representation
%rule character_set_definition
%rule character_set_name
%rule character_set_name_characteristic
%rule character_set_source
%rule character_set_specification
%rule character_specifier
%rule character_string_literal
%rule character_string_type
%rule character_substring_function
%rule character_translation
%rule character_value_expression
%rule character_value_function
%rule check_constraint_definition
%rule circumflex
%rule cli_by_reference_prefix
%rule cli_by_value_prefix
%rule cli_generic_name
%rule cli_name_prefix
%rule cli_parameter_data_type
%rule cli_parameter_declaration
%rule cli_parameter_list
%rule cli_parameter_mode
%rule cli_parameter_name
%rule cli_returns_clause
%rule cli_routine
%rule cli_routine_name
%rule close_statement
%rule cobol_array_locator_variable
%rule cobol_binary_integer
%rule cobol_bit_type
%rule cobol_blob_locator_variable
%rule cobol_blob_variable
%rule cobol_character_type
%rule cobol_clob_locator_variable
%rule cobol_clob_variable
%rule cobol_derived_type_specification
%rule cobol_host_identifier
%rule cobol_integer_type
%rule cobol_national_character_type
%rule cobol_nclob_variable
%rule cobol_nines
%rule cobol_nines_specification
%rule cobol_numeric_type
%rule cobol_ref_variable
%rule cobol_type_specification
%rule cobol_user_defined_type_locator_variable
%rule cobol_user_defined_type_variable
%rule cobol_variable_definition
%rule collate_clause
%rule collation_definition
%rule collation_name
%rule collection_derived_table
%rule collection_type
%rule collection_type_constructor
%rule collection_value_constructor
%rule collection_value_expression
%rule colon
%rule column_constraint
%rule column_constraint_definition
%rule column_definition
%rule column_name
%rule column_name_list
%rule column_option_list
%rule column_options
%rule column_reference
%rule comma
%rule comment
%rule comment_character
%rule commit_statement
%rule comp_op
%rule comparison_predicate
%rule compound_statement
%rule computational_operation
%rule concatenated_grouping
%rule concatenation
%rule concatenation_operator
%rule condition
%rule condition_action
%rule condition_declaration
%rule condition_information
%rule condition_information_item
%rule condition_information_item_name
%rule condition_name
%rule condition_number
%rule condition_value
%rule condition_value_list
%rule connect_statement
%rule connection_name
%rule connection_object
%rule connection_target
%rule connection_user_name
%rule connector_character
%rule constraint_characteristics
%rule constraint_check_time
%rule constraint_name
%rule constraint_name_definition
%rule constraint_name_list
%rule constructor_method_selection
%rule contextually_typed_row_value_constructor
%rule contextually_typed_row_value_constructor_element
%rule contextually_typed_row_value_constructor_element_list
%rule contextually_typed_row_value_expression
%rule contextually_typed_row_value_expression_list
%rule contextually_typed_source
%rule contextually_typed_table_value_constructor
%rule contextually_typed_value_specification
%rule correlation_name
%rule corresponding_column_list
%rule corresponding_spec
%rule cross_join
%rule cube_list
%rule current_date_value_function
%rule current_local_time_value_function
%rule current_local_timestamp_value_function
%rule current_time_value_function
%rule current_timestamp_value_function
%rule cursor_holdability
%rule cursor_intent
%rule cursor_name
%rule cursor_returnability
%rule cursor_scrollability
%rule cursor_sensitivity
%rule cursor_specification
%rule cycle_clause
%rule cycle_column
%rule cycle_column_list
%rule cycle_mark_column
%rule cycle_mark_value
%rule data_type
%rule data_type_list
%rule date_literal
%rule date_string
%rule date_value
%rule datetime_factor
%rule datetime_literal
%rule datetime_primary
%rule datetime_term
%rule datetime_type
%rule datetime_value
%rule datetime_value_expression
%rule datetime_value_function
%rule day_time_interval
%rule day_time_literal
%rule days_value
%rule deallocate_descriptor_statement
%rule deallocate_prepared_statement
%rule decimal_digit_character
%rule declare_cursor
%rule default_clause
%rule default_option
%rule default_schema_name
%rule default_specification
%rule delete_rule
%rule delete_statement_positioned
%rule delete_statement_searched
%rule delimited_identifier
%rule delimited_identifier_body
%rule delimited_identifier_part
%rule delimiter_token
%rule dereference_operation
%rule dereference_operator
%rule derived_column
%rule derived_column_list
%rule derived_representation
%rule derived_table
%rule describe_input_statement
%rule describe_output_statement
%rule describe_statement
%rule described_object
%rule descriptor_item_name
%rule descriptor_name
%rule deterministic_characteristic
%rule diagnostics_size
%rule digit
%rule direct_implementation_defined_statement
%rule direct_invocation
%rule direct_select_statement_multiple_rows
%rule direct_sql_data_statement
%rule direct_sql_statement
%rule directly_executable_statement
%rule disconnect_object
%rule disconnect_statement
%rule dispatch_clause
%rule distinct_predicate
%rule domain_constraint
%rule domain_definition
%rule domain_name
%rule double_colon
%rule double_period
%rule double_quote
%rule doublequote_symbol
%rule drop_assertion_statement
%rule drop_attribute_definition
%rule drop_behavior
%rule drop_character_set_statement
%rule drop_collation_statement
%rule drop_column_default_clause
%rule drop_column_definition
%rule drop_column_scope_clause
%rule drop_data_type_statement
%rule drop_domain_constraint_definition
%rule drop_domain_default_clause
%rule drop_domain_statement
%rule drop_method_specification
%rule drop_module_statement
%rule drop_role_statement
%rule drop_routine_statement
%rule drop_schema_statement
%rule drop_table_constraint_definition
%rule drop_table_statement
%rule drop_transform_statement
%rule drop_translation_statement
%rule drop_trigger_statement
%rule drop_user_defined_cast_statement
%rule drop_user_defined_ordering_statement
%rule drop_view_statement
%rule dynamic_close_statement
%rule dynamic_cursor_name
%rule dynamic_declare_cursor
%rule dynamic_delete_statement_positioned
%rule dynamic_fetch_statement
%rule dynamic_open_statement
%rule dynamic_parameter_specification
%rule dynamic_result_sets_characteristic
%rule dynamic_select_statement
%rule dynamic_single_row_select_statement
%rule dynamic_update_statement_positioned
%rule element_reference
%rule else_clause
%rule embedded_authorization_clause
%rule embedded_authorization_declaration
%rule embedded_authorization_identifier
%rule embedded_character_set_declaration
%rule embedded_exception_declaration
%rule embedded_path_specification
%rule embedded_sql_ada_program
%rule embedded_sql_begin_declare
%rule embedded_sql_c_program
%rule embedded_sql_cobol_program
%rule embedded_sql_declare_section
%rule embedded_sql_end_declare
%rule embedded_sql_fortran_program
%rule embedded_sql_host_program
%rule embedded_sql_mumps_declare
%rule embedded_sql_mumps_program
%rule embedded_sql_pascal_program
%rule embedded_sql_pl_i_program
%rule embedded_sql_statement
%rule embedded_transform_group_specification
%rule embedded_variable_name
%rule embedded_variable_specification
%rule empty_specification
%rule end_field
%rule ending_label
%rule equals_operator
%rule equals_ordering_form
%rule escape_character
%rule escape_octet
%rule escaped_character
%rule exact_numeric_literal
%rule exact_numeric_type
%rule exclusive_user_defined_type_specification
%rule execute_immediate_statement
%rule execute_statement
%rule existing_collation_name
%rule existing_translation_name
%rule exists_predicate
%rule explicit_table
%rule exponent
%rule extended_cursor_name
%rule extended_statement_name
%rule extender_character
%rule external_body_reference
%rule external_routine_name
%rule external_security_clause
%rule externally_invoked_procedure
%rule extract_expression
%rule extract_field
%rule extract_source
%rule factor
%rule fetch_orientation
%rule fetch_statement
%rule fetch_target_list
%rule field_definition
%rule field_name
%rule field_reference
%rule finality
%rule fold
%rule for_loop_variable_name
%rule for_statement
%rule form_of_use_conversion
%rule form_of_use_conversion_name
%rule fortran_array_locator_variable
%rule fortran_blob_locator_variable
%rule fortran_blob_variable
%rule fortran_clob_locator_variable
%rule fortran_clob_variable
%rule fortran_derived_type_specification
%rule fortran_host_identifier
%rule fortran_ref_variable
%rule fortran_type_specification
%rule fortran_user_defined_type_locator_variable
%rule fortran_user_defined_type_variable
%rule fortran_variable_definition
%rule free_locator_statement
%rule from_clause
%rule from_constructor
%rule from_default
%rule from_sql
%rule from_sql_function
%rule from_subquery
%rule full_ordering_form
%rule function_specification
%rule general_literal
%rule general_set_function
%rule general_value_specification
%rule generalized_expression
%rule generalized_invocation
%rule get_descriptor_information
%rule get_descriptor_statement
%rule get_diagnostics_statement
%rule get_header_information
%rule get_item_information
%rule global_or_local
%rule go_to
%rule goto_target
%rule grand_total
%rule grant_privilege_statement
%rule grant_role_statement
%rule grant_statement
%rule grantee
%rule grantor
%rule greater_than_operator
%rule greater_than_or_equals_operator
%rule group_by_clause
%rule group_name
%rule group_specification
%rule grouping_column_reference
%rule grouping_column_reference_list
%rule grouping_element
%rule grouping_element_list
%rule grouping_operation
%rule grouping_set
%rule grouping_set_list
%rule grouping_sets_specification
%rule handler_action
%rule handler_declaration
%rule handler_type
%rule having_clause
%rule header_item_name
%rule hex_string_literal
%rule hexit
%rule high
%rule hold_locator_statement
%rule host_identifier
%rule host_label_identifier
%rule host_parameter_data_type
%rule host_parameter_declaration
%rule host_parameter_declaration_list
%rule host_parameter_declaration_setup
%rule host_parameter_name
%rule host_parameter_specification
%rule host_pl_i_label_variable
%rule host_variable_definition
%rule hours_value
%rule identifier
%rule identifier_body
%rule identifier_chain
%rule identifier_combining_character
%rule identifier_ignorable_character
%rule identifier_part
%rule identifier_start
%rule ideographic_character
%rule if_statement
%rule if_statement_else_clause
%rule if_statement_elseif_clause
%rule if_statement_then_clause
%rule implementation_defined_character_set_name
%rule implementation_defined_cli_generic_name
%rule implicitly_typed_value_specification
%rule in_predicate
%rule in_predicate_value
%rule in_value_list
%rule inclusive_user_defined_type_specification
%rule indicator_parameter
%rule indicator_variable
%rule initial_alphabetic_character
%rule input_using_clause
%rule insert_column_list
%rule insert_columns_and_source
%rule insert_statement
%rule insertion_target
%rule instantiable_clause
%rule integrity_no
%rule integrity_yes
%rule intermediate
%rule interval_absolute_value_function
%rule interval_factor
%rule interval_fractional_seconds_precision
%rule interval_leading_field_precision
%rule interval_literal
%rule interval_primary
%rule interval_qualifier
%rule interval_string
%rule interval_term
%rule interval_term_1
%rule interval_term_2
%rule interval_type
%rule interval_value_expression
%rule interval_value_expression_1
%rule interval_value_function
%rule into_argument
%rule into_arguments
%rule into_descriptor
%rule introducer
%rule isolation_level
%rule item_number
%rule iterate_statement
%rule j_1987
%rule j_1989
%rule j_1989_base
%rule j_1989_package
%rule j_1992
%rule j_1999
%rule join_column_list
%rule join_condition
%rule join_specification
%rule join_type
%rule joined_table
%rule key_word
%rule language_clause
%rule language_name
%rule large_object_length
%rule large_object_length_token
%rule lateral_derived_table
%rule leave_statement
%rule left_brace
%rule left_bracket
%rule left_bracket_or_trigraph
%rule left_bracket_trigraph
%rule left_paren
%rule length
%rule length_expression
%rule less_than_operator
%rule less_than_or_equals_operator
%rule level
%rule level_of_isolation
%rule levels_clause
%rule like_clause
%rule like_predicate
%rule list_of_attributes
%rule literal
%rule local_cursor_declaration_list
%rule local_declaration
%rule local_declaration_list
%rule local_handler_declaration_list
%rule local_or_schema_qualified_name
%rule local_or_schema_qualifier
%rule local_qualified_name
%rule local_qualifier
%rule locator_indication
%rule locator_reference
%rule loop_statement
%rule low
%rule major_category
%rule mantissa
%rule map_category
%rule map_function_specification
%rule match_predicate
%rule match_type
%rule maximum_dynamic_result_sets
%rule member
%rule member_list
%rule member_name
%rule method_characteristic
%rule method_characteristics
%rule method_invocation
%rule method_name
%rule method_reference
%rule method_selection
%rule method_specification
%rule method_specification_designator
%rule method_specification_list
%rule minus_sign
%rule minutes_value
%rule modified_field_reference
%rule modified_field_target
%rule module_authorization_clause
%rule module_authorization_identifier
%rule module_character_set_specification
%rule module_contents
%rule module_function
%rule module_name
%rule module_name_clause
%rule module_path_specification
%rule module_procedure
%rule module_routine
%rule module_transform_group_specification
%rule modulus_expression
%rule months_value
%rule multiple_group_specification
%rule multiplier
%rule mumps_array_locator_variable
%rule mumps_blob_locator_variable
%rule mumps_blob_variable
%rule mumps_character_variable
%rule mumps_clob_locator_variable
%rule mumps_clob_variable
%rule mumps_derived_type_specification
%rule mumps_host_identifier
%rule mumps_length_specification
%rule mumps_numeric_variable
%rule mumps_ref_variable
%rule mumps_type_specification
%rule mumps_user_defined_type_locator_variable
%rule mumps_user_defined_type_variable
%rule mumps_variable_definition
%rule mutated_set_clause
%rule mutated_target
%rule mutated_target_specification
%rule mutator_reference
%rule named_columns_join
%rule national_character_string_literal
%rule national_character_string_type
%rule natural_join
%rule nesting_option
%rule new_invocation
%rule new_specification
%rule new_values_correlation_name
%rule new_values_table_alias
%rule newline
%rule non_cycle_mark_value
%rule non_escaped_character
%rule non_join_query_expression
%rule non_join_query_primary
%rule non_join_query_term
%rule non_reserved_word
%rule non_second_primary_datetime_field
%rule nondelimiter_token
%rule nondoublequote_character
%rule nonparenthesized_value_expression_primary
%rule nonquote_character
%rule not_equals_operator
%rule null_call_clause
%rule null_predicate
%rule null_specification
%rule number_of_conditions
%rule numeric_primary
%rule numeric_type
%rule numeric_value_expression
%rule numeric_value_expression_dividend
%rule numeric_value_expression_divisor
%rule numeric_value_function
%rule object_column
%rule object_name
%rule object_privileges
%rule occurrences
%rule octet_length_expression
%rule octet_like_predicate
%rule octet_match_value
%rule octet_pattern
%rule old_or_new_values_alias
%rule old_or_new_values_alias_list
%rule old_values_correlation_name
%rule old_values_table_alias
%rule only_spec
%rule open_statement
%rule order_by_clause
%rule ordering_category
%rule ordering_form
%rule ordering_specification
%rule ordinary_grouping_set
%rule original_method_specification
%rule outer_join_type
%rule output_using_clause
%rule overlaps_predicate
%rule override_clause
%rule overriding_method_specification
%rule package_pkg_i_
%rule package_pkg_i_no
%rule package_pkg_i_yes
%rule packages
%rule pad_characteristic
%rule parameter_mode
%rule parameter_style
%rule parameter_style_clause
%rule parameter_type
%rule parameter_using_clause
%rule parenthesized_boolean_value_expression
%rule parenthesized_value_expression
%rule part_10
%rule part_3
%rule part_3_conformance
%rule part_3_yes
%rule part_4
%rule part_4_conformance
%rule part_4_module
%rule part_4_module_no
%rule part_4_module_yes
%rule part_4_yes
%rule part_5
%rule part_5_conformance
%rule part_5_direct
%rule part_5_direct_no
%rule part_5_direct_yes
%rule part_5_embedded
%rule part_5_embedded_ada
%rule part_5_embedded_c
%rule part_5_embedded_cobol
%rule part_5_embedded_fortran
%rule part_5_embedded_languages
%rule part_5_embedded_mumps
%rule part_5_embedded_no
%rule part_5_embedded_pascal
%rule part_5_embedded_pl_i
%rule part_5_yes
%rule part_6
%rule part_7
%rule part_8
%rule part_9
%rule part_n_
%rule part_n_no
%rule part_n_yes
%rule partial_method_specification
%rule parts
%rule pascal_array_locator_variable
%rule pascal_blob_locator_variable
%rule pascal_blob_variable
%rule pascal_clob_locator_variable
%rule pascal_clob_variable
%rule pascal_derived_type_specification
%rule pascal_host_identifier
%rule pascal_ref_variable
%rule pascal_type_specification
%rule pascal_user_defined_type_locator_variable
%rule pascal_user_defined_type_variable
%rule pascal_variable_definition
%rule path_column
%rule path_specification
%rule percent
%rule period
%rule pl_i_array_locator_variable
%rule pl_i_blob_locator_variable
%rule pl_i_blob_variable
%rule pl_i_clob_locator_variable
%rule pl_i_clob_variable
%rule pl_i_derived_type_specification
%rule pl_i_host_identifier
%rule pl_i_ref_variable
%rule pl_i_type_fixed_binary
%rule pl_i_type_fixed_decimal
%rule pl_i_type_float_binary
%rule pl_i_type_specification
%rule pl_i_user_defined_type_locator_variable
%rule pl_i_user_defined_type_variable
%rule pl_i_variable_definition
%rule plus_sign
%rule position_expression
%rule precision
%rule predefined_type
%rule predicate
%rule preparable_dynamic_delete_statement_positioned
%rule preparable_dynamic_update_statement_positioned
%rule preparable_implementation_defined_statement
%rule preparable_sql_control_statement
%rule preparable_sql_data_statement
%rule preparable_sql_schema_statement
%rule preparable_sql_session_statement
%rule preparable_sql_transaction_statement
%rule preparable_statement
%rule prepare_statement
%rule primary_datetime_field
%rule privilege_column_list
%rule privilege_method_list
%rule privileges
%rule procedure_name
%rule qualified_asterisk
%rule qualified_identifier
%rule qualified_join
%rule quantified_comparison_predicate
%rule quantifier
%rule query_expression
%rule query_expression_body
%rule query_name
%rule query_primary
%rule query_specification
%rule query_term
%rule question_mark
%rule quote
%rule quote_symbol
%rule recursive_search_order
%rule ref_cast_option
%rule reference_column_list
%rule reference_generation
%rule reference_resolution
%rule reference_scope_check
%rule reference_scope_check_action
%rule reference_type
%rule reference_type_specification
%rule reference_value_expression
%rule referenceable_view_specification
%rule referenced_table_and_columns
%rule referenced_type
%rule references_specification
%rule referencing_columns
%rule referential_action
%rule referential_constraint_definition
%rule referential_triggered_action
%rule regular_character_set
%rule regular_character_set_identifier
%rule regular_expression
%rule regular_expression_substring_function
%rule regular_factor
%rule regular_identifier
%rule regular_primary
%rule regular_term
%rule regular_view_specification
%rule relative_category
%rule relative_function_specification
%rule release_savepoint_statement
%rule repeat_statement
%rule representation
%rule reserved_word
%rule resignal_statement
%rule result
%rule result_cast
%rule result_cast_from_type
%rule result_expression
%rule result_set_cursor
%rule result_using_clause
%rule return_statement
%rule return_value
%rule returns_clause
%rule returns_data_type
%rule revoke_option_extension
%rule revoke_privilege_statement
%rule revoke_role_statement
%rule revoke_statement
%rule right_arrow
%rule right_brace
%rule right_bracket
%rule right_bracket_or_trigraph
%rule right_bracket_trigraph
%rule right_paren
%rule role_definition
%rule role_granted
%rule role_name
%rule role_revoked
%rule role_specification
%rule rollback_statement
%rule rollup_list
%rule routine_body
%rule routine_characteristic
%rule routine_characteristics
%rule routine_invocation
%rule routine_name
%rule routine_type
%rule row_subquery
%rule row_type
%rule row_type_body
%rule row_value_constructor
%rule row_value_constructor_element
%rule row_value_constructor_element_list
%rule row_value_expression
%rule row_value_expression_1
%rule row_value_expression_2
%rule row_value_expression_3
%rule row_value_expression_4
%rule row_value_expression_list
%rule row_value_special_case
%rule savepoint_clause
%rule savepoint_name
%rule savepoint_specifier
%rule savepoint_statement
%rule scalar_subquery
%rule scale
%rule schema_authorization_identifier
%rule schema_character_set_or_path
%rule schema_character_set_specification
%rule schema_definition
%rule schema_element
%rule schema_function
%rule schema_name
%rule schema_name_characteristic
%rule schema_name_clause
%rule schema_name_list
%rule schema_path_specification
%rule schema_procedure
%rule schema_qualified_name
%rule schema_qualified_routine_name
%rule schema_qualified_type_name
%rule schema_routine
%rule scope_clause
%rule scope_option
%rule search_clause
%rule search_condition
%rule search_or_cycle_clause
%rule searched_case
%rule searched_case_statement
%rule searched_case_statement_when_clause
%rule searched_when_clause
%rule seconds_fraction
%rule seconds_integer_value
%rule seconds_value
%rule select_list
%rule select_statement_single_row
%rule select_sublist
%rule select_target_list
%rule self_referencing_column_name
%rule self_referencing_column_specification
%rule semicolon
%rule separator
%rule sequence_column
%rule session_characteristic
%rule session_characteristic_list
%rule set_catalog_statement
%rule set_clause
%rule set_clause_list
%rule set_column_default_clause
%rule set_connection_statement
%rule set_constraints_mode_statement
%rule set_descriptor_information
%rule set_descriptor_statement
%rule set_domain_default_clause
%rule set_function_specification
%rule set_function_type
%rule set_header_information
%rule set_item_information
%rule set_local_time_zone_statement
%rule set_names_statement
%rule set_path_statement
%rule set_quantifier
%rule set_role_statement
%rule set_schema_statement
%rule set_session_characteristics_statement
%rule set_session_user_identifier_statement
%rule set_signal_information
%rule set_time_zone_value
%rule set_transaction_statement
%rule set_transform_group_statement
%rule sign
%rule signal_information_item
%rule signal_information_item_list
%rule signal_statement
%rule signal_value
%rule signed_integer
%rule signed_numeric_literal
%rule similar_pattern
%rule similar_predicate
%rule simple_case
%rule simple_case_operand_1
%rule simple_case_operand_2
%rule simple_case_statement
%rule simple_case_statement_when_clause
%rule simple_comment
%rule simple_comment_introducer
%rule simple_latin_letter
%rule simple_latin_lower_case_letter
%rule simple_latin_upper_case_letter
%rule simple_table
%rule simple_target_specification
%rule simple_target_specification_1
%rule simple_target_specification_2
%rule simple_value_specification
%rule simple_value_specification_1
%rule simple_value_specification_2
%rule simple_when_clause
%rule single_datetime_field
%rule single_group_specification
%rule slash
%rule solidus
%rule some
%rule sort_key
%rule sort_specification
%rule sort_specification_list
%rule source_character_set_specification
%rule source_data_type
%rule space
%rule specific_method_name
%rule specific_method_specification_designator
%rule specific_name
%rule specific_routine_designator
%rule specific_type_method
%rule sql_argument
%rule sql_argument_list
%rule sql_client_module_definition
%rule sql_client_module_name
%rule sql_condition
%rule sql_conformance
%rule sql_connection_statement
%rule sql_control_statement
%rule sql_data_access_indication
%rule sql_data_change_statement
%rule sql_data_statement
%rule sql_diagnostics_information
%rule sql_diagnostics_statement
%rule sql_dynamic_data_statement
%rule sql_dynamic_statement
%rule sql_edition
%rule sql_executable_statement
%rule sql_invoked_function
%rule sql_invoked_procedure
%rule sql_invoked_routine
%rule sql_language_character
%rule sql_language_identifier
%rule sql_language_identifier_part
%rule sql_language_identifier_start
%rule sql_object_identifier
%rule sql_parameter_declaration
%rule sql_parameter_declaration_list
%rule sql_parameter_name
%rule sql_parameter_reference
%rule sql_path_characteristic
%rule sql_prefix
%rule sql_procedure_statement
%rule sql_provenance
%rule sql_routine_body
%rule sql_schema_definition_statement
%rule sql_schema_manipulation_statement
%rule sql_schema_statement
%rule sql_server_module_character_set_specification
%rule sql_server_module_contents
%rule sql_server_module_definition
%rule sql_server_module_name
%rule sql_server_module_path_specification
%rule sql_server_module_schema_clause
%rule sql_server_name
%rule sql_session_statement
%rule sql_special_character
%rule sql_statement_list
%rule sql_statement_name
%rule sql_statement_variable
%rule sql_terminal_character
%rule sql_terminator
%rule sql_transaction_statement
%rule sql_variable_declaration
%rule sql_variable_name
%rule sql_variable_name_list
%rule sql_variable_reference
%rule sql_variant
%rule sqlstate_char
%rule sqlstate_class_value
%rule sqlstate_subclass_value
%rule sqlstate_value
%rule standard_character_set_name
%rule start_field
%rule start_position
%rule start_transaction_statement
%rule state_category
%rule statement_cursor
%rule statement_information
%rule statement_information_item
%rule statement_information_item_name
%rule statement_label
%rule statement_name
%rule statement_or_declaration
%rule static_method_invocation
%rule static_method_selection
%rule status_parameter
%rule string_length
%rule string_position_expression
%rule string_value_expression
%rule string_value_function
%rule subquery
%rule subtable_clause
%rule subtype_clause
%rule subtype_operand
%rule subtype_treatment
%rule subview_clause
%rule supertable_clause
%rule supertable_name
%rule supertype_name
%rule system_descriptor_statement
%rule system_generated_representation
%rule table_commit_action
%rule table_constraint
%rule table_constraint_definition
%rule table_contents_source
%rule table_definition
%rule table_element
%rule table_element_list
%rule table_expression
%rule table_name
%rule table_or_query_name
%rule table_primary
%rule table_reference
%rule table_reference_list
%rule table_scope
%rule table_subquery
%rule table_value_constructor
%rule target_character_set_specification
%rule target_data_type
%rule target_specification
%rule target_subtype
%rule target_table
%rule temporary_table_declaration
%rule term
%rule terminated_local_cursor_declaration
%rule terminated_local_declaration
%rule terminated_local_handler_declaration
%rule terminated_sql_statement
%rule time_fractional_seconds_precision
%rule time_interval
%rule time_literal
%rule time_precision
%rule time_string
%rule time_value
%rule time_zone
%rule time_zone_field
%rule time_zone_interval
%rule time_zone_specifier
%rule timestamp_literal
%rule timestamp_precision
%rule timestamp_string
%rule to_sql
%rule to_sql_function
%rule token
%rule transaction_access_mode
%rule transaction_characteristics
%rule transaction_mode
%rule transform_definition
%rule transform_element
%rule transform_element_list
%rule transform_group
%rule transform_group_characteristic
%rule transform_group_element
%rule transform_group_specification
%rule transforms_to_be_dropped
%rule translation_definition
%rule translation_name
%rule translation_routine
%rule translation_source
%rule trigger_action_time
%rule trigger_column_list
%rule trigger_definition
%rule trigger_event
%rule trigger_name
%rule triggered_action
%rule triggered_sql_statement
%rule trim_character
%rule trim_function
%rule trim_octet
%rule trim_operands
%rule trim_source
%rule trim_specification
%rule truth_value
%rule type_list
%rule type_predicate
%rule underscore
%rule union_join
%rule unique_column_list
%rule unique_constraint_definition
%rule unique_predicate
%rule unique_specification
%rule unqualified_schema_name
%rule unquoted_date_string
%rule unquoted_interval_string
%rule unquoted_time_string
%rule unquoted_timestamp_string
%rule unsigned_integer
%rule unsigned_literal
%rule unsigned_numeric_literal
%rule unsigned_value_specification
%rule updatability_clause
%rule update_rule
%rule update_source
%rule update_statement_positioned
%rule update_statement_searched
%rule update_target
%rule user_defined_cast_definition
%rule user_defined_character_set_name
%rule user_defined_ordering_definition
%rule user_defined_representation
%rule user_defined_type
%rule user_defined_type_body
%rule user_defined_type_definition
%rule user_defined_type_name
%rule user_defined_type_specification
%rule user_defined_type_value_expression
%rule user_identifier
%rule using_argument
%rule using_arguments
%rule using_descriptor
%rule using_input_descriptor
%rule value_expression
%rule value_expression_primary
%rule value_specification
%rule vertical_bar
%rule view_column_list
%rule view_column_option
%rule view_definition
%rule view_element
%rule view_element_list
%rule view_specification
%rule when_operand
%rule where_clause
%rule while_statement
%rule white_space
%rule with_clause
%rule with_column_list
%rule with_list
%rule with_list_element
%rule with_or_without_time_zone
%rule year_month_literal
%rule years_value
*/

%start bnf_program

%%

bnf_program
	:	bnf_statement
	|	bnf_program bnf_statement
	;

bnf_statement
	:	cli_routine
	|	concatenated_grouping
	|	constructor_method_selection
	|	dereference_operation
	|	direct_sql_statement
	|	embedded_sql_declare_section
	|	embedded_sql_host_program
	|	embedded_sql_statement
	|	method_reference
	|	method_selection
	|	new_invocation
	|	part_3_yes
	|	part_4_yes
	|	part_5_yes
	|	part_n_
	|	preparable_statement
	|	sql_client_module_definition
	|	sql_object_identifier
	|	sql_terminal_character
	|	static_method_selection
	|	token
	;

sql_object_identifier
	:	sql_provenance sql_variant
	;

sql_provenance
	:	arc1 arc2 arc3
	;

arc1
	:	iso
	|	1
	|	iso left_paren 1 right_paren
	;

arc2
	:	standard
	|	0
	|	standard left_paren 0 right_paren
	;

arc3
	:	9075
	;

sql_variant
	:	sql_edition sql_conformance
	;

sql_edition
	:	j_1987
	|	j_1989
	|	j_1992
	|	j_1999
	;

j_1987
	:	0
	|	edition1987 left_paren 0 right_paren
	;

j_1989
	:	j_1989_base j_1989_package
	;

j_1989_base
	:	1
	|	edition1989 left_paren 1 right_paren
	;

j_1989_package
	:	integrity_no
	|	integrity_yes
	;

integrity_no
	:	0
	|	IntegrityNo left_paren 0 right_paren
	;

integrity_yes
	:	1
	|	IntegrityYes left_paren 1 right_paren
	;

j_1992
	:	2
	|	edition1992 left_paren 2 right_paren
	;

j_1999
	:	3
	|	edition1999 left_paren 3 right_paren
	;

sql_conformance
	:	level parts packages
	;

level
	:	low
	|	intermediate
	|	high
	;

low
	:	0
	|	Low left_paren 0 right_paren
	;

intermediate
	:	1
	|	Intermediate left_paren 1 right_paren
	;

high
	:	2
	|	High left_paren 2 right_paren
	;

parts
	:	part_3 part_4 part_5 part_6 part_7 part_8 part_9 part_10
	;

lst_nt_001
	:	package_pkg_i_
	|	lst_nt_001 package_pkg_i_
	;

packages
	:	lst_nt_001
	;

part_n_
	:	part_n_no
	|	part_n_yes
	;

part_n_no
	:	0
	|	Part-
	;

part_n_yes
	:	/* !! (as specified in ISO/IEC 9075-(n)) */
	;

package_pkg_i_
	:	package_pkg_i_yes
	|	package_pkg_i_no
	;

part_3_yes
	:	part_3_conformance
	;

part_3_conformance
	:	3
	|	sqlcli1999 left_paren 3 right_paren
	;

part_4_yes
	:	part_4_conformance part_4_module
	;

part_4_conformance
	:	4
	|	sqlpsm1999 left_paren 4 right_paren
	;

part_4_module
	:	part_4_module_yes
	|	part_4_module_no
	;

part_4_module_yes
	:	1
	|	moduleyes left_paren 1 right_paren
	;

part_4_module_no
	:	0
	|	moduleno left_paren 0 right_paren
	;

part_5_yes
	:	part_5_conformance part_5_direct part_5_embedded
	;

part_5_conformance
	:	5
	|	sqlbindings1999 left_paren 5 right_paren
	;

part_5_direct
	:	part_5_direct_yes
	|	part_5_direct_no
	;

part_5_direct_yes
	:	1
	|	directyes left_paren 1 right_paren
	;

part_5_direct_no
	:	0
	|	directno left_paren 0 right_paren
	;

lst_nt_002
	:	part_5_embedded_languages
	|	lst_nt_002 part_5_embedded_languages
	;

part_5_embedded
	:	part_5_embedded_no
	|	lst_nt_002
	;

part_5_embedded_no
	:	0
	|	embeddedno left_paren 0 right_paren
	;

part_5_embedded_languages
	:	part_5_embedded_ada
	|	part_5_embedded_c
	|	part_5_embedded_cobol
	|	part_5_embedded_fortran
	|	part_5_embedded_mumps
	|	part_5_embedded_pascal
	|	part_5_embedded_pl_i
	;

part_5_embedded_ada
	:	1
	|	embeddedAda left_paren 1 right_paren
	;

part_5_embedded_c
	:	2
	|	embeddedC left_paren 2 right_paren
	;

part_5_embedded_cobol
	:	3
	|	embeddedCOBOL left_paren 3 right_paren
	;

part_5_embedded_fortran
	:	4
	|	embeddedFortran left_paren 4 right_paren
	;

part_5_embedded_mumps
	:	5
	|	embeddedMUMPS left_paren 5 right_paren
	;

part_5_embedded_pascal
	:	6
	|	embeddedPascal left_paren 6 right_paren
	;

part_5_embedded_pl_i
	:	7
	|	embeddedPLI left_paren 7 right_paren
	;

sql_terminal_character
	:	sql_language_character
	;

sql_language_character
	:	simple_latin_letter
	|	digit
	|	sql_special_character
	;

simple_latin_letter
	:	simple_latin_upper_case_letter
	|	simple_latin_lower_case_letter
	;

simple_latin_upper_case_letter
	:	A
	|	B
	|	C
	|	D
	|	E
	|	F
	|	G
	|	H
	|	I
	|	J
	|	K
	|	L
	|	M
	|	N
	|	O
	|	P
	|	Q
	|	R
	|	S
	|	T
	|	U
	|	V
	|	W
	|	X
	|	Y
	|	Z
	;

simple_latin_lower_case_letter
	:	a
	|	b
	|	c
	|	d
	|	e
	|	f
	|	g
	|	h
	|	i
	|	j
	|	k
	|	l
	|	m
	|	n
	|	o
	|	p
	|	q
	|	r
	|	s
	|	t
	|	u
	|	v
	|	w
	|	x
	|	y
	|	z
	;

digit
	:	0
	|	1
	|	2
	|	3
	|	4
	|	5
	|	6
	|	7
	|	8
	|	9
	;

sql_special_character
	:	space
	|	double_quote
	|	percent
	|	ampersand
	|	quote
	|	left_paren
	|	right_paren
	|	asterisk
	|	plus_sign
	|	comma
	|	minus_sign
	|	period
	|	solidus
	|	colon
	|	semicolon
	|	less_than_operator
	|	equals_operator
	|	greater_than_operator
	|	question_mark
	|	left_bracket
	|	right_bracket
	|	circumflex
	|	underscore
	|	vertical_bar
	|	left_brace
	|	right_brace
	;

space
	:	/* !! (See the Syntax Rules) */
	;

double_quote
	:	'"'
	;

percent
	:	'%'
	;

ampersand
	:	'&'
	;

quote
	:	'\''
	;

left_paren
	:	'('
	;

right_paren
	:	')'
	;

asterisk
	:	'*'
	;

plus_sign
	:	'+'
	;

comma
	:	','
	;

minus_sign
	:	'-'
	;

period
	:	'.'
	;

solidus
	:	'/'
	;

colon
	:	':'
	;

semicolon
	:	';'
	;

less_than_operator
	:	'<'
	;

equals_operator
	:	'='
	;

greater_than_operator
	:	'>'
	;

question_mark
	:	'?'
	;

left_bracket
	:	'['
	;

right_bracket
	:	']'
	;

circumflex
	:	'^'
	;

underscore
	:	_
	;

vertical_bar
	:	'|'
	;

left_brace
	:	'{'
	;

right_brace
	:	'}'
	;

opt_nt_003
	:	/* Nothing */
	|	module_path_specification
	;

opt_nt_004
	:	/* Nothing */
	|	module_transform_group_specification
	;

lst_nt_006
	:	temporary_table_declaration
	|	lst_nt_006 temporary_table_declaration
	;

opt_nt_005
	:	/* Nothing */
	|	lst_nt_006
	;

lst_nt_007
	:	module_contents
	|	lst_nt_007 module_contents
	;

sql_client_module_definition
	:	module_name_clause language_clause module_authorization_clause opt_nt_003 opt_nt_004 opt_nt_005 lst_nt_007
	;

opt_nt_008
	:	/* Nothing */
	|	sql_client_module_name
	;

opt_nt_009
	:	/* Nothing */
	|	module_character_set_specification ']'
	;

module_name_clause
	:	MODULE opt_nt_008 opt_nt_009
	;

sql_client_module_name
	:	identifier
	;

identifier
	:	actual_identifier
	;

actual_identifier
	:	regular_identifier
	|	delimited_identifier
	;

regular_identifier
	:	identifier_body
	;

lst_nt_011
	:	identifier_part
	|	lst_nt_011 identifier_part
	;

opt_nt_010
	:	/* Nothing */
	|	lst_nt_011 ']'
	;

identifier_body
	:	identifier_start opt_nt_010
	;

identifier_start
	:	initial_alphabetic_character
	|	ideographic_character
	;

initial_alphabetic_character
	:	/* !! (See the Syntax Rules) */
	;

ideographic_character
	:	/* !! (See the Syntax Rules) */
	;

identifier_part
	:	alphabetic_character
	|	ideographic_character
	|	decimal_digit_character
	|	identifier_combining_character
	|	underscore
	|	alternate_underscore
	|	extender_character
	|	identifier_ignorable_character
	|	connector_character
	;

alphabetic_character
	:	/* !! (See the Syntax Rules) */
	;

decimal_digit_character
	:	/* !! (See the Syntax Rules) */
	;

identifier_combining_character
	:	/* !! (See the Syntax Rules) */
	;

alternate_underscore
	:	/* !! (See the Syntax Rules) */
	;

extender_character
	:	/* !! (See the Syntax Rules) */
	;

identifier_ignorable_character
	:	/* !! (See the Syntax Rules) */
	;

connector_character
	:	/* !! (See the Syntax Rules) */
	;

delimited_identifier
	:	double_quote delimited_identifier_body double_quote
	;

lst_nt_012
	:	delimited_identifier_part
	|	lst_nt_012 delimited_identifier_part
	;

delimited_identifier_body
	:	lst_nt_012
	;

delimited_identifier_part
	:	nondoublequote_character
	|	doublequote_symbol
	;

nondoublequote_character
	:	/* !! (See the Syntax Rules) */
	;

doublequote_symbol
	:	double_quote double_quote
	;

module_character_set_specification
	:	NAMES ARE character_set_specification
	;

character_set_specification
	:	standard_character_set_name
	|	implementation_defined_character_set_name
	|	user_defined_character_set_name
	;

standard_character_set_name
	:	character_set_name
	;

opt_nt_013
	:	/* Nothing */
	|	schema_name period
	;

character_set_name
	:	opt_nt_013 sql_language_identifier
	;

opt_nt_014
	:	/* Nothing */
	|	catalog_name period
	;

schema_name
	:	opt_nt_014 unqualified_schema_name
	;

catalog_name
	:	identifier
	;

unqualified_schema_name
	:	identifier
	;

seq_nt_016
	:	underscore
	|	sql_language_identifier_part
	;

lst_nt_017
	:	seq_nt_016
	|	lst_nt_017 seq_nt_016
	;

opt_nt_015
	:	/* Nothing */
	|	lst_nt_017 ']'
	;

sql_language_identifier
	:	sql_language_identifier_start opt_nt_015
	;

sql_language_identifier_start
	:	simple_latin_letter
	;

sql_language_identifier_part
	:	simple_latin_letter
	|	digit
	;

implementation_defined_character_set_name
	:	character_set_name
	;

user_defined_character_set_name
	:	character_set_name
	;

language_clause
	:	LANGUAGE language_name
	;

language_name
	:	ADA
	|	C
	|	COBOL
	|	FORTRAN
	|	MUMPS
	|	PASCAL
	|	PLI
	|	SQL
	;

module_authorization_clause
	:	SCHEMA schema_name
	|	AUTHORIZATION module_authorization_identifier
	|	SCHEMA schema_name AUTHORIZATION module_authorization_identifier
	;

module_authorization_identifier
	:	authorization_identifier
	;

authorization_identifier
	:	role_name
	|	user_identifier
	;

role_name
	:	identifier
	;

user_identifier
	:	identifier
	;

module_path_specification
	:	path_specification
	;

path_specification
	:	PATH schema_name_list
	;

seq_nt_019
	:	comma schema_name
	;

lst_nt_020
	:	seq_nt_019
	|	lst_nt_020 seq_nt_019
	;

opt_nt_018
	:	/* Nothing */
	|	lst_nt_020 ']'
	;

schema_name_list
	:	schema_name opt_nt_018
	;

module_transform_group_specification
	:	transform_group_specification
	;

seq_nt_021
	:	single_group_specification
	|	multiple_group_specification '}'
	;

transform_group_specification
	:	TRANSFORM GROUP seq_nt_021
	;

single_group_specification
	:	group_name
	;

group_name
	:	identifier
	;

seq_nt_023
	:	comma group_specification
	;

lst_nt_024
	:	seq_nt_023
	|	lst_nt_024 seq_nt_023
	;

opt_nt_022
	:	/* Nothing */
	|	lst_nt_024 ']'
	;

multiple_group_specification
	:	group_specification opt_nt_022
	;

group_specification
	:	group_name FOR TYPE user_defined_type
	;

user_defined_type
	:	user_defined_type_name
	;

user_defined_type_name
	:	schema_qualified_type_name
	;

opt_nt_025
	:	/* Nothing */
	|	schema_name period
	;

schema_qualified_type_name
	:	opt_nt_025 qualified_identifier
	;

qualified_identifier
	:	identifier
	;

opt_nt_026
	:	/* Nothing */
	|	ON COMMIT table_commit_action ROWS ']'
	;

temporary_table_declaration
	:	DECLARE LOCAL TEMPORARY TABLE table_name table_element_list opt_nt_026
	;

table_name
	:	local_or_schema_qualified_name
	;

opt_nt_027
	:	/* Nothing */
	|	local_or_schema_qualifier period
	;

local_or_schema_qualified_name
	:	opt_nt_027 qualified_identifier
	;

local_or_schema_qualifier
	:	schema_name
	|	MODULE
	;

seq_nt_029
	:	comma table_element
	;

lst_nt_030
	:	seq_nt_029
	|	lst_nt_030 seq_nt_029
	;

opt_nt_028
	:	/* Nothing */
	|	lst_nt_030
	;

table_element_list
	:	left_paren table_element opt_nt_028 right_paren
	;

table_element
	:	column_definition
	|	table_constraint_definition
	|	like_clause
	|	self_referencing_column_specification
	|	column_options
	;

seq_nt_031
	:	data_type
	|	domain_name
	;

opt_nt_032
	:	/* Nothing */
	|	reference_scope_check
	;

opt_nt_033
	:	/* Nothing */
	|	default_clause
	;

lst_nt_035
	:	column_constraint_definition
	|	lst_nt_035 column_constraint_definition
	;

opt_nt_034
	:	/* Nothing */
	|	lst_nt_035
	;

opt_nt_036
	:	/* Nothing */
	|	collate_clause ']'
	;

column_definition
	:	column_name seq_nt_031 opt_nt_032 opt_nt_033 opt_nt_034 opt_nt_036
	;

column_name
	:	identifier
	;

data_type
	:	predefined_type
	|	row_type
	|	user_defined_type
	|	reference_type
	|	collection_type
	;

opt_nt_037
	:	/* Nothing */
	|	CHARACTER SET character_set_specification
	;

predefined_type
	:	character_string_type opt_nt_037
	|	national_character_string_type
	|	binary_large_object_string_type
	|	bit_string_type
	|	numeric_type
	|	boolean_type
	|	datetime_type
	|	interval_type
	;

opt_nt_038
	:	/* Nothing */
	|	left_paren length right_paren
	;

opt_nt_039
	:	/* Nothing */
	|	left_paren length right_paren
	;

opt_nt_040
	:	/* Nothing */
	|	left_paren large_object_length right_paren
	;

opt_nt_041
	:	/* Nothing */
	|	left_paren large_object_length right_paren
	;

opt_nt_042
	:	/* Nothing */
	|	left_paren large_object_length right_paren ']'
	;

character_string_type
	:	CHARACTER opt_nt_038
	|	CHAR opt_nt_039
	|	CHARACTER VARYING left_paren length right_paren
	|	CHAR VARYING left_paren length right_paren
	|	VARCHAR left_paren length right_paren
	|	CHARACTER LARGE OBJECT opt_nt_040
	|	CHAR LARGE OBJECT opt_nt_041
	|	CLOB opt_nt_042
	;

length
	:	unsigned_integer
	;

lst_nt_043
	:	digit
	|	lst_nt_043 digit
	;

unsigned_integer
	:	lst_nt_043
	;

opt_nt_044
	:	/* Nothing */
	|	multiplier
	;

large_object_length
	:	unsigned_integer opt_nt_044
	|	large_object_length_token
	;

multiplier
	:	K
	|	M
	|	G
	;

lst_nt_045
	:	digit
	|	lst_nt_045 digit
	;

large_object_length_token
	:	lst_nt_045 multiplier
	;

opt_nt_046
	:	/* Nothing */
	|	left_paren length right_paren
	;

opt_nt_047
	:	/* Nothing */
	|	left_paren length right_paren
	;

opt_nt_048
	:	/* Nothing */
	|	left_paren length right_paren
	;

opt_nt_049
	:	/* Nothing */
	|	left_paren large_object_length right_paren
	;

opt_nt_050
	:	/* Nothing */
	|	left_paren large_object_length right_paren
	;

opt_nt_051
	:	/* Nothing */
	|	left_paren large_object_length right_paren ']'
	;

national_character_string_type
	:	NATIONAL CHARACTER opt_nt_046
	|	NATIONAL CHAR opt_nt_047
	|	NCHAR opt_nt_048
	|	NATIONAL CHARACTER VARYING left_paren length right_paren
	|	NATIONAL CHAR VARYING left_paren length right_paren
	|	NCHAR VARYING left_paren length right_paren
	|	NATIONAL CHARACTER LARGE OBJECT opt_nt_049
	|	NCHAR LARGE OBJECT opt_nt_050
	|	NCLOB opt_nt_051
	;

opt_nt_052
	:	/* Nothing */
	|	left_paren large_object_length right_paren
	;

opt_nt_053
	:	/* Nothing */
	|	left_paren large_object_length right_paren ']'
	;

binary_large_object_string_type
	:	BINARY LARGE OBJECT opt_nt_052
	|	BLOB opt_nt_053
	;

opt_nt_054
	:	/* Nothing */
	|	left_paren length right_paren
	;

bit_string_type
	:	BIT opt_nt_054
	|	BIT VARYING left_paren length right_paren
	;

numeric_type
	:	exact_numeric_type
	|	approximate_numeric_type
	;

opt_nt_056
	:	/* Nothing */
	|	comma scale
	;

opt_nt_055
	:	/* Nothing */
	|	left_paren precision opt_nt_056 right_paren
	;

opt_nt_058
	:	/* Nothing */
	|	comma scale
	;

opt_nt_057
	:	/* Nothing */
	|	left_paren precision opt_nt_058 right_paren
	;

opt_nt_060
	:	/* Nothing */
	|	comma scale
	;

opt_nt_059
	:	/* Nothing */
	|	left_paren precision opt_nt_060 right_paren
	;

exact_numeric_type
	:	NUMERIC opt_nt_055
	|	DECIMAL opt_nt_057
	|	DEC opt_nt_059
	|	INTEGER
	|	INT
	|	SMALLINT
	;

precision
	:	unsigned_integer
	;

scale
	:	unsigned_integer
	;

opt_nt_061
	:	/* Nothing */
	|	left_paren precision right_paren
	;

approximate_numeric_type
	:	FLOAT opt_nt_061
	|	REAL
	|	DOUBLE PRECISION
	;

boolean_type
	:	BOOLEAN
	;

opt_nt_062
	:	/* Nothing */
	|	left_paren time_precision right_paren
	;

opt_nt_063
	:	/* Nothing */
	|	with_or_without_time_zone
	;

opt_nt_064
	:	/* Nothing */
	|	left_paren timestamp_precision right_paren
	;

opt_nt_065
	:	/* Nothing */
	|	with_or_without_time_zone ']'
	;

datetime_type
	:	DATE
	|	TIME opt_nt_062 opt_nt_063
	|	TIMESTAMP opt_nt_064 opt_nt_065
	;

time_precision
	:	time_fractional_seconds_precision
	;

time_fractional_seconds_precision
	:	unsigned_integer
	;

with_or_without_time_zone
	:	WITH TIME ZONE
	|	WITHOUT TIME ZONE
	;

timestamp_precision
	:	time_fractional_seconds_precision
	;

interval_type
	:	INTERVAL interval_qualifier
	;

interval_qualifier
	:	start_field TO end_field
	|	single_datetime_field
	;

opt_nt_066
	:	/* Nothing */
	|	left_paren interval_leading_field_precision right_paren ']'
	;

start_field
	:	non_second_primary_datetime_field opt_nt_066
	;

non_second_primary_datetime_field
	:	YEAR
	|	MONTH
	|	DAY
	|	HOUR
	|	MINUTE
	;

interval_leading_field_precision
	:	unsigned_integer
	;

opt_nt_067
	:	/* Nothing */
	|	left_paren interval_fractional_seconds_precision right_paren ']'
	;

end_field
	:	non_second_primary_datetime_field
	|	SECOND opt_nt_067
	;

interval_fractional_seconds_precision
	:	unsigned_integer
	;

opt_nt_068
	:	/* Nothing */
	|	left_paren interval_leading_field_precision right_paren
	;

opt_nt_070
	:	/* Nothing */
	|	comma interval_fractional_seconds_precision
	;

opt_nt_069
	:	/* Nothing */
	|	left_paren interval_leading_field_precision opt_nt_070 right_paren ']'
	;

single_datetime_field
	:	non_second_primary_datetime_field opt_nt_068
	|	SECOND opt_nt_069
	;

row_type
	:	ROW row_type_body
	;

seq_nt_072
	:	comma field_definition
	;

lst_nt_073
	:	seq_nt_072
	|	lst_nt_073 seq_nt_072
	;

opt_nt_071
	:	/* Nothing */
	|	lst_nt_073
	;

row_type_body
	:	left_paren field_definition opt_nt_071 right_paren
	;

opt_nt_074
	:	/* Nothing */
	|	reference_scope_check
	;

opt_nt_075
	:	/* Nothing */
	|	collate_clause ']'
	;

field_definition
	:	field_name data_type opt_nt_074 opt_nt_075
	;

field_name
	:	identifier
	;

opt_nt_076
	:	/* Nothing */
	|	NOT
	;

opt_nt_077
	:	/* Nothing */
	|	ON DELETE reference_scope_check_action ']'
	;

reference_scope_check
	:	REFERENCES ARE opt_nt_076 CHECKED opt_nt_077
	;

reference_scope_check_action
	:	referential_action
	;

referential_action
	:	CASCADE
	|	SET NULL
	|	SET DEFAULT
	|	RESTRICT
	|	NO ACTION
	;

collate_clause
	:	COLLATE collation_name
	;

collation_name
	:	schema_qualified_name
	;

opt_nt_078
	:	/* Nothing */
	|	schema_name period
	;

schema_qualified_name
	:	opt_nt_078 qualified_identifier
	;

opt_nt_079
	:	/* Nothing */
	|	scope_clause ']'
	;

reference_type
	:	REF left_paren referenced_type right_paren opt_nt_079
	;

referenced_type
	:	user_defined_type
	;

scope_clause
	:	SCOPE table_name
	;

collection_type
	:	data_type array_specification
	;

array_specification
	:	collection_type_constructor left_bracket_or_trigraph unsigned_integer right_bracket_or_trigraph
	;

collection_type_constructor
	:	ARRAY
	;

left_bracket_or_trigraph
	:	left_bracket
	|	left_bracket_trigraph
	;

left_bracket_trigraph
	:	question_mark question_mark left_paren
	;

right_bracket_or_trigraph
	:	right_bracket
	|	right_bracket_trigraph
	;

right_bracket_trigraph
	:	question_mark question_mark right_paren
	;

domain_name
	:	schema_qualified_name
	;

default_clause
	:	DEFAULT default_option
	;

default_option
	:	literal
	|	datetime_value_function
	|	USER
	|	CURRENT_USER
	|	CURRENT_ROLE
	|	SESSION_USER
	|	SYSTEM_USER
	|	CURRENT_PATH
	|	implicitly_typed_value_specification
	;

literal
	:	signed_numeric_literal
	|	general_literal
	;

opt_nt_080
	:	/* Nothing */
	|	sign
	;

signed_numeric_literal
	:	opt_nt_080 unsigned_numeric_literal
	;

sign
	:	plus_sign
	|	minus_sign
	;

unsigned_numeric_literal
	:	exact_numeric_literal
	|	approximate_numeric_literal
	;

opt_nt_082
	:	/* Nothing */
	|	unsigned_integer
	;

opt_nt_081
	:	/* Nothing */
	|	period opt_nt_082
	;

exact_numeric_literal
	:	unsigned_integer opt_nt_081
	|	period unsigned_integer
	;

approximate_numeric_literal
	:	mantissa E exponent
	;

mantissa
	:	exact_numeric_literal
	;

exponent
	:	signed_integer
	;

opt_nt_083
	:	/* Nothing */
	|	sign
	;

signed_integer
	:	opt_nt_083 unsigned_integer
	;

general_literal
	:	character_string_literal
	|	national_character_string_literal
	|	bit_string_literal
	|	hex_string_literal
	|	binary_string_literal
	|	datetime_literal
	|	interval_literal
	|	boolean_literal
	;

opt_nt_084
	:	/* Nothing */
	|	introducer character_set_specification
	;

lst_nt_086
	:	character_representation
	|	lst_nt_086 character_representation
	;

opt_nt_085
	:	/* Nothing */
	|	lst_nt_086
	;

lst_nt_090
	:	character_representation
	|	lst_nt_090 character_representation
	;

opt_nt_089
	:	/* Nothing */
	|	lst_nt_090
	;

seq_nt_088
	:	separator quote opt_nt_089 quote
	;

lst_nt_091
	:	seq_nt_088
	|	lst_nt_091 seq_nt_088
	;

opt_nt_087
	:	/* Nothing */
	|	lst_nt_091 ']'
	;

character_string_literal
	:	opt_nt_084 quote opt_nt_085 quote opt_nt_087
	;

introducer
	:	underscore
	;

character_representation
	:	nonquote_character
	|	quote_symbol
	;

nonquote_character
	:	/* !! (See the Syntax Rules.) */
	;

quote_symbol
	:	quote quote
	;

seq_nt_092
	:	comment
	|	white_space
	;

lst_nt_093
	:	seq_nt_092
	|	lst_nt_093 seq_nt_092
	;

separator
	:	lst_nt_093
	;

comment
	:	simple_comment
	|	bracketed_comment
	;

lst_nt_095
	:	comment_character
	|	lst_nt_095 comment_character
	;

opt_nt_094
	:	/* Nothing */
	|	lst_nt_095
	;

simple_comment
	:	simple_comment_introducer opt_nt_094 newline
	;

lst_nt_097
	:	minus_sign
	|	lst_nt_097 minus_sign
	;

opt_nt_096
	:	/* Nothing */
	|	lst_nt_097 ']'
	;

simple_comment_introducer
	:	minus_sign minus_sign opt_nt_096
	;

comment_character
	:	nonquote_character
	|	quote
	;

newline
	:	/* !! (See the Syntax Rules) */
	;

bracketed_comment
	:	bracketed_comment_introducer bracketed_comment_contents bracketed_comment_terminator
	;

bracketed_comment_introducer
	:	slash asterisk
	;

seq_nt_099
	:	comment_character
	|	separator
	;

lst_nt_100
	:	seq_nt_099
	|	lst_nt_100 seq_nt_099
	;

opt_nt_098
	:	/* Nothing */
	|	lst_nt_100 ']'
	;

bracketed_comment_contents
	:	opt_nt_098
	;

bracketed_comment_terminator
	:	asterisk slash
	;

white_space
	:	/* !! (See the Syntax Rules) */
	;

lst_nt_102
	:	character_representation
	|	lst_nt_102 character_representation
	;

opt_nt_101
	:	/* Nothing */
	|	lst_nt_102
	;

lst_nt_106
	:	character_representation
	|	lst_nt_106 character_representation
	;

opt_nt_105
	:	/* Nothing */
	|	lst_nt_106
	;

seq_nt_104
	:	separator quote opt_nt_105 quote
	;

lst_nt_107
	:	seq_nt_104
	|	lst_nt_107 seq_nt_104
	;

opt_nt_103
	:	/* Nothing */
	|	lst_nt_107 ']'
	;

national_character_string_literal
	:	N quote opt_nt_101 quote opt_nt_103
	;

lst_nt_109
	:	bit
	|	lst_nt_109 bit
	;

opt_nt_108
	:	/* Nothing */
	|	lst_nt_109
	;

lst_nt_113
	:	bit
	|	lst_nt_113 bit
	;

opt_nt_112
	:	/* Nothing */
	|	lst_nt_113
	;

seq_nt_111
	:	separator quote opt_nt_112 quote
	;

lst_nt_114
	:	seq_nt_111
	|	lst_nt_114 seq_nt_111
	;

opt_nt_110
	:	/* Nothing */
	|	lst_nt_114 ']'
	;

bit_string_literal
	:	B quote opt_nt_108 quote opt_nt_110
	;

bit
	:	0
	|	1
	;

lst_nt_116
	:	hexit
	|	lst_nt_116 hexit
	;

opt_nt_115
	:	/* Nothing */
	|	lst_nt_116
	;

lst_nt_120
	:	hexit
	|	lst_nt_120 hexit
	;

opt_nt_119
	:	/* Nothing */
	|	lst_nt_120
	;

seq_nt_118
	:	separator quote opt_nt_119 quote
	;

lst_nt_121
	:	seq_nt_118
	|	lst_nt_121 seq_nt_118
	;

opt_nt_117
	:	/* Nothing */
	|	lst_nt_121 ']'
	;

hex_string_literal
	:	X quote opt_nt_115 quote opt_nt_117
	;

hexit
	:	digit
	|	A
	|	B
	|	C
	|	D
	|	E
	|	F
	|	a
	|	b
	|	c
	|	d
	|	e
	|	f
	;

seq_nt_123
	:	hexit hexit
	;

lst_nt_124
	:	seq_nt_123
	|	lst_nt_124 seq_nt_123
	;

opt_nt_122
	:	/* Nothing */
	|	lst_nt_124
	;

seq_nt_128
	:	hexit hexit
	;

lst_nt_129
	:	seq_nt_128
	|	lst_nt_129 seq_nt_128
	;

opt_nt_127
	:	/* Nothing */
	|	lst_nt_129
	;

seq_nt_126
	:	separator quote opt_nt_127 quote
	;

lst_nt_130
	:	seq_nt_126
	|	lst_nt_130 seq_nt_126
	;

opt_nt_125
	:	/* Nothing */
	|	lst_nt_130 ']'
	;

binary_string_literal
	:	X quote opt_nt_122 quote opt_nt_125
	;

datetime_literal
	:	date_literal
	|	time_literal
	|	timestamp_literal
	;

date_literal
	:	DATE date_string
	;

date_string
	:	quote unquoted_date_string quote
	;

unquoted_date_string
	:	date_value
	;

date_value
	:	years_value minus_sign months_value minus_sign days_value
	;

years_value
	:	datetime_value
	;

datetime_value
	:	unsigned_integer
	;

months_value
	:	datetime_value
	;

days_value
	:	datetime_value
	;

time_literal
	:	TIME time_string
	;

time_string
	:	quote unquoted_time_string quote
	;

opt_nt_131
	:	/* Nothing */
	|	time_zone_interval ']'
	;

unquoted_time_string
	:	time_value opt_nt_131
	;

time_value
	:	hours_value colon minutes_value colon seconds_value
	;

hours_value
	:	datetime_value
	;

minutes_value
	:	datetime_value
	;

opt_nt_133
	:	/* Nothing */
	|	seconds_fraction
	;

opt_nt_132
	:	/* Nothing */
	|	period opt_nt_133 ']'
	;

seconds_value
	:	seconds_integer_value opt_nt_132
	;

seconds_integer_value
	:	unsigned_integer
	;

seconds_fraction
	:	unsigned_integer
	;

time_zone_interval
	:	sign hours_value colon minutes_value
	;

timestamp_literal
	:	TIMESTAMP timestamp_string
	;

timestamp_string
	:	quote unquoted_timestamp_string quote
	;

unquoted_timestamp_string
	:	unquoted_date_string space unquoted_time_string
	;

opt_nt_134
	:	/* Nothing */
	|	sign
	;

interval_literal
	:	INTERVAL opt_nt_134 interval_string interval_qualifier
	;

interval_string
	:	quote unquoted_interval_string quote
	;

opt_nt_135
	:	/* Nothing */
	|	sign
	;

seq_nt_136
	:	year_month_literal
	|	day_time_literal '}'
	;

unquoted_interval_string
	:	opt_nt_135 seq_nt_136
	;

opt_nt_137
	:	/* Nothing */
	|	years_value minus_sign
	;

year_month_literal
	:	years_value
	|	opt_nt_137 months_value
	;

day_time_literal
	:	day_time_interval
	|	time_interval
	;

opt_nt_140
	:	/* Nothing */
	|	colon seconds_value
	;

opt_nt_139
	:	/* Nothing */
	|	colon minutes_value opt_nt_140
	;

opt_nt_138
	:	/* Nothing */
	|	space hours_value opt_nt_139 ']'
	;

day_time_interval
	:	days_value opt_nt_138
	;

opt_nt_142
	:	/* Nothing */
	|	colon seconds_value
	;

opt_nt_141
	:	/* Nothing */
	|	colon minutes_value opt_nt_142
	;

opt_nt_143
	:	/* Nothing */
	|	colon seconds_value
	;

time_interval
	:	hours_value opt_nt_141
	|	minutes_value opt_nt_143
	|	seconds_value
	;

boolean_literal
	:	TRUE
	|	FALSE
	|	UNKNOWN
	;

datetime_value_function
	:	current_date_value_function
	|	current_time_value_function
	|	current_timestamp_value_function
	|	current_local_time_value_function
	|	current_local_timestamp_value_function
	;

current_date_value_function
	:	CURRENT_DATE
	;

opt_nt_144
	:	/* Nothing */
	|	left_paren time_precision right_paren ']'
	;

current_time_value_function
	:	CURRENT_TIME opt_nt_144
	;

opt_nt_145
	:	/* Nothing */
	|	left_paren timestamp_precision right_paren ']'
	;

current_timestamp_value_function
	:	CURRENT_TIMESTAMP opt_nt_145
	;

opt_nt_146
	:	/* Nothing */
	|	left_paren time_precision right_paren ']'
	;

current_local_time_value_function
	:	LOCALTIME opt_nt_146
	;

opt_nt_147
	:	/* Nothing */
	|	left_paren timestamp_precision right_paren ']'
	;

current_local_timestamp_value_function
	:	LOCALTIMESTAMP opt_nt_147
	;

implicitly_typed_value_specification
	:	null_specification
	|	empty_specification
	;

null_specification
	:	NULL
	;

empty_specification
	:	ARRAY left_bracket_or_trigraph right_bracket_or_trigraph
	;

opt_nt_148
	:	/* Nothing */
	|	constraint_name_definition
	;

opt_nt_149
	:	/* Nothing */
	|	constraint_characteristics ']'
	;

column_constraint_definition
	:	opt_nt_148 column_constraint opt_nt_149
	;

constraint_name_definition
	:	CONSTRAINT constraint_name
	;

constraint_name
	:	schema_qualified_name
	;

column_constraint
	:	NOT NULL
	|	unique_specification
	|	references_specification
	|	check_constraint_definition
	;

unique_specification
	:	UNIQUE
	|	PRIMARY KEY
	;

opt_nt_150
	:	/* Nothing */
	|	MATCH match_type
	;

opt_nt_151
	:	/* Nothing */
	|	referential_triggered_action ']'
	;

references_specification
	:	REFERENCES referenced_table_and_columns opt_nt_150 opt_nt_151
	;

opt_nt_152
	:	/* Nothing */
	|	left_paren reference_column_list right_paren ']'
	;

referenced_table_and_columns
	:	table_name opt_nt_152
	;

reference_column_list
	:	column_name_list
	;

seq_nt_154
	:	comma column_name
	;

lst_nt_155
	:	seq_nt_154
	|	lst_nt_155 seq_nt_154
	;

opt_nt_153
	:	/* Nothing */
	|	lst_nt_155 ']'
	;

column_name_list
	:	column_name opt_nt_153
	;

match_type
	:	FULL
	|	PARTIAL
	|	SIMPLE
	;

opt_nt_156
	:	/* Nothing */
	|	delete_rule
	;

opt_nt_157
	:	/* Nothing */
	|	update_rule ']'
	;

referential_triggered_action
	:	update_rule opt_nt_156
	|	delete_rule opt_nt_157
	;

update_rule
	:	ON UPDATE referential_action
	;

delete_rule
	:	ON DELETE referential_action
	;

check_constraint_definition
	:	CHECK left_paren search_condition right_paren
	;

search_condition
	:	boolean_value_expression
	;

boolean_value_expression
	:	boolean_term
	|	boolean_value_expression OR boolean_term
	;

boolean_term
	:	boolean_factor
	|	boolean_term AND boolean_factor
	;

opt_nt_158
	:	/* Nothing */
	|	NOT
	;

boolean_factor
	:	opt_nt_158 boolean_test
	;

opt_nt_160
	:	/* Nothing */
	|	NOT
	;

opt_nt_159
	:	/* Nothing */
	|	IS opt_nt_160 truth_value ']'
	;

boolean_test
	:	boolean_primary opt_nt_159
	;

boolean_primary
	:	predicate
	|	parenthesized_boolean_value_expression
	|	nonparenthesized_value_expression_primary
	;

predicate
	:	comparison_predicate
	|	between_predicate
	|	in_predicate
	|	like_predicate
	|	null_predicate
	|	quantified_comparison_predicate
	|	exists_predicate
	|	unique_predicate
	|	match_predicate
	|	overlaps_predicate
	|	similar_predicate
	|	distinct_predicate
	|	type_predicate
	;

comparison_predicate
	:	row_value_expression comp_op row_value_expression
	;

row_value_expression
	:	row_value_special_case
	|	row_value_constructor
	;

row_value_special_case
	:	value_specification
	|	value_expression
	;

value_specification
	:	literal
	|	general_value_specification
	;

general_value_specification
	:	host_parameter_specification
	|	sql_parameter_reference
	|	sql_variable_reference
	|	dynamic_parameter_specification
	|	embedded_variable_specification
	|	CURRENT_DEFAULT_TRANSFORM_GROUP
	|	CURRENT_PATH
	|	CURRENT_ROLE
	|	CURRENT_TRANSFORM_GROUP_FOR_TYPE user_defined_type
	|	CURRENT_USER
	|	SESSION_USER
	|	SYSTEM_USER
	|	USER
	|	VALUE
	;

opt_nt_161
	:	/* Nothing */
	|	indicator_parameter ']'
	;

host_parameter_specification
	:	host_parameter_name opt_nt_161
	;

host_parameter_name
	:	colon identifier
	;

opt_nt_162
	:	/* Nothing */
	|	INDICATOR
	;

indicator_parameter
	:	opt_nt_162 host_parameter_name
	;

sql_parameter_reference
	:	basic_identifier_chain
	;

basic_identifier_chain
	:	identifier_chain
	;

seq_nt_164
	:	period identifier
	;

lst_nt_165
	:	seq_nt_164
	|	lst_nt_165 seq_nt_164
	;

opt_nt_163
	:	/* Nothing */
	|	lst_nt_165 ']'
	;

identifier_chain
	:	identifier opt_nt_163
	;

value_expression
	:	numeric_value_expression
	|	string_value_expression
	|	datetime_value_expression
	|	interval_value_expression
	|	boolean_value_expression
	|	user_defined_type_value_expression
	|	row_value_expression
	|	reference_value_expression
	|	collection_value_expression
	;

numeric_value_expression
	:	term
	|	numeric_value_expression plus_sign term
	|	numeric_value_expression minus_sign term
	;

term
	:	factor
	|	term asterisk factor
	|	term solidus factor
	;

opt_nt_166
	:	/* Nothing */
	|	sign
	;

factor
	:	opt_nt_166 numeric_primary
	;

numeric_primary
	:	value_expression_primary
	|	numeric_value_function
	;

value_expression_primary
	:	parenthesized_value_expression
	|	nonparenthesized_value_expression_primary
	;

parenthesized_value_expression
	:	left_paren value_expression right_paren
	;

nonparenthesized_value_expression_primary
	:	unsigned_value_specification
	|	column_reference
	|	set_function_specification
	|	scalar_subquery
	|	case_expression
	|	cast_specification
	|	subtype_treatment
	|	attribute_or_method_reference
	|	reference_resolution
	|	collection_value_constructor
	|	routine_invocation
	|	field_reference
	|	element_reference
	|	method_invocation
	|	static_method_invocation
	|	new_specification
	;

unsigned_value_specification
	:	unsigned_literal
	|	general_value_specification
	;

unsigned_literal
	:	unsigned_numeric_literal
	|	general_literal
	;

column_reference
	:	basic_identifier_chain
	|	MODULE period qualified_identifier period column_name
	;

set_function_specification
	:	COUNT left_paren asterisk right_paren
	|	general_set_function
	|	grouping_operation
	;

opt_nt_167
	:	/* Nothing */
	|	set_quantifier
	;

general_set_function
	:	set_function_type left_paren opt_nt_167 value_expression right_paren
	;

set_function_type
	:	computational_operation
	;

computational_operation
	:	AVG
	|	MAX
	|	MIN
	|	SUM
	|	EVERY
	|	ANY
	|	SOME
	|	COUNT
	;

set_quantifier
	:	DISTINCT
	|	ALL
	;

grouping_operation
	:	GROUPING left_paren column_reference right_paren
	;

scalar_subquery
	:	subquery
	;

subquery
	:	left_paren query_expression right_paren
	;

opt_nt_168
	:	/* Nothing */
	|	with_clause
	;

query_expression
	:	opt_nt_168 query_expression_body
	;

opt_nt_169
	:	/* Nothing */
	|	RECURSIVE
	;

with_clause
	:	WITH opt_nt_169 with_list
	;

seq_nt_171
	:	comma with_list_element
	;

lst_nt_172
	:	seq_nt_171
	|	lst_nt_172 seq_nt_171
	;

opt_nt_170
	:	/* Nothing */
	|	lst_nt_172 ']'
	;

with_list
	:	with_list_element opt_nt_170
	;

opt_nt_173
	:	/* Nothing */
	|	left_paren with_column_list right_paren
	;

opt_nt_174
	:	/* Nothing */
	|	search_or_cycle_clause ']'
	;

with_list_element
	:	query_name opt_nt_173 AS left_paren query_expression right_paren opt_nt_174
	;

query_name
	:	identifier
	;

with_column_list
	:	column_name_list
	;

search_or_cycle_clause
	:	search_clause
	|	cycle_clause
	|	search_clause cycle_clause
	;

search_clause
	:	SEARCH recursive_search_order SET sequence_column
	;

recursive_search_order
	:	DEPTH FIRST BY sort_specification_list
	|	BREADTH FIRST BY sort_specification_list
	;

seq_nt_176
	:	comma sort_specification
	;

lst_nt_177
	:	seq_nt_176
	|	lst_nt_177 seq_nt_176
	;

opt_nt_175
	:	/* Nothing */
	|	lst_nt_177 ']'
	;

sort_specification_list
	:	sort_specification opt_nt_175
	;

opt_nt_178
	:	/* Nothing */
	|	ordering_specification ']'
	;

sort_specification
	:	sort_key opt_nt_178
	;

sort_key
	:	value_expression
	;

ordering_specification
	:	ASC
	|	DESC
	;

sequence_column
	:	column_name
	;

cycle_clause
	:	CYCLE cycle_column_list SET cycle_mark_column TO cycle_mark_value DEFAULT non_cycle_mark_value USING path_column
	;

seq_nt_180
	:	comma cycle_column
	;

lst_nt_181
	:	seq_nt_180
	|	lst_nt_181 seq_nt_180
	;

opt_nt_179
	:	/* Nothing */
	|	lst_nt_181 ']'
	;

cycle_column_list
	:	cycle_column opt_nt_179
	;

cycle_column
	:	column_name
	;

cycle_mark_column
	:	column_name
	;

cycle_mark_value
	:	value_expression
	;

non_cycle_mark_value
	:	value_expression
	;

path_column
	:	column_name
	;

query_expression_body
	:	non_join_query_expression
	|	joined_table
	;

opt_nt_182
	:	/* Nothing */
	|	ALL
	|	DISTINCT
	;

opt_nt_183
	:	/* Nothing */
	|	corresponding_spec
	;

opt_nt_184
	:	/* Nothing */
	|	ALL
	|	DISTINCT
	;

opt_nt_185
	:	/* Nothing */
	|	corresponding_spec
	;

non_join_query_expression
	:	non_join_query_term
	|	query_expression_body UNION opt_nt_182 opt_nt_183 query_term
	|	query_expression_body EXCEPT opt_nt_184 opt_nt_185 query_term
	;

opt_nt_186
	:	/* Nothing */
	|	ALL
	|	DISTINCT
	;

opt_nt_187
	:	/* Nothing */
	|	corresponding_spec
	;

non_join_query_term
	:	non_join_query_primary
	|	query_term INTERSECT opt_nt_186 opt_nt_187 query_primary
	;

non_join_query_primary
	:	simple_table
	|	left_paren non_join_query_expression right_paren
	;

simple_table
	:	query_specification
	|	table_value_constructor
	|	explicit_table
	;

opt_nt_188
	:	/* Nothing */
	|	set_quantifier
	;

query_specification
	:	SELECT opt_nt_188 select_list table_expression
	;

seq_nt_190
	:	comma select_sublist
	;

lst_nt_191
	:	seq_nt_190
	|	lst_nt_191 seq_nt_190
	;

opt_nt_189
	:	/* Nothing */
	|	lst_nt_191 ']'
	;

select_list
	:	asterisk
	|	select_sublist opt_nt_189
	;

select_sublist
	:	derived_column
	|	qualified_asterisk
	;

opt_nt_192
	:	/* Nothing */
	|	as_clause ']'
	;

derived_column
	:	value_expression opt_nt_192
	;

opt_nt_193
	:	/* Nothing */
	|	AS
	;

as_clause
	:	opt_nt_193 column_name
	;

qualified_asterisk
	:	asterisked_identifier_chain period asterisk
	|	all_fields_reference
	;

seq_nt_195
	:	period asterisked_identifier
	;

lst_nt_196
	:	seq_nt_195
	|	lst_nt_196 seq_nt_195
	;

opt_nt_194
	:	/* Nothing */
	|	lst_nt_196 ']'
	;

asterisked_identifier_chain
	:	asterisked_identifier opt_nt_194
	;

asterisked_identifier
	:	identifier
	;

all_fields_reference
	:	value_expression_primary period asterisk
	;

opt_nt_197
	:	/* Nothing */
	|	where_clause
	;

opt_nt_198
	:	/* Nothing */
	|	group_by_clause
	;

opt_nt_199
	:	/* Nothing */
	|	having_clause ']'
	;

table_expression
	:	from_clause opt_nt_197 opt_nt_198 opt_nt_199
	;

from_clause
	:	FROM table_reference_list
	;

seq_nt_201
	:	comma table_reference
	;

lst_nt_202
	:	seq_nt_201
	|	lst_nt_202 seq_nt_201
	;

opt_nt_200
	:	/* Nothing */
	|	lst_nt_202 ']'
	;

table_reference_list
	:	table_reference opt_nt_200
	;

table_reference
	:	table_primary
	|	joined_table
	;

opt_nt_204
	:	/* Nothing */
	|	AS
	;

opt_nt_205
	:	/* Nothing */
	|	left_paren derived_column_list right_paren
	;

opt_nt_203
	:	/* Nothing */
	|	opt_nt_204 correlation_name opt_nt_205
	;

opt_nt_206
	:	/* Nothing */
	|	AS
	;

opt_nt_207
	:	/* Nothing */
	|	left_paren derived_column_list right_paren
	;

opt_nt_208
	:	/* Nothing */
	|	AS
	;

opt_nt_209
	:	/* Nothing */
	|	left_paren derived_column_list right_paren
	;

opt_nt_210
	:	/* Nothing */
	|	AS
	;

opt_nt_211
	:	/* Nothing */
	|	left_paren derived_column_list right_paren
	;

opt_nt_213
	:	/* Nothing */
	|	AS
	;

opt_nt_214
	:	/* Nothing */
	|	left_paren derived_column_list right_paren
	;

opt_nt_212
	:	/* Nothing */
	|	opt_nt_213 correlation_name opt_nt_214
	;

table_primary
	:	table_or_query_name opt_nt_203
	|	derived_table opt_nt_206 correlation_name opt_nt_207
	|	lateral_derived_table opt_nt_208 correlation_name opt_nt_209
	|	collection_derived_table opt_nt_210 correlation_name opt_nt_211
	|	only_spec opt_nt_212
	|	left_paren joined_table right_paren
	;

table_or_query_name
	:	table_name
	|	query_name
	;

correlation_name
	:	identifier
	;

derived_column_list
	:	column_name_list
	;

derived_table
	:	table_subquery
	;

table_subquery
	:	subquery
	;

lateral_derived_table
	:	LATERAL left_paren query_expression right_paren
	;

opt_nt_215
	:	/* Nothing */
	|	WITH ORDINALITY ']'
	;

collection_derived_table
	:	UNNEST left_paren collection_value_expression right_paren opt_nt_215
	;

collection_value_expression
	:	value_expression_primary
	;

only_spec
	:	ONLY left_paren table_or_query_name right_paren
	;

joined_table
	:	cross_join
	|	qualified_join
	|	natural_join
	|	union_join
	;

cross_join
	:	table_reference CROSS JOIN table_primary
	;

opt_nt_216
	:	/* Nothing */
	|	join_type
	;

qualified_join
	:	table_reference opt_nt_216 JOIN table_reference join_specification
	;

opt_nt_217
	:	/* Nothing */
	|	OUTER ']'
	;

join_type
	:	INNER
	|	outer_join_type opt_nt_217
	;

outer_join_type
	:	LEFT
	|	RIGHT
	|	FULL
	;

join_specification
	:	join_condition
	|	named_columns_join
	;

join_condition
	:	ON search_condition
	;

named_columns_join
	:	USING left_paren join_column_list right_paren
	;

join_column_list
	:	column_name_list
	;

opt_nt_218
	:	/* Nothing */
	|	join_type
	;

natural_join
	:	table_reference NATURAL opt_nt_218 JOIN table_primary
	;

union_join
	:	table_reference UNION JOIN table_primary
	;

where_clause
	:	WHERE search_condition
	;

group_by_clause
	:	GROUP BY grouping_element_list
	;

seq_nt_220
	:	comma grouping_element
	;

lst_nt_221
	:	seq_nt_220
	|	lst_nt_221 seq_nt_220
	;

opt_nt_219
	:	/* Nothing */
	|	lst_nt_221 ']'
	;

grouping_element_list
	:	grouping_element opt_nt_219
	;

grouping_element
	:	ordinary_grouping_set
	|	rollup_list
	|	cube_list
	|	grouping_sets_specification
	|	grand_total
	;

opt_nt_222
	:	/* Nothing */
	|	collate_clause ']'
	;

grouping_column_reference
	:	column_reference opt_nt_222
	;

rollup_list
	:	ROLLUP left_paren grouping_column_reference_list right_paren
	;

seq_nt_224
	:	comma grouping_column_reference
	;

lst_nt_225
	:	seq_nt_224
	|	lst_nt_225 seq_nt_224
	;

opt_nt_223
	:	/* Nothing */
	|	lst_nt_225 ']'
	;

grouping_column_reference_list
	:	grouping_column_reference opt_nt_223
	;

cube_list
	:	CUBE left_paren grouping_column_reference_list right_paren
	;

grouping_sets_specification
	:	GROUPING SETS left_paren grouping_set_list right_paren
	;

seq_nt_227
	:	comma grouping_set
	;

lst_nt_228
	:	seq_nt_227
	|	lst_nt_228 seq_nt_227
	;

opt_nt_226
	:	/* Nothing */
	|	lst_nt_228 ']'
	;

grouping_set_list
	:	grouping_set opt_nt_226
	;

grouping_set
	:	ordinary_grouping_set
	|	rollup_list
	|	cube_list
	|	grouping_sets_specification
	|	grand_total
	;

ordinary_grouping_set
	:	grouping_column_reference
	|	left_paren grouping_column_reference_list right_paren
	;

grand_total
	:	left_paren right_paren
	;

concatenated_grouping
	:	grouping_set comma grouping_set_list
	;

having_clause
	:	HAVING search_condition
	;

table_value_constructor
	:	VALUES row_value_expression_list
	;

seq_nt_230
	:	comma row_value_expression
	;

lst_nt_231
	:	seq_nt_230
	|	lst_nt_231 seq_nt_230
	;

opt_nt_229
	:	/* Nothing */
	|	lst_nt_231 ']'
	;

row_value_expression_list
	:	row_value_expression opt_nt_229
	;

explicit_table
	:	TABLE table_name
	;

query_term
	:	non_join_query_term
	|	joined_table
	;

opt_nt_232
	:	/* Nothing */
	|	BY left_paren corresponding_column_list right_paren ']'
	;

corresponding_spec
	:	CORRESPONDING opt_nt_232
	;

corresponding_column_list
	:	column_name_list
	;

query_primary
	:	non_join_query_primary
	|	joined_table
	;

case_expression
	:	case_abbreviation
	|	case_specification
	;

seq_nt_233
	:	comma value_expression
	;

lst_nt_234
	:	seq_nt_233
	|	lst_nt_234 seq_nt_233
	;

case_abbreviation
	:	NULLIF left_paren value_expression comma value_expression right_paren
	|	COALESCE left_paren value_expression lst_nt_234 right_paren
	;

case_specification
	:	simple_case
	|	searched_case
	;

lst_nt_235
	:	simple_when_clause
	|	lst_nt_235 simple_when_clause
	;

opt_nt_236
	:	/* Nothing */
	|	else_clause
	;

simple_case
	:	CASE case_operand lst_nt_235 opt_nt_236 END
	;

case_operand
	:	value_expression
	;

simple_when_clause
	:	WHEN when_operand THEN result
	;

when_operand
	:	value_expression
	;

result
	:	result_expression
	|	NULL
	;

result_expression
	:	value_expression
	;

else_clause
	:	ELSE result
	;

lst_nt_237
	:	searched_when_clause
	|	lst_nt_237 searched_when_clause
	;

opt_nt_238
	:	/* Nothing */
	|	else_clause
	;

searched_case
	:	CASE lst_nt_237 opt_nt_238 END
	;

searched_when_clause
	:	WHEN search_condition THEN result
	;

cast_specification
	:	CAST left_paren cast_operand AS cast_target right_paren
	;

cast_operand
	:	value_expression
	|	implicitly_typed_value_specification
	;

cast_target
	:	domain_name
	|	data_type
	;

subtype_treatment
	:	TREAT left_paren subtype_operand AS target_subtype right_paren
	;

subtype_operand
	:	value_expression
	;

target_subtype
	:	user_defined_type
	;

opt_nt_239
	:	/* Nothing */
	|	sql_argument_list ']'
	;

attribute_or_method_reference
	:	value_expression_primary dereference_operator qualified_identifier opt_nt_239
	;

dereference_operator
	:	right_arrow
	;

right_arrow
	:	
	;

seq_nt_242
	:	comma sql_argument
	;

lst_nt_243
	:	seq_nt_242
	|	lst_nt_243 seq_nt_242
	;

opt_nt_241
	:	/* Nothing */
	|	lst_nt_243
	;

opt_nt_240
	:	/* Nothing */
	|	sql_argument opt_nt_241
	;

sql_argument_list
	:	left_paren opt_nt_240 right_paren
	;

sql_argument
	:	value_expression
	|	generalized_expression
	|	target_specification
	;

generalized_expression
	:	value_expression AS user_defined_type
	;

target_specification
	:	host_parameter_specification
	|	sql_parameter_reference
	|	column_reference
	|	sql_variable_reference
	|	dynamic_parameter_specification
	|	embedded_variable_specification
	;

reference_resolution
	:	DEREF left_paren reference_value_expression right_paren
	;

reference_value_expression
	:	value_expression_primary
	;

collection_value_constructor
	:	array_value_expression
	;

array_value_expression
	:	array_value_constructor
	|	array_concatenation
	|	value_expression_primary
	;

array_value_constructor
	:	array_value_list_constructor
	;

array_value_list_constructor
	:	ARRAY left_bracket_or_trigraph array_element_list right_bracket_or_trigraph
	;

seq_nt_245
	:	comma array_element
	;

lst_nt_246
	:	seq_nt_245
	|	lst_nt_246 seq_nt_245
	;

opt_nt_244
	:	/* Nothing */
	|	lst_nt_246 ']'
	;

array_element_list
	:	array_element opt_nt_244
	;

array_element
	:	value_expression
	;

array_concatenation
	:	array_value_expression_1 concatenation_operator array_value_expression_2
	;

array_value_expression_1
	:	array_value_expression
	;

concatenation_operator
	:	
	|	'|'
	;

array_value_expression_2
	:	array_value_expression
	;

routine_invocation
	:	routine_name sql_argument_list
	;

opt_nt_247
	:	/* Nothing */
	|	schema_name period
	;

routine_name
	:	opt_nt_247 qualified_identifier
	;

field_reference
	:	value_expression_primary period field_name
	;

element_reference
	:	array_value_expression left_bracket_or_trigraph numeric_value_expression right_bracket_or_trigraph
	;

method_invocation
	:	direct_invocation
	|	generalized_invocation
	;

opt_nt_248
	:	/* Nothing */
	|	sql_argument_list ']'
	;

direct_invocation
	:	value_expression_primary period method_name opt_nt_248
	;

method_name
	:	identifier
	;

opt_nt_249
	:	/* Nothing */
	|	sql_argument_list ']'
	;

generalized_invocation
	:	left_paren value_expression_primary AS data_type right_paren period method_name opt_nt_249
	;

constructor_method_selection
	:	routine_invocation
	;

opt_nt_250
	:	/* Nothing */
	|	sql_argument_list ']'
	;

static_method_invocation
	:	user_defined_type double_colon method_name opt_nt_250
	;

double_colon
	:	colon colon
	;

new_specification
	:	NEW routine_invocation
	;

numeric_value_function
	:	position_expression
	|	extract_expression
	|	length_expression
	|	cardinality_expression
	|	absolute_value_expression
	|	modulus_expression
	;

position_expression
	:	string_position_expression
	|	blob_position_expression
	;

string_position_expression
	:	POSITION left_paren string_value_expression IN string_value_expression right_paren
	;

string_value_expression
	:	character_value_expression
	|	bit_value_expression
	|	blob_value_expression
	;

character_value_expression
	:	concatenation
	|	character_factor
	;

concatenation
	:	character_value_expression concatenation_operator character_factor
	;

opt_nt_251
	:	/* Nothing */
	|	collate_clause ']'
	;

character_factor
	:	character_primary opt_nt_251
	;

character_primary
	:	value_expression_primary
	|	string_value_function
	;

string_value_function
	:	character_value_function
	|	blob_value_function
	|	bit_value_function
	;

character_value_function
	:	character_substring_function
	|	regular_expression_substring_function
	|	fold
	|	form_of_use_conversion
	|	character_translation
	|	trim_function
	|	character_overlay_function
	|	specific_type_method
	;

opt_nt_252
	:	/* Nothing */
	|	FOR string_length
	;

character_substring_function
	:	SUBSTRING left_paren character_value_expression FROM start_position opt_nt_252 right_paren
	;

start_position
	:	numeric_value_expression
	;

string_length
	:	numeric_value_expression
	;

regular_expression_substring_function
	:	SUBSTRING left_paren character_value_expression SIMILAR character_value_expression ESCAPE escape_character right_paren
	;

escape_character
	:	character_value_expression
	;

seq_nt_253
	:	UPPER
	|	LOWER
	;

fold
	:	seq_nt_253 left_paren character_value_expression right_paren
	;

form_of_use_conversion
	:	CONVERT left_paren character_value_expression USING form_of_use_conversion_name right_paren
	;

form_of_use_conversion_name
	:	schema_qualified_name
	;

character_translation
	:	TRANSLATE left_paren character_value_expression USING translation_name right_paren
	;

translation_name
	:	schema_qualified_name
	;

trim_function
	:	TRIM left_paren trim_operands right_paren
	;

opt_nt_255
	:	/* Nothing */
	|	trim_specification
	;

opt_nt_256
	:	/* Nothing */
	|	trim_character
	;

opt_nt_254
	:	/* Nothing */
	|	opt_nt_255 opt_nt_256 FROM
	;

trim_operands
	:	opt_nt_254 trim_source
	;

trim_specification
	:	LEADING
	|	TRAILING
	|	BOTH
	;

trim_character
	:	character_value_expression
	;

trim_source
	:	character_value_expression
	;

opt_nt_257
	:	/* Nothing */
	|	FOR string_length
	;

character_overlay_function
	:	OVERLAY left_paren character_value_expression PLACING character_value_expression FROM start_position opt_nt_257 right_paren
	;

specific_type_method
	:	user_defined_type_value_expression period SPECIFICTYPE
	;

user_defined_type_value_expression
	:	value_expression_primary
	;

blob_value_function
	:	blob_substring_function
	|	blob_trim_function
	|	blob_overlay_function
	;

opt_nt_258
	:	/* Nothing */
	|	FOR string_length
	;

blob_substring_function
	:	SUBSTRING left_paren blob_value_expression FROM start_position opt_nt_258 right_paren
	;

blob_value_expression
	:	blob_concatenation
	|	blob_factor
	;

blob_concatenation
	:	blob_value_expression concatenation_operator blob_factor
	;

blob_factor
	:	blob_primary
	;

blob_primary
	:	value_expression_primary
	|	string_value_function
	;

blob_trim_function
	:	TRIM left_paren blob_trim_operands right_paren
	;

opt_nt_260
	:	/* Nothing */
	|	trim_specification
	;

opt_nt_261
	:	/* Nothing */
	|	trim_octet
	;

opt_nt_259
	:	/* Nothing */
	|	opt_nt_260 opt_nt_261 FROM
	;

blob_trim_operands
	:	opt_nt_259 blob_trim_source
	;

trim_octet
	:	blob_value_expression
	;

blob_trim_source
	:	blob_value_expression
	;

opt_nt_262
	:	/* Nothing */
	|	FOR string_length
	;

blob_overlay_function
	:	OVERLAY left_paren blob_value_expression PLACING blob_value_expression FROM start_position opt_nt_262 right_paren
	;

bit_value_function
	:	bit_substring_function
	;

opt_nt_263
	:	/* Nothing */
	|	FOR string_length
	;

bit_substring_function
	:	SUBSTRING left_paren bit_value_expression FROM start_position opt_nt_263 right_paren
	;

bit_value_expression
	:	bit_concatenation
	|	bit_factor
	;

bit_concatenation
	:	bit_value_expression concatenation_operator bit_factor
	;

bit_factor
	:	bit_primary
	;

bit_primary
	:	value_expression_primary
	|	string_value_function
	;

blob_position_expression
	:	POSITION left_paren blob_value_expression IN blob_value_expression right_paren
	;

extract_expression
	:	EXTRACT left_paren extract_field FROM extract_source right_paren
	;

extract_field
	:	primary_datetime_field
	|	time_zone_field
	;

primary_datetime_field
	:	non_second_primary_datetime_field
	|	SECOND
	;

time_zone_field
	:	TIMEZONE_HOUR
	|	TIMEZONE_MINUTE
	;

extract_source
	:	datetime_value_expression
	|	interval_value_expression
	;

datetime_value_expression
	:	datetime_term
	|	interval_value_expression plus_sign datetime_term
	|	datetime_value_expression plus_sign interval_term
	|	datetime_value_expression minus_sign interval_term
	;

interval_term
	:	interval_factor
	|	interval_term_2 asterisk factor
	|	interval_term_2 solidus factor
	|	term asterisk interval_factor
	;

opt_nt_264
	:	/* Nothing */
	|	sign
	;

interval_factor
	:	opt_nt_264 interval_primary
	;

interval_primary
	:	value_expression_primary
	|	interval_value_function
	;

interval_value_function
	:	interval_absolute_value_function
	;

interval_absolute_value_function
	:	ABS left_paren interval_value_expression right_paren
	;

interval_value_expression
	:	interval_term
	|	interval_value_expression_1 plus_sign interval_term_1
	|	interval_value_expression_1 minus_sign interval_term_1
	|	left_paren datetime_value_expression minus_sign datetime_term right_paren interval_qualifier
	;

interval_value_expression_1
	:	interval_value_expression
	;

interval_term_1
	:	interval_term
	;

datetime_term
	:	datetime_factor
	;

opt_nt_265
	:	/* Nothing */
	|	time_zone ']'
	;

datetime_factor
	:	datetime_primary opt_nt_265
	;

datetime_primary
	:	value_expression_primary
	|	datetime_value_function
	;

time_zone
	:	AT time_zone_specifier
	;

time_zone_specifier
	:	LOCAL
	|	TIME ZONE interval_primary
	;

interval_term_2
	:	interval_term
	;

length_expression
	:	char_length_expression
	|	octet_length_expression
	|	bit_length_expression
	;

seq_nt_266
	:	CHAR_LENGTH
	|	CHARACTER_LENGTH
	;

char_length_expression
	:	seq_nt_266 left_paren string_value_expression right_paren
	;

octet_length_expression
	:	OCTET_LENGTH left_paren string_value_expression right_paren
	;

bit_length_expression
	:	BIT_LENGTH left_paren string_value_expression right_paren
	;

cardinality_expression
	:	CARDINALITY left_paren collection_value_expression right_paren
	;

absolute_value_expression
	:	ABS left_paren numeric_value_expression right_paren
	;

modulus_expression
	:	MOD left_paren numeric_value_expression_dividend comma numeric_value_expression_divisor right_paren
	;

numeric_value_expression_dividend
	:	numeric_value_expression
	;

numeric_value_expression_divisor
	:	numeric_value_expression
	;

opt_nt_267
	:	/* Nothing */
	|	ROW
	;

row_value_constructor
	:	row_value_constructor_element
	|	opt_nt_267 left_paren row_value_constructor_element_list right_paren
	|	row_subquery
	;

row_value_constructor_element
	:	value_expression
	;

seq_nt_269
	:	comma row_value_constructor_element
	;

lst_nt_270
	:	seq_nt_269
	|	lst_nt_270 seq_nt_269
	;

opt_nt_268
	:	/* Nothing */
	|	lst_nt_270 ']'
	;

row_value_constructor_element_list
	:	row_value_constructor_element opt_nt_268
	;

row_subquery
	:	subquery
	;

comp_op
	:	equals_operator
	|	not_equals_operator
	|	less_than_operator
	|	greater_than_operator
	|	less_than_or_equals_operator
	|	greater_than_or_equals_operator
	;

not_equals_operator
	:	less_than_operator greater_than_operator
	;

less_than_or_equals_operator
	:	less_than_operator equals_operator
	;

greater_than_or_equals_operator
	:	greater_than_operator equals_operator
	;

opt_nt_271
	:	/* Nothing */
	|	NOT
	;

opt_nt_272
	:	/* Nothing */
	|	ASYMMETRIC
	|	SYMMETRIC
	;

between_predicate
	:	row_value_expression opt_nt_271 BETWEEN opt_nt_272 row_value_expression AND row_value_expression
	;

opt_nt_273
	:	/* Nothing */
	|	NOT
	;

in_predicate
	:	row_value_expression opt_nt_273 IN in_predicate_value
	;

in_predicate_value
	:	table_subquery
	|	left_paren in_value_list right_paren
	;

seq_nt_275
	:	comma row_value_expression
	;

lst_nt_276
	:	seq_nt_275
	|	lst_nt_276 seq_nt_275
	;

opt_nt_274
	:	/* Nothing */
	|	lst_nt_276 ']'
	;

in_value_list
	:	row_value_expression opt_nt_274
	;

like_predicate
	:	character_like_predicate
	|	octet_like_predicate
	;

opt_nt_277
	:	/* Nothing */
	|	NOT
	;

opt_nt_278
	:	/* Nothing */
	|	ESCAPE escape_character ']'
	;

character_like_predicate
	:	character_match_value opt_nt_277 LIKE character_pattern opt_nt_278
	;

character_match_value
	:	character_value_expression
	;

character_pattern
	:	character_value_expression
	;

opt_nt_279
	:	/* Nothing */
	|	NOT
	;

opt_nt_280
	:	/* Nothing */
	|	ESCAPE escape_octet ']'
	;

octet_like_predicate
	:	octet_match_value opt_nt_279 LIKE octet_pattern opt_nt_280
	;

octet_match_value
	:	blob_value_expression
	;

octet_pattern
	:	blob_value_expression
	;

escape_octet
	:	blob_value_expression
	;

opt_nt_281
	:	/* Nothing */
	|	NOT
	;

null_predicate
	:	row_value_expression IS opt_nt_281 NULL
	;

quantified_comparison_predicate
	:	row_value_expression comp_op quantifier table_subquery
	;

quantifier
	:	all
	|	some
	;

all
	:	ALL
	;

some
	:	SOME
	|	ANY
	;

exists_predicate
	:	EXISTS table_subquery
	;

unique_predicate
	:	UNIQUE table_subquery
	;

opt_nt_282
	:	/* Nothing */
	|	UNIQUE
	;

opt_nt_283
	:	/* Nothing */
	|	SIMPLE
	|	PARTIAL
	|	FULL
	;

match_predicate
	:	row_value_expression MATCH opt_nt_282 opt_nt_283 table_subquery
	;

overlaps_predicate
	:	row_value_expression_1 OVERLAPS row_value_expression_2
	;

row_value_expression_1
	:	row_value_expression
	;

row_value_expression_2
	:	row_value_expression
	;

opt_nt_284
	:	/* Nothing */
	|	NOT
	;

opt_nt_285
	:	/* Nothing */
	|	ESCAPE escape_character ']'
	;

similar_predicate
	:	character_match_value opt_nt_284 SIMILAR TO similar_pattern opt_nt_285
	;

similar_pattern
	:	character_value_expression
	;

regular_expression
	:	regular_term
	|	regular_expression vertical_bar regular_term
	;

regular_term
	:	regular_factor
	|	regular_term regular_factor
	;

regular_factor
	:	regular_primary
	|	regular_primary asterisk
	|	regular_primary plus_sign
	;

regular_primary
	:	character_specifier
	|	percent
	|	regular_character_set
	|	left_paren regular_expression right_paren
	;

character_specifier
	:	non_escaped_character
	|	escaped_character
	;

non_escaped_character
	:	/* !! (See the Syntax Rules) */
	;

escaped_character
	:	/* !! (See the Syntax Rules) */
	;

lst_nt_286
	:	character_enumeration
	|	lst_nt_286 character_enumeration
	;

lst_nt_287
	:	character_enumeration
	|	lst_nt_287 character_enumeration
	;

regular_character_set
	:	underscore
	|	left_bracket lst_nt_286 right_bracket
	|	left_bracket circumflex lst_nt_287 right_bracket
	|	left_bracket colon regular_character_set_identifier colon right_bracket
	;

character_enumeration
	:	character_specifier
	|	character_specifier minus_sign character_specifier
	;

regular_character_set_identifier
	:	identifier
	;

distinct_predicate
	:	row_value_expression_3 IS DISTINCT FROM row_value_expression_4
	;

row_value_expression_3
	:	row_value_expression
	;

row_value_expression_4
	:	row_value_expression
	;

opt_nt_288
	:	/* Nothing */
	|	NOT
	;

type_predicate
	:	user_defined_type_value_expression IS opt_nt_288 OF left_paren type_list right_paren
	;

seq_nt_290
	:	comma user_defined_type_specification
	;

lst_nt_291
	:	seq_nt_290
	|	lst_nt_291 seq_nt_290
	;

opt_nt_289
	:	/* Nothing */
	|	lst_nt_291 ']'
	;

type_list
	:	user_defined_type_specification opt_nt_289
	;

user_defined_type_specification
	:	inclusive_user_defined_type_specification
	|	exclusive_user_defined_type_specification
	;

inclusive_user_defined_type_specification
	:	user_defined_type
	;

exclusive_user_defined_type_specification
	:	ONLY user_defined_type
	;

parenthesized_boolean_value_expression
	:	left_paren boolean_value_expression right_paren
	;

truth_value
	:	TRUE
	|	FALSE
	|	UNKNOWN
	;

opt_nt_293
	:	/* Nothing */
	|	NOT
	;

opt_nt_292
	:	/* Nothing */
	|	opt_nt_293 DEFERRABLE
	;

opt_nt_294
	:	/* Nothing */
	|	NOT
	;

opt_nt_295
	:	/* Nothing */
	|	constraint_check_time ']'
	;

constraint_characteristics
	:	constraint_check_time opt_nt_292
	|	opt_nt_294 DEFERRABLE opt_nt_295
	;

constraint_check_time
	:	INITIALLY DEFERRED
	|	INITIALLY IMMEDIATE
	;

opt_nt_296
	:	/* Nothing */
	|	constraint_name_definition
	;

opt_nt_297
	:	/* Nothing */
	|	constraint_characteristics ']'
	;

table_constraint_definition
	:	opt_nt_296 table_constraint opt_nt_297
	;

table_constraint
	:	unique_constraint_definition
	|	referential_constraint_definition
	|	check_constraint_definition
	;

unique_constraint_definition
	:	unique_specification left_paren unique_column_list right_paren
	|	UNIQUE left_paren VALUE right_paren
	;

unique_column_list
	:	column_name_list
	;

referential_constraint_definition
	:	FOREIGN KEY left_paren referencing_columns right_paren references_specification
	;

referencing_columns
	:	reference_column_list
	;

like_clause
	:	LIKE table_name
	;

self_referencing_column_specification
	:	REF IS self_referencing_column_name reference_generation
	;

self_referencing_column_name
	:	column_name
	;

reference_generation
	:	SYSTEM GENERATED
	|	USER GENERATED
	|	DERIVED
	;

column_options
	:	column_name WITH OPTIONS column_option_list
	;

opt_nt_298
	:	/* Nothing */
	|	scope_clause
	;

opt_nt_299
	:	/* Nothing */
	|	default_clause
	;

lst_nt_301
	:	column_constraint_definition
	|	lst_nt_301 column_constraint_definition
	;

opt_nt_300
	:	/* Nothing */
	|	lst_nt_301
	;

opt_nt_302
	:	/* Nothing */
	|	collate_clause ']'
	;

column_option_list
	:	opt_nt_298 opt_nt_299 opt_nt_300 opt_nt_302
	;

table_commit_action
	:	PRESERVE
	|	DELETE
	;

module_contents
	:	declare_cursor
	|	externally_invoked_procedure
	|	dynamic_declare_cursor
	;

opt_nt_303
	:	/* Nothing */
	|	cursor_sensitivity
	;

opt_nt_304
	:	/* Nothing */
	|	cursor_scrollability
	;

opt_nt_305
	:	/* Nothing */
	|	cursor_holdability
	;

opt_nt_306
	:	/* Nothing */
	|	cursor_returnability
	;

declare_cursor
	:	DECLARE cursor_name opt_nt_303 opt_nt_304 CURSOR opt_nt_305 opt_nt_306 FOR cursor_specification
	;

cursor_name
	:	local_qualified_name
	;

opt_nt_307
	:	/* Nothing */
	|	local_qualifier period
	;

local_qualified_name
	:	opt_nt_307 qualified_identifier
	;

local_qualifier
	:	MODULE
	;

cursor_sensitivity
	:	SENSITIVE
	|	INSENSITIVE
	|	ASENSITIVE
	;

cursor_scrollability
	:	SCROLL
	|	NO SCROLL
	;

cursor_holdability
	:	WITH HOLD
	|	WITHOUT HOLD
	;

cursor_returnability
	:	WITH RETURN
	|	WITHOUT RETURN
	;

opt_nt_308
	:	/* Nothing */
	|	order_by_clause
	;

opt_nt_309
	:	/* Nothing */
	|	updatability_clause ']'
	;

cursor_specification
	:	query_expression opt_nt_308 opt_nt_309
	;

order_by_clause
	:	ORDER BY sort_specification_list
	;

opt_nt_311
	:	/* Nothing */
	|	OF column_name_list
	;

seq_nt_310
	:	READ ONLY
	|	UPDATE opt_nt_311 '}'
	;

updatability_clause
	:	FOR seq_nt_310
	;

externally_invoked_procedure
	:	PROCEDURE procedure_name host_parameter_declaration_setup semicolon sql_procedure_statement semicolon
	;

procedure_name
	:	identifier
	;

host_parameter_declaration_setup
	:	host_parameter_declaration_list
	;

seq_nt_313
	:	comma host_parameter_declaration
	;

lst_nt_314
	:	seq_nt_313
	|	lst_nt_314 seq_nt_313
	;

opt_nt_312
	:	/* Nothing */
	|	lst_nt_314
	;

host_parameter_declaration_list
	:	left_paren host_parameter_declaration opt_nt_312 right_paren
	;

host_parameter_declaration
	:	host_parameter_name host_parameter_data_type
	|	status_parameter
	;

opt_nt_315
	:	/* Nothing */
	|	locator_indication ']'
	;

host_parameter_data_type
	:	data_type opt_nt_315
	;

locator_indication
	:	AS LOCATOR
	;

status_parameter
	:	SQLSTATE
	;

sql_procedure_statement
	:	sql_executable_statement
	;

sql_executable_statement
	:	sql_schema_statement
	|	sql_data_statement
	|	sql_control_statement
	|	sql_transaction_statement
	|	sql_connection_statement
	|	sql_session_statement
	|	sql_diagnostics_statement
	|	sql_dynamic_statement
	;

sql_schema_statement
	:	sql_schema_definition_statement
	|	sql_schema_manipulation_statement
	;

sql_schema_definition_statement
	:	schema_definition
	|	table_definition
	|	view_definition
	|	sql_invoked_routine
	|	grant_statement
	|	role_definition
	|	domain_definition
	|	character_set_definition
	|	collation_definition
	|	translation_definition
	|	assertion_definition
	|	trigger_definition
	|	user_defined_type_definition
	|	user_defined_cast_definition
	|	user_defined_ordering_definition
	|	transform_definition
	|	sql_server_module_definition
	;

opt_nt_316
	:	/* Nothing */
	|	schema_character_set_or_path
	;

lst_nt_318
	:	schema_element
	|	lst_nt_318 schema_element
	;

opt_nt_317
	:	/* Nothing */
	|	lst_nt_318 ']'
	;

schema_definition
	:	CREATE SCHEMA schema_name_clause opt_nt_316 opt_nt_317
	;

schema_name_clause
	:	schema_name
	|	AUTHORIZATION schema_authorization_identifier
	|	schema_name AUTHORIZATION schema_authorization_identifier
	;

schema_authorization_identifier
	:	authorization_identifier
	;

schema_character_set_or_path
	:	schema_character_set_specification
	|	schema_path_specification
	|	schema_character_set_specification schema_path_specification
	|	schema_path_specification schema_character_set_specification
	;

schema_character_set_specification
	:	DEFAULT CHARACTER SET character_set_specification
	;

schema_path_specification
	:	path_specification
	;

schema_element
	:	table_definition
	|	view_definition
	|	domain_definition
	|	character_set_definition
	|	collation_definition
	|	translation_definition
	|	assertion_definition
	|	trigger_definition
	|	user_defined_type_definition
	|	schema_routine
	|	grant_statement
	|	role_definition
	|	user_defined_cast_definition
	|	user_defined_ordering_definition
	|	transform_definition
	;

opt_nt_319
	:	/* Nothing */
	|	table_scope
	;

opt_nt_320
	:	/* Nothing */
	|	ON COMMIT table_commit_action ROWS ']'
	;

table_definition
	:	CREATE opt_nt_319 TABLE table_name table_contents_source opt_nt_320
	;

table_scope
	:	global_or_local TEMPORARY
	;

global_or_local
	:	GLOBAL
	|	LOCAL
	;

opt_nt_321
	:	/* Nothing */
	|	subtable_clause
	;

opt_nt_322
	:	/* Nothing */
	|	table_element_list ']'
	;

table_contents_source
	:	table_element_list
	|	OF user_defined_type opt_nt_321 opt_nt_322
	;

subtable_clause
	:	UNDER supertable_clause
	;

supertable_clause
	:	supertable_name
	;

supertable_name
	:	table_name
	;

opt_nt_323
	:	/* Nothing */
	|	RECURSIVE
	;

opt_nt_325
	:	/* Nothing */
	|	levels_clause
	;

opt_nt_324
	:	/* Nothing */
	|	WITH opt_nt_325 CHECK OPTION ']'
	;

view_definition
	:	CREATE opt_nt_323 VIEW table_name view_specification AS query_expression opt_nt_324
	;

view_specification
	:	regular_view_specification
	|	referenceable_view_specification
	;

opt_nt_326
	:	/* Nothing */
	|	left_paren view_column_list right_paren ']'
	;

regular_view_specification
	:	opt_nt_326
	;

view_column_list
	:	column_name_list
	;

opt_nt_327
	:	/* Nothing */
	|	subview_clause
	;

opt_nt_328
	:	/* Nothing */
	|	view_element_list ']'
	;

referenceable_view_specification
	:	OF user_defined_type opt_nt_327 opt_nt_328
	;

subview_clause
	:	UNDER table_name
	;

opt_nt_329
	:	/* Nothing */
	|	self_referencing_column_specification comma
	;

seq_nt_331
	:	comma view_element
	;

lst_nt_332
	:	seq_nt_331
	|	lst_nt_332 seq_nt_331
	;

opt_nt_330
	:	/* Nothing */
	|	lst_nt_332
	;

view_element_list
	:	left_paren opt_nt_329 view_element opt_nt_330 right_paren
	;

view_element
	:	view_column_option
	;

view_column_option
	:	column_name WITH OPTIONS scope_clause
	;

levels_clause
	:	CASCADED
	|	LOCAL
	;

opt_nt_333
	:	/* Nothing */
	|	AS
	;

opt_nt_334
	:	/* Nothing */
	|	default_clause
	;

lst_nt_336
	:	domain_constraint
	|	lst_nt_336 domain_constraint
	;

opt_nt_335
	:	/* Nothing */
	|	lst_nt_336
	;

opt_nt_337
	:	/* Nothing */
	|	collate_clause ']'
	;

domain_definition
	:	CREATE DOMAIN domain_name opt_nt_333 data_type opt_nt_334 opt_nt_335 opt_nt_337
	;

opt_nt_338
	:	/* Nothing */
	|	constraint_name_definition
	;

opt_nt_339
	:	/* Nothing */
	|	constraint_characteristics ']'
	;

domain_constraint
	:	opt_nt_338 check_constraint_definition opt_nt_339
	;

opt_nt_340
	:	/* Nothing */
	|	AS
	;

opt_nt_341
	:	/* Nothing */
	|	collate_clause ']'
	;

character_set_definition
	:	CREATE CHARACTER SET character_set_name opt_nt_340 character_set_source opt_nt_341
	;

character_set_source
	:	GET character_set_specification
	;

opt_nt_342
	:	/* Nothing */
	|	pad_characteristic ']'
	;

collation_definition
	:	CREATE COLLATION collation_name FOR character_set_specification FROM existing_collation_name opt_nt_342
	;

existing_collation_name
	:	collation_name
	;

pad_characteristic
	:	NO PAD
	|	PAD SPACE
	;

translation_definition
	:	CREATE TRANSLATION translation_name FOR source_character_set_specification TO target_character_set_specification FROM translation_source
	;

source_character_set_specification
	:	character_set_specification
	;

target_character_set_specification
	:	character_set_specification
	;

translation_source
	:	existing_translation_name
	|	translation_routine
	;

existing_translation_name
	:	translation_name
	;

translation_routine
	:	specific_routine_designator
	;

opt_nt_343
	:	/* Nothing */
	|	FOR user_defined_type_name ']'
	;

specific_routine_designator
	:	SPECIFIC routine_type specific_name
	|	routine_type member_name opt_nt_343
	;

opt_nt_344
	:	/* Nothing */
	|	INSTANCE
	|	STATIC
	|	CONSTRUCTOR
	;

routine_type
	:	ROUTINE
	|	FUNCTION
	|	PROCEDURE
	|	opt_nt_344 METHOD
	;

specific_name
	:	schema_qualified_name
	;

opt_nt_345
	:	/* Nothing */
	|	data_type_list ']'
	;

member_name
	:	schema_qualified_routine_name opt_nt_345
	;

schema_qualified_routine_name
	:	schema_qualified_name
	;

seq_nt_348
	:	comma data_type
	;

lst_nt_349
	:	seq_nt_348
	|	lst_nt_349 seq_nt_348
	;

opt_nt_347
	:	/* Nothing */
	|	lst_nt_349
	;

opt_nt_346
	:	/* Nothing */
	|	data_type opt_nt_347
	;

data_type_list
	:	left_paren opt_nt_346 right_paren
	;

opt_nt_350
	:	/* Nothing */
	|	constraint_characteristics ']'
	;

assertion_definition
	:	CREATE ASSERTION constraint_name CHECK left_paren search_condition right_paren opt_nt_350
	;

opt_nt_351
	:	/* Nothing */
	|	REFERENCING old_or_new_values_alias_list
	;

trigger_definition
	:	CREATE TRIGGER trigger_name trigger_action_time trigger_event ON table_name opt_nt_351 triggered_action
	;

trigger_name
	:	schema_qualified_name
	;

trigger_action_time
	:	BEFORE
	|	AFTER
	;

opt_nt_352
	:	/* Nothing */
	|	OF trigger_column_list ']'
	;

trigger_event
	:	INSERT
	|	DELETE
	|	UPDATE opt_nt_352
	;

trigger_column_list
	:	column_name_list
	;

lst_nt_353
	:	old_or_new_values_alias
	|	lst_nt_353 old_or_new_values_alias
	;

old_or_new_values_alias_list
	:	lst_nt_353
	;

opt_nt_354
	:	/* Nothing */
	|	ROW
	;

opt_nt_355
	:	/* Nothing */
	|	AS
	;

opt_nt_356
	:	/* Nothing */
	|	ROW
	;

opt_nt_357
	:	/* Nothing */
	|	AS
	;

opt_nt_358
	:	/* Nothing */
	|	AS
	;

opt_nt_359
	:	/* Nothing */
	|	AS
	;

old_or_new_values_alias
	:	OLD opt_nt_354 opt_nt_355 old_values_correlation_name
	|	NEW opt_nt_356 opt_nt_357 new_values_correlation_name
	|	OLD TABLE opt_nt_358 old_values_table_alias
	|	NEW TABLE opt_nt_359 new_values_table_alias
	;

old_values_correlation_name
	:	correlation_name
	;

new_values_correlation_name
	:	correlation_name
	;

old_values_table_alias
	:	identifier
	;

new_values_table_alias
	:	identifier
	;

seq_nt_361
	:	ROW
	|	STATEMENT
	;

opt_nt_360
	:	/* Nothing */
	|	FOR EACH seq_nt_361
	;

opt_nt_362
	:	/* Nothing */
	|	WHEN left_paren search_condition right_paren
	;

triggered_action
	:	opt_nt_360 opt_nt_362 triggered_sql_statement
	;

seq_nt_363
	:	sql_procedure_statement semicolon
	;

lst_nt_364
	:	seq_nt_363
	|	lst_nt_364 seq_nt_363
	;

triggered_sql_statement
	:	sql_procedure_statement
	|	BEGIN ATOMIC lst_nt_364 END
	;

user_defined_type_definition
	:	CREATE TYPE user_defined_type_body
	;

opt_nt_365
	:	/* Nothing */
	|	subtype_clause
	;

opt_nt_366
	:	/* Nothing */
	|	AS representation
	;

opt_nt_367
	:	/* Nothing */
	|	instantiable_clause
	;

opt_nt_368
	:	/* Nothing */
	|	reference_type_specification
	;

opt_nt_369
	:	/* Nothing */
	|	ref_cast_option
	;

opt_nt_370
	:	/* Nothing */
	|	cast_option
	;

opt_nt_371
	:	/* Nothing */
	|	method_specification_list ']'
	;

user_defined_type_body
	:	user_defined_type_name opt_nt_365 opt_nt_366 opt_nt_367 finality opt_nt_368 opt_nt_369 opt_nt_370 opt_nt_371
	;

subtype_clause
	:	UNDER supertype_name
	;

supertype_name
	:	user_defined_type
	;

representation
	:	predefined_type
	|	member_list
	;

seq_nt_373
	:	comma member
	;

lst_nt_374
	:	seq_nt_373
	|	lst_nt_374 seq_nt_373
	;

opt_nt_372
	:	/* Nothing */
	|	lst_nt_374
	;

member_list
	:	left_paren member opt_nt_372 right_paren
	;

member
	:	attribute_definition
	;

opt_nt_375
	:	/* Nothing */
	|	reference_scope_check
	;

opt_nt_376
	:	/* Nothing */
	|	attribute_default
	;

opt_nt_377
	:	/* Nothing */
	|	collate_clause ']'
	;

attribute_definition
	:	attribute_name data_type opt_nt_375 opt_nt_376 opt_nt_377
	;

attribute_name
	:	identifier
	;

attribute_default
	:	default_clause
	;

instantiable_clause
	:	INSTANTIABLE
	|	NOT INSTANTIABLE
	;

finality
	:	FINAL
	|	NOT FINAL
	;

reference_type_specification
	:	user_defined_representation
	|	derived_representation
	|	system_generated_representation
	;

user_defined_representation
	:	REF USING predefined_type
	;

opt_nt_378
	:	/* Nothing */
	|	cast_to_ref
	;

opt_nt_379
	:	/* Nothing */
	|	cast_to_type ']'
	;

ref_cast_option
	:	opt_nt_378 opt_nt_379
	;

cast_to_ref
	:	CAST left_paren SOURCE AS REF right_paren WITH cast_to_ref_identifier
	;

cast_to_ref_identifier
	:	identifier
	;

cast_to_type
	:	CAST left_paren REF AS SOURCE right_paren WITH cast_to_type_identifier
	;

cast_to_type_identifier
	:	identifier
	;

derived_representation
	:	REF FROM list_of_attributes
	;

seq_nt_381
	:	comma attribute_name
	;

lst_nt_382
	:	seq_nt_381
	|	lst_nt_382 seq_nt_381
	;

opt_nt_380
	:	/* Nothing */
	|	lst_nt_382
	;

list_of_attributes
	:	left_paren attribute_name opt_nt_380 right_paren
	;

system_generated_representation
	:	REF IS SYSTEM GENERATED
	;

opt_nt_383
	:	/* Nothing */
	|	cast_to_distinct
	;

opt_nt_384
	:	/* Nothing */
	|	cast_to_source ']'
	;

cast_option
	:	opt_nt_383 opt_nt_384
	;

cast_to_distinct
	:	CAST left_paren SOURCE AS DISTINCT right_paren WITH cast_to_distinct_identifier
	;

cast_to_distinct_identifier
	:	identifier
	;

cast_to_source
	:	CAST left_paren DISTINCT AS SOURCE right_paren WITH cast_to_source_identifier
	;

cast_to_source_identifier
	:	identifier
	;

seq_nt_386
	:	comma method_specification
	;

lst_nt_387
	:	seq_nt_386
	|	lst_nt_387 seq_nt_386
	;

opt_nt_385
	:	/* Nothing */
	|	lst_nt_387 ']'
	;

method_specification_list
	:	method_specification opt_nt_385
	;

method_specification
	:	original_method_specification
	|	overriding_method_specification
	;

opt_nt_388
	:	/* Nothing */
	|	SELF AS RESULT
	;

opt_nt_389
	:	/* Nothing */
	|	SELF AS LOCATOR
	;

opt_nt_390
	:	/* Nothing */
	|	method_characteristics ']'
	;

original_method_specification
	:	partial_method_specification opt_nt_388 opt_nt_389 opt_nt_390
	;

opt_nt_391
	:	/* Nothing */
	|	INSTANCE
	|	STATIC
	|	CONSTRUCTOR
	;

opt_nt_392
	:	/* Nothing */
	|	SPECIFIC specific_method_name ']'
	;

partial_method_specification
	:	opt_nt_391 METHOD method_name sql_parameter_declaration_list returns_clause opt_nt_392
	;

seq_nt_395
	:	comma sql_parameter_declaration
	;

lst_nt_396
	:	seq_nt_395
	|	lst_nt_396 seq_nt_395
	;

opt_nt_394
	:	/* Nothing */
	|	lst_nt_396
	;

opt_nt_393
	:	/* Nothing */
	|	sql_parameter_declaration opt_nt_394
	;

sql_parameter_declaration_list
	:	left_paren opt_nt_393 right_paren
	;

opt_nt_397
	:	/* Nothing */
	|	parameter_mode
	;

opt_nt_398
	:	/* Nothing */
	|	sql_parameter_name
	;

opt_nt_399
	:	/* Nothing */
	|	RESULT ']'
	;

sql_parameter_declaration
	:	opt_nt_397 opt_nt_398 parameter_type opt_nt_399
	;

parameter_mode
	:	IN
	|	OUT
	|	INOUT
	;

sql_parameter_name
	:	identifier
	;

opt_nt_400
	:	/* Nothing */
	|	locator_indication ']'
	;

parameter_type
	:	data_type opt_nt_400
	;

opt_nt_401
	:	/* Nothing */
	|	result_cast ']'
	;

returns_clause
	:	RETURNS returns_data_type opt_nt_401
	;

opt_nt_402
	:	/* Nothing */
	|	locator_indication ']'
	;

returns_data_type
	:	data_type opt_nt_402
	;

result_cast
	:	CAST FROM result_cast_from_type
	;

opt_nt_403
	:	/* Nothing */
	|	locator_indication ']'
	;

result_cast_from_type
	:	data_type opt_nt_403
	;

opt_nt_404
	:	/* Nothing */
	|	schema_name period
	;

specific_method_name
	:	opt_nt_404 qualified_identifier
	;

lst_nt_405
	:	method_characteristic
	|	lst_nt_405 method_characteristic
	;

method_characteristics
	:	lst_nt_405
	;

method_characteristic
	:	language_clause
	|	parameter_style_clause
	|	deterministic_characteristic
	|	sql_data_access_indication
	|	null_call_clause
	;

parameter_style_clause
	:	PARAMETER STYLE parameter_style
	;

parameter_style
	:	SQL
	|	GENERAL
	;

deterministic_characteristic
	:	DETERMINISTIC
	|	NOT DETERMINISTIC
	;

sql_data_access_indication
	:	NO SQL
	|	CONTAINS SQL
	|	READS SQL DATA
	|	MODIFIES SQL DATA
	;

null_call_clause
	:	RETURNS NULL ON NULL INPUT
	|	CALLED ON NULL INPUT
	;

overriding_method_specification
	:	OVERRIDING partial_method_specification
	;

schema_routine
	:	schema_procedure
	|	schema_function
	;

schema_procedure
	:	CREATE sql_invoked_procedure
	;

sql_invoked_procedure
	:	PROCEDURE schema_qualified_routine_name sql_parameter_declaration_list routine_characteristics routine_body
	;

lst_nt_407
	:	routine_characteristic
	|	lst_nt_407 routine_characteristic
	;

opt_nt_406
	:	/* Nothing */
	|	lst_nt_407 ']'
	;

routine_characteristics
	:	opt_nt_406
	;

routine_characteristic
	:	language_clause
	|	parameter_style_clause
	|	SPECIFIC specific_name
	|	deterministic_characteristic
	|	sql_data_access_indication
	|	null_call_clause
	|	dynamic_result_sets_characteristic
	;

dynamic_result_sets_characteristic
	:	DYNAMIC RESULT SETS maximum_dynamic_result_sets
	;

maximum_dynamic_result_sets
	:	unsigned_integer
	;

routine_body
	:	sql_routine_body
	|	external_body_reference
	;

sql_routine_body
	:	sql_procedure_statement
	;

opt_nt_408
	:	/* Nothing */
	|	NAME external_routine_name
	;

opt_nt_409
	:	/* Nothing */
	|	parameter_style_clause
	;

opt_nt_410
	:	/* Nothing */
	|	transform_group_specification
	;

opt_nt_411
	:	/* Nothing */
	|	external_security_clause ']'
	;

external_body_reference
	:	EXTERNAL opt_nt_408 opt_nt_409 opt_nt_410 opt_nt_411
	;

external_routine_name
	:	identifier
	|	character_string_literal
	;

external_security_clause
	:	EXTERNAL SECURITY DEFINER
	|	EXTERNAL SECURITY INVOKER
	|	EXTERNAL SECURITY IMPLEMENTATION DEFINED
	;

schema_function
	:	CREATE sql_invoked_function
	;

seq_nt_412
	:	function_specification
	|	method_specification_designator
	;

sql_invoked_function
	:	seq_nt_412 routine_body
	;

opt_nt_413
	:	/* Nothing */
	|	dispatch_clause ']'
	;

function_specification
	:	FUNCTION schema_qualified_routine_name sql_parameter_declaration_list returns_clause routine_characteristics opt_nt_413
	;

dispatch_clause
	:	STATIC DISPATCH
	;

opt_nt_414
	:	/* Nothing */
	|	INSTANCE
	|	STATIC
	|	CONSTRUCTOR
	;

opt_nt_415
	:	/* Nothing */
	|	returns_clause
	;

method_specification_designator
	:	opt_nt_414 METHOD method_name sql_parameter_declaration_list opt_nt_415 FOR user_defined_type_name
	;

grant_statement
	:	grant_privilege_statement
	|	grant_role_statement
	;

seq_nt_417
	:	comma grantee
	;

lst_nt_418
	:	seq_nt_417
	|	lst_nt_418 seq_nt_417
	;

opt_nt_416
	:	/* Nothing */
	|	lst_nt_418
	;

opt_nt_419
	:	/* Nothing */
	|	WITH HIERARCHY OPTION
	;

opt_nt_420
	:	/* Nothing */
	|	WITH GRANT OPTION
	;

opt_nt_421
	:	/* Nothing */
	|	GRANTED BY grantor ']'
	;

grant_privilege_statement
	:	GRANT privileges TO grantee opt_nt_416 opt_nt_419 opt_nt_420 opt_nt_421
	;

privileges
	:	object_privileges ON object_name
	;

seq_nt_423
	:	comma action
	;

lst_nt_424
	:	seq_nt_423
	|	lst_nt_424 seq_nt_423
	;

opt_nt_422
	:	/* Nothing */
	|	lst_nt_424 ']'
	;

object_privileges
	:	ALL PRIVILEGES
	|	action opt_nt_422
	;

opt_nt_425
	:	/* Nothing */
	|	left_paren privilege_column_list right_paren
	;

opt_nt_426
	:	/* Nothing */
	|	left_paren privilege_column_list right_paren
	;

opt_nt_427
	:	/* Nothing */
	|	left_paren privilege_column_list right_paren
	;

action
	:	SELECT
	|	SELECT left_paren privilege_column_list right_paren
	|	SELECT left_paren privilege_method_list right_paren
	|	DELETE
	|	INSERT opt_nt_425
	|	UPDATE opt_nt_426
	|	REFERENCES opt_nt_427
	|	USAGE
	|	TRIGGER
	|	UNDER
	|	EXECUTE
	;

privilege_column_list
	:	column_name_list
	;

seq_nt_429
	:	comma specific_routine_designator
	;

lst_nt_430
	:	seq_nt_429
	|	lst_nt_430 seq_nt_429
	;

opt_nt_428
	:	/* Nothing */
	|	lst_nt_430 ']'
	;

privilege_method_list
	:	specific_routine_designator opt_nt_428
	;

opt_nt_431
	:	/* Nothing */
	|	TABLE
	;

object_name
	:	opt_nt_431 table_name
	|	DOMAIN domain_name
	|	COLLATION collation_name
	|	CHARACTER SET character_set_name
	|	MODULE module_name
	|	TRANSLATION translation_name
	|	TYPE user_defined_type_name
	|	specific_routine_designator
	;

grantee
	:	PUBLIC
	|	authorization_identifier
	;

grantor
	:	CURRENT_USER
	|	CURRENT_ROLE
	;

seq_nt_433
	:	comma role_granted
	;

lst_nt_434
	:	seq_nt_433
	|	lst_nt_434 seq_nt_433
	;

opt_nt_432
	:	/* Nothing */
	|	lst_nt_434
	;

seq_nt_436
	:	comma grantee
	;

lst_nt_437
	:	seq_nt_436
	|	lst_nt_437 seq_nt_436
	;

opt_nt_435
	:	/* Nothing */
	|	lst_nt_437
	;

opt_nt_438
	:	/* Nothing */
	|	WITH ADMIN OPTION
	;

opt_nt_439
	:	/* Nothing */
	|	GRANTED BY grantor ']'
	;

grant_role_statement
	:	GRANT role_granted opt_nt_432 TO grantee opt_nt_435 opt_nt_438 opt_nt_439
	;

role_granted
	:	role_name
	;

opt_nt_440
	:	/* Nothing */
	|	WITH ADMIN grantor ']'
	;

role_definition
	:	CREATE ROLE role_name opt_nt_440
	;

sql_invoked_routine
	:	schema_routine
	|	module_routine
	;

opt_nt_441
	:	/* Nothing */
	|	AS ASSIGNMENT ']'
	;

user_defined_cast_definition
	:	CREATE CAST left_paren source_data_type AS target_data_type right_paren WITH cast_function opt_nt_441
	;

source_data_type
	:	data_type
	;

cast_function
	:	specific_routine_designator
	;

user_defined_ordering_definition
	:	CREATE ORDERING FOR user_defined_type_name ordering_form
	;

ordering_form
	:	equals_ordering_form
	|	full_ordering_form
	;

equals_ordering_form
	:	EQUALS ONLY BY ordering_category
	;

ordering_category
	:	relative_category
	|	map_category
	|	state_category
	;

relative_category
	:	RELATIVE WITH relative_function_specification
	;

relative_function_specification
	:	specific_routine_designator
	;

map_category
	:	MAP WITH map_function_specification
	;

map_function_specification
	:	specific_routine_designator
	;

opt_nt_442
	:	/* Nothing */
	|	specific_name ']'
	;

state_category
	:	STATE opt_nt_442
	;

full_ordering_form
	:	ORDER FULL BY ordering_category
	;

seq_nt_443
	:	TRANSFORM
	|	TRANSFORMS
	;

lst_nt_444
	:	transform_group
	|	lst_nt_444 transform_group
	;

transform_definition
	:	CREATE seq_nt_443 FOR user_defined_type_name lst_nt_444
	;

transform_group
	:	group_name left_paren transform_element_list right_paren
	;

opt_nt_445
	:	/* Nothing */
	|	comma transform_element ']'
	;

transform_element_list
	:	transform_element opt_nt_445
	;

transform_element
	:	to_sql
	|	from_sql
	;

to_sql
	:	TO SQL WITH to_sql_function
	;

to_sql_function
	:	specific_routine_designator
	;

from_sql
	:	FROM SQL WITH from_sql_function
	;

from_sql_function
	:	specific_routine_designator
	;

sql_schema_manipulation_statement
	:	drop_schema_statement
	|	alter_table_statement
	|	drop_table_statement
	|	drop_view_statement
	|	alter_routine_statement
	|	drop_routine_statement
	|	drop_user_defined_cast_statement
	|	revoke_statement
	|	drop_role_statement
	|	alter_domain_statement
	|	drop_domain_statement
	|	drop_character_set_statement
	|	drop_collation_statement
	|	drop_translation_statement
	|	drop_assertion_statement
	|	drop_trigger_statement
	|	alter_type_statement
	|	drop_data_type_statement
	|	drop_user_defined_ordering_statement
	|	drop_transform_statement
	|	drop_module_statement
	;

drop_schema_statement
	:	DROP SCHEMA schema_name drop_behavior
	;

drop_behavior
	:	CASCADE
	|	RESTRICT
	;

alter_table_statement
	:	ALTER TABLE table_name alter_table_action
	;

alter_table_action
	:	add_column_definition
	|	alter_column_definition
	|	drop_column_definition
	|	add_table_constraint_definition
	|	drop_table_constraint_definition
	;

opt_nt_446
	:	/* Nothing */
	|	COLUMN
	;

add_column_definition
	:	ADD opt_nt_446 column_definition
	;

opt_nt_447
	:	/* Nothing */
	|	COLUMN
	;

alter_column_definition
	:	ALTER opt_nt_447 column_name alter_column_action
	;

alter_column_action
	:	set_column_default_clause
	|	drop_column_default_clause
	|	add_column_scope_clause
	|	drop_column_scope_clause
	;

set_column_default_clause
	:	SET default_clause
	;

drop_column_default_clause
	:	DROP DEFAULT
	;

add_column_scope_clause
	:	ADD scope_clause
	;

drop_column_scope_clause
	:	DROP SCOPE drop_behavior
	;

opt_nt_448
	:	/* Nothing */
	|	COLUMN
	;

drop_column_definition
	:	DROP opt_nt_448 column_name drop_behavior
	;

add_table_constraint_definition
	:	ADD table_constraint_definition
	;

drop_table_constraint_definition
	:	DROP CONSTRAINT constraint_name drop_behavior
	;

drop_table_statement
	:	DROP TABLE table_name drop_behavior
	;

drop_view_statement
	:	DROP VIEW table_name drop_behavior
	;

alter_routine_statement
	:	ALTER specific_routine_designator alter_routine_characteristics alter_routine_behaviour
	;

lst_nt_449
	:	alter_routine_characteristic
	|	lst_nt_449 alter_routine_characteristic
	;

alter_routine_characteristics
	:	lst_nt_449
	;

alter_routine_characteristic
	:	language_clause
	|	parameter_style_clause
	|	sql_data_access_indication
	|	null_call_clause
	|	dynamic_result_sets_characteristic
	|	NAME external_routine_name
	;

alter_routine_behaviour
	:	RESTRICT
	;

drop_routine_statement
	:	DROP specific_routine_designator drop_behavior
	;

drop_user_defined_cast_statement
	:	DROP CAST left_paren source_data_type AS target_data_type right_paren drop_behavior
	;

revoke_statement
	:	revoke_privilege_statement
	|	revoke_role_statement
	;

opt_nt_450
	:	/* Nothing */
	|	revoke_option_extension
	;

seq_nt_452
	:	comma grantee
	;

lst_nt_453
	:	seq_nt_452
	|	lst_nt_453 seq_nt_452
	;

opt_nt_451
	:	/* Nothing */
	|	lst_nt_453
	;

opt_nt_454
	:	/* Nothing */
	|	GRANTED BY grantor
	;

revoke_privilege_statement
	:	REVOKE opt_nt_450 privileges FROM grantee opt_nt_451 opt_nt_454 drop_behavior
	;

revoke_option_extension
	:	GRANT OPTION FOR
	|	HIERARCHY OPTION FOR
	;

opt_nt_455
	:	/* Nothing */
	|	ADMIN OPTION FOR
	;

seq_nt_457
	:	comma role_revoked
	;

lst_nt_458
	:	seq_nt_457
	|	lst_nt_458 seq_nt_457
	;

opt_nt_456
	:	/* Nothing */
	|	lst_nt_458
	;

seq_nt_460
	:	comma grantee
	;

lst_nt_461
	:	seq_nt_460
	|	lst_nt_461 seq_nt_460
	;

opt_nt_459
	:	/* Nothing */
	|	lst_nt_461
	;

opt_nt_462
	:	/* Nothing */
	|	GRANTED BY grantor
	;

revoke_role_statement
	:	REVOKE opt_nt_455 role_revoked opt_nt_456 FROM grantee opt_nt_459 opt_nt_462 drop_behavior
	;

role_revoked
	:	role_name
	;

drop_role_statement
	:	DROP ROLE role_name
	;

alter_domain_statement
	:	ALTER DOMAIN domain_name alter_domain_action
	;

alter_domain_action
	:	set_domain_default_clause
	|	drop_domain_default_clause
	|	add_domain_constraint_definition
	|	drop_domain_constraint_definition
	;

set_domain_default_clause
	:	SET default_clause
	;

drop_domain_default_clause
	:	DROP DEFAULT
	;

add_domain_constraint_definition
	:	ADD domain_constraint
	;

drop_domain_constraint_definition
	:	DROP CONSTRAINT constraint_name
	;

drop_domain_statement
	:	DROP DOMAIN domain_name drop_behavior
	;

drop_character_set_statement
	:	DROP CHARACTER SET character_set_name
	;

drop_collation_statement
	:	DROP COLLATION collation_name drop_behavior
	;

drop_translation_statement
	:	DROP TRANSLATION translation_name
	;

drop_assertion_statement
	:	DROP ASSERTION constraint_name
	;

drop_trigger_statement
	:	DROP TRIGGER trigger_name
	;

alter_type_statement
	:	ALTER TYPE user_defined_type_name alter_type_action
	;

alter_type_action
	:	add_attribute_definition
	|	drop_attribute_definition
	|	add_original_method_specification
	|	add_overriding_method_specification
	|	drop_method_specification
	;

add_attribute_definition
	:	ADD ATTRIBUTE attribute_definition
	;

drop_attribute_definition
	:	DROP ATTRIBUTE attribute_name RESTRICT
	;

add_original_method_specification
	:	ADD original_method_specification
	;

add_overriding_method_specification
	:	ADD overriding_method_specification
	;

drop_method_specification
	:	DROP specific_method_specification_designator RESTRICT
	;

opt_nt_463
	:	/* Nothing */
	|	INSTANCE
	|	STATIC
	|	CONSTRUCTOR
	;

opt_nt_464
	:	/* Nothing */
	|	data_type_list ']'
	;

specific_method_specification_designator
	:	SPECIFIC METHOD specific_method_name
	|	opt_nt_463 METHOD method_name opt_nt_464
	;

drop_data_type_statement
	:	DROP TYPE user_defined_type_name drop_behavior
	;

drop_user_defined_ordering_statement
	:	DROP ORDERING FOR user_defined_type_name drop_behavior
	;

seq_nt_465
	:	TRANSFORM
	|	TRANSFORMS
	;

drop_transform_statement
	:	DROP seq_nt_465 transforms_to_be_dropped FOR user_defined_type_name drop_behavior
	;

transforms_to_be_dropped
	:	ALL
	|	transform_group_element
	;

transform_group_element
	:	group_name
	;

sql_data_statement
	:	open_statement
	|	fetch_statement
	|	close_statement
	|	select_statement_single_row
	|	free_locator_statement
	|	hold_locator_statement
	|	sql_data_change_statement
	;

open_statement
	:	OPEN cursor_name
	;

opt_nt_467
	:	/* Nothing */
	|	fetch_orientation
	;

opt_nt_466
	:	/* Nothing */
	|	opt_nt_467 FROM
	;

fetch_statement
	:	FETCH opt_nt_466 cursor_name INTO fetch_target_list
	;

seq_nt_468
	:	ABSOLUTE
	|	RELATIVE
	;

fetch_orientation
	:	NEXT
	|	PRIOR
	|	FIRST
	|	LAST
	|	seq_nt_468 simple_value_specification
	;

simple_value_specification
	:	literal
	|	host_parameter_name
	|	sql_parameter_reference
	|	sql_variable_reference
	|	embedded_variable_name
	;

seq_nt_470
	:	comma target_specification
	;

lst_nt_471
	:	seq_nt_470
	|	lst_nt_471 seq_nt_470
	;

opt_nt_469
	:	/* Nothing */
	|	lst_nt_471 ']'
	;

fetch_target_list
	:	target_specification opt_nt_469
	;

close_statement
	:	CLOSE cursor_name
	;

opt_nt_472
	:	/* Nothing */
	|	set_quantifier
	;

select_statement_single_row
	:	SELECT opt_nt_472 select_list INTO select_target_list table_expression
	;

seq_nt_474
	:	comma target_specification
	;

lst_nt_475
	:	seq_nt_474
	|	lst_nt_475 seq_nt_474
	;

opt_nt_473
	:	/* Nothing */
	|	lst_nt_475 ']'
	;

select_target_list
	:	target_specification opt_nt_473
	;

seq_nt_477
	:	comma locator_reference
	;

lst_nt_478
	:	seq_nt_477
	|	lst_nt_478 seq_nt_477
	;

opt_nt_476
	:	/* Nothing */
	|	lst_nt_478 ']'
	;

free_locator_statement
	:	FREE LOCATOR locator_reference opt_nt_476
	;

locator_reference
	:	host_parameter_name
	|	embedded_variable_name
	;

seq_nt_480
	:	comma locator_reference
	;

lst_nt_481
	:	seq_nt_480
	|	lst_nt_481 seq_nt_480
	;

opt_nt_479
	:	/* Nothing */
	|	lst_nt_481 ']'
	;

hold_locator_statement
	:	HOLD LOCATOR locator_reference opt_nt_479
	;

sql_data_change_statement
	:	delete_statement_positioned
	|	delete_statement_searched
	|	insert_statement
	|	update_statement_positioned
	|	update_statement_searched
	;

delete_statement_positioned
	:	DELETE FROM target_table WHERE CURRENT OF cursor_name
	;

opt_nt_482
	:	/* Nothing */
	|	ONLY
	;

target_table
	:	table_name
	|	opt_nt_482 left_paren table_name right_paren
	;

opt_nt_483
	:	/* Nothing */
	|	WHERE search_condition ']'
	;

delete_statement_searched
	:	DELETE FROM target_table opt_nt_483
	;

insert_statement
	:	INSERT INTO insertion_target insert_columns_and_source
	;

insertion_target
	:	table_name
	;

insert_columns_and_source
	:	from_subquery
	|	from_constructor
	|	from_default
	;

opt_nt_484
	:	/* Nothing */
	|	left_paren insert_column_list right_paren
	;

opt_nt_485
	:	/* Nothing */
	|	override_clause
	;

from_subquery
	:	opt_nt_484 opt_nt_485 query_expression
	;

insert_column_list
	:	column_name_list
	;

opt_nt_486
	:	/* Nothing */
	|	left_paren insert_column_list right_paren
	;

opt_nt_487
	:	/* Nothing */
	|	override_clause
	;

from_constructor
	:	opt_nt_486 opt_nt_487 contextually_typed_table_value_constructor
	;

override_clause
	:	OVERRIDING USER VALUE
	|	OVERRIDING SYSTEM VALUE
	;

contextually_typed_table_value_constructor
	:	VALUES contextually_typed_row_value_expression_list
	;

seq_nt_489
	:	comma contextually_typed_row_value_expression
	;

lst_nt_490
	:	seq_nt_489
	|	lst_nt_490 seq_nt_489
	;

opt_nt_488
	:	/* Nothing */
	|	lst_nt_490 ']'
	;

contextually_typed_row_value_expression_list
	:	contextually_typed_row_value_expression opt_nt_488
	;

contextually_typed_row_value_expression
	:	row_value_special_case
	|	contextually_typed_row_value_constructor
	;

opt_nt_491
	:	/* Nothing */
	|	ROW
	;

contextually_typed_row_value_constructor
	:	contextually_typed_row_value_constructor_element
	|	opt_nt_491 left_paren contextually_typed_row_value_constructor_element_list right_paren
	;

contextually_typed_row_value_constructor_element
	:	value_expression
	|	contextually_typed_value_specification
	;

contextually_typed_value_specification
	:	implicitly_typed_value_specification
	|	default_specification
	;

default_specification
	:	DEFAULT
	;

seq_nt_493
	:	comma contextually_typed_row_value_constructor_element
	;

lst_nt_494
	:	seq_nt_493
	|	lst_nt_494 seq_nt_493
	;

opt_nt_492
	:	/* Nothing */
	|	lst_nt_494 ']'
	;

contextually_typed_row_value_constructor_element_list
	:	contextually_typed_row_value_constructor_element opt_nt_492
	;

from_default
	:	DEFAULT VALUES
	;

update_statement_positioned
	:	UPDATE target_table SET set_clause_list WHERE CURRENT OF cursor_name
	;

seq_nt_496
	:	comma set_clause
	;

lst_nt_497
	:	seq_nt_496
	|	lst_nt_497 seq_nt_496
	;

opt_nt_495
	:	/* Nothing */
	|	lst_nt_497 ']'
	;

set_clause_list
	:	set_clause opt_nt_495
	;

set_clause
	:	update_target equals_operator update_source
	|	mutated_set_clause equals_operator update_source
	;

update_target
	:	object_column
	|	object_column left_bracket_or_trigraph simple_value_specification right_bracket_or_trigraph
	;

object_column
	:	column_name
	;

update_source
	:	value_expression
	|	contextually_typed_value_specification
	;

mutated_set_clause
	:	mutated_target period method_name
	;

mutated_target
	:	object_column
	|	mutated_set_clause
	;

opt_nt_498
	:	/* Nothing */
	|	WHERE search_condition ']'
	;

update_statement_searched
	:	UPDATE target_table SET set_clause_list opt_nt_498
	;

sql_control_statement
	:	call_statement
	|	return_statement
	|	assignment_statement
	|	compound_statement
	|	case_statement
	|	if_statement
	|	iterate_statement
	|	leave_statement
	|	loop_statement
	|	while_statement
	|	repeat_statement
	|	for_statement
	;

call_statement
	:	CALL routine_invocation
	;

return_statement
	:	RETURN return_value
	;

return_value
	:	value_expression
	|	NULL
	;

sql_transaction_statement
	:	start_transaction_statement
	|	set_transaction_statement
	|	set_constraints_mode_statement
	|	savepoint_statement
	|	release_savepoint_statement
	|	commit_statement
	|	rollback_statement
	;

seq_nt_500
	:	comma transaction_mode
	;

lst_nt_501
	:	seq_nt_500
	|	lst_nt_501 seq_nt_500
	;

opt_nt_499
	:	/* Nothing */
	|	lst_nt_501 ']'
	;

start_transaction_statement
	:	START TRANSACTION transaction_mode opt_nt_499
	;

transaction_mode
	:	isolation_level
	|	transaction_access_mode
	|	diagnostics_size
	;

isolation_level
	:	ISOLATION LEVEL level_of_isolation
	;

level_of_isolation
	:	READ UNCOMMITTED
	|	READ COMMITTED
	|	REPEATABLE READ
	|	SERIALIZABLE
	;

transaction_access_mode
	:	READ ONLY
	|	READ WRITE
	;

diagnostics_size
	:	DIAGNOSTICS SIZE number_of_conditions
	;

number_of_conditions
	:	simple_value_specification
	;

opt_nt_502
	:	/* Nothing */
	|	LOCAL
	;

set_transaction_statement
	:	SET opt_nt_502 transaction_characteristics
	;

seq_nt_504
	:	comma transaction_mode
	;

lst_nt_505
	:	seq_nt_504
	|	lst_nt_505 seq_nt_504
	;

opt_nt_503
	:	/* Nothing */
	|	lst_nt_505 ']'
	;

transaction_characteristics
	:	TRANSACTION transaction_mode opt_nt_503
	;

seq_nt_506
	:	DEFERRED
	|	IMMEDIATE '}'
	;

set_constraints_mode_statement
	:	SET CONSTRAINTS constraint_name_list seq_nt_506
	;

seq_nt_508
	:	comma constraint_name
	;

lst_nt_509
	:	seq_nt_508
	|	lst_nt_509 seq_nt_508
	;

opt_nt_507
	:	/* Nothing */
	|	lst_nt_509 ']'
	;

constraint_name_list
	:	ALL
	|	constraint_name opt_nt_507
	;

savepoint_statement
	:	SAVEPOINT savepoint_specifier
	;

savepoint_specifier
	:	savepoint_name
	;

savepoint_name
	:	identifier
	;

simple_target_specification
	:	host_parameter_specification
	|	sql_parameter_reference
	|	column_reference
	|	sql_variable_reference
	|	embedded_variable_name
	;

release_savepoint_statement
	:	RELEASE SAVEPOINT savepoint_specifier
	;

opt_nt_510
	:	/* Nothing */
	|	WORK
	;

opt_nt_512
	:	/* Nothing */
	|	NO
	;

opt_nt_511
	:	/* Nothing */
	|	AND opt_nt_512 CHAIN ']'
	;

commit_statement
	:	COMMIT opt_nt_510 opt_nt_511
	;

opt_nt_513
	:	/* Nothing */
	|	WORK
	;

opt_nt_515
	:	/* Nothing */
	|	NO
	;

opt_nt_514
	:	/* Nothing */
	|	AND opt_nt_515 CHAIN
	;

opt_nt_516
	:	/* Nothing */
	|	savepoint_clause ']'
	;

rollback_statement
	:	ROLLBACK opt_nt_513 opt_nt_514 opt_nt_516
	;

savepoint_clause
	:	TO SAVEPOINT savepoint_specifier
	;

sql_connection_statement
	:	connect_statement
	|	set_connection_statement
	|	disconnect_statement
	;

connect_statement
	:	CONNECT TO connection_target
	;

opt_nt_517
	:	/* Nothing */
	|	AS connection_name
	;

opt_nt_518
	:	/* Nothing */
	|	USER connection_user_name
	;

connection_target
	:	sql_server_name opt_nt_517 opt_nt_518
	|	DEFAULT
	;

sql_server_name
	:	simple_value_specification
	;

connection_name
	:	simple_value_specification
	;

connection_user_name
	:	simple_value_specification
	;

set_connection_statement
	:	SET CONNECTION connection_object
	;

connection_object
	:	DEFAULT
	|	connection_name
	;

disconnect_statement
	:	DISCONNECT disconnect_object
	;

disconnect_object
	:	connection_object
	|	ALL
	|	CURRENT
	;

sql_session_statement
	:	set_session_user_identifier_statement
	|	set_role_statement
	|	set_local_time_zone_statement
	|	set_session_characteristics_statement
	|	set_catalog_statement
	|	set_schema_statement
	|	set_names_statement
	|	set_path_statement
	|	set_transform_group_statement
	;

set_session_user_identifier_statement
	:	SET SESSION AUTHORIZATION value_specification
	;

set_role_statement
	:	SET ROLE role_specification
	;

role_specification
	:	value_specification
	|	NONE
	;

set_local_time_zone_statement
	:	SET TIME ZONE set_time_zone_value
	;

set_time_zone_value
	:	interval_value_expression
	|	LOCAL
	;

set_session_characteristics_statement
	:	SET SESSION CHARACTERISTICS AS session_characteristic_list
	;

seq_nt_520
	:	comma session_characteristic
	;

lst_nt_521
	:	seq_nt_520
	|	lst_nt_521 seq_nt_520
	;

opt_nt_519
	:	/* Nothing */
	|	lst_nt_521 ']'
	;

session_characteristic_list
	:	session_characteristic opt_nt_519
	;

session_characteristic
	:	transaction_characteristics
	;

sql_diagnostics_statement
	:	get_diagnostics_statement
	|	signal_statement
	|	resignal_statement
	;

get_diagnostics_statement
	:	GET DIAGNOSTICS sql_diagnostics_information
	;

sql_diagnostics_information
	:	statement_information
	|	condition_information
	;

seq_nt_523
	:	comma statement_information_item
	;

lst_nt_524
	:	seq_nt_523
	|	lst_nt_524 seq_nt_523
	;

opt_nt_522
	:	/* Nothing */
	|	lst_nt_524 ']'
	;

statement_information
	:	statement_information_item opt_nt_522
	;

statement_information_item
	:	simple_target_specification equals_operator statement_information_item_name
	;

statement_information_item_name
	:	NUMBER
	|	MORE
	|	COMMAND_FUNCTION
	|	COMMAND_FUNCTION_CODE
	|	DYNAMIC_FUNCTION
	|	DYNAMIC_FUNCTION_CODE
	|	ROW_COUNT
	|	TRANSACTIONS_COMMITTED
	|	TRANSACTIONS_ROLLED_BACK
	|	TRANSACTION_ACTIVE
	;

seq_nt_526
	:	comma condition_information_item
	;

lst_nt_527
	:	seq_nt_526
	|	lst_nt_527 seq_nt_526
	;

opt_nt_525
	:	/* Nothing */
	|	lst_nt_527 ']'
	;

condition_information
	:	EXCEPTION condition_number condition_information_item opt_nt_525
	;

condition_number
	:	simple_value_specification
	;

condition_information_item
	:	simple_target_specification equals_operator condition_information_item_name
	;

condition_information_item_name
	:	CATALOG_NAME
	|	CLASS_ORIGIN
	|	COLUMN_NAME
	|	CONDITION_IDENTIFIER
	|	CONDITION_NUMBER
	|	CONNECTION_NAME
	|	CONSTRAINT_CATALOG
	|	CONSTRAINT_NAME
	|	CONSTRAINT_SCHEMA
	|	CURSOR_NAME
	|	MESSAGE_LENGTH
	|	MESSAGE_OCTET_LENGTH
	|	MESSAGE_TEXT
	|	PARAMETER_MODE
	|	PARAMETER_NAME
	|	PARAMETER_ORDINAL_POSITION
	|	RETURNED_SQLSTATE
	|	ROUTINE_CATALOG
	|	ROUTINE_NAME
	|	ROUTINE_SCHEMA
	|	SCHEMA_NAME
	|	SERVER_NAME
	|	SPECIFIC_NAME
	|	SUBCLASS_ORIGIN
	|	TABLE_NAME
	|	TRIGGER_CATALOG
	|	TRIGGER_NAME
	|	TRIGGER_SCHEMA
	;

dereference_operation
	:	reference_value_expression dereference_operator attribute_name
	;

method_reference
	:	value_expression_primary dereference_operator method_name sql_argument_list
	;

method_selection
	:	routine_invocation
	;

new_invocation
	:	method_invocation
	|	routine_invocation
	;

static_method_selection
	:	routine_invocation
	;

token
	:	nondelimiter_token
	|	delimiter_token
	;

nondelimiter_token
	:	regular_identifier
	|	key_word
	|	unsigned_numeric_literal
	|	national_character_string_literal
	|	bit_string_literal
	|	hex_string_literal
	|	large_object_length_token
	|	multiplier
	;

key_word
	:	reserved_word
	|	non_reserved_word
	;

reserved_word
	:	ABSOLUTE
	|	ACTION
	|	ADD
	|	AFTER
	|	ALL
	|	ALLOCATE
	|	ALTER
	|	AND
	|	ANY
	|	ARE
	|	ARRAY
	|	AS
	|	ASC
	|	ASSERTION
	|	AT
	|	AUTHORIZATION
	|	BEFORE
	|	BEGIN
	|	BETWEEN
	|	BINARY
	|	BIT
	|	BLOB
	|	BOOLEAN
	|	BOTH
	|	BREADTH
	|	BY
	|	CALL
	|	CASCADE
	|	CASCADED
	|	CASE
	|	CAST
	|	CATALOG
	|	CHAR
	|	CHARACTER
	|	CHECK
	|	CLOB
	|	CLOSE
	|	COLLATE
	|	COLLATION
	|	COLUMN
	|	COMMIT
	|	CONDITION
	|	CONNECT
	|	CONNECTION
	|	CONSTRAINT
	|	CONSTRAINTS
	|	CONSTRUCTOR
	|	CONTINUE
	|	CORRESPONDING
	|	CREATE
	|	CROSS
	|	CUBE
	|	CURRENT
	|	CURRENT_DATE
	|	CURRENT_DEFAULT_TRANSFORM_GROUP
	|	CURRENT_TRANSFORM_GROUP_FOR_TYPE
	|	CURRENT_PATH
	|	CURRENT_ROLE
	|	CURRENT_TIME
	|	CURRENT_TIMESTAMP
	|	CURRENT_USER
	|	CURSOR
	|	CYCLE
	|	DATA
	|	DATE
	|	DAY
	|	DEALLOCATE
	|	DEC
	|	DECIMAL
	|	DECLARE
	|	DEFAULT
	|	DEFERRABLE
	|	DEFERRED
	|	DELETE
	|	DEPTH
	|	DEREF
	|	DESC
	|	DESCRIBE
	|	DESCRIPTOR
	|	DETERMINISTIC
	|	DIAGNOSTICS
	|	DISCONNECT
	|	DISTINCT
	|	DO
	|	DOMAIN
	|	DOUBLE
	|	DROP
	|	DYNAMIC
	|	EACH
	|	ELSE
	|	ELSEIF
	|	END
	|	END-EXEC
	|	EQUALS
	|	ESCAPE
	|	EXCEPT
	|	EXCEPTION
	|	EXEC
	|	EXECUTE
	|	EXISTS
	|	EXIT
	|	EXTERNAL
	|	FALSE
	|	FETCH
	|	FIRST
	|	FLOAT
	|	FOR
	|	FOREIGN
	|	FOUND
	|	FROM
	|	FREE
	|	FULL
	|	FUNCTION
	|	GENERAL
	|	GET
	|	GLOBAL
	|	GO
	|	GOTO
	|	GRANT
	|	GROUP
	|	GROUPING
	|	HANDLE
	|	HAVING
	|	HOLD
	|	HOUR
	|	IDENTITY
	|	IF
	|	IMMEDIATE
	|	IN
	|	INDICATOR
	|	INITIALLY
	|	INNER
	|	INOUT
	|	INPUT
	|	INSERT
	|	INT
	|	INTEGER
	|	INTERSECT
	|	INTERVAL
	|	INTO
	|	IS
	|	ISOLATION
	|	JOIN
	|	KEY
	|	LANGUAGE
	|	LARGE
	|	LAST
	|	LATERAL
	|	LEADING
	|	LEAVE
	|	LEFT
	|	LEVEL
	|	LIKE
	|	LOCAL
	|	LOCALTIME
	|	LOCALTIMESTAMP
	|	LOCATOR
	|	LOOP
	|	MAP
	|	MATCH
	|	METHOD
	|	MINUTE
	|	MODIFIES
	|	MODULE
	|	MONTH
	|	NAMES
	|	NATIONAL
	|	NATURAL
	|	NCHAR
	|	NCLOB
	|	NESTING
	|	NEW
	|	NEXT
	|	NO
	|	NONE
	|	NOT
	|	NULL
	|	NUMERIC
	|	OBJECT
	|	OF
	|	OLD
	|	ON
	|	ONLY
	|	OPEN
	|	OPTION
	|	OR
	|	ORDER
	|	ORDINALITY
	|	OUT
	|	OUTER
	|	OUTPUT
	|	OVERLAPS
	|	PAD
	|	PARAMETER
	|	PARTIAL
	|	PATH
	|	PRECISION
	|	PREPARE
	|	PRESERVE
	|	PRIMARY
	|	PRIOR
	|	PRIVILEGES
	|	PROCEDURE
	|	PUBLIC
	|	READ
	|	READS
	|	REAL
	|	RECURSIVE
	|	REDO
	|	REF
	|	REFERENCES
	|	REFERENCING
	|	RELATIVE
	|	RELEASE
	|	REPEAT
	|	RESIGNAL
	|	RESTRICT
	|	RESULT
	|	RETURN
	|	RETURNS
	|	REVOKE
	|	RIGHT
	|	ROLE
	|	ROLLBACK
	|	ROLLUP
	|	ROUTINE
	|	ROW
	|	ROWS
	|	SAVEPOINT
	|	SCHEMA
	|	SCROLL
	|	SEARCH
	|	SECOND
	|	SECTION
	|	SELECT
	|	SESSION
	|	SESSION_USER
	|	SET
	|	SETS
	|	SIGNAL
	|	SIMILAR
	|	SIZE
	|	SMALLINT
	|	SOME
	|	SPACE
	|	SPECIFIC
	|	SPECIFICTYPE
	|	SQL
	|	SQLEXCEPTION
	|	SQLSTATE
	|	SQLWARNING
	|	START
	|	STATE
	|	STATIC
	|	SYSTEM_USER
	|	TABLE
	|	TEMPORARY
	|	THEN
	|	TIME
	|	TIMESTAMP
	|	TIMEZONE_HOUR
	|	TIMEZONE_MINUTE
	|	TO
	|	TRAILING
	|	TRANSACTION
	|	TRANSLATION
	|	TREAT
	|	TRIGGER
	|	TRUE
	|	UNDER
	|	UNDO
	|	UNION
	|	UNIQUE
	|	UNKNOWN
	|	UNNEST
	|	UNTIL
	|	UPDATE
	|	USAGE
	|	USER
	|	USING
	|	VALUE
	|	VALUES
	|	VARCHAR
	|	VARYING
	|	VIEW
	|	WHEN
	|	WHENEVER
	|	WHERE
	|	WHILE
	|	WITH
	|	WITHOUT
	|	WORK
	|	WRITE
	|	YEAR
	|	ZONE
	;

non_reserved_word
	:	ABS
	|	ADA
	|	ADMIN
	|	ASENSITIVE
	|	ASSIGNMENT
	|	ASYMMETRIC
	|	ATOMIC
	|	ATTRIBUTE
	|	AVG
	|	BIT_LENGTH
	|	C
	|	CALLED
	|	CARDINALITY
	|	CATALOG_NAME
	|	CHAIN
	|	CHAR_LENGTH
	|	CHARACTERISTICS
	|	CHARACTER_LENGTH
	|	CHARACTER_SET_CATALOG
	|	CHARACTER_SET_NAME
	|	CHARACTER_SET_SCHEMA
	|	CHECKED
	|	CLASS_ORIGIN
	|	COALESCE
	|	COBOL
	|	COLLATION_CATALOG
	|	COLLATION_NAME
	|	COLLATION_SCHEMA
	|	COLUMN_NAME
	|	COMMAND_FUNCTION
	|	COMMAND_FUNCTION_CODE
	|	COMMITTED
	|	CONDITION_IDENTIFIER
	|	CONDITION_NUMBER
	|	CONNECTION_NAME
	|	CONSTRAINT_CATALOG
	|	CONSTRAINT_NAME
	|	CONSTRAINT_SCHEMA
	|	CONTAINS
	|	CONVERT
	|	COUNT
	|	CURSOR_NAME
	|	DATETIME_INTERVAL_CODE
	|	DATETIME_INTERVAL_PRECISION
	|	DEFINED
	|	DEFINER
	|	DEGREE
	|	DERIVED
	|	DISPATCH
	|	EVERY
	|	EXTRACT
	|	FINAL
	|	FORTRAN
	|	G
	|	GENERATED
	|	GRANTED
	|	HIERARCHY
	|	IMPLEMENTATION
	|	INSENSITIVE
	|	INSTANCE
	|	INSTANTIABLE
	|	INVOKER
	|	K
	|	KEY_MEMBER
	|	KEY_TYPE
	|	LENGTH
	|	LOWER
	|	M
	|	MAX
	|	MIN
	|	MESSAGE_LENGTH
	|	MESSAGE_OCTET_LENGTH
	|	MESSAGE_TEXT
	|	MOD
	|	MORE
	|	MUMPS
	|	NAME
	|	NULLABLE
	|	NUMBER
	|	NULLIF
	|	OCTET_LENGTH
	|	ORDERING
	|	OPTIONS
	|	OVERLAY
	|	OVERRIDING
	|	PASCAL
	|	PARAMETER_MODE
	|	PARAMETER_NAME
	|	PARAMETER_ORDINAL_POSITION
	|	PARAMETER_SPECIFIC_CATALOG
	|	PARAMETER_SPECIFIC_NAME
	|	PARAMETER_SPECIFIC_SCHEMA
	|	PLI
	|	POSITION
	|	REPEATABLE
	|	RETURNED_CARDINALITY
	|	RETURNED_LENGTH
	|	RETURNED_OCTET_LENGTH
	|	RETURNED_SQLSTATE
	|	ROUTINE_CATALOG
	|	ROUTINE_NAME
	|	ROUTINE_SCHEMA
	|	ROW_COUNT
	|	SCALE
	|	SCHEMA_NAME
	|	SCOPE
	|	SECURITY
	|	SELF
	|	SENSITIVE
	|	SERIALIZABLE
	|	SERVER_NAME
	|	SIMPLE
	|	SOURCE
	|	SPECIFIC_NAME
	|	STATEMENT
	|	STRUCTURE
	|	STYLE
	|	SUBCLASS_ORIGIN
	|	SUBSTRING
	|	SUM
	|	SYMMETRIC
	|	SYSTEM
	|	TABLE_NAME
	|	TOP_LEVEL_COUNT
	|	TRANSACTIONS_COMMITTED
	|	TRANSACTIONS_ROLLED_BACK
	|	TRANSACTION_ACTIVE
	|	TRANSFORM
	|	TRANSFORMS
	|	TRANSLATE
	|	TRIGGER_CATALOG
	|	TRIGGER_SCHEMA
	|	TRIGGER_NAME
	|	TRIM
	|	TYPE
	|	UNCOMMITTED
	|	UNNAMED
	|	UPPER
	;

delimiter_token
	:	character_string_literal
	|	date_string
	|	time_string
	|	timestamp_string
	|	interval_string
	|	delimited_identifier
	|	sql_special_character
	|	not_equals_operator
	|	greater_than_or_equals_operator
	|	less_than_or_equals_operator
	|	concatenation_operator
	|	right_arrow
	|	left_bracket_trigraph
	|	right_bracket_trigraph
	|	double_colon
	|	double_period
	;

opt_nt_528
	:	/* Nothing */
	|	cli_returns_clause ']'
	;

cli_routine
	:	cli_routine_name cli_parameter_list opt_nt_528
	;

cli_routine_name
	:	cli_name_prefix cli_generic_name
	;

cli_name_prefix
	:	cli_by_reference_prefix
	|	cli_by_value_prefix
	;

cli_by_reference_prefix
	:	SQLR
	;

cli_by_value_prefix
	:	SQL
	;

cli_generic_name
	:	AllocConnect
	|	AllocEnv
	|	AllocHandle
	|	AllocStmt
	|	BindCol
	|	BindParameter
	|	Cancel
	|	CloseCursor
	|	ColAttribute
	|	ColumnPrivileges
	|	Columns
	|	Connect
	|	CopyDesc
	|	DataSources
	|	DescribeCol
	|	Disconnect
	|	EndTran
	|	Error
	|	ExecDirect
	|	Execute
	|	Fetch
	|	FetchScroll
	|	ForeignKeys
	|	FreeConnect
	|	FreeEnv
	|	FreeHandle
	|	FreeStmt
	|	GetConnectAttr
	|	GetCursorName
	|	GetData
	|	GetDescField
	|	GetDescRec
	|	GetDiagField
	|	GetDiagRec
	|	GetEnvAttr
	|	GetFeatureInfo
	|	GetFunctions
	|	GetInfo
	|	GetLength
	|	GetParamData
	|	GetPosition
	|	GetSessionInfo
	|	GetStmtAttr
	|	GetSubString
	|	GetTypeInfo
	|	MoreResults
	|	NextResult
	|	NumResultCols
	|	ParamData
	|	Prepare
	|	PrimaryKeys
	|	PutData
	|	RowCount
	|	SetConnectAttr
	|	SetCursorName
	|	SetDescField
	|	SetDescRec
	|	SetEnvAttr
	|	SetStmtAttr
	|	SpecialColumns
	|	StartTran
	|	TablePrivileges
	|	Tables
	|	implementation_defined_cli_generic_name
	;

implementation_defined_cli_generic_name
	:	/* !! (See the Syntax Rules) */
	;

seq_nt_530
	:	comma cli_parameter_declaration
	;

lst_nt_531
	:	seq_nt_530
	|	lst_nt_531 seq_nt_530
	;

opt_nt_529
	:	/* Nothing */
	|	lst_nt_531
	;

cli_parameter_list
	:	left_paren cli_parameter_declaration opt_nt_529 right_paren
	;

cli_parameter_declaration
	:	cli_parameter_name cli_parameter_mode cli_parameter_data_type
	;

cli_parameter_name
	:	/* !! (See the individual CLI routine definitions) */
	;

cli_parameter_mode
	:	IN
	|	OUT
	|	DEFIN
	|	DEFOUT
	|	DEF
	;

cli_parameter_data_type
	:	INTEGER
	|	SMALLINT
	|	ANY
	|	CHARACTER left_paren length right_paren
	;

cli_returns_clause
	:	RETURNS SMALLINT
	;

assignment_statement
	:	SET assignment_target equals_operator assignment_source
	;

assignment_target
	:	target_specification
	|	modified_field_reference
	|	mutator_reference
	;

sql_variable_reference
	:	basic_identifier_chain
	;

modified_field_reference
	:	modified_field_target period field_name
	;

modified_field_target
	:	target_specification
	|	left_paren target_specification right_paren
	|	modified_field_reference
	;

mutator_reference
	:	mutated_target_specification period method_name
	;

mutated_target_specification
	:	target_specification
	|	left_paren target_specification right_paren
	|	mutator_reference
	;

assignment_source
	:	value_expression
	|	contextually_typed_source
	;

contextually_typed_source
	:	implicitly_typed_value_specification
	|	contextually_typed_row_value_expression
	;

opt_nt_532
	:	/* Nothing */
	|	beginning_label colon
	;

opt_nt_534
	:	/* Nothing */
	|	NOT
	;

opt_nt_533
	:	/* Nothing */
	|	opt_nt_534 ATOMIC
	;

opt_nt_535
	:	/* Nothing */
	|	local_declaration_list
	;

opt_nt_536
	:	/* Nothing */
	|	local_cursor_declaration_list
	;

opt_nt_537
	:	/* Nothing */
	|	local_handler_declaration_list
	;

opt_nt_538
	:	/* Nothing */
	|	sql_statement_list
	;

opt_nt_539
	:	/* Nothing */
	|	ending_label ']'
	;

compound_statement
	:	opt_nt_532 BEGIN opt_nt_533 opt_nt_535 opt_nt_536 opt_nt_537 opt_nt_538 END opt_nt_539
	;

beginning_label
	:	statement_label
	;

statement_label
	:	identifier
	;

lst_nt_540
	:	terminated_local_declaration
	|	lst_nt_540 terminated_local_declaration
	;

local_declaration_list
	:	lst_nt_540
	;

terminated_local_declaration
	:	local_declaration semicolon
	;

local_declaration
	:	sql_variable_declaration
	|	condition_declaration
	;

opt_nt_541
	:	/* Nothing */
	|	default_clause ']'
	;

sql_variable_declaration
	:	DECLARE sql_variable_name_list data_type opt_nt_541
	;

seq_nt_543
	:	comma sql_variable_name
	;

lst_nt_544
	:	seq_nt_543
	|	lst_nt_544 seq_nt_543
	;

opt_nt_542
	:	/* Nothing */
	|	lst_nt_544 ']'
	;

sql_variable_name_list
	:	sql_variable_name opt_nt_542
	;

sql_variable_name
	:	identifier
	;

opt_nt_545
	:	/* Nothing */
	|	FOR sqlstate_value ']'
	;

condition_declaration
	:	DECLARE condition_name CONDITION opt_nt_545
	;

condition_name
	:	identifier
	;

opt_nt_546
	:	/* Nothing */
	|	VALUE
	;

sqlstate_value
	:	SQLSTATE opt_nt_546 character_string_literal
	;

lst_nt_547
	:	terminated_local_cursor_declaration
	|	lst_nt_547 terminated_local_cursor_declaration
	;

local_cursor_declaration_list
	:	lst_nt_547
	;

terminated_local_cursor_declaration
	:	declare_cursor semicolon
	;

lst_nt_548
	:	terminated_local_handler_declaration
	|	lst_nt_548 terminated_local_handler_declaration
	;

local_handler_declaration_list
	:	lst_nt_548
	;

terminated_local_handler_declaration
	:	handler_declaration semicolon
	;

handler_declaration
	:	DECLARE handler_type HANDLER FOR condition_value_list handler_action
	;

handler_type
	:	CONTINUE
	|	EXIT
	|	UNDO
	;

seq_nt_550
	:	comma condition_value
	;

lst_nt_551
	:	seq_nt_550
	|	lst_nt_551 seq_nt_550
	;

opt_nt_549
	:	/* Nothing */
	|	lst_nt_551 ']'
	;

condition_value_list
	:	condition_value opt_nt_549
	;

condition_value
	:	sqlstate_value
	|	condition_name
	|	SQLEXCEPTION
	|	SQLWARNING
	|	NOT FOUND
	;

handler_action
	:	sql_procedure_statement
	;

lst_nt_552
	:	terminated_sql_statement
	|	lst_nt_552 terminated_sql_statement
	;

sql_statement_list
	:	lst_nt_552
	;

terminated_sql_statement
	:	sql_procedure_statement semicolon
	;

ending_label
	:	statement_label
	;

case_statement
	:	simple_case_statement
	|	searched_case_statement
	;

lst_nt_553
	:	simple_case_statement_when_clause
	|	lst_nt_553 simple_case_statement_when_clause
	;

opt_nt_554
	:	/* Nothing */
	|	case_statement_else_clause
	;

simple_case_statement
	:	CASE simple_case_operand_1 lst_nt_553 opt_nt_554 END CASE
	;

simple_case_operand_1
	:	value_expression
	;

simple_case_statement_when_clause
	:	WHEN simple_case_operand_2 THEN sql_statement_list
	;

simple_case_operand_2
	:	value_expression
	;

case_statement_else_clause
	:	ELSE sql_statement_list
	;

lst_nt_555
	:	searched_case_statement_when_clause
	|	lst_nt_555 searched_case_statement_when_clause
	;

opt_nt_556
	:	/* Nothing */
	|	case_statement_else_clause
	;

searched_case_statement
	:	CASE lst_nt_555 opt_nt_556 END CASE
	;

searched_case_statement_when_clause
	:	WHEN search_condition THEN sql_statement_list
	;

lst_nt_558
	:	if_statement_elseif_clause
	|	lst_nt_558 if_statement_elseif_clause
	;

opt_nt_557
	:	/* Nothing */
	|	lst_nt_558
	;

opt_nt_559
	:	/* Nothing */
	|	if_statement_else_clause
	;

if_statement
	:	IF search_condition if_statement_then_clause opt_nt_557 opt_nt_559 END IF
	;

if_statement_then_clause
	:	THEN sql_statement_list
	;

if_statement_elseif_clause
	:	ELSEIF search_condition THEN sql_statement_list
	;

if_statement_else_clause
	:	ELSE sql_statement_list
	;

iterate_statement
	:	ITERATE statement_label
	;

leave_statement
	:	LEAVE statement_label
	;

opt_nt_560
	:	/* Nothing */
	|	beginning_label colon
	;

opt_nt_561
	:	/* Nothing */
	|	ending_label ']'
	;

loop_statement
	:	opt_nt_560 LOOP sql_statement_list END LOOP opt_nt_561
	;

opt_nt_562
	:	/* Nothing */
	|	beginning_label colon
	;

opt_nt_563
	:	/* Nothing */
	|	ending_label ']'
	;

while_statement
	:	opt_nt_562 WHILE search_condition DO sql_statement_list END WHILE opt_nt_563
	;

opt_nt_564
	:	/* Nothing */
	|	beginning_label colon
	;

opt_nt_565
	:	/* Nothing */
	|	ending_label ']'
	;

repeat_statement
	:	opt_nt_564 REPEAT sql_statement_list UNTIL search_condition END REPEAT opt_nt_565
	;

opt_nt_566
	:	/* Nothing */
	|	beginning_label colon
	;

opt_nt_568
	:	/* Nothing */
	|	cursor_sensitivity
	;

opt_nt_567
	:	/* Nothing */
	|	cursor_name opt_nt_568 CURSOR FOR
	;

opt_nt_569
	:	/* Nothing */
	|	ending_label ']'
	;

for_statement
	:	opt_nt_566 FOR for_loop_variable_name AS opt_nt_567 cursor_specification DO sql_statement_list END FOR opt_nt_569
	;

for_loop_variable_name
	:	identifier
	;

opt_nt_570
	:	/* Nothing */
	|	set_signal_information ']'
	;

signal_statement
	:	SIGNAL signal_value opt_nt_570
	;

signal_value
	:	condition_name
	|	sqlstate_value
	;

set_signal_information
	:	SET signal_information_item_list
	;

seq_nt_572
	:	comma signal_information_item
	;

lst_nt_573
	:	seq_nt_572
	|	lst_nt_573 seq_nt_572
	;

opt_nt_571
	:	/* Nothing */
	|	lst_nt_573 ']'
	;

signal_information_item_list
	:	signal_information_item opt_nt_571
	;

signal_information_item
	:	condition_information_item_name equals_operator simple_value_specification
	;

opt_nt_574
	:	/* Nothing */
	|	signal_value
	;

opt_nt_575
	:	/* Nothing */
	|	set_signal_information ']'
	;

resignal_statement
	:	RESIGNAL opt_nt_574 opt_nt_575
	;

opt_nt_576
	:	/* Nothing */
	|	sql_server_module_character_set_specification
	;

opt_nt_577
	:	/* Nothing */
	|	sql_server_module_schema_clause
	;

opt_nt_578
	:	/* Nothing */
	|	sql_server_module_path_specification
	;

opt_nt_579
	:	/* Nothing */
	|	temporary_table_declaration
	;

lst_nt_580
	:	sql_server_module_contents
	|	lst_nt_580 sql_server_module_contents
	;

sql_server_module_definition
	:	CREATE MODULE sql_server_module_name opt_nt_576 opt_nt_577 opt_nt_578 opt_nt_579 lst_nt_580 END MODULE
	;

sql_server_module_name
	:	schema_qualified_name
	;

sql_server_module_character_set_specification
	:	NAMES ARE character_set_specification
	;

sql_server_module_schema_clause
	:	SCHEMA default_schema_name
	;

default_schema_name
	:	schema_name
	;

sql_server_module_path_specification
	:	path_specification
	;

sql_server_module_contents
	:	sql_invoked_routine semicolon
	;

module_routine
	:	module_procedure
	|	module_function
	;

opt_nt_581
	:	/* Nothing */
	|	DECLARE
	;

module_procedure
	:	opt_nt_581 sql_invoked_procedure
	;

opt_nt_582
	:	/* Nothing */
	|	DECLARE
	;

module_function
	:	opt_nt_582 sql_invoked_function
	;

drop_module_statement
	:	DROP MODULE sql_server_module_name drop_behavior
	;

triggered_sql_statement
	:	sql_procedure_statement
	;

sql_dynamic_statement
	:	system_descriptor_statement
	|	prepare_statement
	|	deallocate_prepared_statement
	|	describe_statement
	|	execute_statement
	|	execute_immediate_statement
	|	sql_dynamic_data_statement
	;

system_descriptor_statement
	:	allocate_descriptor_statement
	|	deallocate_descriptor_statement
	|	set_descriptor_statement
	|	get_descriptor_statement
	;

opt_nt_583
	:	/* Nothing */
	|	SQL
	;

opt_nt_584
	:	/* Nothing */
	|	WITH MAX occurrences ']'
	;

allocate_descriptor_statement
	:	ALLOCATE opt_nt_583 DESCRIPTOR descriptor_name opt_nt_584
	;

opt_nt_585
	:	/* Nothing */
	|	scope_option
	;

descriptor_name
	:	opt_nt_585 simple_value_specification
	;

scope_option
	:	GLOBAL
	|	LOCAL
	;

embedded_variable_name
	:	colon host_identifier
	;

host_identifier
	:	ada_host_identifier
	|	c_host_identifier
	|	cobol_host_identifier
	|	fortran_host_identifier
	|	mumps_host_identifier
	|	pascal_host_identifier
	|	pl_i_host_identifier
	;

ada_host_identifier
	:	/* !! (See the Syntax Rules.) */
	;

c_host_identifier
	:	/* !! (See the Syntax Rules.) */
	;

cobol_host_identifier
	:	/* !! (See the Syntax Rules.) */
	;

fortran_host_identifier
	:	/* !! (See the Syntax Rules.) */
	;

mumps_host_identifier
	:	/* !! (See the Syntax Rules.) */
	;

pascal_host_identifier
	:	/* !! (See the Syntax Rules.) */
	;

pl_i_host_identifier
	:	/* !! (See the Syntax Rules.) */
	;

occurrences
	:	simple_value_specification
	;

opt_nt_586
	:	/* Nothing */
	|	SQL
	;

deallocate_descriptor_statement
	:	DEALLOCATE opt_nt_586 DESCRIPTOR descriptor_name
	;

opt_nt_587
	:	/* Nothing */
	|	SQL
	;

set_descriptor_statement
	:	SET opt_nt_587 DESCRIPTOR descriptor_name set_descriptor_information
	;

seq_nt_589
	:	comma set_header_information
	;

lst_nt_590
	:	seq_nt_589
	|	lst_nt_590 seq_nt_589
	;

opt_nt_588
	:	/* Nothing */
	|	lst_nt_590
	;

seq_nt_592
	:	comma set_item_information
	;

lst_nt_593
	:	seq_nt_592
	|	lst_nt_593 seq_nt_592
	;

opt_nt_591
	:	/* Nothing */
	|	lst_nt_593 ']'
	;

set_descriptor_information
	:	set_header_information opt_nt_588
	|	VALUE item_number set_item_information opt_nt_591
	;

set_header_information
	:	header_item_name equals_operator simple_value_specification_1
	;

header_item_name
	:	COUNT
	|	KEY_TYPE
	|	DYNAMIC_FUNCTION
	|	DYNAMIC_FUNCTION_CODE
	|	TOP_LEVEL_COUNT
	;

simple_value_specification_1
	:	simple_value_specification
	;

item_number
	:	simple_value_specification
	;

set_item_information
	:	descriptor_item_name equals_operator simple_value_specification_2
	;

descriptor_item_name
	:	CARDINALITY
	|	CHARACTER_SET_CATALOG
	|	CHARACTER_SET_NAME
	|	CHARACTER_SET_SCHEMA
	|	COLLATION_CATALOG
	|	COLLATION_NAME
	|	COLLATION_SCHEMA
	|	DATA
	|	DATETIME_INTERVAL_CODE
	|	DATETIME_INTERVAL_PRECISION
	|	DEGREE
	|	INDICATOR
	|	KEY_MEMBER
	|	LENGTH
	|	LEVEL
	|	NAME
	|	NULLABLE
	|	OCTET_LENGTH
	|	PARAMETER_MODE
	|	PARAMETER_ORDINAL_POSITION
	|	PARAMETER_SPECIFIC_CATALOG
	|	PARAMETER_SPECIFIC_NAME
	|	PARAMETER_SPECIFIC_SCHEMA
	|	PRECISION
	|	RETURNED_CARDINALITY
	|	RETURNED_LENGTH
	|	RETURNED_OCTET_LENGTH
	|	SCALE
	|	SCOPE_CATALOG
	|	SCOPE_NAME
	|	SCOPE_SCHEMA
	|	TYPE
	|	UNNAMED
	|	USER_DEFINED_TYPE_CATALOG
	|	USER_DEFINED_TYPE_NAME
	|	USER_DEFINED_TYPE_SCHEMA
	;

simple_value_specification_2
	:	simple_value_specification
	;

item_number
	:	simple_value_specification
	;

opt_nt_594
	:	/* Nothing */
	|	SQL
	;

get_descriptor_statement
	:	GET opt_nt_594 DESCRIPTOR descriptor_name get_descriptor_information
	;

seq_nt_596
	:	comma get_header_information
	;

lst_nt_597
	:	seq_nt_596
	|	lst_nt_597 seq_nt_596
	;

opt_nt_595
	:	/* Nothing */
	|	lst_nt_597
	;

seq_nt_599
	:	comma get_item_information
	;

lst_nt_600
	:	seq_nt_599
	|	lst_nt_600 seq_nt_599
	;

opt_nt_598
	:	/* Nothing */
	|	lst_nt_600 ']'
	;

get_descriptor_information
	:	get_header_information opt_nt_595
	|	VALUE item_number get_item_information opt_nt_598
	;

get_header_information
	:	simple_target_specification_1 equals_operator header_item_name
	;

simple_target_specification_1
	:	simple_target_specification
	;

get_item_information
	:	simple_target_specification_2 equals_operator descriptor_item_name
	;

simple_target_specification_2
	:	simple_target_specification
	;

prepare_statement
	:	PREPARE sql_statement_name FROM sql_statement_variable
	;

sql_statement_name
	:	statement_name
	|	extended_statement_name
	;

statement_name
	:	identifier
	;

opt_nt_601
	:	/* Nothing */
	|	scope_option
	;

extended_statement_name
	:	opt_nt_601 simple_value_specification
	;

sql_statement_variable
	:	simple_value_specification
	;

deallocate_prepared_statement
	:	DEALLOCATE PREPARE sql_statement_name
	;

describe_statement
	:	describe_input_statement
	|	describe_output_statement
	;

opt_nt_602
	:	/* Nothing */
	|	nesting_option ']'
	;

describe_input_statement
	:	DESCRIBE INPUT sql_statement_name using_descriptor opt_nt_602
	;

opt_nt_603
	:	/* Nothing */
	|	SQL
	;

using_descriptor
	:	USING opt_nt_603 DESCRIPTOR descriptor_name
	;

nesting_option
	:	WITH NESTING
	|	WITHOUT NESTING
	;

opt_nt_604
	:	/* Nothing */
	|	OUTPUT
	;

opt_nt_605
	:	/* Nothing */
	|	nesting_option ']'
	;

describe_output_statement
	:	DESCRIBE opt_nt_604 described_object using_descriptor opt_nt_605
	;

described_object
	:	sql_statement_name
	|	CURSOR extended_cursor_name STRUCTURE
	;

opt_nt_606
	:	/* Nothing */
	|	scope_option
	;

extended_cursor_name
	:	opt_nt_606 simple_value_specification
	;

opt_nt_607
	:	/* Nothing */
	|	result_using_clause
	;

opt_nt_608
	:	/* Nothing */
	|	parameter_using_clause ']'
	;

execute_statement
	:	EXECUTE sql_statement_name opt_nt_607 opt_nt_608
	;

result_using_clause
	:	output_using_clause
	;

output_using_clause
	:	into_arguments
	|	into_descriptor
	;

seq_nt_610
	:	comma into_argument
	;

lst_nt_611
	:	seq_nt_610
	|	lst_nt_611 seq_nt_610
	;

opt_nt_609
	:	/* Nothing */
	|	lst_nt_611 ']'
	;

into_arguments
	:	INTO into_argument opt_nt_609
	;

into_argument
	:	target_specification
	;

dynamic_parameter_specification
	:	question_mark
	;

opt_nt_612
	:	/* Nothing */
	|	indicator_variable ']'
	;

embedded_variable_specification
	:	embedded_variable_name opt_nt_612
	;

opt_nt_613
	:	/* Nothing */
	|	INDICATOR
	;

indicator_variable
	:	opt_nt_613 embedded_variable_name
	;

opt_nt_614
	:	/* Nothing */
	|	SQL
	;

into_descriptor
	:	INTO opt_nt_614 DESCRIPTOR descriptor_name
	;

parameter_using_clause
	:	input_using_clause
	;

input_using_clause
	:	using_arguments
	|	using_input_descriptor
	;

seq_nt_616
	:	comma using_argument
	;

lst_nt_617
	:	seq_nt_616
	|	lst_nt_617 seq_nt_616
	;

opt_nt_615
	:	/* Nothing */
	|	lst_nt_617 ']'
	;

using_arguments
	:	USING using_argument opt_nt_615
	;

using_argument
	:	general_value_specification
	;

using_input_descriptor
	:	using_descriptor
	;

execute_immediate_statement
	:	EXECUTE IMMEDIATE sql_statement_variable
	;

sql_dynamic_data_statement
	:	allocate_cursor_statement
	|	dynamic_open_statement
	|	dynamic_fetch_statement
	|	dynamic_close_statement
	|	dynamic_delete_statement_positioned
	|	dynamic_update_statement_positioned
	;

allocate_cursor_statement
	:	ALLOCATE extended_cursor_name cursor_intent
	;

cursor_intent
	:	statement_cursor
	|	result_set_cursor
	;

opt_nt_618
	:	/* Nothing */
	|	cursor_sensitivity
	;

opt_nt_619
	:	/* Nothing */
	|	SCROLL
	;

opt_nt_620
	:	/* Nothing */
	|	WITH HOLD
	;

opt_nt_621
	:	/* Nothing */
	|	WITH RETURN
	;

statement_cursor
	:	opt_nt_618 opt_nt_619 CURSOR opt_nt_620 opt_nt_621 FOR extended_statement_name
	;

result_set_cursor
	:	FOR PROCEDURE specific_routine_designator
	;

opt_nt_622
	:	/* Nothing */
	|	input_using_clause ']'
	;

dynamic_open_statement
	:	OPEN dynamic_cursor_name opt_nt_622
	;

dynamic_cursor_name
	:	cursor_name
	|	extended_cursor_name
	;

opt_nt_624
	:	/* Nothing */
	|	fetch_orientation
	;

opt_nt_623
	:	/* Nothing */
	|	opt_nt_624 FROM
	;

dynamic_fetch_statement
	:	FETCH opt_nt_623 dynamic_cursor_name output_using_clause
	;

dynamic_close_statement
	:	CLOSE dynamic_cursor_name
	;

dynamic_delete_statement_positioned
	:	DELETE FROM target_table WHERE CURRENT OF dynamic_cursor_name
	;

dynamic_update_statement_positioned
	:	UPDATE target_table SET set_clause_list WHERE CURRENT OF dynamic_cursor_name
	;

double_period
	:	period period
	;

direct_sql_statement
	:	directly_executable_statement semicolon
	;

directly_executable_statement
	:	direct_sql_data_statement
	|	sql_schema_statement
	|	sql_transaction_statement
	|	sql_connection_statement
	|	sql_session_statement
	|	direct_implementation_defined_statement
	;

direct_sql_data_statement
	:	delete_statement_searched
	|	direct_select_statement_multiple_rows
	|	insert_statement
	|	update_statement_searched
	|	temporary_table_declaration
	;

opt_nt_625
	:	/* Nothing */
	|	order_by_clause ']'
	;

direct_select_statement_multiple_rows
	:	query_expression opt_nt_625
	;

set_catalog_statement
	:	SET catalog_name_characteristic
	;

catalog_name_characteristic
	:	CATALOG value_specification
	;

set_schema_statement
	:	SET schema_name_characteristic
	;

schema_name_characteristic
	:	SCHEMA value_specification
	;

set_names_statement
	:	SET character_set_name_characteristic
	;

character_set_name_characteristic
	:	NAMES value_specification
	;

set_path_statement
	:	SET sql_path_characteristic
	;

sql_path_characteristic
	:	PATH value_specification
	;

set_transform_group_statement
	:	SET transform_group_characteristic
	;

transform_group_characteristic
	:	DEFAULT TRANSFORM GROUP value_specification
	|	TRANSFORM GROUP FOR TYPE user_defined_type value_specification
	;

direct_implementation_defined_statement
	:	/* !! (See the Syntax Rules) */
	;

opt_nt_626
	:	/* Nothing */
	|	embedded_character_set_declaration
	;

lst_nt_628
	:	host_variable_definition
	|	lst_nt_628 host_variable_definition
	;

opt_nt_627
	:	/* Nothing */
	|	lst_nt_628
	;

embedded_sql_declare_section
	:	embedded_sql_begin_declare opt_nt_626 opt_nt_627 embedded_sql_end_declare
	|	embedded_sql_mumps_declare
	;

opt_nt_629
	:	/* Nothing */
	|	sql_terminator ']'
	;

embedded_sql_begin_declare
	:	sql_prefix BEGIN DECLARE SECTION opt_nt_629
	;

sql_prefix
	:	EXEC SQL
	|	ampersand SQL left_paren
	;

sql_terminator
	:	END-EXEC
	|	semicolon
	|	right_paren
	;

embedded_character_set_declaration
	:	SQL NAMES ARE character_set_specification
	;

host_variable_definition
	:	ada_variable_definition
	|	c_variable_definition
	|	cobol_variable_definition
	|	fortran_variable_definition
	|	mumps_variable_definition
	|	pascal_variable_definition
	|	pl_i_variable_definition
	;

seq_nt_631
	:	comma ada_host_identifier
	;

lst_nt_632
	:	seq_nt_631
	|	lst_nt_632 seq_nt_631
	;

opt_nt_630
	:	/* Nothing */
	|	lst_nt_632
	;

opt_nt_633
	:	/* Nothing */
	|	ada_initial_value ']'
	;

ada_variable_definition
	:	ada_host_identifier opt_nt_630 colon ada_type_specification opt_nt_633
	;

ada_type_specification
	:	ada_qualified_type_specification
	|	ada_unqualified_type_specification
	|	ada_derived_type_specification
	;

opt_nt_635
	:	/* Nothing */
	|	IS
	;

opt_nt_634
	:	/* Nothing */
	|	CHARACTER SET opt_nt_635 character_set_specification
	;

ada_qualified_type_specification
	:	Interfaces.SQL period CHAR opt_nt_634 left_paren 1 double_period length right_paren
	|	Interfaces.SQL period BIT left_paren 1 double_period length right_paren
	|	Interfaces.SQL period SMALLINT
	|	Interfaces.SQL period INT
	|	Interfaces.SQL period REAL
	|	Interfaces.SQL period DOUBLE_PRECISION
	|	Interfaces.SQL period BOOLEAN
	|	Interfaces.SQL period SQLSTATE_TYPE
	|	Interfaces.SQL period INDICATOR_TYPE
	;

ada_unqualified_type_specification
	:	CHAR left_paren 1 double_period length right_paren
	|	BIT left_paren 1 double_period length right_paren
	|	SMALLINT
	|	INT
	|	REAL
	|	DOUBLE_PRECISION
	|	BOOLEAN
	|	SQLSTATE_TYPE
	|	INDICATOR_TYPE
	;

ada_derived_type_specification
	:	ada_clob_variable
	|	ada_blob_variable
	|	ada_user_defined_type_variable
	|	ada_clob_locator_variable
	|	ada_blob_locator_variable
	|	ada_user_defined_type_locator_variable
	|	ada_array_locator_variable
	|	ada_ref_variable
	;

opt_nt_637
	:	/* Nothing */
	|	IS
	;

opt_nt_636
	:	/* Nothing */
	|	CHARACTER SET opt_nt_637 character_set_specification ']'
	;

ada_clob_variable
	:	SQL TYPE IS CLOB left_paren large_object_length right_paren opt_nt_636
	;

ada_blob_variable
	:	SQL TYPE IS BLOB left_paren large_object_length right_paren
	;

ada_user_defined_type_variable
	:	SQL TYPE IS user_defined_type AS predefined_type
	;

ada_clob_locator_variable
	:	SQL TYPE IS CLOB AS LOCATOR
	;

ada_blob_locator_variable
	:	SQL TYPE IS BLOB AS LOCATOR
	;

ada_user_defined_type_locator_variable
	:	SQL TYPE IS user_defined_type_name AS LOCATOR
	;

ada_array_locator_variable
	:	SQL TYPE IS collection_type AS LOCATOR
	;

ada_ref_variable
	:	SQL TYPE IS reference_type
	;

lst_nt_638
	:	character_representation
	|	lst_nt_638 character_representation
	;

ada_initial_value
	:	ada_assignment_operator lst_nt_638
	;

ada_assignment_operator
	:	colon equals_operator
	;

opt_nt_639
	:	/* Nothing */
	|	c_storage_class
	;

opt_nt_640
	:	/* Nothing */
	|	c_class_modifier
	;

c_variable_definition
	:	opt_nt_639 opt_nt_640 c_variable_specification semicolon
	;

c_storage_class
	:	auto
	|	extern
	|	static
	;

c_class_modifier
	:	const
	|	volatile
	;

c_variable_specification
	:	c_numeric_variable
	|	c_character_variable
	|	c_derived_variable
	;

seq_nt_641
	:	long
	|	short
	|	float
	|	double
	;

opt_nt_642
	:	/* Nothing */
	|	c_initial_value
	;

opt_nt_645
	:	/* Nothing */
	|	c_initial_value
	;

seq_nt_644
	:	comma c_host_identifier opt_nt_645
	;

lst_nt_646
	:	seq_nt_644
	|	lst_nt_646 seq_nt_644
	;

opt_nt_643
	:	/* Nothing */
	|	lst_nt_646 ']'
	;

c_numeric_variable
	:	seq_nt_641 c_host_identifier opt_nt_642 opt_nt_643
	;

lst_nt_647
	:	character_representation
	|	lst_nt_647 character_representation
	;

c_initial_value
	:	equals_operator lst_nt_647
	;

opt_nt_649
	:	/* Nothing */
	|	IS
	;

opt_nt_648
	:	/* Nothing */
	|	CHARACTER SET opt_nt_649 character_set_specification
	;

opt_nt_650
	:	/* Nothing */
	|	c_initial_value
	;

opt_nt_653
	:	/* Nothing */
	|	c_initial_value
	;

seq_nt_652
	:	comma c_host_identifier c_array_specification opt_nt_653
	;

lst_nt_654
	:	seq_nt_652
	|	lst_nt_654 seq_nt_652
	;

opt_nt_651
	:	/* Nothing */
	|	lst_nt_654 ']'
	;

c_character_variable
	:	c_character_type opt_nt_648 c_host_identifier c_array_specification opt_nt_650 opt_nt_651
	;

c_character_type
	:	char
	|	unsigned char
	|	unsigned short
	;

c_array_specification
	:	left_bracket length right_bracket
	;

c_derived_variable
	:	c_varchar_variable
	|	c_nchar_variable
	|	c_nchar_varying_variable
	|	c_clob_variable
	|	c_nclob_variable
	|	c_blob_variable
	|	c_bit_variable
	|	c_user_defined_type_variable
	|	c_clob_locator_variable
	|	c_blob_locator_variable
	|	c_array_locator_variable
	|	c_user_defined_type_locator_variable
	|	c_ref_variable
	;

opt_nt_656
	:	/* Nothing */
	|	IS
	;

opt_nt_655
	:	/* Nothing */
	|	CHARACTER SET opt_nt_656 character_set_specification
	;

opt_nt_657
	:	/* Nothing */
	|	c_initial_value
	;

opt_nt_660
	:	/* Nothing */
	|	c_initial_value
	;

seq_nt_659
	:	comma c_host_identifier c_array_specification opt_nt_660
	;

lst_nt_661
	:	seq_nt_659
	|	lst_nt_661 seq_nt_659
	;

opt_nt_658
	:	/* Nothing */
	|	lst_nt_661 ']'
	;

c_varchar_variable
	:	VARCHAR opt_nt_655 c_host_identifier c_array_specification opt_nt_657 opt_nt_658
	;

opt_nt_663
	:	/* Nothing */
	|	IS
	;

opt_nt_662
	:	/* Nothing */
	|	CHARACTER SET opt_nt_663 character_set_specification
	;

opt_nt_664
	:	/* Nothing */
	|	c_initial_value
	;

opt_nt_667
	:	/* Nothing */
	|	c_initial_value
	;

seq_nt_666
	:	comma c_host_identifier c_array_specification opt_nt_667
	;

lst_nt_668
	:	seq_nt_666
	|	lst_nt_668 seq_nt_666
	;

opt_nt_665
	:	/* Nothing */
	|	lst_nt_668 ']'
	;

c_nchar_variable
	:	NCHAR opt_nt_662 c_host_identifier c_array_specification opt_nt_664 opt_nt_665
	;

opt_nt_670
	:	/* Nothing */
	|	IS
	;

opt_nt_669
	:	/* Nothing */
	|	CHARACTER SET opt_nt_670 character_set_specification
	;

opt_nt_671
	:	/* Nothing */
	|	c_initial_value
	;

opt_nt_674
	:	/* Nothing */
	|	c_initial_value
	;

seq_nt_673
	:	comma c_host_identifier c_array_specification opt_nt_674
	;

lst_nt_675
	:	seq_nt_673
	|	lst_nt_675 seq_nt_673
	;

opt_nt_672
	:	/* Nothing */
	|	lst_nt_675 ']'
	;

c_nchar_varying_variable
	:	NCHAR VARYING opt_nt_669 c_host_identifier c_array_specification opt_nt_671 opt_nt_672
	;

opt_nt_677
	:	/* Nothing */
	|	IS
	;

opt_nt_676
	:	/* Nothing */
	|	CHARACTER SET opt_nt_677 character_set_specification
	;

opt_nt_678
	:	/* Nothing */
	|	c_initial_value
	;

opt_nt_681
	:	/* Nothing */
	|	c_initial_value
	;

seq_nt_680
	:	comma c_host_identifier opt_nt_681
	;

lst_nt_682
	:	seq_nt_680
	|	lst_nt_682 seq_nt_680
	;

opt_nt_679
	:	/* Nothing */
	|	lst_nt_682 ']'
	;

c_clob_variable
	:	SQL TYPE IS CLOB left_paren large_object_length right_paren opt_nt_676 c_host_identifier opt_nt_678 opt_nt_679
	;

opt_nt_684
	:	/* Nothing */
	|	IS
	;

opt_nt_683
	:	/* Nothing */
	|	CHARACTER SET opt_nt_684 character_set_specification
	;

opt_nt_685
	:	/* Nothing */
	|	c_initial_value
	;

opt_nt_688
	:	/* Nothing */
	|	c_initial_value
	;

seq_nt_687
	:	comma c_host_identifier opt_nt_688
	;

lst_nt_689
	:	seq_nt_687
	|	lst_nt_689 seq_nt_687
	;

opt_nt_686
	:	/* Nothing */
	|	lst_nt_689 ']'
	;

c_nclob_variable
	:	SQL TYPE IS NCLOB left_paren large_object_length right_paren opt_nt_683 c_host_identifier opt_nt_685 opt_nt_686
	;

opt_nt_690
	:	/* Nothing */
	|	c_initial_value
	;

opt_nt_693
	:	/* Nothing */
	|	c_initial_value
	;

seq_nt_692
	:	comma c_host_identifier opt_nt_693
	;

lst_nt_694
	:	seq_nt_692
	|	lst_nt_694 seq_nt_692
	;

opt_nt_691
	:	/* Nothing */
	|	lst_nt_694 ']'
	;

c_blob_variable
	:	SQL TYPE IS BLOB left_paren large_object_length right_paren c_host_identifier opt_nt_690 opt_nt_691
	;

opt_nt_695
	:	/* Nothing */
	|	c_initial_value
	;

opt_nt_698
	:	/* Nothing */
	|	c_initial_value
	;

seq_nt_697
	:	comma c_host_identifier c_array_specification opt_nt_698
	;

lst_nt_699
	:	seq_nt_697
	|	lst_nt_699 seq_nt_697
	;

opt_nt_696
	:	/* Nothing */
	|	lst_nt_699 ']'
	;

c_bit_variable
	:	BIT c_host_identifier c_array_specification opt_nt_695 opt_nt_696
	;

opt_nt_700
	:	/* Nothing */
	|	c_initial_value
	;

opt_nt_703
	:	/* Nothing */
	|	c_initial_value
	;

seq_nt_702
	:	comma c_host_identifier opt_nt_703
	;

lst_nt_704
	:	seq_nt_702
	|	lst_nt_704 seq_nt_702
	;

opt_nt_701
	:	/* Nothing */
	|	lst_nt_704 ']'
	;

c_user_defined_type_variable
	:	SQL TYPE IS user_defined_type AS predefined_type c_host_identifier opt_nt_700 opt_nt_701
	;

opt_nt_705
	:	/* Nothing */
	|	c_initial_value
	;

opt_nt_708
	:	/* Nothing */
	|	c_initial_value
	;

seq_nt_707
	:	comma c_host_identifier opt_nt_708
	;

lst_nt_709
	:	seq_nt_707
	|	lst_nt_709 seq_nt_707
	;

opt_nt_706
	:	/* Nothing */
	|	lst_nt_709 ']'
	;

c_clob_locator_variable
	:	SQL TYPE IS CLOB AS LOCATOR c_host_identifier opt_nt_705 opt_nt_706
	;

opt_nt_710
	:	/* Nothing */
	|	c_initial_value
	;

opt_nt_713
	:	/* Nothing */
	|	c_initial_value
	;

seq_nt_712
	:	comma c_host_identifier opt_nt_713
	;

lst_nt_714
	:	seq_nt_712
	|	lst_nt_714 seq_nt_712
	;

opt_nt_711
	:	/* Nothing */
	|	lst_nt_714 ']'
	;

c_blob_locator_variable
	:	SQL TYPE IS BLOB AS LOCATOR c_host_identifier opt_nt_710 opt_nt_711
	;

opt_nt_715
	:	/* Nothing */
	|	c_initial_value
	;

opt_nt_718
	:	/* Nothing */
	|	c_initial_value
	;

seq_nt_717
	:	comma c_host_identifier opt_nt_718
	;

lst_nt_719
	:	seq_nt_717
	|	lst_nt_719 seq_nt_717
	;

opt_nt_716
	:	/* Nothing */
	|	lst_nt_719 ']'
	;

c_array_locator_variable
	:	SQL TYPE IS collection_type AS LOCATOR c_host_identifier opt_nt_715 opt_nt_716
	;

opt_nt_720
	:	/* Nothing */
	|	c_initial_value
	;

opt_nt_723
	:	/* Nothing */
	|	c_initial_value
	;

seq_nt_722
	:	comma c_host_identifier opt_nt_723
	;

lst_nt_724
	:	seq_nt_722
	|	lst_nt_724 seq_nt_722
	;

opt_nt_721
	:	/* Nothing */
	|	lst_nt_724 ']'
	;

c_user_defined_type_locator_variable
	:	SQL TYPE IS user_defined_type AS LOCATOR c_host_identifier opt_nt_720 opt_nt_721
	;

c_ref_variable
	:	SQL TYPE IS reference_type
	;

seq_nt_725
	:	01
	|	77
	;

lst_nt_727
	:	character_representation
	|	lst_nt_727 character_representation
	;

opt_nt_726
	:	/* Nothing */
	|	lst_nt_727
	;

cobol_variable_definition
	:	seq_nt_725 cobol_host_identifier cobol_type_specification opt_nt_726 period
	;

cobol_type_specification
	:	cobol_character_type
	|	cobol_national_character_type
	|	cobol_bit_type
	|	cobol_numeric_type
	|	cobol_integer_type
	|	cobol_derived_type_specification
	;

opt_nt_729
	:	/* Nothing */
	|	IS
	;

opt_nt_728
	:	/* Nothing */
	|	CHARACTER SET opt_nt_729 character_set_specification
	;

seq_nt_730
	:	PIC
	|	PICTURE
	;

opt_nt_731
	:	/* Nothing */
	|	IS
	;

opt_nt_733
	:	/* Nothing */
	|	left_paren length right_paren
	;

seq_nt_732
	:	X opt_nt_733
	;

lst_nt_734
	:	seq_nt_732
	|	lst_nt_734 seq_nt_732
	;

cobol_character_type
	:	opt_nt_728 seq_nt_730 opt_nt_731 lst_nt_734
	;

opt_nt_736
	:	/* Nothing */
	|	IS
	;

opt_nt_735
	:	/* Nothing */
	|	CHARACTER SET opt_nt_736 character_set_specification
	;

seq_nt_737
	:	PIC
	|	PICTURE
	;

opt_nt_738
	:	/* Nothing */
	|	IS
	;

opt_nt_740
	:	/* Nothing */
	|	left_paren length right_paren
	;

seq_nt_739
	:	N opt_nt_740
	;

lst_nt_741
	:	seq_nt_739
	|	lst_nt_741 seq_nt_739
	;

cobol_national_character_type
	:	opt_nt_735 seq_nt_737 opt_nt_738 lst_nt_741
	;

seq_nt_742
	:	PIC
	|	PICTURE
	;

opt_nt_743
	:	/* Nothing */
	|	IS
	;

opt_nt_745
	:	/* Nothing */
	|	left_paren length right_paren
	;

seq_nt_744
	:	X opt_nt_745
	;

lst_nt_746
	:	seq_nt_744
	|	lst_nt_746 seq_nt_744
	;

opt_nt_747
	:	/* Nothing */
	|	IS
	;

cobol_bit_type
	:	seq_nt_742 opt_nt_743 lst_nt_746 USAGE opt_nt_747 BIT
	;

seq_nt_748
	:	PIC
	|	PICTURE
	;

opt_nt_749
	:	/* Nothing */
	|	IS
	;

opt_nt_751
	:	/* Nothing */
	|	IS
	;

opt_nt_750
	:	/* Nothing */
	|	USAGE opt_nt_751
	;

cobol_numeric_type
	:	seq_nt_748 opt_nt_749 S cobol_nines_specification opt_nt_750 DISPLAY SIGN LEADING SEPARATE
	;

opt_nt_753
	:	/* Nothing */
	|	cobol_nines
	;

opt_nt_752
	:	/* Nothing */
	|	V opt_nt_753
	;

cobol_nines_specification
	:	cobol_nines opt_nt_752
	|	V cobol_nines
	;

opt_nt_755
	:	/* Nothing */
	|	left_paren length right_paren
	;

seq_nt_754
	:	9 opt_nt_755
	;

lst_nt_756
	:	seq_nt_754
	|	lst_nt_756 seq_nt_754
	;

cobol_nines
	:	lst_nt_756
	;

cobol_integer_type
	:	cobol_binary_integer
	;

seq_nt_757
	:	PIC
	|	PICTURE
	;

opt_nt_758
	:	/* Nothing */
	|	IS
	;

opt_nt_760
	:	/* Nothing */
	|	IS
	;

opt_nt_759
	:	/* Nothing */
	|	USAGE opt_nt_760
	;

cobol_binary_integer
	:	seq_nt_757 opt_nt_758 S cobol_nines opt_nt_759 BINARY
	;

cobol_derived_type_specification
	:	cobol_clob_variable
	|	cobol_nclob_variable
	|	cobol_blob_variable
	|	cobol_user_defined_type_variable
	|	cobol_clob_locator_variable
	|	cobol_blob_locator_variable
	|	cobol_array_locator_variable
	|	cobol_user_defined_type_locator_variable
	|	cobol_ref_variable
	;

opt_nt_762
	:	/* Nothing */
	|	IS
	;

opt_nt_761
	:	/* Nothing */
	|	USAGE opt_nt_762
	;

opt_nt_764
	:	/* Nothing */
	|	IS
	;

opt_nt_763
	:	/* Nothing */
	|	CHARACTER SET opt_nt_764 character_set_specification ']'
	;

cobol_clob_variable
	:	opt_nt_761 SQL TYPE IS CLOB left_paren large_object_length right_paren opt_nt_763
	;

opt_nt_766
	:	/* Nothing */
	|	IS
	;

opt_nt_765
	:	/* Nothing */
	|	USAGE opt_nt_766
	;

opt_nt_768
	:	/* Nothing */
	|	IS
	;

opt_nt_767
	:	/* Nothing */
	|	CHARACTER SET opt_nt_768 character_set_specification ']'
	;

cobol_nclob_variable
	:	opt_nt_765 SQL TYPE IS NCLOB left_paren large_object_length right_paren opt_nt_767
	;

opt_nt_770
	:	/* Nothing */
	|	IS
	;

opt_nt_769
	:	/* Nothing */
	|	USAGE opt_nt_770
	;

cobol_blob_variable
	:	opt_nt_769 SQL TYPE IS BLOB left_paren large_object_length right_paren
	;

opt_nt_772
	:	/* Nothing */
	|	IS
	;

opt_nt_771
	:	/* Nothing */
	|	USAGE opt_nt_772
	;

cobol_user_defined_type_variable
	:	opt_nt_771 SQL TYPE IS user_defined_type AS predefined_type
	;

opt_nt_774
	:	/* Nothing */
	|	IS
	;

opt_nt_773
	:	/* Nothing */
	|	USAGE opt_nt_774
	;

cobol_clob_locator_variable
	:	opt_nt_773 SQL TYPE IS CLOB AS LOCATOR
	;

opt_nt_776
	:	/* Nothing */
	|	IS
	;

opt_nt_775
	:	/* Nothing */
	|	USAGE opt_nt_776
	;

cobol_blob_locator_variable
	:	opt_nt_775 SQL TYPE IS BLOB AS LOCATOR
	;

opt_nt_778
	:	/* Nothing */
	|	IS
	;

opt_nt_777
	:	/* Nothing */
	|	USAGE opt_nt_778
	;

cobol_array_locator_variable
	:	opt_nt_777 SQL TYPE IS collection_type AS LOCATOR
	;

opt_nt_780
	:	/* Nothing */
	|	IS
	;

opt_nt_779
	:	/* Nothing */
	|	USAGE opt_nt_780
	;

cobol_user_defined_type_locator_variable
	:	opt_nt_779 SQL TYPE IS user_defined_type_name AS LOCATOR
	;

opt_nt_782
	:	/* Nothing */
	|	IS
	;

opt_nt_781
	:	/* Nothing */
	|	USAGE opt_nt_782
	;

cobol_ref_variable
	:	opt_nt_781 SQL TYPE IS reference_type
	;

seq_nt_784
	:	comma fortran_host_identifier
	;

lst_nt_785
	:	seq_nt_784
	|	lst_nt_785 seq_nt_784
	;

opt_nt_783
	:	/* Nothing */
	|	lst_nt_785 ']'
	;

fortran_variable_definition
	:	fortran_type_specification fortran_host_identifier opt_nt_783
	;

opt_nt_786
	:	/* Nothing */
	|	asterisk length
	;

opt_nt_788
	:	/* Nothing */
	|	IS
	;

opt_nt_787
	:	/* Nothing */
	|	CHARACTER SET opt_nt_788 character_set_specification
	;

opt_nt_789
	:	/* Nothing */
	|	asterisk length
	;

opt_nt_791
	:	/* Nothing */
	|	IS
	;

opt_nt_790
	:	/* Nothing */
	|	CHARACTER SET opt_nt_791 character_set_specification
	;

opt_nt_792
	:	/* Nothing */
	|	asterisk length
	;

fortran_type_specification
	:	CHARACTER opt_nt_786 opt_nt_787
	|	CHARACTER KIND equals_operator unsigned_integer opt_nt_789 opt_nt_790
	|	BIT opt_nt_792
	|	INTEGER
	|	REAL
	|	DOUBLE PRECISION
	|	LOGICAL
	|	fortran_derived_type_specification
	;

fortran_derived_type_specification
	:	fortran_clob_variable
	|	fortran_blob_variable
	|	fortran_user_defined_type_variable
	|	fortran_clob_locator_variable
	|	fortran_blob_locator_variable
	|	fortran_user_defined_type_locator_variable
	|	fortran_array_locator_variable
	|	fortran_ref_variable
	;

opt_nt_794
	:	/* Nothing */
	|	IS
	;

opt_nt_793
	:	/* Nothing */
	|	CHARACTER SET opt_nt_794 character_set_specification ']'
	;

fortran_clob_variable
	:	SQL TYPE IS CLOB left_paren large_object_length right_paren opt_nt_793
	;

fortran_blob_variable
	:	SQL TYPE IS BLOB left_paren large_object_length right_paren
	;

fortran_user_defined_type_variable
	:	SQL TYPE IS user_defined_type AS predefined_type
	;

fortran_clob_locator_variable
	:	SQL TYPE IS CLOB AS LOCATOR
	;

fortran_blob_locator_variable
	:	SQL TYPE IS BLOB AS LOCATOR
	;

fortran_user_defined_type_locator_variable
	:	SQL TYPE IS user_defined_type_name AS LOCATOR
	;

fortran_array_locator_variable
	:	SQL TYPE IS collection_type AS LOCATOR
	;

fortran_ref_variable
	:	SQL TYPE IS reference_type
	;

mumps_variable_definition
	:	mumps_numeric_variable semicolon
	|	mumps_character_variable semicolon
	|	mumps_derived_type_specification semicolon
	;

seq_nt_796
	:	comma mumps_host_identifier
	;

lst_nt_797
	:	seq_nt_796
	|	lst_nt_797 seq_nt_796
	;

opt_nt_795
	:	/* Nothing */
	|	lst_nt_797 ']'
	;

mumps_numeric_variable
	:	mumps_type_specification mumps_host_identifier opt_nt_795
	;

opt_nt_799
	:	/* Nothing */
	|	comma scale
	;

opt_nt_798
	:	/* Nothing */
	|	left_paren precision opt_nt_799 right_paren
	;

mumps_type_specification
	:	INT
	|	DEC opt_nt_798
	|	REAL
	;

seq_nt_801
	:	comma mumps_host_identifier mumps_length_specification
	;

lst_nt_802
	:	seq_nt_801
	|	lst_nt_802 seq_nt_801
	;

opt_nt_800
	:	/* Nothing */
	|	lst_nt_802 ']'
	;

mumps_character_variable
	:	VARCHAR mumps_host_identifier mumps_length_specification opt_nt_800
	;

mumps_length_specification
	:	left_paren length right_paren
	;

mumps_derived_type_specification
	:	mumps_clob_variable
	|	mumps_blob_variable
	|	mumps_user_defined_type_variable
	|	mumps_clob_locator_variable
	|	mumps_blob_locator_variable
	|	mumps_user_defined_type_locator_variable
	|	mumps_array_locator_variable
	|	mumps_ref_variable
	;

opt_nt_804
	:	/* Nothing */
	|	IS
	;

opt_nt_803
	:	/* Nothing */
	|	CHARACTER SET opt_nt_804 character_set_specification ']'
	;

mumps_clob_variable
	:	SQL TYPE IS CLOB left_paren large_object_length right_paren opt_nt_803
	;

mumps_blob_variable
	:	SQL TYPE IS BLOB left_paren large_object_length right_paren
	;

mumps_user_defined_type_variable
	:	SQL TYPE IS user_defined_type AS predefined_type
	;

mumps_clob_locator_variable
	:	SQL TYPE IS CLOB AS LOCATOR
	;

mumps_blob_locator_variable
	:	SQL TYPE IS BLOB AS LOCATOR
	;

mumps_user_defined_type_locator_variable
	:	SQL TYPE IS user_defined_type_name AS LOCATOR
	;

mumps_array_locator_variable
	:	SQL TYPE IS collection_type AS LOCATOR
	;

mumps_ref_variable
	:	SQL TYPE IS reference_type
	;

seq_nt_806
	:	comma pascal_host_identifier
	;

lst_nt_807
	:	seq_nt_806
	|	lst_nt_807 seq_nt_806
	;

opt_nt_805
	:	/* Nothing */
	|	lst_nt_807
	;

pascal_variable_definition
	:	pascal_host_identifier opt_nt_805 colon pascal_type_specification semicolon
	;

opt_nt_809
	:	/* Nothing */
	|	IS
	;

opt_nt_808
	:	/* Nothing */
	|	CHARACTER SET opt_nt_809 character_set_specification
	;

opt_nt_811
	:	/* Nothing */
	|	IS
	;

opt_nt_810
	:	/* Nothing */
	|	CHARACTER SET opt_nt_811 character_set_specification
	;

pascal_type_specification
	:	PACKED ARRAY left_bracket 1 double_period length right_bracket OF CHAR opt_nt_808
	|	PACKED ARRAY left_bracket 1 double_period length right_bracket OF BIT
	|	INTEGER
	|	REAL
	|	CHAR opt_nt_810
	|	BIT
	|	BOOLEAN
	|	pascal_derived_type_specification
	;

pascal_derived_type_specification
	:	pascal_clob_variable
	|	pascal_blob_variable
	|	pascal_user_defined_type_variable
	|	pascal_clob_locator_variable
	|	pascal_blob_locator_variable
	|	pascal_user_defined_type_locator_variable
	|	pascal_array_locator_variable
	|	pascal_ref_variable
	;

opt_nt_813
	:	/* Nothing */
	|	IS
	;

opt_nt_812
	:	/* Nothing */
	|	CHARACTER SET opt_nt_813 character_set_specification ']'
	;

pascal_clob_variable
	:	SQL TYPE IS CLOB left_paren large_object_length right_paren opt_nt_812
	;

pascal_blob_variable
	:	SQL TYPE IS BLOB left_paren large_object_length right_paren
	;

pascal_user_defined_type_variable
	:	SQL TYPE IS user_defined_type AS predefined_type
	;

pascal_clob_locator_variable
	:	SQL TYPE IS CLOB AS LOCATOR
	;

pascal_blob_locator_variable
	:	SQL TYPE IS BLOB AS LOCATOR
	;

pascal_user_defined_type_locator_variable
	:	SQL TYPE IS user_defined_type_name AS LOCATOR
	;

pascal_array_locator_variable
	:	SQL TYPE IS collection_type AS LOCATOR
	;

pascal_ref_variable
	:	SQL TYPE IS reference_type
	;

seq_nt_814
	:	DCL
	|	DECLARE
	;

seq_nt_817
	:	comma pl_i_host_identifier
	;

lst_nt_818
	:	seq_nt_817
	|	lst_nt_818 seq_nt_817
	;

opt_nt_816
	:	/* Nothing */
	|	lst_nt_818
	;

seq_nt_815
	:	pl_i_host_identifier
	|	left_paren pl_i_host_identifier opt_nt_816 right_paren
	;

lst_nt_820
	:	character_representation
	|	lst_nt_820 character_representation
	;

opt_nt_819
	:	/* Nothing */
	|	lst_nt_820
	;

pl_i_variable_definition
	:	seq_nt_814 seq_nt_815 pl_i_type_specification opt_nt_819 semicolon
	;

seq_nt_821
	:	CHAR
	|	CHARACTER
	;

opt_nt_822
	:	/* Nothing */
	|	VARYING
	;

opt_nt_824
	:	/* Nothing */
	|	IS
	;

opt_nt_823
	:	/* Nothing */
	|	CHARACTER SET opt_nt_824 character_set_specification
	;

opt_nt_825
	:	/* Nothing */
	|	VARYING
	;

opt_nt_826
	:	/* Nothing */
	|	comma scale
	;

opt_nt_827
	:	/* Nothing */
	|	left_paren precision right_paren
	;

pl_i_type_specification
	:	seq_nt_821 opt_nt_822 left_paren length right_paren opt_nt_823
	|	BIT opt_nt_825 left_paren length right_paren
	|	pl_i_type_fixed_decimal left_paren precision opt_nt_826 right_paren
	|	pl_i_type_fixed_binary opt_nt_827
	|	pl_i_type_float_binary left_paren precision right_paren
	|	pl_i_derived_type_specification
	;

seq_nt_828
	:	DEC
	|	DECIMAL
	;

seq_nt_829
	:	DEC
	|	DECIMAL '}'
	;

pl_i_type_fixed_decimal
	:	seq_nt_828 FIXED
	|	FIXED seq_nt_829
	;

seq_nt_830
	:	BIN
	|	BINARY
	;

seq_nt_831
	:	BIN
	|	BINARY '}'
	;

pl_i_type_fixed_binary
	:	seq_nt_830 FIXED
	|	FIXED seq_nt_831
	;

seq_nt_832
	:	BIN
	|	BINARY
	;

seq_nt_833
	:	BIN
	|	BINARY '}'
	;

pl_i_type_float_binary
	:	seq_nt_832 FLOAT
	|	FLOAT seq_nt_833
	;

pl_i_derived_type_specification
	:	pl_i_clob_variable
	|	pl_i_blob_variable
	|	pl_i_user_defined_type_variable
	|	pl_i_clob_locator_variable
	|	pl_i_blob_locator_variable
	|	pl_i_user_defined_type_locator_variable
	|	pl_i_array_locator_variable
	|	pl_i_ref_variable
	;

opt_nt_835
	:	/* Nothing */
	|	IS
	;

opt_nt_834
	:	/* Nothing */
	|	CHARACTER SET opt_nt_835 character_set_specification ']'
	;

pl_i_clob_variable
	:	SQL TYPE IS CLOB left_paren large_object_length right_paren opt_nt_834
	;

pl_i_blob_variable
	:	SQL TYPE IS BLOB left_paren large_object_length right_paren
	;

pl_i_user_defined_type_variable
	:	SQL TYPE IS user_defined_type AS predefined_type
	;

pl_i_clob_locator_variable
	:	SQL TYPE IS CLOB AS LOCATOR
	;

pl_i_blob_locator_variable
	:	SQL TYPE IS BLOB AS LOCATOR
	;

pl_i_user_defined_type_locator_variable
	:	SQL TYPE IS user_defined_type_name AS LOCATOR
	;

pl_i_array_locator_variable
	:	SQL TYPE IS collection_type AS LOCATOR
	;

pl_i_ref_variable
	:	SQL TYPE IS reference_type
	;

opt_nt_836
	:	/* Nothing */
	|	sql_terminator ']'
	;

embedded_sql_end_declare
	:	sql_prefix END DECLARE SECTION opt_nt_836
	;

opt_nt_837
	:	/* Nothing */
	|	embedded_character_set_declaration
	;

lst_nt_839
	:	host_variable_definition
	|	lst_nt_839 host_variable_definition
	;

opt_nt_838
	:	/* Nothing */
	|	lst_nt_839
	;

embedded_sql_mumps_declare
	:	sql_prefix BEGIN DECLARE SECTION opt_nt_837 opt_nt_838 END DECLARE SECTION sql_terminator
	;

embedded_sql_host_program
	:	embedded_sql_ada_program
	|	embedded_sql_c_program
	|	embedded_sql_cobol_program
	|	embedded_sql_fortran_program
	|	embedded_sql_mumps_program
	|	embedded_sql_pascal_program
	|	embedded_sql_pl_i_program
	;

embedded_sql_ada_program
	:	/* !! (See the Syntax Rules.) */
	;

embedded_sql_c_program
	:	/* !! (See the Syntax Rules.) */
	;

embedded_sql_cobol_program
	:	/* !! (See the Syntax Rules.) */
	;

embedded_sql_fortran_program
	:	/* !! (See the Syntax Rules.) */
	;

embedded_sql_mumps_program
	:	/* !! (See the Syntax Rules.) */
	;

embedded_sql_pascal_program
	:	/* !! (See the Syntax Rules.) */
	;

embedded_sql_pl_i_program
	:	/* !! (See the Syntax Rules.) */
	;

opt_nt_840
	:	/* Nothing */
	|	sql_terminator ']'
	;

embedded_sql_statement
	:	sql_prefix statement_or_declaration opt_nt_840
	;

statement_or_declaration
	:	declare_cursor
	|	dynamic_declare_cursor
	|	temporary_table_declaration
	|	embedded_authorization_declaration
	|	embedded_path_specification
	|	embedded_transform_group_specification
	|	embedded_exception_declaration
	|	handler_declaration
	|	sql_invoked_routine
	|	sql_procedure_statement
	;

opt_nt_841
	:	/* Nothing */
	|	cursor_sensitivity
	;

opt_nt_842
	:	/* Nothing */
	|	cursor_scrollability
	;

opt_nt_843
	:	/* Nothing */
	|	cursor_holdability
	;

opt_nt_844
	:	/* Nothing */
	|	cursor_returnability
	;

dynamic_declare_cursor
	:	DECLARE cursor_name opt_nt_841 opt_nt_842 CURSOR opt_nt_843 opt_nt_844 FOR statement_name
	;

embedded_authorization_declaration
	:	DECLARE embedded_authorization_clause
	;

seq_nt_846
	:	ONLY
	|	AND DYNAMIC
	;

opt_nt_845
	:	/* Nothing */
	|	FOR STATIC seq_nt_846
	;

seq_nt_848
	:	ONLY
	|	AND DYNAMIC
	;

opt_nt_847
	:	/* Nothing */
	|	FOR STATIC seq_nt_848 ']'
	;

embedded_authorization_clause
	:	SCHEMA schema_name
	|	AUTHORIZATION embedded_authorization_identifier opt_nt_845
	|	SCHEMA schema_name AUTHORIZATION embedded_authorization_identifier opt_nt_847
	;

embedded_authorization_identifier
	:	module_authorization_identifier
	;

embedded_path_specification
	:	path_specification
	;

embedded_transform_group_specification
	:	transform_group_specification
	;

embedded_exception_declaration
	:	WHENEVER condition condition_action
	;

condition
	:	sql_condition
	;

opt_nt_849
	:	/* Nothing */
	|	comma sqlstate_subclass_value
	;

sql_condition
	:	major_category
	|	SQLSTATE left_paren sqlstate_class_value opt_nt_849 right_paren
	|	CONSTRAINT constraint_name
	;

major_category
	:	SQLEXCEPTION
	|	SQLWARNING
	|	NOT FOUND
	;

sqlstate_class_value
	:	sqlstate_char sqlstate_char /* !! (See the Syntax Rules.) */
	;

sqlstate_char
	:	simple_latin_upper_case_letter
	|	digit
	;

sqlstate_subclass_value
	:	sqlstate_char sqlstate_char sqlstate_char /* !! (See the Syntax Rules.) */
	;

condition_action
	:	CONTINUE
	|	go_to
	;

seq_nt_850
	:	GOTO
	|	GO TO
	;

go_to
	:	seq_nt_850 goto_target
	;

goto_target
	:	host_label_identifier
	|	unsigned_integer
	|	host_pl_i_label_variable
	;

host_label_identifier
	:	/* !! (See the Syntax Rules.) */
	;

host_pl_i_label_variable
	:	/* !! (See the Syntax Rules.) */
	;

opt_nt_851
	:	/* Nothing */
	|	interval_qualifier
	;

interval_primary
	:	value_expression_primary opt_nt_851
	|	interval_value_function
	;

seq_nt_853
	:	ONLY
	|	AND DYNAMIC
	;

opt_nt_852
	:	/* Nothing */
	|	FOR STATIC seq_nt_853
	;

seq_nt_855
	:	ONLY
	|	AND DYNAMIC
	;

opt_nt_854
	:	/* Nothing */
	|	FOR STATIC seq_nt_855 ']'
	;

module_authorization_clause
	:	SCHEMA schema_name
	|	AUTHORIZATION module_authorization_identifier opt_nt_852
	|	SCHEMA schema_name AUTHORIZATION module_authorization_identifier opt_nt_854
	;

preparable_statement
	:	preparable_sql_data_statement
	|	preparable_sql_schema_statement
	|	preparable_sql_transaction_statement
	|	preparable_sql_control_statement
	|	preparable_sql_session_statement
	|	preparable_implementation_defined_statement
	;

preparable_sql_data_statement
	:	delete_statement_searched
	|	dynamic_single_row_select_statement
	|	insert_statement
	|	dynamic_select_statement
	|	update_statement_searched
	|	preparable_dynamic_delete_statement_positioned
	|	preparable_dynamic_update_statement_positioned
	;

dynamic_single_row_select_statement
	:	query_specification
	;

dynamic_select_statement
	:	cursor_specification
	;

opt_nt_856
	:	/* Nothing */
	|	FROM target_table
	;

opt_nt_857
	:	/* Nothing */
	|	scope_option
	;

preparable_dynamic_delete_statement_positioned
	:	DELETE opt_nt_856 WHERE CURRENT OF opt_nt_857 cursor_name
	;

opt_nt_858
	:	/* Nothing */
	|	target_table
	;

opt_nt_859
	:	/* Nothing */
	|	scope_option
	;

preparable_dynamic_update_statement_positioned
	:	UPDATE opt_nt_858 SET set_clause_list WHERE CURRENT OF opt_nt_859 cursor_name
	;

preparable_sql_schema_statement
	:	sql_schema_statement
	;

preparable_sql_transaction_statement
	:	sql_transaction_statement
	;

preparable_sql_control_statement
	:	sql_control_statement
	;

preparable_sql_session_statement
	:	sql_session_statement
	;

preparable_implementation_defined_statement
	:	/* !! (See the Syntax Rules.) */
	;


%%

