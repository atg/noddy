#import "NoddyMixin.h"
#import <Cocoa/Cocoa.h>

@interface NoddyMixin (NoddyAPI)

- (NSNumber*)showAlert:(NSDictionary*)options;

// Clipboard.js
- (void)clipboard_copy:(NSString *)value;

@end
