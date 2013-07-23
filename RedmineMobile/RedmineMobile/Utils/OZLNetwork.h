//
//  OZLNetwork.h
//  RedmineMobile
//
//  Created by Lee Zhijie on 7/14/13.

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
#import "OZLModelProject.h"
#import "OZLModelIssue.h"
#import "OZLModelIssuePriority.h"
#import "OZLModelIssueStatus.h"
#import "OZLModelTracker.h"
#import "OZLModelUser.h"
#import "OZLModelTimeEntries.h"
#import "OZLModelIssueJournal.h"
#import "OZLModelIssueJournalDetail.h"
#import "OZLModelTimeEntryActivity.h"

@interface OZLNetwork : NSObject

// project 
+(void)getProjectListWithParams:(NSDictionary*)params andBlock:(void (^)(NSArray *result, NSError *error))block;
+(void)getDetailForProject:(int)projectid withParams:(NSDictionary*)params andBlock:(void (^)(OZLModelProject *result, NSError *error))block;
+(void)createProject:(OZLModelProject*)projectData withParams:(NSDictionary*)params andBlock:(void (^)(BOOL success, NSError *error))block;
+(void)updateProject:(OZLModelProject*)projectData withParams:(NSDictionary*)params andBlock:(void (^)(BOOL success, NSError *error))block;
+(void)deleteProject:(int)projectid withParams:(NSDictionary*)params andBlock:(void (^)(BOOL success, NSError *error))block;


// issue
+(void)getIssueListForProject:(int)projectid withParams:(NSDictionary*)params andBlock:(void (^)(NSArray *result, NSError *error))block;
+(void)getDetailFoIssue:(int)issueid withParams:(NSDictionary*)params andBlock:(void (^)(OZLModelIssue *result, NSError *error))block;
+(void)createIssue:(OZLModelIssue*)issueData withParams:(NSDictionary*)params andBlock:(void (^)(BOOL success, NSError *error))block;
+(void)updateIssue:(OZLModelIssue*)issueData withParams:(NSDictionary*)params andBlock:(void (^)(BOOL success, NSError *error))block;
+(void)deleteIssue:(int)issueid withParams:(NSDictionary*)params andBlock:(void (^)(BOOL success, NSError *error))block;
+(void)getJournalListForIssue:(int)issueid withParams:(NSDictionary*)params andBlock:(void (^)(NSArray *result, NSError *error))block;

// priority
+(void)getPriorityListWithParams:(NSDictionary*)params andBlock:(void (^)(NSArray *result, NSError *error))block;
// user
+(void)getUserListWithParams:(NSDictionary*)params andBlock:(void (^)(NSArray *result, NSError *error))block;
// issue status
+(void)getIssueStatusListWithParams:(NSDictionary*)params andBlock:(void (^)(NSArray *result, NSError *error))block;
// tracker
+(void)getTrackerListWithParams:(NSDictionary*)params andBlock:(void (^)(NSArray *result, NSError *error))block;

// time entries
+(void)getTimeEntriesWithParams:(NSDictionary*)params andBlock:(void (^)(NSArray *result, NSError *error))block;
+(void)getTimeEntriesForIssueId:(int)issueid withParams:(NSDictionary*)params andBlock:(void (^)(NSArray *result, NSError *error))block;
+(void)getTimeEntriesForProjectId:(int)projectid withParams:(NSDictionary*)params andBlock:(void (^)(NSArray *result, NSError *error))block;
+(void)getTimeEntryListWithParams:(NSDictionary*)params andBlock:(void (^)(NSArray *result, NSError *error))block;
+(void)createTimeEntry:(OZLModelTimeEntries*)timeEntry withParams:(NSDictionary*)params andBlock:(void (^)(BOOL success, NSError *error))block;


@end
