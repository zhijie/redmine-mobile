//
//  OZLIssueFilterViewController.m
//  RedmineMobile
//
//  Created by lizhijie on 7/17/13.
//  Copyright (c) 2013 Lee Zhijie. All rights reserved.
//

#import "OZLIssueFilterViewController.h"

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

    _checkedCell[0] = 0;
    _checkedCell[1] = 0;
    _checkedCell[2] = 0;
}

-(void) onCancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) onSave:(id) sender
{
    
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
