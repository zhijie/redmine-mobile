//
//  OZLModelIssue.h
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
