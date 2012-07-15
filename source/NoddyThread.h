//
//  NoddyThread.h
//  NodeTest
//
//  Created by Jean-Nicolas Jolivet on 12-07-01.
//  Copyright (c) 2012 Jean-Nicolas Jolivet. All rights reserved.
//

#import <Foundation/Foundation.h>

void NoddyScheduleBlock(dispatch_block_t block);

@interface NoddyThread : NSThread

+ (void)callGlobalFunction:(NSString*)functionName arguments:(NSArray*)args;

@end
