//
//  SearchController.h
//  DJFly
//
//  Created by Timothy Luong on 3/29/14.
//  Copyright (c) 2014 Michael Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Rdio/Rdio.h>

@interface SearchController : UITableViewController <RdioDelegate, RDAPIRequestDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

@property IBOutlet UISearchBar *MusicSearchBar;
@property (strong, nonatomic) NSString *username;

@end
