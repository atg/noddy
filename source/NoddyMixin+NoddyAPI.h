#import "NoddyMixin.h"
#import <Cocoa/Cocoa.h>

@interface NoddyMixin (NoddyAPI)

- (NSNumber*)showAlert:(NSDictionary*)options;

// Clipboard.js
- (void)clipboard_copy:(NSString *)value;

// UI/Hooks
- (void)ui_addMenuItem:(NSDictionary *)options;
- (void)executeNoddyFunctionForMenuItem:(id)sender;
@end
