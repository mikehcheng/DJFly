//
//  MainViewController.m
//  DJFly
//
//  Created by Michael Cheng on 3/28/14.
//  Copyright (c) 2014 Michael Cheng. All rights reserved.
//

#import "MainViewController.h"
#import "PlaylistViewController.h"

@interface MainViewController () {
    NSString *_roomName;
    __weak IBOutlet UIButton *createButton;
    __weak IBOutlet UIButton *joinButton;
}

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Splash@2x.png"]]];
    
    createButton.layer.borderWidth=1.0f;
    createButton.layer.borderColor=[[[UIColor alloc] initWithRed:0.71 green:0.38 blue:0.97 alpha:1] CGColor];
    createButton.layer.cornerRadius = 5;
    createButton.layer.masksToBounds = YES;
    
    joinButton.layer.borderWidth=1.0f;
    joinButton.layer.borderColor=[[[UIColor alloc] initWithRed:0.71 green:0.38 blue:0.97 alpha:1] CGColor];
    joinButton.layer.cornerRadius = 5;
    joinButton.layer.masksToBounds = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (IBAction)createRoom:(id)sender {
    NSLog(@"Host");
    [self performSegueWithIdentifier:@"fromHostToList" sender:self];
}

- (IBAction)joinRoom:(id)sender {
    NSLog(@"Client");
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Join existing room" message:@"Enter the Rdio username." delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

//only for join method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if([alertView alertViewStyle] != UIAlertViewStyleDefault) {
        _roomName = [alertView textFieldAtIndex:0].text;
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *url = [@"http://djfly.herokuapp.com/" stringByAppendingString:[@"join/" stringByAppendingString:_roomName]];
        [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            [self performSegueWithIdentifier:@"fromClientToList" sender:self];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Unable to join room." message:@"Either the server cannot be reached, or the specified room does not exist." delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil];
            alert.alertViewStyle = UIAlertViewStyleDefault;
            [alert show];
        }];
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"fromHostToList"]) {
        PlaylistViewController *target = [segue destinationViewController];
        target.host = TRUE;
        target.username = @""; //change to in playlistview
    } else if ([segue.identifier isEqualToString:@"fromClientToList"]) {
        PlaylistViewController *target = [segue destinationViewController];
        target.username = _roomName;
        target.host = FALSE;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
