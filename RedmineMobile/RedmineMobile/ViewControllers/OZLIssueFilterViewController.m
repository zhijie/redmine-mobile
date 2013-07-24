//
//  OZLIssueFilterViewController.m
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

#import "OZLIssueFilterViewController.h"
#import "OZLSingleton.h"

@interface OZLIssueFilterViewController () {
    NSArray* _cellArray;
    NSArray* _headerArray;
    int _checkedCell[3];

}
@end

@implementation OZLIssueFilterViewController

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

    UIBarButtonItem* cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onCancel:)];
    [self.navigationItem setLeftBarButtonItem:cancelBtn];
    UIBarButtonItem* saveBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(onSave:)];
    [self.navigationItem setRightBarButtonItem:saveBtn];

    _cellArray = @[
                    @[@"Assigned to me",@"Open",@"Reported by me"],
                    @[@"Id", @"Tracker", @"Status", @"Priority", @"Category", @"Asssigned to", @"Fixed Version", @"Start Date", @"Due Date", @"Estimated Date", @"Done", @"Updated on"],
                    @[@"Ascending", @"Descending"]];
    _headerArray = @[@"Filter by", @"Sort by", @""];

    OZLSingleton* singleton =[OZLSingleton sharedInstance];
    _checkedCell[0] = [singleton issueListFilterType];
    _checkedCell[1] = [singleton issueListSortType];
    _checkedCell[2] = [singleton issueListSortAscending];
}

-(void) onCancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) onSave:(id) sender
{

    OZLSingleton* singleton =[OZLSingleton sharedInstance];
    [singleton setIssueListFilterType:_checkedCell[0]];
    [singleton setIssueListSortType:_checkedCell[1]];
    [singleton setIssueListSortAscending:_checkedCell[2]];

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _cellArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [[_cellArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"OZLIssueFilterViewControllerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (_checkedCell[indexPath.section] == indexPath.row ) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.text = [[_cellArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_headerArray objectAtIndex:section];
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _checkedCell[indexPath.section] = indexPath.row;

    [self.tableView reloadData];
}

@end
