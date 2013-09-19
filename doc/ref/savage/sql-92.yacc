/*
** Derived from file sql-92.bnf version 2.3 dated 2004/03/31 19:34:09
*/
/* Using Appendix G of "Understanding the New SQL: A Complete Guide" by J */
/* Melton and A R Simon (Morgan Kaufmann, 1993, ISBN 0-55860-245-3) as the */
/* source of the syntax, here is (most of) the BNF syntax for SQL-92.  The */
/* missing parts are the Cobol, Fortran, MUMPS, Pascal and PL/I variable */
/* definition rules. */
/* The plain text version of this grammar is */
/* --## <a href='sql-92.bnf'> sql-92.bnf </a>. */
/*  Key SQL Statements and Fragments */
/*  ALLOCATE CURSOR <allocate cursor statement> */
/*  ALTER DOMAIN <alter domain statement> */
/*  ALTER TABLE <alter table statement> */
/*  CLOSE cursor <close statement> <dynamic close statement> */
/*  Column definition <column definition> */
/*  COMMIT WORK <commit statement> */
/*  CONNECT <connect statement> */
/*  CREATE ASSERTION <assertion definition> */
/*  CREATE CHARACTER SET <character set definition> */
/*  CREATE COLLATION <collation definition> */
/*  CREATE DOMAIN <domain definition> */
/*  CREATE SCHEMA <schema definition> */
/*  CREATE TABLE <table definition> */
/*  CREATE TRANSLATION <translation definition> */
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
/*  FETCH cursor <fetch statement> <dynamic fetch statement> */
/*  GET DIAGNOSTICS <get diagnostics statement> */
/*  GRANT <grant statement> */
/*  INSERT <insert statement> */
/*  Literal <literal> */
/*  MODULE <module> */
/*  OPEN cursor <open statement> <dynamic open statement> */
/*  PREPARE <prepare statement> */
/*  Preparable statement <preparable statement> */
/*  REVOKE <revoke statement> */
/*  ROLLBACK WORK <rollback statement> */
/*  Search condition <search condition> */
/*  SELECT <query specification> */
/*  SET CATALOG <set catalog statement> */
/*  SET CONNECTION <set connection statement> */
/*  SET CONSTRAINTS <set constraints mode statement> */
/*  SET NAMES <set names statement> */
/*  SET SCHEMA <set schema statement> */
/*  SET SESSION AUTHORIZATION <set session authorization identifier statement> */
/*  SET TIME ZONE <set local time zone statement> */
/*  SET TRANSACTION <set transaction statement> */
/*  UPDATE <update statement: positioned> <update statement: searched> <dynamic update statement: positioned> */
/*  Value expression <value expression> */
/*  Basic Definitions of Characters Used, Tokens, Symbols, Etc. */
/*  Literal Numbers, Strings, Dates and Times */
/* UNK: <> */
/* UNK: >= */
/* UNK: <= */
/* UNK: .. */
/*  SQL Module */
/*  Data Types */
/* UNK: <precision <right paren> ]	|	REAL	|	DOUBLE PRECISION */
/*  Literals */
/*  Constraints */
/*  Search Condition */
/*  Queries */
/* Note that <correlation specification> does not appear in the ISO/IEC grammar. */
/* The notation is written out longhand several times, instead. */
/*  Query expression components */
/*  More about constraints */
/*  Module contents */
/*  SQL Procedures */
/*  SQL Schema Definition Statements */
/* UNK: > }... ] */
/* <grantee> := PUBLIC | <authorization identifier> */
/*  SQL Data Manipulation Statements */
/*  Connection Management */
/*  Session Attributes */
/*  Dynamic SQL */
/* UNK: :		<Ada type specification> [ <Ada initial value> ] */
/*  Identifying the version of SQL in use */
/*  END OF SQL-92 GRAMMAR */
%{
/*
** BNF Grammar for ISO/IEC 9075:1992 - Database Language SQL (SQL-92)
*/
%}

%token 0
%token 1
%token 2
%token 3
%token 4
%token 5
%token 6
%token 7
%token 8
%token 9
%token 9075
%token A
%token ABSOLUTE
%token ACTION
%token ADA
%token ADD
%token ALL
%token ALLOCATE
%token ALTER
%token AND
%token ANY
%token ARE
%token AS
%token ASC
%token ASSERTION
%token AT
%token AUTHORIZATION
%token AVG
%token B
%token BEGIN
%token BETWEEN
%token BIT
%token BIT_LENGTH
%token BOTH
%token BY
%token C
%token CASCADE
%token CASCADED
%token CASE
%token CAST
%token CATALOG
%token CATALOG_NAME
%token CHAR
%token CHARACTER
%token CHARACTER_LENGTH
%token CHARACTER_SET_CATALOG
%token CHARACTER_SET_NAME
%token CHARACTER_SET_SCHEMA
%token CHAR_LENGTH
%token CHECK
%token CLASS_ORIGIN
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
%token COMMIT
%token COMMITTED
%token CONDITION_NUMBER
%token CONNECT
%token CONNECTION
%token CONNECTION_NAME
%token CONSTRAINT
%token CONSTRAINTS
%token CONSTRAINT_CATALOG
%token CONSTRAINT_NAME
%token CONSTRAINT_SCHEMA
%token CONSTRATIN_CATALOG
%token CONTINUE
%token CONVERT
%token CORRESPONDING
%token COUNT
%token CREATE
%token CROSS
%token CURRENT
%token CURRENT_DATE
%token CURRENT_TIME
%token CURRENT_TIMESTAMP
%token CURRENT_USER
%token CURSOR
%token CURSOR_NAME
%token D
%token DATA
%token DATE
%token DATETIME_INTERVAL_CODE
%token DATETIME_INTERVAL_PRECISION
%token DAY
%token DEALLOCATE
%token DEC
%token DECIMAL
%token DECLARE
%token DEFAULT
%token DEFERRABLE
%token DEFERRED
%token DELETE
%token DESC
%token DESCRIBE
%token DESCRIPTOR
%token DIAGNOSTICS
%token DISCONNECT
%token DISTINCT
%token DOMAIN
%token DOUBLE
%token DOUBLE_PRECISION
%token DROP
%token DYNAMIC_FUNCTION
%token E
%token ELSE
%token END
%token END-EXEC
%token ESCAPE
%token EXCEPT
%token EXCEPTION
%token EXEC
%token EXECUTE
%token EXISTS
%token EXTERNAL
%token EXTRACT
%token F
%token FALSE
%token FETCH
%token FIRST
%token FLOAT
%token FOR
%token FOREIGN
%token FORTRAN
%token FOUND
%token FROM
%token FULL
%token G
%token GET
%token GLOBAL
%token GO
%token GOTO
%token GRANT
%token GROUP
%token H
%token HAVING
%token HOUR
%token High
%token I
%token IDENTITY
%token IMMEDIATE
%token IN
%token INDICATOR
%token INDICATOR_TYPE
%token INITIALLY
%token INNER
%token INPUT
%token INSENSITIVE
%token INSERT
%token INT
%token INTEGER
%token INTERSECT
%token INTERVAL
%token INTO
%token IS
%token ISOLATION
%token IntegrityNo
%token IntegrityYes
%token Intermediate
%token J
%token JOIN
%token K
%token KEY
%token L
%token LANGUAGE
%token LAST
%token LEADING
%token LEFT
%token LENGTH
%token LEVEL
%token LIKE
%token LOCAL
%token LOWER
%token Low
%token M
%token MATCH
%token MAX
%token MESSAGE_LENGTH
%token MESSAGE_OCTET_LENGTH
%token MESSAGE_TEXT
%token MIN
%token MINUTE
%token MODULE
%token MONTH
%token MORE
%token MUMPS
%token N
%token NAME
%token NAMES
%token NATIONAL
%token NATURAL
%token NCHAR
%token NEXT
%token NO
%token NOT
%token NULL
%token NULLABLE
%token NULLIF
%token NUMBER
%token NUMERIC
%token O
%token OCTET_LENGTH
%token OF
%token ON
%token ONLY
%token OPEN
%token OPTION
%token OR
%token ORDER
%token OUTER
%token OUTPUT
%token OVERLAPS
%token P
%token PAD
%token PARTIAL
%token PASCAL
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
%token Q
%token R
%token READ
%token REAL
%token REFERENCES
%token RELATIVE
%token REPEATABLE
%token RESTRICT
%token RETURNED_LENGTH
%token RETURNED_OCTET_LENGTH
%token RETURNED_SQLSTATE
%token REVOKE
%token RIGHT
%token ROLLBACK
%token ROWS
%token ROW_COUNT
%token S
%token SCALE
%token SCHEMA
%token SCHEMA_NAME
%token SCROLL
%token SECOND
%token SECTION
%token SELECT
%token SERIALIZABLE
%token SERVER_NAME
%token SESSION
%token SESSION_USER
%token SET
%token SIZE
%token SMALLINT
%token SOME
%token SPACE
%token SQL
%token SQLCODE
%token SQLCODE_TYPE
%token SQLERROR
%token SQLSTATE
%token SQLSTATE_TYPE
%token SQL_STANDARD.BIT
%token SQL_STANDARD.CHAR
%token SQL_STANDARD.DOUBLE_PRECISION
%token SQL_STANDARD.INDICATOR_TYPE
%token SQL_STANDARD.INT
%token SQL_STANDARD.REAL
%token SQL_STANDARD.SMALLINT
%token SQL_STANDARD.SQLCODE_TYPE
%token SQL_STANDARD.SQLSTATE_TYPE
%token SUBCLASS_ORIGIN
%token SUBSTRING
%token SUM
%token SYSTEM_USER
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
%token TRAILING
%token TRANSACTION
%token TRANSLATE
%token TRANSLATION
%token TRIM
%token TRUE
%token TYPE
%token U
%token UNCOMMITTED
%token UNION
%token UNIQUE
%token UNKNOWN
%token UNNAMED
%token UPDATE
%token UPPER
%token USAGE
%token USER
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
%token WITH
%token WORK
%token WRITE
%token X
%token Y
%token YEAR
%token Z
%token ZONE
%token _
%token a
%token action
%token auto
%token b
%token c
%token char
%token const
%token d
%token double
%token e
%token edition1987
%token edition1989
%token edition1992
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
%token n
%token o
%token omitted...
%token p
%token q
%token r
%token s
%token short
%token standard
%token static
%token t
%token u
%token v
%token volatile
%token w
%token x
%token y
%token z

/* The following non-terminals were not defined */
%token case_expression
%token desribe_statement
%token embedded_exception_declaration
%token grantee
%token row_value_constuctor
%token sql_edition
%token sql_session_stateament
%token type_name
/* End of undefined non-terminals */

