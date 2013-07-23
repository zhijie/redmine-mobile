//
//  OZLNetwork.m
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

#import "OZLNetwork.h"
#import "OZLNetworkBase.h"
#import "AFHTTPRequestOperation.h"
#import "JSONKit.h"
#import "OZLSingleton.h"

@implementation OZLNetwork

#pragma mark-
#pragma mark project api
+(void)getProjectListWithParams:(NSDictionary*)params andBlock:(void (^)(NSArray *result, NSError *error))block;
{
    NSString* path = @"/projects.json";
    NSMutableDictionary* paramsDic = [[NSMutableDictionary alloc] initWithDictionary:params];
    NSString* accessKey = [[OZLSingleton sharedInstance] redmineUserKey];
    if (accessKey.length > 0) {
        [paramsDic setObject:accessKey forKey:@"key"];
    }

    [[OZLNetworkBase sharedClient] setAuthorizationHeader];
    [[OZLNetworkBase sharedClient] getPath:path parameters:paramsDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (block) {
            NSLog(@"the repsonse:%@",responseObject);
            NSMutableArray* projects = [[NSMutableArray alloc] init];
            
            NSArray* projectsDic = [responseObject objectForKey:@"projects"];
            for (NSDictionary* p in projectsDic) {
                [projects addObject:[[OZLModelProject alloc] initWithDictionary:p]];
            }
            block(projects,nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (block) {
            block([NSArray array], error);
        }
        
    }];
}

+(void)getDetailForProject:(int)projectid withParams:(NSDictionary*)params andBlock:(void (^)(OZLModelProject *result, NSError *error))block
{
    NSString* path = [NSString stringWithFormat:@"/projects/%d.json",projectid];
    NSMutableDictionary* paramsDic = [[NSMutableDictionary alloc] initWithDictionary:params];
    NSString* accessKey = [[OZLSingleton sharedInstance] redmineUserKey];
    if (accessKey.length > 0) {
        [paramsDic setObject:accessKey forKey:@"key"];
    }

    [[OZLNetworkBase sharedClient] getPath:path parameters:paramsDic success:^(AFHTTPRequestOperation *operation, id responseObject) {

        if (block) {
            NSLog(@"the repsonse:%@",responseObject);

            NSDictionary* projectDic = [responseObject objectForKey:@"project"];
            OZLModelProject* project = [[OZLModelProject alloc] initWithDictionary:projectDic];

            block(project,nil);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        if (block) {
            block(nil, error);
        }

    }];
}

+(void)createProject:(OZLModelProject*)projectData withParams:(NSDictionary*)params andBlock:(void (^)(BOOL success, NSError *error))block
{
    NSString* path = @"/projects.json";

    //project info
    NSMutableDictionary* projectDic = [projectData toParametersDic];
    [projectDic addEntriesFromDictionary:params];
    
    NSString* accessKey = [[OZLSingleton sharedInstance] redmineUserKey];
    if (accessKey.length > 0) {
        [projectDic setObject:accessKey forKey:@"key"];
    }

    [[OZLNetworkBase sharedClient] postPath:path parameters:projectDic success:^(AFHTTPRequestOperation *operation, id responseObject) {

        if (block) {
            NSLog(@"the repsonse:%@",responseObject);
            block(YES,nil);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        if (block) {
            block(NO, error);
        }

    }];
}

+(void)updateProject:(OZLModelProject*)projectData withParams:(NSDictionary*)params andBlock:(void (^)(BOOL success, NSError *error))block
{
    NSString* path = [NSString stringWithFormat:@"/projects/%d.json",projectData.index];

    //project info
    NSMutableDictionary* projectDic = [projectData toParametersDic];
    [projectDic addEntriesFromDictionary:params];

    NSString* accessKey = [[OZLSingleton sharedInstance] redmineUserKey];
    if (accessKey.length > 0) {
        [projectDic setObject:accessKey forKey:@"key"];
    }

    [[OZLNetworkBase sharedClient] putPath:path parameters:projectDic success:^(AFHTTPRequestOperation *operation, id responseObject) {

        if (block) {
            NSLog(@"the repsonse:%@",responseObject);
            int repondNumber = [responseObject intValue];
            block(repondNumber == 201,nil);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        if (block) {
            block(NO, error);
        }
        
    }];

}

+(void)deleteProject:(int)projectid withParams:(NSDictionary*)params andBlock:(void (^)(BOOL success, NSError *error))block
{
    NSString* path = [NSString stringWithFormat:@"/projects/%d.json",projectid];
    NSMutableDictionary* paramsDic = [[NSMutableDictionary alloc] initWithDictionary:params];
    NSString* accessKey = [[OZLSingleton sharedInstance] redmineUserKey];
    if (accessKey.length > 0) {
        [paramsDic setObject:accessKey forKey:@"key"];
    }

    [[OZLNetworkBase sharedClient] deletePath:path parameters:paramsDic success:^(AFHTTPRequestOperation *operation, id responseObject) {

        if (block) {
            NSLog(@"the repsonse:%@",responseObject);
            int repondNumber = [responseObject intValue];
            block(repondNumber == 201,nil);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        if (block) {
            block(NO, error);
        }
        
    }];

}

#pragma mark -
#pragma mark issue api
+(void)getIssueListForProject:(int)projectid withParams:(NSDictionary*)params andBlock:(void (^)(NSArray *result, NSError *error))block
{
    NSString* path = [NSString stringWithFormat:@"/issues.json"];
    NSMutableDictionary* paramsDic = [[NSMutableDictionary alloc] initWithDictionary:params];
    [paramsDic setObject:[NSNumber numberWithInt:projectid] forKey:@"project_id"];
    NSString* accessKey = [[OZLSingleton sharedInstance] redmineUserKey];
    if (accessKey.length > 0) {
        [paramsDic setObject:accessKey forKey:@"key"];
    }

    [[OZLNetworkBase sharedClient] getPath:path parameters:paramsDic success:^(AFHTTPRequestOperation *operation, id responseObject) {

        if (block) {
            NSLog(@"the repsonse:%@",responseObject);

            NSMutableArray* issues = [[NSMutableArray alloc] init];

            NSArray* issuesDic = [responseObject objectForKey:@"issues"];
            for (NSDictionary* p in issuesDic) {
                [issues addObject:[[OZLModelIssue alloc] initWithDictionary:p]];
            }
            block(issues,nil);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        if (block) {
            block([NSArray array], error);
        }
        
    }];
}

+(void)getDetailFoIssue:(int)issueid withParams:(NSDictionary*)params andBlock:(void (^)(OZLModelIssue *result, NSError *error))block
{
    NSString* path = [NSString stringWithFormat:@"/issues/%d.json",issueid];

    NSMutableDictionary* paramsDic = [[NSMutableDictionary alloc] initWithDictionary:params];
    NSString* accessKey = [[OZLSingleton sharedInstance] redmineUserKey];
    if (accessKey.length > 0) {
        [paramsDic setObject:accessKey forKey:@"key"];
    }

    [[OZLNetworkBase sharedClient] getPath:path parameters:paramsDic success:^(AFHTTPRequestOperation *operation, id responseObject) {

        if (block) {
            NSLog(@"the repsonse:%@",responseObject);

            NSDictionary* projectDic = [responseObject objectForKey:@"issue"];
            OZLModelIssue* issue = [[OZLModelIssue alloc] initWithDictionary:projectDic];

            block(issue,nil);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {


        if (block) {
            block([NSArray array], error);
        }
        
    }];
}

+(void)createIssue:(OZLModelIssue*)issueData withParams:(NSDictionary*)params andBlock:(void (^)(BOOL success, NSError *error))block
{
    NSString* path = [NSString stringWithFormat:@"/issues.json"];

    //project info
    NSMutableDictionary* paramsDic = [[NSMutableDictionary alloc] initWithDictionary:params];
    [paramsDic addEntriesFromDictionary:[issueData toParametersDic]];

    NSString* accessKey = [[OZLSingleton sharedInstance] redmineUserKey];
    if (accessKey.length > 0) {
        [paramsDic setObject:accessKey forKey:@"key"];
    }

    [[OZLNetworkBase sharedClient] postPath:path parameters:paramsDic success:^(AFHTTPRequestOperation *operation, id responseObject) {

        if (block) {
            NSLog(@"the repsonse:%@",responseObject);
            block(YES,nil);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        if (block) {
            block(NO, error);
        }
        
    }];
}
+(void)updateIssue:(OZLModelIssue*)issueData withParams:(NSDictionary*)params andBlock:(void (^)(BOOL success, NSError *error))block
{
    NSString* path = [NSString stringWithFormat:@"/issues/%d.json",issueData.index];

    //project info
    NSMutableDictionary* paramsDic = [[NSMutableDictionary alloc] initWithDictionary:params];
    [paramsDic addEntriesFromDictionary:[issueData toParametersDic]];

    NSString* accessKey = [[OZLSingleton sharedInstance] redmineUserKey];
    if (accessKey.length > 0) {
        [paramsDic setObject:accessKey forKey:@"key"];
    }

    [[OZLNetworkBase sharedClient] putPath:path parameters:paramsDic success:^(AFHTTPRequestOperation *operation, id responseObject) {

        if (block) {
            NSLog(@"the repsonse:%@",responseObject);
            int repondNumber = [responseObject intValue];
            block(repondNumber == 201,nil);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        if (block) {
            block(NO, error);
        }
        
    }];
}

+(void)deleteIssue:(int)issueid withParams:(NSDictionary*)params andBlock:(void (^)(BOOL success, NSError *error))block
{
    NSString* path = [NSString stringWithFormat:@"/issues/%d.json",issueid];

    NSMutableDictionary* paramsDic = [[NSMutableDictionary alloc] initWithDictionary:params];
    NSString* accessKey = [[OZLSingleton sharedInstance] redmineUserKey];
    if (accessKey.length > 0) {
        [paramsDic setObject:accessKey forKey:@"key"];
    }
    
    [[OZLNetworkBase sharedClient] deletePath:path parameters:paramsDic success:^(AFHTTPRequestOperation *operation, id responseObject) {

        if (block) {
            NSLog(@"the repsonse:%@",responseObject);
            int repondNumber = [responseObject intValue];
            block(repondNumber == 201,nil);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        if (block) {
            block(NO, error);
        }
        
    }];
}

+(void)getJournalListForIssue:(int)issueid withParams:(NSDictionary*)params andBlock:(void (^)(NSArray *result, NSError *error))block
{
    NSString* path = [NSString stringWithFormat:@"/issues/%d.json?include=journals",issueid];
    NSMutableDictionary* paramsDic = [[NSMutableDictionary alloc] initWithDictionary:params];
    NSString* accessKey = [[OZLSingleton sharedInstance] redmineUserKey];
    if (accessKey.length > 0) {
        [paramsDic setObject:accessKey forKey:@"key"];
    }

    [[OZLNetworkBase sharedClient] getPath:path parameters:paramsDic success:^(AFHTTPRequestOperation *operation, id responseObject) {

        if (block) {
            NSLog(@"the repsonse:%@",responseObject);

            NSMutableArray* journals = [[NSMutableArray alloc] init];

            NSArray* journalsDic = [[responseObject objectForKey:@"issue"] objectForKey:@"journals"];
            for (NSDictionary* p in journalsDic) {
                [journals addObject:[[OZLModelIssueJournal alloc] initWithDictionary:p]];
            }
            block(journals,nil);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        if (block) {
            block([NSArray array], error);
        }
        
    }];
}

#pragma mark -
#pragma mark priority api
// priority
+(void)getPriorityListWithParams:(NSDictionary*)params andBlock:(void (^)(NSArray *result, NSError *error))block
{
    NSString* path = @"/enumerations/issue_priorities.json";
    NSMutableDictionary* paramsDic = [[NSMutableDictionary alloc] initWithDictionary:params];
    NSString* accessKey = [[OZLSingleton sharedInstance] redmineUserKey];
    if (accessKey.length > 0) {
        [paramsDic setObject:accessKey forKey:@"key"];
    }

    [[OZLNetworkBase sharedClient] setAuthorizationHeader];
    [[OZLNetworkBase sharedClient] getPath:path parameters:paramsDic success:^(AFHTTPRequestOperation *operation, id responseObject) {

        if (block) {
            NSLog(@"the repsonse:%@",responseObject);
            NSMutableArray* priorities = [[NSMutableArray alloc] init];

            NSArray* dic = [responseObject objectForKey:@"issue_priorities"];
            for (NSDictionary* p in dic) {
                [priorities addObject:[[OZLModelIssuePriority alloc] initWithDictionary:p]];
            }
            block(priorities,nil);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        if (block) {
            block([NSArray array], error);
        }
    }];
}

#pragma mark -
#pragma mark user api
// user
+(void)getUserListWithParams:(NSDictionary*)params andBlock:(void (^)(NSArray *result, NSError *error))block
{
    NSString* path = @"/users.json";
    NSMutableDictionary* paramsDic = [[NSMutableDictionary alloc] initWithDictionary:params];
    NSString* accessKey = [[OZLSingleton sharedInstance] redmineUserKey];
    if (accessKey.length > 0) {
        [paramsDic setObject:accessKey forKey:@"key"];
    }

    [[OZLNetworkBase sharedClient] setAuthorizationHeader];
    [[OZLNetworkBase sharedClient] getPath:path parameters:paramsDic success:^(AFHTTPRequestOperation *operation, id responseObject) {

        if (block) {
            NSLog(@"the repsonse:%@",responseObject);
            NSMutableArray* priorities = [[NSMutableArray alloc] init];

            NSArray* dic = [responseObject objectForKey:@"users"];
            for (NSDictionary* p in dic) {
                [priorities addObject:[[OZLModelUser alloc] initWithDictionary:p]];
            }
            block(priorities,nil);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        if (block) {
            block([NSArray array], error);
        }
    }];
}


#pragma mark -
#pragma mark issue status api
// issue status
+(void)getIssueStatusListWithParams:(NSDictionary*)params andBlock:(void (^)(NSArray *result, NSError *error))block
{
    NSString* path = @"/issue_statuses.json";
    NSMutableDictionary* paramsDic = [[NSMutableDictionary alloc] initWithDictionary:params];
    NSString* accessKey = [[OZLSingleton sharedInstance] redmineUserKey];
    if (accessKey.length > 0) {
        [paramsDic setObject:accessKey forKey:@"key"];
    }

    [[OZLNetworkBase sharedClient] setAuthorizationHeader];
    [[OZLNetworkBase sharedClient] getPath:path parameters:paramsDic success:^(AFHTTPRequestOperation *operation, id responseObject) {

        if (block) {
            NSLog(@"the repsonse:%@",responseObject);
            NSMutableArray* priorities = [[NSMutableArray alloc] init];

            NSArray* dic = [responseObject objectForKey:@"issue_statuses"];
            for (NSDictionary* p in dic) {
                [priorities addObject:[[OZLModelIssueStatus alloc] initWithDictionary:p]];
            }
            block(priorities,nil);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        if (block) {
            block([NSArray array], error);
        }
    }];
}

#pragma mark -
#pragma mark tracker api
// tracker
+(void)getTrackerListWithParams:(NSDictionary*)params andBlock:(void (^)(NSArray *result, NSError *error))block
{
    NSString* path = @"/trackers.json";
    NSMutableDictionary* paramsDic = [[NSMutableDictionary alloc] initWithDictionary:params];
    NSString* accessKey = [[OZLSingleton sharedInstance] redmineUserKey];
    if (accessKey.length > 0) {
        [paramsDic setObject:accessKey forKey:@"key"];
    }

    [[OZLNetworkBase sharedClient] setAuthorizationHeader];
    [[OZLNetworkBase sharedClient] getPath:path parameters:paramsDic success:^(AFHTTPRequestOperation *operation, id responseObject) {

        if (block) {
            NSLog(@"the repsonse:%@",responseObject);
            NSMutableArray* priorities = [[NSMutableArray alloc] init];

            NSArray* dic = [responseObject objectForKey:@"trackers"];
            for (NSDictionary* p in dic) {
                [priorities addObject:[[OZLModelTracker alloc] initWithDictionary:p]];
            }
            block(priorities,nil);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        if (block) {
            block([NSArray array], error);
        }
    }];
}


#pragma mark -
#pragma mark time entries
// time entries
+(void)getTimeEntriesWithParams:(NSDictionary*)params andBlock:(void (^)(NSArray *result, NSError *error))block
{
    NSString* path = @"/time_entries.json";
    NSMutableDictionary* paramsDic = [[NSMutableDictionary alloc] initWithDictionary:params];
    NSString* accessKey = [[OZLSingleton sharedInstance] redmineUserKey];
    if (accessKey.length > 0) {
        [paramsDic setObject:accessKey forKey:@"key"];
    }

    [[OZLNetworkBase sharedClient] setAuthorizationHeader];
    [[OZLNetworkBase sharedClient] getPath:path parameters:paramsDic success:^(AFHTTPRequestOperation *operation, id responseObject) {

        if (block) {
            NSLog(@"the repsonse:%@",responseObject);
            NSMutableArray* priorities = [[NSMutableArray alloc] init];

            NSArray* dic = [responseObject objectForKey:@"time_entries"];
            for (NSDictionary* p in dic) {
                [priorities addObject:[[OZLModelTimeEntries alloc] initWithDictionary:p]];
            }
            block(priorities,nil);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        if (block) {
            block([NSArray array], error);
        }
    }];

}

+(void)getTimeEntriesForIssueId:(int)issueid withParams:(NSDictionary*)params andBlock:(void (^)(NSArray *result, NSError *error))block
{
    NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:issueid],@"issue_id", nil];
    [OZLNetwork getTimeEntriesWithParams:param andBlock:block];
}

+(void)getTimeEntriesForProjectId:(int)projectid withParams:(NSDictionary*)params andBlock:(void (^)(NSArray *result, NSError *error))block
{

    NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:projectid],@"project_id", nil];
    [OZLNetwork getTimeEntriesWithParams:param andBlock:block];
}

+(void)getTimeEntryListWithParams:(NSDictionary*)params andBlock:(void (^)(NSArray *result, NSError *error))block
{
    NSString* path = @"/enumerations/time_entry_activities.json";
    NSMutableDictionary* paramsDic = [[NSMutableDictionary alloc] initWithDictionary:params];
    NSString* accessKey = [[OZLSingleton sharedInstance] redmineUserKey];
    if (accessKey.length > 0) {
        [paramsDic setObject:accessKey forKey:@"key"];
    }

    [[OZLNetworkBase sharedClient] setAuthorizationHeader];
    [[OZLNetworkBase sharedClient] getPath:path parameters:paramsDic success:^(AFHTTPRequestOperation *operation, id responseObject) {

        if (block) {
            NSLog(@"the repsonse:%@",responseObject);
            NSMutableArray* activities = [[NSMutableArray alloc] init];

            NSArray* dic = [responseObject objectForKey:@"time_entry_activities"];
            for (NSDictionary* p in dic) {
                [activities addObject:[[OZLModelTimeEntryActivity alloc] initWithDictionary:p]];
            }
            block(activities,nil);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        if (block) {
            block([NSArray array], error);
        }
    }];
}
+(void)createTimeEntry:(OZLModelTimeEntries*)timeEntry withParams:(NSDictionary*)params andBlock:(void (^)(BOOL success, NSError *error))block
{
    NSString* path = [NSString stringWithFormat:@"/time_entries.json"];

    //project info
    NSMutableDictionary* paramsDic = [[NSMutableDictionary alloc] initWithDictionary:params];
    [paramsDic addEntriesFromDictionary:[timeEntry toParametersDic]];

    NSString* accessKey = [[OZLSingleton sharedInstance] redmineUserKey];
    if (accessKey.length > 0) {
        [paramsDic setObject:accessKey forKey:@"key"];
    }

    [[OZLNetworkBase sharedClient] postPath:path parameters:paramsDic success:^(AFHTTPRequestOperation *operation, id responseObject) {

        if (block) {
            NSLog(@"the repsonse:%@",responseObject);
            block(YES,nil);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        if (block) {
            block(NO, error);
        }
        
    }];
}


@end
