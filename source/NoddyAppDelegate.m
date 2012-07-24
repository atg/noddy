//
//  NoddyAppDelegate.m
//  noddy
//
//  Created by Alex Gordon on 10/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NoddyAppDelegate.h"
#import "NoddyThread.h"
#import "NoddyController.h"
#import "NSString+Utilities.h"


@implementation NoddyAppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [[NoddyController sharedController] reloadMixins];
}

- (IBAction)helloButton:(id)sender {
    [NoddyThread callGlobalFunction:@"sayHelloTo" arguments:[NSArray arrayWithObject:NSFullUserName()]];
}


@end
