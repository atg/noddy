//
//  NoddyAppDelegate.m
//  noddy
//
//  Created by Alex Gordon on 10/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NoddyAppDelegate.h"
#import "NoddyThread.h"

@implementation NoddyAppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    thread = [[NoddyThread alloc] init];
    [thread start];
}

@end
