//
//  NSString+Utilities.h
//  Chocolat
//
//  Created by Alex Gordon on 13/07/2009.
//  Copyright 2009 Fileability. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <SystemConfiguration/SystemConfiguration.h>

NSString *CHDeveloperDirectory();

@interface NSString (Utilities)

+ (NSString *)computerName;
+ (NSString *)volumeName;

+ (BOOL)ch_isAllowedEncoding:(NSStringEncoding)enc;

- (BOOL)startsWith:(NSString *)s;
+ (NSString *)stringByGeneratingUUID;

- (NSString *)copiesOf:(NSUInteger)numCopies;

- (BOOL)caseInsensitiveContains:(NSString *)needle;

- (NSString *)bashQuotedString;

- (NSRange)rangeOfNearestWordTo:(NSRange)range;
- (NSRange)rangeOfNearestWordTo2:(NSRange)range;

- (NSString *)relativePathRelativeTo:(NSString *)basePath;

- (void)enumerateChars:(void (^)(unichar, BOOL *))block;

- (NSInteger)uintValueOrError;

@end


/*

int AGLevenshtein(const void *s1, size_t l1,
                  const void *s2, size_t l2, size_t nmemb,
				  int weightInsertion, int weightDeletion, int weightSubstitution,
                  int (*comp)(const void*, const void*)); */