//
//  OZLIssueCreateOrUpdateViewController.h
//  RedmineMobile
//
//  Created by lizhijie on 7/16/13.

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

#import <UIKit/UIKit.h>
#import "OZLModelIssue.h"
#import "OZLModelProject.h"

typedef enum {
	OZLIssueInfoViewModeCreate,
//    OZLIssueInfoViewModeDisplay,
    OZLIssueInfoViewModeEdit
} OZLIssueInfoViewMode;

@interface OZLIssueCreateOrUpdateViewController : UITableViewController<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
- (IBAction)onCancel:(id)sender;
- (IBAction)onSave:(id)sender;

@property (weak, nonatomic) NSArray* trackerList;
@property (weak, nonatomic) NSArray* priorityList;
@property (weak, nonatomic) NSArray* statusList;
@property (weak, nonatomic) NSArray* userList;


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
@property(nonatomic, strong) OZLModelIssue* issueData;// used for update issue
@property(nonatomic) OZLIssueInfoViewMode viewMode;

//@property(nonatomic,strong) NSArray* issueList;

@end
