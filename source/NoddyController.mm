#import "NoddyController.h"
#import "NoddyThread.h"
#import "NoddyMixin.h"
#import "NoddyBridge.h"
#import <CDEvents/CDEvents.h>

@implementation NoddyController

@synthesize thread=_thread, mixins=_mixins, events=_events;

+ (id)sharedController
{
    static dispatch_once_t pred;
    static NoddyController *controller;
    dispatch_once(&pred, ^{controller = [[self alloc] init]; });
    return controller;
}

- (id)init
{
    if (self = [super init]) {
        // init
        NSLog(@"Starting our thread...");
        _thread = [[NoddyThread alloc] init];
        _mixins = [[NSMutableArray alloc] init];
        [self.thread start];
        //[self reloadMixins];
        // keyboard events...
        eventMonitor = [NSEvent addLocalMonitorForEventsMatchingMask:NSKeyUpMask
                                                             handler:^NSEvent *(NSEvent *e) {
                                                                 // loop v_v
                                                                 for (NoddyMixin *aMixin in self.mixins) {
                                                                     for (NSDictionary *sc in aMixin.keyboardShortcuts) {
                                                                         NSNumber *lModifiers = [NSNumber numberWithUnsignedInteger:[e modifierFlags]];
                                                                         NSUInteger lUFlags = ([lModifiers unsignedIntegerValue] & NSDeviceIndependentModifierFlagsMask);
                                                                         NSString *lString = [e charactersIgnoringModifiers];
                                                                         if ([[sc objectForKey:@"Modifiers"] unsignedIntegerValue] == lUFlags &&
                                                                             [[sc objectForKey:@"KeyEquiv"] caseInsensitiveCompare:lString] == NSOrderedSame) {
                                                                             
                                                                             NoddyFunction *myCallback = [sc objectForKey:@"Callback"];
                                                                             myCallback.mixin = aMixin;
                                                                             NoddyScheduleBlock(^ () {
                                                                                 [myCallback call:nil arguments:nil];
                                                                             });
                                                                         }
                                                                     }
                                                                 }
                                                                 return e;
                                                             }];
    }
    
    return self;
}



- (void)reloadMixins
{
    [self.mixins removeAllObjects];
    self.events = nil;
    // an URL watcher...
    NSMutableArray *urlsToWatch = [[NSMutableArray alloc] init];
    
    // load mixins from disk...
    // first, sharedsupport
    NSString *sharedSupportPath = [[[NSBundle mainBundle] sharedSupportPath] stringByAppendingPathComponent:@"Mixins"];
    
    // App Support
    NSString *executableName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
    NSArray *basePaths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *appSupportPath = [[[basePaths objectAtIndex:0] stringByAppendingPathComponent:executableName] stringByAppendingPathComponent:@"Mixins"];
    
    // home dir
    NSString *homePath = [NSHomeDirectory() stringByAppendingPathComponent:@".chocolat/mixins/"];
    
    // Miximons, gotta load'em all!
    for (NSString *aPath in [[NSFileManager defaultManager] subpathsAtPath:sharedSupportPath]) {
        if ([[aPath pathExtension] isEqualToString:@"chocmixin"]) {
            NoddyMixin *newMixin = [[NoddyMixin alloc] initWithPath:[sharedSupportPath stringByAppendingPathComponent:aPath]];
            [newMixin reload];
            [self.mixins addObject:newMixin];
            [urlsToWatch addObject:[sharedSupportPath stringByAppendingPathComponent:aPath]];
        }
    }
    
    for (NSString *aPath in [[NSFileManager defaultManager] subpathsAtPath:appSupportPath]) {
        if ([[aPath pathExtension] isEqualToString:@"chocmixin"]) {
            NoddyMixin *newMixin = [[NoddyMixin alloc] initWithPath:[appSupportPath stringByAppendingPathComponent:aPath]];
            [newMixin reload];
            [self.mixins addObject:newMixin];
            [urlsToWatch addObject:[appSupportPath stringByAppendingPathComponent:aPath]];
        }
    }
    
    for (NSString *aPath in [[NSFileManager defaultManager] subpathsAtPath:homePath]) {
        if ([[aPath pathExtension] isEqualToString:@"chocmixin"]) {
            NoddyMixin *newMixin = [[NoddyMixin alloc] initWithPath:[homePath stringByAppendingPathComponent:aPath]];
            [newMixin reload];
            [self.mixins addObject:newMixin];
            
            [urlsToWatch addObject:[NSURL fileURLWithPath:[homePath stringByAppendingPathComponent:aPath]]];
            
        }
    }
    
    // add a watch for those urls
    if ([urlsToWatch count] > 0) {
        self.events = [[CDEvents alloc] initWithURLs:urlsToWatch
                                               block:[^(CDEvents *watcher, CDEvent *event) {
            // a change! reload that mixin...
            //NSLog(@"URLWatcher: %@\n%@", event, self);
            for (NoddyMixin *aMixin in self.mixins) {
                if([[NSURL fileURLWithPath:aMixin.path] isEqualTo:event.URL]) {
                    NSLog(@"Found the culprit!");
                    [aMixin reload];
                }
            }
            
        } copy]];
    }
    
}



@end