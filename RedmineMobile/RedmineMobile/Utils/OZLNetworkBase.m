//
//  OZLNetworkBase.m
//  RedmineMobile
//
//  Created by Lee Zhijie on 7/15/13.
//  Copyright (c) 2013 Lee Zhijie. All rights reserved.
//

#import "OZLNetworkBase.h"
#import "AFJSONRequestOperation.h"
#import "OZLSingleton.h"


@implementation OZLNetworkBase

+(OZLNetworkBase *)sharedClient
{
    static OZLNetworkBase *_sharedClient = nil;
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
    
    return self;
}

@end
