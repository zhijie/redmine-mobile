//
//  OZLAccountViewController.h
//  RedmineMobile
//
//  Created by Lee Zhijie on 7/14/13.
//  Copyright (c) 2013 Lee Zhijie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OZLAccountViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *redmineHomeURL;
@property (strong, nonatomic) IBOutlet UITextField *redmineUserKey;
- (IBAction)onOk:(id)sender;

@end
