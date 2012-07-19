#import <Foundation/Foundation.h>
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

@interface NoddyFunction : NSObject {
    v8::Persistent<v8::Function> func;
}

- (id)initWithFunction:(v8::Handle<v8::Function>)funcHandle;
- (v8::Local<v8::Value>)basicCall:(v8::Handle<v8::Object>)thisObject arguments:(v8::Handle<v8::Array>)args;
- (id)call:(id)thisObject arguments:(NSArray*)args;
- (v8::Local<v8::Function>)functionValue;

@end

/*
 #define ENSUREERROR(value, name) { NSLog("Error in [%@ %@]: %s was %@", [self class], NSStringFromSelector(_cmd), name, value); return nil; }
 #define ENSURE_STRING(x) if (![x isKindOfClass:[NSString class]]) { ENSUREERROR(x, #x); }
 #define ENSURE_NUMBER(x) if (![x isKindOfClass:[NSNumber class]]) { ENSUREERROR(x, #x); }
 #define ENSURE_ARRAY(x) if (![x isKindOfClass:[NSArray class]]) { ENSUREERROR(x, #x); }
 #define ENSURE_DICTIONARY(x) if (![x isKindOfClass:[NSDictionary class]]) { ENSUREERROR(x, #x); }
 #define ENSURE_STRING_ARRAY(x) if (![x isKindOfClass:[NSArray class]]) return nil; for (id y in x) { ENSURE_STRING(y); }
 #define ENSURE_NUMBER_ARRAY(x) if (![x isKindOfClass:[NSArray class]]) return nil; for (id y in x) { ENSURE_NUMBER(y); }
 */
