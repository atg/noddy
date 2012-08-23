//
//  NoddyExtraManager.h
//  noddy
//
//  Created by Jean-Nicolas Jolivet on 2012-08-08.
//
//

#import <Cocoa/Cocoa.h>
@class NoddyMixin;
@interface NoddyExtraManager : NSWindowController <NSTableViewDataSource, NSTableViewDelegate> {
    NSString *gitPath;
}

@property (assign) NSMutableArray *mixins;
@property (assign) IBOutlet NSTableView *mixinTableView;
@property (assign) IBOutlet NSProgressIndicator *progressIndicator;


- (IBAction)installCheckboxClicked:(id)sender;
- (IBAction)reloadMixinClicked:(id)sender;
- (void)reloadMixins;
- (NSString *)whichGit;
- (NSString *)mixinDestinationDirectory;
- (void)installMixin:(NSDictionary *)mixin;
- (BOOL)mixinIsDisabled:(NSDictionary *)mixinFields;
- (NoddyMixin *)mixinForMixinDictionary:(NSDictionary *)mixinFields;

- (void)disableMixin:(NSDictionary *)mixin;
@end
