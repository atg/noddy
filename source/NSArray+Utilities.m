//
//  NSArray+Utilities.m
//  Chocolat
//
//  Created by Alex Gordon on 10/07/2009.
//  Copyright 2009 Fileability. All rights reserved.
//

#import "NSArray+Utilities.h"

NSInteger CHComparePointers(id x, id y, void *context)
{
	if (x < y)
		return NSOrderedAscending;
	else if (x == y)
		return NSOrderedSame;
	else
		return NSOrderedDescending;
}


@implementation NSArray (Utilities)


- (NSArray *)arrayByRemovingObjectsEqualTo:(id)o
{
	NSMutableArray *newArray = [[NSMutableArray alloc] init];
	for (id o1 in self)
	{
		if (![o isEqual:o1])
			[newArray addObject:o1];
	}
	
	return newArray;
}
- (id)firstObject
{
	if (![self count])
		return nil;
	
	return [self objectAtIndex:0];
}
- (id)softObjectAtIndex:(NSInteger)i
{
	if (i >= 0 && i < [self count])
		return [self objectAtIndex:i];
	return nil;
}

+ (NSArray *)arrayByDuplicating:(id)object numTimes:(NSUInteger)numTimes
{
	NSMutableArray *returnArray = [[NSMutableArray alloc] initWithCapacity:numTimes];
	
	NSUInteger i = 0;
	for (i = 0; i < numTimes; i++)
	{
		[returnArray addObject:object];
	}
	
	return returnArray;
}

- (NSArray *)arrayByRemovingIdenticalDuplicates
{	
	NSArray *sortedArray = [self sortedArrayUsingFunction:CHComparePointers context:nil];
	NSUInteger count = [sortedArray count];

	NSMutableArray *noDupes = [[NSMutableArray alloc] initWithCapacity:count];
	id lastObject = nil;
	int i;
	for (i = 0; i < count; i++)
	{
		id currentObject = [sortedArray objectAtIndex:i];
		if (currentObject != lastObject)
		{
			[noDupes addObject:currentObject];
			lastObject = currentObject;
		}
	}
	
	return noDupes;
}

- (NSArray *)arrayByRemovingDuplicates
{
	NSMutableArray *newArray = [NSMutableArray array];
	int i;
	for (i = 0; i < [self count]; i++)
	{
		if (![newArray containsObject:[self objectAtIndex:i]])
		{
			[newArray addObject:[self objectAtIndex:i]];
		}
	}
	return newArray;
}

//This takes an array of KVC-able objects, a key and a root stem to return a unique identifier in the context of the key
//For example you might call this on an array of dictionaries, with a key of name and a stem of untitled, and it will return untitled then untitled 2 then untitled 3, etc
- (NSString *)compositedUniqueIdentifierWithStem:(NSString *)stem key:(NSString *)k
{
	NSArray *kvcnames = [self valueForKey:k];
	
	//Check stem first
	NSArray *names = [self valueForKey:@"name"];
	NSString *untitled = @"";
	int i;
	for (i = 1; i < 1000000; i++) //We don't want to infinite loop so lets set a sensible upper bound
	{
		if (i+1 == 1000000)
			return nil;
		
		NSString *newName = stem;
		if (i > 1)
			newName = [NSString stringWithFormat:@"%@ %d", stem, i];
		
		if ([kvcnames containsObject:newName])
			continue;
		
		return [newName copy];
	}
	
	return nil;
}

- (NSArray *)map:(id (^)(id a))mapping
{
	NSUInteger numItems = [self count];
	NSMutableArray *image = [[NSMutableArray alloc] initWithCapacity:numItems];
	
	for (id x in self)
	{
		id y = mapping(x);
		
		//nil signifies that the object should be removed
		if (y)
			[image addObject:y];
	}
	
	return image;
}
- (NSArray *)filter:(BOOL (^)(id a))predicate
{
	NSUInteger numItems = [self count];
	NSMutableArray *image = [[NSMutableArray alloc] initWithCapacity:numItems];
	
	for (id x in self)
	{
		BOOL p = predicate(x);
		
		if (p)
			[image addObject:x];
	}
	
	return image;
}

- (BOOL)containsInsensitiveString:(NSString *)x
{
	NSString *t = [x lowercaseString];
	for (NSString *s in self)
	{
		if ([[s lowercaseString] isEqual:t])
			return YES;
	}
	
	return NO;
}

- (NSArray *)reversedArray
{
	return [[self reverseObjectEnumerator] allObjects];
}

- (void)optimizeObjectInArray:(id)item matched:(BOOL)matched
{
	NSInteger ind = [self indexOfObject:item];
	//if (matched)
		[self removeObjectAtIndex:ind];
	
	//NSLog(@"item = %@", [item class]);
	
	if (matched)
		[self insertObject:item atIndex:0];
	else
	{
		NSInteger c = (NSInteger)[self count];
		//NSLog(@"GOING FROM %d", ind);
		ind = (ind + (c - 1)) / 2;
		if (ind >= c)
			ind = c - 1;
		if (ind < 0)
			ind = 0;
		
		//NSLog(@"\t TO %d", ind);
		[self insertObject:item atIndex:ind];
	}
}

@end
