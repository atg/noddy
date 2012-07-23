#import "NoddyMixin+NoddyAPI.h"
#import "NSString+Utilities.h"

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


@end
