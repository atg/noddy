#import "NoddyMixin.h"
#import "NoddyIndirectObjects.h"
#import "NoddyThread.h"
#import "NoddyWindow.h"

@implementation NoddyMixin

// storage for cleanup
@synthesize windows=_windows, keyboardShortcuts=_keyboardShortcuts, menuItems=_menuItems;
// other prop...
@synthesize path=_path, info=_info, timestamp=_timestamp;
@synthesize noddyID=_noddyID;
@synthesize name=_name;

- (id)initWithPath:(NSString *)p
{
    if (self = [super init]) {
        NSLog(@"Loading mixin %@", [p stringByAbbreviatingWithTildeInPath]);
        self.windows = [NSMutableArray array];
        self.keyboardShortcuts = [NSMutableArray array];
        self.menuItems = [NSMutableArray array];
        self.path = p;
        self.name = [[self.path lastPathComponent] stringByDeletingPathExtension];
        NSError *e = nil;
        NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:self.path
                                                                               error:&e];
        if (!e) {
            self.timestamp = [attrs objectForKey:NSFileModificationDate];
        }
        
        self.noddyID = [NSString stringWithFormat:@"NODDYID$$MIXIN$$%@", [[p lastPathComponent] stringByDeletingPathExtension]];
        [[NoddyIndirectObjects globalContext] registerID:self.noddyID object:self];
        
    }
    
    return self;
}


#pragma mark - Loading
- (void)load
{
    [NoddyThread callGlobalFunction:@"load_initjs" arguments:[NSArray arrayWithObjects:self.path, self.noddyID, nil]];
}

- (void)reload
{
    [self unload];
    [self load];
}

- (void)unload
{
    // remove our menu items
    for (NSMenuItem *anItem in self.menuItems) {
        [anItem.menu removeItem:anItem];
    }
    for (NoddyWindow* window in self.windows) {
        [window close];
    }
    
    [self.menuItems removeAllObjects];
    [self.keyboardShortcuts removeAllObjects];
    [self.windows removeAllObjects];
}

@end