/*
%rule action
%rule action_list
%rule actual_identifier
%rule ada_assignment_operator
%rule ada_host_identifier
%rule ada_initial_value
%rule ada_qualified_type_specification
%rule ada_type_specification
%rule ada_unqualified_type_specification
%rule ada_variable_definition
%rule add_column_definition
%rule add_domain_constraint_definition
%rule add_table_constraint_definition
%rule all
%rule allocate_cursor_statement
%rule allocate_descriptor_statement
%rule alter_column_action
%rule alter_column_definition
%rule alter_domain_action
%rule alter_domain_statement
%rule alter_table_action
%rule alter_table_statement
%rule ampersand
%rule approximate_numeric_literal
%rule approximate_numeric_type
%rule arc1
%rule arc2
%rule arc3
%rule argument
%rule as_clause
%rule assertion_check
%rule assertion_definition
%rule asterisk
%rule authorization_identifier
%rule between_predicate
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
%rule boolean_factor
%rule boolean_primary
%rule boolean_term
%rule boolean_test
%rule c_array_specification
%rule c_bit_variable
%rule c_character_variable
%rule c_class_modifier
%rule c_derived_variable
%rule c_host_identifier
%rule c_initial_value
%rule c_numeric_variable
%rule c_storage_class
%rule c_varchar_variable
%rule c_variable_definition
%rule c_variable_specification
%rule case_abbreviation
%rule case_expression
%rule case_expresssion
%rule case_operand
%rule case_specification
%rule cast_operand
%rule cast_specification
%rule cast_target
%rule catalog_name
%rule char_length_expression
%rule character_factor
%rule character_primary
%rule character_representation
%rule character_set_definition
%rule character_set_name
%rule character_set_source
%rule character_set_specification
%rule character_string_literal
%rule character_string_type
%rule character_substring_function
%rule character_translation
%rule character_value_expression
%rule character_value_function
%rule check_constraint_definition
%rule close_statement
%rule cobol_host_identifier
%rule cobol_variable_definition
%rule collate_clause
%rule collating_sequence_definition
%rule collation_definition
%rule collation_name
%rule collation_source
%rule colon
%rule column_constraint
%rule column_constraint_definition
%rule column_definition
%rule column_name
%rule column_name_list
%rule column_reference
%rule comma
%rule comment
%rule comment_character
%rule comment_introducer
%rule commit_statement
%rule comp_op
%rule comparison_predicate
%rule concatenation
%rule concatenation_operator
%rule condition
%rule condition_action
%rule condition_information
%rule condition_information_item
%rule condition_information_item_name
%rule condition_number
%rule connect_statement
%rule connection_name
%rule connection_object
%rule connection_target
%rule constraint_attributes
%rule constraint_check_time
%rule constraint_name
%rule constraint_name_definition
%rule constraint_name_list
%rule correlation_name
%rule correlation_specification
%rule corresponding_column_list
%rule corresponding_spec
%rule cross_join
%rule current_date_value_function
%rule current_time_value_function
%rule current_timestamp_value_function
%rule cursor_name
%rule cursor_specification
%rule data_type
%rule date_literal
%rule date_string
%rule date_value
%rule datetime_factor
%rule datetime_field
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
%rule declare_cursor
%rule default_clause
%rule default_option
%rule default_specification
%rule delete_rule
%rule delete_statement_positioned
%rule delete_statement_searched
%rule delimited_identifier
%rule delimited_identifier_body
%rule delimited_identifier_part
%rule delimiter_token
%rule derived_column
%rule derived_column_list
%rule derived_table
%rule describe_input_statement
%rule describe_output_statement
%rule describe_statement
%rule descriptor_item_name
%rule descriptor_name
%rule desribe_statement
%rule diagnostics_size
%rule digit
%rule direct_implementation_defined_statement
%rule direct_select_statement_multiple_rows
%rule direct_sql_data_statement
%rule direct_sql_statement
%rule disconnect_object
%rule disconnect_statement
%rule domain_constraint
%rule domain_definition
%rule domain_name
%rule double_period
%rule double_quote
%rule doublequote_symbol
%rule drop_assertion_statement
%rule drop_behaviour
%rule drop_character_set_statement
%rule drop_collation_statement
%rule drop_column_default_clause
%rule drop_column_definition
%rule drop_domain_constraint_definition
%rule drop_domain_default_clause
%rule drop_domain_statement
%rule drop_schema_statement
%rule drop_table_constraint_definition
%rule drop_table_statement
%rule drop_translation_statement
%rule drop_view_statement
%rule dynamic_close_statement
%rule dynamic_cursor_name
%rule dynamic_declare_cursor
%rule dynamic_delete_statement_positioned
%rule dynamic_fetch_statement
%rule dynamic_open_statement
%rule dynamic_parameter_specification
%rule dynamic_select_statement
%rule dynamic_single_row_select_statement
%rule dynamic_update_statement_positioned
%rule else_clause
%rule embedded_character_set_declaration
%rule embedded_exception_condition
%rule embedded_exception_declaration
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
%rule embedded_variable_name
%rule end_field
%rule equals_operator
%rule escape_character
%rule exact_numeric_literal
%rule exact_numeric_type
%rule execute_immediate_statement
%rule execute_statement
%rule existing_character_set_name
%rule exists_predicate
%rule explicit_table
%rule exponent
%rule extended_cursor_name
%rule extended_statement_name
%rule external_collation
%rule external_collation_name
%rule external_translation
%rule external_translation_name
%rule extract_expression
%rule extract_field
%rule extract_source
%rule factor
%rule fetch_orientation
%rule fetch_statement
%rule fetch_target_list
%rule fold
%rule form_of_use_conversion
%rule form_of_use_conversion_name
%rule fortran_host_identifier
%rule fortran_variable_definition
%rule from_clause
%rule general_literal
%rule general_set_function
%rule general_value_specification
%rule get_count
%rule get_descriptor_information
%rule get_descriptor_statement
%rule get_diagnostics_statement
%rule get_item_information
%rule go_to
%rule goto_target
%rule grant_statement
%rule grantee
%rule greater_than_operator
%rule greater_than_or_equals_operator
%rule group_by_clause
%rule grouping_column_reference
%rule grouping_column_reference_list
%rule having_clause
%rule hex_string_literal
%rule hexit
%rule high
%rule host_identifier
%rule host_label_identifier
%rule host_pl_i_label_variable
%rule host_variable_definition
%rule hours_value
%rule identifier
%rule identifier_body
%rule identifier_part
%rule identifier_start
%rule implementation_defined_character_repertoire_name
%rule implementation_defined_collation_name
%rule implementation_defined_translation_name
%rule implementation_defined_universal_character_form_of_use_name
%rule in_predicate
%rule in_predicate_value
%rule in_value_list
%rule indicator_parameter
%rule indicator_variable
%rule insert_column_list
%rule insert_columns_and_source
%rule insert_statement
%rule integrity_no
%rule integrity_yes
%rule intermediate
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
%rule introducer
%rule isolation_level
%rule item_number
%rule j_1987
%rule j_1989
%rule j_1989_base
%rule j_1989_package
%rule j_1992
%rule join_column_list
%rule join_condition
%rule join_specification
%rule join_type
%rule joined_table
%rule key_word
%rule language_clause
%rule language_name
%rule left_bracket
%rule left_paren
%rule length
%rule length_expression
%rule less_than_operator
%rule less_than_or_equals_operator
%rule level_of_isolation
%rule levels_clause
%rule like_predicate
%rule limited_collation_definition
%rule literal
%rule local_table_name
%rule low
%rule mantissa
%rule match_predicate
%rule match_type
%rule match_value
%rule minus_sign
%rule minutes_value
%rule module
%rule module_authorization_clause
%rule module_authorization_identifier
%rule module_character_set_specification
%rule module_contents
%rule module_name
%rule module_name_clause
%rule months_value
%rule mumps_host_identifier
%rule mumps_variable_definition
%rule named_columns_join
%rule national_character_string_literal
%rule national_character_string_type
%rule newline
%rule non_join_query_expression
%rule non_join_query_primary
%rule non_join_query_term
%rule non_reserved_word
%rule non_second_datetime_field
%rule nondelimiter_token
%rule nondoublequote_character
%rule nonquote_character
%rule not_equals_operator
%rule null_predicate
%rule null_specification
%rule number_of_conditions
%rule numeric_primary
%rule numeric_type
%rule numeric_value_expression
%rule numeric_value_function
%rule object_column
%rule object_name
%rule occurrences
%rule octet_length_expression
%rule open_statement
%rule order_by_clause
%rule ordering_specification
%rule outer_join_type
%rule overlaps_predicate
%rule pad_attribute
%rule parameter_declaration
%rule parameter_declaration_list
%rule parameter_name
%rule parameter_specification
%rule parameter_using_clause
%rule pascal_host_identifier
%rule pascal_variable_definition
%rule pattern
%rule percent
%rule period
%rule pl_i_host_identifier
%rule pl_i_variable_definition
%rule plus_sign
%rule position_expression
%rule precision
%rule predicate
%rule preparable_dynamic_delete_statement_positioned
%rule preparable_dynamic_update_statement_positioned
%rule preparable_sql_data_statement
%rule preparable_sql_implementation_defined_statement
%rule preparable_sql_schema_statement
%rule preparable_sql_session_statement
%rule preparable_sql_transaction_statement
%rule preparable_statement
%rule prepare_statement
%rule privilege_column_list
%rule privileges
%rule procedure
%rule procedure_name
%rule qualified_identifier
%rule qualified_join
%rule qualified_local_table_name
%rule qualified_name
%rule qualifier
%rule quantified_comparison_predicate
%rule quantifier
%rule query_expression
%rule query_primary
%rule query_specification
%rule query_term
%rule question_mark
%rule quote
%rule quote_symbol
%rule reference_column_list
%rule referenced_table_and_columns
%rule references_specification
%rule referencing_columns
%rule referential_action
%rule referential_constraint_definition
%rule referential_triggered_action
%rule regular_identifier
%rule reserved_word
%rule result
%rule result_expression
%rule result_using_clause
%rule revoke_statement
%rule right_bracket
%rule right_paren
%rule rollback_statement
%rule row_subquery
%rule row_value_constructor
%rule row_value_constructor_1
%rule row_value_constructor_2
%rule row_value_constructor_element
%rule row_value_constructor_list
%rule row_value_constuctor
%rule scalar_subquery
%rule scale
%rule schema_authorization_identifier
%rule schema_character_set_name
%rule schema_character_set_specification
%rule schema_collation_name
%rule schema_definition
%rule schema_element
%rule schema_name
%rule schema_name_clause
%rule schema_translation_name
%rule scope_option
%rule search_condition
%rule searched_case
%rule searched_when_clause
%rule seconds_fraction
%rule seconds_integer_value
%rule seconds_value
%rule select_list
%rule select_statement_single_row
%rule select_sublist
%rule select_target_list
%rule semicolon
%rule separator
%rule set_catalog_statement
%rule set_clause
%rule set_clause_list
%rule set_column_default_clause
%rule set_connection_statement
%rule set_constraints_mode_statement
%rule set_count
%rule set_descriptor_information
%rule set_descriptor_statement
%rule set_domain_default_clause
%rule set_function_specification
%rule set_function_type
%rule set_item_information
%rule set_local_time_zone_statement
%rule set_names_statement
%rule set_quantifier
%rule set_schema_statement
%rule set_session_authorization_identifier_statement
%rule set_time_zone_value
%rule set_transaction_statement
%rule sign
%rule signed_integer
%rule signed_numeric_literal
%rule simple_case
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
%rule solidus
%rule some
%rule sort_key
%rule sort_specification
%rule sort_specification_list
%rule source_character_set_specification
%rule space
%rule sql_conformance
%rule sql_connection_statement
%rule sql_data_change_statement
%rule sql_data_statement
%rule sql_diagnostics_information
%rule sql_diagnostics_statement
%rule sql_dynamic_data_statement
%rule sql_dynamic_statement
%rule sql_edition
%rule sql_embedded_language_character
%rule sql_language_character
%rule sql_language_identifier
%rule sql_language_identifier_part
%rule sql_language_identifier_start
%rule sql_object_identifier
%rule sql_prefix
%rule sql_procedure_statement
%rule sql_provenance
%rule sql_schema_definition_statement
%rule sql_schema_manipulation_statement
%rule sql_schema_statement
%rule sql_server_name
%rule sql_session_stateament
%rule sql_session_statement
%rule sql_special_character
%rule sql_statement_name
%rule sql_statement_variable
%rule sql_terminal_character
%rule sql_terminator
%rule sql_transaction_statement
%rule sql_variant
%rule standard_character_repertoire_name
%rule standard_collation_name
%rule standard_translation_name
%rule standard_universal_character_form_of_use_name
%rule start_field
%rule start_position
%rule statement_information
%rule statement_information_item
%rule statement_information_item_name
%rule statement_name
%rule statement_or_declaration
%rule status_parameter
%rule string_length
%rule string_value_expression
%rule string_value_function
%rule subquery
%rule system_descriptor_statement
%rule table_constraint
%rule table_constraint_definition
%rule table_definition
%rule table_element
%rule table_element_list
%rule table_expression
%rule table_name
%rule table_reference
%rule table_subquery
%rule table_value_constructor
%rule table_value_constructor_list
%rule target_character_set_specification
%rule target_specification
%rule temporary_table_declaration
%rule term
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
%rule token
%rule transaction_access_mode
%rule transaction_mode
%rule translation_collation
%rule translation_definition
%rule translation_name
%rule translation_source
%rule translation_specification
%rule trim_character
%rule trim_function
%rule trim_operands
%rule trim_source
%rule trim_specification
%rule truth_value
%rule type_name
%rule underscore
%rule unique_column_list
%rule unique_constraint_definition
%rule unique_predicate
%rule unique_specification
%rule unqualified_schema_name
%rule unsigned_integer
%rule unsigned_literal
%rule unsigned_numeric_literal
%rule unsigned_value_specification
%rule updatability_clause
%rule update_rule
%rule update_source
%rule update_statement_positioned
%rule update_statement_searched
%rule user_defined_character_repertoire_name
%rule user_name
%rule using_arguments
%rule using_clause
%rule using_descriptor
%rule value_expression
%rule value_expression_primary
%rule value_specification
%rule variable_specification
%rule vertical_bar
%rule view_column_list
%rule view_definition
%rule when_operand
%rule where_clause
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
	:	ada_initial_value
	|	ada_type_specification
	|	case_expresssion
	|	describe_statement
	|	direct_sql_statement
	|	embedded_exception_condition
	|	embedded_sql_declare_section
	|	embedded_sql_host_program
	|	embedded_sql_statement
	|	module
	|	preparable_statement
	|	sql_object_identifier
	|	sql_terminal_character
	|	token
	|	unique_predicate
	;

sql_terminal_character
	:	sql_language_character
	|	sql_embedded_language_character
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
	|	greater_than_operator
	|	equals_operator
	|	question_mark
	|	underscore
	|	vertical_bar
	;

space
	:	/* !! space character in character set in use */
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

underscore
	:	_
	;

vertical_bar
	:	'|'
	;

sql_embedded_language_character
	:	left_bracket
	|	right_bracket
	;

left_bracket
	:	'['
	;

right_bracket
	:	']'
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
	;

regular_identifier
	:	identifier_body
	;

seq_nt_002
	:	underscore
	|	identifier_part
	;

lst_nt_003
	:	seq_nt_002
	|	lst_nt_003 seq_nt_002
	;

opt_nt_001
	:	/* Nothing */
	|	lst_nt_003 ']'
	;

identifier_body
	:	identifier_start opt_nt_001
	;

