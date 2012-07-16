//
//  NoddyIndirectObjects.h
//  NodeTest
//
//  Created by Alex Gordon on 03/07/2012.
//  Copyright (c) 2012 Jean-Nicolas Jolivet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoddyIndirectObjects : NSObject {
    NSMapTable* weakmap;
    dispatch_queue_t queue;
}

+ (id)globalContext;
- (void)registerID:(NSString*)noddyid object:(id)obj;
- (NSString*)generateAndSetIDForObject:(id)obj;
- (id)objectForID:(NSString*)noddyid; // May return nil

@end
