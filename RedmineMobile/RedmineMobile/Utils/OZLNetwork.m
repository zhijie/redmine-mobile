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
#import "JSONKit.h"
#import "OZLModelProject.h"

@implementation OZLNetwork

+(void)getProjectListWithParams:(NSDictionary*)params andBlock:(void (^)(NSArray *result, NSError *error))block;
{
    NSString* path = @"/projects.json";
    [[OZLNetworkBase sharedClient] getPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (block) {
            NSLog(@"the repsonse:%@",responseObject);
            NSMutableArray* projects = [[NSMutableArray alloc] init];
            
            NSArray* projectsDic = [responseObject objectForKey:@"projects"];
            for (NSDictionary* p in projectsDic) {
                [projects addObject:[[OZLModelProject alloc] initWithDictionary:p]];
            }
            block(projects,nil);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        if (block) {
            block([NSArray array], error);
        }
        
    }];
}


@end
