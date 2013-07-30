//
//  OZLIssueLogtimeViewController.m
//  RedmineMobile
//
//  Created by lizhijie on 7/23/13.

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

#import "OZLIssueLogtimeViewController.h"
#import "MBProgressHUD.h"
#import "MLTableAlert.h"
#import "OZLNetwork.h"
#import "OZLSingleton.h"

@interface OZLIssueLogtimeViewController () {
    MBProgressHUD* _HUD;
    float _hourValue;
    OZLModelTimeEntries* _entry;
}
@end

@implementation OZLIssueLogtimeViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // initialize data
    _hourValue = 0;
    _entry = [[OZLModelTimeEntries alloc] init];
    _timeEntryActivityList = [[OZLSingleton sharedInstance] timeEntryActivityList];

    UIBarButtonItem* cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onCancel:)];
    [self.navigationItem setLeftBarButtonItem:cancelBtn];
    UIBarButtonItem* saveBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(onSave:)];
    [self.navigationItem setRightBarButtonItem:saveBtn];

    [self.navigationItem setTitle:@"Log Time"];

    [self setupInputViews];
    
    // hud
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:_HUD];
	_HUD.labelText = @"Loading...";
}

-(void)setupInputViews
{
    [_activity setUserInteractionEnabled:NO];

    // setup time picker inputview
    UIDatePicker* timerPicker = [[UIDatePicker alloc]init];
    [timerPicker setDatePickerMode:UIDatePickerModeCountDownTimer];
    [timerPicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    timerPicker.minuteInterval = 5;
    // setup datapicker inputview
    UIDatePicker* datePicker = [[UIDatePicker alloc]init];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    // accessoryview
    UIToolbar* inputAccessoryView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    UIBarButtonItem* accessoryDoneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(accessoryDoneClicked:)];
    UIBarButtonItem* flexleft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    inputAccessoryView.items = [NSArray arrayWithObjects:flexleft, accessoryDoneButton, nil];

    _hours.inputView = timerPicker;
    _hours.inputAccessoryView = inputAccessoryView;
    _dateLabel.inputView = datePicker;
    _dateLabel.inputAccessoryView = inputAccessoryView;
}
-(void) onCancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) onSave:(id)sender
{
    _HUD.mode = MBProgressHUDModeIndeterminate;
    _HUD.labelText = @"Logging time ...";
    _HUD.detailsLabelText = @"";
    [_HUD show:YES];

    // build entry
    _entry.issue = _issueData;
    _entry.hours = _hourValue;
    if (_comment.text.length > 0) {
        _entry.comments = _comment.text;
    }
    if (_dateLabel.text.length > 0) {
        _entry.createdOn = _dateLabel.text;
    }

    [OZLNetwork createTimeEntry:_entry withParams:nil andBlock:^(BOOL success, NSError *error){
        if (error) {
            NSLog(@"log time error: %@",error.description);
            _HUD.mode = MBProgressHUDModeText;
            _HUD.labelText = @"Connection Failed";
            _HUD.detailsLabelText = @" Please check network connection or your account setting.";
            [_HUD hide:YES afterDelay:3];
        }else {
            [self.navigationController popViewControllerAnimated:YES];
            [_HUD hide:YES];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 1) {//activity
        MLTableAlert* tableAlert = [MLTableAlert tableAlertWithTitle:@"Activty" cancelButtonTitle:@"Cancel" numberOfRows:^NSInteger (NSInteger section)
                                    {
                                        return  [_timeEntryActivityList  count] + 1;
                                    }
                                                            andCells:^UITableViewCell* (MLTableAlert *anAlert, NSIndexPath *alertIndexPath)
                                    {
                                        static NSString *CellIdentifier = @"CellIdentifier";
                                        UITableViewCell *cell = [anAlert.table dequeueReusableCellWithIdentifier:CellIdentifier];
                                        if (cell == nil)
                                            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

                                        if (alertIndexPath.row == 0) {
                                            cell.textLabel.text = @"None";
                                        }else {
                                            cell.textLabel.text = [[_timeEntryActivityList objectAtIndex:alertIndexPath.row - 1] name];
                                        }
                                        return cell;
                                    }];

        // Setting custom alert height
        tableAlert.height = 350;

        // configure actions to perform
        [tableAlert configureSelectionBlock:^(NSIndexPath *selectedIndex){
            if (selectedIndex.row == 0) {
                _activity.text = @"None";
                _entry.activity = nil;
            }else {
                _activity.text = [[ _timeEntryActivityList objectAtIndex:selectedIndex.row - 1] name];
                _entry.activity = [_timeEntryActivityList objectAtIndex:selectedIndex.row -1];
            }
            [_activity sizeToFit];
        } andCompletionBlock:^{
            
        }];
        
        [tableAlert show];
    }
}

- (void)viewDidUnload {
    [self setHours:nil];
    [self setActivity:nil];
    [self setDateLabel:nil];
    [self setComment:nil];
    [super viewDidUnload];
}

#pragma mark data picker value changed
-(void)datePickerValueChanged:(id)sender
{
    UIDatePicker* datepicker = (UIDatePicker*)sender;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

    if (_hours.isFirstResponder) {

        NSString* timeStr = [NSString stringWithFormat:@"%d Mins",(int)datepicker.countDownDuration/60];
        _hours.text = timeStr;
        _hourValue = (int)(datepicker.countDownDuration/3600.f);
    }else {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];

        NSString* dateStr = [dateFormatter stringFromDate:datepicker.date];
        _dateLabel.text = dateStr;
    }
}

-(void)accessoryDoneClicked:(id)sender
{
    [self.view endEditing:YES];
}

@end