identifier_start
	:	/* !! See the Syntax rules */
	;

identifier_part
	:	identifier_start
	|	digit
	;

key_word
	:	reserved_word
	|	non_reserved_word
	;

reserved_word
	:	ABSOLUTE
	|	ACTION
	|	ADD
	|	ALL
	|	ALLOCATE
	|	ALTER
	|	AND
	|	ANY
	|	ARE
	|	AS
	|	ASC
	|	ASSERTION
	|	AT
	|	AUTHORIZATION
	|	AVG
	|	BEGIN
	|	BETWEEN
	|	BIT
	|	BIT_LENGTH
	|	BOTH
	|	BY
	|	CASCADE
	|	CASCADED
	|	CASE
	|	CAST
	|	CATALOG
	|	CHAR
	|	CHARACTER
	|	CHARACTER_LENGTH
	|	CHAR_LENGTH
	|	CHECK
	|	CLOSE
	|	COALESCE
	|	COLLATE
	|	COLLATION
	|	COLUMN
	|	COMMIT
	|	CONNECT
	|	CONNECTION
	|	CONSTRAINT
	|	CONSTRAINTS
	|	CONTINUE
	|	CONVERT
	|	CORRESPONDING
	|	CREATE
	|	CROSS
	|	CURRENT
	|	CURRENT_DATE
	|	CURRENT_TIME
	|	CURRENT_TIMESTAMP
	|	CURRENT_USER
	|	CURSOR
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
	|	DESC
	|	DESCRIBE
	|	DESCRIPTOR
	|	DIAGNOSTICS
	|	DISCONNECT
	|	DISTINCT
	|	DOMAIN
	|	DOUBLE
	|	DROP
	|	ELSE
	|	END
	|	END-EXEC
	|	ESCAPE
	|	EXCEPT
	|	EXCEPTION
	|	EXEC
	|	EXECUTE
	|	EXISTS
	|	EXTERNAL
	|	EXTRACT
	|	FALSE
	|	FETCH
	|	FIRST
	|	FLOAT
	|	FOR
	|	FOREIGN
	|	FOUND
	|	FROM
	|	FULL
	|	GET
	|	GLOBAL
	|	GO
	|	GOTO
	|	GRANT
	|	GROUP
	|	HAVING
	|	HOUR
	|	IDENTITY
	|	IMMEDIATE
	|	IN
	|	INDICATOR
	|	INITIALLY
	|	INNER
	|	INPUT
	|	INSENSITIVE
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
	|	LAST
	|	LEADING
	|	LEFT
	|	LEVEL
	|	LIKE
	|	LOCAL
	|	LOWER
	|	MATCH
	|	MAX
	|	MIN
	|	MINUTE
	|	MODULE
	|	MONTH
	|	NAMES
	|	NATIONAL
	|	NATURAL
	|	NCHAR
	|	NEXT
	|	NO
	|	NOT
	|	NULL
	|	NULLIF
	|	NUMERIC
	|	OCTET_LENGTH
	|	OF
	|	ON
	|	ONLY
	|	OPEN
	|	OPTION
	|	OR
	|	ORDER
	|	OUTER
	|	OUTPUT
	|	OVERLAPS
	|	PAD
	|	PARTIAL
	|	POSITION
	|	PRECISION
	|	PREPARE
	|	PRESERVE
	|	PRIMARY
	|	PRIOR
	|	PRIVILEGES
	|	PROCEDURE
	|	PUBLIC
	|	READ
	|	REAL
	|	REFERENCES
	|	RELATIVE
	|	RESTRICT
	|	REVOKE
	|	RIGHT
	|	ROLLBACK
	|	ROWS
	|	SCHEMA
	|	SCROLL
	|	SECOND
	|	SECTION
	|	SELECT
	|	SESSION
	|	SESSION_USER
	|	SET
	|	SIZE
	|	SMALLINT
	|	SOME
	|	SPACE
	|	SQL
	|	SQLCODE
	|	SQLERROR
	|	SQLSTATE
	|	SUBSTRING
	|	SUM
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
	|	TRANSLATE
	|	TRANSLATION
	|	TRIM
	|	TRUE
	|	UNION
	|	UNIQUE
	|	UNKNOWN
	|	UPDATE
	|	UPPER
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
	|	WITH
	|	WORK
	|	WRITE
	|	YEAR
	|	ZONE
	;

non_reserved_word
	:	ADA
	|	C
	|	CATALOG_NAME
	|	CHARACTER_SET_CATALOG
	|	CHARACTER_SET_NAME
	|	CHARACTER_SET_SCHEMA
	|	CLASS_ORIGIN
	|	COBOL
	|	COLLATION_CATALOG
	|	COLLATION_NAME
	|	COLLATION_SCHEMA
	|	COLUMN_NAME
	|	COMMAND_FUNCTION
	|	COMMITTED
	|	CONDITION_NUMBER
	|	CONNECTION_NAME
	|	CONSTRAINT_CATALOG
	|	CONSTRAINT_NAME
	|	CONSTRAINT_SCHEMA
	|	CURSOR_NAME
	|	DATA
	|	DATETIME_INTERVAL_CODE
	|	DATETIME_INTERVAL_PRECISION
	|	DYNAMIC_FUNCTION
	|	FORTRAN
	|	LENGTH
	|	MESSAGE_LENGTH
	|	MESSAGE_OCTET_LENGTH
	|	MESSAGE_TEXT
	|	MORE
	|	MUMPS
	|	NAME
	|	NULLABLE
	|	NUMBER
	|	PASCAL
	|	PLI
	|	REPEATABLE
	|	RETURNED_LENGTH
	|	RETURNED_OCTET_LENGTH
	|	RETURNED_SQLSTATE
	|	ROW_COUNT
	|	SCALE
	|	SCHEMA_NAME
	|	SERIALIZABLE
	|	SERVER_NAME
	|	SUBCLASS_ORIGIN
	|	TABLE_NAME
	|	TYPE
	|	UNCOMMITTED
	|	UNNAMED
	;

unsigned_numeric_literal
	:	exact_numeric_literal
	|	approximate_numeric_literal
	;

opt_nt_005
	:	/* Nothing */
	|	unsigned_integer
	;

opt_nt_004
	:	/* Nothing */
	|	period opt_nt_005
	;

exact_numeric_literal
	:	unsigned_integer opt_nt_004
	|	period unsigned_integer
	;

lst_nt_006
	:	digit
	|	lst_nt_006 digit
	;

unsigned_integer
	:	lst_nt_006
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

opt_nt_007
	:	/* Nothing */
	|	sign
	;

signed_integer
	:	opt_nt_007 unsigned_integer
	;

sign
	:	plus_sign
	|	minus_sign
	;

lst_nt_009
	:	character_representation
	|	lst_nt_009 character_representation
	;

opt_nt_008
	:	/* Nothing */
	|	lst_nt_009
	;

lst_nt_012
	:	separator
	|	lst_nt_012 separator
	;

lst_nt_014
	:	character_representation
	|	lst_nt_014 character_representation
	;

opt_nt_013
	:	/* Nothing */
	|	lst_nt_014
	;

seq_nt_011
	:	lst_nt_012 quote opt_nt_013 quote
	;

lst_nt_015
	:	seq_nt_011
	|	lst_nt_015 seq_nt_011
	;

opt_nt_010
	:	/* Nothing */
	|	lst_nt_015 ']'
	;

national_character_string_literal
	:	N quote opt_nt_008 quote opt_nt_010
	;

character_representation
	:	nonquote_character
	|	quote_symbol
	;

nonquote_character
	:	/* !! See the Syntax rules */
	;

quote_symbol
	:	quote quote
	;

seq_nt_016
	:	comment
	|	space
	|	newline
	;

lst_nt_017
	:	seq_nt_016
	|	lst_nt_017 seq_nt_016
	;

separator
	:	lst_nt_017
	;

lst_nt_019
	:	comment_character
	|	lst_nt_019 comment_character
	;

opt_nt_018
	:	/* Nothing */
	|	lst_nt_019
	;

comment
	:	comment_introducer opt_nt_018 newline
	;

lst_nt_021
	:	minus_sign
	|	lst_nt_021 minus_sign
	;

opt_nt_020
	:	/* Nothing */
	|	lst_nt_021 ']'
	;

comment_introducer
	:	minus_sign minus_sign opt_nt_020
	;

comment_character
	:	nonquote_character
	|	quote
	;

newline
	:	/* !! implementation defined end of line indicator */
	;

lst_nt_023
	:	bit
	|	lst_nt_023 bit
	;

opt_nt_022
	:	/* Nothing */
	|	lst_nt_023
	;

lst_nt_026
	:	separator
	|	lst_nt_026 separator
	;

lst_nt_028
	:	bit
	|	lst_nt_028 bit
	;

opt_nt_027
	:	/* Nothing */
	|	lst_nt_028
	;

seq_nt_025
	:	lst_nt_026 quote opt_nt_027 quote
	;

lst_nt_029
	:	seq_nt_025
	|	lst_nt_029 seq_nt_025
	;

opt_nt_024
	:	/* Nothing */
	|	lst_nt_029 ']'
	;

bit_string_literal
	:	B quote opt_nt_022 quote opt_nt_024
	;

bit
	:	0
	|	1
	;

lst_nt_031
	:	hexit
	|	lst_nt_031 hexit
	;

opt_nt_030
	:	/* Nothing */
	|	lst_nt_031
	;

lst_nt_034
	:	separator
	|	lst_nt_034 separator
	;

lst_nt_036
	:	hexit
	|	lst_nt_036 hexit
	;

opt_nt_035
	:	/* Nothing */
	|	lst_nt_036
	;

seq_nt_033
	:	lst_nt_034 quote opt_nt_035 quote
	;

lst_nt_037
	:	seq_nt_033
	|	lst_nt_037 seq_nt_033
	;

opt_nt_032
	:	/* Nothing */
	|	lst_nt_037 ']'
	;

hex_string_literal
	:	X quote opt_nt_030 quote opt_nt_032
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

delimiter_token
	:	character_string_literal
	|	date_string
	|	time_string
	|	timestamp_string
	|	delimited_identifier
	|	sql_special_character
	|	not_equals_operator
	|	greater_than_or_equals_operator
	|	less_than_or_equals_operator
	|	concatenation_operator
	|	double_period
	|	left_bracket
	|	right_bracket
	;

opt_nt_038
	:	/* Nothing */
	|	introducer character_set_specification
	;

lst_nt_040
	:	character_representation
	|	lst_nt_040 character_representation
	;

opt_nt_039
	:	/* Nothing */
	|	lst_nt_040
	;

lst_nt_043
	:	separator
	|	lst_nt_043 separator
	;

lst_nt_045
	:	character_representation
	|	lst_nt_045 character_representation
	;

opt_nt_044
	:	/* Nothing */
	|	lst_nt_045
	;

seq_nt_042
	:	lst_nt_043 quote opt_nt_044 quote
	;

lst_nt_046
	:	seq_nt_042
	|	lst_nt_046 seq_nt_042
	;

opt_nt_041
	:	/* Nothing */
	|	lst_nt_046 ']'
	;

character_string_literal
	:	opt_nt_038 quote opt_nt_039 quote opt_nt_041
	;

introducer
	:	underscore
	;

character_set_specification
	:	standard_character_repertoire_name
	|	implementation_defined_character_repertoire_name
	|	user_defined_character_repertoire_name
	|	standard_universal_character_form_of_use_name
	|	implementation_defined_universal_character_form_of_use_name
	;

standard_character_repertoire_name
	:	character_set_name
	;

opt_nt_047
	:	/* Nothing */
	|	schema_name period
	;

character_set_name
	:	opt_nt_047 sql_language_identifier
	;

opt_nt_048
	:	/* Nothing */
	|	catalog_name period
	;

schema_name
	:	opt_nt_048 unqualified_schema_name
	;

catalog_name
	:	identifier
	;

opt_nt_049
	:	/* Nothing */
	|	introducer character_set_specification
	;

identifier
	:	opt_nt_049 actual_identifier
	;

actual_identifier
	:	regular_identifier
	|	delimited_identifier
	;

delimited_identifier
	:	double_quote delimited_identifier_body double_quote
	;

lst_nt_050
	:	delimited_identifier_part
	|	lst_nt_050 delimited_identifier_part
	;

delimited_identifier_body
	:	lst_nt_050
	;

delimited_identifier_part
	:	nondoublequote_character
	|	doublequote_symbol
	;

nondoublequote_character
	:	/* !! See the syntax rules */
	;

doublequote_symbol
	:	double_quote double_quote
	;

unqualified_schema_name
	:	identifier
	;

seq_nt_052
	:	underscore
	|	sql_language_identifier_part
	;

lst_nt_053
	:	seq_nt_052
	|	lst_nt_053 seq_nt_052
	;

opt_nt_051
	:	/* Nothing */
	|	lst_nt_053 ']'
	;

sql_language_identifier
	:	sql_language_identifier_start opt_nt_051
	;

sql_language_identifier_start
	:	simple_latin_letter
	;

sql_language_identifier_part
	:	simple_latin_letter
	|	digit
	;

implementation_defined_character_repertoire_name
	:	character_set_name
	;

