#import "NoddyMixin+NoddyAPI.h"

static NSString* string_default(NSString* str, NSString* defaultStr) {
    if ([str length])
        return str;
    return defaultStr;
}
static id collection_default(id coll, id defaultColl) {
    if ([coll count])
        return coll;
    return defaultColl;
}


@implementation NoddyMixin (NoddyAPI)

- (NSNumber*)showAlert:(NSDictionary*)options {
    NSLog(@"options = %@", options);
    NSAlert* alert = [[NSAlert alloc] init];
    [alert setMessageText:string_default([options objectForKey:@"title"], @"Alert")];
    [alert setInformativeText:string_default([options objectForKey:@"message"], @"")];
    
    for (NSString* buttonTitle in collection_default([options objectForKey:@"buttons"], [NSArray arrayWithObject:@"OK"])) {
        [alert addButtonWithTitle:buttonTitle];
    }
    
    return [NSNumber numberWithInteger:[alert runModal] - NSAlertFirstButtonReturn];
}

@end
