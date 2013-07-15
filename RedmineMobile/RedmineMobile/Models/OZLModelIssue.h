//
//  OZLModelIssue.h
//  RedmineMobile
//
//  Created by lizhijie on 7/15/13.
//  Copyright (c) 2013 Lee Zhijie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OZLModelTracker.h"
#import "OZLModelStatus.h"
#import "OZLModelUser.h"
#import "OZLModelPriority.h"

@interface OZLModelIssue : NSObject

@property(nonatomic) int index;
@property(nonatomic) int projectId;
@property(nonatomic) int parentIssueId;
@property(nonatomic,strong) OZLModelTracker* tracker;
@property(nonatomic,strong) OZLModelUser* author;
@property(nonatomic,strong) OZLModelUser* assignedTo;
@property(nonatomic,strong) OZLModelPriority* priority;
@property(nonatomic,strong) NSString* subject;
@property(nonatomic,strong) NSString* description;
@property(nonatomic,strong) NSString* startDate;
@property(nonatomic,strong) NSString* dueDate;
@property(nonatomic,strong) NSString* createdOn;
@property(nonatomic,strong) NSString* updatedOn;
@property(nonatomic) float doneRatio;

-(id)initWithDictionary:(NSDictionary*)dic;

@end
