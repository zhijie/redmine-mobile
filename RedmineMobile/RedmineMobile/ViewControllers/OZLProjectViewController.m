//
//  OZLProjectViewController.m
//  RedmineMobile
//
//  Created by Lee Zhijie on 7/14/13.

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

#import "OZLProjectViewController.h"
#import "PPRevealSideViewController.h"
#import "OZLProjectListViewController.h"
#import "OZLNetwork.h"
#import "MBProgressHUD.h"
#import "OZLProjectInfoViewController.h"
#import "OZLIssueDetailViewController.h"
#import "OZLIssueCreateOrUpdateViewController.h"
#import "OZLIssueFilterViewController.h"
#import "OZLSingleton.h"


@interface OZLProjectViewController () {
    NSMutableArray* _issuesList;

    float _sideviewOffset;
    MBProgressHUD * _HUD;
    UIBarButtonItem* _editBtn;
    UIBarButtonItem* _doneBtn;

    NSMutableDictionary* _issueListOption;
}

@end

@implementation OZLProjectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self changeSideViewOffset:40];

    _editBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editIssueList:)];
    _doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(editIssueListDone:)];
    [self.navigationItem setRightBarButtonItem:_editBtn];

    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:_HUD];
	_HUD.labelText = @"Loading...";
    
    [[OZLSingleton sharedInstance] setLastProjectID:_projectData.index];
}

-(void) viewWillAppear:(BOOL)animated
{
    [self reloadData];
}

-(void) reloadData
{
    if (_projectData == nil) {
        NSLog(@"error: _projectData have to be set");
        return;
    }
    [_HUD show:YES];

    if (_issueListOption == nil) {
        [self loadIssueRelatedData];
    }else {
        [self loadProjectDetail];
    }
}

-(void)loadProjectDetail
{
    // TODO: issue filter not working yet

    // prepare parameters
    OZLSingleton* singleton = [OZLSingleton sharedInstance];
    // meaning of these values is defined in OZLIssueFilterViewController
    int filterType = [singleton issueListFilterType];
    int sortType = [singleton issueListSortType];
    int scendingType = [singleton issueListSortAscending];
    if (filterType == 0) {// assigned to me
        // TODO:
    }else if(filterType == 1) {// open

        [_issueListOption setObject:@"open" forKey:@"status_id"];

    }else if(filterType == 2) {// reported by me
        // TODO: 
    }
    
    NSArray* sortCol = @[@"id",@"tracker",@"status",@"priority",@"category",@"assigned_to_id",@"fixed_version",@"start_date",@"due_date",@"estimated_hours",@"done_ratio",@"updated_on"];
    NSString* sortstring = [NSString stringWithFormat:@"%@%@",[sortCol objectAtIndex:sortType],(scendingType == 0 ? @"" : @":desc")];
    [_issueListOption setObject:sortstring forKey:@"sort"];
    
    [OZLNetwork getDetailForProject:_projectData.index withParams:nil andBlock:^(OZLModelProject *result, NSError *error) {
        if (error) {
            NSLog(@"error getDetailForProject: %@",error.description);
            [_HUD hide:YES];
        }else {
            _projectData = result;
            [self.navigationItem setTitle:_projectData.name];

            // load issues
            [OZLNetwork getIssueListForProject:_projectData.index withParams:_issueListOption andBlock:^(NSArray *result, NSError *error) {
                if (error) {
                    NSLog(@"error getIssueListForProject: %@",error.description);
                }else {
                    _issuesList = [[NSMutableArray alloc] initWithArray: result];
                    [_issuesTableview reloadData];
                }
                [_HUD hide:YES];
            }];
        }
    }];
}

