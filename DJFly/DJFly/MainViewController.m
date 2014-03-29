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
//    
//    NSURL *baseUrl = [NSURL URLWithString:@"http://djfly.herokuapp.com/"];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    [request setHTTPMethod:@"GET"];
//    
//    NSURL *url = [NSURL URLWithString:@"root/create" relativeToURL:baseUrl];
//    [request setURL:url];
//    
//    NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request delegate:self];
//
    [self performSegueWithIdentifier:@"fromHostToList" sender:self];
}

- (IBAction)joinRoom:(id)sender {
    NSLog(@"Client");
    //sender.text send to jia's side
    //if ok, join; else error
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Join existing room" message:@"Enter the Rdio username." delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

//only for join method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    _roomName = [alertView textFieldAtIndex:0].text;
    [self performSegueWithIdentifier:@"fromClientToList" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"fromHostToList"]) {
        PlaylistViewController *target = [segue destinationViewController];
        target.host = TRUE;
        target.username = @"temp"; //change to in playlistview
        [self.navigationController setNavigationBarHidden:NO];
    } else if ([segue.identifier isEqualToString:@"fromClientToList"]) {
        PlaylistViewController *target = [segue destinationViewController];
        NSLog(_roomName);
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
