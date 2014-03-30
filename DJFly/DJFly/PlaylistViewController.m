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
    
    NSMutableArray *_jsonData;
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
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.navigationItem.title = username;
    self.navigationController.navigationBarHidden = NO;
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]]];
    
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
    
    [self updatePlaylist];
    
    [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(updatePlaylist) userInfo:NULL repeats:YES];
}

- (void)rdioRequest:(RDAPIRequest *)request didLoadData:(id)data {
    NSDictionary *dict = (NSDictionary *) data;
    NSString *url = [dict objectForKey:@"url"];
    username = [url substringWithRange:NSMakeRange(8, [url length] - 9)];
    self.navigationItem.title = username;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *getUrl = [@"http://djfly.herokuapp.com/" stringByAppendingString:[@"create/" stringByAppendingString:username]];
    [manager GET:getUrl parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"JSON: %@", responseObject);
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }];
}

- (void)rdioRequest:(RDAPIRequest *)request didFailWithError:(NSError *)error {
    NSLog(error);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) updatePlaylist {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *getUrl = [@"http://djfly.herokuapp.com/" stringByAppendingString:[@"join/" stringByAppendingString:username]];
    [manager GET:getUrl parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"JSON: %@", responseObject);
             //add handling of join data
             NSError *e = nil;
             NSMutableArray *array = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONReadingMutableContainers  error: &e];
             _jsonData = array;
             [self.tableView reloadData];
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_jsonData) {
        return [_jsonData count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary *item = (NSDictionary *)[_jsonData objectAtIndex:indexPath.row];
    cell.textLabel.text = [item objectForKey:@"mainTitleKey"];
    
    
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
    
    [_sharedrdio callAPIMethod:@"currentUser"
                withParameters:[[NSDictionary alloc] init]
                      delegate:self];
}

- (void)rdioAuthorizationFailed:(NSString *)error
{
    [self setLoggedIn:NO];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rdioAuthorizationCancelled
{
    [self setLoggedIn:NO];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rdioDidLogout
{
    [self setLoggedIn:NO];
    
    [self.navigationController popViewControllerAnimated:YES];
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