-(void)loadIssueRelatedData
{
    _issueListOption = [[NSMutableDictionary alloc] init];

    OZLSingleton* singleton = [OZLSingleton sharedInstance];
    if (singleton.userList != nil) {
        _trackerList = singleton.trackerList;
        _statusList = singleton.statusList;
        _userList = singleton.userList;
        _priorityList = singleton.priorityList;
        _timeEntryActivityList = singleton.timeEntryActivityList;
        [self loadProjectDetail];
    }else {
        static int doneCount = 0;
        const int totalCount = 5;
        [OZLNetwork getTrackerListWithParams:nil andBlock:^(NSArray *result, NSError *error) {
            if (!error) {
                _trackerList = result;
                singleton.trackerList = _trackerList;
            }else {
                NSLog(@"get tracker list error : %@",error.description);
            }
            doneCount ++;
            if (doneCount == totalCount) {
                [self loadProjectDetail];
                doneCount = 0;
            }
        }];

        [OZLNetwork getIssueStatusListWithParams:nil andBlock:^(NSArray *result, NSError *error) {
            if (!error) {
                _statusList = result;
                singleton.statusList = _statusList;
            }else {
                NSLog(@"get issue status list error : %@",error.description);
            }
            doneCount ++;
            if (doneCount == totalCount) {
                [self loadProjectDetail];
                doneCount = 0;
            }
        }];
        [OZLNetwork getPriorityListWithParams:nil andBlock:^(NSArray *result, NSError *error) {
            if (!error) {
                _priorityList = result;
                singleton.priorityList = _priorityList;
            }else {
                NSLog(@"get priority list error : %@",error.description);
            }
            doneCount ++;
            if (doneCount == totalCount) {
                [self loadProjectDetail];
                doneCount = 0;
            }
        }];
        [OZLNetwork getUserListWithParams:nil andBlock:^(NSArray *result, NSError *error) {
            if (!error) {
                _userList = result;
                singleton.userList = _userList;
            }else {
                NSLog(@"get user list error : %@",error.description);
            }
            doneCount ++;
            if (doneCount == totalCount) {
                [self loadProjectDetail];
                doneCount = 0;
            }
        }];

        [OZLNetwork getTimeEntryListWithParams:nil andBlock:^(NSArray *result, NSError *error) {
            if (!error) {
                _timeEntryActivityList = result;
                singleton.timeEntryActivityList = _timeEntryActivityList;
            }else {
                NSLog(@"get user list error : %@",error.description);
            }
            doneCount ++;
            if (doneCount == totalCount) {
                [self loadProjectDetail];
                doneCount = 0;
            }
        }];
    }
}


- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(preloadLeft) object:nil];
//    [self performSelector:@selector(preloadLeft) withObject:nil afterDelay:0.3];

}

- (void) preloadLeft {
//    OZLProjectListViewController *c = [[OZLProjectListViewController alloc] initWithNibName:@"OZLProjectListViewController" bundle:nil];
//    [self.revealSideViewController preloadViewController:c
//                                                 forSide:PPRevealSideDirectionLeft
//                                              withOffset:_sideviewOffset];
//    PP_RELEASE(c);
}

- (void) showProjectList {
    [self.navigationController popViewControllerAnimated:YES];

//    OZLProjectListViewController *c = [[OZLProjectListViewController alloc] initWithNibName:@"OZLProjectListViewController" bundle:nil];
//    UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:c];
//    [self.revealSideViewController pushViewController:navigationController onDirection:PPRevealSideDirectionLeft withOffset:_sideviewOffset animated:YES];
//    PP_RELEASE(c);
}

