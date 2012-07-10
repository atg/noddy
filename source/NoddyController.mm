#import "NoddyController.h"
#import "NoddyThread.h"

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
        [self.thread start];
    }
    
    return self;
}

- (NSArray *)mixins
{
    if (!_mixins) {
        [self reloadMixins];
    }
    
    return _mixins;
}

- (void)reloadMixins
{
    
}



@end