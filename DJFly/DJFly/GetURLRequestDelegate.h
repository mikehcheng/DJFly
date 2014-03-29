//
//  GetURLRequestDelegate.h
//  DJFly
//
//  Created by Michael Cheng on 3/29/14.
//  Copyright (c) 2014 Michael Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetURLRequestDelegate : NSObject <NSURLSessionDelegate>

@property (strong, nonatomic) NSString *message;

@end
