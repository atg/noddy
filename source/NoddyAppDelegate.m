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
#import "NoddyExtraManager.h"
#import "Taskit.h"

@implementation NoddyAppDelegate

@synthesize window = _window;
@synthesize extraManager;



- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [[NoddyController sharedController] reloadMixins];
    self.extraManager = [[NoddyExtraManager alloc] initWithWindowNibName:@"NoddyExtraManager"];
}

- (IBAction)helloButton:(id)sender {
    
}


- (IBAction)showExtraManager:(id)sender {
    [self.extraManager showWindow:sender];
}
@end
