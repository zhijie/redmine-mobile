//
//  OZLIssueCreateViewController.m
//  RedmineMobile
//
//  Created by lizhijie on 7/16/13.
//  Copyright (c) 2013 Lee Zhijie. All rights reserved.
//

#import "OZLIssueCreateViewController.h"
#import "OZLNetwork.h"
#import "MBProgressHUD.h"
#import "OZLModelIssuePriority.h"
#import "OZLModelTracker.h"
#import "OZLModelUser.h"
#import "OZLModelIssueStatus.h"
#import "MLTableAlert.h"

@interface OZLIssueCreateViewController () {
    NSArray* _trackerList;
    NSArray* _priorityList;
    NSArray* _statusList;
    NSArray* _userList;

    OZLModelTracker* _currentTracker;
    OZLModelIssuePriority* _currentPriority;
    OZLModelIssueStatus* _currentStatus;
    OZLModelUser* _currentUser;

    NSDate* _currentStartDate;
    NSDate* _currentDueDate;
    int _currentEstimatedTime;//minutes

    MBProgressHUD* _HUD;
}

@end

@implementation OZLIssueCreateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem* cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onCancel:)];
    [self.navigationItem setLeftBarButtonItem:cancelBtn];
    UIBarButtonItem* saveBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(onSave:)];
    [self.navigationItem setRightBarButtonItem:saveBtn];

    [self setupInputviews];

    // hud
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:_HUD];
	_HUD.labelText = @"Loading...";

    [self loadIssueRelatedData];
}

-(void) setupInputviews
{
    // setup datapicker inputview
    UIDatePicker* datePicker = [[UIDatePicker alloc]init];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    // accessoryview
    UIToolbar* inputAccessoryView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    UIBarButtonItem* accessoryDoneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(accessoryDoneClicked:)];
    UIBarButtonItem* flexleft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    inputAccessoryView.items = [NSArray arrayWithObjects:flexleft, accessoryDoneButton, nil];;

    _startDateLabel.inputView = datePicker;
    _startDateLabel.inputAccessoryView = inputAccessoryView;
    _startDateLabel.delegate = self;
    _dueDateLabel.inputView = datePicker;
    _dueDateLabel.inputAccessoryView = inputAccessoryView;
    _dueDateLabel.delegate = self;

    // setup time picker inputview
    UIDatePicker* timerPicker = [[UIDatePicker alloc]init];
    [timerPicker setDatePickerMode:UIDatePickerModeCountDownTimer];
    [timerPicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    timerPicker.minuteInterval = 5;
    _estimatedHoursLabel.inputView = timerPicker;
    _estimatedHoursLabel.inputAccessoryView = inputAccessoryView;
    _estimatedHoursLabel.delegate = self;

    // setup percentage pickerview
    UIPickerView* percentageView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 162)];
    percentageView.dataSource = self;
    percentageView.delegate = self;
    [percentageView selectRow:0 inComponent:0 animated:NO];
    _doneProgressLabel.inputView = percentageView;
    _doneProgressLabel.inputAccessoryView = inputAccessoryView;
    _doneProgressLabel.delegate = self;
}

