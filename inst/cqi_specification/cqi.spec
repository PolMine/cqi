#
#  IMS CQi specification  
#
#  Version:  0.1a ;o)
#  Author:   Stefan Evert (evert@ims.uni-stuttgart.de)
#  Modified: Sun Aug  6 11:30:18 2000 (evert)   
#


#
#
HEAD padding
#
#

00 CQI_PAD	



#
#
HEAD CQi responses
#
#

# group CQI_STATUS_*
01 CQI_STATUS

01:01	CQI_STATUS_OK
01:02	CQI_STATUS_CONNECT_OK
01:03	CQI_STATUS_BYE_OK
01:04	CQI_STATUS_PING_OK


# group CQI_ERROR_*
02 CQI_ERROR

02:01	CQI_ERROR_GENERAL_ERROR
02:02	CQI_ERROR_CONNECT_REFUSED
02:03	CQI_ERROR_USER_ABORT
02:04	CQI_ERROR_SYNTAX_ERROR
%% includes corpus/attribute/subcorpus specifier syntax

# group CQI_DATA_*
03 CQI_DATA

03:01	CQI_DATA_BYTE
03:02	CQI_DATA_BOOL
03:03	CQI_DATA_INT
03:04	CQI_DATA_STRING
# lists of size 0 are explicitly allowed!
03:05	CQI_DATA_BYTE_LIST
03:06	CQI_DATA_BOOL_LIST
03:07	CQI_DATA_INT_LIST
03:08	CQI_DATA_STRING_LIST
03:09	CQI_DATA_INT_INT
03:0A	CQI_DATA_INT_INT_INT_INT
03:0B	CQI_DATA_INT_TABLE

# group CQI_CL_ERROR_*
04 CQI_CL_ERROR
# some CL error codes are not represented in the CQi specs
# -- usually because they're not used in the CL any more
# -- CDA_ENOSTRING is not considered an error (returns -1)
# -- CDA_EARGS: dynamic attribute calls not yet supported

04:01	CQI_CL_ERROR_NO_SUCH_ATTRIBUTE
%% returned if CQi server couldn't open attribute

04:02	CQI_CL_ERROR_WRONG_ATTRIBUTE_TYPE
%% CDA_EATTTYPE

04:03	CQI_CL_ERROR_OUT_OF_RANGE
%% CDA_EIDORNG, CDA_EIDXORNG, CDA_EPOSORNG

04:04	CQI_CL_ERROR_REGEX
%% CDA_EPATTERN (not used), CDA_EBADREGEX

04:05	CQI_CL_ERROR_CORPUS_ACCESS
%% CDA_ENODATA

04:06	CQI_CL_ERROR_OUT_OF_MEMORY
%% CDA_ENOMEM
%% this means the CQi server has run out of memory;
%% try discarding some other corpora and/or subcorpora

04:07	CQI_CL_ERROR_INTERNAL
%% CDA_EOTHER, CDA_ENYI
%% this is the classical 'please contact technical support' error


# group CQI_CQP_ERROR_*
05 CQI_CQP_ERROR
%% CQP error messages yet to be defined

05:01	CQI_CQP_ERROR_GENERAL
05:02	CQI_CQP_ERROR_NO_SUCH_CORPUS
05:03	CQI_CQP_ERROR_INVALID_FIELD
05:04	CQI_CQP_ERROR_OUT_OF_RANGE
%% various cases where a number is out of range

#
#
HEAD CQi commands
#
#

# group CQI_CTRL_*
11 CQI_CTRL

11:01	CQI_CTRL_CONNECT	
<<	(STRING username, STRING password)
>>	CQI_STATUS_CONNECT_OK, CQI_ERROR_CONNECT_REFUSED

11:02	CQI_CTRL_BYE
<<	()
>>	CQI_STATUS_BYE_OK

11:03	CQI_CTRL_USER_ABORT
<<	()
>>

11:04	CQI_CTRL_PING
<<	()
>>	CQI_CTRL_PING_OK

11:05	CQI_CTRL_LAST_GENERAL_ERROR
<<	()
>>	CQI_DATA_STRING
%% full-text error message for the last general error reported by
%% the CQi server



# group CQI_ASK_FEATURE_*
12 CQI_ASK_FEATURE

12:01	CQI_ASK_FEATURE_CQI_1_0
<<	()
>>	CQI_DATA_BOOL

12:02	CQI_ASK_FEATURE_CL_2_3
<<	()
>>	CQI_DATA_BOOL

12:03	CQI_ASK_FEATURE_CQP_2_3
<<	()
>>	CQI_DATA_BOOL



# group CQI_CORPUS_*
13 CQI_CORPUS

13:01	CQI_CORPUS_LIST_CORPORA
<<	()
>>	CQI_DATA_STRING_LIST

