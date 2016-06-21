//
//   CQi v0.1
//   (IMS/HIT Corpus Query Interface)
//   (C) Stefan Evert, IMS Stuttgart, Sep 1999
//




// package cqi;
public class CqiSpec {

// default port for CQi services
public static final int PORT = 4877;


//  ***
//  ***   padding
//  ***

public static final int PAD = 0x00;



//  ***
//  ***   CQi responses
//  ***

public static final int STATUS = 0x01;

public static final int STATUS_OK = 0x0101;
public static final int STATUS_CONNECT_OK = 0x0102;
public static final int STATUS_BYE_OK = 0x0103;
public static final int STATUS_PING_OK = 0x0104;


public static final int ERROR = 0x02;

public static final int ERROR_GENERAL_ERROR = 0x0201;
public static final int ERROR_CONNECT_REFUSED = 0x0202;
public static final int ERROR_USER_ABORT = 0x0203;
public static final int ERROR_SYNTAX_ERROR = 0x0204;
// includes corpus/attribute/subcorpus specifier syntax

public static final int DATA = 0x03;

public static final int DATA_BYTE = 0x0301;
public static final int DATA_BOOL = 0x0302;
public static final int DATA_INT = 0x0303;
public static final int DATA_STRING = 0x0304;
public static final int DATA_BYTE_LIST = 0x0305;
public static final int DATA_BOOL_LIST = 0x0306;
public static final int DATA_INT_LIST = 0x0307;
public static final int DATA_STRING_LIST = 0x0308;
public static final int DATA_INT_INT = 0x0309;
public static final int DATA_INT_INT_INT_INT = 0x030A;
public static final int DATA_INT_TABLE = 0x030B;

public static final int CL_ERROR = 0x04;

public static final int CL_ERROR_NO_SUCH_ATTRIBUTE = 0x0401;
// returned if CQi server couldn't open attribute

public static final int CL_ERROR_WRONG_ATTRIBUTE_TYPE = 0x0402;
// CDA_EATTTYPE

public static final int CL_ERROR_OUT_OF_RANGE = 0x0403;
// CDA_EIDORNG, CDA_EIDXORNG, CDA_EPOSORNG

public static final int CL_ERROR_REGEX = 0x0404;
// CDA_EPATTERN (not used), CDA_EBADREGEX

public static final int CL_ERROR_CORPUS_ACCESS = 0x0405;
// CDA_ENODATA

public static final int CL_ERROR_OUT_OF_MEMORY = 0x0406;
// CDA_ENOMEM
// this means the CQi server has run out of memory;
// try discarding some other corpora and/or subcorpora

public static final int CL_ERROR_INTERNAL = 0x0407;
// CDA_EOTHER, CDA_ENYI
// this is the classical 'please contact technical support' error


public static final int CQP_ERROR = 0x05;
// CQP error messages yet to be defined

public static final int CQP_ERROR_GENERAL = 0x0501;
public static final int CQP_ERROR_NO_SUCH_CORPUS = 0x0502;
public static final int CQP_ERROR_INVALID_FIELD = 0x0503;
public static final int CQP_ERROR_OUT_OF_RANGE = 0x0504;
// various cases where a number is out of range

//  ***
//  ***   CQi commands
//  ***

public static final int CTRL = 0x11;

public static final int CTRL_CONNECT = 0x1101;
// INPUT: (STRING username, STRING password)
// OUTPUT: CQI_STATUS_CONNECT_OK, CQI_ERROR_CONNECT_REFUSED

public static final int CTRL_BYE = 0x1102;
// INPUT: ()
// OUTPUT: CQI_STATUS_BYE_OK

public static final int CTRL_USER_ABORT = 0x1103;
// INPUT: ()
// OUTPUT: 

public static final int CTRL_PING = 0x1104;
// INPUT: ()
// OUTPUT: CQI_CTRL_PING_OK

public static final int CTRL_LAST_GENERAL_ERROR = 0x1105;
// INPUT: ()
// OUTPUT: CQI_DATA_STRING
// full-text error message for the last general error reported by
// the CQi server



public static final int ASK_FEATURE = 0x12;

public static final int ASK_FEATURE_CQI_1_0 = 0x1201;
// INPUT: ()
// OUTPUT: CQI_DATA_BOOL

public static final int ASK_FEATURE_CL_2_3 = 0x1202;
// INPUT: ()
// OUTPUT: CQI_DATA_BOOL

public static final int ASK_FEATURE_CQP_2_3 = 0x1203;
// INPUT: ()
// OUTPUT: CQI_DATA_BOOL



public static final int CORPUS = 0x13;

public static final int CORPUS_LIST_CORPORA = 0x1301;
// INPUT: ()
// OUTPUT: CQI_DATA_STRING_LIST

public static final int CORPUS_CHARSET = 0x1303;
// INPUT: (STRING corpus)
// OUTPUT: CQI_DATA_STRING

public static final int CORPUS_PROPERTIES = 0x1304;
// INPUT: (STRING corpus)
// OUTPUT: CQI_DATA_STRING_LIST

public static final int CORPUS_POSITIONAL_ATTRIBUTES = 0x1305;
// INPUT: (STRING corpus)
// OUTPUT: CQI_DATA_STRING_LIST

public static final int CORPUS_STRUCTURAL_ATTRIBUTES = 0x1306;
// INPUT: (STRING corpus)
// OUTPUT: CQI_DATA_STRING_LIST

public static final int CORPUS_STRUCTURAL_ATTRIBUTE_HAS_VALUES = 0x1307;
// INPUT: (STRING attribute)
// OUTPUT: CQI_DATA_BOOL

public static final int CORPUS_ALIGNMENT_ATTRIBUTES = 0x1308;
// INPUT: (STRING corpus)
// OUTPUT: CQI_DATA_STRING_LIST

public static final int CORPUS_FULL_NAME = 0x1309;
// INPUT: (STRING corpus)
// OUTPUT: CQI_DATA_STRING
// the full name of <corpus> as specified in its registry entry

public static final int CORPUS_INFO = 0x130A;
// INPUT: (STRING corpus)
// OUTPUT: CQI_DATA_STRING_LIST
// returns the contents of the .info file of <corpus> as a list of lines

public static final int CORPUS_DROP_CORPUS = 0x130B;
// INPUT: (STRING corpus)
// OUTPUT: CQI_STATUS_OK
// try to unload a corpus and all its attributes from memory



public static final int CL = 0x14;
// low-level corpus access (CL functions)

public static final int CL_ATTRIBUTE_SIZE = 0x1401;
// INPUT: (STRING attribute)
// OUTPUT: CQI_DATA_INT
// returns the size of <attribute>:
//     number of tokens        (positional)
//     number of regions       (structural)
//     number of alignments    (alignment)

public static final int CL_LEXICON_SIZE = 0x1402;
// INPUT: (STRING attribute)
// OUTPUT: CQI_DATA_INT
// returns the number of entries in the lexicon of a positional attribute;
// valid lexicon IDs range from 0 .. (lexicon_size - 1)

public static final int CL_DROP_ATTRIBUTE = 0x1403;
// INPUT: (STRING attribute)
// OUTPUT: CQI_STATUS_OK
// unload attribute from memory

public static final int CL_STR2ID = 0x1404;
// INPUT: (STRING attribute, STRING_LIST strings)
// OUTPUT: CQI_DATA_INT_LIST
// returns -1 for every string in <strings> that is not found in the lexicon

public static final int CL_ID2STR = 0x1405;
// INPUT: (STRING attribute, INT_LIST id)
// OUTPUT: CQI_DATA_STRING_LIST
// returns "" for every ID in <id> that is out of range

public static final int CL_ID2FREQ = 0x1406;
// INPUT: (STRING attribute, INT_LIST id)
// OUTPUT: CQI_DATA_INT_LIST
// returns 0 for every ID in <id> that is out of range

public static final int CL_CPOS2ID = 0x1407;
// INPUT: (STRING attribute, INT_LIST cpos)
// OUTPUT: CQI_DATA_INT_LIST
// returns -1 for every corpus position in <cpos> that is out of range

public static final int CL_CPOS2STR = 0x1408;
// INPUT: (STRING attribute, INT_LIST cpos)
// OUTPUT: CQI_DATA_STRING_LIST
// returns "" for every corpus position in <cpos> that is out of range

public static final int CL_CPOS2STRUC = 0x1409;
// INPUT: (STRING attribute, INT_LIST cpos)
// OUTPUT: CQI_DATA_INT_LIST
// returns -1 for every corpus position not inside a structure region

// temporary addition for the Euralex2000 tutorial, but should probably be included in CQi specs
public static final int CL_CPOS2LBOUND = 0x1420;
// INPUT: (STRING attribute, INT_LIST cpos)
// OUTPUT: CQI_DATA_INT_LIST
// returns left boundary of s-attribute region enclosing cpos, -1 if not in region

public static final int CL_CPOS2RBOUND = 0x1421;
// INPUT: (STRING attribute, INT_LIST cpos)
// OUTPUT: CQI_DATA_INT_LIST
// returns right boundary of s-attribute region enclosing cpos, -1 if not in region

public static final int CL_CPOS2ALG = 0x140A;
// INPUT: (STRING attribute, INT_LIST cpos)
// OUTPUT: CQI_DATA_INT_LIST
// returns -1 for every corpus position not inside an alignment

public static final int CL_STRUC2STR = 0x140B;
// INPUT: (STRING attribute, INT_LIST strucs)
// OUTPUT: CQI_DATA_STRING_LIST
// returns annotated string values of structure regions in <strucs>; "" if out of range
// check CQI_CORPUS_STRUCTURAL_ATTRIBUTE_HAS_VALUES(<attribute>) first

public static final int CL_ID2CPOS = 0x140C;
// INPUT: (STRING attribute, INT id)
// OUTPUT: CQI_DATA_INT_LIST
// returns all corpus positions where the given token occurs

public static final int CL_IDLIST2CPOS = 0x140D;
// INPUT: (STRING attribute, INT_LIST id_list)
// OUTPUT: CQI_DATA_INT_LIST
// returns all corpus positions where one of the tokens in <id_list>
// occurs; the returned list is sorted as a whole, not per token id

public static final int CL_REGEX2ID = 0x140E;
// INPUT: (STRING attribute, STRING regex)
// OUTPUT: CQI_DATA_INT_LIST
// returns lexicon IDs of all tokens that match <regex>; the returned
// list may be empty (size 0); 

public static final int CL_STRUC2CPOS = 0x140F;
// INPUT: (STRING attribute, INT struc)
// OUTPUT: CQI_DATA_INT_INT
// returns start and end corpus positions of structure region <struc>

public static final int CL_ALG2CPOS = 0x1410;
// INPUT: (STRING attribute, INT alg)
// OUTPUT: CQI_DATA_INT_INT_INT_INT
// returns (src_start, src_end, target_start, target_end)



public static final int CQP = 0x15;

public static final int CQP_QUERY = 0x1501;
// INPUT: (STRING mother_corpus, STRING subcorpus_name, STRING query)
// OUTPUT: CQI_STATUS_OK
// <query> must include the ';' character terminating the query.

public static final int CQP_LIST_SUBCORPORA = 0x1502;
// INPUT: (STRING corpus)
// OUTPUT: CQI_DATA_STRING_LIST

public static final int CQP_SUBCORPUS_SIZE = 0x1503;
// INPUT: (STRING subcorpus)
// OUTPUT: CQI_DATA_INT

public static final int CQP_SUBCORPUS_HAS_FIELD = 0x1504;
// INPUT: (STRING subcorpus, BYTE field)
// OUTPUT: CQI_DATA_BOOL

public static final int CQP_DUMP_SUBCORPUS = 0x1505;
// INPUT: (STRING subcorpus, BYTE field, INT first, INT last)
// OUTPUT: CQI_DATA_INT_LIST
// Dump the values of <field> for match ranges <first> .. <last>
// in <subcorpus>. <field> is one of the CQI_CONST_FIELD_* constants.

public static final int CQP_DROP_SUBCORPUS = 0x1509;
// INPUT: (STRING subcorpus)
// OUTPUT: CQI_STATUS_OK
// delete a subcorpus from memory

// The following two functions are temporarily included for the Euralex 2000 tutorial demo
// frequency distribution of single tokens
public static final int CQP_FDIST_1 = 0x1510;
// INPUT: (STRING subcorpus, INT cutoff, BYTE field, STRING attribute)
// OUTPUT: CQI_DATA_INT_LIST
// returns <n> (id, frequency) pairs flattened into a list of size 2*<n>
// field is one of CQI_CONST_FIELD_MATCH, CQI_CONST_FIELD_TARGET, CQI_CONST_FIELD_KEYWORD
// NB: pairs are sorted by frequency desc.

// frequency distribution of pairs of tokens
public static final int CQP_FDIST_2 = 0x1511;
// INPUT: (STRING subcorpus, INT cutoff, BYTE field1, STRING attribute1, BYTE field2, STRING attribute2)
// OUTPUT: CQI_DATA_INT_LIST
// returns <n> (id1, id2, frequency) pairs flattened into a list of size 3*<n>
// NB: triples are sorted by frequency desc.



//  ***
//  ***   Constant Definitions
//  ***

public static final int CONST_FALSE = 0x00;
public static final int CONST_NO = 0x00;

public static final int CONST_TRUE = 0x01;
public static final int CONST_YES = 0x01;

// The following constants specify which field will be returned 
// by CQI_CQP_DUMP_SUBCORPUS and some other subcorpus commands.

public static final int CONST_FIELD_MATCH = 0x10;
public static final int CONST_FIELD_MATCHEND = 0x11;

// The constants specifiying target0 .. target9 are guaranteed to
// have the numerical values 0 .. 9, so clients do not need to look
// up the constant values if they're handling arbitrary targets.
public static final int CONST_FIELD_TARGET_0 = 0x00;
public static final int CONST_FIELD_TARGET_1 = 0x01;
public static final int CONST_FIELD_TARGET_2 = 0x02;
public static final int CONST_FIELD_TARGET_3 = 0x03;
public static final int CONST_FIELD_TARGET_4 = 0x04;
public static final int CONST_FIELD_TARGET_5 = 0x05;
public static final int CONST_FIELD_TARGET_6 = 0x06;
public static final int CONST_FIELD_TARGET_7 = 0x07;
public static final int CONST_FIELD_TARGET_8 = 0x08;
public static final int CONST_FIELD_TARGET_9 = 0x09;

// The following constants are provided for backward compatibility
// with traditional CQP field names & while the generalised target
// concept isn't yet implemented in the CQPserver.
public static final int CONST_FIELD_TARGET = 0x00;
public static final int CONST_FIELD_KEYWORD = 0x09;


// CQi version is CQI_MAJOR_VERSION.CQI_MINOR_VERSION
public static final int MAJOR_VERSION = 0x00;
public static final int MINOR_VERSION = 0x01;




}
