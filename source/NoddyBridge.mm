#import "NoddyBridge.h"
#import "NoddyIndirectObjects.h"
#import "NoddyThread.h"

using namespace v8;

NSRegularExpressionOptions node_regex_flags_to_cocoa(RegExp::Flags flags) {
    NSRegularExpressionOptions opts = 0;
    
    // We have no equivalent to this: if (flags & RegExp::kGlobal)
    if (flags & RegExp::kIgnoreCase)
        opts |= NSRegularExpressionCaseInsensitive;
    if (flags & RegExp::kMultiline)
        opts |= NSRegularExpressionAnchorsMatchLines;
    
    return opts;
}
RegExp::Flags cocoa_regex_flags_to_node(NSRegularExpressionOptions opts) {
    unsigned flags = 0;
    
    if (opts & NSRegularExpressionCaseInsensitive)
        flags |= RegExp::kIgnoreCase;
    if (opts & NSRegularExpressionAnchorsMatchLines)
        flags |= RegExp::kMultiline;
    
    return (RegExp::Flags)flags;
}

id target_from_receiver_string(NSString* str) {
    return [[NoddyIndirectObjects globalContext] objectForID:str];
}

Local<Value> cocoa_to_node(id x) {
    HandleScope scope;
    if (x == nil || x == [NSNull null])
        return scope.Close(Local<Primitive>::New(Null()));
    
    if ([x respondsToSelector:@selector(noddyID)])
        return cocoa_to_node([x noddyID]);
    
    if ([x isKindOfClass:[NSValue class]]) {
        const char* objctype = [x objCType];
        
        if (strcmp(objctype, @encode(NSRange)) == 0) {
            Local<Object> obj = Object::New();
            NSRange range = [x rangeValue];
            obj->Set(String::New("location"), Number::New(range.location));
            obj->Set(String::New("length"),   Number::New(range.length));
            return scope.Close(obj);
        }
        if (strcmp(objctype, @encode(NSSize)) == 0) {
            Local<Object> obj = Object::New();
            NSSize size = [x sizeValue];
            obj->Set(String::New("width"), Number::New(size.width));
            obj->Set(String::New("height"), Number::New(size.height));
            return scope.Close(obj);
        }
        if (strcmp(objctype, @encode(NSPoint)) == 0) {
            Local<Object> obj = Object::New();
            NSPoint point = [x pointValue];
            obj->Set(String::New("x"), Number::New(point.x));
            obj->Set(String::New("y"), Number::New(point.y));
            return scope.Close(obj);
        }
        if (strcmp(objctype, @encode(NSRect)) == 0) {
            Local<Object> obj = Object::New();
            NSRect rect = [x rectValue];
            obj->Set(String::New("x"), Number::New(rect.origin.x));
            obj->Set(String::New("y"), Number::New(rect.origin.y));
            obj->Set(String::New("width"), Number::New(rect.size.width));
            obj->Set(String::New("height"), Number::New(rect.size.height));
            return scope.Close(obj);
        }
        
        if ([x isKindOfClass:[NSNumber class]]) {
            if (strcmp(objctype, @encode(BOOL)) == 0) {
                signed char v = [x unsignedCharValue];
                if (v == 0)
                    return Local<v8::Boolean>::New(False());
                if (v == 1)
                    return Local<v8::Boolean>::New(True());
            }
            return scope.Close(Number::New([x doubleValue]));
        }
        
        if (strcmp(objctype, @encode(void*)) == 0) {
            return scope.Close(External::New([x pointerValue]));
        }
    }
    
    if ([x isKindOfClass:[NSString class]]) {
        size_t length = [x length];
        uint16_t* characters = new uint16_t[length + 1];
        [x getCharacters:characters range:NSMakeRange(0, length)];
        characters[length] = 0;
        
        Local<String> s = String::New(characters, length);
        
        delete[] characters;
        return scope.Close(s);
    }
    
    if ([x isKindOfClass:[NSArray class]]) {
        uint32_t length = [x count];
        Local<Array> arr = Array::New(length);
        for (uint32_t i = 0; i < length; i++) {
            arr->Set(i, cocoa_to_node([x objectAtIndex:i]));
        }
        return scope.Close(arr);
    }
    
    if ([x isKindOfClass:[NSDictionary class]]) {
        Local<Object> obj = Object::New();
        for (id key in x) {
            Local<Value> js_key = cocoa_to_node(key);
            Local<Value> js_value = cocoa_to_node([x objectForKey:key]);
            obj->Set(js_key, js_value);
        }
        return scope.Close(obj);
    }
    
    if ([x isKindOfClass:[NSDate class]])
        return scope.Close(Date::New([x timeIntervalSince1970]));
    
    if ([x isKindOfClass:[NoddyFunction class]])
        return scope.Close([x functionValue]);
    
    if ([x isKindOfClass:NSClassFromString(@"NSRegularExpression")]) {
        return scope.Close(RegExp::New(cocoa_to_node([x pattern]).As<String>(), cocoa_regex_flags_to_node([x options])));
    }
    
    return scope.Close(Local<Primitive>::New(Null()));
}

