//
//  NoddyAppDelegate.h
//  noddy
//
//  Created by Alex Gordon on 10/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class NoddyThread;

@interface NoddyAppDelegate : NSObject <NSApplicationDelegate> {
    NoddyThread* thread;
}

@property (assign) IBOutlet NSWindow *window;

@end
