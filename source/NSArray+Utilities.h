//
//  NSArray+Utilities.h
//  Chocolat
//
//  Created by Alex Gordon on 10/07/2009.
//  Copyright 2009 Fileability. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NSInteger CHComparePointers(id x, id y, void *context);


@interface NSArray (Utilities)

- (NSArray *)arrayByRemovingObjectsEqualTo:(id)o;

+ (NSArray *)arrayByDuplicating:(id)object numTimes:(NSUInteger)numTimes;
- (NSArray *)arrayByRemovingIdenticalDuplicates;

- (NSArray *)map:(id (^)(id a))mappingFunction;
- (NSArray *)filter:(BOOL (^)(id a))predicate;

- (BOOL)containsInsensitiveString:(NSString *)x;

- (id)softObjectAtIndex:(NSInteger)i;

@end