-(void)loadIssueRelatedData
{
    static int doneCount = 0;
    [_HUD show:YES];
    [OZLNetwork getTrackerListWithParams:nil andBlock:^(NSArray *result, NSError *error) {
        if (!error) {
            _trackerList = result;
        }else {
            NSLog(@"get tracker list error : %@",error.description);
        }
        doneCount ++;
        if (doneCount == 4) {
            [_HUD hide:YES];
            doneCount = 0;
        }
    }];

    [OZLNetwork getIssueStatusListWithParams:nil andBlock:^(NSArray *result, NSError *error) {
        if (!error) {
            _statusList = result;
        }else {
            NSLog(@"get issue status list error : %@",error.description);
        }
        doneCount ++;
        if (doneCount == 4) {
            [_HUD hide:YES];
            doneCount = 0;
        }
    }];
    [OZLNetwork getPriorityListWithParams:nil andBlock:^(NSArray *result, NSError *error) {
        if (!error) {
            _priorityList = result;
        }else {
            NSLog(@"get priority list error : %@",error.description);
        }
        doneCount ++;
        if (doneCount == 4) {
            [_HUD hide:YES];
            doneCount = 0;
        }
    }];
    [OZLNetwork getUserListWithParams:nil andBlock:^(NSArray *result, NSError *error) {
        if (!error) {
            _userList = result;
        }else {
            NSLog(@"get user list error : %@",error.description);
        }
        doneCount ++;
        if (doneCount == 4) {
            [_HUD hide:YES];
            doneCount = 0;
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onSave:(id)sender {

    if (_subjectTextField.text.length == 0) {
        _HUD.mode = MBProgressHUDModeText;
        _HUD.labelText = @"subject can not be empty.";
        [_HUD show:YES];
        [_HUD hide:YES afterDelay:1];
        return;
    }
    if (_currentUser == nil) {
        _HUD.mode = MBProgressHUDModeText;
        _HUD.labelText = @"tracker can not be empty.";
        [_HUD show:YES];
        [_HUD hide:YES afterDelay:1];
        return;
    }
    if (_currentStatus == nil) {
        _HUD.mode = MBProgressHUDModeText;
        _HUD.labelText = @"status can not be empty.";
        [_HUD show:YES];
        [_HUD hide:YES afterDelay:1];
        return;
    }
    if (_currentPriority == nil) {
        _HUD.mode = MBProgressHUDModeText;
        _HUD.labelText = @"priority can not be empty.";
        [_HUD show:YES];
        [_HUD hide:YES afterDelay:1];
        return;
    }

    OZLModelIssue* issueData = [[OZLModelIssue alloc] init];
    issueData.subject = _subjectTextField.text;
    issueData.tracker = _currentTracker;
    issueData.status = _currentStatus;
    issueData.priority = _currentPriority;
    issueData.assignedTo = _currentUser;
    issueData.projectId = _parentProject.index;

    if (_parentIssue) {
        issueData.parentIssueId = _parentIssue.index;
    }
    issueData.description = _descriptionTextview.text;
    issueData.startDate = _startDateLabel.text;
    issueData.dueDate = _dueDateLabel.text;
    issueData.doneRatio =  [_doneProgressLabel.text integerValue];
    issueData.estimatedHours = _currentEstimatedTime/60.0f;
    //TODO: is_public is not processed yet


    _HUD.mode = MBProgressHUDModeIndeterminate;
    _HUD.labelText = @"Creating Project...";
    [_HUD show:YES];
    [OZLNetwork createIssue:issueData withParams:nil andBlock:^(BOOL success, NSError *error){
        if (error) {
            NSLog(@"create project error: %@",error.description);
        }else {

        }
        [_HUD hide:YES];
    }];

}

- (void)viewDidUnload {
    [self setSubjectTextField:nil];
    [self setTrackerLabel:nil];
    [self setStatusLabel:nil];
    [self setPriorityLabel:nil];
    [self setAssigneeLabel:nil];
    [self setStartDateLabel:nil];
    [self setDueDateLabel:nil];
    [self setEstimatedHoursLabel:nil];
    [self setDoneProgressLabel:nil];
    [self setDescriptionTextview:nil];
    [super viewDidUnload];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray* alertTitles = @[@"Select Tracker", @"Select Status", @"Select Priority", @"Select Assignee"];
    NSArray* dataArray = @[_trackerList, _statusList, _priorityList, _userList];
    if (indexPath.section == 1) {

        MLTableAlert* tableAlert = [MLTableAlert tableAlertWithTitle:[alertTitles objectAtIndex:indexPath.row] cancelButtonTitle:@"Cancel" numberOfRows:^NSInteger (NSInteger section)
                                    {
                                        return  [[dataArray objectAtIndex:indexPath.row] count] + 1;
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
                                            cell.textLabel.text = [[[dataArray objectAtIndex:indexPath.row ]objectAtIndex:alertIndexPath.row - 1] name];
                                        }
                                        return cell;
                                    }];

        // Setting custom alert height
        tableAlert.height = 350;

        // configure actions to perform
        [tableAlert configureSelectionBlock:^(NSIndexPath *selectedIndex){
            UITableViewCell* parentCell = [self.tableView cellForRowAtIndexPath:indexPath];
            if (selectedIndex.row == 0) {
                switch (indexPath.row) {
                    case 0:{//tracker
                        _currentTracker = nil;
                    }break;
                    case 1:{//status
                        _currentStatus = nil;
                    }break;
                    case 2:{//priority
                        _currentPriority = nil;
                    }break;
                    case 3:{//assignee
                        _currentUser = nil;
                    }break;
                    default:
                        break;
                }

                parentCell.detailTextLabel.text = @"None";
            }else {
                id data = [[dataArray objectAtIndex:indexPath.row ] objectAtIndex:selectedIndex.row - 1];
                switch (indexPath.row) {
                    case 0:{//tracker
                        _currentUser = data;
                    }break;
                    case 1:{//status
                        _currentStatus = data;
                    }break;
                    case 2:{//priority
                        _currentPriority = data;
                    }break;
                    case 3:{//assignee
                        _currentUser = data;
                    }break;

                    default:
                        break;
                }

                parentCell.detailTextLabel.text = [data name];
            }
            [parentCell.detailTextLabel sizeToFit];
        } andCompletionBlock:^{

        }];

        [tableAlert show];
        
    }else if( indexPath.section == 2){
        switch (indexPath.row) {
            case 0:{//start date

            }break;
            case 1:{//due date

            }break;
            case 2:{//estimated hours

            }break;
            case 3:{//done

            }break;
                
            default:
                break;
        }
    }

    [self.tableView reloadData];
}

#pragma mark -
#pragma mark delegate of textfield inputview

#pragma mark data picker value changed
-(void)datePickerValueChanged:(id)sender
{
    UIDatePicker* datepicker = (UIDatePicker*)sender;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

    if (_estimatedHoursLabel.isFirstResponder) {

         NSString* timeStr = [NSString stringWithFormat:@"%d Mins",(int)datepicker.countDownDuration/60];
        _estimatedHoursLabel.text = timeStr;
        _currentEstimatedTime = (int)datepicker.countDownDuration/60;
    }else {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSString* dateStr = [dateFormatter stringFromDate:datepicker.date];
        if (_startDateLabel.isFirstResponder) {
            _startDateLabel.text = dateStr;
            _currentStartDate = datepicker.date;
        }else if(_dueDateLabel.isFirstResponder) {
            _dueDateLabel.text = dateStr;
            _currentDueDate = datepicker.date;
        }
    }
}
-(void)accessoryDoneClicked:(id)sender
{
    [self.view endEditing:YES];
}

#pragma mark -
#pragma mark picker view delegate and datasource
- (void)pickerView:(UIPickerView *)pV didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _doneProgressLabel.text = [NSString stringWithFormat:@"%d %%",row  * 10];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 11;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%d %%",row  * 10];
}

@end
