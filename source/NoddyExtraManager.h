//
//  NoddyExtraManager.h
//  noddy
//
//  Created by Jean-Nicolas Jolivet on 2012-08-08.
//
//

#import <Cocoa/Cocoa.h>

@interface NoddyExtraManager : NSWindowController <NSTableViewDataSource, NSTableViewDelegate> {
    NSString *gitPath;
}

@property (assign) NSMutableArray *mixins;
@property (assign) IBOutlet NSTableView *mixinTableView;


- (IBAction)installCheckboxClicked:(id)sender;
- (BOOL)mixinIsInstalled:(NSDictionary *)mixinFields;
- (IBAction)reloadMixinClicked:(id)sender;
- (void)reloadMixins;
- (NSString *)whichGit;
- (NSString *)mixinDestinationDirectory;
- (void)installMixin:(NSDictionary *)mixin;


@end
