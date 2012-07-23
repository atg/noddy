//
//  NSString+Utilities.m
//  Chocolat
//
//  Created by Alex Gordon on 13/07/2009.
//  Copyright 2009 Fileability. All rights reserved.
//

#import "NSString+Utilities.h"

#ifdef CHDebug
#import "CHSingleFileDocument.h"
#endif

#import <CommonCrypto/CommonDigest.h>

#include <sys/stat.h>
static inline NSTimeInterval CHTimespecToTimeInterval(struct timespec ts)
{
	return (ts.tv_sec - NSTimeIntervalSince1970) + (ts.tv_nsec / 1000000000);
}


#define MAX_STACK_ALLOC_SIZE 512
#define sthemalloc(name, type, count) \
    _Bool name##_used_stack = sizeof(type) * count <= MAX_STACK_ALLOC_SIZE; \
    type name##_array[MAX_STACK_ALLOC_SIZE]; \
    type* name = name##_used_stack ? name##_array : (type *)malloc(sizeof(type) * count)

#define sthefree(name) if (! name##_used_stack) free(name)

#ifndef MIN3
#define MIN3(a,b,c) (a < b ? (a < c ? a : c) : (b < c ? b : c))
#endif

NSString *CHDeveloperDirectory()
{
	//FIXME: Add some detection code here and consult preferences. Perhaps check if /Developer/Applications exists and if not, use the path of wherever Xcode is
	return @"/Developer";
}

@implementation NSString (Utilities)

- (NSDate *)filePathModificationDate
{
	struct stat s;
	int statworked = [self fileSystemRepresentation] ? lstat([self fileSystemRepresentation], &s) : -1;
	if (statworked == 0)
	{
		double fileTimestampDoubleStat = CHTimespecToTimeInterval(s.st_mtimespec);
		return [NSDate dateWithTimeIntervalSinceReferenceDate:fileTimestampDoubleStat];
	}
	return nil;
}

- (NSArray *)chocolat_pathComponents {
    return [self componentsSeparatedByString:@"/"];
}
- (NSString*)md5HexDigest {
    const char* str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}
