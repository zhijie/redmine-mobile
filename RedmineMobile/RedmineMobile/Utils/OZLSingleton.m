//
//  OZLSingleton.m
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

#import "OZLSingleton.h"
#import "OZLConstants.h"

@implementation OZLSingleton

NSString* USER_DEFUALTS_REDMINE_HOME_URL = @"USER_DEFUALTS_REDMINE_HOME_URL";
NSString* USER_DEFUALTS_REDMINE_USER_KEY = @"USER_DEFUALTS_REDMINE_USER_KEY";
NSString* USER_DEFUALTS_LAST_PROJECT_ID = @"USER_DEFUALTS_LAST_PROJECT_ID";
NSString* USER_DEFUALTS_REDMINE_USER_NAME = @"USER_DEFUALTS_REDMINE_USER_NAME";
NSString* USER_DEFUALTS_REDMINE_PASSWORD = @"USER_DEFUALTS_REDMINE_PASSWORD";

static OZLSingleton* sharedInstance = nil;
+(OZLSingleton*) sharedInstance
{
    if (sharedInstance == nil) {
        sharedInstance = [[OZLSingleton alloc] init
                          ];
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary* dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"http://demo.redmine.org/",USER_DEFUALTS_REDMINE_HOME_URL,
                             @"",USER_DEFUALTS_REDMINE_USER_KEY,
                             [NSNumber numberWithInt:-1],USER_DEFUALTS_LAST_PROJECT_ID,
                             @"",USER_DEFUALTS_REDMINE_USER_NAME,
                             @"",USER_DEFUALTS_REDMINE_PASSWORD,
                             nil];
        [defaults registerDefaults:dic];
    }
    return sharedInstance;
}

-(NSString*)redmineHomeURL
{
    NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
    return [userdefaults objectForKey:USER_DEFUALTS_REDMINE_HOME_URL];
}
-(void)setRedmineHomeURL:(NSString *)redmineHomeURL
{
    NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setObject:redmineHomeURL forKey:USER_DEFUALTS_REDMINE_HOME_URL];
    [userdefaults synchronize];
    
}
-(NSString*)redmineUserKey
{
    NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
    return [userdefaults objectForKey:USER_DEFUALTS_REDMINE_USER_KEY];
}
-(void)setRedmineUserKey:(NSString *)redmineUserKey
{
    NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setObject:redmineUserKey forKey:USER_DEFUALTS_REDMINE_USER_KEY];
    [userdefaults synchronize];    
}
-(int)lastProjectID
{
    NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
    return [userdefaults integerForKey:USER_DEFUALTS_LAST_PROJECT_ID];
}
-(void)setLastProjectID:(int)projectid
{
    NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setInteger:projectid forKey:USER_DEFUALTS_LAST_PROJECT_ID];
    [userdefaults synchronize];
}

-(NSString*)redmineUserName
{
    NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
    return [userdefaults objectForKey:USER_DEFUALTS_REDMINE_USER_NAME];
}

-(void)setRedmineUserName:(NSString *)redmineUserName
{
    NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setObject:redmineUserName forKey:USER_DEFUALTS_REDMINE_USER_NAME];
    [userdefaults synchronize];
}

-(NSString*)redminePassword
{
    NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
    return [userdefaults objectForKey:USER_DEFUALTS_REDMINE_PASSWORD];
}

-(void)setRedminePassword:(NSString *)redminePassword
{
    NSUserDefaults* userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setObject:redminePassword forKey:USER_DEFUALTS_REDMINE_PASSWORD];
    [userdefaults synchronize];
}
@end
