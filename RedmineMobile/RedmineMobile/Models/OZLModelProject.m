//
//  OZLModelProject.m
//  RedmineMobile
//
//  Created by Lee Zhijie on 7/15/13.

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

#import "OZLModelProject.h"

@implementation OZLModelProject

-(id)initWithDictionary:(NSDictionary*)dic
{
    self = [super init];
    if (!self) {
        return nil;
    }

    _index = [[dic objectForKey:@"id"] intValue];
    _identifier = [dic objectForKey:@"identifier"];
    _name = [dic objectForKey:@"name"];
    _description = [dic objectForKey:@"description"];
    _homepage = [dic objectForKey:@"homepage"];
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

-(NSMutableDictionary*) toParametersDic
{
    NSMutableDictionary* projectDic = [[NSMutableDictionary alloc] init];
    [projectDic setObject:_name forKey:@"name"];
    [projectDic setObject:_identifier forKey:@"identifier"];
    if (_description.length > 0) {
        [projectDic setObject:_description forKey:@"description"];
    }
    if (_parentId > 0) {
        [projectDic setObject:[NSNumber numberWithInt:_parentId] forKey:@"parent_id"];
    }
    if (_homepage.length > 0) {
        [projectDic setObject:_homepage forKey:@"homepage"];
    }

    return [[NSMutableDictionary alloc] initWithObjectsAndKeys:projectDic,@"project",nil];
}
@end
