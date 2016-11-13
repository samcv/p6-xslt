use v6.c;

use NativeCall;

our $XSLT_xml_support is export;
{
	$XSLT_xml_support = (try require ::('XML::LibXML::Node')) !~~ Nil;
}

# XML::LibXML predefines
if $XSLT_xml_support {
	require XML::LibXML::CStructs;
} else {
	class xmlAttr 			is repr('CStruct')	{ has int32 $.dummy; }
	class xmlNode 			is repr('CStruct')	{ has int32 $.dummy; }
	class xmlNodeSet		is repr('CStruct')  { has int32 $.dummy; }
	class xmlNs   			is repr('CStruct')	{ has int32 $.dummy; }
	class xmlDict			is repr('CStruct')	{ has int32 $.dummy; }
	class xmlDoc  			is repr('CStruct')	{ has int32 $.dummy; }
	class xmlHashTable		is repr('CStruct')	{ has int32 $.dummy; }
	class xmlXPathContext	is repr('CStruct')  { has int32 $.dummy; }
	class xmlXPathObject 	is repr('CStruct')	{ has int32 $.dummy; }
	class xmlXPathCompExpr	is repr('CStruct')	{ has int32 $.dummy; }
	class xmlOutputBuffer	is repr('CStruct')	{ has int32 $.dummy; }
	class xmlSAXHandler		is repr('CStruct')	{ has int32 $.dummy; }

	class xmlXPathParserContext is repr('CStruct') { has int32 $.dummy; }
}

module XML::LibXSLT::Types {

	# libxslt predefines.
	class xsltTemplate 			is repr('CStruct') { ... }
	class xsltTransformContext 	is repr('CStruct') { ... }
	class xsltRuntimeExtra		is repr('CStruct') { ... }

	enum xsltStyleType is export (
	    XSLT_FUNC_COPY => 1,
	    'XSLT_FUNC_SORT',
	    'XSLT_FUNC_TEXT',
	    'XSLT_FUNC_ELEMENT',
	    'XSLT_FUNC_ATTRIBUTE',
	    'XSLT_FUNC_COMMENT',
	    'XSLT_FUNC_PI',
	    'XSLT_FUNC_COPYOF',
	    'XSLT_FUNC_VALUEOF',
	    'XSLT_FUNC_NUMBER',
	    'XSLT_FUNC_APPLYIMPORTS',
	    'XSLT_FUNC_CALLTEMPLATE',
	    'XSLT_FUNC_APPLYTEMPLATES',
	    'XSLT_FUNC_CHOOSE',
	    'XSLT_FUNC_IF',
	    'XSLT_FUNC_FOREACH',
	    'XSLT_FUNC_DOCUMENT',
	    'XSLT_FUNC_WITHPARAM',
	    'XSLT_FUNC_PARAM',
	    'XSLT_FUNC_VARIABLE',
	    'XSLT_FUNC_WHEN',
	    'XSLT_FUNC_EXTENSION',
	#cw: Not using XSLT_REFACTORED
	#    'XSLT_FUNC_OTHERWISE',
	#    'XSLT_FUNC_FALLBACK',
	#    'XSLT_FUNC_MESSAGE',
	#    'XSLT_FUNC_INCLUDE',
	#    'XSLT_FUNC_ATTRSET',
	#    'XSLT_FUNC_LITERAL_RESULT_ELEMENT',
	#    'XSLT_FUNC_UNKOWN_FORWARDS_COMPAT
	#endif
	);

	enum xsltOutputType is export (
	    XSLT_OUTPUT_XML => 0,
	    'XSLT_OUTPUT_HTML',
	    'XSLT_OUTPUT_TEXT',
	);

	enum xsltTransformState is export (
	    XSLT_STATE_OK => 0,
	    'XSLT_STATE_ERROR',
	    'XSLT_STATE_STOPPED',
	);

	class xsltDecimalFormat is repr('CStruct') is export {
		has xsltDecimalFormat	$.next;
		has Str 				$.name;
		has Str 				$.digit;
		has Str 				$.patternSeparator;
		has Str 				$.minusSign;
		has Str 				$.infinity;
		has Str 				$.noNumber;
		has Str 				$.decimalPoint;
		has Str 				$.grouping;
		has Str 				$.percent;
		has Str 				$.permille;
		has Str 				$.zeroDigit;
	}

