//
//  NoddyExtraTableCellView.h
//  noddy
//
//  Created by Jean-Nicolas Jolivet on 2012-08-16.
//
//

#import <Cocoa/Cocoa.h>

@interface NoddyExtraTableCellView : NSTableCellView

@property (assign) IBOutlet NSTextField *descriptionField;
@property (assign) IBOutlet NSButton *checkbox;
@property (assign) IBOutlet NSButton *updateButton;
@property (assign) IBOutlet NSTextField *statusField;
@end
