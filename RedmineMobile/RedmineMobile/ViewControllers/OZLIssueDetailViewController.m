//
//  OZLIssueDetailViewController.m
//  RedmineMobile
//
//  Created by lizhijie on 7/17/13.

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

#import "OZLIssueDetailViewController.h"
#import "OZLIssueHistoryViewController.h"
#import "OZLIssueLogtimeViewController.h"
#import "OZLSingleton.h"
#import "OZLIssueCreateOrUpdateViewController.h"
#import "MBProgressHUD.h"

@interface OZLIssueDetailViewController () {
    MBProgressHUD * _HUD;
    
}

@end

@implementation OZLIssueDetailViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _timeEntryActivityList = [[OZLSingleton sharedInstance] timeEntryActivityList];

    _subject.text = _issueData.subject;
    _description.text = _issueData.description;
    _progressbar.progress = _issueData.doneRatio/100;
    _status.text = _issueData.status.name ;
    _priority.text = _issueData.priority.name;
    _author.text = _issueData.author.login;
    _assignedTo.text = _issueData.assignedTo.login;
    _startTime.text = _issueData.startDate;
    _dueTime.text = _issueData.dueDate;


    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:_HUD];
	_HUD.labelText = @"Loading...";
    
    [self.navigationItem setTitle:@"Issue Details"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:{//history
                OZLIssueHistoryViewController* history = [[OZLIssueHistoryViewController alloc] init];
                [history setIssueData:_issueData];
                [self.navigationController pushViewController:history animated:YES];
            }break;
            case 1:{// add sub task
                if (![OZLSingleton isUserLoggedIn] ) {
                    _HUD.mode = MBProgressHUDModeText;
                    _HUD.labelText = @"No available";
                    _HUD.detailsLabelText = @"You need to log in to do this.";
                    [_HUD show:YES];
                    [_HUD hide:YES afterDelay:2];
                    return;
                }
                UIStoryboard *tableViewStoryboard = [UIStoryboard storyboardWithName:@"OZLIssueCreateOrUpdateViewController" bundle:nil];
                OZLIssueCreateOrUpdateViewController* creator = [tableViewStoryboard instantiateViewControllerWithIdentifier:@"OZLIssueCreateOrUpdateViewController"];
                [creator setParentIssue:_issueData];
                [self.navigationController pushViewController:creator animated:YES];
            }break;
            case 2:{//logtime
                if (![OZLSingleton isUserLoggedIn] ) {
                    _HUD.mode = MBProgressHUDModeText;
                    _HUD.labelText = @"No available";
                    _HUD.detailsLabelText = @"You need to log in to do this.";
                    [_HUD show:YES];
                    [_HUD hide:YES afterDelay:2];
                    return;
                }
                UIStoryboard *tableViewStoryboard = [UIStoryboard storyboardWithName:@"OZLIssueLogtimeViewController" bundle:nil];
                OZLIssueLogtimeViewController* creator = [tableViewStoryboard instantiateViewControllerWithIdentifier:@"OZLIssueLogtimeViewController"];
                [creator setIssueData:_issueData];
                [self.navigationController pushViewController:creator animated:YES];
            }break;
            case 3:{ // update
                if (![OZLSingleton isUserLoggedIn] ) {
                    _HUD.mode = MBProgressHUDModeText;
                    _HUD.labelText = @"No available";
                    _HUD.detailsLabelText = @"You need to log in to do this.";
                    [_HUD show:YES];
                    [_HUD hide:YES afterDelay:2];
                    return;
                }
                UIStoryboard *tableViewStoryboard = [UIStoryboard storyboardWithName:@"OZLIssueCreateOrUpdateViewController" bundle:nil];
                OZLIssueCreateOrUpdateViewController* creator = [tableViewStoryboard instantiateViewControllerWithIdentifier:@"OZLIssueCreateOrUpdateViewController"];
                [creator setIssueData:_issueData];
                [creator setViewMode:OZLIssueInfoViewModeEdit];
                [self.navigationController pushViewController:creator animated:YES];
            }break;
            default:
                break;
        }
    }
}

- (void)viewDidUnload {
    [self setProgressbar:nil];
    [self setStatus:nil];
    [self setPriority:nil];
    [self setAuthor:nil];
    [self setAssignedTo:nil];
    [self setStartTime:nil];
    [self setDueTime:nil];
    [super viewDidUnload];
}
@end