	class xsltDocument is repr('CStruct') is export {
		has xsltDocument		$.next;
		has int32				$.main;
		has xmlDoc 				$.doc;
		has Pointer				$.keys;
		has xsltDocument		$.includes;
		has int32				$.preproc;
		has int32				$.nbKeysComputed;
	}

	class xsltElemPreComp is repr('CStruct') is export {
		has xsltElemPreComp		$.next;
		has int32				$.type;
		has Pointer				$.func;
		has xmlNode 			$.inst;
		has Pointer				$.free;
	}

	class xslt_ptr_int is repr('CUnion') is export {
		has Pointer				$.pointer;
		has int32				$.ival;
	}

	class xsltRuntimeExtra is export {
		has Pointer				$.info;
		has Pointer				$.deallocate;
		HAS xslt_ptr_int		$.val;
	}

	class xsltStylePreComp is repr('CStruct') is export {
		has xsltStylePreComp		$.next;
		has int32					$.type;
		has Pointer					$.func;
		has xmlNode					$.inst;
		has Pointer					$.free;

		# cw: May want to have a helper function in this class for calling the 
		#     $.free and $.func callbacks
	}

	class xsltStackElem is repr('CStruct') is export {
		has xsltStackElem			$.next;
		has xsltStylePreComp		$.comp;
		has int32					$.computed;
		has Str 					$.name;
		has Str 					$.nameURI;
		has Str 					$.select;
		has xmlNode					$.tree;
		has xmlXPathObject			$.value;
		has xmlDoc 					$.fragment;
		has int32					$.level;
		has xsltTransformContext	$.context;
		has int32					$.flags;
	}

	class xsltStylesheet is repr('CStruct') is export {
		has xsltStylesheet 		$.parent;
		has xsltStylesheet 		$.next;
		has xsltStylesheet  	$.imports;

		has xsltDocument		$.docList;

		has xmlDoc				$.doc;
		has xmlHashTable		$.stripSpaces;
		has int32				$.stripAll;
		has xsltStackElem		$.variables;

		has xsltTemplate		$.templates;
		has Pointer				$.templateHash;
		has Pointer				$.rootMatch;
		has Pointer				$.elemMatch;
		has Pointer				$.attrMatch;
		has Pointer				$.parentMatch;
		has Pointer				$.textMatch;
		has Pointer				$.piMatch;
		has Pointer				$.commentMatch;

		has xmlHashTable		$.nsAliases;
		has xmlHashTable		$.attributeSets;
		has xmlHashTable		$.nsHash;

		has Pointer				$.nsDefs;
		has Pointer				$.keys;

		has Str 				$.method;
		has Str 				$.methodURI;
		has Str 				$.version;
		has Str 				$.encoding;
		has int32 				$.omitXmlDeclaration;

		has xsltDecimalFormat	$.decimalFormat;
		has int32				$.standalone;
		has Str 				$.doctypePublic;
		has Str 				$.doctypeSystem;
		has int32				$.indent;
		has Str 				$.mediaType;

		has xsltElemPreComp		$.preComps;
		has int32				$.warnings;
		has int32				$.errors;

		has Str 				$.exclPrefix;
		has CArray[Str] 		$.exclPrefixTab;
		has int32				$.exclPrefixNr;
		has int32				$.exclPrefixMax;

		has Pointer				$._private;

		has xmlHashTable		$.extInfos;
		has int32				$.extrasNr;

		has xsltDocument		$.includes;
		has xmlDict				$.dict;

		has Pointer				$.attVTs;

		has Str 				$.defaultAlias;
		has int32				$.nopreproc;
		has int32				$.internalized;
		has int32				$.literal_result;

		# cw: XSLT_REFACTORED not defined on Ubuntu. There really is NO GOOD WAY to 
		#     handle this section. If SEGVs are encountered in the use of this module
		#     this might be the 'reason', hence the commented code below:
		# has Pointer					$.compCtxt;
		# xsltPrincipalStylesheetData	$.principalData;

