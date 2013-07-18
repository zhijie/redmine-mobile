//
//  OZLModelIssueStatus.m
//  RedmineMobile
//
//  Created by lizhijie on 7/15/13.
//  Copyright (c) 2013 Lee Zhijie. All rights reserved.
//

#import "OZLModelIssueStatus.h"

@implementation OZLModelIssueStatus

-(id)initWithDictionary:(NSDictionary*)dic
{
    self = [super init];
    if (!self) {
        return nil;
    }

    _index = [[dic objectForKey:@"id"] intValue];
    _name = [dic objectForKey:@"name"];
    return  self;
}

@end
