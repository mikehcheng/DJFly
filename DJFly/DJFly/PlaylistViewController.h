//
//  PlaylistViewController.h
//  DJFly
//
//  Created by Michael Cheng on 3/29/14.
//  Copyright (c) 2014 Michael Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Rdio/Rdio.h>

@interface PlaylistViewController : UITableViewController <NSURLConnectionDelegate, RdioDelegate, RDPlayerDelegate>

@property (strong, nonatomic) NSString *username;
@property (nonatomic) BOOL host;

@property (strong, nonatomic) RDPlayer *player;

@end
