@interface NoddyMixin : NSObject

// The location of the mixin on disk
@property (assign) NSString* path;

// Not needed yet. Mixins that use txtar will need to be expanded into a temporary directory
// @property (assign) NSString* expandedPath;

// The timestamp on the mixin, so we know whether it's been changed and needs to be reloaded
@property (assign) time_t timestamp;

// The contents of the info.json file
@property (assign) NSDictionary* info;

- (id)initWithPath:(NSString*)p;
- (void)reload;

- (id)noddyID;

// 
- (NSString*)execute:(NSString*)js;

@end
