//
//  AppDelegate.h
//  DJFly
//
//  Created by Michael Cheng on 3/28/14.
//  Copyright (c) 2014 Michael Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Rdio/Rdio.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly) Rdio *rdio;

@end
