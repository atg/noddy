@interface NoddyController : NSObject {
    NoddyThread* thread;
    NSArray* mixins;
}

@property (readonly) NoddyThread* thread;
@property (readonly) NSArray* mixins;

+ (id)sharedController;
+ (id)sharedThread;

// Search for mixins on disk
// Mixins can be in either
//   Chocolat.app/Contents/SharedSupport/Mixins
//   ~/Library/Application Support/Chocolat/Mixins
//   ~/.chocolat/mixins
- (void)reloadMixins;

@end