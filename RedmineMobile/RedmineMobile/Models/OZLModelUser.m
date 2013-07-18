//
//  OZLModelUser.m
//  RedmineMobile
//
//  Created by lizhijie on 7/15/13.
//  Copyright (c) 2013 Lee Zhijie. All rights reserved.
//

#import "OZLModelUser.h"

@implementation OZLModelUser

-(id)initWithDictionary:(NSDictionary*)dic
{
    self = [super init];
    if (!self) {
        return nil;
    }

    _index = [[dic objectForKey:@"id"] intValue];
    _login = [dic objectForKey:@"login"];
    _firstname = [dic objectForKey:@"firstname"];
    _lastname = [dic objectForKey:@"lastname"];
    _mail = [dic objectForKey:@"mail"];
    _createdOn = [dic objectForKey:@"created_on"];
    _lastLoginIn = [dic objectForKey:@"last_login_on"];

    _name = _login;
    return  self;
}


@end
