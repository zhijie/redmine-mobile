//
//  OZLNetworkBase.h
//  RedmineMobile
//
//  Created by Lee Zhijie on 7/15/13.
//  Copyright (c) 2013 Lee Zhijie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

@interface OZLNetworkBase : AFHTTPClient

+(OZLNetworkBase *)sharedClient;

@end