user_defined_character_repertoire_name
	:	character_set_name
	;

standard_universal_character_form_of_use_name
	:	character_set_name
	;

implementation_defined_universal_character_form_of_use_name
	:	character_set_name
	;

date_string
	:	quote date_value quote
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

opt_nt_054
	:	/* Nothing */
	|	time_zone_interval
	;

time_string
	:	quote time_value opt_nt_054 quote
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

opt_nt_056
	:	/* Nothing */
	|	seconds_fraction
	;

opt_nt_055
	:	/* Nothing */
	|	period opt_nt_056 ']'
	;

seconds_value
	:	seconds_integer_value opt_nt_055
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

opt_nt_057
	:	/* Nothing */
	|	time_zone_interval
	;

timestamp_string
	:	quote date_value space time_value opt_nt_057 quote
	;

seq_nt_058
	:	year_month_literal
	|	day_time_literal
	;

interval_string
	:	quote seq_nt_058 quote
	;

opt_nt_059
	:	/* Nothing */
	|	years_value minus_sign
	;

year_month_literal
	:	years_value
	|	opt_nt_059 months_value
	;

day_time_literal
	:	day_time_interval
	|	time_interval
	;

opt_nt_062
	:	/* Nothing */
	|	colon seconds_value
	;

opt_nt_061
	:	/* Nothing */
	|	colon minutes_value opt_nt_062
	;

opt_nt_060
	:	/* Nothing */
	|	space hours_value opt_nt_061 ']'
	;

day_time_interval
	:	days_value opt_nt_060
	;

opt_nt_064
	:	/* Nothing */
	|	colon seconds_value
	;

opt_nt_063
	:	/* Nothing */
	|	colon minutes_value opt_nt_064
	;

opt_nt_065
	:	/* Nothing */
	|	colon seconds_value
	;

time_interval
	:	hours_value opt_nt_063
	|	minutes_value opt_nt_065
	|	seconds_value
	;

not_equals_operator
	:	
	;

greater_than_or_equals_operator
	:	
	;

less_than_or_equals_operator
	:	
	;

concatenation_operator
	:	
	|	'|'
	;

double_period
	:	
	;

lst_nt_067
	:	temporary_table_declaration
	|	lst_nt_067 temporary_table_declaration
	;

opt_nt_066
	:	/* Nothing */
	|	lst_nt_067
	;

lst_nt_068
	:	module_contents
	|	lst_nt_068 module_contents
	;

module
	:	module_name_clause language_clause module_authorization_clause opt_nt_066 lst_nt_068
	;

opt_nt_069
	:	/* Nothing */
	|	module_name
	;

opt_nt_070
	:	/* Nothing */
	|	module_character_set_specification ']'
	;

module_name_clause
	:	MODULE opt_nt_069 opt_nt_070
	;

module_name
	:	identifier
	;

module_character_set_specification
	:	NAMES ARE character_set_specification
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
	:	identifier
	;

seq_nt_072
	:	PRESERVE
	|	DELETE
	;

opt_nt_071
	:	/* Nothing */
	|	ON COMMIT seq_nt_072 ROWS ']'
	;

temporary_table_declaration
	:	DECLARE LOCAL TEMPORARY TABLE qualified_local_table_name table_element_list opt_nt_071
	;

qualified_local_table_name
	:	MODULE period local_table_name
	;

local_table_name
	:	qualified_identifier
	;

qualified_identifier
	:	identifier
	;

seq_nt_074
	:	comma table_element
	;

lst_nt_075
	:	seq_nt_074
	|	lst_nt_075 seq_nt_074
	;

opt_nt_073
	:	/* Nothing */
	|	lst_nt_075
	;

table_element_list
	:	left_paren table_element opt_nt_073 right_paren
	;

table_element
	:	column_definition
	|	table_constraint_definition
	;

seq_nt_076
	:	data_type
	|	domain_name
	;

opt_nt_077
	:	/* Nothing */
	|	default_clause
	;

lst_nt_079
	:	column_constraint_definition
	|	lst_nt_079 column_constraint_definition
	;

opt_nt_078
	:	/* Nothing */
	|	lst_nt_079
	;

opt_nt_080
	:	/* Nothing */
	|	collate_clause ']'
	;

column_definition
	:	column_name seq_nt_076 opt_nt_077 opt_nt_078 opt_nt_080
	;

column_name
	:	identifier
	;

opt_nt_081
	:	/* Nothing */
	|	CHARACTER SET character_set_specification
	;

data_type
	:	character_string_type opt_nt_081
	|	national_character_string_type
	|	bit_string_type
	|	numeric_type
	|	datetime_type
	|	interval_type
	;

opt_nt_082
	:	/* Nothing */
	|	left_paren length right_paren
	;

opt_nt_083
	:	/* Nothing */
	|	left_paren length right_paren
	;

opt_nt_084
	:	/* Nothing */
	|	left_paren length right_paren
	;

opt_nt_085
	:	/* Nothing */
	|	left_paren length right_paren
	;

opt_nt_086
	:	/* Nothing */
	|	left_paren length right_paren ']'
	;

character_string_type
	:	CHARACTER opt_nt_082
	|	CHAR opt_nt_083
	|	CHARACTER VARYING opt_nt_084
	|	CHAR VARYING opt_nt_085
	|	VARCHAR opt_nt_086
	;

length
	:	unsigned_integer
	;

opt_nt_087
	:	/* Nothing */
	|	left_paren length right_paren
	;

opt_nt_088
	:	/* Nothing */
	|	left_paren length right_paren
	;

opt_nt_089
	:	/* Nothing */
	|	left_paren length right_paren
	;

opt_nt_090
	:	/* Nothing */
	|	left_paren length right_paren
	;

opt_nt_091
	:	/* Nothing */
	|	left_paren length right_paren
	;

opt_nt_092
	:	/* Nothing */
	|	left_paren length right_paren ']'
	;

national_character_string_type
	:	NATIONAL CHARACTER opt_nt_087
	|	NATIONAL CHAR opt_nt_088
	|	NCHAR opt_nt_089
	|	NATIONAL CHARACTER VARYING opt_nt_090
	|	NATIONAL CHAR VARYING opt_nt_091
	|	NCHAR VARYING opt_nt_092
	;

opt_nt_093
	:	/* Nothing */
	|	left_paren length right_paren
	;

opt_nt_094
	:	/* Nothing */
	|	left_paren length right_paren ']'
	;

bit_string_type
	:	BIT opt_nt_093
	|	BIT VARYING opt_nt_094
	;

numeric_type
	:	exact_numeric_type
	|	approximate_numeric_type
	;

opt_nt_096
	:	/* Nothing */
	|	comma scale
	;

opt_nt_095
	:	/* Nothing */
	|	left_paren precision opt_nt_096 right_paren
	;

opt_nt_098
	:	/* Nothing */
	|	comma scale
	;

opt_nt_097
	:	/* Nothing */
	|	left_paren precision opt_nt_098 right_paren
	;

opt_nt_100
	:	/* Nothing */
	|	comma scale
	;

opt_nt_099
	:	/* Nothing */
	|	left_paren precision opt_nt_100 right_paren
	;

exact_numeric_type
	:	NUMERIC opt_nt_095
	|	DECIMAL opt_nt_097
	|	DEC opt_nt_099
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

opt_nt_101
	:	/* Nothing */
	|	left_paren
	;

approximate_numeric_type
	:	FLOAT opt_nt_101
	;

opt_nt_102
	:	/* Nothing */
	|	left_paren time_precision right_paren
	;

opt_nt_103
	:	/* Nothing */
	|	WITH TIME ZONE
	;

opt_nt_104
	:	/* Nothing */
	|	left_paren timestamp_precision right_paren
	;

opt_nt_105
	:	/* Nothing */
	|	WITH TIME ZONE ']'
	;

datetime_type
	:	DATE
	|	TIME opt_nt_102 opt_nt_103
	|	TIMESTAMP opt_nt_104 opt_nt_105
	;

time_precision
	:	time_fractional_seconds_precision
	;

time_fractional_seconds_precision
	:	unsigned_integer
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

opt_nt_106
	:	/* Nothing */
	|	left_paren interval_leading_field_precision right_paren ']'
	;

start_field
	:	non_second_datetime_field opt_nt_106
	;

non_second_datetime_field
	:	YEAR
	|	MONTH
	|	DAY
	|	HOUR
	|	MINUTE
	;

interval_leading_field_precision
	:	unsigned_integer
	;

opt_nt_107
	:	/* Nothing */
	|	left_paren interval_fractional_seconds_precision right_paren ']'
	;

end_field
	:	non_second_datetime_field
	|	SECOND opt_nt_107
	;

interval_fractional_seconds_precision
	:	unsigned_integer
	;

opt_nt_108
	:	/* Nothing */
	|	left_paren interval_leading_field_precision right_paren
	;

opt_nt_110
	:	/* Nothing */
	|	comma left_paren interval_fractional_seconds_precision
	;

opt_nt_109
	:	/* Nothing */
	|	left_paren interval_leading_field_precision opt_nt_110 right_paren ']'
	;

single_datetime_field
	:	non_second_datetime_field opt_nt_108
	|	SECOND opt_nt_109
	;

domain_name
	:	qualified_name
	;

opt_nt_111
	:	/* Nothing */
	|	schema_name period
	;

qualified_name
	:	opt_nt_111 qualified_identifier
	;

default_clause
	:	DEFAULT default_option
	;

default_option
	:	literal
	|	datetime_value_function
	|	USER
	|	CURRENT_USER
	|	SESSION_USER
	|	SYSTEM_USER
	|	NULL
	;

literal
	:	signed_numeric_literal
	|	general_literal
	;

opt_nt_112
	:	/* Nothing */
	|	sign
	;

signed_numeric_literal
	:	opt_nt_112 unsigned_numeric_literal
	;

general_literal
	:	character_string_literal
	|	national_character_string_literal
	|	bit_string_literal
	|	hex_string_literal
	|	datetime_literal
	|	interval_literal
	;

datetime_literal
	:	date_literal
	|	time_literal
	|	timestamp_literal
	;

date_literal
	:	DATE date_string
	;

time_literal
	:	TIME time_string
	;

timestamp_literal
	:	TIMESTAMP timestamp_string
	;

opt_nt_113
	:	/* Nothing */
	|	sign
	;

interval_literal
	:	INTERVAL opt_nt_113 interval_string interval_qualifier
	;

datetime_value_function
	:	current_date_value_function
	|	current_time_value_function
	|	current_timestamp_value_function
	;

current_date_value_function
	:	CURRENT_DATE
	;

opt_nt_114
	:	/* Nothing */
	|	left_paren time_precision right_paren ']'
	;

current_time_value_function
	:	CURRENT_TIME opt_nt_114
	;

opt_nt_115
	:	/* Nothing */
	|	left_paren timestamp_precision right_paren ']'
	;

current_timestamp_value_function
	:	CURRENT_TIMESTAMP opt_nt_115
	;

opt_nt_116
	:	/* Nothing */
	|	constraint_name_definition
	;

opt_nt_117
	:	/* Nothing */
	|	constraint_attributes ']'
	;

column_constraint_definition
	:	opt_nt_116 column_constraint opt_nt_117
	;

constraint_name_definition
	:	CONSTRAINT constraint_name
	;

constraint_name
	:	qualified_name
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

opt_nt_118
	:	/* Nothing */
	|	MATCH match_type
	;

opt_nt_119
	:	/* Nothing */
	|	referential_triggered_action ']'
	;

references_specification
	:	REFERENCES referenced_table_and_columns opt_nt_118 opt_nt_119
	;

opt_nt_120
	:	/* Nothing */
	|	left_paren reference_column_list right_paren ']'
	;

referenced_table_and_columns
	:	table_name opt_nt_120
	;

table_name
	:	qualified_name
	|	qualified_local_table_name
	;

reference_column_list
	:	column_name_list
	;

seq_nt_122
	:	comma column_name
	;

lst_nt_123
	:	seq_nt_122
	|	lst_nt_123 seq_nt_122
	;

opt_nt_121
	:	/* Nothing */
	|	lst_nt_123 ']'
	;

column_name_list
	:	column_name opt_nt_121
	;

match_type
	:	FULL
	|	PARTIAL
	;

opt_nt_124
	:	/* Nothing */
	|	delete_rule
	;

opt_nt_125
	:	/* Nothing */
	|	update_rule ']'
	;

referential_triggered_action
	:	update_rule opt_nt_124
	|	delete_rule opt_nt_125
	;

update_rule
	:	ON UPDATE referential_action
	;

referential_action
	:	CASCADE
	|	SET NULL
	|	SET DEFAULT
	|	NO ACTION
	;

delete_rule
	:	ON DELETE referential_action
	;

check_constraint_definition
	:	CHECK left_paren search_condition right_paren
	;

search_condition
	:	boolean_term
	|	search_condition OR boolean_term
	;

boolean_term
	:	boolean_factor
	|	boolean_term AND boolean_factor
	;

opt_nt_126
	:	/* Nothing */
	|	NOT
	;

boolean_factor
	:	opt_nt_126 boolean_test
	;

opt_nt_128
	:	/* Nothing */
	|	NOT
	;

