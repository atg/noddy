//
//  NoddyAppDelegate.h
//  noddy
//
//  Created by Alex Gordon on 10/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class NoddyThread, NoddyExtraManager;

@interface NoddyAppDelegate : NSObject <NSApplicationDelegate> {
    NoddyThread* thread;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) NoddyExtraManager *extraManager;
- (IBAction)helloButton:(id)sender;
- (void)ui_addMenuItem:(NSDictionary *)options;
- (IBAction)showExtraManager:(id)sender;

@end
