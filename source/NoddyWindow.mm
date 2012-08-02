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

using namespace v8;

// What we need to do is receive json and convert to json

/*
static id webkit_to_cocoa(id x) {
    if ([x isKindOfClass:[WebScriptObject class]]) {
        NSMutableDictionary* dict = [NSMutableDictionary dictionary];
        NSPointerArray* array = [NSPointerArray pointerArrayWithStrongObjects];
        for (id k in x) {
            NSLog(@"k = %@", k);
            if ([k isKindOfClass:[NSNumber class]]) {
                long idx = [k integerValue];
                if (idx < 0)
                    continue;
                [array insertPointer:webkit_to_cocoa([x valueForKey:k]) atIndex:idx];
            }
            else {
                [dict setObject:webkit_to_cocoa([x valueForKey:k]) forKey:k];
            }
        }
        
        [array compact];
        if ([array count])
            return [array allObjects];
        if ([dict count])
            return dict;
    }
    return x;
}
*/

@implementation NoddyWindow

@synthesize noddyID;

@synthesize mixin;
@synthesize window;
@synthesize webview;
@synthesize title;
@synthesize html;
@synthesize htmlPath; // Instead of html, a path to show
@synthesize buttons; // A list of buttons to display at the bottom of the window.
@synthesize buttonObjects;
@synthesize clientOnLoad, onLoad;
@synthesize onButtonClick;
@synthesize onMessage;
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
    
    [webview setFrameLoadDelegate:self];
    
    // Load buttons
    if ([buttons count]) {
        [window setContentBorderThickness:32 forEdge:NSMinYEdge];
        
        CGFloat deltaX = 0.0;
        for (NSString* name in buttons) {
            
            NSRect buttonFrame = NSMakeRect(0, 3, 3, 25);
            
            NSButton* button = [[NSButton alloc] initWithFrame:buttonFrame];
            [button setAutoresizingMask:NSViewMinXMargin | NSViewMaxYMargin];
            [button setTitle:[name copy]];
            [button setTarget:self];
            [button setAction:@selector(bottomButtonClicked:)];
            [button setBezelStyle:NSTexturedRoundedBezelStyle];
            [button setFont:[NSFont systemFontOfSize:13]];
            [button sizeToFit];
            
            buttonFrame = [button frame];
            if (buttonFrame.size.width < 60)
                buttonFrame.size.width = 60;
            
            buttonFrame.origin.x = [window frame].size.width - buttonFrame.size.width - 12 - deltaX;
            [button setFrame:buttonFrame];
            
            deltaX += buttonFrame.size.width + 8;
            
            [buttonObjects addObject:button];
            [[window contentView] addSubview:button];
        }
    }
    
    NSRect webviewFrame = [(NSView*)[window contentView] frame];
    webviewFrame.size.height -= [self buttonBarHeight];
    webviewFrame.origin.y += [self buttonBarHeight];
    [webview setFrame:webviewFrame];
    [webview setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    [webview setDrawsBackground:NO];
    [[window contentView] addSubview:webview];
        
    [window setMinSize:NSMakeSize(50, 22 + 10 + [self buttonBarHeight])];
    [window makeKeyAndOrderFront:nil];
    
    NSString* htmlstring = nil;
    if ([htmlPath length]) {
        NSString* htmlPathReplaced = [mixin.path stringByAppendingPathComponent:htmlPath];
        if ([htmlPath isEqual:@"default.html"])
            htmlPathReplaced = [[NSBundle mainBundle] pathForResource:@"nodeui_default" ofType:@"html"];
        
        htmlstring = [NSString stringWithContentsOfFile:htmlPathReplaced encoding:NSUTF8StringEncoding error:NULL];
    }
    if (![htmlstring length]) {
        htmlstring = html;
    }
    if (![htmlstring length]) {
        htmlstring = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"nodeui_default" ofType:@"html"] encoding:NSUTF8StringEncoding error:NULL];
    }
    
    // Add default.css
    htmlstring = [htmlstring stringByReplacingOccurrencesOfString:@"default.css" withString:[[NSBundle mainBundle] pathForResource:@"nodeui_default" ofType:@"css"]];
    [[webview mainFrame] loadHTMLString:htmlstring baseURL:[NSURL URLWithString:mixin.path]];
    
}
- (void)setTitle:(NSString *)newTitle {
    [window setTitle:newTitle];
    title = newTitle;
}
- (void)windowWillClose:(NSNotification *)notification {
    [[mixin windows] removeObject:self];
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        window = nil;
        webview = nil;
        onMessage = nil;
        onButtonClick = nil;
        onMessage = nil;
        onLoad = nil;
    });
}

