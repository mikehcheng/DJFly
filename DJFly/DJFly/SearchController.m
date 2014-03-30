//
//  SearchController.m
//  DJFly
//
//  Created by Timothy Luong on 3/29/14.
//  Copyright (c) 2014 Michael Cheng. All rights reserved.
//

#import "AppDelegate.h"
#import "SearchController.h"

@interface SearchController () {
    Rdio *_sharedrdio;
    NSNumber *trackCount;
    //Dictionaries have form albumCover: ~, artist: ~, trackname: ~
    NSMutableArray *dictionaryArray;
}

@end

@implementation SearchController

@synthesize MusicSearchBar;
@synthesize username;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    NSLog(@"YO");
    NSLog(username);
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if (! _sharedrdio) {
        _sharedrdio = ((AppDelegate *) [[UIApplication sharedApplication] delegate]).rdio;
        _sharedrdio.delegate = self;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [trackCount intValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *tempDictionary = [dictionaryArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [tempDictionary objectForKey:@"trackname"];
    cell.detailTextLabel.text = [tempDictionary objectForKey:@"artist"];
    NSData *data = [tempDictionary objectForKey:@"albumCover"];
    UIImage *theImage = [UIImage imageWithData:data];
    cell.imageView.image = theImage;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *tempDictionary = [dictionaryArray objectAtIndex:indexPath.row];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *key = [[tempDictionary objectForKey:@"key"] stringByAppendingString:@"/"];
    NSString *trackname = [[tempDictionary objectForKey:@"trackname"] stringByAppendingString:@"/"];
    NSString *artist =[[tempDictionary objectForKey:@"artist"] stringByAppendingString:@"/"];
    NSString *album =[[tempDictionary objectForKey:@"album"] stringByAppendingString:@"/"];
    NSString *albumCover = [[tempDictionary objectForKey:@"albumCover"] stringByAppendingString:@"/"];
    NSString *getUrl = [@"http://djfly.herokuapp.com/"
                        stringByAppendingString:[@"add/"
                        stringByAppendingString:[username
                        stringByAppendingString:[key
                        stringByAppendingString:[trackname
                        stringByAppendingString:[artist
                        stringByAppendingString:[album
                        stringByAppendingString: albumCover
                                                 ]]]]]]];
    [manager GET:getUrl parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"JSON: %@", responseObject);
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }];

}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Tells the table data source to reload when text changes
    //[self filterContentForSearchText:searchString scope:
    NSDictionary *dic = @{@"query" : searchString, @"types" : @"Track"};
    if (searchString.length>3) {
        [_sharedrdio callAPIMethod:@"search" withParameters:dic delegate: self];
    
        [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]];
    // Return YES to cause the search result table view to be reloaded.
    }
    return YES;
}


-(void) rdioRequest: (RDAPIRequest *)request didLoadData:(id) data {
    NSDictionary *tempDic = (NSDictionary *) data;
    trackCount = [tempDic objectForKey:@"track_count"];
    if ([trackCount intValue] > 10) {
        trackCount = [NSNumber numberWithInteger:10];
    }
    NSArray *overallResults = [tempDic objectForKey:@"results"];
    dictionaryArray = [[NSMutableArray alloc] init];

    for (int x = 0; x < [trackCount intValue]; x++){
        
        NSDictionary *results = [overallResults objectAtIndex:x];
        NSURL *imageURL = [NSURL URLWithString:[results objectForKey:@"icon400"]];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        NSString *name = [results objectForKey:@"name"];
        NSString *artist = [results objectForKey:@"artist"];
        NSNumber *trackNumber = [results objectForKey:@"key"];
        
        [dictionaryArray addObject:@{@"albumCover": imageData, @"artist": artist, @"trackname": name, @"key": trackNumber}];
    }
    
    
}

-(void) rdioRequest: (RDAPIRequest *) request didFailWithError:(NSError *) error {
    NSLog(error);
}

/*
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}
*/

@end