opt_nt_127
	:	/* Nothing */
	|	IS opt_nt_128 truth_value ']'
	;

boolean_test
	:	boolean_primary opt_nt_127
	;

boolean_primary
	:	predicate
	|	left_paren search_condition right_paren
	;

predicate
	:	comparison_predicate
	|	between_predicate
	|	in_predicate
	|	like_predicate
	|	null_predicate
	|	quantified_comparison_predicate
	|	exists_predicate
	|	match_predicate
	|	overlaps_predicate
	;

comparison_predicate
	:	row_value_constructor comp_op row_value_constructor
	;

row_value_constructor
	:	row_value_constructor_element
	|	left_paren row_value_constructor_list right_paren
	|	row_subquery
	;

row_value_constructor_element
	:	value_expression
	|	null_specification
	|	default_specification
	;

value_expression
	:	numeric_value_expression
	|	string_value_expression
	|	datetime_value_expression
	|	interval_value_expression
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

opt_nt_129
	:	/* Nothing */
	|	sign
	;

factor
	:	opt_nt_129 numeric_primary
	;

numeric_primary
	:	value_expression_primary
	|	numeric_value_function
	;

value_expression_primary
	:	unsigned_value_specification
	|	column_reference
	|	set_function_specification
	|	scalar_subquery
	|	case_expression
	|	left_paren value_expression right_paren
	|	cast_specification
	;

unsigned_value_specification
	:	unsigned_literal
	|	general_value_specification
	;

unsigned_literal
	:	unsigned_numeric_literal
	|	general_literal
	;

general_value_specification
	:	parameter_specification
	|	dynamic_parameter_specification
	|	variable_specification
	|	USER
	|	CURRENT_USER
	|	SESSION_USER
	|	SYSTEM_USER
	|	VALUE
	;

opt_nt_130
	:	/* Nothing */
	|	indicator_parameter ']'
	;

parameter_specification
	:	parameter_name opt_nt_130
	;

parameter_name
	:	colon identifier
	;

opt_nt_131
	:	/* Nothing */
	|	INDICATOR
	;

indicator_parameter
	:	opt_nt_131 parameter_name
	;

dynamic_parameter_specification
	:	question_mark
	;

opt_nt_132
	:	/* Nothing */
	|	indicator_variable ']'
	;

variable_specification
	:	embedded_variable_name opt_nt_132
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
	:	/* !! See syntax rules */
	;

c_host_identifier
	:	/* !! See syntax rules */
	;

cobol_host_identifier
	:	/* !! See syntax rules */
	;

fortran_host_identifier
	:	/* !! See syntax rules */
	;

mumps_host_identifier
	:	/* !! See syntax rules */
	;

pascal_host_identifier
	:	/* !! See syntax rules */
	;

pl_i_host_identifier
	:	/* !! See syntax rules */
	;

opt_nt_133
	:	/* Nothing */
	|	INDICATOR
	;

indicator_variable
	:	opt_nt_133 embedded_variable_name
	;

opt_nt_134
	:	/* Nothing */
	|	qualifier period
	;

column_reference
	:	opt_nt_134 column_name
	;

qualifier
	:	table_name
	|	correlation_name
	;

correlation_name
	:	identifier
	;

set_function_specification
	:	COUNT left_paren asterisk right_paren
	|	general_set_function
	;

opt_nt_135
	:	/* Nothing */
	|	set_quantifier
	;

general_set_function
	:	set_function_type left_paren opt_nt_135 value_expression right_paren
	;

set_function_type
	:	AVG
	|	MAX
	|	MIN
	|	SUM
	|	COUNT
	;

set_quantifier
	:	DISTINCT
	|	ALL
	;

scalar_subquery
	:	subquery
	;

subquery
	:	left_paren query_expression right_paren
	;

query_expression
	:	non_join_query_expression
	|	joined_table
	;

opt_nt_136
	:	/* Nothing */
	|	ALL
	;

opt_nt_137
	:	/* Nothing */
	|	corresponding_spec
	;

opt_nt_138
	:	/* Nothing */
	|	ALL
	;

opt_nt_139
	:	/* Nothing */
	|	corresponding_spec
	;

non_join_query_expression
	:	non_join_query_term
	|	query_expression UNION opt_nt_136 opt_nt_137 query_term
	|	query_expression EXCEPT opt_nt_138 opt_nt_139 query_term
	;

opt_nt_140
	:	/* Nothing */
	|	ALL
	;

opt_nt_141
	:	/* Nothing */
	|	corresponding_spec
	;

non_join_query_term
	:	non_join_query_primary
	|	query_term INTERSECT opt_nt_140 opt_nt_141 query_primary
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

opt_nt_142
	:	/* Nothing */
	|	set_quantifier
	;

query_specification
	:	SELECT opt_nt_142 select_list table_expression
	;

seq_nt_144
	:	comma select_sublist
	;

lst_nt_145
	:	seq_nt_144
	|	lst_nt_145 seq_nt_144
	;

opt_nt_143
	:	/* Nothing */
	|	lst_nt_145 ']'
	;

select_list
	:	asterisk
	|	select_sublist opt_nt_143
	;

select_sublist
	:	derived_column
	|	qualifier period asterisk
	;

opt_nt_146
	:	/* Nothing */
	|	as_clause ']'
	;

derived_column
	:	value_expression opt_nt_146
	;

opt_nt_147
	:	/* Nothing */
	|	AS
	;

as_clause
	:	opt_nt_147 column_name
	;

opt_nt_148
	:	/* Nothing */
	|	where_clause
	;

opt_nt_149
	:	/* Nothing */
	|	group_by_clause
	;

opt_nt_150
	:	/* Nothing */
	|	having_clause ']'
	;

table_expression
	:	from_clause opt_nt_148 opt_nt_149 opt_nt_150
	;

seq_nt_152
	:	comma table_reference
	;

lst_nt_153
	:	seq_nt_152
	|	lst_nt_153 seq_nt_152
	;

opt_nt_151
	:	/* Nothing */
	|	lst_nt_153 ']'
	;

from_clause
	:	FROM table_reference opt_nt_151
	;

opt_nt_154
	:	/* Nothing */
	|	correlation_specification
	;

table_reference
	:	table_name opt_nt_154
	|	derived_table correlation_specification
	|	joined_table
	;

opt_nt_155
	:	/* Nothing */
	|	AS
	;

opt_nt_156
	:	/* Nothing */
	|	left_paren derived_column_list right_paren ']'
	;

correlation_specification
	:	opt_nt_155 correlation_name opt_nt_156
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

joined_table
	:	cross_join
	|	qualified_join
	|	left_paren joined_table right_paren
	;

cross_join
	:	table_reference CROSS JOIN table_reference
	;

opt_nt_157
	:	/* Nothing */
	|	NATURAL
	;

opt_nt_158
	:	/* Nothing */
	|	join_type
	;

opt_nt_159
	:	/* Nothing */
	|	join_specification ']'
	;

qualified_join
	:	table_reference opt_nt_157 opt_nt_158 JOIN table_reference opt_nt_159
	;

opt_nt_160
	:	/* Nothing */
	|	OUTER
	;

join_type
	:	INNER
	|	outer_join_type opt_nt_160
	|	UNION
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

where_clause
	:	WHERE search_condition
	;

group_by_clause
	:	GROUP BY grouping_column_reference_list
	;

seq_nt_162
	:	comma grouping_column_reference
	;

lst_nt_163
	:	seq_nt_162
	|	lst_nt_163 seq_nt_162
	;

opt_nt_161
	:	/* Nothing */
	|	lst_nt_163 ']'
	;

grouping_column_reference_list
	:	grouping_column_reference opt_nt_161
	;

opt_nt_164
	:	/* Nothing */
	|	collate_clause ']'
	;

grouping_column_reference
	:	column_reference opt_nt_164
	;

collate_clause
	:	COLLATE collation_name
	;

collation_name
	:	qualified_name
	;

having_clause
	:	HAVING search_condition
	;

table_value_constructor
	:	VALUES table_value_constructor_list
	;

seq_nt_166
	:	comma row_value_constructor
	;

lst_nt_167
	:	seq_nt_166
	|	lst_nt_167 seq_nt_166
	;

opt_nt_165
	:	/* Nothing */
	|	lst_nt_167 ']'
	;

table_value_constructor_list
	:	row_value_constructor opt_nt_165
	;

explicit_table
	:	TABLE table_name
	;

query_term
	:	non_join_query_term
	|	joined_table
	;

opt_nt_168
	:	/* Nothing */
	|	BY left_paren corresponding_column_list right_paren ']'
	;

corresponding_spec
	:	CORRESPONDING opt_nt_168
	;

corresponding_column_list
	:	column_name_list
	;

query_primary
	:	non_join_query_primary
	|	joined_table
	;

case_expresssion
	:	case_abbreviation
	|	case_specification
	;

seq_nt_169
	:	comma value_expression
	;

lst_nt_170
	:	seq_nt_169
	|	lst_nt_170 seq_nt_169
	;

case_abbreviation
	:	NULLIF left_paren value_expression comma value_expression right_paren
	|	COALESCE left_paren value_expression lst_nt_170 right_paren
	;

case_specification
	:	simple_case
	|	searched_case
	;

lst_nt_171
	:	simple_when_clause
	|	lst_nt_171 simple_when_clause
	;

opt_nt_172
	:	/* Nothing */
	|	else_clause
	;

simple_case
	:	CASE case_operand lst_nt_171 opt_nt_172 END
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

lst_nt_173
	:	searched_when_clause
	|	lst_nt_173 searched_when_clause
	;

opt_nt_174
	:	/* Nothing */
	|	else_clause
	;

searched_case
	:	CASE lst_nt_173 opt_nt_174 END
	;

searched_when_clause
	:	WHEN search_condition THEN result
	;

cast_specification
	:	CAST left_paren cast_operand AS cast_target right_paren
	;

cast_operand
	:	value_expression
	|	NULL
	;

cast_target
	:	domain_name
	|	type_name
	;

numeric_value_function
	:	position_expression
	|	extract_expression
	|	length_expression
	;

position_expression
	:	POSITION left_paren character_value_expression IN character_value_expression right_paren
	;

character_value_expression
	:	concatenation
	|	character_factor
	;

concatenation
	:	character_value_expression concatenation_operator character_factor
	;

opt_nt_175
	:	/* Nothing */
	|	collate_clause ']'
	;

character_factor
	:	character_primary opt_nt_175
	;

character_primary
	:	value_expression_primary
	|	string_value_function
	;

string_value_function
	:	character_value_function
	|	bit_value_function
	;

character_value_function
	:	character_substring_function
	|	fold
	|	form_of_use_conversion
	|	character_translation
	|	trim_function
	;

opt_nt_176
	:	/* Nothing */
	|	FOR string_length
	;

character_substring_function
	:	SUBSTRING left_paren character_value_expression FROM start_position opt_nt_176 right_paren
	;

start_position
	:	numeric_value_expression
	;

string_length
	:	numeric_value_expression
	;

seq_nt_177
	:	UPPER
	|	LOWER
	;

fold
	:	seq_nt_177 left_paren character_value_expression right_paren
	;

form_of_use_conversion
	:	CONVERT left_paren character_value_expression USING form_of_use_conversion_name right_paren
	;

form_of_use_conversion_name
	:	qualified_name
	;

character_translation
	:	TRANSLATE left_paren character_value_expression USING translation_name right_paren
	;

translation_name
	:	qualified_name
	;

trim_function
	:	TRIM left_paren trim_operands right_paren
	;

opt_nt_179
	:	/* Nothing */
	|	trim_specification
	;

opt_nt_180
	:	/* Nothing */
	|	trim_character
	;

opt_nt_178
	:	/* Nothing */
	|	opt_nt_179 opt_nt_180 FROM
	;

trim_operands
	:	opt_nt_178 trim_source
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

bit_value_function
	:	bit_substring_function
	;

opt_nt_181
	:	/* Nothing */
	|	FOR string_length
	;

bit_substring_function
	:	SUBSTRING left_paren bit_value_expression FROM start_position opt_nt_181 right_paren
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

extract_expression
	:	EXTRACT left_paren extract_field FROM extract_source right_paren
	;

extract_field
	:	datetime_field
	|	time_zone_field
	;

datetime_field
	:	non_second_datetime_field
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

opt_nt_182
	:	/* Nothing */
	|	sign
	;

interval_factor
	:	opt_nt_182 interval_primary
	;

opt_nt_183
	:	/* Nothing */
	|	interval_qualifier ']'
	;

interval_primary
	:	value_expression_primary opt_nt_183
	;

interval_term_2
	:	interval_term
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

opt_nt_184
	:	/* Nothing */
	|	time_zone ']'
	;

datetime_factor
	:	datetime_primary opt_nt_184
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
	|	TIME ZONE interval_value_expression
	;

length_expression
	:	char_length_expression
	|	octet_length_expression
	|	bit_length_expression
	;

seq_nt_185
	:	CHAR_LENGTH
	|	CHARACTER_LENGTH
	;

char_length_expression
	:	seq_nt_185 left_paren string_value_expression right_paren
	;

string_value_expression
	:	character_value_expression
	|	bit_value_expression
	;

