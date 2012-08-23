//
//  NoddyExtraManager.m
//  noddy
//
//  Created by Jean-Nicolas Jolivet on 2012-08-08.
//
//

#import "NoddyExtraManager.h"
#import "NoddyExtraTableCellView.h"
#import "NoddyMixin.h"
#import "NoddyController.h"
#import "Taskit.h"

@implementation NoddyExtraManager
@synthesize progressIndicator, mixinTableView;

@synthesize mixins=_mixins;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
        _mixins = [[NSMutableArray alloc] init];
        gitPath = nil;
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    [self reloadMixins];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (void)reloadMixins
{
    // test gitpath
    [self.mixins removeAllObjects];
    NSURL *mixinUrl = [NSURL URLWithString:@"http://mixins.chocolatapp.com/json/mixins/"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:mixinUrl];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *e) {
                               if(!e) {
                                   NSError *jsonError = nil;
                                   NSArray *rspMixins = [NSJSONSerialization JSONObjectWithData:data
                                                                                        options:0
                                                                                          error:&jsonError];
                                   if(!jsonError) {
                                       [self.mixins addObjectsFromArray:rspMixins];
                                       [self.mixinTableView reloadData];
                                   }
                               }
                           }];
    
}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.mixins.count;
}

- (NoddyExtraTableCellView *)tableView:(NSTableView *)tableView
   viewForTableColumn:(NSTableColumn *)tableColumn
                  row:(NSInteger)row {
    
    NoddyExtraTableCellView *result = (NoddyExtraTableCellView *)[tableView makeViewWithIdentifier:@"NoddyExtraCell" owner:self];
    
    if (result == nil) {
        result = [[NoddyExtraTableCellView alloc] initWithFrame:NSMakeRect(0, 0, 1, 1)];
        result.identifier = @"NoddyExtraCell";
    }
    
    // configure...
    NSDictionary *mixin = [[self.mixins objectAtIndex:row] objectForKey:@"fields"];
    result.textField.stringValue = [mixin objectForKey:@"name"];
    result.descriptionField.stringValue = [mixin objectForKey:@"description"];
    [result.checkbox setState:([self mixinForMixinDictionary:mixin] != nil && (![self mixinIsDisabled:mixin]))];
    [result.updateButton setHidden:([self mixinForMixinDictionary:mixin] == nil)];
    return result;
}

- (BOOL)selectionShouldChangeInTableView:(NSTableView *)aTableView
{
    return NO;
}

- (IBAction)installCheckboxClicked:(id)sender {
    NSUInteger clickedRow = [self.mixinTableView rowForView:sender];
    if ([sender state] == 1) {
        // install the mixin...
        [self installMixin:[self.mixins objectAtIndex:clickedRow]];
    } else {
        [self disableMixin:[self.mixins objectAtIndex:clickedRow]];
    }
}


- (NSString *)mixinDestinationDirectory
{
    // first check if home dir exists...
    BOOL isDir;
    NSString *dest;
    if ([[NSFileManager defaultManager] fileExistsAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@".chocolat/mixins"]
                                             isDirectory:&isDir] && isDir) {
        dest = [NSHomeDirectory() stringByAppendingPathComponent:@".chocolat/mixins"];
    } else {
        NSString *executableName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
        NSArray *basePaths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
        dest = [[[basePaths objectAtIndex:0] stringByAppendingPathComponent:executableName] stringByAppendingPathComponent:@"Mixins"];
    }
    return dest;
}

- (void)disableMixin:(NSDictionary *)mixin
{
    // just add .disabled to its extension
    [self.progressIndicator startAnimation:nil];
    [self.progressIndicator setHidden:NO];
    
    NSDictionary *fields = [mixin objectForKey:@"fields"];
    NoddyMixin *theMixin = [self mixinForMixinDictionary:[mixin objectForKey:@"fields"]];
    if (theMixin) {
        NSString *disabledPath = [[theMixin path] stringByAppendingString:@".disabled"];
        NSError *error = nil;
        [[NSFileManager defaultManager] moveItemAtPath:[theMixin path]
                                                toPath:disabledPath
                                                 error:&error];
        if (error)
            NSLog(@"%@", [error localizedDescription]);
        
        [[NoddyController sharedController] reloadMixins];
        [self reloadMixins];
        
    }
    [self.progressIndicator stopAnimation:nil];
    [self.progressIndicator setHidden:YES];
}

