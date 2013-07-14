//
//  OZLAppDelegate.h
//  RedmineMobile
//
//  Created by Lee Zhijie on 7/14/13.
//  Copyright (c) 2013 Lee Zhijie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPRevealSideViewController.h"

@interface OZLAppDelegate : UIResponder <UIApplicationDelegate,PPRevealSideViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) PPRevealSideViewController *revealSideViewController;

@end
