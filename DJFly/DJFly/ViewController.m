//
//  ViewController.m
//  DJFly
//
//  Created by Michael Cheng on 3/28/14.
//  Copyright (c) 2014 Michael Cheng. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)createRoom:(id)sender {
    NSLog(@"works");
    [self performSegueWithIdentifier:@"toPlaylist" sender:self];
}

- (IBAction)joinRoom:(id)sender {
    [self performSegueWithIdentifier:@"toPlaylist" sender:self];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
