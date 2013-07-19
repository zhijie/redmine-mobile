//
//  OZLModelIssue.m
//  RedmineMobile
//
//  Created by lizhijie on 7/15/13.

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

#import "OZLModelIssue.h"

@implementation OZLModelIssue

-(id)initWithDictionary:(NSDictionary*)dic
{
    self = [super init];
    if (!self) {
        return nil;
    }
    _index = [[dic objectForKey:@"id"] intValue];
    _projectId = [[[dic objectForKey:@"project"] objectForKey:@"id"] intValue];
    id parent = [dic objectForKey:@"parent"];
    if (parent != nil) {
        _parentIssueId = [[parent objectForKey:@"id"] intValue];
    }else {
        _parentIssueId = -1;
    }
    id tracker = [dic objectForKey:@"tracker"];
    if (tracker != nil) {
        _tracker = [[OZLModelTracker alloc] initWithDictionary:tracker];
    }
    id author = [dic objectForKey:@"author"];
    if (author != nil) {
        _author = [[OZLModelUser alloc] initWithDictionary:author];
    }
    id assignedTo = [dic objectForKey:@"assigned_to"];
    if (assignedTo != nil) {
        _assignedTo = [[OZLModelUser alloc] initWithDictionary:assignedTo];
    }
    id priority = [dic objectForKey:@"priority"];
    if (priority != nil) {
        _priority = [[OZLModelIssuePriority alloc] initWithDictionary:priority];
    }
    id status = [dic objectForKey:@"status"];
    if (status) {
        _status = [[OZLModelIssueStatus alloc ] initWithDictionary:status];
    }
    id category = [dic objectForKey:@"category"];
    if (status) {
        _category = [[OZLModelIssueCategory alloc ] initWithDictionary:category];
    }
    _subject = [dic objectForKey:@"subject"];
    _description = [dic objectForKey:@"description"];
    _startDate = [dic objectForKey:@"start_date"];
    _dueDate = [dic objectForKey:@"due_date"];
    _createdOn = [dic objectForKey:@"created_on"];
    _updatedOn = [dic objectForKey:@"updated_on"];
    _doneRatio = [[dic objectForKey:@"done_ratio"] floatValue];
    id spentHours = [dic objectForKey:@"spent_hours"];
    if (spentHours ) {
        _spentHours = [spentHours floatValue];
    }else {
        _spentHours = 0.0f;
    }
    id estimatedHours = [dic objectForKey:@"estimated_hours"];
    if (spentHours ) {
        _estimatedHours = [estimatedHours floatValue];
    }else {
        _estimatedHours = 0.0f;
    }

    return self;
}
-(NSMutableDictionary*) toParametersDic
{
    NSMutableDictionary* issueData = [[NSMutableDictionary alloc] init];
    if (_projectId > 0) {
        [issueData setObject:[NSNumber numberWithInt:_projectId] forKey:@"project_id"];
    }
    if (_tracker && _tracker.index > 0) {
        [issueData setObject:[NSNumber numberWithInt:_tracker.index] forKey:@"tracker_id"];
    }
    if (_status && _status.index > 0) {
        [issueData setObject:[NSNumber numberWithInt:_status.index] forKey:@"status_id"];
    }
    if (_priority && _priority.init > 0) {
        [issueData setObject:[NSNumber numberWithInt:_priority.index] forKey:@"priority_id"];
    }
    if (_subject.length > 0) {
        [issueData setObject:_subject forKey:@"subject"];
    }
    if (_description.length > 0) {
        [issueData setObject:_description forKey:@"description"];
    }
    if (_category && _category) {
        [issueData setObject:[NSNumber numberWithInt:_category.index ] forKey:@"categroy_id"];
    }
    if (_assignedTo && _assignedTo.index > 0) {
        [issueData setObject:[NSNumber numberWithInt:_assignedTo.index] forKey:@"assigned_to_id"];
    }
    if (_parentIssueId > 0) {
        [issueData setObject:[NSNumber numberWithInt:_parentIssueId] forKey:@"parent_issue_id"];
    }
    if (_spentHours > 0) {
        [issueData setObject:[NSNumber numberWithFloat:_spentHours] forKey:@"spent_hours"];
    }
    if (_estimatedHours > 0) {
        [issueData setObject:[NSNumber numberWithFloat:_estimatedHours] forKey:@"estimated_hours"];
    }

    return [[NSMutableDictionary alloc] initWithObjectsAndKeys:issueData,@"issue",nil];
}
@end
