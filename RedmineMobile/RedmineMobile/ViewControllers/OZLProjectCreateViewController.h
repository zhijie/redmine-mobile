//
//  OZLProjectCreateViewController.h
//  RedmineMobile
//
//  Created by lizhijie on 7/16/13.
//  Copyright (c) 2013 Lee Zhijie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OZLModelProject.h"

@interface OZLProjectCreateViewController : UITableViewController
- (IBAction)onCancel:(id)sender;
- (IBAction)onSave:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *identifier;
@property (weak, nonatomic) IBOutlet UITextField *homepageUrl;
@property (weak, nonatomic) IBOutlet UITextView *description;
@property (nonatomic) BOOL isPublic;
@property (nonatomic,strong) OZLModelProject* parentProject;
@property (nonatomic,strong) NSArray* projectList;

@end
