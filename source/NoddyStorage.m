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
@synthesize persistent;

- (id)init {
    
    self = [super init];
    if (!self)
        return nil;
    
    noddyID = [[NoddyIndirectObjects globalContext] generateAndSetIDForObject:self];
    dictionary = [NSMutableDictionary dictionary];
    return self;
}

- (NSDictionary*)dictionary {
    return dictionary;
}
- (id)valueForKey:(NSString *)key {
    return [dictionary objectForKey:key ?: [NSNull null]];
}
- (void)setValue:(id)value forKey:(NSString *)key {
    if (value && key) {
        [dictionary setObject:value forKey:key];
        if (self.persistent) {
            [[NSUserDefaults standardUserDefaults] setValue:[NSDictionary dictionaryWithDictionary:self.dictionary]
                                                     forKey:@"NoddyStorage"];
        }
    }
}
- (NSNumber*)count {
    return [NSNumber numberWithInteger:(NSInteger)[dictionary count]];
}

- (void)setPersistent:(BOOL)npersistent
{
    persistent = npersistent;
    if (persistent) {
        // load!
        dictionary = [[[NSUserDefaults standardUserDefaults] valueForKey:@"NoddyStorage"] mutableCopy];
    }
}

@end
