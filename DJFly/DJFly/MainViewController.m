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
}

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
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
        target.username = @"temp"; //change to in playlistview
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
