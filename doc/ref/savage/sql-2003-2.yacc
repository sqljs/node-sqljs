/*
** Derived from file sql-2003-2.bnf version 1.11 dated 2005/07/13 18:37:30
*/
/* Information taken from the Final Committee Draft (FCD) of ISO/IEC 9075-2:2003. */
/* However, the page numbers and some section titles (9.14 through 9.23, */
/* for example) are from the final standard. */
/* This means there could be other as yet undiagnosed differences between */
/* the final standard and the notation in this document; you were warned! */
/* The plain text version of this grammar is */
/* --## <a href='sql-2003-2.bnf'> sql-2003-2.bnf </a>. */
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
/*  Keywords <key word> */
/*  MERGE <merge statement> */
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
/*  5 Lexical Elements */
/* Basic definitions of characters used, tokens, symbols, etc. */
/* Most of this section would normally be handled within the lexical */
/* analyzer rather than in the grammar proper. */
/* Further, the original document does not quote the various single */
/* characters, which makes it hard to process automatically. */
/*  5.1 <SQL terminal character> (p151) */
/* The trigraphs are new in SQL-2003. */
/* UNK: ??( */
/* UNK: ??) */
/*  5.2 <token> and <separator> (p134) */
/* Specifying lexical units (tokens and separators) that participate in SQL language. */
/* Previous standard said: */
/* The productions for <Unicode delimited identifier> and so on are new in SQL-2003. */
/* The rule for <doublequote symbol> in the standard uses two adjacent literal double quotes rather than referencing <double quote>; the reasons are not clear. */
/* It is annotated '!! two consecutive double quote characters'. */
/* The rules for <not equals operator> etc in the standard uses */
/* two adjacent literal characters rather than referencing */
/* <less than> and <greater than>; the reasons are not clear. */
/* Note that two characters must be adjacent with no */
/* intervening space, not a pair of characters separated by */
/* arbitrary white space. */
/* The <bracketed comment> rule included '!! See the Syntax Rules'. */
/* This probably says something about the <slash> <asterisk> and <asterisk> */
/* <slash> needing to be adjacent characters rather than adjacent tokens. */
/* There was a surprising amount of movement of keywords */
/* between the reserved and non-reserved word classes. */
/* There is also room to think that much of the host language */
/* support moved out of Part 2 (SQL/Foundation). */
/*  5.3 <literal> (p143) */
/* The <quote symbol> rule consists of two immediately adjacent <quote> */
/* marks with no spaces. */
/* As usual, this would be best handled in the lexical analyzer, not in the */
/* grammar. */
/*  5.4 Names and identifiers (p151) */
/*  6 Scalar expressions */
/*  6.1 <data type> (p161) */
/*  6.2 <field definition> (p173) */
/*  6.3 <value expression primary> (p174) */
/*  6.4 <value specification> and <target specification> (p176) */
/*  6.5 <contextually typed value specification> (p181) */
/*  6.6 <identifier chain> (p183) */
/*  6.7 <column reference> (p187) */
/*  6.8 <SQL parameter reference> (p190) */
/*  6.9 <set function specification> (p191) */
/*  6.10 <window function> (p193) */
/*  6.11 <case expression> (p197) */
/*  6.12 <cast specification> (p200) */
/*  6.13 <next value expression> (p216) */
/*  6.14 <field reference> (p218) */
/*  6.15 <subtype treatment> (p219) */
/*  6.16 <method invocation> (p221) */
/*  6.17 <static method invocation> (p223) */
/*  6.18 <new specification> (p225) */
/*  6.19 <attribute or method reference> (p227) */
/*  6.20 <dereference operation> (p229) */
/*  6.21 <method reference> (p230) */
/*  6.22 <reference resolution> (p232) */
/*  6.23 <array element reference> (p234) */
/*  6.24 <multiset element reference> (p235) */
/*  6.25 <value expression> (p236) */
/* Specify a value. */
/*  6.26 <numeric value expression> (p240) */
/* Specify a numeric value. */
/*  6.27 <numeric value function> (p242) */
/* Specify a function yielding a value of type numeric. */
/*  6.28 <string value expression> (p251) */
/* Specify a character string value or a binary string value. */
/*  6.29 <string value function> (p255) */
/* Specify a function yielding a value of type character string or binary string. */
/*  6.30 <datetime value expression> (p266) */
/* Specify a datetime value. */
/*  6.31 <datetime value function> (p269) */
/* Specify a function yielding a value of type datetime. */
/*  6.32 <interval value expression> (p271) */
/*   */
/* Specify an interval value. */
/*  6.33 <interval value function> (p276) */
/*  6.34 <boolean value expression> (p277) */
/*  6.35 <array value expression> (p284) */
/*  6.36 <array value constructor> (p284) */
/*  6.37 <multiset value expression> (p286) */
/*  6.38 <multiset value function> (p289) */
/*  6.39 <multiset value constructor> (p290) */
/*  7 Query expressions */
/*  7.1 <row value constructor> (p293) */
/* Specify a value or list of values to be constructed into a row or partial row. */
/*  7.2 <row value expression> (p296) */
/*   */
/* Specify a row value. */
/*  7.3 <table value constructor> (p298) */
/*   */
/* Specify a set of <row value expression>s to be constructed into a table. */
/*  7.4 <table expression> (p300) */
/*   */
/* Specify a table or a grouped table. */
/*  7.5 <from clause> (p301) */
/*   */
/* Specify a table derived from one or more tables. */
/*  7.6 <table reference> (p303) */
/*   */
/* Reference a table. */
/*  7.7 <joined table> (p312) */
/*   */
/* Specify a table derived from a Cartesian product, inner or outer join, or union join. */
/*  7.8 <where clause> (p319) */
/*   */
/* Specify a table derived by the application of a <search condition> to the result of the preceding */
/* <from clause>. */
/*  7.9 <group by clause> (p320) */
/*   */
/* Specify a grouped table derived by the application of the <group by clause> to the result of the */
/* previously specified clause. */
/*  7.10 <having clause> (p329) */
/*   */
/* Specify a grouped table derived by the elimination of groups that do not satisfy a <search condition>. */
/*  7.11 <window clause> (p331) */
/*   */
/* Specify one or more window definitions. */
/*  7.12 <query specification> (p341) */
/*   */
/* Specify a table derived from the result of a <table expression>. */
/*  7.13 <query expression> (p350) */
/*   */
/* Specify a table. */
/*  7.14 <search or cycle clause> (p363) */
/*   */
/* Specify the generation of ordering and cycle detection information in the result of recursive query */
/* expressions. */
/*  7.15 <subquery> (p368) */
/*   */
/* Specify a scalar value, a row, or a table derived from a <query expression>. */
/*  8 Predicates */
/*  8.1 <predicate> (p371) */
/*   */
/* Specify a condition that can be evaluated to give a boolean value. */
/*  8.2 <comparison predicate> (p373) */
/*   */
/* Specify a comparison of two row values. */
/*  8.3 <between predicate> (p380) */
/*   */
/* Specify a range comparison. */
/*  8.4 <in predicate> (p381) */
/*   */
/* Specify a quantified comparison. */
/*  8.5 <like predicate> (p383) */
/*   */
/* Specify a pattern-match comparison. */
/*  8.6 <similar predicate> (p389) */
/*   */
/* Specify a character string similarity by means of a regular expression. */
/*  8.7 <null predicate> (p395) */
/*   */
/* Specify a test for a null value. */
/*  8.8 <quantified comparison predicate> (p397) */
/*   */
/* Specify a quantified comparison. */
/*  8.9 <exists predicate> (p399) */
/*   */
/* Specify a test for a non-empty set. */
/*  8.10 <unique predicate> (p400) */
/* Specify a test for the absence of duplicate rows */
/*  8.11 <normalized predicate> (p401) */
/*   */
/* Determine whether a character string value is normalized. */
/*  8.12 <match predicate> (p402) */
/*   */
/* Specify a test for matching rows. */
/*  8.13 <overlaps predicate> (p405) */
/*   */
/* Specify a test for an overlap between two datetime periods. */
/*  8.14 <distinct predicate> (p407) */
/*   */
/* Specify a test of whether two row values are distinct */
/*  8.15 <member predicate> (p409) */
/*   */
/* Specify a test of whether a value is a member of a multiset. */
/*  8.16 <submultiset predicate> (p411) */
/*   */
/* Specify a test of whether a multiset is a submultiset of another multiset. */
/*  8.17 <set predicate> (p413) */
/*   */
/* Specify a test of whether a multiset is a set (that is, does not contain any duplicates). */
/*  8.18 <type predicate> (p414) */
/*   */
/* Specify a type test. */
/*  8.19 <search condition> (p416) */
/*   */
/* Specify a condition that is True , False , or Unknown , depending on the value of a <boolean value */
/* expression>. */
/*  9 Additional common rules */
/*  9.1 Retrieval assignment (p417) */
/*  9.2 Store assignment (p422) */
/*  9.3 Data types of results of aggregations (p427) */
/*  9.4 Subject routine determination (p430) */
/*  9.5 Type precedence list determination (p431) */
/*  9.6 Host parameter mode determination (p434) */
/*  9.7 Type name determination (p436) */
/*  9.8 Determination of identical values (p438) */
/*  9.9 Equality operations (p440) */
/*  9.10 Grouping operations (p443) */
/*  9.11 Multiset element grouping operations (p445) */
/*  9.12 Ordering operations (p447) */
/*  9.13 Collation determination (p449) */
/*  9.14 Execution of array-returning functions (p450) */
/*  9.15 Execution of multiset-returning functions (p453) */
/*  9.16 Data type identity (p454) */
/*  9.17 Determination of a from-sql function (p456) */
/*  9.18 Determination of a from-sql function for an overriding method (p457) */
/*  9.19 Determination of a to-sql function (p458) */
/*  9.20 Determination of a to-sql function for an overriding method (p459) */
/*  9.21 Generation of the next value of a sequence generator (p460) */
/*  9.22 Creation of a sequence generator (p461) */
/*  9.23 Altering a sequence generator (p463) */
/*  10 Additional common elements */
/*  10.1 <interval qualifier> (p465) */
/*   */
/* Specify the precision of an interval data type. */
/*  10.2 <language clause> (p469) */
/*   */
/* Specify a standard programming language. */
/* Table 14 -- Standard programming languages */
/* --## <table border=1> */
/* --## <tr> <th> Language keyword </th> <th> Relevant standard </th> </tr> */
/* --## <tr><td>ADA</td><td>ISO/IEC 8652</td></tr> */
/* --## <tr><td>C</td><td>ISO/IEC 9899</td></tr> */
/* --## <tr><td>COBOL</td><td>ISO 1989</td></tr> */
/* --## <tr><td>FORTRAN</td><td>ISO 1539</td></tr> */
/* --## <tr><td>MUMPS</td><td>ISO/IEC 11756</td></tr> */
/* --## <tr><td>PASCAL</td><td>ISO/IEC 7185 and ISO/IEC 10206</td></tr> */
/* --## <tr><td>PLI</td><td>ISO 6160</td></tr> */
/* --## <tr><td>SQL</td><td>ISO/IEC 9075</td></tr> */
/* --## </table> */
/*  10.3 <path specification> (p471) */
/*   */
/* Specify an order for searching for an SQL-invoked routine. */
/*  10.4 <routine invocation> (p472) */
/*   */
/* Invoke an SQL-invoked routine. */
/*  10.5 <character set specification> (p495) */
/*   */
/* Identify a character set. */
/*  10.6 <specific routine designator> (p497) */
/*   */
/* Specify an SQL-invoked routine. */
/*  10.7 <collate clause> (p500) */
/*   */
/* Specify a default collating sequence. */
/*  10.8 <constraint name definition> and <constraint characteristics> (p501) */
/*   */
/* Specify the name of a constraint and its characteristics. */
/*  10.9 <aggregate function> (p503) */
/*   */
/* Specify a value computed from a collection of rows. */
/*  10.10 <sort specification list> (p515) */
/*   */
/* Specify a sort order. */
/*  11 Schema definition and manipulation */
/*  11.1 <schema definition> (p517) */
/*   */
/* Define a schema. */
/*  11.2 <drop schema statement> (p520) */
/*   */
/* Destroy a schema. */
/*  11.3 <table definition> (p523) */
/*   */
/* Define a persistent base table, a created local temporary table, or a global temporary table. */
/*  11.4 <column definition> (p534) */
/*   */
/* Define a column of a base table. */
/*  11.5 <default clause> (p539) */
/*   */
/* Specify the default for a column, domain, or attribute. */
/*  11.6 <table constraint definition> (p543) */
/*   */
/* Specify an integrity constraint. */
/*  11.7 <unique constraint definition> (p545) */
/*   */
/* Specify a uniqueness constraint for a table. */
/* UNK: ( VALUE ) */
/*  11.8 <referential constraint definition> (p547) */
/*   */
/* Specify a referential constraint. */
/*  11.9 <check constraint definition> (p567) */
/*   */
/* Specify a condition for the SQL-data. */
/*  11.10 <alter table statement> (p569) */
/*   */
/* Change the definition of a table. */
/*  11.11 <add column definition> (p570) */
/*   */
/* Add a column to a table. */
/*  11.12 <alter column definition> (p572) */
/*   */
/* Change a column and its definition. */
/*  11.13 <set column default clause> (p573) */
/*   */
/* Set the default clause for a column. */
/*  11.14 <drop column default clause> (p574) */
/*   */
/* Drop the default clause from a column. */
/*  11.15 <add column scope clause> (p575) */
/*   */
/* Add a non-empty scope for an existing column of data type REF in a base table. */
/*  11.16 <drop column scope clause> (p576) */
/*   */
/* Drop the scope from an existing column of data type REF in a base table. */
/*  11.17 <alter identity column specification> (p578) */
/*   */
/* Change the options specified for an identity column. */
/*  11.18 <drop column definition> (p579) */
/*   */
/* Destroy a column of a base table. */
/*  11.19 <add table constraint definition> (p581) */
/*   */
/* Add a constraint to a table. */
/*  11.20 <drop table constraint definition> (p582) */
/*   */
/* Destroy a constraint on a table. */
/*  11.21 <drop table statement> (p585) */
/*   */
/* Destroy a table. */
/*  11.22 <view definition> (p588) */
/*   */
/* Define a viewed table. */
/*  11.23 <drop view statement> (p598) */
/*   */
/* Destroy a view. */
/*  11.24 <domain definition> (p601) */
/*   */
/* Define a domain. */
/*  11.25 <alter domain statement> (p603) */
/*   */
/* Change a domain and its definition. */
/*  11.26 <set domain default clause> (p604) */
/*   */
/* Set the default value in a domain. */
/*  11.27 <drop domain default clause> (p605) */
/*   */
/* Remove the default clause of a domain. */
/*  11.28 <add domain constraint definition> (p606) */
/*   */
/* Add a constraint to a domain. */
/*  11.29 <drop domain constraint definition> (p607) */
/*   */
/* Destroy a constraint on a domain. */
/*  11.30 <drop domain statement> (p608) */
/*   */
/* Destroy a domain. */
/*  11.31 <character set definition> (p610) */
/*   */
/* Define a character set. */
/*  11.32 <drop character set statement> (p612) */
/*   */
/* Destroy a character set. */
/*  11.33 <collation definition> (p614) */
/*   */
/* Define a collating sequence. */
/*  11.34 <drop collation statement> (p616) */
/*   */
/* Destroy a collating sequence. */
/*  11.35 <transliteration definition> (p618) */
/*   */
/* Define a character transliteration. */
/*  11.36 <drop transliteration statement> (p621) */
/*   */
/* Destroy a character transliteration. */
/*  11.37 <assertion definition> (p623) */
/*   */
/* Specify an integrity constraint. */
/*  11.38 <drop assertion statement> (p625) */
/*   */
/* Destroy an assertion. */
/*  11.39 <trigger definition> (p627) */
/*   */
/* Define triggered SQL-statements. */
/*  11.40 <drop trigger statement> (p631) */
/*   */
/* Destroy a trigger. */
/*  11.41 <user-defined type definition> (p632) */
/*   */
/* Define a user-defined type. */
/*  11.42 <attribute definition> (p648) */
/*   */
/* Define an attribute of a structured type. */
/*  11.43 <alter type statement> (p650) */
/*   */
/* Change the definition of a user-defined type. */
/*  11.44 <add attribute definition> (p651) */
/*   */
/* Add an attribute to a user-defined type. */
/*  11.45 <drop attribute definition> (p653) */
/*   */
/* Destroy an attribute of a user-defined type. */
/*  11.46 <add original method specification> (p655) */
/*   */
/* Add an original method specification to a user-defined type. */
/*  11.47 <add overriding method specification> (p661) */
/*   */
/* Add an overriding method specification to a user-defined type. */
/*  11.48 <drop method specification> (p666) */
/*   */
/* Remove a method specification from a user-defined type. */
/*  11.49 <drop data type statement> (p670) */
/*   */
/* Destroy a user-defined type. */
/*  11.50 <SQL-invoked routine> (p673) */
/*   */
/* Define an SQL-invoked routine. */
/*  11.51 <alter routine statement> (p698) */
/*   */
/* Alter a characteristic of an SQL-invoked routine. */
/*  11.52 <drop routine statement> (p701) */
/*   */
/* Destroy an SQL-invoked routine. */
/*  11.53 <user-defined cast definition> (p703) */
/*   */
/* Define a user-defined cast. */
/*  11.54 <drop user-defined cast statement> (p705) */
/*   */
/* Destroy a user-defined cast. */
/*  11.55 <user-defined ordering definition> (p707) */
/*   */
/* Define a user-defined ordering for a user-defined type. */
/*  11.56 <drop user-defined ordering statement> (p710) */
/*   */
/* Destroy a user-defined ordering method. */
/*  11.57 <transform definition> (p712) */
/*   */
/* Define one or more transform functions for a user-defined type. */
/*  11.58 <alter transform statement> (p715) */
/*   */
/* Change the definition of one or more transform groups. */
/*  11.59 <add transform element list> (p717) */
/*   */
/* Add a transform element (<to sql> and/or <from sql>) to an existing transform group. */
/*  11.60 <drop transform element list> (p719) */
/*   */
/* Remove a transform element (<to sql> and/or <from sql>) from a transform group. */
/*  11.61 <drop transform statement> (p721) */
/*   */
/* Remove one or more transform functions associated with a transform. */
/*  11.62 <sequence generator definition> (p724) */
/*   */
/* Define an external sequence generator. */
/* <sequence generator increment by option> :: = INCREMENT BY <sequence generator increment> */
/* 	|	NO MAXVALUE */
/*  11.63 <alter sequence generator statement> (p726) */
/*   */
/* Change the definition of an external sequence generator. */
/*  11.64 <drop sequence generator statement> (p727) */
/*   */
/* Destroy an external sequence generator. */
/*  12 Access control */
/*  12.1 <grant statement> (p729) */
/*   */
/* Define privileges and role authorizations. */
/*  12.2 <grant privilege statement> (p734) */
/*   */
/* Define privileges. */
/*  12.3 <privileges> (p737) */
/*   */
/* Specify privileges. */
/*  12.4 <role definition> (p741) */
/*   */
/* Define a role. */
/*  12.5 <grant role statement> (p742) */
/*   */
/* Define role authorizations. */
/*  12.6 <drop role statement> (p744) */
/*   */
/* Destroy a role. */
/*  12.7 <revoke statement> (p745) */
/*   */
/* Destroy privileges and role authorizations. */
/*  13 SQL-client modules */
/*  13.1 <SQL-client module definition> (p763) */
/*   */
/* Define an SQL-client module. */
/*  13.2 <module name clause> (p768) */
/*   */
/* Name an SQL-client module. */
/*  13.3 <externally-invoked procedure> (p769) */
/*   */
/* Define an externally-invoked procedure. */
/*  13.4 Calls to an <externally-invoked procedure> (p772) */
/*  13.5 <SQL procedure statement> (p788) */
/*   */
/* Define all of the SQL-statements that are <SQL procedure statement>s. */
/*  13.6 Data type correspondences (p796) */
/* Table 16 -- Data type correspondences for C */
/* --## <table border=1> */
/* --## <tr><th> SQL Data Type </th><th> C Data Type </th></tr> */
/* --## <tr><td> SQLSTATE </td><td> char, with length 6 </td></tr> */
/* --## <tr><td> CHARACTER (L)<sup>3</sup> </td><td> char, with length (L+1)*k<sup>1</sup> </td></tr> */
/* --## <tr><td> CHARACTER VARYING (L)<sup>3</sup> </td><td> char, with length (L+1)*k<sup>1</sup> </td></tr> */
/* --## <tr><td> CHARACTER LARGE OBJECT(L) </td><td> */
/* --## <pre> */
/* --## struct { */
/* --## long hvn<sup>3</sup>_reserved */
/* --## unsigned long hvn<sup>2</sup>_length */
/* --## char<sup>3</sup> hvn<sup>2</sup>_data[L]; */
/* --## } hvn<sup>2</sup> */
/* --## </pre> </td></tr> */
/* --## <tr><td> BINARY LARGE OBJECT(L) </td><td> */
/* --## <pre> struct { */
/* --## long hvn<sup>2</sup>_reserved */
/* --## unsigned long hvn<sup>2</sup>_length */
/* --## char hvn<sup>2</sup>_data[L]; */
/* --## } hvn<sup>2</sup> */
/* --## </pre> </td></tr> */
/* --## <tr><td> NUMERIC(P,S) </td><td> None </td></tr> */
/* --## <tr><td> DECIMAL(P,S) </td><td> None </td></tr> */
/* --## <tr><td> SMALLINT </td><td> pointer to short </td></tr> */
/* --## <tr><td> INTEGER </td><td> pointer to long </td></tr> */
/* --## <tr><td> BIGINT </td><td> pointer to long long </td></tr> */
/* --## <tr><td> FLOAT(P) </td><td> None </td></tr> */
/* --## <tr><td> REAL </td><td> pointer to float </td></tr> */
/* --## <tr><td> DOUBLE PRECISION </td><td> pointer to double </td></tr> */
/* --## <tr><td> BOOLEAN </td><td> pointer to long </td></tr> */
/* --## <tr><td> DATE </td><td> None </td></tr> */
/* --## <tr><td> TIME(T) </td><td> None </td></tr> */
/* --## <tr><td> TIMESTAMP(T) </td><td> None </td></tr> */
/* --## <tr><td> INTERVAL(Q) </td><td> None </td></tr> */
/* --## <tr><td> user-defined type </td><td> None </td></tr> */
/* --## <tr><td> REF </td><td> char, with length N </td></tr> */
/* --## <tr><td> ROW </td><td> None </td></tr> */
/* --## <tr><td> ARRAY </td><td> None </td></tr> */
/* --## <tr><td> MULTISET </td><td> None </td></tr> */
/* --## </table> */
/* --## <sup>1</sup> For character set UTF16, as well as other */
/* implementation-defined character sets in which a code unit occupies two */
/* octets, k is the length in units of C unsigned short of the character */
/* encoded using the greatest number of such units in the character set; */
/* for character set UTF32, as well as other implementation-defined */
/* character sets in which a code unit occupies four octets, k is four; for */
/* other character sets, k is the length in units of C char of the */
/* character encoded using the greatest number of such units in the */
/* character set. */
/* --## <sup>2</sup> hvn is the name of the host variable defined to correspond */
/* to the SQL data type */
/* --## <sup>3</sup> For character set UTF16, as well as other */
/* implementation-defined character sets in which a code unit occupies two */
/* octets, char or unsigned char should be replaced with unsigned short; */
/* for character set UTF32, as well as other implementation-defined */
/* character sets in which a code unit occupies four octets, char or */
/* unsigned char should be replaced with unsigned int.  Otherwise, char or */
/* unsigned char should be used. */
/*  14 Data manipulation */
/*  14.1 <declare cursor> (p807) */
/*   */
/* Define a cursor. */
/*  14.2 <open statement> (p813) */
/*   */
/* Open a cursor. */
/*  14.3 <fetch statement> (p815) */
/*   */
/* Position a cursor on a specified row of a table and retrieve values from that row. */
/*  14.4 <close statement> (p820) */
/* Close a cursor. */
/*  14.5 <select statement: single row> (p822) */
/*   */
/* Retrieve values from a specified row of a table. */
/*  14.6 <delete statement: positioned> (p826) */
/*   */
/* Delete a row of a table. */
/*  14.7 <delete statement: searched> (p829) */
/*   */
/* Delete rows of a table. */
/*  14.8 <insert statement> (p832) */
/*   */
/* Create new rows in a table. */
/*  14.9 <merge statement> (p837) */
/*   */
/* Conditionally update rows of a table, or insert new rows into a table, or both. */
/*  14.10 <update statement: positioned> (p844) */
/*   */
/* Update a row of a table. */
/*  14.11 <update statement: searched> (p847) */
/*   */
/* Update rows of a table. */
/*  14.12 <set clause list> (p851) */
/*   */
/* Specify a list of updates. */
/*  14.13 <temporary table declaration> (p856) */
/*   */
/* Declare a declared local temporary table. */
/*  14.14 <free locator statement> (p858) */
/*   */
/* Remove the association between a locator variable and the value that is represented by that locator. */
/*  14.15 <hold locator statement> (p859) */
/*   */
/* Mark a locator variable as being holdable. */
/*  14.16 Effect of deleting rows from base tables (p860) */
/*  14.17 Effect of deleting some rows from a derived table (p862) */
/*  14.18 Effect of deleting some rows from a viewed table (p864) */
/*  14.19 Effect of inserting tables into base tables (p865) */
/*  14.20 Effect of inserting a table into a derived table (p867) */
/*  14.21 Effect of inserting a table into a viewed table (p869) */
/*  14.22 Effect of replacing rows in base tables (p871) */
/*  14.23 Effect of replacing some rows in a derived table (p874) */
/*  14.24 Effect of replacing some rows in a viewed table (p877) */
/*  14.25 Execution of BEFORE triggers (p879) */
/*  14.26 Execution of AFTER triggers (p880) */
/*  14.27 Execution of triggers (p881) */
/*  15 Control statements */
/*  15.1 <call statement> (p883) */
/*   */
/* Invoke an SQL-invoked routine. */
/*  15.2 <return statement> (p884) */
/*   */
/* Return a value from an SQL function. */
/*  16 Transaction management */
/*  16.1 <start transaction statement> (p885) */
/*   */
/* Start an SQL-transaction and set its characteristics. */
/*  16.2 <set transaction statement> (p888) */
/*   */
/* Set the characteristics of the next SQL-transaction for the SQL-agent. */
/* NOTE 402 - This statement has no effect on any SQL-transactions subsequent to the next SQL-transaction. */
/*  16.3 <set constraints mode statement> (p890) */
/*   */
/* If an SQL-transaction is currently active, then set the constraint mode for that SQL-transaction in */
/* the current SQL-session. If no SQL-transaction is currently active, then set the constraint mode for */
/* the next SQL-transaction in the current SQL-session for the SQL-agent. */
/* NOTE 404 – This statement has no effect on any SQL-transactions subsequent to this SQL-transaction. */
/*  16.4 <savepoint statement> (p892) */
/*   */
/* Establish a savepoint. */
/*  16.5 <release savepoint statement> (p893) */
/*   */
/* Destroy a savepoint. */
/*  16.6 <commit statement> (p894) */
/*   */
/* Terminate the current SQL-transaction with commit. */
/*  16.7 <rollback statement> (p896) */
/*   */
/* Terminate the current SQL-transaction with rollback, or rollback all actions affecting SQL-data */
/* and/or schemas since the establishment of a savepoint. */
/*  17 Connection management */
/*  17.1 <connect statement> (p899) */
/*   */
/* Establish an SQL-session. */
/*  17.2 <set connection statement> (p902) */
/*   */
/* Select an SQL-connection from the available SQL-connections. */
/*  17.3 <disconnect statement> (p904) */
/*   */
/* Terminate an SQL-connection. */
/*  18 Session management */
/*  18.1 <set session characteristics statement> (p907) */
/*   */
/* Set one or more characteristics for the current SQL-session. */
/*  18.2 <set session user identifier statement> (p908) */
/*   */
/* Set the SQL-session user identifier and the current user identifier of the current SQL-session */
/* context. */
/*  18.3 <set role statement> (p909) */
/*   */
/* Set the current role name for the current SQL-session context. */
/*  18.4 <set local time zone statement> (p911) */
/*   */
/* Set the default local time zone displacement for the current SQL-session. */
/*  18.5 <set catalog statement> (p912) */
/*   */
/* Set the default catalog name for unqualified <schema name>s in <preparable statement>s that */
/* are prepared in the current SQL-session by an <execute immediate statement> or a <prepare */
/* statement> and in <direct SQL statement>s that are invoked directly. */
/*  18.6 <set schema statement> (p913) */
/*   */
/* Set the default schema name for unqualified <schema qualified name>s in <preparable statement>s */
/* that are prepared in the current SQL-session by an <execute immediate statement> or a <prepare */
/* statement> and in <direct SQL statement>s that are invoked directly. */
/*  18.7 <set names statement> (p915) */
/*   */
/* Set the default character set name for <character string literal>s in <preparable statement>s that */
/* are prepared in the current SQL-session by an <execute immediate statement> or a <prepare */
/* statement> and in <direct SQL statement>s that are invoked directly. */
/*  18.8 <set path statement> (p916) */
/*   */
/* Set the SQL-path used to determine the subject routine of <routine invocation>s with unqualified */
/* <routine name>s in <preparable statement>s that are prepared in the current SQL-session by */
/* an <execute immediate statement> or a <prepare statement> and in <direct SQL statement>s, */
/* respectively, that are invoked directly. The SQL-path remains the current SQL-path of the SQLsession */
/* until another SQL-path is successfully set. */
/*  18.9 <set transform group statement> (p917) */
/*   */
/* Set the group name that identifies the group of transform functions for */
/* mapping values of userdefined types to predefined data types. */
/*  18.10 <set session collation statement> (p918) */
/*   */
/* Set the SQL-session collation of the SQL-session for one or more */
/* character sets.  An SQL-session collation remains effective until */
/* another SQL-session collation for the same character set is successfully */
/* set. */
/* UNK: , <character set specification>... ] */
/*  19 Dynamic SQL */
/*  19.1 Description of SQL descriptor areas (p921) */
/*  19.2 <allocate descriptor statement> (p931) */
/*   */
/* Allocate an SQL descriptor area. */
/*  19.3 <deallocate descriptor statement> (p933) */
/*   */
/* Deallocate an SQL descriptor area. */
/*  19.4 <get descriptor statement> (p934) */
/*   */
/* Get information from an SQL descriptor area. */
/*  19.5 <set descriptor statement> (p937) */
/*   */
/* Set information in an SQL descriptor area. */
/*  19.6 <prepare statement> (p941) */
/*   */
/* Prepare a statement for execution. */
/*  19.7 <cursor attributes> (p953) */
/*   */
/* Specify a list of cursor attributes. */
/*  19.8 <deallocate prepared statement> (p954) */
/*   */
/* Deallocate SQL-statements that have been prepared with a <prepare statement>. */
/*  19.9 <describe statement> (p955) */
/*   */
/* Obtain information about the <select list> columns or <dynamic parameter specification>s contained */
/* in a prepared statement or about the columns of the result set associated with a cursor. */
/*  19.10 <input using clause> (p961) */
/*   */
/* Supply input values for an <SQL dynamic statement>. */
/*  19.11 <output using clause> (p965) */
/*   */
/* Supply output variables for an <SQL dynamic statement>. */
/*  19.12 <execute statement> (p970) */
/*   */
/* Associate input SQL parameters and output targets with a prepared statement and execute the */
/* statement. */
/*  19.13 <execute immediate statement> (p972) */
/*   */
/* Dynamically prepare and execute a preparable statement. */
/*  19.14 <dynamic declare cursor> (p973) */
/*   */
/* Declare a cursor to be associated with a <statement name>, which may in turn be associated with a */
/* <cursor specification>. */
/*  19.15 <allocate cursor statement> (p974) */
/*   */
/* Define a cursor based on a prepared statement for a <cursor specification> or assign a cursor to the */
/* ordered set of result sets returned from an SQL-invoked procedure. */
/*  19.16 <dynamic open statement> (p976) */
/*   */
/* Associate input dynamic parameters with a <cursor specification> and open the cursor. */
/*  19.17 <dynamic fetch statement> (p977) */
/*   */
/* Fetch a row for a cursor declared with a <dynamic declare cursor>. */
/*  19.18 <dynamic single row select statement> (p978) */
/*   */
/* Retrieve values from a dynamically-specified row of a table. */
/*  19.19 <dynamic close statement> (p979) */
/*   */
/* Close a cursor. */
/*  19.20 <dynamic delete statement: positioned> (p980) */
/*   */
/* Delete a row of a table. */
/*  19.21 <dynamic update statement: positioned> (p982) */
/*   */
/* Update a row of a table. */
/*  19.22 <preparable dynamic delete statement: positioned> (p984) */
/*   */
/* Delete a row of a table through a dynamic cursor. */
/*  19.23 <preparable dynamic update statement: positioned> (p986) */
/*   */
/* Update a row of a table through a dynamic cursor. */
/*  20 Embedded SQL */
/*  20.1 <embedded SQL host program> (p989) */
/*   */
/* Specify an <embedded SQL host program>. */
/*  20.2 <embedded exception declaration> (p1001) */
/*   */
/* Specify the action to be taken when an SQL-statement causes a specific class of condition to be */
/* raised. */
/* UNK: ( <SQLSTATE class value> [ , <SQLSTATE subclass value> ] )	|	CONSTRAINT <constraint name> */
/*  20.3 <embedded SQL Ada program> (p1005) */
/*   */
/* Specify an <embedded SQL Ada program>. */
/*  20.4 <embedded SQL C program> (p1011) */
/*   */
/* Specify an <embedded SQL C program>. */
/*  20.5 <embedded SQL COBOL program> (p1019) */
/*   */
/* Specify an <embedded SQL COBOL program>. */
/*  20.6 <embedded SQL Fortran program> (p1025) */
/*   */
/* Specify an <embedded SQL Fortran program>. */
/* UNK: = n [ <asterisk> <length> ] [ CHARACTER SET [ IS ] <character set specification> ]	|	INTEGER	|	REAL	|	DOUBLE PRECISION	|	LOGICAL	|	<Fortran derived type specification> */
/*  20.7 <embedded SQL MUMPS program> (p1030) */
/*   */
/* Specify an <embedded SQL MUMPS program>. */
/*  20.8 <embedded SQL Pascal program> (p1035) */
/*   */
/* Specify an <embedded SQL Pascal program>. */
/*  20.9 <embedded SQL PL/I program> (p1040) */
/*   */
/* Specify an <embedded SQL PL/I program>. */
/*  21 Direct invocation of SQL */
/*  21.1 <direct SQL statement> (p1047) */
/*   */
/* Specify direct execution of SQL. */
/*  21.2 <direct select statement: multiple rows> (p1051) */
/*   */
/* Specify a statement to retrieve multiple rows from a specified table. */
/*  22 Diagnostics management */
/*  22.1 <get diagnostics statement> (p1053) */
/* Get exception or completion condition information from a diagnostics area. */
/*  22.2 Pushing and popping the diagnostics area stack (p1068) */
/*  23 Status codes */
/*  23.1 SQLSTATE (p1069) */
/* The character string value returned in an SQLSTATE parameter comprises a */
/* 2-character class value followed by a 3-character subclass value, each */
/* with an implementation-defined character set that has a one-octet */
/* character encoding form and is restricted to <digit>s and */
/* <simple Latin upper case letter>s. */
/* Table 31, 'SQLSTATE class and subclass values', specifies the class */
/* value for each condition and the subclass value or values for each class */
/* value. */
/* Class values that begin with one of the <digit>s '0', '1', '2', '3', or */
/* '4' or one of the <simple Latin upper case letter>s 'A', 'B', 'C', 'D', */
/* 'E', 'F', 'G', or 'H' are returned only for conditions defined in */
/* ISO/IEC 9075 or in any other International Standard. */
/* The range of such class values are called standard-defined */
/* classes. */
/* Some such class codes are reserved for use by specific International */
/* Standards, as specified elsewhere in this Clause. */
/* Subclass values associated with such classes that also begin with one of */
/* those 13 characters are returned only for conditions defined in ISO/IEC */
/* 9075 or some */
/* other International Standard. */
/* The range of such class values are called standard-defined classes. */
/* Subclass values associated with such classes that begin with one of the */
/* <digit>s '5', '6', '7', '8', or '9' or one of the <simple Latin upper */
/* case letter>s 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', */
/* 'T', 'U', 'V', 'W', 'X', 'Y', or 'Z' are reserved for */
/* implementation-specified conditions and are called */
/* implementation-defined subclasses. */
/* Class values that begin with one of the <digit>s '5', '6', '7', '8', or */
/* '9' or one of the <simple Latin upper case letter>s 'I', 'J', 'K', 'L', */
/* 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', or 'Z' */
/* are reserved for implementation-specified exception conditions and are */
/* called implementation-defined classes. */
/* All subclass values except '000', which means no subclass, associated */
/* with such classes are reserved for implementation-specified conditions */
/* and are called implementation-defined subclasses. */
/* An implementation-defined completion condition shall be indicated by */
/* returning an implementation-defined subclass in conjunction with one of */
/* the classes successful completion, warning, or no data. */
/* The 'Category' column has the following meanings: 'S' means that the class value given corresponds */
/* to successful completion and is a completion condition; 'W' means that the class value given */
/* corresponds to a successful completion but with a warning and is a completion condition; 'N' means */
/* that the class value given corresponds to a no-data situation and is a completion condition; 'X' */
/* means that the class value given corresponds to an exception condition. */
/* Table 31 - SQLSTATE class and subclass values */
/* --## <table border=1> */
/* --## <tr><th> Category </th><th> Condition </th><th> Class </th><th> Subcondition </th><th> Subclass </th></tr> */
/* --## <tr><td> X </td><td> ambiguous cursor name </td><td> 3C </td><td> (no subclass) </td><td> 000 </td></tr> */
/* --## <tr><td> X </td><td> attempt to assign to non-updatable column </td><td> 0U </td><td> (no subclass) </td><td> 000 </td></tr> */
/* --## <tr><td> X </td><td> attempt to assign to ordering column </td><td> 0V </td><td> (no subclass) </td><td> 000 </td></tr> */
/* --## <tr><td> X </td><td> cardinality violation </td><td> 21 </td><td> (no subclass) </td><td> 000 </td></tr> */
/* --## <tr><td> X </td><td> connection exception </td><td> 08 </td><td> (no subclass) </td><td> 000 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> connection does not exist </td><td> 003 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> connection failure </td><td> 006 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> connection name in use </td><td> 002 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> SQL-client unable to establish SQL-connection </td><td> 001 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> SQL-server rejected establishment of SQL-connection </td><td> 004 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> transaction resolution unknown </td><td> 007 </td></tr> */
/* --## <tr><td> X </td><td> cursor sensitivity exception </td><td> 36 </td><td> (no subclass) </td><td> 000 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> request failed </td><td> 002 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> request rejected </td><td> 001 </td></tr> */
/* --## <tr><td> X </td><td> data exception </td><td> 22 </td><td> (no subclass) </td><td> 000 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> array data, right truncation </td><td> 02F </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> array element error </td><td> 02E </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> character not in repertoire </td><td> 021 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> datetime field overflow </td><td> 008 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> division by zero </td><td> 012 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> error in assignment </td><td> 005 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> escape character conflict </td><td> 00B </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> indicator overflow </td><td> 022 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> interval field overflow </td><td> 015 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> invalid argument for natural logarithm </td><td> 01E </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> invalid argument for power function </td><td> 01F </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> invalid argument for width bucket function </td><td> 01G </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> invalid character value for cast </td><td> 018 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> invalid datetime format </td><td> 007 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> invalid escape character </td><td> 019 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> invalid escape octet </td><td> 00D </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> invalid escape sequence </td><td> 025 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> invalid indicator parameter value </td><td> 010 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> invalid interval format </td><td> 006 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> invalid parameter value </td><td> 023 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> invalid preceding or following size in window function </td><td> 013 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> invalid regular expression </td><td> 01B </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> invalid repeat argument in a sample clause </td><td> 02G </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> invalid sample size </td><td> 02H </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> invalid time zone displacement value </td><td> 009 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> invalid use of escape character </td><td> 00C </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> most specific type mismatch </td><td> 00G </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> noncharacter in UCS string </td><td> 029 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> null value substituted for mutator subject parameter </td><td> 02D </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> null row not permitted in table </td><td> 01C </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> null value in array target </td><td> 00E </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> null value, no indicator parameter </td><td> 002 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> null value not allowed </td><td> 004 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> numeric value out of range </td><td> 003 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> sequence generator limit exceeded </td><td> 00H </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> string data, length mismatch </td><td> 026 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> string data, right truncation </td><td> 001 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> substring error </td><td> 011 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> trim error </td><td> 027 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> unterminated C string </td><td> 024 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> zero-length character string </td><td> 00F </td></tr> */
/* --## <tr><td> X </td><td> dependent privilege descriptors still exist </td><td> 2B </td><td> (no subclass) </td><td> 000 </td></tr> */
/* --## <tr><td> X </td><td> diagnostics exception </td><td> 0Z </td><td> (no subclass) </td><td> 000 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> maximum number of stacked diagnostics areas exceeded </td><td> 001 </td></tr> */
/* --## <tr><td> X </td><td> dynamic SQL error </td><td> 07 </td><td> (no subclass) </td><td> 000 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> cursor specification cannot be executed </td><td> 003 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> data type transform function violation </td><td> 00B </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> invalid DATA target </td><td> 00D </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> invalid DATETIME_INTERVAL_CODE </td><td> 00F </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> invalid descriptor count </td><td> 008 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> invalid descriptor index </td><td> 009 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> invalid LEVEL value </td><td> 00E </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> prepared statement not a cursor specification </td><td> 005 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> restricted data type attribute violation </td><td> 006 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> undefined DATA value </td><td> 00C </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> using clause does not match dynamic parameter specifications </td><td> 001 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> using clause does not match target specifications </td><td> 002 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> using clause required for dynamic parameters </td><td> 004 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> using clause required for result fields </td><td> 007 </td></tr> */
/* --## <tr><td> X </td><td> external routine exception </td><td> 38 </td><td> (no subclass) </td><td> 000 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> containing SQL not permitted </td><td> 001 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> modifying SQL-data not permitted </td><td> 002 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> prohibited SQL-statement attempted </td><td> 003 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> reading SQL-data not permitted </td><td> 004 </td></tr> */
/* --## <tr><td> X </td><td> external routine invocation exception </td><td> 39 </td><td> (no subclass) </td><td> 000 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> invalid SQLSTATE returned </td><td> 001 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> null value not allowed </td><td> 004 </td></tr> */
/* --## <tr><td> X </td><td> feature not supported </td><td> 0A </td><td> (no subclass) </td><td> 000 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> multiple server transactions </td><td> 001 </td></tr> */
/* --## <tr><td> X </td><td> integrity constraint violation </td><td> 23 </td><td> (no subclass) </td><td> 000 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> restrict violation </td><td> 001 </td></tr> */
/* --## <tr><td> X </td><td> invalid authorization specification </td><td> 28 </td><td> (no subclass) </td><td> 000 </td></tr> */
/* --## <tr><td> X </td><td> invalid catalog name </td><td> 3D </td><td> (no subclass) </td><td> 000 </td></tr> */
/* --## <tr><td> X </td><td> invalid character set name </td><td> 2C </td><td> (no subclass) </td><td> 000 </td></tr> */
/* --## <tr><td> X </td><td> invalid condition number </td><td> 35 </td><td> (no subclass) </td><td> 000 </td></tr> */
/* --## <tr><td> X </td><td> invalid connection name </td><td> 2E </td><td> (no subclass) </td><td> 000 </td></tr> */
/* --## <tr><td> X </td><td> invalid cursor name </td><td> 34 </td><td> (no subclass) </td><td> 000 </td></tr> */
/* --## <tr><td> X </td><td> invalid cursor state </td><td> 24 </td><td> (no subclass) </td><td> 000 </td></tr> */
/* --## <tr><td> X </td><td> invalid grantor </td><td> 0L </td><td> (no subclass) </td><td> 000 </td></tr> */
/* --## <tr><td> X </td><td> invalid role specification </td><td> 0P </td><td> (no subclass) </td><td> 000 </td></tr> */
/* --## <tr><td> X </td><td> invalid schema name </td><td> 3F </td><td> (no subclass) </td><td> 000 </td></tr> */
/* --## <tr><td> X </td><td> invalid schema name list specification </td><td> 0E </td><td> (no subclass) </td><td> 000 </td></tr> */
/* --## <tr><td> X </td><td> invalid session collation specification </td><td> 2H </td><td> (no subclass) </td><td> 000 </td></tr> */
/* --## <tr><td> X </td><td> invalid SQL descriptor name </td><td> 33 </td><td> (no subclass) </td><td> 000 </td></tr> */
/* --## <tr><td> X </td><td> invalid SQL-invoked procedure reference </td><td> 0M </td><td> (no subclass) </td><td> 000 </td></tr> */
/* --## <tr><td> X </td><td> invalid SQL statement name </td><td> 26 </td><td> (no subclass) </td><td> 000 </td></tr> */
/* --## <tr><td> X </td><td> invalid SQL statement identifier </td><td> 30 </td><td> (no subclass) </td><td> 000 </td></tr> */
/* --## <tr><td> X </td><td> invalid target type specification </td><td> 0D </td><td> (no subclass) </td><td> 000 </td></tr> */
/* --## <tr><td> X </td><td> invalid transaction initiation </td><td> 0B </td><td> (no subclass) </td><td> 000 </td></tr> */
/* --## <tr><td> X </td><td> invalid transaction state </td><td> 25 </td><td> (no subclass) </td><td> 000 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> active SQL-transaction </td><td> 001 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> branch transaction already active </td><td> 002 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> held cursor requires same isolation level </td><td> 008 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> inappropriate access mode for branch transaction </td><td> 003 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> inappropriate isolation level for branch transaction </td><td> 004 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> no active SQL-transaction for branch transaction </td><td> 005 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> read-only SQL-transaction </td><td> 006 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> schema and data statement mixing not supported </td><td> 007 </td></tr> */
/* --## <tr><td> X </td><td> invalid transaction termination </td><td> 2D </td><td> (no subclass) </td><td> 000 </td></tr> */
/* --## <tr><td> X </td><td> invalid transform group name specification </td><td> 0S </td><td> (no subclass) </td><td> 000 </td></tr> */
/* --## <tr><td> X </td><td> locator exception </td><td> 0F </td><td> (no subclass) </td><td> 000 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> invalid specification </td><td> 001 </td></tr> */
/* --## <tr><td> N </td><td> no data </td><td> 02 </td><td> (no subclass) </td><td> 000 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> no additional dynamic result sets returned </td><td> 001 </td></tr> */
/* --## <tr><td> X </td><td> prohibited statement encountered during trigger execution </td><td> 0W </td><td> (no subclass) </td><td> 000 </td></tr> */
/* --## <tr><td> X </td><td> Remote Database Access </td><td> HZ </td><td> (See Table 32, 'SQLSTATE class codes for RDA', for the definition of protocol subconditions and subclass code values) </td><td> &nbsp; </td></tr> */
/* --## <tr><td> X </td><td> savepoint exception </td><td> 3B </td><td> (no subclass) </td><td> 000 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> invalid specification </td><td> 001 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> too many </td><td> 002 </td></tr> */
/* --## <tr><td> X </td><td> SQL routine exception </td><td> 2F </td><td> (no subclass) </td><td> 000 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> function executed no return statement </td><td> 005 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> modifying SQL-data not permitted </td><td> 002 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> prohibited SQL-statement attempted </td><td> 003 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> reading SQL-data not permitted </td><td> 004 </td></tr> */
/* --## <tr><td> S </td><td> successful completion </td><td> 00 </td><td> (no subclass) </td><td> 000 </td></tr> */
/* --## <tr><td> X </td><td> syntax error or access rule violation </td><td> 42 </td><td> (no subclass) </td><td> 000 </td></tr> */
/* --## <tr><td> X </td><td> target table disagrees with cursor specification </td><td> 0T </td><td> (no subclass) </td><td> 000 </td></tr> */
/* --## <tr><td> X </td><td> transaction rollback </td><td> 40 </td><td> (no subclass) </td><td> 000 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> integrity constraint violation </td><td> 002 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> serialization failure </td><td> 001 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> statement completion unknown </td><td> 003 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> triggered action exception </td><td> 004 </td></tr> */
/* --## <tr><td> X </td><td> triggered action exception </td><td> 09 </td><td> (no subclass) </td><td> 000 </td></tr> */
/* --## <tr><td> X </td><td> triggered data change violation </td><td> 27 </td><td> (no subclass) </td><td> 000 </td></tr> */
/* --## <tr><td> W </td><td> warning </td><td> 01 </td><td> (no subclass) </td><td> 000 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> additional result sets returned </td><td> 00D </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> array data, right truncation </td><td> 02F </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> attempt to return too many result sets </td><td> 00E </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> cursor operation conflict </td><td> 001 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> default value too long for information schema </td><td> 00B </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> disconnect error </td><td> 002 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> dynamic result sets returned </td><td> 00C </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> external routine warning (the value of xx to be chosen by the author of the external routine) </td><td> Hxx </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> insufficient item descriptor areas </td><td> 005 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> null value eliminated in set function </td><td> 003 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> privilege not granted </td><td> 007 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> privilege not revoked </td><td> 006 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> query expression too long for information schema </td><td> 00A </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> search condition too long for information schema </td><td> 009 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> statement too long for information schema </td><td> 008 </td></tr> */
/* --## <tr><td> &nbsp; </td><td> &nbsp; </td><td> &nbsp; </td><td> string data, right truncation </td><td> 004 </td></tr> */
/* --## <tr><td> X </td><td> with check option violation </td><td> 44 </td><td> (no subclass) </td><td> 000 </td></tr> */
/* --## </table> */
/*  24 Conformance */
/*  24.1 General Conformance Requirements (p1079) */
/* Table 33 - Implied feature relationships */
/* --## <table border=1> */
/* --## <tr><th> Feature ID </th><th> Feature Description </th><th> Implied Feature </th><th> ID Implied Feature Description </th></tr>  */
/* --## <tr><td> B032 </td><td> Extended dynamic SQL </td><td> B031 </td><td> Basic dynamic SQL </td></tr> */
/* --## <tr><td> B034 </td><td> Dynamic specification of cursor attributes </td><td> B031 </td><td> Basic dynamic SQL </td></tr> */
/* --## <tr><td> F381 </td><td> Extended schema manipulation </td><td> F491 </td><td> Constraint management </td></tr> */
/* --## <tr><td> F451 </td><td> Character set definition </td><td> F461 </td><td> Named character sets </td></tr> */
/* --## <tr><td> F711 </td><td> ALTER domain </td><td> F251 </td><td> Domain support </td></tr> */
/* --## <tr><td> F801 </td><td> Full set function </td><td> F441 </td><td> Extended set function support </td></tr> */
/* --## <tr><td> S024 </td><td> Enhanced structured types </td><td> S023 </td><td> Basic structured types </td></tr> */
/* --## <tr><td> S041 </td><td> Basic reference types </td><td> S023 </td><td> Basic structured types </td></tr> */
/* --## <tr><td> S041 </td><td> Basic reference types </td><td> S051 </td><td> Create table of type </td></tr> */
/* --## <tr><td> S043 </td><td> Enhanced reference types </td><td> S041 </td><td> Basic reference types </td></tr> */
/* --## <tr><td> S051 </td><td> Create table of type </td><td> S023 </td><td> Basic structured types </td></tr> */
/* --## <tr><td> S081 </td><td> Subtables </td><td> S023 </td><td> Basic structured types </td></tr> */
/* --## <tr><td> S081 </td><td> Subtables </td><td> S051 </td><td> Create table of type </td></tr> */
/* --## <tr><td> S092 </td><td> Arrays of user-defined types </td><td> S091 </td><td> Basic array support </td></tr> */
/* --## <tr><td> S094 </td><td> Arrays of reference types </td><td> S041 </td><td> Basic reference types </td></tr> */
/* --## <tr><td> S094 </td><td> Arrays of reference types </td><td> S091 </td><td> Basic array support </td></tr> */
/* --## <tr><td> S095 </td><td> Array constructors by query </td><td> S091 </td><td> Basic array support </td></tr> */
/* --## <tr><td> S096 </td><td> Optional array bounds </td><td> S091 </td><td> Basic array support </td></tr> */
/* --## <tr><td> S111 </td><td> ONLY in query expressions </td><td> S023 </td><td> Basic structured types </td></tr> */
/* --## <tr><td> S111 </td><td> ONLY in query expressions </td><td> S051 </td><td> Create table of type </td></tr> */
/* --## <tr><td> S201 </td><td> SQL-invoked routines on arrays </td><td> S091 </td><td> Basic array support </td></tr> */
/* --## <tr><td> S202 </td><td> SQL-invoked routines on multisets </td><td> S271 </td><td> Basic multiset support </td></tr> */
/* --## <tr><td> S231 </td><td> Structured type locators </td><td> S023 </td><td> Basic structured types </td></tr> */
/* --## <tr><td> S232 </td><td> Array locators </td><td> S091 </td><td> Basic array support </td></tr> */
/* --## <tr><td> S233 </td><td> Multiset locators </td><td> S271 </td><td> Basic multiset support </td></tr> */
/* --## <tr><td> S242 </td><td> Alter transform statement </td><td> S241 </td><td> Transform functions </td></tr> */
/* --## <tr><td> S272 </td><td> Multisets of user-defined types </td><td> S271 </td><td> Basic multiset support </td></tr> */
/* --## <tr><td> S274 </td><td> Multisets of reference types </td><td> S041 </td><td> Basic reference types </td></tr> */
/* --## <tr><td> S274 </td><td> Multisets of reference types </td><td> S271 </td><td> Basic multiset support </td></tr> */
/* --## <tr><td> S275 </td><td> Advanced multiset support </td><td> S271 </td><td> Basic multiset support </td></tr> */
/* --## <tr><td> T042 </td><td> Extended LOB data type support </td><td> T041 </td><td> Basic LOB data type support </td></tr> */
/* --## <tr><td> T061 </td><td> UCS Support </td><td> F461 </td><td> Named character sets </td></tr> */
/* --## <tr><td> T071 </td><td> BIGINT data type </td><td> E001-01 </td><td> INTEGER and SMALLINT data types (including all spellings) </td></tr> */
/* --## <tr><td> T131 </td><td> Recursive query </td><td> T121 </td><td> WITH (excluding RECURSIVE) in query expression </td></tr> */
/* --## <tr><td> T173 </td><td> Extended LIKE clause in table definition </td><td> T171 </td><td> LIKE clause in table definition </td></tr> */
/* --## <tr><td> T212 </td><td> Enhanced trigger capability </td><td> T211 </td><td> Basic trigger capability </td></tr> */
/* --## <tr><td> T332 </td><td> Extended roles </td><td> T331 </td><td> Basic roles </td></tr> */
/* --## <tr><td> T511 </td><td> Transaction counts </td><td> F121 </td><td> Basic diagnostics management </td></tr> */
/* --## <tr><td> T571 </td><td> Array-returning external SQL-invoked functions </td><td> S091 </td><td> Basic array support </td></tr> */
/* --## <tr><td> T571 </td><td> Array-returning external SQL-invoked functions </td><td> S201 </td><td> SQL-invoked routines on arrays </td></tr> */
/* --## <tr><td> T572 </td><td> Multiset-returning external SQLinvoked functions </td><td> S202 </td><td> SQL-invoked routines on multisets </td></tr> */
/* --## <tr><td> T572 </td><td> Multiset-returning external SQLinvoked functions </td><td> S271 </td><td> Basic multiset support </td></tr> */
/* --## <tr><td> T612 </td><td> Advanced OLAP operations </td><td> T611 </td><td> Elementary OLAP operations </td></tr> */
/* --## </table> */
/*  END OF SQL-2003 Part 2 (SQL/Foundation) GRAMMAR */
/*  Notes on Automatically Converting the SQL Grammar to a YACC Grammar */
/* Automatic translation of this grammar is non-trivial for a number of */
/* reasons. */
/* One is that the grammar has a number of actions '!! */
/* See the Syntax Rules' which cannot be translated automatically. */
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
/*  END OF SQL 2003-2 (SQL/FOUNDATION) GRAMMAR */
%{
/*
** BNF Grammar for ISO/IEC 9075-2:2003 - Database Language SQL (SQL-2003) SQL/Foundation
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
%token ALWAYS
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
%token ATTRIBUTES
%token AUTHORIZATION
%token AVG
%token B
%token BEFORE
%token BEGIN
%token BERNOULLI
%token BETWEEN
%token BIGINT
%token BIN
%token BINARY
%token BLOB
%token BOOLEAN
%token BOTH
%token BREADTH
%token BY
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
%token CEIL
%token CEILING
%token CHAIN
%token CHAR
%token CHARACTER
%token CHARACTERISTICS
%token CHARACTERS
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
%token CODE_UNITS
%token COLLATE
%token COLLATION
%token COLLATION_CATALOG
%token COLLATION_NAME
%token COLLATION_SCHEMA
%token COLLECT
%token COLUMN
%token COLUMN_NAME
%token COMMAND_FUNCTION
%token COMMAND_FUNCTION_CODE
%token COMMIT
%token COMMITTED
%token CONDITION
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
%token CONSTRUCTORS
%token CONTAINS
%token CONTINUE
%token CONVERT
%token CORR
%token CORRESPONDING
%token COUNT
%token COVAR_POP
%token COVAR_SAMP
%token CREATE
%token CROSS
%token CUBE
%token CUME_DIST
%token CURRENT
%token CURRENT_COLLATION
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
%token DEFAULT
%token DEFAULTS
%token DEFERRABLE
%token DEFERRED
%token DEFINED
%token DEFINER
%token DEGREE
%token DELETE
%token DENSE_RANK
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
%token DOMAIN
%token DOUBLE
%token DOUBLE_PRECISION
%token DROP
%token DYNAMIC
%token DYNAMIC_FUNCTION
%token DYNAMIC_FUNCTION_CODE
%token E
%token EACH
%token ELEMENT
%token ELSE
%token END
%token END-EXEC
%token EQUALS
%token ESCAPE
%token EVERY
%token EXCEPT
%token EXCEPTION
%token EXCLUDE
%token EXCLUDING
%token EXEC
%token EXECUTE
%token EXISTS
%token EXP
%token EXTERNAL
%token EXTRACT
%token F
%token FALSE
%token FETCH
%token FILTER
%token FINAL
%token FIRST
%token FIXED
%token FLOAT
%token FLOOR
%token FOLLOWING
%token FOR
%token FOREIGN
%token FORTRAN
%token FOUND
%token FREE
%token FROM
%token FULL
%token FUNCTION
%token FUSION
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
%token H
%token HAVING
%token HIERARCHY
%token HOLD
%token HOUR
%token I
%token IDENTITY
%token IMMEDIATE
%token IMPLEMENTATION
%token IN
%token INCLUDING
%token INCREMENT
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
%token INTERSECTION
%token INTERVAL
%token INTO
%token INVOKER
%token IS
%token ISOLATION
%token Interfaces.SQL
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
%token LEFT
%token LENGTH
%token LEVEL
%token LIKE
%token LN
%token LOCAL
%token LOCALTIME
%token LOCALTIMESTAMP
%token LOCATOR
%token LOWER
%token M
%token MAP
%token MATCH
%token MATCHED
%token MAX
%token MAXVALUE
%token MEMBER
%token MERGE
%token MESSAGE_LENGTH
%token MESSAGE_OCTET_LENGTH
%token MESSAGE_TEXT
%token METHOD
%token MIN
%token MINUTE
%token MINVALUE
%token MOD
%token MODIFIES
%token MODULE
%token MONTH
%token MORE
%token MULTISET
%token MUMPS
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
%token NORMALIZE
%token NORMALIZED
%token NOT
%token NULL
%token NULLABLE
%token NULLIF
%token NULLS
%token NUMBER
%token NUMERIC
%token O
%token OBJECT
%token OCTETS
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
%token OTHERS
%token OUT
%token OUTER
%token OUTPUT
%token OVER
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
%token PARTITION
%token PASCAL
%token PATH
%token PERCENTILE_CONT
%token PERCENTILE_DISC
%token PERCENT_RANK
%token PIC
%token PICTURE
%token PLACING
%token PLI
%token POSITION
%token POWER
%token PRECEDING
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
%token RANGE
%token RANK
%token READ
%token READS
%token REAL
%token RECURSIVE
%token REF
%token REFERENCES
%token REFERENCING
%token REGR_AVGX
%token REGR_AVGY
%token REGR_COUNT
%token REGR_INTERCEPT
%token REGR_R2
%token REGR_SLOPE
%token REGR_SXX
%token REGR_SXY
%token REGR_SYY
%token RELATIVE
%token RELEASE
%token REPEATABLE
%token RESTART
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
%token ROW_NUMBER
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
%token SEQUENCE
%token SERIALIZABLE
%token SERVER_NAME
%token SESSION
%token SESSION_USER
%token SET
%token SETS
%token SIGN
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
%token SQLSTATE
%token SQLSTATE_TYPE
%token SQLWARNING
%token SQRT
%token START
%token STATE
%token STATEMENT
%token STATIC
%token STDDEV_POP
%token STDDEV_SAMP
%token STRUCTURE
%token STYLE
%token SUBCLASS_ORIGIN
%token SUBMULTISET
%token SUBSTRING
%token SUM
%token SYMMETRIC
%token SYSTEM
%token SYSTEM_USER
%token T
%token TABLE
%token TABLESAMPLE
%token TABLE_NAME
%token TEMPORARY
%token THEN
%token TIES
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
%token U
%token UNBOUNDED
%token UNCOMMITTED
%token UNDER
%token UNION
%token UNIQUE
%token UNKNOWN
%token UNNAMED
%token UNNEST
%token UPDATE
%token UPPER
%token USAGE
%token USER
%token USER_DEFINED_TYPE_CATALOG
%token USER_DEFINED_TYPE_CODE
%token USER_DEFINED_TYPE_NAME
%token USER_DEFINED_TYPE_SCHEMA
%token USING
%token V
%token VALUE
%token VALUES
%token VARCHAR
%token VARYING
%token VAR_POP
%token VAR_SAMP
%token VIEW
%token W
%token WHEN
%token WHENEVER
%token WHERE
%token WIDTH_BUCKET
%token WINDOW
%token WITH
%token WITHIN
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
%token double
%token e
%token extern
%token f
%token float
%token g
%token h
%token i
%token j
%token k
%token l
%token long
%token m
%token n
%token o
%token p
%token q
%token r
%token s
%token short
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
%token bit_string_literal
%token delimited_identifier
%token delimited_identifier_part
%token handler_declaration
%token hex_string_literal
%token ideographic_character
%token initial_alphabetic_character
%token module_collation
%token multset_value_expression
%token numeric_value_expression_dividend
%token numeric_value_expression_divisor
%token overlaps_predicate_part
%token sequence_generator_increment_by_option
%token slash
%token unqualified_schema_name
%token unsigned_integer
%token white_space
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
%rule ada_multiset_locator_variable
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
%rule add_transform_element_list
%rule aggregate_function
%rule all
%rule all_fields_column_name_list
%rule all_fields_reference
%rule allocate_cursor_statement
%rule allocate_descriptor_statement
%rule alter_column_action
%rule alter_column_definition
%rule alter_domain_action
%rule alter_domain_statement
%rule alter_group
%rule alter_identity_column_option
%rule alter_identity_column_specification
%rule alter_routine_behavior
%rule alter_routine_characteristic
%rule alter_routine_characteristics
%rule alter_routine_statement
%rule alter_sequence_generator_option
%rule alter_sequence_generator_options
%rule alter_sequence_generator_restart_option
%rule alter_sequence_generator_statement
%rule alter_table_action
%rule alter_table_statement
%rule alter_transform_action
%rule alter_transform_action_list
%rule alter_transform_statement
%rule alter_type_action
%rule alter_type_statement
%rule ampersand
%rule approximate_numeric_literal
%rule approximate_numeric_type
%rule array_concatenation
%rule array_element
%rule array_element_list
%rule array_element_reference
%rule array_factor
%rule array_type
%rule array_value_constructor
%rule array_value_constructor_by_enumeration
%rule array_value_constructor_by_query
%rule array_value_expression
%rule array_value_expression_1
%rule as_clause
%rule as_subquery_clause
%rule assertion_definition
%rule assigned_row
%rule asterisk
%rule asterisked_identifier
%rule asterisked_identifier_chain
%rule attribute_default
%rule attribute_definition
%rule attribute_name
%rule attribute_or_method_reference
%rule attributes_specification
%rule attributes_variable
%rule authorization_identifier
%rule basic_identifier_chain
%rule basic_sequence_generator_option
%rule between_predicate
%rule between_predicate_part_2
%rule binary_large_object_string_type
%rule binary_set_function
%rule binary_set_function_type
%rule binary_string_literal
%rule bit_string_literal
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
%rule boolean_predicand
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
%rule c_multiset_locator_variable
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
%rule ceiling_function
%rule char_length_expression
%rule char_length_units
%rule character_enumeration
%rule character_enumeration_exclude
%rule character_enumeration_include
%rule character_factor
%rule character_like_predicate
%rule character_like_predicate_part_2
%rule character_overlay_function
%rule character_pattern
%rule character_primary
%rule character_representation
%rule character_set_definition
%rule character_set_name
%rule character_set_name_characteristic
%rule character_set_source
%rule character_set_specification
%rule character_set_specification_list
%rule character_specifier
%rule character_string_literal
%rule character_string_type
%rule character_substring_function
%rule character_transliteration
%rule character_value_expression
%rule character_value_function
%rule check_constraint_definition
%rule circumflex
%rule close_statement
%rule cobol_array_locator_variable
%rule cobol_binary_integer
%rule cobol_blob_locator_variable
%rule cobol_blob_variable
%rule cobol_character_type
%rule cobol_clob_locator_variable
%rule cobol_clob_variable
%rule cobol_derived_type_specification
%rule cobol_host_identifier
%rule cobol_integer_type
%rule cobol_multiset_locator_variable
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
%rule collation_specification
%rule collection_derived_table
%rule collection_type
%rule collection_value_constructor
%rule collection_value_expression
%rule colon
%rule column_constraint
%rule column_constraint_definition
%rule column_default_option
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
%rule common_sequence_generator_option
%rule common_sequence_generator_options
%rule common_value_expression
%rule comp_op
%rule comparison_predicate
%rule comparison_predicate_part_2
%rule computational_operation
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
%rule connection_user_name
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
%rule contextually_typed_table_value_constructor
%rule contextually_typed_value_specification
%rule correlation_name
%rule corresponding_column_list
%rule corresponding_spec
%rule cross_join
%rule cube_list
%rule current_collation_specification
%rule current_date_value_function
%rule current_local_time_value_function
%rule current_local_timestamp_value_function
%rule current_time_value_function
%rule current_timestamp_value_function
%rule cursor_attribute
%rule cursor_attributes
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
%rule declare_cursor
%rule default_clause
%rule default_option
%rule default_specification
%rule delete_rule
%rule delete_statement_positioned
%rule delete_statement_searched
%rule delimited_identifier
%rule delimited_identifier_part
%rule delimiter_token
%rule dependent_variable_expression
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
%rule distinct_predicate_part_2
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
%rule drop_role_statement
%rule drop_routine_statement
%rule drop_schema_statement
%rule drop_sequence_generator_statement
%rule drop_table_constraint_definition
%rule drop_table_statement
%rule drop_transform_element_list
%rule drop_transform_statement
%rule drop_transliteration_statement
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
%rule else_clause
%rule embedded_authorization_clause
%rule embedded_authorization_declaration
%rule embedded_authorization_identifier
%rule embedded_character_set_declaration
%rule embedded_collation_specification
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
%rule empty_grouping_set
%rule empty_specification
%rule end_field
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
%rule existing_transliteration_name
%rule existing_window_name
%rule exists_predicate
%rule explicit_row_value_constructor
%rule explicit_table
%rule exponent
%rule exponential_function
%rule extended_cursor_name
%rule extended_statement_name
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
%rule filter_clause
%rule finality
%rule floor_function
%rule fold
%rule fortran_array_locator_variable
%rule fortran_blob_locator_variable
%rule fortran_blob_variable
%rule fortran_clob_locator_variable
%rule fortran_clob_variable
%rule fortran_derived_type_specification
%rule fortran_host_identifier
%rule fortran_multiset_locator_variable
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
%rule generation_clause
%rule generation_expression
%rule generation_rule
%rule get_descriptor_information
%rule get_descriptor_statement
%rule get_diagnostics_statement
%rule get_header_information
%rule get_item_information
%rule global_or_local
%rule go_to
%rule goto_target
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
%rule handler_declaration
%rule having_clause
%rule header_item_name
%rule hex_string_literal
%rule hexit
%rule high_value
%rule hold_locator_statement
%rule host_identifier
%rule host_label_identifier
%rule host_parameter_data_type
%rule host_parameter_declaration
%rule host_parameter_declaration_list
%rule host_parameter_name
%rule host_parameter_specification
%rule host_pl_i_label_variable
%rule host_variable_definition
%rule hours_value
%rule hypothetical_set_function
%rule hypothetical_set_function_value_expression_list
%rule identifier
%rule identifier_body
%rule identifier_chain
%rule identifier_extend
%rule identifier_part
%rule identifier_start
%rule identity_column_specification
%rule identity_option
%rule ideographic_character
%rule implementation_defined_character_set_name
%rule implicitly_typed_value_specification
%rule in_line_window_specification
%rule in_predicate
%rule in_predicate_part_2
%rule in_predicate_value
%rule in_value_list
%rule inclusive_user_defined_type_specification
%rule independent_variable_expression
%rule indicator_parameter
%rule indicator_variable
%rule initial_alphabetic_character
%rule input_using_clause
%rule insert_column_list
%rule insert_columns_and_source
%rule insert_statement
%rule insertion_target
%rule instantiable_clause
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
%rule inverse_distribution_function
%rule inverse_distribution_function_argument
%rule inverse_distribution_function_type
%rule isolation_level
%rule item_number
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
%rule left_brace
%rule left_bracket
%rule left_bracket_or_trigraph
%rule left_bracket_trigraph
%rule left_paren
%rule length
%rule length_expression
%rule less_than_operator
%rule less_than_or_equals_operator
%rule level_of_isolation
%rule levels_clause
%rule like_clause
%rule like_options
%rule like_predicate
%rule list_of_attributes
%rule literal
%rule local_or_schema_qualified_name
%rule local_or_schema_qualifier
%rule local_qualified_name
%rule local_qualifier
%rule locator_indication
%rule locator_reference
%rule low_value
%rule major_category
%rule mantissa
%rule map_category
%rule map_function_specification
%rule match_predicate
%rule match_predicate_part_2
%rule match_type
%rule maximum_dynamic_result_sets
%rule member
%rule member_list
%rule member_name
%rule member_name_alternatives
%rule member_predicate
%rule member_predicate_part_2
%rule merge_correlation_name
%rule merge_insert_specification
%rule merge_insert_value_element
%rule merge_insert_value_list
%rule merge_operation_specification
%rule merge_statement
%rule merge_update_specification
%rule merge_when_clause
%rule merge_when_matched_clause
%rule merge_when_not_matched_clause
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
%rule module_authorization_clause
%rule module_authorization_identifier
%rule module_character_set_specification
%rule module_collation
%rule module_collation_specification
%rule module_collations
%rule module_contents
%rule module_name_clause
%rule module_path_specification
%rule module_transform_group_specification
%rule modulus_expression
%rule months_value
%rule multiple_column_assignment
%rule multiple_group_specification
%rule multiplier
%rule multiset_element
%rule multiset_element_list
%rule multiset_element_reference
%rule multiset_primary
%rule multiset_set_function
%rule multiset_term
%rule multiset_type
%rule multiset_value_constructor
%rule multiset_value_constructor_by_enumeration
%rule multiset_value_constructor_by_query
%rule multiset_value_expression
%rule multiset_value_function
%rule multset_value_expression
%rule mumps_array_locator_variable
%rule mumps_blob_locator_variable
%rule mumps_blob_variable
%rule mumps_character_variable
%rule mumps_clob_locator_variable
%rule mumps_clob_variable
%rule mumps_derived_type_specification
%rule mumps_host_identifier
%rule mumps_length_specification
%rule mumps_multiset_locator_variable
%rule mumps_numeric_variable
%rule mumps_ref_variable
%rule mumps_type_specification
%rule mumps_user_defined_type_locator_variable
%rule mumps_user_defined_type_variable
%rule mumps_variable_definition
%rule mutated_set_clause
%rule mutated_target
%rule named_columns_join
%rule national_character_string_literal
%rule national_character_string_type
%rule natural_join
%rule natural_logarithm
%rule nesting_option
%rule new_invocation
%rule new_specification
%rule new_values_correlation_name
%rule new_values_table_alias
%rule new_window_name
%rule newline
%rule next_value_expression
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
%rule normalize_function
%rule normalized_predicate
%rule not_equals_operator
%rule null_call_clause
%rule null_ordering
%rule null_predicate
%rule null_predicate_part_2
%rule null_specification
%rule number_of_conditions
%rule numeric_primary
%rule numeric_type
%rule numeric_value_expression
%rule numeric_value_expression_base
%rule numeric_value_expression_dividend
%rule numeric_value_expression_divisor
%rule numeric_value_expression_exponent
%rule numeric_value_function
%rule object_column
%rule object_name
%rule object_privileges
%rule occurrences
%rule octet_length_expression
%rule octet_like_predicate
%rule octet_like_predicate_part_2
%rule octet_pattern
%rule old_or_new_values_alias
%rule old_or_new_values_alias_list
%rule old_values_correlation_name
%rule old_values_table_alias
%rule only_spec
%rule open_statement
%rule order_by_clause
%rule ordered_set_function
%rule ordering_category
%rule ordering_form
%rule ordering_specification
%rule ordinary_grouping_set
%rule ordinary_grouping_set_list
%rule original_method_specification
%rule outer_join_type
%rule output_using_clause
%rule overlaps_predicate
%rule overlaps_predicate_part
%rule overlaps_predicate_part_1
%rule overlaps_predicate_part_2
%rule override_clause
%rule overriding_method_specification
%rule pad_characteristic
%rule parameter_mode
%rule parameter_style
%rule parameter_style_clause
%rule parameter_type
%rule parameter_using_clause
%rule parenthesized_boolean_value_expression
%rule parenthesized_value_expression
%rule partial_method_specification
%rule pascal_array_locator_variable
%rule pascal_blob_locator_variable
%rule pascal_blob_variable
%rule pascal_clob_locator_variable
%rule pascal_clob_variable
%rule pascal_derived_type_specification
%rule pascal_host_identifier
%rule pascal_multiset_locator_variable
%rule pascal_ref_variable
%rule pascal_type_specification
%rule pascal_user_defined_type_locator_variable
%rule pascal_user_defined_type_variable
%rule pascal_variable_definition
%rule path_column
%rule path_resolved_user_defined_type_name
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
%rule pl_i_multiset_locator_variable
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
%rule power_function
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
%rule quantified_comparison_predicate_part_2
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
%rule rank_function_type
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
%rule repeat_argument
%rule repeat_factor
%rule repeatable_clause
%rule representation
%rule reserved_word
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
%rule returns_table_type
%rule returns_type
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
%rule rights_clause
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
%rule row_value_constructor_predicand
%rule row_value_expression
%rule row_value_expression_list
%rule row_value_predicand
%rule row_value_predicand_1
%rule row_value_predicand_2
%rule row_value_predicand_3
%rule row_value_predicand_4
%rule row_value_special_case
%rule sample_clause
%rule sample_method
%rule sample_percentage
%rule savepoint_clause
%rule savepoint_level_indication
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
%rule schema_resolved_user_defined_type_name
%rule schema_routine
%rule scope_clause
%rule scope_option
%rule search_clause
%rule search_condition
%rule search_or_cycle_clause
%rule searched_case
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
%rule sequence_generator_cycle_option
%rule sequence_generator_data_type_option
%rule sequence_generator_definition
%rule sequence_generator_increment
%rule sequence_generator_increment_by_option
%rule sequence_generator_max_value
%rule sequence_generator_maxvalue_option
%rule sequence_generator_min_value
%rule sequence_generator_minvalue_option
%rule sequence_generator_name
%rule sequence_generator_option
%rule sequence_generator_options
%rule sequence_generator_restart_value
%rule sequence_generator_start_value
%rule sequence_generator_start_with_option
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
%rule set_predicate
%rule set_predicate_part_2
%rule set_quantifier
%rule set_role_statement
%rule set_schema_statement
%rule set_session_characteristics_statement
%rule set_session_collation_statement
%rule set_session_user_identifier_statement
%rule set_target
%rule set_target_list
%rule set_time_zone_value
%rule set_transaction_statement
%rule set_transform_group_statement
%rule sign
%rule signed_integer
%rule signed_numeric_literal
%rule similar_pattern
%rule similar_predicate
%rule similar_predicate_part_2
%rule simple_case
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
%rule sql_connection_statement
%rule sql_control_statement
%rule sql_data_access_indication
%rule sql_data_change_statement
%rule sql_data_statement
%rule sql_diagnostics_information
%rule sql_diagnostics_statement
%rule sql_dynamic_data_statement
%rule sql_dynamic_statement
%rule sql_executable_statement
%rule sql_invoked_function
%rule sql_invoked_procedure
%rule sql_invoked_routine
%rule sql_language_character
%rule sql_language_identifier
%rule sql_language_identifier_part
%rule sql_language_identifier_start
%rule sql_parameter_declaration
%rule sql_parameter_declaration_list
%rule sql_parameter_name
%rule sql_parameter_reference
%rule sql_path_characteristic
%rule sql_prefix
%rule sql_procedure_statement
%rule sql_routine_body
%rule sql_routine_spec
%rule sql_schema_definition_statement
%rule sql_schema_manipulation_statement
%rule sql_schema_statement
%rule sql_server_name
%rule sql_session_statement
%rule sql_special_character
%rule sql_statement_name
%rule sql_statement_variable
%rule sql_terminal_character
%rule sql_terminator
%rule sql_transaction_statement
%rule sqlstate_char
%rule sqlstate_class_value
%rule sqlstate_subclass_value
%rule square_root
%rule standard_character_set_name
%rule start_field
%rule start_position
%rule start_transaction_statement
%rule state_category
%rule statement_cursor
%rule statement_information
%rule statement_information_item
%rule statement_information_item_name
%rule statement_name
%rule statement_or_declaration
%rule static_method_invocation
%rule static_method_selection
%rule status_parameter
%rule string_length
%rule string_position_expression
%rule string_value_expression
%rule string_value_function
%rule submultiset_predicate
%rule submultiset_predicate_part_2
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
%rule table_function_column_list
%rule table_function_column_list_element
%rule table_function_derived_table
%rule table_name
%rule table_or_query_name
%rule table_primary
%rule table_primary_or_joined_table
%rule table_reference
%rule table_reference_list
%rule table_row_value_expression
%rule table_scope
%rule table_subquery
%rule table_value_constructor
%rule table_value_constructor_by_query
%rule target_array_element_specification
%rule target_array_reference
%rule target_character_set_specification
%rule target_data_type
%rule target_specification
%rule target_subtype
%rule target_table
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
%rule to_sql
%rule to_sql_function
%rule token
%rule transaction_access_mode
%rule transaction_characteristics
%rule transaction_mode
%rule transcoding
%rule transcoding_name
%rule transform_definition
%rule transform_element
%rule transform_element_list
%rule transform_group
%rule transform_group_characteristic
%rule transform_group_element
%rule transform_group_specification
%rule transform_kind
%rule transforms_to_be_dropped
%rule transliteration_definition
%rule transliteration_name
%rule transliteration_routine
%rule transliteration_source
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
%rule type_predicate_part_2
%rule underscore
%rule unicode_4_digit_escape_value
%rule unicode_6_digit_escape_value
%rule unicode_character_string_literal
%rule unicode_delimited_identifier
%rule unicode_delimiter_body
%rule unicode_escape_value
%rule unicode_identifier_part
%rule unicode_representation
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
%rule upper_limit
%rule user_defined_cast_definition
%rule user_defined_character_set_name
%rule user_defined_ordering_definition
%rule user_defined_representation
%rule user_defined_type_body
%rule user_defined_type_definition
%rule user_defined_type_name
%rule user_defined_type_option
%rule user_defined_type_option_list
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
%rule white_space
%rule width_bucket_bound_1
%rule width_bucket_bound_2
%rule width_bucket_count
%rule width_bucket_function
%rule width_bucket_operand
%rule window_clause
%rule window_definition
%rule window_definition_list
%rule window_frame_between
%rule window_frame_bound
%rule window_frame_bound_1
%rule window_frame_bound_2
%rule window_frame_clause
%rule window_frame_exclusion
%rule window_frame_extent
%rule window_frame_following
%rule window_frame_preceding
%rule window_frame_start
%rule window_frame_units
%rule window_function
%rule window_function_type
%rule window_name
%rule window_name_or_specification
%rule window_order_clause
%rule window_partition_clause
%rule window_partition_column_reference
%rule window_partition_column_reference_list
%rule window_specification
%rule window_specification_details
%rule with_clause
%rule with_column_list
%rule with_list
%rule with_list_element
%rule with_or_without_data
%rule with_or_without_time_zone
%rule within_group_specification
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
	:	alter_type_action
	|	constructor_method_selection
	|	cursor_attributes
	|	dereference_operation
	|	direct_sql_statement
	|	doublequote_symbol
	|	embedded_sql_declare_section
	|	embedded_sql_host_program
	|	embedded_sql_statement
	|	fortran_derived_type_specification
	|	independent_variable_expression
	|	method_reference
	|	method_selection
	|	new_invocation
	|	nondoublequote_character
	|	preparable_statement
	|	sequence_generator_increment
	|	sequence_generator_max_value
	|	sql_client_module_definition
	|	sql_terminal_character
	|	sqlstate_class_value
	|	sqlstate_subclass_value
	|	static_method_selection
	|	token
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
	:	/* !! See the Syntax Rules */
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

left_bracket_or_trigraph
	:	left_bracket
	|	left_bracket_trigraph
	;

right_bracket_or_trigraph
	:	right_bracket
	|	right_bracket_trigraph
	;

left_bracket
	:	'['
	;

left_bracket_trigraph
	:	
	;

right_bracket
	:	']'
	;

right_bracket_trigraph
	:	
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

regular_identifier
	:	identifier_body
	;

lst_nt_002
	:	identifier_part
	|	lst_nt_002 identifier_part
	;

opt_nt_001
	:	/* Nothing */
	|	lst_nt_002 ']'
	;

identifier_body
	:	identifier_start opt_nt_001
	;

identifier_part
	:	identifier_start
	|	identifier_extend
	;

identifier_start
	:	initial_alphabetic_character
	|	ideographic_character
	;

identifier_start
	:	/* !! See the Syntax Rules */
	;

identifier_extend
	:	/* !! See the Syntax Rules */
	;

lst_nt_003
	:	digit
	|	lst_nt_003 digit
	;

large_object_length_token
	:	lst_nt_003 multiplier
	;

multiplier
	:	K
	|	M
	|	G
	;

lst_nt_004
	:	unicode_delimiter_body
	|	lst_nt_004 unicode_delimiter_body
	;

opt_nt_005
	:	/* Nothing */
	|	ESCAPE escape_character ']'
	;

unicode_delimited_identifier
	:	U ampersand double_quote lst_nt_004 double_quote opt_nt_005
	;

lst_nt_006
	:	unicode_identifier_part
	|	lst_nt_006 unicode_identifier_part
	;

unicode_delimiter_body
	:	lst_nt_006
	;

unicode_identifier_part
	:	delimited_identifier_part
	|	unicode_escape_value
	;

unicode_escape_value
	:	unicode_4_digit_escape_value
	|	unicode_6_digit_escape_value
	;

unicode_4_digit_escape_value
	:	escape_character hexit hexit hexit hexit
	;

unicode_6_digit_escape_value
	:	escape_character plus_sign hexit hexit hexit hexit hexit hexit
	;

escape_character
	:	/* !! See the Syntax Rules */
	;

nondoublequote_character
	:	/* !! See the Syntax Rules */
	;

doublequote_symbol
	:	double_quote double_quote
	;

delimiter_token
	:	character_string_literal
	|	date_string
	|	time_string
	|	timestamp_string
	|	interval_string
	|	delimited_identifier
	|	unicode_delimited_identifier
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

not_equals_operator
	:	less_than_operator greater_than_operator
	;

greater_than_or_equals_operator
	:	greater_than_operator equals_operator
	;

less_than_or_equals_operator
	:	less_than_operator equals_operator
	;

concatenation_operator
	:	vertical_bar vertical_bar
	;

right_arrow
	:	minus_sign greater_than_operator
	;

double_colon
	:	colon colon
	;

double_period
	:	period period
	;

seq_nt_007
	:	comment
	|	white_space
	;

lst_nt_008
	:	seq_nt_007
	|	lst_nt_008 seq_nt_007
	;

separator
	:	lst_nt_008
	;

comment
	:	simple_comment
	|	bracketed_comment
	;

lst_nt_010
	:	comment_character
	|	lst_nt_010 comment_character
	;

opt_nt_009
	:	/* Nothing */
	|	lst_nt_010
	;

simple_comment
	:	simple_comment_introducer opt_nt_009 newline
	;

lst_nt_012
	:	minus_sign
	|	lst_nt_012 minus_sign
	;

opt_nt_011
	:	/* Nothing */
	|	lst_nt_012 ']'
	;

simple_comment_introducer
	:	minus_sign minus_sign opt_nt_011
	;

bracketed_comment
	:	bracketed_comment_introducer bracketed_comment_contents bracketed_comment_terminator
	;

bracketed_comment_introducer
	:	slash asterisk
	;

bracketed_comment_terminator
	:	asterisk slash
	;

seq_nt_014
	:	comment_character
	|	separator
	;

lst_nt_015
	:	seq_nt_014
	|	lst_nt_015 seq_nt_014
	;

opt_nt_013
	:	/* Nothing */
	|	lst_nt_015 ']'
	;

bracketed_comment_contents
	:	opt_nt_013
	;

comment_character
	:	nonquote_character
	|	quote
	;

newline
	:	/* !! See the Syntax Rules */
	;

key_word
	:	reserved_word
	|	non_reserved_word
	;

non_reserved_word
	:	A
	|	ABS
	|	ABSOLUTE
	|	ACTION
	|	ADA
	|	ADMIN
	|	AFTER
	|	ALWAYS
	|	ASC
	|	ASSERTION
	|	ASSIGNMENT
	|	ATTRIBUTE
	|	ATTRIBUTES
	|	AVG
	|	BEFORE
	|	BERNOULLI
	|	BREADTH
	|	C
	|	CARDINALITY
	|	CASCADE
	|	CATALOG
	|	CATALOG_NAME
	|	CEIL
	|	CEILING
	|	CHAIN
	|	CHARACTERISTICS
	|	CHARACTERS
	|	CHARACTER_LENGTH
	|	CHARACTER_SET_CATALOG
	|	CHARACTER_SET_NAME
	|	CHARACTER_SET_SCHEMA
	|	CHAR_LENGTH
	|	CHECKED
	|	CLASS_ORIGIN
	|	COALESCE
	|	COBOL
	|	CODE_UNITS
	|	COLLATION
	|	COLLATION_CATALOG
	|	COLLATION_NAME
	|	COLLATION_SCHEMA
	|	COLLECT
	|	COLUMN_NAME
	|	COMMAND_FUNCTION
	|	COMMAND_FUNCTION_CODE
	|	COMMITTED
	|	CONDITION
	|	CONDITION_NUMBER
	|	CONNECTION_NAME
	|	CONSTRAINTS
	|	CONSTRAINT_CATALOG
	|	CONSTRAINT_NAME
	|	CONSTRAINT_SCHEMA
	|	CONSTRUCTORS
	|	CONTAINS
	|	CONVERT
	|	CORR
	|	COUNT
	|	COVAR_POP
	|	COVAR_SAMP
	|	CUME_DIST
	|	CURRENT_COLLATION
	|	CURSOR_NAME
	|	DATA
	|	DATETIME_INTERVAL_CODE
	|	DATETIME_INTERVAL_PRECISION
	|	DEFAULTS
	|	DEFERRABLE
	|	DEFERRED
	|	DEFINED
	|	DEFINER
	|	DEGREE
	|	DENSE_RANK
	|	DEPTH
	|	DERIVED
	|	DESC
	|	DESCRIPTOR
	|	DIAGNOSTICS
	|	DISPATCH
	|	DOMAIN
	|	DYNAMIC_FUNCTION
	|	DYNAMIC_FUNCTION_CODE
	|	EQUALS
	|	EVERY
	|	EXCEPTION
	|	EXCLUDE
	|	EXCLUDING
	|	EXP
	|	EXTRACT
	|	FINAL
	|	FIRST
	|	FLOOR
	|	FOLLOWING
	|	FORTRAN
	|	FOUND
	|	FUSION
	|	G
	|	GENERAL
	|	GO
	|	GOTO
	|	GRANTED
	|	HIERARCHY
	|	IMPLEMENTATION
	|	INCLUDING
	|	INCREMENT
	|	INITIALLY
	|	INSTANCE
	|	INSTANTIABLE
	|	INTERSECTION
	|	INVOKER
	|	ISOLATION
	|	K
	|	KEY
	|	KEY_MEMBER
	|	KEY_TYPE
	|	LAST
	|	LENGTH
	|	LEVEL
	|	LN
	|	LOCATOR
	|	LOWER
	|	M
	|	MAP
	|	MATCHED
	|	MAX
	|	MAXVALUE
	|	MESSAGE_LENGTH
	|	MESSAGE_OCTET_LENGTH
	|	MESSAGE_TEXT
	|	MIN
	|	MINVALUE
	|	MOD
	|	MORE
	|	MUMPS
	|	NAME
	|	NAMES
	|	NESTING
	|	NEXT
	|	NORMALIZE
	|	NORMALIZED
	|	NULLABLE
	|	NULLIF
	|	NULLS
	|	NUMBER
	|	OBJECT
	|	OCTETS
	|	OCTET_LENGTH
	|	OPTION
	|	OPTIONS
	|	ORDERING
	|	ORDINALITY
	|	OTHERS
	|	OVERLAY
	|	OVERRIDING
	|	PAD
	|	PARAMETER_MODE
	|	PARAMETER_NAME
	|	PARAMETER_ORDINAL_POSITION
	|	PARAMETER_SPECIFIC_CATALOG
	|	PARAMETER_SPECIFIC_NAME
	|	PARAMETER_SPECIFIC_SCHEMA
	|	PARTIAL
	|	PASCAL
	|	PATH
	|	PERCENTILE_CONT
	|	PERCENTILE_DISC
	|	PERCENT_RANK
	|	PLACING
	|	PLI
	|	POSITION
	|	POWER
	|	PRECEDING
	|	PRESERVE
	|	PRIOR
	|	PRIVILEGES
	|	PUBLIC
	|	RANK
	|	READ
	|	REGR_AVGX
	|	REGR_AVGY
	|	REGR_COUNT
	|	REGR_INTERCEPT
	|	REGR_R2
	|	REGR_SLOPE
	|	REGR_SXX
	|	REGR_SXY
	|	REGR_SXY
	|	RELATIVE
	|	REPEATABLE
	|	RESTART
	|	RESULT
	|	RETURNED_CARDINALITY
	|	RETURNED_LENGTH
	|	RETURNED_OCTET_LENGTH
	|	RETURNED_SQLSTATE
	|	ROLE
	|	ROUTINE
	|	ROUTINE_CATALOG
	|	ROUTINE_NAME
	|	ROUTINE_SCHEMA
	|	ROW_COUNT
	|	ROW_NUMBER
	|	SCALE
	|	SCHEMA
	|	SCHEMA_NAME
	|	SCOPE_CATALOG
	|	SCOPE_NAME
	|	SCOPE_SCHEMA
	|	SECTION
	|	SECURITY
	|	SELF
	|	SEQUENCE
	|	SERIALIZABLE
	|	SERVER_NAME
	|	SESSION
	|	SETS
	|	SIMPLE
	|	SIZE
	|	SOURCE
	|	SPACE
	|	SPECIFIC_NAME
	|	SQRT
	|	STATE
	|	STATEMENT
	|	STDDEV_POP
	|	STDDEV_SAMP
	|	STRUCTURE
	|	STYLE
	|	SUBCLASS_ORIGIN
	|	SUBSTRING
	|	SUM
	|	TABLESAMPLE
	|	TABLE_NAME
	|	TEMPORARY
	|	TIES
	|	TOP_LEVEL_COUNT
	|	TRANSACTION
	|	TRANSACTIONS_COMMITTED
	|	TRANSACTIONS_ROLLED_BACK
	|	TRANSACTION_ACTIVE
	|	TRANSFORM
	|	TRANSFORMS
	|	TRANSLATE
	|	TRIGGER_CATALOG
	|	TRIGGER_NAME
	|	TRIGGER_SCHEMA
	|	TRIM
	|	TYPE
	|	UNBOUNDED
	|	UNCOMMITTED
	|	UNDER
	|	UNNAMED
	|	UPPER
	|	USAGE
	|	USER_DEFINED_TYPE_CATALOG
	|	USER_DEFINED_TYPE_CODE
	|	USER_DEFINED_TYPE_NAME
	|	USER_DEFINED_TYPE_SCHEMA
	|	VAR_POP
	|	VAR_SAMP
	|	VIEW
	|	WIDTH_BUCKET
	|	WORK
	|	WRITE
	|	ZONE
	;

reserved_word
	:	ADD
	|	ALL
	|	ALLOCATE
	|	ALTER
	|	AND
	|	ANY
	|	ARE
	|	ARRAY
	|	AS
	|	ASENSITIVE
	|	ASYMMETRIC
	|	AT
	|	ATOMIC
	|	AUTHORIZATION
	|	BEGIN
	|	BETWEEN
	|	BIGINT
	|	BINARY
	|	BLOB
	|	BOOLEAN
	|	BOTH
	|	BY
	|	CALL
	|	CALLED
	|	CASCADED
	|	CASE
	|	CAST
	|	CHAR
	|	CHARACTER
	|	CHECK
	|	CLOB
	|	CLOSE
	|	COLLATE
	|	COLUMN
	|	COMMIT
	|	CONNECT
	|	CONSTRAINT
	|	CONTINUE
	|	CORRESPONDING
	|	CREATE
	|	CROSS
	|	CUBE
	|	CURRENT
	|	CURRENT_DATE
	|	CURRENT_DEFAULT_TRANSFORM_GROUP
	|	CURRENT_PATH
	|	CURRENT_ROLE
	|	CURRENT_TIME
	|	CURRENT_TIMESTAMP
	|	CURRENT_TRANSFORM_GROUP_FOR_TYPE
	|	CURRENT_USER
	|	CURSOR
	|	CYCLE
	|	DATE
	|	DAY
	|	DEALLOCATE
	|	DEC
	|	DECIMAL
	|	DECLARE
	|	DEFAULT
	|	DELETE
	|	DEREF
	|	DESCRIBE
	|	DETERMINISTIC
	|	DISCONNECT
	|	DISTINCT
	|	DOUBLE
	|	DROP
	|	DYNAMIC
	|	EACH
	|	ELEMENT
	|	ELSE
	|	END
	|	END-EXEC
	|	ESCAPE
	|	EXCEPT
	|	EXEC
	|	EXECUTE
	|	EXISTS
	|	EXTERNAL
	|	FALSE
	|	FETCH
	|	FILTER
	|	FLOAT
	|	FOR
	|	FOREIGN
	|	FREE
	|	FROM
	|	FULL
	|	FUNCTION
	|	GET
	|	GLOBAL
	|	GRANT
	|	GROUP
	|	GROUPING
	|	HAVING
	|	HOLD
	|	HOUR
	|	IDENTITY
	|	IMMEDIATE
	|	IN
	|	INDICATOR
	|	INNER
	|	INOUT
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
	|	LANGUAGE
	|	LARGE
	|	LATERAL
	|	LEADING
	|	LEFT
	|	LIKE
	|	LOCAL
	|	LOCALTIME
	|	LOCALTIMESTAMP
	|	MATCH
	|	MEMBER
	|	MERGE
	|	METHOD
	|	MINUTE
	|	MODIFIES
	|	MODULE
	|	MONTH
	|	MULTISET
	|	NATIONAL
	|	NATURAL
	|	NCHAR
	|	NCLOB
	|	NEW
	|	NO
	|	NONE
	|	NOT
	|	NULL
	|	NUMERIC
	|	OF
	|	OLD
	|	ON
	|	ONLY
	|	OPEN
	|	OR
	|	ORDER
	|	OUT
	|	OUTER
	|	OUTPUT
	|	OVER
	|	OVERLAPS
	|	PARAMETER
	|	PARTITION
	|	PRECISION
	|	PREPARE
	|	PRIMARY
	|	PROCEDURE
	|	RANGE
	|	READS
	|	REAL
	|	RECURSIVE
	|	REF
	|	REFERENCES
	|	REFERENCING
	|	RELEASE
	|	RETURN
	|	RETURNS
	|	REVOKE
	|	RIGHT
	|	ROLLBACK
	|	ROLLUP
	|	ROW
	|	ROWS
	|	SAVEPOINT
	|	SCROLL
	|	SEARCH
	|	SECOND
	|	SELECT
	|	SENSITIVE
	|	SESSION_USER
	|	SET
	|	SIMILAR
	|	SMALLINT
	|	SOME
	|	SPECIFIC
	|	SPECIFICTYPE
	|	SQL
	|	SQLEXCEPTION
	|	SQLSTATE
	|	SQLWARNING
	|	START
	|	STATIC
	|	SUBMULTISET
	|	SYMMETRIC
	|	SYSTEM
	|	SYSTEM_USER
	|	TABLE
	|	THEN
	|	TIME
	|	TIMESTAMP
	|	TIMEZONE_HOUR
	|	TIMEZONE_MINUTE
	|	TO
	|	TRAILING
	|	TRANSLATION
	|	TREAT
	|	TRIGGER
	|	TRUE
	|	UNION
	|	UNIQUE
	|	UNKNOWN
	|	UNNEST
	|	UPDATE
	|	USER
	|	USING
	|	VALUE
	|	VALUES
	|	VARCHAR
	|	VARYING
	|	WHEN
	|	WHENEVER
	|	WHERE
	|	WINDOW
	|	WITH
	|	WITHIN
	|	WITHOUT
	|	YEAR
	;

literal
	:	signed_numeric_literal
	|	general_literal
	;

unsigned_literal
	:	unsigned_numeric_literal
	|	general_literal
	;

general_literal
	:	character_string_literal
	|	national_character_string_literal
	|	unicode_character_string_literal
	|	binary_string_literal
	|	datetime_literal
	|	interval_literal
	|	boolean_literal
	;

opt_nt_016
	:	/* Nothing */
	|	introducer character_set_specification
	;

lst_nt_018
	:	character_representation
	|	lst_nt_018 character_representation
	;

opt_nt_017
	:	/* Nothing */
	|	lst_nt_018
	;

lst_nt_022
	:	character_representation
	|	lst_nt_022 character_representation
	;

opt_nt_021
	:	/* Nothing */
	|	lst_nt_022
	;

seq_nt_020
	:	separator quote opt_nt_021 quote
	;

lst_nt_023
	:	seq_nt_020
	|	lst_nt_023 seq_nt_020
	;

opt_nt_019
	:	/* Nothing */
	|	lst_nt_023 ']'
	;

character_string_literal
	:	opt_nt_016 quote opt_nt_017 quote opt_nt_019
	;

introducer
	:	underscore
	;

character_representation
	:	nonquote_character
	|	quote_symbol
	;

nonquote_character
	:	/* !! See the Syntax Rules */
	;

quote_symbol
	:	quote quote
	;

lst_nt_025
	:	character_representation
	|	lst_nt_025 character_representation
	;

opt_nt_024
	:	/* Nothing */
	|	lst_nt_025
	;

lst_nt_029
	:	character_representation
	|	lst_nt_029 character_representation
	;

opt_nt_028
	:	/* Nothing */
	|	lst_nt_029
	;

seq_nt_027
	:	separator quote opt_nt_028 quote
	;

lst_nt_030
	:	seq_nt_027
	|	lst_nt_030 seq_nt_027
	;

opt_nt_026
	:	/* Nothing */
	|	lst_nt_030 ']'
	;

national_character_string_literal
	:	N quote opt_nt_024 quote opt_nt_026
	;

opt_nt_031
	:	/* Nothing */
	|	introducer character_set_specification
	;

lst_nt_033
	:	unicode_representation
	|	lst_nt_033 unicode_representation
	;

opt_nt_032
	:	/* Nothing */
	|	lst_nt_033
	;

lst_nt_037
	:	unicode_representation
	|	lst_nt_037 unicode_representation
	;

opt_nt_036
	:	/* Nothing */
	|	lst_nt_037
	;

seq_nt_035
	:	separator quote opt_nt_036 quote
	;

lst_nt_038
	:	seq_nt_035
	|	lst_nt_038 seq_nt_035
	;

opt_nt_034
	:	/* Nothing */
	|	lst_nt_038
	;

opt_nt_039
	:	/* Nothing */
	|	ESCAPE escape_character ']'
	;

unicode_character_string_literal
	:	opt_nt_031 U ampersand quote opt_nt_032 quote opt_nt_034 opt_nt_039
	;

unicode_representation
	:	character_representation
	|	unicode_escape_value
	;

seq_nt_041
	:	hexit hexit
	;

lst_nt_042
	:	seq_nt_041
	|	lst_nt_042 seq_nt_041
	;

opt_nt_040
	:	/* Nothing */
	|	lst_nt_042
	;

seq_nt_046
	:	hexit hexit
	;

lst_nt_047
	:	seq_nt_046
	|	lst_nt_047 seq_nt_046
	;

opt_nt_045
	:	/* Nothing */
	|	lst_nt_047
	;

seq_nt_044
	:	separator quote opt_nt_045 quote
	;

lst_nt_048
	:	seq_nt_044
	|	lst_nt_048 seq_nt_044
	;

opt_nt_043
	:	/* Nothing */
	|	lst_nt_048
	;

opt_nt_049
	:	/* Nothing */
	|	ESCAPE escape_character ']'
	;

binary_string_literal
	:	X quote opt_nt_040 quote opt_nt_043 opt_nt_049
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

opt_nt_050
	:	/* Nothing */
	|	sign
	;

signed_numeric_literal
	:	opt_nt_050 unsigned_numeric_literal
	;

unsigned_numeric_literal
	:	exact_numeric_literal
	|	approximate_numeric_literal
	;

opt_nt_052
	:	/* Nothing */
	|	unsigned_integer
	;

opt_nt_051
	:	/* Nothing */
	|	period opt_nt_052
	;

exact_numeric_literal
	:	unsigned_integer opt_nt_051
	|	period unsigned_integer
	;

sign
	:	plus_sign
	|	minus_sign
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

opt_nt_053
	:	/* Nothing */
	|	sign
	;

signed_integer
	:	opt_nt_053 unsigned_integer
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

date_string
	:	quote unquoted_date_string quote
	;

time_string
	:	quote unquoted_time_string quote
	;

timestamp_string
	:	quote unquoted_timestamp_string quote
	;

time_zone_interval
	:	sign hours_value colon minutes_value
	;

date_value
	:	years_value minus_sign months_value minus_sign days_value
	;

time_value
	:	hours_value colon minutes_value colon seconds_value
	;

opt_nt_054
	:	/* Nothing */
	|	sign
	;

interval_literal
	:	INTERVAL opt_nt_054 interval_string interval_qualifier
	;

interval_string
	:	quote unquoted_interval_string quote
	;

unquoted_date_string
	:	date_value
	;

opt_nt_055
	:	/* Nothing */
	|	time_zone_interval ']'
	;

unquoted_time_string
	:	time_value opt_nt_055
	;

unquoted_timestamp_string
	:	unquoted_date_string space unquoted_time_string
	;

opt_nt_056
	:	/* Nothing */
	|	sign
	;

seq_nt_057
	:	year_month_literal
	|	day_time_literal '}'
	;

unquoted_interval_string
	:	opt_nt_056 seq_nt_057
	;

opt_nt_058
	:	/* Nothing */
	|	years_value minus_sign
	;

year_month_literal
	:	years_value
	|	opt_nt_058 months_value
	;

day_time_literal
	:	day_time_interval
	|	time_interval
	;

opt_nt_061
	:	/* Nothing */
	|	colon seconds_value
	;

opt_nt_060
	:	/* Nothing */
	|	colon minutes_value opt_nt_061
	;

opt_nt_059
	:	/* Nothing */
	|	space hours_value opt_nt_060 ']'
	;

day_time_interval
	:	days_value opt_nt_059
	;

opt_nt_063
	:	/* Nothing */
	|	colon seconds_value
	;

opt_nt_062
	:	/* Nothing */
	|	colon minutes_value opt_nt_063
	;

opt_nt_064
	:	/* Nothing */
	|	colon seconds_value
	;

time_interval
	:	hours_value opt_nt_062
	|	minutes_value opt_nt_064
	|	seconds_value
	;

years_value
	:	datetime_value
	;

months_value
	:	datetime_value
	;

days_value
	:	datetime_value
	;

hours_value
	:	datetime_value
	;

minutes_value
	:	datetime_value
	;

opt_nt_066
	:	/* Nothing */
	|	seconds_fraction
	;

opt_nt_065
	:	/* Nothing */
	|	period opt_nt_066 ']'
	;

seconds_value
	:	seconds_integer_value opt_nt_065
	;

seconds_integer_value
	:	unsigned_integer
	;

seconds_fraction
	:	unsigned_integer
	;

datetime_value
	:	unsigned_integer
	;

boolean_literal
	:	TRUE
	|	FALSE
	|	UNKNOWN
	;

identifier
	:	actual_identifier
	;

actual_identifier
	:	regular_identifier
	|	delimited_identifier
	;

seq_nt_068
	:	underscore
	|	sql_language_identifier_part
	;

lst_nt_069
	:	seq_nt_068
	|	lst_nt_069 seq_nt_068
	;

opt_nt_067
	:	/* Nothing */
	|	lst_nt_069 ']'
	;

sql_language_identifier
	:	sql_language_identifier_start opt_nt_067
	;

sql_language_identifier_start
	:	simple_latin_letter
	;

sql_language_identifier_part
	:	simple_latin_letter
	|	digit
	;

authorization_identifier
	:	role_name
	|	user_identifier
	;

table_name
	:	local_or_schema_qualified_name
	;

domain_name
	:	schema_qualified_name
	;

opt_nt_070
	:	/* Nothing */
	|	catalog_name period
	;

schema_name
	:	opt_nt_070 unqualified_schema_name
	;

catalog_name
	:	identifier
	;

opt_nt_071
	:	/* Nothing */
	|	schema_name period
	;

schema_qualified_name
	:	opt_nt_071 qualified_identifier
	;

opt_nt_072
	:	/* Nothing */
	|	local_or_schema_qualifier period
	;

local_or_schema_qualified_name
	:	opt_nt_072 qualified_identifier
	;

local_or_schema_qualifier
	:	schema_name
	|	MODULE
	;

qualified_identifier
	:	identifier
	;

column_name
	:	identifier
	;

correlation_name
	:	identifier
	;

query_name
	:	identifier
	;

sql_client_module_name
	:	identifier
	;

procedure_name
	:	identifier
	;

schema_qualified_routine_name
	:	schema_qualified_name
	;

method_name
	:	identifier
	;

specific_name
	:	schema_qualified_name
	;

cursor_name
	:	local_qualified_name
	;

opt_nt_073
	:	/* Nothing */
	|	local_qualifier period
	;

local_qualified_name
	:	opt_nt_073 qualified_identifier
	;

local_qualifier
	:	MODULE
	;

host_parameter_name
	:	colon identifier
	;

sql_parameter_name
	:	identifier
	;

constraint_name
	:	schema_qualified_name
	;

external_routine_name
	:	identifier
	|	character_string_literal
	;

trigger_name
	:	schema_qualified_name
	;

collation_name
	:	schema_qualified_name
	;

opt_nt_074
	:	/* Nothing */
	|	schema_name period
	;

character_set_name
	:	opt_nt_074 sql_language_identifier
	;

transliteration_name
	:	schema_qualified_name
	;

transcoding_name
	:	schema_qualified_name
	;

user_defined_type_name
	:	schema_qualified_type_name
	;

schema_resolved_user_defined_type_name
	:	user_defined_type_name
	;

opt_nt_075
	:	/* Nothing */
	|	schema_name period
	;

schema_qualified_type_name
	:	opt_nt_075 qualified_identifier
	;

attribute_name
	:	identifier
	;

field_name
	:	identifier
	;

savepoint_name
	:	identifier
	;

sequence_generator_name
	:	schema_qualified_name
	;

role_name
	:	identifier
	;

user_identifier
	:	identifier
	;

connection_name
	:	simple_value_specification
	;

sql_server_name
	:	simple_value_specification
	;

connection_user_name
	:	simple_value_specification
	;

sql_statement_name
	:	statement_name
	|	extended_statement_name
	;

statement_name
	:	identifier
	;

opt_nt_076
	:	/* Nothing */
	|	scope_option
	;

extended_statement_name
	:	opt_nt_076 simple_value_specification
	;

dynamic_cursor_name
	:	cursor_name
	|	extended_cursor_name
	;

opt_nt_077
	:	/* Nothing */
	|	scope_option
	;

extended_cursor_name
	:	opt_nt_077 simple_value_specification
	;

opt_nt_078
	:	/* Nothing */
	|	scope_option
	;

descriptor_name
	:	opt_nt_078 simple_value_specification
	;

scope_option
	:	GLOBAL
	|	LOCAL
	;

window_name
	:	identifier
	;

data_type
	:	predefined_type
	|	row_type
	|	path_resolved_user_defined_type_name
	|	reference_type
	|	collection_type
	;

opt_nt_079
	:	/* Nothing */
	|	CHARACTER SET character_set_specification
	;

opt_nt_080
	:	/* Nothing */
	|	collate_clause
	;

opt_nt_081
	:	/* Nothing */
	|	collate_clause
	;

predefined_type
	:	character_string_type opt_nt_079 opt_nt_080
	|	national_character_string_type opt_nt_081
	|	binary_large_object_string_type
	|	numeric_type
	|	boolean_type
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
	|	left_paren large_object_length right_paren
	;

opt_nt_085
	:	/* Nothing */
	|	left_paren large_object_length right_paren
	;

opt_nt_086
	:	/* Nothing */
	|	left_paren large_object_length right_paren ']'
	;

character_string_type
	:	CHARACTER opt_nt_082
	|	CHAR opt_nt_083
	|	CHARACTER VARYING left_paren length right_paren
	|	CHAR VARYING left_paren length right_paren
	|	VARCHAR left_paren length right_paren
	|	CHARACTER LARGE OBJECT opt_nt_084
	|	CHAR LARGE OBJECT opt_nt_085
	|	CLOB opt_nt_086
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
	|	left_paren large_object_length right_paren
	;

opt_nt_091
	:	/* Nothing */
	|	left_paren large_object_length right_paren
	;

opt_nt_092
	:	/* Nothing */
	|	left_paren large_object_length right_paren ']'
	;

national_character_string_type
	:	NATIONAL CHARACTER opt_nt_087
	|	NATIONAL CHAR opt_nt_088
	|	NCHAR opt_nt_089
	|	NATIONAL CHARACTER VARYING left_paren length right_paren
	|	NATIONAL CHAR VARYING left_paren length right_paren
	|	NCHAR VARYING left_paren length right_paren
	|	NATIONAL CHARACTER LARGE OBJECT opt_nt_090
	|	NCHAR LARGE OBJECT opt_nt_091
	|	NCLOB opt_nt_092
	;

opt_nt_093
	:	/* Nothing */
	|	left_paren large_object_length right_paren
	;

opt_nt_094
	:	/* Nothing */
	|	left_paren large_object_length right_paren ']'
	;

binary_large_object_string_type
	:	BINARY LARGE OBJECT opt_nt_093
	|	BLOB opt_nt_094
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
	|	SMALLINT
	|	INTEGER
	|	INT
	|	BIGINT
	;

opt_nt_101
	:	/* Nothing */
	|	left_paren precision right_paren
	;

approximate_numeric_type
	:	FLOAT opt_nt_101
	|	REAL
	|	DOUBLE PRECISION
	;

length
	:	unsigned_integer
	;

opt_nt_102
	:	/* Nothing */
	|	multiplier
	;

opt_nt_103
	:	/* Nothing */
	|	char_length_units
	;

opt_nt_104
	:	/* Nothing */
	|	char_length_units ']'
	;

large_object_length
	:	unsigned_integer opt_nt_102 opt_nt_103
	|	large_object_length_token opt_nt_104
	;

char_length_units
	:	CHARACTERS
	|	CODE_UNITS
	|	OCTETS
	;

precision
	:	unsigned_integer
	;

scale
	:	unsigned_integer
	;

boolean_type
	:	BOOLEAN
	;

opt_nt_105
	:	/* Nothing */
	|	left_paren time_precision right_paren
	;

opt_nt_106
	:	/* Nothing */
	|	with_or_without_time_zone
	;

opt_nt_107
	:	/* Nothing */
	|	left_paren timestamp_precision right_paren
	;

opt_nt_108
	:	/* Nothing */
	|	with_or_without_time_zone ']'
	;

datetime_type
	:	DATE
	|	TIME opt_nt_105 opt_nt_106
	|	TIMESTAMP opt_nt_107 opt_nt_108
	;

with_or_without_time_zone
	:	WITH TIME ZONE
	|	WITHOUT TIME ZONE
	;

time_precision
	:	time_fractional_seconds_precision
	;

timestamp_precision
	:	time_fractional_seconds_precision
	;

time_fractional_seconds_precision
	:	unsigned_integer
	;

interval_type
	:	INTERVAL interval_qualifier
	;

row_type
	:	ROW row_type_body
	;

seq_nt_110
	:	comma field_definition
	;

lst_nt_111
	:	seq_nt_110
	|	lst_nt_111 seq_nt_110
	;

opt_nt_109
	:	/* Nothing */
	|	lst_nt_111
	;

row_type_body
	:	left_paren field_definition opt_nt_109 right_paren
	;

opt_nt_112
	:	/* Nothing */
	|	scope_clause ']'
	;

reference_type
	:	REF left_paren referenced_type right_paren opt_nt_112
	;

scope_clause
	:	SCOPE table_name
	;

referenced_type
	:	path_resolved_user_defined_type_name
	;

path_resolved_user_defined_type_name
	:	user_defined_type_name
	;

path_resolved_user_defined_type_name
	:	user_defined_type_name
	;

collection_type
	:	array_type
	|	multiset_type
	;

opt_nt_113
	:	/* Nothing */
	|	left_bracket_or_trigraph unsigned_integer right_bracket_or_trigraph ']'
	;

array_type
	:	data_type ARRAY opt_nt_113
	;

multiset_type
	:	data_type MULTISET
	;

opt_nt_114
	:	/* Nothing */
	|	reference_scope_check ']'
	;

field_definition
	:	field_name data_type opt_nt_114
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
	|	window_function
	|	scalar_subquery
	|	case_expression
	|	cast_specification
	|	field_reference
	|	subtype_treatment
	|	method_invocation
	|	static_method_invocation
	|	new_specification
	|	attribute_or_method_reference
	|	reference_resolution
	|	collection_value_constructor
	|	array_element_reference
	|	multiset_element_reference
	|	routine_invocation
	|	next_value_expression
	;

value_specification
	:	literal
	|	general_value_specification
	;

unsigned_value_specification
	:	unsigned_literal
	|	general_value_specification
	;

general_value_specification
	:	host_parameter_specification
	|	sql_parameter_reference
	|	dynamic_parameter_specification
	|	embedded_variable_specification
	|	current_collation_specification
	|	CURRENT_DEFAULT_TRANSFORM_GROUP
	|	CURRENT_PATH
	|	CURRENT_ROLE
	|	CURRENT_TRANSFORM_GROUP_FOR_TYPE path_resolved_user_defined_type_name
	|	CURRENT_USER
	|	SESSION_USER
	|	SYSTEM_USER
	|	USER
	|	VALUE
	;

simple_value_specification
	:	literal
	|	host_parameter_name
	|	sql_parameter_reference
	|	embedded_variable_name
	;

target_specification
	:	host_parameter_specification
	|	sql_parameter_reference
	|	column_reference
	|	target_array_element_specification
	|	dynamic_parameter_specification
	|	embedded_variable_specification
	;

simple_target_specification
	:	host_parameter_specification
	|	sql_parameter_reference
	|	column_reference
	|	embedded_variable_name
	;

opt_nt_115
	:	/* Nothing */
	|	indicator_parameter ']'
	;

host_parameter_specification
	:	host_parameter_name opt_nt_115
	;

dynamic_parameter_specification
	:	question_mark
	;

opt_nt_116
	:	/* Nothing */
	|	indicator_variable ']'
	;

embedded_variable_specification
	:	embedded_variable_name opt_nt_116
	;

opt_nt_117
	:	/* Nothing */
	|	INDICATOR
	;

indicator_variable
	:	opt_nt_117 embedded_variable_name
	;

opt_nt_118
	:	/* Nothing */
	|	INDICATOR
	;

indicator_parameter
	:	opt_nt_118 host_parameter_name
	;

target_array_element_specification
	:	target_array_reference left_bracket_or_trigraph simple_value_specification right_bracket_or_trigraph
	;

target_array_reference
	:	sql_parameter_reference
	|	column_reference
	;

current_collation_specification
	:	CURRENT_COLLATION left_paren string_value_expression right_paren
	;

contextually_typed_value_specification
	:	implicitly_typed_value_specification
	|	default_specification
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
	|	MULTISET left_bracket_or_trigraph right_bracket_or_trigraph
	;

default_specification
	:	DEFAULT
	;

seq_nt_120
	:	period identifier
	;

lst_nt_121
	:	seq_nt_120
	|	lst_nt_121 seq_nt_120
	;

opt_nt_119
	:	/* Nothing */
	|	lst_nt_121 ']'
	;

identifier_chain
	:	identifier opt_nt_119
	;

basic_identifier_chain
	:	identifier_chain
	;

column_reference
	:	basic_identifier_chain
	|	MODULE period qualified_identifier period column_name
	;

sql_parameter_reference
	:	basic_identifier_chain
	;

set_function_specification
	:	aggregate_function
	|	grouping_operation
	;

seq_nt_123
	:	comma column_reference
	;

lst_nt_124
	:	seq_nt_123
	|	lst_nt_124 seq_nt_123
	;

opt_nt_122
	:	/* Nothing */
	|	lst_nt_124
	;

grouping_operation
	:	GROUPING left_paren column_reference opt_nt_122 right_paren
	;

window_function
	:	window_function_type OVER window_name_or_specification
	;

window_function_type
	:	rank_function_type left_paren right_paren
	|	ROW_NUMBER left_paren right_paren
	|	aggregate_function
	;

rank_function_type
	:	RANK
	|	DENSE_RANK
	|	PERCENT_RANK
	|	CUME_DIST
	;

window_name_or_specification
	:	window_name
	|	in_line_window_specification
	;

in_line_window_specification
	:	window_specification
	;

case_expression
	:	case_abbreviation
	|	case_specification
	;

seq_nt_125
	:	comma value_expression
	;

lst_nt_126
	:	seq_nt_125
	|	lst_nt_126 seq_nt_125
	;

case_abbreviation
	:	NULLIF left_paren value_expression comma value_expression right_paren
	|	COALESCE left_paren value_expression lst_nt_126 right_paren
	;

case_specification
	:	simple_case
	|	searched_case
	;

lst_nt_127
	:	simple_when_clause
	|	lst_nt_127 simple_when_clause
	;

opt_nt_128
	:	/* Nothing */
	|	else_clause
	;

simple_case
	:	CASE case_operand lst_nt_127 opt_nt_128 END
	;

lst_nt_129
	:	searched_when_clause
	|	lst_nt_129 searched_when_clause
	;

opt_nt_130
	:	/* Nothing */
	|	else_clause
	;

searched_case
	:	CASE lst_nt_129 opt_nt_130 END
	;

simple_when_clause
	:	WHEN when_operand THEN result
	;

searched_when_clause
	:	WHEN search_condition THEN result
	;

else_clause
	:	ELSE result
	;

case_operand
	:	row_value_predicand
	|	overlaps_predicate_part
	;

when_operand
	:	row_value_predicand
	|	comparison_predicate_part_2
	|	between_predicate_part_2
	|	in_predicate_part_2
	|	character_like_predicate_part_2
	|	octet_like_predicate_part_2
	|	similar_predicate_part_2
	|	null_predicate_part_2
	|	quantified_comparison_predicate_part_2
	|	match_predicate_part_2
	|	overlaps_predicate_part_2
	|	distinct_predicate_part_2
	|	member_predicate_part_2
	|	submultiset_predicate_part_2
	|	set_predicate_part_2
	|	type_predicate_part_2
	;

result
	:	result_expression
	|	NULL
	;

result_expression
	:	value_expression
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

next_value_expression
	:	NEXT VALUE FOR sequence_generator_name
	;

field_reference
	:	value_expression_primary period field_name
	;

subtype_treatment
	:	TREAT left_paren subtype_operand AS target_subtype right_paren
	;

subtype_operand
	:	value_expression
	;

target_subtype
	:	path_resolved_user_defined_type_name
	|	reference_type
	;

method_invocation
	:	direct_invocation
	|	generalized_invocation
	;

opt_nt_131
	:	/* Nothing */
	|	sql_argument_list ']'
	;

direct_invocation
	:	value_expression_primary period method_name opt_nt_131
	;

opt_nt_132
	:	/* Nothing */
	|	sql_argument_list ']'
	;

generalized_invocation
	:	left_paren value_expression_primary AS data_type right_paren period method_name opt_nt_132
	;

method_selection
	:	routine_invocation
	;

constructor_method_selection
	:	routine_invocation
	;

opt_nt_133
	:	/* Nothing */
	|	sql_argument_list ']'
	;

static_method_invocation
	:	path_resolved_user_defined_type_name double_colon method_name opt_nt_133
	;

static_method_selection
	:	routine_invocation
	;

new_specification
	:	NEW routine_invocation
	;

new_invocation
	:	method_invocation
	|	routine_invocation
	;

opt_nt_134
	:	/* Nothing */
	|	sql_argument_list ']'
	;

attribute_or_method_reference
	:	value_expression_primary dereference_operator qualified_identifier opt_nt_134
	;

dereference_operator
	:	right_arrow
	;

dereference_operation
	:	reference_value_expression dereference_operator attribute_name
	;

method_reference
	:	value_expression_primary dereference_operator method_name sql_argument_list
	;

reference_resolution
	:	DEREF left_paren reference_value_expression right_paren
	;

array_element_reference
	:	array_value_expression left_bracket_or_trigraph numeric_value_expression right_bracket_or_trigraph
	;

multiset_element_reference
	:	ELEMENT left_paren multset_value_expression right_paren
	;

value_expression
	:	common_value_expression
	|	boolean_value_expression
	|	row_value_expression
	;

common_value_expression
	:	numeric_value_expression
	|	string_value_expression
	|	datetime_value_expression
	|	interval_value_expression
	|	user_defined_type_value_expression
	|	reference_value_expression
	|	collection_value_expression
	;

user_defined_type_value_expression
	:	value_expression_primary
	;

reference_value_expression
	:	value_expression_primary
	;

collection_value_expression
	:	array_value_expression
	|	multiset_value_expression
	;

collection_value_constructor
	:	array_value_constructor
	|	multiset_value_constructor
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

opt_nt_135
	:	/* Nothing */
	|	sign
	;

factor
	:	opt_nt_135 numeric_primary
	;

numeric_primary
	:	value_expression_primary
	|	numeric_value_function
	;

numeric_value_function
	:	position_expression
	|	extract_expression
	|	length_expression
	|	cardinality_expression
	|	absolute_value_expression
	|	modulus_expression
	|	natural_logarithm
	|	exponential_function
	|	power_function
	|	square_root
	|	floor_function
	|	ceiling_function
	|	width_bucket_function
	;

position_expression
	:	string_position_expression
	|	blob_position_expression
	;

opt_nt_136
	:	/* Nothing */
	|	USING char_length_units
	;

string_position_expression
	:	POSITION left_paren string_value_expression IN string_value_expression opt_nt_136 right_paren
	;

blob_position_expression
	:	POSITION left_paren blob_value_expression IN blob_value_expression right_paren
	;

length_expression
	:	char_length_expression
	|	octet_length_expression
	;

seq_nt_137
	:	CHAR_LENGTH
	|	CHARACTER_LENGTH
	;

opt_nt_138
	:	/* Nothing */
	|	USING char_length_units
	;

char_length_expression
	:	seq_nt_137 left_paren string_value_expression opt_nt_138 right_paren
	;

octet_length_expression
	:	OCTET_LENGTH left_paren string_value_expression right_paren
	;

extract_expression
	:	EXTRACT left_paren extract_field FROM extract_source right_paren
	;

extract_field
	:	primary_datetime_field
	|	time_zone_field
	;

time_zone_field
	:	TIMEZONE_HOUR
	|	TIMEZONE_MINUTE
	;

extract_source
	:	datetime_value_expression
	|	interval_value_expression
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

natural_logarithm
	:	LN left_paren numeric_value_expression right_paren
	;

exponential_function
	:	EXP left_paren numeric_value_expression right_paren
	;

power_function
	:	POWER left_paren numeric_value_expression_base comma numeric_value_expression_exponent right_paren
	;

numeric_value_expression_base
	:	numeric_value_expression
	;

numeric_value_expression_exponent
	:	numeric_value_expression
	;

square_root
	:	SQRT left_paren numeric_value_expression right_paren
	;

floor_function
	:	FLOOR left_paren numeric_value_expression right_paren
	;

seq_nt_139
	:	CEIL
	|	CEILING
	;

ceiling_function
	:	seq_nt_139 left_paren numeric_value_expression right_paren
	;

width_bucket_function
	:	WIDTH_BUCKET left_paren width_bucket_operand comma width_bucket_bound_1 comma width_bucket_bound_2 comma width_bucket_count right_paren
	;

width_bucket_operand
	:	numeric_value_expression
	;

width_bucket_bound_1
	:	numeric_value_expression
	;

width_bucket_bound_2
	:	numeric_value_expression
	;

width_bucket_count
	:	numeric_value_expression
	;

string_value_expression
	:	character_value_expression
	|	blob_value_expression
	;

character_value_expression
	:	concatenation
	|	character_factor
	;

concatenation
	:	character_value_expression concatenation_operator character_factor
	;

opt_nt_140
	:	/* Nothing */
	|	collate_clause ']'
	;

character_factor
	:	character_primary opt_nt_140
	;

character_primary
	:	value_expression_primary
	|	string_value_function
	;

blob_value_expression
	:	blob_concatenation
	|	blob_factor
	;

blob_factor
	:	blob_primary
	;

blob_primary
	:	value_expression_primary
	|	string_value_function
	;

blob_concatenation
	:	blob_value_expression concatenation_operator blob_factor
	;

string_value_function
	:	character_value_function
	|	blob_value_function
	;

character_value_function
	:	character_substring_function
	|	regular_expression_substring_function
	|	fold
	|	transcoding
	|	character_transliteration
	|	trim_function
	|	character_overlay_function
	|	normalize_function
	|	specific_type_method
	;

opt_nt_141
	:	/* Nothing */
	|	FOR string_length
	;

opt_nt_142
	:	/* Nothing */
	|	USING char_length_units
	;

character_substring_function
	:	SUBSTRING left_paren character_value_expression FROM start_position opt_nt_141 opt_nt_142 right_paren
	;

regular_expression_substring_function
	:	SUBSTRING left_paren character_value_expression SIMILAR character_value_expression ESCAPE escape_character right_paren
	;

seq_nt_143
	:	UPPER
	|	LOWER
	;

fold
	:	seq_nt_143 left_paren character_value_expression right_paren
	;

transcoding
	:	CONVERT left_paren character_value_expression USING transcoding_name right_paren
	;

character_transliteration
	:	TRANSLATE left_paren character_value_expression USING transliteration_name right_paren
	;

trim_function
	:	TRIM left_paren trim_operands right_paren
	;

opt_nt_145
	:	/* Nothing */
	|	trim_specification
	;

opt_nt_146
	:	/* Nothing */
	|	trim_character
	;

opt_nt_144
	:	/* Nothing */
	|	opt_nt_145 opt_nt_146 FROM
	;

trim_operands
	:	opt_nt_144 trim_source
	;

trim_source
	:	character_value_expression
	;

trim_specification
	:	LEADING
	|	TRAILING
	|	BOTH
	;

trim_character
	:	character_value_expression
	;

opt_nt_147
	:	/* Nothing */
	|	FOR string_length
	;

opt_nt_148
	:	/* Nothing */
	|	USING char_length_units
	;

character_overlay_function
	:	OVERLAY left_paren character_value_expression PLACING character_value_expression FROM start_position opt_nt_147 opt_nt_148 right_paren
	;

normalize_function
	:	NORMALIZE left_paren character_value_expression right_paren
	;

specific_type_method
	:	user_defined_type_value_expression period SPECIFICTYPE
	;

blob_value_function
	:	blob_substring_function
	|	blob_trim_function
	|	blob_overlay_function
	;

opt_nt_149
	:	/* Nothing */
	|	FOR string_length
	;

blob_substring_function
	:	SUBSTRING left_paren blob_value_expression FROM start_position opt_nt_149 right_paren
	;

blob_trim_function
	:	TRIM left_paren blob_trim_operands right_paren
	;

opt_nt_151
	:	/* Nothing */
	|	trim_specification
	;

opt_nt_152
	:	/* Nothing */
	|	trim_octet
	;

opt_nt_150
	:	/* Nothing */
	|	opt_nt_151 opt_nt_152 FROM
	;

blob_trim_operands
	:	opt_nt_150 blob_trim_source
	;

blob_trim_source
	:	blob_value_expression
	;

trim_octet
	:	blob_value_expression
	;

opt_nt_153
	:	/* Nothing */
	|	FOR string_length
	;

blob_overlay_function
	:	OVERLAY left_paren blob_value_expression PLACING blob_value_expression FROM start_position opt_nt_153 right_paren
	;

start_position
	:	numeric_value_expression
	;

string_length
	:	numeric_value_expression
	;

datetime_value_expression
	:	datetime_term
	|	interval_value_expression plus_sign datetime_term
	|	datetime_value_expression plus_sign interval_term
	|	datetime_value_expression minus_sign interval_term
	;

datetime_term
	:	datetime_factor
	;

opt_nt_154
	:	/* Nothing */
	|	time_zone ']'
	;

datetime_factor
	:	datetime_primary opt_nt_154
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

opt_nt_155
	:	/* Nothing */
	|	left_paren time_precision right_paren ']'
	;

current_time_value_function
	:	CURRENT_TIME opt_nt_155
	;

opt_nt_156
	:	/* Nothing */
	|	left_paren time_precision right_paren ']'
	;

current_local_time_value_function
	:	LOCALTIME opt_nt_156
	;

opt_nt_157
	:	/* Nothing */
	|	left_paren timestamp_precision right_paren ']'
	;

current_timestamp_value_function
	:	CURRENT_TIMESTAMP opt_nt_157
	;

opt_nt_158
	:	/* Nothing */
	|	left_paren timestamp_precision right_paren ']'
	;

current_local_timestamp_value_function
	:	LOCALTIMESTAMP opt_nt_158
	;

interval_value_expression
	:	interval_term
	|	interval_value_expression_1 plus_sign interval_term_1
	|	interval_value_expression_1 minus_sign interval_term_1
	|	left_paren datetime_value_expression minus_sign datetime_term right_paren interval_qualifier
	;

interval_term
	:	interval_factor
	|	interval_term_2 asterisk factor
	|	interval_term_2 solidus factor
	|	term asterisk interval_factor
	;

opt_nt_159
	:	/* Nothing */
	|	sign
	;

interval_factor
	:	opt_nt_159 interval_primary
	;

opt_nt_160
	:	/* Nothing */
	|	interval_qualifier
	;

interval_primary
	:	value_expression_primary opt_nt_160
	|	interval_value_function
	;

interval_value_expression_1
	:	interval_value_expression
	;

interval_term_1
	:	interval_term
	;

interval_term_2
	:	interval_term
	;

interval_value_function
	:	interval_absolute_value_function
	;

interval_absolute_value_function
	:	ABS left_paren interval_value_expression right_paren
	;

boolean_value_expression
	:	boolean_term
	|	boolean_value_expression OR boolean_term
	;

boolean_term
	:	boolean_factor
	|	boolean_term AND boolean_factor
	;

opt_nt_161
	:	/* Nothing */
	|	NOT
	;

boolean_factor
	:	opt_nt_161 boolean_test
	;

opt_nt_163
	:	/* Nothing */
	|	NOT
	;

opt_nt_162
	:	/* Nothing */
	|	IS opt_nt_163 truth_value ']'
	;

boolean_test
	:	boolean_primary opt_nt_162
	;

truth_value
	:	TRUE
	|	FALSE
	|	UNKNOWN
	;

boolean_primary
	:	predicate
	|	boolean_predicand
	;

boolean_predicand
	:	parenthesized_boolean_value_expression
	|	nonparenthesized_value_expression_primary
	;

parenthesized_boolean_value_expression
	:	left_paren boolean_value_expression right_paren
	;

array_value_expression
	:	array_concatenation
	|	array_factor
	;

array_concatenation
	:	array_value_expression_1 concatenation_operator array_factor
	;

array_value_expression_1
	:	array_value_expression
	;

array_factor
	:	value_expression_primary
	;

array_value_constructor
	:	array_value_constructor_by_enumeration
	|	array_value_constructor_by_query
	;

array_value_constructor_by_enumeration
	:	ARRAY left_bracket_or_trigraph array_element_list right_bracket_or_trigraph
	;

seq_nt_165
	:	comma array_element
	;

lst_nt_166
	:	seq_nt_165
	|	lst_nt_166 seq_nt_165
	;

opt_nt_164
	:	/* Nothing */
	|	lst_nt_166 ']'
	;

array_element_list
	:	array_element opt_nt_164
	;

array_element
	:	value_expression
	;

opt_nt_167
	:	/* Nothing */
	|	order_by_clause
	;

array_value_constructor_by_query
	:	ARRAY left_paren query_expression opt_nt_167 right_paren
	;

opt_nt_168
	:	/* Nothing */
	|	ALL
	|	DISTINCT
	;

opt_nt_169
	:	/* Nothing */
	|	ALL
	|	DISTINCT
	;

multiset_value_expression
	:	multiset_term
	|	multiset_value_expression MULTISET UNION opt_nt_168 multiset_term
	|	multiset_value_expression MULTISET EXCEPT opt_nt_169 multiset_term
	;

opt_nt_170
	:	/* Nothing */
	|	ALL
	|	DISTINCT
	;

multiset_term
	:	multiset_primary
	|	multiset_term MULTISET INTERSECT opt_nt_170 multiset_primary
	;

multiset_primary
	:	multiset_value_function
	|	value_expression_primary
	;

multiset_value_function
	:	multiset_set_function
	;

multiset_set_function
	:	SET left_paren multiset_value_expression right_paren
	;

multiset_value_constructor
	:	multiset_value_constructor_by_enumeration
	|	multiset_value_constructor_by_query
	|	table_value_constructor_by_query
	;

multiset_value_constructor_by_enumeration
	:	MULTISET left_bracket_or_trigraph multiset_element_list right_bracket_or_trigraph
	;

seq_nt_172
	:	comma multiset_element
	;

opt_nt_171
	:	/* Nothing */
	|	seq_nt_172 ']'
	;

multiset_element_list
	:	multiset_element opt_nt_171
	;

multiset_element
	:	value_expression
	;

multiset_value_constructor_by_query
	:	MULTISET left_paren query_expression right_paren
	;

table_value_constructor_by_query
	:	TABLE left_paren query_expression right_paren
	;

row_value_constructor
	:	common_value_expression
	|	boolean_value_expression
	|	explicit_row_value_constructor
	;

explicit_row_value_constructor
	:	left_paren row_value_constructor_element comma row_value_constructor_element_list right_paren
	|	ROW left_paren row_value_constructor_element_list right_paren
	|	row_subquery
	;

seq_nt_174
	:	comma row_value_constructor_element
	;

lst_nt_175
	:	seq_nt_174
	|	lst_nt_175 seq_nt_174
	;

opt_nt_173
	:	/* Nothing */
	|	lst_nt_175 ']'
	;

row_value_constructor_element_list
	:	row_value_constructor_element opt_nt_173
	;

row_value_constructor_element
	:	value_expression
	;

contextually_typed_row_value_constructor
	:	common_value_expression
	|	boolean_value_expression
	|	contextually_typed_value_specification
	|	left_paren contextually_typed_row_value_constructor_element comma contextually_typed_row_value_constructor_element_list right_paren
	|	ROW left_paren contextually_typed_row_value_constructor_element_list right_paren
	;

seq_nt_177
	:	comma contextually_typed_row_value_constructor_element
	;

lst_nt_178
	:	seq_nt_177
	|	lst_nt_178 seq_nt_177
	;

opt_nt_176
	:	/* Nothing */
	|	lst_nt_178 ']'
	;

contextually_typed_row_value_constructor_element_list
	:	contextually_typed_row_value_constructor_element opt_nt_176
	;

contextually_typed_row_value_constructor_element
	:	value_expression
	|	contextually_typed_value_specification
	;

row_value_constructor_predicand
	:	common_value_expression
	|	boolean_predicand
	|	explicit_row_value_constructor
	;

row_value_expression
	:	row_value_special_case
	|	explicit_row_value_constructor
	;

table_row_value_expression
	:	row_value_special_case
	|	row_value_constructor
	;

contextually_typed_row_value_expression
	:	row_value_special_case
	|	contextually_typed_row_value_constructor
	;

row_value_predicand
	:	row_value_special_case
	|	row_value_constructor_predicand
	;

row_value_special_case
	:	nonparenthesized_value_expression_primary
	;

table_value_constructor
	:	VALUES row_value_expression_list
	;

seq_nt_180
	:	comma table_row_value_expression
	;

lst_nt_181
	:	seq_nt_180
	|	lst_nt_181 seq_nt_180
	;

opt_nt_179
	:	/* Nothing */
	|	lst_nt_181 ']'
	;

row_value_expression_list
	:	table_row_value_expression opt_nt_179
	;

contextually_typed_table_value_constructor
	:	VALUES contextually_typed_row_value_expression_list
	;

seq_nt_183
	:	comma contextually_typed_row_value_expression
	;

lst_nt_184
	:	seq_nt_183
	|	lst_nt_184 seq_nt_183
	;

opt_nt_182
	:	/* Nothing */
	|	lst_nt_184 ']'
	;

contextually_typed_row_value_expression_list
	:	contextually_typed_row_value_expression opt_nt_182
	;

opt_nt_185
	:	/* Nothing */
	|	where_clause
	;

opt_nt_186
	:	/* Nothing */
	|	group_by_clause
	;

opt_nt_187
	:	/* Nothing */
	|	having_clause
	;

opt_nt_188
	:	/* Nothing */
	|	window_clause ']'
	;

table_expression
	:	from_clause opt_nt_185 opt_nt_186 opt_nt_187 opt_nt_188
	;

from_clause
	:	FROM table_reference_list
	;

seq_nt_190
	:	comma table_reference
	;

lst_nt_191
	:	seq_nt_190
	|	lst_nt_191 seq_nt_190
	;

opt_nt_189
	:	/* Nothing */
	|	lst_nt_191 ']'
	;

table_reference_list
	:	table_reference opt_nt_189
	;

opt_nt_192
	:	/* Nothing */
	|	sample_clause ']'
	;

table_reference
	:	table_primary_or_joined_table opt_nt_192
	;

table_primary_or_joined_table
	:	table_primary
	|	joined_table
	;

opt_nt_193
	:	/* Nothing */
	|	repeatable_clause ']'
	;

sample_clause
	:	TABLESAMPLE sample_method left_paren sample_percentage right_paren opt_nt_193
	;

sample_method
	:	BERNOULLI
	|	SYSTEM
	;

repeatable_clause
	:	REPEATABLE left_paren repeat_argument right_paren
	;

sample_percentage
	:	numeric_value_expression
	;

repeat_argument
	:	numeric_value_expression
	;

opt_nt_195
	:	/* Nothing */
	|	AS
	;

opt_nt_196
	:	/* Nothing */
	|	left_paren derived_column_list right_paren
	;

opt_nt_194
	:	/* Nothing */
	|	opt_nt_195 correlation_name opt_nt_196
	;

opt_nt_197
	:	/* Nothing */
	|	AS
	;

opt_nt_198
	:	/* Nothing */
	|	left_paren derived_column_list right_paren
	;

opt_nt_199
	:	/* Nothing */
	|	AS
	;

opt_nt_200
	:	/* Nothing */
	|	left_paren derived_column_list right_paren
	;

opt_nt_201
	:	/* Nothing */
	|	AS
	;

opt_nt_202
	:	/* Nothing */
	|	left_paren derived_column_list right_paren
	;

opt_nt_203
	:	/* Nothing */
	|	AS
	;

opt_nt_204
	:	/* Nothing */
	|	left_paren derived_column_list right_paren
	;

opt_nt_206
	:	/* Nothing */
	|	AS
	;

opt_nt_207
	:	/* Nothing */
	|	left_paren derived_column_list right_paren
	;

opt_nt_205
	:	/* Nothing */
	|	opt_nt_206 correlation_name opt_nt_207
	;

table_primary
	:	table_or_query_name opt_nt_194
	|	derived_table opt_nt_197 correlation_name opt_nt_198
	|	lateral_derived_table opt_nt_199 correlation_name opt_nt_200
	|	collection_derived_table opt_nt_201 correlation_name opt_nt_202
	|	table_function_derived_table opt_nt_203 correlation_name opt_nt_204
	|	only_spec opt_nt_205
	|	left_paren joined_table right_paren
	;

only_spec
	:	ONLY left_paren table_or_query_name right_paren
	;

lateral_derived_table
	:	LATERAL table_subquery
	;

opt_nt_208
	:	/* Nothing */
	|	WITH ORDINALITY ']'
	;

collection_derived_table
	:	UNNEST left_paren collection_value_expression right_paren opt_nt_208
	;

table_function_derived_table
	:	TABLE left_paren collection_value_expression right_paren
	;

derived_table
	:	table_subquery
	;

table_or_query_name
	:	table_name
	|	query_name
	;

derived_column_list
	:	column_name_list
	;

seq_nt_210
	:	comma column_name
	;

lst_nt_211
	:	seq_nt_210
	|	lst_nt_211 seq_nt_210
	;

opt_nt_209
	:	/* Nothing */
	|	lst_nt_211 ']'
	;

column_name_list
	:	column_name opt_nt_209
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

opt_nt_212
	:	/* Nothing */
	|	join_type
	;

qualified_join
	:	table_reference opt_nt_212 JOIN table_reference join_specification
	;

opt_nt_213
	:	/* Nothing */
	|	join_type
	;

natural_join
	:	table_reference NATURAL opt_nt_213 JOIN table_primary
	;

union_join
	:	table_reference UNION JOIN table_primary
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

opt_nt_214
	:	/* Nothing */
	|	OUTER ']'
	;

join_type
	:	INNER
	|	outer_join_type opt_nt_214
	;

outer_join_type
	:	LEFT
	|	RIGHT
	|	FULL
	;

join_column_list
	:	column_name_list
	;

where_clause
	:	WHERE search_condition
	;

opt_nt_215
	:	/* Nothing */
	|	set_quantifier
	;

group_by_clause
	:	GROUP BY opt_nt_215 grouping_element_list
	;

seq_nt_217
	:	comma grouping_element
	;

lst_nt_218
	:	seq_nt_217
	|	lst_nt_218 seq_nt_217
	;

opt_nt_216
	:	/* Nothing */
	|	lst_nt_218 ']'
	;

grouping_element_list
	:	grouping_element opt_nt_216
	;

grouping_element
	:	ordinary_grouping_set
	|	rollup_list
	|	cube_list
	|	grouping_sets_specification
	|	empty_grouping_set
	;

ordinary_grouping_set
	:	grouping_column_reference
	|	left_paren grouping_column_reference_list right_paren
	;

opt_nt_219
	:	/* Nothing */
	|	collate_clause ']'
	;

grouping_column_reference
	:	column_reference opt_nt_219
	;

seq_nt_221
	:	comma grouping_column_reference
	;

lst_nt_222
	:	seq_nt_221
	|	lst_nt_222 seq_nt_221
	;

opt_nt_220
	:	/* Nothing */
	|	lst_nt_222 ']'
	;

grouping_column_reference_list
	:	grouping_column_reference opt_nt_220
	;

rollup_list
	:	ROLLUP left_paren ordinary_grouping_set_list right_paren
	;

seq_nt_224
	:	comma ordinary_grouping_set
	;

lst_nt_225
	:	seq_nt_224
	|	lst_nt_225 seq_nt_224
	;

opt_nt_223
	:	/* Nothing */
	|	lst_nt_225 ']'
	;

ordinary_grouping_set_list
	:	ordinary_grouping_set opt_nt_223
	;

cube_list
	:	CUBE left_paren ordinary_grouping_set_list right_paren
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
	|	empty_grouping_set
	;

empty_grouping_set
	:	left_paren right_paren
	;

having_clause
	:	HAVING search_condition
	;

window_clause
	:	WINDOW window_definition_list
	;

seq_nt_230
	:	comma window_definition
	;

lst_nt_231
	:	seq_nt_230
	|	lst_nt_231 seq_nt_230
	;

opt_nt_229
	:	/* Nothing */
	|	lst_nt_231 ']'
	;

window_definition_list
	:	window_definition opt_nt_229
	;

window_definition
	:	new_window_name AS window_specification
	;

new_window_name
	:	window_name
	;

window_specification
	:	left_paren window_specification_details right_paren
	;

opt_nt_232
	:	/* Nothing */
	|	existing_window_name
	;

opt_nt_233
	:	/* Nothing */
	|	window_partition_clause
	;

opt_nt_234
	:	/* Nothing */
	|	window_order_clause
	;

opt_nt_235
	:	/* Nothing */
	|	window_frame_clause ']'
	;

window_specification_details
	:	opt_nt_232 opt_nt_233 opt_nt_234 opt_nt_235
	;

existing_window_name
	:	window_name
	;

window_partition_clause
	:	PARTITION BY window_partition_column_reference_list
	;

seq_nt_237
	:	comma window_partition_column_reference
	;

lst_nt_238
	:	seq_nt_237
	|	lst_nt_238 seq_nt_237
	;

opt_nt_236
	:	/* Nothing */
	|	lst_nt_238 ']'
	;

window_partition_column_reference_list
	:	window_partition_column_reference opt_nt_236
	;

opt_nt_239
	:	/* Nothing */
	|	collate_clause ']'
	;

window_partition_column_reference
	:	column_reference opt_nt_239
	;

window_order_clause
	:	ORDER BY sort_specification_list
	;

opt_nt_240
	:	/* Nothing */
	|	window_frame_exclusion ']'
	;

window_frame_clause
	:	window_frame_units window_frame_extent opt_nt_240
	;

window_frame_units
	:	ROWS
	|	RANGE
	;

window_frame_extent
	:	window_frame_start
	|	window_frame_between
	;

window_frame_start
	:	UNBOUNDED PRECEDING
	|	window_frame_preceding
	|	CURRENT ROW
	;

window_frame_preceding
	:	unsigned_value_specification PRECEDING
	;

window_frame_between
	:	BETWEEN window_frame_bound_1 AND window_frame_bound_2
	;

window_frame_bound_1
	:	window_frame_bound
	;

window_frame_bound_2
	:	window_frame_bound
	;

window_frame_bound
	:	window_frame_start
	|	UNBOUNDED FOLLOWING
	|	window_frame_following
	;

window_frame_following
	:	unsigned_value_specification FOLLOWING
	;

window_frame_exclusion
	:	EXCLUDE CURRENT ROW
	|	EXCLUDE GROUP
	|	EXCLUDE TIES
	|	EXCLUDE NO OTHERS
	;

opt_nt_241
	:	/* Nothing */
	|	set_quantifier
	;

query_specification
	:	SELECT opt_nt_241 select_list table_expression
	;

seq_nt_243
	:	comma select_sublist
	;

lst_nt_244
	:	seq_nt_243
	|	lst_nt_244 seq_nt_243
	;

opt_nt_242
	:	/* Nothing */
	|	lst_nt_244 ']'
	;

select_list
	:	asterisk
	|	select_sublist opt_nt_242
	;

select_sublist
	:	derived_column
	|	qualified_asterisk
	;

qualified_asterisk
	:	asterisked_identifier_chain period asterisk
	|	all_fields_reference
	;

seq_nt_246
	:	period asterisked_identifier
	;

lst_nt_247
	:	seq_nt_246
	|	lst_nt_247 seq_nt_246
	;

opt_nt_245
	:	/* Nothing */
	|	lst_nt_247 ']'
	;

asterisked_identifier_chain
	:	asterisked_identifier opt_nt_245
	;

asterisked_identifier
	:	identifier
	;

opt_nt_248
	:	/* Nothing */
	|	as_clause ']'
	;

derived_column
	:	value_expression opt_nt_248
	;

opt_nt_249
	:	/* Nothing */
	|	AS
	;

as_clause
	:	opt_nt_249 column_name
	;

opt_nt_250
	:	/* Nothing */
	|	AS left_paren all_fields_column_name_list right_paren ']'
	;

all_fields_reference
	:	value_expression_primary period asterisk opt_nt_250
	;

all_fields_column_name_list
	:	column_name_list
	;

opt_nt_251
	:	/* Nothing */
	|	with_clause
	;

query_expression
	:	opt_nt_251 query_expression_body
	;

opt_nt_252
	:	/* Nothing */
	|	RECURSIVE
	;

with_clause
	:	WITH opt_nt_252 with_list
	;

seq_nt_254
	:	comma with_list_element
	;

lst_nt_255
	:	seq_nt_254
	|	lst_nt_255 seq_nt_254
	;

opt_nt_253
	:	/* Nothing */
	|	lst_nt_255 ']'
	;

with_list
	:	with_list_element opt_nt_253
	;

opt_nt_256
	:	/* Nothing */
	|	left_paren with_column_list right_paren
	;

opt_nt_257
	:	/* Nothing */
	|	search_or_cycle_clause ']'
	;

with_list_element
	:	query_name opt_nt_256 AS left_paren query_expression right_paren opt_nt_257
	;

with_column_list
	:	column_name_list
	;

query_expression_body
	:	non_join_query_expression
	|	joined_table
	;

opt_nt_258
	:	/* Nothing */
	|	ALL
	|	DISTINCT
	;

opt_nt_259
	:	/* Nothing */
	|	corresponding_spec
	;

opt_nt_260
	:	/* Nothing */
	|	ALL
	|	DISTINCT
	;

opt_nt_261
	:	/* Nothing */
	|	corresponding_spec
	;

non_join_query_expression
	:	non_join_query_term
	|	query_expression_body UNION opt_nt_258 opt_nt_259 query_term
	|	query_expression_body EXCEPT opt_nt_260 opt_nt_261 query_term
	;

query_term
	:	non_join_query_term
	|	joined_table
	;

opt_nt_262
	:	/* Nothing */
	|	ALL
	|	DISTINCT
	;

opt_nt_263
	:	/* Nothing */
	|	corresponding_spec
	;

non_join_query_term
	:	non_join_query_primary
	|	query_term INTERSECT opt_nt_262 opt_nt_263 query_primary
	;

query_primary
	:	non_join_query_primary
	|	joined_table
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

explicit_table
	:	TABLE table_or_query_name
	;

opt_nt_264
	:	/* Nothing */
	|	BY left_paren corresponding_column_list right_paren ']'
	;

corresponding_spec
	:	CORRESPONDING opt_nt_264
	;

corresponding_column_list
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

sequence_column
	:	column_name
	;

cycle_clause
	:	CYCLE cycle_column_list SET cycle_mark_column TO cycle_mark_value DEFAULT non_cycle_mark_value USING path_column
	;

seq_nt_266
	:	comma cycle_column
	;

lst_nt_267
	:	seq_nt_266
	|	lst_nt_267 seq_nt_266
	;

opt_nt_265
	:	/* Nothing */
	|	lst_nt_267 ']'
	;

cycle_column_list
	:	cycle_column opt_nt_265
	;

cycle_column
	:	column_name
	;

cycle_mark_column
	:	column_name
	;

path_column
	:	column_name
	;

cycle_mark_value
	:	value_expression
	;

non_cycle_mark_value
	:	value_expression
	;

scalar_subquery
	:	subquery
	;

row_subquery
	:	subquery
	;

table_subquery
	:	subquery
	;

subquery
	:	left_paren query_expression right_paren
	;

predicate
	:	comparison_predicate
	|	between_predicate
	|	in_predicate
	|	like_predicate
	|	similar_predicate
	|	null_predicate
	|	quantified_comparison_predicate
	|	exists_predicate
	|	unique_predicate
	|	normalized_predicate
	|	match_predicate
	|	overlaps_predicate
	|	distinct_predicate
	|	member_predicate
	|	submultiset_predicate
	|	set_predicate
	|	type_predicate
	;

comparison_predicate
	:	row_value_predicand comparison_predicate_part_2
	;

comparison_predicate_part_2
	:	comp_op row_value_predicand
	;

comp_op
	:	equals_operator
	|	not_equals_operator
	|	less_than_operator
	|	greater_than_operator
	|	less_than_or_equals_operator
	|	greater_than_or_equals_operator
	;

between_predicate
	:	row_value_predicand between_predicate_part_2
	;

opt_nt_268
	:	/* Nothing */
	|	NOT
	;

opt_nt_269
	:	/* Nothing */
	|	ASYMMETRIC
	|	SYMMETRIC
	;

between_predicate_part_2
	:	opt_nt_268 BETWEEN opt_nt_269 row_value_predicand AND row_value_predicand
	;

in_predicate
	:	row_value_predicand in_predicate_part_2
	;

opt_nt_270
	:	/* Nothing */
	|	NOT
	;

in_predicate_part_2
	:	opt_nt_270 IN in_predicate_value
	;

in_predicate_value
	:	table_subquery
	|	left_paren in_value_list right_paren
	;

seq_nt_272
	:	comma row_value_expression
	;

lst_nt_273
	:	seq_nt_272
	|	lst_nt_273 seq_nt_272
	;

opt_nt_271
	:	/* Nothing */
	|	lst_nt_273 ']'
	;

in_value_list
	:	row_value_expression opt_nt_271
	;

like_predicate
	:	character_like_predicate
	|	octet_like_predicate
	;

character_like_predicate
	:	row_value_predicand character_like_predicate_part_2
	;

opt_nt_274
	:	/* Nothing */
	|	NOT
	;

opt_nt_275
	:	/* Nothing */
	|	ESCAPE escape_character ']'
	;

character_like_predicate_part_2
	:	opt_nt_274 LIKE character_pattern opt_nt_275
	;

character_pattern
	:	character_value_expression
	;

escape_character
	:	character_value_expression
	;

octet_like_predicate
	:	row_value_predicand octet_like_predicate_part_2
	;

opt_nt_276
	:	/* Nothing */
	|	NOT
	;

opt_nt_277
	:	/* Nothing */
	|	ESCAPE escape_octet ']'
	;

octet_like_predicate_part_2
	:	opt_nt_276 LIKE octet_pattern opt_nt_277
	;

octet_pattern
	:	blob_value_expression
	;

escape_octet
	:	blob_value_expression
	;

similar_predicate
	:	row_value_predicand similar_predicate_part_2
	;

opt_nt_278
	:	/* Nothing */
	|	NOT
	;

opt_nt_279
	:	/* Nothing */
	|	ESCAPE escape_character ']'
	;

similar_predicate_part_2
	:	opt_nt_278 SIMILAR TO similar_pattern opt_nt_279
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
	|	regular_primary question_mark
	|	regular_primary repeat_factor
	;

opt_nt_280
	:	/* Nothing */
	|	upper_limit
	;

repeat_factor
	:	left_brace low_value opt_nt_280 right_brace
	;

opt_nt_281
	:	/* Nothing */
	|	high_value ']'
	;

upper_limit
	:	comma opt_nt_281
	;

low_value
	:	unsigned_integer
	;

high_value
	:	unsigned_integer
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
	:	/* !! See the Syntax Rules */
	;

escaped_character
	:	/* !! See the Syntax Rules */
	;

lst_nt_282
	:	character_enumeration
	|	lst_nt_282 character_enumeration
	;

lst_nt_283
	:	character_enumeration
	|	lst_nt_283 character_enumeration
	;

lst_nt_284
	:	character_enumeration_include
	|	lst_nt_284 character_enumeration_include
	;

lst_nt_285
	:	character_enumeration_exclude
	|	lst_nt_285 character_enumeration_exclude
	;

regular_character_set
	:	underscore
	|	left_bracket lst_nt_282 right_bracket
	|	left_bracket circumflex lst_nt_283 right_bracket
	|	left_bracket lst_nt_284 circumflex lst_nt_285 right_bracket
	;

character_enumeration_include
	:	character_enumeration
	;

character_enumeration_exclude
	:	character_enumeration
	;

character_enumeration
	:	character_specifier
	|	character_specifier minus_sign character_specifier
	|	left_bracket colon regular_character_set_identifier colon right_bracket
	;

regular_character_set_identifier
	:	identifier
	;

null_predicate
	:	row_value_predicand null_predicate_part_2
	;

opt_nt_286
	:	/* Nothing */
	|	NOT
	;

null_predicate_part_2
	:	IS opt_nt_286 NULL
	;

quantified_comparison_predicate
	:	row_value_predicand quantified_comparison_predicate_part_2
	;

quantified_comparison_predicate_part_2
	:	comp_op quantifier table_subquery
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

opt_nt_287
	:	/* Nothing */
	|	NOT
	;

normalized_predicate
	:	string_value_expression IS opt_nt_287 NORMALIZED
	;

match_predicate
	:	row_value_predicand match_predicate_part_2
	;

opt_nt_288
	:	/* Nothing */
	|	UNIQUE
	;

opt_nt_289
	:	/* Nothing */
	|	SIMPLE
	|	PARTIAL
	|	FULL
	;

match_predicate_part_2
	:	MATCH opt_nt_288 opt_nt_289 table_subquery
	;

overlaps_predicate
	:	overlaps_predicate_part_1 overlaps_predicate_part_2
	;

overlaps_predicate_part_1
	:	row_value_predicand_1
	;

overlaps_predicate_part_2
	:	OVERLAPS row_value_predicand_2
	;

row_value_predicand_1
	:	row_value_predicand
	;

row_value_predicand_2
	:	row_value_predicand
	;

distinct_predicate
	:	row_value_predicand_3 distinct_predicate_part_2
	;

distinct_predicate_part_2
	:	IS DISTINCT FROM row_value_predicand_4
	;

row_value_predicand_3
	:	row_value_predicand
	;

row_value_predicand_4
	:	row_value_predicand
	;

member_predicate
	:	row_value_predicand member_predicate_part_2
	;

opt_nt_290
	:	/* Nothing */
	|	NOT
	;

opt_nt_291
	:	/* Nothing */
	|	OF
	;

member_predicate_part_2
	:	opt_nt_290 MEMBER opt_nt_291 multiset_value_expression
	;

submultiset_predicate
	:	row_value_predicand submultiset_predicate_part_2
	;

opt_nt_292
	:	/* Nothing */
	|	NOT
	;

opt_nt_293
	:	/* Nothing */
	|	OF
	;

submultiset_predicate_part_2
	:	opt_nt_292 SUBMULTISET opt_nt_293 multiset_value_expression
	;

set_predicate
	:	row_value_predicand set_predicate_part_2
	;

opt_nt_294
	:	/* Nothing */
	|	NOT
	;

set_predicate_part_2
	:	IS opt_nt_294 A SET
	;

type_predicate
	:	row_value_predicand type_predicate_part_2
	;

opt_nt_295
	:	/* Nothing */
	|	NOT
	;

type_predicate_part_2
	:	IS opt_nt_295 OF left_paren type_list right_paren
	;

seq_nt_297
	:	comma user_defined_type_specification
	;

lst_nt_298
	:	seq_nt_297
	|	lst_nt_298 seq_nt_297
	;

opt_nt_296
	:	/* Nothing */
	|	lst_nt_298 ']'
	;

type_list
	:	user_defined_type_specification opt_nt_296
	;

user_defined_type_specification
	:	inclusive_user_defined_type_specification
	|	exclusive_user_defined_type_specification
	;

inclusive_user_defined_type_specification
	:	path_resolved_user_defined_type_name
	;

exclusive_user_defined_type_specification
	:	ONLY path_resolved_user_defined_type_name
	;

search_condition
	:	boolean_value_expression
	;

interval_qualifier
	:	start_field TO end_field
	|	single_datetime_field
	;

opt_nt_299
	:	/* Nothing */
	|	left_paren interval_leading_field_precision right_paren ']'
	;

start_field
	:	non_second_primary_datetime_field opt_nt_299
	;

opt_nt_300
	:	/* Nothing */
	|	left_paren interval_fractional_seconds_precision right_paren ']'
	;

end_field
	:	non_second_primary_datetime_field
	|	SECOND opt_nt_300
	;

opt_nt_301
	:	/* Nothing */
	|	left_paren interval_leading_field_precision right_paren
	;

opt_nt_303
	:	/* Nothing */
	|	comma interval_fractional_seconds_precision
	;

opt_nt_302
	:	/* Nothing */
	|	left_paren interval_leading_field_precision opt_nt_303 right_paren ']'
	;

single_datetime_field
	:	non_second_primary_datetime_field opt_nt_301
	|	SECOND opt_nt_302
	;

primary_datetime_field
	:	non_second_primary_datetime_field
	|	SECOND
	;

non_second_primary_datetime_field
	:	YEAR
	|	MONTH
	|	DAY
	|	HOUR
	|	MINUTE
	;

interval_fractional_seconds_precision
	:	unsigned_integer
	;

interval_leading_field_precision
	:	unsigned_integer
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

path_specification
	:	PATH schema_name_list
	;

seq_nt_305
	:	comma schema_name
	;

lst_nt_306
	:	seq_nt_305
	|	lst_nt_306 seq_nt_305
	;

opt_nt_304
	:	/* Nothing */
	|	lst_nt_306 ']'
	;

schema_name_list
	:	schema_name opt_nt_304
	;

routine_invocation
	:	routine_name sql_argument_list
	;

opt_nt_307
	:	/* Nothing */
	|	schema_name period
	;

routine_name
	:	opt_nt_307 qualified_identifier
	;

seq_nt_310
	:	comma sql_argument
	;

lst_nt_311
	:	seq_nt_310
	|	lst_nt_311 seq_nt_310
	;

opt_nt_309
	:	/* Nothing */
	|	lst_nt_311
	;

opt_nt_308
	:	/* Nothing */
	|	sql_argument opt_nt_309
	;

sql_argument_list
	:	left_paren opt_nt_308 right_paren
	;

sql_argument
	:	value_expression
	|	generalized_expression
	|	target_specification
	;

generalized_expression
	:	value_expression AS path_resolved_user_defined_type_name
	;

character_set_specification
	:	standard_character_set_name
	|	implementation_defined_character_set_name
	|	user_defined_character_set_name
	;

standard_character_set_name
	:	character_set_name
	;

implementation_defined_character_set_name
	:	character_set_name
	;

user_defined_character_set_name
	:	character_set_name
	;

opt_nt_312
	:	/* Nothing */
	|	FOR schema_resolved_user_defined_type_name ']'
	;

specific_routine_designator
	:	SPECIFIC routine_type specific_name
	|	routine_type member_name opt_nt_312
	;

opt_nt_313
	:	/* Nothing */
	|	INSTANCE
	|	STATIC
	|	CONSTRUCTOR
	;

routine_type
	:	ROUTINE
	|	FUNCTION
	|	PROCEDURE
	|	opt_nt_313 METHOD
	;

opt_nt_314
	:	/* Nothing */
	|	data_type_list ']'
	;

member_name
	:	member_name_alternatives opt_nt_314
	;

member_name_alternatives
	:	schema_qualified_routine_name
	|	method_name
	;

seq_nt_317
	:	comma data_type
	;

lst_nt_318
	:	seq_nt_317
	|	lst_nt_318 seq_nt_317
	;

opt_nt_316
	:	/* Nothing */
	|	lst_nt_318
	;

opt_nt_315
	:	/* Nothing */
	|	data_type opt_nt_316
	;

data_type_list
	:	left_paren opt_nt_315 right_paren
	;

collate_clause
	:	COLLATE collation_name
	;

constraint_name_definition
	:	CONSTRAINT constraint_name
	;

opt_nt_320
	:	/* Nothing */
	|	NOT
	;

opt_nt_319
	:	/* Nothing */
	|	opt_nt_320 DEFERRABLE
	;

opt_nt_321
	:	/* Nothing */
	|	NOT
	;

opt_nt_322
	:	/* Nothing */
	|	constraint_check_time ']'
	;

constraint_characteristics
	:	constraint_check_time opt_nt_319
	|	opt_nt_321 DEFERRABLE opt_nt_322
	;

constraint_check_time
	:	INITIALLY DEFERRED
	|	INITIALLY IMMEDIATE
	;

opt_nt_323
	:	/* Nothing */
	|	filter_clause
	;

opt_nt_324
	:	/* Nothing */
	|	filter_clause
	;

opt_nt_325
	:	/* Nothing */
	|	filter_clause
	;

opt_nt_326
	:	/* Nothing */
	|	filter_clause ']'
	;

aggregate_function
	:	COUNT left_paren asterisk right_paren opt_nt_323
	|	general_set_function opt_nt_324
	|	binary_set_function opt_nt_325
	|	ordered_set_function opt_nt_326
	;

opt_nt_327
	:	/* Nothing */
	|	set_quantifier
	;

general_set_function
	:	set_function_type left_paren opt_nt_327 value_expression right_paren
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
	|	STDDEV_POP
	|	STDDEV_SAMP
	|	VAR_SAMP
	|	VAR_POP
	|	COLLECT
	|	FUSION
	|	INTERSECTION
	;

set_quantifier
	:	DISTINCT
	|	ALL
	;

filter_clause
	:	FILTER left_paren WHERE search_condition right_paren
	;

binary_set_function
	:	binary_set_function_type left_paren dependent_variable_expression comma
	;

binary_set_function_type
	:	COVAR_POP
	|	COVAR_SAMP
	|	CORR
	|	REGR_SLOPE
	|	REGR_INTERCEPT
	|	REGR_COUNT
	|	REGR_R2
	|	REGR_AVGX
	|	REGR_AVGY
	|	REGR_SXX
	|	REGR_SYY
	|	REGR_SXY
	;

dependent_variable_expression
	:	numeric_value_expression
	;

independent_variable_expression
	:	numeric_value_expression
	;

ordered_set_function
	:	hypothetical_set_function
	|	inverse_distribution_function
	;

hypothetical_set_function
	:	rank_function_type left_paren hypothetical_set_function_value_expression_list right_paren within_group_specification
	;

within_group_specification
	:	WITHIN GROUP left_paren ORDER BY sort_specification_list right_paren
	;

seq_nt_329
	:	comma value_expression
	;

lst_nt_330
	:	seq_nt_329
	|	lst_nt_330 seq_nt_329
	;

opt_nt_328
	:	/* Nothing */
	|	lst_nt_330 ']'
	;

hypothetical_set_function_value_expression_list
	:	value_expression opt_nt_328
	;

inverse_distribution_function
	:	inverse_distribution_function_type left_paren inverse_distribution_function_argument right_paren within_group_specification
	;

inverse_distribution_function_argument
	:	numeric_value_expression
	;

inverse_distribution_function_type
	:	PERCENTILE_CONT
	|	PERCENTILE_DISC
	;

seq_nt_332
	:	comma sort_specification
	;

lst_nt_333
	:	seq_nt_332
	|	lst_nt_333 seq_nt_332
	;

opt_nt_331
	:	/* Nothing */
	|	lst_nt_333 ']'
	;

sort_specification_list
	:	sort_specification opt_nt_331
	;

opt_nt_334
	:	/* Nothing */
	|	ordering_specification
	;

opt_nt_335
	:	/* Nothing */
	|	null_ordering ']'
	;

sort_specification
	:	sort_key opt_nt_334 opt_nt_335
	;

sort_key
	:	value_expression
	;

ordering_specification
	:	ASC
	|	DESC
	;

null_ordering
	:	NULLS FIRST
	|	NULLS LAST
	;

opt_nt_336
	:	/* Nothing */
	|	schema_character_set_or_path
	;

lst_nt_338
	:	schema_element
	|	lst_nt_338 schema_element
	;

opt_nt_337
	:	/* Nothing */
	|	lst_nt_338 ']'
	;

schema_definition
	:	CREATE SCHEMA schema_name_clause opt_nt_336 opt_nt_337
	;

schema_character_set_or_path
	:	schema_character_set_specification
	|	schema_path_specification
	|	schema_character_set_specification schema_path_specification
	|	schema_path_specification schema_character_set_specification
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

schema_path_specification
	:	path_specification
	;

schema_element
	:	table_definition
	|	view_definition
	|	domain_definition
	|	character_set_definition
	|	collation_definition
	|	transliteration_definition
	|	assertion_definition
	|	trigger_definition
	|	user_defined_type_definition
	|	user_defined_cast_definition
	|	user_defined_ordering_definition
	|	transform_definition
	|	schema_routine
	|	sequence_generator_definition
	|	grant_statement
	|	role_definition
	;

drop_schema_statement
	:	DROP SCHEMA schema_name drop_behavior
	;

drop_behavior
	:	CASCADE
	|	RESTRICT
	;

opt_nt_339
	:	/* Nothing */
	|	table_scope
	;

opt_nt_340
	:	/* Nothing */
	|	ON COMMIT table_commit_action ROWS ']'
	;

table_definition
	:	CREATE opt_nt_339 TABLE table_name table_contents_source opt_nt_340
	;

opt_nt_341
	:	/* Nothing */
	|	subtable_clause
	;

opt_nt_342
	:	/* Nothing */
	|	table_element_list
	;

table_contents_source
	:	table_element_list
	|	OF path_resolved_user_defined_type_name opt_nt_341 opt_nt_342
	|	as_subquery_clause
	;

table_scope
	:	global_or_local TEMPORARY
	;

global_or_local
	:	GLOBAL
	|	LOCAL
	;

table_commit_action
	:	PRESERVE
	|	DELETE
	;

seq_nt_344
	:	comma table_element
	;

lst_nt_345
	:	seq_nt_344
	|	lst_nt_345 seq_nt_344
	;

opt_nt_343
	:	/* Nothing */
	|	lst_nt_345
	;

table_element_list
	:	left_paren table_element opt_nt_343 right_paren
	;

table_element
	:	column_definition
	|	table_constraint_definition
	|	like_clause
	|	self_referencing_column_specification
	|	column_options
	;

self_referencing_column_specification
	:	REF IS self_referencing_column_name reference_generation
	;

reference_generation
	:	SYSTEM GENERATED
	|	USER GENERATED
	|	DERIVED
	;

self_referencing_column_name
	:	column_name
	;

column_options
	:	column_name WITH OPTIONS column_option_list
	;

opt_nt_346
	:	/* Nothing */
	|	scope_clause
	;

opt_nt_347
	:	/* Nothing */
	|	default_clause
	;

lst_nt_349
	:	column_constraint_definition
	|	lst_nt_349 column_constraint_definition
	;

opt_nt_348
	:	/* Nothing */
	|	lst_nt_349 ']'
	;

column_option_list
	:	opt_nt_346 opt_nt_347 opt_nt_348
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

opt_nt_350
	:	/* Nothing */
	|	like_options ']'
	;

like_clause
	:	LIKE table_name opt_nt_350
	;

like_options
	:	identity_option
	|	column_default_option
	;

identity_option
	:	INCLUDING IDENTITY
	|	EXCLUDING IDENTITY
	;

column_default_option
	:	INCLUDING DEFAULTS
	|	EXCLUDING DEFAULTS
	;

opt_nt_351
	:	/* Nothing */
	|	left_paren column_name_list right_paren
	;

as_subquery_clause
	:	opt_nt_351 AS subquery with_or_without_data
	;

with_or_without_data
	:	WITH NO DATA
	|	WITH DATA
	;

opt_nt_352
	:	/* Nothing */
	|	data_type
	|	domain_name
	;

opt_nt_353
	:	/* Nothing */
	|	reference_scope_check
	;

opt_nt_354
	:	/* Nothing */
	|	default_clause
	|	identity_column_specification
	|	generation_clause
	;

lst_nt_356
	:	column_constraint_definition
	|	lst_nt_356 column_constraint_definition
	;

opt_nt_355
	:	/* Nothing */
	|	lst_nt_356
	;

opt_nt_357
	:	/* Nothing */
	|	collate_clause ']'
	;

column_definition
	:	column_name opt_nt_352 opt_nt_353 opt_nt_354 opt_nt_355 opt_nt_357
	;

opt_nt_358
	:	/* Nothing */
	|	constraint_name_definition
	;

opt_nt_359
	:	/* Nothing */
	|	constraint_characteristics ']'
	;

column_constraint_definition
	:	opt_nt_358 column_constraint opt_nt_359
	;

column_constraint
	:	NOT NULL
	|	unique_specification
	|	references_specification
	|	check_constraint_definition
	;

opt_nt_360
	:	/* Nothing */
	|	NOT
	;

opt_nt_361
	:	/* Nothing */
	|	ON DELETE reference_scope_check_action ']'
	;

reference_scope_check
	:	REFERENCES ARE opt_nt_360 CHECKED opt_nt_361
	;

reference_scope_check_action
	:	referential_action
	;

seq_nt_362
	:	ALWAYS
	|	BY DEFAULT
	;

opt_nt_363
	:	/* Nothing */
	|	left_paren common_sequence_generator_options right_paren ']'
	;

identity_column_specification
	:	GENERATED seq_nt_362 AS IDENTITY opt_nt_363
	;

generation_clause
	:	generation_rule AS generation_expression
	;

generation_rule
	:	GENERATED ALWAYS
	;

generation_expression
	:	left_paren value_expression right_paren
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

opt_nt_364
	:	/* Nothing */
	|	constraint_name_definition
	;

opt_nt_365
	:	/* Nothing */
	|	constraint_characteristics ']'
	;

table_constraint_definition
	:	opt_nt_364 table_constraint opt_nt_365
	;

table_constraint
	:	unique_constraint_definition
	|	referential_constraint_definition
	|	check_constraint_definition
	;

unique_constraint_definition
	:	unique_specification left_paren unique_column_list right_paren
	|	UNIQUE
	;

unique_specification
	:	UNIQUE
	|	PRIMARY KEY
	;

unique_column_list
	:	column_name_list
	;

referential_constraint_definition
	:	FOREIGN KEY left_paren referencing_columns right_paren references_specification
	;

opt_nt_366
	:	/* Nothing */
	|	MATCH match_type
	;

opt_nt_367
	:	/* Nothing */
	|	referential_triggered_action ']'
	;

references_specification
	:	REFERENCES referenced_table_and_columns opt_nt_366 opt_nt_367
	;

match_type
	:	FULL
	|	PARTIAL
	|	SIMPLE
	;

referencing_columns
	:	reference_column_list
	;

opt_nt_368
	:	/* Nothing */
	|	left_paren reference_column_list right_paren ']'
	;

referenced_table_and_columns
	:	table_name opt_nt_368
	;

reference_column_list
	:	column_name_list
	;

opt_nt_369
	:	/* Nothing */
	|	delete_rule
	;

opt_nt_370
	:	/* Nothing */
	|	update_rule ']'
	;

referential_triggered_action
	:	update_rule opt_nt_369
	|	delete_rule opt_nt_370
	;

update_rule
	:	ON UPDATE referential_action
	;

delete_rule
	:	ON DELETE referential_action
	;

referential_action
	:	CASCADE
	|	SET NULL
	|	SET DEFAULT
	|	RESTRICT
	|	NO ACTION
	;

check_constraint_definition
	:	CHECK left_paren search_condition right_paren
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

opt_nt_371
	:	/* Nothing */
	|	COLUMN
	;

add_column_definition
	:	ADD opt_nt_371 column_definition
	;

opt_nt_372
	:	/* Nothing */
	|	COLUMN
	;

alter_column_definition
	:	ALTER opt_nt_372 column_name alter_column_action
	;

alter_column_action
	:	set_column_default_clause
	|	drop_column_default_clause
	|	add_column_scope_clause
	|	drop_column_scope_clause
	|	alter_identity_column_specification
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

lst_nt_373
	:	alter_identity_column_option
	|	lst_nt_373 alter_identity_column_option
	;

alter_identity_column_specification
	:	lst_nt_373
	;

alter_identity_column_option
	:	alter_sequence_generator_restart_option
	|	SET basic_sequence_generator_option
	;

opt_nt_374
	:	/* Nothing */
	|	COLUMN
	;

drop_column_definition
	:	DROP opt_nt_374 column_name drop_behavior
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

opt_nt_375
	:	/* Nothing */
	|	RECURSIVE
	;

opt_nt_377
	:	/* Nothing */
	|	levels_clause
	;

opt_nt_376
	:	/* Nothing */
	|	WITH opt_nt_377 CHECK OPTION ']'
	;

view_definition
	:	CREATE opt_nt_375 VIEW table_name view_specification AS query_expression opt_nt_376
	;

view_specification
	:	regular_view_specification
	|	referenceable_view_specification
	;

opt_nt_378
	:	/* Nothing */
	|	left_paren view_column_list right_paren ']'
	;

regular_view_specification
	:	opt_nt_378
	;

opt_nt_379
	:	/* Nothing */
	|	subview_clause
	;

opt_nt_380
	:	/* Nothing */
	|	view_element_list ']'
	;

referenceable_view_specification
	:	OF path_resolved_user_defined_type_name opt_nt_379 opt_nt_380
	;

subview_clause
	:	UNDER table_name
	;

seq_nt_382
	:	comma view_element
	;

lst_nt_383
	:	seq_nt_382
	|	lst_nt_383 seq_nt_382
	;

opt_nt_381
	:	/* Nothing */
	|	lst_nt_383
	;

view_element_list
	:	left_paren view_element opt_nt_381 right_paren
	;

view_element
	:	self_referencing_column_specification
	|	view_column_option
	;

view_column_option
	:	column_name WITH OPTIONS scope_clause
	;

levels_clause
	:	CASCADED
	|	LOCAL
	;

view_column_list
	:	column_name_list
	;

drop_view_statement
	:	DROP VIEW table_name drop_behavior
	;

opt_nt_384
	:	/* Nothing */
	|	AS
	;

opt_nt_385
	:	/* Nothing */
	|	default_clause
	;

lst_nt_387
	:	domain_constraint
	|	lst_nt_387 domain_constraint
	;

opt_nt_386
	:	/* Nothing */
	|	lst_nt_387
	;

opt_nt_388
	:	/* Nothing */
	|	collate_clause ']'
	;

domain_definition
	:	CREATE DOMAIN domain_name opt_nt_384 data_type opt_nt_385 opt_nt_386 opt_nt_388
	;

opt_nt_389
	:	/* Nothing */
	|	constraint_name_definition
	;

opt_nt_390
	:	/* Nothing */
	|	constraint_characteristics ']'
	;

domain_constraint
	:	opt_nt_389 check_constraint_definition opt_nt_390
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

opt_nt_391
	:	/* Nothing */
	|	AS
	;

opt_nt_392
	:	/* Nothing */
	|	collate_clause ']'
	;

character_set_definition
	:	CREATE CHARACTER SET character_set_name opt_nt_391 character_set_source opt_nt_392
	;

character_set_source
	:	GET character_set_specification
	;

drop_character_set_statement
	:	DROP CHARACTER SET character_set_name
	;

opt_nt_393
	:	/* Nothing */
	|	pad_characteristic ']'
	;

collation_definition
	:	CREATE COLLATION collation_name FOR character_set_specification FROM existing_collation_name opt_nt_393
	;

existing_collation_name
	:	collation_name
	;

pad_characteristic
	:	NO PAD
	|	PAD SPACE
	;

drop_collation_statement
	:	DROP COLLATION collation_name drop_behavior
	;

transliteration_definition
	:	CREATE TRANSLATION transliteration_name FOR source_character_set_specification TO target_character_set_specification FROM transliteration_source
	;

source_character_set_specification
	:	character_set_specification
	;

target_character_set_specification
	:	character_set_specification
	;

transliteration_source
	:	existing_transliteration_name
	|	transliteration_routine
	;

existing_transliteration_name
	:	transliteration_name
	;

transliteration_routine
	:	specific_routine_designator
	;

drop_transliteration_statement
	:	DROP TRANSLATION transliteration_name
	;

opt_nt_394
	:	/* Nothing */
	|	constraint_characteristics ']'
	;

assertion_definition
	:	CREATE ASSERTION constraint_name CHECK left_paren search_condition right_paren opt_nt_394
	;

drop_assertion_statement
	:	DROP ASSERTION constraint_name
	;

opt_nt_395
	:	/* Nothing */
	|	REFERENCING old_or_new_values_alias_list
	;

trigger_definition
	:	CREATE TRIGGER trigger_name trigger_action_time trigger_event ON table_name opt_nt_395 triggered_action
	;

trigger_action_time
	:	BEFORE
	|	AFTER
	;

opt_nt_396
	:	/* Nothing */
	|	OF trigger_column_list ']'
	;

trigger_event
	:	INSERT
	|	DELETE
	|	UPDATE opt_nt_396
	;

trigger_column_list
	:	column_name_list
	;

seq_nt_398
	:	ROW
	|	STATEMENT
	;

opt_nt_397
	:	/* Nothing */
	|	FOR EACH seq_nt_398
	;

opt_nt_399
	:	/* Nothing */
	|	WHEN left_paren search_condition right_paren
	;

triggered_action
	:	opt_nt_397 opt_nt_399 triggered_sql_statement
	;

seq_nt_400
	:	sql_procedure_statement semicolon
	;

lst_nt_401
	:	seq_nt_400
	|	lst_nt_401 seq_nt_400
	;

triggered_sql_statement
	:	sql_procedure_statement
	|	BEGIN ATOMIC lst_nt_401 END
	;

lst_nt_402
	:	old_or_new_values_alias
	|	lst_nt_402 old_or_new_values_alias
	;

old_or_new_values_alias_list
	:	lst_nt_402
	;

opt_nt_403
	:	/* Nothing */
	|	ROW
	;

opt_nt_404
	:	/* Nothing */
	|	AS
	;

opt_nt_405
	:	/* Nothing */
	|	ROW
	;

opt_nt_406
	:	/* Nothing */
	|	AS
	;

opt_nt_407
	:	/* Nothing */
	|	AS
	;

opt_nt_408
	:	/* Nothing */
	|	AS
	;

old_or_new_values_alias
	:	OLD opt_nt_403 opt_nt_404 old_values_correlation_name
	|	NEW opt_nt_405 opt_nt_406 new_values_correlation_name
	|	OLD TABLE opt_nt_407 old_values_table_alias
	|	NEW TABLE opt_nt_408 new_values_table_alias
	;

old_values_table_alias
	:	identifier
	;

new_values_table_alias
	:	identifier
	;

old_values_correlation_name
	:	correlation_name
	;

new_values_correlation_name
	:	correlation_name
	;

drop_trigger_statement
	:	DROP TRIGGER trigger_name
	;

user_defined_type_definition
	:	CREATE TYPE user_defined_type_body
	;

opt_nt_409
	:	/* Nothing */
	|	subtype_clause
	;

opt_nt_410
	:	/* Nothing */
	|	AS representation
	;

opt_nt_411
	:	/* Nothing */
	|	user_defined_type_option_list
	;

opt_nt_412
	:	/* Nothing */
	|	method_specification_list ']'
	;

user_defined_type_body
	:	schema_resolved_user_defined_type_name opt_nt_409 opt_nt_410 opt_nt_411 opt_nt_412
	;

lst_nt_414
	:	user_defined_type_option
	|	lst_nt_414 user_defined_type_option
	;

opt_nt_413
	:	/* Nothing */
	|	lst_nt_414 ']'
	;

user_defined_type_option_list
	:	user_defined_type_option opt_nt_413
	;

user_defined_type_option
	:	instantiable_clause
	|	finality
	|	reference_type_specification
	|	ref_cast_option
	|	cast_option
	;

subtype_clause
	:	UNDER supertype_name
	;

supertype_name
	:	path_resolved_user_defined_type_name
	;

representation
	:	predefined_type
	|	member_list
	;

seq_nt_416
	:	comma member
	;

lst_nt_417
	:	seq_nt_416
	|	lst_nt_417 seq_nt_416
	;

opt_nt_415
	:	/* Nothing */
	|	lst_nt_417
	;

member_list
	:	left_paren member opt_nt_415 right_paren
	;

member
	:	attribute_definition
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

derived_representation
	:	REF FROM list_of_attributes
	;

system_generated_representation
	:	REF IS SYSTEM GENERATED
	;

opt_nt_418
	:	/* Nothing */
	|	cast_to_ref
	;

opt_nt_419
	:	/* Nothing */
	|	cast_to_type ']'
	;

ref_cast_option
	:	opt_nt_418 opt_nt_419
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

seq_nt_421
	:	comma attribute_name
	;

lst_nt_422
	:	seq_nt_421
	|	lst_nt_422 seq_nt_421
	;

opt_nt_420
	:	/* Nothing */
	|	lst_nt_422
	;

list_of_attributes
	:	left_paren attribute_name opt_nt_420 right_paren
	;

opt_nt_423
	:	/* Nothing */
	|	cast_to_distinct
	;

opt_nt_424
	:	/* Nothing */
	|	cast_to_source ']'
	;

cast_option
	:	opt_nt_423 opt_nt_424
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

seq_nt_426
	:	comma method_specification
	;

lst_nt_427
	:	seq_nt_426
	|	lst_nt_427 seq_nt_426
	;

opt_nt_425
	:	/* Nothing */
	|	lst_nt_427 ']'
	;

method_specification_list
	:	method_specification opt_nt_425
	;

method_specification
	:	original_method_specification
	|	overriding_method_specification
	;

opt_nt_428
	:	/* Nothing */
	|	SELF AS RESULT
	;

opt_nt_429
	:	/* Nothing */
	|	SELF AS LOCATOR
	;

opt_nt_430
	:	/* Nothing */
	|	method_characteristics ']'
	;

original_method_specification
	:	partial_method_specification opt_nt_428 opt_nt_429 opt_nt_430
	;

overriding_method_specification
	:	OVERRIDING partial_method_specification
	;

opt_nt_431
	:	/* Nothing */
	|	INSTANCE
	|	STATIC
	|	CONSTRUCTOR
	;

opt_nt_432
	:	/* Nothing */
	|	SPECIFIC specific_method_name ']'
	;

partial_method_specification
	:	opt_nt_431 METHOD method_name sql_parameter_declaration_list returns_clause opt_nt_432
	;

opt_nt_433
	:	/* Nothing */
	|	schema_name period
	;

specific_method_name
	:	opt_nt_433 qualified_identifier
	;

lst_nt_434
	:	method_characteristic
	|	lst_nt_434 method_characteristic
	;

method_characteristics
	:	lst_nt_434
	;

method_characteristic
	:	language_clause
	|	parameter_style_clause
	|	deterministic_characteristic
	|	sql_data_access_indication
	|	null_call_clause
	;

opt_nt_435
	:	/* Nothing */
	|	reference_scope_check
	;

opt_nt_436
	:	/* Nothing */
	|	attribute_default
	;

opt_nt_437
	:	/* Nothing */
	|	collate_clause ']'
	;

attribute_definition
	:	attribute_name data_type opt_nt_435 opt_nt_436 opt_nt_437
	;

attribute_default
	:	default_clause
	;

alter_type_statement
	:	
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

opt_nt_438
	:	/* Nothing */
	|	INSTANCE
	|	STATIC
	|	CONSTRUCTOR
	;

specific_method_specification_designator
	:	opt_nt_438 METHOD method_name data_type_list
	;

drop_data_type_statement
	:	DROP TYPE schema_resolved_user_defined_type_name drop_behavior
	;

sql_invoked_routine
	:	schema_routine
	;

schema_routine
	:	schema_procedure
	|	schema_function
	;

schema_procedure
	:	CREATE sql_invoked_procedure
	;

schema_function
	:	CREATE sql_invoked_function
	;

sql_invoked_procedure
	:	PROCEDURE schema_qualified_routine_name sql_parameter_declaration_list routine_characteristics routine_body
	;

seq_nt_439
	:	function_specification
	|	method_specification_designator
	;

sql_invoked_function
	:	seq_nt_439 routine_body
	;

seq_nt_442
	:	comma sql_parameter_declaration
	;

lst_nt_443
	:	seq_nt_442
	|	lst_nt_443 seq_nt_442
	;

opt_nt_441
	:	/* Nothing */
	|	lst_nt_443
	;

opt_nt_440
	:	/* Nothing */
	|	sql_parameter_declaration opt_nt_441
	;

sql_parameter_declaration_list
	:	left_paren opt_nt_440 right_paren
	;

opt_nt_444
	:	/* Nothing */
	|	parameter_mode
	;

opt_nt_445
	:	/* Nothing */
	|	sql_parameter_name
	;

opt_nt_446
	:	/* Nothing */
	|	RESULT ']'
	;

sql_parameter_declaration
	:	opt_nt_444 opt_nt_445 parameter_type opt_nt_446
	;

parameter_mode
	:	IN
	|	OUT
	|	INOUT
	;

opt_nt_447
	:	/* Nothing */
	|	locator_indication ']'
	;

parameter_type
	:	data_type opt_nt_447
	;

locator_indication
	:	AS LOCATOR
	;

opt_nt_448
	:	/* Nothing */
	|	dispatch_clause ']'
	;

function_specification
	:	FUNCTION schema_qualified_routine_name sql_parameter_declaration_list returns_clause routine_characteristics opt_nt_448
	;

opt_nt_449
	:	/* Nothing */
	|	INSTANCE
	|	STATIC
	|	CONSTRUCTOR
	;

opt_nt_450
	:	/* Nothing */
	|	returns_clause
	;

method_specification_designator
	:	SPECIFIC METHOD specific_method_name
	|	opt_nt_449 METHOD method_name sql_parameter_declaration_list opt_nt_450 FOR schema_resolved_user_defined_type_name
	;

lst_nt_452
	:	routine_characteristic
	|	lst_nt_452 routine_characteristic
	;

opt_nt_451
	:	/* Nothing */
	|	lst_nt_452 ']'
	;

routine_characteristics
	:	opt_nt_451
	;

routine_characteristic
	:	language_clause
	|	parameter_style_clause
	|	SPECIFIC specific_name
	|	deterministic_characteristic
	|	sql_data_access_indication
	|	null_call_clause
	|	dynamic_result_sets_characteristic
	|	savepoint_level_indication
	;

savepoint_level_indication
	:	NEW SAVEPOINT LEVEL
	|	OLD SAVEPOINT LEVEL
	;

dynamic_result_sets_characteristic
	:	DYNAMIC RESULT SETS maximum_dynamic_result_sets
	;

parameter_style_clause
	:	PARAMETER STYLE parameter_style
	;

dispatch_clause
	:	STATIC DISPATCH
	;

returns_clause
	:	RETURNS returns_type
	;

opt_nt_453
	:	/* Nothing */
	|	result_cast
	;

returns_type
	:	returns_data_type opt_nt_453
	|	returns_table_type
	;

returns_table_type
	:	TABLE table_function_column_list
	;

seq_nt_455
	:	comma table_function_column_list_element
	;

lst_nt_456
	:	seq_nt_455
	|	lst_nt_456 seq_nt_455
	;

opt_nt_454
	:	/* Nothing */
	|	lst_nt_456
	;

table_function_column_list
	:	left_paren table_function_column_list_element opt_nt_454 right_paren
	;

table_function_column_list_element
	:	column_name data_type
	;

result_cast
	:	CAST FROM result_cast_from_type
	;

opt_nt_457
	:	/* Nothing */
	|	locator_indication ']'
	;

result_cast_from_type
	:	data_type opt_nt_457
	;

opt_nt_458
	:	/* Nothing */
	|	locator_indication ']'
	;

returns_data_type
	:	data_type opt_nt_458
	;

routine_body
	:	sql_routine_spec
	|	external_body_reference
	;

opt_nt_459
	:	/* Nothing */
	|	rights_clause
	;

sql_routine_spec
	:	opt_nt_459 sql_routine_body
	;

rights_clause
	:	SQL SECURITY INVOKER
	|	SQL SECURITY DEFINER
	;

sql_routine_body
	:	sql_procedure_statement
	;

opt_nt_460
	:	/* Nothing */
	|	NAME external_routine_name
	;

opt_nt_461
	:	/* Nothing */
	|	parameter_style_clause
	;

opt_nt_462
	:	/* Nothing */
	|	transform_group_specification
	;

opt_nt_463
	:	/* Nothing */
	|	external_security_clause ']'
	;

external_body_reference
	:	EXTERNAL opt_nt_460 opt_nt_461 opt_nt_462 opt_nt_463
	;

external_security_clause
	:	EXTERNAL SECURITY DEFINER
	|	EXTERNAL SECURITY INVOKER
	|	EXTERNAL SECURITY IMPLEMENTATION DEFINED
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

maximum_dynamic_result_sets
	:	unsigned_integer
	;

seq_nt_464
	:	single_group_specification
	|	multiple_group_specification '}'
	;

transform_group_specification
	:	TRANSFORM GROUP seq_nt_464
	;

single_group_specification
	:	group_name
	;

seq_nt_466
	:	comma group_specification
	;

lst_nt_467
	:	seq_nt_466
	|	lst_nt_467 seq_nt_466
	;

opt_nt_465
	:	/* Nothing */
	|	lst_nt_467 ']'
	;

multiple_group_specification
	:	group_specification opt_nt_465
	;

group_specification
	:	group_name FOR TYPE path_resolved_user_defined_type_name
	;

alter_routine_statement
	:	ALTER specific_routine_designator alter_routine_characteristics alter_routine_behavior
	;

lst_nt_468
	:	alter_routine_characteristic
	|	lst_nt_468 alter_routine_characteristic
	;

alter_routine_characteristics
	:	lst_nt_468
	;

alter_routine_characteristic
	:	language_clause
	|	parameter_style_clause
	|	sql_data_access_indication
	|	null_call_clause
	|	dynamic_result_sets_characteristic
	|	NAME external_routine_name
	;

alter_routine_behavior
	:	RESTRICT
	;

drop_routine_statement
	:	DROP specific_routine_designator drop_behavior
	;

opt_nt_469
	:	/* Nothing */
	|	AS ASSIGNMENT ']'
	;

user_defined_cast_definition
	:	CREATE CAST left_paren source_data_type AS target_data_type right_paren WITH cast_function opt_nt_469
	;

cast_function
	:	specific_routine_designator
	;

source_data_type
	:	data_type
	;

target_data_type
	:	data_type
	;

drop_user_defined_cast_statement
	:	DROP CAST left_paren source_data_type AS target_data_type right_paren drop_behavior
	;

user_defined_ordering_definition
	:	CREATE ORDERING FOR schema_resolved_user_defined_type_name ordering_form
	;

ordering_form
	:	equals_ordering_form
	|	full_ordering_form
	;

equals_ordering_form
	:	EQUALS ONLY BY ordering_category
	;

full_ordering_form
	:	ORDER FULL BY ordering_category
	;

ordering_category
	:	relative_category
	|	map_category
	|	state_category
	;

relative_category
	:	RELATIVE WITH relative_function_specification
	;

map_category
	:	MAP WITH map_function_specification
	;

opt_nt_470
	:	/* Nothing */
	|	specific_name ']'
	;

state_category
	:	STATE opt_nt_470
	;

relative_function_specification
	:	specific_routine_designator
	;

map_function_specification
	:	specific_routine_designator
	;

drop_user_defined_ordering_statement
	:	DROP ORDERING FOR schema_resolved_user_defined_type_name drop_behavior
	;

seq_nt_471
	:	TRANSFORM
	|	TRANSFORMS
	;

lst_nt_472
	:	transform_group
	|	lst_nt_472 transform_group
	;

transform_definition
	:	CREATE seq_nt_471 FOR schema_resolved_user_defined_type_name lst_nt_472
	;

transform_group
	:	group_name left_paren transform_element_list right_paren
	;

group_name
	:	identifier
	;

opt_nt_473
	:	/* Nothing */
	|	comma transform_element ']'
	;

transform_element_list
	:	transform_element opt_nt_473
	;

transform_element
	:	to_sql
	|	from_sql
	;

to_sql
	:	TO SQL WITH to_sql_function
	;

from_sql
	:	FROM SQL WITH from_sql_function
	;

to_sql_function
	:	specific_routine_designator
	;

from_sql_function
	:	specific_routine_designator
	;

seq_nt_474
	:	TRANSFORM
	|	TRANSFORMS
	;

lst_nt_475
	:	alter_group
	|	lst_nt_475 alter_group
	;

alter_transform_statement
	:	ALTER seq_nt_474 FOR schema_resolved_user_defined_type_name lst_nt_475
	;

alter_group
	:	group_name left_paren alter_transform_action_list right_paren
	;

seq_nt_477
	:	comma alter_transform_action
	;

lst_nt_478
	:	seq_nt_477
	|	lst_nt_478 seq_nt_477
	;

opt_nt_476
	:	/* Nothing */
	|	lst_nt_478 ']'
	;

alter_transform_action_list
	:	alter_transform_action opt_nt_476
	;

alter_transform_action
	:	add_transform_element_list
	|	drop_transform_element_list
	;

add_transform_element_list
	:	ADD left_paren transform_element_list right_paren
	;

opt_nt_479
	:	/* Nothing */
	|	comma transform_kind
	;

drop_transform_element_list
	:	DROP left_paren transform_kind opt_nt_479 drop_behavior right_paren
	;

transform_kind
	:	TO SQL
	|	FROM SQL
	;

seq_nt_480
	:	TRANSFORM
	|	TRANSFORMS
	;

drop_transform_statement
	:	DROP seq_nt_480 transforms_to_be_dropped FOR schema_resolved_user_defined_type_name drop_behavior
	;

transforms_to_be_dropped
	:	ALL
	|	transform_group_element
	;

transform_group_element
	:	group_name
	;

opt_nt_481
	:	/* Nothing */
	|	sequence_generator_options ']'
	;

sequence_generator_definition
	:	CREATE SEQUENCE sequence_generator_name opt_nt_481
	;

lst_nt_482
	:	sequence_generator_option
	|	lst_nt_482 sequence_generator_option
	;

sequence_generator_options
	:	lst_nt_482
	;

sequence_generator_option
	:	sequence_generator_data_type_option
	|	common_sequence_generator_options
	;

lst_nt_483
	:	common_sequence_generator_option
	|	lst_nt_483 common_sequence_generator_option
	;

common_sequence_generator_options
	:	lst_nt_483
	;

common_sequence_generator_option
	:	sequence_generator_start_with_option
	|	basic_sequence_generator_option
	;

basic_sequence_generator_option
	:	sequence_generator_increment_by_option
	|	sequence_generator_maxvalue_option
	|	sequence_generator_minvalue_option
	|	sequence_generator_cycle_option
	;

sequence_generator_data_type_option
	:	AS data_type
	;

sequence_generator_start_with_option
	:	START WITH sequence_generator_start_value
	;

sequence_generator_start_value
	:	signed_numeric_literal
	;

sequence_generator_increment
	:	signed_numeric_literal
	;

sequence_generator_maxvalue_option
	:	
	;

sequence_generator_max_value
	:	signed_numeric_literal
	;

sequence_generator_minvalue_option
	:	MINVALUE sequence_generator_min_value
	|	NO MINVALUE
	;

sequence_generator_min_value
	:	signed_numeric_literal
	;

sequence_generator_cycle_option
	:	CYCLE
	|	NO CYCLE
	;

alter_sequence_generator_statement
	:	ALTER SEQUENCE sequence_generator_name alter_sequence_generator_options
	;

lst_nt_484
	:	alter_sequence_generator_option
	|	lst_nt_484 alter_sequence_generator_option
	;

alter_sequence_generator_options
	:	lst_nt_484
	;

alter_sequence_generator_option
	:	alter_sequence_generator_restart_option
	|	basic_sequence_generator_option
	;

alter_sequence_generator_restart_option
	:	RESTART WITH sequence_generator_restart_value
	;

sequence_generator_restart_value
	:	signed_numeric_literal
	;

drop_sequence_generator_statement
	:	DROP SEQUENCE sequence_generator_name drop_behavior
	;

grant_statement
	:	grant_privilege_statement
	|	grant_role_statement
	;

seq_nt_486
	:	comma grantee
	;

lst_nt_487
	:	seq_nt_486
	|	lst_nt_487 seq_nt_486
	;

opt_nt_485
	:	/* Nothing */
	|	lst_nt_487
	;

opt_nt_488
	:	/* Nothing */
	|	WITH HIERARCHY OPTION
	;

opt_nt_489
	:	/* Nothing */
	|	WITH GRANT OPTION
	;

opt_nt_490
	:	/* Nothing */
	|	GRANTED BY grantor ']'
	;

grant_privilege_statement
	:	GRANT privileges TO grantee opt_nt_485 opt_nt_488 opt_nt_489 opt_nt_490
	;

privileges
	:	object_privileges ON object_name
	;

opt_nt_491
	:	/* Nothing */
	|	TABLE
	;

object_name
	:	opt_nt_491 table_name
	|	DOMAIN domain_name
	|	COLLATION collation_name
	|	CHARACTER SET character_set_name
	|	TRANSLATION transliteration_name
	|	TYPE schema_resolved_user_defined_type_name
	|	SEQUENCE sequence_generator_name
	|	specific_routine_designator
	;

seq_nt_493
	:	comma action
	;

lst_nt_494
	:	seq_nt_493
	|	lst_nt_494 seq_nt_493
	;

opt_nt_492
	:	/* Nothing */
	|	lst_nt_494 ']'
	;

object_privileges
	:	ALL PRIVILEGES
	|	action opt_nt_492
	;

opt_nt_495
	:	/* Nothing */
	|	left_paren privilege_column_list right_paren
	;

opt_nt_496
	:	/* Nothing */
	|	left_paren privilege_column_list right_paren
	;

opt_nt_497
	:	/* Nothing */
	|	left_paren privilege_column_list right_paren
	;

action
	:	SELECT
	|	SELECT left_paren privilege_column_list right_paren
	|	SELECT left_paren privilege_method_list right_paren
	|	DELETE
	|	INSERT opt_nt_495
	|	UPDATE opt_nt_496
	|	REFERENCES opt_nt_497
	|	USAGE
	|	TRIGGER
	|	UNDER
	|	EXECUTE
	;

seq_nt_499
	:	comma specific_routine_designator
	;

lst_nt_500
	:	seq_nt_499
	|	lst_nt_500 seq_nt_499
	;

opt_nt_498
	:	/* Nothing */
	|	lst_nt_500 ']'
	;

privilege_method_list
	:	specific_routine_designator opt_nt_498
	;

privilege_column_list
	:	column_name_list
	;

grantee
	:	PUBLIC
	|	authorization_identifier
	;

grantor
	:	CURRENT_USER
	|	CURRENT_ROLE
	;

opt_nt_501
	:	/* Nothing */
	|	WITH ADMIN grantor ']'
	;

role_definition
	:	CREATE ROLE role_name opt_nt_501
	;

seq_nt_503
	:	comma role_granted
	;

lst_nt_504
	:	seq_nt_503
	|	lst_nt_504 seq_nt_503
	;

opt_nt_502
	:	/* Nothing */
	|	lst_nt_504
	;

seq_nt_506
	:	comma grantee
	;

lst_nt_507
	:	seq_nt_506
	|	lst_nt_507 seq_nt_506
	;

opt_nt_505
	:	/* Nothing */
	|	lst_nt_507
	;

opt_nt_508
	:	/* Nothing */
	|	WITH ADMIN OPTION
	;

opt_nt_509
	:	/* Nothing */
	|	GRANTED BY grantor ']'
	;

grant_role_statement
	:	GRANT role_granted opt_nt_502 TO grantee opt_nt_505 opt_nt_508 opt_nt_509
	;

role_granted
	:	role_name
	;

drop_role_statement
	:	DROP ROLE role_name
	;

revoke_statement
	:	revoke_privilege_statement
	|	revoke_role_statement
	;

opt_nt_510
	:	/* Nothing */
	|	revoke_option_extension
	;

seq_nt_512
	:	comma grantee
	;

lst_nt_513
	:	seq_nt_512
	|	lst_nt_513 seq_nt_512
	;

opt_nt_511
	:	/* Nothing */
	|	lst_nt_513
	;

opt_nt_514
	:	/* Nothing */
	|	GRANTED BY grantor
	;

revoke_privilege_statement
	:	REVOKE opt_nt_510 privileges FROM grantee opt_nt_511 opt_nt_514 drop_behavior
	;

revoke_option_extension
	:	GRANT OPTION FOR
	|	HIERARCHY OPTION FOR
	;

opt_nt_515
	:	/* Nothing */
	|	ADMIN OPTION FOR
	;

seq_nt_517
	:	comma role_revoked
	;

lst_nt_518
	:	seq_nt_517
	|	lst_nt_518 seq_nt_517
	;

opt_nt_516
	:	/* Nothing */
	|	lst_nt_518
	;

seq_nt_520
	:	comma grantee
	;

lst_nt_521
	:	seq_nt_520
	|	lst_nt_521 seq_nt_520
	;

opt_nt_519
	:	/* Nothing */
	|	lst_nt_521
	;

opt_nt_522
	:	/* Nothing */
	|	GRANTED BY grantor
	;

revoke_role_statement
	:	REVOKE opt_nt_515 role_revoked opt_nt_516 FROM grantee opt_nt_519 opt_nt_522 drop_behavior
	;

role_revoked
	:	role_name
	;

opt_nt_523
	:	/* Nothing */
	|	module_path_specification
	;

opt_nt_524
	:	/* Nothing */
	|	module_transform_group_specification
	;

opt_nt_525
	:	/* Nothing */
	|	module_collation
	;

lst_nt_527
	:	temporary_table_declaration
	|	lst_nt_527 temporary_table_declaration
	;

opt_nt_526
	:	/* Nothing */
	|	lst_nt_527
	;

lst_nt_528
	:	module_contents
	|	lst_nt_528 module_contents
	;

sql_client_module_definition
	:	module_name_clause language_clause module_authorization_clause opt_nt_523 opt_nt_524 opt_nt_525 opt_nt_526 lst_nt_528
	;

seq_nt_530
	:	ONLY
	|	AND DYNAMIC
	;

opt_nt_529
	:	/* Nothing */
	|	FOR STATIC seq_nt_530
	;

seq_nt_532
	:	ONLY
	|	AND DYNAMIC
	;

opt_nt_531
	:	/* Nothing */
	|	FOR STATIC seq_nt_532 ']'
	;

module_authorization_clause
	:	SCHEMA schema_name
	|	AUTHORIZATION module_authorization_identifier opt_nt_529
	|	SCHEMA schema_name AUTHORIZATION module_authorization_identifier opt_nt_531
	;

module_authorization_identifier
	:	authorization_identifier
	;

module_path_specification
	:	path_specification
	;

module_transform_group_specification
	:	transform_group_specification
	;

lst_nt_533
	:	module_collation_specification
	|	lst_nt_533 module_collation_specification
	;

module_collations
	:	lst_nt_533
	;

opt_nt_534
	:	/* Nothing */
	|	FOR character_set_specification_list ']'
	;

module_collation_specification
	:	COLLATION collation_name opt_nt_534
	;

seq_nt_536
	:	comma character_set_specification
	;

lst_nt_537
	:	seq_nt_536
	|	lst_nt_537 seq_nt_536
	;

opt_nt_535
	:	/* Nothing */
	|	lst_nt_537 ']'
	;

character_set_specification_list
	:	character_set_specification opt_nt_535
	;

module_contents
	:	declare_cursor
	|	dynamic_declare_cursor
	|	externally_invoked_procedure
	;

opt_nt_538
	:	/* Nothing */
	|	sql_client_module_name
	;

opt_nt_539
	:	/* Nothing */
	|	module_character_set_specification ']'
	;

module_name_clause
	:	MODULE opt_nt_538 opt_nt_539
	;

module_character_set_specification
	:	NAMES ARE character_set_specification
	;

externally_invoked_procedure
	:	PROCEDURE procedure_name host_parameter_declaration_list semicolon sql_procedure_statement semicolon
	;

seq_nt_541
	:	comma host_parameter_declaration
	;

lst_nt_542
	:	seq_nt_541
	|	lst_nt_542 seq_nt_541
	;

opt_nt_540
	:	/* Nothing */
	|	lst_nt_542
	;

host_parameter_declaration_list
	:	left_paren host_parameter_declaration opt_nt_540 right_paren
	;

host_parameter_declaration
	:	host_parameter_name host_parameter_data_type
	|	status_parameter
	;

opt_nt_543
	:	/* Nothing */
	|	locator_indication ']'
	;

host_parameter_data_type
	:	data_type opt_nt_543
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
	|	transliteration_definition
	|	assertion_definition
	|	trigger_definition
	|	user_defined_type_definition
	|	user_defined_cast_definition
	|	user_defined_ordering_definition
	|	transform_definition
	|	sequence_generator_definition
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
	|	drop_transliteration_statement
	|	drop_assertion_statement
	|	drop_trigger_statement
	|	alter_type_statement
	|	drop_data_type_statement
	|	drop_user_defined_ordering_statement
	|	alter_transform_statement
	|	drop_transform_statement
	|	alter_sequence_generator_statement
	|	drop_sequence_generator_statement
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

sql_data_change_statement
	:	delete_statement_positioned
	|	delete_statement_searched
	|	insert_statement
	|	update_statement_positioned
	|	update_statement_searched
	|	merge_statement
	;

sql_control_statement
	:	call_statement
	|	return_statement
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

sql_connection_statement
	:	connect_statement
	|	set_connection_statement
	|	disconnect_statement
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
	|	set_session_collation_statement
	;

sql_diagnostics_statement
	:	get_diagnostics_statement
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

sql_dynamic_data_statement
	:	allocate_cursor_statement
	|	dynamic_open_statement
	|	dynamic_fetch_statement
	|	dynamic_close_statement
	|	dynamic_delete_statement_positioned
	|	dynamic_update_statement_positioned
	;

system_descriptor_statement
	:	allocate_descriptor_statement
	|	deallocate_descriptor_statement
	|	set_descriptor_statement
	|	get_descriptor_statement
	;

opt_nt_544
	:	/* Nothing */
	|	cursor_sensitivity
	;

opt_nt_545
	:	/* Nothing */
	|	cursor_scrollability
	;

opt_nt_546
	:	/* Nothing */
	|	cursor_holdability
	;

opt_nt_547
	:	/* Nothing */
	|	cursor_returnability
	;

declare_cursor
	:	DECLARE cursor_name opt_nt_544 opt_nt_545 CURSOR opt_nt_546 opt_nt_547 FOR cursor_specification
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

opt_nt_548
	:	/* Nothing */
	|	order_by_clause
	;

opt_nt_549
	:	/* Nothing */
	|	updatability_clause ']'
	;

cursor_specification
	:	query_expression opt_nt_548 opt_nt_549
	;

opt_nt_551
	:	/* Nothing */
	|	OF column_name_list
	;

seq_nt_550
	:	READ ONLY
	|	UPDATE opt_nt_551 '}'
	;

updatability_clause
	:	FOR seq_nt_550
	;

order_by_clause
	:	ORDER BY sort_specification_list
	;

open_statement
	:	OPEN cursor_name
	;

opt_nt_553
	:	/* Nothing */
	|	fetch_orientation
	;

opt_nt_552
	:	/* Nothing */
	|	opt_nt_553 FROM
	;

fetch_statement
	:	FETCH opt_nt_552 cursor_name INTO fetch_target_list
	;

seq_nt_554
	:	ABSOLUTE
	|	RELATIVE
	;

fetch_orientation
	:	NEXT
	|	PRIOR
	|	FIRST
	|	LAST
	|	seq_nt_554 simple_value_specification
	;

seq_nt_556
	:	comma target_specification
	;

lst_nt_557
	:	seq_nt_556
	|	lst_nt_557 seq_nt_556
	;

opt_nt_555
	:	/* Nothing */
	|	lst_nt_557 ']'
	;

fetch_target_list
	:	target_specification opt_nt_555
	;

close_statement
	:	CLOSE cursor_name
	;

opt_nt_558
	:	/* Nothing */
	|	set_quantifier
	;

select_statement_single_row
	:	SELECT opt_nt_558 select_list INTO select_target_list table_expression
	;

seq_nt_560
	:	comma target_specification
	;

lst_nt_561
	:	seq_nt_560
	|	lst_nt_561 seq_nt_560
	;

opt_nt_559
	:	/* Nothing */
	|	lst_nt_561 ']'
	;

select_target_list
	:	target_specification opt_nt_559
	;

delete_statement_positioned
	:	DELETE FROM target_table WHERE CURRENT OF cursor_name
	;

target_table
	:	table_name
	|	ONLY left_paren table_name right_paren
	;

opt_nt_562
	:	/* Nothing */
	|	WHERE search_condition ']'
	;

delete_statement_searched
	:	DELETE FROM target_table opt_nt_562
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

opt_nt_563
	:	/* Nothing */
	|	left_paren insert_column_list right_paren
	;

opt_nt_564
	:	/* Nothing */
	|	override_clause
	;

from_subquery
	:	opt_nt_563 opt_nt_564 query_expression
	;

opt_nt_565
	:	/* Nothing */
	|	left_paren insert_column_list right_paren
	;

opt_nt_566
	:	/* Nothing */
	|	override_clause
	;

from_constructor
	:	opt_nt_565 opt_nt_566 contextually_typed_table_value_constructor
	;

override_clause
	:	OVERRIDING USER VALUE
	|	OVERRIDING SYSTEM VALUE
	;

from_default
	:	DEFAULT VALUES
	;

insert_column_list
	:	column_name_list
	;

opt_nt_568
	:	/* Nothing */
	|	AS
	;

opt_nt_567
	:	/* Nothing */
	|	opt_nt_568 merge_correlation_name
	;

merge_statement
	:	MERGE INTO target_table opt_nt_567 USING table_reference ON search_condition merge_operation_specification
	;

merge_correlation_name
	:	correlation_name
	;

lst_nt_569
	:	merge_when_clause
	|	lst_nt_569 merge_when_clause
	;

merge_operation_specification
	:	lst_nt_569
	;

merge_when_clause
	:	merge_when_matched_clause
	|	merge_when_not_matched_clause
	;

merge_when_matched_clause
	:	WHEN MATCHED THEN merge_update_specification
	;

merge_when_not_matched_clause
	:	WHEN NOT MATCHED THEN merge_insert_specification
	;

merge_update_specification
	:	UPDATE SET set_clause_list
	;

opt_nt_570
	:	/* Nothing */
	|	left_paren insert_column_list right_paren
	;

opt_nt_571
	:	/* Nothing */
	|	override_clause
	;

merge_insert_specification
	:	INSERT opt_nt_570 opt_nt_571 VALUES merge_insert_value_list
	;

seq_nt_573
	:	comma merge_insert_value_element
	;

lst_nt_574
	:	seq_nt_573
	|	lst_nt_574 seq_nt_573
	;

opt_nt_572
	:	/* Nothing */
	|	lst_nt_574
	;

merge_insert_value_list
	:	left_paren merge_insert_value_element opt_nt_572 right_paren
	;

merge_insert_value_element
	:	value_expression
	|	contextually_typed_value_specification
	;

update_statement_positioned
	:	UPDATE target_table SET set_clause_list WHERE CURRENT OF cursor_name
	;

opt_nt_575
	:	/* Nothing */
	|	WHERE search_condition ']'
	;

update_statement_searched
	:	UPDATE target_table SET set_clause_list opt_nt_575
	;

seq_nt_577
	:	comma set_clause
	;

lst_nt_578
	:	seq_nt_577
	|	lst_nt_578 seq_nt_577
	;

opt_nt_576
	:	/* Nothing */
	|	lst_nt_578 ']'
	;

set_clause_list
	:	set_clause opt_nt_576
	;

set_clause
	:	multiple_column_assignment
	|	set_target equals_operator update_source
	;

set_target
	:	update_target
	|	mutated_set_clause
	;

multiple_column_assignment
	:	set_target_list equals_operator assigned_row
	;

seq_nt_580
	:	comma set_target
	;

lst_nt_581
	:	seq_nt_580
	|	lst_nt_581 seq_nt_580
	;

opt_nt_579
	:	/* Nothing */
	|	lst_nt_581
	;

set_target_list
	:	left_paren set_target opt_nt_579 right_paren
	;

assigned_row
	:	contextually_typed_row_value_expression
	;

update_target
	:	object_column
	|	object_column left_bracket_or_trigraph simple_value_specification right_bracket_or_trigraph
	;

object_column
	:	column_name
	;

mutated_set_clause
	:	mutated_target period method_name
	;

mutated_target
	:	object_column
	|	mutated_set_clause
	;

update_source
	:	value_expression
	|	contextually_typed_value_specification
	;

opt_nt_582
	:	/* Nothing */
	|	ON COMMIT table_commit_action ROWS ']'
	;

temporary_table_declaration
	:	DECLARE LOCAL TEMPORARY TABLE table_name table_element_list opt_nt_582
	;

seq_nt_584
	:	comma locator_reference
	;

lst_nt_585
	:	seq_nt_584
	|	lst_nt_585 seq_nt_584
	;

opt_nt_583
	:	/* Nothing */
	|	lst_nt_585 ']'
	;

free_locator_statement
	:	FREE LOCATOR locator_reference opt_nt_583
	;

locator_reference
	:	host_parameter_name
	|	embedded_variable_name
	;

seq_nt_587
	:	comma locator_reference
	;

lst_nt_588
	:	seq_nt_587
	|	lst_nt_588 seq_nt_587
	;

opt_nt_586
	:	/* Nothing */
	|	lst_nt_588 ']'
	;

hold_locator_statement
	:	HOLD LOCATOR locator_reference opt_nt_586
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

seq_nt_591
	:	comma transaction_mode
	;

lst_nt_592
	:	seq_nt_591
	|	lst_nt_592 seq_nt_591
	;

opt_nt_590
	:	/* Nothing */
	|	lst_nt_592
	;

opt_nt_589
	:	/* Nothing */
	|	transaction_mode opt_nt_590 ']'
	;

start_transaction_statement
	:	START TRANSACTION opt_nt_589
	;

transaction_mode
	:	isolation_level
	|	transaction_access_mode
	|	diagnostics_size
	;

transaction_access_mode
	:	READ ONLY
	|	READ WRITE
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

diagnostics_size
	:	DIAGNOSTICS SIZE number_of_conditions
	;

number_of_conditions
	:	simple_value_specification
	;

opt_nt_593
	:	/* Nothing */
	|	LOCAL
	;

set_transaction_statement
	:	SET opt_nt_593 transaction_characteristics
	;

seq_nt_595
	:	comma transaction_mode
	;

lst_nt_596
	:	seq_nt_595
	|	lst_nt_596 seq_nt_595
	;

opt_nt_594
	:	/* Nothing */
	|	lst_nt_596 ']'
	;

transaction_characteristics
	:	TRANSACTION transaction_mode opt_nt_594
	;

seq_nt_597
	:	DEFERRED
	|	IMMEDIATE '}'
	;

set_constraints_mode_statement
	:	SET CONSTRAINTS constraint_name_list seq_nt_597
	;

seq_nt_599
	:	comma constraint_name
	;

lst_nt_600
	:	seq_nt_599
	|	lst_nt_600 seq_nt_599
	;

opt_nt_598
	:	/* Nothing */
	|	lst_nt_600 ']'
	;

constraint_name_list
	:	ALL
	|	constraint_name opt_nt_598
	;

savepoint_statement
	:	SAVEPOINT savepoint_specifier
	;

savepoint_specifier
	:	savepoint_name
	;

release_savepoint_statement
	:	RELEASE SAVEPOINT savepoint_specifier
	;

opt_nt_601
	:	/* Nothing */
	|	WORK
	;

opt_nt_603
	:	/* Nothing */
	|	NO
	;

opt_nt_602
	:	/* Nothing */
	|	AND opt_nt_603 CHAIN ']'
	;

commit_statement
	:	COMMIT opt_nt_601 opt_nt_602
	;

opt_nt_604
	:	/* Nothing */
	|	WORK
	;

opt_nt_606
	:	/* Nothing */
	|	NO
	;

opt_nt_605
	:	/* Nothing */
	|	AND opt_nt_606 CHAIN
	;

opt_nt_607
	:	/* Nothing */
	|	savepoint_clause ']'
	;

rollback_statement
	:	ROLLBACK opt_nt_604 opt_nt_605 opt_nt_607
	;

savepoint_clause
	:	TO SAVEPOINT savepoint_specifier
	;

connect_statement
	:	CONNECT TO connection_target
	;

opt_nt_608
	:	/* Nothing */
	|	AS connection_name
	;

opt_nt_609
	:	/* Nothing */
	|	USER connection_user_name
	;

connection_target
	:	sql_server_name opt_nt_608 opt_nt_609
	|	DEFAULT
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

set_session_characteristics_statement
	:	SET SESSION CHARACTERISTICS AS session_characteristic_list
	;

seq_nt_611
	:	comma session_characteristic
	;

lst_nt_612
	:	seq_nt_611
	|	lst_nt_612 seq_nt_611
	;

opt_nt_610
	:	/* Nothing */
	|	lst_nt_612 ']'
	;

session_characteristic_list
	:	session_characteristic opt_nt_610
	;

session_characteristic
	:	transaction_characteristics
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
	|	TRANSFORM GROUP FOR TYPE path_resolved_user_defined_type_name value_specification
	;

opt_nt_613
	:	/* Nothing */
	|	FOR character_set_specification_list
	;

opt_nt_614
	:	/* Nothing */
	|	FOR character_set_specification_list ']'
	;

set_session_collation_statement
	:	SET COLLATION collation_specification opt_nt_613
	|	SET NO COLLATION opt_nt_614
	;

opt_nt_615
	:	/* Nothing */
	|	
	;

character_set_specification_list
	:	character_set_specification opt_nt_615
	;

collation_specification
	:	value_specification
	;

opt_nt_616
	:	/* Nothing */
	|	SQL
	;

opt_nt_617
	:	/* Nothing */
	|	WITH MAX occurrences ']'
	;

allocate_descriptor_statement
	:	ALLOCATE opt_nt_616 DESCRIPTOR descriptor_name opt_nt_617
	;

occurrences
	:	simple_value_specification
	;

opt_nt_618
	:	/* Nothing */
	|	SQL
	;

deallocate_descriptor_statement
	:	DEALLOCATE opt_nt_618 DESCRIPTOR descriptor_name
	;

opt_nt_619
	:	/* Nothing */
	|	SQL
	;

get_descriptor_statement
	:	GET opt_nt_619 DESCRIPTOR descriptor_name get_descriptor_information
	;

seq_nt_621
	:	comma get_header_information
	;

lst_nt_622
	:	seq_nt_621
	|	lst_nt_622 seq_nt_621
	;

opt_nt_620
	:	/* Nothing */
	|	lst_nt_622
	;

seq_nt_624
	:	comma get_item_information
	;

lst_nt_625
	:	seq_nt_624
	|	lst_nt_625 seq_nt_624
	;

opt_nt_623
	:	/* Nothing */
	|	lst_nt_625 ']'
	;

get_descriptor_information
	:	get_header_information opt_nt_620
	|	VALUE item_number get_item_information opt_nt_623
	;

get_header_information
	:	simple_target_specification_1 equals_operator header_item_name
	;

header_item_name
	:	COUNT
	|	KEY_TYPE
	|	DYNAMIC_FUNCTION
	|	DYNAMIC_FUNCTION_CODE
	|	TOP_LEVEL_COUNT
	;

get_item_information
	:	simple_target_specification_2 equals_operator descriptor_item_name
	;

item_number
	:	simple_value_specification
	;

simple_target_specification_1
	:	simple_target_specification
	;

simple_target_specification_2
	:	simple_target_specification
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
	|	USER_DEFINED_TYPE_CODE
	;

opt_nt_626
	:	/* Nothing */
	|	SQL
	;

set_descriptor_statement
	:	SET opt_nt_626 DESCRIPTOR descriptor_name set_descriptor_information
	;

seq_nt_628
	:	comma set_header_information
	;

lst_nt_629
	:	seq_nt_628
	|	lst_nt_629 seq_nt_628
	;

opt_nt_627
	:	/* Nothing */
	|	lst_nt_629
	;

seq_nt_631
	:	comma set_item_information
	;

lst_nt_632
	:	seq_nt_631
	|	lst_nt_632 seq_nt_631
	;

opt_nt_630
	:	/* Nothing */
	|	lst_nt_632 ']'
	;

set_descriptor_information
	:	set_header_information opt_nt_627
	|	VALUE item_number set_item_information opt_nt_630
	;

set_header_information
	:	header_item_name equals_operator simple_value_specification_1
	;

set_item_information
	:	descriptor_item_name equals_operator simple_value_specification_2
	;

simple_value_specification_1
	:	simple_value_specification
	;

simple_value_specification_2
	:	simple_value_specification
	;

item_number
	:	simple_value_specification
	;

opt_nt_633
	:	/* Nothing */
	|	attributes_specification
	;

prepare_statement
	:	PREPARE sql_statement_name opt_nt_633 FROM sql_statement_variable
	;

attributes_specification
	:	ATTRIBUTES attributes_variable
	;

attributes_variable
	:	simple_value_specification
	;

sql_statement_variable
	:	simple_value_specification
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
	|	merge_statement
	|	preparable_dynamic_delete_statement_positioned
	|	preparable_dynamic_update_statement_positioned
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

dynamic_select_statement
	:	cursor_specification
	;

preparable_implementation_defined_statement
	:	/* !! See the Syntax Rules. */
	;

lst_nt_634
	:	cursor_attribute
	|	lst_nt_634 cursor_attribute
	;

cursor_attributes
	:	lst_nt_634
	;

cursor_attribute
	:	cursor_sensitivity
	|	cursor_scrollability
	|	cursor_holdability
	|	cursor_returnability
	;

deallocate_prepared_statement
	:	DEALLOCATE PREPARE sql_statement_name
	;

describe_statement
	:	describe_input_statement
	|	describe_output_statement
	;

opt_nt_635
	:	/* Nothing */
	|	nesting_option ']'
	;

describe_input_statement
	:	DESCRIBE INPUT sql_statement_name using_descriptor opt_nt_635
	;

opt_nt_636
	:	/* Nothing */
	|	OUTPUT
	;

describe_output_statement
	:	DESCRIBE opt_nt_636 described_object using_descriptor
	;

nesting_option
	:	WITH NESTING
	|	WITHOUT NESTING
	;

opt_nt_637
	:	/* Nothing */
	|	SQL
	;

using_descriptor
	:	USING opt_nt_637 DESCRIPTOR descriptor_name
	;

described_object
	:	sql_statement_name
	|	CURSOR extended_cursor_name STRUCTURE
	;

input_using_clause
	:	using_arguments
	|	using_input_descriptor
	;

seq_nt_639
	:	comma using_argument
	;

lst_nt_640
	:	seq_nt_639
	|	lst_nt_640 seq_nt_639
	;

opt_nt_638
	:	/* Nothing */
	|	lst_nt_640 ']'
	;

using_arguments
	:	USING using_argument opt_nt_638
	;

using_argument
	:	general_value_specification
	;

using_input_descriptor
	:	using_descriptor
	;

output_using_clause
	:	into_arguments
	|	into_descriptor
	;

seq_nt_642
	:	comma into_argument
	;

lst_nt_643
	:	seq_nt_642
	|	lst_nt_643 seq_nt_642
	;

opt_nt_641
	:	/* Nothing */
	|	lst_nt_643 ']'
	;

into_arguments
	:	INTO into_argument opt_nt_641
	;

into_argument
	:	target_specification
	;

opt_nt_644
	:	/* Nothing */
	|	SQL
	;

into_descriptor
	:	INTO opt_nt_644 DESCRIPTOR descriptor_name
	;

opt_nt_645
	:	/* Nothing */
	|	result_using_clause
	;

opt_nt_646
	:	/* Nothing */
	|	parameter_using_clause ']'
	;

execute_statement
	:	EXECUTE sql_statement_name opt_nt_645 opt_nt_646
	;

result_using_clause
	:	output_using_clause
	;

parameter_using_clause
	:	input_using_clause
	;

execute_immediate_statement
	:	EXECUTE IMMEDIATE sql_statement_variable
	;

opt_nt_647
	:	/* Nothing */
	|	cursor_sensitivity
	;

opt_nt_648
	:	/* Nothing */
	|	cursor_scrollability
	;

opt_nt_649
	:	/* Nothing */
	|	cursor_holdability
	;

opt_nt_650
	:	/* Nothing */
	|	cursor_returnability
	;

dynamic_declare_cursor
	:	DECLARE cursor_name opt_nt_647 opt_nt_648 CURSOR opt_nt_649 opt_nt_650 FOR statement_name
	;

allocate_cursor_statement
	:	ALLOCATE extended_cursor_name cursor_intent
	;

cursor_intent
	:	statement_cursor
	|	result_set_cursor
	;

opt_nt_651
	:	/* Nothing */
	|	cursor_sensitivity
	;

opt_nt_652
	:	/* Nothing */
	|	cursor_scrollability
	;

opt_nt_653
	:	/* Nothing */
	|	cursor_holdability
	;

opt_nt_654
	:	/* Nothing */
	|	cursor_returnability
	;

statement_cursor
	:	opt_nt_651 opt_nt_652 CURSOR opt_nt_653 opt_nt_654 FOR extended_statement_name
	;

result_set_cursor
	:	FOR PROCEDURE specific_routine_designator
	;

opt_nt_655
	:	/* Nothing */
	|	input_using_clause ']'
	;

dynamic_open_statement
	:	OPEN dynamic_cursor_name opt_nt_655
	;

opt_nt_657
	:	/* Nothing */
	|	fetch_orientation
	;

opt_nt_656
	:	/* Nothing */
	|	opt_nt_657 FROM
	;

dynamic_fetch_statement
	:	FETCH opt_nt_656 dynamic_cursor_name output_using_clause
	;

dynamic_single_row_select_statement
	:	query_specification
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

opt_nt_658
	:	/* Nothing */
	|	FROM target_table
	;

opt_nt_659
	:	/* Nothing */
	|	scope_option
	;

preparable_dynamic_delete_statement_positioned
	:	DELETE opt_nt_658 WHERE CURRENT OF opt_nt_659 cursor_name
	;

opt_nt_660
	:	/* Nothing */
	|	target_table
	;

opt_nt_661
	:	/* Nothing */
	|	scope_option
	;

preparable_dynamic_update_statement_positioned
	:	UPDATE opt_nt_660 SET set_clause_list WHERE CURRENT OF opt_nt_661 cursor_name
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

opt_nt_662
	:	/* Nothing */
	|	sql_terminator ']'
	;

embedded_sql_statement
	:	sql_prefix statement_or_declaration opt_nt_662
	;

statement_or_declaration
	:	declare_cursor
	|	dynamic_declare_cursor
	|	temporary_table_declaration
	|	embedded_authorization_declaration
	|	embedded_path_specification
	|	embedded_transform_group_specification
	|	embedded_collation_specification
	|	embedded_exception_declaration
	|	handler_declaration
	|	sql_procedure_statement
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

embedded_authorization_declaration
	:	DECLARE embedded_authorization_clause
	;

seq_nt_664
	:	ONLY
	|	AND DYNAMIC
	;

opt_nt_663
	:	/* Nothing */
	|	FOR STATIC seq_nt_664
	;

seq_nt_666
	:	ONLY
	|	AND DYNAMIC
	;

opt_nt_665
	:	/* Nothing */
	|	FOR STATIC seq_nt_666 ']'
	;

embedded_authorization_clause
	:	SCHEMA schema_name
	|	AUTHORIZATION embedded_authorization_identifier opt_nt_663
	|	SCHEMA schema_name AUTHORIZATION embedded_authorization_identifier opt_nt_665
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

embedded_collation_specification
	:	module_collations
	;

opt_nt_667
	:	/* Nothing */
	|	embedded_character_set_declaration
	;

lst_nt_669
	:	host_variable_definition
	|	lst_nt_669 host_variable_definition
	;

opt_nt_668
	:	/* Nothing */
	|	lst_nt_669
	;

embedded_sql_declare_section
	:	embedded_sql_begin_declare opt_nt_667 opt_nt_668 embedded_sql_end_declare
	|	embedded_sql_mumps_declare
	;

embedded_character_set_declaration
	:	SQL NAMES ARE character_set_specification
	;

opt_nt_670
	:	/* Nothing */
	|	sql_terminator ']'
	;

embedded_sql_begin_declare
	:	sql_prefix BEGIN DECLARE SECTION opt_nt_670
	;

opt_nt_671
	:	/* Nothing */
	|	sql_terminator ']'
	;

embedded_sql_end_declare
	:	sql_prefix END DECLARE SECTION opt_nt_671
	;

opt_nt_672
	:	/* Nothing */
	|	embedded_character_set_declaration
	;

lst_nt_673
	:	host_variable_definition
	|	lst_nt_673 host_variable_definition
	;

embedded_sql_mumps_declare
	:	sql_prefix BEGIN DECLARE SECTION opt_nt_672 lst_nt_673 END DECLARE SECTION sql_terminator
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

embedded_exception_declaration
	:	WHENEVER condition condition_action
	;

condition
	:	sql_condition
	;

sql_condition
	:	major_category
	|	SQLSTATE
	;

major_category
	:	SQLEXCEPTION
	|	SQLWARNING
	|	NOT FOUND
	;

sqlstate_class_value
	:	sqlstate_char sqlstate_char /* !! See the Syntax Rules. */
	;

sqlstate_subclass_value
	:	sqlstate_char sqlstate_char sqlstate_char /* !! See the Syntax Rules. */
	;

sqlstate_char
	:	simple_latin_upper_case_letter
	|	digit
	;

condition_action
	:	CONTINUE
	|	go_to
	;

seq_nt_674
	:	GOTO
	|	GO TO
	;

go_to
	:	seq_nt_674 goto_target
	;

goto_target
	:	host_label_identifier
	|	unsigned_integer
	|	host_pl_i_label_variable
	;

host_label_identifier
	:	/* !! See the Syntax Rules. */
	;

host_pl_i_label_variable
	:	/* !! See the Syntax Rules. */
	;

embedded_sql_ada_program
	:	/* !! See the Syntax Rules. */
	;

seq_nt_676
	:	comma ada_host_identifier
	;

lst_nt_677
	:	seq_nt_676
	|	lst_nt_677 seq_nt_676
	;

opt_nt_675
	:	/* Nothing */
	|	lst_nt_677
	;

opt_nt_678
	:	/* Nothing */
	|	ada_initial_value ']'
	;

ada_variable_definition
	:	ada_host_identifier opt_nt_675 colon ada_type_specification opt_nt_678
	;

lst_nt_679
	:	character_representation
	|	lst_nt_679 character_representation
	;

ada_initial_value
	:	ada_assignment_operator lst_nt_679
	;

ada_assignment_operator
	:	colon equals_operator
	;

ada_host_identifier
	:	/* !! See the Syntax Rules. */
	;

ada_type_specification
	:	ada_qualified_type_specification
	|	ada_unqualified_type_specification
	|	ada_derived_type_specification
	;

opt_nt_681
	:	/* Nothing */
	|	IS
	;

opt_nt_680
	:	/* Nothing */
	|	CHARACTER SET opt_nt_681 character_set_specification
	;

ada_qualified_type_specification
	:	Interfaces.SQL period CHAR opt_nt_680 left_paren 1 double_period length right_paren
	|	Interfaces.SQL period SMALLINT
	|	Interfaces.SQL period INT
	|	Interfaces.SQL period BIGINT
	|	Interfaces.SQL period REAL
	|	Interfaces.SQL period DOUBLE_PRECISION
	|	Interfaces.SQL period BOOLEAN
	|	Interfaces.SQL period SQLSTATE_TYPE
	|	Interfaces.SQL period INDICATOR_TYPE
	;

ada_unqualified_type_specification
	:	CHAR left_paren 1 double_period length right_paren
	|	SMALLINT
	|	INT
	|	BIGINT
	|	REAL
	|	DOUBLE_PRECISION
	|	BOOLEAN
	|	SQLSTATE_TYPE
	|	INDICATOR_TYPE
	;

ada_derived_type_specification
	:	ada_clob_variable
	|	ada_clob_locator_variable
	|	ada_blob_variable
	|	ada_blob_locator_variable
	|	ada_user_defined_type_variable
	|	ada_user_defined_type_locator_variable
	|	ada_ref_variable
	|	ada_array_locator_variable
	|	ada_multiset_locator_variable
	;

opt_nt_683
	:	/* Nothing */
	|	IS
	;

opt_nt_682
	:	/* Nothing */
	|	CHARACTER SET opt_nt_683 character_set_specification ']'
	;

ada_clob_variable
	:	SQL TYPE IS CLOB left_paren large_object_length right_paren opt_nt_682
	;

ada_clob_locator_variable
	:	SQL TYPE IS CLOB AS LOCATOR
	;

ada_blob_variable
	:	SQL TYPE IS BLOB left_paren large_object_length right_paren
	;

ada_blob_locator_variable
	:	SQL TYPE IS BLOB AS LOCATOR
	;

ada_user_defined_type_variable
	:	SQL TYPE IS path_resolved_user_defined_type_name AS predefined_type
	;

ada_user_defined_type_locator_variable
	:	SQL TYPE IS path_resolved_user_defined_type_name AS LOCATOR
	;

ada_ref_variable
	:	SQL TYPE IS reference_type
	;

ada_array_locator_variable
	:	SQL TYPE IS array_type AS LOCATOR
	;

ada_multiset_locator_variable
	:	SQL TYPE IS multiset_type AS LOCATOR
	;

embedded_sql_c_program
	:	/* !! See the Syntax Rules. */
	;

opt_nt_684
	:	/* Nothing */
	|	c_storage_class
	;

opt_nt_685
	:	/* Nothing */
	|	c_class_modifier
	;

c_variable_definition
	:	opt_nt_684 opt_nt_685 c_variable_specification semicolon
	;

c_variable_specification
	:	c_numeric_variable
	|	c_character_variable
	|	c_derived_variable
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

seq_nt_686
	:	long long
	|	long
	|	short
	|	float
	|	double
	;

opt_nt_687
	:	/* Nothing */
	|	c_initial_value
	;

opt_nt_690
	:	/* Nothing */
	|	c_initial_value
	;

seq_nt_689
	:	comma c_host_identifier opt_nt_690
	;

lst_nt_691
	:	seq_nt_689
	|	lst_nt_691 seq_nt_689
	;

opt_nt_688
	:	/* Nothing */
	|	lst_nt_691 ']'
	;

c_numeric_variable
	:	seq_nt_686 c_host_identifier opt_nt_687 opt_nt_688
	;

opt_nt_693
	:	/* Nothing */
	|	IS
	;

opt_nt_692
	:	/* Nothing */
	|	CHARACTER SET opt_nt_693 character_set_specification
	;

opt_nt_694
	:	/* Nothing */
	|	c_initial_value
	;

opt_nt_697
	:	/* Nothing */
	|	c_initial_value
	;

seq_nt_696
	:	comma c_host_identifier c_array_specification opt_nt_697
	;

lst_nt_698
	:	seq_nt_696
	|	lst_nt_698 seq_nt_696
	;

opt_nt_695
	:	/* Nothing */
	|	lst_nt_698 ']'
	;

c_character_variable
	:	c_character_type opt_nt_692 c_host_identifier c_array_specification opt_nt_694 opt_nt_695
	;

c_character_type
	:	char
	|	unsigned char
	|	unsigned short
	;

c_array_specification
	:	left_bracket length right_bracket
	;

c_host_identifier
	:	/* !! See the Syntax Rules. */
	;

c_derived_variable
	:	c_varchar_variable
	|	c_nchar_variable
	|	c_nchar_varying_variable
	|	c_clob_variable
	|	c_nclob_variable
	|	c_blob_variable
	|	c_user_defined_type_variable
	|	c_clob_locator_variable
	|	c_blob_locator_variable
	|	c_array_locator_variable
	|	c_multiset_locator_variable
	|	c_user_defined_type_locator_variable
	|	c_ref_variable
	;

opt_nt_700
	:	/* Nothing */
	|	IS
	;

opt_nt_699
	:	/* Nothing */
	|	CHARACTER SET opt_nt_700 character_set_specification
	;

opt_nt_701
	:	/* Nothing */
	|	c_initial_value
	;

opt_nt_704
	:	/* Nothing */
	|	c_initial_value
	;

seq_nt_703
	:	comma c_host_identifier c_array_specification opt_nt_704
	;

lst_nt_705
	:	seq_nt_703
	|	lst_nt_705 seq_nt_703
	;

opt_nt_702
	:	/* Nothing */
	|	lst_nt_705 ']'
	;

c_varchar_variable
	:	VARCHAR opt_nt_699 c_host_identifier c_array_specification opt_nt_701 opt_nt_702
	;

opt_nt_707
	:	/* Nothing */
	|	IS
	;

opt_nt_706
	:	/* Nothing */
	|	CHARACTER SET opt_nt_707 character_set_specification
	;

opt_nt_708
	:	/* Nothing */
	|	c_initial_value
	;

opt_nt_711
	:	/* Nothing */
	|	c_initial_value
	;

seq_nt_710
	:	comma c_host_identifier c_array_specification opt_nt_711
	;

lst_nt_712
	:	seq_nt_710
	|	lst_nt_712 seq_nt_710
	;

opt_nt_709
	:	/* Nothing */
	|	lst_nt_712 ']'
	;

c_nchar_variable
	:	NCHAR opt_nt_706 c_host_identifier c_array_specification opt_nt_708 opt_nt_709
	;

opt_nt_714
	:	/* Nothing */
	|	IS
	;

opt_nt_713
	:	/* Nothing */
	|	CHARACTER SET opt_nt_714 character_set_specification
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
	:	comma c_host_identifier c_array_specification opt_nt_718
	;

lst_nt_719
	:	seq_nt_717
	|	lst_nt_719 seq_nt_717
	;

opt_nt_716
	:	/* Nothing */
	|	lst_nt_719 ']'
	;

c_nchar_varying_variable
	:	NCHAR VARYING opt_nt_713 c_host_identifier c_array_specification opt_nt_715 opt_nt_716
	;

opt_nt_721
	:	/* Nothing */
	|	IS
	;

opt_nt_720
	:	/* Nothing */
	|	CHARACTER SET opt_nt_721 character_set_specification
	;

opt_nt_722
	:	/* Nothing */
	|	c_initial_value
	;

opt_nt_725
	:	/* Nothing */
	|	c_initial_value
	;

seq_nt_724
	:	comma c_host_identifier opt_nt_725
	;

lst_nt_726
	:	seq_nt_724
	|	lst_nt_726 seq_nt_724
	;

opt_nt_723
	:	/* Nothing */
	|	lst_nt_726 ']'
	;

c_clob_variable
	:	SQL TYPE IS CLOB left_paren large_object_length right_paren opt_nt_720 c_host_identifier opt_nt_722 opt_nt_723
	;

opt_nt_728
	:	/* Nothing */
	|	IS
	;

opt_nt_727
	:	/* Nothing */
	|	CHARACTER SET opt_nt_728 character_set_specification
	;

opt_nt_729
	:	/* Nothing */
	|	c_initial_value
	;

opt_nt_732
	:	/* Nothing */
	|	c_initial_value
	;

seq_nt_731
	:	comma c_host_identifier opt_nt_732
	;

lst_nt_733
	:	seq_nt_731
	|	lst_nt_733 seq_nt_731
	;

opt_nt_730
	:	/* Nothing */
	|	lst_nt_733 ']'
	;

c_nclob_variable
	:	SQL TYPE IS NCLOB left_paren large_object_length right_paren opt_nt_727 c_host_identifier opt_nt_729 opt_nt_730
	;

opt_nt_734
	:	/* Nothing */
	|	c_initial_value
	;

opt_nt_737
	:	/* Nothing */
	|	c_initial_value
	;

seq_nt_736
	:	comma c_host_identifier opt_nt_737
	;

lst_nt_738
	:	seq_nt_736
	|	lst_nt_738 seq_nt_736
	;

opt_nt_735
	:	/* Nothing */
	|	lst_nt_738 ']'
	;

c_user_defined_type_variable
	:	SQL TYPE IS path_resolved_user_defined_type_name AS predefined_type c_host_identifier opt_nt_734 opt_nt_735
	;

opt_nt_739
	:	/* Nothing */
	|	c_initial_value
	;

opt_nt_742
	:	/* Nothing */
	|	c_initial_value
	;

seq_nt_741
	:	comma c_host_identifier opt_nt_742
	;

lst_nt_743
	:	seq_nt_741
	|	lst_nt_743 seq_nt_741
	;

opt_nt_740
	:	/* Nothing */
	|	lst_nt_743 ']'
	;

c_blob_variable
	:	SQL TYPE IS BLOB left_paren large_object_length right_paren c_host_identifier opt_nt_739 opt_nt_740
	;

opt_nt_744
	:	/* Nothing */
	|	c_initial_value
	;

opt_nt_747
	:	/* Nothing */
	|	c_initial_value
	;

seq_nt_746
	:	comma c_host_identifier opt_nt_747
	;

lst_nt_748
	:	seq_nt_746
	|	lst_nt_748 seq_nt_746
	;

opt_nt_745
	:	/* Nothing */
	|	lst_nt_748 ']'
	;

c_clob_locator_variable
	:	SQL TYPE IS CLOB AS LOCATOR c_host_identifier opt_nt_744 opt_nt_745
	;

opt_nt_749
	:	/* Nothing */
	|	c_initial_value
	;

opt_nt_752
	:	/* Nothing */
	|	c_initial_value
	;

seq_nt_751
	:	comma c_host_identifier opt_nt_752
	;

lst_nt_753
	:	seq_nt_751
	|	lst_nt_753 seq_nt_751
	;

opt_nt_750
	:	/* Nothing */
	|	lst_nt_753 ']'
	;

c_blob_locator_variable
	:	SQL TYPE IS BLOB AS LOCATOR c_host_identifier opt_nt_749 opt_nt_750
	;

opt_nt_754
	:	/* Nothing */
	|	c_initial_value
	;

opt_nt_757
	:	/* Nothing */
	|	c_initial_value
	;

seq_nt_756
	:	comma c_host_identifier opt_nt_757
	;

lst_nt_758
	:	seq_nt_756
	|	lst_nt_758 seq_nt_756
	;

opt_nt_755
	:	/* Nothing */
	|	lst_nt_758 ']'
	;

c_array_locator_variable
	:	SQL TYPE IS array_type AS LOCATOR c_host_identifier opt_nt_754 opt_nt_755
	;

opt_nt_759
	:	/* Nothing */
	|	c_initial_value
	;

opt_nt_762
	:	/* Nothing */
	|	c_initial_value
	;

seq_nt_761
	:	comma c_host_identifier opt_nt_762
	;

lst_nt_763
	:	seq_nt_761
	|	lst_nt_763 seq_nt_761
	;

opt_nt_760
	:	/* Nothing */
	|	lst_nt_763 ']'
	;

c_multiset_locator_variable
	:	SQL TYPE IS multiset_type AS LOCATOR c_host_identifier opt_nt_759 opt_nt_760
	;

opt_nt_764
	:	/* Nothing */
	|	c_initial_value
	;

opt_nt_767
	:	/* Nothing */
	|	c_initial_value
	;

seq_nt_766
	:	comma c_host_identifier opt_nt_767
	;

lst_nt_768
	:	seq_nt_766
	|	lst_nt_768 seq_nt_766
	;

opt_nt_765
	:	/* Nothing */
	|	lst_nt_768 ']'
	;

c_user_defined_type_locator_variable
	:	SQL TYPE IS path_resolved_user_defined_type_name AS LOCATOR c_host_identifier opt_nt_764 opt_nt_765
	;

c_ref_variable
	:	SQL TYPE IS reference_type
	;

lst_nt_769
	:	character_representation
	|	lst_nt_769 character_representation
	;

c_initial_value
	:	equals_operator lst_nt_769
	;

embedded_sql_cobol_program
	:	/* !! See the Syntax Rules. */
	;

seq_nt_770
	:	01
	|	77
	;

lst_nt_772
	:	character_representation
	|	lst_nt_772 character_representation
	;

opt_nt_771
	:	/* Nothing */
	|	lst_nt_772
	;

cobol_variable_definition
	:	seq_nt_770 cobol_host_identifier cobol_type_specification opt_nt_771 period
	;

cobol_host_identifier
	:	/* !! See the Syntax Rules. */
	;

cobol_type_specification
	:	cobol_character_type
	|	cobol_national_character_type
	|	cobol_numeric_type
	|	cobol_integer_type
	|	cobol_derived_type_specification
	;

cobol_derived_type_specification
	:	cobol_clob_variable
	|	cobol_nclob_variable
	|	cobol_blob_variable
	|	cobol_user_defined_type_variable
	|	cobol_clob_locator_variable
	|	cobol_blob_locator_variable
	|	cobol_array_locator_variable
	|	cobol_multiset_locator_variable
	|	cobol_user_defined_type_locator_variable
	|	cobol_ref_variable
	;

opt_nt_774
	:	/* Nothing */
	|	IS
	;

opt_nt_773
	:	/* Nothing */
	|	CHARACTER SET opt_nt_774 character_set_specification
	;

seq_nt_775
	:	PIC
	|	PICTURE
	;

opt_nt_776
	:	/* Nothing */
	|	IS
	;

opt_nt_778
	:	/* Nothing */
	|	left_paren length right_paren
	;

seq_nt_777
	:	X opt_nt_778
	;

lst_nt_779
	:	seq_nt_777
	|	lst_nt_779 seq_nt_777
	;

cobol_character_type
	:	opt_nt_773 seq_nt_775 opt_nt_776 lst_nt_779
	;

opt_nt_781
	:	/* Nothing */
	|	IS
	;

opt_nt_780
	:	/* Nothing */
	|	CHARACTER SET opt_nt_781 character_set_specification
	;

seq_nt_782
	:	PIC
	|	PICTURE
	;

opt_nt_783
	:	/* Nothing */
	|	IS
	;

opt_nt_785
	:	/* Nothing */
	|	left_paren length right_paren
	;

seq_nt_784
	:	N opt_nt_785
	;

lst_nt_786
	:	seq_nt_784
	|	lst_nt_786 seq_nt_784
	;

cobol_national_character_type
	:	opt_nt_780 seq_nt_782 opt_nt_783 lst_nt_786
	;

opt_nt_788
	:	/* Nothing */
	|	IS
	;

opt_nt_787
	:	/* Nothing */
	|	USAGE opt_nt_788
	;

opt_nt_790
	:	/* Nothing */
	|	IS
	;

opt_nt_789
	:	/* Nothing */
	|	CHARACTER SET opt_nt_790 character_set_specification ']'
	;

cobol_clob_variable
	:	opt_nt_787 SQL TYPE IS CLOB left_paren large_object_length right_paren opt_nt_789
	;

opt_nt_792
	:	/* Nothing */
	|	IS
	;

opt_nt_791
	:	/* Nothing */
	|	USAGE opt_nt_792
	;

opt_nt_794
	:	/* Nothing */
	|	IS
	;

opt_nt_793
	:	/* Nothing */
	|	CHARACTER SET opt_nt_794 character_set_specification ']'
	;

cobol_nclob_variable
	:	opt_nt_791 SQL TYPE IS NCLOB left_paren large_object_length right_paren opt_nt_793
	;

opt_nt_796
	:	/* Nothing */
	|	IS
	;

opt_nt_795
	:	/* Nothing */
	|	USAGE opt_nt_796
	;

cobol_blob_variable
	:	opt_nt_795 SQL TYPE IS BLOB left_paren large_object_length right_paren
	;

opt_nt_798
	:	/* Nothing */
	|	IS
	;

opt_nt_797
	:	/* Nothing */
	|	USAGE opt_nt_798
	;

cobol_user_defined_type_variable
	:	opt_nt_797 SQL TYPE IS path_resolved_user_defined_type_name AS predefined_type
	;

opt_nt_800
	:	/* Nothing */
	|	IS
	;

opt_nt_799
	:	/* Nothing */
	|	USAGE opt_nt_800
	;

cobol_clob_locator_variable
	:	opt_nt_799 SQL TYPE IS CLOB AS LOCATOR
	;

opt_nt_802
	:	/* Nothing */
	|	IS
	;

opt_nt_801
	:	/* Nothing */
	|	USAGE opt_nt_802
	;

cobol_blob_locator_variable
	:	opt_nt_801 SQL TYPE IS BLOB AS LOCATOR
	;

opt_nt_804
	:	/* Nothing */
	|	IS
	;

opt_nt_803
	:	/* Nothing */
	|	USAGE opt_nt_804
	;

cobol_array_locator_variable
	:	opt_nt_803 SQL TYPE IS array_type AS LOCATOR
	;

opt_nt_806
	:	/* Nothing */
	|	IS
	;

opt_nt_805
	:	/* Nothing */
	|	USAGE opt_nt_806
	;

cobol_multiset_locator_variable
	:	opt_nt_805 SQL TYPE IS multiset_type AS LOCATOR
	;

opt_nt_808
	:	/* Nothing */
	|	IS
	;

opt_nt_807
	:	/* Nothing */
	|	USAGE opt_nt_808
	;

cobol_user_defined_type_locator_variable
	:	opt_nt_807 SQL TYPE IS path_resolved_user_defined_type_name AS LOCATOR
	;

opt_nt_810
	:	/* Nothing */
	|	IS
	;

opt_nt_809
	:	/* Nothing */
	|	USAGE opt_nt_810
	;

cobol_ref_variable
	:	opt_nt_809 SQL TYPE IS reference_type
	;

seq_nt_811
	:	PIC
	|	PICTURE
	;

opt_nt_812
	:	/* Nothing */
	|	IS
	;

opt_nt_814
	:	/* Nothing */
	|	IS
	;

opt_nt_813
	:	/* Nothing */
	|	USAGE opt_nt_814
	;

cobol_numeric_type
	:	seq_nt_811 opt_nt_812 S cobol_nines_specification opt_nt_813 DISPLAY SIGN LEADING SEPARATE
	;

opt_nt_816
	:	/* Nothing */
	|	cobol_nines
	;

opt_nt_815
	:	/* Nothing */
	|	V opt_nt_816
	;

cobol_nines_specification
	:	cobol_nines opt_nt_815
	|	V cobol_nines
	;

cobol_integer_type
	:	cobol_binary_integer
	;

seq_nt_817
	:	PIC
	|	PICTURE
	;

opt_nt_818
	:	/* Nothing */
	|	IS
	;

opt_nt_820
	:	/* Nothing */
	|	IS
	;

opt_nt_819
	:	/* Nothing */
	|	USAGE opt_nt_820
	;

cobol_binary_integer
	:	seq_nt_817 opt_nt_818 S cobol_nines opt_nt_819 BINARY
	;

opt_nt_822
	:	/* Nothing */
	|	left_paren length right_paren
	;

seq_nt_821
	:	9 opt_nt_822
	;

lst_nt_823
	:	seq_nt_821
	|	lst_nt_823 seq_nt_821
	;

cobol_nines
	:	lst_nt_823
	;

embedded_sql_fortran_program
	:	/* !! See the Syntax Rules. */
	;

seq_nt_825
	:	comma fortran_host_identifier
	;

lst_nt_826
	:	seq_nt_825
	|	lst_nt_826 seq_nt_825
	;

opt_nt_824
	:	/* Nothing */
	|	lst_nt_826 ']'
	;

fortran_variable_definition
	:	fortran_type_specification fortran_host_identifier opt_nt_824
	;

fortran_host_identifier
	:	/* !! See the Syntax Rules. */
	;

opt_nt_827
	:	/* Nothing */
	|	asterisk length
	;

opt_nt_829
	:	/* Nothing */
	|	IS
	;

opt_nt_828
	:	/* Nothing */
	|	CHARACTER SET opt_nt_829 character_set_specification
	;

fortran_type_specification
	:	CHARACTER opt_nt_827 opt_nt_828
	|	CHARACTER KIND
	;

fortran_derived_type_specification
	:	fortran_clob_variable
	|	fortran_blob_variable
	|	fortran_user_defined_type_variable
	|	fortran_clob_locator_variable
	|	fortran_blob_locator_variable
	|	fortran_user_defined_type_locator_variable
	|	fortran_array_locator_variable
	|	fortran_multiset_locator_variable
	|	fortran_ref_variable
	;

opt_nt_831
	:	/* Nothing */
	|	IS
	;

opt_nt_830
	:	/* Nothing */
	|	CHARACTER SET opt_nt_831 character_set_specification ']'
	;

fortran_clob_variable
	:	SQL TYPE IS CLOB left_paren large_object_length right_paren opt_nt_830
	;

fortran_blob_variable
	:	SQL TYPE IS BLOB left_paren large_object_length right_paren
	;

fortran_user_defined_type_variable
	:	SQL TYPE IS path_resolved_user_defined_type_name AS predefined_type
	;

fortran_clob_locator_variable
	:	SQL TYPE IS CLOB AS LOCATOR
	;

fortran_blob_locator_variable
	:	SQL TYPE IS BLOB AS LOCATOR
	;

fortran_user_defined_type_locator_variable
	:	SQL TYPE IS path_resolved_user_defined_type_name AS LOCATOR
	;

fortran_array_locator_variable
	:	SQL TYPE IS array_type AS LOCATOR
	;

fortran_multiset_locator_variable
	:	SQL TYPE IS multiset_type AS LOCATOR
	;

fortran_ref_variable
	:	SQL TYPE IS reference_type
	;

embedded_sql_mumps_program
	:	/* !! See the Syntax Rules. */
	;

mumps_variable_definition
	:	mumps_numeric_variable semicolon
	|	mumps_character_variable semicolon
	|	mumps_derived_type_specification semicolon
	;

seq_nt_833
	:	comma mumps_host_identifier mumps_length_specification
	;

lst_nt_834
	:	seq_nt_833
	|	lst_nt_834 seq_nt_833
	;

opt_nt_832
	:	/* Nothing */
	|	lst_nt_834 ']'
	;

mumps_character_variable
	:	VARCHAR mumps_host_identifier mumps_length_specification opt_nt_832
	;

mumps_host_identifier
	:	/* !! See the Syntax Rules. */
	;

mumps_length_specification
	:	left_paren length right_paren
	;

seq_nt_836
	:	comma mumps_host_identifier
	;

lst_nt_837
	:	seq_nt_836
	|	lst_nt_837 seq_nt_836
	;

opt_nt_835
	:	/* Nothing */
	|	lst_nt_837 ']'
	;

mumps_numeric_variable
	:	mumps_type_specification mumps_host_identifier opt_nt_835
	;

opt_nt_839
	:	/* Nothing */
	|	comma scale
	;

opt_nt_838
	:	/* Nothing */
	|	left_paren precision opt_nt_839 right_paren
	;

mumps_type_specification
	:	INT
	|	DEC opt_nt_838
	|	REAL
	;

mumps_derived_type_specification
	:	mumps_clob_variable
	|	mumps_blob_variable
	|	mumps_user_defined_type_variable
	|	mumps_clob_locator_variable
	|	mumps_blob_locator_variable
	|	mumps_user_defined_type_locator_variable
	|	mumps_array_locator_variable
	|	mumps_multiset_locator_variable
	|	mumps_ref_variable
	;

opt_nt_841
	:	/* Nothing */
	|	IS
	;

opt_nt_840
	:	/* Nothing */
	|	CHARACTER SET opt_nt_841 character_set_specification ']'
	;

mumps_clob_variable
	:	SQL TYPE IS CLOB left_paren large_object_length right_paren opt_nt_840
	;

mumps_blob_variable
	:	SQL TYPE IS BLOB left_paren large_object_length right_paren
	;

mumps_user_defined_type_variable
	:	SQL TYPE IS path_resolved_user_defined_type_name AS predefined_type
	;

mumps_clob_locator_variable
	:	SQL TYPE IS CLOB AS LOCATOR
	;

mumps_blob_locator_variable
	:	SQL TYPE IS BLOB AS LOCATOR
	;

mumps_user_defined_type_locator_variable
	:	SQL TYPE IS path_resolved_user_defined_type_name AS LOCATOR
	;

mumps_array_locator_variable
	:	SQL TYPE IS array_type AS LOCATOR
	;

mumps_multiset_locator_variable
	:	SQL TYPE IS multiset_type AS LOCATOR
	;

mumps_ref_variable
	:	SQL TYPE IS reference_type
	;

embedded_sql_pascal_program
	:	/* !! See the Syntax Rules. */
	;

seq_nt_843
	:	comma pascal_host_identifier
	;

lst_nt_844
	:	seq_nt_843
	|	lst_nt_844 seq_nt_843
	;

opt_nt_842
	:	/* Nothing */
	|	lst_nt_844
	;

pascal_variable_definition
	:	pascal_host_identifier opt_nt_842 colon pascal_type_specification semicolon
	;

pascal_host_identifier
	:	/* !! See the Syntax Rules. */
	;

opt_nt_846
	:	/* Nothing */
	|	IS
	;

opt_nt_845
	:	/* Nothing */
	|	CHARACTER SET opt_nt_846 character_set_specification
	;

opt_nt_848
	:	/* Nothing */
	|	IS
	;

opt_nt_847
	:	/* Nothing */
	|	CHARACTER SET opt_nt_848 character_set_specification
	;

pascal_type_specification
	:	PACKED ARRAY left_bracket 1 double_period length right_bracket OF CHAR opt_nt_845
	|	INTEGER
	|	REAL
	|	CHAR opt_nt_847
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
	|	pascal_multiset_locator_variable
	|	pascal_ref_variable
	;

opt_nt_850
	:	/* Nothing */
	|	IS
	;

opt_nt_849
	:	/* Nothing */
	|	CHARACTER SET opt_nt_850 character_set_specification ']'
	;

pascal_clob_variable
	:	SQL TYPE IS CLOB left_paren large_object_length right_paren opt_nt_849
	;

pascal_blob_variable
	:	SQL TYPE IS BLOB left_paren large_object_length right_paren
	;

pascal_clob_locator_variable
	:	SQL TYPE IS CLOB AS LOCATOR
	;

pascal_user_defined_type_variable
	:	SQL TYPE IS path_resolved_user_defined_type_name AS predefined_type
	;

pascal_blob_locator_variable
	:	SQL TYPE IS BLOB AS LOCATOR
	;

pascal_user_defined_type_locator_variable
	:	SQL TYPE IS path_resolved_user_defined_type_name AS LOCATOR
	;

pascal_array_locator_variable
	:	SQL TYPE IS array_type AS LOCATOR
	;

pascal_multiset_locator_variable
	:	SQL TYPE IS multiset_type AS LOCATOR
	;

pascal_ref_variable
	:	SQL TYPE IS reference_type
	;

embedded_sql_pl_i_program
	:	/* !! See the Syntax Rules. */
	;

seq_nt_851
	:	DCL
	|	DECLARE
	;

seq_nt_854
	:	comma pl_i_host_identifier
	;

lst_nt_855
	:	seq_nt_854
	|	lst_nt_855 seq_nt_854
	;

opt_nt_853
	:	/* Nothing */
	|	lst_nt_855
	;

seq_nt_852
	:	pl_i_host_identifier
	|	left_paren pl_i_host_identifier opt_nt_853 right_paren
	;

lst_nt_857
	:	character_representation
	|	lst_nt_857 character_representation
	;

opt_nt_856
	:	/* Nothing */
	|	lst_nt_857
	;

pl_i_variable_definition
	:	seq_nt_851 seq_nt_852 pl_i_type_specification opt_nt_856 semicolon
	;

pl_i_host_identifier
	:	/* !! See the Syntax Rules. */
	;

seq_nt_858
	:	CHAR
	|	CHARACTER
	;

opt_nt_859
	:	/* Nothing */
	|	VARYING
	;

opt_nt_861
	:	/* Nothing */
	|	IS
	;

opt_nt_860
	:	/* Nothing */
	|	CHARACTER SET opt_nt_861 character_set_specification
	;

opt_nt_862
	:	/* Nothing */
	|	comma scale
	;

opt_nt_863
	:	/* Nothing */
	|	left_paren precision right_paren
	;

pl_i_type_specification
	:	seq_nt_858 opt_nt_859 left_paren length right_paren opt_nt_860
	|	pl_i_type_fixed_decimal left_paren precision opt_nt_862 right_paren
	|	pl_i_type_fixed_binary opt_nt_863
	|	pl_i_type_float_binary left_paren precision right_paren
	|	pl_i_derived_type_specification
	;

pl_i_derived_type_specification
	:	pl_i_clob_variable
	|	pl_i_blob_variable
	|	pl_i_user_defined_type_variable
	|	pl_i_clob_locator_variable
	|	pl_i_blob_locator_variable
	|	pl_i_user_defined_type_locator_variable
	|	pl_i_array_locator_variable
	|	pl_i_multiset_locator_variable
	|	pl_i_ref_variable
	;

opt_nt_865
	:	/* Nothing */
	|	IS
	;

opt_nt_864
	:	/* Nothing */
	|	CHARACTER SET opt_nt_865 character_set_specification ']'
	;

pl_i_clob_variable
	:	SQL TYPE IS CLOB left_paren large_object_length right_paren opt_nt_864
	;

pl_i_blob_variable
	:	SQL TYPE IS BLOB left_paren large_object_length right_paren
	;

pl_i_user_defined_type_variable
	:	SQL TYPE IS path_resolved_user_defined_type_name AS predefined_type
	;

pl_i_clob_locator_variable
	:	SQL TYPE IS CLOB AS LOCATOR
	;

pl_i_blob_locator_variable
	:	SQL TYPE IS BLOB AS LOCATOR
	;

pl_i_user_defined_type_locator_variable
	:	SQL TYPE IS path_resolved_user_defined_type_name AS LOCATOR
	;

pl_i_array_locator_variable
	:	SQL TYPE IS array_type AS LOCATOR
	;

pl_i_multiset_locator_variable
	:	SQL TYPE IS multiset_type AS LOCATOR
	;

pl_i_ref_variable
	:	SQL TYPE IS reference_type
	;

seq_nt_866
	:	DEC
	|	DECIMAL
	;

seq_nt_867
	:	DEC
	|	DECIMAL '}'
	;

pl_i_type_fixed_decimal
	:	seq_nt_866 FIXED
	|	FIXED seq_nt_867
	;

seq_nt_868
	:	BIN
	|	BINARY
	;

seq_nt_869
	:	BIN
	|	BINARY '}'
	;

pl_i_type_fixed_binary
	:	seq_nt_868 FIXED
	|	FIXED seq_nt_869
	;

seq_nt_870
	:	BIN
	|	BINARY
	;

seq_nt_871
	:	BIN
	|	BINARY '}'
	;

pl_i_type_float_binary
	:	seq_nt_870 FLOAT
	|	FLOAT seq_nt_871
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
	|	merge_statement
	|	temporary_table_declaration
	;

direct_implementation_defined_statement
	:	/* !! See the Syntax Rules */
	;

direct_select_statement_multiple_rows
	:	cursor_specification
	;

get_diagnostics_statement
	:	GET DIAGNOSTICS sql_diagnostics_information
	;

sql_diagnostics_information
	:	statement_information
	|	condition_information
	;

seq_nt_873
	:	comma statement_information_item
	;

lst_nt_874
	:	seq_nt_873
	|	lst_nt_874 seq_nt_873
	;

opt_nt_872
	:	/* Nothing */
	|	lst_nt_874 ']'
	;

statement_information
	:	statement_information_item opt_nt_872
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

seq_nt_875
	:	EXCEPTION
	|	CONDITION
	;

seq_nt_877
	:	comma condition_information_item
	;

lst_nt_878
	:	seq_nt_877
	|	lst_nt_878 seq_nt_877
	;

opt_nt_876
	:	/* Nothing */
	|	lst_nt_878 ']'
	;

condition_information
	:	seq_nt_875 condition_number condition_information_item opt_nt_876
	;

condition_information_item
	:	simple_target_specification equals_operator condition_information_item_name
	;

condition_information_item_name
	:	CATALOG_NAME
	|	CLASS_ORIGIN
	|	COLUMN_NAME
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

condition_number
	:	simple_value_specification
	;


%%

