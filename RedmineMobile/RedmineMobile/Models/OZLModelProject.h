//
//  OZLModelProject.h
//  RedmineMobile
//
//  Created by Lee Zhijie on 7/15/13.
//  Copyright (c) 2013 Lee Zhijie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OZLModelProject : NSObject

@property(nonatomic) int index;
@property(nonatomic,strong) NSString* description;
@property(nonatomic,strong) NSString* name;
@property(nonatomic) int parentId;
@property(nonatomic,strong) NSString* createdOn;
@property(nonatomic,strong) NSString* updatedOn;

-(id)initWithDictionary:(NSDictionary*)dic;
@end
