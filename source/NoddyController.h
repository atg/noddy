
@class NoddyThread;
@class CDEvents;

@interface NoddyController : NSObject {
    NoddyThread* thread;
    NSMutableArray* mixins;
    id eventMonitor;
}

@property (readonly) NoddyThread* thread;
@property (readonly) NSMutableArray* mixins;
@property (assign) CDEvents *events;

+ (id)sharedController;


// Search for mixins on disk
// Mixins can be in either
//   Chocolat.app/Contents/SharedSupport/Mixins
//   ~/Library/Application Support/Chocolat/Mixins
//   ~/.chocolat/mixins
- (void)reloadMixins;

@end