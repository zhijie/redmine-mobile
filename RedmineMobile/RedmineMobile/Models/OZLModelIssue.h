//
//  OZLModelIssue.h
//  RedmineMobile
//
//  Created by lizhijie on 7/15/13.
//  Copyright (c) 2013 Lee Zhijie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OZLModelTracker.h"
#import "OZLModelIssueStatus.h"
#import "OZLModelUser.h"
#import "OZLModelIssuePriority.h"
#import "OZLModelIssueCategory.h"

@interface OZLModelIssue : NSObject

@property(nonatomic) int index;
@property(nonatomic) int projectId;
@property(nonatomic) int parentIssueId;
@property(nonatomic,strong) OZLModelTracker* tracker;
@property(nonatomic,strong) OZLModelUser* author;
@property(nonatomic,strong) OZLModelUser* assignedTo;
@property(nonatomic,strong) OZLModelIssuePriority* priority;
@property(nonatomic,strong) OZLModelIssueStatus* status;
@property(nonatomic,strong) OZLModelIssueCategory* category;
@property(nonatomic,strong) NSString* subject;
@property(nonatomic,strong) NSString* description;
@property(nonatomic,strong) NSString* startDate;
@property(nonatomic,strong) NSString* dueDate;
@property(nonatomic,strong) NSString* createdOn;
@property(nonatomic,strong) NSString* updatedOn;
@property(nonatomic) float doneRatio;
@property(nonatomic) float spentHours;
@property(nonatomic) float estimatedHours;
@property(nonatomic,strong) NSString* notes;// used as paramter to update a issue

-(id)initWithDictionary:(NSDictionary*)dic;
-(NSMutableDictionary*) toParametersDic;

@end