- (void)installMixin:(NSDictionary *)mixin
{
    [self.progressIndicator setHidden:NO];
    [self.progressIndicator startAnimation:nil];
    NSDictionary *fields = [mixin objectForKey:@"fields"];
    NSString *mixinName = [[fields objectForKey:@"name"] stringByAppendingString:@".chocmixin"];
    // gather the args...
    // first the git repo url
    NSString *repoURL = [[fields objectForKey:@"github_url"] stringByAppendingString:@".git"];
    // the destination...
    
    NSString *destination = [[self mixinDestinationDirectory] stringByAppendingPathComponent:mixinName];
    
    NSArray *args = [NSArray arrayWithObjects:@"clone",
                     repoURL,
                     destination, nil];
    
    Taskit *task = [Taskit task];
    [task.arguments addObjectsFromArray:args];
    task.launchPath = [self whichGit];
    [task launch];
    [task waitUntilExit];
    
    [[NoddyController sharedController] reloadMixins];
    [self reloadMixins];
    [self.progressIndicator stopAnimation:nil];
    [self.progressIndicator setHidden:YES];
}



- (NoddyMixin *)mixinForMixinDictionary:(NSDictionary *)mixinFields
{
    NSString *mixinName;
    // check if we should remove the extension...
    if ([[mixinFields objectForKey:@"name"] rangeOfString:@".chocmixin"].location == NSNotFound) {
        mixinName = [mixinFields objectForKey:@"name"];
    } else {
        mixinName = [[mixinFields objectForKey:@"name"] stringByReplacingOccurrencesOfString:@".chocmixin" withString:@""];
    }
    
    for (NoddyMixin *aMixin in [[NoddyController sharedController] mixins]) {
        if ([aMixin.name isEqualToString:mixinName] &&
            [aMixin.path rangeOfString:@"SharedSupport"].location == NSNotFound) {
            return aMixin;
        }
    }
    return nil;

}

- (BOOL)mixinIsDisabled:(NSDictionary *)mixinFields
{
    // obviously if it's in the active mixins, its not disabled...
    if ([self mixinForMixinDictionary:mixinFields] != nil)
        return NO;
    // check on disk...
    // App Support
    NSString *executableName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
    NSArray *basePaths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *appSupportPath = [[[basePaths objectAtIndex:0] stringByAppendingPathComponent:executableName] stringByAppendingPathComponent:@"Mixins"];
    
    // home dir
    NSString *homePath = [NSHomeDirectory() stringByAppendingPathComponent:@".chocolat/mixins/"];
    
    NSString *disabledName = [[mixinFields objectForKey:@"name"] stringByAppendingString:@".chocmixin.disabled"];
    return ([[[NSFileManager defaultManager] subpathsAtPath:appSupportPath] containsObject:disabledName] ||
            [[[NSFileManager defaultManager] subpathsAtPath:homePath] containsObject:disabledName]);
        
}

- (IBAction)reloadMixinClicked:(id)sender {
    [self.progressIndicator setHidden:NO];
    [self.progressIndicator startAnimation:nil];
    [self reloadMixins];
    [self.progressIndicator stopAnimation:nil];
    [self.progressIndicator setHidden:YES];
}

- (NSString *)whichGit
{
    if (gitPath)
        return gitPath;
    
    NSArray *gits = [NSArray arrayWithObjects:@"/usr/local/git/bin/git",
                     @"/usr/local/bin/git",
                     @"/usr/sbin/git",
                     @"/usr/bin/git",
                     @"/sbin/git",
                     @"/bin/git", nil];
    for (NSString *aGit in gits) {
        BOOL isDir;
        if ([[NSFileManager defaultManager] fileExistsAtPath:aGit isDirectory:&isDir]) {
            gitPath = aGit;
            return gitPath;
        }
    }
    return nil;
}

@end