- (NSString*)xmlEntitiesNonQuote {
    NSString *s = [self stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
    s = [s stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
    s = [s stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
    return s;
}

+ (NSString *)computerName
{
	return NSMakeCollectable(SCDynamicStoreCopyComputerName(NULL, NULL));
}
+ (NSString *)volumeName
{
	//return [(NSString *)SCDynamicStoreCopyComputerName(NULL, NULL) autorelease];
	return nil;
}

- (BOOL)startsWith:(NSString *)s
{
	if ([self length] >= [s length] && [[self substringToIndex:[s length]] isEqualToString:s])
		return YES;
	return NO;
}

- (NSInteger)uintValueOrError
{
    if ([self isEqual:@"0"])
        return 0;
    NSInteger i = [self integerValue];
    if (i > 0 && i < NSIntegerMax)
        return i;
    return -1;
}

//For snippets
- (NSString *)evaluatedString
{
	return self;
}

+ (NSString *)stringByGeneratingUUID
{
	CFUUIDRef uuidRef = CFUUIDCreate(NULL);
	NSString *uuidString = (NSString *)NSMakeCollectable((CFUUIDCreateString(NULL, uuidRef)));
	CFRelease(uuidRef);
	return uuidString;
}
+ (NSString *)stringByGeneratingXcodeHexadecimalUUID
{
	//24 Uppercase Hexadecimal Characters
	//For example: 758912EA10C2ABB500F9A5CF
	
	NSMutableString *uuidString = [[NSMutableString alloc] initWithCapacity:24];
	
	//We create 6 groups of 4 characters
	int i;
	for (i = 0; i < 6; i++)
	{
		long r = random();
		r %= 65536; // 16^4
		[uuidString appendString:[[NSString stringWithFormat:@"%04x", r] uppercaseString]];
	}
	
	return uuidString;
}

- (NSString *)copiesOf:(NSUInteger)numCopies
{
	NSMutableString *tabAsSpaces = [[NSMutableString alloc] initWithCapacity:numCopies];
	NSUInteger i = 0;
	for (i = 0; i < numCopies; i++)
	{
		[tabAsSpaces appendString:self];
	}
	
	return tabAsSpaces;
}

- (BOOL)caseInsensitiveContains:(NSString *)needle
{
	if ([self rangeOfString:needle options:NSCaseInsensitiveSearch].location >= NSNotFound)
		return NO;
	return YES;
}

- (NSString *)bashQuotedString
{
	// http://muffinresearch.co.uk/archives/2007/01/30/bash-single-quotes-inside-of-single-quoted-strings/
	// ' -> '\''
	
	return [NSString stringWithFormat:@"'%@'", [self stringByReplacingOccurrencesOfString:@"'" withString:@"'\\''"]];
}

- (NSRange)rangeOfNearestWordTo:(NSRange)range
{
	// First one of these cool new blocks!
	BOOL (^isValidChar)(unichar c) = ^(unichar c){
		return (BOOL)( (c >= 'a' && c <= 'z') || (c >= '0' && c <= '9') || (c >= 'A' && c <= 'Z') || (c == '_') || (c == '$') );
	};
	
	// scan right first to extend the selection
	NSInteger i;
	NSUInteger furthestPointEast = range.location;
	NSUInteger furthestPointWest = range.location;
	
	for (i = range.location; i < [self length]; i++)
	{
		if(!isValidChar([self characterAtIndex:i]))
			break;
		
		furthestPointEast = i + 1;
	}
	
	// scan left now (thanks again moron!)
	for (i = range.location - 1; i >= 0; i--)
	{
		if(!isValidChar([self characterAtIndex:i]))
			break;
		
		furthestPointWest = i;
		
		
		if (i == 0)
			break;
	}
	
	return NSMakeRange(furthestPointWest, furthestPointEast - furthestPointWest);
}
- (NSRange)rangeOfNearestWordTo2:(NSRange)range
{
	// First one of these cool new blocks!
	BOOL (^isValidChar)(unichar c) = ^(unichar c){
		return (BOOL)( (c >= 'a' && c <= 'z') || (c >= '0' && c <= '9') || (c >= 'A' && c <= 'Z') || (c == '_') || (c == '$') || (c == '-') || (c == ':') );
	};
	
	// scan right first to extend the selection
	NSInteger i;
	NSUInteger furthestPointEast = range.location;
	NSUInteger furthestPointWest = range.location;
	
	for (i = range.location; i < [self length]; i++)
	{
		if(!isValidChar([self characterAtIndex:i]))
			break;
		
		furthestPointEast = i + 1;
	}
	
	// scan left now (thanks again moron!)
	for (i = range.location - 1; i >= 0; i--)
	{
		if(!isValidChar([self characterAtIndex:i]))
			break;
		
		furthestPointWest = i;
		
		
		if (i == 0)
			break;
	}
	
	return NSMakeRange(furthestPointWest, furthestPointEast - furthestPointWest);
}

- (NSString *)stringByPrependingString:(NSString *)s
{
	return [s ?: @"" stringByAppendingString:self];
}

// relative item path + absolute base path => absolute item path
- (NSString *)absolutePathRelativeTo:(NSString *)basePath
{
	NSString *relativePath = [self stringByStandardizingPath];
	basePath = [basePath stringByStandardizingPath];
	
	NSString *relativeComponents = [relativePath pathComponents];
	
	NSMutableArray *comps = nil;
	if ([relativePath isAbsolutePath])
		comps = [relativeComponents mutableCopy];
	else
		comps = [[basePath pathComponents] mutableCopy];
	
	for (NSString *rc in relativeComponents)
	{
		if (![rc length])
			continue;
		else if ([rc isEqual:@"/"])
			continue;
		else if ([rc isEqual:@"."])
			continue;
		
		else if ([rc isEqual:@".."])
		{
			if ([comps count])
				[comps removeLastObject];
		}
		
		else
		{
			[comps addObject:rc];
		}
	}
	
	return [[NSString pathWithComponents:comps] stringByStandardizingPath];
}

// absolute item path + absolute base path => relative item path
- (NSString *)relativePathRelativeTo:(NSString *)basePath
{
	/*
	NSString *combined = [[self stringByAppendingString:@"$$$$"] stringByAppendingString:basePath];
		
	static NSMutableDictionary *cache = nil;
	NSUInteger cacheLimit = NSUIntegerMax;
	if (!cache)
	{
		cache = [[NSMutableDictionary alloc] init];
		//[cache setCountLimit:500];
	}
	
	id cachehit = [cache objectForKey:combined];
	if (cachehit)
	{
		return cachehit;
	}
	*/
	
	if ([self hasPrefix:basePath])
		return [self substringFromIndex:[basePath length]];
	
	NSMutableArray *absoluteComponents = [[self pathComponents] mutableCopy];
	[absoluteComponents removeObject:@"/"];
	
	NSMutableArray *relativeComponents = [[basePath pathComponents] mutableCopy];
	[relativeComponents removeObject:@"/"];
	
	//Get the shortest length
	int shortestLength = MIN([absoluteComponents count], [relativeComponents count]);
	
	//Find the point where the two paths diverge
	int lastCommonRoot = -1;
	int i;
	for (i = 0; i < shortestLength; i++)
	{
		NSString *absoluteComponent = [[absoluteComponents objectAtIndex:i] lowercaseString];
		NSString *relativeComponent = [[relativeComponents objectAtIndex:i] lowercaseString];
		
		if ([absoluteComponent isEqual:relativeComponent])
			lastCommonRoot = i;
		else
			break;
	}
	
	//If we didn't find a common prefix, use the absolute path
	if (lastCommonRoot == -1)
	{
		/*
		if ([cache count] < cacheLimit)
			[cache setObject:self forKey:combined];
		*/
		return self;
	}
	
	//Build up the relative path
	NSMutableArray *newPathComponents = [[NSMutableArray alloc] init];
	for (i = lastCommonRoot + 1; i < [relativeComponents count]; i++)
	{
		[newPathComponents addObject:@".."];
	}
	
	for (i = lastCommonRoot + 1; i + 1 < [absoluteComponents count]; i++)
	{
		[newPathComponents addObject:[absoluteComponents objectAtIndex:i]];
	}
	
	[newPathComponents addObject:[absoluteComponents objectAtIndex:[absoluteComponents count] - 1]];
	
	NSString *finalResult = [NSString pathWithComponents:newPathComponents];
	
	/*
	if ([cache count] < cacheLimit)
		[cache setObject:finalResult forKey:combined];
	*/
	
	return finalResult;
}

- (void)enumerateChars:(void (^)(unichar, BOOL *))block
{
	NSUInteger length = [self length];
	if (length == 0)
		return;
	
	unichar *chars = malloc(sizeof(unichar) * length);
	[self getCharacters:chars range:NSMakeRange(0, length)];
	
	BOOL shouldStop = NO;
	NSUInteger i = 0;
	
	@try
	{
		for (i = 0; i < length; i++)
		{
			block(chars[i], &shouldStop);
			
			if (shouldStop)
				break;
		}
	}
	@catch (NSException * e)
	{
		@throw;
	}
	@finally {
		free(chars);
	}
}

+ (BOOL)ch_isAllowedEncoding:(NSStringEncoding)enc
{
	if (enc == NSASCIIStringEncoding || enc == NSUTF8StringEncoding || enc == NSUTF16StringEncoding || enc == NSUTF32StringEncoding || enc == NSISOLatin1StringEncoding)
		return YES;
	return NO;
}

+ (NSArray *)fileEncodingLocalNames
{
	NSMutableArray *encodings = [[NSMutableArray alloc] init];
	NSMutableArray *array = [[NSMutableArray alloc] init];
	
	[encodings addObject:[NSNumber numberWithLongLong:NSASCIIStringEncoding]];
	[array addObject:[NSString localizedNameOfStringEncoding:NSASCIIStringEncoding]];
	
	[encodings addObject:[NSNumber numberWithLongLong:NSUTF8StringEncoding]];
	[array addObject:[NSString localizedNameOfStringEncoding:NSUTF8StringEncoding]];

	[encodings addObject:[NSNumber numberWithLongLong:NSUTF16StringEncoding]];
	[array addObject:[NSString localizedNameOfStringEncoding:NSUTF16StringEncoding]];
	
	[encodings addObject:[NSNumber numberWithLongLong:NSUTF32StringEncoding]];
	[array addObject:[NSString localizedNameOfStringEncoding:NSUTF32StringEncoding]];
	
	[encodings addObject:[NSNumber numberWithLongLong:NSISOLatin1StringEncoding]];
	[array addObject:[NSString localizedNameOfStringEncoding:NSISOLatin1StringEncoding]];

	[encodings addObject:[NSNumber numberWithLongLong:NSShiftJISStringEncoding]];
	[array addObject:[NSString localizedNameOfStringEncoding:NSShiftJISStringEncoding]];

	
	/*
	//A separator item
	[encodings addObject:[NSNull null]];
	[array addObject:[NSNull null]];
	
	NSStringEncoding *encs = [NSString availableStringEncodings];
	while (encs != NULL && *encs != NULL)
	{
		NSStringEncoding enc = *encs;
		if (enc == NSASCIIStringEncoding || enc == NSUTF8StringEncoding ||
			enc == NSUTF16StringEncoding || enc == NSUTF32StringEncoding ||
			enc == NSISOLatin1StringEncoding)
		{
			encs++;
			continue;
		}
		
		[encodings addObject:[NSNumber numberWithLongLong:enc]];
		[array addObject:[NSString localizedNameOfStringEncoding:enc]];
		
		encs++;
	}*/
	
	return [NSMutableArray arrayWithObjects:encodings, array, nil];
}

#ifdef CHDebug
- (NSString *)convertToLineEndings:(CHNewlineType)t
{
	NSString *CRLFLineEnding = [[NSString alloc] initWithFormat:@"%C%C", 0x000D, 0x000A];
	NSString *CRLineEnding = [[NSString alloc] initWithFormat:@"%C", 0x000D];
	NSString *LFLineEnding = [[NSString alloc] initWithFormat:@"%C", 0x000A];
	
	NSMutableString *returnString = [self mutableCopy];
	
	if (t == CHNewlineTypeCRLF) // CRLF
	{
		[returnString replaceOccurrencesOfString:CRLFLineEnding withString:LFLineEnding options:NSLiteralSearch range:NSMakeRange(0, [returnString length])]; // So that it doesn't change CRLineEnding part of CRLFLineEnding
		[returnString replaceOccurrencesOfString:CRLineEnding withString:LFLineEnding options:NSLiteralSearch range:NSMakeRange(0, [returnString length])];
		[returnString replaceOccurrencesOfString:LFLineEnding withString:CRLFLineEnding options:NSLiteralSearch range:NSMakeRange(0, [returnString length])];
	}
	else if (t == CHNewlineTypeCR) // CR
	{
		[returnString replaceOccurrencesOfString:CRLFLineEnding withString:CRLineEnding options:NSLiteralSearch range:NSMakeRange(0, [returnString length])];
		[returnString replaceOccurrencesOfString:LFLineEnding withString:CRLineEnding options:NSLiteralSearch range:NSMakeRange(0, [returnString length])];
	}
	else if (t == CHNewlineTypeLF) // LF
	{
		[returnString replaceOccurrencesOfString:CRLFLineEnding withString:LFLineEnding options:NSLiteralSearch range:NSMakeRange(0, [returnString length])];
		[returnString replaceOccurrencesOfString:CRLineEnding withString:LFLineEnding options:NSLiteralSearch range:NSMakeRange(0, [returnString length])];
	}
	
	return returnString;
}
#endif


- (NSUInteger)localAlignment:(NSString *)otherString
{
	//We do a smith-waterman local sequence alignment
	//Then return the number of gaps
	
	
	
	NSUInteger m = [self length];
	NSUInteger n = [otherString length];
	
	if (m == 0 || n == 0)
		return 0;
	
	unichar c[m + 1][n + 1];
	
	NSInteger i = 0;
	for (; i <= m; i++)
		c[i][0] = 0;
	
	NSInteger j = 0;
	for (; j <= n; j++)
		c[0][j] = 0;
	
	
	for (i = 1; i <= m; i++)
	{
		NSInteger j = 1;
		for (; j <= n; j++)
		{
			
			
			if ([self characterAtIndex:i-1] == [otherString characterAtIndex:j-1])
				c[i][j] = c[i-1][j-1] + 1;
			else
				c[i][j] = MAX(c[i][j-1], c[i-1][j]);
		}
	}
	
	/*
	NSLog(@"%d : %@ ~ %@", c[m][n], self, otherString);
	printf("\t");
	for (i = 0; i < m + 1; i++)
	{
		printf("{");
		NSInteger j = 0;
		for (j = 0; j < n + 1; j++)
		{
			printf("%d, ", c[i][j]);
		}
		printf("},\n");
	}
	printf("\n");
	*/
	
	return c[m][n];
}


@end



/*
int AGLevenshtein(const void *s1, size_t l1,
                  const void *s2, size_t l2, size_t nmemb,
				  int weightInsertion, int weightDeletion, int weightSubstitution,
                  int (*comp)(const void*, const void*))
{
	int i, j;
	size_t len = (l1 + 1) * (l2 + 1);
	char *p1, *p2;
	unsigned int d1, d2, d3, *d, *dp, res;
	
	if (l1 == 0) {
		return l2;
	} else if (l2 == 0) {
		return l1;
	}
	
	d = (unsigned int*)malloc(len * sizeof(unsigned int));
	
	*d = 0;
	for(i = 1, dp = d + l2 + 1;
		i < l1 + 1;
		++i, dp += l2 + 1) {
		*dp = (unsigned) i;
	}
	for(j = 1, dp = d + 1;
		j < l2 + 1;
		++j, ++dp) {
		*dp = (unsigned) j;
	}
	
	for(i = 1, p1 = (char*) s1, dp = d + l2 + 2;
		i < l1 + 1;
		++i, p1 += nmemb, ++dp) {
		for(j = 1, p2 = (char*) s2;
			j < l2 + 1;
			++j, p2 += nmemb, ++dp) {
			if(!comp(p1, p2)) {
				*dp = *(dp - l2 - 2);
			} else {
				d1 = *(dp - 1) + weightDeletion;//1;
				d2 = *(dp - l2 - 1) + weightInsertion;//1;
				d3 = *(dp - l2 - 2) + ((*weightSubstitution;//1;
				*dp = MIN3(d1, d2, d3);
			}
		}
	}
	res = *(dp - 2);
	
	dp = NULL;
	free(d);
	return res;
}*/