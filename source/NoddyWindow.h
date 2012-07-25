//
//  NoddyWindow.h
//  noddy
//
//  Created by Alex Gordon on 23/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "NoddyMixin.h"

@interface NoddyWindow : NSObject<NSWindowDelegate> {
    __weak NoddyMixin* mixin;
    IBOutlet NSWindow* window;
    IBOutlet WebView* webview;
    NSRect laterFrame;
    
    BOOL hasRun;
}

@property (copy) NSString* noddyID;

@property (assign) __weak NoddyMixin* mixin;
@property (readonly) NSWindow* window;
@property (readonly) WebView* webview;
@property (copy) NSString* title;
@property (copy) NSString* html;
@property (copy) NSString* htmlPath; // Instead of html, a path to show
@property (copy) NSArray* buttons; // A list of buttons to display at the bottom of the window.
@property (readonly) NSMutableArray* buttonObjects; // A list of buttons to display at the bottom of the window.
@property (assign) NSNumber* canResize;
@property (assign) NSNumber* canClose;
@property (assign) NSNumber* canMiniaturize;

- (void)run;
- (void)close;
- (NSValue*)frame;
- (void)setFrame:(NSValue*)frame animate:(BOOL)animate;

- (CGFloat)buttonBarHeight;
- (void)run;
- (void)show;
- (void)hide;
- (void)close;
- (void)maximize;
- (void)minimize;
- (NSNumber*)toggle;
- (NSNumber*)isVisible;
- (void)center;
- (NSNumber*)isKeyWindow;
- (NSNumber*)isMainWindow;

- (void)client_callFunctionNamed:(NSString*)functionName arguments:(NSArray*)arguments;
- (void)client_callFunctionCode:(NSString*)functionString jsonArguments:(NSArray*)jsonedArguments;
- (void)client_eval:(NSString*)code;
- (void)client_addFunction:(NSString*)functionString named:(NSString*)functionName;

- (void)server_callFunctionNamed:(NSString*)functionName arguments:(NSArray*)arguments;
- (void)server_callFunctionCode:(NSString*)functionString arguments:(NSArray*)arguments;
- (void)server_eval:(NSString*)code;

// Messaging
- (void)client_sendMessage:(NSString*)message arguments:(NSArray*)arguments;
- (void)server_sendMessage:(NSString*)message arguments:(NSArray*)arguments;

@end
