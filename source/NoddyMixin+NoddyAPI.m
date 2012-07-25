#import "NoddyMixin+NoddyAPI.h"
#import "NSString+Utilities.h"
#import "NSArray+Utilities.h"
#import "NoddyWindow.h"

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

static NSString* sluggify(NSString *str) { 
    NSCharacterSet *badChar = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    NSString *rep = [[[[[str stringByTrimmingCharactersInSet:badChar] componentsSeparatedByCharactersInSet:badChar] arrayByRemovingObjectsEqualTo:@""] componentsJoinedByString:@"-"] lowercaseString];
    return rep;
}

static NSDictionary *shortcut_for_string(NSString *str) {
    NSUInteger modifiers = 0;
    NSMutableString *leKeyEquiv = [[NSMutableString alloc] init];
    unichar functionCharacter = 0;
    
    if ([str length] <= 0)
        return nil;
    
    if ([str caseInsensitiveContains:@"cmd"] ||
        [str caseInsensitiveContains:@"command"]) {
        modifiers |= NSCommandKeyMask;
    }
    if ([str caseInsensitiveContains:@"ctrl"] ||
        [str caseInsensitiveContains:@"control"]) {
        modifiers |= NSControlKeyMask;
    }
    if ([str caseInsensitiveContains:@"alt"] ||
        [str caseInsensitiveContains:@"opt"]) {
        modifiers |= NSAlternateKeyMask;
    }
    if ([str caseInsensitiveContains:@"shift"]) {
        modifiers |= NSShiftKeyMask;
    }
    if ([str caseInsensitiveContains:@"cap"]) {
        modifiers |= NSAlphaShiftKeyMask;
    }
    
    // special keys
    if([str caseInsensitiveContains:@"enter"])
        [leKeyEquiv appendFormat:@"%C", (unichar)NSEnterCharacter];
    else if([str caseInsensitiveContains:@"return"])
        [leKeyEquiv appendString:@"\n"];
    else if([str caseInsensitiveContains:@"esc"])
        [leKeyEquiv appendFormat:@"%c", 0x1B];
    else if([str caseInsensitiveContains:@"pageup"])
        [leKeyEquiv appendFormat:@"%C", (unichar)NSPageUpFunctionKey];
    else if([str caseInsensitiveContains:@"pagedown"])
        [leKeyEquiv appendFormat:@"%C", (unichar)NSPageDownFunctionKey];
    else if([str caseInsensitiveContains:@"clear"] ||
            [str caseInsensitiveContains:@"clr"])
        [leKeyEquiv appendFormat:@"%C", (unichar)NSClearLineFunctionKey];
    else if([str caseInsensitiveContains:@"up"])
        [leKeyEquiv appendFormat:@"%C", (unichar)NSUpArrowFunctionKey];
    else if([str caseInsensitiveContains:@"right"])
        [leKeyEquiv appendFormat:@"%C", (unichar)NSRightArrowFunctionKey];
    else if([str caseInsensitiveContains:@"down"])
        [leKeyEquiv appendFormat:@"%C", (unichar)NSDownArrowFunctionKey];
    else if([str caseInsensitiveContains:@"left"])
        [leKeyEquiv appendFormat:@"%C", (unichar)NSLeftArrowFunctionKey];
    else if([str caseInsensitiveContains:@"backspace"])
        [leKeyEquiv appendFormat:@"%C", (unichar)NSBackspaceCharacter];
    else if([str caseInsensitiveContains:@"space"] ||
            [str caseInsensitiveContains:@"spc"])
        [leKeyEquiv appendFormat:@"%c", 0x20];
    else if([str caseInsensitiveContains:@"tab"])
        [leKeyEquiv appendFormat:@"%C", (unichar)NSTabCharacter];
    else if([str caseInsensitiveContains:@"delete"] ||
            [str caseInsensitiveContains:@"del"])
        [leKeyEquiv appendFormat:@"%C", (unichar)NSDeleteCharacter];
    
    else if([str caseInsensitiveContains:@"home"])
        [leKeyEquiv appendFormat:@"%C", (unichar)NSHomeFunctionKey];
    else if([str caseInsensitiveContains:@"end"])
        [leKeyEquiv appendFormat:@"%C", (unichar)NSEndFunctionKey];
    
    // F1 to F3245
    for (int fk = 1; fk <= 35 ; fk++) {
        NSString *strToFind = [NSString stringWithFormat:@"f%d", fk];
        if ([str caseInsensitiveContains:strToFind]) {
            // ok! we found an F key...
            functionCharacter = fk - 1 + NSF1FunctionKey;
            [leKeyEquiv appendFormat:@"%C", functionCharacter];
            break;
        }
    }
    
    // and finally!
    if ([leKeyEquiv length] <= 0) {
        NSRange r =[str rangeOfComposedCharacterSequencesForRange:NSMakeRange([str length] - 1, 1)];
        [leKeyEquiv appendString:[str substringWithRange:r]];
    }
    
    return [NSDictionary dictionaryWithObjectsAndKeys:leKeyEquiv, @"KeyEquiv",
            [NSNumber numberWithUnsignedInteger:modifiers], @"Modifiers", nil];
    
}


