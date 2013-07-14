//
//  OZLModelProject.m
//  RedmineMobile
//
//  Created by Lee Zhijie on 7/15/13.
//  Copyright (c) 2013 Lee Zhijie. All rights reserved.
//

#import "OZLModelProject.h"

@implementation OZLModelProject

-(id)initWithDictionary:(NSDictionary*)dic
{
    self = [super init];
    if (!self) {
        return nil;
    }

    _index = [[dic objectForKey:@"id"] intValue];
    _name = [dic objectForKey:@"name"];
    _description = [dic objectForKey:@"description"];
    _createdOn = [dic objectForKey:@"created_on"];
    _updatedOn = [dic objectForKey:@"updated_on"];
    NSDictionary* parent = [dic objectForKey:@"parent"];
    if (parent) {
        _parentId = [[parent objectForKey:@"id"] intValue];
    }else {
        _parentId = -1;
    }
    return self;
}

@end
