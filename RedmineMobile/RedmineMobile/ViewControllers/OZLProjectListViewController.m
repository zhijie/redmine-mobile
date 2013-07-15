//
//  OZLProjectListViewController.m
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

#import "OZLProjectListViewController.h"
#import "PPRevealSideViewController.h"
#import "OZLProjectViewController.h"
#import "OZLAccountViewController.h"
#import "OZLNetwork.h"
#import "OZLModelProject.h"
#import "MBProgressHUD.h"

@interface OZLProjectListViewController (){
    NSMutableArray* _projectList;
	MBProgressHUD * _HUD;
}

@end

@implementation OZLProjectListViewController

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
    _projectsTableview.delegate = self;
    _projectsTableview.dataSource = self;

    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:_HUD];
	_HUD.labelText = @"Refreshing...";
}

-(void) viewWillAppear:(BOOL)animated
{
//    if (_needRefresh) {
        _needRefresh = NO;

        [_HUD show:YES];
        // refresh project list
        [OZLNetwork getProjectListWithParams:nil andBlock:^(NSArray *result, NSError *error) {
            NSLog(@"respond:%@",result.description);
            _projectList = [[NSMutableArray alloc] initWithArray: result];
            [_projectsTableview reloadData];
            [_HUD hide:YES];
        }];
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showProjectView:(OZLModelProject*)project
{

    OZLProjectViewController *c = [[OZLProjectViewController alloc] initWithNibName:@"OZLProjectViewController" bundle:nil];
    [c setProjectData:project];
    UINavigationController *n = [[UINavigationController alloc] initWithRootViewController:c];
    [self.revealSideViewController popViewControllerWithNewCenterController:n
                                                                   animated:YES];
}

- (IBAction)showAccountView:(id)sender {
    OZLAccountViewController *c = [[OZLAccountViewController alloc] initWithNibName:@"OZLAccountViewController" bundle:nil];
    UINavigationController *n = [[UINavigationController alloc] initWithRootViewController:c];
    [self.revealSideViewController popViewControllerWithNewCenterController:n
                                                                   animated:YES];
}
- (void)viewDidUnload {
    [self setProjectsTableview:nil];
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
    return [_projectList count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellidentifier = [NSString stringWithFormat:@"project_cell_id"];
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellidentifier];
    }
    OZLModelProject* project = [_projectList objectAtIndex:indexPath.row];
    cell.textLabel.text = project.name;
    cell.detailTextLabel.text = project.description;
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self showProjectView:[_projectList objectAtIndex:indexPath.row]];
    
}

@end