static NSMenuItem *menu_item_for_path(NSString *path)
{
    NSArray *menuItems = [path componentsSeparatedByString:@"/"];
    int cnt = 0;
    
    NSMenu *rootMenu = [NSApp mainMenu];
    NSMenuItem *lastItem = nil;
    for (NSString *anItem in menuItems) {
        for (NSMenuItem *aMenuItem in [rootMenu itemArray]) {
            if ([sluggify(aMenuItem.title) isEqualToString:anItem] && aMenuItem.hasSubmenu) {
                rootMenu = aMenuItem.submenu;
                cnt++;
                break;
            } else if([sluggify(aMenuItem.title) isEqualToString:anItem] && !aMenuItem.hasSubmenu) {
                lastItem = aMenuItem;
                cnt++;
                break;
            }
        }
        // we should've found a menu for this:
        
    }
    //CHDebug(@"Menu Item: %@", lastItem);
    if (cnt == [menuItems count])
        return lastItem;
    return nil;
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

#pragma mark - Hooks

- (void)ui_addKeyboardShortcut:(NSDictionary *)options
{
    // make sure that shortcut is valid...
    NSDictionary *shortcut = shortcut_for_string([options objectForKey:@"shortcut"]);
    if (shortcut) {
        // do something!
    }
}

- (void)ui_addMenuItem:(NSDictionary *)options
{
    // make sure that shortcut is valid...
    NSDictionary *shortcut = shortcut_for_string([options objectForKey:@"shortcut"]);
    NSString *path = [options objectForKey:@"path"];
    NSArray *menuItems = [path componentsSeparatedByString:@"/"];    
    NSMenu *rootMenu = [NSApp mainMenu];
    
    for (int i = 0; i < [menuItems count]; i++) {
        NSString *anItem = [menuItems objectAtIndex:i];
        BOOL menuExists = NO;
        if (i < [menuItems count] - 1) {
            
            for (NSMenuItem *aMenuItem in [rootMenu itemArray]) {
                if ([aMenuItem.title caseInsensitiveCompare:anItem] == NSOrderedSame
                    && aMenuItem.hasSubmenu) {
                    rootMenu = aMenuItem.submenu;
                    menuExists = YES;
                }
            }
            if (!menuExists) {
                // create it, and set as root?!
                NSMenuItem *newItem = [[NSMenuItem alloc] initWithTitle:anItem
                                                                 action:NULL
                                                          keyEquivalent:@""];
                NSMenu *newMenu = [[NSMenu alloc] initWithTitle:anItem];
                newItem.submenu = newMenu;
                [rootMenu addItem:newItem];
                rootMenu = newItem.submenu;
            }
            
            
        } else {
            // last item... insert here!
            NSMenuItem *newItem = [[NSMenuItem alloc] initWithTitle:anItem
                                                             action:NULL
                                                      keyEquivalent:@""];
            [rootMenu addItem:newItem];
        }
    }
    
    
    
}

#pragma mark - Windows

- (NoddyWindow*)createWindow:(NSString*)kind {
    NSLog(@"classname = %@", [@"Noddy" stringByAppendingFormat:kind]);
    NSLog(@"class = %@", NSClassFromString([@"Noddy" stringByAppendingFormat:kind]) );
    NoddyWindow* w = [[NSClassFromString([@"Noddy" stringByAppendingFormat:kind]) alloc] init];
    w.mixin = self;
    return w;
}

@end
