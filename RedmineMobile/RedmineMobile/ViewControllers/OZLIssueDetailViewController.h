//
//  OZLIssueDetailViewController.h
//  RedmineMobile
//
//  Created by lizhijie on 7/17/13.
//  Copyright (c) 2013 Lee Zhijie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OZLModelIssue.h"

@interface OZLIssueDetailViewController : UITableViewController
@property(nonatomic,strong) OZLModelIssue* issueData;
@property (weak, nonatomic) IBOutlet UILabel *subject;
@property (weak, nonatomic) IBOutlet UILabel *description;
@property (weak, nonatomic) IBOutlet UIProgressView *progressbar;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *priority;
@property (weak, nonatomic) IBOutlet UILabel *author;
@property (weak, nonatomic) IBOutlet UILabel *assignedTo;
@property (weak, nonatomic) IBOutlet UILabel *startTime;
@property (weak, nonatomic) IBOutlet UILabel *dueTime;



@end
