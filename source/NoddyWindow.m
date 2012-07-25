//
//  NoddyWindow.m
//  noddy
//
//  Created by Alex Gordon on 23/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NoddyWindow.h"
#import "NoddyBridge.h"
#import "NoddyThread.h"
#import "NoddyIndirectObjects.h"

@implementation NoddyWindow

@synthesize noddyID;

@synthesize window;
@synthesize webview;
@synthesize title;
@synthesize html;
@synthesize htmlPath; // Instead of html, a path to show
@synthesize buttons; // A list of buttons to display at the bottom of the window.
@synthesize buttonObjects;
@synthesize canResize;
@synthesize canClose;
@synthesize canMiniaturize;

- (id)init
{
    self = [super init];
    if (!self)
        return nil;
    
    noddyID = [[NoddyIndirectObjects globalContext] generateAndSetIDForObject:self];
    buttonObjects = [NSMutableArray array];
    canResize = [NSNumber numberWithBool:YES];
    canClose = [NSNumber numberWithBool:YES];
    canMiniaturize = [NSNumber numberWithBool:YES];
    title = @"";
    laterFrame = NSMakeRect(0, 0, 480, 270);
    
    return self;
}

- (CGFloat)buttonBarHeight {
    return [buttons count] ? 32 : 0;
}
- (void)run {
    
    if (hasRun)
        return;
    hasRun = YES;
    
    NSUInteger styleMask = NSTitledWindowMask;
    if ([canMiniaturize boolValue])
        styleMask |= NSMiniaturizableWindowMask;
    if ([canClose boolValue])
        styleMask |= NSClosableWindowMask;
    if ([canResize boolValue])
        styleMask |= NSResizableWindowMask;
    
    // Load the webview
    [NSBundle loadNibNamed:@"NoddyWindow" owner:self];
    
    
    // Construct the window
    laterFrame.size.height += [self buttonBarHeight];
    window = [[NSWindow alloc] initWithContentRect:laterFrame
                                         styleMask:styleMask
                                           backing:NSBackingStoreBuffered
                                             defer:YES];
    [window setReleasedWhenClosed:NO];
    [window setTitle:[self title] ?: @""];
    [window setDelegate:self];
    [window center];
    
    // Load buttons
    if ([buttons count]) {
        [window setContentBorderThickness:32 forEdge:NSMinYEdge];
        
        for (NSDictionary* buttonDescription in buttons) {
            
            NSRect buttonFrame = NSMakeRect(0, 3, 1000, 25);
            
            NSButton* button = [[NSButton alloc] initWithFrame:buttonFrame];
            [button setAutoresizingMask:NSViewMaxXMargin | NSViewMinYMargin];
            [button setTitle:[[buttonDescription valueForKey:@"name"] copy]];
            [button setTarget:self];
            [button setAction:@selector(bottomButtonClicked:)];
            [button sizeToFit];
            
            buttonFrame.origin.x = [window frame].size.width - [button frame].size.width - 12;
            [buttonObjects addObject:button];
            [[window contentView] addSubview:button];
        }
    }
    
    NSRect webviewFrame = [(NSView*)[window contentView] frame];
    webviewFrame.size.height -= [self buttonBarHeight];
    webviewFrame.origin.y += [self buttonBarHeight];
    [webview setFrame:webviewFrame];
    [webview setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    [[window contentView] addSubview:webview];
        
    [window makeKeyAndOrderFront:nil];
}
- (void)setTitle:(NSString *)newTitle {
    [window setTitle:newTitle];
    title = newTitle;
}
- (void)windowWillClose:(NSNotification *)notification {
    [[mixin windows] removeObject:self];
}

- (void)setButtons:(NSArray *)btts {
    // Only allow setting buttons before we've run
    if (hasRun)
        return;
    buttons = [btts copy];
}
- (void)bottomButtonClicked:(id)sender {
    NoddyFunction* callback = [[buttons objectAtIndex:[buttonObjects indexOfObject:sender]] objectForKey:@"callback"];
    NoddyScheduleBlock(^{
        [callback call:nil arguments:[NSArray array]];
    });
}
- (void)show {
    [window makeKeyAndOrderFront:nil];
}
- (void)hide {
    [window orderOut:nil];
}
- (void)close {
    [window performClose:nil];
    window = nil;
    webview = nil;
}
- (void)maximize {
    [window zoom:nil];
}
- (void)minimize {
    [window miniaturize:nil];
}
- (void)unminimize {
    [window deminiaturize:nil];
}
- (NSNumber*)isMinimized {
    return [NSNumber numberWithBool:[window isMiniaturized]];
}

- (NSNumber*)toggle {
    if ([[self isVisible] boolValue])
        [self hide];
    else
        [self show];
    return [self isVisible];
}
- (NSNumber*)isVisible {
    return [NSNumber numberWithBool:[window isVisible]];
}
- (void)center {
    [window center];
}
- (NSNumber*)isKeyWindow {
    return [NSNumber numberWithBool:[window isKeyWindow]];
}
- (NSNumber*)isMainWindow {
    return [NSNumber numberWithBool:[window isMainWindow]];
}


- (void)client_callFunctionNamed:(NSString*)functionName arguments:(NSArray*)arguments {
    WebScriptObject* wso = [webview windowScriptObject];
    [wso callWebScriptMethod:functionName withArguments:arguments];
}
- (void)client_callFunctionCode:(NSString*)functionString jsonArguments:(NSArray*)jsonedArguments {
    
    NSString* argumentsString = [jsonedArguments componentsJoinedByString:@", "];
    [self client_eval:[NSString stringWithFormat:@"(%@)(%@)", functionString, argumentsString]];
}
- (void)client_eval:(NSString*)code {
    WebScriptObject* wso = [webview windowScriptObject];
    [wso evaluateWebScript:code];
}
- (void)client_addFunction:(NSString*)functionString named:(NSString*)functionName {
    NSString* code = [NSString stringWithFormat:@"window[\"%@\"] = %@;", functionName, functionString];
    [self client_eval:code];
}


- (void)server_callFunctionNamed:(NSString*)functionName arguments:(NSArray*)arguments {
    
//    [NoddyThread callGlobalFunction:@"call_function_as"
//                          arguments:[NSArray arrayWithObjects:[mixin noddyID], functionName, arguments, nil]];
}
- (void)server_callFunctionCode:(NSString*)functionString arguments:(NSArray*)arguments {
    
//    NSMutableArray* jsonedArguments = [NSMutableArray arrayWithCapacity:[arguments count]];
//    for (id argument in arguments) {
//        [jsonedArguments addObject:to_json(argument)];
//    }
    
//    NSString* argumentsString = [jsonedArguments componentsJoinedByString:@", "];
//    [self server_eval:[NSString stringWithFormat:@"(%@)(%@)", functionString, argumentsString]];
}
- (void)server_eval:(NSString*)code {
    
//    [NoddyThread callGlobalFunction:@"run_code_as"
//                          arguments:[NSArray arrayWithObjects:[mixin noddyID], functionName, arguments, nil]];    
}



- (NSValue*)frame {
    return [NSValue valueWithRect:[window frame]];
}
- (void)setFrame:(NSValue*)frame animate:(BOOL)animate {
    if (!frame || ![frame isKindOfClass:[NSValue class]])
        return;
    
    const char* objctype = [frame objCType];
    if (strcmp(objctype, @encode(NSRect)) != 0)
        return;
    
    NSRect r = [frame rectValue];
    if (!window)
        [window setFrame:r display:YES animate:animate];
    else
        laterFrame = r;
}


// Messaging
- (void)client_sendMessage:(NSString*)message arguments:(NSArray*)arguments {
    [self client_callFunctionNamed:@"noddy_private_receivedMessage"
                         arguments:[NSArray arrayWithObjects:message, arguments, nil]];
}
- (void)server_sendMessage:(NSString*)message arguments:(NSArray*)arguments {
//    [self server_callFunctionNamed:@"window_received_message" arguments:[NSArray arrayWithObjects:[mixin noddyID], message, arguments, nil]];

}

@end
