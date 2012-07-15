#import "NoddyController.h"
#import "NoddyThread.h"
#import "NoddyMixin.h"

@implementation NoddyController

@synthesize thread=_thread, mixins=_mixins;

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
    }
    
    return self;
}



- (void)reloadMixins
{
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
        }
    }
    
    for (NSString *aPath in [[NSFileManager defaultManager] subpathsAtPath:appSupportPath]) {
        if ([[aPath pathExtension] isEqualToString:@"chocmixin"]) {
            NoddyMixin *newMixin = [[NoddyMixin alloc] initWithPath:[appSupportPath stringByAppendingPathComponent:aPath]];
            [newMixin reload];
            [self.mixins addObject:newMixin];
        }
    }
    
    for (NSString *aPath in [[NSFileManager defaultManager] subpathsAtPath:homePath]) {
        if ([[aPath pathExtension] isEqualToString:@"chocmixin"]) {
            NoddyMixin *newMixin = [[NoddyMixin alloc] initWithPath:[homePath stringByAppendingPathComponent:aPath]];
            [newMixin reload];
            [self.mixins addObject:newMixin];
        }
    }
    
}



@end