		has int32				$.forwards_compatible;

		has xmlHashTable		$.namedTemplates;
	}

	class xsltTemplate is export {
		has xsltTemplate 	$.next;
		has xsltStylesheet	$.style;
		has Str				$.match;
		has num32			$.priority;
		has Str				$.name;
		has Str				$.nameURI;
		has Str				$.mode;
		has Str				$.modeURI;
		has xmlNode			$.content;
		has xmlNode			$.elem;
		has int32			$.inheritedNsNr;
		has xmlNs			$.inheritedNs;
		has int32			$.nbCalls;
		has uint64			$.time;
		has Pointer			$.params;
		has int32			$.templNr;
		has int32			$.templMax;
		has xsltTemplate 	$.templCalledTab;
		has int32			$.templCountTab;
	}

	class xsltTransformCache is repr('CStruct') {
		has xmlDoc 			$.RVT;
		has int32 			$.nvRVT;
		has xsltStackElem 	$.stackItems;
		has int32			$.nbStackItems;
		# cw: There is no good way to support conditional XSLT_DEBUG_PROFILE_CACHE 
		#     'elements', yet. Ubuntu has them commented 'out', so for now we do not 
		#     consider their existence.
		# has int32			$.dbgCachedRVTs;
		# has int32			$.debugReusedRVTs;
		# has int32			$.debugCachedVars;
		# has int32			$.debugReusedVars;
	}

	class xsltTransformContext is export {
		has xsltStylesheet 		$.style;
		has int32				$.type;

		has xsltTemplate 		$.templ;
		has int32 				$.templNr;
		has int32 				$.templMax;
		has xsltTemplate 		$.templTab;

		has xsltStackElem		$.vars;
		has int32				$.varsNr;
		has int32				$.varsMax;
		has xsltStackElem		$.varsTab;
		has int32				$.varsBase;

		has xmlHashTable 		$.extFunctions;
		has xmlHashTable 		$.extElements;
		has xmlHashTable 		$.extInfos;

		has Str 				$.mode;
		has Str 				$.modeURI;

		has xsltDocument 		$.docList;
		has xsltDocument 		$.document;
		has xmlNode 			$.node;
		has xmlNodeSet			$.nodeList;

		has xmlDoc 				$.output;
		has xmlNode 			$.insert;

		has xmlXPathContext 	$.xpathCtxt;
		has int32			 	$.state;

		has xmlHashTable 		$.globalVars;
		has xmlNode 			$.inst;

		has int32				$.include;
		has Str 				$.outputFile;

		has int32				$.profile;
		has int64				$.prof;
		has int32				$.profNr;
		has int32				$.profMax;
		has Pointer				$.profTab;

		has Pointer				$._private; 

		has int32				$.extrasNr;
		has int32				$.extrasMax;
		has xsltRuntimeExtra	$.extras;

		has xsltDocument 		$.styleList;
		has Pointer 			$.sec;

		has Pointer				$.error;
		has Pointer				$.errctx;

		has Pointer				$.sortfunc;

		has xmlDoc 				$.tmpRVT;
		has xmlDoc 				$.persistRVT;
		has int32 				$.ctxtflags;

		has Str 				$.lasttext;
		has uint32				$.lasttsize;
		has uint32				$.lastuse;

		has int32 				$.debugStatus;
		has uint64 				$.traceCode;

		has int32	 			$.parserOptions;

		has xmlDict 			$.dict;
		has xmlDoc 				$.tmpDoc;

		has int32				$.internalized;
		has int32 				$.nbKeys;
		has int32				$.hasTemplKeyPatterns;
		has xsltTemplate 		$.currentTemplateRule;
		has xmlNode 			$.initialContextNode;
		has xmlDoc 				$.initialContextDoc;
		has xsltTransformCache	$.cache;
		has Pointer 			$.contextVariable;
		has xmlDoc 				$.localRVT;
		has xmlDoc 				$.localRVTBase;
		has int32				$.keyInitLevel;
		has int32				$.funcLevel;
		has int32				$.maxTemplateDepth;
		has int32 				$.maxTemplateVars;

		has uint64 				$.nextid;
	}

}