//
//  NoddyIndirectObjects.m
//  NodeTest
//
//  Created by Alex Gordon on 03/07/2012.
//  Copyright (c) 2012 Jean-Nicolas Jolivet. All rights reserved.
//

#import "NoddyIndirectObjects.h"

@implementation NoddyIndirectObjects

- (id)init
{
    self = [super init];
    if (!self)
        return nil;
    
    queue = dispatch_queue_create("com.chocolatapp.Chocolat.noddy-queue", 0);
    weakmap = [NSMapTable mapTableWithStrongToWeakObjects];
    
    return self;
}
+ (id)globalContext {
    static id sharedContext;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedContext = [[NoddyIndirectObjects alloc] init];
    });
    return sharedContext;
}
- (NSString*)generateAndSetIDForObject:(id)obj {
    
    __block NSString* noddyid = nil;
    dispatch_sync(queue, ^{
        
        // Find the most basic class that responds to -noddyID
        Class c = [obj class];
        if (![c instancesRespondToSelector:@selector(noddyID)])
            [NSException raise:@"Noddy: Cannot generate ID for object '%@' of class '%@' which does not implement -noddyID" format:obj, c];
        
        while (1) {
            if ([[c superclass] instancesRespondToSelector:@selector(noddyID)])
                c = [c superclass];
            else
                break;
        }
        
        noddyid = [NSString stringWithFormat:@"NODDYID$$%@@%x%x%x", NSStringFromClass(c), arc4random(), arc4random(), arc4random()];
        
        // If we've been passed a class, then don't set
        if ([obj class] != obj)
            [weakmap setObject:obj forKey:noddyid];
    });
    
    return noddyid;
}
- (id)objectForID:(NSString*)noddyid {
    
    __block id obj = nil;
    dispatch_sync(queue, ^{
        obj = [weakmap objectForKey:noddyid];
    });
    
    return obj;
}
- (void)finalize {
    dispatch_release(queue);
    [super finalize];
}

@end

