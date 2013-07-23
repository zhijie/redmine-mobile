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
	_HUD.labelText = @"Refreshing...";
    
    [self.navigationItem setTitle:_issueData.subject];
}


-(void) viewWillAppear:(BOOL)animated
{
    [_HUD show:YES];
    // refresh journal list
    [OZLNetwork getJournalListForIssue:_issueData.index withParams:nil andBlock:^(NSArray *result, NSError *error) {
        NSLog(@"respond:%@",result.description);
        _journalList = [[NSMutableArray alloc] initWithArray: result];
        [self.tableView reloadData];
        [_HUD hide:YES];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _journalList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"timeEntryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    if (!cell) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    OZLModelIssueJournal* journal = [_journalList objectAtIndex:indexPath.row];
    [cell.textLabel setText: journal.user.name];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"number of change: %d",journal.detailArray.count]];
    return cell;
}

@end