octet_length_expression
	:	OCTET_LENGTH left_paren string_value_expression right_paren
	;

bit_length_expression
	:	BIT_LENGTH left_paren string_value_expression right_paren
	;

null_specification
	:	NULL
	;

default_specification
	:	DEFAULT
	;

seq_nt_187
	:	comma row_value_constructor_element
	;

lst_nt_188
	:	seq_nt_187
	|	lst_nt_188 seq_nt_187
	;

opt_nt_186
	:	/* Nothing */
	|	lst_nt_188 ']'
	;

row_value_constructor_list
	:	row_value_constructor_element opt_nt_186
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

opt_nt_189
	:	/* Nothing */
	|	NOT
	;

between_predicate
	:	row_value_constructor opt_nt_189 BETWEEN row_value_constructor AND row_value_constructor
	;

opt_nt_190
	:	/* Nothing */
	|	NOT
	;

in_predicate
	:	row_value_constructor opt_nt_190 IN in_predicate_value
	;

in_predicate_value
	:	table_subquery
	|	left_paren in_value_list right_paren
	;

seq_nt_191
	:	comma value_expression
	;

lst_nt_192
	:	seq_nt_191
	|	lst_nt_192 seq_nt_191
	;

in_value_list
	:	value_expression lst_nt_192
	;

opt_nt_193
	:	/* Nothing */
	|	NOT
	;

opt_nt_194
	:	/* Nothing */
	|	ESCAPE escape_character ']'
	;

like_predicate
	:	match_value opt_nt_193 LIKE pattern opt_nt_194
	;

match_value
	:	character_value_expression
	;

pattern
	:	character_value_expression
	;

escape_character
	:	character_value_expression
	;

opt_nt_195
	:	/* Nothing */
	|	NOT
	;

null_predicate
	:	IS opt_nt_195 NULL
	;

quantified_comparison_predicate
	:	row_value_constuctor comp_op quantifier table_subquery
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

opt_nt_196
	:	/* Nothing */
	|	UNIQUE
	;

opt_nt_197
	:	/* Nothing */
	|	PARTIAL
	|	FULL
	;

match_predicate
	:	row_value_constructor MATCH opt_nt_196 opt_nt_197 table_subquery
	;

overlaps_predicate
	:	row_value_constructor_1 OVERLAPS row_value_constructor_2
	;

row_value_constructor_1
	:	row_value_constructor
	;

row_value_constructor_2
	:	row_value_constructor
	;

truth_value
	:	TRUE
	|	FALSE
	|	UNKNOWN
	;

opt_nt_199
	:	/* Nothing */
	|	NOT
	;

opt_nt_198
	:	/* Nothing */
	|	opt_nt_199 DEFERRABLE
	;

opt_nt_200
	:	/* Nothing */
	|	NOT
	;

opt_nt_201
	:	/* Nothing */
	|	constraint_check_time ']'
	;

constraint_attributes
	:	constraint_check_time opt_nt_198
	|	opt_nt_200 DEFERRABLE opt_nt_201
	;

constraint_check_time
	:	INITIALLY DEFERRED
	|	INITIALLY IMMEDIATE
	;

opt_nt_202
	:	/* Nothing */
	|	constraint_name_definition
	;

opt_nt_203
	:	/* Nothing */
	|	constraint_check_time ']'
	;

table_constraint_definition
	:	opt_nt_202 table_constraint opt_nt_203
	;

table_constraint
	:	unique_constraint_definition
	|	referential_constraint_definition
	|	check_constraint_definition
	;

unique_constraint_definition
	:	unique_specification left_paren unique_column_list right_paren
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

module_contents
	:	declare_cursor
	|	dynamic_declare_cursor
	|	procedure
	;

opt_nt_204
	:	/* Nothing */
	|	INSENSITIVE
	;

opt_nt_205
	:	/* Nothing */
	|	SCROLL
	;

declare_cursor
	:	DECLARE cursor_name opt_nt_204 opt_nt_205 CURSOR FOR cursor_specification
	;

cursor_name
	:	identifier
	;

opt_nt_206
	:	/* Nothing */
	|	order_by_clause
	;

opt_nt_207
	:	/* Nothing */
	|	updatability_clause ']'
	;

cursor_specification
	:	query_expression opt_nt_206 opt_nt_207
	;

order_by_clause
	:	ORDER BY sort_specification_list
	;

seq_nt_209
	:	comma sort_specification
	;

lst_nt_210
	:	seq_nt_209
	|	lst_nt_210 seq_nt_209
	;

opt_nt_208
	:	/* Nothing */
	|	lst_nt_210 ']'
	;

sort_specification_list
	:	sort_specification opt_nt_208
	;

opt_nt_211
	:	/* Nothing */
	|	collate_clause
	;

opt_nt_212
	:	/* Nothing */
	|	ordering_specification ']'
	;

sort_specification
	:	sort_key opt_nt_211 opt_nt_212
	;

sort_key
	:	column_name
	|	unsigned_integer
	;

ordering_specification
	:	ASC
	|	DESC
	;

opt_nt_214
	:	/* Nothing */
	|	OF column_name_list
	;

seq_nt_213
	:	READ ONLY
	|	UPDATE opt_nt_214 '}'
	;

updatability_clause
	:	FOR seq_nt_213
	;

opt_nt_215
	:	/* Nothing */
	|	INSENSITIVE
	;

opt_nt_216
	:	/* Nothing */
	|	SCROLL
	;

dynamic_declare_cursor
	:	DECLARE cursor_name opt_nt_215 opt_nt_216 CURSOR FOR statement_name
	;

statement_name
	:	identifier
	;

procedure
	:	PROCEDURE procedure_name parameter_declaration_list semicolon sql_procedure_statement semicolon
	;

procedure_name
	:	identifier
	;

seq_nt_218
	:	comma parameter_declaration
	;

lst_nt_219
	:	seq_nt_218
	|	lst_nt_219 seq_nt_218
	;

opt_nt_217
	:	/* Nothing */
	|	lst_nt_219
	;

parameter_declaration_list
	:	left_paren parameter_declaration opt_nt_217 right_paren
	;

parameter_declaration
	:	parameter_name data_type
	|	status_parameter
	;

status_parameter
	:	SQLCODE
	|	SQLSTATE
	;

sql_procedure_statement
	:	sql_schema_statement
	|	sql_data_statement
	|	sql_transaction_statement
	|	sql_connection_statement
	|	sql_session_statement
	|	sql_dynamic_statement
	|	sql_diagnostics_statement
	;

sql_schema_statement
	:	sql_schema_definition_statement
	|	sql_schema_manipulation_statement
	;

sql_schema_definition_statement
	:	schema_definition
	|	table_definition
	|	view_definition
	|	grant_statement
	|	domain_definition
	|	character_set_definition
	|	collation_definition
	|	translation_definition
	|	assertion_definition
	;

opt_nt_220
	:	/* Nothing */
	|	schema_character_set_specification
	;

lst_nt_222
	:	schema_element
	|	lst_nt_222 schema_element
	;

opt_nt_221
	:	/* Nothing */
	|	lst_nt_222 ']'
	;

schema_definition
	:	CREATE SCHEMA schema_name_clause opt_nt_220 opt_nt_221
	;

schema_name_clause
	:	schema_name
	|	AUTHORIZATION schema_authorization_identifier
	|	schema_name AUTHORIZATION schema_authorization_identifier
	;

schema_authorization_identifier
	:	authorization_identifier
	;

schema_character_set_specification
	:	DEFAULT CHARACTER SET character_set_specification
	;

schema_element
	:	domain_definition
	|	table_definition
	|	view_definition
	|	grant_statement
	|	assertion_definition
	|	character_set_definition
	|	collation_definition
	|	translation_definition
	;

opt_nt_223
	:	/* Nothing */
	|	AS
	;

opt_nt_224
	:	/* Nothing */
	|	default_clause
	;

opt_nt_225
	:	/* Nothing */
	|	domain_constraint
	;

opt_nt_226
	:	/* Nothing */
	|	collate_clause ']'
	;

domain_definition
	:	CREATE DOMAIN domain_name opt_nt_223 data_type opt_nt_224 opt_nt_225 opt_nt_226
	;

opt_nt_227
	:	/* Nothing */
	|	constraint_name_definition
	;

opt_nt_228
	:	/* Nothing */
	|	constraint_attributes ']'
	;

domain_constraint
	:	opt_nt_227 check_constraint_definition opt_nt_228
	;

seq_nt_230
	:	GLOBAL
	|	LOCAL
	;

opt_nt_229
	:	/* Nothing */
	|	seq_nt_230 TEMPORARY
	;

seq_nt_232
	:	DELETE
	|	PRESERVE
	;

opt_nt_231
	:	/* Nothing */
	|	ON COMMIT seq_nt_232 ROWS ']'
	;

table_definition
	:	CREATE opt_nt_229 TABLE table_name table_element_list opt_nt_231
	;

opt_nt_233
	:	/* Nothing */
	|	left_paren view_column_list right_paren
	;

opt_nt_235
	:	/* Nothing */
	|	levels_clause
	;

opt_nt_234
	:	/* Nothing */
	|	WITH opt_nt_235 CHECK OPTION ']'
	;

view_definition
	:	CREATE VIEW table_name opt_nt_233 AS query_expression opt_nt_234
	;

view_column_list
	:	column_name_list
	;

levels_clause
	:	CASCADED
	|	LOCAL
	;

seq_nt_237
	:	comma grantee
	;

lst_nt_238
	:	seq_nt_237
	|	lst_nt_238 seq_nt_237
	;

opt_nt_236
	:	/* Nothing */
	|	lst_nt_238
	;

opt_nt_239
	:	/* Nothing */
	|	WITH GRANT OPTION ']'
	;

grant_statement
	:	GRANT privileges ON object_name TO grantee opt_nt_236 opt_nt_239
	;

privileges
	:	ALL PRIVILEGES
	|	action_list
	;

seq_nt_241
	:	comma action
	;

opt_nt_240
	:	/* Nothing */
	|	seq_nt_241
	;

action_list
	:	action opt_nt_240
	;

opt_nt_242
	:	/* Nothing */
	|	left_paren privilege_column_list right_paren
	;

opt_nt_243
	:	/* Nothing */
	|	left_paren privilege_column_list right_paren
	;

opt_nt_244
	:	/* Nothing */
	|	left_paren privilege_column_list right_paren
	;

action
	:	SELECT
	|	DELETE
	|	INSERT opt_nt_242
	|	UPDATE opt_nt_243
	|	REFERENCES opt_nt_244
	|	USAGE
	;

privilege_column_list
	:	column_name_list
	;

opt_nt_245
	:	/* Nothing */
	|	TABLE
	;

object_name
	:	opt_nt_245 table_name
	|	DOMAIN domain_name
	|	COLLATION collation_name
	|	CHARACTER SET character_set_name
	|	TRANSLATION translation_name
	;

opt_nt_246
	:	/* Nothing */
	|	constraint_attributes ']'
	;

assertion_definition
	:	CREATE ASSERTION constraint_name assertion_check opt_nt_246
	;

assertion_check
	:	CHECK left_paren search_condition right_paren
	;

opt_nt_247
	:	/* Nothing */
	|	AS
	;

opt_nt_248
	:	/* Nothing */
	|	collate_clause
	|	limited_collation_definition ']'
	;

character_set_definition
	:	CREATE CHARACTER SET character_set_name opt_nt_247 character_set_source opt_nt_248
	;

character_set_source
	:	GET existing_character_set_name
	;

existing_character_set_name
	:	standard_character_repertoire_name
	|	implementation_defined_character_repertoire_name
	|	schema_character_set_name
	;

schema_character_set_name
	:	character_set_name
	;

limited_collation_definition
	:	COLLATION FROM collation_source
	;

collation_source
	:	collating_sequence_definition
	|	translation_collation
	;

collating_sequence_definition
	:	external_collation
	|	schema_collation_name
	|	DESC left_paren collation_name right_paren
	|	DEFAULT
	;

external_collation
	:	EXTERNAL left_paren quote external_collation_name quote right_paren
	;

external_collation_name
	:	standard_collation_name
	|	implementation_defined_collation_name
	;

standard_collation_name
	:	collation_name
	;

implementation_defined_collation_name
	:	collation_name
	;

schema_collation_name
	:	collation_name
	;

opt_nt_249
	:	/* Nothing */
	|	THEN COLLATION collation_name ']'
	;

translation_collation
	:	TRANSLATION translation_name opt_nt_249
	;

opt_nt_250
	:	/* Nothing */
	|	pad_attribute ']'
	;

collation_definition
	:	CREATE COLLATION collation_name FOR character_set_specification FROM collation_source opt_nt_250
	;

pad_attribute
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
	:	translation_specification
	;

translation_specification
	:	external_translation
	|	IDENTITY
	|	schema_translation_name
	;

external_translation
	:	EXTERNAL left_paren quote external_translation_name quote right_paren
	;

external_translation_name
	:	standard_translation_name
	|	implementation_defined_translation_name
	;

standard_translation_name
	:	translation_name
	;

implementation_defined_translation_name
	:	translation_name
	;

schema_translation_name
	:	translation_name
	;

