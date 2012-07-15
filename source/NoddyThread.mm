//
//  NoddyThread.m
//  NodeTest
//
//  Created by Jean-Nicolas Jolivet on 12-07-01.
//  Copyright (c) 2012 Jean-Nicolas Jolivet. All rights reserved.
//
#import <node.h>
#import <uv.h>
#import <libkern/OSAtomic.h>

#import "NoddyBridge.h"

using namespace v8;

// http://izs.me/v8-docs/classv8_1_1Array.html

void noddy_init(v8::Handle<v8::Object> target) {
//    printf("noddy_init\n");
}

static uv_async_t noddy_async;
static uv_prepare_t noddy_prep;

static void NoddyPrepareNode(uv_prepare_t* handle, int status) {
    HandleScope scope;
    Persistent<Object> noddyModule;

    // Create _choc module
    Local<FunctionTemplate> noddy_init_template = FunctionTemplate::New();
    // node::EventEmitter::Initialize(noddy_init_template);
    noddyModule = Persistent<Object>::New(noddy_init_template->GetFunction()->NewInstance());
    noddy_init(noddyModule);
    
    Local<Object> global = v8::Context::GetCurrent()->Global();
    global->Set(String::New("_choc"), noddyModule);
    
    uv_prepare_stop(handle);
}

static volatile OSSpinLock NoddyMessageQueueLock = OS_SPINLOCK_INIT;
static unsigned NoddyMessagesCount; // Avoid sending a -count message each poll
static NSMutableArray* NoddyMessages;

void NoddyScheduleBlock(dispatch_block_t block) {
    OSSpinLockLock(&NoddyMessageQueueLock);

    if (!NoddyMessages) {
        NoddyMessages = [[NSMutableArray alloc] init];
    }
    
    [NoddyMessages addObject:[block copy]];
    NoddyMessagesCount = [NoddyMessages count];
    
    OSSpinLockUnlock(&NoddyMessageQueueLock);
    
    uv_async_send(&noddy_async);
}
static void NoddyPollMessageQueue(uv_async_t* handle, int status) {
    
    NSArray* messages = nil;
    
    OSSpinLockLock(&NoddyMessageQueueLock);
    if (NoddyMessagesCount) {
        messages = [NoddyMessages copy];
        [NoddyMessages removeAllObjects];
        NoddyMessagesCount = 0;
    }
    OSSpinLockUnlock(&NoddyMessageQueueLock);
    
    // Run each message
    for (id message in messages) {
        dispatch_block_t block = (dispatch_block_t)message;
        block();
    }
}


#import "NoddyThread.h"

@implementation NoddyThread

- (void)main
{
    // args
    NSAutoreleasePool *pool = [NSAutoreleasePool new];
    
    const char *argv[] = {NULL,"","",NULL};
    argv[0] = [[[NSBundle mainBundle] bundlePath] fileSystemRepresentation];
    int argc = 2;
    argv[argc-1] = [[[[NSBundle mainBundle] sharedSupportPath] stringByAppendingPathComponent:@"node/chocolat.js"] fileSystemRepresentation];
    
    // NODE_PATH
    NSString *nodelibPath = [[NSBundle mainBundle] sharedSupportPath];
    nodelibPath = [nodelibPath stringByAppendingPathComponent:@"node"];
    const char *NODE_PATH_pch = getenv("NODE_PATH");
    NSString *NODE_PATH;
    if (NODE_PATH_pch)
        NODE_PATH = [NSString stringWithFormat:@"%@:%s",nodelibPath, NODE_PATH_pch];
    else
        NODE_PATH = nodelibPath;
    
    setenv("NODE_PATH", [NODE_PATH UTF8String], 1);
    
    // Make sure HOME is correct and set
    setenv("HOME", [NSHomeDirectory() UTF8String], 1);
    
    // register our initializer
    static uv_prepare_t noddy_prep;
    uv_prepare_init(uv_default_loop(), &noddy_prep);
    uv_prepare_start(&noddy_prep, NoddyPrepareNode);
    
//    static uv_idle_t noddy_idle;
//    uv_idle_init(uv_default_loop(), &noddy_idle);
//    uv_idle_start(&noddy_idle, NoddyPollMessageQueue);
    uv_async_init(uv_default_loop(), &noddy_async, NoddyPollMessageQueue);
    
    
    /* int exitStatus = */ node::Start(argc, const_cast<char**>(argv));
    
    [pool drain];
}

+ (void)callGlobalFunction:(NSString*)functionName arguments:(NSArray*)args {
    
    NoddyScheduleBlock(^{
        
        HandleScope scope;
                
        v8::Local<v8::Object> global = v8::Context::GetCurrent()->Global();
        v8::Local<v8::Function> fun = global->Get(v8::String::New([functionName UTF8String])).As<v8::Function>();
        
        NSUInteger count = [args count];
        v8::Handle<v8::Value>* argv = new v8::Handle<v8::Value>[count]();
        for (NSUInteger i = 0; i < count; i++) {
            argv[i] = cocoa_to_node([args objectAtIndex:i]);
        }
        
        fun->Call(global, count, argv);
        
        delete[] argv;
    });
}

@end