id node_string_to_cocoa(Handle<String> str) {
    HandleScope scope;
    String::Value s(str);
    NSString* objcstr = [NSString stringWithCharacters:*s length:s.length()];
    
    if ([objcstr hasPrefix:@"NODDYID$$"])
        return [[NoddyIndirectObjects globalContext] objectForID:objcstr];
    
    return objcstr;
}
NSNumber* node_number_to_cocoa(Handle<Number> num) {
    HandleScope scope;
    return [NSNumber numberWithDouble:num->Value()];
}
NSArray* node_array_to_cocoa(Handle<Array> arr) {
    HandleScope scope;
    uint32_t length = arr->Length();
    NSMutableArray* arrobj = [NSMutableArray arrayWithCapacity:length];
    for (uint32_t i = 0; i < length; i++) {
        [arrobj addObject:node_to_cocoa(arr->Get(i)) ?: [NSNull null]];
    }
    return arrobj;
}
NSDictionary* node_object_to_cocoa(Handle<Object> obj) {
    HandleScope scope;
    Local<Array> keys = obj->GetOwnPropertyNames();
    uint32_t length = keys->Length();
    NSMutableDictionary* dictobj = [NSMutableDictionary dictionaryWithCapacity:length];
    for (uint32_t i = 0; i < length; i++) {
        Local<Value> jskey = keys->Get(i);
        id key = node_to_cocoa(jskey) ?: [NSNull null];
        id value = node_to_cocoa(obj->Get(jskey)) ?: [NSNull null];
        
        [dictobj setObject:value forKey:key];
    }
    return dictobj;
}

id node_to_cocoa(Handle<Value> val) {
    HandleScope scope;
    if (val->IsUndefined() || val->IsNull())
        return nil;
    if (val->IsTrue())
        return [NSNumber numberWithBool:YES];
    if (val->IsFalse())
        return [NSNumber numberWithBool:NO];
    if (val->IsArray())
        return node_array_to_cocoa(val.As<Array>());
    if (val->IsString())
        return node_string_to_cocoa(val.As<String>());
    if (val->IsNumber())
        return node_number_to_cocoa(val.As<Number>());
    
    if (val->IsInt32())
        return [NSNumber numberWithInt:val->Int32Value()];
    if (val->IsUint32())
        return [NSNumber numberWithUnsignedInt:val->Uint32Value()];
    if (val->IsBooleanObject())
        return [NSNumber numberWithBool:val.As<BooleanObject>()->BooleanValue()];
    if (val->IsNumberObject())
        return [NSNumber numberWithDouble:val.As<NumberObject>()->NumberValue()];
    if (val->IsStringObject())
        return node_string_to_cocoa(val.As<StringObject>()->StringValue());
    if (val->IsDate())
        return [NSDate dateWithTimeIntervalSince1970:val.As<Date>()->NumberValue()];
    
    if (val->IsExternal())
        return [NSValue valueWithPointer:val.As<External>()->Value()];    
    if (val->IsFunction())
        return [[NoddyFunction alloc] initWithFunction:val.As<Function>()];
    if (val->IsRegExp())
        return [NSClassFromString(@"NSRegularExpression")
                regularExpressionWithPattern:node_string_to_cocoa(val.As<RegExp>()->GetSource())
                options:node_regex_flags_to_cocoa(val.As<RegExp>()->GetFlags())
                error:NULL
                ];
    if (val->IsObject())
        return node_object_to_cocoa(val.As<Object>());

//    if (val.IsNativeError())
//        return .. no idea;
    return nil;
}

