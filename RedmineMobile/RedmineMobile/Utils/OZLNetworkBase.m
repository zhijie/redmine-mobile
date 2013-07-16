//
//  OZLNetworkBase.m
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

#import "OZLNetworkBase.h"
#import "AFJSONRequestOperation.h"
#import "OZLSingleton.h"
#import "OZLConstants.h"

@implementation OZLNetworkBase

static OZLNetworkBase *_sharedClient = nil;
+(OZLNetworkBase *)sharedClient
{
    if (_sharedClient == nil) {
        
        _sharedClient = [[OZLNetworkBase alloc] initWithBaseURL:[NSURL URLWithString:[[OZLSingleton sharedInstance] redmineHomeURL]]];

    };
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
	[self setDefaultHeader:@"Accept" value:@"application/json"];

    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(accountChanged) name:NOTIFICATION_REDMINE_ACCOUNT_CHANGED object:nil];

    [self setAuthorizationHeader];
    return self;
}

-(void)setAuthorizationHeader
{

    [self clearAuthorizationHeader];
    NSString* username = [[OZLSingleton sharedInstance] redmineUserName];
    NSString* password = [[OZLSingleton sharedInstance] redminePassword];
    [self setAuthorizationHeaderWithUsername:username password:password];

}

-(void)accountChanged
{
    _sharedClient = nil;

    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
}
@end
