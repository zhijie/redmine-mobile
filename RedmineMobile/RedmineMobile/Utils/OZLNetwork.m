//
//  OZLNetwork.m
//  RedmineMobile
//
//  Created by Lee Zhijie on 7/14/13.

// This code is distributed under the terms and conditions of the MIT license.

// Copyright (c) 2013 Zhijie Lee(onezeros.lee@gmail.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

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

+(void)getDetailForProject:(int)projectid withParams:(NSDictionary*)params andBlock:(void (^)(OZLModelProject *result, NSError *error))block
{
    NSString* path = [NSString stringWithFormat:@"/projects/%d.json",projectid];
    [[OZLNetworkBase sharedClient] getPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {

        if (block) {
            NSLog(@"the repsonse:%@",responseObject);

            NSDictionary* projectDic = [responseObject objectForKey:@"project"];
            OZLModelProject* project = [[OZLModelProject alloc] initWithDictionary:projectDic];

            block(project,nil);
        }


    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {


        if (block) {
            block([NSArray array], error);
        }

    }];
}

@end
