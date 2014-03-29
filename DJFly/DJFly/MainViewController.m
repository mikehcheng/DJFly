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

}

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    NSLog(@"Sender");
    //sender.text send to jia's side
    //if ok, join; else error
    [self performSegueWithIdentifier:@"fromClientToList" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"fromHostToList"]) {
        PlaylistViewController *target = [segue destinationViewController];
        target.host = TRUE;
        target.username = @"root"; //change to username
        [self.navigationController setNavigationBarHidden:NO];
    } else if ([segue.identifier isEqualToString:@"fromClientToList"]) {
        PlaylistViewController *target = [segue destinationViewController];
        target.username = textField.text;
        target.host = FALSE;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *) field{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