sql_schema_manipulation_statement
	:	drop_schema_statement
	|	alter_table_statement
	|	drop_table_statement
	|	drop_view_statement
	|	revoke_statement
	|	alter_domain_statement
	|	drop_domain_statement
	|	drop_character_set_statement
	|	drop_collation_statement
	|	drop_translation_statement
	|	drop_assertion_statement
	;

drop_schema_statement
	:	DROP SCHEMA schema_name drop_behaviour
	;

drop_behaviour
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

opt_nt_251
	:	/* Nothing */
	|	COLUMN
	;

add_column_definition
	:	ADD opt_nt_251 column_definition
	;

opt_nt_252
	:	/* Nothing */
	|	COLUMN
	;

alter_column_definition
	:	ALTER opt_nt_252 column_name alter_column_action
	;

alter_column_action
	:	set_column_default_clause
	|	drop_column_default_clause
	;

set_column_default_clause
	:	SET default_clause
	;

drop_column_default_clause
	:	DROP DEFAULT
	;

opt_nt_253
	:	/* Nothing */
	|	COLUMN
	;

drop_column_definition
	:	DROP opt_nt_253 column_name drop_behaviour
	;

add_table_constraint_definition
	:	ADD table_constraint_definition
	;

drop_table_constraint_definition
	:	DROP CONSTRAINT constraint_name drop_behaviour
	;

drop_table_statement
	:	DROP TABLE table_name drop_behaviour
	;

drop_view_statement
	:	DROP VIEW table_name drop_behaviour
	;

opt_nt_254
	:	/* Nothing */
	|	GRANT OPTION FOR
	;

seq_nt_256
	:	comma grantee
	;

lst_nt_257
	:	seq_nt_256
	|	lst_nt_257 seq_nt_256
	;

opt_nt_255
	:	/* Nothing */
	|	lst_nt_257
	;

revoke_statement
	:	REVOKE opt_nt_254 privileges ON object_name FROM grantee opt_nt_255 drop_behaviour
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
	:	DROP DOMAIN domain_name drop_behaviour
	;

drop_character_set_statement
	:	DROP CHARACTER SET character_set_name
	;

drop_collation_statement
	:	DROP COLLATION collation_name
	;

drop_translation_statement
	:	DROP TRANSLATION translation_name
	;

drop_assertion_statement
	:	DROP ASSERTION constraint_name
	;

sql_data_statement
	:	open_statement
	|	fetch_statement
	|	close_statement
	|	select_statement_single_row
	|	sql_data_change_statement
	;

open_statement
	:	OPEN cursor_name
	;

opt_nt_259
	:	/* Nothing */
	|	fetch_orientation
	;

opt_nt_258
	:	/* Nothing */
	|	opt_nt_259 FROM
	;

fetch_statement
	:	FETCH opt_nt_258 cursor_name INTO fetch_target_list
	;

seq_nt_260
	:	ABSOLUTE
	|	RELATIVE
	;

fetch_orientation
	:	NEXT
	|	PRIOR
	|	FIRST
	|	LAST
	|	seq_nt_260 simple_value_specification
	;

simple_value_specification
	:	parameter_name
	|	embedded_variable_name
	|	literal
	;

seq_nt_262
	:	comma target_specification
	;

lst_nt_263
	:	seq_nt_262
	|	lst_nt_263 seq_nt_262
	;

opt_nt_261
	:	/* Nothing */
	|	lst_nt_263 ']'
	;

fetch_target_list
	:	target_specification opt_nt_261
	;

target_specification
	:	parameter_specification
	|	variable_specification
	;

close_statement
	:	CLOSE cursor_name
	;

opt_nt_264
	:	/* Nothing */
	|	set_quantifier
	;

select_statement_single_row
	:	SELECT opt_nt_264 select_list INTO select_target_list table_expression
	;

seq_nt_266
	:	comma target_specification
	;

lst_nt_267
	:	seq_nt_266
	|	lst_nt_267 seq_nt_266
	;

opt_nt_265
	:	/* Nothing */
	|	lst_nt_267 ']'
	;

select_target_list
	:	target_specification opt_nt_265
	;

sql_data_change_statement
	:	delete_statement_positioned
	|	delete_statement_searched
	|	insert_statement
	|	update_statement_positioned
	|	update_statement_searched
	;

delete_statement_positioned
	:	DELETE FROM table_name WHERE CURRENT OF cursor_name
	;

opt_nt_268
	:	/* Nothing */
	|	WHERE search_condition ']'
	;

delete_statement_searched
	:	DELETE FROM table_name opt_nt_268
	;

insert_statement
	:	INSERT INTO table_name insert_columns_and_source
	;

opt_nt_269
	:	/* Nothing */
	|	left_paren insert_column_list right_paren
	;

insert_columns_and_source
	:	opt_nt_269 query_expression
	|	DEFAULT VALUES
	;

insert_column_list
	:	column_name_list
	;

update_statement_positioned
	:	UPDATE table_name SET set_clause_list WHERE CURRENT OF cursor_name
	;

seq_nt_271
	:	comma set_clause
	;

lst_nt_272
	:	seq_nt_271
	|	lst_nt_272 seq_nt_271
	;

opt_nt_270
	:	/* Nothing */
	|	lst_nt_272 ']'
	;

set_clause_list
	:	set_clause opt_nt_270
	;

set_clause
	:	object_column equals_operator update_source
	;

object_column
	:	column_name
	;

update_source
	:	value_expression
	|	null_specification
	|	DEFAULT
	;

opt_nt_273
	:	/* Nothing */
	|	WHERE search_condition ']'
	;

update_statement_searched
	:	UPDATE table_name SET set_clause_list opt_nt_273
	;

sql_transaction_statement
	:	set_transaction_statement
	|	set_constraints_mode_statement
	|	commit_statement
	|	rollback_statement
	;

seq_nt_275
	:	comma transaction_mode
	;

lst_nt_276
	:	seq_nt_275
	|	lst_nt_276 seq_nt_275
	;

opt_nt_274
	:	/* Nothing */
	|	lst_nt_276 ']'
	;

set_transaction_statement
	:	SET TRANSACTION transaction_mode opt_nt_274
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

seq_nt_277
	:	DEFERRED
	|	IMMEDIATE '}'
	;

set_constraints_mode_statement
	:	SET CONSTRAINTS constraint_name_list seq_nt_277
	;

seq_nt_279
	:	comma constraint_name
	;

lst_nt_280
	:	seq_nt_279
	|	lst_nt_280 seq_nt_279
	;

opt_nt_278
	:	/* Nothing */
	|	lst_nt_280 ']'
	;

constraint_name_list
	:	ALL
	|	constraint_name opt_nt_278
	;

opt_nt_281
	:	/* Nothing */
	|	WORK ']'
	;

commit_statement
	:	COMMIT opt_nt_281
	;

opt_nt_282
	:	/* Nothing */
	|	WORK ']'
	;

rollback_statement
	:	ROLLBACK opt_nt_282
	;

sql_connection_statement
	:	connect_statement
	|	set_connection_statement
	|	disconnect_statement
	;

connect_statement
	:	CONNECT TO connection_target
	;

opt_nt_283
	:	/* Nothing */
	|	AS connection_name
	;

opt_nt_284
	:	/* Nothing */
	|	USER user_name
	;

connection_target
	:	sql_server_name opt_nt_283 opt_nt_284
	|	DEFAULT
	;

sql_server_name
	:	simple_value_specification
	;

connection_name
	:	simple_value_specification
	;

user_name
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
	:	set_catalog_statement
	|	set_schema_statement
	|	set_names_statement
	|	set_session_authorization_identifier_statement
	|	set_local_time_zone_statement
	;

set_catalog_statement
	:	SET CATALOG value_specification
	;

value_specification
	:	literal
	|	general_value_specification
	;

set_schema_statement
	:	SET SCHEMA value_specification
	;

set_names_statement
	:	SET NAMES value_specification
	;

set_session_authorization_identifier_statement
	:	SET SESSION AUTHORIZATION value_specification
	;

set_local_time_zone_statement
	:	SET TIME ZONE set_time_zone_value
	;

set_time_zone_value
	:	interval_value_expression
	|	LOCAL
	;

sql_dynamic_statement
	:	system_descriptor_statement
	|	prepare_statement
	|	deallocate_prepared_statement
	|	desribe_statement
	|	execute_statement
	|	execute_immediate_statement
	|	sql_dynamic_data_statement
	;

system_descriptor_statement
	:	allocate_descriptor_statement
	|	deallocate_descriptor_statement
	|	get_descriptor_statement
	|	set_descriptor_statement
	;

opt_nt_285
	:	/* Nothing */
	|	WITH MAX occurrences ']'
	;

allocate_descriptor_statement
	:	ALLOCATE DESCRIPTOR descriptor_name opt_nt_285
	;

opt_nt_286
	:	/* Nothing */
	|	scope_option
	;

descriptor_name
	:	opt_nt_286 simple_value_specification
	;

scope_option
	:	GLOBAL
	|	LOCAL
	;

occurrences
	:	simple_value_specification
	;

deallocate_descriptor_statement
	:	DEALLOCATE DESCRIPTOR descriptor_name
	;

set_descriptor_statement
	:	SET DESCRIPTOR descriptor_name set_descriptor_information
	;

seq_nt_288
	:	comma set_item_information
	;

lst_nt_289
	:	seq_nt_288
	|	lst_nt_289 seq_nt_288
	;

opt_nt_287
	:	/* Nothing */
	|	lst_nt_289 ']'
	;

set_descriptor_information
	:	set_count
	|	VALUE item_number set_item_information opt_nt_287
	;

set_count
	:	COUNT equals_operator simple_value_specification_1
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
	:	TYPE
	|	LENGTH
	|	OCTET_LENGTH
	|	RETURNED_LENGTH
	|	RETURNED_OCTET_LENGTH
	|	PRECISION
	|	SCALE
	|	DATETIME_INTERVAL_CODE
	|	DATETIME_INTERVAL_PRECISION
	|	NULLABLE
	|	INDICATOR
	|	DATA
	|	NAME
	|	UNNAMED
	|	COLLATION_CATALOG
	|	COLLATION_SCHEMA
	|	COLLATION_NAME
	|	CHARACTER_SET_CATALOG
	|	CHARACTER_SET_SCHEMA
	|	CHARACTER_SET_NAME
	;

simple_value_specification_2
	:	simple_value_specification
	;

get_descriptor_statement
	:	GET DESCRIPTOR descriptor_name get_descriptor_information
	;

seq_nt_291
	:	comma get_item_information
	;

lst_nt_292
	:	seq_nt_291
	|	lst_nt_292 seq_nt_291
	;

opt_nt_290
	:	/* Nothing */
	|	lst_nt_292 ']'
	;

get_descriptor_information
	:	get_count
	|	VALUE item_number get_item_information opt_nt_290
	;

get_count
	:	simple_target_specification_1 equals_operator COUNT
	;

simple_target_specification_1
	:	simple_target_specification
	;

simple_target_specification
	:	parameter_name
	|	embedded_variable_name
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

opt_nt_293
	:	/* Nothing */
	|	scope_option
	;

extended_statement_name
	:	opt_nt_293 simple_value_specification
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

describe_input_statement
	:	DESCRIBE INPUT sql_statement_name using_descriptor
	;

seq_nt_294
	:	USING
	|	INTO
	;

using_descriptor
	:	seq_nt_294 SQL DESCRIPTOR descriptor_name
	;

opt_nt_295
	:	/* Nothing */
	|	OUTPUT
	;

describe_output_statement
	:	DESCRIBE opt_nt_295 sql_statement_name using_descriptor
	;

opt_nt_296
	:	/* Nothing */
	|	result_using_clause
	;

opt_nt_297
	:	/* Nothing */
	|	parameter_using_clause ']'
	;

execute_statement
	:	EXECUTE sql_statement_name opt_nt_296 opt_nt_297
	;

result_using_clause
	:	using_clause
	;

using_clause
	:	using_arguments
	|	using_descriptor
	;

seq_nt_298
	:	USING
	|	INTO
	;

seq_nt_300
	:	comma argument
	;

lst_nt_301
	:	seq_nt_300
	|	lst_nt_301 seq_nt_300
	;

opt_nt_299
	:	/* Nothing */
	|	lst_nt_301 ']'
	;

using_arguments
	:	seq_nt_298 argument opt_nt_299
	;

argument
	:	target_specification
	;

parameter_using_clause
	:	using_clause
	;

execute_immediate_statement
	:	EXECUTE IMMEDIATE sql_statement_variable
	;

sql_dynamic_data_statement
	:	allocate_cursor_statement
	|	dynamic_open_statement
	|	dynamic_close_statement
	|	dynamic_fetch_statement
	|	dynamic_delete_statement_positioned
	|	dynamic_update_statement_positioned
	;

opt_nt_302
	:	/* Nothing */
	|	INSENSITIVE
	;

opt_nt_303
	:	/* Nothing */
	|	SCROLL
	;

allocate_cursor_statement
	:	ALLOCATE extended_cursor_name opt_nt_302 opt_nt_303 CURSOR FOR extended_statement_name
	;

opt_nt_304
	:	/* Nothing */
	|	scope_option
	;

