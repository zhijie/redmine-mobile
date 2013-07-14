//
//  OZLNetwork.m
//  RedmineMobile
//
//  Created by Lee Zhijie on 7/14/13.
//  Copyright (c) 2013 Lee Zhijie. All rights reserved.
//

#import "OZLNetwork.h"
#import "OZLNetworkBase.h"
#import "AFHTTPRequestOperation.h"

@implementation OZLNetwork

+(void)getProjectListWithBlock:(void (^)(NSDictionary *result, NSError *error))block
{
    NSString* path = @"/projects.json";
    NSDictionary* params = [[NSDictionary alloc] initWithObjectsAndKeys: nil];
    [[OZLNetworkBase sharedClient] getPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (block) {
            NSLog(@"the repsonse:%@",responseObject);
            block(responseObject,nil);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        if (block) {
            block(nil, error);
        }
        
    }];
}


@end