13:03	CQI_CORPUS_CHARSET
<<	(STRING corpus)
>>	CQI_DATA_STRING

13:04	CQI_CORPUS_PROPERTIES
<<	(STRING corpus)
>>	CQI_DATA_STRING_LIST

13:05	CQI_CORPUS_POSITIONAL_ATTRIBUTES
<<	(STRING corpus)
>>	CQI_DATA_STRING_LIST

13:06	CQI_CORPUS_STRUCTURAL_ATTRIBUTES
<<	(STRING corpus)
>>	CQI_DATA_STRING_LIST

13:07	CQI_CORPUS_STRUCTURAL_ATTRIBUTE_HAS_VALUES
<<	(STRING attribute)
>>	CQI_DATA_BOOL

13:08	CQI_CORPUS_ALIGNMENT_ATTRIBUTES
<<	(STRING corpus)
>>	CQI_DATA_STRING_LIST

13:09	CQI_CORPUS_FULL_NAME
<<	(STRING corpus)
>>	CQI_DATA_STRING
%% the full name of <corpus> as specified in its registry entry
       
13:0A	CQI_CORPUS_INFO
<<	(STRING corpus)
>>	CQI_DATA_STRING_LIST
%% returns the contents of the .info file of <corpus> as a list of lines

13:0B	CQI_CORPUS_DROP_CORPUS
<<	(STRING corpus)
>>	CQI_STATUS_OK
%% try to unload a corpus and all its attributes from memory



# group CQI_CL_*
14 CQI_CL
%% low-level corpus access (CL functions)

14:01	CQI_CL_ATTRIBUTE_SIZE
<<	(STRING attribute)
>>	CQI_DATA_INT
%% returns the size of <attribute>:
%%     number of tokens        (positional)
%%     number of regions       (structural)
%%     number of alignments    (alignment)

14:02	CQI_CL_LEXICON_SIZE
<<	(STRING attribute)
>>	CQI_DATA_INT
%% returns the number of entries in the lexicon of a positional attribute;
%% valid lexicon IDs range from 0 .. (lexicon_size - 1)

14:03	CQI_CL_DROP_ATTRIBUTE
<<	(STRING attribute)
>>	CQI_STATUS_OK
%% unload attribute from memory

#
# simple (scalar) mappings are applied to lists
# [the returned list has exactly the same length as the list passed as an argument]
#
14:04	CQI_CL_STR2ID
<<	(STRING attribute, STRING_LIST strings)
>>	CQI_DATA_INT_LIST
%% returns -1 for every string in <strings> that is not found in the lexicon

14:05	CQI_CL_ID2STR
<<	(STRING attribute, INT_LIST id)
>>	CQI_DATA_STRING_LIST
%% returns "" for every ID in <id> that is out of range

14:06	CQI_CL_ID2FREQ
<<	(STRING attribute, INT_LIST id)
>>	CQI_DATA_INT_LIST
%% returns 0 for every ID in <id> that is out of range

14:07	CQI_CL_CPOS2ID
<<	(STRING attribute, INT_LIST cpos)
>>	CQI_DATA_INT_LIST
%% returns -1 for every corpus position in <cpos> that is out of range

14:08	CQI_CL_CPOS2STR
<<	(STRING attribute, INT_LIST cpos)
>>	CQI_DATA_STRING_LIST
%% returns "" for every corpus position in <cpos> that is out of range

14:09	CQI_CL_CPOS2STRUC
<<	(STRING attribute, INT_LIST cpos)
>>	CQI_DATA_INT_LIST
%% returns -1 for every corpus position not inside a structure region

%% temporary addition for the Euralex2000 tutorial, but should probably be included in CQi specs
14:20	CQI_CL_CPOS2LBOUND
<<	(STRING attribute, INT_LIST cpos)
>>	CQI_DATA_INT_LIST
%% returns left boundary of s-attribute region enclosing cpos, -1 if not in region

14:21	CQI_CL_CPOS2RBOUND
<<	(STRING attribute, INT_LIST cpos)
>>	CQI_DATA_INT_LIST
%% returns right boundary of s-attribute region enclosing cpos, -1 if not in region

14:0A	CQI_CL_CPOS2ALG
<<	(STRING attribute, INT_LIST cpos)
>>	CQI_DATA_INT_LIST
%% returns -1 for every corpus position not inside an alignment

14:0B	CQI_CL_STRUC2STR
<<	(STRING attribute, INT_LIST strucs)
>>	CQI_DATA_STRING_LIST
%% returns annotated string values of structure regions in <strucs>; "" if out of range
%% check CQI_CORPUS_STRUCTURAL_ATTRIBUTE_HAS_VALUES(<attribute>) first

