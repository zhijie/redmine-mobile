//
//  OZLSingleton.m
//  RedmineMobile
//
//  Created by Lee Zhijie on 7/15/13.
//  Copyright (c) 2013 Lee Zhijie. All rights reserved.
//

#import "OZLSingleton.h"

@implementation OZLSingleton

NSString* USER_DEFUALTS_REDMINE_HOME_URL = @"USER_DEFUALTS_REDMINE_HOME_URL";
NSString* USER_DEFUALTS_REDMINE_USER_KEY = @"USER_DEFUALTS_REDMINE_USER_KEY";


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

@end
