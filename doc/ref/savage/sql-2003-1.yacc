/*
** Derived from file sql-2003-1.bnf version 1.2 dated 2004/10/27 00:26:59
*/
/* Information taken from the Final Committee Draft (FCD) of ISO/IEC 9075-1:2003. */
/* The plain text version of this grammar is */
/* --## <a href='sql-2003-1.bnf'> sql-2003-1.bnf </a>. */
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
/*  6.3 Object identifier for Database Language SQL */
/*  Annex B (informative) SQL Packages: */
/* --## <table border=1>  */
/* --## <tr><td> 1 </td><td> PKG001 </td><td> Enhanced datetime facilities </td></tr> */
/* --## <tr><td> 2 </td><td> PKG002 </td><td> Enhanced integrity management </td></tr> */
/* --## <tr><td> 3 </td><td> PKG004 </td><td> PSM </td></tr> */
/* --## <tr><td> 4 </td><td> PKG005 </td><td> CLI </td></tr> */
/* --## <tr><td> 5 </td><td> PKG006 </td><td> Basic object support </td></tr> */
/* --## <tr><td> 6 </td><td> PKG007 </td><td> Enhanced object support </td></tr> */
/* --## <tr><td> 7 </td><td> PKG008 </td><td> Active database </td></tr> */
/* --## <tr><td> 8 </td><td> PKG009 </td><td> SQL/MM support </td></tr> */
/* --## <tr><td> 9 </td><td> PKG010 </td><td> OLAP </td></tr> */
/* --## </table> */
/*  B.1 Enhanced datetime facilities */
/* The package called "Enhanced datetime facilities" comprises the following features of the SQL */
/* language as specified in the SQL Feature Taxonomy Annex of the various parts of ISO/IEC 9075. */
/* --## <table border=1> */
/* --## <tr> <td> Feature F052 </td> <td> Intervals and datetime arithmetic </td> </tr> */
/* --## <tr> <td> Feature F411 </td> <td> Time zone specification </td> </tr> */
/* --## <tr> <td> Feature F555 </td> <td> Enhanced seconds precision </td> </tr> */
/* --## </table> */
/* B.2 Enhanced integrity management */
/* The package called "Enhanced integrity management" comprises the following features of the SQL */
/* language as specified in the SQL Feature Taxonomy Annex of the various parts of ISO/IEC 9075. */
/* --## <table border=1> */
/* --## <tr> <td> Feature F191 </td> <td> Referential delete actions </td> </tr> */
/* --## <tr> <td> Feature F521 </td> <td> Assertions </td> </tr> */
/* --## <tr> <td> Feature F701 </td> <td> Referential update actions </td> </tr> */
/* --## <tr> <td> Feature F491 </td> <td> Constraint management </td> </tr> */
/* --## <tr> <td> Feature F671 </td> <td> Subqueries in CHECK constraints </td> </tr> */
/* --## <tr> <td> Feature T201 </td> <td> Comparable data types for referential constraints </td> </tr> */
/* --## <tr> <td> Feature T211 </td> <td> Basic trigger capability </td> </tr> */
/* --## <tr> <td> Feature T212 </td> <td> Enhanced trigger capability </td> </tr> */
/* --## <tr> <td> Feature T191 </td> <td> Referential action RESTRICT </td> </tr> */
/* --## </table> */
/*  B.3 PSM */
/* The package called "PSM" comprises the following features of the SQL language as specified in the */
/* SQL Feature Taxonomy Annex of the various parts of ISO/IEC 9075. */
/* --## <table border=1> */
/* --## <tr> <td> Feature T322 </td> <td> Overloading of SQL-invoked functions and SQL-invoked procedures </td> </tr> */
/* --## <tr> <td> Feature P001 </td> <td> Stored modules </td> </tr> */
/* --## <tr> <td> Feature P002 </td> <td> Computational completeness </td> </tr> */
/* --## <tr> <td> Feature P003 </td> <td> Information Schema views </td> </tr> */
/* --## </table> */
/*  B.4 CLI */
/* The package called "CLI" comprises the following features of the SQL language as specified in the */
/* SQL Feature Taxonomy Annex of the various parts of ISO/IEC 9075. */
/* --## <table border=1> */
/* --## <tr> <td> Feature C011 </td> <td> SQL/CLI </td> </tr> */
/* --## <tr> <td> Feature C021 </td> <td> Automatic population of Implementation Parameter Descriptor </td> </tr> */
/* --## <tr> <td> Feature C041 </td> <td> Information Schema data controlled by current privileges </td> </tr> */
/* --## <tr> <td> Feature C051 </td> <td> GetData extensions </td> </tr> */
/* --## <tr> <td> Feature C061 </td> <td> GetParamData extensions </td> </tr> */
/* --## <tr> <td> Feature C071 </td> <td> Scroll Concurrency </td> </tr> */
/* --## <tr> <td> Feature C081 </td> <td> Read-only data source </td> </tr> */
/* --## </table> */
/*  B.5 Basic object support */
/* The package called "basic object support" comprises the following features of the SQL language as */
/* specified in the SQL Feature Taxonomy Annex of the various parts of ISO/IEC 9075. */
/* --## <table border=1> */
/* --## <tr> <td> Feature S023 </td> <td> Basic structured types </td> </tr> */
/* --## <tr> <td> Feature S041 </td> <td> Basic reference types </td> </tr> */
/* --## <tr> <td> Feature S051 </td> <td> Create table of type </td> </tr> */
/* --## <tr> <td> Feature S151 </td> <td> Type predicate </td> </tr> */
/* --## <tr> <td> Feature T041 </td> <td> Basic LOB data type support </td> </tr> */
/* --## </table> */
/*  B.6 Enhanced object support */
/* The package called "enhanced object support" comprises all of the features of the package called */
/* (Basic object support), plus the following features of the SQL language as specified in the SQL */
/* Feature Taxonomy Annex of the various parts of ISO/IEC 9075. */
/* --## <table border=1> */
/* --## <tr> <td> Feature S024 </td> <td> Enhanced structured types </td> </tr> */
/* --## <tr> <td> Feature S043 </td> <td> Enhanced reference types </td> </tr> */
/* --## <tr> <td> Feature S071 </td> <td> SQL-paths in function and type name resolution </td> </tr> */
/* --## <tr> <td> Feature S081 </td> <td> Subtables </td> </tr> */
/* --## <tr> <td> Feature S111 </td> <td> ONLY in query expressions </td> </tr> */
/* --## <tr> <td> Feature S161 </td> <td> Subtype treatment </td> </tr> */
/* --## <tr> <td> Feature S211 </td> <td> User-defined cast functions </td> </tr> */
/* --## <tr> <td> Feature S231 </td> <td> Structured type locators </td> </tr> */
/* --## <tr> <td> Feature S241 </td> <td> Transform functions </td> </tr> */
/* --## </table> */
/*  B.7 Active database */
/* The package called "Active database" comprises the following features of the SQL language as */
/* specified in the SQL Feature Taxonomy Annex of the various parts of ISO/IEC 9075. */
/* --## <table border=1> */
/* --## <tr> <td> Feature T211 </td> <td> Basic trigger capability </td> </tr> */
/* --## </table> */
/*  B.8 OLAP */
/* The package called "OLAP" comprises the following features of the SQL language as specified in the */
/* SQL Feature Taxonomy Annex of the various parts of ISO/IEC 9075. */
/* --## <table border=1> */
/* --## <tr> <td> Feature T431 </td> <td> Extended grouping capabilities </td> </tr> */
/* --## <tr> <td> Feature T611 </td> <td> Elementary OLAP operators </td> </tr> */
/* --## </table> */
/*  END OF SQL-2003-1 GRAMMAR */
%{
/*
** BNF Grammar for ISO/IEC 9075-1:2003 SQL/Foundation - Database Language SQL (SQL-2003)
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
%token 9075
%token High
%token IntegrityNo
%token IntegrityYes
%token Intermediate
%token Low
%token Part-nNo
%token directno
%token directyes
%token edition1987
%token edition1989
%token edition1992
%token edition1999
%token edition2003
%token embeddedAda
%token embeddedC
%token embeddedCOBOL
%token embeddedFortran
%token embeddedMUMPS
%token embeddedPLI
%token embeddedPascal
%token invokedAda
%token invokedC
%token invokedCOBOL
%token invokedFortran
%token invokedMUMPS
%token invokedPLI
%token invokedPascal
%token iso
%token moduleAda
%token moduleC
%token moduleCOBOL
%token moduleFortran
%token moduleMUMPS
%token modulePLI
%token modulePascal
%token standard

/* The following non-terminals were not defined */
%token embedded_no
%token j_200n
%token left_paren
%token module_no
%token package_pkgino
%token package_pkgiyes
%token part_10
%token part_11
%token part_3
%token part_4
%token part_7
%token part_9
%token right_paren
/* End of undefined non-terminals */

/*
%rule arc1
%rule arc2
%rule arc3
%rule bindings
%rule direct
%rule direct_no
%rule direct_yes
%rule embedded
%rule embedded_ada
%rule embedded_c
%rule embedded_cobol
%rule embedded_fortran
%rule embedded_languages
%rule embedded_mumps
%rule embedded_no
%rule embedded_pascal
%rule embedded_pl_i
%rule high
%rule integrity_no
%rule integrity_yes
%rule intermediate
%rule invoked_ada
%rule invoked_c
%rule invoked_cobol
%rule invoked_fortran
%rule invoked_mumps
%rule invoked_pascal
%rule invoked_pl_i
%rule invoked_routine_languages
%rule j_1987
%rule j_1989
%rule j_1989_base
%rule j_1989_package
%rule j_1992
%rule j_1999
%rule j_2003
%rule j_200n
%rule left_paren
%rule level
%rule low
%rule module
%rule module_ada
%rule module_c
%rule module_cobol
%rule module_fortran
%rule module_languages
%rule module_mumps
%rule module_no
%rule module_pascal
%rule module_pl_i
%rule package_pkgi
%rule package_pkgino
%rule package_pkgiyes
%rule packages
%rule part_10
%rule part_11
%rule part_3
%rule part_4
%rule part_7
%rule part_9
%rule part_n
%rule part_n_no
%rule part_n_yes
%rule parts
%rule right_paren
%rule sql_conformance
%rule sql_edition
%rule sql_object_identifier
%rule sql_provenance
%rule sql_variant
*/

%start bnf_program

%%

bnf_program
	:	bnf_statement
	|	bnf_program bnf_statement
	;

bnf_statement
	:	j_2003
	|	part_n
	|	sql_object_identifier
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
	|	j_200n
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
	:	level bindings parts packages
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

j_1999
	:	3
	|	edition1999 left_paren 3 right_paren
	;

j_2003
	:	4
	|	edition2003 left_paren 4 right_paren
	;

bindings
	:	module embedded direct invoked_routine_languages
	;

lst_nt_001
	:	module_languages
	|	lst_nt_001 module_languages
	;

module
	:	module_no
	|	lst_nt_001
	;

module_languages
	:	module_ada
	|	module_c
	|	module_cobol
	|	module_fortran
	|	module_mumps
	|	module_pascal
	|	module_pl_i
	;

module_ada
	:	1
	|	moduleAda left_paren 1 right_paren
	;

module_c
	:	2
	|	moduleC left_paren 2 right_paren
	;

module_cobol
	:	3
	|	moduleCOBOL left_paren 3 right_paren
	;

module_fortran
	:	4
	|	moduleFortran left_paren 4 right_paren
	;

module_mumps
	:	5
	|	moduleMUMPS left_paren 5 right_paren
	;

module_pascal
	:	6
	|	modulePascal left_paren 6 right_paren
	;

module_pl_i
	:	7
	|	modulePLI left_paren 7 right_paren
	;

lst_nt_002
	:	embedded_languages
	|	lst_nt_002 embedded_languages
	;

embedded
	:	embedded_no
	|	lst_nt_002
	;

embedded_languages
	:	embedded_ada
	|	embedded_c
	|	embedded_cobol
	|	embedded_fortran
	|	embedded_mumps
	|	embedded_pascal
	|	embedded_pl_i
	;

embedded_ada
	:	1
	|	embeddedAda left_paren 1 right_paren
	;

embedded_c
	:	2
	|	embeddedC left_paren 2 right_paren
	;

embedded_cobol
	:	3
	|	embeddedCOBOL left_paren 3 right_paren
	;

embedded_fortran
	:	4
	|	embeddedFortran left_paren 4 right_paren
	;

embedded_mumps
	:	5
	|	embeddedMUMPS left_paren 5 right_paren
	;

embedded_pascal
	:	6
	|	embeddedPascal left_paren 6 right_paren
	;

embedded_pl_i
	:	7
	|	embeddedPLI left_paren 7 right_paren
	;

direct
	:	direct_yes
	|	direct_no
	;

direct_yes
	:	1
	|	directyes left_paren 1 right_paren
	;

direct_no
	:	0
	|	directno left_paren 0 right_paren
	;

invoked_routine_languages
	:	invoked_ada
	|	invoked_c
	|	invoked_cobol
	|	invoked_fortran
	|	invoked_mumps
	|	invoked_pascal
	|	invoked_pl_i
	;

invoked_ada
	:	1
	|	invokedAda left_paren 1 right_paren
	;

invoked_c
	:	2
	|	invokedC left_paren 2 right_paren
	;

invoked_cobol
	:	3
	|	invokedCOBOL left_paren 3 right_paren
	;

invoked_fortran
	:	4
	|	invokedFortran left_paren 4 right_paren
	;

invoked_mumps
	:	5
	|	invokedMUMPS left_paren 5 right_paren
	;

invoked_pascal
	:	6
	|	invokedPascal left_paren 6 right_paren
	;

invoked_pl_i
	:	7
	|	invokedPLI left_paren 7 right_paren
	;

parts
	:	part_3 part_4 part_7 part_9 part_10 part_11
	;

part_n
	:	part_n_no
	|	part_n_yes
	;

part_n_no
	:	0
	|	Part-nNo left_paren 0 right_paren
	;

part_n_yes
	:	/* !! as specified in ISO/IEC 9075-n */
	;

lst_nt_003
	:	package_pkgi
	|	lst_nt_003 package_pkgi
	;

packages
	:	lst_nt_003
	;

package_pkgi
	:	package_pkgiyes
	|	package_pkgino
	;


%%

