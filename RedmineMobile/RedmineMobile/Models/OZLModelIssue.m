//
//  OZLModelIssue.m
//  RedmineMobile
//
//  Created by lizhijie on 7/15/13.
//  Copyright (c) 2013 Lee Zhijie. All rights reserved.
//

#import "OZLModelIssue.h"

@implementation OZLModelIssue

-(id)initWithDictionary:(NSDictionary*)dic
{
    self = [super init];
    if (!self) {
        return nil;
    }

//    @property(nonatomic) int index;
//    @property(nonatomic) int projectId;
//    @property(nonatomic) int parentIssueId;
//    @property(nonatomic,strong) OZLModelTracker* tracker;
//    @property(nonatomic,strong) OZLModelUser* author;
//    @property(nonatomic,strong) OZLModelUser* assignedTo;
//    @property(nonatomic,strong) OZLModelPriority* priority;
//    @property(nonatomic,strong) NSString* subject;
//    @property(nonatomic,strong) NSString* description;
//    @property(nonatomic,strong) NSString* startDate;
//    @property(nonatomic,strong) NSString* dueDate;
//    @property(nonatomic,strong) NSString* createdOn;
//    @property(nonatomic,strong) NSString* updatedOn;
//    @property(nonatomic) float doneRatio;
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
        _priority = [[OZLModelPriority alloc] initWithDictionary:priority];
    }
    _subject = [dic objectForKey:@"subject"];
    _description = [dic objectForKey:@"description"];
    _startDate = [dic objectForKey:@"start_date"];
    _dueDate = [dic objectForKey:@"due_date"];
    _createdOn = [dic objectForKey:@"created_on"];
    _updatedOn = [dic objectForKey:@"updated_on"];
    _doneRatio = [[dic objectForKey:@"done_ratio"] floatValue];
    return self;
}

@end
