//
//  NoddyStorage.h
//  noddy
//
//  Created by Alex Gordon on 23/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoddyStorage : NSObject

@property (readonly) NSMutableDictionary* dictionary;
@property (copy) NSString* noddyID;
@property BOOL persistent;
@end
