#import "NoddyMixin.h"
#import "NoddyIndirectObjects.h"

@implementation NoddyMixin

@synthesize path=_path, info=_info, timestamp=_timestamp;
@synthesize noddyID=_noddyID;

- (id)initWithPath:(NSString *)p
{
    if (self = [super init]) {
        NSLog(@"Mixin Loaded");
        self.path = p;
        
        NSError *e = nil;
        NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:self.path
                                                                               error:&e];
        if (!e) {
            self.timestamp = [attrs objectForKey:NSFileModificationDate];
        }
        
        self.noddyID = [[NoddyIndirectObjects globalContext] generateAndSetIDForObject:self];
    }
    
    return self;
}


#pragma mark - Loading
- (void)load
{
    
}

- (void)reload
{
    
}

- (void)unload
{
    
}

@end