//
//  OZLSingleton.h
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

#import <Foundation/Foundation.h>
#import "OZLModelTracker.h"
#import "OZLModelUser.h"
#import "OZLModelIssueStatus.h"
#import "OZLModelIssuePriority.h"

@interface OZLSingleton : NSObject

+(OZLSingleton*) sharedInstance;

//network
@property(nonatomic,strong) NSString* redmineHomeURL;
@property(nonatomic,strong) NSString* redmineUserKey;
@property(nonatomic,strong) NSString* redmineUserName;
@property(nonatomic,strong) NSString* redminePassword;

// issue list option
@property(nonatomic) int issueListFilterType;
@property(nonatomic) int issueListSortType;
@property(nonatomic) int issueListSortAscending;

//app status
@property(nonatomic) int lastProjectID;// last viewed project id

// app data
@property (strong, nonatomic) NSArray* trackerList;
@property (strong, nonatomic) NSArray* priorityList;
@property (strong, nonatomic) NSArray* statusList;
@property (strong, nonatomic) NSArray* userList;
@property (strong, nonatomic) NSArray* timeEntryActivityList;
-(OZLModelTracker*)trackerWithId:(int)index;
-(OZLModelIssuePriority*)issuePriorityWithId:(int)index;
-(OZLModelIssueStatus*)issueStatusWithId:(int)index;
-(OZLModelUser*)userWithId:(int)index;

+(BOOL) isUserLoggedIn;

@end
