//
//  OZLIssueLogtimeViewController.h
//  RedmineMobile
//
//  Created by lizhijie on 7/23/13.
//  Copyright (c) 2013 Lee Zhijie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OZLModelIssue.h"
#import "OZLModelTimeEntryActivity.h"

@interface OZLIssueLogtimeViewController : UITableViewController

@property (nonatomic, strong) OZLModelIssue* issueData;
@property (nonatomic, strong) NSArray* timeEntryActivityList;

@property (weak, nonatomic) IBOutlet UITextField *hours;
@property (weak, nonatomic) IBOutlet UITextField *activity;
@property (weak, nonatomic) IBOutlet UITextField *dateLabel;
@property (weak, nonatomic) IBOutlet UITextView *comment;

@end
