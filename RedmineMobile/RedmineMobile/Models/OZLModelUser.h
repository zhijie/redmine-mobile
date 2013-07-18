//
//  OZLModelUser.h
//  RedmineMobile
//
//  Created by lizhijie on 7/15/13.
//  Copyright (c) 2013 Lee Zhijie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OZLModelUser : NSObject

@property(nonatomic) int index;
@property(nonatomic, strong) NSString* login;
@property(nonatomic, strong) NSString* firstname;
@property(nonatomic, strong) NSString* lastname;
@property(nonatomic, strong) NSString* mail;
@property(nonatomic, strong) NSString* createdOn;
@property(nonatomic, strong) NSString* lastLoginIn;

@property(nonatomic, strong) NSString* name;

-(id)initWithDictionary:(NSDictionary*)dic;

@end
