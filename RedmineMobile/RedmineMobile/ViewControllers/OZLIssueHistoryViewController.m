//
//  OZLIssueHistoryViewController.m
//  RedmineMobile
//
//  Created by lizhijie on 7/22/13.

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


#import "OZLIssueHistoryViewController.h"
#import "MBProgressHUD.h"
#import "OZLNetwork.h"
#import "OZLModelIssueJournal.h"
#import "OZLModelIssueJournalDetail.h"
#import "OZLSingleton.h"

@interface OZLIssueHistoryViewController () {
    MBProgressHUD* _HUD;
    NSMutableArray* _journalList;
}

@end

@implementation OZLIssueHistoryViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:_HUD];
    
    [self.navigationItem setTitle:@"History"];
}


-(void) viewWillAppear:(BOOL)animated
{
	_HUD.labelText = @"Refreshing...";
    _HUD.detailsLabelText = @"";
    _HUD.mode = MBProgressHUDModeIndeterminate;
    [_HUD show:YES];
    // refresh journal list
    [OZLNetwork getJournalListForIssue:_issueData.index withParams:nil andBlock:^(NSArray *result, NSError *error) {
        if (error) {
            NSLog(@"getJournalListForIssue error: %@",error.description);
            _HUD.mode = MBProgressHUDModeText;
            _HUD.labelText = @"Connection Failed";
            _HUD.detailsLabelText = @" Please check network connection or your account setting.";
            [_HUD hide:YES afterDelay:3];
        }else {
            NSLog(@"respond:%@",result.description);
            _journalList = [[NSMutableArray alloc] initWithArray: result];
            [self.tableView reloadData];
            [_HUD hide:YES];
        }
    }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _journalList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[_journalList objectAtIndex:section] detailArray] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"timeEntryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    if (!cell) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = [UIColor darkTextColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    OZLModelIssueJournalDetail* detail = [[[_journalList objectAtIndex:indexPath.section] detailArray] objectAtIndex:indexPath.row];
    NSString* content;
    if ([detail.name isEqualToString:@"done_ratio"]) {
        content = [NSString stringWithFormat:@"Done changed from %@ to %@",detail.oldValue,detail.freshValue];
    }else if([detail.name isEqualToString:@"tracker_id"]){
        OZLModelTracker* old = [[OZLSingleton sharedInstance] trackerWithId:[detail.oldValue intValue]];
        OZLModelTracker* new = [[OZLSingleton sharedInstance] trackerWithId:[detail.freshValue intValue]];
        content = [NSString stringWithFormat:@"Tracker changed from %@ to %@", old.name, new.name];

    }else if([detail.name isEqualToString:@"priority_id"]) {
        OZLModelIssuePriority* old = [[OZLSingleton sharedInstance] issuePriorityWithId:[detail.oldValue intValue]];
        OZLModelIssuePriority* new = [[OZLSingleton sharedInstance] issuePriorityWithId:[detail.freshValue intValue]];
        content = [NSString stringWithFormat:@"Priority changed from %@ to %@", old.name, new.name];

    }else if([detail.name isEqualToString:@"status_id"]) {
        OZLModelIssueStatus* old = [[OZLSingleton sharedInstance] issueStatusWithId:[detail.oldValue intValue]];
        OZLModelIssueStatus* new = [[OZLSingleton sharedInstance] issueStatusWithId:[detail.freshValue intValue]];
        content = [NSString stringWithFormat:@"Status changed from %@ to %@", old.name, new.name];
    }else if([detail.name isEqualToString:@"assigned_to_id"]) {
        OZLModelUser* new = [[OZLSingleton sharedInstance] userWithId:[detail.freshValue intValue]];
        content = [NSString stringWithFormat:@"Assignee set to %@", new.name];
    }else if([detail.name isEqualToString:@"estimated_hours"]){
        content = [NSString stringWithFormat:@"Estimated time changed from %.2f to %.2f", [detail.oldValue floatValue], [detail.freshValue floatValue]];
    }else if([detail.name isEqualToString:@"subject"]) {
        //content = [NSString stringWithFormat:@"Subject changed from %@ to %@",detail.oldValue, detail.freshValue];
        content = [NSString stringWithFormat:@"Subject changed to %@",detail.freshValue];
    }

    [cell.textLabel setText:content];
    return cell;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc ] initWithFrame:CGRectMake(0, 0, 320, 44)];
    view.backgroundColor = [UIColor colorWithHue:0.6 saturation:0.33 brightness:0.65 alpha:0.7];
    
    OZLModelIssueJournal* journal = [_journalList objectAtIndex:section];
    UILabel* nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, 160, 20)];
    [nameLabel setText: journal.user.name];
    nameLabel.font = [UIFont systemFontOfSize:12];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = [UIColor darkTextColor];
    [view addSubview:nameLabel];

    UILabel* timeLable = [[UILabel alloc] initWithFrame:CGRectMake(160, 2, 160, 20)];
    [timeLable setText: journal.createdOn];
    timeLable.font = [UIFont systemFontOfSize:12];
    timeLable.backgroundColor = [UIColor clearColor];
    timeLable.textColor = [UIColor lightTextColor];
    [view addSubview:timeLable];

    UILabel* notesLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 24, 300, 20)];
    [notesLable setText: journal.notes];
    notesLable.font = [UIFont systemFontOfSize:12];
    notesLable.backgroundColor = [UIColor clearColor];
    notesLable.textColor = [UIColor lightTextColor];
    [view addSubview:notesLable];

    return view;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0;
}
@end