- (void)setButtons:(NSArray *)btts {
    // Only allow setting buttons before we've run
    if (hasRun)
        return;
    buttons = [btts copy];
}
- (void)bottomButtonClicked:(id)sender {
//    NSLog(@"sender = %@", sender);
//    NSLog(@"[buttonObjects indexOfObject:sender] = %@", [buttonObjects indexOfObject:sender]);
//    NSLog(@"[buttons objectAtIndex:[buttonObjects indexOfObject:sender]] = %@", [buttons objectAtIndex:[buttonObjects indexOfObject:sender]]);
//    NSLog(@"callback = %@", [[buttons objectAtIndex:[buttonObjects indexOfObject:sender]] objectForKey:@"callback"]);
    NoddyFunction* callback = onButtonClick;//[[buttons objectAtIndex:[buttonObjects indexOfObject:sender]] objectForKey:@"callback"];
    callback.mixin = mixin;
    
    NoddyScheduleBlock(^ () {
        [callback call:nil arguments:[NSArray arrayWithObject:[sender title]]];
    });
}
- (void)show {
    [window deminiaturize:nil];
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


- (void)client_callFunctionNamed:(NSString*)functionName jsonArguments:(NSArray*)jsonedArguments {
//    NSLog(@"-client_callFunctionNamed: '%@' jsonArguments: '%@'", functionName, jsonedArguments);
    
    [self client_eval:[NSString stringWithFormat:@"((%@).apply({}, (%@)[0]))", functionName, jsonedArguments]];
}
- (void)client_callFunctionCode:(NSString*)functionString jsonArguments:(NSString*)jsonedArguments {
//    NSLog(@"-client_callFunctionCode: '%@' jsonArguments: '%@'", functionString, jsonedArguments);
    
    [self client_eval:[NSString stringWithFormat:@"((%@).apply({}, (%@)[0]))", functionString, jsonedArguments]];
}
- (void)client_eval:(NSString*)code {
//    NSLog(@"-client_eval: '%@'", code);
    WebScriptObject* wso = [webview windowScriptObject];
    [wso evaluateWebScript:code];
}
- (void)client_addFunction:(NSString*)functionString named:(NSString*)functionName {
//    NSLog(@"-client_addFunction: '%@' named: '%@'", functionString, functionName);
    NSString* code = [NSString stringWithFormat:@"window[\"%@\"] = %@;", functionName, functionString];
    [self client_eval:code];
}

- (void)serverAddFunction:(NSString*)functionString named:(NSString*)functionName {
//    NSLog(@"-serverAddFunction: '%@' named: '%@'", functionString, functionName);
    NSString* code = [NSString stringWithFormat:@"global[\"%@\"] = %@;\n", functionName, functionString];
    [self serverEval:code];
}
- (void)serverCallFunctionNamed:(NSString*)functionName jsonArguments:(NSArray*)jsonedArguments {
//    NSLog(@"-serverCallFunctionNamed: '%@' jsonArguments: '%@'", functionName, jsonedArguments);
    
    [self serverEval:[NSString stringWithFormat:@"(%@).apply({}, (%@)[0]);\n", functionName, jsonedArguments]];
}
- (void)serverCallFunctionCode:(NSString*)functionString jsonArguments:(NSArray*)jsonedArguments {
//    NSLog(@"-serverCallFunctionCode: '%@' jsonArguments: '%@'", functionString, jsonedArguments);
    
    [self serverEval:[NSString stringWithFormat:@"(%@).apply({}, (%@)[0]);\n", functionString, jsonedArguments]];
}
- (void)serverEval:(NSString*)code {
    NoddyScheduleBlock(^{
        
//        NSLog(@" SERVER EVAL: %@", code);
        // Create a stack-allocated handle scope.
        HandleScope handle_scope;
        
        // Create a string containing the JavaScript source code.
        Handle<String> source = String::New([code UTF8String]);
        
        // Compile the source code.
        Handle<Script> script = Script::Compile(source);
        
        // Run the script to get the result.
        script->Run();
    });
}
//- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame {
//    NSLog(@"[webview windowScriptObject] = %@", [webview windowScriptObject]);
//}
- (void)webView:(WebView *)webView didClearWindowObject:(WebScriptObject *)windowObject forFrame:(WebFrame *)frame {
    static NSString* nodeui_default_js;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        nodeui_default_js = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"nodeui_default" ofType:@"js"] encoding:NSUTF8StringEncoding error:NULL];
    });
    
    [windowObject setValue:self forKey:@"chocprivate"];
    [windowObject evaluateWebScript:nodeui_default_js];
    
    if (clientOnLoad) {
        [self client_callFunctionCode:clientOnLoad jsonArguments:[NSArray array]];
    }
    
    if (onLoad) {
        onLoad.mixin = mixin;
        NoddyScheduleBlock(^{
            [onLoad call:nil arguments:[NSArray array]];
        });
    }}

- (void)privateSendMessage:(NSString*)messagename arguments:(id)jsargs {
    if (onMessage) {
        onMessage.mixin = mixin;
        NoddyScheduleBlock(^{
            [onMessage call:nil arguments:[NSArray arrayWithObjects:messagename, jsargs, nil]];
        });
    }
}
+ (BOOL)isSelectorExcludedFromWebScript:(SEL)selector {
    return NO;
}
+ (BOOL)isKeyExcludedFromWebScript:(const char *)name {
    return NO;
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
- (void)client_sendMessage:(NSString*)message arguments:(NSString*)arguments {
    NSLog(@"client_sendMessage: '%@' arguments: '%@'", message, arguments);
    [self client_callFunctionNamed:@"noddy_private_receivedMessage"
                         arguments:[NSArray arrayWithObjects:message, arguments, nil]];
}
- (void)server_sendMessage:(NSString*)message arguments:(NSString*)arguments {
    
    NSLog(@"server_sendMessage: '%@' arguments: '%@'", message, arguments);
    if (onMessage) {
        onMessage.mixin = mixin;
        NoddyScheduleBlock(^{
            [onMessage call:nil arguments:[NSArray arrayWithObjects:message, arguments, nil]];
        });
    }
}

@end
