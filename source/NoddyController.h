
@class NoddyThread;

@interface NoddyController : NSObject {
    NoddyThread* thread;
    NSMutableArray* mixins;
}

@property (readonly) NoddyThread* thread;
@property (readonly) NSMutableArray* mixins;

+ (id)sharedController;

// Search for mixins on disk
// Mixins can be in either
//   Chocolat.app/Contents/SharedSupport/Mixins
//   ~/Library/Application Support/Chocolat/Mixins
//   ~/.chocolat/mixins
- (void)reloadMixins;

@end