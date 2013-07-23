//
//  OZLModelTimeEntries.m
//  RedmineMobile
//
//  Created by lizhijie on 7/22/13.

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


#import "OZLModelTimeEntries.h"

@implementation OZLModelTimeEntries

-(id)initWithDictionary:(NSDictionary*)dic
{
    self = [super init];
    if (!self) {
        return nil;
    }
    _index = [[dic objectForKey:@"id"] intValue];
    id project = [dic objectForKey:@"project"];
    if (project != nil) {
        _project = [[OZLModelProject alloc] initWithDictionary:project];
    }
    id user = [dic objectForKey:@"user"];
    if (user != nil) {
        _user = [[OZLModelUser alloc] initWithDictionary: user];
    }
    id issue = [dic objectForKey:@"issue"];
    if (issue != nil ) {
        _issue = [[OZLModelIssue alloc] initWithDictionary:issue];
    }
    id activity = [dic objectForKey:@"activity"];
    if (activity != nil) {
        _activity = [[OZLModelTimeEntryActivity alloc] initWithDictionary:activity];
    }
    _hours = [[dic objectForKey:@"hours"] floatValue];
    _comments = [dic objectForKey:@"comments"];
    _spentOn = [dic objectForKey:@"spent_on"];
    _createdOn = [dic objectForKey:@"created_on"];
    _updatedOn = [dic objectForKey:@"updated_on"];
    return self;
}

-(NSMutableDictionary*) toParametersDic
{
    NSMutableDictionary* entryDic = [[NSMutableDictionary alloc] init];
    [entryDic setObject:[NSNumber numberWithFloat:_hours] forKey:@"hours"];//required
    if (_issue) {
        [entryDic setObject:[NSNumber numberWithInt:_issue.index] forKey:@"issue_id"];
    }else if(_project){
        [entryDic setObject:[NSNumber numberWithInt:_project.index] forKey:@"project_id"];
    }
    if (_spentOn) {
        [entryDic setObject:_spentOn forKey:@"spent_on"];
    }
    if (_activity) {
        [entryDic setObject:[NSNumber numberWithInt:_activity.index] forKey:@"activity_id"];
    }
    if (_comments) {
        [entryDic setObject:_comments forKey:@"comments"];
    }
    
    return [[NSMutableDictionary alloc] initWithObjectsAndKeys:entryDic,@"time_entry",nil];
}


@end
