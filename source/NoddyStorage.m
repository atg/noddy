//
//  NoddyStorage.m
//  noddy
//
//  Created by Alex Gordon on 23/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NoddyStorage.h"
#import "NoddyIndirectObjects.h"

@implementation NoddyStorage

@synthesize noddyID;
@synthesize dictionary;

- (id)init {
    
    self = [super init];
    if (!self)
        return nil;
    
    noddyID = [[NoddyIndirectObjects globalContext] generateAndSetIDForObject:self];
    return self;
}

- (NSDictionary*)dictionary {
    return dictionary;
}
- (id)valueForKey:(NSString *)key {
    return [dictionary objectForKey:key ?: [NSNull null]];
}
- (void)setValue:(id)value forKey:(NSString *)key {
    if (value && key)
        return [dictionary setObject:value forKey:key];
}
- (NSNumber*)count {
    return [NSNumber numberWithInteger:(NSInteger)[dictionary count]];
}

@end