Handle<Value> noddy_objc_msgSend(const Arguments& args) {
    HandleScope scope;
    
    Local<Object> thisObject = args.This();
    bool isSync = thisObject->Has(String::New("sync")) && thisObject->Get(String::New("sync"))->BooleanValue();
    
    // Determine the target
    Local<String> receiver = args[0].As<String>();
    id target = node_to_cocoa(receiver);
    if (![target respondsToSelector:@selector(noddyID)]) {
        NSLog(@"Error target %@ does not have a noddyID", target);
        return Undefined();
    }
    
    // Get the selector
    Local<String> selector = args[1].As<String>();
    // How many objects do we have?
    NSMutableString* selectorstring = [node_to_cocoa(selector) mutableCopy];
    // Delete all colons to find out how many it has. E.g. [@"a:b:c:" length] - [@"abc" length] == 3
    long numberOfParameters = [selectorstring length] - [[selectorstring stringByReplacingOccurrencesOfString:@":" withString:@""] length];
    
    // Get the parameters
    NSMutableArray* objcArgs = [NSMutableArray array];
    for (long i = 0; i < numberOfParameters; i++) {
        [objcArgs addObject:node_to_cocoa(args[i + 2])];
    }
    
    NSMethodSignature *signature = [target methodSignatureForSelector:NSSelectorFromString(selectorstring)];
    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:signature];
    
    dispatch_block_t invocationBlock = ^{
        [invocation setTarget:target];
        [invocation setSelector:NSSelectorFromString(selectorstring)];
        
        for (long i = 0; i < numberOfParameters; i++) {
            id argObj = [objcArgs objectAtIndex:i];
            [invocation setArgument:&argObj atIndex:i + 2];
        }
        
        // Send the message!
        [invocation invoke];
    };
    
    if (isSync) {
        
        dispatch_sync(dispatch_get_main_queue(), invocationBlock);
        
        if (![signature methodReturnLength])
            return Local<Primitive>::New(Undefined());
        
        id returnvalue = nil;
        [invocation getReturnValue:&returnvalue];
        
        Local<Object> result = cocoa_to_node(returnvalue).As<Object>();
        return scope.Close(result);
    }
    else {
        dispatch_async(dispatch_get_main_queue(), invocationBlock);
        
        return Undefined();
    }
}


@implementation NoddyFunction

- (id)initWithFunction:(v8::Handle<v8::Function>)funcHandle {
    self = [super init];
    if (!self)
        return nil;
    HandleScope scope;
    func = Persistent<v8::Function>::New(funcHandle);
    return self;
}
- (v8::Local<v8::Value>)basicCall:(v8::Handle<v8::Object>)thisObject arguments:(v8::Handle<v8::Array>)args {
    HandleScope scope;    
    
    uint32_t count = args->Length();
    v8::Handle<v8::Value>* argv = new v8::Handle<v8::Value>[count]();
    for (NSUInteger i = 0; i < count; i++) {
        argv[i] = args->Get(i);
    }
    
    v8::Local<v8::Value> ret = func->Call(thisObject, count, argv);
    delete[] argv;
    
    return scope.Close(ret);
}
- (id)call:(id)thisObject arguments:(NSArray*)args {
    HandleScope scope;
    Local<Object> js_thisObject = (!thisObject || thisObject == [NSNull null]) ? Object::New() : cocoa_to_node(thisObject).As<Object>();
    Local<Array> js_args = (!args) ? Array::New() : cocoa_to_node(args).As<Array>();
    return node_to_cocoa([self basicCall:js_thisObject arguments:js_args]);
}
- (v8::Local<v8::Function>)functionValue {
    HandleScope scope;
    return scope.Close(Local<Function>::New(func));
}
- (void)finalize {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NoddyScheduleBlock(^{
            func.Dispose();
        });
    });
    
    
    [super finalize];
}

@end