#
# the following mappings take a single argument and return multiple
# values, including lists of arbitrary size
#
14:0C	CQI_CL_ID2CPOS
<<	(STRING attribute, INT id)
>>	CQI_DATA_INT_LIST
%% returns all corpus positions where the given token occurs

14:0D	CQI_CL_IDLIST2CPOS
<<	(STRING attribute, INT_LIST id_list)
>>	CQI_DATA_INT_LIST
%% returns all corpus positions where one of the tokens in <id_list>
%% occurs; the returned list is sorted as a whole, not per token id

14:0E	CQI_CL_REGEX2ID
<<	(STRING attribute, STRING regex)
>>	CQI_DATA_INT_LIST
%% returns lexicon IDs of all tokens that match <regex>; the returned
%% list may be empty (size 0); 
# flags are ISO-Latin-1-specific so they're available in CQP queries only

14:0F	CQI_CL_STRUC2CPOS
<<	(STRING attribute, INT struc)
>>	CQI_DATA_INT_INT
%% returns start and end corpus positions of structure region <struc>

14:10	CQI_CL_ALG2CPOS
<<	(STRING attribute, INT alg)
>>	CQI_DATA_INT_INT_INT_INT
%% returns (src_start, src_end, target_start, target_end)



# group CQI_CQP_*
15 CQI_CQP

15:01	CQI_CQP_QUERY
<<	(STRING mother_corpus, STRING subcorpus_name, STRING query)
>>	CQI_STATUS_OK
%% <query> must include the ';' character terminating the query.

15:02	CQI_CQP_LIST_SUBCORPORA
<<	(STRING corpus)
>>	CQI_DATA_STRING_LIST

15:03	CQI_CQP_SUBCORPUS_SIZE
<<	(STRING subcorpus)
>>	CQI_DATA_INT

15:04	CQI_CQP_SUBCORPUS_HAS_FIELD
<<	(STRING subcorpus, BYTE field)
>>	CQI_DATA_BOOL

15:05	CQI_CQP_DUMP_SUBCORPUS
<<	(STRING subcorpus, BYTE field, INT first, INT last)
>>	CQI_DATA_INT_LIST
%% Dump the values of <field> for match ranges <first> .. <last>
%% in <subcorpus>. <field> is one of the CQI_CONST_FIELD_* constants.

15:09	CQI_CQP_DROP_SUBCORPUS
<<	(STRING subcorpus)
>>	CQI_STATUS_OK
%% delete a subcorpus from memory

%% The following two functions are temporarily included for the Euralex 2000 tutorial demo
%% frequency distribution of single tokens
15:10	CQI_CQP_FDIST_1
<<	(STRING subcorpus, INT cutoff, BYTE field, STRING attribute)
>>	CQI_DATA_INT_LIST
%% returns <n> (id, frequency) pairs flattened into a list of size 2*<n>
%% field is one of CQI_CONST_FIELD_MATCH, CQI_CONST_FIELD_TARGET, CQI_CONST_FIELD_KEYWORD
%% NB: pairs are sorted by frequency desc.

%% frequency distribution of pairs of tokens
15:11	CQI_CQP_FDIST_2
<<	(STRING subcorpus, INT cutoff, BYTE field1, STRING attribute1, BYTE field2, STRING attribute2)
>>	CQI_DATA_INT_LIST
%% returns <n> (id1, id2, frequency) pairs flattened into a list of size 3*<n>
%% NB: triples are sorted by frequency desc.



#
#
HEAD Constant Definitions
#
#

00 	CQI_CONST_FALSE
00 	CQI_CONST_NO

01	CQI_CONST_TRUE
01	CQI_CONST_YES

%% The following constants specify which field will be returned 
%% by CQI_CQP_DUMP_SUBCORPUS and some other subcorpus commands.

10	CQI_CONST_FIELD_MATCH
11	CQI_CONST_FIELD_MATCHEND

%% The constants specifiying target0 .. target9 are guaranteed to
%% have the numerical values 0 .. 9, so clients do not need to look
%% up the constant values if they're handling arbitrary targets.
00	CQI_CONST_FIELD_TARGET_0
01	CQI_CONST_FIELD_TARGET_1
02	CQI_CONST_FIELD_TARGET_2
03	CQI_CONST_FIELD_TARGET_3
04	CQI_CONST_FIELD_TARGET_4
05	CQI_CONST_FIELD_TARGET_5
06 	CQI_CONST_FIELD_TARGET_6
07	CQI_CONST_FIELD_TARGET_7
08	CQI_CONST_FIELD_TARGET_8
09	CQI_CONST_FIELD_TARGET_9

%% The following constants are provided for backward compatibility
%% with traditional CQP field names & while the generalised target
%% concept isn't yet implemented in the CQPserver.
00	CQI_CONST_FIELD_TARGET
09	CQI_CONST_FIELD_KEYWORD

