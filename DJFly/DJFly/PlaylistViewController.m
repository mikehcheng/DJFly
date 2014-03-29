//
//  PlaylistViewController.m
//  DJFly
//
//  Created by Michael Cheng on 3/29/14.
//  Copyright (c) 2014 Michael Cheng. All rights reserved.
//

#import "AppDelegate.h"
#import "PlaylistViewController.h"

@interface PlaylistViewController () {
    __weak IBOutlet UIButton *_playButton;
    BOOL _loggedIn;
    BOOL _playing;
    BOOL _paused;
    Rdio *_sharedrdio;
    RDPlayer* _player;
}


@end

@implementation PlaylistViewController

@synthesize username, host, player;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (! _sharedrdio) {
        _sharedrdio = ((AppDelegate *) [[UIApplication sharedApplication] delegate]).rdio;
        _sharedrdio.delegate = self;
        _sharedrdio.player.delegate = self;
    }

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    if (! _loggedIn && host) {
        [_sharedrdio authorizeFromController:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */
- (IBAction)playClicked:(id)sender {
    NSLog(@"clicked");
    if (!_playing) {
        NSArray* keys = [@"t2742133,t1992210,t7418766,t8816323" componentsSeparatedByString:@","];
        [[self getPlayer] playSources:keys];
    } else {
        [[self getPlayer] togglePause];
    }
}

#pragma mark - Rdio Helper

- (RDPlayer*)getPlayer
{
    if (_player == nil) {
        _player = _sharedrdio.player;
    }
    return _player;
}

- (void)setLoggedIn:(BOOL)logged_in
{
    _loggedIn = logged_in;
}

#pragma mark - RdioDelegate

- (void)rdioDidAuthorizeUser:(NSDictionary *)user withAccessToken:(NSString *)accessToken
{
    [self setLoggedIn:YES];
}

- (void)rdioAuthorizationFailed:(NSString *)error
{
    [self setLoggedIn:NO];
}

- (void)rdioAuthorizationCancelled
{
    [self setLoggedIn:NO];
}

- (void)rdioDidLogout
{
    [self setLoggedIn:NO];
}

#pragma mark - RDPlayerDelegate

- (BOOL)rdioIsPlayingElsewhere
{
    // let the Rdio framework tell the user.
    return NO;
}

- (void)rdioPlayerChangedFromState:(RDPlayerState)fromState toState:(RDPlayerState)state
{
    _playing = (state != RDPlayerStateInitializing && state != RDPlayerStateStopped);
    _paused = (state == RDPlayerStatePaused);
    if (_paused || !_playing) {
        [_playButton setTitle:@"Play" forState:UIControlStateNormal];
    } else {
        [_playButton setTitle:@"Pause" forState:UIControlStateNormal];
    }
}

@end