- (IBAction)changeSideViewOffset:(int)offset {
    _sideviewOffset = offset;
    [self.revealSideViewController changeOffset:_sideviewOffset
                                   forDirection:PPRevealSideDirectionRight];
    [self.revealSideViewController changeOffset:_sideviewOffset
                                   forDirection:PPRevealSideDirectionLeft];
    [self.revealSideViewController changeOffset:_sideviewOffset
                                   forDirection:PPRevealSideDirectionTop];
    [self.revealSideViewController changeOffset:_sideviewOffset
                                   forDirection:PPRevealSideDirectionBottom];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setIssuesTableview:nil];
    [super viewDidUnload];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [_issuesList count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellidentifier = [NSString stringWithFormat:@"issue_cell_id"];
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellidentifier];
    }
    OZLModelIssue* issue = [_issuesList objectAtIndex:indexPath.row];
    cell.textLabel.text = issue.subject;
    cell.detailTextLabel.text = issue.description;
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        _HUD.labelText = @"Deleting Issue...";
        _HUD.detailsLabelText = @"";
        _HUD.mode = MBProgressHUDModeIndeterminate;
        [_HUD show:YES];
        [OZLNetwork deleteIssue:[[_issuesList objectAtIndex:indexPath.row] index] withParams:nil andBlock:^(BOOL success, NSError *error) {
            if (error) {
                NSLog(@"failed to delete issue");
                _HUD.mode = MBProgressHUDModeText;
                _HUD.labelText = @"Connection Failed";
                _HUD.detailsLabelText = @" Please check network connection or your account setting.";
                [_HUD hide:YES afterDelay:3];
            }else {
                [_issuesList removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [_HUD hide:YES];
            }
        }];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //OZLIssueDetailViewController* detail = [[OZLIssueDetailViewController alloc] initWithNibName:@"OZLIssueDetailViewController" bundle:nil];
    UIStoryboard *tableViewStoryboard = [UIStoryboard storyboardWithName:@"OZLIssueDetailViewController" bundle:nil];
    OZLIssueDetailViewController* detail = [tableViewStoryboard instantiateViewControllerWithIdentifier:@"OZLIssueDetailViewController"];
    [detail setIssueData:[_issuesList objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:detail animated:YES];
}

- (IBAction)onNewIssue:(id)sender {
    if (![OZLSingleton isUserLoggedIn] ) {
        _HUD.mode = MBProgressHUDModeText;
        _HUD.labelText = @"No available";
        _HUD.detailsLabelText = @"You need to log in to do this.";
        [_HUD show:YES];
        [_HUD hide:YES afterDelay:2];
        return;
    }
    //OZLIssueCreateOrUpdateViewController* creator = [[OZLIssueCreateOrUpdateViewController alloc] initWithNibName:@"OZLIssueCreateOrUpdateViewController" bundle:nil];
    UIStoryboard *tableViewStoryboard = [UIStoryboard storyboardWithName:@"OZLIssueCreateOrUpdateViewController" bundle:nil];
    OZLIssueCreateOrUpdateViewController* creator = [tableViewStoryboard instantiateViewControllerWithIdentifier:@"OZLIssueCreateOrUpdateViewController"];
    [creator setParentProject:_projectData];
    [creator setViewMode:OZLIssueInfoViewModeCreate];
    //[self.navigationController presentModalViewController:creator animated:YES];
    [self.navigationController pushViewController:creator animated:YES];
}

- (IBAction)onSortSetting:(id)sender {
    OZLIssueFilterViewController* filter = [[OZLIssueFilterViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:filter animated:YES];
}

- (IBAction)onShowInfo:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"OZLProjectInfoViewController" bundle:nil];
    OZLProjectInfoViewController* detail = [storyboard instantiateViewControllerWithIdentifier:@"OZLProjectInfoViewController"];
    [detail setProjectData:_projectData];
    [detail setViewMode:OZLProjectInfoViewModeDisplay];
    [self.navigationController pushViewController:detail animated:YES];
}

-(void)editIssueList:(id)sender
{
    if (![OZLSingleton isUserLoggedIn] ) {
        _HUD.mode = MBProgressHUDModeText;
        _HUD.labelText = @"No available";
        _HUD.detailsLabelText = @"You need to log in to do this.";
        [_HUD show:YES];
        [_HUD hide:YES afterDelay:2];
        return;
    }
    [_issuesTableview setEditing:YES animated:YES];
    self.navigationItem.rightBarButtonItem = _doneBtn;

}

-(void)editIssueListDone:(id)sender
{
    [_issuesTableview setEditing:NO animated:YES];
    self.navigationItem.rightBarButtonItem = _editBtn;
}
@end
