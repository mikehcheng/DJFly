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
    __weak IBOutlet UITextField *textField;
}

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    textField.delegate = self;
}

- (IBAction)createRoom:(id)sender {
    NSLog(@"Host");
    
    NSURL *baseUrl = [NSURL URLWithString:@"http://djfly.herokuapp.com/"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    
    NSURL *url = [NSURL URLWithString:@"root/create" relativeToURL:baseUrl];
    [request setURL:url];
    
    NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    
    
    
    //if (_loggedIn) {
    [self performSegueWithIdentifier:@"fromHostToList" sender:self];
    //} else {
        //login and send ^
    //}
}

-(BOOL)textFieldShouldReturn:(UITextField *) field{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)joinRoom:(id)sender {
    NSLog(@"Sender");
    //sender.text send to jia's side
    //if ok, join; else error
    [self performSegueWithIdentifier:@"fromClientToList" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
