//
//  OZLProjectInfoViewController.m
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

#import "OZLProjectInfoViewController.h"
#import "MBProgressHUD.h"
#import "OZLNetwork.h"
#import "MLTableAlert.h"

@interface OZLProjectInfoViewController () {
    MBProgressHUD * _HUD;
    
}

@end

@implementation OZLProjectInfoViewController

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


    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:_HUD];
	_HUD.labelText = @"Loading...";

    if (_viewMode == OZLProjectInfoViewModeCreate) {
        [self prepareViewForCreate];
    }else if(_viewMode == OZLProjectInfoViewModeDisplay) {
        [self prepareViewForDisplay];
    }else if(_viewMode == OZLProjectInfoViewModeEdit) {
        
    }
}

-(void)prepareViewForDisplay
{
    self.navigationItem.title = @"Project Details";

    _name.userInteractionEnabled = NO;
    _identifier.userInteractionEnabled = NO;
    _homepageUrl.userInteractionEnabled = NO;
    _description.userInteractionEnabled = NO;

    _name.text = _projectData.name;
    _identifier.text = _projectData.identifier;
    _homepageUrl.text = _projectData.homepage;
    _description.text = _projectData.description;
}

-(void)prepareViewForCreate
{

    UIBarButtonItem* cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onCancel:)];
    [self.navigationItem setLeftBarButtonItem:cancelBtn];
    UIBarButtonItem* saveBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(onSave:)];
    [self.navigationItem setRightBarButtonItem:saveBtn];

    self.navigationItem.title = @"New Project";

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onCancel:(id)sender {

    if (_viewMode == OZLProjectInfoViewModeCreate) {
        [self.navigationController dismissModalViewControllerAnimated:YES];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)onSave:(id)sender {

    if (_name.text.length == 0) {
        _HUD.mode = MBProgressHUDModeText;
        _HUD.labelText = @"Project name can not be empty.";
        [_HUD show:YES];
        [_HUD hide:YES afterDelay:1];
        
        return;
    }
    if (_identifier.text.length == 0) {
        _HUD.mode = MBProgressHUDModeText;
        _HUD.labelText = @"Project identifier can not be empty.";
        [_HUD show:YES];
        [_HUD hide:YES afterDelay:1];
        return;
    }
    

    OZLModelProject* projectData = [[OZLModelProject alloc] init];
    projectData.name = _name.text;
    projectData.identifier = _identifier.text;
    //TODO: is_public is not processed yet

    projectData.description = _description.text;
    projectData.homepage = _homepageUrl.text;
    if (_parentProject) {
        projectData.parentId = _parentProject.index;
    }

    _HUD.mode = MBProgressHUDModeIndeterminate;
    _HUD.labelText = @"Creating Project...";
    [_HUD show:YES];
    [OZLNetwork createProject:projectData withParams:nil andBlock:^(BOOL success, NSError *error) {
        if (error) {
            NSLog(@"create project error: %@",error.description);
            _HUD.mode = MBProgressHUDModeText;
            _HUD.labelText = @"Connection Failed";
            _HUD.detailsLabelText = @" Please check network connection or your account setting.";
            [_HUD hide:YES afterDelay:3];

        }else {
            [_HUD hide:YES];
            [self onCancel:nil];
        }
    }];
}

- (void)viewDidUnload {
    [self setName:nil];
    [self setIdentifier:nil];
    [self setHomepageUrl:nil];
    [self setDescription:nil];
    [super viewDidUnload];
}

#pragma mark tableview datasource

#pragma mark tableview delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0 && indexPath.row == 4) {//parent project
        // create the alert
        MLTableAlert* tableAlert = [MLTableAlert tableAlertWithTitle:@"Parent Project" cancelButtonTitle:@"Cancel" numberOfRows:^NSInteger (NSInteger section)
                                      {
                                          return  _projectList.count + 1;
                                      }
                                                              andCells:^UITableViewCell* (MLTableAlert *anAlert, NSIndexPath *indexPath)
                                      {
                                          static NSString *CellIdentifier = @"CellIdentifier";
                                          UITableViewCell *cell = [anAlert.table dequeueReusableCellWithIdentifier:CellIdentifier];
                                          if (cell == nil)
                                              cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

                                          if (indexPath.row == 0) {
                                              cell.textLabel.text = @"None";
                                          }else {
                                              cell.textLabel.text = [[_projectList objectAtIndex:indexPath.row - 1] name];
                                          }
                                          return cell;
                                      }];

        // Setting custom alert height
        tableAlert.height = 350;

        // configure actions to perform
        [tableAlert configureSelectionBlock:^(NSIndexPath *selectedIndex){
            UITableViewCell* parentCell = [self.tableView cellForRowAtIndexPath:indexPath];
            if (selectedIndex.row == 0) {
                _parentProject = nil;
                parentCell.detailTextLabel.text = @"None";
            }else {
                _parentProject = [_projectList objectAtIndex:selectedIndex.row - 1];
                parentCell.detailTextLabel.text = _parentProject.name;
            }
            [parentCell.detailTextLabel sizeToFit];
        } andCompletionBlock:^{
            
        }];
        
        // show the alert
        [tableAlert show];
    }
}
@end
