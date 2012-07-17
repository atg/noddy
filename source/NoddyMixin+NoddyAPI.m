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

#pragma mark - Alert
- (NSNumber*)showAlert:(NSDictionary*)options {
    NSAlert* alert = [[NSAlert alloc] init];
    [alert setMessageText:string_default([options objectForKey:@"title"], @"Alert")];
    [alert setInformativeText:string_default([options objectForKey:@"message"], @"")];
    
    for (NSString* buttonTitle in collection_default([options objectForKey:@"buttons"], [NSArray arrayWithObject:@"OK"])) {
        [alert addButtonWithTitle:buttonTitle];
    }
    
    return [NSNumber numberWithInteger:[alert runModal] - NSAlertFirstButtonReturn];
}

#pragma mark - Clipboard
- (void)clipboard_copy:(NSString *)value
{
    [[NSPasteboard generalPasteboard] writeObjects:[NSArray arrayWithObject:value]];
}

- (id)clipboard_paste
{
    NSArray *items = [[NSPasteboard generalPasteboard] readObjectsForClasses:[NSArray arrayWithObject:[NSString class]]
                                                                     options:nil];
    if (items.count > 0) {        
        return [items objectAtIndex:0];
    }
    
    return nil;
}

@end