extended_cursor_name
	:	opt_nt_304 simple_value_specification
	;

opt_nt_305
	:	/* Nothing */
	|	using_clause ']'
	;

dynamic_open_statement
	:	OPEN dynamic_cursor_name opt_nt_305
	;

dynamic_cursor_name
	:	cursor_name
	|	extended_cursor_name
	;

dynamic_close_statement
	:	CLOSE dynamic_cursor_name
	;

opt_nt_307
	:	/* Nothing */
	|	fetch_orientation
	;

opt_nt_306
	:	/* Nothing */
	|	opt_nt_307 FROM
	;

dynamic_fetch_statement
	:	FETCH opt_nt_306 dynamic_cursor_name
	;

dynamic_delete_statement_positioned
	:	DELETE FROM table_name WHERE CURRENT OF dynamic_cursor_name
	;

seq_nt_309
	:	comma set_clause
	;

lst_nt_310
	:	seq_nt_309
	|	lst_nt_310 seq_nt_309
	;

opt_nt_308
	:	/* Nothing */
	|	lst_nt_310
	;

dynamic_update_statement_positioned
	:	UPDATE table_name SET set_clause opt_nt_308 WHERE CURRENT OF dynamic_cursor_name
	;

sql_diagnostics_statement
	:	get_diagnostics_statement
	;

get_diagnostics_statement
	:	GET DIAGNOSTICS sql_diagnostics_information
	;

sql_diagnostics_information
	:	statement_information
	|	condition_information
	;

seq_nt_312
	:	comma statement_information_item
	;

lst_nt_313
	:	seq_nt_312
	|	lst_nt_313 seq_nt_312
	;

opt_nt_311
	:	/* Nothing */
	|	lst_nt_313 ']'
	;

statement_information
	:	statement_information_item opt_nt_311
	;

statement_information_item
	:	simple_target_specification equals_operator statement_information_item_name
	;

statement_information_item_name
	:	NUMBER
	|	MORE
	|	COMMAND_FUNCTION
	|	DYNAMIC_FUNCTION
	|	ROW_COUNT
	;

seq_nt_315
	:	comma condition_information_item
	;

lst_nt_316
	:	seq_nt_315
	|	lst_nt_316 seq_nt_315
	;

opt_nt_314
	:	/* Nothing */
	|	lst_nt_316 ']'
	;

condition_information
	:	EXCEPTION condition_number condition_information_item opt_nt_314
	;

condition_number
	:	simple_value_specification
	;

condition_information_item
	:	simple_target_specification equals_operator condition_information_item_name
	;

condition_information_item_name
	:	CONDITION_NUMBER
	|	RETURNED_SQLSTATE
	|	CLASS_ORIGIN
	|	SUBCLASS_ORIGIN
	|	SERVER_NAME
	|	CONNECTION_NAME
	|	CONSTRATIN_CATALOG
	|	CONSTRAINT_SCHEMA
	|	CONSTRAINT_NAME
	|	CATALOG_NAME
	|	SCHEMA_NAME
	|	TABLE_NAME
	|	COLUMN_NAME
	|	CURSOR_NAME
	|	MESSAGE_TEXT
	|	MESSAGE_LENGTH
	|	MESSAGE_OCTET_LENGTH
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
	:	/* !! See the syntax rules */
	;

embedded_sql_c_program
	:	/* !! See the syntax rules */
	;

embedded_sql_cobol_program
	:	/* !! See the syntax rules */
	;

embedded_sql_fortran_program
	:	/* !! See the syntax rules */
	;

embedded_sql_mumps_program
	:	/* !! See the syntax rules */
	;

embedded_sql_pascal_program
	:	/* !! See the syntax rules */
	;

embedded_sql_pl_i_program
	:	/* !! See the syntax rules */
	;

opt_nt_317
	:	/* Nothing */
	|	embedded_character_set_declaration
	;

lst_nt_319
	:	host_variable_definition
	|	lst_nt_319 host_variable_definition
	;

opt_nt_318
	:	/* Nothing */
	|	lst_nt_319
	;

embedded_sql_declare_section
	:	embedded_sql_begin_declare opt_nt_317 opt_nt_318 embedded_sql_end_declare
	|	embedded_sql_mumps_declare
	;

opt_nt_320
	:	/* Nothing */
	|	sql_terminator ']'
	;

embedded_sql_begin_declare
	:	sql_prefix BEGIN DECLARE SECTION opt_nt_320
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

seq_nt_322
	:	comma ada_host_identifier
	;

lst_nt_323
	:	seq_nt_322
	|	lst_nt_323 seq_nt_322
	;

opt_nt_321
	:	/* Nothing */
	|	lst_nt_323
	;

ada_variable_definition
	:	ada_host_identifier opt_nt_321
	;

ada_type_specification
	:	ada_qualified_type_specification
	|	ada_unqualified_type_specification
	;

opt_nt_325
	:	/* Nothing */
	|	IS
	;

opt_nt_324
	:	/* Nothing */
	|	CHARACTER SET opt_nt_325 character_set_specification
	;

ada_qualified_type_specification
	:	SQL_STANDARD.CHAR opt_nt_324 left_paren 1 double_period length right_paren
	|	SQL_STANDARD.BIT left_paren 1 double_period length right_paren
	|	SQL_STANDARD.SMALLINT
	|	SQL_STANDARD.INT
	|	SQL_STANDARD.REAL
	|	SQL_STANDARD.DOUBLE_PRECISION
	|	SQL_STANDARD.SQLCODE_TYPE
	|	SQL_STANDARD.SQLSTATE_TYPE
	|	SQL_STANDARD.INDICATOR_TYPE
	;

ada_unqualified_type_specification
	:	CHAR left_paren 1 double_period length right_paren
	|	BIT left_paren 1 double_period length right_paren
	|	SMALLINT
	|	INT
	|	REAL
	|	DOUBLE_PRECISION
	|	SQLCODE_TYPE
	|	SQLSTATE_TYPE
	|	INDICATOR_TYPE
	;

ada_initial_value
	:	ada_assignment_operator character_representation
	;

ada_assignment_operator
	:	colon equals_operator
	;

opt_nt_326
	:	/* Nothing */
	|	c_storage_class
	;

opt_nt_327
	:	/* Nothing */
	|	c_class_modifier
	;

c_variable_definition
	:	opt_nt_326 opt_nt_327 c_variable_specification semicolon
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

seq_nt_328
	:	long
	|	short
	|	float
	|	double
	;

opt_nt_329
	:	/* Nothing */
	|	c_initial_value
	;

opt_nt_332
	:	/* Nothing */
	|	c_initial_value
	;

seq_nt_331
	:	comma c_host_identifier opt_nt_332
	;

lst_nt_333
	:	seq_nt_331
	|	lst_nt_333 seq_nt_331
	;

opt_nt_330
	:	/* Nothing */
	|	lst_nt_333 ']'
	;

c_numeric_variable
	:	seq_nt_328 c_host_identifier opt_nt_329 opt_nt_330
	;

c_initial_value
	:	equals_operator character_representation
	;

opt_nt_335
	:	/* Nothing */
	|	IS
	;

opt_nt_334
	:	/* Nothing */
	|	CHARACTER SET opt_nt_335 character_set_specification
	;

opt_nt_336
	:	/* Nothing */
	|	c_initial_value
	;

opt_nt_339
	:	/* Nothing */
	|	c_initial_value
	;

seq_nt_338
	:	comma c_host_identifier c_array_specification opt_nt_339
	;

lst_nt_340
	:	seq_nt_338
	|	lst_nt_340 seq_nt_338
	;

opt_nt_337
	:	/* Nothing */
	|	lst_nt_340 ']'
	;

c_character_variable
	:	char opt_nt_334 c_host_identifier c_array_specification opt_nt_336 opt_nt_337
	;

c_array_specification
	:	left_bracket length right_bracket
	;

c_derived_variable
	:	c_varchar_variable
	|	c_bit_variable
	;

opt_nt_342
	:	/* Nothing */
	|	IS
	;

opt_nt_341
	:	/* Nothing */
	|	CHARACTER SET opt_nt_342 character_set_specification
	;

opt_nt_343
	:	/* Nothing */
	|	c_initial_value
	;

opt_nt_346
	:	/* Nothing */
	|	c_initial_value
	;

seq_nt_345
	:	comma c_host_identifier c_array_specification opt_nt_346
	;

lst_nt_347
	:	seq_nt_345
	|	lst_nt_347 seq_nt_345
	;

opt_nt_344
	:	/* Nothing */
	|	lst_nt_347 ']'
	;

c_varchar_variable
	:	VARCHAR opt_nt_341 c_host_identifier c_array_specification opt_nt_343 opt_nt_344
	;

opt_nt_348
	:	/* Nothing */
	|	c_initial_value
	;

opt_nt_351
	:	/* Nothing */
	|	c_initial_value
	;

seq_nt_350
	:	comma c_host_identifier c_array_specification opt_nt_351
	;

lst_nt_352
	:	seq_nt_350
	|	lst_nt_352 seq_nt_350
	;

opt_nt_349
	:	/* Nothing */
	|	lst_nt_352 ']'
	;

c_bit_variable
	:	BIT c_host_identifier c_array_specification opt_nt_348 opt_nt_349
	;

lst_nt_353
	:	
	|	lst_nt_353 
	;

cobol_variable_definition
	:	lst_nt_353 omitted...
	;

lst_nt_354
	:	
	|	lst_nt_354 
	;

fortran_variable_definition
	:	lst_nt_354 omitted...
	;

lst_nt_355
	:	
	|	lst_nt_355 
	;

mumps_variable_definition
	:	lst_nt_355 omitted...
	;

lst_nt_356
	:	
	|	lst_nt_356 
	;

pascal_variable_definition
	:	lst_nt_356 omitted...
	;

lst_nt_357
	:	
	|	lst_nt_357 
	;

pl_i_variable_definition
	:	lst_nt_357 omitted...
	;

opt_nt_358
	:	/* Nothing */
	|	sql_terminator ']'
	;

embedded_sql_end_declare
	:	sql_prefix END DECLARE SECTION opt_nt_358
	;

opt_nt_359
	:	/* Nothing */
	|	embedded_character_set_declaration
	;

lst_nt_361
	:	host_variable_definition
	|	lst_nt_361 host_variable_definition
	;

opt_nt_360
	:	/* Nothing */
	|	lst_nt_361
	;

embedded_sql_mumps_declare
	:	sql_prefix BEGIN DECLARE SECTION opt_nt_359 opt_nt_360 END DECLARE SECTION sql_terminator
	;

opt_nt_362
	:	/* Nothing */
	|	sql_terminator ']'
	;

embedded_sql_statement
	:	sql_prefix statement_or_declaration opt_nt_362
	;

statement_or_declaration
	:	declare_cursor
	|	dynamic_declare_cursor
	|	temporary_table_declaration
	|	embedded_exception_declaration
	|	sql_procedure_statement
	;

embedded_exception_condition
	:	WHENEVER condition condition_action
	;

condition
	:	SQLERROR
	|	NOT FOUND
	;

condition_action
	:	CONTINUE
	|	go_to
	;

seq_nt_363
	:	GOTO
	|	GO TO
	;

go_to
	:	seq_nt_363 goto_target
	;

goto_target
	:	host_label_identifier
	|	unsigned_integer
	|	host_pl_i_label_variable
	;

host_label_identifier
	:	/* !! See the syntax rules */
	;

host_pl_i_label_variable
	:	/* !! See the syntax rules */
	;

preparable_statement
	:	preparable_sql_data_statement
	|	preparable_sql_schema_statement
	|	preparable_sql_transaction_statement
	|	preparable_sql_session_statement
	|	preparable_sql_implementation_defined_statement
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

opt_nt_364
	:	/* Nothing */
	|	FROM table_name
	;

preparable_dynamic_delete_statement_positioned
	:	DELETE opt_nt_364 WHERE CURRENT OF cursor_name
	;

opt_nt_365
	:	/* Nothing */
	|	table_name
	;

preparable_dynamic_update_statement_positioned
	:	UPDATE opt_nt_365 SET set_clause WHERE CURRENT OF cursor_name
	;

preparable_sql_schema_statement
	:	sql_schema_statement
	;

preparable_sql_transaction_statement
	:	sql_transaction_statement
	;

preparable_sql_session_statement
	:	sql_session_statement
	;

preparable_sql_implementation_defined_statement
	:	/* !! See the syntax rules */
	;

direct_sql_statement
	:	direct_sql_data_statement
	|	sql_schema_statement
	|	sql_transaction_statement
	|	sql_connection_statement
	|	sql_session_stateament
	|	direct_implementation_defined_statement
	;

direct_sql_data_statement
	:	delete_statement_searched
	|	direct_select_statement_multiple_rows
	|	insert_statement
	|	update_statement_searched
	|	temporary_table_declaration
	;

opt_nt_366
	:	/* Nothing */
	|	order_by_clause ']'
	;

direct_select_statement_multiple_rows
	:	query_expression opt_nt_366
	;

direct_implementation_defined_statement
	:	/* !! See the syntax rules */
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

sql_variant
	:	j_1987
	|	j_1989
	|	j_1992
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

sql_conformance
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


%%

