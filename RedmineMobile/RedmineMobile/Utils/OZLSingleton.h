//
//  OZLSingleton.h
//  RedmineMobile
//
//  Created by Lee Zhijie on 7/15/13.
//  Copyright (c) 2013 Lee Zhijie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OZLSingleton : NSObject

+(OZLSingleton*) sharedInstance;

//network
@property(nonatomic,strong) NSString* redmineHomeURL;
@property(nonatomic,strong) NSString* redmineUserKey;


@end
