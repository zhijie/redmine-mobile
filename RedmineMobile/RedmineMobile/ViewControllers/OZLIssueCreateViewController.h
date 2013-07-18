//
//  OZLIssueCreateViewController.h
//  RedmineMobile
//
//  Created by lizhijie on 7/16/13.
//  Copyright (c) 2013 Lee Zhijie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OZLModelIssue.h"
#import "OZLModelProject.h"

@interface OZLIssueCreateViewController : UITableViewController<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
- (IBAction)onCancel:(id)sender;
- (IBAction)onSave:(id)sender;

// neccessory
@property (weak, nonatomic) IBOutlet UITextField *subjectTextField;
@property (weak, nonatomic) IBOutlet UILabel *trackerLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *priorityLabel;
// optional
@property (weak, nonatomic) IBOutlet UILabel *assigneeLabel;
@property (weak, nonatomic) IBOutlet UITextField *startDateLabel;
@property (weak, nonatomic) IBOutlet UITextField *dueDateLabel;
@property (weak, nonatomic) IBOutlet UITextField *estimatedHoursLabel;
@property (weak, nonatomic) IBOutlet UITextField *doneProgressLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextview;

@property(nonatomic,strong) OZLModelProject* parentProject;
@property(nonatomic,strong) OZLModelIssue* parentIssue;
@property(nonatomic,strong) NSArray* issueList;
@end
