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
    NSLog(@"Which git: %@", [self whichGit]);
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
    [result.checkbox setState:([self mixinIsInstalled:mixin])];
    [result.updateButton setHidden:!([self mixinIsInstalled:mixin])];
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
    }
}

- (NSString *)completeMixinName:(NSDictionary *)mixin
{
    
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

- (void)installMixin:(NSDictionary *)mixin
{
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
    NSString *output = [task waitForOutputString];
    NSLog(@"Done... %@", output);
    [[NoddyController sharedController] reloadMixins];
    [self reloadMixins];
}

- (BOOL)mixinIsInstalled:(NSDictionary *)mixinFields
{
    NSString *mixinName;
    // check if we should add the extension...
    if ([[mixinFields objectForKey:@"name"] rangeOfString:@".chocmixin"].location == NSNotFound) {
        mixinName = [mixinFields objectForKey:@"name"];
    } else {
        mixinName = [[mixinFields objectForKey:@"name"] stringByReplacingOccurrencesOfString:@".chocmixin" withString:@""];
    }
    
    for (NoddyMixin *aMixin in [[NoddyController sharedController] mixins]) {
        if ([aMixin.name isEqualToString:mixinName] &&
            [aMixin.path rangeOfString:@"SharedSupport"].location == NSNotFound) {
            return YES;
        }
    }
    
    
    return NO;
}

- (IBAction)reloadMixinClicked:(id)sender {
    [self reloadMixins];
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
