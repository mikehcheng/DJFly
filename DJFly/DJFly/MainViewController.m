//
//  MainViewController.m
//  DJFly
//
//  Created by Michael Cheng on 3/28/14.
//  Copyright (c) 2014 Michael Cheng. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController () {
    //BOOL _loggedIn;
}

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)createRoom:(id)sender {
    NSLog(@"Host");
    //if (_loggedIn) {
        [self performSegueWithIdentifier:@"fromHosttoList" sender:self];
    //} else {
        //login and send ^
    //}
}

- (IBAction)joinRoom:(id)sender {
    NSLog(@"Sender");
    //sender.text send to jia's side
    //if ok, join; else error
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
