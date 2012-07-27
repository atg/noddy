#import <Foundation/Foundation.h>
@class NoddyMixin;

#ifdef __cplusplus
#import <node.h>

v8::Handle<v8::Value> noddy_objc_msgSend(const v8::Arguments& args);

NSRegularExpressionOptions node_regex_flags_to_cocoa(v8::RegExp::Flags flags);
v8::RegExp::Flags cocoa_regex_flags_to_node(NSRegularExpressionOptions opts);

v8::Local<v8::Value> cocoa_to_node(id x);
id node_string_to_cocoa(v8::Handle<v8::String> str);
NSNumber* node_number_to_cocoa(v8::Handle<v8::Number> num);
NSArray* node_array_to_cocoa(v8::Handle<v8::Array> arr);
NSDictionary* node_object_to_cocoa(v8::Handle<v8::Object> obj);
id node_to_cocoa(v8::Handle<v8::Value> val);
#endif

@interface NoddyFunction : NSObject {
#ifdef __cplusplus
    v8::Persistent<v8::Function> func;
#endif
}

@property (assign) __weak NoddyMixin* mixin;

#ifdef __cplusplus
- (id)initWithFunction:(v8::Handle<v8::Function>)funcHandle;
- (v8::Local<v8::Value>)basicCall:(v8::Handle<v8::Object>)thisObject arguments:(v8::Handle<v8::Array>)args;
- (v8::Local<v8::Function>)functionValue;
#endif

- (id)call:(id)thisObject arguments:(NSArray*)args;

@end

#ifndef ENSUREERROR
static inline BOOL IS_NULL(id x) {
    return !x || x == [NSNull null];
}
static inline BOOL IS_STRING(id x) {
    return [x isKindOfClass:[NSString class]];
}
static inline BOOL IS_NUMBER(id x) {
    return [x isKindOfClass:[NSNumber class]];
}
static inline BOOL IS_DATE(id x) {
    return [x isKindOfClass:[NSDate class]];
}
static inline BOOL IS_ARRAY(id x) {
    return [x isKindOfClass:[NSArray class]];
}
static inline BOOL IS_FUNCTION(id x) {
    return [x isKindOfClass:[NoddyFunction class]];
}
static inline BOOL IS_ARRAY_OF(id x, BOOL(*f)(id v)) {
    if (!IS_ARRAY(x))
        return NO;
    for (id v in x) {
        if (!f(v))
            return NO;
    }
    return YES;
}
static inline BOOL IS_DICTIONARY_OF(id x, BOOL(*f)(id v)) {
    if (!IS_ARRAY(x))
        return NO;
    for (id k in x) {
        if (!IS_STRING(k))
            return NO;
        id v = [x objectForKey:k];
        if (!f(v))
            return NO;
    }
    return YES;
}
static inline BOOL IS_RANGE(NSValue* x) {
    if (!x || ![x isKindOfClass:[NSValue class]])
        return NO;
    
    const char* objctype = [x objCType];
    if (strcmp(objctype, @encode(NSRect)) != 0)
        return NO;
    return YES;
}
static inline BOOL IS_SIZE(NSValue* x) {
    if (!x || ![x isKindOfClass:[NSValue class]])
        return NO;
    
    const char* objctype = [x objCType];
    if (strcmp(objctype, @encode(NSSize)) != 0)
        return NO;
    return YES;
}
static inline BOOL IS_POINT(NSValue* x) {
    if (!x || ![x isKindOfClass:[NSValue class]])
        return NO;
    
    const char* objctype = [x objCType];
    if (strcmp(objctype, @encode(NSPoint)) != 0)
        return NO;
    return YES;
}
static inline BOOL IS_RECT(NSValue* x) {
    if (!x || ![x isKindOfClass:[NSValue class]])
        return NO;
    
    const char* objctype = [x objCType];
    if (strcmp(objctype, @encode(NSRect)) != 0)
        return NO;
    return YES;
}


    
    #define ENSUREERROR(value, name) { NSLog("Error in [%@ %@]: %s was %@", [self class], NSStringFromSelector(_cmd), name, value); return nil; }
    #define ENSURE_STRING(x) if (![x isKindOfClass:[NSString class]]) { ENSUREERROR(x, #x); }
    #define ENSURE_NUMBER(x) if (![x isKindOfClass:[NSNumber class]]) { ENSUREERROR(x, #x); }
    #define ENSURE_ARRAY(x) if (![x isKindOfClass:[NSArray class]]) { ENSUREERROR(x, #x); }
    #define ENSURE_DICTIONARY(x) if (![x isKindOfClass:[NSDictionary class]]) { ENSUREERROR(x, #x); }
    #define ENSURE_STRING_ARRAY(x) if (![x isKindOfClass:[NSArray class]]) return nil; for (id y in x) { ENSURE_STRING(y); }
    #define ENSURE_NUMBER_ARRAY(x) if (![x isKindOfClass:[NSArray class]]) return nil; for (id y in x) { ENSURE_NUMBER(y); }
#endif